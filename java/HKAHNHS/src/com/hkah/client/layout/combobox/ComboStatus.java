package com.hkah.client.layout.combobox;

public class ComboStatus extends ComboBoxBase{

	private final static String NOR_DISPLAY = "Normal";
	private final static String CAN_DISPLAY = "Cancel";

	private final static String NOR_VALUE = "N";
	private final static String CAN_VALUE = "C";

	public ComboStatus() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(NOR_VALUE, NOR_DISPLAY);
		addItem(CAN_VALUE, CAN_DISPLAY);

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}