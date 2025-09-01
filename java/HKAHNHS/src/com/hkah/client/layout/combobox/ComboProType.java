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
public class ComboProType extends ComboBoxBase {

	private final static String ULTRA_MAJOR_DISPLAY = "Ultra Major";
	private final static String MAJOR_DISPLAY = "Major";
	private final static String MINOR_DISPLAY = "Minor";
	private final static String ULTRA_MAJOR_VALUE = "U";
	private final static String MAJOR_VALUE = "M";
	private final static String MINOR_VALUE = "N";

	public ComboProType() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(ULTRA_MAJOR_VALUE, ULTRA_MAJOR_DISPLAY);
		addItem(MAJOR_VALUE, MAJOR_DISPLAY);
		addItem(MINOR_VALUE, MINOR_DISPLAY);
	}
}