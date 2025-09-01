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
public class ComboCMCode extends ComboBoxBase {

	public ComboCMCode(boolean showKey) {
		super(showKey);
		initContent();
	}


	public void initContent() {
		// initial combobox
		resetContent(ConstantsTx.CMCODE_TXCODE);
	}
}