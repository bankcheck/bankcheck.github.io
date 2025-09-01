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
public class ComboDocType extends ComboBoxBase {

	private final static String COURTESTY_DISPLAY = "Courtesy";
	private final static String CONSULTANT_DISPLAY = "Consultant";
	private final static String INHOUSE_DISPLAY = "Inhouse";
	private final static String COURTESTY_VALUE = "M";
	private final static String CONSULTANT_VALUE = "C";
	private final static String INHOUSE_VALUE = "I";

	public ComboDocType() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(EMPTY_VALUE, EMPTY_VALUE);

		addItem(INHOUSE_VALUE, INHOUSE_DISPLAY);
		addItem(COURTESTY_VALUE, COURTESTY_DISPLAY);
		addItem(CONSULTANT_VALUE, CONSULTANT_DISPLAY);
	}
}