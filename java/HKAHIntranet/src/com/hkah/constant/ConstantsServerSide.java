package com.hkah.constant;

public class ConstantsServerSide {

	public static final int MAXIMUM_NO_OF_RECORDS = 500;

	public static String UPLOAD_FOLDER = null;
	public static String UPLOAD_WEB_FOLDER = null;
	public static String INDEX_FOLDER = null;
	public static String POLICY_FOLDER = null;
	public static String TEMP_FOLDER = null;
	public static String DOCUMENT_FOLDER = null;

	public static String ELEAVE_DB = null;
	public static String EMR_SERVER = null;
	public static String EMR_FOLDER = null;

	public static boolean DEBUG = false;
	public static boolean CORE_SERVER = false;
	public static boolean SECURE_SERVER = false;
	public static boolean BACKEND_SERVER = false;
	public static boolean EMAIL_SERVER = false;
	public static boolean LOAD_BALANCE = false;
	public static String SECURE_PORT = "443";

	public static final String SITE_CODE_HKAH = "hkah";
	public static final String SITE_CODE_TWAH = "twah";
	public static final String SITE_CODE_AMC = "amc";
	public static final String SITE_CODE_AMC1 = "amc1";
	public static final String SITE_CODE_AMC2 = "amc2";
	
	public static final String DBLINK_PORTAL_HKAH = "hkah";
	public static final String DBLINK_PORTAL_TWAH = "twah";
	public static final String DBLINK_PORTAL_AMC1 = "amc1_portal";
	public static final String DBLINK_PORTAL_AMC2 = "amc2_portal";

	public static String SITE_CODE = SITE_CODE_HKAH;
		// Get site code of this application instance from property file defined in
		// FileProperties.DEFAULT_CONFIG, set default to "hkah" if file cannot be found.

	public static boolean isHKAH() {
		return SITE_CODE_HKAH.equals(SITE_CODE);
	}

	public static boolean isTWAH() {
		return SITE_CODE_TWAH.equals(SITE_CODE);
	}

	public static boolean isAMC() {
		return SITE_CODE_AMC.equals(SITE_CODE);
	}
	
	public static boolean isAMC1() {
		return SITE_CODE_AMC1.equals(SITE_CODE);
	}

	public static boolean isAMC2() {
		return SITE_CODE_AMC2.equals(SITE_CODE);
	}
	
	public static String getSiteShortTermSymbol() {
		return isHKAH() ? "SR" : (isTWAH() ? "TW" : (isAMC1() ? "CWB" : (isAMC2() ? "TKP" : "")));
	}
	
	public static String getSiteShortTermSymbol(String siteCode) {
		return SITE_CODE_HKAH.equals(siteCode) ? "SR" : (SITE_CODE_TWAH.equals(siteCode) ? "TW" : 
			(SITE_CODE_AMC1.equals(siteCode) ? "CWB" : (SITE_CODE_AMC2.equals(siteCode) ? "TKP" : "")));
	}
	
	public static String getSiteShortForm() {
		return isHKAH() ? "HKAH-SR" : (isTWAH() ? "HKAH-TW" : (isAMC1() ? "AMC-CWB" : (isAMC2() ? "AMC-TKP" : "")));
	}
	
	public static String getSiteShortForm(String siteCode) {
		return SITE_CODE_HKAH.equals(siteCode) ? "HKAH-SR" : (SITE_CODE_TWAH.equals(siteCode) ? "HKAH-TW" : 
			(SITE_CODE_AMC1.equals(siteCode) ? "AMC-CWB" : (SITE_CODE_AMC2.equals(siteCode) ? "AMC-TKP" : "")));
	}
	
	public static String getDBLinkPortal(String siteCode) {
		return SITE_CODE_HKAH.equalsIgnoreCase(siteCode) ? DBLINK_PORTAL_HKAH : 
			(SITE_CODE_TWAH.equalsIgnoreCase(siteCode) ? DBLINK_PORTAL_TWAH : 
				(SITE_CODE_AMC1.equalsIgnoreCase(siteCode) ? DBLINK_PORTAL_AMC1 : 
					(SITE_CODE_AMC2.equalsIgnoreCase(siteCode) ? DBLINK_PORTAL_AMC2 : "")));
	}

	public static String MAIL_HOST = null;
	public static String MAIL_SMTP_PORT = null;
	public static String MAIL_SMTP_AUTH = null;
	public static String MAIL_SMTP_USERNAME = null;
	public static String MAIL_SMTP_PASSWORD = null;
	public static String MAIL_SMTP_CONNECTIONTIMEOUT = null;
	public static String MAIL_SMTP_TIMEOUT = null;
	public static String MAIL_ALERT = null;
	public static String MAIL_TESTER = null;
	public static String MAIL_ADMIN = null;
	public static String MAIL_ALLSTAFF = null;

	public static boolean JOB_SEND_BILL_NOTICE = true;
	public static boolean JOB_SEND_PR_APPROVAL = true;
	public static boolean JOB_SEND_MKUP_PRICE_HKAH = true;
	public static boolean JOB_SEND_MKUP_PRICE_TWAH = true;
	public static boolean JOB_SEND_ITEM_OUTSTANDING_NOTICE = true;

	public static String DOCTOR_PHOTO_SRC = null;
	public static String DOCTOR_PHOTO_DEST = null;

	public static String FS_SCANPC_HOST = null;
	public static String FS_FORM_DEST = null;

	public static String INTRANET_ANOTHER_SITE_URL = null;
	public static String INTRANET_URL = null;
	public static String OFFSITE_URL = null;

	public static boolean CAS_SINGLESIGNON = false;
	public static String CAS_SINGLESIGNOUTURL = null;

	public static boolean READ_DB_SERVER = false;
	public static String READ_DB_SERVER_URL = null;
}