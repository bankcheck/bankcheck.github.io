package com.hkah.client.tx.transaction;

import com.extjs.gxt.ui.client.widget.form.TextField;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextDoctorSearch;
import com.hkah.client.layout.textfield.TextNum;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.ActionPanel;
import com.hkah.client.util.PanelUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTransaction;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class SlipTransactionModification extends ActionPanel {
	// property declare start
	private BasePanel actionPanel = null;
	private FieldSetBase detailPanel = null;

	private LabelBase slipSeqDesc = null;
	private TextReadOnly slipSeq = null;
	private LabelBase slipNoDesc = null;
	private TextReadOnly slipNo = null;
	private LabelBase itemCodeDesc = null;
	private TextReadOnly itemCode = null;
	private LabelBase pkgCodeDesc = null;
	private TextReadOnly pkgCode = null;
	private LabelBase acmCodeDesc = null;
	private TextReadOnly acmCode = null;
	private LabelBase glcCodeDesc = null;
	private TextReadOnly glcCode = null;
	private LabelBase originalAmtDesc = null;
	private TextReadOnly originalAmt = null;
	private LabelBase discountDesc = null;
	private TextReadOnly discount = null;
	private LabelBase netAmtDesc = null;
	private TextReadOnly netAmt = null;
	private LabelBase rptLvlDesc = null;
	private TextReadOnly rptLvl = null;
	private LabelBase statusDesc = null;
	private TextReadOnly status = null;
	private FieldSetBase adjustPanel = null;
	private LabelBase docCodeDesc = null;
	private TextDoctorSearch docCode = null;
	private TextReadOnly docName = null;
	private LabelBase txDateDesc = null;
	private TextDate txDate = null;
	private LabelBase billAmtDesc = null;
	private TextNum billAmt = null;
	private LabelBase descriptionDesc = null;
	private TextString description = null;

	private String action = ConstantsVariable.EMPTY_VALUE;

	private String stnid = null;

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.SLIPTX_MODIFY_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.SLIPTX_MODIFY_TITLE;
	}

	/**
	 * This method initializes
	 *
	 */
	public SlipTransactionModification() {
		super();
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		PanelUtil.setAllFieldsEditable(getRightPanel(), true);
		if (getParameter("SlpNo") != null) {
			getSlipSeq().setText(getParameter("StnSeq"));
			getSlipNo().setText(getParameter("SlpNo"));
			getItemCode().setText(getParameter("ItmCode"));
			getPkgCode().setText(getParameter("PkgCode"));
			getAcmCode().setText(getParameter("AcmCode"));
			getGlcCode().setText(getParameter("GlcCode"));
			getOriginalAmt().setText(getParameter("StnOAmt"));
			getDiscount().setText(getParameter("StnDisc"));
			getNetAmt().setText(getParameter("StnNAmt"));
			getRptLvl().setText(getParameter("StnRlvl"));
			getStatus().setText(getParameter("StnSts"));

			getDocCode().setText(getParameter("DocCode"));
			getDocName().setText(getParameter("DocName"));
			getTxDate().setText(getParameter("StnTDate"));
			getDescription().setText(getParameter("StnDesc"));

			stnid = getParameter("StnID");
			action = getParameter("TransactionMode");
			setForceExit(false);
			if (ConstantsTransaction.TXN_ADJUST_MODE.equalsIgnoreCase(action)) {
				getDocCode().setEditable(false);
				getTxDate().setEditable(false);
				getBillAmt().setEditable(true);
				getBillAmt().resetText();
				getDescription().setEditable(true);
				setForceExit(true);
			} else if (ConstantsTransaction.TXN_UPDATE_MODE.equalsIgnoreCase(action)) {
				getDocCode().setEditable(true);
				getTxDate().setEditable(true);
				getBillAmt().setEditable(false);
				getBillAmt().setText(getParameter("StnBAmt"));
				getDescription().setEditable(false);
				getDescription().hide();
				getDescriptionDesc().hide();
				setForceExit(true);
			} else {
				getDocCode().setEditable(true);
				getTxDate().setEditable(true);
				getBillAmt().setEditable(false);
				getBillAmt().setText(getParameter("StnBAmt"));
				getDescription().setEditable(false);
			}
		}

		setNewRefresh(false);//not refresh data from db
		modifyAction(true);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextField getDefaultFocusComponent() {
		if (ConstantsTransaction.TXN_ADJUST_MODE.equalsIgnoreCase(action)) {
			return getBillAmt();
		} else {
			return getDocCode();
		}
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {}

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
				action,
				getSlipNo().getText(),
				stnid,
				getBillAmt().getText().trim(),
				getDescription().getText().trim(),
				getTxDate().getText(),
				getDocCode().getText(),
				"-1",	//WITHDI
				"-1",	//Enhancement_01
				"1",	//SCM
				"A",	//stnsts
				getUserInfo().getUserID()
		};
	}

	/* >>> ~16.1~ Set Action Output Parameters =========================== <<< */
	@Override
	protected void getNewOutputValue(String returnValue) {}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {
		boolean returnValue = true;
		if (ConstantsVariable.EMPTY_VALUE.equals(getDocCode().getText().trim())) {
			Factory.getInstance().addErrorMessage("invalid doctor code.", "PBA - [Slip Transaction Modification]", getDocCode());
		}

		if (ConstantsTransaction.TXN_ADJUST_MODE.equalsIgnoreCase(action)) {
			if (getBillAmt().isEmpty()) {
				Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_NUMERIC_AMOUNT, "PBA - [Slip Transaction Modification]", getBillAmt());
				returnValue = false;
			} else {
				int billAmt = 0;
				int MaxAdjustAmount = 0;
				try {
					billAmt = Integer.parseInt(getBillAmt().getText().trim());
				} catch (Exception e) {
					Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_INTEGER_AMOUNT, "PBA - [Slip Transaction Modification]", getBillAmt());
					getBillAmt().setText(ConstantsVariable.EMPTY_VALUE);
					returnValue = false;
				}

				if (returnValue) {
					try {
						MaxAdjustAmount = Integer.parseInt(getParameter("StnBAmt"));
					} catch (Exception e) {
						Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_INTEGER_AMOUNT, "PBA - [Slip Transaction Modification]");
						getBillAmt().setText(ConstantsVariable.EMPTY_VALUE);
						returnValue = false;
					}
				}

				if (returnValue) {
					if (billAmt < 0 && -1 * billAmt > MaxAdjustAmount) {
						Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_MAXADJUST_AMOUNT, "PBA - [Slip Transaction Modification]", getBillAmt());
						getBillAmt().setText(ConstantsVariable.EMPTY_VALUE);
						returnValue = false;
					}
				}
			}
		} else {
			if (!getTxDate().isValid()) {
				Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_TRANSACTION_DATE, "PBA - [Slip Transaction Modification]", getTxDate());
				getTxDate().setText(getParameter("StnTDate"));
				returnValue = false;
			}
		}
		actionValidationReady(actionType, returnValue);
	}

	/***************************************************************************
	 * Override Methods
	 **************************************************************************/

	@Override
	protected void cancelPostAction() {
		exitPanel(true);
	}
	
	@Override
	public void saveAction() {
		if (getSaveButton().isEnabled()) {
			getSaveButton().setEnabled(false);
			performAction(ACTION_SAVE);
		}
	}

	@Override
	protected void actionValidationReady(final String actionType, boolean isValidationReady) {
		if (isValidationReady) {
			QueryUtil.executeMasterAction(getUserInfo(), getTxCode(), QueryUtil.ACTION_MODIFY,getActionInputParamaters(), new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						// reset action type
						setActionType(null);
						if (ConstantsTransaction.TXN_ADJUST_MODE.equals(action)) {
							Factory.getInstance().addInformationMessage("Sliptx adjust successfully.", "PBA - [Slip Transaction Modification]");
						} else if (ConstantsTransaction.TXN_UPDATE_MODE.equals(action)) {
							Factory.getInstance().addInformationMessage("Sliptx update successfully.", "PBA - [Slip Transaction Modification]");
						}
						exitPanel();
					} else {
						Factory.getInstance().addErrorMessage(mQueue.getReturnMsg(), "PBA - [Slip Transaction Modification]", getDefaultFocusComponent());
					}
				}
			});
		}
	}

	@Override
	protected void enableButton(String mode) {
		disableButton();
		getSaveButton().setEnabled(true);
		getCancelButton().setEnabled(true);
	}

	/***************************************************************************
	 * Layout Methods
	 **************************************************************************/

	@Override
	protected BasePanel getActionPanel() {
		if (actionPanel == null) {
			actionPanel = new BasePanel();
			actionPanel.setSize(735, 580);
			actionPanel.add(getDetailPanel(), null);
			actionPanel.add(getAdjustPanel(), null);
		}
		return actionPanel;
	}

	public FieldSetBase getDetailPanel() {
		if (detailPanel == null) {
			detailPanel = new FieldSetBase();
			detailPanel.setBounds(10, 10, 695, 270);
			detailPanel.setHeading("Slip Transaction Details");
			detailPanel.add(getSlipSeqDesc(), null);
			detailPanel.add(getSlipSeq(), null);
			detailPanel.add(getSlipNoDesc(), null);
			detailPanel.add(getSlipNo(), null);
			detailPanel.add(getItemCodeDesc(), null);
			detailPanel.add(getItemCode(), null);
			detailPanel.add(getPkgCodeDesc(), null);
			detailPanel.add(getPkgCode(), null);
			detailPanel.add(getAcmCodeDesc(), null);
			detailPanel.add(getAcmCode(), null);
			detailPanel.add(getGlcCodeDesc(), null);
			detailPanel.add(getGlcCode(), null);
			detailPanel.add(getOriginalAmtDesc(), null);
			detailPanel.add(getOriginalAmt(), null);
			detailPanel.add(getDiscountDesc(), null);
			detailPanel.add(getDiscount(), null);
			detailPanel.add(getNetAmtDesc(), null);
			detailPanel.add(getNetAmt(), null);
			detailPanel.add(getRptLvlDesc(), null);
			detailPanel.add(getRptLvl(), null);
			detailPanel.add(getStatusDesc(), null);
			detailPanel.add(getStatus(), null);
		}
		return detailPanel;
	}

	public FieldSetBase getAdjustPanel() {
		if (adjustPanel == null) {
			adjustPanel = new FieldSetBase();
			adjustPanel.setBounds(10, 290, 695, 100);
			adjustPanel.setHeading("Update Capture");
			adjustPanel.add(getDocCodeDesc(), null);
			adjustPanel.add(getDocCode(), null);
			adjustPanel.add(getDocName(), null);
			adjustPanel.add(getTxDateDesc(), null);
			adjustPanel.add(getTxDate(), null);
			adjustPanel.add(getBillAmtDesc(), null);
			adjustPanel.add(getBillAmt(), null);
			adjustPanel.add(getDescriptionDesc(), null);
			adjustPanel.add(getDescription(), null);
		}
		return adjustPanel;
	}

	public LabelBase getSlipSeqDesc() {
		if (slipSeqDesc == null) {
			slipSeqDesc = new LabelBase();
			slipSeqDesc.setText("Slip Seq");
			slipSeqDesc.setBounds(50, 20, 100, 20);
		}
		return slipSeqDesc;
	}

	public TextReadOnly getSlipSeq() {
		if (slipSeq == null) {
			slipSeq = new TextReadOnly();
			slipSeq.setBounds(155, 20, 120, 20);
		}
		return slipSeq;
	}

	public LabelBase getSlipNoDesc() {
		if (slipNoDesc == null) {
			slipNoDesc = new LabelBase();
			slipNoDesc.setText("Slip No");
			slipNoDesc.setBounds(360, 20, 100, 20);
		}
		return slipNoDesc;
	}

	public TextReadOnly getSlipNo() {
		if (slipNo == null) {
			slipNo = new TextReadOnly();
			slipNo.setBounds(465, 20, 120, 20);
		}
		return slipNo;
	}

	public LabelBase getItemCodeDesc() {
		if (itemCodeDesc == null) {
			itemCodeDesc = new LabelBase();
			itemCodeDesc.setText("Item Code");
			itemCodeDesc.setBounds(50, 50, 100, 20);
		}
		return itemCodeDesc;
	}

	public TextReadOnly getItemCode() {
		if (itemCode == null) {
			itemCode = new TextReadOnly();
			itemCode.setBounds(155, 50, 120, 20);
		}
		return itemCode;
	}

	public LabelBase getPkgCodeDesc() {
		if (pkgCodeDesc == null) {
			pkgCodeDesc = new LabelBase();
			pkgCodeDesc.setText("Package Code");
			pkgCodeDesc.setBounds(360, 50, 100, 20);
		}
		return pkgCodeDesc;
	}

	public TextReadOnly getPkgCode() {
		if (pkgCode == null) {
			pkgCode = new TextReadOnly();
			pkgCode.setBounds(465, 50, 120, 20);
		}
		return pkgCode;
	}

	public LabelBase getAcmCodeDesc() {
		if (acmCodeDesc == null) {
			acmCodeDesc = new LabelBase();
			acmCodeDesc.setText("Acm Code");
			acmCodeDesc.setBounds(50, 80, 100, 20);
		}
		return acmCodeDesc;
	}

	public TextReadOnly getAcmCode() {
		if (acmCode == null) {
			acmCode = new TextReadOnly();
			acmCode.setBounds(155, 80, 120, 20);
		}
		return acmCode;
	}

	public LabelBase getGlcCodeDesc() {
		if (glcCodeDesc == null) {
			glcCodeDesc = new LabelBase();
			glcCodeDesc.setText("Glc Code");
			glcCodeDesc.setBounds(360, 80, 100, 20);
		}
		return glcCodeDesc;
	}

	public TextReadOnly getGlcCode() {
		if (glcCode == null) {
			glcCode = new TextReadOnly();
			glcCode.setBounds(465, 80, 120, 20);
		}
		return glcCode;
	}

	public LabelBase getOriginalAmtDesc() {
		if (originalAmtDesc == null) {
			originalAmtDesc = new LabelBase();
			originalAmtDesc.setText("Original Amount");
			originalAmtDesc.setBounds(50, 110, 100, 20);
		}
		return originalAmtDesc;
	}

	public TextReadOnly getOriginalAmt() {
		if (originalAmt == null) {
			originalAmt = new TextReadOnly();
			originalAmt.setBounds(155, 110, 120, 20);
		}
		return originalAmt;
	}

	public LabelBase getDiscountDesc() {
		if (discountDesc == null) {
			discountDesc = new LabelBase();
			discountDesc.setText("Discount");
			discountDesc.setBounds(360, 110, 100, 20);
		}
		return discountDesc;
	}

	public TextReadOnly getDiscount() {
		if (discount == null) {
			discount = new TextReadOnly();
			discount.setBounds(465, 110, 120, 20);
		}
		return discount;
	}

	public LabelBase getNetAmtDesc() {
		if (netAmtDesc == null) {
			netAmtDesc = new LabelBase();
			netAmtDesc.setText("Net Amount");
			netAmtDesc.setBounds(50, 140, 100, 20);
		}
		return netAmtDesc;
	}

	public TextReadOnly getNetAmt() {
		if (netAmt == null) {
			netAmt = new TextReadOnly();
			netAmt.setBounds(155, 140, 120, 20);
		}
		return netAmt;
	}

	public LabelBase getRptLvlDesc() {
		if (rptLvlDesc == null) {
			rptLvlDesc = new LabelBase();
			rptLvlDesc.setText("Reporting Level");
			rptLvlDesc.setBounds(360, 140, 100, 20);
		}
		return rptLvlDesc;
	}

	public TextReadOnly getRptLvl() {
		if (rptLvl == null) {
			rptLvl = new TextReadOnly();
			rptLvl.setBounds(465, 140, 120, 20);
		}
		return rptLvl;
	}

	public LabelBase getStatusDesc() {
		if (statusDesc == null) {
			statusDesc = new LabelBase();
			statusDesc.setText("Status");
			statusDesc.setBounds(50, 170, 100, 20);
		}
		return statusDesc;
	}

	public TextReadOnly getStatus() {
		if (status == null) {
			status = new TextReadOnly();
			status.setBounds(155, 170, 120, 20);
		}
		return status;
	}

	public LabelBase getDocCodeDesc() {
		if (docCodeDesc == null) {
			docCodeDesc = new LabelBase();
			docCodeDesc.setText("Doctor Code");
			docCodeDesc.setBounds(50, 0, 100, 20);
		}
		return docCodeDesc;
	}

	public TextDoctorSearch getDocCode() {
		if (docCode == null) {
			docCode = new TextDoctorSearch(getDocName()) {
				public void onTyped() {
					//updatePatientChineseName();
				}
				public void onBlur() {
					// call database to retrieve district
					if (!ConstantsVariable.EMPTY_VALUE.equals(getDocCode().getText().trim())) {
						QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.DOCTOR_ACTIVE_TXCODE,
								new String[] {getDocCode().getText().trim()},
								new MessageQueueCallBack() {
									@Override
									public void onPostSuccess(MessageQueue mQueue) {
										if (mQueue.success()) {
											getDocName().setText(mQueue.getContentField()[0]);
										} else {
											Factory.getInstance().addErrorMessage("invalid doctor code.", "PBA - [Slip Transaction Modification]", getDocCode());
											docCode.setText(ConstantsVariable.EMPTY_VALUE);
											getDocName().setText(ConstantsVariable.EMPTY_VALUE);
										}
									}
								});
					} else {
						//Factory.getInstance().addErrorMessage("invalid doctor code.", "PBA - [Slip Transaction Modification]", getDocCode());
						//getDocCode().setText(ConstantsVariable.EMPTY_VALUE);
						//getDocName().setText(ConstantsVariable.EMPTY_VALUE);
					}

				}
			};
			docCode.setBounds(155, 0, 120, 20);
		}
		return docCode;
	}

	public TextReadOnly getDocName() {
		if (docName == null) {
			docName = new TextReadOnly();
			docName.setBounds(280, 0, 150, 20);
		}
		return docName;
	}

	public LabelBase getTxDateDesc() {
		if (txDateDesc == null) {
			txDateDesc = new LabelBase();
			txDateDesc.setText("Transaction Date");
			txDateDesc.setBounds(435, 0, 100, 20);
		}
		return txDateDesc;
	}

	public TextDate getTxDate() {
		if (txDate == null) {
			txDate = new TextDate();
			txDate.setBounds(540, 0, 100, 20);
		}
		return txDate;
	}

	public LabelBase getBillAmtDesc() {
		if (billAmtDesc == null) {
			billAmtDesc = new LabelBase();
			billAmtDesc.setText("Bill Amount");
			billAmtDesc.setBounds(50, 30, 100, 20);
		}
		return billAmtDesc;
	}

	public TextNum getBillAmt() {
		if (billAmt == null) {
			billAmt = new TextNum(10, 0, false, true);
			billAmt.setBounds(155, 30, 120, 20);
		}
		return billAmt;
	}

	public LabelBase getDescriptionDesc() {
		if (descriptionDesc == null) {
			descriptionDesc = new LabelBase();
			descriptionDesc.setText("Desciption");
			descriptionDesc.setBounds(385, 30, 100, 20);
		}
		return descriptionDesc;
	}

	public TextString getDescription() {
		if (description == null) {
			description = new TextString();
			description.setBounds(470, 30, 170, 20);
		}
		return description;
	}
}