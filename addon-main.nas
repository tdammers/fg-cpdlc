var CPDLC = {
    new: func () {
        return {
            parents: [CPDLC],
            downlinkNode: props.globals.getNode('/acars/downlink', 1),
            uplinkNode: props.globals.getNode('/acars/uplink', 1),
            statusNode: props.globals.getNode('/acars/status-text', 1),
            messages: {}, # messages by ID ({$SENDER}%{$MIN})
            dialogHeads: [], # last message IDs of all open dialogs
            history: [], # all message IDs in order received / sent
            unread: [], # unread message IDs in order received / sent
            downlinkErrors: [],
            currentStation: nil,
            lastStation: nil,

            telexUplink: [],
            telexDownlink: [],
        };
    },

    reset: func() {
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
        var msgID = msg.from ~ '/' ~ msg.cpdlc.min;
        var m = msg.cpdlc.message;
        var vars = [];
        if (typeof(m) == 'vector') { m = m[0]; }
        m = string.uc(m);
        if (m == 'LOGON ACCEPTED') {
            me.lastStation = me.currentStation;
            me.currentStation = msg.from;
            setprop('/cpdlc/current-station', me.currentStation or '');
            setprop('/cpdlc/last-station', me.lastStation or '');
        }
        elsif (m == 'LOGOFF') {
            me.lastStation = me.currentStation;
            me.currentStation = nil;
            setprop('/cpdlc/current-station', me.currentStation or '');
            setprop('/cpdlc/last-station', me.lastStation or '');
        }
        elsif (startswith(m, 'HANDOVER') and string.scanf(m, "HANDOVER @%4s", vars)) {
            me.cpdlcRequestLogon(vars[0]);
        }
        else {
            debug.dump('UNKNOWN UPLINK', m);
        }

        if (msg.cpdlc.ra == 'NE') {
            # no response required
        }
        else {
            # response required, add to open dialog heads.
            append(me.dialogHeads, msgID);
        }
    },

    cpdlcRequestLogon: func (station=nil) {
        if (station == nil) {
            station = getprop('/cpdlc/logon-station');
        }
        me.sendCPDLC(station, '', 'Y', 'REQUEST LOGON');
    },

    cpdlcReply: func (msg, ra, reply) {
        if (typeof(msg) == 'string') {
            msg = me.messages[msg];
        }
        if (msg == nil) {
            debug.warn('Message for reply not found: ' ~ msg);
        }
        if (msg.cpdlc.dir != 'uplink') {
            debug.warn('Cannot reply to downlink messages');
            return;
        }
        if (me.closesDialog(msg.ra, reply)) {
            me.closeDialogHead(msg);
        }
        me.sendCPDLC(msg.from, msg.min, ra, reply);
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
        else {
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
            };
        if (msg.type == 'cpdlc') {
            msg.cpdlc = me.parseCPDLC(msg.packet);
        }
        return msg;
    },

    closeDialogHead: func (msgID) {
        if (msgID == nil) return;
        if (typeof(msgID) != 'string') {
            msgID = msgID.from ~ '/' ~ msgID.cpdlc.min;
        }
        var tmp = [];
        foreach (var h; me.dialogHeads) {
            if (h != msgID) append(tmp, h);
        }
        me.dialogHeads = tmp;
    },

    handleDownlink: func() {
        var msg = me.messageFromNode(me.downlinkNode);
        msg.dir = 'downlink';
        if (msg.status == 'sending') return;

        if (msg.status == 'error') {
            append(me.downlinkErrors, msg);
        }
        elsif (msg.type == 'cpdlc') {
            var msgID = msg.from ~ '/' ~ msg.cpdlc.min;
            me.messages[msgID] = msg;
            if (msg.cpdlc.mrn != '') {
                var parentID = msg.to ~ '/' ~ msg.cpdlc.mrn;
                me.closeDialogHead(parentID);
            }
            append(me.dialogHeads, msgID);
            append(me.history, msgID);
            append(me.unread, msgID);
        }
        else {
            append(me.telexDownlink, msg);
        }
    },

    handleUplink: func() {
        var msg = me.messageFromNode(me.uplinkNode);
        msg.dir = 'uplink';

        if (msg.type == 'cpdlc') {
            var msgID = msg.from ~ '/' ~ msg.cpdlc.min;
            me.messages[msgID] = msg;
            if (msg.cpdlc.mrn != '') {
                var parentID = msg.to ~ '/' ~ msg.cpdlc.mrn;
                var tmp = [];
                foreach (var h; me.dialogHeads) {
                    if (h != parentID) append(tmp, h);
                }
                me.dialogHeads = tmp;
            }
            append(me.history, msgID);
            me.cpdlcHandleUplink(msg);
        }
        else {
            append(me.telexUplink, msg);
        }
    },
};

var unload = func(addon) {
};

var main = func(addon) {
    globals.cpdlc = CPDLC.new();
    setlistener('/acars/uplink/status', func { globals.cpdlc.handleUplink(); });
    setlistener('/acars/downlink/status', func { globals.cpdlc.handleDownlink(); });
};

var startswith = func (haystack, needle) {
    return (left(haystack, size(needle)) == needle);
};
