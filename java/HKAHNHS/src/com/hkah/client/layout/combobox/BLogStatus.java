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
public class BLogStatus extends ComboBoxBase {

	private final static String ALL_DISPLAY = "All";
	private final static String NORMAL_DISPLAY = "Normal";
	private final static String CONFIMED_DISPLAY = "Confimed";
	private final static String CLOSED_DISPLAY = "Closed";
	private final static String REJECTED_DISPLAY = "Rejected";
	private final static String MANUAL_DISPLAY = "Manual";
	private final static String NORMAL_VALUE = "N";
	private final static String CONFIMED_VALUE = "C";
	private final static String CLOSED_VALUE = "A";
	private final static String REJECTED_VALUE = "R";
	private final static String MANUAL_VALUE = "M";

	public BLogStatus() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		//addItem(ConstantsVariable.EMPTY_VALUE,ConstantsVariable.EMPTY_VALUE);
		addItem( ConstantsVariable.EMPTY_VALUE, ALL_DISPLAY);
		addItem( NORMAL_VALUE, NORMAL_DISPLAY);
		addItem( CONFIMED_VALUE, CONFIMED_DISPLAY);
		addItem( CLOSED_VALUE, CLOSED_DISPLAY);
		addItem( REJECTED_VALUE, REJECTED_DISPLAY);
		addItem( MANUAL_VALUE, MANUAL_DISPLAY);

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(NORMAL_VALUE);
	}
}