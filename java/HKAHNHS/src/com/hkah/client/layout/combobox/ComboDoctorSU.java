/**
 *
 */
package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboDoctorSU extends ComboBoxBase{
	public ComboDoctorSU() {
		this(null, true);
	}

	public ComboDoctorSU(boolean loadContent) {
		this(null, loadContent);
	}

	public ComboDoctorSU(String[] params, boolean loadContent) {
		super(false);
		setMinListWidth(400);
		if (params == null) {
			params = new String[] {null, null};
		}

		if (loadContent) {
			initContent(params);
		} else {
			setTxCode(ConstantsTx.DOCTORCBSU_TXCODE);
		}
	}

	private void initContent(String[] params) {
		resetContent(ConstantsTx.DOCTORCBSU_TXCODE, params);
	}
}