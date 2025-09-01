package com.hkah.client.layout.textfield;

import com.hkah.client.layout.dialog.DialogSearchBase;
import com.hkah.client.layout.dialogsearch.DlgPackageSearch;

public class TextPackageCodeSearch extends SearchTriggerField {

	private DlgPackageSearch dlgPackageSearch = null;
	private String packageCategoryExcl = null;

	public TextPackageCodeSearch() {
		super();
	}

	public TextPackageCodeSearch(String packageCategoryExcl) {
		super();
		this.packageCategoryExcl = packageCategoryExcl;
	}

	public TextPackageCodeSearch(boolean showSearchTrigger) {
		super(!showSearchTrigger);
	}

	@Override
	protected DialogSearchBase getSearchDialog() {
		if (dlgPackageSearch == null) {
			dlgPackageSearch = new DlgPackageSearch(this, packageCategoryExcl);
		}
		return dlgPackageSearch;
	}
}