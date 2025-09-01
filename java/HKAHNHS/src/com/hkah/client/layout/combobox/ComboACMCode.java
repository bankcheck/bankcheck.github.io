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
public class ComboACMCode extends ComboBoxBase {

	public ComboACMCode() {
		super(true);
		initCombo();
	}

	public ComboACMCode(boolean showKey) {
		super(showKey);
		initCombo();
	}

	public ComboACMCode(TextReadOnly panel) {
		super(panel);
		initCombo();
	}

	private void initCombo() {
		initContent();
		setWidth(130);
		setMinListWidth(180);
	}

	public void initContent() {
		// initial combobox
		resetContent(ConstantsTx.ACM_CODE_TXCODE);
	}
}