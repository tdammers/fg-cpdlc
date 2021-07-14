var CPDLC = {
    # Static fields
    downlinkElems: {
        'ROUTE': [
            [ 'RTED-1',  'REQ DIRECT TO',      'M', 'Y', [ 'REQUEST DIRECT TO', '$POSITION' ] ],
            [ 'RTED-2',  'REQ PROCEDURE',      'M', 'Y', [ 'REQUEST ', '$NAMED_INSTRUCTION' ] ],
            [ 'RTED-3',  'REQ ROUTE',          'M', 'Y', [ 'REQUEST CLEARANCE', '$DEPARTURE_DATA', '$ENROUTE_DATA', '$ARRIVAL_APPROACH_DATA' ] ],
            [ 'RTED-4',  'REQ CLEARANCE',      'M', 'Y', [ 'REQUEST', '$CLEARANCE_TYPE', 'CLEARANCE' ] ],
            [ 'RTED-5',  'POS REPORT',         'M', 'N', [ 'POSITION REPORT', '$POSREP' ] ],
            [ 'RTED-6',  'REQ HEADING',        'M', 'Y', [ 'REQUEST HEADING', '$DEGREES' ] ],
            [ 'RTED-7',  'REQ GROUND TRK',     'M', 'Y', [ 'REQUEST GROUND TRACK', '$DEGREES' ] ],
            [ 'RTED-8',  'WCWE BACK ON ROUTE', 'M', 'Y', [ 'WHEN CAN WE EXPECT BACK ON ROUTE' ] ],
            [ 'RTED-9',  'ASSIGNED ROUTE',     'M', 'N', [ 'ASSIGNED ROUTE', '$DEPARTURE_DATA', '$ENROUTE_DATA', '$ARRIVAL_APPROACH_DATA' ] ],
            [ 'RTED-10', 'ETA',                'M', 'N', [ 'ETA', '$POSITION', 'TIME', '$TIME' ] ],
        ],
        'LATERAL': [
            [ 'LATD-1',  'REQ OFFSET',         'M', 'Y', [ 'REQUEST OFFSET', '$DISTANCE', '$DIRECTION', 'OF ROUTE' ] ],
            [ 'LATD-2',  'REQ WEATHER DEVTN',  'M', 'Y', [ 'REQUEST WEATHER DEVIATION UP TO', '$LATERAL_DEVIATION', 'OF ROUTE' ] ],
            [ 'LATD-3',  'CLEAR OF WEATHER',   'M', 'N', [ 'CLEAR OF WEATHER' ] ],
            [ 'LATD-4',  'BACK ON ROUTE',      'M', 'N', [ 'BACK ON ROUTE' ] ],
            [ 'LATD-5',  'DIVERTING',          'M', 'Y', [ 'DIVERTING TO', '$POSITION', 'VIA', '$ENROUTE_DATA', '$ARRIVAL_APPROACH_DATA' ] ],
            [ 'LATD-6',  'OFFSETTING',         'M', 'Y', [ 'OFFSETTING', '$DISTANCE', '$DIRECTION', 'OF ROUTE' ] ],
            [ 'LATD-7',  'DEVIATING',          'M', 'Y', [ 'DEVIATING', '$LATERAL_DEVIATION', 'OF ROUTE' ] ],
            [ 'LATD-8',  'PASSING',            'M', 'N', [ 'PASSING', '$POSITION' ] ],
        ],
        'LEVEL': [
            [ 'LVLD-1',  'REQ LEVEL',          'M', 'Y', [ 'REQUEST', '$LEVEL' ] ],
            [ 'LVLD-2',  'REQ CLIMB',          'M', 'Y', [ 'REQUEST CLIMB TO', '$LEVEL' ] ],
            [ 'LVLD-3',  'REQ DESCENT',        'M', 'Y', [ 'REQUEST DESCENT TO', '$LEVEL' ] ],
            [ 'LVLD-4',  'REQ LEVEL AT POS',   'M', 'Y', [ 'AT', '$POSITION', 'REQUEST', '$LEVEL' ] ],
            [ 'LVLD-5',  'REQ LEVEL AT TIME',  'M', 'Y', [ 'AT TIME', '$TIME', 'REQUEST', '$LEVEL' ] ],
            [ 'LVLD-6',  'WCWE LOWER',         'M', 'Y', [ 'WHEN CAN WE EXPECT LOWER LEVEL' ] ],
            [ 'LVLD-7',  'WCWE HIGHER',        'M', 'Y', [ 'WHEN CAN WE EXPECT HIGHER LEVEL' ] ],
            [ 'LVLD-8',  'LEAVING',            'M', 'N', [ 'LEAVING', '$LEVEL_SINGLE' ] ],
            [ 'LVLD-9',  'MAINTAINING',        'M', 'N', [ 'MAINTAINING', '$LEVEL_SINGLE' ] ],
            [ 'LVLD-10', 'REACHING BLOCK',     'M', 'N', [ 'REACHING BLOCK', '$LEVEL_SINGLE', 'TO', '$LEVEL_SINGLE' ] ],
            [ 'LVLD-11', 'ASSIGNED LEVEL',     'M', 'N', [ 'ASSIGNED LEVEL', '$LEVEL' ] ],
            [ 'LVLD-12', 'PREFERRED LEVEL',    'M', 'N', [ 'PREFERRED LEVEL', '$LEVEL' ] ],
            [ 'LVLD-13', 'CLIMBING TO',        'M', 'N', [ 'CLIMBING TO', '$LEVEL_SINGLE' ] ],
            [ 'LVLD-14', 'DESCENDING TO',      'M', 'N', [ 'DESCENDING TO', '$LEVEL_SINGLE' ] ],
            [ 'LVLD-15', 'CAN ACCEPT AT TIME', 'M', 'N', [ 'WE CAN ACCEPT', '$LEVEL_SINGLE', 'AT TIME', '$TIME' ] ],
            [ 'LVLD-16', 'CAN ACCEPT AT POS',  'M', 'N', [ 'WE CAN ACCEPT', '$LEVEL_SINGLE', 'AT', '$POSITION' ] ],
            [ 'LVLD-17', 'CANNOT ACCEPT',      'M', 'N', [ 'WE CANNOT ACCEPT', '$LEVEL_SINGLE' ] ],
            [ 'LVLD-18', 'TOP OF DESCENT',     'M', 'N', [ 'TOP OF DESCENT', '$POSITION', 'TIME', '$TIME' ] ],
        ],
        'SPEED': [
            [ 'SPDD-1',  'REQ SPEED',          'M', 'Y', [ 'REQUEST', '$SPEED' ] ],
            [ 'SPDD-2',  'WCWE SPEED',         'M', 'Y', [ 'WHEN CAN WE EXPECT', '$SPEED' ] ],
            [ 'SPDD-3',  'SPEED',              'M', 'N', [ '$SPEED_TYPES', 'SPEED', '$SPEED' ] ],
            [ 'SPDD-4',  'ASSIGNED SPEED',     'M', 'N', [ 'ASSIGNED SPEED', '$SPEED' ] ],
            [ 'SPDD-5',  'CAN ACCEPT AT TIME', 'M', 'N', [ 'WE CAN ACCEPT', '$SPEED', 'AT TIME', '$TIME' ] ],
            [ 'SPDD-6',  'CANNOT ACCEPT',      'M', 'N', [ 'WE CANNOT ACCEPT', '$SPEED' ] ],
        ],
        'ADVISORY': [
            [ 'ADVD-1',  'SQUAWKING',          'M', 'N', [ 'SQUAWKING', '$SSR_CODE' ] ],
            [ 'ADVD-2',  'TRAFFIC',            'M', 'N', [ 'TRAFFIC', '$AIRCRAFT_TYPE', '$TRAFFIC_LOCATION', '$TRAFFIC_VISIBILITY' ] ],
        ],
        'VOICE': [
            [ 'COMD-1',  'REQ VOICE CONTACT',  'M', 'Y', [ 'REQUEST VOICE CONTACT', '$FREQUENCY' ] ],
            [ 'COMD-2',  'RELAY FROM',         'M', 'N', [ 'RELAY FROM', '$AIRCRAFT_IDENTIFICATION', '$RELAYED_TEXT' ] ],
        ],
        'EMERGENCY': [
            [ 'EMGD-1',  'PAN PAN',            'H', 'Y', [ 'PAN PAN PAN' ] ],
            [ 'EMGD-2',  'MAYDAY',             'H', 'Y', [ 'MAYDAY MAYDAY MAYDAY' ] ],
            [ 'EMGD-3',  'FUEL AND SOULS',     'H', 'Y', [ '$REMAINING_FUEL', 'ENDURANCE AND' '$PERSONS_ON_BOARD', 'PERSONS ON BOARD' ] ],
            [ 'EMGD-4',  'CANCEL EMERGENCY',   'H', 'Y', [ 'CANCEL EMERGENCY' ] ],
        ],
    },

    # Methods
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

    sendCPDLC: func (to, mrn, ra, message, done=nil) {
        var min = getprop('/cpdlc/next-min');
        setprop('/cpdlc/next-min', min + 1);
        var cpdlc = me.packCPDLC(min, mrn, ra, message);
        globals.acars.send(to, 'cpdlc', cpdlc, done);
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
            setprop('/cpdlc/current-station', msg.from or '');
            setprop('/cpdlc/current-station-name', msg.from or '');
            setprop('/cpdlc/next-station', '');
            setprop('/cpdlc/next-station-name', '');
            setprop('/cpdlc/logon-status', 'ACCEPTED');
            setprop('/cpdlc/logon-station', '');
        }
        elsif (m == 'LOGOFF') {
            setprop('/cpdlc/last-station', getprop('/cpdlc/current-station'));
            setprop('/cpdlc/last-station-name', getprop('/cpdlc/current-station-name'));
            setprop('/cpdlc/current-station', '');
            setprop('/cpdlc/current-station-name', '');
            setprop('/cpdlc/next-station', '');
            setprop('/cpdlc/next-station-name', '');
        }
        elsif (startswith(m, 'HANDOVER') and string.scanf(m, 'HANDOVER @%4s', vars)) {
            setprop('/cpdlc/next-station', vars[0]);
            setprop('/cpdlc/next-station-name', '');
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
                timestamp: '',
                timestamp4: '',
            });
        }
        else {
            node.setValues(msg);
            node.setValue('id', msgID);
            debug.dump(msg);
            if (msg['cpdlc'] != nil) {
                node.setValue('message', string.join('/', msg.cpdlc.message));
            }
            elsif (msg.packet != nil) {
                node.setValue('message', msg.packet);
            }
            else {
                node.setValue('message', '');
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
        setprop('/cpdlc/logon-status', 'SENDING');
        if (station == nil) {
            station = getprop('/cpdlc/logon-station');
        }
        me.sendCPDLC(station, '', 'Y', 'REQUEST LOGON', func { setprop('/cpdlc/logon-status', 'SENT'); });
    },

    cpdlcLogoff: func (station=nil) {
        setprop('/cpdlc/logon-status', 'SENDING');
        if (station == nil) {
            station = getprop('/cpdlc/current-station');
        }
        setprop('/cpdlc/last-station', getprop('/cpdlc/current-station'));
        setprop('/cpdlc/last-station-name', getprop('/cpdlc/current-station-name'));
        setprop('/cpdlc/current-station', '');
        setprop('/cpdlc/current-station-name', '');
        me.sendCPDLC(station, '', 'N', 'LOGOFF', func { setprop('/cpdlc/logon-status', 'SENT'); });
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
                timestamp: node.getValue('timestamp'),
                timestamp4: substr(node.getValue('timestamp') or '?????????T??????', 9, 4),
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

globals.CPDLC = CPDLC;

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
