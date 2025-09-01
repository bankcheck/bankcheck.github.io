/*
 * Created on August 4, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.layout.combobox;

import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboMRIPRmk extends ComboBoxBase {

	public ComboMRIPRmk() {
		super(false);
		initContent();
	}

	public void initContent() {
		// initial combobox
		resetContent(ConstantsTx.MRINPRMK_TXCODE);
	}
}