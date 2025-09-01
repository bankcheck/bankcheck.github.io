package com.hkah.client.layout.combobox;

public class ComboPickListOrderBy extends ComboBoxBase {
	public ComboPickListOrderBy() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		setShowClearButton(false);
		addItem("P", "Patient No.");
		addItem("T", "Terminal Digit");

		resetText();
	}
	
	public void resetContentForOPD() {
		removeAllItems();
		setShowClearButton(false);
		addItem("D", "Default");
		addItem("T", "Terminal Digit");

		resetText();
	}
	
	public void resetContentForIPD() {
		removeAllItems();
		setShowClearButton(false);
		addItem("P", "Patient No.");
		addItem("T", "Terminal Digit");

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}
