/*
 * Created on August 4, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.layout.combobox;

import com.hkah.client.layout.table.TableList;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboPrApp extends ComboBoxBase {

	private final static String AP_DISPLAY = "APPROVED";
	private final static String AP_VALUE = "1";
	private final static String WA_DISPLAY = "WAITING APPROVAL";
	private final static String WA_VALUE = "0";
	private final static String ALL_DISPLAY = "ALL";
	private final static String ALL_VALUE = "ALL";

	public ComboPrApp() {
		super();
		initContent();
	}

	public ComboPrApp(TableList table, int column) {
		super(table, column);
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(ALL_VALUE, ALL_DISPLAY);
		addItem(WA_VALUE, WA_DISPLAY);
		addItem(AP_VALUE, AP_DISPLAY);
		resetText();
	}

	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}