package com.hkah.client.layout.combobox;

import java.util.ArrayList;
import java.util.List;

import com.extjs.gxt.ui.client.GXT;
import com.extjs.gxt.ui.client.core.El;
import com.extjs.gxt.ui.client.data.BaseModelData;
import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.FieldEvent;
import com.extjs.gxt.ui.client.util.Size;
import com.extjs.gxt.ui.client.widget.form.SimpleComboBox;
import com.google.gwt.event.dom.client.KeyCodes;
import com.google.gwt.user.client.DOM;
import com.google.gwt.user.client.Element;
import com.google.gwt.user.client.Event;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;
import com.hkah.shared.model.UserInfo;

public class ComboBoxBase extends SimpleComboBox implements ConstantsVariable {

	protected static final String DEFAULT_DISPLAY = "value";
	protected static final String DISPLAY_FIELD_CUSTOME_NAME = "_custom1";
	protected String defaultDisplayFormat = "{k} {v}";

	private String[] memParam_prev = null;
	private String[] memParam_curr = null;
	private String memStoreValue = null;
	private boolean memIsEditableForever = false;
	private boolean memIsShowTextSearhPanel = false;
	private String memDisplayFieldCustom = null;

	private El span = null;
	private El twinTrigger = null;
	private El searchTrigger = null;

	private String memTxCode = null;
	private boolean memHasAll = false;
	private boolean memHasEmpty = false;
	private boolean memShowKey = true;
	private boolean memShowKeyOnly = false;
	private TextReadOnly memShowTextPanel = null;
	private TableList memTable = null;
	private int memColumn = -1;
	private boolean memShowClearButton = true;
	private boolean memOnTyped = false;
	private int memFieldLength = 0;
	private boolean isSkipOnSelect = false;
	protected boolean isShowPopUp = false;
	private boolean isAllUpperCase = true;
	private boolean isEditing = false;

	protected ModelData previousModelData = null;

	public ComboBoxBase() {
		this(null, null, null, null, -1, false, false, true, false);
	}

	public ComboBoxBase(boolean showKey) {
		this(null, null, null, null, -1, showKey, false, true, false);
	}

	public ComboBoxBase(boolean showKey, boolean showKeyOnly) {
		this(null, null, null, null, -1, showKey, showKeyOnly, true, false);
	}

	public ComboBoxBase(boolean showKey, boolean showKeyOnly, boolean showClearButton, boolean hasEmpty) {
		this(null, null, null, null, -1, showKey, showKeyOnly, showClearButton, hasEmpty);
	}

	public ComboBoxBase(String txCode) {
		this(txCode, null, null, null, -1, false, false, true, false);
	}

	public ComboBoxBase(TextReadOnly showTextPanel) {
		this(null, null, showTextPanel, null, -1, true, true, true, false);
	}

	public ComboBoxBase(boolean showKey, TextReadOnly showTextPanel) {
		this(null, null, showTextPanel, null, -1, showKey, false, true, false);
	}

	public ComboBoxBase(String txCode, boolean showKey) {
		this(txCode, null, null, null, -1, showKey, false, true, false);
	}

	public ComboBoxBase(String txCode, boolean showKey, boolean showClearButton) {
		this(txCode, null, null, null, -1, showKey, false, showClearButton, false);
	}

	public ComboBoxBase(String txCode, boolean showKey, boolean showClearButton, boolean hasEmtpy) {
		this(txCode, null, null, null, -1, showKey, false, showClearButton, hasEmtpy);
	}

	public ComboBoxBase(String txCode, TextReadOnly showTextPanel) {
		this(txCode, null, showTextPanel, null, -1, true, true, false, false);
	}

	public ComboBoxBase(String txCode, String[] param) {
		this(txCode, param, null, null, -1, true, false, false, false);
	}

	public ComboBoxBase(String txCode, String[] param, boolean showKey) {
		this(txCode, param, null, null, -1, showKey, false, false, false);
	}
	
