package com.hkah.web.db.hibernate;

import java.util.Date;

public class ELeaveBalanceObj  {
	
	public ELeaveBalanceObjID id;
	public String siteCode;
	public float actualBalance;
	public float pendingBalance;
	public int enabled;
	public String modifiedUser;
	public String createdUser;
	public Date modifiedDate;
	public Date createdDate;
	public String getModifiedUser() {
		return modifiedUser;
	}
	public void setModifiedUser(String modifiedUser) {
		this.modifiedUser = modifiedUser;
	}
	public String getCreatedUser() {
		return createdUser;
	}
	public void setCreatedUser(String createdUser) {
		this.createdUser = createdUser;
	}
	public String getStaffID() {
		return getId().getStaffID();
	}
	public void setStaffID(String staffID) {
		 getId().setStaffID(staffID);
	}
	public int getYear() {
		return getId().getYear();
	}
	public void setYear(int year) {
		 getId().setYear(year);
	}
	public float getActualBalance() {
		return actualBalance;
	}
	public void setActualBalance(float actualBalance) {
		this.actualBalance = actualBalance;
	}
	public float getPendingBalance() {
		return pendingBalance;
	}
	public void setPendingBalance(float pendingBalance) {
		this.pendingBalance = pendingBalance;
	}
	public int getEnabled() {
		return enabled;
	}
	public void setEnabled(int enabled) {
		this.enabled = enabled;
	}
	public ELeaveBalanceObjID getId() {
		return id;
	}
	public void setId(ELeaveBalanceObjID id) {
		this.id = id;
	}
	public Date getModifiedDate() {
		return modifiedDate;
	}
	public void setModifiedDate(Date modifiedDate) {
		this.modifiedDate = modifiedDate;
	}
	public Date getCreatedDate() {
		return createdDate;
	}
	public void setCreatedDate(Date createdDate) {
		this.createdDate = createdDate;
	}
	public String getSiteCode() {
		return siteCode;
	}
	public void setSiteCode(String siteCode) {
		this.siteCode = siteCode;
	}
}
