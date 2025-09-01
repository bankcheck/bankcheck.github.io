package com.hkah.client.layout.combobox;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboOTAppIsAdmitted extends ComboBoxBase {

	public ComboOTAppIsAdmitted() {
		super(false);
		initContent();
	}

	public void initContent() {
		// initial combobox
		resetContent("OT_CANCEL_APP", new String[] { "AD" });
	}

	@Override
	public void resetText() {
		setText(EMPTY_VALUE);
	}
}