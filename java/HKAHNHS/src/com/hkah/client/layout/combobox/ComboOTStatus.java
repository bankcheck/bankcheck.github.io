package com.hkah.client.layout.combobox;

public class ComboOTStatus extends ComboBoxBase{

	private final static String CAN_DISPLAY = "Cancelled";
	private final static String CON_DISPLAY = "Confirmed";
	private final static String NOR_DISPLAY = "Normal";

	private final static String CAN_VALUE = "C";
	private final static String CON_VALUE = "F";
	private final static String NOR_VALUE = "N";

	public ComboOTStatus() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(CAN_VALUE, CAN_DISPLAY);
		addItem(CON_VALUE, CON_DISPLAY);
		addItem(NOR_VALUE, NOR_DISPLAY);

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(2);
	}
}