/*
 * Created on August 4, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.layout.combobox;

import com.hkah.client.common.Factory;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboDocExSMSType extends ComboBoxBase {

	private final static String OT_DISPLAY = "OT";
	private final static String IP_DISPLAY = "IP";
	private final static String BOTH_DISPLAY = "BOTH";
	private final static String ALL_DISPLAY = "ALL";
	private final static String JA_DISPLAY = "JUST ADMIT";
	
	private final static String OT_VALUE = "1";
	private final static String IP_VALUE = "2";
	private final static String BOTH_VALUE = "3";
	private final static String ALL_VALUE = "3";
	private final static String JA_VALUE = "4";

	public ComboDocExSMSType() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		if ("HKAH".equals(Factory.getInstance().getSysParameter("curtSite"))) {
			addItem(OT_VALUE, OT_DISPLAY);
			addItem(IP_VALUE, IP_DISPLAY);
			addItem(JA_VALUE, JA_DISPLAY);
			addItem(ALL_VALUE, ALL_DISPLAY);
		} else if ("TWAH".equals(Factory.getInstance().getSysParameter("curtSite"))) {
			addItem(OT_VALUE, OT_DISPLAY);
			addItem(IP_VALUE, IP_DISPLAY);
			addItem(BOTH_VALUE, BOTH_DISPLAY);
		} else {
			addItem(ALL_VALUE, ALL_DISPLAY);
		}
	}
}