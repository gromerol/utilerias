# Ti.soundsampler Module

## Description

Provides an audio peak meter sampling from the device microphone

## Getting Started

View the [Using Titanium Modules](http://docs.appcelerator.com/titanium/latest/#!/guide/Using_Titanium_Modules) document for instructions on getting
started with using this module in your application.

## Accessing the soundsampler Module

To access this module from JavaScript, you would do the following:

<pre>var soundsampler = require('ti.soundsampler');</pre>

## Functions

### start()

Start recording audio samples

### stop()

Stop recording audio samples

## Properties

### isRecording [bool]

The current state of audio recording

### soundAmplitude [int]

The decibel level of the peak meter reading since the last time this value was retrieved (dBFS)

## Usage

See example.

## Author

Jeff English

## Module History

View the [change log](changelog.html) for this module.

## Feedback and Support
Please direct all questions, feedback, and concerns to [info@appcelerator.com](mailto:info@appcelerator.com?subject=SoundSampler%20Module).

## License
Copyright(c) 2010-2013 by Appcelerator, Inc. All Rights Reserved. Please see the LICENSE file included in the distribution for further details.

