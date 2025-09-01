package com.hkah.client.layout.combobox;

public class ComboPaymentType extends ComboBoxBase{

	private final static String PAYOUT_DISPLAY = "Payout";
	private final static String RECEIPT_DISPLAY = "Receipt";
	private final static String ADWITHRAW_DISPLAY = "Advance_Withdraw";
	private final static String PAYOUT_VALUE = "P";
	private final static String RECEIPT_VALUE = "R";
	private final static String ADWITHRAW_VALUE = "A";

	public ComboPaymentType() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(EMPTY_VALUE, EMPTY_VALUE);
		addItem(PAYOUT_VALUE, PAYOUT_DISPLAY);
		addItem(RECEIPT_VALUE, RECEIPT_DISPLAY);
		addItem(ADWITHRAW_VALUE, ADWITHRAW_DISPLAY);

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}