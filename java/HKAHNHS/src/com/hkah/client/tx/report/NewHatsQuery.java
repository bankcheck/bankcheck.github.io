package com.hkah.client.tx.report;

import com.hkah.client.common.Factory;
import com.hkah.client.tx.NoScreenPanel;

public class NewHatsQuery extends NoScreenPanel {
	private static final String AAQUERY_URL = "http://" + Factory.getInstance().getMainFrame().getSysParameter("ptIgUrlSte") + "/intranet/hat/aa_query.jsp";

	/**
	 * This method initializes
	 *
	 */
	public boolean preAction() {
		openNewWindow(AAQUERY_URL, "resizable=1,scrollbars=1");
		return false;
	}
}