/*
 * Created on July 23, 2008
 *
 * To change the template for this generated file go to
 */
package com.hkah.client.tx.transaction;

import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.FieldEvent;
import com.extjs.gxt.ui.client.event.FormEvent;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.MessageBox;
import com.extjs.gxt.ui.client.widget.Window;
import com.extjs.gxt.ui.client.widget.form.FormPanel;
import com.extjs.gxt.ui.client.widget.form.FormPanel.Method;
import com.extjs.gxt.ui.client.widget.form.TextField;
import com.extjs.gxt.ui.client.widget.layout.AbsoluteLayout;
import com.google.gwt.event.dom.client.KeyCodes;
import com.google.gwt.json.client.JSONObject;
import com.google.gwt.json.client.JSONParser;
import com.google.gwt.json.client.JSONValue;
import com.hkah.client.common.Factory;
import com.hkah.client.common.TxnCallBack;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboACMCode;
import com.hkah.client.layout.combobox.ComboARCompany;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.combobox.ComboCategory;
import com.hkah.client.layout.combobox.ComboCoPayRefType;
import com.hkah.client.layout.combobox.ComboTranDtlOrderBy;
import com.hkah.client.layout.dialog.DlgARCardRemark;
import com.hkah.client.layout.dialog.DlgARCardTypeSel;
import com.hkah.client.layout.dialog.DlgBudgetEstBase;
import com.hkah.client.layout.dialog.DlgCalRefItem;
import com.hkah.client.layout.dialog.DlgCalSpec;
import com.hkah.client.layout.dialog.DlgChangeACM;
import com.hkah.client.layout.dialog.DlgChangeAmount;
import com.hkah.client.layout.dialog.DlgChgRptLvl;
import com.hkah.client.layout.dialog.DlgChrgDayCase;
import com.hkah.client.layout.dialog.DlgConPceChange;
import com.hkah.client.layout.dialog.DlgEnterConfinement;
import com.hkah.client.layout.dialog.DlgIPOfficialReceipt;
import com.hkah.client.layout.dialog.DlgIPStmtORIPStmtSmy;
import com.hkah.client.layout.dialog.DlgIPStmtOROffReceipt;
import com.hkah.client.layout.dialog.DlgOPDayCaseStatement;
import com.hkah.client.layout.dialog.DlgOSBillAlert;
import com.hkah.client.layout.dialog.DlgPatientAlert;
import com.hkah.client.layout.dialog.DlgPaymentInstruction;
import com.hkah.client.layout.dialog.DlgPkgCode;
import com.hkah.client.layout.dialog.DlgReason;
import com.hkah.client.layout.dialog.DlgReminderLetter;
import com.hkah.client.layout.dialog.DlgReprintRpt;
import com.hkah.client.layout.dialog.DlgSlipList;
import com.hkah.client.layout.dialog.DlgSlipRemark;
import com.hkah.client.layout.dialog.DlgTransOT;
import com.hkah.client.layout.dialog.DlgTxHistory;
import com.hkah.client.layout.dialog.DlgTxUpdateBed;
import com.hkah.client.layout.dialog.DlgUpdateDoctor;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelSmallBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.textfield.TextAmount;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextReadOnlyAmount;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.ActionPaymentPanel;
import com.hkah.client.tx.cashier.Cashiers;
import com.hkah.client.tx.insuranceCard.ARCardLink;
import com.hkah.client.tx.registration.Patient;
import com.hkah.client.tx.registration.PrintOBCert;
import com.hkah.client.tx.registration.RegistrationDischarge;
import com.hkah.client.tx.report.LabSummaryReport;
import com.hkah.client.tx.schedule.DoctorAppointment;
import com.hkah.client.util.AppStmtUtil;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.PanelUtil;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.Report;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTransaction;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class TransactionDetail extends ActionPaymentPanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.TRANSACTION_DETAIL_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.TRANSACTION_DETAIL_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Seq No", "Pkg", "Ref", "Item", "Type", "Description", "Unit", "I-Ref", "Disc %", "Net Amount",
				"Amount", "Dr Code", "Txn Date", "Service Code", "Status", "Speciality", "User ID", "Class", "Report Level", "Capture Date",
				"Glc", "Doctor Name", "STNID", "STNADOC", "STNXREF", "XRGID", "Stntype", "stncpsflag", "Dixref", "Stnoamt",
				"StnAscm", EMPTY_VALUE, EMPTY_VALUE, EMPTY_VALUE, EMPTY_VALUE, EMPTY_VALUE, EMPTY_VALUE, EMPTY_VALUE, EMPTY_VALUE};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				45, 45, 45, 45, 0,  200, 30, 50, 45, 0,
				70, 50, 65, 75, 40, 120, 70, 50, 70, 110,
				0,  0,  0,  0,  0,   0,  0,  0,  0,  0,
				0,  0,  0,  0,  0,   0,  0,  0,  0};
	}

	@Override
	public int getColumnKey() {
		return 0;
	}

	/* >>> ~4a~ Set Table Column Menu  ==================================== <<< */
	@Override
	public boolean getNotShowMenu() {
		if (YES_VALUE.equals(getSysParameter("TxDtlColMu"))) {
			return false;
		} else {
			return true;
		}
	}

	@Override
	public boolean[] getMenuDefault1List() {
		//true when the column need to hide
		return new boolean[] {
				false, false, false, false, true, false, true, false, true, true,
				false, false, false, true, true, true, false, true, true, false,
				true, true, true, true, true, true, true, true, true, true,
				true, true, true, true, true, true, true, true, true};
	}

	@Override
	public boolean getShowSort() {
		return false;
	}

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;
	private FieldSetBase slipDetailPanel = null;
	private LabelSmallBase RightJLabel_SlipNo = null;
	private TextReadOnly RightJText_SlipNo = null;
	private LabelSmallBase RightJLabel_PatientNo = null;
	private TextReadOnly RightJText_PatientNo = null;
	private TextReadOnly RightJText_PatientName = null;
	private LabelSmallBase RightJLabel_Staff = null;
	private CheckBoxBase RightJCheckBox_Staff = null;
	private LabelSmallBase RightJLabel_BedCode = null;
	private TextReadOnly RightJText_BedCode = null;
	private LabelSmallBase RightJLabel_AcmDesc = null;
	private TextReadOnly RightJText_AcmDesc = null;

	private BasePanel totalPanel = null;
	private LabelSmallBase RightJLabel_AdmissionDate = null;
	private TextReadOnly RightJText_AdmissionDate = null;
	private LabelSmallBase RightJLabel_Doctor = null;
	private TextReadOnly RightJText_Doctor = null;
	private TextReadOnly RightJText_DoctorName = null;
	private LabelSmallBase RightJLabel_DischargeDate = null;
	private TextReadOnly RightJText_DischargeDate = null;
	private LabelSmallBase RightJLabel_MAllocate = null;
	private CheckBoxBase RightJCheckBox_MAllocate = null;
	private LabelSmallBase RightJLabel_SourceNo = null;
	private TextString RightJText_SourceNo = null;
	private LabelSmallBase RightJLabel_ARCompanyCode = null;
	private ComboARCompany RightJCombo_ARCompanyCode = null;
	private TextReadOnly RightJText_ARCompanyDesc = null;
	private TextReadOnly RightJText_ARCardType = null;
	private LabelSmallBase RightJLabel_PolicyNo = null;
	private TextString RightJText_PolicyNo = null;
	private LabelSmallBase RightJLabel_VoucherNo = null;
	private TextString RightJText_VoucherNo = null;
	private LabelSmallBase RightJLabel_PreAuthNo = null;
	private TextString RightJText_PreAuthNo = null;
	private LabelSmallBase INJLabel_PrtMedRecordRpt = null;
	private CheckBoxBase INJCheckBox_PrtMedRecordRpt = null;
	private LabelSmallBase RightJLabel_CategoryNo = null;
	private ComboCategory RightJCombo_CategoryNo = null;
	private LabelSmallBase RightJLabel_RefNo = null;
	private TextString RightJText_CategoryName = null;
	private LabelSmallBase RightJLabel_Misc = null;
	private ComboBoxBase RightJCombo_Misc = null;
	private LabelSmallBase RightJLabel_Nature = null;
	private TextReadOnly RightJText_Nature = null;
	private LabelSmallBase RightJLabel_Source = null;
	private ComboBoxBase RightJCombo_Source = null;
	private LabelSmallBase RightJLabel_LimitAmount = null;
	private TextAmount RightJText_LimitAmount = null;
	private LabelSmallBase RightJLabel_CoPayRefNo = null;
	private ComboCoPayRefType RightJCombo_CoPayRefType = null;
	private TextString RightJText_CoPayRefAmount = null;
	private LabelSmallBase RightJLabel_CoPayActualNo = null;
	private TextString RightJText_CoPayActualAmount = null;
	private LabelSmallBase RightJLabel_CvtEndDate = null;
	private TextDate RightJText_CvtEndDate = null;
	private LabelSmallBase RightJLabel_FGrtAmount = null;
	private TextAmount RightJText_FGrtAmount = null;
	private LabelSmallBase RightJLabel_FGrtDate = null;
	private TextDate RightJText_FGrtDate = null;

	private ButtonBase RightButton_Remarks = null;
	private TextString RightJText_Remarks = null;
	private LabelSmallBase RightJLabel_Complex = null;
	private CheckBoxBase RightJCheckBox_Complex = null;

	private BasePanel coveredItemPanel = null;
	private LabelSmallBase RightJLabel_CoverredItem = null;
	private LabelSmallBase RightJLabel_CoverredItemDoctor = null;
	private CheckBoxBase RightJCheckBox_CoverredItemDoctor = null;
	private LabelSmallBase RightJLabel_CoverredItemHospital = null;
	private CheckBoxBase RightJCheckBox_CoverredItemHospital = null;
	private LabelSmallBase RightJLabel_CoverredItemSpecial = null;
	private CheckBoxBase RightJCheckBox_CoverredItemSpecial = null;
	private LabelSmallBase RightJLabel_CoverredItemOther = null;
	private CheckBoxBase RightJCheckBox_CoverredItemOther = null;

	private LabelSmallBase RightJLabel_TotalCharges = null;
	private TextReadOnlyAmount RightJText_TotalCharges = null;
	private LabelSmallBase RightJLabel_TotalPayment = null;
	private TextReadOnlyAmount RightJText_TotalPayment = null;
	private LabelSmallBase RightJLabel_TotalCredit = null;
	private TextReadOnlyAmount RightJText_TotalCredit = null;
	private LabelSmallBase RightJLabel_Balance = null;
	private TextReadOnlyAmount RightJText_Balance = null;
	private LabelSmallBase RightJLabel_RoomPhone = null;
	private TextReadOnly RightJText_RoomPhone = null;

	private LabelSmallBase RightJLabel_TotalHospitalCharges = null;
	private TextReadOnlyAmount RightJText_TotalHospitalCharges = null;
	private LabelSmallBase RightJLabel_TotalDoctorCharges = null;
	private TextReadOnlyAmount RightJText_TotalDoctorCharges = null;
	private LabelSmallBase RightJLabel_TotalSpecialCharges = null;
	private TextReadOnlyAmount RightJText_TotalSpecialCharges = null;
	private LabelSmallBase RightJLabel_TotalRefund = null;
	private TextReadOnlyAmount RightJText_TotalRefund = null;
	private LabelSmallBase RightJLabel_OTCount = null;
	private ButtonBase RightJText_OT = null;
	private TextReadOnly RightJText_OTCount = null;

	private FieldSetBase discountPanel = null;
	private LabelSmallBase RightJLabel_HospitalDiscount = null;
	private TextAmount RightJText_HospitalDiscount = null;
	private LabelSmallBase RightJLabel_HospitalDiscountSuffix = null;
	private LabelSmallBase RightJLabel_DoctorDiscount = null;
	private TextAmount RightJText_DoctorDiscount = null;
	private LabelSmallBase RightJLabel_DoctorDiscountSuffix = null;
	private LabelSmallBase RightJLabel_SpecialDiscount = null;
	private TextAmount RightJText_SpecialDiscount = null;
	private LabelSmallBase RightJLabel_SpecialDiscountSuffix = null;
	private LabelSmallBase RightJLabel_SendBillDate = null;
	private TextDate RightJText_SendBillDate = null;
	private ComboBoxBase RightJCombo_SendBillType = null;
	private LabelSmallBase RightJLabel_SpRqt = null;
	private ComboBoxBase RightJCombo_SpRqt = null;
	private LabelSmallBase RightJLabel_Package = null;
	private ComboBoxBase RightJCombo_Package = null;
	private LabelSmallBase RightJLabel_NoSign = null;
	private ComboBoxBase RightJCombo_NoSign = null;
	private LabelSmallBase PJLabel_RevLog = null;
	private CheckBoxBase PJCheckBox_RevLog = null;
	private LabelSmallBase RightJLabel_LogCvrCls = null;
	private ComboACMCode RightJCombo_LogCvrCls = null;
	private LabelSmallBase PJLabel_EstGiven = null;
	private CheckBoxBase PJCheckBox_EstGiven = null;
	private LabelSmallBase PJCheckBox_BEDesc = null;
	private CheckBoxBase PJCheckBox_BE = null;
	private LabelSmallBase RightJLabel_AR = null;
	private CheckBoxBase RightJCheckBox_AR = null;
	private CheckBoxBase ShowHistory = null;
	private LabelSmallBase ShowHistoryDesc = null;
	private BasePanel btnPanel = null;
	private JScrollPane RightJScrollPane_Detail = null;

	private ButtonBase RightButton_Charge = null;
	private ButtonBase RightButton_Adjust = null;
	private ButtonBase RightButton_Update = null;
	private ButtonBase RightButton_UpDocCode = null;
	private ButtonBase RightButton_UpdateBed = null;
	private ButtonBase RightButton_Payment = null;
	private ButtonBase RightButton_CancelItem = null;
	private ButtonBase RightButton_CancelPkg = null;
	private ButtonBase RightButton_AddCItem = null;
	private ButtonBase RightButton_AddCItemPer = null;
	private ButtonBase RightButton_PkgTxn = null;
	private ButtonBase RightButton_Refund = null;
	private ButtonBase RightButton_CloseBill = null;
	private ButtonBase RightButton_DoctorAllow = null;
	private ButtonBase RightButton_CalRefItem = null;
	private ButtonBase RightButton_SpecCal = null;
	private ButtonBase RightButton_PatDetail = null;
	private ButtonBase RightButton_PrintTotalReceipt = null;
	private ButtonBase RightButton_Statement = null;
	private ButtonBase RightButton_Reprint = null;
	private DlgReprintRpt dlgReprintRpt = null;
	private ButtonBase RightButton_MovetoPkgtx = null;
	private ButtonBase RightButton_MovePkgtoPkgtx = null;
	private ButtonBase RightButton_ChangeRLvl = null;
	private ButtonBase RightButton_ChangeAmount = null;
	private ButtonBase RightButton_ChangeAcm = null;
	private ButtonBase RightButton_Log = null;
	private ButtonBase RightButton_PrintCert = null;
	private ButtonBase RightButton_CashierSignOn = null;
	private ButtonBase RightButton_BillSummary = null;
	private ButtonBase RightButton_Supp = null;
	private ButtonBase RightButton_PrtSupp = null;
	private ButtonBase RightButton_LabReport = null;
	private ButtonBase RightButton_DoctorAppointment = null;
	private ButtonBase RightButton_PatientRegistration = null;
	private ButtonBase RightButton_Consent = null;
	private ButtonBase RightButton_ReOpenSlip = null;
	private ButtonBase RightButton_CancelSlip = null;
	private ButtonBase RightButton_OtherSlip = null;
	private ButtonBase RightButton_DischargeCheck = null;
	private ButtonBase RightButton_ReminderLetter = null;
	private ButtonBase RightButton_Deposit = null;
	private ButtonBase RightButton_MovetoPkgtx2 = null;
	private ButtonBase RightButton_BudgetEst = null;
	private ButtonBase RightButton_SendDisChrgSMS = null;
	private ButtonBase RightButton_Insurance = null;
	private ButtonBase RightButton_MobBill = null;
	private ButtonBase RightButton_PkgDetails = null;
	private ButtonBase RightButton_sendSMSTelemed = null;

	private DlgBudgetEstBase dlgBudgetEst = null;
	private DlgARCardRemark dlgARCardRemark = null;
	private DlgCalRefItem dlgCalRefItem = null;
	private DlgCalSpec dlgCalSpec = null;
	private DlgChangeACM dlgChangeACM = null;
	private DlgChangeAmount dlgChangeAmount = null;
	private DlgChgRptLvl dlgChgRptLvl = null;
	private DlgConPceChange dlgConPceChange = null;
	private DlgEnterConfinement dlgEnterConfinement = null;
	private DlgIPOfficialReceipt dlgIPOfficialReceipt = null;
	private DlgIPStmtORIPStmtSmy dlgIPStmtORIPStmtSmy = null;
	private DlgIPStmtOROffReceipt dlgIPStmtOROffReceipt = null;
	private DlgOPDayCaseStatement dlgOPDayCaseStatement = null;
	private DlgChrgDayCase dlgChrgDayCase = null;
	private DlgReminderLetter dlgReminderLetter = null;
	private DlgPkgCode dlgPkgCodeMvItm2Ref = null;
	private DlgPkgCode dlgPkgCodeMvPkg2Ref = null;
	private DlgReason dlgReason = null;
	private DlgSlipRemark dlgSlipRemark = null;
	private DlgTransOT dlgTransOT = null;
	private DlgTxUpdateBed dlgTxUpdateBed = null;
	private DlgUpdateDoctor dlgUpdateDoctor = null;
	private DlgARCardTypeSel dlgARCardTypeSel = null;
	private DlgARCardRemark dlgARCardRemarkForPayment = null;
	private DlgPaymentInstruction dlgPaymentInstruction = null;
	private DlgTxHistory dlgTxHistory = null;
	private DlgSlipList dlgSlipList = null;
	private DlgPatientAlert dlgPatientAlert = null;
	private DlgOSBillAlert dlgOSBillAlert = null;

	private String oldSlpNo = null;
	private String slpNo = null;
	private String slipType = null;
	private String spcName = null;
	private String slpsts = null;
	private String regid = EMPTY_VALUE;
	private String inpid = null;
	private String patCName = null;
	private String patSex = null;
//	private String slpPayAllCheckValue = null;
	private boolean chgAmtFlg = false;
	private String smtRemark = null;
	private String isUpdAllSlpNoSign = "N";

	// old value
	private String memLimitAmt = EMPTY_VALUE;
	private String memCoPayType = EMPTY_VALUE;
	private String memCoPayAmt = EMPTY_VALUE;
	private String memCvrEndDate = EMPTY_VALUE;
	private String memHDisc = EMPTY_VALUE;
	private String memDDisc = EMPTY_VALUE;
	private String memSDisc = EMPTY_VALUE;
	private String memCvrItem = EMPTY_VALUE;
	private String memGrtAmt = EMPTY_VALUE;
	private String memGrtDate = EMPTY_VALUE;
	private String memStnid = EMPTY_VALUE;
	private String memPcyID = null;
	private String memPrintDate = EMPTY_VALUE;
//	private String rmkmodusr = EMPTY_VALUE;
//	private String rmkmoddt = EMPTY_VALUE;
	private String memActID = EMPTY_VALUE;
	private LabelSmallBase orderbydesc = null;
	private ComboTranDtlOrderBy orderBy = null;
	private String checkDate = null;
	private String[] select = null;
	private String memArcCode = null;
	private String dNCTRSDate = EMPTY_VALUE;
	private String dNCTREDate = EMPTY_VALUE;
	private String sNoContractMsg = EMPTY_VALUE;
	private String regDate = EMPTY_VALUE;
	private String sFromWhere = EMPTY_VALUE;
	private String lang;
	private String newCpsId = EMPTY_VALUE;
	private String memNoSign = EMPTY_VALUE;
	private String memFESTID = EMPTY_VALUE;
	private String memAcmCode = EMPTY_VALUE;
	private String memTelemedURL = EMPTY_VALUE;

	private boolean isFromSrhPatStsView = false;
	private boolean isEmptySource = false;
	private String lastSelectedItemKey = null;
//	private boolean LoadFirstTime = false;
	private boolean showAlert = false;

	private boolean arSignature = false;
	private boolean arInpSmySignature = false;
	private String mothLang = null;
	private boolean isLocked = false;
	private boolean isReadOnly = false;
	private boolean isAlertLOG = false;
	private String regPkgCode = null;

	private int STNSEQ_COL = 0;
	private int PKGCODE_COL = 1;
	private int STNID_COL = 2;
	private int ITMCODE_COL = 3;
	private int ITMTYPE_COL = 4;
	private int STNDESC_COL = 5;
	private int STNDISC_COL = 8;
	private int STNNAMT_COL = 9;
	private int STNBAMT_COL = 10;
	private int DOCCODE_COL = 11;
	private int STNTDATE_COL = 12;
	private int DSCCODE_COL = 13;
	private int STNSTS_COL = 14;
	private int ACMCODE_COL = 17;
	private int STNRLVL_COL = 18;
	private int STNCDATE_COL = 38;
	private int GLCCODE_COL = 20;
	private int DOCNAME_COL = 21;
	private int STNID2_COL = 22;
	private int STNADOC_COL = 23;
	private int STNXREF_COL = 24;
	private int STNTYPE_COL = 26;
	private int STNCPSFLAG_COL = 27;
	private int DIXREF_COL = 28;
	private int STNOAMT_COL = 29;
	private int STNASCM_COL = 30;
	private int BISNULL_COL = 34;
	private int ISEPSPAYMENT_COL = 35;
	private int ISCHEQUETRANSACTION_COL = 36;
	private int XRSTNID_COL = 37;
//	private int PAYMENTMETHOD_COL = ??;

	/**
	 * This method initializes
	 *
	 */
	public TransactionDetail() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		/* >>> ~7.1~ Init action (e.g. Listing, Init Comobbox ========= <<< */
		setFullEntry(true);
		setNoGetDB(false);

		/* >>> ~7.2~ Disable Add/Modify/Delete Buttons ================ <<< */
		oldSlpNo = null;
		slpNo = getParameter("SlpNo");
		isLocked = YES_VALUE.equals(getParameter("isLocked"));
		isReadOnly = YES_VALUE.equals(getParameter("isReadOnly"));
		if (slpNo != null && slpNo.length() > 0) {
			if (!isLocked && !isReadOnly) {
				lockRecord("Slip", slpNo);
			} else {
				skipLockRecord();
			}
			resetParameter("SlpNo");
			return true;
		} else {
			return false;
		}
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		showAlert = false;

		if (HKAH_VALUE.equals(getUserInfo().getSiteCode())) {
			getSlipDetailPanel().setBounds(5, 0, 810, 155);
			getRightJLabel_SlipNo().setText("Slip #");
			getRightJLabel_SlipNo().setBounds(5, -5, 50, 20);
			getRightJText_SlipNo().setBounds(49, -5, 88, 20);
			getRightJLabel_PatientNo().setBounds(141, -5, 88, 20);
			getRightJText_PatientNo().setBounds(175, -5, 68, 20);
			getRightJText_PatientName().setBounds(245, -5, 210, 20);
			getRightJLabel_Staff().setBounds(457, -5, 25, 20);
			getRightJCheckBox_Staff().setBounds(480, -5, 20, 20);
			getRightJLabel_BedCode().setText("Bed");
			getRightJLabel_BedCode().setBounds(500, -5 ,28, 20);
			getRightJText_BedCode().setBounds(523, -5, 65, 20);
			getRightJLabel_AcmDesc().setBounds(588, -5, 40, 20);
			getRightJText_AcmDesc().setBounds(620, -5, 35, 20);

			getRightJLabel_ARCompanyCode().setText("AR");
			getRightJCombo_ARCompanyCode().setBounds(35, 39, 45, 20);
			getRightJText_ARCompanyDesc().setBounds(132, 39, 111, 20);
			getRightJText_ARCardType().setBounds(245, 39, 100, 20);
			getRightJLabel_PolicyNo().setBounds(350, 39, 50, 20);
			getRightJText_PolicyNo().setBounds(392, 39, 100, 20);
			getRightJLabel_VoucherNo().setBounds(495, 39, 55, 20);
			getRightJText_VoucherNo().setBounds(529, 39, 40, 20);
			getRightJLabel_PreAuthNo().setBounds(573, 39, 55, 20);
			getRightJText_PreAuthNo().setBounds(610, 39, 40, 20);

			getRightJLabel_Complex().setPosition(455, 83);
			getRightJLabel_Complex().setText("Tent Case");
			getRightJCheckBox_Complex().setPosition(510, 83);
			getCoveredItemPanel().setBounds(530, 84, 270, 19);
			getRightJLabel_CoverredItem().setBounds(5, 0, 80, 20);
			getRightJLabel_CoverredItemDoctor().setText("Dr.");
			getRightJLabel_CoverredItemDoctor().setBounds(65, 0, 40, 20);
			getRightJCheckBox_CoverredItemDoctor().setPosition(80, 0);
			getRightJLabel_CoverredItemHospital().setText("Hosp.");
			getRightJLabel_CoverredItemHospital().setBounds(110, 0, 50, 20);
			getRightJCheckBox_CoverredItemHospital().setPosition(138, 0);
			getRightJLabel_CoverredItemSpecial().setText("Spec.");
			getRightJLabel_CoverredItemSpecial().setBounds(165, 0, 40, 20);
			getRightJCheckBox_CoverredItemSpecial().setPosition(193, 0);
			getRightJLabel_CoverredItemOther().setBounds(220, 0, 40, 20);
			getRightJCheckBox_CoverredItemOther().setPosition(249, 0);

			getRightButton_Remarks().setPosition(5, 105);
			getRightJText_Remarks().setBounds(90, 105, 355, 20);

			getTotalPanel().setBounds(5, 157, 665, 60);
			getRightJLabel_RoomPhone().setBounds(680, 156, 80, 20);
			getRightJText_RoomPhone().setBounds(750, 156, 60, 20);
			getRightJText_OT().setBounds(678, 179, 30, 22);
			getRightJLabel_OTCount().setBounds(710, 179, 40, 20);
			getRightJText_OTCount().setBounds(750, 179, 60, 20);
			getShowHistoryDesc().setBounds(720, 204, 100, 20);
			getShowHistory().setBounds(690, 204, 20, 20);

			getDiscountPanel().setBounds(5, 211, 210, 43);
			getRightJLabel_HospitalDiscount().setText("Hosp.");
			getRightJLabel_HospitalDiscount().setBounds(5, -5, 35, 20);
			getRightJText_HospitalDiscount().setBounds(40, -5, 30, 20);

			getRightJLabel_DoctorDiscount().setText("Dr.");
			getRightJLabel_DoctorDiscount().setBounds(74, -5, 20, 20);
			getRightJText_DoctorDiscount().setBounds(95, -5, 30, 20);

			getRightJLabel_SpecialDiscount().setText("Spec.");
			getRightJLabel_SpecialDiscount().setBounds(130, -5, 30, 20);
			getRightJText_SpecialDiscount().setBounds(162, -5, 35, 20);

			getRightJLabel_MAllocate().setBounds(590, 225, 60, 20);
			getRightJCheckBox_MAllocate().setBounds(640, 225, 20, 20);
			getOrderByDesc().setBounds(665, 225, 30, 20);
			getRightJLabel_AR().setBounds(520, 225, 35, 20);
			getRightJCheckBox_AR().setBounds(535, 225, 20, 20);
			getOrderBy().setBounds(695, 225, 120, 20);

			getRightJLabel_Misc().setText("Rmk");
			getRightJLabel_Misc().setVisible(true);
			getRightJCombo_Misc().setVisible(true);
			getRightJLabel_Misc().setBounds(659, -5, 25, 20);
			getRightJCombo_Misc().setBounds(685, -5, 55, 20);
			
			getRightJLabel_Nature().setVisible(true);
			getRightJText_Nature().setVisible(true);

			getINJLabel_PrtMedRecordRpt().setVisible(true);
			getINJCheckBox_PrtMedRecordRpt().setVisible(true);
			getRightJLabel_SourceNo().setVisible(true);
			getRightJText_SourceNo().setVisible(true);
			getRightJLabel_SendBillDate().setVisible(true);
			getRightJText_SendBillDate().setVisible(true);
			getRightJCombo_SendBillType().setVisible(true);
			getRightJLabel_SpRqt().setVisible(true);
			getRightJCombo_SpRqt().setVisible(true);
			getRightJLabel_Package().setVisible(true);
			getRightJCombo_Package().setVisible(true);
			getRightJLabel_NoSign().setVisible(true);
			getRightJCombo_NoSign().setVisible(true);
			getPJLabel_RevLog().setVisible(true);
			getPJCheckBox_Revlog().setVisible(true);
			getRightJLabel_LogCvrCls().setVisible(true);
			getRightJCombo_LogCvrCls().setVisible(true);
			getPJLabel_EstGiven().setVisible(true);
			getPJCheckBox_EstGiven().setVisible(true);
			getPJCheckBox_BEDesc().setVisible(true);
			getPJCheckBox_BE().setVisible(true);
			getRightJLabel_AR().setVisible(false);
			getRightJCheckBox_AR().setVisible(false);
			getRightJLabel_HospitalDiscountSuffix().setVisible(false);
			getRightJLabel_DoctorDiscountSuffix().setVisible(false);
			getRightJLabel_SpecialDiscountSuffix().setVisible(false);
			getRightButton_SendDisChrgSMS().setVisible(true);

			getRightJScrollPane_Detail().setBounds(5, 255, 810, 178);
			getBtnPanel().setBounds(3, 429, 810, 110);

			isUpdAllSlpNoSign = "Y";
			
			getRightButton_Reprint().setText("Reprint DEPOSIT");
		}

		lastSelectedItemKey = null;

		getListTable().setColumnColor(2, "red");
		getListTable().setColumnAmount(6);
		getListTable().setColumnAmount(8);
		getListTable().setColumnAmount(10);
		getListTable().setColumnAmount(18);

		// from Adjust and Update and others
		getShowHistory().setSelected(false);

//		removeParameter();

