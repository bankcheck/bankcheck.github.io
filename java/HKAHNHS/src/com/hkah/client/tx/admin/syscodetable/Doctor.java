/*
 * Created on July 23, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.tx.admin.syscodetable;

import java.util.ArrayList;
import java.util.Date;

import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.FieldEvent;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.store.ListStore;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.form.Field;
import com.extjs.gxt.ui.client.widget.form.TextField;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboDocClass;
import com.hkah.client.layout.combobox.ComboDocType;
import com.hkah.client.layout.combobox.ComboDoctorDept;
import com.hkah.client.layout.combobox.ComboDoctorDeptServ;
import com.hkah.client.layout.combobox.ComboDoctorItemCode;
import com.hkah.client.layout.combobox.ComboPatientCat;
import com.hkah.client.layout.combobox.ComboPatientType;
import com.hkah.client.layout.combobox.ComboPrintAddress;
import com.hkah.client.layout.combobox.ComboPrivilege;
import com.hkah.client.layout.combobox.ComboQualification;
import com.hkah.client.layout.combobox.ComboRelDoc;
import com.hkah.client.layout.combobox.ComboSex;
import com.hkah.client.layout.combobox.ComboSpecialtyCode;
import com.hkah.client.layout.combobox.ComboTitle;
import com.hkah.client.layout.dialog.DlgDoctorSelection;
import com.hkah.client.layout.dialog.DlgNewDr;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.panel.TabbedPaneBase;
import com.hkah.client.layout.table.EditorTableList;
import com.hkah.client.layout.table.TableData;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextDoctorSearch;
import com.hkah.client.layout.textfield.TextName;
import com.hkah.client.layout.textfield.TextNameChinese;
import com.hkah.client.layout.textfield.TextNum;
import com.hkah.client.layout.textfield.TextPhone;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.ActionPanel;
import com.hkah.client.tx.schedule.DoctorAppointment;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.PanelUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TableUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsProperties;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class Doctor extends ActionPanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.DOCTOR_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.DOCTOR_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Doctor code",				//1  	0
				"Family Name",				//2  	1
				"Given Name",				//3  	2
				"DOCCNAME",                 //   	3
				"DOCIDNO",					//	 	4
				"Sex",						//4     5
				"Specialty Name",			//5     6
				"Specialty Code",			//6     7
				"Active",					//      8
				"Doctor Type",				//11    9

				"DOCPCT_I",                 //      10
				"DOCPCT_O",					//		11
				"DOCPCT_D",					//		12
				"DOCADD1",					//		13
				"DOCADD2",					//		14
				"DOCADD3",					//		15
				"Home Phone",				//9     16
				"Office Phone",				//10    17
				"Pager",					//8     18
				"DOCTSLOT",					//		19

				"DOCQUALI",					//      20
				"DOCTDATE",					//		21
				"DOCSDATE",					//		22
				"DOCHOMADD1",				//		23
				"DOCHOMADD2",				//		24
				"DOCHOMADD3",				//		25
				"Office Address line 1",	//12    26
				"Office Address line 2",	//13    27
				"Office Address line 3",	//14    28
				"DOCCSHOLY",				//      29

				"Mobile Phone",				//7     30
				"DOCEMAIL",					//		31
				"DOCFAXNO",					//		32
				"DOCHOMADD4",				//		33
				"DOCADD4",					//		34
				"Office Address line 4",	//15 	35
				"DOCPICKLIST",				//      36
				"DOCQUALIFY",				//      37
				"DOB",						//	    38
				"RPTTO",					//      39

				"ISDOCTOR",					//		40
				"TITTLE",					//		41
				"ISOTSURGEON",				//      42
				"ISOTANESTHETIST",			//		43
				"SHOWPROFILE",				//		44
				"STODECLARATION"			//		45
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				100,	// DR.DOCCODE,
				100,	//DR.DOCFNAME,
				100,	//DR.DOCGNAME,
				0,
				0,
				50,		// DR.DOCSEX,
				140,	// SP.SPCNAME,
				100,	// DR.SPCCODE,
				0,		// DR.DOCMTEL,
				80,		// DR.DOCPTEL,

				0,
				0,
				0,
				0,
				0,
				0,
				100,	// DR.DOCHTEL,
				100,	// DR.DOCOTEL,
				100,	// DR.DOCTYPE,
				0,		// DR.DOCOFFADD1,

				0,
				0,
				0,
				0,
				0,
				0,
				150,	// DR.DOCOFFADD2,
				150,	// DR.DOCOFFADD3,
				150,	// DR.DOCOFFADD4,
				0,

				100,
				0,
				0,
				0,
				0,		// DR.DOCBDATE,
				150,	// DR.DOCSTS
				0,
				0,
				0,
				0,

				0,
				0,
				0,
				0,
				0,
				0
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel actionPanel = null;

	private DlgNewDr dlgNewDr = null;

	private TextDate RightJText_SignDate = null;
	private TextString RightJText_MedicalLicenseNo = null;
	private TextDate RightJText_EfficDate = null;
	private TextDate RightJText_SingnLableDate = null;
	private TextDate RightJText_ClinicDate = null;
	private TextDate RightJText_MPSEfficDate = null;
	private LabelBase RightJLabel_MPSEfficDate = null;
	private LabelBase RightJLabel_SignDate = null;
	private LabelBase RightJLabel_MedicalLicenseNo = null;
	private LabelBase RightJLabel_SingnLableDate = null;
	private LabelBase RightJLabel_ClinicDate = null;
	private LabelBase RightJLabel_Lab1 = null;
	private LabelBase RightJLabel_Lab2 = null;
	private LabelBase RightJLabel_Lab3 = null;
	private LabelBase RightJLabel_Lab4 = null;
	private LabelBase RightJLabel_Lab5 = null;
	private LabelBase RightJLabel_Lab6 = null;
	private LabelBase RightJLabel_Lab7 = null;
	private LabelBase RightJLabel_Lab8 = null;
	private LabelBase RightJLabel_Lab9 = null;
	private LabelBase RightJLabel_Lab10 = null;
	private LabelBase RightJLabel_CLab1 = null;
	private LabelBase RightJLabel_CLab2 = null;
	private LabelBase RightJLabel_CLab3 = null;
	private LabelBase RightJLabel_CLab4 = null;
	private LabelBase RightJLabel_CLab5 = null;
	private LabelBase RightJLabel_CLab6 = null;
	private LabelBase RightJLabel_CLab7 = null;
	private LabelBase RightJLabel_CLab8 = null;
	private LabelBase RightJLabel_CLab9 = null;
	private LabelBase RightJLabel_CLab10 = null;
	private TextString RightJText_CText1 = null;
	private TextString RightJText_CText2 = null;
	private TextString RightJText_CText3 = null;
	private TextString RightJText_CText4 = null;
	private TextString RightJText_CText5 = null;
	private TextString RightJText_CText6 = null;
	private TextString RightJText_CText7 = null;
	private TextString RightJText_CText8 = null;
	private TextString RightJText_CText9 = null;
	private TextString RightJText_CText10 = null;
	private TextString RightJText_Text1 = null;
	private TextString RightJText_Text2 = null;
	private TextString RightJText_Text3 = null;
	private TextString RightJText_Text4 = null;
	private TextString RightJText_Text5 = null;
	private TextString RightJText_Text6 = null;
	private TextString RightJText_Text7 = null;
	private TextString RightJText_Text8 = null;
	private TextString RightJText_Text9 = null;
	private TextString RightJText_Text10 = null;
	private LabelBase RightJLabel_EfficDate = null;

	private FieldSetBase PersonnalPanel = null;
	private LabelBase RightJLabel_DoctorCode = null;
	private TextDoctorSearch RightJText_DoctorCode = null;
	private LabelBase RightJLabel_DoctorFamilyName = null;
	private TextName RightJText_DoctorFamilyName = null;
	private LabelBase RightJLabel_DoctorGivenName = null;
	private TextName RightJText_DoctorGivenName = null;
	private TextString RightJText_BRNo = null;
	private TextString RightJText_Remarks = null;
	private LabelBase RightJLabel_Sex = null;
	private ComboSex RightJCombo_Sex = null;
	private ComboDocType RightCombo_Type = null;
	private LabelBase RightJLabel_Type = null;
	private ButtonBase newBrBtn = null;
	private LabelBase RightJLabel_OtherDoc = null;
	private LabelBase RightJLabel_Title = null;
	private LabelBase RightJLabel_ChineseName = null;
	private LabelBase RightJLabel_ID_PassportNo = null;
	private LabelBase RightJLabel_MstDocCode = null;
	private TextString RightJText_MstDocCode = null;
	private LabelBase RightJLabel_EhrUid = null;
	private TextNum RightJText_EhrUid = null;
	private ButtonBase uptDrBtn = null;

	private LabelBase RightJLabel_DOB = null;
	private LabelBase RightJLabel_Address = null;
	private LabelBase RightJLabel_HomePhone = null;
	private LabelBase RightJLabel_OfficePhone = null;
	private LabelBase RightJLabel_Pager = null;
	private LabelBase RightJLabel_MobilePhone = null;
	private LabelBase RightJLabel_PrintAddress = null;
	private LabelBase RightJLabel_HomeAddress = null;
	private LabelBase RightJLabel_OfficeAddress = null;
	private LabelBase RightJLabel_EmailAddress = null;
	private LabelBase RightJLabel_FaxNumber = null;
	private LabelBase RightJLabel_ReceivePromo = null;
	private LabelBase RightJLabel_ReceivePromoByFax = null;
	private LabelBase RightJLabel_Company = null;

	private LabelBase RightJLabel_InpatShare = null;
	private LabelBase RightJLabel_OutpatShare = null;
	private LabelBase RightJLabel_DaycaseShare = null;

	private LabelBase RightJLabel_SpecialityCode = null;
	private LabelBase RightJLabel_BRNo = null;
	private LabelBase RightJLabel_DeclarationOfSTO = null;
	private CheckBoxBase RightJCheck_DeclarationOfSTO = null;
	private LabelBase RightJLabel_Remarks = null;
	private ComboSpecialtyCode RightJText_SpecialityCode = null;
	private LabelBase RightJLabel_Active = null;
	private CheckBoxBase RightJCheck_Active = null;
	private LabelBase RightJLabel_QualificationDesc = null;
	private LabelBase RightJLabel_TimeSlotDuration = null;
	private LabelBase RightJLabel_StartDate = null;
	private LabelBase RightJLabel_TerminationDate = null;
	private LabelBase RightJLabel_OPStartDate = null;
	private LabelBase RightJLabel_OPEndDate = null;
	private LabelBase RightJLabel_InsurComp = null;
	private LabelBase RightJLabel_HKMANo = null;
	private LabelBase RightJLabel_MPSNo = null;
	private LabelBase RightJLabel_CashOnly = null;
	private LabelBase RightJLabel_CompleteOfQualification = null;
	private LabelBase RightJLabel_Picklist = null;
	private LabelBase RightJLabel_IsDoctor = null;
	private LabelBase RightJLabel_IsEndoscopist = null;
	private LabelBase RightJLabel_IsOTSurgeon = null;
	private LabelBase RightJLabel_IsOTAnesthetist = null;
	private LabelBase RightJLabel_DoctorProfile = null;
	private LabelBase RightJLabel_IsPostSchedule = null;

//	private Vector tableData_ItemShare = new Vector();
//	private Vector tableData_BasicSalary = new Vector();
//	private Vector tableData_Qualification = new Vector();
//	private Vector tableData_Specialty = new Vector();
//	private Vector tableData_Department = new Vector();
//	private Vector tableData_Privilege = new Vector();

	private TabbedPaneBase ContactJTabbedPane = null;
	private BasePanel RightBasePanel_Contact = null;
	private BasePanel RightBasePanel_EmailAddressFaxNo = null;
	private BasePanel RightBasePanel_HomeOfficeAddress = null;

	private TabbedPaneBase DetailJTabbedPane = null;
	private BasePanel RightBasePanel_General = null;
	private BasePanel RightBasePanel_Privilege = null;
	private BasePanel RightBasePanel_Department = null;
	private BasePanel RightBasePanel_Specialty = null;
	private BasePanel RightBasePanel_Qualification = null;
	private BasePanel RightBasePanel_BasicSalary = null;
	private BasePanel RightBasePanel_ConShare = null;
	private BasePanel RightBasePanel_ItemShare = null;
	private BasePanel RightBasePanel_ItemShareHist = null;
	private BasePanel SharePanel = null;
	private TextNameChinese RightJText_ChineseName = null;
	private TextString RightJText_IDPassportNo = null;
	private TextDate RightJText_DOB = null;
	private TextString RightJText_DocAddress1 = null;
	private TextString RightJText_DocAddress2 = null;
	private TextString RightJText_DocAddress3 = null;
	private TextString RightJText_DocAddress4 = null;
	private TextPhone RightJText_HomePhone = null;
	private TextPhone RightJText_OfficePhone = null;
	private TextPhone RightJText_Pager = null;
	private TextPhone RightJText_MobilePhone = null;
	private TextString RightJText_HomeAddress = null;
	private TextString RightJText_HomeAddress2 = null;
	private TextString RightJText_HomeAddress3 = null;
	private TextString RightJText_HomeAddress4 = null;
	private TextString RightJText_OfficeAddress1 = null;
	private TextString RightJText_OfficeAddress2 = null;
	private TextString RightJText_OfficeAddress3 = null;
	private TextString RightJText_OfficeAddress4 = null;
	private TextString RightJText_EmailAddress = null;
	private TextString RightJText_Company = null;
	private TextPhone RightJText_FaxNumber = null;
	private TextNum RightJText_InpatShare = null;
	private TextNum RightJText_OutpatShare = null;
	private TextNum RightJText_DaycaseShare = null;
	private TextNum RightJTex_TimeSlotDuration = null;
	private LabelBase RightJLabel_Minutes = null;
	private TextDate RightJText_StartDate = null;
	private TextDate RightJText_TerminationDate = null;
	private TextDate RightJText_OPStartDate = null;
	private TextDate RightJText_OPEndDate = null;
	private TextString RightJText_InsurComp = null;
	private TextString RightJText_HKMANo = null;
	private TextString RightJText_MPSNo = null;
	private TextString RightJText_QualificationDesc = null;
	private CheckBoxBase RightJCheck_IsOTSurgeon = null;
	private CheckBoxBase RightJCheck_Picklist = null;
	private CheckBoxBase RightJCheck_IsDoctor = null;
	private CheckBoxBase RightJCheck_IsEndescopist = null;
	private CheckBoxBase RightJCheck_DoctorProfile = null;
	private CheckBoxBase RightJCheck_IsOTAnesthetist = null;
	private CheckBoxBase RightJCheck_IsPostSchedule = null;
	private CheckBoxBase RightJCheck_ReceivePromo = null;
	private CheckBoxBase RightJCheck_ReceivePromoByFax = null;
	private CheckBoxBase RightJCheck_CompleteOfQualification = null;
	private CheckBoxBase RightJCheck_CashOnly = null;
	private ComboTitle RightJCombo_Title = null;
	private ComboRelDoc RightJCombo_OtherDoc = null;

	private BasePanel RightBasePanel_RefDate = null;
	private JScrollPane tableScrollPanel_Privilege = null;
	private EditorTableList RightJTable_Privilege = null;
	private JScrollPane tableScrollPanel_Department = null; 
	private EditorTableList RightJTable_Department = null;
	private JScrollPane tableScrollPanel_Specialty = null;
	private EditorTableList RightJTable_Specialty = null;
	private JScrollPane tableScrollPanel_Qualification = null;
	private EditorTableList RightJTable_Qualification = null;
	private BasePanel RightBasePanel_CertChi = null;
	private BasePanel RightBasePanel_CertEng = null;
	private JScrollPane tableScrollPanel_BasicSalary = null;
	private EditorTableList RightJTable_BasicSalary = null;
	private JScrollPane tableScrollPanel_ConShare = null;
	private EditorTableList RightJTable_ConShare = null;
	private JScrollPane tableScrollPanel_ItemShare = null;
	private EditorTableList RightJTable_ItemShare = null;
	private JScrollPane tableScrollPanel_ItemShareHist = null;
	private EditorTableList RightJTable_ItemShareHist = null;	
	private JScrollPane tableScrollPanel_Approval = null;
	private EditorTableList RightJTable_Approval = null;
	private BasePanel RightBasePanel_Approval = null;
	private ButtonBase RightButtonBase_Load = null;
	private ComboPrintAddress RightJCombo_PrintAddress = null;
	
	private BasePanel RightBasePanel_Class = null;
	private JScrollPane tableScrollPanel_Class = null;
	private EditorTableList RightJTable_Class = null;

	private boolean isAllowNewDr = false;

	private ArrayList deleteRowsPrivilege = new ArrayList();
	private ArrayList deleteRowsDepartment = new ArrayList();
	private ArrayList deleteRowsSpecialty = new ArrayList();
	private ArrayList deleteRowsQulification = new ArrayList();
	private ArrayList deleteRowsBasicSalary = new ArrayList();
	private ArrayList deleteRowsConShare = new ArrayList();
	private ArrayList deleteRowsItemShare = new ArrayList();
	private ArrayList deleteRowsItemShareHist = new ArrayList();
	private ArrayList deleteRowsApproval = new ArrayList();
	private ArrayList deleteRowsClass = new ArrayList();
	
	private String memTerminationDate = null;

	private ArrayList<String> viewedTab = new ArrayList<String>();
	private int saveTabNum = 0;
	/**
	 * This method initializes
	 *
	 */
	public Doctor() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		super.init();
		/* >>> ~7.1~ Init action (e.g. Listing, Init Comobbox ========= <<< */
		//setFullEntry(true);
		isAllowNewDr = !isDisableFunction("cmdNewDr", "mntDoctor");

		/* >>> ~7.2~ Disable Add/Modify/Delete Buttons ================ <<< */
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		// screen need to render in order to get value
		getDetailJTabbedPane().setSelectedIndex(0);

