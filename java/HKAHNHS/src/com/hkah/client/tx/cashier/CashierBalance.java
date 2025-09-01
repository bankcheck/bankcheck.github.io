package com.hkah.client.tx.cashier;

import com.hkah.client.common.Factory;
import com.hkah.client.layout.dialog.DlgCshBalance;
import com.hkah.client.layout.panel.DefaultPanel;
import com.hkah.shared.constants.ConstantsMessage;

public class CashierBalance extends DefaultPanel {
	/**
	 *
	 */
	private static final long serialVersionUID = 1L;
	private DlgCshBalance dlgCshBalance = null;

	/**
	 * This method initializes
	 *
	 */
	public CashierBalance() {
		super();
	}

	public boolean preAction() {
		disableButton();
		if (!getUserInfo().isCashier()) {
			Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_NOT_CASHIER, "PBA-[Patient Business Administration System]");
		} else {
			getDlgCshBalance().showDialog();
		}
		return false;
	}

	private DlgCshBalance getDlgCshBalance() {
		if (dlgCshBalance == null) {
			dlgCshBalance = new DlgCshBalance(getMainFrame());
		}
		return dlgCshBalance;
	}

	@Override
	public void searchAction() {
	}

	@Override
	public void appendAction() {
	}

	@Override
	public void modifyAction() {
	}

	@Override
	public void deleteAction() {
	}

	@Override
	public void saveAction() {
	}

	@Override
	public void acceptAction() {
	}

	@Override
	public void cancelAction() {
	}

	@Override
	public void clearAction() {
	}

	@Override
	public void refreshAction() {
	}

	@Override
	public void printAction() {
	}

	@Override
	public String getTxCode() {
		return null;
	}

	@Override
	public String getTitle() {
		return null;
	}
}