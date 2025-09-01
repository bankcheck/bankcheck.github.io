/*
 * Created on August 4, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.layout.combobox;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboPrintAddress extends ComboBoxBase {

	private final static String NULL_DISPLAY = "";
	private final static String HOME_DISPLAY = "Home";
	private final static String CONTACT_DISPLAY = "Contact";
	private final static String OFFICE_DISPLAY = "Office";

	private final static String NULL_VALUE = "";
	private final static String HOME_VALUE = "H";
	private final static String CONTACT_VALUE = "C";
	private final static String OFFICE_VALUE = "O";

	public ComboPrintAddress() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(NULL_VALUE, NULL_DISPLAY);
		addItem(HOME_VALUE, HOME_DISPLAY);
		addItem(CONTACT_VALUE, CONTACT_DISPLAY);
		addItem(OFFICE_VALUE, OFFICE_DISPLAY);
	}
}