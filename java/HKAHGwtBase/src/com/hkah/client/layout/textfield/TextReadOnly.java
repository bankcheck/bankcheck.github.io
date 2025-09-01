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
public class TextReadOnly extends TextBase {
	private boolean allowReset = true;

	public TextReadOnly() {
		super();
		initialize();
	}
	
	public TextReadOnly(String value) {
		super();
		this.setValue(value);
		initialize();
	}

	public TextReadOnly(TableList table, int column) {
		super(table, column);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 * @return void
	 */
	private void initialize() {
		setSize(100, 25);
		setEditableForever(false);
		setTabIndex(-1);
	}

	public boolean isAllowReset() {
		return allowReset;
	}

	public void setAllowReset(boolean value) {
		allowReset = value;
	}

	public boolean isEmpty() {
		return getText().trim().length() == 0;
	}
}