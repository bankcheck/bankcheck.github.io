package com.hkah.web.db.model;

import java.util.ArrayList;

public class FsPatNo{
	private String fsPatno;
	private ArrayList<FsFileDetails> fileDetails = new ArrayList<FsFileDetails>();
	
	public FsPatNo() {
		super();
	}
	
	public String getFsPatno() {
		return fsPatno;
	}

	public void setFsPatno(String fsPatno) {
		this.fsPatno = fsPatno;
	}
	
	public ArrayList<FsFileDetails> getFileDetails() {
		return fileDetails;
	}

	public void setFileDetails(FsFileDetails fileDetails) {
		this.fileDetails.add(fileDetails);
	}
}
