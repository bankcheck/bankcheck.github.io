package com.hkah.client.util;

/**
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class PasswordUtil {

	private static final String ls_key = "ah_framework";

	/**
	 * 	Description:
	 *	
	 *		This function is coded for password encryption
	 *		user XOR function and decode to Hex(a=0..15), XOR key is project ID.
	 *	
	 *	 Log:
	 *		1997/08/05	C.K. Hung	Initial Version
	 */
	public static String cisEncryption(String password) {
		int		i, ll_len1, ll_len2, ll_key[], ll_source, ll_keychr;
		char[]	ls_text; 

		// for empty password
		if (password == null || password.length() == 0) return "";

		// get the ascII array of key
		ll_len1 = ls_key.length();
		ll_key = new int[ll_len1];
		for (i = ll_len1 - 1; i >= 0; i--) {
			ll_key[i] = ls_key.charAt(i);
		}

		// xor operation, f(source,key) = 256 + key - source
		ll_len2	= password.length();
		ls_text = new char[ll_len2 * 2];
		for (i = 0; i < ll_len2; i++) {
			ll_source = password.charAt(i);
			ll_keychr = 256 + ll_key[i % ll_len1] - ll_source;
			ls_text[i * 2] = (char) ('A' + ((int) ll_keychr / 16));
			ls_text[(i * 2)+ 1] = (char) ('A' + (ll_keychr % 16));
		}
		return String.valueOf(ls_text);
	}

	/**
	 * 	Description:
	 *	
	 *		This function is used to decode password for of_encryption()
	 *	
	 *	 Log:
	 *		2005/12/26	C.K. Hung	Initial Version
	 */
	public static String cisDecryption(String password) {
		int		i, ll_len1, ll_len2, ll_key[], ll_source, ll_keychr;
		char[]	ls_text; 

		// for empty password
		if (password == null || password.length() == 0) return "";

		// get the ascII array of key
		ll_len1 = ls_key.length();
		ll_key = new int[ll_len1];
		for (i = ll_len1 - 1; i >= 0; i--) {
			ll_key[i] = ls_key.charAt(i);
		}

		// xor operation, f(source,key) = 256 + key - source
		ll_len2	= password.length() / 2;
		ls_text = new char[ll_len2];
		for (i = 0; i < ll_len2; i++) {
			ll_source = (password.charAt(i * 2) - 'A') * 16 + (password.charAt(i * 2 + 1) - 'A');
			ll_keychr = 256 + ll_key[ i % ll_len1] - ll_source;
			ls_text[i] = (char) ll_keychr;
		}
		return String.valueOf(ls_text);
	}
}