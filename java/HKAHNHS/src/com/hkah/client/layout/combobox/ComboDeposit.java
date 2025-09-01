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
public class ComboDeposit extends ComboBoxBase{

	private final static String ALL_DISPLAY = "All";
	private final static String NOTPAY_DISPLAY = "Not Pay";
	private final static String PAID_DISPLAY = "Paid";
	private final static String ALL_VALUE = "A";
	private final static String NOTPAY_VALUE = "N";
	private final static String PAID_VALUE = "P";

	public ComboDeposit() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(ALL_VALUE, ALL_DISPLAY);
		addItem(NOTPAY_VALUE, NOTPAY_DISPLAY);
		addItem(PAID_VALUE, PAID_DISPLAY);

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}
