package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboDeptProc extends ComboBoxBase{
	String isActiveOnly = null;
	String deptpid = null;
	String isActive = null;
	String deptType = null;

	public ComboDeptProc(String deptType) {
		this(deptType, null, null, null, true);
	}

	public ComboDeptProc(String deptType, boolean loadContent) {
		this(deptType, null, null, null, loadContent);
	}

	public ComboDeptProc(String deptType, String isActiveOnly, String deptpid, String isActive, boolean loadContent) {
		super(false);
		setMinListWidth(400);
		this.isActiveOnly = isActiveOnly;
		this.deptpid = deptpid;
		this.isActive = isActive;
		this.deptType = deptType;
		
		if (loadContent) {
			initContent();
		} else {
			setTxCode(ConstantsTx.DEPTPROC_TXCODE);
		}
	}

	private void initContent() {
		resetContent(ConstantsTx.DEPTPROC_TXCODE, new String[] { isActiveOnly, deptpid, isActive, deptType });
	}

	/**
	 * @return the deptType
	 */
	public String getDeptType() {
		return deptType;
	}
	
	/**
	 * @return the isActiveOnly
	 */
	public String getIsActiveOnly() {
		return isActiveOnly;
	}

	/**
	 * @return the deptpid
	 */
	public String getDeptpid() {
		return deptpid;
	}

	/**
	 * @return the isActive
	 */
	public String getIsActive() {
		return isActive;
	}
	
	/**
	 * @param deptpid the deptType to set
	 */
	public void setDeptType(String deptType) {
		this.deptType = deptType;
	}

	/**
	 * @param isActiveOnly the isActiveOnly to set
	 */
	public void setIsActiveOnly(String isActiveOnly) {
		this.isActiveOnly = isActiveOnly;
	}

	/**
	 * @param deptpid the deptpid to set
	 */
	public void setOtpid(String deptpid) {
		this.deptpid = deptpid;
	}

	/**
	 * @param isActive the isActive to set
	 */
	public void setIsActive(String isActive) {
		this.isActive = isActive;
	}
}