package com.hkah.client.layout.textfield;

import com.hkah.client.layout.dialog.DialogSearchBase;
import com.hkah.client.layout.dialogsearch.DlgARCodeSearch;

public class TextARCodeSearch extends SearchTriggerField {

	private DlgARCodeSearch dlgARCodeSearch = null;

	public TextARCodeSearch() {
		super();
	}

	public TextARCodeSearch(boolean showSearchTrigger) {
		super(!showSearchTrigger, true);	// all upper case
	}

	@Override
	protected DialogSearchBase getSearchDialog() {
		if (dlgARCodeSearch == null) {
			dlgARCodeSearch = new DlgARCodeSearch(this){
				@Override
				protected void acceptPostAction() {
					postAcceptAction();
				}
			};
		}
		return dlgARCodeSearch;
	}
	
	protected void postAcceptAction() {
		// for override if necessary
	}
}