/*
 * Created on August 4, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsVariable;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboRomSex extends ComboBoxBase {

	private final static String MALE_DISPLAY = "Male";
	private final static String FEMALE_DISPLAY = "Female";
	private final static String UNKNOWN_DISPLAY = "Universal";
	private final static String ALWAYMALE_DISPLAY = "Alway Male";
	private final static String ALWAYFEMALE_DISPLAY = "Alway Female";
	private final static String MALE_VALUE = "M";
	private final static String FEMALE_VALUE = "F";
	private final static String UNKNOWN_VALUE = "U";
	private final static String ALWAYMALE_VALUE = "Y";
	private final static String ALWAYFEMALE_VALUE = "Z";

	public ComboRomSex() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(ConstantsVariable.EMPTY_VALUE,ConstantsVariable.EMPTY_VALUE);
		addItem(MALE_VALUE, MALE_DISPLAY);
		addItem(FEMALE_VALUE, FEMALE_DISPLAY);
		addItem(UNKNOWN_VALUE, UNKNOWN_DISPLAY);
		addItem(ALWAYMALE_VALUE, ALWAYMALE_DISPLAY);
		addItem(ALWAYFEMALE_VALUE, ALWAYFEMALE_DISPLAY);
	}
}