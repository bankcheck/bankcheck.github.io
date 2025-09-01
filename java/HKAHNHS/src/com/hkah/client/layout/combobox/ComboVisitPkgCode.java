package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboVisitPkgCode extends ComboBoxBase{

	private String slpno = null;

	public ComboVisitPkgCode(String slpno) {
	    super(false);
	    this.slpno = slpno;
		initContent();
	}

	public void initContent() {
		initContent(slpno);
	}

	public void initContent(String slpno) {
		// initial combobox
		resetContent(ConstantsTx.VISITPKGCODE_TXCODE, new String[] { slpno });
	}

	public void resetList(String slpno) {
		removeAllItems();
		initContent(slpno);
	}
}