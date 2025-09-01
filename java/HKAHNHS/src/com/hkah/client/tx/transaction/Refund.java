package com.hkah.client.tx.transaction;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.util.Rectangle;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.combobox.ComboRefundMethod;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextAmount;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.tx.ActionPaymentPanel;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsTransaction;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class Refund extends ActionPaymentPanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.REFUND_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.REFUND_TITLE;
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private BasePanel actionPanel = null;

	private FieldSetBase slpDetailPanel = null;
	private LabelBase slpNoDesc = null;
	private TextReadOnly slpNo = null;
	private LabelBase patDesc = null;
	private TextReadOnly patNo = null;
	private TextReadOnly patName = null;
	private LabelBase admDateDesc = null;
	private TextReadOnly admDate = null;
	private LabelBase docDesc = null;
	private TextReadOnly docCode = null;
	private TextReadOnly docName = null;

	private FieldSetBase rfdDetailPanel = null;
	private LabelBase itmCodeDesc = null;
	private TextReadOnly itmCode = null;
	private LabelBase methodDesc = null;
	private ComboRefundMethod method = null;
	private LabelBase amtDesc = null;
	private TextAmount amt = null;
	private LabelBase glccodeDesc = null;
	private TextReadOnly glccode = null;
	private LabelBase tdateDesc = null;
	private TextDate tdate = null;
	private BasePanel paymentPanel = null;
	private TableList paymentTable = null;
	private JScrollPane paymentScrollPane = null;

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */

	/**
	 * This method initializes
	 *
	 */
	public Refund() {
		super();
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		getPaymentTable().setColumnAmount(0);

		getSlpNo().setText(getParameter("SlpNo"));
		getPatNo().setText(getParameter("PatNo"));
		getPatName().setText(getParameter("PatName"));
		getAdmDate().setText(getParameter("RegDate"));
		getDocCode().setText(getParameter("DocCode"));
		getDocName().setText(getParameter("DocName"));
		getItmCode().setText(TXN_REFUND_ITMCODE);
		getAmt().setText(String.valueOf(-Integer.valueOf(getParameter("RefundAmt"))));
		getTdate().setText(getMainFrame().getServerDate());
		memAcmCode = getParameter("AcmCode");
		memBedCode = getParameter("BedCode");

		// clear get parameter
//		resetParameter("SlpNo");
//		resetParameter("PatNo");
//		resetParameter("PatName");
//		resetParameter("RegDate");
//		resetParameter("DocCode");
//		resetParameter("DocName");
//		resetParameter("RefundAmt");
//		resetParameter("AcmCode");
//		resetParameter("BedCode");

		// set action
		setActionType(QueryUtil.ACTION_APPEND);

		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String [] { "Item i, ItemChg c", "c.GlcCode", "i.ItmCode = c.ItmCode AND i.ItmCode='" + TXN_REFUND_ITMCODE + "'"},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					String GlcCode = mQueue.getContentField()[0];
					if (GlcCode != null && GlcCode.trim().length() > 0) {
						getGlccode().setText(GlcCode);
					} else {
						Factory.getInstance().addErrorMessage("Invalid refund item/glcode.", "PBA-[Refund Capture]");
						exitPanel();
					}
				} else {
					Factory.getInstance().addErrorMessage("Invalid refund item/glcode.", "PBA-[Refund Capture]");
					exitPanel();
				}
			}
		});

		// load table
		getPaymentTable().setListTableContent(getTxCode(), new String[] { getSlpNo().getText() });

		setActionType(QueryUtil.ACTION_APPEND);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextAmount getDefaultFocusComponent() {
		return getAmt();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {
	}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {
	}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
	}

	/* >>> ~13~ Set Disable Fields When Delete ButtonBase Is Clicked ====== <<< */
	@Override
	protected void deleteDisabledFields() {
	}

	/* >>> ~16~ Set Fetch Input Parameters ================================ <<< */
	@Override
	protected String[] getFetchInputParameters() {
		return null;
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {
	}

	/* >>> ~15~ Set Fetch Output Results ============================== <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected String[] getActionInputParamaters() {
		/*
		writeLog("Refund", "Param", "getUserInfo().getUserID(): "+getUserInfo().getUserID());
		writeLog("Refund", "Param", "getUserInfo().getCashierCode(): "+getUserInfo().getCashierCode());
		writeLog("Refund", "Param", "CommonUtil.getComputerName(): "+CommonUtil.getComputerName());
		writeLog("Refund", "Param", "getMethod().getText(): "+getMethod().getText());
		writeLog("Refund", "Param", "getMethod().getDisplayText(): "+getMethod().getDisplayText());
		writeLog("Refund", "Param", "getPatName().getText(): "+getPatName().getText());
		writeLog("Refund", "Param", "getDocCode().getText(): "+getDocCode().getText());
		writeLog("Refund", "Param", "getTdate().getText(): "+getTdate().getText());
		writeLog("Refund", "Param", "getSlpNo().getText(): "+getSlpNo().getText());
		writeLog("Refund", "Param", "getAmt().getText(): "+getAmt().getText());
		writeLog("Refund", "Param", "memAcmCode: "+memAcmCode);
		writeLog("Refund", "Param", "memBedCode: "+memBedCode);
		writeLog("Refund", "Param", "memPayee: "+memPayee);
		writeLog("Refund", "Param", "memPatAddr1: "+memPatAddr1);
		writeLog("Refund", "Param", "memPatAddr2: "+memPatAddr2);
		writeLog("Refund", "Param", "memPatAddr3: "+memPatAddr3);
		writeLog("Refund", "Param", "memCountry: "+memCountry);
		writeLog("Refund", "Param", "memReason: "+getAmt().getText());
		writeLog("Refund", "Param", "memS9000YN: "+(memS9000YN? YES_VALUE: NO_VALUE));
		writeLog("Refund", "Param", "memTmpReceiptNumber: "+memTmpReceiptNumber);
		writeLog("Refund", "Param", "memTxnType: "+memTxnType);
		writeLog("Refund", "Param", "memTxnEcrRef: "+memTxnEcrRef);
		writeLog("Refund", "Param", "memTxnAmount: "+memTxnAmount);
		writeLog("Refund", "Param", "memTxnRespCode: "+memTxnRespCode);
		writeLog("Refund", "Param", "memTxnRespText: "+memTxnRespText);
		writeLog("Refund", "Param", "memTxnDateTime: "+memTxnDateTime);
		writeLog("Refund", "Param", "memTxnCardType: "+memTxnCardType);
		writeLog("Refund", "Param", "memTxnCardNo: "+memTxnCardNo);
		writeLog("Refund", "Param", "memTxnExpiryDate: "+memTxnExpiryDate);
		writeLog("Refund", "Param", "memTxnCardHolder: "+memTxnCardHolder);
		writeLog("Refund", "Param", "memTxnTerminalNo: "+memTxnTerminalNo);
		writeLog("Refund", "Param", "memTxnMerchantNo: "+memTxnMerchantNo);
		writeLog("Refund", "Param", "memTxnStoreNo: "+memTxnStoreNo);
		writeLog("Refund", "Param", "memTxnTraceNo: "+memTxnTraceNo);
		writeLog("Refund", "Param", "memTxnBatchNo: "+memTxnBatchNo);
		writeLog("Refund", "Param", "memTxnAppCode: "+memTxnAppCode);
		writeLog("Refund", "Param", "memTxnRefNo: "+memTxnRefNo);
		writeLog("Refund", "Param", "memTxnRRNo: "+memTxnRRNo);
		writeLog("Refund", "Param", "memTxnVDate: "+memTxnVDate);
		writeLog("Refund", "Param", "memTxnDAccount: "+memTxnDAccount);
		writeLog("Refund", "Param", "memTxnAResp: "+memTxnAResp);
		*/
		return new String[] {
				getUserInfo().getUserID(),
				getUserInfo().getCashierCode(),
				CommonUtil.getComputerName(),
				getMethod().getText(),
				getMethod().getDisplayText(),
				getPatName().getText(),
				getDocCode().getText(),
				getTdate().getText(),
				getSlpNo().getText(),
				getAmt().getText(),
				memAcmCode,
				memBedCode,
				memPayee,
				memPatAddr1,
				memPatAddr2,
				memPatAddr3,
				memCountry,
				memReason,
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
				// credit card/octopus end
		};
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(final String actionType) {
		boolean returnValue = true;
		if (getMethod().isEmpty()) {
			Factory.getInstance().addErrorMessage("Please select one method.", "PBA-[Refund Capture]", getMethod());
			returnValue = false;
		} else if (!TextUtil.isPositiveInteger(getAmt().getText().trim())) {
			Factory.getInstance().addErrorMessage(MSG_POSITIVE_AMOUNT, "PBA-[Refund Capture]", getAmt());
			returnValue = false;
		} else if (getTdate().isEmpty() || !getTdate().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid date.", "PBA-[Refund Capture]", getTdate());
			returnValue = false;
		}

		String refundOrgAmt = getParameter("RefundAmt");
		if (getPaymentTable().getSelectedRow() >= 0) {
			refundOrgAmt = getPaymentTable().getSelectedRowContent()[0];
		}
		actionValidation(actionType, returnValue, "Refund",
				getMethod().getText(), CASHTX_TXNTYPE_PAYOUT, String.valueOf(-Integer.valueOf(refundOrgAmt)), getAmt().getText(),
				getPatNo().getText(), getSlpNo().getText(), null, null,
				null, null, null, null);
	}

	/***************************************************************************
	 * Overload Method
	 **************************************************************************/

	@Override
	protected void actionValidationPostReady(String actionType) {
		enableButton();

		// call after all action done
		if (ACTION_SAVE.equals(actionType)) {
			savePostAction();
		} else if (ACTION_ACCEPT.equals(actionType)) {
			acceptPostAction();
		}
		Factory.getInstance().addInformationMessage("Refund Success.");
		setActionType(null);
		exitPanel();
	}

	@Override
	protected void enableButton(String mode) {
		// disable all button
		disableButton();

		getSaveButton().setEnabled(true);
		getCancelButton().setEnabled(true);
	}

	@Override
	public void cancelAction() {
		if (getCancelButton().isEnabled() && getActionType() != null) {
			MessageBoxBase.confirm(MSG_PBA_SYSTEM, "Are you sure to cancel all unsaved operations?",
					new Listener<MessageBoxEvent>() {
				@Override
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						// do action after click yes
						cancelYesAction();
						exitPanel();
					}
				}
			});
		} else {
			// do action after click yes
			cancelYesAction();
		}
	}

	/***************************************************************************
	 * Layout Methods
	 **************************************************************************/

	@Override
	protected BasePanel getActionPanel() {
		if (actionPanel == null) {
			actionPanel = new BasePanel();
			actionPanel.setSize(779, 460);
			actionPanel.add(getSlpDetailPanel(), null);
			actionPanel.add(getRfdDetailPanel(), null);
			actionPanel.add(getPaymentPanel(), null);
		}
		return actionPanel;
	}

	public FieldSetBase getSlpDetailPanel() {
		if (slpDetailPanel == null) {
			slpDetailPanel = new FieldSetBase();
			slpDetailPanel.setHeading("Slip Details");
			slpDetailPanel.setBounds(5, 5, 757, 100);
			slpDetailPanel.add(getSlpNoDesc(), null);
			slpDetailPanel.add(getSlpNo(), null);
			slpDetailPanel.add(getPatDesc(), null);
			slpDetailPanel.add(getPatNo(), null);
			slpDetailPanel.add(getPatName(), null);
			slpDetailPanel.add(getAdmDateDesc(), null);
			slpDetailPanel.add(getAdmDate(), null);
			slpDetailPanel.add(getDocDesc(), null);
			slpDetailPanel.add(getDocCode(), null);
			slpDetailPanel.add(getDocName(), null);
		}
		return slpDetailPanel;
	}

	public LabelBase getSlpNoDesc() {
		if (slpNoDesc == null) {
			slpNoDesc = new LabelBase();
			slpNoDesc.setText("Slip Number");
			slpNoDesc.setBounds(50, 10, 100, 20);
		}
		return slpNoDesc;
	}

	public TextReadOnly getSlpNo() {
		if (slpNo == null) {
			slpNo = new TextReadOnly();
			slpNo.setBounds(150, 10, 140, 20);
		}
		return slpNo;
	}

	public LabelBase getPatDesc() {
		if (patDesc == null) {
			patDesc = new LabelBase();
			patDesc.setText("Patient");
			patDesc.setBounds(320, 10, 50, 20);
		}
		return patDesc;
	}

	public TextReadOnly getPatNo() {
		if (patNo == null) {
			patNo = new TextReadOnly();
			patNo.setBounds(370, 10, 110, 20);
		}
		return patNo;
	}

	public TextReadOnly getPatName() {
		if (patName == null) {
			patName = new TextReadOnly();
			patName.setBounds(490, 10, 180, 20);
		}
		return patName;
	}

	public LabelBase getAdmDateDesc() {
		if (admDateDesc == null) {
			admDateDesc = new LabelBase();
			admDateDesc.setText("Admission Date");
			admDateDesc.setBounds(50, 40, 100, 20);
		}
		return admDateDesc;
	}

	public TextReadOnly getAdmDate() {
		if (admDate == null) {
			admDate = new TextReadOnly();
			admDate.setBounds(150, 40, 140, 20);
		}
		return admDate;
	}

	public LabelBase getDocDesc() {
		if (docDesc == null) {
			docDesc = new LabelBase();
			docDesc.setText("Doctor");
			docDesc.setBounds(320, 40, 50, 20);
		}
		return docDesc;
	}

	public TextReadOnly getDocCode() {
		if (docCode == null) {
			docCode = new TextReadOnly();
			docCode.setBounds(370, 40, 110, 20);
		}
		return docCode;
	}

	public TextReadOnly getDocName() {
		if (docName == null) {
			docName = new TextReadOnly();
			docName.setBounds(490, 40, 180, 20);
		}
		return docName;
	}

	public FieldSetBase getRfdDetailPanel() {
		if (rfdDetailPanel == null) {
			rfdDetailPanel = new FieldSetBase();
			rfdDetailPanel.setHeading("Refund Details");
			rfdDetailPanel.setBounds(5, 115, 757, 132);
			rfdDetailPanel.add(getItmCodeDesc(), null);
			rfdDetailPanel.add(getItmCode(), null);
			rfdDetailPanel.add(getMethodDesc(), null);
			rfdDetailPanel.add(getMethod(), null);
			rfdDetailPanel.add(getAmtDesc(), null);
			rfdDetailPanel.add(getAmt(), null);
			rfdDetailPanel.add(getGlccodeDesc(), null);
			rfdDetailPanel.add(getGlccode(), null);
			rfdDetailPanel.add(getTdateDesc(), null);
			rfdDetailPanel.add(getTdate(), null);
		}
		return rfdDetailPanel;
	}

	public LabelBase getItmCodeDesc() {
		if (itmCodeDesc == null) {
			itmCodeDesc = new LabelBase();
			itmCodeDesc.setText("Item Code");
			itmCodeDesc.setBounds(80, 10, 100, 20);
		}
		return itmCodeDesc;
	}

	public TextReadOnly getItmCode() {
		if (itmCode == null) {
			itmCode = new TextReadOnly();
			itmCode.setBounds(190, 10, 120, 20);
		}
		return itmCode;
	}

	public LabelBase getMethodDesc() {
		if (methodDesc == null) {
			methodDesc = new LabelBase();
			methodDesc.setText("Method");
			methodDesc.setBounds(350, 10, 80, 20);
		}
		return methodDesc;
	}

	public ComboRefundMethod getMethod() {
		if (method == null) {
			method = new ComboRefundMethod() {
				@Override
				protected void resetContentPost() {
					if (getKeySize() >= 0) {
						setSelectedIndex(0);
					}
				}
			};
			method.setBounds(440, 10, 120, 20);
		}
		return method;
	}

	public LabelBase getAmtDesc() {
		if (amtDesc == null) {
			amtDesc = new LabelBase();
			amtDesc.setText("Amount");
			amtDesc.setBounds(80, 40, 100, 20);
		}
		return amtDesc;
	}

	public TextAmount getAmt() {
		if (amt == null) {
			amt = new TextAmount(ConstantsTransaction.MAX_AMOUNT_LIMIT);
			amt.setBounds(190, 40, 120, 20);
		}
		return amt;
	}

	public LabelBase getGlccodeDesc() {
		if (glccodeDesc == null) {
			glccodeDesc = new LabelBase();
			glccodeDesc.setText("Glc Code");
			glccodeDesc.setBounds(350, 40, 80, 20);
		}
		return glccodeDesc;
	}

	public TextReadOnly getGlccode() {
		if (glccode == null) {
			glccode = new TextReadOnly();
			glccode.setBounds(440, 40, 120, 20);
		}
		return glccode;
	}

	public LabelBase getTdateDesc() {
		if (tdateDesc == null) {
			tdateDesc = new LabelBase();
			tdateDesc.setText("Transation Date");
			tdateDesc.setBounds(80, 70, 100, 20);
		}
		return tdateDesc;
	}

	public TextDate getTdate() {
		if (tdate == null) {
			tdate = new TextDate();
			tdate.setBounds(190, 70, 120, 20);
		}
		return tdate;
	}

	protected String[] getPaymentColumnNames() {
		return new String[] { "Amount", "User", "Reference No","Terminal No", "Cap. Date",
				"Trans. Date", "Description", "Type", "Card #", "Holder",
				"Trace #", "Expiry date", "", "", "", ""};
	}

	protected int[] getPaymentColumnWidths() {
		return new int[] { 80, 60, 80,70, 70, 70, 150, 80, 120, 80, 80, 80, 0, 0, 0, 0 };
	}

	/**
	 * This method initializes paymentTable
	 *
	 * @return com.hkah.layout.ListTable
	 */
	public TableList getPaymentTable() {
		if (paymentTable == null) {
			paymentTable = new TableList(getPaymentColumnNames(), getPaymentColumnWidths());
		}
		return paymentTable;
	}

	/**
	 * This method initializes jScrollPane
	 *
	 * @return paymentScrollPane
	 */
	public JScrollPane getJScrollPaymentPane() {
		if (paymentScrollPane == null) {
			paymentScrollPane = new JScrollPane();
			paymentScrollPane.setBounds(15, 25, 725, 200);
			paymentScrollPane.setViewportView(getPaymentTable());
		}
		return paymentScrollPane;
	}

	public BasePanel getPaymentPanel() {
		if (paymentPanel == null) {
			paymentPanel = new BasePanel();
			paymentPanel.setTitledBorder();
			paymentPanel.setBounds(new Rectangle(5, 253, 757, 250));
			paymentPanel.add(getJScrollPaymentPane());
		}
		return paymentPanel;
	}
}