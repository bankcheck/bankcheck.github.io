/*
 * Created on July 23, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.tx.transaction;

import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.MessageBox;
import com.extjs.gxt.ui.client.widget.form.CheckBoxGroup;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboPay2Code;
import com.hkah.client.layout.dialog.DlgReprintRpt;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextAmount;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.ActionPaymentPanel;
import com.hkah.client.util.PanelUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTransaction;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class PaymentCapture extends ActionPaymentPanel {

	private static final String TXN_PAYCODE_CODE = "PAYCODE";

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		return ConstantsTx.PAYMENT_CAPTURE_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.PAYMENT_CAPTURE_TITLE;
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel actionPanel = null;
	private FieldSetBase generalPanel = null;
	private FieldSetBase PaymentPanel = null;

	private LabelBase RightJLabel_SlipNo = null;
	private TextReadOnly RightJText_SlipNo = null;
	private LabelBase RightJLabel_PatientNo = null;
	private TextReadOnly RightJText_PatientNo = null;
	private TextReadOnly RightJText_PatientName = null;
	private LabelBase RightJLabel_AdmissionDate = null;
	private TextReadOnly RightJText_AdmissionDate = null;
	private LabelBase RightJLabel_Doctor = null;
	private TextReadOnly RightJText_Doctor = null;
	private TextReadOnly RightJText_DoctorName = null;
	private LabelBase RightJLabel_ARCompanyCode = null;
	private TextReadOnly RightJText_ARCompanyCode = null;
	private TextReadOnly RightJText_ARCompanyDesc = null;
	private LabelBase RightJLabel_TotalPayment = null;
	private TextReadOnly RightJText_TotalPayment = null;

	private TextAmount RightJText_Amount = null;
	private LabelBase RightJLabel_PayCode = null;
	private ComboPay2Code RightJText_PayCode = null;
	private TextReadOnly RightJText_PayCode2 = null;
	private LabelBase RightJLabel_GLCode = null;
	private TextReadOnly RightJText_GLCode = null;
	private LabelBase RightJLabel_Amount = null;
	private LabelBase RightJLabel_ReceiveAmount = null;
	private LabelBase RightJLabel_Return = null;
	private TextReadOnly RightJText_Return = null;
	private LabelBase RightJLabel_Description = null;
	private LabelBase RightJLabel_TransactionDate = null;
	private TextString RightJText_Description = null;
	private TextDate RightJText_TransactionDate = null;
	private TextAmount RightJText_ReceiveAmount = null;

	private DlgReprintRpt dlgReprt = null;
	private CheckBoxBase oriOpt = null;
	private CheckBoxBase cpyOpt = null;

//	private String memActID = null;
//	private String memSlipType = null;
//	private String currPayCode = null;
//	private String currPayType = null;
	private String rptParamText = null;
	private String lang = null;
//	private String memSliptxStntype = null;
	private boolean isCheckPayCode = false;

	/**
	 * This method initializes
	 */
	public PaymentCapture() {
		super();
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		getRightJText_SlipNo().setText(getParameter("SlpNo"));
		getRightJText_PatientNo().setText(getParameter("PatNo"));
		getRightJText_PatientName().setText(getParameter("PatName"));
		getRightJText_AdmissionDate().setText(getParameter("RegDate"));
		getRightJText_Doctor().setText(getParameter("DocCode"));
		getRightJText_DoctorName().setText(getParameter("DocName"));
		getRightJText_TotalPayment().setText(getParameter("Balance"));
		getRightJText_ARCompanyCode().setText(getParameter("ARCode"));
		getRightJText_ARCompanyDesc().setText(getParameter("ARDesc"));

		QueryUtil.executeMasterFetch(
				Factory.getInstance().getUserInfo(),
				"PATIENTRPTLANG",
				new String[] {
					getRightJText_SlipNo().getText(), ""
				},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				// TODO Auto-generated method stub
				if (mQueue.success()) {
					lang = mQueue.getContentField()[0];
				}
			}
		});
		if (getRightJText_ARCompanyCode().getText() != null
				&& getRightJText_ARCompanyCode().getText().length() > 0) {
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] {"arcode", "PAY_CHECK", "ARCCODE= '" + getRightJText_ARCompanyCode().getText() + "'"},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						isCheckPayCode = "-1".equals(mQueue.getContentField()[0]);
					}
			}});
		}

		// init combobox
		String regDate = getParameter("RegDate");
		if (regDate != null && regDate.length() > 0) {
			getRightJText_PayCode().initContent(getParameter("RegDate"));
		} else {
			QueryUtil.executeMasterFetch(getUserInfo(), "Slpno2Date",
					new String[] { getRightJText_SlipNo().getText() },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						String[] rs = mQueue.getContentField();
						getRightJText_PayCode().initContent(rs[0]);
					}
				}
			});
		}

