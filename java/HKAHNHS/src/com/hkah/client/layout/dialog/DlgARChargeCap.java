package com.hkah.client.layout.dialog;

import com.extjs.gxt.ui.client.widget.Dialog;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextNum;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsAR;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgARChargeCap extends DialogBase implements ConstantsAR {

	private final static int m_frameWidth = 450;
	private final static int m_frameHeight = 265;

	private BasePanel panel = null;
	private LabelBase payCodeDesc = null;
	private TextReadOnly userID = null;
	private TextReadOnly payName = null;
	private LabelBase tranDateDesc = null;
	private TextDate tranDate = null;
	private LabelBase descDesc = null;
	private TextString desc = null;
	private LabelBase amountDesc = null;
	private TextReadOnly payerCode = null;
	private TextNum amount = null;
	private TextNum xref = null;
	private LabelBase xrefDesc = null;
	private LabelBase userIDDesc = null;

	private String memTransactionMode = null;
	private String memArcCode = null;
	private String memArcName = null;
	private String memAtxAmt = null;
	private String memAtxDesc = null;
	private String memAtxRefID = null;
//	private String memArID = null;

	/**
	 * This method initializes
	 *
	 */
	public DlgARChargeCap(MainFrame owner
	) {
		super(owner, OKCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setContentPane(getPanel());
		setVisible(false);
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	/**
	 * This method showDialog this
	 *
	 */
	public void showDialog(
			String transactionMode,
			String arcCode,
			String arcName,
			String atxAmt,
			String atxDesc,
			String atxRefID,
			String arID) {
		memTransactionMode = transactionMode;
		memArcCode = arcCode;
		memArcName = arcName;
		memAtxAmt = atxAmt;
		memAtxDesc = atxDesc;
		memAtxRefID = atxRefID;
//		memArID = arID;

		if (AR_CHARGE_MODE.equals(memTransactionMode)) {
			setTitle("AR Charge Capture");
			getAmount().setText("");
			getDescription().setText("");
			getXref().setText("");
		} else {
			setTitle("AR Adjust Capture");
			getAmount().setText(memAtxAmt);
			getDescription().setText(memAtxDesc);
			getXref().setText(memAtxRefID);
			getXref().setEditable(false);
		}

		getPayerCode().setText(memArcCode);
		getPayName().setText(memArcName);
		getUserID().setText(getUserInfo().getUserID());
		getTranDate().setText(getMainFrame().getServerDate());

		setVisible(true);
	}

	protected boolean validation() {
		if (getAmount().isEmpty()) {
			Factory.getInstance().addErrorMessage("Please enter a numeric amount.", getAmount());
			return false;
		}
		if (getTranDate().isEmpty() || !getTranDate().isValid()) {
			Factory.getInstance().addErrorMessage("Please enter the transaction date with the format of dd/mm/yyyy.", getTranDate());
			return false;
		}
		if (getDescription().isEmpty()) {
			Factory.getInstance().addErrorMessage("Please enter the description.", getDescription());
			return false;
		}
		return true;
	}

	protected void post() {
		if (validation()) {
			String[] inParam;
			String strDesc = getDescription().getText().trim();
			MessageQueueCallBack callBack = new MessageQueueCallBack() {
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						if (AR_CHARGE_MODE.equals(memTransactionMode)) {
							Factory.getInstance().addInformationMessage(ConstantsMessage.MSG_ARCHARGE_SUCCESS);
						} else {
							Factory.getInstance().addInformationMessage(ConstantsMessage.MSG_ARADJUST_SUCCESS);
						}
						afterPost();
						dispose();
					} else {
						Factory.getInstance().addErrorMessage(mQueue.getReturnMsg());
					}
					getButtonBar().getItemByItemId(Dialog.OK).enable();
				}

				public void onComplete() {
					super.onComplete();
					getMainFrame().setLoading(false);
				}
			};
			if (AR_CHARGE_MODE.equals(memTransactionMode) && Double.parseDouble(getAmount().getText())<0) {
				inParam = new String[] {
					memArcCode,
					getAmount().getText(),"","","",
					strDesc,
					getUserInfo().getUserID()
				};
				QueryUtil.executeMasterAction(
						getUserInfo(), ConstantsTx.ARPAYMENTENTRY_TXCODE,QueryUtil.ACTION_APPEND, inParam, callBack);
			} else {
				if (AR_ADJUST_MODE.equals(memTransactionMode)) {
					if (memAtxDesc.length() > 0) {
						strDesc = memAtxDesc;
					}
				}
				inParam = new String[] {
						memArcCode,"","",
						getAmount().getText(),	"0",
						getTranDate().getText(),"",
						getXref().getText(),
						AR_CHARGE_MODE.equals(memTransactionMode)?"C":"A",
						"N",
						strDesc,
						getUserInfo().getUserID()
				};
				QueryUtil.executeMasterAction(
						getUserInfo(), ConstantsTx.ARENTRY_TXCODE,
						QueryUtil.ACTION_APPEND, inParam, callBack);
			}
		}
	}

	protected void afterPost() {
		// override from child class
	}

	@Override
	protected void doOkAction() {
		getMainFrame().setLoading(true);
		getButtonBar().getItemByItemId(Dialog.OK).disable();
		post();
	}

	@Override
	protected void doCancelAction() {
		afterPost();
		dispose();
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/**
	 * This method initializes panel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	private BasePanel getPanel() {
		if (panel == null) {
			panel = new BasePanel();
			panel.add(getPayCodeDesc(), null);
			panel.add(getPayerCode(), null);
			panel.add(getPayName(), null);
			panel.add(getAmountDesc(), null);
			panel.add(getAmount(), null);
			panel.add(getTranDateDesc(), null);
			panel.add(getTranDate(), null);
			panel.add(getDescDesc(), null);
			panel.add(getDescription(), null);
			panel.add(getXrefDesc(), null);
			panel.add(getXref(), null);
			panel.add(getUserIDDesc(), null);
			panel.add(getUserID(), null);
		}
		return panel;
	}

	/**
	 * This method initializes tranDateDesc
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getPayCodeDesc() {
		if (payCodeDesc == null) {
			payCodeDesc = new LabelBase();
			payCodeDesc.setBounds(39, 10, 55, 20);
			payCodeDesc.setText("Payer");
		}
		return payCodeDesc;
	}

	/**
	 * This method initializes payerCode
	 *
	 * @return com.hkah.client.layout.textfield.TextReadOnly
	 */
	private TextReadOnly getPayerCode() {
		if (payerCode == null) {
			payerCode = new TextReadOnly();
			payerCode.setBounds(109, 10, 69, 20);
		}
		return payerCode;
	}

	/**
	 * This method initializes payName
	 *
	 * @return com.hkah.client.layout.textfield.TextReadOnly
	 */
	private TextReadOnly getPayName() {
		if (payName == null) {
			payName = new TextReadOnly();
			payName.setBounds(188, 10, 208, 20);
		}
		return payName;
	}

	/**
	 * This method initializes amountDesc
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getAmountDesc() {
		if (amountDesc == null) {
			amountDesc = new LabelBase();
			amountDesc.setBounds(39, 45, 56, 20);
			amountDesc.setText("Amount");
		}
		return amountDesc;
	}

	/**
	 * This method initializes amount
	 *
	 * @return com.hkah.client.layout.textfield.TextNum
	 */
	private TextNum getAmount() {
		if (amount == null) {
			amount = new TextNum(10, 3, false, true);
			amount.setBounds(109, 45, 69, 20);
		}
		return amount;
	}

	/**
	 * This method initializes tranDateDesc
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getTranDateDesc() {
		if (tranDateDesc == null) {
			tranDateDesc = new LabelBase();
			tranDateDesc.setBounds(188, 45, 100, 19);
			tranDateDesc.setText("Transaction Date");
		}
		return tranDateDesc;
	}

	/**
	 * This method initializes tranDate
	 *
	 * @return com.hkah.client.layout.textfield.TextDate
	 */
	private TextDate getTranDate() {
		if (tranDate == null) {
			tranDate = new TextDate();
			tranDate.setBounds(300, 45, 100, 20);
		}
		return tranDate;
	}

	/**
	 * This method initializes tranDateDesc
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getDescDesc() {
		if (descDesc == null) {
			descDesc = new LabelBase();
			descDesc.setBounds(40, 80, 65, 20);
			descDesc.setText("Description");
		}
		return descDesc;
	}

	/**
	 * This method initializes desc
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getDescription() {
		if (desc == null) {
			desc = new TextString(50, false);
			desc.setBounds(109, 80, 169, 20);
		}
		return desc;
	}

	/**
	 * This method initializes tranDateDesc
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getXrefDesc() {
		if (xrefDesc == null) {
			xrefDesc = new LabelBase();
			xrefDesc.setBounds(39, 115, 65, 20);
			xrefDesc.setText("XRef");
		}
		return xrefDesc;
	}

	/**
	 * This method initializes xref
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextNum getXref() {
		if (xref == null) {
			xref = new TextNum(10);
			xref.setBounds(109, 115, 110, 20);
		}
		return xref;
	}

	/**
	 * This method initializes userIDDesc
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getUserIDDesc() {
		if (userIDDesc == null) {
			userIDDesc = new LabelBase();
			userIDDesc.setBounds(39, 150, 65, 20);
			userIDDesc.setText("User ID");
		}
		return userIDDesc;
	}

	/**
	 * This method initializes userID
	 * @return com.hkah.client.layout.textfield.TextReadOnly
	 */
	private TextReadOnly getUserID() {
		if (userID == null) {
			userID = new TextReadOnly();
			userID.setBounds(109, 150, 110, 20);
		}
		return userID;
	}
}