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
public class ComboRegType extends ComboBoxBase {

	private final static String INPAT_DISPLAY = "In-Patient";
	private final static String APP_DISPLAY = "Appointment";
	private final static String URGENTCARE_DISPLAY = "Urgent-Care";
	private final static String PRIORITY_DISPLAY = "Priority";
	private final static String WALKIN_DISPLAY = "Walk-In";
	private final static String DC_DISPLAY = "Daycase";
	private final static String INPAT_VALUE = "I";
	private final static String APP_VALUE = "N";
	private final static String URGENTCARE_VALUE = "U";
	private final static String PRIOTIRY_VALUE = "P";
	private final static String WALKIN_VALUE = "W";
	private final static String DC_DISPLAY_VALUE = "D";

	public ComboRegType() {
		super();
		initContent();
	}

	public void initContent() {
		boolean isInPatient = Factory.getInstance().getUserInfo().isInPatient();
		boolean isOutPatient = Factory.getInstance().getUserInfo().isOutPatient();
		boolean isDayCase = Factory.getInstance().getUserInfo().isDayCase();

		// initial combobox
		removeAllItems();
		addItem(ConstantsVariable.EMPTY_VALUE, ConstantsVariable.EMPTY_VALUE);
		if (isInPatient) addItem(INPAT_VALUE, INPAT_DISPLAY);
		if (isOutPatient) addItem(APP_VALUE, APP_DISPLAY);
		if (isOutPatient) addItem(URGENTCARE_VALUE, URGENTCARE_DISPLAY);
		if (isOutPatient) addItem(PRIOTIRY_VALUE, PRIORITY_DISPLAY);
		if (isOutPatient) addItem(WALKIN_VALUE, WALKIN_DISPLAY);
		if (isDayCase) addItem(DC_DISPLAY_VALUE, DC_DISPLAY);
	}
}