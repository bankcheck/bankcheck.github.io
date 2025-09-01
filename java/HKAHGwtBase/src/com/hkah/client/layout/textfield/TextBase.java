package com.hkah.client.layout.textfield;

import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.KeyListener;
import com.extjs.gxt.ui.client.widget.form.TextField;
import com.google.gwt.event.dom.client.KeyCodes;
import com.google.gwt.user.client.Element;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.table.TableList;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.UserInfo;

public class TextBase extends TextField<String> {

	private int stringLength = -1;
	private boolean isAllUpperCase = true;
	private TableList table = null;
	private int column = -1;
	private boolean isEditableForever = false;

	public TextBase() {
		super();
		initialize(-1, null, -1, true);
	}

	public TextBase(boolean isAllUpperCase) {
		super();
		initialize(-1, null, -1, isAllUpperCase);
	}

	public TextBase(TableList table, int column) {
		super();
		initialize(-1, table, column, true);
	}

	public TextBase(int stringLength, boolean isAllUpperCase) {
		super();
		initialize(stringLength, null, -1, isAllUpperCase);
	}

	public TextBase(int stringLength, TableList table, int column) {
		super();
		initialize(stringLength, table, column, true);
	}

	public TextBase(int stringLength, TableList table, int column, boolean isAllUpperCase) {
		super();
		initialize(stringLength, table, column, isAllUpperCase);
	}

	private void initialize(int stringLength, TableList table, int column, boolean isAllUpperCase) {
		setWidth(130);
		setStringLength(stringLength);
		setTableList(table);
		setTableColumn(column);
		setAllUpperCase(isAllUpperCase);

		addKeyListener(new KeyListener() {
			@Override
			public void componentKeyDown(ComponentEvent event) {
				onPressed();
			}

			@Override
			public void componentKeyUp(ComponentEvent event) {
				if (KeyCodes.KEY_TAB != event.getKeyCode()) {
					onReleased();
				}
			}

			@Override
			public void componentKeyPress(ComponentEvent event) {
				if (getValue() != null && getValue().getBytes().length >= getStringLength() &&
						getSelectionLength() == 0 &&
						(
								KeyCodes.KEY_RIGHT != event.getKeyCode()&&
								KeyCodes.KEY_LEFT != event.getKeyCode()&&
								KeyCodes.KEY_HOME != event.getKeyCode()&&
								KeyCodes.KEY_END != event.getKeyCode())&&
								KeyCodes.KEY_BACKSPACE != event.getKeyCode()&&
								getStringLength() > 0
						) {
					Factory.getInstance().addErrorMessage("Field must not longer than " + getStringLength() + " character.");
					event.stopEvent();
					requestFocus();
				}

				if (KeyCodes.KEY_ENTER == event.getKeyCode()) {
					onEnter();
				} else {
					onTyped();
				}
			}
		});
	}

	/***************************************************************************
	 * Helper Functions
	 **************************************************************************/

	@Override
	protected boolean validateValue(String value) {
		boolean result = super.validateValue(value);
		if (!result) {
			return false;
		}
		return true;
	}

	protected UserInfo getUserInfo() {
		return Factory.getInstance().getUserInfo();
	}

	/**
	 * @return Returns the isAllUpperCase.
	 */
	public int getStringLength() {
		return stringLength;
	}

	/**
	 * @param stringLength
	 * The stringLength to set.
	 */
	public void setStringLength(int stringLength) {
		this.stringLength = stringLength;
		if (stringLength > 0) setMaxLength(stringLength);
	}

	/**
	 * @return Returns the isAllUpperCase.
	 */
	public boolean isAllUpperCase() {
		return isAllUpperCase;
	}

	/**
	 * @param isAllUpperCase
	 * The isAllUpperCase to set.
	 */
	public void setAllUpperCase(boolean isAllUpperCase) {
		this.isAllUpperCase = isAllUpperCase;
		if (isAllUpperCase) {
			setInputStyleAttribute("text-transform", "uppercase");
		}
	}

	/**
	 * @param table
	 * The table to set.
	 */
	public void setTableList(TableList table) {
		this.table = table;
	}

	/**
	 * @param column
	 * The column to set.
	 */
	public void setTableColumn(int column) {
		this.column = column;
	}

	public void resetText() {
		super.setValue(ConstantsVariable.EMPTY_VALUE);
	}

	public void setText(String value) {
		setText(value, false);
	}

	public void setText(String value, boolean allowUpdate) {
		super.setValue(value);
		if (allowUpdate) {
			updateTable();
		}
	}

	public String getText() {
		if (getValue() != null) {
			if (isAllUpperCase()) {
				return getValue().toUpperCase();
			} else {
				return getValue();
			}
		} else {
			return ConstantsVariable.EMPTY_VALUE;
		}
	}

	public void requestFocus() {
		super.focus();
	}

	public boolean isFocusOwner() {
		return super.hasFocus;
	}

	public void setEnabled(boolean enabled) {
		super.setEnabled(enabled);
		setEditable(enabled);
	}

	public void setEditable(boolean editable) {
		setEditable(editable, false);
	}

	private void setEditable(boolean editable, boolean override) {
		if (isEditableForever() && !override) return;
		setReadOnly(!editable);
		if (editable) {
			removeInputStyleName("read-only");
		} else {
			addInputStyleName("read-only");
		}
	}

	public boolean isEditable() {
		return !isReadOnly();
	}

	public void setEditableForever(boolean editable) {
		isEditableForever = true;
		setEditable(editable, true);
	}

	private boolean isEditableForever() {
		return isEditableForever;
	}

	public void setLocation(int x,int y) {
		super.setPosition(x, y);
	}

	/**
	 * @param isError The isError to set.
	 */
	public void setErrorField(boolean isError) {
		setErrorField(isError, null);
	}

	public void setErrorField(boolean isError, String message) {
		if (isError) {
			markInvalid(message);
		} else {
			clearInvalid();
		}
	}

	private void updateTable() {
		if (getText() != null && table != null && table.getSelectedRow() >= 0 && column >= 0) {
			table.setValueAt(getText(), table.getSelectedRow(), column);
		}
	}

	public boolean isEmpty() {
		return getText().trim().length() == 0;
	}

	/***************************************************************************
	 * Parent Override Functions
	 **************************************************************************/

	@Override
	protected void onRender(Element parent, int index) {
		super.onRender(parent, index);
		if (stringLength > 0) {
			getInputEl().setElementAttribute("maxLength", stringLength);
		}
	}

	@Override
	public void setBounds(int x, int y, int width, int height) {
		setPosition(x, y);
		setSize(width, height);
	}

	@Override
	public void setMaxLength(int stringLength) {
		super.setMaxLength(stringLength);
		this.stringLength = stringLength;
		if (rendered) {
			getInputEl().setElementAttribute("maxLength", stringLength);
		}
	}

	public void setInputStyle(String style){
		getInputEl().addStyleName(style);
	}


	@Override
	protected void onBlur(ComponentEvent ce) {
		if (rendered) {
			super.onBlur(ce);
			onBlur();
		}
	}

	@Override
	protected void onFocus(ComponentEvent ce) {
		if (rendered) {
			super.onFocus(ce);
			onFocus();
		}
	}

	/***************************************************************************
	 * Child Override Functions
	 **************************************************************************/

	public void onBlur() {
		// override by child class when lost focus
		updateTable();
	}

	protected void onFocus() {
		// override by child class when on focus
	}

	protected void onPressed() {
	}

	protected void onReleased() {
		// override by child class when key released
	}

	protected void onEnter() {
		// override by child class when press enter key
	}

	protected void onTyped() {
	}
}