package com.hkah.client.layout.textfield;

import com.hkah.client.layout.dialog.DialogSearchBase;
import com.hkah.client.layout.dialogsearch.DlgSubReasonSearch;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class TextSubReasonSearch extends SearchTriggerField {

	private DlgSubReasonSearch dlgSubReasonSearch = null;

	public TextSubReasonSearch() {
		super();
	}

	public TextSubReasonSearch(boolean showSearchTrigger) {
		super();
		setHideTrigger(!showSearchTrigger);
	}

	@Override
	protected DialogSearchBase getSearchDialog() {
		if (dlgSubReasonSearch == null) {
			dlgSubReasonSearch = new DlgSubReasonSearch(this)  {
				@Override
				protected void acceptPostAction() {
					checkTriggerBySearchKeyPost();
				}
			};
		}
		return dlgSubReasonSearch;
	}

	@Override
	public void checkTriggerBySearchKey() {
		if (isEmpty()) {
			showSearchPanel();
		} else {
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] { "SReason", "SRsnCode, SRsnDesc",
									"UPPER(SRsnCode) ='" + getText().toUpperCase() + "' and SRSNNEW = -1 "
					},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						if (mQueue == null ||
								mQueue.getContentField().length == 0 ||
								mQueue.getContentField()[0].length() == 0) {
							resetText();
							showSearchPanel();
						} else {
							checkTriggerBySearchKeyPost();
						}
					} else {
						resetText();
						showSearchPanel();
					}
				}
			});
		}
	}
}