package com.hkah.client.layout.combobox;

public class ComboSource4CPLab extends ComboBoxBase {

	private final static String REGULAR_OUTPATIENT_DISPLAY = "Regular (OP)";
	private final static String REGULAR_OUTPATIENT_VALUE = "71";
	private final static String REGULAR_INPATIENT_DISPLAY = "Regular (IP)";
	private final static String REGULAR_INPATIENT_VALUE = "72";
	private final static String WALKIN_OUTPATIENT_DISPLAY = "Walk-In (OP)";
	private final static String WALKIN_OUTPATIENT_VALUE = "73";
	private final static String WALKIN_INPATIENT_DISPLAY = "Walk-In (IP)";
	private final static String WALKIN_INPATIENT_VALUE = "74";

	public ComboSource4CPLab() {
		super();
		setMinListWidth(200);
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem( REGULAR_OUTPATIENT_VALUE, REGULAR_OUTPATIENT_DISPLAY);
		addItem( REGULAR_INPATIENT_VALUE, REGULAR_INPATIENT_DISPLAY);
		addItem( WALKIN_OUTPATIENT_VALUE, WALKIN_OUTPATIENT_DISPLAY);
		addItem( WALKIN_INPATIENT_VALUE, WALKIN_INPATIENT_DISPLAY);

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}
