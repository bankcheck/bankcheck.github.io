package com.hkah.ehr.model;

public class DownloadPatientAdrAndAllergyForm {
	private String ehrNo = null;
	private String patNo = null;
	private String userID = null;
	private String moduleCode = null;

	public String getEhrNo() {
		return ehrNo;
	}

	public void setEhrNo(String ehrNo) {
		this.ehrNo = ehrNo;
	}

	public String getPatNo() {
		return patNo;
	}

	public void setPatNo(String patNo) {
		this.patNo = patNo;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getModuleCode() {
		return moduleCode;
	}

	public void setModuleCode(String moduleCode) {
		this.moduleCode = moduleCode;
	}
}
