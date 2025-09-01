package com.hkah.client.layout.combobox;

public class ComboLogSortBy extends ComboBoxBase{

	private final static String SYS_DISPLAY = "From System";
	private final static String SLP_DISPLAY = "Slip No.";
	private final static String CHARGE_DISPLAY = "Charge Code";

	private final static String SYS_VALUE = "S";
	private final static String SLP_VALUE = "N";
	private final static String CHARGE_VALUE = "C";

	public ComboLogSortBy() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(SYS_VALUE, SYS_DISPLAY);
		addItem(SLP_VALUE, SLP_DISPLAY);
		addItem(CHARGE_VALUE, CHARGE_DISPLAY);

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}