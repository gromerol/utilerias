/**
 * Ti.UDP Module
 * Copyright (c) 2010-2011 by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */
package ti.udp;

import org.appcelerator.kroll.KrollModule;
import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.titanium.TiContext;

@Kroll.module(name = "Udp", id = "ti.udp")
public class UdpModule extends KrollModule {
	public UdpModule(TiContext tiContext) {
		super(tiContext);
	}
}