	public ComboBoxBase(String txCode, String[] param, boolean showKey, boolean showClearButton, boolean hasEmpty) {
		this(txCode, param, null, null, -1, true, false, showClearButton, hasEmpty);
	}

	public ComboBoxBase(TableList table, int column) {
		this(null, null, null, table, column, false, false, true, false);
	}

	public ComboBoxBase(String txCode, TableList table, int column) {
		this(txCode, null, null, table, column, false, false, true, false);
	}

	public ComboBoxBase(String txCode, boolean showKey, TableList table, int column) {
		this(txCode, null, null, table, column, showKey, false, true, false);
	}

	public ComboBoxBase(String txCode, String[] param, TableList table, int column) {
		this(txCode, param, null, table, column, false, false, true, false);
	}

	public ComboBoxBase(String txCode, String[] param, boolean showKey, TableList table, int column) {
		this(txCode, param, null, table, column, showKey, false, true, false);
	}

	public ComboBoxBase(String txCode, String[] param,
			TextReadOnly showTextPanel,
			TableList table, int column,
			boolean showKey, boolean showKeyOnly,
			boolean showClearButton, boolean hasEmpty) {
		super();
		setShowKey(showKey);
		setShowKeyOnly(showKeyOnly);
		setShowTextPanel(showTextPanel);
		memTable = table;
		memColumn = column;
		setShowClearButton(showClearButton);

		if (hasEmpty) {
			setAllowBlank(true);
		}

		// initialize
		setMinChars(2);
		setWidth(130);
		setTypeAhead(true);
		setTriggerAction(TriggerAction.ALL);
		setDisplayField(DEFAULT_DISPLAY);
		setForceSelection(true);	// default not allow free text
		setAllUpperCase(true);

		if (txCode != null) {
			resetContent(txCode, param, false, hasEmpty);
		}
	}

	/***************************************************************************
	 * Setup Functions
	 **************************************************************************/

	public String getTxCode() {
		return memTxCode;
	}

	public void setTxCode(String txCode) {
		memTxCode = txCode;
	}

	/**
	 * @return the memHasAll
	 */
	public boolean isHasAll() {
		return memHasAll;
	}

	/**
	 * @param memHasAll the memHasAll to set
	 */
	public void setHasAll(boolean hasAll) {
		memHasAll = hasAll;
	}

	/**
	 * @return the memHasEmpty
	 */
	public boolean isHasEmpty() {
		return memHasEmpty;
	}

	/**
	 * @param memHasEmpty the memHasEmpty to set
	 */
	public void setHasEmpty(boolean hasEmpty) {
		memHasEmpty = hasEmpty;
	}

	public void setShowKey(boolean showKey) {
		memShowKey = showKey;
	}

	public void setShowKeyOnly(boolean showKeyOnly) {
		memShowKeyOnly = showKeyOnly;
	}

	public TextReadOnly getShowTextPanel() {
		return memShowTextPanel;
	}

	public void setShowTextPanel(TextReadOnly showTextPanel) {
		memShowTextPanel = showTextPanel;
	}

	/**
	 * @return the memShowClearButton
	 */
	public boolean isShowClearButton() {
		return memShowClearButton;
	}

	public void setShowClearButton(boolean showClearButton) {
		memShowClearButton = showClearButton;
//		setForceSelection(!showClearButton);
		setAllowBlank(showClearButton);
	}

	/**
	 * @return the showTextSearhPanel
	 */
	public boolean isShowTextSearhPanel() {
		return memIsShowTextSearhPanel;
	}

	/**
	 * @param showTextSearhPanel the showTextSearhPanel to set
	 */
	public void setShowTextSearhPanel(boolean isShowTextSearhPanel) {
		memIsShowTextSearhPanel = isShowTextSearhPanel;
	}

	public String getStoreValue() {
		return memStoreValue;
	}

	public void setStoreValue(String storeValue) {
		memStoreValue = storeValue;
	};

