/*
 * Created on August 4, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.layout.combobox;

import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.shared.constants.ConstantsVariable;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboSex extends ComboBoxBase {

	private final static String MALE_DISPLAY = "Male";
	private final static String FEMALE_DISPLAY = "Female";
	private final static String UNKNOWN_DISPLAY = "Unknown";
	private final static String MALE_VALUE = "M";
	private final static String FEMALE_VALUE = "F";
	private final static String UNKNOWN_VALUE = "U";

	public ComboSex() {
		super();
		initContent();
	}

	public ComboSex(TextReadOnly showTextPanel) {
		super(false, showTextPanel);
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(ConstantsVariable.EMPTY_VALUE, ConstantsVariable.EMPTY_VALUE);
		addItem(MALE_VALUE, MALE_DISPLAY);
		addItem(FEMALE_VALUE, FEMALE_DISPLAY);
		addItem(UNKNOWN_VALUE, UNKNOWN_DISPLAY);

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}