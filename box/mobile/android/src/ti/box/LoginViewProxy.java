/**
 * Ti.Box Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

package ti.box;

import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.kroll.KrollDict;
import org.appcelerator.titanium.proxy.TiViewProxy;
import org.appcelerator.titanium.view.TiUIView;

import ti.modules.titanium.ui.ProgressBarProxy;
import ti.modules.titanium.ui.widget.TiUIProgressBar;
import ti.modules.titanium.ui.widget.TiView;
import ti.modules.titanium.ui.widget.webview.TiUIWebView;

import android.app.Activity;
import android.view.MotionEvent;
import android.view.View;

import java.util.HashMap;

@Kroll.proxy(creatableInModule = BoxModule.class)
public class LoginViewProxy extends TiViewProxy {

	public LoginViewProxy() {
		super();
	}

	private TiUIWebView _web;

	public TiUIWebView getWebView() {
		if (_web == null) {
			_web = new TiUIWebView(this);
			_web.getLayoutParams().autoFillsHeight = true;
			_web.getLayoutParams().autoFillsWidth = true;
		}
		return _web;
	}

	private ProgressBarProxy _progress;

	private ProgressBarProxy getProgressBar() {
		if (_progress == null) {
			_progress = new ProgressBarProxy();
			_progress.setProperty("max", 100, true);
			_progress.setWidth("90%");
		}
		return _progress;
	}

	/**
	 * Shows a progress bar to the user.
	 * 
	 * @param progress
	 *            A value from 0 to 100 to show how far along the login request
	 *            is.
	 */
	public void setProgress(int progress) {
		ProgressBarProxy progressBar = getProgressBar();
		progressBar.setProperty("value", progress, true);
		if (progress == 100) {
			progressBar.hide(new KrollDict());
			remove(progressBar);
			progressBar.releaseViews();
		}
	}

	@Override
	public TiUIView createView(Activity activity) {
		TiUIView view = new TiView(this);
		view.getLayoutParams().autoFillsHeight = true;
		view.getLayoutParams().autoFillsWidth = true;
		TiUIWebView webView = getWebView();
		view.add(webView);
		webView.getWebView().requestFocus(View.FOCUS_DOWN);
		webView.getWebView().setOnTouchListener(new View.OnTouchListener() {
			@Override
			public boolean onTouch(View v, MotionEvent e) {
				switch (e.getAction()) {
				case MotionEvent.ACTION_DOWN:
				case MotionEvent.ACTION_UP:
					if (!v.hasFocus())
						v.requestFocus();
					break;
				}
				return false;
			}
		});
		add(getProgressBar());
		return view;
	}

}