//		if ("srhPatStsView".equals(getParameter("Form"))) {
//			//LeftJText_SlipNo.setText(getParameter("slpNo"));
//			//searchAction();
//			acceptAction();
//		}

		sFromWhere = EMPTY_VALUE;
		isFromSrhPatStsView = false;
		arSignature = false;
		arInpSmySignature = false;

		if ("OT_LOG".equals(getParameter("From"))) {
			sFromWhere = getParameter("From_OT");
//			LoadFirstTime = false;
		} else if ("srhPatStsView".equals(getParameter("From"))) {
			isFromSrhPatStsView = true;
//			LoadFirstTime = true;
		} else {
//			LoadFirstTime = true;
		}
		getRightJLabel_OTCount().setVisible(true);
		getRightJText_OTCount().setVisible(true);

		QueryUtil.executeMasterFetch(
				getUserInfo(), "PATIENTRPTLANG", new String[] { slpNo, "" },
				TxnCallBack.getInstance().getSlpReportLangCallBack(this));

		QueryUtil.executeMasterBrowse(
				getUserInfo(), "SLIPALERT", new String[] { slpNo },
				TxnCallBack.getInstance().getSlpAlertCallBack(this));

		getRightJCombo_ARCompanyCode().preloadContent();
	}

	@Override
	public void rePostAction() {
		if ("true".equals(getParameter("SUCCESSSAVEDISCHARGE"))) {
			resetParameter("SUCCESSSAVEDISCHARGE");
//			getDlgTxHistory().showDialog(slpNo);
		}
		refreshAction();
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public Component getDefaultFocusComponent() {
		if (isModify()) {
			if (ConstantsTransaction.SLIP_STATUS_REMOVE.equals(slpsts) || ConstantsTransaction.SLIP_STATUS_CLOSE.equals(slpsts)) {
				return getRightJText_Remarks();
			} else {
				return getRightJText_PolicyNo();
			}
		} else {
			if (getListTable().getRowCount() == 0) {
				return getRightJText_SlipNo();
			} else {
				return getListTable();
			}
		}
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {
		// override function if necessary
		PanelUtil.setAllFieldsEditable(getRightPanel(), true);
		PanelUtil.setAllFieldsEditable(getSlipDetailPanel(), false);
		PanelUtil.setAllFieldsEditable(getTotalPanel(), false);
		PanelUtil.setAllFieldsEditable(getDiscountPanel(), false);
		getRightJText_SendBillDate().setEditable(false);
		getRightJCombo_SendBillType().setEditable(false);
		getRightJCheckBox_AR().setEditable(false);
		getRightJCheckBox_MAllocate().setEditable(false);
		getRightJCombo_SpRqt().setEditable(false);
		getRightJCombo_Package().setEditable(false);
		getPJCheckBox_Revlog().setEditable(false);
		getRightJCombo_LogCvrCls().setEditable(false);
		getPJCheckBox_EstGiven().setEditable(false);
		getPJCheckBox_BE().setEditable(false);
		getRightJCombo_NoSign().setEditable(false);
	}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {
		// enable/disable field
	}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
		// enable/disable field
		getRightJCheckBox_Staff().setEnabled(false);
		getShowHistory().setEditable(false);
		getShowHistory().setSelected(false);
		refreshTable();
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
		return null;
	}

	@Override
	protected void getFetchOutputValues(String[] outParam) {
		setBtnUpdateByTable();
	}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return new String[] {
				getRightJText_PatientNo().getText()
		};
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	protected void actionValidationReady(boolean ready) {
		if (ready) {
			canProceed("save");
		}
	}

	/***************************************************************************
	 * Helper Methods
	 **************************************************************************/

	private TransactionDetail getThis() {
		return this;
	}

	public void setLoadingScreen(boolean showLoading) {
		getMainFrame().setLoading(showLoading);
		PanelUtil.setAllFieldsEditable(getRightJScrollPane_Detail(), !showLoading);
		PanelUtil.setAllFieldsEditable(getSlipDetailPanel(), false);
	}

	private void getFetchDetail(boolean showLoading) {
		setLoadingScreen(showLoading);
		QueryUtil.executeMasterFetch(
				getUserInfo(), getTxCode(), new String[] { slpNo },
				TxnCallBack.getInstance().getFetchDetailCallBack(this));
	}

	public void getFetchDetailReady(String[] outParam) {
		int index = 0;

//		slpNo = outParam[index++];  //no need
		index++;
		getRightJText_SlipNo().setText(slpNo);
		regid = outParam[index++];	// regid
		slipType = outParam[index++];
		slpsts = outParam[index++];	// slpsts
		index++;	// dptcode
		getRightJText_TotalCredit().setText(outParam[index++]);
		getRightJText_TotalCharges().setText(outParam[index++]);
		getRightJText_TotalPayment().setText(outParam[index++]);
		getRightJText_Balance().setText(outParam[index++]);
		getRightJText_TotalDoctorCharges().setText(outParam[index++]);
		getRightJText_TotalSpecialCharges().setText(outParam[index++]);
		getRightJText_TotalHospitalCharges().setText(outParam[index++]);
		getRightJText_TotalRefund().setText(outParam[index++]);
		getRightJText_OTCount().setText(outParam[index++]);
		getRightJText_PatientNo().setText(outParam[index++]);
		getRightJText_PatientName().setText(outParam[index++] + SPACE_VALUE + outParam[index++]);//	index+=2;
		getRightJText_BedCode().setText(outParam[index++]);
		getRightJText_RoomPhone().setText(outParam[index++]);
		getRightJText_AdmissionDate().setText(outParam[index++]);
		getRightJText_Doctor().setText(outParam[index++]);
		getRightJText_DoctorName().setText(outParam[index++] + SPACE_VALUE + outParam[index++]);	//index+=2;
		memAcmCode = outParam[index++];
		getRightJText_AcmDesc().setText(outParam[index++]);
		getRightJText_DischargeDate().setText(outParam[index++]);
		spcName = outParam[index++];
		inpid = outParam[index++];
		memPcyID = outParam[index++];
		getRightJCombo_CategoryNo().setPcyID(memPcyID);	// pcyid
		getRightJText_CategoryName().setText(outParam[index++]);	// patrefno
		getRightJCombo_Misc().setText(outParam[index++]);	// slpmid
		getRightJCombo_Source().setText(outParam[index++]);	// slpsid
		getRightJText_PolicyNo().setText(outParam[index++]);	//Slpplyno
		getRightJText_VoucherNo().setText(outParam[index++]);	//slpvchno
		memArcCode = outParam[index++];
		getRightJCombo_ARCompanyCode().setText(memArcCode);
		getRightJText_ARCompanyDesc().setText(outParam[index++]);
		memActID = outParam[index++];	// actID
		getRightJText_ARCardType().setText(outParam[index++]);	//actCode
		getRightJCheckBox_Staff().setSelected(YES_VALUE.equals(outParam[index++]));
		getRightJText_Remarks().setText(outParam[index++]);
		memCoPayType = outParam[index++];
		getRightJCombo_CoPayRefType().setText(memCoPayType);
		memLimitAmt = outParam[index++];
		getRightJText_LimitAmount().setText(memLimitAmt);
		memCvrEndDate = outParam[index++];
		getRightJText_CvtEndDate().setText(memCvrEndDate);
		memCoPayAmt = outParam[index++];
		getRightJText_CoPayRefAmount().setText(memCoPayAmt);
		getRightJCheckBox_CoverredItemHospital().setSelected(YES_VALUE.equals(outParam[index++]));
		getRightJCheckBox_CoverredItemDoctor().setSelected(YES_VALUE.equals(outParam[index++]));
		getRightJCheckBox_CoverredItemSpecial().setSelected(YES_VALUE.equals(outParam[index++]));
		getRightJCheckBox_CoverredItemOther().setSelected(YES_VALUE.equals(outParam[index++]));
		memGrtAmt = outParam[index++];
		getRightJText_FGrtAmount().setText(memGrtAmt);
		memGrtDate = outParam[index++];
		getRightJText_FGrtDate().setText(memGrtDate);
		memPrintDate = outParam[index++];
		getRightJText_CoPayActualAmount().setText(outParam[index++]);
		index++;	// rmkmodusr
		index++;	// rmkmoddt
		getRightJCheckBox_AR().setSelected(YES_VALUE.equals(outParam[index++]));	// slpusear
		getRightJCheckBox_MAllocate().setSelected(YES_VALUE.equals(outParam[index++]));
		index++;	// slpremark
		memHDisc = outParam[index++];
		getRightJText_HospitalDiscount().setText(memHDisc);
		memDDisc = outParam[index++];
		getRightJText_DoctorDiscount().setText(memDDisc);
		memSDisc = outParam[index++];
		getRightJText_SpecialDiscount().setText(memSDisc);
		index++;	// SlpAddRmk
		index++;	// Addrmkmodusr
		index++;	// Addrmkmoddt
		getRightJCheckBox_Complex().setSelected(YES_VALUE.equals(outParam[index++]));
		patCName = outParam[index++];
		patSex = outParam[index++];
		getRightJText_SourceNo().setText(outParam[index++]);	// slpsno
		getRightJText_SendBillDate().setText(outParam[index++]);
		getRightJCombo_SendBillType().setText(outParam[index++]);
		smtRemark  = outParam[index++];
		getRightJCombo_SpRqt().setText(outParam[index++]);
		getPJCheckBox_Revlog().setSelected(YES_VALUE.equals(outParam[index++]));
		getRightJCombo_LogCvrCls().setText(outParam[index++]);
		getRightJCombo_Package().setText(outParam[index++]);
		getPJCheckBox_EstGiven().setText(outParam[index++]);
		memNoSign = outParam[index++];
		getRightJCombo_NoSign().setText(memNoSign);
		memCvrItem = EMPTY_VALUE;

		try {
			if (Integer.parseInt(outParam[index++]) > 0) {
				arSignature = true;
			} else {
				arSignature = false;
			}
		} catch (Exception e) {
			arSignature = false;
		}

		if (!ZERO_VALUE.equals(outParam[index++])) {
			getRightButton_Log().el().addStyleName("button-alert");
			isAlertLOG = true;
		} else {
			getRightButton_Log().removeStyleName("button-alert");
			isAlertLOG = false;
		}

		if (!ZERO_VALUE.equals(outParam[index++])) {
			getRightButton_DischargeCheck().el().addStyleName("button-alert");
		} else {
			getRightButton_DischargeCheck().removeStyleName("button-alert");
		}

		mothLang = outParam[index++];

		if (ZERO_VALUE.equals(outParam[index++])) {
			getRightJText_OTCount().removeInputStyleName("read-only-OT");
		} else {
			getRightJText_OTCount().addInputStyleName("read-only-OT");
		}

		getINJCheckBox_PrtMedRecordRpt().setSelected(MINUS_ONE_VALUE.equals(outParam[index++]));

/*		if (!ZERO_VALUE.equals(outParam[index++])) {
			getRightButton_Deposit().el().addStyleName("button-alert");
		} else {
			getRightButton_Deposit().removeStyleName("button-alert");
		}*/

		if (!ZERO_VALUE.equals(outParam[index++])) {
			getRightButton_LabReport().el().addStyleName("button-alert");
		} else {
			getRightButton_LabReport().removeStyleName("button-alert");
		}

		memFESTID = outParam[index++];
		if (memFESTID.length() > 0 && memFESTID != null ) {
			getRightButton_BudgetEst().el().addStyleName("button-alert-green");
		} else {
			getRightButton_BudgetEst().removeStyleName("button-alert-green");
		}

		getPJCheckBox_BE().setSelected(MINUS_ONE_VALUE.equals(outParam[index++]));
		
		

		try {
			if (Integer.parseInt(outParam[index++]) > 0) {
				arInpSmySignature = true;
			} else {
				arInpSmySignature = false;
			}
		} catch (Exception e) {
			arInpSmySignature = false;
		}

		getRightJText_PreAuthNo().setText(outParam[index++]);
		
		regPkgCode = outParam[88];
			
		if (YES_VALUE.equals(outParam[89])) {
			getRightButton_MobileBill().el().addStyleName("button-alert-yellow");
		} else {
			getRightButton_MobileBill().removeStyleName("button-alert-yellow");
		}
		memTelemedURL = outParam[90];
		
		getRightJText_Nature().setText(outParam[91]);

		if (getRightJCheckBox_CoverredItemDoctor().isSelected()) { memCvrItem = "D"; }
		if (getRightJCheckBox_CoverredItemHospital().isSelected()) { memCvrItem += "H"; }
		if (getRightJCheckBox_CoverredItemSpecial().isSelected()) { memCvrItem += "S"; }
		if (getRightJCheckBox_CoverredItemOther().isSelected()) { memCvrItem += "O"; }
		
		if (!getRightJCombo_ARCompanyCode().isEmpty()) {
			getRightJCombo_ARCompanyCode().addInputStyleName("read-only-OT");			
		} else {
			getRightJCombo_ARCompanyCode().removeInputStyleName("read-only-OT");			
		}
		
		

		// set subtable
		refreshTable();

		getRightPanel().setVisible(true);
		getLeftPanel().setVisible(false);

		confirmCancelButtonClicked();

		layout();
//		PanelUtil.setFirstComponentFocus(getListTable());

		doLCDDisplay(getSysParameter("DisplayCap"), getRightJText_Balance().getText());

		setCheckDate();

		// show patient alert
		if (!showAlert && YES_VALUE.equals(getMainFrame().getSysParameter("TXALERT"))&&
				getParameter("isNewSlip")!= null && "Y".equals(getParameter("isNewSlip"))) {
			showAlert = true;
			getDlgOSBillAlert().showDialog(getRightJText_PatientNo().getText());
		}
		resetParameter("isNewSlip");
		refreshButton();
	}

	public void refreshButton() {
		// setup button
		enableButton();
		setBtnUpdateStatus();
		setBtnUpdateByTable();
	}

	private void actionValidation() {
		/* === ~16~ Validation before call right panel action */
		if (!getRightJCombo_ARCompanyCode().isEmpty()) {
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] {"arcode", "count(1)", "ArcCode ='" + getRightJCombo_ARCompanyCode().getText() + "'"},
					TxnCallBack.getInstance().getActionValidationCallBack(this));
		} else {
			if (Factory.getInstance().getSysParameter("ArBlockEvt").length() == 0) {
				clearArEntry();
			}
			actionValidationPost();
		}
	}

	private void actionValidationPost() {
		if (!getRightJCombo_Misc().isEmpty() &&
				!getRightJCombo_Misc().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid Misc.", getRightJCombo_Misc());
			actionValidationReady(false);
			return;
		}

		if (!getRightJCombo_Source().isEmpty() &&
				!getRightJCombo_Source().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid Input Source.", getRightJCombo_Source());
			actionValidationReady(false);
			return;
		}

		if (!getRightJText_LimitAmount().isEmpty() && !TextUtil.isFloat(getRightJText_LimitAmount().getText().trim())) {
			Factory.getInstance().addErrorMessage("Please enter a numeric Limit Amount.", "PBA-[Transaction Detail]", getRightJText_LimitAmount());
			actionValidationReady(false);
			return;
		}

		if (!getRightJText_CoPayRefAmount().isEmpty()) {
			if (!TextUtil.isFloat(getRightJText_CoPayRefAmount().getText().trim())) {
				Factory.getInstance().addErrorMessage("Please enter a numeric Co-Payment Amount. ", "PBA-[Transaction Detail]", getRightJText_CoPayRefAmount());
				actionValidationReady(false);
				return;
			}
		} else {
			getRightJText_CoPayRefAmount().setText(ZERO_VALUE);
		}

		if (!getRightJText_FGrtAmount().isEmpty() && !TextUtil.isFloat(getRightJText_FGrtAmount().getText().trim())) {
			Factory.getInstance().addErrorMessage("Please enter a numeric Further Guarantee Amount. ", "PBA-[Transaction Detail]", getRightJText_FGrtAmount());
			actionValidationReady(false);
			return;
		}

		if (!getRightJText_CoPayActualAmount().isEmpty()) {
			if (!TextUtil.isFloat(getRightJText_CoPayActualAmount().getText().trim())) {
				Factory.getInstance().addErrorMessage("Please enter a numeric Co-Payment(Act.) Amount.", "PBA-[Transaction Detail]", getRightJText_CoPayActualAmount());
				actionValidationReady(false);
				return;
			}
		} else {
			getRightJText_CoPayActualAmount().setText(ZERO_VALUE);
		}

		if (!getRightJText_CvtEndDate().isEmpty() && !getRightJText_CvtEndDate().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid Date Format.", "PBA-[Transaction Detail]", getRightJText_CvtEndDate());
			actionValidationReady(false);
			return;
		}

		if (!getRightJText_FGrtDate().isEmpty() && !getRightJText_FGrtDate().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid Date Format.", "PBA-[Transaction Detail]", getRightJText_FGrtDate());
			actionValidationReady(false);
			return;
		}

		if (!getRightJText_LimitAmount().isEmpty()) {
			if (Double.parseDouble(getRightJText_LimitAmount().getText().trim()) < 0) {
				Factory.getInstance().addErrorMessage("Guarantee Amount Limit must >=0.", "PBA-[Transaction Detail]", getRightJText_LimitAmount());
				actionValidationReady(false);
				return;
			}
		} else {
			getRightJText_LimitAmount().setText(ZERO_VALUE);
		}

		if (!getRightJText_FGrtAmount().isEmpty()) {
			if (Double.parseDouble(getRightJText_FGrtAmount().getText().trim()) < 0) {
				Factory.getInstance().addErrorMessage("Further Guarantee Amount must >=0.", "PBA-[Transaction Detail]", getRightJText_FGrtAmount());
				actionValidationReady(false);
				return;
			}
		} else {
			getRightJText_FGrtAmount().setText(ZERO_VALUE);
		}

		if (!getRightJCombo_CoPayRefType().isEmpty()) {
			if ("%".equals(getRightJCombo_CoPayRefType().getText().trim())) {
				if (getRightJText_CoPayRefAmount().getText().trim().length() == 0) {
					Factory.getInstance().addErrorMessage("Co-Payment Amount must >=0.", "PBA-[Transaction Detail]", getRightJText_CoPayRefAmount());
					actionValidationReady(false);
					return;
				} else {
					Double db = Double.parseDouble(getRightJText_CoPayRefAmount().getText().trim());
					if (db > 100||db < 0) {
						Factory.getInstance().addErrorMessage("Co-Payment Amount must >=0 and <=100.", "PBA-[Transaction Detail]", getRightJText_CoPayRefAmount());
						actionValidationReady(false);
						return;
					}
				}
			} else {
				if (getRightJText_CoPayRefAmount().getText().trim().length() == 0) {
					Factory.getInstance().addErrorMessage("Co-Payment Amount must >=0.", "PBA-[Transaction Detail]", getRightJText_CoPayRefAmount());
					actionValidationReady(false);
					return;
				} else if (Double.parseDouble(getRightJText_CoPayRefAmount().getText().trim()) < 0) {
					Factory.getInstance().addErrorMessage("Co-Payment Amount must >=0.", "PBA-[Transaction Detail]", getRightJText_CoPayRefAmount());
					actionValidationReady(false);
					return;
				}
			}
		} else {
			getRightJText_CoPayRefAmount().setText(ZERO_VALUE);
		}

		if (Double.parseDouble(getRightJText_FGrtAmount().getText().trim()) > Double.parseDouble(getRightJText_LimitAmount().getText().trim())) {
			Factory.getInstance().addErrorMessage("Further guarantee amount should less than or equal to Limited amount.", "PBA-[Transaction Detail]", getRightJText_LimitAmount());
			actionValidationReady(false);
			return;
		}

		if (!getRightJText_SendBillDate().isEmpty() && !getRightJText_SendBillDate().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid Date Format.", "PBA-[Transaction Detail]", getRightJText_SendBillDate());
			actionValidationReady(false);
			return;
		}

		if (!getRightJCombo_SendBillType().isEmpty() && !getRightJCombo_SendBillType().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid Send Bill Type.", "PBA-[Transaction Detail]", getRightJCombo_SendBillType());
			actionValidationReady(false);
			return;
		}

		if (HKAH_VALUE.equals(getUserInfo().getSiteCode()) && getRightJText_ARCompanyDesc().isEmpty() && !getRightJCombo_ARCompanyCode().isEmpty()) {
			Factory.getInstance().addErrorMessage("Plese select AR card!", "PBA-[Transaction Detail]", getRightJCombo_ARCompanyCode());
			actionValidationReady(false);
			return;
		}

		actionValidationReady(true);
	}

	private void setModifySlipTxParam() {
		setParameter("SlpNo", slpNo);

		String[] para = getListTable().getSelectedRowContent();
		if (para != null && para.length > 0) {
			setParameter("StnID", para[STNID2_COL]);
			setParameter("StnSeq", para[STNSEQ_COL]);
			setParameter("StnSts", para[STNSTS_COL]);
			setParameter("ItmCode", para[ITMCODE_COL]);
			setParameter("PkgCode", para[PKGCODE_COL]);
			setParameter("StnDisc", para[STNDISC_COL]);
			setParameter("StnOAmt", para[STNOAMT_COL]);
			setParameter("StnNAmt", para[STNNAMT_COL]);
			setParameter("AcmCode", para[ACMCODE_COL]);
			setParameter("GlcCode", para[GLCCODE_COL]);
			setParameter("StnRlvl", para[STNRLVL_COL]);
			setParameter("ItmType", para[ITMTYPE_COL]);

			setParameter("StnTDate", para[STNTDATE_COL]);
			setParameter("StnDesc", para[STNDESC_COL]);
			setParameter("StnBAmt", para[STNBAMT_COL]);
		}
	}

	private void refreshTable() {
		// it is very strange, when run here,the slpNo changed to "I"
		getMainFrame().setLoading(true);
		QueryUtil.executeMasterBrowse(
				getUserInfo(), ConstantsTx.TRANSACTION_SUBDETAIL_TXCODE,
				new String[] {
					slpNo,
					getShowHistory().isSelected()?ConstantsVariable.YES_VALUE:ConstantsVariable.EMPTY_VALUE,
					getOrderBy().getText(),
					getUserInfo().getUserID()
				},
				Factory.getInstance().getListTableCallBack(this));
	}

	@Override
	protected void canProceedReady(String actionType, boolean canProceed) {
		if (!canProceed) {
			Factory.getInstance().addErrorMessage(ConstantsMessage.ERROR_DISABLE);
		} else if (actionType.equals("changeAcm") && getListTable().getSelectedRow() >= 0) {
			getDlgChangeACM().showDialog(slpNo, getListTable().getSelectedRowContent()[ACMCODE_COL]);
		} else if (actionType.equals("moveItem2Pkg") && getListTable().getSelectedRow() >= 0) {
			MessageBoxBase.confirm(MSG_PBA_SYSTEM, MSG_MOVE_ITEM_TO_PKGTX, new Listener<MessageBoxEvent>() {
				@Override
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						getDlgPkgCodeMvItm2Ref().showDialog("TxnDetails", slpNo, isRegisteredExam());
					} else {
						defaultFocus();
					}
				}
			});
		} else if (actionType.equals("changeAmount") && getListTable().getSelectedRow() >= 0) {
			select = getListTable().getSelectedRowContent();
			if ("F".equals(select[STNCPSFLAG_COL]) || "T".equals(select[STNCPSFLAG_COL])) {//SLIPTX_CPS_STD_FIX(F):Standard Rate With CPS Fix Amount;SLIPTX_CPS_STA_FIX(T):Stat Rate With CPS Fix Amount
				Factory.getInstance().addErrorMessage("This is a fix amount contract; therefore, amount and % can not be changed.","PBA-[Transaction Detail]");
				return;
			}

			if ("P".equals(select[STNCPSFLAG_COL]) || "U".equals(select[STNCPSFLAG_COL])) {//SLIPTX_CPS_STD_PCT(P):Standard Rate With CPS Percentage Disc;SLIPTX_CPS_STA_PCT(U):Stat Rate With CPS Percentage Disc
				chgAmtFlg = true;
			} else {
				chgAmtFlg = false;
			}

			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] {"sliptx","sum(stnbamt)","(stnsts='N' or stnsts='A') and stntype='D' and dixref='"+select[28]+"' and slpno='"+slpNo+"'"},
					TxnCallBack.getInstance().getChangeAmountCallBack(this));
		} else if (actionType.equals("movePkg2Pkg") && getListTable().getSelectedRow() >= 0) {
			MessageBoxBase.confirm(MSG_PBA_SYSTEM, MSG_MOVE_PACKAGE_TO_PKGTX,new Listener<MessageBoxEvent>() {
				@Override
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						getDlgPkgCodeMvPkg2Ref().showDialog();
					} else {
						defaultFocus();
					}
				}
			});
		} else if (actionType.equals("cancelPkg") && getListTable().getSelectedRow() >= 0) {
			MessageBoxBase.confirm(MSG_PBA_SYSTEM, MSG_CANCEL_PACKAGE,new Listener<MessageBoxEvent>() {
				@Override
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						cancelPkg();
					}
				}
			});
		} else if (actionType.equals("save")) {
			if (!TextUtil.isFloat(getRightJText_HospitalDiscount().getText().trim())) {
				Factory.getInstance().addErrorMessage(MSG_NUMERIC_DISCOUNT, "PBA-[Transaction Detail]", getRightJText_HospitalDiscount());
				return;
			} else {
				if (Double.parseDouble(getRightJText_HospitalDiscount().getText().trim()) > 100) {
					Factory.getInstance().addErrorMessage(MSG_NUMERIC_DISCOUNTOFF, "PBA-[Transaction Detail]", getRightJText_HospitalDiscount());
					getRightJText_HospitalDiscount().resetText();
					return;
				}
			}

			if (!TextUtil.isFloat(getRightJText_DoctorDiscount().getText().trim())) {
				Factory.getInstance().addErrorMessage(MSG_NUMERIC_DISCOUNT, "PBA-[Transaction Detail]", getRightJText_DoctorDiscount());
				return;
			} else {
				if (Double.parseDouble(getRightJText_DoctorDiscount().getText().trim()) > 100) {
					Factory.getInstance().addErrorMessage(MSG_NUMERIC_DISCOUNTOFF, "PBA-[Transaction Detail]", getRightJText_DoctorDiscount());
					getRightJText_DoctorDiscount().resetText();
					return;
				}
			}

			if (!TextUtil.isFloat(getRightJText_SpecialDiscount().getText().trim())) {
				Factory.getInstance().addErrorMessage(MSG_NUMERIC_DISCOUNT, "PBA-[Transaction Detail]", getRightJText_SpecialDiscount());
				return;
			} else {
				if (Double.parseDouble(getRightJText_SpecialDiscount().getText().trim()) > 100) {
					Factory.getInstance().addErrorMessage(MSG_NUMERIC_DISCOUNTOFF, "PBA-[Transaction Detail]", getRightJText_SpecialDiscount());
					getRightJText_DoctorDiscount().resetText();
					return;
				}
			}

			if (!memArcCode.equals(getRightJCombo_ARCompanyCode().getText().trim()) ||
					(memArcCode == null && getRightJCombo_ARCompanyCode().getText().trim() != null)) {
				getDlgConPceChange().showDialog(slpNo, slipType, memAcmCode, newCpsId, EMPTY_VALUE, EMPTY_VALUE);
			} else {
				memPrintDate = EMPTY_VALUE;
				if (isNewGrt()) {
					if ((memArcCode != null && memArcCode.length() > 0) &&
							(getRightJCombo_ARCompanyCode().getText().trim() != null && getRightJCombo_ARCompanyCode().getText().trim().length() > 0)) {
						MessageBoxBase.confirm(MSG_PBA_SYSTEM, "Is a new further guarantee ? ", new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									memPrintDate = EMPTY_VALUE;
								}
								doPostTrasactions();
							}
						});
					} else {
						memPrintDate = EMPTY_VALUE;
						doPostTrasactions();
					}
				} else {
					doPostTrasactions();
				}
			}
		} else if (actionType.equals("CancelItem") && getListTable().getSelectedRow() >= 0) {
			final String[] rs = getListTable().getSelectedRowContent();
			doCancelItem(rs[STNID2_COL], rs[STNXREF_COL], rs[STNSEQ_COL], false, false, false, null, false);
		}
	}

	public void changeAmountCallBackSuccess(MessageQueue mQueue) {
		if (mQueue.success()) {
			getDlgChangeAmount().showDialog(
					slpNo,
					getListTable().getSelectedRowContent()[STNID2_COL],
					getListTable().getSelectedRowContent()[STNTDATE_COL],
					mQueue.getContentField()[0],
					select[8],
					select[3],
					select[5],
					chgAmtFlg
			);
		}
	}
