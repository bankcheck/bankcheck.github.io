/*
 * Created on July 3, 2008
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
public class TextDesc extends TextString {

	public TextDesc() {
		super(200, true);
	}

	public TextDesc(int stringLength) {
		super(stringLength, true);
	}

	public TextDesc(TableList table, int column) {
		super(200, table, column);
	}
}