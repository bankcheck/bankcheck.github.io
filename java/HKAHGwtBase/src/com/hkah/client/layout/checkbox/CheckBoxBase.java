/*
 * Created on August 25, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.layout.checkbox;

import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.widget.form.CheckBox;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.table.TableList;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.UserInfo;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class CheckBoxBase extends CheckBox implements ConstantsVariable  {

	private TableList table = null;
	private int column = -1;
	private boolean memIsEditableForever = false;

	public CheckBoxBase() {
		super();
	}

	public CheckBoxBase(String text) {
		super();
		setBoxLabel(text);
	}
	
	public CheckBoxBase(TableList table, int column) {
		super();
		this.table = table;
		this.column = column;
	}

	public void setSelected(boolean value) {
		setValue(value);
	}

	public boolean isSelected() {
		return getValue();
	}

	public void setText(String value) {
		setText(value, false);
	}

	public void setText(String value, boolean allowUpdate) {
		setSelected(YES_VALUE.equals(value) || MINUS_ONE_VALUE.equals(value));
		if (allowUpdate) {
			onClick();
		}
	}

	public String getText() {
		return this.isSelected() ? YES_VALUE : NO_VALUE;
	}

	@Override
	protected final void onClick(ComponentEvent ce) {
		super.onClick(ce);
		// only call onClick if available
		if (isEnabled() && isEditable()) {
			onClick();
		}
	} 

	public void onClick() {
		// override by child class when key released
		if (table != null) {
			table.setValueAt(getText(), table.getSelectedRow(), column);
		}
	}
	
	@Override
	public void setBounds(int x, int y, int width, int height) {
		setPosition(x, y);
	    setSize(width, height);
	}

	public void setLocation(int x, int y) {
		setPosition(x, y);
	}

	public void setEditable(boolean editable) {
		setEditable(editable, false);
	}

	private void setEditable(boolean editable, boolean override) {
		if (isEditableForever() && !override) return;
		setReadOnly(!editable);
	}

	public boolean isEditable() {
		return !isReadOnly();
	}

	public void setEditableForever(boolean editable) {
		memIsEditableForever = editable;
		setEditable(editable, true);
	}

	private boolean isEditableForever() {
		return memIsEditableForever;
	}

	protected UserInfo getUserInfo() {
		return Factory.getInstance().getUserInfo();
	}
}