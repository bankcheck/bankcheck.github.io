package com.hkah.web.db.model;

import java.math.BigDecimal;
import java.util.Date;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.web.db.helper.FsModelHelper;

public class FsFileProfile {
	protected BigDecimal fsFileProfileId;
	protected String fsIcdCode;
	protected String fsIcdName;
	protected String fsFormCode;
	protected Date fsCreatedDate;
	protected String fsCreatedUser;
	protected Date fsModifiedDate;
	protected String fsModifiedUser;
	protected int fsEnabled;
	protected String fsStnid;
	protected String fsRisAccessionNo;
	protected String fsKey;
	
	protected FsCategory fsCategory;
	
	protected FsFileIndex fsFileIndex;
	
	public FsFileProfile() {
		super();
	}
	
	public FsFileProfile(BigDecimal fsFileProfileId, String fsIcdCode, String fsIcdName, String fsFormCode,
			Date fsCreatedDate, String fsCreatedUser,
			Date fsModifiedDate, String fsModifiedUser, int fsEnabled, String fsStnid) {
		super();
		this.fsFileProfileId = fsFileProfileId;
		this.fsIcdCode = fsIcdCode;
		this.fsIcdName = fsIcdName;
		this.fsFormCode = fsFormCode;
		this.fsCreatedDate = fsCreatedDate;
		this.fsCreatedUser = fsCreatedUser;
		this.fsModifiedDate = fsModifiedDate;
		this.fsModifiedUser = fsModifiedUser;
		this.fsEnabled = fsEnabled;
		this.fsStnid = fsStnid;
	}
	
	public FsCategory getFsCategory() {
		return fsCategory;
	}

	public void setFsCategory(FsCategory fsCategory) {
		this.fsCategory = fsCategory;
	}

	public FsFileIndex getFsFileIndex() {
		return fsFileIndex;
	}

	public void setFsFileIndex(FsFileIndex fsFileIndex) {
		this.fsFileIndex = fsFileIndex;
	}

	public BigDecimal getFsFileProfileId() {
		return fsFileProfileId;
	}
	public void setFsFileProfileId(BigDecimal fsFileProfileId) {
		this.fsFileProfileId = fsFileProfileId;
	}
	
	public String getFsIcdCode() {
		return fsIcdCode;
	}
	public void setFsIcdCode(String fsIcdCode) {
		this.fsIcdCode = fsIcdCode;
	}
	public String getFsIcdName() {
		return fsIcdName;
	}
	public void setFsIcdName(String fsIcdName) {
		this.fsIcdName = fsIcdName;
	}
	public String getFsFormCode() {
		return fsFormCode;
	}
	public void setFsFormCode(String fsFormCode) {
		this.fsFormCode = fsFormCode;
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
	
	public String getFsStnid() {
		return fsStnid;
	}

	public void setFsStnid(String fsStnid) {
		this.fsStnid = fsStnid;
	}
	
	public String getFsRisAccessionNo() {
		return fsRisAccessionNo;
	}

	public void setFsRisAccessionNo(String fsRisAccessionNo) {
		this.fsRisAccessionNo = fsRisAccessionNo;
	}

	public String getFsKey() {
		return fsKey;
	}

	public void setFsKey(String fsKey) {
		this.fsKey = fsKey;
	}

	public boolean isReferralLab() {
		return getFsCategory() != null && (
			(ConstantsServerSide.isHKAH() && FsModelHelper.HKAH_HIS_CAT_ID.equals(getFsCategory().getFsCategoryId())) ||
			(ConstantsServerSide.isTWAH() && FsModelHelper.TWAH_HIS_CAT_ID.equals(getFsCategory().getFsCategoryId()))
			);
	}
	
	public boolean isRisAutoImport() {
		if (ConstantsServerSide.isHKAH() && FsModelHelper.HKAH_DI_REPORT_CODE.equals(getFsFormCode()) && "SYSTEM".equals(getFsCreatedUser())) {
			return true;
		} else {
			return false;
		}
	}
	
	public boolean isLisAutoImport() {
		if (getFsKey() != null && "SYSTEM".equals(getFsCreatedUser())) {
			return true;
		} else {
			return false;
		}
	}
}
