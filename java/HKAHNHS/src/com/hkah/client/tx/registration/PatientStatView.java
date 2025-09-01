package com.hkah.client.tx.registration;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.store.ListStore;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.form.RadioGroup;
import com.extjs.gxt.ui.client.widget.grid.ColumnConfig;
import com.extjs.gxt.ui.client.widget.grid.ColumnData;
import com.extjs.gxt.ui.client.widget.grid.Grid;
import com.google.gwt.dom.client.Element;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.combobox.ComboBookType;
import com.hkah.client.layout.combobox.ComboDeposit;
import com.hkah.client.layout.combobox.ComboShowType;
import com.hkah.client.layout.combobox.ComboSortPatStatPara;
import com.hkah.client.layout.combobox.ComboSortPatStatPrePara;
import com.hkah.client.layout.combobox.ComboWard;
import com.hkah.client.layout.dialog.DialogBase;
import com.hkah.client.layout.dialog.DlgSelectSlip;
import com.hkah.client.layout.label.LabelSmallBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.panel.TabbedPaneBase;
import com.hkah.client.layout.radiobutton.RadioButtonBase;
import com.hkah.client.layout.table.BufferedTableList;
import com.hkah.client.layout.table.GeneralGridCellRenderer;
import com.hkah.client.layout.table.TableData;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextDateWithCheckBox;
import com.hkah.client.layout.textfield.TextDoctorSearch;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.tx.ot.OTAppointmentBrowse;
import com.hkah.client.tx.transaction.TransactionDetail;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.Report;
import com.hkah.shared.constants.ConstantsGlobal;
import com.hkah.shared.constants.ConstantsRegistration;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class PatientStatView extends MasterPanel {

	private final static String PATIENTSTATVIEW_INPAT_TXCODE = "STATUSVIEWINPAT";
	private final static String PATIENTSTATVIEW_PREBOOK_TXCODE = "STATUSVIEWPB";

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		if (getTabbedPane().getSelectedIndex() == 0) {
			return PATIENTSTATVIEW_INPAT_TXCODE;
		} else if (getTabbedPane().getSelectedIndex() == 1 || (getTabbedPane().getSelectedIndex() == 2 && hasDayCase)) {
			return PATIENTSTATVIEW_PREBOOK_TXCODE;
		} else {
			return ConstantsTx.PATIENTSTATVIEW_TXCODE;
		}
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.PATIENTSTATVIEW_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
			"A",
			"Patient No",
			"Patient Name",
			"Chi. Name",
			"Bed Code",
			"Phone Ext.",
			"Spc Request",
			"Slip No",
			"Reg. Date",
			"Adm. Doctor",
			"Alt. Doctor",
			"Age",
			"Sex",
			"Class",
			"Ward",
			"In-patient Remark",
			"",
			""
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				25,
				60,
				90,
				70,
				90,
				60,
				(YES_VALUE.equals(getSysParameter("PBkAMCCMP")))?40:0,//special request
				80,
				110,
				80,
				80,
				35,
				30,
				40,
				40,
				150,
				0,
				0
		};
	}

	private BasePanel rightPanel = null;
	private BasePanel leftPanel = null;

	private int rtvOldTabIndex = 0;
	private TabbedPaneBase TabbedPane = null;
	private BasePanel PSViewPanel = null;

	private FieldSetBase ParaPanel = null;
	private LabelSmallBase PatientNoDesc = null;
	private TextPatientNoSearch PatientNo = null;
	private LabelSmallBase SurNameDesc = null;
	private TextString SurNameCode = null;
	private LabelSmallBase GivenNameDesc = null;
	private TextString GivenName = null;
	private LabelSmallBase WardDesc = null;
	private ComboWard Ward = null;
	private LabelSmallBase DrCodeDesc = null;
	private TextDoctorSearch DrCode = null;
	private LabelSmallBase AdmFromDesc = null;
	private TextDateWithCheckBox AdmFrom = null;
	private LabelSmallBase AdmToDesc = null;
	private TextDateWithCheckBox AdmTo = null;
	private LabelSmallBase SortByDesc = null;
	private ComboSortPatStatPara SortBy = null;
	private JScrollPane patientScrollPanel = null;

	private FieldSetBase PatStatusPanel = null;
	private TableList PatStatusTable = null;
	private JScrollPane PatStatusScrollPane = null;

	private ButtonBase BedDrTrans = null;
	private ButtonBase WardEntry = null;
	private ButtonBase CurIProfile = null;
	private ButtonBase Billing = null;

	private LabelSmallBase PatCount = null;
	private LabelSmallBase PatIP_RetrDesc = null;
	private TextReadOnly PatIP_Retr = null;
	private LabelSmallBase PatPB_RetrDesc = null;
	private TextReadOnly PatPB_Retr = null;
	private LabelSmallBase PatIP_TotalDesc = null;
	private TextReadOnly PatIP_Total = null;
	private LabelSmallBase PatIP_Total_PBDesc = null;
	private TextReadOnly PatIP_Total_PB = null;

	private BasePanel PreBookPanel = null;
	private BasePanel PreParaPanel = null;
	private BasePanel DCPreParaPanel = null;
	private BasePanel DCPreBookPanel = null;
	private LabelSmallBase PrePatientNoDesc = null;
	private TextPatientNoSearch PrePatientNo = null;
	private LabelSmallBase PreDocDesc = null;
	private TextString PreDoc = null;
	private LabelSmallBase PreNameDesc = null;
	private TextString PreName = null;
	private LabelSmallBase PreChiNameDesc = null;
	private TextString PreChiName = null;
	private LabelSmallBase PreDrCodeDesc = null;
	private TextDoctorSearch PreDrCode = null;
	private LabelSmallBase PreDrNameDesc = null;
	private TextString PreDrName = null;
	private LabelSmallBase PreBookTypeDesc = null;
	private ComboBookType PreBookType = null;
	private LabelSmallBase PreSortByDesc = null;
	private ComboSortPatStatPrePara PreSortBy = null;
	private LabelSmallBase PreSchdADateFromDesc = null;
	private TextDate PreSchdADateFrom = null;
	private LabelSmallBase PreSchdADateToDesc = null;
	private TextDateWithCheckBox PreSchdADateTo = null;
	private LabelSmallBase PreWardDesc = null;
	private ComboWard PreWard = null;
	private LabelSmallBase PreCancelDesc = null;
	private ComboShowType PreCancel = null;
	private LabelSmallBase PreOTCaseDesc = null;
	private ComboShowType PreOTCase = null;
	private LabelSmallBase PreOrdDateFromDesc = null;
	private TextDateWithCheckBox PreOrdDateFrom = null;
	private LabelSmallBase PreOrdDateToDesc = null;
	private TextDateWithCheckBox PreOrdDateTo = null;
	private LabelSmallBase PreDepositDesc = null;
	private ComboDeposit PreDeposit = null;
	private LabelSmallBase PreDeclinDesc = null;
	private ComboShowType PreDeclin = null;

	private LabelSmallBase DCPrePatientNoDesc = null;
	private TextPatientNoSearch DCPrePatientNo = null;
	private LabelSmallBase DCPreDocDesc = null;
	private TextString DCPreDoc = null;
	private LabelSmallBase DCPreNameDesc = null;
	private TextString DCPreName = null;
	private LabelSmallBase DCPreChiNameDesc = null;
	private TextString DCPreChiName = null;
	private LabelSmallBase DCPreDrCodeDesc = null;
	private TextDoctorSearch DCPreDrCode = null;
	private LabelSmallBase DCPreDrNameDesc = null;
	private TextString DCPreDrName = null;
	private LabelSmallBase DCPreBookTypeDesc = null;
	private ComboBookType DCPreBookType = null;
	private LabelSmallBase DCPreSortByDesc = null;
	private ComboSortPatStatPrePara DCPreSortBy = null;
	private LabelSmallBase DCPreSchdDateFromDesc = null;
	private TextDate DCPreSchdDateFrom = null;
	private LabelSmallBase DCPreSchdDateToDesc = null;
	private TextDateWithCheckBox DCPreSchdDateTo = null;
	private LabelSmallBase DCPreWardDesc = null;
	private ComboWard DCPreWard = null;
	private LabelSmallBase DCPreCancelDesc = null;
	private ComboShowType DCPreCancel = null;
	private LabelSmallBase DCPreOTCaseDesc = null;
	private ComboShowType DCPreOTCase = null;
	private LabelSmallBase DCPreOrdDateFromDesc = null;
	private TextDateWithCheckBox DCPreOrdDateFrom = null;
	private LabelSmallBase DCPreOrdDateToDesc = null;
	private TextDateWithCheckBox DCPreOrdDateTo = null;
	private LabelSmallBase DCPreDepositDesc = null;
	private ComboDeposit DCPreDeposit = null;
	private LabelSmallBase DCPreDeclinDesc = null;
	private ComboShowType DCPreDeclin = null;

	private TableList PreListTable = null;
	private TableList DCPreListTable = null;
//	private JScrollPane PreScrollPane = null;

	private ButtonBase PreIPReg = null;
	private ButtonBase PreOTAB = null;
	private ButtonBase PrePBL = null;
	private ButtonBase PreDCReg = null;
	private LabelSmallBase PreCount = null;
	private LabelSmallBase PreDCCount = null;
	private LabelSmallBase PreIP_RetrDesc = null;
	private TextReadOnly PreIP_Retr = null;
	private LabelSmallBase PrePB_RetrDesc = null;
	private TextReadOnly PrePB_Retr = null;
	private LabelSmallBase PreDC_RetrDesc = null;
	private TextReadOnly PreDC_Retr = null;
	private LabelSmallBase PreIP_TotalDesc = null;
	private TextReadOnly PreIP_Total = null;
	private LabelSmallBase PreIP_Total_PBDesc = null;
	private TextReadOnly PreIP_Total_PB = null;

	private BasePanel CheckDupPanel = null;
	private TableList CheckListTable = null;
	private JScrollPane JScrollPane_CheckListTable = null;
	private LabelSmallBase ChkCount = null;
	private LabelSmallBase ChkIP_RetrDesc = null;
	private TextReadOnly ChkIP_Retr = null;
	private LabelSmallBase ChkPB_RetrDesc = null;
	private TextReadOnly ChkPB_Retr = null;
	private LabelSmallBase ChkIP_TotalDesc = null;
	private TextReadOnly ChkIP_Total = null;
	private LabelSmallBase ChkIP_Total_PBDesc = null;
	private TextReadOnly ChkIP_Total_PB = null;

	private DialogBase AskDialog = null;
	private BasePanel CheckDupAskPanel = null;
	private LabelSmallBase AskLabel = null;
	private RadioGroup AskOptGroup = null;
	private RadioButtonBase AskOptA = null;
	private RadioButtonBase AskOptB = null;
	private ButtonBase AskYes = null;
	private ButtonBase AskNo = null;
	private ButtonBase PrintPicklist = null;

	private BasePanel jPanel = null;

	private boolean isBedEnable = false;
	private boolean isCurIProfileEnable = false;
	private boolean isBillingEnable = false;
	private boolean isPreIPRegEnable = false;
	private boolean isPreDCRegEnable = false;
	private boolean isShowAskDialog = true;
	private boolean isSearchDup = true;
	private DlgSelectSlip dlgSelectSlip = null;

	private String paraFromWhere = null;
	private final int GrdPbCol_Status = 1;
	private final int GrdPbCol_BookingNo = 2;
	private final int GrdPbCol_PatNo = 3;
	private final int GrdPbCol_PatName = 4;
	private final int GrdPbCol_PatCName = 5;
	private final int GrdPbCol_DocName = 6;
	private final int GrdPbCol_HospDate = 11;
//	private final int GrdPbCol_PatEDC = 12;
//	private final int GrdPbCol_Rmk = 13;
	private final int GrdPbCol_PatIDNo = 14;
//	private final int GrdPbCol_EstGiven = 15;
	//private final int GrdPbCol_BE = 20;
	private final int GrdPbCol_PBRmk = 21;
	private final int GrdPbCol_isRefused = 30;
	private final int GrdPbCol_PbPid = 31;
	private final int GrdPbCol_ForDelivery = 36;
	private final int GrdPbCol_PatFName = 37;
	private final int GrdPbCol_PatGName = 38;

//	private String vfromOTFname = null;
//	private String vfromOTGname = null;
//	private String vFormOTSetName = null;

	private String lpbpid = null;
	private boolean formActivate = false;
	private boolean bFromSelectSlip = false;
	private String lCurRegId = null;
	private String lPreRegid = null;
	private boolean searchSingleDup = false;
	private boolean hasDayCase = false;

	/**
	 * This method initializes
	 *
	 */
	public PatientStatView() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		setLeftAlignPanel();
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		setParameter("lotPBPID", ZERO_VALUE);

		hasDayCase = HKAH_VALUE.equals(getUserInfo().getSiteCode());

//		getPreListTable().setColumnClass(15, new ComboYN(), false);

//		vfromOTFname = getParameter("fromOTFname");
//		vfromOTGname = getParameter("fromOTGname");
//		vFormOTSetName = getParameter("FormOTSetName");

		lpbpid = ZERO_VALUE;
		lPreRegid = null;

		int obdtf = 0;
		try {
			obdtf = Integer.parseInt(getSysParameter("OBDTF"));
		} catch (Exception e) {
			obdtf = 0;
		}

//	    getAdmFrom().setText(getMainFrame().getServerDate());
//	    getAdmTo().setText(getMainFrame().getServerDate());
		getAdmFrom().setText(null);
		getAdmTo().setText(null);

		getPreSchdADateFrom().setText(DateTimeUtil.getRollDate(getMainFrame().getServerDate(), obdtf * -1));
		getDCPreSchdDateFrom().setText(DateTimeUtil.getRollDate(getMainFrame().getServerDate(), obdtf * -1));
//		getPreSchdADateTo().setText(getMainFrame().getServerDate());
		getPreSchdADateTo().setText(null);
		getDCPreSchdDateTo().setText(null);

//	    getPreOrdDateTo().setText(getMainFrame().getServerDate());
//		getPreOrdDateFrom().setText(getMainFrame().getServerDate());
		getPreOrdDateTo().setText(null);
		getPreOrdDateFrom().setText(null);
		getDCPreOrdDateTo().setText(null);
		getDCPreOrdDateFrom().setText(null);
		getPatIP_Retr().setText(null);
		getPreIP_Retr().setText(null);
		getChkIP_Retr().setText(null);
		getPatPB_Retr().setText(null);
		getPrePB_Retr().setText(null);
		getPreDC_Retr().setText(null);
		getChkPB_Retr().setText(null);

		getTabbedPane().setSelectedIndex(0);
