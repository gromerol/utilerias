/**
 * Ti.Soundsampler Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiModule.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface TiSoundsamplerModule : TiModule 
{
	AVAudioRecorder *recorder;
}

@end
