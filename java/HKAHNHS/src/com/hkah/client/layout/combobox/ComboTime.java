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
public class ComboTime extends ComboBoxBase {

	private final static String T1_DISPLAY = "8:00";
	private final static String T2_DISPLAY = "15:30";
	private final static String T3_DISPLAY = "20:00";
	private final static String T1_VALUE = "T1";
	private final static String T2_VALUE = "T2";
	private final static String T3_VALUE = "T3";

	public ComboTime() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(ConstantsVariable.EMPTY_VALUE, ConstantsVariable.EMPTY_VALUE);
		addItem(T1_VALUE, T1_DISPLAY);
		addItem(T2_VALUE,T2_DISPLAY);
		addItem(T3_VALUE,T3_DISPLAY);

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}