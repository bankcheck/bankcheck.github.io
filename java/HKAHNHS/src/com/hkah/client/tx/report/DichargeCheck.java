package com.hkah.client.tx.report;

import com.hkah.client.common.Factory;
import com.hkah.client.tx.NoScreenPanel;

public class DichargeCheck extends NoScreenPanel {

	/**
	 * This method initializes
	 *
	 */
	public boolean preAction() {
		openNewWindow("healthcheck", "http://" + Factory.getInstance().getSysParameter("ptIgUrlSte") + "/intranet/hat/discharge_check.jsp?userid=" + getUserInfo().getUserID());
		return false;
	}
}
