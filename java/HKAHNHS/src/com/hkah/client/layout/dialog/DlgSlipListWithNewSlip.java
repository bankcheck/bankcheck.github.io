package com.hkah.client.layout.dialog;

import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public abstract class DlgSlipListWithNewSlip extends DlgSlipList {
	private DlgCreateSlip dlgCreateSlip = null;
	private ButtonBase newSlip = null;
	private String memPatno = null;
	boolean memShowActive = false;

	public DlgSlipListWithNewSlip(MainFrame owner) {
		super(owner);
	}

	@Override
	protected void createButtons() {
		super.createButtons();
		addButton(getNewSlip());
	}

	@Override
	public void showDialog(String patno) {
		super.showDialog(patno);
		memPatno = patno;
	}

	public void showDialog(String patno, boolean onlyShowActive) {
		memShowActive = false;
		memShowActive = onlyShowActive;
		super.showDialog(patno, memShowActive?"A":null);
		memPatno = patno;
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public abstract void post(String slipNo);

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	protected boolean isAcceptButtonEnable() {
		return false;
	}

	private ButtonBase getNewSlip() {
		if (newSlip == null) {
			newSlip = new ButtonBase() {
				@Override
				public void onClick() {
					getDlgCreateSlip().showDialog(isAcceptButtonEnable(), memPatno);
				}
			};
			newSlip.setText("New Slip", 'N');
		}
		return newSlip;
	}

	private DlgCreateSlip getDlgCreateSlip() {
		if (dlgCreateSlip == null) {
			dlgCreateSlip = new DlgCreateSlip(getMainFrame()) {
				@Override
				public void dispose() {
					super.dispose();

					QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.TRANSACTION_DETAIL_TXCODE,
							new String[] {
								memPatno,
								EMPTY_VALUE,
								EMPTY_VALUE,
								memShowActive?"A":EMPTY_VALUE,
								EMPTY_VALUE,
								EMPTY_VALUE,
								EMPTY_VALUE,
								EMPTY_VALUE,
								NO_VALUE,
								Factory.getInstance().getUserInfo().getUserID()
							},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								getSlipListTable().setListTableContent(mQueue);
							} else {
								Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_NO_RECORD_FOUND);
							}
						}
					});
				}

				@Override
				public void post(String slipNo) {
				}

			};
		}
		return dlgCreateSlip;
	}
}