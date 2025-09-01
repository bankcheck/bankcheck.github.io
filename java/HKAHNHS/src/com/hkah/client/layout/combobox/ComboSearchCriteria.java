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
public class ComboSearchCriteria extends ComboBoxBase {

	public ComboSearchCriteria() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem("Cross");
		addItem("Soundex");
		addItem("Wildcard");

		resetText();
	}

	public void resetText() {
		super.resetText();
		setSelectedIndex(2);
	}
}