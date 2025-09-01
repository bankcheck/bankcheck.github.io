/*
 * Created on August 4, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsVariable;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboPayType extends ComboBoxBase {

	private final static String AUTOPAY_DISPLAY = "Autopay";
	private final static String CASH_DISPLAY = "Cash";
	private final static String CHEQUE_DISPLAY = "Cheque";
	private final static String CREDITCARD_DISPLAY = "Credit Card";
	private final static String CUPC_DISPLAY = "CUP";
	private final static String EPS_DISPLAY = "EPS";
	private final static String OCTOPUS_DISPLAY = "Octopus";
	private final static String QR_DISPLAY = "Wechat/Alipay";
	private final static String OTHERS_DISPLAY = "Others";

	private final static String AUTOPAY_VALUE = "A";
	private final static String CASH_VALUE = "C";
	private final static String CHEQUE_VALUE = "Q";
	private final static String CREDITCARD_VALUE = "D";
	private final static String CUPC_VALUE = "U";
	private final static String EPS_VALUE = "E";
	private final static String OCTOPUS_VALUE = "T";
	private final static String QR_VALUE = "R";
	private final static String OTHERS_VALUE = "O";

	public ComboPayType() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(ConstantsVariable.EMPTY_VALUE,ConstantsVariable.EMPTY_VALUE);
		addItem(AUTOPAY_VALUE, AUTOPAY_DISPLAY);
		addItem(CASH_VALUE, CASH_DISPLAY);
		addItem(CHEQUE_VALUE, CHEQUE_DISPLAY);
		addItem(CREDITCARD_VALUE, CREDITCARD_DISPLAY);
		addItem(CUPC_VALUE, CUPC_DISPLAY);
		addItem(EPS_VALUE, EPS_DISPLAY);
		addItem(OCTOPUS_VALUE, OCTOPUS_DISPLAY);
		addItem(QR_VALUE, QR_DISPLAY);
		addItem(OTHERS_VALUE, OTHERS_DISPLAY);

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}