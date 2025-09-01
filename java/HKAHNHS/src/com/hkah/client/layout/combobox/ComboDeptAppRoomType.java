/*
 * Created on August 4, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.layout.combobox;

import com.extjs.gxt.ui.client.data.ModelData;
import com.hkah.shared.constants.ConstantsTx;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboDeptAppRoomType extends ComboBoxBase  {
	String isActiveOnly = null;
	String deptcid = null;
	String isActive = null;
	String deptType = null;

	public ComboDeptAppRoomType(String deptType) {
		this(deptType, null, null, null, true);
	}

	public ComboDeptAppRoomType(String deptType, boolean loadContent) {
		this(deptType, null, null, null, loadContent);
	}

	public ComboDeptAppRoomType(String deptType, String isActiveOnly, String deptcid, String isActive, boolean loadContent) {
		super(false);
		setMinListWidth(200);
		this.isActiveOnly = isActiveOnly;
		this.deptcid = deptcid;
		this.isActive = isActive;
		this.deptType = deptType;

		if (loadContent) {
			initContent();
		} else {
			setTxCode(ConstantsTx.DEPTAPPROOMTYPE_TXCODE);
		}
	}

	private void initContent() {
		resetContent(ConstantsTx.DEPTAPPROOMTYPE_TXCODE, new String[] { isActiveOnly, deptcid, isActive, deptType });
	}	
	
	public String getDeptCID() {
		ModelData modelData = getValue();
		return (modelData == null ? getRawValue() : (modelData.get(ZERO_VALUE)).toString());
	}
}