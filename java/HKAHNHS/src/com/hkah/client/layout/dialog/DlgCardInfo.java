package com.hkah.client.layout.dialog;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.combobox.ComboCardType;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextDateTime;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsCashiers;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgCardInfo extends DialogBase implements ConstantsCashiers {
	private final static int m_frameWidth = 520;
	private final static int m_frameHeight = 320;

	private BasePanel basePanel = null;
	private BasePanel cardPanel = null;
	private LabelBase infoDesc = null;
	private LabelBase terminalNoDesc = null;
	private TextString terminalNo = null;
	private LabelBase merchantNoDesc = null;
	private TextString merchantNo = null;
	private LabelBase cardTypeDesc = null;
	private ComboCardType cardType = null;
	private LabelBase cardNoDesc = null;
	private TextString cardNo = null;
	private LabelBase batchNoDesc = null;
	private TextString batchNo = null;
	private LabelBase traceNoDesc = null;
	private TextString traceNo = null;
	private LabelBase ecrRefDesc = null;
	private TextString ecrRef = null;
	private LabelBase appCodeDesc = null;
	private TextString appCode = null;
	private LabelBase refNoDesc = null;
	private TextString refNo = null;
	private LabelBase tDateDesc = null;
	private TextDateTime tDate = null;
	private LabelBase expiryDateDesc = null;
	private TextString expiryDate = null;
	private LabelBase expiryDateRemark = null;

	private String memActionType = null;
	private String memActionDescription = null;
	private String memPayCode = null;

	public DlgCardInfo(MainFrame owner) {
		super(owner, OKCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setContentPane(getBasePanel());

    	// change label
    	getButtonById(OK).setText("Confirm", 'C');
    	getButtonById(CANCEL).setText("Cancel", 'a');
	}

	public TextString getDefaultFocusComponent() {
		return getTerminalNo();
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String actionType, String actionDescription, String payType, String paymentType, String payCode, String slipNo) {
		memActionType = actionType;
		memActionDescription = actionDescription;
		memPayCode = payCode;

		getCardNoDesc().setText("Card Number");
		getCardNo().setStringLength(19);
		getTraceNoDesc().setText("Trace Number");
		getRefNoDesc().setText("Reference No");
		getRefNo().setStringLength(12);
		getAppCodeDesc().setVisible(true);
		getAppCode().setVisible(true);
		getExpiryDateDesc().setVisible(true);
		getExpiryDate().setVisible(true);
		getExpiryDateRemark().setVisible(true);

		if (CASHTX_PAYTYPE_EPS.equals(paymentType)) {
			setTitle("EPS Information Entry");
			getCardPanel().setHeading("EPS Information");
			getInfoDesc().setText("<html><b>If the card machine is completed successfully and the transaction is not updated to the computer system, please enter all required information below.</b></html>");
			getTraceNoDesc().setText("ISN Number");
		} else if (CASHTX_PAYTYPE_QR.equals(paymentType)) {
			setTitle("WeChat/Ali Pay Information Entry");
			getCardPanel().setHeading("WeChat/Ali Pay Information");
			getInfoDesc().setText("<html><b>After Manual operation of the credit card machine<br>Please enter all required information below for reference</b></html>");
			getCardNoDesc().setText("Trade Number");
			getCardNo().setStringLength(32);
			getRefNoDesc().setText("Transaction ID");
			getRefNo().setStringLength(40);
			getAppCodeDesc().setVisible(false);
			getAppCode().setVisible(false);
			getExpiryDateDesc().setVisible(false);
			getExpiryDate().setVisible(false);
			getExpiryDateRemark().setVisible(false);
		} else {
			setTitle("Credit Card Information Entry");
			getCardPanel().setHeading("Credit Card Information");
			getInfoDesc().setText("<html><b>After Manual operation of the credit card machine<br>Please enter all required information below for reference</b></html>");
		}
		getCardType().initContent(payCode);

		getTerminalNo().resetText();
		getMerchantNo().resetText();
		getCardType().resetText();
		getCardNo().resetText();
		getBatchNo().resetText();
		getTraceNo().resetText();
		getAppCode().resetText();
		getRefNo().resetText();
		getTDate().setText(getMainFrame().getServerDateTime());
		getExpiryDate().resetText();

		if (slipNo != null) {
			QueryUtil.executeMasterFetch(getUserInfo(), "CARDNEWREF",
					new String[] { slipNo },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						getEcrRef().setText(mQueue.getContentField()[0]);
						setVisible(true);
					}
				}
			});
		} else {
			getEcrRef().setText(getTmpReceiptNumber(payType));
			setVisible(true);
		}
	}

	@Override
	protected void doOkAction() {
		if (getCardType().isEmpty()) {
			Factory.getInstance().addErrorMessage("Card Type is empty.", getCardType());
			return;
		} else if (!getCardType().isValid()) {
			Factory.getInstance().addErrorMessage("Card Type is invalid.", getCardType());
			return;
		} else if ("07".equals(memPayCode) && getRefNo().isEmpty()) {
			Factory.getInstance().addErrorMessage("Reference No is empty.", getRefNo());
			return;
		} else if (getTDate().isEmpty()) {
			Factory.getInstance().addErrorMessage("Transaction date is empty.", getTDate());
			return;
		} else if (!getTDate().isValid()) {
			Factory.getInstance().addErrorMessage("Transaction date is not a date type.", getTDate());
			return;
		} else if (!getExpiryDate().isEmpty() && !DateTimeUtil.isExpiryDate(getExpiryDate().getText().trim())) {
			Factory.getInstance().addErrorMessage("The format of expiry date is invalid.", getExpiryDate());
			return;
		}

		MessageBoxBase.confirm(ConstantsMessage.MSG_PBA_SYSTEM, ConstantsMessage.MSG_CARDINFO_CONFIRM,
				new Listener<MessageBoxEvent>() {
			public void handleEvent(MessageBoxEvent be) {
				if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
					post(
						memActionType,
						memActionDescription,
						Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId()),
						getTerminalNo().getText(),
						getMerchantNo().getText(),
						getCardType().getText(),
						getCardNo().getText(),
						getBatchNo().getText(),
						getTraceNo().getText(),
						getEcrRef().getText(),
						getAppCode().getText(),
						getRefNo().getText(),
						getTDate().getText(),
						!getExpiryDate().isEmpty() ? getExpiryDate().getText().substring(2) + getExpiryDate().getText().substring(0, 2) : EMPTY_VALUE
					);
				}
			}
		});
	}

	@Override
	protected void doCancelAction() {
		post(memActionType, memActionDescription, false, null, null, null, null, null, null, null, null, null, null, null);
	}

	public void post(String actionType, String actionDescription,
			boolean confirmed, String terminalNo, String merchantNo, String cardType,
			String cardNo, String batchNo, String traceNo, String ecrRef, String appCode,
			String refNo, String transactionDateTime, String expiryDate) {
		dispose();
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getBasePanel() {
		if (basePanel == null) {
			basePanel = new BasePanel();
			basePanel.setBounds(0, 0, 520, 320);
			basePanel.add(getInfoDesc(), null);
			basePanel.add(getCardPanel(), null);
		}
		return basePanel;
	}

	public LabelBase getInfoDesc() {
		if (infoDesc == null) {
			infoDesc = new LabelBase();
			infoDesc.setBounds(3, 3, 495, 60);
		}
		return infoDesc;
	}

	public BasePanel getCardPanel() {
		if (cardPanel == null) {
			cardPanel = new BasePanel();
			cardPanel.setBounds(3, 50, 485, 180);
			cardPanel.add(getTerminalNoDesc(), null);
			cardPanel.add(getTerminalNo(), null);
			cardPanel.add(getMerchantNoDesc(), null);
			cardPanel.add(getMerchantNo(), null);
			cardPanel.add(getCardTypeDesc(), null);
			cardPanel.add(getCardType(), null);
			cardPanel.add(getCardNoDesc(), null);
			cardPanel.add(getCardNo(), null);
			cardPanel.add(getBatchNoDesc(), null);
			cardPanel.add(getBatchNo(), null);
			cardPanel.add(getTraceNoDesc(), null);
			cardPanel.add(getTraceNo(), null);
			cardPanel.add(getEcrRefDesc(), null);
			cardPanel.add(getEcrRef(), null);
			cardPanel.add(getAppCodeDesc(), null);
			cardPanel.add(getAppCode(), null);
			cardPanel.add(getRefNoDesc(), null);
			cardPanel.add(getRefNo(), null);
			cardPanel.add(getTDateDesc(), null);
			cardPanel.add(getTDate(), null);
			cardPanel.add(getExpiryDateDesc(), null);
			cardPanel.add(getExpiryDate(), null);
			cardPanel.add(getExpiryDateRemark(), null);
		}
		return cardPanel;
	}

	public LabelBase getTerminalNoDesc() {
		if (terminalNoDesc == null) {
			terminalNoDesc = new LabelBase();
			terminalNoDesc.setText("Terminal No.");
			terminalNoDesc.setBounds(10, 20, 100, 20);
		}
		return terminalNoDesc;
	}

	public TextString getTerminalNo() {
		if (terminalNo == null) {
			terminalNo = new TextString(8);
			terminalNo.setBounds(95, 20, 130, 20);
		}
		return terminalNo;
	}

	public LabelBase getMerchantNoDesc() {
		if (merchantNoDesc == null) {
			merchantNoDesc = new LabelBase();
			merchantNoDesc.setText("Merchant No.");
			merchantNoDesc.setBounds(250, 20, 100, 20);
		}
		return merchantNoDesc;
	}

	public TextString getMerchantNo() {
		if (merchantNo == null) {
			merchantNo = new TextString(15);
			merchantNo.setBounds(345, 20, 130, 20);
		}
		return merchantNo;
	}

	public LabelBase getCardTypeDesc() {
		if (cardTypeDesc == null) {
			cardTypeDesc = new LabelBase();
			cardTypeDesc.setText("Card Type");
			cardTypeDesc.setBounds(10, 45, 100, 20);
		}
		return cardTypeDesc;
	}

	public ComboCardType getCardType() {
		if (cardType == null) {
			cardType = new ComboCardType();
			cardType.setBounds(95, 45, 130, 20);
		}
		return cardType;
	}

	public LabelBase getCardNoDesc() {
		if (cardNoDesc == null) {
			cardNoDesc = new LabelBase();
			cardNoDesc.setText("Card Number");
			cardNoDesc.setBounds(250, 45, 100, 20);
		}
		return cardNoDesc;
	}

	public TextString getCardNo() {
		if (cardNo == null) {
			cardNo = new TextString(19);
			cardNo.setBounds(345, 45, 130, 20);
		}
		return cardNo;
	}

	public LabelBase getBatchNoDesc() {
		if (batchNoDesc == null) {
			batchNoDesc = new LabelBase();
			batchNoDesc.setText("Batch Number");
			batchNoDesc.setBounds(10, 70, 100, 20);
		}
		return batchNoDesc;
	}

	public TextString getBatchNo() {
		if (batchNo == null) {
			batchNo = new TextString(6);
			batchNo.setBounds(95, 70, 130, 20);
		}
		return batchNo;
	}

	public LabelBase getTraceNoDesc() {
		if (traceNoDesc == null) {
			traceNoDesc = new LabelBase();
			traceNoDesc.setBounds(250, 70, 100, 20);
		}
		return traceNoDesc;
	}

	public TextString getTraceNo() {
		if (traceNo == null) {
			traceNo = new TextString(6);
			traceNo.setBounds(345, 70, 130, 20);
		}
		return traceNo;
	}

	public LabelBase getEcrRefDesc() {
		if (ecrRefDesc == null) {
			ecrRefDesc = new LabelBase();
			ecrRefDesc.setText("ECR Reference");
			ecrRefDesc.setBounds(10, 95, 100, 20);
		}
		return ecrRefDesc;
	}

	public TextString getEcrRef() {
		if (ecrRef == null) {
			ecrRef = new TextString(16);
			ecrRef.setBounds(95, 95, 130, 20);
		}
		return ecrRef;
	}

	public LabelBase getAppCodeDesc() {
		if (appCodeDesc == null) {
			appCodeDesc = new LabelBase();
			appCodeDesc.setText("Approval Code");
			appCodeDesc.setBounds(250, 95, 100, 20);
		}
		return appCodeDesc;
	}

	public TextString getAppCode() {
		if (appCode == null) {
			appCode = new TextString(6);
			appCode.setBounds(345, 95, 130, 20);
		}
		return appCode;
	}

	public LabelBase getRefNoDesc() {
		if (refNoDesc == null) {
			refNoDesc = new LabelBase();
			refNoDesc.setText("Reference No");
			refNoDesc.setBounds(10, 120, 100, 20);
		}
		return refNoDesc;
	}

	public TextString getRefNo() {
		if (refNo == null) {
			refNo = new TextString(12);
			refNo.setBounds(95, 120, 130, 20);
		}
		return refNo;
	}

	public LabelBase getTDateDesc() {
		if (tDateDesc == null) {
			tDateDesc = new LabelBase();
			tDateDesc.setText("Transaction Date");
			tDateDesc.setBounds(250, 120, 100, 20);
		}
		return tDateDesc;
	}

	public TextDateTime getTDate() {
		if (tDate == null) {
			tDate = new TextDateTime();
			tDate.setBounds(345, 120, 130, 20);
		}
		return tDate;
	}

	public LabelBase getExpiryDateDesc() {
		if (expiryDateDesc == null) {
			expiryDateDesc = new LabelBase();
			expiryDateDesc.setText("Expiry Date");
			expiryDateDesc.setBounds(10, 145, 100, 20);
		}
		return expiryDateDesc;
	}

	public TextString getExpiryDate() {
		if (expiryDate == null) {
			expiryDate = new TextString(4);
			expiryDate.setBounds(95, 145, 130, 20);
		}
		return expiryDate;
	}

	public LabelBase getExpiryDateRemark() {
		if (expiryDateRemark == null) {
			expiryDateRemark = new LabelBase();
			expiryDateRemark.setText("(MMYY)");
			expiryDateRemark.setBounds(235, 145, 50, 20);
		}
		return expiryDateRemark;
	}

	private String getTmpReceiptNumber(String payType) {
		StringBuffer receiptNumber = new StringBuffer();
		receiptNumber.append("000000");
		if (!CASHTX_TXNTYPE_PAYOUT.equals(payType)) {
			receiptNumber.append(getUserInfo().getUserID());
			receiptNumber.append(getMainFrame().getServerTime());
		}

		if (receiptNumber.length() > 16) {
			return receiptNumber.substring(receiptNumber.length() - 16);
		} else {
			return receiptNumber.toString();
		}
	}
}