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
public class ComboTelLogSortby extends ComboBoxBase {

	private final static String FS_DISPLAY = "From System";
	private final static String FS_VALUE= "FS";
	private final static String SLPNO_DISPLAY = "Slip No.";
	private final static String SLPNO_VALUE = "SLPNO";
	private final static String CHGCODE_DISPLAY = "Charge Code";
	private final static String CHGCODE_VALUE = "CHGCODE";

	public ComboTelLogSortby() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(FS_VALUE,FS_DISPLAY);
		addItem(SLPNO_VALUE,SLPNO_DISPLAY);
		addItem(CHGCODE_VALUE,CHGCODE_DISPLAY);
	}
}