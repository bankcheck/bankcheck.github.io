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
public class ComboPatientType extends ComboBoxBase {

	private final static String INPAT_DISPLAY = "In-Patient";
	private final static String OUTPAT_DISPLAY = "Out-Patient";
	private final static String DC_DISPLAY = "Daycase";
	private final static String INPAT_VALUE = "I";
	private final static String OUTPAT_VALUE = "O";
	private final static String DC_VALUE = "D";

	public ComboPatientType() {
		super();
		initContent();
	}

	public ComboPatientType(boolean showKey) {
		super(showKey);
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(ConstantsVariable.EMPTY_VALUE,ConstantsVariable.EMPTY_VALUE);
		addItem(INPAT_VALUE, INPAT_DISPLAY);
		addItem(OUTPAT_VALUE, OUTPAT_DISPLAY);
		addItem(DC_VALUE, DC_DISPLAY);

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}