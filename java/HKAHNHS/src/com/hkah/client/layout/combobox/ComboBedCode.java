/*
 * Created on August 4, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.layout.combobox;

import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.shared.constants.ConstantsTx;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboBedCode extends ComboBoxBase {

	public ComboBedCode() {
		super(true);
		initContent();
	}

	public ComboBedCode(TextReadOnly panel) {
		super(panel);
		initContent();
	}

	public void initContent() {
		// initial combobox
		resetContent(ConstantsTx.BED_CODE_TXCODE);
	}
}