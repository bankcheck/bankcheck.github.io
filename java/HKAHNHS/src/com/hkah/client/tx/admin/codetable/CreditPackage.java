package com.hkah.client.tx.admin.codetable;

import com.hkah.shared.constants.ConstantsTx;

public class CreditPackage extends Package {
	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.CREDITPACKAGE_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.CREDITPACKAGE_TITLE;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		super.initAfterReady();
		generalPanel.setHeading("Credit Package Information");
	}
}
