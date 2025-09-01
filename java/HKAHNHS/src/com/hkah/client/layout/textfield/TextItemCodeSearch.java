package com.hkah.client.layout.textfield;

import com.hkah.client.layout.dialog.DialogSearchBase;
import com.hkah.client.layout.dialogsearch.DlgItemSearch;

public class TextItemCodeSearch extends SearchTriggerField {

	private DlgItemSearch dlgItemSearch = null;
	private String itemCategoryExcl = null;

	public TextItemCodeSearch() {
		super();
	}

	public TextItemCodeSearch(String itemCategoryExcl) {
		super();
		this.itemCategoryExcl = itemCategoryExcl;
	}

	public TextItemCodeSearch(boolean showSearchTrigger) {
		super(!showSearchTrigger);
	}

	@Override
	protected DialogSearchBase getSearchDialog() {
		if (dlgItemSearch == null) {
			dlgItemSearch = new DlgItemSearch(this, itemCategoryExcl);
		}
		return dlgItemSearch;
	}
}