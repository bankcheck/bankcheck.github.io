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
public class ComboFinEstPdBySts extends ComboBoxBase {
	boolean isFrmA = true;


	public ComboFinEstPdBySts(boolean isFormA) {
		super(false);
		this.isFrmA = isFormA;
		initContent();
	}

	public void initContent() {
		// initial combobox
		this.removeAllItems();
		resetContent("FINESTSTS", new String[] { isFrmA?"Y":"" });
		//this.setSelectedIndex(1);
	}
}