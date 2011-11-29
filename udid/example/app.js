var UDID = require('ti.udid');

var win = Ti.UI.createWindow({
    backgroundColor: 'white'
});

win.add(Ti.UI.createLabel({
    text: UDID.oldUDID
}));

win.open();