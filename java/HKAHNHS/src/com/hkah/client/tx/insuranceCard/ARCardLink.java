package com.hkah.client.tx.insuranceCard;

import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.google.gwt.event.dom.client.ErrorEvent;
import com.google.gwt.event.dom.client.ErrorHandler;
import com.google.gwt.user.client.ui.Image;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboHealthExamCoverage;
import com.hkah.client.layout.combobox.ComboImmunizationCoverage;
import com.hkah.client.layout.combobox.ComboOtherCoverage;
import com.hkah.client.layout.combobox.ComboPrePostNatal;
import com.hkah.client.layout.dialog.DlgARCardTypeSel;
import com.hkah.client.layout.dialog.DlgGeneralExclusions;
import com.hkah.client.layout.dialog.DlgInsuranceOptions;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.TabbedPaneBase;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextARCodeSimpleSearch;
import com.hkah.client.layout.textfield.TextAreaBase;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.util.PanelUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class ARCardLink extends MasterPanel {

	private final static String SERVER_PATH_PREFIX = "http://";
	private final static String SERVER_PATH_SUFFIX = "/intranet/hat/arCardImage.jsp?arcard=";
	private final static String SERVER_PATH_NO_IMAGE_SUFFIX = "/intranet/images/Photo Not Available.jpg";
	private static final String OPENFILE_SUFFIX  = "/intranet/hat/open_document.jsp?filePath=";
	private static final String ENLARGEPHOTO_SUFFIX = "/intranet/hat/arCardImage.jsp?arcard=";
	private String imageNotFoundUrl = null;
	private String serverPathUrl = null;
	private String openFileUrl = null;
	private String enlargePhotoUrl = null;

    /* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.ARCARDLINK_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.ARCARDLINK_TITLE;
	}

	@Override
	protected String[] getColumnNames() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	protected int[] getColumnWidths() {
		// TODO Auto-generated method stub
		return null;
	}

	private BasePanel leftPanel = null;
	private BasePanel rightPanel = null;

	private boolean adminOnly = false;

	private String memPre_ArcCode = null;
	private String memActID = EMPTY_VALUE;
	private String mdmARCardName = EMPTY_VALUE;
	private String memArcCode = null;
	private String memIpUrl = null;
	private String memOpUrl = null;
	private String memInpExclu = null;
	private String memOutExclu = null;
	private String memInVouch = null;
	private String memOutVouch = null;
	private String memInClaim = null;
	private String memOutClaim = null;
	private String memInAcknowForm = null;
//	private String memOutAcknowForm = null;
	private String memInNameList = null;
	private String memOutNameList = null;
	private String memInPreAuth = null;
	private String memOutPreAuth = null;
//	private String memInMemo = null;
	private String memOutMemo = null;
	private String memBillSampleInv = null;
	private String memInPolicySample = null;
	private String memOutPolicySample = null;
	private String memInDtlPro = null;
	private String memOutDtlPro = null;
	private String memHealthExam = null;
	private String memImmunization = null;
	private String memPrePostNatal = null;
	private String memOtherCoverageType = null;
	private String memOtherCoverage = null;
	private boolean tabSelect2 = false;

	private LabelBase arCodeSearchDesc = null;
//	private ComboARCompany arCodeSearch = null;
	private TextARCodeSimpleSearch arCodeSearch = null;
	private LabelBase cardPhotoDesc = null;
	private LabelBase cardPhotoAlert = null;
	private BasePanel cardPhotoFrame = null;
	private Image cardPhoto = null;

	private FieldSetBase arCardTypeInfoPanel = null;
	private LabelBase arCodeDesc = null;
	private TextReadOnly arCode = null;
	private LabelBase arNameDesc = null;
	private TextReadOnly arName = null;
	private LabelBase cardTypeCodeDesc = null;
	private TextString cardTypeCode = null;
	private LabelBase cardTypeDescriptionDesc = null;
	private TextString cardTypeDescription = null;
	private LabelBase colour1Desc = null;
//	private ComboARCardColour colour1 = null;
	private TextString colour1 = null;
	private LabelBase colour2Desc = null;
//	private ComboARCardColour colour2 = null;
	private TextString colour2 = null;
	private LabelBase effectiveDateDesc = null;
	private TextDate effectiveDate = null;
	private LabelBase terminationDateDesc = null;
	private TextDate terminationDate = null;
	private LabelBase activeDesc = null;
	private CheckBoxBase active = null;

	private TabbedPaneBase tabbedPanel = null;

	/* Billing Remark */
	private BasePanel billingPanel = null;
	private LabelBase eBillingDesc = null;
	private CheckBoxBase eBilling = null;
	private LabelBase sendOriginalBillsDesc = null;
	private CheckBoxBase sendOriginalBills = null;
	private LabelBase uploadToPortalDesc = null;
	private CheckBoxBase uploadToPortal = null;
	private LabelBase inpatientBillingRemarkDesc = null;
	private TextAreaBase inpatientBillingRemark = null;
	private LabelBase outpatientBillingRemarkDesc = null;
	private TextAreaBase outpatientBillingRemark = null;
	private ButtonBase sampleInvoiceButton = null;
	private LabelBase billingOtherDesc = null;
	private TextString billingOther = null;

	/* Contact Remark */
	private BasePanel contactPanel = null;
	private FieldSetBase contactFieldSet1 = null;
	private LabelBase contactPerson1Desc = null;
	private TextString contactPerson1 = null;
	private LabelBase contactPhoneNo1Desc = null;
	private TextString contactPhoneNo1 = null;
	private LabelBase contactFaxNo1Desc = null;
	private TextString contactFaxNo1 = null;
	private LabelBase contactEmail1Desc = null;
	private TextString contactEmail1 = null;
	private LabelBase operationHour1Desc = null;
	private TextString operationHour1 = null;
	private FieldSetBase contactFieldSet2 = null;
	private LabelBase contactPerson2Desc = null;
	private TextString contactPerson2 = null;
	private LabelBase contactPhoneNo2Desc = null;
	private TextString contactPhoneNo2 = null;
	private LabelBase contactFaxNo2Desc = null;
	private TextString contactFaxNo2 = null;
	private LabelBase contactEmail2Desc = null;
	private TextString contactEmail2 = null;
	private LabelBase operationHour2Desc = null;
	private TextString operationHour2 = null;
	private LabelBase inpatientContactRemarkDesc = null;
	private TextAreaBase inpatientContactRemark = null;
	private LabelBase outpatientContactRemarkDesc = null;
	private TextAreaBase outpatientContactRemark = null;

	/*Inpatient Tab*/
	private BasePanel inpatientPanel = null;
	private LabelBase inpatientRegistrationRemarkDesc = null;
	private TextAreaBase inpatientRegistrationRemark = null;
	private LabelBase inpatientPaymentRemarkDesc = null;
	private TextAreaBase inpatientPaymentRemark = null;
	private LabelBase inpatientExclusionsRemarkDesc = null;
	private TextAreaBase inpatientExclusionsRemark = null;
	private ButtonBase inpatientWebSiteAddressButton = null;
	private ButtonBase inpatientVoucherButton = null;
	private ButtonBase inpatientClaimFormLinkButton = null;
	private ButtonBase inpatientNameListCardorPolicySampleButton = null;
	private ButtonBase inpatientPreAuthorisationFormButton = null;
	private ButtonBase inpatientLogPASampleButton = null;
	private ButtonBase inpatientAcknowledgementAdmissionFormButton = null;
//	private ButtonBase inpatientPreAuthorisationMemoToDoctorButton = null;
	private ButtonBase inpatientExclusionsButton = null;
	private DlgGeneralExclusions generalExclusionsDialog = null;
	private ButtonBase inpatientGeneralExclusionsButton = null;
	private TableList inpatientGeneralExclusionsTableList = null;
	private LabelBase inpatientInsuranceOptionsDesc = null;
	private LabelBase inpatientGeneralExclusionsDesc = null;
	private ButtonBase inpatientInsuranceOptionsButton = null;
	private DlgInsuranceOptions insuranceOptionsDialog = null;
	private TableList inpatientInsuranceOptionsTableList = null;
	private ButtonBase inpatientDetailedProceduresButton = null;

	/*Outpatient Tab*/
	private BasePanel outpatientPanel = null;
	private LabelBase outpatientRegistrationRemarkDesc = null;
	private TextAreaBase outpatientRegistrationRemark = null;
	private LabelBase outpatientPaymentRemarkDesc = null;
	private TextAreaBase outpatientPaymentRemark = null;
	private LabelBase outpatientExclusionsRemarkDesc = null;
	private TextAreaBase outpatientExclusionsRemark = null;
	private ButtonBase outpatientWebSiteAddressButton = null;
	private ButtonBase outpatientVoucherButton = null;
	private ButtonBase outpatientNameListCardorPolicySampleButton = null;
	private ButtonBase outpatientPreAuthorisationFormButton = null;
//	private ButtonBase outpatientAcknowledgementAdmissionFormButton = null;
	private ButtonBase outpatientPreAuthorisationMemoToDoctorButton = null;
	private ButtonBase outpatientLogPASampleButton = null;
	private ButtonBase outpatientClaimFormLinkButton = null;
	private ButtonBase outpatientExclusionsButton = null;
	private ButtonBase outpatientGeneralExclusionsButton = null;
	private ButtonBase outpatientInsuranceOptionsButton = null;
	private LabelBase outpatientInsuranceOptionsDesc = null;
	private LabelBase outpatientGeneralExclusionsDesc = null;
	private TableList outpatientGeneralExclusionsTableList = null;
	private TableList outpatientInsuranceOptionsTableList = null;
	private LabelBase healthExamDesc = null;
	private ComboHealthExamCoverage healthExam = null;
	private LabelBase immunizationDesc = null;
	private ComboImmunizationCoverage immunization = null;
	private LabelBase prePostNatalDesc = null;
	private ComboPrePostNatal prePostNatal = null;
	private TextString otherCoverageType = null;
	private ComboOtherCoverage otherCoverage = null;
	private ButtonBase outpatientDetailedProceduresButton = null;

	/* Admin tab */
	private BasePanel adminPanel = null;
	private FieldSetBase adminFieldSetIp = null;
	private FieldSetBase adminFieldSetOp = null;
	private LabelBase webSiteUrlIpDesc = null;
	private TextString webSiteUrlIp = null;
	private LabelBase voucherUrlIpDesc = null;
	private TextString voucherUrlIp = null;
	private LabelBase claimFormUrlIpDesc = null;
	private TextString claimFormUrlIp = null;
	private LabelBase nameListUrlIpDesc = null;
	private TextString nameListUrlIp = null;
	private LabelBase acknowFormUrlIpDesc = null;
	private TextString acknowFormUrlIp = null;
	private LabelBase preAuthFormUrlIpDesc = null;
	private TextString preAuthFormUrlIp = null;
	private LabelBase paSampleUrlIpDesc = null;
	private TextString paSampleUrlIp = null;
	private LabelBase webSiteUrlOpDesc = null;
	private TextString webSiteUrlOp = null;
	private LabelBase voucherUrlOpDesc = null;
	private TextString voucherUrlOp = null;
	private LabelBase claimFormUrlOpDesc = null;
	private TextString claimFormUrlOp = null;
	private LabelBase nameListUrlOpDesc = null;
	private TextString nameListUrlOp = null;
	private LabelBase acknowFormUrlOpDesc = null;
	private TextString acknowFormUrlOp = null;
	private LabelBase preAuthFormUrlOpDesc = null;
	private TextString preAuthFormUrlOp = null;
	private TextString memoToDocUrlIp = null;
	private LabelBase memoToDocUrlIpDesc = null;
	private TextString memoToDocUrlOp = null;
	private LabelBase memoToDocUrlOpDesc = null;
	private TextString exclusionUrlIp = null;
	private LabelBase exclusionUrlIpDesc = null;
	private TextString exclusionUrlOp = null;
	private LabelBase exclusionUrlOpDesc = null;
	private TextString billSampInvUrl = null;
	private LabelBase billSampInvUrlDesc = null;
	private TextString paSampleUrlOp = null;
	private LabelBase paSampleUrlOpDesc = null;
	private TextString detailedProceduresIp = null;
	private LabelBase detailedProceduresIpDesc = null;
	private TextString detailedProceduresOp = null;
	private LabelBase detailedProceduresOpDesc = null;

	private DlgARCardTypeSel dlgARCardTypeSel = null;
	//private ComboImmunization

	public ARCardLink() {
		super();
	}

	@Override
	protected BasePanel getLeftPanel() {
		// TODO Auto-generated method stub
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.add(getArCodeSearchDesc(), null);
			leftPanel.add(getArCodeSearch(), null);
			leftPanel.add(getCardPhotoDesc(), null);
			leftPanel.add(getCardPhotoAlert(), null);
			leftPanel.add(getCardPhotoFrame(), null);
			leftPanel.add(getArCardTypeInfoPanel(), null);
			leftPanel.add(getTabbedPanel(), null);
		}
		return leftPanel;
	}

	@Override
	protected BasePanel getRightPanel() {
		// TODO Auto-generated method stub
		if (rightPanel == null) {
			rightPanel = new BasePanel();
		}
		return rightPanel;
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	protected boolean init() {
		// TODO Auto-generated method stub
		setNoGetDB(true);
		setLeftAlignPanel();
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		// TODO Auto-generated method stub
		initVariables();
		enableButton();
		adminOnly = !isDisableFunction("insCdAdmin", "insCd");
		getTabbedPanel().setSelectedIndexWithoutStateChange(4);
		getTabbedPanel().setSelectedIndexWithoutStateChange(3);
		getTabbedPanel().setSelectedIndexWithoutStateChange(2);
		getTabbedPanel().setSelectedIndexWithoutStateChange(1);
		getTabbedPanel().setSelectedIndexWithoutStateChange(0);

		getInpatientGeneralExclusionsTableList().getView().setSortingEnabled(false);

		String arcCode = getParameter("ArcCode");
		if (arcCode != null) {
			memArcCode = arcCode;
			getArCodeSearch().setText(arcCode);
		}

		String arcCardType = getParameter("ArcCardType");
		if (arcCardType != null) {
			memActID = arcCardType;
			getCardTypeCode().setText(memActID);
		}

		if (memArcCode != null && memArcCode.length() > 0 && memActID != null && memActID.length() > 0) {
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] {
							"arcardtype",
							"actcode, ACTDESC, ACTCODE",
							"actid = '" + memActID + "' and arccode = upper('" + memArcCode + "') and actactive = -1 order by ACTDESC"
					},
					new MessageQueueCallBack() {
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						String[] record = TextUtil.split(mQueue.getContentAsQueue(), TextUtil.LINE_DELIMITER);
						String[] fields = TextUtil.split(record[0]);
						getDlgARCardTypeSel().post(memArcCode, memActID, fields[0], fields[1], fields[2]);
					}
				}
			});
		} else if (memActID != null && memActID.length() > 0) {
			getDlgARCardTypeSel().showDialog(memArcCode, null, true);
		}
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public Component getDefaultFocusComponent() {
		return getArCodeSearch();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {
		// TODO Auto-generated method stub

	}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {
		// TODO Auto-generated method stub
	}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
		// TODO Auto-generated method stub

		boolean enabled = isModify();
		PanelUtil.setAllFieldsEditable(getAdminPanel(), adminOnly && enabled);
/*
		getWebsiteUrlIp().setEditable(enabled);
		getVoucherUrlIp().setEditable(enabled);
		getClaimFormUrlIp().setEditable(enabled);
		getNameListUrlIp().setEditable(enabled);
//		getAcknowFormUrlIp().setEditable(enabled);
		getPreAuthFormUrlIp().setEditable(enabled);
		getMemoToDocUrlIp().setEditable(enabled);
		getExclusionUrlIp().setEditable(enabled);
		getPaSampleUrlIp().setEditable(enabled);

		getWebsiteUrlOp().setEditable(enabled);
		getVoucherUrlOp().setEditable(enabled);
		getClaimFormUrlOp().setEditable(enabled);
		getNameListUrlOp().setEditable(enabled);
//		getAcknowFormUrlOp().setEditable(enabled);
		getPreAuthFormUrlOp().setEditable(enabled);
		getMemoToDocUrlOp().setEditable(enabled);
		getExclusionUrlOp().setEditable(enabled);
		getPaSampleUrlOp().setEditable(enabled);
*/
	}

	/* >>> ~13~ Set Disable Fields When Delete ButtonBase Is Clicked ====== <<< */
	@Override
	protected void deleteDisabledFields() {
		// TODO Auto-generated method stub
	}

	/* >>> ~14~ Set Browse Validation ===================================== <<< */
	@Override
	protected boolean browseValidation() {
		if (getArCodeSearch().getText().length() <= 0 || !getArCodeSearch().isValid()) {
			Factory.getInstance().addErrorMessage("Please select AR Company.", getArCodeSearch());
			return false;
		}
		return true;
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		// TODO Auto-generated method stub
		return null;
	}

	/* >>> ~15.1~ Set Browse Output Results =============================== <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {

	}

	/* >>> ~16~ Set Fetch Input Parameters ================================ <<< */
	@Override
	protected String[] getFetchInputParameters() {
		// TODO Auto-generated method stub
		return null;
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {
		// TODO Auto-generated method stub
	}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		// TODO Auto-generated method stub
		return new String[] {
			memActID,
			memArcCode,
			getInpatientRegistrationRemark().getText(), // ACTYPE.ACTREGRMKIP
			getOutpatientRegistrationRemark().getText(), // ACTYPE.ACTREGRMKOP
			getInpatientPaymentRemark().getText(), // ACTYPE.ACTPAYRMKIP
			getOutpatientPaymentRemark().getText(), // ACTYPE.ACTPAYRMKOP
			getWebsiteUrlIp().getText(), // ACTYPE.REGRMKIPURL
			getWebsiteUrlOp().getText(), // ACTYPE.REGRMKOPURL
			getCardTypeCode().getText(), // ARCARDTYPE.ACTCODE%TYPE,
			getCardTypeDescription().getText(), // ARCARDTYPE.ACTDESC%TYPE,
			getColour1().getText(),  // ACTYPE.COLOUR1
			getColour2().getText(), // ACTYPE.COLOUR2
			getExclusionUrlIp().getText(), // ACTERMIN.EXCLUSION
			getExclusionUrlOp().getText(), // ACTERMOUT.EXCLUSION
			getVoucherUrlIp().getText(), // ACTERMIN.VOUCHER
			getVoucherUrlOp().getText(), // ACTERMOUT.VOUCHER
			getClaimFormUrlIp().getText(), // ACTERMIN.CLAIM_FORM
			getClaimFormUrlOp().getText(), // ACTERMOUT.CLAIM_FORM
			getNameListUrlIp().getText(), // ACTERMIN.NAME_LIST
			getNameListUrlOp().getText(), // ACTERMOUT.NAME_LIST
			getPreAuthFormUrlIp().getText(), // ACTERMIN.PRE_AUTHORISE_FORM
			getPreAuthFormUrlOp().getText(), // ACTERMOUT.PRE_AUTHORISE_FORM
			getMemoToDocUrlIp().getText(), // ACTERMIN.PRE_AUTHORISATION_MEMO
			getMemoToDocUrlOp().getText(), // ACTERMOUT.PRE_AUTHORISATION_MEMO
			getInpatientContactRemark().getText(), // ACTERMIN.REMARKS
			getOutpatientContactRemark().getText(), // ACTERMIN.REMARKS
			getContactPerson1().getText(), // ACTERMIN.CONTACT_DETAILS
			getContactPerson2().getText(), // ACTERMOUT.CONTACT_DETAILS
			getContactPhoneNo1().getText(), // ACTERMIN.CONTACT_PHONE
			getContactPhoneNo2().getText(), // ACTERMOUT.CONTACT_PHONE
			getContactFaxNo1().getText(), // ACTERMIN.FAX AS CONTACTFAXIN
			getContactFaxNo2().getText(), // ACTERMOUT.FAX AS CONTACTFAXOUT
			getInpatientBillingRemark().getText(), // ACTERMIN.BILLREMARKS
			getOutpatientBillingRemark().getText(), //ACTERMOUT.BILLREMARKS
			geteBilling().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE, //ACTYPE.EBILLING
			getSendOriginalBills().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE, //ACTYPE.SENDORGINV
			getBillSampInvUrl().getText(), //ACTYPE.SAMPLEINV
			getInpatientExclusionsRemark().getText(), //ACTERMIN.EXCLUSIONREMARKS
			getOutpatientExclusionsRemark().getText(), //ACTERMOUT.EXCLUSIONREMARKS
			getContactEmail1().getText(), // ACTERMIN.CONTACT_EMAIL
			getContactEmail2().getText(), // ACTERMOUT.CONTACT_EMAIL
			getEffectiveDate().getText(), // ACTYPE.ARCARDSDATE
			getTerminationDate().getText(), // ACTYPE.ARCARDEDATE
			getActive().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE, //ACTYPE.ACTACTIVE
			getUploadToPortal().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE, //ACTYPE.UPLOADTOPORTAL
			getBillingOther().getText(), // ACTYPE.BILLINGOTHER,
			getPaSampleUrlIp().getText(), //ACTERMIN.POLICYSAMPLE
			getPaSampleUrlOp().getText(), //ACTERMOP.POLICYSAMPLE
			!memHealthExam.equals(getHealthExam().getText())&&tabSelect2?getHealthExam().getText():memHealthExam,
			!memImmunization.equals(getImmunization().getText())&&tabSelect2?getImmunization().getText():memImmunization,
			!memPrePostNatal.equals(getPrePostNatal().getText())&&tabSelect2?getPrePostNatal().getText():memPrePostNatal,
			!memOtherCoverageType.equals(getOtherCoverageType().getText())&&tabSelect2?getOtherCoverageType().getText():memOtherCoverageType,
			!memOtherCoverage.equals(getOtherCoverage().getText())&&tabSelect2?getOtherCoverage().getText():memOtherCoverage,
			getOperationHour1().getText(),
			getOperationHour2().getText(),
			getAcknowFormUrlIp().getText(), //ACTERMIN.ACKNOWLEDGE_FORM
			getDetailedProceduresIp().getText(),
			getDetailedProceduresOp().getText()
		};
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(final String actionType) {
		if (getCardTypeCode().isEmpty()) {
			Factory.getInstance().addErrorMessage("Card ID cannot empty.", getCardTypeCode());
			actionValidationReady(actionType, false);
			return;
		} else {
			actionValidationReady(actionType, true);
		}
	}

	@Override
	protected void actionValidationReady(final String actionType, final boolean isValidationReady) {
		if (isValidationReady) {
				//getMainFrame().setLoading(true);
				QueryUtil.executeMasterAction(getUserInfo(), getTxCode(), getActionType(),
						getActionInputParamaters(),
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							Factory.getInstance().addInformationMessage("Card Save Succeed.");
							resetActionType();
							searchAction(false);
						} else {
							Factory.getInstance().addInformationMessage("Card Save Fail.");
						}
					}
				});
		}
	}

	@Override
	public void appendAction() {
		super.appendAction();
		memActID = EMPTY_VALUE;
		mdmARCardName = EMPTY_VALUE;

		getCardTypeCode().resetText();
		getColour1().resetText();
		getColour2().resetText();
		getCardTypeDescription().resetText();
		getEffectiveDate().resetText();
		getTerminationDate().resetText();
		getActive().setSelected(false);
		cardPhoto.setUrl(Factory.getInstance().getPhotoIsNotAvilableImg());
		getInpatientInsuranceOptionsButton().setEnabled(false);
		getOutpatientInsuranceOptionsButton().setEnabled(false);
		getInpatientGeneralExclusionsButton().setEnabled(false);
		getOutpatientGeneralExclusionsButton().setEnabled(false);

	String arCodeReadOnly = getArCode().getText();
	if (arCodeReadOnly==null || arCodeReadOnly.length()==0) {
			String arccode = arCodeSearch.getText().trim().toUpperCase();
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] {"arcode", "arccode, arcname", "arccode = '" + arccode + "'"},
					new MessageQueueCallBack() {
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						memArcCode = mQueue.getContentField()[0];
						getArCode().setText(memArcCode);
						getArName().setText(mQueue.getContentField()[1]);
					}
				}
			});
	}
	};

	@Override
	public void appendPostAction() {
		setAllLeftFieldsEnabled(true);
	};

	@Override
	public void deleteAction() {
		super.deleteAction();
		Factory.getInstance().isConfirmYesNoDialog("Confirm delete?",
				new Listener<MessageBoxEvent>() {
			@Override
			public void handleEvent(MessageBoxEvent be) {
				if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
					QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] {"SLIP", "COUNT(1)", "ACTID = '" + memActID + "'"},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								if ("0".equals(mQueue.getContentField()[0])) {
									//getMainFrame().setLoading(true);
									QueryUtil.executeMasterAction(getUserInfo(), getTxCode(), getActionType(),
											getActionInputParamaters(),
											new MessageQueueCallBack() {
										@Override
										public void onPostSuccess(MessageQueue mQueue) {
											if (mQueue.success()) {
												resetActionType();
												enableButton();
												clearAction();
												Factory.getInstance().addInformationMessage("Card Delete Succeed.");
											} else {
												Factory.getInstance().addInformationMessage("Card Delete Failed.");
											}
										}
									});
								} else {
									Factory.getInstance().addInformationMessage("This card is already in use, cannot delete!");
								}
							}
						}
					});
				}
			}
		});
	}

	@Override
	public void clearAction() {
			resetCurrentFields();

			// clear record found
			setRecordFound(false);

			enableButton();

			// call focus component
			defaultFocus();
	}

	@Override
	public void searchAction(boolean showDialog) {
		if (browseValidation()) {
			if (!showDialog) {
				if (getCardTypeCode().getText() != null && memActID != null) {
					QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] {
									"arcardtype",
									"actid",
									"UPPER(ACTCODE) = UPPER('" + getCardTypeCode().getText() + "')"
							},
							new MessageQueueCallBack() {
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								memActID = mQueue.getContentField()[0];
							}
						}
					});
				}
			}

			enableButton();
			if (showDialog) {
				if (adminOnly) {
					getDlgARCardTypeSel().showDialog(getArCodeSearch().getText(), null, false);
				} else {
					getDlgARCardTypeSel().showDialog(getArCodeSearch().getText(), null, true);
				}
			}
		}
		performList(false);
	}

	@Override
	protected void enableButton(String mode) {
		disableButton();
		getSearchButton().setEnabled(!isModify() && !isAppend() && !isDelete());
		getModifyButton().setEnabled(!isModify() && !isAppend() && !isDelete() && getArCode().getText().length() > 0 && adminOnly);
		getDeleteButton().setEnabled(!isModify() && !isAppend() && !isDelete() && getArCode().getText().length() > 0 && adminOnly);
		getAppendButton().setEnabled(!isModify() && !isAppend() && !isDelete() && getArCode().getText().length() > 0 && adminOnly &&
				((memActID == null && getCardTypeCode().isEmpty()) || (getCardTypeCode().getText() != null && memActID != null)));
//		getAcceptButton().setEnabled(isAppend() || (isModify() && memActID != null && memActID.length() > 0));
		getSaveButton().setEnabled(isAppend() || (isModify() && memActID != null && memActID.length() > 0));
		getCancelButton().setEnabled(isModify() || isAppend());
		//setAllLeftFieldsEnabled(false);

		if (isAppend()) {
			// empty entry panel content
			emptyAllRightPanelFields();
		}
		// enable all right panel field
		setAllLeftFieldsEnabled(isAppend() || isModify());
		bottonControlbByURL();

		if (adminOnly) {
			getInpatientGeneralExclusionsButton().setEnabled(adminOnly);
			getOutpatientGeneralExclusionsButton().setEnabled(adminOnly);
			getInpatientInsuranceOptionsButton().setEnabled(adminOnly);
			getOutpatientInsuranceOptionsButton().setEnabled(adminOnly);
		} else {
			getInpatientGeneralExclusionsButton().setEnabled(false);
			getOutpatientGeneralExclusionsButton().setEnabled(false);
			getInpatientInsuranceOptionsButton().setEnabled(false);
			getOutpatientInsuranceOptionsButton().setEnabled(false);
		}

		getInpatientGeneralExclusionsTableList().setEnabled(true);
		getOutpatientGeneralExclusionsTableList().setEnabled(true);
		getInpatientInsuranceOptionsTableList().setEnabled(true);
		getOutpatientInsuranceOptionsTableList().setEnabled(true);

		getArCodeSearch().setEnabled(!isModify() && !isAppend());

/*
		if (!adminOnly) {
			getAdminFieldSetIp().setEnabled(false);
			getAdminFieldSetOp().setEnabled(false);
			getBillSampInvUrl().setEnabled(false);
		}
*/
	}

	@Override
	public void proExitPanel() {
		resetCurrentFields();
	}

	@Override
	public void resetCurrentFields() {
		memPre_ArcCode = EMPTY_VALUE;
		memArcCode = EMPTY_VALUE;
		memActID = EMPTY_VALUE;
		mdmARCardName = EMPTY_VALUE;
		PanelUtil.resetAllFields(getLeftPanel());
		cardPhoto.setUrl(Factory.getInstance().getPhotoIsNotAvilableImg());
	}

	private void initVariables() {
		resetCurrentFields();
	}


	private void showCardDetail(String arCardNo) {
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.EHR_PMI_TXCODE,
				new String[] { arCardNo },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					if (mQueue.getContentField()[0] == null) {

					}
				}
			}
		});
	}

	private void setARValue(final String arcode) {
		QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.AR_COMPANY_TXCODE,
				new String[] { arcode },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success() && mQueue.getContentLineCount() > 0) {
					// get first return value and assign to district
					String[] outParam = mQueue.getContentField();
					memArcCode = outParam[0];
					getArCodeSearch().setText(outParam[0]);
					getArCode().setText(outParam[0]);
					getArName().setText(outParam[1]);
					getCardTypeDescription().setText(outParam[1]);
					setAllowEntryAR();
				} else {
					Factory.getInstance().addErrorMessage("AR Code does not exist.", getArCodeSearch());
					getArName().resetText();
					getCardTypeDescription().resetText();
					getArCodeSearch().resetText();
					getArCodeSearch().resetText();
					setAllowEntryAR();
				}
			}
		});
	}

	private void setAllowEntryAR() {
		boolean enabled = false;
		String arblockevt = Factory.getInstance().getSysParameter("ArBlockEvt");

		if (Factory.getInstance().getSysParameter("ArBlockEvt").length() > 0) {
			if (isAppend() || isModify() || !EMPTY_VALUE.equals(getArCodeSearch().getText())) {
				enabled = true;
			}
		}
	}

	private void resetAllowEntryAR() {
		getArCodeSearch().resetText();
		getArCode().resetText();
		getArName().resetText();
		getCardTypeCode().resetText();
		getCardTypeDescription().resetText();
		getColour1().resetText();
		getColour2().resetText();
	}

	private void bottonControlbByURL() {
		if (memIpUrl != null && memIpUrl.length() > 0) {
			getInpatientWebSiteAddressButton().setEnabled(true);
		} else {
			getInpatientWebSiteAddressButton().setEnabled(false);
		}
		if (memOpUrl != null && memOpUrl.length() > 0) {
			getOutpatientWebSiteAddressButton().setEnabled(true);
		} else {
			getOutpatientWebSiteAddressButton().setEnabled(false);
		}

		if (memInpExclu != null && memInpExclu.length() > 0) {
			getInpatientExclusionsButton().setEnabled(true);
		} else {
			getInpatientExclusionsButton().setEnabled(false);
		}
		if (memOutExclu != null && memOutExclu.length() > 0) {
			getOutpatientExclusionsButton().setEnabled(true);
		} else {
			getOutpatientExclusionsButton().setEnabled(false);
		}

		if (memInVouch != null && memInVouch.length() > 0) {
			getInpatientVoucherButton().setEnabled(true);
		} else {
			getInpatientVoucherButton().setEnabled(false);
		}
		if (memOutVouch != null && memOutVouch.length() > 0) {
			getOutpatientVoucherButton().setEnabled(true);
		} else {
			getOutpatientVoucherButton().setEnabled(false);
		}

		if (memInClaim != null && memInClaim.length() > 0) {
			getInpatientClaimFormLinkButton().setEnabled(true);
		} else {
			getInpatientClaimFormLinkButton().setEnabled(false);
		}
		if (memOutClaim != null && memOutClaim.length() > 0) {
			getOutpatientClaimFormLinkButton().setEnabled(true);
		} else {
			getOutpatientClaimFormLinkButton().setEnabled(false);
		}

		if (memInNameList != null && memInNameList.length() > 0) {
			getInpatientNameListCardorPolicySampleButton().setEnabled(true);
		} else {
			getInpatientNameListCardorPolicySampleButton().setEnabled(false);
		}
		if (memOutNameList != null && memOutNameList.length() > 0) {
			getOutpatientNameListCardorPolicySampleButton().setEnabled(true);
		} else {
			getOutpatientNameListCardorPolicySampleButton().setEnabled(false);
		}

		if (memInPreAuth != null && memInPreAuth.length() > 0) {
			getInpatientPreAuthorisationFormButton().setEnabled(true);
		} else {
			getInpatientPreAuthorisationFormButton().setEnabled(false);
		}
		if (memOutPreAuth != null && memOutPreAuth.length() > 0) {
			getOutpatientPreAuthorisationFormButton().setEnabled(true);
		} else {
			getOutpatientPreAuthorisationFormButton().setEnabled(false);
		}

		if (memOutMemo != null && memOutMemo.length() > 0) {
			getOutpatientPreAuthorisationMemoToDoctorButton().setEnabled(true);
		} else {
			getOutpatientPreAuthorisationMemoToDoctorButton().setEnabled(false);
		}

		if (memInPolicySample != null && memInPolicySample.length() > 0) {
			getInpatientLogPASampleButton().setEnabled(true);
		} else {
			getInpatientLogPASampleButton().setEnabled(false);
		}
		if (memOutPolicySample != null && memOutPolicySample.length() > 0) {
			getOutpatientLogPASampleButton().setEnabled(true);
		} else {
			getOutpatientLogPASampleButton().setEnabled(false);
		}

		if (memInAcknowForm != null && memInAcknowForm.length() > 0) {
			getInpatientAcknowledgementAdmissionFormButton().setEnabled(true);
		} else {
			getInpatientAcknowledgementAdmissionFormButton().setEnabled(false);
		}

		if (memBillSampleInv != null && memBillSampleInv.length() > 0) {
			getSampleInvoiceButton().setEnabled(true);
		} else {
			getSampleInvoiceButton().setEnabled(false);
		}

		if (memBillSampleInv != null && memBillSampleInv.length() > 0) {
			getSampleInvoiceButton().setEnabled(true);
		} else {
			getSampleInvoiceButton().setEnabled(false);
		}

		if (memInDtlPro != null && memInDtlPro.length() > 0) {
			getInpatientDetailedProceduresButton().setEnabled(true);
		} else {
			getInpatientDetailedProceduresButton().setEnabled(false);
		}

		if (memOutDtlPro != null && memOutDtlPro.length() > 0) {
			getOutpatientDetailedProceduresButton().setEnabled(true);
		} else {
			getOutpatientDetailedProceduresButton().setEnabled(false);
		}
	}

	private String getImageNotFound() {
		if (imageNotFoundUrl == null) {
			imageNotFoundUrl = SERVER_PATH_PREFIX + Factory.getInstance().getSysParameter("PORTALURL") + SERVER_PATH_NO_IMAGE_SUFFIX;
		}
		return imageNotFoundUrl;
	}

	private String getServerPathURL() {
		if (serverPathUrl == null) {
			serverPathUrl = SERVER_PATH_PREFIX + Factory.getInstance().getSysParameter("PORTALURL") + SERVER_PATH_SUFFIX;
		}
		return serverPathUrl;
	}

	private String getOpenFileURL() {
		if (openFileUrl == null) {
			openFileUrl = SERVER_PATH_PREFIX + Factory.getInstance().getSysParameter("PORTALURL") + OPENFILE_SUFFIX;
		}
		return openFileUrl;
	}

	private String getEnargePhotoURL() {
		if (enlargePhotoUrl == null) {
			enlargePhotoUrl = SERVER_PATH_PREFIX + Factory.getInstance().getSysParameter("PORTALURL") + ENLARGEPHOTO_SUFFIX;
		}
		return enlargePhotoUrl;
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/**
	 * @return the arCodeSearchDesc
	 */
	private LabelBase getArCodeSearchDesc() {
		if (arCodeSearchDesc == null) {
			arCodeSearchDesc = new LabelBase();
			arCodeSearchDesc.setText("AR Code");
			arCodeSearchDesc.setBounds(5, 5, 60, 20);
		}
		return arCodeSearchDesc;
	}

	/**
	 * @return the arCodeSearch
	 */

	public TextARCodeSimpleSearch getArCodeSearch() {
		if (arCodeSearch == null) {
			arCodeSearch = new TextARCodeSimpleSearch(adminOnly?"0":"-1") {
				@Override
				public void checkTriggerBySearchKey() {
					if (isFocusOwner()) {
						showSearchPanel();
						resetText();
					}
				}

				@Override
				public void onBlur() {
					if (arCodeSearch.getText().trim().length() > 0) {
						arCodeSearch.setText(arCodeSearch.getText().trim().toUpperCase());
					//	showInfo();
					}
				}

				@Override
				public void onTab() {
					if (arCodeSearch.getText().trim().length() > 0) {
						final String arccode = arCodeSearch.getText().trim().toUpperCase();
//						arCodeSearch.setText(arccode);

						QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
								new String[] {"arcode", "arccode", "arccode = '" + arccode + "'"},
								new MessageQueueCallBack() {
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									if (adminOnly) {
										getDlgARCardTypeSel().showDialog(arccode, memActID, false, false);
									} else {
										getDlgARCardTypeSel().showDialog(arccode, memActID, true, false);
									}
								} else {
									Factory.getInstance().addErrorMessage("AR code not exist!",arCodeSearch);
								}
							}
						});
					}
				}

				@Override
				public void onReleased() {
					if (memArcCode != null && memArcCode.length() > 0 && !memArcCode.equals(getText())) {
						String originalArcCode = null;
						if (getText().length() > memArcCode.length()) {
							originalArcCode = getText().substring(memArcCode.length());
						}

						resetCurrentFields();
						if (originalArcCode != null) {
							setText(originalArcCode);
						}
					}
				}

				@Override
				public void post(String ArcCode, final String ARCardType, String ARCardName,
						String ARCardDesc, String ARCardCode) {
					setCardPhotoHelper(getCardPhoto(), getCardPhotoFrame(), ARCardName);
					getArCode().setText(ArcCode);
					memArcCode = ArcCode;
		//			getArName().setText(ARCardName);
					QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] {"arcode", "ARCNAME", "arccode = '" + memArcCode + "'"},
							new MessageQueueCallBack() {
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								getArName().setText(mQueue.getContentField()[0]);
							}
						}
					});
					getCardTypeCode().setText(ARCardName);
					getCardTypeDescription().setText(ARCardDesc);
					getArCodeSearch().setText(ArcCode);
					memActID = ARCardType;
					mdmARCardName = ARCardName;

					QueryUtil.executeMasterBrowse(getUserInfo(), "ARCARDLINKDTL",
							new String[] { ARCardType },
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								getInpatientRegistrationRemark().setText(mQueue.getContentField()[0]); // ACTYPE.ACTREGRMKIP
								getOutpatientRegistrationRemark().setText(mQueue.getContentField()[1]); // ACTYPE.ACTREGRMKOP
								getInpatientPaymentRemark().setText(mQueue.getContentField()[2]); // ACTYPE.ACTPAYRMKIP
								getOutpatientPaymentRemark().setText(mQueue.getContentField()[3]); // ACTYPE.ACTPAYRMKOP
								memIpUrl = mQueue.getContentField()[4]; // ACTYPE.REGRMKIPURL
								memOpUrl = mQueue.getContentField()[5]; // ACTYPE.REGRMKOPURL

								if (memIpUrl != null && memIpUrl.length() > 0) {
									getWebsiteUrlIp().setText(memIpUrl);
								} else {
									getWebsiteUrlIp().setText(memIpUrl);
									getInpatientWebSiteAddressButton().setEnabled(false);
								}
								if (memOpUrl != null && memOpUrl.length() > 0) {
									getWebsiteUrlOp().setText(memOpUrl);
								} else {
									getWebsiteUrlOp().setText(memOpUrl);
									getOutpatientWebSiteAddressButton().setEnabled(false);
								}
								memInpExclu = mQueue.getContentField()[8]; // ACTERMIN.EXCLUSION AS EXCLUSIN
								memOutExclu = mQueue.getContentField()[9]; // ACTERMOUT.EXCLUSION AS EXCLUSOUT
								if (memInpExclu != null && memInpExclu.length() > 0) {
									getExclusionUrlIp().setText(memInpExclu);
								} else {
									getExclusionUrlIp().setText(memInpExclu);
									getInpatientExclusionsButton().setEnabled(false);
								}
								if (memOutExclu != null && memOutExclu.length() > 0) {
									getExclusionUrlOp().setText(memOutExclu);
								} else {
									getExclusionUrlOp().setText(memOutExclu);
									getOutpatientExclusionsButton().setEnabled(false);
								}
								memInVouch = mQueue.getContentField()[10]; // ACTERMIN.VOUCHER AS VOUCHERIN,
								memOutVouch = mQueue.getContentField()[11]; // ACTERMOUT.VOUCHER AS VOUCHEROUT,
								if (memInVouch != null && memInVouch.length() > 0) {
									getVoucherUrlIp().setText(memInVouch);
								} else {
									getVoucherUrlIp().setText(memInVouch);
									getInpatientVoucherButton().setEnabled(false);
								}
								if (memOutVouch != null && memOutVouch.length() > 0) {
									getVoucherUrlOp().setText(memOutVouch);
								} else {
									getVoucherUrlOp().setText(memOutVouch);
									getOutpatientVoucherButton().setEnabled(false);
								}
								memInClaim = mQueue.getContentField()[12]; // ACTERMIN.CLAIM_FORM AS CLAIMIN,
								memOutClaim = mQueue.getContentField()[13]; // ACTERMOUT.CLAIM_FORM AS CLAIMOUT,
								if (memInClaim != null && memInClaim.length() > 0) {
									getClaimFormUrlIp().setText(memInClaim);
								} else {
									getClaimFormUrlIp().setText(memInClaim);
									getInpatientClaimFormLinkButton().setEnabled(false);
								}
								if (memOutClaim != null && memOutClaim.length() > 0) {
									getClaimFormUrlOp().setText(memOutClaim);
								} else {
									getClaimFormUrlOp().setText(memOutClaim);
									getOutpatientClaimFormLinkButton().setEnabled(false);
								}
								memInNameList = mQueue.getContentField()[14]; // ACTERMIN.NAME_LIST AS NAMELISTIN,
								memOutNameList = mQueue.getContentField()[15]; // ACTERMOUT.NAME_LIST AS NAMELISTOUT,
								if (memInNameList != null && memInNameList.length() > 0) {
									getNameListUrlIp().setText(memInNameList);
								} else {
									getNameListUrlIp().setText(memInNameList);
									getInpatientNameListCardorPolicySampleButton().setEnabled(false);
								}
								if (memOutNameList != null && memOutNameList.length() > 0) {
									getNameListUrlOp().setText(memOutNameList);
								} else {
									getNameListUrlOp().setText(memOutNameList);
									getOutpatientNameListCardorPolicySampleButton().setEnabled(false);
								}
								memInPreAuth = mQueue.getContentField()[16]; // ACTERMIN.PRE_AUTHORISE_FORM AS PREAUTHIN,
								memOutPreAuth = mQueue.getContentField()[17]; // ACTERMOUT.PRE_AUTHORISE_FORM AS PREAUTHOUT,
								if (memInPreAuth != null && memInPreAuth.length() > 0) {
									getPreAuthFormUrlIp().setText(memInPreAuth);
								} else {
									getPreAuthFormUrlIp().setText(memInPreAuth);
									getInpatientPreAuthorisationFormButton().setEnabled(false);
								}
								if (memOutPreAuth != null && memOutPreAuth.length() > 0) {
									getPreAuthFormUrlOp().setText(memOutPreAuth);
								} else {
									getPreAuthFormUrlOp().setText(memOutPreAuth);
									getOutpatientPreAuthorisationFormButton().setEnabled(false);
								}
//								memInMemo = mQueue.getContentField()[18]; // ACTERMIN.PRE_AUTHORISATION_MEMO AS MEMEOIN,
								memOutMemo = mQueue.getContentField()[19]; // ACTERMOUT.PRE_AUTHORISATION_MEMO AS MEMOOUT,
								if (memOutMemo != null && memOutMemo.length() > 0) {
									getMemoToDocUrlOp().setText(memOutMemo);
								} else {
									getMemoToDocUrlOp().setText(memOutMemo);
									getOutpatientPreAuthorisationMemoToDoctorButton().setEnabled(false);
								}
								getInpatientContactRemark().setText(mQueue.getContentField()[20]); // ACTERMIN.REMARKS AS CONTACTRMKIN,
								getOutpatientContactRemark().setText(mQueue.getContentField()[21]); // ACTERMIN.REMARKS AS CONTACTRMKOUT,
								getContactPerson1().setText(mQueue.getContentField()[22]); // ACTERMIN.CONTACT_DETAILS AS CONTACTDTLIN,
								getContactPerson2().setText(mQueue.getContentField()[23]); // ACTERMOUT.CONTACT_DETAILS AS CONTACTDTLOUT,
								getContactPhoneNo1().setText(mQueue.getContentField()[24]); // ACTERMIN.CONTACT_PHONE AS CONTACTPHONEIN,
								getContactPhoneNo2().setText(mQueue.getContentField()[25]); // ACTERMOUT.CONTACT_PHONE AS CONTACTPHONEOUT,
								getContactFaxNo1().setText(mQueue.getContentField()[26]); // ACTERMIN.FAX AS CONTACTFAXIN,
								getContactFaxNo2().setText(mQueue.getContentField()[27]); // ACTERMOUT.FAX AS CONTACTFAXOUT
								getInpatientBillingRemark().setText(mQueue.getContentField()[28]); // ACTERMIN.BILLREMARKS AS BILLRMKIP
								getOutpatientBillingRemark().setText(mQueue.getContentField()[29]); //ACTERMOUT.BILLREMARKS AS BILLRMKOP
								geteBilling().setSelected(MINUS_ONE_VALUE.equals(mQueue.getContentField()[30])); //ACTYPE.EBILLING
								getSendOriginalBills().setSelected(MINUS_ONE_VALUE.equals(mQueue.getContentField()[31])); //ACTYPE.SENDORGINV
								memBillSampleInv = mQueue.getContentField()[32]; //ACTYPE.SAMPLEINV
								if (memBillSampleInv != null && memBillSampleInv.length() > 0) {
									getBillSampInvUrl().setText(memBillSampleInv);
								} else {
									getBillSampInvUrl().setText(memBillSampleInv);
									getSampleInvoiceButton().setEnabled(false);
								}
								getInpatientExclusionsRemark().setText(mQueue.getContentField()[33]); //ACTERMIN.EXCLUSIONREMARKS
								getOutpatientExclusionsRemark().setText(mQueue.getContentField()[34]); //ACTERMOUT.EXCLUSIONREMARKS
								getContactEmail1().setText(mQueue.getContentField()[35]); // ACTERMIN.CONTACT_EMAIL
								getContactEmail2().setText(mQueue.getContentField()[36]); // ACTERMOUT.CONTACT_EMAIL
								getEffectiveDate().setText(mQueue.getContentField()[37]); // ACTYPE.ARCARDSDATE
								getTerminationDate().setText(mQueue.getContentField()[38]); // ACTYPE.ARCARDEDATE
								getActive().setSelected(MINUS_ONE_VALUE.equals(mQueue.getContentField()[39])); //ACTYPE.ACTACTIVE
								getUploadToPortal().setSelected(MINUS_ONE_VALUE.equals(mQueue.getContentField()[40])); //ACTYPE.UPLOADTOPORTAL
								getBillingOther().setText(mQueue.getContentField()[41]); //ACTYPE.BILLINGOTHER
								memInPolicySample = mQueue.getContentField()[42]; //ACTERMIN.POLICYSAMPLE
								memOutPolicySample = mQueue.getContentField()[43]; //ACTERMOP.POLICYSAMPLE
								getOperationHour1().setText(mQueue.getContentField()[44]);  //ACTERMIN.OFC_HOUR
								getOperationHour2().setText(mQueue.getContentField()[45]); //ACTERMIN.OFC_HOUR

								if (memInPolicySample != null && memInPolicySample.length() > 0) {
									getPaSampleUrlIp().setText(memInPolicySample);
								} else {
									getPaSampleUrlIp().setText(memInPolicySample);
									getInpatientLogPASampleButton().setEnabled(false);
								}
								if (memOutPolicySample != null && memOutPolicySample.length() > 0) {
									getPaSampleUrlOp().setText(memOutPolicySample);
								} else {
									getPaSampleUrlOp().setText(memOutPolicySample);
									getOutpatientLogPASampleButton().setEnabled(false);
								}
								memInAcknowForm = mQueue.getContentField()[46]; // ACTERMIN.ACKNOWLEDGE_FORM AS ACKNOWIN,
//								memOutAcknowForm = mQueue.getContentField()[47]; // ACTERMOUT.ACKNOWLEDGE_FORM AS ACKNOWOUT,
								if (memInAcknowForm != null && memInAcknowForm.length() > 0) {
									getAcknowFormUrlIp().setText(memInAcknowForm);
								} else {
									getAcknowFormUrlIp().setText(memInAcknowForm);
									getInpatientAcknowledgementAdmissionFormButton().setEnabled(false);
								}
//								getAcknowFormUrlOp().setText(memOutAcknowForm);

								memInDtlPro= mQueue.getContentField()[47]; //ACTERMOP.DTL_PROCEDURES
								if (memInDtlPro != null && memInDtlPro.length() > 0) {
									getDetailedProceduresIp().setText(memInDtlPro);
								} else {
									getDetailedProceduresIp().setText(memInDtlPro);
									getInpatientDetailedProceduresButton().setEnabled(false);
								}

								memOutDtlPro= mQueue.getContentField()[48]; //ACTERMOP.DTL_PROCEDURES
								if (memOutDtlPro != null && memOutDtlPro.length() > 0) {
									getDetailedProceduresOp().setText(memOutDtlPro);
								} else {
									getDetailedProceduresOp().setText(memOutDtlPro);
									getOutpatientDetailedProceduresButton().setEnabled(false);
								}

								bottonControlbByURL();

								String colour1 = mQueue.getContentField()[6]; // ACTYPE.COLOUR1
								if (!(colour1==null)) {
									getColour1().setText(colour1);
								}

								String colour2 = mQueue.getContentField()[7]; // ACTYPE.COLOUR2
								if (!(colour2==null)) {
									getColour2().setText(colour2);
								}

								QueryUtil.executeMasterBrowse(getUserInfo(), "ARCOVERAGE",
										new String[] { ARCardType },
										new MessageQueueCallBack() {
									@Override
									public void onPostSuccess(MessageQueue mQueue) {
										if (mQueue.success()) {
											memHealthExam = mQueue.getContentField()[2];
											memImmunization = mQueue.getContentField()[3];
											memPrePostNatal = mQueue.getContentField()[4];
											memOtherCoverageType = mQueue.getContentField()[5];
											memOtherCoverage = mQueue.getContentField()[6];

											getHealthExam().setText(memHealthExam); //COV.HEALTHTEXT,
											getImmunization().setText(memImmunization); //COV.IMMUNIZATIONTEXT,
											getPrePostNatal().setText(memPrePostNatal); //COV.PRENATALTEXT,
											getOtherCoverageType().setText(memOtherCoverageType); //COV.COVERATE,
											getOtherCoverage().setText(memOtherCoverage); //COV.WBTEXT
										}
									}
								});

								// set general exclusive
								getOutpatientGeneralExclusionsTableList().setListTableContent("AREXCLUSIONSLIST", new String[] {ARCardType});
								getOutpatientInsuranceOptionsTableList().setListTableContent("ARCHECKLISTLIST", new String[] {ARCardType,"Out",null});
								getInpatientGeneralExclusionsTableList().setListTableContent("AREXCLUSIONSLIST", new String[] {ARCardType});
								getInpatientInsuranceOptionsTableList().setListTableContent("ARCHECKLISTLIST", new String[] {ARCardType,"In",null});
							} else {
								getColour1().setText(null);
								getColour2().setText(null);
							}
						}
					});

					enableButton();
					getAppendButton().setEnabled(adminOnly);

					/*
					if (ARCardType != null && ARCardType.trim().length() > 0) {
						memActID = ARCardType;
					} else {
						memActID = EMPTY_VALUE;
					}
					getRightJText_ARCardType().setText(ARCardName);

					if (memActID.length() > 0) {
						getDlgARCardRemark().showDialog(null, ArcCode, memActID, slipType, true, true);
					} else {
						getRightJText_PolicyNo().focus();
					}
					*/
				}

			};
			arCodeSearch.setBounds(90, 10, 103, 20);
		 }
		return arCodeSearch;
	}
