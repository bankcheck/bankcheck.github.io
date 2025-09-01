package com.hkah.server.util;

import jcifs.smb.NtlmPasswordAuthentication;

public class AuthUtil {
	// Under development
	private static String login_user = "webfolder@ahhk.local";
	private static String login_pass = "folder28350";
	private static NtlmPasswordAuthentication auth = new NtlmPasswordAuthentication("",login_user, login_pass);
	
	public static NtlmPasswordAuthentication getDefaultSmbAuth() {
		return auth;
	}
}
