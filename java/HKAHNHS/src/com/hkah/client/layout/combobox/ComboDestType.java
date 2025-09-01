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
public class ComboDestType extends ComboBoxBase {

	private final static String DEATH_DISPLAY = "Death";
	private final static String HOME_DISPLAY = "Home";
	private final static String HOSPITAL_DISPLAY = "Hospital";
	private final static String DEATH_VALUE = "D";
	private final static String HOME_VALUE = "H";
	private final static String HOSPITAL_VALUE = "P";

	public ComboDestType() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		addItem(DEATH_VALUE, DEATH_DISPLAY);
		addItem(HOME_VALUE, HOME_DISPLAY);
		addItem(HOSPITAL_VALUE, HOSPITAL_DISPLAY);
	}
}