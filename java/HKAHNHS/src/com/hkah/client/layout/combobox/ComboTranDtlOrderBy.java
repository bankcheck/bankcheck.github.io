package com.hkah.client.layout.combobox;

public class ComboTranDtlOrderBy extends ComboBoxBase {

	public ComboTranDtlOrderBy() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		setShowClearButton(false);
		addItem("seq", "Seq. No");
		addItem("dptcode", "Dept. Code");
		addItem("tdate", "Transaction Date");
		addItem("dptsrv", "Dept. Service");
		addItem("itmcode", "Item Code");

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}