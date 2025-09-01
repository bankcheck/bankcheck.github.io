package com.hkah.client.layout.combobox;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboOTAppCancelBy extends ComboBoxBase {
	public ComboOTAppCancelBy() {
		super(false);
		initContent();
	}

	public void initContent() {
		resetContent("OT_CANCEL_APP", new String[] { "CA" });
	}

	@Override
	public void resetText() {
		setText(EMPTY_VALUE);
	}
}