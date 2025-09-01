/*
 * Created on November 3, 2009
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.layout.textfield;

import com.hkah.client.layout.table.TableList;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class TextItemCode extends TextString {

	public TextItemCode() {
		super(10, true);
	}

	public TextItemCode(TableList table, int column) {
		super(10, table, column);
	}
}