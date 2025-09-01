package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboDoctorAN extends ComboBoxBase{
	public ComboDoctorAN() {
		this(null);
	}

	public ComboDoctorAN (String[] params) {
		this(params, true);
	}
	
	public ComboDoctorAN(boolean loadContent) {
		this(null, loadContent);
	}	

	public ComboDoctorAN (String[] params, boolean showKey) {
		super(showKey);
		setMinListWidth(400);
		if (params == null) {
			params = new String[] {null, null};
		}
		initContent(params);
	}

	public ComboDoctorAN(boolean isDisplayValue, boolean loadContent) {
		this(isDisplayValue, null, loadContent);
	}

	public ComboDoctorAN(boolean isDisplayValue, String[] params, boolean loadContent) {
		super(isDisplayValue);
		setMinListWidth(400);		
		if (params == null) {
			params = new String[] {null, null};
		}

		if (loadContent) {
			initContent(params);
		} else {
			setTxCode(ConstantsTx.DOCTORCBAN_TXCODE);
		}
	}

	private void initContent(String[] params) {
		resetContent(ConstantsTx.DOCTORCBAN_TXCODE, params);
	}
}