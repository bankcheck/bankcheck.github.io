package com.hkah.client.layout.textfield;

import com.hkah.client.layout.dialog.DialogSearchBase;
import com.hkah.client.layout.dialogsearch.DlgDoctorSearch;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class TextDoctorSearch extends SearchTriggerField {

	private DlgDoctorSearch dlgDoctorSearch = null;
	private TextReadOnly docNameField = null;
	private boolean filterDocCode = false;

	public TextDoctorSearch() {
		this(null);
	}

	public TextDoctorSearch(TextReadOnly docNameField) {
		super();
		this.docNameField = docNameField;
		setAllUpperCase(true);
	}
	
	public TextDoctorSearch(TextReadOnly docNameField, boolean isClear) {
		super();
		this.docNameField = docNameField;
		setAllUpperCase(true);
		getSearchDialog().setClear(isClear);
	}

	public TextDoctorSearch(boolean showSearchTrigger) {
		this(showSearchTrigger, null, false);
	}
	
	public TextDoctorSearch(boolean showSearchTrigger, boolean filterDocCode) {
		this(showSearchTrigger, null, filterDocCode);
	}

	public TextDoctorSearch(boolean showSearchTrigger, TextReadOnly docNameField, boolean filterDocCode) {
		super(!showSearchTrigger);
		this.docNameField = docNameField;
		this.filterDocCode = filterDocCode;
		setAllUpperCase(true);
	}

	public TextDoctorSearch(TableList table, int column) {
		super(table, column);
		setAllUpperCase(true);
	}
	
	public TextDoctorSearch(TableList table, int column, boolean filterDocCode) {
		super(table, column);
		this.filterDocCode = filterDocCode;
		setAllUpperCase(true);
	}
	
	@Override
	protected DialogSearchBase getSearchDialog() {
		if (dlgDoctorSearch == null) {
			dlgDoctorSearch = new DlgDoctorSearch(this, docNameField, filterDocCode){
				@Override
				protected void acceptPostAction() {
					super.acceptPostAction();
					searchAfterAcceptAction();
				}
			};
		}
		return dlgDoctorSearch;
	}

	/***************************************************************************
	* Child Override Functions
	***************************************************************************/
	public void searchAfterAcceptAction() {
	}

	@Override
	public void checkTriggerBySearchKey() {
		if (isEmpty()) {
			showSearchPanel();
		} else {
			QueryUtil.executeMasterFetch(getUserInfo(), "DOCCODE_EXIST",
					new String[] { getText().trim() },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					// TODO Auto-generated method stub
					if (mQueue.success()) {
						checkTriggerBySearchKeyPost();
					} else {
						showSearchPanel();
					}
				}
			});
		}
	}
}