/*
	private ComboARCompany getArCodeSearch() {
		if (arCodeSearch == null) {
			arCodeSearch = new ComboARCompany() {
				@Override
				protected String getTxFrom() {
					return "ArCardLink";
				}

				@Override
				protected String getTxDate() {
						return null;
				}

				@Override
				protected void onPressed(FieldEvent fe) {
					if (fe.getKeyCode() == KeyCodes.KEY_TAB) {
						final String arccode = getText();
						if (findModelByKey(arccode, true) == null) {
							resetText();
							return;
						}

						setAllowEntryAR();

						if (Factory.getInstance().getSysParameter("ArBlockEvt").length() > 0 &&
								(Factory.getInstance().getSysParameter("ArBlockEvt").equals(getText()))) {
							return;
						}

						if (!isEmpty()) {
							setARValue(getText());
						} else {
							resetAllowEntryAR();
						}

						if (!isShowPopUp) {
							QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
									new String[] {"ARCARDTYPE", "COUNT(1)", "arccode = upper('" + arccode + "') and actactive = -1"},
									new MessageQueueCallBack() {
								@Override
								public void onPostSuccess(MessageQueue mQueue) {
									if (mQueue.success()) {
										if (!arccode.equals(memArcCode)) {
											memActID = ConstantsVariable.EMPTY_VALUE;
											getCardTypeDescription().resetText();
										}
										getDlgARCardTypeSel().showDialog(arccode, memActID, false);
									} else {
										memActID = ConstantsVariable.EMPTY_VALUE;
										getCardTypeDescription().resetText();
//										getRightJText_PolicyNo().focus();
									}
								}
							});
						}
					}
				}

				@Override
				protected void clearPostAction() {
//					resetAllowEntryAR();
				setAllowEntryAR();
				}

				@Override
				public void setText(String key, boolean allowUpdate) {
					super.setText(key, allowUpdate);
					setAllowEntryAR();
				}
			};
			arCodeSearch.setBounds(90, 5, 200, 20);
		}
		return arCodeSearch;
	}
*/
	/**
	 * @return the cardPhotoDesc
	 */
	private LabelBase getCardPhotoDesc() {
		if (cardPhotoDesc == null) {
			cardPhotoDesc = new LabelBase();
			cardPhotoDesc.setText("<b>Card Photo</b>");
			cardPhotoDesc.setBounds(620, 5, 100, 20);
		}
		return cardPhotoDesc;
	}

	private LabelBase getCardPhotoAlert() {
		if (cardPhotoAlert == null) {
			cardPhotoAlert = new LabelBase();
			cardPhotoAlert.setText("<font color='red'>Please click to enlarge</font>");
			cardPhotoAlert.setBounds(730, 5, 200, 20);
		}
		return cardPhotoAlert;
	}

	/**
	 * @return the cardPhotoFrame
	 */
	private BasePanel getCardPhotoFrame() {
		if (cardPhotoFrame == null) {
			cardPhotoFrame = new BasePanel();
			cardPhotoFrame.setBounds(620, 25, 240, 155);
			cardPhotoFrame.setBorders(true);
			cardPhotoFrame.add(getCardPhoto());
			cardPhotoFrame.addListener(Events.OnClick, new Listener<ComponentEvent>() {
			    @Override
			    public void handleEvent(ComponentEvent be) {
					// TODO Auto-generated method stub
					String arName = getArName().getText();
					if (arName!=null && arName.length() > 0) {
//						String redirectPath = "../documentManage/download.jsp?locationPath="+"\\\\160.100.1.10\\CardPhoto\\"+"&dispositionType=inline&intranetPathYN=Y&#view=FitH";
						openNewWindow(getEnargePhotoURL() + mdmARCardName);
					}
			    }
			});
		}
		return cardPhotoFrame;
	}

	/**
	 * @return the cardPhoto
	 */
	private Image getCardPhoto() {
		if (cardPhoto == null) {
			cardPhoto = new Image();
			cardPhoto.setUrl(Factory.getInstance().getPhotoIsNotAvilableImg());
			cardPhoto.addErrorHandler(new ErrorHandler() {
				@Override
				public void onError(ErrorEvent event) {
					cardPhoto.setUrl(Factory.getInstance().getPhotoIsNotAvilableImg());
				}
			});
			cardPhoto.setPixelSize(240, 155);
		}
		return cardPhoto;
	}

	private void setCardPhotoHelper(Image photo, BasePanel photoFrame, String value) {
		if (value != null) {
			photo.setUrl(getServerPathURL() + value);
			photoFrame.setVisible(true);
		} else {
			photo.setUrl(EMPTY_VALUE);
			photoFrame.setVisible(false);
		}
	}

	/**
	 * @return the arCardTypeInfoPanel
	 */
	private FieldSetBase getArCardTypeInfoPanel() {
		if (arCardTypeInfoPanel == null) {
			arCardTypeInfoPanel = new FieldSetBase();
			arCardTypeInfoPanel.setHeading("AR Card Type Information");
			arCardTypeInfoPanel.add(getArCodeDesc(), null);
			arCardTypeInfoPanel.add(getArCode(), null);
			arCardTypeInfoPanel.add(getArNameDesc(), null);
			arCardTypeInfoPanel.add(getArName(), null);
			arCardTypeInfoPanel.add(getCardTypeCodeDesc(), null);
			arCardTypeInfoPanel.add(getCardTypeCode(), null);
			arCardTypeInfoPanel.add(getColour1Desc(), null);
			arCardTypeInfoPanel.add(getColour1(), null);
			arCardTypeInfoPanel.add(getColour2Desc(), null);
			arCardTypeInfoPanel.add(getColour2(), null);
			arCardTypeInfoPanel.add(getCardTypeDescriptionDesc(), null);
			arCardTypeInfoPanel.add(getCardTypeDescription(), null);
			arCardTypeInfoPanel.add(getEffectiveDateDesc(), null);
			arCardTypeInfoPanel.add(getEffectiveDate(), null);
			arCardTypeInfoPanel.add(getTerminationDateDesc(), null);
			arCardTypeInfoPanel.add(getTerminationDate(), null);
			arCardTypeInfoPanel.add(getActiveDesc(), null);
			arCardTypeInfoPanel.add(getActive(), null);
			arCardTypeInfoPanel.setBounds(5, 40, 600, 150);
		}
		return arCardTypeInfoPanel;
	}

	/**
	 * @return the arCodeDesc
	 */
	private LabelBase getArCodeDesc() {
		if (arCodeDesc == null) {
			arCodeDesc = new LabelBase();
			arCodeDesc.setText("AR Code");
			arCodeDesc.setBounds(0, 0, 150, 20);
		}
		return arCodeDesc;
	}

	/**
	 * @return the arCode
	 */
	private TextReadOnly getArCode() {
		if (arCode == null) {
			arCode = new TextReadOnly();
			arCode.setBounds(155, 0, 100, 20);
		}
		return arCode;
	}

	/**
	 * @return the arNameDesc
	 */
	private LabelBase getArNameDesc() {
		if (arNameDesc == null) {
			arNameDesc = new LabelBase();
			arNameDesc.setText("AR Name");
			arNameDesc.setBounds(265, 0, 60, 20);
		}
		return arNameDesc;
	}

	/**
	 * @return the arName
	 */
	private TextReadOnly getArName() {
		if (arName == null) {
			arName = new TextReadOnly();
			arName.setBounds(330, 0, 255, 20);
		}
		return arName;
	}

	/**
	 * @return the cardTypeCodeDesc
	 */
	private LabelBase getCardTypeCodeDesc() {
		if (cardTypeCodeDesc == null) {
			cardTypeCodeDesc = new LabelBase();
			cardTypeCodeDesc.setText("Card Name / Plan Name");
			cardTypeCodeDesc.setBounds(0, 25, 150, 20);
		}
		return cardTypeCodeDesc;
	}

	/**
	 * @return the cardTypeCode
	 */
	private TextString getCardTypeCode() {
		if (cardTypeCode == null) {
			cardTypeCode = new TextString(200);
			cardTypeCode.setBounds(155, 25, 430, 20);
		}
		return cardTypeCode;
	}

	/**
	 * @return the colour1Desc
	 */
	private LabelBase getColour1Desc() {
		if (colour1Desc == null) {
			colour1Desc = new LabelBase();
			colour1Desc.setText("Colour 1");
			colour1Desc.setBounds(265, 50, 50, 20);
		}
		return colour1Desc;
	}

	/**
	 * @return the colour1
	 */
