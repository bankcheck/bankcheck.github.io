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
public class ComboBirthOrdSPG extends ComboBoxBase {

	private final static String DISPLAY1 = "1";
	private final static String DISPLAY2 = "2";
	private final static String DISPLAY3 = "3";
	private final static String DISPLAY4 = "4";	
	private final static String VALUE1 = "1";
	private final static String VALUE2 = "2";
	private final static String VALUE3 = "3";
	private final static String VALUE4 = "4";	

	public ComboBirthOrdSPG() {
		super();
		initContent();
	}

	public ComboBirthOrdSPG(TextReadOnly showTextPanel) {
		super(false, showTextPanel);
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(ConstantsVariable.EMPTY_VALUE, ConstantsVariable.EMPTY_VALUE);
		addItem(DISPLAY1, VALUE1);
		addItem(DISPLAY2, VALUE2);
		addItem(DISPLAY3, VALUE3);
		addItem(DISPLAY4, VALUE4);

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}