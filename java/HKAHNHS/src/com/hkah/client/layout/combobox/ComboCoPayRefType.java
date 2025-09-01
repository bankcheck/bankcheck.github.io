/*
 * Created on August 4, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.layout.combobox;

import com.hkah.client.layout.table.TableList;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboCoPayRefType extends ComboBoxBase {

	public ComboCoPayRefType() {
		super();
		initContent();
	}

	public ComboCoPayRefType (TableList table, int column) {
		super(table, column);
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(EMPTY_VALUE);
		addItem(PERCENTAGE_VALUE);
		addItem(AMOUNT_VALUE);

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}