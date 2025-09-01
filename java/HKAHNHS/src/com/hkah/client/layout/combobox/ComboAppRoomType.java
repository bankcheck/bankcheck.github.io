/*
 * Created on August 4, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboAppRoomType extends ComboBoxBase  {
	String isActiveOnly = null;
	String octid = null;
	String isActive = null;

	public ComboAppRoomType() {
		this(null, null, null, true);
	}

	public ComboAppRoomType(boolean loadContent) {
		this(null, null, null, loadContent);
	}

	public ComboAppRoomType(String isActiveOnly, String octid, String isActive, boolean loadContent) {
		super(false);
		setMinListWidth(200);
		this.isActiveOnly = isActiveOnly;
		this.octid = octid;
		this.isActive = isActive;

		if (loadContent) {
			initContent();
		} else {
			setTxCode(ConstantsTx.APPROOMTYPE_TXCODE);
		}
	}

	private void initContent() {
		resetContent(ConstantsTx.APPROOMTYPE_TXCODE, new String[] { isActiveOnly, octid, isActive });
	}

	/**
	 * @return the isActiveOnly
	 */
	public String getIsActiveOnly() {
		return isActiveOnly;
	}

	/**
	 * @return the octid
	 */
	public String getOctid() {
		return octid;
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
	 * @param octid the octid to set
	 */
	public void setOctid(String octid) {
		this.octid = octid;
	}

	/**
	 * @param isActive the isActive to set
	 */
	public void setIsActive(String isActive) {
		this.isActive = isActive;
	}
}