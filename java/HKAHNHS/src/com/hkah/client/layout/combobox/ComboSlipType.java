/*
 * Created on August 4, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.layout.combobox;

import com.hkah.client.common.Factory;
import com.hkah.shared.constants.ConstantsVariable;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboSlipType extends ComboBoxBase {

	private final static String ALL_DISPLAY = "All";
	private final static String IN_DISPLAY = "In-Patient";
	private final static String OUT_DISPLAY = "Out-Patient";
	private final static String DAY_DISPLAY = "Daycase";
	private final static String ALL_VALUE = "";
	private final static String IN_VALUE = "I";
	private final static String OUT_VALUE = "O";
	private final static String DAY_VALUE = "D";

	public ComboSlipType() {
		super();
		initContent();
	}

	public void initContent() {
		boolean isInPatient = Factory.getInstance().getUserInfo().isInPatient();
		boolean isOutPatient = Factory.getInstance().getUserInfo().isOutPatient();
		boolean isDayCase = Factory.getInstance().getUserInfo().isDayCase();

		// initial combobox
		removeAllItems();
		addItem(ConstantsVariable.EMPTY_VALUE,ConstantsVariable.EMPTY_VALUE);
		if (isInPatient && isOutPatient && isDayCase) addItem(ALL_VALUE, ALL_DISPLAY);
		if (isInPatient) addItem(IN_VALUE, IN_DISPLAY);
		if (isOutPatient) addItem(OUT_VALUE, OUT_DISPLAY);
		if (isDayCase) addItem(DAY_VALUE, DAY_DISPLAY);

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}