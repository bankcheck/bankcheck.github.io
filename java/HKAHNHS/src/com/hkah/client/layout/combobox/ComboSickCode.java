package com.hkah.client.layout.combobox;

/*
 * Created on Jan 1, 2011
*
* To change the template for this generated file go to
* Window - Preferences - Java - Code Generation - Code and Comments
*/
public class ComboSickCode extends ComboBoxBase {

	private final static String SICKCODE_DISPLAY_1 = "Same Sick Code";
	private final static String SICKCODE_VALUE_1 = "S";
	private final static String SICKCODE_DISPLAY_2 = "Not Same Sick Code";
	private final static String SICKCODE_VALUE_2 = "N";
	private final static String SICKCODE_DISPLAY_3 = "Ignore Sick Code";
	private final static String SICKCODE_VALUE_3 = "I";

	public ComboSickCode() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(SICKCODE_VALUE_1, SICKCODE_DISPLAY_1);
		addItem(SICKCODE_VALUE_2, SICKCODE_DISPLAY_2);
		addItem(SICKCODE_VALUE_3, SICKCODE_DISPLAY_3);
	}
}