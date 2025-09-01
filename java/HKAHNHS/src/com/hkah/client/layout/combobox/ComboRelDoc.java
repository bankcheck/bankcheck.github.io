/*
 * Created on July 3, 2015
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboRelDoc extends ComboBoxBase {
	public ComboRelDoc() {
		this(null);
	}
	
	public ComboRelDoc(String doccodes) {
		super();
		//initContent(doccodes);
	}
	
	public void initContent(String doccodes) {
		resetContent(ConstantsTx.RELDOC_TXCODE, new String[]{doccodes},false,false,true);
	}
}