// -- pre-loading value
		isCurIProfileEnable = !isDisableFunction("btnAlert", "srhPatStsView");
		isBillingEnable = !isDisableFunction("cmdBilling", "srhPatStsView");
		isPreIPRegEnable = !isDisableFunction("btnPatProfile", "srhPatStsView");
		isPreDCRegEnable = !isDisableFunction("btnPatProfile", "srhPatStsView");
		isBedEnable = !isDisableFunction("btnBed", "srhPatStsView");
		getBilling().setEnabled(isBillingEnable);

		formActivate = true;

		if ("OT".equals(getParameter("FROM"))) {
			paraFromWhere = "OT";
			if ("T".equals(getParameter("CallBackPSV"))) {
				getTabbedPane().setSelectedIndex(1);
				getPreListTable().focus();
				searchAction();
			}
			getPreOTAB().setEnabled(false);
		} else {
			paraFromWhere = EMPTY_VALUE;
			if ("True".equals(getParameter("NewPB")) ||
					"T".equals(getParameter("NewPB")) && getTabbedPane().getSelectedIndex() == 1) {
				getTabbedPane().setSelectedIndex(1);
				getPreListTable().focus();
				searchAction();
			}
		}

		enableButton(null);
	}

	public void rePostAction() {
		formActivate = true;
		lPreRegid = null;
		searchAction();
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public Component getDefaultFocusComponent() {
		if (getTabbedPane().getSelectedIndex() == 1) {
			if (getPreListTable().getRowCount() > 0) {
				return getPreListTable();
			} else {
				return getPrePatientNo();
			}
		} else if (getTabbedPane().getSelectedIndex() == 2 && hasDayCase) {
			if (getDCPreListTable().getRowCount() > 0) {
				return getDCPreListTable();
			} else {
				return getDCPrePatientNo();
			}
		} else {
			if (getListTable().getRowCount() > 0) {
				return getListTable();
			} else {
				return getPatientNo();
			}
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
		if (getTabbedPane().getSelectedIndex() == 0) {
			if (!getAdmFrom().isEmpty() && !getAdmFrom().isValid()) {
				return false;
			} else if (!getAdmTo().isEmpty() && !getAdmTo().isValid()) {
				return false;
			} else if (!getAdmFrom().isEmpty() && !getAdmTo().isEmpty() && DateTimeUtil.dateDiff(getAdmFrom().getText(), getAdmTo().getText()) > 0) {
				Factory.getInstance().addErrorMessage("From Date must smaller than or equal to To Date", getAdmFrom());
				getAdmFrom().resetText();
				return false;
			} else {
				return true;
			}
		} else if (getTabbedPane().getSelectedIndex() == 1) {
			if (getPreSchdADateFrom().getText().isEmpty()) {
				Factory.getInstance().addErrorMessage("Please input valid Schd Adm Date Fr", getPreSchdADateFrom());
				return false;
			}
			return true;
		} else if (getTabbedPane().getSelectedIndex() == 2 && hasDayCase) {
			if (getDCPreSchdDateFrom().getText().isEmpty()) {
				Factory.getInstance().addErrorMessage("Please input valid Schd Adm Date Fr", getDCPreSchdDateFrom());
				return false;
			}
			return true;
		} else {
			return true;
		}
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		if (getTabbedPane().getSelectedIndex() == 0) {
			String sorter = "patno, patname, wrdcode, bedcode, doccode_reg, regdate,ACMCODE";
			if ("PN".equals(getSortBy().getText())) {
				sorter="patno";
			}
			if ("SN".equals(getSortBy().getText()) || "GN".equals(getSortBy().getText())) {
				sorter="patname";
			}
			if ("WD".equals(getSortBy().getText())) {
				sorter="wrdcode";
			}
			if ("BC".equals(getSortBy().getText())) {
				sorter="bedcode";
			}
			if ("DN".equals(getSortBy().getText())) {
				sorter="doccode_reg";
			}
			if ("AF".equals(getSortBy().getText())) {
				sorter="regdate";
			}
			if ("CL".equals(getSortBy().getText())) {
				sorter="ACMCODE";
			}
			return new String[] {
					getPatientNo().getText(),
					getSurNameCode().getText(),
					getGivenName().getText(),
					getWard().getText(),
					getDrCode().getText(),
					getAdmFrom().getText(),
					getAdmTo().getText(),
					sorter
			};
		} else if (getTabbedPane().getSelectedIndex() == 1) {
			return new String[] {
					getPrePatientNo().getText(),
					getPreName().getText(),
					getPreDrCode().getText(),
					getPreDrName().getText(),
					getPreWard().getText(),
					getPreDoc().getText(),
					getPreSchdADateFrom().getText(),
					getPreSchdADateTo().getText(),
					getPreBookType().getText(),
					PreOrdDateFrom.getText(),
					getPreOrdDateTo().getText(),
					getPreDeposit().getText(),
					getPreCancel().getText(),
					getPreOTCase().getText(),
					getPreDeclin().getText(),
					getPreSortBy().getText(),
					getPreChiName().getText(),
					"I"
			};
		} else if (getTabbedPane().getSelectedIndex() == 2 && hasDayCase) {
			return new String[] {
					getDCPrePatientNo().getText(),
					getDCPreName().getText(),
					getDCPreDrCode().getText(),
					getDCPreDrName().getText(),
					getDCPreWard().getText(),
					getDCPreDoc().getText(),
					getDCPreSchdDateFrom().getText(),
					getDCPreSchdDateTo().getText(),
					getDCPreBookType().getText(),
					getDCPreOrdDateFrom().getText(),
					getDCPreOrdDateTo().getText(),
					getDCPreDeposit().getText(),
					getDCPreCancel().getText(),
					getDCPreOTCase().getText(),
					getDCPreDeclin().getText(),
					getDCPreSortBy().getText(),
					getDCPreChiName().getText(),
					"D"
			};
		} else {
			String sorter = "patno, patname, wrdcode, bedcode, doccode_reg, regdate, ACMCODE";
			if ("PN".equals(getSortBy().getText())) {
				sorter="patno";
			}
			if ("SN".equals(getSortBy().getText()) || "GN".equals(getSortBy().getText())) {
				sorter="patname";
			}
			if ("WD".equals(getSortBy().getText())) {
				sorter="wrdcode";
			}
			if ("BC".equals(getSortBy().getText())) {
				sorter="bedcode";
			}
			if ("DN".equals(getSortBy().getText())) {
				sorter="doccode_reg";
			}
			if ("AF".equals(getSortBy().getText())) {
				sorter="regdate";
			}
			if ("CL".equals(getSortBy().getText())) {
				sorter="ACMCODE";
			}
			return new String[] {
					getPatientNo().getText(),
					getSurNameCode().getText(),
					getGivenName().getText(),
					getWard().getText(),
					getDrCode().getText(),
					getAdmFrom().getText(),
					getAdmTo().getText(),
					sorter
			};
		}
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
	// trigger by getListTable().onSelectionChanged()
	@Override
	protected void getFetchOutputValues(String[] outParam) {
		lCurRegId = null;
		if (getListTable().getSelectedRow() != -1) {
			lCurRegId = getListTable().getSelectedRowContent()[16];
		}
		getBilling().setEnabled(false);

		if (getListTable().getRowCount() > 0) {
			if (isBillingEnable) {
				getBilling().setEnabled(true);
			}
			if (!lCurRegId.equals(lPreRegid) && lCurRegId != null) {
				getPatStatusTable().setListTableContent("STATUSVIEWPS", new String[] { lCurRegId });
			}
			if (isCurIProfileEnable) {
				getCurIProfile().setEnabled(true);
			}
		} else {
			getPatStatusTable().removeAllRow();
			getCurIProfile().setEnabled(false);
		}

		lPreRegid = lCurRegId;
	}

	/* >>> ~15~ Set Fetch Output Results ============================== <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return new String[] {};
	}

	/* >>> ~16.1~ Set Action Output Parameters =========================== <<< */
	@Override
	protected void getNewOutputValue(String returnValue) {}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected void proExitPanel() {
		paraFromWhere = EMPTY_VALUE;
		getTabbedPane().setSelectedIndex(0);
	}

	@Override
	protected void enableButton(String mode) {
		disableButton();
		getWardEntry().setEnabled(false);

		if (getTabbedPane().getSelectedIndex() < 2 + (hasDayCase ? 1 : 0)) {
			getSearchButton().setEnabled(true);
			getAppendButton().setEnabled(!isDisableFunction("TB_INSERT", "PatientStatView"));

			if (getTabbedPane().getSelectedIndex() == 1) {
				if (getPreListTable().getRowCount() > 0 || getPreListTable().getSelectedRow() > 0) {
					getModifyButton().setEnabled(!isDisableFunction("TB_MODIFY", "PatientStatView") &&
							ConstantsGlobal.PB_NORMAL_STS.equals(getPreListTable().getSelectedRowContent()[GrdPbCol_Status]));
					getDeleteButton().setEnabled(!isDisableFunction("TB_DELETE", "PatientStatView") &&
							ConstantsGlobal.PB_NORMAL_STS.equals(getPreListTable().getSelectedRowContent()[GrdPbCol_Status]));
				} else {
					getModifyButton().setEnabled(false);
					getDeleteButton().setEnabled(false);
				}
			} else if (getTabbedPane().getSelectedIndex() == 2 && hasDayCase) {
				if (getDCPreListTable().getRowCount() > 0 || getDCPreListTable().getSelectedRow() > 0) {
					getModifyButton().setEnabled(!isDisableFunction("TB_MODIFY", "PatientStatView") &&
							ConstantsGlobal.PB_NORMAL_STS.equals(getDCPreListTable().getSelectedRowContent()[GrdPbCol_Status]));
					getDeleteButton().setEnabled(!isDisableFunction("TB_DELETE", "PatientStatView") &&
							ConstantsGlobal.PB_NORMAL_STS.equals(getDCPreListTable().getSelectedRowContent()[GrdPbCol_Status]));
				} else {
					getModifyButton().setEnabled(false);
					getDeleteButton().setEnabled(false);
				}
			}
/*
			if (getTabbedPane().getSelectedIndex() == 1) {
				setPreBookButton();
			} else {
				setPatStatusViewButton();
			}
*/
		}

		getBilling().setEnabled(isBillingEnable && getListTable().getRowCount() > 0);
		getCurIProfile().setEnabled(isCurIProfileEnable);
	}

	@Override
	protected TableList getCurrentListTable() {
		if (getTabbedPane().getSelectedIndex() == 0) {
			return getListTable();
		} else if (getTabbedPane().getSelectedIndex() == 1) {
			return getPreListTable();
		} else if (getTabbedPane().getSelectedIndex() == 2 && hasDayCase) {
			return getDCPreListTable();
		} else {
			return getCheckListTable();
		}
	}

	@Override
	public int getColumnKey() {
		return 16;
	}

	@Override
	public void performListCallBackPost(MessageQueue mQueue) {
		String lastSelectedItemKey = null;
		if (mQueue != null) {
			lastSelectedItemKey = getListTable().getLastSelectedItemKey();
		}

		super.performListCallBackPost(mQueue);

		if (mQueue != null) {
			getListTable().setLastSelectedItemKey(lastSelectedItemKey);
			getListTable().reSelection(true);
		}
	}

	@Override
	protected void performListPost() {
		if (getTabbedPane().getSelectedIndex() == 0) {
			if (formActivate) {
				if ("True".equals(getParameter("bFromSelectSlip"))) {
					bFromSelectSlip = true;
				} else {
					bFromSelectSlip = false;
				}
				if (bFromSelectSlip) {
					QueryUtil.executeMasterBrowse(getUserInfo(),ConstantsTx.LOOKUP_TXCODE,
							new String[] {"slip", "COUNT(1)", "regid="+lCurRegId},
							new MessageQueueCallBack() {
						public void onPostSuccess(MessageQueue mQueue) {
							if (Integer.parseInt(mQueue.getContentField()[0]) > 1 && isBillingEnable) {
								getBilling().setEnabled(true);
							}
						}
					});
					bFromSelectSlip = false;
					setParameter("bFromSelectSlip", "False");
				}
				formActivate = false;
			}
		} else if (getTabbedPane().getSelectedIndex() == 1) {
			if (getPreListTable().getRowCount() > 0) {
				lpbpid = ZERO_VALUE;

				if (getPreListTable().getRowCount() > 1) {
					lpbpid = getPreListTable().getValueAt(0, GrdPbCol_PbPid);
				}
				if (lpbpid != null && lpbpid.length() > 0 && !ZERO_VALUE.equals(lpbpid)) {
					if (isPreIPRegEnable &&
							(EMPTY_VALUE.equals(getPreListTable().getValueAt(0, GrdPbCol_PbPid)) || getPreListTable().getValueAt(0, GrdPbCol_PbPid) == null)) {
						getPreIPReg().setEnabled(true);
					}
				} else {
					getPreIPReg().setEnabled(false);
				}

				if (lpbpid != null && lpbpid.length() > 0 && !ZERO_VALUE.equals(lpbpid) &&
						getPreListTable().getSelectedRowContent()[GrdPbCol_Status] != null &&
						getPreListTable().getSelectedRowContent()[GrdPbCol_Status].length() > 0 &&
						NO_VALUE.equals(getPreListTable().getSelectedRowContent()[GrdPbCol_Status])) {
					getPreOTAB().setEnabled(true);//!isDisableFunction("cmdOTApp", "srhPatStsView"));
				} else {
					getPreOTAB().setEnabled(false);
				}
			}
			getPreListTable().onSelectionChanged();
		} else if (getTabbedPane().getSelectedIndex() == 2 && hasDayCase) {
			if (getDCPreListTable().getRowCount() > 0) {
				lpbpid = ZERO_VALUE;

				if (getDCPreListTable().getRowCount() > 1) {
					lpbpid = getDCPreListTable().getValueAt(0, GrdPbCol_PbPid);
				}
				if (lpbpid != null && lpbpid.length() > 0 && !ZERO_VALUE.equals(lpbpid)) {
					if (isPreDCRegEnable &&
							(EMPTY_VALUE.equals(getDCPreListTable().getValueAt(0, GrdPbCol_PbPid)) || getDCPreListTable().getValueAt(0, GrdPbCol_PbPid) == null)) {
						getPreDCReg().setEnabled(true);
					}
				} else {
					getPreDCReg().setEnabled(false);
				}

				if (lpbpid != null && lpbpid.length() > 0 && !ZERO_VALUE.equals(lpbpid) &&
						getDCPreListTable().getSelectedRowContent()[GrdPbCol_Status] != null &&
						getDCPreListTable().getSelectedRowContent()[GrdPbCol_Status].length() > 0 &&
						NO_VALUE.equals(getDCPreListTable().getSelectedRowContent()[GrdPbCol_Status])) {
//					getPreOTAB().setEnabled(true);//!isDisableFunction("cmdOTApp", "srhPatStsView"));
				} else {
//					getPreOTAB().setEnabled(false);
				}
			}
			getDCPreListTable().onSelectionChanged();
		}
		super.performListPost();
		fillNumbers();
	}

	@Override
	public void searchAction() {
		if (getTabbedPane().getSelectedIndex() == 0) {
			getListTable().removeAllRow();
			getPatStatusTable().removeAllRow();
			super.searchAction();
		} else if (getTabbedPane().getSelectedIndex() == 1) {
			if (!triggerSearchField()) {
				getPreListTable().removeAllRow();
				super.searchAction();
			}
		} else if (getTabbedPane().getSelectedIndex() == 2 && hasDayCase) {
			if (!triggerSearchField()) {
				getDCPreListTable().removeAllRow();
				super.searchAction();
			}
		}
	}

	@Override
	public void appendAction() {
		resetParameter("PBPID");
		setParameter("From", paraFromWhere);
		setParameter("ACTIONTYPE", QueryUtil.ACTION_APPEND);
		Factory.getInstance().writeLogToLocal("[Pre Booking]PatientStatView Press Append :PBPID:"+getParameter("PBPID")
												+" getParameter(\"From\"):"+getParameter("From")
												+" getParameter(\"ACTIONTYPE\"):"+getParameter("ACTIONTYPE"));
		if (getTabbedPane().getSelectedIndex() == 2 && hasDayCase) {
			setParameter("BPBREGTYPE", "D");
			showPanel(new AddDCPreBooking());
		} else {
			setParameter("BPBREGTYPE", "I");
			showPanel(new AddPreBooking());
		}

	}

	@Override
	public void modifyAction() {
		if (getTabbedPane().getSelectedIndex() == 1) {
			if (getPreListTable().getSelectedRow() >= 0) {
				if (NO_VALUE.equals(getPreListTable().getSelectedRowContent()[GrdPbCol_Status])) {
					setParameter("ACTIONTYPE", QueryUtil.ACTION_MODIFY);
					setParameter("PBPID", getPreListTable().getSelectedRowContent()[GrdPbCol_PbPid]);
					setParameter("BPBREGTYPE", "I");
					showPanel(new AddPreBooking());
				}
			}
		} else if (getTabbedPane().getSelectedIndex() == 2 && hasDayCase) {
			if (getDCPreListTable().getSelectedRow() >= 0) {
				if (NO_VALUE.equals(getDCPreListTable().getSelectedRowContent()[GrdPbCol_Status])) {
					setParameter("ACTIONTYPE", QueryUtil.ACTION_MODIFY);
					setParameter("PBPID", getDCPreListTable().getSelectedRowContent()[GrdPbCol_PbPid]);
					setParameter("BPBREGTYPE", "D");
					showPanel(new AddDCPreBooking());
				}
			}
		}
	}

	@Override
	public void deleteAction() {
		if (getTabbedPane().getSelectedIndex() == 1) {
			if (getPreListTable().getSelectedRow() >= 0) {
				Factory.getInstance().isConfirmYesNoDialog("Confirm remove pre-booking?", new Listener<MessageBoxEvent>() {
					public void handleEvent(MessageBoxEvent be) {
						if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
							deletePB();
						}
					}
				});
			}
		} else if (getTabbedPane().getSelectedIndex() == 2 && hasDayCase) {
			if (getDCPreListTable().getSelectedRow() >= 0) {
				Factory.getInstance().isConfirmYesNoDialog("Confirm remove pre-booking?", new Listener<MessageBoxEvent>() {
					public void handleEvent(MessageBoxEvent be) {
						if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
							deletePB();
						}
					}
				});
			}
		}
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	private void billingAction() {
		if (getListTable().getSelectedRow() == -1) {
			Factory.getInstance().addErrorMessage("Please select a record.");
			return;
		}

		QueryUtil.executeMasterBrowse(getUserInfo(),ConstantsTx.LOOKUP_TXCODE,
				new String[] {"slip", "COUNT(1)", "regid="+lCurRegId},
				new MessageQueueCallBack() {
			public void onPostSuccess(MessageQueue mQueue) {
				String sslpno = getListTable().getSelectedRowContent()[7];
				if (Integer.parseInt(mQueue.getContentField()[0])>1) {
//					sslpno = EMPTY_VALUE;
					setParameter("lRegid", lCurRegId);
					getDlgSelectSlip().showDialog(lCurRegId);
				} else {
					setParameter("SlpNo", sslpno);
					setParameter("lXregId", getListTable().getSelectedRowContent()[16]);
					setParameter("From", "srhPatStsView");
					setParameter("isNewSlip", YES_VALUE);
					showPanel(new TransactionDetail());
				}
			}
		});

		if (getListTable().getSelectedRow() == -1) {
			Factory.getInstance().addErrorMessage("Please select a record.");
			return;
		}
	}

	private void fillNumbers() {
		getPatIP_Retr().setText(String.valueOf(getListTable().getRowCount()));
		getPreIP_Retr().setText(String.valueOf(getListTable().getRowCount()));
		getChkIP_Retr().setText(String.valueOf(getListTable().getRowCount()));
		getPatPB_Retr().setText(String.valueOf(getPreListTable().getRowCount()));
		getPrePB_Retr().setText(String.valueOf(getPreListTable().getRowCount()));
		getPreDC_Retr().setText(String.valueOf(getDCPreListTable().getRowCount()));
		getChkPB_Retr().setText(String.valueOf(getPreListTable().getRowCount()));

		if (getTabbedPane().getSelectedIndex() == 0) {
			if (getListTable().getRowCount() > 0) {
				if (isBedEnable) {
					getBedDrTrans().setEnabled(true);
				}
			} else {
				getBedDrTrans().setEnabled(true);
			}
		}

		// Arran changed SQL to SP
		QueryUtil.executeMasterBrowse(getUserInfo(), "PATSTATVIEW_FILLNUM",
				new String[] { EMPTY_VALUE },
				new MessageQueueCallBack() {
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					int totalBP1 = 0;
					int totalBP2 = 0;
					int totalBP = 0;
					try {
						totalBP1 = Integer.parseInt(mQueue.getContentField()[0]);
						totalBP2 = Integer.parseInt(mQueue.getContentField()[1]);
						totalBP = totalBP1 + totalBP2;
					} catch (Exception e) {}

					getPatIP_Total().setText(String.valueOf(totalBP1));
					getPreIP_Total().setText(String.valueOf(totalBP1));
					getChkIP_Total().setText(String.valueOf(totalBP1));
					getPatIP_Total_PB().setText(String.valueOf(totalBP));
					getPreIP_Total_PB().setText(String.valueOf(totalBP));
					getChkIP_Total_PB().setText(String.valueOf(totalBP));
				}
			}
		});
	}

	private void allDuplication() {
		if (YES_VALUE.equals(getSysParameter("DUPBPCHKF"))) {
			GetARS_Dup();
		}
	}

	private void singleDuplication() {
		if (YES_VALUE.equals(getSysParameter("DUPBPCHKF"))) {
			if (searchSingleDup && getPreListTable().getSelectedRow() >= 0) {
				getCheckListTable().setListTableContent("STATUSVIEWSINGLEDUP",
						new String[] {
							getPreListTable().getSelectedRowContent()[GrdPbCol_PatNo],
							getPreListTable().getSelectedRowContent()[GrdPbCol_PatIDNo],
							getPreListTable().getSelectedRowContent()[GrdPbCol_PatFName],
							getPreListTable().getSelectedRowContent()[GrdPbCol_PatGName],
							NO_VALUE
						});
			} else {
				Factory.getInstance().addErrorMessage(NO_RECORD_FOUND);
			}
		}
		searchSingleDup = false;
	}

	private void GetARS_Dup() {
		Factory.getInstance().showMask();
		getMainFrame().setLoading(true);

		getCheckListTable().setListTableContent("STATUSVIEWALLDUP", new String[] { EMPTY_VALUE });
	}

	private void getARS_Dup2(final int idx, final List<String[]> allList,
			final Map<String, String[]> tmpList) {
		String[] contents = null;
		if (idx < allList.size()) {
			contents = allList.get(idx);
			if (contents != null) {
				QueryUtil.executeMasterBrowse(getUserInfo(),
						"STATUSVIEWSINGLEDUP",
						new String[] {contents[1], contents[2], contents[3], contents[4], YES_VALUE},
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							List<String[]> list = mQueue.getContentAsArray();
							for (String[] contents : list) {
								tmpList.put(contents[0], contents);
							}
						}

						getARS_Dup2(idx + 1, allList, tmpList);
					}
				});
			}
		} else {
			getARS_DupPost(tmpList);
		}
	}

	private void getARS_DupPost(Map<String, String[]> tmpList) {
		if (tmpList != null) {
			Set<String> pbpids = new HashSet<String>();
			for (int i = 0; i < getCheckListTable().getRowCount(); i++) {
				pbpids.add(getCheckListTable().getRowContent(i)[28]);
			}
			Iterator<String> itr = tmpList.keySet().iterator();
			while (itr.hasNext()) {
				String[] row = tmpList.get(itr.next());
				if (row != null) {
					if (!pbpids.contains(row[0])) {
						getCheckListTable().addRow(row);
					}
				}
			}
		}
		sortCheckList();

		Factory.getInstance().hideMask();
		getMainFrame().setLoading(false);

		isShowAskDialog = false;
		int selectedIndex = TabbedPane.getSelectedIndex();
		getTabbedPane().setSelectedIndex(0);
		getTabbedPane().setSelectedIndex(selectedIndex);

		setStrikeRow();
	}

	private void sortCheckList() {
		List<TableData> tmpList = new ArrayList<TableData>();
		List<String> tmpKey = new ArrayList<String>();

		for (int i = 0; i < getCheckListTable().getStore().getCount(); i++) {
			List<TableData> list = getCheckListTable().getStore().getRange(i, i);
			TableData td = (TableData) list.get(0);
			String patName = (String) td.getValue(5);
			String schAdmDate = (String) td.getValue(12);
			String pbpid = (String) td.getValue(29);

			StringBuilder str1 = new StringBuilder(patName == null ? "" : patName);
			int str1Len = str1.length();
			for (int j = 0; j < 42 - str1Len; j++) {
				str1.append(" ");
			}
			StringBuilder str2 = new StringBuilder(schAdmDate == null ? "" :
				schAdmDate.substring(6, 10) + schAdmDate.substring(3, 5) + schAdmDate.substring(0, 2) +
				schAdmDate.substring(11, 13) + schAdmDate.substring(14, 16) + schAdmDate.substring(17, 19));
			// pbpid must have no duplicate
			StringBuilder str3 = new StringBuilder(pbpid == null ? "" : pbpid);
			int str3Len = str3.length();
			for (int j = 0; j < 22 - str3Len; j++) {
				str3.append(" ");
			}

			String compareStr = str1.toString() + str2.toString() + str3.toString();

			boolean stop = false;
			int idx = tmpKey.size();
			for (int j = 0; !stop && j < tmpKey.size(); j++) {
				//System.out.println(j + ":" + tmpKey.get(j));
				if (compareStr.compareTo(tmpKey.get(j)) < 0) {
					stop = true;
					idx = j;
				}
			}
			tmpKey.add(idx, compareStr);
			tmpList.add(idx, td);
		}
		getCheckListTable().getStore().removeAll();
		getCheckListTable().setListTableContent(tmpList);
	}

	private void setStrikeRow() {
		for (int i = 0; i < getCheckListTable().getStore().getCount(); i++) {
			List<TableData> list = getCheckListTable().getStore().getRange(i, i);
			TableData td = (TableData) list.get(0);
			String isRefused = (String) td.getValue(30);

			if (ConstantsVariable.MINUS_ONE_VALUE.equals(isRefused)) {
				Element cell = getCheckListTable().getView().getCell(i, 0);
				if (cell != null) {
					cell.getParentElement().addClassName("strike-through");
				}
			}
		}
	}

	private void IPRegReady(boolean isReady) {
		if (isReady) {
			setParameter("isPreBooking", "YES");
			QueryUtil.executeMasterBrowse(getUserInfo(),ConstantsTx.LOOKUP_TXCODE,
					new String[] {"bedprebok", "doccode", "pbpid = '" + lpbpid + "'"},
					new MessageQueueCallBack() {
				public void onPostSuccess(MessageQueue mQueue) {
					String sDocCode = null;
					if (mQueue.success()) {
						sDocCode = mQueue.getContentField()[0];
					}
					setParameter("DocCode", sDocCode);
					setParameter("PatNo", getPreListTable().getSelectedRowContent()[GrdPbCol_PatNo]);
					if (!getPreListTable().getSelectedRowContent()[GrdPbCol_PatFName].isEmpty()) {
						setParameter("PatFName", getPreListTable().getSelectedRowContent()[GrdPbCol_PatFName]);
						setParameter("pat_Fname", getPreListTable().getSelectedRowContent()[GrdPbCol_PatFName]);
					} else {
						setParameter("PatFName", getPreListTable().getSelectedRowContent()[GrdPbCol_PatName]);
						setParameter("pat_Fname", getPreListTable().getSelectedRowContent()[GrdPbCol_PatFName]);
					}
					setParameter("pat_Gname", getPreListTable().getSelectedRowContent()[GrdPbCol_PatGName]);
					setParameter("pat_Cname", getPreListTable().getSelectedRowContent()[GrdPbCol_PatCName]);
					setParameter("START_TYPE", ConstantsRegistration.REG_INPATIENT); // REG_INPATIENT="I"
					setParameter("CallForm", "srhPatStsView");
					setParameter("CurrentPBPId", lpbpid);
					setParameter("PBORemark", getPreListTable().getSelectedRowContent()[GrdPbCol_PBRmk]);

					QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] { "bedprebok b, BEDPREBOK_EXTRA BE", "B.ESTSTAYLEN, BE.PBPKGCODE2", "B.PBPID = BE.PBPID AND B.PBPId = '" + lpbpid + "'"},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							int vStayLen = 0;
							if (mQueue.success()) {
								try {
									vStayLen = Integer.parseInt(mQueue.getContentField()[0]);
								} catch (Exception e) {
								}
							}
							if (vStayLen > 0) {
								setParameter("STAYLEN", mQueue.getContentField()[0]);
							} else {
								setParameter("STAYLEN", ZERO_VALUE);
							}
							
							if (mQueue.getContentField()[1].length() > 0) {
								setParameter("BPBPkgCode", mQueue.getContentField()[1].trim());
							}

							QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
									new String[] { "bedprebok b, ot_app ota, ot_proc otp", "min(ota.otpid)", "b.pbpid = ota.pbpid and ota.otpid = otp.otpid and b.pbpid = '" + lpbpid + "'"},
									new MessageQueueCallBack() {
								@Override
								public void onPostSuccess(MessageQueue mQueue) {
									if (mQueue.success()) {
										if (!mQueue.getContentField()[0].isEmpty()) {
											QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
													new String[] { "ot_proc", "PkgCode", "otpid = '" + lpbpid + "'"},
													new MessageQueueCallBack() {
												@Override
												public void onPostSuccess(MessageQueue mQueue) {
													if (mQueue.success()) {
														if (!mQueue.getContentField()[0].isEmpty()) {
															setParameter("PkgCode", mQueue.getContentField()[0]);
														}
													}
													showPanel(new PatientIn());
												}
											});
										}
									}
									showPanel(new PatientIn());
								}
							});
						}
					});
				}
			});
		}
	}

	private void DCRegReady(boolean isReady) {
		if (isReady) {
			setParameter("isPreBooking", "YES");
			QueryUtil.executeMasterBrowse(getUserInfo(),ConstantsTx.LOOKUP_TXCODE,
					new String[] {"bedprebok", "doccode", "pbpid = '" + lpbpid + "'"},
					new MessageQueueCallBack() {
				public void onPostSuccess(MessageQueue mQueue) {
					String sDocCode = null;
					if (mQueue.success()) {
						sDocCode = mQueue.getContentField()[0];
					}
					setParameter("DocCode", sDocCode);
					setParameter("PatNo", getDCPreListTable().getSelectedRowContent()[GrdPbCol_PatNo]);
					if (!getDCPreListTable().getSelectedRowContent()[GrdPbCol_PatFName].isEmpty()) {
						setParameter("PatFName", getDCPreListTable().getSelectedRowContent()[GrdPbCol_PatFName]);
						setParameter("pat_Fname", getDCPreListTable().getSelectedRowContent()[GrdPbCol_PatFName]);
					} else {
						setParameter("PatFName", getDCPreListTable().getSelectedRowContent()[GrdPbCol_PatName]);
						setParameter("pat_Fname", getDCPreListTable().getSelectedRowContent()[GrdPbCol_PatFName]);
					}
					setParameter("pat_Gname", getDCPreListTable().getSelectedRowContent()[GrdPbCol_PatGName]);
					setParameter("pat_Cname", getDCPreListTable().getSelectedRowContent()[GrdPbCol_PatCName]);
					setParameter("START_TYPE", ConstantsRegistration.REG_DAYCASE); // REG_INPATIENT="D"
					setParameter("CallForm", "srhPatStsView");
					setParameter("CurrentPBPId", lpbpid);
					setParameter("PBORemark", getDCPreListTable().getSelectedRowContent()[GrdPbCol_PBRmk]);

					QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] { "bedprebok b, BEDPREBOK_EXTRA BE", "B.ESTSTAYLEN, BE.BPBPKGCODE", "B.PBPID = BE.PBPID AND B.PBPId = '" + lpbpid + "'"},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							int vStayLen = 0;
							String bpbPkgCode = null;
							if (mQueue.success()) {
								try {
									vStayLen = Integer.parseInt(mQueue.getContentField()[0]);
									bpbPkgCode = mQueue.getContentField()[1];
								} catch (Exception e) {
								}
							}
							if (vStayLen > 0) {
								setParameter("STAYLEN", mQueue.getContentField()[0]);
							} else {
								setParameter("STAYLEN", ZERO_VALUE);
							}
							
							if (!"".equals(bpbPkgCode.trim())) {
								setParameter("BPBPkgCode", bpbPkgCode.trim());
							}

							QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
									new String[] { "bedprebok b, ot_app ota, ot_proc otp", "min(ota.otpid)", "b.pbpid = ota.pbpid and ota.otpid = otp.otpid and b.pbpid = '" + lpbpid + "'"},
									new MessageQueueCallBack() {
								@Override
								public void onPostSuccess(MessageQueue mQueue) {
									if (mQueue.success()) {
										if (!mQueue.getContentField()[0].isEmpty()) {
											QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
													new String[] { "ot_proc", "PkgCode", "otpid = '" + lpbpid + "'"},
													new MessageQueueCallBack() {
												@Override
												public void onPostSuccess(MessageQueue mQueue) {
													if (mQueue.success()) {
														if (!mQueue.getContentField()[0].isEmpty()) {
															setParameter("PkgCode", mQueue.getContentField()[0]);
														}
													}
													showPanel(new PatientDayCase());
												}
											});
										}
									}
									showPanel(new PatientDayCase());
								}
							});
						}
					});
				}
			});
		}
	}

	private void IPReg() {
		if (getPreListTable().getSelectedRow() != -1) {
			QueryUtil.executeMasterBrowse(getUserInfo(),ConstantsTx.LOOKUP_TXCODE,
					new String[] {"bedprebok", "bpbsts", "pbpid ="+lpbpid},
					new MessageQueueCallBack() {
				public void onPostSuccess(MessageQueue mQueue) {
//					String sState = mQueue.getContentField()[0];
					if ("F".equals(getPreListTable().getSelectedRowContent()[0])) {
						Factory.getInstance().addErrorMessage("The current Pre_Booking has been confirmed.");
						IPRegReady(false);
					} else if (((getPreListTable().getSelectedRowContent()[GrdPbCol_BookingNo].length() > 0)) &&
							("S".equals(getPreListTable().getSelectedRowContent()[GrdPbCol_BookingNo].substring(0, 1)))) {
						Factory.getInstance().isConfirmYesNoDialog("Confirmed to register a waiting list pre-booking?", new Listener<MessageBoxEvent>() {
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									if (DateTimeUtil.dateDiff(getMainFrame().getServerDate(), getPreListTable().getSelectedRowContent()[GrdPbCol_HospDate].substring(0, 10)) > 0) {
										Factory.getInstance().isConfirmYesNoDialog("Confirm IP registration on outdated booking ?", new Listener<MessageBoxEvent>() {
											public void handleEvent(MessageBoxEvent be) {
												if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
													IPRegReady(true);
												}
											}
										});
									} else {
										IPRegReady(true);
									}
								}
							}
						});
					} else if (DateTimeUtil.dateDiff(getMainFrame().getServerDate(), getPreListTable().getSelectedRowContent()[GrdPbCol_HospDate].substring(0, 10)) > 0) {
						Factory.getInstance().isConfirmYesNoDialog("Confirm IP registration on outdated booking ?", new Listener<MessageBoxEvent>() {
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									IPRegReady(true);
								}
							}
						});
					} else {
						IPRegReady(true);
					}
				}
			});
		}
	}

	private void DCReg() {
		if (getDCPreListTable().getSelectedRow() != -1) {
			QueryUtil.executeMasterBrowse(getUserInfo(),ConstantsTx.LOOKUP_TXCODE,
					new String[] {"bedprebok", "bpbsts", "pbpid ="+lpbpid},
					new MessageQueueCallBack() {
				public void onPostSuccess(MessageQueue mQueue) {
//					String sState = mQueue.getContentField()[0];
					if ("F".equals(getDCPreListTable().getSelectedRowContent()[0])) {
						Factory.getInstance().addErrorMessage("The current Pre_Booking has been confirmed.");
						DCRegReady(false);
					} else if (((getDCPreListTable().getSelectedRowContent()[GrdPbCol_BookingNo].length() > 0)) &&
							("S".equals(getDCPreListTable().getSelectedRowContent()[GrdPbCol_BookingNo].substring(0, 1)))) {
						Factory.getInstance().isConfirmYesNoDialog("Confirmed to register a waiting list pre-booking?", new Listener<MessageBoxEvent>() {
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									if (DateTimeUtil.dateDiff(getMainFrame().getServerDate(), getDCPreListTable().getSelectedRowContent()[GrdPbCol_HospDate].substring(0, 10)) > 0) {
										Factory.getInstance().isConfirmYesNoDialog("Confirm IP registration on outdated booking ?", new Listener<MessageBoxEvent>() {
											public void handleEvent(MessageBoxEvent be) {
												if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
													DCRegReady(true);
												}
											}
										});
									} else {
										DCRegReady(true);
									}
								}
							}
						});
					} else if (DateTimeUtil.dateDiff(getMainFrame().getServerDate(), getDCPreListTable().getSelectedRowContent()[GrdPbCol_HospDate].substring(0, 10)) > 0) {
						Factory.getInstance().isConfirmYesNoDialog("Confirm IP registration on outdated booking ?", new Listener<MessageBoxEvent>() {
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									DCRegReady(true);
								}
							}
						});
					} else {
						DCRegReady(true);
					}
				}
			});
		}
	}

	private void deletePB() {
		if (getTabbedPane().getSelectedIndex() == 1) {
			final String pbpid = getPreListTable().getSelectedRowContent()[GrdPbCol_PbPid];
			QueryUtil.executeMasterAction(getUserInfo(), "BEDPREBOKDEL", QueryUtil.ACTION_DELETE,
					new String[] {pbpid,getUserInfo().getUserID()}, new MessageQueueCallBack() {
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
								new String[] {"OT_APP", "COUNT(1)", "PBPID = "+pbpid+" and otasts = 'N'"},
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue cntQueue) {
								String funname = "Pre-Booking -> Delete";
								Map<String, String> params = new HashMap<String, String>();
								params.put("Ward", getListTable().getSelectedRowContent()[14]);
								params.put("Order by Doctor", getPreListTable().getSelectedRowContent()[GrdPbCol_DocName]);
								params.put("Hospital Date", getPreListTable().getSelectedRowContent()[GrdPbCol_HospDate]);
								String patno = getListTable().getSelectedRowContent()[1];
								getAlertCheck().checkAltAccess(
										patno, funname, true, true, params);

								if (ZERO_VALUE.equals(cntQueue.getContentField()[0])) {
									Factory.getInstance().addInformationMessage("Booking removed successfully");
								} else {
									Factory.getInstance().addInformationMessage("Booking removed successfully. Please notify the Operation Room for the cancel of the pre-booking.");
								}
							}
						});
						searchAction();
					} else {
						Factory.getInstance().addErrorMessage("Delete Failed. ");
					}
				}
			});
		} else if (getTabbedPane().getSelectedIndex() == 2 && hasDayCase) {
			final String pbpid = getDCPreListTable().getSelectedRowContent()[GrdPbCol_PbPid];
			QueryUtil.executeMasterAction(getUserInfo(), "BEDPREBOKDEL", QueryUtil.ACTION_DELETE,
					new String[] {pbpid,getUserInfo().getUserID()}, new MessageQueueCallBack() {
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
								new String[] {"OT_APP", "COUNT(1)", "PBPID = "+pbpid+" and otasts = 'N'"},
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue cntQueue) {
								String funname = "Pre-Booking -> Delete";
								Map<String, String> params = new HashMap<String, String>();
								params.put("Ward", getListTable().getSelectedRowContent()[14]);
								params.put("Order by Doctor", getDCPreListTable().getSelectedRowContent()[GrdPbCol_DocName]);
								params.put("Hospital Date", getDCPreListTable().getSelectedRowContent()[GrdPbCol_HospDate]);
								String patno = getListTable().getSelectedRowContent()[1];
								getAlertCheck().checkAltAccess(
										patno, funname, true, true, params);

								if (ZERO_VALUE.equals(cntQueue.getContentField()[0])) {
									Factory.getInstance().addInformationMessage("Booking removed successfully");
								} else {
									Factory.getInstance().addInformationMessage("Booking removed successfully. Please notify the Operation Room for the cancel of the pre-booking.");
								}
							}
						});
						searchAction();
					} else {
						Factory.getInstance().addErrorMessage("Delete Failed. ");
					}
				}
			});
		}
	}

	protected void printRptDCAppListing() {
		String fromDate = getDCPreSchdDateFrom().getText();
		String toDate = getDCPreSchdDateTo().getText();

		HashMap<String, String> map = new HashMap<String, String>();
		map.put("FromSDate", fromDate);
		map.put("ToSDate", toDate);
		map.put("SiteName", Factory.getInstance().getUserInfo().getSiteName());
		map.put("SUBREPORT_DIR",CommonUtil.getReportDir());

		Report.print(Factory.getInstance().getUserInfo(),
					"PatStatViewDC", map,
					new String[] {
						getDCPrePatientNo().getText(),
						getDCPreName().getText(),
						getDCPreDrCode().getText(),
						getDCPreDrName().getText(),
						getDCPreWard().getText(),
						getDCPreDoc().getText(),
						getDCPreSchdDateFrom().getText(),
						getDCPreSchdDateTo().getText(),
						getDCPreBookType().getText(),
						getDCPreOrdDateFrom().getText(),
						getDCPreOrdDateTo().getText(),
						getDCPreDeposit().getText(),
						getDCPreCancel().getText(),
						getDCPreOTCase().getText(),
						getDCPreDeclin().getText(),
						getDCPreSortBy().getText(),
						getDCPreChiName().getText(),
						"D"
					},
					new String[] {
						"BPBSTS",
						"BPBNO",
						"PATNO",
						"PATNAME",
						"PATCNAME",
						"DOCNAME",
						"SEX",
						"AGE",
						"ACMCODE",
						"WRDCODE",
						"HOSDATE",
						"EDC",
						"RMK",
						"PATIDNO",
						"BE",
						"BEDCODE",
						"BEDTIME",
						"ORDDATE",
						"CREATEUSERNAME",
						"ESTGIVN",
						"REMARK",
						"PATKHTEL",
						"PATPAGER",
						"OTPDESC",
						"OTAOSDATE",
						"CABLABRMK",
						"SLPNO",
						"EDITUSERNAME",
						"EDITDATE",
						"ISREFUSED",
						"PBPID",
						"USRID",
						"EDITUSER",
						"BPBTYPE",
						"DOCCODE",
						"FORDELIVERY",
						"PATFNAME",
						"PATGNAME",
						"SMSSENTDT",
						"EMAILSENTDT",
						"ESTSTAYLEN",
						"PKGCODE"
					}, true);
		/*
		Report.print(getUserInfo(),
				"ChrgDayCase", map,
				new String[] {
					getMemSlipNo()
				},
				new String[] {
					"PATNAME", "PATCNAME", "SLPNO", "PATNO",
					"REGDATE", "REGTIME", "BEDACM", "INPDDATE",
					"INPDTIME", "DOCNAME", "DOCCNAME"
				},
				new boolean[] {
					false, false, false, false,
					false, false, false, false,
					false, false, false
				},
				new String[] {
					"CHRGDAYCASE_SUB"
				},
				new String[][] {{ getAllSlip(true) }},
				new String[][] {
					{
						"DESCRIPTION", "QTY", "AMOUNT",
						"STNTYPE", "ITMTYPE", "DOCCODE",
						"DOCNAME", "DOCCNAME", "CDESCCODE"
					}
				},
				new boolean[][] {
					{
						false, true, false, false,
						false, false, false, false,
						false
					}
				}, "", true, false, true, false, null, null, null, false);
			*/
	}
