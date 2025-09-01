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
public class ComboAnesMeth extends ComboBoxBase {
	public ComboAnesMeth() {
		this(null, true);
	}

	public ComboAnesMeth(boolean loadContent) {
		this(null, loadContent);
	}

	public ComboAnesMeth(String[] params, boolean loadContent) {
		super(loadContent);		
		if (params == null) {
			params = new String[] {null, null};
		}

		if (loadContent) {
			initContent(params);
		} else {
			setTxCode(ConstantsTx.APPANESMETH_TXCODE);
		}
	}

	private void initContent(String[] params) {
		resetContent(ConstantsTx.APPANESMETH_TXCODE, params);
	}
}