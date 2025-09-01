package com.hkah.client.layout.textfield;

import com.hkah.client.common.Factory;
import com.hkah.client.layout.dialog.DlgPatientAlert;

public class TextPatientNo extends TextBase {

	private String oldPatientNo = null;
	private DlgPatientAlert dlgPatientAlert = null;

	@Override
	public void onBlur() {
		super.onBlur();
		if (!getText().equals(oldPatientNo)) {
    		checkPatientAlert();
    	}
	}

	public void checkPatientAlert() {
		getDlgPatientAlert().showDialog(getText());
	}

	private DlgPatientAlert getDlgPatientAlert() {
		if (dlgPatientAlert == null) {
			dlgPatientAlert = new DlgPatientAlert(Factory.getInstance().getMainFrame()) {
				@Override
				protected void post(boolean success) {
					if (success) {
						// store old patient no
						oldPatientNo = getText();
					}
				}
			};
		}
		return dlgPatientAlert;
	}
}