package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboDeptService extends ComboBoxBase {

	public ComboDeptService() {
		super(true);
		initContent();
	}

	public ComboDeptService(boolean showKey) {
		super(showKey);
		initContent();
	}

	public void initContent() {
		// initial combobox
		resetContent(ConstantsTx.DEPTSERVICE);
	}
}