	public String getDisplayFieldCustom() {
		return memDisplayFieldCustom;
	}

	public void setDisplayFieldCustom(String displayFieldCustom) {
		memDisplayFieldCustom = displayFieldCustom;
		setDisplayField(DISPLAY_FIELD_CUSTOME_NAME);
	}

	/***************************************************************************
	 * Get/Set/Remove Functions
	 **************************************************************************/

	@Override
	public int getSelectedIndex() {
		ModelData modelData = findModelByKey(getRawValue());
		if (modelData != null) {
			return getStore().indexOf(modelData);
		} else {
			modelData = findModelByDisplayText(getRawValue());
			if (modelData != null) {
				return getStore().indexOf(modelData);
			}
			return -1;
		}
	}

	/**
	 * @return the defaultDisplayFormat
	 */
	private String getDefaultDisplayFormat() {
		return defaultDisplayFormat;
	}

	/**
	 * @param defaultDisplayFormat the defaultDisplayFormat to set
	 */
	public void setDefaultDisplayFormat(String defaultDisplayFormat) {
		this.defaultDisplayFormat = defaultDisplayFormat;
	}

	public void setSelectedIndex(int index) {
		setSelectedIndex(getStore().getAt(index));
	}

	public void setSelectedIndex(String key) {
		setText(key);
	}

	public void setSelectedIndex(ModelData modelData) {
		setSelectedIndex(modelData, true);
	}

	public void setSelectedIndex(ModelData modelData, boolean loadTextPanel) {
		if (modelData != null) {
			setRawValue(modelData.get(ZERO_VALUE).toString());
			setValue(modelData);

			if (loadTextPanel && !modelData.equals(previousModelData) && isEditable()) {
				setTextPanel(modelData);

				// store modeldata
				previousModelData = modelData;
			}
		} else {
			callClearButton(true);
		}
	}

	public int getKeySize() {
		return getStore().getCount();
	}

	public String getText() {
		String text = getRawValue();
		ModelData modelData = findModelByKey(text);
		if (modelData == null) {
			modelData = findModelByDisplayText(text);
		}
		return (modelData == null ? 
					(isAllUpperCase()?getRawValue().toUpperCase() : getRawValue()) : 
					(modelData.get(ZERO_VALUE)).toString());
	}

	public String getTextByDisplayText(String displayText) {
		ModelData modelData = findModelByDisplayText(displayText);
		return (modelData == null ? EMPTY_VALUE : (modelData.get(ZERO_VALUE)).toString());
	}

	public String getDisplayText(String key) {
		ModelData modelData = findModelByKey(key);
		return (modelData == null ? (isAllUpperCase()?getRawValue().toUpperCase() : getRawValue()) : (modelData.get(DEFAULT_DISPLAY)).toString());
	}

	public String getDisplayText() {
		ModelData modelData = getValue();
		return (modelData == null ? (isAllUpperCase()?getRawValue().toUpperCase() : getRawValue()) : (modelData.get(DEFAULT_DISPLAY)).toString());
	}

	public String getDisplayTextWithoutKey() {
		ModelData modelData = getValue();
		return (modelData == null ? (isAllUpperCase()?getRawValue().toUpperCase() : getRawValue()) : (modelData.get(ONE_VALUE)).toString());
	}

	public void setText(String key) {
		setText(key, false);
	}

	public void setText(String key, boolean allowUpdate) {
		// reset filter
		if (memOnTyped) {
			memOnTyped = false;
			getStore().clearFilters();
		}

		if (getStore().getCount() > 0) {
			ModelData modelData = findModelByKey(key);

//			reset(); // ClassCastException, try clearSelections()
			clearSelections();

			setRawValue(key);
			if (modelData != null) {
				setSelectedIndex(modelData);
			} else if (isEditable()) {
				setTextPanel(null);
			}

			if (allowUpdate) {
				updateTable();
			}
		} else {
			// store value for use later
			setStoreValue(key);
		}
	}

