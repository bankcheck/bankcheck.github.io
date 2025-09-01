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
public class ComboCardType extends ComboBoxBase {

	public ComboCardType() {
		super(false);
	}

	public void initContent(String paycode) {
		// initial combobox
		resetContent(ConstantsTx.CARDTYPE, new String[] { paycode });
	}

	@Override
	protected void resetContentPost() {
		if (getStore().getCount() == 1) {
			// default set to first item
			setSelectedIndex(0);
		} else {
			setText(EMPTY_VALUE);
		}
	}
}