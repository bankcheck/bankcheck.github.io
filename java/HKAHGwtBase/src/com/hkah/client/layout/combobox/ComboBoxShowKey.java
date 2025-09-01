package com.hkah.client.layout.combobox;

import com.hkah.client.layout.textfield.TextReadOnly;


public abstract class ComboBoxShowKey extends ComboBoxBase {

	private boolean loadTemplate = false;

	public ComboBoxShowKey() {
		super();
		initSettings(true);
		initContent(null);
	}

	public ComboBoxShowKey(boolean showKey) {
		super();
		initSettings(showKey);
		initContent(null);
	}

	public ComboBoxShowKey(String value) {
		super();
		initSettings(true);
		initContent(value);
	}

	public ComboBoxShowKey(TextReadOnly showTextPanel) {
		super(showTextPanel);
		initSettings(true);
		initContent(null);
	}

	public ComboBoxShowKey(boolean showKey, String value) {
		super();
		initSettings(showKey);
		initContent(value);
	}

	private void initSettings(boolean showKey) {
		setShowKey(showKey);
		setShowKeyOnly(true);
		setItemSelector("div.search-item");
		if (!loadTemplate) {
			setTemplate(getTemplateScript());
			loadTemplate = true;
		}
		setEmptyText(EMPTY_VALUE);
		setMinListWidth(300);
	}

	protected native String getTemplateScript() /*-{
		return [
			'<tpl for="."><div role="listitem" class="search-item">',
			'<h5><span>{0}</span>{1}</h5>',
			'</div></tpl>',
		].join("");
	}-*/;

	public abstract void initContent(String value);
}