	public void removeItemAt(int index) {
		getStore().remove(index);
	}

	/***************************************************************************
	 * findModel Functions
	 **************************************************************************/

	protected ModelData findModelByKey() {
		return findModel(ZERO_VALUE, getText());
	}

	public ModelData findModelByKey(String key) {
		if (key != null && key.length() > 0) {
			return findModel(ZERO_VALUE, key);
		} else {
			return null;
		}
	}

	public ModelData findModelByDisplayText(String displayText) {
		ModelData val = findModel(getDisplayField(), displayText);
		if (val != null) {
			return val;
		} else {
			return findModelStartsWith(getDisplayField(), displayText);
		}
	}

	protected ModelData findModelStartsWith(String fieldName, String model) {
		if (model == null || model.length() == 0) return null;

		ModelData val = null;
		String model2Upper = model.toUpperCase();

		//System.out.println("-----------------------");
		//System.out.println("isFiltered: "+getStore().isFiltered());
		for (Object c : getStore().getModels()) {
			//System.out.println(((ModelData) c).get(fieldName).toString().toUpperCase());
			//System.out.println("model2Upper: "+model2Upper);
			if (((ModelData) c).get(fieldName).toString().toUpperCase().startsWith(model2Upper)) {
				val = (ModelData) c;
				break;
			}
		}

		if (val == null && getStore().isFiltered()) {
			getStore().clearFilters();
			return findModelStartsWith(fieldName, model);
		}

		//System.out.println("val: "+val!=null?val.get(ZERO_VALUE):"null");
		return val;
	}

	@Override
	protected ModelData findModel(String property, String value) {
		if (value == null) return null;

		ModelData val = null;
		String model2Upper = value.toUpperCase();

		for (Object c : getStore().getModels()) {
			if (((ModelData) c).get(property).toString().toUpperCase().equals(model2Upper)) {
				val = (ModelData) c;
				break;
			}
		}
		return val;
	}
	
	/***************************************************************************
	 * addItem Methods
	 **************************************************************************/

	@Override
	public boolean isValid() {
//		super.isValid() && findModelByDisplayText(getRawValue()) != null;
		return isValid(getRawValue());
	}

	public boolean isValid(String text) {
		ModelData modelData = findModelByKey(text);
		if (modelData == null) {
			modelData = findModelByDisplayText(text);
		}
//		ModelData modelData = findModelByDisplayText(getRawValue());
		if (modelData != null) {
			if (getValue() == null || !getValue().equals(modelData)) {
				setValue(modelData);
			}
			return true;
		} else {
			return false;
		}
	}

	public void resetText() {
		callClearButton(false);
	}

	public void addItem(String key) {
		addItem(key, key, true);
	}

	public void addItem(String key, String value) {
		addItem(key, value, true);
	}

	private void addItem(String key, String value, boolean allowEmpty) {
		String item = getDisplayString(key, value, allowEmpty);
		if (item != null) {
			ModelData m = new BaseModelData();
			m.set(ZERO_VALUE, key);
			m.set(ONE_VALUE, value);
			m.set(DEFAULT_DISPLAY, item);
			getStore().add(m);
		}
	}

	/**
	 * Removes all items from the item list.
	 */
	public void removeAllItems() {
		if (getStore() != null) {
			getStore().removeAll();
		}
	}

	/***************************************************************************
	 * ResetContent Methods
	 **************************************************************************/

	public void resetContent(String[][] content) {
		removeAllItems();

		for (int i = 0; i < content.length; i++) {
			addItem(content[i][0], content[i][1], false);
		}
	}

	protected void resetContentForAll() {
		addItem(ALL_VALUE, ALL_VALUE, false);
	}

	protected void resetContentForEmpty() {
		addItem(EMPTY_VALUE, EMPTY_VALUE, true);
	}

	public void resetContent(String txCode) {
		resetContent(txCode, null, false, false);
	}

	protected void resetContent(String txCode, boolean hasAll) {
		resetContent(txCode, null, hasAll, false);
	}

