/*
 * Created on July 3, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.shared.model;

import java.io.Serializable;

import com.hkah.shared.constants.ConstantsVariable;

/**
 * To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Generation - Code and Comments
 */

public class UserInfo implements Serializable {

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;
	private String userID = null;
	private String userName = null;
	private String siteCode = null;
	private String siteName = null;
	private String parentHost = null;
	private String deptCode = null;
	private String otherCode = null;
	private String cashierCode = null;
	private boolean isInPatient = false;
	private boolean isOutPatient = false;
	private boolean isDayCase = false;
	private boolean isPBO = false;
	private boolean isManager = false;
	private String userTeam = null;
	private String ssoSessionID = null;
	private String ssoModuleCode = null;
	private String ssoUserID = null;

	/*
	 * GET/SET FUNCTIONS
	 */
	public UserInfo() {
		super();
	}

	public void clear() {
		userID = null;
		userName = null;
		siteCode = null;
		siteName = null;
		deptCode = null;
		otherCode = null;
		cashierCode = null;
		isInPatient = false;
		isOutPatient = false;
		isDayCase = false;
		isPBO = false;
		isManager = false;
		userTeam = null;
		ssoSessionID = null;
		ssoModuleCode = null;
	}

	/***************************************************************************
	 * getter and setter for local variable
	 **************************************************************************/

	/**
	 * @return Returns the userID.
	 */
	public String getUserID() {
		return userID;
	}

	/**
	 * @param userID The userID to set.
	 */
	public void setUserID(String userID) {
		// USRID
		this.userID = userID;
	}

	/**
	 * @return Returns the userName.
	 */
	public String getUserName() {
		return userName;
	}

	/**
	 * @param userName The userName to set.
	 */
	public void setUserName(String userName) {
		// USRNAME
		this.userName = userName;
	}

	/**
	 * @return the siteCode
	 */
	public String getSiteCode() {
		return siteCode;
	}

	/**
	 * @param siteCode the siteCode to set
	 */
	public void setSiteCode(String siteCode) {
		// STECODE
		this.siteCode = siteCode;
	}

	/**
	 * @return the siteName
	 */
	public String getSiteName() {
		return siteName;
	}

	/**
	 * @param siteName the siteName to set
	 */
	public void setSiteName(String siteName) {
		// STENAME
		this.siteName = siteName;
	}

	public String getParentHost() {
		return parentHost;
	}

	public void setParentHost(String parentHost) {
		this.parentHost = parentHost;
	}

	/**
	 * @return Returns the deptCode.
	 */
	public String getDeptCode() {
		return deptCode;
	}

	/**
	 * @param deptCode The deptCode to set.
	 */
	public void setDeptCode(String deptCode) {
		// DPTCODE
		this.deptCode = deptCode;
	}

	/**
	 * @return Returns the otherCode.
	 */
	public String getOtherCode() {
		return otherCode;
	}

	/**
	 * @param otherCode The otherCode to set.
	 */
	public void setOtherCode(String otherCode) {
		// OTHERCODE
		this.otherCode = otherCode;
	}

	/**
	 * @return Returns the isInPatient.
	 */
	public boolean isInPatient() {
		return isInPatient;
	}

	/**
	 * @param isInPatient The isInPatient to set.
	 */
	public void setInPatient(String inPatient) {
		this.isInPatient = !ConstantsVariable.ZERO_VALUE.equals(inPatient);
	}

	/**
	 * @return the isOutPatient
	 */
	public boolean isOutPatient() {
		return isOutPatient;
	}

	/**
	 * @param isOutPatient the isOutPatient to set
	 */
	public void setOutPatient(String outPatient) {
		this.isOutPatient = !ConstantsVariable.ZERO_VALUE.equals(outPatient);
	}

	/**
	 * @return the isDayCase
	 */
	public boolean isDayCase() {
		return isDayCase;
	}

	/**
	 * @param isDayCase the isDayCase to set
	 */
	public void setDayCase(String dayCase) {
		this.isDayCase = !ConstantsVariable.ZERO_VALUE.equals(dayCase);
	}

	/**
	 * @return the isPBO
	 */
	public boolean isPBO() {
		return isPBO;
	}

	/**
	 * @param isPBO the isPBO to set
	 */
	public void setPBO(String PBO) {
		// USRPBO
		this.isPBO = !ConstantsVariable.ZERO_VALUE.equals(PBO);
	}

	/**
	 * @return the isManager
	 */
	public boolean isManager() {
		return isManager;
	}

	/**
	 * @param isManager the isManager to set
	 */
	public void setManager(String Manager) {
		// Manager
		this.isManager = !ConstantsVariable.ZERO_VALUE.equals(Manager);
	}

	/**
	 * @return the isCashier
	 */
	public boolean isCashier() {
		return getCashierCode() != null && getCashierCode().length() > 0;
	}

	/**
	 * @return Returns the cashierCode.
	 */
	public String getCashierCode() {
		return cashierCode;
	}

	/**
	 * @param cashierCode the isCashier to set
	 */
	public void setCashierCode(String cashierCode) {
		this.cashierCode = cashierCode;
	}

	/**
	 * @return the userTeam
	 */
	public String getUserTeam() {
		return userTeam;
	}

	/**
	 * @param userTeam the userTeam to set
	 */
	public void setUserTeam(String userTeam) {
		this.userTeam = userTeam;
	}

	/**
	 * @return the isDoctor
	 */
	public boolean isDoctor() {
		if (getUserID() != null && getUserID().toUpperCase().startsWith("DR") &&
				getDeptCode().equals("DR")) {
			return true;
		}
		return false;
	}

	public String getDoctorCode() {
		if (isDoctor()) {
			return getUserID().substring(2);
		}
		return "";
	}

	/**
	 * @return the isNurse
	 */
	public boolean isNurse() {
		if (getUserID() != null &&
				getDeptCode().equals("NX")) {
			return true;
		}
		return false;
	}

	/**
	 * @return the isFoodService
	 */
	public boolean isFoodService() {
		if (getUserID() != null &&
				getDeptCode().equals("FSD")) {
			return true;
		}
		return false;
	}

	/**
	 * @return the isPharmacy
	 */
	public boolean isPharmacy() {
		if (getUserID() != null &&
				getDeptCode().equals("PX")) {
			return true;
		}
		return false;
	}

	public boolean isAdmin() {
		if (getUserID() != null && "ADMIN".equals(getUserID().toUpperCase())) {
			return true;
		}
		return false;
	}

	public String getSsoSessionID() {
		return ssoSessionID;
	}

	public void setSsoSessionID(String ssoSessionID) {
		this.ssoSessionID = ssoSessionID;
	}

	public String getSsoModuleCode() {
		return ssoModuleCode;
	}

	public void setSsoModuleCode(String ssoModuleCode) {
		this.ssoModuleCode = ssoModuleCode;
	}

	public String getSsoUserID() {
		return ssoUserID;
	}

	public void setSsoUserID(String ssoUserID) {
		this.ssoUserID = ssoUserID;
	}
}