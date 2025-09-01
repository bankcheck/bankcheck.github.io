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
public class ComboOTCodeType extends ComboBoxBase {
	public ComboOTCodeType() {
		this(null);
	}

	public ComboOTCodeType(String[] params) {
		super(false);
		if (params == null) {
			params = new String[] {null, null, null};
		}
		initContent(params);
	}

	private void initContent(String[] params) {
		resetContent(ConstantsTx.APPROOMTYPE_TXCODE, params);
	}
}