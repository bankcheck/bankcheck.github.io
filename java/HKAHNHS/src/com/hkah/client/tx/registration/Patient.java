package com.hkah.client.tx.registration;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.EditorEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.FieldEvent;
import com.extjs.gxt.ui.client.event.FormEvent;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.event.WindowEvent;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.MessageBox;
import com.extjs.gxt.ui.client.widget.VerticalPanel;
import com.extjs.gxt.ui.client.widget.Window;
import com.extjs.gxt.ui.client.widget.button.Button;
import com.extjs.gxt.ui.client.widget.form.AdapterField;
import com.extjs.gxt.ui.client.widget.form.Field;
import com.extjs.gxt.ui.client.widget.form.FormPanel;
import com.extjs.gxt.ui.client.widget.form.FormPanel.Method;
import com.extjs.gxt.ui.client.widget.form.HiddenField;
import com.extjs.gxt.ui.client.widget.form.MultiField;
import com.extjs.gxt.ui.client.widget.form.RadioGroup;
import com.extjs.gxt.ui.client.widget.form.TextField;
import com.extjs.gxt.ui.client.widget.layout.FormData;
import com.google.gwt.event.dom.client.ErrorEvent;
import com.google.gwt.event.dom.client.ErrorHandler;
import com.google.gwt.event.dom.client.KeyCodes;
import com.google.gwt.i18n.client.DateTimeFormat;
import com.google.gwt.json.client.JSONObject;
import com.google.gwt.json.client.JSONParser;
import com.google.gwt.json.client.JSONValue;
import com.google.gwt.user.client.rpc.AsyncCallback;
import com.google.gwt.user.client.ui.Image;
import com.hkah.client.common.Factory;
import com.hkah.client.event.CallbackListener;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboACMCode;
import com.hkah.client.layout.combobox.ComboADMType;
import com.hkah.client.layout.combobox.ComboARCompany;
import com.hkah.client.layout.combobox.ComboBirthOrdSPG;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.combobox.ComboCategory;
import com.hkah.client.layout.combobox.ComboCoPayRefType;
import com.hkah.client.layout.combobox.ComboCountry;
import com.hkah.client.layout.combobox.ComboDoctor;
import com.hkah.client.layout.combobox.ComboEduLvl;
import com.hkah.client.layout.combobox.ComboEhrExactDobInd;
import com.hkah.client.layout.combobox.ComboEhrPmiDocType;
import com.hkah.client.layout.combobox.ComboLanguage;
import com.hkah.client.layout.combobox.ComboLocation;
import com.hkah.client.layout.combobox.ComboMSTS;
import com.hkah.client.layout.combobox.ComboMarketingSource;
import com.hkah.client.layout.combobox.ComboPackage;
import com.hkah.client.layout.combobox.ComboRace;
import com.hkah.client.layout.combobox.ComboRelationship;
import com.hkah.client.layout.combobox.ComboReligious;
import com.hkah.client.layout.combobox.ComboSex;
import com.hkah.client.layout.combobox.ComboSource;
import com.hkah.client.layout.combobox.ComboTitle;
import com.hkah.client.layout.dialog.DlgARCardRemark;
import com.hkah.client.layout.dialog.DlgARCardTypeSel;
import com.hkah.client.layout.dialog.DlgBookingList;
import com.hkah.client.layout.dialog.DlgBudgetEstBase;
import com.hkah.client.layout.dialog.DlgDoctorInstruction;
import com.hkah.client.layout.dialog.DlgEhrPmiDupl;
import com.hkah.client.layout.dialog.DlgMedicalRecord;
import com.hkah.client.layout.dialog.DlgNoOfLabel;
import com.hkah.client.layout.dialog.DlgNoOfLblToBePrt;
import com.hkah.client.layout.dialog.DlgPatSecCheck;
import com.hkah.client.layout.dialog.DlgPatientDuplicate;
import com.hkah.client.layout.dialog.DlgPrintAddress;
import com.hkah.client.layout.dialog.DlgPrintPatietCard;
import com.hkah.client.layout.dialog.DlgPrintUKCert;
import com.hkah.client.layout.dialog.DlgPrtCallChart;
import com.hkah.client.layout.dialog.DlgSlipList;
import com.hkah.client.layout.dialog.DlgTicketNumber;
import com.hkah.client.layout.dialog.DlgTodayAppAlert;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.label.LabelSmallBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.TabbedPaneBase;
import com.hkah.client.layout.radiobutton.RadioButtonBase;
import com.hkah.client.layout.table.EditorTableList;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextAmount;
import com.hkah.client.layout.textfield.TextAreaBase;
import com.hkah.client.layout.textfield.TextBedSearch;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextDateTimeWithoutSecond;
import com.hkah.client.layout.textfield.TextDoctorSearch;
import com.hkah.client.layout.textfield.TextEmail;
import com.hkah.client.layout.textfield.TextName;
import com.hkah.client.layout.textfield.TextNameChinese;
import com.hkah.client.layout.textfield.TextPassport;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.ActionPanel;
import com.hkah.client.tx.transaction.TransactionDetail;
import com.hkah.client.util.AppStmtUtil;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.EhrUtil;
import com.hkah.client.util.PanelUtil;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsGlobal;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsRegistration;
import com.hkah.shared.constants.ConstantsTableColumn;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class Patient extends ActionPanel implements ConstantsRegistration, ConstantsTableColumn {
	/**
	 *
	 */
	private static final long serialVersionUID = 1L;
	private static final String SAME_AS_ABOVE = "SAME AS ABOVE";
	private static final String HTTP_URL_PREFIX = "http://";
	private static final String CONSENT_URL_SUFFIX = "/intranet/hat/patient_consent.jsp?patno=";
	private static final String FTOCC_URL_SUFFIX = "/intranet/FTOCC/FTOCC_entry.jsp?system=HATS&regid=";
	private static final String APPADMIN_URL_SUFFIX = "/intranet/mobile/appUserAdmin.jsp?from=hats&patNo=";
	private static final String FTOCC_URL_SUFFIX_USER = "&user=";
	private static String SERVER_PATH = null;
	private static String DEFAULT_NO_IMAGE = null;
	private static String CONSENT_URL = null;
	private static String FTOCC_URL = null;
	private static String APPADMIN_URL = null;

	// Current Display Patient No
	private String currentPatNo = null;
	private String memRegStatus = null;

	// keep the master action type when go to the registration for reusing
	// registration variable
	private String registrationType = null;
	private ComboPackage comboPackage = null;
	private int rtvOldTabIndex = 0; // Previous tab index
	private String memLockBed = null;

	private String memActID = null;
	private String memPBORemark = null;
	private String isNewBorn = null; // store for checkEbirthDtl()
	private String isAppend = null; // for new patient to store type
	private String ticketNo = null;
	private boolean hasPatImage = false;

	private String memModeP = null;                // Current Mode of Operation for Pat. (Search/Edit/Add)
	private String memModeR = null;                // Current Mode of Operation for Reg. (Search/Edit/Add)
	private String memModeI = null;                // Current Mode of Operation for Inf. (Search/Edit/Add)
	private String memModeE = null; 			   // Current Mode of Operation for eHR. (Search/Edit/Add)
	private String memModeC = null; 			   // Current Mode of Operation for consent. (Search/Edit/Add)
	private String memRegMode = null;              // Current Registration Mode  (Browse/Inpat/Outpat(Walkin,Priority,Normal)/Daycase)
	private boolean memFromBk = false;
	private boolean memPreBooking = false;
	private boolean memOBBook1 = false;
	private String memAlertClinic = null;
	private String memPkgCode = null;
	private String memBPBPkgCode = null;
	private String memPBPID = null;
//	private String memCallForm = null;
	private String memPatNo = null;
	private String memOldPatNo = null;
	private String memBkgID = null;
	private String memBkgRmk = null;
	private String memDocCode = null;
	private String memRegID = null;
	private String memRegID_L = null;
	private String memRegID_C = null;
	private String memSTAYLEN = null;
	private String memPre_voucher = null;
	private String memPre_authno = null;
	private String memPre_form = null;
	private String memPre_PBID = null;
	private String memPre_ArcCode = null;
//	private String memPre_COPAYTYP = null;
//	private String memPre_CoPayamt = null;
//	private String memPre_POLICY = null;
//	private String memPre_ARLMTAMT = null;
//	private String memPre_CVREDATE = null;
//	private String memPre_FURGRTAMT = null;
//	private String memPre_FURGRTDATE = null;
//	private String memPre_isDoctor = null;
//	private String memPre_isSpecial = null;
//	private String memPre_isHospital = null;
//	private String memPre_isOther = null;
	private String memPre_PBMID = null;
	private String memPre_PBSNO = null;
	private String memPre_PBSID = null;
//	private String memPre_PBMCODE = null;
	private String memPre_ACTID = null;
//	private String memPre_ACTYPE = null;
	private String memPre_ISRECLG = null;
	private String memPre_ARACMCODE = null;
	private String memPre_PBPKGCODE = null;
	private String memPre_PBESTGIVN = null;
	private String memPre_DEDUCTIBLE = null;
	private String mem_FESTID = null;
	private String mem_FESTBE = null;
	private String memPre_docCode = null;
	private String memWBLblType = null;
	private String memPatFName = null;
	private String memPatLongFName = null;
	private String memPatLongGName = null;
	private String memPatGName = null;
	private String memPat_CName = null;

	// for couter checking
	private String oldPatGName = null;
	private String oldPatFName = null;
	private String oldPat_CName = null;
	private String oldPatDocID = null;
	private String oldPatDocType = null;
	private String oldPatDOB = null;
	private String oldPatSex = null;
	private String oldPatDocA1ID = null;
	private String oldPatDocA1Type = null;
	private String oldPatDocA2ID = null;
	private String oldPatDocA2Type = null;

	private String memPrintDate = null;
	private String memAdmissionDate = null;
	private String tmpOTAid = null;

	// old value
	private String memLimitAmt = EMPTY_VALUE;
	private String memCoPayType = EMPTY_VALUE;
	private String memCoPayAmt = EMPTY_VALUE;
	private String memCvrEndDate = EMPTY_VALUE;
	private String memCvrItem = EMPTY_VALUE;
	private String memGrtAmt = EMPTY_VALUE;
	private String memGrtDate = EMPTY_VALUE;

	private DlgARCardRemark dlgARCardRemark = null;
	private DlgARCardTypeSel dlgARCardTypeSel = null;
	private DlgSlipList DlgSlipList = null;
	private DlgDoctorInstruction dlgDoctorInstruction = null;
	private DlgPrintAddress dlgPrintAddress = null;
	private DlgNoOfLblToBePrt dlgNoOfLblToBePrtInp = null;
	private DlgNoOfLblToBePrt dlgNoOfLblToBePrtOutp = null;
	private DlgNoOfLabel dlgPrintPatientLabel = null;
	private DlgPrtCallChart dlgPrtCallChart = null;
	private DlgPrintPatietCard dlgPrintPatientCard = null;
	private DlgMedicalRecord dlgMedicalRecord = null;
	private DlgEhrPmiDupl dlgEhrPmiDupl = null;
	private DlgPatientDuplicate duplicateDialog;
	private DlgTodayAppAlert dlgTodayAppAlert = null;
	private DlgTicketNumber dlgTicketNumber = null;
	private DlgBookingList dlgBookingList = null;


//	private boolean modalResult = false;
	private boolean isNewPatientEmptyField = false;
	private boolean isPrompt_ChangeShortPatName = false;
	private boolean isPrompt_ChangeLongPatName = false;
	private boolean isPrompt_ChangeBedHistory = false;
	private boolean isConfirmPatInfChg = false;

	final private int birthDayRange = 3;
//	private String oldRegMode = null;
	private ButtonBase masterTabBtn = null;
	private ButtonBase regTabBtn = null;
	private ButtonBase addInfoTabBtn = null;
	private ButtonBase eHrTabBtn = null;
	private ButtonBase consentTabBtn = null;

	boolean isTabConsent = false;
	boolean isTabFTOCC = false;
	boolean isTabApp = false;

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		if (isRegFlag()) {
			return ConstantsTx.PATIENT_REG_TXCODE;
		} else if (isEhrFlag()) {
			return ConstantsTx.EHR_PMI_TXCODE;
		} else if (isConsentFlag()) {
			return ConstantsTx.PATIENT_CONSENT_TXCODE;
		} else {
			return ConstantsTx.PATIENT_TXCODE;
		}
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.PATIENT_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return null;
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return null;
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */

	private BasePanel actionPanel = null;
	private BasePanel generalPanel = null;
	private BasePanel RTPanel = null; // right top panel
	private ButtonBase RTJLabel_PATNO = null;
	private TextPatientNoSearch RTJText_PatientNumber = null;
	private LabelSmallBase RTJLabel_PATName = null;
	private TextReadOnly RTJText_PatientName = null; // right top patient foreign name
	private TextReadOnly RTJText_PATCName = null; // right top patient Chinese name
	private LabelSmallBase RTJLabel_Sex = null;
	private LabelSmallBase RTJLabel_DentalPatientNo = null;
	private TextReadOnly RTJText_Sex = null;
	private TextString RTJText_DentalPatientNo = null;

	private TabbedPaneBase RBTPanel = null; // right bottom tabbedpane

	// Master Panel
	private BasePanel MasterPanel = null;
	private FieldSetBase PersonalPanel = null; // Master Personal Information
	private LabelSmallBase PJLabel_IDPassportNO = null;
	private TextPassport PJText_IDPassportNO = null;
	private LabelSmallBase PJLabel_DocType = null;
	private ComboBoxBase PJCombo_DocType = null;

	private LabelSmallBase PJLabel_IDPassportNO_S1 = null;
	private TextPassport PJText_IDPassportNO_S1 = null;
	private LabelSmallBase PJLabel_DocType_S1 = null;
	private ComboBoxBase PJCombo_DocType_S1 = null;

	private LabelSmallBase PJLabel_IDPassportNO_S2 = null;
	private TextPassport PJText_IDPassportNO_S2 = null;
	private LabelSmallBase PJLabel_DocType_S2 = null;
	private ComboBoxBase PJCombo_DocType_S2 = null;

	private LabelSmallBase AJLabel_IDCountry = null;
	private ComboCountry AJCombo_IDCountry = null;
	private LabelSmallBase AJLabel_IDCountry_S1 = null;
	private ComboCountry AJCombo_IDCountry_S1 = null;
	private LabelSmallBase AJLabel_IDCountry_S2 = null;
	private ComboCountry AJCombo_IDCountry_S2 = null;
	private LabelSmallBase PJLabel_FamilyName = null;
	private TextName PJText_FamilyName = null;

	private LabelSmallBase PJLabel_Title = null;
	private ComboTitle PJCombo_Title = null;

	private LabelSmallBase PJLabel_GivenName = null;
	private TextName PJText_GivenName = null;
	private LabelSmallBase PJLabel_ChineseName = null;
	private TextNameChinese PJText_ChineseName = null;
	private LabelSmallBase PJLabel_MSTS = null; // personal Jlabel martial status
	private ComboMSTS PJCombo_MSTS = null;
	private LabelSmallBase PJLabel_MaidenName = null;
	private TextName PJText_MaidenName = null;
	private LabelSmallBase PJLabel_Race = null;
	private ComboRace PJCombo_Race = null;
	private LabelSmallBase PJLabel_Birthday = null;
	private TextDate PJText_Birthday = null;
	private LabelSmallBase PJLabel_Age = null;
	private TextReadOnly PJText_Age = null;
	private LabelSmallBase PJLabel_BirthOrdSPG = null;
	private ComboBirthOrdSPG getPJCombo_BirthOrdSPG = null;
	private LabelSmallBase PJLabel_MotherLanguage = null;
	private ComboLanguage PJCombo_MotherLanguage = null;
	private LabelSmallBase PJLabel_Sex = null;
	private ComboSex PJCombo_Sex = null;
	private LabelSmallBase PJLabel_EduLvl = null;
	private ComboEduLvl PJCombo_EduLvl = null;
	private LabelSmallBase PJLabel_Death = null;
	private TextDate PJText_Death = null;
	private LabelSmallBase PJLabel_Religious = null;
	private ComboReligious PJCombo_Religious = null;
	private ButtonBase PJButton_UpdateDeathDate = null;
	private LabelSmallBase PJLabel_Occupation = null;
	private TextString PJText_Occupation = null;
	private LabelSmallBase PJLabel_MiscRemark = null;
	private TextString PJText_MiscRemark = null;
	private LabelSmallBase PJLabel_MotherRecord = null;
	private TextPatientNoSearch PJText_MotherRecord = null;
	private LabelSmallBase PJLabel_NewBorn = null;
	private CheckBoxBase PJCheckBox_NewBorn = null;
	private LabelSmallBase PJLabel_MRRemark = null;
	private TextString PJText_MRRemark = null;
	private LabelSmallBase PJLabel_MarketingSource = null;
	private ComboMarketingSource PJCombo_MarketingSource = null;
	private LabelSmallBase PJLabel_MarketingRemark = null;
	private TextString PJText_MarketingRemark = null;
	private LabelSmallBase PJLabel_Active = null;
	private CheckBoxBase PJCheckBox_Active = null;
	private LabelSmallBase PJLabel_Interpreter = null;
	private CheckBoxBase PJCheckBox_Interpreter = null;
	private LabelSmallBase PJLabel_Staff = null;
	private CheckBoxBase PJCheckBox_Staff = null;
	private LabelSmallBase PJLabel_SMS = null;
	private CheckBoxBase PJCheckBox_SMS = null;
	private LabelSmallBase PJLabel_CheckID = null;
	private CheckBoxBase PJCheckBox_CheckID = null;
	private TextReadOnly PJText_CheckIDLastUpdatedDate = null;
	private TextReadOnly PJText_CheckIDLastUpdatedBy = null;

	private FieldSetBase AddressPanel = null; // Master Address Information
	private LabelSmallBase AJLabel_Email = null;
	private TextEmail AJText_Email = null;
	private LabelSmallBase AJLabel_HomePhone = null;
	private TextString AJText_HomePhone = null;
	private LabelSmallBase AJLabel_MobCouCode = null;
	private ComboCountry AJCombo_MobCouCode = null;
	private LabelSmallBase AJLabel_OfficePhone = null;
	private TextString AJText_OfficePhone = null;
	private LabelSmallBase AJLabel_Mobile = null;
	private TextString AJText_Mobile = null;
	private LabelSmallBase AJLabel_FaxNO = null;
	private TextString AJText_FaxNO = null;
	private LabelSmallBase AJLabel_ADDR = null;
	private TextString AJText_ADDR1 = null;
	private TextString AJText_ADDR2 = null;
	private TextString AJText_ADDR3 = null;
	private LabelSmallBase AJLabel_Location = null;
	private ComboLocation AJCombo_Location = null;
	private LabelSmallBase AJLabel_District = null;
	private TextReadOnly AJText_District = null;
	private LabelSmallBase AJLabel_Country = null;
	private ComboCountry AJCombo_Country = null;
	private LabelSmallBase AJLabel_Remark = null;
	private TextString AJText_Remark = null;
	private LabelSmallBase AJLabel_LastUpdated = null;
	private TextReadOnly AJText_LastUpdatedDate = null;
	private TextReadOnly AJText_LastUpdatedBy = null;
	private LabelSmallBase AJLabel_MobileUser = null;
	private TextReadOnly AJText_MobileUser = null;
	private TextReadOnly AJText_MobileDate = null;
	private ButtonBase AButton_Alert = null;
	private ButtonBase AButton_PrintBasicinfoSheet = null;
	private ButtonBase AButton_PrintLabel = null;
	private ButtonBase AButton_PrintAddr = null;

	private FieldSetBase RelativePanel = null; // Master Relative info.
	private LabelSmallBase RJLabel_KinName = null;
	private TextString RJText_KinName = null;
	private LabelSmallBase RJLabel_HomeTel = null;
	private TextString RJText_HomeTel = null;
	private LabelSmallBase RJLabel_Pager = null;
	private TextString RJText_Pager = null;
	private LabelSmallBase RJLabel_Relationship = null;
	private ComboRelationship RJText_Relationship = null;
	private LabelSmallBase RJLabel_OfficeTel = null;
	private TextString RJText_OfficeTel = null;
	private LabelSmallBase RJLabel_Mobile = null;
	private TextString RJText_Mobile = null;
	private LabelSmallBase RJLabel_Email = null;
	private TextEmail RJText_Email = null;
	private LabelSmallBase RJLabel_Address = null;
	private TextString RJText_Address = null;
	private LabelSmallBase RJLabel_SameAsAbove = null;
	private CheckBoxBase RJCheckBox_SameAsAbove = null;

	// Registration Panel
	private BasePanel regPanel = null; // Registration Panel
	private FieldSetBase RegTypePanel = null; // registration type panel
	private RadioButtonBase RTJRadio_OutPatient = null;
	private LabelSmallBase RTJLabel_OutPatient = null;
	private RadioButtonBase RTJRadio_DayCasePatient = null;
	private LabelSmallBase RTJLabel_DayCasePatient = null;
	private RadioButtonBase RTJRadio_InPatient = null;
	private LabelSmallBase RTJLabel_InPatient = null;
	private LabelSmallBase RTJLabel_OutPatientType = null;
	private TextReadOnly RTJText_OutPatientType = null;
	private RadioGroup RegTypeGR = null;

	private FieldSetBase InPatInfoPanel = null; // InPatient Information panel;
	private LabelSmallBase INJLabel_BedNo = null;
	private TextBedSearch INJText_BedNo = null; //BEDCODE
	private TextReadOnly INJText_BedIsWindow = null;
	private LabelSmallBase INJLabel_DeptCode = null;
	private TextReadOnly INJText_DeptCode = null;
	private TextReadOnly INJText_BedCharge = null;
	private LabelSmallBase INJLabel_WardType = null;
	private TextReadOnly INJText_WardType = null;
	private LabelSmallBase INJLabel_AcmCode = null;
	private ComboACMCode INJCombo_AcmCode = null;
	private TextReadOnly INJText_AcmCode = null;
	private LabelSmallBase INJLabel_NewBorn = null;
	private CheckBoxBase INJCheckBox_NewBorn = null;
	private LabelSmallBase INJLabel_Mom = null;
	private RadioButtonBase RTJRadio_MainLand = null;
	private LabelSmallBase RTJLabel_MainLand = null;
	private RadioButtonBase RTJRadio_NonMainland = null;
	private LabelSmallBase RTJLabel_NonMainland = null;
	private BasePanel FromMainlandPanel = null; // Mother from mainland panel;
	private RadioGroup RTJRadioGroup_FromMainlandGR = null; // Mother from mainland
	private LabelSmallBase INJLabel_ADMDoctor = null;
	private TextDoctorSearch INJText_ADMDoctor = null;
	private TextReadOnly INRJText_ADMDoctor = null;
	private LabelSmallBase INJLabel_RefDoctor1 = null;
	private TextDoctorSearch INJText_RefDoctor1 = null;
	private TextReadOnly INRJText_RefDoctor1 = null;
	private LabelSmallBase INJLabel_RefDoctor2 = null;
	private TextDoctorSearch INJText_RefDoctor2 = null;
	private TextReadOnly INRJText_RefDoctor2 = null;
	private LabelSmallBase INJLabel_ADMDate = null;
	private TextDateTimeWithoutSecond INJText_ADMDate = null;
	private LabelSmallBase INJLabel_ADMFrom = null;
	private ComboSource INJCombo_ADMFrom = null;
	private LabelSmallBase INJLabel_ADMType = null;
	private ComboADMType INJCombo_ADMType = null;
	private LabelSmallBase INJLabel_Remark = null;
	private TextString INJText_Remark = null;
	private LabelSmallBase INJLabel_RmExt = null;
	private TextReadOnly INJText_RmExt = null;
	private LabelSmallBase INJLabel_SpRqt = null;
	private ComboBoxBase INJCombo_SpRqt = null;
	private LabelSmallBase INJLabel_Package = null;
	private ComboBoxBase INJCombo_Package = null;
	private LabelSmallBase PJLabel_EstGiven = null;
	private CheckBoxBase PJCheckBox_EstGiven = null;
	private ButtonBase RightButton_BudgetEst = null;
	private DlgBudgetEstBase dlgBudgetEst = null;
	private DlgPatSecCheck dlgPatSecCheck = null;
	private LabelSmallBase PJCheckBox_BEDesc = null;
	private CheckBoxBase PJCheckBox_BE = null;
	private LabelBase RTCombo_docRoomDesc = null;
	private ComboBoxBase RTCombo_docRoom = null;
	private LabelBase RTCombo_natureDesc = null;
	private ComboBoxBase RTCombo_nature = null;
	private LabelSmallBase INJLabel_MedRec = null;
	private TextReadOnly INJText_Med = null;
	private TextReadOnly INJText_Rec = null;
	private ButtonBase INButton_MedRec = null;
	private LabelSmallBase INJLabel_SLPNO = null;
	private TextReadOnly INJText_SLPNO = null;
	private ButtonBase INButton_SlipDetail = null;
	private LabelSmallBase INJLabel_RDate = null;
	private TextDateTimeWithoutSecond INJText_RegDate = null;
	private LabelSmallBase INJLabel_Category = null;
	private ComboCategory INJCombo_Category = null;
	private TextReadOnly INJText_Category = null;
	private LabelSmallBase INJLabel_Ref = null;
	private TextString INJText_Ref = null;
	private LabelSmallBase INJLabel_Source = null;
	private ComboBoxBase INJCombo_Source = null;
	private LabelSmallBase INJLabel_SourceNo = null;
	private TextString INJText_SourceNo = null;
	private LabelSmallBase RightJLabel_Misc = null;
	private ComboBoxBase RightJCombo_Misc = null;
	private LabelSmallBase INJLabel_ARC = null;
	private ComboARCompany INJCombo_ARC = null;
	private TextReadOnly INJText_ARC = null;
	private TextReadOnly INJText_ARCardType = null;
	private LabelSmallBase INJLabel_PLNO = null;
	private TextString INJText_PLNO = null;
	private LabelSmallBase INJLabel_VHNO = null;
	private TextString INJText_VHNO = null;
	private LabelSmallBase INJLabel_PreAuthNo = null;
	private TextString INJText_PreAuthNo = null;
	private LabelSmallBase INJLabel_LAmt = null;
	private TextAmount INJText_LAmt = null;
	private LabelSmallBase INJLabel_Deduct = null;
	private TextAmount INJText_Deduct = null;
	private LabelSmallBase INJLabel_endDate = null;
	private TextDate INJText_endDate = null;
	private LabelSmallBase INJLabel_CPAmt = null;
	private ComboCoPayRefType INJCombo_CPAmt = null;
	private TextAmount INJText_CPAmt = null;
	private LabelSmallBase INJLabel_CoveredItem = null;
	private LabelSmallBase INJLabel_Doctor = null;
	private CheckBoxBase INJCheckBox_Doctor = null;
	private LabelSmallBase INJLabel_Hospital = null;
	private CheckBoxBase INJCheckBox_Hspital = null;
	private LabelSmallBase INJLabel_Special = null;
	private CheckBoxBase INJCheckBox_Special = null;
	private LabelSmallBase INJLabel_Other = null;
	private CheckBoxBase INJCheckBox_Other = null;
	private LabelSmallBase INJLabel_PrtMedRecordRpt = null;
	private CheckBoxBase INJCheckBox_PrtMedRecordRpt = null;
	private LabelSmallBase INJLabel_FGAmt = null;
	private TextAmount INJText_FGAmt = null;
	private LabelSmallBase INJLabel_FGDate = null;
	private TextDate INJText_FGDate = null;
	private LabelSmallBase INJLabel_LengthOfStay = null;
	private TextString INJText_LengthOfStay = null;
	private LabelSmallBase INJLabel_RevLog = null;
	private CheckBoxBase INJCheckBox_RevLog = null;
	private LabelSmallBase INJLabel_LogCvrCls = null;
	private ComboACMCode INJCombo_LogCvrCls = null;
	private LabelSmallBase INJLabel_NVTD = null;
	private TextDoctorSearch INJText_TreDrCode = null;
	private ComboDoctor INJCombo_TreDrCode = null;
	private TextReadOnly INJText_TreDrName = null;
	private ButtonBase INButton_AddNature = null;
	private EditorTableList RegDtorTable = null;

	// Additional Panel
	private BasePanel additInfoPanel = null;
	private BasePanel AdditInfoLeftPanel = null; // additional info left panel
	private BasePanel AdditInfoRightPanel = null; // additional info right panel
	private LabelSmallBase Label_LongFName = null;
	private TextAreaBase Text_LongFName = null;
	private LabelSmallBase Label_LongGName = null;
	private TextAreaBase Text_LongGName = null;
	private LabelSmallBase Label_CreateSiteCode = null;
	private TextReadOnly INJText_CreateSiteCode = null;
	private LabelSmallBase Label_PatientRmk = null;
	private LabelSmallBase Label_PatientRmkUnderLine = null;
	private LabelSmallBase Label_RmkLastUptBy = null;
	private LabelSmallBase Label_RmkLastUptByText = null;
	private LabelSmallBase Label_RmkLastUptTime = null;
	private LabelSmallBase Label_RmkLastUptTimeText = null;
	private TextAreaBase TextArea_PatientRmk = null;
	private BasePanel imgDocPanel = null;

	// eHR Panel
	private BasePanel ehrPanel = null;
	private FieldSetBase ehrPmiPanel = null;
	private FieldSetBase ehrEnrollHistPanel = null;
	private LabelSmallBase EJLabel_FName = null;
	private TextName EJText_FName = null;
	private LabelSmallBase EJLabel_GName = null;
	private TextName EJText_GName = null;
	private LabelSmallBase EJLabel_Dob = null;
	private TextDate EJText_Dob = null;
	private ComboEhrExactDobInd EJCombo_ehrExactDobInd = null;
	private LabelSmallBase EJLabel_Sex = null;
	private ComboSex EJCombo_Sex = null;
	private LabelSmallBase EJLabel_HKID = null;
	private TextString EJText_HKID = null;
	private LabelSmallBase EJLabel_docType = null;
	private ComboEhrPmiDocType EJCombo_docType = null;
	private LabelSmallBase EJLabel_docTypeAlert = null;
	private LabelSmallBase EJLabel_docNo = null;
	private TextString EJText_docNo = null;
	private LabelSmallBase EJLabel_cEhrNo = null;
	private TextString EJText_cEhrNo = null;
	private LabelSmallBase EJLabel_NBRegID = null;
	private TextReadOnly EJText_NBRegID = null;
	private LabelSmallBase EJLabel_Death = null;
	private TextDate EJText_Death = null;
	private LabelSmallBase EJLabel_cEhrActive = null;
	private TableList ehrEnrollHistTable = null;
	private Image Image_eHRLogo = null;
	private BasePanel eHRLogoPanel = null;
	private ButtonBase ehrCopyLatestPInfoBtn = null;
	private ButtonBase ehrSendMatchMsgBtn = null;
	private ButtonBase ehrEnrolButton = null;
	private Window ehrSendMatchMsgWin = null;

	// Consent Panel
	private BasePanel consentPanel = null;
	private FieldSetBase consentInfoPanel1 = null;
	private LabelSmallBase CSJLabel_DateStart1 = null;
	private TextDate CSJText_DateStart1 = null;
	private LabelSmallBase CSJLabel_DateTo1 = null;
	private TextDate CSJText_DateTo1 = null;
	private LabelSmallBase CSJLabel_ArCode1 = null;
	private ComboARCompany CSJText_ArCode1 = null;
	private LabelSmallBase CSJLabel_Remark1 = null;
	private TextString CSJText_Remark1 = null;
	private LabelSmallBase CSJLabel_ConsentDoc1 = null;
	private ButtonBase CSJButton_ConsentDoc1 = null;
	private LabelSmallBase CSJLabel_LastUptBy1 = null;
	private TextReadOnly CSJText_LastUptBy1 = null;
	private LabelSmallBase CSJLabel_LastUptTime1 = null;
	private TextReadOnly CSJText_LastUptTime1 = null;

	private FieldSetBase consentInfoPanel2 = null;
	private LabelSmallBase CSJLabel_DateStart2 = null;
	private TextDate CSJText_DateStart2 = null;
	private LabelSmallBase CSJLabel_DateTo2 = null;
	private TextDate CSJText_DateTo2 = null;
	private LabelSmallBase CSJLabel_ArCode2 = null;
	private ComboARCompany CSJText_ArCode2 = null;
	private LabelSmallBase CSJLabel_Remark2 = null;
	private TextString CSJText_Remark2 = null;
	private LabelSmallBase CSJLabel_ConsentDoc2 = null;
	private ButtonBase CSJButton_ConsentDoc2 = null;
	private LabelSmallBase CSJLabel_LastUptBy2 = null;
	private TextReadOnly CSJText_LastUptBy2 = null;
	private LabelSmallBase CSJLabel_LastUptTime2 = null;
	private TextReadOnly CSJText_LastUptTime2 = null;

	private FieldSetBase consentInfoPanel3 = null;
	private LabelSmallBase CSJLabel_DateStart3 = null;
	private TextDate CSJText_DateStart3 = null;
	private LabelSmallBase CSJLabel_DateTo3 = null;
	private TextDate CSJText_DateTo3 = null;
	private LabelSmallBase CSJLabel_ArCode3 = null;
	private ComboARCompany CSJText_ArCode3 = null;
	private LabelSmallBase CSJLabel_Remark3 = null;
	private TextString CSJText_Remark3 = null;
	private LabelSmallBase CSJLabel_ConsentDoc3 = null;
	private ButtonBase CSJButton_ConsentDoc3 = null;
	private LabelSmallBase CSJLabel_LastUptBy3 = null;
	private TextReadOnly CSJText_LastUptBy3 = null;
	private LabelSmallBase CSJLabel_LastUptTime3 = null;
	private TextReadOnly CSJText_LastUptTime3 = null;

	private FieldSetBase consentInfoPanel4 = null;
	private TextAreaBase TextArea_InsuranceRmk = null;

	private ButtonBase CSButton_BillingHistory = null;

	// FTOCC Panel
	private BasePanel FTOCCPanel = null;
	
	private BasePanel appAdminPanel = null;

	private ButtonBase INButton_MedRecDetail = null;
	private ButtonBase INButton_AdmFrm = null;
	private ButtonBase INButton_PrintLabel = null;
	private ButtonBase INButton_PrintChartLabel = null; // print call chart label
	private ButtonBase INButton_PrintOTHandOver = null; // print OT HandOver
//	private ButtonBase INButton_Inpat = null; // transfer to inpatient
	private ButtonBase INButton_PrintWristbandLabel = null;
	private ButtonBase INButton_PrintBillingHistory = null;
	private ButtonBase INButton_MasBillingHistory = null;
	private ButtonBase INButton_PrintBilling = null;
	private ButtonBase INButton_PatientCardBtn = null;
	private ButtonBase INButton_IPGeneralLblBtn = null;
	private ButtonBase INButton_DlgPrtCallChartButton = null;
	private ButtonBase INButton_UKCert = null;
	private DlgPrintUKCert dlgPrintUKCert = null;
	private ButtonBase INButton_PrintEShare = null;
	private BasePanel RegRBPanel = null; // registration right bottom panel;

	private Image Image_PatImage = null;
	private String currentArcCode = null;
	private boolean addNewPatient = false;
	private boolean addNewVolume = false;
	private String memNewPatientNo = null;

	private String memPcyCode = null;
	private String memArcCode = null;
	private boolean saving = false;
	private boolean skipBedChecking = false;
	private boolean skipCreateSlip = false;
	private ButtonBase INButton_RegLabelBtn = null;
	private ButtonBase INButton_IdtLabelBtn = null;

	/**
	 * This method initializes
	 *
	 */
	public Patient() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		super.init();
		/* >>> ~7.1~ Init action (e.g. Listing, Init Comobbox ========= <<< */
		//setFullEntry(true);

		// set field enable
		/* >>> ~4.2~ Disable Add/Modify/Delete Buttons ================ <<< */
		setDeleteButtonEnabled(false);
		return true;
	}

	@Override
	public void rePostAction() {
		showPatient(memPatNo);
		super.rePostAction();
	}

	private void initVariables() {
		memPre_ArcCode = EMPTY_VALUE;
		memPre_voucher = EMPTY_VALUE;
		memPre_authno = EMPTY_VALUE;
		memPre_docCode = EMPTY_VALUE;
		memPre_PBMID = EMPTY_VALUE;
		memPre_PBSNO = EMPTY_VALUE;
		memPre_PBSID = EMPTY_VALUE;
//		memPre_PBMCODE = EMPTY_VALUE;
		memPre_ACTID = EMPTY_VALUE;
//		memPre_ACTYPE = EMPTY_VALUE;
		memPre_ISRECLG  = EMPTY_VALUE;
		memPre_ARACMCODE = EMPTY_VALUE;
		memPre_PBPKGCODE = EMPTY_VALUE;
		memPre_DEDUCTIBLE  = EMPTY_VALUE;
		mem_FESTID = EMPTY_VALUE;
		mem_FESTBE = EMPTY_VALUE;
		memPre_form = getParameter("CallForm");
		memPre_PBID = getParameter("CurrentPBPId");
		memPreBooking = "YES".equals(getParameter("isPreBooking"));
		memOBBook1 = "YES".equals(getParameter("FromOBBook1"));
		memPatFName = getParameter("pat_Fname");
		memPatGName = getParameter("pat_Gname");
		memPat_CName = getParameter("pat_Cname");
		memPBORemark =	getParameter("PBORemark");
		memSTAYLEN = getParameter("STAYLEN");
		memAlertClinic = getParameter("isAlertClinic");

		oldPatGName = EMPTY_VALUE;
		oldPatFName = EMPTY_VALUE;
		oldPat_CName = EMPTY_VALUE;
		oldPatDocID = EMPTY_VALUE;
		oldPatDocType = EMPTY_VALUE;
		oldPatDOB = EMPTY_VALUE;
		oldPatDocA1ID = EMPTY_VALUE;
		oldPatDocA1Type = EMPTY_VALUE;
		oldPatDocA2ID = EMPTY_VALUE;
		oldPatDocA2Type = EMPTY_VALUE;
		

		setRegistrationMode(EMPTY_VALUE);
		memRegID = EMPTY_VALUE;
		memRegID_L = EMPTY_VALUE;
		memRegID_C = EMPTY_VALUE;
		memDocCode = EMPTY_VALUE;
		memBedCode = EMPTY_VALUE;
		memBkgID = EMPTY_VALUE;
		memBkgRmk = EMPTY_VALUE;
		memLockBed = EMPTY_VALUE;
		memWBLblType = EMPTY_VALUE;
		memPatLongFName = EMPTY_VALUE;
		memPatLongGName = EMPTY_VALUE;
		memAdmissionDate = EMPTY_VALUE;

		memPBPID = EMPTY_VALUE;
//		memCallForm = EMPTY_VALUE;
		memPkgCode = EMPTY_VALUE;
		memPatNo = EMPTY_VALUE;
		memOldPatNo = EMPTY_VALUE;
		memFromBk = "bkgz".equals(getParameter("FromBk"));
		memRegStatus = null;

		currentPatNo = null;
		setRecordFound(false);
		resetAllActionType();
		currentArcCode = null;
		addNewPatient = false;
		addNewVolume = false;
		memNewPatientNo = EMPTY_VALUE;
		memPcyCode = EMPTY_VALUE;
		memArcCode = EMPTY_VALUE;

		saving = false;
		skipBedChecking = false;
		skipCreateSlip = false;
	}

	private void setParameterHelper(String parameterName, MessageQueue mQueue, int index) {
		setParameter(parameterName,
				mQueue.getContentField()[index] == null ?
						EMPTY_VALUE : mQueue.getContentField()[index]);
	}

	private void resetParameterHelper(String parameterName) {
		setParameter(parameterName, EMPTY_VALUE);
	}

	private void resetPreBookPatDetail() {
		resetParameterHelper("pre_ArcCode");
		resetParameterHelper("pre_COPAYTYP");
		resetParameterHelper("pre_CoPayamt");
		resetParameterHelper("pre_POLICY");
		resetParameterHelper("pre_ARLMTAMT");
		resetParameterHelper("pre_CVREDATE");
		resetParameterHelper("pre_voucher");
		resetParameterHelper("Pre_FURGRTAMT");
		resetParameterHelper("Pre_FURGRTDATE");
		resetParameterHelper("pre_isDoctor");
		resetParameterHelper("pre_isSpecial");
		resetParameterHelper("Pre_isHospital");
		resetParameterHelper("pre_isOther");
		resetParameterHelper("pre_DOCCODE");
		resetParameterHelper("pre_PBMID");
		resetParameterHelper("pre_PBSNO");
		resetParameterHelper("pre_PBSID");
		resetParameterHelper("pre_PBMCODE");
		resetParameterHelper("pre_ACTID");
		resetParameterHelper("pre_ACTYPE");
		resetParameterHelper("pre_ISRECLG");
		resetParameterHelper("pre_ARACMCODE");
		resetParameterHelper("pre_PBPKGCODE");
//		resetParameterHelper("pre_PBESTGIVN");
		resetParameterHelper("pre_DEDUCTIBLE");
		resetParameterHelper("pre_FESTID");
		resetParameterHelper("pre_FESTBE");
		resetParameterHelper("pre_authno");
		resetParameterHelper("BPBPkgCode");
	}

	private void showPreBookPatDetail(String prePBID) {
		resetPreBookPatDetail();
		if (prePBID != null && prePBID.length() > 0) {
			// set default date
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.PREBOOKDETAIL,
					new String[] { prePBID },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						setParameterHelper("pre_ArcCode", mQueue, 0);
						setParameterHelper("pre_COPAYTYP", mQueue, 1);
						setParameterHelper("pre_CoPayamt", mQueue, 2);
						setParameterHelper("pre_POLICY", mQueue, 3);
						setParameterHelper("pre_ARLMTAMT", mQueue, 4);
						setParameterHelper("pre_CVREDATE", mQueue, 5);
						setParameterHelper("pre_voucher", mQueue, 6);
						setParameterHelper("Pre_FURGRTAMT", mQueue, 7);
						setParameterHelper("Pre_FURGRTDATE", mQueue, 8);
						setParameterHelper("pre_isDoctor", mQueue, 9);
						setParameterHelper("pre_isSpecial", mQueue, 10);
						setParameterHelper("Pre_isHospital", mQueue, 11);
						setParameterHelper("pre_isOther", mQueue, 12);
						setParameterHelper("pre_DOCCODE", mQueue, 13);
						setParameterHelper("pre_PBMID", mQueue, 14);
						setParameterHelper("pre_PBSNO", mQueue, 15);
						setParameterHelper("pre_PBSID", mQueue, 16);
						setParameterHelper("pre_PBMCODE", mQueue, 17);
						setParameterHelper("pre_ACTID", mQueue, 18);
						setParameterHelper("pre_ACTYPE", mQueue, 19);
						setParameterHelper("pre_ISRECLG", mQueue, 20);
						setParameterHelper("pre_ARACMCODE", mQueue, 21);
						setParameterHelper("pre_PBPKGCODE", mQueue, 22);
//						setParameterHelper("pre_PBESTGIVN", mQueue, 23); // no added in previous version
						setParameterHelper("pre_DEDUCTIBLE", mQueue, 24);
						setParameterHelper("pre_FESTID", mQueue, 25);
						setParameterHelper("pre_FESTBE", mQueue, 26);
						setParameterHelper("pre_authno", mQueue, 27);
						setParameterHelper("BPBPkgCode", mQueue, 28);


						setPreBookPatDetail();
					}
					showPreBookPatDetailPost();
				}
			});
		} else {
			setPreBookPatDetail();
			showPreBookPatDetailPost();
		}
	}

	private void setPreBookPatDetail() {
		memPre_ArcCode = getParameter("pre_ArcCode");
//		memPre_COPAYTYP = getParameter("pre_COPAYTYP");
//		memPre_CoPayamt = getParameter("pre_CoPayamt");
//		memPre_POLICY = getParameter("pre_POLICY");
//		memPre_ARLMTAMT = getParameter("pre_ARLMTAMT");
//		memPre_CVREDATE = getParameter("pre_CVREDATE");
		memPre_voucher = getParameter("pre_voucher");
		memPre_authno = getParameter("pre_authno");
//		memPre_FURGRTAMT = getParameter("Pre_FURGRTAMT");
//		memPre_FURGRTDATE = getParameter("Pre_FURGRTDATE");
//		memPre_isDoctor = getParameter("pre_isDoctor");
//		memPre_isSpecial = getParameter("pre_isSpecial");
//		memPre_isHospital = getParameter("Pre_isHospital");
//		memPre_isOther = getParameter("pre_isOther");
		memPre_docCode = getParameter("pre_DOCCODE");
		memPre_PBMID = getParameter("pre_PBMID");
		memPre_PBSNO = getParameter("pre_PBSNO");
		memPre_PBSID = getParameter("pre_PBSID");
//		memPre_PBMCODE = getParameter("pre_PBMCODE");
		memPre_ACTID = getParameter("pre_ACTID");
		memActID = memPre_ACTID;
//		memPre_ACTYPE = getParameter("pre_ACTYPE");
		memPre_ISRECLG = getParameter("pre_ISRECLG");
		memPre_ARACMCODE = getParameter("pre_ARACMCODE");
		memPre_PBPKGCODE = getParameter("pre_PBPKGCODE");
//		memPre_PBESTGIVN = getParameter("pre_PBESTGIVN"); //no added in previous version
		memPre_DEDUCTIBLE = getParameter("pre_DEDUCTIBLE");
		mem_FESTID = getParameter("pre_FESTID");
		mem_FESTBE = getParameter("pre_FESTBE");
		memBPBPkgCode = getParameter("BPBPkgCode");

	}

	private void showPreBookPatDetailPost() {
//		memCallForm = getParameter("CallForm");
		memPatNo = getParameter("PatNo");
		memBkgID = getParameter("BkgID");
		memDocCode = getParameter("DocCode");

		if (memBkgID != null && memBkgID.length() > 0) {
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] { "BOOKING", "BKGRMK", "BKGID='" + memBkgID + "'" },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						memBkgRmk = mQueue.getContentField()[0];
					}
				}
			});
		}
		

		if (memFromBk) {
//			getRTJText_PatientNumber().setEditable(!(memPatNo != null && memPatNo.length() > 0));

			QueryUtil.executeMasterFetch(getUserInfo(),
					ConstantsTx.DOCTOR_TXCODE,
					new String[] { memDocCode },
					new MessageQueueCallBack() {
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						HashMap<String, String> params = new HashMap<String, String>();
						params.put("App. Date", getParameter("BkgSDate"));
						params.put("Doctor Name", mQueue.getContentField()[1] + SPACE_VALUE + mQueue.getContentField()[2]);
						getAlertCheck().checkAltAccess(memPatNo, "Accept Appointment", false, true, params);
					}
				}
			});
		}

		if (memPreBooking) {
//			getRTJText_PatientNumber().setEditable(!(memPatNo != null && memPatNo.length() > 0));

			if (memPatNo == null || memPatNo.length() == 0) {
				QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
						new String[] {"BEDPREBOK", "PATIDNO", "PBPID ='" + memPBPID + "'"},
						new MessageQueueCallBack() {
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							if (mQueue.getContentField()[0] != null && mQueue.getContentField()[0].length() > 0) {
								QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
										new String[] {"PATIENT", "PATNO", "PATIDNO ='" + mQueue.getContentField()[0] + "'"},
										new MessageQueueCallBack() {
									public void onPostSuccess(MessageQueue mQueue) {
										if (mQueue.success()) {
											memPatNo = mQueue.getContentField()[0];

											if (memPatNo != null && memPatNo.length() > 0) {
												showPatient(memPatNo);
												getRTJText_PatientNumber().checkPatientAlert();
												getDlgBookingList().showDialog(memPatNo,(memPreBooking?memPBPID:""),((memBkgID != null && memBkgID.length() > 0)?memBkgID:""));

											} else {
												//memPatno is null
												insertRecordFromBooking();
											}
										} else {
											//memPatno is null
											insertRecordFromBooking();
										}
									}
								});
							} else {
								//memPatno is null
								insertRecordFromBooking();
							}
						} else {
							//memPatno is null
							insertRecordFromBooking();
						}
					}
				});
			} else {
				showPatient(memPatNo);
				getRTJText_PatientNumber().checkPatientAlert();
				getDlgBookingList().showDialog(memPatNo,(memPreBooking?memPBPID:""),((memBkgID != null && memBkgID.length() > 0)?memBkgID:""));
			}
		} else {
			if (memPatNo != null && memPatNo.length() > 0) {
				showPatient(memPatNo);
				getDlgBookingList().showDialog(memPatNo,(memPreBooking?memPBPID:""),((memBkgID != null && memBkgID.length() > 0)?memBkgID:""));

				getRTJText_PatientNumber().checkPatientAlert();
			} else {
				//memPatno is null
				insertRecordFromBooking();
			}
		}
	}

	private void insertRecordFromBooking() {
		if (REG_NORMAL.equals(getRegistrationMode())) {
			// set status to append mode only for normal reg
			appendAction(true);
		}

		if (getParameter("PatFName") != null && getParameter("PatFName").length() > 0) {
			getPJText_FamilyName().setText(getParameter("PatFName").toUpperCase());
		}
		if (getParameter("PatCName") != null && getParameter("PatCName").length() > 0) {
			getPJText_GivenName().setText(getParameter("PatCName"));
		}
		if (getParameter("Tel") != null && getParameter("Tel").length() > 0) {
			getAJText_HomePhone().setText(getParameter("Tel"));
		}
		if (getParameter("MTel") != null && getParameter("MTel").length() > 0) {
			getAJText_Mobile().setText(getParameter("MTel"));
		}
		
		
		if (memBkgID != null && memBkgID.length() > 0) {
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] { "GOVREG", "BKGID, GOVSEX", "BKGID='" + memBkgID + "'" },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						getPJCombo_Sex().setText(mQueue.getContentField()[1]);
					} else {
						System.out.println("MASTER: " + memBkgID + " not exist in GOVREG");
					}
				}
			});
		}
		if (memPreBooking && (memPatNo == null || memPatNo.length() == 0)) {
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] { "BEDPREBOK", "PATIDNO, PATKHTEL, PATPAGER", "PBPID='" + memPBPID + "'" },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						getPJText_FamilyName().setText(memPatFName);
						getPJText_GivenName().setText(memPatGName);
						getPJText_ChineseName().setText(memPat_CName);
						getPJText_IDPassportNO().setText(mQueue.getContentField()[0]);
						getAJText_HomePhone().setText(mQueue.getContentField()[1]);
						getAJText_Mobile().setText(mQueue.getContentField()[2]);
					}
					updatePatientName();
					updatePatientChineseName();
				}
			});
		} else {
			updatePatientName();
			updatePatientChineseName();
		}
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		isTabConsent = !isDisableFunction("tabConsent", "regPatReg");
		isTabFTOCC = !isDisableFunction("tabFTOCC", "regPatReg");
		isTabApp = !isDisableFunction("tabAppUser", "regPatReg");
		changeLayoutPerParameter();

		//isPatRegTabPageEnable
		//getRegPanel().setEnabled(isPatRegTabPageEnable());
		getRBTPanel().setSelectedIndexWithoutStateChange(0);

		initVariables();

		if (getRegistrationMode() == null || getRegistrationMode().length() == 0) {
			setRegistrationMode(getParameter("START_TYPE"));

			if (getRegistrationMode() == null || getRegistrationMode().length() == 0) {
				setRegistrationMode(REG_NOTHING);
			}

			if (REG_NORMAL.equals(getRegistrationMode()) ||
					REG_URGENTCARE.equals(getRegistrationMode()) ||
					//REG_CAT_NORMAL.equals(getRegistrationMode()) ||
					memPreBooking) {
				memPkgCode = getParameter("PkgCode");
				memBPBPkgCode = getParameter("BPBPkgCode");
				
				memPBPID = getParameter("CurrentPBPId");
				if (memPBPID == null || memPBPID.length() == 0) {
					memPBPID = "";
				}
				showPreBookPatDetail(memPBPID);
			} else {
				memPatNo = getParameter("PatNo");
				memRegID = getParameter("RegID");
				showPatient(memPatNo, memRegID);
				getDlgBookingList().showDialog(memPatNo,(memPreBooking?memPBPID:""),((memBkgID != null && memBkgID.length() > 0)?memBkgID:""));

				getRTJText_PatientNumber().checkPatientAlert();
			}
			if (memAlertClinic != null && memAlertClinic.length() > 0 && "TWAH".equals(getUserInfo().getSiteCode())) {
				Factory.getInstance().addInformationMessage("Appointment Clinic Location:</br><font color='red'>"+memAlertClinic+"</font></br>","PBA - [Patient] Appointment Details");
			}
		}

//		enableButton();
		oTHandOverStatus(false);
		getINJCombo_ARC().initSettings();
	}

//	private void resetParameters() {
//		resetParameter("CallForm");
//		resetParameter("CurrentPBPId");
//		resetParameter("isPreBooking");
//		resetParameter("pat_Fname");
//		resetParameter("pat_Gname");
//		resetParameter("pat_Cname");
//		resetParameter("PBORemark");
//		resetParameter("STAYLEN");
//		resetParameter("FromBk");
//		resetParameter("pre_ArcCode");
//		resetParameter("pre_voucher");
//		resetParameter("pre_DOCCODE");
//		resetParameter("PatNo");
//		resetParameter("BkgID");
//		resetParameter("DocCode");
//		resetParameter("BkgSDate");
//		resetParameter("PatFName");
//		resetParameter("PatCName");
//		resetParameter("Tel");
//		resetParameter("MTel");
//		resetParameter("START_TYPE");
//		resetParameter("RegID");
//		resetParameter("PkgCode");
//		resetParameter("qPATNO");
//		resetParameter("AcceptClass");
//		resetParameter("FromOBBook1");
//	}

	@Override
	protected void proExitPanel() {
		if (memLockBed != null && memLockBed.length() > 0) {
			if (getINJText_BedNo().getText().trim().toUpperCase().length() > 0) {
				unlockRecord("Bed", getINJText_BedNo().getText().trim().toUpperCase());
			}
			unlockRecord("Bed", memLockBed);
		}

		if (memBkgID != null && memBkgID.length() > 0) {
			unlockRecord("Booking", memBkgID);
		}

		resetParameter("START_TYPE");
		resetParameter("FromBk");
		//resetParameters();
		resetParameter("FromOBBook1");
		resetParameter("isAlertClinic");

		// to call the getSearchParameter for PatientStatusView
		setParameter("CallBackPSV", "T");
		if (getParameter("CallForm") != null &&
				getParameter("CallForm").equals("srhReg")) {
			resetParameter("PatNo");
			resetParameter("RegID");
		}

		memActID = EMPTY_VALUE;
		memPcyCode = EMPTY_VALUE;
		memArcCode = EMPTY_VALUE;
		resetAllActionType();

		getRBTPanel().setSelectedIndexWithoutStateChange(0);
	}

	private void oTHandOverStatus(final boolean print) {
		enableButton();
		if (YES_VALUE.equals(getSysParameter("OTHandOver")) && memRegID != null
				&& tmpOTAid != null && tmpOTAid.length() > 0 && print) {
			printOThandOver();
		}
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public Component getDefaultFocusComponent() {
		if (!getRTJText_PatientNumber().isReadOnly() && getRBTPanel().getSelectedIndex() == 0) {
			return getRTJText_PatientNumber();
		} else {
			return super.getDefaultFocusComponent();
		}
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {
		resetAllActionType();
	}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {
		// enable/disable field
//		boolean appendStatus = getAppendButton().isEnabled();
		enableButton();
		if (isPatientFlag()) {
			boolean autoGenPatNo = TextUtil.isNumber(getSysParameter("NEXTPATNO"));

			getRTJText_PatientNumber().resetText();
			//getPJText_Death().setEditable(false);
			getPJCheckBox_Active().setSelected(true);
			getPJCheckBox_SMS().setSelected(true);
			//getPJCheckBox_Interpreter().setEditable(false);
			//getPJCheckBox_Staff().setEditable(false);
			String defaultLocation = getSysParameter("PatLocDef");
			if (defaultLocation != null && defaultLocation.length() > 0) {
				getAJCombo_Location().setText(defaultLocation);
			}
			getAJText_District().resetText();
			getAJText_LastUpdatedDate().setText(getMainFrame().getServerDateTime());
			getAJText_LastUpdatedBy().setText(getUserInfo().getUserID());

			getMasterPanel().focus();
			if (autoGenPatNo) {
				getPJText_IDPassportNO().requestFocus();
			} else {
				getRTJText_PatientNumber().requestFocus();
			}
		} else if (isRegFlag()) {
//			getAppendButton().setEnabled(appendStatus);
//			enablePatRegButton();
			enablePatRegEditFiled();

			if ((REG_NORMAL.equals(getRegistrationMode()) || REG_URGENTCARE.equals(getRegistrationMode()))
					&& memBkgID != null && memBkgID.length() > 0
					&& QueryUtil.ACTION_APPEND.equals(getActionTypeRegistration())
					&& REG_TYPE_OUTPATIENT.equals(getCurrentRegistrationType())) {
				QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
						new String[] {"Booking", "BkSid", "BkgID= '" + memBkgID + "'"},
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							String sourceKey = mQueue.getContentField()[0];
							if (getINJCombo_Source().isValid(sourceKey)) {
								getINJCombo_Source().setText(sourceKey);
							} else {
								getINJCombo_Source().resetText();
							}
						} else {
							getINJCombo_Source().resetText();
						}
					}
				});
			}
		}
	}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
		// enable/disable field
		enableButton();

		if (SAME_AS_ABOVE.equals(getRJText_Address().getText())) {
			getRJText_Address().setEditable(false);
			getRJCheckBox_SameAsAbove().setSelected(true);
		} else {
			getRJText_Address().setEditable(true);
			getRJCheckBox_SameAsAbove().setSelected(false);
		}

		if (isRegFlag()) {
			enablePatRegEditFiled();
		}
	}

	/* >>> ~12.1~ Set Disable Fields When Modify ButtonBase Is Clicked ==== <<< */
	@Override
	public void modifyPostAction() {
		// focus on entry panel
		if (isPatientFlag()) {
			getOldPatDataBfEdit();
			getPJText_IDPassportNO().requestFocus();
		} else if (isRegFlag()) {
			if (getRTJRadio_InPatient().isSelected()) {
				getINJText_BedNo().requestFocus();
			} else {
				getINJText_TreDrCode().requestFocus();
			}
		} else if (isEhrFlag()) {
			getEJText_FName().requestFocus();
		} else if (isConsentFlag()) {
			getCSJText_DateStart1().requestFocus();
		}
	}

	/* >>> ~13~ Set Disable Fields When Delete ButtonBase Is Clicked ====== <<< */
	@Override
	protected void deleteDisabledFields() {
		// enable/disable field
		enableButton();
		//getPJText_Death().setEditable(false);
	}

	@Override
	protected void clearPostAction() {
		enableButton();
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		if (isRegFlag()) {
			return new String[] {
					getRTJText_PatientNumber().getText(),
					EMPTY_VALUE
			};
		} else if (isEhrFlag() || isConsentFlag()) {
			return new String[] {
					getRTJText_PatientNumber().getText()
			};
		} else {
			return new String[] {
					getRTJText_PatientNumber().getText(),
					EMPTY_VALUE,
					EMPTY_VALUE,
					EMPTY_VALUE,
					EMPTY_VALUE,
					EMPTY_VALUE,
					EMPTY_VALUE,
					EMPTY_VALUE,
					EMPTY_VALUE,
					EMPTY_VALUE,
					EMPTY_VALUE,
					EMPTY_VALUE
			};
		}
	}

	/* >>> ~15.1~ Set Browse Output Results =============================== <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {
		if (outParam.length > 0) {
			updatePatient(outParam);
			getMomBabySearch(outParam[PATIENT_NUMBER], EMPTY_VALUE, EMPTY_VALUE);

			setActionType(null);
//			setActionTypePatient(QueryUtil.ACTION_BROWSE);
			enableButton();

//			if (memPatNo != null && !memPatNo.equals(memOldPatNo)) {
//				getAlertCheck().checkAltAccess(getRTJText_PatientNumber().getText(),
//						"Patient Registration", true, false, null);
//				getAlertCheck().checkAltOSBill(getRTJText_PatientNumber().getText());
//
//				memOldPatNo = getRTJText_PatientNumber().getText();
//			}
		} else {
			// go to patient search if record not found
			getRTJText_PatientNumber().showSearchPanel();
		}
	}

	/* >>> ~16~ Set Fetch Input Parameters ================================ <<< */
	@Override
	protected String[] getFetchInputParameters() {
		return new String[] {
				getRTJText_PatientNumber().getText()
		};
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {
		if (isEhrFlag()) {
			// e-HR
			showEhr(outParam[PATIENT_NUMBER]);
		} else if (isConsentFlag()) {
			// Consent
			showConsent(outParam[PATIENT_NUMBER]);
		} else {
			updatePatient(outParam);
		}
	}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		if (isRegFlag()) {
			return new String[] {
					getINJText_SLPNO().getText(), //SLPNO
					getINJText_BedNo().getText().toUpperCase(), //BEDCODE
					getINJCombo_AcmCode().getText(), //ACMCODE
					!getINJText_ADMDoctor().isEmpty() ? getINJText_ADMDoctor().getText() : getINJText_TreDrCode().getText(), //Doccode_a
					getINJCombo_ADMFrom().getText(), //Srccode
					getINJCombo_ADMType().getText(), //AMTID
					getINJText_Remark().getText(), //INPREMARK
					getRTJText_PatientNumber().getText(), //PATNO
					getRTJRadio_OutPatient().isSelected() ? REG_TYPE_OUTPATIENT : getRTJRadio_DayCasePatient().isSelected() ? REG_TYPE_DAYCASE : REG_TYPE_INPATIENT, //SLPTYPE
					getINJText_TreDrCode().getText(), //DOCCODE
					getINJCombo_ARC().getText(), //ARCCODE
					getINJText_PLNO().getText(), //SLPPLYNO
					getINJText_VHNO().getText(), //SLPVCHNO
					getINJText_PreAuthNo().getText(), //INSPREAUTHNO
					getINJCombo_Category().getPcyID(), //PCYID
					getINJText_Ref().getText(), //PATREFNO
					getINJCombo_Source().getText(), // SOURCE
					getINJText_SourceNo().getText(), // SOURCE NO
					getRightJCombo_Misc().getText(), //SLPMID
					getRightJCombo_SpRqt().getText(), //SPRQTID
					getINJCheckBox_Revlog().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE,      //ISRECLG,
					getINJCombo_LogCvrCls().getText(),                                        //ARACMCODE
					getINJCombo_Package().getText(),                                          //PBPKGCODE
					getPJCheckBox_EstGiven().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE,     //est given
					getINJText_LAmt().getText(), //ARLMTAMT
					getINJText_endDate().getText(), //CVREDATE
					getINJCheckBox_Doctor().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE, // ITMTYPED
					getINJCheckBox_Hspital().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE, // ITMTYPEH
					getINJCheckBox_Special().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE, // ITMTYPES
					getINJCheckBox_Other().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE, // ITMTYPEO
					getINJText_FGAmt().getText(), //FURGRTAMT
					getINJText_FGDate().getText(), //FURGRTDATE
					getINJCombo_CPAmt().getText(), //COPAYTYP
					getINJText_CPAmt().getText(), //COPAYAMT
					memPrintDate,
					getINJText_RegDate().getText(), //REGDATE
					getRTJRadio_OutPatient().isSelected() ? REG_TYPE_OUTPATIENT :
						getRTJRadio_DayCasePatient().isSelected() ? REG_TYPE_DAYCASE :
							getRTJRadio_InPatient().isSelected() ? REG_TYPE_INPATIENT : EMPTY_VALUE, // REGTYPE
					getRegistrationMode() == null ||
						REG_TYPE_INPATIENT.equals(getRegistrationMode()) ||
						REG_TYPE_DAYCASE.equals(getRegistrationMode()) ? EMPTY_VALUE :
						(memFromBk)?REG_CAT_NORMAL:getRegistrationMode(),//REGOPCAT
					getINJCheckBox_NewBorn().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE, 		//REGNB
					getRegDtorTableData(),
					REG_NORMAL.equals(getRegistrationMode()) || REG_URGENTCARE.equals(getRegistrationMode()) ? memBkgID : ZERO_VALUE,
					getRTJRadio_NonMainland().isSelected() ? ZERO_VALUE : getRTJRadio_Mainland().isSelected() ? ONE_VALUE : EMPTY_VALUE,
					memActID,
					getINJText_LengthOfStay().getText(), //ACTSTAYLEN,
					ticketNo,
					memPBORemark,
					memPBPID,
					getINJCheckBox_PrtMedRecordRpt().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE, // PRINT_MRRPT
					getINJText_Deduct().getText(), //SLIP_EXTRA.COPAYAMTACT
					mem_FESTID,
					getPJCheckBox_BE().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE,
					getUserInfo().getSiteCode(),
					getUserInfo().getUserID(),
					CommonUtil.getComputerName(),
					skipBedChecking?"1":"0",
					skipCreateSlip?"1":"0",
					getINJText_RefDoctor1().getText(),
					getINJText_RefDoctor2().getText(),
					((getRTJRadio_OutPatient().isSelected() && NO_VALUE.equals(Factory.getInstance().getSysParameter("DISABLERM")))?
							getRTCombo_docRoom().getText():"")
			};
		} else if (isEhrFlag()) {
			return new String[] {
					getRTJText_PatientNumber().getText(),
					getEJText_cEhrNo().getText(),
					getEJText_FName().getText(),
					getEJText_GName().getText(),
					getEJText_Dob().getText(),
					getEJCombo_ehrExactDobInd().getText(),
					getEJCombo_Sex().getText(),
					getEJText_HKID().getText(),
					getEJText_docNo().getText(),
					getEJCombo_docType().getText(),
					null,	// active
					null,	// death
					(getEJText_HKID().getText().startsWith(SPACE_VALUE) ? YES_VALUE : NO_VALUE),
					getUserInfo().getUserID()
			};
		} else if (isConsentFlag()) {
			return new String[] {
					getRTJText_PatientNumber().getText(),
					getCSJText_DateStart1().getText(),
					getCSJText_DateTo1().getText(),
					getCSJText_ArCode1().getText(),
					getCSJText_Remark1().getText(),
					getCSJText_DateStart2().getText(),
					getCSJText_DateTo2().getText(),
					getCSJText_ArCode2().getText(),
					getCSJText_Remark2().getText(),
					getCSJText_DateStart3().getText(),
					getCSJText_DateTo3().getText(),
					getCSJText_ArCode3().getText(),
					getCSJText_Remark3().getText(),
					getTextArea_InsuranceRmk().getText(),
					getUserInfo().getUserID()
			};
		} else {
			return new String[] {
					getRTJText_PatientNumber().getText(),
					getPJText_IDPassportNO().getText(),
					getAJCombo_IDCountry().getText(),
					getPJText_FamilyName().getText(),
					getPJCombo_Title().getText(),
					getPJText_GivenName().getText(),
					getPJText_ChineseName().getText(),
					getPJCombo_MSTS().getText(),
					getPJText_MaidenName().getText(),
					getPJCombo_Race().getText(),
					getPJText_Birthday().getText(),
					getPJCombo_MotherLanguage().getText(),
					getPJCombo_Sex().getText(),
					getPJCombo_EduLvl().getText(),
					getPJCombo_Religious().getText(),
					getPJText_Death().getText(),
					getPJText_Occupation().getText(),
					getPJText_MotherRecord().getText(),
					getPJCheckBox_NewBorn().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE,
					getPJCheckBox_Active().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE,
					getPJCheckBox_Interpreter().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE,
					getPJCheckBox_Staff().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE,
					getPJCheckBox_SMS().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE,
					getPJCheckBox_CheckID().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE,
					getAJText_Email().getText(),
					getAJText_HomePhone().getText(),
					getAJText_OfficePhone().getText(),
					getAJText_Mobile().getText(),
					getAJText_FaxNO().getText(),
					getAJText_ADDR1().getText(),
					getAJText_ADDR2().getText(),
					getAJText_ADDR3().getText(),
					getAJCombo_Location().getText(),
					getAJCombo_Country().getText(),
					getAJText_Remark().getText(),
					getRJText_KinName().getText(),
					getRJText_HomeTel().getText(),
					getRJText_Pager().getText(),
					getRJText_Relationship().getDisplayText(),
					getRJText_OfficeTel().getText(),
					getRJText_Mobile().getText(),
					getRJText_Email().getText(),
					getRJText_Address().getText(),
					getPJText_MRRemark().getText(),
					getText_LongFName().getText(),
					getText_LongGName().getText(),
					getTextArea_PatientRmk().getText(),
					getPJCombo_DocType().getText(),
					getPJCombo_MarketingSource().getText(),
					getPJText_MarketingRemark().getText(),
					getRTJText_DentalPatientNo().getText(),
					getPJText_MiscRemark().getText(),
					getUserInfo().getUserID(),
					getPJCombo_BirthOrdSPG().getText(),//BIRHTORDSPG
					getPJText_IDPassportNO_S1().getText(),
					getPJCombo_DocType_S1().getText(),
					getAJCombo_IDCountry_S1().getText(),
					getPJText_IDPassportNO_S2().getText(),
					getPJCombo_DocType_S2().getText(),
					getAJCombo_IDCountry_S2().getText(),
					getAJCombo_MobCouCode().getText()
			};
		}
	}

	/* >>> ~17.1~ Set Action Input Parameters ============================= <<< */
	@Override
	protected void getNewOutputValue(String returnValue) {
		if (!isRegFlag()) {
			getRTJText_PatientNumber().setText(returnValue);
			// set memPatNo if empty memPatno and memPreBooking
			if (memPreBooking && (memPatNo == null || memPatNo.length() == 0)) {
				memPatNo = returnValue;
			}

			// log add patient master index by staff id
			writePatientLog(getRTJText_PatientNumber().getText(), "ADD-HATS", "Add patient profile of #" + getRTJText_PatientNumber().getText(), getUserInfo().getSsoUserID());
		}
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(final String actionType) {
		boolean returnValue = true;
		String regType = getCurrentRegistrationType();
		Map<String, String> hasUpdatePatientInf = null;
//		getSaveButton().setEnabled(false);

		isPrompt_ChangeLongPatName = false;
		isPrompt_ChangeShortPatName = false;
		isPrompt_ChangeBedHistory = false;
		saving = true;
		skipCreateSlip = false;

		if (isRegFlag()) {
			getSaveButton().setEnabled(false);
			getMainFrame().setLoading(true);
			try {
				if (getINJCombo_ARC().isEditable() &&
						!getINJCombo_ARC().isEmpty() &&
						!getINJCombo_ARC().isValid()) {
					Factory.getInstance().addErrorMessage("AR Code does not exist.", getINJCombo_ARC());
					callActionValidationReady(actionType, false);
					return;
				}

				if (!getINJCombo_Source().isEmpty() &&
						!getINJCombo_Source().isValid()) {
					Factory.getInstance().addErrorMessage("Invalid Input Source.", getINJCombo_Source());
					callActionValidationReady(actionType, false);
					return;
				}

				// Limit Amount
				if (!getINJText_LAmt().isEmpty() &&
						(!TextUtil.isInteger(getINJText_LAmt().getText().toString()) ||
						Integer.parseInt(getINJText_LAmt().getText()) < 0)) {
					if (!TextUtil.isInteger(getINJText_LAmt().getText().toString())) {
						Factory.getInstance().addErrorMessage("Please enter a integer Limit Amount.", getINJText_LAmt());
					}
					if (Integer.parseInt(getINJText_LAmt().getText()) < 0) {
						Factory.getInstance().addErrorMessage("Guarantee Amount Limit must >= 0.", getINJText_LAmt());
					}
					getINJText_LAmt().setText(ZERO_VALUE);

					callActionValidationReady(actionType, false);
					return;
				}

				// Co-Payment
				if (!getINJText_CPAmt().isEmpty() &&
						(!TextUtil.isInteger(getINJText_CPAmt().getText().toString()) ||
								Integer.parseInt(getINJText_CPAmt().getText()) < 0)) {
					Factory.getInstance().addErrorMessage("Please enter a integer Co-Payment Amount.", getINJText_CPAmt());
					getINJText_CPAmt().setText(ZERO_VALUE);

					callActionValidationReady(actionType, false);
					return;
				}

				if (getINJCombo_CPAmt().isEmpty() && !getINJText_CPAmt().getText().isEmpty() &&
						Integer.parseInt(getINJText_CPAmt().getText()) > 0) {
					Factory.getInstance().addErrorMessage("Co-Payment type should be selected.", getINJCombo_CPAmt());

					callActionValidationReady(actionType, false);
					return;
				}

				if (!getINJCombo_CPAmt().isEmpty()) {
					if (getINJText_CPAmt().isEmpty() ||
							(!getINJText_CPAmt().isEmpty() &&
							(!TextUtil.isInteger(getINJText_CPAmt().getText().toString()) ||
									Integer.parseInt(getINJText_CPAmt().getText()) < 0))) {
						Factory.getInstance().addErrorMessage("Co-Payment Amount must >= 0.", getINJText_CPAmt());

						callActionValidationReady(actionType, false);
						return;
					}

					if (getINJCombo_CPAmt().getText().trim().equals("%")) {
						if (returnValue) {
							Integer amt = Integer.parseInt(getINJText_CPAmt().getText());

							if (amt > 100 || amt < 0) {
								Factory.getInstance().addErrorMessage("Co-Payment Amount must >= 0 and <= 100.", getINJText_CPAmt());

								callActionValidationReady(actionType, false);
								return;
							}
						}
					}
				} else {
					getINJText_CPAmt().setText(ZERO_VALUE);
				}

				// Further Guarantee Amount
				if (!getINJText_FGAmt().isEmpty() &&
						(!TextUtil.isInteger(getINJText_FGAmt().getText().toString()) ||
								Integer.parseInt(getINJText_FGAmt().getText()) < 0)) {
					if (!TextUtil.isInteger(getINJText_FGAmt().getText().toString())) {
						Factory.getInstance().addErrorMessage("Please enter a integer Further Guarantee Amount.", getINJText_FGAmt());
					}
					if (Integer.parseInt(getINJText_FGAmt().getText()) < 0) {
						Factory.getInstance().addErrorMessage("Further Guarantee Amount Limit must >= 0.", getINJText_FGAmt());
					}
					getINJText_FGAmt().setText(ZERO_VALUE);

					callActionValidationReady(actionType, false);
					return;
				}

				// Deductible Amount
				if (!getINJText_Deduct().isEmpty() &&
						(!TextUtil.isInteger(getINJText_Deduct().getText().toString()) ||
								Integer.parseInt(getINJText_Deduct().getText()) < 0)) {
					if (!TextUtil.isInteger(getINJText_Deduct().getText().toString())) {
						Factory.getInstance().addErrorMessage("Please enter a integer Deductible Amount.", getINJText_Deduct());
					}
					if (Integer.parseInt(getINJText_Deduct().getText()) < 0) {
						Factory.getInstance().addErrorMessage("Deductible Amount Limit must >= 0.", getINJText_Deduct());
					}
					getINJText_Deduct().setText(ZERO_VALUE);

					callActionValidationReady(actionType, false);
					return;
				}

				if (!getINJText_LAmt().isEmpty() &&
						!getINJText_FGAmt().isEmpty()) {
					if (Integer.parseInt(getINJText_FGAmt().getText()) >
							Integer.parseInt(getINJText_LAmt().getText())) {
						Factory.getInstance().addErrorMessage("Further Guarantee Amount Limit should less than or equal to Limited Amount.", getINJText_FGAmt());

						callActionValidationReady(actionType, false);
						return;
					}
				}

				if (getINJText_LAmt().isEmpty()) {
					getINJText_LAmt().setText(ZERO_VALUE);
				}

				if (getINJText_CPAmt().isEmpty()) {
					getINJText_CPAmt().setText(ZERO_VALUE);
				}

				if (getINJText_FGAmt().isEmpty()) {
					getINJText_FGAmt().setText(ZERO_VALUE);
				}

				if (getINJText_Deduct().isEmpty()) {
					getINJText_Deduct().setText(ZERO_VALUE);
				}

				if (REG_TYPE_INPATIENT.equals(regType)) {
					getINJText_ADMDate().onBlur();
				}

				if (!getINJText_ADMDate().isValid()) {
					Factory.getInstance().addErrorMessage("Invalid the admission date.", getINJText_ADMDate());

					callActionValidationReady(actionType, false);
					return;
				}

				if (DateTimeUtil.dateTimeDiff(getINJText_ADMDate().getText(),
												getMainFrame().getServerDateTime()) > 0) {
					Factory.getInstance().addErrorMessage("Admission date is a future date.", getINJText_ADMDate());

					callActionValidationReady(actionType, false);
					return;
				}

				if (!getINJText_RegDate().isValid()) {
					Factory.getInstance().addErrorMessage("Invalid the registration date.", getINJText_RegDate());

					callActionValidationReady(actionType, false);
					return;
				}

				if (!getINJText_endDate().isEmpty() && !getINJText_endDate().isValid()) {
					Factory.getInstance().addErrorMessage("The End Date is invalid.", getINJText_endDate());

					callActionValidationReady(actionType, false);
					return;
				}

				if (!getINJText_endDate().isEmpty() && !getINJText_FGDate().isValid()) {
					Factory.getInstance().addErrorMessage("The Fur. Gu. Date is invalid.", getINJText_FGDate());

					callActionValidationReady(actionType, false);
					return;
				}

				if (REG_TYPE_INPATIENT.equals(regType) &&
						getINJText_LengthOfStay().isEmpty() &&
						YES_VALUE.equals(getSysParameter("ACTLENMUST"))) {
					Factory.getInstance().addErrorMessage("Please input Length of Stay.", getINJText_LengthOfStay());

					callActionValidationReady(actionType, false);
					return;
				}

				if (REG_TYPE_INPATIENT.equals(regType) &&
						!getINJText_LengthOfStay().isEmpty() &&
						(!TextUtil.isInteger(getINJText_LengthOfStay().getText().toString()) ||
								Integer.parseInt(getINJText_LengthOfStay().getText()) <= 0)) {

					if (YES_VALUE.equals(getSysParameter("ACTSTAYLEN"))) {
						Factory.getInstance().addErrorMessage("Length of Stay should be > 0.", getINJText_LengthOfStay());
					} else {
						Factory.getInstance().addErrorMessage("Length of Stay should be > 0 or null.", getINJText_LengthOfStay());
					}

					callActionValidationReady(actionType, false);
					return;
				}

				if (REG_TYPE_INPATIENT.equals(regType) &&
						YES_VALUE.equals(getSysParameter("ADMTYPMUST")) &&
						getINJCombo_ADMType().isEmpty()) {
					Factory.getInstance().addErrorMessage("Please input Admission Type.", getINJCombo_ADMType());

					callActionValidationReady(actionType, false);
					return;
				}

				if (REG_TYPE_INPATIENT.equals(regType) &&
						!getINJCombo_ADMType().isEmpty() && !getINJCombo_ADMType().isValid()) {
					// Check Admission Type
					Factory.getInstance().addErrorMessage("Invalid Admission Type.", getINJCombo_ADMType());
					callActionValidationReady(actionType, false);
					return;
				}

				if (REG_TYPE_INPATIENT.equals(regType) &&
						getINJText_ADMDoctor().isEmpty()) {
					// Check Doctor code
					Factory.getInstance().addErrorMessage("Inactive Admission Doctor.", getINJText_ADMDoctor());
					callActionValidationReady(actionType, false);
					return;
				}

				if (REG_TYPE_INPATIENT.equals(regType) &&
						!getINJText_ADMDoctor().isEmpty() && !getINJText_ADMDoctor().isValid()) {
					// Check Doctor code
					Factory.getInstance().addErrorMessage("Invalid Admission Doctor.", getINJText_ADMDoctor());
					callActionValidationReady(actionType, false);
					return;
				}

				if (getINJText_TreDrCode().isEmpty()) {
					// Check Doctor code
					Factory.getInstance().addErrorMessage("Inactive Doctor Code.", getINJText_TreDrCode());
					callActionValidationReady(actionType, false);
					return;
				}

				if (!getINJText_TreDrCode().isEmpty() && !getINJText_TreDrCode().isValid()) {
					// Check Doctor code
					Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_WRONG_DOCCODE, getINJText_TreDrCode());
					callActionValidationReady(actionType, false);
					return;
				}

				if (REG_TYPE_INPATIENT.equals(regType) &&
						QueryUtil.ACTION_APPEND.equals(getActionType()) &&
						getINJCheckBox_NewBorn().isSelected()) {
					if (!getRTJRadio_NonMainland().isSelected() && !getRTJRadio_Mainland().isSelected()) {
						Factory.getInstance().addErrorMessage("Mainland / Non-Mainland is mandatory.");

						callActionValidationReady(actionType, false);
						return;
					}
				}

				if (REG_TYPE_INPATIENT.equals(regType) &&
						getINJText_BedNo().isEmpty()) {
					// Check Bed No EMPTY_VALUE.equalsIgnoreCase(INJText_BedNo.getText().trim())
					Factory.getInstance().addErrorMessage("Inactive Bed No.", getINJText_BedNo());

					callActionValidationReady(actionType, false);
					return;
				}

				if (REG_TYPE_INPATIENT.equals(regType) &&
						(getINJCombo_ADMFrom().isEmpty()
						|| MINUS_VALUE.equals(getINJCombo_ADMFrom().getText().trim()))) {
					// Check Source
					Factory.getInstance().addErrorMessage("Please select Admission Source.", getINJCombo_ADMFrom());
					callActionValidationReady(actionType, false);
					return;
				}

				if (!getINJCombo_ADMFrom().isEmpty() &&
						!getINJCombo_ADMFrom().isValid()) {
					// Check Source
					Factory.getInstance().addErrorMessage("Invalid Admission Source.", getINJCombo_ADMFrom());
					callActionValidationReady(actionType, false);
					return;
				}

				if (HKAH_VALUE.equals(getUserInfo().getSiteCode()) &&
						(getINJCombo_Source().isEmpty() || !getINJCombo_Source().isValid())) {
					Factory.getInstance().addErrorMessage("Please select a source.", getINJCombo_Source());
					callActionValidationReady(actionType, false);
					return;
				}

				if (!getINJText_ADMDate().isEmpty() &&
						!getPJText_Birthday().isEmpty() &&
						getINJText_ADMDate().isValid() &&
						getPJText_Birthday().isValid()) {
					if (DateTimeUtil.dateDiff(getINJText_ADMDate().getText().substring(0, 10),
												getPJText_Birthday().getText()) == 1 ||
						DateTimeUtil.dateDiff(getINJText_ADMDate().getText().substring(0, 10),
												getPJText_Birthday().getText()) == -1) {

						Factory.getInstance().addErrorMessage("Birth date is one day earlier or later than admission date.", getINJText_ADMDate());

						//callActionValidationReady(actionType, false);
						//return;
					}
				}
				
				if (NO_VALUE.equals(Factory.getInstance().getSysParameter("DISABLERM")) && REG_TYPE_OUTPATIENT.equals(regType)
						&& ((REG_DISPLAY_WALKIN.toUpperCase().equals(getRTJText_OutPatientType().getText()) && getRTCombo_docRoom().isEmpty()))
						) {
					Factory.getInstance().addErrorMessage("Please Choose a Doctor Room.", getRTCombo_docRoom());
					callActionValidationReady(actionType, false);
					return;
				}
				
				
			} catch (Exception e) {
				e.printStackTrace();
				callActionValidationReady(actionType, false);
				return;
			}

			if (isModify()) {
				if (isNewGrt()) {
					if (currentArcCode != null && currentArcCode.length() > 0) {
						MessageBoxBase.confirm(MSG_PBA_SYSTEM, "Is a new further guarantee ? ",
						new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									memPrintDate = EMPTY_VALUE;
								} else {
									defaultFocus();
								}
								callActionValidationReadyForAdmissionDate(actionType, true);
							}
						});
						return;
					} else {
						memPrintDate = EMPTY_VALUE;
					}
				}
				callActionValidationReadyForAdmissionDate(actionType, true);
			} else {
				if (memBkgRmk != null && (memBkgRmk.indexOf("INPATIENT") >= 0 || memBkgRmk.indexOf("HD") >= 0) && "NUWC".equals(getINJText_TreDrCode().getText())) {
					getMainFrame().setLoading(false);
					MessageBoxBase.confirm(MSG_PBA_SYSTEM, "Do you want to create slip?",
							new Listener<MessageBoxEvent>() {
						@Override
						public void handleEvent(MessageBoxEvent be) {
							getMainFrame().setLoading(true);
							skipCreateSlip = !Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId());
							callActionValidationReady(actionType, true);
						}
					});
				} else {
					callActionValidationReady(actionType, true);
				}
				return;
			}
		} else if (isEhrFlag()) {
			if (getEJText_FName().isEmpty() && getEJText_GName().isEmpty()) {
				Factory.getInstance().addErrorMessage("Patient Family Name and Given Name should not be empty.", getEJText_FName());
				returnValue = false;
			} else if (getEJText_FName().getText().length() > 40) {
				Factory.getInstance().addErrorMessage("Patient Family Name too long (max 40).", getEJText_FName());
				returnValue = false;
			} else if (getEJText_GName().getText().length() > 40) {
				Factory.getInstance().addErrorMessage("Patient Given Name too long (max 40).", getEJText_GName());
				returnValue = false;
			} else if (getEJText_Dob().isEmpty()) {
				Factory.getInstance().addErrorMessage("Patient Date of Birth should not be empty.", getEJText_Dob());
				returnValue = false;
			} else if (getEJCombo_Sex().isEmpty()) {
				Factory.getInstance().addErrorMessage("Patient Sex should not be empty.", getEJCombo_Sex());
				returnValue = false;
			} else if (getEJText_docNo().getText().length() > 30) {
				Factory.getInstance().addErrorMessage("Identity Document Number too long (max 30).", getEJText_docNo());
				returnValue = false;
			} else if (getEJText_HKID().getText().isEmpty() && getEJText_docNo().getText().isEmpty()) {
				Component focusField = null;
				if (getEJCombo_docType().getText().isEmpty()) {
					focusField = getEJText_HKID();
				} else {
					focusField = getEJText_docNo();
				}
				Factory.getInstance().addErrorMessage("Please enter HKID No. or Identity Document Number.", focusField);
				returnValue = false;
			} else if (!getEJText_docNo().getText().isEmpty() && getEJCombo_docType().getText().isEmpty()) {
				Factory.getInstance().addErrorMessage("Please select Type of Identity Document.", getEJCombo_docType());
				returnValue = false;
			} else if (!getEJText_HKID().getText().isEmpty() && !getEJText_docNo().getText().isEmpty() && getEJCombo_docType().isEmpty()) {
				Factory.getInstance().addErrorMessage("Please select Type of Identity Document.", getEJCombo_docType());
				returnValue = false;
			} else {
				if (!getEJText_HKID().isEmpty()) {
					final String hkid = getEJText_HKID().getText();
					EhrUtil.isValidHkid(hkid, new AsyncCallback<String>() {
						@Override
						public void onFailure(Throwable caught) {
							Factory.getInstance().addErrorMessage("HKID validation error. Please contact IT support.");
						}

						@Override
						public void onSuccess(String result) {
							if (result != null) {
								if (hkid.contains("(") || hkid.contains(")")) {
									result += " (Do not enter the brackets\"()\".";
								}
								Factory.getInstance().addErrorMessage(result);
							} else {
								if (hkid.length() > 40) {
									Factory.getInstance().addErrorMessage("HKID No. too long (max 12).", getEJText_HKID());
								} else {
									getEJText_HKID().setText(EhrUtil.getValidHkidFormat(hkid));
									checkEhrHKIDTypeConflict(actionType, new CallbackListener() {
										@Override
										public void handleRetBool(boolean ret,
												String result,
												MessageQueue mQueue) {
											checkEhrPatDupl(actionType);
										}
									});
								}
							}
						}
					});
				} else {
					checkEhrPatDupl(actionType);
				}
			}
		} else if (isConsentFlag()) {
			if (!getCSJText_DateStart1().isEmpty() && !getCSJText_DateStart1().isValid()) {
				Factory.getInstance().addErrorMessage("Invalid Start date.", getCSJText_DateStart1());
				returnValue = false;
			} else if (!getCSJText_DateTo1().isEmpty() && !getCSJText_DateTo1().isValid()) {
				Factory.getInstance().addErrorMessage("Invalid Revoke date.", getCSJText_DateTo1());
				returnValue = false;
			} else if (!getCSJText_ArCode1().isEmpty() && !getCSJText_ArCode1().isValid()) {
				Factory.getInstance().addErrorMessage("Invalid Ar Code.", getCSJText_ArCode1());
				returnValue = false;
			} else if (!getCSJText_DateStart2().isEmpty() && !getCSJText_DateStart2().isValid()) {
				Factory.getInstance().addErrorMessage("Invalid Start date.", getCSJText_DateStart2());
				returnValue = false;
			} else if (!getCSJText_DateTo2().isEmpty() && !getCSJText_DateTo2().isValid()) {
				Factory.getInstance().addErrorMessage("Invalid Revoke date.", getCSJText_DateTo2());
				returnValue = false;
			} else if (!getCSJText_ArCode2().isEmpty() && !getCSJText_ArCode2().isValid()) {
				Factory.getInstance().addErrorMessage("Invalid Ar Code.", getCSJText_ArCode2());
				returnValue = false;
			} else if (!getCSJText_DateStart3().isEmpty() && !getCSJText_DateStart3().isValid()) {
				Factory.getInstance().addErrorMessage("Invalid Start date.", getCSJText_DateStart3());
				returnValue = false;
			} else if (!getCSJText_DateTo3().isEmpty() && !getCSJText_DateTo3().isValid()) {
				Factory.getInstance().addErrorMessage("Invalid Revoke date.", getCSJText_DateTo3());
				returnValue = false;
			} else if (!getCSJText_ArCode3().isEmpty() && !getCSJText_ArCode3().isValid()) {
				Factory.getInstance().addErrorMessage("Invalid Ar Code.", getCSJText_ArCode3());
				returnValue = false;
			}
			callActionValidationReadyForPatientName(actionType, returnValue);
		} else {
			boolean autoGenPatNo = TextUtil.isNumber(getSysParameter("NEXTPATNO"));
			if (isAppend() && autoGenPatNo && !getRTJText_PatientNumber().isEmpty()) {
				Factory.getInstance().addErrorMessage("Patient Number will be auto generated by system. Please empty Patient Number.", getRTJText_PatientNumber());
				returnValue = false;
			} else if (!autoGenPatNo && getRTJText_PatientNumber().isEmpty()) {
				Factory.getInstance().addErrorMessage("Patient Number can't be empty.", getRTJText_PatientNumber());
				returnValue = false;
			} else if (!autoGenPatNo && !getRTJText_PatientNumber().isEmpty() && getRTJText_PatientNumber().getText().length() > 10) {
				Factory.getInstance().addErrorMessage("Patient Number can't be longer than 10.", getRTJText_PatientNumber());
				returnValue = false;
			} else if (!getAJCombo_IDCountry().isEmpty() && !getAJCombo_IDCountry().isValid()) {
				Factory.getInstance().addErrorMessage("Invalid Issue Country.", getAJCombo_IDCountry());
				returnValue = false;
			} else if (getAJCombo_IDCountry().isEmpty() && "OP".equals(getPJCombo_DocType().getText()) && YES_VALUE.equals(getSysParameter("PatIDConty"))) {
				Factory.getInstance().addErrorMessage("Issue Country Must be Entered!", getAJCombo_IDCountry());
				returnValue = false;
			} else if (getPJText_FamilyName().isEmpty()) {
				Factory.getInstance().addErrorMessage("Patient Family Name should not be empty.", getPJText_FamilyName());
				returnValue = false;
			} else if (!getPJText_FamilyName().isEmpty() && getPJText_FamilyName().getText().length() > 40) {
				Factory.getInstance().addErrorMessage("Patient Family Name can't be longer than 40.", getPJText_FamilyName());
				returnValue = false;
			} else if (getPJText_GivenName().isEmpty()) {
				Factory.getInstance().addErrorMessage("Patient Given Name should not be empty.", getPJText_GivenName());
				returnValue = false;
			} else if (!getPJText_GivenName().isEmpty() && getPJText_GivenName().getText().length() > 40) {
				Factory.getInstance().addErrorMessage("Patient Given Name can't be longer than 40.", getPJText_GivenName());
				returnValue = false;
			} else if (!getPJCombo_Title().isEmpty() && !getPJCombo_Title().isValid()) {
				Factory.getInstance().addErrorMessage("Invalid Title.", getPJCombo_Title());
				returnValue = false;
			} else if (!getPJCombo_MSTS().isEmpty() && !getPJCombo_MSTS().isValid()) {
				Factory.getInstance().addErrorMessage("Invalid Marital Status.", getPJCombo_MSTS());
				returnValue = false;
			} else if (!getPJCombo_Race().isEmpty() && !getPJCombo_Race().isValid()) {
				Factory.getInstance().addErrorMessage("Invalid Nationality.", getPJCombo_Race());
				returnValue = false;
			} else if (!getPJCombo_MotherLanguage().isEmpty() && !getPJCombo_MotherLanguage().isValid()) {
				Factory.getInstance().addErrorMessage("Invalid Corresponding Language.", getPJCombo_MotherLanguage());
				returnValue = false;
			} else if (getPJCombo_Sex().isEmpty() || MINUS_VALUE.equals(getPJCombo_Sex().getText().trim())) {
				Factory.getInstance().addErrorMessage("Patient Sex should not be empty.", getPJCombo_Sex());
				returnValue = false;
			} else if (!getPJCombo_EduLvl().isEmpty() && !getPJCombo_EduLvl().isValid()) {
				Factory.getInstance().addErrorMessage("Invalid Education Level.", getPJCombo_EduLvl());
				returnValue = false;
			} else if (HKAH_VALUE.equals(getUserInfo().getSiteCode())
					&& getPJCombo_MarketingSource().isEmpty() && isPatientFlag()) {
				Factory.getInstance().addErrorMessage("Please select Marketing Source.", getPJCombo_MarketingSource());
				returnValue = false;
			} else if (!getPJCombo_MarketingSource().isEmpty() && !getPJCombo_MarketingSource().isValid()) {
				Factory.getInstance().addErrorMessage("Invalid Marketing Source.", getPJCombo_MarketingSource());
				returnValue = false;
			} else if (!getPJCombo_Religious().isEmpty() && !getPJCombo_Religious().isValid()) {
				Factory.getInstance().addErrorMessage("Invalid Religious.", getPJCombo_Religious());
				returnValue = false;
			} else if (!getPJText_Death().isEmpty() && DateTimeUtil.compareTo(getMainFrame().getServerDate(), getPJText_Death().getText()) == -1) {
				Factory.getInstance().addErrorMessage("The death date can't be later then today!", getPJText_Death());
				returnValue = false;
			} else if (getPJCheckBox_NewBorn().isSelected() && getPJText_MotherRecord().isEmpty()  ) {
				Factory.getInstance().addErrorMessage("Mother Record should not be empty.", getPJText_MotherRecord());
				returnValue = false;
			} else if (getAJCombo_Location().isEmpty() || MINUS_VALUE.equals(getAJCombo_Location().getText().trim())) {
				Factory.getInstance().addErrorMessage("Location can't empty.", getAJCombo_Location());
				returnValue = false;
			} else if (!getAJCombo_Location().isEmpty() && !getAJCombo_Location().isValid()) {
				Factory.getInstance().addErrorMessage("Invalid Location.", getAJCombo_Location());
				returnValue = false;
			} else if (!getAJCombo_Country().isEmpty() && !getAJCombo_Country().isValid()) {
				Factory.getInstance().addErrorMessage("Invalid Country.", getAJCombo_Country());
				returnValue = false;
			} else if (!getRJText_Relationship().isEmpty() && getRJText_Relationship().getDisplayText().length() > 25) {
				Factory.getInstance().addErrorMessage("Relationship between patient and kin can't be longer than 25.", getRJText_Relationship());
				returnValue = false;
			} else if (!getText_LongFName().isEmpty() && TextUtil.isExceedMaxLengthByAscCode(getText_LongFName().getText(), 160)) {
				Factory.getInstance().addErrorMessage("Patient Long Family name is too long.");
				returnValue = false;
			} else if (!getText_LongGName().isEmpty() && TextUtil.isExceedMaxLengthByAscCode(getText_LongGName().getText(), 160)) {
				Factory.getInstance().addErrorMessage("Patient Long Given name is too long.");
				returnValue = false;
			} else if (!getPJText_IDPassportNO().isEmpty() && getPJCombo_DocType().isEmpty() ) {
				Factory.getInstance().addErrorMessage("Document Type can not be empty!",getPJCombo_DocType());
				returnValue = false;
			} else if (!getPJText_IDPassportNO_S1().isEmpty() && getPJCombo_DocType_S1().isEmpty() ) {
				Factory.getInstance().addErrorMessage("Add.Document(1)Document Type can not be empty!",getPJCombo_DocType_S1());
				returnValue = false;
			} else if (!getPJText_IDPassportNO_S2().isEmpty() && getPJCombo_DocType_S2().isEmpty() ) {
				Factory.getInstance().addErrorMessage("Add.Document(2)Document Type can not be empty!",getPJCombo_DocType_S2());
				returnValue = false;
			} else if (!getAJText_Mobile().isEmpty() && getAJCombo_MobCouCode().isEmpty() && isPatientFlag()) {
				Factory.getInstance().addErrorMessage("Mobile Country Code can not be empty!",getAJCombo_MobCouCode());
				returnValue = false;
			} else if (getAJText_Email().isEmpty() && YES_VALUE.equals(getSysParameter("PEMAILMUST")) && isPatientFlag()) {
				Factory.getInstance().addErrorMessage("Patient Email can not be empty!",getAJText_Email());
				returnValue = false;				
			}  else if ((!getAJText_Mobile().isEmpty() && (getAJText_Mobile().getText().length() != 8)) && (!getAJCombo_MobCouCode().isEmpty() && "852".equals(getAJCombo_MobCouCode().getText())) && isPatientFlag()) {
				Factory.getInstance().addErrorMessage("HK mobile phone number must be 8 digits ");
				returnValue = false;
			} else if (!getTextArea_PatientRmk().isEmpty()&& TextUtil.isExceedMaxLengthByAscCode(getTextArea_PatientRmk().getText(), 1000)) {
				Factory.getInstance().addErrorMessage("Patient Remark is too long.");
				returnValue = false;
			} else {
				hasUpdatePatientInf = hasUpdatePatientData();
				if (hasUpdatePatientInf.size() > 0 && !isConfirmPatInfChg
						&& isModify() && isPatientFlag() && YES_VALUE.equals(getSysParameter("PATCTRSIGN"))) {
					getDlgPatSecCheck(actionType).showDialog(hasUpdatePatientInf,getRTJText_PatientNumber().getText());
					returnValue = false;
				}
			}

			// check patient number merge and new born
//			IsPatNoMerged(actionType, returnValue);

			callActionValidationReadyForPatientDOB(actionType, returnValue);
		}
	}

	private void callActionValidationReadyForPatientDOB(final String actionType, boolean returnValue) {
		if (returnValue) {
			if (getPJText_Birthday().getText().trim().length() > 0) {
				if (!getPJCheckBox_NewBorn().isSelected()
						&& DateTimeUtil.dateDiff(getMainFrame().getServerDate(), getPJText_Birthday().getText().trim()) < birthDayRange) {
					MessageBox mb = Factory.getInstance().isConfirmYesNoDialog("PBA-["+getTitle()+"]",
							ConstantsMessage.MSG_CONFIRM_PATIENT_NEWBORN,
							new Listener<MessageBoxEvent>() {
						@Override
						public void handleEvent(MessageBoxEvent be) {
							if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
								getPJCheckBox_NewBorn().setSelected(true);
							}

							//Original code didnt hv this, only warning is enough
							//callActionValidationReadyForPatientDOB(actionType, true);
							callActionValidationReadyForPatientName(actionType, true);
						}
					});

					mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
				} else if (QueryUtil.ACTION_APPEND.equals(getActionTypePatient())
						&& getPJCheckBox_NewBorn().isSelected()
						&& DateTimeUtil.dateDiff(getMainFrame().getServerDate(), getPJText_Birthday().getText().trim()) != 0) {
					MessageBox mb = Factory.getInstance().isConfirmYesNoDialog("PBA-["+getTitle()+"]",
							ConstantsMessage.MSG_CONFIRM_PATIENT_NB_BIRTHDAY,
							new Listener<MessageBoxEvent>() {
						@Override
						public void handleEvent(MessageBoxEvent be) {
							if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
								callActionValidationReadyForPatientName(actionType, true);
							} else {
								getPJText_Birthday().requestFocus();
								callActionValidationReadyForPatientName(actionType, false);
							}
						}
					});

					mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
				} else {
					callActionValidationReadyForPatientName(actionType, returnValue);
				}
			} else {
				// only warning
				MessageBox mb = Factory.getInstance().isConfirmYesNoDialog("PBA-["+getTitle()+"]",
						ConstantsMessage.MSG_CONFIRM_PATIENT_NB_NO_DOB,
						new Listener<MessageBoxEvent>() {
					@Override
					public void handleEvent(MessageBoxEvent be) {
						if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
							callActionValidationReadyForPatientName(actionType, true);
						} else {
							getPJText_Birthday().requestFocus();
							callActionValidationReadyForPatientName(actionType, false);
						}
					}
				});

				mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
			}
		} else {
			callActionValidationReadyForPatientName(actionType, returnValue);
		}
	}

	private void callActionValidationReadyForPatientName(String actionType, boolean returnValue) {
		if (returnValue) {
			if (isPatientFlag()
					&& QueryUtil.ACTION_MODIFY.equals(getActionTypePatient())
					&& (!memPatFName.equals(getPJText_FamilyName().getText())
							|| !memPatGName.equals(getPJText_GivenName().getText()))) {
				isPrompt_ChangeLongPatName = true;
			} else if (isAdditionInfoFlag()
					&& QueryUtil.ACTION_MODIFY.equals(getActionTypeAdditInfo())
					&& (!memPatLongFName.equals(getText_LongFName().getText())
							|| !memPatLongGName.equals(getText_LongGName().getText()))) {
				isPrompt_ChangeShortPatName = true;
			}
		}

		// check duplicate
		if (returnValue && isPatientFlag() && isAppend()) {
			getDuplicateDialog(actionType).showDialog(
					getRTJText_PatientNumber().getText(),
					getPJText_Birthday().getText(),
					getPJText_FamilyName().getText(),
					getPJText_GivenName().getText()
				);
		} else {
			callActionValidationReady(actionType, returnValue);
		}
	}

	private void callActionValidationReadyForAdmissionDate(String actionType, boolean returnValue) {
		if (returnValue
				&& isRegFlag()
				&& QueryUtil.ACTION_MODIFY.equals(getActionTypeRegistration())
				&& REG_TYPE_INPATIENT.equals(getCurrentRegistrationType())
				&& !memAdmissionDate.equals(getINJText_ADMDate().getText() + ":00")) {
			isPrompt_ChangeBedHistory = true;
		}
		callActionValidationReady(actionType, returnValue);
	}

	private void callActionValidationReady(String actionType, boolean returnValue) {
		if (returnValue
				&& isRegFlag()
				&& (QueryUtil.ACTION_APPEND.equals(getActionTypeRegistration()) || QueryUtil.ACTION_MODIFY.equals(getActionTypeRegistration()))
				&& REG_TYPE_OUTPATIENT.equals(getCurrentRegistrationType())) {
			callActionValidationReadyForConfirmBooking(actionType, returnValue);
		} else {
			actionValidationReady(actionType, returnValue);
		}
	}

	private void callActionValidationReadyForConfirmBooking(final String actionType, final boolean returnValue) {
		if (returnValue
				&& isRegFlag()
				&& (REG_NORMAL.equals(getRegistrationMode()) || REG_URGENTCARE.equals(getRegistrationMode()))
				&& memBkgID != null && memBkgID.length() > 0
				&& QueryUtil.ACTION_APPEND.equals(getActionTypeRegistration())
				&& REG_TYPE_OUTPATIENT.equals(getCurrentRegistrationType())) {
			//getMainFrame().setLoading(true);
			QueryUtil.executeMasterAction(getUserInfo(), "BOOKING_CHECK", QueryUtil.ACTION_APPEND,
					new String[] {
						memBkgID,
						CommonUtil.getComputerName(),
						getUserInfo().getUserID()
					},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						checkTicketNo(actionType, returnValue);
					} else {
						MessageBoxBase.confirm(MSG_PBA_SYSTEM, mQueue.getReturnMsg() + " Continue?",
								new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									checkTicketNo(actionType, returnValue);
								} else {
									// abort confirm appointment
									defaultFocus();
									actionValidationReady(actionType, false);
								}
							}
						});
					}
				}

				public void onComplete() {
					super.onComplete();
					//getMainFrame().setLoading(false);
				}
			});
		} else {
			checkTicketNo(actionType, returnValue);
		}
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	/*>>> override searchAction ======== <<<<*/
	@Override
	public void searchAction() {
		if (!getSearchButton().isEnabled()) {
			return;
		}

		triggerSearchField();
		enableButton("RegSave");
/*
		if (isPatientFlag() && getRTJText_PatientNumber().isEditable() && getRTJText_PatientNumber().isEmpty()) {
			getRTJText_PatientNumber().showSearchPanel();
		} else if (isRegFlag() && getINJText_BedNo().isEditable() && getINJText_BedNo().isEmpty()) {
			getINJText_BedNo().showSearchPanel();
		}
*/
//		getSaveButton().setEnabled(false);

	}

	/*>>> override acceptAction ======== <<<<*/
	@Override
	public void acceptAction() {
		if (!getAcceptButton().isEnabled()) {
			return;
		}

		if (getParameter("qPATNO") != null) {
			exitPanel();
		} else if (getParameter("AcceptClass") != null && getParameter("AcceptClass").equals("PatientSearch")) {
			setParameter("qPATNO", getListTable().getSelectedRowContent()[0]);
			showPanel(new RegistrationSearch());
		} else if (memOBBook1) {
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] {"patient", "death", "patno= '" + getRTJText_PatientNumber().getText() + "'"},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue chkDeath) {
					if (chkDeath.success()) {
						if (chkDeath.getContentField()[0].length() > 0) {
							MessageBoxBase.confirm(MSG_PBA_SYSTEM," Current patient is dead. Continue?",
									new Listener<MessageBoxEvent>() {
								@Override
								public void handleEvent(MessageBoxEvent be) {
									if (Dialog.NO.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
										removeParameter();
										defaultFocus();
									} else {
										removeParameter();
										setParameter("pno", getRTJText_PatientNumber().getValue());
										setParameter("pname", getRTJText_PatientName().getValue().toString());
										exitPanel();
									}
								}
							});
						} else {
							removeParameter();
							setParameter("pno", getRTJText_PatientNumber().getValue());
							setParameter("pname", RTJText_PatientName.getValue().toString());
							exitPanel();
						}
					}
				}
			});
		}
//		if (isSearchFieldsEmpty()) {
//			setRightAlignPanel();
//			enableButton();
//		} else {
//			super.acceptAction();
//			if (isRightAlignPanel()) {
//				getRTJText_PatientNumber().setEditable(true);
//			}
//		}
	}

	/*>>> override appendAction ======== <<<<*/
	@Override
	public void appendAction() {
		if (!getAppendButton().isEnabled()) {
			return;
		}

		rtvOldTabIndex = getRBTPanel().getSelectedIndex();
		isNewPatientEmptyField = true;
		memRegID = null;
		if (rtvOldTabIndex != 0 && getRTJText_PatientNumber().isFocusOwner()) {
			defaultFocus();
		}

		if (isRegFlag()) {
			//check death first
			isNewBorn = EMPTY_VALUE; //reset value

			// move several db call into one
			QueryUtil.executeMasterFetch(getUserInfo(), "PATIENT_NEWREG",
					new String[] { getRTJText_PatientNumber().getText().trim() },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(final MessageQueue mQueue) {
					if (mQueue.success()) {
						if (YES_VALUE.equals(mQueue.getContentField()[0])) {
							Factory.getInstance().isConfirmYesNoDialog(
									"PBA-[" + getTitle() + "]",
									"Current patient is dead. Continue?",
									new Listener<MessageBoxEvent>() {
								@Override
								public void handleEvent(MessageBoxEvent be) {
									if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
										initAppendAction(mQueue);
									}
								}
							});
						} else {
							initAppendAction(mQueue);
						}
					}
				}
			});
		} else {
			memPcyCode = EMPTY_VALUE;
			memArcCode = EMPTY_VALUE;
			super.appendAction();
		}
	}

	/*>>> override appendPostAction ======== <<<<*/
	@Override
	public void appendPostAction() {
		isNewPatientEmptyField = false;

		/*>>> override appendPostAction by child InPatient.java ======== <<<<*/
		if (isRegFlag()) {
			// Is Inpatient Registration
			// Patient is new born in Hospital
			// This is the first registration
			if (REG_INPATIENT.equals(getCurrentRegistrationType())) {
				if (getPJCheckBox_NewBorn().isSelected() &&
						(memRegID_L == null || memRegID_L.length() == 0) &&
						(memRegID_C == null || memRegID_C.length() == 0)) {
					getINJCheckBox_NewBorn().setSelected(true);

					if (memPreBooking) {
						getINJCheckBox_NewBorn().setSelected(false);
					}
				} else {
					getINJCheckBox_NewBorn().setSelected(false);
				}
			} else if (REG_DAYCASE.equals(getCurrentRegistrationType())) {
				getPJCheckBox_BE().setSelected(true);
			} else {
				getINJCheckBox_NewBorn().setSelected(false);
			}
		}

		if (isPatientFlag() && "TWAH".equals(getUserInfo().getSiteCode())) {
			getPJCombo_DocType().setText(getSysParameter("INTPATDTYP"));
		}

		if (isPatientFlag()) {
			getAJCombo_MobCouCode().setText("852");
		}

		if ("srhPatStsView".equals(memPre_form) && memPre_PBID != null) {
			formSrhPatStsView(memPre_PBID);
		}
	}

	/*>>> override modifyAction ======== <<<<*/
	@Override
	public void modifyAction() {
		if (!getModifyButton().isEnabled()) {
			return;
		}

		rtvOldTabIndex = getRBTPanel().getSelectedIndex();

		setActionType(QueryUtil.ACTION_MODIFY);
		super.modifyAction();
	}

	/*>>> override deleteAction ======== <<<<*/
	public void deleteAction() {
		if (!getDeleteButton().isEnabled()) {
			return;
		}

		rtvOldTabIndex = getRBTPanel().getSelectedIndex();

		if (isRegFlag() && (isAppend() || isModify())) {
			getRegDtorTable().removeSelectedRow();
		}
	}

	/*>>> override cancelYesAction ======== <<<<*/
	@Override
	public void cancelYesAction() {
		super.cancelYesAction();
		if (memPatNo != null && memPatNo.length() > 0) {
			showPatient(memPatNo);
		} else {
			showPatient();
		}
	}

	/*>>> override clearAction ======== <<<<*/
	@Override
	public void clearAction() {
		if (!getClearButton().isEnabled()) {
			return;
		}

		currentPatNo = null;
//		memPatNo = EMPTY_VALUE;
		memOldPatNo = EMPTY_VALUE;
		memRegID = null;
		super.clearAction();
		setActionType(null);
	}

	@Override
	protected void enableButton(String mode) {
		if (isDisableFunction("btnUpdateDeath", "regPatReg")) {
			getPJText_Death().setEditable(false);
		}

		if (!"RegSave".equals(mode)) {
			super.enableButton(mode);
		}
		boolean isActioning = isAppend() || isModify();
		boolean autoGenPatNo = TextUtil.isNumber(getSysParameter("NEXTPATNO"));

		getRTJLabel_PATNO().setEnabled(isActioning);
		getSearchButton().setEnabled(isPatientFlag() && !isDisableFunction("ToolBarSearch", "regPatReg"));
		getModifyButton().setEnabled((
										(
											(
													(isPatientFlag() && !isDisableFunction("TABPAGE", "regPatReg") && !isDisableFunction("btnEditPat", "regPatReg")) ||
													isAdditionInfoFlag() ||
													(isEhrFlag() && (
															(!isDisableFunction("ehrInfoEdit", "regPatReg")) ||
															(isEhrPmiExist() && !isEhrPmiActive() && !isDisableFunction("ehrInfoCreate", "regPatReg")) ||
															(!isEhrPmiExist() && !isDisableFunction("ehrInfoCreate", "regPatReg"))
															)
													) ||
													(isConsentFlag() && !isDisableFunction("tabConsent", "regPatReg"))
											) &&
											isRecordFound()
										) ||
										(
												isRegFlag() && memRegID != null && memRegID.length() > 0 &&
												!isDisableFunction("TABPAGE", "regPatReg")
										)
									) &&
									!isActioning && !isDisableFunction("TB_MODIFY", "regPatReg"));
		getAppendButton().setEnabled(
									(
										(
												isRegFlag() &&
												!REG_NOTHING.equals(getRegistrationMode()) &&
												isRecordFound() && !isDisableFunction("TABPAGE", "regPatReg")
										)
										||
										(
												isPatientFlag() && !isActioning &&
												!isDisableFunction("TABPAGE", "regPatReg") &&
												!isDisableFunction("btnEditPat", "regPatReg") &&
												!(memFromBk && memPatNo != null && memPatNo.length() > 0)
										)
									) &&
									!isDisableFunction("TB_INSERT", "regPatReg"));
		if (isPatientFlag() && memPreBooking) {
			getAppendButton().setEnabled(getAppendButton().isEnabled() && (!(memPatNo != null && memPatNo.length() > 0 && memPreBooking)));
		}

		getAcceptButton().setEnabled(isPatientFlag() && memPatNo != null && memPatNo.length() > 0 && memOBBook1);
		getDeleteButton().setEnabled(isRegFlag() && !isDisableFunction("TABPAGE", "regPatReg") && isActioning);
		getClearButton().setEnabled(isPatientFlag() && !isActioning && !isDisableFunction("TABPAGE", "regPatReg") && memPatNo != null && memPatNo.length() > 0);

		if (isPatientFlag() || isRegFlag()) {
			getCancelButton().setEnabled(isActioning && !isDisableFunction("TABPAGE", "regPatReg"));
			getSaveButton().setEnabled(isActioning && !isDisableFunction("TABPAGE", "regPatReg"));
		} else {
			getCancelButton().setEnabled(isActioning);
			getSaveButton().setEnabled(isActioning);
		}

		getRTJText_PatientNumber().setEditableForever(isPatientFlag() &&
				((!isAppend() || !autoGenPatNo || ((memFromBk || memPreBooking) && (memPatNo == null || memPatNo.length() == 0))) && !isModify()));
		getRTJText_PatientNumber().setReadOnly(!getRTJText_PatientNumber().isEditable());

		// set alert button
		enablePatRegButton();

		// eHR
//		System.err.println("check canSendMatchMsg");
//		System.out.println("isEhrFlag()="+isEhrFlag());
//		System.out.println("isEhrPmiExist()="+isEhrPmiExist());
//		System.out.println("isDisableFunction(\"ehrSendPmiMatch\", \"regPatReg\")="+isDisableFunction("ehrSendPmiMatch", "regPatReg"));
//		System.out.println("isActioning="+isActioning);

		boolean canEditeHRKey = false;
		boolean canEditPmi = isEhrFlag() && (
				(isEhrPmiExist() && !isDisableFunction("ehrInfoEdit", "regPatReg")) ||
				(!isEhrPmiExist() && !isDisableFunction("ehrInfoCreate", "regPatReg"))
				);
		boolean canSendMatchMsg = isEhrFlag() && isEhrPmiExist() && !isDisableFunction("ehrSendPmiMatch", "regPatReg") && !isActioning;
		getEhrCopyLatestPInfoBtn().setEnabled(canEditPmi && getEhrEnrollHistTable().getRowCount() > 0);
		getEhrSendMatchMsgBtn().setEnabled(canSendMatchMsg);
		getEhrEnrolButton().setEnabled(canEditPmi);
		getEJText_cEhrNo().setEditable(canEditeHRKey);
		getEJText_Death().setEditable(canEditeHRKey);
		getEhrEnrollHistTable().setEnabled(true);

		// consent
		getCSJButton_ConsentDoc1().setEnabled(!isAppend() && !isModify());
		getCSJButton_ConsentDoc2().setEnabled(!isAppend() && !isModify());
		getCSJButton_ConsentDoc3().setEnabled(!isAppend() && !isModify());
	}

	@Override
	protected void setAllRightFieldsEnabled(boolean enable) {
		if (getRightPanel() != null) {
			// reset field status
			PanelUtil.resetAllFieldsStatus(getCurrentTabPanel());
			// disable field
			PanelUtil.setAllFieldsEditable(getCurrentTabPanel(), enable);
			if (isPatientFlag()) {
				getRTJText_DentalPatientNo().setEditable(enable);
			}
//			this.setWorking(!enable);
		}
	}

	@Override
	protected void actionValidationPostReady(String actionType) {
		getSaveButton().setEnabled(false);
		final String regType = getCurrentRegistrationType();
		final String sRegCat = getRegCat(getRegistrationMode());

		if (QueryUtil.ACTION_APPEND.equals(isAppend)) {
			if ("A".equals(getSysParameter("TicketGen")) || "B".equals(getSysParameter("TicketGen"))) {
				QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
						new String[] { "MEDRECHDR", "COUNT(1)", "patno = '" + getRTJText_PatientNumber().getText() + "'" },
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							if (ZERO_VALUE.equals(mQueue.getContentField()[0])) {
								addMedicalRecord(QueryUtil.ACTION_APPEND, 0, "P", regType,
													getRTJText_PatientNumber().getText(),
													getUserInfo().getSiteCode(),
													getINJText_TreDrCode().getText(), null,
													getINJText_BedNo().getText().toUpperCase(),
													sRegCat, getUserInfo().getUserID(), 0, 0, -1,
													null);
							}
						}
					}
				});
			}

			if (isPatientFlag()) {
				showPatient();
			}
		}

		if (ACTION_SAVE.equals(actionType)) {
			if (isPatientFlag()) {
				if (QueryUtil.ACTION_APPEND.equals(isAppend)) {
					addNewPatient = true;
					memNewPatientNo = getRTJText_PatientNumber().getText();
				}
				ehrBuildConsent(getRTJText_PatientNumber().getText());
			}
			saving = false;
		}

		isAppend = null;
		if (ACTION_SAVE.equals(actionType)) {
			enableButton();
			isConfirmPatInfChg = false;
			if (memPatNo != null && memOldPatNo != null &&
				!memPatNo.equals(memOldPatNo)) {
				isPrompt_ChangeLongPatName = false;
				isPrompt_ChangeShortPatName = false;
			} else if (isPrompt_ChangeLongPatName) {
				isPrompt_ChangeLongPatName = false;
				MessageBoxBase.confirm(MSG_PBA_SYSTEM, "Do you need to change long patient name also?",
						new Listener<MessageBoxEvent>() {
					@Override
					public void handleEvent(MessageBoxEvent be) {
						if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
							getRBTPanel().setSelectedIndexWithoutStateChange(2);
							modifyAction();
							getText_LongFName().focus();
						} else {
							defaultFocus();
						}
					}
				});
			} else if (isPrompt_ChangeShortPatName) {
				isPrompt_ChangeShortPatName = false;
				MessageBoxBase.confirm(MSG_PBA_SYSTEM, "Do you need to change short patient name also?",
						new Listener<MessageBoxEvent>() {
					@Override
					public void handleEvent(MessageBoxEvent be) {
						if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
							getRBTPanel().setSelectedIndexWithoutStateChange(0);
							modifyAction();
							getPJText_FamilyName().focus();
						} else {
							defaultFocus();
						}
					}
				});
			}
			defaultFocus();

/*
			Factory.getInstance().addInformationMessage(
					"Save Record Completed.",
					new Listener<MessageBoxEvent>() {
				@Override
				public void handleEvent(MessageBoxEvent ce) {
					// update short names
					if (!memPatNo.equals(memOldPatNo)) {
						isPrompt_ChangeLongPatName = false;
						isPrompt_ChangeShortPatName = false;
					} else if (isPrompt_ChangeLongPatName) {
						isPrompt_ChangeLongPatName = false;
						MessageBoxBase.confirm(MSG_PBA_SYSTEM, "Do you need to change long patient name also?",
								new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									getRBTPanel().setSelectedIndexWithoutStateChange(2);
									modifyAction();
									getText_LongFName().focus();
								} else {
									defaultFocus();
								}
							}
						});
					} else if (isPrompt_ChangeShortPatName) {
						isPrompt_ChangeShortPatName = false;
						MessageBoxBase.confirm(MSG_PBA_SYSTEM, "Do you need to change short patient name also?",
								new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									getRBTPanel().setSelectedIndexWithoutStateChange(0);
									modifyAction();
									getPJText_FamilyName().focus();
								} else {
									defaultFocus();
								}
							}
						});
					}
					defaultFocus();
				}
			});
*/
			PanelUtil.setAllFieldsEditable(getMasterPanel(), false);
			confirmCancelButtonClicked();
			resetAllActionType();

			// call after all action done
			showPatient(getRTJText_PatientNumber().getText());
		} else if (ACTION_ACCEPT.equals(actionType)) {
			enableButton();
			confirmCancelButtonClicked();

			// call after all action done
			acceptPostAction();
		}
	}

	@Override
	protected void actionValidationReady(final String actionType, final boolean isValidationReady) {
		if (isValidationReady) {
			if (isRegFlag()) {
				//getMainFrame().setLoading(true);
				QueryUtil.executeMasterAction(getUserInfo(), getTxCode(), getActionType(),
						getActionInputParamaters(),
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						saving = false;

						if (mQueue.success()) {
							getSaveButton().setEnabled(false);
//							String regType = getCurrentRegistrationType();
//							String sRegCat = getRegCat(getRegistrationMode());
//							if (checkDateCompare() == 1 || checkDateCompare() == -1) {
//								Factory.getInstance().addErrorMessage("DOB is one day earlier or later than admission date");
//							}
							if (QueryUtil.ACTION_APPEND.equals(getActionType()) && !skipCreateSlip) {
								getINJText_SLPNO().setText(mQueue.getReturnCode());
							} else {
								/**Print Label Automatically**/
								//autoPrintLabel();
							}
							checkEbirthDtl();
							// following logic will put into getTrtDrInstruction
/*
							ticketUnlock();

							if (REG_INPATIENT.equals(regType) && isAppend()) {
								unlockRecord("Bed", getINJText_BedNo().getText(), new String[] { "checkAltAccess" });
							}

							PanelUtil.setAllFieldsEditable(getRegPanel(), false);
							resetAllActionType();

							if (RBTPanel.getSelectedIndex() == 0) {
								showPatient(getRTJText_PatientNumber().getText());
							} else if (RBTPanel.getSelectedIndex() == 1) {
								oldRegMode = getRegistrationMode();
								setRegistrationMode(REG_NOTHING);
								showRegistration();
							}
							ticketNo = null; // reset value
*/
							if (isPrompt_ChangeBedHistory) {
								MessageBoxBase.confirm(MSG_PBA_SYSTEM, "Admission Date is changed, do you want to modify Bed/Doctor history?",
										new Listener<MessageBoxEvent>() {
									@Override
									public void handleEvent(MessageBoxEvent be) {
										if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
											setParameter("PatNo", memPatNo);
											setParameter("SlpNo", getINJText_SLPNO().getText());
											setParameter("From", "regPatReg");
											showPanel(new DoctorBedTransfer());
										} else {
											defaultFocus();
										}
									}
								});
							}
							isPrompt_ChangeBedHistory = false;

							if (isAppend()) {
								// patient alert for Staff Admission
								if (REG_INPATIENT.equals(getCurrentRegistrationType())) {
									HashMap<String, String> params = new HashMap<String, String>();
									params.put("Admission Date/Time", getINJText_ADMDate().getText());
									params.put("Bed No.", getINJText_BedNo().getText());
									getAlertCheck().checkAltAccess(memPatNo, "staffadmission", "Admission of " + getRTJText_PatientName().getText() + " on " + getINJText_ADMDate().getText() + " (Staff)", false, true, params);
								} else if (!memFromBk) {
									QueryUtil.executeMasterFetch(getUserInfo(),
												ConstantsTx.DOCTOR_TXCODE,
												new String[] { getINJText_TreDrCode().getText() },
												new MessageQueueCallBack() {
											public void onPostSuccess(MessageQueue mQueue) {
												if (mQueue.success()) {
													HashMap<String, String> params = new HashMap<String, String>();
													params.put("Doctor Name", mQueue.getContentField()[1] + SPACE_VALUE + mQueue.getContentField()[2]);
													getAlertCheck().checkAltAccess(memPatNo, "Accept Appointment", false, true, params);
												}
											}
										});
								}
							}
							
							if (YES_VALUE.equals(getSysParameter("ISIPABILL")) && isRegFlag() && REG_INPATIENT.equals(getCurrentRegistrationType())) {
								final Map<String,String> map = new HashMap<String,String>();
								map.put("SUBREPORT_DIR", CommonUtil.getReportDir());
								map.put("P_SLPNO", getINJText_SLPNO().getText() );
								map.put("ALLSLPNO", getINJText_SLPNO().getText() );
								map.put("ISCOPY", "Y");
							
								Factory.getInstance()
									.addRequiredReportDesc(map,
											   new String[] {
														"MapLanguage", "MapLanguage", "MapLanguage",
														"MapLanguage", "MapLanguage", "MapLanguage",
														"MapLanguage", "MapLanguage", "MapLanguage",
														"MapLanguage", "MapLanguage", "MapLanguage",
														"MapLanguage", "MapLanguage", "MapLanguage",
														"MapLanguage", "MapLanguage", "MapLanguage",
														"MapLanguage", "MapLanguage"
												},
											   new String[] {
														"StaOfAut", "AdmDtTime", "PatName", "DisDtTime",
														"TreDr", "BillNo", "PatNo", "BedNo", "Copy",
														"Page", "Date", "Item", "Amount", "TotChg",
														"TotRfd", "Balance", "patM", "patB", "BirthDt",
														"DelDr"
												},
												(TWAH_VALUE.equals(getUserInfo().getSiteCode())?"CHT":"CTE"));

								map.put("watermark", CommonUtil.getReportImg("app_watermark.gif"));
								
								AppStmtUtil.createAppBill(true, "", "IR", "Y", getINJText_SLPNO().getText(),map, memPatNo );
							}

							if (isRegFlag() && REG_INPATIENT.equals(getCurrentRegistrationType()) && HKAH_VALUE.equals(getUserInfo().getSiteCode())) {
								Factory.getInstance().addInformationMessage("Please process FTOCC");
							}

							ehrDownloadAllergyAdr();
						} else {
							if ("-100".equals(mQueue.getReturnCode())) {
								Factory.getInstance().addErrorMessage(mQueue.getReturnMsg(), getINJCombo_ARC());
								getINJCombo_ARC().requestFocus();
							} else if ("-200".equals(mQueue.getReturnCode())) {
								Factory.getInstance().addErrorMessage(mQueue.getReturnMsg(), getINJText_BedNo());
								getINJText_BedNo().requestFocus();
							} else if ("-300".equals(mQueue.getReturnCode())) {
								Factory.getInstance().addErrorMessage(mQueue.getReturnMsg(), getINJText_ADMDoctor());
								getINJText_ADMDoctor().requestFocus();
							} else if ("-400".equals(mQueue.getReturnCode())) {
								Factory.getInstance().addErrorMessage(mQueue.getReturnMsg(), getINJText_TreDrCode());
								getINJText_TreDrCode().requestFocus();
							} else if ("-10".equals(mQueue.getReturnCode())) {//-10: other error
								Factory.getInstance().addErrorMessage(mQueue.getReturnMsg());
							} else if (ConstantsRegistration.BED_NOT_AVAILABLE.equals(mQueue.getReturnCode().substring(1))) {
								Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_BED_UNAVAILABLE, getINJText_BedNo());
								getINJText_BedNo().resetText();
								getINJText_DeptCode().resetText();
								getINJText_WardType().resetText();
								getINJCombo_AcmCode().resetText();
								getINJText_AcmCode().resetText();
								getINJText_RmExt().resetText();
								getINJText_BedIsWindow().resetText();
								getINJText_BedNo().focus();
							} else if (ConstantsRegistration.BED_WRONG_SEX.equals(mQueue.getReturnCode().substring(1))) {
								saving = true;
								MessageBoxBase.confirm(MSG_PBA_SYSTEM,ConstantsMessage.MSG_BED_WRONG_SEX,
										new Listener<MessageBoxEvent>() {
									@Override
									public void handleEvent(MessageBoxEvent be) {
												if (Dialog.NO.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
													getINJText_BedNo().resetText();
													getINJText_DeptCode().resetText();
													getINJText_WardType().resetText();
													getINJCombo_AcmCode().resetText();
													getINJText_AcmCode().resetText();
													getINJText_RmExt().resetText();
													getINJText_BedIsWindow().resetText();
													getINJText_BedNo().focus();

													getSaveButton().setEnabled(true);
													enablePatRegEditFiled();
													saving = false;
												} else {
													skipBedChecking = true;
													actionValidationReady(actionType, isValidationReady);
													return;
												}
											}
										});
							} else if (ConstantsRegistration.BED_NOT_CLEAN.equals(mQueue.getReturnCode().substring(1))) {
								saving = true;
								MessageBoxBase.confirm(MSG_PBA_SYSTEM,ConstantsMessage.MSG_BED_UNCLEAN,
										new Listener<MessageBoxEvent>() {
									@Override
									public void handleEvent(MessageBoxEvent be) {
										if (Dialog.NO.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
											getINJText_BedNo().resetText();
											getINJText_DeptCode().resetText();
											getINJText_WardType().resetText();
											getINJCombo_AcmCode().resetText();
											getINJText_AcmCode().resetText();
											getINJText_RmExt().resetText();
											getINJText_BedIsWindow().resetText();
											getINJText_BedNo().focus();

											getSaveButton().setEnabled(true);
											enablePatRegEditFiled();
											saving = false;
										} else {
											skipBedChecking = true;
											actionValidationReady(actionType, isValidationReady);
											return;
										}
									}
								});
							}

							if (!saving) {
								if (isRegFlag()) {
									getSaveButton().setEnabled(true);
									enablePatRegEditFiled();
								} else {
									enableButton();
								}
							}
							return;
						}
					}

					public void onComplete() {
						super.onComplete();
						getMainFrame().setLoading(false);
					}
				});
			} else {
				getSaveButton().setEnabled(false);
				
				if (isAppend()) {
					isAppend = isAppend()? QueryUtil.ACTION_APPEND : QueryUtil.ACTION_MODIFY;
				} else {
					// log edit patient master index by staff id
					writePatientLog(getRTJText_PatientNumber().getText(), "EDIT-HATS", "Edit patient profile of #" + getRTJText_PatientNumber().getText(), getUserInfo().getSsoUserID());
				}
				super.actionValidationReady(actionType, isValidationReady);
			}
		} else {
			saving = false;
			getSaveButton().setEnabled(true);
			getMainFrame().setLoading(false);
//			enableButton();
		}
	}

	@Override
	protected void unlockRecordReady(final String lockType, final String lockKey, String[] record, boolean unlock, String returnMessage) {
		if ("Bed".equals(lockType) && record != null) {
			checkAltAccess();
		}
	}

	@Override
	protected void savePostAction() {
		// reload patient after saved
		if ((isPatientFlag() || isAdditionInfoFlag()) && memPatNo != null && memPatNo.length() > 0) {
			showPatient(memPatNo);
		}
		if (isPatientFlag()) {
			// check pmi consent
			ehrBuildConsent(memPatNo);
		}
	}

	@Override
	protected boolean triggerSearchField() {
		currentPatNo = getRTJText_PatientNumber().getText().trim();

		if (getRTJText_PatientNumber().isFocusOwner()) {
			getRTJText_PatientNumber().checkTriggerBySearchKey();
			return true;
		} else if (getINJText_BedNo().isFocusOwner()) {
			getINJText_BedNo().checkTriggerBySearchKey();
			return true;
		}

		return false;
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/
	
	private void ehrBuildConsent(String patno) {
		String url = getSysParameter("EHRBCLNK");
		if (url == null) {
			Factory.getInstance().addErrorMessage("Cannot get build consent message path. Please contact IT support.");
		} else {
			final Window ehrDownloadFormWin = new Window();
			ehrDownloadFormWin.setSize(0, 0);
			ehrDownloadFormWin.setPosition(-1000, -1000);	//hidden
			ehrDownloadFormWin.setHeadingHtml("eHR build consent");
			
			final FormPanel downloadFormPanel = new FormPanel();
	
			final TextField<String> patNo = new TextField<String>();
			patNo.setName("patno");
			patNo.setValue(patno);
			downloadFormPanel.add(patNo);
	
			final TextField<String> userID = new TextField<String>();
			userID.setName("userID");
			userID.setValue(getUserInfo().getUserID());
			downloadFormPanel.add(userID);
	
			downloadFormPanel.setAction(url);
			downloadFormPanel.setMethod(Method.POST);
			downloadFormPanel.addListener(Events.Submit, new Listener<FormEvent>() {
				@Override
				public void handleEvent(FormEvent be) {
					ehrDownloadFormWin.hide();
					String htmlResult = be.getResultHtml();
					String resultMsg = "";
	
					if (htmlResult != null) {
						JSONValue ret = JSONParser.parseStrict(htmlResult);
						JSONObject o = ret.isObject();
						if (o != null) {
							String rCode = o.get("responseCode").toString();
							String rMsg = o.get("responseMessage").toString();
							String rTs = o.get("ts").toString();
	
							resultMsg += rCode + ": " + rMsg + "<br />(" + rTs + ")";
						}
					} else {
						resultMsg += "Request sent. No response code return.";
					}
				}
			});
			ehrDownloadFormWin.add(downloadFormPanel);
			ehrDownloadFormWin.show();
			downloadFormPanel.submit();
		}
	}

	private void ehrDownloadAllergyAdr() {
		// check if patient is active ehr pmi
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] { "ehr_pmi", "active", "patno = '" + memPatNo + "'" },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					if ("-1".equals(mQueue.getContentField()[0])) {
						ehrDownloadAllergyAdrWin();
					}
				}
			}
		});
	}

	private void ehrDownloadAllergyAdrWin() {
		final Window ehrDownloadAllergyAdrWin = new Window();
		ehrDownloadAllergyAdrWin.setSize(0, 0);
		ehrDownloadAllergyAdrWin.setPosition(-1000, -1000);	//hidden
		ehrDownloadAllergyAdrWin.setHeadingHtml("Download eHR allergy/ADR");
		ehrDownloadAllergyAdrWin.setVisible(false);

		String isDownloadAllergyAdr = getSysParameter("EHRAL1ISDL");

		if ("Y".equals(isDownloadAllergyAdr)) {
			String downloadAllergyLink = getSysParameter("EHRAL1DLNK");
			if (downloadAllergyLink == null) {
				Factory.getInstance().addSystemMessage("No download EHR allergy/ADR Url (EHRAL1DLNK)");
			} else {
				final FormPanel downloadFormPanel = new FormPanel();

				final TextField<String> patNo = new TextField<String>();
				patNo.setName("patNo");
				patNo.setValue(memPatNo);
				downloadFormPanel.add(patNo);

				final TextField<String> userID = new TextField<String>();
				userID.setName("userID");
				userID.setValue(getUserInfo().getUserID());
				downloadFormPanel.add(userID);

				final TextField<String> moduleCode = new TextField<String>();
				moduleCode.setName("moduleCode");
				moduleCode.setValue(getUserInfo().getSsoModuleCode());
				downloadFormPanel.add(moduleCode);

				final TextField<String> sessionID = new TextField<String>();
				sessionID.setName("sessionID");
				sessionID.setValue(getUserInfo().getSsoSessionID());
				downloadFormPanel.add(sessionID);

				downloadFormPanel.setAction(downloadAllergyLink);
				downloadFormPanel.setMethod(Method.POST);
				downloadFormPanel.addListener(Events.Submit, new Listener<FormEvent>() {
					@Override
					public void handleEvent(FormEvent be) {
						ehrDownloadAllergyAdrWin.hide();
						String htmlResult = be.getResultHtml();
						String resultMsg = "";

						if (htmlResult != null) {
							JSONValue ret = JSONParser.parseStrict(htmlResult);
							JSONObject o = ret.isObject();
							if (o != null) {
								String rCode = o.get("responseCode").toString();
								String rMsg = o.get("responseMessage").toString();
								String rTs = o.get("ts").toString();

								resultMsg += rCode + ": " + rMsg + "<br />(" + rTs + ")";
							}
						} else {
							resultMsg += "Sent. No response code return.";
						}

						/*
						Factory.getInstance().addInformationMessage(resultMsg, "Download result", new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
							}
						});
						*/
					}
				});
				ehrDownloadAllergyAdrWin.add(downloadFormPanel);
				ehrDownloadAllergyAdrWin.show();
				downloadFormPanel.submit();
			}
		}
	}

	private void autoPrintLabel() {
		if (YES_VALUE.equalsIgnoreCase(Factory.getInstance().getSysParameter("AUTOREGLBL"))) {
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] { "slip", "slptype", "slpno = '" + getINJText_SLPNO().getText() + "'" },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						if ("I".equals(mQueue.getContentField()[0]) ||
								"D".equals(mQueue.getContentField()[0])) {
							//getDlgNoOfLblToBePrtInp().showDialog(memPatNo, true);
						} else if ("O".equals(mQueue.getContentField()[0])) {
							getDlgNoOfLblToBePrtOutp().showDialog(memPatNo, null, null, null, true, true);
							printPhysicalOrderForm();
						}
					}
				}
			});
		}
	}

	private void checkAltAccess() {
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] {"bed", "romcode", "bedcode='" + getINJText_BedNo().getText().toUpperCase() + "'"},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				String roomNo = null;
				if (mQueue.success()) {
					roomNo = mQueue.getContentField()[0];
				}
//				System.out.println("DEBUG Patient checkAltAccess Doctor Name="+getINRJText_ADMDoctor().getText()+
//						", Room No="+roomNo+", Adm. Date="+getINJText_ADMDate().getText());

				Map<String, String> params = new HashMap<String, String>();
				params.put("Doctor Name", getINRJText_ADMDoctor().getText());
				params.put("Room No", roomNo);
				params.put("Adm. Date", getINJText_ADMDate().getText());
				params.put("Title", getPJCombo_Title().getText());
				getAlertCheck().checkAltAccess(memPatNo, "Inpatient Registration", false, true, params);
			}
		});
	}

	public void writePatientLog(String patno, String logAction, String remark, String userID) {
		QueryUtil.executeMasterAction(getUserInfo(), "PATIENTACTIVITYLOG", QueryUtil.ACTION_APPEND,
				new String[] {
						patno, "Patient Master Index", logAction, remark, (userID == null ? getUserInfo().getUserID() : userID), CommonUtil.getComputerName()
				});
	}

	/***************************************************************************
	 * Append Registration Method
	 **************************************************************************/

	private void superAppendAction() {
		super.appendAction();
	}

	private void checkInpat(String hasInpdate2, String medloc, String medtype) {
		if (YES_VALUE.equals(hasInpdate2)) {
			if (getRTJRadio_InPatient().isSelected()) {
				Factory.getInstance().addErrorMessage(
						"The patient is a current inpatient.",
						"PBA-[" + getTitle() + "]");
				return;
			}
		}
		superAppendAction();
		fillMedicalRecord(medloc, medtype);

		if (memDocCode != null && memDocCode.length() > 0) {
			getINJText_TreDrCode().setText(memDocCode);
			checkDocExist(memDocCode);
		}

		if (memPcyCode != null && memPcyCode.length() > 0) {
			getINJCombo_Category().setSelectedIndex(getINJCombo_Category().findModelByKey(memPcyCode));
		}

		if (memArcCode != null && memArcCode.length() > 0) {
			getINJCombo_ARC().setText(memArcCode); //ARCCODE
		}

		getINJText_LAmt().setText(ZERO_VALUE);
		getINJText_CPAmt().setText(ZERO_VALUE);
		getINJText_FGAmt().setText(ZERO_VALUE);
		getINJText_Deduct().setText(ZERO_VALUE);
		String dateStr = getMainFrame().getServerDateTime();
		if (dateStr != null && dateStr.length() > 21) {
			dateStr = dateStr.substring(0, 21);
		}
		getINJText_ADMDate().setText(dateStr);
		getINJText_RegDate().setText(dateStr);

		getINJText_VHNO().setText(memPre_voucher);
//		getINJText_VHNO().setEditable(false);
		getINJText_PreAuthNo().setText(memPre_authno);
		if (memSTAYLEN != null && memSTAYLEN.length() > 0 && Integer.parseInt(memSTAYLEN) > 0) {
			getINJText_LengthOfStay().setEditable(false);
			getINJText_LengthOfStay().setText(memSTAYLEN);
		}

		if (memPkgCode != null && memPkgCode.trim().length() > 0) {
			getRegDtorTable().addRow(
					new String[] {memPkgCode, null, null, null, null, null, null});
		}
		
		if (memBPBPkgCode != null && memBPBPkgCode.trim().length() > 0) {
			getRegDtorTable().addRow(
					new String[] {memBPBPkgCode, null, null, null, null, null, null});
		}
		
		if (getParameter("BkgNatureOfVisit") != null && getParameter("BkgNatureOfVisit").length() > 0) {
			getRTCombo_nature().setText(getParameter("BkgNatureOfVisit"));
		}


		if (getRTJRadio_InPatient().isSelected()) {
			getINJText_BedNo().focus();
		} else {
			getINJText_TreDrCode().focus();
		}
	}

	private void initAppendAction(MessageQueue mQueue) {
		String hasInpdate1 = mQueue.getContentField()[1];
		final String hasInpdate2 = mQueue.getContentField()[2];
		final String medloc = mQueue.getContentField()[3];
		final String medtype = mQueue.getContentField()[4];

		if (isRegFlag()) {
			if (getActionType() == null) {
				getRegDtorTable().removeAllRow();
/*
				QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
						new String[] { "BOOKING_EXTRA", "NATUREOFVISIT", "BKGID='" + memBkgID + "'" },
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							if (!"".equals(mQueue.getContentField()[0]) && mQueue.getContentField()[0] != null) {
								getRegDtorTable().addRow(
										new String[] {mQueue.getContentField()[0], null, null, null, null, null, null});
								getRegDtorTable().addRow(
										new String[] {"GEN", null, null, null, null, null, null});
							}
						}
					}
				});
*/
			}

			if (isAppend()) {
				getRegDtorTable().addRow(new String[] {null, null, null, null, null, null, null});
				getRegDtorTable().focus();
			} else {
				// check Current Inpatient
				if (YES_VALUE.equals(hasInpdate1)) {
					if (getRTJRadio_InPatient().isSelected()) {
						Factory.getInstance().addErrorMessage(
								MSG_CURRENT_INPATIENT,
								"PBA-[" + getTitle() + "]");
					} else {
						Factory.getInstance().isConfirmYesNoDialog("PBA-[" + getTitle() + "]",
								MSG_CURRENT_INPATIENT +
								"Do you want to continue?", new Listener<MessageBoxEvent>() {
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									checkInpat(hasInpdate2, medloc, medtype);
								}
							}
						});
					}
				} else {
					checkInpat(hasInpdate2, medloc, medtype);
				}
			}
		}
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	private void changeLayoutPerParameter() {
		if (YES_VALUE.equals(getSysParameter("OTHandOver"))) {
			getINButton_AdmFrm().setBounds(5, 123, 103, 23);
			getINButton_PrintLabel().setBounds(110, 123, 73, 23);
			getINButton_PrintChartLabel().setBounds(185, 123, 133, 23);
			getINButton_PrintOTHandOver().setVisible(true);
		} else {
			getINButton_AdmFrm().setBounds(5, 123, 132, 23);
			getINButton_PrintLabel().setBounds(139, 123, 132, 23);
			getINButton_PrintChartLabel().setBounds(273, 123, 132, 23);
			getINButton_PrintOTHandOver().setVisible(false);
		}

		if (YES_VALUE.equals(getSysParameter("PatIDConty"))) {

			getPJLabel_MaidenName().setVisible(false);
			getPJText_MaidenName().setVisible(false);
			getPJLabel_Title().setBounds(5, 150, 30, 20);
			getPJCombo_Title().setBounds(85, 150, 135, 20);

			getPJText_FamilyName().setBounds(85, 75, 330, 20);
		}

		if (YES_VALUE.equals(getSysParameter("PatChkID"))) {
			getPJLabel_Interpreter().setVisible(false);
			getPJCheckBox_Interpreter().setVisible(false);
			getPJLabel_Staff().setVisible(false);
			getPJCheckBox_Staff().setVisible(false);
			getPJLabel_CheckID().setVisible(true);
			getPJCheckBox_CheckID().setVisible(true);
			getPJText_CheckIDLastUpdatedDate().setVisible(true);
			getPJText_CheckIDLastUpdatedBy().setVisible(true);

			getPJLabel_SMS().setLocation(95, 355);
			getPJCheckBox_SMS().setLocation(120, 355);
		}
		
		if (YES_VALUE.equals(Factory.getInstance().getSysParameter("DISABLERM"))) {
			getRTCombo_docRoomDesc().setVisible(false);
			getRTCombo_docRoom().setVisible(false);
		}
		
		if (YES_VALUE.equals(Factory.getInstance().getSysParameter("HIDENATURE"))) {
			getRTCombo_natureDesc().setVisible(false);
			getRTCombo_nature().setVisible(false);
		}

//		getINJLabel_Source().setVisible(true);

		if (HKAH_VALUE.equals(getUserInfo().getSiteCode())) {
			getINJCombo_Source().setWidth(50);
			getINJLabel_SourceNo().setVisible(true);
			getINJText_SourceNo().setVisible(true);
			getINJLabel_RmExt().setVisible(true);
			getINJText_RmExt().setVisible(true);
			getRightJLabel_SpRqt().setVisible(true);
			getRightJCombo_SpRqt().setVisible(true);
			getINJCombo_Package().setVisible(true);
			getINJLabel_Package().setVisible(true);
			getPJLabel_EstGiven().setVisible(true);
			getPJCheckBox_EstGiven().setVisible(true);
			getINJLabel_LengthOfStay().setVisible(false);
			getINJText_LengthOfStay().setVisible(false);
			getINJLabel_RevLog().setVisible(true);
			getINJCheckBox_Revlog().setVisible(true);
			getINJLabel_LogCvrCls().setVisible(true);
			getINJCombo_LogCvrCls().setVisible(true);
			getRightJCombo_Misc().setVisible(true);
			getRightJLabel_Misc().setVisible(true);
			getINJText_BedIsWindow().setVisible(true);
			getRightButton_BudgetEst().setVisible(true);
			getPJCheckBox_BEDesc().setVisible(true);
			getPJCheckBox_BE().setVisible(true);
			getINButton_IdtLabelBtn().setVisible(true);
			getINButton_UKCert().setVisible(true);

			getPJText_Birthday().setBounds(85, 175, 90, 20);
			getPJLabel_Age().setBounds(185, 175, 20, 20);
			getPJText_Age().setBounds(210, 175, 40, 20);
			getPJLabel_BirthOrdSPG().setVisible(true);
			getPJCombo_BirthOrdSPG().setVisible(true);

			getINJLabel_WardType().setBounds(243, 25, 40, 20);
			getINJLabel_WardType().setText("Ward");
			getINJText_WardType().setBounds(275,25,80,20);
			getINJLabel_AcmCode().setBounds(5,50,110,20);
			getINJCombo_AcmCode().setBounds(120,50,80,20);
			getINJText_AcmCode().setBounds(205,50,150,20);
			getINJLabel_NewBorn().setBounds(5, 75, 110, 20);
			getINJCheckBox_NewBorn().setBounds(65, 75, 20, 20);
			getINJLabel_Mom().setBounds(85, 75, 50, 20);
			getFromMainlandPanel().setBounds(120, 75, 235, 20);
			getINJLabel_ADMDoctor().setBounds(5, 100, 110, 20);
			getINJText_ADMDoctor().setBounds(120, 100, 74, 20);
			getINRJText_ADMDoctor().setBounds(197, 100, 158, 20);
			getINJLabel_RefDoctor1().setVisible(true);
			getINJText_RefDoctor1().setVisible(true);
			getINRJText_RefDoctor1().setVisible(true);
			getINJLabel_RefDoctor2().setVisible(true);
			getINJText_RefDoctor2().setVisible(true);
			getINRJText_RefDoctor2().setVisible(true);
			getINJLabel_ADMDate().setBounds(5, 175, 110, 20);
			getINJText_ADMDate().setBounds(120, 175, 235, 20);
			getINJLabel_ADMFrom().setBounds(5, 200, 110, 20);
			getINJCombo_ADMFrom().setBounds(120, 200, 235, 20);
			getINJLabel_ADMType().setBounds(5, 225, 110, 20);
			getINJCombo_ADMType().setBounds(120, 225, 235, 20);
			getINJLabel_Remark().setBounds(5, 250, 110, 20);
			getINJText_Remark().setBounds(120, 250, 235, 20);
			getRightJLabel_SpRqt().setBounds(5, 275, 110, 20);
			getRightJCombo_SpRqt().setBounds(120, 275, 120, 20);
			getINJLabel_RmExt().setBounds(245, 275, 50, 20);
			getINJText_RmExt().setBounds(295, 275, 60, 20);
			getINJLabel_Package().setBounds(5, 300, 20, 20);
			getINJCombo_Package().setBounds(120, 300, 235, 20);
			getPJLabel_EstGiven().setBounds(5, 325, 70, 13);
			getPJCheckBox_EstGiven().setBounds(65, 325, 20, 20);
			getRightButton_BudgetEst().setBounds(120, 325, 120, 22);
			getPJCheckBox_BEDesc().setBounds(245, 325, 20, 20);
			getPJCheckBox_BE().setBounds(270, 325, 20, 20);
		}

		getINButton_PatientCardButton().setVisible(YES_VALUE.equalsIgnoreCase(getSysParameter("PRPATCARD")));
		getINButton_IPGeneralLabelButton().setVisible(YES_VALUE.equalsIgnoreCase(getSysParameter("PRGENLBL")));
		getINButton_RegLabelBtn().setVisible(YES_VALUE.equalsIgnoreCase(getSysParameter("PRTADMLBL")));
		getINButton_DlgPrtCallChartButton().setVisible(YES_VALUE.equalsIgnoreCase(getSysParameter("PRCALLCHRT")));
		getINButton_PrintEShare().setVisible(true);
	}

	private String getServerPath() {
		if (SERVER_PATH == null) {
			SERVER_PATH = HTTP_URL_PREFIX + getSysParameter("ptIgUrlSte") + "/intranet/hat/patientImage.jsp?patno=";
		}
		return SERVER_PATH;
	}

	private String getDefaultNoImage() {
		if (DEFAULT_NO_IMAGE == null) {
			DEFAULT_NO_IMAGE = HTTP_URL_PREFIX + getSysParameter("ptIgUrlSte") + "/hats/images/Photo Not Available.jpg";
		}
		return DEFAULT_NO_IMAGE;
	}

	private String getConsentUrl() {
		if (CONSENT_URL == null) {
			CONSENT_URL = HTTP_URL_PREFIX + getSysParameter("ptIgUrlSte") + CONSENT_URL_SUFFIX;
		}
		return CONSENT_URL;
	}

	private String getFTOCCUrl() {
		if (FTOCC_URL == null) {
			FTOCC_URL = HTTP_URL_PREFIX + getSysParameter("ptIgUrlSte") + FTOCC_URL_SUFFIX;
		}
		return FTOCC_URL;
	}
	
	private String getAppAdminUrl() {
		if (APPADMIN_URL == null) {
			APPADMIN_URL = HTTP_URL_PREFIX + getSysParameter("ptIgUrlSte") + APPADMIN_URL_SUFFIX;
		}
		return APPADMIN_URL;
	}

//	private void initpatient_formOBBook() {
//		if (getParameter("PatNo") != null && !(getParameter("PatNo").trim().equals(""))) {
//			getRTJText_PatientNumber().setValue(getParameter("PatNo"));
//			searchPatient();
//		} else {
//			getRTJText_PatientName().setValue(getParameter("pat_name"));
//			getPJText_FamilyName().setValue(getParameter("pat_Fname"));
//			getPJText_GivenName().setValue(getParameter("pat_Gname"));
//			getRTJText_PATCName().setValue(getParameter("pat_Cname"));
//			getPJText_ChineseName().setValue(getParameter("pat_Cname"));
//			getRTJText_PatientNumber().focus();
//		}
//	}

	private BasePanel getCurrentTabPanel() {
		if (isRegFlag()) {
			return getRegPanel();
		} else if (isAdditionInfoFlag()) {
			return getAdditInfoPanel();
		} else if (isEhrFlag()) {
			return getEhrPanel();
		} else if (isConsentFlag()) {
			return getConsentPanel();
		} else {
			return getMasterPanel();
		}
	}

	private void formSrhPatStsView(String prePBID) {
		// set default date
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.PREBOOKDETAIL,
				new String[] { prePBID },
				new MessageQueueCallBack() {
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					setParameterHelper("pre_ArcCode", mQueue, 0);
					setParameterHelper("pre_COPAYTYP", mQueue, 1);
					setParameterHelper("pre_CoPayamt", mQueue, 2);
					setParameterHelper("pre_POLICY", mQueue, 3);
					setParameterHelper("pre_ARLMTAMT", mQueue, 4);
					setParameterHelper("pre_CVREDATE", mQueue, 5);
					setParameterHelper("pre_voucher", mQueue, 6);
					setParameterHelper("Pre_FURGRTAMT", mQueue, 7);
					setParameterHelper("Pre_FURGRTDATE", mQueue, 8);
					setParameterHelper("pre_isDoctor", mQueue, 9);
					setParameterHelper("pre_isSpecial", mQueue, 10);
					setParameterHelper("Pre_isHospital", mQueue, 11);
					setParameterHelper("pre_isOther", mQueue, 12);
					setParameterHelper("pre_DOCCODE", mQueue, 13);
					setParameterHelper("pre_PBMID", mQueue, 14);
					setParameterHelper("pre_PBSNO", mQueue, 15);
					setParameterHelper("pre_PBSID", mQueue, 16);
					setParameterHelper("pre_PBMCODE", mQueue, 17);
					setParameterHelper("pre_ACTID", mQueue, 18);
					setParameterHelper("pre_ACTYPE", mQueue, 19);
					setParameterHelper("pre_ISRECLG", mQueue, 20);
					setParameterHelper("pre_ARACMCODE", mQueue, 21);
					setParameterHelper("pre_PBPKGCODE", mQueue, 22);
					setParameterHelper("pre_PBESTGIVN", mQueue, 23);
					setParameterHelper("pre_DEDUCTIBLE", mQueue, 24);
					setParameterHelper("pre_FESTID", mQueue, 25);
					setParameterHelper("pre_FESTBE", mQueue, 26);
					setParameterHelper("pre_authno", mQueue, 27);

					final String sArcCode = getParameter("pre_ArcCode");
					if (sArcCode != null && sArcCode.length() > 0) {
						getINJCombo_ARC().setText(sArcCode);
						getINJCombo_ARC().getSearchArCode().setText(sArcCode);
						getINJCombo_CPAmt().setText(getParameter("pre_COPAYTYP"));
						getINJText_CPAmt().setText(getParameter("pre_CoPayamt"));
						getINJText_PLNO().setText(getParameter("pre_POLICY"));
						getINJText_LAmt().setText(getParameter("pre_ARLMTAMT"));
						getINJText_ARCardType().setText(getParameter("pre_ACTYPE"));
						String endDate = getParameter("pre_CVREDATE");
						if (endDate != null && endDate.length() >= 10) {
							getINJText_endDate().setText(endDate.substring(0, 10));
						} else {
							getINJText_endDate().resetText();
						}
						getINJText_VHNO().setText(getParameter("pre_voucher"));
						getINJText_PreAuthNo().setText(getParameter("pre_authno"));
						getINJText_FGAmt().setText(getParameter("Pre_FURGRTAMT"));
						String furGrtDate = getParameter("Pre_FURGRTDATE");
						if (furGrtDate != null && furGrtDate.length() >= 10) {
							getINJText_FGDate().setText(furGrtDate.substring(0, 10));
						} else {
							getINJText_FGDate().resetText();
						}
						getINJCheckBox_Doctor().setSelected(MINUS_ONE_VALUE.equals(getParameter("pre_isDoctor")));
						getINJCheckBox_Special().setSelected(MINUS_ONE_VALUE.equals(getParameter("pre_isSpecial")));
						getINJCheckBox_Hspital().setSelected(MINUS_ONE_VALUE.equals(getParameter("Pre_isHospital")));
						getINJCheckBox_Other().setSelected(MINUS_ONE_VALUE.equals(getParameter("pre_isOther")));

						QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
								new String[] {"arcode",
										"copaytyp,copayamt,arlmtamt,cvredate,arcname,PRINT_MRRPT",
										"arccode ='"+sArcCode+"'"},
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									setParameterHelper("pre_COPAYTYP", mQueue, 0);
									setParameterHelper("pre_CoPayamt", mQueue, 1);
									setParameterHelper("pre_ARLMTAMT", mQueue, 2);
									setParameterHelper("pre_CVREDATE", mQueue, 3);

									memPre_ArcCode = sArcCode;
//									memPre_COPAYTYP = getParameter("pre_COPAYTYP");
//									memPre_CoPayamt = getParameter("pre_CoPayamt");
//									memPre_ARLMTAMT = getParameter("pre_ARLMTAMT");
//									memPre_CVREDATE = getParameter("pre_CVREDATE");

//									getINJCombo_ARC().setText(memPre_ArcCode);
									getINJText_ARC().setText(mQueue.getContentField()[4]);
								}
							}
						});
					}

//					memPre_POLICY = getParameter("pre_POLICY");
					memPre_voucher = getParameter("pre_voucher");
					memPre_authno = getParameter("pre_authno");
//					memPre_FURGRTAMT = getParameter("Pre_FURGRTAMT");
//					memPre_FURGRTDATE = getParameter("Pre_FURGRTDATE");
//					memPre_isDoctor = getParameter("pre_isDoctor");
//					memPre_isSpecial = getParameter("pre_isSpecial");
//					memPre_isHospital = getParameter("Pre_isHospital");
//					memPre_isOther = getParameter("pre_isOther");
					memPre_docCode = getParameter("pre_DOCCODE");

					QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] {
								"Doctor",
								"DocFName || ' ' || DocGName, DocCode",
								"DocCode = '" + memPre_docCode + "'"
							},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								getINJText_ADMDoctor().setText(mQueue.getContentField()[1]);
								getINJText_ADMDoctor().onBlur();
//								getINJText_TreDrCode().setText(mQueue.getContentField()[1]);
							}
						}
					});

					memPre_PBMID = getParameter("pre_PBMID");
					memPre_PBSNO = getParameter("pre_PBSNO");
					memPre_PBSID = getParameter("pre_PBSID");
					memPre_ISRECLG = getParameter("pre_ISRECLG");
					memPre_ARACMCODE = getParameter("pre_ARACMCODE");
					memPre_PBPKGCODE = getParameter("pre_PBPKGCODE");
//					memPre_PBMCODE = getParameter("pre_PBMCODE");
					memPre_PBESTGIVN = getParameter("pre_PBESTGIVN");
					memPre_DEDUCTIBLE = getParameter("pre_DEDUCTIBLE");
					mem_FESTID = getParameter("pre_FESTID");
					mem_FESTBE = getParameter("pre_FESTBE");
					memBPBPkgCode = getParameter("BPBPkgCode");

					getINJCombo_Source().setText(memPre_PBSID);
					getINJText_SourceNo().setText(memPre_PBSNO);
					getRightJCombo_Misc().setText(memPre_PBMID);
					getINJCheckBox_Revlog().setSelected(MINUS_ONE_VALUE.equals(memPre_ISRECLG));
					getINJCombo_LogCvrCls().setText(memPre_ARACMCODE);
					getINJCombo_Package().setText(memPre_PBPKGCODE);
					getPJCheckBox_EstGiven().setSelected(MINUS_ONE_VALUE.equals(memPre_PBESTGIVN));
					getINJText_Deduct().setText(memPre_DEDUCTIBLE);
					getPJCheckBox_BE().setSelected(MINUS_ONE_VALUE.equals(mem_FESTBE));
					if (mem_FESTID != null && !"".equals(mem_FESTID)) {
						//getRightButton_BudgetEst().setEnabled(true);
						getRightButton_BudgetEst().el().addStyleName("button-alert-green");
					} else {
						getRightButton_BudgetEst().el().removeStyleName("button-alert-green");
					}
				}
			}
		});
	}

	private void ticketUnlock() {
		unlockRecord("Ticket", "Ticket");
	}

	private void checkTicketNo(String actionType, boolean returnValue) {
		// check whether gen or input
		if ("C".equals(getSysParameter("TicketGen"))) {
			getMainFrame().setLoading(false);
			getDlgTicketNumber().showDialog(actionType, returnValue);
		} else {
			getTicketNoByDB(ZERO_VALUE, getRTJText_PatientNumber().getText(), "ticket",
					"ticket", CommonUtil.getComputerName(), getUserInfo().getUserID(),
					getRegCat(getRegistrationMode()), getINJText_TreDrCode().getText(),
					getINJText_ADMDate().getText(), ZERO_VALUE, actionType, returnValue);
		}
	}

	private void getTicketNoByDB(String stepNo, final String patNo, final String lockType,
								final String lockKey, final String computerName,
								final String usrId, final String regopcat, final String docCode,
								final String regDate,String isYes1S, final String actionType,
								final boolean returnValue) {

//		getMainFrame().setLoading(true);
		QueryUtil.executeTx(getUserInfo(), "ACT_TICKETNO",
				new String[] {stepNo, patNo, lockType, lockKey, computerName, usrId, regopcat, docCode, memBkgID, regDate, isYes1S},
				new MessageQueueCallBack() {
			public void onPostSuccess(final MessageQueue mQueue) {
				if (mQueue.success()) {
					if (Integer.parseInt(mQueue.getContentField()[0]) == -100) {
						Factory.getInstance().isConfirmYesNoDialog("PBA-[" + getTitle() + "]", mQueue.getContentField()[4], new Listener<MessageBoxEvent>() {
							public void handleEvent(MessageBoxEvent be) {
								int stepReturn = 0;
								int isYes1 = 0;
								stepReturn = Integer.parseInt(mQueue.getContentField()[1]);
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									isYes1 = 1;
									getTicketNoByDB(String.valueOf(stepReturn + 1), patNo, lockType, lockKey, computerName, usrId, regopcat, docCode, regDate, String.valueOf(isYes1), actionType, returnValue);
								}
							}
						});
					} else if (Integer.parseInt(mQueue.getContentField()[0]) == 0) {
						ticketNo = mQueue.getContentField()[2];
						actionValidationReady(actionType, returnValue);
						ticketUnlock();
					} else if (Integer.parseInt(mQueue.getContentField()[0]) < 0
							&& Integer.parseInt(mQueue.getContentField()[0]) > -10) {
						Factory.getInstance().addErrorMessage(mQueue.getContentField()[4]);
						actionValidationReady(actionType, false);
					}
				} else {
					Factory.getInstance().addErrorMessage("Fail to generate ticket no.");
					actionValidationReady(actionType, false);
				}
			}

			public void onComplete() {
				super.onComplete();
//				getMainFrame().setLoading(false);
			}
		});
	}

//	private void updateTicketNO(String ticketNo) {
//		QueryUtil.executeMasterAction(getUserInfo(), "UPDATE_TICKETNO", getActionType(), new String[] {getRTJText_PatientNumber().getText(), getCurrentRegistrationType(), ticketNo},
//				new MessageQueueCallBack() {
//			public void onPostSuccess(MessageQueue mQueue) {
//				if (!mQueue.success()) {
//					Factory.getInstance().addErrorMessage("Update ticket number fail!");
//				}
//			}
//		});
//	}

	private Map<String,String> hasUpdatePatientData() {
		Map<String,String> data = new HashMap<String,String>();
		if (!getPJText_GivenName().getText().equals(oldPatGName)) {
			data.put("GNAME",oldPatGName+"<N>"+getPJText_GivenName().getText());
		}
		if (!getPJText_FamilyName().getText().equals(oldPatFName)) {
			data.put("FNAME",oldPatFName+"<N>"+getPJText_FamilyName().getText());
		}
		if (!getPJText_ChineseName().getText().equals(oldPat_CName) &&
				(oldPat_CName != null && oldPat_CName.length() > 0)) {
			data.put("CNAME",memPat_CName+"<N>"+getPJText_ChineseName().getText());
		}
		if (!getPJText_Birthday().getText().equals(oldPatDOB)) {
			data.put("DOB",oldPatDOB+"<N>"+getPJText_Birthday().getText());
		}
		if (!getPJCombo_Sex().getText().equals(oldPatSex)) {
			data.put("SEX",oldPatSex+"<N>"+getPJCombo_Sex().getText());
		}
		if (!getPJText_IDPassportNO().getText().equals(oldPatDocID)) {
			data.put("DOCID",oldPatDocID+"<N>"+getPJText_IDPassportNO().getText());
		}
		if (!getPJCombo_DocType().getText().equals(oldPatDocType)
				&& (oldPatDocType != null && oldPatDocType.length() > 0)) {
			data.put("DOCTYPE",oldPatDocType+"<N>"+getPJCombo_DocType().getText());
		}
		
		if (!getPJText_IDPassportNO_S1().getText().equals(oldPatDocA1ID)) {
			data.put("DOCA1ID",oldPatDocA1ID+"<N>"+getPJText_IDPassportNO_S1().getText());
		}
		if (!getPJCombo_DocType_S1().getText().equals(oldPatDocA1Type)
				&& (oldPatDocA1Type != null && oldPatDocA1Type.length() > 0)) {
			data.put("DOCA1TYPE",oldPatDocA1Type+"<N>"+getPJCombo_DocType_S1().getText());
		}
		
		if (!getPJText_IDPassportNO_S2().getText().equals(oldPatDocA2ID)) {
			data.put("DOCA2ID",oldPatDocA2ID+"<N>"+getPJText_IDPassportNO_S2().getText());
		}
		if (!getPJCombo_DocType_S2().getText().equals(oldPatDocA2Type)
				&& (oldPatDocA2Type != null && oldPatDocA2Type.length() > 0)) {
			data.put("DOCA2TYPE",oldPatDocA1Type+"<N>"+getPJCombo_DocType_S1().getText());
		}

		return data;
	}

	private void getOldPatDataBfEdit() {
		oldPatGName = getPJText_GivenName().getText();
		oldPatFName = getPJText_FamilyName().getText();
		oldPat_CName = getPJText_ChineseName().getText();
		oldPatDOB = getPJText_Birthday().getText();
		oldPatDocID = getPJText_IDPassportNO().getText();
		oldPatDocType = getPJCombo_DocType().getText();
		oldPatSex = getPJCombo_Sex().getText();
		oldPatDocA1ID = getPJText_IDPassportNO_S1().getText();
		oldPatDocA1Type = getPJCombo_DocType_S1().getText();
		oldPatDocA2ID = getPJText_IDPassportNO_S2().getText();
		oldPatDocA2Type = getPJCombo_DocType_S2().getText();
	}

//	private int checkDateCompare() {
//		return DateTimeUtil.dateDiff(getPJText_Birthday().getText(), getINJText_ADMDate().getText().substring(0, 10));
//	}

	private void addMedicalRecord(
						final String isNew, final int step, final String isReg,
						final String regType, final String patNo, final String siteCode,
						final String docCode, final String mrdRmk, final String bedCode,
						final String regopCat, final String userID, int isYes1,
						int isYes2, final int isButtonAdd, final CallbackListener cl) {
// isButtonAdd equal -1(false) in java code means isAutoAddVol -1(true) in VB code
		QueryUtil.executeTx(getUserInfo(), "ACT_MEDREC_ADD",
				new String[] {
					isNew, //v_action
					String.valueOf(step), //V_STEP
					isReg, //V_ISREG
					regType, //V_REGTYPE
					patNo, //V_PATNO
					siteCode, //V_SITECODE
					docCode, //V_DOCCODE
					mrdRmk, //V_MRDRMK
					bedCode, //V_BEDCODE
					regopCat, //V_REGOPCAT
					userID, //V_USERID
					String.valueOf(isYes1), //V_ISYES1S
					String.valueOf(isYes2), //V_ISYES2S
					String.valueOf(isButtonAdd) //V_ISBUTTONADDS
				},
				new MessageQueueCallBack() {
			public void onPostSuccess(final MessageQueue mQueue) {
				if (mQueue.success()) {
					int isAutoAddedVol = Integer.parseInt(mQueue.getContentField()[4]);
					int addMedicalRecord = Integer.parseInt(mQueue.getContentField()[6]);
					final String mrhVolLab = mQueue.getContentField()[7];
					int isAdded = Integer.parseInt(mQueue.getContentField()[8]);

					if (Integer.parseInt(mQueue.getContentField()[0]) == 0) {
						if (isButtonAdd == 1) {
							if (addMedicalRecord == -1) {
								fillMedicalRecord(patNo);
								Factory.getInstance().isConfirmYesNoDialog("PBA-["+getTitle()+"]", "Print medical record label?", new Listener<MessageBoxEvent>() {
									public void handleEvent(MessageBoxEvent be) {
										if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
											printMedLabel(mrhVolLab);
										}
									}
								});
							} else {
								Factory.getInstance().addErrorMessage("A new volume has already created for today.");
							}
						} else {
							if (addMedicalRecord == 0 && "R".equals(isReg) && QueryUtil.ACTION_APPEND.equals(isNew)) {
								Factory.getInstance().addErrorMessage("A new volume has already created for today.");
							}

							if (isAutoAddedVol == -1 && "R".equals(isReg) && QueryUtil.ACTION_APPEND.equals(isNew) && isAdded == -1) {
								addNewVolume = true;
								Factory.getInstance().addErrorMessage("A new Volume has been added", new Listener<MessageBoxEvent>() {
									public void handleEvent(MessageBoxEvent be) {
										if (Dialog.OK.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
											Factory.getInstance().isConfirmYesNoDialog("PBA-["+getTitle()+"]", "Print medical record label?", new Listener<MessageBoxEvent>() {
												public void handleEvent(MessageBoxEvent be) {
													if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
														printMedLabel(mrhVolLab);
													}
												}
											});
										}
									}
								});
							}

							if (isAutoAddedVol == -1) {
								fillMedicalRecord(patNo);
							}
						}
					} else if (Integer.parseInt(mQueue.getContentField()[0])==-100||Integer.parseInt(mQueue.getContentField()[0])==-200) {
						Factory.getInstance().isConfirmYesNoDialog("PBA-["+getTitle()+"]", mQueue.getContentField()[9], new Listener<MessageBoxEvent>() {
							public void handleEvent(MessageBoxEvent be) {
								int stepReturn = 0;
								int isYes1 = 0;
								int isYes2 = 0;
								stepReturn = Integer.parseInt(mQueue.getContentField()[1]);
								String regType = getCurrentRegistrationType();
								if (Integer.parseInt(mQueue.getContentField()[0])==-100) {
									if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
										isYes1 = 1;
										isYes2 = 0;
										addMedicalRecord(isNew, stepReturn+1, isReg, regType, patNo, siteCode, docCode,
												mrdRmk, bedCode, regopCat, userID, isYes1, isYes2, isButtonAdd, cl);
									} else {
										isYes1 = 0;
										isYes2 = 0;
										addMedicalRecord(isNew, stepReturn+1, isReg, regType, patNo, siteCode, docCode,
												mrdRmk, bedCode, regopCat, userID, isYes1, isYes2, isButtonAdd, cl);
									}
								} else if (Integer.parseInt(mQueue.getContentField()[0])==-200) {
									if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
										isYes1 = Integer.parseInt(mQueue.getContentField()[5]);
										isYes2 = 1;
										addMedicalRecord(isNew, stepReturn+1, isReg, regType, patNo, siteCode, docCode,
												mrdRmk, bedCode, regopCat, userID, isYes1, isYes2, isButtonAdd, cl);
									} else {
										isYes1 = Integer.parseInt(mQueue.getContentField()[5]);
										isYes2 = 0;
										addMedicalRecord(isNew, stepReturn+1, isReg, regType, patNo, siteCode, docCode,
												mrdRmk, bedCode, regopCat, userID, isYes1, isYes2, isButtonAdd, cl);
									}
								}
							}
						});
					} else if (Integer.parseInt(mQueue.getContentField()[0]) < 0
							&& Integer.parseInt(mQueue.getContentField()[0])>-10) {
						Factory.getInstance().addErrorMessage(mQueue.getContentField()[9]);
					}
				} else {
					Factory.getInstance().addErrorMessage(mQueue.getContentField()[9]);
				}

				if (cl != null) {
					cl.handleRetBool(true, null, null);
				}
			}
		});
	}

	// paper priority
	private void fillMedicalRecord(String patNo) {
		if (patNo != null && patNo.length() > 0) {
			QueryUtil.executeMasterFetch(getUserInfo(), "MEDREC_FILL_PAPERPRI",
					new String[] { patNo },
					new MessageQueueCallBack() {
				public void onPostSuccess(final MessageQueue mQueue) {
					if (mQueue.success()) {
						getINJText_Med().setText(mQueue.getContentField()[1]);
						getINJText_Rec().setText(mQueue.getContentField()[2]);
					}
				}
			});
		} else {
			getINJText_Med().resetText();
			getINJText_Rec().resetText();
		}
	}

/*
	private void fillMedicalRecord(String patNo) {
		if (patNo != null && patNo.length() > 0) {
			QueryUtil.executeMasterFetch(getUserInfo(), "MEDREC_FILL",
					new String[] { patNo },
					new MessageQueueCallBack() {
				public void onPostSuccess(final MessageQueue mQueue) {
					if (mQueue.success()) {
						fillMedicalRecord(mQueue.getContentField()[1], mQueue.getContentField()[2]);
					}
				}
			});
		} else {
			fillMedicalRecord(null, null);
		}
	}
*/
	private void fillMedicalRecord(String medloc, String medtype) {
		if (medloc != null && medtype != null) {
			getINJText_Med().setText(medloc);
			getINJText_Rec().setText(medtype);
		} else {
			getINJText_Med().resetText();
			getINJText_Rec().resetText();
		}
	}

	private void printMedLabel(final String vol) {
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] { "medrechdr", "max(mrhvollab)", "patno='" + memPatNo + "' AND mrhsts = 'N'" },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if ((mQueue.getContentField()[0]).length() == 0 || mQueue.getContentField()[0] == null) {
					Factory.getInstance().addErrorMessage("Print Medical Label Fail: Patient doesn't have any Medical Volume Label!");
				} else {
					Map<String,String> map = new HashMap<String,String>();
					map.put("isasterisk",getSysParameter("Chk*"));
					map.put("isChkDigit",getSysParameter("ChkDigit"));

					String tempChkDigit = "#";
					if ("YES".equals(getSysParameter("ChkDigit"))) {
						tempChkDigit = PrintingUtil.generateCheckDigit("-C/"+memPatNo + "/" + vol).toString()+"#";
					}
					map.put("recordID", memPatNo + "/" + vol+tempChkDigit);
					//map.put("ChkDigit", tempChkDigit);
					PrintingUtil.print(getSysParameter("PRTRLBL"), "MedChartLbl", map, null);
				}
			}
		});
	}

	private void updateBabySlipToEbirth() {
		if (getPJCheckBox_NewBorn().isSelected() &&
				getRTJRadio_InPatient().isSelected() &&
				!getPJText_Birthday().isEmpty() &&
				!getINJText_RegDate().isEmpty() &&
				(DateTimeUtil.dateDiff(
						getPJText_Birthday().getText().trim(),
						getINJText_RegDate().getText().trim().substring(0, 10)) == 0)) {
			QueryUtil.executeMasterAction(getUserInfo(), "UPDATE", QueryUtil.ACTION_MODIFY,
					new String[] {
						"EBIRTHDTL",
						"BB_SLPNO = '"+getINJText_SLPNO().getText()+"'",
						"BB_PATNO = '"+getRTJText_PatientNumber().getText()+"'"
					});
		}
	}

	private void checkEbirthDtl() {
		if (!MINUS_ONE_VALUE.equals(isNewBorn) && getINJCheckBox_NewBorn().isSelected()) {
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] {
									"EBIRTHDTL",
									"COUNT(1)",
									"BB_PATNO='" + getRTJText_PatientNumber().getText() + "'"
					},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						if (mQueue.getContentField()[0] != null
								&& mQueue.getContentField()[0].length() > 0
								&& Integer.parseInt(mQueue.getContentField()[0]) > 0) {
							if (getRTJRadio_Mainland().isSelected()) {
								QueryUtil.executeMasterAction(getUserInfo(), "EBIRTHDTL_REG", QueryUtil.ACTION_MODIFY,
										new String[] {
												"EBIRTHDTL",
												getRTJText_PatientNumber().getText(),
												"1"
										},
										new MessageQueueCallBack() {
											@Override
											public void onPostSuccess(MessageQueue mQueue) {
												updateBabySlipToEbirth();
											}
										});
							} else {
								updateBabySlipToEbirth();
							}
							checkDHBbirthDtl();
						} else {
							MessageBox mb = Factory.getInstance().isConfirmYesNoDialog("PBA-[" + getTitle() + "]", "Create record for HKSAR?", new Listener<MessageBoxEvent>() {
								public void handleEvent(MessageBoxEvent be) {
									if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
										QueryUtil.executeMasterAction(getUserInfo(), "EBIRTHDTL_REG", QueryUtil.ACTION_APPEND,
												new String[] {
														"EBIRTHDTL",
														getRTJText_PatientNumber().getText(),
														getRTJRadio_NonMainland().isSelected() ? ZERO_VALUE : getRTJRadio_Mainland().isSelected() ? ONE_VALUE : EMPTY_VALUE
												},
												new MessageQueueCallBack() {
													@Override
													public void onPostSuccess(MessageQueue mQueue) {
														updateBabySlipToEbirth();
													}
												});
										checkDHBbirthDtl();
									} else {
										checkDHBbirthDtl();
									}
								}
							});
							mb.show();
							mb.getDialog().focus();
							mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
						}
					} else {
						checkDHBbirthDtl();
					}
				}
			});
		} else {
			updateBabySlipToEbirth();
			checkDrInstruction(getINJText_ADMDoctor().getText(), getINJText_TreDrCode().getText());
		}
	}

	private void checkDHBbirthDtl() {
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] {"DHBIRTHDTL", "count(1)", "BBPATNO='"+getRTJText_PatientNumber().getText()+"'"},
				new MessageQueueCallBack() {
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					if (mQueue.getContentField()[0] != null
							&& mQueue.getContentField()[0].length() > 0
							&& Integer.parseInt(mQueue.getContentField()[0]) == 0) {
						if (getINJCheckBox_NewBorn().isSelected()) {
							MessageBox mb = Factory.getInstance().isConfirmYesNoDialog("PBA-["+getTitle()+"]", "Create record for Health Department?",
									new Listener<MessageBoxEvent>() {
								@Override
								public void handleEvent(MessageBoxEvent be) {
									if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
										QueryUtil.executeMasterAction(
												getUserInfo(),
												"EBIRTHDTL_REG",
												QueryUtil.ACTION_APPEND,
												new String[] {
													"DHBIRTHDTL",
													getRTJText_PatientNumber().getText(),
													getRTJRadio_NonMainland().isSelected() ? ZERO_VALUE : getRTJRadio_Mainland().isSelected() ? ONE_VALUE : EMPTY_VALUE
										});
										checkDrInstruction(getINJText_ADMDoctor().getText(), getINJText_TreDrCode().getText());
									} else {
										checkDrInstruction(getINJText_ADMDoctor().getText(), getINJText_TreDrCode().getText());
									}
								}
							});

							mb.show();
							mb.getDialog().focus();
							mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
						}
					} else {
						checkDrInstruction(getINJText_ADMDoctor().getText(), getINJText_TreDrCode().getText());
					}
				} else {
					checkDrInstruction(getINJText_ADMDoctor().getText(), getINJText_TreDrCode().getText());
				}
			}
		});
	}

	/*>>> create for inpatient by pass show registration ======== <<<<*/
	protected void overridePatientCancelYesAction() {
		super.cancelYesAction();
	}

	@Override
	protected void emptyAllRightPanelFields() {
		if (isRegFlag()) {
			// only clear registration panel
			PanelUtil.resetAllFields(getRegPanel());
		} else if (!isPatientFlag() || isNewPatientEmptyField) {
			// clear all panel
			PanelUtil.resetAllFields(getRightPanel());
		}
	}

	/*>>> override getSearchHeight for adjust the height of search panel ======== <<<<*/
	@Override
	protected int getSearchHeight() {
		return 180;
	}

	/*>>> override getListWidth for adjust the width of the table list ======== <<<<*/
	@Override
	protected int getListWidth() {
		return 790;
	}

	/***************************************************************************
	 * Inner Function Method
	 **************************************************************************/

	private String getRegistrationType() {
		return this.registrationType;
	}

//	private void setRegistrationType(String registrationType) {
//		this.registrationType = registrationType;
//		if (registrationType == null) {
//			return;
//		} else if (registrationType.equals(REG_TYPE_INPATIENT)
//				|| registrationType.equals(REG_TYPE_OUTPATIENT)
//				|| registrationType.equals(REG_TYPE_DAYCASE)) {
//			setCurrentRegistrationType(registrationType);
//		}
//	}

	private String getCurrentRegistrationType() {
		if (getRTJRadio_OutPatient().isSelected()) {
			return REG_TYPE_OUTPATIENT;
		} else if (getRTJRadio_DayCasePatient().isSelected()) {
			return REG_TYPE_DAYCASE;
		} else if (getRTJRadio_InPatient().isSelected()) {
			return REG_TYPE_INPATIENT;
		} else {
			return REG_TYPE_CANCEL;
		}
	}

	private void setCurrentRegistrationType(String registrationType) {
		getRTJRadio_DayCasePatient().setSelected(false);
		getRTJRadio_InPatient().setSelected(false);
		getRTJRadio_OutPatient().setSelected(false);

		if (REG_TYPE_DAYCASE.equals(registrationType)) {
			getRTJRadio_DayCasePatient().setSelected(true);
			getRTJText_OutPatientType().resetText();
		} else if (REG_TYPE_INPATIENT.equals(registrationType)) {
			getRTJRadio_InPatient().setSelected(true);
			getRTJText_OutPatientType().resetText();
		} else if (REG_TYPE_OUTPATIENT.equals(registrationType)) {
			getRTJRadio_OutPatient().setSelected(true);
			//getRTJText_OutPatientType().setText(getRegCatName(getRegCat(getRegistrationMode())));
		}
	}

	private String getRegistrationMode() {
		return memRegMode;
	}

	private void setRegistrationMode(String registrationMode) {
		memRegMode = registrationMode;
	}

	public boolean isPatientFlag() {
		// indicate the registration flag for operation
		return getRBTPanel().getSelectedIndex() == 0;
	}

	public boolean isRegFlag() {
		// indicate the registration flag for operation
		return getRBTPanel().getSelectedIndex() == 1;
	}

	public boolean isAdditionInfoFlag() {
		// indicate the registration flag for operation
		return getRBTPanel().getSelectedIndex() == 2;
	}

	public boolean isEhrFlag() {
		// indicate the patient eHr flag for operation
		return getRBTPanel().getSelectedIndex() == 3;
	}

	public boolean isConsentFlag() {
		// indicate the patient consent flag for operation
		return getRBTPanel().getSelectedIndex() == 4;
	}

	private void enablePatRegEditFiled() {
		boolean isInPatient = getRTJRadio_InPatient().isSelected();

		// enable/disable field and button
		getRTJRadio_OutPatient().setEnabled(false);
		getRTJRadio_DayCasePatient().setEnabled(false);
		getRTJRadio_InPatient().setEnabled(false);
		
		getRTCombo_docRoom().setEditable(!isInPatient &&
				(REG_WALKIN.equals(getRegistrationMode())
				|| REG_PRIORITY.equals(getRegistrationMode())
				|| "TRIAGE".equals(getINJText_TreDrCode().getText().trim())));
		
		getRTCombo_nature().setEditable(false);

		getINJText_BedNo().setEditable(isInPatient);
		getINJCombo_AcmCode().setEditable(isInPatient);
		getINJCheckBox_NewBorn().setEnabled(isInPatient);
		getRTJRadio_Mainland().setEnabled(isInPatient);
		getRTJRadio_NonMainland().setEnabled(isInPatient);
		getINJText_ADMDoctor().setEditable(isInPatient);
		getINJText_ADMDate().setEditable(isInPatient);
		getINJCombo_ADMFrom().setEditable(isInPatient);
		getINJCombo_ADMType().setEditable(isInPatient);
		getINJText_Remark().setEditable(isInPatient);
		getRightJCombo_Misc().setEditable(isInPatient);
		getINJCheckBox_Revlog().setEditable(true);
		getINJCombo_LogCvrCls().setEditable(isInPatient);
		getINJCombo_Package().setEditable(isInPatient);
		getPJCheckBox_EstGiven().setEditable(isInPatient);
		getRightButton_BudgetEst().setEnabled((isInPatient || REG_DAYCASE.equals(getCurrentRegistrationType()))
				&& (!getINJText_SLPNO().isEmpty()));
		getINJText_RegDate().setEditable(!isInPatient);
		getINJCombo_Category().setEditable(QueryUtil.ACTION_APPEND.equals(getActionTypeRegistration()));
		getINJText_Ref().setEditable(true);
		getINJCombo_Source().setEditable(true);
		getINJText_SourceNo().setEditable(true);
		getINJCombo_ARC().setEditable(QueryUtil.ACTION_APPEND.equals(getActionTypeRegistration()));
		getINJText_PLNO().setEditable(true);
		getINJText_VHNO().setEditable(true);

		if (memBkgID != null && memBkgID.length() > 0) {
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] { "GOVREG R, GOVJOB J", "R.BKGID, SUBSTR(R.GOVJOBCODE,-1), J.ARCCODE", "R.GOVJOBCODE = J.GOVJOBCODE AND R.BKGID='" + memBkgID + "'" },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						setARValue(mQueue.getContentField()[2], getINJText_ADMDate().getText());
						if (mQueue.getContentField()[1].length() > 0 && mQueue.getContentField()[1] != null) {
							if ("A".equals(mQueue.getContentField()[1])) {
								getINJCombo_Category().setText("GA");
								getINJText_Category().setText("Gov't Cat A");
							} else if ("B".equals(mQueue.getContentField()[1])) {
								getINJCombo_Category().setText("GB");
								getINJText_Category().setText("Gov't Cat B");
							}
						}
					}
				}
			});
		}

		getINJText_LengthOfStay().setEditable(isInPatient);
		getINJText_TreDrCode().setEditable(true);
		getRegDtorTable().setEnabled(true);

		if (isInPatient) {
			getINJText_BedNo().setEnabled(isInPatient);
			getINJCombo_AcmCode().setEnabled(isInPatient);
			getINJCheckBox_NewBorn().setEnabled(isInPatient);
			getRTJRadio_Mainland().setEnabled(isInPatient);
			getRTJRadio_NonMainland().setEnabled(isInPatient);
			getINJText_ADMDoctor().setEnabled(isInPatient);
			getINJText_ADMDate().setEnabled(isInPatient);
			getINJCombo_ADMFrom().setEnabled(isInPatient);
			getINJCombo_ADMType().setEnabled(isInPatient);
			getINJText_Remark().setEnabled(isInPatient);

//			getINJText_RegDate().setEditable(!isInPatient);
//			getINJCombo_Category().setEnabled(true);
			getINJText_Ref().setEnabled(true);
//			getINJCombo_ARC().setEnabled(true);
			getINJText_PLNO().setEnabled(true);
			getINJText_VHNO().setEnabled(true);

			getINJText_LengthOfStay().setEnabled(isInPatient);
			getINJText_TreDrCode().setEnabled(true);
			getRegDtorTable().setEnabled(true);
		}

		setAllowEntryAR();
	}

	private void enablePatButton(boolean enable) {
		getPJButton_UpdateDeathDate().setEnabled(enable && !isDisableFunction("btnUpdateDeath", "regPatReg"));
		getAButton_Alert().setEnabled(enable && !isDisableFunction("btnAlert", "regPatReg"));
		getAButton_PrintBasicinfoSheet().setEnabled(enable && !isDisableFunction("btnData", "regPatReg"));
		getAButton_PrintLabel().setEnabled(enable);
		getAButton_PrintAddress().setEnabled(enable);
		getINButton_MasBillingHistory().setEnabled(enable);
		getINButton_MedRec().setEnabled(enable);
		getINButton_MedRecDetail().setEnabled(enable);
		getINButton_SlipDetail().setEnabled(enable && !getINJText_SLPNO().isEmpty());
		getCSButton_BillingHistory().setEnabled(enable);
	}

	private void enablePatRegButton() {
		boolean isInPatient = getRTJRadio_InPatient().isSelected();
		boolean isSlipNoFilled = !getINJText_SLPNO().isEmpty();
		boolean isPrintLabel = !getINJText_TreDrCode().isEmpty();

		getINButton_PrintLabel().setEnabled(isSlipNoFilled && isPrintLabel);
		getINButton_PrintWristbandLabel().setEnabled(
				isSlipNoFilled && isPrintLabel && !memWBLblType.equals("NA") &&
				(getCurrentRegistrationType().equals(REG_TYPE_INPATIENT) ||
				getCurrentRegistrationType().equals(REG_TYPE_DAYCASE)));
		getINButton_PrintChartLabel().setEnabled(isPrintLabel && isSlipNoFilled && !"AMC".equals(Factory.getInstance().getSysParameter("curtSite")));
						//In vb, it seems the button does not have any permission
						//&& !isDisableFunction("btnPrintChartLable", "regPatReg"));
		getINButton_PrintBilling().setEnabled(isPrintLabel && isSlipNoFilled && !isDisableFunction("mnuTransDetail"));
		getINButton_AdmFrm().setEnabled(!isModify() && !isDelete() && isSlipNoFilled &&
											isInPatient);
		getINButton_PrintOTHandOver().setEnabled(isInPatient && isSlipNoFilled &&
													tmpOTAid != null && !tmpOTAid.isEmpty() &&
													!isModify() && !isDelete());
		getINButton_UKCert().setEnabled(!isModify() && !isDelete() && isSlipNoFilled &&
				!isInPatient);
		getINButton_PrintEShare().setEnabled(memRegID != null && isInPatient);
		enablePatButton(!getRTJText_PatientNumber().isEmpty() &&
						!isDisableFunction("TABPAGE", "regPatReg"));
		getINButton_PrintBillingHistory().setEnabled(true);
		getINButton_PatientCardButton().setEnabled(true);
		getINButton_IPGeneralLabelButton().setEnabled(isSlipNoFilled && isPrintLabel);
		getINButton_RegLabelBtn().setEnabled(isSlipNoFilled && isPrintLabel && !isInPatient);
		getINButton_IdtLabelBtn().setEnabled(isSlipNoFilled && isPrintLabel && !isInPatient);
		getINButton_DlgPrtCallChartButton().setEnabled(isPrintLabel && isSlipNoFilled);
		if ((isInPatient || REG_DAYCASE.equals(getCurrentRegistrationType()))
				&& (!getINJText_SLPNO().isEmpty())) {
			getRightButton_BudgetEst().setEnabled(true);
			//getRightButton_BudgetEst().el().addStyleName("button-alert-green");
		} else {
			getRightButton_BudgetEst().removeStyleName("button-alert-green");
		}
		getINButton_SlipDetail().setEnabled(!isDisableFunction("mnuTransDetail", ""));
	}

	private void checkNCTRDate(final String arcode, String dNCTRSDateStr, String dNCTREDateStr) {
		String dNCTRSDate = dNCTRSDateStr;
		if (dNCTRSDate != null && dNCTRSDate.length() > 10) {
			dNCTRSDate = dNCTRSDate.substring(0, 10);
		}
		String dNCTREDate = dNCTREDateStr;
		if (dNCTREDate != null && dNCTREDate.length() > 10) {
			dNCTREDate = dNCTREDate.substring(0, 10);
		}

		String sNoContractMsg = null;
//		Boolean isCboArcCode_Prompted = false;
		int result1 = DateTimeUtil.compareTo(getINJText_ADMDate().getText(), dNCTRSDate);
		int result2 = DateTimeUtil.compareTo(getINJText_ADMDate().getText(), dNCTREDate);

		if (dNCTRSDate != null && dNCTRSDate.length() > 0) {
			if (dNCTREDate != null && dNCTREDate.length() > 0) {
				if (result1 >= 0 && result2 <= 0) {
					sNoContractMsg = "This AR has no contract during "+dNCTRSDate+" and "+dNCTREDate;
				}
			} else {
				if (result1 >= 0) {
					sNoContractMsg = "This AR has no contract since "+dNCTRSDate;
				}
			}

			if (sNoContractMsg != null && sNoContractMsg.length() > 0) {
//				isCboArcCode_Prompted = true;
				Factory.getInstance().addErrorMessage(sNoContractMsg);
				return;
			}
		}

		QueryUtil.executeMasterBrowse(Factory.getInstance().getUserInfo(),
				"ARCARDTYPE", new String[] { arcode, null, MINUS_ONE_VALUE },
				new MessageQueueCallBack() {
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success() && mQueue.getContentField().length > 0) {
					getDlgARCardTypeSel().showDialog(arcode);
				} else {
					getINJText_ARCardType().resetText();
					memActID = null;
				}
			}
		});
	}

	private void setARValue(final String arcode, final String admissionDate) {
		QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.AR_COMPANY_TXCODE,
				new String[] { arcode },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success() && mQueue.getContentLineCount() > 0) {
					// get first return value and assign to district
					String[] outParam = mQueue.getContentField();
					getINJCombo_ARC().setText(outParam[0]);
					getINJCombo_ARC().getSearchArCode().setText(outParam[0]);
					getINJText_ARC().setText(outParam[1]);

					if (memPre_ArcCode == null || memPre_ArcCode.length() == 0 || !getINJCombo_ARC().getText().equals(memPre_ArcCode)) {
						if (QueryUtil.ACTION_APPEND.equals(getActionTypeRegistration())
								|| QueryUtil.ACTION_MODIFY.equals(getActionTypeRegistration())) {
//							if (getCurrentRegistrationType().equals(REG_TYPE_INPATIENT)) {
								getINJText_LAmt().setText(outParam[2]);
								String endDate = outParam[3];
								if (endDate != null && endDate.length() >= 10) {
									endDate = endDate.substring(0, 10);
								}
								getINJText_endDate().setText(endDate);
								getINJCombo_CPAmt().setText(outParam[4]);
								getINJText_CPAmt().setText(outParam[5]);
//								getINJText_FGAmt().setText(outParam[6]);
//								getINJText_FGDate().setText(outParam[7]);
								getINJCheckBox_Doctor().setSelected(MINUS_ONE_VALUE.equals(outParam[8]));
								getINJCheckBox_Hspital().setSelected(MINUS_ONE_VALUE.equals(outParam[9]));
								getINJCheckBox_Special().setSelected(MINUS_ONE_VALUE.equals(outParam[10]));
								getINJCheckBox_Other().setSelected(MINUS_ONE_VALUE.equals(outParam[11]));
								getINJCheckBox_PrtMedRecordRpt().setSelected(MINUS_ONE_VALUE.equals(outParam[14]));
//							} else {
//								getINJCheckBox_PrtMedRecordRpt().setSelected(MINUS_ONE_VALUE.equals(outParam[14]));
//							}
						}
					} else {
						getINJText_VHNO().setText(memPre_voucher);
						getINJText_PreAuthNo().setText(memPre_authno);
					}

					if (admissionDate != null && admissionDate.length() > 0) {
						checkNCTRDate(outParam[0], outParam[12], outParam[13]);
					}

					setAllowEntryAR();
				} else {
					Factory.getInstance().addErrorMessage("AR Code does not exist.", getINJCombo_ARC());
					getINJText_ARC().resetText();
					getINJText_ARCardType().resetText();
					getINJCombo_ARC().resetText();
					getINJCombo_ARC().getSearchArCode().resetText();
					setAllowEntryAR();
				}
			}
		});
	}

	private void setAllowEntryAR() {
		boolean enabled = isModify() || !EMPTY_VALUE.equals(getINJCombo_ARC().getText());
		if (Factory.getInstance().getSysParameter("ArBlockEvt").length() > 0) {
			if (isAppend() || isModify()) {
				enabled = true;
			}
		}

		getINJText_LAmt().setEditable(enabled);
		getINJText_endDate().setEditable(enabled);
		getINJCombo_CPAmt().setEditable(enabled);
		getINJText_CPAmt().setEditable(enabled);
		getINJText_FGAmt().setEditable(enabled);
		getINJText_FGDate().setEditable(enabled);
		getINJCheckBox_Doctor().setEnabled(enabled);
		getINJCheckBox_Special().setEnabled(enabled);
		getINJCheckBox_Hspital().setEnabled(enabled);
		getINJCheckBox_Other().setEnabled(enabled);
		getINJCheckBox_PrtMedRecordRpt().setEnabled(enabled);
	}

	private void resetAllowEntryAR() {
		getINJText_ARC().resetText();
		getINJCombo_ARC().getSearchArCode().resetText();
		getINJText_LAmt().setText(ZERO_VALUE);
		getINJText_endDate().resetText();
		getINJCombo_CPAmt().resetText();
		getINJText_CPAmt().setText(ZERO_VALUE);
		getINJText_FGAmt().setText(ZERO_VALUE);
		getINJText_Deduct().setText(ZERO_VALUE);
		getINJText_FGDate().resetText();
		getINJCheckBox_Doctor().setSelected(false);
		getINJCheckBox_Hspital().setSelected(false);
		getINJCheckBox_Special().setSelected(false);
		getINJCheckBox_Other().setSelected(false);
		getINJText_ARCardType().resetText();
		getINJCheckBox_PrtMedRecordRpt().setSelected(false);
	}

	private void checkDrInstruction(final String admDr, final String trtDr) {
		if (admDr != null && admDr.length() > 0) {
			QueryUtil.executeMasterBrowse(getUserInfo(), "DOCTOR_INSTRUCTION",
					new String[] { admDr },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					String doctorCode1 = null;
					String doctorName1 = null;
					String instruction1 = null;
					String payment1 = null;

					if (mQueue.success()) {
						doctorCode1 = admDr.toUpperCase();
						doctorName1 = mQueue.getContentField()[0].toUpperCase() + "," + mQueue.getContentField()[1].toUpperCase();
						instruction1 = mQueue.getContentField()[3];
						payment1 = mQueue.getContentField()[5];
					}
					getTrtDrInstruction(doctorCode1, doctorName1, instruction1, payment1, trtDr);
				}
			});
		} else {
			if (trtDr != null && trtDr.length() > 0) {
				getTrtDrInstruction(null, null, null, null, trtDr);
			}
		}
		defaultFocus();
	}

	private void getTrtDrInstruction(final String doctorCode1, final String doctorName1, final String instruction1, final String payment1, final String trtDr) {
		final String regType = getCurrentRegistrationType();
		QueryUtil.executeMasterBrowse(getUserInfo(), "DOCTOR_INSTRUCTION",
				new String[] { trtDr },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					String doctorCode2 = trtDr.toUpperCase();
					String doctorName2 = mQueue.getContentField()[0].toUpperCase() + "," + mQueue.getContentField()[1].toUpperCase();
					String instruction2 = null;
					String dialogTitle = null;
					if (REG_TYPE_DAYCASE.equals(regType)) {
						instruction2 = mQueue.getContentField()[2];
						dialogTitle = "DAY-CASE INSTRUCTIONS";
					} else if (REG_TYPE_INPATIENT.equals(regType)) {
						instruction2 = mQueue.getContentField()[3];
						dialogTitle = "IN-PATIENT INSTRUCTIONS";
					} else if (REG_TYPE_OUTPATIENT.equals(regType)) {
						instruction2 = mQueue.getContentField()[4];
						dialogTitle = "OUT-PATIENT INSTRUCTIONS";
					}
					String payment2 = mQueue.getContentField()[5];

					if (
							(instruction1 != null && instruction1.length() > 0)
							|| (payment1 != null && payment1.length() > 0)
							|| (instruction2 != null && instruction2.length() > 0)
							|| (payment2 != null && payment2.length() > 0)) {

						getDlgDoctorInstruction().showDialog(dialogTitle,
								doctorCode1, doctorName1, instruction1, payment1,
								doctorCode2, doctorName2, instruction2, payment2);
					} else {
						addMedicalRecordAfterInstruction();
					}
				}
			}
		});
	}

	private void addMedicalRecordAfterInstruction() {
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] { "MEDRECDTL D, MEDRECHDR M", "MAX(D.MRDID)", "M.MRHID = D.MRHID AND M.PATNO ='" + getRTJText_PatientNumber().getText() + "'" },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					final String maxMrdid = mQueue.getContentField()[0];

					addMedicalRecord(isAppend()? QueryUtil.ACTION_APPEND : QueryUtil.ACTION_MODIFY,
							0, "R", getCurrentRegistrationType(),
							getRTJText_PatientNumber().getText(),
							getUserInfo().getSiteCode(),
							getINJText_TreDrCode().getText(), null,
							getINJText_BedNo().getText().toUpperCase(),
							getRegCat(getRegistrationMode()),
							getUserInfo().getUserID(), 0, 0, -1,
							new CallbackListener() {
						public void handleRetBool(boolean ret, String result, MessageQueue mQueue) {
							ticketUnlock();
							if (HKAH_VALUE.equals(getUserInfo().getSiteCode()) &&
									(!addNewPatient && (REG_INPATIENT.equals(getCurrentRegistrationType())||
									REG_DAYCASE.equals(getCurrentRegistrationType())) && !addNewVolume
									&& (!"".equals(maxMrdid)&& maxMrdid != null ))) {
								showPopUpCallChart(maxMrdid);
							}
							if (REG_INPATIENT.equals(getCurrentRegistrationType()) && isAppend()) {
								unlockRecord("Bed", getINJText_BedNo().getText(), new String[] { "checkAltAccess" });
							}

							PanelUtil.setAllFieldsEditable(getRegPanel(), false);
							resetAllActionType();

							if (getRBTPanel().getSelectedIndex() == 0) {
								showPatient(getRTJText_PatientNumber().getText());
							} else if (getRBTPanel().getSelectedIndex() == 1) {
//								oldRegMode = getRegistrationMode();
								setRegistrationMode(REG_NOTHING);
								showRegistration(true);
							}
							ticketNo = null; // reset value

							defaultFocus();
						}
					});
				}
			}
		});
	}

	private void showPopUpCallChart(final String maxMrdid) {
		MessageBoxBase.confirm(MSG_PBA_SYSTEM, "Do you want to call chart? ",
				new Listener<MessageBoxEvent>() {
					@Override
					public void handleEvent(MessageBoxEvent be) {
						if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
							QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
									new String[] { "MEDRECDTL D, MEDRECHDR M", "MAX(D.MRDID)", "M.MRHID = D.MRHID AND M.PATNO ='" + getRTJText_PatientNumber().getText() + "'" },
									new MessageQueueCallBack() {
								@Override
								public void onPostSuccess(MessageQueue mQueue) {
									if (mQueue.success()) {
										String newMaxMrdid = mQueue.getContentField()[0];
										if (newMaxMrdid != null && maxMrdid != null) {
											try{
												if (Integer.parseInt(newMaxMrdid)>Integer.parseInt(maxMrdid)) {
													QueryUtil.executeMasterAction(getUserInfo(), "UPDATEMEDRECSTATUS", "ADD", new String[] {newMaxMrdid},
															new MessageQueueCallBack() {
														public void onPostSuccess(MessageQueue mQueue) {
															if (mQueue.success()) {
																System.err.println("1[getReturnMsg]:"+mQueue.getReturnMsg());
															} else {
																System.err.println("2[getReturnMsg]:"+mQueue.getReturnMsg());
															}
														}
													});
												}
											} catch(Exception e) {
												System.err.println(e);
											}
										}
									}
								}
							});

							printLab();
						}
					}
				});
	}

	private String getRegDtorTableData() {
		StringBuffer data = new StringBuffer();
		String temp = "";
		for (int i = 0; i < getRegDtorTable().getRowCount(); i++) {
			temp = getRegDtorTable().getValueAt(i, 0);
			if (temp != null && !temp.equals(SPACE_VALUE)) {
				if (i > 0) {
					data.append(",");
				}
				data.append(temp);
			}
		}
		return data.toString();
	}

	private void showPatient() {
		if (!getRTJText_PatientNumber().isEmpty()) {
			showPatient(getRTJText_PatientNumber().getText());
		} else if (getRTJText_PatientNumber().isEditable()) {
			defaultFocus();
		}
	}

	private void showPatient(String newPatNo) {
		showPatient(newPatNo, null);
	}

	private void showPatient(final String newPatNo, final String regID) {
		if (newPatNo == null || newPatNo.trim().length() == 0) {
			return;
		}
		// focus
		getRTJText_PatientNumber().setText(newPatNo);
		getRTJText_PatientNumber().requestFocus();

		// exit if merge patient
		if (getRTJText_PatientNumber().isMergePatientNo()) {
			return;
		}

		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.PATIENT_TXCODE,
				new String[] {
					newPatNo
				}, new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				showPatient(mQueue, regID);
			}
		});
	}

	private void showPatient(MessageQueue mQueue) {
		showPatient(mQueue, null);
	}

	private void showPatient(MessageQueue mQueue, String regID) {
		if (mQueue.success()) {
			// get first return value and assign to district
			final String newPatNo = mQueue.getContentField()[PATIENT_NUMBER];
			if (newPatNo == null || newPatNo.trim().length() == 0) {
				return;
			}

			// focus
			getRTJText_PatientNumber().setText(newPatNo);
			getRTJText_PatientNumber().requestFocus();

			// exit if merge patient
			if (getRTJText_PatientNumber().isMergePatientNo()) {
				return;
			}

			memOldPatNo = memPatNo;
			memPatNo = newPatNo;

			if (!newPatNo.equals(memNewPatientNo)) {
				addNewPatient = false;
				memNewPatientNo = EMPTY_VALUE;
			}

			// get first return value and assign to district
			if (getRegistrationType() == null) {
				PanelUtil.resetAllFields(getRightPanel());
				getRTJText_PatientNumber().setOldPatientNo(memPatNo);
			}
			getRegDtorTable().removeAllRow();
//			getImage_PatImage().setUrl(SERVER_PATH_NO_IMAGE);
			getBrowseOutputValues(mQueue.getContentField());
			showRegistration(false, regID);
			if (hasPatImage) {
				getImage_PatImage().setUrl(getServerPath() + memPatNo);
			} else {
				getImage_PatImage().setUrl(getDefaultNoImage());
			}
		} else {
			getRTJText_PatientNumber().showSearchPanel();
		}
	}

	private void showEhr(String patNo) {
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.EHR_PMI_TXCODE,
				new String[] { patNo },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				String activeKey = null;
				boolean showEnrolButton = false;
				if (mQueue.success()) {
					if (mQueue.getContentField()[0] == null) {

					}
					getEJText_FName().setText(mQueue.getContentField()[2]);
					getEJText_GName().setText(mQueue.getContentField()[3]);
					getEJText_Dob().setText(mQueue.getContentField()[4]);
					getEJCombo_ehrExactDobInd().setText(mQueue.getContentField()[5]);
					getEJCombo_Sex().setText(mQueue.getContentField()[6]);
					getEJText_HKID().setText(YES_VALUE.equals(mQueue.getContentField()[12]) ? SPACE_VALUE + mQueue.getContentField()[7] : mQueue.getContentField()[7]);
					getEJText_docNo().setText(mQueue.getContentField()[8]);
					getEJCombo_docType().setText(mQueue.getContentField()[9]);
					getEJText_Death().setText(mQueue.getContentField()[11]);
					String isActive = mQueue.getContentField()[10];
					getEJText_NBRegID().setText(mQueue.getContentField()[13]);

					String cEhrNo = mQueue.getContentField()[1];
					if (ConstantsVariable.MINUS_ONE_VALUE.equals(isActive)) {
						getEJText_cEhrNo().setText(cEhrNo);
						activeKey = "l_active";
						showEnrolButton = false;
					} else {
						activeKey = "l_inactive";
						showEnrolButton = true;
					}
				} else {
					activeKey = "l_default";
					showEnrolButton = true;
				}
				getEJLabel_cEhrActive().setText((String) getEJLabel_cEhrActive().getData(activeKey));
				getEhrEnrolButton().setVisible(showEnrolButton);
			}
		});

		getEhrEnrollHistTable().setListTableContent(ConstantsTx.EHR_PMIHIST_TXCODE,
				new String[]{"PMIHIST", patNo});
	}

	private void showConsent(String patNo) {
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.PATIENT_CONSENT_TXCODE,
				new String[] { patNo },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getCSJText_DateStart1().setText(mQueue.getContentField()[1]);
					getCSJText_DateTo1().setText(mQueue.getContentField()[2]);
					getCSJText_ArCode1().setText(mQueue.getContentField()[3]);
					getCSJText_Remark1().setText(mQueue.getContentField()[4]);
					getCSJText_LastUptBy1().setText(mQueue.getContentField()[5]);
					getCSJText_LastUptTime1().setText(mQueue.getContentField()[6]);
					getCSJText_DateStart2().setText(mQueue.getContentField()[7]);
					getCSJText_DateTo2().setText(mQueue.getContentField()[8]);
					getCSJText_ArCode2().setText(mQueue.getContentField()[9]);
					getCSJText_Remark2().setText(mQueue.getContentField()[10]);
					getCSJText_LastUptBy2().setText(mQueue.getContentField()[11]);
					getCSJText_LastUptTime2().setText(mQueue.getContentField()[12]);
					getCSJText_DateStart3().setText(mQueue.getContentField()[13]);
					getCSJText_DateTo3().setText(mQueue.getContentField()[14]);
					getCSJText_ArCode3().setText(mQueue.getContentField()[15]);
					getCSJText_Remark3().setText(mQueue.getContentField()[16]);
					getCSJText_LastUptBy3().setText(mQueue.getContentField()[17]);
					getCSJText_LastUptTime3().setText(mQueue.getContentField()[18]);
					getTextArea_InsuranceRmk().setText(mQueue.getContentField()[19]);
				}
			}
		});
	}

	private void searchPatient() {
		// if patno exist in the db then get the record and update the related fields value
		String newPatNo = getRTJText_PatientNumber().getText().trim();

		if (getActionType() == null
				&& newPatNo.length() > 0
				//&& !newPatNo.equals(memOldPatNo	)
				&& !isRegFlag()) {
			showPatient(newPatNo);

//			callDefaultFocusComponent();
		}
	}

	private void updateAge() {
		if (getPJText_Birthday().getText().length() == 10) {
			int currentYear = (new Integer(DateTimeFormat.getFormat("yyyyMMdd").format(new Date()))).intValue();
			try {
				int dobYear = Integer.parseInt(getPJText_Birthday().getText().substring(6));
				int dobMonth = Integer.parseInt(getPJText_Birthday().getText().substring(3, 5));
				int dobDay = Integer.parseInt(getPJText_Birthday().getText().substring(0, 2));

				int birthYear = dobYear * 10000 + dobMonth * 100 + dobDay;
				int age = (int) (currentYear - birthYear) / 10000;
				if (age >= 150) {
					Factory.getInstance().addErrorMessage(
							ConstantsMessage.MSG_INVALID_DATE,
							getPJText_Birthday());
					getPJText_Age().resetText();
					getPJText_Birthday().resetText();
					return;
				}
				getPJText_Age().setText(String.valueOf(age));

			} catch(Exception e) {
				getPJText_Age().resetText();
			}
		}
	}

	private void updatePatientName() {
		getRTJText_PatientName().setText(
				getPJText_FamilyName().getText() +
				SPACE_VALUE +
				getPJText_GivenName().getText()
			);
		// HKAH PBO asked to remove auto copy long name from short name @ 29/08/2017
//		if (QueryUtil.ACTION_APPEND.equals(getActionTypePatient())) {
//			getText_LongFName().setText(getPJText_FamilyName().getText());
//			getText_LongGName().setText(getPJText_GivenName().getText());
//		}
	}

	private void updatePatientChineseName() {
		getRTJText_PATCName().setText(getPJText_ChineseName().getText());
	}

	private void updatePatient(String[] outParam) {
		// set the values at top of rightpanel
		getRTJText_PatientNumber().setText(outParam[PATIENT_NUMBER]);
		memPatFName = outParam[PATIENT_FAMILY_NAME];
		getPJText_FamilyName().setText(memPatFName);
		memPatGName = outParam[PATIENT_GIVEN_NAME];
		getPJText_GivenName().setText(memPatGName);
		getPJText_MaidenName().setText(outParam[PATIENT_MAIDEN_NAME]);
		memPat_CName = outParam[PATIENT_CHINESE_NAME];
		getPJText_ChineseName().setText(memPat_CName);
		getRTJText_Sex().setText(outParam[PATIENT_SEX]);
		getPJCombo_Sex().setText(outParam[PATIENT_SEX]);
		getPJText_Birthday().setText(outParam[PATIENT_DOB]);
		getPJText_Age().setText(outParam[PATIENT_AGE]);
		getAJText_Mobile().setText(outParam[PATIENT_MOBILE_PHONE]);
		getAJText_HomePhone().setText(outParam[PATIENT_HOME_PHONE]);
		getPJText_IDPassportNO().setText(outParam[PATIENT_ID_NO]);
		getAJCombo_IDCountry().setText(outParam[PATIENT_ID_COUNTRY]);
		// set the values at personal information
		getPJCombo_Title().setText(outParam[PATIENT_TITDESC]);//MR.
		getPJCombo_MSTS().setText(outParam[PATIENT_MSTS]);
		getPJCombo_Race().setText(outParam[PATIENT_RACDESC]);
		getPJCombo_MotherLanguage().setText(outParam[PATIENT_MOTHCODE]);
		getPJCombo_EduLvl().setText(outParam[PATIENT_EDULEVEL]);
		getPJCombo_Religious().setText(outParam[PATIENT_RELIGIOUS]);
		getPJText_Death().setText(outParam[PATIENT_DEATH]);
		getPJText_Occupation().setText(outParam[PATIENT_OCCUPATION]);
		getPJText_MotherRecord().setText(outParam[PATIENT_MOTHER_RECORD]);
		getPJCheckBox_NewBorn().setSelected(MINUS_ONE_VALUE.equals(outParam[PATIENT_NEWBORN]));
		getPJCheckBox_Active().setSelected(MINUS_ONE_VALUE.equals(outParam[PATIENT_STATUS]));
		getPJCheckBox_Interpreter().setSelected(MINUS_ONE_VALUE.equals(outParam[PATIENT_INTERPRETER]));
		getPJCheckBox_Staff().setSelected(MINUS_ONE_VALUE.equals(outParam[PATIENT_STAFF]));
		getPJCheckBox_SMS().setSelected(MINUS_ONE_VALUE.equals(outParam[PATIENT_SMS]));
		getPJCheckBox_CheckID().setSelected(MINUS_ONE_VALUE.equals(outParam[PATIENT_CHKID]));

		// set the values at Address information
		getAJText_Email().setText(outParam[PATIENT_EMAIL]);
		getAJText_OfficePhone().setText(outParam[PATIENT_OFFICE_PHONE]);
		getAJText_FaxNO().setText(outParam[PATIENT_FAXNO]);
		getAJText_ADDR1().setText(outParam[PATIENT_ADD1]);
		getAJText_ADDR2().setText(outParam[PATIENT_ADD2]);
		getAJText_ADDR3().setText(outParam[PATIENT_ADD3]);
		getAJCombo_Location().setText(outParam[PATIENT_LOCATION]);
		getAJText_District().setText(outParam[PATIENT_DISTRICT]);
		getAJCombo_Country().setText(outParam[PATIENT_COUNTRY]);
		getAJText_Remark().setText(outParam[PATIENT_REMARK]);
		getAJText_LastUpdatedDate().setText(outParam[PATIENT_LAST_UPDATE_DATE]);
		getAJText_LastUpdatedBy().setText(outParam[PATIENT_LAST_UPDATE_USER]);

		// kin's info
		getRJText_KinName().setText(outParam[PATIENT_KIN_NAME]);
		getRJText_HomeTel().setText(outParam[PATIENT_KIN_HOME_PHONE]);
		getRJText_Pager().setText(outParam[PATIENT_KIN_PAGER_NO]);
		getRJText_Relationship().setText(outParam[PATIENT_KIN_RELATIONSHIP]);
		getRJText_OfficeTel().setText(outParam[PATIENT_KIN_OFFICE_PHONE]);
		getRJText_Mobile().setText(outParam[PATIENT_KIN_MOBILE_PHONE]);
		getRJText_Email().setText(outParam[PATIENT_KIN_EMAIL]);
		getRJText_Address().setText(outParam[PATIENT_KIN_ADDRESS]);
		if (SAME_AS_ABOVE.equals(getRJText_Address().getText())) {
			getRJCheckBox_SameAsAbove().setSelected(true);
		}
		memPatLongFName = outParam[PATIENT_LONG_FAMILY_NAME];
		getText_LongFName().setText(memPatLongFName);
		memPatLongGName = outParam[PATIENT_LONG_GIVEN_NAME];
		getText_LongGName().setText(memPatLongGName);
		getINJText_CreateSiteCode().setText(outParam[PATIENT_CREATE_SITECODE]);
		getTextArea_PatientRmk().setText(outParam[PATIENT_ADDITIONAL_REMARK]);
		getLabel_RmkLastUptByText().setText(outParam[PATIENT_REMARK_UPDATE_USER]);
		getLabel_RmkLastUptTimeText().setText(outParam[PATIENT_REMARK_UPDATE_DATE]);
		memRegID_L = outParam[PATIENT_REGID_L];
		memRegID_C = outParam[PATIENT_REGID_C];
		hasPatImage = "-1".equals(outParam[PATIENT_PHOTO]);
		getPJText_CheckIDLastUpdatedBy().setText(outParam[PATIENT_CHKID_UPDATE_USER]);
		getPJText_CheckIDLastUpdatedDate().setText(outParam[PATIENT_CHKID_UPDATE_DATE]);
		getPJCombo_DocType().setText(outParam[PATIENT_DOC_TYPE]);
		getPJCombo_MarketingSource().setText(outParam[PATIENT_MARKETING_SOURCE]);
		getPJText_MarketingRemark().setText(outParam[PATIENT_MARKETING_REMARK]);
		getRTJText_DentalPatientNo().setText(outParam[PATIENT_DENTALNO]);
		getPJText_MiscRemark().setText(outParam[PATIENT_MISC_REMARK]);
		getPJCombo_BirthOrdSPG().setText(outParam[PATIENT_BIRTH_ORDER]);
		getPJText_IDPassportNO_S1().setText(outParam[PATIENT_ADDIDNO1]);
		getPJCombo_DocType_S1().setText(outParam[PATIENT_ADDIDDOCTYPE1]);
		getAJCombo_IDCountry_S1().setText(outParam[PATIENT_ADDIDCOUCODE1]);
		getPJText_IDPassportNO_S2().setText(outParam[PATIENT_ADDIDNO2]);
		getPJCombo_DocType_S2().setText(outParam[PATIENT_ADDIDDOCTYPE2]);
		getAJCombo_IDCountry_S2().setText(outParam[PATIENT_ADDIDCOUCODE2]);
		getAJCombo_MobCouCode().setText(outParam[PATIENT_MOBCOUCODE]);
		getAJText_MobileUser().setText(outParam[PATIENT_APPUSEREXIST]);
		getAJText_MobileDate().setText(outParam[PATIENT_APPUSERLKDATE]);
		
		// store patient no
		currentPatNo = getRTJText_PatientNumber().getText().trim();

		// update age
//		updateAge();

		// set patient name
		updatePatientName();
		updatePatientChineseName();

		if (getPJText_IDPassportNO().isEmpty()) {
			getPJText_IDPassportNO().setErrorField(true, "Empty ID/Passport No.");
		}

		if (getPJText_Birthday().isEmpty()) {
			getPJText_Birthday().setErrorField(true, "Empty Birthday.");
		}

		if (getPJCombo_DocType().isEmpty()) {
			getPJCombo_DocType().setErrorField(true, "Empty Document Type.");
		}
		// update registration
		//setActionTypePatient(QueryUtil.ACTION_FETCH);
		setActionTypeRegistration(null);
		setActionTypeAdditInfo(null);
		setActionTypeEhr(null);
		setActionTypeConsent(null);

		// set record found
		setRecordFound(true);

		// e-HR
		showEhr(outParam[PATIENT_NUMBER]);

		// Consent
		showConsent(outParam[PATIENT_NUMBER]);

		// show consent if necessary
		if ("txnDetails".equals(memPre_form)) {
			memPre_form = null;
			getRBTPanel().setSelectedIndexWithoutStateChange(4);
		}

		// log view patient master index by staff id
		writePatientLog(getRTJText_PatientNumber().getText(), "VIEW-HATS", "View patient profile of #" + getRTJText_PatientNumber().getText(), getUserInfo().getSsoUserID());
	}

	private void showRegistration(boolean autoPrintLabel) {
		showRegistration(autoPrintLabel, null);
	}

	private void showRegistration(final boolean autoPrintLabel, final String regID) {
		getINJCombo_ARC().preloadContent();
		currentArcCode = null;
		getRegDtorTable().removeAllRow();
		getRTJRadio_DayCasePatient().setSelected(false);
		getRTJRadio_InPatient().setSelected(false);
		getRTJRadio_OutPatient().setSelected(false);
		getRTJText_OutPatientType().resetText();

		if (REG_INPATIENT.equals(getRegistrationMode())) {
			getRTJText_OutPatientType().resetText();
			getRTJRadio_InPatient().setSelected(true);
		} else if (REG_DAYCASE.equals(getRegistrationMode())) {
			getRTJText_OutPatientType().resetText();
			getRTJRadio_DayCasePatient().setSelected(true);
		} else if (REG_NORMAL.equals(getRegistrationMode())
				|| REG_WALKIN.equals(getRegistrationMode())
				|| REG_PRIORITY.equals(getRegistrationMode())
				|| REG_URGENTCARE.equals(getRegistrationMode())) {
			getRTJText_OutPatientType().setText(getRegCatName(getRegCat(getRegistrationMode())));
			getRTJRadio_OutPatient().setSelected(true);
		}  else if (REG_NOTHING.equals(getRegistrationMode())) {
			getRTJText_OutPatientType().resetText();
		}

		// set default
		getRTJRadio_Mainland().setSelected(false);
		getRTJRadio_NonMainland().setSelected(false);
		fillMedicalRecord(getRTJText_PatientNumber().getText());

		memRegStatus = null;
		if (REG_NOTHING.equals(getRegistrationMode())) {
			QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.PATIENT_REG_TXCODE,
					new String[] { memPatNo, regID },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						String[] outParam = mQueue.getContentField();
						int index = 0;
						String isMainland = null;

						String currentRegistrationType = outParam[index++];
						String regOpCat = outParam[index++];

//						setRegistrationMode(regMode);
						getRTJText_OutPatientType().setText(getRegCatName(regOpCat));

						memBedCode = outParam[index++];
						getINJText_BedNo().setText(memBedCode); //BEDCODE
						getINJText_DeptCode().setText(outParam[index++]);
						getINJText_WardType().setText(outParam[index++]);
						getINJCombo_AcmCode().setText(outParam[index++]); //ACMCODE
						isNewBorn = outParam[index++];
						getINJCheckBox_NewBorn().setSelected(MINUS_ONE_VALUE.equals(isNewBorn)); // ITMTYPED
						isMainland = outParam[index++];
						getINJText_ADMDoctor().setText(outParam[index++]); //Doccode_a
						getINRJText_ADMDoctor().setText(outParam[index++]);
						memAdmissionDate = outParam[index++];
						getINJText_ADMDate().setText(memAdmissionDate); //REGDATE
						getINJCombo_ADMFrom().setText(outParam[index++]); //Srccode
						getINJCombo_ADMType().setText(outParam[index++]); //AMTID
						getINJText_Remark().setText(outParam[index++]); //INPREMARK

						getINJText_SLPNO().setText(outParam[index++]);
						getINJText_TreDrCode().setText(outParam[index++]); //DOCCODE
						getINJText_TreDrName().setText(outParam[index++]);
						getINJCombo_Category().setPcyID(outParam[index++]); //PCYID
						getINJText_Category().setText(outParam[index++]);
						getINJText_Ref().setText(outParam[index++]); //PATREFNO
						getINJCombo_Source().setText(outParam[index++]); // BKGSID
						getINJText_SourceNo().setText(outParam[index++]); // SLPSNO
						currentArcCode = outParam[index++];
						getINJCombo_ARC().setText(currentArcCode); //ARCCODE
						getINJText_PLNO().setText(outParam[index++]); //SLPPLYNO
						getINJText_VHNO().setText(outParam[index++]); //SLPVCHNO

						memLimitAmt = outParam[index++];
						getINJText_LAmt().setText(memLimitAmt); //ARLMTAMT
						memCvrEndDate = outParam[index++];
						getINJText_endDate().setText(memCvrEndDate); //CVREDATE
						memCoPayType = outParam[index++];
						getINJCombo_CPAmt().setText(memCoPayType); //COPAYTYP
						memCoPayAmt = outParam[index++];
						getINJText_CPAmt().setText(memCoPayAmt); //COPAYAMT

						getINJCheckBox_Doctor().setSelected(MINUS_ONE_VALUE.equals(outParam[index++])); // ITMTYPED
						getINJCheckBox_Hspital().setSelected(MINUS_ONE_VALUE.equals(outParam[index++])); // ITMTYPEH
						getINJCheckBox_Special().setSelected(MINUS_ONE_VALUE.equals(outParam[index++])); // ITMTYPES
						getINJCheckBox_Other().setSelected(MINUS_ONE_VALUE.equals(outParam[index++])); // ITMTYPEO

						memGrtAmt = outParam[index++];
						getINJText_FGAmt().setText(memGrtAmt); //FURGRTAMT
						memGrtDate = outParam[index++];
						getINJText_FGDate().setText(memGrtDate);//FURGRTDATE

						memCvrItem = EMPTY_VALUE;
						if (getINJCheckBox_Doctor().isSelected()) { memCvrItem = "D"; }
						if (getINJCheckBox_Hspital().isSelected()) { memCvrItem += "H"; }
						if (getINJCheckBox_Special().isSelected()) { memCvrItem += "S"; }
						if (getINJCheckBox_Other().isSelected()) { memCvrItem += "O"; }

						String pkgCode = outParam[index++];
						memRegStatus = outParam[index++];
						index++;
						index++;
						//getINJText_Rec().setText(outParam[index++]);
						//getINJText_Med().setText(outParam[index++]);
						getINJText_ARC().setText(outParam[index++]);
						getINJText_ARCardType().setText(outParam[index++]);
						memRegID_C = outParam[index++];
						memPrintDate = outParam[index++];
						tmpOTAid = outParam[index++];
						memRegID_L = outParam[index++];
						getINJText_LengthOfStay().setText(outParam[index++]);
						getINJCheckBox_PrtMedRecordRpt().setSelected(MINUS_ONE_VALUE.equals(outParam[index++])); // PRINT_MRRPT
						getINJText_RmExt().setText(outParam[index++]);
						getRightJCombo_Misc().setText(outParam[index++]);
						getRightJCombo_SpRqt().setText(outParam[index++]);
						getINJCheckBox_Revlog().setSelected(MINUS_ONE_VALUE.equals(outParam[index++]));
						getINJCombo_LogCvrCls().setText(outParam[index++]);
						getINJCombo_Package().setText(outParam[index++]);
						getINJText_BedIsWindow().setText(outParam[index++]);
						getPJCheckBox_EstGiven().setText(outParam[index++]);
//						if (memRegID != null && memRegID.equals(regID_c)) {
//							getINButton_Inpat().setEnabled(true);
//						} else {
//							getINButton_Inpat().setEnabled(false);
//						}

						if (memRegID == null || memRegID.length() == 0) {
							memRegID = memRegID_C;
						}

						mem_FESTID = outParam[index++];
						if (mem_FESTID != null && !"".equals(mem_FESTID) && !getINJText_SLPNO().isEmpty()) {
							getRightButton_BudgetEst().setEnabled(true);
							getRightButton_BudgetEst().addStyleName("button-alert-green");
						} else {
							getRightButton_BudgetEst().setEnabled(false);
							getRightButton_BudgetEst().removeStyleName("button-alert-green");
						}
						getPJCheckBox_BE().setSelected(MINUS_ONE_VALUE.equals(outParam[index++]));

						getINJText_RefDoctor1().setText(outParam[index++]);
						getINRJText_RefDoctor1().setText(outParam[index++]);

						getINJText_RefDoctor2().setText(outParam[index++]);
						getINRJText_RefDoctor2().setText(outParam[index++]);
						getRTCombo_docRoom().setText(outParam[index++]);
//						if (oldRegMode != null) {
//							setRegistrationMode(oldRegMode);
//							oldRegMode = null;
//						}
						// copy admission date
						getINJText_RegDate().setText(getINJText_ADMDate().getText());

						// set registration type button
						setCurrentRegistrationType(currentRegistrationType);

						// set is from mainland radiobutton
						if (REG_TYPE_INPATIENT.equals(getCurrentRegistrationType())) {
							getRTJRadio_Mainland().setSelected(ONE_VALUE.equals(isMainland));
							getRTJRadio_NonMainland().setSelected(ZERO_VALUE.equals(isMainland));
						}

						// set regpkglink
						if (pkgCode != null && pkgCode.length() > 0) {
							getRegDtorTable().setListTableContent("REGPKGLINK", new String[] {memPatNo, memRegID});
						}

						// if it is not empty, new record is allowed only
						setActionTypeRegistration(QueryUtil.ACTION_FETCH);

						if (autoPrintLabel && (memAlertClinic == null || memAlertClinic.length() == 0) && isDisableFunction("isDisableAutoPLbl", "regPatReg")) {
							/**Print Label Automatically**/
							autoPrintLabel();
						}

						// call fill medical record
						//fillMedicalRecord(getRTJText_PatientNumber().getText());
					}
					// call disable field
//					enableButton();
					oTHandOverStatus(false);
					defaultFocus();
				}
			});
		} else {
			// call fill medical record
			//fillMedicalRecord(getRTJText_PatientNumber().getText());
			// call disable field
//			enableButton();
			oTHandOverStatus(false);
			defaultFocus();
		}
	}

	private String getActionTypeRegistration() {
		return memModeR;
	}

	private void setActionTypeRegistration(String actionTypeRegistration) {
		memModeR = actionTypeRegistration;
	}

	private String getActionTypePatient() {
		return memModeP;
	}

	private void setActionTypePatient(String actionTypePatient) {
		memModeP = actionTypePatient;
	}

	private String getActionTypeAdditInfo() {
		return memModeI;
	}

	private void setActionTypeAdditInfo(String actionTypeAdditInfo) {
		memModeI = actionTypeAdditInfo;
	}

	private String getActionTypeEhr() {
		return memModeE;
	}

	private void setActionTypeEhr(String actionTypeEhr) {
		memModeE = actionTypeEhr;
	}

	private String getActionTypeConsent() {
		return memModeC;
	}

	private void setActionTypeConsent(String actionTypeConsent) {
		memModeC = actionTypeConsent;
	}

	@Override
	protected String getActionType() {
		if (isRegFlag()) {
			return getActionTypeRegistration();
		} else if (isAdditionInfoFlag()) {
			return getActionTypeAdditInfo();
		} else if (isEhrFlag()) {
			return getActionTypeEhr();
		} else if (isConsentFlag()) {
			return getActionTypeConsent();
		} else {
			return getActionTypePatient();
		}
	}

	private String getActionType(int tab) {
		if (tab == 1) {
			return getActionTypeRegistration();
		} else if (tab == 2) {
			return getActionTypeAdditInfo();
		} else if (tab == 3) {
			return getActionTypeEhr();
		} else if (tab == 4) {
			return getActionTypeConsent();
		} else {
			return getActionTypePatient();
		}
	}

	/**
	 * @param actionType the actionType to set
	 */
	@Override
	protected void setActionType(String actionType) {
		if (isRegFlag()) {
			setActionTypeRegistration(actionType);
		} else if (isAdditionInfoFlag()) {
			setActionTypeAdditInfo(actionType);
		} else if (isEhrFlag()) {
			setActionTypeEhr(actionType);
		} else if (isConsentFlag()) {
			setActionTypeConsent(actionType);
		} else {
			setActionTypePatient(actionType);
		}
	}

	private void resetAllActionType() {
		setActionTypePatient(null);
		setActionTypeRegistration(null);
		setActionTypeAdditInfo(null);
		setActionTypeEhr(null);
	}

	private String getRegCat(String regCat) {
		if (REG_NORMAL.equals(regCat)) {
			return REG_CAT_NORMAL;
		} else if (REG_WALKIN.equals(regCat)) {
			return REG_CAT_WALKIN;
		} else if (REG_PRIORITY.equals(regCat)) {
			return REG_CAT_PRIORITY;
		} else if (REG_URGENTCARE.equals(regCat)) {
			return REG_CAT_URGENTCARE;
		} else {
			// REG_INPATIENT || REG_DAYCASE
			return EMPTY_VALUE;
		}
	}

	private String getRegCatName(String regCat) {

		if (REG_CAT_NORMAL.equals(regCat)) {
			return REG_DISPLAY_NORMAL;
		} else if (REG_CAT_WALKIN.equals(regCat)) {
			return REG_DISPLAY_WALKIN;
		} else if (REG_CAT_PRIORITY.equals(regCat)) {
			return REG_DISPLAY_PRIORITY;
		} else if (REG_CAT_URGENTCARE.equals(regCat)) {
			return REG_DISPLAY_URGENTCARE;
		} else {
			return "";
		}
	}

	private void getMomBabySearch(String momBabyPatNo, String momBabyPatFName, String momBabyPatGName) {
		QueryUtil.executeMasterBrowse(Factory.getInstance().getUserInfo(),
				"MOMBABYSEARCH", new String[] { momBabyPatNo, momBabyPatFName, momBabyPatGName, "B"},
				new MessageQueueCallBack() {
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					String mblDesc = mQueue.getContentField()[10];
					if (mblDesc != null && mblDesc.length() > 0) {
						getPJText_MRRemark().setText(mblDesc);
					} else {
						getPJText_MRRemark().resetText();
					}
				}
				defaultFocus();
			}
		});
	}

	private void showMomDetails(String momPatNo) {
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.PATIENT_TXCODE,
				new String[] {
					momPatNo
				}, new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					if (QueryUtil.ACTION_APPEND.equals(getActionTypePatient())) {
						//PATFNAME
						getPJText_FamilyName().setText("B/O " + mQueue.getContentField()[PATIENT_FAMILY_NAME]);
						//PATGNAME
						getPJText_GivenName().setText(mQueue.getContentField()[PATIENT_GIVEN_NAME]);
						//PATEMAIL
						getAJText_Email().setText(mQueue.getContentField()[PATIENT_EMAIL]);
						//PATHTEL
						getAJText_HomePhone().setText(mQueue.getContentField()[PATIENT_HOME_PHONE]);
						//PATPAGER
						getAJText_Mobile().setText(mQueue.getContentField()[PATIENT_MOBILE_PHONE]);
						//PATOTEL
						getAJText_OfficePhone().setText(mQueue.getContentField()[PATIENT_OFFICE_PHONE]);
						//PATFAXNO
						getAJText_FaxNO().setText(mQueue.getContentField()[PATIENT_FAXNO]);
						//PATADD1
						getAJText_ADDR1().setText(mQueue.getContentField()[PATIENT_ADD1]);
						//PATADD2
						getAJText_ADDR2().setText(mQueue.getContentField()[PATIENT_ADD2]);
						//PATADD3
						getAJText_ADDR3().setText(mQueue.getContentField()[PATIENT_ADD3]);
						//LOCCODE
						getAJCombo_Location().setText(mQueue.getContentField()[PATIENT_LOCATION]);
						//DSTNAME
						getAJText_District().setText(mQueue.getContentField()[PATIENT_DISTRICT]);
						//COUCODE
						getAJCombo_Country().setText(mQueue.getContentField()[PATIENT_COUNTRY]);
						//PATKNAME
						getRJText_KinName().setText(mQueue.getContentField()[PATIENT_KIN_NAME]);
						//PATKHTEL
						getRJText_HomeTel().setText(mQueue.getContentField()[PATIENT_KIN_HOME_PHONE]);
						//PATKPTEL
						getRJText_Pager().setText(mQueue.getContentField()[PATIENT_KIN_PAGER_NO]);
						//PATKOTEL
						getRJText_OfficeTel().setText(mQueue.getContentField()[PATIENT_KIN_OFFICE_PHONE]);
						//PATKMTEL
						getRJText_Mobile().setText(mQueue.getContentField()[PATIENT_KIN_MOBILE_PHONE]);
						//PATKEMAIL
						getRJText_Email().setText(mQueue.getContentField()[PATIENT_KIN_EMAIL]);
						//PATKADD
						getRJText_Address().setText(mQueue.getContentField()[PATIENT_KIN_ADDRESS]);
					}
				} else {
					Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_INVALID_PATIENTNO, PJText_MotherRecord);
				}
			}
		});
	}

/*
	private void printLabels(String value) {
		//print alert label
		PrintingUtil.print(getPrinterInfo().getLabelPtrName(),
				"ALERTLABEL", null, null,
				new String[] {
						Factory.getInstance().getUserInfo().getUserID(),
						getRTJText_PatientNumber().getText().trim()
				},
				new String[] {"patno", "sex", "patname", "dob", "alert"});

		//print label B
		Map<String,String> map = new HashMap<String,String>();
		map.put("PrnTktLbl", getSysParameter("PrnTktLbl"));
		if (getSysParameter("ChkDigit").equals("YES")) {
			map.put("key", "*"+getRTJText_PatientNumber().getText().trim()+
							getChcekCode(getRTJText_PatientNumber().getText().trim())+"*");
		} else {
			map.put("key", "*"+getRTJText_PatientNumber().getText().trim()+"*");
		}

		PrintingUtil.print(getPrinterInfo().getLabelPtrName(),
				"RptLblB", map, null,
				new String[] {
					memRegID,
					getRTJText_PatientNumber().getText().trim(),
					memBkgID,
					getRegistrationType()
				},
				new String[] {
								"siteCode",
								"patno",
								"patname",
								"patcname",
								"dob", "sex",
								"title", "apttime",
								"arrival", "ticketNo",
								"docname"});

		//ticket label
		try {
			if (Integer.parseInt(getSysParameter("TicketLblN")) > 0) {
			}
		} catch (Exception e) {
		}

		//patient label
		try {
			if (ConstantsProperties.OTP2 == 1) {
				if (Integer.parseInt(getSysParameter("NOPATLABEL")) > 0) {
				}
			}
		} catch (Exception e) {
		}

		//general label
	}
*/
	private void checkDocExist(String docCode) {
		if (docCode != null && docCode.length() > 0) {
			QueryUtil.executeMasterFetch(getUserInfo(), "DOCCODE_EXIST",
					new String[] { getINJText_TreDrCode().getText() },
					new MessageQueueCallBack() {
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						// get first return value and assign to district
						String docName = mQueue.getContentField()[1];
						getINJText_TreDrName().setText(docName);
					} else {
						QueryUtil.executeMasterFetch(getUserInfo(), "DOCTOR",
								new String[] {
									getINJText_TreDrCode().getText()
								},
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_WRONG_DOCCODE+
											"<br/>Admission Expiry Date: "+mQueue.getContentField()[21], getINJText_TreDrCode());
								} else {
									Factory.getInstance()
										.addErrorMessage("Inactive Doctor.<br/>Cannot get Admission Expiry Date", getINJText_TreDrCode());
								}
							}
						});
						getINJText_TreDrName().resetText();
						getINJText_TreDrCode().resetText();
					}
				}
			});
		} else {
			getINJText_TreDrName().resetText();
		}
	}

	private void checkDuplicatApp() {
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] { "BOOKING B, SCHEDULE S",
			"count(1)",
			" B.SCHID = S.SCHID AND TRUNC(bkgsdate) = TRUNC(SYSDATE) AND BKGSTS != 'C' AND PATNO = '" +getRTJText_PatientNumber().getText().trim() +"' AND S.DOCCODE = '" + getINJText_TreDrCode().getText().trim() + "' " },
				new MessageQueueCallBack() {
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.getContentField()[0] != null &&
						mQueue.getContentField()[0].length() > 0 &&
						Integer.parseInt(mQueue.getContentField()[0]) > 0) {
					Factory.getInstance()
					.addErrorMessage("Patient already has another appointment for same doctor on the same date!");
				}
			}
		});
	}
	
	private void checkDrCurRoom() {
		if (NO_VALUE.equals(Factory.getInstance().getSysParameter("DISABLERM")) && REG_TYPE_OUTPATIENT.equals(getCurrentRegistrationType())) {
			QueryUtil.executeMasterFetch(getUserInfo(), "DRROOM",
					new String[] { getRTJText_OutPatientType().getText(),getINJText_TreDrCode().getText().trim(),getRTCombo_docRoom().getText(),memBkgID},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						if (mQueue.getContentField()[0] != "" &&
								mQueue.getContentField()[0].length() > 0  && "0".equals(mQueue.getContentField()[1])) {//dr hv room and not duplicated
							getRTCombo_docRoom().setText(mQueue.getContentField()[0]);
						} else if ("1".equals(mQueue.getContentField()[1])){
							Factory.getInstance()
							.addErrorMessage("The Room is occupied by Doctor: "+mQueue.getContentField()[0]);
							getRTCombo_docRoom().resetText();
						} else if ("-1".equals(mQueue.getContentField()[1])){
							getRTCombo_docRoom().resetText();
						}
					}
				}
			});
		}

	}

	private int getAppLableNum() {
		int tempGetAppLableNum;
		int getAppLableNum;

		try {
			tempGetAppLableNum = Integer.parseInt(getSysParameter("AppLabNum"));
		} catch (Exception e) {
			tempGetAppLableNum = 0;
		}

		if (tempGetAppLableNum < 1) {
			getAppLableNum = 1;
		} else {
			getAppLableNum = tempGetAppLableNum;
		}

		return getAppLableNum;
	}

	private void printLab() {
		if (getAppLableNum() < 1) {
			return;
		}
		if ("A".equals(getSysParameter("LBLTYP").toUpperCase())) {
			printPickLstLabel();
		} else {
			getMrhvollab();
		}
	}

	private void printPickLstLabel() {
		final String sgName = (getPJText_FamilyName().getText().trim() + SPACE_VALUE + getPJText_GivenName().getText().trim()).replace("'", "''");

		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] { "doctor d,spec sp , site s",
			"S.STENAME, D.DOCCODE, D.DOCFNAME, D.DOCGNAME, TO_CHAR(sysdate, 'DD/MM/YYYY') as BKGSDATE, TO_CHAR(sysdate, 'HH24:MI') as strBkgsDt, " +
			getRTJText_PatientNumber().getText().trim() + " as patno, '" + sgName + "' as bkgpname ,'" + CommonUtil.getComputerName() + "' as Sendto ",
			" d.spccode = sp.spccode and s.stecode= '" +getUserInfo().getSiteCode() +"' and d.doccode= '" + getINJText_TreDrCode().getText().trim() + "' " },
				new MessageQueueCallBack() {
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					final String strBkgsDt = mQueue.getContentField()[5];
					final String bkgsdate = mQueue.getContentField()[4];
					final String bkgpname = mQueue.getContentField()[7];

					if ("A".equals(getSysParameter("LBLTYP").toUpperCase())) {
						if (getAppLableNum() > 0) {

							final String sTempDocCode = mQueue.getContentField()[1];
							final String sTempDocName = mQueue.getContentField()[2] + SPACE_VALUE + mQueue.getContentField()[3];
							final String sSendTo = mQueue.getContentField()[8];

							QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.PRINTPICKLSTLABEL,
									new String[] { getRTJText_PatientNumber().getText().trim() },
									new MessageQueueCallBack() {
								@Override
								public void onPostSuccess(MessageQueue mQueue) {
//									String sMedRecID = "";
									String sVolNumber = "";
									String variable_current_location = "";
									String sDoctorName = "";

									if (mQueue.success()) {
//										  sMedRecID = mQueue.getContentField()[0];
										  sVolNumber = mQueue.getContentField()[2];
										  variable_current_location = mQueue.getContentField()[1];
										  if (mQueue.getContentField()[3].length() > 0) {
											  sDoctorName = "(" + mQueue.getContentField()[3] + ")";
										  } else {
											  sDoctorName = "";
										  }
									}

									final HashMap<String, String> map = new HashMap<String, String>();
									map.put("DOCNAME", sTempDocName);
									map.put("BKGSDATE", strBkgsDt + "(" +bkgsdate + ")*");
									map.put("PATNO", getRTJText_PatientNumber().getText().trim());
									map.put("VOLNUM", sVolNumber);
									map.put("PATNAME", bkgpname);
									map.put("LOCATION", variable_current_location + sDoctorName );
									map.put("SENDTO", sSendTo);

									if (YES_VALUE.equals(Factory.getInstance().getSysParameter("CLCHARTLOG"))) {
										if (sVolNumber == null ||  sVolNumber.length() == 0) {
											Factory.getInstance().addErrorMessage("It does not have any medical chart");
											return;
										}

										QueryUtil.executeMasterAction(
												Factory.getInstance().getUserInfo(),
												ConstantsTx.MEDRECDTL_TXCODE, QueryUtil.ACTION_APPEND,
												new String[] {
													sTempDocCode,
													EMPTY_VALUE,
													(getRTJRadio_InPatient().isSelected()?"In-patient Registration":"Out-patient Registration"),
													Factory.getInstance().getUserInfo().getUserID(),
													CommonUtil.getComputerName(),
													sVolNumber,
													getRTJText_PatientNumber().getText().trim()
												},
												new MessageQueueCallBack() {
													@Override
													public void onPostSuccess(MessageQueue mQueue) {
														if (mQueue.success()) {
//															String sBarCode = "*-C/" + sMedRecID;

															PrintingUtil.print(getSysParameter("PRTRMEDLBL"),
																	"PickLstLbl",
																	map, sgName);
														}
													}
												});
									} else {
										PrintingUtil.print(getSysParameter("PRTRMEDLBL"),
												"PickLstLbl",
												map, sgName);
									}
								}
							});
						} else {
							Factory.getInstance().addErrorMessage("no appointment label number.");
						}
					}
				}
			}
		});
	}

	private void getMrhvollab() {
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] { "MedRecHdr H, MEDRECMED M ", "max(H.mrhvollab) as maxvol",
				" h.MrmID = m.MrmID AND M.MRMID = 1 AND mrhsts='N' and patno= '"+getRTJText_PatientNumber().getText().trim()+"' order by mrhvollab desc" },
				new MessageQueueCallBack() {
			public void onPostSuccess(MessageQueue mQueue) {
				String mrhvollab = EMPTY_VALUE;
				if (mQueue.success()) {
					if (mQueue.getContentField()[0].length() > 0) {
						mrhvollab = "(" + mQueue.getContentField()[0] + ")";
					} else {
						mrhvollab = "(  )";
					}
				} else {
					mrhvollab = "(  )";
				}
				getMrhvollabReady(mrhvollab);
			}
		});
	}

	private void getMrhvollabReady(final String mrhvollab) {
		final String sgName = getPJText_FamilyName().getText().trim() + SPACE_VALUE + getPJText_GivenName().getText().trim();
		if (YES_VALUE.equals(Factory.getInstance().getSysParameter("CLCHARTLOG"))) {
			if (mrhvollab == null ||  mrhvollab.replace("(", "").replace(")", "").trim().length() == 0) {
				Factory.getInstance().addErrorMessage("It does not have any medical chart");
				return;
			}
		}

		if (getRTJRadio_InPatient().isSelected()) {
			QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.REGPRINTCALLCHART, new String[] {
				sgName,
				getRTJText_PatientNumber().getText().trim(),
				getINJText_BedNo().getText().trim() + SPACE_VALUE + "(" + getINJText_WardType().getText().trim() + ")",
				getUserInfo().getSiteCode(),
				getINJText_TreDrCode().getText().trim(),
				Factory.getInstance().getUserInfo().getUserID()
			}, new MessageQueueCallBack() {
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						final HashMap<String, String> map = new HashMap<String, String>();
						map.put("steName", mQueue.getContentField()[12]);
						map.put("bkgpName", mQueue.getContentField()[0]);
						map.put("spcName", mQueue.getContentField()[9]);
						map.put("docName", mQueue.getContentField()[7]);
						map.put("bkgsDate", mQueue.getContentField()[11]);
						map.put("bkgsDate2", "(" + mQueue.getContentField()[10] + ")");
						map.put("stecode", getUserInfo().getUserName());
						map.put("patNOA", mQueue.getContentField()[2]);
						map.put("patNOB", mQueue.getContentField()[3]);
						map.put("patNOC", mQueue.getContentField()[4]);
						map.put("patNOD", mQueue.getContentField()[5]);
						map.put("patNOE", mQueue.getContentField()[6]);
						map.put("volume", mrhvollab);
						map.put("alertcode", mQueue.getContentField()[14]);
						map.put("isStaff", mQueue.getContentField()[15]);
						map.put("pcName", CommonUtil.getComputerName());
						if (REG_WALKIN.equals(getRegistrationMode())) {
							map.put("walkin", "WI");
						} else if (REG_PRIORITY.equals(getRegistrationMode())) {
							map.put("walkin", "P");
						} else if (REG_URGENTCARE.equals(getRegistrationMode())) {
							map.put("walkin", "UC");
						} else {
							map.put("walkin", "");
						}
						map.put("userID", mQueue.getContentField()[16]);

						if (YES_VALUE.equals(Factory.getInstance().getSysParameter("CLCHARTLOG"))) {
							QueryUtil.executeMasterAction(
									Factory.getInstance().getUserInfo(),
									ConstantsTx.MEDRECDTL_TXCODE, QueryUtil.ACTION_APPEND,
									new String[] {
										mQueue.getContentField()[8],
										EMPTY_VALUE,
										"In-patient Registration",
										Factory.getInstance().getUserInfo().getUserID(),
										CommonUtil.getComputerName(),
										mrhvollab == null?SPACE_VALUE:mrhvollab.replace("(", "").replace(")", "").trim(),
										getRTJText_PatientNumber().getText().trim()
									},
									new MessageQueueCallBack() {
										@Override
										public void onPostSuccess(MessageQueue mQueue) {
											if (mQueue.success()) {
												PrintingUtil.print(getSysParameter("PRTRMEDLBL"),
														"RegPrtCallCht",
														map,null, 2);
											}
										}
									});
						} else {
							PrintingUtil.print(getSysParameter("PRTRMEDLBL"),
									"RegPrtCallCht",
									map,null, 2);
						}
					}
				}
			});
		} else {
			final HashMap<String, String> map = new HashMap<String, String>();
			map.put("bkgsDate", "");
			map.put("SteName", getUserInfo().getSiteName());
			map.put("Volume",  mrhvollab == null ? SPACE_VALUE : mrhvollab);
			if (getRTJRadio_DayCasePatient().isSelected()) {
				map.put("walkin", "DC");
			} else if (REG_DISPLAY_WALKIN.equals(getRTJText_OutPatientType().getValue())) {
				map.put("walkin", "WI");
			} else if (REG_DISPLAY_PRIORITY.equals(getRTJText_OutPatientType().getValue())) {
				map.put("walkin", "P");
			} else if (REG_DISPLAY_URGENTCARE.equals(getRTJText_OutPatientType().getValue())) {
				map.put("walkin", "UC");
			} else {
				map.put("walkin", "");
			}
			map.put("pcName", CommonUtil.getComputerName());
			System.out.println("---Registration(Print Call Chart label)---");
			System.out.println("Pat No: "+getRTJText_PatientNumber().getText().trim());
			System.out.println("Location: "+CommonUtil.getComputerName());
			System.out.println("Required By: "+getINJText_TreDrCode().getText().trim());
			System.out.println("WalkIN/Priority: "+("Priority".equals(getRTJText_OutPatientType().getValue())?"P":"W"));
			System.out.println("-----------------------------------------");

			if (YES_VALUE.equals(Factory.getInstance().getSysParameter("CLCHARTLOG"))
					&& (!getRTJRadio_DayCasePatient().isSelected())) {
				QueryUtil.executeMasterAction(
						Factory.getInstance().getUserInfo(),
						ConstantsTx.MEDRECDTL_TXCODE, QueryUtil.ACTION_APPEND,
						new String[] {
							getINJText_TreDrCode().getText(),
							EMPTY_VALUE,
							"Out-patient Registration",
							Factory.getInstance().getUserInfo().getUserID(),
							CommonUtil.getComputerName(),
							mrhvollab == null?SPACE_VALUE:mrhvollab.replace("(", "").replace(")", "").trim(),
							getRTJText_PatientNumber().getText().trim()
						},
						new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									PrintingUtil.print(getMainFrame().getSysParameter("PRTRMEDLBL"),
											"RegPrtCallChtDrApp", map, null,
											 new String[]{
													sgName,
													getRTJText_PatientNumber().getText().trim(),
													getUserInfo().getSiteCode(),
													getINJText_TreDrCode().getText().trim(),
													getParameter("BkgID"),
													getINJText_SLPNO().getText(),
													getMainFrame().getSysParameter("AppLabNum")
											},
											new String[]{"bkgname", "patno", "patnoA",
														 "patnoB", "patnoC", "patnoD",
														 "patnoE", "docName", "docCode",
														 "spcname",
														 "bkgsdate2", "bkgsdate", "stename",
														  "isStaff", "alert", "userID"
														 }, 2);
								}
							}
						});
			} else {
				PrintingUtil.print(getMainFrame().getSysParameter("PRTRMEDLBL"),
						"RegPrtCallChtDrApp", map, null,
						 new String[]{
								sgName,
								getRTJText_PatientNumber().getText().trim(),
								getUserInfo().getSiteCode(),
								getINJText_TreDrCode().getText().trim(),
								getParameter("BkgID"),
								getINJText_SLPNO().getText(),
								getMainFrame().getSysParameter("AppLabNum")
						},
						new String[]{"bkgname", "patno", "patnoA",
									 "patnoB", "patnoC", "patnoD",
									 "patnoE", "docName", "docCode",
									 "spcname",
									 "bkgsdate2", "bkgsdate", "stename",
									  "isStaff", "alert", "userID"
									 }, 2);
			}
		}
	}

	private void showTransactions() {
		showTransactions(getINJText_SLPNO().getText());
	}

	private void showTransactions(String slpNo) {
		setParameter("SlpNo", slpNo);
		setParameter("From", "PATREG");
		showPanel(new TransactionDetail());
	}

	private void printBasicInfoForm() {
		QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.PRINTADMISSIONFORM,
				new String[] { "basic", getRTJText_PatientNumber().getText().trim(), EMPTY_VALUE, EMPTY_VALUE },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue2) {
				if (mQueue2.success()) {
					String patNo = mQueue2.getContentField()[0];
					final boolean isChkDigit = "YES".equals(getSysParameter("ChkDigit"));
					String tempChkDigit = "#";
					if (isChkDigit) {
						if (patNo != null
							&& !"".equals(patNo.trim())) {
							tempChkDigit = PrintingUtil.generateCheckDigit(patNo.trim()).toString()+"#";
						}
					}
					final String checkDigit = tempChkDigit;

					String sex = null;
					if ("F".equals(mQueue2.getContentField()[5].toUpperCase())) {
						sex = "Female";
					} else if ("M".equals(mQueue2.getContentField()[5].toUpperCase())) {
						sex = "Male";
					} else {
						sex = "Unknown";
					}
					String maritalStatus = getPJCombo_MSTS().getDisplayText(mQueue2.getContentField()[12]);
					if (maritalStatus == null) {
						maritalStatus = "";
					}

					HashMap<String, String> map = new HashMap<String, String>();
					map.put("patNo", mQueue2.getContentField()[0]);
					map.put("patDOB", mQueue2.getContentField()[4]);
					map.put("patSex", sex.toUpperCase());
					map.put("patHPhone", mQueue2.getContentField()[10]);
					map.put("patMPhone", mQueue2.getContentField()[13]);
					map.put("patOPhone", mQueue2.getContentField()[11]);
					map.put("patNation", mQueue2.getContentField()[7].toUpperCase());
					map.put("patReli", mQueue2.getContentField()[37]);
					map.put("patAdd", mQueue2.getContentField()[15]+
							(!mQueue2.getContentField()[15].equals("")?",":"")
							+mQueue2.getContentField()[16]+
							(!mQueue2.getContentField()[16].equals("")?",":"")
							+mQueue2.getContentField()[17]+
							(!mQueue2.getContentField()[17].equals("")?",":"")
							+mQueue2.getContentField()[9]);
					map.put("patSname", mQueue2.getContentField()[1]);
					map.put("patFname", mQueue2.getContentField()[2]);
					map.put("patIDNo", mQueue2.getContentField()[6]);
					map.put("patMStatus", maritalStatus.toUpperCase());
					map.put("patEduLvl", mQueue2.getContentField()[8]);
					map.put("patOccptn", mQueue2.getContentField()[36]);
					map.put("patCorrLang", mQueue2.getContentField()[14]);
					map.put("patEmail", mQueue2.getContentField()[42]);
					map.put("patRomNo", mQueue2.getContentField()[26]);
					map.put("patBedNo", mQueue2.getContentField()[27]);
					map.put("NKName", mQueue2.getContentField()[19]);
					map.put("NKOPhone", mQueue2.getContentField()[38]);
					map.put("NKEmail", mQueue2.getContentField()[43]);
					map.put("NKAdd", mQueue2.getContentField()[22]);
					map.put("NKRetnshp", mQueue2.getContentField()[20]);
					map.put("NKMPhone", mQueue2.getContentField()[39]);
					map.put("NKPager", mQueue2.getContentField()[40]);
					map.put("NKHPhone", mQueue2.getContentField()[21]);
					map.put("patFax", (getAJText_FaxNO().getValue() == null ? "" : getAJText_FaxNO().getValue()));
					map.put("docID", mQueue2.getContentField()[28]);
					map.put("docName", mQueue2.getContentField()[29] + mQueue2.getContentField()[30]);
					map.put("patAdmDate", mQueue2.getContentField()[31]);
					map.put("patRomClass", mQueue2.getContentField()[32]);
					map.put("patSlpNo", getINJText_SLPNO().getText().trim());
					map.put("patInsurNo", getINJText_PLNO().getText().trim());
					map.put("arCompName", getINJText_ARC().getText().trim());
					map.put("patVouNo", getINJText_VHNO().getText().trim());
					map.put("admClerk", mQueue2.getContentField()[44]);
					map.put("patcname", mQueue2.getContentField()[45]);
					map.put("mktSts", mQueue2.getContentField()[47]);
					map.put("ImgTick", CommonUtil.getReportImg("tick1.gif"));
					map.put("patno1", mQueue2.getContentField()[0] + (isChkDigit ? checkDigit : "#"));
					map.put("LogoImg", CommonUtil.getReportImg(mQueue2.getContentField()[48]+"_rpt_logo.jpg"));
							//Factory.getInstance().getSysParameter("curtSite")
					map.put("mktSrc", getPJCombo_MarketingSource().getText());
					map.put("siteCode", mQueue2.getContentField()[48]);
					PrintingUtil.print(getSysParameter("PRTFORM"),
							"BASICINFOFRM_"+
							getUserInfo().getSiteCode().toUpperCase(),
							map, mQueue2.getContentField()[3]);
				} else {
					Factory.getInstance().addErrorMessage("Patient record does not exist.<br>Admission Form Printing is fails.");
				}
			}
		});
	}

	private void printAdmForm() {
		getRegDtorTable().removeAllRow();
		QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.PATIENT_REG_TXCODE,
				new String[] { memPatNo, memRegID },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(final MessageQueue mQueue1) {
				if (mQueue1.success()) {
					getINJText_SLPNO().setText(mQueue1.getContentField()[14]);
					QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.PRINTADMISSIONFORM,
							new String[] { "admission", memPatNo, getINJText_SLPNO().getText().trim()},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue2) {
							if (mQueue2.success()) {
								final String patNo = mQueue2.getContentField()[0];
								final String patDOB = mQueue2.getContentField()[4];
								final String patSname = mQueue2.getContentField()[1];
								final String patFname = mQueue2.getContentField()[2];
								final String patSex = mQueue2.getContentField()[5];
								final String alertCode = mQueue2.getContentField()[51];
								final String roomRate = mQueue2.getContentField()[52];
								final String wardRoundRate = mQueue2.getContentField()[53];

								String patLang = mQueue2.getContentField()[48];

								final boolean isChkDigit = "YES".equals(getSysParameter("ChkDigit"));
								String tempChkDigit = "#";
								if (isChkDigit) {
									if (patNo != null
										&& !"".equals(patNo.trim())) {
										tempChkDigit = PrintingUtil.generateCheckDigit(patNo.trim()).toString()+"#";
									}
								}
								final String checkDigit = tempChkDigit;

								 String sex = null;
								if (mQueue2.getContentField()[5].toUpperCase().equals("F")) {
									sex = "Female";
								} else if (mQueue2.getContentField()[5].toUpperCase().equals("M")) {
									sex = "Male";
								} else {
									sex = "Unknown";
								}
								String maritalStatus = getPJCombo_MSTS().getDisplayText(mQueue2.getContentField()[12]);
								if (maritalStatus == null) {
									maritalStatus = "";
								}

								if (!"".equals(alertCode) && "Y".equals(Factory.getInstance().getSysParameter("ISPRTALTFM"))) {
									MessageBoxBase.alert(MSG_PBA_SYSTEM,
											"Patient Alert Exist. Please put paper in Printer.",
											new Listener<MessageBoxEvent>() {
										@Override
										public void handleEvent(MessageBoxEvent be) {
											if (Dialog.OK.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
												HashMap<String, String> map = new HashMap<String, String>();
												map.put("patNo", patNo);
												map.put("patDOB", patDOB);
												map.put("patSex", patSex.toUpperCase());
												map.put("patSname", patSname);
												map.put("patFname", patFname);
												map.put("alertCode", alertCode);
												map.put("LogoImg",CommonUtil.getReportImg(Factory.getInstance().getSysParameter("curtSite")+"_rpt_logo.jpg"));
												PrintingUtil.print(getSysParameter("PRTFORM"),
														"ALERTFORM_"+Factory.getInstance().getUserInfo().getSiteCode(),
														map,null,1);
											}
										}
									});
								}
								HashMap<String, String> map = new HashMap<String, String>();
								map.put("patNo", mQueue2.getContentField()[0]);
								map.put("patDOB", mQueue2.getContentField()[4]);
								map.put("patSex", sex.toUpperCase());
								map.put("patHPhone", mQueue2.getContentField()[10]);
								map.put("patMPhone", mQueue2.getContentField()[13]);
								map.put("patOPhone", mQueue2.getContentField()[11]);
								map.put("patNation", mQueue2.getContentField()[7].toUpperCase());
								map.put("patReli", mQueue2.getContentField()[37]);
								map.put("patAdd", mQueue2.getContentField()[15]+
										(!mQueue2.getContentField()[15].equals("")?",":"")
										+mQueue2.getContentField()[16]+
										(!mQueue2.getContentField()[16].equals("")?",":"")
										+mQueue2.getContentField()[17]+
										(!mQueue2.getContentField()[17].equals("")?",":"")
										+mQueue2.getContentField()[9]);
								map.put("patSname", mQueue2.getContentField()[1]);
								map.put("patFname", mQueue2.getContentField()[2]);
								map.put("patIDNo", mQueue2.getContentField()[6]);
								map.put("patMStatus", maritalStatus.toUpperCase());
								map.put("patEduLvl", mQueue2.getContentField()[8]);
								map.put("patOccptn", mQueue2.getContentField()[36]);
								map.put("patCorrLang", mQueue2.getContentField()[14]);
								map.put("patEmail", mQueue2.getContentField()[42]);
								map.put("patRomNo", mQueue2.getContentField()[26]);
								map.put("patBedNo", mQueue2.getContentField()[27]);
								map.put("NKName", mQueue2.getContentField()[19]);
								map.put("NKOPhone", mQueue2.getContentField()[38]);
								map.put("NKEmail", mQueue2.getContentField()[43]);
								map.put("NKAdd", mQueue2.getContentField()[22]);
								map.put("NKRetnshp", mQueue2.getContentField()[20]);
								map.put("NKMPhone", mQueue2.getContentField()[39]);
								map.put("NKPager", mQueue2.getContentField()[40]);
								map.put("NKHPhone", mQueue2.getContentField()[21]);
								map.put("patFax", (getAJText_FaxNO().getValue() == null ? "" : getAJText_FaxNO().getValue()));
								map.put("docID", mQueue2.getContentField()[28]);
								map.put("docName", mQueue2.getContentField()[29] + SPACE_VALUE + mQueue2.getContentField()[30]);
								map.put("patAdmDate", mQueue2.getContentField()[31]);
								map.put("patRomClass", mQueue2.getContentField()[32]);
								map.put("patSlpNo", getINJText_SLPNO().getText().trim());
								map.put("patInsurNo", getINJText_PLNO().getText().trim());
								map.put("arCompName", getINJText_ARC().getText().trim());
								map.put("patVouNo", getINJText_VHNO().getText().trim());
								map.put("admClerk", mQueue2.getContentField()[44]);
								map.put("patcname", mQueue2.getContentField()[45]);
								map.put("patno1", mQueue2.getContentField()[0] + (isChkDigit ? checkDigit : "#"));
								map.put("remark", mQueue2.getContentField()[49]);
								map.put("mktSts", mQueue2.getContentField()[47]);
								map.put("ImgTick", CommonUtil.getReportImg("tick1.gif"));
								map.put("LogoImg",CommonUtil.getReportImg(Factory.getInstance().getSysParameter("curtSite")+"_rpt_logo.jpg"));
								map.put("SUBREPORT_DIR", CommonUtil.getReportDir());
								map.put("refDoctor1ID", mQueue1.getContentField()[57]);
								map.put("refDoctor1Name", mQueue1.getContentField()[58]);
								map.put("refDoctor2ID", mQueue1.getContentField()[59]);
								map.put("refDoctor2Name", mQueue1.getContentField()[60]);
								map.put("patAge", mQueue2.getContentField()[50]);
								map.put("roomRate", roomRate);
								map.put("wardRoundRate", wardRoundRate);
								
								PrintingUtil.print(getSysParameter("PRTFORM"),
										"ADMFRM2PAT_"+Factory.getInstance().getUserInfo().getSiteCode()
										+(YES_VALUE.equals(getSysParameter("PRTJAPADM"))?
												("SMC".equals(patLang)?"_TRC":"_"+("".equals(patLang)?"ENG":patLang))
												:((		"CTE".equals(patLang)||
														"MAN".equals(patLang)||
														"NP".equals(patLang) ||
														"POT".equals(patLang) ||
														"SMC".equals(patLang) ||
														"TRC".equals(patLang) ||
														"CHT".equals(patLang) ||
														"".equals(patLang))?
													"_CHI":"_ENG")),
										map,mQueue2.getContentField()[45],Integer.parseInt(mQueue2.getContentField()[46]));
							} else {
								Factory.getInstance().addErrorMessage("Patient record does not exist.<br>Admission Form Printing is fails.");
							}
						}
					});
				} else {
					Factory.getInstance().addErrorMessage("Patient record does not exist.<br>Admission Form Printing is fails.");
				}
			}
		});
	}

	private void printOThandOver() {
		Map<String,String> map = new HashMap<String,String>();
		map.put("PATNO", getRTJText_PatientNumber().getText().trim());
		map.put("PATNAME", getRTJText_PatientName().getText().trim());
		map.put("OTROOM_TYPE", ConstantsGlobal.OT_ROOM);
		map.put("OTAID", tmpOTAid);
		map.put("STENAME", getUserInfo().getSiteName());
		PrintingUtil.print("OTHandover", map, "",
				new String[] { tmpOTAid, ConstantsGlobal.OT_ROOM },
				new String[] { "ROOM", "BED", "OTSTART", "OTEND", "OPERATION", "SURGEON", "OTROOM", "OTAID", "BARCODE" });
	}

	private void printPhysicalOrderForm() {
		Boolean isG = false;
		String tempArc = getINJCombo_ARC().getText().trim();
		String searchCriteria = "";

		if (memRegID != null && memRegID.length() > 0) {
			searchCriteria = "R.REGID='" + memRegID +"'";
		} else {
			searchCriteria = "R.BKGID='" + memBkgID +"'";
		}
		if (tempArc != null && tempArc.length() > 0) {
			tempArc = tempArc.substring(0, 1);
			isG = "G".equals(tempArc);
		}

		if (isG) {
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] { "REG R, PATIENT P, DOCTOR D, GOVREG G, GOVJOB J, ARCODE A ",
					"R.REGID,P.PATNO,INITCAP(CONCAT(P.PATFNAME,(' '||P.PATGNAME))),P.PATIDNO,TO_CHAR(P.PATBDATE,'dd/MM/YYYY'),P.PATSEX,INITCAP(CONCAT(('DR. '||D.DOCFNAME),(' '||D.DOCGNAME))),TO_CHAR(R.REGDATE,'dd/MM/YYYY HH24:MM'),INITCAP(A.ARCNAME),J.GOVPOSITION,TO_CHAR(R.REGDATE+5,'dd/MM/YYYY'),P.PATCNAME ",
					"R.PATNO=P.PATNO AND R.DOCCODE=D.DOCCODE AND "+ searchCriteria +" AND R.REGID=G.REGID AND J.GOVJOBCODE=G.GOVJOBCODE AND J.ARCCODE=A.ARCCODE "},
					new MessageQueueCallBack() {

						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								memRegID = mQueue.getContentField()[0];

								/*Check digit*/
								String newbarcode = mQueue.getContentField()[1] + ("YES".equals(getSysParameter("ChkDigit")) ?
										PrintingUtil.generateCheckDigit(mQueue.getContentField()[1]).toString()+"#" : "#");

								HashMap<String, String> map = new HashMap<String, String>();
								map.put("regid", memRegID);
								map.put("patno", mQueue.getContentField()[1]);
								map.put("name", mQueue.getContentField()[2]);
								map.put("sex", mQueue.getContentField()[5]);
								map.put("dob", mQueue.getContentField()[4]);
								map.put("hkid", mQueue.getContentField()[3]);
								map.put("orderDate", mQueue.getContentField()[7]);
								map.put("docName", mQueue.getContentField()[6]);
								map.put("govDept", mQueue.getContentField()[8]);
								map.put("govPosition", mQueue.getContentField()[9]);
								map.put("reportDueDate", mQueue.getContentField()[10]);
								String patcname = mQueue.getContentField()[11];

								map.put("SUBREPORT_DIR", CommonUtil.getReportDir());
								map.put("LogoImg", CommonUtil.getReportImg("Horizontal_billingual_HKAH_TW.jpg"));
								map.put("BreastImg", CommonUtil.getReportImg("breast.jpg"));
								map.put("userID", Factory.getInstance().getUserInfo().getUserID());
								map.put("userName", Factory.getInstance().getUserInfo().getUserName());
								map.put("newbarcode", newbarcode);

								PrintingUtil.print(
										"PHYORDERFORM_DEPT",
										map,
										patcname,
										new String[]{memRegID},
										new String[]{"DPTCODE","DPTNAME","ITMCODE","ITMNAME","DSCCODE","DSCDESC"}
									);
								PrintingUtil.print(
										"PHYORDERFORM_MR",
										map,
										patcname,
										new String[]{memRegID},
										new String[]{"DPTCODE","DPTNAME","ITMCODE","ITMNAME","GUIDELINE"},
										2,
										new String[] {"PHYORDERFORM_MR_SUB1","PHYORDERFORM_MR_SUB2"},
										new String[][] {
											{ memRegID },
											{ memRegID }
										},
										new String[][] {
											{ "ITMCODE","ITMNAME","GUIDELINE","GLCCODE" },
											{ "DPTCODE","DPTNAME" }
										},
										new boolean[][] {
											{ false, false, false, false },
											{ false, false }
										}, 1);
							} else {
								Factory.getInstance().addErrorMessage("Patient record does not exist.<br>Physical Checkup Order Form Printing is fails.");
								System.out.println("Physical Checkup Order Form Error: " + mQueue.getReturnMsg());
							}

						}
					});
		} else {
			QueryUtil.executeMasterFetch(getUserInfo(), "PHYSICALORDERFORM",
					new String[] { memRegID, memBkgID },
					new MessageQueueCallBack() {

						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {

								/*Check digit*/
								String newbarcode = mQueue.getContentField()[1] + ("YES".equals(getSysParameter("ChkDigit")) ?
										PrintingUtil.generateCheckDigit(mQueue.getContentField()[1]).toString()+"#" : "#");

								HashMap<String, String> map = new HashMap<String, String>();
								map.put("regid", mQueue.getContentField()[0]);
								map.put("patno", mQueue.getContentField()[1]);
								map.put("name", mQueue.getContentField()[2]);
								map.put("sex", mQueue.getContentField()[3]);
								map.put("dob", mQueue.getContentField()[4]);
								map.put("hkid", mQueue.getContentField()[5]);
								map.put("docName", mQueue.getContentField()[6]);
								map.put("orderDate", mQueue.getContentField()[7]);
								map.put("pkgCode", mQueue.getContentField()[8]);
								map.put("pkgName", mQueue.getContentField()[9]);
								String patcname = mQueue.getContentField()[10];

								map.put("SUBREPORT_DIR", CommonUtil.getReportDir());
								map.put("LogoImg", CommonUtil.getReportImg("Horizontal_billingual_HKAH_TW.jpg"));
								map.put("BreastImg", CommonUtil.getReportImg("breast.jpg"));
								map.put("userID", Factory.getInstance().getUserInfo().getUserID());
								map.put("userName", Factory.getInstance().getUserInfo().getUserName());
								map.put("newbarcode", newbarcode);

								PrintingUtil.print(
										"PHYORDERFORM",
										map,
										patcname,
										new String[]{ mQueue.getContentField()[8] },
										new String[]{"DPTCODE","DPTNAME","ITMCODE","ITMNAME","NUM","DSCCODE","DSCDESC"}
									);

							} else {
								System.out.println("No Physical Checkup Order Form to be print.");
							}
						}
			});
		}
	}
	
	private Image getImage_PatImage() {
		if (Image_PatImage == null) {
			Image_PatImage = new Image();
			Image_PatImage.addErrorHandler(new ErrorHandler() {
				@Override
				public void onError(ErrorEvent event) {
					Image_PatImage.setUrl(getDefaultNoImage());
				}
			});
			Image_PatImage.setPixelSize(225, 300);
		}
		return Image_PatImage;
	}

	protected void getSysParameterReady(String parcde, String sysparam) {
		if ("PRNWBLBL".equals(parcde)) {
			memWBLblType = sysparam;
			if (!YES_VALUE.equals(sysparam)) {
				memWBLblType = "NA";
			}
		}
	}

	private void getNodeValueFromStr(final String strXML, String RefField) {
		final String[] result = TextUtil.split(RefField, ",");

		for (int n = 0; n < result.length; n++) {
			final String xmlValue = getResponeData(strXML,result[n]);

			if ("HKID".equals(result[n])) {
				QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.PATIENT_IDNO_TXCODE,
						new String[] { xmlValue },
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							showPatient(mQueue);
						} else {
							appendAction();
							parse2dCode(strXML, result);
						}
					}
				});
			}
		}
	}

	private void parse2dCode(String strXML, String[] result) {
		String patName[] = null;
		for (int n=0; n<result.length; n++) {
			final String xmlValue = getResponeData(strXML,result[n]);
			final String xmlField = result[n];

			if ("HKID".equals(xmlField)) {
				getPJText_IDPassportNO().setText(xmlValue);
			} else if ("ENAME".equals(xmlField)) {
				patName = TextUtil.split(xmlValue, ",");
				getPJText_FamilyName().setText(patName[0]);
				getPJText_GivenName().setText(patName[1]);
			} else if ("DOB".equals(xmlField)) {
				getPJText_Birthday().setText(xmlValue);
			} else if ("SEX".equals(xmlField)) {
				getPJCombo_Sex().setText(xmlValue);
			}
		}
	}

	private String getResponeData(String respone, String key) {
		if (respone.indexOf("</"+key+">") > -1) {
			return respone.substring(respone.indexOf("<"+key+">")+("<"+key+">").length(),
					respone.indexOf("</"+key+">")).replaceAll("'", "''").trim();
		} else {
			return "";
		}
	}

	private boolean isNewGrt() {
		if (!memLimitAmt.equals(getINJText_LAmt().getText().trim())) return true;
		if (!memCoPayAmt.equals(getINJText_CPAmt().getText().trim())) return true;
		if (!memCvrEndDate.equals(getINJText_endDate().getText().trim())) return true;
		if (!memGrtAmt.equals(getINJText_FGAmt().getText().trim())) return true;
		if (!memGrtDate.equals(getINJText_FGDate().getText().trim())) return true;

		String cvrItems = EMPTY_VALUE;
		if (getINJCheckBox_Doctor().isSelected()) { cvrItems = "D"; }
		if (getINJCheckBox_Hspital().isSelected()) { cvrItems += "H"; }
		if (getINJCheckBox_Special().isSelected()) { cvrItems += "S"; }
		if (getINJCheckBox_Other().isSelected()) { cvrItems += "O"; }

		return !memCvrItem.equals(cvrItems);
	}

	private void searchPatientByChangeTab() {
		if (getActionType() == null
				&& getRTJText_PatientNumber().getText().trim().length() > 0
				&& !getRTJText_PatientNumber().getText().trim().equals(memOldPatNo)) {
			getRTJText_PatientNumber().onBlur();
			showPatient(getRTJText_PatientNumber().getText().trim());
		}
	}

	private void printArrivalLabel(String printer, Map<String, Map<String, String>> batchMap, String patNo,
			String noToBePrintStr, int noToBePrint, int printMedNo, boolean ticketLabel) {
		if (batchMap.size() > 5) {
			PrintingUtil.printBatch(
					printer,
					new String[] {
							"REGTICKETLABEL", "PBA",
							"REGSEARCHPRINTDOBWTHNO", "NurseNote", "MedChartLbl", "ALERTLABEL"
					},
					batchMap, null,
					new String[][] { //inparam
							new String[] {
									memRegID
							},//regticketlbl
							new String[] {
									patNo, getSysParameter("NOPATLABEL")
							},//pba
							new String[] {
									patNo, noToBePrintStr
							}, //REGSEARCHPRINTDOBWITHNO
							new String[] { },//NurseNote
							new String[] { },//MedChartLbl
							new String[] {
									Factory.getInstance().getUserInfo().getUserID(),
									getRTJText_PatientNumber().getText().trim()
							}//alert
					},
					new String[][] {
							new String[] {"patno", "ticketNo", "newticketno", "docname", "doccname",
									"patname", "patcname", "arrivalTime", "apptTime"}, //regticketlbl
									new String[] {"stecode", "patno", "patname"
									,"patcname", "patbdate", "patsex"
									,"docname", "regdate", "admdate", "regcat", "regcount", "ticketno","lblrmk"}, //PBA
									new String[] {"stecode", "patno", "patname", "patcname", "patbdate", "patsex","patmobile"}, //regsearchprtdobwithno
									new String[] { },//NurseNote
									new String[] { },//MedChartLbl
									new String[] {"patno", "sex", "patname", "dob", "alert"} //alert
					},
					null,null,null,null,
					new int[] {(ticketLabel?Integer.parseInt(getSysParameter("TicketLblN")):0),
							1, noToBePrint, Integer.parseInt(getSysParameter("NRNOTELBLN")), printMedNo, 1},
							null, null, true);
		} else {
			PrintingUtil.printBatch(printer,
					new String[] {"REGTICKETLABEL", "PBA",
					"REGSEARCHPRINTDOBWTHNO", "NurseNote", "ALERTLABEL"},
					batchMap,null,
					new String[][] { //inparam
							new String[] {memRegID},//regticketlbl
							new String[] {patNo, getSysParameter("NOPATLABEL")},//pba
							new String[] {patNo, noToBePrintStr}, //REGSEARCHPRINTDOBWITHNO
							new String[] { },//NurseNote
							new String[] {
									Factory.getInstance().getUserInfo().getUserID(),
									getRTJText_PatientNumber().getText().trim()}//alert
			},
			new String[][] {
							new String[] {"patno", "ticketNo", "newticketno", "docname", "doccname",
							"patname", "patcname", "arrivalTime", "apptTime"}, //regticketlbl
							new String[] {"stecode", "patno", "patname"
							,"patcname", "patbdate", "patsex"
							,"docname", "regdate", "admdate", "regcat", "regcount", "ticketno","lblrmk"}, //PBA
							new String[] {"stecode", "patno", "patname", "patcname", "patbdate", "patsex","patmobile"}, //regsearchprtdobwithno
							new String[] { },//NurseNote
							new String[] {"patno", "sex", "patname", "dob", "alert"} //alert
			},
			null,null,null,null,
			new int[] {(ticketLabel?Integer.parseInt(getSysParameter("TicketLblN")):0),
					1, 1, Integer.parseInt(getSysParameter("NRNOTELBLN")),1},
					null, null, true);
		}
	}

	private void checkTodayApp(final String patno) {
		QueryUtil.executeMasterBrowse(getUserInfo(), "SHOWTODAYAPP",
				new String[] { patno },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					final String patNo = mQueue.getContentField()[5];
					if (mQueue.getContentField().length > 0) {
						getDlgTodayAppAlert().showDialog(patNo);
					}
				}
			}
		});
	}

	/***************************************************************************
	 * Dialog Methods
	 **************************************************************************/
	private DlgMedicalRecord getDlgMedicalRecord() {
		if (dlgMedicalRecord == null) {
			dlgMedicalRecord = new DlgMedicalRecord(getMainFrame());
		}
		return dlgMedicalRecord;
	}

	private DlgPrintPatietCard getDlgPrintPatientCard() {
		if (dlgPrintPatientCard == null) {
			dlgPrintPatientCard = new DlgPrintPatietCard(getMainFrame());
		}
		return dlgPrintPatientCard;
	}

	private DlgPrtCallChart getDlgPrtCallChart() {
		if (dlgPrtCallChart == null) {
			dlgPrtCallChart = new DlgPrtCallChart(getMainFrame());
		}
		return dlgPrtCallChart;
	}

	private DlgARCardRemark getDlgARCardRemark() {
		if (dlgARCardRemark == null) {
			dlgARCardRemark = new DlgARCardRemark(getMainFrame())  {
				@Override
				public void post(String source, String actCode, String actId) {
					getINJText_ARCardType().setText(actCode);
					memActID = actId;
				}
			};
		}
		return dlgARCardRemark;
	}

	private DlgARCardTypeSel getDlgARCardTypeSel() {
		if (dlgARCardTypeSel == null) {
			dlgARCardTypeSel = new DlgARCardTypeSel(getMainFrame())  {
				@Override
				public void post(String ArcCode, String ARCardType, String ARCardName,
									String ARCardDesc, String ARCardCode) {
					if (ARCardType != null && ARCardType.trim().length() > 0) {
						memActID = ARCardType;
					} else {
						memActID = null;
					}
					if (memActID != null && memActID.length() > 0) {
						getRTJLabel_PATName().focus();
						getDlgARCardRemark().showDialog(null, ArcCode, memActID, getCurrentRegistrationType(), true, true);
						getRTJLabel_PATName().focus();
					}
				}
			};
		}
		return dlgARCardTypeSel;
	}

	private DlgSlipList getDlgSlipList() {
		if (DlgSlipList == null) {
			DlgSlipList = new DlgSlipList(getMainFrame()) {
				@Override
				public void post(String newSlipNo) {
					if (newSlipNo != null && newSlipNo.length() > 0) {
						getDlgSlipList().dispose();
						showTransactions(newSlipNo);
					}
				}
			};
		}
		return DlgSlipList;
	}

	private DlgDoctorInstruction getDlgDoctorInstruction() {
		if (dlgDoctorInstruction == null) {
			dlgDoctorInstruction = new DlgDoctorInstruction(getMainFrame()) {
				@Override
				public void doOkAction() {
					addMedicalRecordAfterInstruction();
					dispose();
				}
			};
			dlgDoctorInstruction.setClosable(false);
		}
		return dlgDoctorInstruction;
	}

	private DlgPrintAddress getDlgPrintAddress() {
		if (dlgPrintAddress == null) {
			dlgPrintAddress = new DlgPrintAddress(getMainFrame());
		}
		return dlgPrintAddress;
	}

	private DlgNoOfLblToBePrt getDlgNoOfLblToBePrtInp() {
		if (dlgNoOfLblToBePrtInp == null) {
			dlgNoOfLblToBePrtInp = new DlgNoOfLblToBePrt(getMainFrame(), true) {
				@Override
				protected void post(String patNo) {}
			};
		}
		return dlgNoOfLblToBePrtInp;
	}

	private DlgNoOfLblToBePrt getDlgNoOfLblToBePrtOutp() {
		if (dlgNoOfLblToBePrtOutp == null) {
			dlgNoOfLblToBePrtOutp = new DlgNoOfLblToBePrt(getMainFrame(), false) {
				@Override
				protected void post(String patNo) {}

				@Override
				protected void label4Outpatient(final int noToBePrint) {
					QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] { "medrechdr", "max(mrhvollab)", "patno='" + memPatNo + "' AND mrhsts = 'N'" },
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							final String noToBePrintStr = String.valueOf(noToBePrint);
							//printLabels(value);
							final String patNo = getRTJText_PatientNumber().getText().trim();
							final String tempChkDigit = ("YES".equals(getSysParameter("ChkDigit"))) ? PrintingUtil.generateCheckDigit(patNo.trim()).toString()+"#" : "#";
							final String max_mrhvollab = mQueue.getContentField()[0];

							QueryUtil.executeTx(getUserInfo(), "RPT_PBA",
									new String[] { patNo, getSysParameter("NOPATLABEL") },
									new MessageQueueCallBack() {
										@Override
										public void onPostSuccess(MessageQueue mq) {
											Map<String,String> mapPba = new HashMap<String,String>();
											mapPba.put("SUBREPORT_DIR", CommonUtil.getReportDir());
											mapPba.put("number", noToBePrintStr);
											mapPba.put("outPatType", getRTJText_OutPatientType().getText());
											mapPba.put("newbarcode", patNo + tempChkDigit);
											mapPba.put("TicketGenMth", getSysParameter("TicketGen"));
											mapPba.put("isasterisk",
													String.valueOf("YES".equals(getMainFrame().getSysParameter("Chk*"))));
											mapPba.put("stecode", mq.getContentField()[0]);
											mapPba.put("patno", mq.getContentField()[1]);
											mapPba.put("patname", mq.getContentField()[2]);
											mapPba.put("ppatcname", mq.getContentField()[3]);
											mapPba.put("patbdate", mq.getContentField()[4]);
											mapPba.put("patsex", mq.getContentField()[5]);
											mapPba.put("pdocname", mq.getContentField()[6]);
											mapPba.put("pregdate", mq.getContentField()[7]);
											mapPba.put("padmdate", mq.getContentField()[8]);
											mapPba.put("pregcat", mq.getContentField()[9]);
											mapPba.put("regcount", mq.getContentField()[10]);
											mapPba.put("pticketno", mq.getContentField()[11]);
											mapPba.put("plblrmk", mq.getContentField()[12]);

											Map<String,String> mapGeneral = new HashMap<String,String>();
											mapGeneral.put("SUBREPORT_DIR", CommonUtil.getReportDir());
											mapGeneral.put("number", noToBePrintStr);
											mapGeneral.put("outPatType", getRTJText_OutPatientType().getText());
											mapGeneral.put("newbarcode", patNo + tempChkDigit);
											mapGeneral.put("TicketGenMth", getSysParameter("TicketGen"));
											mapGeneral.put("isasterisk",
													String.valueOf("YES".equals(getMainFrame().getSysParameter("Chk*"))));

											Map<String,String> mapTicket = new HashMap<String,String>();
											mapTicket.put("TicketLblN", getSysParameter("TicketLblN"));
											mapTicket.put("newbarcode",patNo+tempChkDigit);
											mapTicket.put("TicketGenMth",getSysParameter("TicketGen"));

											Map<String,String> mapPatient = new HashMap<String,String>();
											mapPatient.put("isasterisk",
													String.valueOf("YES".equals(getMainFrame().getSysParameter("Chk*"))));
											mapPatient.put("newbarcode",patNo+tempChkDigit);

											Map<String, String> mapNurseNote = new HashMap<String, String>();
											mapNurseNote.put("patno", patNo);

											Map<String,Map<String,String>> mapBatchMap =
												new HashMap<String,Map<String,String>>();
											mapBatchMap.put("1", mapTicket); //REGTICKETLABEL
											mapBatchMap.put("2", mapPba); //PBA
											mapBatchMap.put("3", mapPatient); //REGSEARCHPRINTDOBWTHNO
											mapBatchMap.put("4", mapNurseNote); //NurseNote
											mapBatchMap.put("5", mapGeneral); //ALERTLABEL

											int printMedNo = 0;

											if (max_mrhvollab.length() == 0 || max_mrhvollab == null) {
												Factory.getInstance().addErrorMessage("Print Medical Label Fail: Patient doesn't have any Medical Volume Label!");
											} else {
												if (addNewPatient && (memRegID_L == null || memRegID_L.length() == 0)) {
														//&& (memRegID_C == null || memRegID_C.length() == 0)) {
													try {
														printMedNo = Integer.parseInt(getSysParameter("MedPrnNo"));
													} catch (Exception e) { }

													if (printMedNo > 0) {
														Map<String,String> mapMedical = new HashMap<String,String>();
														boolean isasterisk = "YES".equals(getSysParameter("Chk*"));
														boolean isChkDigit = "YES".equals(getSysParameter("ChkDigit"));
														String tmpChkDigit = "#";

														if (isChkDigit) {
															tmpChkDigit = PrintingUtil.generateCheckDigit("-C/"+memPatNo + "/" + max_mrhvollab).toString()+"#";
														}
														mapMedical.put("recordID",memPatNo + "/" + max_mrhvollab+tmpChkDigit);
														//mapMedical.put("ChkDigit",tmpChkDigit);
														mapMedical.put("isasterisk",getSysParameter("Chk*"));
														mapMedical.put("isChkDigit",getSysParameter("ChkDigit"));
														mapBatchMap.put("6", mapMedical);
													}
												}
											}

											if (YES_VALUE.equals(Factory.getInstance().getSysParameter("REGLBLMULI"))) {
												if (getAutoPrint()) {
													//print ticket only
													PrintingUtil.print(getSysParameter("PRTRLBL"), "REGTICKETLABEL",
															mapTicket, null,
															new String[] {
																	memRegID
															},
															new String[] {
																	"patno", "ticketNo", "newticketno", "docname", "doccname",
																	"patname", "patcname", "arrivalTime", "apptTime"
															},
															Integer.parseInt(getSysParameter("TicketLblN")));
												} else {
													//print arrival label
													String printer = getPrintToCounter().isSelected()?getSysParameter("PRTRLBL"):
																		(getPrintToMR().isSelected()?getSysParameter("ARIVLBLMR"):
																				getSysParameter("PRTRLBL"));
													printArrivalLabel(printer, mapBatchMap, patNo, noToBePrintStr, noToBePrint, printMedNo, getIsPrintTicketLabel().isSelected());
												}
												return;
											}

											if (getIsPrintTicketLabel().isSelected()) {
												PrintingUtil.print(getSysParameter("PRTRLBL"), "REGTICKETLABEL",
														mapTicket, null,
														new String[] {
																memRegID
														},
														new String[] {
																"patno", "ticketNo", "newticketno", "docname", "doccname",
																"patname", "patcname", "arrivalTime", "apptTime"
														},
														Integer.parseInt(getSysParameter("TicketLblN"))==0?1:Integer.parseInt(getSysParameter("TicketLblN")));
											} else {
												//HKAH, AMC
												printArrivalLabel(getSysParameter("PRTRLBL"), mapBatchMap, patNo, noToBePrintStr, noToBePrint, printMedNo, true);
											}

										}
							});
						}
					});
				}

				@Override
				protected void doCancelAction() {
					label4Outpatient(0);
					dispose();
				}
			};
		}
		return dlgNoOfLblToBePrtOutp;
	}

	private DlgNoOfLabel getDlgPrintPatientLabel() {
		if (dlgPrintPatientLabel == null) {
/*
			int noOfPatLabel = 0;
			try {
				noOfPatLabel = Integer.parseInt(getSysParameter("NOPATLABEL"));
			} catch (Exception e) {
			}
*/

			int maxNoOfLabel = 0;
			try {
				maxNoOfLabel = Integer.parseInt(getSysParameter("MaxLabel"));
			} catch(Exception e) {
			}

			dlgPrintPatientLabel = new DlgNoOfLabel(getMainFrame(), maxNoOfLabel) {
				@Override
				public void showDialog() {
					if (Integer.parseInt(getSysParameter("NOPATLABEL")) > 0) {
						super.showDialog();
					} else {
						Factory.getInstance().addSystemMessage("No Label will be printed.<br/>Please set SYSPARAM: NOPATLABEL");
					}
				}

				@Override
				protected void doOkAction() {
					final String patNo = getRTJText_PatientNumber().getText().trim();
					final boolean isasterisk = "YES".equals(getSysParameter("Chk*"));
					final boolean isChkDigit = "YES".equals(getSysParameter("ChkDigit"));
					String tempChkDigit = "#";
					if (isChkDigit) {
						if (patNo != null
							&& !"".equals(patNo.trim())) {
							tempChkDigit = PrintingUtil.generateCheckDigit(patNo.trim()).toString()+"#";
						}
					}
					final String checkDigit = tempChkDigit;
					if (Integer.parseInt(getSysParameter("NOPATLABEL")) > 0 &&
							Integer.parseInt(getNoToBePrinted().getText()) > 0) {
						if (Integer.parseInt(getNoToBePrinted().getText()) > getMaxNoOfLabel()) {
							Factory.getInstance().addErrorMessage("It is larger than "+ String.valueOf(getMaxNoOfLabel())+"!");
							return;
						} else {
							QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.REGSEARCHPRINTDOB,
								new String[] { patNo },
								new MessageQueueCallBack() {
									@Override
									public void onPostSuccess(MessageQueue mq) {
										HashMap<String, String> map = new HashMap<String, String>();
										map.put("stecode", mq.getContentField()[0] + (isasterisk ? "*" : ""));
										map.put("patno", mq.getContentField()[1]);
										map.put("name", mq.getContentField()[2]);
										map.put("patcname", mq.getContentField()[3]);
										map.put("patsex", mq.getContentField()[5]);
										map.put("patno1", mq.getContentField()[1] + (isChkDigit ? checkDigit : "#"));
										map.put("patdob",mq.getContentField()[4]);

										StringBuffer mapKey = new StringBuffer();
										StringBuffer mapValue = new StringBuffer();
										String patcname = null;
										for (Map.Entry<String, String> pairs : map.entrySet()) {
											if (!"patcname".equals(pairs.getKey())) {
												mapKey.append(pairs.getKey()+"<FIELD/>");
												mapValue.append(pairs.getValue()+"<FIELD/>");
											} else {
												patcname = pairs.getValue();
											}
										}

										System.err.println("[stecode]:"+mq.getContentField()[0] + (isasterisk ? "*" : "")+";[patno]:"+mq.getContentField()[1]+";[name]:"+mq.getContentField()[2]+";[patcname]:"+mq.getContentField()[3]);
										PrintingUtil.print(getSysParameter("PRTRLBL"),
												"RegPatientLabel",
												map, patcname,
												Integer.parseInt(getNoToBePrinted().getText()));
										}
								});
						}
					}
					dispose();
				}
			};
		}
		return dlgPrintPatientLabel;
	}

	private DlgEhrPmiDupl getDlgEhrPmiDupl(final String actionType) {
		if (dlgEhrPmiDupl == null) {
			dlgEhrPmiDupl = new DlgEhrPmiDupl(getMainFrame(), Factory.getInstance().getSysParameter("EHRPMICKPD"))  {
				@Override
				public void post() {
					System.err.println("post Patient");
					// save
					callActionValidationReady(actionType, true);
				}
			};
		}
		return dlgEhrPmiDupl;
	}

	private DlgPatientDuplicate getDuplicateDialog(final String actionType) {
		if (duplicateDialog == null) {
			duplicateDialog = new DlgPatientDuplicate(getMainFrame()) {
				@Override
				public void continueAction() {
					//callActionValidationReady(QueryUtil.ACTION_APPEND, true);
					callActionValidationReady(actionType, true);
				}
			};
		}
		return duplicateDialog;
	}

	private DlgTodayAppAlert getDlgTodayAppAlert() {
		if (dlgTodayAppAlert == null) {
			dlgTodayAppAlert = new DlgTodayAppAlert(getMainFrame())  {
				@Override
				public void post(String source, String actCode, String actId) {
//					getINJText_ARCardType().setText(actCode);
//					memActID = actId;
				}
			};
		}
		return dlgTodayAppAlert;
	}

	private DlgBookingList getDlgBookingList() {
		if (dlgBookingList == null) {
			dlgBookingList = new DlgBookingList(getMainFrame());
		}
		return dlgBookingList;
	}

	private DlgTicketNumber getDlgTicketNumber() {
		if (dlgTicketNumber == null) {
			dlgTicketNumber = new DlgTicketNumber(getMainFrame())  {
				@Override
				public void post(String actionType, boolean returnValue, String tno) {
					if (returnValue) {
						ticketNo = tno;
					} else {
						ticketNo = null;
					}
					getMainFrame().setLoading(true);
					actionValidationReady(actionType, returnValue);
				}
			};
		}
		return dlgTicketNumber;
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/* >>> getter methods for init the Component start from here ================================== <<< */
	@Override
	protected BasePanel getActionPanel() {
		if (actionPanel == null) {
			actionPanel = new BasePanel();
			actionPanel.setSize(810, 580);
			actionPanel.add(getGeneralPanel());
		}
		return actionPanel;
	}

	public BasePanel getGeneralPanel() {
		if (generalPanel == null) {
			generalPanel = new BasePanel();
			generalPanel.setLayout(null);
			generalPanel.setBounds(0, 0, 810, 580);
			generalPanel.add(getRTPanel(), null);
			generalPanel.add(getRBTPanel(), null);
			generalPanel.add(getMasterTabButton(), null);
			generalPanel.add(getRegTabButton(), null);
			generalPanel.add(getAddInfoTabButton(), null);
			generalPanel.add(getEhrTabButton(), null);
			generalPanel.add(getConsentTabButton(), null);
		}
		return generalPanel;
	}

	public BasePanel getRTPanel() {
		if (RTPanel == null) {
			RTPanel = new BasePanel();
			RTPanel.setBorders(true);
			RTPanel.setBounds(5, 5, 800, 30);
			RTPanel.add(getRTJLabel_PATNO(), null);
			RTPanel.add(getRTJText_PatientNumber(), null);
			RTPanel.add(getRTJLabel_PATName(), null);
			RTPanel.add(getRTJText_PatientName(), null);
			RTPanel.add(getRTJText_PATCName(), null);
			RTPanel.add(getRTJLabel_Sex(), null);
			RTPanel.add(getRTJText_Sex(), null);
			RTPanel.add(getRTJLabel_DentalPatientNo(), null);
			RTPanel.add(getRTJText_DentalPatientNo(), null);
		}
		return RTPanel;
	}

	private ButtonBase getRTJLabel_PATNO() {
		if (RTJLabel_PATNO == null) {
			RTJLabel_PATNO = new ButtonBase() {
				public void onClick() {
					final String clientIP = CommonUtil.getComputerIP();
					if (callIDScanner(clientIP)) {
						MessageBoxBase.confirm(MSG_PBA_SYSTEM,
								"Ready to retrieve ID Scanner info?",
								new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.PATIENT_IDSCANNER,
											new String[] { clientIP },
											new MessageQueueCallBack() {
										@Override
										public void onPostSuccess(MessageQueue mQueue) {
											if (mQueue.success()) {
												getPJCombo_DocType().setText(mQueue.getContentField()[0]);
												getPJText_IDPassportNO().setText(mQueue.getContentField()[1]);
												getPJText_GivenName().setText(mQueue.getContentField()[2]);
												getPJText_FamilyName().setText(mQueue.getContentField()[3]);
												getPJCombo_Sex().setText(mQueue.getContentField()[4]);
												getPJText_Birthday().setText(mQueue.getContentField()[5]);
											} else {
												Factory.getInstance().addErrorMessage("No info is retrieved.");
											}
										}
									});
								}
							}
						});
					}
				}

				private native boolean callIDScanner(String clientIP) /*-{
					var newUrl = window.location.href;
					var index = newUrl.indexOf('/HKAH');
					if (index > 0) {
						index = newUrl.indexOf('/', index + 1);
						if (index > 0) {
							window.location.href = "NHSClientIDScanner:" + clientIP + ":" + newUrl.substring(0, index) + "/hkahnhs/IDScanner";
						}
					} else {
						index = newUrl.indexOf('/', 9);
						if (index > 0) {
							window.location.href = "NHSClientIDScanner:" + clientIP + ":" + newUrl.substring(0, index) + "/hkahnhs/IDScanner";
						}
					}
					return true;
				}-*/;
			};
			RTJLabel_PATNO.setText("Patient Number");
			RTJLabel_PATNO.setBounds(5, 3, 90, 20);
//			RTJLabel_PATNO.setOptionalLabel();
		}
		return RTJLabel_PATNO;
	}

	private TextPatientNoSearch getRTJText_PatientNumber() {
		if (RTJText_PatientNumber == null) {
			RTJText_PatientNumber =
				new TextPatientNoSearch(
					!isDisableFunction("ToolBarSearch", "regPatReg"),
					true,
					true, //!isDisableFunction("btnAlert", "regPatReg"),
					!isDisableFunction("ToolBarSearch", "regPatReg")) {
				@Override
				public void checkTriggerBySearchKey() {
					//setSearchKey
					if (isFocusOwner()) {
						if (getText().trim().length() == 0) {
							showSearchPanel();
						} else {
							checkMergePatient(true);
						}
					}
				}

				@Override
				protected void checkPatient(boolean isExistPatient, boolean bySearchKey) {
					boolean isAppendFromBk = (memFromBk || memPreBooking) && (memPatNo == null || memPatNo.length() == 0);
					memPcyCode = EMPTY_VALUE;
					memArcCode = EMPTY_VALUE;

					if (isExistPatient) {
						if (isAppend()) {
							if (isAppendFromBk) {
								setActionTypeRegistration(null);
								memPatNo = RTJText_PatientNumber.getText();
								showPatient(memPatNo);
								getRTJText_PatientNumber().checkPatientAlert();
							} else {
								if (getRBTPanel().getSelectedIndex() == 0 && !getRTJText_PatientNumber().isReadOnly()) {
									Factory.getInstance().addErrorMessage(MSG_PATIENTNO_EXIST + getRBTPanel().getSelectedIndex(), RTJText_PatientNumber);
									RTJText_PatientNumber.resetText();
								}
							}
						} else {
							super.checkPatient(isExistPatient, bySearchKey);
						}
						getDlgBookingList().showDialog(RTJText_PatientNumber.getText(),(memPreBooking?memPBPID:""),((memBkgID != null && memBkgID.length() > 0)?memBkgID:""));
					} else {
						if (!isAppend()) {
							RTJText_PatientNumber.resetText();
							if (bySearchKey) {
								showSearchPanel();
							} else {
								Factory.getInstance().addErrorMessage(MSG_INVALID_PATIENTNO, RTJText_PatientNumber);
							}
						} else if (getPJText_IDPassportNO().isEditable()) {
							getPJText_IDPassportNO().requestFocus();
						}
					}
				}

				@Override
				public void onBlurPost() {
//					if (!isDisableFunction("ToolBarSearch", "regPatReg")) {
						if (isPatientFlag() && !RTJText_PatientNumber.isEmpty()) {
							if (RTJText_PatientNumber.getText().length() > 6
									&& RTJText_PatientNumber.getText().indexOf("<HKID>") > -1) {
								getNodeValueFromStr(RTJText_PatientNumber.getText(),"HKID,ENAME,SEX,DOB");
							} else {
								searchPatient();
								// twah ONLY
								if (memBkgID==null && "TWAH".equals(getUserInfo().getSiteCode()) &&
										REG_URGENTCARE.equals(getRegistrationMode()) && saving == false){
									checkTodayApp(RTJText_PatientNumber.getText());
									System.err.println("[checkTodayApp]"+RTJText_PatientNumber.getText());
								}
							}
						} else {
//							getRTJText_PatientNumber().focus();
						}
//					}
				}

				@Override
				public void onPressed() {
					if (!isRegFlag()) {
						if (currentPatNo != null && currentPatNo.length() > 0) {
							// clear field
							String oldActionType = getActionType();
							clearAction();
							setActionType(oldActionType);
							memPcyCode = EMPTY_VALUE;
							memArcCode = EMPTY_VALUE;
						}
					}
				}

				@Override
				protected boolean isSkipCheckPatient() {
					return !isAppend();
				}

				@Override
				protected void actionAfterOK() {
					// for child class implement
					onBlur();
				}

				@Override
				protected void checkPatientAlertAction(String pcyCode, String arcCode) {
					memPcyCode = pcyCode;
					memArcCode = arcCode;
				}
			};
			RTJText_PatientNumber.setBounds(100, 3, 80, 20);
		}
		return RTJText_PatientNumber;
	}

	private LabelSmallBase getRTJLabel_PATName() {
		if (RTJLabel_PATName == null) {
			RTJLabel_PATName = new LabelSmallBase();
			RTJLabel_PATName.setText("Patient Name");
			RTJLabel_PATName.setBounds(200, 3, 95, 20);
		}
		return RTJLabel_PATName;
	}

	private TextReadOnly getRTJText_PatientName() {
		if (RTJText_PatientName == null) {
			RTJText_PatientName = new TextReadOnly();
			RTJText_PatientName.setBounds(285, 3, 180, 20);
		}
		return RTJText_PatientName;
	}

	private TextReadOnly getRTJText_PATCName() {
		if (RTJText_PATCName == null) {
			RTJText_PATCName = new TextReadOnly();
			RTJText_PATCName.setBounds(465, 3, 80, 20);
		}
		return RTJText_PATCName;
	}

	private LabelSmallBase getRTJLabel_Sex() {
		if (RTJLabel_Sex == null) {
			RTJLabel_Sex = new LabelSmallBase();
			RTJLabel_Sex.setText("Sex");
			RTJLabel_Sex.setBounds(570, 3, 50, 20);
		}
		return RTJLabel_Sex;
	}

	private TextReadOnly getRTJText_Sex() {
		if (RTJText_Sex == null) {
			RTJText_Sex = new TextReadOnly();
			RTJText_Sex.setBounds(605, 3, 50, 20);
		}
		return RTJText_Sex;
	}

	private LabelSmallBase getRTJLabel_DentalPatientNo() {
		if (RTJLabel_DentalPatientNo == null) {
			RTJLabel_DentalPatientNo = new LabelSmallBase();
			RTJLabel_DentalPatientNo.setText("Dent #");
			RTJLabel_DentalPatientNo.setBounds(662, 3, 50, 20);
		}
		return RTJLabel_DentalPatientNo;
	}

	private TextString getRTJText_DentalPatientNo() {
		if (RTJText_DentalPatientNo == null) {
			RTJText_DentalPatientNo = new TextString();
			RTJText_DentalPatientNo.setBounds(705, 3, 80, 20);
		}
		return RTJText_DentalPatientNo;
	}

	public TabbedPaneBase getRBTPanel() {
		if (RBTPanel == null) {
			RBTPanel = new TabbedPaneBase() {
				public void onStateChange() {
					getMainFrame().setLoading(true);
					int selectedIndex = RBTPanel.getSelectedIndex();

					if (selectedIndex == 3) {
						String errMsg = null;
						if (!"Y".equals(Factory.getInstance().getSysParameter("EHRENABLE"))) {
							errMsg = "eHR PMI facility development is in progress.";
						} else if (Factory.getInstance().isDisableFunction("ehrView", "regPatReg")) {
							errMsg = "You cannot access eHR PMI.";
						}

						if (errMsg != null) {
							Factory.getInstance().addErrorMessage(errMsg);
							getMainFrame().setLoading(false);
							RBTPanel.setSelectedIndexWithoutStateChange(rtvOldTabIndex);
							return;
						}
					}

					if (selectedIndex > 0 && isDisableFunction("TABPAGE", "regPatReg")) {
						getMainFrame().setLoading(false);
						RBTPanel.setSelectedIndexWithoutStateChange(rtvOldTabIndex);
						return;
					}

					if ((QueryUtil.ACTION_APPEND.equals(getActionType(rtvOldTabIndex))
							|| QueryUtil.ACTION_MODIFY.equals(getActionType(rtvOldTabIndex)))
							&& rtvOldTabIndex != selectedIndex) {
						getMainFrame().setLoading(false);
						if (rtvOldTabIndex == 1) {
							Factory.getInstance().addErrorMessage(MSG_SAVE_REG);
						}
						RBTPanel.setSelectedIndexWithoutStateChange(rtvOldTabIndex);
						return;
					}

					if (selectedIndex > 0 && getRTJText_PatientNumber().isEmpty()) {
						getMainFrame().setLoading(false);
						RBTPanel.setSelectedIndexWithoutStateChange(0);
						return;
					}

					if (selectedIndex == 1 && REG_STS_CANCEL.equals(memRegStatus)) {
						getMainFrame().setLoading(false);
						Factory.getInstance().addErrorMessage("The Registration has been cancelled.");
						RBTPanel.setSelectedIndexWithoutStateChange(rtvOldTabIndex);
						return;
					}

					if (selectedIndex == 1) {
						getINJCombo_ARC().setText(currentArcCode);
					} else if (isTabFTOCC && (!isTabConsent && selectedIndex == 4) || (isTabConsent && selectedIndex == 5)) {
						getMainFrame().setLoading(false);
						RBTPanel.setSelectedIndexWithoutStateChange(rtvOldTabIndex);
						if (memRegID != null && memRegID.length() > 0) {
							openNewWindow(null, getFTOCCUrl() + memRegID + FTOCC_URL_SUFFIX_USER + getUserInfo().getUserName() + "(" + getUserInfo().getSsoUserID() + ")", null, true);
						} else {
							Factory.getInstance().addErrorMessage("The Registration must be done first.");
						}
					} else if ((isTabApp && selectedIndex == 6)){
						getMainFrame().setLoading(false);
						RBTPanel.setSelectedIndexWithoutStateChange(rtvOldTabIndex);
						openNewWindow(null, getAppAdminUrl()
								+getRTJText_PatientNumber().getText(), null, true);

					}

					enableButton();
					defaultFocus();

					rtvOldTabIndex = selectedIndex;
					getMainFrame().setLoading(false);

					if (selectedIndex == 3) {
						// redraw table scroll bar
						getEhrEnrollHistTable().setListTableContent(ConstantsTx.EHR_PMIHIST_TXCODE,
								new String[]{"PMIHIST", memPatNo});
					}
				}

				@Override
				public void setSelectedIndexWithoutStateChange(int index) {
					super.setSelectedIndexWithoutStateChange(index);
					getDefaultFocusComponent().focus();
				}
			};
			RBTPanel.setBounds(5, 40, 800, 545);
			RBTPanel.addTab("<u>M</u>aster", getMasterPanel());
			RBTPanel.addTab("<u>R</u>egistration", getRegPanel());
			RBTPanel.addTab("Additional <u>I</u>nfo", getAdditInfoPanel());
			RBTPanel.addTab("<u>e</u>HR", getEhrPanel());
			if (!isDisableFunction("tabConsent", "regPatReg")) {
				RBTPanel.addTab("PBO C<u>o</u>nsent/Ins Card/AR", getConsentPanel());
			}
			if (!isDisableFunction("tabFTOCC", "regPatReg")) {
				RBTPanel.addTab("<u>F</u>TOCC", getFTOCC());
			}
			if (!isDisableFunction("tabAppUser", "regPatReg")) {
				RBTPanel.addTab("<u>A</u>pp User/Linkup", getAppAdmin());
			}
		}
		return RBTPanel;
	}

	private ButtonBase getMasterTabButton() {
		if (masterTabBtn == null) {
			masterTabBtn = new ButtonBase() {
				public void onClick() {
					searchPatientByChangeTab();
					getRBTPanel().setSelectedIndex(0);
					defaultFocus();
				}
			};
			masterTabBtn.setVisible(false);
			masterTabBtn.setHotkey('M');
		}
		return masterTabBtn;
	}

	public BasePanel getMasterPanel() {
		if (MasterPanel == null) {
			MasterPanel = new BasePanel();
			MasterPanel.setBounds(0, 0, 800, 530);
			MasterPanel.add(getPersonalPanel(), null);
			MasterPanel.add(getAddressPanel(), null);
			MasterPanel.add(getRelativePanel(), null);
		}
		return MasterPanel;
	}

	public FieldSetBase getPersonalPanel() {
		if (PersonalPanel == null) {
			PersonalPanel = new FieldSetBase();
			PersonalPanel.setBounds(5, 0, 427, 412);
			PersonalPanel.setHeading("Personal Information");
			PersonalPanel.add(getPJLabel_IDPassportNO(), null);
			PersonalPanel.add(getPJText_IDPassportNO(), null);
			PersonalPanel.add(getAJLabel_IDCountry(), null);
			PersonalPanel.add(getAJCombo_IDCountry(), null);
			PersonalPanel.add(getPJLabel_DocType(), null);
			PersonalPanel.add(getPJCombo_DocType(), null);

			PersonalPanel.add(getPJLabel_IDPassportNO_S1(), null);
			PersonalPanel.add(getPJText_IDPassportNO_S1(), null);
			PersonalPanel.add(getPJLabel_DocType_S1(), null);
			PersonalPanel.add(getPJCombo_DocType_S1(), null);
			PersonalPanel.add(getAJLabel_IDCountry_S1(), null);
			PersonalPanel.add(getAJCombo_IDCountry_S1(), null);

			PersonalPanel.add(getPJLabel_IDPassportNO_S2(), null);
			PersonalPanel.add(getPJText_IDPassportNO_S2(), null);
			PersonalPanel.add(getPJLabel_DocType_S2(), null);
			PersonalPanel.add(getPJCombo_DocType_S2(), null);
			PersonalPanel.add(getAJLabel_IDCountry_S2(), null);
			PersonalPanel.add(getAJCombo_IDCountry_S2(), null);

			PersonalPanel.add(getPJLabel_FamilyName(), null);
			PersonalPanel.add(getPJText_FamilyName(), null);
			if (!YES_VALUE.equals(getSysParameter("PatIDConty"))) {
				PersonalPanel.add(getPJLabel_Title(), null);
				PersonalPanel.add(getPJCombo_Title(), null);
			}

			PersonalPanel.add(getPJLabel_GivenName(), null);
			PersonalPanel.add(getPJText_GivenName(), null);
			PersonalPanel.add(getPJLabel_ChineseName(), null);
			PersonalPanel.add(getPJText_ChineseName(), null);
			PersonalPanel.add(getPJLabel_MSTS(), null);
			PersonalPanel.add(getPJCombo_MSTS(), null);
			if (YES_VALUE.equals(getSysParameter("PatIDConty"))) {
				PersonalPanel.add(getPJLabel_Title(), null);
				PersonalPanel.add(getPJCombo_Title(), null);
			}
			PersonalPanel.add(getPJLabel_MaidenName(), null);
			PersonalPanel.add(getPJText_MaidenName(), null);
			PersonalPanel.add(getPJLabel_Race(), null);
			PersonalPanel.add(getPJCombo_Race(), null);
			PersonalPanel.add(getPJLabel_Birthday(), null);
			PersonalPanel.add(getPJText_Birthday(), null);
			PersonalPanel.add(getPJLabel_Age(), null);
			PersonalPanel.add(getPJText_Age(), null);
			PersonalPanel.add(getPJLabel_BirthOrdSPG(), null);
			PersonalPanel.add(getPJCombo_BirthOrdSPG(), null);
			PersonalPanel.add(getPJLabel_MotherLanguage(), null);
			PersonalPanel.add(getPJCombo_MotherLanguage(), null);
			PersonalPanel.add(getPJLabel_Sex(), null);
			PersonalPanel.add(getPJCombo_Sex(), null);
			PersonalPanel.add(getPJLabel_EduLvl(), null);
			PersonalPanel.add(getPJCombo_EduLvl(), null);
			PersonalPanel.add(getPJLabel_Death(), null);
			PersonalPanel.add(getPJText_Death(), null);
			PersonalPanel.add(getPJLabel_Religious(), null);
			PersonalPanel.add(getPJCombo_Religious(), null);
			PersonalPanel.add(getPJButton_UpdateDeathDate(), null);
			PersonalPanel.add(getPJLabel_Occupation(), null);
			PersonalPanel.add(getPJText_Occupation(), null);
			PersonalPanel.add(getPJLabel_MiscRemark(), null);
			PersonalPanel.add(getPJText_MiscRemark(), null);
			PersonalPanel.add(getPJLabel_MotherRecord(), null);
			PersonalPanel.add(getPJText_MotherRecord(), null);
			PersonalPanel.add(getPJLabel_NewBorn(), null);
			PersonalPanel.add(getPJCheckBox_NewBorn(), null);
			PersonalPanel.add(getPJLabel_MRRemark(), null);
			PersonalPanel.add(getPJText_MRRemark(), null);
			PersonalPanel.add(getPJLabel_MarketingSource(), null);
			PersonalPanel.add(getPJCombo_MarketingSource(), null);
			PersonalPanel.add(getPJLabel_MarketingRemark(), null);
			PersonalPanel.add(getPJText_MarketingRemark(), null);
			PersonalPanel.add(getPJLabel_Active(), null);
			PersonalPanel.add(getPJCheckBox_Active(), null);
			PersonalPanel.add(getPJLabel_Interpreter(), null);
			PersonalPanel.add(getPJCheckBox_Interpreter(), null);
			PersonalPanel.add(getPJLabel_Staff(), null);
			PersonalPanel.add(getPJCheckBox_Staff(), null);
			PersonalPanel.add(getPJLabel_SMS(), null);
			PersonalPanel.add(getPJCheckBox_SMS(), null);
			PersonalPanel.add(getPJLabel_CheckID(), null);
			PersonalPanel.add(getPJCheckBox_CheckID(), null);
			PersonalPanel.add(getPJText_CheckIDLastUpdatedDate(), null);
			PersonalPanel.add(getPJText_CheckIDLastUpdatedBy(), null);
		}
		return PersonalPanel;
	}

	private LabelSmallBase getPJLabel_IDPassportNO() {
		if (PJLabel_IDPassportNO == null) {
			PJLabel_IDPassportNO = new LabelSmallBase();
			PJLabel_IDPassportNO.setText("Document No.");
			PJLabel_IDPassportNO.setBounds(5, 0, 120, 20);
		}
		return PJLabel_IDPassportNO;
	}

	private TextPassport getPJText_IDPassportNO() {
		if (PJText_IDPassportNO == null) {
			PJText_IDPassportNO = new TextPassport() {
				@Override
				public void onBlur() {
					// if ID/Passport No exist in the db then get the record and update the related fields value
					if (!isEmpty() && isAppend() && isPatientFlag()) {
						QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.PATIENT_IDNO_TXCODE,
								new String[] { getPJText_IDPassportNO().getText() },
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									showPatient(mQueue);
								}
							}
						});
					}
				};
			};
			PJText_IDPassportNO.setBounds(87, 0, 90, 20);
		}
		return PJText_IDPassportNO;
	}

	private LabelSmallBase getPJLabel_DocType() {
		if (PJLabel_DocType == null) {
			PJLabel_DocType = new LabelSmallBase();
			PJLabel_DocType.setText("Doc Type");
			PJLabel_DocType.setBounds(280, 0, 65, 20);
		}
		return PJLabel_DocType;
	}

	private void setIssueCountryByDocType() {
		getAJCombo_IDCountry().setEnabled(true);
		getPJCombo_DocType().setErrorField(false);

		QueryUtil.executeMasterFetch(getUserInfo(),"DOCTYPACT", new String[] { getPJCombo_DocType().getText() },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					// get first return value and assign to district
					getAJCombo_IDCountry().setText(mQueue.getContentField()[0]);
					getAJCombo_IDCountry().setEnabled(false);
					if (mQueue.getContentField()[0].isEmpty() || "BC".equals(getPJCombo_DocType().getText())) {
						getAJCombo_IDCountry().setEnabled(true);
					}
				} else {
					getAJCombo_IDCountry().resetText();
				}
			}
		});
	}

	private void setIssueCountryByDocType_S1() {
		getAJCombo_IDCountry_S1().setEnabled(true);
		getPJCombo_DocType_S1().setErrorField(false);

		QueryUtil.executeMasterFetch(getUserInfo(),"DOCTYPACT", new String[] { getPJCombo_DocType_S1().getText() },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					// get first return value and assign to district
					getAJCombo_IDCountry_S1().setText(mQueue.getContentField()[0]);
					getAJCombo_IDCountry_S1().setEnabled(false);
					if (mQueue.getContentField()[0].isEmpty() || "BC".equals(getPJCombo_DocType_S1().getText())) {
						getAJCombo_IDCountry_S1().setEnabled(true);
					}
				} else {
					getAJCombo_IDCountry_S1().resetText();
				}
			}
		});
	}

	private void setIssueCountryByDocType_S2() {
		getAJCombo_IDCountry_S2().setEnabled(true);
		getPJCombo_DocType_S2().setErrorField(false);

		QueryUtil.executeMasterFetch(getUserInfo(),"DOCTYPACT", new String[] { getPJCombo_DocType_S2().getText() },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					// get first return value and assign to district
					getAJCombo_IDCountry_S2().setText(mQueue.getContentField()[0]);
					getAJCombo_IDCountry_S2().setEnabled(false);
					if (mQueue.getContentField()[0].isEmpty() || "BC".equals(getPJCombo_DocType_S2().getText())) {
						getAJCombo_IDCountry_S2().setEnabled(true);
					}
				} else {
					getAJCombo_IDCountry_S2().resetText();
				}
			}
		});
	}

	private ComboBoxBase getPJCombo_DocType() {
		if (PJCombo_DocType == null) {
			PJCombo_DocType = new ComboBoxBase("PATDOCTYPE", false, false, true) {
				@Override
				protected void onSelect(ModelData modelData, int index) {
					super.onSelect(modelData, index);
					setIssueCountryByDocType();
				}
				@Override
				protected void onPressed() {
					if (getRawValue().length()== 0) {
						getAJCombo_IDCountry().setEnabled(true);
						getAJCombo_IDCountry().resetText();
					} else {
						setIssueCountryByDocType();
					}
				}
				@Override
				protected void onTypeAhead() {
					super.onTypeAhead();
					setIssueCountryByDocType();
				}
			};
			PJCombo_DocType.setBounds(342, 0, 70, 20);
			PJCombo_DocType.setMinListWidth(400);
		}
		return PJCombo_DocType;
	}

	private LabelSmallBase getPJLabel_FamilyName() {
		if (PJLabel_FamilyName == null) {
			PJLabel_FamilyName = new LabelSmallBase();
			PJLabel_FamilyName.setText("Family name");
			PJLabel_FamilyName.setBounds(5, 75, 88, 20);
		}
		return PJLabel_FamilyName;
	}

	private TextName getPJText_FamilyName() {
		if (PJText_FamilyName == null) {
			PJText_FamilyName = new TextName(40) {
				@Override
				public void onReleased() {
					updatePatientName();
				}

				@Override
				public void onBlur() {
					updatePatientName();
				};
			};
			PJText_FamilyName.setBounds(85, 75, 135, 20);
		}
		return PJText_FamilyName;
	}

	private LabelSmallBase getAJLabel_IDCountry() {
		if (AJLabel_IDCountry == null) {
			AJLabel_IDCountry = new LabelSmallBase();
			AJLabel_IDCountry.setText("Iss. Ct");
			AJLabel_IDCountry.setBounds(177, 0, 40, 20);
		}
		return AJLabel_IDCountry;
	}

	private ComboCountry getAJCombo_IDCountry() {
		if (AJCombo_IDCountry == null) {
			AJCombo_IDCountry = new ComboCountry() {
				protected void onClick() {
					if (!getPJCombo_DocType().isEmpty()
							&& "BC".equals(getPJCombo_DocType().getText())
							&& !"852".equals(AJCombo_IDCountry.getText())
							&& !"".equals(AJCombo_IDCountry.getText())) {
						MessageBoxBase.confirm(MSG_PBA_SYSTEM,
								"Do you need to change issue country?",
								new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.NO.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									AJCombo_IDCountry.setText("852");
								}
							}
						});
					}
				}
			};
			AJCombo_IDCountry.setBounds(210, 0, 70, 20);
			AJCombo_IDCountry.setMinListWidth(150);
		}
		return AJCombo_IDCountry;
	}

	private LabelSmallBase getAJLabel_IDCountry_S1() {
		if (AJLabel_IDCountry_S1 == null) {
			AJLabel_IDCountry_S1 = new LabelSmallBase();
			AJLabel_IDCountry_S1.setText("Iss. Ct");
			AJLabel_IDCountry_S1.setBounds(177, 25, 40, 20);
		}
		return AJLabel_IDCountry_S1;
	}

	private ComboCountry getAJCombo_IDCountry_S1() {
		if (AJCombo_IDCountry_S1 == null) {
			AJCombo_IDCountry_S1 = new ComboCountry() {
				protected void onClick() {
					if (!getPJCombo_DocType_S1().isEmpty()
							&& "BC".equals(getPJCombo_DocType_S1().getText())
							&& !"852".equals(AJCombo_IDCountry_S1.getText())
							&& !"".equals(AJCombo_IDCountry_S1.getText())) {
						MessageBoxBase.confirm(MSG_PBA_SYSTEM,
								"Do you need to change issue country?",
								new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.NO.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									AJCombo_IDCountry_S1.setText("852");
								}
							}
						});
					}
				}
			};
			AJCombo_IDCountry_S1.setBounds(210, 25, 70, 20);
			AJCombo_IDCountry_S1.setMinListWidth(150);
		}
		return AJCombo_IDCountry_S1;
	}

	private LabelSmallBase getAJLabel_IDCountry_S2() {
		if (AJLabel_IDCountry_S2 == null) {
			AJLabel_IDCountry_S2 = new LabelSmallBase();
			AJLabel_IDCountry_S2.setText("Iss. Ct");
			AJLabel_IDCountry_S2.setBounds(177, 50, 40, 20);
		}
		return AJLabel_IDCountry_S2;
	}

	private ComboCountry getAJCombo_IDCountry_S2() {
		if (AJCombo_IDCountry_S2 == null) {
			AJCombo_IDCountry_S2 = new ComboCountry() {
				protected void onClick() {
					if (!getPJCombo_DocType_S2().isEmpty()
							&& "BC".equals(getPJCombo_DocType_S2().getText())
							&& !"852".equals(AJCombo_IDCountry_S2.getText())
							&& !"".equals(AJCombo_IDCountry_S2.getText())) {
						MessageBoxBase.confirm(MSG_PBA_SYSTEM,
								"Do you need to change issue country?",
								new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.NO.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									AJCombo_IDCountry_S2.setText("852");
								}
							}
						});
					}
				}
			};
			AJCombo_IDCountry_S2.setBounds(210, 50, 70, 20);
			AJCombo_IDCountry_S2.setMinListWidth(150);
		}
		return AJCombo_IDCountry_S2;
	}

	private LabelSmallBase getPJLabel_IDPassportNO_S1() {
		if (PJLabel_IDPassportNO_S1 == null) {
			PJLabel_IDPassportNO_S1 = new LabelSmallBase();
			PJLabel_IDPassportNO_S1.setText("Add.Doc No.(1)");
			PJLabel_IDPassportNO_S1.setBounds(5, 25, 120, 20);
		}
		return PJLabel_IDPassportNO_S1;
	}

	private TextPassport getPJText_IDPassportNO_S1() {
		if (PJText_IDPassportNO_S1 == null) {
			PJText_IDPassportNO_S1 = new TextPassport() {
				@Override
				public void onBlur() {
					// if ID/Passport No exist in the db then get the record and update the related fields value
					if (!isEmpty() && isAppend() && isPatientFlag()) {
						QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.PATIENT_IDNO_TXCODE,
								new String[] { getPJText_IDPassportNO_S1().getText() },
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									Factory.getInstance().addInformationMessage("Document already exist in patient "+mQueue.getContentField()[0]);
								}
							}
						});
					}
				};
			};
			PJText_IDPassportNO_S1.setBounds(87, 25, 90, 20);
		}
		return PJText_IDPassportNO_S1;
	}


	private LabelSmallBase getPJLabel_DocType_S1() {
		if (PJLabel_DocType_S1 == null) {
			PJLabel_DocType_S1 = new LabelSmallBase();
			PJLabel_DocType_S1.setText("Doc Type");
			PJLabel_DocType_S1.setBounds(280, 25, 65, 20);
		}
		return PJLabel_DocType_S1;
	}

	private ComboBoxBase getPJCombo_DocType_S1() {
		if (PJCombo_DocType_S1 == null) {
			PJCombo_DocType_S1 = new ComboBoxBase("PATDOCTYPE", false, false, true){
				@Override
				protected void onSelect(ModelData modelData, int index) {
					super.onSelect(modelData, index);
					setIssueCountryByDocType_S1();
				}
				@Override
				protected void onPressed() {
					if (getRawValue().length()== 0) {
						getAJCombo_IDCountry_S1().setEnabled(true);
						getAJCombo_IDCountry_S1().resetText();
					} else {
						setIssueCountryByDocType_S1();
					}
				}
				@Override
				protected void onTypeAhead() {
					super.onTypeAhead();
					setIssueCountryByDocType_S1();
				}
			};
			PJCombo_DocType_S1.setBounds(342, 25, 70, 20);
			PJCombo_DocType_S1.setMinListWidth(400);
		}
		return PJCombo_DocType_S1;
	}

	private LabelSmallBase getPJLabel_IDPassportNO_S2() {
		if (PJLabel_IDPassportNO_S2 == null) {
			PJLabel_IDPassportNO_S2 = new LabelSmallBase();
			PJLabel_IDPassportNO_S2.setText("Add.Doc No.(2)");
			PJLabel_IDPassportNO_S2.setBounds(5, 50, 90, 20);
		}
		return PJLabel_IDPassportNO_S2;
	}

	private TextPassport getPJText_IDPassportNO_S2() {
		if (PJText_IDPassportNO_S2 == null) {
			PJText_IDPassportNO_S2 = new TextPassport() {
				@Override
				public void onBlur() {
					// if ID/Passport No exist in the db then get the record and update the related fields value
					if (!isEmpty() && isAppend() && isPatientFlag()) {
						QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.PATIENT_IDNO_TXCODE,
								new String[] { getPJText_IDPassportNO_S2().getText() },
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									Factory.getInstance().addInformationMessage("Document already exist in patient "+mQueue.getContentField()[0]);
								}
							}
						});
					}
				};
			};
			PJText_IDPassportNO_S2.setBounds(85, 50, 135, 20);
		}
		return PJText_IDPassportNO_S2;
	}

	private LabelSmallBase getPJLabel_DocType_S2() {
		if (PJLabel_DocType_S2 == null) {
			PJLabel_DocType_S2 = new LabelSmallBase();
			PJLabel_DocType_S2.setText("Doc Type");
			PJLabel_DocType_S2.setBounds(280, 50, 65, 20);
		}
		return PJLabel_DocType_S2;
	}

	private ComboBoxBase getPJCombo_DocType_S2() {
		if (PJCombo_DocType_S2 == null) {
			PJCombo_DocType_S2 = new ComboBoxBase("PATDOCTYPE", false, false, true){
				@Override
				protected void onSelect(ModelData modelData, int index) {
					super.onSelect(modelData, index);
					setIssueCountryByDocType_S2();
				}

				@Override
				protected void onPressed() {
					if (getRawValue().length()== 0) {
						getAJCombo_IDCountry_S2().setEnabled(true);
						getAJCombo_IDCountry_S2().resetText();
					} else {
						setIssueCountryByDocType_S2();
					}
				}
				@Override
				protected void onTypeAhead() {
					super.onTypeAhead();
					setIssueCountryByDocType_S2();
				}
			};
			PJCombo_DocType_S2.setBounds(342, 50, 70, 20);
			PJCombo_DocType_S2.setMinListWidth(400);
		}
		return PJCombo_DocType_S2;
	}

	private LabelSmallBase getPJLabel_GivenName() {
		if (PJLabel_GivenName == null) {
			PJLabel_GivenName = new LabelSmallBase();
			PJLabel_GivenName.setText("Given name");
			PJLabel_GivenName.setBounds(5, 100, 88, 20);
		}
		return PJLabel_GivenName;
	}

	private TextName getPJText_GivenName() {
		if (PJText_GivenName == null) {
			PJText_GivenName = new TextName(40) {
				@Override
				public void onReleased() {
					updatePatientName();
				}

				@Override
				public void onBlur() {
					updatePatientName();
				};
			};
			PJText_GivenName.setBounds(85, 100, 330, 20);
		}
		return PJText_GivenName;
	}

	private LabelSmallBase getPJLabel_ChineseName() {
		if (PJLabel_ChineseName == null) {
			PJLabel_ChineseName = new LabelSmallBase();
			PJLabel_ChineseName.setText("Chinese name");
			PJLabel_ChineseName.setBounds(5, 125, 88, 20);
		}
		return PJLabel_ChineseName;
	}

	private TextNameChinese getPJText_ChineseName() {
		if (PJText_ChineseName == null) {
			PJText_ChineseName = new TextNameChinese() {
				public void onReleased() {
					updatePatientChineseName();
				}
			};
			PJText_ChineseName.setBounds(85, 125, 115, 20);
		}
		return PJText_ChineseName;
	}

	private LabelSmallBase getPJLabel_MSTS() {
		if (PJLabel_MSTS == null) {
			PJLabel_MSTS = new LabelSmallBase();
			PJLabel_MSTS.setText("Marital Status");
			PJLabel_MSTS.setBounds(210, 125, 90, 20);
		}
		return PJLabel_MSTS;
	}

	private ComboMSTS getPJCombo_MSTS() {
		if (PJCombo_MSTS == null) {
			PJCombo_MSTS = new ComboMSTS();
			PJCombo_MSTS.setBounds(280, 125, 135, 20);
		}
		return PJCombo_MSTS;
	}

	private LabelSmallBase getPJLabel_MaidenName() {
		if (PJLabel_MaidenName == null) {
			PJLabel_MaidenName = new LabelSmallBase();
			PJLabel_MaidenName.setText("Maiden name");
			PJLabel_MaidenName.setBounds(5, 150, 88, 20);
		}
		return PJLabel_MaidenName;
	}

	private TextName getPJText_MaidenName() {
		if (PJText_MaidenName == null) {
			PJText_MaidenName = new TextName();
			PJText_MaidenName.setBounds(85, 150, 135, 20);
		}
		return PJText_MaidenName;
	}

	private LabelSmallBase getPJLabel_Title() {
		if (PJLabel_Title == null) {
			PJLabel_Title = new LabelSmallBase();
			PJLabel_Title.setText("Title");
			PJLabel_Title.setBounds(230, 75, 30, 20);
		}
		return PJLabel_Title;
	}

	private ComboTitle getPJCombo_Title() {
		if (PJCombo_Title == null) {
			PJCombo_Title = new ComboTitle();
			PJCombo_Title.setBounds(280, 75, 135, 20);
		}
		return PJCombo_Title;
	}

	private LabelSmallBase getPJLabel_Race() {
		if (PJLabel_Race == null) {
			PJLabel_Race = new LabelSmallBase();
			PJLabel_Race.setText("Nat'y");
			PJLabel_Race.setBounds(230, 150, 40, 20);
		}
		return PJLabel_Race;
	}

	private ComboRace getPJCombo_Race() {
		if (PJCombo_Race == null) {
			PJCombo_Race = new ComboRace();
			PJCombo_Race.setBounds(280, 150, 135, 20);
		}
		return PJCombo_Race;
	}

	private LabelSmallBase getPJLabel_Birthday() {
		if (PJLabel_Birthday == null) {
			PJLabel_Birthday = new LabelSmallBase();
			PJLabel_Birthday.setText("Birthday");
			PJLabel_Birthday.setBounds(5, 175, 88, 20);
		}
		return PJLabel_Birthday;
	}

	private TextDate getPJText_Birthday() {
		if (PJText_Birthday == null) {
			PJText_Birthday = new TextDate() {
				@Override
				public void onBlur() {
					if (!isEmpty() && !isValid()) {
						Factory.getInstance().addErrorMessage(
								ConstantsMessage.MSG_ADMISSION_DATE,
								getPJText_Birthday());
						resetText();
						return;
					} else if (!isEmpty()) {
						if ((DateTimeUtil.dateDiff(getMainFrame().getServerDate(),
													getPJText_Birthday().getText().trim()) < 0)) {
							Factory.getInstance().addErrorMessage(
									ConstantsMessage.MSG_BIRTHDAY_DATE,
									getPJText_Birthday());
							getPJText_Age().resetText();
							resetText();
							return;
						}

						updateAge();
					} else {
						getPJText_Age().resetText();
					}
				}

//				@Override
//				protected void validation() {
//					super.validation();
//					updateAge();
//				}
			};
			PJText_Birthday.setBounds(85, 175, 135, 20);
		}
		return PJText_Birthday;
	}

	private LabelSmallBase getPJLabel_Age() {
		if (PJLabel_Age == null) {
			PJLabel_Age = new LabelSmallBase();
			PJLabel_Age.setText("Age");
			PJLabel_Age.setBounds(230, 175, 40, 20);
		}
		return PJLabel_Age;
	}

	private TextReadOnly getPJText_Age() {
		if (PJText_Age == null) {
			PJText_Age = new TextReadOnly();
			PJText_Age.setBounds(280, 175, 135, 20);
		}
		return PJText_Age;
	}

	private LabelSmallBase getPJLabel_BirthOrdSPG() {
		if (PJLabel_BirthOrdSPG == null) {
			PJLabel_BirthOrdSPG = new LabelSmallBase();
			PJLabel_BirthOrdSPG.setText("Birth Order<br> Same PG");
			PJLabel_BirthOrdSPG.setBounds(270, 168, 70, 20);
			PJLabel_BirthOrdSPG.setVisible(false);
		}
		return PJLabel_BirthOrdSPG;
	}

	private ComboBirthOrdSPG getPJCombo_BirthOrdSPG() {
		if (getPJCombo_BirthOrdSPG == null) {
			getPJCombo_BirthOrdSPG = new ComboBirthOrdSPG();
			getPJCombo_BirthOrdSPG.setBounds(335, 175, 80, 20);
			getPJCombo_BirthOrdSPG.setVisible(false);
		}
		return getPJCombo_BirthOrdSPG;
	}

	private LabelSmallBase getPJLabel_MotherLanguage() {
		if (PJLabel_MotherLanguage == null) {
			PJLabel_MotherLanguage = new LabelSmallBase();
			PJLabel_MotherLanguage.setText("Corr. Language");
			PJLabel_MotherLanguage.setBounds(5, 200, 120, 20);
		}
		return PJLabel_MotherLanguage;
	}

	private ComboLanguage getPJCombo_MotherLanguage() {
		if (PJCombo_MotherLanguage == null) {
			PJCombo_MotherLanguage = new ComboLanguage();
			PJCombo_MotherLanguage.setBounds(85, 200, 135, 20);
		}
		return PJCombo_MotherLanguage;
	}

	private LabelSmallBase getPJLabel_Sex() {
		if (PJLabel_Sex == null) {
			PJLabel_Sex = new LabelSmallBase();
			PJLabel_Sex.setText("Sex");
			PJLabel_Sex.setBounds(230, 200, 40, 20);
		}
		return PJLabel_Sex;
	}

	private ComboSex getPJCombo_Sex() {
		if (PJCombo_Sex == null) {
			PJCombo_Sex = new ComboSex(getRTJText_Sex());
			PJCombo_Sex.setBounds(280, 200, 135, 20);
		}
		return PJCombo_Sex;
	}

	private LabelSmallBase getPJLabel_EduLvl() {
		if (PJLabel_EduLvl == null) {
			PJLabel_EduLvl = new LabelSmallBase();
			PJLabel_EduLvl.setText("Edu. Level");
			PJLabel_EduLvl.setBounds(5, 225, 88, 20);
		}
		return PJLabel_EduLvl;
	}

	private ComboEduLvl getPJCombo_EduLvl() {
		if (PJCombo_EduLvl == null) {
			PJCombo_EduLvl = new ComboEduLvl();
			PJCombo_EduLvl.setBounds(85, 225, 135, 20);
		}
		return PJCombo_EduLvl;
	}

	private LabelSmallBase getPJLabel_Death() {
		if (PJLabel_Death == null) {
			PJLabel_Death = new LabelSmallBase();
			PJLabel_Death.setText("Death");
			PJLabel_Death.setBounds(230, 225, 40, 20);
		}
		return PJLabel_Death;
	}

	private TextDate getPJText_Death() {
		if (PJText_Death == null) {
			PJText_Death = new TextDate() {
				@Override
				public void onBlur() {
					if (!isEmpty() && !isValid()) {
						Factory.getInstance().addErrorMessage("Invalid date.", PJText_Death);
						resetText();
						return;
					}

					if (DateTimeUtil.dateTimeDiff(getText(), getMainFrame().getServerDateTime()) > 0) {
						Factory.getInstance().addErrorMessage("The death date can't be later than today.", this);
						return;
					}
				};
				@Override
				public void setEditable(boolean editable) {
					super.setEditable(editable);
					super.setHideTrigger(!editable);
				}
			};
			PJText_Death.setEditable(false);
			PJText_Death.setBounds(280, 225, 135, 20);
		}
		return PJText_Death;
	}

	private LabelSmallBase getPJLabel_Religious() {
		if (PJLabel_Religious == null) {
			PJLabel_Religious = new LabelSmallBase();
			PJLabel_Religious.setText("Religion");
			PJLabel_Religious.setBounds(5, 250, 88, 20);
		}
		return PJLabel_Religious;
	}

	private ComboReligious getPJCombo_Religious() {
		if (PJCombo_Religious == null) {
			PJCombo_Religious = new ComboReligious();
			PJCombo_Religious.setBounds(85, 250, 135, 20);
		}
		return PJCombo_Religious;
	}

	private ButtonBase getPJButton_UpdateDeathDate() {
		if (PJButton_UpdateDeathDate == null) {
			PJButton_UpdateDeathDate = new ButtonBase() {
				@Override
				public void onClick() {
					getPJText_Death().setEditable(true);
				}
			};
			PJButton_UpdateDeathDate.setEnabled(false);
			PJButton_UpdateDeathDate.setText("Update Death Date");
			PJButton_UpdateDeathDate.setBounds(230, 250, 185, 23);
		}
		return PJButton_UpdateDeathDate;
	}

	private LabelSmallBase getPJLabel_Occupation() {
		if (PJLabel_Occupation == null) {
			PJLabel_Occupation = new LabelSmallBase();
			PJLabel_Occupation.setText("Occupation");
			PJLabel_Occupation.setBounds(5, 275, 88, 20);
		}
		return PJLabel_Occupation;
	}

	private TextString getPJText_Occupation() {
		if (PJText_Occupation == null) {
			PJText_Occupation = new TextString(20, true);
			PJText_Occupation.setBounds(85, 275, 135, 20);
		}
		return PJText_Occupation;
	}

	private LabelSmallBase getPJLabel_MiscRemark() {
		if (PJLabel_MiscRemark == null) {
			PJLabel_MiscRemark = new LabelSmallBase();
			PJLabel_MiscRemark.setText("Misc Rmk");
			PJLabel_MiscRemark.setBounds(230, 275, 80, 20);
		}
		return PJLabel_MiscRemark;
	}

	private TextString getPJText_MiscRemark() {
		if (PJText_MiscRemark == null) {
			PJText_MiscRemark = new TextString(50, true);
			PJText_MiscRemark.setBounds(280, 275, 135, 20);
		}
		return PJText_MiscRemark;
	}

	private LabelSmallBase getPJLabel_MotherRecord() {
		if (PJLabel_MotherRecord == null) {
			PJLabel_MotherRecord = new LabelSmallBase();
			PJLabel_MotherRecord.setText("Mother Record");
			PJLabel_MotherRecord.setBounds(5, 300, 88, 20);
		}
		return PJLabel_MotherRecord;
	}

	private TextPatientNoSearch getPJText_MotherRecord() {
		if (PJText_MotherRecord == null) {
			PJText_MotherRecord = new TextPatientNoSearch(true, false) {
				@Override
				protected void checkPatient(boolean isExistPatient, boolean bySearchKey) {
					if (isExistPatient && isAppend() && isPatientFlag()) {
						showMomDetails(PJText_MotherRecord.getText().trim());
					} else if (!isExistPatient && (isAppend() || isModify())) {
						Factory.getInstance().addErrorMessage(MSG_INVALID_PATIENTNO, PJText_MotherRecord);
						PJText_MotherRecord.resetText();
					}
				}
			};
			PJText_MotherRecord.setBounds(85, 300, 70, 20);
		}
		return PJText_MotherRecord;
	}

	private LabelSmallBase getPJLabel_NewBorn() {
		if (PJLabel_NewBorn == null) {
			PJLabel_NewBorn = new LabelSmallBase();
			PJLabel_NewBorn.setText("New Born");
			PJLabel_NewBorn.setBounds(158, 300, 60, 20);
		}
		return PJLabel_NewBorn;
	}

	public CheckBoxBase getPJCheckBox_NewBorn() {
		if (PJCheckBox_NewBorn == null) {
			PJCheckBox_NewBorn = new CheckBoxBase();
			PJCheckBox_NewBorn.setBounds(209, 300, 20, 20);
		}
		return PJCheckBox_NewBorn;
	}

	private LabelSmallBase getPJLabel_MRRemark() {
		if (PJLabel_MRRemark == null) {
			PJLabel_MRRemark = new LabelSmallBase();
			PJLabel_MRRemark.setText("NB Rmk");
			PJLabel_MRRemark.setBounds(230, 300, 80, 20);
		}
		return PJLabel_MRRemark;
	}

	private TextString getPJText_MRRemark() {
		if (PJText_MRRemark == null) {
			PJText_MRRemark = new TextString(20, true);
			PJText_MRRemark.setBounds(280, 300, 135, 20);
		}
		return PJText_MRRemark;
	}

	private LabelSmallBase getPJLabel_MarketingSource() {
		if (PJLabel_MarketingSource == null) {
			PJLabel_MarketingSource = new LabelSmallBase();
			PJLabel_MarketingSource.setText("Marketing Src");
			PJLabel_MarketingSource.setBounds(5, 325, 88, 20);
		}
		return PJLabel_MarketingSource;
	}

	private ComboMarketingSource getPJCombo_MarketingSource() {
		if (PJCombo_MarketingSource == null) {
			PJCombo_MarketingSource = new ComboMarketingSource();
			PJCombo_MarketingSource.setBounds(85, 325, 135, 20);
		}
		return PJCombo_MarketingSource;
	}

	private LabelSmallBase getPJLabel_MarketingRemark() {
		if (PJLabel_MarketingRemark == null) {
			PJLabel_MarketingRemark = new LabelSmallBase();
			PJLabel_MarketingRemark.setText("Mkt Rmk");
			PJLabel_MarketingRemark.setBounds(230, 325, 80, 20);
		}
		return PJLabel_MarketingRemark;
	}

	private TextString getPJText_MarketingRemark() {
		if (PJText_MarketingRemark == null) {
			PJText_MarketingRemark = new TextString(20, true);
			PJText_MarketingRemark.setBounds(280, 325, 135, 20);
		}
		return PJText_MarketingRemark;
	}

	private LabelSmallBase getPJLabel_Active() {
		if (PJLabel_Active == null) {
			PJLabel_Active = new LabelSmallBase();
			PJLabel_Active.setText("Subscribe");
			PJLabel_Active.setBounds(5, 355, 40, 20);
		}
		return PJLabel_Active;
	}

	public CheckBoxBase getPJCheckBox_Active() {
		if (PJCheckBox_Active == null) {
			PJCheckBox_Active = new CheckBoxBase();
			PJCheckBox_Active.setBounds(60, 355, 20, 20);
		}
		return PJCheckBox_Active;
	}

	private LabelSmallBase getPJLabel_Interpreter() {
		if (PJLabel_Interpreter == null) {
			PJLabel_Interpreter = new LabelSmallBase();
			PJLabel_Interpreter.setText("Interpreter");
			PJLabel_Interpreter.setBounds(120, 355, 60, 20);
			}
		return PJLabel_Interpreter;
	}

	public CheckBoxBase getPJCheckBox_Interpreter() {
		if (PJCheckBox_Interpreter == null) {
			PJCheckBox_Interpreter = new CheckBoxBase();
			PJCheckBox_Interpreter.setBounds(175, 355, 20, 20);
		}
		return PJCheckBox_Interpreter;
	}

	private LabelSmallBase getPJLabel_Staff() {
		if (PJLabel_Staff == null) {
			PJLabel_Staff = new LabelSmallBase();
			PJLabel_Staff.setText("Staff");
			PJLabel_Staff.setBounds(240, 355, 30, 20);
		}
		return PJLabel_Staff;
	}

	public CheckBoxBase getPJCheckBox_Staff() {
		if (PJCheckBox_Staff == null) {
			PJCheckBox_Staff = new CheckBoxBase();
			PJCheckBox_Staff.setBounds(265, 355, 20, 20);
		}
		return PJCheckBox_Staff;
	}

	private LabelSmallBase getPJLabel_SMS() {
		if (PJLabel_SMS == null) {
			PJLabel_SMS = new LabelSmallBase();
			PJLabel_SMS.setText("SMS");
			PJLabel_SMS.setBounds(330, 355, 30, 20);
		}
		return PJLabel_SMS;
	}

	public CheckBoxBase getPJCheckBox_SMS() {
		if (PJCheckBox_SMS == null) {
			PJCheckBox_SMS = new CheckBoxBase();
			PJCheckBox_SMS.setBounds(355, 355, 20, 20);
		}
		return PJCheckBox_SMS;
	}

	private LabelSmallBase getPJLabel_CheckID() {
		if (PJLabel_CheckID == null) {
			PJLabel_CheckID = new LabelSmallBase();
			PJLabel_CheckID.setText("CKID");
			PJLabel_CheckID.setBounds(150, 355, 40, 20);
			PJLabel_CheckID.setVisible(false);
		}
		return PJLabel_CheckID;
	}

	public CheckBoxBase getPJCheckBox_CheckID() {
		if (PJCheckBox_CheckID == null) {
			PJCheckBox_CheckID = new CheckBoxBase();
			PJCheckBox_CheckID.setBounds(180, 355, 20, 20);
			PJCheckBox_CheckID.setVisible(false);
		}
		return PJCheckBox_CheckID;
	}

	private TextReadOnly getPJText_CheckIDLastUpdatedDate() {
		if (PJText_CheckIDLastUpdatedDate == null) {
			PJText_CheckIDLastUpdatedDate = new TextReadOnly();
			PJText_CheckIDLastUpdatedDate.setBounds(205, 355, 120, 20);
			PJText_CheckIDLastUpdatedDate.setVisible(false);
		}
		return PJText_CheckIDLastUpdatedDate;
	}

	private TextReadOnly getPJText_CheckIDLastUpdatedBy() {
		if (PJText_CheckIDLastUpdatedBy == null) {
			PJText_CheckIDLastUpdatedBy = new TextReadOnly();
			PJText_CheckIDLastUpdatedBy.setBounds(332, 355, 83, 20);
			PJText_CheckIDLastUpdatedBy.setVisible(false);
		}
		return PJText_CheckIDLastUpdatedBy;
	}

	public FieldSetBase getAddressPanel() {
		if (AddressPanel == null) {
			AddressPanel = new FieldSetBase();
			AddressPanel.setBounds(439, 0, 354, 412);
			AddressPanel.setHeading("Address Information");
			AddressPanel.add(getAJLabel_Email(), null);
			AddressPanel.add(getAJText_Email(), null);
			AddressPanel.add(getAJLabel_HomePhone(), null);
			AddressPanel.add(getAJText_HomePhone(), null);
			AddressPanel.add(getAJLabel_MobCouCode(), null);
			AddressPanel.add(getAJCombo_MobCouCode(), null);
			AddressPanel.add(getAJLabel_Mobile(), null);
			AddressPanel.add(getAJText_Mobile(), null);
			AddressPanel.add(getAJLabel_OfficePhone(), null);
			AddressPanel.add(getAJText_OfficePhone(), null);
			AddressPanel.add(getAJLabel_FaxNO(), null);
			AddressPanel.add(getAJText_FaxNO(), null);
			AddressPanel.add(getAJLabel_ADDR(), null);
			AddressPanel.add(getAJText_ADDR1(), null);
			AddressPanel.add(getAJText_ADDR2(), null);
			AddressPanel.add(getAJText_ADDR3(), null);
			AddressPanel.add(getAJLabel_Location(), null);
			AddressPanel.add(getAJCombo_Location(), null);
			AddressPanel.add(getAJLabel_District(), null);
			AddressPanel.add(getAJText_District(), null);
			AddressPanel.add(getAJLabel_Country(), null);
			AddressPanel.add(getAJCombo_Country(), null);
			AddressPanel.add(getAJLabel_Remark(), null);
			AddressPanel.add(getAJText_Remark(), null);
			AddressPanel.add(getAJLabel_LastUpdated(), null);
			AddressPanel.add(getAJText_LastUpdatedDate(), null);
			AddressPanel.add(getAJText_LastUpdatedBy(), null);
			AddressPanel.add(getAJLabel_MobileUser(), null);
			AddressPanel.add(getAJText_MobileUser(), null);
			AddressPanel.add(getAJText_MobileDate(), null);
			AddressPanel.add(getAButton_Alert(), null);
			AddressPanel.add(getAButton_PrintBasicinfoSheet(), null);
			AddressPanel.add(getAButton_PrintLabel(), null);
			AddressPanel.add(getAButton_PrintAddress(), null);
			AddressPanel.add(getINButton_MasBillingHistory(), null);
		}
		return AddressPanel;
	}

	private LabelSmallBase getAJLabel_Email() {
		if (AJLabel_Email == null) {
			AJLabel_Email = new LabelSmallBase();
			AJLabel_Email.setText("Email");
			AJLabel_Email.setBounds(5, 0, 100, 20);
		}
		return AJLabel_Email;
	}

	private TextEmail getAJText_Email() {
		if (AJText_Email == null) {
			AJText_Email = new TextEmail();
			AJText_Email.setBounds(80, 0, 260, 20);
		}
		return AJText_Email;
	}

	private LabelSmallBase getAJLabel_HomePhone() {
		if (AJLabel_HomePhone == null) {
			AJLabel_HomePhone = new LabelSmallBase();
			AJLabel_HomePhone.setText("Home phone");
			AJLabel_HomePhone.setBounds(5, 25, 100, 20);
		}
		return AJLabel_HomePhone;
	}

	private TextString getAJText_HomePhone() {
		if (AJText_HomePhone == null) {
			AJText_HomePhone = new TextString(20, true);
			AJText_HomePhone.setBounds(80, 25, 70, 20);
		}
		return AJText_HomePhone;
	}

	private LabelSmallBase getAJLabel_MobCouCode() {
		if (AJLabel_MobCouCode == null) {
			AJLabel_MobCouCode = new LabelSmallBase();
			AJLabel_MobCouCode.setText("M.Cty Code");
			AJLabel_MobCouCode.setBounds(155, 21, 30, 20);
		}
		return AJLabel_MobCouCode;
	}

	private ComboCountry getAJCombo_MobCouCode() {
		if (AJCombo_MobCouCode == null) {
			AJCombo_MobCouCode = new ComboCountry();
			AJCombo_MobCouCode.setBounds(185, 25, 50, 20);
			AJCombo_MobCouCode.setMinListWidth(100);
		}
		return AJCombo_MobCouCode;
	}

	private LabelSmallBase getAJLabel_Mobile() {
		if (AJLabel_Mobile == null) {
			AJLabel_Mobile = new LabelSmallBase();
			AJLabel_Mobile.setText("Mobile");
			AJLabel_Mobile.setBounds(240, 25, 30, 20);
		}
		return AJLabel_Mobile;
	}

	private TextString getAJText_Mobile() {
		if (AJText_Mobile == null) {
			AJText_Mobile = new TextString(20,false);
			AJText_Mobile.setBounds(270, 25, 70, 20);
		}
		return AJText_Mobile;
	}

	private LabelSmallBase getAJLabel_OfficePhone() {
		if (AJLabel_OfficePhone == null) {
			AJLabel_OfficePhone = new LabelSmallBase();
			AJLabel_OfficePhone.setText("Office phone");
			AJLabel_OfficePhone.setBounds(5, 50, 100, 20);
		}
		return AJLabel_OfficePhone;
	}

	private TextString getAJText_OfficePhone() {
		if (AJText_OfficePhone == null) {
			AJText_OfficePhone = new TextString(20, true);
			AJText_OfficePhone.setBounds(80, 50, 100, 20);
		}
		return AJText_OfficePhone;
	}

	private LabelSmallBase getAJLabel_FaxNO() {
		if (AJLabel_FaxNO == null) {
			AJLabel_FaxNO = new LabelSmallBase();
			AJLabel_FaxNO.setText("Fax No.");
			AJLabel_FaxNO.setBounds(194, 50, 60, 20);
		}
		return AJLabel_FaxNO;
	}

	private TextString getAJText_FaxNO() {
		if (AJText_FaxNO == null) {
			AJText_FaxNO = new TextString(20, false);
			AJText_FaxNO.setBounds(240, 50, 100, 20);
		}
		return AJText_FaxNO;
	}

	private LabelSmallBase getAJLabel_ADDR() {
		if (AJLabel_ADDR == null) {
			AJLabel_ADDR = new LabelSmallBase();
			AJLabel_ADDR.setText("Address");
			AJLabel_ADDR.setBounds(5, 75, 100, 20);
		}
		return AJLabel_ADDR;
	}

	private TextString getAJText_ADDR1() {
		if (AJText_ADDR1 == null) {
			AJText_ADDR1 = new TextString(40, true);
			AJText_ADDR1.setBounds(80, 75, 260, 20);
		}
		return AJText_ADDR1;
	}

	private TextString getAJText_ADDR2() {
		if (AJText_ADDR2 == null) {
			AJText_ADDR2 = new TextString(40, true);
			AJText_ADDR2.setBounds(80, 100, 260, 20);
		}
		return AJText_ADDR2;
	}

	private TextString getAJText_ADDR3() {
		if (AJText_ADDR3 == null) {
			AJText_ADDR3 = new TextString(40, true);
			AJText_ADDR3.setBounds(80, 125, 260, 20);
		}
		return AJText_ADDR3;
	}

	private LabelSmallBase getAJLabel_Location() {
		if (AJLabel_Location == null) {
			AJLabel_Location = new LabelSmallBase();
			AJLabel_Location.setText("Location");
			AJLabel_Location.setBounds(5, 150, 100, 20);
		}
		return AJLabel_Location;
	}

	private ComboLocation getAJCombo_Location() {
		if (AJCombo_Location == null) {
			AJCombo_Location = new ComboLocation() {
				@Override
				protected void setTextPanel(ModelData modelData) {
					if (!isRegFlag()) {
						// call database to retrieve district
						QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOCATION_TXCODE, new String[] { getText() },
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									// get first return value and assign to district
									getAJText_District().setText(mQueue.getContentField()[3]);
								} else {
									getAJText_District().resetText();
								}
							}
						});
					}
				}
			};
			AJCombo_Location.setBounds(80, 150, 260, 20);
		}
		return AJCombo_Location;
	}

	private LabelSmallBase getAJLabel_District() {
		if (AJLabel_District == null) {
			AJLabel_District = new LabelSmallBase();
			AJLabel_District.setText("District");
			AJLabel_District.setBounds(5, 175, 100, 20);
		}
		return AJLabel_District;
	}

	private TextReadOnly getAJText_District() {
		if (AJText_District == null) {
			AJText_District = new TextReadOnly();
			AJText_District.setBounds(80, 175, 260, 20);
		}
		return AJText_District;
	}

	private LabelSmallBase getAJLabel_Country() {
		if (AJLabel_Country == null) {
			AJLabel_Country = new LabelSmallBase();
			AJLabel_Country.setText("Country");
			AJLabel_Country.setBounds(5, 200, 100, 20);
		}
		return AJLabel_Country;
	}

	private ComboCountry getAJCombo_Country() {
		if (AJCombo_Country == null) {
			AJCombo_Country = new ComboCountry();
			AJCombo_Country.setBounds(80, 200, 260, 20);
		}
		return AJCombo_Country;
	}

	private LabelSmallBase getAJLabel_Remark() {
		if (AJLabel_Remark == null) {
			AJLabel_Remark = new LabelSmallBase();
			AJLabel_Remark.setText("Remark");
			AJLabel_Remark.setBounds(5, 225, 100, 20);
		}
		return AJLabel_Remark;
	}

	private TextString getAJText_Remark() {
		if (AJText_Remark == null) {
			AJText_Remark = new TextString(100, false);
			AJText_Remark.setBounds(80, 225, 260, 20);
		}
		return AJText_Remark;
	}

	private LabelSmallBase getAJLabel_LastUpdated() {
		if (AJLabel_LastUpdated == null) {
			AJLabel_LastUpdated = new LabelSmallBase();
			AJLabel_LastUpdated.setText("Last Updated");
			AJLabel_LastUpdated.setBounds(5, 250, 100, 20);
		}
		return AJLabel_LastUpdated;
	}

	private TextReadOnly getAJText_LastUpdatedDate() {
		if (AJText_LastUpdatedDate == null) {
			AJText_LastUpdatedDate = new TextReadOnly() {
				@Override
				public void setText(String value) {
					if (value != null && value.trim().length() > 19) {
						super.setText(value);
						if (rendered) {
							addInputStyleName("read-only-negative");
						}
					} else {
						super.setText(value);
						if (rendered) {
							removeInputStyleName("read-only-negative");
						}
					}
				}
			};
			AJText_LastUpdatedDate.setBounds(80, 250, 120, 20);
		}
		return AJText_LastUpdatedDate;
	}
	
	private TextReadOnly getAJText_LastUpdatedBy() {
		if (AJText_LastUpdatedBy == null) {
			AJText_LastUpdatedBy = new TextReadOnly();
			AJText_LastUpdatedBy.setBounds(205, 250, 135, 20);
		}
		return AJText_LastUpdatedBy;
	}
	
	private LabelSmallBase getAJLabel_MobileUser() {
		if (AJLabel_MobileUser == null) {
			AJLabel_MobileUser = new LabelSmallBase();
			AJLabel_MobileUser.setText("App User");
			AJLabel_MobileUser.setBounds(5, 275, 100, 20);
		}
		return AJLabel_MobileUser;
	}
	
	private TextReadOnly getAJText_MobileUser() {
		if (AJText_MobileUser == null) {
			AJText_MobileUser = new TextReadOnly();
			AJText_MobileUser.setBounds(80, 275, 120, 20);
		}
		return AJText_MobileUser;
	}

	private TextReadOnly getAJText_MobileDate() {
		if (AJText_MobileDate == null) {
			AJText_MobileDate = new TextReadOnly();
			AJText_MobileDate.setBounds(205, 275, 135, 20);
		}
		return AJText_MobileDate;
	}
	



	private ButtonBase getAButton_Alert() {
		if (AButton_Alert == null) {
			AButton_Alert = new ButtonBase() {
				@Override
				public void onClick() {
					setParameter("PATNO", getRTJText_PatientNumber().getText());
					setParameter("Patfname", getPJText_FamilyName().getText());
					setParameter("patgname", getPJText_GivenName().getText());
					setParameter("patcname", getPJText_ChineseName().getText());
					setParameter("patsex", getRTJText_Sex().getText());
					showPanel(new PatientAlert());
				}
			};
			AButton_Alert.setText("Alert", 'A');
			AButton_Alert.setBounds(5, 305, 120, 23);
		}
		return AButton_Alert;
	}

	private ButtonBase getAButton_PrintBasicinfoSheet() {
		if (AButton_PrintBasicinfoSheet == null) {
			AButton_PrintBasicinfoSheet = new ButtonBase() {
				@Override
				public void onClick() {
					printBasicInfoForm();
				}
			};
			AButton_PrintBasicinfoSheet.setText("Print Basic Info Sheet", 'P');
			AButton_PrintBasicinfoSheet.setBounds(5, 332, 120, 23);
		}
		return AButton_PrintBasicinfoSheet;
	}

	private ButtonBase getAButton_PrintLabel() {
		if (AButton_PrintLabel == null) {
			AButton_PrintLabel = new ButtonBase() {
				@Override
				public void onClick() {
					//call label dialog
					getDlgPrintPatientLabel().showDialog();
				}
			};
			AButton_PrintLabel.setText("Print Label", 'b');
			AButton_PrintLabel.setBounds(130, 332, 105, 23);
		}
		return AButton_PrintLabel;
	}

	private ButtonBase getAButton_PrintAddress() {
		if (AButton_PrintAddr == null) {
			AButton_PrintAddr = new ButtonBase() {
				@Override
				public void onClick() {
					// show patient address
					getDlgPrintAddress().showDialog(
						getRTJText_PatientNumber().getText().trim(),
						getPJCombo_Title().getText() + SPACE_VALUE + getPJText_FamilyName().getText(),
						getPJText_GivenName().getText(),
						getAJText_ADDR1().getText(),
						getAJText_ADDR2().getText(),
						getAJText_ADDR3().getText(),
						getAJCombo_Country().getText()
					);
				}
			};
			AButton_PrintAddr.setText("Print Addr/Env");
			AButton_PrintAddr.setBounds(240, 332, 105, 23);
		}
		return AButton_PrintAddr;
	}

	private ButtonBase getINButton_MasBillingHistory() {
		if (INButton_MasBillingHistory == null) {
			INButton_MasBillingHistory = new ButtonBase() {
				@Override
				public void onClick() {
					
					getDlgSlipList().showDialog(getRTJText_PatientNumber().getText().trim());
				}
			};
			INButton_MasBillingHistory.setBounds(130, 305, 215, 23);
			INButton_MasBillingHistory.setText("Billing History", 'H');
		}
		return INButton_MasBillingHistory;
	}

	public FieldSetBase getRelativePanel() {
		if (RelativePanel == null) {
			RelativePanel = new FieldSetBase();
			RelativePanel.setHeading("Relative");
			RelativePanel.setBounds(5, 410, 788, 102);
			RelativePanel.add(getRJLabel_KinName(), null);
			RelativePanel.add(getRJText_KinName(), null);
			RelativePanel.add(getRJLabel_HomeTel(), null);
			RelativePanel.add(getRJText_HomeTel(), null);
			RelativePanel.add(getRJLabel_Pager(), null);
			RelativePanel.add(getRJText_Pager(), null);
			RelativePanel.add(getRJLabel_OfficeTel(), null);
			RelativePanel.add(getRJText_OfficeTel(), null);
			RelativePanel.add(getRJLabel_Relationship(), null);
			RelativePanel.add(getRJText_Relationship(), null);
			RelativePanel.add(getRJLabel_Mobile(), null);
			RelativePanel.add(getRJText_Mobile(), null);
			RelativePanel.add(getRJLabel_Email(), null);
			RelativePanel.add(getRJText_Email(), null);
			RelativePanel.add(getRJLabel_Address(), null);
			RelativePanel.add(getRJText_Address(), null);
			RelativePanel.add(getRJLabel_SameAsAbove(), null);
			RelativePanel.add(getRJCheckBox_SameAsAbove(), null);
		}
		return RelativePanel;
	}

	private LabelSmallBase getRJLabel_KinName() {
		if (RJLabel_KinName == null) {
			RJLabel_KinName = new LabelSmallBase();
			RJLabel_KinName.setText("Kin Name");
			RJLabel_KinName.setBounds(5, 0, 80, 20);
		}
		return RJLabel_KinName;
	}

	private TextString getRJText_KinName() {
		if (RJText_KinName == null) {
			RJText_KinName = new TextString(40, true);
			RJText_KinName.setBounds(85, 0, 150, 20);
		}
		return RJText_KinName;
	}

	private LabelSmallBase getRJLabel_HomeTel() {
		if (RJLabel_HomeTel == null) {
			RJLabel_HomeTel = new LabelSmallBase();
			RJLabel_HomeTel.setText("Home Tel.");
			RJLabel_HomeTel.setBounds(245, 0, 60, 20);
		}
		return RJLabel_HomeTel;
	}

	private TextString getRJText_HomeTel() {
		if (RJText_HomeTel == null) {
			RJText_HomeTel = new TextString(20, true);
			RJText_HomeTel.setBounds(305, 0, 120, 20);
		}
		return RJText_HomeTel;
	}

	private LabelSmallBase getRJLabel_Pager() {
		if (RJLabel_Pager == null) {
			RJLabel_Pager = new LabelSmallBase();
			RJLabel_Pager.setText("Pager");
			RJLabel_Pager.setBounds(435, 0, 60, 20);
		}
		return RJLabel_Pager;
	}

	private TextString getRJText_Pager() {
		if (RJText_Pager == null) {
			RJText_Pager = new TextString(20, true);
			RJText_Pager.setBounds(475, 0, 120, 20);
		}
		return RJText_Pager;
	}

	private LabelSmallBase getRJLabel_OfficeTel() {
		if (RJLabel_OfficeTel == null) {
			RJLabel_OfficeTel = new LabelSmallBase();
			RJLabel_OfficeTel.setText("Office Tel.");
			RJLabel_OfficeTel.setBounds(600, 0, 60, 20);
		}
		return RJLabel_OfficeTel;
	}

	private TextString getRJText_OfficeTel() {
		if (RJText_OfficeTel == null) {
			RJText_OfficeTel = new TextString(20, true);
			RJText_OfficeTel.setBounds(655, 0, 120, 20);
		}
		return RJText_OfficeTel;
	}

	private LabelSmallBase getRJLabel_Relationship() {
		if (RJLabel_Relationship == null) {
			RJLabel_Relationship = new LabelSmallBase();
			RJLabel_Relationship.setText("Relationship");
			RJLabel_Relationship.setBounds(5, 25, 80, 20);
		}
		return RJLabel_Relationship;
	}

	private ComboRelationship getRJText_Relationship() {
		if (RJText_Relationship == null) {
			RJText_Relationship = new ComboRelationship();
			RJText_Relationship.setBounds(85, 25, 150, 20);
			RJText_Relationship.setForceSelection(false);
		}
		return RJText_Relationship;
	}

	private LabelSmallBase getRJLabel_Mobile() {
		if (RJLabel_Mobile == null) {
			RJLabel_Mobile = new LabelSmallBase();
			RJLabel_Mobile.setText("Mobile");
			RJLabel_Mobile.setBounds(245, 25, 60, 20);
		}
		return RJLabel_Mobile;
	}

	private TextString getRJText_Mobile() {
		if (RJText_Mobile == null) {
			RJText_Mobile = new TextString(20, true);
			RJText_Mobile.setBounds(305, 25, 120, 20);
		}
		return RJText_Mobile;
	}

	private LabelSmallBase getRJLabel_Email() {
		if (RJLabel_Email == null) {
			RJLabel_Email = new LabelSmallBase();
			RJLabel_Email.setText("Email");
			RJLabel_Email.setBounds(435, 25, 60, 20);
		}
		return RJLabel_Email;
	}

	private TextEmail getRJText_Email() {
		if (RJText_Email == null) {
			RJText_Email = new TextEmail();
			RJText_Email.setBounds(475, 25, 300, 20);
		}
		return RJText_Email;
	}

	private LabelSmallBase getRJLabel_Address() {
		if (RJLabel_Address == null) {
			RJLabel_Address = new LabelSmallBase();
			RJLabel_Address.setText("Address");
			RJLabel_Address.setBounds(5, 50, 80, 20);
		}
		return RJLabel_Address;
	}

	private TextString getRJText_Address() {
		if (RJText_Address == null) {
			RJText_Address = new TextString(100, true);
			RJText_Address.setBounds(85, 50, 570, 20);
		}
		return RJText_Address;
	}

	private LabelSmallBase getRJLabel_SameAsAbove() {
		if (RJLabel_SameAsAbove == null) {
			RJLabel_SameAsAbove = new LabelSmallBase();
			RJLabel_SameAsAbove.setText("Same as above");
			RJLabel_SameAsAbove.setBounds(665, 50, 90, 20);
		}
		return RJLabel_SameAsAbove;
	}

	public CheckBoxBase getRJCheckBox_SameAsAbove() {
		if (RJCheckBox_SameAsAbove == null) {
			RJCheckBox_SameAsAbove = new CheckBoxBase() {
				@Override
				public void onClick() {
					if (isSelected()) {
						getRJText_Address().setText(SAME_AS_ABOVE);
						getRJText_Address().setEditable(false);
					} else {
						getRJText_Address().setEditable(true);
					}
				}
			};
			RJCheckBox_SameAsAbove.setBounds(755, 50, 20, 20);
		}
		return RJCheckBox_SameAsAbove;
	}

	private RadioButtonBase getRTJRadio_OutPatient() {
		if (RTJRadio_OutPatient == null) {
			RTJRadio_OutPatient = new RadioButtonBase();
			RTJRadio_OutPatient.setBounds(5, 0, 20, 20);
		}
		return RTJRadio_OutPatient;
	}

	private LabelSmallBase getRTJLabel_OutPatient() {
		if (RTJLabel_OutPatient == null) {
			RTJLabel_OutPatient = new LabelSmallBase();
			RTJLabel_OutPatient.setText("Out-Patient");
			RTJLabel_OutPatient.setBounds(30, 0, 110, 20);
		}
		return RTJLabel_OutPatient;
	}

	private RadioButtonBase getRTJRadio_DayCasePatient() {
		if (RTJRadio_DayCasePatient == null) {
			RTJRadio_DayCasePatient = new RadioButtonBase();
			RTJRadio_DayCasePatient.setBounds(120, 0, 20, 20);
		}
		return RTJRadio_DayCasePatient;
	}

	private LabelSmallBase getRTJLabel_DayCasePatient() {
		if (RTJLabel_DayCasePatient == null) {
			RTJLabel_DayCasePatient = new LabelSmallBase();
			RTJLabel_DayCasePatient.setText("Day Case");
			RTJLabel_DayCasePatient.setBounds(145, 0, 110, 20);
		}
		return RTJLabel_DayCasePatient;
	}

	private RadioButtonBase getRTJRadio_InPatient() {
		if (RTJRadio_InPatient == null) {
			RTJRadio_InPatient = new RadioButtonBase();
			RTJRadio_InPatient.setBounds(235, 0, 20, 20);
		}
		return RTJRadio_InPatient;
	}

	private LabelSmallBase getRTJLabel_InPatient() {
		if (RTJLabel_InPatient == null) {
			RTJLabel_InPatient = new LabelSmallBase();
			RTJLabel_InPatient.setText("In-Patient");
			RTJLabel_InPatient.setBounds(260, 0, 110, 20);
		}
		return RTJLabel_InPatient;
	}

	private LabelSmallBase getRTJLabel_OutPatientType() {
		if (RTJLabel_OutPatientType == null) {
			RTJLabel_OutPatientType = new LabelSmallBase();
			RTJLabel_OutPatientType.setText("Out-Patient Type");
			RTJLabel_OutPatientType.setBounds(5, 25, 110, 20);
		}
		return RTJLabel_OutPatientType;
	}

	private TextReadOnly getRTJText_OutPatientType() {
		if (RTJText_OutPatientType == null) {
			RTJText_OutPatientType = new TextReadOnly();
			RTJText_OutPatientType.setBounds(120, 25, 235, 20);
			RTJText_OutPatientType.setAllowReset(false);
		}
		return RTJText_OutPatientType;
	}
	
	private LabelBase getRTCombo_docRoomDesc() {
		if (RTCombo_docRoomDesc == null) {
			RTCombo_docRoomDesc = new LabelBase();
			RTCombo_docRoomDesc.setText("Room");
			RTCombo_docRoomDesc.setBounds(5, 50, 60, 20);
		}
		return RTCombo_docRoomDesc;
	}

	private ComboBoxBase getRTCombo_docRoom() {
		if (RTCombo_docRoom == null) {
			RTCombo_docRoom = new ComboBoxBase("DRROOM", false, true, true){
				@Override
				protected void onSelect(ModelData modelData, int index) {
					super.onSelect(modelData, index);
					checkDrCurRoom();
				}
				@Override
				protected void onPressed() {
					if (getRawValue().length()> 0) {
						checkDrCurRoom();
					}
				}
				@Override
				protected void onTypeAhead() {
					super.onTypeAhead();
					checkDrCurRoom();
				}
			};
			RTCombo_docRoom.setBounds(120, 50, 158, 20);
		}
		return RTCombo_docRoom;
	}
	
	private LabelBase getRTCombo_natureDesc() {
		if (RTCombo_natureDesc == null) {
			RTCombo_natureDesc = new LabelBase();
			RTCombo_natureDesc.setText("Nature");
			RTCombo_natureDesc.setBounds(5, 75, 60, 20);
		}
		return RTCombo_natureDesc;
	}
	
	private ComboBoxBase getRTCombo_nature() {
		if (RTCombo_nature == null) {
			RTCombo_nature = new ComboBoxBase("NATUREOFVISIT", false, false, true);
			RTCombo_nature.setBounds(120, 75, 158, 20);
			RTCombo_nature.setEditable(false);
		}
		return RTCombo_nature;
	}

	private ButtonBase getRegTabButton() {
		if (regTabBtn == null) {
			regTabBtn = new ButtonBase() {
				public void onClick() {
					searchPatientByChangeTab();
					getRBTPanel().setSelectedIndex(1);
					defaultFocus();
				}
			};
			regTabBtn.setVisible(false);
			regTabBtn.setHotkey('R');
		}
		return regTabBtn;
	}

	public BasePanel getRegPanel() {
		if (regPanel == null) {
			regPanel = new BasePanel();
			regPanel.setLayout(null);
			regPanel.setBounds(0, 0, 800, 540);
			regPanel.add(getRegTypePanel(), null);
			regPanel.add(getInPatInfoPanel(), null);
			regPanel.add(getINJLabel_MedRec(), null);
			regPanel.add(getINJText_Med(), null);
			regPanel.add(getINJText_Rec(), null);
			regPanel.add(getINButton_MedRecDetail(), null);
			regPanel.add(getINButton_MedRec(), null);
			regPanel.add(getINJLabel_SLPNO(), null);
			regPanel.add(getINJText_SLPNO(), null);
			regPanel.add(getINButton_SlipDetail(), null);
			regPanel.add(getINJLabel_RDate(), null);
			regPanel.add(getINJText_RegDate(), null);
			regPanel.add(getINJLabel_Category(), null);
			regPanel.add(getINJCombo_Category(), null);
			regPanel.add(getINJText_Category(), null);
			regPanel.add(getINJLabel_Ref(), null);
			regPanel.add(getINJText_Ref(), null);
			regPanel.add(getINJLabel_Source(), null);
			regPanel.add(getINJCombo_Source(), null);
			regPanel.add(getINJLabel_SourceNo(), null);
			regPanel.add(getINJText_SourceNo(), null);
			regPanel.add(getRightJLabel_Misc(), null);
			regPanel.add(getRightJCombo_Misc(), null);
			regPanel.add(getINJLabel_ARC(), null);
			regPanel.add(getINJCombo_ARC(), null);
			regPanel.add(getINJText_ARC(), null);
			regPanel.add(getINJText_ARCardType(), null);
			regPanel.add(getINJLabel_PLNO(), null);
			regPanel.add(getINJText_PLNO(), null);
			regPanel.add(getINJLabel_VHNO(), null);
			regPanel.add(getINJText_VHNO(), null);
			regPanel.add(getINJLabel_PreAuthNo(), null);
			regPanel.add(getINJText_PreAuthNo(), null);
			regPanel.add(getINJLabel_LAmt(), null);
			regPanel.add(getINJText_LAmt(), null);
			regPanel.add(getINJLabel_Deduct(), null);
			regPanel.add(getINJText_Deduct(), null);
			regPanel.add(getINJLabel_endDate(), null);
			regPanel.add(getINJText_endDate(), null);
			regPanel.add(getINJLabel_CPAmt(), null);
			regPanel.add(getINJCombo_CPAmt(), null);
			regPanel.add(getINJText_CPAmt(), null);
			regPanel.add(getINJLabel_CoveredItem(), null);
			regPanel.add(getINJLabel_Doctor(), null);
			regPanel.add(getINJCheckBox_Doctor(), null);
			regPanel.add(getINJLabel_Hospital(), null);
			regPanel.add(getINJCheckBox_Hspital(), null);
			regPanel.add(getINJLabel_Special(), null);
			regPanel.add(getINJCheckBox_Special(), null);
			regPanel.add(getINJLabel_Other(), null);
			regPanel.add(getINJCheckBox_Other(), null);
			regPanel.add(getINJLabel_FGAmt(), null);
			regPanel.add(getINJText_FGAmt(), null);
			regPanel.add(getINJLabel_FGDate(), null);
			regPanel.add(getINJText_FGDate(), null);
			regPanel.add(getINJLabel_LengthOfStay(), null);
			regPanel.add(getINJText_LengthOfStay(), null);
			regPanel.add(getINJLabel_RevLog(), null);
			regPanel.add(getINJCheckBox_Revlog(), null);
			regPanel.add(getINJLabel_LogCvrCls(), null);
			regPanel.add(getINJCombo_LogCvrCls(), null);
			regPanel.add(getINJLabel_PrtMedRecordRpt(), null);
			regPanel.add(getINJCheckBox_PrtMedRecordRpt(), null);
			regPanel.add(getRegRBPanel(), null);
		}
		return regPanel;
	}

	// registration getter method start
	private FieldSetBase getRegTypePanel() {
		if (RegTypePanel == null) {
			RegTypePanel = new FieldSetBase();
			RegTypePanel.setHeading("Registration Type");
			RegTypePanel.setBounds(5, 5, 370, 130);
//			RegTypePanel.add(getRegTypeGR());
			RegTypePanel.add(getRTJRadio_OutPatient(), null);
			RegTypePanel.add(getRTJLabel_OutPatient(), null);
			RegTypePanel.add(getRTJRadio_InPatient(), null);
			RegTypePanel.add(getRTJLabel_InPatient(), null);
			RegTypePanel.add(getRTJRadio_DayCasePatient(), null);
			RegTypePanel.add(getRTJLabel_DayCasePatient(), null);
			RegTypePanel.add(getRTJLabel_OutPatientType(), null);
			RegTypePanel.add(getRTJText_OutPatientType(), null);
			RegTypePanel.add(getRTCombo_docRoomDesc(), null);
			RegTypePanel.add(getRTCombo_docRoom(), null);
			RegTypePanel.add(getRTCombo_natureDesc(), null);
			RegTypePanel.add(getRTCombo_nature(), null);
			
			
			getRegTypeGR();
		}
		return RegTypePanel;
	}

	private RadioGroup getRegTypeGR() {
		if (RegTypeGR == null) {
			RegTypeGR = new RadioGroup();
			RegTypeGR.add(getRTJRadio_OutPatient());
			RegTypeGR.add(getRTJRadio_InPatient());
			RegTypeGR.add(getRTJRadio_DayCasePatient());
		}
		return RegTypeGR;
	}

	public FieldSetBase getInPatInfoPanel() {
		if (InPatInfoPanel == null) {
			InPatInfoPanel = new FieldSetBase();
			InPatInfoPanel.setHeading("In-Patient Information");
			InPatInfoPanel.setBounds(5, 130, 370, 400);
			InPatInfoPanel.add(getINJLabel_BedNo(), null);
			InPatInfoPanel.add(getINJText_BedNo(), null);
			InPatInfoPanel.add(getINJText_BedIsWindow(), null);
			InPatInfoPanel.add(getINJLabel_DeptCode(), null);
			InPatInfoPanel.add(getINJText_DeptCode(), null);
//			InPatInfoPanel.add(getINJText_BedCharge(), null);
			InPatInfoPanel.add(getINJLabel_WardType(), null);
			InPatInfoPanel.add(getINJText_WardType(), null);
			InPatInfoPanel.add(getINJLabel_AcmCode(), null);
			InPatInfoPanel.add(getINJCombo_AcmCode(), null);
			InPatInfoPanel.add(getINJText_AcmCode(), null);
			InPatInfoPanel.add(getINJLabel_NewBorn(), null);
			InPatInfoPanel.add(getINJCheckBox_NewBorn(), null);
			InPatInfoPanel.add(getINJLabel_Mom(), null);
			InPatInfoPanel.add(getFromMainlandPanel(), null);
			InPatInfoPanel.add(getINJLabel_ADMDoctor(), null);
			InPatInfoPanel.add(getINJText_ADMDoctor(), null);
			InPatInfoPanel.add(getINRJText_ADMDoctor(), null);
			InPatInfoPanel.add(getINJLabel_RefDoctor1(), null);
			 InPatInfoPanel.add(getINJText_RefDoctor1(), null);
			InPatInfoPanel.add(getINRJText_RefDoctor1(), null);
			InPatInfoPanel.add(getINJLabel_RefDoctor2(), null);
			 InPatInfoPanel.add(getINJText_RefDoctor2(), null);
			InPatInfoPanel.add(getINRJText_RefDoctor2(), null);
			InPatInfoPanel.add(getINJLabel_ADMDate(), null);
			InPatInfoPanel.add(getINJText_ADMDate(), null);
			InPatInfoPanel.add(getINJLabel_ADMFrom(), null);
			InPatInfoPanel.add(getINJCombo_ADMFrom(), null);
			InPatInfoPanel.add(getINJLabel_ADMType(), null);
			InPatInfoPanel.add(getINJCombo_ADMType(), null);
			InPatInfoPanel.add(getINJLabel_Remark(), null);
			InPatInfoPanel.add(getINJText_Remark(), null);
			InPatInfoPanel.add(getRightJLabel_SpRqt(), null);
			InPatInfoPanel.add(getRightJCombo_SpRqt(), null);
			InPatInfoPanel.add(getINJLabel_RmExt(), null);
			InPatInfoPanel.add(getINJText_RmExt(), null);
			InPatInfoPanel.add(getINJLabel_Package(), null);
			InPatInfoPanel.add(getINJCombo_Package(), null);
			InPatInfoPanel.add(getPJLabel_EstGiven(), null);
			InPatInfoPanel.add(getPJCheckBox_EstGiven(), null);
			InPatInfoPanel.add(getRightButton_BudgetEst(), null);
			InPatInfoPanel.add(getPJCheckBox_BEDesc(), null);
			InPatInfoPanel.add(getPJCheckBox_BE(), null);
		}
		return InPatInfoPanel;
	}

	private LabelSmallBase getINJLabel_BedNo() {
		if (INJLabel_BedNo == null) {
			INJLabel_BedNo = new LabelSmallBase();
			INJLabel_BedNo.setText("Bed No.");
			INJLabel_BedNo.setBounds(5, 0, 110, 20);
		}
		return INJLabel_BedNo;
	}

	private TextBedSearch getINJText_BedNo() {
		if (INJText_BedNo == null) {
			INJText_BedNo = new TextBedSearch(true, true) {
				@Override
				public void checkTriggerBySearchKey() {
					if (isRegFlag() && getINJText_BedNo().isEditable()) {
						super.checkTriggerBySearchKey();
					}
				}

				@Override
				public void onPressed() {
					if (!memBedCode.equals(getText().trim().toUpperCase())) {
						skipBedChecking = false;
						getINJText_DeptCode().resetText();
						getINJText_WardType().resetText();
						getINJCombo_AcmCode().resetText();
						getINJText_AcmCode().resetText();
						getINJText_RmExt().resetText();
						getINJText_BedIsWindow().resetText();
					}
				}

				@Override
				public void onBlur() {
					// call database to retrieve district
					final String bedNo = getText().trim().toUpperCase();
					if (!EMPTY_VALUE.equals(bedNo) && !bedNo.equals(memBedCode) && !saving) {
						QueryUtil.executeMasterFetch(getUserInfo(), "BED_INF", new String[] { bedNo },
								new MessageQueueCallBack() {
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									if (mQueue.getContentField()[1] == null) {
										Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_WRONG_BEDCODE, getINJText_BedNo());
										getINJText_BedNo().resetText();
										getINJText_DeptCode().resetText();
										getINJText_WardType().resetText();
										getINJCombo_AcmCode().resetText();
										getINJText_AcmCode().resetText();
										getINJText_RmExt().resetText();
										getINJText_BedIsWindow().resetText();
									} else {
										if (mQueue.getContentField()[3] != null &&
												mQueue.getContentField()[3].length() > 0) {
											getINJText_DeptCode().setText(mQueue.getContentField()[1]);
											getINJText_WardType().setText(mQueue.getContentField()[2]);
											getINJCombo_AcmCode().setText(mQueue.getContentField()[3]);
											getINJText_AcmCode().setText(mQueue.getContentField()[4]);
											getINJText_RmExt().setText(mQueue.getContentField()[6]);
											getINJText_BedIsWindow().setText(mQueue.getContentField()[5]);
										}

										QueryUtil.executeMasterBrowse(getUserInfo(), "CHECKBEDSTATUS",
												new String[] {
													ConstantsRegistration.BED_STS_FREE,
													bedNo,
													getRTJText_Sex().getText().trim(),
													CommonUtil.getComputerName(),
													getUserInfo().getUserID()
												},
												new MessageQueueCallBack() {
											@Override
											public void onPostSuccess(MessageQueue mQueue) {
												if (mQueue.success() && getActionType() != null && !saving) {
													if (ConstantsRegistration.BED_NOT_AVAILABLE.equals(mQueue.getContentField()[0])) {
														Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_BED_UNAVAILABLE, getINJText_BedNo());
														getINJText_BedNo().resetText();
														getINJText_DeptCode().resetText();
														getINJText_WardType().resetText();
														getINJCombo_AcmCode().resetText();
														getINJText_AcmCode().resetText();
														getINJText_RmExt().resetText();
														getINJText_BedIsWindow().resetText();
													} else if (ConstantsRegistration.BED_WRONG_SEX.equals(mQueue.getContentField()[0])) {
														MessageBoxBase.confirm(MSG_PBA_SYSTEM, ConstantsMessage.MSG_BED_WRONG_SEX,
																new Listener<MessageBoxEvent>() {
															@Override
															public void handleEvent(MessageBoxEvent be) {
																if (Dialog.NO.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
																	getINJText_BedNo().resetText();
																	getINJText_DeptCode().resetText();
																	getINJText_WardType().resetText();
																	getINJCombo_AcmCode().resetText();
																	getINJText_AcmCode().resetText();
																	getINJText_RmExt().resetText();
																	getINJText_BedIsWindow().resetText();
																	getINJText_BedNo().focus();
																} else {
																	defaultFocus();
																	skipBedChecking = true;
																}
															}
														});
													} else if (ConstantsRegistration.BED_NOT_CLEAN.equals(mQueue.getContentField()[0])) {
														MessageBoxBase.confirm(MSG_PBA_SYSTEM, ConstantsMessage.MSG_BED_UNCLEAN,
																new Listener<MessageBoxEvent>() {
															@Override
															public void handleEvent(MessageBoxEvent be) {
																if (Dialog.NO.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
																	getINJText_BedNo().resetText();
																	getINJText_DeptCode().resetText();
																	getINJText_WardType().resetText();
																	getINJCombo_AcmCode().resetText();
																	getINJText_AcmCode().resetText();
																	getINJText_RmExt().resetText();
																	getINJText_BedIsWindow().resetText();
																	getINJText_BedNo().focus();
																} else {
																	defaultFocus();
																	skipBedChecking = true;
																}
															}
														});
													} else if ("-100".equals(mQueue.getContentField()[0])) {
														MessageBoxBase.confirm(MSG_PBA_SYSTEM, mQueue.getContentField()[1],
																new Listener<MessageBoxEvent>() {
															@Override
															public void handleEvent(MessageBoxEvent be) {
																if (Dialog.NO.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
																	getINJText_BedNo().resetText();
																	getINJText_DeptCode().resetText();
																	getINJText_WardType().resetText();
																	getINJCombo_AcmCode().resetText();
																	getINJText_AcmCode().resetText();
																	getINJText_RmExt().resetText();
																	getINJText_BedIsWindow().resetText();
																	getINJText_BedNo().focus();
																} else {
																	defaultFocus();
																	skipBedChecking = true;
																}
															}
														});
													} else if ("-200".equals(mQueue.getContentField()[0])) {
														Factory.getInstance().addErrorMessage(mQueue.getContentField()[1], getINJText_BedNo());
														getINJText_BedNo().resetText();
														getINJText_DeptCode().resetText();
														getINJText_WardType().resetText();
														getINJCombo_AcmCode().resetText();
														getINJText_AcmCode().resetText();
														getINJText_RmExt().resetText();
														getINJText_BedIsWindow().resetText();
													} else if ("200".equals(mQueue.getContentField()[0])) {
														Factory.getInstance().addErrorMessage(mQueue.getContentField()[1], getINJText_BedNo());
														getINJText_BedNo().resetText();
														getINJText_DeptCode().resetText();
														getINJText_WardType().resetText();
														getINJCombo_AcmCode().resetText();
														getINJText_AcmCode().resetText();
														getINJText_RmExt().resetText();
														getINJText_BedIsWindow().resetText();
													}
													memLockBed = bedNo;
												}
											}
										});
									}
								} else {
									Factory.getInstance().addErrorMessage(MSG_WRONG_BEDCODE, getINJText_BedNo());
									getINJText_BedNo().resetText();
									getINJText_DeptCode().resetText();
									getINJText_WardType().resetText();
									getINJCombo_AcmCode().resetText();
									getINJText_AcmCode().resetText();
									getINJText_RmExt().resetText();
									getINJText_BedIsWindow().resetText();
								}
/*
								if (mQueue.success()) {
									// get first return value and assign to district
									if (REG_TYPE_OUTPATIENT.equals(mQueue.getContentField()[0]) || REG_TYPE_DAYCASE.equals(mQueue.getContentField()[0])) {
										Factory.getInstance().addErrorMessage("The selected bed is unavailable.", getINJText_BedNo());
										getINJText_BedNo().resetText();
										getINJText_DeptCode().resetText();
										getINJText_WardType().resetText();
										getINJCombo_AcmCode().resetText();
										getINJText_AcmCode().resetText();
									} else {
										if (mQueue.getContentField()[3] != null &&
												mQueue.getContentField()[3].length() > 0) {

										}

										getINJText_DeptCode().setText(mQueue.getContentField()[1]);
										getINJText_WardType().setText(mQueue.getContentField()[2]);
										getINJCombo_AcmCode().setText(mQueue.getContentField()[3]);
										getINJText_AcmCode().setText(mQueue.getContentField()[4]);
									}
								} else {
									Factory.getInstance().addErrorMessage(MSG_WRONG_BEDCODE, getINJText_BedNo());
									getINJText_BedNo().resetText();
									getINJText_DeptCode().resetText();
									getINJText_WardType().resetText();
									getINJCombo_AcmCode().resetText();
									getINJText_AcmCode().resetText();
								}
*/
							}
						});
					}
				};
			};
			INJText_BedNo.setBounds(120, 0, 120, 20);
		}
		return INJText_BedNo;
	}

	private TextReadOnly getINJText_BedIsWindow() {
		if (INJText_BedIsWindow == null) {
			INJText_BedIsWindow = new TextReadOnly();
			INJText_BedIsWindow.setBounds(245, 0, 110, 20);
			INJText_BedIsWindow.setVisible(false);
		}
		return INJText_BedIsWindow;
	}

	private LabelSmallBase getINJLabel_DeptCode() {
		if (INJLabel_DeptCode == null) {
			INJLabel_DeptCode = new LabelSmallBase();
			INJLabel_DeptCode.setText("Dept. Code");
			INJLabel_DeptCode.setBounds(5, 25, 110, 20);
		}
		return INJLabel_DeptCode;
	}

	private TextReadOnly getINJText_DeptCode() {
		if (INJText_DeptCode == null) {
			INJText_DeptCode = new TextReadOnly();
			INJText_DeptCode.setBounds(120, 25, 120, 20);
		}
		return INJText_DeptCode;
	}

	private TextReadOnly getINJText_BedCharge() {
		if (INJText_BedCharge == null) {
			INJText_BedCharge = new TextReadOnly();
			INJText_BedCharge.setBounds(242, 25, 120, 20);
		}
		return INJText_BedCharge;
	}

	private LabelSmallBase getINJLabel_WardType() {
		if (INJLabel_WardType == null) {
			INJLabel_WardType = new LabelSmallBase();
			INJLabel_WardType.setText("Ward Code");
			INJLabel_WardType.setBounds(5, 50, 110, 20);
		}
		return INJLabel_WardType;
	}

	private TextReadOnly getINJText_WardType() {
		if (INJText_WardType == null) {
			INJText_WardType = new TextReadOnly();
			INJText_WardType.setBounds(120, 50, 120, 20);
		}
		return INJText_WardType;
	}

	private LabelSmallBase getINJLabel_AcmCode() {
		if (INJLabel_AcmCode == null) {
			INJLabel_AcmCode = new LabelSmallBase();
			INJLabel_AcmCode.setText("Class");
			INJLabel_AcmCode.setBounds(5, 75, 110, 20);
		}
		return INJLabel_AcmCode;
	}

	private ComboACMCode getINJCombo_AcmCode() {
		if (INJCombo_AcmCode == null) {
			INJCombo_AcmCode = new ComboACMCode(getINJText_AcmCode());
			INJCombo_AcmCode.setBounds(120, 75, 80, 20);
		}
		return INJCombo_AcmCode;
	}

	private TextReadOnly getINJText_AcmCode() {
		if (INJText_AcmCode == null) {
			INJText_AcmCode = new TextReadOnly();
			INJText_AcmCode.setBounds(205, 75, 150, 20);
		}
		return INJText_AcmCode;
	}

	private LabelSmallBase getINJLabel_NewBorn() {
		if (INJLabel_NewBorn == null) {
			INJLabel_NewBorn = new LabelSmallBase();
			INJLabel_NewBorn.setText("New Born");
			INJLabel_NewBorn.setBounds(5, 100, 110, 20);
		}
		return INJLabel_NewBorn;
	}

	public CheckBoxBase getINJCheckBox_NewBorn() {
		if (INJCheckBox_NewBorn == null) {
			INJCheckBox_NewBorn = new CheckBoxBase();
			INJCheckBox_NewBorn.setBounds(65, 100, 20, 20);
		}
		return INJCheckBox_NewBorn;
	}

	private LabelSmallBase getINJLabel_Mom() {
		if (INJLabel_Mom == null) {
			INJLabel_Mom = new LabelSmallBase();
			INJLabel_Mom.setText("MOM");
			INJLabel_Mom.setBounds(85, 100, 50, 20);
		}
		return INJLabel_Mom;
	}

	public BasePanel getFromMainlandPanel() {
		if (FromMainlandPanel == null) {
			FromMainlandPanel = new BasePanel();
			FromMainlandPanel.setBounds(120, 100, 235, 20);
			FromMainlandPanel.add(getRTJRadio_Mainland(), null);
			FromMainlandPanel.add(getRTJLabel_Mainland(), null);
			FromMainlandPanel.add(getRTJRadio_NonMainland(), null);
			FromMainlandPanel.add(getRTJLabel_NonMainland(), null);
			FromMainlandPanel.setEtchedBorder();
			getFromMainlandGR();
		}
		return FromMainlandPanel;
	}

	private RadioButtonBase getRTJRadio_Mainland() {
		if (RTJRadio_MainLand == null) {
			RTJRadio_MainLand = new RadioButtonBase();
			RTJRadio_MainLand.setBounds(0, 0, 20, 20);
		}
		return RTJRadio_MainLand;
	}

	private LabelSmallBase getRTJLabel_Mainland() {
		if (RTJLabel_MainLand == null) {
			RTJLabel_MainLand = new LabelSmallBase();
			RTJLabel_MainLand.setText("Mainland");
			RTJLabel_MainLand.setBounds(25, 0, 80, 20);
		}
		return RTJLabel_MainLand;
	}

	private RadioButtonBase getRTJRadio_NonMainland() {
		if (RTJRadio_NonMainland == null) {
			RTJRadio_NonMainland = new RadioButtonBase();
			RTJRadio_NonMainland.setBounds(100, 0, 20, 20);
		}
		return RTJRadio_NonMainland;
	}

	private LabelSmallBase getRTJLabel_NonMainland() {
		if (RTJLabel_NonMainland == null) {
			RTJLabel_NonMainland = new LabelSmallBase();
			RTJLabel_NonMainland.setText("Non-Mainland");
			RTJLabel_NonMainland.setBounds(125, 0, 90, 20);
		}
		return RTJLabel_NonMainland;
	}

	private RadioGroup getFromMainlandGR() {
		if (RTJRadioGroup_FromMainlandGR == null) {
			RTJRadioGroup_FromMainlandGR = new RadioGroup();
//			RTJRadioGroup_FromMainlandGR.setBorders(true);
			RTJRadioGroup_FromMainlandGR.add(getRTJRadio_Mainland());
			RTJRadioGroup_FromMainlandGR.add(getRTJRadio_NonMainland());
		}
		return RTJRadioGroup_FromMainlandGR;
	}

	private LabelSmallBase getINJLabel_ADMDoctor() {
		if (INJLabel_ADMDoctor == null) {
			INJLabel_ADMDoctor = new LabelSmallBase();
			INJLabel_ADMDoctor.setText("Admission Doctor");
			INJLabel_ADMDoctor.setBounds(5, 125, 110, 20);
		}
		return INJLabel_ADMDoctor;
	}

	private TextDoctorSearch getINJText_ADMDoctor() {
		if (INJText_ADMDoctor == null) {
			INJText_ADMDoctor = new TextDoctorSearch(true, true) {
				@Override
				public void onBlur() {
					// call database to retrieve district
					if (!EMPTY_VALUE.equals(getText().trim())) {
						QueryUtil.executeMasterFetch(getUserInfo(), "DOCCODE_EXIST", new String[] { getText() },
								new MessageQueueCallBack() {
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									// get first return value and assign to district
									String DocCode = mQueue.getContentField()[0];
									String docName = mQueue.getContentField()[1];
									if (DocCode != null && DocCode.trim().length() > 0) {
										getINRJText_ADMDoctor().setText(docName);
//										if (getINJText_TreDrCode().getText() == null || getINJText_TreDrCode().isEmpty()) {
											getINJText_TreDrCode().setText(DocCode);
											getINJText_TreDrName().setText(docName);
//										}
									} else {
										Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_WRONG_DOCCODE, INJText_ADMDoctor);
										INJText_ADMDoctor.resetText();
										getINRJText_ADMDoctor().resetText();
									}
								} else {
									Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_WRONG_DOCCODE, INJText_ADMDoctor);
									INJText_ADMDoctor.resetText();
									getINRJText_ADMDoctor().resetText();
								}
							}
						});
					}
				};
			};
			INJText_ADMDoctor.setBounds(120, 125, 74, 20);
		}
		return INJText_ADMDoctor;
	}

	private TextReadOnly getINRJText_ADMDoctor() {
		if (INRJText_ADMDoctor == null) {
			INRJText_ADMDoctor = new TextReadOnly();
			INRJText_ADMDoctor.setBounds(197, 125, 158, 20);
		}
		return INRJText_ADMDoctor;
	}

	private LabelSmallBase getINJLabel_RefDoctor1() {
		if (INJLabel_RefDoctor1 == null) {
			INJLabel_RefDoctor1 = new LabelSmallBase();
			INJLabel_RefDoctor1.setText("Referred Doctor");
			INJLabel_RefDoctor1.setBounds(5, 125, 110, 20);
			INJLabel_RefDoctor1.setVisible(false);
		}
		return INJLabel_RefDoctor1;
	}

	private TextDoctorSearch getINJText_RefDoctor1() {
		if (INJText_RefDoctor1 == null) {
			INJText_RefDoctor1 = new TextDoctorSearch(true, true) {
				@Override
				public void onBlur() {
					// call database to retrieve district
					if (!EMPTY_VALUE.equals(getText().trim())) {
						QueryUtil.executeMasterFetch(getUserInfo(), "DOCCODE_EXIST", new String[] { getText() },
								new MessageQueueCallBack() {
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									// get first return value and assign to district
									String DocCode = mQueue.getContentField()[0];
									String docName = mQueue.getContentField()[1];
									if (DocCode != null && DocCode.trim().length() > 0) {
										getINRJText_RefDoctor1().setText(docName);

									} else {
										Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_WRONG_DOCCODE, INJText_ADMDoctor);
										INJText_RefDoctor1.resetText();
										getINRJText_RefDoctor1().resetText();
									}
								} else {
									Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_WRONG_DOCCODE, INJText_ADMDoctor);
									INJText_RefDoctor1.resetText();
									getINRJText_RefDoctor1().resetText();
								}
							}
						});
					}
				};
			};
			INJText_RefDoctor1.setBounds(120, 125, 74, 20);
			INJText_RefDoctor1.setVisible(false);
		}
		return INJText_RefDoctor1;
	}

	private TextReadOnly getINRJText_RefDoctor1() {
		if (INRJText_RefDoctor1 == null) {
			INRJText_RefDoctor1 = new TextReadOnly();
			INRJText_RefDoctor1.setBounds(197, 125, 158, 20);
			INRJText_RefDoctor1.setVisible(false);
		}
		return INRJText_RefDoctor1;
	}

	private LabelSmallBase getINJLabel_RefDoctor2() {
		if (INJLabel_RefDoctor2 == null) {
			INJLabel_RefDoctor2 = new LabelSmallBase();
			INJLabel_RefDoctor2.setText("Referred Doctor");
			INJLabel_RefDoctor2.setBounds(5, 150, 110, 20);
			INJLabel_RefDoctor2.setVisible(false);
		}
		return INJLabel_RefDoctor2;
	}

	private TextDoctorSearch getINJText_RefDoctor2() {
		if (INJText_RefDoctor2 == null) {
			INJText_RefDoctor2 = new TextDoctorSearch(true, true) {
				@Override
				public void onBlur() {
					// call database to retrieve district
					if (!EMPTY_VALUE.equals(getText().trim())) {
						QueryUtil.executeMasterFetch(getUserInfo(), "DOCCODE_EXIST", new String[] { getText() },
								new MessageQueueCallBack() {
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									// get first return value and assign to district
									String DocCode = mQueue.getContentField()[0];
									String docName = mQueue.getContentField()[1];
									if (DocCode != null && DocCode.trim().length() > 0) {
										getINRJText_RefDoctor2().setText(docName);

									} else {
										Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_WRONG_DOCCODE, INJText_ADMDoctor);
										INJText_RefDoctor2.resetText();
										getINRJText_RefDoctor2().resetText();
									}
								} else {
									Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_WRONG_DOCCODE, INJText_ADMDoctor);
									INJText_RefDoctor2.resetText();
									getINRJText_RefDoctor2().resetText();
								}
							}
						});
					}
				};
			};
			INJText_RefDoctor2.setBounds(120, 150, 74, 20);
			INJText_RefDoctor2.setVisible(false);
		}
		return INJText_RefDoctor2;
	}

	private TextReadOnly getINRJText_RefDoctor2() {
		if (INRJText_RefDoctor2 == null) {
			INRJText_RefDoctor2 = new TextReadOnly();
			INRJText_RefDoctor2.setBounds(197, 150, 158, 20);
			INRJText_RefDoctor2.setVisible(false);
		}
		return INRJText_RefDoctor2;
	}

	private LabelSmallBase getINJLabel_ADMDate() {
		if (INJLabel_ADMDate == null) {
			INJLabel_ADMDate = new LabelSmallBase();
			INJLabel_ADMDate.setText("Admission Date");
			INJLabel_ADMDate.setBounds(5, 150, 110, 20);
		}
		return INJLabel_ADMDate;
	}

	private TextDateTimeWithoutSecond getINJText_ADMDate() {
		if (INJText_ADMDate == null) {
			INJText_ADMDate = new TextDateTimeWithoutSecond() {
				@Override
				public void onBlur() {
					super.onBlur();
					if (!isEmpty() && !isValid()) {
						Factory.getInstance().addErrorMessage("Invalid Date.", INJText_ADMDate);
						resetText();
						return;
					} else if (DateTimeUtil.dateDiff(getText(), getMainFrame().getServerDateTime()) > 0) {
						Factory.getInstance().addErrorMessage("Admission date is a future date.", this);
						resetText();
						return;
					}

					getINJText_RegDate().setText(getINJText_ADMDate().getText());
				};
			};
			INJText_ADMDate.setBounds(120, 150, 235, 20);
		}
		return INJText_ADMDate;
	}

	private LabelSmallBase getINJLabel_ADMFrom() {
		if (INJLabel_ADMFrom == null) {
			INJLabel_ADMFrom = new LabelSmallBase();
			INJLabel_ADMFrom.setText("Admission From");
			INJLabel_ADMFrom.setBounds(5, 175, 110, 20);
		}
		return INJLabel_ADMFrom;
	}

	private ComboSource getINJCombo_ADMFrom() {
		if (INJCombo_ADMFrom == null) {
			INJCombo_ADMFrom = new ComboSource();
			INJCombo_ADMFrom.setBounds(120, 175, 235, 20);
		}
		return INJCombo_ADMFrom;
	}

	private LabelSmallBase getINJLabel_ADMType() {
		if (INJLabel_ADMType == null) {
			INJLabel_ADMType = new LabelSmallBase();
			INJLabel_ADMType.setText("Admission Type");
			INJLabel_ADMType.setBounds(5, 200, 110, 20);
		}
		return INJLabel_ADMType;
	}

	private ComboADMType getINJCombo_ADMType() {
		if (INJCombo_ADMType == null) {
			INJCombo_ADMType = new ComboADMType();
			INJCombo_ADMType.setBounds(120, 200, 235, 20);
		}
		return INJCombo_ADMType;
	}

	private LabelSmallBase getINJLabel_Remark() {
		if (INJLabel_Remark == null) {
			INJLabel_Remark = new LabelSmallBase();
			INJLabel_Remark.setText("In-patient Remark");
			INJLabel_Remark.setBounds(5, 225, 110, 20);
		}
		return INJLabel_Remark;
	}

	private TextString getINJText_Remark() {
		if (INJText_Remark == null) {
			INJText_Remark = new TextString(40, true);
			INJText_Remark.setBounds(120, 225, 235, 20);
		}
		return INJText_Remark;
	}

	private LabelSmallBase getRightJLabel_SpRqt() {
		if (INJLabel_SpRqt == null) {
			INJLabel_SpRqt = new LabelSmallBase();
			INJLabel_SpRqt.setText("Special Request");
			INJLabel_SpRqt.setBounds(5, 250, 110, 20);
			INJLabel_SpRqt.setVisible(false);
		}
		return INJLabel_SpRqt;
	}

	private ComboBoxBase getRightJCombo_SpRqt() {
		if (INJCombo_SpRqt == null) {
			INJCombo_SpRqt = new ComboBoxBase("INPSPRQT", false, false, true);
			INJCombo_SpRqt.setBounds(120, 250, 120, 20);
			INJCombo_SpRqt.setVisible(false);
		}
		return INJCombo_SpRqt;
	}

	private LabelSmallBase getINJLabel_RmExt() {
		if (INJLabel_RmExt == null) {
			INJLabel_RmExt = new LabelSmallBase();
			INJLabel_RmExt.setText("Rm Ext.");
			INJLabel_RmExt.setBounds(245, 250, 50, 20);
			INJLabel_RmExt.setVisible(false);
		}
		return INJLabel_RmExt;
	}

	private TextReadOnly getINJText_RmExt() {
		if (INJText_RmExt == null) {
			INJText_RmExt = new TextReadOnly();
			INJText_RmExt.setBounds(295, 250, 60, 20);
			INJText_RmExt.setVisible(false);
		}
		return INJText_RmExt;
	}

	private LabelSmallBase getINJLabel_Package() {
		if (INJLabel_Package == null) {
			INJLabel_Package = new LabelSmallBase();
			INJLabel_Package.setText("Package");
			INJLabel_Package.setBounds(5, 275, 20, 20);
			INJLabel_Package.setVisible(false);
		}
		return INJLabel_Package;
	}

	private ComboBoxBase getINJCombo_Package() {
		if (INJCombo_Package == null) {
			INJCombo_Package = new ComboBoxBase("BPBPKG", false, false, true);
			INJCombo_Package.setBounds(120, 275, 235, 20);
			INJCombo_Package.setVisible(false);
		}
		return INJCombo_Package;
	}

	public LabelSmallBase getPJLabel_EstGiven() {
		if (PJLabel_EstGiven == null) {
			PJLabel_EstGiven = new LabelSmallBase();
			PJLabel_EstGiven.setText("Est. given");
			PJLabel_EstGiven.setBounds(5, 300, 70, 13);
			PJLabel_EstGiven.setVisible(false);

		}
		return PJLabel_EstGiven;
	}

	public CheckBoxBase getPJCheckBox_EstGiven() {
		if (PJCheckBox_EstGiven == null) {
			PJCheckBox_EstGiven = new CheckBoxBase();
			PJCheckBox_EstGiven.setBounds(65, 300, 20, 20);
			PJCheckBox_EstGiven.setVisible(false);
		}
		return PJCheckBox_EstGiven;
	}

	private ButtonBase getRightButton_BudgetEst() {
		if (RightButton_BudgetEst == null) {
			RightButton_BudgetEst = new ButtonBase() {
				@Override
				public void onClick() {
					getDlgBudgetEst().showDialog(mem_FESTID,"TxnDtl",getINJText_SLPNO().getText(),memPatNo,memPatFName+" "+memPatGName,getINJText_ADMDoctor().getText());
				}
			};
			RightButton_BudgetEst.setText("Budget Estimation");
			RightButton_BudgetEst.setVisible(false);
			RightButton_BudgetEst.setEnabled(false);
			RightButton_BudgetEst.setBounds(120, 300, 120, 22);
		}
		return RightButton_BudgetEst;
	}

	private DlgBudgetEstBase getDlgBudgetEst() {
		if (dlgBudgetEst == null) {
			dlgBudgetEst = new DlgBudgetEstBase(getMainFrame()) {
				@Override
				public void post(String srcNo,boolean isBE) {
					mem_FESTID = srcNo;
					if (isBE) {
						getRightButton_BudgetEst().el().addStyleName("button-alert-green");
					} else {
						getRightButton_BudgetEst().el().removeStyleName("button-alert-green");
					}
					getPJCheckBox_BE().setSelected(isBE);
				}
			};
		}
		return dlgBudgetEst;
	}

	private DlgPatSecCheck getDlgPatSecCheck(final String actionType) {
		if (dlgPatSecCheck == null) {
			dlgPatSecCheck = new DlgPatSecCheck(getMainFrame()) {
				@Override
				public void post(boolean result) {
					isConfirmPatInfChg = result;
					if (isConfirmPatInfChg) {
						callActionValidationReady(actionType, true);
					}
				}
			};
		}
		return dlgPatSecCheck;
	}

	protected LabelSmallBase getPJCheckBox_BEDesc() {
		if (PJCheckBox_BEDesc == null) {
			PJCheckBox_BEDesc = new LabelSmallBase();
			PJCheckBox_BEDesc.setText("*BE");
			PJCheckBox_BEDesc.setBounds(245, 300, 20, 20);
			PJCheckBox_BEDesc.setVisible(false);

		}
		return PJCheckBox_BEDesc;
	}

	protected CheckBoxBase getPJCheckBox_BE() {
		if (PJCheckBox_BE == null) {
			PJCheckBox_BE = new CheckBoxBase();
			PJCheckBox_BE.setBounds(270, 300, 20, 20);
			PJCheckBox_BE.setVisible(false);
		}
		return PJCheckBox_BE;
	}

	private LabelSmallBase getINJLabel_MedRec() {
		if (INJLabel_MedRec == null) {
			INJLabel_MedRec = new LabelSmallBase();
			INJLabel_MedRec.setText("Med. Rec.");
			INJLabel_MedRec.setBounds(380, 5, 90, 20);
		}
		return INJLabel_MedRec;
	}

	private TextReadOnly getINJText_Med() {
		if (INJText_Med == null) {
			INJText_Med = new TextReadOnly();
			INJText_Med.setBounds(455, 5, 125, 20);
		}
		return INJText_Med;
	}

	private TextReadOnly getINJText_Rec() {
		if (INJText_Rec == null) {
			INJText_Rec = new TextReadOnly();
			INJText_Rec.setBounds(585, 5, 125, 20);
		}
		return INJText_Rec;
	}

	private ButtonBase getINButton_MedRecDetail() {
		if (INButton_MedRecDetail == null) {
			INButton_MedRecDetail = new ButtonBase() {
				@Override
				public void onClick() {
					getDlgMedicalRecord().showDialog(getRTJText_PatientNumber().getText().trim());
				}
			};
			INButton_MedRecDetail.setText("View", 'V');
			INButton_MedRecDetail.setBounds(712, 5, 50, 23);
		}
		return INButton_MedRecDetail;
	}

	private ButtonBase getINButton_MedRec() {
		if (INButton_MedRec == null) {
			INButton_MedRec = new ButtonBase() {
				@Override
				public void onClick() {
					String regType = getCurrentRegistrationType();
					String sRegCat = getRegCat(getRegistrationMode());
					addMedicalRecord(isAppend()? QueryUtil.ACTION_APPEND : QueryUtil.ACTION_MODIFY,
										0, "R", regType, getRTJText_PatientNumber().getText(),
										getUserInfo().getSiteCode(), getINJText_TreDrCode().getText(),
										null, getINJText_BedNo().getText(), sRegCat,
										getUserInfo().getUserID(),0, 0, 1, null);
				}
			};
			INButton_MedRec.setText("+");
			INButton_MedRec.setBounds(765, 5, 20, 23);
		}
		return INButton_MedRec;
	}

	private LabelSmallBase getINJLabel_SLPNO() {
		if (INJLabel_SLPNO == null) {
			INJLabel_SLPNO = new LabelSmallBase();
			INJLabel_SLPNO.setText("Slip Number");
			INJLabel_SLPNO.setBounds(380, 30, 90, 20);
		}
		return INJLabel_SLPNO;
	}

	private TextReadOnly getINJText_SLPNO() {
		if (INJText_SLPNO == null) {
			INJText_SLPNO = new TextReadOnly();
			INJText_SLPNO.setBounds(455, 30, 82, 20);
		}
		return INJText_SLPNO;
	}

	private ButtonBase getINButton_SlipDetail() {
		if (INButton_SlipDetail == null) {
			INButton_SlipDetail = new ButtonBase() {
				@Override
				public void onClick() {
					if (!getINJText_SLPNO().isEmpty()) {
						showTransactions();
					}
				}
			};
			INButton_SlipDetail.setText("View");
			INButton_SlipDetail.setBounds(540, 30, 40, 20);
		}
		return INButton_SlipDetail;
	}

	private LabelSmallBase getINJLabel_RDate() {
		if (INJLabel_RDate == null) {
			INJLabel_RDate = new LabelSmallBase();
			INJLabel_RDate.setText("Reg.Date");
			INJLabel_RDate.setBounds(585, 30, 60, 20);
		}
		return INJLabel_RDate;
	}

	private TextDateTimeWithoutSecond getINJText_RegDate() {
		if (INJText_RegDate == null) {
			INJText_RegDate = new TextDateTimeWithoutSecond() {
				@Override
				public void onBlur() {
					super.onBlur();
					if (!isEmpty() && !isValid()) {
						Factory.getInstance().addErrorMessage("Invalid date.", INJText_RegDate);
						resetText();
						return;
					}

					getINJText_ADMDate().setText(getText());
				}

				@Override
				public void setText(String value) {
					super.setText(value);
					getINJCombo_ARC().getLoader().load();
				}
			};
			INJText_RegDate.setBounds(640, 30, 145, 20);
		}
		return INJText_RegDate;
	}

	private LabelSmallBase getINJLabel_Category() {
		if (INJLabel_Category == null) {
			INJLabel_Category = new LabelSmallBase();
			INJLabel_Category.setText("Category");
			INJLabel_Category.setBounds(380, 55, 90, 20);
		}
		return INJLabel_Category;
	}

	private ComboCategory getINJCombo_Category() {
		if (INJCombo_Category == null) {
			INJCombo_Category = new ComboCategory(getINJText_Category());
			INJCombo_Category.setBounds(455, 55, 65, 20);
		}
		return INJCombo_Category;
	}

	private TextReadOnly getINJText_Category() {
		if (INJText_Category == null) {
			INJText_Category = new TextReadOnly();
			INJText_Category.setBounds(525, 55, 55, 20);
		}
		return INJText_Category;
	}

	private LabelSmallBase getINJLabel_Ref() {
		if (INJLabel_Ref == null) {
			INJLabel_Ref = new LabelSmallBase();
			INJLabel_Ref.setText("Ref #");
			INJLabel_Ref.setBounds(585, 55, 60, 20);
		}
		return INJLabel_Ref;
	}

	private TextString getINJText_Ref() {
		if (INJText_Ref == null) {
			INJText_Ref = new TextString(10, true);
			INJText_Ref.setBounds(640, 55, 145, 20);
		}
		return INJText_Ref;
	}

	private LabelSmallBase getINJLabel_Source() {
		if (INJLabel_Source == null) {
			INJLabel_Source = new LabelSmallBase();
			INJLabel_Source.setText("Src");
			INJLabel_Source.setBounds(380, 80, 90, 20);
			INJLabel_Source.setVisible(true);
		}
		return INJLabel_Source;
	}

	private ComboBoxBase getINJCombo_Source() {
		if (INJCombo_Source == null) {
			INJCombo_Source = new ComboBoxBase("TRANSSRC", false, false, true);
			INJCombo_Source.setBounds(455, 80, 330, 20);
			INJCombo_Source.setMinListWidth(150);
			INJCombo_Source.setVisible(true);
		}
		return INJCombo_Source;
	}

	private LabelSmallBase getINJLabel_SourceNo() {
		if (INJLabel_SourceNo == null) {
			INJLabel_SourceNo = new LabelSmallBase();
			INJLabel_SourceNo.setText("Src #");
			INJLabel_SourceNo.setBounds(520, 80, 40, 20);
			INJLabel_SourceNo.setVisible(false);
		}
		return INJLabel_SourceNo;
	}

	private TextString getINJText_SourceNo() {
		if (INJText_SourceNo == null) {
			INJText_SourceNo = new TextString(20);
			INJText_SourceNo.setBounds(558, 80, 100, 20);
			INJText_SourceNo.setVisible(false);
		}
		return INJText_SourceNo;
	}

	public LabelSmallBase getRightJLabel_Misc() {
		if (RightJLabel_Misc == null) {
			RightJLabel_Misc = new LabelSmallBase();
			RightJLabel_Misc.setText("Rmk");
			RightJLabel_Misc.setBounds(660, 80, 25, 20);
			RightJLabel_Misc.setVisible(false);
		}
		return RightJLabel_Misc;
	}

	public ComboBoxBase getRightJCombo_Misc() {
		if (RightJCombo_Misc == null) {
			RightJCombo_Misc = new ComboBoxBase("TRANSMISC", false, false, true);
			RightJCombo_Misc.setBounds(695, 80, 90, 20);
			RightJCombo_Misc.setVisible(false);
		}
		return RightJCombo_Misc;
	}

	private LabelSmallBase getINJLabel_ARC() {
		if (INJLabel_ARC == null) {
			INJLabel_ARC = new LabelSmallBase();
			INJLabel_ARC.setText("AR Company");
			INJLabel_ARC.setBounds(380, 105, 90, 20);
		}
		return INJLabel_ARC;
	}

	@SuppressWarnings("unchecked")
	private ComboARCompany getINJCombo_ARC() {
		if (INJCombo_ARC == null) {
			INJCombo_ARC = new ComboARCompany(true) {
				@Override
				protected String getTxFrom() {
					return "RegPatReg";
				}

				@Override
				protected String getTxDate() {
					if (((getINJText_RegDate().isEditable()) ||
							(!getINJText_RegDate().isEditable()&& REG_TYPE_INPATIENT.equals(getCurrentRegistrationType()))) &&
							!QueryUtil.ACTION_MODIFY.equals(getActionTypeRegistration())) {
						String checkDate = getINJText_RegDate().getText().trim();
						if (checkDate.length() > 10) {
							return checkDate.substring(0, 10);
						} else {
							return checkDate;
						}
					} else {
						return null;
					}
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
								(Factory.getInstance().getSysParameter("ArBlockEvt").equals(getText()) ||
								(currentArcCode != null && Factory.getInstance().getSysParameter("ArBlockEvt").equals(currentArcCode)))) {
							return;
						}

						if (!isEmpty()) {
							setARValue(getText(), getINJText_ADMDate().getText());
						} else {
							resetAllowEntryAR();
						}
					}
				}

				@Override
				protected void clearPostAction() {
					if (currentArcCode == null) {
						resetAllowEntryAR();
						setAllowEntryAR();
					}
				}

				@Override
				public void setText(String key, boolean allowUpdate) {
					super.setText(key, allowUpdate);
					setAllowEntryAR();
				}
			};
//			INJCombo_ARC.setShowTextPanel(getINJText_ARC());
			INJCombo_ARC.setBounds(455, 105, 100, 20);
		}
		return INJCombo_ARC;
	}

	private TextReadOnly getINJText_ARC() {
		if (INJText_ARC == null) {
			INJText_ARC = new TextReadOnly();
			INJText_ARC.setBounds(558, 105, 133, 20);
		}
		return INJText_ARC;
	}

	private TextReadOnly getINJText_ARCardType() {
		if (INJText_ARCardType == null) {
			INJText_ARCardType = new TextReadOnly();
			INJText_ARCardType.setBounds(695, 105, 90, 20);
		}
		return INJText_ARCardType;
	}

	private LabelSmallBase getINJLabel_PLNO() {
		if (INJLabel_PLNO == null) {
			INJLabel_PLNO = new LabelSmallBase();
			INJLabel_PLNO.setText("Policy No");
			INJLabel_PLNO.setBounds(380, 130, 90, 20);
		}
		return INJLabel_PLNO;
	}

	private TextString getINJText_PLNO() {
		if (INJText_PLNO == null) {
			INJText_PLNO = new TextString(40, true);
			INJText_PLNO.setBounds(455, 130, 80, 20);
		}
		return INJText_PLNO;
	}

	private LabelSmallBase getINJLabel_VHNO() {
		if (INJLabel_VHNO == null) {
			INJLabel_VHNO = new LabelSmallBase();
			INJLabel_VHNO.setText("Vchr #");
			INJLabel_VHNO.setBounds(540, 130, 90, 20);
		}
		return INJLabel_VHNO;
	}

	private TextString getINJText_VHNO() {
		if (INJText_VHNO == null) {
			INJText_VHNO = new TextString(40, true);
			INJText_VHNO.setBounds(580, 130, 60, 20);
		}
		return INJText_VHNO;
	}

	private LabelSmallBase getINJLabel_PreAuthNo() {
		if (INJLabel_PreAuthNo == null) {
			INJLabel_PreAuthNo = new LabelSmallBase();
			INJLabel_PreAuthNo.setText("Auth #");
			INJLabel_PreAuthNo.setBounds(644, 130, 80, 20);
		}
		return INJLabel_PreAuthNo;
	}

	private TextString getINJText_PreAuthNo() {
		if (INJText_PreAuthNo == null) {
			INJText_PreAuthNo = new TextString(20, true);
			INJText_PreAuthNo.setBounds(695, 130, 90, 20);
		}
		return INJText_PreAuthNo;
	}

	private LabelSmallBase getINJLabel_LAmt() {
		if (INJLabel_LAmt == null) {
			INJLabel_LAmt = new LabelSmallBase();
			INJLabel_LAmt.setText("Limit Amt.");
			INJLabel_LAmt.setBounds(380, 155, 90, 20);
		}
		return INJLabel_LAmt;
	}

	private TextAmount getINJText_LAmt() {
		if (INJText_LAmt == null) {
			INJText_LAmt = new TextAmount() {
				@Override
				public void onBlur() {
					if (!isEmpty()) {
						if (!TextUtil.isInteger(INJText_LAmt.getText().toString())) {
							Factory.getInstance().addErrorMessage("Please enter a integer Limit Amount.", INJText_LAmt);
							INJText_LAmt.setText(ZERO_VALUE);
							return;
						}

						getINJText_FGAmt().setText(calFurGrtAmt(INJText_LAmt.getText()));
					}
				}
			};
			INJText_LAmt.setBounds(455, 155, 80, 20);

		}
		return INJText_LAmt;
	}

	private LabelSmallBase getINJLabel_Deduct() {
		if (INJLabel_Deduct == null) {
			INJLabel_Deduct = new LabelSmallBase();
			INJLabel_Deduct.setText("Deduct");
			INJLabel_Deduct.setBounds(540, 155, 90, 20);
		}
		return INJLabel_Deduct;
	}

	private TextAmount getINJText_Deduct() {
		if (INJText_Deduct == null) {
			INJText_Deduct = new TextAmount();
			INJText_Deduct.setBounds(580, 155, 60, 20);
		}
		return INJText_Deduct;
	}

	private LabelSmallBase getINJLabel_endDate() {
		if (INJLabel_endDate == null) {
			INJLabel_endDate = new LabelSmallBase();
			INJLabel_endDate.setText("End Date");
			INJLabel_endDate.setBounds(644, 155, 80, 20);
		}
		return INJLabel_endDate;
	}

	private TextDate getINJText_endDate() {
		if (INJText_endDate == null) {
			INJText_endDate = new TextDate() {
				@Override
				public void onBlur() {
					if (!isEmpty()) {
						if (!isValid()) {
							Factory.getInstance().addErrorMessage("The End Date is Invalid.", INJText_endDate);
							return;
						}

						if (getINJText_FGDate().isEmpty()) {
							getINJText_FGDate().setText(calFurGrtDate(INJText_endDate.getText()));
						}
					}
				}
			};
			INJText_endDate.setBounds(695, 155, 90, 20);
		}
		return INJText_endDate;
	}

	private LabelSmallBase getINJLabel_CPAmt() {
		if (INJLabel_CPAmt == null) {
			INJLabel_CPAmt = new LabelSmallBase();
			INJLabel_CPAmt.setText("Co-Pay");
			INJLabel_CPAmt.setBounds(380, 180, 90, 20);
		}
		return INJLabel_CPAmt;
	}

	private ComboCoPayRefType getINJCombo_CPAmt() {
		if (INJCombo_CPAmt == null) {
			INJCombo_CPAmt = new ComboCoPayRefType() {
				@Override
				protected void setTextPanel(ModelData modelData) {
					if (getText().trim().isEmpty()) {
						getINJText_CPAmt().setText(ZERO_VALUE);
					}
				}
			};
			INJCombo_CPAmt.setBounds(455, 180, 50, 20);
		}
		return INJCombo_CPAmt;
	}

	private TextAmount getINJText_CPAmt() {
		if (INJText_CPAmt == null) {
			INJText_CPAmt = new TextAmount() {
				@Override
				public void onBlur() {
					if (!INJText_CPAmt.isEmpty() && !TextUtil.isInteger(getText().toString())) {
						Factory.getInstance().addErrorMessage("Please enter a integer Co-Payment Amount.", INJText_CPAmt);
						INJText_CPAmt.setText(ZERO_VALUE);
					}
				}
			};
			INJText_CPAmt.setBounds(510, 180, 45, 20);
		}
		return INJText_CPAmt;
	}

	private LabelSmallBase getINJLabel_CoveredItem() {
		if (INJLabel_CoveredItem == null) {
			INJLabel_CoveredItem = new LabelSmallBase();
			INJLabel_CoveredItem.setText("Covered Item");
			INJLabel_CoveredItem.setBounds(560, 180, 90, 20);
		}
		return INJLabel_CoveredItem;
	}

	private LabelSmallBase getINJLabel_Doctor() {
		if (INJLabel_Doctor == null) {
			INJLabel_Doctor = new LabelSmallBase();
			INJLabel_Doctor.setText("Doctor");
			INJLabel_Doctor.setBounds(650, 180, 50, 20);
		}
		return INJLabel_Doctor;
	}

	public CheckBoxBase getINJCheckBox_Doctor() {
		if (INJCheckBox_Doctor == null) {
			INJCheckBox_Doctor = new CheckBoxBase();
			INJCheckBox_Doctor.setBounds(690, 180, 20, 20);
		}
		return INJCheckBox_Doctor;
	}

	private LabelSmallBase getINJLabel_Hospital() {
		if (INJLabel_Hospital == null) {
			INJLabel_Hospital = new LabelSmallBase();
			INJLabel_Hospital.setText("Hospital");
			INJLabel_Hospital.setBounds(725, 180, 50, 20);
		}
		return INJLabel_Hospital;
	}

	public CheckBoxBase getINJCheckBox_Hspital() {
		if (INJCheckBox_Hspital == null) {
			INJCheckBox_Hspital = new CheckBoxBase();
			INJCheckBox_Hspital.setBounds(770, 180, 20, 20);
		}
		return INJCheckBox_Hspital;
	}

	private LabelSmallBase getINJLabel_Special() {
		if (INJLabel_Special == null) {
			INJLabel_Special = new LabelSmallBase();
			INJLabel_Special.setText("Special");
			INJLabel_Special.setBounds(650, 205, 50, 20);
		}
		return INJLabel_Special;
	}

	public CheckBoxBase getINJCheckBox_Special() {
		if (INJCheckBox_Special == null) {
			INJCheckBox_Special = new CheckBoxBase();
			INJCheckBox_Special.setBounds(690, 205, 20, 20);
		}
		return INJCheckBox_Special;
	}

	private LabelSmallBase getINJLabel_Other() {
		if (INJLabel_Other == null) {
			INJLabel_Other = new LabelSmallBase();
			INJLabel_Other.setText("Other");
			INJLabel_Other.setBounds(725, 205, 50, 20);
		}
		return INJLabel_Other;
	}

	public CheckBoxBase getINJCheckBox_Other() {
		if (INJCheckBox_Other == null) {
			INJCheckBox_Other = new CheckBoxBase();
			INJCheckBox_Other.setBounds(770, 205, 20, 20);
		}
		return INJCheckBox_Other;
	}

	private LabelSmallBase getINJLabel_FGAmt() {
		if (INJLabel_FGAmt == null) {
			INJLabel_FGAmt = new LabelSmallBase();
			INJLabel_FGAmt.setText("Fur. Gu. Amt");
			INJLabel_FGAmt.setBounds(380, 205, 90, 20);
		}
		return INJLabel_FGAmt;
	}

	private TextAmount getINJText_FGAmt() {
		if (INJText_FGAmt == null) {
			INJText_FGAmt = new TextAmount() {
				@Override
				public void onBlur() {
					if (!INJText_FGAmt.isEmpty()) {
						if (!TextUtil.isInteger(getText().toString())) {
							Factory.getInstance().addErrorMessage("Please enter a integer Further Guarantee Amount.", this);
							INJText_FGAmt.setText(ZERO_VALUE);
							return;
						}
					}
				}
			};
			INJText_FGAmt.setBounds(455, 205, 100, 20);
		}
		return INJText_FGAmt;
	}

	private LabelSmallBase getINJLabel_PrtMedRecordRpt() {
		if (INJLabel_PrtMedRecordRpt == null) {
			INJLabel_PrtMedRecordRpt = new LabelSmallBase();
			INJLabel_PrtMedRecordRpt.setText("Print MR");
			INJLabel_PrtMedRecordRpt.setBounds(560, 205, 50, 20);
		}
		return INJLabel_PrtMedRecordRpt;
	}

	public CheckBoxBase getINJCheckBox_PrtMedRecordRpt() {
		if (INJCheckBox_PrtMedRecordRpt == null) {
			INJCheckBox_PrtMedRecordRpt = new CheckBoxBase();
			INJCheckBox_PrtMedRecordRpt.setBounds(620, 205, 20, 20);
		}
		return INJCheckBox_PrtMedRecordRpt;
	}

	private LabelSmallBase getINJLabel_FGDate() {
		if (INJLabel_FGDate == null) {
			INJLabel_FGDate = new LabelSmallBase();
			INJLabel_FGDate.setText("Fur. Gu. Date");
			INJLabel_FGDate.setBounds(380, 230, 90, 20);
		}
		return INJLabel_FGDate;
	}

	private TextDate getINJText_FGDate() {
		if (INJText_FGDate == null) {
			INJText_FGDate = new TextDate() {
				@Override
				public void onBlur() {
					if (!isEmpty() && !isValid()) {
						Factory.getInstance().addErrorMessage("The Fur.Gu.Date is Invalid.", this);
						return;
					}
				}
			};
			INJText_FGDate.setBounds(455, 230, 100, 20);
		}
		return INJText_FGDate;
	}

	private LabelSmallBase getINJLabel_LengthOfStay() {
		if (INJLabel_LengthOfStay == null) {
			INJLabel_LengthOfStay = new LabelSmallBase();
			INJLabel_LengthOfStay.setText("Length of Stay");
			INJLabel_LengthOfStay.setBounds(570, 230, 100, 20);
		}
		return INJLabel_LengthOfStay;
	}

	private TextString getINJText_LengthOfStay() {
		if (INJText_LengthOfStay == null) {
			INJText_LengthOfStay = new TextString(4, true) {
				@Override
				public void onBlur() {
					String lengthOfStay = getSysParameter("ACTSTAYLEN");
					double dDayStay = 0;
					long lDayStay = 0;

					if (!INJText_LengthOfStay.isEmpty()) {
						if (!TextUtil.isInteger(INJText_LengthOfStay.getText().toString())) {
							Factory.getInstance().addErrorMessage("Please enter a integer Length of Stay.", INJText_LengthOfStay);
							return;
						} else {
							dDayStay = Math.round(Double.valueOf(INJText_LengthOfStay.getText().toString()));
							lDayStay = (long)dDayStay;
							if (lDayStay < 0) {
								Factory.getInstance().addErrorMessage("Length of Stay should be > 0.", INJText_LengthOfStay);
								return;
							} else {
								INJText_LengthOfStay.setText(Long.toString(lDayStay));
							}
						}
					} else if (lengthOfStay != null && lengthOfStay.length() > 0 && YES_VALUE.equals(lengthOfStay)) {
						Factory.getInstance().addErrorMessage("Length of Stay should be > 0.", INJText_LengthOfStay);
						return;
					}
				}
			};
			INJText_LengthOfStay.setBounds(655, 230, 130, 20);
		}
		return INJText_LengthOfStay;
	}

	public LabelSmallBase getINJLabel_RevLog() {
		if (INJLabel_RevLog == null) {
			INJLabel_RevLog = new LabelSmallBase();
			INJLabel_RevLog.setText("Rec'd LOG");
			INJLabel_RevLog.setBounds(560, 230, 60, 13);
			INJLabel_RevLog.setVisible(false);
		}
		return INJLabel_RevLog;
	}

	public CheckBoxBase getINJCheckBox_Revlog() {
		if (INJCheckBox_RevLog == null) {
			INJCheckBox_RevLog = new CheckBoxBase();
			INJCheckBox_RevLog.setBounds(620, 230, 20, 20);
			INJCheckBox_RevLog.setVisible(false);
		}
		return INJCheckBox_RevLog;
	}

	private LabelSmallBase getINJLabel_LogCvrCls() {
		if (INJLabel_LogCvrCls == null) {
			INJLabel_LogCvrCls = new LabelSmallBase();
			INJLabel_LogCvrCls.setText("LOG Cv Cls");
			INJLabel_LogCvrCls.setBounds(642, 230, 65, 20);
			INJLabel_LogCvrCls.setVisible(false);
		}
		return INJLabel_LogCvrCls;
	}

	private ComboACMCode getINJCombo_LogCvrCls() {
		if (INJCombo_LogCvrCls == null) {
			INJCombo_LogCvrCls = new ComboACMCode();
			INJCombo_LogCvrCls.setBounds(705, 230, 80, 18);
			INJCombo_LogCvrCls.setVisible(false);
		}
		return INJCombo_LogCvrCls;
	}

	private LabelSmallBase getINJLabel_NVTD() {
		if (INJLabel_NVTD == null) {
			INJLabel_NVTD = new LabelSmallBase();
			INJLabel_NVTD.setText("Nature of Visit Treatement Dr");
			INJLabel_NVTD.setBounds(5, 2, 90, 40);
		}
		return INJLabel_NVTD;
	}

	private TextDoctorSearch getINJText_TreDrCode() {
		if (INJText_TreDrCode == null) {
			INJText_TreDrCode = new TextDoctorSearch(true, getINJText_TreDrName(), true) {
				@Override
				public void onBlur() {
					checkDocExist(getText());
					if(REG_WALKIN.equals(getRegistrationMode())
						|| REG_PRIORITY.equals(getRegistrationMode())
						|| REG_URGENTCARE.equals(getRegistrationMode())){
						checkDuplicatApp();
						//checkDrCurRoom();
					}
					checkDrCurRoom();

				}
				
				@Override
				public void onTextSet() {
					if(NO_VALUE.equals(Factory.getInstance().getSysParameter("DISABLERM"))) {
						if ((QueryUtil.ACTION_APPEND.equals(getActionTypeRegistration()) 
								|| QueryUtil.ACTION_MODIFY.equals(getActionTypeRegistration())) && 
								"TRIAGE".equals(memDocCode)) {
							getRTCombo_docRoom().setEditable(true);
						}
						
						if ((QueryUtil.ACTION_APPEND.equals(getActionTypeRegistration()) 
								|| QueryUtil.ACTION_MODIFY.equals(getActionTypeRegistration())) && "".equals(getINJText_TreDrCode().getText())) {
							getRTCombo_docRoom().resetText();
						}
						checkDrCurRoom();
					}

				}

				@Override
				public void onReleased() {
					if (isEmpty()) {
						resetText();
					}
				}
				

			};
			int width = 100;
			if (YES_VALUE.equalsIgnoreCase(Factory.getInstance().getSysParameter("PatRegDocC"))) {
				width = 65;
			}
			INJText_TreDrCode.setBounds(80, 10, width, 20);
		}
		return INJText_TreDrCode;
	}

	public ComboDoctor getINJCombo_TreDrCode() {
		if (INJCombo_TreDrCode == null) {
			INJCombo_TreDrCode = new ComboDoctor(getINJText_TreDrName()) {
				@Override
				protected void onSelected() {
					getINJText_TreDrCode().setText(getText());
				}
			};
			INJCombo_TreDrCode.setBounds(80, 10, 100, 20);
		}
		return INJCombo_TreDrCode;
	}

	private TextReadOnly getINJText_TreDrName() {
		if (INJText_TreDrName == null) {
			INJText_TreDrName = new TextReadOnly();
			INJText_TreDrName.setBounds(185, 10, 200, 20);
		}
		return INJText_TreDrName;
	}

	private ButtonBase getINButton_AddNature() {
		if (INButton_AddNature == null) {
			INButton_AddNature = new ButtonBase() {
				@Override
				public void onClick() {
					if (isRegFlag()) {
						if (getActionType() == null) {
							getRegDtorTable().removeAllRow();
						}

						if (isAppend() || isModify() ) {
							getRegDtorTable().addRow(new String[] {null, null, null, null, null, null, null});
						}
					}
				}
			};
			INButton_AddNature.setText("+");
			INButton_AddNature.setBounds(387, 10, 20, 23);
		}
		return INButton_AddNature;
	}

	private ButtonBase getINButton_AdmFrm() {
		if (INButton_AdmFrm == null) {
			INButton_AdmFrm = new ButtonBase() {
				@Override
				public void onClick() {
					printAdmForm();
				}
			};
			INButton_AdmFrm.setText("Admission Form", 'A');
			INButton_AdmFrm.setBounds(5, 123, 132, 23);
		}
		return INButton_AdmFrm;
	}
/*
	private ButtonBase getINButton_Inpat() {
		// not visible, so no attached to container
		if (INButton_Inpat == null) {
			INButton_Inpat = new ButtonBase() {
				@Override
				public void onClick() {
					checkCurrentInpat(new CallbackListener() {
						@Override
						public void handleRetBool(boolean ret, String result, MessageQueue mQueue) {
							if (ret) {
								Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_CURRENT_INPATIENT);
								return;
							} else {
								QueryUtil.executeMasterAction(getUserInfo(),
										ConstantsTx.TRANTOINPAT_TXCODE, QueryUtil.ACTION_APPEND,
										new String[] {memRegID, null, getUserInfo().getSiteCode(), getUserInfo().getUserID()},
										new MessageQueueCallBack() {
									@Override
									public void onPostSuccess(MessageQueue mQueue) {
										if (mQueue.success()) {
											setRegistrationMode(REG_NOTHING);
											memRegID = mQueue.getReturnCode();
											showRegistration();
										} else {
											Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_FAILED_INPATTRANSFER);
										}
									}
								});
							}
						}
					});
				}
			};
//			INButton_Inpat.setBounds(320, 123, 75, 23);
			INButton_Inpat.setText("Transfer to Inpatient");
		}
		return INButton_Inpat;
	}
*/
	private ButtonBase getINButton_PrintLabel() {
		if (INButton_PrintLabel == null) {
			INButton_PrintLabel = new ButtonBase() {
				@Override
				public void onClick() {
					String prtPatno = getRTJText_PatientNumber().getText();
					if (prtPatno.length() == 0) {
						return;
					}

					QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] { "slip", "slptype", "slpno = '" + getINJText_SLPNO().getText() + "'" },
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								if ("I".equals(mQueue.getContentField()[0])) {
									getDlgNoOfLblToBePrtInp().showDialog(
											memPatNo, memRegID, mQueue.getContentField()[0],
											memAdmissionDate, true, true);
								} else if ("D".equals(mQueue.getContentField()[0])) {
									getDlgNoOfLblToBePrtInp().showDialog(
											memPatNo, memRegID, mQueue.getContentField()[0],
											memAdmissionDate, true, true);
								} else if ("O".equals(mQueue.getContentField()[0])) {
									getDlgNoOfLblToBePrtOutp().showDialog(memPatNo, null, null, null, true);
								}
							}
						}
					});
				}
			};
			INButton_PrintLabel.setBounds(139, 123, 132, 23);
			INButton_PrintLabel.setText("Print Label", 'L');
		}
		return INButton_PrintLabel;
	}

	private ButtonBase getINButton_PrintChartLabel() {
		if (INButton_PrintChartLabel == null) {
			INButton_PrintChartLabel = new ButtonBase() {
				@Override
				public void onClick() {
					printLab();
				}
			};
			INButton_PrintChartLabel.setBounds(273, 123, 132, 23);
			INButton_PrintChartLabel.setText("Print Call Chart Label");
		}
		return INButton_PrintChartLabel;
	}

	private ButtonBase getINButton_PrintOTHandOver() {
		if (INButton_PrintOTHandOver == null) {
			INButton_PrintOTHandOver = new ButtonBase() {
				@Override
				public void onClick() {
					printOThandOver();
				}
			};
			INButton_PrintOTHandOver.setBounds(320, 123, 85, 23);
			INButton_PrintOTHandOver.setText("Print Handover");
		}
		return INButton_PrintOTHandOver;
	}

	private ButtonBase getINButton_PrintWristbandLabel() {
		if (INButton_PrintWristbandLabel == null) {
			INButton_PrintWristbandLabel = new ButtonBase() {
				@Override
				public void onClick() {
					QueryUtil.executeMasterFetch(getUserInfo(), "PATIENTBYNO",
							new String[] { memPatNo }, new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mq) {
							if (mq.success()) {
								String wbdTypeQyVar = null;
								String printName = null;
								if (!"NA".equals(memWBLblType)) {
									if (!MINUS_ONE_VALUE.equals(isNewBorn)) {
										wbdTypeQyVar = "ADWBLBLTYP";
										memWBLblType = "Adult";
										printName = getSysParameter("PRTRTWBADT");
									} else {
										wbdTypeQyVar = "BBWBLBLTYP";
										memWBLblType = "BABY";
										printName = getSysParameter("PRTRTWBBB");
									}

									HashMap<String, String> map = new HashMap<String, String>();

									map.put("patbdate", mq.getContentField()[3]+mq.getContentField()[9]);
									map.put("patno", memPatNo);
									map.put("patsname", mq.getContentField()[0]);
									map.put("patfname", mq.getContentField()[1]);
									map.put("patsex", mq.getContentField()[5]);
									map.put("patcname",	mq.getContentField()[6]);

									StringBuffer mapKey = new StringBuffer();
									StringBuffer mapValue = new StringBuffer();
									String patcname = null;
									for (Map.Entry<String, String> pairs : map.entrySet()) {
										if (!"patcname".equals(pairs.getKey())) {
											mapKey.append(pairs.getKey()+"<FIELD/>");
											mapValue.append(pairs.getValue()+"<FIELD/>");
										} else {
											patcname = pairs.getValue();
										}
									}
									PrintingUtil.print(printName,
											"WristbandLabel_"+memWBLblType+"_"+getSysParameter(wbdTypeQyVar),
											map,patcname);
								}
							}
						}
					});
				}
			};
			INButton_PrintWristbandLabel.setBounds(5, 148, 132, 23);
			INButton_PrintWristbandLabel.setText("Print Wristband label", 'W');
		}
		return INButton_PrintWristbandLabel;
	}

	private ButtonBase getINButton_PrintBillingHistory() {
		if (INButton_PrintBillingHistory == null) {
			INButton_PrintBillingHistory = new ButtonBase() {
				@Override
				public void onClick() {
					getDlgSlipList().showDialog(getRTJText_PatientNumber().getText().trim());
				}
			};
			INButton_PrintBillingHistory.setBounds(139, 148, 132, 23);
			INButton_PrintBillingHistory.setText("Billing History", 'H');
		}
		return INButton_PrintBillingHistory;
	}

	private ButtonBase getINButton_PrintBilling() {
		if (INButton_PrintBilling == null) {
			INButton_PrintBilling = new ButtonBase() {
				@Override
				public void onClick() {
					QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] {"rlock", "count(1)", "UPPER(RlkType) = UPPER('Slip') and RlkKey ='" + getINJText_SLPNO().getText() + "'"}, // Set para for getting death date
							new MessageQueueCallBack() {
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								if (mQueue.getContentField()[0] != null &&
										mQueue.getContentField()[0].length() > 0 &&
										Integer.parseInt(mQueue.getContentField()[0]) > 0) {
									QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
											new String[] {"rlock", "USRID", "UPPER(RlkType) = UPPER('Slip') and RlkKey ='" + getINJText_SLPNO().getText() + "'"},
											new MessageQueueCallBack() {
										public void onPostSuccess(MessageQueue mQueue) {
											if (mQueue.success()) {
												QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
														new String[] {"USR", "USRNAME", "UPPER(USRID) = UPPER('"+mQueue.getContentField()[0]+"') "},
														new MessageQueueCallBack() {
													public void onPostSuccess(MessageQueue mQueue) {
														if (mQueue.success()) {
															Factory.getInstance().addErrorMessage("Slip is locked by "+mQueue.getContentField()[0]+".");
															return;
														}
													}
												});
											}
										}
									});
								} else {
									if (!getINJText_SLPNO().isEmpty()) {
										showTransactions();
									} else {
										Factory.getInstance().addErrorMessage("No slip number.", getINJText_SLPNO());
										return;
									}
								}
							} else {
								Factory.getInstance().addErrorMessage("Data retrieve err.");
								return;
							}
						}
					});
				}
			};
			INButton_PrintBilling.setBounds(273, 148, 132, 23);
			INButton_PrintBilling.setText("Billing");
		}
		return INButton_PrintBilling;
	}

	private ButtonBase getINButton_PatientCardButton() {
		if (INButton_PatientCardBtn == null) {
			INButton_PatientCardBtn = new ButtonBase() {
				@Override
				public void onClick() {
					if (HKAH_VALUE.equals(getUserInfo().getSiteCode())) {
						getDlgPrintPatientCard().showDialog(getRTJText_PatientNumber().getText().trim());
					} else {
						Map<String, String> map = new HashMap<String, String>();
						map.put("PATFNAME", getPJText_FamilyName().getText().trim());
						map.put("PATGNAME", getPJText_GivenName().getText().trim());
						map.put("PATNO", getRTJText_PatientNumber().getText().trim());
						map.put("PATCNAME", getPJText_ChineseName().getText());
						map.put("BARCODE",  getRTJText_PatientNumber().getText().trim() +
											PrintingUtil.generateCheckDigit(getRTJText_PatientNumber().getText().trim()).toString()+"#");

						if (!PrintingUtil.print(getSysParameter("PRTPATCARD"),
												"PatientCard_" + (Factory.getInstance().getMainFrame().isDisableApplet()?HKAH_VALUE:TWAH_VALUE),
												map, null)) {
							Factory.getInstance().addErrorMessage("Printing Patient Card failed.");
						}
					}
				}
			};
			INButton_PatientCardBtn.setText("Patient Card", 'd');
			INButton_PatientCardBtn.setBounds(5, 173, 132, 23);
		}
		return INButton_PatientCardBtn;
	}

	private ButtonBase getINButton_IPGeneralLabelButton() {
		if (INButton_IPGeneralLblBtn == null) {
			INButton_IPGeneralLblBtn = new ButtonBase() {
				@Override
				public void onClick() {
					if (!getCurrentRegistrationType().equals(REG_TYPE_OUTPATIENT)) {
						getDlgNoOfLblToBePrtInp().showDialog(
								getRTJText_PatientNumber().getText(), memRegID,
								getCurrentRegistrationType(),
								memAdmissionDate, false, true
							);
					} else {
						getDlgNoOfLblToBePrtInp().showDialog(
								getRTJText_PatientNumber().getText(), memRegID,
								getCurrentRegistrationType(), memAdmissionDate, false, true);
					}
				}
			};

			INButton_IPGeneralLblBtn.setText("IP Gen Label (DOB)", 'G');
			INButton_IPGeneralLblBtn.setBounds(139, 173, 132, 23);
		}
		return INButton_IPGeneralLblBtn;
	}

	/**
	 * @return the iNButton_AdmLabelBtn
	 */
	private ButtonBase getINButton_RegLabelBtn() {
		if (INButton_RegLabelBtn == null) {
			INButton_RegLabelBtn = new ButtonBase() {
				@Override
				public void onClick() {
					final String patNo = getRTJText_PatientNumber().getText().trim();
					String tempChkDigit = "#";
					if ("YES".equals(getSysParameter("ChkDigit"))) {
							tempChkDigit = PrintingUtil.generateCheckDigit(patNo.trim()).toString()+"#";
					}
					Map<String,String> mapGeneral = new HashMap<String,String>();

					mapGeneral.put("outPatType", getRTJText_OutPatientType().getText());
					mapGeneral.put("newbarcode", patNo + tempChkDigit);

					if (getCurrentRegistrationType().equals(REG_TYPE_DAYCASE)) {
						PrintingUtil.print(getSysParameter("PRTRLBL"),
								"DAYCASEADMLABEL", mapGeneral, null,
								new String[] { patNo },
								new String[] {
										"stecode", "patno", "patname",
										"patcname","patbdate", "patsex",
										"docname", "regdate"
								});
					} else {

						mapGeneral.put("TicketGenMth", getSysParameter("TicketGen"));
						mapGeneral.put("isasterisk",
								String.valueOf("YES".equals(getMainFrame().getSysParameter("Chk*"))));

						PrintingUtil.print(getSysParameter("PRTRLBL"),
											"ADMISSIONLABEL", mapGeneral, null,
											new String[] { patNo },
											new String[] {
													"stecode", "patno", "patname",
													"patcname", "patbdate", "patsex",
													"docname", "regdate", "admdate",
													"regcat", "regcount", "ticketno",
													"lblrmk"
											});
					}
				}
			};
			INButton_RegLabelBtn.setText("Reg Label");
			INButton_RegLabelBtn.setBounds(139, 173, 132, 23);
		}
		return INButton_RegLabelBtn;
	}

	/**
	 * @return the INButton_IdtLabelBtn
	 */
	private ButtonBase getINButton_IdtLabelBtn() {
		if (INButton_IdtLabelBtn == null) {
			INButton_IdtLabelBtn = new ButtonBase() {
				@Override
				public void onClick() {
					final String patNo = getRTJText_PatientNumber().getText().trim();
					String tempChkDigit = "#";
					if ("YES".equals(getSysParameter("ChkDigit"))) {
							tempChkDigit = PrintingUtil.generateCheckDigit(patNo.trim()).toString()+"#";
					}
					Map<String,String> mapGeneral = new HashMap<String,String>();

					mapGeneral.put("outPatType", getRTJText_OutPatientType().getText());
					mapGeneral.put("newbarcode", patNo + tempChkDigit);
					mapGeneral.put("TicketGenMth", getSysParameter("TicketGen"));
					mapGeneral.put("isasterisk",
							String.valueOf("YES".equals(getMainFrame().getSysParameter("Chk*"))));

					PrintingUtil.print(getSysParameter("PRTRLBL"),
										"ADMISSIONLABEL_WBOSPG", mapGeneral, null,
										new String[] { patNo },
										new String[] {
												"stecode", "patno", "patname",
												"patcname", "patbdate", "patsex",
												"docname", "regdate", "admdate",
												"regcat", "regcount", "ticketno",
												"lblrmk", "birthordspg"
										});

				}
			};
			INButton_IdtLabelBtn.setText("Identification Label");
			INButton_IdtLabelBtn.setBounds(273, 173, 132, 23);
			INButton_IdtLabelBtn.setVisible(false);
		}
		return INButton_IdtLabelBtn;
	}

	private ButtonBase getINButton_DlgPrtCallChartButton() {
		if (INButton_DlgPrtCallChartButton == null) {
			INButton_DlgPrtCallChartButton = new ButtonBase() {
				@Override
				public void onClick() {
					getDlgPrtCallChart().showDialog(getRTJText_PatientNumber().getText());
				}
			};
			INButton_DlgPrtCallChartButton.setText("Call / Trf Cht", 'C');
			INButton_DlgPrtCallChartButton.setBounds(273, 173, 132, 23);
		}
		return INButton_DlgPrtCallChartButton;
	}
	
	private ButtonBase getINButton_UKCert() {
		if (INButton_UKCert == null) {
			INButton_UKCert = new ButtonBase() {
				@Override
				public void onClick() {
					getDlgPrintUKCert().showDialog(memRegID);
				}
			};
			INButton_UKCert.setText("UK Med Cert");
			INButton_UKCert.setBounds(5, 198, 132, 23);
			INButton_UKCert.setVisible(false);
		}
		return INButton_UKCert;
	}
	
	private DlgPrintUKCert getDlgPrintUKCert() {
		if (dlgPrintUKCert == null) {
			dlgPrintUKCert = new DlgPrintUKCert(getMainFrame());
		}
		return dlgPrintUKCert;
	}
	
	private ButtonBase getINButton_PrintEShare() {
		if (INButton_PrintEShare == null) {
			INButton_PrintEShare = new ButtonBase() {
				@Override
				public void onClick() {
					String qrCodeLink = getSysParameter("E_SUV") + memRegID + "&code=qr";
					Map<String,String> map = new HashMap<String,String>();
					map.put("QRCODE", qrCodeLink);
					map.put("steCode", getUserInfo().getSiteCode());
					map.put("LogoImg", CommonUtil.getReportImg(getUserInfo().getSiteCode().toUpperCase()+"_rpt_logo1.jpg"));
					PrintingUtil.print("eShareLetter", map, "");
				}
			};
			INButton_PrintEShare.setText("eShare");
			INButton_PrintEShare.setBounds(139, 198, 132, 23);
			INButton_PrintEShare.setVisible(false);
		}
		return INButton_PrintEShare;
	}

	public BasePanel getRegRBPanel() {
		if (RegRBPanel == null) {
			RegRBPanel = new BasePanel();
			RegRBPanel.setBorders(true);
			RegRBPanel.setBounds(380, 259, 413, 230);
			RegRBPanel.add(getINJLabel_NVTD(), null);
			if (YES_VALUE.equalsIgnoreCase(Factory.getInstance().getSysParameter("PatRegDocC"))) {
				RegRBPanel.add(getINJCombo_TreDrCode(), null);
			}
			RegRBPanel.add(getINJText_TreDrCode(), null);
			RegRBPanel.add(getINJText_TreDrName(), null);
			RegRBPanel.add(getINButton_AddNature(), null);
			RegRBPanel.add(getRegDtorTable(), null);
			RegRBPanel.add(getINButton_AdmFrm(), null);
			RegRBPanel.add(getINButton_PrintLabel(), null);
			RegRBPanel.add(getINButton_PrintChartLabel(), null);
			RegRBPanel.add(getINButton_PrintOTHandOver(), null);
			RegRBPanel.add(getINButton_PrintWristbandLabel(), null);
			RegRBPanel.add(getINButton_PrintBillingHistory(), null);
			RegRBPanel.add(getINButton_PrintBilling(), null);
			RegRBPanel.add(getINButton_PatientCardButton(), null);
			RegRBPanel.add(getINButton_IPGeneralLabelButton(), null);
			RegRBPanel.add(getINButton_RegLabelBtn(), null);
			RegRBPanel.add(getINButton_DlgPrtCallChartButton(), null);
			RegRBPanel.add(getINButton_IdtLabelBtn(), null);
			RegRBPanel.add(getINButton_UKCert(), null);
			RegRBPanel.add(getINButton_PrintEShare(), null);
		}
		return RegRBPanel;
	}

	private ComboPackage getComboPackage() {
		if (comboPackage == null) {
			comboPackage = new ComboPackage(true, "PKGTYPE <> 'P'") {
				@Override
				protected void setTextPanel(ModelData modelData) {
					super.setTextPanel(modelData);

					if (modelData != null) {
						getRegDtorTable().setValueAt(modelData.get(ZERO_VALUE).toString(),
													getRegDtorTable().getSelectedRow(), 0);
						getRegDtorTable().setValueAt(modelData.get(ONE_VALUE).toString(),
													getRegDtorTable().getSelectedRow(), 1);
					}
				}
			};
		}
		return comboPackage;
	}

	private EditorTableList getRegDtorTable() {
		if (RegDtorTable == null) {
			RegDtorTable = new EditorTableList(
				getRegDtorColumnNames(),
				getRegDtorColumnWidths(),
				getRegDtorColumnFields()
			) {
				// for stop edit by typing tab or click away
				@Override
				protected void columnBlurHandler(FieldEvent be, int editingCol) {
					if (editingCol == 0 && getRegDtorTable().isEditing()) {
						int r = getRegDtorTable().getActiveEditor().row;

						getRegDtorTable().stopEditing();

						getRegDtorTable().setValueAt(((ComboPackage) be.getSource()).getDisplayTextWithoutKey(), r, 1);
					}
				}

				// for click trigger and select only
				@Override
				protected void columnCancelEditHandler(EditorEvent be, int editingCol) {
					if (editingCol == 0) {
						int r = getRegDtorTable().getActiveEditor().row;

						getRegDtorTable().stopEditing();

						int editingRow = getRegDtorTable().getSelectedRow();
						String rv = getRegDtorTable().getValueAt(editingRow, editingCol);

						getRegDtorTable().setValueAt(rv, r, 0);
					}
				}
			};
			RegDtorTable.setTableLength(getListWidth());
			RegDtorTable.setBorders(true);
			RegDtorTable.setBounds(5, 39, 400, 80);
		}
		return RegDtorTable;
	}

	private String[] getRegDtorColumnNames() {
		return new String[] { "Nature", "Description", "", "", "", "", ""};
	}

	private int[] getRegDtorColumnWidths() {
		return new int[] { 100, 250, 0, 0, 0, 0, 0 };
	}

	private Field<? extends Object>[] getRegDtorColumnFields() {
		return new Field[] {
				getComboPackage(), null, null, null, null, null, null
		};
	}
/*
	public void tableChanged(TableModelEvent e) {
		RegDtorTable.editingStopped(new ChangeEvent(this));

		if (RegDtorTable.getEditingRow()>-1 && RegDtorTable.getEditingColumn() == 0) {
			Object editvalue = RegDtorTable.getValueAt(RegDtorTable.getEditingRow(), RegDtorTable.getEditingColumn());
			if (editvalue == null) {
				RegDtorTable.setValueAt(null, RegDtorTable.getEditingRow(), RegDtorTable.getEditingColumn()+1);
				return;
			}
			//Combo values is Code and Name
			String []ComboValues = editvalue.toString().split("\\s+");
			String ComboCode = ComboValues[ComboValues.length-1];
			//RegDtorTable.setValueAt(null, RegDtorTable.getEditingRow(), RegDtorTable.getEditingColumn());
			QueryUtil.executeMasterFetch(getUserInfo(), "PACKAGE", new String[] { ComboCode});
			if (mQueue.success()) {
				// get first return value and assign to district
				RegDtorTable.setValueAt(mQueue.getContentField()[1], RegDtorTable.getEditingRow(), RegDtorTable.getEditingColumn()+1);
			}
		}
	}
*/
	private ButtonBase getAddInfoTabButton() {
		if (addInfoTabBtn == null) {
			addInfoTabBtn = new ButtonBase() {
				public void onClick() {
					searchPatientByChangeTab();
					getRBTPanel().setSelectedIndex(2);
					defaultFocus();
				}
			};
			addInfoTabBtn.setVisible(false);
			addInfoTabBtn.setHotkey('I');
		}
		return addInfoTabBtn;
	}

	public BasePanel getAdditInfoPanel() {
		if (additInfoPanel == null) {
			additInfoPanel = new BasePanel();
			additInfoPanel.setLayout(null);
			additInfoPanel.setBounds(0, 0, 800, 480);
			additInfoPanel.add(getAdditInfoLeftPanel(), null);
			additInfoPanel.add(getAdditInfoRightPanel(), null);
		}
		return additInfoPanel;
	}

	// Additional information left panel
	public BasePanel getAdditInfoLeftPanel() {
		if (AdditInfoLeftPanel == null) {
			AdditInfoLeftPanel = new BasePanel();
			AdditInfoLeftPanel.setBorders(true);
			AdditInfoLeftPanel.setBounds(5, 5, 500, 457);
			AdditInfoLeftPanel.add(getLabel_LongFName(), null);
			AdditInfoLeftPanel.add(getText_LongFName(), null);
			AdditInfoLeftPanel.add(getLabel_LongGName(), null);
			AdditInfoLeftPanel.add(getText_LongGName(), null);
			AdditInfoLeftPanel.add(getLabel_CreateSiteCode(), null);
			AdditInfoLeftPanel.add(getINJText_CreateSiteCode(), null);
			AdditInfoLeftPanel.add(getLabel_RmkLastUptBy(), null);
			AdditInfoLeftPanel.add(getLabel_RmkLastUptByText(), null);
			AdditInfoLeftPanel.add(getLabel_RmkLastUptTime(), null);
			AdditInfoLeftPanel.add(getLabel_RmkLastUptTimeText(), null);
			AdditInfoLeftPanel.add(getLabel_PatientRmk(), null);
			AdditInfoLeftPanel.add(getLabel_PatientRmkUnderLine(), null);
			AdditInfoLeftPanel.add(getTextArea_PatientRmk(), null);
		}
		return AdditInfoLeftPanel;
	}

	private LabelSmallBase getLabel_LongFName() {
		if (Label_LongFName == null) {
			Label_LongFName = new LabelSmallBase();
			Label_LongFName.setText("Long Family Name");
			Label_LongFName.setBounds(5, 5, 110, 50);
		}
		return Label_LongFName;
	}

	private TextAreaBase getText_LongFName() {
		if (Text_LongFName == null) {
			Text_LongFName = new TextAreaBase(160, true);
			Text_LongFName.setBounds(120, 5, 370, 50);
		}
		return Text_LongFName;
	}

	private LabelSmallBase getLabel_LongGName() {
		if (Label_LongGName == null) {
			Label_LongGName = new LabelSmallBase();
			Label_LongGName.setText("Long Given Name");
			Label_LongGName.setBounds(5, 60, 110, 50);
		}
		return Label_LongGName;
	}

	private TextAreaBase getText_LongGName() {
		if (Text_LongGName == null) {
			Text_LongGName = new TextAreaBase(160, true);
			Text_LongGName.setBounds(120, 60, 370, 50);
		}
		return Text_LongGName;
	}

	private LabelSmallBase getLabel_CreateSiteCode() {
		if (Label_CreateSiteCode == null) {
			Label_CreateSiteCode = new LabelSmallBase();
			Label_CreateSiteCode.setText("Created Site Code");
			Label_CreateSiteCode.setBounds(5, 115, 110, 20);
		}
		return Label_CreateSiteCode;
	}

	private TextReadOnly getINJText_CreateSiteCode() {
		if (INJText_CreateSiteCode == null) {
			INJText_CreateSiteCode = new TextReadOnly();
			INJText_CreateSiteCode.setBounds(120, 115, 370, 20);
		}
		return INJText_CreateSiteCode;
	}

	private LabelSmallBase getLabel_PatientRmk() {
		if (Label_PatientRmk == null) {
			Label_PatientRmk = new LabelSmallBase();
			Label_PatientRmk.setText("Patient Remark");
			Label_PatientRmk.setBounds(5, 145, 90, 20);
		}
		return Label_PatientRmk;
	}

	private LabelSmallBase getLabel_PatientRmkUnderLine() {
		if (Label_PatientRmkUnderLine == null) {
			Label_PatientRmkUnderLine = new LabelSmallBase();
			Label_PatientRmkUnderLine.setText("==============");
			Label_PatientRmkUnderLine.setBounds(5, 155, 90, 20);
		}
		return Label_PatientRmkUnderLine;
	}

	private TextAreaBase getTextArea_PatientRmk() {
		if (TextArea_PatientRmk == null) {
			TextArea_PatientRmk = new TextAreaBase(1000);
			TextArea_PatientRmk.setBounds(5, 225, 488, 225);
		}
		return TextArea_PatientRmk;
	}

	private LabelSmallBase getLabel_RmkLastUptBy() {
		if (Label_RmkLastUptBy == null) {
			Label_RmkLastUptBy = new LabelSmallBase();
			Label_RmkLastUptBy.setText("Last Updated By:");
			Label_RmkLastUptBy.setBounds(5, 175, 150, 20);
		}
		return Label_RmkLastUptBy;
	}

	private LabelSmallBase getLabel_RmkLastUptByText() {
		if (Label_RmkLastUptByText == null) {
			Label_RmkLastUptByText = new LabelSmallBase();
			Label_RmkLastUptByText.setBounds(155, 175, 200, 20);
		}
		return Label_RmkLastUptByText;
	}

	private LabelSmallBase getLabel_RmkLastUptTime() {
		if (Label_RmkLastUptTime == null) {
			Label_RmkLastUptTime = new LabelSmallBase();
			Label_RmkLastUptTime.setText("Last Updated Date/Time:");
			Label_RmkLastUptTime.setBounds(5, 200, 150, 20);
		}
		return Label_RmkLastUptTime;
	}

	private LabelSmallBase getLabel_RmkLastUptTimeText() {
		if (Label_RmkLastUptTimeText == null) {
			Label_RmkLastUptTimeText = new LabelSmallBase();
			Label_RmkLastUptTimeText.setBounds(155, 200, 200, 20);
		}
		return Label_RmkLastUptTimeText;
	}

	// Additional information right panel
	public BasePanel getAdditInfoRightPanel() {
		if (AdditInfoRightPanel == null) {
			AdditInfoRightPanel = new BasePanel();
			AdditInfoRightPanel.setBorders(true);
			AdditInfoRightPanel.setBounds(510, 5, 283, 457);
			AdditInfoRightPanel.add(getDocImagePanel(), null);
		}
		return AdditInfoRightPanel;
	}

	public BasePanel getDocImagePanel() {
		if (imgDocPanel == null) {
			imgDocPanel = new BasePanel();
			imgDocPanel.setBorders(true);
			imgDocPanel.setBounds(30, 50, 225, 297);
			imgDocPanel.add(getImage_PatImage());
		}
		return imgDocPanel;
	}

	// eHR Information
	private ButtonBase getEhrTabButton() {
		if (eHrTabBtn == null) {
			eHrTabBtn = new ButtonBase() {
				public void onClick() {
					searchPatientByChangeTab();
					getRBTPanel().setSelectedIndex(3);
					defaultFocus();
				}
			};
			eHrTabBtn.setVisible(false);
			eHrTabBtn.setHotkey('E');
		}
		return eHrTabBtn;
	}

	public BasePanel getEhrPanel() {
		if (ehrPanel == null) {
			ehrPanel = new BasePanel();
			ehrPanel.setLayout(null);
			ehrPanel.setBounds(0, 0, 800, 800);
			ehrPanel.add(getEhrPmiPanel(), null);
			ehrPanel.add(getEhrEnrollHistPanel(), null);
		}
		return ehrPanel;
	}

	public FieldSetBase getEhrPmiPanel() {
		if (ehrPmiPanel == null) {
			ehrPmiPanel = new FieldSetBase();
			ehrPmiPanel.setBounds(5, 5, 790, 200);
			ehrPmiPanel.setHeading("Patient Information");
			ehrPmiPanel.add(getEHRLogoPanel());
			ehrPmiPanel.add(getEJLabel_cEhrActive());
			ehrPmiPanel.add(getEhrEnrolButton());
			ehrPmiPanel.add(getEJLabel_cEhrNo());
			ehrPmiPanel.add(getEJText_cEhrNo());
			ehrPmiPanel.add(getEJLabel_NBRegID());
			ehrPmiPanel.add(getEJText_NBRegID());
			ehrPmiPanel.add(getEJLabel_Death());
			ehrPmiPanel.add(getEJText_Death());
			ehrPmiPanel.add(getEJLabel_FName());
			ehrPmiPanel.add(getEJText_FName());
			ehrPmiPanel.add(getEJLabel_GName());
			ehrPmiPanel.add(getEJText_GName());
			ehrPmiPanel.add(getEJLabel_Dob());
			ehrPmiPanel.add(getEJText_Dob());
			ehrPmiPanel.add(getEJCombo_ehrExactDobInd());
			ehrPmiPanel.add(getEJLabel_Sex());
			ehrPmiPanel.add(getEJCombo_Sex());
			ehrPmiPanel.add(getEJLabel_HKID());
			ehrPmiPanel.add(getEJText_HKID());
			ehrPmiPanel.add(getEJLabel_docType());
			ehrPmiPanel.add(getEJCombo_docType());
			ehrPmiPanel.add(getEJLabel_docTypeAlert());
			ehrPmiPanel.add(getEJLabel_docNo());
			ehrPmiPanel.add(getEJText_docNo());
		}
		return ehrPmiPanel;
	}

	public FieldSetBase getEhrEnrollHistPanel() {
		if (ehrEnrollHistPanel == null) {
			ehrEnrollHistPanel = new FieldSetBase();
			ehrEnrollHistPanel.setBounds(5, 205, 790, 255);
			ehrEnrollHistPanel.setHeading("Enrollment History");
			ehrEnrollHistPanel.add(getEhrCopyLatestPInfoBtn());
			ehrEnrollHistPanel.add(getEhrSendMatchMsgBtn());
			ehrEnrollHistPanel.add(getEhrEnrollHistTable());
		}
		return ehrEnrollHistPanel;
	}

	private LabelSmallBase getEJLabel_FName() {
		if (EJLabel_FName == null) {
			EJLabel_FName = new LabelSmallBase();
			EJLabel_FName.setText("Family Name");
			EJLabel_FName.setBounds(240, 0, 150, 20);
		}
		return EJLabel_FName;
	}

	private TextName getEJText_FName() {
		if (EJText_FName == null) {
			EJText_FName = new TextName();
			EJText_FName.setBounds(395, 0, 380, 20);
		}
		return EJText_FName;
	}

	private LabelSmallBase getEJLabel_GName() {
		if (EJLabel_GName == null) {
			EJLabel_GName = new LabelSmallBase();
			EJLabel_GName.setText("Given Name");
			EJLabel_GName.setBounds(240, 25, 150, 20);
		}
		return EJLabel_GName;
	}

	private TextName getEJText_GName() {
		if (EJText_GName == null) {
			EJText_GName = new TextName();
			EJText_GName.setBounds(395, 25, 380, 20);
		}
		return EJText_GName;
	}

	private LabelSmallBase getEJLabel_Dob() {
		if (EJLabel_Dob == null) {
			EJLabel_Dob = new LabelSmallBase();
			EJLabel_Dob.setText("Date of Birth (Exactness)");
			EJLabel_Dob.setBounds(240, 50, 150, 20);
		}
		return EJLabel_Dob;
	}

	private TextDate getEJText_Dob() {
		if (EJText_Dob == null) {
			EJText_Dob = new TextDate();
			EJText_Dob.setBounds(395, 50, 100, 20);
		}
		return EJText_Dob;
	}

	private ComboEhrExactDobInd getEJCombo_ehrExactDobInd() {
		if (EJCombo_ehrExactDobInd == null) {
			EJCombo_ehrExactDobInd = new ComboEhrExactDobInd();
			EJCombo_ehrExactDobInd.setBounds(500, 50, 100, 20);
		}
		return EJCombo_ehrExactDobInd;
	}

	private LabelSmallBase getEJLabel_Sex() {
		if (EJLabel_Sex == null) {
			EJLabel_Sex = new LabelSmallBase();
			EJLabel_Sex.setText("Sex");
			EJLabel_Sex.setBounds(645, 50, 30, 20);
		}
		return EJLabel_Sex;
	}

	private ComboSex getEJCombo_Sex() {
		if (EJCombo_Sex == null) {
			EJCombo_Sex = new ComboSex();
			EJCombo_Sex.setBounds(675, 50, 100, 20);
		}
		return EJCombo_Sex;
	}

	private LabelSmallBase getEJLabel_HKID() {
		if (EJLabel_HKID == null) {
			EJLabel_HKID = new LabelSmallBase();
			EJLabel_HKID.setText("HKID No.");
			EJLabel_HKID.setBounds(240, 75, 150, 20);
		}
		return EJLabel_HKID;
	}

	private TextString getEJText_HKID() {
		if (EJText_HKID == null) {
			EJText_HKID = new TextString();
			EJText_HKID.setBounds(395, 75, 380, 20);
		}
		return EJText_HKID;
	}

	private LabelSmallBase getEJLabel_docType() {
		if (EJLabel_docType == null) {
			EJLabel_docType = new LabelSmallBase();
			EJLabel_docType.setText("Type of Identity Document");
			EJLabel_docType.setBounds(240, 100, 150, 20);
		}
		return EJLabel_docType;
	}

	private ComboEhrPmiDocType getEJCombo_docType() {
		if (EJCombo_docType == null) {
			EJCombo_docType = new ComboEhrPmiDocType() {
				@Override
				protected void onSelect(ModelData modelData, int index) {
					super.onSelect(modelData, index);
					if (5 == this.getSelectedIndex()) {
						if (getEJText_HKID().isEmpty()) {
							getEJText_HKID().setText(getEJText_docNo().getText());
							getEJText_docNo().clear();
						} else {
							getEJText_docNo().clear();
						}
					} else {
						if (getEJText_docNo().isEmpty()) {
							getEJText_docNo().setText(getEJText_HKID().getText());
							getEJText_HKID().clear();
						} else {
							getEJText_HKID().clear();
						}
					}
				}
			};
			EJCombo_docType.setBounds(395, 100, 380, 20);
		}
		return EJCombo_docType;
	}

	private LabelSmallBase getEJLabel_docTypeAlert() {
		if (EJLabel_docTypeAlert == null) {
			EJLabel_docTypeAlert = new LabelSmallBase();
			EJLabel_docTypeAlert.setText("Leave it blank if this is HKID No.");
			EJLabel_docTypeAlert.setBounds(395, 120, 200, 20);
			EJLabel_docTypeAlert.setStyleAttribute("color", "red");
		}
		return EJLabel_docTypeAlert;
	}

	private LabelSmallBase getEJLabel_docNo() {
		if (EJLabel_docNo == null) {
			EJLabel_docNo = new LabelSmallBase();
			EJLabel_docNo.setText("Identity Document Number");
			EJLabel_docNo.setBounds(240, 145, 150, 20);
		}
		return EJLabel_docNo;
	}

	private TextString getEJText_docNo() {
		if (EJText_docNo == null) {
			EJText_docNo = new TextString();
			EJText_docNo.setBounds(395, 145, 380, 20);
		}
		return EJText_docNo;
	}

	private BasePanel getEHRLogoPanel() {
		if (eHRLogoPanel == null) {
			eHRLogoPanel = new BasePanel();
			eHRLogoPanel.setBounds(5, 0, 100, 70);
			eHRLogoPanel.add(getImage_eHRLogo());
		}
		return eHRLogoPanel;
	}

	private Image getImage_eHRLogo() {
		if (Image_eHRLogo == null) {
			Image_eHRLogo = new Image();
			Image_eHRLogo.setUrl(HTTP_URL_PREFIX + getSysParameter("ptIgUrlSte") +"/hats/images/ehealth_system_logo.png");
			Image_eHRLogo.setPixelSize(94, 62);
		}
		return Image_eHRLogo;
	}

	private LabelSmallBase getEJLabel_cEhrActive() {
		if (EJLabel_cEhrActive == null) {
			EJLabel_cEhrActive = new LabelSmallBase();
			EJLabel_cEhrActive.setBounds(130, 0, 100, 20);
			EJLabel_cEhrActive.setBorders(true);
			EJLabel_cEhrActive.setText("N/A");
			EJLabel_cEhrActive.setStyleAttribute("text-align", "center");
			EJLabel_cEhrActive.setData("l_default", "Not Enroll");
			EJLabel_cEhrActive.setData("l_active", "ACTIVE");
			EJLabel_cEhrActive.setData("l_active_color", "#00FF00");
			EJLabel_cEhrActive.setData("l_inactive", "INACTIVE");
			EJLabel_cEhrActive.setData("l_inactive_color", "#C0C0C0");
		}
		return EJLabel_cEhrActive;
	}

	private LabelSmallBase getEJLabel_cEhrNo() {
		if (EJLabel_cEhrNo == null) {
			EJLabel_cEhrNo = new LabelSmallBase();
			EJLabel_cEhrNo.setText("Current eHR No.");
			EJLabel_cEhrNo.setBounds(5, 75, 120, 20);
		}
		return EJLabel_cEhrNo;
	}

	private TextString getEJText_cEhrNo() {
		if (EJText_cEhrNo == null) {
			EJText_cEhrNo = new TextString();
			EJText_cEhrNo.setBounds(130, 75, 100, 20);
		}
		return EJText_cEhrNo;
	}

	private ButtonBase getEhrEnrolButton() {
		if (ehrEnrolButton == null) {
			ehrEnrolButton = new ButtonBase() {
				public void onClick() {
					if (isModify() || (!isModify() && getModifyButton().isEnabled())) {
						modifyAction();

						getEJText_FName().setText(getPJText_FamilyName().getText());
						getEJText_GName().setText(getPJText_GivenName().getText());
						getEJText_Dob().setText(getPJText_Birthday().getText());
						getEJCombo_ehrExactDobInd().setSelectedIndex(1);
						getEJCombo_Sex().setText(getPJCombo_Sex().getText());
						getEJText_HKID().setText(getPJText_IDPassportNO().getText());
						getEJText_docNo().setText(getPJText_IDPassportNO().getText());

						getEJText_FName().requestFocus();
					} else {
						Factory.getInstance().addErrorMessage("Cannot edit eHR Patient Info.");
					}
				}
			};
			ehrEnrolButton.setText("Copy Patient Info");
			ehrEnrolButton.setBounds(130, 30, 100, 25);
			ehrEnrolButton.setVisible(false);
		}
		return ehrEnrolButton;
	}

	private LabelSmallBase getEJLabel_NBRegID() {
		if (EJLabel_NBRegID == null) {
			EJLabel_NBRegID = new LabelSmallBase();
			EJLabel_NBRegID.setText("New Born Episode No.");
			EJLabel_NBRegID.setBounds(5, 100, 120, 20);
		}
		return EJLabel_NBRegID;
	}

	private TextReadOnly getEJText_NBRegID() {
		if (EJText_NBRegID == null) {
			EJText_NBRegID = new TextReadOnly();
			EJText_NBRegID.setBounds(130, 100, 100, 20);
		}
		return EJText_NBRegID;
	}

	private LabelSmallBase getEJLabel_Death() {
		if (EJLabel_Death == null) {
			EJLabel_Death = new LabelSmallBase();
			EJLabel_Death.setText("Death");
			EJLabel_Death.setBounds(5, 125, 120, 20);
		}
		return EJLabel_Death;
	}

	private TextDate getEJText_Death() {
		if (EJText_Death == null) {
			EJText_Death = new TextDate();
			EJText_Death.setBounds(130, 125, 100, 20);
		}
		return EJText_Death;
	}

	private ButtonBase getEhrCopyLatestPInfoBtn() {
		if (ehrCopyLatestPInfoBtn == null) {
			ehrCopyLatestPInfoBtn = new ButtonBase() {
				@Override
				public void onClick() {
					if (isModify() || (!isModify() && getModifyButton().isEnabled())) {
						modifyAction();
						if (getEhrEnrollHistTable().getSelectedRow() >= 0) {
							String[] c = getEhrEnrollHistTable().getSelectedRowContent();

							getEJText_FName().setText(c[9]);
							getEJText_GName().setText(c[10]);
							getEJText_Dob().setText(c[11]);
							getEJCombo_ehrExactDobInd().setText(c[12]);
							getEJCombo_Sex().setText(c[13]);
							getEJText_HKID().setText(c[14]);
							getEJCombo_docType().setText(c[15]);
							getEJText_docNo().setText(c[17]);
						} else {
							Factory.getInstance().addErrorMessage("Please select an enrollment history message.");
						}
					} else {
						Factory.getInstance().addErrorMessage("Cannot edit eHR Patient Info.");
					}
				}
			};
			ehrCopyLatestPInfoBtn.setText("Copy Patient Info from highlighted history");
			ehrCopyLatestPInfoBtn.setBounds(5, 0, 235, 25);
		}
		return ehrCopyLatestPInfoBtn;
	}

	private ButtonBase getEhrSendMatchMsgBtn() {
		if (ehrSendMatchMsgBtn == null) {
			ehrSendMatchMsgBtn = new ButtonBase() {
				@Override
				public void onClick() {
					if (getSysParameter("EHRPMILNK") == null) {
						Factory.getInstance().addErrorMessage("Cannot get PMI message upload server path. Please contact IT support.");
					} else {
						getEhrSendMatchMsgWin().show();
					}
				}
			};
			ehrSendMatchMsgBtn.setText("Send Major Key Match");
			ehrSendMatchMsgBtn.setBounds(260, 0, 120, 25);
		}
		return ehrSendMatchMsgBtn;
	}

	private Window getEhrSendMatchMsgWin() {
		if (ehrSendMatchMsgWin == null) {
			ehrSendMatchMsgWin = new Window();
			ehrSendMatchMsgWin.setWidth(495);
			ehrSendMatchMsgWin.setHeadingHtml("Send PMI Major Key Match");

			final FormPanel uploadFormPanel = new FormPanel();
			uploadFormPanel.setAction(getSysParameter("EHRPMILNK"));
			uploadFormPanel.setMethod(Method.POST);
			uploadFormPanel.setHeaderVisible(false);
			uploadFormPanel.setFrame(true);
			uploadFormPanel.setWidth(460);
			uploadFormPanel.setLabelWidth(175);
			uploadFormPanel.addListener(Events.Submit, new Listener<FormEvent>() {
				@Override
				public void handleEvent(FormEvent be) {
					String htmlResult = be.getResultHtml();

					// testing only
					//htmlResult = "{\"responseCode\":99999, \"responseMessage\":\"Unexpected error\", \"ts\":\"Thu Apr 30 14:41:49 CST 2015\"}";
					String resultMsg = "";
					if (htmlResult != null) {
						JSONValue ret = JSONParser.parseStrict(htmlResult);
						JSONObject o = ret.isObject();
						if (o != null) {
							String rCode = o.get("responseCode").toString();
							String rMsg = o.get("responseMessage").toString();
							String rTs = o.get("ts").toString();

							resultMsg += rCode + ": " + rMsg + "<br />(" + rTs + ")";
						}
					} else {
						resultMsg += "Sent. No response code return.";
					}

					Factory.getInstance().hideMask(ehrSendMatchMsgWin);
					Factory.getInstance().addInformationMessage(resultMsg, "Send result", new Listener<MessageBoxEvent>() {
						@Override
						public void handleEvent(MessageBoxEvent be) {
							getEhrSendMatchMsgWin().hide();
							ehrSendMatchMsgWin = null;
							showEhr(currentPatNo);
						}
					});
				}
			});

			FormData formData = new FormData("-20");
			VerticalPanel vp = new VerticalPanel();
			vp.setSpacing(10);

			final TextField<String> eventCode = new TextField<String>();
			eventCode.setName("eventCode");
			eventCode.setValue("A28");
			eventCode.setFieldLabel("Event Code");
			eventCode.setReadOnly(true);
			uploadFormPanel.add(eventCode, formData);

			final TextField<String> matchingResult = new TextField<String>();
			matchingResult.setName("matchingResult");
			matchingResult.setValue("1");
			matchingResult.setFieldLabel("Matching Result");
			matchingResult.setReadOnly(true);
			uploadFormPanel.add(matchingResult, formData);

			final TextField<String> patno = new TextField<String>();
			patno.setName("patno");
			patno.setFieldLabel("Patient No.");
			patno.setReadOnly(true);
			uploadFormPanel.add(patno, formData);

			final TextField<String> ehrNo = new TextField<String>();
			ehrNo.setName("participant.ehrNo");

			final TextField<String> hkid = new TextField<String>();
			hkid.setName("participant.hkid");
			hkid.setFieldLabel("HKID No.");
			hkid.setReadOnly(true);

			final TextField<String> docType = new TextField<String>();
			docType.setName("participant.docType");
			docType.setFieldLabel("Type of Identity Document");
			docType.setReadOnly(true);

			final TextField<String> docNo = new TextField<String>();
			docNo.setName("participant.docNo");
			docNo.setFieldLabel("Identity Document Number");
			docNo.setReadOnly(true);

			final Button bGetEhrNo = new Button("Get eHR No.") {
				@Override
				protected void onClick(ComponentEvent ce) {
					if (ehrNo.getValue() == null || ehrNo.getValue().isEmpty()) {
						String ehrNoVal = getEhrNoFromBuildConsentHistory();
						if (ehrNoVal == null) {
							getEhrNoByIDsFromHist(hkid.getValue(), docType.getValue(), docNo.getValue(), ehrNo);
						} else {
							ehrNo.setValue(ehrNoVal);
						}
					}
				}
			};
			AdapterField getEhrNoAF = new AdapterField(bGetEhrNo);
			MultiField<Field> ehrNoMF = new MultiField<Field>();
			ehrNoMF.setFieldLabel("eHR No.");
			ehrNoMF.setLabelSeparator(":");
			ehrNoMF.add(ehrNo);
			ehrNoMF.add(getEhrNoAF);
			uploadFormPanel.add(ehrNoMF, formData);

			uploadFormPanel.add(hkid, formData);
			uploadFormPanel.add(docType, formData);
			uploadFormPanel.add(docNo, formData);

			final TextField<String> personEngSurname = new TextField<String>();
			personEngSurname.setName("participant.personEngSurname");
			personEngSurname.setFieldLabel("Eng Surname");
			personEngSurname.setReadOnly(true);
			uploadFormPanel.add(personEngSurname, formData);

			final TextField<String> personEngGivenName = new TextField<String>();
			personEngGivenName.setName("participant.personEngGivenName");
			personEngGivenName.setFieldLabel("Eng Given Name");
			personEngGivenName.setReadOnly(true);
			uploadFormPanel.add(personEngGivenName, formData);

			final HiddenField<String> personEngFullName = new HiddenField<String>();
			personEngFullName.setName("participant.personEngFullName");
			personEngFullName.setFieldLabel("Eng Full Name");
			personEngFullName.setReadOnly(true);
			uploadFormPanel.add(personEngFullName, formData);

			final HiddenField<String> personChiName = new HiddenField<String>();
			personChiName.setName("participant.personChiName");
			personChiName.setFieldLabel("Chi Name");
			personChiName.setReadOnly(true);
			uploadFormPanel.add(personChiName, formData);

			final TextField<String> sex = new TextField<String>();
			sex.setName("participant.sex");
			sex.setFieldLabel("Sex");
			sex.setReadOnly(true);
			uploadFormPanel.add(sex, formData);

			final TextField<String> birthDate = new TextField<String>();
			birthDate.setName("participant.birthDate");
			birthDate.setFieldLabel("Date of Birth (YYYY-MM-DD HH:MM:SS.SSS)");
			birthDate.setReadOnly(true);
			uploadFormPanel.add(birthDate, formData);

			final TextField<String> exactDateOfBirthInd = new TextField<String>();
			exactDateOfBirthInd.setName("participant.exactDateOfBirthInd");
			exactDateOfBirthInd.setValue("EDMY");
			exactDateOfBirthInd.setFieldLabel("DOB Indicator");
			exactDateOfBirthInd.setReadOnly(true);
			uploadFormPanel.add(exactDateOfBirthInd, formData);

			final HiddenField<String> ssoSessionId = new HiddenField<String>();
			ssoSessionId.setName("ssoSessionId");
			ssoSessionId.setValue(Factory.getInstance().getUserInfo().getSsoSessionID());
			uploadFormPanel.add(ssoSessionId, formData);

			final HiddenField<String> ssoModuleCode = new HiddenField<String>();
			ssoModuleCode.setName("ssoModuleCode");
			ssoModuleCode.setValue(Factory.getInstance().getUserInfo().getSsoModuleCode());
			uploadFormPanel.add(ssoModuleCode, formData);

			final HiddenField<String> ssoModuleUserId = new HiddenField<String>();
			ssoModuleUserId.setName("ssoModuleUserId");
			ssoModuleUserId.setValue(Factory.getInstance().getUserInfo().getUserID());
			uploadFormPanel.add(ssoModuleUserId, formData);

			final Button bSubmit = new Button("Send") {
				@Override
				protected void onClick(ComponentEvent ce) {
					if (ehrNo.getValue() == null || ehrNo.getValue().isEmpty()) {
						Factory.getInstance().addErrorMessage("No eHR No.");
						return;
					}

					uploadFormPanel.submit();
					setEnabled(false);
					Factory.getInstance().showMask(ehrSendMatchMsgWin);
				}
			};
			uploadFormPanel.addButton(bSubmit);

			final Button bCancel = new Button("Cancel") {
				@Override
				protected void onClick(ComponentEvent ce) {
					getEhrSendMatchMsgWin().hide();
				}
			};
			uploadFormPanel.addButton(bCancel);
			vp.add(uploadFormPanel);
			ehrSendMatchMsgWin.add(vp);
			ehrSendMatchMsgWin.addListener(Events.Show, new Listener<WindowEvent>() {
				@Override
				public void handleEvent(WindowEvent be) {
					// set vaue
					patno.setValue(currentPatNo);
					ehrNo.setValue(getEJText_cEhrNo().getText());
					hkid.setValue(getEJText_HKID().getText());
					docType.setValue(getEJCombo_docType().getText());
					docNo.setValue(getEJText_docNo().getText());
					personEngSurname.setValue(getEJText_FName().getText());
					personEngGivenName.setValue(getEJText_GName().getText());
					sex.setValue(getEJCombo_Sex().getText());
					birthDate.setValue(DateTimeUtil.formatEhrPmiDOBDateTime(DateTimeUtil.parseDate(getEJText_Dob().getText())));
					exactDateOfBirthInd.setValue(getEJCombo_ehrExactDobInd().getText());

					bSubmit.setEnabled(true);
					bCancel.focus();
				}
			});
		}
		return ehrSendMatchMsgWin;
	}

	private void getEhrNoByIDsFromHist(final String hkid, final String docType,
			final String docNo, final TextField<String> tfEhrno) {
		QueryUtil.executeMasterBrowse(getUserInfo(), "EHR_GETEHRNOBYIDS",
				new String[] { "LATEST", hkid, docType, docNo },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				boolean isFound = false;
				if (mQueue.success()) {
					String ehrNo = mQueue.getContentField()[0];
					if (ehrNo != null && !ehrNo.isEmpty()) {
						isFound = true;
						tfEhrno.setValue(ehrNo);
					}
				}

				if (!isFound) {
					String fieldName = null;
					if (hkid != null  && !hkid.isEmpty()) {
						fieldName  = "HKID No.";
					} else {
						fieldName  = "Identity Document Number";
					}
					Factory.getInstance().addErrorMessage("Cannot find eHR No. in history by matching " + fieldName + ".");
				}
			}
		});
	}

	private TableList getEhrEnrollHistTable() {
		if (ehrEnrollHistTable == null) {
			ehrEnrollHistTable = new TableList(
				getEhrEnrollHistColumnNames(),
				getEhrEnrollHistColumnWidths()
			);
			ehrEnrollHistTable.setBorders(true);
			ehrEnrollHistTable.setBounds(5, 30, 780, 195);
		}
		return ehrEnrollHistTable;
	}

	private String[] getEhrEnrollHistColumnNames() {
		return new String[] {
				"Patient No.",
				"eHR Msg No.",
				"Msg Event Code",
				"Enrollment Date",
				"eHR No.",
				"Start Date",
				"End Date",
				"Created Date",
				"Create By",
				"Family Name",
				"Given Name",
				"Date of Birth",
				"Exact DOB indicator",
				"Sex",
				"HKID No.",
				"doctype",
				"Type of Identity Document",
				"Identity Document No.",
				"Death"
				};
	}

	private int[] getEhrEnrollHistColumnWidths() {
		return new int[] { 80, 100, 95, 100, 90, 100, 100, 100, 100, 100, 100,
				70, 120, 40, 100, 0, 200, 120, 100};
	}

	private String getEhrNoFromBuildConsentHistory() {
		for (int i = 0; i < getEhrEnrollHistTable().getRowCount(); i++) {
			String eventCode = getEhrEnrollHistTable().getValueAt(i, 2);
			String ehrNo = getEhrEnrollHistTable().getValueAt(i, 4);
			if ("A28".equals(eventCode) && ehrNo != null && !ehrNo.isEmpty()) {
				return ehrNo;
			}
		}
		return null;
	}

	private ButtonBase getConsentTabButton() {
		if (consentTabBtn == null) {
			consentTabBtn = new ButtonBase() {
				public void onClick() {
					searchPatientByChangeTab();
					getRBTPanel().setSelectedIndex(4);
					defaultFocus();
				}
			};
			consentTabBtn.setVisible(false);
			consentTabBtn.setHotkey('O');
		}
		return regTabBtn;
	}

	public BasePanel getConsentPanel() {
		if (consentPanel == null) {
			consentPanel = new BasePanel();
			consentPanel.setLayout(null);
			consentPanel.setBounds(0, 0, 800, 480);
			consentPanel.add(getConsentInfoPanel1(), null);
			consentPanel.add(getConsentInfoPanel2(), null);
			consentPanel.add(getConsentInfoPanel3(), null);
			consentPanel.add(getConsentInfoPanel4(), null);
			consentPanel.add(getCSButton_BillingHistory());
		}
		return consentPanel;
	}

	public FieldSetBase getConsentInfoPanel1() {
		if (consentInfoPanel1 == null) {
			consentInfoPanel1 = new FieldSetBase();
			consentInfoPanel1.setBounds(5, 0, 788, 125);
			consentInfoPanel1.setHeading("PBO Consent #1");
			consentInfoPanel1.setStyleAttribute("background-color", "#EEFCEE");
			consentInfoPanel1.add(getCSJLabel_DateStart1());
			consentInfoPanel1.add(getCSJText_DateStart1());
			consentInfoPanel1.add(getCSJLabel_DateTo1());
			consentInfoPanel1.add(getCSJText_DateTo1());
			consentInfoPanel1.add(getCSJLabel_ArCode1());
			consentInfoPanel1.add(getCSJText_ArCode1());
			consentInfoPanel1.add(getCSJLabel_Remark1());
			consentInfoPanel1.add(getCSJText_Remark1());
			consentInfoPanel1.add(getCSJLabel_ConsentDoc1());
			consentInfoPanel1.add(getCSJButton_ConsentDoc1());
			consentInfoPanel1.add(getCSJLabel_LastUptBy1());
			consentInfoPanel1.add(getCSJText_LastUptBy1());
			consentInfoPanel1.add(getCSJLabel_LastUptTime1());
			consentInfoPanel1.add(getCSJText_LastUptTime1());
		}
		return consentInfoPanel1;
	}

	public FieldSetBase getConsentInfoPanel2() {
		if (consentInfoPanel2 == null) {
			consentInfoPanel2 = new FieldSetBase();
			consentInfoPanel2.setBounds(5, 125, 788, 125);
			consentInfoPanel2.setHeading("PBO Consent #2");
			consentInfoPanel2.setStyleAttribute("background-color", "#EEFCEE");
			consentInfoPanel2.add(getCSJLabel_DateStart2());
			consentInfoPanel2.add(getCSJText_DateStart2());
			consentInfoPanel2.add(getCSJLabel_DateTo2());
			consentInfoPanel2.add(getCSJText_DateTo2());
			consentInfoPanel2.add(getCSJLabel_ArCode2());
			consentInfoPanel2.add(getCSJText_ArCode2());
			consentInfoPanel2.add(getCSJLabel_Remark2());
			consentInfoPanel2.add(getCSJText_Remark2());
			consentInfoPanel2.add(getCSJLabel_ConsentDoc2());
			consentInfoPanel2.add(getCSJButton_ConsentDoc2());
			consentInfoPanel2.add(getCSJLabel_LastUptBy2());
			consentInfoPanel2.add(getCSJText_LastUptBy2());
			consentInfoPanel2.add(getCSJLabel_LastUptTime2());
			consentInfoPanel2.add(getCSJText_LastUptTime2());
		}
		return consentInfoPanel2;
	}

	public FieldSetBase getConsentInfoPanel3() {
		if (consentInfoPanel3 == null) {
			consentInfoPanel3 = new FieldSetBase();
			consentInfoPanel3.setBounds(5, 250, 788, 125);
			consentInfoPanel3.setHeading("Insurance Card | Policy");
			consentInfoPanel3.setStyleAttribute("background-color", "#FFFBFF");
			consentInfoPanel3.add(getCSJLabel_DateStart3());
			consentInfoPanel3.add(getCSJText_DateStart3());
			consentInfoPanel3.add(getCSJLabel_DateTo3());
			consentInfoPanel3.add(getCSJText_DateTo3());
			consentInfoPanel3.add(getCSJLabel_ArCode3());
			consentInfoPanel3.add(getCSJText_ArCode3());
			consentInfoPanel3.add(getCSJLabel_Remark3());
			consentInfoPanel3.add(getCSJText_Remark3());
			consentInfoPanel3.add(getCSJLabel_ConsentDoc3());
			consentInfoPanel3.add(getCSJButton_ConsentDoc3());
			consentInfoPanel3.add(getCSJLabel_LastUptBy3());
			consentInfoPanel3.add(getCSJText_LastUptBy3());
			consentInfoPanel3.add(getCSJLabel_LastUptTime3());
			consentInfoPanel3.add(getCSJText_LastUptTime3());
		}
		return consentInfoPanel3;
	}

	public FieldSetBase getConsentInfoPanel4() {
		if (consentInfoPanel4 == null) {
			consentInfoPanel4 = new FieldSetBase();
			consentInfoPanel4.setBounds(5, 375, 788, 80);
			consentInfoPanel4.setHeading("Insurance Case Remark");
			consentInfoPanel4.setStyleAttribute("background-color", "#FBFFFB");
			consentInfoPanel4.add(getTextArea_InsuranceRmk());
		}
		return consentInfoPanel4;
	}

	private LabelSmallBase getCSJLabel_DateStart1() {
		if (CSJLabel_DateStart1 == null) {
			CSJLabel_DateStart1 = new LabelSmallBase();
			CSJLabel_DateStart1.setText("Start Date");
			CSJLabel_DateStart1.setBounds(5, 0, 150, 20);
		}
		return CSJLabel_DateStart1;
	}

	private TextDate getCSJText_DateStart1() {
		if (CSJText_DateStart1 == null) {
			CSJText_DateStart1 = new TextDate() {
				@Override
				public void onBlur() {
					if (!isEmpty() && !isValid()) {
						Factory.getInstance().addErrorMessage("Invalid Start date.", CSJText_DateStart1);
						resetText();
						return;
					}
				};
			};
			CSJText_DateStart1.setBounds(155, 0, 200, 20);
		}
		return CSJText_DateStart1;
	}

	private LabelSmallBase getCSJLabel_DateTo1() {
		if (CSJLabel_DateTo1 == null) {
			CSJLabel_DateTo1 = new LabelSmallBase();
			CSJLabel_DateTo1.setText("Revoke Date");
			CSJLabel_DateTo1.setBounds(5, 25, 150, 20);
		}
		return CSJLabel_DateTo1;
	}

	private TextDate getCSJText_DateTo1() {
		if (CSJText_DateTo1 == null) {
			CSJText_DateTo1 = new TextDate() {
				@Override
				public void onBlur() {
					if (!isEmpty() && !isValid()) {
						Factory.getInstance().addErrorMessage("Invalid Revoke date.", CSJText_DateTo1);
						resetText();
						return;
					}
				};
			};
			CSJText_DateTo1.setBounds(155, 25, 200, 20);
		}
		return CSJText_DateTo1;
	}

	private LabelSmallBase getCSJLabel_ArCode1() {
		if (CSJLabel_ArCode1 == null) {
			CSJLabel_ArCode1 = new LabelSmallBase();
			CSJLabel_ArCode1.setText("AR Company");
			CSJLabel_ArCode1.setBounds(5, 50, 150, 20);
		}
		return CSJLabel_ArCode1;
	}

	private ComboARCompany getCSJText_ArCode1() {
		if (CSJText_ArCode1 == null) {
			CSJText_ArCode1 = new ComboARCompany();
			CSJText_ArCode1.setBounds(155, 50, 200, 20);
		}
		return CSJText_ArCode1;
	}

	private LabelSmallBase getCSJLabel_Remark1() {
		if (CSJLabel_Remark1 == null) {
			CSJLabel_Remark1 = new LabelSmallBase();
			CSJLabel_Remark1.setText("Remark");
			CSJLabel_Remark1.setBounds(5, 75, 150, 20);
		}
		return CSJLabel_Remark1;
	}

	private TextString getCSJText_Remark1() {
		if (CSJText_Remark1 == null) {
			CSJText_Remark1 = new TextString(50, true);
			CSJText_Remark1.setBounds(155, 75, 200, 20);
		}
		return CSJText_Remark1;
	}

	private LabelSmallBase getCSJLabel_ConsentDoc1() {
		if (CSJLabel_ConsentDoc1 == null) {
			CSJLabel_ConsentDoc1 = new LabelSmallBase();
			CSJLabel_ConsentDoc1.setText("Consent Document");
			CSJLabel_ConsentDoc1.setBounds(425, 0, 150, 20);
		}
		return CSJLabel_ConsentDoc1;
	}

	private ButtonBase getCSJButton_ConsentDoc1() {
		if (CSJButton_ConsentDoc1 == null) {
			CSJButton_ConsentDoc1 = new ButtonBase() {
				@Override
				public void onClick() {
					openNewWindow(getConsentUrl() + currentPatNo);
				}
			};
			CSJButton_ConsentDoc1.setText("View");
			CSJButton_ConsentDoc1.setBounds(575, 0, 75, 20);
		}
		return CSJButton_ConsentDoc1;
	}

	private LabelSmallBase getCSJLabel_LastUptBy1() {
		if (CSJLabel_LastUptBy1 == null) {
			CSJLabel_LastUptBy1 = new LabelSmallBase();
			CSJLabel_LastUptBy1.setText("Last Updated By");
			CSJLabel_LastUptBy1.setBounds(425, 25, 150, 20);
		}
		return CSJLabel_LastUptBy1;
	}

	private TextReadOnly getCSJText_LastUptBy1() {
		if (CSJText_LastUptBy1 == null) {
			CSJText_LastUptBy1 = new TextReadOnly();
			CSJText_LastUptBy1.setBounds(575, 25, 200, 20);
		}
		return CSJText_LastUptBy1;
	}

	private LabelSmallBase getCSJLabel_LastUptTime1() {
		if (CSJLabel_LastUptTime1 == null) {
			CSJLabel_LastUptTime1 = new LabelSmallBase();
			CSJLabel_LastUptTime1.setText("Last Updated Time");
			CSJLabel_LastUptTime1.setBounds(425, 50, 150, 20);
		}
		return CSJLabel_LastUptTime1;
	}

	private TextReadOnly getCSJText_LastUptTime1() {
		if (CSJText_LastUptTime1 == null) {
			CSJText_LastUptTime1 = new TextReadOnly();
			CSJText_LastUptTime1.setBounds(575, 50, 200, 20);
		}
		return CSJText_LastUptTime1;
	}

	private LabelSmallBase getCSJLabel_DateStart2() {
		if (CSJLabel_DateStart2 == null) {
			CSJLabel_DateStart2 = new LabelSmallBase();
			CSJLabel_DateStart2.setText("Start Date");
			CSJLabel_DateStart2.setBounds(5, 0, 150, 20);
		}
		return CSJLabel_DateStart2;
	}

	private TextDate getCSJText_DateStart2() {
		if (CSJText_DateStart2 == null) {
			CSJText_DateStart2 = new TextDate() {
				@Override
				public void onBlur() {
					if (!isEmpty() && !isValid()) {
						Factory.getInstance().addErrorMessage("Invalid Start date.", CSJText_DateStart2);
						resetText();
						return;
					}
				};
			};
			CSJText_DateStart2.setBounds(155, 0, 200, 20);
		}
		return CSJText_DateStart2;
	}

	private LabelSmallBase getCSJLabel_DateTo2() {
		if (CSJLabel_DateTo2 == null) {
			CSJLabel_DateTo2 = new LabelSmallBase();
			CSJLabel_DateTo2.setText("Revoke Date");
			CSJLabel_DateTo2.setBounds(5, 25, 150, 20);
		}
		return CSJLabel_DateTo2;
	}

	private TextDate getCSJText_DateTo2() {
		if (CSJText_DateTo2 == null) {
			CSJText_DateTo2 = new TextDate() {
				@Override
				public void onBlur() {
					if (!isEmpty() && !isValid()) {
						Factory.getInstance().addErrorMessage("Invalid Revoke date.", CSJText_DateTo2);
						resetText();
						return;
					}
				};
			};
			CSJText_DateTo2.setBounds(155, 25, 200, 20);
		}
		return CSJText_DateTo2;
	}

	private LabelSmallBase getCSJLabel_ArCode2() {
		if (CSJLabel_ArCode2 == null) {
			CSJLabel_ArCode2 = new LabelSmallBase();
			CSJLabel_ArCode2.setText("AR Company");
			CSJLabel_ArCode2.setBounds(5, 50, 150, 20);
		}
		return CSJLabel_ArCode2;
	}

	private ComboARCompany getCSJText_ArCode2() {
		if (CSJText_ArCode2 == null) {
			CSJText_ArCode2 = new ComboARCompany();
			CSJText_ArCode2.setBounds(155, 50, 200, 20);
		}
		return CSJText_ArCode2;
	}

	private LabelSmallBase getCSJLabel_Remark2() {
		if (CSJLabel_Remark2 == null) {
			CSJLabel_Remark2 = new LabelSmallBase();
			CSJLabel_Remark2.setText("Remark");
			CSJLabel_Remark2.setBounds(5, 75, 150, 20);
		}
		return CSJLabel_Remark2;
	}

	private TextString getCSJText_Remark2() {
		if (CSJText_Remark2 == null) {
			CSJText_Remark2 = new TextString(50, true);
			CSJText_Remark2.setBounds(155, 75, 200, 20);
		}
		return CSJText_Remark2;
	}

	private LabelSmallBase getCSJLabel_ConsentDoc2() {
		if (CSJLabel_ConsentDoc2 == null) {
			CSJLabel_ConsentDoc2 = new LabelSmallBase();
			CSJLabel_ConsentDoc2.setText("Consent Document");
			CSJLabel_ConsentDoc2.setBounds(425, 0, 150, 20);
		}
		return CSJLabel_ConsentDoc2;
	}

	private ButtonBase getCSJButton_ConsentDoc2() {
		if (CSJButton_ConsentDoc2 == null) {
			CSJButton_ConsentDoc2 = new ButtonBase() {
				@Override
				public void onClick() {
					openNewWindow(getConsentUrl() + currentPatNo + "-2");
				}
			};
			CSJButton_ConsentDoc2.setText("View");
			CSJButton_ConsentDoc2.setBounds(575, 0, 75, 20);
		}
		return CSJButton_ConsentDoc2;
	}

	private LabelSmallBase getCSJLabel_LastUptBy2() {
		if (CSJLabel_LastUptBy2 == null) {
			CSJLabel_LastUptBy2 = new LabelSmallBase();
			CSJLabel_LastUptBy2.setText("Last Updated By");
			CSJLabel_LastUptBy2.setBounds(425, 25, 150, 20);
		}
		return CSJLabel_LastUptBy2;
	}

	private TextReadOnly getCSJText_LastUptBy2() {
		if (CSJText_LastUptBy2 == null) {
			CSJText_LastUptBy2 = new TextReadOnly();
			CSJText_LastUptBy2.setBounds(575, 25, 200, 20);
		}
		return CSJText_LastUptBy2;
	}

	private LabelSmallBase getCSJLabel_LastUptTime2() {
		if (CSJLabel_LastUptTime2 == null) {
			CSJLabel_LastUptTime2 = new LabelSmallBase();
			CSJLabel_LastUptTime2.setText("Last Updated Time");
			CSJLabel_LastUptTime2.setBounds(425, 50, 150, 20);
		}
		return CSJLabel_LastUptTime2;
	}

	private TextReadOnly getCSJText_LastUptTime2() {
		if (CSJText_LastUptTime2 == null) {
			CSJText_LastUptTime2 = new TextReadOnly();
			CSJText_LastUptTime2.setBounds(575, 50, 200, 20);
		}
		return CSJText_LastUptTime2;
	}

	private LabelSmallBase getCSJLabel_DateStart3() {
		if (CSJLabel_DateStart3 == null) {
			CSJLabel_DateStart3 = new LabelSmallBase();
			CSJLabel_DateStart3.setText("Start Date");
			CSJLabel_DateStart3.setBounds(5, 0, 150, 20);
		}
		return CSJLabel_DateStart3;
	}

	private TextDate getCSJText_DateStart3() {
		if (CSJText_DateStart3 == null) {
			CSJText_DateStart3 = new TextDate() {
				@Override
				public void onBlur() {
					if (!isEmpty() && !isValid()) {
						Factory.getInstance().addErrorMessage("Invalid Start date.", CSJText_DateStart3);
						resetText();
						return;
					}
				};
			};
			CSJText_DateStart3.setBounds(155, 0, 200, 20);
		}
		return CSJText_DateStart3;
	}

	private LabelSmallBase getCSJLabel_DateTo3() {
		if (CSJLabel_DateTo3 == null) {
			CSJLabel_DateTo3 = new LabelSmallBase();
			CSJLabel_DateTo3.setText("Revoke Date");
			CSJLabel_DateTo3.setBounds(5, 25, 150, 20);
		}
		return CSJLabel_DateTo3;
	}

	private TextDate getCSJText_DateTo3() {
		if (CSJText_DateTo3 == null) {
			CSJText_DateTo3 = new TextDate() {
				@Override
				public void onBlur() {
					if (!isEmpty() && !isValid()) {
						Factory.getInstance().addErrorMessage("Invalid Revoke date.", CSJText_DateTo3);
						resetText();
						return;
					}
				};
			};
			CSJText_DateTo3.setBounds(155, 25, 200, 20);
		}
		return CSJText_DateTo3;
	}

	private LabelSmallBase getCSJLabel_ArCode3() {
		if (CSJLabel_ArCode3 == null) {
			CSJLabel_ArCode3 = new LabelSmallBase();
			CSJLabel_ArCode3.setText("AR Company");
			CSJLabel_ArCode3.setBounds(5, 50, 150, 20);
		}
		return CSJLabel_ArCode3;
	}

	private ComboARCompany getCSJText_ArCode3() {
		if (CSJText_ArCode3 == null) {
			CSJText_ArCode3 = new ComboARCompany();
			CSJText_ArCode3.setBounds(155, 50, 200, 20);
		}
		return CSJText_ArCode3;
	}

	private LabelSmallBase getCSJLabel_Remark3() {
		if (CSJLabel_Remark3 == null) {
			CSJLabel_Remark3 = new LabelSmallBase();
			CSJLabel_Remark3.setText("Remark");
			CSJLabel_Remark3.setBounds(5, 75, 150, 20);
		}
		return CSJLabel_Remark3;
	}

	private TextString getCSJText_Remark3() {
		if (CSJText_Remark3 == null) {
			CSJText_Remark3 = new TextString(50, true);
			CSJText_Remark3.setBounds(155, 75, 200, 20);
		}
		return CSJText_Remark3;
	}

	private LabelSmallBase getCSJLabel_ConsentDoc3() {
		if (CSJLabel_ConsentDoc3 == null) {
			CSJLabel_ConsentDoc3 = new LabelSmallBase();
			CSJLabel_ConsentDoc3.setText("Card/Policy");
			CSJLabel_ConsentDoc3.setBounds(425, 0, 150, 20);
		}
		return CSJLabel_ConsentDoc3;
	}

	private ButtonBase getCSJButton_ConsentDoc3() {
		if (CSJButton_ConsentDoc3 == null) {
			CSJButton_ConsentDoc3 = new ButtonBase() {
				@Override
				public void onClick() {
					openNewWindow(getConsentUrl() + currentPatNo + "-INSU");
				}
			};
			CSJButton_ConsentDoc3.setText("View");
			CSJButton_ConsentDoc3.setBounds(575, 0, 75, 20);
		}
		return CSJButton_ConsentDoc3;
	}

	private LabelSmallBase getCSJLabel_LastUptBy3() {
		if (CSJLabel_LastUptBy3 == null) {
			CSJLabel_LastUptBy3 = new LabelSmallBase();
			CSJLabel_LastUptBy3.setText("Last Updated By");
			CSJLabel_LastUptBy3.setBounds(425, 25, 150, 20);
		}
		return CSJLabel_LastUptBy3;
	}

	private TextReadOnly getCSJText_LastUptBy3() {
		if (CSJText_LastUptBy3 == null) {
			CSJText_LastUptBy3 = new TextReadOnly();
			CSJText_LastUptBy3.setBounds(575, 25, 200, 20);
		}
		return CSJText_LastUptBy3;
	}

	private LabelSmallBase getCSJLabel_LastUptTime3() {
		if (CSJLabel_LastUptTime3 == null) {
			CSJLabel_LastUptTime3 = new LabelSmallBase();
			CSJLabel_LastUptTime3.setText("Last Updated Time");
			CSJLabel_LastUptTime3.setBounds(425, 50, 150, 20);
		}
		return CSJLabel_LastUptTime3;
	}

	private TextReadOnly getCSJText_LastUptTime3() {
		if (CSJText_LastUptTime3 == null) {
			CSJText_LastUptTime3 = new TextReadOnly();
			CSJText_LastUptTime3.setBounds(575, 50, 200, 20);
		}
		return CSJText_LastUptTime3;
	}

	private TextAreaBase getTextArea_InsuranceRmk() {
		if (TextArea_InsuranceRmk == null) {
			TextArea_InsuranceRmk = new TextAreaBase(1000);
			TextArea_InsuranceRmk.setBounds(10, 5, 765, 50);
		}
		return TextArea_InsuranceRmk;
	}

	private ButtonBase getCSButton_BillingHistory() {
		if (CSButton_BillingHistory == null) {
			CSButton_BillingHistory = new ButtonBase() {
				@Override
				public void onClick() {
					getDlgSlipList().showDialog(getRTJText_PatientNumber().getText().trim());
				}
			};
			CSButton_BillingHistory.setBounds(658, 470, 135, 23);
			CSButton_BillingHistory.setText("Billing History", 'H');
		}
		return CSButton_BillingHistory;
	}

	public BasePanel getFTOCC() {
		if (FTOCCPanel == null) {
			FTOCCPanel = new BasePanel();
			FTOCCPanel.setLayout(null);
			FTOCCPanel.setBounds(0, 0, 800, 480);
		}
		return FTOCCPanel;
	}
	
	public BasePanel getAppAdmin() {
		if (appAdminPanel == null) {
			appAdminPanel = new BasePanel();
			appAdminPanel.setLayout(null);
			appAdminPanel.setBounds(0, 0, 800, 480);
		}
		return appAdminPanel;
	}

	private void checkEhrHKIDTypeConflict(final String actionType, final CallbackListener callback) {
		if (getEJText_HKID().getText() != null && "ID".equals(getEJCombo_docType().getText())) {
			MessageBoxBase.confirm(MSG_PBA_SYSTEM, "You have filled HKID No.. Type of Identity Document should leave it blank.",
					new Listener<MessageBoxEvent>() {
				@Override
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						getEJCombo_docType().setText("");
					}
					callback.handleRetBool(true, null, null);
				}
			});
		} else {
			callback.handleRetBool(true, null, null);
		}
	}

	private void checkEhrPatDupl(final String actionType) {
		checkEhrPatDupl(Factory.getInstance().getSysParameter("EHRPMICKPD"), new CallbackListener() {
			@Override
			public void handleRetBool(boolean ret,
					String result,
					MessageQueue mQueue) {
				if (ret) {
					callActionValidationReady(actionType, true);
				} else {
					getDlgEhrPmiDupl(actionType).showDialog(mQueue);
				}
			}
		});
	}

	private void checkEhrPatDupl(String matchType, final CallbackListener callback) {
		QueryUtil.executeMasterBrowse(getUserInfo(), "EHR_PMI_DUPL",
				new String[] {
					currentPatNo,
					getEJText_FName().getText(),
					getEJText_GName().getText(),
					getEJText_Dob().getText(),
					getEJCombo_Sex().getText(),
					getEJText_HKID().getText(),
					getEJText_docNo().getText(),
					getEJCombo_docType().getText(),
					getEJCombo_ehrExactDobInd().getText(),
					matchType,
				},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mq) {
				callback.handleRetBool(!mq.success(), null, mq);
			}
		});
	}

	private boolean isEhrPmiExist() {
		return !getEJText_Dob().getText().isEmpty();
	}

	private boolean isEhrPmiActive() {
		return ((String) getEJLabel_cEhrActive().getData("l_active")).equals(getEJLabel_cEhrActive().getText());
	}
}