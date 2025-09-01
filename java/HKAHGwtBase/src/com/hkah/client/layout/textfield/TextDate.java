package com.hkah.client.layout.textfield;

import java.util.Date;

import com.extjs.gxt.ui.client.GXT;
import com.extjs.gxt.ui.client.core.El;
import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.KeyListener;
import com.extjs.gxt.ui.client.widget.form.DateField;
import com.extjs.gxt.ui.client.widget.form.DateTimePropertyEditor;
import com.google.gwt.event.dom.client.KeyCodes;
import com.google.gwt.i18n.client.DateTimeFormat;
import com.google.gwt.user.client.DOM;
import com.google.gwt.user.client.Element;
import com.google.gwt.user.client.Event;
import com.hkah.client.layout.table.TableList;
import com.hkah.shared.constants.ConstantsVariable;

public class TextDate extends DateField {

	private TableList table = null;
	protected Date selectedDate = null;
	private int column = -1;
	private boolean isEditableForever = false;
	private boolean addClearTrigger = false;

	protected El twinTrigger;
	private final String twinTriggerStyle = "x-form-clear-trigger";
	private El span;

	public TextDate() {
		super();
		initialize();
	}

	public TextDate(TableList table, int column) {
		super();
		setTableList(table);
		setTableColumn(column);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 * @return void
	 */
	private void initialize() {
		if (getStringLength() > 0) setMaxLength(getStringLength());
		getPropertyEditor().setFormat(getDateTimeFormat());
		setPropertyEditor(new DateTimePropertyEditor(getDateTimePattern()));
		getDatePicker().setStartDay(7);
		setWidth(130);

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
				if (KeyCodes.KEY_ENTER == event.getKeyCode()) {
					onEnter();
				} else {
					onTyped();
				}
			}
		});
	}

	protected String getDateTimePattern() {
		return "dd/MM/yyyy";
	}

	public DateTimeFormat getDateTimeFormat(){
		return DateTimeFormat.getFormat(getDateTimePattern());
	}

	/***************************************************************************
	* Helper Functions
	**************************************************************************/

	public void setText(String value) {
		setText(value, false);
	}

	public void setText(String value, boolean allowUpdate) {
		try {
			if (value != null && value.length() > 0) {
				super.setValue(getDateTimeFormat().parse(value));
				if (allowUpdate) {
					updateTable();
				}
				return;
			}
		} catch (Exception e) {}
		clear();
	}

	public String getText() {
		try {
			if (super.getValue() != null) {
				return getDateTimeFormat().format(getValue());
			}
		} catch (Exception e) {}
		return ConstantsVariable.EMPTY_VALUE;
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
		setValue(null);
	}

	@Override
	public void setBounds(int x, int y, int width, int height) {
		setPosition(x, y);
		setSize(width, height);
	}

	public void setEnabled(boolean enabled) {
		super.setEnabled(enabled);
		setEditable(enabled);
	}

	@Override
	public void setEditable(boolean editable) {
		setEditable(editable, false);
	}

	private void setEditable(boolean editable, boolean override) {
		if (isEditableForever() && !override) return;
		super.setEditable(editable);
		setReadOnly(!editable);
		if (editable) {
			removeInputStyleName("read-only");
		    removeStyleName("x-item-disabled");
		} else {
			addInputStyleName("read-only");
		    addStyleName("x-item-disabled");
		}
	}

	public void setEditableForever(boolean editable) {
		this.isEditableForever = true;
		setEditable(editable, true);
	}

	private boolean isEditableForever() {
		return isEditableForever;
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

	public boolean isFocusOwner() {
		return super.hasFocus;
	}

	public boolean isAddClearTrigger() {
		return addClearTrigger;
	}

	public void setAddClearTrigger(boolean addClearTrigger) {
		this.addClearTrigger = addClearTrigger;
	}

	private void updateTable() {
		if (getText() != null && table != null && table.getSelectedRow() >= 0 && column >= 0) {
			table.setValueAt(getText(), table.getSelectedRow(), column);
		}
	}

	protected int getStringLength() {
		return getDateTimePattern().length();
	}

	public boolean isEmpty() {
		return getRawValue().trim().length() == 0;
	}

	@Override
	public boolean isValid() {
		if (super.isValid() && getRawValue().trim().length() == getStringLength()) {
			return parseDate(getRawValue()) != null;
		} else {
			return false;
		}
	}

	// return true if raw value is invalid or real empty
	public boolean isValidEmpty() {
		return !isValid() || getRawValue().trim().length() == 0;
	}

	protected Date parseDate(String dateStr) {
		try {
			return DateTimeFormat.getFormat(getDateTimePattern()).parse(dateStr);
		} catch (Exception ex) {
			return null;
		}
	}

	/***************************************************************************
	 * Parent Override Functions
	 **************************************************************************/

	@Override
	protected void onRender(Element parent, int index) {
		input = new El(DOM.createInputText());
		setElement(DOM.createDiv(), parent, index);
		addStyleName("x-form-field-wrap");

		trigger = new El(DOM.createImg());
		trigger.dom.setClassName("x-form-trigger " + triggerStyle);
		trigger.dom.setPropertyString("src", GXT.BLANK_IMAGE_URL);

		if (addClearTrigger) {
			twinTrigger = new El(DOM.createImg());
			twinTrigger.dom.setClassName("x-form-trigger " + twinTriggerStyle);
			twinTrigger.dom.setPropertyString("src", GXT.BLANK_IMAGE_URL);
		}

		span = new El(DOM.createSpan());
		span.dom.setClassName("x-form-twin-triggers");

		span.appendChild(trigger.dom);
		if (addClearTrigger) {
			span.appendChild(twinTrigger.dom);
		}

		el().appendChild(input.dom);
		el().appendChild(span.dom);

		if (isHideTrigger()) {
			span.setVisible(false);
		}

		super.onRender(parent, index);
		if (getStringLength() > 0) {
			getInputEl().setElementAttribute("maxLength", getStringLength());
		}
	}

	@Override
	public void onComponentEvent(ComponentEvent ce) {
		try {
			super.onComponentEvent(ce);
			int type = ce.getEventTypeInt();
			if (ce != null & ce.getTarget() != null && twinTrigger != null
					&& ce.getTarget() == twinTrigger.dom
					&& Event.ONCLICK == type) {
				onTwinTriggerClick(ce);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	protected void onTwinTriggerClick(ComponentEvent ce) {
		if (isEnabled() && isEditable()) {
			boolean allowBlank = getAllowBlank();
			if (!allowBlank) {
				setAllowBlank(true);
			}
			setValue(null);
			setAllowBlank(allowBlank);

			fireEvent(Events.TwinTriggerClick, ce);
		}
	}

	@Override
	protected void onBlur(ComponentEvent be) {
		if (rendered) {
			super.onBlur(be);
			onBlur();
		}
	}

	@Override
	protected void onFocus(ComponentEvent be) {
		super.onFocus(be);
		onFocus();
	}

	@Override
	public Date getValue() {
		selectedDate = super.getValue();
		return super.getValue();
	}

	@Override
	public void setValue(Date value) {
		if (value != null && selectedDate != null) {
			value.setHours(selectedDate.getHours());
			value.setMinutes(selectedDate.getMinutes());
			value.setSeconds(selectedDate.getSeconds());
		}
		super.setValue(value);
	}

	protected void autoCorrectFormat(boolean isTyping) {
		String val = getRawValue();
		if (val == null) {
			return;
		}
		String ptnSingleD = "\\d{1}\\/\\d{2}\\/\\d{4}$";
		String ptnSingleM = "\\d{2}\\/\\d{1}\\/\\d{4}$";
		String ptnSingleDM = "\\d{1}\\/\\d{1}\\/\\d{4}$";
		String ptnSingleHWithOutSec = "^\\d{1}:\\d{2}$";
		String ptnSingleH = "^\\d{1}:\\d{2}:\\d{2}$";

		if (!isTyping || (isTyping && getCursorPos() == val.length())) {
			String[] dateTimeS = val.split(" ");
			String date = null;
			String time = null;
			if (dateTimeS != null && dateTimeS.length == 2) {
				date = dateTimeS[0].trim();
				time = dateTimeS[1].trim();
			}

			if (val.matches(ptnSingleDM)) {
				val = "0" + val.substring(0, 2) + "0" + val.substring(2, 8);
				setRawValue(val);
			} else if (val.matches(ptnSingleD)) {
				val = "0" + val;
				setRawValue(val);
			} else if (val.matches(ptnSingleM)) {
				val = val.substring(0, 3) + "0" + val.substring(3, 9);
				setRawValue(val);
			} else if (time != null) {
				if (time.matches(ptnSingleHWithOutSec) ||
						time.matches(ptnSingleH)) {
					val = date + " " + "0" + time;
					setRawValue(val);
				}
			}
		}
	}

	/***************************************************************************
	 * Child Override Functions
	 **************************************************************************/

	public void onBlur() {
		// override by child class when lost focus
		autoCorrectFormat(false);
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
		autoCorrectFormat(true);
	}

	protected void onEnter() {
		// override by child class when press enter key
	}

	protected void onTyped() {
		// override by child class when key typed
	}
}