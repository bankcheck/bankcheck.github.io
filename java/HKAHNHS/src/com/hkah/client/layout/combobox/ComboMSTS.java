package com.hkah.client.layout.combobox;

public class ComboMSTS extends ComboBoxBase {

	public ComboMSTS() {
		super();
		initContent();
	}

	public void initContent() {
		// allow blank
		setShowClearButton(false);
		setAllowBlank(true);

		// initial combobox
		resetContent("MARITALSTATUS");

		resetText();
	}
}