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
public class ComboRollbackBillType extends ComboBoxBase {

	private final static String WEEKLY_DISPLAY = "Weekly Bill";
	private final static String HIGH_DISPLAY = "Hill Bill";
	
	private final static String WEEKLY_VALUE = "W";
	private final static String HIGH_VALUE = "H";
	

	public ComboRollbackBillType() {
		super(false);
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(ConstantsVariable.EMPTY_VALUE, ConstantsVariable.EMPTY_VALUE);
		addItem(WEEKLY_VALUE, WEEKLY_DISPLAY);
		addItem(HIGH_VALUE, HIGH_DISPLAY);
		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}