	protected void resetContent(String txCode, boolean hasAll, boolean hasEmtpy) {
		resetContent(txCode, null, hasAll, hasEmtpy);
	}

	protected void resetContent(String txCode, String[] param) {
		resetContent(txCode, param, false, false);
	}

	protected void resetContent(String txCode, String[] param, boolean hasAll) {
		resetContent(txCode, param, hasAll, false);
	}

	public void resetContent(MessageQueue mQueue) {
		resetContent(mQueue, false, false);
	}

	public void resetContent(MessageQueue mQueue, boolean hasAll) {
		resetContent(mQueue, hasAll, false);
	}

	public void resetContent(MessageQueue mQueue, boolean hasAll, boolean hasEmpty) {
		removeAllItems();
		memOnTyped = false;

		if (mQueue.success()) {
			// allow select all
			if (hasAll) {
				resetContentForAll();
			}

			// allow empty
			if (hasEmpty) {
				resetContentForEmpty();
			}

			getStore().add(convertMessageQueue2List(mQueue));
		}

		// select store value if calling setText before ready
		if (getStoreValue() != null) {
			String storeValue = getStoreValue();

			// reset storeValue
			setStoreValue(null);

			// set text
			setText(storeValue);
		}

		// call reset post content
		resetContentPost();
	}

	protected void resetContent(String txCode, String[] param, final boolean hasAll, final boolean hasEmpty) {
		resetContent(txCode, param, hasAll, hasEmpty, false);
	}
	
