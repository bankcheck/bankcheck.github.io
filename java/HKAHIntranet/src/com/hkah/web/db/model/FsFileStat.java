package com.hkah.web.db.model;

import java.math.BigDecimal;
import java.util.Date;

import com.hkah.util.DateTimeUtil;

public class FsFileStat implements Cloneable {
	protected BigDecimal fsFileStatId;
	protected String fsPatno;
	protected BigDecimal noOfBatch;
	protected BigDecimal noOfReg;
	protected BigDecimal noOfFileIndexAll;
	protected BigDecimal noOfFileIndexIp;
	protected BigDecimal noOfFileIndexOp;
	protected BigDecimal noOfFileIndexDc;
	protected BigDecimal noOfFileIndexOther;
	protected Date fsFirstImportDate;
	protected Date fsLatestImportDate;
	
	public FsFileStat() {
		super();
	}

	public BigDecimal getFsFileStatId() {
		return fsFileStatId;
	}

	public void setFsFileStatId(BigDecimal fsFileStatId) {
		this.fsFileStatId = fsFileStatId;
	}

	public String getFsPatno() {
		return fsPatno;
	}

	public void setFsPatno(String fsPatno) {
		this.fsPatno = fsPatno;
	}

	public BigDecimal getNoOfBatch() {
		return noOfBatch;
	}

	public void setNoOfBatch(BigDecimal noOfBatch) {
		this.noOfBatch = noOfBatch;
	}

	public BigDecimal getNoOfReg() {
		return noOfReg;
	}

	public void setNoOfReg(BigDecimal noOfReg) {
		this.noOfReg = noOfReg;
	}

	public BigDecimal getNoOfFileIndexAll() {
		return noOfFileIndexAll;
	}

	public void setNoOfFileIndexAll(BigDecimal noOfFileIndexAll) {
		this.noOfFileIndexAll = noOfFileIndexAll;
	}

	public BigDecimal getNoOfFileIndexIp() {
		return noOfFileIndexIp;
	}

	public void setNoOfFileIndexIp(BigDecimal noOfFileIndexIp) {
		this.noOfFileIndexIp = noOfFileIndexIp;
	}

	public BigDecimal getNoOfFileIndexOp() {
		return noOfFileIndexOp;
	}

	public void setNoOfFileIndexOp(BigDecimal noOfFileIndexOp) {
		this.noOfFileIndexOp = noOfFileIndexOp;
	}

	public BigDecimal getNoOfFileIndexDc() {
		return noOfFileIndexDc;
	}

	public void setNoOfFileIndexDc(BigDecimal noOfFileIndexDc) {
		this.noOfFileIndexDc = noOfFileIndexDc;
	}

	public BigDecimal getNoOfFileIndexOther() {
		return noOfFileIndexOther;
	}

	public void setNoOfFileIndexOther(BigDecimal noOfFileIndexOther) {
		this.noOfFileIndexOther = noOfFileIndexOther;
	}

	public Date getFsFirstImportDate() {
		return fsFirstImportDate;
	}

	public void setFsFirstImportDate(Date fsFirstImportDate) {
		this.fsFirstImportDate = fsFirstImportDate;
	}

	public Date getFsLatestImportDate() {
		return fsLatestImportDate;
	}

	public void setFsLatestImportDate(Date fsLatestImportDate) {
		this.fsLatestImportDate = fsLatestImportDate;
	}
	
	public String getFsFirstImportDateStr() {
		return DateTimeUtil.formatDate(getFsFirstImportDate());
	}
	
	public String getFsLatestImportDateStr() {
		return DateTimeUtil.formatDate(getFsLatestImportDate());
	}
}
