
package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboDocName extends ComboBoxBase {
	boolean filterDoc = false;

	public ComboDocName() {
		super(true);
		initContent();
	}

	public ComboDocName(boolean showKey) {
		super(showKey);
		initContent();
	}
	
	public ComboDocName(boolean showKey, boolean filterDoc) {
		super(showKey);
		this.filterDoc = filterDoc;
		initContent();
	}

	public void initContent() {
		// initial combobox
		resetContent(ConstantsTx.DOCTOR_TXCODE, new String[] { "OrderByName", filterDoc?"Y":"N" });
	}
}