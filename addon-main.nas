var CPDLC = {
    new: func () {
        return {
            parents: [CPDLC],
            downlinkNode: props.globals.getNode('/acars/downlink', 1),
            uplinkNode: props.globals.getNode('/acars/uplink', 1),
            statusNode: props.globals.getNode('/acars/status-text', 1),


            selectedMessageNode: props.globals.getNode('/cpdlc/selected-message', 1),
            selectedMessageIDNode: props.globals.getNode('/cpdlc/selected-message-id', 1),
            numOpenNode: props.globals.getNode('/cpdlc/num-open', 1),
            numUnreadNode: props.globals.getNode('/cpdlc/num-unread', 1),
            messagesNode: props.globals.getNode('/cpdlc/messages', 1),
            unreadNode: props.globals.getNode('/cpdlc/unread', 1),
            openNode: props.globals.getNode('/cpdlc/open', 1),
            historyNode: props.globals.getNode('/cpdlc/history', 1),
        };
    },

    addItem: func (node, val) {
        node.addChild('item').setValue(val);
    },

    removeItem: func (node, val) {
        var numRemoved = 0;
        foreach (var c; node.getChildren('item')) {
            if (c.getValue() == val) {
                c.remove();
                numRemoved += 1;
            }
        }
        return numRemoved;
    },

    parseCPDLC: func (str) {
        # /data2/654/3/NE/LOGON ACCEPTED
        var result = split('/', string.uc(str));
        if (result[0] != '') {
            debug.dump('PARSER ERROR 10: expected leading slash in ' ~ str);
            return nil;
        }
        if (result[1] != 'DATA2') {
            debug.dump('PARSER ERROR 11: expected `data2` in ' ~ str);
            return nil;
        }
        var min = result[2];
        var mrn = result[3];
        var ra = result[4];
        var message = subvec(result, 5);
        return {
            min: min,
            mrn: mrn,
            ra: ra,
            message: message,
        }
    },

    packCPDLC: func (min, mrn, ra, message) {
        if (typeof(message) == 'vector') {
            message = string.join('/', message);
        }
        return string.join('/', ['', 'data2', min, mrn, ra, message]);
    },

    sendCPDLC: func (to, mrn, ra, message) {
        var min = getprop('/cpdlc/next-min');
        setprop('/cpdlc/next-min', min + 1);
        var cpdlc = me.packCPDLC(min, mrn, ra, message);
        globals.acars.send(to, 'cpdlc', cpdlc);
    },


    cpdlcHandleUplink: func (msg) {
        var msgID = me.makeMessageID(msg);
        var m = msg.cpdlc.message;
        var vars = [];
        if (typeof(m) == 'vector') { m = m[0]; }
        m = string.uc(m);
        if (m == 'LOGON ACCEPTED') {
            setprop('/cpdlc/last-station', getprop('/cpdlc/current-station'));
            setprop('/cpdlc/last-station-name', getprop('/cpdlc/current-station-name'));
            setprop('/cpdlc/current-station', '');
            setprop('/cpdlc/current-station-name', msg.from or '');
        }
        elsif (m == 'LOGOFF') {
            setprop('/cpdlc/last-station', getprop('/cpdlc/current-station'));
            setprop('/cpdlc/last-station-name', getprop('/cpdlc/current-station-name'));
            setprop('/cpdlc/current-station', '');
            setprop('/cpdlc/current-station-name', '');
        }
        elsif (startswith(m, 'HANDOVER') and string.scanf(m, 'HANDOVER @%4s', vars)) {
            me.cpdlcRequestLogon(vars[0]);
        }
        elsif (startswith(m, 'CURRENT ATC UNIT') and (string.scanf(m, 'CURRENT ATC UNIT@_@%4s@_@%', vars) != 0)) {
            var currentStation = vars[0];
            var stationName = substr(m, size('CURRENT ATC UNIT@_@@_@') + size(currentStation));
            if (getprop('/cpdlc/current-station') == currentStation) {
                setprop('/cpdlc/current-station-name', stationName);
            }
        }
        else {
            debug.dump('UNKNOWN UPLINK', m);
        }

        if (msg.cpdlc.ra == 'NE') {
            # no response required
        }
        else {
            # response required, add to open dialog heads.
            me.addItem(me.openNode, msgID);
            me.numOpenNode.increment();
        }

        if (msg.cpdlc.mrn != '') {
            var parentID = me.makeMessageID(msg.to, 'C', msg.cpdlc.mrn);
            var parent = me.getMessage(parentID);
            if (parent != nil and me.closesDialog(parent.cpdlc.ra, m)) {
                var numRemoved = me.removeItem(me.openNode, parentID);
                me.numOpenNode.decrement(numRemoved);
            }
        }
    },

    cpdlcHandleDownlink: func (msg) {
        var msgID = me.makeMessageID(msg);
        var m = msg.cpdlc.message;
        if (typeof(m) == 'vector') { m = m[0]; }
        m = string.uc(m);

        if (msg.cpdlc.mrn != '') {
            var parentID = me.makeMessageID(msg.to, 'C', msg.cpdlc.mrn);
            var parent = me.getMessage(parentID);
            if (parent != nil and me.closesDialog(parent.cpdlc.ra, m)) {
                var numRemoved = me.removeItem(me.openNode, parentID);
                me.numOpenNode.decrement(numRemoved);
            }
        }
        if (msg.cpdlc.ra == 'Y') {
            me.addItem(me.openNode, msgID);
            me.numOpenNode.increment();
        }
        me.selectMessage(msgID);
    },

    getMessage: func(msgID) {
        if (msgID == nil) {
            return nil;
        }
        var node = me.messagesNode.getNode(msgID);
        if (node == nil) {
            return nil;
        }
        else {
            return me.messageFromNode(node);
        }
    },

    putMessage: func (msg) {
        var serial = getprop('/cpdlc/next-serial');
        setprop('/cpdlc/next-serial', serial + 1);
        msg.serial = serial;

        var msgID = me.makeMessageID(msg);
        var node = me.messagesNode.getNode(msgID, 1);
        me.messageToNode(node, msg);
        return msgID;
    },

    selectMessage: func (msgID) {
        var msg = me.getMessage(msgID);
        var node = me.selectedMessageNode;
        if (msg == nil) {
            node.setValues({
                'id': '',
                cpdlc: {
                    message: '',
                    min: '',
                    mrn: '',
                    ra: '',
                },
                from: '',
                to: '',
                dir: '',
                packet: '',
                status: '',
                type: '',
                message: '',
            });
        }
        else {
            node.setValues(msg);
            node.setValue('id', msgID);
            if (msg['cpdlc'] != nil) {
                node.setValue('message', msg.cpdlc.message);
            }
            else {
                node.setValue('message', msg.packet);
            }
        }
        var numRemoved = me.removeItem(me.unreadNode, msgID);
        me.numUnreadNode.decrement(numRemoved);
        me.selectedMessageIDNode.setValue(msgID or '');
    },

    selectFirstOpen: func () {
        if (me.numOpenNode.getValue() == 0) {
            me.select(nil);
            return;
        }
        var msgID = me.openNode.getValue('item');
        me.selectMessage(msgID);
    },

    selectNextOpen: func () {
        var found = 0;
        var selectedID = me.selectedMessageIDNode.getValue();
        if (selectedID == nil or selectedID == '') {
            me.selectFirstOpen();
            return;
        }
        var h = nil;
        foreach (var n; me.openNode.getChildren('item')) {
            h = n.getValue();
            if (found) {
                me.selectMessage(h);
                return;
            }
            if (h == selectedID) {
                found = 1;
            }
        }
    },

    selectPrevOpen: func () {
        var prevID = '';
        var selectedID = me.selectedMessageIDNode.getValue();
        if (selectedID == nil or selectedID == '') {
            me.selectFirstOpen();
            return;
        }
        var h = nil;
        foreach (var n; me.openNode.getChildren('item')) {
            h = n.getValue();
            if (h == selectedID) {
                me.selectMessage(prevID);
                return;
            }
            prevID = h;
        }
    },

    selectFirstUnread: func () {
        if (me.numUnreadNode.getValue() == 0) {
            me.select(nil);
            return;
        }
        var msgID = me.unreadNode.getValue('item');
        me.selectMessage(msgID);
    },

    selectNextUnread: func () {
        var found = 0;
        var selectedID = me.selectedMessageIDNode.getValue();
        if (selectedID == nil or selectedID == '') {
            me.selectFirstUnread();
            return;
        }
        var h = nil;
        foreach (var n; me.unreadNode.getChildren('item')) {
            h = n.getValue();
            if (found) {
                me.selectMessage(h);
                return;
            }
            if (h == selectedID) {
                found = 1;
            }
        }
    },

    selectPrevUnread: func () {
        var prevID = '';
        var selectedID = me.selectedMessageIDNode.getValue();
        if (selectedID == nil or selectedID == '') {
            me.selectFirstUnread();
            return;
        }
        var h = nil;
        foreach (var n; me.unreadNode.getChildren('item')) {
            h = n.getValue();
            if (h == selectedID) {
                me.selectMessage(prevID);
                return;
            }
            prevID = h;
        }
    },

    cpdlcRequestLogon: func (station=nil) {
        if (station == nil) {
            station = getprop('/cpdlc/logon-station');
        }
        me.sendCPDLC(station, '', 'Y', 'REQUEST LOGON');
    },

    cpdlcLogoff: func (station=nil) {
        if (station == nil) {
            station = getprop('/cpdlc/current-station');
        }
        me.sendCPDLC(station, '', 'N', 'LOGOFF');
        setprop('/cpdlc/last-station', getprop('/cpdlc/current-station'));
        setprop('/cpdlc/last-station-name', getprop('/cpdlc/current-station-name'));
        setprop('/cpdlc/current-station', '');
        setprop('/cpdlc/current-station-name', '');
    },

    cpdlcReply: func (msgID, ra, reply) {
        var msg = msgID;
        if (typeof(msgID) == 'scalar') {
            msg = me.getMessage(msgID);
        }
        if (msg == nil) {
            debug.warn('Message for reply not found: ' ~ msgID);
        }
        if (msg.dir != 'uplink') {
            debug.warn('Cannot reply to downlink messages');
            return;
        }
        if (me.closesDialog(msg.cpdlc.ra, reply)) {
            var numRemoved = me.removeItem(me.openNode, msgID);
            me.numOpenNode.decrement(numRemoved);
        }
        me.sendCPDLC(msg.from, msg.cpdlc.min, ra, reply);
    },

    closesDialog: func(ra, reply) {
        if (ra == 'WU') {
            return (startswith(reply, 'WILCO') or startswith(reply, 'UNABLE'));
        }
        elsif (ra == 'AN') {
            return (startswith(reply, 'AFFIRM') or startswith(reply, 'NEGATIVE'));
        }
        elsif (ra == 'R') {
            return (startswith(reply, 'ROGER') or startswith(reply, 'UNABLE'));
        }
        elsif (ra == 'Y') {
            return (!startswith(reply, 'STANDBY'));
        }
        elsif (ra == 'N' or ra == 'NE') {
            # Anything closes an 'N' or 'NE' dialog, though this should never
            # happen, since they should also auto-close.
            return 1;
        }
        else {
            # This should never happen either, but let's catch it.
            debug.warn('Invalid RA value: ' ~ ra);
            return 0;
        }
    },

    cpdlcRoger: func (msg) { me.cpdlcReply(msg, 'N', 'ROGER'); },
    cpdlcWilco: func (msg) { me.cpdlcReply(msg, 'N', 'WILCO'); },
    cpdlcAffirmative: func (msg) { me.cpdlcReply(msg, 'N', 'AFFIRMATIVE'); },
    cpdlcNegative: func (msg, extraText=nil) {
        var text = 'NEGATIVE';
        if (extraText != nil) { text = text ~ ', ' ~ extraText; }
        me.cpdlcReply(msg, 'N', text);
    },
    cpdlcStandby: func (msg) { me.cpdlcReply(msg, 'N', 'STANDBY'); },
    cpdlcUnable: func (msg, dueTo=nil, extraText=nil) {
        var text = 'UNABLE';
        if (dueTo != nil) { text = text ~ ' DUE TO ' ~ dueTo; }
        if (extraText != nil) { text = text ~ ', ' ~ extraText; }
        me.cpdlcReply(msg, 'N', text);
    },

    messageFromNode: func(node) {
        var msg = {
                from: node.getValue('from'),
                to: node.getValue('to'),
                type: node.getValue('type'),
                packet: node.getValue('packet'),
                status: node.getValue('status'),
                serial: node.getValue('serial'),
            };
        if (msg.type == 'cpdlc') {
            msg.cpdlc = me.parseCPDLC(msg.packet);
        }
        return msg;
    },

    messageToNode: func(node, msg) {
        node.setValues(msg);
    },

    makeMessageID: func(arg1, arg2=nil, arg3=nil) {
        if (typeof(arg1) == 'scalar' and typeof(arg2) == 'scalar' and typeof(arg3) == 'scalar') {
            return arg1 ~ '-' ~ arg2 ~ '-' ~ arg3;
        }
        elsif (typeof(arg1) == 'hash' and arg2 == nil and arg3 == nil) {
            var msg = arg1;
            if (msg.type == 'cpdlc') {
                return msg.from ~ '-C-' ~ msg.cpdlc.min;
            }
            else {
                return msg.from ~ '-T-' ~ msg.serial;
            }
        }
        else {
            debug.warn('Invalid arguments to makeMessageID');
            return nil;
        }
    },

    handleDownlink: func() {
        var msg = me.messageFromNode(me.downlinkNode);
        msg.dir = 'downlink';
        if (msg.status == 'sending') return;

        if (msg.status == 'error') {
            return;
        }

        var msgID = me.putMessage(msg);

        if (msg.type == 'cpdlc') {
            me.cpdlcHandleDownlink(msg);
        }
    },

    handleUplink: func() {
        var msg = me.messageFromNode(me.uplinkNode);
        msg.dir = 'uplink';

        var serial = getprop('/cpdlc/next-serial');
        setprop('/cpdlc/next-serial', serial + 1);
        msg.serial = serial;

        var msgID = me.putMessage(msg);
        me.addItem(me.unreadNode, msgID);
        me.numUnreadNode.increment();

        if (msg.type == 'cpdlc') {
            me.cpdlcHandleUplink(msg);
        }
    },
};