//		memActID = getParameter("ActID");
//		memSlipType = getParameter("SlpType");
		memAcmCode = getParameter("AcmCode");
		memBedCode = getParameter("BedCode");
//		memSliptxStntype = null;

		PanelUtil.setAllFieldsEditable(getPaymentPanel(), true);

		// clear memory
//		resetParameter("SlpNo");
//		resetParameter("PatNo");
//		resetParameter("PatName");
//		resetParameter("RegDate");
//		resetParameter("DocCode");
//		resetParameter("DocName");
//		resetParameter("Balance");
//		resetParameter("ActID");
//		resetParameter("SlpType");
//		resetParameter("ARCode");
//		resetParameter("ARDesc");
//		resetParameter("AcmCode");
//		resetParameter("BedCode");

		appendAction(true);
		setActionType(QueryUtil.ACTION_APPEND);
		writeLog("Payment", "initial", "actionType:[" + getActionType() + "]");
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public ComboPay2Code getDefaultFocusComponent() {
		return getRightJText_PayCode();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {
		// override function if necessary
	}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {
		emptyFields();
		defaultNewSetting();
	}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
		// enable/disable field
	}

	/* >>> ~13~ Set Disable Fields When Delete ButtonBase Is Clicked ====== <<< */
	@Override
	protected void deleteDisabledFields() {
		// enable/disable field
	}

	/* >>> ~16~ Set Fetch Input Parameters ================================ <<< */
	@Override
	protected String[] getFetchInputParameters() {
		String[] selectedContent = getListSelectedRow();

		return new String[] {
				selectedContent[0]
		};
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return new String[] {
				getUserInfo().getUserID(),
				getUserInfo().getCashierCode(),
				getRightJText_PayCode().getText().trim(),
				getRightJText_Description().getText(),
				getRightJText_TransactionDate().getText(),
				memPaymentAmount,
				getRightJText_SlipNo().getText(),
				// ecr
				memS9000YN ? YES_VALUE: NO_VALUE,
				memTmpReceiptNumber,
				// credit card/octopus begin
				memTxnType,
				memTxnEcrRef,
				memTxnAmount,
				memTxnRespCode,
				memTxnRespText,
				memTxnDateTime,
				memTxnCardType,
				memTxnCardNo,
				memTxnExpiryDate,
				memTxnCardHolder,
				memTxnTerminalNo,
				memTxnMerchantNo,
				memTxnStoreNo,
				memTxnTraceNo,
				memTxnBatchNo,
				memTxnAppCode,
				memTxnRefNo,
				memTxnRRNo,
				memTxnVDate,
				memTxnDAccount,
				memTxnAResp
		};
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {
		getSaveButton().setEnabled(false);

		boolean returnValue = true;
		if (!getUserInfo().isCashier()) {
			Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_NOT_CASHIER, "PBA-[Payment Capture]");
			returnValue = false;
		} else if (getRightJText_PayCode().isEmpty() || !getRightJText_PayCode().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid Pay Code/Arc Code!", "PBA-[Payment Capture]", getRightJText_PayCode());
			returnValue = false;
		} else if (getRightJText_Amount().isEmpty() || !TextUtil.isPositiveInteger(getRightJText_Amount().getText())) {
			Factory.getInstance().addErrorMessage(MSG_POSITIVE_AMOUNT, "PBA-[Payment Capture]", getRightJText_Amount());
			returnValue = false;
		} else if (getRightJText_TransactionDate().isEmpty() || !getRightJText_TransactionDate().isValid()) {
			Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_TRANSACTION_DATE_FORMAT, "PBA-[Payment Capture]", getRightJText_TransactionDate());
			returnValue = false;
		} else if (actionType == null) {
			Factory.getInstance().addErrorMessage("Invalid action, please try again!", "PBA-[Payment Capture]");
			returnValue = false;
			exitPanel(true);
		}

		if (returnValue) {
			PreTransaction(actionType);
		} else {
			actionValidationReady(actionType, returnValue);
		}
	}

	/***************************************************************************
	 * Helper Methods
	 **************************************************************************/

	private void defaultNewSetting() {
		resetCardInfo();
		getRightJText_TransactionDate().setText(getMainFrame().getServerDate());
	}

	private void emptyFields() {
		getRightJText_PayCode().resetText();
		getRightJText_TransactionDate().resetText();
		getRightJText_Amount().resetText();
	}

	// business logic
	private void PreTransaction(String actionType) {
		if (!CASHTX_METHODCODE_CASH.equals(getRightJText_PayCode().getText())) {
			srhCshOnlyDr(actionType);
		} else {
			PostTransactions(actionType);
		}
	}

	private void srhCshOnlyDr(final String actionType) {
		QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] {"sliptx st, Doctor d ", "DISTINCT st.doccode", "st.slpno ='" + getRightJText_SlipNo().getText() + "' AND st.doccode = d.doccode AND d.DOCCSHOLY = -1 ORDER BY st.doccode"},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					StringBuffer CshOnlyMsg = new StringBuffer();
					String[] record = TextUtil.split(mQueue.getContentAsQueue(), TextUtil.LINE_DELIMITER);
					for (int i = 0; i < record.length; i++) {
						CshOnlyMsg.append("Dr.");
						CshOnlyMsg.append(record[i]);
						CshOnlyMsg.append("<br>");
					}

					if (CshOnlyMsg.length() > 0) {
						CshOnlyMsg.append("<br>Cash only payment!<br>Do you want to continue?");
						MessageBoxBase.confirm(MSG_PBA_SYSTEM, CshOnlyMsg.toString(), new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									PostTransactions(actionType);
								}
								else {
									getSaveButton().setEnabled(true);
								}
							}
						});
					} else {
						PostTransactions(actionType);
					}
				} else {
					PostTransactions(actionType);
				}
			}
		});
	}

	private void PostTransactions(String actionType) {
		actionValidation(actionType, true, "Transaction",
				getRightJText_PayCode().getText(), "2", getRightJText_Amount().getText(), getRightJText_Amount().getText(),
				null, getRightJText_SlipNo().getText(), null, null, null, null, null, null);
	}

	private void fetchRptParm(String stnId, final boolean isPrint,
			final String isCopy) {
		// store report param for re-print
		writeLog("Payment", "Print", "5. fetchRptParm");
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] {
			"sliptx",
			"Stndesc, (SELECT DESCRIPTION "+
			"FROM DESCRIPTION_MAPPING  "+
			"WHERE TYPE || '.' || ID = 'PAYMENTMETHOD.'|| (SELECT CT.CTXMETH "+
			"FROM CASHTX CT, SLIPTX TX "+
			"WHERE CT.CTXID = TX.STNXREF "+
			"AND TX.STNID = '" + stnId + "')), " +
			"To_Char(Stntdate, 'dd/mm/yyyy'), " +
			"trim(To_Char(Stnnamt, '999,999,999,999')), "+
			" TO_CHAR(Stntdate, 'DD-MON-YYYY HH24:MI:SS','nls_date_language=ENGLISH') AS STNTDATE",
			"stnid = '" + stnId + "'"},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				writeLog("Payment", "Print", "6. fetchRptParm: "+mQueue.success()+" isPrint:"+isPrint);
				if (mQueue.success()) {
					writeLog("Payment", "Print", "7. mQueue.success(): success.....");
					setRptParamText(mQueue.getText());
					if (isPrint) {
						writeLog("Payment", "Print", "8. printRptReceipt for printing.....");
						printRptReceipt(isCopy, true);
					}
				} else {
					writeLog("Payment", "Print", "7. mQueue.success(): fail.....");
					if (isPrint) {
						Factory.getInstance().addErrorMessage(
								"Fail to get deposit. Print fail.");
					}
				}
			}
		});
	}

	private void printRptReceipt(String stnid, String isCopy) {
		fetchRptParm(stnid, true, isCopy);
	}

	private void printRptReceipt(String isCopy, boolean isShowRePrint) {
		writeLog("Payment", "Print", "9. Entering printRptReceipt.....");
		try {
			writeLog("Payment", "Print", "10. Spilt the text....");
			String[] tmpInfo = TextUtil.split(getRptParamText());

			writeLog("Payment", "Print", "11. Calling printDepositReceipt........");

			printDepositReceipt(getRightJText_SlipNo().getText(), lang,
					tmpInfo[5],
					tmpInfo[5],
					tmpInfo[6],
					tmpInfo[7],
					Integer.toString(Math.abs(Integer.parseInt(tmpInfo[8].replaceAll(",", "")))),
					isCopy,
					tmpInfo[9]);

			if (isShowRePrint) {
				//rePrintRpt();
				getDlgReprt().showDialog();
			}
		} catch (Exception e) {
			writeLog("Payment", "Print", "10. Exception: "+(e.getMessage().length()>500?e.getMessage().substring(0, 499):e.getMessage()));
		}
	}

	private void postSaveSuccess(final String actionType, final MessageQueue mQueue) {
		if (TXN_PAYCODE_CODE.equals(getRightJText_PayCode().getValue().get(THREE_VALUE).toString())) {
			writeLog("Payment", "Print", "2. Receipt Dialog ("+getRightJText_SlipNo().getText()+")");
			MessageBox mb = Factory.getInstance().isConfirmYesNoDialog("PBA", "Print DEPOSIT receipt for this payment?",
					new Listener<MessageBoxEvent>() {
				public void handleEvent(MessageBoxEvent be) {
					final String stnid = mQueue.getReturnCode();

					writeLog("Payment", "Print", "3. stnid ="+stnid+" button clicked: "+be.getButtonClicked().getItemId());
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId()) &&
							stnid != null && !"".equals(stnid)) {
						writeLog("Payment", "Print", "4. Call printRptReceipt for fetch.....");
						printRptReceipt(stnid, NO_VALUE);
					} else {
						writeLog("Payment", "Print", "4. Call postPrintAction.....");
						postPrintAction(actionType, mQueue);
					}
				}
			});

			mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
		} else {
			writeLog("Payment", "Print", "2. No Receipt Dialog ("+getRightJText_SlipNo().getText()+")");
			postPrintAction(actionType, mQueue);
		}
	}

	private void postPrintAction(String actionType, final MessageQueue mQueue) {
		if (isAppend() && mQueue != null) {
			getNewOutputValue(mQueue.getReturnCode());
		}

		if (isDelete()) {
			clearAction();
		}

		// call post ready
		actionValidationPostReady(actionType);
	}

	private void rePrintRpt() {
		MessageBoxBase.confirm("Re-Print report?",
				"Re-Print the following Report?<br /> Deposit Receipt Report",
				new Listener<MessageBoxEvent>() {
			public void handleEvent(MessageBoxEvent be) {
				if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
					printRptReceipt(YES_VALUE, true);
				} else {	// NO
					getDlgReprt().showDialog();
				}
			}}
		);
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected void cancelPostAction() {
		exitPanel(true);
	}

	@Override
	protected void actionValidationPostReady(String actionType) {
		super.actionValidationPostReady(actionType);
		exitPanel();
	}

	@Override
	protected void actionValidationReady(final String actionType, boolean isValidationReady) {
		// set action type
//		setActionType(actionType);
		if (isValidationReady) {
			getMainFrame().setLoading(true);
			writeLog("Payment", "Save", "1. Saving Payment ("+getRightJText_SlipNo().getText()+")[" + getActionType() + "]");
			QueryUtil.executeMasterAction(getUserInfo(), getTxCode(),
					getActionType(),
					getActionInputParamaters(),
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(final MessageQueue mQueue) {
					if (mQueue.success()) {
						// reset action type
						resetActionType();

						Factory.getInstance().addInformationMessage(
								mQueue.getReturnMsg(), new Listener<MessageBoxEvent>() {
									@Override
									public void handleEvent(MessageBoxEvent be) {
										postSaveSuccess(actionType, mQueue);
									}
								});	// Payment successfully added.
					} else {
						writeLog("Payment", "Save", "Fail: "+mQueue.getReturnMsg() +" ("+getRightJText_SlipNo().getText()+")");
						Factory.getInstance().addErrorMessage(mQueue);
						if (mQueue.getContentField().length >= 2) {
							String msg = mQueue.getContentField()[1];
							if (msg != null && msg.trim().length() > 0) {
								Factory.getInstance().addSystemMessage(msg);
							}
						}
						getSaveButton().setEnabled(true);
					}
				}

				@Override
				public void onComplete() {
					super.onComplete();
					getMainFrame().setLoading(false);
				}
			});
		} else {
			getSaveButton().setEnabled(true);
		}
	}

	@Override
	protected void enableButton(String mode) {
		// disable all button
		disableButton();

		getSaveButton().setEnabled(true);
		getCancelButton().setEnabled(true);
	}

	/***************************************************************************
	 * Create Instance Method
	 **************************************************************************/

	// DO NOT USE it for object instantiation
	private DlgReprintRpt getDlgReprt() {
		return getDlgReprt(null);
	}

	private DlgReprintRpt getDlgReprt(final String actionType) {
		if (dlgReprt == null) {
			CheckBoxGroup btngrp = new CheckBoxGroup();
			btngrp.add(getOriOpt());
			btngrp.add(getCpyOpt());
			dlgReprt = new DlgReprintRpt(getMainFrame(), "DEPOSIT") {
				@Override
				protected void doYesAction() {
					if (getOriOpt().isSelected()) {
						printRptReceipt(NO_VALUE, false);
					}
					if (getCpyOpt().isSelected()) {
						printRptReceipt(YES_VALUE, false);
					}
					dlgReprt.dispose();
					postPrintAction(actionType, null);
				}

				@Override
				protected void doNoAction() {
					super.doNoAction();
					exitPanel(true);
				}
			};
			dlgReprt.getBtmPanel().add(btngrp);
		}
		return dlgReprt;
	}

	public CheckBoxBase getOriOpt() {
		if (oriOpt == null) {
			oriOpt = new CheckBoxBase();
			oriOpt.setBoxLabel("Original");
			oriOpt.setSelected(true);
		}
		return oriOpt;
	}

	public CheckBoxBase getCpyOpt() {
		if (cpyOpt == null) {
			cpyOpt = new CheckBoxBase();
			cpyOpt.setBoxLabel("Copy");
		}
		return cpyOpt;
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/**
	 * This method initializes actionPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	@Override
	protected BasePanel getActionPanel() {
		if (actionPanel == null) {
			// create tabbed panel
			actionPanel = new BasePanel();
			actionPanel.setSize(906, 541);
			actionPanel.add(getGeneralPanel(), null);
			actionPanel.add(getPaymentPanel(), null);
		}
		return actionPanel;
	}

	/**
	 * This method initializes generalPanel
	 *
	 * @return com.hkah.client.layout.BasePanel
	 */
	private FieldSetBase getGeneralPanel() {
		if (generalPanel == null) {
			generalPanel = new FieldSetBase();
			generalPanel.setBounds(10, 10, 760, 125);
			generalPanel.setHeading("Slip Details");
			generalPanel.add(getRightJLabel_SlipNo(), null);
			generalPanel.add(getRightJLabel_PatientNo(), null);
			generalPanel.add(getRightJText_PatientName(), null);
			generalPanel.add(getRightJText_SlipNo(), null);
			generalPanel.add(getRightJText_PatientNo(), null);
			generalPanel.add(getRightJLabel_AdmissionDate(), null);
			generalPanel.add(getRightJLabel_Doctor(), null);
			generalPanel.add(getRightJText_AdmissionDate(), null);
			generalPanel.add(getRightJText_DoctorName(), null);
			generalPanel.add(getRightJText_Doctor(), null);
			generalPanel.add(getRightJLabel_ARCompanyCode(), null);
			generalPanel.add(getRightJText_ARCompanyCode(), null);
			generalPanel.add(getRightJText_ARCompanyDesc(), null);
			generalPanel.add(getRightJLabel_TotalPayment(), null);
			generalPanel.add(getRightJText_TotalPayment(), null);
		}
		return generalPanel;
	}

	/**
	 * This method initializes PaymentPanel
	 *
	 * @return com.hkah.client.layout.FieldSetBase
	 */
	private FieldSetBase getPaymentPanel() {
		if (PaymentPanel == null) {
			PaymentPanel = new FieldSetBase();
//			PaymentPanel.setLayout(null);
			PaymentPanel.setBounds(10, 145, 760, 220);
			PaymentPanel.setHeading("Payment Details");
			PaymentPanel.add(getRightJLabel_PayCode(), null);
			PaymentPanel.add(getRightJText_PayCode(), null);
			PaymentPanel.add(getRightJText_PayCode2(), null);
			PaymentPanel.add(getRightJLabel_GLCode(), null);
			PaymentPanel.add(getRightJText_GLCode(), null);
			PaymentPanel.add(getRightJLabel_Amount(), null);
			PaymentPanel.add(getRightJText_Amount(), null);
			PaymentPanel.add(getRightJLabel_ReceiveAmount(), null);
			PaymentPanel.add(getRightJText_ReceiveAmount(), null);
			PaymentPanel.add(getRightJLabel_Return(), null);
			PaymentPanel.add(getRightJText_Return(), null);
			PaymentPanel.add(getRightJLabel_Description(), null);
			PaymentPanel.add(getRightJText_Description(), null);
			PaymentPanel.add(getRightJLabel_TransactionDate(), null);
			PaymentPanel.add(getRightJText_TransactionDate(), null);
		}
		return PaymentPanel;
	}

	/**
	 * This method initializes RightJLabel_SlipNo
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_SlipNo() {
		if (RightJLabel_SlipNo == null) {
			RightJLabel_SlipNo = new LabelBase();
			RightJLabel_SlipNo.setText("Slip Number");
			RightJLabel_SlipNo.setBounds(20, 5, 100, 20);
		}
		return RightJLabel_SlipNo;
	}

	/**
	 * This method initializes RightJText_SlipNo
	 *
	 * @return com.hkah.client.layout.label.TextReadOnly
	 */
	private TextReadOnly getRightJText_SlipNo() {
		if (RightJText_SlipNo == null) {
			RightJText_SlipNo = new TextReadOnly();
			RightJText_SlipNo.setBounds(120, 5, 130, 20);
		}
		return RightJText_SlipNo;
	}

	/**
	 * This method initializes RightJLabel_PatientNo
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_PatientNo() {
		if (RightJLabel_PatientNo == null) {
			RightJLabel_PatientNo = new LabelBase();
			RightJLabel_PatientNo.setText("Patient");
			RightJLabel_PatientNo.setBounds(270, 5, 100, 20);
		}
		return RightJLabel_PatientNo;
	}

	/**
	 * This method initializes RightJText_PatientNo
	 *
	 * @return com.hkah.client.layout.label.TextReadOnly
	 */
	private TextReadOnly getRightJText_PatientNo() {
		if (RightJText_PatientNo == null) {
			RightJText_PatientNo = new TextReadOnly();
			RightJText_PatientNo.setBounds(350, 5, 80, 20);
		}
		return RightJText_PatientNo;
	}

	/**
	 * This method initializes RightJText_PatientName
	 *
	 * @return com.hkah.client.layout.label.TextReadOnly
	 */
	private TextReadOnly getRightJText_PatientName() {
		if (RightJText_PatientName == null) {
			RightJText_PatientName = new TextReadOnly();
			RightJText_PatientName.setBounds(435, 5, 315, 20);
		}
		return RightJText_PatientName;
	}
	/**
	 * This method initializes RightJLabel_AdmissionDate
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_AdmissionDate() {
		if (RightJLabel_AdmissionDate == null) {
			RightJLabel_AdmissionDate = new LabelBase();
			RightJLabel_AdmissionDate.setText("Admission Date");
			RightJLabel_AdmissionDate.setBounds(20, 35, 100, 20);
		}
		return RightJLabel_AdmissionDate;
	}

	/**
	 * This method initializes RightJText_AdmissionDate
	 *
	 * @return com.hkah.client.layout.label.TextReadOnly
	 */
	private TextReadOnly getRightJText_AdmissionDate() {
		if (RightJText_AdmissionDate == null) {
			RightJText_AdmissionDate = new TextReadOnly();
			RightJText_AdmissionDate.setBounds(120, 35, 130, 20);
		}
		return RightJText_AdmissionDate;
	}

	/**
	 * This method initializes RightJLabel_Doctor
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_Doctor() {
		if (RightJLabel_Doctor == null) {
			RightJLabel_Doctor = new LabelBase();
			RightJLabel_Doctor.setText("Doctor");
			RightJLabel_Doctor.setBounds(270, 35, 100, 20);
		}
		return RightJLabel_Doctor;
	}

	/**
	 * This method initializes RightJText_Doctor
	 *
	 * @return com.hkah.client.layout.label.TextReadOnly
	 */
	private TextReadOnly getRightJText_Doctor() {
		if (RightJText_Doctor == null) {
			RightJText_Doctor = new TextReadOnly();
			RightJText_Doctor.setBounds(350, 35, 80, 20);
		}
		return RightJText_Doctor;
	}

	/**
	 * This method initializes RightJText_DoctorName
	 *
	 * @return com.hkah.client.layout.label.TextReadOnly
	 */
	private TextReadOnly getRightJText_DoctorName() {
		if (RightJText_DoctorName == null) {
			RightJText_DoctorName = new TextReadOnly();
			RightJText_DoctorName.setBounds(435, 35, 315, 20);
		}
		return RightJText_DoctorName;
	}

	/**
	 * This method initializes RightJLabel_TotalPayment
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_TotalPayment() {
		if (RightJLabel_TotalPayment == null) {
			RightJLabel_TotalPayment = new LabelBase();
			RightJLabel_TotalPayment.setText("Total Payment");
			RightJLabel_TotalPayment.setBounds(20, 65, 100, 20);
		}
		return RightJLabel_TotalPayment;
	}

	/**
	 * This method initializes RightJText_TotalPayment
	 *
	 * @return com.hkah.client.layout.label.TextReadOnly
	 */
	private TextReadOnly getRightJText_TotalPayment() {
		if (RightJText_TotalPayment == null) {
			RightJText_TotalPayment = new TextReadOnly();
			RightJText_TotalPayment.setBounds(120, 65, 130, 20);
		}
		return RightJText_TotalPayment;
	}

	/**
	 * This method initializes RightJLabel_ARCompanyCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_ARCompanyCode() {
		if (RightJLabel_ARCompanyCode == null) {
			RightJLabel_ARCompanyCode = new LabelBase();
			RightJLabel_ARCompanyCode.setText("AR Company");
			RightJLabel_ARCompanyCode.setBounds(270, 65, 100, 20);
		}
		return RightJLabel_ARCompanyCode;
	}

	/**
	 * This method initializes RightJText_ARCompanyCode
	 *
	 * @return com.hkah.client.layout.textfield.TextReadOnly
	 */
	private TextReadOnly getRightJText_ARCompanyCode() {
		if (RightJText_ARCompanyCode == null) {
			RightJText_ARCompanyCode = new TextReadOnly();
			RightJText_ARCompanyCode.setBounds(350, 65, 80, 20);
		}
		return RightJText_ARCompanyCode;
	}
	/**
	 * This method initializes RightJText_ARCompanyCode
	 *
	 * @return com.hkah.client.layout.textfield.TextReadOnly
	 */
	private TextReadOnly getRightJText_ARCompanyDesc() {
		if (RightJText_ARCompanyDesc == null) {
			RightJText_ARCompanyDesc = new TextReadOnly();
			RightJText_ARCompanyDesc.setBounds(435, 65, 315, 20);
		}
		return RightJText_ARCompanyDesc;
	}

	/**
	 * This method initializes RightJLabel_PayCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_PayCode() {
		if (RightJLabel_PayCode == null) {
			RightJLabel_PayCode = new LabelBase();
			RightJLabel_PayCode.setText("Pay Code");
			RightJLabel_PayCode.setBounds(20, 5, 100, 20);
		}
		return RightJLabel_PayCode;
	}

	private ComboPay2Code getRightJText_PayCode() {
		if (RightJText_PayCode == null) {
			RightJText_PayCode = new ComboPay2Code(getParameter("RegDate")) {
				@Override
				protected void setTextPanel(ModelData modelData) {
					if (modelData != null) {
						if ((!"".equals(getRightJText_ARCompanyCode().getText())
							&& !getText().equals(getRightJText_ARCompanyCode().getText()) && isCheckPayCode)){
							Factory.getInstance().addInformationMessage("Payment Code is different from AR Code!");
						}
						getRightJText_PayCode2().setText(modelData.get(ONE_VALUE).toString());
						getRightJText_GLCode().setText(modelData.get(TWO_VALUE).toString());
//						memSliptxStntype = modelData.get(THREE_VALUE).toString();
						getRightJText_Amount().requestFocus();
					} else {
						// reset GLCode
						getRightJText_PayCode2().resetText();
						getRightJText_GLCode().resetText();
					}
				}
			};
			RightJText_PayCode.setBounds(120, 5, 210, 20);
		}
		return RightJText_PayCode;
	}

	/**
	 * This method initializes RightJText_PayCode2
	 *
	 * @return com.hkah.client.layout.textfield.TextReadOnly
	 */
	private TextReadOnly getRightJText_PayCode2() {
		if (RightJText_PayCode2 == null) {
			RightJText_PayCode2 = new TextReadOnly();
			RightJText_PayCode2.setBounds(340, 5, 380, 20);
		}
		return RightJText_PayCode2;
	}

	/**
	 * This method initializes RightJLabel_GLCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_GLCode() {
		if (RightJLabel_GLCode == null) {
			RightJLabel_GLCode = new LabelBase();
			RightJLabel_GLCode.setText("G/L Code");
			RightJLabel_GLCode.setBounds(20, 35, 100, 20);
		}
		return RightJLabel_GLCode;
	}

	/**
	 * This method initializes RightJLabel_GLCode
	 *
	 * @return com.hkah.client.layout.textfield.TextReadOnly
	 */
	private TextReadOnly getRightJText_GLCode() {
		if (RightJText_GLCode == null) {
			RightJText_GLCode = new TextReadOnly();
			RightJText_GLCode.setBounds(120, 35, 120, 20);
		}
		return RightJText_GLCode;
	}

	/**
	 * This method initializes RightJLabel_Amount
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_Amount() {
		if (RightJLabel_Amount == null) {
			RightJLabel_Amount = new LabelBase();
			RightJLabel_Amount.setText("Amount");
			RightJLabel_Amount.setBounds(20, 65, 100, 20);
		}
		return RightJLabel_Amount;
	}

	/**
	 * This method initializes RightJText_Amount
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextAmount getRightJText_Amount() {
		if (RightJText_Amount == null) {
			RightJText_Amount = new TextAmount(ConstantsTransaction.MAX_AMOUNT_LIMIT) {
				public void onReleased() {
					if (!RightJText_Amount.isEmpty()
							&& !getRightJText_ReceiveAmount().isEmpty()) {
						getRightJText_Return().setText(String.valueOf(Integer.valueOf(getRightJText_ReceiveAmount().getText().trim()) - Integer.valueOf(RightJText_Amount.getText().trim())));
					} else {
						getRightJText_Return().resetText();
					}
				}
			};
			RightJText_Amount.setBounds(120, 65, 120, 20);
		}
		return RightJText_Amount;
	}

	/**
	 * This method initializes RightJLabel_ReceiveAmount
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_ReceiveAmount() {
		if (RightJLabel_ReceiveAmount == null) {
			RightJLabel_ReceiveAmount = new LabelBase();
			RightJLabel_ReceiveAmount.setText("Receive Amount");
			RightJLabel_ReceiveAmount.setBounds(20, 95, 100, 20);
		}
		return RightJLabel_ReceiveAmount;
	}

	/**
	 * This method initializes RightJText_ReceiveAmount
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextAmount getRightJText_ReceiveAmount() {
		if (RightJText_ReceiveAmount == null) {
			RightJText_ReceiveAmount = new TextAmount(ConstantsTransaction.MAX_AMOUNT_LIMIT) {
				public void onReleased() {
					if (!RightJText_ReceiveAmount.isEmpty()
							&& !getRightJText_Amount().isEmpty()) {
						getRightJText_Return().setText(String.valueOf(Integer.valueOf(RightJText_ReceiveAmount.getText().trim()) - Integer.valueOf(getRightJText_Amount().getText().trim())));
					} else {
						getRightJText_Return().resetText();
					}
				}
			};
			RightJText_ReceiveAmount.setBounds(120, 95, 120, 20);
		}
		return RightJText_ReceiveAmount;
	}

	/**
	 * This method initializes RightJLabel_Return
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_Return() {
		if (RightJLabel_Return == null) {
			RightJLabel_Return = new LabelBase();
			RightJLabel_Return.setText("Return");
			RightJLabel_Return.setBounds(260, 95, 105, 20);
		}
		return RightJLabel_Return;
	}

	/**
	 * This method initializes RightJText_Return
	 *
	 * @return com.hkah.client.layout.textfield.TextReadOnly
	 */
	public TextReadOnly getRightJText_Return() {
		if (RightJText_Return == null) {
			RightJText_Return = new TextReadOnly();
			RightJText_Return.setBounds(330, 95, 120, 20);
		}
		return RightJText_Return;
	}

	/**
	 * This method initializes RightJLabel_Description
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_Description() {
		if (RightJLabel_Description == null) {
			RightJLabel_Description = new LabelBase();
			RightJLabel_Description.setText("Description");
			RightJLabel_Description.setBounds(20, 125, 109, 20);
		}
		return RightJLabel_Description;
	}

	/**
	 * This method initializes RightJText_Description
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_Description() {
		if (RightJText_Description == null) {
			RightJText_Description = new TextString(50, false);
			RightJText_Description.setBounds(120, 125, 600, 20);
		}
		return RightJText_Description;
	}

	/**
	 * This method initializes RightJLabel_TransactionDate
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_TransactionDate() {
		if (RightJLabel_TransactionDate == null) {
			RightJLabel_TransactionDate = new LabelBase();
			RightJLabel_TransactionDate.setText("Transaction Date");
			RightJLabel_TransactionDate.setBounds(20, 155, 109, 20);
		}
		return RightJLabel_TransactionDate;
	}

	/**
	 * This method initializes RightJText_TransactionDate
	 *
	 * @return com.hkah.client.layout.textfield.TextDate
	 */
	private TextDate getRightJText_TransactionDate() {
		if (RightJText_TransactionDate == null) {
			RightJText_TransactionDate = new TextDate();
			RightJText_TransactionDate.setBounds(120, 155, 120, 20);
		}
		return RightJText_TransactionDate;
	}

	public void setRptParamText(String rptParamText) {
		this.rptParamText = rptParamText;
	}

	public String getRptParamText() {
		return rptParamText;
	}
}