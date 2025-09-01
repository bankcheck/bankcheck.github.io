/*
 * Created on October 21, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.shared.constants;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public interface ConstantsVariable {

	public final static String HKAH_VALUE = "HKAH";
	public final static String TWAH_VALUE = "TWAH";

	public final static String DOT_VALUE = ".";
	public final static String COMMA_VALUE = ",";
	public final static String SEMIQUOTE_VALUE = ";";
	public final static String MENU_VALUE = "menu";
	public final static String SUBMENU_VALUE = "submenu";
	public final static String NAME_VALUE = "name";
	public final static String DESTINATION_VALUE = "dest";
	public final static String KEYS_VALUE = "keys";
	public final static String MASK_VALUE = "mask";
	public final static String MNEMONIC_VALUE = "mnemonic";

	public final static String CLOSE_VALUE = "Close";
	public final static String EXIT_VALUE = "Exit";

	public final static String EMPTY_VALUE = "";
	public final static String SPACE_VALUE = " ";
	public final static String EQUAL_VALUE = "=";
	public final static String PLUS_VALUE = "+";
	public final static String MINUS_VALUE = "-";
	public final static String QUOTE_VALUE = "\"";
	public final static String UNDERSCORE_VALUE = "_";
	public final static String SLASH_VALUE = "/";
	public final static String BACKSLASH_VALUE = "\\";
	public final static String GREATER_THAN_DELIMITER = ">";
	public final static String NA_VALUE = "N/A";
	public final static String YES_VALUE = "Y";
	public final static String NO_VALUE = "N";
	public final static String FIELD_DELIMITER = "<FIELD/>";
	public final static String LINE_DELIMITER = "<LINE/>";
	public final static String MENU_DELIMITER = "#";
	public final static String DOLLORSIGN_VALUE = "$";
	public final static String QUESTION_MARK_VALUE = "?";

	public final static String AND_VALUE = "&";
	public final static String AND_HTML_VALUE = "&amp;";
	public final static String GREATER_THAN_VALUE = ">";
	public final static String GREATER_THAN_HTML_VALUE = "&gt;";
	public final static String SMALLER_THAN_VALUE = "<";
	public final static String SMALLER_THAN_HTML_VALUE = "&lt;";
	public final static String DOUBLE_QUOTE_VALUE = "\"";
	public final static String DOUBLE_QUOTE_HTML_VALUE = "&quot;";
	public final static String SINGLE_QUOTE_VALUE = "'";
	public final static String SINGLE_QUOTE_HTML_VALUE = "&apos;";

	public final static String MINUS_ONE_VALUE = "-1";
	public final static String MINUS_TWO_VALUE = "-2";
	public final static String MINUS_THREE_VALUE = "-3";
	public final static String MINUS_FOUR_VALUE = "-4";
	public final static String MINUS_FIVE_VALUE = "-5";
	public final static String MINUS_SIX_VALUE = "-6";
	public final static String MINUS_SEVEN_VALUE = "-7";
	public final static String MINUS_EIGHT_VALUE = "-8";
	public final static String MINUS_NINE_VALUE = "-9";
	public final static String ZERO_VALUE = "0";
	public final static String ONE_VALUE = "1";
	public final static String TWO_VALUE = "2";
	public final static String THREE_VALUE = "3";
	public final static String FOUR_VALUE = "4";
	public final static String FIVE_VALUE = "5";
	public final static String SIX_VALUE = "6";
	public final static String SEVEN_VALUE = "7";
	public final static String EIGHT_VALUE = "8";
	public final static String NINE_VALUE = "9";

	public final static String NULL_VALUE = "null";

	public final static String ALL_VALUE = "ALL";
	public final static String SEARCH_VALUE = "Search";
	public final static String APPEND_VALUE = "Append";
	public final static String MODIFY_VALUE = "Modify";
	public final static String DELETE_VALUE = "Delete";

	public final static String INVISIBLE_VALUE = "Invisible";
//	public final static String READ_VALUE = "Read";
	public final static String FULL_ACCESS_VALUE = "Full Access";

	// CoPayRef Type
	public final static String PERCENTAGE_VALUE = "%";
	public final static String AMOUNT_VALUE = "Amt";

	// login
	public static enum LoginCode {
		AUTH_SUCCESS ("AU00", "Login success."),
	    AUTH_ERR ("AU01", "System error. Please contact IT support."),
	    AUTH_CREDENTAIL_FAIL ("AU02", "User ID or password incorrect. Please try again."),
	    AUTH_USER_INACTIVE ("AU03", "User is inactive. Please contact IT support."),
	    AUTH_TRY_AGAIN ("AU04", "Sorry, please try to login again. If fail, please contact IT support."),
	    AUTH_LOGOUT_FAIL ("AU05", "Logout not success."),
		AUTH_SUCCESS_CHG_PWD ("AU06", "Change Password.");

	    private final String msg;
	    private final String code;

	    LoginCode(String code, String msg) {
	    	this.code = code;
	        this.msg = msg;
	    }

	    public String getCode() {
	    	return code;
	    }
	    public String getMsg() {
	    	return msg;
	    }

	    public static LoginCode getLoginCodeByCode(String code) {
	    	if (code == null) {
	    		return null;
	    	}
	    	for (LoginCode loginCode : LoginCode.values()) {
	    		if (loginCode.getCode().equals(code)) {
	    			return loginCode;
	    		}
	    	}
	    	return null;
	    }
	}
}