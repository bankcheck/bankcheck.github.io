/*
 * Created on July 23, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.tx.admin.codetable;

import com.extjs.gxt.ui.client.event.BaseEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.FieldEvent;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.widget.LayoutContainer;
import com.google.gwt.event.dom.client.KeyCodes;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboARCompany;
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
import com.hkah.client.layout.textfield.TextPhone;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.tx.MaintenancePanel;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class AccountReceivable extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.ACCOUNT_RECEIVABLE_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.ACCOUNT_RECEIVABLE_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
	// TODO Auto-generated method stub
	return new String[] {
				"AR Code",              //0 ARCCODE
				"AR Company Name",      //1 ARCNAME
				"AR Company CName",     //2 ARCCNAME
				"GL Code",              //3 GLCCODE
				"R. GL Code",           //4 RETGLCCODE
				"Address1",             //5 ARCADD1
				"Address2",             //6 ARCADD2
				"Address3",             //7 ARCADD3
				"Phone Num.",           //8 ARCTEL
				"FaxNumber",            //9 FAX
				"Email Address",        //10 EMAIL
				"Contact Person",       //11 ARCCT
				"Contact Person Title", //12 ARCTITLE
				"Unallocated Amount",   //13 ARCUAMT
				"Current Outstanding",  //14 ARCAMT
				EMPTY_VALUE,            //15 CPSID
				"Contract Set",         //16 CPSCODE
				EMPTY_VALUE,            //17 ARCADMCNAME
				EMPTY_VALUE,            //18 ADMTTL
				EMPTY_VALUE,            //19 ADMEMAIL
				EMPTY_VALUE,            //20 ARCADMCP
				EMPTY_VALUE,            //21 ARCADMCF
				EMPTY_VALUE,            //22 ARCSND
				EMPTY_VALUE,            //23 FURCCT
				EMPTY_VALUE,            //24 FURTTL
				EMPTY_VALUE,            //25 FUREMAIL
				EMPTY_VALUE,            //26 FURTEL
				EMPTY_VALUE,            //27 FURFAX
				"Co-Pay Type",          //28 COPAYTYP
				"Limit Amt.",           //29 ARLMTAMT
				"Coverage Date",        //30 CVREDATE
				"Co-Payment Amount",    //31 COPAYAMT
				"Item Type D",          //32 ITMTYPED
				"Item Type H",          //33 ITMTYPEH
				"Item Type S",          //34 ITMTYPES
				"Item Type O",          //35 ITMTYPEO
				"Start Date",           //36 AR_S_DATE
				"Termination",          //37 AR_E_DATE
				EMPTY_VALUE,			//38 USRNAME
				EMPTY_VALUE,			//39 ARCUPDDATE
				EMPTY_VALUE,			//40 AR_ACTIVE
				EMPTY_VALUE,			//41 ARCPRIMCOMP
				EMPTY_VALUE,			//42 NCTRSDATE
				EMPTY_VALUE,			//43 NCTREDATE
				EMPTY_VALUE,			//44 ARCADD4,
				"Print MR Rpt"				//45 PRINT_MRRPT
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				80,                     // ARCCODE
				150,                    // ARCNAME
				120,                    // ARCCNAME
				80,                     // GLCCODE
				80,                     // RETGLCCODE
				150,                    // ARCADD1
				150,                    // ARCADD2
				150,                    // ARCADD3
				100,                    // ARCTEL
				100,                    // FAX
				150,                    // EMAIL
				150,                    // ARCCT
				150,                    // ARCTITLE
				80,                     // ARCUAMT
				80,                     // ARCAMT
				0,                      // CPSID
				80,                     // CPSCODE
				0,                      // ARCADMCNAME
				0,                      // ADMTTL
				0,                      // ADMEMAIL
				0,                      // ARCADMCP
				0,                      // ARCADMCF
				0,                      // ARCSND
				0,                      // FURCCT
				0,                      // FURTTL
				0,                      // FUREMAIL
				0,                      // FURTEL
				0,                      // FURFAX
				80,                     // COPAYTYP
				80,                     // ARLMTAMT
				100,                    // CVREDATE
				80,                     // COPAYAMT
				80,                     // ITMTYPED
				80,                     // ITMTYPEH
				80,                     // ITMTYPES
				80,                     // ITMTYPEO
				80,                     // AR_S_DATE
				80,                     // AR_E_DATE
				0,   					// USRNAME
				0,   					// ARCUPDDATE
				0,						// AR_ACTIVE
				0,						// ARCPRIMCOMP
				0,						// NCTRSDATE
				0,						// NCTREDATE
				0,						// ARCADD4,
				80						// PRINT_MRRPT
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;
	private ColumnLayout generalPanel = null;
	private FieldSetBase billingPanel = null;

	private LabelBase RightJLabel_LastUpdateBy = null;
	private TextReadOnly RightJText_LastUpdateBy = null;
	private LabelBase RightJLabel_LastUpdateDate = null;
	private TextReadOnly RightJText_LastUpdateDate = null;
	private LabelBase RightJLabel_ArActive = null;
	private CheckBoxBase RightCheckBox_ArActive = null;
	private LabelBase RightJLabel_PrimaryCompany = null;
	private ComboArPrimComp RightJText_PrimaryCompany = null;
	private LabelBase RightJLabel_NoContractStartDate = null;
	private TextDate RightJText_NoContractStartDate = null;
	private LabelBase RightJLabel_NoContractEndDate = null;
	private TextDate RightJText_NoContractEndDate = null;
	private LabelBase RightJLabel_PrtMedRecordRpt = null;
	private CheckBoxBase RightCheckBox_PrtMedRecordRpt = null;	

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
	private ButtonBase LJButton_ConHistory = null;
	private DlgConHistory dlgConHistory = null;

	private LabelBase searchARCodeDesc = null;
	private ComboARCompany searchARCode = null;
	
	private String oldCode = null;

	/**
	 * This method initializes
	 *
	 */
	public AccountReceivable() {
		super();
		getListTable().setBounds(0, 35, 800, 90);
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		/* >>> ~7.1~ Init action (e.g. Listing, Init Comobbox ========= <<< */
		//setFullEntry(true);
		//setNoGetDB(false);

		/* >>> ~7.2~ Disable Add/Modify/Delete Buttons ================ <<< */
		//setAppendButtonEnabled(false);
		//setModifyButtonEnabled(false);
		setDeleteButtonEnabled(false);

		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		//setRightAlignPanel();

//		performList();
		getListTable().setColumnClass(32, new CheckBoxBase(), false);
		getListTable().setColumnClass(33, new CheckBoxBase(), false);
		getListTable().setColumnClass(34, new CheckBoxBase(), false);
		getListTable().setColumnClass(35, new CheckBoxBase(), false);
		getListTable().setColumnClass(45, new CheckBoxBase(), false);
		
		getListTable().addListener(Events.OnScroll, new Listener() {
			@Override
			public void handleEvent(BaseEvent be) {
				// TODO Auto-generated method stub
				getListTable().getView().layout();
			}
		});
		
//		getListTable().setSize(600, 70);
//		getListTable().setVisible(true);
		searchAction();
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return getRightJText_ARCode();
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
		getRightCheckBox_PrtMedRecordRpt().setSelected(false);

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
		getRightCheckBox_PrtMedRecordRpt().setEnabled(true);

		getListTable().setEnabled(false);
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
		getRightCheckBox_PrtMedRecordRpt().setEnabled(true);		

		oldCode = getRightJText_ARCode().getText();
		getListTable().setEnabled(false);
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
		return new String[] { EMPTY_VALUE, EMPTY_VALUE };
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
		getRightCheckBox_PrtMedRecordRpt().setSelected(MINUS_ONE_VALUE.equals(outParam[index++]));                 //45 PRINT_MRRPT
		
	}

	/* >>> ~21~ Set Add New Row toclearPostAction table ============================== <<< */
	@Override
	protected void clearTableFields() {
		super.clearTableFields();
	}

	/* >>> ~22~ Set Action Input Parameters per table ===================== <<< */
	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		String[] param = new String[] {
			selectedContent[0],  //arccode
			selectedContent[1],  //arcname
			selectedContent[2],  //ARCCNAME
			selectedContent[3],  //glccode
			selectedContent[4],	 //retglccode
			selectedContent[5],  //arcadd1
			selectedContent[6],	 //arcadd2
			selectedContent[7],	 //arcadd3
			selectedContent[8],  //arctel
			selectedContent[9],  //fax
			selectedContent[10],  //email
			selectedContent[11],	//arcct
			selectedContent[12],	//arctitle
			//selectedContent[13],	//arcuamt
			//electedContent[14],   //arcamt
			getRightJText_ConstractualPrice().getText(),//selectedContent[15],   //cpsid         //selectedContent[16],  cpscode
			selectedContent[17],   //arcadmcname
			selectedContent[18],  //admttl
			selectedContent[19],  //admemail
			selectedContent[20],  //arcadmcp
			selectedContent[21],  //arcadmcf
			"Y".equals(selectedContent[22])?"-1":"0",  //arcsnd
			selectedContent[23],  //furcct
			selectedContent[24],	//furttl
			selectedContent[25],   //furemail
			selectedContent[26],   //furtel
			selectedContent[27],   //furfax
			selectedContent[28],  //copaytyp
			selectedContent[29],  //arlmtamt
			getRightJText_FurtherGuarantee_CvtEndDate().getText(),  //curedate
			selectedContent[31],  //copayamt
			"Y".equals(selectedContent[32])?"-1":"0",  //itmtyped
			"Y".equals(selectedContent[33])?"-1":"0",  //itmtypeh
			"Y".equals(selectedContent[34])?"-1":"0",  //itmtypes
			"Y".equals(selectedContent[35])?"-1":"0",  //itmtypeo
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
		};
		return param;
	}

	/* >>> ~23~ Set Action Validation per table =========================== <<< */
	@Override
	protected boolean actionValidation(String[] selectedContent) {
		// TODO Auto-generated method stub
		if (selectedContent[0] == null || selectedContent[0].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty AR Code!");
			return false;
		} else if (selectedContent[1] == null || selectedContent[1].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty AR Name!");
			return false;
		} else if (selectedContent[3] == null || selectedContent[3].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty GL Code!");
			return false;
		} else if (selectedContent[5] == null || selectedContent[5].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty Address!");
			return false;
		}
		return true;
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	public void appendAction() {
		if (getAppendButton().isEnabled() && addActionValidation()) {
			clearTableFields();
			super.appendAction(false);
		}
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
		super.enableButton(mode);
		if (isAppend() || isModify()) {
			getClearButton().setEnabled(true);
			getSearchButton().setEnabled(false);
		} else {
			getClearButton().setEnabled(false);
			getSearchButton().setEnabled(true);
		}
		getRefreshButton().setEnabled(false);
		getSearchARCode().setEnabled(!isAppend() && !isModify());
	}


	/***************************************************************************
	 * Layout Method
	 **************************************************************************/
	
	private LabelBase getSearchARCodeDesc() {
		if (searchARCodeDesc == null) {
			searchARCodeDesc = new LabelBase();
			searchARCodeDesc.setText("Search AR Code:");
			searchARCodeDesc.setBounds(0, 10, 100, 20);
		}
		return searchARCodeDesc;
	}
	
	private ComboARCompany getSearchARCode() {
		if (searchARCode == null) {
			searchARCode = new ComboARCompany(true, true) {
				@Override
				protected void onPressed(FieldEvent fe) {
					if (fe.getKeyCode() == KeyCodes.KEY_TAB) {
						if (!isEmpty()) {
							final String arccode = getText();
							if (findModelByKey(arccode, true) == null) {
								resetText();
								return;
							}
							
							for (int i = 0; i < getListTable().getStore().getCount(); i++) {
								if (arccode.equalsIgnoreCase(getListTable().getStore().getAt(i).getValue(0).toString())) {
									getListTable().setSelectRow(i);
								}
							}
						}
					}
				}
			};
			searchARCode.setBounds(110, 10, 150, 20);
		}
		return searchARCode;
	}

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
	protected LayoutContainer getActionPanel() {
		if (rightPanel == null) {
			rightPanel = new BasePanel();
			rightPanel.add(getSearchARCodeDesc(), null);
			rightPanel.add(getSearchARCode(), null);
			rightPanel.add(getGeneralPanel(), null);
			rightPanel.add(getBillingPanel(), null);
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
			generalPanel = new ColumnLayout(6, 6, new int[] {130, 190, 130, 190, 140, 20}, new int[] {18, 18, 18, 20, 18, 18});
			generalPanel.setHeading("General");
			generalPanel.add(0, 0, getRightJLabel_ARCode());
			generalPanel.add(1, 0, getRightJText_ARCode());
			generalPanel.add(0, 1, getRightJLabel_ARCName());
			generalPanel.add(1, 1, getRightJText_ARCName());
			generalPanel.add(0, 2, getRightJLabel_RefundGlCode());
			generalPanel.add(1, 2, getRightJText_RefundGlCode());
			generalPanel.add(0, 3, getRightJLabel_PrimaryCompany());
			generalPanel.add(1, 3, getRightJText_PrimaryCompany());
			generalPanel.add(0, 4, getRightJLabel_StartDate());
			generalPanel.add(1, 4, getRightJText_StartDate());
			generalPanel.add(0, 5, getRightJLabel_NoContractStartDate());
			generalPanel.add(1, 5, getRightJText_NoContractStartDate());

			generalPanel.add(2, 0, getRightJLabel_ARName());
			generalPanel.add(3, 0, getRightJText_ARName());
			generalPanel.add(2, 1, getRightJLabel_GlCode());
			generalPanel.add(3, 1, getRightJText_GlCode());
			generalPanel.add(2, 2, getRightJLabel_ConstractualPrice());
			generalPanel.add(3, 2, getRightJText_ConstractualPrice());
			generalPanel.add(3, 3, getLJButton_ConHistory());
			generalPanel.add(2, 4, getRightJLabel_TerminationDate());
			generalPanel.add(3, 4, getRightJText_TerminationDate());
			generalPanel.add(2, 5, getRightJLabel_NoContractEndDate());
			generalPanel.add(3, 5, getRightJText_NoContractEndDate());

			generalPanel.add(4, 0, getRightJLabel_LastUpdateBy());
			generalPanel.add(4, 1, getRightJText_LastUpdateBy());
			generalPanel.add(4, 2, getRightJLabel_LastUpdateDate());
			generalPanel.add(4, 3, getRightJText_LastUpdateDate());
			generalPanel.add(4, 4, getRightJLabel_ArActive());
			generalPanel.add(5, 4, getRightCheckBox_ArActive());
			generalPanel.add(4, 5, getRightJLabel_PrtMedRecordRpt());			
			generalPanel.add(5, 5, getRightCheckBox_PrtMedRecordRpt());
			
			generalPanel.setBounds(0, 40, 800, 160);
		}
		return generalPanel;
	}

	/**
	 * This method initializes billingPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	private FieldSetBase getBillingPanel() {
		if (billingPanel == null) {
			billingPanel = new FieldSetBase();
			billingPanel.setHeading("Billing");
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
			billingPanel.setBounds(0, 200, 800, 115);
		}
		return billingPanel;
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
			jTabbedPane.setBounds(0, 320, 800, 135);
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
					setCurrentTable(0, RightJText_ARCode.getText());
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
											setCurrentTable(0, "");
										} else {
											setCurrentTable(0, getRightJText_ARCode().getText());
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

	private LabelBase getRightJLabel_LastUpdateBy() {
		if (RightJLabel_LastUpdateBy == null) {
			RightJLabel_LastUpdateBy = new LabelBase();
			RightJLabel_LastUpdateBy.setText("Last update by");
			RightJLabel_LastUpdateBy.setHeight(18);
		}
		return RightJLabel_LastUpdateBy;
	}

	private TextReadOnly getRightJText_LastUpdateBy() {
		if (RightJText_LastUpdateBy == null) {
			RightJText_LastUpdateBy = new TextReadOnly(getListTable(), 38);
			RightJText_LastUpdateBy.setSize(130, 18);
		}
		return RightJText_LastUpdateBy;
	}

	private LabelBase getRightJLabel_LastUpdateDate() {
		if (RightJLabel_LastUpdateDate == null) {
			RightJLabel_LastUpdateDate = new LabelBase();
			RightJLabel_LastUpdateDate.setText("Last update date/time");
			RightJLabel_LastUpdateDate.setHeight(18);
		}
		return RightJLabel_LastUpdateDate;
	}

	private TextReadOnly getRightJText_LastUpdateDate() {
		if (RightJText_LastUpdateDate == null) {
			RightJText_LastUpdateDate = new TextReadOnly(getListTable(), 39);
			RightJText_LastUpdateDate.setSize(130, 18);
		}
		return RightJText_LastUpdateDate;
	}

	private LabelBase getRightJLabel_ArActive() {
		if (RightJLabel_ArActive == null) {
			RightJLabel_ArActive = new LabelBase();
			RightJLabel_ArActive.setText("Active");
			RightJLabel_ArActive.setHeight(18);
		}
		return RightJLabel_ArActive;
	}

	private CheckBoxBase getRightCheckBox_ArActive() {
		if (RightCheckBox_ArActive == null) {
			RightCheckBox_ArActive = new CheckBoxBase(getListTable(), 40);
			RightCheckBox_ArActive.setBounds(0, 5, 20, 20);
			RightCheckBox_ArActive.setHeight(18);
		}
		return RightCheckBox_ArActive;
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

	private LabelBase getRightJLabel_NoContractStartDate() {
		if (RightJLabel_NoContractStartDate == null) {
			RightJLabel_NoContractStartDate = new LabelBase();
			RightJLabel_NoContractStartDate.setText("No Contract Start Date");
			//NoContractStartDate.setBounds(16, 109, 140, 20);
			RightJLabel_NoContractStartDate.setHeight(18);
		}
		return RightJLabel_NoContractStartDate;
	}

	private TextDate getRightJText_NoContractStartDate() {
		if (RightJText_NoContractStartDate == null) {
			RightJText_NoContractStartDate = new TextDate() {
				public void onReleased() {
					setCurrentTable(42, RightJText_NoContractStartDate.getText());
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
					setCurrentTable(43, RightJText_NoContractEndDate.getText());
				}
			};
			RightJText_NoContractEndDate.setWidth(180);
			RightJText_NoContractEndDate.setHeight(18);
		}
		return RightJText_NoContractEndDate;
	}
	
	private LabelBase getRightJLabel_PrtMedRecordRpt() {
		if (RightJLabel_PrtMedRecordRpt == null) {
			RightJLabel_PrtMedRecordRpt = new LabelBase();
			RightJLabel_PrtMedRecordRpt.setText("Print Medical Report");
			//RightJLabel_PrtMedRecordRpt(16, 109, 140, 20);
			RightJLabel_PrtMedRecordRpt.setHeight(18);
		}
		return RightJLabel_PrtMedRecordRpt;
	}
	
	private CheckBoxBase getRightCheckBox_PrtMedRecordRpt() {
		if (RightCheckBox_PrtMedRecordRpt == null) {
			RightCheckBox_PrtMedRecordRpt = new CheckBoxBase(getListTable(), 40);
//			RightCheckBox_PrtMedRecordRpt.setBounds(0, 5, 20, 20);
			RightCheckBox_PrtMedRecordRpt.setHeight(18);
		}
		return RightCheckBox_PrtMedRecordRpt;	
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
			RightJText_ARName = new TextName(getListTable(), 1);
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
			RightJText_ARCName = new TextNameChinese(getListTable(), 2);
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
					setCurrentTable(3, RightJText_GlCode.getText());
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
										setCurrentTable(3, RightJText_GlCode.getText());
									} else {
										Factory.getInstance().addErrorMessage("Invalid GL Code!", RightJText_GlCode);
										RightJText_GlCode.resetText();
										setCurrentTable(3, "");
	
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
			RightJText_RefundGlCode = new TextBase(getListTable(), 4);
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
					setCurrentTable(36, RightJText_StartDate.getText());
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
			RightJText_TerminationDate = new TextDate() {
				public void onReleased() {
					setCurrentTable(37, RightJText_TerminationDate.getText());
				}
			};
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
			RightJText_ClaimContact_Person = new TextBase(getListTable(), 11);
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
			RightJText_ClaimContact_Title = new TextBase(getListTable(), 12);
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
			RightJText_ClaimContact_PhoneNumber = new TextPhone(getListTable(), 8);
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
			RightJText_ClaimContact_FaxNumber = new TextPhone(getListTable(), 9);
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
			RightJText_ClaimContact_EmailAddress = new TextBase(getListTable(), 10);
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
			RightJText_ClaimContact_Address1 = new TextBase(getListTable(), 5);
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
			RightJText_ClaimContact_Address2 = new TextBase(getListTable(), 6);
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
			RightJText_ClaimContact_Address3 = new TextBase(getListTable(), 7);
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
			RightJText_ClaimContact_Address4 = new TextBase(getListTable(), 44);
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
			RightJText_AdmissionContact_Person = new TextBase(getListTable(), 17);
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
			RightJText_AdmissionContact_Title = new TextBase(getListTable(), 18);
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
			RightJText_AdmissionContact_PhoneNumber = new TextPhone(getListTable(), 20);
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
			RightJText_AdmissionContact_FaxNumber = new TextPhone(getListTable(), 21);
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
			RightJText_AdmissionContact_EmailAddress = new TextBase(getListTable(), 19);
			RightJText_AdmissionContact_EmailAddress.setBounds(460, 0, 170, 20);
		}
		return RightJText_AdmissionContact_EmailAddress;
	}

	private LabelBase getRightJLabel_AdmissionContract_AdmissionNotice() {
		if (RightJLabel_AdmissionContract_AdmissionNotice == null) {
			RightJLabel_AdmissionContract_AdmissionNotice = new LabelBase();
			RightJLabel_AdmissionContract_AdmissionNotice.setText("Adminssion Notice");
			RightJLabel_AdmissionContract_AdmissionNotice.setBounds(350, 22, 150, 20);
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
			RightCheckBox_AdmissionContract_AdmissionNotice = new CheckBoxBase(getListTable(), 22);
			RightCheckBox_AdmissionContract_AdmissionNotice.setBounds(460, 22, 20, 20);
		}
		return RightCheckBox_AdmissionContract_AdmissionNotice;
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
			RightJText_FurtherGuarantee_ContactPerson = new TextBase(getListTable(), 23);
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
			RightJText_FurtherGuarantee_ContactTitle = new TextBase(getListTable(), 24);
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
			RightJText_FurtherGuarantee_PhoneNumber = new TextPhone(getListTable(), 26);
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
			RightJText_FurtherGuarantee_FaxNumber = new TextPhone(getListTable(), 27);
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
			RightJText_FurtherGuarantee_EmailAddress = new TextBase(getListTable(), 25);
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
					setCurrentTable(29, "0");
					setCurrentTable(29, RightJText_FurtherGuarantee_LimitAmt.getText());
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
			RightJCombo_FurtherGuarantee_CoPayRefType = new ComboCoPayRefType(getListTable(), 28);
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
					setCurrentTable(31, RightJText_ClaimContact_CoPayRefAmount.getText());
				}

				public void onClick() {
					if (RightJText_ClaimContact_CoPayRefAmount.getText() == null || RightJText_ClaimContact_CoPayRefAmount.getText().trim().length()==0) {
						setCurrentTable(31, "0");
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
					setCurrentTable(30, RightJText_FurtherGuarantee_CvtEndDate.getText());
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
			RightCheckBox_FurtherGuarantee_Doctor = new CheckBoxBase(getListTable(), 32);
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
			RightCheckBox_FurtherGuarantee_Hospital = new CheckBoxBase(getListTable(), 33);
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
			RightCheckBox_FurtherGuarantee_Special = new CheckBoxBase(getListTable(), 34);
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
			RightCheckBox_FurtherGuarantee_Other = new CheckBoxBase(getListTable(), 35);
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
}