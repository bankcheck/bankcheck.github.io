package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsVariable;

public class ComboMedChartStatus extends ComboBoxBase {

	private final static String NORMAL_DISPLAY = "Normal";
	private final static String MISS_DISPLAY = "Missing";
	private final static String DELETED_DISPLAY = "Deleted";
	//private final static String PERMANENTDEL_DISPLAY = "Permanent eleted";
	private final static String NORMAL_VALUE = "N";
	private final static String MISS_VALUE = "M";
	private final static String DELETED_VALUE = "D";
	//private final static String PERMANENTDEL_VALUE = "P";

	public ComboMedChartStatus() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(ConstantsVariable.EMPTY_VALUE, ConstantsVariable.EMPTY_VALUE);
		addItem(NORMAL_VALUE, NORMAL_DISPLAY);
		addItem(MISS_VALUE, MISS_DISPLAY);
		addItem(DELETED_VALUE, DELETED_DISPLAY);

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(1);
	}
}