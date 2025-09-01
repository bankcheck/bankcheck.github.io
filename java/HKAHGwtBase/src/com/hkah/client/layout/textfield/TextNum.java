/*
 * Created on July 3, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.layout.textfield;

import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.FieldEvent;
import com.extjs.gxt.ui.client.event.KeyListener;
import com.extjs.gxt.ui.client.widget.form.NumberField;
import com.google.gwt.dom.client.NativeEvent;
import com.google.gwt.event.dom.client.KeyCodes;
import com.google.gwt.user.client.Element;
import com.hkah.client.layout.table.TableList;
import com.hkah.shared.constants.ConstantsVariable;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class TextNum extends NumberField implements ConstantsVariable {

	private static final char decimalSeparator = '.';

	private int stringLength = 0;
	private int integralDigitNum = 0;
	private int decimalDigitNum = 0;
	private boolean isCommaSeparated = false;
	private boolean isQtyField = false;
	private TableList table = null;
	private int column = -1;
	private boolean isEditableForever = false;

	public TextNum() {
		super();
	}

	public TextNum(int integralDigitNum) {
		super();
		initialize(integralDigitNum, 0, false, false, false, null, -1);
	}

	public TextNum(int integralDigitNum, int decimalDigitNum) {
		super();
		initialize(integralDigitNum, decimalDigitNum, false, false, false, null, -1);
	}

	public TextNum(int integralDigitNum, int decimalDigitNum, boolean isCommaSeparated) {
		super();
		initialize(integralDigitNum, decimalDigitNum, isCommaSeparated, false, false, null, -1);
	}

	public TextNum(int integralDigitNum, int decimalDigitNum, boolean isCommaSeparated, boolean allowNegative) {
		super();
		initialize(integralDigitNum, decimalDigitNum, isCommaSeparated, allowNegative, false, null, -1);
	}

	public TextNum(int integralDigitNum, int decimalDigitNum, boolean isCommaSeparated, boolean allowNegative, boolean isQtyField) {
		super();
		initialize(integralDigitNum, decimalDigitNum, isCommaSeparated, allowNegative, isQtyField, null, -1);
	}

	public TextNum(int integralDigitNum, TableList table, int column) {
		super();
		initialize(integralDigitNum, 0, false, false, false, table, column);
	}

	private void initialize(int integralDigitNum, int decimalDigitNum,
			boolean isCommaSeparated, boolean allowNegative, boolean isQtyField,
			TableList table, int column) {
		setIntegralDigitNum(integralDigitNum);
		setDecimalDigitNum(decimalDigitNum);

		setCommaSeparated(isCommaSeparated);
		setAllowNegative(allowNegative);
		setQtyField(isQtyField);

		setTableList(table);
		setTableColumn(column);

		addKeyListener(new KeyListener() {
			@Override
			public void componentKeyDown(ComponentEvent event) {
				onPressed();
				onPressed(event.getKeyCode());
			}

			@Override
			public void componentKeyUp(ComponentEvent event) {
		        if (KeyCodes.KEY_TAB != event.getKeyCode()) {
					onReleased();
				}
		        onReleased(event.getKeyCode());
			}

			@Override
			public void componentKeyPress(ComponentEvent event) {
				if (KeyCodes.KEY_ENTER == event.getKeyCode()) {
					onEnter();
				} else {
					onTyped();
					onTyped(event.getKeyCode());
				}
			}
		});
	}


	/***************************************************************************
	 * Helper Functions
	 **************************************************************************/

	/**
	 * @param table
	 * The table to set.
	 */
	public void setTableList(TableList value) {
		table = value;
	}

	/**
	 * @param column
	 * The column to set.
	 */
	public void setTableColumn(int value) {
		column = value;
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

	protected boolean isValidField() {
		return true;
	}

	public boolean validateDigit() {
		int index = getText().indexOf(".");
		int length = getText().length();
		if (index == 0) {
			return false;
		} else {
			if (index > 0) {
				if (index > getIntegralDigitNum()) {
					return false;
				} else if (length - index -1  > getDecimalDigitNum()) {
					return false;
				}
			} else if (length > getIntegralDigitNum()) {
				return false;
			}
		}
		return true;
	}

	public String getText() {
		if (getValue() == null) {
			return EMPTY_VALUE;
		} else {
			return getValue().toString();
		}
	}

	public void resetText() {
		setText(EMPTY_VALUE);
	}

	public void setText(String text) {
		if (text != null && text.trim().length() > 0) {
			try {
				if (getDecimalDigitNum() == 0) {
					setValue(new Integer(text));
				} else {
					setValue(new Double(text));
				}
			} catch (Exception e) {
				setRawValue(EMPTY_VALUE);
			}
		} else {
			setRawValue(EMPTY_VALUE);
		}
	}

	protected int getMaxInputLength() {
		int result = getDecimalDigitNum(true);
		if (result > 0) {
			// for decimal
			result++;
		}
		result += getIntegralDigitNum();
		if (isCommaSeparated()) {
			// for coma
			result += integralDigitNum / 3;
		}
		if (getAllowNegative()) {
			// for negative sign
			result++;
		}
		return result;
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

	public void requestFocus() {
		super.focus();
	}

	/**
	 * @return
	 */
	private boolean isCommaSeparated() {
		return isCommaSeparated;
	}

	/**
	 * @param b
	 */
	private void setCommaSeparated(boolean b) {
		isCommaSeparated = b;
		setMaxLength(getMaxInputLength());
	}

	/**
	 * @return
	 */
	protected boolean isQtyField() {
		return isQtyField;
	}

	/**
	 * @return
	 */
	private void setQtyField(boolean qtyField) {
		isQtyField = qtyField;
		setMaxLength(getMaxInputLength());
	}

	/**
	 * @return
	 */
	private int getIntegralDigitNum() {
		return integralDigitNum;
	}

	/**
	 * @param i
	 */
	private void setIntegralDigitNum(int i) {
		integralDigitNum = i;
		setMaxLength(getMaxInputLength());
	}

	/**
	 * @return
	 */
	private int getDecimalDigitNum() {
		return decimalDigitNum;
	}

	/**
	 * @return
	 */
	private int getDecimalDigitNum(boolean includeMultipleQtyLength) {
		if (includeMultipleQtyLength && isQtyField()) {
			return decimalDigitNum + 4;
		} else {
			return decimalDigitNum;
		}
	}

	/**
	 * @param i
	 */
	private void setDecimalDigitNum(int i) {
		decimalDigitNum = i;
		if (decimalDigitNum == 0) {
			setPropertyEditorType(Integer.class);
		} else {
			setPropertyEditorType(Double.class);
		}
		setMaxLength(getMaxInputLength());
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
	public void setMaxLength(int value) {
		super.setMaxLength(value);
		stringLength = value;
		if (rendered) {
			getInputEl().setElementAttribute("maxLength", value);
		}
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

	@Override
	protected void onKeyPress(FieldEvent fe) {
		super.onKeyPress(fe);

		char key = getChar(fe.getEvent());

		// more logic to check decimal
		if (key == decimalSeparator && (getDecimalDigitNum() == 0 || getRawValue().indexOf(decimalSeparator) >= 0)) {
			fe.stopEvent();
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
		// override by child class when key pressed
	}

	protected void onReleased() {
		// override by child class when key released
	}

	protected void onEnter() {
		// override by child class when press enter key
	}

	protected void onTyped() {
		// override by child class when key typed
	}
	
	protected void onPressed(int KeyCode) {
		// override by child class when key pressed
	}
	
	protected void onTyped(int KeyCode) {
		// override by child class when key typed
	}
	
	protected void onReleased(int KeyCode) {
		// override by child class when key released
	}

	/***************************************************************************
	 * Native Functions
	 **************************************************************************/

	// needed due to GWT 2.1 changes (copy from SpinnerField.class)
	private native char getChar(NativeEvent e) /*-{
		return e.which || e.charCode || e.keyCode || 0;
	}-*/;
}