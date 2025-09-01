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
public class ComboCashierStatus extends ComboBoxBase{

	private final static String NORMAL_DISPLAY = "Normal";
	private final static String NORMAL_VALUE = "N";
	private final static String CLOSE_DISPLAY = "Close";
	private final static String CLOSE_VALUE = "C";
	private final static String OFF_DISPLAY = "Off";
	private final static String OFF_VALUE = "O";

	public ComboCashierStatus() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(NORMAL_VALUE, NORMAL_DISPLAY);
		addItem(CLOSE_VALUE, CLOSE_DISPLAY);
		addItem(OFF_VALUE, OFF_DISPLAY);
	}
}