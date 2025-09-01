package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboPackage extends ComboBoxShowKey {
	private boolean isOrdering = true;
	private String criteria = EMPTY_VALUE;
	
	public ComboPackage() {
		super();
	}
	
	public ComboPackage(boolean isOrdering, String criteria) {
		super();
		this.isOrdering = isOrdering;
		if (criteria != null) {
			this.criteria = criteria;
		}
	}
	
	@Override
	public void initContent(String value) {
		// initial combobox
		resetContent(ConstantsTx.PKGCODE_TXCODE, new String[]{(isOrdering ? YES_VALUE : NO_VALUE), criteria, null});
	}
}