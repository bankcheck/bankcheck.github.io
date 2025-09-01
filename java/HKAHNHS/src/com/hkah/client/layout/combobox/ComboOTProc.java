package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboOTProc extends ComboBoxBase{
	String isActiveOnly = null;
	String otpid = null;
	String isActive = null;

	public ComboOTProc() {
		this(null, null, null, true);
	}

	public ComboOTProc(boolean loadContent) {
		this(null, null, null, loadContent);
	}

	public ComboOTProc(String isActiveOnly, String otpid, String isActive, boolean loadContent) {
		super(false);
		setMinListWidth(400);
		this.isActiveOnly = isActiveOnly;
		this.otpid = otpid;
		this.isActive = isActive;

		if (loadContent) {
			initContent();
		} else {
			setTxCode(ConstantsTx.OTPROC_TXCODE);
		}
	}

	private void initContent() {
		resetContent(ConstantsTx.OTPROC_TXCODE, new String[] { isActiveOnly, otpid, isActive });
	}

	/**
	 * @return the isActiveOnly
	 */
	public String getIsActiveOnly() {
		return isActiveOnly;
	}

	/**
	 * @return the otpid
	 */
	public String getOtpid() {
		return otpid;
	}

	/**
	 * @return the isActive
	 */
	public String getIsActive() {
		return isActive;
	}

	/**
	 * @param isActiveOnly the isActiveOnly to set
	 */
	public void setIsActiveOnly(String isActiveOnly) {
		this.isActiveOnly = isActiveOnly;
	}

	/**
	 * @param otpid the otpid to set
	 */
	public void setOtpid(String otpid) {
		this.otpid = otpid;
	}

	/**
	 * @param isActive the isActive to set
	 */
	public void setIsActive(String isActive) {
		this.isActive = isActive;
	}
}