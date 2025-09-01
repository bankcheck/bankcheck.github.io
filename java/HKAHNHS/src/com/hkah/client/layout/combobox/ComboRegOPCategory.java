package com.hkah.client.layout.combobox;

import com.hkah.client.common.Factory;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboRegOPCategory extends ComboBoxBase {

	private final static String NORMAL_DISPLAY = "Normal";
	private final static String URGENTCARE_DISPLAY = "Urgent-Care";
	private final static String PRIORITY_DISPLAY = "Priority";
	private final static String WALKIN_DISPLAY = "Walk-In";
	private final static String NORMAL_VALUE = "N";
	private final static String URGENTCARE_VALUE = "U";
	private final static String PRIOTIRY_VALUE = "P";
	private final static String WALKIN_VALUE = "W";

	public ComboRegOPCategory() {
		super();
		initContent();
	}

	public void initContent() {
		boolean isOutPatient = Factory.getInstance().getUserInfo().isOutPatient();

		// initial combobox
		removeAllItems();

		if (isOutPatient) addItem(NORMAL_VALUE, NORMAL_DISPLAY);
		if (isOutPatient && !Factory.getInstance().getMainFrame().isDisableFunction("btnUrgentCare", "schAppoint")) addItem(URGENTCARE_VALUE, URGENTCARE_DISPLAY);
		if (isOutPatient) addItem(PRIOTIRY_VALUE, PRIORITY_DISPLAY);
		if (isOutPatient) addItem(WALKIN_VALUE, WALKIN_DISPLAY);

		resetText();
	}

	public void resetText() {
		super.resetText();
		setSelectedIndex(NORMAL_VALUE);
	}
}