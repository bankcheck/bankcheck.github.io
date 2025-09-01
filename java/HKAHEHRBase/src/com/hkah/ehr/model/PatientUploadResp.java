package com.hkah.ehr.model;

public class PatientUploadResp {
	private String patNo;
	private String ehrNo;
	private boolean uploadSuccess;
	private String initDomain;
	
	public PatientUploadResp(String patNo, String ehrNo, String initDomain) {
		super();
		this.patNo = patNo;
		this.ehrNo = ehrNo;
		this.initDomain = initDomain;
	}
	
	public String getPatNo() {
		return patNo;
	}		
	public String getInitDomain() {
		return initDomain;
	}

	public String getEhrNo() {
		return ehrNo;
	}

	public void setEhrNo(String ehrNo) {
		this.ehrNo = ehrNo;
	}

	public boolean isUploadSuccess() {
		return uploadSuccess;
	}

	public void setUploadSuccess(boolean uploadSuccess) {
		this.uploadSuccess = uploadSuccess;
	}	
}
