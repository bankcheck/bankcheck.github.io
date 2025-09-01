package com.hkah.client.layout.combobox;

import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsTx;

public class ComboOTTmpType extends ComboBoxBase {
	public ComboOTTmpType() {
		this(null);
	}
	
	public ComboOTTmpType(String[] doccodes) {
		super();
		//initContent(doccodes);
	}
	
	public void initContent(String[] doccodes) {
		initContent(combineDoccode(doccodes));
	}

	public void initContent(String doccodesStr) {
		resetContent(ConstantsTx.OTTMPTYPE_TXCODE, new String[]{doccodesStr});
	}
	
	public String combineDoccode(String[] doccodes) {
		String doccodesStr = null;
		if (doccodes != null) {
			doccodesStr = TextUtil.combine(doccodes, "','");
			doccodesStr = "'" + doccodesStr + "'";
		}
		return doccodesStr;
	}
}