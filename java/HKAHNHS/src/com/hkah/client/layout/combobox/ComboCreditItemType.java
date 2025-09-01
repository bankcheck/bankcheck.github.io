/*
 * Created on August 4, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsVariable;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboCreditItemType extends ComboBoxBase {

	private final static String ALL_DISPLAY = "All";
	private final static String DOCTOR_DISPLAY = "Doctor";
	private final static String HOSPITAL_DISPLAY = "Hospital";
	private final static String SPECIAL_DISPLAY = "Special";
	private final static String OTHERS_DISPLAY = "Others";
	private final static String ALL_VALUE = "A";
	private final static String HOME_VALUE = "D";
	private final static String DOCTOR_VALUE = "H";
	private final static String SPECIAL_VALUE = "S";
	private final static String OTHERS_VALUE = "O";

	public ComboCreditItemType() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(ConstantsVariable.EMPTY_VALUE,ConstantsVariable.EMPTY_VALUE);
		addItem(ALL_VALUE, ALL_DISPLAY);
		addItem(HOME_VALUE, DOCTOR_DISPLAY);
		addItem(DOCTOR_VALUE, HOSPITAL_DISPLAY);
		addItem(SPECIAL_VALUE, SPECIAL_DISPLAY);
		addItem(OTHERS_VALUE, OTHERS_DISPLAY);

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}