package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboAppBillType extends ComboBoxBase {
	private String smtType = EMPTY_VALUE;
	
	public ComboAppBillType() {
		super();
		setTxCode(ConstantsTx.MOBILEBILLTYPE_TXCODE);
		initContent();
	}
	
	public ComboAppBillType(String smtType) {
		super();
		setTxCode(ConstantsTx.MOBILEBILLTYPE_TXCODE);
		if (smtType != null) {
			this.smtType = smtType;
		}
	}
	
	
	public void initContent() {
		// initial combobox
		resetContent(ConstantsTx.MOBILEBILLTYPE_TXCODE, new String[]{smtType});
	}
}