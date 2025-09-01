/*
 * Created on July 3, 2008
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.hkah.client.layout.textfield;
import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.KeyListener;
import com.extjs.gxt.ui.client.widget.form.TextArea;
import com.google.gwt.event.dom.client.KeyCodes;
import com.hkah.client.common.Factory;
import com.hkah.shared.constants.ConstantsVariable;

/**
 * @author Administrator
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class TextAreaBase extends TextArea implements ConstantsVariable{

	private int stringLength = -1;
	private boolean isAllowEnabled = true;
	private boolean editableForever = true;
	private boolean isAllUpperCase = false;
	private boolean isWhiteBgColor = false;
	private int defaultwidth = 200;
	private int defaultheight = 60;

	/**
	 * This method initializes
	 *
	 */
	public TextAreaBase() {
		super();
		initialize(null, -1, -1, -1, true, false);
	}

	public TextAreaBase(boolean editable) {
		super();
		initialize(null, -1, -1, -1, editable, false);
	}

	public TextAreaBase(int stringLength) {
		super();
		initialize(null, -1, -1, stringLength, true, false);
	}

	public TextAreaBase(int stringLength, boolean isAllUpperCase) {
		super();
		initialize(null, -1, -1, stringLength, true, isAllUpperCase);
	}

	public TextAreaBase(int rows, int columns) {
		super();
		initialize(null, rows, columns, -1, true, false);
	}

	public TextAreaBase(String text, int rows, int columns, boolean editable) {
		super();
		initialize(text, rows, columns, -1, editable, false);
	}

	/**
	 * This method initializes this
	 *
	 * @return void
	 */
	private void initialize(String text, int rows, int columns, int stringLength, boolean editable, boolean isAllUpperCase) {
		if (text != null && text.length() > 0) {
			setValue(text);
		} else {
			setText(EMPTY_VALUE);
		}

		if (rows > 0 && columns > 0) {
			setSize(rows, columns);
		} else {
			setSize(defaultwidth, defaultheight);
		}

		setStringLength(stringLength);
		setEditable(editable);
		setReadOnly(!editable);
		setAllUpperCase(isAllUpperCase);

		addKeyListener(new KeyListener() {
			@Override
			public void componentKeyUp(ComponentEvent event) {
			}

			@Override
			public void componentKeyPress(ComponentEvent event) {
				if (getValue() != null && !getValue().isEmpty()) {
					if (getValue().getBytes().length >= getMaxLength() &&
							(
								KeyCodes.KEY_RIGHT != event.getKeyCode()&&
								KeyCodes.KEY_LEFT != event.getKeyCode()&&
								KeyCodes.KEY_HOME != event.getKeyCode()&&
								KeyCodes.KEY_END != event.getKeyCode())&&
								KeyCodes.KEY_BACKSPACE != event.getKeyCode()&&
								getMaxLength() >0
					) {
						Factory.getInstance().addErrorMessage("Field must not longer than "+getMaxLength()+" character.");
						event.stopEvent();
						focus();
					}
				}
			}
		});
	}

	/***************************************************************************
	* Helper Functions
	**************************************************************************/

	public void setText(String text) {
		setValue(text);
	}

	public String getText() {
		if (getValue() != null) {
			if (isAllUpperCase()) {
				return getValue().toUpperCase();
			} else {
				return getValue();
			}
		} else {
			return EMPTY_VALUE;
		}
	}

	public void resetText() {
		setText(ConstantsVariable.EMPTY_VALUE);
	}

	public void setEnabled(boolean enabled) {
		super.setEnabled(enabled);
		setEditable(enabled);
	}

	public void setWhiteBackgroundColor(boolean whiteBgColor) {
		isWhiteBgColor = whiteBgColor;
	}

	public void setEditable(boolean editable) {
		setEditable(editable, isWhiteBgColor);
	}

	public void setEditable(boolean editable, boolean normalBgColor) {
		setReadOnly(!editable);
		if (editable) {
			if (normalBgColor) {
				removeInputStyleName("read-only-white");
			} else {
				removeInputStyleName("read-only");
			}
		} else {
			if (normalBgColor) {
				addInputStyleName("read-only-white");
			} else {
				addInputStyleName("read-only");
			}
		}
	}

	public boolean isEditable() {
		return !isReadOnly();
	}

	public void setEditableForever(boolean editable) {
		editableForever = editable;
		setEditable(editable);
	}

	public boolean isEditableForever() {
		return editableForever;
	}

	@Override
	public void setBounds(int x, int y, int width, int height) {
		 setPosition(x, y);
		 setSize(width, height);
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
	 * @return Returns the isAllowEnabled.
	 */
	public boolean isAllowEnabled() {
		return isAllowEnabled;
	}

	/**
	 * @param isAllowEnabled The isAllowEnabled to set.
	 */
	public void setAllowEnabled(boolean isAllowEnabled) {
		this.isAllowEnabled = isAllowEnabled;
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

	public boolean isEmpty() {
		return getText().trim().length() == 0;
	}
}