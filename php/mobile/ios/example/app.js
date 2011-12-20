var TiPHP = require('ti.php');

var win = Ti.UI.createWindow({
    backgroundColor: 'white'
});

win.add(Ti.UI.createLabel({
    text: TiPHP.addslashes("mark's")
}));

win.open();