package com.hkah.client.tx.registration;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class AddPreBooking extends EditPreBooking {

	private FieldSetBase masterPane = null;

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		Factory.getInstance().writeLogToLocal("[Pre Booking]addPreBooking Init :PBPID:"+getParameter("PBPID")
				+" getParameter(\"From\"):"+getParameter("From")
				+" getParameter(\"ACTIONTYPE\"):"+getParameter("ACTIONTYPE"));
		super.initAfterReady();

		getPJLabel_Document().setText("<font color='blue'>Document #</font>");
		getPJLabel_Document().setBounds(375, 5, 135, 20);
		getAJText_Document().setBounds(505, 5, 225, 20);

		getPJLabel_FamilyName().setBounds(375, 28, 135, 20);
		getAJText_FamilyName().setBounds(505, 28, 225, 20);
		getPJLabel_GivenName().setBounds(10, 28, 135, 20);
		getAJText_GivenName().setBounds(140, 28, 225, 20);

		getPJLabel_ChineseName().setBounds(375, 51, 225, 20);
		getAJText_ChineseName().setBounds(505, 51, 225, 20);
		getPJLabel_ContactPhone().setBounds(10, 51, 135, 20);
		getAJText_ContactPhone().setBounds(140, 51, 225, 20);

		getPJLabel_MobilePhone().setBounds(10, 74, 135, 20);
		getAJText_MobilePhone().setBounds(140, 74, 225, 20);
		getPJLabel_ACM().setBounds(375, 74, 135, 20);
		getPJCombo_ACM().setBounds(505, 74, 225, 20);

		getPJLabel_Ward().setBounds(375, 120, 135, 20);
		getPJCombo_Ward().setBounds(505, 120, 225, 20);

		getPJLabel_DocType().setVisible(false);
		getPJCombo_DocType().setVisible(false);
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	@Override
	protected void  actionValidation1(final String actionType) {
		final boolean returnValue = true;
		if (getAJText_PatNo().isEmpty()
				&& getAJText_FamilyName().isEmpty()
				&& getAJText_Document().isEmpty()) {
			Factory.getInstance().addErrorMessage("Please input Patient no/Document#/Family name.", getAJText_PatNo());
			if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
			return;
//		} else if (getPJCombo_DocType().isEmpty()) {
//			Factory.getInstance().addErrorMessage("Please input Patient Document Type.", getPJCombo_DocType());
//			getTabbedPane().setSelectedIndex(0);
//			return;
		} else if (getPJCombo_OrderByDoctor().isEmpty()) {
			Factory.getInstance().addErrorMessage("Please input Doctor Code.", getPJCombo_OrderByDoctor());
			if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
			return;
		} else if (!getPJCombo_OrderByDoctor().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid Doctor Code.", getPJCombo_OrderByDoctor());
			if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
			return;
		} else if (getPJCombo_Sex().isEmpty()) {
			Factory.getInstance().addErrorMessage("Please input Sex.", getPJCombo_Sex());
			if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
			return;
		} else if (getPJDate_SchdAdmDate().isEmpty()) {
			Factory.getInstance().addErrorMessage("Please input Hospital Date.", getPJDate_SchdAdmDate());
			if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
			return;
		} else if (!getPJDate_SchdAdmDate().isValid()) {
			Factory.getInstance().addErrorMessage("Hospital Date is invalid.", getPJDate_SchdAdmDate());
			if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
			return;
		} else if (referralCase && getRightJCombo_Source().isEmpty()) {
			Factory.getInstance().addErrorMessage("Please input source.", getRightJCombo_Source());
			if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
			return;
		} else if (!getPJCombo_ArCode().isEmpty() && !getPJCombo_ArCode().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid Arcode.", getPJCombo_ArCode());
			if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
			return;
		} else if (!getAJText_InsCoverageEndDate().isEmpty() && !getAJText_InsCoverageEndDate().isValid()) {
			Factory.getInstance().addErrorMessage("Coverage End Date is invalid.", getAJText_InsCoverageEndDate());
			if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
			return;
		}

		int insuranceAmount = 0;
		int guaranteeAmount = 0;
		if (!getAJText_LimitAmount().isEmpty()) {
			insuranceAmount = Integer.parseInt(getAJText_LimitAmount().getText());
			if (insuranceAmount < 0) {
				Factory.getInstance().addErrorMessage("Insurance Amount Limit can't be less than 0.", getAJText_LimitAmount());
				if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
				return;
			}
		}

		if (!getAJText_GuarAmt().isEmpty()) {
			guaranteeAmount = Integer.parseInt(getAJText_GuarAmt().getText());
			if (guaranteeAmount < 0) {
				Factory.getInstance().addErrorMessage("Further Guarantee Amount can't be less than 0.", getAJText_GuarAmt());
				if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
				return;
			}
		}

		if (!getAJText_LimitAmount().isEmpty() && !getAJText_GuarAmt().isEmpty() && guaranteeAmount > insuranceAmount) {
			Factory.getInstance().addErrorMessage("Further Guarantee Amount should less than or equal to Insurance Limit Amount.", getAJText_GuarAmt());
			if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
			return;
		} else if (!getAJText_GuarDate().isEmpty() && !getAJText_GuarDate().isValid()) {
			Factory.getInstance().addErrorMessage("Further Guarantee Date is invalid.", getAJText_GuarDate());
			if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
			return;
		}

		if (getPJCombo_BedCode().isEmpty() && YES_VALUE.equals(getSysParameter("BEDCDEMUST"))) {
			Factory.getInstance().addErrorMessage("Please input Bed Code.", getPJCombo_BedCode());
			if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
			return;
		}

		if (getAJText_Stay().isEmpty() && YES_VALUE.equals(getSysParameter("ESTLENMUST"))) {
			Factory.getInstance().addErrorMessage("Please input Estimated Length of Stay.", getAJText_Stay());
			if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
			return;
		} else if (!getAJText_Stay().isEmpty() && Integer.parseInt(getAJText_Stay().getText()) < 0) {
			if (YES_VALUE.equals(getSysParameter("ESTLENMUST"))) {
				Factory.getInstance().addErrorMessage("Estimated Length of Stay should be > 0", getAJText_Stay());
			} else {
				Factory.getInstance().addErrorMessage("Estimated Length of Stay should be > 0 or null", getAJText_Stay());
			}
			if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
			return;
		}

		if (!getPJCombo_PaymentType().isEmpty() && !getAJText_PaymentType().isEmpty()) {
			int paymentAmount = Integer.parseInt(getAJText_PaymentType().getText());
			if (getPJCombo_PaymentType().getText().equals("AMT") && paymentAmount < 0) {
				Factory.getInstance().addErrorMessage("The Co-Payment Amount can't be less than 0.", getAJText_PaymentType());
				if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
				return;
			} else if (getPJCombo_PaymentType().getText().equals("%") && (paymentAmount < 0 || paymentAmount > 100)) {
				Factory.getInstance().addErrorMessage("The Co-Payment Amount should be within 0 to 100.", getAJText_PaymentType());
				if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
				return;
			}
		}

		if (getPJCheckBox_Declined().isSelected() && getAJText_Reacon().isEmpty()) {
			Factory.getInstance().addErrorMessage("Please input Declined Reason.", getAJText_Reacon());
			if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
			return;
		}

		if("HKAH".equals(Factory.getInstance().getSysParameter("curtSite").toUpperCase()) && !getPJCombo_Ward().isEmpty()){
			QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] {"BEDPREBOK", "COUNT(1)", "WRDCODE = '" + getPJCombo_Ward().getText() + "'" +
								 " AND BPBHDATE = TO_DATE('" + getPJDate_SchdAdmDate().getText() + "', 'dd/mm/yyyy HH24:MI:SS')"},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success() && mQueue.getContentField()[0].length()>0) {
						int preBokAllow = 0;
						try {
							preBokAllow = Integer.parseInt(Factory.getInstance().getSysParameter("PREBOOKALT"));
						}
						catch (Exception e) { }

						if(Integer.parseInt(mQueue.getContentField()[0]) >= preBokAllow){							//
							Factory.getInstance().isConfirmYesNoDialog(Factory.getInstance().getSysParameter("PREBOOKALT") + " booking already, please check.<br> Continue?", new Listener<MessageBoxEvent>() {
								public void handleEvent(MessageBoxEvent be) {
									if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
										actionValidationReady(actionType, returnValue);
									}
								}
							});

						} else {
							actionValidationReady(actionType, returnValue);
						}
					}
					else {
						actionValidationReady(actionType, returnValue);
					}
				}
			});
		} else {
			actionValidationReady(actionType, returnValue);
		}
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getParaPanel() {
		if (paraPanel == null) {
			paraPanel = new BasePanel();
			paraPanel.setBounds(5, 29, 751, 347);
			paraPanel.add(getMasterPane());
		}
		return paraPanel;
	}

	public FieldSetBase getMasterPane() {
		if (masterPane == null) {
			masterPane = new FieldSetBase();
			masterPane.setSize(750, 347);
			masterPane.setHeading("Pre-Book Information(In-patient)");
			masterPane.add(getMasterPanel());
		}
		return masterPane;
	}
}