package com.hkah.client.layout.combobox;

public class ComboPackageType extends ComboBoxBase {

	private final static String NORMAL_DISPLAY = "Normal";
	private final static String NORMAL_VALUE = "P";
	private final static String NATURE_OF_VISIT_DISPLAY = "Nature of Visit";
	private final static String NATURE_OF_VISIT_VALUE = "N";
	private final static String BOTH_DISPLAY = "Both";
	private final static String BOTH_VALUE = "B";

	public ComboPackageType() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(NORMAL_VALUE, NORMAL_DISPLAY);
		addItem(NATURE_OF_VISIT_VALUE, NATURE_OF_VISIT_DISPLAY);
		addItem(BOTH_VALUE, BOTH_DISPLAY);
	}
}