	protected void resetContent(String txCode, String[] param, final boolean hasAll, final boolean hasEmpty, boolean noCheckPrev) {
		memParam_prev = memParam_curr;
		memParam_curr = param;
		setTxCode(txCode);
		setHasAll(hasAll);
		setHasEmpty(hasEmpty);

		if (!compareArray(memParam_prev, memParam_curr) || noCheckPrev) {
			removeAllItems();

			QueryUtil.executeComboBox(
					getUserInfo(), txCode, param,
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					resetContent(mQueue, hasAll, hasEmpty);
				}
			});
		}
	}	

	protected void resetContentPost() {
		// override for child class
		if (getKeySize() == 1) {
			// default set to first item
			setSelectedIndex(0);
		}
	}

	protected List<ModelData> convertMessageQueue2List(MessageQueue mQueue) {
		if (mQueue != null && mQueue.success()) {
			String[] record = TextUtil.split(mQueue.getContentAsQueue(), TextUtil.LINE_DELIMITER);
			String[] fields = null;
			ModelData m = null;
			String displayStr = null;
			List<ModelData> list = new ArrayList<ModelData>();
			String displayFieldCustomValue = null;

			// Handle query result with "^"
			if (record.length >= 1) {
				for (int i = 0; i < record.length; i++) {
					if (record != null) {
						fields = TextUtil.split(record[i]);
						if (!TextUtil.FIELD_DELIMITER.equals(record[i])) {
							m = new BaseModelData();

							memFieldLength = fields.length;
							for (int j = 0; j < memFieldLength; j++) {
								m.set(Integer.toString(j), fields[j]);
							}

							// custom display field
							if (getDisplayFieldCustom() != null) {
								displayFieldCustomValue = getDisplayFieldCustom();
								for (int j = 0; j < memFieldLength; j++) {
									displayFieldCustomValue = displayFieldCustomValue.replaceAll("\\{"+Integer.toString(j)+"\\}", (String) m.get(Integer.toString(j)));
								}
								m.set(DISPLAY_FIELD_CUSTOME_NAME, displayFieldCustomValue);
							}

							if (memFieldLength > 1) {
								displayStr = getDisplayString(fields[0], fields[1], false);
							} else {
								displayStr = getDisplayString(fields[0], fields[0], false);
							}
							m.set(DEFAULT_DISPLAY, displayStr);

							list.add(m);
						}
					}
				}
			}
			return list;
		} else {
			return null;
		}
	}

	private boolean compareArray(String[] param1, String[] param2) {
		if (param1 != null && param2 != null && param1.length == param2.length) {
			for (int i = 0; i < param1.length; i++) {
				if (param1[i] == null || param2[i] == null || !param1[i].equals(param2[i]))
					return false;
			}
			return true;
		} else {
			return false;
		}
	}

	public void refreshContent() {
		resetContent(getTxCode(), memParam_curr, isHasAll(), isHasEmpty());
	}

	public void refreshContent(String[] param) {
		resetContent(getTxCode(), param, isHasAll(), isHasEmpty());
	}

	/***************************************************************************
	 * Clear Button
	 **************************************************************************/

	@Override
	protected Size adjustInputSize() {
		if (isShowClearButton()) {
			return new Size(span.getWidth(), 0);
		} else {
			return super.adjustInputSize();
		}
	}

	@Override
	protected void afterRender() {
		super.afterRender();

		if (isShowClearButton()) {
			addStyleOnOver(twinTrigger.dom, "x-form-trigger-over");
		}

		if (isShowTextSearhPanel()) {
			addStyleOnOver(searchTrigger.dom, "x-form-trigger-over");
		}

		// select store value if calling setText before ready
		if (getStoreValue() != null) {
			String storeValue = getStoreValue();

			// reset storeValue
			setStoreValue(null);

			// set text
			setText(storeValue);
		}
	}

	@Override
	public void onComponentEvent(ComponentEvent ce) {
		super.onComponentEvent(ce);

		if (isShowClearButton()) {
			try {
				int type = ce.getEventTypeInt();
				if ((ce.getTarget() == twinTrigger.dom) && (type == Event.ONCLICK)) {
					onTwinTriggerClick(ce);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		if (isShowTextSearhPanel()) {
			if (isEditable()) {
				try {
					int type = ce.getEventTypeInt();
					if ((ce.getTarget() == searchTrigger.dom) && (type == Event.ONCLICK)) {
						onSearchTriggerClick(ce);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
	}

	@Override
	protected void onRender(Element parent, int index) {
		if (isShowClearButton()) {
			input = new El(DOM.createInputText());
			setElement(DOM.createDiv(), parent, index);
			addStyleName("x-form-field-wrap");

			trigger = new El(DOM.createImg());
			trigger.dom.setClassName("x-form-trigger " + triggerStyle);
			trigger.dom.setPropertyString("src", GXT.BLANK_IMAGE_URL);

			twinTrigger = new El(DOM.createImg());
			twinTrigger.dom.setClassName("x-form-trigger x-form-clear-trigger");
			twinTrigger.dom.setPropertyString("src", GXT.BLANK_IMAGE_URL);

			if (isShowTextSearhPanel()) {
				searchTrigger = new El(DOM.createImg());
				searchTrigger.dom.setClassName("x-form-trigger x-form-search-trigger");
				searchTrigger.dom.setPropertyString("src", GXT.BLANK_IMAGE_URL);
			}

			span = new El(DOM.createSpan());
			span.dom.setClassName("x-form-twin-triggers");

			span.appendChild(trigger.dom);
			if (isShowTextSearhPanel()) {
				span.appendChild(searchTrigger.dom);
			}
			span.appendChild(twinTrigger.dom);

			el().appendChild(input.dom);
			el().appendChild(span.dom);

			if (isHideTrigger()) {
				span.setVisible(false);
			}
		}
		super.onRender(parent, index);
	}

	protected void onTwinTriggerClick(ComponentEvent ce) {
		if (isShowClearButton() && isEnabled() && isEditable() && !isReadOnly()) {
			fireEvent(Events.TwinTriggerClick, ce);

			if (isExpanded()) {
				collapse();
			}

			callClearButton(true);
			requestFocus();
		}
	}

	protected void callClearButton(boolean callOnSelected) {
		isEditing = false;
		clear();
		clearSelections();
		memOnTyped = false;
		previousModelData = null;
//		buffer.setLength(0);

		if (isEditable()) {
			if (callOnSelected) {
				setTextPanel(null);
				onSelected();
			}

			clearPostAction();
		}
	}

	/***************************************************************************
	 * Helper Functions
	 **************************************************************************/

	private String getDisplayString(String key, String value, boolean allowEmpty) {
		if (allowEmpty || (key != null && key.length() > 0)) {
			String newValue = null;
			if (memShowKey) {
				if (memShowKeyOnly) {
					newValue = key == null ? "" : key.trim();
				} else {
					newValue = getDisplayStringFormat(key, value);
				}
			} else {
				newValue = value;
			}

			if (memShowTextPanel == null || !memShowKeyOnly) {
				return newValue;
			} else {
				return key;
			}
		} else {
			return null;
		}
	}
	
	protected String getDisplayStringFormat(String key, String value) {
		return getDefaultDisplayFormat().replaceAll("\\{k\\}", key).replaceAll("\\{v\\}", value).trim();
	}

	@Override
	protected void onSelect(ModelData modelData, int index) {
		if (!isSkipOnSelect) {
			super.onSelect(modelData, index);
		}

		previousModelData = modelData;

		// index return filtered-index after auto-suggest filtering!
		setTextPanel(modelData);
		memOnTyped = false;
		if (getKeySize() > 0 && !isSkipOnSelect) {
			onSelected();
			onClick();
		}
	}

	protected void setTextPanel(ModelData modelData) {
		if (memShowTextPanel != null) {
			if (modelData != null) {
				memShowTextPanel.setText(memFieldLength > 1 ? modelData.get(ONE_VALUE).toString() : modelData.get(ZERO_VALUE).toString());
			} else {
				memShowTextPanel.resetText();
			}
		}
	}

	public String[] getRawTextArray() {
		return getRawTextArray(getSelectedIndex());
	}

	public String[] getRawTextArray(int index) {
		if (index >= 0) {
			ModelData data = getStore().getAt(index);
			if (data != null) {
				String[] returnArray = new String[memFieldLength];
				for (int i = 0; i < memFieldLength; i++) {
					returnArray[i] = data.get(Integer.toString(i));
				}
				return returnArray;
			}
		}
		return null;
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
		} else {
			addInputStyleName("read-only");
		}
	}

	public void setEditableForever(boolean editable) {
		memIsEditableForever = editable;
		setEditable(editable, true);
	}

	private boolean isEditableForever() {
		return memIsEditableForever;
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

	// for dummy use
	protected UserInfo getUserInfo() {
		return Factory.getInstance().getUserInfo();
	}

	private void updateTable() {
		if (getText() != null && memTable != null && memTable.getSelectedRow() >= 0 && memColumn >= 0) {
			memTable.setValueAt(getText(), memTable.getSelectedRow(), memColumn);
		}
	}

	public boolean isEmpty() {
		return getRawValue().trim().length() == 0;
	}

	/***************************************************************************
	 * Parent Override Functions
	 **************************************************************************/

	@Override
	protected void onTriggerClick(ComponentEvent ce) {
		// only popup when trigger clicked
		isShowPopUp = true;
		super.onTriggerClick(ce);
		isShowPopUp = false;
	}

	@Override
	public void setBounds(int x, int y, int width, int height) {
		setPosition(x, y);
		setSize(width, height);
	}

	@Override
	protected final void onKeyDown(FieldEvent fe) {
		super.onKeyDown(fe);
		isEditing = true;
		if (previousModelData != null) {
			previousModelData = null;
			if (fe.getKeyCode() != KeyCodes.KEY_TAB &&
				!Factory.getInstance().isFunctionKey(fe.getKeyCode())) {
				callClearButton(true);
			}
		}
//		expand();
		onPressed(fe);
	}

	@Override
	protected void onKeyUp(FieldEvent fe) {
		super.onKeyUp(fe);
		isEditing = true;
		if (KeyCodes.KEY_TAB != fe.getKeyCode() &&
				!Factory.getInstance().isFunctionKey(fe.getKeyCode())) {
			onReleased();
		}
	}

	/***************************************************************************
	 * http://ui-programming.blogspot.hk/2010/04/gxt-select-item-for-non-editable.html
	 * Handle Type-in Functions
	 **************************************************************************/

	@Override
	protected final void onKeyPress(FieldEvent fe) {
		super.onKeyPress(fe);

		if (Factory.getInstance().isFunctionKey(fe.getKeyCode())) {
			return;
		}

		if (isExpanded()) {
			collapse();
		}

		if (KeyCodes.KEY_ENTER == fe.getKeyCode()) {
			// change to upper case if input any 'a' - 'z'
//			if (isAllUpperCase && event.getKeyCode() >= 97 && event.getKeyCode() <= 122) {
//				setValue(getValue().toUpperCase());
//			}
			onEnter();
		} else {
//			if (!isExpanded()) {
//				if (fe.getKeyCode() == KeyCodes.KEY_BACKSPACE || fe.getKeyCode() == KeyCodes.KEY_DELETE) {
//					int idx = buffer.length() - 1;
//					if (idx >= 0) {
//						buffer.deleteCharAt(idx);
//					}
//				} else if (!fe.isSpecialKey()) {
//					buffer.append((char) fe.getKeyCode());
//				} else {
//					buffer.setLength(0);
//					buffer.append(getRawValue());
//				}
//
//				/* timer timeout 1 second */
//				resetBufferTimer.delay(1000);
//			}

			memOnTyped = true;
			onTyped();
		}
	}

	@Override
	protected final void onBlur(ComponentEvent be) {
		if (rendered) {
			super.onBlur(be);
			onBlur();
		}
	}

	@Override
	public void expand() {
		if (isShowPopUp) {
//			buffer.setLength(0);
			super.expand();
		}
	}

	/***************************************************************************
	 * Child Override Functions
	 **************************************************************************/

	@Override
	protected void onTypeAhead() {
		String text = getRawValue();
		if (getStore().getCount() > 0 && text != null && text.length() > 0) {
			ModelData modelDataRaw = findModelByDisplayText(text);//findModelByKey(text);
			ModelData modelDataList = getStore().getAt(0);
			if (modelDataRaw != null && !modelDataList.equals(modelDataRaw)) {
				setRawValue(propertyEditor.getStringValue(modelDataRaw));
				return;
			}
		}
		super.onTypeAhead();
	}

	/***************************************************************************
	 * Other Methods
	 **************************************************************************/

	public void onSearchTriggerClick(ComponentEvent ce) {
		// override by child class when key pressed
	}

	public void onBlur() {
		// reset filter
		if (memOnTyped) {
			memOnTyped = false;
			getStore().clearFilters();
		}

		// try to locate selecteditem
		String text = getRawValue();
		if (text.length() > 0) {
			ModelData modelData = findModelByKey(text);
			if (modelData == null) {
				modelData = findModelByDisplayText(text);
			}

			if (modelData != null) {
				setSelectedIndex(modelData);
				onSelected();
			} else {
				onBlurInvalid();
			}
		} else if (getForceSelection() && isEditing) {
			callClearButton(true);
		}

		// override by child class when lost focus
		onUpdate();
		updateTable();
	}

	protected void onBlurInvalid() {
		if (getForceSelection()) {
			callClearButton(true);
		}
	}

	protected void onClick() {
		// override by child class when click
	}

	protected void onSelected() {
		// override by child class when selected
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

	protected void onUpdate() {
		// override by child class when onBlur
	}

	protected void clearPostAction() {
		// override by child class when click clear button
	}

	protected void onPressed(FieldEvent fe) {
		// override by child class when key pressed
		onPressed();
	}
	
	public boolean isFocusOwner() {
		return super.hasFocus;
	}
}