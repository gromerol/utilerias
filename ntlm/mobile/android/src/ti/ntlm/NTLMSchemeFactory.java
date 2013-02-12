/**
 * Ti.Ntlm Module
 * Copyright (c) 2013 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

package ti.ntlm;

import org.apache.http.auth.AuthScheme;
import org.apache.http.auth.AuthSchemeFactory;
import org.apache.http.impl.auth.NTLMScheme;
import org.apache.http.params.HttpParams;
import org.appcelerator.kroll.KrollProxy;
import org.appcelerator.kroll.annotations.Kroll;

@Kroll.proxy(creatableInModule=NtlmModule.class)
public class NTLMSchemeFactory extends KrollProxy implements AuthSchemeFactory {

	@Override
	public AuthScheme newInstance(HttpParams arg0) {
		
		return new NTLMScheme(new JCIFSEngine());
	}

}
