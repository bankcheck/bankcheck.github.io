package com.hkah.shared.model;

import java.io.Serializable;

public class ClientConfigObject implements Serializable {

	public static final long serialVersionUID = 1L;
	private String versionNo = null;
	private String defaultProtocol = null;
	private String defaultHost = null;
	private String defaultPort = null;
	private String portalHost = null;
	private String portalPort = null;
	private String contextRoot = null;
	private String hkHost = null;
	private String hkPort = null;
	private String contextRootHk = null;
	private String moduleCode = null;
	private String jndiName = null;
	private String appletName = null;
	private String txServlet = null;
	private String masterServlet = null;
	private String siteCode = null;
	private String siteName = null;
	private String defaultUserID = null;
	private String defaultUserName = null;
	private String defaultUserDeptCode = null;
	private String serverFileBasePath = null;
	// CMS
	private String systemEnv = null;
	private String systemSite = null;
	private String systemVerBuild = null;
	private String systemVerNum = null;
	private String systemVerPhrase = null;
	private String systemVerYear = null;
	private String uploadPath = null;
	private String cmsFilePath = null;
	private String attachmentFileSubPath = null;
	
	public String getVersionNo() {
		return versionNo;
	}

	public void setVersionNo(String versionNo) {
		this.versionNo = versionNo;
	}

	public String getDefaultProtocol() {
		return defaultProtocol;
	}

	public void setDefaultProtocol(String defaultProtocol) {
		this.defaultProtocol = defaultProtocol;
	}

	public String getDefaultHost() {
		return defaultHost;
	}

	public void setDefaultHost(String defaultHost) {
		this.defaultHost = defaultHost;
	}

	public String getDefaultPort() {
		return defaultPort;
	}

	public void setDefaultPort(String defaultPort) {
		this.defaultPort = defaultPort;
	}

	public String getPortalHost() {
		return portalHost;
	}

	public void setPortalHost(String portalHost) {
		this.portalHost = portalHost;
	}

	public String getPortalPort() {
		return portalPort;
	}

	public void setPortalPort(String portalPort) {
		this.portalPort = portalPort;
	}

	public String getContextRoot() {
		return contextRoot;
	}

	public void setContextRoot(String contextRoot) {
		this.contextRoot = contextRoot;
	}

	public String getHkHost() {
		return hkHost;
	}

	public void setHkHost(String hkHost) {
		this.hkHost = hkHost;
	}

	public String getHkPort() {
		return hkPort;
	}

	public void setHkPort(String hkPort) {
		this.hkPort = hkPort;
	}

	public String getContextRootHk() {
		return contextRootHk;
	}

	public void setContextRootHk(String contextRootHk) {
		this.contextRootHk = contextRootHk;
	}

	public String getModuleCode() {
		return moduleCode;
	}

	public void setModuleCode(String moduleCode) {
		this.moduleCode = moduleCode;
	}

	public String getJndiName() {
		return jndiName;
	}

	public void setJndiName(String jndiName) {
		this.jndiName = jndiName;
	}

	public String getAppletName() {
		return appletName;
	}

	public void setAppletName(String appletName) {
		this.appletName = appletName;
	}

	public String getTxServlet() {
		return txServlet;
	}

	public void setTxServlet(String txServlet) {
		this.txServlet = txServlet;
	}

	public String getMasterServlet() {
		return masterServlet;
	}

	public void setMasterServlet(String masterServlet) {
		this.masterServlet = masterServlet;
	}

	public String getSiteCode() {
		return siteCode;
	}

	public void setSiteCode(String siteCode) {
		this.siteCode = siteCode;
	}

	public String getSiteName() {
		return siteName;
	}

	public void setSiteName(String siteName) {
		this.siteName = siteName;
	}

	public String getDefaultUserID() {
		return defaultUserID;
	}

	public void setDefaultUserID(String defaultUserID) {
		this.defaultUserID = defaultUserID;
	}

	public String getDefaultUserName() {
		return defaultUserName;
	}

	public void setDefaultUserName(String defaultUserName) {
		this.defaultUserName = defaultUserName;
	}

	public String getDefaultUserDeptCode() {
		return defaultUserDeptCode;
	}

	public void setDefaultUserDeptCode(String defaultUserDeptCode) {
		this.defaultUserDeptCode = defaultUserDeptCode;
	}

	public String getServerFileBasePath() {
		return serverFileBasePath;
	}

	public void setServerFileBasePath(String serverFileBasePath) {
		this.serverFileBasePath = serverFileBasePath;
	}
	
	public String getSystemEnv() {
		return systemEnv;
	}
	
	public void setSystemEnv(String systemEnv) {
		this.systemEnv = systemEnv;
	}
	
	public String getSystemSite() {
		return systemSite;
	}
	
	public void setSystemSite(String systemSite) {
		this.systemSite = systemSite;
	}
	
	public String getSystemVerBuild() {
		return systemVerBuild;
	}
	
	public void setSystemVerBuild(String systemVerBuild) {
		this.systemVerBuild = systemVerBuild;
	}
	
	public String getSystemVerNum() {
		return systemVerNum;
	}
	
	public void setSystemVerNum(String systemVerNum) {
		this.systemVerNum = systemVerNum;
	}
	
	public String getSystemVerPhrase() {
		return systemVerPhrase;
	}
	
	public void setSystemVerPhrase(String systemVerPhrase) {
		this.systemVerPhrase = systemVerPhrase;
	}
	
	public String getSystemVerYear() {
		return systemVerYear;
	}
	
	public void setSystemVerYear(String systemVerYear) {
		this.systemVerYear = systemVerYear;
	}

	public String getUploadPath() {
		return uploadPath;
	}

	public void setUploadPath(String uploadPath) {
		this.uploadPath = uploadPath;
	}

	public String getCmsFilePath() {
		return cmsFilePath;
	}

	public void setCmsFilePath(String cmsFilePath) {
		this.cmsFilePath = cmsFilePath;
	}

	public String getAttachmentFileSubPath() {
		return attachmentFileSubPath;
	}

	public void setAttachmentFileSubPath(String attachmentFileSubPath) {
		this.attachmentFileSubPath = attachmentFileSubPath;
	}
}