//	private ComboARCardColour getColour1() {
	private TextString getColour1() {
		if (colour1 == null) {
//			colour1 = new ComboARCardColour();
			colour1 = new TextString(20);
			colour1.setBounds(320, 50, 100, 20);
		}
		return colour1;
	}

	/**
	 * @return the colour2Desc
	 */
	private LabelBase getColour2Desc() {
		if (colour2Desc == null) {
			colour2Desc = new LabelBase();
			colour2Desc.setText("Colour 2");
			colour2Desc.setBounds(430, 50, 50, 20);
		}
		return colour2Desc;
	}

	/**
	 * @return the colour2
	 */
//	private ComboARCardColour getColour2() {
	private TextString getColour2() {
		if (colour2 == null) {
//			colour2 = new ComboARCardColour();
			colour2 = new TextString(20);
			colour2.setBounds(485, 50, 100, 20);
		}
		return colour2;
	}

	/**
	 * @return the cardTypeDescriptionDesc
	 */
	private LabelBase getCardTypeDescriptionDesc() {
		if (cardTypeDescriptionDesc == null) {
			cardTypeDescriptionDesc = new LabelBase();
			cardTypeDescriptionDesc.setText("Card ID");
			cardTypeDescriptionDesc.setBounds(0, 50, 150, 20);
		}
		return cardTypeDescriptionDesc;
	}

	/**
	 * @return the cardTypeDescription
	 */
	private TextString getCardTypeDescription() {
		if (cardTypeDescription == null) {
			cardTypeDescription = new TextString();
			cardTypeDescription.setBounds(155, 50, 100, 20);
		}
		return cardTypeDescription;
	}

	/**
	 * @return the effectiveDateDesc
	 */
	private LabelBase getEffectiveDateDesc() {
		if (effectiveDateDesc == null) {
			effectiveDateDesc = new LabelBase();
			effectiveDateDesc.setText("Card effective date");
			effectiveDateDesc.setBounds(0, 75, 150, 20);
		}
		return effectiveDateDesc;
	}

	/**
	 * @return the effectiveDate
	 */
	private TextDate getEffectiveDate() {
		if (effectiveDate == null) {
			effectiveDate = new TextDate();
			effectiveDate.setBounds(155, 75, 120, 20);
		}
		return effectiveDate;
	}

	/**
	 * @return the terminationDateDesc
	 */
	private LabelBase getTerminationDateDesc() {
		if (terminationDateDesc == null) {
			terminationDateDesc = new LabelBase();
			terminationDateDesc.setText("Card termination date");
			terminationDateDesc.setBounds(330, 75, 150, 20);
		}
		return terminationDateDesc;
	}

	/**
	 * @return the teminationDate
	 */
	private TextDate getTerminationDate() {
		if (terminationDate == null) {
			terminationDate = new TextDate();
			terminationDate.setBounds(465, 75, 120, 20);
		}
		return terminationDate;
	}

	/**
	 * @return the activeDesc
	 */
	private LabelBase getActiveDesc() {
		if (activeDesc == null) {
			activeDesc = new LabelBase();
			activeDesc.setText("Active Card");
			activeDesc.setBounds(0, 100, 150, 20);
		}
		return activeDesc;
	}

	/**
	 * @return the active
	 */
	private CheckBoxBase getActive() {
		if (active == null) {
			active = new CheckBoxBase();
			active.setBounds(155, 100, 20, 20);
		}
		return active;
	}

	/**
	 * @return the tabbedPanel
	 */
	private TabbedPaneBase getTabbedPanel() {
		if (tabbedPanel == null) {
			tabbedPanel = new TabbedPaneBase() {
				public void onStateChange() {
					if (memActID!=null && memActID.length() > 0) {
						if (tabbedPanel.getSelectedIndex() == 0) {
							getInpatientInsuranceOptionsTableList().setListTableContent("ARCHECKLISTLIST", new String[] {memActID,getTabbedPanel().getSelectedIndex()==0?"In":getTabbedPanel().getSelectedIndex()==1?"Out":null,null});
						}else {
							if (tabbedPanel.getSelectedIndex() == 1) {
								tabSelect2 = true;
							}
							QueryUtil.executeMasterBrowse(getUserInfo(), "ARCOVERAGE",
									new String[] { memActID },
									new MessageQueueCallBack() {
								@Override
								public void onPostSuccess(MessageQueue mQueue) {
									if (mQueue.success()) {
										memHealthExam = mQueue.getContentField()[2];
										memImmunization = mQueue.getContentField()[3];
										memPrePostNatal = mQueue.getContentField()[4];
										memOtherCoverageType = mQueue.getContentField()[5];
										memOtherCoverage = mQueue.getContentField()[6];

										getHealthExam().setText(memHealthExam); //COV.HEALTHTEXT,
										getImmunization().setText(memImmunization); //COV.IMMUNIZATIONTEXT,
										getPrePostNatal().setText(memPrePostNatal); //COV.PRENATALTEXT,
										getOtherCoverageType().setText(memOtherCoverageType); //COV.COVERATE,
										getOtherCoverage().setText(memOtherCoverage); //COV.WBTEXT
									}
								}
							});
							getOutpatientInsuranceOptionsTableList().setListTableContent("ARCHECKLISTLIST", new String[] {memActID,getTabbedPanel().getSelectedIndex()==0?"In":getTabbedPanel().getSelectedIndex()==1?"Out":null,null});
						}
					}
				}
			};
			tabbedPanel.setBounds(5, 200, 860, 380);
			//tabbedPanel.addTab("Registration Remark", getRegistrationRemarkPanel());
			//tabbedPanel.addTab("Payment Remark", getPaymentRemarkPanel());
			tabbedPanel.addTab("Inpatient", getInpatientPanel());
			tabbedPanel.addTab("Outpatient", getOutpatientPanel());
			tabbedPanel.addTab("Contact", getContactPanel());
			tabbedPanel.addTab("Billing", getBillingPanel());
			tabbedPanel.addTab("Admin", getAdminPanel());
			//tabbedPanel.addTab("Exlusions", getExclusionsPanel());
		}
		return tabbedPanel;
	}

	/**
	 * @return the inpatientPanel
	 */
	private BasePanel getInpatientPanel() {
		if (inpatientPanel == null) {
			inpatientPanel = new BasePanel();
			inpatientPanel.add(getInpatientRegistrationRemarkDesc(), null);
			inpatientPanel.add(getInpatientRegistrationRemark(), null);
			inpatientPanel.add(getInpatientPaymentRemarkDesc(), null);
			inpatientPanel.add(getInpatientPaymentRemark(), null);
			inpatientPanel.add(getInpatientExclusionsRemarkDesc(), null);
			inpatientPanel.add(getInpatientExclusionsRemark(), null);

			inpatientPanel.add(getInpatientWebSiteAddressButton(), null);
			inpatientPanel.add(getInpatientVoucherButton(), null);
			inpatientPanel.add(getInpatientNameListCardorPolicySampleButton(), null);
			inpatientPanel.add(getInpatientPreAuthorisationFormButton(), null);
			inpatientPanel.add(getInpatientLogPASampleButton(), null);
			inpatientPanel.add(getInpatientAcknowledgementAdmissionFormButton(), null);
//			inpatientPanel.add(getInpatientPreAuthorisationMemoToDoctorButton(), null);
			inpatientPanel.add(getInpatientClaimFormLinkButton(), null);
			inpatientPanel.add(getInpatientExclusionsButton(), null);
			inpatientPanel.add(getInpatientInsuranceOptionsButton(), null);
			inpatientPanel.add(getInpatientInsuranceOptionsDesc(), null);
			inpatientPanel.add(getInpatientInsuranceOptionsTableList(), null);
			inpatientPanel.add(getInpatientGeneralExclusionsButton(), null);
			inpatientPanel.add(getInpatientGeneralExclusionsDesc(), null);
			inpatientPanel.add(getInpatientGeneralExclusionsTableList(), null);
			inpatientPanel.add(getInpatientDetailedProceduresButton(), null);
		}
		return inpatientPanel;
	}

	/**
	 * @return the inpatientRemarkDesc
	 */
	private LabelBase getInpatientRegistrationRemarkDesc() {
		if (inpatientRegistrationRemarkDesc == null) {
			inpatientRegistrationRemarkDesc = new LabelBase();
			inpatientRegistrationRemarkDesc.setText("<b>Direct Billing Remark</b>");
			inpatientRegistrationRemarkDesc.setBounds(5, 5, 150, 25);
		}
		return inpatientRegistrationRemarkDesc;
	}

	/**
	 * @return the inpatientRemark
	 */
	private TextAreaBase getInpatientRegistrationRemark() {
		if (inpatientRegistrationRemark == null) {
			inpatientRegistrationRemark = new TextAreaBase();
			inpatientRegistrationRemark.setBounds(5, 30, 360, 182);
		}
		return inpatientRegistrationRemark;
	}

	/**
	 * @return the inpatientPaymentRemarkDesc
	 */
	private LabelBase getInpatientPaymentRemarkDesc() {
		if (inpatientPaymentRemarkDesc == null) {
			inpatientPaymentRemarkDesc = new LabelBase();
			inpatientPaymentRemarkDesc.setText("<b>Pop-up Alert</b>");
			inpatientPaymentRemarkDesc.setBounds(5, 209, 150, 25);
		}
		return inpatientPaymentRemarkDesc;
	}

	/**
	 * @return the inpatientPaymentRemark
	 */
	private TextAreaBase getInpatientPaymentRemark() {
		if (inpatientPaymentRemark == null) {
			inpatientPaymentRemark = new TextAreaBase();
			inpatientPaymentRemark.setBounds(5, 230, 360, 116);
		}
		return inpatientPaymentRemark;
	}

	/**
	 * @return the inpatientExclusionsRemarkDesc
	 */
	private LabelBase getInpatientExclusionsRemarkDesc() {
		if (inpatientExclusionsRemarkDesc == null) {
			inpatientExclusionsRemarkDesc = new LabelBase();
			inpatientExclusionsRemarkDesc.setText("<b>Exclusion Remark</b>");
			inpatientExclusionsRemarkDesc.setBounds(650, 170, 200, 25);
		}
		return inpatientExclusionsRemarkDesc;
	}

	/**
	 * @return the inpatientExclusionsRemark
	 */
	private TextAreaBase getInpatientExclusionsRemark() {
		if (inpatientExclusionsRemark == null) {
			inpatientExclusionsRemark = new TextAreaBase();
			inpatientExclusionsRemark.setBounds(650, 195, 200, 150);
		}
		return inpatientExclusionsRemark;
	}

	/**
	 * @return the outpatientRegWebSiteAddressButton
	 */
	private ButtonBase getInpatientWebSiteAddressButton() {
		if (inpatientWebSiteAddressButton == null) {
			inpatientWebSiteAddressButton = new ButtonBase("Website") {
				@Override
				public void onClick() {
					if (memIpUrl!=null && memIpUrl.length() > 0) {
						if ("HTTP".equals(memIpUrl.substring(0, 4).toUpperCase())) {
							memIpUrl = memIpUrl.replace("&", "%26");
							openNewWindow(memIpUrl);
						} else {
							memIpUrl = memIpUrl.replace("&", "%26");
							openNewWindow(getOpenFileURL() + memIpUrl);
						}
					}
				}
			};
			inpatientWebSiteAddressButton.setBounds(370, 5, 50, 25);
		}
		return inpatientWebSiteAddressButton;
	}

	/**
	 * @return the voucherButton
	 */
	private ButtonBase getInpatientVoucherButton() {
		if (inpatientVoucherButton == null) {
			inpatientVoucherButton = new ButtonBase("Voucher") {
				@Override
				public void onClick() {
					if (memInVouch!=null && memInVouch.length() > 0) {
						if ("HTTP".equals(memInVouch.substring(0, 4).toUpperCase())) {
							memInVouch = memInVouch.replace("&", "%26");
							openNewWindow(memInVouch);
						} else {
							memInVouch = memInVouch.replace("&", "%26");
							openNewWindow(getOpenFileURL() + memInVouch);
						}

					}
				}
			};
			inpatientVoucherButton.setBounds(425, 5, 60, 25);
		}
		return inpatientVoucherButton;
	}

	/**
	 * @return the claimFormLinkButton
	 */
	private ButtonBase getInpatientClaimFormLinkButton() {
		if (inpatientClaimFormLinkButton == null) {
			inpatientClaimFormLinkButton = new ButtonBase("Claim Form") {
				@Override
				public void onClick() {
					if (memInClaim!=null && memInClaim.length() > 0) {
						if ("HTTP".equals(memInClaim.substring(0, 4).toUpperCase())) {
							memInClaim = memInClaim.replace("&", "%26");
							openNewWindow(memInClaim);
						} else {
							memInClaim = memInClaim.replace("&", "%26");
							openNewWindow(getOpenFileURL() + memInClaim);
						}
					}
				}
			};
			inpatientClaimFormLinkButton.setBounds(490, 5, 70, 25);
		}
		return inpatientClaimFormLinkButton;
	}

	/**
	 * @return the nameListCardorPolicySampleButton
	 */
	private ButtonBase getInpatientNameListCardorPolicySampleButton() {
		if (inpatientNameListCardorPolicySampleButton == null) {
			inpatientNameListCardorPolicySampleButton = new ButtonBase("Name List") {
				@Override
				public void onClick() {
					if (memInNameList!=null && memInNameList.length() > 0) {
						if ("HTTP".equals(memInNameList.substring(0, 4).toUpperCase())) {
							memInNameList = memInNameList.replace("&", "%26");
							openNewWindow(memInNameList);
						} else {
							memInNameList = memInNameList.replace("&", "%26");
							openNewWindow(getOpenFileURL() + memInNameList);
						}
					}
				}
			};
			inpatientNameListCardorPolicySampleButton.setBounds(565, 5, 70, 25);
		}
		return inpatientNameListCardorPolicySampleButton;
	}

	/**
	 * @return the preAuthorisationFormButton
	 */
	private ButtonBase getInpatientPreAuthorisationFormButton() {
		if (inpatientPreAuthorisationFormButton == null) {
			inpatientPreAuthorisationFormButton = new ButtonBase("PA Request Form") {
				@Override
				public void onClick() {
					if (memInPreAuth!=null && memInPreAuth.length() > 0) {
						if ("HTTP".equals(memInPreAuth.substring(0, 4).toUpperCase())) {
							memInPreAuth = memInPreAuth.replace("&", "%26");
							openNewWindow(memInPreAuth);
						} else {
							memInPreAuth = memInPreAuth.replace("&", "%26");
							openNewWindow(getOpenFileURL() + memInPreAuth);
						}
					}
				}
			};
			inpatientPreAuthorisationFormButton.setBounds(370, 35, 105, 25);
		}
		return inpatientPreAuthorisationFormButton;
	}

	/**
	 * @return the inpatientLogPASampleButton
	 */
	private ButtonBase getInpatientLogPASampleButton() {
		if (inpatientLogPASampleButton == null) {
			inpatientLogPASampleButton = new ButtonBase("LOG/ PA Sample") {
				@Override
				public void onClick() {
					if (memInPolicySample!=null && memInPolicySample.length() > 0) {
						if ("HTTP".equals(memInPolicySample.substring(0, 4).toUpperCase())) {
							memInPolicySample = memInPolicySample.replace("&", "%26");
							openNewWindow(memInPolicySample);
						} else {
							memInPolicySample = memInPolicySample.replace("&", "%26");
							openNewWindow(getOpenFileURL() + memInPolicySample);
						}
					}
				}
			};
			inpatientLogPASampleButton.setBounds(480, 35, 100, 25);
		}
		return inpatientLogPASampleButton;
	}


	/**
	 * @return the acknowledgementAdmissionFormButton
	 */

	private ButtonBase getInpatientAcknowledgementAdmissionFormButton() {
		if (inpatientAcknowledgementAdmissionFormButton == null) {
			inpatientAcknowledgementAdmissionFormButton = new ButtonBase("Acknowledgement") {
				@Override
				public void onClick() {
					if (memInAcknowForm!=null && memInAcknowForm.length() > 0) {
						memInAcknowForm = memInAcknowForm.replace("&", "%26");
						openNewWindow(getOpenFileURL() + memInAcknowForm);
					}
				}
			};
			inpatientAcknowledgementAdmissionFormButton.setBounds(370, 65, 105, 25);
		}
		return inpatientAcknowledgementAdmissionFormButton;
	}

	/**
	 * @return the preAuthorisationMemoToDoctorButton
	 */
