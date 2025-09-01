/*
 * Created on August 4, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboDeptServ extends ComboBoxBase{

	public ComboDeptServ() {
		super(true);
		setMinListWidth(200);
		initContent();
	}

	public ComboDeptServ(boolean showKey) {
		super(showKey);
		setMinListWidth(200);
		initContent();
	}


	public void initContent() {
		// initial combobox
		resetContent(ConstantsTx.DPSERV_TXCODE);
	}
}