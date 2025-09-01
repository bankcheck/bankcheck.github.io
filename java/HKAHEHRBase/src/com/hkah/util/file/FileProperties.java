package com.hkah.util.file;

import java.io.File;
import java.io.FileInputStream;
import java.util.Properties;

import org.apache.log4j.Logger;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.server.config.ServerConfig;

public class FileProperties {
	protected static Logger logger = Logger.getLogger(FileProperties.class);
	
	public static void readProperties() {
		logger.debug("readProperties");
		
		ConstantsServerSide.DEBUG = "Y".equals(ServerConfig.getObject().getDebug());
		ConstantsServerSide.SITE_CODE = ServerConfig.getObject().getSiteCode();
		ConstantsServerSide.SITE_ENV = ServerConfig.getObject().getSiteEnv();
		ConstantsServerSide.JNDI_NAME_HATS = ServerConfig.getObject().getJndiNameHATS();
		ConstantsServerSide.JNDI_NAME_CIS = ServerConfig.getObject().getJndiNameCIS();
		ConstantsServerSide.JNDI_NAME_LIS = ServerConfig.getObject().getJndiNameLIS();
		ConstantsServerSide.MAIL_HOST = ServerConfig.getObject().getMailHost();
		ConstantsServerSide.MAIL_SMTP_PORT = ServerConfig.getObject().getMailSmtpPort();
		ConstantsServerSide.MAIL_PROTOCOL = ServerConfig.getObject().getMailProtocol();
		ConstantsServerSide.MAIL_SMTP_AUTH = ServerConfig.getObject().getMailSmtpAuth();
		ConstantsServerSide.MAIL_SMTP_USERNAME = ServerConfig.getObject().getMailSmtpUsername();
		ConstantsServerSide.MAIL_SMTP_PASSWORD = ServerConfig.getObject().getMailSmtpPassword();
		ConstantsServerSide.MAIL_SMTP_CONNECTIONTIMEOUT = ServerConfig.getObject().getMailSmtpConnectiontimeout();
		ConstantsServerSide.MAIL_SMTP_TIMEOUT = ServerConfig.getObject().getMailSmtpTimeout();
		ConstantsServerSide.MAIL_ALERT = ServerConfig.getObject().getMailFromAlert();
		ConstantsServerSide.MAIL_TESTER = ServerConfig.getObject().getMailFromTester();
		ConstantsServerSide.MAIL_ADMIN = ServerConfig.getObject().getMailFromAdmin();
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