/*
	private void setPatStatusViewButton() {
		int patientStatusCount = getListTable().getRowCount();
//		getBedDrTrans().setEnabled(isBedEnable && patientStatusCount > 0);
		getWardEntry().setEnabled(false);
		getCurIProfile().setEnabled(isCurIProfileEnable && patientStatusCount > 0);
		getBilling().setEnabled(isBillingEnable && patientStatusCount > 0);
	}

	private void setPreBookButton() {
		getModifyButton().setEnabled(false);
		getDeleteButton().setEnabled(false);
		if (getPreListTable().getSelectedRow() != -1 && NO_VALUE.equals(getPreListTable().getSelectedRowContent()[1])
				&& ZERO_VALUE.equals(getPreListTable().getSelectedRowContent()[26]) ) {
			getPreIPReg().setEnabled(isPreIPRegEnable);
			getPreOTAB().setEnabled(!"OT".equals(getParameter("From")));
			getPrePBL().setEnabled(MINUS_ONE_VALUE.equals(getPreListTable().getSelectedRowContent()[GrdPbCol_ForDelivery]));

			getModifyButton().setEnabled(true);
			getDeleteButton().setEnabled(true);
		} else {
			getPreIPReg().setEnabled(false);
			getPreOTAB().setEnabled(false);
			getPrePBL().setEnabled(false);
		}
	}
*/
	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/* >>> getter methods for init the Component start from here================================== <<< */
	@Override
	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.setSize(788, 540);
			leftPanel.add(getTabbedPane(),null);
		}
		return leftPanel;
	}

	protected BasePanel getRightPanel() {
		if (rightPanel == null) {
			rightPanel = new BasePanel();
		}
		return rightPanel;
	}

	public TabbedPaneBase getTabbedPane() {
		if (TabbedPane == null) {
			TabbedPane = new TabbedPaneBase() {
				public void onStateChange() {
					int selectedIndex = TabbedPane.getSelectedIndex();
					enableButton();

					if (selectedIndex == 2 + (hasDayCase ? 1 : 0)) {
						if (YES_VALUE.equals(getSysParameter("DUPBPCHKF"))) {
							if (isShowAskDialog) {
								// removeAllRow before another search
								if (rtvOldTabIndex == 1) {
									searchSingleDup = true;
								} else {
									searchSingleDup = false;
								}
								isSearchDup = false;
								getCheckListTable().removeAllRow();
								getAskOptA().setSelected(true);

								getAskDialog().setVisible(true);
							} else {
								isShowAskDialog = true;
							}
						} else {
							getMainFrame().setLoading(false);
							setSelectedIndexWithoutStateChange(rtvOldTabIndex);
							return;
						}
					} else if (selectedIndex == 1) {
//						getPreScrollPane().layout();
					}

					rtvOldTabIndex = selectedIndex;
				}
			};
			TabbedPane.setBounds(0, 0, 784, 500);
			TabbedPane.addTab("Patient Status View", getPSViewPanel());
			TabbedPane.addTab("Pre Booking", getPreBookPanel());
			if (HKAH_VALUE.equals(getUserInfo().getSiteCode())) {
				TabbedPane.addTab("Daycase - OPD", getDCPreBookPanel());
			}
			if (YES_VALUE.equals(getSysParameter("DUPBPCHKF"))) {
				TabbedPane.addTab("Check Duplication", getCheckDupPanel());
			}
		}
		return TabbedPane;
	}

	public BasePanel getPSViewPanel() {
		if (PSViewPanel == null) {
			PSViewPanel = new BasePanel();
			PSViewPanel.setBounds(5, 5, 790, 480);
			PSViewPanel.add(getParaPanel(),null);
			PSViewPanel.add(getListPanel(), null);
			PSViewPanel.add(getBedDrTrans(), null);
			PSViewPanel.add(getWardEntry(), null);
			PSViewPanel.add(getCurIProfile(), null);
			PSViewPanel.add(getBilling(), null);
			PSViewPanel.add(getPatCount(), null);
			PSViewPanel.add(getPatIP_RetrDesc(), null);
			PSViewPanel.add(getPatPB_RetrDesc(), null);
			PSViewPanel.add(getPatIP_TotalDesc(), null);
			PSViewPanel.add(getPatIP_Retr(), null);
			PSViewPanel.add(getPatPB_Retr(), null);
			PSViewPanel.add(getPatIP_Total(), null);
			PSViewPanel.add(getPatIP_Total_PB(), null);
			PSViewPanel.add(getPatIP_Total_PBDesc(), null);
		}
		return PSViewPanel;
	}

	public FieldSetBase getParaPanel() {
		if (ParaPanel == null) {
			ParaPanel = new FieldSetBase();
			ParaPanel.setHeading("In Patient");
			ParaPanel.add(getPatientNoDesc(), null);
			ParaPanel.add(getPatientNo(), null);
			ParaPanel.add(getSurNameDesc(), null);
			ParaPanel.add(getSurNameCode(), null);
			ParaPanel.add(getGivenNameDesc(), null);
			ParaPanel.add(getGivenName(), null);
			ParaPanel.add(getWardDesc(), null);
			ParaPanel.add(getWard(), null);
			ParaPanel.add(getDrCodeDesc(), null);
			ParaPanel.add(getDrCode(), null);
			ParaPanel.add(getAdmFromDesc(), null);
			ParaPanel.add(getAdmFrom(), null);
			ParaPanel.add(getAdmToDesc(), null);
			ParaPanel.add(getAdmTo(), null);
			ParaPanel.add(getSortByDesc(), null);
			ParaPanel.add(getSortBy(), null);
			ParaPanel.add(getPatientScrollPanel());
			ParaPanel.setBounds(5, 5, 759, 263);
		}
		return ParaPanel;
	}

	public LabelSmallBase getPatientNoDesc() {
		if (PatientNoDesc == null) {
			PatientNoDesc = new LabelSmallBase();
			PatientNoDesc.setText("Patient No");
			PatientNoDesc.setBounds(10, 0, 71, 20);
			PatientNoDesc.setOptionalLabel();
		}
		return PatientNoDesc;
	}

	public TextPatientNoSearch getPatientNo() {
		if (PatientNo == null) {
			PatientNo = new TextPatientNoSearch();
			PatientNo.setBounds(79, 0, 86, 20);
		}
		return PatientNo;
	}

	public LabelSmallBase getSurNameDesc() {
		if (SurNameDesc == null) {
			SurNameDesc = new LabelSmallBase();
			SurNameDesc.setText("SurName");
			SurNameDesc.setBounds(178, 0, 68, 20);
			SurNameDesc.setOptionalLabel();
		}
		return SurNameDesc;
	}

	public TextString getSurNameCode() {
		if (SurNameCode == null) {
			SurNameCode = new TextString();
			SurNameCode.setBounds(242, 0, 125, 20);
		}
		return SurNameCode;
	}

	public LabelSmallBase getGivenNameDesc() {
		if (GivenNameDesc == null) {
			GivenNameDesc = new LabelSmallBase();
			GivenNameDesc.setText("Given Name");
			GivenNameDesc.setBounds(385, 0, 89, 20);
			GivenNameDesc.setOptionalLabel();
		}
		return GivenNameDesc;
	}

	public TextString getGivenName() {
		if (GivenName == null) {
			GivenName = new TextString();
			GivenName.setBounds(466, 0, 125, 20);
		}
		return GivenName;
	}

	public LabelSmallBase getWardDesc() {
		if (WardDesc == null) {
			WardDesc = new LabelSmallBase();
			WardDesc.setText("Ward");
			WardDesc.setBounds(600, 0, 46, 20);
			WardDesc.setOptionalLabel();
		}
		return WardDesc;
	}

	public ComboWard getWard() {
		if (Ward == null) {
			Ward = new ComboWard(false);
			Ward.setBounds(650, 0, 85, 20);
		}
		return Ward;
	}

	public LabelSmallBase getDrCodeDesc() {
		if (DrCodeDesc == null) {
			DrCodeDesc = new LabelSmallBase();
			DrCodeDesc.setText("Dr. Code");
			DrCodeDesc.setBounds(10, 25, 71, 20);
			DrCodeDesc.setOptionalLabel();
		}
		return DrCodeDesc;
	}

	public TextDoctorSearch getDrCode() {
		if (DrCode == null) {
			DrCode = new TextDoctorSearch();
			DrCode.setBounds(79, 25, 86, 20);
		}
		return DrCode;
	}

	public LabelSmallBase getAdmFromDesc() {
		if (AdmFromDesc == null) {
			AdmFromDesc = new LabelSmallBase();
			AdmFromDesc.setText("Admission From");
			AdmFromDesc.setBounds(178, 25, 106, 20);
			AdmFromDesc.setOptionalLabel();
		}
		return AdmFromDesc;
	}

	public TextDateWithCheckBox getAdmFrom() {
		if (AdmFrom == null) {
			AdmFrom = new TextDateWithCheckBox();
			AdmFrom.setBounds(268, 25, 120, 20);
		}
		return AdmFrom;
	}

	public LabelSmallBase getAdmToDesc() {
		if (AdmToDesc == null) {
			AdmToDesc = new LabelSmallBase();
			AdmToDesc.setText("to");
			AdmToDesc.setBounds(411, 25, 36, 20);
			AdmToDesc.setOptionalLabel();
		}
		return AdmToDesc;
	}

	public TextDateWithCheckBox getAdmTo() {
		if (AdmTo == null) {
			AdmTo = new TextDateWithCheckBox();
			AdmTo.setBounds(446, 25, 120, 20);
		}
		return AdmTo;
	}

	public LabelSmallBase getSortByDesc() {
		if (SortByDesc == null) {
			SortByDesc = new LabelSmallBase();
			SortByDesc.setText("Sort by");
			SortByDesc.setBounds(580, 25, 53, 20);
			SortByDesc.setOptionalLabel();
		}
		return SortByDesc;
	}

	public ComboSortPatStatPara getSortBy() {
		if (SortBy == null) {
			SortBy = new ComboSortPatStatPara();
			SortBy.setBounds(630, 25, 105, 20);
		}
		return SortBy;
	}

	/**
	 * This method initializes jScrollPane
	 *
	 * @return JScrollPane
	 */
	protected JScrollPane getPatientScrollPanel() {
		if (patientScrollPanel == null) {
			patientScrollPanel = new JScrollPane();
			getJScrollPane().removeViewportView(getListTable());
			patientScrollPanel.setViewportView(getListTable());
			patientScrollPanel.setBounds(5, 60, 746, 170);
		}
		return patientScrollPanel;
	}

	public FieldSetBase getListPanel() {
		if (PatStatusPanel == null) {
			PatStatusPanel = new FieldSetBase();
			PatStatusPanel.setHeading("Patient Status");
			PatStatusPanel.setBounds(4, 272, 759, 141);
			PatStatusPanel.add(getPatStatusScrollPane(),null);
		}
		return PatStatusPanel;
	}

	private JScrollPane getPatStatusScrollPane() {
		if (PatStatusScrollPane == null) {
			PatStatusScrollPane = new JScrollPane();
			PatStatusScrollPane.setViewportView(getPatStatusTable());
			PatStatusScrollPane.setBounds(5, 0, 746, 105);
		}
		return PatStatusScrollPane;
	}

	private TableList getPatStatusTable() {
		if (PatStatusTable == null) {
			PatStatusTable = new TableList(getPatStatusColumnNames(), getPatStatusColumnWidths()) {
				public void setListTableContentPost() {
					// focus main table
					getListTable().focus();
				}
			};
//			PatStatusTable.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
//			PatStatusTable.setColumnClass(0, ComboPackage.class, true);
//			PatStatusTable.setColumnClass(1, String.class, true);
		}
		return PatStatusTable;
	}

	protected String[] getPatStatusColumnNames() {
		return new String[] {"From", "To", "Location"};
	}

	protected int[] getPatStatusColumnWidths() {
		return new int[] { 120, 120, 150};
	}

	public ButtonBase getBedDrTrans() {
		if (BedDrTrans == null) {
			BedDrTrans = new ButtonBase() {
				@Override
				public void onClick() {
					if (!"C".equals(getListTable().getSelectedRowContent()[17])) {
						setParameter("PatNo", getListTable().getSelectedRowContent()[1]);
						setParameter("SlpNo", getListTable().getSelectedRowContent()[7]);
						setParameter("From", "srhReg");
						showPanel(new DoctorBedTransfer());
					} else {
						Factory.getInstance().addErrorMessage("The selected registration is cancelled.");
					}
				}
			};
			BedDrTrans.setText("Bed/Dr. Transfer", 'T');
			BedDrTrans.setBounds(7, 428, 117, 30);
		}
		return BedDrTrans;
	}

	public ButtonBase getWardEntry() {
		if (WardEntry == null) {
			WardEntry = new ButtonBase() {
				@Override
				public void onClick() {
					//add something
				}
			};
			WardEntry.setText("Ward Entry", 'W');
			WardEntry.setBounds(128, 428, 99, 30);
			WardEntry.setEnabled(false);
		}
		return WardEntry;
	}

	public ButtonBase getCurIProfile() {
		if (CurIProfile == null) {
			CurIProfile = new ButtonBase() {
				@Override
				public void onClick() {
					if (getListTable().getSelectedRow() != -1) {
						setParameter("PatNo", getListTable().getSelectedRowContent()[1]);
						setParameter("RegId", lCurRegId);
						setParameter("CallForm", "srhReg");
						showPanel(new Patient());
					}
				}
			};
			CurIProfile.setText("Current IP Profile", 'C');
			CurIProfile.setBounds(231, 428, 117, 30);
		}
		return CurIProfile;
	}

	public ButtonBase getBilling() {
		if (Billing == null) {
			Billing = new ButtonBase() {
				@Override
				public void onClick() {
					billingAction();
				}
			};
			Billing.setText("Billing", 'B');
			Billing.setBounds(352, 428, 74, 30);
		}
		return Billing;
	}

	public LabelSmallBase getPatCount() {
		if (PatCount == null) {
			PatCount = new LabelSmallBase();
			PatCount.setText("Count:");
			PatCount.setBounds(437, 438, 47, 20);
			PatCount.setRemarkLabel();
		}
		return PatCount;
	}

	public LabelSmallBase getPatIP_RetrDesc() {
		if (PatIP_RetrDesc == null) {
			PatIP_RetrDesc = new LabelSmallBase();
			PatIP_RetrDesc.setText("IP Retr.");
			PatIP_RetrDesc.setBounds(480, 417, 58, 20);
			PatIP_RetrDesc.setRemarkLabel();
		}
		return PatIP_RetrDesc;
	}

	public LabelSmallBase getPatPB_RetrDesc() {
		if (PatPB_RetrDesc == null) {
			PatPB_RetrDesc = new LabelSmallBase();
			PatPB_RetrDesc.setText("PB Retr.");
			PatPB_RetrDesc.setBounds(537, 417, 58, 20);
			PatPB_RetrDesc.setRemarkLabel();
		}
		return PatPB_RetrDesc;
	}

	public LabelSmallBase getPatIP_TotalDesc() {
		if (PatIP_TotalDesc == null) {
			PatIP_TotalDesc = new LabelSmallBase();
			PatIP_TotalDesc.setText("Total IP");
			PatIP_TotalDesc.setBounds(595, 417, 58, 20);
			PatIP_TotalDesc.setRemarkLabel();
		}
		return PatIP_TotalDesc;
	}

	public LabelSmallBase getPatIP_Total_PBDesc() {
		if (PatIP_Total_PBDesc == null) {
			PatIP_Total_PBDesc = new LabelSmallBase();
			PatIP_Total_PBDesc.setText("Total IP(Incl.PB)");
			PatIP_Total_PBDesc.setBounds(652, 417, 104, 20);
			PatIP_Total_PBDesc.setRemarkLabel();
		}
		return PatIP_Total_PBDesc;
	}

	public TextReadOnly getPatIP_Retr() {
		if (PatIP_Retr == null) {
			PatIP_Retr = new TextReadOnly();
			PatIP_Retr.setBounds(480, 438, 58, 20);
			PatIP_Retr.setText(ZERO_VALUE);
			PatIP_Retr.setAllowReset(false);
		}
		return PatIP_Retr;
	}

	public TextReadOnly getPatPB_Retr() {
		if (PatPB_Retr == null) {
			PatPB_Retr = new TextReadOnly();
			PatPB_Retr.setBounds(537, 438, 58, 20);
			PatPB_Retr.setText(ZERO_VALUE);
			PatPB_Retr.setAllowReset(false);
		}
		return PatPB_Retr;
	}

	public TextReadOnly getPatIP_Total() {
		if (PatIP_Total == null) {
			PatIP_Total = new TextReadOnly();
			PatIP_Total.setBounds(595, 438, 58, 20);
			PatIP_Total.setText(ZERO_VALUE);
			PatIP_Total.setAllowReset(false);
		}
		return PatIP_Total;
	}

	public TextReadOnly getPatIP_Total_PB() {
		if (PatIP_Total_PB == null) {
			PatIP_Total_PB = new TextReadOnly();
			PatIP_Total_PB.setBounds(652, 438, 104, 20);
			PatIP_Total_PB.setText(ZERO_VALUE);
			PatIP_Total_PB.setAllowReset(false);
		}
		return PatIP_Total_PB;
	}

	public LabelSmallBase getPrePatientNoDesc() {
		if (PrePatientNoDesc == null) {
			PrePatientNoDesc = new LabelSmallBase();
			PrePatientNoDesc.setText("Patient No");
			PrePatientNoDesc.setBounds(10, 5, 71, 20);
			PrePatientNoDesc.setOptionalLabel();
		}
		return PrePatientNoDesc;
	}

	public LabelSmallBase getDCPrePatientNoDesc() {
		if (DCPrePatientNoDesc == null) {
			DCPrePatientNoDesc = new LabelSmallBase();
			DCPrePatientNoDesc.setText("Patient No");
			DCPrePatientNoDesc.setBounds(10, 5, 71, 20);
			DCPrePatientNoDesc.setOptionalLabel();
		}
		return DCPrePatientNoDesc;
	}

	public TextPatientNoSearch getPrePatientNo() {
		if (PrePatientNo == null) {
			PrePatientNo = new TextPatientNoSearch() {
				@Override
				public void onBlurPost() {
					getPreListTable().removeAllRow();
					getPreListTable().focus();
					searchAction(true);
				}
			};
			PrePatientNo.setBounds(81, 5, 101, 20);
			PrePatientNo.setShowAllAlert(false);
		}
		return PrePatientNo;
	}

	public TextPatientNoSearch getDCPrePatientNo() {
		if (DCPrePatientNo == null) {
			DCPrePatientNo = new TextPatientNoSearch() {
				@Override
				public void onBlurPost() {
					getDCPreListTable().removeAllRow();
					getDCPreListTable().focus();
					searchAction(true);
				}
			};
			DCPrePatientNo.setBounds(81, 5, 101, 20);
			DCPrePatientNo.setShowAllAlert(false);
		}
		return DCPrePatientNo;
	}

	public LabelSmallBase getPreDocDesc() {
		if (PreDocDesc == null) {
			PreDocDesc = new LabelSmallBase();
			PreDocDesc.setText("Document #");
			PreDocDesc.setBounds(211, 5, 82, 20);
			PreDocDesc.setOptionalLabel();
		}
		return PreDocDesc;
	}

	public LabelSmallBase getDCPreDocDesc() {
		if (DCPreDocDesc == null) {
			DCPreDocDesc = new LabelSmallBase();
			DCPreDocDesc.setText("Document #");
			DCPreDocDesc.setBounds(211, 5, 82, 20);
			DCPreDocDesc.setOptionalLabel();
		}
		return DCPreDocDesc;
	}

	public TextString getPreDoc() {
		if (PreDoc == null) {
			PreDoc = new TextString();
			PreDoc.setBounds(275, 5, 101, 20);
		}
		return PreDoc;
	}

	public TextString getDCPreDoc() {
		if (DCPreDoc == null) {
			DCPreDoc = new TextString();
			DCPreDoc.setBounds(275, 5, 101, 20);
		}
		return DCPreDoc;
	}

	public LabelSmallBase getPreNameDesc() {
		if (PreNameDesc == null) {
			PreNameDesc = new LabelSmallBase();
			PreNameDesc.setText("Name");
			PreNameDesc.setBounds(435, 5, 46, 20);
			PreNameDesc.setOptionalLabel();
		}
		return PreNameDesc;
	}

	public LabelSmallBase getDCPreNameDesc() {
		if (DCPreNameDesc == null) {
			DCPreNameDesc = new LabelSmallBase();
			DCPreNameDesc.setText("Name");
			DCPreNameDesc.setBounds(435, 5, 46, 20);
			DCPreNameDesc.setOptionalLabel();
		}
		return DCPreNameDesc;
	}

	public TextString getPreName() {
		if (PreName == null) {
			PreName = new TextString();
			PreName.setBounds(484, 5, 101, 20);
		}
		return PreName;
	}

	public TextString getDCPreName() {
		if (DCPreName == null) {
			DCPreName = new TextString();
			DCPreName.setBounds(484, 5, 101, 20);
		}
		return DCPreName;
	}

	public LabelSmallBase getPreChiNameDesc() {
		if (PreChiNameDesc == null) {
			PreChiNameDesc = new LabelSmallBase();
			PreChiNameDesc.setText("Chi. Name");
			PreChiNameDesc.setBounds(599, 5, 70, 20);
			PreChiNameDesc.setOptionalLabel();
		}
		return PreChiNameDesc;
	}

	public LabelSmallBase getDCPreChiNameDesc() {
		if (DCPreChiNameDesc == null) {
			DCPreChiNameDesc = new LabelSmallBase();
			DCPreChiNameDesc.setText("Chi. Name");
			DCPreChiNameDesc.setBounds(599, 5, 70, 20);
			DCPreChiNameDesc.setOptionalLabel();
		}
		return DCPreChiNameDesc;
	}

	public TextString getPreChiName() {
		if (PreChiName == null) {
			PreChiName = new TextString();
			PreChiName.setBounds(659, 5, 95, 20);
		}
		return PreChiName;
	}

	public TextString getDCPreChiName() {
		if (DCPreChiName == null) {
			DCPreChiName = new TextString();
			DCPreChiName.setBounds(659, 5, 95, 20);
		}
		return DCPreChiName;
	}

	public LabelSmallBase getPreDrCodeDesc() {
		if (PreDrCodeDesc == null) {
			PreDrCodeDesc = new LabelSmallBase();
			PreDrCodeDesc.setText("Dr. Code");
			PreDrCodeDesc.setBounds(10, 37, 71, 20);
			PreDrCodeDesc.setOptionalLabel();
		}
		return PreDrCodeDesc;
	}

	public LabelSmallBase getDCPreDrCodeDesc() {
		if (DCPreDrCodeDesc == null) {
			DCPreDrCodeDesc = new LabelSmallBase();
			DCPreDrCodeDesc.setText("Dr. Code");
			DCPreDrCodeDesc.setBounds(10, 37, 71, 20);
			DCPreDrCodeDesc.setOptionalLabel();
		}
		return DCPreDrCodeDesc;
	}

	public TextDoctorSearch getPreDrCode() {
		if (PreDrCode == null) {
			PreDrCode = new TextDoctorSearch() {
				@Override
				public void checkTriggerBySearchKeyPost() {
					getPreListTable().removeAllRow();
					getPreListTable().focus();
					searchAction(true);
				}
			};
			PreDrCode.setBounds(81, 37, 101, 20);
		}
		return PreDrCode;
	}

	public TextDoctorSearch getDCPreDrCode() {
		if (DCPreDrCode == null) {
			DCPreDrCode = new TextDoctorSearch() {
				@Override
				public void checkTriggerBySearchKeyPost() {
					getDCPreListTable().removeAllRow();
					getDCPreListTable().focus();
					searchAction(true);
				}
			};
			DCPreDrCode.setBounds(81, 37, 101, 20);
		}
		return DCPreDrCode;
	}

	public LabelSmallBase getPreDrNameDesc() {
		if (PreDrNameDesc == null) {
			PreDrNameDesc = new LabelSmallBase();
			PreDrNameDesc.setText("Dr. Name");
			PreDrNameDesc.setBounds(211, 37, 65, 20);
			PreDrNameDesc.setOptionalLabel();
		}
		return PreDrNameDesc;
	}

	public LabelSmallBase getDCPreDrNameDesc() {
		if (DCPreDrNameDesc == null) {
			DCPreDrNameDesc = new LabelSmallBase();
			DCPreDrNameDesc.setText("Dr. Name");
			DCPreDrNameDesc.setBounds(211, 37, 65, 20);
			DCPreDrNameDesc.setOptionalLabel();
		}
		return DCPreDrNameDesc;
	}

	public TextString getPreDrName() {
		if (PreDrName == null) {
			PreDrName = new TextString();
			PreDrName.setBounds(275, 37, 101, 20);
		}
		return PreDrName;
	}

	public TextString getDCPreDrName() {
		if (DCPreDrName == null) {
			DCPreDrName = new TextString();
			DCPreDrName.setBounds(275, 37, 101, 20);
		}
		return DCPreDrName;
	}

	public LabelSmallBase getPreBookTypeDesc() {
		if (PreBookTypeDesc == null) {
			PreBookTypeDesc = new LabelSmallBase();
			PreBookTypeDesc.setText("Booking #/Type");
			PreBookTypeDesc.setBounds(395, 37, 106, 20);
			PreBookTypeDesc.setOptionalLabel();
		}
		return PreBookTypeDesc;
	}

	public LabelSmallBase getDCPreBookTypeDesc() {
		if (DCPreBookTypeDesc == null) {
			DCPreBookTypeDesc = new LabelSmallBase();
			DCPreBookTypeDesc.setText("Booking #/Type");
			DCPreBookTypeDesc.setBounds(395, 37, 106, 20);
			DCPreBookTypeDesc.setOptionalLabel();
		}
		return DCPreBookTypeDesc;
	}

	public ComboBookType getPreBookType() {
		if (PreBookType == null) {
			PreBookType = new ComboBookType();
			PreBookType.setBounds(485, 37, 101, 20);
		}
		return PreBookType;
	}

	public ComboBookType getDCPreBookType() {
		if (DCPreBookType == null) {
			DCPreBookType = new ComboBookType();
			DCPreBookType.setBounds(485, 37, 101, 20);
		}
		return DCPreBookType;
	}

	public LabelSmallBase getPreSortByDesc() {
		if (PreSortByDesc == null) {
			PreSortByDesc = new LabelSmallBase();
			PreSortByDesc.setText("Sort by");
			PreSortByDesc.setBounds(599, 27, 52, 20);
			PreSortByDesc.setOptionalLabel();
		}
		return PreSortByDesc;
	}

	public LabelSmallBase getDCPreSortByDesc() {
		if (DCPreSortByDesc == null) {
			DCPreSortByDesc = new LabelSmallBase();
			DCPreSortByDesc.setText("Sort by");
			DCPreSortByDesc.setBounds(599, 27, 52, 20);
			DCPreSortByDesc.setOptionalLabel();
		}
		return DCPreSortByDesc;
	}

	public ComboSortPatStatPrePara getPreSortBy() {
		if (PreSortBy == null) {
			PreSortBy = new ComboSortPatStatPrePara() {
				@Override
				public void resetText() {
					setSelectedIndex(5);
				}
			};
			PreSortBy.setBounds(659, 27, 95, 20);
		}
		return PreSortBy;
	}

	public ComboSortPatStatPrePara getDCPreSortBy() {
		if (DCPreSortBy == null) {
			DCPreSortBy = new ComboSortPatStatPrePara() {
				@Override
				public void resetText() {
					setSelectedIndex(5);
				}
			};
			DCPreSortBy.setBounds(659, 27, 95, 20);
		}
		return DCPreSortBy;
	}

	public LabelSmallBase getPreSchdADateFromDesc() {
		if (PreSchdADateFromDesc == null) {
			PreSchdADateFromDesc = new LabelSmallBase();
			PreSchdADateFromDesc.setText("Schd Adm Date From");
			PreSchdADateFromDesc.setBounds(10, 65, 122, 20);
			PreSchdADateFromDesc.setOptionalLabel();
		}
		return PreSchdADateFromDesc;
	}

	public LabelSmallBase getDCPreSchdADateFromDesc() {
		if (DCPreSchdDateFromDesc == null) {
			DCPreSchdDateFromDesc = new LabelSmallBase();
			DCPreSchdDateFromDesc.setText("Schd Date From");
			DCPreSchdDateFromDesc.setBounds(10, 65, 122, 20);
			DCPreSchdDateFromDesc.setOptionalLabel();
		}
		return DCPreSchdDateFromDesc;
	}

	public TextDate getPreSchdADateFrom() {
		if (PreSchdADateFrom == null) {
			PreSchdADateFrom = new TextDate();
			PreSchdADateFrom.setBounds(120, 65, 118, 20);
		}
		return PreSchdADateFrom;
	}

	public TextDate getDCPreSchdDateFrom() {
		if (DCPreSchdDateFrom == null) {
			DCPreSchdDateFrom = new TextDate();
			DCPreSchdDateFrom.setBounds(120, 65, 118, 20);
		}
		return DCPreSchdDateFrom;
	}

	public LabelSmallBase getPreSchdADateToDesc() {
		if (PreSchdADateToDesc == null) {
			PreSchdADateToDesc = new LabelSmallBase();
			PreSchdADateToDesc.setText("to");
			PreSchdADateToDesc.setBounds(256, 65, 20, 20);
			PreSchdADateToDesc.setOptionalLabel();
		}
		return PreSchdADateToDesc;
	}

	public LabelSmallBase getDCPreSchdDateToDesc() {
		if (DCPreSchdDateToDesc == null) {
			DCPreSchdDateToDesc = new LabelSmallBase();
			DCPreSchdDateToDesc.setText("to");
			DCPreSchdDateToDesc.setBounds(256, 65, 20, 20);
			DCPreSchdDateToDesc.setOptionalLabel();
		}
		return DCPreSchdDateToDesc;
	}

	public TextDateWithCheckBox getPreSchdADateTo() {
		if (PreSchdADateTo == null) {
			PreSchdADateTo = new TextDateWithCheckBox() {
				@Override
				public void onBlur() {
					if (!PreSchdADateTo.isEmpty()
							&& DateTimeUtil.compareTo(PreSchdADateTo.getText(), getPreSchdADateFrom().getText()) < 0) {
						Factory.getInstance().addErrorMessage("From Date must be smaller than To Date.", PreSchdADateTo);
						PreSchdADateTo.resetText();
					}
				}
			};
			PreSchdADateTo.setBounds(275, 65, 118, 20);
		}
		return PreSchdADateTo;
	}

	public TextDateWithCheckBox getDCPreSchdDateTo() {
		if (DCPreSchdDateTo == null) {
			DCPreSchdDateTo = new TextDateWithCheckBox() {
				@Override
				public void onBlur() {
					if (!DCPreSchdDateTo.isEmpty()
							&& DateTimeUtil.compareTo(DCPreSchdDateTo.getText(), getDCPreSchdDateFrom().getText()) < 0) {
						Factory.getInstance().addErrorMessage("From Date must be smaller than To Date.", DCPreSchdDateTo);
						DCPreSchdDateTo.resetText();
					}
				}
			};
			DCPreSchdDateTo.setBounds(275, 65, 118, 20);
		}
		return DCPreSchdDateTo;
	}

	public LabelSmallBase getPreWardDesc() {
		if (PreWardDesc == null) {
			PreWardDesc = new LabelSmallBase();
			PreWardDesc.setText("Ward");
			PreWardDesc.setBounds(435, 65, 42, 20);
			PreWardDesc.setOptionalLabel();
		}
		return PreWardDesc;
	}

	public LabelSmallBase getDCPreWardDesc() {
		if (DCPreWardDesc == null) {
			DCPreWardDesc = new LabelSmallBase();
			DCPreWardDesc.setText("Ward");
			DCPreWardDesc.setBounds(435, 65, 42, 20);
			DCPreWardDesc.setOptionalLabel();
		}
		return DCPreWardDesc;
	}

	public ComboWard getPreWard() {
		if (PreWard == null) {
			PreWard = new ComboWard(false);
			PreWard.setBounds(485, 65, 101, 20);
		}
		return PreWard;
	}

	public ComboWard getDCPreWard() {
		if (DCPreWard == null) {
			DCPreWard = new ComboWard(false);
			DCPreWard.setBounds(485, 65, 101, 20);
		}
		return DCPreWard;
	}

	public LabelSmallBase getPreCancelDesc() {
		if (PreCancelDesc == null) {
			PreCancelDesc = new LabelSmallBase();
			PreCancelDesc.setText("Cancelled");
			PreCancelDesc.setBounds(599, 49, 70, 20);
			PreCancelDesc.setOptionalLabel();
		}
		return PreCancelDesc;
	}

	public LabelSmallBase getDCPreCancelDesc() {
		if (DCPreCancelDesc == null) {
			DCPreCancelDesc = new LabelSmallBase();
			DCPreCancelDesc.setText("Cancelled");
			DCPreCancelDesc.setBounds(599, 49, 70, 20);
			DCPreCancelDesc.setOptionalLabel();
		}
		return DCPreCancelDesc;
	}

	public ComboShowType getPreCancel() {
		if (PreCancel == null) {
			PreCancel = new ComboShowType();
			PreCancel.setBounds(659, 49, 95, 20);
		}
		return PreCancel;
	}

	public ComboShowType getDCPreCancel() {
		if (DCPreCancel == null) {
			DCPreCancel = new ComboShowType();
			DCPreCancel.setBounds(659, 49, 95, 20);
		}
		return DCPreCancel;
	}

	public LabelSmallBase getPreOTCaseDesc() {
		if (PreOTCaseDesc == null) {
			PreOTCaseDesc = new LabelSmallBase();
			PreOTCaseDesc.setText("OT Case");
			PreOTCaseDesc.setBounds(599, 71, 61, 20);
			PreOTCaseDesc.setOptionalLabel();
		}
		return PreOTCaseDesc;
	}

	public LabelSmallBase getDCPreOTCaseDesc() {
		if (DCPreOTCaseDesc == null) {
			DCPreOTCaseDesc = new LabelSmallBase();
			DCPreOTCaseDesc.setText("OT Case");
			DCPreOTCaseDesc.setBounds(599, 71, 61, 20);
			DCPreOTCaseDesc.setOptionalLabel();
		}
		return DCPreOTCaseDesc;
	}

	public ComboShowType getPreOTCase() {
		if (PreOTCase == null) {
			PreOTCase = new ComboShowType() {
				@Override
				public void resetText() {
					setSelectedIndex(0);
				}
			};
			PreOTCase.setBounds(659, 71, 95, 20);
		}
		return PreOTCase;
	}

	public ComboShowType getDCPreOTCase() {
		if (DCPreOTCase == null) {
			DCPreOTCase = new ComboShowType() {
				@Override
				public void resetText() {
					setSelectedIndex(0);
				}
			};
			DCPreOTCase.setBounds(659, 71, 95, 20);
		}
		return DCPreOTCase;
	}

	public LabelSmallBase getPreOrdDateFromDesc() {
		if (PreOrdDateFromDesc == null) {
			PreOrdDateFromDesc = new LabelSmallBase();
			PreOrdDateFromDesc.setText("Order Date From");
			PreOrdDateFromDesc.setBounds(10, 93, 122, 20);
			PreOrdDateFromDesc.setOptionalLabel();
		}
		return PreOrdDateFromDesc;
	}

	public LabelSmallBase getDCPreOrdDateFromDesc() {
		if (DCPreOrdDateFromDesc == null) {
			DCPreOrdDateFromDesc = new LabelSmallBase();
			DCPreOrdDateFromDesc.setText("Order Date From");
			DCPreOrdDateFromDesc.setBounds(10, 93, 122, 20);
			DCPreOrdDateFromDesc.setOptionalLabel();
		}
		return DCPreOrdDateFromDesc;
	}

	public TextDateWithCheckBox getPreOrdDateFrom() {
		if (PreOrdDateFrom == null) {
			PreOrdDateFrom = new TextDateWithCheckBox();
			PreOrdDateFrom.setBounds(120, 93, 118, 20);
		}
		return PreOrdDateFrom;
	}

	public TextDateWithCheckBox getDCPreOrdDateFrom() {
		if (DCPreOrdDateFrom == null) {
			DCPreOrdDateFrom = new TextDateWithCheckBox();
			DCPreOrdDateFrom.setBounds(120, 93, 118, 20);
		}
		return DCPreOrdDateFrom;
	}

	public LabelSmallBase getPreOrdDateToDesc() {
		if (PreOrdDateToDesc == null) {
			PreOrdDateToDesc = new LabelSmallBase();
			PreOrdDateToDesc.setText("to");
			PreOrdDateToDesc.setBounds(256, 93, 20, 20);
			PreOrdDateToDesc.setOptionalLabel();
		}
		return PreOrdDateToDesc;
	}

	public LabelSmallBase getDCPreOrdDateToDesc() {
		if (DCPreOrdDateToDesc == null) {
			DCPreOrdDateToDesc = new LabelSmallBase();
			DCPreOrdDateToDesc.setText("to");
			DCPreOrdDateToDesc.setBounds(256, 93, 20, 20);
			DCPreOrdDateToDesc.setOptionalLabel();
		}
		return DCPreOrdDateToDesc;
	}

	public TextDateWithCheckBox getPreOrdDateTo() {
		if (PreOrdDateTo == null) {
			PreOrdDateTo = new TextDateWithCheckBox();
			PreOrdDateTo.setBounds(276, 93, 118, 20);
		}
		return PreOrdDateTo;
	}

	public TextDateWithCheckBox getDCPreOrdDateTo() {
		if (DCPreOrdDateTo == null) {
			DCPreOrdDateTo = new TextDateWithCheckBox();
			DCPreOrdDateTo.setBounds(276, 93, 118, 20);
		}
		return DCPreOrdDateTo;
	}

	public LabelSmallBase getPreDepositDesc() {
		if (PreDepositDesc == null) {
			PreDepositDesc = new LabelSmallBase();
			PreDepositDesc.setText("Deposit");
			PreDepositDesc.setBounds(435, 93, 55, 20);
			PreDepositDesc.setOptionalLabel();
		}
		return PreDepositDesc;
	}

	public LabelSmallBase getDCPreDepositDesc() {
		if (DCPreDepositDesc == null) {
			DCPreDepositDesc = new LabelSmallBase();
			DCPreDepositDesc.setText("Deposit");
			DCPreDepositDesc.setBounds(435, 93, 55, 20);
			DCPreDepositDesc.setOptionalLabel();
		}
		return DCPreDepositDesc;
	}

	public ComboDeposit getPreDeposit() {
		if (PreDeposit == null) {
			PreDeposit = new ComboDeposit();
			PreDeposit.setBounds(485, 93, 101, 20);
		}
		return PreDeposit;
	}

	public ComboDeposit getDCPreDeposit() {
		if (DCPreDeposit == null) {
			DCPreDeposit = new ComboDeposit();
			DCPreDeposit.setBounds(485, 93, 101, 20);
		}
		return DCPreDeposit;
	}

	public LabelSmallBase getPreDeclinDesc() {
		if (PreDeclinDesc == null) {
			PreDeclinDesc = new LabelSmallBase();
			PreDeclinDesc.setText("Declined");
			PreDeclinDesc.setBounds(599, 93, 61, 20);
			PreDeclinDesc.setOptionalLabel();
		}
		return PreDeclinDesc;
	}

	public LabelSmallBase getDCPreDeclinDesc() {
		if (DCPreDeclinDesc == null) {
			DCPreDeclinDesc = new LabelSmallBase();
			DCPreDeclinDesc.setText("Declined");
			DCPreDeclinDesc.setBounds(599, 93, 61, 20);
			DCPreDeclinDesc.setOptionalLabel();
		}
		return DCPreDeclinDesc;
	}

	public ComboShowType getPreDeclin() {
		if (PreDeclin == null) {
			PreDeclin = new ComboShowType();
			PreDeclin.setBounds(659, 93, 95, 20);
		}
		return PreDeclin;
	}

	public ComboShowType getDCPreDeclin() {
		if (DCPreDeclin == null) {
			DCPreDeclin = new ComboShowType();
			DCPreDeclin.setBounds(659, 93, 95, 20);
		}
		return DCPreDeclin;
	}

	public BasePanel getPreBookPanel() {
		if (PreBookPanel == null) {
			PreBookPanel = new BasePanel();
			PreBookPanel.setBounds(5, 5, 790, 480);
			PreBookPanel.add(getPreParaPanel(), null);
			PreBookPanel.add(getPreListTable(), null);
			PreBookPanel.add(getPreIPReg(), null);
			PreBookPanel.add(getPreOTAB(), null);
			PreBookPanel.add(getPrePBL(), null);
			PreBookPanel.add(getPreCount(), null);
			PreBookPanel.add(getPreIP_RetrDesc(), null);
			PreBookPanel.add(getPrePB_RetrDesc(), null);
			PreBookPanel.add(getPreIP_TotalDesc(), null);
			PreBookPanel.add(getPreIP_Retr(), null);
			PreBookPanel.add(getPrePB_Retr(), null);
			PreBookPanel.add(getPreIP_Total(), null);
			PreBookPanel.add(getPreIP_Total_PB(), null);
			PreBookPanel.add(getPreIP_Total_PBDesc(), null);
		}
		return PreBookPanel;
	}

	public BasePanel getDCPreBookPanel() {
		if (DCPreBookPanel == null) {
			DCPreBookPanel = new BasePanel();
			DCPreBookPanel.setBounds(5, 5, 790, 480);
			DCPreBookPanel.add(getDCPreParaPanel(), null);
			DCPreBookPanel.add(getDCPreListTable(), null);
			DCPreBookPanel.add(getPreDCReg(), null);
			DCPreBookPanel.add(getPrintPicklist(), null);
			DCPreBookPanel.add(getPreDCCount(), null);
			DCPreBookPanel.add(getPreDC_RetrDesc(), null);
			DCPreBookPanel.add(getPreDC_Retr(), null);
		}
		return DCPreBookPanel;
	}

	public BasePanel getPreParaPanel() {
		if (PreParaPanel == null) {
			PreParaPanel = new BasePanel();
			PreParaPanel.add(getPrePatientNoDesc(), null);
			PreParaPanel.add(getPrePatientNo(), null);
			PreParaPanel.add(getPreDocDesc(), null);
			PreParaPanel.add(getPreDoc(), null);
			PreParaPanel.add(getPreNameDesc(), null);
			PreParaPanel.add(getPreName(), null);
			PreParaPanel.add(getPreChiNameDesc(), null);
			PreParaPanel.add(getPreChiName(), null);
			PreParaPanel.add(getPreDrCodeDesc(), null);
			PreParaPanel.add(getPreDrCode(), null);
			PreParaPanel.add(getPreDrNameDesc(), null);
			PreParaPanel.add(getPreDrName(), null);
			PreParaPanel.add(getPreBookTypeDesc(), null);
			PreParaPanel.add(getPreBookType(), null);
			PreParaPanel.add(getPreSchdADateFromDesc(), null);
			PreParaPanel.add(getPreSchdADateFrom(), null);
			PreParaPanel.add(getPreSchdADateToDesc(), null);
			PreParaPanel.add(getPreSchdADateTo(), null);
			PreParaPanel.add(getPreWardDesc(), null);
			PreParaPanel.add(getPreWard(), null);
			PreParaPanel.add(getPreCancelDesc(), null);
			PreParaPanel.add(getPreCancel(), null);
			PreParaPanel.add(getPreOTCaseDesc(), null);
			PreParaPanel.add(getPreOrdDateFrom(), null);
			PreParaPanel.add(getPreOrdDateFromDesc(), null);
			PreParaPanel.add(getPreOrdDateTo(), null);
			PreParaPanel.add(getPreOrdDateToDesc(), null);
			PreParaPanel.add(getPreDeposit(), null);
			PreParaPanel.add(getPreDepositDesc(), null);
			PreParaPanel.add(getPreDeclin(), null);
			PreParaPanel.add(getPreDeclinDesc(), null);
			PreParaPanel.add(getPreCancel(), null);
			PreParaPanel.add(getPreDrCodeDesc(), null);
			PreParaPanel.add(getPreSortByDesc(), null);
			PreParaPanel.add(getPreSortBy(), null);
			PreParaPanel.add(getPreOTCase(), null);
			PreParaPanel.setLocation(5, 5);
			PreParaPanel.setSize(759, 127);
		}
		return PreParaPanel;
	}

	private TableList getPreListTable() {
		if (PreListTable == null) {
			PreListTable = new BufferedTableList(getPreListTableColumnNames(),
													getPreListTableColumnWidths()) {
				@Override
				public void setColumnStyle(int col, final String style) {
					ColumnConfig column = getColumnModel().getColumn(col);
					column.setRenderer(new GeneralGridCellRenderer() {
						@Override
						public Object render(TableData model, String property,
								ColumnData config,
								int rowIndex, int colIndex, ListStore<TableData> store,
								Grid<TableData> grid) {
							if (ConstantsVariable.MINUS_ONE_VALUE.equals(model.get("refused").toString())) {
								return "<" + style + ">" + model.get(property).toString() + "</" + style + ">";
							} else {
								return super.render(model, property, config, rowIndex, colIndex, store, grid);
							}
						}
					});
				}

				@Override
				public void onSelectionChanged() {
					if (getPreListTable().getRowCount() > 0 && getPreListTable().getSelectedRowContent() != null) {
						lpbpid = ZERO_VALUE;
						lpbpid = getPreListTable().getSelectedRowContent()[GrdPbCol_PbPid];

						if (lpbpid != null && lpbpid.length() > 0 && !ZERO_VALUE.equals(lpbpid) &&
								NO_VALUE.equals(getPreListTable().getSelectedRowContent()[GrdPbCol_Status]) &&
								ZERO_VALUE.equals(getPreListTable().getSelectedRowContent()[GrdPbCol_isRefused])) {
							if (!"OT".equals(paraFromWhere)) {
								getPreOTAB().setEnabled(true);//!isDisableFunction("cmdOTApp", "srhPatStsView"));
							} else {
								getPreOTAB().setEnabled(true);
							}

							if (MINUS_ONE_VALUE.equals(getPreListTable().getSelectedRowContent()[GrdPbCol_ForDelivery])) {
								getPrePBL().setEnabled(true);
							} else {
								getPrePBL().setEnabled(false);
							}

							if (isPreIPRegEnable) {
								getPreIPReg().setEnabled(true);
							} else {
								getPreIPReg().setEnabled(false);
							}
						} else {
							getPreOTAB().setEnabled(false);
							getPrePBL().setEnabled(false);
							getPreIPReg().setEnabled(false);
						}
					 }
				}

				@Override
				public void setListTableContentPost() {
					super.setListTableContentPost();
					getPreListTable().getView().layout();
				}
			};
			//PreListTable.setTableLength(getListWidth());

			getPreListTable().setColumnStyle(1, "STRIKE");
			getPreListTable().setColumnStyle(2, "STRIKE");
			getPreListTable().setColumnStyle(3, "STRIKE");
			getPreListTable().setColumnStyle(4, "STRIKE");
			getPreListTable().setColumnStyle(5, "STRIKE");
			getPreListTable().setColumnStyle(6, "STRIKE");
			getPreListTable().setColumnStyle(7, "STRIKE");
			getPreListTable().setColumnStyle(8, "STRIKE");
			getPreListTable().setColumnStyle(9, "STRIKE");
			getPreListTable().setColumnStyle(10, "STRIKE");
			getPreListTable().setColumnStyle(11, "STRIKE");
			getPreListTable().setColumnStyle(12, "STRIKE");
			getPreListTable().setColumnStyle(13, "STRIKE");
			getPreListTable().setColumnStyle(14, "STRIKE");
			getPreListTable().setColumnStyle(15, "STRIKE");
			getPreListTable().setColumnStyle(16, "STRIKE");
			getPreListTable().setColumnStyle(17, "STRIKE");
			getPreListTable().setColumnStyle(18, "STRIKE");
			getPreListTable().setColumnStyle(19, "STRIKE");
			getPreListTable().setColumnStyle(20, "STRIKE");
			getPreListTable().setColumnStyle(21, "STRIKE");
			getPreListTable().setColumnStyle(22, "STRIKE");
			getPreListTable().setColumnStyle(23, "STRIKE");
			getPreListTable().setColumnStyle(24, "STRIKE");
			getPreListTable().setColumnStyle(25, "STRIKE");
			getPreListTable().setColumnStyle(35, "STRIKE");
			getPreListTable().setColumnStyle(36, "STRIKE");
			getPreListTable().setColumnStyle(37, "STRIKE");
			getPreListTable().setColumnStyle(38, "STRIKE");
			getPreListTable().setColumnStyle(39, "STRIKE");
			getPreListTable().setColumnStyle(40, "STRIKE");
			PreListTable.setBounds(5, 128, 759, 285);
		}
		return PreListTable;
	}

	protected String[] getPreListTableColumnNames() {
		return new String[] {
				"", "Status","Booking #","Patient No","Patient Name", //0-4
				"Chi. Name","Ordered By","Sex","Age","Class", //5-9
				"Ward","Schd Adm Date","EDC","Rmk","Doc #", //10-14
				"*BE","Bed","Available","Order Date","Created By", //15-19
				"Est Given", //20
				"PBO Remark",
				"Contact Phone No.",
				"Patient Mobile Phone",
				"OT Procedure",
				"Surgery time",
				"Cath Lab Remark",
				"Slip No",
				"Edit By",
				"Edit Date",//index=25
				"Refused", "", "", "", "", "", "", "", "", "SMS sent date/time", "Email sent date/time", "", ""
				};
	}

	protected int[] getPreListTableColumnWidths() {
		return new int[] {
				10,40,80,60,120,
				80,100,35,45,45,
				45,110,
				(HKAH_VALUE.equals(getUserInfo().getSiteCode()))?65:0,//EDC
				(HKAH_VALUE.equals(getUserInfo().getSiteCode()))?40:0,//Rmk
				130,
				(HKAH_VALUE.equals(getUserInfo().getSiteCode()))?60:0,//BE
				90,120,120,80,
				(HKAH_VALUE.equals(getUserInfo().getSiteCode()))?60:0,//EST
				120,120,120,120,120,120,80,80,80,
				5,0,0,0,0,0,0,0,0,150,150, 0, 0};
	}

	public BasePanel getDCPreParaPanel() {
		if (DCPreParaPanel == null) {
			DCPreParaPanel = new BasePanel();
			DCPreParaPanel.add(getDCPrePatientNoDesc(), null);
			DCPreParaPanel.add(getDCPrePatientNo(), null);
			DCPreParaPanel.add(getDCPreDocDesc(), null);
			DCPreParaPanel.add(getDCPreDoc(), null);
			DCPreParaPanel.add(getDCPreNameDesc(), null);
			DCPreParaPanel.add(getDCPreName(), null);
			DCPreParaPanel.add(getDCPreChiNameDesc(), null);
			DCPreParaPanel.add(getDCPreChiName(), null);
			DCPreParaPanel.add(getDCPreDrCodeDesc(), null);
			DCPreParaPanel.add(getDCPreDrCode(), null);
			DCPreParaPanel.add(getDCPreDrNameDesc(), null);
			DCPreParaPanel.add(getDCPreDrName(), null);
			DCPreParaPanel.add(getDCPreBookTypeDesc(), null);
			DCPreParaPanel.add(getDCPreBookType(), null);
			DCPreParaPanel.add(getDCPreSchdADateFromDesc(), null);
			DCPreParaPanel.add(getDCPreSchdDateFrom(), null);
			DCPreParaPanel.add(getDCPreSchdDateToDesc(), null);
			DCPreParaPanel.add(getDCPreSchdDateTo(), null);
			DCPreParaPanel.add(getDCPreWardDesc(), null);
			DCPreParaPanel.add(getDCPreWard(), null);
			DCPreParaPanel.add(getDCPreCancelDesc(), null);
			DCPreParaPanel.add(getDCPreCancel(), null);
			DCPreParaPanel.add(getDCPreOTCaseDesc(), null);
			DCPreParaPanel.add(getDCPreOrdDateFrom(), null);
			DCPreParaPanel.add(getDCPreOrdDateFromDesc(), null);
			DCPreParaPanel.add(getDCPreOrdDateTo(), null);
			DCPreParaPanel.add(getDCPreOrdDateToDesc(), null);
			DCPreParaPanel.add(getDCPreDeposit(), null);
			DCPreParaPanel.add(getDCPreDepositDesc(), null);
			DCPreParaPanel.add(getDCPreDeclin(), null);
			DCPreParaPanel.add(getDCPreDeclinDesc(), null);
			DCPreParaPanel.add(getDCPreCancel(), null);
			DCPreParaPanel.add(getDCPreDrCodeDesc(), null);
			DCPreParaPanel.add(getDCPreSortByDesc(), null);
			DCPreParaPanel.add(getDCPreSortBy(), null);
			DCPreParaPanel.add(getDCPreOTCase(), null);
			DCPreParaPanel.setLocation(5, 5);
			DCPreParaPanel.setSize(759, 127);
		}
		return DCPreParaPanel;
	}

	private TableList getDCPreListTable() {
		if (DCPreListTable == null) {
			DCPreListTable = new BufferedTableList(getDCPreListTableColumnNames(),
													getDCPreListTableColumnWidths()) {
				@Override
				public void setColumnStyle(int col, final String style) {
					ColumnConfig column = getColumnModel().getColumn(col);
					column.setRenderer(new GeneralGridCellRenderer() {
						@Override
						public Object render(TableData model, String property,
								ColumnData config,
								int rowIndex, int colIndex, ListStore<TableData> store,
								Grid<TableData> grid) {
							if (ConstantsVariable.MINUS_ONE_VALUE.equals(model.get("refused").toString())) {
								return "<" + style + ">" + model.get(property).toString() + "</" + style + ">";
							} else {
								return super.render(model, property, config, rowIndex, colIndex, store, grid);
							}
						}
					});
				}

				@Override
				public void onSelectionChanged() {
					if (getDCPreListTable().getRowCount() > 0 && getDCPreListTable().getSelectedRowContent() != null) {
						lpbpid = ZERO_VALUE;
						lpbpid = getDCPreListTable().getSelectedRowContent()[GrdPbCol_PbPid];

						if (lpbpid != null && lpbpid.length() > 0 && !ZERO_VALUE.equals(lpbpid) &&
								NO_VALUE.equals(getDCPreListTable().getSelectedRowContent()[GrdPbCol_Status]) &&
								ZERO_VALUE.equals(getDCPreListTable().getSelectedRowContent()[GrdPbCol_isRefused])) {
							if (!"OT".equals(paraFromWhere)) {
								getPreOTAB().setEnabled(true);//!isDisableFunction("cmdOTApp", "srhPatStsView"));
							} else {
								getPreOTAB().setEnabled(true);
							}

							if (MINUS_ONE_VALUE.equals(getDCPreListTable().getSelectedRowContent()[GrdPbCol_ForDelivery])) {
								getPrePBL().setEnabled(true);
							} else {
								getPrePBL().setEnabled(false);
							}

							if (isPreDCRegEnable) {
								getPreDCReg().setEnabled(true);
							} else {
								getPreDCReg().setEnabled(false);
							}
						} else {
							getPreDCReg().setEnabled(false);
						}
					 }
				}

				@Override
				public void setListTableContentPost() {
					super.setListTableContentPost();
					getDCPreListTable().getView().layout();
				}
			};
			//DCPreListTable.setTableLength(getListWidth());

			getDCPreListTable().setColumnStyle(1, "STRIKE");
			getDCPreListTable().setColumnStyle(2, "STRIKE");
			getDCPreListTable().setColumnStyle(3, "STRIKE");
			getDCPreListTable().setColumnStyle(4, "STRIKE");
			getDCPreListTable().setColumnStyle(5, "STRIKE");
			getDCPreListTable().setColumnStyle(6, "STRIKE");
			getDCPreListTable().setColumnStyle(7, "STRIKE");
			getDCPreListTable().setColumnStyle(8, "STRIKE");
			getDCPreListTable().setColumnStyle(9, "STRIKE");
			getDCPreListTable().setColumnStyle(10, "STRIKE");
			getDCPreListTable().setColumnStyle(11, "STRIKE");
			getDCPreListTable().setColumnStyle(12, "STRIKE");
			getDCPreListTable().setColumnStyle(13, "STRIKE");
			getDCPreListTable().setColumnStyle(14, "STRIKE");
			getDCPreListTable().setColumnStyle(15, "STRIKE");
			getDCPreListTable().setColumnStyle(16, "STRIKE");
			getDCPreListTable().setColumnStyle(17, "STRIKE");
			getDCPreListTable().setColumnStyle(18, "STRIKE");
			getDCPreListTable().setColumnStyle(19, "STRIKE");
			getDCPreListTable().setColumnStyle(20, "STRIKE");
			getDCPreListTable().setColumnStyle(21, "STRIKE");
			getDCPreListTable().setColumnStyle(22, "STRIKE");
			getDCPreListTable().setColumnStyle(23, "STRIKE");
			getDCPreListTable().setColumnStyle(24, "STRIKE");
			getDCPreListTable().setColumnStyle(25, "STRIKE");
			getDCPreListTable().setColumnStyle(35, "STRIKE");
			getDCPreListTable().setColumnStyle(36, "STRIKE");
			getDCPreListTable().setColumnStyle(37, "STRIKE");
			getDCPreListTable().setColumnStyle(38, "STRIKE");
			getDCPreListTable().setColumnStyle(39, "STRIKE");
			getDCPreListTable().setColumnStyle(40, "STRIKE");
			DCPreListTable.setBounds(5, 128, 759, 285);
		}
		return DCPreListTable;
	}

	protected String[] getDCPreListTableColumnNames() {
		return new String[] {
				"", "Status","","Patient No","Patient Name", //0-4
				"Chi. Name","Ordered By","Sex","Age","", //5-9
				"","Schd Date","","","", //10-14
				"*BE","","","Order Date","Created By", //15-19
				"Est Given", //20
				"PBO Remark",
				"Contact Phone No.",
				"Patient Mobile Phone",
				"OT Procedure",
				"Surgery time",
				"",
				"",
				"Edit By",
				"Edit Date",//index=25
				"Refused", "", "", "", "", "", "", "", "", "", "", "", ""
				};
	}

	protected int[] getDCPreListTableColumnWidths() {
		return new int[] {
				10,40,0,60,120,
				80,100,35,45,0,
				0,110,
				0,//EDC
				0,//Rmk
				0,//Doc #
				(HKAH_VALUE.equals(getUserInfo().getSiteCode()))?60:0,//BE
				0,0,120,80,
				0,//EST
				120,120,120,120,120,0,0,80,80,
				0,0,0,0,0,0,0,0,0,0,0, 0, 0};
	}

	public ButtonBase getPreIPReg() {
		if (PreIPReg == null) {
			PreIPReg = new ButtonBase() {
				@Override
				public void onClick() {
					IPReg();
				}
			};
			PreIPReg.setText("IP Registration", 'I');
			PreIPReg.setBounds(7, 428, 114, 30);
		}
		return PreIPReg;
	}

	public ButtonBase getPreDCReg() {
		if (PreDCReg == null) {
			PreDCReg = new ButtonBase() {
				@Override
				public void onClick() {
					DCReg();
				}
			};
			PreDCReg.setText("Daycase Registration", 'D');
			PreDCReg.setBounds(7, 428, 114, 30);
		}
		return PreDCReg;
	}

	private ButtonBase getPrintPicklist() {
		if (PrintPicklist == null) {
			PrintPicklist = new ButtonBase() {
				@Override
				public void onClick() {
					printRptDCAppListing();
				}
			};
			PrintPicklist.setText("Print Picklist");
			PrintPicklist.setBounds(130, 428, 114, 30);

		}
		return PrintPicklist;
	}

	public ButtonBase getPreOTAB() {
		if (PreOTAB == null) {
			PreOTAB = new ButtonBase() {
				@Override
				public void onClick() {
					setParameter("FromPreBooking", "srhPatStsView");
					setParameter("lotPBPID",getPreListTable().getSelectedRowContent()[GrdPbCol_PbPid]);
					showPanel(new OTAppointmentBrowse());
				}
			};
			PreOTAB.setText("OT Appointment Browse", 'O');
			PreOTAB.setBounds(126, 428, 157, 30);
		}
		return PreOTAB;
	}

	public ButtonBase getPrePBL() {
		if (PrePBL == null) {
			PrePBL = new ButtonBase() {
				@Override
				public void onClick() {
					if (getPreListTable().getSelectedRow() == -1) {
						return;
					}

					if (MINUS_ONE_VALUE.equals(getPreListTable().getSelectedRowContent()[GrdPbCol_ForDelivery]) &&
							NO_VALUE.equals(getPreListTable().getSelectedRowContent()[GrdPbCol_Status])) {
						// return function
					} else {
						HashMap<String, String> map = new HashMap<String, String>();
						map.put("Image", CommonUtil.getReportImg("rpt_logo2.jpg"));
						PrintingUtil.print("OBBooking_"+Factory.getInstance().getUserInfo().getSiteCode(),
								map,"",
								new String[] {getPreListTable().getSelectedRowContent()[GrdPbCol_PbPid]},
								new String[] {"PATNAME","PATCNAME","BPBHDATE",
										"BPBNO","DOCNAME","DOCFAXNO","DOCOTEL","PRINTDATE"});
					}
				}
			};
			PrePBL.setText("Print Booking Letter", 'P');
			PrePBL.setBounds(289, 428, 137, 30);
		}
		return PrePBL;
	}

	public LabelSmallBase getPreCount() {
		if (PreCount == null) {
			PreCount = new LabelSmallBase();
			PreCount.setText("Count:");
			PreCount.setBounds(437, 438, 47, 20);
		}
		return PreCount;
	}

	public LabelSmallBase getPreDCCount() {
		if (PreDCCount == null) {
			PreDCCount = new LabelSmallBase();
			PreDCCount.setText("Count:");
			PreDCCount.setBounds(595, 438, 58, 20);
		}
		return PreDCCount;
	}

	public LabelSmallBase getPreIP_RetrDesc() {
		if (PreIP_RetrDesc == null) {
			PreIP_RetrDesc = new LabelSmallBase();
			PreIP_RetrDesc.setText("IP Retr.");
			PreIP_RetrDesc.setBounds(480, 417, 58, 20);
		}
		return PreIP_RetrDesc;
	}

	public LabelSmallBase getPrePB_RetrDesc() {
		if (PrePB_RetrDesc == null) {
			PrePB_RetrDesc = new LabelSmallBase();
			PrePB_RetrDesc.setText("PB Retr.");
			PrePB_RetrDesc.setBounds(537, 417, 58, 20);
		}
		return PrePB_RetrDesc;
	}

	public LabelSmallBase getPreDC_RetrDesc() {
		if (PreDC_RetrDesc == null) {
			PreDC_RetrDesc = new LabelSmallBase();
			PreDC_RetrDesc.setText("Total DC");
			PreDC_RetrDesc.setBounds(652, 417, 104, 20);
		}
		return PreDC_RetrDesc;
	}

	public LabelSmallBase getPreIP_TotalDesc() {
		if (PreIP_TotalDesc == null) {
			PreIP_TotalDesc = new LabelSmallBase();
			PreIP_TotalDesc.setText("Total IP");
			PreIP_TotalDesc.setBounds(595, 417, 58, 20);
		}
		return PreIP_TotalDesc;
	}

	public LabelSmallBase getPreIP_Total_PBDesc() {
		if (PreIP_Total_PBDesc == null) {
			PreIP_Total_PBDesc = new LabelSmallBase();
			PreIP_Total_PBDesc.setText("Total IP(Incl.PB)");
			PreIP_Total_PBDesc.setBounds(652, 417, 104, 20);
		}
		return PreIP_Total_PBDesc;
	}

	public TextReadOnly getPreIP_Retr() {
		if (PreIP_Retr == null) {
			PreIP_Retr = new TextReadOnly();
			PreIP_Retr.setBounds(480, 438, 58, 20);
			PreIP_Retr.setText(ZERO_VALUE);
			PreIP_Retr.setAllowReset(false);
		}
		return PreIP_Retr;
	}

	public TextReadOnly getPrePB_Retr() {
		if (PrePB_Retr == null) {
			PrePB_Retr = new TextReadOnly();
			PrePB_Retr.setBounds(537, 438, 58, 20);
			PrePB_Retr.setText(ZERO_VALUE);
			PrePB_Retr.setAllowReset(false);
		}
		return PrePB_Retr;
	}

	public TextReadOnly getPreDC_Retr() {
		if (PreDC_Retr == null) {
			PreDC_Retr = new TextReadOnly();
			PreDC_Retr.setBounds(652, 438, 104, 20);
			PreDC_Retr.setText(ZERO_VALUE);
			PreDC_Retr.setAllowReset(false);
		}
		return PreDC_Retr;
	}

	public TextReadOnly getPreIP_Total() {
		if (PreIP_Total == null) {
			PreIP_Total = new TextReadOnly();
			PreIP_Total.setBounds(595, 438, 58, 20);
			PreIP_Total.setText(ZERO_VALUE);
			PreIP_Total.setAllowReset(false);
		}
		return PreIP_Total;
	}

	public TextReadOnly getPreIP_Total_PB() {
		if (PreIP_Total_PB == null) {
			PreIP_Total_PB = new TextReadOnly();
			PreIP_Total_PB.setBounds(652, 438, 104, 20);
			PreIP_Total_PB.setText(ZERO_VALUE);
			PreIP_Total_PB.setAllowReset(false);
		}
		return PreIP_Total_PB;
	}

	public BasePanel getCheckDupPanel() {
		if (CheckDupPanel == null) {
			CheckDupPanel = new BasePanel();
			CheckDupPanel.add(getJScrollPane_CheckListTable(), null);
			CheckDupPanel.add(getChkCount(), null);
			CheckDupPanel.add(getChkIP_RetrDesc(), null);
			CheckDupPanel.add(getChkPB_RetrDesc(), null);
			CheckDupPanel.add(getChkIP_TotalDesc(), null);
			CheckDupPanel.add(getChkIP_Retr(), null);
			CheckDupPanel.add(getChkPB_Retr(), null);
			CheckDupPanel.add(getChkIP_Total(), null);
			CheckDupPanel.add(getChkIP_Total_PB(), null);
			CheckDupPanel.add(getChkIP_Total_PBDesc(), null);
			CheckDupPanel.setBounds(5, 5, 759, 127);
		}
		return CheckDupPanel;
	}

	private JScrollPane getJScrollPane_CheckListTable() {
		if (JScrollPane_CheckListTable == null) {
			JScrollPane_CheckListTable = new JScrollPane();
			JScrollPane_CheckListTable.setViewportView(getCheckListTable());
			JScrollPane_CheckListTable.setBounds(5, 5, 759, 395);
		}
		return JScrollPane_CheckListTable;
	}

	private TableList getCheckListTable() {
		if (CheckListTable == null) {
			CheckListTable = new TableList(getCheckListTableColumnNames(), getCheckListTableColumnWidths()) {
				public void setListTableContentPost() {
					if (CheckListTable.getRowCount() == 0) {
						Factory.getInstance().addErrorMessage(NO_RECORD_FOUND);
					}

					if (isSearchDup) {
						QueryUtil.executeMasterBrowse(getUserInfo(), "STATUSVIEWALL",
								new String[] {null},
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									List<String[]> allList = new ArrayList<String[]>();
									allList.addAll(mQueue.getContentAsArray());
									getARS_Dup2(0, allList, new LinkedHashMap<String, String[]>());
								} else {
									getARS_DupPost(null);
								}
							}
						});
					} else {
						isSearchDup = true;
						getARS_DupPost(null);
					}
				}
			};
			CheckListTable.setTableLength(getListWidth());
			//PatStatusTable.setColumnClass(0, ComboPackage.class, true);
			//PatStatusTable.setColumnClass(1, String.class, true);
		}
		return CheckListTable;
	}


	protected String[] getCheckListTableColumnNames() {
		return new String[] { "",
				"Status",
				"Reg Type",
				"Booking #",
				"Patient No",
				"Patient Name",
				"Chi. Name",
				"Ordered By",
				"Sex",
				"Age",
				"Class",
				"Ward",
				"Schd Adm Date",
				"Document #",
				"Bed",
				"Available",
				"Order Date",
				"Created By",
				"PBO Remark",
				"Contract Phone No.",
				"Patient Mobile Phone",
				"OT Procedure",
				"Surgery time",
				"Cath Lab Remark",
				"Slip No",
				"Edit By",
				"Edit Date",
				"SMS sent date/time",
				"Email sent date/time",
				"PBPID",
				"ISREFUSED"
				};
	}

	protected int[] getCheckListTableColumnWidths() {
		return new int[] { 5,30,40,60,60,120,80,100,30,40,40,40,110,150,90,120,80,80,120,120,120,120,120,120,80,80,80,120,120,0,0};
	}

	public LabelSmallBase getChkCount() {
		if (ChkCount == null) {
			ChkCount = new LabelSmallBase();
			ChkCount.setText("Count:");
			ChkCount.setBounds(437, 438, 47, 20);
		}
		return ChkCount;
	}

	public LabelSmallBase getChkIP_RetrDesc() {
		if (ChkIP_RetrDesc == null) {
			ChkIP_RetrDesc = new LabelSmallBase();
			ChkIP_RetrDesc.setText("IP Retr.");
			ChkIP_RetrDesc.setBounds(480, 417, 58, 20);
		}
		return ChkIP_RetrDesc;
	}

	public LabelSmallBase getChkPB_RetrDesc() {
		if (ChkPB_RetrDesc == null) {
			ChkPB_RetrDesc = new LabelSmallBase();
			ChkPB_RetrDesc.setText("PB Retr.");
			ChkPB_RetrDesc.setBounds(537, 417, 58, 20);
		}
		return ChkPB_RetrDesc;
	}

	public LabelSmallBase getChkIP_TotalDesc() {
		if (ChkIP_TotalDesc == null) {
			ChkIP_TotalDesc = new LabelSmallBase();
			ChkIP_TotalDesc.setText("Total IP");
			ChkIP_TotalDesc.setBounds(595, 417, 58, 20);
		}
		return ChkIP_TotalDesc;
	}

	public LabelSmallBase getChkIP_Total_PBDesc() {
		if (ChkIP_Total_PBDesc == null) {
			ChkIP_Total_PBDesc = new LabelSmallBase();
			ChkIP_Total_PBDesc.setText("Total IP(Incl.PB)");
			ChkIP_Total_PBDesc.setBounds(652, 417, 104, 20);
		}
		return ChkIP_Total_PBDesc;
	}

	public TextReadOnly getChkIP_Retr() {
		if (ChkIP_Retr == null) {
			ChkIP_Retr = new TextReadOnly();
			ChkIP_Retr.setBounds(480, 438, 58, 20);
			ChkIP_Retr.setText(ZERO_VALUE);
			ChkIP_Retr.setAllowReset(false);
		}
		return ChkIP_Retr;
	}

	public TextReadOnly getChkPB_Retr() {
		if (ChkPB_Retr == null) {
			ChkPB_Retr = new TextReadOnly();
			ChkPB_Retr.setBounds(537, 438, 58, 20);
			ChkPB_Retr.setText(ZERO_VALUE);
			ChkPB_Retr.setAllowReset(false);
		}
		return ChkPB_Retr;
	}

	public TextReadOnly getChkIP_Total() {
		if (ChkIP_Total == null) {
			ChkIP_Total = new TextReadOnly();
			ChkIP_Total.setBounds(595, 438, 58, 20);
			ChkIP_Total.setText(ZERO_VALUE);
			ChkIP_Total.setAllowReset(false);
		}
		return ChkIP_Total;
	}

	public TextReadOnly getChkIP_Total_PB() {
		if (ChkIP_Total_PB == null) {
			ChkIP_Total_PB = new TextReadOnly();
			ChkIP_Total_PB.setText(ZERO_VALUE);
			ChkIP_Total_PB.setBounds(652, 438, 104, 20);
		}
		return ChkIP_Total_PB;
	}

	private DialogBase getAskDialog() {
		if (AskDialog == null) {
			AskDialog = new DialogBase(getMainFrame(),true);
			AskDialog.setTitle("PBA - Check Duplication");
//			AskDialog.setLayout(null);
			AskDialog.add(getCheckDupAskPanel());
//			AskDialog.setLocation(320, 240);
			AskDialog.setSize(511, 210);
			AskDialog.setResizable(false);
//			AskDialog.pack();
		}
		return AskDialog;
	}

	public BasePanel getCheckDupAskPanel() {
		if (CheckDupAskPanel == null) {
			CheckDupAskPanel = new BasePanel();
			CheckDupAskPanel.setSize(510, 188);
			CheckDupAskPanel.add(getAskLabel(), null);
			CheckDupAskPanel.add(getAskYes(), null);
			CheckDupAskPanel.add(getAskNo(), null);
			//CheckDupAskPanel.setLocation(0, 0);
			CheckDupAskPanel.add(getJPanel(), null);
			getAskOptGroup();
		}
		return CheckDupAskPanel;
	}

	public LabelSmallBase getAskLabel() {
		if (AskLabel == null) {
			AskLabel = new LabelSmallBase();
			AskLabel.setText("The process may take a while to finish");
			AskLabel.setBounds(27, 20, 250, 20);
		}
		return AskLabel;
	}

	public RadioGroup getAskOptGroup() {
		if (AskOptGroup == null) {
			AskOptGroup = new RadioGroup();
			AskOptGroup.add(getAskOptA());
			AskOptGroup.add(getAskOptB());
		}
		return AskOptGroup;
	}

	public RadioButtonBase getAskOptA() {
		if (AskOptA == null) {
			AskOptA = new RadioButtonBase();
			AskOptA.setText("List all potential duplicate bookings");
			AskOptA.setBounds(11, 14, 396, 26);
			AskOptA.setSelected(true);
		}
		return AskOptA;
	}

	public RadioButtonBase getAskOptB() {
		if (AskOptB == null) {
			AskOptB = new RadioButtonBase();
			AskOptB.setText("Show the potential duplicate bookings relate to highlighted Pre-Booking");
			AskOptB.setBounds(11, 42, 464, 26);
		}
		return AskOptB;
	}

	public ButtonBase getAskYes() {
		if (AskYes == null) {
			AskYes = new ButtonBase() {
				@Override
				public void onClick() {
					if (getAskOptA().isSelected()) {
						allDuplication();
					} else if (getAskOptB().isSelected()) {
						singleDuplication();
					}
					getAskDialog().setVisible(false);
				}
			};
			AskYes.setText("Yes");
			AskYes.setBounds(100, 136, 87, 25);
		}
		return AskYes;
	}

	public ButtonBase getAskNo() {
		if (AskNo == null) {
			AskNo = new ButtonBase() {
				@Override
				public void onClick() {
					getAskDialog().setVisible(false);
					// switch back to first tab
					getTabbedPane().setSelectedIndex(0);
				}
			};
			AskNo.setText("No");
			AskNo.setBounds(251, 136, 87, 25);

		}
		return AskNo;
	}

	private DlgSelectSlip getDlgSelectSlip() {
		if (dlgSelectSlip == null) {
			dlgSelectSlip = new DlgSelectSlip(Factory.getInstance().getMainFrame()) {
				@Override
				public void post() {
					boolean bClickCancelFlag = false;

					if (selectSlpNo.isEmpty()) {
						bClickCancelFlag = true;
					}

					if (!bClickCancelFlag) {
						setParameter("SlpNo", selectSlpNo);
						setParameter("lXregId", getListTable().getSelectedRowContent()[16]);
						setParameter("From", "srhPatStsView");
						setParameter("isNewSlip", YES_VALUE);
						showPanel(new TransactionDetail());
					}
				}
			};
		}
		return dlgSelectSlip;
	}

	/**
	 * This method initializes jPanel
	 *
	 * @return javax.swing.JPanel
	 */
	private BasePanel getJPanel() {
		if (jPanel == null) {
			jPanel = new BasePanel();
			jPanel.setLayout(null);
			jPanel.setBounds(15, 44, 484, 84);
			jPanel.add(getAskOptA(), null);
			jPanel.add(getAskOptB(), null);
		}
		return jPanel;
	}

	@Override
	protected boolean triggerSearchField() {
		if (getTabbedPane().getSelectedIndex() == 1) {
			if (getPrePatientNo().isFocusOwner()) {
				getPrePatientNo().setOldPatientNo(EMPTY_VALUE);
				if (getPrePatientNo().getText().trim().length() == 0) {
					getPrePatientNo().checkTriggerBySearchKey();
				} else {
					getPrePatientNo().checkMergePatient(true);
				}
				return true;
			} else if (getPreDrCode().isFocusOwner()) {
				getPreDrCode().checkTriggerBySearchKey();
				return true;
			}
		} else if (getTabbedPane().getSelectedIndex() == 2 && hasDayCase) {
			if (getDCPrePatientNo().isFocusOwner()) {
				getDCPrePatientNo().setOldPatientNo(EMPTY_VALUE);
				if (getDCPrePatientNo().getText().trim().length() == 0) {
					getDCPrePatientNo().checkTriggerBySearchKey();
				} else {
					getDCPrePatientNo().checkMergePatient(true);
				}
				return true;
			} else if (getDCPreDrCode().isFocusOwner()) {
				getDCPreDrCode().checkTriggerBySearchKey();
				return true;
			}
		}
		return false;
	}
}