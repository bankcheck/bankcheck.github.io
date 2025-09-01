package com.hkah.client.layout.textfield;

import com.hkah.client.layout.dialog.DialogSearchBase;
import com.hkah.client.layout.dialogsearch.DlgBedSearch;
import com.hkah.client.layout.table.TableList;

public class TextBedSearch extends SearchTriggerField {

	private DlgBedSearch dlgBedSearch = null;

	public TextBedSearch() {
		super();
	}

	public TextBedSearch(boolean showSearchTrigger) {
		super(!showSearchTrigger);
	}
	
	public TextBedSearch(boolean showSearchTrigger, boolean triggerBySearchKey) {
		super(!showSearchTrigger, true, triggerBySearchKey);
	}

	public TextBedSearch(TableList table, int column) {
		super(table, column);
	}

	@Override
	protected DialogSearchBase getSearchDialog() {
		if (dlgBedSearch == null) {
			dlgBedSearch = new DlgBedSearch(this);
		}
		return dlgBedSearch;
	}
}