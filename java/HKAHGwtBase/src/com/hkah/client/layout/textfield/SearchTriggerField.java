package com.hkah.client.layout.textfield;

import com.extjs.gxt.ui.client.GXT;
import com.extjs.gxt.ui.client.core.El;
import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.FieldEvent;
import com.extjs.gxt.ui.client.event.PreviewEvent;
import com.extjs.gxt.ui.client.util.BaseEventPreview;
import com.extjs.gxt.ui.client.widget.form.TriggerField;
import com.google.gwt.dom.client.Node;
import com.google.gwt.event.dom.client.KeyCodes;
import com.google.gwt.user.client.DOM;
import com.google.gwt.user.client.Element;
import com.google.gwt.user.client.Event;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.dialog.DialogSearchBase;
import com.hkah.client.layout.table.TableList;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.UserInfo;

public abstract class SearchTriggerField extends TriggerField<String> implements ConstantsVariable {

	private boolean isAllUpperCase = true;
	private TableList table = null;
	private int column = -1;
	private boolean isEditableForever = false;
	private boolean triggerBySearchKey = false;
	private boolean isAltMode = false;
	private boolean isCtrlMode = false;
	private boolean isShiftMode = false;
	private El twinTrigger = null;
	private El span = null;
	private boolean memShowClearButton = false;

	public SearchTriggerField() {
		super();
		initialize(false, null, -1, true, false);
	}

	public SearchTriggerField(boolean hideSearchTrigger) {
		super();
		initialize(hideSearchTrigger, null, -1, true, false);
	}

	public SearchTriggerField(boolean hideSearchTrigger, boolean isAllUpperCase) {
		super();
		initialize(hideSearchTrigger, null, -1, isAllUpperCase, false);
	}

	public SearchTriggerField(boolean hideSearchTrigger, boolean isAllUpperCase, boolean triggerBySearchKey) {
		super();
		initialize(hideSearchTrigger, null, -1, isAllUpperCase, triggerBySearchKey);
	}

	public SearchTriggerField(TableList table, int column) {
		super();
		initialize(false, table, column, true, false);
	}

	public SearchTriggerField(boolean hideSearchTrigger, TableList table, int column) {
		super();
		initialize(hideSearchTrigger, table, column, true, false);
	}

	private void initialize(boolean hideSearchTrigger, TableList table, int column, boolean isAllUpperCase, boolean triggerBySearchKey) {
		setTriggerStyle("x-form-search-trigger");
		setHideTrigger(hideSearchTrigger);
		setTableList(table);
		setTableColumn(column);
		setAllUpperCase(isAllUpperCase);
		setTriggerBySearchKey(triggerBySearchKey);
	}

	public void showSearchPanel() {
		getSearchDialog().showPanel();
	}

	@Override
	protected void onRender(Element target, int index) {
		if (isShowClearButton()) {
			focusEventPreview = new BaseEventPreview() {
				protected boolean onAutoHide(final PreviewEvent ce) {
					if (ce.getEventTypeInt() == Event.ONMOUSEDOWN) {
						mimicBlur(ce, ce.getTarget());
					}
					return false;
				}
			};

			input = new El(DOM.createInputText());
			setElement(DOM.createDiv(), target, index);
			addStyleName("x-form-field-wrap");

			trigger = new El(DOM.createImg());
			trigger.dom.setClassName("x-form-trigger " + triggerStyle);
			trigger.dom.setPropertyString("src", GXT.BLANK_IMAGE_URL);

			twinTrigger = new El(DOM.createImg());
			twinTrigger.dom.setClassName("x-form-trigger x-form-clear-trigger");
			twinTrigger.dom.setPropertyString("src", GXT.BLANK_IMAGE_URL);

			span = new El(DOM.createSpan());
			span.dom.setClassName("x-form-twin-triggers");

			span.appendChild(trigger.dom);
			span.appendChild(twinTrigger.dom);

			el().appendChild(input.dom);
			el().appendChild(span.dom);
		}
		super.onRender(target, index);
	}

	/***************************************************************************
	 * Helper Functions
	 **************************************************************************/

	protected UserInfo getUserInfo() {
		return Factory.getInstance().getUserInfo();
	}

	public void requestFocus() {
		focus();
	}

	public void resetText() {
		super.setValue(EMPTY_VALUE);
	}

	public void setText(String value) {
		setText(value, false);
	}

	public void setText(String value, boolean allowUpdate) {
		super.setValue(value);
		if (allowUpdate) {
			updateTable();
		}
		onTextSet();
	}

	public String getText() {
		return getValue();
	}

	public String getValue() {
		if (super.getValue() != null) {
			if (isAllUpperCase()) {
				return super.getValue().trim().toUpperCase();
			} else {
				return super.getValue().trim();
			}
		} else {
			return EMPTY_VALUE;
		}
	}

	public boolean isFocusOwner() {
		return super.hasFocus;
	}

	public void setEnabled(boolean enabled) {
		super.setEnabled(enabled);
		setEditable(enabled);
	}

	@Override
	public void setEditable(boolean editable) {
		setEditable(editable, false);
	}

	public void setEditable(boolean editable, boolean override) {
		if (isEditableForever() && !override) return;
		super.setEditable(editable);
		setReadOnly(!editable);
		if (editable) {
			removeInputStyleName("read-only");
		} else {
			addInputStyleName("read-only");
		}
	}

	public void setEditableForever(boolean editable) {
		this.isEditableForever = true;
		setEditable(editable, true);
	}

