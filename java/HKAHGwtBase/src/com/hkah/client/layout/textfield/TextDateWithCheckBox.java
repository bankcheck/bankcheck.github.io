package com.hkah.client.layout.textfield;

import java.util.Date;

import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.FieldEvent;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.widget.form.MultiField;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.checkbox.CheckBoxBase;

public class TextDateWithCheckBox extends MultiField<TextDate> {

	private final CheckBoxBase cbFuncField;
	private final TextDate dateField;

	public TextDateWithCheckBox() {
		super();

		cbFuncField = new CheckBoxBase() {
			@Override
			public void onClick() {
				super.onClick();
				if (isSelected()) {
					dateField.setText(Factory.getInstance().getMainFrame().getServerDate());
				} else {
					dateField.resetText();
				}
			}
		};
		add(cbFuncField);

		dateField = new TextDate();
		dateField.setFireChangeEventOnSetValue(true);
		dateField.addListener(Events.Change, new Listener<FieldEvent>() {
			public void handleEvent(FieldEvent be) {
				if (dateField.getText().isEmpty()) {
					cbFuncField.setSelected(false);
				} else {
					cbFuncField.setSelected(true);
				}
			}
		});
		add(dateField);
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public TextDate getDateField() {
		return dateField;
	}

	public String getText() {
		return dateField.getText();
	}

	public void setText(String value) {
		dateField.setText(value);
	}

	public void setValue(Date value) {
		dateField.setValue(value);
	}

	public boolean isEmpty() {
		return dateField.isEmpty();
	}

	public void resetText() {
		cbFuncField.setSelected(false);
		dateField.resetText();
	}

	@Override
	public boolean isValid() {
		return dateField.isValid();
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

	public void setEditable(boolean editable) {
		cbFuncField.setEditable(editable);
		dateField.setEditable(editable);
	}

	public void onBlur() {
		dateField.onBlur();
	}

	protected void onFocus() {
		dateField.onFocus();
	}

	@Override
	public void focus() {
		dateField.focus();
	}

	public void requestFocus() {
		focus();
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	@Override
	public void setBounds(int x, int y, int width, int height) {
		setPosition(x, y);
		setSize(width, height);
		dateField.setSize(width - 20, height);
	}
}