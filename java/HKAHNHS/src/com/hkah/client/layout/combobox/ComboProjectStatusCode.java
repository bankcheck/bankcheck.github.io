/*
 * Created on June 27, 2012
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.layout.combobox;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboProjectStatusCode extends ComboBoxBase {

	public ComboProjectStatusCode() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem("To Start");
		addItem("To Prioritize");
		addItem("Pending");
		addItem("Design");
		addItem("In Progress");
		addItem("Completed");
		addItem("UAT");
		addItem("Ready");
		addItem("Live Run");
	}
}