/***********Useless code*************/
/*
	private void preProcessUpdateCPS() {
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] {"arcode", "cpsid", "arccode ='" + getRightJCombo_ARCompanyCode().getText() + "'"},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getDlgConPceChange().showDialog(slpNo, slipType, memAcmCode, mQueue.getContentField()[0],EMPTY_VALUE,EMPTY_VALUE);
					//preProcessUpdateCPSReady(getDlgConPceChange().getCapCol());
				} else {
					reCalculateCPS(slpNo, null);
				}
			}
		});
	}

	private void preProcessUpdateCPSReady(TableList cpslist) {
		reCalculateCPS(slpNo, cpslist);
	}

	@Override
	public void reCalculateCPSReady(boolean ready) {
		if (ready && !memPcyID.equals(getRightJCombo_CategoryNo().getText())) {
			SCMUpdate(slpNo, getRightJCombo_CategoryNo().getText());
		} else {
			SCMUpdateReady(true);
		}
	}

	@Override
	public void SCMUpdateReady(boolean ready) {
		if (ready) {
			if (isNewGrt()) {
				if (memArcCode != null && memArcCode.length() > 0 && getRightJCombo_ARCompanyCode().getText().trim().length() > 0) {
					MessageBoxBase.confirm(MSG_PBA_SYSTEM, "Is a new further guarantee ? ", new Listener<MessageBoxEvent>() {
						@Override
						public void handleEvent(MessageBoxEvent be) {
							if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
								memPrintDate = EMPTY_VALUE;
							}
							doPostTrasactions();
						}
					});
				} else {
					memPrintDate = EMPTY_VALUE;
					doPostTrasactions();
				}
			} else {
				doPostTrasactions();
			}
		}
	}

	@Override
	public void IsCashierClosedReady(boolean ready) {
		if (ready) {
			Factory.getInstance().addErrorMessage(MSG_CASHIER_CLOSED + SPACE_VALUE + MSG_CANCEL_ITEM_FAIL, "PBA-[Transaction Detail]");
		} else {
			final String[] rs = getListTable().getSelectedRowContent();
			doCashierVoidEntry(getUserInfo(), rs[STNXREF_COL], slpNo, rs[STNSEQ_COL]);
		}
	}
*/

	@Override
	public void doCashierVoidEntryReady(boolean ready) {
		if (ready) {
			// Only from: Cancel item - payment -> do REVERSEENTRY, UPDATESLIP
			// after CashierVoidEntryPost
			QueryUtil.executeMasterAction(getUserInfo(), "ITEMCANCELPOST",
					QueryUtil.ACTION_APPEND,
					new String[] {
						getUserInfo().getUserID(),
						getUserInfo().getCashierCode(),
						slpNo,
						memStnid // stnid
					},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(final MessageQueue mQueue) {
					if (mQueue.success()) {
						Factory.getInstance().addInformationMessage(MSG_CANCEL_ITEM_SUCCESS, "PBA-[Transaction Detail]");
						getFetchDetail(true);
					}
				}
			});
		} else {
			Factory.getInstance().addErrorMessage(MSG_CASHIER_CLOSE_NOENTRY + SPACE_VALUE + MSG_CANCEL_ITEM_FAIL, "PBA-[Transaction Detail]");
		}
	}

	private boolean isPBODischarged() {
		String dischargeDate = getRightJText_DischargeDate().getText();
		String currentDate = getMainFrame().getServerDateTime();

		return
			getUserInfo().isPBO()				// CurrentUser.IsPBOUser
			|| dischargeDate.length() == 0		// compare discharge date with current date
			|| DateTimeUtil.compareTo(dischargeDate, currentDate) >= 0;
	}

	private void setSlipTxParam() {
		setParameter("SlpNo", slpNo);
		setParameter("BedCode", getRightJText_BedCode().getText());
		setParameter("PatNo", getRightJText_PatientNo().getText());
		setParameter("PatName", getRightJText_PatientName().getText());
		setParameter("RegDate", getRightJText_AdmissionDate().getText());
		setParameter("DocCode", getRightJText_Doctor().getText());
		setParameter("DocName", getRightJText_DoctorName().getText());
		setParameter("AcmCode", memAcmCode);
		setParameter("AcmDesc", getRightJText_AcmDesc().getText());
		// get transaction date
		String[] tableValue = getListTable().getSelectedRowContent();
		if (tableValue != null) {
			setParameter("StnTDate", tableValue[STNTDATE_COL]);
		} else {
			resetParameter("StnTDate");
		}
	}

	private void clearArEntry() {
		memActID = ConstantsVariable.EMPTY_VALUE;
		getRightJText_ARCompanyDesc().resetText();
		getRightJText_ARCardType().resetText();

		getRightJText_LimitAmount().setText(ZERO_VALUE);
		getRightJCombo_CoPayRefType().resetText();
		getRightJText_CoPayRefAmount().setText(ZERO_VALUE);
		getRightJText_CvtEndDate().resetText();
		getRightJText_FGrtAmount().setText(ZERO_VALUE);
		getRightJText_FGrtDate().resetText();
		getRightJCheckBox_CoverredItemDoctor().setSelected(false);
		getRightJCheckBox_CoverredItemHospital().setSelected(false);
		getRightJCheckBox_CoverredItemSpecial().setSelected(false);
		getRightJCheckBox_CoverredItemOther().setSelected(false);
		allowArEntry(false);
	}

	private void allowArEntry(boolean allow) {
		//enable this field
		if (Factory.getInstance().getSysParameter("ArBlockEvt").length() == 0) {
			getRightJText_LimitAmount().setEditable(allow);
			getRightJText_CvtEndDate().setEditable(allow);
			getRightJCombo_CoPayRefType().setEditable(allow);
			getRightJText_CoPayRefAmount().setEditable(allow);
			getRightJText_FGrtAmount().setEditable(allow);
			getRightJText_FGrtDate().setEditable(allow);

			getRightJCheckBox_CoverredItemDoctor().setEnabled(allow);
			getRightJCheckBox_CoverredItemHospital().setEnabled(allow);
			getRightJCheckBox_CoverredItemSpecial().setEnabled(allow);
			getRightJCheckBox_CoverredItemOther().setEnabled(allow);
		}
	}

	private void showPayment() {
		setSlipTxParam();
		setParameter("Balance", getRightJText_Balance().getText());
		resetParameter("StnTDate");
		setParameter("ARCode", getRightJCombo_ARCompanyCode().getText());
		setParameter("ARDesc", getRightJText_ARCompanyDesc().getText());
		setParameter("ActID", memActID);
		setParameter("SlpType", slipType);
		//setParameter("RegDate", regDate);
		setParameter("RegDate", getRightJText_AdmissionDate().getText());

		showPanel(new PaymentCapture());
	}

	/***************************************************************************
	 * Button Methods
	 **************************************************************************/

	private void setBtnUpdateStatus() {
		boolean isAction = isReadOnly || (getActionType() != null && (isAppend() || isModify() || isDelete()));

		getRightButton_Remarks().setEnabled(!isReadOnly);
		getRightButton_Charge().setEnabled(false);
		getRightButton_Adjust().setEnabled(false);
		getRightButton_Update().setEnabled(false);
		getRightButton_UpDocCode().setEnabled(false);
		getRightButton_UpdateBed().setEnabled(false);
		getRightButton_Payment().setEnabled(false);
		getRightButton_CancelItem().setEnabled(false);
		getRightButton_CancelPkg().setEnabled(false);

		getRightButton_AddCItem().setEnabled(false);
		getRightButton_AddCItemPer().setEnabled(false);
		getRightButton_PkgTxn().setEnabled(false);
		getRightButton_Refund().setEnabled(false);
		getRightButton_CloseBill().setEnabled(false);
		getRightButton_DoctorAllow().setEnabled(!isAction && isPBODischarged() && !isDisableFunction("btnManualAllocate", "txnDetails"));
		getRightButton_CalRefItem().setEnabled(false);
		getRightButton_SpecCal().setEnabled(!isAction);

		getRightButton_PatDetail().setEnabled(false);
		getRightButton_PrintTotalReceipt().setEnabled(!isAction && (ConstantsTransaction.SLIP_STATUS_OPEN.equals(slpsts) 
				|| ConstantsTransaction.SLIP_STATUS_CLOSE.equals(slpsts)) && 
				(ConstantsTransaction.SLIP_TYPE_INPATIENT.equals(slipType) || ConstantsTransaction.SLIP_TYPE_DAYCASE.equals(slipType)|| (ConstantsTransaction.SLIP_TYPE_OUTPATIENT.equals(slipType) && "Y".equals(Factory.getInstance().getSysParameter("OPPTRECT")))) 
				&& !isDisableFunction("btnPTotReceipt", "txnDetails"));
		getRightButton_Statement().setEnabled(!isAction && (ConstantsTransaction.SLIP_STATUS_OPEN.equals(slpsts) || ConstantsTransaction.SLIP_STATUS_CLOSE.equals(slpsts)) && !isDisableFunction("btnStatement", "txnDetails"));
		getRightButton_Reprint().setEnabled(false);
		getRightButton_MovePkgtoPkgtx().setEnabled(false);
		getRightButton_MovetoPkgtx().setEnabled(false);
		getRightButton_ChangeRLvl().setEnabled(!isAction);

		getRightButton_ChangeAmount().setEnabled(false);
		getRightButton_ChangeAcm().setEnabled(false);
		getRightButton_Log().setEnabled(false);
		getRightButton_PrintCert().setEnabled(!isAction && !isModify() && !isDisableFunction("cmdPrintCert", "txnDetails"));
		getRightButton_CashierSignOn().setEnabled(false);
		getRightButton_BillSummary().setEnabled(!isAction);
		getRightButton_Supp().setEnabled(false);
		getRightButton_PrtSupp().setEnabled(false);
		getRightButton_LabReport().setEnabled(!isAction && !isModify() && !isDisableFunction("mnuReport"));

		getRightButton_DoctorAppointment().setEnabled(!isAction &&
				((ConstantsTransaction.SLIP_STATUS_OPEN.equals(slpsts) && !isDisableFunction("mnuAppointSlipOpen")) ||
				(ConstantsTransaction.SLIP_STATUS_CLOSE.equals(slpsts) && !isDisableFunction("mnuAppoint"))));
		getRightButton_PatientRegistration().setEnabled(!isAction && !getRightJText_PatientNo().isEmpty() && !isDisableFunction("mnuPatReg"));
		getRightButton_Consent().setEnabled(!isAction && !isDisableFunction("tabConsent", "regPatReg"));
		getRightButton_ReOpenSlip().setEnabled(!isAction && ConstantsTransaction.SLIP_STATUS_CLOSE.equals(slpsts) && !isDisableFunction("btnReopen", "srhSlip"));
		getRightButton_CancelSlip().setEnabled(false);
		getRightButton_OtherSlip().setEnabled(!isAction);
		getRightButton_DischargeCheck().setEnabled(!isAction && (!isDisableFunction("mnuDischargeCheck") || getUserInfo().isPBO()));
		getRightButton_ReminderLetter().setEnabled(!isAction);
		getRightButton_Deposit().setEnabled(!isAction && !isDisableFunction("mnuDeposit"));

		getRightButton_MovetoPkgtx2().setEnabled(false);
		getRightButton_BudgetEst().setEnabled(!isAction);
		getRightButton_SendDisChrgSMS().setEnabled(!isAction && ConstantsTransaction.SLIP_TYPE_INPATIENT.equals(slipType) && !isDisableFunction("mnuRptCvLtr", "regPatReg"));
		getRightButton_Insurance().setEnabled(!isAction);

		getRightJCheckBox_MAllocate().setEnabled(!getRightJCheckBox_MAllocate().isSelected());

		if (isAction) {
			return;
		}

		boolean cond1 = false;
		boolean cond2 = false;
		boolean cond3 = false;

		if (ConstantsTransaction.SLIP_TYPE_INPATIENT.equals(slipType)) {
			cond1 = !getRightJText_DischargeDate().isEmpty();
		} else if (!getRightJText_AdmissionDate().isEmpty()) {
			cond2 = (ConstantsTransaction.SLIP_TYPE_OUTPATIENT.equals(slipType) || ConstantsTransaction.SLIP_TYPE_DAYCASE.equals(slipType)) &&
					(DateTimeUtil.dateTimeDiff(getMainFrame().getServerDateTime(), getRightJText_AdmissionDate().getText())/(1000*60*60)) > 24;
		} else {
			cond3 = (DateTimeUtil.dateTimeDiff(getMainFrame().getServerDateTime(), checkDate) / (1000*60*60)) > 24 ||
				(DateTimeUtil.dateTimeDiff(checkDate, getMainFrame().getServerDateTime()) / (1000*60*60)) > 24;
		}

		if (((cond1 || cond2 || cond3) && !getUserInfo().isPBO()) || ConstantsTransaction.SLIP_STATUS_REMOVE.equals(slpsts) || ConstantsTransaction.SLIP_STATUS_CLOSE.equals(slpsts)) {
			return;
		}

		int balance = 0;
		try {
			balance = Integer.valueOf(getRightJText_Balance().getText().trim()).intValue();
		} catch(Exception e) {}

		getRightButton_Charge().setEnabled(!isDisableFunction("btnCharge", "txnDetails"));
		getRightButton_UpDocCode().setEnabled(!isDisableFunction("btnUpDocCode", "txnDetails"));
		getRightButton_UpdateBed().setEnabled(inpid != null && inpid.length() > 0 && !isDisableFunction("btnUpdateBed", "txnDetails"));
		getRightButton_Payment().setEnabled(getUserInfo().isCashier() && !isDisableFunction("btnPayment", "txnDetails"));

		getRightButton_AddCItem().setEnabled(!isDisableFunction("btnAddCItem", "txnDetails"));
		getRightButton_AddCItemPer().setEnabled(!isDisableFunction("btnAddCItemPer", "txnDetails"));
		getRightButton_PkgTxn().setEnabled(!isDisableFunction("btnPkgTxn", "txnDetails"));
		getRightButton_Refund().setEnabled(getUserInfo().isCashier() && balance < 0 && !isDisableFunction("btnRefund", "txnDetails"));
		getRightButton_CloseBill().setEnabled(balance == 0 && ConstantsTransaction.SLIP_STATUS_OPEN.equals(slpsts) && (getUserInfo().isPBO() || !isDisableFunction("btnBill", "txnDetails")));

		getRightButton_PatDetail().setEnabled(ConstantsTransaction.SLIP_STATUS_OPEN.equals(slpsts) && ConstantsTransaction.SLIP_TYPE_INPATIENT.equals(slipType) && getUserInfo().isPBO() && !isDisableFunction("btnPatDetail", "txnDetails"));

		getRightButton_ChangeAcm().setEnabled(ConstantsTransaction.SLIP_STATUS_OPEN.equals(slpsts) && ConstantsTransaction.SLIP_TYPE_INPATIENT.equals(slipType));
		getRightButton_Log().setEnabled(ConstantsTransaction.SLIP_STATUS_OPEN.equals(slpsts) && !isDisableFunction("cmdLog", "txnDetails"));
		getRightButton_CashierSignOn().setEnabled(!getUserInfo().isCashier() && !isDisableFunction("cmdSignon", "txnDetails"));

		getRightButton_CancelSlip().setEnabled(ConstantsTransaction.SLIP_STATUS_OPEN.equals(slpsts) && balance == 0 && ZERO_VALUE.equals(getRightJText_OTCount().getText()) && !isDisableFunction("btnCancel", "srhSlip"));
		getRightButton_sendSMSTelemed().setEnabled(memTelemedURL != null && !memTelemedURL.isEmpty());
	}

	private void setBtnUpdateByTable() {
		getRightButton_Adjust().setEnabled(false);
		getRightButton_Update().setEnabled(false);
		getRightButton_CancelItem().setEnabled(false);
		getRightButton_CancelPkg().setEnabled(false);
		getRightButton_Reprint().setEnabled(false);
		getRightButton_MovetoPkgtx().setEnabled(false);
		getRightButton_MovetoPkgtx2().setEnabled(false);
		getRightButton_MovePkgtoPkgtx().setEnabled(false);
		getRightButton_ChangeAmount().setEnabled(false);
		getRightButton_Supp().setEnabled(false);

		if (getListTable().getSelectedRow() < 0 || isReadOnly || (getActionType() != null && (isAppend() || isModify() || isDelete()))) {
			return;
		}

		String[] para = getListTable().getSelectedRowContent();
		String pkgCode = para[PKGCODE_COL];
		String itmType = para[ITMTYPE_COL];
		String stnSts = para[STNSTS_COL];
		String stnCDate = para[STNCDATE_COL];
//		String stnid = para[STNID2_COL];
		String stnAdoc = para[STNADOC_COL];
//		String stnXRef = para[STNXREF_COL];
		String stnType = para[STNTYPE_COL];
		String stnAscm = para[STNASCM_COL];
		String bIsNull = para[BISNULL_COL];
		String isEPSPayment = para[ISEPSPAYMENT_COL];
		String isChequeTransactionWithBuffer = para[ISCHEQUETRANSACTION_COL];
		String xrStnID = para[XRSTNID_COL];
		String lStnId = para[DIXREF_COL]; //DiXRef;
		String stnid = para[STNID2_COL];

		if (ConstantsTransaction.SLIP_STATUS_OPEN.equals(slpsts) && isPBODischarged()) {
			if (ConstantsTransaction.SLIPTX_STATUS_NORMAL.equals(stnSts) || ConstantsTransaction.SLIPTX_STATUS_ADJUST.equals(stnSts)) {
				getRightButton_Adjust().setEnabled(!isDisableFunction("btnAdjust", "txnDetails") && ConstantsTransaction.SLIPTX_STATUS_NORMAL.equals(stnSts) && (ConstantsTransaction.SLIPTX_TYPE_DEBIT.equals(stnType) || ConstantsTransaction.SLIPTX_TYPE_CREDIT.equals(stnType)));
				if (stnAdoc == null || stnAdoc.length() == 0) {
					if (ConstantsTransaction.SLIPTX_TYPE_DEBIT.equals(stnType)
							|| ConstantsTransaction.SLIPTX_TYPE_CREDIT.equals(stnType)
							|| ConstantsTransaction.SLIPTX_TYPE_REFUND.equals(stnType)
							|| ConstantsTransaction.SLIPTX_TYPE_DEPOSIT_O.equals(stnType)
							|| ConstantsTransaction.SLIPTX_TYPE_PAYMENT_C.equals(stnType)
							|| ConstantsTransaction.SLIPTX_TYPE_PAYMENT_A.equals(stnType)) {
						getRightButton_Update().setEnabled(!isDisableFunction("btnUpdate", "txnDetails") && ZERO_VALUE.equals(bIsNull));
					} else {
						getRightButton_Update().setEnabled(!isDisableFunction("btnUpdate", "txnDetails") && ZERO_VALUE.equals(bIsNull));
					}
				} else {
					getRightButton_Update().setEnabled(false);
				}

				if (!isDisableFunction("btnCancelItem", "txnDetails")) {
					if (ConstantsTransaction.SLIPTX_TYPE_PAYMENT_C.equals(stnType)) {
						if ((stnCDate == null || stnCDate.length() == 0) && (stnAdoc == null || stnAdoc.length() == 0)) {
							getRightButton_CancelItem().setEnabled(!ONE_VALUE.equals(isEPSPayment));
						} else {
							getRightButton_CancelItem().setEnabled(YES_VALUE.equals(isChequeTransactionWithBuffer));
						}
					} else if (ConstantsTransaction.SLIPTX_TYPE_PAYMENT_A.equals(stnType)) {
						getRightButton_CancelItem().setEnabled(stnAdoc == null || stnAdoc.length() == 0);
					} else if ("D".equals(itmType)) {
						getRightButton_CancelItem().setEnabled((stnAdoc == null || stnAdoc.length() == 0) && (stnAscm == null || stnAscm.length() == 0));
					} else {
						getRightButton_CancelItem().setEnabled((stnAscm == null || stnAscm.length() == 0) && !ConstantsTransaction.SLIPTX_TYPE_DEPOSIT_X.equals(stnType));
					}

					if (xrStnID != null && xrStnID.length() > 0) {
						getRightButton_CancelItem().setEnabled(false);
					}
				}

				if (pkgCode != null && pkgCode.trim().length() > 0) {
					QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] { "sliptx", "stnid", "slpno = '" + slpNo + "' and pkgcode = '" + pkgCode + "' and itmtype = 'D' and stnadoc is not null"},
							TxnCallBack.getInstance().getCheckPkgCodeStnidCallBack(this));
					// added by ck on 20121210. enabled "cancel pkg" button.
					getRightButton_CancelPkg().setEnabled(!isDisableFunction("btnCancelPkg", "txnDetails") && ConstantsTransaction.SLIPTX_STATUS_NORMAL.equals(stnSts));

					getRightButton_MovePkgtoPkgtx().setEnabled(!isDisableFunction("btnMovePkgtoPkgtx", "txnDetails") && ConstantsTransaction.SLIPTX_STATUS_NORMAL.equals(stnSts));
//					mQueue = callBack.getMessageQueue();
//					String tmpPaid = null;
//					if (mQueue.success()) {
//						tmpPaid = mQueue.getContentField()[0];
//					}
//					getRightButton_CancelPkg().setEnabled(tmpPaid == null || tmpPaid.length() == 0);
				} else {
					getRightButton_CancelPkg().setEnabled(false);
					getRightButton_MovePkgtoPkgtx().setEnabled(false);
				}
				getRightButton_MovetoPkgtx().setEnabled(!isDisableFunction("btnMovetoPkgtx", "txnDetails") && ConstantsTransaction.SLIPTX_STATUS_NORMAL.equals(stnSts) && ConstantsTransaction.SLIPTX_TYPE_DEBIT.equals(stnType));
				getRightButton_MovetoPkgtx2().setEnabled(!isDisableFunction("btnMovetoPkgtx", "txnDetails") && ConstantsTransaction.SLIPTX_STATUS_NORMAL.equals(stnSts) && ConstantsTransaction.SLIPTX_TYPE_DEBIT.equals(stnType));
				getRightButton_Reprint().setEnabled(!isDisableFunction("btnReprint", "txnDetails") && ConstantsTransaction.SLIPTX_TYPE_PAYMENT_C.equals(stnType));
			}
		}

		if (ConstantsTransaction.SLIP_STATUS_OPEN.equals(slpsts)
				&& ConstantsTransaction.SLIPTX_STATUS_NORMAL.equals(stnSts)
				&& ConstantsTransaction.SLIPTX_TYPE_DEBIT.equals(stnType)
				&& !ConstantsTransaction.TYPE_DOCTOR.equals(itmType)) {
			getRightButton_ChangeAmount().setEnabled(true);
		} else {
			getRightButton_ChangeAmount().setEnabled(false);
		}

		getRightButton_Supp().setEnabled(!isDisableFunction("cmdSupp", "txnDetails") && ConstantsTransaction.SLIPTX_STATUS_NORMAL.equals(stnSts) || ConstantsTransaction.SLIPTX_STATUS_ADJUST.equals(stnSts));
		setCmdPrtSuppStatus(stnid);
	}

	public void checkPkgCodeStnid(MessageQueue mQueue) {
		if (mQueue.success()) {
			if (mQueue.getContentField()[0].trim().length() > 0) {
				getRightButton_CancelPkg().setEnabled(false);
			}
		}
	}

	/***************************************************************************
	 * Change Accommodation Code Dialog
	 **************************************************************************/

	private boolean isNewGrt() {
		if (!memArcCode.equals(getRightJCombo_ARCompanyCode().getText().trim())) return true;
		if (!memLimitAmt.equals(getRightJText_LimitAmount().getText().trim())) return true;
		if (!memCoPayType.equals(getRightJCombo_CoPayRefType().getText().trim())) return true;
		if (!memCoPayAmt.equals(getRightJText_CoPayRefAmount().getText().trim())) return true;
		if (!memCvrEndDate.equals(getRightJText_CvtEndDate().getText().trim())) return true;
		if (!memGrtAmt.equals(getRightJText_FGrtAmount().getText().trim())) return true;
		if (!memGrtDate.equals(getRightJText_FGrtDate().getText().trim())) return true;

		String cvrItems = EMPTY_VALUE;
		if (getRightJCheckBox_CoverredItemDoctor().isSelected()) { cvrItems = "D"; }
		if (getRightJCheckBox_CoverredItemHospital().isSelected()) { cvrItems += "H"; }
		if (getRightJCheckBox_CoverredItemSpecial().isSelected()) { cvrItems += "S"; }
		if (getRightJCheckBox_CoverredItemOther().isSelected()) { cvrItems += "O"; }

		return !memCvrItem.equals(cvrItems);
	}

	private void doPostTrasactionsReady(boolean ready) {
		if (ready) {
			setActionType(null);
			getFetchDetail(true);
		}
	}

	private void doPostTrasactions() {
		// doSlip update,include UpdateSlipDiscount,UpdateSlip
		QueryUtil.executeMasterAction(getUserInfo(), ConstantsTx.TRANSACTION_POST_TXCODE, QueryUtil.ACTION_MODIFY,
				new String[] {
					slpNo, //v_slpno
					getRightJCombo_ARCompanyCode().getText(), //v_arcode
					memActID, //v_actid
					getRightJText_PolicyNo().getText().trim(), //v_slpplyno
					getRightJText_VoucherNo().getText().trim(), //v_slpvchno
					getRightJText_PreAuthNo().getText().trim(), //v_slpauthno
					getRightJCombo_CategoryNo().getPcyID(), //v_pcyid
					getRightJText_CategoryName().getText().trim(), //v_patrefno
					getRightJCombo_Misc().getText(), // v_misc
					getRightJCombo_Source().getText(), // v_source
					getRightJText_LimitAmount().getText().trim(), //v_arlmamt
					getRightJCombo_CoPayRefType().getText(), //v_copaytyp
					getRightJText_CoPayRefAmount().getText().trim(), //v_copayamt
					getRightJText_CoPayActualAmount().getText().trim(), //v_copayamtact
					getRightJText_CvtEndDate().getText().trim(), //v_cvredate
					getRightJText_FGrtAmount().getText().trim(), //v_furgrtamt
					getRightJText_FGrtDate().getText().trim(), //v_furgrtdate
					getRightJText_Remarks().getText().trim(), //v_slpremark
					getRightJCheckBox_CoverredItemDoctor().isSelected()?MINUS_ONE_VALUE:ZERO_VALUE, //v_itmtyped
					getRightJCheckBox_CoverredItemHospital().isSelected()?MINUS_ONE_VALUE:ZERO_VALUE, //v_itmtypeh
					getRightJCheckBox_CoverredItemSpecial().isSelected()?MINUS_ONE_VALUE:ZERO_VALUE, //v_itmtypes
					getRightJCheckBox_CoverredItemOther().isSelected()?MINUS_ONE_VALUE:ZERO_VALUE, //v_itmtypeo
					getRightJText_DoctorDiscount().getText().trim(), //v_slpddisc
					getRightJText_HospitalDiscount().getText().trim(), //v_slphdisc
					getRightJText_SpecialDiscount().getText().trim(), //v_slpsdisc
					getUserInfo().getUserID(), //v_rmkmodusr
					getMainFrame().getServerDateTime(), //v_rmkmoddt
					memPrintDate, //v_printdate
					memDDisc, //v_slpoddisc
					memHDisc, //v_slpohdisc
					memSDisc, //v_slposdisc
					getRightJCheckBox_Complex().isSelected()?YES_VALUE:NO_VALUE,
					getRightJCheckBox_MAllocate().isSelected()?YES_VALUE:NO_VALUE,
					getRightJCheckBox_AR().isSelected()?YES_VALUE:NO_VALUE,
					getRightJText_SourceNo().getText(), // v_sourceno
					getRightJText_SendBillDate().getText().trim(), //v_sendbilldate
					getRightJCombo_SendBillType().getText().trim(), //v_sendbilltype,
					getRightJCombo_SpRqt().getText(), //special request
					getPJCheckBox_Revlog().isSelected()?MINUS_ONE_VALUE:ZERO_VALUE, //i_isrqlog
					getRightJCombo_LogCvrCls().getText(), //i_aracmcode
					getRightJCombo_Package().getText(), //i_pbpkgcode
					getPJCheckBox_EstGiven().isSelected()?MINUS_ONE_VALUE:ZERO_VALUE, //i_estgiven
					getRightJCombo_NoSign().getText(), //i_nosign
					getINJCheckBox_PrtMedRecordRpt().isSelected()?MINUS_ONE_VALUE:ZERO_VALUE, //I_PRINT_MRRPT
					isUpdAllSlpNoSign, //update all related slip no sign option
					getUserInfo().getUserID(),
					getPJCheckBox_BE().isSelected()?MINUS_ONE_VALUE:ZERO_VALUE
				},
				TxnCallBack.getInstance().getDoPostTransactionCallBack(this));
	}

	public void doPostTrasactionsSuccess(MessageQueue mQueue) {
		if (mQueue.success()) {
			doPostTrasactionsReady(true);
		} else {
			Factory.getInstance().addErrorMessage(mQueue);
		}
	}

	// revised by ck on 20130225. call db function NHS_ACT_CancelPackage() instead.
	private void cancelPkg() {
		QueryUtil.executeMasterAction(getUserInfo(), "CANCELPACKAGE", QueryUtil.ACTION_MODIFY,
				new String[] {  slpNo, getListTable().getSelectedRowContent()[STNID2_COL], getUserInfo().getUserID() },
				TxnCallBack.getInstance().getCancelPkgCallBack(this));
	}

	public void cancelPkgCallBackSuccess(MessageQueue mQueue) {
		if (mQueue.success()) {
			refreshAction();
			Factory.getInstance().addInformationMessage(MSG_CANCEL_PACKAGE_SUCCESS);
		} else {
			Factory.getInstance().addErrorMessage(MSG_CANCEL_PACKAGE_FAIL);
		}
	}

	protected boolean isRegisteredExam() {
		if (getListTable().getSelectedRowContent()[STNID_COL] != null) {
			return getListTable().getSelectedRowContent()[STNID_COL].length() > 0;
		} else {
			return false;
		}
	}

	private void previewBillSummary() {
		Map<String,String> map = new HashMap<String,String>();
		map.put("SLPNO", slpNo);
		map.put("PATNAME", getRightJText_PatientName().getText());

		Report.print(getUserInfo(), "BillSummary", map,
				new String[] { getRightJText_SlipNo().getText() },
				new String[] { "SLPNO", "PATNO", "SLPCAMT", "SLPPAMT", "HOSCHG",
						"DOCCHG", "OTHCHG", "SPECHG", "HOSNET", "DOCNET",
						"OTHNET", "SPENET", "HOSDISC", "DOCDISC", "OTHDISC",
						"SPEDISC", "HOSCRED", "DOCCRED", "OTHCRED", "SPECRED",
						"DISCOUNT", "TOTCHG", "SLPDAMT", "DEPOSIT", "ARPAY",
						"SELFPAY", "REFUND", "BALANCE" }, true);
	}

