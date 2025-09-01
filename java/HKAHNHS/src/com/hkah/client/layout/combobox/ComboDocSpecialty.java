package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboDocSpecialty extends ComboBoxBase {

	public ComboDocSpecialty() {
		super(true);
		initContent();
	}

	public ComboDocSpecialty(boolean showKey) {
		super(showKey);
		initContent();
	}

	public void initContent() {
		// initial combobox
		resetContent(ConstantsTx.DOCTORSPE_TXCODE);
	}
}