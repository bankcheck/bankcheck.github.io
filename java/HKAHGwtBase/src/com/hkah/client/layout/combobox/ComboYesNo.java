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
public class ComboYesNo extends ComboBoxBase {

	private final static String YES_DISPLAY = "Yes";
	private final static String NO_DISPLAY = "No";
	private final static String YES_VALUE = "Y";
	private final static String NO_VALUE = "N";

	public ComboYesNo() {
		super(false);
		initContent();
	}

	public void initContent() {
		// initial combobox
		this.removeAllItems();
		this.addItem(YES_VALUE, YES_DISPLAY);
		this.addItem(NO_VALUE, NO_DISPLAY);
		//this.setSelectedIndex(1);
	}
}