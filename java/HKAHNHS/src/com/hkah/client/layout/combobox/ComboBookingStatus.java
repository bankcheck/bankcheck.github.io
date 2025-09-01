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
public class ComboBookingStatus extends ComboBoxBase {

	private final static String Normal_DISPLAY = "Normal";
	private final static String Confirm_DISPLAY = "Confirmed";
	private final static String Cancel_DISPLAY = "Cancelled";
	private final static String Pending_DISPLAY = "Pending";
	private final static String Block_DISPLAY = "Block";
	private final static String Normal_VALUE = "N";
	private final static String Confirm_VALUE = "F";
	private final static String Cancel_VALUE = "C";
	private final static String Pending_VALUE = "P";
	private final static String Block_VALUE = "B";

	public ComboBookingStatus() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(Normal_VALUE, Normal_DISPLAY);
		addItem(Confirm_VALUE, Confirm_DISPLAY);
		addItem(Cancel_VALUE, Cancel_DISPLAY);
		addItem(Pending_VALUE, Pending_DISPLAY);
		addItem(Block_VALUE, Block_DISPLAY);

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}