package com.hkah.web.db.model;

import java.math.BigDecimal;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.web.db.helper.FsModelHelper;

public class FsFileIndex implements Cloneable {
	protected BigDecimal fsFileIndexId;
	protected String fsPatno;
	protected String fsRegid;
	protected Date fsDueDate;
	protected Date fsAdmDate;
	protected Date fsDischargeDate;
	protected Date fsImportDate;
	protected String fsImportedBy;
	protected String fsFormCode;
	protected String fsFormName;
	protected String fsFilePath;
	protected String fsPattype;
	protected String fsSeq;
	protected Date fsApprovedDate;
	protected String fsApprovedUser;
	protected Date fsCreatedDate;
	protected String fsCreatedUser;
	protected Date fsModifiedDate;
	protected String fsModifiedUser;
	protected int fsEnabled;
	protected String fsLabNum;
	protected String stationId;
	protected FsFileProfile fsFileProfile;
	
	protected String masterFormCode;
	protected String fsBatchNo;
	protected Set<String> formAliases = new HashSet<String>();
	protected boolean isAppendDocDateBeforeName = true;
	protected boolean isLinkedByCmsMr = false;
	
	public FsFileIndex() {
		super();
		if (ConstantsServerSide.isHKAH()) {
			setAppendDocDateBeforeName(false);
		} else if (ConstantsServerSide.isTWAH()) {
			setAppendDocDateBeforeName(true);
		}
	}
	
