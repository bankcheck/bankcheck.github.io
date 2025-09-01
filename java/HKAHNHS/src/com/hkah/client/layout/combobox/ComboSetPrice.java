/*
 * Created on August 4, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.layout.combobox;

import com.hkah.client.layout.table.TableList;
import com.hkah.shared.constants.ConstantsTx;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboSetPrice extends ComboBoxBase {

	public ComboSetPrice() {
		super(false);
		initContent();
	}
	
	public ComboSetPrice(TableList table, int column) {
		super(table, column);
		initContent();
	}

	public void initContent() {
		// TODO Auto-generated method stub
		resetContent(ConstantsTx.ITEMSET_TXCODE);
	}
}