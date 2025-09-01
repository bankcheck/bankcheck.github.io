package com.hkah.client.layout.combobox;

public class ComboOrderBy extends ComboBoxBase {

	public ComboOrderBy() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();

		addItem("Patient Name");
		addItem("Patient No.");

		resetText();
	}

	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}