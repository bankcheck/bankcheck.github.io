package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboDoctorDept extends ComboBoxShowKey {

	public ComboDoctorDept() {
		super();
		setMinListWidth(400);
	}

	@Override
	public void initContent(String value) {
		// initial combobox
		String dptCode = "";
		String sortBy = "";
		resetContent(ConstantsTx.DEPARTMENT_TXCODE, new String[] {dptCode, sortBy});
	}
}