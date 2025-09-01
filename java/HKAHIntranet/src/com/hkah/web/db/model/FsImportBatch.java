package com.hkah.web.db.model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class FsImportBatch implements Cloneable {
	protected BigDecimal fsBatchNo;
	protected String fsIndexFileName;
	protected Date fsCreatedDate;
	protected String fsCreatedUser;
	protected List<FsImportBatch> diffSeqBatches;
	
	public FsImportBatch() {
		super();
	}
	
	public FsImportBatch(String fsIndexFileName) {
		super();
		this.fsIndexFileName = fsIndexFileName;
	}

	public FsImportBatch(BigDecimal fsBatchNo, String fsIndexFileName, Date fsCreatedDate, String fsCreatedUser) {
		super();
		this.fsBatchNo = fsBatchNo;
		this.fsIndexFileName = fsIndexFileName;
		this.fsCreatedDate = fsCreatedDate;
		this.fsCreatedUser = fsCreatedUser;
	}

	public BigDecimal getFsBatchNo() {
		return fsBatchNo;
	}

	public void setFsBatchNo(BigDecimal fsBatchNo) {
		this.fsBatchNo = fsBatchNo;
	}

	public String getFsIndexFileName() {
		return fsIndexFileName;
	}

	public void setFsIndexFileName(String fsIndexFileName) {
		this.fsIndexFileName = fsIndexFileName;
	}

	public Date getFsCreatedDate() {
		return fsCreatedDate;
	}

	public void setFsCreatedDate(Date fsCreatedDate) {
		this.fsCreatedDate = fsCreatedDate;
	}

	public String getFsCreatedUser() {
		return fsCreatedUser;
	}

	public void setFsCreatedUser(String fsCreatedUser) {
		this.fsCreatedUser = fsCreatedUser;
	}

	public List<FsImportBatch> getDiffSeqBatches() {
		if (diffSeqBatches == null) {
			diffSeqBatches = new ArrayList<FsImportBatch>();
		}
		return diffSeqBatches;
	}
	
	public String getDiffSeqBatchesHTMLStr() {
		String ret = "";
		if (diffSeqBatches != null) {
			List<String> fileNames = new ArrayList<String>();
			for (FsImportBatch b : diffSeqBatches) {
				fileNames.add(b.getFsIndexFileName());
				ret+= "<a href='importLog_list.jsp?batchNo=" + b.getFsBatchNo() + "&approveStatus=A' target='_blank'>" + b.getFsIndexFileName() + "</a><br />";
			}
		}
		return ret;
	}

	public void setDiffSeqBatches(List<FsImportBatch> diffSeqBatches) {
		this.diffSeqBatches = diffSeqBatches;
	}

}
