package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboSuppCode extends ComboBoxBase {
	private String criteria1  = EMPTY_VALUE;
	private String criteria2  = EMPTY_VALUE;

	public ComboSuppCode() {
		super(true);
		initContent(criteria1,criteria2);
		this.setMinListWidth(400);
	}
	
	public ComboSuppCode(String criteria1, String criteria2) {
		super(true, true);
		if (criteria1 != null) {
			this.criteria1 = criteria1;
		}
		if (criteria2 != null) {
			this.criteria2 = criteria2;
		}		
		initContent(criteria1, criteria2);
	}

	public void initContent(String criteria1, String criteria2) {
		// initial combobox
		resetContent(ConstantsTx.SUPP_CODE_TXCODE, new String[] {criteria1,criteria2});
	}	
	
	@Override
	protected void resetContentPost() {
		// do not auto set select item
	}
}