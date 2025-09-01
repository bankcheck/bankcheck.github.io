package com.hkah.client.layout.combobox;

public class ComboPkgJoined extends ComboBoxBase{

	public ComboPkgJoined() {
		super();
	}

	public ComboPkgJoined(String slpno) {
		super();
		initContent(slpno);
	}

	public void initContent(String slpno) {
		// initial combobox
		resetContent("PKGJOINED", new String[] { slpno });
	}

	@Override
	protected void resetContentPost() {
		// override for child class
		if (getStore().getCount() > 0) {
			// default set to first item
			this.setSelectedIndex(0);
		}
	}
}