package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboChartRequiredBy extends ComboBoxBase {
	public ComboChartRequiredBy() {
		super(false);
		initContent();
	}

	public void initContent() {
		// initial combobox
		resetContent(ConstantsTx.DOCTOR_TXCODE, new String[] { "CallChartOrderByName", "N" });
	}
}