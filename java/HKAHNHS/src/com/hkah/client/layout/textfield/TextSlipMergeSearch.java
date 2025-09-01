package com.hkah.client.layout.textfield;

import com.hkah.client.layout.dialog.DialogSearchBase;
import com.hkah.client.layout.dialogsearch.DlgSlipMergeSearch;

public class TextSlipMergeSearch extends SearchTriggerField {

	private DlgSlipMergeSearch dlgSlipSearch = null;
	private boolean showSlpDlg = true;

	public TextSlipMergeSearch() {
		this(true);
	}

	public TextSlipMergeSearch(boolean showSearchTrigger) {
		super(!showSearchTrigger);
	}

	@Override
	protected DialogSearchBase getSearchDialog() {
		if (dlgSlipSearch == null) {
			dlgSlipSearch = new DlgSlipMergeSearch(this);
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