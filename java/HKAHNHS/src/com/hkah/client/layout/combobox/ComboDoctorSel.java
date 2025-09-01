package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboDoctorSel extends ComboBoxBase{
	public ComboDoctorSel() {
		this(null, true);
	}

	public ComboDoctorSel(boolean loadContent) {
		this(null, loadContent);
	}

	public ComboDoctorSel (String[] params, boolean loadContent) {
		super(true);
		setMinListWidth(400);
		if (params == null) {
			params = new String[] {null};
		}

		if (loadContent) {
			initContent(params);
		} else {
			setTxCode(ConstantsTx.DOCTORCBSEL_TXCODE);
		}
	}

	private void initContent(String[] params) {
		resetContent(ConstantsTx.DOCTORCBSEL_TXCODE, params);
	}
}