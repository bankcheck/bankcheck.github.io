/*
 * Created on July 3, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.common;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class Factory extends FactoryBase {

	// variable
	private static Factory factory = null;

	// hidden constructor
	private Factory() {
		super();
	}

	public static Factory getInstance() {
		if (factory == null) {
			factory = new Factory();
		}
		return factory;
	}
}