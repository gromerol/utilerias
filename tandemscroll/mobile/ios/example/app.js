var win = Ti.UI.createWindow({
    backgroundColor: '#fff'
});
var TandemScroll = require('ti.tandemscroll');
var scrollViews = [];
for (var i = 0; i < 3; i++) {
    var scrollView = Ti.UI.createScrollView({
        contentWidth: 1000 * (i + 1),
        contentHeight: 1000 * (i + 1)
    });
    scrollView.add(Ti.UI.createLabel({
        text: 'I am Scroll View ' + i,
        width: 160, height: 30,
        top: 200 + 70 * i, left: 200 + 40 * i
    }));
    scrollViews.push(scrollView);
    win.add(scrollView);
}
TandemScroll.lockTogether(scrollViews);
scrollViews[scrollViews.length-1].addEventListener('scroll', function (evt) {
    Ti.API.info(evt.x + ',' + evt.y);
});
win.open();