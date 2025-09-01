package com.hkah.client.layout.combobox;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboOTAppOther extends ComboBoxBase {
	
	public ComboOTAppOther() {
		super(false);
		initContent();
	}

	public void initContent() {
		resetContent("OT_CANCEL_APP", new String[] { "RA" });
	}

	@Override
	public void resetText() {
		setText(EMPTY_VALUE);
	}
}