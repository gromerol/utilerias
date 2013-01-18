/**
 * Ti.Soundsampler Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiSoundsamplerModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation TiSoundsamplerModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"178d3dee-d3ea-4290-9a64-12717db58a74";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"ti.soundsampler";
}

#pragma mark Lifecycle

-(void)dealloc
{
	RELEASE_TO_NIL(recorder);
	
	[super dealloc];
}

-(id)init
{
	NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
	
	NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
							  [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
							  [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
							  [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
							  [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
							  nil];
	
	NSError *error;
	
	recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
	
	if (recorder == nil) {
		NSLog([error description]);	
	}
	
	return [super init];
}

-(void)suspend:(id)sender
{
	[recorder stop];
	
	[super suspend:sender];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

-(void)start:(id)args
{
	if (recorder && ![recorder isRecording]) {
		[recorder prepareToRecord];
		recorder.meteringEnabled = YES;
		[recorder record];
	}
}

-(void)stop:(id)args
{
	if (recorder && [recorder isRecording]) {
		[recorder stop];
	}
}

-(BOOL)getIsRecording
{
	if (recorder) {
		return [recorder isRecording];
	}
	
	return NO;
}

-(NSNumber*)getSoundAmplitude
{
	if (recorder) {
		[recorder updateMeters];
		
		return NUMFLOAT([recorder peakPowerForChannel:0]);
	}
	
	return NUMFLOAT(0.0);
}

@end
