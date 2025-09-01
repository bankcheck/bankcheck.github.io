package com.hkah.client.tx.admin.codetable;

import com.hkah.client.common.Factory;
import com.hkah.shared.constants.ConstantsTx;


public class ItemBudgeting extends XBudgeting {

	protected void initAfterReady() {
		super.initAfterReady();
		LeftJLabel_XCategory.setText("Item Category");
		LeftJLabel_XType.setText("Item Type");
		LeftJLabel_XCode.setText("Item Code");
		RightJLabel_XCategory.setText("Item Category");
		RightJLabel_XType.setText("Item Type");
	}

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.ITEMBUDGETING_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.ITEMBUDGETING_TITLE;
	}

	@Override
	protected boolean actionValidation(String[] selectedContent) {
		if (selectedContent[1] == null || selectedContent[1].trim().length() == 0) {
			Factory.getInstance().addErrorMessage("Empty Item Code.");
		} else if (selectedContent[2] == null || selectedContent[2].trim().length() == 0) {
			Factory.getInstance().addErrorMessage("Empty Item Type.");
			return false;
		} else if (selectedContent[5] == null || selectedContent[5].trim().length() == 0) {
			Factory.getInstance().addErrorMessage("Empty GL Code.");
			return false;
		}
		return true;
	}

	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		// TODO Auto-generated method stub
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

	@Override
	public void appendAction() {
		// TODO Auto-generated method stub
		super.appendAction();
	}
}