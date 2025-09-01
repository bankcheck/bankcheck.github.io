package com.hkah.client.layout.combobox;


public class ComboPaymentStatus extends ComboBoxBase {

	private final static String NORMAL_DISPLAY = "Normal";
	private final static String VOID_DISPLAY = "Void";
	private final static String NORMAL_VALUE = "N";
	private final static String VOID_VALUE = "V";

	public ComboPaymentStatus() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(SPACE_VALUE, "All");
		addItem(NORMAL_VALUE, NORMAL_DISPLAY);
		addItem(VOID_VALUE, VOID_DISPLAY);

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(1);
	}
}
