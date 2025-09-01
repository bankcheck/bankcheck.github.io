package com.hkah.util.file;

import java.io.File;
import java.io.FileInputStream;
import java.util.Properties;

import com.hkah.config.ServerConfig;
import com.hkah.constant.ConstantsServerSide;

public class FileProperties {

	private static final String DEFAULT_CONFIG = "/WebConfig/serverConfig.properties";

	public static void readProperties() {
		Properties properties = readProperties(DEFAULT_CONFIG);
		ConstantsServerSide.UPLOAD_FOLDER = ServerConfig.getUploadFolder(properties);
		ConstantsServerSide.UPLOAD_WEB_FOLDER = ServerConfig.getUploadWebFolder(properties);
		ConstantsServerSide.INDEX_FOLDER = ServerConfig.getIndexFolder(properties);
		ConstantsServerSide.POLICY_FOLDER = ServerConfig.getPolicyFolder(properties);
		ConstantsServerSide.TEMP_FOLDER = ServerConfig.getTempFolder(properties);
		ConstantsServerSide.DOCUMENT_FOLDER = ServerConfig.getDocumentFolder(properties);

		ConstantsServerSide.EMR_SERVER = ServerConfig.getEMRServer(properties);
		ConstantsServerSide.EMR_FOLDER = ServerConfig.getEMRFolder(properties);

		ConstantsServerSide.DEBUG = ServerConfig.isDebug(properties);
		ConstantsServerSide.CORE_SERVER = ServerConfig.isCore(properties);
		ConstantsServerSide.SECURE_SERVER = ServerConfig.isSecure(properties);
		ConstantsServerSide.BACKEND_SERVER = ServerConfig.isBackEnd(properties);
		ConstantsServerSide.EMAIL_SERVER = ServerConfig.isEmail(properties);
		ConstantsServerSide.LOAD_BALANCE = ServerConfig.isLoadBalance(properties);
		ConstantsServerSide.SITE_CODE = ServerConfig.getSiteCode(properties);
		ConstantsServerSide.SECURE_PORT = ServerConfig.getSecurePort(properties);

		ConstantsServerSide.MAIL_HOST = ServerConfig.getMailHost(properties);
		ConstantsServerSide.MAIL_SMTP_PORT = ServerConfig.getMailSmtpPort(properties);
		ConstantsServerSide.MAIL_SMTP_AUTH = ServerConfig.getMailSmtpAuth(properties);
		ConstantsServerSide.MAIL_SMTP_USERNAME = ServerConfig.getMailSmtpUsername(properties);
		ConstantsServerSide.MAIL_SMTP_PASSWORD = ServerConfig.getMailSmtpPassword(properties);
		ConstantsServerSide.MAIL_SMTP_CONNECTIONTIMEOUT = ServerConfig.getMailSmtpConnectiontimeout(properties);
		ConstantsServerSide.MAIL_SMTP_TIMEOUT = ServerConfig.getMailSmtpTimeout(properties);
		ConstantsServerSide.MAIL_ALERT = ServerConfig.getMailAlert(properties);
		ConstantsServerSide.MAIL_ADMIN = ServerConfig.getMailAdmin(properties);
		ConstantsServerSide.MAIL_ALLSTAFF = ServerConfig.getMailAllStaff(properties);

		ConstantsServerSide.JOB_SEND_BILL_NOTICE = ServerConfig.isJobSendBillNotice(properties);
		ConstantsServerSide.JOB_SEND_PR_APPROVAL = ServerConfig.isJobSendPRApproval(properties);
		ConstantsServerSide.JOB_SEND_MKUP_PRICE_HKAH = ServerConfig.isJobSendMkupPriceHkah(properties);
		ConstantsServerSide.JOB_SEND_MKUP_PRICE_TWAH = ServerConfig.isJobSendMkupPriceTwah(properties);
		ConstantsServerSide.JOB_SEND_ITEM_OUTSTANDING_NOTICE = ServerConfig.isJobSendItemOustandingNotice(properties);

		ConstantsServerSide.DOCTOR_PHOTO_SRC = ServerConfig.getDoctorPhotoSrc(properties);
		ConstantsServerSide.DOCTOR_PHOTO_DEST = ServerConfig.getDoctorPhotoDest(properties);

		ConstantsServerSide.FS_SCANPC_HOST = ServerConfig.getFsScanPcHost(properties);
		ConstantsServerSide.FS_FORM_DEST = ServerConfig.getFsFormDesc(properties);

		ConstantsServerSide.INTRANET_ANOTHER_SITE_URL = ServerConfig.getIntranetAnotherSiteUrl(properties);
		ConstantsServerSide.INTRANET_URL = ServerConfig.getIntranetUrl(properties);
		ConstantsServerSide.OFFSITE_URL = ServerConfig.getOffsiteUrl(properties);

		ConstantsServerSide.CAS_SINGLESIGNON = ServerConfig.isCasSinglesignon(properties);
		ConstantsServerSide.CAS_SINGLESIGNOUTURL = ServerConfig.getCasSinglesignouturl(properties);

		ConstantsServerSide.READ_DB_SERVER = ServerConfig.isReadDBServer(properties);
		ConstantsServerSide.READ_DB_SERVER_URL = ServerConfig.getReadDBServerUrl(properties);
	}

	private static Properties readProperties(String fileName) {
		try {
			Properties properties = new Properties();
			properties.load(new FileInputStream(new File(fileName)));
			return properties;
		} catch (Exception e) {
			return null;
		}
	}
}