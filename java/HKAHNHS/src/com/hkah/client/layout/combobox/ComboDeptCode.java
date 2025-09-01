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
public class ComboDeptCode extends ComboBoxBase{

	public ComboDeptCode() {
		super(true);
		initContent();
		this.setMinListWidth(200);
	}

	public void initContent() {
		// initial combobox
		resetContent("DEPTCODE", new String[] { "ALL", "" });
	}
}