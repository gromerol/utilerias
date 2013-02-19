/**
 * Ti.Ntlm Module
 * Copyright (c) 2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

package ti.ntlm;

import org.apache.http.auth.AuthSchemeFactory;
import org.appcelerator.kroll.KrollModule;
import org.appcelerator.kroll.annotations.Kroll;

import org.appcelerator.titanium.TiApplication;
import org.appcelerator.kroll.common.Log;
import org.appcelerator.kroll.common.TiConfig;


@Kroll.module(name="Ntlm", id="ti.ntlm")
public class NtlmModule extends KrollModule
{

	// You can define constants with @Kroll.constant, for example:
	// @Kroll.constant public static final String EXTERNAL_NAME = value;
	
	private NTLMSchemeFactory _ntlmFactory;
	
	public NtlmModule()
	{
		super();
	}

	// Methods
	@Kroll.method
	public String getAuthScheme()
	{
		return "ntlm";
	}
	
	@Kroll.method
	public AuthSchemeFactory getAuthFactory()
	{
		if (_ntlmFactory == null) {
			_ntlmFactory = new NTLMSchemeFactory();
		}
		return _ntlmFactory;
	}
	
}

