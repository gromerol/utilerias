// open a single window
var window = Ti.UI.createWindow({
    backgroundColor:'white'
});

var GetGlue = require('ti.getglue');

var widget = GetGlue.createView({
    source: 'http://urltoshow.com',
    objectKey: 'movies/home_alone/chris_columbus',
    top:30,
    left:30,
});
 
window.add(widget);

window.open();
