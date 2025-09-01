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
public class ComboBookType extends ComboBoxBase {

	private final static String Booked_DISPLAY = "Booked";
	private final static String Waiting_DISPLAY = "Waiting";
	private final static String All_DISPLAY = "All";
	private final static String Booked_VALUE = "B";
	private final static String Waiting_VALUE = "W";
	private final static String All_VALUE = "A";

	public ComboBookType() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(Booked_VALUE, Booked_DISPLAY);
		addItem(Waiting_VALUE, Waiting_DISPLAY);
		addItem(All_VALUE, All_DISPLAY);

		resetText();
	}

	public void resetText() {
		super.resetText();
		setSelectedIndex(2);
	}
}