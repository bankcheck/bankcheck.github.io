package com.hkah.client.tx.admin.codetable;

import com.hkah.shared.constants.ConstantsTx;

public class PackageBudgeting extends XBudgeting {

	protected void initAfterReady() {
		super.initAfterReady();
		LeftJLabel_XCategory.setText("Package Type");
		LeftJLabel_XType.setText("Itc Type");
		LeftJLabel_XCode.setText("Package Code");
		RightJLabel_XCategory.setText("Package Type");
		RightJLabel_XType.setText("Itc Type ");
	}

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.PACKAGEBUDGETING_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.PACKAGEBUDGETING_TITLE;
	}

	@Override
	protected boolean actionValidation(String[] selectedContent) {
		return true;
	}

	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		return new String[] {
			selectedContent[0],
			selectedContent[1],
			selectedContent[2],
			selectedContent[3],
			selectedContent[4],
			selectedContent[5],
			selectedContent[6],
			selectedContent[7],
			selectedContent[8],
			selectedContent[9]
		};
	}
}