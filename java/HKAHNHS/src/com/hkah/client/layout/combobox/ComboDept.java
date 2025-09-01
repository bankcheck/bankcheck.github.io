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
public class ComboDept extends ComboBoxBase {

	public ComboDept() {
		this(true, null, null);
	}

	public ComboDept(boolean showKey, String sortBy) {
		this(showKey, null, sortBy);
	}

	public ComboDept(String dptCode) {
		this(true, dptCode, null);
	}

	public ComboDept(boolean showKey, String dptCode, String sortBy) {
		super(showKey);
		initContent(dptCode, sortBy);
	}

	public void initContent(String dptCode) {
		initContent(dptCode, null);
	}

	public void initContent(String dptCode, String sortBy) {
		// initial combobox
		resetContent(ConstantsTx.DEPARTMENT_TXCODE, new String[] {dptCode, sortBy});
	}
}