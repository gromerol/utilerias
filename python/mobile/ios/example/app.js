var TiPY = require('ti.python');

var win = Ti.UI.createWindow({
    backgroundColor: 'white'
});

win.add(Ti.UI.createLabel({
    text: TiPY.builtins.min(677, 45, 99, 12, 200)
}));

win.open();

