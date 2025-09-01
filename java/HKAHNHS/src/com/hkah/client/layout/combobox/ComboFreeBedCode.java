/*
 * Created on August 4, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.layout.combobox;

import com.hkah.client.layout.textfield.TextReadOnly;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboFreeBedCode extends ComboBoxBase {

	private static final String BED_FREE = "BED_FREE";
	private static final String BED = "BED";

	public ComboFreeBedCode() {
		super(false);
	}

	public ComboFreeBedCode(TextReadOnly panel) {
		super(false, panel);
	}

	public void setShowFreeBed(boolean flag) {
		// initial combobox
		if (flag) {
			resetContent(BED_FREE);
		} else {
			resetContent(BED);
		}
	}
}