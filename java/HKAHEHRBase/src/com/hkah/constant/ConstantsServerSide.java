package com.hkah.constant;

public class ConstantsServerSide {
	
	public static final int MAXIMUM_NO_OF_RECORDS = 500;

	public static boolean DEBUG = false;
	public static boolean CORE_SERVER = false;
	public static boolean SECURE_SERVER = false;

	public static final String SITE_CODE_HKAH = "hkah";
	public static final String SITE_CODE_TWAH = "twah";

	public static String SITE_CODE = SITE_CODE_HKAH;
		// Get site code of this application instance from property file defined in
		// FileProperties.DEFAULT_CONFIG, set default to "hkah" if file cannot be found.
	public static String SITE_ENV = "N/A";
	
	public static boolean isHKAH() {
		return SITE_CODE_HKAH.equals(SITE_CODE);
	}

	public static boolean isTWAH() {
		return SITE_CODE_TWAH.equals(SITE_CODE);
	}
	
	public static String getSiteShortFormUpper() {
		return ("HKAH-" + (isHKAH() ? "SR" : (isTWAH() ? "TW" : SITE_CODE))).toUpperCase();
	}
	
	//default values
	public static String JNDI_NAME_HATS = "hats";
	public static String JNDI_NAME_CIS = "cis";
	public static String JNDI_NAME_LIS = "lis";
	public static String MAIL_HOST = "160.100.2.6";
	public static String MAIL_SMTP_PORT = "25";
	public static String MAIL_PROTOCOL = "smtp";
	public static String MAIL_SMTP_AUTH = "false";
	public static String MAIL_SMTP_USERNAME = null;
	public static String MAIL_SMTP_PASSWORD = null;
	public static String MAIL_SMTP_CONNECTIONTIMEOUT = "30000";
	public static String MAIL_SMTP_TIMEOUT = "30000";
	public static String MAIL_ALERT = "alert@hkah.org.hk";
	public static String MAIL_TESTER = "arran.siu@hkah.org.hk";
	public static String MAIL_ADMIN = "arran.siu@hkah.org.hk";
	public static String MAIL_ALLSTAFF = "hk@hkah.org.hk";
}