	private boolean isEditableForever() {
		return isEditableForever;
	}

	public boolean isAllUpperCase() {
		return isAllUpperCase;
	}

	public void setAllUpperCase(boolean isAllUpperCase) {
		this.isAllUpperCase = isAllUpperCase;
		if (isAllUpperCase) {
			setInputStyleAttribute("text-transform", "uppercase");
		}
	}
	/**
	 * @return the memShowClearButton
	 */
	public boolean isShowClearButton() {
		return memShowClearButton;
	}

	public void setShowClearButton(boolean showClearButton) {
		memShowClearButton = showClearButton;
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
	public void setBounds(int x, int y, int width, int height) {
		setPosition(x, y);
		setSize(width, height);
	}

	@Override
	public void onComponentEvent(ComponentEvent ce) {
		super.onComponentEvent(ce);
		try {
			int type = ce.getEventTypeInt();
			if (twinTrigger != null && ce.getTarget() == twinTrigger.dom && type == Event.ONCLICK) {
				onTwinTriggerClick(ce);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	protected void onTriggerClick(ComponentEvent ce) {
		super.onTriggerClick(ce);
		showSearchPanel();
	}

	protected void onTwinTriggerClick(ComponentEvent ce) {
		fireEvent(Events.TwinTriggerClick, ce);
		setText("");
		requestFocus();
	}

	private boolean isFunctionKeyMode(int keyCode, boolean isRelease) {
		if (KeyCodes.KEY_ALT == keyCode) {
			isAltMode = true && !isRelease;
		}

		if (KeyCodes.KEY_CTRL == keyCode) {
			isCtrlMode = true && !isRelease;
		}

		if (KeyCodes.KEY_SHIFT == keyCode) {
			isShiftMode = true && !isRelease;
		}

		return isAltMode || isCtrlMode || isShiftMode;
	}

	@Override
	protected void onKeyDown(FieldEvent fe) {
		super.onKeyDown(fe);
		if (isFunctionKeyMode(fe.getKeyCode(), false) ||
				Factory.getInstance().isFunctionKey(fe.getKeyCode()) ||
				fe.isAltKey() || fe.isControlKey() || fe.isShiftKey()) {
			return;
		}

		if (KeyCodes.KEY_TAB == fe.getKeyCode()) {
			onTab();
		} else if (KeyCodes.KEY_ENTER == fe.getKeyCode()) {
			onEnter();
		} else {
			onPressed();
		}
	}

	@Override
	protected void onKeyUp(FieldEvent fe) {
		super.onKeyUp(fe);
		if (isFunctionKeyMode(fe.getKeyCode(), true) ||
				Factory.getInstance().isFunctionKey(fe.getKeyCode()) ||
				fe.isAltKey() || fe.isControlKey() || fe.isShiftKey()) {
			return;
		}

		if (KeyCodes.KEY_TAB != fe.getKeyCode()) {
			onReleased();
		}
	}

	@Override
	protected void onKeyPress(FieldEvent fe) {
		super.onKeyPress(fe);
		if (isFunctionKeyMode(fe.getKeyCode(), false) ||
				Factory.getInstance().isFunctionKey(fe.getKeyCode()) ||
				fe.isAltKey() || fe.isControlKey() || fe.isShiftKey()) {
			return;
		}

		onTyped();
	}

	@Override
	protected void onBlur(ComponentEvent ce) {
		if (rendered) {
			super.onBlur(ce);
			hasFocus = false;
			onBlur();
		}
	}

	@Override
	protected void onFocus(ComponentEvent ce) {
		// reset mode not release during blur by using function key
		isAltMode = false;
		isCtrlMode = false;
		isShiftMode = false;

		if (rendered) {
			super.onFocus(ce);
			onFocus();
		}
	}

	/**
	 * @return the triggerBySearchKey
	 */
	public boolean isTriggerBySearchKey() {
		return triggerBySearchKey;
	}

	/**
	 * @param triggerBySearchKey the triggerBySearchKey to set
	 */
	public void setTriggerBySearchKey(boolean triggerBySearchKey) {
		this.triggerBySearchKey = triggerBySearchKey;
	}

	/***************************************************************************
	 * Child Override Functions
	 **************************************************************************/

	public void onTyped() {
		// override by child class when key typed
	}

	public void onPressed() {
		// override by child class when key pressed
	}

	public void onReleased() {
		// override by child class when key released
	}

	public void onFocus() {
		// override by child class when on focus
	}

	public void onBlur() {
		// override by child class when lost focus
		updateTable();
	}

	public void onEnter() {
		// press Enter key
		onBlur();
	}

	public void onTab() {
		// press Enter key
	}

	public void onTextSet() {
		// override by child class when text is set by triggered class
	}

	@Override
	public void setReadOnly(boolean readOnly) {
		super.setReadOnly(readOnly);
		// set readonly background color
		Element e = getElement();
		if (e.hasChildNodes()) {
			Node node = ((Element) getElement().getChild(0));
			if (node instanceof Element) {
				if (readOnly) {
					((Element) node).addClassName("read-only");
				} else {
					((Element) node).removeClassName("read-only");
				}
			}
		}
	}

	public void checkTriggerBySearchKey() {
		// TODO Auto-generated method stub
		if (isFocusOwner()) {
			showSearchPanel();
		}
	}

	public void checkTriggerBySearchKeyPost() {

	}

	/***************************************************************************
	 * Abstract Method
	 **************************************************************************/

	protected abstract DialogSearchBase getSearchDialog();
}