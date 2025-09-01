package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboReferDotorDeptApp extends ComboBoxBase {
	public ComboReferDotorDeptApp() {
		this(null, true);
	}

	public ComboReferDotorDeptApp(boolean loadContent) {
		this(null, loadContent);
	}

	public ComboReferDotorDeptApp(String[] params, boolean loadContent) {
		super(false);
		if (params == null) {
			params = new String[] { null, null};
		}

		if (loadContent) {
			initContent(params);
		} else {
			setTxCode(ConstantsTx.APPREFERDOCTORDEPTAPP_TXCODE);
		}
	}

	private void initContent(String[] params) {
		resetContent(ConstantsTx.APPREFERDOCTORDEPTAPP_TXCODE, params);
	}
}