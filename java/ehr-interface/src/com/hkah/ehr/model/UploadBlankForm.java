package com.hkah.ehr.model;

public class UploadBlankForm {
	private String ehrNo = null;
	private String patNo = null;
	private String uploadMode = null;
	private String userID = null;

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

	public String getUploadMode() {
		return uploadMode;
	}

	public void setUploadMode(String uploadMode) {
		this.uploadMode = uploadMode;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}
}
