package com.hkah.client.layout.combobox;

import com.hkah.client.util.CommonUtil;

public class ComboDoctorLocation extends ComboBoxBase {

	private final static String DOCTOR_LOCATION_TXCODE = "DoctorLocation";

	public ComboDoctorLocation() {
		super(false);
		initContent();
	}

	public void initContent() {
		// initial combobox
		resetContent(DOCTOR_LOCATION_TXCODE, new String[] { CommonUtil.getComputerIP() });
	}

	@Override
	protected void resetContentPost() {
		// override for child class
		if (getKeySize() > 0) {
			// default set to first item
			setSelectedIndex(0);
		}
	}

	public void resetText() {
		super.resetText();
		resetContentPost();
	}
}