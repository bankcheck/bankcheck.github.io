package com.hkah.web.db.hibernate;

import java.util.Date;

import com.hkah.util.DateTimeUtil;

public class ELeaveObj {
	public int eleaveID;
	public String staffID;
	public String staffName;
	public Date fromDate;
	public Date toDate;
	public float appliedDays;
	public String leaveStatus;
	public Date createdDate;
	public Date modifiedDate;
	public String createdUser;
	public String modifiedUser;
	public String createdUsername;
	public String modifiedUsername;
	public String siteCode;
	public String leaveType;
	public String requestRemarks;
	public int enabled;
	public String responseRemarks;
	public String deptCode;
	public String deptDesc;
	
	public String getResponseRemarks() {
		return responseRemarks;
	}
	public void setResponseRemarks(String responseRemarks) {
		this.responseRemarks = responseRemarks;
	}
	public int getEleaveID() {
		return eleaveID;
	}
	public void setEleaveID(int eleaveID) {
		this.eleaveID = eleaveID;
	}
	public String getStaffID() {
		return staffID;
	}
	public void setStaffID(String staffID) {
		this.staffID = staffID;
	}
	public String getStaffName() {
		return staffName;
	}
	public void setStaffName(String staffName) {
		this.staffName = staffName;
	}
	public Date getFromDate() {
		return fromDate;
	}
	public void setFromDate(Date fromDate) {
		this.fromDate = fromDate;
	}
	public String getFormattedFromDate() {
		if (this.getFromDate() != null) {
			return DateTimeUtil.formatDateReverse(this.getFromDate());
		}
		return null;
	}
	public float getAppliedDays() {
		return appliedDays;
	}
	public void setAppliedDays(float appliedDays) {
		this.appliedDays = appliedDays;
	}
	public String getLeaveStatus() {
		return leaveStatus;
	}
	public void setLeaveStatus(String leaveStatus) {
		this.leaveStatus = leaveStatus;
	}
	public Date getCreatedDate() {
		return createdDate;
	}
	public void setCreatedDate(Date createdDate) {
		this.createdDate = createdDate;
	}
	public String getFormattedCreatedDate() {
		if (this.getCreatedDate() != null) {
			return DateTimeUtil.formatDateReverse(this.getCreatedDate());
		}
		return null;
	}
	public Date getModifiedDate() {
		return modifiedDate;
	}
	public void setModifiedDate(Date modifiedDate) {
		this.modifiedDate = modifiedDate;
	}
	public String getFormattedModifiedDate() {
		if (this.getModifiedDate() != null) {
			return DateTimeUtil.formatDateReverse(this.getModifiedDate());
		}
		return null;
	}
	public String getCreatedUser() {
		return createdUser;
	}
	public void setCreatedUser(String createdUser) {
		this.createdUser = createdUser;
	}
	public String getModifiedUser() {
		return modifiedUser;
	}
	public void setModifiedUser(String modifiedUser) {
		this.modifiedUser = modifiedUser;
	}
	public String getCreatedUsername() {
		return createdUsername;
	}
	public void setCreatedUsername(String createdUsername) {
		this.createdUsername = createdUsername;
	}
	public String getModifiedUsername() {
		return modifiedUsername;
	}
	public void setModifiedUsername(String modifiedUsername) {
		this.modifiedUsername = modifiedUsername;
	}
	public String getSiteCode() {
		return siteCode;
	}
	public void setSiteCode(String siteCode) {
		this.siteCode = siteCode;
	}
	public String getLeaveType() {
		return leaveType;
	}
	public void setLeaveType(String leaveType) {
		this.leaveType = leaveType;
	}
	public int getEnabled() {
		return enabled;
	}
	public void setEnabled(int enabled) {
		this.enabled = enabled;
	}
	public String getRequestRemarks() {
		return requestRemarks;
	}
	public void setRequestRemarks(String requestRemarks) {
		this.requestRemarks = requestRemarks;
	}
	public Date getToDate() {
		return toDate;
	}
	public void setToDate(Date toDate) {
		this.toDate = toDate;
	}
	public String getFormattedToDate() {
		if (this.getFromDate() != null) {
			return DateTimeUtil.formatDateReverse(this.getToDate());
		}
		return null;
	}
	public String getDeptDesc() {
		return deptDesc;
	}
	public void setDeptDesc(String deptDesc) {
		this.deptDesc = deptDesc;
	}
	
	/**
	 * @return the deptCode
	 */
	public String getDeptCode() {
		return deptCode;
	}
	/**
	 * @param deptCode the deptCode to set
	 */
	public void setDeptCode(String deptCode) {
		this.deptCode = deptCode;
	}
	// Formatted outputs
	public String getFromDateDisplay() {
		if (this.getFromDate() != null) {
			return DateTimeUtil.formatDate(this.getFromDate());
		} else {
			return "";
		}
	}
	
	public String getToDateDisplay() {
		if (this.getToDate() != null) {
			return DateTimeUtil.formatDate(this.getToDate());
		} else {
			return "";
		}
	}
}
