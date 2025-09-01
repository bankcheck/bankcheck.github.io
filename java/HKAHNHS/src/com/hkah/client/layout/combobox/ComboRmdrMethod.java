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
public class ComboRmdrMethod extends ComboBoxBase {



	public ComboRmdrMethod() {
		super(false);
		initContent();
	}

	public void initContent() {
		// initial combobox
		this.removeAllItems();
		this.addItem("0", "Email");
		this.addItem("1", "Post");
		this.addItem("2", "Email & Post");
		//this.setSelectedIndex(1);
	}
}