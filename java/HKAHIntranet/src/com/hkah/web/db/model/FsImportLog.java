package com.hkah.web.db.model;

import java.math.BigDecimal;
import java.util.Date;

import com.hkah.constant.ConstantsVariable;

public class FsImportLog implements Cloneable {
	protected BigDecimal fsImportLogId;
	protected BigDecimal fsBatchNo;
	protected BigDecimal fsFileIndexId;
	protected Date fsImportDate;
	protected String fsEncodedParams;
	protected String fsDescription;
	protected String fsHandled;
	protected String fsHandledDesc;
	protected Date fsCreatedDate;
	protected String fsCreatedUser;
	
	protected Date fsApprovedDate;
	protected String fsApprovedUser;
	protected int corrFsFileIndexEnabled;
	
	public FsImportLog() {
		super();
	}

	public FsImportLog(BigDecimal fsImportLogId, BigDecimal fsBatchNo, BigDecimal fsFileIndexId,
			Date fsImportDate, String fsEncodedParams, String fsDescription, String fsHandled, String fsHandledDesc,
			Date fsCreatedDate, String fsCreatedUser) {
		super();
		this.fsImportLogId = fsImportLogId;
		this.fsBatchNo = fsBatchNo;
		this.fsFileIndexId = fsFileIndexId;
		this.fsImportDate = fsImportDate;
		this.fsEncodedParams = fsEncodedParams;
		this.fsDescription = fsDescription;
		this.fsCreatedDate = fsCreatedDate;
		this.fsCreatedUser = fsCreatedUser;
	}

	public BigDecimal getFsImportLogId() {
		return fsImportLogId;
	}

	public void setFsImportLogId(BigDecimal fsImportLogId) {
		this.fsImportLogId = fsImportLogId;
	}

	public BigDecimal getFsBatchNo() {
		return fsBatchNo;
	}

	public void setFsBatchNo(BigDecimal fsBatchNo) {
		this.fsBatchNo = fsBatchNo;
	}

	public BigDecimal getFsFileIndexId() {
		return fsFileIndexId;
	}

	public void setFsFileIndexId(BigDecimal fsFileIndexId) {
		this.fsFileIndexId = fsFileIndexId;
	}

	public Date getFsImportDate() {
		return fsImportDate;
	}

	public void setFsImportDate(Date fsImportDate) {
		this.fsImportDate = fsImportDate;
	}

	public String getFsEncodedParams() {
		return fsEncodedParams;
	}
	
	public void setFsEncodedParams(String fsEncodedParams) {
		this.fsEncodedParams = fsEncodedParams;
	}

	public String getFsDescription() {
		return fsDescription;
	}

	public void setFsDescription(String fsDescription) {
		this.fsDescription = fsDescription;
	}

	public String getFsHandled() {
		return fsHandled;
	}

	public void setFsHandled(String fsHandled) {
		this.fsHandled = fsHandled;
	}

	public String getFsHandledDesc() {
		return fsHandledDesc;
	}

	public void setFsHandledDesc(String fsHandledDesc) {
		this.fsHandledDesc = fsHandledDesc;
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
	
	public boolean isImported() {
		return getFsFileIndexId() == null ? false : true;
	}
	
	public boolean isHandled() {
		return ConstantsVariable.YES_VALUE.equals(getFsHandled());
	}

	public Date getFsApprovedDate() {
		return fsApprovedDate;
	}

	public void setFsApprovedDate(Date fsApprovedDate) {
		this.fsApprovedDate = fsApprovedDate;
	}
	
	public String getFsApprovedUser() {
		return fsApprovedUser;
	}

	public void setFsApprovedUser(String fsApprovedUser) {
		this.fsApprovedUser = fsApprovedUser;
	}

	public boolean isApproved() {
		return (getFsApprovedDate() != null && getFsApprovedUser() != null) ? true : false;
	}
	
	public int getCorrFsFileIndexEnabled() {
		return corrFsFileIndexEnabled;
	}

	public void setCorrFsFileIndexEnabled(int corrFsFileIndexEnabled) {
		this.corrFsFileIndexEnabled = corrFsFileIndexEnabled;
	}
	
	public boolean isCorrFsFileIndexEnabled() {
		return getCorrFsFileIndexEnabled() == 1;
	}
	
	public boolean canApprove() {
		return isCorrFsFileIndexEnabled() && !isApproved();
	}
}
