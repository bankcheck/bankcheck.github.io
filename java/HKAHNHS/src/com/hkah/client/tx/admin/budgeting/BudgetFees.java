package com.hkah.client.tx.admin.budgeting;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.panel.DefaultPanel;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class BudgetFees extends DefaultPanel {

	public boolean preAction() {
		disableButton();
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] { "ITEMCHG I,CREDITCHG C", "MAX(I.ITCID),MAX(C.CICID)", "1=1" },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue chkQueue) {
				// TODO Auto-generated method stub
				if (chkQueue.success()) {
					MessageBoxBase.confirm(ConstantsMessage.MSG_PBA_SYSTEM, ConstantsMessage.MSG_MOVE_BUDGET_TO_FEES,
							new Listener<MessageBoxEvent>() {
						public void handleEvent(MessageBoxEvent be) {
							if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
								QueryUtil.executeMasterAction(getUserInfo(), ConstantsTx.BUDGETFEES_TXCODE,
										QueryUtil.ACTION_MODIFY, new String[] { "" },new MessageQueueCallBack() {
									@Override
									public void onPostSuccess(MessageQueue mQueue) {
										// TODO Auto-generated method stub
										if (mQueue.success()) {
											Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_MOVE_BUDGET_TO_FEES_SUCCESS);
										} else {
											Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_MOVE_BUDGET_TO_FEES_FAILS);
										}
									}
								});
							}
						}
					});
				} else {
					Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_EMPTY_CHARGES);
				}
			}
		});

		return false;
	}

	@Override
	public void searchAction() {
		// TODO Auto-generated method stub
	}

	@Override
	public void appendAction() {
		// TODO Auto-generated method stub
	}

	@Override
	public void modifyAction() {
		// TODO Auto-generated method stub
	}

	@Override
	public void deleteAction() {
		// TODO Auto-generated method stub
	}

	@Override
	public void saveAction() {
		// TODO Auto-generated method stub
	}

	@Override
	public void acceptAction() {
		// TODO Auto-generated method stub
	}

	@Override
	public void cancelAction() {
		// TODO Auto-generated method stub
	}

	@Override
	public void clearAction() {
		// TODO Auto-generated method stub
	}

	@Override
	public void refreshAction() {
		// TODO Auto-generated method stub
	}

	@Override
	public void printAction() {
		// TODO Auto-generated method stub
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