package com.hkah.client.layout.combobox;

public class ComboOTLogStatus extends ComboBoxBase{

	private final static String A_DISPLAY = "Active";
	private final static String C_DISPLAY = "Closed";

	private final static String A_VALUE = "A";
	private final static String C_VALUE = "C";

	public ComboOTLogStatus() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(A_VALUE, A_DISPLAY);
		addItem(C_VALUE, C_DISPLAY);

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}