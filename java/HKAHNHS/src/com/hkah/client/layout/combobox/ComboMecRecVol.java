package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboMecRecVol extends ComboBoxBase{

	private String patno = null;
	private String excludeVol = null;
	
	public ComboMecRecVol() {
		this(null, null);
	}

	public ComboMecRecVol(String patno, String excludeVol) {
	    super(false);
	    this.patno = patno;
	    this.excludeVol = excludeVol;
	}

	public void initContent() {
		initContent(patno, excludeVol);
	}

	public void initContent(String patno, String excludeVol) {
		// initial combobox
		resetContent(ConstantsTx.MEDRECVOL_TXCODE, new String[] { patno, excludeVol });
	}

	public void resetList(String patno, String excludeVol) {
		removeAllItems();
		initContent(patno, excludeVol);
	}
}