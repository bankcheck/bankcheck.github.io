package com.hkah.client.tx.report;

import java.util.HashMap;
import java.util.Map;

import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.layout.AbsoluteLayout;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboOOSFilter;
import com.hkah.client.layout.combobox.ComboSiteType;
import com.hkah.client.layout.dialog.DlgDayEndReport;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextDoctorSearch;
import com.hkah.client.layout.textfield.TextItemCodeSearch;
import com.hkah.client.layout.textfield.TextPackageCodeSearch;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.ActionPanel;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.Report;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsProperties;
import com.hkah.shared.constants.ConstantsTx;

public class DayEndReport extends ActionPanel {

	/* >>> ~1~ Set Transaction Code =================================== <<< */
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.DAYENDREPORT_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	public String getTitle() {
		return ConstantsTx.DAYENDREPORT_TITLE;
	}

	private BasePanel actionPanel = null;

	private BasePanel CheckBoxPanel = null;
	private LabelBase ALICDesc = null;
	private CheckBoxBase ALIC = null;
	private LabelBase CTTLDesc = null;
	private CheckBoxBase CTTL = null;
	private LabelBase CMPCRDesc = null;
	private CheckBoxBase CMPCR = null;
	private LabelBase CASDesc = null;
	private CheckBoxBase CAS = null;
	private LabelBase CSRDesc = null;
	private CheckBoxBase CSR = null;
	private LabelBase DISDesc = null;
	private CheckBoxBase DIS = null;
	private LabelBase DSLDesc = null;
	private CheckBoxBase DSL = null;
	private LabelBase NADesc = null;
	private CheckBoxBase NA = null;
	private LabelBase OLBSADesc = null;
	private CheckBoxBase OLBSA = null;
	private LabelBase OBRDesc = null;
	private CheckBoxBase OBR = null;
	private LabelBase ODCSDesc = null;
	private CheckBoxBase ODCS = null;
	private LabelBase ODRDesc = null;
	private CheckBoxBase ODR = null;
	private LabelBase OISDesc = null;
	private CheckBoxBase OIS = null;
	private LabelBase OOSDesc = null;
	private CheckBoxBase OOS = null;
	private LabelBase OFRDesc = null;
	private CheckBoxBase OFR = null;
	private LabelBase ReceiptDesc = null;
	private CheckBoxBase Receipt = null;
	private LabelBase RLDesc = null;
	private CheckBoxBase RL = null;
	private LabelBase RCLDesc = null;
	private CheckBoxBase RCL = null;
	private LabelBase STECRDesc = null;
	private CheckBoxBase STECR = null;
	private LabelBase TLDesc = null;
	private CheckBoxBase TL = null;
	private LabelBase TTIDesc = null;
	private CheckBoxBase TTI = null;
	private LabelBase TCARDesc = null;
	private CheckBoxBase TCAR = null;
	private LabelBase WBillDesc = null;
	private CheckBoxBase WBill = null;
	private LabelBase CovLetterDesc = null;
	private CheckBoxBase CovLetter = null;
	private LabelBase IPStatmentWBDesc = null;
	private CheckBoxBase IPStatmentWB = null;

	private BasePanel TextPanel = null;
	private LabelBase DateRangeStartDesc = null;
	private TextDate DateRangeStart = null;
	private LabelBase DateRangeEndDesc = null;
	private TextDate DateRangeEnd = null;
	private LabelBase SiteCodeDesc = null;
	private ComboSiteType SiteCode = null;
	private LabelBase CashIDDesc = null;
	private TextString CashID = null;
	private LabelBase DoctorCodeDesc = null;
	private TextDoctorSearch DoctorCode = null;
	private LabelBase PatientCodeDesc = null;
	private TextString PatientCode = null;
	private LabelBase ItemCodeDesc = null;
	private TextItemCodeSearch ItemCode = null;
	private LabelBase PackageCodeDesc = null;
	private TextPackageCodeSearch PackageCode = null;
	private LabelBase PercentDesc = null;
	private TextString Percent = null;
	private LabelBase ARCCodeDesc = null;
	private TextString ARCCode = null;
	private LabelBase GenDateDesc = null;
	private TextDate GenDate = null;
	private LabelBase PrinttoFileDesc = null;
	private CheckBoxBase PrinttoFile = null;
	private LabelBase PrinttoScreenDesc = null;
	private CheckBoxBase PrinttoScreen = null;
	private LabelBase OOSFilterDesc	= null;
	private ComboOOSFilter OOSFilter = null;

	private DlgDayEndReport dlgDayEndReport = null;

	private BasePanel ButtonPanel = null;
	private ButtonBase ARLetters = null;
	private ButtonBase FGLetters = null;
	private ButtonBase PRLetters = null;

