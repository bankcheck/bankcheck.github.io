package com.hkah.client.tx.cashier;

import com.hkah.client.common.Factory;
import com.hkah.client.tx.NoScreenPanel;

public class CashierSignOn extends NoScreenPanel {

	/**
	 * This method initializes
	 *
	 */
	public boolean preAction() {
		if (!getUserInfo().isCashier()) {
			Cashiers.setCashierSignOn(null, true);
			return true;
		} else {
			Factory.getInstance().addInformationMessage("You have already signed on.", "PBA-[Patient Business Administration System]");
			return false;
		}
	}
}