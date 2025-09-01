package com.hkah.web.db.model;

import java.math.BigDecimal;

public class FsFileDetails{
	private BigDecimal fsCategoryId;
	private String fsFilePath;
	private String fsFormCode;
	private String fsPatType;
	private String fsAdmDate;
	private String fsDisDate;
	
	public FsFileDetails() {
		super();
	}
	
	public FsFileDetails(BigDecimal fsCategoryId, String fsFilePath, String fsFormCode, String fsPatType, String fsAdmDate, String fsDisDate) {
		super();
		this.fsCategoryId = fsCategoryId;
		this.fsFilePath = fsFilePath;
		this.fsFormCode = fsFormCode;
		this.fsPatType = fsPatType;
		this.fsAdmDate = fsAdmDate;
		this.fsDisDate = fsDisDate;
	}
	
	public BigDecimal getFsCategoryId() {
		return fsCategoryId;
	}

	public void setFsCategoryId(BigDecimal fsCategoryId) {
		this.fsCategoryId = fsCategoryId;
	}
	
	public String getFsFilePath() {
		return fsFilePath;
	}

	public void setFsFilePath(String fsFilePath) {
		this.fsFilePath = fsFilePath;
	}
	
	public String getFsFormCode() {
		return fsFormCode;
	}

	public void setFsFormCode(String fsFormCode) {
		this.fsFormCode = fsFormCode;
	}	
	
	public String getFsPatType() {
		return fsPatType;
	}

	public void setFsPatType(String fsPatType) {
		this.fsPatType = fsPatType;
	}	
	
	public String getFsAdmDate() {
		return fsAdmDate;
	}

	public void setFsAdmDate(String fsAdmDate) {
		this.fsAdmDate = fsAdmDate;
	}	
	
	public String getFsDisDate() {
		return fsDisDate;
	}

	public void setFsDisDate(String fsDisDate) {
		this.fsDisDate = fsDisDate;
	}	
}