	/**
	 * This method initializes
	 *
	 */
	public DayEndReport() {
		super();
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	protected void initAfterReady() {
		getALICDesc().setEnabled(false);
		getALIC().setEnabled(false);
		getCSRDesc().setEnabled(false);
		getCSR().setEnabled(false);
		getOLBSADesc().setEnabled(false);
		getOLBSA().setEnabled(false);
		getSTECRDesc().setEnabled(false);
		getSTECR().setEnabled(false);
		getARLetters().setEnabled(false);
		getFGLetters().setEnabled(false);
		getPRLetters().setEnabled(false);
		getOOSFilter().setEnabled(false);

		// specific for particular users
		boolean onlyTCAR = (!isDisableFunction("chkTCAR", "rptDayEnd") && 
				!Factory.getInstance().getUserInfo().getSiteCode().equals(Factory.getInstance().getUserInfo().getUserID()));
		boolean onlyOFR = (!isDisableFunction("chkOFR", "rptDayEnd") && 
				!Factory.getInstance().getUserInfo().getSiteCode().equals(Factory.getInstance().getUserInfo().getUserID()));
		if (onlyTCAR) {
			setCheckBoxPanelEnabled(false);
			getTCARDesc().setEnabled(true);
			getTCAR().setEnabled(true);
		}
		if (onlyOFR) {
			setCheckBoxPanelEnabled(false);
			getOFRDesc().setEnabled(true);
			getOFR().setEnabled(true);
		}
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	public Component getDefaultFocusComponent() {
		return getDateRangeStart();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	protected void confirmCancelButtonClicked() {}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	protected void appendDisabledFields() {}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	protected void modifyDisabledFields() {}

	/* >>> ~13~ Set Disable Fields When Delete ButtonBase Is Clicked ====== <<< */
	protected void deleteDisabledFields() {
		// enable/disable field
	}

	/* >>> ~16~ Set Fetch Input Parameters ================================ <<< */
	protected String[] getFetchInputParameters() {
		return null;
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	protected void getFetchOutputValues(String[] outParam) {}

	/* >>> ~15~ Set Fetch Output Results ============================== <<< */
	protected void getBrowseOutputValues(String[] outParam) {}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	protected String[] getActionInputParamaters() {
		return null;
	}

	/* >>> ~17.1~ Set Action Output Parameters ============================ <<< */
	protected void getNewOutputValue(String returnValue) {}

	/***************************************************************************
	 * Override Methods
	 **************************************************************************/

	@Override
	protected void enableButton(String mode) {
		disableButton();
		getPrintButton().setEnabled(true);
	}

	/***************************************************************************
	 * Dialog Methods
	 **************************************************************************/

	private DlgDayEndReport getDlgDayEndReport() {
		if (dlgDayEndReport == null) {
			dlgDayEndReport = new DlgDayEndReport(getMainFrame()) {
				@Override
				protected void doOkAction() {
					String reportType = getNormalOpt().isSelected() ? YES_VALUE : NO_VALUE;
					memMap.put("ReportType", reportType);
					if ("RptPettyCash".equals(memReportName)) {
						if (memIsPrintToScreen) {
							Report.print(Factory.getInstance().getUserInfo(), "RptPettyCash", memMap,
									new String[] {
											memStartDate, memEndDate, memSteCode, reportType
									},
									new String[] {
											"CTXTYPE", "USRID", "CTXMETH",
											"CTNCTYPE", "CTXSNO", "CTXNAME",
											"CTXAMT", "CTXDESC", "CTXCDATE",
											"STENAME", "ARCCODE"
									});
						} else if (memIsPrintToFile) {
							PrintingUtil.print("DEFAULT", "RptPettyCash", memMap, "",
									new String[] {
											memStartDate, memEndDate, memSteCode, reportType
									},
									new String[] {
											"CTXTYPE", "USRID", "CTXMETH",
											"CTNCTYPE", "CTXSNO", "CTXNAME",
											"CTXAMT", "CTXDESC", "CTXCDATE",
											"STENAME", "ARCCODE"
									},
									0, null, null, null, null, 1,
									false, true, new String[] { "xls" }, true);
						} else {
							PrintingUtil.print("DEFAULT", "RptPettyCash", memMap, "",
									new String[] {
											memStartDate, memEndDate, memSteCode, reportType
									},
									new String[] {
											"CTXTYPE", "USRID", "CTXMETH",
											"CTNCTYPE", "CTXSNO", "CTXNAME",
											"CTXAMT", "CTXDESC", "CTXCDATE",
											"STENAME", "ARCCODE"
									});
						}
					} else if ("RptCshrAuditSmy".equals(memReportName)) {
						if (memIsPrintToScreen) {
							Report.print(Factory.getInstance().getUserInfo(), "RptCshrAuditSmy",
									memMap,
									new String[] {
											memStartDate, memEndDate, memSteCode, reportType
									},
									new String[] {
											"CTXCDATE", "USRID", "CTXMETH",
											"CTXTYPE", "CTNCTYPE", "CTXAMT",
											"STENAME"
									},
									new boolean[] {
											false, false, false,
											false, false, false,
											false
									},
									new String[] {
											"RptCshrAuditSmy1"
									},
									new String[][] {
											{
												memStartDate, memEndDate, memSteCode, reportType
											}
									},
									new String[][] {
											{
												"CTXCDATE", "USRID", "CTXMETH",
												"CTXTYPE", "CTNCTYPE", "CTXAMT",
												"STENAME"
											}
									},
									new boolean[][] {
											{
												false, false, false,
												false, false, false,
												false
											}
									}, null);
						} else if (memIsPrintToFile) {
							PrintingUtil.print("DEFAULT", "RptCshrAuditSmy", memMap, "",
									new String[] {
											memStartDate, memEndDate, memSteCode, reportType
									},
									new String[] {
											"CTXCDATE", "USRID", "CTXMETH",
											"CTXTYPE", "CTNCTYPE", "CTXAMT",
											"STENAME"
									},
									1,
									new String[] {
											"RptCshrAuditSmy1"
									},
									new String[][] {
											{
												memStartDate, memEndDate, memSteCode, reportType
											}
									},
									new String[][] {
											{
												"CTXCDATE", "USRID", "CTXMETH",
												"CTXTYPE", "CTNCTYPE", "CTXAMT",
												"STENAME"
											}
									},
									new boolean[][] {
														{
															false, false, false,
															false, false, false,
															false
														}
									}, 1, false, true, new String[] { "xls" }, true);
						} else {
							PrintingUtil.print("DEFAULT", "RptCshrAuditSmy", memMap, "",
									new String[] {
											memStartDate, memEndDate, memSteCode, reportType
									},
									new String[] {
											"CTXCDATE", "USRID", "CTXMETH",
											"CTXTYPE", "CTNCTYPE", "CTXAMT",
											"STENAME"
									},
									1,
									new String[] {
											"RptCshrAuditSmy1"
									},
									new String[][] {
											{
												memStartDate, memEndDate, memSteCode, reportType
											}
									},
									new String[][] {
											{
												"CTXCDATE", "USRID", "CTXMETH",
												"CTXTYPE", "CTNCTYPE", "CTXAMT",
												"STENAME"
											}
									},
									new boolean[][] {
											{
												false, false, false,
												false, false, false,
												false
											}
									});
						}
					} else if ("RptReceipt".equals(memReportName)) {
						if (memIsPrintToScreen) {
							Report.print(Factory.getInstance().getUserInfo(), "RptReceipt",
									memMap,
									new String[] {
											memStartDate, memEndDate, memSteCode, reportType
									},
									new String[] {
											"USRID","CTXSNO","CTXNAME",
											"CTXAMT","CTXDESC","CTXCDATE","CTXMETH","STENAME",
											"CTNCTYPE","REGTYPE"}
									);
						} else if (memIsPrintToFile) {
							PrintingUtil.print("DEFAULT","RptReceipt",memMap,"",
									new String[] {
											memStartDate, memEndDate, memSteCode, reportType
									},
									new String[] {
											"USRID","CTXSNO","CTXNAME",
											"CTXAMT","CTXDESC","CTXCDATE","CTXMETH","STENAME",
											"CTNCTYPE","REGTYPE"
									},
									0, null, null, null, null, 1,
									false, true, new String[] { "xls" }, true);
						} else {
							PrintingUtil.print("DEFAULT", "RptReceipt", memMap,"",
									new String[] {
											 memStartDate, memEndDate, memSteCode, reportType
									},
									new String[] {
											"USRID","CTXSNO","CTXNAME",
											"CTXAMT","CTXDESC","CTXCDATE","CTXMETH","STENAME",
											"CTNCTYPE","REGTYPE"
									});
						}
					}

					setVisible(false);
				}
			};
		}
		return dlgDayEndReport;
	}

	/***************************************************************************
	 * ButtonBase Action Methods
	 **************************************************************************/

	protected BasePanel getActionPanel() {
		if (actionPanel == null) {
			actionPanel = new BasePanel();
			actionPanel.setLayout(new AbsoluteLayout());
			actionPanel.setBounds(5, 0, 779, 550);
			actionPanel.add(getCheckBoxPanel(), null);
			actionPanel.add(getTextPanel(), null);
			actionPanel.add(getButtonPanel(), null);
		}
		return actionPanel;
	}

	public BasePanel getCheckBoxPanel() {
		if (CheckBoxPanel == null) {
			CheckBoxPanel = new BasePanel();
			CheckBoxPanel.setLayout(new AbsoluteLayout());
			CheckBoxPanel.setBorders(true);
			CheckBoxPanel.add(getALICDesc(), null);
			CheckBoxPanel.add(getALIC(), null);
			CheckBoxPanel.add(getCTTLDesc(), null);
			CheckBoxPanel.add(getCTTL(), null);
			CheckBoxPanel.add(getCMPCRDesc(), null);
			CheckBoxPanel.add(getCMPCR(), null);
			CheckBoxPanel.add(getCASDesc(), null);
			CheckBoxPanel.add(getCAS(), null);
			CheckBoxPanel.add(getCSRDesc(), null);
			CheckBoxPanel.add(getCSR(), null);
			CheckBoxPanel.add(getDISDesc(), null);
			CheckBoxPanel.add(getDIS(), null);
			CheckBoxPanel.add(getDSLDesc(), null);
			CheckBoxPanel.add(getDSL(), null);
			CheckBoxPanel.add(getNADesc(), null);
			CheckBoxPanel.add(getNA(), null);
			CheckBoxPanel.add(getOLBSADesc(), null);
			CheckBoxPanel.add(getOLBSA(), null);
			CheckBoxPanel.add(getOBRDesc(), null);
			CheckBoxPanel.add(getOBR(), null);
			CheckBoxPanel.add(getODCSDesc(), null);
			CheckBoxPanel.add(getODCS(), null);
			CheckBoxPanel.add(getODRDesc(), null);
			CheckBoxPanel.add(getODR(), null);
			CheckBoxPanel.add(getOISDesc(), null);
			CheckBoxPanel.add(getOIS(), null);
			CheckBoxPanel.add(getOOSDesc(), null);
			CheckBoxPanel.add(getOOS(), null);
			CheckBoxPanel.add(getOFRDesc(), null);
			CheckBoxPanel.add(getOFR(), null);
			CheckBoxPanel.add(getReceiptDesc(), null);
			CheckBoxPanel.add(getReceipt(), null);
			CheckBoxPanel.add(getRLDesc(), null);
			CheckBoxPanel.add(getRL(), null);
			CheckBoxPanel.add(getRCLDesc(), null);
			CheckBoxPanel.add(getRCL(), null);
			CheckBoxPanel.add(getSTECRDesc(), null);
			CheckBoxPanel.add(getSTECR(), null);
			CheckBoxPanel.add(getTLDesc(), null);
			CheckBoxPanel.add(getTL(), null);
			CheckBoxPanel.add(getTTIDesc(), null);
			CheckBoxPanel.add(getTTI(), null);
			CheckBoxPanel.add(getTCARDesc(), null);
			CheckBoxPanel.add(getTCAR(), null);
			CheckBoxPanel.add(getWeekBillDesc(), null);
			CheckBoxPanel.add(getWeekBill(), null);
			CheckBoxPanel.add(getCoverLetterDesc(), null);
			CheckBoxPanel.add(getCoverLetter(), null);
			CheckBoxPanel.add(getIPStatmentWBDesc(), null);
			CheckBoxPanel.add(getIPStatmentWB(), null);

			CheckBoxPanel.setBounds(5, 10, 769, 254);
		}
		return CheckBoxPanel;
	}
	
	protected void setCheckBoxPanelEnabled(boolean enable) {
		getALICDesc().setEnabled(enable);
		getALIC().setEnabled(enable);
		getCTTLDesc().setEnabled(enable);
		getCTTL().setEnabled(enable);
		getCMPCRDesc().setEnabled(enable);
		getCMPCR().setEnabled(enable);
		getCASDesc().setEnabled(enable);
		getCAS().setEnabled(enable);
		getCSRDesc().setEnabled(enable);
		getCSR().setEnabled(enable);
		getDISDesc().setEnabled(enable);
		getDIS().setEnabled(enable);
		getDSLDesc().setEnabled(enable);
		getDSL().setEnabled(enable);
		getNADesc().setEnabled(enable);
		getNA().setEnabled(enable);
		getOLBSADesc().setEnabled(enable);
		getOLBSA().setEnabled(enable);
		getOBRDesc().setEnabled(enable);
		getOBR().setEnabled(enable);
		getODCSDesc().setEnabled(enable);
		getODCS().setEnabled(enable);
		getODRDesc().setEnabled(enable);
		getODR().setEnabled(enable);
		getOISDesc().setEnabled(enable);
		getOIS().setEnabled(enable);
		getOOSDesc().setEnabled(enable);
		getOOS().setEnabled(enable);
		getOFRDesc().setEnabled(enable);
		getOFR().setEnabled(enable);
		getReceiptDesc().setEnabled(enable);
		getReceipt().setEnabled(enable);
		getRLDesc().setEnabled(enable);
		getRL().setEnabled(enable);
		getRCLDesc().setEnabled(enable);
		getRCL().setEnabled(enable);
		getSTECRDesc().setEnabled(enable);
		getSTECR().setEnabled(enable);
		getTLDesc().setEnabled(enable);
		getTL().setEnabled(enable);
		getTTIDesc().setEnabled(enable);
		getTTI().setEnabled(enable);
		getTCARDesc().setEnabled(enable);
		getTCAR().setEnabled(enable);
		getWeekBillDesc().setEnabled(enable);
		getWeekBill().setEnabled(enable);
		getCoverLetterDesc().setEnabled(enable);
		getCoverLetter().setEnabled(enable);
		getIPStatmentWBDesc().setEnabled(enable);
		getIPStatmentWB().setEnabled(enable);
	}

	public LabelBase getALICDesc() {
		if (ALICDesc == null) {
			ALICDesc = new LabelBase();
			ALICDesc.setText("Admission List for Insurance Company");
			ALICDesc.setBounds(34, 10, 224, 20);
		}
		return ALICDesc;
	}

	public CheckBoxBase getALIC() {
		if (ALIC == null) {
			ALIC = new CheckBoxBase();
			ALIC.setBounds(10, 10, 20, 20);
		}
		return ALIC;
	}

	public LabelBase getCTTLDesc() {
		if (CTTLDesc == null) {
			CTTLDesc = new LabelBase();
			CTTLDesc.setText("Cancelled/Transferred Transactions Listing");
			CTTLDesc.setBounds(34, 40, 240, 20);
		}
		return CTTLDesc;
	}

	public CheckBoxBase getCTTL() {
		if (CTTL == null) {
			CTTL = new CheckBoxBase();
			CTTL.setBounds(10, 40, 20, 20);
		}
		return CTTL;
	}

	public LabelBase getCMPCRDesc() {
		if (CMPCRDesc == null) {
			CMPCRDesc = new LabelBase();
			CMPCRDesc.setText("Cash Management/Petty Cash Report");
			CMPCRDesc.setBounds(34, 70, 224, 20);
		}
		return CMPCRDesc;
	}

	public CheckBoxBase getCMPCR() {
		if (CMPCR == null) {
			CMPCR = new CheckBoxBase();
			CMPCR.setBounds(10, 70, 20, 20);
		}
		return CMPCR;
	}

	public LabelBase getCASDesc() {
		if (CASDesc == null) {
			CASDesc = new LabelBase();
			CASDesc.setText("Cashier Audit Summary");
			CASDesc.setBounds(34, 100, 224, 20);
		}
		return CASDesc;
	}

	public CheckBoxBase getCAS() {
		if (CAS == null) {
			CAS = new CheckBoxBase();
			CAS.setBounds(10, 100, 20, 20);
		}
		return CAS;
	}
	public LabelBase getCSRDesc() {
		if (CSRDesc == null) {
			CSRDesc = new LabelBase();
			CSRDesc.setText("Contract Switching Report");
			CSRDesc.setBounds(34, 130, 224, 20);
		}
		return CSRDesc;
	}

	public CheckBoxBase getCSR() {
		if (CSR == null) {
			CSR = new CheckBoxBase();
			CSR.setBounds(10, 130, 20, 20);
		}
		return CSR;
	}

	public LabelBase getDISDesc() {
		if (DISDesc == null) {
			DISDesc = new LabelBase();
			DISDesc.setText("Daily Income Summary");
			DISDesc.setBounds(34, 160, 224, 20);
		}
		return DISDesc;
	}

	public CheckBoxBase getDIS() {
		if (DIS == null) {
			DIS = new CheckBoxBase();
			DIS.setBounds(10, 160, 20, 20);
		}
		return DIS;
	}

	public LabelBase getDSLDesc() {
		if (DSLDesc == null) {
			DSLDesc = new LabelBase();
			DSLDesc.setText("Deposit Settlement List");
			DSLDesc.setBounds(34, 190, 224, 20);
		}
		return DSLDesc;
	}

	public CheckBoxBase getDSL() {
		if (DSL == null) {
			DSL = new CheckBoxBase();
			DSL.setBounds(10, 190, 20, 20);
		}
		return DSL;
	}

	public LabelBase getNADesc() {
		if (NADesc == null) {
			NADesc = new LabelBase();
			NADesc.setText("Note to the Account");
			NADesc.setBounds(34, 220, 224, 20);
		}
		return NADesc;
	}

	public CheckBoxBase getNA() {
		if (NA == null) {
			NA = new CheckBoxBase();
			NA.setBounds(10, 220, 20, 20);
		}
		return NA;
	}

	public LabelBase getOLBSADesc() {
		if (OLBSADesc == null) {
			OLBSADesc = new LabelBase();
			OLBSADesc.setText("OT Log Book Slip Amendment");
			OLBSADesc.setBounds(294, 10, 232, 20);
		}
		return OLBSADesc;
	}

	public CheckBoxBase getOLBSA() {
		if (OLBSA == null) {
			OLBSA = new CheckBoxBase();
			OLBSA.setBounds(271, 10, 23, 20);
		}
		return OLBSA;
	}

	public LabelBase getOBRDesc() {
		if (OBRDesc == null) {
			OBRDesc = new LabelBase();
			OBRDesc.setText("Outstanding Balance Report");
			OBRDesc.setBounds(294, 40, 232, 20);
		}
		return OBRDesc;
	}

	public CheckBoxBase getOBR() {
		if (OBR == null) {
			OBR = new CheckBoxBase();
			OBR.setBounds(271, 40, 23, 20);
		}
		return OBR;
	}

	public LabelBase getODCSDesc() {
		if (ODCSDesc == null) {
			ODCSDesc = new LabelBase();
			ODCSDesc.setText("Outstanding Day Case Slip");
			ODCSDesc.setBounds(294, 71, 232, 20);
		}
		return ODCSDesc;
	}

	public CheckBoxBase getODCS() {
		if (ODCS == null) {
			ODCS = new CheckBoxBase();
			ODCS.setBounds(271, 71, 20, 20);
		}
		return ODCS;
	}

	public LabelBase getODRDesc() {
		if (ODRDesc == null) {
			ODRDesc = new LabelBase();
			ODRDesc.setText("Outstanding Deposit Report");
			ODRDesc.setBounds(294, 101, 232, 20);
		}
		return ODRDesc;
	}

	public CheckBoxBase getODR() {
		if (ODR == null) {
			ODR = new CheckBoxBase();
			ODR.setBounds(271, 101, 20, 20);
		}
		return ODR;
	}

	public LabelBase getOISDesc() {
		if (OISDesc == null) {
			OISDesc = new LabelBase();
			OISDesc.setText("Outstanding IP Slip");
			OISDesc.setBounds(294, 131, 232, 20);
		}
		return OISDesc;
	}

	public CheckBoxBase getOIS() {
		if (OIS == null) {
			OIS = new CheckBoxBase();
			OIS.setBounds(271, 131, 20, 20);
		}
		return OIS;
	}

	public LabelBase getOOSDesc() {
		if (OOSDesc == null) {
			OOSDesc = new LabelBase();
			OOSDesc.setText("Outstanding OP Slip");
			OOSDesc.setBounds(294, 161, 232, 20);
		}
		return OOSDesc;
	}

	public CheckBoxBase getOOS() {
		if (OOS == null) {
			OOS = new CheckBoxBase() {
				public void onClick() {
					boolean onlyDENT = !isDisableFunction("chkDENT", "rptDayEnd");
					if (!onlyDENT) {
						if (getOOSFilter().isEnabled()) {
							getOOSFilter().setEnabled(false);
						} else {
							getOOSFilter().setEnabled(true);
						}
					}
				}
			};
			OOS.setBounds(271, 161, 20, 20);
		}
		return OOS;
	}

	public LabelBase getOFRDesc() {
		if (OFRDesc == null) {
			OFRDesc = new LabelBase();
			OFRDesc.setText("Override Fee Report");
			OFRDesc.setBounds(294, 191, 232, 20);
		}
		return OFRDesc;
	}

	public CheckBoxBase getOFR() {
		if (OFR == null) {
			OFR = new CheckBoxBase();
			OFR.setBounds(271, 191, 20, 20);
		}
		return OFR;
	}

	public LabelBase getReceiptDesc() {
		if (ReceiptDesc == null) {
			ReceiptDesc = new LabelBase();
			ReceiptDesc.setText("Receipt");
			ReceiptDesc.setBounds(294, 221, 232, 20);
		}
		return ReceiptDesc;
	}

	public CheckBoxBase getReceipt() {
		if (Receipt == null) {
			Receipt = new CheckBoxBase();
			Receipt.setBounds(271, 221, 20, 20);
		}
		return Receipt;
	}

	public LabelBase getRLDesc() {
		if (RLDesc == null) {
			RLDesc = new LabelBase();
			RLDesc.setText("Refund List");
			RLDesc.setBounds(559, 10, 197, 20);
		}
		return RLDesc;
	}

	public CheckBoxBase getRL() {
		if (RL == null) {
			RL = new CheckBoxBase();
			RL.setBounds(537, 10, 20, 20);
		}
		return RL;
	}

	public LabelBase getRCLDesc() {
		if (RCLDesc == null) {
			RCLDesc = new LabelBase();
			RCLDesc.setText("Reject Cheque List");
			RCLDesc.setBounds(559, 40, 197, 20);
		}
		return RCLDesc;
	}

	public CheckBoxBase getRCL() {
		if (RCL == null) {
			RCL = new CheckBoxBase();
			RCL.setBounds(537, 40, 20, 20);
		}
		return RCL;
	}

	public LabelBase getSTECRDesc() {
		if (STECRDesc == null) {
			STECRDesc = new LabelBase();
			STECRDesc.setText("Soon To Expiry Contract Report");
			STECRDesc.setBounds(559, 71, 197, 20);
		}
		return STECRDesc;
	}

	public CheckBoxBase getSTECR() {
		if (STECR == null) {
			STECR = new CheckBoxBase();
			STECR.setBounds(537, 71, 20, 20);
		}
		return STECR;
	}

	public LabelBase getTLDesc() {
		if (TLDesc == null) {
			TLDesc = new LabelBase();
			TLDesc.setText("Transaction Listing");
			TLDesc.setBounds(559, 101, 197, 20);
		}
		return TLDesc;
	}

	public CheckBoxBase getTL() {
		if (TL == null) {
			TL = new CheckBoxBase();
			TL.setBounds(537, 101, 20, 20);
		}
		return TL;
	}

	public LabelBase getTTIDesc() {
		if (TTIDesc == null) {
			TTIDesc = new LabelBase();
			TTIDesc.setText("Transaction Total by Item");
			TTIDesc.setBounds(559, 131, 197, 20);
		}
		return TTIDesc;
	}

	public CheckBoxBase getTTI() {
		if (TTI == null) {
			TTI = new CheckBoxBase();
			TTI.setBounds(537, 131, 20, 20);
		}
		return TTI;
	}

	public LabelBase getTCARDesc() {
		if (TCARDesc == null) {
			TCARDesc = new LabelBase();
			TCARDesc.setText("Transfer to Company AR");
			TCARDesc.setBounds(559, 161, 197, 20);
		}
		return TCARDesc;
	}

	public CheckBoxBase getTCAR() {
		if (TCAR == null) {
			TCAR = new CheckBoxBase();
			TCAR.setBounds(537, 161, 20, 20);
		}
		return TCAR;
	}

	public LabelBase getWeekBillDesc() {
		if (WBillDesc == null) {
			WBillDesc = new LabelBase();
			WBillDesc.setText("Weekly Bill");
			WBillDesc.setBounds(559, 191, 197, 20);
		}
		return WBillDesc;
	}

	public CheckBoxBase getWeekBill() {
		if (WBill == null) {
			WBill = new CheckBoxBase();
			WBill.setBounds(537, 191, 20, 20);
		}
		return WBill;
	}

	public LabelBase getCoverLetterDesc() {
		if (CovLetterDesc == null) {
			CovLetterDesc = new LabelBase();
			CovLetterDesc.setText("Cover Letter");
			CovLetterDesc.setBounds(559, 221, 197, 20);
		}
		return CovLetterDesc;
	}

	public CheckBoxBase getCoverLetter() {
		if (CovLetter == null) {
			CovLetter = new CheckBoxBase();
			CovLetter.setBounds(537, 221, 20, 20);
		}
		return CovLetter;
	}

	public LabelBase getIPStatmentWBDesc() {
		if (IPStatmentWBDesc == null) {
			IPStatmentWBDesc = new LabelBase();
			IPStatmentWBDesc.setText("IP STM (WB)");
			IPStatmentWBDesc.setBounds(660, 221, 197, 15);
		}
		return IPStatmentWBDesc;
	}

	public CheckBoxBase getIPStatmentWB() {
		if (IPStatmentWB == null) {
			IPStatmentWB = new CheckBoxBase();
			IPStatmentWB.setBounds(635, 221, 20, 20);
		}
		return IPStatmentWB;
	}

	public BasePanel getTextPanel() {
		if (TextPanel == null) {
			TextPanel = new BasePanel();
			TextPanel.setLayout(new AbsoluteLayout());
			TextPanel.setBorders(true);
			TextPanel.add(getDateRangeStartDesc(), null);
			TextPanel.add(getDateRangeStart(), null);
			TextPanel.add(getDateRangeEndDesc(), null);
			TextPanel.add(getDateRangeEnd(), null);
			TextPanel.add(getSiteCodeDesc(), null);
			TextPanel.add(getSiteCode(), null);
			TextPanel.add(getCashIDDesc(), null);
			TextPanel.add(getCashID(), null);
			TextPanel.add(getDoctorCodeDesc(), null);
			TextPanel.add(getDoctorCode(), null);
			TextPanel.add(getPatientCodeDesc(), null);
			TextPanel.add(getPatientCode(), null);
			TextPanel.add(getItemCodeDesc(), null);
			TextPanel.add(getItemCode(), null);
			TextPanel.add(getPackageCodeDesc(), null);
			TextPanel.add(getPackageCode(), null);
			TextPanel.add(getPercentDesc(), null);
			TextPanel.add(getPercent(), null);
			TextPanel.add(getOOSFilterDesc(), null);
			TextPanel.add(getOOSFilter(), null);
			TextPanel.add(getARCCodeDesc(), null);
			TextPanel.add(getARCCode(), null);
			TextPanel.add(getGenDateDesc(), null);
			TextPanel.add(getGenDate(), null);
			TextPanel.add(getPrinttoFileDesc(), null);
			TextPanel.add(getPrinttoFile(), null);
			TextPanel.add(getPrinttoScreenDesc(), null);
			TextPanel.add(getPrinttoScreen(), null);
			TextPanel.setBounds(5, 270, 769, 170);
		}
		return TextPanel;
	}

	public LabelBase getDateRangeStartDesc() {
		if (DateRangeStartDesc == null) {
			DateRangeStartDesc = new LabelBase();
			DateRangeStartDesc.setText("<html>Date range start<br>(dd/mm/yyyy)</html>");
			DateRangeStartDesc.setBounds(10, 40, 103, 30);
		}
		return DateRangeStartDesc;
	}

	public TextDate getDateRangeStart() {
		if (DateRangeStart == null) {
			DateRangeStart = new TextDate() {
				@Override
				public void onBlur() {
					if (!isEmpty() && !isValid()) {
						Factory.getInstance().addErrorMessage("Invalid date.", DateRangeStart);
						resetText();
						return;
					}
				};
			};
			DateRangeStart.setBounds(112, 50, 125, 20);
		}
		return DateRangeStart;
	}

	public LabelBase getDateRangeEndDesc() {
		if (DateRangeEndDesc == null) {
			DateRangeEndDesc = new LabelBase();
			DateRangeEndDesc.setText("<html>Date range end<br>(dd/mm/yyyy)</html>");
			DateRangeEndDesc.setBounds(257, 40, 103, 30);
		}
		return DateRangeEndDesc;
	}

	public TextDate getDateRangeEnd() {
		if (DateRangeEnd == null) {
			DateRangeEnd = new TextDate() {
				@Override
				public void onBlur() {
					if (!isEmpty() && !isValid()) {
						Factory.getInstance().addErrorMessage("Invalid date.", DateRangeEnd);
						resetText();
						return;
					}
				};
			};
			DateRangeEnd.setBounds(369, 50, 125, 20);
		}
		return DateRangeEnd;
	}

	public LabelBase getSiteCodeDesc() {
		if (SiteCodeDesc == null) {
			SiteCodeDesc = new LabelBase();
			SiteCodeDesc.setText("Site Code");
			SiteCodeDesc.setBounds(519, 50, 103, 20);
		}
		return SiteCodeDesc;
	}

	public ComboSiteType getSiteCode() {
		if (SiteCode == null) {
			SiteCode = new ComboSiteType();
			SiteCode.setBounds(621, 50, 125, 20);
		}
		return SiteCode;
	}

	public LabelBase getCashIDDesc() {
		if (CashIDDesc == null) {
			CashIDDesc = new LabelBase();
			CashIDDesc.setText("Cashier ID");
			CashIDDesc.setBounds(10, 80, 103, 20);
		}
		return CashIDDesc;
	}

	public TextString getCashID() {
		if (CashID == null) {
			CashID = new TextString();
			CashID.setBounds(112, 80, 125, 20);
		}
		return CashID;
	}

	public LabelBase getDoctorCodeDesc() {
		if (DoctorCodeDesc == null) {
			DoctorCodeDesc = new LabelBase();
			DoctorCodeDesc.setText("Doctor Code");
			DoctorCodeDesc.setBounds(257, 80, 103, 20);
		}
		return DoctorCodeDesc;
	}

	public TextDoctorSearch getDoctorCode() {
		if (DoctorCode == null) {
			DoctorCode = new TextDoctorSearch();
			DoctorCode.setBounds(369, 80, 125, 20);
		}
		return DoctorCode;
	}

	public LabelBase getPatientCodeDesc() {
		if (PatientCodeDesc == null) {
			PatientCodeDesc = new LabelBase();
			PatientCodeDesc.setText("Patient Code");
			PatientCodeDesc.setBounds(519, 80, 103, 20);
		}
		return PatientCodeDesc;
	}

	public TextString getPatientCode() {
		if (PatientCode == null) {
			PatientCode = new TextString();
			PatientCode.setBounds(621, 80, 125, 20);
		}
		return PatientCode;
	}

	public LabelBase getItemCodeDesc() {
		if (ItemCodeDesc == null) {
			ItemCodeDesc = new LabelBase();
			ItemCodeDesc.setText("Item Code");
			ItemCodeDesc.setBounds(10, 110, 103, 20);
		}
		return ItemCodeDesc;
	}

	public TextItemCodeSearch getItemCode() {
		if (ItemCode == null) {
			ItemCode = new TextItemCodeSearch();
			ItemCode.setBounds(112, 110, 125, 20);
		}
		return ItemCode;
	}

	public LabelBase getPackageCodeDesc() {
		if (PackageCodeDesc == null) {
			PackageCodeDesc = new LabelBase();
			PackageCodeDesc.setText("Package Code");
			PackageCodeDesc.setBounds(257, 110, 103, 20);
		}
		return PackageCodeDesc;
	}

	public TextPackageCodeSearch getPackageCode() {
		if (PackageCode == null) {
			PackageCode = new TextPackageCodeSearch();
			PackageCode.setBounds(369, 110, 125, 20);
		}
		return PackageCode;
	}

	public LabelBase getPercentDesc() {
		if (PercentDesc == null) {
			PercentDesc = new LabelBase();
			PercentDesc.setText("Percentage");
			PercentDesc.setBounds(519, 110, 103, 20);
		}
		return PercentDesc;
	}

	public TextString getPercent() {
		if (Percent == null) {
			Percent = new TextString();
			Percent.setBounds(621, 110, 125, 20);
		}
		return Percent;
	}

	public LabelBase getOOSFilterDesc() {
		if (OOSFilterDesc == null) {
			OOSFilterDesc = new LabelBase();
			OOSFilterDesc.setText("OP Slip Filter");
			OOSFilterDesc.setBounds(10, 140, 103, 20);
		}
		return OOSFilterDesc;
	}

	public ComboOOSFilter getOOSFilter() {
		if (OOSFilter == null) {
			OOSFilter = new ComboOOSFilter();
			OOSFilter.setBounds(112, 140, 125, 20);
		}
		return OOSFilter;
	}

	public LabelBase getARCCodeDesc() {
		if (ARCCodeDesc == null) {
			ARCCodeDesc = new LabelBase();
			ARCCodeDesc.setText("AR Company Code");
			ARCCodeDesc.setBounds(257, 140, 113, 20);
		}
		return ARCCodeDesc;
	}

	public TextString getARCCode() {
		if (ARCCode == null) {
			ARCCode = new TextString();
			ARCCode.setBounds(369, 140, 125, 20);
		}
		return ARCCode;
	}

	public LabelBase getGenDateDesc() {
		if (GenDateDesc == null) {
			GenDateDesc = new LabelBase();
			GenDateDesc.setText("Generation Date");
			GenDateDesc.setBounds(519, 140, 103, 20);
		}
		return GenDateDesc;
	}

	public TextDate getGenDate() {
		if (GenDate == null) {
			GenDate = new TextDate() {
				@Override
				public void onBlur() {
					if (!isEmpty() && !isValid()) {
						Factory.getInstance().addErrorMessage("Invalid date.", GenDate);
						resetText();
						return;
					}
				};
			};
			GenDate.setBounds(621, 140, 125, 20);
		}
		return GenDate;
	}

	public LabelBase getPrinttoFileDesc() {
		if (PrinttoFileDesc == null) {
			PrinttoFileDesc = new LabelBase();
			PrinttoFileDesc.setText("Print To File");
			PrinttoFileDesc.setBounds(560, 11, 77, 20);
		}
		return PrinttoFileDesc;
	}

	public CheckBoxBase getPrinttoFile() {
		if (PrinttoFile == null) {
			PrinttoFile = new CheckBoxBase() {
				@Override
				public void onClick() {
					if (getPrinttoFile().isSelected()) {
						getPrinttoScreen().setSelected(false);
					}
				}
			};
			PrinttoFile.setBounds(540, 11, 20, 20);
		}
		return PrinttoFile;
	}

	public LabelBase getPrinttoScreenDesc() {
		if (PrinttoScreenDesc == null) {
			PrinttoScreenDesc = new LabelBase();
			PrinttoScreenDesc.setText("Print To Screen");
			PrinttoScreenDesc.setBounds(660, 11, 95, 20);
		}
		return PrinttoScreenDesc;
	}

	public CheckBoxBase getPrinttoScreen() {
		if (PrinttoScreen == null) {
			PrinttoScreen = new CheckBoxBase() {
				@Override
				public void onClick() {
					if (getPrinttoScreen().isSelected()) {
						getPrinttoFile().setSelected(false);
					}
				}
			};
			PrinttoScreen.setBounds(635, 11, 20, 20);
		}
		return PrinttoScreen;
	}

	@Override
	public void rePostAction() {
	}

	private boolean validatePrintAction() {
		if (!getDateRangeStart().isEmpty() && !getDateRangeStart().isValid()) {
			Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_ERR_INVALIDDATE+"Start Date.", getDateRangeStart());
			return false;
		}
		if (!getDateRangeEnd().isEmpty() && !getDateRangeEnd().isValid()) {
			Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_ERR_INVALIDDATE+"End Date.", getDateRangeEnd());
			return false;
		}

		boolean error = false;
		StringBuffer sb = new StringBuffer();

		// Cancelled/Transferred Transactions Listing
		if (getCTTL().isSelected()) {
			if (error) {
				sb.append("<br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 ||
					!getSiteCode().isValid() ||
					getDateRangeStart().isEmpty() ||
					getDateRangeEnd().isEmpty()) {
				error = true;
				sb.append("Fail to print: Cancelled/Transferred Transactions (rptCancelTxLst)<br/><br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 || !getSiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
			if (getDateRangeStart().isEmpty()) {
				sb.append("Please supply Start Date.<br/>");
			}
			if (getDateRangeEnd().isEmpty()) {
				sb.append("Please supply End Date.<br/>");
			}
		}

		// Cash Management/Petty Cash Report
		if (getCMPCR().isSelected()) {
			if (error) {
				sb.append("<br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 ||
					!getSiteCode().isValid() ||
					getDateRangeStart().isEmpty() ||
					getDateRangeEnd().isEmpty()) {
				error = true;
				sb.append("Fail to print: Cash Management/Petty Cash Report (rptPettyCash)<br/><br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 || !getSiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
			if (getDateRangeStart().isEmpty()) {
				sb.append("Please supply Start Date.<br/>");
			}
			if (getDateRangeEnd().isEmpty()) {
				sb.append("Please supply End Date.<br/>");
			}
		}

		// Cashier Audit Summary
		if (getCAS().isSelected()) {
			if (error) {
				sb.append("<br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 ||
					!getSiteCode().isValid() ||
					getDateRangeStart().isEmpty() ||
					getDateRangeEnd().isEmpty()) {
				error = true;
				sb.append("Fail to print: Cashier Audit Summary (rptCshrAuditSmy)<br/><br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 || !getSiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
			if (getDateRangeStart().isEmpty()) {
				sb.append("Please supply Start Date.<br/>");
			}
			if (getDateRangeEnd().isEmpty()) {
				sb.append("Please supply End Date.<br/>");
			}
		}

		// Daily Income Summary
		if (getDIS().isSelected()) {
			if (error) {
				sb.append("<br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 ||
					!getSiteCode().isValid() ||
					getDateRangeStart().isEmpty() ||
					getDateRangeEnd().isEmpty()) {
				error = true;
				sb.append("Fail to print: Daily Income Summary (rptDailyInc)<br/><br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 || !getSiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
			if (getDateRangeStart().isEmpty()) {
				sb.append("Please supply Start Date.<br/>");
			}
			if (getDateRangeEnd().isEmpty()) {
				sb.append("Please supply End Date.<br/>");
			}
		}

		// Deposit Settlement List
		if (getDSL().isSelected()) {
			if (error) {
				sb.append("<br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 ||
					!getSiteCode().isValid() ||
					getDateRangeStart().isEmpty() ||
					getDateRangeEnd().isEmpty()) {
				error = true;
				sb.append("Fail to print: Deposit Settlement List (rptDepSettle)<br/><br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 || !getSiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
			if (getDateRangeStart().isEmpty()) {
				sb.append("Please supply Start Date.<br/>");
			}
			if (getDateRangeEnd().isEmpty()) {
				sb.append("Please supply End Date.<br/>");
			}
		}

		// Contract Switching Report
		if (getCSR().isSelected()) {
			if (error) {
				sb.append("<br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 ||
					!getSiteCode().isValid() ||
					getDateRangeStart().isEmpty() ||
					getDateRangeEnd().isEmpty()) {
				error = true;
				sb.append("Fail to print: Contract Switching Report (rptContSwitch)<br/><br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 || !getSiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
			if (getDateRangeStart().isEmpty()) {
				sb.append("Please supply Start Date.<br/>");
			}
			if (getDateRangeEnd().isEmpty()) {
				sb.append("Please supply End Date.<br/>");
			}
		}

		if (getRL().isSelected()) {
			if (error) {
				sb.append("<br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 ||
					!getSiteCode().isValid() ||
					getDateRangeStart().isEmpty() ||
					getDateRangeEnd().isEmpty()) {
				error = true;
				sb.append("Fail to print: Refund List (rptRefList)<br/><br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 || !getSiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
			if (getDateRangeStart().isEmpty()) {
				sb.append("Please supply Start Date.<br/>");
			}
			if (getDateRangeEnd().isEmpty()) {
				sb.append("Please supply End Date.<br/>");
			}
		}

		// Note to the Account
		if (getNA().isSelected()) {
			if (error) {
				sb.append("<br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 ||
					!getSiteCode().isValid() ||
					getDateRangeStart().isEmpty() ||
					getDateRangeEnd().isEmpty()) {
				error = true;
				sb.append("Fail to print: Note to the Account (rptNoteToAcc)<br/><br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 || !getSiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
			if (getDateRangeStart().isEmpty()) {
				sb.append("Please supply Start Date.<br/>");
			}
			if (getDateRangeEnd().isEmpty()) {
				sb.append("Please supply End Date.<br/>");
			}
		}

		// Transaction Listing
		if (getTL().isSelected()) {
			if (error) {
				sb.append("<br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 ||
					!getSiteCode().isValid() ||
					getDateRangeStart().isEmpty() ||
					getDateRangeEnd().isEmpty()) {
				error = true;
				sb.append("Fail to print: Transaction Total by Item (rptTxnTotByItem)<br/><br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 || !getSiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
			if (getDateRangeStart().isEmpty()) {
				sb.append("Please supply Start Date.<br/>");
			}
			if (getDateRangeEnd().isEmpty()) {
				sb.append("Please supply End Date.<br/>");
			}
		}

		// Transfer to Company AR
		if (getTCAR().isSelected()) {
			if (error) {
				sb.append("<br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 ||
					!getSiteCode().isValid() ||
					getDateRangeStart().isEmpty() ||
					getDateRangeEnd().isEmpty()) {
				error = true;
				sb.append("Fail to print: Transfer to Company AR (rptTransToCmpAR)<br/><br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 || !getSiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
			if (getDateRangeStart().isEmpty()) {
				sb.append("Please supply Start Date.<br/>");
			}
			if (getDateRangeEnd().isEmpty()) {
				sb.append("Please supply End Date.<br/>");
			}
		}

		// Transaction Total by Item
		if (getTTI().isSelected()) {
			if (error) {
				sb.append("<br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 ||
					!getSiteCode().isValid() ||
					getDateRangeStart().isEmpty() ||
					getDateRangeEnd().isEmpty()) {
				error = true;
				sb.append("Fail to print: Transaction Total by Item (rptTxnTotByItem)<br/><br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 || !getSiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
			if (getDateRangeStart().isEmpty()) {
				sb.append("Please supply Start Date.<br/>");
			}
			if (getDateRangeEnd().isEmpty()) {
				sb.append("Please supply End Date.<br/>");
			}
		}

		// Transaction Listing
		if (getTL().isSelected()) {
			if (error) {
				sb.append("<br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 ||
					!getSiteCode().isValid() ||
					getDateRangeStart().isEmpty() ||
					getDateRangeEnd().isEmpty()) {
				error = true;
				sb.append("Fail to print: Transaction Listing (rptTxnLst)<br/><br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 || !getSiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
			if (getDateRangeStart().isEmpty()) {
				sb.append("Please supply Start Date.<br/>");
			}
			if (getDateRangeEnd().isEmpty()) {
				sb.append("Please supply End Date.<br/>");
			}
		}

		// reject Cheque List
		if (getRCL().isSelected()) {
			if (error) {
				sb.append("<br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 ||
					!getSiteCode().isValid() ||
					getDateRangeStart().isEmpty() ||
					getDateRangeEnd().isEmpty()) {
				error = true;
				sb.append("Fail to print: Reject Cheque List (RptRejChqLst)<br/><br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 || !getSiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
			if (getDateRangeStart().isEmpty()) {
				sb.append("Please supply Start Date.<br/>");
			}
			if (getDateRangeEnd().isEmpty()) {
				sb.append("Please supply End Date.<br/>");
			}
		}

		// Soon to Expiry Contract Report
		if (getSTECR().isSelected()) {
			if (error) {
				sb.append("<br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 ||
					!getSiteCode().isValid() ||
					getDateRangeStart().isEmpty() ||
					getDateRangeEnd().isEmpty()) {
				error = true;
				sb.append("Fail to print: Soon to Expiry Contract Report(RptSnExpiry)<br/><br/>");
			}
			if (getSiteCode().getText().trim().length() == 0 || !getSiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
			if (getDateRangeStart().isEmpty()) {
				sb.append("Please supply Start Date.<br/>");
			}
			if (getDateRangeEnd().isEmpty()) {
				sb.append("Please supply End Date.<br/>");
			}
		}

		// Outstanding Balance Report
		if (getOBR().isSelected()) {
			if (error) {
				sb.append("<br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 ||
					!getSiteCode().isValid()) {
				error = true;
				sb.append("Fail to print: Outstanding Balance Report (RptOutstdBal)<br/><br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 || !getSiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
		}

		// Outstanding Day Case Slip
		if (getODCS().isSelected()) {
			if (error) {
				sb.append("<br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 ||
					!getSiteCode().isValid()) {
				error = true;
				sb.append("Fail to print: Outstanding Day Case Slip (RptDayCaseSlip)<br/><br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 || !getSiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
		}

		// Outstanding Balance Report
		if (getOBR().isSelected()) {
			if (error) {
				sb.append("<br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 ||
					!getSiteCode().isValid()) {
				error = true;
				sb.append("Fail to print: Outstanding Balance Report (RptOutstdBal)<br/><br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 || !getSiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
		}

		// Outstanding IP Slip
		if (getOIS().isSelected()) {
			if (error) {
				sb.append("<br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 ||
					!getSiteCode().isValid()) {
				error = true;
				sb.append("Fail to print: Outstanding IP Slip (RptIPSlip)<br/><br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 || !getSiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
		}

		// Outstanding OP Slip
		if (getOOS().isSelected()) {
			if (error) {
				sb.append("<br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 ||
					!getSiteCode().isValid()) {
				error = true;
				sb.append("Fail to print: Outstanding OP Slip (RptOPSlip)<br/><br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 || !getSiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
		}

		// Override Fee Report
		if (getOFR().isSelected()) {
			if (error) {
				sb.append("<br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 ||
					!getSiteCode().isValid() ||
					getDateRangeStart().isEmpty() ||
					getDateRangeEnd().isEmpty()) {
				error = true;
				sb.append("Fail to print: Override Fee Report (RptOverrideFee)<br/><br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 || !getSiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
			if (getDateRangeStart().isEmpty()) {
				sb.append("Please supply Start Date.<br/>");
			}
			if (getDateRangeEnd().isEmpty()) {
				sb.append("Please supply End Date.<br/>");
			}
		}

		// Receipt Report
		if (getReceipt().isSelected()) {
			if (error) {
				sb.append("<br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 ||
					!getSiteCode().isValid() ||
					getDateRangeStart().isEmpty() ||
					getDateRangeEnd().isEmpty()) {
				error = true;
				sb.append("Fail to print: Receipt Report (rptReceipt)<br/><br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 || !getSiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
			if (getDateRangeStart().isEmpty()) {
				sb.append("Please supply Start Date.<br/>");
			}
			if (getDateRangeEnd().isEmpty()) {
				sb.append("Please supply End Date.<br/>");
			}
		}

		// Weekly Bill
		if (getWeekBill().isSelected()) {
			if (error) {
				sb.append("<br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 ||
					!getSiteCode().isValid() ||
					getDateRangeStart().isEmpty()) {
				error = true;
				sb.append("Fail to print: Weekly Bill Report (RptWeekBill_xls)<br/><br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 || !getSiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
			if (getDateRangeStart().isEmpty()) {
				sb.append("Please supply Start Date.<br/>");
			}
		}

		// Cover Letter
		if (getCoverLetter().isSelected()) {
			if (error) {
				sb.append("<br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 ||
					!getSiteCode().isValid() ||
					getDateRangeStart().isEmpty()) {
				error = true;
				sb.append("Fail to print: Cover Letter <br/><br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 || !getSiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
			if (getDateRangeStart().isEmpty()) {
				sb.append("Please supply Start Date.<br/>");
			}
		}

		if (error) {
			Factory.getInstance().addErrorMessage(sb.toString());
			return false;
		}

		return true;
	}

	@Override
	public void printAction() {
		//checking
		if (!validatePrintAction()) {
			return;
		}

		String steCode = getSiteCode().getText().trim();
		String stename = getSiteCode().getDisplayText();
		String startDate = getDateRangeStart().getText().trim();
		String endDate = getDateRangeEnd().getText().trim();
		String dateRange = startDate+" to "+endDate;
		Map<String, String> map = new HashMap<String, String>();
		map.put("SteCode", steCode);
		map.put("SteName", stename);
		map.put("StartDate", startDate);
		map.put("EndDate", endDate);
		map.put("SUBREPORT_DIR", CommonUtil.getReportDir());

		if (getPrinttoScreen().isSelected()) {//use report panel
			// Cancelled/Transferred Transactions Listing
			if (getCTTL().isSelected()) {
				Report.print(Factory.getInstance().getUserInfo(), "RptCancelTxLst", map,
									new String[] {
											startDate, endDate, steCode
									},
									new String[] {
											"STENAME", "STNSTS", "SLPTYPE",
											"STNTDATE", "GLCCODE", "SLPFNAME",
											"SLPGNAME", "PATFNAME", "PATNO",
											"PATGNAME", "SLPNO", "ITMCODE",
											"STNDESC", "STNNAMT", "USRID"
									});
			}

			// Cash Management/Petty Cash Report
			if (getCMPCR().isSelected()) {
				// add option panel
				getDlgDayEndReport().showDialog("RptPettyCash", map, startDate, endDate, steCode, true, false);
			}

			// Cashier Audit Summary
			if (getCAS().isSelected()) {
				// add option panel
				getDlgDayEndReport().showDialog("RptCshrAuditSmy", map, startDate, endDate, steCode, true, false);
			}

			// Daily Income Summary
			if (getDIS().isSelected()) {
				Report.print(Factory.getInstance().getUserInfo(), "RptDailyInc", map,
									new String[] {
											startDate, endDate, steCode
									},
									new String[] {
											"STENAME", "SLPTYPE", "GLCCODE",
											"GLCNAME", "STNBAMT" , "NUM"
									});
			}

			// Deposit Settlement List
			if (getDSL().isSelected()) {
				Report.print(Factory.getInstance().getUserInfo(), "RptDepSettle",
								map,
								new String[] {
										startDate, endDate, steCode
								},
								new String[] {
										"STENAME", "DPSSTS", "GLCCODE",
										"SLPNO_S", "PATNO", "PATNAME",
										"STNDESC", "DPSAMT", "DPSLCDATE",
										"STNID"
								});
			}

			// Contract Switching Report
			if (getCSR().isSelected()) {
				Report.print(Factory.getInstance().getUserInfo(), "RptContSwitch",
								map,
								new String[] {
										endDate, steCode
								},
								new String[] {
									"ARCCODE", "ARCNAME", "CPSCODE",
									"CPSDESC","CPSCODE1", "CPSDESC1",
									"ACHEDATE"
								});
			}

			// Refund List
			if (getRL().isSelected()) {
				Report.print(Factory.getInstance().getUserInfo(), "RptRefList",
						map,
						new String[] {startDate,endDate,steCode},
						new String[]{"ITMCODE","CTXMETH","PATNO",
						"SLPNO","SLPFNAME","STNNAMT","USRID","STECODE",
						"STENAME","SLPTYPE","STNSTS","STNCDATE"});

			}

			// Transfer to Company AR
			if (getTCAR().isSelected()) {
				Report.print(Factory.getInstance().getUserInfo(),
						"RptTransToCmpAR",map,
						 new String[] {startDate,endDate,steCode},
						 new String[] {"PATNO","STNTYPE","SLPTYPENAME",
						"AMT","NAME","SLPNO","BILLON","ARCCODE","ARCNAME","SLPTYPE","SLPCNT","SLPPLYNO","SLPVCHNO"});
			}

			// Note to the Account
			if (getNA().isSelected()) {
				Report.print(Factory.getInstance().getUserInfo(),"RptNoteToAcc", map,
						new String[] {startDate,endDate,steCode},
						new String[] {"CTXMETH","SLPTYPE","CTXSTS",
						"PATNO","PATNAME","SLPNO","MARPAYEE","MARADD1",
						"MARADD2","MARADD3","COUNTRY" ,"CTXAMT","MARREASON","USRID"});
			}

			// Transaction Total by Item
			if (getTTI().isSelected()) {
				Report.print(Factory.getInstance().getUserInfo(),"RptTxnTotByItem",map,
						new String[] {startDate,endDate,steCode},
						new String[] {"STENAME","DEPT","ITMCODE","ITMNAME","ITMCNT","ITMAMT"},
						new boolean[]{false,false,false,false,false,false},
						new String[] {"RptTxnTotByItemPkg"},
				new String[][] {{startDate,endDate,steCode}},
				new String[][] {{"PACKCODE","PACKNAME","STENAME",
						"DEPT","ITMCODE","ITMNAME","ITMCNT","ITMAMT"}},
				new boolean[][] {{false,false,false,false,false,false,false,false}},"");
			}

			// Transaction Listing
			if (getTL().isSelected()) {
				Report.print(Factory.getInstance().getUserInfo(),"RptTxnLst"
						,map,new String[] {startDate,endDate,steCode},
						 new String[] {"SLPTYPE","PATNO","PATNAME",
					"SLPNO","ITMCODE","STENAME","STNSTS","STNDESC",
					"STNNAMT","DOCCODE","SPCCODE","STNTDATE","USRID"});
			}

			// Rejected Cheque List
			if (getRCL().isSelected()) {
				map.put("siteName",stename);
				Report.print(Factory.getInstance().getUserInfo(),
						"RptRejChqLst",map,
						 new String[] {startDate,endDate,steCode},
						 new String[] {"SLPNO","PATNO","SLPTYPE",
						"PATNAME","STNNAMT","USRID","STNCDATE"});

			}

			// Soon to expiry Contract Report
			if (getSTECR().isSelected()) {
				Report.print(Factory.getInstance().getUserInfo(),
						"RptSnExpiry",map,
						 new String[] {endDate,steCode},
						 new String[] {"ARCCODE","ARCNAME","CPSCODE",
						"CPSDESC","ACHSDATE","ACHEDATE"});
			}

			// Outstanding Balance Report
			if (getOBR().isSelected()) {
				map.remove("dateRange");
				String reportTime  = null;
				if (endDate != null) {
					reportTime = endDate;
				} else {
					reportTime = getMainFrame().getServerDate();
				}
				map.put("siteName", stename);
				Report.print(Factory.getInstance().getUserInfo(), "RptOutstdBal", map,
						new String[] {
					reportTime,steCode,Integer.toString(ConstantsProperties.OTP2)
						},
						new String[] {"PATNO","PATNAME","SLPNO","SLPTYPE",
								"PCYDESC","REGDATE","SLPAMT","SLPREMARK"});

			}

			// Outstanding Day Case Slip
			if (getODCS().isSelected()) {
				map.remove("dateRange");
				String reportTime  = null;

				if (startDate != null) {
					reportTime = endDate;
				} else {
					reportTime = getMainFrame().getServerDate();
				}
				map.put("reportTime", reportTime);
				Report.print(Factory.getInstance().getUserInfo(), "RptDayCaseSlip", map,
						new String[] {
					reportTime,steCode,Integer.toString(ConstantsProperties.OTP2)
						},
						new String[] {"STENAME","DOCCODE","SLPNO",
								"PATNO","REGDATE","PATNAME","G","AMOUNT","SLPREMARK","SLPSTS"});
			}

			// Outstanding Deposit Report
			if (getODR().isSelected()) {
				String paperSize = Factory.getInstance().getSysParameter("DpPageSize");
				String printerName = " ";
				if (paperSize != null && paperSize.length() > 0) {
					printerName = "HATS_"+paperSize;
				}

				Report.print(Factory.getInstance().getUserInfo(),
						 "RptOutstdgDeposit", map,
						 new String[] {steCode},
						 new String[] {"SLPNO_S","DPSAMT","DPSCDATE",
									"DPSSTS","PATNO","SLPFNAME","SLPGNAME",
									"STNDESC","GLCCODE","PATFNAME","PATGNAME","STENAME"},
								null,null,null,
								new String[] {null},
								null,paperSize);
			}

			// Outstanding IP Slip
			if (getOIS().isSelected()) {
				map.remove("dateRange");
				String reportTime = null;
				if (endDate != null) {
					reportTime=endDate;
				} else {
					reportTime = getMainFrame().getServerDate();
				}
				map.put("reportTime", reportTime);
				Report.print(Factory.getInstance().getUserInfo(), "RptIPSlip", map,
						new String[] {reportTime,steCode,Integer.toString(ConstantsProperties.OTP2)},
						new String[]  {"STENAME","DOCCODE","SLPNO","PATNO","REGDATE",
								"PATNAME","AMOUNT","BEDCODE","WRDCODE",
								"DDATE","SLPREMARK","SLPSTS", "ARCCODE"});
			}

			// Outstanding OP Slip
			if (getOOS().isSelected()) {

				map.remove("dateRange");
				String reportTime = null;
				String oosFilter = getOOSFilter().getText().trim();
				if (endDate != null) {
					reportTime=endDate;
				} else {
					reportTime = getMainFrame().getServerDate();
				}

				map.put("reportTime", reportTime);
				Report.print(Factory.getInstance().getUserInfo(), "RptOPSlip", map,
						new String[] {reportTime,steCode,Integer.toString(ConstantsProperties.OTP2),oosFilter},
						new String[] {"STENAME","DOCCODE","SLPNO",
								"PATNO","REGDATE","PATNAME","G","AMOUNT",
								"SLPREMARK","SLPSTS"});
			}

			// Override Fee Report
			if (getOFR().isSelected()) {
				map.put("dateRange",dateRange);
				Report.print(Factory.getInstance().getUserInfo(), "RptOverrideFee", map,
						new String[] {startDate,endDate,steCode},
						new String[] {"ITMCODE","ITMNAME","PKGCODE",
								"STNSTS","STNBAMT","STNOAMT","SLPNO","DOCCODE",
								"USRID","STENAME","STNCDATE"});
			}

			// Receipt Report
			if (getReceipt().isSelected()) {
				// add option panel
				map.put("dateRange", dateRange);
				getDlgDayEndReport().showDialog("RptReceipt", map, startDate, endDate, steCode, true, false);
			}

			// Weekly Bill Report
			if (getWeekBill().isSelected()) {
				map.put("dateRange",dateRange);
				Report.print(Factory.getInstance().getUserInfo(), "RptWeekBill_xls",
						map,
						new String[] {"rptNameWDate",startDate},
						new String[] {"PATNO","SLPNO","PATNAME",
								"PATFNAME","BEDCODE","TITDESC","REGDATE",
								"SLPTYPE","ARCODE","OUTAMT"});
			}

			// Cover Letter
			if (getCoverLetter().isSelected()) {
				map.put("printDate",dateRange);
				Report.print(Factory.getInstance().getUserInfo(), "DAYENDCOVERLETTER",
						map,
						new String[] {startDate},
						new String[] {"ALLSLPNO", "DSLP.PATNO", "PATNAME",
						"PATFNAME", "BEDCODE", "PATTITLE", "AMT", "PRINTDATE",
						"FROMDATE","TODATE"});
			}

			if (getIPStatmentWB().isSelected()) {
				System.err.println("1[slipno]:"+getPatientCode().getText()+";[startDate]:"+startDate);
				Map<String,String> mapWB = new HashMap<String,String>();
				mapWB.put("SUBREPORT_DIR", CommonUtil.getReportDir());
				mapWB.put("DOCBKGCPY",Factory.getInstance().getSysParameter("DOCBKGCPY"));
				mapWB.put("watermark", CommonUtil.getReportImg("copy_watermark.gif"));
				mapWB.put("ALLSLPNO",getPatientCode().getText());

				Factory.getInstance()
				.addRequiredReportDesc(mapWB,
							new String[] {
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage"
							},
							new String[] {
									"StaOfAut", "AdmDtTime", "PatName",
									"DisDtTime", "TreDr", "BillNo",
									"PatNo", "BedNo", "Copy", "Page",
									"Date", "Item", "Amount", "TotChg",
									"TotRfd", "Balance", "Credits", "StatBalance", "BalanceFwd"
							},
							"CTE");

				Report.print(getUserInfo(), "IPStatementWB", mapWB,
						new String[] { getPatientCode().getText(), startDate },
						new String[] {
								"PATNAME", "PATCNAME" ,"SLPNO", "PATNO",
								"REGDATE", "REGTIME", "BEDACM", "INPDDATE",
								"INPDTIME", "DOCNAME", "DOCCNAME", "FROM_WBDATE",
								"TO_WBDATE"
						},
						new boolean[] {
								false, false, false, false, false, false,
								false, false, false, false, false, false, false
						},
						new String[] {
								"IPStatementWB_Sub4",
								"IPStatementWB_Sub1",
								"IPStatementWB_Sub3"
						} ,
						new String[][] {
								{
									getPatientCode().getText(), startDate
								},
								{
									getPatientCode().getText(), startDate
								},
								{
									getPatientCode().getText(), startDate
								}
						},
						new String[][] {
								{
										"STNTDATE", "AMOUNT", "DESCRIPTION", "QTY", "CDESCCODE"

								},
								{
										"STNTDATE", "AMOUNT", "DESCRIPTION", "QTY",
										"TOTALREFUND", "TOTALCHARGE", "CDESCCODE"
								},
								{
										"STNTDATE", "AMOUNT", "DESCRIPTION", "QTY", "CDESCCODE"
								},
						},
						new boolean[][] {
								{
										false, true, false, true, false
								},
								{
										false, true, false, true, true, true, false
								},
								{
										false, true, false, true, false
								}
						}, Factory.getInstance().getSysParameter("IpPageSize"));
			}
		} else if (getPrinttoFile().isSelected()) {
			// print xls
			// Cancelled/Transferred Transactions Listing
			if (getCTTL().isSelected()) {
				PrintingUtil.print("DEFAULT", "RptCancelTxLst", map, "",
									new String[] {
											startDate, endDate, steCode
									},
									new String[] {
											"STENAME", "STNSTS", "SLPTYPE",
											"STNTDATE", "GLCCODE", "SLPFNAME",
											"SLPGNAME", "PATFNAME", "PATNO",
											"PATGNAME", "SLPNO", "ITMCODE",
											"STNDESC", "STNNAMT", "USRID"
									},
									0, null, null, null, null, 1,
									false, true, new String[] { "xls" }, true);
			}

			// Cash Management/Petty Cash Report
			if (getCMPCR().isSelected()) {
				// add option panel
				getDlgDayEndReport().showDialog("RptPettyCash", map, startDate, endDate, steCode, false, true);
			}

			// Cashier Audit Summary
			if (getCAS().isSelected()) {
				// add option panel
				getDlgDayEndReport().showDialog("RptCshrAuditSmy", map, startDate, endDate, steCode, false, true);
			}

			// Daily Income Summary
			if (getDIS().isSelected()) {
				PrintingUtil.print("DEFAULT", "RptDailyInc", map, "",
									new String[] {
											startDate, endDate, steCode
									},
									new String[] {
											"STENAME", "SLPTYPE", "GLCCODE",
											"GLCNAME", "STNBAMT" , "NUM"
									},
									0, null, null, null, null, 1,
									false, true, new String[] { "xls" }, true);
			}

			// Deposit Settlement List
			if (getDSL().isSelected()) {
				PrintingUtil.print("DEFAULT", "RptDepSettle", map, "",
									new String[] {
											startDate, endDate, steCode
									},
									new String[] {
											"STENAME", "DPSSTS", "GLCCODE",
											"SLPNO_S", "PATNO", "PATNAME",
											"STNDESC", "DPSAMT", "DPSLCDATE",
											"STNID"
									},
									0, null, null, null, null, 1,
									false, true, new String[] { "xls" }, true);
			}

			// Contract Switching Report
			if (getCSR().isSelected()) {
				PrintingUtil.print("DEFAULT", "RptContSwitch", map, "",
									new String[] {
											endDate, steCode
									},
									new String[] {
										"ARCCODE", "ARCNAME", "CPSCODE",
										"CPSDESC","CPSCODE1", "CPSDESC1",
										"ACHEDATE"
									},
									0, null, null, null, null, 1,
									false, true, new String[] { "xls" }, true);
			}

			// Transfer to Company AR
			if (getTCAR().isSelected()) {
				map.put("siteName",stename);
				PrintingUtil.print("DEFAULT","RptTransToCmpAR_xls",map,"",
						 new String[] {startDate,endDate,steCode},
						 new String[] {"PATNO","STNTYPE","SLPTYPENAME",
						"AMT","NAME","SLPNO","BILLON","ARCCODE","ARCNAME","SLPTYPE","SLPCNT","SLPPLYNO","SLPVCHNO"},
						0, null, null, null, null, 1,
						false, true, new String[] { "xls" });
			}

			// Note to the Account
			if (getNA().isSelected()) {
				PrintingUtil.print("DEFAULT","RptNoteToAcc", map,"",
						new String[] {startDate,endDate,steCode},
						new String[] {"CTXMETH","SLPTYPE","CTXSTS",
						"PATNO","PATNAME","SLPNO","MARPAYEE","MARADD1",
						"MARADD2","MARADD3","COUNTRY" ,"CTXAMT","MARREASON","USRID"},
						0, null, null, null, null, 1,
						false, true, new String[] { "xls" }, true);
			}

			// Transaction Total by Item
			if (getTTI().isSelected()) {
				PrintingUtil.print("DEFAULT","RptTxnTotByItem",map,"",
						new String[] {startDate,endDate,steCode},
						new String[] {"STENAME","DEPT","ITMCODE","ITMNAME","ITMCNT","ITMAMT"},
						1,new String[] {"RptTxnTotByItemPkg"},
				new String[][] {{startDate,endDate,steCode}},
				new String[][] {{"PACKCODE","PACKNAME","STENAME",
						"DEPT","ITMCODE","ITMNAME","ITMCNT","ITMAMT"}},
				new boolean[][] {{false,false,false,false,false,false,false,false}},
				1,false, true, new String[] { "xls" }, true);
			}

			// Transaction Listing
			if (getTL().isSelected()) {
				PrintingUtil.print("DEFAULT","RptTxnLst",map,"",
						 new String[] {startDate,endDate,steCode},
						 new String[] {"SLPTYPE","PATNO","PATNAME",
					"SLPNO","ITMCODE","STENAME","STNSTS","STNDESC",
					"STNNAMT","DOCCODE","SPCCODE","STNTDATE","USRID"},
					0, null, null, null, null, 1,
					false, true, new String[] { "xls" }, true);
			}

			// Refund List
			if (getRL().isSelected()) {
				PrintingUtil.print("DEFAULT","RptRefList",map,"",
						 new String[] {startDate,endDate,steCode},
						 new String[] {"ITMCODE","CTXMETH","PATNO",
						"SLPNO","SLPFNAME","STNNAMT","USRID","STECODE",
						"STENAME","SLPTYPE","STNSTS","STNCDATE"},
						0, null, null, null, null, 1,
						false, true, new String[] { "xls" }, true);

			}

			// Rejected cheque list
			if (getRCL().isSelected()) {
				map.put("siteName",stename);
				PrintingUtil.print("DEFAULT","RptRejChqLst",map,"",
						 new String[] {startDate,endDate,steCode},
						 new String[] {"SLPNO","PATNO","SLPTYPE",
						"PATNAME","STNNAMT","USRID","STNCDATE"},
						0, null, null, null, null, 1,
						false, true, new String[] { "xls" }, true);

			}

			// Soon to expiry Contract Report
			if (getSTECR().isSelected()) {
				PrintingUtil.print("DEFAULT","RptSnExpiry",map,"",
						 new String[] {endDate,steCode},
						 new String[] {"ARCCODE","ARCNAME","CPSCODE",
						"CPSDESC","ACHSDATE","ACHEDATE"},
						0, null, null, null, null, 1,
						false, true, new String[] { "xls" }, true);
			}

			// Outstanding Balance Report
			if (getOBR().isSelected()) {
				map.remove("dateRange");
				String reportTime  = null;
				if (endDate != null) {
					reportTime = endDate;
				} else {
					reportTime = getMainFrame().getServerDate();
				}
				map.put("siteName", stename);
				PrintingUtil.print("DEFAULT", "RptOutstdBal",map,"",
						 new String[] {reportTime,steCode,Integer.toString(ConstantsProperties.OTP2)},
						 new String[] {"PATNO","PATNAME","SLPNO","SLPTYPE",
						"PCYDESC","REGDATE","SLPAMT","SLPREMARK"},
						0, null, null, null, null, 1,
						false, true, new String[] { "xls" }, true);
			}

			// Outstanding Day Case Slip
			if (getODCS().isSelected()) {
				map.remove("dateRange");
				String reportTime  = null;
				if (endDate != null) {
					reportTime = endDate;
				} else {
					reportTime = getMainFrame().getServerDate();
				}
				map.put("reportTime", reportTime);
				PrintingUtil.print("DEFAULT","RptDayCaseSlip",map,"",
						 new String[] {reportTime,steCode,Integer.toString(ConstantsProperties.OTP2)},
						 new String[] {"STENAME","DOCCODE","SLPNO",
						"PATNO","REGDATE","PATNAME","G","AMOUNT","SLPREMARK","SLPSTS"},                     
						0, null, null, null, null, 1,
						false, true, new String[] { "xls" }, true);
			}

			// Outstanding Deposit Report
			if (getODR().isSelected()) {
				String paperSize = Factory.getInstance().getSysParameter("DpPageSize");
				String printerName = " ";
				if (paperSize != null && paperSize.length() > 0) {
					printerName = "HATS_"+paperSize;
				}

				PrintingUtil.print(printerName, "RptOutstdgDeposit", map, "",
						new String[] { steCode },
						new String[] {"SLPNO_S","DPSAMT","DPSCDATE",
						"DPSSTS","PATNO","SLPFNAME","SLPGNAME",
						"STNDESC","GLCCODE","PATFNAME","PATGNAME","STENAME"},
						0, null, null, null, null, 1, null, false,
						paperSize, true, new String[] { "xls" }
						);
			}

			// Outstanding IP Slip
			if (getOIS().isSelected()) {
				map.remove("dateRange");
				String reportTime = null;
				if (endDate != null) {
					reportTime=endDate;
				} else {
					reportTime = getMainFrame().getServerDate();
				}
				map.put("reportTime", reportTime);
				PrintingUtil.print("DEFAULT","RptIPSlip",map,"",
						new String[] {reportTime,steCode,Integer.toString(ConstantsProperties.OTP2)},
						new String[] {"STENAME","DOCCODE","SLPNO","PATNO","REGDATE",
								"PATNAME","AMOUNT","BEDCODE","WRDCODE",
								"DDATE","SLPREMARK","SLPSTS", "ARCCODE"},
						0, null, null, null, null, 1,
						false, true, new String[] { "xls" }, true);
			}

			// Outstanding OP Slip
			if (getOOS().isSelected()) {
				map.remove("dateRange");
				String reportTime = null;
				String oosFilter = getOOSFilter().getText().trim();
				if (endDate != null) {
					reportTime=endDate;
				} else {
					reportTime = getMainFrame().getServerDate();
				}

				map.put("reportTime", reportTime);
				PrintingUtil.print("DEFAULT","RptOPSlip",map,"",
						new String[] {reportTime,steCode,Integer.toString(ConstantsProperties.OTP2),oosFilter},
						new String[] {"STENAME","DOCCODE","SLPNO",
								"PATNO","REGDATE","PATNAME","G","AMOUNT",
								"SLPREMARK","SLPSTS"},
						0, null, null, null, null, 1,
						false, true, new String[] { "xls" }, true);
			}

			// Override Fee Report
			if (getOFR().isSelected()) {
				map.put("dateRange",dateRange);
				PrintingUtil.print("DEFAULT","RptOverrideFee",map,"",
						new String[] {startDate,endDate,steCode},
						new String[] {"ITMCODE","ITMNAME","PKGCODE",
								"STNSTS","STNBAMT","STNOAMT","SLPNO","DOCCODE",
								"USRID","STENAME","STNCDATE"},
						0, null, null, null, null, 1,
						false, true, new String[] { "xls" }, true);
			}

			// Receipt Report
			if (getReceipt().isSelected()) {
				// add option panel
				map.put("dateRange", dateRange);
				getDlgDayEndReport().showDialog("RptReceipt", map, startDate, endDate, steCode, false, true);
			}

			// Weekly Bill Report
			if (getWeekBill().isSelected()) {
				map.put("dateRange",dateRange);
				Report.print(Factory.getInstance().getUserInfo(), "RptWeekBill_xls",
						map,
						new String[] {startDate},
						new String[] {"PATNO","SLPNO","PATNAME",
					"PATFNAME","BEDCODE","TITDESC","REGDATE",
					"SLPTYPE","ARCODE","OUTAMT"});
			}

			// Cover Letter
			if (getCoverLetter().isSelected()) {
				map.put("printDate",dateRange);
				Report.print(Factory.getInstance().getUserInfo(), "DAYENDCOVERLETTER",
						map,
						new String[] {startDate},
						new String[] {"ALLSLPNO", "DSLP.PATNO", "PATNAME",
						"PATFNAME", "BEDCODE", "PATTITLE", "AMT", "PRINTDATE",
						"FROMDATE","TODATE"});
			}


			// IP Statement WB
			if (getIPStatmentWB().isSelected()) {
				Map<String,String> mapWB = new HashMap<String,String>();
				System.err.println("2[slipno]:"+getPatientCode().getText()+";[startDate]:"+startDate);
				mapWB.put("SUBREPORT_DIR", CommonUtil.getReportDir());
				mapWB.put("DOCBKGCPY",Factory.getInstance().getSysParameter("DOCBKGCPY"));
				mapWB.put("watermark", CommonUtil.getReportImg("copy_watermark.gif"));
				mapWB.put("ALLSLPNO",getPatientCode().getText());

				Factory.getInstance()
				.addRequiredReportDesc(mapWB,
							new String[] {
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage"
							},
							new String[] {
									"StaOfAut", "AdmDtTime", "PatName",
									"DisDtTime", "TreDr", "BillNo",
									"PatNo", "BedNo", "Copy", "Page",
									"Date", "Item", "Amount", "TotChg",
									"TotRfd", "Balance", "Credits", "StatBalance", "BalanceFwd"
							},
							"CTE");

				Report.print(getUserInfo(), "IPStatementWB", mapWB,
						new String[] { getPatientCode().getText(), startDate },
						new String[] {
								"PATNAME", "PATCNAME" ,"SLPNO", "PATNO",
								"REGDATE", "REGTIME", "BEDACM", "INPDDATE",
								"INPDTIME", "DOCNAME", "DOCCNAME", "FROM_WBDATE",
								"TO_WBDATE"
						},
						new boolean[] {
								false, false, false, false, false, false,
								false, false, false, false, false, false, false
						},
						new String[] {
								"IPStatementWB_Sub4",
								"IPStatementWB_Sub1",
								"IPStatementWB_Sub3"
						} ,
						new String[][] {
								{
									getPatientCode().getText(), startDate
								},
								{
									getPatientCode().getText(), startDate
								},
								{
									getPatientCode().getText(), startDate
								}
						},
						new String[][] {

								{
										"STNTDATE", "AMOUNT", "DESCRIPTION", "QTY", "CDESCCODE"
								},
								{
										"STNTDATE", "AMOUNT", "DESCRIPTION", "QTY",
										"TOTALREFUND", "TOTALCHARGE", "CDESCCODE"
								},
								{
										"STNTDATE", "AMOUNT", "DESCRIPTION", "QTY", "CDESCCODE"
								}
						},
						new boolean[][] {
								{
										false, true, false, true, false
								},
								{
										false, true, false, true, true, true, false
								},
								{
										false, true, false, true, false
								}
						}, Factory.getInstance().getSysParameter("IpPageSize"));
			}
		} else {
			// print to printer
			// Cancelled/Transferred Transactions Listing
			if (getCTTL().isSelected()) {
				PrintingUtil.print("DEFAULT","RptCancelTxLst", map, "",
									new String[] {
											startDate, endDate, steCode
									},
									new String[] {
											"STENAME", "STNSTS", "SLPTYPE",
											"STNTDATE", "GLCCODE", "SLPFNAME",
											"SLPGNAME", "PATFNAME", "PATNO",
											"PATGNAME", "SLPNO", "ITMCODE",
											"STNDESC", "STNNAMT", "USRID"
									});
			}

			// Cash Management/Petty Cash Report
			if (getCMPCR().isSelected()) {
				// add option panel
				getDlgDayEndReport().showDialog("RptPettyCash", map, startDate, endDate, steCode, false, false);
			}

			// Cashier Audit Summary
			if (getCAS().isSelected()) {
				// add option panel
				getDlgDayEndReport().showDialog("RptCshrAuditSmy", map, startDate, endDate, steCode, false, false);
			}

			// Daily Income Summary
			if (getDIS().isSelected()) {
				PrintingUtil.print("DEFAULT","RptDailyInc", map, "",
									new String[] {
											startDate, endDate, steCode
									},
									new String[] {
											"STENAME", "SLPTYPE", "GLCCODE",
											"GLCNAME", "STNBAMT" , "NUM"
									});
			}

			// Deposit Settlement List
			if (getDSL().isSelected()) {
				PrintingUtil.print("DEFAULT","RptDepSettle", map, "",
									new String[] {
											startDate, endDate, steCode
									},
									new String[] {
											"STENAME", "DPSSTS", "GLCCODE",
											"SLPNO_S", "PATNO", "PATNAME",
											"STNDESC", "DPSAMT", "DPSLCDATE",
											"STNID"
									});
			}

			// Contract Switching Report
			if (getCSR().isSelected()) {
				PrintingUtil.print("DEFAULT","RptContSwitch", map, "",
									new String[] {
											endDate, steCode
									},
									new String[] {
										"ARCCODE", "ARCNAME", "CPSCODE",
										"CPSDESC","CPSCODE1", "CPSDESC1",
										"ACHEDATE"
									});
			}

			if (getALIC().isSelected()) {

			}

			if (getOLBSA().isSelected()) {
				Map<String,String> par = new HashMap<String,String>();
				par.put("dateRange",dateRange);
				par.put("siteName",stename);
				par.put("SUBREPORT_DIR",CommonUtil.getReportDir());
				PrintingUtil.print("DEFAULT","RptOTLogSlipAudit",par,"",
						new String[] {startDate,endDate},
						new String[] {"AUDID","PATIENTNO","ADMUSERID","ADMDATE",
						"PRESLPNO","NEWSLPNO","PRESEQNO","NEWSEQNO","STNSEQ",
						"NEWSTNSEQ","PREPKGCODE","PREITMCODE","PREUSRID",
						"NEWPKGCODE","NEWITMCODE","NEWUSRID"}
				);
			}

			// Outstanding Balance Report
			if (getOBR().isSelected()) {
				map.remove("dateRange");
				String reportTime  = null;
				if (endDate != null) {
					reportTime = endDate;
				} else {
					reportTime = getMainFrame().getServerDate();
				}
				map.put("siteName", stename);
				PrintingUtil.print("DEFAULT","RptOutstdBal",map,"",
						 new String[] {reportTime,steCode,Integer.toString(ConstantsProperties.OTP2)},
						 new String[] {"PATNO","PATNAME","SLPNO","SLPTYPE",
						"PCYDESC","REGDATE","SLPAMT","SLPREMARK"});
			}

			// Outstanding Day Case Slip
			if (getODCS().isSelected()) {
				map.remove("dateRange");
				String reportTime  = null;

				if (startDate != null) {
					reportTime = endDate;
				} else {
					reportTime = getMainFrame().getServerDate();
				}
				map.put("reportTime", reportTime);
				PrintingUtil.print("DEFAULT","RptDayCaseSlip",map,"",
						 new String[] {reportTime,steCode,Integer.toString(ConstantsProperties.OTP2)},
						 new String[] {"STENAME","DOCCODE","SLPNO",
						"PATNO","REGDATE","PATNAME","G","AMOUNT","SLPREMARK","SLPSTS"});
			}

			// Soon to expiry Contract Report
			if (getSTECR().isSelected()) {
				map.put("reportTime", endDate);
				map.put("siteName", stename);
				PrintingUtil.print("DEFAULT","RptSnExpiry",map,"",
						 new String[] {endDate,steCode},
						 new String[] {"ARCCODE","ARCNAME","CPSCODE","CPSDESC","ACHSDATE","ACHEDATE"});
			}

			// Transfer to Company AR
			if (getTCAR().isSelected()) {
				PrintingUtil.print("DEFAULT","RptTransToCmpAR",map,"",
						 new String[] {startDate,endDate,steCode},
						 new String[] {"PATNO","STNTYPE","SLPTYPENAME",
						"AMT","NAME","SLPNO","BILLON","ARCCODE","ARCNAME","SLPTYPE","SLPCNT","SLPPLYNO","SLPVCHNO"});			
			}

			// Transaction Total by Item
			if (getTTI().isSelected()) {
				PrintingUtil.print("DEFAULT","RptTxnTotByItem",map,"",
						new String[] {startDate,endDate,steCode},
						new String[] {"STENAME","DEPT","ITMCODE","ITMNAME","ITMCNT","ITMAMT"},
						1,new String[] {"RptTxnTotByItemPkg"},
				new String[][] {{startDate,endDate,steCode}},
				new String[][] {{"PACKCODE","PACKNAME","STENAME",
						"DEPT","ITMCODE","ITMNAME","ITMCNT","ITMAMT"}},
				new boolean[][] {{false,false,false,false,false,false,false,false}});
			}

			// Transaction Listing
			if (getTL().isSelected()) {
				PrintingUtil.print("DEFAULT","RptTxnLst",map,"",
						 new String[] {startDate,endDate,steCode},
						 new String[] {"SLPTYPE","PATNO","PATNAME",
					"SLPNO","ITMCODE","STENAME","STNSTS","STNDESC",
					"STNNAMT","DOCCODE","SPCCODE","STNTDATE","USRID"});
			}

			// Rejected cheque list
			if (getRCL().isSelected()) {
				map.put("siteName",stename);
				PrintingUtil.print("DEFAULT","RptRejChqLst",map,"",
						 new String[] {startDate,endDate,steCode},
						 new String[] {"SLPNO","PATNO","SLPTYPE",
						"PATNAME","STNNAMT","USRID","STNCDATE"});
			}

			// Refund List
			if (getRL().isSelected()) {
				PrintingUtil.print("RptRefList",map,"",
						 new String[] {startDate,endDate,steCode},
						 new String[] {"ITMCODE","CTXMETH","PATNO",
						"SLPNO","SLPFNAME","STNNAMT","USRID","STECODE",
						"STENAME","SLPTYPE","STNSTS","STNCDATE"});
			}

			// Receipt Report
			if (getReceipt().isSelected()) {
				// add option panel
				map.put("dateRange", dateRange);
				getDlgDayEndReport().showDialog("RptReceipt", map, startDate, endDate, steCode, false, false);
			}

			if (getODR().isSelected()) {
				PrintingUtil.print("DEFAULT","RptOutstdgDeposit", null, null,
						new String[] {steCode},
						new String[] {"SLPNO_S","DPSAMT","DPSCDATE",
						"DPSSTS","PATNO","SLPFNAME","SLPGNAME",
						"STNDESC","GLCCODE","PATFNAME","PATGNAME","STENAME"});
			}

			// Note to the Account
			if (getNA().isSelected()) {
				PrintingUtil.print("DEFAULT","RptNoteToAcc", map,"",
						new String[] {startDate,endDate,steCode},
						new String[] {"CTXMETH","SLPTYPE","CTXSTS",
						"PATNO","PATNAME","SLPNO","MARPAYEE","MARADD1",
						"MARADD2","MARADD3","COUNTRY" ,"CTXAMT","MARREASON","USRID"});
			}

			// Outstanding Deposit Report
			if (getODR().isSelected()) {
				String paperSize = Factory.getInstance().getSysParameter("DpPageSize");
				String printerName = " ";
				if (paperSize != null && paperSize.length() > 0) {
					printerName = "HATS_"+paperSize;
				}

				PrintingUtil.print(printerName, "RptOutstdgDeposit", map, "",
						new String[] { steCode },
						new String[] {"SLPNO_S","DPSAMT","DPSCDATE",
						"DPSSTS","PATNO","SLPFNAME","SLPGNAME",
						"STNDESC","GLCCODE","PATFNAME","PATGNAME","STENAME"},
						0, null, null, null, null, 1,
						paperSize
						);
			}

			// Outstanding IP Slip
			if (getOIS().isSelected()) {
				map.remove("dateRange");
				String reportTime = null;
				if (!endDate.isEmpty()) {
					reportTime=endDate;
				} else {
					reportTime = getMainFrame().getServerDate();
				}
				map.put("reportTime", reportTime);
				PrintingUtil.print("DEFAULT","RptIPSlip",map,"",
						 new String[] {reportTime,steCode,Integer.toString(ConstantsProperties.OTP2)},
							new String[] {"STENAME","DOCCODE","SLPNO","PATNO","REGDATE",
						"PATNAME","AMOUNT","BEDCODE","WRDCODE",
						"DDATE","SLPREMARK","SLPSTS", "ARCCODE"});
			}

			// Outstanding OP Slip
			if (getOOS().isSelected()) {
				map.remove("dateRange");
				String reportTime = null;
				String oosFilter = getOOSFilter().getText().trim();
				if (endDate != null) {
					reportTime=endDate;
				} else {
					reportTime = getMainFrame().getServerDate();
				}

				map.put("reportTime", reportTime);
				PrintingUtil.print("DEFAULT","RptOPSlip",map,"",
						 new String[] {reportTime,steCode,Integer.toString(ConstantsProperties.OTP2),oosFilter},
						 new String[] {"STENAME","DOCCODE","SLPNO",
						"PATNO","REGDATE","PATNAME","G","AMOUNT",
						"SLPREMARK","SLPSTS"});
			}

			// Override Fee Report
			if (getOFR().isSelected()) {
				map.put("dateRange",dateRange);
				PrintingUtil.print("DEFAULT","RptOverrideFee",map,"",
						 new String[] {startDate,endDate,steCode},
						 new String[] {"ITMCODE","ITMNAME","PKGCODE",
						"STNSTS","STNBAMT","STNOAMT","SLPNO","DOCCODE",
						"USRID","STENAME","STNCDATE"});
			}

			// Weekly Bill Report
			if (getWeekBill().isSelected()) {
				map.put("dateRange",dateRange);
				Report.print(Factory.getInstance().getUserInfo(), "RptWeekBill_xls",
						map,
						new String[] {"rptNameWDate",startDate},
						new String[] {"PATNO","SLPNO","PATNAME",
								"PATFNAME","BEDCODE","TITDESC","REGDATE",
								"SLPTYPE","ARCODE","OUTAMT"},
								true,
								null,
								null,
								"RptWeekBill_xls"+startDate.replaceAll("/", ""),
								false);
			}

			// Cover Letter
			if (getCoverLetter().isSelected()) {
				map.put("printDate",dateRange);
				System.err.println("[getCoverLetter][slipno]:"+getPatientCode().getText()+";[startDate]:"+startDate);
				PrintingUtil.print("DEFAULT","DAYENDCOVERLETTER",map,"",
						new String[] {startDate},
						new String[] {"ALLSLPNO", "DSLP.PATNO", "PATNAME",
						"PATFNAME", "BEDCODE", "PATTITLE", "AMT", "PRINTDATE",
						"FROMDATE","TODATE"});
			}

			if (getIPStatmentWB().isSelected()) {
				System.err.println("[getIPStatmentWB][slipno]:"+getPatientCode().getText()+";[startDate]:"+startDate);
				/*
				PrintingUtil.print("IPStatementWB",map,"",
						new String[] {getPatientCode().getText()},
						new String[] {"PATNAME", "PATCNAME", "SLPNO", "PATNO",
						"REGDATE", "REGTIME", "BEDACM", "INPDDATE",
						"INPDTIME", "DOCNAME", "DOCCNAME"});
*/
				Map<String,String> mapWB = new HashMap<String,String>();
				mapWB.put("SUBREPORT_DIR", CommonUtil.getReportDir());
				mapWB.put("DOCBKGCPY",Factory.getInstance().getSysParameter("DOCBKGCPY"));
				mapWB.put("watermark", CommonUtil.getReportImg("copy_watermark.gif"));
				mapWB.put("ALLSLPNO",getPatientCode().getText());

				Factory.getInstance()
				.addRequiredReportDesc(mapWB,
							new String[] {
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage"
							},
							new String[] {
									"StaOfAut", "AdmDtTime", "PatName",
									"DisDtTime", "TreDr", "BillNo",
									"PatNo", "BedNo", "Copy", "Page",
									"Date", "Item", "Amount", "TotChg",
									"TotRfd", "Balance", "Credits", "StatBalance", "BalanceFwd"
							},
							"CTE");

				PrintingUtil.print("DEFAULT", "IPStatementWB", mapWB, null,
						new String[] {
									getPatientCode().getText(), startDate

						},
						new String[] {
								"PATNAME", "PATCNAME", "SLPNO", "PATNO",
								"REGDATE", "REGTIME", "BEDACM", "INPDDATE",
								"INPDTIME", "DOCNAME", "DOCCNAME", "FROM_WBDATE",
								"TO_WBDATE"
						}, 3,
						new String[] {
								"IPStatementWB_Sub4",
								"IPStatementWB_Sub1",
								"IPStatementWB_Sub3"
						},
						new String[][] {
								{
									getPatientCode().getText(), startDate
								},
								{
									getPatientCode().getText(), startDate
								},
								{
									getPatientCode().getText(), startDate
								}
						},
						new String[][] {
								{
										"STNTDATE", "AMOUNT" ,"DESCRIPTION", "QTY","CDESCCODE"
								},
								{
										"STNTDATE", "AMOUNT" ,"DESCRIPTION", "QTY",
										"TOTALREFUND", "TOTALCHARGE", "CDESCCODE"
								},
								{
										"STNTDATE", "AMOUNT" ,"DESCRIPTION", "QTY","CDESCCODE"
								}
						},
						new boolean[][] {
								{
										false, true, false, true, false
								},
								{
										false, true, false, true, true, true, false
								},
								{
										false, true, false, true, false
								}
						}, 1, Factory.getInstance().getSysParameter("IpPageSize"));
			}
		}
	}

	public BasePanel getButtonPanel() {
		if (ButtonPanel == null) {
			ButtonPanel = new BasePanel();
			ButtonPanel.add(getARLetters());
			ButtonPanel.add(getFGLetters());
			ButtonPanel.add(getPRLetters());
		}
		return ButtonPanel;
	}

	public ButtonBase getARLetters() {
		if (ARLetters == null) {
			ARLetters = new ButtonBase();
			ARLetters.setText("AR Reminding Letters");
			ARLetters.setBounds(200, 450, 165, 25);
		}
		return ARLetters;
	}

	public ButtonBase getFGLetters() {
		if (FGLetters == null) {
			FGLetters = new ButtonBase();
			FGLetters.setText("Further Guarantee Letters");
			FGLetters.setBounds(375, 450, 199, 25);
		}
		return FGLetters;
	}

	public ButtonBase getPRLetters() {
		if (PRLetters == null) {
			PRLetters = new ButtonBase();
			PRLetters.setText("Patient Reminding Letters");
			PRLetters.setBounds(585, 450, 193, 25);
		}
		return PRLetters;
	}
}