	public FsFileIndex(BigDecimal fsFileIndexId, String fsPatno, String fsRegid,
			Date fsDueDate, Date fsAdmDate, Date fsDischargeDate, Date fsImportDate,
			String fsFormCode, String fsFormName, String fsFilePath, String fsPattype,
			Date fsApprovedDate, String fsApprovedUser,
			String fsSeq, Date fsCreatedDate, String fsCreatedUser,
			Date fsModifiedDate, String fsModifiedUser, int fsEnabled, String fsLabNum) {
		super();
		this.fsFileIndexId = fsFileIndexId;
		this.fsPatno = fsPatno;
		this.fsRegid = fsRegid;
		this.fsDueDate = fsDueDate;
		this.fsAdmDate = fsAdmDate;
		this.fsDischargeDate = fsDischargeDate;
		this.fsImportDate = fsImportDate;
		this.fsFormCode = fsFormCode;
		this.fsFormName = fsFormName;
		this.fsFilePath = fsFilePath;
		this.fsPattype = fsPattype;
		this.fsSeq = fsSeq;
		this.fsApprovedDate = fsApprovedDate;
		this.fsApprovedUser = fsApprovedUser;
		this.fsCreatedDate = fsCreatedDate;
		this.fsCreatedUser = fsCreatedUser;
		this.fsModifiedDate = fsModifiedDate;
		this.fsModifiedUser = fsModifiedUser;
		this.fsEnabled = fsEnabled;
		this.fsLabNum = fsLabNum;
	}
	public BigDecimal getFsFileIndexId() {
		return fsFileIndexId;
	}
	public void setFsFileIndexId(BigDecimal fsFileIndexId) {
		this.fsFileIndexId = fsFileIndexId;
	}
	public String getFsPatno() {
		return fsPatno;
	}
	public void setFsPatno(String fsPatno) {
		this.fsPatno = fsPatno;
	}
	public String getFsRegid() {
		return fsRegid;
	}
	public void setFsRegid(String fsRegid) {
		this.fsRegid = fsRegid;
	}
	public Date getFsDueDate() {
		return fsDueDate;
	}
	public void setFsDueDate(Date fsDueDate) {
		this.fsDueDate = fsDueDate;
	}
	public Date getFsAdmDate() {
		return fsAdmDate;
	}
	public void setFsAdmDate(Date fsAdmDate) {
		this.fsAdmDate = fsAdmDate;
	}
	public Date getFsDischargeDate() {
		return fsDischargeDate;
	}
	public void setFsDischargeDate(Date fsDischargeDate) {
		this.fsDischargeDate = fsDischargeDate;
	}
	public Date getFsImportDate() {
		return fsImportDate;
	}
	public void setFsImportDate(Date fsImportDate) {
		this.fsImportDate = fsImportDate;
	}
	public String getFsImportedBy() {
		return fsImportedBy;
	}
	public void setFsImportedBy(String fsImportedBy) {
		this.fsImportedBy = fsImportedBy;
	}
	public String getFsFormCode() {
		return fsFormCode;
	}
	public void setFsFormCode(String fsFormCode) {
		this.fsFormCode = fsFormCode;
	}
	public String getFsFormName() {
		return fsFormName;
	}
	public void setFsFormName(String fsFormName) {
		this.fsFormName = fsFormName;
	}
	public String getFsFilePath() {
		return fsFilePath;
	}
	public void setFsFilePath(String fsFilePath) {
		this.fsFilePath = fsFilePath;
	}
	public String getFsPattype() {
		return fsPattype;
	}
	public void setFsPattype(String fsPattype) {
		this.fsPattype = fsPattype;
	}
	public String getFsSeq() {
		return fsSeq;
	}
	public void setFsSeq(String fsSeq) {
		this.fsSeq = fsSeq;
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
	public Date getFsModifiedDate() {
		return fsModifiedDate;
	}
	public void setFsModifiedDate(Date fsModifiedDate) {
		this.fsModifiedDate = fsModifiedDate;
	}
	public String getFsModifiedUser() {
		return fsModifiedUser;
	}
	public void setFsModifiedUser(String fsModifiedUser) {
		this.fsModifiedUser = fsModifiedUser;
	}
	public int getFsEnabled() {
		return fsEnabled;
	}
	public void setFsEnabled(int fsEnabled) {
		this.fsEnabled = fsEnabled;
	}

	public String getFsLabNum() {
		return fsLabNum;
	}

	public void setFsLabNum(String fsLabNum) {
		this.fsLabNum = fsLabNum;
	}

	public String getStationID() {
		return stationId;
	}

	public void setStationId(String stationId) {
		this.stationId = stationId;
	}

	public FsFileProfile getFsFileProfile() {
		return fsFileProfile;
	}

	public void setFsFileProfile(FsFileProfile fsFileProfile) {
		this.fsFileProfile = fsFileProfile;
	}
	public boolean isAppendDocDateBeforeName() {
		return isAppendDocDateBeforeName;
	}
	public void setAppendDocDateBeforeName(boolean isAppendDocDateBeforeName) {
		this.isAppendDocDateBeforeName = isAppendDocDateBeforeName;
	}
	
	public boolean isLinkedByCmsMr() {
		return isLinkedByCmsMr;
	}

	public void setLinkedByCmsMr(boolean isLinkedByCmsMr) {
		this.isLinkedByCmsMr = isLinkedByCmsMr;
	}

	public String getMasterFormCode() {
		return masterFormCode;
	}

	public void setMasterFormCode(String masterFormCode) {
		this.masterFormCode = masterFormCode;
	}

	public Set<String> getFormAliases() {
		return formAliases;
	}

	public void setFormAliases(Set<String> formAliases) {
		this.formAliases = formAliases;
	}

	public void setFsBatchNo(String fsBatchNo) {
		this.fsBatchNo = fsBatchNo;
	}

	public String getFsBatchNo() {
		return fsBatchNo;
	}

	public String getTreeDisplayName() {
		String displayName = "";
		if (isAppendDocDateBeforeName()) {
			if (getFsDueDate() != null) {
				displayName += FsModelHelper.displayDateFormatMiddleEndianShort.format(getFsDueDate());
				displayName += " - ";
			}
		}
		displayName += getFsFormName();
		if (displayName.length() == 0)
			displayName = "Form";
		return displayName;
	}

	@Override
	protected Object clone() throws CloneNotSupportedException {
		FsFileIndex o = (FsFileIndex) super.clone();
		
		return o;
	}
	
	public boolean isApproved() {
		return (getFsApprovedDate() != null && getFsApprovedUser() != null) ? true : false;
	}
}