var findMenuNode = func (create=0) {
    var equipmentMenuNode = props.globals.getNode('/sim/menubar/default/menu[5]');
    foreach (var item; equipmentMenuNode.getChildren('item')) {
        if (item.getValue('name') == 'cpdlc') {
            return item;
        }
    }
    if (create) {
        return equipmentMenuNode.addChild('item');
    }
    else {
        return nil;
    }
};

var unload = func(addon) {
    var myMenuNode = findMenuNode();
    if (myMenuNode != nil) {
        myMenuNode.remove();
        fgcommand('reinit', {'subsystem': 'gui'});
    }
};

var main = func(addon) {
    globals.cpdlc = CPDLC.new();
    setlistener('/acars/uplink/status', func { globals.cpdlc.handleUplink(); });
    setlistener('/acars/downlink/status', func { globals.cpdlc.handleDownlink(); });
    var myMenuNode = findMenuNode(1);
    myMenuNode.setValues({
        enabled: 'true',
        name: 'cpdlc',
        label: 'CPDLC',
        binding: {
            'command': 'dialog-show',
            'dialog-name': 'addon-cpdlc-dialog',
        },
    });
    fgcommand('reinit', {'subsystem': 'gui'});
};

var startswith = func (haystack, needle) {
    return (left(haystack, size(needle)) == needle);
};
