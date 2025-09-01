package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboDoctorEN extends ComboBoxBase{
	public ComboDoctorEN() {
		this(null, true);
	}

	public ComboDoctorEN(boolean loadContent) {
		this(null, loadContent);
	}

	public ComboDoctorEN (String[] params, boolean loadContent) {
		super(false);
		setMinListWidth(400);
		if (params == null) {
			params = new String[] {null, null};
		}

		if (loadContent) {
			initContent(params);
		} else {
			setTxCode(ConstantsTx.DOCTORCBEN_TXCODE);
		}
	}

	private void initContent(String[] params) {
		resetContent(ConstantsTx.DOCTORCBEN_TXCODE, params);
	}
}