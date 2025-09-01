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
public class ComboBillStatus extends ComboBoxBase{

	private final static String NOR_DISPLAY = "Normal";
	private final static String CLOSE_DISPLAY = "Closed";
	private final static String NOR_VALUE = "N";
	private final static String CLOSE_VALUE = "C";

	public ComboBillStatus() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(NOR_VALUE, NOR_DISPLAY);
		addItem(CLOSE_VALUE, CLOSE_DISPLAY);


		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}