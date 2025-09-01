package com.hkah.client.tx.insuranceCard;

import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.event.FieldEvent;
import com.extjs.gxt.ui.client.widget.Component;
import com.google.gwt.event.dom.client.KeyCodes;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboARCompany;
import com.hkah.client.layout.combobox.ComboARNature;
import com.hkah.client.layout.combobox.ComboArPrimComp;
import com.hkah.client.layout.combobox.ComboCoPayRefType;
import com.hkah.client.layout.combobox.ComboSetPrice;
import com.hkah.client.layout.dialog.DlgConHistory;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.TabbedPaneBase;
import com.hkah.client.layout.textfield.TextARCode;
import com.hkah.client.layout.textfield.TextAmount;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextName;
import com.hkah.client.layout.textfield.TextNameChinese;
import com.hkah.client.layout.textfield.TextNum;
import com.hkah.client.layout.textfield.TextPhone;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.ActionPanel;
import com.hkah.client.util.PanelUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class AccountReceivableDetail extends ActionPanel {
	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.ACCOUNT_RECEIVABLE_DETAIL_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.ACCOUNT_RECEIVABLE_DETAIL_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
	// TODO Auto-generated method stub
		return new String[] { };
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] { };
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;
	private ColumnLayout generalPanel = null;
	private FieldSetBase editionHistoryPanel = null;
	private BasePanel billingPanel = null;
	private FieldSetBase extraPanel = null;

	private LabelBase RightJLabel_LastUpdateBy = null;
	private TextReadOnly RightJText_LastUpdateBy = null;
	private LabelBase RightJLabel_LastUpdateDate = null;
	private TextReadOnly RightJText_LastUpdateDate = null;
	private LabelBase RightJLabel_ArActive = null;
	private CheckBoxBase RightCheckBox_ArActive = null;
	private LabelBase RightJLabel_ArInpatient = null;
	private CheckBoxBase RightCheckBox_ArInpatient = null;
	private LabelBase RightJLabel_ArOutpatient = null;
	private CheckBoxBase RightCheckBox_ArOutpatient = null;
	private LabelBase RightJLabel_ArPatientSign = null;
	private CheckBoxBase RightCheckBox_ArPatientSign = null;
	private LabelBase RightJLabel_ArHealthAssessment = null;
	private CheckBoxBase RightCheckBox_ArHealthAssessment = null;
	private LabelBase RightJLabel_ArOthers = null;
	private CheckBoxBase RightCheckBox_ArOthers = null;
	private TextBase RightText_ArOthers = null;
	private LabelBase RightJLabel_PrimaryCompany = null;
	private ComboArPrimComp RightJText_PrimaryCompany = null;
	private LabelBase RightJLabel_NoContractStartDate = null;
	private TextDate RightJText_NoContractStartDate = null;
	private LabelBase RightJLabel_NoContractEndDate = null;
	private TextDate RightJText_NoContractEndDate = null;
	private LabelBase RightJLabel_MstrAR = null;
	private TextARCode RightJText_MstrAR = null;
	private LabelBase RightJLabel_ArPct = null;
	private TextNum RightJText_ArPct = null;

	private LabelBase RightJLabel_ARCode = null;
	private TextARCode RightJText_ARCode = null;
	private LabelBase RightJLabel_ARName = null;
	private TextName RightJText_ARName = null;
	private LabelBase RightJLabel_ARCName = null;
	private TextNameChinese RightJText_ARCName = null;
	private LabelBase RightJLabel_GlCode = null;
	private TextBase RightJText_GlCode = null;
	private LabelBase RightJLabel_ConstractualPrice = null;
	private ComboSetPrice RightJText_ConstractualPrice = null;
	private LabelBase RightJLabel_RefundGlCode = null;
	private TextBase RightJText_RefundGlCode = null;
	private LabelBase RightJLabel_StartDate = null;
	private TextDate RightJText_StartDate = null;
	private LabelBase RightJLabel_TerminationDate = null;
	private TextDate RightJText_TerminationDate = null;

	private LabelBase RightJLabel_ClaimContact_Person = null;
	private TextBase RightJText_ClaimContact_Person = null;
	private LabelBase RightJLabel_ClaimContact_EmailAddress = null;
	private TextBase RightJText_ClaimContact_EmailAddress = null;
	private LabelBase RightJLabel_ClaimContact_Title = null;
	private TextBase RightJText_ClaimContact_Title = null;
	private LabelBase RightJLabel_ClaimContact_Address = null;
	private TextBase RightJText_ClaimContact_Address1 = null;
	private LabelBase RightJLabel_ClaimContact_PhoneNumber = null;
	private TextPhone RightJText_ClaimContact_PhoneNumber = null;
	private TextBase RightJText_ClaimContact_Address2 = null;
	private LabelBase RightJLabel_ClaimContact_FaxNumber = null;
	private TextPhone RightJText_ClaimContact_FaxNumber = null;
	private TextBase RightJText_ClaimContact_Address3 = null;
	private TextBase RightJText_ClaimContact_Address4 = null;

	private TabbedPaneBase jTabbedPane = null;
	private BasePanel RightBasePanel_AdmissionContact = null;
	private LabelBase RightJLabel_AdmissionContact_Person = null;
	private TextBase RightJText_AdmissionContact_Person = null;
	private LabelBase RightJLabel_AdmissionContact_EmailAddress = null;
	private TextBase RightJText_AdmissionContact_EmailAddress = null;
	private LabelBase RightJLabel_AdmissionContact_Title = null;
	private TextBase RightJText_AdmissionContact_Title = null;
	private CheckBoxBase RightCheckBox_AdmissionContract_AdmissionNotice = null;
	private LabelBase RightJLabel_AdmissionContract_AdmissionNotice = null;
	private LabelBase RightJLabel_AdmissionContact_PhoneNumber = null;
	private TextPhone RightJText_AdmissionContact_PhoneNumber = null;
	private LabelBase RightJLabel_AdmissionContact_FaxNumber = null;
	private TextPhone RightJText_AdmissionContact_FaxNumber = null;
	private LabelBase RightJLabel_AdmissionContact_Address = null;
	private TextBase RightJText_AdmissionContact_Address1 = null;
	private TextBase RightJText_AdmissionContact_Address2 = null;
	private TextBase RightJText_AdmissionContact_Address3 = null;
	private TextBase RightJText_AdmissionContact_Address4 = null;

	private BasePanel RightBasePanel_FurtherGuaranteePanel = null;
	private LabelBase RightJLabel_FurtherGuarantee_ContactPerson = null;
	private TextBase RightJText_FurtherGuarantee_ContactPerson = null;
	private LabelBase RightJLabel_FurtherGuarantee_EmailAddress = null;
	private TextBase RightJText_FurtherGuarantee_EmailAddress = null;
	private LabelBase RightJLabel_FurtherGuarantee_ContactTitle = null;
	private TextBase RightJText_FurtherGuarantee_ContactTitle = null;
	private LabelBase RightJLabel_FurtherGuarantee_LimitAmt = null;
	private TextAmount RightJText_FurtherGuarantee_LimitAmt = null;
	private LabelBase RightJLabel_FurtherGuarantee_PhoneNumber = null;
	private TextPhone RightJText_FurtherGuarantee_PhoneNumber = null;
	private LabelBase RightJLabel_FurtherGuarantee_CoPayRefNo = null;
	private ComboCoPayRefType RightJCombo_FurtherGuarantee_CoPayRefType = null;
	private TextAmount RightJText_ClaimContact_CoPayRefAmount = null;
	private LabelBase RightJLabel_FurtherGuarantee_FaxNumber = null;
	private TextPhone RightJText_FurtherGuarantee_FaxNumber = null;
	private LabelBase RightJLabel_FurtherGuarantee_CvtEndDate = null;
	private TextDate RightJText_FurtherGuarantee_CvtEndDate = null;
	private LabelBase RightJLabel_FurtherGuarantee_CoverredItem = null;
	private CheckBoxBase RightCheckBox_FurtherGuarantee_Doctor = null;
	private LabelBase RightJLabel_FurtherGuarantee_Doctor = null;
	private CheckBoxBase RightCheckBox_FurtherGuarantee_Hospital = null;
	private LabelBase RightJLabel_FurtherGuarantee_Hospital = null;
	private CheckBoxBase RightCheckBox_FurtherGuarantee_Special = null;
	private LabelBase RightJLabel_FurtherGuarantee_Special = null;
	private CheckBoxBase RightCheckBox_FurtherGuarantee_Other = null;
	private LabelBase RightJLabel_FurtherGuarantee_ConveredItemOther = null;

	private BasePanel RightBasePanel_RegisteredOffice = null;
	private LabelBase RightJLabel_RegisteredOffice_Person = null;
	private TextBase RightJText_RegisteredOffice_Person = null;
	private LabelBase RightJLabel_RegisteredOffice_EmailAddress = null;
	private TextBase RightJText_RegisteredOffice_EmailAddress = null;
	private LabelBase RightJLabel_RegisteredOffice_Title = null;
	private TextBase RightJText_RegisteredOffice_Title = null;
	private LabelBase RightJLabel_RegisteredOffice_PhoneNumber = null;
	private TextPhone RightJText_RegisteredOffice_PhoneNumber = null;
	private LabelBase RightJLabel_RegisteredOffice_FaxNumber = null;
	private TextPhone RightJText_RegisteredOffice_FaxNumber = null;
	private LabelBase RightJLabel_RegisteredOffice_Address = null;
	private TextBase RightJText_RegisteredOffice_Address1 = null;
	private TextBase RightJText_RegisteredOffice_Address2 = null;
	private TextBase RightJText_RegisteredOffice_Address3 = null;
	private TextBase RightJText_RegisteredOffice_Address4 = null;

	private BasePanel RightBasePanel_AuthorizedPerson = null;
	private LabelBase RightJLabel_AuthorizedPerson_Person = null;
	private TextBase RightJText_AuthorizedPerson_Person = null;
	private LabelBase RightJLabel_AuthorizedPerson_EmailAddress = null;
	private TextBase RightJText_AuthorizedPerson_EmailAddress = null;
	private LabelBase RightJLabel_AuthorizedPerson_Title = null;
	private TextBase RightJText_AuthorizedPerson_Title = null;
	private LabelBase RightJLabel_AuthorizedPerson_PhoneNumber = null;
	private TextPhone RightJText_AuthorizedPerson_PhoneNumber = null;
	private LabelBase RightJLabel_AuthorizedPerson_FaxNumber = null;
	private TextPhone RightJText_AuthorizedPerson_FaxNumber = null;
	private LabelBase RightJLabel_AuthorizedPerson_Address = null;
	private TextBase RightJText_AuthorizedPerson_Address1 = null;
	private TextBase RightJText_AuthorizedPerson_Address2 = null;
	private TextBase RightJText_AuthorizedPerson_Address3 = null;
	private TextBase RightJText_AuthorizedPerson_Address4 = null;

	private BasePanel RightBasePanel_ProviderEnquiry = null;
	private LabelBase RightJLabel_ProviderEnquiry_Person = null;
	private TextBase RightJText_ProviderEnquiry_Person = null;
	private LabelBase RightJLabel_ProviderEnquiry_EmailAddress = null;
	private TextBase RightJText_ProviderEnquiry_EmailAddress = null;
	private LabelBase RightJLabel_ProviderEnquiry_Title = null;
	private TextBase RightJText_ProviderEnquiry_Title = null;
	private LabelBase RightJLabel_ProviderEnquiry_PhoneNumber = null;
	private TextPhone RightJText_ProviderEnquiry_PhoneNumber = null;
	private LabelBase RightJLabel_ProviderEnquiry_FaxNumber = null;
	private TextPhone RightJText_ProviderEnquiry_FaxNumber = null;
	private LabelBase RightJLabel_ProviderEnquiry_Address = null;
	private TextBase RightJText_ProviderEnquiry_Address1 = null;
	private TextBase RightJText_ProviderEnquiry_Address2 = null;
	private TextBase RightJText_ProviderEnquiry_Address3 = null;
	private TextBase RightJText_ProviderEnquiry_Address4 = null;

	private ButtonBase LJButton_ConHistory = null;
	private DlgConHistory dlgConHistory = null;

	private LabelBase RightJLabel_CreatedBy = null;
	private TextReadOnly RightJText_CreatedBy = null;
	private LabelBase RightJLabel_CreatedDate = null;
	private TextReadOnly RightJText_CreatedDate = null;

	private LabelBase RightJLabel_ARCompanyCode = null;
	private ComboARCompany RightJCombo_ARCompanyCode = null;
	private LabelBase RightJLabel_ARCompanyName = null;
	private TextString RightJText_ARCompanyName = null;

	private LabelBase RightJLabel_ARNature = null;
	private ComboARNature RightJText_ARNature = null;
	private LabelBase RightJLabel_Agreement = null;
	private CheckBoxBase RightJCheckBox_Agreement = null;

	private CheckBoxBase RightCheckBox_PayCodeChk = null;
	private LabelBase RightJLabel_PayCodeChk = null;
	private LabelBase RightJLabel_PrtMedRecordRpt = null;
	private CheckBoxBase RightCheckBox_PrtMedRecordRpt = null;
	private LabelBase RightJLabel_isDIDesc = null;
	private CheckBoxBase RightCheckBox_isDI = null;
	private LabelBase RightJLabel_inpAutoBrkdown = null;
	private LabelBase RightJLabel_opAutoBrkdown = null;
	private LabelBase RightJLabel_CLAutoBrkdown = null;
	private LabelBase RightJLabel_ORAutoBrkdown = null;
	private LabelBase RightJLabel_CSAutoBrkdown = null;
	private CheckBoxBase RightCheckBox_inpCLAutoBrkdown = null;
	private CheckBoxBase RightCheckBox_inpORAutoBrkdown = null;
	private CheckBoxBase RightCheckBox_inpCSAutoBrkdown = null;
	private CheckBoxBase RightCheckBox_opCLAutoBrkdown = null;
	private CheckBoxBase RightCheckBox_opORAutoBrkdown = null;
	private CheckBoxBase RightCheckBox_opCSAutoBrkdown = null;

	private String oldCode = null;
	private String inpAutoBrkDown = null;
	private String opAutoBrkDown = null;

	/**
	 * This method initializes
	 *
	 */
	public AccountReceivableDetail() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		/* >>> ~7.1~ Init action (e.g. Listing, Init Comobbox ========= <<< */
		//setFullEntry(true);
		setNoGetDB(true);
		setNoListDB(true);
		setRightAlignPanel();

		/* >>> ~7.2~ Disable Add/Modify/Delete Buttons ================ <<< */
		//setAppendButtonEnabled(false);
		//setModifyButtonEnabled(false);
		//setDeleteButtonEnabled(false);

		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		//oldCode = getParameter("ArCode");
		if (getListTable() != null && getListTable().getParent() != null &&
				getListTable().getParent().equals(getBodyPanel())) {
			getBodyPanel().remove(getListTable());
		}
		//getListTable().setColumnClass(32, new CheckBoxBase(), false);
		//getListTable().setColumnClass(33, new CheckBoxBase(), false);
		//getListTable().setColumnClass(34, new CheckBoxBase(), false);
		//getListTable().setColumnClass(35, new CheckBoxBase(), false);
		/*
		getListTable().addListener(Events.OnScroll, new Listener() {
			@Override
			public void handleEvent(BaseEvent be) {
				// TODO Auto-generated method stub
				getListTable().getView().layout();
			}
		});
		*/
		//searchAction();

		getRightJCombo_ARCompanyCode().resetText();
		PanelUtil.resetAllFields(getBodyPanel());
		getJTabbedPane().setSelectedIndex(0);
		enableButton();
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public Component getDefaultFocusComponent() {
		return getRightJCombo_ARCompanyCode();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {
		// override function if necessary
	}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {
		getRightJText_ARCode().resetText();
		getRightJText_ARName().resetText();
		getRightJText_ARCName().resetText();
		getRightJText_GlCode().resetText();
		getRightJText_RefundGlCode().resetText();
		getRightJText_ClaimContact_Address1().resetText();
		getRightJText_ClaimContact_Address2().resetText();
		getRightJText_ClaimContact_Address3().resetText();
		getRightJText_ClaimContact_Address4().resetText();
		getRightJText_ClaimContact_PhoneNumber().resetText();
		getRightJText_ClaimContact_FaxNumber().resetText();
		getRightJText_ClaimContact_EmailAddress().resetText();
		getRightJText_ClaimContact_Person().resetText();
		getRightJText_ClaimContact_Title().resetText();
		getRightJText_ARNature().resetText();
		getRightJText_ConstractualPrice().resetText();
		getRightJText_AdmissionContact_Person().resetText();
		getRightJText_AdmissionContact_Title().resetText();
		getRightJText_AdmissionContact_EmailAddress().resetText();
		getRightJText_AdmissionContact_PhoneNumber().resetText();
		getRightJText_AdmissionContact_FaxNumber().resetText();
		getRightCheckBox_AdmissionContract_AdmissionNotice().setSelected(false);
		getRightJText_FurtherGuarantee_ContactPerson().resetText();
		getRightJText_FurtherGuarantee_ContactTitle().resetText();
		getRightJText_FurtherGuarantee_EmailAddress().resetText();
		getRightJText_FurtherGuarantee_PhoneNumber().resetText();
		getRightJText_FurtherGuarantee_FaxNumber().resetText();
		getRightJCombo_FurtherGuarantee_CoPayRefType().resetText();
		getRightJText_FurtherGuarantee_LimitAmt().clear();
		getRightJText_FurtherGuarantee_CvtEndDate().resetText();
		getRightJText_ClaimContact_CoPayRefAmount().clear();
		getRightCheckBox_FurtherGuarantee_Doctor().setSelected(false);
		getRightCheckBox_FurtherGuarantee_Hospital().setSelected(false);
		getRightCheckBox_FurtherGuarantee_Special().setSelected(false);
		getRightCheckBox_FurtherGuarantee_Other().setSelected(false);
		getRightJText_StartDate().resetText();
		getRightJText_TerminationDate().resetText();
		getRightJText_LastUpdateBy().resetText();
		getRightJText_LastUpdateDate().resetText();
		getRightCheckBox_ArActive().setSelected(false);
		getRightJText_PrimaryCompany().resetText();
		getRightJText_NoContractStartDate().resetText();
		getRightJText_NoContractEndDate().resetText();
		getRightJText_ArPct().resetText();
	    getRightJText_AdmissionContact_Address1().resetText();
	    getRightJText_AdmissionContact_Address2().resetText();
	    getRightJText_AdmissionContact_Address3().resetText();
	    getRightJText_AdmissionContact_Address4().resetText();
	    getRightJText_RegisteredOffice_Person().resetText();
	    getRightJText_RegisteredOffice_Title().resetText();
	    getRightJText_RegisteredOffice_PhoneNumber().resetText();
	    getRightJText_RegisteredOffice_FaxNumber().resetText();
	    getRightJText_RegisteredOffice_EmailAddress().resetText();
	    getRightJText_RegisteredOffice_Address1().resetText();
	    getRightJText_RegisteredOffice_Address2().resetText();
	    getRightJText_RegisteredOffice_Address3().resetText();
	    getRightJText_RegisteredOffice_Address4().resetText();
	    getRightJText_AuthorizedPerson_Person().resetText();
	    getRightJText_AuthorizedPerson_Title().resetText();
	    getRightJText_AuthorizedPerson_EmailAddress().resetText();
	    getRightJText_AuthorizedPerson_PhoneNumber().resetText();
	    getRightJText_AuthorizedPerson_FaxNumber().resetText();
	    getRightJText_AuthorizedPerson_Address1().resetText();
	    getRightJText_AuthorizedPerson_Address2().resetText();
	    getRightJText_AuthorizedPerson_Address3().resetText();
	    getRightJText_AuthorizedPerson_Address4().resetText();
		getRightJText_ProviderEnquiry_Person().resetText();
		getRightJText_ProviderEnquiry_Title().resetText();
		getRightJText_ProviderEnquiry_EmailAddress().resetText();
		getRightJText_ProviderEnquiry_PhoneNumber().resetText();
		getRightJText_ProviderEnquiry_FaxNumber().resetText();
		getRightJText_ProviderEnquiry_Address1().resetText();
		getRightJText_ProviderEnquiry_Address2().resetText();
		getRightJText_ProviderEnquiry_Address3().resetText();
		getRightJText_ProviderEnquiry_Address4().resetText();

		getRightCheckBox_PrtMedRecordRpt().setSelected(false);
		getRightCheckBox_ArInpatient().setSelected(false);
		getRightCheckBox_ArOutpatient().setSelected(false);
		getRightCheckBox_ArPatientSignature().setSelected(false);
		getRightCheckBox_PayCodeChk().setSelected(false);
		getRightCheckBox_isDI().setSelected(false);
		getRightJCheckBox_Agreement().setSelected(false);
		getRightCheckBox_ArHealthAssessment().setSelected(false);
		getRightCheckBox_inpCLAutoBrkdown().setSelected(false);
		getRightCheckBox_inpORAutoBrkdown().setSelected(false);
		getRightCheckBox_inpCSAutoBrkdown().setSelected(false);
		getRightCheckBox_opCLAutoBrkdown().setSelected(false);
		getRightCheckBox_opORAutoBrkdown().setSelected(false);
		getRightCheckBox_opCSAutoBrkdown().setSelected(false);

		getRightJText_ARCode().setEnabled(true);
		getRightJText_ARName().setEnabled(true);
		getRightJText_ARCName().setEnabled(true);
		getRightJText_GlCode().setEnabled(true);
		getRightJText_RefundGlCode().setEnabled(true);
		getRightJText_ClaimContact_Address1().setEnabled(true);
		getRightJText_ClaimContact_Address2().setEnabled(true);
		getRightJText_ClaimContact_Address3().setEnabled(true);
		getRightJText_ClaimContact_Address4().setEnabled(true);
		getRightJText_ClaimContact_PhoneNumber().setEnabled(true);
		getRightJText_ClaimContact_FaxNumber().setEnabled(true);
		getRightJText_ClaimContact_EmailAddress().setEnabled(true);
		getRightJText_ClaimContact_Person().setEnabled(true);
		getRightJText_ClaimContact_Title().setEnabled(true);
		getRightJText_ARNature().setEnabled(true);
		getRightJText_ConstractualPrice().setEnabled(true);
		getRightJText_AdmissionContact_Person().setEnabled(true);
		getRightJText_AdmissionContact_Title().setEnabled(true);
		getRightJText_AdmissionContact_EmailAddress().setEnabled(true);
		getRightJText_AdmissionContact_PhoneNumber().setEnabled(true);
		getRightJText_AdmissionContact_FaxNumber().setEnabled(true);
		getRightCheckBox_AdmissionContract_AdmissionNotice().setEnabled(true);
		getRightJText_FurtherGuarantee_ContactPerson().setEnabled(true);
		getRightJText_FurtherGuarantee_ContactTitle().setEnabled(true);
		getRightJText_FurtherGuarantee_EmailAddress().setEnabled(true);
		getRightJText_FurtherGuarantee_PhoneNumber().setEnabled(true);
		getRightJText_FurtherGuarantee_FaxNumber().setEnabled(true);
		getRightJCombo_FurtherGuarantee_CoPayRefType().setEnabled(true);
		getRightJText_FurtherGuarantee_LimitAmt().setEnabled(true);
		getRightJText_FurtherGuarantee_CvtEndDate().setEnabled(true);
		getRightJText_ClaimContact_CoPayRefAmount().setEnabled(true);
		getRightCheckBox_FurtherGuarantee_Doctor().setEnabled(true);
		getRightCheckBox_FurtherGuarantee_Hospital().setEnabled(true);
		getRightCheckBox_FurtherGuarantee_Special().setEnabled(true);
		getRightCheckBox_FurtherGuarantee_Other().setEnabled(true);
		getRightJText_StartDate().setEnabled(true);
		getRightJText_TerminationDate().setEnabled(true);
		getRightCheckBox_ArActive().setEnabled(true);
		getRightJText_PrimaryCompany().setEnabled(true);
		getRightJText_NoContractStartDate().setEnabled(true);
		getRightJText_NoContractEndDate().setEnabled(true);
		getRightJText_ArPct().setEnabled(true);
		getRightCheckBox_PrtMedRecordRpt().setEnabled(true);
		getRightCheckBox_ArInpatient().setEnabled(true);
		getRightCheckBox_ArOutpatient().setEnabled(true);
		getRightCheckBox_ArPatientSignature().setEnabled(true);
		getRightCheckBox_PayCodeChk().setEnabled(true);
		getRightCheckBox_isDI().setEnabled(true);
		getRightJCheckBox_Agreement().setEnabled(true);
		getRightCheckBox_ArHealthAssessment().setEnabled(true);
		getRightCheckBox_inpCLAutoBrkdown().setEnabled(true);
		getRightCheckBox_inpORAutoBrkdown().setEnabled(true);
		getRightCheckBox_inpCSAutoBrkdown().setEnabled(true);
		getRightCheckBox_opCLAutoBrkdown().setEnabled(true);
		getRightCheckBox_opORAutoBrkdown().setEnabled(true);
		getRightCheckBox_opCSAutoBrkdown().setEnabled(true);
	    getRightJText_AdmissionContact_Address1().setEnabled(true);
	    getRightJText_AdmissionContact_Address2().setEnabled(true);
	    getRightJText_AdmissionContact_Address3().setEnabled(true);
	    getRightJText_AdmissionContact_Address4().setEnabled(true);
	    getRightJText_RegisteredOffice_Person().setEnabled(true);
	    getRightJText_RegisteredOffice_Title().setEnabled(true);
	    getRightJText_RegisteredOffice_PhoneNumber().setEnabled(true);
	    getRightJText_RegisteredOffice_FaxNumber().setEnabled(true);
	    getRightJText_RegisteredOffice_EmailAddress().setEnabled(true);
	    getRightJText_RegisteredOffice_Address1().setEnabled(true);
	    getRightJText_RegisteredOffice_Address2().setEnabled(true);
	    getRightJText_RegisteredOffice_Address3().setEnabled(true);
	    getRightJText_RegisteredOffice_Address4().setEnabled(true);
	    getRightJText_AuthorizedPerson_Person().setEnabled(true);
	    getRightJText_AuthorizedPerson_Title().setEnabled(true);
	    getRightJText_AuthorizedPerson_EmailAddress().setEnabled(true);
	    getRightJText_AuthorizedPerson_PhoneNumber().setEnabled(true);
	    getRightJText_AuthorizedPerson_FaxNumber().setEnabled(true);
	    getRightJText_AuthorizedPerson_Address1().setEnabled(true);
	    getRightJText_AuthorizedPerson_Address2().setEnabled(true);
	    getRightJText_AuthorizedPerson_Address3().setEnabled(true);
	    getRightJText_AuthorizedPerson_Address4().setEnabled(true);
		getRightJText_ProviderEnquiry_Person().setEnabled(true);
		getRightJText_ProviderEnquiry_Title().setEnabled(true);
		getRightJText_ProviderEnquiry_EmailAddress().setEnabled(true);
		getRightJText_ProviderEnquiry_PhoneNumber().setEnabled(true);
		getRightJText_ProviderEnquiry_FaxNumber().setEnabled(true);
		getRightJText_ProviderEnquiry_Address1().setEnabled(true);
		getRightJText_ProviderEnquiry_Address2().setEnabled(true);
		getRightJText_ProviderEnquiry_Address3().setEnabled(true);
		getRightJText_ProviderEnquiry_Address4().setEnabled(true);

		//getListTable().setEnabled(false);
	}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
		getRightJText_ARCode().setEnabled(true);
		getRightJText_ARName().setEnabled(true);
		getRightJText_ARCName().setEnabled(true);
		getRightJText_GlCode().setEnabled(true);
		getRightJText_RefundGlCode().setEnabled(true);
		getRightJText_ClaimContact_Address1().setEnabled(true);
		getRightJText_ClaimContact_Address2().setEnabled(true);
		getRightJText_ClaimContact_Address3().setEnabled(true);
		getRightJText_ClaimContact_Address4().setEnabled(true);
		getRightJText_ClaimContact_PhoneNumber().setEnabled(true);
		getRightJText_ClaimContact_FaxNumber().setEnabled(true);
		getRightJText_ClaimContact_EmailAddress().setEnabled(true);
		getRightJText_ClaimContact_Person().setEnabled(true);
		getRightJText_ClaimContact_Title().setEnabled(true);
		getRightJText_ARNature().setEnabled(true);
		getRightJText_ConstractualPrice().setEnabled(true);
		getRightJText_AdmissionContact_Person().setEnabled(true);
		getRightJText_AdmissionContact_Title().setEnabled(true);
		getRightJText_AdmissionContact_EmailAddress().setEnabled(true);
		getRightJText_AdmissionContact_PhoneNumber().setEnabled(true);
		getRightJText_AdmissionContact_FaxNumber().setEnabled(true);
		getRightCheckBox_AdmissionContract_AdmissionNotice().setEnabled(true);
		getRightJText_FurtherGuarantee_ContactPerson().setEnabled(true);
		getRightJText_FurtherGuarantee_ContactTitle().setEnabled(true);
		getRightJText_FurtherGuarantee_EmailAddress().setEnabled(true);
		getRightJText_FurtherGuarantee_PhoneNumber().setEnabled(true);
		getRightJText_FurtherGuarantee_FaxNumber().setEnabled(true);
		getRightJCombo_FurtherGuarantee_CoPayRefType().setEnabled(true);
		getRightJText_FurtherGuarantee_LimitAmt().setEnabled(true);
		getRightJText_FurtherGuarantee_CvtEndDate().setEnabled(true);
		getRightJText_ClaimContact_CoPayRefAmount().setEnabled(true);
		getRightCheckBox_FurtherGuarantee_Doctor().setEnabled(true);
		getRightCheckBox_FurtherGuarantee_Hospital().setEnabled(true);
		getRightCheckBox_FurtherGuarantee_Special().setEnabled(true);
		getRightCheckBox_FurtherGuarantee_Other().setEnabled(true);
		getRightJText_StartDate().setEnabled(true);
		getRightJText_TerminationDate().setEnabled(true);
		getRightCheckBox_ArActive().setEnabled(true);
		getRightJText_PrimaryCompany().setEnabled(true);
		getRightJText_NoContractStartDate().setEnabled(true);
		getRightJText_NoContractEndDate().setEnabled(true);
		getRightJText_ArPct().setEnabled(true);
		getRightCheckBox_ArPatientSignature().setEnabled(true);
	    getRightJText_AdmissionContact_Address1().setEnabled(true);
	    getRightJText_AdmissionContact_Address2().setEnabled(true);
	    getRightJText_AdmissionContact_Address3().setEnabled(true);
	    getRightJText_AdmissionContact_Address4().setEnabled(true);
	    getRightJText_RegisteredOffice_Person().setEnabled(true);
	    getRightJText_RegisteredOffice_Title().setEnabled(true);
	    getRightJText_RegisteredOffice_PhoneNumber().setEnabled(true);
	    getRightJText_RegisteredOffice_FaxNumber().setEnabled(true);
	    getRightJText_RegisteredOffice_EmailAddress().setEnabled(true);
	    getRightJText_RegisteredOffice_Address1().setEnabled(true);
	    getRightJText_RegisteredOffice_Address2().setEnabled(true);
	    getRightJText_RegisteredOffice_Address3().setEnabled(true);
	    getRightJText_RegisteredOffice_Address4().setEnabled(true);
	    getRightJText_AuthorizedPerson_Person().setEnabled(true);
	    getRightJText_AuthorizedPerson_Title().setEnabled(true);
	    getRightJText_AuthorizedPerson_EmailAddress().setEnabled(true);
	    getRightJText_AuthorizedPerson_PhoneNumber().setEnabled(true);
	    getRightJText_AuthorizedPerson_FaxNumber().setEnabled(true);
	    getRightJText_AuthorizedPerson_Address1().setEnabled(true);
	    getRightJText_AuthorizedPerson_Address2().setEnabled(true);
	    getRightJText_AuthorizedPerson_Address3().setEnabled(true);
	    getRightJText_AuthorizedPerson_Address4().setEnabled(true);
		getRightJText_ProviderEnquiry_Person().setEnabled(true);
		getRightJText_ProviderEnquiry_Title().setEnabled(true);
		getRightJText_ProviderEnquiry_EmailAddress().setEnabled(true);
		getRightJText_ProviderEnquiry_PhoneNumber().setEnabled(true);
		getRightJText_ProviderEnquiry_FaxNumber().setEnabled(true);
		getRightJText_ProviderEnquiry_Address1().setEnabled(true);
		getRightJText_ProviderEnquiry_Address2().setEnabled(true);
		getRightJText_ProviderEnquiry_Address3().setEnabled(true);
		getRightJText_ProviderEnquiry_Address4().setEnabled(true);
		oldCode = getRightJText_ARCode().getText();
		//getListTable().setEnabled(false);
	}

	/* >>> ~13~ Set Disable Fields When Delete ButtonBase Is Clicked ====== <<< */
	@Override
	protected void deleteDisabledFields() {
		// enable/disable field
	}

	/* >>> ~14~ Set Browse Validation ===================================== <<< */
	@Override
	protected boolean browseValidation() {
		return true;
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
				getRightJCombo_ARCompanyCode().getText().toUpperCase(),
				getRightJText_ARCompanyName().getText().trim()
		};
	}

	/* >>> ~16~ Set Fetch Input Parameters ================================ <<< */
	@Override
	protected String[] getFetchInputParameters() {
		return new String[] {
//				getRightJCombo_ARCompanyCode().getText()
				getRightJText_ARCode().getText(),  //arccode
				getRightJText_ARName().getText(),  //arcname
				getRightJText_ARCName().getText(),  //ARCCNAME
				getRightJText_GlCode().getText(),  //glccode
				getRightJText_RefundGlCode().getText(),	 //retglccode
				getRightJText_ClaimContact_Address1().getText(),  //arcadd1
				getRightJText_ClaimContact_Address2().getText(),	 //arcadd2
				getRightJText_ClaimContact_Address3().getText(),	 //arcadd3
				getRightJText_ClaimContact_PhoneNumber().getText(),  //arctel
				getRightJText_ClaimContact_FaxNumber().getText(),  //fax
				getRightJText_ClaimContact_EmailAddress().getText(),  //email
				getRightJText_ClaimContact_Person().getText(),	//arcct
				getRightJText_ClaimContact_Title().getText(),	//arctitle
				//selectedContent[13],	//arcuamt
				//electedContent[14],   //arcamt
				getRightJText_ConstractualPrice().getText(),//selectedContent[15],   //cpsid         //selectedContent[16],  cpscode
				getRightJText_AdmissionContact_Person().getText(),   //arcadmcname
				getRightJText_AdmissionContact_Title().getText(),  //admttl
				getRightJText_AdmissionContact_EmailAddress().getText(),  //admemail
				getRightJText_AdmissionContact_PhoneNumber().getText(),  //arcadmcp
				getRightJText_AdmissionContact_FaxNumber().getText(),  //arcadmcf
				"Y".equals(getRightCheckBox_AdmissionContract_AdmissionNotice().getText())?"-1":"0",  //arcsnd
				getRightJText_FurtherGuarantee_ContactPerson().getText(),  //furcct
				getRightJText_FurtherGuarantee_ContactTitle().getText(),	//furttl
				getRightJText_FurtherGuarantee_EmailAddress().getText(),   //furemail
				getRightJText_FurtherGuarantee_PhoneNumber().getText(),   //furtel
				getRightJText_FurtherGuarantee_FaxNumber().getText(),   //furfax
				getRightJCombo_FurtherGuarantee_CoPayRefType().getText(),  //copaytyp
				getRightJText_FurtherGuarantee_LimitAmt().getText(),  //arlmtamt
				getRightJText_FurtherGuarantee_CvtEndDate().getText(),  //curedate
				getRightJText_ClaimContact_CoPayRefAmount().getText(),  //copayamt
				"Y".equals(getRightCheckBox_FurtherGuarantee_Doctor().getText())?"-1":"0",  //itmtyped
				"Y".equals(getRightCheckBox_FurtherGuarantee_Hospital().getText())?"-1":"0",  //itmtypeh
				"Y".equals(getRightCheckBox_FurtherGuarantee_Special().getText())?"-1":"0",  //itmtypes
				"Y".equals(getRightCheckBox_FurtherGuarantee_Other().getText())?"-1":"0",  //itmtypeo
				getRightJText_StartDate().getText(),  	   //ar_s_date
				getRightJText_TerminationDate().getText(), //ar_e_date
				getUserInfo().getUserID(),				   //USRNAME
				"Y".equals(getRightCheckBox_ArActive().getText())?"-1":"0",	 //AR_ACTIVE
				getRightJText_PrimaryCompany().getText(),		//ARCPRIMCOMP
				getRightJText_NoContractStartDate().getText(),  //42 NCTRSDATE
				getRightJText_NoContractEndDate().getText(),    //43 NCTREDATE
				getRightJText_ClaimContact_Address4().getText(), //44 ARCADD4
				oldCode,
				"Y".equals(getRightCheckBox_PrtMedRecordRpt().getText())?"-1":"0",	 //PRINT_MRRPT
				getRightJText_MstrAR().getText(), //46 MSTR_AR
				"Y".equals(getRightCheckBox_ArInpatient().getText())?"-1":"0",
				"Y".equals(getRightCheckBox_ArOutpatient().getText())?"-1":"0",
				"Y".equals(getRightCheckBox_PayCodeChk().getText())?"-1":"0",	 //47 PAY_CHECK
			    "Y".equals(getRightCheckBox_isDI().getText())?"-1":"0",	 //48 ISDI
			    "Y".equals(getRightJCheckBox_Agreement().getText())?"-1":"0",	 //59 AR_AGREEMENT
				"Y".equals(getRightCheckBox_ArHealthAssessment().getText())?"-1":"0",	 //52 AR_HTHASSMENT
				"Y".equals(getRightCheckBox_ArOthers().getText())?"-1":"0",	 //53 AR_OTHERS
				getRightJText_ArOthers().getText(), //54 AR_OTHERS_TEXT
			    getAllAutoBrkDown("I"),	//63	INP_CHG_RPTLVL
			    getAllAutoBrkDown("O"),	//64	OP_CHG_RPTLVL
			    "Y".equals(getRightCheckBox_ArPatientSignature().getText())?"-1":"0",	 //65 PATSIGN
			    getRightJText_ARNature().getText(),	//66 AR_NATURE
			    getRightJText_AdmissionContact_Address1().getText(),	//67	ADMADD1
			    getRightJText_AdmissionContact_Address2().getText(),	//68	ADMADD2
			    getRightJText_AdmissionContact_Address3().getText(),	//69	ADMADD3
			    getRightJText_AdmissionContact_Address4().getText(),		//70	ADMADD4
			    getRightJText_RegisteredOffice_Person().getText(),		//71	AGCCCT
			    getRightJText_RegisteredOffice_Title().getText(),	//72	AGCTITLE
			    getRightJText_RegisteredOffice_PhoneNumber().getText(),	//73	AGCTEL
			    getRightJText_RegisteredOffice_FaxNumber().getText(),	//74	AGCFAX
			    getRightJText_RegisteredOffice_EmailAddress().getText(),	//75	AGCEMAIL
			    getRightJText_RegisteredOffice_Address1().getText(),	//76	AGCADD1
			    getRightJText_RegisteredOffice_Address2().getText(),	//77	AGCADD2
			    getRightJText_RegisteredOffice_Address3().getText(),	//78	AGCADD3
			    getRightJText_RegisteredOffice_Address4().getText(),	//79	AGCADD4
			    getRightJText_AuthorizedPerson_Person().getText(),		//80	AUPCCT
			    getRightJText_AuthorizedPerson_Title().getText(),		//81	AUPTITLE
			    getRightJText_AuthorizedPerson_EmailAddress().getText(),	//82	AUPEMAIL
			    getRightJText_AuthorizedPerson_PhoneNumber().getText(),		//83	AUPTEL
			    getRightJText_AuthorizedPerson_FaxNumber().getText(),		//84	AUPFAX
			    getRightJText_AuthorizedPerson_Address1().getText(),		//85	AUPADD1
			    getRightJText_AuthorizedPerson_Address2().getText(),		//86	AUPADD2
			    getRightJText_AuthorizedPerson_Address3().getText(),		//87	AUPADD3
			    getRightJText_AuthorizedPerson_Address4().getText(),		//88	AUPADD4
				getRightJText_ProviderEnquiry_Person().getText(),			//89	PRECCT
				getRightJText_ProviderEnquiry_Title().getText(),			//90	PRETITLE
				getRightJText_ProviderEnquiry_EmailAddress().getText(),			//91	PREEMAIL
				getRightJText_ProviderEnquiry_PhoneNumber().getText(),			//92	PRETEL
				getRightJText_ProviderEnquiry_FaxNumber().getText(),			//93	PREFAX
				getRightJText_ProviderEnquiry_Address1().getText(),			//94	PREADD1
				getRightJText_ProviderEnquiry_Address2().getText(),			//95	PREADD2
				getRightJText_ProviderEnquiry_Address3().getText(),			//96	PREADD3
				getRightJText_ProviderEnquiry_Address4().getText(),			//97	PREADD4
				getRightJText_ArPct().getText()								//98	AR_PCT
		};
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {
		int index = 0;
		getRightJText_ARCode().setText(outParam[index++]);                          //0 ARCCODE
		getRightJText_ARName().setText(outParam[index++]);                          //1 ARCNAME
		getRightJText_ARCName().setText(outParam[index++]);                         //2 ARCCNAME
		getRightJText_GlCode().setText(outParam[index++]);                          //3 GLCCODE
		getRightJText_RefundGlCode().setText(outParam[index++]);                    //4 RETGLCCODE
		getRightJText_ClaimContact_Address1().setText(outParam[index++]);           //5 ARCADD1
		getRightJText_ClaimContact_Address2().setText(outParam[index++]);           //6 ARCADD2
		getRightJText_ClaimContact_Address3().setText(outParam[index++]);           //7 ARCADD3
		getRightJText_ClaimContact_PhoneNumber().setText(outParam[index++]);        //8 ARCTEL
		getRightJText_ClaimContact_FaxNumber().setText(outParam[index++]);          //9 FAX
		getRightJText_ClaimContact_EmailAddress().setText(outParam[index++]);       //10 EMAIL
		getRightJText_ClaimContact_Person().setText(outParam[index++]);             //11 ARCCT
		getRightJText_ClaimContact_Title().setText(outParam[index++]);              //12 ARCTITLE
		index++;                                                                    //13 ARCUAMT
		index++;                                                                    //14 ARCAMT
		getRightJText_ConstractualPrice().setText(outParam[index++]);                //15 CPSID
		index++;                                                                    //16 CPSCODE
		getRightJText_AdmissionContact_Person().setText(outParam[index++]);         //17 ARCADMCNAME
		getRightJText_AdmissionContact_Title().setText(outParam[index++]);          //18 ADMTTL
		getRightJText_AdmissionContact_EmailAddress().setText(outParam[index++]);   //19 ADMEMAIL
		getRightJText_AdmissionContact_PhoneNumber().setText(outParam[index++]);    //20 ARCADMCP
		getRightJText_AdmissionContact_FaxNumber().setText(outParam[index++]);      //21 ARCADMCF
		getRightCheckBox_AdmissionContract_AdmissionNotice().setSelected(YES_VALUE.equals(outParam[index++]));      //22 ARCSND
		getRightJText_FurtherGuarantee_ContactPerson().setText(outParam[index++]);  //23 FURCCT
		getRightJText_FurtherGuarantee_ContactTitle().setText(outParam[index++]);   //24 FURTTL
		getRightJText_FurtherGuarantee_EmailAddress().setText(outParam[index++]);   //25 FUREMAIL
		getRightJText_FurtherGuarantee_PhoneNumber().setText(outParam[index++]);    //26 FURTEL
		getRightJText_FurtherGuarantee_FaxNumber().setText(outParam[index++]);      //27 FURFAX
		getRightJCombo_FurtherGuarantee_CoPayRefType().setText(outParam[index++]);  //28 COPAYTYP
		getRightJText_FurtherGuarantee_LimitAmt().setText(outParam[index++]);       //29 ARLMTAMT
		getRightJText_FurtherGuarantee_CvtEndDate().setText(outParam[index++]);     //30 CVREDATE
		getRightJText_ClaimContact_CoPayRefAmount().setText(outParam[index++]);     //31 COPAYAMT
		getRightCheckBox_FurtherGuarantee_Doctor().setSelected(YES_VALUE.equals(outParam[index++]));     //32 ITMTYPED
		getRightCheckBox_FurtherGuarantee_Hospital().setSelected(YES_VALUE.equals(outParam[index++]));   //33 ITMTYPEH
		getRightCheckBox_FurtherGuarantee_Special().setSelected(YES_VALUE.equals(outParam[index++]));    //34 ITMTYPES
		getRightCheckBox_FurtherGuarantee_Other().setSelected(YES_VALUE.equals(outParam[index++]));      //35 ITMTYPEO
		getRightJText_StartDate().setText(outParam[index++]);                       //36 AR_S_DATE
		getRightJText_TerminationDate().setText(outParam[index++]);                 //37 AR_E_DATE
		getRightJText_LastUpdateBy().setText(outParam[index++]);                    //38 USRNAME
		getRightJText_LastUpdateDate().setText(outParam[index++]);                  //39 ARCUPDDATE
		getRightCheckBox_ArActive().setSelected(YES_VALUE.equals(outParam[index++]));                 //40 AR_ACTIVE
		getRightJText_PrimaryCompany().setText(outParam[index++]);                  //41 ARCPRIMCOMP
		getRightJText_NoContractStartDate().setText(outParam[index++]);             //42 NCTRSDATE
		getRightJText_NoContractEndDate().setText(outParam[index++]);               //43 NCTREDATE
		getRightJText_ClaimContact_Address4().setText(outParam[index++]);           //44 ARCADD4
		getRightCheckBox_PrtMedRecordRpt().setSelected(MINUS_ONE_VALUE.equals(outParam[index++]));              //45 PRINT_MRRPT
		getRightJText_MstrAR().setText(outParam[index++]);           //46 MSTR_AR
		getRightCheckBox_ArInpatient().setSelected(MINUS_ONE_VALUE.equals(outParam[index++]));
		getRightCheckBox_ArOutpatient().setSelected(MINUS_ONE_VALUE.equals(outParam[index++]));
		getRightCheckBox_PayCodeChk().setSelected(MINUS_ONE_VALUE.equals(outParam[index++]));          //47 PAY_CHECK
		getRightCheckBox_isDI().setSelected(MINUS_ONE_VALUE.equals(outParam[index++]));          //48 IS_DI
		getRightJCheckBox_Agreement().setSelected(MINUS_ONE_VALUE.equals(outParam[index++]));          //49 AR_AGREEMENT
		getRightCheckBox_ArHealthAssessment().setSelected(MINUS_ONE_VALUE.equals(outParam[index++]));          //52 AR_HTHASSMENT
		getRightCheckBox_ArOthers().setSelected(MINUS_ONE_VALUE.equals(outParam[index++]));	 //53 AR_OTHERS
		getRightJText_ArOthers().setText(outParam[index++]); //54 AR_OTHERS_TEXT
		getRightCheckBox_inpCLAutoBrkdown().setSelected(MINUS_ONE_VALUE.equals(outParam[index++]));          //50 CL INP_CHG_RPTLVL
		getRightCheckBox_inpORAutoBrkdown().setSelected(MINUS_ONE_VALUE.equals(outParam[index++]));          //51 OR INP_CHG_RPTLVL
		getRightCheckBox_inpCSAutoBrkdown().setSelected(MINUS_ONE_VALUE.equals(outParam[index++]));          //52 CS INP_CHG_RPTLVL
		getRightCheckBox_opCLAutoBrkdown().setSelected(MINUS_ONE_VALUE.equals(outParam[index++]));          //53 CL OP_CHG_RPTLVL
		getRightCheckBox_opORAutoBrkdown().setSelected(MINUS_ONE_VALUE.equals(outParam[index++]));          //54 OR OP_CHG_RPTLVL
		getRightCheckBox_opCSAutoBrkdown().setSelected(MINUS_ONE_VALUE.equals(outParam[index++]));			//55 CS OP_CHG_RPTLVL
		getRightJText_CreatedBy().setText(outParam[index++]);         	//56 AR_CREATEUSR
		getRightJText_CreatedDate().setText(outParam[index++]); 			//57 AR_CREATEDATE
		getRightCheckBox_ArPatientSignature().setSelected(MINUS_ONE_VALUE.equals(outParam[index++]));		 //58 PATSIGN
		getRightJText_ARNature().setText(outParam[index++]);			//58 AR_CREATEDATE
	    getRightJText_AdmissionContact_Address1().setText(outParam[index++]);	//	ADMADD1
	    getRightJText_AdmissionContact_Address2().setText(outParam[index++]);	//	ADMADD2
	    getRightJText_AdmissionContact_Address3().setText(outParam[index++]);	//	ADMADD3
	    getRightJText_AdmissionContact_Address4().setText(outParam[index++]);	//	ADMADD4
	    getRightJText_RegisteredOffice_Person().setText(outParam[index++]);		//	AGCCCT
	    getRightJText_RegisteredOffice_Title().setText(outParam[index++]);	//	AGCTITLE
	    getRightJText_RegisteredOffice_PhoneNumber().setText(outParam[index++]);	//	AGCTEL
	    getRightJText_RegisteredOffice_FaxNumber().setText(outParam[index++]);	//	AGCFAX
	    getRightJText_RegisteredOffice_EmailAddress().setText(outParam[index++]);	//	AGCEMAIL
	    getRightJText_RegisteredOffice_Address1().setText(outParam[index++]);	//	AGCADD1
	    getRightJText_RegisteredOffice_Address2().setText(outParam[index++]);	//	AGCADD2
	    getRightJText_RegisteredOffice_Address3().setText(outParam[index++]);	//	AGCADD3
	    getRightJText_RegisteredOffice_Address4().setText(outParam[index++]);		//	AGCADD4
	    getRightJText_AuthorizedPerson_Person().setText(outParam[index++]);		//	AUPCCT
	    getRightJText_AuthorizedPerson_Title().setText(outParam[index++]);		//	AUPTITLE
	    getRightJText_AuthorizedPerson_EmailAddress().setText(outParam[index++]);	//	AUPEMAIL
	    getRightJText_AuthorizedPerson_PhoneNumber().setText(outParam[index++]);		//	AUPTEL
	    getRightJText_AuthorizedPerson_FaxNumber().setText(outParam[index++]);		//	AUPFAX
	    getRightJText_AuthorizedPerson_Address1().setText(outParam[index++]);		//	AUPADD1
	    getRightJText_AuthorizedPerson_Address2().setText(outParam[index++]);		//	AUPADD2
	    getRightJText_AuthorizedPerson_Address3().setText(outParam[index++]);		//	AUPADD3
	    getRightJText_AuthorizedPerson_Address4().setText(outParam[index++]);		//	AUPADD4
		getRightJText_ProviderEnquiry_Person().setText(outParam[index++]);			//	PRECCT
		getRightJText_ProviderEnquiry_Title().setText(outParam[index++]);			//	PRETITLE
		getRightJText_ProviderEnquiry_EmailAddress().setText(outParam[index++]);	//	PREEMAIL
		getRightJText_ProviderEnquiry_PhoneNumber().setText(outParam[index++]);		//	PRETEL
		getRightJText_ProviderEnquiry_FaxNumber().setText(outParam[index++]);		//	PREFAX
		getRightJText_ProviderEnquiry_Address1().setText(outParam[index++]);		//	PREADD1
		getRightJText_ProviderEnquiry_Address2().setText(outParam[index++]);		//	PREADD2
		getRightJText_ProviderEnquiry_Address3().setText(outParam[index++]);		//	PREADD3
		getRightJText_ProviderEnquiry_Address4().setText(outParam[index++]);		//	PREADD4		
		getRightJText_ArPct().setText(outParam[index++]);							//	AR_PCT	
		
		enableButton();
	}

	/* >>> ~21~ Set Add New Row toclearPostAction table ============================== <<< */
/*
	@Override
	protected void clearTableFields() {
		super.clearTableFields();
	}
*/

	/* >>> ~22~ Set Action Input Parameters per table ===================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		String[] param = new String[] {
			getRightJText_ARCode().getText(),  //arccode
			getRightJText_ARName().getText(),  //arcname
			getRightJText_ARCName().getText(),  //ARCCNAME
			getRightJText_GlCode().getText(),  //glccode
			getRightJText_RefundGlCode().getText(),	 //retglccode
			getRightJText_ClaimContact_Address1().getText(),  //arcadd1
			getRightJText_ClaimContact_Address2().getText(),	 //arcadd2
			getRightJText_ClaimContact_Address3().getText(),	 //arcadd3
			getRightJText_ClaimContact_PhoneNumber().getText(),  //arctel
			getRightJText_ClaimContact_FaxNumber().getText(),  //fax
			getRightJText_ClaimContact_EmailAddress().getText(),  //email
			getRightJText_ClaimContact_Person().getText(),	//arcct
			getRightJText_ClaimContact_Title().getText(),	//arctitle
			//selectedContent[13],	//arcuamt
			//electedContent[14],   //arcamt
			getRightJText_ConstractualPrice().getText(),//selectedContent[15],   //cpsid         //selectedContent[16],  cpscode
			getRightJText_AdmissionContact_Person().getText(),   //arcadmcname
			getRightJText_AdmissionContact_Title().getText(),  //admttl
			getRightJText_AdmissionContact_EmailAddress().getText(),  //admemail
			getRightJText_AdmissionContact_PhoneNumber().getText(),  //arcadmcp
			getRightJText_AdmissionContact_FaxNumber().getText(),  //arcadmcf
			"Y".equals(getRightCheckBox_AdmissionContract_AdmissionNotice().getText())?"-1":"0",  //arcsnd
			getRightJText_FurtherGuarantee_ContactPerson().getText(),  //furcct
			getRightJText_FurtherGuarantee_ContactTitle().getText(),	//furttl
			getRightJText_FurtherGuarantee_EmailAddress().getText(),   //furemail
			getRightJText_FurtherGuarantee_PhoneNumber().getText(),   //furtel
			getRightJText_FurtherGuarantee_FaxNumber().getText(),   //furfax
			getRightJCombo_FurtherGuarantee_CoPayRefType().getText(),  //copaytyp
			getRightJText_FurtherGuarantee_LimitAmt().getText(),  //arlmtamt
			getRightJText_FurtherGuarantee_CvtEndDate().getText(),  //curedate
			getRightJText_ClaimContact_CoPayRefAmount().getText(),  //copayamt
			"Y".equals(getRightCheckBox_FurtherGuarantee_Doctor().getText())?"-1":"0",  //itmtyped
			"Y".equals(getRightCheckBox_FurtherGuarantee_Hospital().getText())?"-1":"0",  //itmtypeh
			"Y".equals(getRightCheckBox_FurtherGuarantee_Special().getText())?"-1":"0",  //itmtypes
			"Y".equals(getRightCheckBox_FurtherGuarantee_Other().getText())?"-1":"0",  //itmtypeo
			getRightJText_StartDate().getText(),  	   //ar_s_date
			getRightJText_TerminationDate().getText(), //ar_e_date
			getUserInfo().getUserID(),				   //USRNAME
			"Y".equals(getRightCheckBox_ArActive().getText())?"-1":"0",	 //42 AR_ACTIVE
			getRightJText_PrimaryCompany().getText(),		//43 ARCPRIMCOMP
			getRightJText_NoContractStartDate().getText(),  //44 NCTRSDATE
			getRightJText_NoContractEndDate().getText(),    //45 NCTREDATE
			getRightJText_ClaimContact_Address4().getText(), //46 ARCADD4
			oldCode,
			"Y".equals(getRightCheckBox_PrtMedRecordRpt().getText())?"-1":"0",	 //47 PRINT_MRRPT
			getRightJText_MstrAR().getText(), //48 MSTR_AR
			"Y".equals(getRightCheckBox_ArInpatient().getText())?"-1":"0",
			"Y".equals(getRightCheckBox_ArOutpatient().getText())?"-1":"0",
			"Y".equals(getRightCheckBox_PayCodeChk().getText())?"-1":"0",	 //49 PAY_CHECK
		    "Y".equals(getRightCheckBox_isDI().getText())?"-1":"0",	 //62 ISDI
		    "Y".equals(getRightJCheckBox_Agreement().getText())?"-1":"0",	 //59 AR_AGREEMENT
		    "Y".equals(getRightCheckBox_ArHealthAssessment().getText())?"-1":"0",	 //52 AR_HTHASSMENT
			"Y".equals(getRightCheckBox_ArOthers().getText())?"-1":"0",	 //53 AR_OTHERS
			getRightJText_ArOthers().getText(), //54 AR_OTHERS_TEXT
		    getAllAutoBrkDown("I"),	//63	INP_CHG_RPTLVL
		    getAllAutoBrkDown("O"),	//64	OP_CHG_RPTLVL
		    "Y".equals(getRightCheckBox_ArPatientSignature().getText())?"-1":"0",	 //65 PATSIGN
		    getRightJText_ARNature().getText(),	//66 AR_NATURE
		    getRightJText_AdmissionContact_Address1().getText(),	//67	ADMADD1
		    getRightJText_AdmissionContact_Address2().getText(),	//68	ADMADD2
		    getRightJText_AdmissionContact_Address3().getText(),	//69	ADMADD3
		    getRightJText_AdmissionContact_Address4().getText(),	//70	ADMADD4
		    getRightJText_RegisteredOffice_Person().getText(),		//71	AGCCCT
		    getRightJText_RegisteredOffice_Title().getText(),	//72	AGCTITLE
		    getRightJText_RegisteredOffice_PhoneNumber().getText(),	//73	AGCTEL
		    getRightJText_RegisteredOffice_FaxNumber().getText(),	//74	AGCFAX
		    getRightJText_RegisteredOffice_EmailAddress().getText(),	//75	AGCEMAIL
		    getRightJText_RegisteredOffice_Address1().getText(),	//76	AGCADD1
		    getRightJText_RegisteredOffice_Address2().getText(),	//77	AGCADD2
		    getRightJText_RegisteredOffice_Address3().getText(),	//78	AGCADD3
		    getRightJText_RegisteredOffice_Address4().getText(),	//79	AGCADD4
		    getRightJText_AuthorizedPerson_Person().getText(),		//80	AUPCCT
		    getRightJText_AuthorizedPerson_Title().getText(),		//81	AUPTITLE
		    getRightJText_AuthorizedPerson_EmailAddress().getText(),	//82	AUPEMAIL
		    getRightJText_AuthorizedPerson_PhoneNumber().getText(),		//83	AUPTEL
		    getRightJText_AuthorizedPerson_FaxNumber().getText(),		//84	AUPFAX
		    getRightJText_AuthorizedPerson_Address1().getText(),		//85	AUPADD1
		    getRightJText_AuthorizedPerson_Address2().getText(),		//86	AUPADD2
		    getRightJText_AuthorizedPerson_Address3().getText(),		//87	AUPADD3
		    getRightJText_AuthorizedPerson_Address4().getText(),		//88	AUPADD4
			getRightJText_ProviderEnquiry_Person().getText(),			//89	PRECCT
			getRightJText_ProviderEnquiry_Title().getText(),			//90	PRETITLE
			getRightJText_ProviderEnquiry_EmailAddress().getText(),			//91	PREEMAIL
			getRightJText_ProviderEnquiry_PhoneNumber().getText(),			//92	PRETEL
			getRightJText_ProviderEnquiry_FaxNumber().getText(),			//93	PREFAX
			getRightJText_ProviderEnquiry_Address1().getText(),			//94	PREADD1
			getRightJText_ProviderEnquiry_Address2().getText(),			//95	PREADD2
			getRightJText_ProviderEnquiry_Address3().getText(),			//96	PREADD3
			getRightJText_ProviderEnquiry_Address4().getText(),			//97	PREADD4
			getRightJText_ArPct().getText()								//98	AR_PCT
		};
		return param;
	}

	/* >>> ~23~ Set Action Validation per table =========================== <<< */
	@Override
	protected void actionValidation(final String actionType) {
		// TODO Auto-generated method stub
		if (getRightJText_ARCode().getText() == null || getRightJText_ARCode().getText().trim().length() == 0) {
			Factory.getInstance().addErrorMessage("Empty AR Code!");
			return;
		} else if (getRightJText_ARName().getText() == null || getRightJText_ARName().getText().trim().length() == 0) {
			Factory.getInstance().addErrorMessage("Empty AR Name!");
			return;
		} else if (getRightJText_GlCode().getText() == null || getRightJText_GlCode().getText().trim().length() == 0) {
			Factory.getInstance().addErrorMessage("Empty GL Code!");
			return;
		} else if (getRightJText_ClaimContact_Address1().getText() == null || getRightJText_ClaimContact_Address1().getText().trim().length() == 0) {
			Factory.getInstance().addErrorMessage("Empty Address!");
			return;
		}
		actionValidationReady(actionType, true);
	}

	public String getAllAutoBrkDown(String slpType){
		if("I".equals(slpType)){
			if("Y".equals(getRightCheckBox_inpCLAutoBrkdown().getText())){ //49 INP_CHG_RPTLVL
				inpAutoBrkDown = "CL";
			}

			if("Y".equals(getRightCheckBox_inpORAutoBrkdown().getText())){ //49 INP_CHG_RPTLVL
				if(inpAutoBrkDown!=null && inpAutoBrkDown.length()>0){
					inpAutoBrkDown = inpAutoBrkDown+"/"+"OR";
				}else{
					inpAutoBrkDown = "OR";
				}
			}

			if("Y".equals(getRightCheckBox_inpCSAutoBrkdown().getText())){ //49 INP_CHG_RPTLVL
				if(inpAutoBrkDown!=null && inpAutoBrkDown.length()>0){
					inpAutoBrkDown = inpAutoBrkDown+"/"+"CS";
				}else{
					inpAutoBrkDown = "CS";
				}
			}

			return inpAutoBrkDown;
		}else if("O".equals(slpType)){
			if("Y".equals(getRightCheckBox_opCLAutoBrkdown().getText())){ //49 INP_CHG_RPTLVL
				opAutoBrkDown = "CL";
			}

			if("Y".equals(getRightCheckBox_opORAutoBrkdown().getText())){ //49 INP_CHG_RPTLVL
				if(opAutoBrkDown!=null && opAutoBrkDown.length()>0){
					opAutoBrkDown = opAutoBrkDown+"/"+"OR";
				}else{
					opAutoBrkDown = "OR";
				}
			}

			if("Y".equals(getRightCheckBox_opCSAutoBrkdown().getText())){ //50 OP_CHG_RPTLVL
				if(opAutoBrkDown!=null && opAutoBrkDown.length()>0){
					opAutoBrkDown = opAutoBrkDown+"/"+"CS";
				}else{
					opAutoBrkDown = "CS";
				}
			}

			return opAutoBrkDown;
		}else{
			return null;
		}
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	public void searchAction() {
		if ((getRightJCombo_ARCompanyCode().getText() == null ||
				getRightJCombo_ARCompanyCode().getText().length() == 0) &&
				(getRightJText_ARCompanyName().getText() == null  ||
				getRightJText_ARCompanyName().getText().trim().length() == 0)) {
			Factory.getInstance().addInformationMessage("Please input criteria.", getRightJCombo_ARCompanyCode());
			return;
		}

		QueryUtil.executeMasterBrowse(
				getUserInfo(), getTxCode(), getBrowseInputParameters(),
			new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					// TODO Auto-generated method stub
					if (mQueue.success() && mQueue.getContentLineCount() > 0) {
						getFetchOutputValues(mQueue.getContentField());
					}else{
						Factory.getInstance().addInformationMessage(MSG_NO_RECORD_FOUND, getRightJCombo_ARCompanyCode());
						return;
					}
				}
			});
	}

	@Override
	public void appendPostAction() {
		getRightCheckBox_ArActive().setSelected(true);
	}

	@Override
	public boolean isTableViewOnly() {
		return false;
	}

	@Override
	protected void enableButton(String mode) {
		disableButton();
		getSearchButton().setEnabled(!isModify() && !isAppend());
		getModifyButton().setEnabled(!isModify() && !isAppend() && getRightJCombo_ARCompanyCode().getText().length()>0);
		getSaveButton().setEnabled(isModify() || isAppend());
		getAppendButton().setEnabled(!isModify() && !isAppend());
		getCancelButton().setEnabled(isModify() || isAppend());
		setAllLeftFieldsEnabled(false);
		if (isAppend()) {
			// empty entry panel content
			emptyAllRightPanelFields();
		}
		// enable all right panel field
		setAllRightFieldsEnabled(isAppend() || isModify());
		getRightJCombo_ARCompanyCode().setEnabled(!isModify() && !isAppend());
		getRightJText_ARCompanyName().setEnabled(!isModify() && !isAppend());
		getLJButton_ConHistory().setEnabled(isAppend() || isModify());
	}

	@Override
	protected void actionValidationReadyHelper(String actionType, MessageQueue mQueue) {
		if (isAppend()) {
//			getNewOutputValue(mQueue.getReturnCode());
			QueryUtil.executeMasterBrowse(
					getUserInfo(), getTxCode(), new String[] {
						getRightJText_ARCode().getText(),
						getRightJText_ARName().getText()},
				new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						// TODO Auto-generated method stub
						getFetchOutputValues(mQueue.getContentField());
					}
				});
		}
		if (isDelete()) {
			clearAction();
		}
		if ((isNewRefresh() && isAppend()) || isModify()) {
			// retrieve from database again
			performList(true);
		} else if (!isRightAlignPanel()) {
			performList(false);
		}
	}


	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/**
	 * This method initializes leftPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected ColumnLayout getSearchPanel() {
		return null;
	}

	/**
	 * This method initializes rightPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected BasePanel getActionPanel() {
		if (rightPanel == null) {
			rightPanel = new BasePanel();
			rightPanel.add(getRightJLabel_ARCompanyCode(), null);
			rightPanel.add(getRightJCombo_ARCompanyCode(), null);
			//rightPanel.add(getRightJLabel_ARCompanyName(), null);
			//rightPanel.add(getRightJText_ARCompanyName(), null);
			rightPanel.add(getGeneralPanel(), null);
//			rightPanel.add(getEditionHistoryPanel(), null);
			rightPanel.add(getExtraPanel(), null);
			//rightPanel.add(getBillingPanel(), null);
			rightPanel.add(getJTabbedPane(), null);
			rightPanel.setBounds(0, 0, 800, 430);
		}
		return rightPanel;
	}

	/**
	 * This method initializes generalPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected ColumnLayout getGeneralPanel() {
		if (generalPanel == null) {
//			generalPanel = new ColumnLayout(6, 7, new int[] {130, 190, 130, 190, 140, 20}, new int[] {18, 18, 18, 20, 18, 18, 18});
			generalPanel = new ColumnLayout(4, 12, new int[] {130, 190, 130, 190}, new int[] {18, 18, 18, 20, 18, 18, 18, 18, 18, 18, 18, 18});
			generalPanel.setHeading("General");
			generalPanel.add(0, 0, getRightJLabel_ARCode());
			generalPanel.add(1, 0, getRightJText_ARCode());
			generalPanel.add(2, 0, getRightJLabel_ArActive());
			generalPanel.add(3, 0, getRightCheckBox_ArActive());
			generalPanel.add(0, 1, getRightJLabel_ARName());
			generalPanel.add(1, 1, getRightJText_ARName());
			generalPanel.add(2, 1, getRightJLabel_ARCName());
			generalPanel.add(3, 1, getRightJText_ARCName());
			generalPanel.add(0, 2, getRightJLabel_PrimaryCompany());
			generalPanel.add(1, 2, getRightJText_PrimaryCompany());
			generalPanel.add(2, 2, getRightJLabel_MstrAR());
			generalPanel.add(3, 2, getRightJText_MstrAR());
			generalPanel.add(0, 3, getRightJLabel_ARNature());
			generalPanel.add(1, 3, getRightJText_ARNature());
			generalPanel.add(0, 4, getRightJLabel_GlCode());
			generalPanel.add(1, 4, getRightJText_GlCode());
			generalPanel.add(2, 4, getRightJLabel_RefundGlCode());
			generalPanel.add(3, 4, getRightJText_RefundGlCode());
			generalPanel.add(0, 5, getRightJLabel_ConstractualPrice());
			generalPanel.add(1, 5, getRightJText_ConstractualPrice());
			generalPanel.add(3, 5, getLJButton_ConHistory());
			generalPanel.add(0, 6, getRightJLabel_StartDate());
			generalPanel.add(1, 6, getRightJText_StartDate());
			generalPanel.add(2, 6, getRightJLabel_TerminationDate());
			generalPanel.add(3, 6, getRightJText_TerminationDate());
			generalPanel.add(0, 7, getRightJLabel_NoContractStartDate());
			generalPanel.add(1, 7, getRightJText_NoContractStartDate());
			generalPanel.add(2, 7, getRightJLabel_NoContractEndDate());
			generalPanel.add(3, 7, getRightJText_NoContractEndDate());
			generalPanel.add(0, 8, getRightJLabel_ArPct());
			generalPanel.add(1, 8, getRightJText_ArPct());
			
			generalPanel.add(0, 9, getRightJLabel_CreatedBy());
			generalPanel.add(1, 9, getRightJText_CreatedBy());
			generalPanel.add(2, 9, getRightJLabel_CreatedDate());
			generalPanel.add(3, 9, getRightJText_CreatedDate());
			generalPanel.add(0, 10, getRightJLabel_LastUpdateBy());
			generalPanel.add(1, 10, getRightJText_LastUpdateBy());
			generalPanel.add(2, 10, getRightJLabel_LastUpdateDate());
			generalPanel.add(3, 10, getRightJText_LastUpdateDate());
/*
			generalPanel.add(4, 0, getRightJLabel_ArActive());
			generalPanel.add(4, 1, getRightJLabel_ArInpatient());
			generalPanel.add(4, 2, getRightJLabel_ArOutpatient());
			generalPanel.add(4, 3, getRightJLabel_ArHealthAssessment());
			generalPanel.add(4, 4, getRightJLabel_ArOthers());
			generalPanel.add(4, 4, getRightJText_ArOthers());
			generalPanel.add(5, 0, getRightCheckBox_ArActive());
			generalPanel.add(5, 1, getRightCheckBox_ArInpatient());
			generalPanel.add(5, 2, getRightCheckBox_ArOutpatient());
			generalPanel.add(5, 3, getRightCheckBox_ArHealthAssessment());
			generalPanel.add(5, 4, getRightCheckBox_ArOthers());


			generalPanel.add(2, 6, getRightJLabel_Agreement());
			generalPanel.add(3, 6, getRightJCheckBox_Agreement());
	*/
			generalPanel.setBounds(0, 25, 620, 285);
		}
		return generalPanel;
	}

	protected FieldSetBase getEditionHistoryPanel() {
		if (editionHistoryPanel == null) {
			editionHistoryPanel = new FieldSetBase();
			editionHistoryPanel.setHeading("Edition History");
			editionHistoryPanel.add(getRightJLabel_CreatedBy(), null);
			editionHistoryPanel.add(getRightJText_CreatedBy(), null);
			editionHistoryPanel.add(getRightJLabel_CreatedDate(), null);
			editionHistoryPanel.add(getRightJText_CreatedDate(), null);
			editionHistoryPanel.add(getRightJLabel_LastUpdateBy(), null);
			editionHistoryPanel.add(getRightJText_LastUpdateBy(), null);
			editionHistoryPanel.add(getRightJLabel_LastUpdateDate(), null);
			editionHistoryPanel.add(getRightJText_LastUpdateDate(), null);
			editionHistoryPanel.setBounds(0, 310, 800, 80);
		}
		return editionHistoryPanel;
	}

	/**
	 * This method initializes RightBasePanel_AdmissionContact
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	private BasePanel getAdmissionContactPanel() {
		if (RightBasePanel_AdmissionContact == null) {
			RightBasePanel_AdmissionContact = new BasePanel();
			RightBasePanel_AdmissionContact.add(getRightJLabel_AdmissionContact_Person(), null);
			RightBasePanel_AdmissionContact.add(getRightJText_AdmissionContact_Person(), null);
			RightBasePanel_AdmissionContact.add(getRightJLabel_AdmissionContact_Title(), null);
			RightBasePanel_AdmissionContact.add(getRightJText_AdmissionContact_Title(), null);
			RightBasePanel_AdmissionContact.add(getRightJLabel_AdmissionContact_PhoneNumber(), null);
			RightBasePanel_AdmissionContact.add(getRightJText_AdmissionContact_PhoneNumber(), null);
			RightBasePanel_AdmissionContact.add(getRightJLabel_AdmissionContact_FaxNumber(), null);
			RightBasePanel_AdmissionContact.add(getRightJText_AdmissionContact_FaxNumber(), null);

			RightBasePanel_AdmissionContact.add(getRightJLabel_AdmissionContact_EmailAddress(), null);
			RightBasePanel_AdmissionContact.add(getRightJText_AdmissionContact_EmailAddress(), null);
			RightBasePanel_AdmissionContact.add(getRightJLabel_AdmissionContract_AdmissionNotice(), null);
			RightBasePanel_AdmissionContact.add(getRightCheckBox_AdmissionContract_AdmissionNotice(), null);

			RightBasePanel_AdmissionContact.add(getRightJLabel_AdmissionContact_Address(), null);
			RightBasePanel_AdmissionContact.add(getRightJText_AdmissionContact_Address1(), null);
			RightBasePanel_AdmissionContact.add(getRightJText_AdmissionContact_Address2(), null);
			RightBasePanel_AdmissionContact.add(getRightJText_AdmissionContact_Address3(), null);
			RightBasePanel_AdmissionContact.add(getRightJText_AdmissionContact_Address4(), null);
		}
		return RightBasePanel_AdmissionContact;
	}

	/**
	 * This method initializes RightBasePanel_FurtherGuaranteePanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	private BasePanel getRightBasePanel_FurtherGuaranteePanel() {
		if (RightBasePanel_FurtherGuaranteePanel == null) {
			RightBasePanel_FurtherGuaranteePanel = new BasePanel();
			RightBasePanel_FurtherGuaranteePanel.add(getRightJLabel_FurtherGuarantee_ContactPerson(), null);
			RightBasePanel_FurtherGuaranteePanel.add(getRightJText_FurtherGuarantee_ContactPerson(), null);
			RightBasePanel_FurtherGuaranteePanel.add(getRightJLabel_FurtherGuarantee_ContactTitle(), null);
			RightBasePanel_FurtherGuaranteePanel.add(getRightJText_FurtherGuarantee_ContactTitle(), null);
			RightBasePanel_FurtherGuaranteePanel.add(getRightJLabel_FurtherGuarantee_PhoneNumber(), null);
			RightBasePanel_FurtherGuaranteePanel.add(getRightJText_FurtherGuarantee_PhoneNumber(), null);
			RightBasePanel_FurtherGuaranteePanel.add(getRightJLabel_FurtherGuarantee_FaxNumber(), null);
			RightBasePanel_FurtherGuaranteePanel.add(getRightJText_FurtherGuarantee_FaxNumber(), null);

			RightBasePanel_FurtherGuaranteePanel.add(getRightJLabel_FurtherGuarantee_EmailAddress(), null);
			RightBasePanel_FurtherGuaranteePanel.add(getRightJText_FurtherGuarantee_EmailAddress(), null);
			RightBasePanel_FurtherGuaranteePanel.add(getRightJLabel_FurtherGuarantee_LimitAmt(), null);
			RightBasePanel_FurtherGuaranteePanel.add(getRightJText_FurtherGuarantee_LimitAmt(), null);
			RightBasePanel_FurtherGuaranteePanel.add(getRightJLabel_FurtherGuarantee_CoPayRefNo(), null);
			RightBasePanel_FurtherGuaranteePanel.add(getRightJCombo_FurtherGuarantee_CoPayRefType(), null);
			RightBasePanel_FurtherGuaranteePanel.add(getRightJText_ClaimContact_CoPayRefAmount(), null);
			RightBasePanel_FurtherGuaranteePanel.add(getRightJLabel_FurtherGuarantee_CvtEndDate(), null);
			RightBasePanel_FurtherGuaranteePanel.add(getRightJText_FurtherGuarantee_CvtEndDate(), null);

			RightBasePanel_FurtherGuaranteePanel.add(getRightJLabel_FurtherGuarantee_CoverredItem(), null);
			RightBasePanel_FurtherGuaranteePanel.add(getRightCheckBox_FurtherGuarantee_Doctor(), null);
			RightBasePanel_FurtherGuaranteePanel.add(getRightJLabel_FurtherGuarantee_Doctor(),null);
			RightBasePanel_FurtherGuaranteePanel.add(getRightCheckBox_FurtherGuarantee_Hospital(), null);
			RightBasePanel_FurtherGuaranteePanel.add(getRightJLabel_FurtherGuarantee_Hospital(),null);
			RightBasePanel_FurtherGuaranteePanel.add(getRightCheckBox_FurtherGuarantee_Special(), null);
			RightBasePanel_FurtherGuaranteePanel.add(getRightJLabel_FurtherGuarantee_Special(), null);
			RightBasePanel_FurtherGuaranteePanel.add(getRightCheckBox_FurtherGuarantee_Other(), null);
			RightBasePanel_FurtherGuaranteePanel.add(getRightJLabel_FurtherGuarantee_ConveredItemOther(), null);
		}
		return RightBasePanel_FurtherGuaranteePanel;
	}

	private BasePanel getRightBasePanel_RegisteredOfficePanel() {
		if (RightBasePanel_RegisteredOffice == null) {
			RightBasePanel_RegisteredOffice = new BasePanel();
			RightBasePanel_RegisteredOffice.add(getRightJLabel_RegisteredOffice_Person(), null);
			RightBasePanel_RegisteredOffice.add(getRightJText_RegisteredOffice_Person(), null);
			RightBasePanel_RegisteredOffice.add(getRightJLabel_RegisteredOffice_Title(), null);
			RightBasePanel_RegisteredOffice.add(getRightJText_RegisteredOffice_Title(), null);
			RightBasePanel_RegisteredOffice.add(getRightJLabel_RegisteredOffice_PhoneNumber(), null);
			RightBasePanel_RegisteredOffice.add(getRightJText_RegisteredOffice_PhoneNumber(), null);
			RightBasePanel_RegisteredOffice.add(getRightJLabel_RegisteredOffice_FaxNumber(), null);
			RightBasePanel_RegisteredOffice.add(getRightJText_RegisteredOffice_FaxNumber(), null);

			RightBasePanel_RegisteredOffice.add(getRightJLabel_RegisteredOffice_EmailAddress(), null);
			RightBasePanel_RegisteredOffice.add(getRightJText_RegisteredOffice_EmailAddress(), null);

			RightBasePanel_RegisteredOffice.add(getRightJLabel_RegisteredOffice_Address(), null);
			RightBasePanel_RegisteredOffice.add(getRightJText_RegisteredOffice_Address1(), null);
			RightBasePanel_RegisteredOffice.add(getRightJText_RegisteredOffice_Address2(), null);
			RightBasePanel_RegisteredOffice.add(getRightJText_RegisteredOffice_Address3(), null);
			RightBasePanel_RegisteredOffice.add(getRightJText_RegisteredOffice_Address4(), null);
		}
		return RightBasePanel_RegisteredOffice;
	}

	private BasePanel getRightBasePanel_AuthorizedPersonPanel() {
		if (RightBasePanel_AuthorizedPerson == null) {
			RightBasePanel_AuthorizedPerson = new BasePanel();
			RightBasePanel_AuthorizedPerson.add(getRightJLabel_AuthorizedPerson_Person(), null);
			RightBasePanel_AuthorizedPerson.add(getRightJText_AuthorizedPerson_Person(), null);
			RightBasePanel_AuthorizedPerson.add(getRightJLabel_AuthorizedPerson_Title(), null);
			RightBasePanel_AuthorizedPerson.add(getRightJText_AuthorizedPerson_Title(), null);
			RightBasePanel_AuthorizedPerson.add(getRightJLabel_AuthorizedPerson_PhoneNumber(), null);
			RightBasePanel_AuthorizedPerson.add(getRightJText_AuthorizedPerson_PhoneNumber(), null);
			RightBasePanel_AuthorizedPerson.add(getRightJLabel_AuthorizedPerson_FaxNumber(), null);
			RightBasePanel_AuthorizedPerson.add(getRightJText_AuthorizedPerson_FaxNumber(), null);

			RightBasePanel_AuthorizedPerson.add(getRightJLabel_AuthorizedPerson_EmailAddress(), null);
			RightBasePanel_AuthorizedPerson.add(getRightJText_AuthorizedPerson_EmailAddress(), null);

			RightBasePanel_AuthorizedPerson.add(getRightJLabel_AuthorizedPerson_Address(), null);
			RightBasePanel_AuthorizedPerson.add(getRightJText_AuthorizedPerson_Address1(), null);
			RightBasePanel_AuthorizedPerson.add(getRightJText_AuthorizedPerson_Address2(), null);
			RightBasePanel_AuthorizedPerson.add(getRightJText_AuthorizedPerson_Address3(), null);
			RightBasePanel_AuthorizedPerson.add(getRightJText_AuthorizedPerson_Address4(), null);
		}
		return RightBasePanel_AuthorizedPerson;
	}

	/**
	 * This method initializes billingPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	private BasePanel getBillingPanel() {
		if (billingPanel == null) {
			billingPanel = new BasePanel();
			billingPanel.add(getRightJLabel_ClaimContact_Person(), null);
			billingPanel.add(getRightJText_ClaimContact_Person(), null);
			billingPanel.add(getRightJLabel_ClaimContact_Title(), null);
			billingPanel.add(getRightJText_ClaimContact_Title(), null);
			billingPanel.add(getRightJLabel_ClaimContact_PhoneNumber(), null);
			billingPanel.add(getRightJText_ClaimContact_PhoneNumber(), null);
			billingPanel.add(getRightJLabel_ClaimContact_FaxNumber(), null);
			billingPanel.add(getRightJText_ClaimContact_FaxNumber(), null);
			billingPanel.add(getRightJLabel_ClaimContact_EmailAddress(), null);
			billingPanel.add(getRightJText_ClaimContact_EmailAddress(), null);
			billingPanel.add(getRightJLabel_ClaimContact_Address(), null);
			billingPanel.add(getRightJText_ClaimContact_Address1(), null);
			billingPanel.add(getRightJText_ClaimContact_Address2(), null);
			billingPanel.add(getRightJText_ClaimContact_Address3(), null);
			billingPanel.add(getRightJText_ClaimContact_Address4(), null);
		}
		return billingPanel;
	}

	/**
	 * @return the rightBasePanel_ProviderEnquiry
	 */
	private BasePanel getRightBasePanel_ProviderEnquiry() {
		if (RightBasePanel_ProviderEnquiry == null) {
			RightBasePanel_ProviderEnquiry = new BasePanel();
			RightBasePanel_ProviderEnquiry.add(getRightJLabel_ProviderEnquiry_Person(), null);
			RightBasePanel_ProviderEnquiry.add(getRightJText_ProviderEnquiry_Person(), null);
			RightBasePanel_ProviderEnquiry.add(getRightJLabel_ProviderEnquiry_Title(), null);
			RightBasePanel_ProviderEnquiry.add(getRightJText_ProviderEnquiry_Title(), null);
			RightBasePanel_ProviderEnquiry.add(getRightJLabel_ProviderEnquiry_PhoneNumber(), null);
			RightBasePanel_ProviderEnquiry.add(getRightJText_ProviderEnquiry_PhoneNumber(), null);
			RightBasePanel_ProviderEnquiry.add(getRightJLabel_ProviderEnquiry_FaxNumber(), null);
			RightBasePanel_ProviderEnquiry.add(getRightJText_ProviderEnquiry_FaxNumber(), null);

			RightBasePanel_ProviderEnquiry.add(getRightJLabel_ProviderEnquiry_EmailAddress(), null);
			RightBasePanel_ProviderEnquiry.add(getRightJText_ProviderEnquiry_EmailAddress(), null);

			RightBasePanel_ProviderEnquiry.add(getRightJLabel_ProviderEnquiry_Address(), null);
			RightBasePanel_ProviderEnquiry.add(getRightJText_ProviderEnquiry_Address1(), null);
			RightBasePanel_ProviderEnquiry.add(getRightJText_ProviderEnquiry_Address2(), null);
			RightBasePanel_ProviderEnquiry.add(getRightJText_ProviderEnquiry_Address3(), null);
			RightBasePanel_ProviderEnquiry.add(getRightJText_ProviderEnquiry_Address4(), null);
		}
		return RightBasePanel_ProviderEnquiry;
	}

	public FieldSetBase getExtraPanel() {
		if (extraPanel == null) {
			extraPanel = new FieldSetBase();
//			extraPanel.add(getLJButton_ConHistory());
//			extraPanel.add(getRightCheckBox_ArActive(), null);
//			extraPanel.add(getRightJLabel_ArActive(), null);

			extraPanel.add(getRightJLabel_ArInpatient());
			extraPanel.add(getRightCheckBox_ArInpatient());
			extraPanel.add(getRightJLabel_ArOutpatient());
			extraPanel.add(getRightCheckBox_ArOutpatient());
			extraPanel.add(getRightJLabel_ArPatientSignature());
			extraPanel.add(getRightCheckBox_ArPatientSignature());
			extraPanel.add(getRightJLabel_ArHealthAssessment());
			extraPanel.add(getRightCheckBox_ArHealthAssessment());
			extraPanel.add(getRightJLabel_ArOthers());
			extraPanel.add(getRightCheckBox_ArOthers());
			extraPanel.add(getRightJText_ArOthers());
			extraPanel.add(getRightJLabel_Agreement());
			extraPanel.add(getRightJCheckBox_Agreement());

			extraPanel.add(getRightJLabel_PrtMedRecordRpt(), null);
			extraPanel.add(getRightCheckBox_PrtMedRecordRpt(), null);
			extraPanel.add(getRightJLabel_PayCodeChk(), null);
			extraPanel.add(getRightCheckBox_PayCodeChk(), null);
			extraPanel.add(getRightJLabel_isDIDesc(), null);
			extraPanel.add(getRightCheckBox_isDI(), null);
			extraPanel.add(getRightJLabel_inpAutoBrkdown(), null);
			extraPanel.add(getRightJLabel_opAutoBrkdown(), null);
			extraPanel.add(getRightJLabel_CLAutoBrkdown(), null);
			extraPanel.add(getRightJLabel_ORAutoBrkdown(), null);
			extraPanel.add(getRightJLabel_CSAutoBrkdown(), null);
			extraPanel.add(getRightCheckBox_inpCLAutoBrkdown(), null);
			extraPanel.add(getRightCheckBox_inpORAutoBrkdown(), null);
			extraPanel.add(getRightCheckBox_inpCSAutoBrkdown(), null);
			extraPanel.add(getRightCheckBox_opCLAutoBrkdown(), null);
			extraPanel.add(getRightCheckBox_opORAutoBrkdown(), null);
			extraPanel.add(getRightCheckBox_opCSAutoBrkdown(), null);
			extraPanel.setBounds(621, 36, 178, 275);
		}
		return extraPanel;
	}

	private LabelBase getRightJLabel_ProviderEnquiry_Person() {
		if (RightJLabel_ProviderEnquiry_Person == null) {
			RightJLabel_ProviderEnquiry_Person = new LabelBase();
			RightJLabel_ProviderEnquiry_Person.setBounds(17, 0, 130, 20);
			RightJLabel_ProviderEnquiry_Person.setText("Contact Person");
		}
		return RightJLabel_ProviderEnquiry_Person;
	}

	private TextBase getRightJText_ProviderEnquiry_Person() {
		if (RightJText_ProviderEnquiry_Person == null) {
			RightJText_ProviderEnquiry_Person = new TextBase();
			RightJText_ProviderEnquiry_Person.setBounds(140, 0, 170, 20);
		}
		return RightJText_ProviderEnquiry_Person;
	}

	private LabelBase getRightJLabel_ProviderEnquiry_Title() {
		if (RightJLabel_ProviderEnquiry_Title == null) {
			RightJLabel_ProviderEnquiry_Title = new LabelBase();
			RightJLabel_ProviderEnquiry_Title.setText("Title");
			RightJLabel_ProviderEnquiry_Title.setBounds(17, 22, 130, 20);
		}
		return RightJLabel_ProviderEnquiry_Title;
	}

	private TextBase getRightJText_ProviderEnquiry_Title() {
		if (RightJText_ProviderEnquiry_Title == null) {
			RightJText_ProviderEnquiry_Title = new TextBase();
			RightJText_ProviderEnquiry_Title.setBounds(140, 22, 170, 20);
		}
		return RightJText_ProviderEnquiry_Title;
	}

	private LabelBase getRightJLabel_ProviderEnquiry_PhoneNumber() {
		if (RightJLabel_ProviderEnquiry_PhoneNumber == null) {
			RightJLabel_ProviderEnquiry_PhoneNumber = new LabelBase();
			RightJLabel_ProviderEnquiry_PhoneNumber.setText("Phone Number");
			RightJLabel_ProviderEnquiry_PhoneNumber.setBounds(17, 44, 140, 20);
		}
		return RightJLabel_ProviderEnquiry_PhoneNumber;
	}

	private TextPhone getRightJText_ProviderEnquiry_PhoneNumber() {
		if (RightJText_ProviderEnquiry_PhoneNumber == null) {
			RightJText_ProviderEnquiry_PhoneNumber = new TextPhone();
			RightJText_ProviderEnquiry_PhoneNumber.setBounds(140, 44, 170, 20);
		}
		return RightJText_ProviderEnquiry_PhoneNumber;
	}

	private LabelBase getRightJLabel_ProviderEnquiry_FaxNumber() {
		if (RightJLabel_ProviderEnquiry_FaxNumber == null) {
			RightJLabel_ProviderEnquiry_FaxNumber = new LabelBase();
			RightJLabel_ProviderEnquiry_FaxNumber.setText("Fax Number");
			RightJLabel_ProviderEnquiry_FaxNumber.setBounds(17, 66, 140, 20);
		}
		return RightJLabel_ProviderEnquiry_FaxNumber;
	}

	private TextPhone getRightJText_ProviderEnquiry_FaxNumber() {
		if (RightJText_ProviderEnquiry_FaxNumber == null) {
			RightJText_ProviderEnquiry_FaxNumber = new TextPhone();
			RightJText_ProviderEnquiry_FaxNumber.setBounds(140, 66, 170, 20);
		}
		return RightJText_ProviderEnquiry_FaxNumber;
	}

	private LabelBase getRightJLabel_ProviderEnquiry_EmailAddress() {
		if (RightJLabel_ProviderEnquiry_EmailAddress == null) {
			RightJLabel_ProviderEnquiry_EmailAddress = new LabelBase();
			RightJLabel_ProviderEnquiry_EmailAddress.setBounds(350, 0, 130, 20);
			RightJLabel_ProviderEnquiry_EmailAddress.setText("Email Address");
		}
		return RightJLabel_ProviderEnquiry_EmailAddress;
	}

	private TextBase getRightJText_ProviderEnquiry_EmailAddress() {
		if (RightJText_ProviderEnquiry_EmailAddress == null) {
			RightJText_ProviderEnquiry_EmailAddress = new TextBase();
			RightJText_ProviderEnquiry_EmailAddress.setBounds(460, 0, 300, 20);
		}
		return RightJText_ProviderEnquiry_EmailAddress;
	}

	/**
	 * @return the rightJLabel_AdmissionContact_Address
	 */
	private LabelBase getRightJLabel_ProviderEnquiry_Address() {
		if (RightJLabel_ProviderEnquiry_Address == null) {
			RightJLabel_ProviderEnquiry_Address = new LabelBase();
			RightJLabel_ProviderEnquiry_Address.setText("Address");
			RightJLabel_ProviderEnquiry_Address.setBounds(350, 22, 130, 20);
		}
		return RightJLabel_ProviderEnquiry_Address;
	}

	/**
	 * @return the rightJText_AdmissionContact_Address1
	 */
	private TextBase getRightJText_ProviderEnquiry_Address1() {
		if (RightJText_ProviderEnquiry_Address1 == null) {
			RightJText_ProviderEnquiry_Address1 = new TextBase();
			RightJText_ProviderEnquiry_Address1.setBounds(460, 22, 300, 20);
		}
		return RightJText_ProviderEnquiry_Address1;
	}

	/**
	 * @return the rightJText_AdmissionContact_Address2
	 */
	private TextBase getRightJText_ProviderEnquiry_Address2() {
		if (RightJText_ProviderEnquiry_Address2 == null) {
			RightJText_ProviderEnquiry_Address2 = new TextBase();
			RightJText_ProviderEnquiry_Address2.setBounds(460, 44, 300, 20);
		}
		return RightJText_ProviderEnquiry_Address2;
	}

	/**
	 * @return the rightJText_AdmissionContact_Address3
	 */
	private TextBase getRightJText_ProviderEnquiry_Address3() {
		if (RightJText_ProviderEnquiry_Address3 == null) {
			RightJText_ProviderEnquiry_Address3 = new TextBase();
			RightJText_ProviderEnquiry_Address3.setBounds(460, 66, 300, 20);
		}
		return RightJText_ProviderEnquiry_Address3;
	}

	/**
	 * @return the rightJText_AdmissionContact_Address4
	 */
	private TextBase getRightJText_ProviderEnquiry_Address4() {
		if (RightJText_ProviderEnquiry_Address4 == null) {
			RightJText_ProviderEnquiry_Address4 = new TextBase();
			RightJText_ProviderEnquiry_Address4.setBounds(460, 88, 300, 20);
		}
		return RightJText_ProviderEnquiry_Address4;
	}

	/**
	 * This method initializes jTabbedPane
	 *
	 * @return javax.swing.JTabbedPane
	 */
	private TabbedPaneBase getJTabbedPane() {
		if (jTabbedPane == null) {
			jTabbedPane = new TabbedPaneBase();
			jTabbedPane.addTab("Admission Contact", null, getAdmissionContactPanel(), "Admission Contact");
			jTabbedPane.addTab("Further Guarantee", null, getRightBasePanel_FurtherGuaranteePanel(), "Further Guarantee");
			jTabbedPane.addTab("Agreement Contact", null, getRightBasePanel_RegisteredOfficePanel(), "Agreement Contact");
			jTabbedPane.addTab("Authorized Person", null, getRightBasePanel_AuthorizedPersonPanel(), "Authorized Person");
			jTabbedPane.addTab("Billing", null, getBillingPanel(), "Billing");
			jTabbedPane.addTab("Provider Enquiry", null, getRightBasePanel_ProviderEnquiry(), "Provider Enquiry");
			jTabbedPane.setBounds(0, 320, 800, 255);
		}
		return jTabbedPane;
	}

	/**
	 * This method initializes RightJLabel_ARCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_ARCode() {
		if (RightJLabel_ARCode == null) {
			RightJLabel_ARCode = new LabelBase();
			RightJLabel_ARCode.setText("AR Code");
//			RightJLabel_ARCode.setBounds(16, 16, 140, 20);
			RightJLabel_ARCode.setHeight(18);
		}
		return RightJLabel_ARCode;
	}

	/**
	 * This method initializes RightJText_ARCode
	 *
	 * @return com.hkah.client.layout.textfield.TextARCode
	 */
	private TextARCode getRightJText_ARCode() {
		if (RightJText_ARCode == null) {
			RightJText_ARCode = new TextARCode() {
				@Override
				public void onReleased() {
					//setCurrentTable(0, RightJText_ARCode.getText());
				}

				@Override
				public void onBlur() {
					if (isAppend() || isModify()) {
						if (!getRightJText_ARCode().isEmpty()) {
							if (isModify() && oldCode.equals(getRightJText_ARCode().getText())) {
							} else {
								QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
										new String[] {"ArCode", "ArcCode", "ArcCode='"+RightJText_ARCode.getText()+"'"},
										new MessageQueueCallBack() {
									@Override
									public void onPostSuccess(MessageQueue mQueue) {
										if (mQueue.success()) {
											Factory.getInstance().addErrorMessage("Record exists.", getRightJText_ARCode());
											getRightJText_ARCode().resetText();
											//setCurrentTable(0, "");
										} else {
											//setCurrentTable(0, getRightJText_ARCode().getText());
										}
									}
								});
							}
						}
					}
				};
			};
			RightJText_ARCode.setWidth(180);
			RightJText_ARCode.setHeight(18);
		}
		return RightJText_ARCode;
	}

	private LabelBase getRightJLabel_CreatedBy() {
		if (RightJLabel_CreatedBy == null) {
			RightJLabel_CreatedBy = new LabelBase();
			RightJLabel_CreatedBy.setText("Created By");
//			RightJLabel_CreatedBy.setBounds(5, 0, 100, 20);
			RightJLabel_CreatedBy.setHeight(18);
		}
		return RightJLabel_CreatedBy;
	}

	private TextReadOnly getRightJText_CreatedBy() {
		if (RightJText_CreatedBy == null) {
			RightJText_CreatedBy = new TextReadOnly();
//			RightJText_CreatedBy.setBounds(132, 0, 170, 20);
			RightJText_CreatedBy.setHeight(18);
		}
		return RightJText_CreatedBy;
	}

	private LabelBase getRightJLabel_CreatedDate() {
		if (RightJLabel_CreatedDate == null) {
			RightJLabel_CreatedDate = new LabelBase();
			RightJLabel_CreatedDate.setText("Created date/time");
//			RightJLabel_CreatedDate.setBounds(320, 0, 150, 20);
			RightJLabel_CreatedDate.setHeight(18);
		}
		return RightJLabel_CreatedDate;
	}

	private TextReadOnly getRightJText_CreatedDate() {
		if (RightJText_CreatedDate == null) {
			RightJText_CreatedDate = new TextReadOnly();
//			RightJText_CreatedDate.setBounds(445, 0, 170, 20);
			RightJText_CreatedDate.setHeight(18);
		}
		return RightJText_CreatedDate;
	}

	private LabelBase getRightJLabel_LastUpdateBy() {
		if (RightJLabel_LastUpdateBy == null) {
			RightJLabel_LastUpdateBy = new LabelBase();
			RightJLabel_LastUpdateBy.setText("Last update by");
//			RightJLabel_LastUpdateBy.setBounds(5, 25, 100, 20);
		}
		return RightJLabel_LastUpdateBy;
	}

	private TextReadOnly getRightJText_LastUpdateBy() {
		if (RightJText_LastUpdateBy == null) {
			RightJText_LastUpdateBy = new TextReadOnly();
//			RightJText_LastUpdateBy.setBounds(132, 25, 170, 20);
			RightJText_LastUpdateBy.setHeight(18);
		}
		return RightJText_LastUpdateBy;
	}

	private LabelBase getRightJLabel_LastUpdateDate() {
		if (RightJLabel_LastUpdateDate == null) {
			RightJLabel_LastUpdateDate = new LabelBase();
			RightJLabel_LastUpdateDate.setText("Last update date/time");
//			RightJLabel_LastUpdateDate.setBounds(320, 25, 150, 20);
			RightJLabel_LastUpdateDate.setHeight(18);
		}
		return RightJLabel_LastUpdateDate;
	}

	private TextReadOnly getRightJText_LastUpdateDate() {
		if (RightJText_LastUpdateDate == null) {
			RightJText_LastUpdateDate = new TextReadOnly();
//			RightJText_LastUpdateDate.setBounds(445, 25, 170, 20);
			RightJText_LastUpdateDate.setHeight(18);
		}
		return RightJText_LastUpdateDate;
	}

	private LabelBase getRightJLabel_ArActive() {
		if (RightJLabel_ArActive == null) {
			RightJLabel_ArActive = new LabelBase();
			RightJLabel_ArActive.setText("Active");
//			RightJLabel_ArActive.setBounds(5, 0, 100, 20);
			RightJLabel_ArActive.setHeight(18);
		}
		return RightJLabel_ArActive;
	}

	private CheckBoxBase getRightCheckBox_ArActive() {
		if (RightCheckBox_ArActive == null) {
			RightCheckBox_ArActive = new CheckBoxBase();
//			RightCheckBox_ArActive.setBounds(25, 5, 100, 20);
			RightCheckBox_ArActive.setHeight(18);
		}
		return RightCheckBox_ArActive;
	}

	private LabelBase getRightJLabel_ArInpatient() {
		if (RightJLabel_ArInpatient == null) {
			RightJLabel_ArInpatient = new LabelBase();
			RightJLabel_ArInpatient.setText("Inpat");
			RightJLabel_ArInpatient.setBounds(5, 25, 70, 20);
//			RightJLabel_ArInpatient.setHeight(18);
		}
		return RightJLabel_ArInpatient;
	}

	private CheckBoxBase getRightCheckBox_ArInpatient() {
		if (RightCheckBox_ArInpatient == null) {
			RightCheckBox_ArInpatient = new CheckBoxBase();
			RightCheckBox_ArInpatient.setBounds(65, 25, 20, 20);
//			RightCheckBox_ArInpatient.setHeight(18);
		}
		return RightCheckBox_ArInpatient;
	}

	private LabelBase getRightJLabel_ArOutpatient() {
		if (RightJLabel_ArOutpatient == null) {
			RightJLabel_ArOutpatient = new LabelBase();
			RightJLabel_ArOutpatient.setText("Outpat");
			RightJLabel_ArOutpatient.setBounds(90, 25, 70, 20);
//			RightJLabel_ArOutpatient.setHeight(18);
		}
		return RightJLabel_ArOutpatient;
	}

	private CheckBoxBase getRightCheckBox_ArOutpatient() {
		if (RightCheckBox_ArOutpatient == null) {
			RightCheckBox_ArOutpatient = new CheckBoxBase();
			RightCheckBox_ArOutpatient.setBounds(135, 25, 20, 20);
//			RightCheckBox_ArOutpatient.setHeight(18);
		}
		return RightCheckBox_ArOutpatient;
	}

	private LabelBase getRightJLabel_ArPatientSignature() {
		if (RightJLabel_ArPatientSign == null) {
			RightJLabel_ArPatientSign = new LabelBase();
			RightJLabel_ArPatientSign.setText("Patient Signature");
			RightJLabel_ArPatientSign.setBounds(5, 240, 125, 20);
//			RightJLabel_ArPatientSign(18);
		}
		return RightJLabel_ArPatientSign;
	}

	private CheckBoxBase getRightCheckBox_ArPatientSignature() {
		if (RightCheckBox_ArPatientSign == null) {
			RightCheckBox_ArPatientSign = new CheckBoxBase();
			RightCheckBox_ArPatientSign.setBounds(135, 240, 20, 20);
//			RightCheckBox_ArPatientSign(18);
		}
		return RightCheckBox_ArPatientSign;
	}

	private LabelBase getRightJLabel_ArHealthAssessment() {
		if (RightJLabel_ArHealthAssessment == null) {
			RightJLabel_ArHealthAssessment = new LabelBase();
			RightJLabel_ArHealthAssessment.setText("Health Assessment");
			RightJLabel_ArHealthAssessment.setBounds(5, 50, 150, 60);
//			RightJLabel_ArHealthAssessment.setHeight(18);
		}
		return RightJLabel_ArHealthAssessment;
	}

	private CheckBoxBase getRightCheckBox_ArHealthAssessment() {
		if (RightCheckBox_ArHealthAssessment == null) {
			RightCheckBox_ArHealthAssessment = new CheckBoxBase();
			RightCheckBox_ArHealthAssessment.setBounds(135, 50, 20, 20);
//			RightCheckBox_ArHealthAssessment.setHeight(18);
		}
		return RightCheckBox_ArHealthAssessment;
	}

	private LabelBase getRightJLabel_ArOthers() {
		if (RightJLabel_ArOthers == null) {
			RightJLabel_ArOthers = new LabelBase();
			RightJLabel_ArOthers.setText("Others");
			RightJLabel_ArOthers.setBounds(5, 70, 20, 100);
//			RightJLabel_ArOthers.setHeight(18);
		}
		return RightJLabel_ArOthers;
	}

	private CheckBoxBase getRightCheckBox_ArOthers() {
		if (RightCheckBox_ArOthers == null) {
			RightCheckBox_ArOthers = new CheckBoxBase();
			RightCheckBox_ArOthers.setBounds(135, 70, 20, 20);
//			RightCheckBox_ArOthers.setHeight(18);
		}
		return RightCheckBox_ArOthers;
	}

	private TextBase getRightJText_ArOthers() {
		if (RightText_ArOthers == null) {
			RightText_ArOthers = new TextBase();
			RightText_ArOthers.setBounds(5, 95, 160, 20);
//			RightText_ArOthers.setHeight(18);
		}
		return RightText_ArOthers;
	}

	private LabelBase getRightJLabel_PrimaryCompany() {
		if (RightJLabel_PrimaryCompany == null) {
			RightJLabel_PrimaryCompany = new LabelBase();
			RightJLabel_PrimaryCompany.setText("Primary Company");
			RightJLabel_PrimaryCompany.setHeight(19);
		}
		return RightJLabel_PrimaryCompany;
	}

	private ComboArPrimComp getRightJText_PrimaryCompany() {
		if (RightJText_PrimaryCompany == null) {
			RightJText_PrimaryCompany = new ComboArPrimComp(/*getListTable(), 41*/);
			RightJText_PrimaryCompany.setSize(180, 18);
		}
		return RightJText_PrimaryCompany;
	}

	private LabelBase getRightJLabel_MstrAR() {
		if (RightJLabel_MstrAR == null) {
			RightJLabel_MstrAR = new LabelBase();
			RightJLabel_MstrAR.setText("Mstr AR");
//			RightJLabel_MstrAR.setBounds(314, 47, 112, 20);
			RightJLabel_MstrAR.setHeight(18);
		}
		return RightJLabel_MstrAR;
	}

	/**
	 * This method initializes RightJText_GlCode
	 *
	 * @return com.hkah.client.layout.textfield.TextBase
	 */
	private TextARCode getRightJText_MstrAR() {
		if (RightJText_MstrAR == null) {
			RightJText_MstrAR = new TextARCode() {
				@Override
				public void onBlur() {
					if (isAppend() || isModify()) {
						if (!getRightJText_MstrAR().isEmpty()) {
							QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
									new String[] {"ArCode", "ArcCode", "ArcCode='"+RightJText_ARCode.getText()+"'"},
									new MessageQueueCallBack() {
								@Override
								public void onPostSuccess(MessageQueue mQueue) {
									if (mQueue.success()) {
										System.err.println("[valid AR][getRightJText_MstrAR()]:"+getRightJText_MstrAR().getText());
									}else{
										Factory.getInstance().addErrorMessage("No such AR", getRightJText_MstrAR());
										getRightJText_MstrAR().resetText();
									}
								}
							});
						}
					}
				};
			};
			RightJText_MstrAR.setWidth(180);
			RightJText_MstrAR.setHeight(18);
		}
		return RightJText_MstrAR;
	}

	private LabelBase getRightJLabel_NoContractStartDate() {
		if (RightJLabel_NoContractStartDate == null) {
			RightJLabel_NoContractStartDate = new LabelBase();
			RightJLabel_NoContractStartDate.setText("No Contract Start Date");
			//NoContractStartDate.setBounds(16, 109, 140, 20);
			RightJLabel_NoContractStartDate.setHeight(22);
		}
		return RightJLabel_NoContractStartDate;
	}

	private TextDate getRightJText_NoContractStartDate() {
		if (RightJText_NoContractStartDate == null) {
			RightJText_NoContractStartDate = new TextDate() {
				public void onReleased() {
					//setCurrentTable(42, RightJText_NoContractStartDate.getText());
				}
			};
			RightJText_NoContractStartDate.setWidth(180);
			RightJText_NoContractStartDate.setHeight(18);
		}
		return RightJText_NoContractStartDate;
	}

	private LabelBase getRightJLabel_NoContractEndDate() {
		if (RightJLabel_NoContractEndDate == null) {
			RightJLabel_NoContractEndDate = new LabelBase();
			RightJLabel_NoContractEndDate.setText("No Contract End Date");
			//NoContractStartDate.setBounds(16, 109, 140, 20);
			RightJLabel_NoContractEndDate.setHeight(18);
		}
		return RightJLabel_NoContractEndDate;
	}

	private TextDate getRightJText_NoContractEndDate() {
		if (RightJText_NoContractEndDate == null) {
			RightJText_NoContractEndDate = new TextDate() {
				@Override
				public void onReleased() {
					//setCurrentTable(43, RightJText_NoContractEndDate.getText());
				}
			};
			RightJText_NoContractEndDate.setWidth(180);
			RightJText_NoContractEndDate.setHeight(18);
		}
		return RightJText_NoContractEndDate;
	}
	
	private LabelBase getRightJLabel_ArPct() {
		if (RightJLabel_ArPct == null) {
			RightJLabel_ArPct = new LabelBase();
			RightJLabel_ArPct.setText("TPA %");
			RightJLabel_ArPct.setHeight(18);
		}
		return RightJLabel_ArPct;
	}
	
	private TextNum getRightJText_ArPct() {
		if (RightJText_ArPct == null) {
			RightJText_ArPct = new TextNum(3,1);
			RightJText_ArPct.setHeight(18);
		}
		return RightJText_ArPct;
	}


	/**
	 * This method initializes RightJLabel_ARCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_ARName() {
		if (RightJLabel_ARName == null) {
			RightJLabel_ARName = new LabelBase();
			RightJLabel_ARName.setText("AR Name");
//			RightJLabel_ARName.setBounds(314, 16, 112, 20);
			RightJLabel_ARName.setHeight(18);
		}
		return RightJLabel_ARName;
	}

	/**
	 * This method initializes RightJText_ARCode
	 *
	 * @return com.hkah.client.layout.textfield.TextName
	 */
	private TextName getRightJText_ARName() {
		if (RightJText_ARName == null) {
			RightJText_ARName = new TextName(80);
			RightJText_ARName.setWidth(180);
			RightJText_ARName.setHeight(18);
		}
		return RightJText_ARName;
	}

	/**
	 * This method initializes RightJLabel_ARCName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_ARCName() {
		if (RightJLabel_ARCName == null) {
			RightJLabel_ARCName = new LabelBase();
			RightJLabel_ARCName.setText("AR CName");
//			RightJLabel_ARCName.setBounds(16, 47, 140, 20);
			RightJLabel_ARCName.setHeight(18);
		}
		return RightJLabel_ARCName;
	}

	/**
	 * This method initializes RightJText_ARCName
	 *
	 * @return com.hkah.client.layout.textfield.TextNameChinese
	 */
	private TextNameChinese getRightJText_ARCName() {
		if (RightJText_ARCName == null) {
			RightJText_ARCName = new TextNameChinese();
			RightJText_ARCName.setWidth(180);
			RightJText_ARCName.setHeight(18);
		}
		return RightJText_ARCName;
	}

	/**
	 * This method initializes RightJLabel_GlCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_GlCode() {
		if (RightJLabel_GlCode == null) {
			RightJLabel_GlCode = new LabelBase();
			RightJLabel_GlCode.setText("GlCode");
//			RightJLabel_GlCode.setBounds(314, 47, 112, 20);
			RightJLabel_GlCode.setHeight(18);
		}
		return RightJLabel_GlCode;
	}

	/**
	 * This method initializes RightJText_GlCode
	 *
	 * @return com.hkah.client.layout.textfield.TextBase
	 */
	private TextBase getRightJText_GlCode() {
		if (RightJText_GlCode == null) {
			RightJText_GlCode = new TextBase() {
				@Override
				public void onReleased() {
					// TODO Auto-generated method stub
					//setCurrentTable(3, RightJText_GlCode.getText());
				}

				@Override
				public void onBlur() {
					if (isAppend() || isModify()) {
						if (!RightJText_GlCode.getText().isEmpty()){
							QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
									new String[] {"GLCODE", "GLCCODE", "GLCCODE='"+RightJText_GlCode.getText()+"'"},
									new MessageQueueCallBack() {
								@Override
								public void onPostSuccess(MessageQueue mQueue) {
									if (mQueue.success()) {
										//setCurrentTable(3, RightJText_GlCode.getText());
									} else {
										Factory.getInstance().addErrorMessage("Invalid GL Code!", RightJText_GlCode);
										RightJText_GlCode.resetText();
										//setCurrentTable(3, "");

									}
								}
							});
						}
					}
				}
			};
			RightJText_GlCode.setWidth(180);
			RightJText_GlCode.setHeight(18);
		}
		return RightJText_GlCode;
	}

	/**
	 * This method initializes RightJLabel_ConstractualPrice
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_ConstractualPrice() {
		if (RightJLabel_ConstractualPrice == null) {
			RightJLabel_ConstractualPrice = new LabelBase();
			RightJLabel_ConstractualPrice.setText("Constractual Price");
//			RightJLabel_ConstractualPrice.setBounds(16, 78, 140, 20);
			RightJLabel_ConstractualPrice.setHeight(18);
		}
		return RightJLabel_ConstractualPrice;
	}

	/**
	 * This method initializes RightJText_ConstractualPrice
	 *
	 * @return com.hkah.client.layout.combobox.TextBase
	 */
	private ComboSetPrice getRightJText_ConstractualPrice() {
		if (RightJText_ConstractualPrice == null) {
			RightJText_ConstractualPrice = new ComboSetPrice(/*getListTable(), 15*/);
			RightJText_ConstractualPrice.setWidth(180);
			RightJText_ConstractualPrice.setHeight(18);
		}
		return RightJText_ConstractualPrice;
	}

	/**
	 * This method initializes RightJLabel_RefundGlCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_RefundGlCode() {
		if (RightJLabel_RefundGlCode == null) {
			RightJLabel_RefundGlCode = new LabelBase();
//			RightJLabel_RefundGlCode.setBounds(314, 78, 112, 20);
			RightJLabel_RefundGlCode.setText("Refund Gl Code");
			RightJLabel_RefundGlCode.setHeight(18);
		}
		return RightJLabel_RefundGlCode;
	}

	/**
	 * This method initializes RightJText_RefundGlCode
	 *
	 * @return com.hkah.client.layout.textfield.TextBase
	 */
	private TextBase getRightJText_RefundGlCode() {
		if (RightJText_RefundGlCode == null) {
			RightJText_RefundGlCode = new TextBase();
			RightJText_RefundGlCode.setWidth(180);
			RightJText_RefundGlCode.setHeight(18);
		}
		return RightJText_RefundGlCode;
	}

	/**
	 * This method initializes RightJLabel_StartDate
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_StartDate() {
		if (RightJLabel_StartDate == null) {
			RightJLabel_StartDate = new LabelBase();
			RightJLabel_StartDate.setText("Start Date");
			RightJLabel_StartDate.setBounds(16, 109, 140, 20);
			RightJLabel_StartDate.setHeight(22);
		}
		return RightJLabel_StartDate;
	}

	/**
	 * This method initializes RightJText_StartDate
	 *
	 * @return com.hkah.client.layout.textfield.TextDate
	 */
	private TextDate getRightJText_StartDate() {
		if (RightJText_StartDate == null) {
			RightJText_StartDate = new TextDate() {
				public void onReleased() {
					//setCurrentTable(36, RightJText_StartDate.getText());
				}
			};
//			RightJText_StartDate.setLocation(160, 109);
			RightJText_StartDate.setWidth(180);
			RightJText_StartDate.setHeight(18);
		}
		return RightJText_StartDate;
	}

	/**
	 * This method initializes RightJLabel_TerminationDate
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_TerminationDate() {
		if (RightJLabel_TerminationDate == null) {
			RightJLabel_TerminationDate = new LabelBase();
			RightJLabel_TerminationDate.setText("Termination Date");
//			RightJLabel_TerminationDate.setBounds(314, 108, 112, 20);
			RightJLabel_TerminationDate.setHeight(22);
		}
		return RightJLabel_TerminationDate;
	}

	/**
	 * This method initializes RightJText_TerminationDate
	 *
	 * @return com.hkah.client.layout.textfield.TextDate
	 */
	private TextDate getRightJText_TerminationDate() {
		if (RightJText_TerminationDate == null) {
			RightJText_TerminationDate = new TextDate();
//			RightJText_TerminationDate.setLocation(435, 108);
			RightJText_TerminationDate.setSize(180, 18);
		}
		return RightJText_TerminationDate;
	}

	/**
	 * This method initializes RightJLabel_ClaimContact_Person
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_ClaimContact_Person() {
		if (RightJLabel_ClaimContact_Person == null) {
			RightJLabel_ClaimContact_Person = new LabelBase();
			RightJLabel_ClaimContact_Person.setText("Claim Contact Person");
			RightJLabel_ClaimContact_Person.setBounds(5, 0, 140, 20);
		}
		return RightJLabel_ClaimContact_Person;
	}

	/**
	 * This method initializes RightJText_ClaimContact_Person
	 *
	 * @return com.hkah.client.layout.textfield.TextBase
	 */
	private TextBase getRightJText_ClaimContact_Person() {
		if (RightJText_ClaimContact_Person == null) {
			RightJText_ClaimContact_Person = new TextBase();
			RightJText_ClaimContact_Person.setBounds(140, 0, 270, 20);
		}
		return RightJText_ClaimContact_Person;
	}

	/**
	 * This method initializes RightJLabel_ClaimContact_Title
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_ClaimContact_Title() {
		if (RightJLabel_ClaimContact_Title == null) {
			RightJLabel_ClaimContact_Title = new LabelBase();
			RightJLabel_ClaimContact_Title.setText("Claim Contact Title");
			RightJLabel_ClaimContact_Title.setBounds(5, 22, 140, 20);
		}
		return RightJLabel_ClaimContact_Title;
	}

	/**
	 * This method initializes RightJText_ClaimContact_Title
	 *
	 * @return com.hkah.client.layout.textfield.TextBase
	 */
	private TextBase getRightJText_ClaimContact_Title() {
		if (RightJText_ClaimContact_Title == null) {
			RightJText_ClaimContact_Title = new TextBase();
			RightJText_ClaimContact_Title.setBounds(140, 22, 270, 20);
		}
		return RightJText_ClaimContact_Title;
	}

	/**
	 * This method initializes RightJLabel_ClaimContact_PhoneNumber
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_ClaimContact_PhoneNumber() {
		if (RightJLabel_ClaimContact_PhoneNumber == null) {
			RightJLabel_ClaimContact_PhoneNumber = new LabelBase();
			RightJLabel_ClaimContact_PhoneNumber.setBounds(5, 44, 140, 20);
			RightJLabel_ClaimContact_PhoneNumber.setText("Phone Number");
		}
		return RightJLabel_ClaimContact_PhoneNumber;
	}

	/**
	 * This method initializes RightJText_ClaimContact_PhoneNumber
	 *
	 * @return com.hkah.client.layout.textfield.TextPhone
	 */
	private TextPhone getRightJText_ClaimContact_PhoneNumber() {
		if (RightJText_ClaimContact_PhoneNumber == null) {
			RightJText_ClaimContact_PhoneNumber = new TextPhone();
			RightJText_ClaimContact_PhoneNumber.setBounds(140, 44, 90, 20);
		}
		return RightJText_ClaimContact_PhoneNumber;
	}

	/**
	 * This method initializes RightJLabel_ClaimContact_FaxNumber
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_ClaimContact_FaxNumber() {
		if (RightJLabel_ClaimContact_FaxNumber == null) {
			RightJLabel_ClaimContact_FaxNumber = new LabelBase();
			RightJLabel_ClaimContact_FaxNumber.setText("Fax Number");
			RightJLabel_ClaimContact_FaxNumber.setBounds(240, 44, 80, 20);
		}
		return RightJLabel_ClaimContact_FaxNumber;
	}

	/**
	 * This method initializes RightJText_ClaimContact_FaxNumber
	 *
	 * @return com.hkah.client.layout.textfield.TextPhone
	 */
	private TextPhone getRightJText_ClaimContact_FaxNumber() {
		if (RightJText_ClaimContact_FaxNumber == null) {
			RightJText_ClaimContact_FaxNumber = new TextPhone();
			RightJText_ClaimContact_FaxNumber.setBounds(320, 44, 90, 20);
		}
		return RightJText_ClaimContact_FaxNumber;
	}

	/**
	 * This method initializes RightJLabel_ClaimContact_EmailAddress
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_ClaimContact_EmailAddress() {
		if (RightJLabel_ClaimContact_EmailAddress == null) {
			RightJLabel_ClaimContact_EmailAddress = new LabelBase();
			RightJLabel_ClaimContact_EmailAddress.setText("Email Address");
			RightJLabel_ClaimContact_EmailAddress.setBounds(5, 66, 112, 20);
		}
		return RightJLabel_ClaimContact_EmailAddress;
	}

	/**
	 * This method initializes RightJText_ClaimContact_EmailAddress
	 *
	 * @return com.hkah.client.layout.textfield.TextBase
	 */
	private TextBase getRightJText_ClaimContact_EmailAddress() {
		if (RightJText_ClaimContact_EmailAddress == null) {
			RightJText_ClaimContact_EmailAddress = new TextBase();
			RightJText_ClaimContact_EmailAddress.setBounds(140, 66, 270, 20);
		}
		return RightJText_ClaimContact_EmailAddress;
	}

	/**
	 * This method initializes RightJLabel_ClaimContact_Address
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_ClaimContact_Address() {
		if (RightJLabel_ClaimContact_Address == null) {
			RightJLabel_ClaimContact_Address = new LabelBase();
			RightJLabel_ClaimContact_Address.setText("Address");
			RightJLabel_ClaimContact_Address.setBounds(430, 0, 60, 20);
		}
		return RightJLabel_ClaimContact_Address;
	}

	/**
	 * This method initializes RightJText_ClaimContact_Address1
	 *
	 * @return com.hkah.client.layout.textfield.TextBase
	 */
	private TextBase getRightJText_ClaimContact_Address1() {
		if (RightJText_ClaimContact_Address1 == null) {
			RightJText_ClaimContact_Address1 = new TextBase();
			RightJText_ClaimContact_Address1.setBounds(490, 0, 300, 18);
		}
		return RightJText_ClaimContact_Address1;
	}

	/**
	 * This method initializes RightJText_ClaimContact_Address2
	 *
	 * @return com.hkah.client.layout.textfield.TextBase
	 */
	private TextBase getRightJText_ClaimContact_Address2() {
		if (RightJText_ClaimContact_Address2 == null) {
			RightJText_ClaimContact_Address2 = new TextBase();
			RightJText_ClaimContact_Address2.setBounds(490, 22, 300, 20);
		}
		return RightJText_ClaimContact_Address2;
	}

	/**
	 * This method initializes RightJText_ClaimContact_Address3
	 *
	 * @return com.hkah.client.layout.textfield.TextBase
	 */
	private TextBase getRightJText_ClaimContact_Address3() {
		if (RightJText_ClaimContact_Address3 == null) {
			RightJText_ClaimContact_Address3 = new TextBase();
			RightJText_ClaimContact_Address3.setBounds(490, 44, 300, 18);
		}
		return RightJText_ClaimContact_Address3;
	}

	/**
	 * This method initializes RightJText_ClaimContact_Address4
	 *
	 * @return com.hkah.client.layout.textfield.TextBase
	 */
	private TextBase getRightJText_ClaimContact_Address4() {
		if (RightJText_ClaimContact_Address4 == null) {
			RightJText_ClaimContact_Address4 = new TextBase();
			RightJText_ClaimContact_Address4.setBounds(490, 66, 300, 18);
		}
		return RightJText_ClaimContact_Address4;
	}

	/**
	 * This method initializes RightJLabel_AdmissionContact_Person
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_AdmissionContact_Person() {
		if (RightJLabel_AdmissionContact_Person == null) {
			RightJLabel_AdmissionContact_Person = new LabelBase();
			RightJLabel_AdmissionContact_Person.setBounds(17, 0, 130, 20);
			RightJLabel_AdmissionContact_Person.setText("Adm. Contact Person");
		}
		return RightJLabel_AdmissionContact_Person;
	}


	/**
	 * This method initializes RightJText_AdmissionContact_Person
	 *
	 * @return com.hkah.client.layout.textfield.TextBase
	 */
	private TextBase getRightJText_AdmissionContact_Person() {
		if (RightJText_AdmissionContact_Person == null) {
			RightJText_AdmissionContact_Person = new TextBase();
			RightJText_AdmissionContact_Person.setBounds(140, 0, 170, 20);
		}
		return RightJText_AdmissionContact_Person;
	}

	/**
	 * This method initializes RightJLabel_AdmissionContact_Title
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_AdmissionContact_Title() {
		if (RightJLabel_AdmissionContact_Title == null) {
			RightJLabel_AdmissionContact_Title = new LabelBase();
			RightJLabel_AdmissionContact_Title.setText("Title");
			RightJLabel_AdmissionContact_Title.setBounds(17, 22, 130, 20);
		}
		return RightJLabel_AdmissionContact_Title;
	}

	/**
	 * This method initializes RightJText_AdmissionContact_Title
	 *
	 * @return com.hkah.client.layout.textfield.TextBase
	 */
	private TextBase getRightJText_AdmissionContact_Title() {
		if (RightJText_AdmissionContact_Title == null) {
			RightJText_AdmissionContact_Title = new TextBase();
			RightJText_AdmissionContact_Title.setBounds(140, 22, 170, 20);
		}
		return RightJText_AdmissionContact_Title;
	}

	/**
	 * This method initializes RightJLabel_AdmissionContact_PhoneNumber
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_AdmissionContact_PhoneNumber() {
		if (RightJLabel_AdmissionContact_PhoneNumber == null) {
			RightJLabel_AdmissionContact_PhoneNumber = new LabelBase();
			RightJLabel_AdmissionContact_PhoneNumber.setText("Phone Number");
			RightJLabel_AdmissionContact_PhoneNumber.setBounds(17, 44, 140, 20);
		}
		return RightJLabel_AdmissionContact_PhoneNumber;
	}

	/**
	 * This method initializes RightJText_AdmissionContact_PhoneNumber
	 *
	 * @return com.hkah.client.layout.textfield.TextPhone
	 */
	private TextPhone getRightJText_AdmissionContact_PhoneNumber() {
		if (RightJText_AdmissionContact_PhoneNumber == null) {
			RightJText_AdmissionContact_PhoneNumber = new TextPhone();
			RightJText_AdmissionContact_PhoneNumber.setBounds(140, 44, 170, 20);
		}
		return RightJText_AdmissionContact_PhoneNumber;
	}

	/**
	 * This method initializes RightJLabel_AdmissionContact_FaxNumber
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_AdmissionContact_FaxNumber() {
		if (RightJLabel_AdmissionContact_FaxNumber == null) {
			RightJLabel_AdmissionContact_FaxNumber = new LabelBase();
			RightJLabel_AdmissionContact_FaxNumber.setText("Fax Number");
			RightJLabel_AdmissionContact_FaxNumber.setBounds(17, 66, 140, 20);
		}
		return RightJLabel_AdmissionContact_FaxNumber;
	}

	/**
	 * This method initializes RightJText_AdmissionContact_FaxNumber
	 *
	 * @return com.hkah.client.layout.textfield.TextPhone
	 */
	private TextPhone getRightJText_AdmissionContact_FaxNumber() {
		if (RightJText_AdmissionContact_FaxNumber == null) {
			RightJText_AdmissionContact_FaxNumber = new TextPhone();
			RightJText_AdmissionContact_FaxNumber.setBounds(140, 66, 170, 20);
		}
		return RightJText_AdmissionContact_FaxNumber;
	}

	/**
	 * This method initializes RightJLabel_AdmissionContact_EmailAddress
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_AdmissionContact_EmailAddress() {
		if (RightJLabel_AdmissionContact_EmailAddress == null) {
			RightJLabel_AdmissionContact_EmailAddress = new LabelBase();
			RightJLabel_AdmissionContact_EmailAddress.setBounds(350, 0, 130, 20);
			RightJLabel_AdmissionContact_EmailAddress.setText("Email Address");
		}
		return RightJLabel_AdmissionContact_EmailAddress;
	}

	/**
	 * This method initializes RightJText_AdmissionContact_EmailAddress
	 *
	 * @return com.hkah.client.layout.textfield.TextBase
	 */
	private TextBase getRightJText_AdmissionContact_EmailAddress() {
		if (RightJText_AdmissionContact_EmailAddress == null) {
			RightJText_AdmissionContact_EmailAddress = new TextBase();
			RightJText_AdmissionContact_EmailAddress.setBounds(460, 0, 300, 20);
		}
		return RightJText_AdmissionContact_EmailAddress;
	}

	private LabelBase getRightJLabel_AdmissionContract_AdmissionNotice() {
		if (RightJLabel_AdmissionContract_AdmissionNotice == null) {
			RightJLabel_AdmissionContract_AdmissionNotice = new LabelBase();
			RightJLabel_AdmissionContract_AdmissionNotice.setText("Auto-gen Admission Notice");
			RightJLabel_AdmissionContract_AdmissionNotice.setBounds(17, 88, 140, 20);
		}
		return RightJLabel_AdmissionContract_AdmissionNotice;
	}
	/**
	 * This method initializes RightJRadioButton_AdmissionContract_AdmissionNotice
	 *
	 * @return com.hkah.client.layout.button.RadioButtonBase
	 */
	private CheckBoxBase getRightCheckBox_AdmissionContract_AdmissionNotice() {
		if (RightCheckBox_AdmissionContract_AdmissionNotice == null) {
			RightCheckBox_AdmissionContract_AdmissionNotice = new CheckBoxBase();
			RightCheckBox_AdmissionContract_AdmissionNotice.setBounds(140, 88, 170, 20);
		}
		return RightCheckBox_AdmissionContract_AdmissionNotice;
	}

	/**
	 * @return the rightJLabel_AdmissionContact_Address
	 */
	private LabelBase getRightJLabel_AdmissionContact_Address() {
		if (RightJLabel_AdmissionContact_Address == null) {
			RightJLabel_AdmissionContact_Address = new LabelBase();
			RightJLabel_AdmissionContact_Address.setText("Address");
			RightJLabel_AdmissionContact_Address.setBounds(350, 22, 130, 20);
		}
		return RightJLabel_AdmissionContact_Address;
	}

	/**
	 * @return the rightJText_AdmissionContact_Address1
	 */
	private TextBase getRightJText_AdmissionContact_Address1() {
		if (RightJText_AdmissionContact_Address1 == null) {
			RightJText_AdmissionContact_Address1 = new TextBase();
			RightJText_AdmissionContact_Address1.setBounds(460, 22, 300, 20);
		}
		return RightJText_AdmissionContact_Address1;
	}

	/**
	 * @return the rightJText_AdmissionContact_Address2
	 */
	private TextBase getRightJText_AdmissionContact_Address2() {
		if (RightJText_AdmissionContact_Address2 == null) {
			RightJText_AdmissionContact_Address2 = new TextBase();
			RightJText_AdmissionContact_Address2.setBounds(460, 44, 300, 20);
		}
		return RightJText_AdmissionContact_Address2;
	}

	/**
	 * @return the rightJText_AdmissionContact_Address3
	 */
	private TextBase getRightJText_AdmissionContact_Address3() {
		if (RightJText_AdmissionContact_Address3 == null) {
			RightJText_AdmissionContact_Address3 = new TextBase();
			RightJText_AdmissionContact_Address3.setBounds(460, 66, 300, 20);
		}
		return RightJText_AdmissionContact_Address3;
	}

	/**
	 * @return the rightJText_AdmissionContact_Address4
	 */
	private TextBase getRightJText_AdmissionContact_Address4() {
		if (RightJText_AdmissionContact_Address4 == null) {
			RightJText_AdmissionContact_Address4 = new TextBase();
			RightJText_AdmissionContact_Address4.setBounds(460, 88, 300, 20);
		}
		return RightJText_AdmissionContact_Address4;
	}

	/**
	 * This method initializes RightJLabel_FurtherGuarantee_ContactPerson
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_FurtherGuarantee_ContactPerson() {
		if (RightJLabel_FurtherGuarantee_ContactPerson == null) {
			RightJLabel_FurtherGuarantee_ContactPerson = new LabelBase();
			RightJLabel_FurtherGuarantee_ContactPerson.setBounds(17, 0, 140, 18);
			RightJLabel_FurtherGuarantee_ContactPerson.setText("Contact Person");
		}
		return RightJLabel_FurtherGuarantee_ContactPerson;
	}

	/**
	 * This method initializes RightJText_FurtherGuarantee_ContactPerson
	 *
	 * @return com.hkah.client.layout.textfield.TextBase
	 */
	private TextBase getRightJText_FurtherGuarantee_ContactPerson() {
		if (RightJText_FurtherGuarantee_ContactPerson == null) {
			RightJText_FurtherGuarantee_ContactPerson = new TextBase();
			RightJText_FurtherGuarantee_ContactPerson.setBounds(140, 0, 170, 18);
		}
		return RightJText_FurtherGuarantee_ContactPerson;
	}

	/**
	 * This method initializes RightJLabel_FurtherGuarantee_ContactTitle
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_FurtherGuarantee_ContactTitle() {
		if (RightJLabel_FurtherGuarantee_ContactTitle == null) {
			RightJLabel_FurtherGuarantee_ContactTitle = new LabelBase();
			RightJLabel_FurtherGuarantee_ContactTitle.setText("Title");
			RightJLabel_FurtherGuarantee_ContactTitle.setBounds(17, 21, 140, 18);
		}
		return RightJLabel_FurtherGuarantee_ContactTitle;
	}

	/**
	 * This method initializes RightJText_FurtherGuarantee_ContactTitle
	 *
	 * @return com.hkah.client.layout.textfield.TextBase
	 */
	private TextBase getRightJText_FurtherGuarantee_ContactTitle() {
		if (RightJText_FurtherGuarantee_ContactTitle == null) {
			RightJText_FurtherGuarantee_ContactTitle = new TextBase();
			RightJText_FurtherGuarantee_ContactTitle.setBounds(140, 21, 170, 18);
		}
		return RightJText_FurtherGuarantee_ContactTitle;
	}

	/**
	 * This method initializes RightJLabel_FurtherGuarantee_PhoneNumber
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_FurtherGuarantee_PhoneNumber() {
		if (RightJLabel_FurtherGuarantee_PhoneNumber == null) {
			RightJLabel_FurtherGuarantee_PhoneNumber = new LabelBase();
			RightJLabel_FurtherGuarantee_PhoneNumber.setText("Phone Number");
			RightJLabel_FurtherGuarantee_PhoneNumber.setBounds(17, 42, 140, 18);
		}
		return RightJLabel_FurtherGuarantee_PhoneNumber;
	}

	/**
	 * This method initializes RightJText_FurtherGuarantee_PhoneNumber
	 *
	 * @return com.hkah.client.layout.textfield.TextPhone
	 */
	private TextPhone getRightJText_FurtherGuarantee_PhoneNumber() {
		if (RightJText_FurtherGuarantee_PhoneNumber == null) {
			RightJText_FurtherGuarantee_PhoneNumber = new TextPhone();
			RightJText_FurtherGuarantee_PhoneNumber.setBounds(140, 42, 170, 18);
		}
		return RightJText_FurtherGuarantee_PhoneNumber;
	}

	/**
	 * This method initializes RightJLabel_FurtherGuarantee_FaxNumber
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_FurtherGuarantee_FaxNumber() {
		if (RightJLabel_FurtherGuarantee_FaxNumber == null) {
			RightJLabel_FurtherGuarantee_FaxNumber = new LabelBase();
			RightJLabel_FurtherGuarantee_FaxNumber.setText("Fax Number");
			RightJLabel_FurtherGuarantee_FaxNumber.setBounds(17, 63, 140, 18);
		}
		return RightJLabel_FurtherGuarantee_FaxNumber;
	}

	/**
	 * This method initializes RightJText_FurtherGuarantee_FaxNumber
	 *
	 * @return com.hkah.client.layout.textfield.TextPhone
	 */
	private TextPhone getRightJText_FurtherGuarantee_FaxNumber() {
		if (RightJText_FurtherGuarantee_FaxNumber == null) {
			RightJText_FurtherGuarantee_FaxNumber = new TextPhone();
			RightJText_FurtherGuarantee_FaxNumber.setBounds(140, 63, 170 , 18);
		}
		return RightJText_FurtherGuarantee_FaxNumber;
	}

	/**
	 * This method initializes RightJLabel_FurtherGuarantee_EmailAddress
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_FurtherGuarantee_EmailAddress() {
		if (RightJLabel_FurtherGuarantee_EmailAddress == null) {
			RightJLabel_FurtherGuarantee_EmailAddress = new LabelBase();
			RightJLabel_FurtherGuarantee_EmailAddress.setBounds(350, 0, 134, 18);
			RightJLabel_FurtherGuarantee_EmailAddress.setText("Email Address");
		}
		return RightJLabel_FurtherGuarantee_EmailAddress;
	}

	/**
	 * This method initializes RightJText_FurtherGuarantee_EmailAddress
	 *
	 * @return com.hkah.client.layout.textfield.TextBase
	 */
	private TextBase getRightJText_FurtherGuarantee_EmailAddress() {
		if (RightJText_FurtherGuarantee_EmailAddress == null) {
			RightJText_FurtherGuarantee_EmailAddress = new TextBase();
			RightJText_FurtherGuarantee_EmailAddress.setBounds(460, 0, 170, 18);
		}
		return RightJText_FurtherGuarantee_EmailAddress;
	}

	/**
	 * This method initializes RightJLabel_FurtherGuarantee_LimitAmt
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_FurtherGuarantee_LimitAmt() {
		if (RightJLabel_FurtherGuarantee_LimitAmt == null) {
			RightJLabel_FurtherGuarantee_LimitAmt = new LabelBase();
			RightJLabel_FurtherGuarantee_LimitAmt.setText("Inr. Limit Amt.");
			RightJLabel_FurtherGuarantee_LimitAmt.setBounds(350, 21, 134, 18);
		}
		return RightJLabel_FurtherGuarantee_LimitAmt;
	}

	/**
	 * This method initializes RightJText_FurtherGuarantee_LimitAmt
	 *
	 * @return com.hkah.client.layout.textfield.TextAmount
	 */
	private TextAmount getRightJText_FurtherGuarantee_LimitAmt() {
		if (RightJText_FurtherGuarantee_LimitAmt == null) {
			RightJText_FurtherGuarantee_LimitAmt = new TextAmount() {
				@Override
				public void onReleased() {
					//setCurrentTable(29, "0");
					//setCurrentTable(29, RightJText_FurtherGuarantee_LimitAmt.getText());
				}
			};
			RightJText_FurtherGuarantee_LimitAmt.setBounds(460, 21, 170, 18);
		}
		return RightJText_FurtherGuarantee_LimitAmt;
	}

	/**
	 * This method initializes RightJLabel_FurtherGuarantee_CoPayRefNo
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_FurtherGuarantee_CoPayRefNo() {
		if (RightJLabel_FurtherGuarantee_CoPayRefNo == null) {
			RightJLabel_FurtherGuarantee_CoPayRefNo = new LabelBase();
			RightJLabel_FurtherGuarantee_CoPayRefNo.setText("Co-Pay.(Ref)");
			RightJLabel_FurtherGuarantee_CoPayRefNo.setBounds(350, 42, 134, 18);
		}
		return RightJLabel_FurtherGuarantee_CoPayRefNo;
	}

	/**
	 * This method initializes RightJCombo_FurtherGuarantee_CoPayRefType
	 *
	 * @return com.hkah.client.layout.combobox.ComboCoPayRefType
	 */
	private ComboCoPayRefType getRightJCombo_FurtherGuarantee_CoPayRefType() {
		if (RightJCombo_FurtherGuarantee_CoPayRefType == null) {
			RightJCombo_FurtherGuarantee_CoPayRefType = new ComboCoPayRefType();
			RightJCombo_FurtherGuarantee_CoPayRefType.setBounds(460, 42, 60, 18);
		}
		return RightJCombo_FurtherGuarantee_CoPayRefType;
	}

	/**
	 * This method initializes RightJText_ClaimContact_CoPayRefAmount
	 *
	 * @return com.hkah.client.layout.textfield.TextAmount
	 */
	private TextAmount getRightJText_ClaimContact_CoPayRefAmount() {
		if (RightJText_ClaimContact_CoPayRefAmount == null) {
			RightJText_ClaimContact_CoPayRefAmount = new TextAmount() {
				@Override
				public void onReleased() {
					//setCurrentTable(31, RightJText_ClaimContact_CoPayRefAmount.getText());
				}

				public void onClick() {
					if (RightJText_ClaimContact_CoPayRefAmount.getText() == null || RightJText_ClaimContact_CoPayRefAmount.getText().trim().length()==0) {
						//setCurrentTable(31, "0");
					}
				}
			};
			RightJText_ClaimContact_CoPayRefAmount.setBounds(522, 42, 108, 18);
		}
		return RightJText_ClaimContact_CoPayRefAmount;
	}

	/**
	 * This method initializes RightJLabel_FurtherGuarantee_CvtEndDate
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_FurtherGuarantee_CvtEndDate() {
		if (RightJLabel_FurtherGuarantee_CvtEndDate == null) {
			RightJLabel_FurtherGuarantee_CvtEndDate = new LabelBase();
			RightJLabel_FurtherGuarantee_CvtEndDate.setText("Cvt End Date");
			RightJLabel_FurtherGuarantee_CvtEndDate.setBounds(350, 63, 134, 18);
		}
		return RightJLabel_FurtherGuarantee_CvtEndDate;
	}

	/**
	 * This method initializes RightJText_FurtherGuarantee_CvtEndDate
	 *
	 * @return com.hkah.client.layout.textfield.TextDate
	 */
	private TextDate getRightJText_FurtherGuarantee_CvtEndDate() {
		if (RightJText_FurtherGuarantee_CvtEndDate == null) {
			RightJText_FurtherGuarantee_CvtEndDate = new TextDate() {
				public void onReleased() {
					//setCurrentTable(30, RightJText_FurtherGuarantee_CvtEndDate.getText());
				}
			};
			RightJText_FurtherGuarantee_CvtEndDate.setBounds(460, 63, 170, 18);
		}
		return RightJText_FurtherGuarantee_CvtEndDate;
	}

	/**
	 * This method initializes RightJLabel_FurtherGuarantee_CoverredItem
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_FurtherGuarantee_CoverredItem() {
		if (RightJLabel_FurtherGuarantee_CoverredItem == null) {
			RightJLabel_FurtherGuarantee_CoverredItem = new LabelBase();
			RightJLabel_FurtherGuarantee_CoverredItem.setBounds(17, 84, 93, 18);
			RightJLabel_FurtherGuarantee_CoverredItem.setText("Covered Item");
		}
		return RightJLabel_FurtherGuarantee_CoverredItem;
	}

	private LabelBase getRightJLabel_FurtherGuarantee_Doctor() {
		if (RightJLabel_FurtherGuarantee_Doctor == null) {
			RightJLabel_FurtherGuarantee_Doctor = new LabelBase();
			RightJLabel_FurtherGuarantee_Doctor.setBounds(166, 84, 50, 18);
			RightJLabel_FurtherGuarantee_Doctor.setText("Doctor");
		}
		return RightJLabel_FurtherGuarantee_Doctor;
	}

	/**
	 * This method initializes RightJRadioButton_FurtherGuarantee_CoveredItemDoctor
	 *
	 * @return com.hkah.client.layout.button.RadioButtonBase
	 */
	private CheckBoxBase getRightCheckBox_FurtherGuarantee_Doctor() {
		if (RightCheckBox_FurtherGuarantee_Doctor == null) {
			RightCheckBox_FurtherGuarantee_Doctor = new CheckBoxBase();
			RightCheckBox_FurtherGuarantee_Doctor.setBounds(140, 84, 20, 20);
		}
		return RightCheckBox_FurtherGuarantee_Doctor;
	}

	private LabelBase getRightJLabel_FurtherGuarantee_Hospital() {
		if (RightJLabel_FurtherGuarantee_Hospital == null) {
			RightJLabel_FurtherGuarantee_Hospital = new LabelBase();
			RightJLabel_FurtherGuarantee_Hospital.setBounds(251, 84, 50, 18);
			RightJLabel_FurtherGuarantee_Hospital.setText("Hospital");
		}
		return RightJLabel_FurtherGuarantee_Hospital;
	}

	/**
	 * This method initializes RightJRadioButton_FurtherGuarantee_CoveredItemHospital
	 *
	 * @return com.hkah.client.layout.button.RadioButtonBase
	 */
	private CheckBoxBase getRightCheckBox_FurtherGuarantee_Hospital() {
		if (RightCheckBox_FurtherGuarantee_Hospital == null) {
			RightCheckBox_FurtherGuarantee_Hospital = new CheckBoxBase();
			RightCheckBox_FurtherGuarantee_Hospital.setBounds(226, 84, 20, 20);
		}
		return RightCheckBox_FurtherGuarantee_Hospital;
	}

	private LabelBase getRightJLabel_FurtherGuarantee_Special() {
		if (RightJLabel_FurtherGuarantee_Special == null) {
			RightJLabel_FurtherGuarantee_Special = new LabelBase();
			RightJLabel_FurtherGuarantee_Special.setBounds(339, 86, 50, 18);
			RightJLabel_FurtherGuarantee_Special.setText("Special");
		}
		return RightJLabel_FurtherGuarantee_Special;
	}

	/**
	 * This method initializes RightJRadioButton_FurtherGuarantee_CoveredItemSpecial
	 *
	 * @return com.hkah.client.layout.button.RadioButtonBase
	 */

	private CheckBoxBase getRightCheckBox_FurtherGuarantee_Special() {
		if (RightCheckBox_FurtherGuarantee_Special == null) {
			RightCheckBox_FurtherGuarantee_Special = new CheckBoxBase();
			RightCheckBox_FurtherGuarantee_Special.setBounds(312, 84, 20, 20);
		}
		return RightCheckBox_FurtherGuarantee_Special;
	}

	private LabelBase getRightJLabel_FurtherGuarantee_ConveredItemOther() {
		if (RightJLabel_FurtherGuarantee_ConveredItemOther == null) {
			RightJLabel_FurtherGuarantee_ConveredItemOther = new LabelBase();
			RightJLabel_FurtherGuarantee_ConveredItemOther.setBounds(424, 86, 50, 18);
			RightJLabel_FurtherGuarantee_ConveredItemOther.setText("Other");
		}
		return RightJLabel_FurtherGuarantee_ConveredItemOther;
	}

	/**
	 * This method initializes RightJRadioButton_FurtherGuarantee_CoveredItemOther
	 *
	 * @return com.hkah.client.layout.button.RadioButtonBase
	 */
	private CheckBoxBase getRightCheckBox_FurtherGuarantee_Other() {
		if (RightCheckBox_FurtherGuarantee_Other == null) {
			RightCheckBox_FurtherGuarantee_Other = new CheckBoxBase();
			RightCheckBox_FurtherGuarantee_Other.setBounds(396, 84, 20, 20);
		}
		return RightCheckBox_FurtherGuarantee_Other;
	}

	public ButtonBase getLJButton_ConHistory() {
		if (LJButton_ConHistory == null) {
			LJButton_ConHistory = new ButtonBase() {
				@Override
				public void onClick() {
						getConHistory().showDialog(getRightJText_ARCode().getText());
				}
			};
			LJButton_ConHistory.setText("Contractual History");
//			LJButton_ConHistory.setBounds(385, 465, 165, 25);
			LJButton_ConHistory.setHeight(20);
		}
		return LJButton_ConHistory;
	}

	private DlgConHistory getConHistory() {
		if (dlgConHistory == null) {
			dlgConHistory = new DlgConHistory(Factory.getInstance().getMainFrame());
		}
		return dlgConHistory;
	}

	private LabelBase getRightJLabel_RegisteredOffice_Person() {
		if (RightJLabel_RegisteredOffice_Person == null) {
			RightJLabel_RegisteredOffice_Person = new LabelBase();
			RightJLabel_RegisteredOffice_Person.setBounds(17, 0, 130, 20);
			RightJLabel_RegisteredOffice_Person.setText("Contact Person");
		}
		return RightJLabel_RegisteredOffice_Person;
	}

	private TextBase getRightJText_RegisteredOffice_Person() {
		if (RightJText_RegisteredOffice_Person == null) {
			RightJText_RegisteredOffice_Person = new TextBase();
			RightJText_RegisteredOffice_Person.setBounds(140, 0, 170, 20);
		}
		return RightJText_RegisteredOffice_Person;
	}

	private LabelBase getRightJLabel_RegisteredOffice_Title() {
		if (RightJLabel_RegisteredOffice_Title == null) {
			RightJLabel_RegisteredOffice_Title = new LabelBase();
			RightJLabel_RegisteredOffice_Title.setText("Title");
			RightJLabel_RegisteredOffice_Title.setBounds(17, 22, 130, 20);
		}
		return RightJLabel_RegisteredOffice_Title;
	}

	private TextBase getRightJText_RegisteredOffice_Title() {
		if (RightJText_RegisteredOffice_Title == null) {
			RightJText_RegisteredOffice_Title = new TextBase();
			RightJText_RegisteredOffice_Title.setBounds(140, 22, 170, 20);
		}
		return RightJText_RegisteredOffice_Title;
	}

	private LabelBase getRightJLabel_RegisteredOffice_PhoneNumber() {
		if (RightJLabel_RegisteredOffice_PhoneNumber == null) {
			RightJLabel_RegisteredOffice_PhoneNumber = new LabelBase();
			RightJLabel_RegisteredOffice_PhoneNumber.setText("Phone Number");
			RightJLabel_RegisteredOffice_PhoneNumber.setBounds(17, 44, 140, 20);
		}
		return RightJLabel_RegisteredOffice_PhoneNumber;
	}

	private TextPhone getRightJText_RegisteredOffice_PhoneNumber() {
		if (RightJText_RegisteredOffice_PhoneNumber == null) {
			RightJText_RegisteredOffice_PhoneNumber = new TextPhone();
			RightJText_RegisteredOffice_PhoneNumber.setBounds(140, 44, 170, 20);
		}
		return RightJText_RegisteredOffice_PhoneNumber;
	}

	private LabelBase getRightJLabel_RegisteredOffice_FaxNumber() {
		if (RightJLabel_RegisteredOffice_FaxNumber == null) {
			RightJLabel_RegisteredOffice_FaxNumber = new LabelBase();
			RightJLabel_RegisteredOffice_FaxNumber.setText("Fax Number");
			RightJLabel_RegisteredOffice_FaxNumber.setBounds(17, 66, 140, 20);
		}
		return RightJLabel_RegisteredOffice_FaxNumber;
	}

	private TextPhone getRightJText_RegisteredOffice_FaxNumber() {
		if (RightJText_RegisteredOffice_FaxNumber == null) {
			RightJText_RegisteredOffice_FaxNumber = new TextPhone();
			RightJText_RegisteredOffice_FaxNumber.setBounds(140, 66, 170, 20);
		}
		return RightJText_RegisteredOffice_FaxNumber;
	}

	private LabelBase getRightJLabel_RegisteredOffice_EmailAddress() {
		if (RightJLabel_RegisteredOffice_EmailAddress == null) {
			RightJLabel_RegisteredOffice_EmailAddress = new LabelBase();
			RightJLabel_RegisteredOffice_EmailAddress.setBounds(350, 0, 130, 20);
			RightJLabel_RegisteredOffice_EmailAddress.setText("Email Address");
		}
		return RightJLabel_RegisteredOffice_EmailAddress;
	}

	private TextBase getRightJText_RegisteredOffice_EmailAddress() {
		if (RightJText_RegisteredOffice_EmailAddress == null) {
			RightJText_RegisteredOffice_EmailAddress = new TextBase();
			RightJText_RegisteredOffice_EmailAddress.setBounds(460, 0, 300, 20);
		}
		return RightJText_RegisteredOffice_EmailAddress;
	}

	/**
	 * @return the rightJLabel_AdmissionContact_Address
	 */
	private LabelBase getRightJLabel_RegisteredOffice_Address() {
		if (RightJLabel_RegisteredOffice_Address == null) {
			RightJLabel_RegisteredOffice_Address = new LabelBase();
			RightJLabel_RegisteredOffice_Address.setText("Address");
			RightJLabel_RegisteredOffice_Address.setBounds(350, 22, 130, 20);
		}
		return RightJLabel_RegisteredOffice_Address;
	}

	/**
	 * @return the rightJText_AdmissionContact_Address1
	 */
	private TextBase getRightJText_RegisteredOffice_Address1() {
		if (RightJText_RegisteredOffice_Address1 == null) {
			RightJText_RegisteredOffice_Address1 = new TextBase();
			RightJText_RegisteredOffice_Address1.setBounds(460, 22, 300, 20);
		}
		return RightJText_RegisteredOffice_Address1;
	}

	/**
	 * @return the rightJText_AdmissionContact_Address2
	 */
	private TextBase getRightJText_RegisteredOffice_Address2() {
		if (RightJText_RegisteredOffice_Address2 == null) {
			RightJText_RegisteredOffice_Address2 = new TextBase();
			RightJText_RegisteredOffice_Address2.setBounds(460, 44, 300, 20);
		}
		return RightJText_RegisteredOffice_Address2;
	}

	/**
	 * @return the rightJText_AdmissionContact_Address3
	 */
	private TextBase getRightJText_RegisteredOffice_Address3() {
		if (RightJText_RegisteredOffice_Address3 == null) {
			RightJText_RegisteredOffice_Address3 = new TextBase();
			RightJText_RegisteredOffice_Address3.setBounds(460, 66, 300, 20);
		}
		return RightJText_RegisteredOffice_Address3;
	}

	/**
	 * @return the rightJText_AdmissionContact_Address4
	 */
	private TextBase getRightJText_RegisteredOffice_Address4() {
		if (RightJText_RegisteredOffice_Address4 == null) {
			RightJText_RegisteredOffice_Address4 = new TextBase();
			RightJText_RegisteredOffice_Address4.setBounds(460, 88, 300, 20);
		}
		return RightJText_RegisteredOffice_Address4;
	}

	private LabelBase getRightJLabel_AuthorizedPerson_Person() {
		if (RightJLabel_AuthorizedPerson_Person == null) {
			RightJLabel_AuthorizedPerson_Person = new LabelBase();
			RightJLabel_AuthorizedPerson_Person.setBounds(17, 0, 130, 20);
			RightJLabel_AuthorizedPerson_Person.setText("Contact Person");
		}
		return RightJLabel_AuthorizedPerson_Person;
	}

	private TextBase getRightJText_AuthorizedPerson_Person() {
		if (RightJText_AuthorizedPerson_Person == null) {
			RightJText_AuthorizedPerson_Person = new TextBase();
			RightJText_AuthorizedPerson_Person.setBounds(140, 0, 170, 20);
		}
		return RightJText_AuthorizedPerson_Person;
	}

	private LabelBase getRightJLabel_AuthorizedPerson_Title() {
		if (RightJLabel_AuthorizedPerson_Title == null) {
			RightJLabel_AuthorizedPerson_Title = new LabelBase();
			RightJLabel_AuthorizedPerson_Title.setText("Title");
			RightJLabel_AuthorizedPerson_Title.setBounds(17, 22, 130, 20);
		}
		return RightJLabel_AuthorizedPerson_Title;
	}

	private TextBase getRightJText_AuthorizedPerson_Title() {
		if (RightJText_AuthorizedPerson_Title == null) {
			RightJText_AuthorizedPerson_Title = new TextBase();
			RightJText_AuthorizedPerson_Title.setBounds(140, 22, 170, 20);
		}
		return RightJText_AuthorizedPerson_Title;
	}

	private LabelBase getRightJLabel_AuthorizedPerson_PhoneNumber() {
		if (RightJLabel_AuthorizedPerson_PhoneNumber == null) {
			RightJLabel_AuthorizedPerson_PhoneNumber = new LabelBase();
			RightJLabel_AuthorizedPerson_PhoneNumber.setText("Phone Number");
			RightJLabel_AuthorizedPerson_PhoneNumber.setBounds(17, 44, 140, 20);
		}
		return RightJLabel_AuthorizedPerson_PhoneNumber;
	}

	private TextPhone getRightJText_AuthorizedPerson_PhoneNumber() {
		if (RightJText_AuthorizedPerson_PhoneNumber == null) {
			RightJText_AuthorizedPerson_PhoneNumber = new TextPhone();
			RightJText_AuthorizedPerson_PhoneNumber.setBounds(140, 44, 170, 20);
		}
		return RightJText_AuthorizedPerson_PhoneNumber;
	}

	private LabelBase getRightJLabel_AuthorizedPerson_FaxNumber() {
		if (RightJLabel_AuthorizedPerson_FaxNumber == null) {
			RightJLabel_AuthorizedPerson_FaxNumber = new LabelBase();
			RightJLabel_AuthorizedPerson_FaxNumber.setText("Fax Number");
			RightJLabel_AuthorizedPerson_FaxNumber.setBounds(17, 66, 140, 20);
		}
		return RightJLabel_AuthorizedPerson_FaxNumber;
	}

	private TextPhone getRightJText_AuthorizedPerson_FaxNumber() {
		if (RightJText_AuthorizedPerson_FaxNumber == null) {
			RightJText_AuthorizedPerson_FaxNumber = new TextPhone();
			RightJText_AuthorizedPerson_FaxNumber.setBounds(140, 66, 170, 20);
		}
		return RightJText_AuthorizedPerson_FaxNumber;
	}

	private LabelBase getRightJLabel_AuthorizedPerson_EmailAddress() {
		if (RightJLabel_AuthorizedPerson_EmailAddress == null) {
			RightJLabel_AuthorizedPerson_EmailAddress = new LabelBase();
			RightJLabel_AuthorizedPerson_EmailAddress.setBounds(350, 0, 130, 20);
			RightJLabel_AuthorizedPerson_EmailAddress.setText("Email Address");
		}
		return RightJLabel_AuthorizedPerson_EmailAddress;
	}

	/**
	 * This method initializes RightJText_AdmissionContact_EmailAddress
	 *
	 * @return com.hkah.client.layout.textfield.TextBase
	 */
	private TextBase getRightJText_AuthorizedPerson_EmailAddress() {
		if (RightJText_AuthorizedPerson_EmailAddress == null) {
			RightJText_AuthorizedPerson_EmailAddress = new TextBase();
			RightJText_AuthorizedPerson_EmailAddress.setBounds(460, 0, 300, 20);
		}
		return RightJText_AuthorizedPerson_EmailAddress;
	}

	/**
	 * @return the rightJLabel_AdmissionContact_Address
	 */
	private LabelBase getRightJLabel_AuthorizedPerson_Address() {
		if (RightJLabel_AuthorizedPerson_Address == null) {
			RightJLabel_AuthorizedPerson_Address = new LabelBase();
			RightJLabel_AuthorizedPerson_Address.setText("Address");
			RightJLabel_AuthorizedPerson_Address.setBounds(350, 22, 130, 20);
		}
		return RightJLabel_AuthorizedPerson_Address;
	}

	/**
	 * @return the rightJText_AdmissionContact_Address1
	 */
	private TextBase getRightJText_AuthorizedPerson_Address1() {
		if (RightJText_AuthorizedPerson_Address1 == null) {
			RightJText_AuthorizedPerson_Address1 = new TextBase();
			RightJText_AuthorizedPerson_Address1.setBounds(460, 22, 300, 20);
		}
		return RightJText_AuthorizedPerson_Address1;
	}

	/**
	 * @return the rightJText_AdmissionContact_Address2
	 */
	private TextBase getRightJText_AuthorizedPerson_Address2() {
		if (RightJText_AuthorizedPerson_Address2 == null) {
			RightJText_AuthorizedPerson_Address2 = new TextBase();
			RightJText_AuthorizedPerson_Address2.setBounds(460, 44, 300, 20);
		}
		return RightJText_AuthorizedPerson_Address2;
	}

	/**
	 * @return the rightJText_AdmissionContact_Address3
	 */
	private TextBase getRightJText_AuthorizedPerson_Address3() {
		if (RightJText_AuthorizedPerson_Address3 == null) {
			RightJText_AuthorizedPerson_Address3 = new TextBase();
			RightJText_AuthorizedPerson_Address3.setBounds(460, 66, 300, 20);
		}
		return RightJText_AuthorizedPerson_Address3;
	}

	/**
	 * @return the rightJText_AdmissionContact_Address4
	 */
	private TextBase getRightJText_AuthorizedPerson_Address4() {
		if (RightJText_AuthorizedPerson_Address4 == null) {
			RightJText_AuthorizedPerson_Address4 = new TextBase();
			RightJText_AuthorizedPerson_Address4.setBounds(460, 88, 300, 20);
		}
		return RightJText_AuthorizedPerson_Address4;
	}

	private LabelBase getRightJLabel_ARCompanyCode() {
		if (RightJLabel_ARCompanyCode == null) {
			RightJLabel_ARCompanyCode = new LabelBase();
			RightJLabel_ARCompanyCode.setText("AR Code");
			RightJLabel_ARCompanyCode.setBounds(0, 5, 100, 20);
		}
		return RightJLabel_ARCompanyCode;
	}

	private ComboARCompany getRightJCombo_ARCompanyCode() {
		if (RightJCombo_ARCompanyCode == null) {
			RightJCombo_ARCompanyCode = new ComboARCompany(true, true) {
				@Override
				protected void onPressed(FieldEvent fe) {
					if (fe.getKeyCode() == KeyCodes.KEY_TAB) {
						if (!isEmpty()) {
							final String arccode = getText();
							ModelData modelData = findModelByKey(arccode, true);

							if (findModelByKey(arccode, true) == null) {
								resetText();
								return;
							}
							searchAction();
						}
					}
				}

			};
			RightJCombo_ARCompanyCode.setBounds(105, 5, 200, 20);
		}
		return RightJCombo_ARCompanyCode;
	}

	private LabelBase getRightJLabel_ARCompanyName() {
		if (RightJLabel_ARCompanyName == null) {
			RightJLabel_ARCompanyName = new LabelBase();
			RightJLabel_ARCompanyName.setText("AR Name");
			RightJLabel_ARCompanyName.setBounds(320, 5, 100, 20);
		}
		return RightJLabel_ARCompanyName;
	}

	private TextString getRightJText_ARCompanyName() {
		if (RightJText_ARCompanyName == null) {
			RightJText_ARCompanyName = new TextString(80);
			RightJText_ARCompanyName.setBounds(425, 5, 250, 20);
		}
		return RightJText_ARCompanyName;
	}

	private LabelBase getRightJLabel_ARNature() {
		if (RightJLabel_ARNature == null) {
			RightJLabel_ARNature = new LabelBase();
			RightJLabel_ARNature.setText("Company Nature");
//			RightJLabel_ARNature.setBounds(5, 95, 100, 60);
			RightJLabel_ARNature.setHeight(18);
		}
		return RightJLabel_ARNature;
	}

	private ComboARNature getRightJText_ARNature() {
		if (RightJText_ARNature == null) {
			RightJText_ARNature = new ComboARNature();
//			RightJText_ARNature.setBounds(100, 95, 100, 60);
//			RightJText_ARNature.setWidth(180);
			RightJText_ARNature.setHeight(18);
		}
		return RightJText_ARNature;
	}

	private LabelBase getRightJLabel_Agreement() {
		if (RightJLabel_Agreement == null) {
			RightJLabel_Agreement = new LabelBase();
			RightJLabel_Agreement.setText("Agreement");
			RightJLabel_Agreement.setBounds(5, 0, 100, 20);
//			RightJLabel_Agreement.setHeight(18);
		}
		return RightJLabel_Agreement;
	}

	private CheckBoxBase getRightJCheckBox_Agreement() {
		if (RightJCheckBox_Agreement == null) {
			RightJCheckBox_Agreement = new CheckBoxBase();
			RightJCheckBox_Agreement.setBounds(100, 0, 20, 20);
//			RightJCheckBox_Agreement.setHeight(18);
		}
		return RightJCheckBox_Agreement;
	}

	private LabelBase getRightJLabel_PayCodeChk() {
		if (RightJLabel_PayCodeChk == null) {
			RightJLabel_PayCodeChk = new LabelBase();
			RightJLabel_PayCodeChk.setText("Pay Code Check");
			RightJLabel_PayCodeChk.setBounds(5, 145, 100, 20);
		}
		return RightJLabel_PayCodeChk;
	}
	/**
	 * This method initializes RightJRadioButton_PayCodeChk
	 *
	 * @return com.hkah.client.layout.button.RadioButtonBase
	 */
	private CheckBoxBase getRightCheckBox_PayCodeChk() {
		if (RightCheckBox_PayCodeChk == null) {
			RightCheckBox_PayCodeChk = new CheckBoxBase(/*getListTable(), 47*/);
			RightCheckBox_PayCodeChk.setBounds(135, 145, 20, 20);
		}
		return RightCheckBox_PayCodeChk;
	}

	private LabelBase getRightJLabel_PrtMedRecordRpt() {
		if (RightJLabel_PrtMedRecordRpt == null) {
			RightJLabel_PrtMedRecordRpt = new LabelBase();
			RightJLabel_PrtMedRecordRpt.setText("Prt Med Rpt");
			RightJLabel_PrtMedRecordRpt.setBounds(5, 120, 140, 60);
//			RightJLabel_PrtMedRecordRpt.setHeight(18);
		}
		return RightJLabel_PrtMedRecordRpt;
	}

	private CheckBoxBase getRightCheckBox_PrtMedRecordRpt() {
		if (RightCheckBox_PrtMedRecordRpt == null) {
			RightCheckBox_PrtMedRecordRpt = new CheckBoxBase(/*getListTable(), 40*/);
			RightCheckBox_PrtMedRecordRpt.setBounds(135, 120, 10, 20);
//			RightCheckBox_PrtMedRecordRpt.setHeight(18);
		}
		return RightCheckBox_PrtMedRecordRpt;
	}

	private LabelBase getRightJLabel_isDIDesc() {
		if (RightJLabel_isDIDesc == null) {
			RightJLabel_isDIDesc = new LabelBase();
			RightJLabel_isDIDesc.setText("DI");
			RightJLabel_isDIDesc.setBounds(120, 0, 10, 20);
		}
		return RightJLabel_isDIDesc;
	}

	private CheckBoxBase getRightCheckBox_isDI() {
		if (RightCheckBox_isDI == null) {
			RightCheckBox_isDI = new CheckBoxBase(/*getListTable(), 47*/);
			RightCheckBox_isDI.setBounds(135, 0, 20, 20);
		}
		return RightCheckBox_isDI;
	}


	private LabelBase getRightJLabel_inpAutoBrkdown() {
		if (RightJLabel_inpAutoBrkdown == null) {
			RightJLabel_inpAutoBrkdown = new LabelBase();
			RightJLabel_inpAutoBrkdown.setText("INP Brk Dn");
			RightJLabel_inpAutoBrkdown.setBounds(5, 190, 70, 20);
		}
		return RightJLabel_inpAutoBrkdown;
	}

	private LabelBase getRightJLabel_CLAutoBrkdown() {
		if (RightJLabel_CLAutoBrkdown == null) {
			RightJLabel_CLAutoBrkdown = new LabelBase();
			RightJLabel_CLAutoBrkdown.setText("CL");
			RightJLabel_CLAutoBrkdown.setBounds(65, 170, 70, 20);
		}
		return RightJLabel_CLAutoBrkdown;
	}

	private LabelBase getRightJLabel_ORAutoBrkdown() {
		if (RightJLabel_ORAutoBrkdown == null) {
			RightJLabel_ORAutoBrkdown = new LabelBase();
			RightJLabel_ORAutoBrkdown.setText("OR");
			RightJLabel_ORAutoBrkdown.setBounds(100, 170, 70, 20);
		}
		return RightJLabel_ORAutoBrkdown;
	}

	private LabelBase getRightJLabel_CSAutoBrkdown() {
		if (RightJLabel_CSAutoBrkdown == null) {
			RightJLabel_CSAutoBrkdown = new LabelBase();
			RightJLabel_CSAutoBrkdown.setText("CS");
			RightJLabel_CSAutoBrkdown.setBounds(135, 170, 70, 20);
		}
		return RightJLabel_CSAutoBrkdown;
	}

	private CheckBoxBase getRightCheckBox_inpCLAutoBrkdown() {
		if (RightCheckBox_inpCLAutoBrkdown == null) {
			RightCheckBox_inpCLAutoBrkdown = new CheckBoxBase(/*getListTable(), 48*/);
			RightCheckBox_inpCLAutoBrkdown.setBounds(65, 190, 20, 20);
		}
		return RightCheckBox_inpCLAutoBrkdown;
	}

	private CheckBoxBase getRightCheckBox_inpORAutoBrkdown() {
		if (RightCheckBox_inpORAutoBrkdown == null) {
			RightCheckBox_inpORAutoBrkdown = new CheckBoxBase(/*getListTable(), 49*/);
			RightCheckBox_inpORAutoBrkdown.setBounds(100, 190, 20, 20);
		}
		return RightCheckBox_inpORAutoBrkdown;
	}

	private CheckBoxBase getRightCheckBox_inpCSAutoBrkdown() {
		if (RightCheckBox_inpCSAutoBrkdown == null) {
			RightCheckBox_inpCSAutoBrkdown = new CheckBoxBase(/*getListTable(), 50*/);
			RightCheckBox_inpCSAutoBrkdown.setBounds(135, 190, 20, 20);
		}
		return RightCheckBox_inpCSAutoBrkdown;
	}

	private LabelBase getRightJLabel_opAutoBrkdown() {
		if (RightJLabel_opAutoBrkdown == null) {
			RightJLabel_opAutoBrkdown = new LabelBase();
			RightJLabel_opAutoBrkdown.setText("OP Brk Dn");
			RightJLabel_opAutoBrkdown.setBounds(5, 215, 60, 20);
		}
		return RightJLabel_opAutoBrkdown;
	}

	private CheckBoxBase getRightCheckBox_opCLAutoBrkdown() {
		if (RightCheckBox_opCLAutoBrkdown == null) {
			RightCheckBox_opCLAutoBrkdown = new CheckBoxBase(/*getListTable(), 51*/);
			RightCheckBox_opCLAutoBrkdown.setBounds(65, 215, 20, 20);
		}
		return RightCheckBox_opCLAutoBrkdown;
	}

	private CheckBoxBase getRightCheckBox_opORAutoBrkdown() {
		if (RightCheckBox_opORAutoBrkdown == null) {
			RightCheckBox_opORAutoBrkdown = new CheckBoxBase(/*getListTable(), 52*/);
			RightCheckBox_opORAutoBrkdown.setBounds(100, 215, 20, 20);
		}
		return RightCheckBox_opORAutoBrkdown;
	}

	private CheckBoxBase getRightCheckBox_opCSAutoBrkdown() {
		if (RightCheckBox_opCSAutoBrkdown == null) {
			RightCheckBox_opCSAutoBrkdown = new CheckBoxBase(/*getListTable(), 53*/);
			RightCheckBox_opCSAutoBrkdown.setBounds(135, 215, 20, 20);
		}
		return RightCheckBox_opCSAutoBrkdown;
	}
}
