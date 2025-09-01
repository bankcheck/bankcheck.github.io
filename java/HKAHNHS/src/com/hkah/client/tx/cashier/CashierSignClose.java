package com.hkah.client.tx.cashier;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.MessageBox;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.tx.NoScreenPanel;
import com.hkah.shared.constants.ConstantsMessage;

public class CashierSignClose extends NoScreenPanel {

	/**
	 * This method initializes
	 *
	 */
	public boolean preAction() {
		final BasePanel panel = this;
		if (getUserInfo().isCashier()) {
			MessageBox mb =
				MessageBoxBase.confirm(ConstantsMessage.MSG_PBA_SYSTEM, ConstantsMessage.MSG_CASHIER_CLOSE,
						new Listener<MessageBoxEvent>() {
					public void handleEvent(MessageBoxEvent be) {
						if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
							Factory.getInstance().getMainFrame().writeLog("CashierSignClose", "Info", "preAction - Cashier [" + panel.getUserInfo().getCashierCode() + "] about to close");

							MessageBox mb =
								MessageBoxBase.confirm(ConstantsMessage.MSG_PBA_SYSTEM, ConstantsMessage.MSG_ASK2PRINTAUDITSMY,
										new Listener<MessageBoxEvent>() {
									@Override
									public void handleEvent(MessageBoxEvent be) {
										Cashiers.setCashierSignOff(panel, Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId()), true);
									}
								});

							mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
						}
					}
				});

			mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
		} else {
			Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_NOT_CASHIER, "PBA-[Patient Business Administration System]");
		}
		return false;
	}
}