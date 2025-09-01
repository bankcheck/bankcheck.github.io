/*
 * Created on July 3, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.server.config;

import java.util.ResourceBundle;

import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.ClientConfigObject;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ClientConfig {
	private static ClientConfigObject clientConfigObject = null;

	private static ResourceBundle resource = ResourceBundle.getBundle("ClientConfig");
	private static final String VERSION_NUMBER = "system.version.number";
	private static final String DEFAULT_PROTOCAL = "system.default.protocol";
	private static final String DEFAULT_HOST = "system.default.host";
	private static final String DEFAULT_PORT = "system.default.port";
	private static final String PORTAL_HOST = "portal.host";
	private static final String PORTAL_PORT = "portal.port";
	private static final String CONTEXT_ROOT = "system.contextRoot";
	private static final String HK_HOST = "system.hk.host";
	private static final String HK_PORT = "system.hk.port";
	private static final String CONTEXT_ROOT_HK = "system.hk.contextRoot";
	private static final String MODULE_CODE = "system.module.code";
	private static final String JNDI_NAME = "system.jndiName";
	private static final String APPLET_NAME = "client.print.applet.name";
	private static final String TX_SERVLET = "server.tx.servlet";
	private static final String MASTER_SERVLET = "server.master.servlet";
	private static final String SITE_CODE = "login.site.code";
	private static final String SITE_NAME = "login.site.name";
	private static final String DEFAULT_USER_ID = "login.user.id";
	private static final String DEFAULT_USER_NAME = "login.user.name";
	private static final String DEFAULT_USER_DEPTCODE = "login.user.deptCode";
	private static final String SERVER_FILE_BASEPATH = "server.file.basePath";
	// CMS
	private static final String SYSTEM_ENV = "system.env";
	private static final String SYSTEM_SITE = "system.site";
	private static final String SYSTEM_VER_BUILD = "system.ver.build";
	private static final String SYSTEM_VER_NUM = "system.ver.num";
	private static final String SYSTEM_VER_PHRASE = "system.ver.phrase";
	private static final String SYSTEM_VER_YEAR = "system.ver.year";
	private static final String UPLOAD_PATH = "upload.path";
	private static final String CMS_FILE_PATH = "cms.file.path";
	private static final String ATTACHMENT_FILE_SUBPATH = "attachment.file.subPath";
	
	public static ClientConfigObject getObject() {
		if (clientConfigObject == null) {
			clientConfigObject = new ClientConfigObject();
			clientConfigObject.setVersionNo(getValueByKey(VERSION_NUMBER));
			clientConfigObject.setDefaultProtocol(getValueByKey(DEFAULT_PROTOCAL));
			clientConfigObject.setDefaultHost(getValueByKey(DEFAULT_HOST));
			clientConfigObject.setDefaultPort(getValueByKey(DEFAULT_PORT));
			clientConfigObject.setPortalHost(getValueByKey(PORTAL_HOST));
			clientConfigObject.setPortalPort(getValueByKey(PORTAL_PORT));
			clientConfigObject.setContextRoot(getValueByKey(CONTEXT_ROOT));
			clientConfigObject.setHkHost(getValueByKey(HK_HOST));
			clientConfigObject.setHkPort(getValueByKey(HK_PORT));
			clientConfigObject.setContextRootHk(getValueByKey(CONTEXT_ROOT_HK));
			clientConfigObject.setModuleCode(getValueByKey(MODULE_CODE));
			clientConfigObject.setJndiName(getValueByKey(JNDI_NAME));
			clientConfigObject.setAppletName(getValueByKey(APPLET_NAME));
			clientConfigObject.setTxServlet(getValueByKey(TX_SERVLET));
			clientConfigObject.setMasterServlet(getValueByKey(MASTER_SERVLET));
			clientConfigObject.setSiteCode(getValueByKey(SITE_CODE));
			clientConfigObject.setSiteName(getValueByKey(SITE_NAME));
			clientConfigObject.setDefaultUserID(getValueByKey(DEFAULT_USER_ID));
			clientConfigObject.setDefaultUserName(getValueByKey(DEFAULT_USER_NAME));
			clientConfigObject.setDefaultUserDeptCode(getValueByKey(DEFAULT_USER_DEPTCODE));
			clientConfigObject.setServerFileBasePath(getValueByKey(SERVER_FILE_BASEPATH));
			clientConfigObject.setSystemEnv(getValueByKey(SYSTEM_ENV));
			clientConfigObject.setSystemSite(getValueByKey(SYSTEM_SITE));
			clientConfigObject.setSystemVerBuild(getValueByKey(SYSTEM_VER_BUILD));
			clientConfigObject.setSystemVerNum(getValueByKey(SYSTEM_VER_NUM));
			clientConfigObject.setSystemVerPhrase(getValueByKey(SYSTEM_VER_PHRASE));
			clientConfigObject.setSystemVerYear(getValueByKey(SYSTEM_VER_YEAR));
			clientConfigObject.setUploadPath(getValueByKey(UPLOAD_PATH));
			clientConfigObject.setCmsFilePath(getValueByKey(CMS_FILE_PATH));
			clientConfigObject.setAttachmentFileSubPath(getValueByKey(ATTACHMENT_FILE_SUBPATH));
		}
		return clientConfigObject;
	}

	private static String getValueByKey(String key) {
		if (resource.containsKey(key)) {
			return resource.getString(key);
		} else {
			return ConstantsVariable.EMPTY_VALUE;
		}
	}
}