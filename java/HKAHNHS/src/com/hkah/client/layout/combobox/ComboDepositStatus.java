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
public class ComboDepositStatus extends ComboBoxBase{

	private final static String NOR_DISPLAY = "Normal";
	private final static String AVAIL_DISPLAY = "Available";
	private final static String WRITEOFF_DISPLAY = "Write Off";
	private final static String TRANSFER_DISPLAY = "Transfer";
	private final static String REFUND_DISPLAY = "Refund";
	private final static String NOR_VALUE = "N";
	private final static String AVAIL_VALUE = "A";
	private final static String WRITEOFF_VAlUE = "W";
	private final static String TRANSFER_VAlUE = "T";
	private final static String REFUND_VALUE = "R";

	public ComboDepositStatus() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(NOR_VALUE, NOR_DISPLAY);
		addItem(AVAIL_VALUE, AVAIL_DISPLAY);
		addItem(WRITEOFF_VAlUE,WRITEOFF_DISPLAY );
		addItem(TRANSFER_VAlUE,TRANSFER_DISPLAY);
		addItem( REFUND_VALUE,REFUND_DISPLAY);

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(1);
	}
}