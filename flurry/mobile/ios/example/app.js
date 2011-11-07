var window = Ti.UI.createWindow({
    backgroundColor: 'white'
});

Titanium.Flurry = Ti.Flurry = require('ti.flurry');

Ti.Flurry.debugLogEnabled = true;
Ti.Flurry.eventLoggingEnabled = true;

Ti.Flurry.initialize('ND1292FY4ULRQF5PU4ZQ' /*<-- PUT YOUR OWN API KEY HERE!*/);

Ti.Flurry.reportOnClose = true;
Ti.Flurry.sessionReportsOnPauseEnabled = true;
Ti.Flurry.secureTransportEnabled = false;

Ti.Flurry.age = 24;
Ti.Flurry.userID = 'John Adams';
Ti.Flurry.gender = 'm';

/**
 * Log a very simple click event.
 */
var logEvent = Ti.UI.createButton({
    title: 'Fire Event',
    top: 60, width: 200, height: 40
});
var logEventCount = 0;
logEvent.addEventListener('click', function() {
    Ti.Flurry.logEvent('click', { clickCount: ++logEventCount });
});
window.add(logEvent);

/**
 * Time based events.
 */
var startTimedEvent = Ti.UI.createButton({
    title: 'Start Timed Event',
    top: 120, width: 200, height: 40
});
startTimedEvent.addEventListener('click', function() {
    Ti.Flurry.logTimedEvent('timedClick');
});
window.add(startTimedEvent);
var endTimedEvent = Ti.UI.createButton({
    title: 'End Timed Event',
    top: 180, width: 200, height: 40
});
endTimedEvent.addEventListener('click', function() {
    Ti.Flurry.endTimedEvent('timedClick');
});
window.add(endTimedEvent);

window.open();