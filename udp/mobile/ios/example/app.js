var UDP = require('ti.udp');

var u = Ti.Android != undefined ? 'dp' : 0;
var win = Ti.UI.createWindow({
    backgroundColor: '#fff',
    layout: 'vertical'
});

/*
 Create our socket. 
 */
var socket = UDP.createSocket();

/*
 Start the server...
 */
var startSocket = Ti.UI.createButton({
    title: 'Start Socket',
    top: 10 + u, left: 10 + u, right: 10 + u, height: 40 + u
});
startSocket.addEventListener('click', function () {
    socket.start({
        port: 6100
    });
});
win.add(startSocket);

var sendTo = Ti.UI.createTextField({
    height: 44 + u, top: 10 + u, left: 10 + u, right: 10 + u,
    borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED,
    value: Ti.App.Properties.getString('SavedSendTo', '')
});
win.add(sendTo);

/*
 Send a string...
 */
var sendString = Ti.UI.createButton({
    title: 'Send String to Specific',
    top: 10 + u, left: 10 + u, right: 10 + u, height: 40 + u
});
sendString.addEventListener('click', function () {
    Ti.App.Properties.setString('SavedSendTo', sendTo.value);
    socket.sendString({
        host: sendTo.value,
        data: 'Hello, UDP!'
    });
});
win.add(sendString);

/*
 ... or send bytes.
 */
var sendBytes = Ti.UI.createButton({
    title: 'Send Bytes to Specific',
    top: 10 + u, left: 10 + u, right: 10 + u, height: 40 + u
});
sendBytes.addEventListener('click', function () {
    Ti.App.Properties.setString('SavedSendTo', sendTo.value);
    socket.sendBytes({
        host: sendTo.value,
        data: [ 181, 10, 0, 0 ]
    });
});
win.add(sendBytes);

/*
 Broadcast a string (notice we don't specify a host)...
 */
var broadcastString = Ti.UI.createButton({
    title: 'Broadcast String',
    top: 10 + u, left: 10 + u, right: 10 + u, height: 40 + u
});
broadcastString.addEventListener('click', function () {
    socket.sendString({
        data: 'Hello, UDP!'
    });
});
win.add(broadcastString);

/*
 Listen for when the server or client is ready.
 */
socket.addEventListener('started', function (evt) {
    status.text = 'Started!';
});

/*
 Listen for data from network traffic.
 */
socket.addEventListener('data', function (evt) {
    status.text = JSON.stringify(evt);
    Ti.API.info(JSON.stringify(evt));
});

/*
 Listen for errors.
 */
socket.addEventListener('error', function (evt) {
    status.text = JSON.stringify(evt);
    Ti.API.info(JSON.stringify(evt));
});

/*
 Finally, stop the socket when you no longer need network traffic access.
 */
var stop = Ti.UI.createButton({
    title: 'Stop',
    top: 10 + u, left: 10 + u, right: 10 + u, height: 40 + u
});
stop.addEventListener('click', function () {
    socket.stop();
});
win.add(stop);

var status = Ti.UI.createLabel({
    text: 'Press Start Socket to Begin',
    top: 10 + u, left: 10 + u, right: 10 + u, height: 'auto'
});
win.add(status);

win.open();