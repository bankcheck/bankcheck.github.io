package com.hkah.client.layout.combobox;

public class ComboCashierHistorySortBy extends ComboBoxBase {
	private final static String DEFAULT_DISPLAY = "Default";
	private final static String DEFAULT_VALUE= "D";
	private final static String CARDTYPE_DISPLAY = "Card Type";
	private final static String CARDTYPE_VALUE = "CT";

	public ComboCashierHistorySortBy() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(DEFAULT_VALUE, DEFAULT_DISPLAY);
		addItem(CARDTYPE_VALUE, CARDTYPE_DISPLAY);
	}
}