/*
	private ButtonBase getInpatientPreAuthorisationMemoToDoctorButton() {
		if (inpatientPreAuthorisationMemoToDoctorButton == null) {
			inpatientPreAuthorisationMemoToDoctorButton = new ButtonBase("Memo to Doctor") {
				@Override
				public void onClick() {
					if (memInMemo!=null && memInMemo.length() > 0) {
						openNewWindow(getOpenFileURL() + memInMemo);
					}
				}
			};
			inpatientPreAuthorisationMemoToDoctorButton.setBounds(485, 5, 85, 25);
		}
		return inpatientPreAuthorisationMemoToDoctorButton;
	}
*/
	/**
	 * @return the exclusionsButton
	 */
	private ButtonBase getInpatientExclusionsButton() {
		if (inpatientExclusionsButton == null) {
			inpatientExclusionsButton = new ButtonBase("Exclusions List") {
				@Override
				public void onClick() {
					if (memInpExclu!=null && memInpExclu.length() > 0) {
						if ("HTTP".equals(memInpExclu.substring(0, 4).toUpperCase())) {
							memInpExclu = memInpExclu.replace("&", "%26");
							openNewWindow(memInpExclu);
						} else {
							memInpExclu = memInpExclu.replace("&", "%26");
							openNewWindow(getOpenFileURL() + memInpExclu);
						}
					}
				};
			};
			inpatientExclusionsButton.setBounds(760, 5, 80, 25);
		}
		return inpatientExclusionsButton;
	}

	/**
	 * @return the generalExclusionsButton
	 */
	private ButtonBase getInpatientGeneralExclusionsButton() {
		if (inpatientGeneralExclusionsButton == null) {
			inpatientGeneralExclusionsButton = new ButtonBase("General Exclusions") {
				@Override
				public void onClick() {
					if (memActID!=null && memActID.length() > 0) {
						getGeneralExclusionsDialog().showDialog(memArcCode,memActID);
					}
				};
			};
			inpatientGeneralExclusionsButton.setBounds(650, 5, 100, 25);
		}
		return inpatientGeneralExclusionsButton;
	}

	/**
	 * @return the generalExclusionsDialog
	 */
	private DlgGeneralExclusions getGeneralExclusionsDialog() {
		if (generalExclusionsDialog == null) {
			generalExclusionsDialog = new DlgGeneralExclusions(getMainFrame()) {
			    @Override
				protected void doOkAction() {
					getOutpatientGeneralExclusionsTableList().setListTableContent("AREXCLUSIONSLIST", new String[] {memActID});
					getInpatientGeneralExclusionsTableList().setListTableContent("AREXCLUSIONSLIST", new String[] {memActID});
			    }

				@Override
				public void dispose() {
					super.dispose();
					getOutpatientGeneralExclusionsTableList().setListTableContent("AREXCLUSIONSLIST", new String[] {memActID});
					getInpatientGeneralExclusionsTableList().setListTableContent("AREXCLUSIONSLIST", new String[] {memActID});
				};
			};
		}
		return generalExclusionsDialog;
	}

	private String[] getGeneralExclusionsColumnNames() {
		return new String[] { "", "" };
	}

	private int[] getGeneralExclusionsColumnWidths(boolean inpat) {
		if (inpat) {
			return new int[] { 270, 0 };
		}
		else {
			return new int[] { 270, 0 };
		}
	}

	private LabelBase getInpatientGeneralExclusionsDesc() {
		if (inpatientGeneralExclusionsDesc == null) {
			inpatientGeneralExclusionsDesc = new LabelBase();
			inpatientGeneralExclusionsDesc.setText("<b>General Exclusion</b>");
			inpatientGeneralExclusionsDesc.setBounds(650, 35, 200, 20);
		}
		return inpatientGeneralExclusionsDesc;
	}

	/**
	 * @return the generalExclusionsTableList
	 */
	private TableList getInpatientGeneralExclusionsTableList() {
		if (inpatientGeneralExclusionsTableList == null) {
			inpatientGeneralExclusionsTableList = new TableList(getGeneralExclusionsColumnNames(),
															getGeneralExclusionsColumnWidths(true));
			inpatientGeneralExclusionsTableList.setBounds(650, 55, 200, 115);
		}
		return inpatientGeneralExclusionsTableList;
	}

	/**
	 * @return the getInpatientDetailedProceduresButton
	 */
	private ButtonBase getInpatientDetailedProceduresButton() {
		if (inpatientDetailedProceduresButton == null) {
			inpatientDetailedProceduresButton = new ButtonBase("Detailed Procedures") {
				@Override
				public void onClick() {
					if (memInDtlPro!=null && memInDtlPro.length() > 0) {
						if ("HTTP".equals(memInDtlPro.substring(0, 4).toUpperCase())) {
							memInDtlPro = memInDtlPro.replace("&", "%26");
							openNewWindow(memInDtlPro);
						} else {
							memInDtlPro = memInDtlPro.replace("&", "%26");
							openNewWindow(getOpenFileURL() + memInDtlPro);
						}
					}
				}
			};
			inpatientDetailedProceduresButton.setBounds(240, 5, 120, 25);
		}
		return inpatientDetailedProceduresButton;
	}

	/**
	 * @return the regInsuranceOptionsButton
	 */
	private ButtonBase getInpatientInsuranceOptionsButton() {
		if (inpatientInsuranceOptionsButton == null) {
			inpatientInsuranceOptionsButton = new ButtonBase("Insurance Checklist") {
				@Override
				public void onClick() {
					getInsuranceOptionsDialog().showDialog(getArCode().getText(),memActID,getTabbedPanel().getSelectedIndex()==0?"In":getTabbedPanel().getSelectedIndex()==1?"Out":null);
				};
			};
			inpatientInsuranceOptionsButton.setBounds(370, 140, 270, 25);
		}
		return inpatientInsuranceOptionsButton;
	}

	/**
	 * @return the insuranceOptionsDialog
	 */
	private DlgInsuranceOptions getInsuranceOptionsDialog() {
		if (insuranceOptionsDialog == null) {
			insuranceOptionsDialog = new DlgInsuranceOptions(getMainFrame()) {
			    @Override
				protected void doOkAction() {
					getOutpatientInsuranceOptionsTableList().setListTableContent("ARCHECKLISTLIST", new String[] {memActID,getTabbedPanel().getSelectedIndex()==0?"In":getTabbedPanel().getSelectedIndex()==1?"Out":null,null});
					getInpatientInsuranceOptionsTableList().setListTableContent("ARCHECKLISTLIST", new String[] {memActID,getTabbedPanel().getSelectedIndex()==0?"In":getTabbedPanel().getSelectedIndex()==1?"Out":null,null});
			    }

				@Override
				public void dispose() {
					super.dispose();
					getOutpatientInsuranceOptionsTableList().setListTableContent("ARCHECKLISTLIST", new String[] {memActID,getTabbedPanel().getSelectedIndex()==0?"In":getTabbedPanel().getSelectedIndex()==1?"Out":null,null});
					getInpatientInsuranceOptionsTableList().setListTableContent("ARCHECKLISTLIST", new String[] {memActID,getTabbedPanel().getSelectedIndex()==0?"In":getTabbedPanel().getSelectedIndex()==1?"Out":null,null});
				};
			};
		}
		return insuranceOptionsDialog;
	}

	private String[] getInsuranceOptionsColumnNames() {
		return new String[] { "", "" };
	}

	private int[] getInsuranceOptionsColumnWidths(boolean inpat) {
		if (inpat) {
			return new int[] { 270, 0 };
		}
		else {
			return new int[] { 270, 0 };
		}
	}

	private LabelBase getInpatientInsuranceOptionsDesc() {
		if (inpatientInsuranceOptionsDesc == null) {
			inpatientInsuranceOptionsDesc = new LabelBase();
			inpatientInsuranceOptionsDesc.setText("<b>Item Checklist</b>");
			inpatientInsuranceOptionsDesc.setBounds(370, 170, 150, 25);
		}
		return inpatientInsuranceOptionsDesc;
	}

	/**
	 * @return the insuranceOptionsTableList
	 */
	private TableList getInpatientInsuranceOptionsTableList() {
		if (inpatientInsuranceOptionsTableList == null) {
			inpatientInsuranceOptionsTableList = new TableList(getInsuranceOptionsColumnNames(),
														getInsuranceOptionsColumnWidths(true));
			inpatientInsuranceOptionsTableList.setBounds(370, 195, 270, 150);
			inpatientInsuranceOptionsTableList.getView().setSortingEnabled(false);
		}
		return inpatientInsuranceOptionsTableList;
	}

	/**
	 * @return the outpatientPanel
	 */
	private BasePanel getOutpatientPanel() {
		if (outpatientPanel == null) {
			outpatientPanel = new BasePanel();
			outpatientPanel.add(getOutpatientRegistrationRemarkDesc(), null);
			outpatientPanel.add(getOutpatientRegistrationRemark(), null);
			outpatientPanel.add(getOutpatientPaymentRemarkDesc(), null);
			outpatientPanel.add(getOutpatientPaymentRemark(), null);
			outpatientPanel.add(getOutpatientExclusionsRemarkDesc(), null);
			outpatientPanel.add(getOutpatientExclusionsRemark(), null);
			outpatientPanel.add(getOutpatientWebSiteAddressButton(), null);
			outpatientPanel.add(getOutpatientVoucherButton(), null);
			outpatientPanel.add(getOutpatientNameListCardorPolicySampleButton(), null);
			outpatientPanel.add(getOutpatientLogPASampleButton(), null);
			outpatientPanel.add(getOutpatientPreAuthorisationFormButton(), null);
//			outpatientPanel.add(getOutpatientAcknowledgementAdmissionFormButton(), null);
			outpatientPanel.add(getOutpatientPreAuthorisationMemoToDoctorButton(), null);
			outpatientPanel.add(getOutpatientClaimFormLinkButton(), null);
			outpatientPanel.add(getOutpatientExclusionsButton(), null);
			outpatientPanel.add(getOutpatientInsuranceOptionsButton(), null);
			outpatientPanel.add(getOutpatientInsuranceOptionsDesc(), null);
			outpatientPanel.add(getOutpatientInsuranceOptionsTableList(), null);
			outpatientPanel.add(getOutpatientGeneralExclusionsButton(), null);
			outpatientPanel.add(getOutpatientGeneralExclusionsDesc(), null);
			outpatientPanel.add(getOutpatientGeneralExclusionsTableList(), null);
			outpatientPanel.add(getHealthExamDesc(), null);
			outpatientPanel.add(getHealthExam(), null);
			outpatientPanel.add(getImmunizationDesc(), null);
			outpatientPanel.add(getImmunization(), null);
			outpatientPanel.add(getPrePostNatalDesc(), null);
			outpatientPanel.add(getPrePostNatal(), null);
			outpatientPanel.add(getOtherCoverageType(), null);
			outpatientPanel.add(getOtherCoverage(), null);
			outpatientPanel.add(getOutpatientDetailedProceduresButton(), null);
		}
		return outpatientPanel;
	}

	/**
	 * @return the outpatientRegistrationRemarkDesc
	 */
	private LabelBase getOutpatientRegistrationRemarkDesc() {
		if (outpatientRegistrationRemarkDesc == null) {
			outpatientRegistrationRemarkDesc = new LabelBase();
			outpatientRegistrationRemarkDesc.setText("<b>Direct Billing Remark</b>");
			outpatientRegistrationRemarkDesc.setBounds(5, 5, 150, 25);
		}
		return outpatientRegistrationRemarkDesc;
	}

	/**
	 * @return the outpatientRegistrationRemark
	 */
	private TextAreaBase getOutpatientRegistrationRemark() {
		if (outpatientRegistrationRemark == null) {
			outpatientRegistrationRemark = new TextAreaBase();
			outpatientRegistrationRemark.setBounds(5, 30, 365, 182);
		}
		return outpatientRegistrationRemark;
	}

	/**
	 * @return the outpatientPaymentRemarkDesc
	 */
	private LabelBase getOutpatientPaymentRemarkDesc() {
		if (outpatientPaymentRemarkDesc == null) {
			outpatientPaymentRemarkDesc = new LabelBase();
			outpatientPaymentRemarkDesc.setText("<b>Pop-up Alert</b>");
			outpatientPaymentRemarkDesc.setBounds(5, 209, 150, 25);
		}
		return outpatientPaymentRemarkDesc;
	}

	/**
	 * @return the outpatientPaymentRemark
	 */
	private TextAreaBase getOutpatientPaymentRemark() {
		if (outpatientPaymentRemark == null) {
			outpatientPaymentRemark = new TextAreaBase();
			outpatientPaymentRemark.setBounds(5, 230, 365, 115);
		}
		return outpatientPaymentRemark;
	}

	/**
	 * @return the outpatientExclusionsRemarkDesc
	 */
	private LabelBase getOutpatientExclusionsRemarkDesc() {
		if (outpatientExclusionsRemarkDesc == null) {
			outpatientExclusionsRemarkDesc = new LabelBase();
			outpatientExclusionsRemarkDesc.setText("<b>Exclusion Remark</b>");
			outpatientExclusionsRemarkDesc.setBounds(650, 185, 200, 25);
		}
		return outpatientExclusionsRemarkDesc;
	}

	/**
	 * @return the outpatientExclusionsRemark
	 */
	private TextAreaBase getOutpatientExclusionsRemark() {
		if (outpatientExclusionsRemark == null) {
			outpatientExclusionsRemark = new TextAreaBase();
			outpatientExclusionsRemark.setBounds(650, 210, 200, 137);
		}
		return outpatientExclusionsRemark;
	}

	/**
	 * @return the outpatientRegWebSiteAddressButton
	 */
	private ButtonBase getOutpatientWebSiteAddressButton() {
		if (outpatientWebSiteAddressButton == null) {
			outpatientWebSiteAddressButton = new ButtonBase("Website") {
				@Override
				public void onClick() {
					if (memOpUrl!=null && memOpUrl.length() > 0) {
						if ("HTTP".equals(memOpUrl.substring(0, 4).toUpperCase())) {
							memOpUrl = memOpUrl.replace("&", "%26");
							openNewWindow(memOpUrl);
						} else {
							memOpUrl = memOpUrl.replace("&", "%26");
							openNewWindow(getOpenFileURL() + memOpUrl);
						}
					}
				}
			};
			outpatientWebSiteAddressButton.setBounds(375, 5, 50, 25);
		}
		return outpatientWebSiteAddressButton;
	}

	/**
	 * @return the voucherButton
	 */
	private ButtonBase getOutpatientVoucherButton() {
		if (outpatientVoucherButton == null) {
			outpatientVoucherButton = new ButtonBase("Voucher") {
				@Override
				public void onClick() {
					if (memOutVouch!=null && memOutVouch.length() > 0) {
						if ("HTTP".equals(memOutVouch.substring(0, 4).toUpperCase())) {
							memOutVouch = memOutVouch.replace("&", "%26");
							openNewWindow(memOutVouch);
						} else {
							memOutVouch = memOutVouch.replace("&", "%26");
							openNewWindow(getOpenFileURL() + memOutVouch);
						}
					}
				};
			};
			outpatientVoucherButton.setBounds(430, 5, 60, 25);
		}
		return outpatientVoucherButton;
	}

	/**
	 * @return the nameListCardorPolicySampleButton
	 */
	private ButtonBase getOutpatientNameListCardorPolicySampleButton() {
		if (outpatientNameListCardorPolicySampleButton == null) {
			outpatientNameListCardorPolicySampleButton = new ButtonBase("Name List") {
				@Override
				public void onClick() {
					if (memOutNameList!=null && memOutNameList.length() > 0) {
						if ("HTTP".equals(memOutNameList.substring(0, 4).toUpperCase())) {
							memOutNameList = memOutNameList.replace("&", "%26");
							openNewWindow(memOutNameList);
						} else {
							memOutNameList = memOutNameList.replace("&", "%26");
							openNewWindow(getOpenFileURL() + memOutNameList);
						}
					}
				}
			};
			outpatientNameListCardorPolicySampleButton.setBounds(570, 5, 60, 25);
		}
		return outpatientNameListCardorPolicySampleButton;
	}


	/**
	 * @return the outpatientLogPASampleButton
	 */
	private ButtonBase getOutpatientLogPASampleButton() {
		if (outpatientLogPASampleButton == null) {
			outpatientLogPASampleButton = new ButtonBase("LOG / PA Sample") {
				@Override
				public void onClick() {
					if (memOutPolicySample!=null && memOutPolicySample.length() > 0) {
						if ("HTTP".equals(memOutPolicySample.substring(0, 4).toUpperCase())) {
							memOutPolicySample = memOutPolicySample.replace("&", "%26");
							openNewWindow(memOutPolicySample);
						} else {
							memOutPolicySample = memOutPolicySample.replace("&", "%26");
							openNewWindow(getOpenFileURL() + memOutPolicySample);
						}
					}
				}
			};
			outpatientLogPASampleButton.setBounds(545, 35, 90, 25);
		}
		return outpatientLogPASampleButton;
	}

	/**
	 * @return the preAuthorisationFormButton
	 */
	private ButtonBase getOutpatientPreAuthorisationFormButton() {
		if (outpatientPreAuthorisationFormButton == null) {
			outpatientPreAuthorisationFormButton = new ButtonBase("Pre-Auth Form") {
				@Override
				public void onClick() {
					if (memOutPreAuth!=null && memOutPreAuth.length() > 0) {
						if ("HTTP".equals(memOutPreAuth.substring(0, 4).toUpperCase())) {
							memOutPreAuth = memOutPreAuth.replace("&", "%26");
							openNewWindow(memOutPreAuth);
						} else {
							memOutPreAuth = memOutPreAuth.replace("&", "%26");
							openNewWindow(getOpenFileURL() + memOutPreAuth);
						}
					}
				}
			};
			outpatientPreAuthorisationFormButton.setBounds(375, 35, 80, 25);
		}
		return outpatientPreAuthorisationFormButton;
	}

	/**
	 * @return the acknowledgementAdmissionFormButton
	 */
