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
public class ComboRLSType extends ComboBoxBase {

	private final static String IP_DISPLAY = "OutStanding Balance For Patient";
	private final static String CC_DISPLAY = "Letter For Contract Company";
	private final static String IP_VALUE = "1";
	private final static String CC_VALUE = "2";

	public ComboRLSType() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(IP_VALUE, IP_DISPLAY);
		addItem(CC_VALUE, CC_DISPLAY);
	}
}