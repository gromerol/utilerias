/**
 * Ti.Soundsampler Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

package ti.soundsampler;

import java.io.IOException;
import java.lang.Math;

import org.appcelerator.kroll.KrollModule;
import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.kroll.common.Log;

import android.app.Activity;
import android.media.MediaRecorder;

@Kroll.module(name="Soundsampler", id="ti.soundsampler")
public class SoundsamplerModule extends KrollModule
{
	// Standard Debugging variables
	private static final String LCAT = "SoundsamplerModule";

	private MediaRecorder recorder;
	
	public SoundsamplerModule() {
		super();
	}
	
	@Override
	public void onDestroy(Activity activity) {
		stop();
		
		super.onDestroy(activity);
	}
	
	@Override
	public void onPause(Activity activity) {
		super.onPause(activity);
		
		stop();
	}
	
	// Methods
	@Kroll.method
	public void start() {
		if (recorder == null) {
			recorder = new MediaRecorder();
			recorder.setAudioSource(MediaRecorder.AudioSource.MIC);
			recorder.setOutputFormat(MediaRecorder.OutputFormat.THREE_GPP);
			recorder.setAudioEncoder(MediaRecorder.AudioEncoder.AMR_NB);
			recorder.setOutputFile("/dev/null");
			try {
				recorder.prepare();
				recorder.start();
			} catch (IOException e) {
			}

		}
	}
	
	@Kroll.method
	public void stop() {
		if (recorder != null) {
			recorder.stop();
			recorder.release();
			recorder = null;
		}
	}
	
	// Properties
	@Kroll.getProperty
	public int getSoundAmplitude() {
		if (recorder != null) {
			try {
				// Convert from 16-bit sample value to dBFS
				return (int)(20.0 * Math.log10((double)recorder.getMaxAmplitude() / 32767.0));
			} catch (RuntimeException e) {
			}
		}
		
		return 0;
	}
	
	@Kroll.getProperty
	public boolean getIsRecording() {
		return recorder != null;
	}
}