/*
	private ButtonBase getOutpatientAcknowledgementAdmissionFormButton() {
		if (outpatientAcknowledgementAdmissionFormButton == null) {
			outpatientAcknowledgementAdmissionFormButton = new ButtonBase("Acknowledgement") {
				@Override
				public void onClick() {
					if (memOutAcknowForm!=null && memOutAcknowForm.length() > 0) {
						openNewWindow(getOpenFileURL() + memOutAcknowForm);
					}
				}
			};
			outpatientAcknowledgementAdmissionFormButton.setBounds(85, 5, 80, 25);
		}
		return outpatientAcknowledgementAdmissionFormButton;
	}
*/
	/**
	 * @return the preAuthorisationMemoToDoctorButton
	 */
	private ButtonBase getOutpatientPreAuthorisationMemoToDoctorButton() {
		if (outpatientPreAuthorisationMemoToDoctorButton == null) {
			outpatientPreAuthorisationMemoToDoctorButton = new ButtonBase("Memo to Dr") {
				@Override
				public void onClick() {
					if (memOutMemo!=null && memOutMemo.length() > 0) {
						if ("HTTP".equals(memOutMemo.substring(0, 4).toUpperCase())) {
							memOutMemo = memOutMemo.replace("&", "%26");
							openNewWindow(memOutMemo);
						} else {
							memOutMemo = memOutMemo.replace("&", "%26");
							openNewWindow(getOpenFileURL() + memOutMemo);
						}
					}
				}
			};
			outpatientPreAuthorisationMemoToDoctorButton.setBounds(460, 35, 80, 25);
		}
		return outpatientPreAuthorisationMemoToDoctorButton;
	}

	/**
	 * @return the claimFormLinkButton
	 */
	private ButtonBase getOutpatientClaimFormLinkButton() {
		if (outpatientClaimFormLinkButton == null) {
			outpatientClaimFormLinkButton = new ButtonBase("Claim Form") {
				@Override
				public void onClick() {
					if (memOutClaim!=null && memOutClaim.length() > 0) {
						if ("HTTP".equals(memOutClaim.substring(0, 4).toUpperCase())) {
							memOutClaim = memOutClaim.replace("&", "%26");
							openNewWindow(memOutClaim);
						} else {
							memOutClaim = memOutClaim.replace("&", "%26");
							openNewWindow(getOpenFileURL() + memOutClaim);
						}
					}
				}
			};
			outpatientClaimFormLinkButton.setBounds(495, 5, 70, 25);
		}
		return outpatientClaimFormLinkButton;
	}

	/**
	 * @return the exclusionsButton
	 */
	private ButtonBase getOutpatientExclusionsButton() {
		if (outpatientExclusionsButton == null) {
			outpatientExclusionsButton = new ButtonBase("Exclusions List") {
				@Override
				public void onClick() {
					if (memOutExclu!=null && memOutExclu.length() > 0) {
						if ("HTTP".equals(memOutExclu.substring(0, 4).toUpperCase())) {
							memOutExclu = memOutExclu.replace("&", "%26");
							openNewWindow(memOutExclu);
						} else {
							memOutExclu = memOutExclu.replace("&", "%26");
							openNewWindow(getOpenFileURL() + memOutExclu);
						}
					}
				};
			};
			outpatientExclusionsButton.setBounds(760, 5, 80, 25);
		}
		return outpatientExclusionsButton;
	}

	/**
	 * @return the generalExclusionsButton
	 */
	private ButtonBase getOutpatientGeneralExclusionsButton() {
		if (outpatientGeneralExclusionsButton == null) {
			outpatientGeneralExclusionsButton = new ButtonBase("General Exclusions") {
				@Override
				public void onClick() {
					getGeneralExclusionsDialog().showDialog(getArCode().getText(),memActID);
				};
			};
			outpatientGeneralExclusionsButton.setBounds(650, 5, 100, 25);
		}
		return outpatientGeneralExclusionsButton;
	}

	/**
	 * @return the getOutpatientDetailedProceduresButton
	 */
	private ButtonBase getOutpatientDetailedProceduresButton() {
		if (outpatientDetailedProceduresButton == null) {
			outpatientDetailedProceduresButton = new ButtonBase("Detailed Procedures") {
				@Override
				public void onClick() {
					if (memOutDtlPro!=null && memOutDtlPro.length() > 0) {
						if ("HTTP".equals(memOutDtlPro.substring(0, 4).toUpperCase())) {
							memOutDtlPro = memOutDtlPro.replace("&", "%26");
							openNewWindow(memOutDtlPro);
						} else {
							memOutDtlPro = memOutDtlPro.replace("&", "%26");
							openNewWindow(getOpenFileURL() + memOutDtlPro);
						}
					}
				}
			};
			outpatientDetailedProceduresButton.setBounds(240, 5, 120, 25);
		}
		return outpatientDetailedProceduresButton;
	}

	/**
	 * @return the regInsuranceOptionsButton
	 */
	private ButtonBase getOutpatientInsuranceOptionsButton() {
		if (outpatientInsuranceOptionsButton == null) {
			outpatientInsuranceOptionsButton = new ButtonBase("Insurance Checklist") {
				@Override
				public void onClick() {
					getInsuranceOptionsDialog().showDialog(getArCode().getText(),memActID,getTabbedPanel().getSelectedIndex()==0?"In":getTabbedPanel().getSelectedIndex()==1?"Out":null);
				};
			};
			outpatientInsuranceOptionsButton.setBounds(375, 188, 270, 25);
		}
		return outpatientInsuranceOptionsButton;
	}

	private LabelBase getOutpatientGeneralExclusionsDesc() {
		if (outpatientGeneralExclusionsDesc == null) {
			outpatientGeneralExclusionsDesc = new LabelBase();
			outpatientGeneralExclusionsDesc.setText("<b>General Exclusion</b>");
			outpatientGeneralExclusionsDesc.setBounds(650, 37, 200, 20);
		}
		return outpatientGeneralExclusionsDesc;
	}

	/**
	 * @return the generalExclusionsTableList
	 */
	private TableList getOutpatientGeneralExclusionsTableList() {
		if (outpatientGeneralExclusionsTableList == null) {
			outpatientGeneralExclusionsTableList = new TableList(getGeneralExclusionsColumnNames(),
															getGeneralExclusionsColumnWidths(false));
			outpatientGeneralExclusionsTableList.setBounds(650, 55, 200, 120);
		}
		return outpatientGeneralExclusionsTableList;
	}

	private LabelBase getOutpatientInsuranceOptionsDesc() {
		if (outpatientInsuranceOptionsDesc == null) {
			outpatientInsuranceOptionsDesc = new LabelBase();
			outpatientInsuranceOptionsDesc.setText("<b>Item Checklist</b>");
			outpatientInsuranceOptionsDesc.setBounds(375, 209, 150, 20);
		}
		return outpatientInsuranceOptionsDesc;
	}

	/**
	 * @return the insuranceOptionsTableList
	 */
	private TableList getOutpatientInsuranceOptionsTableList() {
		if (outpatientInsuranceOptionsTableList == null) {
			outpatientInsuranceOptionsTableList = new TableList(getInsuranceOptionsColumnNames(),
														getInsuranceOptionsColumnWidths(false));
			outpatientInsuranceOptionsTableList.setBounds(375, 230, 270, 116);
		}
		return outpatientInsuranceOptionsTableList;
	}

	/**
	 * @return the healthExamDesc
	 */
	private LabelBase getHealthExamDesc() {
		if (healthExamDesc == null) {
			healthExamDesc = new LabelBase();
			healthExamDesc.setText("<b>Health Exam:</b>");
			healthExamDesc.setBounds(375, 70, 90, 30);
		}
		return healthExamDesc;
	}

	/**
	 * @return the healthExam
	 */
	private ComboHealthExamCoverage getHealthExam() {
		if (healthExam == null) {
			healthExam = new ComboHealthExamCoverage() {
				@Override
				protected void resetContentPost() {
					super.resetContentPost();
				}
			};
			healthExam.setBounds(500, 70, 145, 20);
			healthExam.setForceSelection(false);
		}
		return healthExam;
	}

	/**
	 * @return the immunizationDesc
	 */
	private LabelBase getImmunizationDesc() {
		if (immunizationDesc == null) {
			immunizationDesc = new LabelBase();
			immunizationDesc.setText("<b>Immunization:</b>");
			immunizationDesc.setBounds(375, 95, 90, 20);
		}
		return immunizationDesc;
	}

	/**
	 * @return the immunization
	 */
	private ComboImmunizationCoverage getImmunization() {
		if (immunization == null) {
			immunization = new ComboImmunizationCoverage() {
				@Override
				protected void resetContentPost() {
					super.resetContentPost();
				}
			};
			immunization.setBounds(500, 95, 145, 20);
			immunization.setForceSelection(false);
		}
		return immunization;
	}

	/**
	 * @return the prePostNatalDesc
	 */
	private LabelBase getPrePostNatalDesc() {
		if (prePostNatalDesc == null) {
			prePostNatalDesc = new LabelBase();
			prePostNatalDesc.setText("<b>Pre-natal/Post-natal:</b>");
			prePostNatalDesc.setBounds(375, 120, 120, 30);
		}
		return prePostNatalDesc;
	}

	/**
	 * @return the prePostNatal
	 */
	private ComboPrePostNatal getPrePostNatal() {
		if (prePostNatal == null) {
			prePostNatal = new ComboPrePostNatal() {
				@Override
				protected void resetContentPost() {
					super.resetContentPost();
				}
			};
			prePostNatal.setBounds(500, 120, 145, 20);
			prePostNatal.setForceSelection(false);
		}
		return prePostNatal;
	}

	/**
	 * @return the otherCoverageType
	 */
	private TextString getOtherCoverageType() {
		if (otherCoverageType == null) {
			otherCoverageType = new TextString();
			otherCoverageType.setBounds(375, 155, 120, 20);
		}
		return otherCoverageType;
	}

	/**
	 * @return the otherCoverage
	 */
	private ComboOtherCoverage getOtherCoverage() {
		if (otherCoverage == null) {
			otherCoverage = new ComboOtherCoverage() {
				@Override
				protected void resetContentPost() {
					super.resetContentPost();
				}
			};
			otherCoverage.setBounds(500, 155, 145, 20);
			otherCoverage.setForceSelection(false);
		}
		return otherCoverage;
	}

	/**
	 * @return the billingPanel
	 */
	private BasePanel getBillingPanel() {
		if (billingPanel == null) {
			billingPanel = new BasePanel();
			billingPanel.add(geteBillingDesc(), null);
			billingPanel.add(geteBilling(), null);
			billingPanel.add(getSendOriginalBillsDesc(), null);
			billingPanel.add(getSendOriginalBills(), null);
			billingPanel.add(getUploadToPortalDesc(), null);
			billingPanel.add(getUploadToPortal(), null);
			billingPanel.add(getBillingOtherDesc(), null);
			billingPanel.add(getBillingOther(), null);
			billingPanel.add(getInpatientBillingRemarkDesc(), null);
			billingPanel.add(getInpatientBillingRemark(), null);
			billingPanel.add(getOutpatientBillingRemarkDesc(), null);
			billingPanel.add(getOutpatientBillingRemark(), null);
			billingPanel.add(getSampleInvoiceButton(), null);
		}
		return billingPanel;
	}

	/**
	 * @return the eBillingDesc
	 */
	private LabelBase geteBillingDesc() {
		if (eBillingDesc == null) {
			eBillingDesc = new LabelBase();
			eBillingDesc.setText("<b>E-billing</b>");
			eBillingDesc.setBounds(650, 5, 170, 20);
		}
		return eBillingDesc;
	}

	/**
	 * @return the eBilling
	 */
	private CheckBoxBase geteBilling() {
		if (eBilling == null) {
			eBilling = new CheckBoxBase();
			eBilling.setBounds(825, 5, 20, 20);
		}
		return eBilling;
	}

	/**
	 * @return the sendOriginalBillsDesc
	 */
	private LabelBase getSendOriginalBillsDesc() {
		if (sendOriginalBillsDesc == null) {
			sendOriginalBillsDesc = new LabelBase();
			sendOriginalBillsDesc.setText("<b>Send original invoice</b>");
			sendOriginalBillsDesc.setBounds(650, 30, 170, 20);
		}
		return sendOriginalBillsDesc;
	}

	/**
	 * @return the sendOriginalBills
	 */
	private CheckBoxBase getSendOriginalBills() {
		if (sendOriginalBills == null) {
			sendOriginalBills = new CheckBoxBase();
			sendOriginalBills.setBounds(825, 30, 20, 20);
		}
		return sendOriginalBills;
	}

	/**
	 * @return the uploadToPortalDesc
	 */
	private LabelBase getUploadToPortalDesc() {
		if (uploadToPortalDesc == null) {
			uploadToPortalDesc = new LabelBase();
			uploadToPortalDesc.setText("<b>Upload To Portal</b>");
			uploadToPortalDesc.setBounds(650, 55, 170, 20);
		}
		return uploadToPortalDesc;
	}

	/**
	 * @return the uploadToPortal
	 */
	private CheckBoxBase getUploadToPortal() {
		if (uploadToPortal == null) {
			uploadToPortal = new CheckBoxBase();
			uploadToPortal.setBounds(825, 55, 20, 20);
		}
		return uploadToPortal;
	}

	/**
	 * @return the inpatientBillingRemarkDesc
	 */
	private LabelBase getInpatientBillingRemarkDesc() {
		if (inpatientBillingRemarkDesc == null) {
			inpatientBillingRemarkDesc = new LabelBase();
			inpatientBillingRemarkDesc.setText("<b>In-patient Remark</b>");
			inpatientBillingRemarkDesc.setBounds(0, 5, 150, 25);
		}
		return inpatientBillingRemarkDesc;
	}

	/**
	 * @return the inpatientBillingRemark
	 */
	private TextAreaBase getInpatientBillingRemark() {
		if (inpatientBillingRemark == null) {
			inpatientBillingRemark = new TextAreaBase();
			inpatientBillingRemark.setBounds(0, 30, 300, 220);
		}
		return inpatientBillingRemark;
	}

	/**
	 * @return the outpatientBillingRemarkDesc
	 */
	private LabelBase getOutpatientBillingRemarkDesc() {
		if (outpatientBillingRemarkDesc == null) {
			outpatientBillingRemarkDesc = new LabelBase();
			outpatientBillingRemarkDesc.setText("<b>Out-patient Remark</b>");
			outpatientBillingRemarkDesc.setBounds(325, 5, 150, 25);
		}
		return outpatientBillingRemarkDesc;
	}

	/**
	 * @return the outpatientBillingRemark
	 */
	private TextAreaBase getOutpatientBillingRemark() {
		if (outpatientBillingRemark == null) {
			outpatientBillingRemark = new TextAreaBase();
			outpatientBillingRemark.setBounds(325, 30, 300, 220);
		}
		return outpatientBillingRemark;
	}

	/**
	 * @return the sampleInvoiceButton
	 */
	private ButtonBase getSampleInvoiceButton() {
		if (sampleInvoiceButton == null) {
			sampleInvoiceButton = new ButtonBase("IP Bill Checklist") {
				@Override
				public void onClick() {
					if (memBillSampleInv!=null && memBillSampleInv.length() > 0) {
						memBillSampleInv = memBillSampleInv.replace("&", "%26");
						openNewWindow(getOpenFileURL() + memBillSampleInv);
					}
				}
			};
			sampleInvoiceButton.setBounds(0, 260, 200, 25);
		}
		return sampleInvoiceButton;
	}

	/**
	 * @return the billingOtherDesc
	 */
	private LabelBase getBillingOtherDesc() {
		if (billingOtherDesc == null) {
			billingOtherDesc = new LabelBase();
			billingOtherDesc.setText("<b>Others</b>");
			billingOtherDesc.setBounds(650, 80, 60, 20);;
		}
		return billingOtherDesc;
	}

	/**
	 * @return the billingOther
	 */
	private TextString getBillingOther() {
		if (billingOther == null) {
			billingOther = new TextString();
			billingOther.setBounds(715, 80, 130, 20);
		}
		return billingOther;
	}

	/**
	 * @return the contactPanel
	 */
	private BasePanel getContactPanel() {
		if (contactPanel == null) {
			contactPanel = new BasePanel();
			contactPanel.add(getContactFieldSet1(), null);
			contactPanel.add(getContactFieldSet2(), null);
			contactPanel.add(getInpatientContactRemarkDesc(), null);
			contactPanel.add(getInpatientContactRemark(), null);
			contactPanel.add(getOutpatientContactRemarkDesc(), null);
			contactPanel.add(getOutpatientContactRemark(), null);
		}
		return contactPanel;
	}

	/**
	 * @return the contactFieldSet1
	 */
	private FieldSetBase getContactFieldSet1() {
		if (contactFieldSet1 == null) {
			contactFieldSet1 = new FieldSetBase();
			contactFieldSet1.setHeading("In-patient Contact Detail");
			contactFieldSet1.add(getContactPerson1Desc(), null);
			contactFieldSet1.add(getContactPerson1(), null);
			contactFieldSet1.add(getContactPhoneNo1Desc(), null);
			contactFieldSet1.add(getContactPhoneNo1(), null);
			contactFieldSet1.add(getContactFaxNo1Desc(), null);
			contactFieldSet1.add(getContactFaxNo1(), null);
			contactFieldSet1.add(getContactEmail1Desc(), null);
			contactFieldSet1.add(getContactEmail1(), null);
			contactFieldSet1.add(getOperationHour1Desc(), null);
			contactFieldSet1.add(getOperationHour1(), null);
			contactFieldSet1.setBounds(0, 5, 400, 185);
		}
		return contactFieldSet1;
	}

	/**
	 * @return the contactFieldSet2
	 */
	private FieldSetBase getContactFieldSet2() {
		if (contactFieldSet2 == null) {
			contactFieldSet2 = new FieldSetBase();
			contactFieldSet2.setHeading("Out-patient Contact Detail");
			contactFieldSet2.add(getContactPerson2Desc(), null);
			contactFieldSet2.add(getContactPerson2(), null);
			contactFieldSet2.add(getContactPhoneNo2Desc(), null);
			contactFieldSet2.add(getContactPhoneNo2(), null);
			contactFieldSet2.add(getContactFaxNo2Desc(), null);
			contactFieldSet2.add(getContactFaxNo2(), null);
			contactFieldSet2.add(getContactEmail2Desc(), null);
			contactFieldSet2.add(getContactEmail2(), null);
			contactFieldSet2.add(getOperationHour2Desc(), null);
			contactFieldSet2.add(getOperationHour2(), null);
			contactFieldSet2.setBounds(425, 5, 400, 185);
		}
		return contactFieldSet2;
	}

	/**
	 * @return the contactPerson1Desc
	 */
	private LabelBase getContactPerson1Desc() {
		if (contactPerson1Desc == null) {
			contactPerson1Desc = new LabelBase();
			contactPerson1Desc.setText("<b>Contact Person</b>");
			contactPerson1Desc.setBounds(5, 0, 130, 15);
		}
		return contactPerson1Desc;
	}

	/**
	 * @return the contactPerson1
	 */
	private TextString getContactPerson1() {
		if (contactPerson1 == null) {
			contactPerson1 = new TextString(200);
			contactPerson1.setBounds(140, 0, 250, 20);
		}
		return contactPerson1;
	}

	/**
	 * @return the contactPhoneNo1Desc
	 */
	private LabelBase getContactPhoneNo1Desc() {
		if (contactPhoneNo1Desc == null) {
			contactPhoneNo1Desc = new LabelBase();
			contactPhoneNo1Desc.setText("<b>Contact Phone No.</b>");
			contactPhoneNo1Desc.setBounds(5, 25, 130, 15);
		}
		return contactPhoneNo1Desc;
	}

	/**
	 * @return the contactPhoneNo1
	 */
	private TextString getContactPhoneNo1() {
		if (contactPhoneNo1 == null) {
			contactPhoneNo1 = new TextString();
			contactPhoneNo1.setBounds(140, 25, 250, 20);
		}
		return contactPhoneNo1;
	}

	/**
	 * @return the contactFaxNo1Desc
	 */
	private LabelBase getContactFaxNo1Desc() {
		if (contactFaxNo1Desc == null) {
			contactFaxNo1Desc = new LabelBase();
			contactFaxNo1Desc.setText("<b>Contact Fax No.</b>");
			contactFaxNo1Desc.setBounds(5, 50, 130, 15);
		}
		return contactFaxNo1Desc;
	}

	/**
	 * @return the contactFaxNo1
	 */
	private TextString getContactFaxNo1() {
		if (contactFaxNo1 == null) {
			contactFaxNo1 = new TextString();
			contactFaxNo1.setBounds(140, 50, 250, 20);
		}
		return contactFaxNo1;
	}

	/**
	 * @return the contactEmail1Desc
	 */
	private LabelBase getContactEmail1Desc() {
		if (contactEmail1Desc == null) {
			contactEmail1Desc = new LabelBase();
			contactEmail1Desc.setText("<b>Contact Email</b>");
			contactEmail1Desc.setBounds(5, 75, 130, 15);
		}
		return contactEmail1Desc;
	}

	/**
	 * @return the contactEmail1
	 */
	private TextString getContactEmail1() {
		if (contactEmail1 == null) {
			contactEmail1 = new TextString();
			contactEmail1.setBounds(140, 75, 250, 20);
		}
		return contactEmail1;
	}

	/**
	 * @return the OperationHour1Desc
	 */
	private LabelBase getOperationHour1Desc() {
		if (operationHour1Desc == null) {
			operationHour1Desc = new LabelBase();
			operationHour1Desc.setText("<b>Operation Hour</b>");
			operationHour1Desc.setBounds(5, 100, 130, 15);
		}
		return operationHour1Desc;
	}

	/**
	 * @return the OperationHour1
	 */
	private TextString getOperationHour1() {
		if (operationHour1 == null) {
			operationHour1 = new TextString();
			operationHour1.setBounds(140, 100, 250, 20);
		}
		return operationHour1;
	}

	/**
	 * @return the contactPerson2Desc
	 */
	private LabelBase getContactPerson2Desc() {
		if (contactPerson2Desc == null) {
			contactPerson2Desc = new LabelBase();
			contactPerson2Desc.setText("<b>Contact Person</b>");
			contactPerson2Desc.setBounds(5, 0, 130, 15);
		}
		return contactPerson2Desc;
	}

	/**
	 * @return the contactPerson2
	 */
	private TextString getContactPerson2() {
		if (contactPerson2 == null) {
			contactPerson2 = new TextString(200);
			contactPerson2.setBounds(140, 0, 250, 20);
		}
		return contactPerson2;
	}

	/**
	 * @return the contactPhoneNo2Desc
	 */
	private LabelBase getContactPhoneNo2Desc() {
		if (contactPhoneNo2Desc == null) {
			contactPhoneNo2Desc = new LabelBase();
			contactPhoneNo2Desc.setText("<b>Contact Phone No.</b>");
			contactPhoneNo2Desc.setBounds(5, 25, 130, 15);
		}
		return contactPhoneNo2Desc;
	}

	/**
	 * @return the contactPhoneNo2
	 */
	private TextString getContactPhoneNo2() {
		if (contactPhoneNo2 == null) {
			contactPhoneNo2 = new TextString();
			contactPhoneNo2.setBounds(140, 25, 250, 20);
		}
		return contactPhoneNo2;
	}

	/**
	 * @return the contactFaxNo2Desc
	 */
	private LabelBase getContactFaxNo2Desc() {
		if (contactFaxNo2Desc == null) {
			contactFaxNo2Desc = new LabelBase();
			contactFaxNo2Desc.setText("<b>Contact Fax No.</b>");
			contactFaxNo2Desc.setBounds(5, 50, 130, 15);
		}
		return contactFaxNo2Desc;
	}

	/**
	 * @return the contactFaxNo2
	 */
	private TextString getContactFaxNo2() {
		if (contactFaxNo2 == null) {
			contactFaxNo2 = new TextString();
			contactFaxNo2.setBounds(140, 50, 250, 20);
		}
		return contactFaxNo2;
	}

	/**
	 * @return the contactEmail2Desc
	 */
	private LabelBase getContactEmail2Desc() {
		if (contactEmail2Desc == null) {
			contactEmail2Desc = new LabelBase();
			contactEmail2Desc.setText("<b>Contact Email</b>");
			contactEmail2Desc.setBounds(5, 75, 130, 15);
		}
		return contactEmail2Desc;
	}

	/**
	 * @return the contactEmail2
	 */
	private TextString getContactEmail2() {
		if (contactEmail2 == null) {
			contactEmail2 = new TextString();
			contactEmail2.setBounds(140, 75, 250, 20);
		}
		return contactEmail2;
	}

	/**
	 * @return the OperationHour2Desc
	 */
	private LabelBase getOperationHour2Desc() {
		if (operationHour2Desc == null) {
			operationHour2Desc = new LabelBase();
			operationHour2Desc.setText("<b>Operation Hour</b>");
			operationHour2Desc.setBounds(5, 100, 130, 15);
		}
		return operationHour2Desc;
	}

	/**
	 * @return the OperationHour2
	 */
	private TextString getOperationHour2() {
		if (operationHour2 == null) {
			operationHour2 = new TextString();
			operationHour2.setBounds(140, 100, 250, 20);
		}
		return operationHour2;
	}

	/**
	 * @return the inpatientContactRemarkDesc
	 */
	private LabelBase getInpatientContactRemarkDesc() {
		if (inpatientContactRemarkDesc == null) {
			inpatientContactRemarkDesc = new LabelBase();
			inpatientContactRemarkDesc.setText("<b>In-patient Remark</b>");
			inpatientContactRemarkDesc.setBounds(5, 195, 150, 20);
		}
		return inpatientContactRemarkDesc;
	}

	/**
	 * @return the inpatientContactRemark
	 */
	private TextAreaBase getInpatientContactRemark() {
		if (inpatientContactRemark == null) {
			inpatientContactRemark = new TextAreaBase();
			inpatientContactRemark.setBounds(0, 220, 400, 120);
		}
		return inpatientContactRemark;
	}

	/**
	 * @return the outpatientContactRemarkDesc
	 */
	private LabelBase getOutpatientContactRemarkDesc() {
		if (outpatientContactRemarkDesc == null) {
			outpatientContactRemarkDesc = new LabelBase();
			outpatientContactRemarkDesc.setText("<b>Out-patient Remark</b>");
			outpatientContactRemarkDesc.setBounds(430, 195, 150, 25);
		}
		return outpatientContactRemarkDesc;
	}

	/**
	 * @return the outpatientContactRemark
	 */
	private TextAreaBase getOutpatientContactRemark() {
		if (outpatientContactRemark == null) {
			outpatientContactRemark = new TextAreaBase();
			outpatientContactRemark.setBounds(425, 220, 400, 120);
		}
		return outpatientContactRemark;
	}

	private DlgARCardTypeSel getDlgARCardTypeSel() {
		if (dlgARCardTypeSel == null) {
			dlgARCardTypeSel = new DlgARCardTypeSel(Factory.getInstance().getMainFrame(),"ARCardLink")  {
				@Override
				public void noCardSelection() {
//					getArCode().setText(getArCodeSearch().getText());
//					getArName().setText(getArCodeSearch().getValue().get(ONE_VALUE).toString());
					getAppendButton().setEnabled(adminOnly);
					PanelUtil.resetAllTabbedPanelFields(getTabbedPanel());
				}

				@Override
				public void setVisible(boolean visible) {
					super.setVisible(visible);
					//getTpRadio_Card1().
				}

				@Override
				public void post(String ArcCode,final String ARCardType, String ARCardName,
						String ARCardDesc, String ARCardCode) {
					setCardPhotoHelper(getCardPhoto(), getCardPhotoFrame(), ARCardName);
					getArCode().setText(ArcCode);
					memArcCode = ArcCode;
//					getArName().setText(ARCardName);
					QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] {"arcode", "ARCNAME", "arccode = '" + memArcCode + "'"},
							new MessageQueueCallBack() {
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								getArName().setText(mQueue.getContentField()[0]);
							}
						}
					});

					getCardTypeCode().setText(ARCardCode);
					getCardTypeDescription().setText(ARCardDesc);
					memActID = ARCardType;
					mdmARCardName = ARCardName;
					memIpUrl = null;
					memOpUrl = null;
					memInpExclu = null;
					memOutExclu = null;
					memInVouch = null;
					memOutVouch = null;
					memInClaim = null;
					memOutClaim = null;
					memInNameList = null;
					memOutNameList = null;
					memInPreAuth = null;
					memOutPreAuth = null;
					memOutMemo = null;
					memBillSampleInv = null;
					memInPolicySample = null;
					memOutPolicySample = null;
					memInAcknowForm = null;

					QueryUtil.executeMasterBrowse(getUserInfo(), "ARCARDLINKDTL",
							new String[] { ARCardType },
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								getInpatientRegistrationRemark().setText(mQueue.getContentField()[0]); // ACTYPE.ACTREGRMKIP
								getOutpatientRegistrationRemark().setText(mQueue.getContentField()[1]); // ACTYPE.ACTREGRMKOP
								getInpatientPaymentRemark().setText(mQueue.getContentField()[2]); // ACTYPE.ACTPAYRMKIP
								getOutpatientPaymentRemark().setText(mQueue.getContentField()[3]); // ACTYPE.ACTPAYRMKOP
								memIpUrl = mQueue.getContentField()[4]; // ACTYPE.REGRMKIPURL
								memOpUrl = mQueue.getContentField()[5]; // ACTYPE.REGRMKOPURL

								if (memIpUrl != null && memIpUrl.length() > 0) {
									getWebsiteUrlIp().setText(memIpUrl);
								} else {
									getWebsiteUrlIp().setText(memIpUrl);
									getInpatientWebSiteAddressButton().setEnabled(false);
								}
								if (memOpUrl != null && memOpUrl.length() > 0) {
									getWebsiteUrlOp().setText(memOpUrl);
								} else {
									getWebsiteUrlOp().setText(memOpUrl);
									getOutpatientWebSiteAddressButton().setEnabled(false);
								}
								memInpExclu = mQueue.getContentField()[8]; // ACTERMIN.EXCLUSION AS EXCLUSIN
								memOutExclu = mQueue.getContentField()[9]; // ACTERMOUT.EXCLUSION AS EXCLUSOUT
								if (memInpExclu != null && memInpExclu.length() > 0) {
									getExclusionUrlIp().setText(memInpExclu);
								} else {
									getExclusionUrlIp().setText(memInpExclu);
									getInpatientExclusionsButton().setEnabled(false);
								}
								if (memOutExclu != null && memOutExclu.length() > 0) {
									getExclusionUrlOp().setText(memOutExclu);
								} else {
									getExclusionUrlOp().setText(memOutExclu);
									getOutpatientExclusionsButton().setEnabled(false);
								}
								memInVouch = mQueue.getContentField()[10]; // ACTERMIN.VOUCHER AS VOUCHERIN,
								memOutVouch = mQueue.getContentField()[11]; // ACTERMOUT.VOUCHER AS VOUCHEROUT,
								if (memInVouch != null && memInVouch.length() > 0) {
									getVoucherUrlIp().setText(memInVouch);
								} else {
									getVoucherUrlIp().setText(memInVouch);
									getInpatientVoucherButton().setEnabled(false);
								}
								if (memOutVouch != null && memOutVouch.length() > 0) {
									getVoucherUrlOp().setText(memOutVouch);
								} else {
									getVoucherUrlOp().setText(memOutVouch);
									getOutpatientVoucherButton().setEnabled(false);
								}
								memInClaim = mQueue.getContentField()[12]; // ACTERMIN.CLAIM_FORM AS CLAIMIN,
								memOutClaim = mQueue.getContentField()[13]; // ACTERMOUT.CLAIM_FORM AS CLAIMOUT,
								if (memInClaim != null && memInClaim.length() > 0) {
									getClaimFormUrlIp().setText(memInClaim);
								} else {
									getClaimFormUrlIp().setText(memInClaim);
									getInpatientClaimFormLinkButton().setEnabled(false);
								}
								if (memOutClaim != null && memOutClaim.length() > 0) {
									getClaimFormUrlOp().setText(memOutClaim);
								} else {
									getClaimFormUrlOp().setText(memOutClaim);
									getOutpatientClaimFormLinkButton().setEnabled(false);
								}
								memInNameList = mQueue.getContentField()[14]; // ACTERMIN.NAME_LIST AS NAMELISTIN,
								memOutNameList = mQueue.getContentField()[15]; // ACTERMOUT.NAME_LIST AS NAMELISTOUT,
								if (memInNameList != null && memInNameList.length() > 0) {
									getNameListUrlIp().setText(memInNameList);
								} else {
									getNameListUrlIp().setText(memInNameList);
									getInpatientNameListCardorPolicySampleButton().setEnabled(false);
								}
								if (memOutNameList != null && memOutNameList.length() > 0) {
									getNameListUrlOp().setText(memOutNameList);
								} else {
									getNameListUrlOp().setText(memOutNameList);
									getOutpatientNameListCardorPolicySampleButton().setEnabled(false);
								}
								memInPreAuth = mQueue.getContentField()[16]; // ACTERMIN.PRE_AUTHORISE_FORM AS PREAUTHIN,
								memOutPreAuth = mQueue.getContentField()[17]; // ACTERMOUT.PRE_AUTHORISE_FORM AS PREAUTHOUT,
								if (memInPreAuth != null && memInPreAuth.length() > 0) {
									getPreAuthFormUrlIp().setText(memInPreAuth);
								} else {
									getPreAuthFormUrlIp().setText(memInPreAuth);
									getInpatientPreAuthorisationFormButton().setEnabled(false);
								}
								if (memOutPreAuth != null && memOutPreAuth.length() > 0) {
									getPreAuthFormUrlOp().setText(memOutPreAuth);
								} else {
									getPreAuthFormUrlOp().setText(memOutPreAuth);
									getOutpatientPreAuthorisationFormButton().setEnabled(false);
								}
//								memInMemo = mQueue.getContentField()[18]; // ACTERMIN.PRE_AUTHORISATION_MEMO AS MEMEOIN,
								memOutMemo = mQueue.getContentField()[19]; // ACTERMOUT.PRE_AUTHORISATION_MEMO AS MEMOOUT,
								if (memOutMemo != null && memOutMemo.length() > 0) {
									getMemoToDocUrlOp().setText(memOutMemo);
								} else {
									getMemoToDocUrlOp().setText(memOutMemo);
									getOutpatientPreAuthorisationMemoToDoctorButton().setEnabled(false);
								}
								getInpatientContactRemark().setText(mQueue.getContentField()[20]); // ACTERMIN.REMARKS AS CONTACTRMKIN,
								getOutpatientContactRemark().setText(mQueue.getContentField()[21]); // ACTERMIN.REMARKS AS CONTACTRMKOUT,
								getContactPerson1().setText(mQueue.getContentField()[22]); // ACTERMIN.CONTACT_DETAILS AS CONTACTDTLIN,
								getContactPerson2().setText(mQueue.getContentField()[23]); // ACTERMOUT.CONTACT_DETAILS AS CONTACTDTLOUT,
								getContactPhoneNo1().setText(mQueue.getContentField()[24]); // ACTERMIN.CONTACT_PHONE AS CONTACTPHONEIN,
								getContactPhoneNo2().setText(mQueue.getContentField()[25]); // ACTERMOUT.CONTACT_PHONE AS CONTACTPHONEOUT,
								getContactFaxNo1().setText(mQueue.getContentField()[26]); // ACTERMIN.FAX AS CONTACTFAXIN,
								getContactFaxNo2().setText(mQueue.getContentField()[27]); // ACTERMOUT.FAX AS CONTACTFAXOUT
								getInpatientBillingRemark().setText(mQueue.getContentField()[28]); // ACTERMIN.BILLREMARKS AS BILLRMKIP
								getOutpatientBillingRemark().setText(mQueue.getContentField()[29]); //ACTERMOUT.BILLREMARKS AS BILLRMKOP
								geteBilling().setSelected(MINUS_ONE_VALUE.equals(mQueue.getContentField()[30])); //ACTYPE.EBILLING
								getSendOriginalBills().setSelected(MINUS_ONE_VALUE.equals(mQueue.getContentField()[31])); //ACTYPE.SENDORGINV
								memBillSampleInv = mQueue.getContentField()[32]; //ACTYPE.SAMPLEINV
								if (memBillSampleInv != null && memBillSampleInv.length() > 0) {
									getBillSampInvUrl().setText(memBillSampleInv);
								} else {
									getBillSampInvUrl().setText(memBillSampleInv);
									getSampleInvoiceButton().setEnabled(false);
								}
								getInpatientExclusionsRemark().setText(mQueue.getContentField()[33]); //ACTERMIN.EXCLUSIONREMARKS
								getOutpatientExclusionsRemark().setText(mQueue.getContentField()[34]); //ACTERMOUT.EXCLUSIONREMARKS
								getContactEmail1().setText(mQueue.getContentField()[35]); // ACTERMIN.CONTACT_EMAIL
								getContactEmail2().setText(mQueue.getContentField()[36]); // ACTERMOUT.CONTACT_EMAIL
								getEffectiveDate().setText(mQueue.getContentField()[37]); // ACTYPE.ARCARDSDATE
								getTerminationDate().setText(mQueue.getContentField()[38]); // ACTYPE.ARCARDEDATE
								getActive().setSelected(MINUS_ONE_VALUE.equals(mQueue.getContentField()[39])); //ACTYPE.ACTACTIVE
								getUploadToPortal().setSelected(MINUS_ONE_VALUE.equals(mQueue.getContentField()[40])); //ACTYPE.UPLOADTOPORTAL
								getBillingOther().setText(mQueue.getContentField()[41]); //ACTYPE.BILLINGOTHER
								memInPolicySample = mQueue.getContentField()[42]; //ACTERMIN.POLICYSAMPLE
								memOutPolicySample = mQueue.getContentField()[43]; //ACTERMOP.POLICYSAMPLE
								getOperationHour1().setText(mQueue.getContentField()[44]);  //ACTERMIN.OFC_HOUR
								getOperationHour2().setText(mQueue.getContentField()[45]); //ACTERMIN.OFC_HOUR

								if (memInPolicySample != null && memInPolicySample.length() > 0) {
									getPaSampleUrlIp().setText(memInPolicySample);
								} else {
									getPaSampleUrlIp().setText(memInPolicySample);
									getInpatientLogPASampleButton().setEnabled(false);
								}
								if (memOutPolicySample != null && memOutPolicySample.length() > 0) {
									getPaSampleUrlOp().setText(memOutPolicySample);
								} else {
									getPaSampleUrlOp().setText(memOutPolicySample);
									getOutpatientLogPASampleButton().setEnabled(false);
								}
								memInAcknowForm = mQueue.getContentField()[46]; // ACTERMIN.ACKNOWLEDGE_FORM AS ACKNOWIN,
//								memOutAcknowForm = mQueue.getContentField()[47]; // ACTERMOUT.ACKNOWLEDGE_FORM AS ACKNOWOUT,
								if (memInAcknowForm != null && memInAcknowForm.length() > 0) {
									getAcknowFormUrlIp().setText(memInAcknowForm);
								} else {
									getAcknowFormUrlIp().setText(memInAcknowForm);
									getInpatientAcknowledgementAdmissionFormButton().setEnabled(false);
								}
//								getAcknowFormUrlOp().setText(memOutAcknowForm);

								memInDtlPro= mQueue.getContentField()[47]; //ACTERMOP.DTL_PROCEDURES
								if (memInDtlPro != null && memInDtlPro.length() > 0) {
									getDetailedProceduresIp().setText(memInDtlPro);
								} else {
									getDetailedProceduresIp().setText(memInDtlPro);
									getInpatientDetailedProceduresButton().setEnabled(false);
								}

								memOutDtlPro= mQueue.getContentField()[48]; //ACTERMOP.DTL_PROCEDURES
								if (memOutDtlPro != null && memOutDtlPro.length() > 0) {
									getDetailedProceduresOp().setText(memOutDtlPro);
								} else {
									getDetailedProceduresOp().setText(memOutDtlPro);
									getOutpatientDetailedProceduresButton().setEnabled(false);
								}

								bottonControlbByURL();

								String colour1 = mQueue.getContentField()[6]; // ACTYPE.COLOUR1
								if (!(colour1==null)) {
									getColour1().setText(colour1);
								}

								String colour2 = mQueue.getContentField()[7]; // ACTYPE.COLOUR2
								if (!(colour2==null)) {
									getColour2().setText(colour2);
								}

								QueryUtil.executeMasterBrowse(getUserInfo(), "ARCOVERAGE",
										new String[] { ARCardType },
										new MessageQueueCallBack() {
									@Override
									public void onPostSuccess(MessageQueue mQueue) {
										if (mQueue.success()) {
											memHealthExam = mQueue.getContentField()[2];
											memImmunization = mQueue.getContentField()[3];
											memPrePostNatal = mQueue.getContentField()[4];
											memOtherCoverageType = mQueue.getContentField()[5];
											memOtherCoverage = mQueue.getContentField()[6];

											getHealthExam().setText(mQueue.getContentField()[2]); //COV.HEALTHTEXT,
											getImmunization().setText(mQueue.getContentField()[3]); //COV.IMMUNIZATIONTEXT,
											getPrePostNatal().setText(mQueue.getContentField()[4]); //COV.PRENATALTEXT,
											getOtherCoverageType().setText(mQueue.getContentField()[5]); //COV.COVERATE,
											getOtherCoverage().setText(mQueue.getContentField()[6]); //COV.WBTEXT
										}
									}
								});

								// set general exclusive
								getOutpatientGeneralExclusionsTableList().setListTableContent("AREXCLUSIONSLIST", new String[] {ARCardType});
								getOutpatientInsuranceOptionsTableList().setListTableContent("ARCHECKLISTLIST", new String[] {ARCardType,"Out",null});
								getInpatientGeneralExclusionsTableList().setListTableContent("AREXCLUSIONSLIST", new String[] {ARCardType});
								getInpatientInsuranceOptionsTableList().setListTableContent("ARCHECKLISTLIST", new String[] {ARCardType,"In",null});
							} else {
								getColour1().setText(null);
								getColour2().setText(null);
							}
						}
					});

					enableButton();
					getAppendButton().setEnabled(adminOnly);

					/*
					if (ARCardType != null && ARCardType.trim().length() > 0) {
						memActID = ARCardType;
					} else {
						memActID = EMPTY_VALUE;
					}
					getRightJText_ARCardType().setText(ARCardName);

					if (memActID.length() > 0) {
						getDlgARCardRemark().showDialog(null, ArcCode, memActID, slipType, true, true);
					} else {
						getRightJText_PolicyNo().focus();
					}
					*/
				}

				@Override
				public void dispose() {
					super.dispose();
					PanelUtil.resetAllTabbedPanelFields(getTabbedPanel());
					if (memArcCode==null||"".equals(memArcCode)) {
						final String arccode = arCodeSearch.getText().trim().toUpperCase();
						QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
								new String[] {"arcode", "ARCNAME", "arccode = '" + arccode + "'"},
								new MessageQueueCallBack() {
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									memArcCode = arccode;
									getArCode().setText(arccode);
									getArName().setText(mQueue.getContentField()[0]);
									getAppendButton().setEnabled(adminOnly);
								}
							}
						});
					}
				}
			};
		}

		return dlgARCardTypeSel;
	}

	/**
	 * @return the contactPanel
	 */
	private BasePanel getAdminPanel() {
		if (adminPanel == null) {
			adminPanel = new BasePanel();
			adminPanel.add(getAdminFieldSetIp(), null);
			adminPanel.add(getAdminFieldSetOp(), null);
			adminPanel.add(getBillSampInvUrlDesc(), null);
			adminPanel.add(getBillSampInvUrl(), null);
		}
		return adminPanel;
	}

	/**
	 * @return the adminFieldSetIp
	 */
	private FieldSetBase getAdminFieldSetIp() {
		if (adminFieldSetIp == null) {
			adminFieldSetIp = new FieldSetBase();
			adminFieldSetIp.setHeading("In-patient");
			adminFieldSetIp.add(getWebsiteUrlIp(), null);
			adminFieldSetIp.add(getWebsiteUrlIpDesc(), null);
			adminFieldSetIp.add(getVoucherUrlIp(), null);
			adminFieldSetIp.add(getVoucherUrlIpDesc(), null);
			adminFieldSetIp.add(getClaimFormUrlIp(), null);
			adminFieldSetIp.add(getClaimFormUrlIpDesc(), null);
			adminFieldSetIp.add(getNameListUrlIp(), null);
			adminFieldSetIp.add(getNameListUrlIpDesc(), null);
			adminFieldSetIp.add(getAcknowFormUrlIpDesc(), null);
			adminFieldSetIp.add(getAcknowFormUrlIp(), null);
			adminFieldSetIp.add(getPreAuthFormUrlIpDesc(), null);
			adminFieldSetIp.add(getPreAuthFormUrlIp(), null);
			adminFieldSetIp.add(getMemoToDocUrlIpDesc(), null);
			adminFieldSetIp.add(getMemoToDocUrlIp(), null);
			adminFieldSetIp.add(getExclusionUrlIpDesc(), null);
			adminFieldSetIp.add(getExclusionUrlIp(), null);
			adminFieldSetIp.add(getPaSampleUrlIpDesc(), null);
			adminFieldSetIp.add(getPaSampleUrlIp(), null);
			adminFieldSetIp.add(getDetailedProceduresIpDesc(), null);
			adminFieldSetIp.add(getDetailedProceduresIp(), null);
			adminFieldSetIp.setBounds(0, 5, 400, 290);
		}
		return adminFieldSetIp;
	}

	/**
	 * @return the webSiteUrlIpDesc
	 */
	private LabelBase getWebsiteUrlIpDesc() {
		if (webSiteUrlIpDesc == null) {
			webSiteUrlIpDesc = new LabelBase();
			webSiteUrlIpDesc.setText("<b>Website</b>");
			webSiteUrlIpDesc.setBounds(5, 5, 115, 15);
		}
		return webSiteUrlIpDesc;
	}

	/**
	 * @return the webSiteUrlIp
	 */
	private TextString getWebsiteUrlIp() {
		if (webSiteUrlIp == null) {
			webSiteUrlIp = new TextString(200, false);
			webSiteUrlIp.setBounds(120, 5, 270, 20);
		}
		return webSiteUrlIp;
	}

	/**
	 * @return the voucherUrlIpDesc
	 */
	private LabelBase getVoucherUrlIpDesc() {
		if (voucherUrlIpDesc == null) {
			voucherUrlIpDesc = new LabelBase();
			voucherUrlIpDesc.setText("<b>Voucher</b>");
			voucherUrlIpDesc.setBounds(5, 30, 115, 15);
		}
		return voucherUrlIpDesc;
	}

	/**
	 * @return the voucherUrlIp
	 */
	private TextString getVoucherUrlIp() {
		if (voucherUrlIp == null) {
			voucherUrlIp = new TextString(200, false);
			voucherUrlIp.setBounds(120, 30, 270, 20);
		}
		return voucherUrlIp;
	}

	/**
	 * @return the claimFormUrlIpDesc
	 */
	private LabelBase getClaimFormUrlIpDesc() {
		if (claimFormUrlIpDesc == null) {
			claimFormUrlIpDesc = new LabelBase();
			claimFormUrlIpDesc.setText("<b>Claim Form</b>");
			claimFormUrlIpDesc.setBounds(5, 55, 115, 15);
		}
		return claimFormUrlIpDesc;
	}

	/**
	 * @return the claimFormUrlIp
	 */
	private TextString getClaimFormUrlIp() {
		if (claimFormUrlIp == null) {
			claimFormUrlIp = new TextString(200, false);
			claimFormUrlIp.setBounds(120, 55, 270, 20);
		}
		return claimFormUrlIp;
	}

	/**
	 * @return the nameListUrlIpDesc
	 */
	private LabelBase getNameListUrlIpDesc() {
		if (nameListUrlIpDesc == null) {
			nameListUrlIpDesc = new LabelBase();
			nameListUrlIpDesc.setText("<b>Name List</b>");
			nameListUrlIpDesc.setBounds(5, 80, 115, 15);
		}
		return nameListUrlIpDesc;
	}

	/**
	 * @return the nameListUrlIp
	 */
	private TextString getNameListUrlIp() {
		if (nameListUrlIp == null) {
			nameListUrlIp = new TextString(200, false);
			nameListUrlIp.setBounds(120, 80, 270, 20);
		}
		return nameListUrlIp;
	}

	/**
	 * @return the acknowFormUrlIpDesc
	 */
	private LabelBase getAcknowFormUrlIpDesc() {
		if (acknowFormUrlIpDesc == null) {
			acknowFormUrlIpDesc = new LabelBase();
			acknowFormUrlIpDesc.setText("<b>Acknowledgement</b>");
			acknowFormUrlIpDesc.setBounds(5, 205, 115, 15);
		}
		return acknowFormUrlIpDesc;
	}

	/**
	 * @return the acknowFormUrlIp
	 */
	private TextString getAcknowFormUrlIp() {
		if (acknowFormUrlIp == null) {
			acknowFormUrlIp = new TextString(200, false);
			acknowFormUrlIp.setBounds(120, 205, 270, 20);
		}
		return acknowFormUrlIp;
	}

	/**
	 * @return the preAuthFormUrlIpDesc
	 */
	private LabelBase getPreAuthFormUrlIpDesc() {
		if (preAuthFormUrlIpDesc == null) {
			preAuthFormUrlIpDesc = new LabelBase();
			preAuthFormUrlIpDesc.setText("<b>Pre-Auth Form</b>");
			preAuthFormUrlIpDesc.setBounds(5, 105, 115, 15);
		}
		return preAuthFormUrlIpDesc;
	}

	/**
	 * @return the preAuthFormUrlIp
	 */
	private TextString getPreAuthFormUrlIp() {
		if (preAuthFormUrlIp == null) {
			preAuthFormUrlIp = new TextString(200, false);
			preAuthFormUrlIp.setBounds(120, 105, 270, 20);
		}
		return preAuthFormUrlIp;
	}

	/**
	 * @return the memoToDocUrlIpDesc
	 */
	private LabelBase getMemoToDocUrlIpDesc() {
		if (memoToDocUrlIpDesc == null) {
			memoToDocUrlIpDesc = new LabelBase();
			memoToDocUrlIpDesc.setText("<b>Memo To Doctor</b>");
			memoToDocUrlIpDesc.setBounds(5, 130, 115, 15);
		}
		return memoToDocUrlIpDesc;
	}

	/**
	 * @return the memoToDocUrlIp
	 */
	private TextString getMemoToDocUrlIp() {
		if (memoToDocUrlIp == null) {
			memoToDocUrlIp = new TextString(200, false);
			memoToDocUrlIp.setBounds(120, 130, 270, 20);
		}
		return memoToDocUrlIp;
	}

	/**
	 * @return the exclusionUrlIpDesc
	 */
	private LabelBase getExclusionUrlIpDesc() {
		if (exclusionUrlIpDesc == null) {
			exclusionUrlIpDesc = new LabelBase();
			exclusionUrlIpDesc.setText("<b>Exclusions</b>");
			exclusionUrlIpDesc.setBounds(5, 155, 115, 15);
		}
		return exclusionUrlIpDesc;
	}

	/**
	 * @return the exclusionUrlIp
	 */
	private TextString getExclusionUrlIp() {
		if (exclusionUrlIp == null) {
			exclusionUrlIp = new TextString(200, false);
			exclusionUrlIp.setBounds(120, 155, 270, 20);
		}
		return exclusionUrlIp;
	}

	/**
	 * @return the paSampleUrlIpDesc
	 */
	private LabelBase getPaSampleUrlIpDesc() {
		if (paSampleUrlIpDesc == null) {
			paSampleUrlIpDesc = new LabelBase();
			paSampleUrlIpDesc.setText("<b>Log/PA Sample</b>");
			paSampleUrlIpDesc.setBounds(5, 180, 115, 15);
		}
		return paSampleUrlIpDesc;
	}

	/**
	 * @return the paSampleUrlIp
	 */
	private TextString getPaSampleUrlIp() {
		if (paSampleUrlIp == null) {
			paSampleUrlIp = new TextString(200);
			paSampleUrlIp.setBounds(120, 180, 270, 20);
		}
		return paSampleUrlIp;
	}

	/**
	 * @return the detailedProceduresIpDesc
	 */
	private LabelBase getDetailedProceduresIpDesc() {
		if (detailedProceduresIpDesc == null) {
			detailedProceduresIpDesc = new LabelBase();
			detailedProceduresIpDesc.setText("<b>Detailed Procedures</b>");
			detailedProceduresIpDesc.setBounds(5, 230, 115, 15);
		}
		return detailedProceduresIpDesc;
	}

	/**
	 * @return the detailedProceduresIp
	 */
	private TextString getDetailedProceduresIp() {
		if (detailedProceduresIp == null) {
			detailedProceduresIp = new TextString(200);
			detailedProceduresIp.setBounds(120, 230, 270, 20);
		}
		return detailedProceduresIp;
	}

	/**
	 * @return the adminFieldSetOp
	 */
	private FieldSetBase getAdminFieldSetOp() {
		if (adminFieldSetOp == null) {
			adminFieldSetOp = new FieldSetBase();
			adminFieldSetOp.setHeading("Out-patient");
			adminFieldSetOp.add(getWebsiteUrlOp(), null);
			adminFieldSetOp.add(getWebsiteUrlOpDesc(), null);
			adminFieldSetOp.add(getVoucherUrlOp(), null);
			adminFieldSetOp.add(getVoucherUrlOpDesc(), null);
			adminFieldSetOp.add(getClaimFormUrlOp(), null);
			adminFieldSetOp.add(getClaimFormUrlOpDesc(), null);
			adminFieldSetOp.add(getNameListUrlOp(), null);
			adminFieldSetOp.add(getNameListUrlOpDesc(), null);
//			adminFieldSetOp.add(getAcknowFormUrlOpDesc(), null);
//			adminFieldSetOp.add(getAcknowFormUrlOp(), null);
			adminFieldSetOp.add(getPreAuthFormUrlOpDesc(), null);
			adminFieldSetOp.add(getPreAuthFormUrlOp(), null);
			adminFieldSetOp.add(getMemoToDocUrlOpDesc(), null);
			adminFieldSetOp.add(getMemoToDocUrlOp(), null);
			adminFieldSetOp.add(getExclusionUrlOpDesc(), null);
			adminFieldSetOp.add(getExclusionUrlOp(), null);
			adminFieldSetOp.add(getPaSampleUrlOpDesc(), null);
			adminFieldSetOp.add(getPaSampleUrlOp(), null);
			adminFieldSetOp.add(getDetailedProceduresOpDesc(), null);
			adminFieldSetOp.add(getDetailedProceduresOp(), null);
			adminFieldSetOp.setBounds(425, 5, 400, 290);
		}
		return adminFieldSetOp;
	}

	/**
	 * @return the webSiteUrlOpDesc
	 */
	private LabelBase getWebsiteUrlOpDesc() {
		if (webSiteUrlOpDesc == null) {
			webSiteUrlOpDesc = new LabelBase();
			webSiteUrlOpDesc.setText("<b>Website</b>");
			webSiteUrlOpDesc.setBounds(5, 5, 115, 15);
		}
		return webSiteUrlOpDesc;
	}

	/**
	 * @return the webSiteUrlOp
	 */
	private TextString getWebsiteUrlOp() {
		if (webSiteUrlOp == null) {
			webSiteUrlOp = new TextString(200, false);
			webSiteUrlOp.setBounds(120, 5, 270, 20);
		}
		return webSiteUrlOp;
	}

	/**
	 * @return the voucherUrlOpDesc
	 */
	private LabelBase getVoucherUrlOpDesc() {
		if (voucherUrlOpDesc == null) {
			voucherUrlOpDesc = new LabelBase();
			voucherUrlOpDesc.setText("<b>Voucher</b>");
			voucherUrlOpDesc.setBounds(5, 30, 115, 15);
		}
		return voucherUrlOpDesc;
	}

	/**
	 * @return the voucherUrlOp
	 */
	private TextString getVoucherUrlOp() {
		if (voucherUrlOp == null) {
			voucherUrlOp = new TextString(200, false);
			voucherUrlOp.setBounds(120, 30, 270, 20);
		}
		return voucherUrlOp;
	}

	/**
	 * @return the claimFormUrlOpDesc
	 */
	private LabelBase getClaimFormUrlOpDesc() {
		if (claimFormUrlOpDesc == null) {
			claimFormUrlOpDesc = new LabelBase();
			claimFormUrlOpDesc.setText("<b>Claim Form</b>");
			claimFormUrlOpDesc.setBounds(5, 55, 115, 15);
		}
		return claimFormUrlOpDesc;
	}

	/**
	 * @return the claimFormUrlOp
	 */
	private TextString getClaimFormUrlOp() {
		if (claimFormUrlOp == null) {
			claimFormUrlOp = new TextString(200, false);
			claimFormUrlOp.setBounds(120, 55, 270, 20);
		}
		return claimFormUrlOp;
	}

	/**
	 * @return the nameListUrlOpDesc
	 */
	private LabelBase getNameListUrlOpDesc() {
		if (nameListUrlOpDesc == null) {
			nameListUrlOpDesc = new LabelBase();
			nameListUrlOpDesc.setText("<b>Name List</b>");
			nameListUrlOpDesc.setBounds(5, 80, 115, 15);
		}
		return nameListUrlOpDesc;
	}

	/**
	 * @return the nameListUrlOp
	 */
	private TextString getNameListUrlOp() {
		if (nameListUrlOp == null) {
			nameListUrlOp = new TextString(200, false);
			nameListUrlOp.setBounds(120, 80, 270, 20);
		}
		return nameListUrlOp;
	}

	/**
	 * @return the acknowFormUrlIpDesc
	 */
