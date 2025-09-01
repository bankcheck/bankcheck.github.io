/*
 * Created on July 3, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.server.config;

import java.util.ResourceBundle;

import com.hkah.ehr.model.ServerConfigObject;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ServerConfig {
	private static ServerConfigObject serverConfigObject = null;

	private static ResourceBundle resource = ResourceBundle.getBundle("ServerConfig");
	private static final String DEBUG = "system.debug";
	private static final String JNDI_NAME_HATS = "system.jndiName.hats";
	private static final String JNDI_NAME_CIS = "system.jndiName.cis";
	private static final String JNDI_NAME_LIS = "system.jndiName.lis";
	private static final String JNDI_NAME_PHAR = "system.jndiName.phar";
	private static final String SITE_CODE = "site.code";
	private static final String SITE_ENV = "site.env";
	private static final String MAIL_HOST = "mail.host";
	private static final String MAIL_SMTP_PORT = "mail.smtp.port";
	private static final String MAIL_PROTOCOL = "mail.protocol";
	private static final String MAIL_SMTP_AUTH = "mail.smtp.auth";
	private static final String MAIL_SMTP_USERNAME = "mail.smtp.username";
	private static final String MAIL_SMTP_PASSWORD = "mail.smtp.password";
	private static final String MAIL_SMTP_CONNECTIONTIMEOUT = "mail.smtp.connectiontimeout";
	private static final String MAIL_SMTP_TIMEOUT = "mail.smtp.timeout";
	private static final String MAIL_FROM_ALERT = "mail.from.alert";
	private static final String MAIL_FROM_TESTER = "mail.from.tester";
	private static final String MAIL_FROM_ADMIN = "mail.from.admin";
	
	public static ServerConfigObject getObject() {
		if (serverConfigObject == null) {
			serverConfigObject = new ServerConfigObject();
			serverConfigObject.setDebug(getValueByKey(DEBUG));
			serverConfigObject.setJndiNameHATS(getValueByKey(JNDI_NAME_HATS));
			serverConfigObject.setJndiNameCIS(getValueByKey(JNDI_NAME_CIS));
			serverConfigObject.setJndiNameLIS(getValueByKey(JNDI_NAME_LIS));
			serverConfigObject.setJndiNamePHAR(getValueByKey(JNDI_NAME_PHAR));
			serverConfigObject.setSiteCode(getValueByKey(SITE_CODE));
			serverConfigObject.setSiteEnv(getValueByKey(SITE_ENV));
			serverConfigObject.setMailHost(getValueByKey(MAIL_HOST));
			serverConfigObject.setMailSmtpPort(getValueByKey(MAIL_SMTP_PORT));
			serverConfigObject.setMailProtocol(getValueByKey(MAIL_PROTOCOL));
			serverConfigObject.setMailSmtpAuth(getValueByKey(MAIL_SMTP_AUTH));
			serverConfigObject.setMailSmtpUsername(getValueByKey(MAIL_SMTP_USERNAME));
			serverConfigObject.setMailSmtpPassword(getValueByKey(MAIL_SMTP_PASSWORD));
			serverConfigObject.setMailSmtpConnectiontimeout(getValueByKey(MAIL_SMTP_CONNECTIONTIMEOUT));
			serverConfigObject.setMailSmtpTimeout(getValueByKey(MAIL_SMTP_TIMEOUT));
			serverConfigObject.setMailFromAlert(getValueByKey(MAIL_FROM_ALERT));
			serverConfigObject.setMailFromTester(getValueByKey(MAIL_FROM_TESTER));
			serverConfigObject.setMailFromAdmin(getValueByKey(MAIL_FROM_ADMIN));
			
		}
		return serverConfigObject;
	}

	private static String getValueByKey(String key) {
		if (resource.containsKey(key)) {
			return resource.getString(key);
		} else {
			return "";
		}
	}
}