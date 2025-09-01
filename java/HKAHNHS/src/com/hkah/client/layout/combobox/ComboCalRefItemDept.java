package com.hkah.client.layout.combobox;

public class ComboCalRefItemDept extends ComboBoxBase {

	public ComboCalRefItemDept() {
	    super(true);
	}

	public void initContent(String slpno) {
		// initial combobox
		resetContent("CALREFITEMDEPT", new String[] { slpno });
	}
}