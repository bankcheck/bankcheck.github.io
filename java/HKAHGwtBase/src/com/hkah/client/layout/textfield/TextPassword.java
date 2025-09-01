package com.hkah.client.layout.textfield;

import com.hkah.client.layout.table.TableList;

public class TextPassword extends TextString {

	public TextPassword() {
		super();
		setPassword(true);
	}
	
	public TextPassword(boolean isAllUpper) {
		super(isAllUpper);
		setPassword(true);
	}

	public TextPassword(TableList table, int column) {
		super(table, column);
		setPassword(true);
	}

	public String getPassword() {
		return getText();
	}
}