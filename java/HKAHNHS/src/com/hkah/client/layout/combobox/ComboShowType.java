package com.hkah.client.layout.combobox;

public class ComboShowType extends ComboBoxBase {

	private final static String ALL_DISPLAY = "All";
	private final static String NOSHOW_DISPLAY = "No Show";
	private final static String SHOW_DISPLAY = "Show";
	private final static String ALL_VALUE = "A";
	private final static String NOSHOW_VALUE = "N";
	private final static String SHOW_VALUE = "S";

	public ComboShowType() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(ALL_VALUE, ALL_DISPLAY);
		addItem(NOSHOW_VALUE, NOSHOW_DISPLAY);
		addItem(SHOW_VALUE, SHOW_DISPLAY);

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(1);
	}
}