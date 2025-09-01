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
public class TextString extends TextBase {

	public TextString() {
		this(50, true);
	}

	public TextString(boolean isAllUpperCase) {
		this(50, isAllUpperCase);
	}

	public TextString(int stringLength) {
		this(stringLength, true);
	}

	public TextString(int stringLength, boolean isAllUpperCase) {
		super(stringLength, isAllUpperCase);
		initialize();
	}

	public TextString(TableList table, int column) {
		this(50, table, column);
	}

	public TextString(int stringLength, TableList table, int column) {
		super(stringLength, table, column);
		initialize();
	}
	
	public TextString(int stringLength, TableList table, int column, boolean isAllUpperCase) {
		super(stringLength, table, column, isAllUpperCase);
		initialize();
	}

	private void initialize() {
		setHideLabel(true);
	}
}