/*
	private void printBillSummary() {
		Map<String,String> map = new HashMap<String,String>();
		map.put("SLPNO", slpNo);
		map.put("PATNAME", getRightJText_PatientName().getText());

		PrintingUtil.print("BillSummary", map,"",
				new String[] { getRightJText_SlipNo().getText() },
				new String[] { "SLPNO", "PATNO", "SLPCAMT", "SLPPAMT", "HOSCHG",
					"DOCCHG", "OTHCHG", "SPECHG", "HOSNET", "DOCNET", "OTHNET",
					"SPENET", "HOSDISC", "DOCDISC", "OTHDISC", "SPEDISC",
					"HOSCRED", "DOCCRED", "OTHCRED", "SPECRED", "DISCOUNT",
					"TOTCHG", "SLPDAMT", "DEPOSIT", "ARPAY", "SELFPAY", "REFUND",
					"BALANCE" });
	}
*/

	private void btnStatementPrintRpt() {
		isSlipIP(primarySlipGet());
	}

	private void btnClosePrintRpt() {
		isCloseSlipIP(primarySlipGet());
	}

	private void getStatementDialog() {
		if (ConstantsTransaction.SLIP_TYPE_INPATIENT.equals(slipType)) {
			getDlgIPStmtORIPStmtSmy().showDialog(getRightJText_PatientNo().getText().trim(), slpNo,
					slipType, lang, memAcmCode, arInpSmySignature, mothLang);
		} else if (ConstantsTransaction.SLIP_TYPE_OUTPATIENT.equals(slipType)) {
			getDlgOPDayCaseStatement().showDialog(getRightJText_PatientNo().getText().trim(), slpNo, slipType, false, "Statement", false, lang, mothLang,
													smtRemark, getRightJCombo_ARCompanyCode().getText().length() > 0, arSignature);
		} else if (ConstantsTransaction.SLIP_TYPE_DAYCASE.equals(slipType)) {
			if (HKAH_VALUE.equals(getUserInfo().getSiteCode())) {
				getDlgOPDayCaseStatement().showDialog(getRightJText_PatientNo().getText().trim(), slpNo, slipType, false, "Statement", false, lang, mothLang,
						smtRemark, getRightJCombo_ARCompanyCode().getText().length() > 0, arSignature);
			} else {
				getDlgChrgDayCase().showDialog(getRightJText_PatientNo().getText().trim(), slpNo, slipType, false, lang);
			}

		}
	}

	private String primarySlipGet() {
		return getRightJText_SlipNo().getText();
	}

	private void isSlipIP(String slipNo) {
//		return whether specified Slip is IP or not
//		if yes, return 1
//		if not a IP slip, return -1
//		if slpno not found in TABLE: Slip, return -2

		if (ConstantsTransaction.SLIP_TYPE_INPATIENT.equals(slipType)) {
			getDlgIPStmtORIPStmtSmy().showDialog(getRightJText_PatientNo().getText().trim(),
					slipNo, slipType, lang, memAcmCode, arInpSmySignature, mothLang);
		} else if (ConstantsTransaction.SLIP_TYPE_OUTPATIENT.equals(slipType)) {
			getDlgOPDayCaseStatement().showDialog(getRightJText_PatientNo().getText().trim(), slipNo, slipType, false, "Statement", false, lang, mothLang,
													smtRemark, getRightJCombo_ARCompanyCode().getText().length() > 0, arSignature);
		} else if (ConstantsTransaction.SLIP_TYPE_DAYCASE.equals(slipType)) {
			if (HKAH_VALUE.equals(getUserInfo().getSiteCode())) {
				getDlgOPDayCaseStatement().showDialog(getRightJText_PatientNo().getText().trim(), slipNo, slipType, false, "Statement", false, lang, mothLang,
						smtRemark, getRightJCombo_ARCompanyCode().getText().length() > 0, arSignature);
			} else {
				getDlgChrgDayCase().showDialog(getRightJText_PatientNo().getText().trim(), slipNo, slipType, false, lang);
			}
		}
/*
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] {"slip", "slptype", "slpno= '" + slipNo + "'"},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					if (ConstantsTransaction.SLIP_TYPE_INPATIENT.equals(mQueue.getContentField()[0])) {
						getDlgIPStmtORIPStmtSmy().showDialog(slipNo, slipType);
					} else if (ConstantsTransaction.SLIP_TYPE_OUTPATIENT.equals(mQueue.getContentField()[0])) {
						getDlgOPDayCaseStatement().showDialog(slipNo, slipType, false, "Statement", false);
					} else if (ConstantsTransaction.SLIP_TYPE_DAYCASE.equals(mQueue.getContentField()[0])) {
						getDlgChrgDayCase().showDialog(slipNo, slipType, false);
					}
				} else {
					Factory.getInstance().addErrorMessage("<html>"+MSG_INVALID_SLPNO+"<br>"+MSG_ERR_CANNOT_CONTINUE+"</html>"," PBA-[Transaction Detail]", getRightButton_Statement());
				}
			}
		});
*/
	}

	private void isCloseSlipIP(final String slipNo) {
//		return whether specified Slip is IP or not
//		if yes, return 1
//		if not a IP slip, return -1
//		if slpno not found in TABLE: Slip, return -2

		if ((ConstantsTransaction.SLIP_TYPE_INPATIENT.equals(slipType))) {
			getDlgIPStmtOROffReceipt().showDialog(slipNo, slipType, true, lang);
		} else if (ConstantsTransaction.SLIP_TYPE_OUTPATIENT.equals(slipType)) {
			if (Factory.getInstance().getSysParameter("AUTPRTRECE").equals("Y")) {
				MessageBox messageBox = MessageBoxBase.confirm(MSG_PBA_SYSTEM,  "Do you want to print the receipt automatically?",
						new Listener<MessageBoxEvent>() {
					@Override
					public void handleEvent(MessageBoxEvent be) {
						if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
							getDlgOPDayCaseStatement().showDialog(getRightJText_PatientNo().getText().trim(), slipNo, slipType, false, "Receipt", true, lang, mothLang,
																	smtRemark, getRightJCombo_ARCompanyCode().getText().length() > 0, arSignature);
						} else {
							getDlgOPDayCaseStatement().showDialog(getRightJText_PatientNo().getText().trim(), slipNo, slipType, true, "Receipt", false, lang, mothLang,
																	smtRemark, getRightJCombo_ARCompanyCode().getText().length() > 0, arSignature);
						}
					}
				});
				messageBox.getDialog().focus();
				// set default yes
				messageBox.getDialog().setFocusWidget(messageBox.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
			} else {
				getDlgOPDayCaseStatement().showDialog(getRightJText_PatientNo().getText().trim(), slipNo, slipType, true, "Receipt", false, lang, mothLang,
														smtRemark, getRightJCombo_ARCompanyCode().getText().length() > 0, arSignature);
			}
		} else if (ConstantsTransaction.SLIP_TYPE_DAYCASE.equals(slipType)) {
			if (HKAH_VALUE.equals(getUserInfo().getSiteCode())) {
				getDlgOPDayCaseStatement().showDialog(getRightJText_PatientNo().getText().trim(), slipNo, slipType, true, "Receipt", false, lang, mothLang,
						smtRemark, getRightJCombo_ARCompanyCode().getText().length() > 0, arSignature);
			} else {
				getDlgChrgDayCase().showDialog(getRightJText_PatientNo().getText().trim(), slipNo, slipType, true, lang);
			}
		}
/*
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] {"slip", "slptype", "slpno= '" + slipNo + "'"},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					if ((ConstantsTransaction.SLIP_TYPE_INPATIENT.equals(slipType))) {
						getDlgIPStmtOROffReceipt().showDialog(slpNo, slipType, true);
					} else if (ConstantsTransaction.SLIP_TYPE_OUTPATIENT.equals(slipType)) {
						if (Factory.getInstance().getSysParameter("AUTPRTRECE").equals("Y")) {
							MessageBox messageBox = MessageBoxBase.confirm(MSG_PBA_SYSTEM,  "Do you want to print the receipt automatically?",
									new Listener<MessageBoxEvent>() {
								@Override
								public void handleEvent(MessageBoxEvent be) {
									if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
										getDlgOPDayCaseStatement().showDialog(slpNo, slipType, false, "Receipt", true);
									} else {
										getDlgOPDayCaseStatement().showDialog(slpNo, slipType, true, "Receipt", false);
									}
								}
							});
							messageBox.getDialog().focus();
							// set default yes
							messageBox.getDialog().setFocusWidget(messageBox.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
						} else {
							getDlgOPDayCaseStatement().showDialog(slpNo, slipType, true, "Receipt", false);
						}
					} else if (ConstantsTransaction.SLIP_TYPE_DAYCASE.equals(slipType)) {
						getDlgChrgDayCase().showDialog(slpNo, slipType, true);
					}
				} else {
					Factory.getInstance().addErrorMessage("<html>"+MSG_INVALID_SLPNO+"<br>"+MSG_ERR_CANNOT_CONTINUE+"</html>"," PBA-[Transaction Detail]", getRightButton_Statement());
				}
			}
		});
*/
	}

	private void setCheckDate() {
		if (!getRightJText_AdmissionDate().isEmpty()) {
			checkDate = getRightJText_AdmissionDate().getText();
		} else {
			Date tempDate = DateTimeUtil.parseDateTime("01/01/" + slpNo.substring(0, 4) + " 00:00:00");
			tempDate.setDate(Integer.parseInt(slpNo.substring(4, 7)));

			checkDate = DateTimeUtil.formatDateTime(tempDate);
		}
	}

	/***************************************************************************
	 * Cancel Item
	 **************************************************************************/

	private void doCancelItem(final String stnID, final String stnxref,
			final String stnSeq, final boolean isDIReported,
			final boolean isDIPayed, final boolean isDIPayedDr,
			final String cancelReason, final boolean isCancelItem) {
		QueryUtil.executeMasterAction(getUserInfo(), "ItemCancel", QueryUtil.ACTION_APPEND,
				new String[] {
					getUserInfo().getUserID(),
					getUserInfo().getCashierCode(),
					slpNo,
					stnID,
					isDIReported ? YES_VALUE : NO_VALUE,
					isDIPayed ? YES_VALUE : NO_VALUE,
					isDIPayedDr ? YES_VALUE : NO_VALUE,
					cancelReason,
					isCancelItem ? YES_VALUE : NO_VALUE
				},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(final MessageQueue mQueue) {
				if (mQueue.success()) {
					Factory.getInstance().addInformationMessage(MSG_CANCEL_ITEM_SUCCESS, "PBA-[Transaction Detail]");
					getFetchDetail(true);
				} else {
					if ("-100".equals(mQueue.getReturnCode())
							|| "-200".equals(mQueue.getReturnCode())
							|| "-300".equals(mQueue.getReturnCode())) {
						MessageBoxBase.confirm(MSG_PBA_SYSTEM, mQueue.getReturnMsg(), new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									if ("-100".equals(mQueue.getReturnCode())) {
										doCancelItem(stnID, stnxref, stnSeq, true, isDIPayed, isDIPayedDr, cancelReason, isCancelItem);
									} else if ("-200".equals(mQueue.getReturnCode())) {
										doCancelItem(stnID, stnxref, stnSeq, isDIReported, true, isDIPayedDr, cancelReason, isCancelItem);
									} else if ("-300".equals(mQueue.getReturnCode())) {
										doCancelItem(stnID, stnxref, stnSeq, isDIReported, isDIPayed, true, cancelReason, isCancelItem);
									}
								} else {
									Factory.getInstance().addErrorMessage(MSG_CANCEL_ITEM_FAIL, "PBA-[Transaction Detail]");
								}
							}
						});
					} else if ("-400".equals(mQueue.getReturnCode())) {
						getDlgReason().showDialog(stnID, stnxref, stnSeq, isDIReported, isDIPayed, isDIPayedDr, isCancelItem);
					} else if ("-500".equals(mQueue.getReturnCode())) {
						MessageBoxBase.confirm(MSG_PBA_SYSTEM, MSG_CANCEL_ITEM, new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									doCancelItem(stnID, stnxref, stnSeq, isDIReported, isDIPayed, isDIPayedDr, cancelReason, true);
								}
							}
						});
					} else if ("-602".equals(mQueue.getReturnCode())) {
						// void payment
						doCashierVoidEntry(getUserInfo(), stnxref, slpNo, stnSeq);
						memStnid = stnID;
					} else {
						Factory.getInstance().addErrorMessage(mQueue.getReturnMsg(), "PBA-[Transaction Detail]");
					}
				}
			}
		});
	}

	/***************************************************************************
	 * Close Slip
	 **************************************************************************/

	private void doCloseSlip() {
		// to reduce call database, move confirm close slip message in the front
		MessageBox messageBox = MessageBoxBase.confirm(MSG_PBA_SYSTEM,  "Do you want to close the slip?",
				new Listener<MessageBoxEvent>() {
			@Override
			public void handleEvent(MessageBoxEvent be) {
				if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
					checkSlipBeforeClose(slpNo, false, false);
				}
			}
		});
		// set default yes
		messageBox.getDialog().setFocusWidget(messageBox.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
	}

	// check slip before close
	private void checkSlipBeforeClose(final String slpno, final boolean manual, final boolean discharge) {
		Factory.getInstance().getMainFrame().writeLog("TransactionDetail", "Info", "checkSlipBeforeClose slip: " + slpno + ", manual: " + manual + ", discharge: " + discharge);

		QueryUtil.executeMasterAction(getUserInfo(), "TXNCLOSE", QueryUtil.ACTION_APPEND,
			new String[] {
				slpno, getRightJText_PatientNo().getText(),
				manual ? YES_VALUE : NO_VALUE,
				discharge ? YES_VALUE : NO_VALUE,
				CommonUtil.getComputerName(),
				getUserInfo().getUserID()
			},
			TxnCallBack.getInstance().getCheckSlipBeforeCloseCallBack(this, slpno, manual, discharge));
	}

	public void checkSlipBeforeCloseSuccess(MessageQueue mQueue, final String slpno,
											final boolean manual, final boolean discharge) {
		if (mQueue.success()) {
			// close and print report?
/*
			if ((ConstantsTransaction.SLIP_TYPE_INPATIENT.equals(slipType))) {
				getDlgIPStmtOROffReceipt().showDialog(slpNo, slipType, true);
			} else if (ConstantsTransaction.SLIP_TYPE_OUTPATIENT.equals(slipType)) {
				getDlgOPDayCaseStatement().showDialog(slpNo, slipType, true, "Receipt");
			} else if (ConstantsTransaction.SLIP_TYPE_DAYCASE.equals(slipType)) {
				getDlgChrgDayCase().showDialog(slpNo, slipType, true);
			}
*/
			btnClosePrintRpt();
			getFetchDetail(false);
			
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] {"APPBILLS", "BILLID", "SLPNO = "+slpno+" AND BILLSTS = 'N'"},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						final String bID = mQueue.getContentField()[0];
						QueryUtil.executeMasterAction(getUserInfo(), "APPBILL_CLOSE", QueryUtil.ACTION_APPEND,
								new String[] {mQueue.getContentField()[0]},
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									Factory.getInstance().addInformationMessage("Related Mobile Bill Closed");
									AppStmtUtil.closeSlipRegen(getRightJText_PatientNo().getText(), slpno, bID);
								} else {
									//Factory.getInstance().addErrorMessage(mQueue, getPkgCode());
								}
							}
						});
					}
				}
			});
		} else if ("-200".equals(mQueue.getReturnCode())) {
			MessageBoxBase.confirm(MSG_PBA_SYSTEM, mQueue.getReturnMsg(), new Listener<MessageBoxEvent>() {
				@Override
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						checkSlipBeforeClose(slpno, true, discharge);
					}
				}
			});
		} else if ("-500".equals(mQueue.getReturnCode())) {
			MessageBox mb = MessageBoxBase.confirm(MSG_PBA_SYSTEM, mQueue.getReturnMsg(), new Listener<MessageBoxEvent>() {
				@Override
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						checkSlipBeforeClose(slpno, manual, true);
					}
				}
			});

			mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
		} else {
			if ("-100".equals(mQueue.getReturnCode())) {
				getRightButton_CloseBill().setEnabled(false);
			}
			Factory.getInstance().addErrorMessage(mQueue);
		}
	}

	private void setCmdPrtSuppStatus(String lStnId) {
		getRightButton_PrtSupp().setEnabled(false);

		if (!lStnId.isEmpty()) {
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] {"TxnEndosDtls", "count(1)", "stnid ='" + lStnId + "' and usrid_c is null"},
					TxnCallBack.getInstance().getSetCmdPrtSuppStatusCallBack(this));
		}
	}

	public void setCmdPrtSuppStatusSuccess(MessageQueue mQueue) {
		if (!mQueue.success() || ZERO_VALUE.equals(mQueue.getContentField()[0])) {
		} else {
			getRightButton_PrtSupp().setEnabled(true);
		}
	}

	private void updateSlipStatus(final String method) {
		QueryUtil.executeMasterAction(getUserInfo(), ConstantsTx.SLIP_TXCODE,
				QueryUtil.ACTION_MODIFY, new String[] { method, slpNo, getMainFrame().getComputerIP(), getUserInfo().getUserID() },
				TxnCallBack.getInstance().getUpdateSlipStatusCallBack(this));
	}

	public void updateSlipStatusSuccess(MessageQueue mQueue) {
		refreshAction();
		if (!mQueue.success()) {
			Factory.getInstance().addErrorMessage(mQueue);
		}
	}

	private void setDoctorAppParam() {
		setParameter("From", "TxnDetail");
		setParameter("memDocCode", getRightJText_Doctor().getText());
		setParameter("PatNo", getRightJText_PatientNo().getText());
	}

	private void setPatientAppParam() {
		setParameter("PatNo", getRightJText_PatientNo().getText());
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected void proExitPanel() {
		// unlock slip no before exit
		if (slpNo != null && slpNo.length() > 0) {
			unlockRecord("Slip", slpNo);
		}

		if (oldSlpNo != null && oldSlpNo.length() > 0) {
			unlockRecord("Slip", oldSlpNo);
		}

		if (isFromSrhPatStsView) {
			  setParameter("bFromSelectSlip", "True");
		}

		// clear LCD
		doLCDInitial();
	}

	@Override
	public void enableButton(String mode) {
		disableButton();
		getSearchButton().setEnabled(!isDisableFunction("TB_SEARCH", "txnDetails"));

		if (isModify()) {
			getSaveButton().setEnabled(!isDisableFunction("TB_COMMIT", "txnDetails"));
			getCancelButton().setEnabled(!isDisableFunction("TB_CANCEL", "txnDetails"));
		} else {
			getModifyButton().setEnabled(!isDisableFunction("TB_MODIFY", "txnDetails") && !isReadOnly);
			getRefreshButton().setEnabled(!isDisableFunction("TB_Refresh", "txnDetails"));
		}

//		getPrintButton().setEnabled(!isDisableFunction("TB_Print", "txnDetails"));
	}

	/**
	 * override the method searchAction()
	 */
	@Override
	public void searchAction() {
		exitPanel();
	}

	/**
	 * override modifyAction()
	 */
	@Override
	public void modifyAction() {
		super.modifyAction();

		if (ConstantsTransaction.SLIP_STATUS_REMOVE.equals(slpsts) || ConstantsTransaction.SLIP_STATUS_CLOSE.equals(slpsts)) {
			PanelUtil.setAllFieldsEditable(getRightPanel(), false);
			PanelUtil.setAllFieldsEditable(getSlipDetailPanel(), false);
			PanelUtil.setAllFieldsEditable(getTotalPanel(), false);
			PanelUtil.setAllFieldsEditable(getDiscountPanel(), false);

			getRightJText_Remarks().setEditable(true);
			getRightJText_CategoryName().setEditable(true);
			getRightJCombo_NoSign().setEditable(true);
			getRightJText_SendBillDate().setEditable(true);
			getRightJCombo_SendBillType().setEditable(true);
		} else {
			PanelUtil.setAllFieldsEditable(getSlipDetailPanel(), true);
			PanelUtil.setAllFieldsEditable(getDiscountPanel(), true);
			getRightJText_SendBillDate().setEditable(true);
			getRightJCombo_SendBillType().setEditable(true);
			getRightJCheckBox_AR().setEditable(true);
			getRightJCheckBox_MAllocate().setEditable(true);
			getRightJCombo_SpRqt().setEditable(true);
			getRightJCombo_Package().setEditable(true);
			getPJCheckBox_Revlog().setEditable(true);
			getRightJCombo_LogCvrCls().setEditable(true);
			getRightJCombo_NoSign().setEditable(true);

			if (!getRightJCombo_ARCompanyCode().isEmpty()) {
				allowArEntry(true);
			} else {
				allowArEntry(false);
			}
		}
	}

	/**
	 * set the search criteria height
	 */
	@Override
	protected int getSearchHeight() {
		return 145;
	}

	@Override
	protected void lockRecordReady(final String lockType, final String lockKey, String[] record, boolean lock, String returnMessage) {
		isLocked = lock;
		isReadOnly = false;
		if (lock) {
			skipLockRecord();
		} else {
			MessageBox mb = MessageBoxBase.confirm(MSG_PBA_SYSTEM, returnMessage + " <font color='green'>Do you want to read-only mode?</font>",
					new Listener<MessageBoxEvent>() {
				@Override
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						isReadOnly = true;
					}
					skipLockRecord();
				}
			});
			mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.NO));
		}
	}

	private void skipLockRecord() {
		if (isLocked || isReadOnly) {
			getFetchDetail(true);

			// handle internal previous slip
			if (oldSlpNo != null) {
				getDlgSlipList().dispose();
				unlockRecord("Slip", oldSlpNo);
				oldSlpNo = null;
			}
		} else {
			slpNo = null; // no need to unlock when exit
			// load previous slip
			if (oldSlpNo != null) {
				slpNo = oldSlpNo;
				oldSlpNo = null;
				getFetchDetail(true);
			} else {
				exitPanel();
			}
		}
	}

	@Override
	public void saveAction() {
		actionValidation();
	}

	protected void savePostAction() {
		refreshAction();
	}

	@Override
	protected void cancelPostAction() {
		refreshAction();
	}

	/**
	 * override the method refreshAction()
	 */
	@Override
	public void refreshAction() {
		getFetchDetail(true);
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/**
	 * This method initializes rightPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	@Override
	protected BasePanel getActionPanel() {
		if (rightPanel == null) {
			rightPanel = new BasePanel();
			rightPanel.setBounds(5, 5, 800, 528);
			rightPanel.add(getSlipDetailPanel(), null);

			rightPanel.add(getTotalPanel(), null);
			rightPanel.add(getRightJLabel_RoomPhone(), null);
			rightPanel.add(getRightJText_RoomPhone(), null);
			rightPanel.add(getRightJText_OT(), null);
			rightPanel.add(getRightJLabel_OTCount(), null);
			rightPanel.add(getRightJText_OTCount(), null);

			rightPanel.add(getDiscountPanel(), null);
			rightPanel.add(getRightJLabel_SendBillDate(), null);
			rightPanel.add(getRightJText_SendBillDate(), null);
			rightPanel.add(getRightJCombo_SendBillType(), null);
			rightPanel.add(getRightJLabel_SpRqt(), null);
			rightPanel.add(getRightJCombo_SpRqt(), null);
			rightPanel.add(getRightJLabel_AR(), null);
			rightPanel.add(getRightJCheckBox_AR(), null);
			rightPanel.add(getRightJLabel_MAllocate(), null);
			rightPanel.add(getRightJCheckBox_MAllocate(), null);
			rightPanel.add(getShowHistory(), null);
			rightPanel.add(getShowHistoryDesc(), null);
			rightPanel.add(getOrderByDesc(), null);
			rightPanel.add(getOrderBy(), null);
			rightPanel.add(getBtnPanel(), null);

			rightPanel.add(getRightJScrollPane_Detail(), null);
		}
		return rightPanel;
	}

	/**
	 * This method initializes slipDetailPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	public FieldSetBase getSlipDetailPanel() {
		if (slipDetailPanel == null) {
			slipDetailPanel = new FieldSetBase();
			slipDetailPanel.setLayout(new AbsoluteLayout());
			slipDetailPanel.setHeading("Slip Details");
			slipDetailPanel.setBounds(5, 0, 810, 133);
			slipDetailPanel.add(getRightJLabel_SlipNo(), null);
			slipDetailPanel.add(getRightJText_SlipNo(), null);
			slipDetailPanel.add(getRightJText_PatientNo(), null);
			slipDetailPanel.add(getRightJLabel_PatientNo(), null);
			slipDetailPanel.add(getRightJText_PatientName(), null);
			slipDetailPanel.add(getRightJLabel_Staff(), null);
			slipDetailPanel.add(getRightJCheckBox_Staff(), null);
			slipDetailPanel.add(getRightJLabel_BedCode(), null);
			slipDetailPanel.add(getRightJText_BedCode(), null);
			slipDetailPanel.add(getRightJLabel_AcmDesc(), null);
			slipDetailPanel.add(getRightJText_AcmDesc(), null);
			slipDetailPanel.add(getRightJLabel_Misc(), null);
			slipDetailPanel.add(getRightJCombo_Misc(), null);
			slipDetailPanel.add(getRightJLabel_Nature(), null);
			slipDetailPanel.add(getRightJText_Nature(), null);
			slipDetailPanel.add(getRightJLabel_AdmissionDate(), null);
			slipDetailPanel.add(getRightJText_AdmissionDate(), null);
			slipDetailPanel.add(getRightJLabel_Doctor(), null);
			slipDetailPanel.add(getRightJText_Doctor(), null);
			slipDetailPanel.add(getRightJText_DoctorName(), null);
			slipDetailPanel.add(getRightJLabel_DischargeDate(), null);
			slipDetailPanel.add(getRightJText_DischargeDate(), null);
			slipDetailPanel.add(getRightJLabel_CategoryNo(), null);
			slipDetailPanel.add(getRightJCombo_CategoryNo(), null);
			slipDetailPanel.add(getRightJLabel_RefNo(), null);
			slipDetailPanel.add(getRightJText_CategoryName(), null);
			slipDetailPanel.add(getRightJLabel_Source(), null);
			slipDetailPanel.add(getRightJCombo_Source(), null);
			slipDetailPanel.add(getRightJCombo_ARCompanyCode(), null);
			slipDetailPanel.add(getRightJText_ARCompanyDesc(), null);
			slipDetailPanel.add(getRightJText_ARCardType(), null);
			slipDetailPanel.add(getRightJLabel_ARCompanyCode(), null);
			slipDetailPanel.add(getRightJLabel_PolicyNo(), null);
			slipDetailPanel.add(getRightJText_PolicyNo(), null);
			slipDetailPanel.add(getRightJLabel_VoucherNo(), null);
			slipDetailPanel.add(getRightJText_VoucherNo(), null);
			slipDetailPanel.add(getRightJLabel_PreAuthNo(), null);
			slipDetailPanel.add(getRightJText_PreAuthNo(), null);
			slipDetailPanel.add(getINJLabel_PrtMedRecordRpt(), null);
			slipDetailPanel.add(getINJCheckBox_PrtMedRecordRpt(), null);
			slipDetailPanel.add(getRightJLabel_SourceNo(), null);
			slipDetailPanel.add(getRightJText_SourceNo(), null);
			slipDetailPanel.add(getRightJLabel_LimitAmount(), null);
			slipDetailPanel.add(getRightJText_LimitAmount(), null);
			slipDetailPanel.add(getRightJLabel_CoPayRefNo(), null);
			slipDetailPanel.add(getRightJCombo_CoPayRefType(), null);
			slipDetailPanel.add(getRightJText_CoPayRefAmount(), null);
			slipDetailPanel.add(getRightJLabel_CoPayActualNo(), null);
			slipDetailPanel.add(getRightJText_CoPayActualAmount(), null);
			slipDetailPanel.add(getRightJLabel_CvtEndDate(), null);
			slipDetailPanel.add(getRightJText_CvtEndDate(), null);
			slipDetailPanel.add(getRightJLabel_FGrtAmount(), null);
			slipDetailPanel.add(getRightJText_FGrtAmount(), null);
			slipDetailPanel.add(getRightJLabel_FGrtDate(), null);
			slipDetailPanel.add(getRightJText_FGrtDate(), null);
			slipDetailPanel.add(getPJLabel_RevLog(), null);
			slipDetailPanel.add(getPJCheckBox_Revlog(), null);
			slipDetailPanel.add(getRightJLabel_LogCvrCls(), null);
			slipDetailPanel.add(getRightJCombo_LogCvrCls(), null);
			slipDetailPanel.add(getPJLabel_EstGiven(), null);
			slipDetailPanel.add(getPJCheckBox_EstGiven(), null);
			slipDetailPanel.add(getPJCheckBox_BEDesc(), null);
			slipDetailPanel.add(getPJCheckBox_BE(), null);
			slipDetailPanel.add(getRightJLabel_Package(), null);
			slipDetailPanel.add(getRightJCombo_Package(), null);
			slipDetailPanel.add(getRightJLabel_NoSign(), null);
			slipDetailPanel.add(getRightJCombo_NoSign(), null);
			slipDetailPanel.add(getRightButton_Remarks(), null);
			slipDetailPanel.add(getRightJText_Remarks(), null);
			slipDetailPanel.add(getRightJLabel_Complex(), null);
			slipDetailPanel.add(getRightJCheckBox_Complex(), null);
			slipDetailPanel.add(getCoveredItemPanel(), null);
		}
		return slipDetailPanel;
	}

	/**
	 * This method initializes RightJLabel_SlipNo
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_SlipNo() {
		if (RightJLabel_SlipNo == null) {
			RightJLabel_SlipNo = new LabelSmallBase();
			RightJLabel_SlipNo.setText("Slip Number");
			RightJLabel_SlipNo.setBounds(5, -5, 90, 20);
		}
		return RightJLabel_SlipNo;
	}

	/**
	 * This method initializes RightJText_SlipNo
	 *
	 * @return com.hkah.client.layout.label.TextReadOnly
	 */
	private TextReadOnly getRightJText_SlipNo() {
		if (RightJText_SlipNo == null) {
			RightJText_SlipNo = new TextReadOnly();
			RightJText_SlipNo.setBounds(80, -5, 90, 20);
		}
		return RightJText_SlipNo;
	}

	/**
	 * This method initializes RightJLabel_PatientNo
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_PatientNo() {
		if (RightJLabel_PatientNo == null) {
			RightJLabel_PatientNo = new LabelSmallBase();
			RightJLabel_PatientNo.setText("Patient");
			RightJLabel_PatientNo.setBounds(185, -5, 40, 20);
		}
		return RightJLabel_PatientNo;
	}

	/**
	 * This method initializes RightJText_PatientNo
	 *
	 * @return com.hkah.client.layout.label.TextReadOnly
	 */
	private TextReadOnly getRightJText_PatientNo() {
		if (RightJText_PatientNo == null) {
			RightJText_PatientNo = new TextReadOnly();
			RightJText_PatientNo.setBounds(225, -5, 68, 20);
		}
		return RightJText_PatientNo;
	}

	/**
	 * This method initializes RightJText_PatientName
	 *
	 * @return com.hkah.client.layout.label.TextReadOnly
	 */
	private TextReadOnly getRightJText_PatientName() {
		if (RightJText_PatientName == null) {
			RightJText_PatientName = new TextReadOnly();
			RightJText_PatientName.setBounds(295, -5, 210, 20);
		}
		return RightJText_PatientName;
	}

	/**
	 * This method initializes RightJLabel_Staff
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_Staff() {
		if (RightJLabel_Staff == null) {
			RightJLabel_Staff = new LabelSmallBase();
			RightJLabel_Staff.setText("Staff");
			RightJLabel_Staff.setBounds(512, -5, 25, 20);
		}
		return RightJLabel_Staff;
	}

	/**
	 * This method initializes RightJCheckBox_Staff
	 *
	 * @return com.hkah.client.layout.button.CheckBoxBase
	 */
	private CheckBoxBase getRightJCheckBox_Staff() {
		if (RightJCheckBox_Staff == null) {
			RightJCheckBox_Staff = new CheckBoxBase();
			RightJCheckBox_Staff.setBounds(535, -5, 20, 20);
		}
		return RightJCheckBox_Staff;
	}

	/**
	 * This method initializes RightJLabel_BedCode
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_BedCode() {
		if (RightJLabel_BedCode == null) {
			RightJLabel_BedCode = new LabelSmallBase();
			RightJLabel_BedCode.setText("Bed Code");
			RightJLabel_BedCode.setBounds(565, -5, 60, 20);
		}
		return RightJLabel_BedCode;
	}

	/**
	 * This method initializes RightJText_BedCode
	 *
	 * @return com.hkah.client.layout.label.TextReadOnly
	 */
	private TextReadOnly getRightJText_BedCode() {
		if (RightJText_BedCode == null) {
			RightJText_BedCode = new TextReadOnly();
			RightJText_BedCode.setBounds(620, -5, 90, 20);
		}
		return RightJText_BedCode;
	}

	/**
	 * This method initializes RightJLabel_AcmDesc
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_AcmDesc() {
		if (RightJLabel_AcmDesc == null) {
			RightJLabel_AcmDesc = new LabelSmallBase();
			RightJLabel_AcmDesc.setText("Class");
			RightJLabel_AcmDesc.setBounds(715, -5, 70, 20);
		}
		return RightJLabel_AcmDesc;
	}

	/**
	 * This method initializes RightJText_AcmDesc
	 *
	 * @return com.hkah.client.layout.label.TextReadOnly
	 */
	private TextReadOnly getRightJText_AcmDesc() {
		if (RightJText_AcmDesc == null) {
			RightJText_AcmDesc = new TextReadOnly();
			RightJText_AcmDesc.setBounds(750, -5, 50, 20);
		}
		return RightJText_AcmDesc;
	}
	/**
	 * This method initializes RightJLabel_Misc
	 *
	 * @return com.hkah.client.layout.label.TextReadOnly
	 */
	public LabelSmallBase getRightJLabel_Misc() {
		if (RightJLabel_Misc == null) {
			RightJLabel_Misc = new LabelSmallBase();
			RightJLabel_Misc.setText("Misc");
			RightJLabel_Misc.setBounds(709, -5, 25, 20);
			RightJLabel_Misc.setVisible(false);
		}
		return RightJLabel_Misc;
	}

	public ComboBoxBase getRightJCombo_Misc() {
		if (RightJCombo_Misc == null) {
			RightJCombo_Misc = new ComboBoxBase("TRANSMISC", false, false, true);
			RightJCombo_Misc.setBounds(735, -5, 65, 20);
			RightJCombo_Misc.setVisible(false);
		}
		return RightJCombo_Misc;
	}
	
	private LabelSmallBase getRightJLabel_Nature() {
		if (RightJLabel_Nature == null) {
			RightJLabel_Nature = new LabelSmallBase();
			RightJLabel_Nature.setText("NV");
			RightJLabel_Nature.setBounds(740, -5, 20, 20);
			RightJLabel_Nature.setVisible(false);
		}
		return RightJLabel_Nature;
	}

	private TextReadOnly getRightJText_Nature() {
		if (RightJText_Nature == null) {
			RightJText_Nature = new TextReadOnly();
			RightJText_Nature.setBounds(760, -5, 45, 20);
			RightJText_Nature.setVisible(false);
		}
		return RightJText_Nature;
	}

	/**
	 * This method initializes RightJLabel_AdmissionDate
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_AdmissionDate() {
		if (RightJLabel_AdmissionDate == null) {
			RightJLabel_AdmissionDate = new LabelSmallBase();
			RightJLabel_AdmissionDate.setText("Adm. Dt");
			RightJLabel_AdmissionDate.setBounds(5, 17, 65, 20);
		}
		return RightJLabel_AdmissionDate;
	}

	/**
	 * This method initializes RightJText_AdmissionDate
	 *
	 * @return com.hkah.client.layout.label.TextReadOnly
	 */
	private TextReadOnly getRightJText_AdmissionDate() {
		if (RightJText_AdmissionDate == null) {
			RightJText_AdmissionDate = new TextReadOnly();
			RightJText_AdmissionDate.setBounds(50, 17, 125, 20);
		}
		return RightJText_AdmissionDate;
	}

	/**
	 * This method initializes RightJLabel_Doctor
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_Doctor() {
		if (RightJLabel_Doctor == null) {
			RightJLabel_Doctor = new LabelSmallBase();
			RightJLabel_Doctor.setText("Dr.");
			RightJLabel_Doctor.setBounds(180, 17, 20, 20);
		}
		return RightJLabel_Doctor;
	}

	/**
	 * This method initializes RightJText_Doctor
	 *
	 * @return com.hkah.client.layout.label.TextReadOnly
	 */
	private TextReadOnly getRightJText_Doctor() {
		if (RightJText_Doctor == null) {
			RightJText_Doctor = new TextReadOnly();
			RightJText_Doctor.setBounds(200, 17, 43, 20);
		}
		return RightJText_Doctor;
	}

	/**
	 * This method initializes RightJText_DoctorName
	 *
	 * @return com.hkah.client.layout.label.TextReadOnly
	 */
	private TextReadOnly getRightJText_DoctorName() {
		if (RightJText_DoctorName == null) {
			RightJText_DoctorName = new TextReadOnly();
			RightJText_DoctorName.setBounds(245, 17, 120, 20);
		}
		return RightJText_DoctorName;
	}

	/**
	 * This method initializes RightJLabel_DischargeDate
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_DischargeDate() {
		if (RightJLabel_DischargeDate == null) {
			RightJLabel_DischargeDate = new LabelSmallBase();
			RightJLabel_DischargeDate.setText("Dischrge Dt");
			RightJLabel_DischargeDate.setBounds(366, 17, 85, 20);
		}
		return RightJLabel_DischargeDate;
	}

	/**
	 * This method initializes RightJText_DischargeDate
	 *
	 * @return com.hkah.client.layout.label.TextReadOnly
	 */
	private TextReadOnly getRightJText_DischargeDate() {
		if (RightJText_DischargeDate == null) {
			RightJText_DischargeDate = new TextReadOnly();
			RightJText_DischargeDate.setBounds(429, 17, 108, 20);
		}
		return RightJText_DischargeDate;
	}

	/**
	 * This method initializes RightJLabel_CategoryNo
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_CategoryNo() {
		if (RightJLabel_CategoryNo == null) {
			RightJLabel_CategoryNo = new LabelSmallBase();
			RightJLabel_CategoryNo.setText("Cat.");
			RightJLabel_CategoryNo.setBounds(540, 17, 20, 20);
		}
		return RightJLabel_CategoryNo;
	}

	/**
	 * This method initializes RightJCombo_CategoryNo
	 *
	 * @return com.hkah.client.layout.combobox.ComboCategory
	 */
	private ComboCategory getRightJCombo_CategoryNo() {
		if (RightJCombo_CategoryNo == null) {
			RightJCombo_CategoryNo = new ComboCategory();
			RightJCombo_CategoryNo.setBounds(562, 17, 25, 20);
		}
		return RightJCombo_CategoryNo;
	}

	/**
	 * This method initializes getRightJLabel_RefNo
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_RefNo() {
		if (RightJLabel_RefNo == null) {
			RightJLabel_RefNo = new LabelSmallBase();
			RightJLabel_RefNo.setText("Ref #");
			RightJLabel_RefNo.setBounds(624, 17, 50, 20);
		}
		return RightJLabel_RefNo;
	}

	/**
	 * This method initializes RightJText_CategoryName
	 *
	 * @return com.hkah.client.layout.textfield.TextBase
	 */
	private TextString getRightJText_CategoryName() {
		if (RightJText_CategoryName == null) {
			RightJText_CategoryName = new TextString();
			RightJText_CategoryName.setBounds(652, 17, 58, 20);
		}
		return RightJText_CategoryName;
	}

	public LabelSmallBase getRightJLabel_Source() {
		if (RightJLabel_Source == null) {
			RightJLabel_Source = new LabelSmallBase();
			RightJLabel_Source.setText("Src");
			RightJLabel_Source.setBounds(713, 17, 20, 20);
		}
		return RightJLabel_Source;
	}

	public ComboBoxBase getRightJCombo_Source() {
		if (RightJCombo_Source == null) {
			RightJCombo_Source = new ComboBoxBase("TRANSSRC", false, false, true);
			RightJCombo_Source.setBounds(735, 17, 65, 20);
			RightJCombo_Source.setMinListWidth(150);
		}
		return RightJCombo_Source;
	}

	/**
	 * This method initializes RightJLabel_ARCompanyCode
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_ARCompanyCode() {
		if (RightJLabel_ARCompanyCode == null) {
			RightJLabel_ARCompanyCode = new LabelSmallBase();
			RightJLabel_ARCompanyCode.setText("AR Company");
			RightJLabel_ARCompanyCode.setBounds(5, 39, 90, 20);
		}
		return RightJLabel_ARCompanyCode;
	}

	/**
	 * This method initializes RightJCombo_ARCompanyCode
	 *
	 * @return com.hkah.client.layout.combobox.ComboARCompany
	 */
	private void doARTabAction(boolean isShowPopUp) {
		dNCTRSDate = EMPTY_VALUE;
		dNCTREDate = EMPTY_VALUE;
		sNoContractMsg = EMPTY_VALUE;
		regDate = EMPTY_VALUE;
		newCpsId = EMPTY_VALUE;

		if (!getRightJCombo_ARCompanyCode().isEmpty()) {
			final String arccode = getRightJCombo_ARCompanyCode().getText().toUpperCase();
			if (getRightJCombo_ARCompanyCode().findModelByKey(arccode, true) == null) {
				getRightJCombo_ARCompanyCode().resetText();
				return;
			}

			QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.AR_COMPANY_TXCODE,
					new String[] { arccode },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success() && mQueue.getContentLineCount() > 0) {
						// get first return value and assign to district
						String[] outParam = mQueue.getContentField();
						getRightJCombo_ARCompanyCode().setText(outParam[0]);
						getRightJText_ARCompanyDesc().setText(outParam[1]);
						dNCTRSDate = outParam[12];
						if (dNCTRSDate != null && dNCTRSDate.length() > 10) {
							dNCTRSDate = dNCTRSDate.substring(0, 10);
						}
						dNCTREDate = outParam[13];
						if (dNCTREDate != null && dNCTREDate.length() > 10) {
							dNCTREDate = dNCTREDate.substring(0, 10);
						}
						regDate = getRightJText_AdmissionDate().getText();
						if (regDate != null && regDate.length() > 10) {
							regDate = regDate.substring(0, 10);
						}

						if (regDate != null && regDate.length() > 0 && DateTimeUtil.isDate(regDate) &&
								dNCTRSDate != null && dNCTRSDate.length() > 0 && DateTimeUtil.isDate(dNCTRSDate)) {
							if (dNCTREDate != null && dNCTREDate.length() > 0 && DateTimeUtil.isDate(dNCTREDate)) {
								if (DateTimeUtil.compareTo(regDate, dNCTRSDate) >= 0 && DateTimeUtil.compareTo(regDate, dNCTREDate) <= 0) {
									sNoContractMsg = "This AR has no contract during " + dNCTRSDate + " and " + dNCTREDate;
								}
							} else {
								if (DateTimeUtil.compareTo(regDate, dNCTRSDate) >= 0) {
									sNoContractMsg = "This AR has no contract since " + dNCTRSDate;
								}
							}
							if (sNoContractMsg != null && sNoContractMsg.length() > 0) {
								Factory.getInstance().addInformationMessage(sNoContractMsg, "AR Code");
							}
						}
						newCpsId = outParam[14];
					}
				}
			});

			if (!isShowPopUp ) {
				QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
						new String[] {"ARCARDTYPE", "COUNT(1)", "arccode = upper('" + arccode + "') and actactive = -1"},
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							if (!arccode.equals(memArcCode)) {
								memActID = ConstantsVariable.EMPTY_VALUE;
								getRightJText_ARCardType().resetText();
							}
							getDlgARCardTypeSel().showDialog(arccode, memActID);
						} else {
							memActID = ConstantsVariable.EMPTY_VALUE;
							getRightJText_ARCardType().resetText();
							getRightJText_PolicyNo().focus();
						}
					}
				});
			}

			String value[] = getRightJCombo_ARCompanyCode().getRawTextArray();
			if (value != null) {
				if (Factory.getInstance().getSysParameter("ArBlockEvt").length() > 0 &&
						(Factory.getInstance().getSysParameter("ArBlockEvt").equals(arccode) ||
						(memArcCode != null && Factory.getInstance().getSysParameter("ArBlockEvt").equals(memArcCode)))) {
					return;
				}

				getRightJText_LimitAmount().setText(value[6]);
				getRightJCombo_CoPayRefType().setText(value[5]);
				getRightJText_CoPayRefAmount().setText(value[8]);
				getRightJText_CvtEndDate().setText(value[7]);
				if (value[13]!=null && "0".equals(value[13])){
					try {
						// add 50 to handle rounding
						BigDecimal amount = (new BigDecimal(value[6]))
								.multiply(new BigDecimal(getSysParameter("FGAMTRATE")))
								.divide(new BigDecimal(100), BigDecimal.ROUND_HALF_EVEN);
						getRightJText_FGrtAmount().setText(String.valueOf(amount.intValue()));
					} catch (Exception e) {
						getRightJText_FGrtAmount().setText(ZERO_VALUE);
					}
				}else{
					getRightJText_FGrtAmount().setText(value[13]);
				}
				getRightJText_FGrtDate().setText(value[14]);
				getRightJCheckBox_CoverredItemDoctor().setSelected(YES_VALUE.equals(value[9]));
				getRightJCheckBox_CoverredItemHospital().setSelected(YES_VALUE.equals(value[10]));
				getRightJCheckBox_CoverredItemSpecial().setSelected(YES_VALUE.equals(value[11]));
				getRightJCheckBox_CoverredItemOther().setSelected(YES_VALUE.equals(value[12]));
			}
