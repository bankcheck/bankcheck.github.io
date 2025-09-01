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
public class ComboSiteType extends ComboBoxBase {
	public ComboSiteType() {
		super();
		initContent();
	}

	public ComboSiteType(TableList table, int column) {
		super(table, column);
		initContent();
	}

	public void initContent() {
		resetContent(ConstantsTx.SITECODE_TXCODE);
	}

	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}