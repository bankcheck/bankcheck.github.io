package com.hkah.web.db.model;

import java.math.BigDecimal;
import java.util.ArrayList;

public class FsCombineFiles{
	private BigDecimal fsCategoryId;
	private ArrayList<FsFileDetails> fileDetails = new ArrayList<FsFileDetails>();
	
	public FsCombineFiles() {
		super();
	}
	
	public FsCombineFiles(BigDecimal fsCategoryId) {
		super();
		this.fsCategoryId = fsCategoryId;
	}
	
	public BigDecimal getFsCategoryId() {
		return fsCategoryId;
	}

	public void setFsCategoryId(BigDecimal fsCategoryId) {
		this.fsCategoryId = fsCategoryId;
	}
	
	public ArrayList<FsFileDetails> getFileDetails() {
		return fileDetails;
	}

	public void setFileDetails(FsFileDetails fileDetails) {
		this.fileDetails.add(fileDetails);
	}
}