/*
			if (!ConstantsTransaction.SLIP_TYPE_INPATIENT.equals(slipType)) {
				if (Factory.getInstance().getSysParameter("ArBlockEvt").length() > 0 &&
						(Factory.getInstance().getSysParameter("ArBlockEvt").equals(arccode) ||
						(memArcCode != null && Factory.getInstance().getSysParameter("ArBlockEvt").equals(memArcCode)))) {
					return;
				}

				getRightJCombo_CoPayRefType().setText(ConstantsVariable.EMPTY_VALUE);
				getRightJText_LimitAmount().setText(ZERO_VALUE);
				getRightJText_FGrtAmount().setText(ZERO_VALUE);
				getRightJText_CvtEndDate().setText(ConstantsVariable.EMPTY_VALUE);
				getRightJText_FGrtDate().setText(ConstantsVariable.EMPTY_VALUE);
				getRightJText_CoPayRefAmount().setText(ZERO_VALUE);
				getRightJCheckBox_CoverredItemDoctor().setSelected(false);
				getRightJCheckBox_CoverredItemHospital().setSelected(false);
				getRightJCheckBox_CoverredItemSpecial().setSelected(false);
				getRightJCheckBox_CoverredItemOther().setSelected(false);
			}
*/
			allowArEntry(true);
		} else {
			if (Factory.getInstance().getSysParameter("ArBlockEvt").length() > 0) {
				if ((memArcCode != null && Factory.getInstance().getSysParameter("ArBlockEvt").equals(memArcCode)) ||
						getRightJCombo_ARCompanyCode().getText().length() == 0) {
					return;
				}
			}
			clearArEntry();
		}
	}

	private ComboARCompany getRightJCombo_ARCompanyCode() {
		if (RightJCombo_ARCompanyCode == null) {
			RightJCombo_ARCompanyCode = new ComboARCompany(true) {
				@Override
				protected String getTxFrom() {
					return "TxDetail";
				}

				@Override
				protected String getTxDate() {
					String checkDate = getRightJText_AdmissionDate().getText().trim();
					if (checkDate.length() == 0 && slpNo != null) {
						checkDate = DateTimeUtil.getRollDate("01/01/" + slpNo.substring(0, 4), Integer.parseInt(slpNo.substring(4, 7)) - 1);
					} else if (checkDate.length() > 0) {
						checkDate = checkDate.substring(0, 10);
					}
					return checkDate;
				}

				@Override
				public void onSearchTriggerClick(ComponentEvent ce) {
					RightJCombo_ARCompanyCode.getSearchArCode().showSearchPanel();
				}

				@Override
				protected void acceptPostAction() {
					doARTabAction(isShowPopUp);
				}


				@Override
				protected void onPressed(FieldEvent fe) {
					if (fe.getKeyCode() == KeyCodes.KEY_TAB) {
						doARTabAction(isShowPopUp);
/*						dNCTRSDate = EMPTY_VALUE;
						dNCTREDate = EMPTY_VALUE;
						sNoContractMsg = EMPTY_VALUE;
						regDate = EMPTY_VALUE;
						newCpsId = EMPTY_VALUE;

						if (!isEmpty()) {
							final String arccode = getText().toUpperCase();
							if (findModelByKey(arccode, true) == null) {
								resetText();
								return;
							}

							QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.AR_COMPANY_TXCODE,
									new String[] { arccode },
									new MessageQueueCallBack() {
								@Override
								public void onPostSuccess(MessageQueue mQueue) {
									if (mQueue.success() && mQueue.getContentLineCount() > 0) {
										// get first return value and assign to district
										String[] outParam = mQueue.getContentField();
										setText(outParam[0]);
										getRightJText_ARCompanyDesc().setText(outParam[1]);
										dNCTRSDate = outParam[12];
										if (dNCTRSDate != null && dNCTRSDate.length() > 10) {
											dNCTRSDate = dNCTRSDate.substring(0, 10);
										}
										dNCTREDate = outParam[13];
										if (dNCTREDate != null && dNCTREDate.length() > 10) {
											dNCTREDate = dNCTREDate.substring(0, 10);
										}
										regDate = getRightJText_AdmissionDate().getText();
										if (regDate != null && regDate.length() > 10) {
											regDate = regDate.substring(0, 10);
										}

										if (regDate != null && regDate.length() > 0 && DateTimeUtil.isDate(regDate) &&
												dNCTRSDate != null && dNCTRSDate.length() > 0 && DateTimeUtil.isDate(dNCTRSDate)) {
											if (dNCTREDate != null && dNCTREDate.length() > 0 && DateTimeUtil.isDate(dNCTREDate)) {
												if (DateTimeUtil.compareTo(regDate, dNCTRSDate) >= 0 && DateTimeUtil.compareTo(regDate, dNCTREDate) <= 0) {
													sNoContractMsg = "This AR has no contract during " + dNCTRSDate + " and " + dNCTREDate;
												}
											} else {
												if (DateTimeUtil.compareTo(regDate, dNCTRSDate) >= 0) {
													sNoContractMsg = "This AR has no contract since " + dNCTRSDate;
												}
											}
											if (sNoContractMsg != null && sNoContractMsg.length() > 0) {
												Factory.getInstance().addInformationMessage(sNoContractMsg, "AR Code");
											}
										}
										newCpsId = outParam[14];
									}
								}
							});

							if (!isShowPopUp) {
								QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
										new String[] {"ARCARDTYPE", "COUNT(1)", "arccode = upper('" + arccode + "') and actactive = -1"},
										new MessageQueueCallBack() {
									@Override
									public void onPostSuccess(MessageQueue mQueue) {
										if (mQueue.success()) {
											if (!arccode.equals(memArcCode)) {
												memActID = ConstantsVariable.EMPTY_VALUE;
												getRightJText_ARCardType().resetText();
											}
											getDlgARCardTypeSel().showDialog(arccode, memActID);
										} else {
											memActID = ConstantsVariable.EMPTY_VALUE;
											getRightJText_ARCardType().resetText();
											getRightJText_PolicyNo().focus();
										}
									}
								});
							}

							String value[] = getRawTextArray();
							if (value != null) {
								if (Factory.getInstance().getSysParameter("ArBlockEvt").length() > 0 &&
										(Factory.getInstance().getSysParameter("ArBlockEvt").equals(arccode) ||
										(memArcCode != null && Factory.getInstance().getSysParameter("ArBlockEvt").equals(memArcCode)))) {
									return;
								}

								getRightJText_LimitAmount().setText(value[6]);
								getRightJCombo_CoPayRefType().setText(value[5]);
								getRightJText_CoPayRefAmount().setText(value[8]);
								getRightJText_CvtEndDate().setText(value[7]);
								if (value[13]!=null && "0".equals(value[13])) {
									try {
										// add 50 to handle rounding
										BigDecimal amount = (new BigDecimal(value[6]))
												.multiply(new BigDecimal(getSysParameter("FGAMTRATE")))
												.divide(new BigDecimal(100), BigDecimal.ROUND_HALF_EVEN);
										getRightJText_FGrtAmount().setText(String.valueOf(amount.intValue()));
									} catch (Exception e) {
										getRightJText_FGrtAmount().setText(ZERO_VALUE);
									}
								}else{
									getRightJText_FGrtAmount().setText(value[13]);
								}
								getRightJText_FGrtDate().setText(value[14]);
								getRightJCheckBox_CoverredItemDoctor().setSelected(YES_VALUE.equals(value[9]));
								getRightJCheckBox_CoverredItemHospital().setSelected(YES_VALUE.equals(value[10]));
								getRightJCheckBox_CoverredItemSpecial().setSelected(YES_VALUE.equals(value[11]));
								getRightJCheckBox_CoverredItemOther().setSelected(YES_VALUE.equals(value[12]));
							}

							if (!ConstantsTransaction.SLIP_TYPE_INPATIENT.equals(slipType)) {
								if (Factory.getInstance().getSysParameter("ArBlockEvt").length() > 0 &&
										(Factory.getInstance().getSysParameter("ArBlockEvt").equals(arccode) ||
										(memArcCode != null && Factory.getInstance().getSysParameter("ArBlockEvt").equals(memArcCode)))) {
									return;
								}

								getRightJCombo_CoPayRefType().setText(ConstantsVariable.EMPTY_VALUE);
								getRightJText_LimitAmount().setText(ZERO_VALUE);
								getRightJText_FGrtAmount().setText(ZERO_VALUE);
								getRightJText_CvtEndDate().setText(ConstantsVariable.EMPTY_VALUE);
								getRightJText_FGrtDate().setText(ConstantsVariable.EMPTY_VALUE);
								getRightJText_CoPayRefAmount().setText(ZERO_VALUE);
								getRightJCheckBox_CoverredItemDoctor().setSelected(false);
								getRightJCheckBox_CoverredItemHospital().setSelected(false);
								getRightJCheckBox_CoverredItemSpecial().setSelected(false);
								getRightJCheckBox_CoverredItemOther().setSelected(false);
							}

							allowArEntry(true);
						} else {
							if (Factory.getInstance().getSysParameter("ArBlockEvt").length() > 0) {
								if ((memArcCode != null && Factory.getInstance().getSysParameter("ArBlockEvt").equals(memArcCode)) ||
										getText().length() == 0) {
									return;
								}
							}
							clearArEntry();
						}*/
					}
				}

				@Override
				public void clearPostAction() {
					if (Factory.getInstance().getSysParameter("ArBlockEvt").length() > 0) {
						if ((memArcCode != null && Factory.getInstance().getSysParameter("ArBlockEvt").equals(memArcCode))) {
							return;
						}
					}
					clearArEntry();
				}
			};
			RightJCombo_ARCompanyCode.setBounds(80, 39, 45, 20);
		}
		return RightJCombo_ARCompanyCode;
	}

	/**
	 * This method initializes RightJText_ARCompanyDesc
	 *
	 * @return com.hkah.client.layout.textfield.TextReadOnly
	 */
	private TextReadOnly getRightJText_ARCompanyDesc() {
		if (RightJText_ARCompanyDesc == null) {
			RightJText_ARCompanyDesc = new TextReadOnly();
			RightJText_ARCompanyDesc.setBounds(162, 39, 118, 20);
		}
		return RightJText_ARCompanyDesc;
	}

	/**
	 * This method initializes RightJText_ARCardType
	 *
	 * @return com.hkah.client.layout.textfield.TextReadOnly
	 */
	private TextReadOnly getRightJText_ARCardType() {
		if (RightJText_ARCardType == null) {
			RightJText_ARCardType = new TextReadOnly();
			RightJText_ARCardType.setBounds(282, 39, 143, 20);
		}
		return RightJText_ARCardType;
	}

	/**
	 * This method initializes RightJLabel_PolicyNo
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_PolicyNo() {
		if (RightJLabel_PolicyNo == null) {
			RightJLabel_PolicyNo = new LabelSmallBase();
			RightJLabel_PolicyNo.setText("Policy #");
			RightJLabel_PolicyNo.setBounds(433, 39, 50, 20);
		}
		return RightJLabel_PolicyNo;
	}

	/**
	 * This method initializes RightJText_PolicyNo
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_PolicyNo() {
		if (RightJText_PolicyNo == null) {
			RightJText_PolicyNo = new TextString(40);
			RightJText_PolicyNo.setBounds(478, 39, 110, 20);
		}
		return RightJText_PolicyNo;
	}

	/**
	 * This method initializes RightJLabel_VoucherNo
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_VoucherNo() {
		if (RightJLabel_VoucherNo == null) {
			RightJLabel_VoucherNo = new LabelSmallBase();
			RightJLabel_VoucherNo.setText("Vchr #");
			RightJLabel_VoucherNo.setBounds(595, 39, 55, 20);
		}
		return RightJLabel_VoucherNo;
	}

	/**
	 * This method initializes RightJText_VoucherNo
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_VoucherNo() {
		if (RightJText_VoucherNo == null) {
			RightJText_VoucherNo = new TextString(40);
			RightJText_VoucherNo.setBounds(635, 39, 55, 20);
		}
		return RightJText_VoucherNo;
	}

	/**
	 * This method initializes RightJLabel_PreAuthNo
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_PreAuthNo() {
		if (RightJLabel_PreAuthNo == null) {
			RightJLabel_PreAuthNo = new LabelSmallBase();
			RightJLabel_PreAuthNo.setText("Auth #");
			RightJLabel_PreAuthNo.setBounds(695, 39, 50, 20);
		}
		return RightJLabel_PreAuthNo;
	}

	/**
	 * This method initializes RightJText_PreAuthNo
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_PreAuthNo() {
		if (RightJText_PreAuthNo == null) {
			RightJText_PreAuthNo = new TextString(20);
			RightJText_PreAuthNo.setBounds(735, 39, 65, 20);
		}
		return RightJText_PreAuthNo;
	}

	private LabelSmallBase getINJLabel_PrtMedRecordRpt() {
		if (INJLabel_PrtMedRecordRpt == null) {
			INJLabel_PrtMedRecordRpt = new LabelSmallBase();
			INJLabel_PrtMedRecordRpt.setText("Prt MR");
			INJLabel_PrtMedRecordRpt.setBounds(655, 39, 50, 20);
			INJLabel_PrtMedRecordRpt.setVisible(false);
		}
		return INJLabel_PrtMedRecordRpt;
	}

	/**
	 * This method initializes INJCheckBox_PrtMedRecordRpt
	 *
	 * @return com.hkah.client.layout.button.CheckBoxBase
	 */
	private CheckBoxBase getINJCheckBox_PrtMedRecordRpt() {
		if (INJCheckBox_PrtMedRecordRpt == null) {
			INJCheckBox_PrtMedRecordRpt = new CheckBoxBase();
			INJCheckBox_PrtMedRecordRpt.setBounds(689, 39, 20, 20);
			INJCheckBox_PrtMedRecordRpt.setVisible(false);
		}
		return INJCheckBox_PrtMedRecordRpt;
	}

	/**
	 * This method initializes RightJLabel_SourceNo
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_SourceNo() {
		if (RightJLabel_SourceNo == null) {
			RightJLabel_SourceNo = new LabelSmallBase();
			RightJLabel_SourceNo.setText("Src #");
			RightJLabel_SourceNo.setBounds(708, 39, 60, 20);
			RightJLabel_SourceNo.setVisible(false);
		}
		return RightJLabel_SourceNo;
	}

	/**
	 * This method initializes RightJCheckBox_MAllocate
	 *
	 * @return com.hkah.client.layout.button.CheckBoxBase
	 */
	private TextString getRightJText_SourceNo() {
		if (RightJText_SourceNo == null) {
			RightJText_SourceNo = new TextString(20);
			RightJText_SourceNo.setBounds(735, 39, 65, 20);
			RightJText_SourceNo.setVisible(false);
		}
		return RightJText_SourceNo;
	}

	/**
	 * This method initializes RightJLabel_LimitAmount
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_LimitAmount() {
		if (RightJLabel_LimitAmount == null) {
			RightJLabel_LimitAmount = new LabelSmallBase();
			RightJLabel_LimitAmount.setText("Limit Amt.");
			RightJLabel_LimitAmount.setBounds(5, 61, 60, 20);
		}
		return RightJLabel_LimitAmount;
	}

	/**
	 * This method initializes RightJText_LimitAmount
	 *
	 * @return com.hkah.client.layout.label.TextReadOnly
	 */
	private TextAmount getRightJText_LimitAmount() {
		if (RightJText_LimitAmount == null) {
			RightJText_LimitAmount = new TextAmount() {
				public void onBlur() {
					if (!RightJText_LimitAmount.isEmpty()) {
						if (!TextUtil.isInteger(RightJText_LimitAmount.getText().toString())) {
							Factory.getInstance().addErrorMessage("Please enter a integer Limit Amount.", RightJText_LimitAmount);
							RightJText_LimitAmount.setText(ZERO_VALUE);
							return;
						}

						try {
							// add 50 to handle rounding
							BigDecimal amount = (new BigDecimal(RightJText_LimitAmount.getText()))
									.multiply(new BigDecimal(getSysParameter("FGAMTRATE")))
									.divide(new BigDecimal(100), BigDecimal.ROUND_HALF_EVEN);
							getRightJText_FGrtAmount().setText(String.valueOf(amount.intValue()));
						} catch (Exception e) {
							getRightJText_FGrtAmount().setText(ZERO_VALUE);
						}
					}
				}
			};
			RightJText_LimitAmount.setBounds(56, 61, 55, 20);
		}
		return RightJText_LimitAmount;
	}

	/**
	 * This method initializes RightJLabel_CoPayRefNo
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_CoPayRefNo() {
		if (RightJLabel_CoPayRefNo == null) {
			RightJLabel_CoPayRefNo = new LabelSmallBase();
			RightJLabel_CoPayRefNo.setText("Co-Pay");
			RightJLabel_CoPayRefNo.setBounds(118, 61, 75, 20);
		}
		return RightJLabel_CoPayRefNo;
	}

	/**
	 * This method initializes RightJCombo_CoPayRefType
	 *
	 * @return com.hkah.client.layout.combobox.ComboCoPayRefType
	 */
	private ComboCoPayRefType getRightJCombo_CoPayRefType() {
		if (RightJCombo_CoPayRefType == null) {
			RightJCombo_CoPayRefType = new ComboCoPayRefType();
			RightJCombo_CoPayRefType.setBounds(158, 61, 30, 20);
		}
		return RightJCombo_CoPayRefType;
	}

	/**
	 * This method initializes RightJText_CoPayRefAmount
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_CoPayRefAmount() {
		if (RightJText_CoPayRefAmount == null) {
			RightJText_CoPayRefAmount = new TextString();
			RightJText_CoPayRefAmount.setBounds(220, 61, 51, 20);
		}
		return RightJText_CoPayRefAmount;
	}

	/**
	 * This method initializes RightJLabel_CoPayActualNo
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_CoPayActualNo() {
		if (RightJLabel_CoPayActualNo == null) {
			RightJLabel_CoPayActualNo = new LabelSmallBase();
			RightJLabel_CoPayActualNo.setText("Deductible");
			RightJLabel_CoPayActualNo.setBounds(276, 61, 90, 20);
		}
		return RightJLabel_CoPayActualNo;
	}

	/**
	 * This method initializes RightJText_CoPayActualAmount
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_CoPayActualAmount() {
		if (RightJText_CoPayActualAmount == null) {
			RightJText_CoPayActualAmount = new TextString();
			RightJText_CoPayActualAmount.setBounds(333, 61, 51, 20);
		}
		return RightJText_CoPayActualAmount;
	}

	/**
	 * This method initializes RightJLabel_CvtEndDate
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_CvtEndDate() {
		if (RightJLabel_CvtEndDate == null) {
			RightJLabel_CvtEndDate = new LabelSmallBase();
			RightJLabel_CvtEndDate.setText("Cvr.End Dt");
			RightJLabel_CvtEndDate.setBounds(388, 61, 80, 20);
		}
		return RightJLabel_CvtEndDate;
	}

	/**
	 * This method initializes RightJText_CvtEndDate
	 *
	 * @return com.hkah.client.layout.textfield.TextDate
	 */
	private TextDate getRightJText_CvtEndDate() {
		if (RightJText_CvtEndDate == null) {
			RightJText_CvtEndDate = new TextDate() {
				@Override
				public void onBlur() {
					if (!RightJText_CvtEndDate.isEmpty()) {
						if (!RightJText_CvtEndDate.isValid()) {
							Factory.getInstance().addErrorMessage("The End Date is Invalid.", RightJText_CvtEndDate);
							RightJText_CvtEndDate.resetText();
							return;
						}

						String sFurGrtDate = "";
						String preDays = getSysParameter("FGPREDAYS");

						if (!RightJText_CvtEndDate.isEmpty() &&
								RightJText_CvtEndDate.isValid() &&
								!"NULL".equals(preDays) &&
								!"EMPTY".equals(preDays) &&
								!"NIL".equals(preDays)) {
							try {
								sFurGrtDate = DateTimeUtil.getRollDate(RightJText_CvtEndDate.getText(), Integer.parseInt(preDays) * -1);
							} catch (Exception e) {}
						}
						getRightJText_FGrtDate().setText(sFurGrtDate);
					}
				}
			};
			RightJText_CvtEndDate.setBounds(450, 61, 90, 20);
		}
		return RightJText_CvtEndDate;
	}

	/**
	 * This method initializes RightJLabel_FGrtAmount
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_FGrtAmount() {
		if (RightJLabel_FGrtAmount == null) {
			RightJLabel_FGrtAmount = new LabelSmallBase();
			RightJLabel_FGrtAmount.setText("F.Grt.Amt.");
			RightJLabel_FGrtAmount.setBounds(545, 61, 70, 20);
		}
		return RightJLabel_FGrtAmount;
	}

	/**
	 * This method initializes RightJText_FGrtAmount
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextAmount getRightJText_FGrtAmount() {
		if (RightJText_FGrtAmount == null) {
			RightJText_FGrtAmount = new TextAmount();
			RightJText_FGrtAmount.setBounds(600, 61, 55, 20);
		}
		return RightJText_FGrtAmount;
	}

	/**
	 * This method initializes RightJLabel_FGrtDate
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_FGrtDate() {
		if (RightJLabel_FGrtDate == null) {
			RightJLabel_FGrtDate = new LabelSmallBase();
			RightJLabel_FGrtDate.setText("F.Grt.Dt");
			RightJLabel_FGrtDate.setBounds(662, 61, 70, 20);
		}
		return RightJLabel_FGrtDate;
	}

	/**
	 * This method initializes RightJText_FGrtDate
	 *
	 * @return com.hkah.client.layout.field.TextDate
	 */
	private TextDate getRightJText_FGrtDate() {
		if (RightJText_FGrtDate == null) {
			RightJText_FGrtDate = new TextDate();
			RightJText_FGrtDate.setBounds(710, 61, 90, 20);
		}
		return RightJText_FGrtDate;
	}

	public LabelSmallBase getPJLabel_RevLog() {
		if (PJLabel_RevLog == null) {
			PJLabel_RevLog = new LabelSmallBase();
			PJLabel_RevLog.setText("Rec'd LOG");
			PJLabel_RevLog.setBounds(5, 83, 65, 13);
			PJLabel_RevLog.setVisible(false);
		}
		return PJLabel_RevLog;
	}

	public CheckBoxBase getPJCheckBox_Revlog() {
		if (PJCheckBox_RevLog == null) {
			PJCheckBox_RevLog = new CheckBoxBase();
			PJCheckBox_RevLog.setBounds(62, 83, 20, 20);
			PJCheckBox_RevLog.setVisible(false);
		}
		return PJCheckBox_RevLog;
	}

	private LabelSmallBase getRightJLabel_LogCvrCls() {
		if (RightJLabel_LogCvrCls == null) {
			RightJLabel_LogCvrCls = new LabelSmallBase();
			RightJLabel_LogCvrCls.setText("LOG Cover Class");
			RightJLabel_LogCvrCls.setBounds(98, 83, 100, 20);
			RightJLabel_LogCvrCls.setVisible(false);
		}
		return RightJLabel_LogCvrCls;
	}

	private ComboACMCode getRightJCombo_LogCvrCls() {
		if (RightJCombo_LogCvrCls == null) {
			RightJCombo_LogCvrCls = new ComboACMCode();
			RightJCombo_LogCvrCls.setBounds(194, 83, 100, 18);
			RightJCombo_LogCvrCls.setVisible(false);
		}
		return RightJCombo_LogCvrCls;
	}

	private LabelSmallBase getPJLabel_EstGiven() {
		if (PJLabel_EstGiven == null) {
			PJLabel_EstGiven = new LabelSmallBase();
			PJLabel_EstGiven.setText("Est. Given");
			PJLabel_EstGiven.setBounds(339, 83, 60, 13);
			PJLabel_EstGiven.setVisible(false);

		}
		return PJLabel_EstGiven;
	}

	private CheckBoxBase getPJCheckBox_EstGiven() {
		if (PJCheckBox_EstGiven == null) {
			PJCheckBox_EstGiven = new CheckBoxBase();
			PJCheckBox_EstGiven.setBounds(391, 83, 20, 20);
			PJCheckBox_EstGiven.setVisible(false);
		}
		return PJCheckBox_EstGiven;
	}

	protected LabelSmallBase getPJCheckBox_BEDesc() {
		if (PJCheckBox_BEDesc == null) {
			PJCheckBox_BEDesc = new LabelSmallBase();
			PJCheckBox_BEDesc.setText("*BE");
			PJCheckBox_BEDesc.setBounds(415, 83, 20, 20);
			PJCheckBox_BEDesc.setVisible(false);
		}
		return PJCheckBox_BEDesc;
	}

	protected CheckBoxBase getPJCheckBox_BE() {
		if (PJCheckBox_BE == null) {
			PJCheckBox_BE = new CheckBoxBase();
			PJCheckBox_BE.setBounds(435, 83, 20, 20);
			PJCheckBox_BE.setVisible(false);
			PJCheckBox_BE.setEditable(false);
		}
		return PJCheckBox_BE;
	}

	/**
	 * This method initializes RightButton_Remarks
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private ButtonBase getRightButton_Remarks() {
		if (RightButton_Remarks == null) {
			RightButton_Remarks = new ButtonBase() {
				@Override
				public void onClick() {
					getDlgSlipRemark().showDialog(slpNo);
				}
			};
			RightButton_Remarks.setText("Slip Remark");
			RightButton_Remarks.setBounds(5, 83, 80, 22);
		}
		return RightButton_Remarks;
	}

	/**
	 * This method initializes RightJText_Remarks
	 *
	 * @return com.hkah.client.layout.textfield.TextBase
	 */
	private TextString getRightJText_Remarks() {
		if (RightJText_Remarks == null) {
			RightJText_Remarks = new TextString(200, false);
			RightJText_Remarks.setBounds(90, 83, 295, 20);
		}
		return RightJText_Remarks;
	}

	/**
	 * This method initializes RightJLabel_Complex
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_Complex() {
		if (RightJLabel_Complex == null) {
			RightJLabel_Complex = new LabelSmallBase();
			RightJLabel_Complex.setText("Complex");
			RightJLabel_Complex.setBounds(390, 83, 100, 20);
		}
		return RightJLabel_Complex;
	}

	/**
	 * This method initializes RightJCheckBox_Complex
	 *
	 * @return com.hkah.client.layout.button.CheckBoxBase
	 */
	private CheckBoxBase getRightJCheckBox_Complex() {
		if (RightJCheckBox_Complex == null) {
			RightJCheckBox_Complex = new CheckBoxBase();
			RightJCheckBox_Complex.setBounds(440, 83, 20, 20);
		}
		return RightJCheckBox_Complex;
	}

	/**
	 * This method initializes coveredItemPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	public BasePanel getCoveredItemPanel() {
		if (coveredItemPanel == null) {
			coveredItemPanel = new BasePanel();
			coveredItemPanel.setEtchedBorder();
			coveredItemPanel.setBounds(460, 83, 340, 22);
			coveredItemPanel.add(getRightJLabel_CoverredItem(), null);
			coveredItemPanel.add(getRightJLabel_CoverredItemDoctor(), null);
			coveredItemPanel.add(getRightJCheckBox_CoverredItemDoctor(), null);
			coveredItemPanel.add(getRightJLabel_CoverredItemHospital(), null);
			coveredItemPanel.add(getRightJCheckBox_CoverredItemHospital(), null);
			coveredItemPanel.add(getRightJLabel_CoverredItemSpecial(), null);
			coveredItemPanel.add(getRightJCheckBox_CoverredItemSpecial(), null);
			coveredItemPanel.add(getRightJLabel_CoverredItemOther(), null);
			coveredItemPanel.add(getRightJCheckBox_CoverredItemOther(), null);
		}
		return coveredItemPanel;
	}

	/**
	 * This method initializes RightJLabel_CoverredItem
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_CoverredItem() {
		if (RightJLabel_CoverredItem == null) {
			RightJLabel_CoverredItem = new LabelSmallBase();
			RightJLabel_CoverredItem.setText("Cvr. Item");
			RightJLabel_CoverredItem.setBounds(5, 1, 80, 20);
		}
		return RightJLabel_CoverredItem;
	}

	/**
	 * This method initializes RightJLabel_CoverredItemDoctor
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_CoverredItemDoctor() {
		if (RightJLabel_CoverredItemDoctor == null) {
			RightJLabel_CoverredItemDoctor = new LabelSmallBase();
			RightJLabel_CoverredItemDoctor.setText("Doctor");
			RightJLabel_CoverredItemDoctor.setBounds(83, 1, 40, 20);
		}
		return RightJLabel_CoverredItemDoctor;
	}

	/**
	 * This method initializes RightJCheckBox_CoverredItemDoctor
	 *
	 * @return com.hkah.client.layout.button.CheckBoxBase
	 */
	private CheckBoxBase getRightJCheckBox_CoverredItemDoctor() {
		if (RightJCheckBox_CoverredItemDoctor == null) {
			RightJCheckBox_CoverredItemDoctor = new CheckBoxBase();
			RightJCheckBox_CoverredItemDoctor.setBounds(115, 1, 20, 20);
		}
		return RightJCheckBox_CoverredItemDoctor;
	}

	/**
	 * This method initializes RightJLabel_CoverredItemHospital
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_CoverredItemHospital() {
		if (RightJLabel_CoverredItemHospital == null) {
			RightJLabel_CoverredItemHospital = new LabelSmallBase();
			RightJLabel_CoverredItemHospital.setText("Hospital");
			RightJLabel_CoverredItemHospital.setBounds(146, 1, 50, 20);
		}
		return RightJLabel_CoverredItemHospital;
	}

	/**
	 * This method initializes RightJCheckBox_CoverredItemHospital
	 *
	 * @return com.hkah.client.layout.button.CheckBoxBase
	 */
	private CheckBoxBase getRightJCheckBox_CoverredItemHospital() {
		if (RightJCheckBox_CoverredItemHospital == null) {
			RightJCheckBox_CoverredItemHospital = new CheckBoxBase();
			RightJCheckBox_CoverredItemHospital.setBounds(187, 1, 20, 20);
		}
		return RightJCheckBox_CoverredItemHospital;
	}

	/**
	 * This method initializes RightJLabel_CoverredItemSpecial
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_CoverredItemSpecial() {
		if (RightJLabel_CoverredItemSpecial == null) {
			RightJLabel_CoverredItemSpecial = new LabelSmallBase();
			RightJLabel_CoverredItemSpecial.setText("Special");
			RightJLabel_CoverredItemSpecial.setBounds(220, 1, 40, 20);
		}
		return RightJLabel_CoverredItemSpecial;
	}

	/**
	 * This method initializes RightJCheckBox_CoverredItemSpecial
	 *
	 * @return com.hkah.client.layout.button.CheckBoxBase
	 */
	private CheckBoxBase getRightJCheckBox_CoverredItemSpecial() {
		if (RightJCheckBox_CoverredItemSpecial == null) {
			RightJCheckBox_CoverredItemSpecial = new CheckBoxBase();
			RightJCheckBox_CoverredItemSpecial.setBounds(257, 1, 20, 20);
		}
		return RightJCheckBox_CoverredItemSpecial;
	}

	/**
	 * This method initializes RightJLabel_CoverredItemOther
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_CoverredItemOther() {
		if (RightJLabel_CoverredItemOther == null) {
			RightJLabel_CoverredItemOther = new LabelSmallBase();
			RightJLabel_CoverredItemOther.setText("Other");
			RightJLabel_CoverredItemOther.setBounds(288, 1, 40, 20);
		}
		return RightJLabel_CoverredItemOther;
	}

	/**
	 * This method initializes RightJCheckBox_CoverredItemOther
	 *
	 * @return com.hkah.client.layout.button.CheckBoxBase
	 */
	private CheckBoxBase getRightJCheckBox_CoverredItemOther() {
		if (RightJCheckBox_CoverredItemOther == null) {
			RightJCheckBox_CoverredItemOther = new CheckBoxBase();
			RightJCheckBox_CoverredItemOther.setBounds(316, 1, 20, 20);
		}
		return RightJCheckBox_CoverredItemOther;
	}

	private LabelSmallBase getRightJLabel_Package() {
		if (RightJLabel_Package == null) {
			RightJLabel_Package = new LabelSmallBase();
			RightJLabel_Package.setText("Pkg");
			RightJLabel_Package.setBounds(457, 105, 20, 20);
			RightJLabel_Package.setVisible(false);
		}
		return RightJLabel_Package;
	}

	private ComboBoxBase getRightJCombo_Package() {
		if (RightJCombo_Package == null) {
			RightJCombo_Package = new ComboBoxBase("BPBPKG", false, false, true);
			RightJCombo_Package.setBounds(482, 105, 120, 20);
			RightJCombo_Package.setMinListWidth(160);
			RightJCombo_Package.setVisible(false);

		}
		return RightJCombo_Package;
	}

	private LabelSmallBase getRightJLabel_NoSign() {
		if (RightJLabel_NoSign == null) {
			RightJLabel_NoSign = new LabelSmallBase();
			RightJLabel_NoSign.setText("No Signature");
			RightJLabel_NoSign.setBounds(610, 105, 80, 20);
			RightJLabel_NoSign.setVisible(false);
		}
		return RightJLabel_NoSign;
	}

	private ComboBoxBase getRightJCombo_NoSign() {
		if (RightJCombo_NoSign == null) {
			RightJCombo_NoSign = new ComboBoxBase("TXNNOSIGN", false, true, true);
			RightJCombo_NoSign.setBounds(680, 105, 80, 20);
			RightJCombo_NoSign.setMinListWidth(120);
			RightJCombo_NoSign.setVisible(false);

		}
		return RightJCombo_NoSign;
	}

	/**
	 * This method initializes totalPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	public BasePanel getTotalPanel() {
		if (totalPanel == null) {
			totalPanel = new BasePanel();
			totalPanel.setEtchedBorder();
			totalPanel.setBounds(5, 134, 665, 60);
			totalPanel.add(getRightJLabel_TotalCharges(), null);
			totalPanel.add(getRightJText_TotalCharges(), null);
			totalPanel.add(getRightJLabel_TotalPayment(), null);
			totalPanel.add(getRightJText_TotalPayment(), null);
			totalPanel.add(getRightJLabel_TotalCredit(), null);
			totalPanel.add(getRightJText_TotalCredit(), null);
			totalPanel.add(getRightJLabel_Balance(), null);
			totalPanel.add(getRightJText_Balance(), null);
			totalPanel.add(getRightJLabel_TotalHospitalCharges(), null);
			totalPanel.add(getRightJText_TotalHospitalCharges(), null);
			totalPanel.add(getRightJLabel_TotalDoctorCharges(), null);
			totalPanel.add(getRightJText_TotalDoctorCharges(), null);
			totalPanel.add(getRightJLabel_TotalSpecialCharges(), null);
			totalPanel.add(getRightJText_TotalSpecialCharges(), null);
			totalPanel.add(getRightJLabel_TotalRefund(), null);
			totalPanel.add(getRightJText_TotalRefund(), null);
		}
		return totalPanel;
	}

	/**
	 * This method initializes RightJLabel_TotalCharges
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_TotalCharges() {
		if (RightJLabel_TotalCharges == null) {
			RightJLabel_TotalCharges = new LabelSmallBase();
			RightJLabel_TotalCharges.setText("Total Charges");
			RightJLabel_TotalCharges.setBounds(5, 5, 90, 20);
		}
		return RightJLabel_TotalCharges;
	}

	/**
	 * This method initializes RightJText_TotalCharges
	 *
	 * @return com.hkah.client.layout.label.TextReadOnly
	 */
	private TextReadOnlyAmount getRightJText_TotalCharges() {
		if (RightJText_TotalCharges == null) {
			RightJText_TotalCharges = new TextReadOnlyAmount();
			RightJText_TotalCharges.setBounds(87, 5, 65, 20);
		}
		return RightJText_TotalCharges;
	}

	/**
	 * This method initializes RightJLabel_TotalPayment
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_TotalPayment() {
		if (RightJLabel_TotalPayment == null) {
			RightJLabel_TotalPayment = new LabelSmallBase();
			RightJLabel_TotalPayment.setText("Total Payment");
			RightJLabel_TotalPayment.setBounds(173, 5, 90, 20);
		}
		return RightJLabel_TotalPayment;
	}

	/**
	 * This method initializes RightJText_TotalPayment
	 *
	 * @return com.hkah.client.layout.label.TextReadOnly
	 */
	private TextReadOnlyAmount getRightJText_TotalPayment() {
		if (RightJText_TotalPayment == null) {
			RightJText_TotalPayment = new TextReadOnlyAmount();
			RightJText_TotalPayment.setBounds(253, 5, 65, 20);
		}
		return RightJText_TotalPayment;
	}

	/**
	 * This method initializes RightJLabel_TotalCredit
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_TotalCredit() {
		if (RightJLabel_TotalCredit == null) {
			RightJLabel_TotalCredit = new LabelSmallBase();
			RightJLabel_TotalCredit.setText("Total Credit");
			RightJLabel_TotalCredit.setBounds(340, 5, 90, 20);
		}
		return RightJLabel_TotalCredit;
	}

	/**
	 * This method initializes RightJText_TotalCredit
	 *
	 * @return com.hkah.client.layout.label.TextReadOnly
	 */
	private TextReadOnlyAmount getRightJText_TotalCredit() {
		if (RightJText_TotalCredit == null) {
			RightJText_TotalCredit = new TextReadOnlyAmount();
			RightJText_TotalCredit.setBounds(421, 5, 65, 20);
		}
		return RightJText_TotalCredit;
	}

	/**
	 * This method initializes RightJLabel_Balance
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_Balance() {
		if (RightJLabel_Balance == null) {
			RightJLabel_Balance = new LabelSmallBase();
			RightJLabel_Balance.setText("Balance");
			RightJLabel_Balance.setBounds(507, 5, 90, 20);
		}
		return RightJLabel_Balance;
	}

	/**
	 * This method initializes RightJText_Balance
	 *
	 * @return com.hkah.client.layout.label.TextReadOnly
	 */
	private TextReadOnlyAmount getRightJText_Balance() {
		if (RightJText_Balance == null) {
			RightJText_Balance = new TextReadOnlyAmount();
			RightJText_Balance.setBounds(588, 5, 65, 20);
			RightJText_Balance.addListener(Events.Change, new Listener<FieldEvent>() {
				public void handleEvent(FieldEvent be) {
					int balance = 0;
					try {
						balance = Integer.valueOf(getRightJText_Balance().getText().trim()).intValue();
					} catch(Exception e) {}

					getRightButton_AddCItemPer().setEnabled(balance > 0 && !isDisableFunction("btnAddCItemPer", "txnDetails"));
				}
			});
		}
		return RightJText_Balance;
	}

	/**
	 * This method initializes RightJLabel_TotalHospitalCharges
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_TotalHospitalCharges() {
		if (RightJLabel_TotalHospitalCharges == null) {
			RightJLabel_TotalHospitalCharges = new LabelSmallBase();
			RightJLabel_TotalHospitalCharges.setText("Total Hospital Charges");
			RightJLabel_TotalHospitalCharges.setBounds(5, 25, 90, 20);
		}
		return RightJLabel_TotalHospitalCharges;
	}

	/**
	 * This method initializes RightJText_TotalHospitalCharges
	 *
	 * @return com.hkah.client.layout.label.TextReadOnly
	 */
	private TextReadOnlyAmount getRightJText_TotalHospitalCharges() {
		if (RightJText_TotalHospitalCharges == null) {
			RightJText_TotalHospitalCharges = new TextReadOnlyAmount();
			RightJText_TotalHospitalCharges.setBounds(87, 30, 65, 20);
		}
		return RightJText_TotalHospitalCharges;
	}

	/**
	 * This method initializes RightJLabel_TotalDoctorCharges
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_TotalDoctorCharges() {
		if (RightJLabel_TotalDoctorCharges == null) {
			RightJLabel_TotalDoctorCharges = new LabelSmallBase();
			RightJLabel_TotalDoctorCharges.setText("Total Doctor Charges");
			RightJLabel_TotalDoctorCharges.setBounds(173, 25, 90, 20);
		}
		return RightJLabel_TotalDoctorCharges;
	}

	/**
	 * This method initializes RightJText_TotalDoctorCharges
	 *
	 * @return com.hkah.client.layout.label.TextReadOnly
	 */
	private TextReadOnlyAmount getRightJText_TotalDoctorCharges() {
		if (RightJText_TotalDoctorCharges == null) {
			RightJText_TotalDoctorCharges = new TextReadOnlyAmount();
			RightJText_TotalDoctorCharges.setBounds(253, 30, 65, 20);
		}
		return RightJText_TotalDoctorCharges;
	}

	/**
	 * This method initializes RightJLabel_TotalSpecialCharges
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_TotalSpecialCharges() {
		if (RightJLabel_TotalSpecialCharges == null) {
			RightJLabel_TotalSpecialCharges = new LabelSmallBase();
			RightJLabel_TotalSpecialCharges.setText("Total Special Charges");
			RightJLabel_TotalSpecialCharges.setBounds(340, 25, 90, 20);
		}
		return RightJLabel_TotalSpecialCharges;
	}

	/**
	 * This method initializes RightJText_TotalSpecialCharges
	 *
	 * @return com.hkah.client.layout.label.TextReadOnly
	 */
	private TextReadOnlyAmount getRightJText_TotalSpecialCharges() {
		if (RightJText_TotalSpecialCharges == null) {
			RightJText_TotalSpecialCharges = new TextReadOnlyAmount();
			RightJText_TotalSpecialCharges.setBounds(421, 30, 65, 20);
		}
		return RightJText_TotalSpecialCharges;
	}

	/**
	 * This method initializes RightJLabel_TotalRefund
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_TotalRefund() {
		if (RightJLabel_TotalRefund == null) {
			RightJLabel_TotalRefund = new LabelSmallBase();
			RightJLabel_TotalRefund.setText("Total Refund");
			RightJLabel_TotalRefund.setBounds(507, 30, 90, 20);
		}
		return RightJLabel_TotalRefund;
	}

	/**
	 * This method initializes RightJText_TotalRefund
	 *
	 * @return com.hkah.client.layout.label.TextReadOnly
	 */
	private TextReadOnlyAmount getRightJText_TotalRefund() {
		if (RightJText_TotalRefund == null) {
			RightJText_TotalRefund = new TextReadOnlyAmount();
			RightJText_TotalRefund.setBounds(588, 30, 65, 20);
		}
		return RightJText_TotalRefund;
	}

	/**
	 * This method initializes RightJLabel_RoomPhone
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_RoomPhone() {
		if (RightJLabel_RoomPhone == null) {
			RightJLabel_RoomPhone = new LabelSmallBase();
			RightJLabel_RoomPhone.setText("Rm Ext");
			RightJLabel_RoomPhone.setBounds(680, 137, 80, 20);
		}
		return RightJLabel_RoomPhone;
	}

	/**
	 * This method initializes RightJText_RoomPhone
	 *
	 * @return com.hkah.client.layout.label.TextReadOnly
	 */
	private TextReadOnly getRightJText_RoomPhone() {
		if (RightJText_RoomPhone == null) {
			RightJText_RoomPhone = new TextReadOnly();
			RightJText_RoomPhone.setBounds(750, 137, 60, 20);
		}
		return RightJText_RoomPhone;
	}

	/**
	 * This method initializes getRightJText_OT
	 *
	 * @return ButtonBase
	 */
	private ButtonBase getRightJText_OT() {
		if (RightJText_OT == null) {
			RightJText_OT = new ButtonBase() {
				@Override
				public void onClick() {
					getDlgTransOT().showDialog(slpNo);
				}
			};
			RightJText_OT.setText("OT");
			RightJText_OT.setBounds(678, 160, 30, 22);
		}
		return RightJText_OT;
	}

	/**
	 * This method initializes RightJLabel_OTCount
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_OTCount() {
		if (RightJLabel_OTCount == null) {
			RightJLabel_OTCount = new LabelSmallBase();
			RightJLabel_OTCount.setText("Count");
			RightJLabel_OTCount.setBounds(710, 160, 40, 20);
		}
		return RightJLabel_OTCount;
	}

	/**
	 * This method initializes RightJText_OTCount
	 *
	 * @return com.hkah.client.layout.textfield.TextReadOnly
	 */
	private TextReadOnly getRightJText_OTCount() {
		if (RightJText_OTCount == null) {
			RightJText_OTCount = new TextReadOnly();
			RightJText_OTCount.setBounds(750, 160, 60, 20);
		}
		return RightJText_OTCount;
	}

	private FieldSetBase getDiscountPanel() {
		if (discountPanel == null) {
			discountPanel = new FieldSetBase();
			discountPanel.setHeading("Discount (%)");
			discountPanel.setBounds(5, 189, 495, 42);
			discountPanel.add(getRightJLabel_HospitalDiscount(), null);
			discountPanel.add(getRightJText_HospitalDiscount(), null);
			discountPanel.add(getRightJLabel_HospitalDiscountSuffix(), null);
			discountPanel.add(getRightJLabel_DoctorDiscount(), null);
			discountPanel.add(getRightJText_DoctorDiscount(), null);
			discountPanel.add(getRightJLabel_DoctorDiscountSuffix(), null);
			discountPanel.add(getRightJLabel_SpecialDiscount(), null);
			discountPanel.add(getRightJText_SpecialDiscount(), null);
			discountPanel.add(getRightJLabel_SpecialDiscountSuffix(), null);
		}
		return discountPanel;
	}

	/**
	 * This method initializes RightJLabel_HospitalDiscount
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_HospitalDiscount() {
		if (RightJLabel_HospitalDiscount == null) {
			RightJLabel_HospitalDiscount = new LabelSmallBase();
			RightJLabel_HospitalDiscount.setText("Hosp. Disc.");
			RightJLabel_HospitalDiscount.setBounds(5, -5, 80, 20);
		}
		return RightJLabel_HospitalDiscount;
	}

	/**
	 * This method initializes RightJText_HospitalDiscount
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextAmount getRightJText_HospitalDiscount() {
		if (RightJText_HospitalDiscount == null) {
			RightJText_HospitalDiscount = new TextAmount(3);
			RightJText_HospitalDiscount.setBounds(70, -5, 50, 20);
		}
		return RightJText_HospitalDiscount;
	}

	/**
	 * This method initializes RightJLabel_HospitalSuffix
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_HospitalDiscountSuffix() {
		if (RightJLabel_HospitalDiscountSuffix == null) {
			RightJLabel_HospitalDiscountSuffix = new LabelSmallBase();
			RightJLabel_HospitalDiscountSuffix.setText("Off");
			RightJLabel_HospitalDiscountSuffix.setBounds(125, -5, 45, 20);
		}
		return RightJLabel_HospitalDiscountSuffix;
	}

	/**
	 * This method initializes RightJLabel_DoctorDiscount
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_DoctorDiscount() {
		if (RightJLabel_DoctorDiscount == null) {
			RightJLabel_DoctorDiscount = new LabelSmallBase();
			RightJLabel_DoctorDiscount.setText("Doctor Disc.");
			RightJLabel_DoctorDiscount.setBounds(175, -5, 110, 20);
		}
		return RightJLabel_DoctorDiscount;
	}

	/**
	 * This method initializes RightJText_DoctorDiscount
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextAmount getRightJText_DoctorDiscount() {
		if (RightJText_DoctorDiscount == null) {
			RightJText_DoctorDiscount = new TextAmount(3);
			RightJText_DoctorDiscount.setBounds(245, -5, 50, 20);
		}
		return RightJText_DoctorDiscount;
	}

	/**
	 * This method initializes RightJLabel_DoctorSuffix
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_DoctorDiscountSuffix() {
		if (RightJLabel_DoctorDiscountSuffix == null) {
			RightJLabel_DoctorDiscountSuffix = new LabelSmallBase();
			RightJLabel_DoctorDiscountSuffix.setText("Off");
			RightJLabel_DoctorDiscountSuffix.setBounds(300, -5, 45, 20);
		}
		return RightJLabel_DoctorDiscountSuffix;
	}

	/**
	 * This method initializes RightJLabel_SpecialDiscount
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_SpecialDiscount() {
		if (RightJLabel_SpecialDiscount == null) {
			RightJLabel_SpecialDiscount = new LabelSmallBase();
			RightJLabel_SpecialDiscount.setText("Spec. Disc.");
			RightJLabel_SpecialDiscount.setBounds(350, -5, 100, 20);
		}
		return RightJLabel_SpecialDiscount;
	}

	/**
	 * This method initializes RightJText_SpecialDiscount
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextAmount getRightJText_SpecialDiscount() {
		if (RightJText_SpecialDiscount == null) {
			RightJText_SpecialDiscount = new TextAmount(3);
			RightJText_SpecialDiscount.setBounds(415, -5, 50, 20);
		}
		return RightJText_SpecialDiscount;
	}

	/**
	 * This method initializes RightJLabel_SpecialDiscountSuffix
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_SpecialDiscountSuffix() {
		if (RightJLabel_SpecialDiscountSuffix == null) {
			RightJLabel_SpecialDiscountSuffix = new LabelSmallBase();
			RightJLabel_SpecialDiscountSuffix.setText("Off");
			RightJLabel_SpecialDiscountSuffix.setBounds(470, -5, 45, 20);
		}
		return RightJLabel_SpecialDiscountSuffix;
	}

	/**
	 * This method initializes RightJLabel_SendBillDate
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_SendBillDate() {
		if (RightJLabel_SendBillDate == null) {
			RightJLabel_SendBillDate = new LabelSmallBase();
			RightJLabel_SendBillDate.setText("Send Bill DD");
			RightJLabel_SendBillDate.setBounds(220, 225, 65, 20);
			RightJLabel_SendBillDate.setVisible(false);
		}
		return RightJLabel_SendBillDate;
	}

	/**
	 * This method initializes RightJText_SendBillDate
	 *
	 * @return com.hkah.client.layout.button.CheckBoxBase
	 */
	private TextDate getRightJText_SendBillDate() {
		if (RightJText_SendBillDate == null) {
			RightJText_SendBillDate = new TextDate() {
				@Override
				public void onBlur() {
					if (!RightJText_SendBillDate.isEmpty() && !RightJText_SendBillDate.isValid()) {
						Factory.getInstance().addErrorMessage("The Send Bill Date is Invalid.", RightJText_SendBillDate);
						RightJText_SendBillDate.resetText();
					}
				}
			};
			RightJText_SendBillDate.setBounds(282, 225, 90, 20);
			RightJText_SendBillDate.setVisible(false);
		}
		return RightJText_SendBillDate;
	}

	/**
	 * This method initializes orderBy
	 *
	 * @return com.hkah.client.layout.combobox.ComboBoxBase
	 */
	private ComboBoxBase getRightJCombo_SendBillType() {
		if (RightJCombo_SendBillType == null) {
			RightJCombo_SendBillType = new ComboBoxBase("SENDBILLTYPE", false, true, true);
			RightJCombo_SendBillType.setBounds(380, 225, 50, 20);
			RightJCombo_SendBillType.setVisible(false);
		}
		return RightJCombo_SendBillType;
	}

	private LabelSmallBase getRightJLabel_SpRqt() {
		if (RightJLabel_SpRqt == null) {
			RightJLabel_SpRqt = new LabelSmallBase();
			RightJLabel_SpRqt.setText("Sp.Req");
			RightJLabel_SpRqt.setBounds(467, 225, 20, 20);
			RightJLabel_SpRqt.setVisible(false);
		}
		return RightJLabel_SpRqt;
	}

	private ComboBoxBase getRightJCombo_SpRqt() {
		if (RightJCombo_SpRqt == null) {
			RightJCombo_SpRqt = new ComboBoxBase("INPSPRQT", false, false, true);
			RightJCombo_SpRqt.setBounds(505, 225, 80, 20);
			RightJCombo_SpRqt.setVisible(false);
		}
		return RightJCombo_SpRqt;
	}

	/**
	 * This method initializes RightJLabel_AR
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_AR() {
		if (RightJLabel_AR == null) {
			RightJLabel_AR = new LabelSmallBase();
			RightJLabel_AR.setText("AR");
			RightJLabel_AR.setBounds(520, 205, 35, 20);
		}
		return RightJLabel_AR;
	}

	/**
	 * This method initializes RightJCheckBox_AR
	 *
	 * @return com.hkah.client.layout.button.CheckBoxBase
	 */
	private CheckBoxBase getRightJCheckBox_AR() {
		if (RightJCheckBox_AR == null) {
			RightJCheckBox_AR = new CheckBoxBase();
			RightJCheckBox_AR.setBounds(536, 205, 20, 20);
		}
		return RightJCheckBox_AR;
	}

	/**
	 * This method initializes RightJLabel_MAllocate
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getRightJLabel_MAllocate() {
		if (RightJLabel_MAllocate == null) {
			RightJLabel_MAllocate = new LabelSmallBase();
			RightJLabel_MAllocate.setText("M Allocate");
			RightJLabel_MAllocate.setBounds(570, 205, 60, 20);
		}
		return RightJLabel_MAllocate;
	}

	/**
	 * This method initializes RightJCheckBox_MAllocate
	 *
	 * @return com.hkah.client.layout.button.CheckBoxBase
	 */
	private CheckBoxBase getRightJCheckBox_MAllocate() {
		if (RightJCheckBox_MAllocate == null) {
			RightJCheckBox_MAllocate = new CheckBoxBase();
			RightJCheckBox_MAllocate.setBounds(625, 205, 20, 20);
		}
		return RightJCheckBox_MAllocate;
	}

	public CheckBoxBase getShowHistory() {
		if (ShowHistory == null) {
			ShowHistory = new CheckBoxBase() {
				public void onClick() {
					refreshTable();
				}
			};
			ShowHistory.setBounds(690, 185, 20, 20);
		}
		return ShowHistory;
	}

	public LabelSmallBase getShowHistoryDesc() {
		if (ShowHistoryDesc == null) {
			ShowHistoryDesc = new LabelSmallBase();
			ShowHistoryDesc.setText("<font color='blue'>Show History</font>");
			ShowHistoryDesc.setBounds(720, 185, 100, 20);
		}
		return ShowHistoryDesc;
	}

	public LabelSmallBase getOrderByDesc() {
		if (orderbydesc == null) {
			orderbydesc = new LabelSmallBase();
			orderbydesc.setText("Sort");
			orderbydesc.setBounds(665, 205, 30, 20);
		}
		return orderbydesc;
	}

	/**
	 * This method initializes orderBy
	 *
	 * @return com.hkah.client.layout.combobox.ComboCoPayRefType
	 */
	private ComboTranDtlOrderBy getOrderBy() {
		if (orderBy == null) {
			orderBy = new ComboTranDtlOrderBy() {
				protected void onClick() {
					refreshTable();
				}
			};
			orderBy.setBounds(695, 205, 120, 20);
		}
		return orderBy;
	}

	/**
	 * This method initializes RightJScrollPane_Detail
	 *
	 * @return javax.swing.JScrollPane
	 */
	private JScrollPane getRightJScrollPane_Detail() {
		if (RightJScrollPane_Detail == null) {
			getJScrollPane().removeViewportView(getListTable());
			RightJScrollPane_Detail = new JScrollPane();
			RightJScrollPane_Detail.setViewportView(getListTable());
			RightJScrollPane_Detail.setBounds(5, 232, 810, 178);
		}
		return RightJScrollPane_Detail;
	}

	/**
	 * This method initializes slipDetailPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	public BasePanel getBtnPanel() {
		if (btnPanel == null) {
			btnPanel = new BasePanel();
			btnPanel.setBounds(3, 407, 810, 140);
			btnPanel.add(getRightButton_Charge(), null);
			btnPanel.add(getRightButton_Adjust(), null);
			btnPanel.add(getRightButton_Update(), null);
			btnPanel.add(getRightButton_UpDocCode(), null);
			btnPanel.add(getRightButton_UpdateBed(), null);
			btnPanel.add(getRightButton_Payment(), null);
			btnPanel.add(getRightButton_CancelItem(), null);
			btnPanel.add(getRightButton_CancelPkg(), null);

			btnPanel.add(getRightButton_AddCItem(), null);
			btnPanel.add(getRightButton_AddCItemPer(), null);
			btnPanel.add(getRightButton_PkgTxn(), null);
			btnPanel.add(getRightButton_Refund(), null);
			btnPanel.add(getRightButton_CloseBill(), null);
			btnPanel.add(getRightButton_DoctorAllow(), null);
			btnPanel.add(getRightButton_CalRefItem(), null);
			btnPanel.add(getRightButton_SpecCal(), null);

			btnPanel.add(getRightButton_PatDetail(), null);
			btnPanel.add(getRightButton_PrintTotalReceipt(), null);
			btnPanel.add(getRightButton_Statement(), null);
			btnPanel.add(getRightButton_Reprint(), null);
			btnPanel.add(getRightButton_MovetoPkgtx(), null);
			btnPanel.add(getRightButton_MovePkgtoPkgtx(), null);
			btnPanel.add(getRightButton_ChangeRLvl(), null);

			btnPanel.add(getRightButton_ChangeAmount(), null);
			btnPanel.add(getRightButton_ChangeAcm(), null);
			btnPanel.add(getRightButton_Log(), null);
			btnPanel.add(getRightButton_PrintCert(), null);
			btnPanel.add(getRightButton_CashierSignOn(), null);
			btnPanel.add(getRightButton_BillSummary(), null);
			btnPanel.add(getRightButton_Supp(), null);
			btnPanel.add(getRightButton_PrtSupp(), null);
			btnPanel.add(getRightButton_LabReport(), null);

			btnPanel.add(getRightButton_DoctorAppointment(), null);
			btnPanel.add(getRightButton_PatientRegistration(), null);
			btnPanel.add(getRightButton_Consent(), null);
			btnPanel.add(getRightButton_ReOpenSlip(), null);
			btnPanel.add(getRightButton_CancelSlip(), null);
			btnPanel.add(getRightButton_OtherSlip(), null);
			btnPanel.add(getRightButton_DischargeCheck(), null);
			btnPanel.add(getRightButton_ReminderLetter(), null);
			btnPanel.add(getRightButton_Deposit(), null);
			btnPanel.add(getRightButton_MovetoPkgtx2(), null);
			btnPanel.add(getRightButton_BudgetEst(), null);
			btnPanel.add(getRightButton_SendDisChrgSMS(), null);
			btnPanel.add(getRightButton_Insurance(), null);
			btnPanel.add(getRightButton_MobileBill(), null);
			btnPanel.add(getRightButton_PkgDetails(), null);
			btnPanel.add(getRightButton_sendSMSTelemed(), null);
		}
		return btnPanel;
	}

	/**
	 * This method initializes RightButton_Charge
	 *
	 * @return javax.swing.ButtonBase
	 */
	private ButtonBase getRightButton_Charge() {
		if (RightButton_Charge == null) {
			RightButton_Charge = new ButtonBase() {
				@Override
				public void onClick() {

					if (slpNo.trim().length() > 0) {
						setSlipTxParam();
						setParameter("SlpType", slipType);
						setParameter("SpcName", spcName);
						// get transaction date
						String[] tableValue = getListTable().getSelectedRowContent();
						if (tableValue != null) {
							setParameter("StnDesc", tableValue[STNDESC_COL]);
							setParameter("StnRlvl", tableValue[STNRLVL_COL]);
						} else {
							resetParameter("StnDesc");
							resetParameter("StnRlvl");
						}
						setParameter("SlpHDisc", getRightJText_HospitalDiscount().getText());
						setParameter("SlpDDisc", getRightJText_DoctorDiscount().getText());
						setParameter("SlpSDisc", getRightJText_SpecialDiscount().getText());
						setParameter("TransactionMode", ConstantsTransaction.TXN_ADD_MODE);
						setParameter("ItmCat", "D");
						setParameter("FromWhere", sFromWhere);
						getListTable().setLastSelectedItemKey(null);
						showPanel(new ChargeCapture());
					}
				}
			};
			RightButton_Charge.setBounds(5, 5, 84, 23);
			RightButton_Charge.setText("Add Charges", 'C');

		}
		return RightButton_Charge;
	}

	/**
	 * This method initializes RightButton_Adjust
	 *
	 * @return javax.swing.ButtonBase
	 */
	private ButtonBase getRightButton_Adjust() {
		if (RightButton_Adjust == null) {
			RightButton_Adjust = new ButtonBase() {
				@Override
				public void onClick() {
					String[] para = getListTable().getSelectedRowContent();
					if (para != null && para.length > 0) {
						setModifySlipTxParam();
						setParameter("TransactionMode", ConstantsTransaction.TXN_ADJUST_MODE);
						setParameter("DocCode", para[DOCCODE_COL]);
						setParameter("DocName", para[DOCNAME_COL]);
						showPanel(new SlipTransactionModification());
					}
				}
			};
			RightButton_Adjust.setBounds(90, 5, 79, 23);
			RightButton_Adjust.setText("Adjust", 'A');

		}
		return RightButton_Adjust;
	}

	/**
	 * This method initializes RightButton_Update
	 *
	 * @return javax.swing.ButtonBase
	 */
	private ButtonBase getRightButton_Update() {
		if (RightButton_Update == null) {
			RightButton_Update = new ButtonBase() {
				@Override
				public void onClick() {
					String[] para = getListTable().getSelectedRowContent();
					if (para != null && para.length > 0) {
						setModifySlipTxParam();
						setParameter("TransactionMode", ConstantsTransaction.TXN_UPDATE_MODE);
						setParameter("DocCode", para[DOCCODE_COL]);
						setParameter("DocName", para[DOCNAME_COL]);
						showPanel(new SlipTransactionModification());
					}
				}
			};
			RightButton_Update.setBounds(170, 5, 79, 23);
			RightButton_Update.setText("Update", 'U');
		}
		return RightButton_Update;
	}

	/**
	 * This method initializes RightButton_UpDocCode
	 *
	 * @return javax.swing.ButtonBase
	 */
	private ButtonBase getRightButton_UpDocCode() {
		if (RightButton_UpDocCode == null) {
			RightButton_UpDocCode = new ButtonBase() {
				@Override
				public void onClick() {
					getDlgUpdateDoctor().showDialog(
							slpNo,
							getRightJText_PatientNo().getText(),
							getRightJText_Doctor().getText());
				}
			};
			RightButton_UpDocCode.setBounds(250, 5, 139, 23);
			RightButton_UpDocCode.setText("Update Slip Doctor (z)", 'z');
		}
		return RightButton_UpDocCode;
	}

	/**
	 * This method initializes RightButton_UpdateBed
	 *
	 * @return javax.swing.ButtonBase
	 */
	private ButtonBase getRightButton_UpdateBed() {
		if (RightButton_UpdateBed == null) {
			RightButton_UpdateBed = new ButtonBase() {
				@Override
				public void onClick() {
					if (getListTable().getSelectedRow() >= 0) {
						getDlgTxUpdateBed().showDialog(slpNo, inpid, getListTable().getSelectedRowContent()[STNID2_COL]);
					} else {
						getDlgTxUpdateBed().showDialog(slpNo, inpid, null);
					}
				}
			};
			RightButton_UpdateBed.setBounds(390, 5, 109, 23);
			RightButton_UpdateBed.setText("Update Bed (y)", 'y');
		}
		return RightButton_UpdateBed;
	}

	/**
	 * This method initializes RightButton_Payment
	 *
	 * @return javax.swing.ButtonBase
	 */
	private ButtonBase getRightButton_Payment() {
		if (RightButton_Payment == null) {
			RightButton_Payment = new ButtonBase() {
				@Override
				public void onClick() {
					if (HKAH_VALUE.equals(getUserInfo().getSiteCode())
							&& (isAlertLOG) && (ConstantsTransaction.SLIP_TYPE_OUTPATIENT.equals(slipType))){
							Factory.getInstance()
							.addErrorMessage("There are still transaction(s) un-posted.  Please check before collecting payment .");
					} else {
						if (HKAH_VALUE.equals(getUserInfo().getSiteCode())
								&& (isAlertLOG) && (ConstantsTransaction.SLIP_TYPE_INPATIENT.equals(slipType))){
							Factory.getInstance()
							.addErrorMessage("There are still transaction(s) un-posted.  Please check before collecting payment .");
						}
						if (memActID != null && memActID.length() > 0) {
							QueryUtil.executeMasterBrowse(
									getUserInfo(), "ARCARDTYPE",
									new String[] { null, memActID, MINUS_ONE_VALUE },
									TxnCallBack.getInstance().getCheckArCardRemarkCallBack(getThis()));
						} else {
							getDlgPaymentInstruction().showDialog(getRightJText_SlipNo().getText());
						}
					}
				}
			};
			RightButton_Payment.setBounds(500, 5, 79, 23);
			RightButton_Payment.setText("Payment", 'm');
		}
		return RightButton_Payment;
	}

	public void checkArCardRemark(MessageQueue mQueue) {
		if (mQueue.success()) {
			String[] content = mQueue.getContentField();

			String sPayRmkIP = content[4];
			String sPayRmkOP = content[5];
			String sPayRmkDC = content[6];

			if (ConstantsTransaction.SLIP_TYPE_INPATIENT.equals(slipType) &&
					sPayRmkIP != null &&
					sPayRmkIP.length() > 0) {
				getDlgARCardRemarkForPayment().showDialog("Payment",
						content[13], memActID, slipType, false, true);
			} else if (ConstantsTransaction.SLIP_TYPE_OUTPATIENT.equals(slipType) &&
						sPayRmkOP != null &&
						sPayRmkOP.length() > 0) {
				getDlgARCardRemarkForPayment().showDialog("Payment",
						content[13], memActID, slipType, false, true);
			} else if (ConstantsTransaction.SLIP_TYPE_DAYCASE.equals(slipType) &&
//						(sPayRmkDC != null && sPayRmkDC.length() > 0)) {
					sPayRmkIP != null &&
					sPayRmkIP.length() > 0) {
				getDlgARCardRemarkForPayment().showDialog("Payment",
						content[13], memActID, slipType, false, true);
			} else {
				getDlgPaymentInstruction().showDialog(getRightJText_SlipNo().getText());
			}
		} else {
			getDlgPaymentInstruction().showDialog(getRightJText_SlipNo().getText());
		}
	}

	/**
	 * This method initializes RightButton_CancelItem
	 *
	 * @return javax.swing.ButtonBase
	 */
	private ButtonBase getRightButton_CancelItem() {
		if (RightButton_CancelItem == null) {
			RightButton_CancelItem = new ButtonBase() {
				@Override
				public void onClick() {
					canProceed("CancelItem");
				}
			};
			RightButton_CancelItem.setBounds(580, 5, 109, 23);
			RightButton_CancelItem.setText("Cancel Item", 'I');
		}
		return RightButton_CancelItem;
	}

	/**
	 * This method initializes RightButton_CancelPkg
	 *
	 * @return javax.swing.ButtonBase
	 */
	private ButtonBase getRightButton_CancelPkg() {
		if (RightButton_CancelPkg == null) {
			RightButton_CancelPkg = new ButtonBase() {
				@Override
				public void onClick() {
					canProceed("cancelPkg");
				}
			};
			RightButton_CancelPkg.setBounds(690, 5, 120, 23);
			RightButton_CancelPkg.setText("Cancel Package", 'k');
		}
		return RightButton_CancelPkg;
	}

	/**
	 * This method initializes RightButton_AddCItem
	 *
	 * @return ButtonBase
	 */
	private ButtonBase getRightButton_AddCItem() {
		if (RightButton_AddCItem == null) {
			RightButton_AddCItem = new ButtonBase() {
				@Override
				public void onClick() {

					if (slpNo.trim().length() > 0) {
						setSlipTxParam();
						setParameter("SlpType", slipType);
						setParameter("SpcName", spcName);
						// get transaction date
						String[] tableValue = getListTable().getSelectedRowContent();
						if (tableValue != null) {
							setParameter("StnDesc", tableValue[STNDESC_COL]);
							setParameter("StnRlvl", tableValue[STNRLVL_COL]);
						} else {
							resetParameter("StnDesc");
							resetParameter("StnRlvl");
						}
						setParameter("SlpHDisc", getRightJText_HospitalDiscount().getText());
						setParameter("SlpDDisc", getRightJText_DoctorDiscount().getText());
						setParameter("SlpSDisc", getRightJText_SpecialDiscount().getText());
						setParameter("TransactionMode", ConstantsTransaction.TXN_CREDITITEMPER_MODE);
						setParameter("ItmCat", "C");
						showPanel(new ChargeCapture());
					}
				}
			};
			RightButton_AddCItem.setBounds(5, 29, 120, 23);
			RightButton_AddCItem.setText("Add Item/Pkg Credit", 't');
		}
		return RightButton_AddCItem;
	}

	/**
	 * This method initializes RightButton_AddCItemPer
	 *
	 * @return javax.swing.ButtonBase
	 */
	private ButtonBase getRightButton_AddCItemPer() {
		if (RightButton_AddCItemPer == null) {
			RightButton_AddCItemPer = new ButtonBase() {
				@Override
				public void onClick() {
					if (slpNo.trim().length() > 0) {
						setModifySlipTxParam();
						setParameter("TransactionMode", ConstantsTransaction.TXN_CREDITITEM_MODE);
						setParameter("BedCode", getRightJText_BedCode().getText());
						setParameter("DocCode", getRightJText_Doctor().getText());
						setParameter("TotalCharge", getRightJText_TotalCharges().getText());
						setParameter("ItmCat", "C");
						showPanel(new AddCreditItem());
					}
				}
			};
			RightButton_AddCItemPer.setBounds(126, 29, 120, 23);
			RightButton_AddCItemPer.setText("Add Credit Item %", 'd');

		}
		return RightButton_AddCItemPer;
	}

	/**
	 * This method initializes RightButton_PkgTxn
	 *
	 * @return javax.swing.ButtonBase
	 */
	private ButtonBase getRightButton_PkgTxn() {
		if (RightButton_PkgTxn == null) {
			RightButton_PkgTxn = new ButtonBase() {
				@Override
				public void onClick() {
					setSlipTxParam();
					setParameter("SlpType", slipType);
					setParameter("InpDDate", getRightJText_DischargeDate().getText());

					String[] tableValue = getListTable().getSelectedRowContent();
					if (tableValue != null) {
						setParameter("GlcCode", tableValue[GLCCODE_COL]);
						setParameter("StnDisc", tableValue[STNDISC_COL]);
						setParameter("StnDesc", tableValue[STNDESC_COL]);
						setParameter("StnRlvl", tableValue[STNRLVL_COL]);
					} else {
						resetParameter("GlcCode");
						resetParameter("StnDisc");
						resetParameter("StnDesc");
						resetParameter("StnRlvl");
					}

					setParameter("SlpHDisc", getRightJText_HospitalDiscount().getText());
					setParameter("SlpDDisc", getRightJText_DoctorDiscount().getText());
					setParameter("SlpSDisc", getRightJText_SpecialDiscount().getText());

					showPanel(new PackageTransactionEntry());
				}
			};
			RightButton_PkgTxn.setBounds(247, 29, 130, 23);
			RightButton_PkgTxn.setText("Package Transaction", 'P');
		}
		return RightButton_PkgTxn;
	}

	/**
	 * This method initializes RightButton_Refund
	 *
	 * @return javax.swing.ButtonBase
	 */
	private ButtonBase getRightButton_Refund() {
		if (RightButton_Refund == null) {
			RightButton_Refund = new ButtonBase() {
				@Override
				public void onClick() {
					setSlipTxParam();
					setParameter("RefundAmt", getRightJText_Balance().getText());

					String[] tableValue = getListTable().getSelectedRowContent();
					if (tableValue != null) {
						setParameter("StnID", tableValue[STNID2_COL]);
						setParameter("StnDesc", tableValue[STNDESC_COL]);
					} else {
						resetParameter("StnID");
						resetParameter("StnDesc");
					}
					showPanel(new Refund());
				}
			};
			RightButton_Refund.setBounds(378, 29, 70, 23);
			RightButton_Refund.setText("Refund", 'f');
		}
		return RightButton_Refund;
	}

	/**
	 * This method initializes RightButton_CloseBill
	 *
	 * @return javax.swing.ButtonBase
	 */
	private ButtonBase getRightButton_CloseBill() {
		if (RightButton_CloseBill == null) {
			RightButton_CloseBill = new ButtonBase() {
				@Override
				public void onClick() {

					if (HKAH_VALUE.equals(getUserInfo().getSiteCode()) &&
							(getRightJCombo_Source().isEmpty() || !getRightJCombo_Source().isValid())) {
						Factory.getInstance().addErrorMessage("Please select a source before closing slip.",
								new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								isEmptySource = true;
								modifyAction();
							}
						});
					} else if (HKAH_VALUE.equals(getUserInfo().getSiteCode()) && (isAlertLOG)){
							Factory.getInstance().
							addErrorMessage("There are still transaction(s) un-posted.  Please check before closing the slip. ");
					} else {
						doCloseSlip();
					}
				}
			};
			RightButton_CloseBill.setBounds(449, 29, 70, 23);
			RightButton_CloseBill.setText("Close", 'l');
		}
		return RightButton_CloseBill;
	}

	/**
	 * This method initializes RightButton_DoctorAllow
	 *
	 * @return javax.swing.ButtonBase
	 */
	private ButtonBase getRightButton_DoctorAllow() {
		if (RightButton_DoctorAllow == null) {
			RightButton_DoctorAllow = new ButtonBase() {
				@Override
				public void onClick() {
					setParameter("SlpNo", slpNo);
					setParameter("SlpType", slipType);
					showPanel(new SlipPaymentAllocation());
				}
			};
			RightButton_DoctorAllow.setBounds(520, 29, 100, 23);
			RightButton_DoctorAllow.setText("Dr. Alloc (w)", 'w');

		}
		return RightButton_DoctorAllow;
	}

	/**
	 * This method initializes RightButton_CalRefItem
	 *
	 * @return javax.swing.ButtonBase
	 */
	private ButtonBase getRightButton_CalRefItem() {
		if (RightButton_CalRefItem == null) {
			RightButton_CalRefItem = new ButtonBase() {
				@Override
				public void onClick() {
					getDlgCalRefItem().showDialog(slpNo);
				}
			};
			RightButton_CalRefItem.setBounds(621, 29, 120, 23);
			RightButton_CalRefItem.setText("Cal Reference Item", 'n');
		}
		return RightButton_CalRefItem;
	}

	/**
	 * This method initializes RightButton_SpecCal
	 *
	 * @return javax.swing.ButtonBase
	 */
	private ButtonBase getRightButton_SpecCal() {
		if (RightButton_SpecCal == null) {
			RightButton_SpecCal = new ButtonBase() {
				@Override
				public void onClick() {
					getDlgCalSpec().showDialog(slpNo, getRightJText_AdmissionDate().getText());
				}
			};
			RightButton_SpecCal.setBounds(742, 29, 68, 23);
			RightButton_SpecCal.setText("Spec Cal");
		}
		return RightButton_SpecCal;
	}

	/**
	 * This method initializes RightButton_PatDetail
	 *
	 * @return javax.swing.ButtonBase
	 */
	private ButtonBase getRightButton_PatDetail() {
		if (RightButton_PatDetail == null) {
			RightButton_PatDetail = new ButtonBase() {
				@Override
				public void onClick() {
					setParameter("SlpNo", slpNo);
					setParameter("RegID",regid);
					showPanel(new RegistrationDischarge());
				}
			};
			RightButton_PatDetail.setBounds(5, 53, 170, 23);
			RightButton_PatDetail.setText("Admission/Discharge Detail", 'o');
		}
		return RightButton_PatDetail;
	}

	/**
	 * This method initializes RightButton_PrintTotalReceipt
	 *
	 * @return javax.swing.ButtonBase
	 */
	private ButtonBase getRightButton_PrintTotalReceipt() {
		if (RightButton_PrintTotalReceipt == null) {
			RightButton_PrintTotalReceipt = new ButtonBase() {
				@Override
				public void onClick() {
					getDlgIPOfficialReceipt().showDialog(getRightJText_PatientNo().getText().trim(), slpNo, slipType, lang);
				}
			};
			RightButton_PrintTotalReceipt.setBounds(176, 53, 110, 23);
			RightButton_PrintTotalReceipt.setText("Print Total Receipt", 'e');
		}
		return RightButton_PrintTotalReceipt;
	}

	/**
	 * This method initializes RightButton_Statement
	 *
	 * @return javax.swing.ButtonBase
	 */
	private ButtonBase getRightButton_Statement() {
		if (RightButton_Statement == null) {
			RightButton_Statement = new ButtonBase() {
				@Override
				public void onClick() {
					if (memActID != null && memActID.length() > 0) {
						QueryUtil.executeMasterBrowse(
							getUserInfo(), "ARCARDTYPE",
							new String[] { null, memActID, MINUS_ONE_VALUE },
							TxnCallBack.getInstance().getCheckArCardRemarkForStatementCallBack(getThis()));
					} else {
//						getStatementDialog();
						btnStatementPrintRpt();
					}
				}
			};
			RightButton_Statement.setBounds(287, 53, 80, 23);
			RightButton_Statement.setText("Statement", 'S');
		}
		return RightButton_Statement;
	}

	public void checkArCardRemarkForStatement(MessageQueue mQueue) {
		String[] content = mQueue.getContentField();
/*
		String actRegRmkIP = content[1];
		String actRegRmkOP = content[2];
		String actRegRmkDC = content[3];
*/
		String actPayRmkIP = content[4];
		String actPayRmkOP = content[5];
		String actPayRmkDC = content[6];

		if ((slipType.equals(ConstantsTransaction.SLIP_TYPE_INPATIENT) &&
				actPayRmkIP != null && actPayRmkIP.length() > 0) ||
			(slipType.equals(ConstantsTransaction.SLIP_TYPE_OUTPATIENT) &&
				actPayRmkOP != null && actPayRmkOP.length() > 0) ||
			(slipType.equals(ConstantsTransaction.SLIP_TYPE_DAYCASE) &&
				actPayRmkDC != null && actPayRmkDC.length() > 0)) {
			getDlgARCardRemark().showDialog("Statement",
					content[13], memActID, slipType,
					true, false);
		} else {
			getStatementDialog();
		}
	}

	/**
	 * This method initializes RightButton_Reprint
	 *
	 * @return javax.swing.ButtonBase
	 */
	private ButtonBase getRightButton_Reprint() {
		if (RightButton_Reprint == null) {
			RightButton_Reprint = new ButtonBase() {
				@Override
				public void onClick() {
					if (getListTable().getRowCount() > 0) {
						if (Factory.getInstance().getSysParameter("SHOWSIGN").equals("Y")) {
							 showDlgReprintRpt();
						} else {
							printDepositReceipt(getRightJText_SlipNo().getText(), lang,
									getListTable().getSelectedRowContent()[ITMCODE_COL],
									getListTable().getSelectedRowContent()[STNDESC_COL],
									EMPTY_VALUE,//getListTable().getSelectedRowContent()[PAYMENTMETHOD_COL],
									getListTable().getSelectedRowContent()[STNTDATE_COL],
									Integer.toString(Math.abs(Integer.parseInt(getListTable().getSelectedRowContent()[STNNAMT_COL]))),
									"Y",
									DateTimeUtil.formatHaBobDate(DateTimeUtil.parseDate((getListTable().getSelectedRowContent()[STNTDATE_COL]))));
						}
					}
				}
			};
			RightButton_Reprint.setBounds(368, 53, 100, 23);
			RightButton_Reprint.setText("Reprint Receipt", 'R');
		}
		return RightButton_Reprint;
	}

	private void showDlgReprintRpt() {
		if (dlgReprintRpt == null) {
			dlgReprintRpt = new DlgReprintRpt(getMainFrame(), "DEPOSIT") {
				@Override
				public void reprint() {
					printDepositReceipt(getRightJText_SlipNo().getText(), lang,
							getListTable().getSelectedRowContent()[ITMCODE_COL],
							getListTable().getSelectedRowContent()[STNDESC_COL],
							EMPTY_VALUE,//getListTable().getSelectedRowContent()[PAYMENTMETHOD_COL],
							getListTable().getSelectedRowContent()[STNTDATE_COL],
							Integer.toString(Math.abs(Integer.parseInt(getListTable().getSelectedRowContent()[STNNAMT_COL]))),
							getCopyYesOpt().isSelected()?"Y":"",
							DateTimeUtil.formatHaBobDate(DateTimeUtil.parseDate((getListTable().getSelectedRowContent()[STNTDATE_COL]))));
					dispose();
					showDlgReprintRpt();
				}

				@Override
				public void showDialog(boolean copyOpt, String parameter[]) {
					if (copyOpt) {
						getCopyDesc().show();
						getCopyYesOpt().show();
						getCopyNoOpt().show();
						getCopyYesOpt().setSelected(true);
					}
					else {
						getCopyDesc().hide();
						getCopyYesOpt().hide();
						getCopyNoOpt().hide();
					}
					getCopyYesOpt().setSelected(true);
					setParameter(parameter);
					layout();
					setVisible(true);
					setFocusWidget(getButtonById(YES));
				}
			};
			dlgReprintRpt.setResizable(false);
		}

		dlgReprintRpt.showDialog(true, null);

		dlgReprintRpt.setZIndex(20000);
		dlgReprintRpt.focus();
	}

	/**
	 * This method initializes RightButton_MovetoPkgtx
	 *
	 * @return javax.swing.ButtonBase
	 */
	private ButtonBase getRightButton_MovetoPkgtx() {
		if (RightButton_MovetoPkgtx == null) {
			RightButton_MovetoPkgtx = new ButtonBase() {
				@Override
				public void onClick() {
					canProceed("moveItem2Pkg");
				}
			};
			RightButton_MovetoPkgtx.setBounds(469, 53, 110, 23);
			RightButton_MovetoPkgtx.setText("Move Item to Ref(x)", 'v');

		}
		return RightButton_MovetoPkgtx;
	}

	/**
	 * This method initializes RightButton_MovePkgtoPkgtx
	 *
	 * @return javax.swing.ButtonBase
	 */
	private ButtonBase getRightButton_MovePkgtoPkgtx() {
		if (RightButton_MovePkgtoPkgtx == null) {
			RightButton_MovePkgtoPkgtx = new ButtonBase() {
				@Override
				public void onClick() {
					if (getListTable().getRowCount() == 0)
						return;
					canProceed("movePkg2Pkg");
				}
			};
			RightButton_MovePkgtoPkgtx.setBounds(580, 53, 129, 23);
			RightButton_MovePkgtoPkgtx.setText("Move Package to Ref(x)", 'x');
		}
		return RightButton_MovePkgtoPkgtx;
	}

	/**
	 * This method initializes RightButton_ChangeRLvl
	 *
	 * @return javax.swing.ButtonBase
	 */
	private ButtonBase getRightButton_ChangeRLvl() {
		if (RightButton_ChangeRLvl == null) {
			RightButton_ChangeRLvl = new ButtonBase() {
				@Override
				public void onClick() {
					if (getListTable().getSelectedRow() < 0) {
						Factory.getInstance().addErrorMessage(
								"No seq no. has been selected.",
								"PBA-[Transaction Detail]", null,
								new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								defaultFocus();
							}
						});
					} else if ("PAYME".equals(getListTable().getSelectedRowContent()[ITMCODE_COL])) {//TXN_PAYMENT_ITMCODE
						Factory.getInstance().addErrorMessage(
								"Payment is not allowed to change report level.",
								"PBA-[Transaction Detail]", null,
								new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								defaultFocus();
							}
						});
					} else {
						getDlgChgRptLvl().showDialog(
							slpNo,
							getListTable().getSelectedRowContent()[STNSEQ_COL],
							getListTable().getSelectedRowContent()[ITMCODE_COL],
							getListTable().getSelectedRowContent()[STNDESC_COL],
							getListTable().getSelectedRowContent()[DSCCODE_COL],
							getListTable().getSelectedRowContent()[STNSTS_COL],
							getListTable().getSelectedRowContent()[STNRLVL_COL],
							getSysParameter("PItmCode"),
							getListTable().getSelectedRowContent()[PKGCODE_COL],
							getListTable().getSelectedRowContent()[GLCCODE_COL]);
					}
				}
			};
			RightButton_ChangeRLvl.setBounds(710, 53, 100, 23);
			RightButton_ChangeRLvl.setText("Chg R. Lvl", 'h');
		}
		return RightButton_ChangeRLvl;
	}

	/**
	 * This method initializes RightButton_ChangeAmount
	 *
	 * @return javax.swing.ButtonBase
	 */
	private ButtonBase getRightButton_ChangeAmount() {
		if (RightButton_ChangeAmount == null) {
			RightButton_ChangeAmount = new ButtonBase() {
				@Override
				public void onClick() {
					canProceed("changeAmount");
				}
			};
			RightButton_ChangeAmount.setBounds(5, 77, 90, 23);
			RightButton_ChangeAmount.setText("Change $/%");
		}
		return RightButton_ChangeAmount;
	}

	/**
	 * This method initializes RightButton_ChangeAcm
	 *
	 * @return javax.swing.ButtonBase
	 */
	private ButtonBase getRightButton_ChangeAcm() {
		if (RightButton_ChangeAcm == null) {
			RightButton_ChangeAcm = new ButtonBase() {
				@Override
				public void onClick() {
					canProceed("changeAcm");
				}
			};
			RightButton_ChangeAcm.setBounds(96, 77, 90, 23);
			RightButton_ChangeAcm.setText("Change ACM");
		}
		return RightButton_ChangeAcm;
	}

	/**
	 * This method initializes RightButton_Log
	 *
	 * @return javax.swing.ButtonBase
	 */
	private ButtonBase getRightButton_Log() {
		if (RightButton_Log == null) {
			RightButton_Log = new ButtonBase() {
				@Override
				public void onClick() {
					setParameter("CurrentRegid", regid);
					setParameter("CurrentSlpNo", slpNo);
					setParameter("FromForm", "txnDetails");
					showPanel(new TelLog());
				}
			};
			RightButton_Log.setBounds(187, 77, 60, 23);
			RightButton_Log.setText("Log");
		}
		return RightButton_Log;
	}

	/**
	 * This method initializes RightButton_PrintCert
	 *
	 * @return javax.swing.ButtonBase
	 */
	private ButtonBase getRightButton_PrintCert() {
		if (RightButton_PrintCert == null) {
			RightButton_PrintCert = new ButtonBase() {
				@Override
				public void onClick() {
					getDlgEnterConfinement().showDialog(slpNo);
				}
			};
			RightButton_PrintCert.setBounds(248, 77, 112, 23);
			RightButton_PrintCert.setText("Upd/Prt OB BK");
		}
		return RightButton_PrintCert;
	}

	/**
	 * This method initializes RightButton_CashierSignOn
	 *
	 * @return javax.swing.ButtonBase
	 */
	private ButtonBase getRightButton_CashierSignOn() {
		if (RightButton_CashierSignOn == null) {
			RightButton_CashierSignOn = new ButtonBase() {
				@Override
				public void onClick() {
					if (!getUserInfo().isCashier()) {
						Cashiers.setCashierSignOn(getThis(), false);
					} else {
						Factory.getInstance().addInformationMessage("You have already signed on.", "PBA-[Patient Business Administration System]");
					}
				}
			};
			RightButton_CashierSignOn.setBounds(361, 77, 110, 23);
			RightButton_CashierSignOn.setText("Cashier Sign On");
		}
		return RightButton_CashierSignOn;
	}

	/**
	 * This method initializes RightButton_BillSummary
	 *
	 * @return javax.swing.ButtonBase
	 */
	private ButtonBase getRightButton_BillSummary() {
		if (RightButton_BillSummary == null) {
			RightButton_BillSummary = new ButtonBase() {
				@Override
				public void onClick() {
					//printBillSummary();
					previewBillSummary();
				}
			};
			RightButton_BillSummary.setBounds(472, 77, 100, 23);
			RightButton_BillSummary.setText("Bill Summary");
		}
		return RightButton_BillSummary;
	}

	/**
	 * This method initializes RightButton_Supp
	 *
	 * @return javax.swing.ButtonBase
	 */
	private ButtonBase getRightButton_Supp() {
		if (RightButton_Supp == null) {
			RightButton_Supp = new ButtonBase() {
				@Override
				public void onClick() {
					String[] tableValue = getListTable().getSelectedRowContent();

					setParameter("StnID", tableValue[STNID2_COL]);
					setParameter("ItmCode", tableValue[ITMCODE_COL]);
					setParameter("ItmDesc", tableValue[STNDESC_COL]);
					setParameter("PatNo", getRightJText_PatientNo().getText());
					setParameter("PatName", getRightJText_PatientName().getText());
					setParameter("PatCName", patCName);
					setParameter("PatSex", patSex);
					showPanel(new SupplementaryLink());
				}
			};
			RightButton_Supp.setBounds(573, 77, 80, 23);
			RightButton_Supp.setText("Supp");
		}
		return RightButton_Supp;
	}

	private ButtonBase getRightButton_PrtSupp() {
		if (RightButton_PrtSupp == null) {
			RightButton_PrtSupp = new ButtonBase() {
				@Override
				public void onClick() {
					if (getListTable().getRowCount() > 0) {
						String[] para = getListTable().getSelectedRowContent();
						final String lStnId = para[DIXREF_COL]; //DiXRef;

						QueryUtil.executeMasterFetch(
									getUserInfo(), "SLIPMERGE", new String[] { slpNo, lStnId },
									new MessageQueueCallBack() {
								@Override
								public void onPostSuccess(MessageQueue mQueue) {
									Map<String, String> prtMap = new HashMap<String, String>();
									prtMap.put("SteName", getUserInfo().getSiteName());
									prtMap.put("SteCode", getUserInfo().getSiteCode());
									if (mQueue.success()) {
										prtMap.put("PatNo", getRightJText_PatientNo().getText());
										prtMap.put("PatName", getRightJText_PatientName().getText());
										prtMap.put("AllSlpNo", mQueue.getContentField()[0]!=null&&mQueue.getContentField()[0].length() > 0?mQueue.getContentField()[0]:slpNo);
										prtMap.put("SlipType", slipType);
										prtMap.put("Therapists", mQueue.getContentField()[1]);
										prtMap.put("SUBREPORT_DIR", CommonUtil.getReportDir());
									} else {
										prtMap.put("PatNo", getRightJText_PatientNo().getText());
										prtMap.put("PatName", getRightJText_PatientName().getText());
										prtMap.put("AllSlpNo", slpNo);
										prtMap.put("SlipType", slipType);
										prtMap.put("Therapists", null);
										prtMap.put("SUBREPORT_DIR", CommonUtil.getReportDir());
									}

									PrintingUtil.print("HATS_A4","PrtSupp",prtMap,"",
											new String[] {lStnId},
											new String[] {"SUPPCATEGORYDESC",
											"TXNDATE ",
											"SUPPDESC",
											"TREATBYDRNAME",
											"STNDESC",
											"STNDESC1",
											"STNNAMT"});

								}
							}
						);
					}
				}
			};
			RightButton_PrtSupp.setBounds(654, 77, 80, 23);
			RightButton_PrtSupp.setText("PrtSupp");
		}
		return RightButton_PrtSupp;
	}

	private ButtonBase getRightButton_LabReport() {
		if (RightButton_LabReport == null) {
			RightButton_LabReport = new ButtonBase() {
				@Override
				public void onClick() {
					showPanel(new LabSummaryReport() {
						@Override
						public String getCommandLine() {
							return " "+Factory.getInstance().getUserInfo().getUserID()+
							   " "+getRightJText_PatientNo().getText().trim()+
							   " "+("".equals(getRightJText_AdmissionDate().getText())?
									   getMainFrame().getServerDate():getRightJText_AdmissionDate().getText().trim().substring(0, 10))+
							   " "+("".equals(getRightJText_DischargeDate().getText())?
									   getMainFrame().getServerDate():getRightJText_DischargeDate().getText().trim().substring(0, 10));
						}
					});
				}
			};
			RightButton_LabReport.setBounds(735, 77, 75, 23);
			RightButton_LabReport.setText("Lab Report");
		}
		return RightButton_LabReport;
	}

	private ButtonBase getRightButton_DoctorAppointment() {
		if (RightButton_DoctorAppointment == null) {
			RightButton_DoctorAppointment = new ButtonBase() {
				@Override
				public void onClick() {
					removeParameter();
					setDoctorAppParam();
					exitPanel();
					showPanel(new DoctorAppointment(), false, true);
				}
			};
			RightButton_DoctorAppointment.setBounds(5, 101, 110, 23);
			RightButton_DoctorAppointment.setText("Doctor Appointment", 'o');
		}
		return RightButton_DoctorAppointment;
	}

	private ButtonBase getRightButton_PatientRegistration() {
		if (RightButton_PatientRegistration == null) {
			RightButton_PatientRegistration = new ButtonBase() {
				@Override
				public void onClick() {
					removeParameter();
					setPatientAppParam();
					exitPanel();
					showPanel(new Patient(), false, true);
				}
			};
			RightButton_PatientRegistration.setBounds(116, 101, 110, 23);
			RightButton_PatientRegistration.setText("Patient Registration");
		}
		return RightButton_PatientRegistration;
	}

	private ButtonBase getRightButton_Consent() {
		if (RightButton_Consent == null) {
			RightButton_Consent = new ButtonBase() {
				@Override
				public void onClick() {
					removeParameter();
					setPatientAppParam();
					setParameter("CallForm", "txnDetails");
					exitPanel();
					showPanel(new Patient(), false, true);
				}
			};
			RightButton_Consent.setBounds(227, 101, 105, 23);
			RightButton_Consent.setText("Consent/Insu Card");
		}
		return RightButton_Consent;
	}

	private ButtonBase getRightButton_ReOpenSlip() {
		if (RightButton_ReOpenSlip == null) {
			RightButton_ReOpenSlip = new ButtonBase() {
				@Override
				public void onClick() {
					MessageBox mb = MessageBoxBase.confirm(MSG_PBA_SYSTEM,  "Do you want to reopen the selected slip?",
							new Listener<MessageBoxEvent>() {
						@Override
						public void handleEvent(MessageBoxEvent be) {
							if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
								updateSlipStatus("open");
							}
						}
					});
					mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
				}
			};
			RightButton_ReOpenSlip.setText("Reopen Slip");
			RightButton_ReOpenSlip.setBounds(333, 101, 70, 23);
		}
		return RightButton_ReOpenSlip;
	}

	private ButtonBase getRightButton_CancelSlip() {
		if (RightButton_CancelSlip == null) {
			RightButton_CancelSlip = new ButtonBase() {
				@Override
				public void onClick() {
					String cancelMessage = null;
					if (getListTable().getRowCount() > 0) {
						cancelMessage = MSG_CANCEL_SLIP_HAS_DETAILS;
					} else {
						cancelMessage = ConstantsMessage.MSG_CANCEL_SLIP;
					}
					MessageBox mb = MessageBoxBase.confirm(MSG_PBA_SYSTEM, cancelMessage,
							new Listener<MessageBoxEvent>() {
						@Override
						public void handleEvent(MessageBoxEvent be) {
							if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
								updateSlipStatus("cancel");
							}
						}
					});
					mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
				}
			};
			RightButton_CancelSlip.setText("Cancel Slip");
			RightButton_CancelSlip.setBounds(404, 101, 70, 23);
		}
		return RightButton_CancelSlip;
	}

	private ButtonBase getRightButton_OtherSlip() {
		if (RightButton_OtherSlip == null) {
			RightButton_OtherSlip = new ButtonBase() {
				@Override
				public void onClick() {
					getDlgSlipList().showDialog(getRightJText_PatientNo().getText().trim());
				}
			};
			RightButton_OtherSlip.setText("Billing History");
			RightButton_OtherSlip.setBounds(475, 101, 90, 23);
		}
		return RightButton_OtherSlip;
	}

	private ButtonBase getRightButton_DischargeCheck() {
		if (RightButton_DischargeCheck == null) {
			RightButton_DischargeCheck = new ButtonBase() {
				@Override
				public void onClick() {
					openNewWindow("healthcheck", "http://" + getSysParameter("ptIgUrlSte") + "/intranet/hat/discharge_check.jsp?userid=" + getUserInfo().getUserID() + "&patno=" + getRightJText_PatientNo().getText(),"width=760,height=800,resizable");
				}
			};
			RightButton_DischargeCheck.setText("Misc & O/S");
			RightButton_DischargeCheck.setBounds(566, 101, 82, 23);
		}
		return RightButton_DischargeCheck;
	}

	private ButtonBase getRightButton_ReminderLetter() {
		if (RightButton_ReminderLetter == null) {
			RightButton_ReminderLetter = new ButtonBase() {
				@Override
				public void onClick() {
					getDlgReminderLetter().showDialog(getRightJText_PatientNo().getText().trim(),
							slpNo, slipType,getRightJText_Balance().getText(),"",lang,smtRemark);
				}
			};
			RightButton_ReminderLetter.setBounds(649, 101, 95, 23);
			RightButton_ReminderLetter.setText("Reminder Letter");
		}
		return RightButton_ReminderLetter;
	}

	private ButtonBase getRightButton_Deposit() {
		if (RightButton_Deposit == null) {
			RightButton_Deposit = new ButtonBase() {
				@Override
				public void onClick() {
					removeParameter();
					setPatientAppParam();
					exitPanel();
					showPanel(new Deposit(), false, true);
				}
			};
			RightButton_Deposit.setBounds(745, 101, 65, 23);
			RightButton_Deposit.setText("Deposit");
		}
		return RightButton_Deposit;
	}

	private ButtonBase getRightButton_MovetoPkgtx2() {
		if (RightButton_MovetoPkgtx2 == null) {
			RightButton_MovetoPkgtx2 = new ButtonBase() {
				@Override
				public void onClick() {
					setParameter("PatNo", getRightJText_PatientNo().getText());
					setParameter("PatName", getRightJText_PatientName().getText());
					setParameter("PatCName", patCName);
					setParameter("PatSex", patSex);
					setParameter("SlpNo", getRightJText_SlipNo().getText());
					showPanel(new PkgCodeMvItm2Ref());
				}
			};
			RightButton_MovetoPkgtx2.setBounds(5, 125, 140, 23);
			RightButton_MovetoPkgtx2.setText("Move Multi Item to Ref(x)");
		}
		return RightButton_MovetoPkgtx2;
	}

	private ButtonBase getRightButton_BudgetEst() {
		if (RightButton_BudgetEst == null) {
			RightButton_BudgetEst = new ButtonBase() {
				@Override
				public void onClick() {
					getDlgBudgetEst().showDialog(
							memFESTID,
							"TxnDtl",
							slpNo,
							getRightJText_PatientNo().getText(),
							getRightJText_PatientName().getText(),
							getRightJText_Doctor().getText()
						);
				}
			};
			RightButton_BudgetEst.setText("Budget Estimation");
			RightButton_BudgetEst.setBounds(146, 125, 120, 22);
		}
		return RightButton_BudgetEst;
	}

	private ButtonBase getRightButton_SendDisChrgSMS() {
		if (RightButton_SendDisChrgSMS == null) {
			RightButton_SendDisChrgSMS = new ButtonBase() {
				@Override
				public void onClick() {
					String url = "http://www-server/intranet/hat/sendHATSSms.jsp?staffID=" + getUserInfo().getUserID() + "&slpNo=" + getRightJText_SlipNo().getText()+ "&patNo=" + getRightJText_PatientNo().getText()+ "&command=view";
					openNewWindow("healthcheck", url,"width=700,height=200,resizable");
/*
					QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] {"PATIENT", "COUNT(1)", "patno = '" + getRightJText_PatientNo().getText() + "' and patsms = -1"},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success() && "1".equals(mQueue.getContentField()[0])) {
								String url = "http://www-server/intranet/hat/sendHATSSms.jsp?staffID=" + getUserInfo().getUserID() + "&slpNo=" + getRightJText_SlipNo().getText()+ "&patNo=" + getRightJText_PatientNo().getText()+ "&command=view";
								openNewWindow("healthcheck", url,"width=700,height=200,resizable");
							} else {
								Factory.getInstance().addErrorMessage("Patient request NO. SMS.");
							}
						}
					});
 */
				}
			};
			RightButton_SendDisChrgSMS.setText("DisCharge SMS");
			RightButton_SendDisChrgSMS.setBounds(267, 125, 110, 22);
		}
		return RightButton_SendDisChrgSMS;
	}

	private ButtonBase getRightButton_Insurance() {
		if (RightButton_Insurance == null) {
			RightButton_Insurance = new ButtonBase() {
				@Override
				public void onClick() {
					setParameter("ArcCode", memArcCode);
					setParameter("ArcCardType", memActID);
					showPanel(new ARCardLink());
				}
			};
			RightButton_Insurance.setText("Insurance Program");
			RightButton_Insurance.setBounds(378, 125, 120, 22);
		}
		return RightButton_Insurance;
	}
	
	private ButtonBase getRightButton_MobileBill() {
		if (RightButton_MobBill == null) {
			RightButton_MobBill = new ButtonBase() {
				@Override
				public void onClick() {
					setParameter("PatNo", getRightJText_PatientNo().getText());
					showPanel(new MobileBills());
				}
			};
			RightButton_MobBill.setText("Mobile Bill");
			RightButton_MobBill.setBounds(500, 125, 120, 22);
		}
		return RightButton_MobBill;
	}

	private ButtonBase getRightButton_PkgDetails() {
		if (RightButton_PkgDetails == null) {
			RightButton_PkgDetails = new ButtonBase() {
				@Override
				public void onClick() {
					openNewWindow(null, Factory.getInstance().getSysParameter("PKGDETAILS")+"?from=hats&pkgCode="+regPkgCode, null, true);
				}
			};
			RightButton_PkgDetails.setText("Package Details");
			RightButton_PkgDetails.setBounds(622, 125, 120, 22);
		}
		return RightButton_PkgDetails;
	}
	
	private ButtonBase getRightButton_sendSMSTelemed() {
		if (RightButton_sendSMSTelemed == null) {
			RightButton_sendSMSTelemed = new ButtonBase() {
				@Override
				public void onClick() {
					MessageBoxBase.confirm("Send Zoom URL SMS? ", "Zoom URL: " + memTelemedURL, new Listener<MessageBoxEvent>() {
						@Override
						public void handleEvent(MessageBoxEvent be) {
							if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
								sendTelemedURLSMS();
							}
						}
					});
				}
			};
			RightButton_sendSMSTelemed.setText("Zoom SMS");
			RightButton_sendSMSTelemed.setBounds(744, 125, 66, 22);
		}
		return RightButton_sendSMSTelemed;
	}
	
	/***************************************************************************
	 * Create Dialog Method
	 **************************************************************************/

	private DlgARCardRemark getDlgARCardRemarkForPayment() {
		if (dlgARCardRemarkForPayment == null) {
			dlgARCardRemarkForPayment = new DlgARCardRemark(getMainFrame()) {
				@Override
				public void post(String source, String actCode, String actId) {
					getDlgPaymentInstruction().showDialog(getRightJText_SlipNo().getText());
				}
			};
		}
		return dlgARCardRemarkForPayment;
	}

	private DlgPaymentInstruction getDlgPaymentInstruction() {
		if (dlgPaymentInstruction == null) {
			dlgPaymentInstruction = new DlgPaymentInstruction(getMainFrame()) {
				public void dispose() {
					super.dispose();
					showPayment();
				}
			};
		}
		return dlgPaymentInstruction;
	}

	private DlgARCardTypeSel getDlgARCardTypeSel() {
		dlgARCardTypeSel = new DlgARCardTypeSel(Factory.getInstance().getMainFrame())  {
			@Override
			public void post(String ArcCode, String ARCardType, String ARCardName, String ARCardDesc, String ARCardCode) {
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
			}

			@Override
			public void dispose() {
				if (HKAH_VALUE.equals(getUserInfo().getSiteCode())) {
					getRightJCombo_ARCompanyCode().setText(null);
					getRightJText_ARCardType().resetText();
					super.dispose();
					getRightJCombo_ARCompanyCode().focus();
				} else {
					getRightJText_PolicyNo().focus();
					super.dispose();
				}
			}
		};

		return dlgARCardTypeSel;
	}

	private DlgARCardRemark getDlgARCardRemark() {
		if (dlgARCardRemark == null) {
			dlgARCardRemark = new DlgARCardRemark(getMainFrame()) {
				@Override
				public void post(String source, String actCode, String actId) {
					// return to child class
					dispose();
					if (isContinue()) {
						getStatementDialog();
					}
				}

				@Override
				public void dispose() {
					getRightJText_PolicyNo().focus();
					super.dispose();
				}
			};
		}
		return dlgARCardRemark;
	}
	private DlgCalRefItem getDlgCalRefItem() {
		if (dlgCalRefItem == null) {
			dlgCalRefItem = new DlgCalRefItem(getMainFrame());
		}
		return dlgCalRefItem;
	}

	private DlgCalSpec getDlgCalSpec() {
		if (dlgCalSpec == null) {
			dlgCalSpec = new DlgCalSpec(getMainFrame());
		}
		return dlgCalSpec;
	}

	private DlgChangeACM getDlgChangeACM() {
		if (dlgChangeACM == null) {
			dlgChangeACM = new DlgChangeACM(getMainFrame()) {
				@Override
				public void post() {
					getFetchDetail(true);
				}
			};
		}
		return dlgChangeACM;
	}

	private DlgChangeAmount getDlgChangeAmount() {
		if (dlgChangeAmount == null) {
			dlgChangeAmount = new DlgChangeAmount(getMainFrame()) {
				@Override
				public void post(String slipNo) {
					setParameter("SlpNo", slipNo);
					refreshAction();
				}
			};
		}
		return dlgChangeAmount;
	}

	private DlgChgRptLvl getDlgChgRptLvl() {
		if (dlgChgRptLvl == null) {
			dlgChgRptLvl = new DlgChgRptLvl(getMainFrame()) {
				@Override
				public void post() {
					refreshAction();
				}
			};
		}
		return dlgChgRptLvl;
	}

	private DlgConPceChange getDlgConPceChange() {
		if (dlgConPceChange == null) {
			dlgConPceChange = new DlgConPceChange(getMainFrame()) {
				@Override
				public void post() {
					if (isNewGrt()) {
						if ((memArcCode != null && memArcCode.length() > 0) &&
								(getRightJCombo_ARCompanyCode().getText().trim() != null && getRightJCombo_ARCompanyCode().getText().trim().length() > 0)) {
							MessageBoxBase.confirm(MSG_PBA_SYSTEM, "Is a new further guarantee ? ", new Listener<MessageBoxEvent>() {
								@Override
								public void handleEvent(MessageBoxEvent be) {
									if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
										memPrintDate = EMPTY_VALUE;
									}
									doPostTrasactions();
								}
							});
						} else {
							memPrintDate = EMPTY_VALUE;
							doPostTrasactions();
						}
					} else {
						doPostTrasactions();
					}
				}
			};
		}
		return dlgConPceChange;
	}

	private DlgEnterConfinement getDlgEnterConfinement() {
		if (dlgEnterConfinement == null) {
			dlgEnterConfinement = new DlgEnterConfinement(getMainFrame()) {
				@Override
				protected void doOpenOBCert() {
					dlgEnterConfinement.dispose();
					setParameter("SlpNo", slpNo);
					setParameter("patNo",getRightJText_PatientNo().getText());
					setParameter("currMode","newCert");
					showPanel(new PrintOBCert());
				}
			};
		}
		return dlgEnterConfinement;
	}

	private DlgIPOfficialReceipt getDlgIPOfficialReceipt() {
		if (dlgIPOfficialReceipt == null) {
			dlgIPOfficialReceipt = new DlgIPOfficialReceipt(getMainFrame());
		}
		return dlgIPOfficialReceipt;
	}

	private DlgIPStmtORIPStmtSmy getDlgIPStmtORIPStmtSmy() {
		if (dlgIPStmtORIPStmtSmy == null) {
			dlgIPStmtORIPStmtSmy = new DlgIPStmtORIPStmtSmy(getMainFrame());
		}
		return dlgIPStmtORIPStmtSmy;
	}

	private DlgIPStmtOROffReceipt getDlgIPStmtOROffReceipt() {
		if (dlgIPStmtOROffReceipt == null) {
			dlgIPStmtOROffReceipt = new DlgIPStmtOROffReceipt(getMainFrame());
		}
		return dlgIPStmtOROffReceipt;
	}

	private DlgOPDayCaseStatement getDlgOPDayCaseStatement() {
		if (dlgOPDayCaseStatement == null) {
			dlgOPDayCaseStatement = new DlgOPDayCaseStatement(getMainFrame());
		}
		return dlgOPDayCaseStatement;
	}

	private DlgChrgDayCase getDlgChrgDayCase() {
		if (dlgChrgDayCase == null) {
			dlgChrgDayCase = new DlgChrgDayCase(getMainFrame());
		}
		return dlgChrgDayCase;
	}

	private DlgReminderLetter getDlgReminderLetter() {
		if (dlgReminderLetter == null) {
			dlgReminderLetter = new DlgReminderLetter(getMainFrame());
		}
		return dlgReminderLetter;
	}

	// Move Item to Ref Dialog
	private DlgPkgCode getDlgPkgCodeMvItm2Ref() {
		if (dlgPkgCodeMvItm2Ref == null) {
			dlgPkgCodeMvItm2Ref = new DlgPkgCode(getMainFrame()) {
				@Override
				public void afterVerifyAction(final String movePkgCode, final String movePkgStnSeq) {
					if (movePkgCode == null || movePkgCode.length() == 0) {
						Factory.getInstance().addErrorMessage("Invalid package code.");
					} else {
						QueryUtil.executeMasterAction(getUserInfo(), "MOVEITEMTOREF", QueryUtil.ACTION_APPEND,
								new String[] {slpNo, getListTable().getSelectedRowContent()[STNID2_COL], null, movePkgCode, getUserInfo().getUserID()},
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									getFetchDetail(true);
									setVisible(false);
									Factory.getInstance().addInformationMessage("Move Succeed.");
								} else {
									Factory.getInstance().addErrorMessage(mQueue, getPkgCode());
								}
							}
						});
					}
				}
			};
		}
		return dlgPkgCodeMvItm2Ref;
	}

	// Move Package to Ref Dialog
	private DlgPkgCode getDlgPkgCodeMvPkg2Ref() {
		if (dlgPkgCodeMvPkg2Ref == null) {
			dlgPkgCodeMvPkg2Ref = new DlgPkgCode(getMainFrame()) {
				@Override
				public void afterVerifyAction(final String movePkgCode, final String movePkgStnSeq) {
					if (movePkgCode == null || movePkgCode.length() == 0) {
						Factory.getInstance().addErrorMessage("Invalid package code.");
					} else {
						QueryUtil.executeMasterAction(getUserInfo(), "MOVEITEMTOREF", QueryUtil.ACTION_APPEND,
								new String[] {slpNo, null, getListTable().getSelectedRowContent()[PKGCODE_COL], movePkgCode, getUserInfo().getUserID()},
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									getFetchDetail(true);
									setVisible(false);
									Factory.getInstance().addInformationMessage("Move Succeed.");
								} else {
									Factory.getInstance().addErrorMessage("Move Fail.", getPkgCode());
								}
							}
						});
					}
				}
			};
		}
		return dlgPkgCodeMvPkg2Ref;
	}

	private DlgReason getDlgReason() {
		if (dlgReason == null) {
			dlgReason = new DlgReason(getMainFrame()) {
				@Override
				public void post(String stnID, String stnxref, String stnSeq,
						boolean isDIReported, boolean isDIPayed, boolean isDIPayedDr, String cancelReason, boolean isCancelItem) {
					doCancelItem(stnID, stnxref, stnSeq, isDIReported, isDIPayed, isDIPayedDr, cancelReason, isCancelItem);
				}
			};
		}
		return dlgReason;
	}

	private DlgSlipRemark getDlgSlipRemark() {
		if (dlgSlipRemark == null) {
			dlgSlipRemark = new DlgSlipRemark(getMainFrame());
		}
		return dlgSlipRemark;
	}

	private DlgTransOT getDlgTransOT() {
		if (dlgTransOT == null) {
			dlgTransOT = new DlgTransOT(getMainFrame());
		}
		return dlgTransOT;
	}

	private DlgTxUpdateBed getDlgTxUpdateBed() {
		if (dlgTxUpdateBed == null) {
			dlgTxUpdateBed = new DlgTxUpdateBed(getMainFrame()) {
				public void post(String bedCode) {
					// unlock bed
					unlockRecord("Bed", bedCode);

					refreshAction();
				}
			};
		}
		return dlgTxUpdateBed;
	}

	private DlgUpdateDoctor getDlgUpdateDoctor() {
		if (dlgUpdateDoctor == null) {
			dlgUpdateDoctor = new DlgUpdateDoctor(getMainFrame()) {
				public void post(String docCode, String docName) {
					getRightJText_Doctor().setText(docCode);
					getRightJText_DoctorName().setText(docName);

					refreshAction();
				}
			};
		}
		return dlgUpdateDoctor;
	}

	private DlgTxHistory getDlgTxHistory() {
		if (dlgTxHistory == null) {
			dlgTxHistory = new DlgTxHistory(getMainFrame());
		}
		return dlgTxHistory;
	}

	private DlgSlipList getDlgSlipList() {
		if (dlgSlipList == null) {
			dlgSlipList = new DlgSlipList(getMainFrame()) {
				@Override
				public void post(String newSlipNo) {
					if (!newSlipNo.equals(slpNo)) {
						oldSlpNo = slpNo;
						slpNo = newSlipNo;
						lockRecord("Slip", slpNo);
					} else {
						Factory.getInstance().addErrorMessage("Select another slip, please!");
					}
				}
			};
		}
		return dlgSlipList;
	}

	private DlgPatientAlert getDlgPatientAlert() {
		if (dlgPatientAlert == null) {
			dlgPatientAlert = new DlgPatientAlert(getMainFrame());
		}
		return dlgPatientAlert;
	}

	private DlgOSBillAlert getDlgOSBillAlert() {
		if (dlgOSBillAlert == null) {
			dlgOSBillAlert = new DlgOSBillAlert(getMainFrame());
		}
		return dlgOSBillAlert;
	}

	private DlgBudgetEstBase getDlgBudgetEst() {
		if (dlgBudgetEst == null) {
			dlgBudgetEst = new DlgBudgetEstBase(getMainFrame()) {
				@Override
				public void post(String srcNo,boolean isBE) {
					memFESTID = srcNo;
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

	protected void listTableContentPrev() {
		lastSelectedItemKey = getListTable().getLastSelectedItemKey();
	}

	protected void listTableContentPost() {
		getListTable().getView().refresh(false);
		// refresh button after update table
		refreshButton();
		if (!isModify()) {
			defaultFocus();
		} else {
			if (isEmptySource) {
				getRightJCombo_Source().focus();
				getRightJCombo_Source().markInvalid("Empty Value");
			} else {
				defaultFocus();
			}
			isEmptySource = false;
		}

		if (lastSelectedItemKey != null) {
			getListTable().setLastSelectedItemKey(lastSelectedItemKey);
			getListTable().reSelection(true);
		}

		getMainFrame().setLoading(false);
	}

	public void actionValidationSuccess(MessageQueue mQueue) {
		if (!mQueue.success() || ZERO_VALUE.equals(mQueue.getContentField()[0])) {
			Factory.getInstance().addErrorMessage("Arcode does not exist."," PBA-[Transaction Detail]", getRightJCombo_ARCompanyCode());
			actionValidationReady(false);
		} else {
			actionValidationPost();
		}
	}

	public void setReportLang(String lang) {
		this.lang = lang;
	}
	
	private void sendTelemedURLSMS() {
		String url = getSysParameter("SENDSMSURL");
		if (url == null) {
			Factory.getInstance().addErrorMessage("Cannot get send SMS URL. Please contact IT support.");
		} else {
			final Window sendTelemedURLSMSWin = new Window();
			sendTelemedURLSMSWin.setSize(0, 0);
			sendTelemedURLSMSWin.setPosition(-1000, -1000);	//hidden
			sendTelemedURLSMSWin.setHeadingHtml("Telemedicine send SMS - Zoom URL");
			
			final FormPanel sendTelemedURLSMSPanel = new FormPanel();
			
			final TextField<String> module = new TextField<String>();
			module.setName("module");
			module.setValue("TELEMEDURL");
			sendTelemedURLSMSPanel.add(module);
	
			final TextField<String> patNo = new TextField<String>();
			patNo.setName("patno");
			patNo.setValue(getRightJText_PatientNo().getText());
			sendTelemedURLSMSPanel.add(patNo);
			
			final TextField<String> slipNo = new TextField<String>();
			slipNo.setName("slipNo");
			slipNo.setValue(getRightJText_SlipNo().getText());
			sendTelemedURLSMSPanel.add(slipNo);
	
			final TextField<String> userID = new TextField<String>();
			userID.setName("userid");
			userID.setValue(getUserInfo().getUserID());
			sendTelemedURLSMSPanel.add(userID);
	
			sendTelemedURLSMSPanel.setAction(url);
			sendTelemedURLSMSPanel.setMethod(Method.GET);
			sendTelemedURLSMSPanel.addListener(Events.Submit, new Listener<FormEvent>() {
				@Override
				public void handleEvent(FormEvent be) {
					sendTelemedURLSMSWin.hide();
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
					Factory.getInstance().addInformationMessage(resultMsg, "Send SMS - Zoom URL result", new Listener<MessageBoxEvent>() {
						@Override
						public void handleEvent(MessageBoxEvent be) {
						}
					});
				}
			});
			sendTelemedURLSMSWin.add(sendTelemedURLSMSPanel);
			sendTelemedURLSMSWin.show();
			sendTelemedURLSMSPanel.submit();
		}
	}
}