package com.hkah.client.layout.textfield;

import com.hkah.client.layout.dialog.DialogSearchBase;
import com.hkah.client.layout.dialogsearch.DlgSubDiseaseSearch;
import com.hkah.client.layout.dialogsearch.DlgSubDiseaseSearchByAbbr;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class TextSubDiseaseSearch extends SearchTriggerField {

	private DlgSubDiseaseSearch dlgSubDiseaseSearch = null;
	private DlgSubDiseaseSearchByAbbr dlgSubDiseaseSearchByAbbr = null;
	private boolean isDefaultDialog = true;

	public TextSubDiseaseSearch() {
		super();
	}

	public TextSubDiseaseSearch(boolean isDefaultDialog, boolean showSearchTrigger) {
		super();
		this.isDefaultDialog = isDefaultDialog;
		setHideTrigger(!showSearchTrigger);
	}

	@Override
	protected DialogSearchBase getSearchDialog() {
		if (isDefaultDialog) {
			if (dlgSubDiseaseSearch == null) {
				dlgSubDiseaseSearch = new DlgSubDiseaseSearch(this)  {
					@Override
					protected void acceptPostAction() {
						checkTriggerBySearchKeyPost();
					}
				};;
			}
			return dlgSubDiseaseSearch;
		} else {
			if (dlgSubDiseaseSearchByAbbr == null) {
				dlgSubDiseaseSearchByAbbr = new DlgSubDiseaseSearchByAbbr(this)  {
					@Override
					protected void acceptPostAction() {
						checkTriggerBySearchKeyPost();
					}
				};;
			}
			return dlgSubDiseaseSearchByAbbr;
		}
	}

	@Override
	public void checkTriggerBySearchKey() {
		if (isDefaultDialog) {
			if (isEmpty()) {
				showSearchPanel();
			} else {
				QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
						new String[] { "SDisease", "SdsCode, SdsDesc",
										"UPPER(SdsCode) ='"  + getText().toUpperCase() + "' and SDSNEW = -1 "
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
		} else {
			showSearchPanel();
		}
	}
}