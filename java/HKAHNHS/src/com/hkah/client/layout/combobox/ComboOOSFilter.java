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
public class ComboOOSFilter extends ComboBoxBase {

	private final static String ALL_DISPLAY = "All";
	private final static String INCL_DENTAL_DISPLAY = "Dental ONLY";
	private final static String EXCL_DENTAL_DISPLAY = "Exclude Dental";
	private final static String ALL_VALUE = "99";
	private final static String INCL_DENTAL_VALUE = "1";
	private final static String EXCL_DENTAL_VALUE = "2";


	public ComboOOSFilter() {
		super();
		setMinListWidth(200);
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem( ALL_VALUE,ALL_DISPLAY);
		addItem( INCL_DENTAL_VALUE,INCL_DENTAL_DISPLAY);
		addItem( EXCL_DENTAL_VALUE,EXCL_DENTAL_DISPLAY);

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}