package com.hkah.web.db.hibernate;

import java.util.Date;

public class ELeaveApprovedObj {
	public ELeaveApprovedObjID id;
	public String approvalStaffID;
	public int enabled;
	public Date modifiedDate;
	public String createdUser;
	public String modifiedUser;
	public String siteCode;
	public Date createdDate;
	
	/**
	 * @return the id
	 */
	public ELeaveApprovedObjID getId() {
		return id;
	}
	/**
	 * @param id the id to set
	 */
	public void setId(ELeaveApprovedObjID id) {
		this.id = id;
	}
	public String getApprovalStaffID() {
		return approvalStaffID;
	}
	public void setApprovalStaffID(String approvalStaffID) {
		this.approvalStaffID = approvalStaffID;
	}
	public int getEnabled() {
		return enabled;
	}
	public void setEnabled(int enabled) {
		this.enabled = enabled;
	}
	public Date getModifiedDate() {
		return modifiedDate;
	}
	public void setModifiedDate(Date modifiedDate) {
		this.modifiedDate = modifiedDate;
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
	public String getSiteCode() {
		return siteCode;
	}
	public void setSiteCode(String siteCode) {
		this.siteCode = siteCode;
	}
	public Date getCreatedDate() {
		return createdDate;
	}
	public void setCreatedDate(Date createdDate) {
		this.createdDate = createdDate;
	}
	
}
