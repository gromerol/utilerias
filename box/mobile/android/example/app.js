var Box = require('ti.box');
Box.apiKey = '<<YOUR API KEY HERE>>'; // You can get your own at https://www.box.net/developers/services

/*
    This example app uses a very simple UI concept. There is only one window, and we add views to it.
    - One central "UI" object handles showing and hiding views.
    - Each view gets its own JavaScript file, named for what it does (like login or register).
 */
var u = Ti.Android != undefined ? 'dp' : 0;
Ti.include(
    'utility.js',
    'views/chooseLoginOrRegister.js',
    'views/login.js', 'views/register.js',
    'views/loggedIn.js'
);

var win = Ti.UI.createWindow({
    backgroundColor: 'white',
    exitOnClose: true,
    navBarHidden: true
});

var UI = {
    visible: null,
    viewStack: [],
    zIndexLevels: {
        normal: 1,
        dialog: 2,
        alert: 3
    },
    add: function(view) { win.add(view); UI.viewStack.push(view); },
    remove: function(view) { win.remove(view); UI.viewStack.splice(UI.viewStack.indexOf(view), 1); },
    popIn: popInView,
    popOut: popOutView,
    fadeIn: fadeInView,
    fadeOut: fadeOutView
};

win.addEventListener('android:back', function() {
    if (UI.viewStack.length == 1) {
        win.close();
    }
    else {
        UI.popOut(UI.viewStack[UI.viewStack.length-1]);
    }
});

if (Ti.Android) {
    bindAndroidMenuButton();
}

win.open();

if (Box.user && Box.user.loggedIn) {
    UI.add(createLoggedInView());
}
else {
    UI.add(createChooseLoginOrRegisterView());
}