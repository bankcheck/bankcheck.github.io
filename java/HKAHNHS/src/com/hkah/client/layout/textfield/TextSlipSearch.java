package com.hkah.client.layout.textfield;

import com.hkah.client.layout.dialog.DialogSearchBase;
import com.hkah.client.layout.dialogsearch.DlgSlipSearch;

public class TextSlipSearch extends SearchTriggerField {

	private DlgSlipSearch dlgSlipSearch = null;
	private boolean showSlpDlg = true;

	public TextSlipSearch() {
		this(true);
	}

	public TextSlipSearch(boolean showSearchTrigger) {
		super(!showSearchTrigger);
	}

	@Override
	protected DialogSearchBase getSearchDialog() {
		if (dlgSlipSearch == null) {
			dlgSlipSearch = new DlgSlipSearch(this);
		}
		return dlgSlipSearch;
	}

	public boolean isShowSlpDlg() {
		return showSlpDlg;
	}

	public void setShowSlpDlg(boolean showSlpDlg) {
		this.showSlpDlg = showSlpDlg;
	}
}