// open a single window
var window = Ti.UI.createWindow({
    backgroundColor: 'white',
    layout: 'vertical'
});

var onSwitch = Ti.UI.createSwitch({
    value: false,
    isSwitch: true,
    top: 10,
    left: 10,
    height: Ti.UI.SIZE || 'auto',
    width: 200,
    titleOn: 'Stop Recording',
    titleOff: 'Start Recording'
});
window.add(onSwitch);

var soundLevelLabel = Ti.UI.createLabel({
    top: 10,
    left: 10,
    width: 200,
    height: Ti.UI.SIZE || 'auto'
});
window.add(soundLevelLabel);

window.open();

var SoundSampler = require('ti.soundsampler');
Ti.API.info("module is => " + SoundSampler);

var intervalTimer;

function showLevels() {
    soundLevelLabel.text = SoundSampler.soundAmplitude;
}

onSwitch.addEventListener('change', function (e) {
    if (e.value) {
        SoundSampler.start();
        intervalTimer = setInterval(showLevels, 1000);
    } else {
        clearInterval(intervalTimer);
        SoundSampler.stop();
    }
});

function pauseHandler() {
    clearInterval(intervalTimer);
}

function resumeHandler() {
    onSwitch.value = SoundSampler.isRecording;
}

if (Ti.Platform.name == 'android') {
    Ti.Android.currentActivity.addEventListener('pause', pauseHandler);
    Ti.Android.currentActivity.addEventListener('resume', resumeHandler);
} else {
    Ti.App.addEventListener('pause', pauseHandler);
    Ti.App.addEventListener('resume', resumeHandler);
}