/*
 * Created on July 25, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.shared.constants;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public interface ConstantsErrorMessage {

	public static final String ERROR_SYSTEMLOGINFAIL = "Please contact the system administrator in order to connect to the database.";
	public static final String ERROR_FATAL = "System fatal error !  Please contant system administrator !";
	public static final String ERROR_EXTREME_FATAL = "Fatal error during dayend! Please contant system administrator!";
	public static final String ERROR_DAYEND = "Generation of Dayend Report has been failed during the night! Some functions will be disabled. Please contant system administrator! ";
	public static final String ERROR_DISABLE = "This function is disabled due to the failure of the dayend process!";
	public static final String ERROR_TXCNT_BEGINTX = "Fatal error!  This transaction cannot be completed! Please also check against previous Transaction ";
	public static final String ERROR_TXCNT_COMMITTX = "Fatal error in processing transaction!  Please retry!";
	public static final String ERROR_NOT_FOUND_RECORD = "Not found record!";
	
	public final static String RETURN_PASS		= "0";
	public final static String RETURN_FAIL		= "-1";
	public final static String RETURN_DB_ERROR	= "-999";

	public final static String OK				= "OK";
	public final static String FAIL_TO_APPEND	= "Fail to Append.";
	public final static String FAIL_TO_MODIFY	= "Fail to Modify.";
	public final static String FAIL_TO_DELETE	= "Fail to Delete.";
	public final static String NO_RECORD_FOUND	= "No record found.";
	public final static String ACCESS_DENY		= "Access Deny!";
}
