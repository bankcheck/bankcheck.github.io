package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboReferDotor extends ComboBoxBase {
	public ComboReferDotor() {
		this(null, true);
	}

	public ComboReferDotor(boolean loadContent) {
		this(null, loadContent);
	}

	public ComboReferDotor(String[] params, boolean loadContent) {
		super(false);
		setMinListWidth(400);		
		if (params == null) {
			params = new String[] { null, null };
		}

		if (loadContent) {
			initContent(params);
		} else {
			setTxCode(ConstantsTx.APPREFERDOCTOR_TXCODE);
		}
	}

	private void initContent(String[] params) {
		resetContent(ConstantsTx.APPREFERDOCTOR_TXCODE, params);
	}
}