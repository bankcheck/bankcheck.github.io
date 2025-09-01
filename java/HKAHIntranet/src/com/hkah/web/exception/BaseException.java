/*
 * Created on January 31, 2009
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.web.exception;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class BaseException extends Exception {

	protected Log log = LogFactory.getLog(this.getClass());

	/**
	 * Constructor for BaseException.
	 */
	public BaseException() {
		super();
	}

	/**
	 * Constructor for BaseException.
	 * @param arg0
	 */
	public BaseException(String arg0) {
		super(arg0);
		log.error(arg0);
	}
}
