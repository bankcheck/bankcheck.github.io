package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboDoctorDeptServ extends ComboBoxShowKey {

	public ComboDoctorDeptServ() {
		super();
		setMinListWidth(400);
	}

	@Override
	public void initContent(String value) {
		// initial combobox
		resetContent(ConstantsTx.DPSERV_TXCODE);
	}
}	