/*
 * Created on July 10, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.config;

import java.util.Properties;
import java.util.ResourceBundle;

import com.hkah.constant.ConstantsVariable;

public class ServerConfig {

	private static final String UPLOAD_FOLDER_PROPERTIES = "upload.folder";
	private static final String UPLOAD_WEB_FOLDER_PROPERTIES = "upload.web.folder";
	private static final String INDEX_FOLDER_PROPERTIES = "index.folder";
	private static final String POLICY_FOLDER_PROPERTIES = "policy.folder";
	private static final String TEMP_FOLDER_PROPERTIES = "temp.folder";
	private static final String DOCUMENT_FOLDER_PROPERTIES = "document.folder";
	private static final String EMR_SERVER_PROPERTIES = "emr.server";
	private static final String EMR_FOLDER_PROPERTIES = "emr.folder";

	private static final String DEBUG_PROPERTIES = "debug";
	private static final String CORE_PROPERTIES = "core";
	private static final String SECURE_PROPERTIES = "secure";
	private static final String BACKEND_PROPERTIES = "backend";
	private static final String EMAIL_PROPERTIES = "email";
	private static final String LOAD_BALANCE_PROPERTIES = "load.balance";
	private static final String SECURE_PORT_PROPERTIES = "secure.port";

	private static final String SITE_CODE_PROPERTIES = "site.code";

	public static final String MAIL_HOST_PROPERTIES = "mail.host";
	public static final String MAIL_SMTP_PORT_PROPERTIES = "mail.smtp.port";
	public static final String MAIL_SMTP_AUTH_PROPERTIES = "mail.smtp.auth";
	public static final String MAIL_SMTP_AUTH_USERNAME = "mail.smtp.username";
	public static final String MAIL_SMTP_AUTH_PASSWORD = "mail.smtp.password";
	public static final String MAIL_SMTP_CONNECTIONTIMEOUT_PROPERTIES = "mail.smtp.connectiontimeout";
	public static final String MAIL_SMTP_TIMEOUT_PROPERTIES = "mail.smtp.timeout";
	public static final String MAIL_ALERT_PROPERTIES = "mail.from.alert";
	public static final String MAIL_TESTER_PROPERTIES = "mail.from.tester";
	public static final String MAIL_ADMIN_PROPERTIES = "mail.from.admin";
	public static final String MAIL_ALLSTAFF_PROPERTIES = "mail.to.allStaff";

	public static final String JOB_SEND_BILL_NOTICE_PROPERTIES = "job.send.bill.notice";
	public static final String JOB_SEND_PR_APPROVAL_PROPERTIES = "job.send.pr.approval";
	public static final String JOB_SEND_MKUP_PRICE_HKAH = "job.send.mkup.price.hkah";
	public static final String JOB_SEND_MKUP_PRICE_TWAH = "job.send.mkup.price.twah";
	public static final String JOB_SEND_ITEM_OUTSTANDING_NOTICE = "job.send.item.outstanding.notice";

	public static final String DOCTOR_PHOTO_SRC_PROPERTIES = "doctor.photo.src";
	public static final String DOCTOR_PHOTO_DEST_PROPERTIES = "doctor.photo.dest";

	public static final String FS_SCAN_PC_HOST_PROPERTIES = "fs.scanPc.host";
	public static final String FS_FORM_DESC_PROPERTIES = "fs.form.dest";

	public static final String INTRANET_ANOTHER_SITE_URL_PROPERTIES = "intranet.another.site.url";
	public static final String INTRANET_URL_PROPERTIES = "intranet.url";
	public static final String OFFSITE_URL_PROPERTIES = "offsite.url";

	public static final String CAS_SINGLESIGNON_PROPERTIES = "cas.singleSignOn";
	public static final String CAS_SINGLESIGNOUTURL_PROPERTIES = "cas.singleSignOutUrl";

	public static final String READ_DB_SERVER_PROPERTIES = "read.db.server";
	public static final String READ_DB_SERVERURL_PROPERTIES = "read.db.server.url";

	private static ResourceBundle DEFAULT_RESOURCE = ResourceBundle.getBundle("serverConfig");

	private static String getProperty(Properties properties, String key) {
		String result = null;

		// get value from properties
		if (properties != null) {
			try {
				result = properties.getProperty(key);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		// get value from default
		if (result == null) {
			try {
				result = DEFAULT_RESOURCE.getString(key);
			} catch (Exception e) {
			}
		}

		return result;
	}

	public static String getUploadFolder(Properties properties) {
		return getProperty(properties, UPLOAD_FOLDER_PROPERTIES);
	}

	public static String getUploadWebFolder(Properties properties) {
		return getProperty(properties, UPLOAD_WEB_FOLDER_PROPERTIES);
	}

	public static String getIndexFolder(Properties properties) {
		return getProperty(properties, INDEX_FOLDER_PROPERTIES);
	}

	public static String getPolicyFolder(Properties properties) {
		return getProperty(properties, POLICY_FOLDER_PROPERTIES);
	}

	public static String getTempFolder(Properties properties) {
		return getProperty(properties, TEMP_FOLDER_PROPERTIES);
	}

	public static String getDocumentFolder(Properties properties) {
		return getProperty(properties, DOCUMENT_FOLDER_PROPERTIES);
	}

	public static String getEMRServer(Properties properties) {
		return getProperty(properties, EMR_SERVER_PROPERTIES);
	}

	public static String getEMRFolder(Properties properties) {
		return getProperty(properties, EMR_FOLDER_PROPERTIES);
	}

	public static boolean isDebug(Properties properties) {
		return ConstantsVariable.YES_VALUE.equals(getProperty(properties, DEBUG_PROPERTIES));
	}

	public static boolean isCore(Properties properties) {
		return ConstantsVariable.YES_VALUE.equals(getProperty(properties, CORE_PROPERTIES));
	}

	public static boolean isSecure(Properties properties) {
		return ConstantsVariable.YES_VALUE.equals(getProperty(properties, SECURE_PROPERTIES));
	}

	public static boolean isBackEnd(Properties properties) {
		return ConstantsVariable.YES_VALUE.equals(getProperty(properties, BACKEND_PROPERTIES));
	}

	public static boolean isEmail(Properties properties) {
		return ConstantsVariable.YES_VALUE.equals(getProperty(properties, EMAIL_PROPERTIES));
	}

	public static boolean isLoadBalance(Properties properties) {
		return ConstantsVariable.YES_VALUE.equals(getProperty(properties, LOAD_BALANCE_PROPERTIES));
	}
	
	public static String getSecurePort(Properties properties) {
		return getProperty(properties, SECURE_PORT_PROPERTIES);
	}
	
	public static String getSiteCode(Properties properties) {
		return getProperty(properties, SITE_CODE_PROPERTIES);
	}

	public static String getMailHost(Properties properties) {
		return getProperty(properties, MAIL_HOST_PROPERTIES);
	}

	public static String getMailSmtpPort(Properties properties) {
		return getProperty(properties, MAIL_SMTP_PORT_PROPERTIES);
	}

	public static String getMailSmtpAuth(Properties properties) {
		return getProperty(properties, MAIL_SMTP_AUTH_PROPERTIES);
	}

	public static String getMailSmtpUsername(Properties properties) {
		return getProperty(properties, MAIL_SMTP_AUTH_USERNAME);
	}

	public static String getMailSmtpPassword(Properties properties) {
		return getProperty(properties, MAIL_SMTP_AUTH_PASSWORD);
	}

	public static String getMailSmtpConnectiontimeout(Properties properties) {
		return getProperty(properties, MAIL_SMTP_CONNECTIONTIMEOUT_PROPERTIES);
	}

	public static String getMailSmtpTimeout(Properties properties) {
		return getProperty(properties, MAIL_SMTP_TIMEOUT_PROPERTIES);
	}

	public static String getMailAlert(Properties properties) {
		return getProperty(properties, MAIL_ALERT_PROPERTIES);
	}

	public static String getMailTester(Properties properties) {
		return getProperty(properties, MAIL_TESTER_PROPERTIES);
	}

	public static String getMailAdmin(Properties properties) {
		return getProperty(properties, MAIL_ADMIN_PROPERTIES);
	}

	public static String getMailAllStaff(Properties properties) {
		return getProperty(properties, MAIL_ALLSTAFF_PROPERTIES);
	}

	public static boolean isJobSendBillNotice(Properties properties) {
		return ConstantsVariable.YES_VALUE.equals(getProperty(properties, JOB_SEND_BILL_NOTICE_PROPERTIES));
	}

	public static boolean isJobSendPRApproval(Properties properties) {
		return ConstantsVariable.YES_VALUE.equals(getProperty(properties, JOB_SEND_PR_APPROVAL_PROPERTIES));
	}

	public static boolean isJobSendMkupPriceHkah(Properties properties) {
		return ConstantsVariable.YES_VALUE.equals(getProperty(properties, JOB_SEND_MKUP_PRICE_HKAH));
	}

	public static boolean isJobSendMkupPriceTwah(Properties properties) {
		return ConstantsVariable.YES_VALUE.equals(getProperty(properties, JOB_SEND_MKUP_PRICE_TWAH));
	}

	public static boolean isJobSendItemOustandingNotice(Properties properties) {
		return ConstantsVariable.YES_VALUE.equals(getProperty(properties, JOB_SEND_ITEM_OUTSTANDING_NOTICE));
	}

	public static String getDoctorPhotoSrc(Properties properties) {
		return getProperty(properties, DOCTOR_PHOTO_SRC_PROPERTIES);
	}

	public static String getDoctorPhotoDest(Properties properties) {
		return getProperty(properties, DOCTOR_PHOTO_DEST_PROPERTIES);
	}

	public static String getFsFormDesc(Properties properties) {
		return getProperty(properties, FS_FORM_DESC_PROPERTIES);
	}

	public static String getFsScanPcHost(Properties properties) {
		return getProperty(properties, FS_SCAN_PC_HOST_PROPERTIES);
	}


	public static String getIntranetAnotherSiteUrl(Properties properties) {
		return getProperty(properties, INTRANET_ANOTHER_SITE_URL_PROPERTIES);
	}

	public static String getIntranetUrl(Properties properties) {
		return getProperty(properties, INTRANET_URL_PROPERTIES);
	}

	public static String getOffsiteUrl(Properties properties) {
		return getProperty(properties, OFFSITE_URL_PROPERTIES);
	}

	public static boolean isCasSinglesignon(Properties properties) {
		return ConstantsVariable.YES_VALUE.equals(getProperty(properties, CAS_SINGLESIGNON_PROPERTIES));
	}

	public static String getCasSinglesignouturl(Properties properties) {
		return getProperty(properties, CAS_SINGLESIGNOUTURL_PROPERTIES);
	}

	public static boolean isReadDBServer(Properties properties) {
		return ConstantsVariable.YES_VALUE.equals(getProperty(properties, READ_DB_SERVER_PROPERTIES));
	}

	public static String getReadDBServerUrl(Properties properties) {
		return getProperty(properties, READ_DB_SERVERURL_PROPERTIES);
	}
}