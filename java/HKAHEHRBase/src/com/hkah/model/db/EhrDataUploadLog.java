package com.hkah.model.db;

import java.io.Serializable;
import java.util.Date;

public class EhrDataUploadLog implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private String id = null;
	private String domainCode = null;
	private Date uploadDate = null;
	private String ehrNo = null;
	private String patno = null;
	private Date startDate = null;
	private Date endDate = null;
	private String uploadMode = null;
	private String success = null;
	
	public EhrDataUploadLog(String id, String domainCode, Date uploadDate,
			String ehrNo, String patno, Date startDate, Date endDate,
			String uploadMode, String success) {
		super();
		this.id = id;
		this.domainCode = domainCode;
		this.uploadDate = uploadDate;
		this.ehrNo = ehrNo;
		this.patno = patno;
		this.startDate = startDate;
		this.endDate = endDate;
		this.uploadMode = uploadMode;
		this.success = success;
	}
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getDomainCode() {
		return domainCode;
	}
	public void setDomainCode(String domainCode) {
		this.domainCode = domainCode;
	}
	public Date getUploadDate() {
		return uploadDate;
	}
	public void setUploadDate(Date uploadDate) {
		this.uploadDate = uploadDate;
	}
	public String getEhrNo() {
		return ehrNo;
	}
	public void setEhrNo(String ehrNo) {
		this.ehrNo = ehrNo;
	}
	public String getPatno() {
		return patno;
	}
	public void setPatno(String patno) {
		this.patno = patno;
	}
	public Date getStartDate() {
		return startDate;
	}
	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}
	public Date getEndDate() {
		return endDate;
	}
	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}
	public String getUploadMode() {
		return uploadMode;
	}
	public void setUploadMode(String uploadMode) {
		this.uploadMode = uploadMode;
	}
	public String getSuccess() {
		return success;
	}
	public void setSuccess(String success) {
		this.success = success;
	}
}
