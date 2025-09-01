package com.hkah.client.layout.combobox;

import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.shared.constants.ConstantsTx;

public class ComboPackage2 extends PagingComboBoxBase {
	private boolean isOrdering = true;
	private String criteria = EMPTY_VALUE;
	private boolean loadTemplate = false;
	
	public ComboPackage2() {
		super();
		initSettings();
	}

	public ComboPackage2(TextReadOnly showTextPanel, boolean showTextSearchPanel) {
		super();
		setShowTextPanel(showTextPanel);
		setShowTextSearhPanel(showTextSearchPanel);
		initSettings();
		initSearchField();
	}
	
	public ComboPackage2(boolean isOrdering, String criteria) {
		super();
		this.isOrdering = isOrdering;
		if (criteria != null) {
			this.criteria = criteria;
		}
		initSettings();
		initSearchField();
	}

	@Override
	public void initSettings() {
		setTxCode(ConstantsTx.PKGCODE_TXCODE);
		setItemSelector("div.search-item");
		if (!loadTemplate) {
			setTemplate(getTemplateScript());
			loadTemplate = true;
		}
		setEmptyText(EMPTY_VALUE);
		setMinListWidth(400);
		setDisplayField(ZERO_VALUE);
		preloadContent();
	}
	
	private void initSearchField() {
		getLoader().load();
	}

	@Override
	protected final String[] getParam() {
		return new String[] {isOrdering ? YES_VALUE : NO_VALUE, criteria, getRawValue()};
	}
	
	private native String getTemplateScript() /*-{
		return [
			'<tpl for="."><div role="listitem" class="search-item">',
			'<b>{0}</b>&nbsp;&nbsp;&nbsp;{1}',
			'</div></tpl>',
		].join("");
	}-*/;
}