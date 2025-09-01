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
public class ComboSlipStatus extends ComboBoxBase {

	private final static String ACTIVE_DISPLAY = "Active";
	private final static String CLOSE_DISPLAY = "Close";
	private final static String REMOVED_DISPLAY = "Removed";
	private final static String ACTIVE_VALUE = "A";
	private final static String CLOSE_VALUE = "C";
	private final static String REMOVED_VALUE = "R";

	public ComboSlipStatus() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(ACTIVE_VALUE, ACTIVE_DISPLAY);
		addItem(CLOSE_VALUE, CLOSE_DISPLAY);
		addItem(REMOVED_VALUE, REMOVED_DISPLAY);

		resetText();
	}

	public boolean isActive() {
		return ACTIVE_VALUE.equals(getText());
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}