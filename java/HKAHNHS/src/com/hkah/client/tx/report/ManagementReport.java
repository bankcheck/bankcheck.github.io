package com.hkah.client.tx.report;

import java.util.HashMap;
import java.util.Map;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.util.Rectangle;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.MessageBox;
import com.hkah.client.common.Factory;
import com.hkah.client.event.CallbackListener;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboDocCode;
import com.hkah.client.layout.combobox.ComboSickCode;
import com.hkah.client.layout.combobox.ComboSiteType;
import com.hkah.client.layout.dialog.DlgDocFeeRpt;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextItemCodeSearch;
import com.hkah.client.layout.textfield.TextPackageCodeSearch;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.ActionPanel;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.Report;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsProperties;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class ManagementReport extends ActionPanel {

	private static final long serialVersionUID = 1L;

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.MANAGEMENTREPORT_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.MANAGEMENTREPORT_TITLE;
	}

	private BasePanel actionPanel = null;

	private BasePanel CheckBoxPanel = null;
	private LabelBase BOOBUBDesc = null;
	private CheckBoxBase BOOBUB = null;
	private LabelBase CADesc = null;
	private CheckBoxBase CA = null;
	private LabelBase DAnewDesc = null;
	private CheckBoxBase DAnew = null;
	private LabelBase DAoldDesc = null;
	private CheckBoxBase DAold = null;
	private LabelBase DSHRBPDesc = null;
	private CheckBoxBase DSHRBP = null;
	private LabelBase DSHSCDesc = null;
	private CheckBoxBase DSHSC = null;
	private LabelBase DTSDesc = null;
	private CheckBoxBase DTS = null;
	private LabelBase RMMDesc = null;
	private CheckBoxBase RMM = null;
	private LabelBase FILchgDesc = null;
	private CheckBoxBase FILchg = null;
	private LabelBase FILCrdDesc = null;
	private CheckBoxBase FILCrd = null;
	private LabelBase FPLchgDesc = null;
	private CheckBoxBase FPLchg = null;
	private LabelBase FPLCrdDesc = null;
	private CheckBoxBase FPLCrd = null;
	private LabelBase IDCGCDesc = null;
	private CheckBoxBase IDCGC = null;
	private LabelBase LCDesc = null;
	private CheckBoxBase LC = null;
	private LabelBase MIPSADesc = null;
	private CheckBoxBase MIPSA = null;
	private LabelBase MIPSA06Desc = null;
	private CheckBoxBase MIPSA06 = null;
	private LabelBase OSTTFADesc = null;
	private CheckBoxBase OSTTFA = null;
	private LabelBase OFRDDesc = null;
	private CheckBoxBase OFRD = null;
	private LabelBase PPPDesc = null;
	private CheckBoxBase PPP = null;
	private LabelBase PDDesc = null;
	private CheckBoxBase PD = null;
	private LabelBase RARDesc = null;
	private CheckBoxBase RAR = null;
	private LabelBase RAnewDesc = null;
	private CheckBoxBase RAnew = null;
	private LabelBase RAoldDesc = null;
	private CheckBoxBase RAold = null;
	private LabelBase TDDesc = null;
	private CheckBoxBase TD = null;
	private LabelBase ItemDesc = null;
	private CheckBoxBase Item = null;
	private LabelBase PackageDesc = null;
	private CheckBoxBase Package = null;
	private LabelBase ItemChargeDesc = null;
	private CheckBoxBase ItemCharge = null;

	private BasePanel TextPanel = null;
	private LabelBase DateRangeStartDesc = null;
	private TextDate DateRangeStart = null;
	private LabelBase DateRangeEndDesc = null;
	private TextDate DateRangeEnd = null;
	private LabelBase SiteCodeDesc = null;
	private ComboSiteType SiteCode = null;
	private LabelBase ItemGroupDesc = null;
	private TextString ItemGroup = null;
	private LabelBase DoctorDesc = null;
	private ComboDocCode Doctor = null;
	private LabelBase SickCodeDesc = null;
	private ComboSickCode SickCode = null;
	private LabelBase ReadmitDayDesc = null;
	private TextString ReadmitDay = null;
	private ButtonBase btnOpenDoctorFee = null;
	private DlgDocFeeRpt dlgDocFeeRpt = null;
	private LabelBase CashIDDesc = null;
	private TextString CashID = null;
	private LabelBase DoctorCodeDesc = null;
	private TextString DoctorCode = null;
	private LabelBase PatientCodeDesc = null;
	private TextString PatientCode = null;
	private LabelBase ItemCodeDesc = null;
	private TextItemCodeSearch ItemCode = null;
	private LabelBase PackageCodeDesc = null;
	private TextPackageCodeSearch PackageCode = null;
	private LabelBase PercentDesc = null;
	private TextString Percent = null;
	private LabelBase PrinttoFileDesc = null;
	private CheckBoxBase PrinttoFile = null;
	private LabelBase PrinttoScreenDesc = null;
	private CheckBoxBase PrinttoScreen = null;
	private LabelBase SelectPrinterDesc = null;
	private CheckBoxBase SelectPrinter = null;
	private LabelBase ReprintDesc = null;
	private CheckBoxBase Reprint = null;
	private ButtonBase NewDoctor = null;
	private ButtonBase NewDoctorExp = null;
	private ButtonBase NewDoctorRpt2 = null;
	private ButtonBase Specialcom = null;
	private ButtonBase Reprintrpt = null;

	private String docFeeMode = null;
	private boolean memIsConfirm = false;
	private boolean isTxListDone = false;
	private boolean isPayableDone = false;
	private boolean isDetail2Done = false;
	private boolean isSummary2Done = false;
	public static final String C_STAGE_9 = "90";
	public static final String C_STAGE_10 = "100";
	public static final String NEWDOCFEE = "NEWDOCFEE";
	public static final String NEWDOCFEE_EXP = "NEWDOCFEE_EXP";
	public static final String DOCFEE2 = "DOCFEE2";

	/**
	 * This method initializes
	 * 
	 */
	public ManagementReport() {
		super();
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {

		setAllAvailEnable(false);
		
		getCADesc().setEnabled(!isDisableFunction("chkRptCshrAudit", "rptManagement"));
		getCA().setEnabled(!isDisableFunction("chkRptCshrAudit", "rptManagement"));
		getRMMDesc().setEnabled(!isDisableFunction("chkRegMainLandMaterPatLst", "rptManagement"));
		getRMM().setEnabled(!isDisableFunction("chkRegMainLandMaterPatLst", "rptManagement"));
		getMIPSADesc().setEnabled(!isDisableFunction("chkRptIPStatAnalysis", "rptManagement"));
		getMIPSA().setEnabled(!isDisableFunction("chkRptIPStatAnalysis", "rptManagement"));
		getMIPSA06Desc().setEnabled(!isDisableFunction("chkRptIPStatAnalysis2006","rptManagement"));
		getMIPSA06().setEnabled(!isDisableFunction("chkRptIPStatAnalysis2006","rptManagement"));
		getOFRDDesc().setEnabled(!isDisableFunction("chkRptOverrideFeeDisc", "rptManagement"));
		getOFRD().setEnabled(!isDisableFunction("chkRptOverrideFeeDisc", "rptManagement"));
		getPDDesc().setEnabled(!isDisableFunction("chkRptPayDetail", "rptManagement"));
		getPD().setEnabled(!isDisableFunction("chkRptPayDetail", "rptManagement"));
		getRARDesc().setEnabled(!isDisableFunction("chkRptReAdmiss", "rptManagement"));
		getRAR().setEnabled(!isDisableFunction("chkRptReAdmiss", "rptManagement"));
		getTDDesc().setEnabled(!isDisableFunction("chkRptTranDtl", "rptManagement"));
		getTD().setEnabled(!isDisableFunction("chkRptTranDtl", "rptManagement"));
		getBtnOpenDoctorFee().setEnabled(!isDisableFunction("chkBtnDocFeeRpt", "rptManagement"));
		getNewDoctor().setEnabled(!isDisableFunction("chkBtnNewDocFee", "rptManagement"));
		getNewDoctorExp().setEnabled(!isDisableFunction("chkBtnNewFeeExcept", "rptManagement"));
		getNewDoctorRpt2().setEnabled(!isDisableFunction("chkBtnDocFeeRpt2", "rptManagement"));
		

		getItem().setEnabled(!isDisableFunction("btnPrintLst", "admPrint"));
		getItemDesc().setEnabled(!isDisableFunction("btnPrintLst", "admPrint"));
		getPackage().setEnabled(!isDisableFunction("btnPrintLst", "admPrint"));
		getPackageDesc().setEnabled(!isDisableFunction("btnPrintLst", "admPrint"));
		getItemCharge().setEnabled(!isDisableFunction("btnPrintLst", "admPrint"));
		getItemChargeDesc().setEnabled(!isDisableFunction("btnPrintLst", "admPrint"));

		// reports are not in use
		getBOOBUBDesc().setEnabled(false);
		getBOOBUB().setEnabled(false);
		getDAnewDesc().setEnabled(false);
		getDAnew().setEnabled(false);
		getDAoldDesc().setEnabled(false);
		getDAold().setEnabled(false);
		getDSHRBPDesc().setEnabled(false);
		getDSHRBP().setEnabled(false);
		getDSHSCDesc().setEnabled(false);
		getDSHSC().setEnabled(false);
		getDTSDesc().setEnabled(false);
		getDTS().setEnabled(false);
		getFILchgDesc().setEnabled(false);
		getFILchg().setEnabled(false);
		getFILCrdDesc().setEnabled(false);
		getFILCrd().setEnabled(false);
		getFPLchgDesc().setEnabled(false);
		getFPLchg().setEnabled(false);
		getFPLCrdDesc().setEnabled(false);
		getFPLCrd().setEnabled(false);
		getIDCGCDesc().setEnabled(false);
		getIDCGC().setEnabled(false);
		getLCDesc().setEnabled(false);
		getLC().setEnabled(false);
		getOSTTFADesc().setEnabled(false);
		getOSTTFA().setEnabled(false);
		getPPPDesc().setEnabled(false);
		getPPP().setEnabled(false);
		getRAnewDesc().setEnabled(false);
		getRAnew().setEnabled(false);
		getRAoldDesc().setEnabled(false);
		getRAold().setEnabled(false);
		getSpecialcom().setEnabled(false);
		getReprintrpt().setEnabled(false);
	}
	
	private void setAllAvailEnable(boolean enable) {
				getCA().setEnabled(enable);
				getRMM().setEnabled(enable);
				getMIPSA().setEnabled(enable);
				getMIPSA06().setEnabled(enable);
				getOFRD().setEnabled(enable);
				getPD().setEnabled(enable);
				getRAR().setEnabled(enable);
				getTD().setEnabled(enable);
				getBtnOpenDoctorFee().setEnabled(enable);
				getNewDoctor().setEnabled(enable);
				getNewDoctorExp().setEnabled(enable);
				getNewDoctorRpt2().setEnabled(enable);                
				getLC().setEnabled(enable);
				getRAR().setEnabled(enable);
				getRAnew().setEnabled(enable);				                    
				getItem().setEnabled(enable);
				getItemDesc().setEnabled(enable);
				getPackage().setEnabled(enable);
				getItemCharge().setEnabled(enable);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return null;// getBOOBUB();
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
		return null;
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {}

	/* >>> ~15~ Set Fetch Output Results ============================== <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return null;
	}

	/* >>> ~16.1~ Set Action Output Parameters =========================== <<< */
	@Override
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
	 * ButtonBase Action Methods
	 **************************************************************************/

	@Override
	protected BasePanel getActionPanel() {
		if (actionPanel == null) {
			actionPanel = new BasePanel();
			actionPanel.setSize(779, 505);
			actionPanel.add(getTextPanel(), null);
			actionPanel.add(getCheckBoxPanel(), null);
		}
		return actionPanel;
	}

	public BasePanel getCheckBoxPanel() {
		if (CheckBoxPanel == null) {
			CheckBoxPanel = new BasePanel();
			CheckBoxPanel.setBorders(true);
			CheckBoxPanel.add(getBOOBUBDesc(), null);
			CheckBoxPanel.add(getBOOBUB(), null);
			CheckBoxPanel.add(getCADesc(), null);
			CheckBoxPanel.add(getCA(), null);
			CheckBoxPanel.add(getDAnewDesc(), null);
			CheckBoxPanel.add(getDAnew(), null);
			CheckBoxPanel.add(getDAoldDesc(), null);
			CheckBoxPanel.add(getDAold(), null);
			CheckBoxPanel.add(getDSHRBPDesc(), null);
			CheckBoxPanel.add(getDSHRBP(), null);
			CheckBoxPanel.add(getDSHSCDesc(), null);
			CheckBoxPanel.add(getDSHSC(), null);
			CheckBoxPanel.add(getDTSDesc(), null);
			CheckBoxPanel.add(getDTS(), null);
			CheckBoxPanel.add(getRMMDesc(), null);
			CheckBoxPanel.add(getRMM(), null);
			CheckBoxPanel.add(getFILchgDesc(), null);
			CheckBoxPanel.add(getFILchg(), null);
			CheckBoxPanel.add(getFILCrdDesc(), null);
			CheckBoxPanel.add(getFILCrd(), null);
			CheckBoxPanel.add(getFPLchgDesc(), null);
			CheckBoxPanel.add(getFPLchg(), null);
			CheckBoxPanel.add(getFPLCrdDesc(), null);
			CheckBoxPanel.add(getFPLCrd(), null);
			CheckBoxPanel.add(getIDCGCDesc(), null);
			CheckBoxPanel.add(getIDCGC(), null);
			CheckBoxPanel.add(getLCDesc(), null);
			CheckBoxPanel.add(getLC(), null);
			CheckBoxPanel.add(getMIPSADesc(), null);
			CheckBoxPanel.add(getMIPSA(), null);
			CheckBoxPanel.add(getMIPSA06Desc(), null);
			CheckBoxPanel.add(getMIPSA06(), null);
			CheckBoxPanel.add(getOSTTFADesc(), null);
			CheckBoxPanel.add(getOSTTFA(), null);
			CheckBoxPanel.add(getOFRDDesc(), null);
			CheckBoxPanel.add(getOFRD(), null);
			CheckBoxPanel.add(getPPPDesc(), null);
			CheckBoxPanel.add(getPPP(), null);
			CheckBoxPanel.add(getPDDesc(), null);
			CheckBoxPanel.add(getPD(), null);
			CheckBoxPanel.add(getRARDesc(), null);
			CheckBoxPanel.add(getRAR(), null);
			CheckBoxPanel.add(getRAnewDesc(), null);
			CheckBoxPanel.add(getRAnew(), null);
			CheckBoxPanel.add(getRAoldDesc(), null);
			CheckBoxPanel.add(getRAold(), null);
			CheckBoxPanel.add(getTDDesc(), null);
			CheckBoxPanel.add(getTD(), null);
			CheckBoxPanel.add(getItemDesc(), null);
			CheckBoxPanel.add(getItem(), null);
			CheckBoxPanel.add(getPackageDesc(), null);
			CheckBoxPanel.add(getPackage(), null);
			CheckBoxPanel.add(getItemChargeDesc(), null);
			CheckBoxPanel.add(getItemCharge(), null);
			CheckBoxPanel.setLocation(5, 24);
			CheckBoxPanel.setSize(790, 284);
		}
		return CheckBoxPanel;
	}

	public LabelBase getBOOBUBDesc() {
		if (BOOBUBDesc == null) {
			BOOBUBDesc = new LabelBase();
			BOOBUBDesc.setText("Bed Occupancy Official Bed/Unofficial Bed");
			BOOBUBDesc.setBounds(34, 10, 234, 20);
		}
		return BOOBUBDesc;
	}

	public CheckBoxBase getBOOBUB() {
		if (BOOBUB == null) {
			BOOBUB = new CheckBoxBase();
			BOOBUB.setBounds(10, 10, 23, 20);
		}
		return BOOBUB;
	}

	public LabelBase getCADesc() {
		if (CADesc == null) {
			CADesc = new LabelBase();
			CADesc.setText("Cashier Audit Report");
			CADesc.setBounds(34, 40, 224, 20);
		}
		return CADesc;
	}

	public CheckBoxBase getCA() {
		if (CA == null) {
			CA = new CheckBoxBase();
			CA.setBounds(10, 40, 23, 20);
		}
		return CA;
	}

	public LabelBase getDAnewDesc() {
		if (DAnewDesc == null) {
			DAnewDesc = new LabelBase();
			DAnewDesc.setText("Disease Analysis [to-Government (new)");
			DAnewDesc.setBounds(34, 70, 224, 20);
		}
		return DAnewDesc;
	}

	public CheckBoxBase getDAnew() {
		if (DAnew == null) {
			DAnew = new CheckBoxBase();
			DAnew.setBounds(10, 70, 23, 20);
		}
		return DAnew;
	}

	public LabelBase getDAoldDesc() {
		if (DAoldDesc == null) {
			DAoldDesc = new LabelBase();
			DAoldDesc.setText("Disease Analysis [to-Government (old)]");
			DAoldDesc.setBounds(34, 100, 224, 20);
		}
		return DAoldDesc;
	}

	public CheckBoxBase getDAold() {
		if (DAold == null) {
			DAold = new CheckBoxBase();
			DAold.setBounds(10, 100, 23, 20);
		}
		return DAold;
	}
	public LabelBase getDSHRBPDesc() {
		if (DSHRBPDesc == null) {
			DSHRBPDesc = new LabelBase();
			DSHRBPDesc.setText("Doctor Swap History Report-By Patient");
			DSHRBPDesc.setBounds(34, 130, 224, 20);
		}
		return DSHRBPDesc;
	}

	public CheckBoxBase getDSHRBP() {
		if (DSHRBP == null) {
			DSHRBP = new CheckBoxBase();
			DSHRBP.setBounds(10, 130, 23, 20);
		}
		return DSHRBP;
	}

	public LabelBase getDSHSCDesc() {
		if (DSHSCDesc == null) {
			DSHSCDesc = new LabelBase();
			DSHSCDesc.setText("Doctor Swap History-Summary Count");
			DSHSCDesc.setBounds(34, 160, 224, 20);
		}
		return DSHSCDesc;
	}

	public CheckBoxBase getDSHSC() {
		if (DSHSC == null) {
			DSHSC = new CheckBoxBase();
			DSHSC.setBounds(10, 160, 23, 20);
		}
		return DSHSC;
	}

	public LabelBase getDTSDesc() {
		if (DTSDesc == null) {
			DTSDesc = new LabelBase();
			DTSDesc.setText("Doctor Treatment Summary");
			DTSDesc.setBounds(34, 190, 224, 20);
		}
		return DTSDesc;
	}

	public CheckBoxBase getDTS() {
		if (DTS == null) {
			DTS = new CheckBoxBase();
			DTS.setBounds(10, 190, 23, 20);
		}
		return DTS;
	}

	public LabelBase getRMMDesc() {
		if (RMMDesc == null) {
			RMMDesc = new LabelBase();
			RMMDesc.setText("Registered Maintand Maternity");
			RMMDesc.setBounds(34, 220, 224, 20);
		}
		return RMMDesc;
	}

	public CheckBoxBase getRMM() {
		if (RMM == null) {
			RMM = new CheckBoxBase();
			RMM.setBounds(10, 220, 23, 20);
		}
		return RMM;
	}

	public LabelBase getFILchgDesc() {
		if (FILchgDesc == null) {
			FILchgDesc = new LabelBase();
			FILchgDesc.setText("Fee Item [Charge] List");
			FILchgDesc.setBounds(new Rectangle(294, 10, 232, 20));
		}
		return FILchgDesc;
	}

	public CheckBoxBase getFILchg() {
		if (FILchg == null) {
			FILchg = new CheckBoxBase();
			FILchg.setBounds(new Rectangle(271, 10, 23, 20));
		}
		return FILchg;
	}

	public LabelBase getFILCrdDesc() {
		if (FILCrdDesc == null) {
			FILCrdDesc = new LabelBase();
			FILCrdDesc.setText("Fee Item [Credit] List");
			FILCrdDesc.setBounds(new Rectangle(294, 40, 232, 20));
		}
		return FILCrdDesc;
	}

	public CheckBoxBase getFILCrd() {
		if (FILCrd == null) {
			FILCrd = new CheckBoxBase();
			FILCrd.setBounds(new Rectangle(271, 40, 23, 20));
		}
		return FILCrd;
	}

	public LabelBase getFPLchgDesc() {
		if (FPLchgDesc == null) {
			FPLchgDesc = new LabelBase();
			FPLchgDesc.setText("Fee Package [Charge] List");
			FPLchgDesc.setBounds(294, 71, 232, 20);
		}
		return FPLchgDesc;
	}

	public CheckBoxBase getFPLchg() {
		if (FPLchg == null) {
			FPLchg = new CheckBoxBase();
			FPLchg.setBounds(271, 71, 23, 20);
		}
		return FPLchg;
	}

	public LabelBase getFPLCrdDesc() {
		if (FPLCrdDesc == null) {
			FPLCrdDesc = new LabelBase();
			FPLCrdDesc.setText("Fee Package [Credit] List");
			FPLCrdDesc.setBounds(294, 101, 232, 20);
		}
		return FPLCrdDesc;
	}

	public CheckBoxBase getFPLCrd() {
		if (FPLCrd == null) {
			FPLCrd = new CheckBoxBase();
			FPLCrd.setBounds(271, 101, 23, 20);
		}
		return FPLCrd;
	}

	public LabelBase getIDCGCDesc() {
		if (IDCGCDesc == null) {
			IDCGCDesc = new LabelBase();
			IDCGCDesc.setText("IP Day Count-Government Census");
			IDCGCDesc.setBounds(294, 131, 232, 20);
		}
		return IDCGCDesc;
	}

	public CheckBoxBase getIDCGC() {
		if (IDCGC == null) {
			IDCGC = new CheckBoxBase();
			IDCGC.setBounds(271, 131, 23, 20);
		}
		return IDCGC;
	}

	public LabelBase getLCDesc() {
		if (LCDesc == null) {
			LCDesc = new LabelBase();
			LCDesc.setText("Location Census");
			LCDesc.setBounds(294, 161, 232, 20);
		}
		return LCDesc;
	}

	public CheckBoxBase getLC() {
		if (LC == null) {
			LC = new CheckBoxBase();
			LC.setBounds(271, 161, 23, 20);
		}
		return LC;
	}

	public LabelBase getMIPSADesc() {
		if (MIPSADesc == null) {
			MIPSADesc = new LabelBase();
			MIPSADesc.setText("Monthly In-Patients Statistical Analysis");
			MIPSADesc.setBounds(294, 191, 232, 20);
		}
		return MIPSADesc;
	}

	public CheckBoxBase getMIPSA() {
		if (MIPSA == null) {
			MIPSA = new CheckBoxBase();
			MIPSA.setBounds(271, 191, 23, 20);
		}
		return MIPSA;
	}

	public LabelBase getMIPSA06Desc() {
		if (MIPSA06Desc == null) {
			MIPSA06Desc = new LabelBase();
			MIPSA06Desc.setText("Monthly In-Patients Statistical Analysis 2006");
			MIPSA06Desc.setBounds(294, 221, 245, 20);
		}
		return MIPSA06Desc;
	}

	public CheckBoxBase getMIPSA06() {
		if (MIPSA06 == null) {
			MIPSA06 = new CheckBoxBase();
			MIPSA06.setBounds(271, 221, 23, 20);
		}
		return MIPSA06;
	}

	public LabelBase getOSTTFADesc() {
		if (OSTTFADesc == null) {
			OSTTFADesc = new LabelBase();
			OSTTFADesc.setText("OP Status Type Time Frame Analysis");
			OSTTFADesc.setBounds(559, 10, 210, 20);
		}
		return OSTTFADesc;
	}

	public CheckBoxBase getOSTTFA() {
		if (OSTTFA == null) {
			OSTTFA = new CheckBoxBase();
			OSTTFA.setBounds(537, 10, 23, 20);
		}
		return OSTTFA;
	}

	public LabelBase getOFRDDesc() {
		if (OFRDDesc == null) {
			OFRDDesc = new LabelBase();
			OFRDDesc.setText("Override Fee Report - Discount");
			OFRDDesc.setBounds(559, 40, 197, 20);
		}
		return OFRDDesc;
	}

	public CheckBoxBase getOFRD() {
		if (OFRD == null) {
			OFRD = new CheckBoxBase();
			OFRD.setBounds(537, 40, 23, 20);
		}
		return OFRD;
	}

	public LabelBase getPPPDesc() {
		if (PPPDesc == null) {
			PPPDesc = new LabelBase();
			PPPDesc.setText("Package Performance Report");
			PPPDesc.setBounds(559, 71, 197, 20);
		}
		return PPPDesc;
	}

	public CheckBoxBase getPPP() {
		if (PPP == null) {
			PPP = new CheckBoxBase();
			PPP.setBounds(537, 71, 23, 20);
		}
		return PPP;
	}

	public LabelBase getPDDesc() {
		if (PDDesc == null) {
			PDDesc = new LabelBase();
			PDDesc.setText("Payment Detail");
			PDDesc.setBounds(559, 101, 197, 20);
		}
		return PDDesc;
	}

	public CheckBoxBase getPD() {
		if (PD == null) {
			PD = new CheckBoxBase();
			PD.setBounds(537, 101, 23, 20);
		}
		return PD;
	}

	public LabelBase getRARDesc() {
		if (RARDesc == null) {
			RARDesc = new LabelBase();
			RARDesc.setText("Re-Admission Report");
			RARDesc.setBounds(559, 131, 197, 20);
		}
		return RARDesc;
	}

	public CheckBoxBase getRAR() {
		if (RAR == null) {
			RAR = new CheckBoxBase();
			RAR.setBounds(537, 131, 23, 20);
		}
		return RAR;
	}

	public LabelBase getRAnewDesc() {
		if (RAnewDesc == null) {
			RAnewDesc = new LabelBase();
			RAnewDesc.setText("Reason Analysis [to Government (new)]");
			RAnewDesc.setBounds(559, 161, 225, 20);
		}
		return RAnewDesc;
	}

	public CheckBoxBase getRAnew() {
		if (RAnew == null) {
			RAnew = new CheckBoxBase();
			RAnew.setBounds(537, 161, 23, 20);
		}
		return RAnew;
	}

	public LabelBase getRAoldDesc() {
		if (RAoldDesc == null) {
			RAoldDesc = new LabelBase();
			RAoldDesc.setText("Reason Analysis [to Government (old)]");
			RAoldDesc.setBounds(559, 191, 215, 20);
		}
		return RAoldDesc;
	}

	public CheckBoxBase getRAold() {
		if (RAold == null) {
			RAold = new CheckBoxBase();
			RAold.setBounds(537, 191, 23, 20);
		}
		return RAold;
	}

	public LabelBase getTDDesc() {
		if (TDDesc == null) {
			TDDesc = new LabelBase();
			TDDesc.setText("Transaction Detail");
			TDDesc.setBounds(559, 221, 197, 20);
		}
		return TDDesc;
	}

	public CheckBoxBase getTD() {
		if (TD == null) {
			TD = new CheckBoxBase();
			TD.setBounds(537, 221, 23, 20);
		}
		return TD;
	}

	public LabelBase getItemDesc() {
		if (ItemDesc == null) {
			ItemDesc = new LabelBase();
			ItemDesc.setText("Item List (Print to file only)");
			ItemDesc.setBounds(34, 250, 224, 20);

		}
		return ItemDesc;
	}

	public CheckBoxBase getItem() {
		if (Item == null) {
			Item = new CheckBoxBase();
			Item.setBounds(10, 250, 23, 20);
		}
		return Item;
	}

	public LabelBase getPackageDesc() {
		if (PackageDesc == null) {
			PackageDesc = new LabelBase();
			PackageDesc.setText("Package List (Print to file only)");
			PackageDesc.setBounds(294, 250, 224, 20);

		}
		return PackageDesc;
	}

	public CheckBoxBase getPackage() {
		if (Package == null) {
			Package = new CheckBoxBase();
			Package.setBounds(271, 250, 23, 20);
		}
		return Package;
	}

	public LabelBase getItemChargeDesc() {
		if (ItemChargeDesc == null) {
			ItemChargeDesc = new LabelBase();
			ItemChargeDesc.setText("Item Charge List (Print to file only)");
			ItemChargeDesc.setBounds(559, 250, 224, 20);

		}
		return ItemChargeDesc;
	}

	public CheckBoxBase getItemCharge() {
		if (ItemCharge == null) {
			ItemCharge = new CheckBoxBase();
			ItemCharge.setBounds(537, 250, 23, 20);
		}
		return ItemCharge;
	}

	@Override
	public void rePostAction() {

	}

	private boolean validatePrintAction() {
		if (!getDateRangeStart().isEmpty() && !getDateRangeStart().isValid()) {
			Factory.getInstance().addErrorMessage(
					ConstantsMessage.MSG_ERR_INVALIDDATE + "Start Date.",
					getDateRangeStart());
			return false;
		}
		if (!getDateRangeEnd().isEmpty() && !getDateRangeEnd().isValid()) {
			Factory.getInstance().addErrorMessage(
					ConstantsMessage.MSG_ERR_INVALIDDATE + "End Date.",
					getDateRangeEnd());
			return false;
		}

		boolean error = false;
		StringBuffer sb = new StringBuffer();

		if (getBOOBUB().isSelected()) {
			if (getSiteCode().getText().trim().length() == 0
					|| !getSiteCode().isValid()
					|| getDateRangeStart().isEmpty()
					|| getDateRangeEnd().isEmpty()) {
				error = true;
				sb.append("Fail to print: Bed Occupancy (rptBedSmy)<br/><br/>");
			}

			if (getSiteCode().getText().trim().length() == 0
					|| !getSiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
			if (getDateRangeStart().isEmpty()) {
				sb.append("Please supply Start Date.<br/>");
			}
			if (getDateRangeEnd().isEmpty()) {
				sb.append("Please supply End Date.<br/>");
			}
		}

		if (getCA().isSelected()) {
			if (error) {
				sb.append("<br/><br/>");
			}

			if (getSiteCode().getText().trim().length() == 0
					|| !getSiteCode().isValid()
					|| getDateRangeStart().isEmpty()
					|| getDateRangeEnd().isEmpty()
					|| getCashID().getText().isEmpty()) {
				error = true;
				sb.append("Fail to print: Cashier Audit Report (rptCshrAudit)<br/><br/>");
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
			if (getCashID().getText().isEmpty()) {
				sb.append("Please supply Cashier ID.<br/>");
			}
		}

		// Override Fee Discount Report
		if (getOFRD().isSelected()) {
			if (getSiteCode().getText().trim().length() == 0
					|| !getSiteCode().isValid()
					|| getDateRangeStart().isEmpty()
					|| getDateRangeEnd().isEmpty()) {
				error = true;
				sb.append("Fail to print: Override Fee Discount Report (RptOverrideFeeDisc)<br/><br/>");
			}

			if (getSiteCode().getText().trim().length() == 0
					|| !getSiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
			if (getDateRangeStart().isEmpty()) {
				sb.append("Please supply Start Date.<br/>");
			}
			if (getDateRangeEnd().isEmpty()) {
				sb.append("Please supply End Date.<br/>");
			}
		}

		// Payment Detail Report
		if (getPD().isSelected()) {
			if (getSiteCode().getText().trim().length() == 0
					|| !getSiteCode().isValid()
					|| getDateRangeStart().isEmpty()
					|| getDateRangeEnd().isEmpty()) {
				error = true;
				sb.append("Fail to print: Payment Detail Report (RPTPAYDETAIL)<br/><br/>");
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

		// Re-Admission Report
		if (getRAR().isSelected()) {
			if (getSiteCode().getText().trim().length() == 0
					|| !getSiteCode().isValid()
					|| getDateRangeStart().isEmpty()
					|| getDateRangeEnd().isEmpty()) {
				error = true;
				sb.append("Fail to print: Re-Admission Report (RPTREADMISS)<br/><br/>");
			}

			if (getSiteCode().getText().trim().length() == 0
					|| !getSiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
			if (getDateRangeStart().isEmpty()) {
				sb.append("Please supply Start Date.<br/>");
			}
			if (getDateRangeEnd().isEmpty()) {
				sb.append("Please supply End Date.<br/>");
			}
			if (getDoctorCode().getText().trim().isEmpty()) {
				sb.append("Please select Doctor Option.<br/>");
			}
			if (getSickCode().getText().trim().isEmpty()) {
				sb.append("Please select Sick Code Option<br/>");
			}
			if (getReadmitDay().isEmpty()) {
				sb.append("Please supply Readmit Day.<br/>");
			}
		}

		// Transaction Detail
		if (getTD().isSelected()) {
			if (getSiteCode().getText().trim().length() == 0
					|| !getSiteCode().isValid()
					|| getDateRangeStart().isEmpty()
					|| getDateRangeEnd().isEmpty()) {
				error = true;
				sb.append("Fail to print: Transaction Detail Report (RPTTRANDTL)<br/><br/>");
			}

			if (getSiteCode().getText().trim().length() == 0
					|| !getSiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
			if (getDateRangeStart().isEmpty()) {
				sb.append("Please supply Start Date.<br/>");
			}
			if (getDateRangeEnd().isEmpty()) {
				sb.append("Please supply End Date.<br/>");
			}
		}

		// Registered Maintand Maternity
		if (getRMM().isSelected()) {
			if (getSiteCode().getText().trim().length() == 0
					|| !getSiteCode().isValid()
					|| getDateRangeStart().isEmpty()
					|| getDateRangeEnd().isEmpty()) {
				error = true;
				sb.append("Fail to print: Registered Maintand Maternity (RegMainLandMaterPatLst)<br/><br/>");
			}

			if (getSiteCode().getText().trim().length() == 0
					|| !getSiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
			if (getDateRangeStart().isEmpty()) {
				sb.append("Please supply Start Date.<br/>");
			}
			if (getDateRangeEnd().isEmpty()) {
				sb.append("Please supply End Date.<br/>");
			}
		}

		// Monthly In-Patients Statistical Analysis
		if (getMIPSA().isSelected()) {
			if (getSiteCode().getText().trim().length() == 0
					|| !getSiteCode().isValid()
					|| getDateRangeStart().isEmpty()
					|| getDateRangeEnd().isEmpty()) {
				error = true;
				sb.append("Fail to print: Monthly In-Patients Statistical Analysis (RptIPStatAnalysis)<br/><br/>");
			}

			if (getSiteCode().getText().trim().length() == 0
					|| !getSiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
			if (getDateRangeStart().isEmpty()) {
				sb.append("Please supply Start Date.<br/>");
			}
			if (getDateRangeEnd().isEmpty()) {
				sb.append("Please supply End Date.<br/>");
			}
		}

		if (getMIPSA06().isSelected()) {
			if (getSiteCode().getText().trim().length() == 0
					|| !getSiteCode().isValid()
					|| getDateRangeStart().isEmpty()
					|| getDateRangeEnd().isEmpty()) {
				error = true;
				sb.append("Fail to print: Monthly In-Patients Statistical Analysis (RptIPStatAnalysis)<br/><br/>");
			}

			if (getSiteCode().getText().trim().length() == 0
					|| !getSiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
			if (getDateRangeStart().isEmpty()) {
				sb.append("Please supply Start Date.<br/>");
			}
			if (getDateRangeEnd().isEmpty()) {
				sb.append("Please supply End Date.<br/>");
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
		// checking
		if (!validatePrintAction()) {
			return;
		}

		String steCode = getSiteCode().getText().trim();
		String stename = getSiteCode().getDisplayText();
		String startDate = getDateRangeStart().getText().trim();
		String endDate = getDateRangeEnd().getText().trim();
		String dateRange = startDate + " to " + endDate;
		Map<String, String> maps = new HashMap<String, String>();

		maps.put("SteCode", steCode);
		maps.put("SteName", stename);
		maps.put("StartDate", startDate);
		maps.put("EndDate", endDate);
		maps.put("SUBREPORT_DIR", CommonUtil.getReportDir());

		if (getPrinttoScreen().isSelected()) {// use report panel
			if (getBOOBUB().isSelected()) {
				int days = DateTimeUtil.dateDiff(endDate, startDate);
				maps.put("days", new Integer(days).toString());

				Report.print(Factory.getInstance().getUserInfo(),
						"RptMainBedSmy", maps, new String[] { steCode,
								startDate, endDate }, new String[] { "WARD",
								"ROOM", "ACMCODE", "TYPE", "NOOFBED",
								"NOOFDAY", "DESCRIPTION" });
			}

			if (getCA().isSelected()) {
				String cashierCode = getCashID().getText().trim();
				maps.put("cashiercode", cashierCode);

				Report.print(Factory.getInstance().getUserInfo(),
						"RptCshrAudit", maps, new String[] { steCode,
								startDate, endDate, cashierCode },
						new String[] { "TYPE", "CTXMETH", "CTNCTYPE",
								"CTXTYPE", "CTXSNO", "CTXNAME", "CTXDESC",
								"CTXAMT", "CTXCDATE" });
			}

			// Override Fee Discount Report
			if (getOFRD().isSelected()) {
				maps.put("dateRange", dateRange);
				Report.print(Factory.getInstance().getUserInfo(),
						"RptOverrideFeeDisc", maps, new String[] { startDate,
								endDate, steCode, getPercent().getText() },
						new String[] { "ITMCODE", "ITMNAME", "STNBAMT",
								"STNNAMT", "STNDISC", "SLPNO", "DOCCODE",
								"USRID", "STENAME", "STNSTS", "STNCDATE" });
			}

			// Payment Detail Report
			if (getPD().isSelected()) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("stename", stename);
				Report.print(Factory.getInstance().getUserInfo(),
						"RptPayDetail", maps, new String[] { startDate,
								endDate, steCode }, new String[] { "STNCDATE",
								"SLPTYPE", "CTXMETH", "GLCCODE", "STNDESC",
								"CTNCTYPE", "PATNO", "PATFNAME", "PATGNAME",
								"SLPFNAME", "SLPGNAME", "SLPNO", "STNNAMT",
								"STNTDATE", "STNSTS", "STNTDATECHAR" });
			}

			if (getRAR().isSelected()) {
				String docCode = getDoctor().getText().trim();
				String sickCode = getSickCode().getText().trim();
				String admitday = getReadmitDay().getText().trim();
				String SelectCrit = "Selection Criteria -- Readmit Day: "
						+ admitday + "     Doctor: ";
				if (docCode.equals("S")) {
					SelectCrit = SelectCrit + "Same Doctor"
							+ "     Sick Code: ";
				} else if (docCode.equals("N")) {
					SelectCrit = SelectCrit + "Not Same Doctor"
							+ "     Sick Code: ";
				} else {
					SelectCrit = SelectCrit + "Ignore Doctor"
							+ "     Sick Code: ";
				}

				if (sickCode.equals("S")) {
					SelectCrit = SelectCrit + "Same Sick Code";
				} else if (sickCode.equals("N")) {
					SelectCrit = SelectCrit + "Not Same Sick Code";
				} else {
					SelectCrit = SelectCrit + "Ignore Sick Code";
				}
				Map<String, String> map = new HashMap<String, String>();
				map.put("stename", stename);
				map.put("daterange", startDate + " to " + endDate);
				map.put("SelectCrit", SelectCrit);
				PrintingUtil.print("DEFAULT", "RptReAdmiss", map, "",
						new String[] { steCode, startDate, endDate, admitday,
								docCode, sickCode }, new String[] { "PATNO",
								"AGE", "REGDATE1", "INPDDATE1", "LOS1",
								"ADMDR1", "DISDR1", "SCKCODE1", "SCKDESC1",
								"REGDATE2", "INPDDATE2", "LOS2", "ADMDR2",
								"DISDR2", "SCKCODE2", "SCKDESC2", "SPEC_SA",
								"SPEC_SD", "SPEC_SSA", "SPEC_SSD" });
			}

			// Transaction Detail
			if (getTD().isSelected()) {
				Report.print(Factory.getInstance().getUserInfo(), "RptTranDtl",
						maps, new String[] { steCode, startDate, endDate,
								getItemGroup().getText() }, new String[] {
								"DOCTOR", "ITEM", "PATNO", "NAME", "STNNAMT",
								"STNCDATE", "PCYDESC", "ITMGRP" });
			}

			// Registered Maintand Maternity
			if (getRMM().isSelected()) {
				Report.print(Factory.getInstance().getUserInfo(),
						"RegMainLandMaterPatLst", maps, new String[] { steCode,
								startDate, endDate }, new String[] { "SLPNO",
								"ENAME", "PATID", "PATBDATE", "EDC" });
			}

			// Monthly In-Patients Statistical Analysis
			if (getMIPSA().isSelected()) {
				Report.print(Factory.getInstance().getUserInfo(),
						"RptIPStatAnalysis", maps, new String[] { steCode,
								startDate, endDate }, new String[] { "SPCCODE",
								"SPCNAME", "FG", "NOOFDISCHARGED", "NOOFMID",
								"NOOF24", "NOOF_DEATH" });
			}

			if (getMIPSA06().isSelected()) {
				Report.print(Factory.getInstance().getUserInfo(),
						"RptIPStatAnalysis2006", maps, new String[] { steCode,
								startDate, endDate }, new String[] { "SPCCODE",
								"SPCNAME", "FG", "NOOFDISCHARGED", "NOOFMID",
								"NOOF24", "NOOF_DEATH" });
			}

		} else if (getPrinttoFile().isSelected()) {// print xls
			if (getBOOBUB().isSelected()) {
				int days = DateTimeUtil.dateDiff(endDate, startDate);
				maps.put("days", new Integer(days).toString());

				PrintingUtil.print("DEFAULT", "RptMainBedSmy", maps, "",
						new String[] { steCode, startDate, endDate },
						new String[] { "WARD", "ROOM", "ACMCODE", "TYPE",
								"NOOFBED", "NOOFDAY", "DESCRIPTION" }, 0, null,
						null, null, null, 1, false, true,
						new String[] { "xls" });
			}

			if (getCA().isSelected()) {
				String cashierCode = getCashID().getText().trim();
				maps.put("cashiercode", cashierCode);
				PrintingUtil
						.print("DEFAULT", "RptCshrAudit", maps, "",
								new String[] { steCode, startDate, endDate,
										cashierCode }, new String[] { "TYPE",
										"CTXMETH", "CTNCTYPE", "CTXTYPE",
										"CTXSNO", "CTXNAME", "CTXDESC",
										"CTXAMT", "CTXCDATE" }, 0, null, null,
								null, null, 1, false, true,
								new String[] { "xls" });
			}

			// Override Fee Discount Report
			if (getOFRD().isSelected()) {
				maps.put("dateRange", dateRange);

				PrintingUtil.print("DEFAULT", "RptOverrideFeeDisc", maps, "",
						new String[] { startDate, endDate, steCode,
								getPercent().getText() }, new String[] {
								"ITMCODE", "ITMNAME", "STNBAMT", "STNNAMT",
								"STNDISC", "SLPNO", "DOCCODE", "USRID",
								"STENAME", "STNSTS", "STNCDATE" }, 0, null,
						null, null, null, 1, false, true,
						new String[] { "xls" });
			}

			// Payment Detail Report
			if (getPD().isSelected()) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("stename", stename);
				PrintingUtil.print("DEFAULT", "RptPayDetail", map, "",
						new String[] { startDate, endDate, steCode },
						new String[] { "STNCDATE", "SLPTYPE", "CTXMETH",
								"GLCCODE", "STNDESC", "CTNCTYPE", "PATNO",
								"PATFNAME", "PATGNAME", "SLPFNAME", "SLPGNAME",
								"SLPNO", "STNNAMT", "STNTDATE", "STNSTS",
								"STNTDATECHAR" }, 0, null, null, null, null, 1,
						false, true, new String[] { "xls" });
			}

			if (getRAR().isSelected()) {
				String docCode = getDoctor().getText().trim();
				String sickCode = getSickCode().getText().trim();
				String admitday = getReadmitDay().getText().trim();
				String SelectCrit = "Selection Criteria -- Readmit Day: "
						+ admitday + "     Doctor: ";
				if (docCode.equals("S")) {
					SelectCrit = SelectCrit + "Same Doctor"
							+ "     Sick Code: ";
				} else if (docCode.equals("N")) {
					SelectCrit = SelectCrit + "Not Same Doctor"
							+ "     Sick Code: ";
				} else {
					SelectCrit = SelectCrit + "Ignore Doctor"
							+ "     Sick Code: ";
				}

				if (sickCode.equals("S")) {
					SelectCrit = SelectCrit + "Same Sick Code";
				} else if (sickCode.equals("N")) {
					SelectCrit = SelectCrit + "Not Same Sick Code";
				} else {
					SelectCrit = SelectCrit + "Ignore Sick Code";
				}
				Map<String, String> map = new HashMap<String, String>();
				map.put("stename", stename);
				map.put("daterange", startDate + " to " + endDate);
				map.put("SelectCrit", SelectCrit);
				PrintingUtil.print("DEFAULT", "RptReAdmiss", map, "",
						new String[] { steCode, startDate, endDate, admitday,
								docCode, sickCode }, new String[] { "PATNO",
								"AGE", "REGDATE1", "INPDDATE1", "LOS1",
								"ADMDR1", "DISDR1", "SCKCODE1", "SCKDESC1",
								"REGDATE2", "INPDDATE2", "LOS2", "ADMDR2",
								"DISDR2", "SCKCODE2", "SCKDESC2", "SPEC_SA",
								"SPEC_SD", "SPEC_SSA", "SPEC_SSD" }, 0, null,
						null, null, null, 1, false, true,
						new String[] { "xls" });
			}

			// Transaction Detail
			if (getTD().isSelected()) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("stename", stename);
				map.put("daterange", startDate + " to " + endDate);
				PrintingUtil.print("DEFAULT", "RptTranDtl", map, "",
						new String[] { steCode, startDate, endDate,
								getItemGroup().getText() }, new String[] {
								"DOCTOR", "ITEM", "PATNO", "NAME", "STNNAMT",
								"STNCDATE", "PCYDESC", "ITMGRP" }, 0, null,
						null, null, null, 1, false, true,
						new String[] { "xls" });
			}

			// Registered Maintand Maternity
			if (getRMM().isSelected()) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("stename", stename);
				map.put("daterange", startDate + " to " + endDate);
				PrintingUtil.print("DEFAULT", "RegMainLandMaterPatLst", map,
						"", new String[] { steCode, startDate, endDate },
						new String[] { "SLPNO", "ENAME", "PATID", "PATBDATE",
								"EDC" }, 0, null, null, null, null, 1, false,
						true, new String[] { "xls" });
			}

			// Monthly In-Patients Statistical Analysis
			if (getMIPSA().isSelected()) {
				PrintingUtil.print("DEFAULT", "RptIPStatAnalysis", maps, "",
						new String[] { steCode, startDate, endDate },
						new String[] { "SPCCODE", "SPCNAME", "FG",
								"NOOFDISCHARGED", "NOOFMID", "NOOF24",
								"NOOF_DEATH" }, 0, null, null, null, null, 1,
						false, true, new String[] { "xls" });
			}

			if (getMIPSA06().isSelected()) {
				PrintingUtil.print("DEFAULT", "RptIPStatAnalysis2006", maps,
						"", new String[] { steCode, startDate, endDate },
						new String[] { "SPCCODE", "SPCNAME", "FG",
								"NOOFDISCHARGED", "NOOFMID", "NOOF24",
								"NOOF_DEATH" }, 0, null, null, null, null, 1,
						false, true, new String[] { "xls" });
			}

			if (getItem().isSelected()) {
				Map<String, String> map = new HashMap<String, String>();
				PrintingUtil.print("DEFAULT", "PrintItemLst", map, "",
						new String[] { "" }, new String[] { "ITMCODE",
								"ITMNAME", "ITMCNAME", "ITMTYPE", "ITMRLVL",
								"DSCCODE", "DSCDESC", "DPTCODE", "DPTNAME",
								"STECODE", "ITMPOVERRD", "ITMDOCCR", "ITMCAT",
								"ITMGRP" }, 0, null, null, null, null, 1,
						false, true, new String[] { "xls" });
			}

			if (getPackage().isSelected()) {
				Map<String, String> map = new HashMap<String, String>();

				PrintingUtil.print("DEFAULT", "PrintPackageLst", map, "",
						new String[] { "" }, new String[] { "PKGCODE",
								"PKGNAME", "PKGCNAME", "DPTCODE", "PKGRLVL",
								"PKGTYPE", "PKGALERT" }, 0, null, null, null,
						null, 1, false, true, new String[] { "xls" });
			}

			if (getItemCharge().isSelected()) {
				Map<String, String> map = new HashMap<String, String>();
				maps.put("SUBREPORT_DIR", CommonUtil.getReportDir());

				PrintingUtil.print("", "PrintItemChargeLst", map, "",
						new String[] { "" }, new String[] { "T.ITCID",
								"T.ITMCODE", "I.ITMNAME", "T.ITCTYPE",
								"T.PKGCODE", "P.PKGNAME", "T.ACMCODE",
								"T.GLCCODE", "T.ITCAMT1", "T.ITCAMT2",
								"T.CPSID", "T.CPSPCT" }, 0, null, null, null,
						null, 1, false, true, new String[] { "xls" });
			}

		} else {// print to printer
			if (getBOOBUB().isSelected()) {
				int days = DateTimeUtil.dateDiff(endDate, startDate);
				maps.put("days", new Integer(days).toString());

				PrintingUtil.print("RptMainBedSmy", maps, "", new String[] {
						steCode, startDate, endDate }, new String[] { "WARD",
						"ROOM", "ACMCODE", "TYPE", "NOOFBED", "NOOFDAY",
						"DESCRIPTION" });
			}

			if (getCA().isSelected()) {
				String cashierCode = getCashID().getText().trim();
				maps.put("cashiercode", cashierCode);

				PrintingUtil
						.print("DEFAULT", "RptCshrAudit", maps, "",
								new String[] { steCode, startDate, endDate,
										cashierCode }, new String[] { "TYPE",
										"CTXMETH", "CTNCTYPE", "CTXTYPE",
										"CTXSNO", "CTXNAME", "CTXDESC",
										"CTXAMT", "CTXCDATE" });
			}

			if (getDAnew().isSelected()) {
				String sckCode = getSickCode().getText().trim();
				Map<String, String> map = new HashMap<String, String>();
				map.put("steN", stename);
				map.put("StartDate", startDate);
				map.put("EndDate", endDate);
				PrintingUtil
						.print("DEFAULT", "RptDisDetail", map, "",
								new String[] { steCode, startDate, endDate,
										sckCode }, new String[] { "SCKCODE",
										"SCKDESC", "CNTHOME", "CNTHOSPITAL",
										"CNTDEATH", "SDSCODE", "SDSDESC" });
			}

			if (getDAold().isSelected()) {
				PrintingUtil.print("DEFAULT", "RptDisAnaly2", maps, "");
				PrintingUtil.print("DEFAULT", "RptDisAnalysis", maps, "");
			}

			if (getDSHRBP().isSelected()) {
				// Report.print("RptDrSwapPat", maps);
			}

			if (getDSHSC().isSelected()) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("stename", stename);
				map.put("daterange", startDate + " to " + endDate);
				PrintingUtil.print("DEFAULT", "RptDocSwapHistSmy", map, "",
						new String[] { steCode, startDate, endDate },
						new String[] { "DOCCODE", "DOCFNAME", "DOCGNAME",
								"ADM", "TOT", "DAY", "DSHG", "REC", "TRAN" });
			}

			if (getDTS().isSelected()) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("stename", stename);
				map.put("daterange", startDate + " to " + endDate);
				PrintingUtil
						.print("DEFAULT", "RptDocTreatmentSmy", map, "",
								new String[] { steCode, startDate, endDate },
								new String[] { "DOCCODE", "DOCFNAME",
										"DOCGNAME", "PATNO", "PATFNAME",
										"PATGNAME", "AGE", "DHSDATE",
										"DHSEDATE", "LENGTH", "TOTALCHARGES" });
			}

			// Registered Maintand Maternity
			if (getRMM().isSelected()) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("stename", stename);
				map.put("daterange", "From: " + startDate + " To: " + endDate);
				PrintingUtil.print("DEFAULT", "RegMainLandMaterPatLst", map,
						"", new String[] { steCode, startDate, endDate },
						new String[] { "SLPNO", "ENAME", "PATID", "PATBDATE",
								"EDC" });
			}
			// --------------------------------------------------------------------------------//
			if (getFILchg().isSelected()) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("stename", stename);
				String itemCode = getItemCode().getText().trim();
				PrintingUtil.print("DEFAULT", "RptFeeLst", map, "",
						new String[] { steCode, itemCode }, new String[] {
								"ITMCODE", "ITMNAME", "DSCCODE", "ITMRLVL",
								"ITMTYPE", "PKGCODE", "DSCDESC", "ACMCODE",
								"GLCCODE", "ITCAMT1", "ITCAMT2", "ITCTYPE",
								"DPTCODE", "ITMPOVERRD" });
			}

			if (getFILCrd().isSelected()) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("stename", stename);
				String itemCode = getItemCode().getText().trim();
				PrintingUtil.print("DEFAULT", "RptFeeCreditLst", map, "",
						new String[] { steCode, itemCode }, new String[] {
								"ITMCODE", "ITMNAME", "ITMCNAME", "DSCCODE",
								"ITMRLVL", "ITMTYPE", "PKGCODE", "DSCDESC",
								"ACMCODE", "GLCCODE", "ITCAMT1", "ITCAMT2",
								"ITCTYPE", "DPTCODE", "ITMPOVERRD" });
			}

			if (getFPLchg().isSelected()) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("stename", stename);
				String pkgcode = getPackageCode().getText().trim();
				PrintingUtil.print("DEFAULT", "RptPgmFeeLst", map, null,
						new String[] { steCode, pkgcode }, new String[] {
								"ITMCODE", "ITMNAME", "ITMCNAME", "DSCCODE",
								"STENAME", "ITMRLVL", "ITMTYPE", "PKGCODE",
								"PKGNAME", "PKGCNAME", "DPTCODE", "ACMCODE",
								"GLCCODE", "ITCAMT1", "ITCAMT2", "ITCTYPE",
								"DPTCODE3", "ITMPOVERRD", "PACKAGE" });
			}

			if (getFPLCrd().isSelected()) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("stename", stename);
				String pkgcode = getPackageCode().getText().trim();
				PrintingUtil.print("DEFAULT", "RptPgmCreditLst", map, null,
						new String[] { steCode, pkgcode }, new String[] {
								"ITMCODE", "ITMNAME", "STENAME", "ITMRLVL",
								"ITMTYPE", "PKGCODE", "PKGNAME", "PKGCNAME",
								"DPTCODE", "ACMCODE", "GLCCODE", "ITCAMT1",
								"ITCAMT2", "ITCTYPE", "PACKAGE" });
			}

			if (getIDCGC().isSelected()) {
			}

			if (getLC().isSelected()) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("stename", stename);
				map.put("daterange", startDate + " to " + endDate);
				PrintingUtil.print("DEFAULT", "RptLocCensus", map, "",
						new String[] { steCode, startDate, endDate },
						new String[] { "LOCCODE", "DSTCODE", "LOCNAME",
								"DSTNAME", "REGTYPE", "NOOFPAT",
								"DISTINCTNOOFPAT", "SUMOFIP", "SUMOFOP",
								"SUMOFDAYCASE" });
			}

			// Monthly In-Patients Statistical Analysis
			if (getMIPSA().isSelected()) {
				PrintingUtil.print("DEFAULT", "RptIPStatAnalysis", maps, "",
						new String[] { steCode, startDate, endDate },
						new String[] { "SPCCODE", "SPCNAME", "FG",
								"NOOFDISCHARGED", "NOOFMID", "NOOF24",
								"NOOF_DEATH" });
			}

			if (getMIPSA06().isSelected()) {
				PrintingUtil.print("DEFAULT", "RptIPStatAnalysis2006", maps,
						"", new String[] { steCode, startDate, endDate },
						new String[] { "SPCCODE", "SPCNAME", "FG",
								"NOOFDISCHARGED", "NOOFMID", "NOOF24",
								"NOOF_DEATH" });
			}

			// --------------------------------------------------------------------------------//
			if (getOSTTFA().isSelected()) {
			}

			if (getPPP().isSelected()) {
				String doccode = getDoctorCode().getText().trim();
				String pkgcode = getPackageCode().getText().trim();
				Map<String, String> map = new HashMap<String, String>();
				map.put("stename", stename);
				map.put("daterange", startDate + " to " + endDate);
				PrintingUtil.print("DEFAULT", "RptPkgPerformance", map, "",
						new String[] { steCode, startDate, endDate, doccode,
								pkgcode }, new String[] { "SLPNO", "PKGCODE",
								"SLPTYPE", "DOCCODE", "PATNO", "FIELDTYPE",
								"AMOUNT" });
			}

			if (getRAR().isSelected()) {
				String docCode = getDoctor().getText().trim();
				String sickCode = getSickCode().getText().trim();
				String admitday = getReadmitDay().getText().trim();
				String SelectCrit = "Selection Criteria -- Readmit Day: "
						+ admitday + "     Doctor: ";
				if (docCode.equals("S")) {
					SelectCrit = SelectCrit + "Same Doctor"
							+ "     Sick Code: ";
				} else if (docCode.equals("N")) {
					SelectCrit = SelectCrit + "Not Same Doctor"
							+ "     Sick Code: ";
				} else {
					SelectCrit = SelectCrit + "Ignore Doctor"
							+ "     Sick Code: ";
				}

				if (sickCode.equals("S")) {
					SelectCrit = SelectCrit + "Same Sick Code";
				} else if (sickCode.equals("N")) {
					SelectCrit = SelectCrit + "Not Same Sick Code";
				} else {
					SelectCrit = SelectCrit + "Ignore Sick Code";
				}
				Map<String, String> map = new HashMap<String, String>();
				map.put("stename", stename);
				map.put("daterange", startDate + " to " + endDate);
				map.put("SelectCrit", SelectCrit);
				PrintingUtil.print("DEFAULT", "RptReAdmiss", map, "",
						new String[] { steCode, startDate, endDate, admitday,
								docCode, sickCode }, new String[] { "PATNO",
								"AGE", "REGDATE1", "INPDDATE1", "LOS1",
								"ADMDR1", "DISDR1", "SCKCODE1", "SCKDESC1",
								"REGDATE2", "INPDDATE2", "LOS2", "ADMDR2",
								"DISDR2", "SCKCODE2", "SCKDESC2", "SPEC_SA",
								"SPEC_SD", "SPEC_SSA", "SPEC_SSD" });
			}

			if (getRAnew().isSelected()) {

			}

			if (getRAold().isSelected()) {

			}

			// Override Fee Discount Report
			if (getOFRD().isSelected()) {
				maps.put("dateRange", dateRange);
				PrintingUtil.print("DEFAULT", "RptOverrideFeeDisc", maps, "",
						new String[] { startDate, endDate, steCode,
								getPercent().getText() }, new String[] {
								"ITMCODE", "ITMNAME", "STNBAMT", "STNNAMT",
								"STNDISC", "SLPNO", "DOCCODE", "USRID",
								"STENAME", "STNSTS", "STNCDATE" });
			}

			// Payment Detail Report
			if (getPD().isSelected()) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("stename", stename);
				PrintingUtil.print("DEFAULT", "RptPayDetail", map, "",
						new String[] { startDate, endDate, steCode },
						new String[] { "STNCDATE", "SLPTYPE", "CTXMETH",
								"GLCCODE", "STNDESC", "CTNCTYPE", "PATNO",
								"PATFNAME", "PATGNAME", "SLPFNAME", "SLPGNAME",
								"SLPNO", "STNNAMT", "STNTDATE", "STNSTS",
								"STNTDATECHAR" });
			}

			// Transaction Detail
			if (getTD().isSelected()) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("stename", stename);
				map.put("daterange", startDate + " to " + endDate);
				PrintingUtil.print("DEFAULT", "RptTranDtl", map, "",
						new String[] { steCode, startDate, endDate,
								getItemGroup().getText() }, new String[] {
								"DOCTOR", "ITEM", "PATNO", "NAME", "STNNAMT",
								"STNCDATE", "PCYDESC", "ITMGRP" });
			}
		}
	}

	public BasePanel getTextPanel() {
		if (TextPanel == null) {
			TextPanel = new BasePanel();
			TextPanel.setBorders(true);
			TextPanel.add(getPrinttoFileDesc(), null);
			TextPanel.add(getPrinttoFile(), null);
			TextPanel.add(getPrinttoScreenDesc(), null);
			TextPanel.add(getPrinttoScreen(), null);
			TextPanel.add(getDateRangeStartDesc(), null);
			TextPanel.add(getDateRangeStart(), null);
			TextPanel.add(getDateRangeEndDesc(), null);
			TextPanel.add(getDateRangeEnd(), null);
			TextPanel.add(getSiteCodeDesc(), null);
			TextPanel.add(getSiteCode(), null);
			TextPanel.add(getItemGroupDesc(), null);
			TextPanel.add(getItemGroup(), null);
			TextPanel.add(getDoctorDesc(), null);
			TextPanel.add(getDoctor(), null);
			TextPanel.add(getSickCodeDesc(), null);
			TextPanel.add(getSickCode(), null);
			TextPanel.add(getReadmitDayDesc(), null);
			TextPanel.add(getReadmitDay(), null);
			TextPanel.add(getCashIDDesc(), null);
			TextPanel.add(getBtnOpenDoctorFee(), null);
			TextPanel.add(getCashID(), null);
			TextPanel.add(getDoctorCodeDesc(), null);
			TextPanel.add(getDoctorCode(), null);
			TextPanel.add(getPatientCodeDesc(), null);
			TextPanel.add(getPatientCode(), null);
			TextPanel.add(getSelectPrinterDesc(), null);
			TextPanel.add(getSelectPrinter(), null);
			TextPanel.add(getItemCodeDesc(), null);
			TextPanel.add(getItemCode(), null);
			TextPanel.add(getPackageCodeDesc(), null);
			TextPanel.add(getPackageCode(), null);
			TextPanel.add(getPercentDesc(), null);
			TextPanel.add(getPercent(), null);
			TextPanel.add(getReprintDesc(), null);
			TextPanel.add(getReprint(), null);
			TextPanel.add(getNewDoctor(), null);
			TextPanel.add(getNewDoctorExp(), null);
			TextPanel.add(getNewDoctorRpt2(), null);
			TextPanel.add(getSpecialcom(), null);
			TextPanel.add(getReprintrpt(), null);
			TextPanel.setLocation(5, 315);
			TextPanel.setSize(790, 204);
		}
		return TextPanel;
	}

	public LabelBase getPrinttoFileDesc() {
		if (PrinttoFileDesc == null) {
			PrinttoFileDesc = new LabelBase();
			PrinttoFileDesc.setText("Print To File");
			PrinttoFileDesc.setBounds(520, 10, 85, 20);
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
			PrinttoFile.setBounds(495, 10, 23, 20);
		}
		return PrinttoFile;
	}

	public LabelBase getPrinttoScreenDesc() {
		if (PrinttoScreenDesc == null) {
			PrinttoScreenDesc = new LabelBase();
			PrinttoScreenDesc.setText("Print To Screen");
			PrinttoScreenDesc.setBounds(635, 10, 95, 20);
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
			PrinttoScreen.setBounds(610, 10, 23, 20);
		}
		return PrinttoScreen;
	}

	public LabelBase getDateRangeStartDesc() {
		if (DateRangeStartDesc == null) {
			DateRangeStartDesc = new LabelBase();
			DateRangeStartDesc
					.setText("<html>Date range start<br>(dd/mm/yyyy)</html>");
			DateRangeStartDesc.setBounds(10, 40, 90, 30);
		}
		return DateRangeStartDesc;
	}

	public TextDate getDateRangeStart() {
		if (DateRangeStart == null) {
			DateRangeStart = new TextDate() {
				@Override
				public void onBlur() {
					if (!isEmpty() && !isValid()) {
						Factory.getInstance().addErrorMessage("Invalid date.",
								getDateRangeStart());
						resetText();
						return;
					}
				};
			};

			DateRangeStart.setBounds(110, 50, 90, 20);
		}
		return DateRangeStart;
	}

	public LabelBase getDateRangeEndDesc() {
		if (DateRangeEndDesc == null) {
			DateRangeEndDesc = new LabelBase();
			DateRangeEndDesc
					.setText("<html>Date range end<br>(dd/mm/yyyy)</html>");
			DateRangeEndDesc.setBounds(210, 40, 90, 30);
		}
		return DateRangeEndDesc;
	}

	public TextDate getDateRangeEnd() {
		if (DateRangeEnd == null) {
			DateRangeEnd = new TextDate() {
				@Override
				public void onBlur() {
					if (!isEmpty() && !isValid()) {
						Factory.getInstance().addErrorMessage("Invalid date.",
								getDateRangeEnd());
						resetText();
						return;
					}
				};
			};
			DateRangeEnd.setBounds(310, 50, 90, 20);
		}
		return DateRangeEnd;
	}

	public LabelBase getSiteCodeDesc() {
		if (SiteCodeDesc == null) {
			SiteCodeDesc = new LabelBase();
			SiteCodeDesc.setText("Site Code");
			SiteCodeDesc.setBounds(410, 50, 90, 20);
		}
		return SiteCodeDesc;
	}

	public ComboSiteType getSiteCode() {
		if (SiteCode == null) {
			SiteCode = new ComboSiteType();
			SiteCode.setBounds(490, 50, 90, 20);
		}
		return SiteCode;
	}

	public LabelBase getItemGroupDesc() {
		if (ItemGroupDesc == null) {
			ItemGroupDesc = new LabelBase();
			ItemGroupDesc.setText("Item Group");
			ItemGroupDesc.setBounds(590, 50, 90, 20);
		}
		return ItemGroupDesc;
	}

	public TextString getItemGroup() {
		if (ItemGroup == null) {
			ItemGroup = new TextString();
			ItemGroup.setBounds(670, 50, 90, 20);
		}
		return ItemGroup;
	}

	public LabelBase getDoctorDesc() {
		if (DoctorDesc == null) {
			DoctorDesc = new LabelBase();
			DoctorDesc.setText("Doctor");
			DoctorDesc.setBounds(10, 80, 90, 20);
		}
		return DoctorDesc;
	}

	public ComboDocCode getDoctor() {
		if (Doctor == null) {
			Doctor = new ComboDocCode();
			Doctor.setBounds(110, 80, 90, 20);
		}
		return Doctor;
	}

	public LabelBase getSickCodeDesc() {
		if (SickCodeDesc == null) {
			SickCodeDesc = new LabelBase();
			SickCodeDesc.setText("Sick Code");
			SickCodeDesc.setBounds(210, 80, 90, 20);
		}
		return SickCodeDesc;
	}

	public ComboSickCode getSickCode() {
		if (SickCode == null) {
			SickCode = new ComboSickCode();
			SickCode.setBounds(310, 80, 90, 20);
		}
		return SickCode;
	}

	public LabelBase getReadmitDayDesc() {
		if (ReadmitDayDesc == null) {
			ReadmitDayDesc = new LabelBase();
			ReadmitDayDesc.setText("Readmit Day");
			ReadmitDayDesc.setBounds(410, 81, 90, 20);
		}
		return ReadmitDayDesc;
	}

	public TextString getReadmitDay() {
		if (ReadmitDay == null) {
			ReadmitDay = new TextString();
			ReadmitDay.setBounds(490, 81, 90, 20);
		}
		return ReadmitDay;
	}

	public ButtonBase getBtnOpenDoctorFee() {
		if (btnOpenDoctorFee == null) {
			btnOpenDoctorFee = new ButtonBase() {
				@Override
				public void onClick() {
					getDlgDocFeeRpt().showDialog(getSysParameter("DOCFEEPATH"));
				}
			};
			btnOpenDoctorFee.setText("Open Doc Fee Reports");
			btnOpenDoctorFee.setBounds(630, 81, 140, 25);
		}
		return btnOpenDoctorFee;
	}

	private DlgDocFeeRpt getDlgDocFeeRpt() {
		if (dlgDocFeeRpt == null) {
			dlgDocFeeRpt = new DlgDocFeeRpt(getMainFrame());
		}
		return dlgDocFeeRpt;
	}

	public LabelBase getCashIDDesc() {
		if (CashIDDesc == null) {
			CashIDDesc = new LabelBase();
			CashIDDesc.setText("Cashier ID");
			CashIDDesc.setBounds(10, 110, 90, 20);
		}
		return CashIDDesc;
	}

	public TextString getCashID() {
		if (CashID == null) {
			CashID = new TextString();
			CashID.setBounds(110, 110, 90, 20);
		}
		return CashID;
	}

	public LabelBase getDoctorCodeDesc() {
		if (DoctorCodeDesc == null) {
			DoctorCodeDesc = new LabelBase();
			DoctorCodeDesc.setText("Doctor Code");
			DoctorCodeDesc.setBounds(210, 110, 90, 20);
		}
		return DoctorCodeDesc;
	}

	public TextString getDoctorCode() {
		if (DoctorCode == null) {
			DoctorCode = new TextString();
			DoctorCode.setBounds(310, 110, 90, 20);
		}
		return DoctorCode;
	}

	public LabelBase getPatientCodeDesc() {
		if (PatientCodeDesc == null) {
			PatientCodeDesc = new LabelBase();
			PatientCodeDesc.setText("Patient Code");
			PatientCodeDesc.setBounds(410, 110, 90, 20);
		}
		return PatientCodeDesc;
	}

	public TextString getPatientCode() {
		if (PatientCode == null) {
			PatientCode = new TextString();
			PatientCode.setBounds(490, 110, 90, 20);
		}
		return PatientCode;
	}

	public LabelBase getSelectPrinterDesc() {
		if (SelectPrinterDesc == null) {
			SelectPrinterDesc = new LabelBase();
			SelectPrinterDesc.setText("Select Printer");
			SelectPrinterDesc.setBounds(630, 110, 90, 20);
		}
		return SelectPrinterDesc;
	}

	public CheckBoxBase getSelectPrinter() {
		if (SelectPrinter == null) {
			SelectPrinter = new CheckBoxBase();
			SelectPrinter.setBounds(720, 110, 23, 20);
		}
		return SelectPrinter;
	}

	public LabelBase getItemCodeDesc() {
		if (ItemCodeDesc == null) {
			ItemCodeDesc = new LabelBase();
			ItemCodeDesc.setText("Item Code");
			ItemCodeDesc.setBounds(10, 140, 90, 20);
		}
		return ItemCodeDesc;
	}

	public TextItemCodeSearch getItemCode() {
		if (ItemCode == null) {
			ItemCode = new TextItemCodeSearch();
			ItemCode.setBounds(110, 140, 90, 20);
		}
		return ItemCode;
	}

	public LabelBase getPackageCodeDesc() {
		if (PackageCodeDesc == null) {
			PackageCodeDesc = new LabelBase();
			PackageCodeDesc.setText("Package Code");
			PackageCodeDesc.setBounds(210, 140, 90, 20);
		}
		return PackageCodeDesc;
	}

	public TextPackageCodeSearch getPackageCode() {
		if (PackageCode == null) {
			PackageCode = new TextPackageCodeSearch();
			PackageCode.setBounds(310, 140, 90, 20);
		}
		return PackageCode;
	}

	public LabelBase getPercentDesc() {
		if (PercentDesc == null) {
			PercentDesc = new LabelBase();
			PercentDesc.setText("Percentage");
			PercentDesc.setBounds(410, 138, 90, 20);
		}
		return PercentDesc;
	}

	public TextString getPercent() {
		if (Percent == null) {
			Percent = new TextString();
			Percent.setBounds(490, 138, 90, 20);
		}
		return Percent;
	}

	public LabelBase getReprintDesc() {
		if (ReprintDesc == null) {
			ReprintDesc = new LabelBase();
			ReprintDesc.setText("Reprint");
			ReprintDesc.setBounds(630, 138, 90, 20);
		}
		return ReprintDesc;
	}

	public CheckBoxBase getReprint() {
		if (Reprint == null) {
			Reprint = new CheckBoxBase();
			Reprint.setBounds(720, 138, 23, 20);
		}
		return Reprint;
	}

	public ButtonBase getNewDoctor() {
		if (NewDoctor == null) {
			NewDoctor = new ButtonBase() {
				@Override
				public void onClick() {
					docFeeMode = NEWDOCFEE;
					newDocFee();
				}
			};
			NewDoctor.setText("New Doctor Fee");
			NewDoctor.setBounds(9, 170, 121, 25);

		}
		return NewDoctor;
	}

	public ButtonBase getNewDoctorExp() {
		if (NewDoctorExp == null) {
			NewDoctorExp = new ButtonBase() {
				@Override
				public void onClick() {
					docFeeMode = NEWDOCFEE_EXP;
					newDocFee();
				}
			};
			NewDoctorExp.setText("New Doctor Fee Exception");
			NewDoctorExp.setBounds(137, 170, 177, 25);
		}
		return NewDoctorExp;
	}

	public ButtonBase getNewDoctorRpt2() {
		if (NewDoctorRpt2 == null) {
			NewDoctorRpt2 = new ButtonBase() {
				@Override
				public void onClick() {
					docFeeMode = DOCFEE2;
					docFeeReport2();
				}
			};
			NewDoctorRpt2.setText("Doctor Fee Report 2");
			NewDoctorRpt2.setBounds(321, 170, 152, 25);
		}
		return NewDoctorRpt2;
	}

	public ButtonBase getSpecialcom() {
		if (Specialcom == null) {
			Specialcom = new ButtonBase() {
				@Override
				public void onClick() {
					// add something
				}
			};
			Specialcom.setText("Special Commission");
			Specialcom.setBounds(482, 170, 155, 25);
		}
		return Specialcom;
	}

	public ButtonBase getReprintrpt() {
		if (Reprintrpt == null) {
			Reprintrpt = new ButtonBase() {
				@Override
				public void onClick() {
					// add something
				}
			};
			Reprintrpt.setText("Reprint *.rpt");
			Reprintrpt.setBounds(645, 170, 111, 25);
		}
		return Reprintrpt;
	}

	// DEVELOPMENT IN PROGRESS
	/* >>> Doctor Fee Report ===================================== <<< */
	private void newDocFee() {
		if (getDateRangeEnd().getText().isEmpty()
				|| getSiteCode().getText().isEmpty()) {
			Factory.getInstance().addErrorMessage(
					"Please provide Date Range End and Site Code.");
			return;
		}
		if (getDateRangeEnd().getText().isEmpty()) {
			Factory.getInstance().addErrorMessage("Invalid Date Range End.");
			return;
		}

		getDocFeeProgBox().show();
		getDocFeeProgBox().getProgressBar().updateProgress(0 / 100d,
				"Starting ...");
		// StatusMsg = "Doctor Fee Report ..."

		if (getReprint().isSelected()) {
			QueryUtil.executeMasterBrowse(getUserInfo(),
					ConstantsTx.LOOKUP_TXCODE, new String[] {
							"slppayhdr",
							"max(sphid)",
							"to_char(dateend, 'dd/mm/yyyy')='"
									+ getDateRangeEnd().getText() + "'" },
					new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								if (mQueue.getContentField()[0].isEmpty()) {
									Factory.getInstance()
											.addErrorMessage(
													"Re-print fail. Invalid Date Range End.");
								} else {
									getDocFeeProgBox().getProgressBar()
											.updateProgress(0 / 100d,
													"Now Printing ...");
									printNewDocFee(getDateRangeEnd().getText(),
											null, true);
								}
							} else {
								Factory.getInstance()
										.addErrorMessage(
												"Re-print fail. Invalid Date Range End.");
							}
						}
					});
		} else {
			Factory.getInstance().isConfirmYesNoDialog(
					ConstantsMessage.MSG_CONFIRMDOCFEEPAYABLE,
					new Listener<MessageBoxEvent>() {
						public void handleEvent(MessageBoxEvent be) {
							if (Dialog.YES.equalsIgnoreCase(be
									.getButtonClicked().getItemId())) {
								if ("N".equals(Factory.getInstance()
										.getSysParameter("DocFeeARun"))) {
									Factory.getInstance().addErrorMessage(
											"Actual run is disabled.");
								} else {
									processNewDocFee(true);
								}
							} else if (Dialog.NO.equalsIgnoreCase(be
									.getButtonClicked().getItemId())) {
								processNewDocFee(false);
							}
						}
					});
		}
	}

	private void processNewDocFee(boolean isConfirm) {
		memIsConfirm = isConfirm;
		docFeeStep1();
	}

	private void docFeeStep1() {
		getDocFeeProgBox().getProgressBar().updateProgress(10 / 100d,
				"Preparing Slip Payment Allocation ...");
		QueryUtil.executeMasterAction(getUserInfo(), "DOCFEESTEP1",
				QueryUtil.ACTION_APPEND, new String[] {
						getDateRangeEnd().getText(),
						memIsConfirm ? ConstantsVariable.YES_VALUE
								: ConstantsVariable.NO_VALUE,
						getUserInfo().getSiteCode(), getUserInfo().getUserID(),
						CommonUtil.getComputerName() },
				new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(final MessageQueue mQueue) {
						if (mQueue.success()) {
							docFeeStep2();
						} else {
							Factory.getInstance().addErrorMessage(
									"Fail to prepare slip payment allocation:"
											+ mQueue.getReturnMsg());
							endDocFeeProg();
						}
					}
				});
	}

	private void docFeeStep2() {
		getDocFeeProgBox().getProgressBar().updateProgress(20 / 100d,
				"Preparing Temporary Table ...");
		QueryUtil.executeMasterAction(
				getUserInfo(),
				"DOCFEESTEP2",
				QueryUtil.ACTION_APPEND,
				new String[] { String.valueOf(ConstantsProperties.OTP2),
						String.valueOf(ConstantsProperties.OTP3),
						getUserInfo().getSiteCode(), getUserInfo().getUserID(),
						CommonUtil.getComputerName() },
				new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(final MessageQueue mQueue) {
						if (mQueue.success()) {
							docFeeStep3();
						} else {
							Factory.getInstance().addErrorMessage(
									"Fail to prepare temporary table:"
											+ mQueue.getReturnMsg());
							endDocFeeProg();
						}
					}
				});
	}

	private void docFeeStep3() {
		getDocFeeProgBox().getProgressBar().updateProgress(30 / 100d,
				"Update Doctor Flag 1 ...");
		QueryUtil.executeMasterAction(getUserInfo(), "DOCFEESTEP3",
				QueryUtil.ACTION_APPEND, new String[] { "" },
				new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(final MessageQueue mQueue) {
						if (mQueue.success()) {
							docFeeStep5();
						} else {
							Factory.getInstance().addErrorMessage(
									"Fail to update doctor flag 1:"
											+ mQueue.getReturnMsg());
							endDocFeeProg();
						}
					}
				});
	}

	private void docFeeStep5() {
		getDocFeeProgBox().getProgressBar().updateProgress(40 / 100d,
				"Update Doctor Flag 2 ...");
		QueryUtil.executeMasterAction(getUserInfo(), "DOCFEESTEP5",
				QueryUtil.ACTION_APPEND, new String[] { "" },
				new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(final MessageQueue mQueue) {
						if (mQueue.success()) {
							printNewDocFeePre(false);
						} else {
							Factory.getInstance().addErrorMessage(
									"Fail to update Doctor Flag 2:"
											+ mQueue.getReturnMsg());
							endDocFeeProg();
						}
					}
				});
	}

	private void postPrintDocFeeTxLst(boolean success) {
		isTxListDone = success ? success : isTxListDone;
		if (isTxListDone) {
			postPrintDocFee(true, false);
		} else {
			Factory.getInstance().addErrorMessage(
					"Fail to generate Doctor Fee Transaction Report");
			endDocFeeProg();
		}
	}

	private void postPrintDocFeePayable(boolean success) {
		isPayableDone = success ? success : isPayableDone;
		if (isPayableDone) {
			postPrintDocFee(false, true);
		} else {
			Factory.getInstance().addErrorMessage(
					"Fail to generate Doctor Fee Payable Report");
			endDocFeeProg();
		}
	}

	private void postPrintDocFee(boolean isTxList, boolean isPayable) {
		System.out.println("== postPrintDocFee isTxListDone=" + isTxListDone
				+ ", isPayableDone=" + isPayableDone);

		if (isTxListDone && isPayableDone) {
			QueryUtil.executeMasterAction(getUserInfo(), "DOCFEE_UPDCHKPT",
					QueryUtil.ACTION_MODIFY, new String[] { null, null,
							C_STAGE_10, null, null, null, null, null },
					new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(final MessageQueue mQueue) {
							if (mQueue.success()) {
								docFeeStep7();
							} else {
								Factory.getInstance().addErrorMessage(
										"Fail to process post report print:"
												+ mQueue.getReturnMsg());
								endDocFeeProg();
							}
						}
					});
		}
	}

	private void docFeeStep7() {
		getDocFeeProgBox().getProgressBar().updateProgress(90 / 100d,
				"Completing ...");
		QueryUtil.executeMasterAction(getUserInfo(), "DOCFEESTEP7",
				QueryUtil.ACTION_APPEND,
				new String[] { memIsConfirm ? ConstantsVariable.YES_VALUE
						: ConstantsVariable.NO_VALUE },
				new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(final MessageQueue mQueue) {
						if (mQueue.success()) {
							QueryUtil.executeMasterFetch(getUserInfo(),
									ConstantsTx.LOOKUP_TXCODE, new String[] {
											"df_chkpt", "count(1)", "1=1" },
									new MessageQueueCallBack() {
										@Override
										public void onPostSuccess(
												MessageQueue mQueue) {
											String msg = "Doctor Fee Reports"
													+ (memIsConfirm ? ""
															: " (Trail Run)");
											if (mQueue.success()) {
												int count = Integer.parseInt(mQueue
														.getContentField()[0]);
												if (count == 0) {
													Factory.getInstance()
															.addInformationMessage(
																	msg
																			+ " Completed Successfully!<br />"
																			+ "Please use Open Doc Fee Reports");
												} else {
													Factory.getInstance()
															.addInformationMessage(
																	msg
																			+ " does not complete!");
												}
											}
											endDocFeeProg();
										}

										@Override
										public void onFailure(Throwable caught) {
											// TODO Auto-generated method stub
											super.onFailure(caught);
											endDocFeeProg();
										}
									});
						} else {
							Factory.getInstance()
									.addErrorMessage(
											"Fail to complete:"
													+ mQueue.getReturnMsg());
							endDocFeeProg();
						}
					}
				});
	}

	private void printNewDocFeePre(final boolean isReprint) {
		getDocFeeProgBox().getProgressBar().updateProgress(50 / 100d,
				"Now Printing ...");

		final String dateend = getDateRangeEnd().getText();

		if (isReprint) {
			printNewDocFee(dateend, null, true);
		} else {
			QueryUtil.executeMasterFetch(getUserInfo(), "DOCFEE_CHKPT",
					new String[] {}, new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(final MessageQueue mQueue) {
							String cp_status = null;
							String cp_sphid = null;
							if (mQueue.success()) {
								cp_status = mQueue.getContentField()[2];
								cp_sphid = mQueue.getContentField()[1];
							}

							// TESTING
							// cp_status = C_STAGE_9;

							if (C_STAGE_9.equals(cp_status)) {
								printNewDocFee(dateend, cp_sphid, false);

								/*
								 * Map<String,String> map = new
								 * HashMap<String,String>();
								 * map.put("in_dateend", dateend);
								 * map.put("in_actualrun", memIsConfirm ?
								 * ConstantsVariable.YES_VALUE :
								 * ConstantsVariable.NO_VALUE);
								 * map.put("in_sitecode",
								 * getUserInfo().getSiteCode());
								 * 
								 * isTxListDone = false; isPayableDone = false;
								 * String fileNamePrefix = dateend.substring(6,
								 * 10) + dateend.substring(3, 5) +
								 * dateend.substring(0, 2) +
								 * getUserInfo().getSiteCode();
								 * 
								 * String rptName = null; if
								 * (NEWDOCFEE_EXP.equals(docFeeMode)) { rptName
								 * = "RptNewDocFeeTxLstEx"; } else { rptName =
								 * "RptNewDocFeeTxLst"; } final String rptNameF
								 * = rptName; Report.print(getUserInfo(),
								 * rptName, map, new String[] {dateend,
								 * cp_sphid,}, new String[] {
								 * "GRP","SUBGRP","DOCCODE","DOCFNAME",
								 * "DOCGNAME","SLPNO","SLPTYPE","STNID",
								 * "STNSTS","STNCDATE","ITMCODE","STNDESC",
								 * "STNBAMT","STNDISC","STNNAMT","PATNO",
								 * "SLPFNAME","SLPGNAME","PATFNAME","PATGNAME",
								 * "PCYID","DSCCODE","DFX_PCT","DFX_FAMT",
								 * "DFX_SAMT"
								 * ,"DFX_PAMT","DFX_CAMT","COMMISSION",
								 * "DFX_CODE","STNOAMT","STNTDATE","TITTLE",
								 * "ADD1","ADD2","ADD3","ADD4" }, null, null,
								 * null, null, null, null, true, // keepPanel
								 * false, false, false, // showpdf new
								 * CallbackListener() {
								 * 
								 * @Override public void handleRetBool(boolean
								 * ret, String result, MessageQueue mQueue) {
								 * System.out.println(rptNameF +
								 * " file saved path="+result);
								 * postPrintDocFeeTxLst(ret); } },
								 * getSysParameter("DOCFEEPATH"), fileNamePrefix
								 * + "TT", true);
								 * 
								 * if (NEWDOCFEE.equals(docFeeMode)) {
								 * Report.print(getUserInfo(),
								 * "RptNewDocFeePayable", map, new String[]
								 * {dateend, null,}, new String[] {
								 * "DOCCODE","DOCFNAME","DOCGNAME","SLPTYPE",
								 * "GRP","METHOD","CRARATE","BEFORE_COM",
								 * "COM"}, null, null, null, null, null, null,
								 * true, // keepPanel false, false, false, new
								 * CallbackListener() {
								 * 
								 * @Override public void handleRetBool(boolean
								 * ret, String result, MessageQueue mQueue) {
								 * System.out.println(
								 * "RptNewDocFeePayable file saved path="
								 * +result); postPrintDocFeePayable(ret); } },
								 * getSysParameter("DOCFEEPATH"), fileNamePrefix
								 * + "PP", true); }
								 */
							} else {
								docFeeStep7();
							}
						}
					});
		}
	}

	private void printNewDocFee(String dateend, String cp_sphid,
			final boolean isReprint) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("in_dateend", dateend);
		map.put("in_actualrun", memIsConfirm ? ConstantsVariable.YES_VALUE
				: ConstantsVariable.NO_VALUE);
		map.put("in_sitecode", getUserInfo().getSiteCode());
		map.put("in_sitename", getUserInfo().getSiteName());

		isTxListDone = false;
		isPayableDone = false;
		String fileNamePrefix = dateend.substring(6, 10)
				+ dateend.substring(3, 5) + dateend.substring(0, 2)
				+ getUserInfo().getSiteCode();

		String rptName = null;
		if (NEWDOCFEE_EXP.equals(docFeeMode)) {
			rptName = getSysParameter("DOCFEERTX") + "Ex";
		} else {
			rptName = getSysParameter("DOCFEERTX");
		}
		final String rptNameF = rptName;
		final String filePath = getSysParameter("DOCFEEPATH");

		Report.print(getUserInfo(), rptName, map, new String[] { dateend,
				cp_sphid, },
				new String[] { "GRP", "SUBGRP", "DOCCODE", "DOCFNAME",
						"DOCGNAME", "SLPNO", "SLPTYPE", "STNID", "STNSTS",
						"STNCDATE", "ITMCODE", "STNDESC", "STNBAMT", "STNDISC",
						"STNNAMT", "PATNO", "SLPFNAME", "SLPGNAME", "PATFNAME",
						"PATGNAME", "PCYID", "DSCCODE", "DFX_PCT", "DFX_FAMT",
						"DFX_SAMT", "DFX_PAMT", "DFX_CAMT", "COMMISSION",
						"DFX_CODE", "STNOAMT", "STNTDATE", "TITTLE", "ADD1",
						"ADD2", "ADD3", "ADD4", "ARCCODE", "AR_PCT" }, null, null, null, null, null,
				null, true, // keepPanel
				false, false, false, // showpdf
				new CallbackListener() {
					@Override
					public void handleRetBool(boolean ret, String result,
							MessageQueue mQueue) {
						System.out.println(rptNameF + " file saved path="
								+ result);
						postPrintDocFeeTxLst(ret);
					}
				}, filePath, fileNamePrefix + "TT", false); // DO NOT print to
															// printer

		if (NEWDOCFEE.equals(docFeeMode)) {
			Report.print(getUserInfo(), "RptNewDocFeePayable", map,
					new String[] { dateend, null, }, new String[] { "DOCCODE",
							"DOCFNAME", "DOCGNAME", "SLPTYPE", "GRP", "METHOD",
							"CRARATE", "BEFORE_COM", "COM" }, null, null, null,
					null, null, null, true, // keepPanel
					false, false, false, // showpdf
					new CallbackListener() {
						@Override
						public void handleRetBool(boolean ret, String result,
								MessageQueue mQueue) {
							System.out
									.println("RptNewDocFeePayable file saved path="
											+ result);
							postPrintDocFeePayable(ret);
						}
					}, filePath, fileNamePrefix + "PP", false); // DO NOT print
																// to printer
		}
	}

	private MessageBox progressBoxExp = null;
	private MessageBox progressBox = null;
	private MessageBox progressBox2 = null;

	protected MessageBox getDocFeeProgBox() {
		if (DOCFEE2.equals(docFeeMode)) {
			if (progressBox2 == null) {
				progressBox2 = MessageBoxBase.progress(
						"Please don't turn off the browser. Close all open reports.",
						"Doctor Fee Report 2", "Initializing...");
			}
			return progressBox2;
		} else if (NEWDOCFEE_EXP.equals(docFeeMode)) {
			if (progressBoxExp == null) {
				progressBoxExp = MessageBoxBase.progress(
						"Please don't turn off the browser. Close all open reports.",
						"Doctor Fee Exception Report", "Initializing...");
			}
			return progressBoxExp;
		} else {
			if (progressBox == null) {
				progressBox = MessageBoxBase.progress(
						"Please don't turn off the browser. Close all open reports.",
						"Doctor Fee Report", "Initializing...");
			}
			return progressBox;
		}
	}

	protected void endDocFeeProg() {
		getDocFeeProgBox().getProgressBar().reset();
		getDocFeeProgBox().close();
	}

	private void docFeeReport2() {
		if (!getDateRangeStart().isEmpty() && !getDateRangeStart().isValid()) {
			Factory.getInstance().addErrorMessage(
					ConstantsMessage.MSG_ERR_INVALIDDATE + "Start Date.",
					getDateRangeStart());
			return;
		}
		if (getDateRangeEnd().isEmpty()
				|| (!getDateRangeEnd().isEmpty() && !getDateRangeEnd()
						.isValid())) {
			Factory.getInstance().addErrorMessage(
					ConstantsMessage.MSG_ERR_INVALIDDATE + "End Date.",
					getDateRangeEnd());
			return;
		}

		getDocFeeProgBox().show();
		getDocFeeProgBox().getProgressBar().updateProgress(50 / 100d,
				"Now Printing ...");

		isDetail2Done = false;
		isSummary2Done = false;

		// DocFeeDetail2
		String dateend = getDateRangeEnd().getText();
		String fileNamePrefix = dateend.substring(6, 10)
				+ dateend.substring(3, 5) + dateend.substring(0, 2)
				+ getUserInfo().getSiteCode();
		Map<String, String> map = new HashMap<String, String>();
		map.put("in_dateend", dateend);
		map.put("in_sitecode", getUserInfo().getSiteCode());
		map.put("in_sitename", getUserInfo().getSiteName());
		Report.print(getUserInfo(), "rptDocFeeDetail2", map,
				new String[] { "" }, new String[] { "GRP", "SUBGRP", "DOCCODE",
						"DOCFNAME", "DOCGNAME", "SLPNO", "SLPTYPE", "STNID",
						"STNSTS", "STNCDATE", "ITMCODE", "STNDESC", "STNBAMT",
						"STNDISC", "STNNAMT", "PATNO", "SLPFNAME", "SLPGNAME",
						"PATFNAME", "PATGNAME", "PCYID", "DSCCODE", "DFX_PCT",
						"DFX_FAMT", "DFX_SAMT", "DFX_PAMT", "DFX_CAMT",
						"COMMISSION", "DFX_CODE", "NET", "COMM", "STNTDATE" },
				null, null, null, null, null, null, true, // keepPanel
				false, false, false, new CallbackListener() {
					@Override
					public void handleRetBool(boolean ret, String result,
							MessageQueue mQueue) {
						System.out.println("rptDocFeeDetail2 file saved path="
								+ result);
						postPrintDocFeeDetail2(ret);
					}
				}, getSysParameter("DOCFEEPATH"), fileNamePrefix
						+ "DocFeeDetail2", false);

		// DocFeeSummary2
		Report.print(getUserInfo(), "rptDocFeeSummary2", map,
				new String[] { "" }, new String[] { "GRP", "SUBGRP", "DOCCODE",
						"DOCFNAME", "DOCGNAME", "SLPNO", "SLPTYPE", "STNID",
						"STNSTS", "STNCDATE", "ITMCODE", "STNDESC", "STNBAMT",
						"STNDISC", "STNNAMT", "PATNO", "SLPFNAME", "SLPGNAME",
						"PATFNAME", "PATGNAME", "PCYID", "DSCCODE", "DFX_PCT",
						"DFX_FAMT", "DFX_SAMT", "DFX_PAMT", "DFX_CAMT",
						"COMMISSION", "DFX_CODE", "NET", "COMM", "STNTDATE" },
				null, null, null, null, null, null, true, // keepPanel
				false, false, false, new CallbackListener() {
					@Override
					public void handleRetBool(boolean ret, String result,
							MessageQueue mQueue) {
						System.out.println("rptDocFeeSummary2 file saved path="
								+ result);
						postPrintDocFeeSummary2(ret);
					}
				}, getSysParameter("DOCFEEPATH"), fileNamePrefix
						+ "DocFeeSummary2", false);
	}

	private void postPrintDocFeeDetail2(boolean success) {
		isDetail2Done = success ? success : isDetail2Done;
		if (isDetail2Done) {
			postPrintDocFee2(true, false);
		} else {
			Factory.getInstance()
					.addErrorMessage(
							"Fail to generate Doctor Fee Transaction Report 2 (Detail)");
			endDocFeeProg();
		}
	}

	private void postPrintDocFeeSummary2(boolean success) {
		isSummary2Done = success ? success : isSummary2Done;
		if (isSummary2Done) {
			postPrintDocFee2(false, true);
		} else {
			Factory.getInstance()
					.addErrorMessage(
							"Fail to generate Doctor Fee Transaction Report 2 (Summary)");
			endDocFeeProg();
		}
	}

	private void postPrintDocFee2(boolean isDetail2, boolean isSummary2) {
		System.out.println("== postPrintDocFee2 isDetail2=" + isDetail2
				+ ", isSummary2=" + isSummary2);
		System.out.println(" isDetail2Done" + isDetail2Done
				+ ", isSummary2Done=" + isSummary2Done);

		if (isDetail2Done && isSummary2Done) {
			getDocFeeProgBox().getProgressBar().updateProgress(1d, "Completed");
			Factory.getInstance()
			.addInformationMessage(
							"Doctor Fee Report 2 (summary, detail) completed.<br />"
							+ "Please use Open Doc Fee Reports");
			endDocFeeProg();
		}
	}
}