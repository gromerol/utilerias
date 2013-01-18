/**
 * Ti.Box Module
 * Copyright (c) 2010-2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

package ti.box.calls;

import java.io.IOException;
import java.util.HashMap;

import org.appcelerator.kroll.KrollFunction;
import org.appcelerator.kroll.KrollProxy;
import ti.box.Constants;
import ti.box.LoginViewProxy;
import ti.box.Util;
import android.graphics.Bitmap;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import com.box.androidlib.Box;
import com.box.androidlib.DAO.User;
import com.box.androidlib.ResponseListeners.GetAuthTokenListener;
import com.box.androidlib.ResponseListeners.GetTicketListener;
import com.box.androidlib.Utils.BoxConstants;

public class Login {

	/**
	 * Prevents instantiation.
	 */
	private Login() {
	}

	public static void call(final KrollProxy proxy, HashMap args) {
		final LoginViewProxy loginView = (LoginViewProxy) args.get("view");
		final KrollFunction success = (KrollFunction) args.get("success");
		final KrollFunction error = (KrollFunction) args.get("error");

		final Box box = Box.getInstance(Constants.API_KEY);

		/**
		 * First, we get a ticket. We need this to show the login web view to the user.
		 */
		box.getTicket(new GetTicketListener() {

			@Override
			public void onIOException(IOException ex) {
				Util.handleIOException(proxy, ex, error);
			}

			@Override
			public void onComplete(final String ticket, final String status) {
				if (status.equals("get_ticket_ok")) {
					String login_url = BoxConstants.LOGIN_URL + ticket;
					loginView.getWebView().getWebView().setWebChromeClient(new WebChromeClient() {

						@Override
						public void onProgressChanged(WebView view, int newProgress) {
							super.onProgressChanged(view, newProgress);
							loginView.setProgress(newProgress);
						}

					});
					loginView.getWebView().getWebView().setWebViewClient(new WebViewClient() {

						@Override
						public void onPageStarted(WebView view, String url, Bitmap favicon) {
							super.onPageStarted(view, url, favicon);
							loginView.setProgress(0);
						}

						@Override
						public void onPageFinished(WebView view, String url) {
							box.getAuthToken(ticket, new GetAuthTokenListener() {

								@Override
								public void onIOException(IOException ex) {
									Util.handleIOException(proxy, ex, error);
								}

								@Override
								public void onComplete(final User user, final String status) {
									loginView.setProgress(100);
									if (status.equals("get_auth_token_ok")) {
										Util.saveAuthToken(user.getAuthToken());
										success.callAsync(proxy.getKrollObject(), new Object[] {});
									}
									/*
									 * NOTE: we don't fail with an "else" case here because we are checking the token after EVERY load of the web view
									 * to see if they have successfully logged in.
									 */
								}
							});
						}
					});
					loginView.getWebView().getWebView().loadUrl(login_url);
				} else {
					Util.handleCommonStatuses(proxy, status, error);
				}
			}
		});
	}
}
