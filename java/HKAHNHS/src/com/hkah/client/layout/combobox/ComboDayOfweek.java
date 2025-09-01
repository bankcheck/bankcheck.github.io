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
public class ComboDayOfweek extends ComboBoxBase{

	public ComboDayOfweek() {
		super(false);
		initContent();
	}

	public void initContent() {
		removeAllItems();
		addItem(ConstantsVariable.EMPTY_VALUE, ConstantsVariable.EMPTY_VALUE);
		addItem("1", "Sunday");
		addItem("2", "Monday");
		addItem("3", "Tuesday");
		addItem("4", "Wednesday");
		addItem("5", "Thursday");
		addItem("6", "Friday");
		addItem("7", "Saturday");

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}