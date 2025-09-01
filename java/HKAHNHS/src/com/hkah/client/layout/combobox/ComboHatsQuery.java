package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboHatsQuery extends ComboBoxShowKey {

	public ComboHatsQuery() {
		super();
		setMinListWidth(420);
	}

	@Override
	public void initContent(String value) {
		// initial combobox
		resetContent(ConstantsTx.HATSQUERY_TXCODE);
	}
	
	@Override
	protected native String getTemplateScript() /*-{
		return [
			'<tpl for="."><div role="listitem" class="search-item">',
			'{0}',
			'</div></tpl>',
		].join("");
	}-*/;
}