/*
	private LabelBase getAcknowFormUrlOpDesc() {
		if (acknowFormUrlOpDesc == null) {
			acknowFormUrlOpDesc = new LabelBase();
			acknowFormUrlOpDesc.setText("Acknowledgement");
			acknowFormUrlOpDesc.setBounds(5, 105, 115, 15);
		}
		return acknowFormUrlOpDesc;
	}
*/
	/**
	 * @return the acknowFormUrlOp
	 */
/*
	private TextString getAcknowFormUrlOp() {
		if (acknowFormUrlOp == null) {
			acknowFormUrlOp = new TextString(200, false);
			acknowFormUrlOp.setBounds(120, 105, 270, 20);
		}
		return acknowFormUrlOp;
	}
*/
	/**
	 * @return the preAuthFormUrlOpDesc
	 */
	private LabelBase getPreAuthFormUrlOpDesc() {
		if (preAuthFormUrlOpDesc == null) {
			preAuthFormUrlOpDesc = new LabelBase();
			preAuthFormUrlOpDesc.setText("<b>Pre-Auth Form</b>");
			preAuthFormUrlOpDesc.setBounds(5, 105, 115, 15);
		}
		return preAuthFormUrlOpDesc;
	}

	/**
	 * @return the preAuthFormUrlOp
	 */
	private TextString getPreAuthFormUrlOp() {
		if (preAuthFormUrlOp == null) {
			preAuthFormUrlOp = new TextString(200, false);
			preAuthFormUrlOp.setBounds(120, 105, 270, 20);
		}
		return preAuthFormUrlOp;
	}

	/**
	 * @return the memoToDocUrlOpDesc
	 */
	private LabelBase getMemoToDocUrlOpDesc() {
		if (memoToDocUrlOpDesc == null) {
			memoToDocUrlOpDesc = new LabelBase();
			memoToDocUrlOpDesc.setText("<b>Memo To Doctor</b>");
			memoToDocUrlOpDesc.setBounds(5, 130, 115, 15);
		}
		return memoToDocUrlOpDesc;
	}

	/**
	 * @return the memoToDocUrlOp
	 */
	private TextString getMemoToDocUrlOp() {
		if (memoToDocUrlOp == null) {
			memoToDocUrlOp = new TextString(200, false);
			memoToDocUrlOp.setBounds(120, 130, 270, 20);
		}
		return memoToDocUrlOp;
	}

	/**
	 * @return the exclusionUrlOpDesc
	 */
	private LabelBase getExclusionUrlOpDesc() {
		if (exclusionUrlOpDesc == null) {
			exclusionUrlOpDesc = new LabelBase();
			exclusionUrlOpDesc.setText("<b>Exclusions</b>");
			exclusionUrlOpDesc.setBounds(5, 155, 115, 15);
		}
		return exclusionUrlOpDesc;
	}

	/**
	 * @return the exclusionUrlOp
	 */
	private TextString getExclusionUrlOp() {
		if (exclusionUrlOp == null) {
			exclusionUrlOp = new TextString(200, false);
			exclusionUrlOp.setBounds(120, 155, 270, 20);
		}
		return exclusionUrlOp;
	}

	/**
	 * @return the billSampInvUrlDesc
	 */
	private LabelBase getBillSampInvUrlDesc() {
		if (billSampInvUrlDesc == null) {
			billSampInvUrlDesc = new LabelBase();
			billSampInvUrlDesc.setText("<b>IP Bill Checklist</b>");
			billSampInvUrlDesc.setBounds(5, 300, 115, 15);
		}
		return billSampInvUrlDesc;
	}

	/**
	 * @return the billSampInvUrl
	 */
	private TextString getBillSampInvUrl() {
		if (billSampInvUrl == null) {
			billSampInvUrl = new TextString(200, false);
			billSampInvUrl.setBounds(120, 300, 270, 20);
		}
		return billSampInvUrl;
	}

	/**
	 * @return the paSampleUrlOpDesc
	 */
	private LabelBase getPaSampleUrlOpDesc() {
		if (paSampleUrlOpDesc == null) {
			paSampleUrlOpDesc = new LabelBase();
			paSampleUrlOpDesc.setText("<b>Log/PA Sample</b>");
			paSampleUrlOpDesc.setBounds(5, 180, 115, 15);
		}
		return paSampleUrlOpDesc;
	}

	/**
	 * @return the paSampleUrlOp
	 */
	private TextString getPaSampleUrlOp() {
		if (paSampleUrlOp == null) {
			paSampleUrlOp = new TextString(200, false);
			paSampleUrlOp.setBounds(120, 180, 270, 20);
		}
		return paSampleUrlOp;
	}


	/**
	 * @return the detailedProceduresOpDesc
	 */
	private LabelBase getDetailedProceduresOpDesc() {
		if (detailedProceduresOpDesc == null) {
			detailedProceduresOpDesc = new LabelBase();
			detailedProceduresOpDesc.setText("<b>Detailed Procedures</b>");
			detailedProceduresOpDesc.setBounds(5, 200, 115, 15);
		}
		return detailedProceduresOpDesc;
	}

	/**
	 * @return the detailedProceduresOp
	 */
	private TextString getDetailedProceduresOp() {
		if (detailedProceduresOp == null) {
			detailedProceduresOp = new TextString(200);
			detailedProceduresOp.setBounds(120, 205, 270, 20);
		}
		return detailedProceduresOp;
	}
}
