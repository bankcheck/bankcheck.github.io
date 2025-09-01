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
public class ComboDeptAppPatType extends ComboBoxBase {

	private final static String INPAT_DISPLAY = "In Patient";
	private final static String INPAT_ADD_DISPLAY = "In Patient-Addon";
	private final static String OUTPAT_DISPLAY = "Out Patient";
	private final static String OUTPAT_ADD_DISPLAY = "Out Patient-Addon";
	private final static String INPAT_VALUE = "I";
	private final static String INPAT_ADD_VALUE = "E";
	private final static String OUTPAT_VALUE = "O";
	private final static String OUTPAT_ADD_VALUE = "F";

	public ComboDeptAppPatType() {
		super();
		initContent();
	}

	public ComboDeptAppPatType(boolean showKey) {
		super(showKey);
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(ConstantsVariable.EMPTY_VALUE,ConstantsVariable.EMPTY_VALUE);
		addItem(INPAT_VALUE, INPAT_DISPLAY);
		addItem(INPAT_ADD_VALUE, INPAT_ADD_DISPLAY);
		addItem(OUTPAT_VALUE, OUTPAT_DISPLAY);
		addItem(OUTPAT_ADD_VALUE, OUTPAT_ADD_DISPLAY);

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}