package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboPrivilege extends ComboBoxShowKey {

	public ComboPrivilege() {
		super();
		setMinListWidth(400);
	}

	@Override
	public void initContent(String value) {
		// initial combobox
		resetContent(ConstantsTx.PRIVILEGE_TXCODE);
	}
}