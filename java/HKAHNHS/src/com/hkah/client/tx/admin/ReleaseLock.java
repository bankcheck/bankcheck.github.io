package com.hkah.client.tx.admin;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class ReleaseLock extends MasterPanel {

	/**
	 * This method initializes
	 *
	 */

	public ReleaseLock() {
		super();
	}

	public boolean preAction() {
		disableButton();
		MessageBoxBase.confirm(MSG_PBA_SYSTEM, "Release Lock?",new Listener<MessageBoxEvent>() {
			public void handleEvent(MessageBoxEvent be) {
				if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
					QueryUtil.executeMasterAction(getUserInfo(), "UNLOCKDAYEND", QueryUtil.ACTION_MODIFY,
							new String[] { getUserInfo().getSiteCode() },
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
 								Factory.getInstance().addInformationMessage("Release Lock successfully!", ConstantsMessage.MSG_PBA_SYSTEM);
							} else {
								Factory.getInstance().addErrorMessage(MSG_UNABLE_TOUNLOCK);
							}
						}
					});
				}
			}
		});
		return false;
	}

	@Override
	protected String[] getColumnNames() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	protected int[] getColumnWidths() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	protected BasePanel getLeftPanel() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	protected BasePanel getRightPanel() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	protected boolean init() {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	protected void initAfterReady() {
		// TODO Auto-generated method stub
	}

	@Override
	protected void confirmCancelButtonClicked() {
		// TODO Auto-generated method stub
	}

	@Override
	protected void appendDisabledFields() {
		// TODO Auto-generated method stub
	}

	@Override
	protected void modifyDisabledFields() {
		// TODO Auto-generated method stub
	}

	@Override
	protected void deleteDisabledFields() {
		// TODO Auto-generated method stub
	}

	@Override
	protected String[] getBrowseInputParameters() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	protected String[] getFetchInputParameters() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	protected void getFetchOutputValues(String[] outParam) {
		// TODO Auto-generated method stub

	}

	@Override
	protected String[] getActionInputParamaters() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getTxCode() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getTitle() {
		// TODO Auto-generated method stub
		return null;
	}
}