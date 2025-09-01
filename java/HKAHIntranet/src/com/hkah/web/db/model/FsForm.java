package com.hkah.web.db.model;

import java.math.BigDecimal;

public class FsForm {
	private BigDecimal fsFormId;
	private String fsFormCode;
	private String fsFormName;
	private BigDecimal fsCategoryId;
	private String fsSection;
	private String fsSeq;
	private String fsPattype;
	private String fsIsDefault;
	private Integer fsChartMaxAllow;
	
	public FsForm() {
		super();
	}
	
	public FsForm(BigDecimal fsFormId, String fsFormCode, String fsFormName,
			BigDecimal fsCategoryId, String fsSection, String fsSeq,
			String fsPattype, String fsIsDefault, Integer fsChartMaxAllow) {
		super();
		this.fsFormId = fsFormId;
		this.fsFormCode = fsFormCode;
		this.fsFormName = fsFormName;
		this.fsCategoryId = fsCategoryId;
		this.fsSection = fsSection;
		this.fsSeq = fsSeq;
		this.fsPattype = fsPattype;
		this.fsIsDefault = fsIsDefault;
		this.fsChartMaxAllow = fsChartMaxAllow;
	}
	public BigDecimal getFsFormId() {
		return fsFormId;
	}
	public void setFsFormId(BigDecimal fsFormId) {
		this.fsFormId = fsFormId;
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
	public BigDecimal getFsCategoryId() {
		return fsCategoryId;
	}
	public void setFsCategoryId(BigDecimal fsCategoryId) {
		this.fsCategoryId = fsCategoryId;
	}
	public String getFsSection() {
		return fsSection;
	}
	public void setFsSection(String fsSection) {
		this.fsSection = fsSection;
	}
	public String getFsSeq() {
		return fsSeq;
	}
	public void setFsSeq(String fsSeq) {
		this.fsSeq = fsSeq;
	}
	public String getFsPattype() {
		return fsPattype;
	}
	public void setFsPattype(String fsPattype) {
		this.fsPattype = fsPattype;
	}

	public String getFsIsDefault() {
		return fsIsDefault;
	}

	public void setFsIsDefault(String fsIsDefault) {
		this.fsIsDefault = fsIsDefault;
	}

	public Integer getFsChartMaxAllow() {
		return fsChartMaxAllow;
	}

	public void setFsChartMaxAllow(Integer fsChartMaxAllow) {
		this.fsChartMaxAllow = fsChartMaxAllow;
	}
}
