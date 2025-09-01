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
public class ComboCordCutPlace extends ComboBoxBase {

	private final static String H_DISPLAY = "HK";
	private final static String K_DISPLAY = "HK(others)";
	private final static String M_DISPLAY = "Mainland";
	private final static String O_DISPLAY = "Other";
	private final static String U_DISPLAY = "Unknown";
	private final static String H_VALUE = "H";
	private final static String K_VALUE = "K";
	private final static String M_VALUE = "M";
	private final static String O_VALUE = "O";
	private final static String U_VALUE = "U";

	public ComboCordCutPlace() {
		super(false);
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(H_VALUE, H_DISPLAY);
		addItem(K_VALUE, K_DISPLAY);
		addItem(M_VALUE, M_DISPLAY);
		addItem(NO_VALUE, O_DISPLAY);
		addItem(O_VALUE, H_DISPLAY);
		addItem(U_VALUE, U_DISPLAY);

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}