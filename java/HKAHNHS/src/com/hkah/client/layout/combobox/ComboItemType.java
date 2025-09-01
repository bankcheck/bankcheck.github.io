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
public class ComboItemType extends ComboBoxBase {

	private final static String DOCTOR_DISPLAY = "Doctor";
	private final static String HOSPITAL_DISPLAY = "Hospital";
	private final static String SPECIAL_DISPLAY = "Special";
	private final static String OTHER_DISPLAY = "Other";
	private final static String DOCTOR_VALUE = "D";
	private final static String HOSPITAL_VALUE = "H";
	private final static String SPECIAL_VALUE = "S";
	private final static String OTHER_VALUE = "O";

	public ComboItemType() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(ConstantsVariable.EMPTY_VALUE, ConstantsVariable.EMPTY_VALUE);
		addItem(DOCTOR_VALUE, DOCTOR_DISPLAY);
		addItem(HOSPITAL_VALUE,HOSPITAL_DISPLAY);
		addItem(SPECIAL_VALUE,SPECIAL_DISPLAY);
		addItem(OTHER_VALUE,OTHER_DISPLAY);

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}