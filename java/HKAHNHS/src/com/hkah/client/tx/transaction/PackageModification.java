package com.hkah.client.tx.transaction;

import com.extjs.gxt.ui.client.widget.form.TextField;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextPackageCodeSearch;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.ActionPanel;
import com.hkah.client.util.PanelUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTransaction;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class PackageModification extends ActionPanel {
	// property declare start
	private BasePanel actionPanel = null;
	private FieldSetBase detailPanel = null;
	private LabelBase pkgSeqDesc = null;
	private TextReadOnly pkgSeq = null;
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
	private LabelBase rptLvlDesc = null;
	private TextReadOnly rptLvl = null;
	private LabelBase statusDesc = null;
	private TextReadOnly status = null;
	private FieldSetBase adjustPanel = null;
	private FieldSetBase changePackagePanel = null;
	private LabelBase docCodeDesc = null;
	private TextReadOnly docCode = null;
	private LabelBase txDateDesc = null;
	private TextReadOnly txDate = null;
	private LabelBase billAmtDesc = null;
	private LabelBase billAmtDesc2 = null;
	private TextString billAmt = null;
	private TextReadOnly billAmt2 = null;
	private LabelBase descriptionDesc = null;
	private TextString description = null;
	private LabelBase toPkgDesc = null;
	private TextPackageCodeSearch toPkg = null;
	private LabelBase fromPkgDesc = null;
	private TextReadOnly fromPkg = null;

	private String action = "";
	private String ptnid = "";
	private String memAmount = null;
	private boolean doUpdatePkgCode = false;

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		if (ConstantsTransaction.TXN_ADJUST_MODE.equals(action)) {
			return ConstantsTx.PKGTX_ADJUST_TXCODE;
		} else {
			return ConstantsTx.PKGTX_MODIFY_TXCODE;
		}
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.PKGTX_MODIFY_TITLE;
	}

	/**
	 * This method initializes
	 *
	 */
	public PackageModification() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		setRightAlignPanel();

		return true;
	}

	public boolean performEscAction() {
		//super.performEscAction();
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		PanelUtil.setAllFieldsEditable(getRightPanel(), true);
		if (getParameter("pkgCode1") != null && getParameter("pkgCode1").length() > 0) {
			getToPkg().setText(getParameter("pkgCode1"));
			resetParameter("pkgCode1");
		}

		if (getParameter("PtnSeq") != null) {
			ptnid = getParameter("PtnID");
			action = getParameter("TransactionMode");
			doUpdatePkgCode = YES_VALUE.equals(getParameter("doUpdatePkgCode"));
			memAmount = getParameter("PtnBAmt");
			if (memAmount == null || memAmount.trim().length() == 0) {
				memAmount = getParameter("PtnOAmt");
			}

			getPkgSeq().setText(getParameter("PtnSeq"));
			getSlipNo().setText(getParameter("SlpNo"));
			getTxDate().setText(getParameter("PtnTDate"));
			getPkgCode().setText(getParameter("PkgCode"));
			getItemCode().setText(getParameter("ItmCode"));
			getDocCode().setText(getParameter("DocCode"));
			getAcmCode().setText(getParameter("AcmCode"));
			getGlcCode().setText(getParameter("GlcCode"));
			getOriginalAmt().setText(getParameter("PtnOAmt"));
			getStatus().setText(getParameter("PtnSts"));
			getRptLvl().setText(getParameter("PtnRLvl"));

//			resetParameter("PtnID");
//			resetParameter("TransactionMode");
//			resetParameter("PkgSeq");
//			resetParameter("SlpNo");
//			resetParameter("PtnTDate");
//			resetParameter("PkgCode");
//			resetParameter("ItmCode");
//			resetParameter("DocCode");
//			resetParameter("AcmCode");
//			resetParameter("GlcCode");
//			resetParameter("PtnOAmt");
//			resetParameter("PtnSts");
//			resetParameter("PtnRLvl");

			getFromPkg().resetText();
			getToPkg().resetText();
			getBillAmt().resetText();
			getDescription().resetText();

			if (ConstantsTransaction.TXN_ADJUST_MODE.equals(action)) {
				getBillAmt().setText(memAmount);
				getDescription().setText(getParameter("PtnDesc"));
				getAdjustPanel().setVisible(true);
				getChangePackagePanel().setVisible(false);
			} else {
				getFromPkg().setText(getPkgCode().getText());
				getBillAmt2().setText(memAmount);
				getAdjustPanel().setVisible(false);
				getChangePackagePanel().setVisible(true);
			}

			resetParameter("PtnDesc");
		}

		setNewRefresh(false);	//not refresh data from db
		setActionType(QueryUtil.ACTION_MODIFY);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextField<String> getDefaultFocusComponent() {
		if (ConstantsTransaction.TXN_ADJUST_MODE.equals(action)) {
			return getBillAmt();
		} else {
			return getToPkg();
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

	/* >>> ~14~ Set Browse Validation ===================================== <<< */
	@Override
	protected boolean browseValidation() {
		if (getDocCode().isEmpty()) {
			//showPanel(TransactionDetail.class);
		}
		return true;
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
			"1", //Enhancement_01
			"1", //OTP2
			getSlipNo().getText(),
		};
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
	protected void getFetchOutputValues(String[] outParam) {

	}

	/* >>> ~15~ Set Fetch Output Results ============================== <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		if (ConstantsTransaction.TXN_ADJUST_MODE.equals(action)) {
			return new String[] {
					getSlipNo().getText(),
					ptnid,
					getBillAmt().getText(),
					getDescription().getText(),
					null,
					null,
					getUserInfo().getUserID()
			};
		} else {
			return new String[] {
					getSlipNo().getText(),
					ptnid,
					getToPkg().getText(),
					doUpdatePkgCode ? YES_VALUE : NO_VALUE,
					getUserInfo().getDeptCode()
			};
		}
	}

	/* >>> ~16.1~ Set Action Output Parameters =========================== <<< */
	@Override
	protected void getNewOutputValue(String returnValue) {}

	/* >>> ~17~ Set Action Validation ================================= <<< */
	@Override
	protected void actionValidation(String actionType) {
		if (getAdjustPanel().isVisible()) {
			if (getBillAmt().isEmpty()) {
				Factory.getInstance().addErrorMessage("Please input Amount.", "PBA - [Slip Transaction Modification]", getBillAmt());
				return;
			} else if (!TextUtil.isInteger(getBillAmt().getText().trim())) {
				Factory.getInstance().addErrorMessage("Invalid Amount.", "PBA - [Slip Transaction Modification]", getBillAmt());
				getBillAmt().resetText();
				return;
			} else if (Integer.parseInt(getBillAmt().getText().trim()) < 0) {
				if ((Integer.parseInt(getBillAmt().getText().trim()) * -1) >
						Integer.parseInt(memAmount)) {
					Factory.getInstance().addErrorMessage("Invalid Amount.", "PBA - [Slip Transaction Modification]", getBillAmt());
					return;
				}
			}
		} else {
			if (getToPkg().isEmpty()) {
				Factory.getInstance().addErrorMessage("Please input package code", "PBA - [Slip Transaction Modification]", getToPkg());
				return;
			}
		}

		actionValidationReady(actionType, true);
	}

	/***************************************************************************
	 * Override Methods
	 **************************************************************************/

	@Override
	protected void actionValidationReady(final String actionType, boolean isValidationReady) {
		if (isValidationReady) {
			getMainFrame().setLoading(true);
			QueryUtil.executeMasterAction(getUserInfo(), getTxCode(), QueryUtil.ACTION_MODIFY,
					getActionInputParamaters(),
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						if (ConstantsTransaction.TXN_ADJUST_MODE.equals(action)) {
							setActionType(null);
							Factory.getInstance().addInformationMessage("Package Transaction adjust successfully.", "PBA - [Package Transaction Modification]");
							exitPanel();
						} else {
							setActionType(null);
							Factory.getInstance().addInformationMessage("Package Code update successfully.", "PBA - [Package Transaction Modification]");
							exitPanel();
						}
					} else {
						if ("-100".equals(mQueue.getReturnCode())) {
							getToPkg().resetText();
							Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_PKG_CODE, "PBA - [Package Transaction Modification]", getToPkg());
						} else {
							Factory.getInstance().addErrorMessage("Update failed - "+mQueue.getReturnMsg()+" Code="+mQueue.getReturnCode(), "PBA - [Package Transaction Modification]");
						}
					}
				}

				@Override
				public void onComplete() {
					super.onComplete();
					getMainFrame().setLoading(false);
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

	@Override
	protected void cancelPostAction() {
		 exitPanel() ;
	}

	@Override
	public void saveAction() {
		super.saveAction();
	}

	@Override
	public void searchAction() {
		showPanel(new PkgSearch());
	}

	/***************************************************************************
	 * Layout Methods
	 **************************************************************************/

	//action method override end
	/* >>> getter methods for init the Component start from here================================== <<< */
	@Override
	protected BasePanel getActionPanel() {
		if (actionPanel == null) {
			actionPanel = new BasePanel();
			actionPanel.setSize(735, 580);
			actionPanel.add(getDetailPanel(), null);
			actionPanel.add(getAdjustPanel(), null);
			actionPanel.add(getChangePackagePanel(), null);
		}
		return actionPanel;
	}

	public FieldSetBase getDetailPanel() {
		if (detailPanel == null) {
			detailPanel = new FieldSetBase();
			detailPanel.setBounds(5, 5, 695, 300);
			detailPanel.setHeading("Package Transaction Details");
			detailPanel.add(getPkgSeqDesc(), null);
			detailPanel.add(getPkgSeq(), null);
			detailPanel.add(getSlipNoDesc(), null);
			detailPanel.add(getSlipNo(), null);
			detailPanel.add(getTxDateDesc(), null);
			detailPanel.add(getTxDate(), null);
			detailPanel.add(getPkgCodeDesc(), null);
			detailPanel.add(getPkgCode(), null);
			detailPanel.add(getItemCodeDesc(), null);
			detailPanel.add(getItemCode(), null);
			detailPanel.add(getDocCodeDesc(), null);
			detailPanel.add(getDocCode(), null);
			detailPanel.add(getAcmCodeDesc(), null);
			detailPanel.add(getAcmCode(), null);
			detailPanel.add(getGlcCodeDesc(), null);
			detailPanel.add(getGlcCode(), null);
			detailPanel.add(getOriginalAmtDesc(), null);
			detailPanel.add(getOriginalAmt(), null);
			detailPanel.add(getStatusDesc(), null);
			detailPanel.add(getStatus(), null);
			detailPanel.add(getRptLvlDesc(), null);
			detailPanel.add(getRptLvl(), null);
		}
		return detailPanel;
	}

	public LabelBase getPkgSeqDesc() {
		if (pkgSeqDesc == null) {
			pkgSeqDesc = new LabelBase();
			pkgSeqDesc.setText("Package Seq");
			pkgSeqDesc.setBounds(50, 20, 100, 20);
		}
		return pkgSeqDesc;
	}

	public TextReadOnly getPkgSeq() {
		if (pkgSeq == null) {
			pkgSeq = new TextReadOnly();
			pkgSeq.setBounds(155, 20, 120, 20);
		}
		return pkgSeq;
	}

	public LabelBase getSlipNoDesc() {
		if (slipNoDesc == null) {
			slipNoDesc = new LabelBase();
			slipNoDesc.setText("Slip No");
			slipNoDesc.setBounds(380, 20, 100, 20);
		}
		return slipNoDesc;
	}

	public TextReadOnly getSlipNo() {
		if (slipNo == null) {
			slipNo = new TextReadOnly();
			slipNo.setBounds(490, 20, 120, 20);
		}
		return slipNo;
	}

	public LabelBase getTxDateDesc() {
		if (txDateDesc == null) {
			txDateDesc = new LabelBase();
			txDateDesc.setText("Transaction Date");
			txDateDesc.setBounds(50, 60, 100, 20);
		}
		return txDateDesc;
	}

	public TextReadOnly getTxDate() {
		if (txDate == null) {
			txDate = new TextReadOnly();
			txDate.setBounds(155, 60, 120, 20);
		}
		return txDate;
	}

	public LabelBase getPkgCodeDesc() {
		if (pkgCodeDesc == null) {
			pkgCodeDesc = new LabelBase();
			pkgCodeDesc.setText("Package Code");
			pkgCodeDesc.setBounds(380, 60, 100, 20);
		}
		return pkgCodeDesc;
	}

	public TextReadOnly getPkgCode() {
		if (pkgCode == null) {
			pkgCode = new TextReadOnly();
			pkgCode.setBounds(490, 60, 120, 20);
		}
		return pkgCode;
	}

	public LabelBase getItemCodeDesc() {
		if (itemCodeDesc == null) {
			itemCodeDesc = new LabelBase();
			itemCodeDesc.setText("Item Code");
			itemCodeDesc.setBounds(50, 100, 100, 20);
		}
		return itemCodeDesc;
	}

	public TextReadOnly getItemCode() {
		if (itemCode == null) {
			itemCode = new TextReadOnly();
			itemCode.setBounds(155, 100, 120, 20);
		}
		return itemCode;
	}

	public LabelBase getDocCodeDesc() {
		if (docCodeDesc == null) {
			docCodeDesc = new LabelBase();
			docCodeDesc.setText("Doctor Code");
			docCodeDesc.setBounds(380, 100, 100, 20);
		}
		return docCodeDesc;
	}

	public TextReadOnly getDocCode() {
		if (docCode == null) {
			docCode = new TextReadOnly();
			docCode.setBounds(490, 100, 120, 20);
		}
		return docCode;
	}

	public LabelBase getAcmCodeDesc() {
		if (acmCodeDesc == null) {
			acmCodeDesc = new LabelBase();
			acmCodeDesc.setText("Acm Code");
			acmCodeDesc.setBounds(50, 140, 100, 20);
		}
		return acmCodeDesc;
	}

	public TextReadOnly getAcmCode() {
		if (acmCode == null) {
			acmCode = new TextReadOnly();
			acmCode.setBounds(155, 140, 120, 20);
		}
		return acmCode;
	}

	public LabelBase getGlcCodeDesc() {
		if (glcCodeDesc == null) {
			glcCodeDesc = new LabelBase();
			glcCodeDesc.setText("Glc Code");
			glcCodeDesc.setBounds(380, 140, 100, 20);
		}
		return glcCodeDesc;
	}

	public TextReadOnly getGlcCode() {
		if (glcCode == null) {
			glcCode = new TextReadOnly();
			glcCode.setBounds(490, 140, 120, 20);
		}
		return glcCode;
	}

	public LabelBase getOriginalAmtDesc() {
		if (originalAmtDesc == null) {
			originalAmtDesc = new LabelBase();
			originalAmtDesc.setText("Original Amount");
			originalAmtDesc.setBounds(50, 180, 100, 20);
		}
		return originalAmtDesc;
	}

	public TextReadOnly getOriginalAmt() {
		if (originalAmt == null) {
			originalAmt = new TextReadOnly();
			originalAmt.setBounds(155, 180, 120, 20);
		}
		return originalAmt;
	}

	public LabelBase getStatusDesc() {
		if (statusDesc == null) {
			statusDesc = new LabelBase();
			statusDesc.setText("Status");
			statusDesc.setBounds(380, 180, 100, 20);
		}
		return statusDesc;
	}

	public TextReadOnly getStatus() {
		if (status == null) {
			status = new TextReadOnly();
			status.setBounds(490, 180, 120, 20);
		}
		return status;
	}

	public LabelBase getRptLvlDesc() {
		if (rptLvlDesc == null) {
			rptLvlDesc = new LabelBase();
			rptLvlDesc.setText("Reporting Level");
			rptLvlDesc.setBounds(50, 220, 100, 20);
		}
		return rptLvlDesc;
	}

	public TextReadOnly getRptLvl() {
		if (rptLvl == null) {
			rptLvl = new TextReadOnly();
			rptLvl.setBounds(155, 220, 120, 20);
		}
		return rptLvl;
	}

	public FieldSetBase getAdjustPanel() {
		if (adjustPanel == null) {
			adjustPanel = new FieldSetBase();
			adjustPanel.setBounds(5, 310, 695, 90);
			adjustPanel.setHeading("Adjust Capture");
			adjustPanel.add(getBillAmtDesc(), null);
			adjustPanel.add(getBillAmt(), null);
			adjustPanel.add(getDescriptionDesc(), null);
			adjustPanel.add(getDescription(), null);
		}
		return adjustPanel;
	}

	public LabelBase getBillAmtDesc() {
		if (billAmtDesc == null) {
			billAmtDesc = new LabelBase();
			billAmtDesc.setText("Bill Amount");
			billAmtDesc.setBounds(50, 10, 100, 20);
		}
		return billAmtDesc;
	}

	public TextString getBillAmt() {
		if (billAmt == null) {
			billAmt = new TextString();
			billAmt.setBounds(155, 10, 120, 20);
		}
		return billAmt;
	}

	public LabelBase getDescriptionDesc() {
		if (descriptionDesc == null) {
			descriptionDesc = new LabelBase();
			descriptionDesc.setText("Desciption");
			descriptionDesc.setBounds(380, 10, 100, 20);
		}
		return descriptionDesc;
	}

	public TextString getDescription() {
		if (description == null) {
			description = new TextString();
			description.setBounds(490, 10, 169, 20);
		}
		return description;
	}

	public FieldSetBase getChangePackagePanel() {
		if (changePackagePanel == null) {
			changePackagePanel = new FieldSetBase();
			changePackagePanel.setBounds(5, 310, 695, 90);
			changePackagePanel.setHeading("Change Package Code");
			changePackagePanel.add(getFromPkgDesc(), null);
			changePackagePanel.add(getFromPkg(), null);
			changePackagePanel.add(getBillAmtDesc2(), null);
			changePackagePanel.add(getBillAmt2(), null);
			changePackagePanel.add(getToPkgDesc(), null);
			changePackagePanel.add(getToPkg(), null);
		}
		return changePackagePanel;
	}

	public LabelBase getFromPkgDesc() {
		if (fromPkgDesc == null) {
			fromPkgDesc = new LabelBase();
			fromPkgDesc.setText("From Package");
			fromPkgDesc.setBounds(50, 0, 100, 20);
		}
		return fromPkgDesc;
	}

	public TextReadOnly getFromPkg() {
		if (fromPkg == null) {
			fromPkg = new TextReadOnly();
			fromPkg.setBounds(155, 0, 120, 20);
		}
		return fromPkg;
	}

	public LabelBase getBillAmtDesc2() {
		if (billAmtDesc2 == null) {
			billAmtDesc2 = new LabelBase();
			billAmtDesc2.setText("Bill Amount");
			billAmtDesc2.setBounds(380, 0, 100, 20);
		}
		return billAmtDesc2;
	}

	public TextReadOnly getBillAmt2() {
		if (billAmt2 == null) {
			billAmt2 = new TextReadOnly();
			billAmt2.setBounds(490, 0, 120, 20);
		}
		return billAmt2;
	}

	public LabelBase getToPkgDesc() {
		if (toPkgDesc == null) {
			toPkgDesc = new LabelBase();
			toPkgDesc.setText("To Package");
			toPkgDesc.setBounds(50, 30, 100, 20);
		}
		return toPkgDesc;
	}

	public TextPackageCodeSearch getToPkg() {
		if (toPkg == null) {
			toPkg = new TextPackageCodeSearch();
			toPkg.setBounds(155, 30, 120, 20);
		}
		return toPkg;
	}
}