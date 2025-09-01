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
public class ComboBudgetType extends ComboBoxBase {

	private final static String DEBIT_DISPLAY = "Debit";
	private final static String DEBIT_VALUE = "D";
	private final static String CREDIT_DISPLAY = "Credit";
	private final static String CREDIT_VALUE = "C";

	public ComboBudgetType() {
		super();
		initContent();
		this.setWidth(130);
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(DEBIT_VALUE, DEBIT_DISPLAY);
		addItem(CREDIT_VALUE, CREDIT_DISPLAY);
	}
}