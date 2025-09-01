package com.hkah.client.tx.cashier;

import com.hkah.client.common.Factory;
import com.hkah.client.tx.NoScreenPanel;

public class CashierSignOff extends NoScreenPanel {

	/**
	 * This method initializes
	 *
	 */
	public boolean preAction() {
		if (getUserInfo().isCashier()) {
			Cashiers.setCashierSignOff(this, false, false);
			return true;
		} else {
			Factory.getInstance().addInformationMessage("You have already signed off.", "PBA-[Patient Business Administration System]");
			return false;
		}
	}
}