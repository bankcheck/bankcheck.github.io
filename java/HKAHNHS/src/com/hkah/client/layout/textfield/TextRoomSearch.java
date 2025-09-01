package com.hkah.client.layout.textfield;

import com.hkah.client.layout.dialog.DialogSearchBase;
import com.hkah.client.layout.dialogsearch.DlgRoomSearch;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class TextRoomSearch extends SearchTriggerField {
	private DlgRoomSearch dlgRoomSearch = null;

	public TextRoomSearch() {
		super();
	}

	public TextRoomSearch(boolean showSearchTrigger) {
		super(!showSearchTrigger);
	}

	@Override
	protected DialogSearchBase getSearchDialog() {
		if (dlgRoomSearch == null) {
			dlgRoomSearch = new DlgRoomSearch(this);
		}
		return dlgRoomSearch;
	}

	@Override
	public void checkTriggerBySearchKey() {
		if (isEmpty()) {
			showSearchPanel();
		} else {
			QueryUtil.executeMasterFetch(getUserInfo(), "ROOM_EXIST",
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