//		getListTable().setColumnClass(3, new ComboSex(), false);
//		getListTable().setColumnClass(10, new ComboDocType(), false);

		clearAction();
		disableButton();
		getSearchButton().setEnabled(true);
		getAppendButton().setEnabled(isAllowNewDr);
		getNewDrButton().setEnabled(isAllowNewDr);
		getUpdateToDrCodeButton().setEnabled(false);

		getRightJCheck_CompleteOfQualification().setVisible(ConstantsProperties.OT == 1 ? true : false);
		getRightJTable_Privilege().removeAllRow();
		getRightJTable_Department().removeAllRow();
		getRightJTable_Specialty().removeAllRow();
		getRightJTable_Qualification().removeAllRow();
		getRightJTable_BasicSalary().removeAllRow();
		getRightJTable_ConShare().removeAllRow();
		getRightJTable_ItemShare().removeAllRow();
		getRightJTable_ItemShareHist().removeAllRow();
		getRightJTable_Approval().removeAllRow();
		getRightJTable_Class().removeAllRow();
	}

	@Override
	public void rePostAction() {
		super.rePostAction();
		if (getParameter("DocCode") != null) {
			searchDoctor(getParameter("DocCode"), false);
		}
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public ButtonBase getDefaultFocusComponent() {
		return getNewDrButton();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {
		// override function if necessary
	}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {
		// enable/disable field
	}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
		getRightJText_DoctorCode().setEditable(false);
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
		return null;
	}

	/* >>> ~16~ Set Fetch Input Parameters ================================ <<< */
	@Override
	protected String[] getFetchInputParameters() {
		return new String[] {
				getRightJText_DoctorCode().getText()
		};
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {
		//  validate if it from DoctorAppointment start
		if (getParameter("From") != null) {
			setParameter("DOCCODE", outParam[0]);
			setParameter("DOCNAME", outParam[1]+" "+outParam[2]);
			showPanel(new DoctorAppointment());
			return;
		}
		//  validate if it from DoctorAppointment end
		memTerminationDate = null;
		int index = 0;
		String docCode = outParam[index++];

		getRightJText_DoctorCode().setText(docCode);     					//DOCCODE
		getRightJText_DoctorFamilyName().setText(outParam[index++]);		//DOCFNAME
		getRightJText_DoctorGivenName().setText(outParam[index++]);			//DOCGNAME
		getRightJText_ChineseName().setText(outParam[index++]);				//DOCCNAME
		getRightJText_IDPassportNo().setText(outParam[index++]);			//DOCIDNO
		getRightJCombo_Sex().setText(outParam[index++]);					//DOCSEX
		getRightJText_SpecialityCode().setText(outParam[index++]);			//SPCCODE
		getRightJCheck_Active().setText(outParam[index++]);					//DOCSTS
		getRightCombo_Type().setText(outParam[index++]);              		//DOCTYPE
		getRightJText_InpatShare().setText(outParam[index++]);				//DOCPCT_I
		getRightJText_OutpatShare().setText(outParam[index++]);				//DOCPCT_O
		getRightJText_DaycaseShare().setText(outParam[index++]);			//DOCPCT_D
		getRightJText_DocAddress1().setText(outParam[index++]);				//DOCADD1
		getRightJText_DocAddress2().setText(outParam[index++]);				//DOCADD2
		getRightJText_DocAddress3().setText(outParam[index++]);				//DOCADD3
		getRightJText_HomePhone().setText(outParam[index++]);				//DOCHTEL
		getRightJText_OfficePhone().setText(outParam[index++]);				//DOCOTEL
		getRightJText_Pager().setText(outParam[index++]);					//DOCPTEL
		getRightJText_TimeSlotDuration().setText(outParam[index++]);		//DOCTSLOT
		getRightJText_QualificationDesc().setText(outParam[index++]);		//DOCQUALI
		getRightJText_TerminationDate().setText(outParam[index++]);			//DOCTDATE
		getRightJText_StartDate().setText(outParam[index++]);				//DOCSDATE
		getRightJText_HomeAddress().setText(outParam[index++]);				//DOCHOMADD1
		getRightJText_HomeAddress2().setText(outParam[index++]);			//DOCHOMADD2
		getRightJText_HomeAddress3().setText(outParam[index++]);			//DOCHOMADD3
		getRightJText_OfficeAddress1().setText(outParam[index++]);			//DOCOFFADD1
		getRightJText_OfficeAddress2().setText(outParam[index++]);			//DOCOFFADD2
		getRightJText_OfficeAddress3().setText(outParam[index++]);			//DOCOFFADD3
		getRightJCheck_CashOnly().setText(outParam[index++]);				//DOCCSHOLY
		getRightJText_MobilePhone().setText(outParam[index++]);				//DOCMTEL
		getRightJText_EmailAddress().setText(outParam[index++]);			//DOCEMAIL
		getRightJText_FaxNumber().setText(outParam[index++]);				//DOCFAXNO
		getRightJText_HomeAddress4().setText(outParam[index++]);			//DOCHOMADD4
		getRightJText_DocAddress4().setText(outParam[index++]); 			//DOCADD4
		getRightJText_OfficeAddress4().setText(outParam[index++]);			//DOCOFFADD4
		getRightJCheck_Picklist().setText(outParam[index++]);				//DOCPICKLIST
		getRightJCheck_CompleteOfQualification().setText(outParam[index++]);//DOCQUALIFY
		getRightJText_DOB().setText(outParam[index++]);						//DOCBDATE
		getRightJCombo_PrintAddress().setText(outParam[index++]);			//RPTTO
		getRightJCheck_IsDoctor().setText(outParam[index++]);				//ISDOCTOR
		getRightJCombo_Title().setText(outParam[index++]);					//TITTLE
		getRightJCheck_IsOTSurgeon().setText(outParam[index++]);			//ISOTSURGEON
		getRightJCheck_IsOTAnesthetist().setText(outParam[index++]);		//ISOTANESTHETIST
		getRightJCheck_DoctorProfile().setText(outParam[index++]);			//SHOWPROFILE
		getRightJText_BRNo().setText(outParam[index++]);					//BRNO
		getRightJText_Remarks().setText(outParam[index++]);                 //DOCREMARK
		getRightJText_SignDate().setText(outParam[index++]);                //CPSDATE
		getRightJText_EfficDate().setText(outParam[index++]);               //APLDATE
		getRightJText_MPSEfficDate().setText(outParam[index++]);            //MPSCDATE
		getRightJText_SingnLableDate().setText(outParam[index++]);          //SLDATE
		getRightJCheck_IsEndoscopist().setText(outParam[index++]);          //ISOTENDOSCOPIST
		getRightJText_Text1().setText(outParam[index++]);                   //DOCCERT.ECERT1
		getRightJText_Text2().setText(outParam[index++]);                   //DOCCERT.ECERT2
		getRightJText_Text3().setText(outParam[index++]);                   //DOCCERT.ECERT3
		getRightJText_Text4().setText(outParam[index++]);                   //DOCCERT.ECERT4
		getRightJText_Text5().setText(outParam[index++]);                   //DOCCERT.ECERT5
		getRightJText_Text6().setText(outParam[index++]);                   //DOCCERT.ECERT6
		getRightJText_Text7().setText(outParam[index++]);                   //DOCCERT.ECERT7
		getRightJText_Text8().setText(outParam[index++]);                   //DOCCERT.ECERT8
		getRightJText_Text9().setText(outParam[index++]);                   //DOCCERT.ECERT9
		getRightJText_Text10().setText(outParam[index++]);                  //DOCCERT.ECERT10
		getRightJText_CText1().setText(outParam[index++]);                  //DOCCERT.CCERT1
		getRightJText_CText2().setText(outParam[index++]);                  //DOCCERT.CCERT2
		getRightJText_CText3().setText(outParam[index++]);                  //DOCCERT.CCERT3
		getRightJText_CText4().setText(outParam[index++]);                  //DOCCERT.CCERT4
		getRightJText_CText5().setText(outParam[index++]);                  //DOCCERT.CCERT5
		getRightJText_CText6().setText(outParam[index++]);                  //DOCCERT.CCERT6
		getRightJText_CText7().setText(outParam[index++]);                  //DOCCERT.CCERT7
		getRightJText_CText8().setText(outParam[index++]);                  //DOCCERT.CCERT8
		getRightJText_CText9().setText(outParam[index++]);                  //DOCCERT.CCERT9
		getRightJText_CText10().setText(outParam[index++]);                 //DOCCERT.CCERT10
		getRightJCheck_IsPostSchedule().setText(outParam[index++]);         //ISPOSTSCHEDULE
		getRightJCheck_ReceivePromo().setText(outParam[index++]);           //RECEIVEPROMO
		getRightJCheck_ReceivePromoByFax().setText(outParam[index++]);      //RECEIVEPROMOBYFAX
		getRightJText_MedicalLicenseNo().setText(outParam[index++]);        //HKMCLICNO
		getRightJText_ClinicDate().setText(outParam[index++]);              //CLINSDATE
		getRightJText_OPStartDate().setText(outParam[index++]);             //OPPSDATE
		getRightJText_OPEndDate().setText(outParam[index++]);               //OPPEDATE
		getRightJText_InsurComp().setText(outParam[index++]);               //DOCINSURCOMP
		String mst = outParam[index++];                                     //MSTRDOCCODE
		getRightJText_MstrDocCode().setText(mst);                           //
		getRightJText_EhrUid().setText(outParam[index++]);                  //EHRUID
		getRightJText_Company().setText(outParam[index++]);                 //COMPANY
		getRightJCheck_DeclarationOfSTO().setText(outParam[index++]);       //DOCTOR_EXTRA.STODECLARATION
		getRightJCombo_OtherDoc().setText(docCode);                         //
		getRightJText_HKMANo().setText(outParam[index++]);                  //DOCTOR_EXTRA.HKMANO
		getRightJText_MPSNo().setText(outParam[index++]);                   //DOCTOR_EXTRA.MPSNO
		
		// set subtables
		getRightJTable_Privilege().setListTableContent(ConstantsTx.LIST_DOCTOR_PRIVILEGE_TXCODE, new String[] { docCode, "Y" });
		getRightJTable_Department().setListTableContent(ConstantsTx.LIST_DOCTOR_DEPARTMENT_TXCODE, new String[] { docCode });
		getRightJTable_Specialty().setListTableContent(ConstantsTx.LIST_DOCTOR_SPECIALTY_TXCODE, new String[] { docCode });
		getRightJTable_Qualification().setListTableContent(ConstantsTx.LIST_DOCTOR_QUALIFICATION_TXCODE, new String[] { docCode });
		getRightJTable_BasicSalary().setListTableContent(ConstantsTx.LIST_DOCTOR_BASICSALARY_TXCODE, new String[] { docCode });
		getRightJTable_ConShare().setListTableContent(ConstantsTx.LIST_DOCPCTHIST_TXCODE, new String[] { docCode });
		getRightJTable_ItemShare().setListTableContent(ConstantsTx.LIST_DOCTOR_ITEMSHARE_TXCODE, new String[] { docCode, "Y"});
		getRightJTable_ItemShareHist().setListTableContent(ConstantsTx.LIST_DOCTOR_ITEMSHAREHIST_TXCODE, new String[] { docCode, "Y"});
		getRightJTable_Approval().setListTableContent(ConstantsTx.LIST_DOCTOR_APPROVAL_TXCODE, new String[] { docCode });
		getRightJTable_Class().setListTableContent(ConstantsTx.LIST_DOCTOR_CLASS_TXCODE, new String[] { docCode});
		getRightJCombo_OtherDoc().reset();
		
		memTerminationDate = getRightJText_TerminationDate().getText(); 

		// reset combobox
		getRightJCombo_OtherDoc().initContent(docCode);
		getRightJCombo_OtherDoc().setEditable(true);

		getContactJTabbedPane().setSelectedIndexWithoutStateChange(0);
		getDetailJTabbedPane().setSelectedIndexWithoutStateChange(0);
	}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return new String[] {
				getRightJText_DoctorCode().getText(),     					//DOCCODE
				getRightJText_DoctorFamilyName().getText(),		//DOCFNAME
				getRightJText_DoctorGivenName().getText(),			//DOCGNAME
				getRightJText_ChineseName().getText(),				//DOCCNAME
				getRightJText_IDPassportNo().getText(),		//DOCIDNO
				getRightJCombo_Sex().getText(),				//DOCSEX
				getRightJText_SpecialityCode().getText(),			//SPCCODE
				getRightJCheck_Active().getValue() ? "-1" : "0",				//DOCSTS
				getRightCombo_Type().getText(),            		//DOCTYPE
				getRightJText_InpatShare().getText(),				//DOCPCT_I
				getRightJText_OutpatShare().getText(),				//DOCPCT_O
				getRightJText_DaycaseShare().getText(),			//DOCPCT_D
				getRightJText_DocAddress1().getText(),			//DOCADD1
				getRightJText_DocAddress2().getText(),				//DOCADD2
				getRightJText_DocAddress3().getText(),				//DOCADD3
				getRightJText_HomePhone().getText(),				//DOCHTEL
				getRightJText_OfficePhone().getText(),				//DOCOTEL
				getRightJText_Pager().getText(),					//DOCPTEL
				getRightJText_TimeSlotDuration().getText(),		//DOCTSLOT
				getRightJText_QualificationDesc().getText(),		//DOCQUALI
				getRightJText_TerminationDate().getText(),			//DOCTDATE
				getRightJText_StartDate().getText(),				//DOCSDATE
				getRightJText_HomeAddress().getText(),				//DOCHOMADD1
				getRightJText_HomeAddress2().getText(),		//DOCHOMADD2
				getRightJText_HomeAddress3().getText(),			//DOCHOMADD3
				getRightJText_OfficeAddress1().getText(),			//DOCOFFADD1
				getRightJText_OfficeAddress2().getText(),			//DOCOFFADD2
				getRightJText_OfficeAddress3().getText(),			//DOCOFFADD3
				getRightJCheck_CashOnly().getValue() ? "-1" : "0",				//DOCCSHOLY
				getRightJText_MobilePhone().getText(),				//DOCMTEL
				getRightJText_EmailAddress().getText(),			//DOCEMAIL
				getRightJText_FaxNumber().getText(),				//DOCFAXNO
				getRightJText_HomeAddress4().getText(),			//DOCHOMADD4
				getRightJText_DocAddress4().getText(), 			//DOCADD4
				getRightJText_OfficeAddress4().getText(),			//DOCOFFADD4
				getRightJCheck_Picklist().getValue() ? "-1" : "0",				//DOCPICKLIST
				getRightJCheck_CompleteOfQualification().getValue() ? "-1" : "0",//DOCQUALIFY
				getRightJText_DOB().getText(),						//DOCBDATE
				getRightJCombo_PrintAddress().getText(),			//RPTTO
				getRightJCheck_IsDoctor().getValue() ? "-1" : "0",				//ISDOCTOR
				getRightJCombo_Title().getText(),					//TITTLE
				getRightJCheck_IsOTSurgeon().getValue() ? "-1" : "0",			//ISOTSURGEON
				getRightJCheck_IsOTAnesthetist().getValue() ? "-1" : "0",		//ISOTANESTHETIST
				getRightJCheck_DoctorProfile().getValue() ? "-1" : "0",			//SHOWPROFILE
				getRightJCheck_DeclarationOfSTO().getValue() ? "-1" : "0",		//STODECLARATION
				getRightJText_BRNo().getText(),						//BRNO
				getRightJText_Remarks().getText(),					//REMARKS
				getRightJText_SignDate().getText(), 				//CPSDATE
				getRightJText_EfficDate().getText(),				//APLDATE
				getRightJText_MPSEfficDate().getText(),				//MPSCDATE
				getRightJText_SingnLableDate().getText(),			//SLDate
				getRightJCheck_IsEndoscopist().getValue() ? "-1" : "0",			//ISENDOSCOPIST
				getRightJText_Text1().getText(),
				getRightJText_Text2().getText(),
				getRightJText_Text3().getText(),
				getRightJText_Text4().getText(),
				getRightJText_Text5().getText(),
				getRightJText_Text6().getText(),
				getRightJText_Text7().getText(),
				getRightJText_Text8().getText(),
				getRightJText_Text9().getText(),
				getRightJText_Text10().getText(),
				getRightJText_CText1().getText(),
				getRightJText_CText2().getText(),
				getRightJText_CText3().getText(),
				getRightJText_CText4().getText(),
				getRightJText_CText5().getText(),
				getRightJText_CText6().getText(),
				getRightJText_CText7().getText(),
				getRightJText_CText8().getText(),
				getRightJText_CText9().getText(),
				getRightJText_CText10().getText(),
				getRightJCheck_IsPostSchedule().getValue() ? "-1" : "0",		//ISPOSTSCHEDULE
				getRightJCheck_ReceivePromo().getValue() ? "-1" : "0",		//RECEIVEPROMO
				getRightJCheck_ReceivePromoByFax().getValue() ? "-1" : "0",		//RECEIVEPROMOBYFAX
				getRightJText_MedicalLicenseNo().getText(),			//    HKMCLICNO
				getRightJText_ClinicDate().getText(),			//DOCINSURCOMP
				getRightJText_OPStartDate().getText(), 			//OPPSDATE
				getRightJText_OPEndDate().getText(),			//OPPEDATE,
				getRightJText_InsurComp().getText(),				//DOCINSURCOMP
				getRightJText_Company().getText(),				//COMPANY
				getRightJText_MstrDocCode().getText(),			//MSTRDOCCODE
				getRightJText_EhrUid().getText(),			//EHRUID
				getRightJText_HKMANo().getText(),				//HKMANO
				getRightJText_MPSNo().getText(),				//MPSNO
				getUserInfo().getSiteCode(),						//SITECODE
				getUserInfo().getUserID()						//USERID
		};
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(final String actionType) {
		if (getRightJText_DoctorCode().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Doctor Code.", getRightJText_DoctorCode());
			actionValidationReady(actionType, false);
			return;
		} else if (getRightJText_DoctorFamilyName().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Family Name.", getRightJText_DoctorFamilyName());
			actionValidationReady(actionType, false);
			return;
		} else if (getRightJText_DoctorGivenName().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Given Name.", getRightJText_DoctorGivenName());
			actionValidationReady(actionType, false);
			return;
		} else if (getRightJCombo_Sex().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Sex.", getRightJCombo_Sex());
			actionValidationReady(actionType, false);
			return;
		} else if (getRightJText_SpecialityCode().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Speciality Code.", getRightJText_SpecialityCode());
			getDetailJTabbedPane().setSelectedIndex(0);
			actionValidationReady(actionType, false);
			return;
		} else if (getRightJText_InpatShare().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Inpat% Share.", getRightJText_InpatShare());
			actionValidationReady(actionType, false);
			return;
		} else if (getRightJText_OutpatShare().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Outpat % Share.", getRightJText_OutpatShare());
			actionValidationReady(actionType, false);
			return;
		} else if (getRightJText_DaycaseShare().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Daycase % Share.", getRightJText_DaycaseShare());
			actionValidationReady(actionType, false);
			return;
		} else if (getRightJText_TimeSlotDuration().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Time Slot Duration.", getRightJText_TimeSlotDuration());
			getDetailJTabbedPane().setSelectedIndex(0);
			actionValidationReady(actionType, false);
			return;
		}
		if (!getRightJText_DOB().isEmpty()) {
			if (!getRightJText_DOB().isValid()) {
				Factory.getInstance().addErrorMessage("Invalid birthday date.", getRightJText_DOB());
				actionValidationReady(actionType, false);
				return;
			} else if (DateTimeUtil.compareTo(getRightJText_DOB().getText(), DateTimeUtil.formatDate(new Date())) >= 0) {
				Factory.getInstance().addErrorMessage("Birthday should not be future date.", getRightJText_DOB());
				actionValidationReady(actionType, false);
				return;
			}
		}
		if (!getRightJText_SignDate().isEmpty() && !getRightJText_SignDate().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid Code of Practice Signed Date.", getRightJText_SignDate());
			getDetailJTabbedPane().setSelectedIndex(10);
			actionValidationReady(actionType, false);
			return;
		}
		if (!getRightJText_EfficDate().isEmpty() && !getRightJText_EfficDate().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid Annual Practising Licence Date.", getRightJText_EfficDate());
			getDetailJTabbedPane().setSelectedIndex(10);
			actionValidationReady(actionType, false);
			return;
		}
		if (!getRightJText_MPSEfficDate().isEmpty() && !getRightJText_MPSEfficDate().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid Malpractice Insurance Expiry Date.", getRightJText_MPSEfficDate());
			getDetailJTabbedPane().setSelectedIndex(10);
			actionValidationReady(actionType, false);
			return;
		}
		if (!getRightJText_SingnLableDate().isEmpty() && !getRightJText_SingnLableDate().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid Signature Label Date.", getRightJText_SingnLableDate());
			getDetailJTabbedPane().setSelectedIndex(10);
			actionValidationReady(actionType, false);
			return;
		}
		if (!getRightJText_ClinicDate().isEmpty() && !getRightJText_ClinicDate().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid Clinic Start Date.", getRightJText_ClinicDate());
			getDetailJTabbedPane().setSelectedIndex(10);
			actionValidationReady(actionType, false);
			return;
		}
		if (!getRightJText_StartDate().isEmpty() && !getRightJText_StartDate().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid Admission Start Date.", getRightJText_StartDate());
			getDetailJTabbedPane().setSelectedIndex(10);
			actionValidationReady(actionType, false);
			return;
		}
		if (!getRightJText_TerminationDate().isEmpty() && !getRightJText_TerminationDate().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid Admission Expiry Date.", getRightJText_TerminationDate());
			getDetailJTabbedPane().setSelectedIndex(10);
			actionValidationReady(actionType, false);
			return;
		} else if (!isDisableFunction("isAllowExpDtActive", "mntDoctor") 
				&& DateTimeUtil.dateDiff(getRightJText_TerminationDate().getText(), memTerminationDate) > 14 ) {
			Factory.getInstance().addErrorMessage("Can not Extend Termination Date more than 14 Days.", getRightJText_TerminationDate());
			getDetailJTabbedPane().setSelectedIndex(10);
			actionValidationReady(actionType, false);
			return;
		}
		if (!getRightJText_OPStartDate().isEmpty() && !getRightJText_OPStartDate().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid OP Privilege Start Date.", getRightJText_OPStartDate());
			getDetailJTabbedPane().setSelectedIndex(10);
			actionValidationReady(actionType, false);
			return;
		}
		if (!getRightJText_OPEndDate().isEmpty() && !getRightJText_OPEndDate().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid OP Privilege Expiry Date.", getRightJText_OPEndDate());
			getDetailJTabbedPane().setSelectedIndex(10);
			actionValidationReady(actionType, false);
			return;
		}
		if (getRightJText_MstrDocCode().getText().equals(getRightJText_DoctorCode().getText())) {
			Factory.getInstance().addErrorMessage("Master Doctor Code cannot same as Doctor Code"," PBA-[Transaction Detail]", getRightJText_MstrDocCode());
			actionValidationReady(actionType, false);
			return;
		} else {
			// Check  getRightJText_MstrDocCode() is or is not the Master Doctor Code
			QueryUtil.executeMasterFetch(
					getUserInfo(), "MSTR_DOCCODE", new String[] { getRightJText_MstrDocCode().getText() },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					String rtnDocCode = mQueue.getContentField()[0];
//					System.err.println("[rtnDocCode]:"+rtnDocCode);
					if (!rtnDocCode.equals(getRightJText_MstrDocCode().getText())) {
						Factory.getInstance().addErrorMessage(getRightJText_MstrDocCode().getText()+" is NOT the Master Doctor Code"," PBA-[Transaction Detail]", getRightJText_MstrDocCode());
						actionValidationReady(actionType, false);
						return;
					} else {
						actionValidationReady(actionType, true);
					}
				}
			});
		}
	}

	/**
	 * set the search criteria height
	 */
	protected int getSearchHeight() {
		return 145;
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	public void appendAction() {
		if (getAppendButton().isEnabled()) {
			if (!isAppend() && !isModify()) {
				getDlgNewDr().showDialog();
			} else if (getDetailJTabbedPane().getSelectedIndex() == 1) {
				getRightJTable_Privilege().addRow(new String[] {null, null, null, null, null});
			} else if (getDetailJTabbedPane().getSelectedIndex() == 2) {
				getRightJTable_Department().addRow(new String[] {null, null, null, null});
			} else if (getDetailJTabbedPane().getSelectedIndex() == 3) {
				getRightJTable_Specialty().addRow(new Object[] {null, null, new Boolean(false), null, null});
			} else if (getDetailJTabbedPane().getSelectedIndex() == 4) {
				getRightJTable_Qualification().addRow(new String[] {null, null, null, null});
			} else if (getDetailJTabbedPane().getSelectedIndex() == 7) {
				getRightJTable_BasicSalary().addRow(new String[] {null, null, null, null});
			} else if (getDetailJTabbedPane().getSelectedIndex() == 8) {
				getRightJTable_ConShare().addRow(new String[] {null, null, null, null, null, null});				
			} else if (getDetailJTabbedPane().getSelectedIndex() == 9) {
				getRightJTable_ItemShare().addRow(new String[] {null, null, null, null, null, null, null});
			} else if (getDetailJTabbedPane().getSelectedIndex() == 10) {
				getRightJTable_ItemShareHist().addRow(new String[] {null, null, null, null, null, null, null, null, null});			
			} else if (getDetailJTabbedPane().getSelectedIndex() == 11) {
				getRightJTable_Approval().addRow(new String[] {null, null, null, null});
			} else if (getDetailJTabbedPane().getSelectedIndex() == 13) {
				getRightJTable_Class().addRow(new String[] {null, null, null});
			}
		}
//		super.appendAction();
	}

	@Override
	public void clearAction() {
			PanelUtil.resetAllFields(getPersonnalPanel());
			PanelUtil.resetAllFields(getRightBasePanel_Contact());
			PanelUtil.resetAllFields(getRightBasePanel_EmailAddressFaxNo());
			PanelUtil.resetAllFields(getRightBasePanel_HomeOfficeAddress());
			PanelUtil.resetAllFields(getSharePanel());
			PanelUtil.resetAllFields(getRightBasePanel_General());
			PanelUtil.resetAllFields(getRightBasePanel_Privilege());
			PanelUtil.resetAllFields(getRightBasePanel_Department());
			PanelUtil.resetAllFields(getRightBasePanel_Specialty());
			PanelUtil.resetAllFields(getRightBasePanel_Qualification());
			PanelUtil.resetAllFields(getRightBasePanel_CertChi());
			PanelUtil.resetAllFields(getRightBasePanel_CertEng());
			PanelUtil.resetAllFields(getRightBasePanel_BasicSalary());
			PanelUtil.resetAllFields(getRightBasePanel_ConShare());
			PanelUtil.resetAllFields(getRightBasePanel_ItemShare());
			PanelUtil.resetAllFields(getRightBasePanel_ItemShareHist());
			PanelUtil.resetAllFields(getRightBasePanel_Approval());
			PanelUtil.resetAllFields(getRightBasePanel_RefDate());
			PanelUtil.resetAllFields(getRightBasePanel_Class());
			getUpdateToDrCodeButton().setEnabled(false);

			setActionType(null);
	}

	@Override
	public void cancelPostAction() {
		searchDoctor(getRightJText_DoctorCode().getText(), false);
	}

	@Override
	public void searchAction() {
		if (isModify()) {
			searchDoctor(getRightJText_DoctorCode().getText(), false);
			setActionType(null);
		} else {
			getRightJText_DoctorCode().showSearchPanel();
		}
	}

	@Override
	public void modifyAction() {
		super.modifyAction();

		getAppendButton().setEnabled(true);
		getDeleteButton().setEnabled(true);
		getClearButton().setEnabled(false);
		getNewDrButton().setEnabled(false);
		getUpdateToDrCodeButton().setEnabled(false);

		getRightJCombo_OtherDoc().setEditable(false);
//		getRightJTable_ItemShare().getColumnModel().getColumn(0).setEditor(new CellEditor(new TextField<String>()));
		deleteRowsPrivilege.clear();
		deleteRowsDepartment.clear();
		deleteRowsSpecialty.clear();
		deleteRowsQulification.clear();
		deleteRowsBasicSalary.clear();
		deleteRowsConShare.clear();
		deleteRowsItemShare.clear();
		deleteRowsItemShareHist.clear();
		deleteRowsApproval.clear();
		deleteRowsClass.clear();
//		System.err.println("2[getUpdateToDrCodeButton]:"+getUpdateToDrCodeButton().isVisible());
	}

	@Override
	protected void actionValidationReadyHelper(String actionType, MessageQueue mQueue) {
	}

	@Override
	public void saveAction() {
		saveTabNum = DetailJTabbedPane.getSelectedIndex();
		boolean noError = true;

		noError = checkSubTableValues("1", getRightJTable_Privilege(), noError);
		noError = checkSubTableValues("2", getRightJTable_Department(), noError);
		noError = checkSubTableValues("3", getRightJTable_Specialty(), noError);
		noError = checkSubTableValues("4", getRightJTable_Qualification(), noError);
		noError = checkSubTableValues("7", getRightJTable_BasicSalary(), noError);
		noError = checkSubTableValues("8", getRightJTable_ConShare(), noError);
		noError = checkSubTableValues("9", getRightJTable_ItemShare(), noError);
		noError = checkSubTableValues("10", getRightJTable_ItemShareHist(), noError);
		noError = checkSubTableValues("11", getRightJTable_Approval(), noError);
		noError = checkSubTableValues("13", getRightJTable_Class(), noError);

		if (noError) {
			super.saveAction();
		}
	}

	@Override
	protected void savePostAction() {
		if (getRightJTable_Privilege().getStore().getModifiedRecords().size() > 0) {
			getRightJTable_Privilege().saveTable("DOCTOR_PRIVILEGE",
					new String[] {getUserInfo().getUserID(), getRightJText_DoctorCode().getText()},
					"DOCTOR_PRIVILEGE", true, true, false, true, "");
		} else {
			deleteSelectedRowsAction(deleteRowsPrivilege, "DOCTOR_PRIVILEGE", 4);
		}

		if (getRightJTable_Department().getStore().getModifiedRecords().size() > 0) {
			getRightJTable_Department().saveTable("DOCTOR_DEPT",
					new String[] {getUserInfo().getUserID(), getRightJText_DoctorCode().getText()},
					"DOCTOR_DEPT", true, true, false, true, "");
		} else {
			 deleteSelectedRowsAction(deleteRowsDepartment, "DOCTOR_DEPT", 3);
		}

		if (getRightJTable_Specialty().getStore().getModifiedRecords().size() > 0) {
			getRightJTable_Specialty().saveTable("DOCTOR_SPECIALTY",
					new String[] {getUserInfo().getUserID(), getRightJText_DoctorCode().getText()},
					"DOCTOR_SPECIALTY", true, true, false, true, "");
		} else {
			 deleteSelectedRowsAction(deleteRowsSpecialty, "DOCTOR_SPECIALTY", 3);
		}

		if (getRightJTable_Qualification().getStore().getModifiedRecords().size() > 0) {
			getRightJTable_Qualification().saveTable("DOCTOR_QUALIFICATION",
					new String[] {getUserInfo().getUserID(), getRightJText_DoctorCode().getText()},
					"DOCTOR_QUALIFICATION", true, true, false, true, "");
		} else {
			 deleteSelectedRowsAction(deleteRowsQulification, "DOCTOR_QUALIFICATION", 3);
		}

		if (getRightJTable_BasicSalary().getStore().getModifiedRecords().size() > 0) {
			getRightJTable_BasicSalary().saveTable("DOCTOR_BASICSALARY",
					new String[] {getUserInfo().getUserID(), getRightJText_DoctorCode().getText()},
					"DOCTOR_BASICSALARY", true, true, false, true, "");
		} else {
			 deleteSelectedRowsAction(deleteRowsBasicSalary, "DOCTOR_BASICSALARY", 3);
		}
		
		if (getRightJTable_ConShare().getStore().getModifiedRecords().size() > 0) {
			getRightJTable_ConShare().saveTable("DOCPCTHIST",
					new String[] {getUserInfo().getUserID(), getRightJText_DoctorCode().getText()},
					"DOCPCTHIST_OBJ", true, true, false, true, "");
		} else {
			 deleteSelectedRowsAction(deleteRowsConShare, "DOCPCTHIST", 0);
		}

		if (getRightJTable_ItemShare().getStore().getModifiedRecords().size() > 0) {
			getRightJTable_ItemShare().saveTable("DOCTOR_ITEMSHARE",
					new String[] {getUserInfo().getUserID(), getRightJText_DoctorCode().getText(),getUserInfo().getSiteCode()},
					"DOCTOR_ITEMSHARE", true, true, false, true, "");
		} else {
			 deleteSelectedRowsAction(deleteRowsItemShare, "DOCTOR_ITEMSHARE", 7);
		}
		
		if (getRightJTable_ItemShareHist().getStore().getModifiedRecords().size() > 0) {
			getRightJTable_ItemShareHist().saveTable("DOCTOR_ITEMSHAREHIST",
					new String[] {getUserInfo().getUserID(), getRightJText_DoctorCode().getText(),getUserInfo().getSiteCode()},
					"DOCTOR_ITEMSHAREHIST", true, true, false, true, "");
		} else {
			 deleteSelectedRowsAction(deleteRowsItemShareHist, "DOCTOR_ITEMSHAREHIST", 9);
		}

		if (getRightJTable_Approval().getStore().getModifiedRecords().size() > 0) {
			getRightJTable_Approval().saveTable("DOCTOR_APPROVAL",
					new String[] {getUserInfo().getUserID(), getRightJText_DoctorCode().getText()},
					"DOCTOR_APPROVAL", true, true, false, true, "");
		} else {
			 deleteSelectedRowsAction(deleteRowsApproval, "DOCTOR_APPROVAL", 3);
		}
		
		if (getRightJTable_Class().getStore().getModifiedRecords().size() > 0) {
			getRightJTable_Class().saveTable("DOCTOR_CLASS",
					new String[] {getUserInfo().getUserID(), getRightJText_DoctorCode().getText()},
					"DOCTOR_CLASS", true, true, false, true, "");
		} else {
			 deleteSelectedRowsAction(deleteRowsClass, "DOCTOR_CLASS", 3);
		}

		viewedTab.clear();
		viewedTab.add(Integer.toString(saveTabNum));
		getDetailJTabbedPane().setSelectedIndex(saveTabNum);
		searchDoctor(getRightJText_DoctorCode().getText(), false);
	}

	@Override
	public void deleteAction() {
		if (QueryUtil.ACTION_MODIFY.equals(getActionType())) {
			if (getDetailJTabbedPane().getSelectedIndex() == 1) {
				deleteSelectedRows(getRightJTable_Privilege(), deleteRowsPrivilege);
			} else if (getDetailJTabbedPane().getSelectedIndex() == 2) {
				deleteSelectedRows(getRightJTable_Department(), deleteRowsDepartment);
			} else if (getDetailJTabbedPane().getSelectedIndex() == 3) {
				deleteSelectedRows(getRightJTable_Specialty(), deleteRowsSpecialty);
			} else if (getDetailJTabbedPane().getSelectedIndex() == 4) {
				deleteSelectedRows(getRightJTable_Qualification(), deleteRowsQulification);
			} else if (getDetailJTabbedPane().getSelectedIndex() == 7) {
				deleteSelectedRows(getRightJTable_BasicSalary(), deleteRowsBasicSalary);
			} else if (getDetailJTabbedPane().getSelectedIndex() == 8) {
				deleteSelectedRows(getRightJTable_ConShare(), deleteRowsConShare);
			} else if (getDetailJTabbedPane().getSelectedIndex() == 9) {
				deleteSelectedRows(getRightJTable_ItemShare(), deleteRowsItemShare);
			} else if (getDetailJTabbedPane().getSelectedIndex() == 10) {
				deleteSelectedRows(getRightJTable_ItemShareHist(), deleteRowsItemShareHist);				
			} else if (getDetailJTabbedPane().getSelectedIndex() == 11) {
				deleteSelectedRows(getRightJTable_Approval(), deleteRowsApproval);
			} else if (getDetailJTabbedPane().getSelectedIndex() == 13) {
				deleteSelectedRows(getRightJTable_Class(), deleteRowsClass);
			}
		} else {
			MessageBoxBase.confirm("Message", "Are you sure to delete doctor's record?",
					new Listener<MessageBoxEvent>() {
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						QueryUtil.executeMasterAction(getUserInfo(), getTxCode(),QueryUtil.ACTION_DELETE, getActionInputParamaters(),
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									Factory.getInstance().addInformationMessage("Delete successful!");
									clearAction();
									initAfterReady();
								} else {
									Factory.getInstance().addErrorMessage(mQueue.getReturnMsg());
								}
							}
						});
					}
				}
			});
		}
	}

	@Override
	protected void setAllRightFieldsEnabled(boolean enable) {
		if (getActionPanel() != null) {
			// reset field status
			PanelUtil.resetAllFieldsStatus(getActionPanel());
			// disable field
			PanelUtil.setAllFieldsEditable(getActionPanel(), enable);

//			PanelUtil.setAllFieldsEditable(getPersonnalPanel(), true);
//			PanelUtil.setAllFieldsReadOnly(getPersonnalPanel(), !enable);
			setComponentsEnabled(enable);
//			this.setWorking(!enable);
		}
	}

	protected void setComponentsEnabled(boolean enable) {
//		getRightJTable_Privilege().setEnabled(true);
//		getRightJTable_Department().setEnabled(true);
//		getRightJTable_Specialty().setEnabled(true);
//		getRightJTable_Qualification().setEnabled(true);
//		getRightJTable_BasicSalary().setEnabled(true);
//		getRightJTable_ItemShare().setEnabled(true);
//		getRightJTable_Approval().setEnabled(true);
		
		if (Factory.getInstance().getUserInfo().getUserName().toUpperCase().indexOf("ADMIN") <= 0
				&& (!isDisableFunction("isAllowExpDtActive", "mntDoctor") && enable)) {
			PanelUtil.setAllFieldsEditable(getActionPanel(), false);
			getRightJText_TerminationDate().setEditable(!isDisableFunction("isAllowExpDtActive", "mntDoctor") && enable);
			getRightJCheck_Active().setEditable(!isDisableFunction("isAllowExpDtActive", "mntDoctor") && enable);
		}

		getRightJTable_Privilege().enableEvents(!isDisableFunction("grdPrivil", "mntDoctor") && enable);
		getRightJTable_Department().enableEvents(!isDisableFunction("grdDept", "mntDoctor") && enable);
		getRightJTable_Specialty().enableEvents(!isDisableFunction("grdSpec", "mntDoctor") && enable);
		getRightJTable_Qualification().enableEvents(!isDisableFunction("grdQlf", "mntDoctor") && enable);
		getRightJTable_BasicSalary().enableEvents(!isDisableFunction("grdBasSal", "mntDoctor") && enable);
		getRightJTable_ConShare().enableEvents(!isDisableFunction("grdConShare", "mntDoctor") && enable);
		getRightJTable_ItemShare().enableEvents(!isDisableFunction("grdItemShare", "mntDoctor") && enable);
		getRightJTable_Approval().enableEvents(!isDisableFunction("grdApproval", "mntDoctor") && enable);
		getRightJTable_Class().enableEvents(!isDisableFunction("grdClass", "mntDoctor") && enable);

		getRightButtonBase_Load().setEnabled(
				!isDisableFunction("grdItemShare", "mntDoctor") &&
				!getRightJTable_ItemShare().isDisabledEvents());

		if (ConstantsProperties.OT == 1) {
			boolean isCoQEditable = !getRightJCheck_CompleteOfQualification().isReadOnly();
			getRightJCheck_CompleteOfQualification().setEditable(
					!isDisableFunction("chkQualify", "mntDoctor") &&
					isCoQEditable);
		}

		boolean isECertEditable = !isDisableFunction("fraECert", "mntDoctor");
		getRightJText_Text1().setEditable(isECertEditable && getRightJText_Text1().isEditable());
		getRightJText_Text2().setEditable(isECertEditable && getRightJText_Text2().isEditable());
		getRightJText_Text3().setEditable(isECertEditable && getRightJText_Text3().isEditable());
		getRightJText_Text4().setEditable(isECertEditable && getRightJText_Text4().isEditable());
		getRightJText_Text5().setEditable(isECertEditable && getRightJText_Text5().isEditable());
		getRightJText_Text6().setEditable(isECertEditable && getRightJText_Text6().isEditable());
		getRightJText_Text7().setEditable(isECertEditable && getRightJText_Text7().isEditable());
		getRightJText_Text8().setEditable(isECertEditable && getRightJText_Text8().isEditable());
		getRightJText_Text9().setEditable(isECertEditable && getRightJText_Text9().isEditable());
		getRightJText_Text10().setEditable(isECertEditable && getRightJText_Text10().isEditable());

		boolean isCCertEditable = !isDisableFunction("fraCCert", "mntDoctor");
		getRightJText_CText1().setEditable(isCCertEditable && getRightJText_CText1().isEditable());
		getRightJText_CText2().setEditable(isCCertEditable && getRightJText_CText2().isEditable());
		getRightJText_CText3().setEditable(isCCertEditable && getRightJText_CText3().isEditable());
		getRightJText_CText4().setEditable(isCCertEditable && getRightJText_CText4().isEditable());
		getRightJText_CText5().setEditable(isCCertEditable && getRightJText_CText5().isEditable());
		getRightJText_CText6().setEditable(isCCertEditable && getRightJText_CText6().isEditable());
		getRightJText_CText7().setEditable(isCCertEditable && getRightJText_CText7().isEditable());
		getRightJText_CText8().setEditable(isCCertEditable && getRightJText_CText8().isEditable());
		getRightJText_CText9().setEditable(isCCertEditable && getRightJText_CText9().isEditable());
		getRightJText_CText10().setEditable(isCCertEditable && getRightJText_CText10().isEditable());
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void searchDoctor(String doccode, final boolean isModifyAfterSearch) {
		QueryUtil.executeMasterFetch(getUserInfo(), "DOCTOR_DETAIL",
				new String[] { doccode },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getFetchOutputValues(mQueue.getContentField());
					disableButton();
					getSearchButton().setEnabled(true);
					getAppendButton().setEnabled(isAllowNewDr);
					getModifyButton().setEnabled(true);
					getDeleteButton().setEnabled(true);

					getNewDrButton().setEnabled(isAllowNewDr);
					getUpdateToDrCodeButton().setEnabled(getRightJText_MstrDocCode().getText().isEmpty());

					if (isModifyAfterSearch) {
						modifyAction();
					}
				}
			}
		});
	}

	public void initData(String[] data) {
		setParameter("DocCode", data[0]);
		disableButton();
		getAppendButton().setEnabled(true);
		getDeleteButton().setEnabled(true);
		getCancelButton().setEnabled(true);
		getNewDrButton().setVisible(false);

		int index = 0;
		getRightJText_DoctorCode().setText(data[index++]);     			//DOCCODE
		getRightCombo_Type().setText(data[index++]);              		//DOCTYPE
		getRightJText_DoctorFamilyName().setText(data[index++]);		//DOCFNAME
		getRightJCombo_Sex().setText(data[index++]);					//DOCSEX
		getRightJText_DoctorGivenName().setText(data[index++]);			//DOCGNAME
		getRightJText_InpatShare().setText(data[index++]);				//DOCPCT_I
		getRightJText_OutpatShare().setText(data[index++]);				//DOCPCT_O
		getRightJText_DaycaseShare().setText(data[index++]);			//DOCPCT_D
		getRightJText_SpecialityCode().setText(data[index++]);			//SPCCODE
		getRightJText_TimeSlotDuration().setText(data[index++]);		//DOCTSLOT
		getRightJCheck_Active().setText(data[index++]);					//DOCSTS
		getRightJCheck_IsDoctor().setText(data[index]);				    //ISDOCTOR
		getRightJCheck_DeclarationOfSTO().setText(data[index++]);
//		getRightJText_DoctorCode().setEditable(false);
	}

	/***************************************************************************
	 * Dialog Method
	 **************************************************************************/

	private DlgNewDr getDlgNewDr() {
		if (dlgNewDr == null) {
			dlgNewDr = new DlgNewDr(getMainFrame()) {
				@Override
				public void createNewDRComplete(String docCode) {
					searchDoctor(docCode, true);
				}
			};
		}
		return dlgNewDr;
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
			actionPanel.setBounds(0, 0, 825, 505);
			actionPanel.add(getNewDrButton());
			actionPanel.add(getPersonnalPanel());
			actionPanel.add(getContactJTabbedPane());
			actionPanel.add(getSharePanel());
			actionPanel.add(getDetailJTabbedPane());
			actionPanel.add(getUpdateToDrCodeButton());
		}
		return actionPanel;
	}

	public ButtonBase getNewDrButton() {
		if (newBrBtn == null) {
			newBrBtn = new ButtonBase("New Dr") {
				@Override
				public void onClick() {
					appendAction();
				}
			};
			newBrBtn.setBounds(5, 10, 50, 35);
		}
		return newBrBtn;
	}

	public ButtonBase getUpdateToDrCodeButton() {
		if (uptDrBtn == null) {
			uptDrBtn = new ButtonBase("Upt Dr Dtl") {
				@Override
				public void onClick() {
					MessageBoxBase.confirm(ConstantsMessage.MSG_PBA_SYSTEM, "Do you want to copy doctor's info from master doctor? ",
							new Listener<MessageBoxEvent>() {
								@Override
								public void handleEvent(MessageBoxEvent be) {
									if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
//										System.err.println("1[YES]");
										QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
												new String[] {"DOCTOR", "DOCCODE", "DOCCODE ='" + getRightJText_DoctorCode().getText() + "'"},
												new MessageQueueCallBack() {
											public void onPostSuccess(MessageQueue mQueue) {
												if (mQueue.success()) {
													if (mQueue.getContentField()[0] != null && mQueue.getContentField()[0].length() > 0) {
														QueryUtil.executeMasterAction(getUserInfo(), "UPDATE_RELATED_DOCTOR","MOD", getActionInputParamaters(),
																new MessageQueueCallBack() {
															@Override
															public void onPostSuccess(MessageQueue mQueue) {
																if (mQueue.success()) {
																	Factory.getInstance().addInformationMessage("Update related doctor info successful!");
//																	clearAction();
//																	initAfterReady();
																} else {
																	Factory.getInstance().addErrorMessage("Update related doctor info failed", getRightJText_DoctorCode());
																}
															}
														});
													}
												} else {
													Factory.getInstance().addErrorMessage("No related doctor for update.", getRightJText_DoctorCode());
													clearAction();
//													System.err.println("1[select YES]");
												}
											}
										});
									} else {
//										System.err.println("1[select NO]");
									}
								}
							});
				}
			};
			uptDrBtn.setBounds(5, 55, 50, 35);
		}
		return uptDrBtn;
	}

	/***************************************************************************
	 * Pernsonnal Panel Method
	 **************************************************************************/

	/**
	 * This method initializes PersonnalPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected FieldSetBase getPersonnalPanel() {
		if (PersonnalPanel == null) {
			PersonnalPanel = new FieldSetBase();
			PersonnalPanel.setBounds(60, 0, 760, 120);
			PersonnalPanel.setAriaSupport(getAriaSupport());
			PersonnalPanel.setStyleAttribute("margin-bottom", "5px");
			PersonnalPanel.setHeading("Doctor Personnal Information");
			PersonnalPanel.add(getRightJLabel_DoctorCode(), null);
			PersonnalPanel.add(getRightJText_DoctorCode(), null);
			PersonnalPanel.add(getRightJLabel_Type(), null);
			PersonnalPanel.add(getRightCombo_Type(), null);
			PersonnalPanel.add(getRightJLabel_DoctorFamilyName(), null);
			PersonnalPanel.add(getRightJText_DoctorFamilyName(), null);
			PersonnalPanel.add(getRightJLabel_Title(), null);
			PersonnalPanel.add(getRightJCombo_Title(), null);
			PersonnalPanel.add(getRightJLabel_ChineseName(), null);
			PersonnalPanel.add(getRightJText_ChineseName(), null);
			PersonnalPanel.add(getRightJLabel_DoctorGivenName(), null);
			PersonnalPanel.add(getRightJText_DoctorGivenName(), null);
			PersonnalPanel.add(getRightJLabel_Sex(), null);
			PersonnalPanel.add(getRightJCombo_Sex(), null);
			PersonnalPanel.add(getRightJLabel_ID_PassportNo(), null);
			PersonnalPanel.add(getRightJText_IDPassportNo(), null);
			PersonnalPanel.add(getRightJLabel_DOB(), null);
			PersonnalPanel.add(getRightJText_DOB(), null);
			PersonnalPanel.add(getRightJLabel_MstrDocCode(), null);
			PersonnalPanel.add(getRightJText_MstrDocCode(), null);
			PersonnalPanel.add(getRightJLabel_OtherDoc(), null);
			PersonnalPanel.add(getRightJCombo_OtherDoc(), null);
			PersonnalPanel.add(getRightJLabel_EhrUid(), null);
			PersonnalPanel.add(getRightJText_EhrUid(), null);
		}
		return PersonnalPanel;
	}

	/**
	 * This method initializes RightJLabel_DoctorCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_DoctorCode() {
		if (RightJLabel_DoctorCode == null) {
			RightJLabel_DoctorCode = new LabelBase();
			RightJLabel_DoctorCode.setBounds(13, 0, 84, 20);
			RightJLabel_DoctorCode.setText("Doctor Code");
		}
		return RightJLabel_DoctorCode;
	}

	/**
	 * This method initializes RightJText_DoctorCode
	 *
	 * @return com.hkah.client.layout.textfield.TextBase
	 */
	private TextDoctorSearch getRightJText_DoctorCode() {
		if (RightJText_DoctorCode == null) {
			RightJText_DoctorCode = new TextDoctorSearch() {
				@Override public void searchAfterAcceptAction() {
					searchDoctor(getRightJText_DoctorCode().getText(), false);
				}

//				public void onReleased() {
//					// TODO Auto-generated method stub
//					setCurrentTable(0,RightJText_DoctorCode.getText());
//				}

//				public void onBlur() {
//					QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
//							new String[] {"Doctor", "DocCODE", "DocCODE='"+RightJText_DoctorCode.getText()+"'"},
//							new MessageQueueCallBack() {
//								@Override
//								public void onPostSuccess(MessageQueue mQueue) {
//									if (mQueue.success()) {
//										Factory.getInstance().addErrorMessage("Record exists.");
//										RightJText_DoctorCode.resetText();
//										RightJText_DoctorCode.requestFocus();
//									} else {
//										setCurrentTable(0,RightJText_DoctorCode.getText());
//									}
//								}
//							});
//				};
			};
			RightJText_DoctorCode.setBounds(126, 0, 120, 20);
		}
		return RightJText_DoctorCode;
	}

	/**
	 * This method initializes RightJLabel_Type
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_OtherDoc() {
		if (RightJLabel_OtherDoc == null) {
			RightJLabel_OtherDoc = new LabelBase();
			RightJLabel_OtherDoc.setText("Other Doctor");
			RightJLabel_OtherDoc.setBounds(250, 23, 100, 20);
		}
		return RightJLabel_OtherDoc;
	}

	private ComboRelDoc getRightJCombo_OtherDoc() {
		if (RightJCombo_OtherDoc == null) {
			RightJCombo_OtherDoc = new ComboRelDoc() {
//				public void onClick() {
//					setCurrentTable(41, RightJCombo_Title.getText());
//				}

				@Override
				protected void onSelected() {
					searchDoctor(RightJCombo_OtherDoc.getText(), false);
				}
			};
			RightJCombo_OtherDoc.setBounds(350, 23, 90, 20);
		}
		return RightJCombo_OtherDoc;
	}

	private LabelBase getRightJLabel_Type() {
		if (RightJLabel_Type == null) {
			RightJLabel_Type = new LabelBase();
			RightJLabel_Type.setBounds(466, 0, 94, 20);
			RightJLabel_Type.setText("Doctor Type");
		}
		return RightJLabel_Type;
	}

	/**
	 * This method initializes RightCombo_DocType
	 *
	 * @return com.hkah.client.layout.combobox.ComboDocType
	 */
	private ComboDocType getRightCombo_Type() {
		if (RightCombo_Type == null) {
			RightCombo_Type = new ComboDocType();
//			{
//				public void onClick() {
//					setCurrentTable(9,RightCombo_Type.getText());
//				}
//			};
			RightCombo_Type.setBounds(590, 0, 160, 20);
		}
		return RightCombo_Type;
	}

	/**
	 * This method initializes RightJLabel_DoctorFamilyName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_DoctorFamilyName() {
		if (RightJLabel_DoctorFamilyName == null) {
			RightJLabel_DoctorFamilyName = new LabelBase();
			RightJLabel_DoctorFamilyName.setBounds(13, 23, 85, 20);
			RightJLabel_DoctorFamilyName.setText("Family Name");
		}
		return RightJLabel_DoctorFamilyName;
	}

	/**
	 * This method initializes RightJText_DoctorFamilyName
	 *
	 * @return com.hkah.client.layout.textfield.TextName
	 */
	private TextName getRightJText_DoctorFamilyName() {
		if (RightJText_DoctorFamilyName == null) {
			RightJText_DoctorFamilyName = new TextName();
//			getListTable(), 1);
			RightJText_DoctorFamilyName.setBounds(126, 23, 103, 20);

		}
		return RightJText_DoctorFamilyName;
	}

	/**
	 * This method initializes RightJLabel_Title
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_Title() {
		if (RightJLabel_Title == null) {
			RightJLabel_Title = new LabelBase();
			RightJLabel_Title.setText("Title");
			RightJLabel_Title.setBounds(290, 46, 50, 20);
		}
		return RightJLabel_Title;
	}

	private ComboTitle getRightJCombo_Title() {
		if (RightJCombo_Title == null) {
			RightJCombo_Title = new ComboTitle();
//			{
//				public void onClick() {
//					setCurrentTable(41, RightJCombo_Title.getText());
//				}
//			};
			RightJCombo_Title.setBounds(350, 46, 90, 20);
		}
		return RightJCombo_Title;
	}

	/**
	 * This method initializes RightJLabel_ChineseName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_ChineseName() {
		if (RightJLabel_ChineseName == null) {
			RightJLabel_ChineseName = new LabelBase();
			RightJLabel_ChineseName.setText("Chinese Name");
			RightJLabel_ChineseName.setBounds(466, 23, 100, 20);
		}
		return RightJLabel_ChineseName;
	}

	/**
	 * This method initializes RightJText_ChineseName
	 *
	 * @return com.hkah.client.layout.textfield.TextNameChinese
	 */
	private TextNameChinese getRightJText_ChineseName() {
		if (RightJText_ChineseName == null) {
			RightJText_ChineseName = new TextNameChinese();
//			getListTable(), 3);
			RightJText_ChineseName.setAriaSupport(getAriaSupport());
			RightJText_ChineseName.setBounds(590, 23, 160, 20);
		}
		return RightJText_ChineseName;
	}

	/**
	 * This method initializes RightJLabel_DoctorGivenName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_DoctorGivenName() {
		if (RightJLabel_DoctorGivenName == null) {
			RightJLabel_DoctorGivenName = new LabelBase();
			RightJLabel_DoctorGivenName.setBounds(13, 46, 85, 20);
			RightJLabel_DoctorGivenName.setText("Given Name");
		}
		return RightJLabel_DoctorGivenName;
	}

	/**
	 * This method initializes RightJText_DoctorGivenName
	 *
	 * @return com.hkah.client.layout.textfield.TextName
	 */
	private TextName getRightJText_DoctorGivenName() {
		if (RightJText_DoctorGivenName == null) {
			RightJText_DoctorGivenName = new TextName();
//			getListTable(), 2);
			RightJText_DoctorGivenName.setBounds(126, 46, 160, 20);

		}
		return RightJText_DoctorGivenName;
	}

	/**
	 * This method initializes RightJLabel_Sex
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_Sex() {
		if (RightJLabel_Sex == null) {
			RightJLabel_Sex = new LabelBase();
			RightJLabel_Sex.setBounds(290, 69, 90, 20);
			RightJLabel_Sex.setText("Sex");
		}
		return RightJLabel_Sex;
	}

	/**
	 * This method initializes RightJCombo_Sex
	 *
	 * @return com.hkah.client.layout.combobox.ComboSex
	 */
	private ComboSex getRightJCombo_Sex() {
		if (RightJCombo_Sex == null) {
			RightJCombo_Sex = new ComboSex();
//			{
//				public void onClick() {
//					setCurrentTable(5,RightJCombo_Sex.getText());
//				}
//			};
			RightJCombo_Sex.setBounds(350, 69, 90, 20);
		}
		return RightJCombo_Sex;
	}

	/**
	 * This method initializes RightJLabel_ID_PassportNo
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_ID_PassportNo() {
		if (RightJLabel_ID_PassportNo == null) {
			RightJLabel_ID_PassportNo = new LabelBase();
			RightJLabel_ID_PassportNo.setText("ID /Passport No.");
			RightJLabel_ID_PassportNo.setBounds(13, 69, 100, 20);
		}
		return RightJLabel_ID_PassportNo;
	}

	/**
	 * This method initializes RightJText_IDPassortNo
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_IDPassportNo() {
		if (RightJText_IDPassportNo == null) {
			RightJText_IDPassportNo = new TextString(15, false);
//			, getListTable(), 4,false);
			RightJText_IDPassportNo.setBounds(126, 69, 160, 20);
		}
		return RightJText_IDPassportNo;
	}

	private LabelBase getRightJLabel_DOB() {
		if (RightJLabel_DOB == null) {
			RightJLabel_DOB = new LabelBase();
			RightJLabel_DOB.setBounds(466, 69, 94, 20);
			RightJLabel_DOB.setText("DOB");
		}
		return RightJLabel_DOB;
	}

	/**
	 * This method initializes RightJText_DOB
	 *
	 * @return com.hkah.client.layout.textfield.TextDate
	 */
	private TextDate getRightJText_DOB() {
		if (RightJText_DOB == null) {
			RightJText_DOB = new TextDate();
			RightJText_DOB.setMaxValue(new Date());
//			{
//				public void onReleased() {
//					setCurrentTable(38,RightJText_DOB.getText());
//				}
//			};
			RightJText_DOB.setBounds(590, 69, 160, 20);
			/*RightJText_DOB.addKeyListener(new KeyAdapter() {
				public void keyReleased(KeyEvent e) {
					setCurrentTable(38,RightJText_DOB.getText());
				}
			});*/
		}
		return RightJText_DOB;
	}

	private LabelBase getRightJLabel_MstrDocCode() {
		if (RightJLabel_MstDocCode == null) {
			RightJLabel_MstDocCode = new LabelBase();
			RightJLabel_MstDocCode.setText("MSTR Doc Code");
			RightJLabel_MstDocCode.setBounds(250, 0, 100, 20);
		}
		return RightJLabel_MstDocCode;
	}

	private TextString getRightJText_MstrDocCode() {
		if (RightJText_MstDocCode == null) {
			RightJText_MstDocCode = new TextString();
			RightJText_MstDocCode.setBounds(350, 0, 90, 20);
		}
		return RightJText_MstDocCode;
	}

	private LabelBase getRightJLabel_EhrUid() {
		if (RightJLabel_EhrUid == null) {
			RightJLabel_EhrUid = new LabelBase();
			RightJLabel_EhrUid.setText("eHR UID");
			RightJLabel_EhrUid.setBounds(466, 46, 94, 20);
		}
		return RightJLabel_EhrUid;
	}

	private TextNum getRightJText_EhrUid() {
		if (RightJText_EhrUid == null) {
			RightJText_EhrUid = new TextNum(10);
			RightJText_EhrUid.setBounds(590, 46, 160, 20);
		}
		return RightJText_EhrUid;
	}

	/**
	 * This method initializes RightJLabel_InpatShare
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_InpatShare() {
		if (RightJLabel_InpatShare == null) {
			RightJLabel_InpatShare = new LabelBase();
			RightJLabel_InpatShare.setText("Inpat % Share");
			RightJLabel_InpatShare.setBounds(20, 6, 108, 20);
		}
		return RightJLabel_InpatShare;
	}

	/**
	 * This method initializes RightJLabOutpatShareber
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_OutpatShare() {
		if (RightJLabel_OutpatShare == null) {
			RightJLabel_OutpatShare = new LabelBase();
			RightJLabel_OutpatShare.setText("Outpat % Share");
			RightJLabel_OutpatShare.setBounds(230, 6, 108, 20);
		}
		return RightJLabel_OutpatShare;
	}

	/**
	 * This method initializes RightJLabelDaycaseSharer
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_DaycaseShare() {
		if (RightJLabel_DaycaseShare == null) {
			RightJLabel_DaycaseShare = new LabelBase();
			RightJLabel_DaycaseShare.setText("Daycase % Share");
			RightJLabel_DaycaseShare.setBounds(480, 6, 117, 20);
		}
		return RightJLabel_DaycaseShare;
	}

	/**
	 * This method initializes RightJLabel_StartDate
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_StartDate() {
		if (RightJLabel_StartDate == null) {
			RightJLabel_StartDate = new LabelBase();
			RightJLabel_StartDate.setText("Admission Start Date");
			RightJLabel_StartDate.setBounds(448, 0, 125, 20);
		}
		return RightJLabel_StartDate;
	}

	/**
	 * This method initializes RightJLabel_TerminationDate
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_TerminationDate() {
		if (RightJLabel_TerminationDate == null) {
			RightJLabel_TerminationDate = new LabelBase();
			RightJLabel_TerminationDate.setText("Admission Expiry Date");
			RightJLabel_TerminationDate.setBounds(447, 25, 156, 20);
		}
		return RightJLabel_TerminationDate;
	}

	private LabelBase getRightJLabel_OPStartDate() {
		if (RightJLabel_OPStartDate == null) {
			RightJLabel_OPStartDate = new LabelBase();
			RightJLabel_OPStartDate.setText("OP Privilege Start Date");
			RightJLabel_OPStartDate.setBounds(447, 50, 156, 20);
		}
		return RightJLabel_OPStartDate;
	}

	private LabelBase getRightJLabel_OPEndDate() {
		if (RightJLabel_OPEndDate == null) {
			RightJLabel_OPEndDate = new LabelBase();
			RightJLabel_OPEndDate.setText("OP Privilege Expiry Date");
			RightJLabel_OPEndDate.setBounds(447, 75, 156, 20);
		}
		return RightJLabel_OPEndDate;
	}

	private LabelBase getRightJLabel_InsurComp() {
		if (RightJLabel_InsurComp == null) {
			RightJLabel_InsurComp = new LabelBase();
			RightJLabel_InsurComp.setText("Insurance Company");
			RightJLabel_InsurComp.setBounds(20, 125, 130, 20);
		}
		return RightJLabel_InsurComp;
	}
	
	private LabelBase getRightJLabel_HKMANo() {
		if (RightJLabel_HKMANo == null) {
			RightJLabel_HKMANo = new LabelBase();
			RightJLabel_HKMANo.setText("HKMA No.");
			RightJLabel_HKMANo.setBounds(20, 105, 60, 20);
		}
		return RightJLabel_HKMANo;
	}
	
	private LabelBase getRightJLabel_MPSNo() {
		if (RightJLabel_MPSNo == null) {
			RightJLabel_MPSNo = new LabelBase();
			RightJLabel_MPSNo.setText("MPS No.");
			RightJLabel_MPSNo.setBounds(200, 105, 60, 20);
		}
		return RightJLabel_MPSNo;
	}

	/***************************************************************************
	 * Contact Panel Method
	 **************************************************************************/

	/**
	 * This method initializes ContactJTabbedPane
	 *
	 * @return javax.swing.JTabbedPane
	 */
	private TabbedPaneBase getContactJTabbedPane() {
		if (ContactJTabbedPane == null) {
			ContactJTabbedPane = new TabbedPaneBase();
			ContactJTabbedPane.setStyleAttribute("margin-bottom", "5px");
			ContactJTabbedPane.setBounds(60, 125, 760, 150);
			ContactJTabbedPane.addTab("Doctor Contact Information", null, getRightBasePanel_Contact(), "Doctor Contact Information");
			ContactJTabbedPane.addTab("Home/Office Address", null, getRightBasePanel_HomeOfficeAddress(), "Home/Office Address");
			ContactJTabbedPane.addTab("Email Address/Fax No", null, getRightBasePanel_EmailAddressFaxNo(), "Email Address/Fax No");
		}
		return ContactJTabbedPane;
	}

	/**
	 * This method initializes RightBasePanel_Contact
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	private BasePanel getRightBasePanel_Contact() {
		if (RightBasePanel_Contact == null) {
			RightBasePanel_Contact = new BasePanel();
			RightBasePanel_Contact.setLayout(null);
			RightBasePanel_Contact.add(getRightJLabel_Address(), null);
			RightBasePanel_Contact.add(getRightJText_DocAddress1(), null);
			RightBasePanel_Contact.add(getRightJText_DocAddress2(), null);
			RightBasePanel_Contact.add(getRightJText_DocAddress3(), null);
			RightBasePanel_Contact.add(getRightJText_DocAddress4(), null);
			RightBasePanel_Contact.add(getRightJLabel_HomePhone(), null);
			RightBasePanel_Contact.add(getRightJText_HomePhone(), null);
			RightBasePanel_Contact.add(getRightJLabel_OfficePhone(), null);
			RightBasePanel_Contact.add(getRightJText_OfficePhone(), null);
			RightBasePanel_Contact.add(getRightJLabel_Pager(), null);
			RightBasePanel_Contact.add(getRightJText_Pager(), null);
			RightBasePanel_Contact.add(getRightJLabel_MobilePhone(), null);
			RightBasePanel_Contact.add(getRightJText_MobilePhone(), null);
			RightBasePanel_Contact.add(getRightJLabel_PrintAddress(), null);
			RightBasePanel_Contact.add(getRightJCombo_PrintAddress(), null);
			RightBasePanel_Contact.add(getRightJLabel_Company(), null);
			RightBasePanel_Contact.add(getRightJText_Company(), null);
		}
		return RightBasePanel_Contact;
	}

	/**
	 * This method initializes RightJLabel_Address
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_Address() {
		if (RightJLabel_Address == null) {
			RightJLabel_Address = new LabelBase();
			RightJLabel_Address.setText("Address");
			RightJLabel_Address.setBounds(10, 4, 46, 20);
		}
		return RightJLabel_Address;
	}

	/**
	 * This method initializes RightJText_DocAddress1
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_DocAddress1() {
		if (RightJText_DocAddress1 == null) {
			RightJText_DocAddress1 = new TextString();
//			getListTable(), 13);
			RightJText_DocAddress1.setBounds(70, 3, 195, 20);
		}
		return RightJText_DocAddress1;
	}

	/**
	 * This method initializes RightJText_DocAddress2
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_DocAddress2() {
		if (RightJText_DocAddress2 == null) {
			RightJText_DocAddress2 = new TextString();
//			getListTable(), 14);
			RightJText_DocAddress2.setBounds(70, 30, 195, 20);

		}
		return RightJText_DocAddress2;
	}

	/**
	 * This method initializes RightJText_DocAddress3
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_DocAddress3() {
		if (RightJText_DocAddress3 == null) {
			RightJText_DocAddress3 = new TextString();
//			getListTable(), 15);
			RightJText_DocAddress3.setBounds(70, 60, 195, 20);
		}
		return RightJText_DocAddress3;
	}

	/**
	 * This method initializes RightJText_DocAddress4
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_DocAddress4() {
		if (RightJText_DocAddress4 == null) {
			RightJText_DocAddress4 = new TextString();
//			getListTable(), 34);
			RightJText_DocAddress4.setBounds(70, 90, 195, 20);
		}
		return RightJText_DocAddress4;
	}

	/**
	 * This method initializes RightJLabel_HomePhone
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_HomePhone() {
		if (RightJLabel_HomePhone == null) {
			RightJLabel_HomePhone = new LabelBase();
			RightJLabel_HomePhone.setText("Home Phone");
			RightJLabel_HomePhone.setBounds(290, 3, 100, 20);
		}
		return RightJLabel_HomePhone;
	}

	/**
	 * This method initializes RightJText_HomePhone
	 *
	 * @return com.hkah.client.layout.textfield.TextPhone
	 */
	private TextPhone getRightJText_HomePhone() {
		if (RightJText_HomePhone == null) {
			RightJText_HomePhone = new TextPhone();
//			{
//				public void onReleased() {
//					setCurrentTable(16, RightJText_HomePhone.getText());
//				}
//				public void onClick() {
//					setCurrentTable(16, RightJText_HomePhone.getText());
//				}
//			};
			RightJText_HomePhone.setBounds(390, 3, 130, 20);
		}
		return RightJText_HomePhone;
	}

	/**
	 * This method initializes RightJLabel_OfficePhone
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_OfficePhone() {
		if (RightJLabel_OfficePhone == null) {
			RightJLabel_OfficePhone = new LabelBase();
			RightJLabel_OfficePhone.setText("Office Phone");
			RightJLabel_OfficePhone.setBounds(290, 30, 100, 20);
		}
		return RightJLabel_OfficePhone;
	}

	/**
	 * This method initializes RightJText_OfficePhone
	 *
	 * @return com.hkah.client.layout.textfield.TextPhone
	 */
	private TextPhone getRightJText_OfficePhone() {
		if (RightJText_OfficePhone == null) {
			RightJText_OfficePhone = new TextPhone();
//			{
//				public void onReleased() {
//					setCurrentTable(17, RightJText_OfficePhone.getText());
//				}
//			};
			RightJText_OfficePhone.setBounds(390, 30, 130, 20);
		}
		return RightJText_OfficePhone;
	}

	/**
	 * This method initializes RightJLabel_Pager
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_Pager() {
		if (RightJLabel_Pager == null) {
			RightJLabel_Pager = new LabelBase();
			RightJLabel_Pager.setText("Pager");
			RightJLabel_Pager.setBounds(290, 60, 100, 20);
		}
		return RightJLabel_Pager;
	}

	/**
	 * This method initializes RightJText_Pager
	 *
	 * @return com.hkah.client.layout.textfield.TextPhone
	 */
	private TextPhone getRightJText_Pager() {
		if (RightJText_Pager == null) {
			RightJText_Pager = new TextPhone();
//			{
//				public void onReleased() {
//					setCurrentTable(18,RightJText_Pager.getText());
//				}
//			};
			RightJText_Pager.setBounds(390, 60, 130, 20);
		}
		return RightJText_Pager;
	}

	/**
	 * This method initializes RightJLabel_MobilePhone
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_MobilePhone() {
		if (RightJLabel_MobilePhone == null) {
			RightJLabel_MobilePhone = new LabelBase();
			RightJLabel_MobilePhone.setText("Mobile Phone");
			RightJLabel_MobilePhone.setBounds(290, 90, 100, 20);
		}
		return RightJLabel_MobilePhone;
	}

	/**
	 * This method initializes RightJText_MobilePhone
	 *
	 * @return com.hkah.client.layout.textfield.TextPhone
	 */
	private TextPhone getRightJText_MobilePhone() {
		if (RightJText_MobilePhone == null) {
			RightJText_MobilePhone = new TextPhone();
//			{
//				public void onReleased() {
//					setCurrentTable(30, RightJText_MobilePhone.getText());
//				}
//			};
			RightJText_MobilePhone.setBounds(390, 90, 130, 20);
		}
		return RightJText_MobilePhone;
	}

	/**
	 * This method initializes RightJLabel_PrintAddress
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_PrintAddress() {
		if (RightJLabel_PrintAddress == null) {
			RightJLabel_PrintAddress = new LabelBase();
			RightJLabel_PrintAddress.setText("Print Address");
			RightJLabel_PrintAddress.setBounds(550, 3, 90, 20);
		}
		return RightJLabel_PrintAddress;
	}

	/**
	 * This method initializes RightJCombo_PrintAddress
	 *
	 * @return com.hkah.client.layout.combobox.ComboPrintAddress
	 */
	private ComboPrintAddress getRightJCombo_PrintAddress() {
		if (RightJCombo_PrintAddress == null) {
			RightJCombo_PrintAddress = new ComboPrintAddress();
//			{
//				public void onClick() {
//					setCurrentTable(39,RightJCombo_PrintAddress.getText());
//				}
//			};
			RightJCombo_PrintAddress.setBounds(633, 3, 118, 20);
		}
		return RightJCombo_PrintAddress;
	}

	private LabelBase getRightJLabel_Company() {
		if (RightJLabel_Company == null) {
			RightJLabel_Company = new LabelBase();
			RightJLabel_Company.setText("Company");
			RightJLabel_Company.setBounds(550, 30, 90, 20);
		}
		return RightJLabel_Company;
	}

	private TextString getRightJText_Company() {
		if (RightJText_Company == null) {
			RightJText_Company = new TextString();
			RightJText_Company.setBounds(633, 30, 118, 20);
		}
		return RightJText_Company;
	}

	/**
	 * This method initializes RightBasePanel_Contact
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	private BasePanel getRightBasePanel_HomeOfficeAddress() {
		if (RightBasePanel_HomeOfficeAddress == null) {
			RightBasePanel_HomeOfficeAddress = new BasePanel();
			RightBasePanel_HomeOfficeAddress.setLayout(null);
			RightBasePanel_HomeOfficeAddress.add(getRightJLabel_HomeAddress(), null);
			RightBasePanel_HomeOfficeAddress.add(getRightJText_HomeAddress(), null);
			RightBasePanel_HomeOfficeAddress.add(getRightJText_HomeAddress2(), null);
			RightBasePanel_HomeOfficeAddress.add(getRightJText_HomeAddress3(), null);
			RightBasePanel_HomeOfficeAddress.add(getRightJText_HomeAddress4(), null);
			RightBasePanel_HomeOfficeAddress.add(getRightJLabel_OfficeAddress(), null);
			RightBasePanel_HomeOfficeAddress.add(getRightJText_OfficeAddress1(), null);
			RightBasePanel_HomeOfficeAddress.add(getRightJText_OfficeAddress2(), null);
			RightBasePanel_HomeOfficeAddress.add(getRightJText_OfficeAddress3(), null);
			RightBasePanel_HomeOfficeAddress.add(getRightJText_OfficeAddress4(), null);
		}
		return RightBasePanel_HomeOfficeAddress;
	}

	/**
	 * This method initializes RightJLabel_HomeAddress
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_HomeAddress() {
		if (RightJLabel_HomeAddress == null) {
			RightJLabel_HomeAddress = new LabelBase();
			RightJLabel_HomeAddress.setText("Home Address");
			RightJLabel_HomeAddress.setBounds(45, 10, 94, 20);
		}
		return RightJLabel_HomeAddress;
	}

	/**
	 * This method initializes RightJText_HomeAddress
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_HomeAddress() {
		if (RightJText_HomeAddress == null) {
			RightJText_HomeAddress = new TextString();
//			{
//				public void onReleased() {
//					setCurrentTable(23,RightJText_HomeAddress.getText());
//				}
//			};
			RightJText_HomeAddress.setBounds(181,10, 175, 20);
		}
		return RightJText_HomeAddress;
	}

	/**
	 * This method initializes RightJText_HomeAddress2
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_HomeAddress2() {
		if (RightJText_HomeAddress2 == null) {
			RightJText_HomeAddress2 = new TextString();
//			{
//				public void onReleased() {
//					setCurrentTable(24, RightJText_HomeAddress2.getText());
//				}
//			};
			RightJText_HomeAddress2.setBounds(181, 34, 175, 20);
		}
		return RightJText_HomeAddress2;
	}

	/**
	 * This method initializes RightJText_HomeAddress3
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_HomeAddress3() {
		if (RightJText_HomeAddress3 == null) {
			RightJText_HomeAddress3 = new TextString();
//			{
//				public void onReleased() {
//					setCurrentTable(25,RightJText_HomeAddress3.getText());
//				}
//			};
			RightJText_HomeAddress3.setBounds(181, 60, 175, 20);
		}
		return RightJText_HomeAddress3;
	}

	/**
	 * This method initializes RightJText_HomeAddress4
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_HomeAddress4() {
		if (RightJText_HomeAddress4 == null) {
			RightJText_HomeAddress4 = new TextString();
//			{
//				public void onReleased() {
//					setCurrentTable(33,RightJText_HomeAddress4.getText());
//				}
//			};
			RightJText_HomeAddress4.setBounds(181, 90, 175, 20);
		}
		return RightJText_HomeAddress4;
	}

	/**
	 * This method initializes RightJLabel_OfficeAddress
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_OfficeAddress() {
		if (RightJLabel_OfficeAddress == null) {
			RightJLabel_OfficeAddress = new LabelBase();
			RightJLabel_OfficeAddress.setText("Office Address");
			RightJLabel_OfficeAddress.setBounds(420,10, 99, 20);
		}
		return RightJLabel_OfficeAddress;
	}

	/**
	 * This method initializes RightJText_OfficeAddress1
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_OfficeAddress1() {
		if (RightJText_OfficeAddress1 == null) {
			RightJText_OfficeAddress1 = new TextString();
//			{
//				public void onReleased() {
//					setCurrentTable(26,RightJText_OfficeAddress1.getText());
//				}
//			};
			RightJText_OfficeAddress1.setBounds(556, 10, 183, 20);
		}
		return RightJText_OfficeAddress1;
	}

	/**
	 * This method initializes RightJText_OfficeAddress2
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_OfficeAddress2() {
		if (RightJText_OfficeAddress2 == null) {
			RightJText_OfficeAddress2 = new TextString();
//			getListTable(), 27);
			RightJText_OfficeAddress2.setBounds(556, 35, 183, 20);
		}
		return RightJText_OfficeAddress2;
	}

	/**
	 * This method initializes RightJText_OfficeAddress3
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_OfficeAddress3() {
		if (RightJText_OfficeAddress3 == null) {
			RightJText_OfficeAddress3 = new TextString();
//			getListTable(), 28);
			RightJText_OfficeAddress3.setBounds(556, 60, 183, 20);
		}
		return RightJText_OfficeAddress3;
	}

	/**
	 * This method initializes RightJText_OfficeAddress4
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_OfficeAddress4() {
		if (RightJText_OfficeAddress4 == null) {
			RightJText_OfficeAddress4 = new TextString();
//			getListTable(), 35);
			RightJText_OfficeAddress4.setBounds(556, 90, 183, 20);
		}
		return RightJText_OfficeAddress4;
	}

	/**
	 * This method initializes RightBasePanel_EmailAddressFaxNo
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	private BasePanel getRightBasePanel_EmailAddressFaxNo() {
		if (RightBasePanel_EmailAddressFaxNo == null) {
			RightBasePanel_EmailAddressFaxNo = new BasePanel();
			RightBasePanel_EmailAddressFaxNo.setLayout(null);
			RightBasePanel_EmailAddressFaxNo.add(getRightJLabel_EmailAddress(), null);
			RightBasePanel_EmailAddressFaxNo.add(getRightJText_EmailAddress(), null);
			RightBasePanel_EmailAddressFaxNo.add(getRightJLabel_FaxNumber(), null);
			RightBasePanel_EmailAddressFaxNo.add(getRightJText_FaxNumber(), null);
			RightBasePanel_EmailAddressFaxNo.add(getRightJLabel_ReceivePromo(), null);
			RightBasePanel_EmailAddressFaxNo.add(getRightJCheck_ReceivePromo(), null);
			RightBasePanel_EmailAddressFaxNo.add(getRightJLabel_ReceivePromoByFax(), null);
			RightBasePanel_EmailAddressFaxNo.add(getRightJCheck_ReceivePromoByFax(), null);
		}
		return RightBasePanel_EmailAddressFaxNo;
	}

	/**
	 * This method initializes RightJLabel_EmailAddress
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_EmailAddress() {
		if (RightJLabel_EmailAddress == null) {
			RightJLabel_EmailAddress = new LabelBase();
			RightJLabel_EmailAddress.setText("Email Address");
			RightJLabel_EmailAddress.setBounds(41, 25, 100,20);
		}
		return RightJLabel_EmailAddress;
	}

	/**
	 * This method initializes RightJText_EmailAddress
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_EmailAddress() {
		if (RightJText_EmailAddress == null) {
			RightJText_EmailAddress = new TextString();
//			getListTable(), 31);
			RightJText_EmailAddress.setBounds(172, 25, 320, 20);
		}
		return RightJText_EmailAddress;
	}

	/**
	 * This method initializes RightJLabel_FaxNumber
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_FaxNumber() {
		if (RightJLabel_FaxNumber == null) {
			RightJLabel_FaxNumber = new LabelBase();
			RightJLabel_FaxNumber.setText("Fax Number");
			RightJLabel_FaxNumber.setBounds(41, 50, 100, 20);
		}
		return RightJLabel_FaxNumber;
	}

	/**
	 * This method initializes RightJText_FaxNumber
	 *
	 * @return com.hkah.client.layout.textfield.TextPhone
	 */
	private TextPhone getRightJText_FaxNumber() {
		if (RightJText_FaxNumber == null) {
			RightJText_FaxNumber = new TextPhone();
//			getListTable(), 32);
			RightJText_FaxNumber.setBounds(172, 50, 104,20);
		}
		return RightJText_FaxNumber;
	}

	private LabelBase getRightJLabel_ReceivePromo() {
		if (RightJLabel_ReceivePromo == null) {
			RightJLabel_ReceivePromo = new LabelBase();
			RightJLabel_ReceivePromo.setText("Receive promo material");
			RightJLabel_ReceivePromo.setBounds(55, 75, 150,20);
		}
		return RightJLabel_ReceivePromo;
	}

	private CheckBoxBase getRightJCheck_ReceivePromo() {
		if (RightJCheck_ReceivePromo == null) {
			RightJCheck_ReceivePromo = new CheckBoxBase() {
				public void onClick() {
					if (!RightJCheck_ReceivePromo.isReadOnly()) {
						if (!RightJCheck_ReceivePromo.isSelected()) {
							RightJCheck_ReceivePromo.setSelected(false);
							RightJCheck_ReceivePromoByFax.setSelected(false);
						}
					}
				}
			};
			RightJCheck_ReceivePromo.setBounds(32, 72, 25, 25);
		}
		return RightJCheck_ReceivePromo;
	}

	private LabelBase getRightJLabel_ReceivePromoByFax() {
		if (RightJLabel_ReceivePromoByFax == null) {
			RightJLabel_ReceivePromoByFax = new LabelBase();
			RightJLabel_ReceivePromoByFax.setText("(&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;by fax)");
			RightJLabel_ReceivePromoByFax.setBounds(192, 75, 150, 20);
		}
		return RightJLabel_ReceivePromoByFax;
	}

	private CheckBoxBase getRightJCheck_ReceivePromoByFax() {
		if (RightJCheck_ReceivePromoByFax == null) {
			RightJCheck_ReceivePromoByFax = new CheckBoxBase() {
				public void onClick() {
					if (!RightJCheck_ReceivePromoByFax.isReadOnly()) {
						if (RightJCheck_ReceivePromoByFax.isSelected()) {
							RightJCheck_ReceivePromoByFax.setSelected(true);
							RightJCheck_ReceivePromo.setSelected(true);
						}
					}
				}
			};
			RightJCheck_ReceivePromoByFax.setBounds(193, 72, 25, 25);
		};
		return RightJCheck_ReceivePromoByFax;
	}

	/***************************************************************************
	 * Detail Panel Method
	 **************************************************************************/

	/**
	 * This method initializes DetailJTabbedPane
	 *
	 * @return javax.swing.JTabbedPane
	 */
	private TabbedPaneBase getDetailJTabbedPane() {
		if (DetailJTabbedPane == null) {
			DetailJTabbedPane = new TabbedPaneBase() {
				public void onStateChange() {
					if (!viewedTab.contains(Integer.toString(DetailJTabbedPane.getSelectedIndex()))) {
						viewedTab.add(Integer.toString(DetailJTabbedPane.getSelectedIndex()));
					}
				}
			};
			DetailJTabbedPane.setBounds(5, 320, 815, 180);
//			DetailJTabbedPane.setStyleAttribute("margin-bottom", "5px");
			DetailJTabbedPane.addTab("General Info.", null, getRightBasePanel_General(), "GeneralInformation");
			DetailJTabbedPane.addTab("Privilege", null, getRightBasePanel_Privilege(), "Privilege");
			DetailJTabbedPane.addTab("Department", null, getRightBasePanel_Department(), "Department");
			DetailJTabbedPane.addTab("Specialty", null, getRightBasePanel_Specialty(), "Speciality");
			DetailJTabbedPane.addTab("Qualification", null, getRightBasePanel_Qualification(), "Qualification");
			DetailJTabbedPane.addTab("Cert.(Eng)", null, getRightBasePanel_CertEng(), "Cert.(Eng)");
			DetailJTabbedPane.addTab("Cert.(Chi)", null, getRightBasePanel_CertChi(), "Cert.(Chi)");
			DetailJTabbedPane.addTab("Basic Salary", null, getRightBasePanel_BasicSalary(), "BasicSalary");
			DetailJTabbedPane.addTab("IOD % Share History", null, getRightBasePanel_ConShare(), "ConShare");
			DetailJTabbedPane.addTab("Item % Share", null, getRightBasePanel_ItemShare(), "ItemShare");
			DetailJTabbedPane.addTab("Item % Share History", null, getRightBasePanel_ItemShareHist(), "ItemShareHist");
			DetailJTabbedPane.addTab("Approval", null, getRightBasePanel_Approval(), "Approval");
			DetailJTabbedPane.addTab("Ref Date", null, getRightBasePanel_RefDate(), "Ref Date");
			DetailJTabbedPane.addTab("Class", null, getRightBasePanel_Class(), "Class");
//			DetailJTabbedPane.setMinTabWidth(115);
//			DetailJTabbedPane.setResizeTabs(true);
//			DetailJTabbedPane.setAnimScroll(true);
			DetailJTabbedPane.setTabScroll(true);
		}
		return DetailJTabbedPane;
	}

	/**
	 * This method initializes RightBasePanel_General
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	private BasePanel getRightBasePanel_General() {
		if (RightBasePanel_General == null) {
			RightBasePanel_General = new BasePanel();
			RightBasePanel_General.setHeight(175);
//			RightBasePanel_General.setStyleAttribute("background-color", "blue");
//			RightBasePanel_General.setLayout(null);
			RightBasePanel_General.add(getRightJLabel_SpecialityCode(), null);
			RightBasePanel_General.add(getRightJText_SpecialityCode(), null);
			RightBasePanel_General.add(getRightJLabel_QualificationDesc(), null);
			RightBasePanel_General.add(getRightJText_QualificationDesc(), null);
			RightBasePanel_General.add(getRightJLabel_TimeSlotDuration(), null);
			RightBasePanel_General.add(getRightJText_TimeSlotDuration(), null);
			RightBasePanel_General.add(getRightJLabel_Minutes(), null);
			RightBasePanel_General.add(getRightJLabel_BRNo(), null);
			RightBasePanel_General.add(getRightJText_BRNo(), null);
			RightBasePanel_General.add(getRightJCheck_DeclarationOfSTO(), null);
			RightBasePanel_General.add(getRightJLabel_DeclarationOfSTO(), null);

			RightBasePanel_General.add(getRightJLabel_Active(), null);
			RightBasePanel_General.add(getRightJCheck_Active(), null);
			RightBasePanel_General.add(getRightJLabel_CompleteOfQualification(), null);
			RightBasePanel_General.add(getRightJCheck_CompleteOfQualification(), null);
			RightBasePanel_General.add(getRightJLabel_Picklist(), null);
			RightBasePanel_General.add(getRightJCheck_Picklist(), null);
			RightBasePanel_General.add(getRightJLabel_IsDoctor(), null);
			RightBasePanel_General.add(getRightJCheck_IsDoctor(), null);
			RightBasePanel_General.add(getRightJLabel_IsEndoscopist(), null);
			RightBasePanel_General.add(getRightJCheck_IsEndoscopist(), null);

			RightBasePanel_General.add(getRightJLabel_CashOnly(), null);
			RightBasePanel_General.add(getRightJCheck_CashOnly(), null);
			RightBasePanel_General.add(getRightJLabel_IsOTSurgeon(), null);
			RightBasePanel_General.add(getRightJCheck_IsOTSurgeon(), null);
			RightBasePanel_General.add(getRightJLabel_IsOTAnesthetist(), null);
			RightBasePanel_General.add(getRightJCheck_IsOTAnesthetist(), null);
			RightBasePanel_General.add(getRightJLabel_DoctorProfile(), null);
			RightBasePanel_General.add(getRightJCheck_DoctorProfile(), null);
			RightBasePanel_General.add(getRightJLabel_IsPostSchedule(), null);
			RightBasePanel_General.add(getRightJCheck_IsPostSchedule(), null);

			RightBasePanel_General.add(getRightJLabel_Remarks(), null);
			RightBasePanel_General.add(getRightJText_Remarks(), null);
		}
		return RightBasePanel_General;
	}

	/**
	 * This method initializes RightJLabel_SpecialityCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_SpecialityCode() {
		if (RightJLabel_SpecialityCode == null) {
			RightJLabel_SpecialityCode = new LabelBase();
			RightJLabel_SpecialityCode.setText("Speciality Code");
			RightJLabel_SpecialityCode.setBounds(45, 5, 109, 20);
		}
		return RightJLabel_SpecialityCode;
	}

	/**
	 * This method initializes RightJText_SpecialityCode
	 *
	 * @return com.hkah.client.layout.textfield.TextBase
	 */
	private ComboSpecialtyCode getRightJText_SpecialityCode() {
		if (RightJText_SpecialityCode == null) {
			RightJText_SpecialityCode = new ComboSpecialtyCode();
//			{
//				public void onClick() {
//					setCurrentTable(7,RightJText_SpecialityCode.getText());
//				}
//			};
			RightJText_SpecialityCode.setBounds(181, 5, 244, 20);
		}
		return RightJText_SpecialityCode;
	}

	/**
	 * This method initializes RightJLabel_QualificationDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_QualificationDesc() {
		if (RightJLabel_QualificationDesc == null) {
			RightJLabel_QualificationDesc = new LabelBase();
			RightJLabel_QualificationDesc.setText("Qualification Desc.");
			RightJLabel_QualificationDesc.setBounds(428, 5, 147, 20);
		}
		return RightJLabel_QualificationDesc;
	}

	/**
	 * This method initializes RightJText_QualificationDesc
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_QualificationDesc() {
		if (RightJText_QualificationDesc == null) {
			RightJText_QualificationDesc = new TextString();
//			getListTable(), 20);
			RightJText_QualificationDesc.setBounds(590, 5, 149, 20);
		}
		return RightJText_QualificationDesc;
	}

	/**
	 * This method initializes RightJLabel_TimeSlotDuration
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_TimeSlotDuration() {
		if (RightJLabel_TimeSlotDuration == null) {
			RightJLabel_TimeSlotDuration = new LabelBase();
			RightJLabel_TimeSlotDuration.setText("Time Slot Duration");
			RightJLabel_TimeSlotDuration.setBounds(45, 30, 123, 20);
		}
		return RightJLabel_TimeSlotDuration;
	}

	/**
	 * This method initializes RightJTex_TimeSlotDuration
	 *
	 * @return com.hkah.client.layout.textfield.TextNum
	 */
	private TextNum getRightJText_TimeSlotDuration() {
		if (RightJTex_TimeSlotDuration == null) {
			RightJTex_TimeSlotDuration = new TextNum();
//			{
//				public void onReleased() {
//					setCurrentTable(19,RightJTex_TimeSlotDuration.getText());
//				}
//			};
			RightJTex_TimeSlotDuration.setBounds(181, 30, 98, 20);
		}
		return RightJTex_TimeSlotDuration;
	}

	/**
	 * This method initializes RightJLabel_Minutes
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_Minutes() {
		if (RightJLabel_Minutes == null) {
			RightJLabel_Minutes = new LabelBase();
			RightJLabel_Minutes.setBounds(293, 30, 75, 20);
			RightJLabel_Minutes.setText("minute(s)");
		}
		return RightJLabel_Minutes;
	}

	private LabelBase getRightJLabel_BRNo() {
		if (RightJLabel_BRNo == null) {
			RightJLabel_BRNo = new LabelBase();
			RightJLabel_BRNo.setText("BR NO.");
			RightJLabel_BRNo.setBounds(45, 55, 109, 20);
		}
		return RightJLabel_BRNo;
	}

	private TextString getRightJText_BRNo() {
		if (RightJText_BRNo == null) {
			RightJText_BRNo = new TextString();
//			{
//				public void onClick() {
//					setCurrentTable(7,RightJText_BRNo.getText());
//				}
//			};
			RightJText_BRNo.setBounds(181, 55, 244, 20);
		}
		return RightJText_BRNo;
	}
	
	private CheckBoxBase getRightJCheck_DeclarationOfSTO() {
		if (RightJCheck_DeclarationOfSTO == null) {
			RightJCheck_DeclarationOfSTO = new CheckBoxBase();
			RightJCheck_DeclarationOfSTO.setAutoValidate(true);
			RightJCheck_DeclarationOfSTO.setBounds(450, 55, 20, 20);
		}
		return RightJCheck_DeclarationOfSTO;
	}
	
	private LabelBase getRightJLabel_DeclarationOfSTO() {
		if (RightJLabel_DeclarationOfSTO == null) {
			RightJLabel_DeclarationOfSTO = new LabelBase();
			RightJLabel_DeclarationOfSTO.setText("Declaration of Secured Text Order via cell phone usage");
			RightJLabel_DeclarationOfSTO.setBounds(480, 55, 350, 20);
		}
		return RightJLabel_DeclarationOfSTO;
	}

	/**
	 * This method initializes RightJLabel_Active
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_Active() {
		if (RightJLabel_Active == null) {
			RightJLabel_Active = new LabelBase();
			RightJLabel_Active.setText("Active");
			RightJLabel_Active.setBounds(45, 80, 100, 20);
		}
		return RightJLabel_Active;
	}

	/**
	 * This method initializes RightJCheckBox_Active
	 *
	 * @return com.hkah.client.layout.checkbox.CheckBoxBase
	 */
	private CheckBoxBase getRightJCheck_Active() {
		if (RightJCheck_Active == null) {
			RightJCheck_Active = new CheckBoxBase();
//			{
//				public void onClick() {
//					if (RightJCheck_Active.isSelected()) {
//						setCurrentTable(8, "Y");
//					} else {
//						setCurrentTable(8, "N");
//					}
//				}
//			};
			RightJCheck_Active.setAutoValidate(true);
			RightJCheck_Active.setBounds(115, 80, 20, 20);
		}
		return RightJCheck_Active;
	}

	/**
	 * This method initializes RightJLabel_CompleteOfQualification
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_CompleteOfQualification() {
		if (RightJLabel_CompleteOfQualification == null) {
			RightJLabel_CompleteOfQualification = new LabelBase();
			RightJLabel_CompleteOfQualification.setText("Complete Of Qualification");
			RightJLabel_CompleteOfQualification.setBounds(170, 80, 153, 20);
		}
		return RightJLabel_CompleteOfQualification;
	}

	/**
	 * This method initializes RightJCheck_CompleteOfQualification
	 *
	 * @return com.hkah.client.layout.checkbox.CheckBoxBase
	 */
	private CheckBoxBase getRightJCheck_CompleteOfQualification() {
		if (RightJCheck_CompleteOfQualification == null) {
			RightJCheck_CompleteOfQualification = new CheckBoxBase();
//			{
//				public void onClick() {
//					if (RightJCheck_CompleteOfQualification.isSelected()) {
//						setCurrentTable(37, "Y");
//					} else {
//						setCurrentTable(37, "N");
//					}
//				}
//			};
			RightJCheck_CompleteOfQualification.setBounds(320, 80, 25, 25);
		}
		return RightJCheck_CompleteOfQualification;
	}

	/**
	 * This method initializes RightJLabel_Picklist
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_Picklist() {
		if (RightJLabel_Picklist == null) {
			RightJLabel_Picklist = new LabelBase();
			RightJLabel_Picklist.setText("Picklist");
			RightJLabel_Picklist.setBounds(380, 80, 56, 20);
		}
		return RightJLabel_Picklist;
	}

	/**
	 * This method initializes RightJCheck_Picklist
	 *
	 * @return com.hkah.client.layout.checkbox.CheckBoxBase
	 */
	private CheckBoxBase getRightJCheck_Picklist() {
		if (RightJCheck_Picklist == null) {
			RightJCheck_Picklist = new CheckBoxBase();
//			{
//				public void onClick() {
//					if (RightJCheck_Picklist.isSelected()) {
//						setCurrentTable(36, "Y");
//					} else {
//						setCurrentTable(36, "N");
//					}
//				}
//			};
			RightJCheck_Picklist.setBounds(483, 80, 25, 25);
		}
		return RightJCheck_Picklist;
	}

	/**
	 * This method initializes RightJLabel_IsDoctor
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_IsDoctor() {
		if (RightJLabel_IsDoctor == null) {
			RightJLabel_IsDoctor = new LabelBase();
			RightJLabel_IsDoctor.setText("IsDoctor");
			RightJLabel_IsDoctor.setBounds(520, 80, 66, 20);
		}
		return RightJLabel_IsDoctor;
	}

	/**
	 * This method initializes RightJCheck_IsDoctor
	 *
	 * @return com.hkah.client.layout.checkbox.CheckBoxBase
	 */
	private CheckBoxBase getRightJCheck_IsDoctor() {
		if (RightJCheck_IsDoctor == null) {
			RightJCheck_IsDoctor = new CheckBoxBase();
//			{
//				public void onClick() {
//					if (RightJCheck_IsDoctor.isSelected()) {
//						setCurrentTable(40, "Y");
//					} else {
//						setCurrentTable(40, "N");
//					}
//				}
//			};
			RightJCheck_IsDoctor.setBounds(600, 80, 25, 25);
		}
		return RightJCheck_IsDoctor;
	}

	private LabelBase getRightJLabel_IsEndoscopist() {
		if (RightJLabel_IsEndoscopist == null) {
			RightJLabel_IsEndoscopist = new LabelBase();
			RightJLabel_IsEndoscopist.setText("Is Endoscopist");
			RightJLabel_IsEndoscopist.setBounds(630, 80, 96, 20);
		}
		return RightJLabel_IsEndoscopist;
	}

	private CheckBoxBase getRightJCheck_IsEndoscopist() {
		if (RightJCheck_IsEndescopist == null) {
			RightJCheck_IsEndescopist = new CheckBoxBase();
//			{
//				public void onClick() {
//					if (RightJCheck_IsEndescopist.isSelected()) {
//						setCurrentTable(40, "Y");
//					} else {
//						setCurrentTable(40, "N");
//					}
//				}
//			};
			RightJCheck_IsEndescopist.setBounds(730, 80, 25, 25);
		}
		return RightJCheck_IsEndescopist;
	}

	/**
	 * This method initializes RightJLabel_CashOnly
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_CashOnly() {
		if (RightJLabel_CashOnly == null) {
			RightJLabel_CashOnly = new LabelBase();
			RightJLabel_CashOnly.setText("Cash Only");
			RightJLabel_CashOnly.setBounds(45, 100, 100, 20);
		}
		return RightJLabel_CashOnly;
	}

	/**
	 * This method initializes RightJCheck_CashOnly
	 *
	 * @return com.hkah.client.layout.checkbox.CheckBoxBase
	 */
	private CheckBoxBase getRightJCheck_CashOnly() {
		if (RightJCheck_CashOnly == null) {
			RightJCheck_CashOnly = new CheckBoxBase();
//			{
//				public void onClick() {
//					if (RightJCheck_CashOnly.isSelected()) {
//						setCurrentTable(29, "Y");
//					} else {
//						setCurrentTable(29, "N");
//					}
//				}
//			};
			RightJCheck_CashOnly.setBounds(115, 100, 20, 28);
		}
		return RightJCheck_CashOnly;
	}

	/**
	 * This method initializes RightJLabel_IsOTSurgeon
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_IsOTSurgeon() {
		if (RightJLabel_IsOTSurgeon == null) {
			RightJLabel_IsOTSurgeon = new LabelBase();
			RightJLabel_IsOTSurgeon.setText("Is OT Surgeon");
			RightJLabel_IsOTSurgeon.setBounds(170, 100, 100, 20);
		}
		return RightJLabel_IsOTSurgeon;
	}

	/**
	 * This method initializes RightJCheck_IsOTSurgeon
	 *
	 * @return com.hkah.client.layout.checkbox.CheckBoxBase
	 */
	private CheckBoxBase getRightJCheck_IsOTSurgeon() {
		if (RightJCheck_IsOTSurgeon == null) {
			RightJCheck_IsOTSurgeon = new CheckBoxBase();
//			{
//				public void onClick() {
//					if (RightJCheck_IsOTSurgeon.isSelected()) {
//						setCurrentTable(42, "Y");
//					} else {
//						setCurrentTable(42, "N");
//					}
//				}
//			};
			RightJCheck_IsOTSurgeon.setBounds(323, 100, 20, 28);
		}
		return RightJCheck_IsOTSurgeon;
	}

	/**
	 * This method initializes RightJLabel_IsOTAnesthetist
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_IsOTAnesthetist() {
		if (RightJLabel_IsOTAnesthetist == null) {
			RightJLabel_IsOTAnesthetist = new LabelBase();
			RightJLabel_IsOTAnesthetist.setText("Is OT Anesthetist");
			RightJLabel_IsOTAnesthetist.setBounds(380, 100, 117, 20);
		}
		return RightJLabel_IsOTAnesthetist;
	}

	/**
	 * This method initializes RightJCheck_IsOTAnesthetist
	 *
	 * @return com.hkah.client.layout.checkbox.CheckBoxBase
	 */
	private CheckBoxBase getRightJCheck_IsOTAnesthetist() {
		if (RightJCheck_IsOTAnesthetist == null) {
			RightJCheck_IsOTAnesthetist = new CheckBoxBase();
//			{
//				public void onClick() {
//					if (RightJCheck_IsOTAnesthetist.isSelected()) {
//						setCurrentTable(43, "Y");
//					} else {
//						setCurrentTable(43, "N");
//					}
//				}
//			};
			RightJCheck_IsOTAnesthetist.setBounds(483, 100, 25, 25);
		}
		return RightJCheck_IsOTAnesthetist;
	}

	/**
	 * This method initializes RightJLabel_DoctorProfile
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_DoctorProfile() {
		if (RightJLabel_DoctorProfile == null) {
			RightJLabel_DoctorProfile = new LabelBase();
			RightJLabel_DoctorProfile.setText("Doctor Profile");
			RightJLabel_DoctorProfile.setBounds(520, 100, 92, 20);
		}
		return RightJLabel_DoctorProfile;
	}

	/**
	 * This method initializes RightJCheck_DoctorProfile
	 *
	 * @return com.hkah.client.layout.checkbox.CheckBoxBase
	 */
	private CheckBoxBase getRightJCheck_DoctorProfile() {
		if (RightJCheck_DoctorProfile == null) {
			RightJCheck_DoctorProfile = new CheckBoxBase();
//			{
//				public void onClick() {
//					if (RightJCheck_DoctorProfile.isSelected()) {
//						setCurrentTable(44, "Y");
//					} else {
//						setCurrentTable(44, "N");
//					}
//				}
//			};
			RightJCheck_DoctorProfile.setBounds(600, 100, 25, 25);
		}
		return RightJCheck_DoctorProfile;
	}

	private LabelBase getRightJLabel_IsPostSchedule() {
		if (RightJLabel_IsPostSchedule == null) {
			RightJLabel_IsPostSchedule = new LabelBase();
			RightJLabel_IsPostSchedule.setText("Is Post Schedule");
			RightJLabel_IsPostSchedule.setBounds(630, 100, 105, 20);
		}
		return RightJLabel_IsPostSchedule;
	}


	private CheckBoxBase getRightJCheck_IsPostSchedule() {
		if (RightJCheck_IsPostSchedule == null) {
			RightJCheck_IsPostSchedule = new CheckBoxBase();
//			{
//				public void onClick() {
//					if (RightJCheck_IsOTAnesthetist.isSelected()) {
//						setCurrentTable(43, "Y");
//					} else {
//						setCurrentTable(43, "N");
//					}
//				}
//			};
			RightJCheck_IsPostSchedule.setBounds(730, 100, 25, 25);
		}
		return RightJCheck_IsPostSchedule;
	}

	private LabelBase getRightJLabel_Remarks() {
		if (RightJLabel_Remarks == null) {
			RightJLabel_Remarks = new LabelBase();
			RightJLabel_Remarks.setText("Remarks");
			RightJLabel_Remarks.setBounds(45, 125, 109, 20);
		}
		return RightJLabel_Remarks;
	}

	private TextString getRightJText_Remarks() {
		if (RightJText_Remarks == null) {
			RightJText_Remarks = new TextString(75, false);
//			{
//				public void onClick() {
//					setCurrentTable(7,RightJText_BRNo.getText());
//				}
//			};
			RightJText_Remarks.setBounds(181, 125, 444, 20);
		}
		return RightJText_Remarks;
	}
	
	/**
	 * This method initializes RightBasePanel_Class
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	private BasePanel getRightBasePanel_Class() {
		if (RightBasePanel_Class == null) {
			RightBasePanel_Class = new BasePanel();
			RightBasePanel_Class.setHeight(175);
			RightBasePanel_Class.setLayout(null);
			RightBasePanel_Class.add(getTableScrollPanel_Class(), null);
		}
		return RightBasePanel_Class;
	}

	/**
	 * This method initializes RightBasePanel_Privilege
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	private BasePanel getRightBasePanel_Privilege() {
		if (RightBasePanel_Privilege == null) {
			RightBasePanel_Privilege = new BasePanel();
			RightBasePanel_Privilege.setHeight(175);
			RightBasePanel_Privilege.setLayout(null);
			RightBasePanel_Privilege.add(getTableScrollPanel_Privilege(), null);
		}
		return RightBasePanel_Privilege;
	}

	/**
	 * This method initializes RightBasePanel_Department
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	private BasePanel getRightBasePanel_Department() {
		if (RightBasePanel_Department == null) {
			RightBasePanel_Department = new BasePanel();
			RightBasePanel_Department.setHeight(175);
			RightBasePanel_Department.setLayout(null);
			RightBasePanel_Department.add(getTableScrollPanel_Department(), null);
		}
		return RightBasePanel_Department;
	}

	/**
	 * This method initializes RightBasePanel_Specialty
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	private BasePanel getRightBasePanel_Specialty() {
		if (RightBasePanel_Specialty == null) {
			RightBasePanel_Specialty = new BasePanel();
			RightBasePanel_Specialty.setHeight(175);
			RightBasePanel_Specialty.add(getTableScrollPanel_Specialty(), null);
		}
		return RightBasePanel_Specialty;
	}

	/**
	 * This method initializes RightBasePanel_Qualification
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	private BasePanel getRightBasePanel_Qualification() {
		if (RightBasePanel_Qualification == null) {
			RightBasePanel_Qualification = new BasePanel();
			RightBasePanel_Qualification.setHeight(180);
			RightBasePanel_Qualification.add(getTableScrollPanel_Qualification(), null);
		}
		return RightBasePanel_Qualification;
	}

	private BasePanel getRightBasePanel_CertEng() {
		if (RightBasePanel_CertEng == null) {
			RightBasePanel_CertEng = new BasePanel();
			RightBasePanel_CertEng.setHeight(180);
			RightBasePanel_CertEng.add(getRightJLabel_Lab1(), null);
			RightBasePanel_CertEng.add(getRightJLabel_Lab2(), null);
			RightBasePanel_CertEng.add(getRightJLabel_Lab3(), null);
			RightBasePanel_CertEng.add(getRightJLabel_Lab4(), null);
			RightBasePanel_CertEng.add(getRightJLabel_Lab5(), null);
			RightBasePanel_CertEng.add(getRightJLabel_Lab6(), null);
			RightBasePanel_CertEng.add(getRightJLabel_Lab7(), null);
			RightBasePanel_CertEng.add(getRightJLabel_Lab8(), null);
			RightBasePanel_CertEng.add(getRightJLabel_Lab9(), null);
			RightBasePanel_CertEng.add(getRightJLabel_Lab10(), null);

			RightBasePanel_CertEng.add(getRightJText_Text1(), null);
			RightBasePanel_CertEng.add(getRightJText_Text2(), null);
			RightBasePanel_CertEng.add(getRightJText_Text3(), null);
			RightBasePanel_CertEng.add(getRightJText_Text4(), null);
			RightBasePanel_CertEng.add(getRightJText_Text5(), null);
			RightBasePanel_CertEng.add(getRightJText_Text6(), null);
			RightBasePanel_CertEng.add(getRightJText_Text7(), null);
			RightBasePanel_CertEng.add(getRightJText_Text8(), null);
			RightBasePanel_CertEng.add(getRightJText_Text9(), null);
			RightBasePanel_CertEng.add(getRightJText_Text10(), null);
		}
		return RightBasePanel_CertEng;
	}

	private BasePanel getRightBasePanel_CertChi() {
		if (RightBasePanel_CertChi == null) {
			RightBasePanel_CertChi = new BasePanel();
			RightBasePanel_CertChi.setHeight(180);
			RightBasePanel_CertChi.add(getRightJLabel_CLab1(), null);
			RightBasePanel_CertChi.add(getRightJLabel_CLab2(), null);
			RightBasePanel_CertChi.add(getRightJLabel_CLab3(), null);
			RightBasePanel_CertChi.add(getRightJLabel_CLab4(), null);
			RightBasePanel_CertChi.add(getRightJLabel_CLab5(), null);
			RightBasePanel_CertChi.add(getRightJLabel_CLab6(), null);
			RightBasePanel_CertChi.add(getRightJLabel_CLab7(), null);
			RightBasePanel_CertChi.add(getRightJLabel_CLab8(), null);
			RightBasePanel_CertChi.add(getRightJLabel_CLab9(), null);
			RightBasePanel_CertChi.add(getRightJLabel_CLab10(), null);

			RightBasePanel_CertChi.add(getRightJText_CText1(), null);
			RightBasePanel_CertChi.add(getRightJText_CText2(), null);
			RightBasePanel_CertChi.add(getRightJText_CText3(), null);
			RightBasePanel_CertChi.add(getRightJText_CText4(), null);
			RightBasePanel_CertChi.add(getRightJText_CText5(), null);
			RightBasePanel_CertChi.add(getRightJText_CText6(), null);
			RightBasePanel_CertChi.add(getRightJText_CText7(), null);
			RightBasePanel_CertChi.add(getRightJText_CText8(), null);
			RightBasePanel_CertChi.add(getRightJText_CText9(), null);
			RightBasePanel_CertChi.add(getRightJText_CText10(), null);
		}
		return RightBasePanel_CertChi;
	}

	/**
	 * This method initializes RightBasePanel_BasicSalary
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	private BasePanel getRightBasePanel_BasicSalary() {
		if (RightBasePanel_BasicSalary == null) {
			RightBasePanel_BasicSalary = new BasePanel();
			RightBasePanel_BasicSalary.setHeight(180);
			RightBasePanel_BasicSalary.add(getTableScrollPanel_BasicSalary(), null);
		}
		return RightBasePanel_BasicSalary;
	}
	
	private BasePanel getRightBasePanel_ConShare() {
		if (RightBasePanel_ConShare == null) {
			RightBasePanel_ConShare = new BasePanel();
			RightBasePanel_ConShare.setHeight(180);
			RightBasePanel_ConShare.add(getTableScrollPanel_ConShare(), null);
		}
		return RightBasePanel_ConShare;
	}

	/**
	 * This method initializes RightBasePanel_ItemShare
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	private BasePanel getRightBasePanel_ItemShare() {
		if (RightBasePanel_ItemShare == null) {
			RightBasePanel_ItemShare = new BasePanel();
			RightBasePanel_ItemShare.setHeight(180);
			RightBasePanel_ItemShare.add(getTableScrollPanel_ItemShare(), null);
			RightBasePanel_ItemShare.add(getRightButtonBase_Load(), null);
		}
		return RightBasePanel_ItemShare;
	}
	
	private BasePanel getRightBasePanel_ItemShareHist() {
		if (RightBasePanel_ItemShareHist == null) {
			RightBasePanel_ItemShareHist = new BasePanel();
			RightBasePanel_ItemShareHist.setHeight(180);
			RightBasePanel_ItemShareHist.add(getTableScrollPanel_ItemShareHist(), null);
			//RightBasePanel_ItemShareHist.add(getRightButtonBase_Load(), null);
		}
		return RightBasePanel_ItemShareHist;
	}

	/**
	 * This method initializes RightBasePanel_ItemShare
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	private BasePanel getRightBasePanel_Approval() {
		if (RightBasePanel_Approval == null) {
			RightBasePanel_Approval = new BasePanel();
			RightBasePanel_Approval.setHeight(180);
			RightBasePanel_Approval.add(getTableScrollPanel_Approval(), null);
//			RightBasePanel_Approval.add(getRightButtonBase_Load(), null);
		}
		return RightBasePanel_Approval;
	}

	/**
	 * This method initializes RightBasePanel_ItemShare
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	private BasePanel getRightBasePanel_RefDate() {
		if (RightBasePanel_RefDate == null) {
			RightBasePanel_RefDate = new BasePanel();
			RightBasePanel_RefDate.setHeight(180);
			RightBasePanel_RefDate.add(getRightJLabel_SignDate(), null);
			RightBasePanel_RefDate.add(getRightJLabel_MedicalLicenseNo(), null);
			RightBasePanel_RefDate.add(getRightJLabel_EfficDate(), null);
			RightBasePanel_RefDate.add(getRightJLabel_MPSEfficDate(), null);
			RightBasePanel_RefDate.add(getRightJLabel_SingnLableDate(), null);
			RightBasePanel_RefDate.add(getRightJLabel_ClinicDate(), null);
			RightBasePanel_RefDate.add(getRightJLabel_StartDate(), null);
			RightBasePanel_RefDate.add(getRightJLabel_TerminationDate(), null);
			RightBasePanel_RefDate.add(getRightJLabel_OPStartDate(), null);
			RightBasePanel_RefDate.add(getRightJLabel_OPEndDate(), null);
			RightBasePanel_RefDate.add(getRightJLabel_InsurComp(), null);
			RightBasePanel_RefDate.add(getRightJLabel_HKMANo(), null);
			RightBasePanel_RefDate.add(getRightJLabel_MPSNo(), null);

			RightBasePanel_RefDate.add(getRightJText_SignDate(), null);
			RightBasePanel_RefDate.add(getRightJText_MedicalLicenseNo(), null);
			RightBasePanel_RefDate.add(getRightJText_EfficDate(), null);
			RightBasePanel_RefDate.add(getRightJText_MPSEfficDate(), null);
			RightBasePanel_RefDate.add(getRightJText_SingnLableDate(), null);
			RightBasePanel_RefDate.add(getRightJText_ClinicDate(), null);
			RightBasePanel_RefDate.add(getRightJText_StartDate(), null);
			RightBasePanel_RefDate.add(getRightJText_TerminationDate(), null);
			RightBasePanel_RefDate.add(getRightJText_OPStartDate(), null);
			RightBasePanel_RefDate.add(getRightJText_OPEndDate(), null);
			RightBasePanel_RefDate.add(getRightJText_InsurComp(), null);
			RightBasePanel_RefDate.add(getRightJText_HKMANo(), null);
			RightBasePanel_RefDate.add(getRightJText_MPSNo(), null);

		}
		return RightBasePanel_RefDate;
	}

	private TextDate getRightJText_SignDate() {
		if (RightJText_SignDate == null) {
			 RightJText_SignDate = new TextDate();
			RightJText_SignDate.setBounds(270, 0, 100, 20);
		}
		return RightJText_SignDate;
	}

	private TextString getRightJText_MedicalLicenseNo() {
		if (RightJText_MedicalLicenseNo == null) {
			RightJText_MedicalLicenseNo = new TextString();
			RightJText_MedicalLicenseNo.setBounds(270, 25, 100, 20);
		}
		return RightJText_MedicalLicenseNo;
	}

	private TextDate getRightJText_EfficDate() {
		if (RightJText_EfficDate == null) {
			RightJText_EfficDate = new TextDate();
			RightJText_EfficDate.setBounds(270, 50, 100, 20);
		}
		return RightJText_EfficDate;
	}

	private TextDate getRightJText_MPSEfficDate() {
		if (RightJText_MPSEfficDate == null) {
			RightJText_MPSEfficDate = new TextDate();
			RightJText_MPSEfficDate.setBounds(270, 75, 100, 20);
		}
		return RightJText_MPSEfficDate;
	}

	private TextDate getRightJText_SingnLableDate() {
		if (RightJText_SingnLableDate == null) {
			RightJText_SingnLableDate = new TextDate();
				RightJText_SingnLableDate.setBounds(611, 100, 100, 20);
		}
		return RightJText_SingnLableDate;
	}

	private TextDate getRightJText_ClinicDate() {
		if (RightJText_ClinicDate == null) {
			RightJText_ClinicDate = new TextDate();
			RightJText_ClinicDate.setBounds(611, 125, 100, 20);
		}
		return RightJText_ClinicDate;
	}

	private LabelBase getRightJLabel_SignDate() {
		if (RightJLabel_SignDate == null) {
			RightJLabel_SignDate = new LabelBase();
			RightJLabel_SignDate.setText("Code of Practice Signed Date");
			RightJLabel_SignDate.setBounds(20, 0, 250, 20);
		}
		return RightJLabel_SignDate;
	}

	private LabelBase getRightJLabel_MedicalLicenseNo() {
		if (RightJLabel_MedicalLicenseNo == null) {
			RightJLabel_MedicalLicenseNo = new LabelBase();
			RightJLabel_MedicalLicenseNo.setText("HK Medical Council License No.");
			RightJLabel_MedicalLicenseNo.setBounds(20, 25, 250, 20);
		}
		return RightJLabel_MedicalLicenseNo;
	}

	private LabelBase getRightJLabel_EfficDate() {
		if (RightJLabel_EfficDate == null) {
			RightJLabel_EfficDate = new LabelBase();
			RightJLabel_EfficDate.setText("Annual Practising Licence Date(effective until)");
			RightJLabel_EfficDate.setBounds(20, 50, 250, 20);
		}
		return RightJLabel_EfficDate;
	}

	private LabelBase getRightJLabel_MPSEfficDate() {
		if (RightJLabel_MPSEfficDate == null) {
			RightJLabel_MPSEfficDate = new LabelBase();
			RightJLabel_MPSEfficDate.setText("Malpractice Insurance Expiry Date (effective until)");
			RightJLabel_MPSEfficDate.setBounds(20, 75, 250, 20);
		}
		return RightJLabel_MPSEfficDate;
	}

	private LabelBase getRightJLabel_SingnLableDate() {
		if (RightJLabel_SingnLableDate == null) {
			RightJLabel_SingnLableDate = new LabelBase();
			RightJLabel_SingnLableDate.setText("Signature Label Date");
			RightJLabel_SingnLableDate.setBounds(447, 100, 250, 20);
		}
		return RightJLabel_SingnLableDate;
	}

	private LabelBase getRightJLabel_ClinicDate() {
		if (RightJLabel_ClinicDate == null) {
			RightJLabel_ClinicDate = new LabelBase();
			RightJLabel_ClinicDate.setText("Clinic Start Date");
			RightJLabel_ClinicDate.setBounds(447, 125, 250, 20);
		}
		return RightJLabel_ClinicDate;
	}

	private LabelBase getRightJLabel_Lab1() {
		if (RightJLabel_Lab1 == null) {
			RightJLabel_Lab1 = new LabelBase();
			RightJLabel_Lab1.setText("1.");
			RightJLabel_Lab1.setBounds(5, 5,15, 20);
		}
		return RightJLabel_Lab1;
	}

	private LabelBase getRightJLabel_Lab2() {
		if (RightJLabel_Lab2 == null) {
			RightJLabel_Lab2 = new LabelBase();
			RightJLabel_Lab2.setText("2.");
			RightJLabel_Lab2.setBounds(5,30,15, 20);
		}
		return RightJLabel_Lab2;
	}

	private LabelBase getRightJLabel_Lab3() {
		if (RightJLabel_Lab3 == null) {
			RightJLabel_Lab3 = new LabelBase();
			RightJLabel_Lab3.setText("3.");
			RightJLabel_Lab3.setBounds(5,55,15, 20);
		}
		return RightJLabel_Lab3;
	}

	private LabelBase getRightJLabel_Lab4() {
		if (RightJLabel_Lab4 == null) {
			RightJLabel_Lab4 = new LabelBase();
			RightJLabel_Lab4.setText("4.");
			RightJLabel_Lab4.setBounds(5, 80,15, 20);
		}
		return RightJLabel_Lab4;
	}

	private LabelBase getRightJLabel_Lab5() {
		if (RightJLabel_Lab5 == null) {
			RightJLabel_Lab5 = new LabelBase();
			RightJLabel_Lab5.setText("5.");
			RightJLabel_Lab5.setBounds(5, 105,15, 20);
		}
		return RightJLabel_Lab5;
	}

	private LabelBase getRightJLabel_Lab6() {
		if (RightJLabel_Lab6 == null) {
			RightJLabel_Lab6 = new LabelBase();
			RightJLabel_Lab6.setText("6.");
			RightJLabel_Lab6.setBounds(410,5,15, 20);
		}
		return RightJLabel_Lab6;
	}

	private LabelBase getRightJLabel_Lab7() {
		if (RightJLabel_Lab7 == null) {
			RightJLabel_Lab7 = new LabelBase();
			RightJLabel_Lab7.setText("7.");
			RightJLabel_Lab7.setBounds(410,30,15, 20);
		}
		return RightJLabel_Lab7;
	}

	private LabelBase getRightJLabel_Lab8() {
		if (RightJLabel_Lab8 == null) {
			RightJLabel_Lab8 = new LabelBase();
			RightJLabel_Lab8.setText("8.");
			RightJLabel_Lab8.setBounds(410,55,15, 20);
		}
		return RightJLabel_Lab8;
	}

	private LabelBase getRightJLabel_Lab9() {
		if (RightJLabel_Lab9 == null) {
			RightJLabel_Lab9 = new LabelBase();
			RightJLabel_Lab9.setText("9.");
			RightJLabel_Lab9.setBounds(410,80,15, 20);
		}
		return RightJLabel_Lab9;
	}

	private LabelBase getRightJLabel_Lab10() {
		if (RightJLabel_Lab10 == null) {
			RightJLabel_Lab10 = new LabelBase();
			RightJLabel_Lab10.setText("10.");
			RightJLabel_Lab10.setBounds(410, 105,15, 20);
		}
		return RightJLabel_Lab10;
	}

	private TextString getRightJText_Text1() {
		if (RightJText_Text1 == null) {
			RightJText_Text1 = new TextString(150, false);
			RightJText_Text1.setBounds(25, 5,380, 20);
		}
		return RightJText_Text1;
	}

	private TextString getRightJText_Text2() {
		if (RightJText_Text2 == null) {
			RightJText_Text2 = new TextString(150, false);
			RightJText_Text2.setBounds(25,30,380, 20);
		}
		return RightJText_Text2;
	}

	private TextString getRightJText_Text3() {
		if (RightJText_Text3 == null) {
			RightJText_Text3 = new TextString(150, false);
			RightJText_Text3.setBounds(25,55,380, 20);
		}
		return RightJText_Text3;
	}

	private TextString getRightJText_Text4() {
		if (RightJText_Text4 == null) {
			RightJText_Text4 = new TextString(150, false);
			RightJText_Text4.setBounds(25,80,380, 20);
		}
		return RightJText_Text4;
	}

	private TextString getRightJText_Text5() {
		if (RightJText_Text5 == null) {
			RightJText_Text5 = new TextString(150, false);
			RightJText_Text5.setBounds(25,105,380, 20);
		}
		return RightJText_Text5;
	}

	private TextString getRightJText_Text6() {
		if (RightJText_Text6 == null) {
			RightJText_Text6 = new TextString(150, false);
			RightJText_Text6.setBounds(430,5,380, 20);
		}
		return RightJText_Text6;
	}

	private TextString getRightJText_Text7() {
		if (RightJText_Text7 == null) {
			RightJText_Text7= new TextString(150, false);
			RightJText_Text7.setBounds(430,30,380, 20);
		}
		return RightJText_Text7;
	}

	private TextString getRightJText_Text8() {
		if (RightJText_Text8 == null) {
			RightJText_Text8 = new TextString(150, false);
			RightJText_Text8.setBounds(430,55,380, 20);
		}
		return RightJText_Text8;
	}

	private TextString getRightJText_Text9() {
		if (RightJText_Text9 == null) {
			RightJText_Text9 = new TextString(150, false);
			RightJText_Text9.setBounds(430,80,380, 20);
		}
		return RightJText_Text9;
	}

	private TextString getRightJText_Text10() {
		if (RightJText_Text10 == null) {
			RightJText_Text10 = new TextString(150, false);
			RightJText_Text10.setBounds(430,105,380, 20);
		}
		return RightJText_Text10;
	}

	private LabelBase getRightJLabel_CLab1() {
		if (RightJLabel_CLab1 == null) {
			RightJLabel_CLab1 = new LabelBase();
			RightJLabel_CLab1.setText("1.");
			RightJLabel_CLab1.setBounds(5, 5,15, 20);
		}
		return RightJLabel_CLab1;
	}

	private LabelBase getRightJLabel_CLab2() {
		if (RightJLabel_CLab2 == null) {
			RightJLabel_CLab2 = new LabelBase();
			RightJLabel_CLab2.setText("2.");
			RightJLabel_CLab2.setBounds(5,30,15, 20);
		}
		return RightJLabel_CLab2;
	}

	private LabelBase getRightJLabel_CLab3() {
		if (RightJLabel_CLab3 == null) {
			RightJLabel_CLab3 = new LabelBase();
			RightJLabel_CLab3.setText("3.");
			RightJLabel_CLab3.setBounds(5,55,15, 20);
		}
		return RightJLabel_CLab3;
	}

	private LabelBase getRightJLabel_CLab4() {
		if (RightJLabel_CLab4 == null) {
			RightJLabel_CLab4 = new LabelBase();
			RightJLabel_CLab4.setText("4.");
			RightJLabel_CLab4.setBounds(5, 80,15, 20);
		}
		return RightJLabel_CLab4;
	}

	private LabelBase getRightJLabel_CLab5() {
		if (RightJLabel_CLab5 == null) {
			RightJLabel_CLab5 = new LabelBase();
			RightJLabel_CLab5.setText("5.");
			RightJLabel_CLab5.setBounds(5, 105,15, 20);
		}
		return RightJLabel_CLab5;
	}

	private LabelBase getRightJLabel_CLab6() {
		if (RightJLabel_CLab6 == null) {
			RightJLabel_CLab6 = new LabelBase();
			RightJLabel_CLab6.setText("6.");
			RightJLabel_CLab6.setBounds(410,5,15, 20);
		}
		return RightJLabel_CLab6;
	}

	private LabelBase getRightJLabel_CLab7() {
		if (RightJLabel_CLab7 == null) {
			RightJLabel_CLab7 = new LabelBase();
			RightJLabel_CLab7.setText("7.");
			RightJLabel_CLab7.setBounds(410,30,15, 20);
		}
		return RightJLabel_CLab7;
	}

	private LabelBase getRightJLabel_CLab8() {
		if (RightJLabel_CLab8 == null) {
			RightJLabel_CLab8 = new LabelBase();
			RightJLabel_CLab8.setText("8.");
			RightJLabel_CLab8.setBounds(410,55,15, 20);
		}
		return RightJLabel_CLab8;
	}

	private LabelBase getRightJLabel_CLab9() {
		if (RightJLabel_CLab9 == null) {
			RightJLabel_CLab9 = new LabelBase();
			RightJLabel_CLab9.setText("9.");
			RightJLabel_CLab9.setBounds(410,80,15, 20);
		}
		return RightJLabel_CLab9;
	}

	private LabelBase getRightJLabel_CLab10() {
		if (RightJLabel_CLab10 == null) {
			RightJLabel_CLab10 = new LabelBase();
			RightJLabel_CLab10.setText("10.");
			RightJLabel_CLab10.setBounds(410, 105,15, 20);
		}
		return RightJLabel_CLab10;
	}

	private TextString getRightJText_CText1() {
		if (RightJText_CText1 == null) {
			RightJText_CText1 = new TextString(150);
			RightJText_CText1.setBounds(25, 5,380, 20);
		}
		return RightJText_CText1;
	}

	private TextString getRightJText_CText2() {
		if (RightJText_CText2 == null) {
			RightJText_CText2 = new TextString(150);
			RightJText_CText2.setBounds(25,30,380, 20);
		}
		return RightJText_CText2;
	}

	private TextString getRightJText_CText3() {
		if (RightJText_CText3 == null) {
			RightJText_CText3 = new TextString(150);
			RightJText_CText3.setBounds(25,55,380, 20);
		}
		return RightJText_CText3;
	}

	private TextString getRightJText_CText4() {
		if (RightJText_CText4 == null) {
			RightJText_CText4 = new TextString(150);
			RightJText_CText4.setBounds(25,80,380, 20);
		}
		return RightJText_CText4;
	}

	private TextString getRightJText_CText5() {
		if (RightJText_CText5 == null) {
			RightJText_CText5 = new TextString(150);
			RightJText_CText5.setBounds(25,105,380, 20);
		}
		return RightJText_CText5;
	}

	private TextString getRightJText_CText6() {
		if (RightJText_CText6 == null) {
			RightJText_CText6 = new TextString(150);
			RightJText_CText6.setBounds(430,5,380, 20);
		}
		return RightJText_CText6;
	}

	private TextString getRightJText_CText7() {
		if (RightJText_CText7 == null) {
			RightJText_CText7= new TextString(150);
			RightJText_CText7.setBounds(430,30,380, 20);
		}
		return RightJText_CText7;
	}

	private TextString getRightJText_CText8() {
		if (RightJText_CText8 == null) {
			RightJText_CText8 = new TextString(150);
			RightJText_CText8.setBounds(430,55,380, 20);
		}
		return RightJText_CText8;
	}

	private TextString getRightJText_CText9() {
		if (RightJText_CText9 == null) {
			RightJText_CText9 = new TextString(150);
			RightJText_CText9.setBounds(430,80,380, 20);
		}
		return RightJText_CText9;
	}

	private TextString getRightJText_CText10() {
		if (RightJText_CText10 == null) {
			RightJText_CText10 = new TextString(150);
			RightJText_CText10.setBounds(430,105,380, 20);
		}
		return RightJText_CText10;
	}

	/**
	 * This method initializes SharePanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	private BasePanel getSharePanel() {
		if (SharePanel == null) {
			SharePanel = new BasePanel();
			SharePanel.setBorders(true);
			SharePanel.setBounds(60, 280, 760, 33);
			SharePanel.setStyleAttribute("margin-bottom", "5px");
			SharePanel.add(getRightJLabel_DaycaseShare(), null);
			SharePanel.add(getRightJLabel_InpatShare(), null);
			SharePanel.add(getRightJLabel_OutpatShare(), null);
			SharePanel.add(getRightJText_InpatShare(), null);
			SharePanel.add(getRightJText_OutpatShare(), null);
			SharePanel.add(getRightJText_DaycaseShare(), null);
		}
		return SharePanel;
	}

	/**
	 * This method initializes RightJText_InpatShare
	 *
	 * @return com.hkah.client.layout.textfield.TextNum
	 */
	private TextNum getRightJText_InpatShare() {
		if (RightJText_InpatShare == null) {
			RightJText_InpatShare = new TextNum(3,0);
//			{
//				public void onReleased() {
//					setCurrentTable(10,RightJText_InpatShare.getText());
//				}
//			};
			RightJText_InpatShare.setBounds(110, 6, 95, 20);
		}
		return RightJText_InpatShare;
	}

	/**
	 * This method initializes RightJText_OutpatShare
	 *
	 * @return com.hkah.client.layout.textfield.TextNum
	 */
	private TextNum getRightJText_OutpatShare() {
		if (RightJText_OutpatShare == null) {
			RightJText_OutpatShare = new TextNum(3,0);
//			{
//
//				public void onReleased() {
//					// TODO Auto-generated method stub
//					setCurrentTable(11,RightJText_OutpatShare.getText());
//				}};
			RightJText_OutpatShare.setBounds(350, 6, 100, 20);

		}
		return RightJText_OutpatShare;
	}

	/**
	 * This method initializes RightJText_DaycaseShare
	 *
	 * @return com.hkah.client.layout.textfield.TextNum
	 */
	private TextNum getRightJText_DaycaseShare() {
		if (RightJText_DaycaseShare == null) {
			RightJText_DaycaseShare = new TextNum(3,0);
//			{
//				public void onReleased() {
//					setCurrentTable(12,RightJText_DaycaseShare.getText());
//				}
//			};
			RightJText_DaycaseShare.setBounds(620, 6, 113, 20);
		}
		return RightJText_DaycaseShare;
	}

	/**
	 * This method initializes RightJText_StartDate
	 *
	 * @return com.hkah.client.layout.textfield.TextDate
	 */
	private TextDate getRightJText_StartDate() {
		if (RightJText_StartDate == null) {
			RightJText_StartDate = new TextDate();
//			{
//				public void onReleased() {
//					setCurrentTable(22,RightJText_StartDate.getText());
//				}
//			};
			RightJText_StartDate.setBounds(611,0, 100, 20);

		}
		return RightJText_StartDate;
	}

	/**
	 * This method initializes RightJText_TerminationDate
	 *
	 * @return com.hkah.client.layout.textfield.TextDate
	 */
	private TextDate getRightJText_TerminationDate() {
		if (RightJText_TerminationDate == null) {
			RightJText_TerminationDate = new TextDate();
//			{
//				public void onReleased() {
//					setCurrentTable(21, RightJText_TerminationDate.getText());
//				}
//			};
			RightJText_TerminationDate.setBounds(611, 25, 100, 20);
		}
		return RightJText_TerminationDate;
	}

	private TextDate getRightJText_OPStartDate() {
		if (RightJText_OPStartDate == null) {
			RightJText_OPStartDate = new TextDate();
//			{
//				public void onReleased() {
//					setCurrentTable(21, RightJText_TerminationDate.getText());
//				}
//			};
			RightJText_OPStartDate.setBounds(611, 50, 100, 20);
		}
		return RightJText_OPStartDate;
	}

	private TextDate getRightJText_OPEndDate() {
		if (RightJText_OPEndDate == null) {
			RightJText_OPEndDate = new TextDate();
//			{
//				public void onReleased() {
//					setCurrentTable(21, RightJText_TerminationDate.getText());
//				}
//			};
			RightJText_OPEndDate.setBounds(611, 75, 100, 20);
		}
		return RightJText_OPEndDate;
	}

	private TextString getRightJText_InsurComp() {
		if (RightJText_InsurComp == null) {
			RightJText_InsurComp = new TextString();
			RightJText_InsurComp.setBounds(270, 128, 100, 20);
		}
		return RightJText_InsurComp;
	}
	
	private TextString getRightJText_HKMANo() {
		if (RightJText_HKMANo == null) {
			RightJText_HKMANo = new TextString();
			RightJText_HKMANo.setBounds(90, 105, 100, 20);
		}
		return RightJText_HKMANo;
	}
	
	private TextString getRightJText_MPSNo() {
		if (RightJText_MPSNo == null) {
			RightJText_MPSNo = new TextString();
			RightJText_MPSNo.setBounds(270, 105, 100, 20);
		}
		return RightJText_MPSNo;
	}
	
	private JScrollPane getTableScrollPanel_Class() {
		if (tableScrollPanel_Class == null) {
			tableScrollPanel_Class = new JScrollPane();
			tableScrollPanel_Class.setViewportView(getRightJTable_Class());
			tableScrollPanel_Class.setBounds(5, 5, 800, 140);
		}
		return tableScrollPanel_Class;
	}

	private EditorTableList getRightJTable_Class() {
		if (RightJTable_Class == null) {
			RightJTable_Class = new EditorTableList(
					new String[] {"Class Code", "Description", "Expiry Date", "DCLID"},
					new int[] {250, 250, 150, 0 }, getClassEditor()
			) {
				@Override
				public void postSaveTable(boolean success, Integer rtnCode, String rtnMsg) {
					deleteSelectedRowsAction(deleteRowsClass, "DOCTOR_CLASS", 11);
					searchDoctor(getRightJText_DoctorCode().getText(), false);
				}
			};
			RightJTable_Class.setHeight(130);
		}
		return RightJTable_Class;
	}

	private JScrollPane getTableScrollPanel_Privilege() {
		if (tableScrollPanel_Privilege == null) {
			tableScrollPanel_Privilege = new JScrollPane();
			tableScrollPanel_Privilege.setViewportView(getRightJTable_Privilege());
			tableScrollPanel_Privilege.setBounds(5, 5, 800, 140);
		}
		return tableScrollPanel_Privilege;
	}

	private EditorTableList getRightJTable_Privilege() {
		if (RightJTable_Privilege == null) {
			RightJTable_Privilege = new EditorTableList(
					new String[] {"Privilege Code", "Privilege Name", "Start Date", "End Date", "DPLID"},
					new int[] {250, 250, 150, 150, 0 }, getPrivilegeEditor()
			) {
				@Override
				public void postSaveTable(boolean success, Integer rtnCode, String rtnMsg) {
					deleteSelectedRowsAction(deleteRowsPrivilege, "DOCTOR_PRIVILEGE", 4);
					searchDoctor(getRightJText_DoctorCode().getText(), false);
				}
			};
			RightJTable_Privilege.setHeight(130);
		}
		return RightJTable_Privilege;
	}

	private JScrollPane getTableScrollPanel_Department() {
		if (tableScrollPanel_Department == null) {
			tableScrollPanel_Department = new JScrollPane();
			tableScrollPanel_Department.setViewportView(getRightJTable_Department());
			tableScrollPanel_Department.setBounds(5, 5, 800, 140);
		}
		return tableScrollPanel_Department;
	}

	private EditorTableList getRightJTable_Department() {
		if (RightJTable_Department == null) {
			RightJTable_Department = new EditorTableList(
					new String[] {"Department Code", "Department Name", "Department Chinese Name", "DDLID"},
					new int[] { 200, 300, 300, 0 }, getDepartmentEditor()
			) {
				@Override
				public void postSaveTable(boolean success, Integer rtnCode, String rtnMsg) {
					deleteSelectedRowsAction(deleteRowsDepartment, "DOCTOR_DEPT", 3);
					searchDoctor(getRightJText_DoctorCode().getText(), false);
				}
			};
		}
		return RightJTable_Department;
	}

	private JScrollPane getTableScrollPanel_Specialty() {
		if (tableScrollPanel_Specialty == null) {
			tableScrollPanel_Specialty = new JScrollPane();
			tableScrollPanel_Specialty.setViewportView(getRightJTable_Specialty());
			tableScrollPanel_Specialty.setBounds(5, 5, 800, 140);
		}
		return tableScrollPanel_Specialty;
	}

	private EditorTableList getRightJTable_Specialty() {
		if (RightJTable_Specialty == null) {
			RightJTable_Specialty = new EditorTableList(
					new String[] {"Specialty Code", "Specialty Name", "Official", "DSLID", "Officialdata"},
					new int[] { 200, 500 , 100, 0, 0}, getSpecialtyEditor()
			) {
				@Override
				public void postSaveTable(boolean success, Integer rtnCode, String rtnMsg) {
					deleteSelectedRowsAction(deleteRowsSpecialty, "DOCTOR_SPECIALTY", 3);
					searchDoctor(getRightJText_DoctorCode().getText(), false);
				}
			};
		}
		return RightJTable_Specialty;
	}

	private JScrollPane getTableScrollPanel_Qualification() {
		if (tableScrollPanel_Qualification == null) {
			tableScrollPanel_Qualification = new JScrollPane();
			tableScrollPanel_Qualification.setViewportView(getRightJTable_Qualification());
			tableScrollPanel_Qualification.setBounds(5, 5, 800, 140);
		}
		return tableScrollPanel_Qualification;
	}

	private EditorTableList getRightJTable_Qualification() {
		if (RightJTable_Qualification == null) {
			RightJTable_Qualification = new EditorTableList(
					new String[] {"Qualification Reference", "Qualification Name", "Issue Date", "DQLID", "Expiry Date"},
					new int[] { 150, 550 , 100 , 0, 100}, getQualificationEditor()
			) {
				@Override
				public void postSaveTable(boolean success, Integer rtnCode, String rtnMsg) {
					deleteSelectedRowsAction(deleteRowsQulification, "DOCTOR_QUALIFICATION", 3);
					searchDoctor(getRightJText_DoctorCode().getText(), false);
				}
			};
		}
		return RightJTable_Qualification;
	}

	private JScrollPane getTableScrollPanel_BasicSalary() {
		if (tableScrollPanel_BasicSalary == null) {
			tableScrollPanel_BasicSalary = new JScrollPane();
			tableScrollPanel_BasicSalary.setViewportView(getRightJTable_BasicSalary());
			tableScrollPanel_BasicSalary.setBounds(5, 5, 800, 140);
		}
		return tableScrollPanel_BasicSalary;
	}

	private EditorTableList getRightJTable_BasicSalary() {
		if (RightJTable_BasicSalary == null) {
			RightJTable_BasicSalary = new EditorTableList(
					new String[] {"Start Date", "End Date", "Salary", "DBSID"},
					new int[] { 150, 150, 500, 0 }, getBasicSalaryEditor()
			) {
				@Override
				public void postSaveTable(boolean success, Integer rtnCode, String rtnMsg) {
					deleteSelectedRowsAction(deleteRowsBasicSalary, "DOCTOR_BASICSALARY", 3);
					searchDoctor(getRightJText_DoctorCode().getText(), false);
				}
			};
		}
		return RightJTable_BasicSalary;
	}
	
	private JScrollPane getTableScrollPanel_ConShare() {
		if (tableScrollPanel_ConShare == null) {
			tableScrollPanel_ConShare = new JScrollPane();
			tableScrollPanel_ConShare.setViewportView(getRightJTable_ConShare());
			tableScrollPanel_ConShare.setBounds(5, 5, 735, 140);
		}
		return tableScrollPanel_ConShare;
	}

	private EditorTableList getRightJTable_ConShare() {
		if (RightJTable_ConShare == null) {
			RightJTable_ConShare = new EditorTableList(
					new String[] {"DPHID", "DOCCODE", "Contract Start Date", "Contract End Date",
								  "Inpat % Share", "Outpat % Share", "Daycase % Share"},
					new int[] {  0, 0, 100, 100, 100, 100, 100}, getConShareEditor()
			) {
				@Override
				public void postSaveTable(boolean success, Integer rtnCode, String rtnMsg) {
					deleteSelectedRowsAction(deleteRowsConShare, "DOCPCTHIST", 0);
					//searchDoctor(getRightJText_DoctorCode().getText(), false);
				}

				@Override
				public void setListTableContentPost() {
					// override for the child class
					int cursorInt = getRowCount();
					if (cursorInt > 0) {
						getView().focusRow(cursorInt);
						getSelectionModel().select(cursorInt, false);
					}
				}
			};
		}
		return RightJTable_ConShare;
	}

	private JScrollPane getTableScrollPanel_ItemShare() {
		if (tableScrollPanel_ItemShare == null) {
			tableScrollPanel_ItemShare = new JScrollPane();
			tableScrollPanel_ItemShare.setViewportView(getRightJTable_ItemShare());
			tableScrollPanel_ItemShare.setBounds(5, 5, 735, 140);
		}
		return tableScrollPanel_ItemShare;
	}

	private EditorTableList getRightJTable_ItemShare() {
		if (RightJTable_ItemShare == null) {
			RightJTable_ItemShare = new EditorTableList(
					new String[] {"Pat. Type", "Pat. Cat", "Dpt Srv",
								  "Item", "Name", "Share%", "Fix Amount", "DIPID"},
					new int[] {  90, 90, 90, 90, 200, 60, 80 , 0}, getItemShareEditor()
			) {
				@Override
				public void postSaveTable(boolean success, Integer rtnCode, String rtnMsg) {
					deleteSelectedRowsAction(deleteRowsItemShare, "DOCTOR_ITEMSHARE", 7);
					searchDoctor(getRightJText_DoctorCode().getText(), false);
				}

				@Override
				public void setListTableContentPost() {
					// override for the child class
					int cursorInt = getRowCount();
					if (cursorInt > 0) {
						getView().focusRow(cursorInt);
						getSelectionModel().select(cursorInt, false);
					}
				}
			};
		}
		return RightJTable_ItemShare;
	}
	
	private JScrollPane getTableScrollPanel_ItemShareHist() {
		if (tableScrollPanel_ItemShareHist == null) {
			tableScrollPanel_ItemShareHist = new JScrollPane();
			tableScrollPanel_ItemShareHist.setViewportView(getRightJTable_ItemShareHist());
			tableScrollPanel_ItemShareHist.setBounds(5, 5, 735, 140);
		}
		return tableScrollPanel_ItemShareHist;
	}

	private EditorTableList getRightJTable_ItemShareHist() {
		if (RightJTable_ItemShareHist == null) {
			RightJTable_ItemShareHist = new EditorTableList(
					new String[] {"Start Date", "End Date", "Pat. Type", "Pat. Cat", "Dpt Srv",
								  "Item", "Name", "Share%", "Fix Amount", "DIPHID"},
					new int[] {  120, 120, 90, 90, 90, 90, 200, 60, 80 , 0}, getItemShareHistEditor()
			) {
				@Override
				public void postSaveTable(boolean success, Integer rtnCode, String rtnMsg) {
					deleteSelectedRowsAction(deleteRowsItemShareHist, "DOCTOR_ITEMSHAREHIST", 9);
					searchDoctor(getRightJText_DoctorCode().getText(), false);
				}

				@Override
				public void setListTableContentPost() {
					// override for the child class
					int cursorInt = getRowCount();
					if (cursorInt > 0) {
						getView().focusRow(cursorInt);
						getSelectionModel().select(cursorInt, false);
					}
				}
			};
		}
		return RightJTable_ItemShareHist;
	}

	private JScrollPane getTableScrollPanel_Approval() {
		if (tableScrollPanel_Approval == null) {
			tableScrollPanel_Approval = new JScrollPane();
			tableScrollPanel_Approval.setViewportView(getRightJTable_Approval());
			tableScrollPanel_Approval.setBounds(5, 5, 800, 140);
		}
		return tableScrollPanel_Approval;
	}

	private EditorTableList getRightJTable_Approval() {
		if (RightJTable_Approval == null) {
			RightJTable_Approval = new EditorTableList(
					new String[] {"Approval By", "Action No.", "Approved Date", "DALID"},
					new int[] { 400, 200, 200, 0}, getApprovalEditor()
			) {
				@Override
				public void postSaveTable(boolean success, Integer rtnCode, String rtnMsg) {
					deleteSelectedRowsAction(deleteRowsApproval, "DOCTOR_APPROVAL", 3);
					searchDoctor(getRightJText_DoctorCode().getText(), false);
				}
			};
		}
		return RightJTable_Approval;
	}
	

	@SuppressWarnings("unchecked")
	private Field<? extends Object>[] getClassEditor() {
		Field<? extends Object>[] editors = new Field<?>[4];
		editors[0] = new ComboDocClass() {
			@Override
			protected void onClick() {
				getRightJTable_Class().stopEditing();
				getRightJTable_Class().setValueAt(this.getDisplayTextWithoutKey(), getRightJTable_Class().getSelectedRow(), 1);
			}

			@Override
			protected void onPressed(FieldEvent fe) {
				if (13 == fe.getKeyCode() || 9 == fe.getKeyCode()) {
					getRightJTable_Class().stopEditing();
					getRightJTable_Class().setValueAt(this.getDisplayTextWithoutKey(), getRightJTable_Class().getSelectedRow(), 1);
				}
			}
		};
		editors[1] = new TextField<String>();
		editors[2] = new TextDate();
		editors[3] = null;
		return editors;
	}

	@SuppressWarnings("unchecked")
	private Field<? extends Object>[] getPrivilegeEditor() {
		Field<? extends Object>[] editors = new Field<?>[5];
		editors[0] = new ComboPrivilege() {
			@Override
			protected void onClick() {
				getRightJTable_Privilege().stopEditing();
				getRightJTable_Privilege().setValueAt(this.getDisplayTextWithoutKey(), getRightJTable_Privilege().getSelectedRow(), 1);
			}

			@Override
			protected void onPressed(FieldEvent fe) {
				if (13 == fe.getKeyCode() || 9 == fe.getKeyCode()) {
					getRightJTable_Privilege().stopEditing();
					getRightJTable_Privilege().setValueAt(this.getDisplayTextWithoutKey(), getRightJTable_Privilege().getSelectedRow(), 1);
				}
			}
		};
		editors[1] = null;
		editors[2] = new TextDate();
		editors[3] = new TextDate();
		editors[4] = null;
		return editors;
	}

	@SuppressWarnings("unchecked")
	private Field<? extends Object>[] getDepartmentEditor() {
		Field<? extends Object>[] editors = new Field<?>[4];
		editors[0] = new ComboDoctorDept() {
			@Override
			protected void onClick() {
				getRightJTable_Department().stopEditing();
				getRightJTable_Department().setValueAt(this.getDisplayTextWithoutKey(), getRightJTable_Department().getSelectedRow(), 1);
			}

			@Override
			protected void onPressed(FieldEvent fe) {
				if (13 == fe.getKeyCode() || 9 == fe.getKeyCode()) {
					getRightJTable_Department().stopEditing();
					getRightJTable_Department().setValueAt(this.getDisplayTextWithoutKey(), getRightJTable_Department().getSelectedRow(), 1);
				}
			}
		};
		editors[1] = null;
		editors[2] = null;
		editors[3] = null;

		return editors;
	}

	@SuppressWarnings("unchecked")
	private Field<? extends Object>[] getSpecialtyEditor() {
		Field<? extends Object>[] editors = new Field<?>[5];
		editors[0] = new ComboSpecialtyCode() {
			@Override
			protected void onClick() {
				getRightJTable_Specialty().stopEditing();
				getRightJTable_Specialty().setValueAt(this.getDisplayTextWithoutKey(), getRightJTable_Specialty().getSelectedRow(), 1);
			}

			@Override
			protected void onPressed(FieldEvent fe) {
				if (13 == fe.getKeyCode() || 9 == fe.getKeyCode()) {
					getRightJTable_Specialty().stopEditing();
					getRightJTable_Specialty().setValueAt(this.getDisplayTextWithoutKey(), getRightJTable_Specialty().getSelectedRow(), 1);
				}
			}
		};
		editors[1] = null;
		editors[2] = getOfficialChkBox();
		editors[3] = null;
		editors[4] = null;

		return editors;
	}

	@SuppressWarnings("unchecked")
	private Field<? extends Object>[] getQualificationEditor() {
		Field<? extends Object>[] editors = new Field<?>[5];
		editors[0] = new ComboQualification() {
			@Override
			protected void onClick() {
				getRightJTable_Qualification().stopEditing();
				getRightJTable_Qualification().setValueAt(this.getDisplayTextWithoutKey(), getRightJTable_Qualification().getSelectedRow(), 1);
			}

			@Override
			protected void onPressed(FieldEvent fe) {
				if (13 == fe.getKeyCode() || 9 == fe.getKeyCode()) {
					getRightJTable_Qualification().stopEditing();
					getRightJTable_Qualification().setValueAt(this.getDisplayTextWithoutKey(), getRightJTable_Qualification().getSelectedRow(), 1);
				}
			}
		};
		editors[1] = null;
		editors[2] = new TextDate();
		editors[3] = null;
		editors[4] = new TextDate();

		return editors;
	}

	private Field<? extends Object>[] getBasicSalaryEditor() {
		Field<? extends Object>[] editors = new Field<?>[4];
		editors[0] = new TextDate();
		editors[1] = new TextDate();
		editors[2] = new TextField<String>();
		editors[3] = null;
		return editors;
	}
	
	private Field<? extends Object>[] getConShareEditor() {
		Field<? extends Object>[] editors = new Field<?>[76];
		editors[0] = null;
		editors[1] = null;
		editors[2] = new TextDate();
		editors[3] = new TextDate();
		editors[4] = new TextNum(3,0);
		editors[5] = new TextNum(3,0);
		editors[6] = new TextNum(3,0);
		return editors;
	}

	@SuppressWarnings("unchecked")
	private Field<? extends Object>[] getItemShareEditor() {
		Field<? extends Object>[] editors = new Field<?>[8];
		editors[0] = new ComboPatientType();
		editors[1] = new ComboPatientCat();
		editors[2] = new ComboDoctorDeptServ();
		editors[3] = new ComboDoctorItemCode() {
			@Override
			protected void onClick() {
				getRightJTable_ItemShare().stopEditing();
				getRightJTable_ItemShare().setValueAt(this.getDisplayTextWithoutKey(), getRightJTable_ItemShare().getSelectedRow(), 4);
			}

			@Override
			protected void onPressed(FieldEvent fe) {
				if (13 == fe.getKeyCode() || 9 == fe.getKeyCode()) {
					getRightJTable_ItemShare().stopEditing();
					getRightJTable_ItemShare().setValueAt(this.getDisplayTextWithoutKey(), getRightJTable_ItemShare().getSelectedRow(), 4);
				}
			}
		};
		editors[4] = null;
		editors[5] = new TextField<String>();
		editors[6] = new TextField<String>();
		editors[7] = null;
		return editors;
	}
	
	@SuppressWarnings("unchecked")
	private Field<? extends Object>[] getItemShareHistEditor() {
		Field<? extends Object>[] editors = new Field<?>[10];
		editors[0] = new TextDate();
		editors[1] = new TextDate();
		editors[2] = new ComboPatientType();
		editors[3] = new ComboPatientCat();
		editors[4] = new ComboDoctorDeptServ();
		editors[5] = new ComboDoctorItemCode() {
			@Override
			protected void onClick() {
				getRightJTable_ItemShareHist().stopEditing();
				getRightJTable_ItemShareHist().setValueAt(this.getDisplayTextWithoutKey(), getRightJTable_ItemShareHist().getSelectedRow(), 6);
			}

			@Override
			protected void onPressed(FieldEvent fe) {
				if (13 == fe.getKeyCode() || 9 == fe.getKeyCode()) {
					getRightJTable_ItemShareHist().stopEditing();
					getRightJTable_ItemShareHist().setValueAt(this.getDisplayTextWithoutKey(), getRightJTable_ItemShareHist().getSelectedRow(), 6);
				}
			}
		};
		editors[6] = null;
		editors[7] = new TextField<String>();
		editors[8] = new TextField<String>();
		editors[9] = null;
		return editors;
	}

	private Field<? extends Object>[] getApprovalEditor() {
		Field<? extends Object>[] editors = new Field<?>[4];
		editors[0] = new TextField<String>();
		editors[1] = new TextField<String>();
		editors[2] = new TextDate();
		editors[3] = null;
		return editors;
	}

	/**
	 * This method initializes RightButtonBase_Load
	 *
	 * @return javax.swing.ButtonBase
	 */
	private ButtonBase getRightButtonBase_Load() {
		if (RightButtonBase_Load == null) {
			RightButtonBase_Load = new ButtonBase("Load") {
				@Override
				public void onClick() {
					// TODO Auto-generated method stub
					super.onClick();
					DlgDoctorSelection dds = new DlgDoctorSelection(getMainFrame());
					dds.show();
				}
			};
			RightButtonBase_Load.setBounds(745, 121, 64, 25);
		}
//		RightButtonBase_Load.setHeight(100);
		return RightButtonBase_Load;
	}

	public void itemShareLoad(String doccode) {
		getRightJTable_ItemShare().appendListTableContent(ConstantsTx.LIST_DOCTOR_ITEMSHARE_TXCODE, new String[] { doccode, "N"});
	}

	private CheckBoxBase getOfficialChkBox() {
		CheckBoxBase ChkBox = new CheckBoxBase();

		ChkBox.addListener(Events.OnClick, new Listener<FieldEvent>() {
			@Override
			public void handleEvent(FieldEvent be) {
				// TODO Auto-generated method stub
				final int selRow = RightJTable_Specialty.getSelectedRow();
				final ListStore<TableData> store = RightJTable_Specialty.getStore();
				final TableData rowData = store.getAt(selRow);

				if (((CheckBoxBase)be.getField()).getValue()) {
					//listTable.setValueAt("-1", selRow, 24);
					rowData.set(TableUtil.getName2ID("Officialdata"), "-1");
				} else {
					//listTable.setValueAt("0", selRow, 24);
					rowData.set(TableUtil.getName2ID("Officialdata"), "0");
				}
			}
		});
		return ChkBox;
	}

	private void deleteSelectedRows(EditorTableList selectedTable, ArrayList deleteRows) {
		int selectrow = selectedTable.getSelectedRow();
		int rowcount = selectedTable.getRowCount();
		if (selectedTable.getRowCount() > 0) {
			deleteRows.add(selectedTable.getSelectedRowContent());

			// remove selected row from table
			selectedTable.removeRow(selectedTable.getSelectedRow());
			if (selectedTable.getRowCount() > 0) {
				// set select row
				if (selectrow == (rowcount - 1)) {
					selectedTable.setSelectRow(selectrow - 1);
				} else {
					selectedTable.setSelectRow(selectrow);
				}
			}
		}
	}

	private void deleteSelectedRowsAction(ArrayList deleteRows, String tableName, int itemID) {
		if (deleteRows.size() > 0) {
			for (int i = 0; i < deleteRows.size(); i++) {
				String[] tablevalue = (String[]) deleteRows.get(i);
					QueryUtil.executeMasterAction(getUserInfo(), tableName + "_D", QueryUtil.ACTION_DELETE, new String[] {getUserInfo().getUserID(), tablevalue[itemID]},
							new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						// refresh from db
					}
				});
			}
			deleteRows.clear();
		}
	}

	protected boolean actionValidation(String[] selectedContent, String tabNum) {
		boolean success = true;
		if ("1".equals(tabNum)) {
			if (selectedContent[0].trim().length() == 0) {
				Factory.getInstance().addErrorMessage("Table: Doctor-Privilege Linkage<br>Field: Privilege Code<br><br>Field not allowed to be null", "PBA - [Doctor]");
				success = false;
			}
		} else if ("2".equals(tabNum)) {
			if (selectedContent[0].trim().length() == 0) {
				Factory.getInstance().addErrorMessage("Table: Doctor-Department Linkage<br>Field: Department Code<br><br>Field not allowed to be null", "PBA - [Doctor]");
				success = false;
			}
		} else if ("3".equals(tabNum)) {
			if (selectedContent[0].trim().length() == 0) {
				Factory.getInstance().addErrorMessage("Table: Doctor-Specialty Linkage<br>Field: Specialty Code<br><br>Field not allowed to be null", "PBA - [Doctor]");
				success = false;
			}
		} else if ("4".equals(tabNum)) {
			if (selectedContent[0].trim().length() == 0) {
				Factory.getInstance().addErrorMessage("Table: Doctor-Qualification Linkage<br>Field: Qualification Reference<br><br>Field not allowed to be null", "PBA - [Doctor]");
				success = false;
			}
		} else if ("7".equals(tabNum)) {
			if (selectedContent[0].trim().length() == 0) {
				Factory.getInstance().addErrorMessage("Table: Doctor-Basic Salary<br>Field: Start Date<br><br>Field not allowed to be null", "PBA - [Doctor]");
				success = false;
			} else if (selectedContent[1].trim().length() == 0) {
				Factory.getInstance().addErrorMessage("Table: Doctor-Basic Salary<br>Field: End Date<br><br>Field not allowed to be null", "PBA - [Doctor]");
				success = false;
			} else if (selectedContent[2].trim().length() == 0) {
				Factory.getInstance().addErrorMessage("Table: Doctor-Basic Salary<br>Field: Salary<br><br>Field not allowed to be null", "PBA - [Doctor]");
				success = false;
			}

		} else if ("9".equals(tabNum)) {
			if (selectedContent[5].trim().length() == 0 && selectedContent[6].trim().length() == 0) {
				Factory.getInstance().addErrorMessage("Table: Doctor-Item % Share<br>Please input either Share % or Fix Amt!", "PBA - [Doctor]");
				success = false;
			}
		} else if ("10".equals(tabNum)) {
			if (selectedContent[7].trim().length() == 0 && selectedContent[8].trim().length() == 0) {
				Factory.getInstance().addErrorMessage("Table: Doctor-Item % Share History<br>Please input either Share % or Fix Amt!", "PBA - [Doctor]");
				success = false;
			}
		} else if ("11".equals(tabNum)) {
			if (selectedContent[0].trim().length() == 0) {
				Factory.getInstance().addErrorMessage("Table: Doctor-Approval Link<br>Field: Approval By<br><br>Field not allowed to be null", "PBA - [Doctor]");
				success = false;
			} else if (selectedContent[2].trim().length() == 0) {
				Factory.getInstance().addErrorMessage("Table: Doctor-Approval Link<br>Field: Approved Date<br><br>Field not allowed to be null", "PBA - [Doctor]");
				success = false;
			}
		} else if ("13".equals(tabNum)) {
			if (selectedContent[0].trim().length() == 0) {
				Factory.getInstance().addErrorMessage("Table: Doctor-Class Link<br>Field: Class Code<br><br>Field not allowed to be null", "PBA - [Doctor]");
				success = false;
			} else if (selectedContent[2].trim().length() == 0) {
				Factory.getInstance().addErrorMessage("Table: Doctor-Class Link<br>Field: Expiry Date<br><br>Field not allowed to be null", "PBA - [Doctor]");
				success = false;
			}
		}
		return success;
	}

	private boolean checkSubTableValues(String tabNum, EditorTableList eList, boolean noError) {
		if (viewedTab.contains(tabNum) && noError) {
			getDetailJTabbedPane().setSelectedIndex(Integer.parseInt(tabNum));
			for (int i = 0; i < eList.getRowCount(); i++) {
				String[] selectedContent = eList.getTableValues()[i];
				eList.setSelectRow(i);
				if (!actionValidation(selectedContent, tabNum)) {
					noError = false;
					eList.setSelectRow(i);
					break;
				}
			}
		}
		return noError;
	}
}