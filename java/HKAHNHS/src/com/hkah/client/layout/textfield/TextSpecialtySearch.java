package com.hkah.client.layout.textfield;

import com.hkah.client.layout.dialog.DialogSearchBase;
import com.hkah.client.layout.dialogsearch.DlgSpecialtySearch;

public class TextSpecialtySearch extends SearchTriggerField {
	private DlgSpecialtySearch dlgSpecialtySearch = null;

	public TextSpecialtySearch() {
		super();
	}

	public TextSpecialtySearch(boolean showSearchTrigger) {
		super(!showSearchTrigger);
	}

	@Override
	protected DialogSearchBase getSearchDialog() {
		if (dlgSpecialtySearch == null) {
			dlgSpecialtySearch = new DlgSpecialtySearch(this);
		}
		return dlgSpecialtySearch;
	}
}