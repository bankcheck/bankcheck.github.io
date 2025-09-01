package com.hkah.client.tx.ot;

import java.util.HashMap;

import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.FieldEvent;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.event.SelectionChangedEvent;
import com.extjs.gxt.ui.client.event.SelectionChangedListener;
import com.extjs.gxt.ui.client.store.ListStore;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.form.Field;
import com.google.gwt.json.client.JSONObject;
import com.google.gwt.json.client.JSONString;
import com.hkah.client.common.Factory;
import com.hkah.client.event.CallbackListener;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboAppAnesMeth;
import com.hkah.client.layout.combobox.ComboBloodType;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.combobox.ComboDoctorAN;
import com.hkah.client.layout.combobox.ComboDoctorEN;
import com.hkah.client.layout.combobox.ComboDoctorSU;
import com.hkah.client.layout.combobox.ComboDressing;
import com.hkah.client.layout.combobox.ComboOTCodeType;
import com.hkah.client.layout.combobox.ComboOTLogReason;
import com.hkah.client.layout.combobox.ComboOutcome;
import com.hkah.client.layout.combobox.ComboPatientType;
import com.hkah.client.layout.combobox.ComboProcPrim;
import com.hkah.client.layout.combobox.ComboReasonLate;
import com.hkah.client.layout.combobox.ComboReferDotor;
import com.hkah.client.layout.combobox.ComboScheduleType;
import com.hkah.client.layout.combobox.ComboSpecDest;
import com.hkah.client.layout.combobox.ComboWard;
import com.hkah.client.layout.combobox.ComboYesNo;
import com.hkah.client.layout.dialog.DlgOTSltSlip;
import com.hkah.client.layout.dialog.DlgOTTemplate;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.panel.TabbedPaneBase;
import com.hkah.client.layout.table.EditorTableList;
import com.hkah.client.layout.table.TableData;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextAreaBase;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextDateTimeWithoutSecondWithCheckBox;
import com.hkah.client.layout.textfield.TextNum;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.tx.transaction.TransactionDetail;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.OTTmpUtil;
import com.hkah.client.util.PanelUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TableUtil;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsGlobal;
import com.hkah.shared.constants.ConstantsProperties;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class OTLogBook extends MasterPanel {

	private final static String OT_LOG_MODE_EDIT = String.valueOf(ConstantsGlobal.OT_LOG_MODE_EDIT);
	private final static String OT_LOG_MODE_NEW = String.valueOf(ConstantsGlobal.OT_LOG_MODE_NEW);

	private final static String RTF_PREFIX = "{\\rtf1";
	private final static String RTF_BODY = "\\viewkind4";
	private final static String RTF_SUFFIX = "\\par }";
	private final static String LINE_FEED = "\r\n";

	public final static String OT_APPSTS_F = "F";
	public final static String OT_STS_CLOSE = "C";

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.OTLOGBOOK_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.OTLOGBOOK_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"drpid",
				"#",
				"Date/Time",
				"status_id",
				"Status",
				"User"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				0, 50, 120, 0, 100, 120
			};
	}

	private BasePanel rightPanel = null;
	private BasePanel leftPanel = null;
	private TabbedPaneBase TabbedPane = null;

	// Current Display Patient No
	private String currentPatNo = null;
	private BasePanel GeneralPanel = null;
	private BasePanel GenPatPanel = null;
	private LabelBase PatNoDesc = null;
	private TextPatientNoSearch PatNo = null;
	private LabelBase PatNameDesc = null;
	private TextReadOnly PatFName = null;
	private TextReadOnly PatGName = null;
	private TextReadOnly PatCName = null;
	private LabelBase DOBDesc = null;
	private TextReadOnly DOB = null;
	private LabelBase SexDesc = null;
	private TextReadOnly Sex = null;
	private ButtonBase Allergy = null;

	private LabelBase DateOfOperDesc = null;
	private TextDate DateOfOper = null;
	private LabelBase OperRoomDesc = null;
	private ComboOTCodeType OperRoom = null;
	private LabelBase SetupTimeDesc = null;
	private TextString SetupTime = null;;
	private LabelBase PatTypeDesc = null;
	private ComboPatientType PatType = null;
	private LabelBase PatInDesc = null;
	private TextDateTimeWithoutSecondWithCheckBox PatIn = null;
	private LabelBase PatOutDesc = null;
	private TextDateTimeWithoutSecondWithCheckBox PatOut = null;
	private LabelBase AnesthStartDesc = null;
	private TextDateTimeWithoutSecondWithCheckBox AnesthStart = null;
	private LabelBase AnesthEndDesc = null;
	private TextDateTimeWithoutSecondWithCheckBox AnesthEnd = null;
	private LabelBase OperStartDesc = null;
	private TextDateTimeWithoutSecondWithCheckBox OperStart = null;
	private LabelBase OperEndDesc = null;
	private TextDateTimeWithoutSecondWithCheckBox OperEnd = null;
	private LabelBase IntoRecoveryDesc = null;
	private TextDateTimeWithoutSecondWithCheckBox IntoRecovery = null;
	private LabelBase LeftRecoveryDesc = null;
	private TextDateTimeWithoutSecondWithCheckBox LeftRecovery = null;
	private LabelBase PhoneWardTimeDesc = null;
	private TextDateTimeWithoutSecondWithCheckBox PhoneWardTime = null;
	private LabelBase WardDesc = null;
	private ComboWard Ward = null;
	private LabelBase CleanuptimeDesc = null;
	private TextString Cleanuptime = null;;
	private LabelBase ReasonDesc = null;
	private ComboReasonLate Reason = null;
	private LabelBase SlipNoDesc = null;
	private TextReadOnly SlipNo = null;
	private ButtonBase Charges = null;
	private ButtonBase CloseLog = null;
	private ButtonBase PrintLog = null;
	private ButtonBase Change = null;
	private DlgOTSltSlip dlgOTSltSlip = null;

	private BasePanel ProcedurePanel = null;
	private LabelBase TourOnDesc = null;
	private TextDateTimeWithoutSecondWithCheckBox TourOn = null;
	private LabelBase TourOffDesc = null;
	private TextDateTimeWithoutSecondWithCheckBox TourOff = null;
	private LabelBase BloodTypeDesc = null;
	private ComboBloodType BloodType = null;
	private LabelBase ScheTypeDesc = null;
	private ComboScheduleType ScheType = null;
	private LabelBase OutcomeDesc = null;
	private ComboOutcome Outcome = null;
	private LabelBase DressDesc = null;
	private ComboDressing Dress = null;
	private LabelBase ReasonProcDesc = null;
	private ComboOTLogReason ReasonProc = null;
	private LabelBase SpecimensDesc = null;
	private CheckBoxBase Specimens = null;
	private LabelBase SpecimenToDesc = null;
	private ComboSpecDest SpecimenTo = null;
	private LabelBase FERequestedDesc = null;
	private ComboYesNo FERequested = null;
	private LabelBase FEReceivedDesc = null;
	private ComboYesNo FEReceived = null;

	private FieldSetBase ProcPanel = null;
	private LabelBase PrimaryProcDesc = null;
	private ComboProcPrim PrimaryProc = null;
	private ButtonBase PrimaryProcSearch = null;
	private LabelBase SecProcDesc = null;
	private ButtonBase secProcAdd = null;
	private ButtonBase secProcRemove = null;
	private EditorTableList SecProcTable = null;
	private TableList delSecProcTable = null;
	private JScrollPane SecProcJScrollPane = null;
	private ComboProcPrim comboProcPrim = null;

	private FieldSetBase AnesthMedPanel = null;
	private LabelBase PrimaryAnesDesc = null;
	private ComboAppAnesMeth PrimaryAnes = null;
	private LabelBase SecAnesDesc = null;
	private ButtonBase secAnesAdd = null;
	private ButtonBase secAnesRemove = null;
	private EditorTableList SecAnesTable = null;
	private TableList delSecAnesTable = null;
	private JScrollPane SecAnesJScrollPane = null;
	private LabelBase RemarkDesc = null;
	private TextAreaBase Remark = null;

	private LabelBase CommentsDesc = null;
	private TextAreaBase Comments = null;
	private ButtonBase BFont = null;
	private ButtonBase IFont = null;
	private ButtonBase UFont = null;
	private ButtonBase CFont = null;

	private BasePanel ManpowerPanel = null;
	private FieldSetBase SurgeonPanel = null;
	private LabelBase PrimarySurDesc = null;
	private ComboDoctorSU PrimarySur = null;
	private LabelBase SecSurDesc = null;
	private ButtonBase secSurAdd = null;
	private ButtonBase secSurRemove = null;
	private EditorTableList SecSurTable = null;
	private TableList delSecSurTable = null;
	private JScrollPane SecSurJScrollPane = null;

	private FieldSetBase AnesthManPanel = null;
	private LabelBase PrimaryAnesManDesc = null;
	private ComboDoctorAN PrimaryAnesMan = null;
	private LabelBase SecAnesManDesc = null;
	private ButtonBase secAnesManAdd = null;
	private ButtonBase secAnesManRemove = null;
	private EditorTableList SecAnesManTable = null;
	private TableList delSecAnesManTable = null;
	private JScrollPane SecAnesManJScrollPane = null;

	private FieldSetBase EndosPanel = null;
	private LabelBase EndoscopistDesc = null;
	private ComboDoctorEN Endoscopist = null;

	private FieldSetBase ReferDoctorPanel = null;
	private LabelBase ReferralDoctorDesc = null;
	private ComboReferDotor ReferralDoctor = null;

	private FieldSetBase TeamMembersPanel = null;
	private LabelBase AvaStaffDesc = null;
	private TableList AvaStaffTable = null;
	private JScrollPane AvaStaffJScrollPane = null;

	private LabelBase FunctionDesc = null;
	private TableList FunctionTable = null;
	private JScrollPane FunctionJScrollPane = null;

	private TableList TeamTable = null;
	private TableList delTeamTable = null;
	private JScrollPane ResultJScrollPane = null;
	private ButtonBase Select = null;
	private ButtonBase Remove = null;

	private BasePanel MaterialPanel = null;
	private FieldSetBase ImplantPanel = null;
	private LabelBase AvaImpDesc = null;
	private TableList AvaImpTable = null;
	private JScrollPane AvaImpJScrollPane = null;
	private LabelBase SelImpDesc = null;
	private EditorTableList SelImpTable = null;
	private TableList delSelImpTable = null;
	private JScrollPane SelImpJScrollPane = null;
	private ButtonBase Impbtn = null;

	private FieldSetBase EquipmentPanel = null;
	private LabelBase AvaEquDesc = null;
	private TableList AvaEquTable = null;
	private JScrollPane AvaEquJScrollPane = null;
	private LabelBase SelEquDesc = null;
	private EditorTableList SelEquTable = null;
	private TableList delSelEquTable = null;
	private JScrollPane SelEquJScrollPane = null;
	private ButtonBase Equbtn = null;

	private FieldSetBase InstrumentPanel = null;
	private LabelBase AvaInsDesc = null;
	private TableList AvaInsTable = null;
	private JScrollPane AvaInsJScrollPane = null;
	private LabelBase SelInsDesc = null;
	private EditorTableList SelInsTable = null;
	private TableList delSelInsTable = null;
	private JScrollPane SelInsJScrollPane = null;
	private ButtonBase Insbtn = null;

	private FieldSetBase DrugPanel = null;
	private LabelBase AvaDrugDesc = null;
	private TableList AvaDrugTable = null;
	private JScrollPane AvaDrugJScrollPane = null;
	private LabelBase SelDrugDesc = null;
	private EditorTableList SelDrugTable = null;
	private TableList delSelDrugTable = null;
	private JScrollPane SelDrugJScrollPane = null;
	private ButtonBase Drugbtn = null;

	private BasePanel DoctorProceduresPanel = null;
	private LabelBase ReportDesc = null;
	private TableList ReportTable = null;
	private JScrollPane ReportJScrollPane = null;
	private LabelBase HistoryDesc = null;
	private ButtonBase CreateRpt = null;
	private ButtonBase ModifyRpt = null;
	private ButtonBase ViewRpt = null;
	private ButtonBase PrintRpt = null;
	private DlgOTTemplate dlgOTTemplate = null;
	
	private BasePanel ConsignmentTrackingPanel = null;
	private ButtonBase consignmentSystemButton = null;
	private ButtonBase consignmentSearchButton = null;
	private String consignUrl = null;
	private String consignSearchUrl = null;

	private String patIDNO = "";
	private String memSLPNO;
	private String memPatNo;
	private String memSlpType;
	private String memOTLID;
	private String memOTSTS;
	private String memOTAID;
	private boolean memFromOT_A;
	private boolean memFromOT_B;
	private boolean mem_OTA_no_PatNo;
	private boolean blnOT_LOG_LOCK;
	private String[] OT = null;
	private String lId = null;
	private int iPreIndex = -1;
	private boolean keepListTableRow = false;
	private boolean isProcessingReport = false;
	private String actMode;
	private boolean bisEdit = false;
	private boolean bisInsert = false;
	private String otAppDate = null;

	private JSONObject tplValueJSON = null;

	/**
	 * This method initializes
	 *
	 */
	public OTLogBook() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		if (getActionType() == null) {
			memOTLID = null;
		}

//		setNoGetDB(true);
		setLeftAlignPanel();
		getJScrollPane().setBounds(350, 35, 400, 370);
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		// fix cannot get other tab's fields value problem
		getTabbedPane().setSelectedIndexWithoutStateChange(0);

		// set visible
		if (Factory.getInstance().getUserInfo().getSiteCode().toUpperCase().equals("HKAH")) {
			getFERequestedDesc().setVisible(false);
			getFERequested().setVisible(false);
			getFEReceivedDesc().setVisible(false);
			getFEReceived().setVisible(false);
		} else {
			getFERequestedDesc().setVisible(true);
			getFERequested().setVisible(true);
			getFEReceivedDesc().setVisible(true);
			getFEReceived().setVisible(true);
		}

		otAppDate = EMPTY_VALUE;
		initControls();
		getParameter();
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextPatientNoSearch getDefaultFocusComponent() {
		return getPatNo();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
		getPatNo().setEditable(false);
		getDateOfOper().setEditable(false);
		getPatType().setEditable(false);
		enableCmdAction(true, true, true);
		getChange().setEnabled(false);
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
		return new String[] {};
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
	protected void getFetchOutputValues(String[] outParam) {}

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
		// unlock ot_log before exit
		if (OT_LOG_MODE_EDIT.equals(getParameter("MODE"))) {
			if ("A".equals(getParameter("OTSTS"))) {
				unlockRecord("OTLogBook", getParameter("OTLID"));
			}
		}
	}

	@Override
	protected void enableButton(String mode) {
		disableButton();

		// set button focus color
		if (OT_LOG_MODE_NEW.equals(mode)) {
			if (getPatNo().isEmpty()) {
				setAllFieldsReadOnly(true);

				getPatNo().setReadOnly(false);
				getSaveButton().setEnabled(true);
			} else {
				setAllFieldsReadOnly(false);
				enableCmdAction(false, false, false);
				getSaveButton().setEnabled(true);
				getCancelButton().setEnabled(true);
				getChange().setEnabled(false);
				if (getParameter("PATNO") == null || (getParameter("PATNO") != null && getParameter("PATNO").length() == 0)) {
					getPatNo().setReadOnly(false);
				} else {
					getPatNo().setReadOnly(true);
				}
			}
		} else if ("afterSave".equals(mode)) {
			setAllFieldsReadOnly(true);

			getModifyButton().setEnabled(true);
			getDeleteButton().setEnabled(true);
			getAppendButton().setEnabled(true);
			enableCmdAction(true, false, true);
			getChange().setEnabled(true);

			getPatNo().setReadOnly(true);
		} else if (PRINT_MODE.equals(mode)) {

		} else if (SEARCH_MODE.equals(mode)) {
			setAllFieldsReadOnly(true);

			getSearchButton().setEnabled(true);
			getAppendButton().setEnabled(!getPatNo().isMergePatientNo());
			enableCmdAction(false, false, false);
			getChange().setEnabled(false);

			// set all ready only
			getPatNo().setReadOnly(false);

			getConsignmentSearchButton().setEnabled(true);
			getConsignmentSystemButton().setEnabled(true);
		} else if (isFetch()) {
			setAllFieldsReadOnly(true);

			if (!OT_STS_CLOSE.equals(memOTSTS)) {
				getModifyButton().setEnabled(true);
				getDeleteButton().setEnabled(true);
				getChange().setEnabled(true);
			} else {
				getChange().setEnabled(false);
			}
			enableCmdAction(true, false, true);
		} else if (isModify()) {
			setAllFieldsReadOnly(false);

			getSaveButton().setEnabled(true);
			getCancelButton().setEnabled(true);
			enableCmdAction(true, true, true);
			getChange().setEnabled(false);

			getPatNo().setReadOnly(true);
			getDateOfOper().setEditable(false);
			getPatType().setEditable(false);

			addDefaultRows();
		} else if (isAppend()) {
			setAllFieldsReadOnly(false);

			getSearchButton().setEnabled(isSearchButtonEnabled());
			getSaveButton().setEnabled(true);
			getCancelButton().setEnabled(true);
			enableCmdAction(false, false, false);
			getChange().setEnabled(false);

			getPatNo().setReadOnly(true);
		} else {
			// Initial Status
			getSearchButton().setEnabled(isSearchButtonEnabled());
			enableCmdAction(false, false, false);
			getChange().setEnabled(false);
			getTabbedPane().setSelectedIndexWithoutStateChange(0);
			// enable browse panel
			setAllLeftFieldsEnabled(false);

			getPatNo().setReadOnly(false);
			getPatNo().setEditable(true);
		}

		getDOB().setReadOnly(true);
		getPatFName().setReadOnly(true);
		getPatGName().setReadOnly(true);
		getSex().setReadOnly(true);
		getPatCName().setReadOnly(true);

		getBFont().setEnabled(false);
		getIFont().setEnabled(false);
		getUFont().setEnabled(false);
		getCFont().setEnabled(false);

		enableButtonReport();
		isProcessingReport = false;
	}

	@Override
	public void searchAction() {
		// if validated
		loadOTLogBrowse();
	}

	@Override
	public void rePostAction() {
		if (getParameter("OTLID") != null) {
			getParameter();
		}
	}

	@Override
	public void appendPostAction() {
		resetOTInfo();
		bisInsert = true;
		enableButton();

		getDateOfOper().requestFocus();
	}

	@Override
	public void modifyPostAction() {
		bisEdit = true;
		bisInsert = true;
		enableButton();

		getOperRoom().requestFocus();
	}

	@Override
	protected void cancelYesAction() {
		if (getActionType() != null) {
			if (isAppend() || currentPatNo == null) {
				setActionType(null);
			} else {
				setActionType(QueryUtil.ACTION_FETCH);
			}
		}

		enableButton();
		if (getPatNo().getText().length() > 0) {
			getAppendButton().setEnabled(true);
		}
		confirmCancelButtonClicked();

		// call after all action done
		cancelPostAction();
	}

	@Override
	public void cancelPostAction() {
		lockDoctorProcedures(false);
		showOTLogDetail();
	}

	@Override
	public void saveAction() {
		saveAction(true);
	}

	private void saveAction(boolean check) {
		if (saveValidation(check)) {
			saveOT();
		}
	}

	@Override
	public void refreshAction() {
		showOTLogDetail();
	}

	@Override
	protected void lockRecordReady(final String lockType, final String lockKey, String[] record, boolean lock, String returnMessage) {
		if (lock) {
			blnOT_LOG_LOCK = true;
			setActionType(QueryUtil.ACTION_BROWSE);
			memFromOT_B = true;
			memOTLID = getParameter("OTLID");
			memOTSTS = getParameter("OTSTS");
			showOTLogDetail();
		} else {
			Factory.getInstance().addErrorMessage(returnMessage, "PBA-[OT Log Book]");
			setActionType(null);
			exitPanel();
		}
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	private String[] getDbArrayObjCodes() {
		// db array object
		return new String[] {
			"OTLOGPROC",
			"OTLOGPROC",
			"OTLOGMETH",
			"OTLOGMETH",
			"OTLOGSURG",
			"OTLOGSURG",
			"OTLOGANES",
			"OTLOGANES",
			"OTLOGTEAM",
			"OTLOGTEAM",
			"OTLOGIMPL",
			"OTLOGIMPL",
			"OTLOGEQUI",
			"OTLOGEQUI",
			"OTLOGINST",
			"OTLOGINST",
			"OTLOGDRUG",
			"OTLOGDRUG"
		};
	}

	private String[][][] getDbArrayObjVals() {
		// db array object
		return new String[][][] {
			getSecProcTable().getTableValues(),
			getDelSecProcTable().getTableValues(),
			getSecAnesTable().getTableValues(),
			getDelSecAnesTable().getTableValues(),
			getSecSurTable().getTableValues(),
			getDelSecSurTable().getTableValues(),
			getSecAnesManTable().getTableValues(),
			getDelSecAnesManTable().getTableValues(),
			getTeamTable().getTableValues(),
			getDelTeamTable().getTableValues(),
			getSelImpTable().getTableValues(),
			getDelSelImpTable().getTableValues(),
			getSelEquTable().getTableValues(),
			getDelSelEquTable().getTableValues(),
			getSelInsTable().getTableValues(),
			getDelSelInsTable().getTableValues(),
			getSelDrugTable().getTableValues(),
			getDelSelDrugTable().getTableValues()
		};
	}

	private String getTplValueJSON() {
		String lastDoccodePtn = "(\\([^\\(\\)]*\\))$";	// remove last doccode i.e. Jeff (1001) > Jeff

		tplValueJSON = new JSONObject();

		tplValueJSON.put("«PatientNo»", new JSONString(TextUtil.trimToEmpty(getPatNo().getText())));
		tplValueJSON.put("«PatFName»", new JSONString(TextUtil.trimToEmpty(getPatFName().getText())));
		tplValueJSON.put("«PatGName»", new JSONString(TextUtil.trimToEmpty(getPatGName().getText())));
		tplValueJSON.put("«PatCName»", new JSONString(TextUtil.trimToEmpty(getPatCName().getText())));

		tplValueJSON.put("«DOB»", new JSONString(TextUtil.trimToEmpty(getDOB().getText())));
		tplValueJSON.put("«PatientSex»", new JSONString(TextUtil.trimToEmpty(getSex().getText())));
		tplValueJSON.put("«DateOfOperation»", new JSONString(
				(TextUtil.trimToEmpty(this.getDateOfOper().getText())).substring(0, 10)));
		tplValueJSON.put("«OperationRoom»", new JSONString(TextUtil.trimToEmpty(getOperRoom().getDisplayText())));
		tplValueJSON.put("«SetupTime»", new JSONString(TextUtil.trimToEmpty(getSetupTime().getText())));
		tplValueJSON.put("«PatientType»", new JSONString(TextUtil.trimToEmpty(getPatType().getDisplayText())));
		tplValueJSON.put("«PatientIn»", new JSONString(TextUtil.trimToEmpty(getPatIn().getText())));
		tplValueJSON.put("«PatientOut»", new JSONString(TextUtil.trimToEmpty(getPatOut().getText())));
		tplValueJSON.put("«AnestheticsStart»", new JSONString(TextUtil.trimToEmpty(getAnesthStart().getText())));
		tplValueJSON.put("«AnestheticsEnd»", new JSONString(TextUtil.trimToEmpty(getAnesthEnd().getText())));
		tplValueJSON.put("«OperationStart»", new JSONString(TextUtil.trimToEmpty(getOperStart().getText())));
		tplValueJSON.put("«OperationEnd»", new JSONString(TextUtil.trimToEmpty(getOperEnd().getText())));
		tplValueJSON.put("«IntoRecovery»", new JSONString(TextUtil.trimToEmpty(getIntoRecovery().getText())));
		tplValueJSON.put("«LeftRecovery»", new JSONString(TextUtil.trimToEmpty(getLeftRecovery().getText())));
		tplValueJSON.put("«PhoneWardTime»", new JSONString(TextUtil.trimToEmpty(getPhoneWardTime().getText())));
		tplValueJSON.put("«Ward»", new JSONString(TextUtil.trimToEmpty(getWard().getDisplayText())));
		tplValueJSON.put("«CleanUpTime»", new JSONString(TextUtil.trimToEmpty(getCleanuptime().getText())));
		tplValueJSON.put("«ReasonForLate»", new JSONString(TextUtil.trimToEmpty(getReason().getDisplayText())));
		tplValueJSON.put("«SlipNumber»", new JSONString(TextUtil.trimToEmpty(getSlipNo().getText())));

		// Procedure
		tplValueJSON.put("«TourniquetOn»", new JSONString(TextUtil.trimToEmpty(getTourOn().getText())));
		tplValueJSON.put("«TourniquetOff»", new JSONString(TextUtil.trimToEmpty(getTourOff().getText())));
		tplValueJSON.put("«BloodType»", new JSONString(TextUtil.trimToEmpty(getBloodType().getDisplayText())));
		tplValueJSON.put("«ScheduleType»", new JSONString(TextUtil.trimToEmpty(getScheType().getDisplayText())));
		tplValueJSON.put("«Outcome»", new JSONString(TextUtil.trimToEmpty(getOutcome().getDisplayText())));
		tplValueJSON.put("«Dressing»", new JSONString(TextUtil.trimToEmpty(getDress().getDisplayText())));
		tplValueJSON.put("«Reason»", new JSONString(TextUtil.trimToEmpty(getReasonProc().getDisplayText())));
		tplValueJSON.put("«Specimens»", new JSONString(
				getSpecimens().isSelected() ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE));
		tplValueJSON.put("«SpecimenTo»", new JSONString(TextUtil.trimToEmpty(getSpecimenTo().getDisplayText())));
		tplValueJSON.put("«PrimaryProcedure»", new JSONString(TextUtil.trimToEmpty(getPrimaryProc().getDisplayText())));
		tplValueJSON.put("«SecondaryProcedure»", new JSONString(getTblVals2String(getSecProcTable(), new Integer[] {4}, 0)));
		tplValueJSON.put("«PrimaryAnestheticMethod»", new JSONString(TextUtil.trimToEmpty(getPrimaryAnes().getDisplayText())));
		tplValueJSON.put("«SecondaryAnestheticMethod»", new JSONString(getTblVals2String(getSecAnesTable(), new Integer[] {4}, 0)));
		tplValueJSON.put("«AnestheticsRemark»", new JSONString(TextUtil.trimToEmpty(getRemark().getText())));
		tplValueJSON.put("«Comments»", new JSONString(TextUtil.trimToEmpty(getComments().getText())));

		// manpower
		getPrimarySur().getDisplayText().replaceAll(lastDoccodePtn, "");
		tplValueJSON.put("«PrimarySurgeon»", new JSONString(TextUtil.trimToEmpty(getPrimarySur().getDisplayText()).replaceAll(lastDoccodePtn, "")));
		tplValueJSON.put("«SecondarySurgeon»", new JSONString(getTblVals2String(getSecSurTable(), new Integer[] {3}, 0)));
		tplValueJSON.put("«PrimaryAnesthetist»", new JSONString(TextUtil.trimToEmpty(getPrimaryAnesMan().getDisplayText()).replaceAll(lastDoccodePtn, "")));
		tplValueJSON.put("«SecondaryAnesthetist»", new JSONString(getTblVals2String(getSecAnesManTable(), new Integer[] {3}, 0)));
		tplValueJSON.put("«TeamMembers»", new JSONString(getTblVals2String(getTeamTable(), new Integer[] {2, 4}, 1)));

		// Material
		tplValueJSON.put("«ImplantDesc»", new JSONString(getTblVals2String(this.getSelImpTable(), new Integer[] {2, 3}, 0)));
		tplValueJSON.put("«EquipmentDesc»", new JSONString(getTblVals2String(this.getSelEquTable(), new Integer[] {2, 3}, 0)));
		tplValueJSON.put("«InstrumentDesc»", new JSONString(getTblVals2String(this.getSelInsTable(), new Integer[] {2, 3}, 0)));
		tplValueJSON.put("«DrugDesc»", new JSONString(getTblVals2String(this.getSelDrugTable(), new Integer[] {2, 6}, 0)));

		return tplValueJSON.toString();
	}

	private String getTblVals2String(TableList tbl, Integer[] colIdxs, int style) {
		String ret = "";
		if (tbl != null) {
			int size = tbl.getRowCount();
			int c = 0;
			for (int i = 0; i < size; i++) {
				ret += ret.isEmpty() ? "" : "\n";
				if (colIdxs != null) {
					ret += (c + 1) + ". ";
					for (int j = 0; j < colIdxs.length; j++) {
						int colIdx = colIdxs[j];
						String val = tbl.getRowContent(i)[colIdx];
						if (style == 1) {
							if (j > 0) {
								val = " (" + val + ")";
							}
						} else {
							if (j > 0) {
								val = " " + val;
							}
						}
						ret += val;
					}
				}
				c++;
			}
		}
		return ret;
	}

	private String getTblVals2String(EditorTableList tbl, Integer[] colIdxs, int style) {
		String ret = "";
		if (tbl != null) {
			int size = tbl.getRowCount();
			int c = 0;
			for (int i = 0; i < size; i++) {
				ret += ret.isEmpty() ? "" : "\n";
				if (colIdxs != null) {
					ret += (c + 1) + ". ";
					for (int j = 0; j < colIdxs.length; j++) {
						int colIdx = colIdxs[j];
						String val = tbl.getRowContent(i)[colIdx];
						if (style == 1) {
							if (j > 0) {
								val = " (" + val + ")";
							}
						} else {
							if (j > 0) {
								val = " " + val;
							}
						}
						ret += val;
					}
				}
				c++;
			}
		}
		return ret;
	}

	private void enableButtonReport() {
		if (isFetch()) {
			getCreateRpt().setEnabled(false);
			getModifyRpt().setEnabled(false);
			if (getListTable().getSelectedRow() > -1) {
				getViewRpt().setEnabled(true);
				getPrintRpt().setEnabled(true);
			} else {
				getViewRpt().setEnabled(false);
				getPrintRpt().setEnabled(false);
			}
		} else if (isModify()) {
			getCreateRpt().setEnabled(!isProcessingReport);
			if (getListTable().getSelectedRow() > -1) {
				getModifyRpt().setEnabled(true);
				getViewRpt().setEnabled(true);
				getPrintRpt().setEnabled(true);
			} else {
				getModifyRpt().setEnabled(false);
				getViewRpt().setEnabled(false);
				getPrintRpt().setEnabled(false);
			}
		} else if (isAppend()) {
			if (getListTable().getRowCount() == 0 && !isProcessingReport) {
				getCreateRpt().setEnabled(true);
			} else {
				getCreateRpt().setEnabled(false);
			}

			if (getListTable().getSelectedRow() > -1) {
				getModifyRpt().setEnabled(true);
			} else {
				getModifyRpt().setEnabled(false);
			}
			getViewRpt().setEnabled(false);
			getPrintRpt().setEnabled(false);
		} else {
			getCreateRpt().setEnabled(false);
			getModifyRpt().setEnabled(false);
			getViewRpt().setEnabled(false);
			getPrintRpt().setEnabled(false);
		}
	}

	private void loadOTLogBrowse() {
		setParameter("FROM", "OT_LOG_first");
		setParameter("PatNo", getPatNo().getText());
		showPanel(new com.hkah.client.tx.ot.OTLogBrowser(this));
	}

	private void initControls() {
		String txtCode = ConstantsTx.LOOKUP_TXCODE;
		String matCol = "'',OTCID, OTCDESC,'','',''";
		String orderBy = " ORDER BY OTCORD, OTCDESC";
		String table = "OT_CODE";

		getAvaImpTable().setListTableContent(txtCode, new String[] {table, matCol,"OTCTYPE = 'IM' AND OTCSTS = -1 " + orderBy});
		getAvaEquTable().setListTableContent(txtCode,new String[] {table, matCol,"OTCTYPE = 'EQ' AND OTCSTS = -1 " + orderBy});
		getAvaInsTable().setListTableContent(txtCode, new String[] {table, matCol,"OTCTYPE = 'IN' and OTCSTS = -1 " + orderBy});
		getAvaDrugTable().setListTableContent(txtCode, new String[] {table, "'',OTCID, OTCDESC,OTCNUM_1, OTCCHR_1,'','','',''","OTCTYPE = 'DG' AND OTCSTS = -1 " + orderBy});
		getAvaStaffTable().setListTableContent(txtCode, new String[] {table, matCol, "OTCTYPE = 'SF' AND OTCSTS = -1 " + orderBy});
		getFunctionTable().setListTableContent(txtCode, new String[] {table, matCol, "OTCTYPE = 'FN' AND OTCSTS = -1 " + orderBy});

		getListTable().getSelectionModel().addSelectionChangedListener(new SelectionChangedListener<TableData>() {
			public void selectionChanged(SelectionChangedEvent se) {
				enableButtonReport();
			}
		});
	}

	private void addDefaultRows() {
		if (getSecProcTable().getRowCount() == 0) {
			getSecProcTable().addRow(new Object[6]);
		}
	}

	private void getParameter() {
		setActionType(getParameter("ActionType"));
		otAppDate = getParameter("OTASDATE") == null?EMPTY_VALUE:getParameter("OTASDATE");
		resetParameter("OTASDATE");

		if (ConstantsProperties.OT == 1) {
			getChange().setVisible(true);
			getChange().setEnabled(false);
			memOTAID = getParameter("OTAID");

			if ("OTLogBrowse".equals(getParameter("FromOTLogBrowse"))) {
				getChange().setEnabled(true);
				String sPatType = getParameter("sPatType");
				if ("I".equalsIgnoreCase(sPatType)) {
					getPatType().select(1);
					setParameter("prePatType", "Inpatient");
					iPreIndex = 0;
				} else if ("O".equalsIgnoreCase(sPatType)) {
					getPatType().select(2);
					setParameter("prePatType", "Outpatient");
					iPreIndex = 1;
				} else if ("D".equalsIgnoreCase(sPatType)) {
					getPatType().select(3);
					setParameter("prePatType", "Day Case");
					iPreIndex = 2;
				}
			}
		} else {
			getChange().setVisible(false);
			getChange().setEnabled(true);
		}

		if (getParameter("PATNO") != null) {
			memOTLID = getParameter("OTLID");

			if (OT_LOG_MODE_EDIT.equals(getParameter("MODE"))) {
//				checkPatNo(getParameter("PATNO"));
				QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
						new String[] {"patient", "patno", "patno='" + getParameter("PATNO") + "'"},
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
//							getPatNo().setReadOnly(true);//set readonly
							memPatNo = getParameter("PATNO");
							getPatNo().setText(memPatNo);
							showPatientInfo(memPatNo, null);
							showOTLogDetail();
//							SetCmdAllergy Trim(txtPatNum.Text), cmdAllergy
						} else {
							Factory.getInstance().addErrorMessage("Invalid Patient No, please check.", getPatNo());
						}
					}
				});
//				if (checkPatNo(getParameter("PATNO"))) {
//					getPatNo().setEnabled(false);//set readonly
//					memPatNo = getParameter("PATNO");
//					getPatNo().setText(memPatNo);
//					showPatientInfo(memPatNo);
//					//SetCmdAllergy Trim(txtPatNum.Text), cmdAllergy
//				} else {
//					Factory.getInstance().addErrorMessage("Invalid Patient No, please check.");
//					return;
//				}
			}
			if (OT_LOG_MODE_NEW.equals(getParameter("MODE"))) {
				getParaAction(getParameter("MODE"));
			} else if (OT_LOG_MODE_EDIT.equals(getParameter("MODE"))) {
				getParaAction(getParameter("MODE"));
				enableCmdAction(true, false, true);
			}
		} else {
			setActionType(null);
			enableButton();
			getPatType().setSelectedIndex(1);
		}
	}

	private void showPatientInfo(final String patno, final String mode) {
		if (patno != null) {
			QueryUtil.executeMasterFetch(getUserInfo(), "PATIENTBYNO",
					new String[] {patno},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					showPatientInfoReady(mQueue, patno, mode);
					if (!OT_LOG_MODE_NEW.equals(mode)) {
						getAppendButton().setEnabled(true);
					}
				}
			});
		} else {
			showPatientInfoReady(null, patno, null);
		}
	}

	private void showPatientInfoReady(MessageQueue mQueue, String patno, String mode) {
		if (mQueue != null && mQueue.success()) {
			getPatFName().setText(mQueue.getContentField()[0]);
			getPatGName().setText(mQueue.getContentField()[1]);
			patIDNO = mQueue.getContentField()[2];
			getDOB().setText(mQueue.getContentField()[3]);
			getSex().setText(mQueue.getContentField()[5]);
			getPatCName().setText(mQueue.getContentField()[6]);

			currentPatNo = patno;
		} else {
			getPatFName().resetText();
			getPatGName().resetText();
			getDOB().resetText();
			getSex().resetText();
			getPatCName().resetText();

			currentPatNo = null;
		}
		enableButton(mode);
	}

	private void getParaAction(String mode) {
		if (OT_LOG_MODE_NEW.equals(mode)) {	//From App Browse
			memFromOT_A = true;
			mem_OTA_no_PatNo = true;

		QueryUtil.executeMasterFetch(
			Factory.getInstance().getUserInfo(), "OTAPP", new String[] {getParameter("OTAID")},
			new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						getFERequested().setText(mQueue.getContentField()[31]);
						getFEReceived().setText(mQueue.getContentField()[32]);

						if (getParameter("PATNO") == null || (getParameter("PATNO") != null && getParameter("PATNO").length() == 0)) {
							//doOT.Fields("OTAID") = doApp.Fields("OTAID")
							getDateOfOper().setText(mQueue.getContentField()[7].split(" ")[0]);
							getOperRoom().setSelectedIndex(mQueue.getContentField()[9]);
							getOperStart().setText(mQueue.getContentField()[7]);
							getOperEnd().setText(mQueue.getContentField()[8]);
							getPrimaryProc().setSelectedIndex(mQueue.getContentField()[10]);
							getPrimaryAnes().setSelectedIndex(mQueue.getContentField()[11]);

							getPrimarySur().setSelectedIndex(mQueue.getContentField()[12]);
							getPrimaryAnesMan().setSelectedIndex(mQueue.getContentField()[13]);
							getEndoscopist().setSelectedIndex(mQueue.getContentField()[26]);
							getReferralDoctor().setSelectedIndex(mQueue.getContentField()[28]);

							if ("I".equals(mQueue.getContentField()[23])) {
								getPatType().setSelectedIndex(1);
								getPatType().onBlur();
							} else if ("O".equals(mQueue.getContentField()[23])) {
								getPatType().setSelectedIndex(2);
								getPatType().onBlur();
							} else if ("D".equals(mQueue.getContentField()[23])) {
								getPatType().setSelectedIndex(3);
								getPatType().onBlur();
							}
							enableButton(OT_LOG_MODE_NEW);
						} else {
							checkPatNo(getParameter("PATNO"), mQueue);
						}
					} else {
						Factory.getInstance().addErrorMessage(mQueue.getReturnMsg());
					}
				}
			});
		}

		if (OT_LOG_MODE_EDIT.equals(mode)) {	//From OT Browse
			if ("A".equals(getParameter("OTSTS"))) {
				lockRecord("OTLogBook", getParameter("OTLID"));
			}
		}
	}

	private void checkPatNo(final String patNo, final MessageQueue otApp) {
		QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] {"patient", "patno", "patno='" + patNo + "'"},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					memPatNo = patNo;
					getPatNo().setText(memPatNo);
					showPatientInfo(memPatNo, OT_LOG_MODE_NEW);
					newOtLogAction(otApp);
				} else {
					Factory.getInstance().addErrorMessage("Invalid patient No.");
				}
			}
		});
	}

	private void newOtLogAction(MessageQueue doApp) {
		String dOperateDate = otAppDate;
		if (DateTimeUtil.isDate(getDateOfOper().getText().trim())) {
			int iYear = 0;
			iYear = Integer.parseInt(getDateOfOper().getText().split("/")[2]);
			if (iYear > 1900) {
				dOperateDate = getDateOfOper().getText();
			}
		}

		checkInPatDayCase(dOperateDate, doApp);
	}

	private void setCheckInPatDayCaseValue(MessageQueue doApp) {
		getPatNo().setReadOnly(true);
		actMode = OT_LOG_MODE_NEW;

		enableCmdAction(false, false, false);

		if (!memFromOT_A) {
//doOT.Fields("OTAID") = Null
		}
		getSlipNo().setText(memSLPNO);
//doOT.Fields("OTLSPEC") = 0
//doOT.Fields("OTLRODATE") = Null
//doOT.Fields("USRID_1") = Null
//doOT.Fields("USRID_2") = Null
		getPatNo().setText(memPatNo);
//doOT.Fields("OTLSTS") = OT_STS_ACTIVE


//doOT.Fields("OTAID") = doApp.Fields("OTAID")
		getDateOfOper().setText(doApp.getContentField()[7].split(" ")[0]);
		getOperRoom().setSelectedIndex(doApp.getContentField()[9]);
		getOperStart().setText(doApp.getContentField()[7]);
		getOperEnd().setText(doApp.getContentField()[8]);
		getPrimaryProc().setSelectedIndex(doApp.getContentField()[10]);
		getPrimaryAnes().setSelectedIndex(doApp.getContentField()[11]);

		getPrimarySur().setSelectedIndex(doApp.getContentField()[12]);
		getPrimaryAnesMan().setSelectedIndex(doApp.getContentField()[13]);
		getEndoscopist().setSelectedIndex(doApp.getContentField()[26]);
		getReferralDoctor().setSelectedIndex(doApp.getContentField()[28]);

		if ("I".equals(doApp.getContentField()[23])) {
			getPatType().setSelectedIndex(1);
			getPatType().onBlur();
		} else if ("O".equals(doApp.getContentField()[23])) {
			getPatType().setSelectedIndex(2);
			getPatType().onBlur();
		} else if ("D".equals(doApp.getContentField()[23])) {
			getPatType().setSelectedIndex(3);
			getPatType().onBlur();
		}

		getSecProcTable().setListTableContent(ConstantsTx.OTAPPPROC_OTLOG_TXCODE, new String[] {memOTAID});

		String txtCode=ConstantsTx.LOOKUP_TXCODE;
		String matCol="'','','',D.DOCFNAME ||' '|| D.DOCGNAME,OAS.DOCCODE";
		String orderBy=" ORDER BY OAS.DOCCODE";
		String table = "OT_APP_SURG OAS, DOCTOR D, OT_APP OA";

		getSecSurTable().setListTableContent(txtCode, new String[] {table,matCol,"OA.OTAID = OAS.OTAID AND OAS.DOCCODE = D.DOCCODE AND OAS.OTAID='"+memOTAID+"'"+orderBy});

		mem_OTA_no_PatNo = false;
	}

	private void checkInPatDayCase(final String dOperateDate, final MessageQueue doApp) {
		if (memPatNo.length() > 0 && !memPatNo.isEmpty()) {
			QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.OTACTIVESLIP_TXCODE,
					new String[] {memPatNo, "I", dOperateDate},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						memSLPNO = mQueue.getContentField()[0];
						memSlpType = mQueue.getContentField()[1];
						getPatType().setSelectedIndex(1);
						setCheckInPatDayCaseValue(doApp);
					} else {
						QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.OTACTIVESLIP_TXCODE,
								new String[] {memPatNo, "D", dOperateDate},
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									memSLPNO = mQueue.getContentField()[0];
									memSlpType = mQueue.getContentField()[1];
									getPatType().setSelectedIndex(2);
									setCheckInPatDayCaseValue(doApp);
								} else {
									QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.OTACTIVESLIP_TXCODE,
											new String[] {memPatNo, "O", dOperateDate},
											new MessageQueueCallBack() {
										@Override
										public void onPostSuccess(MessageQueue mQueue) {
											if (mQueue.success()) {
												memSLPNO = mQueue.getContentField()[0];
												memSlpType = mQueue.getContentField()[1];
												getPatType().setSelectedIndex(3);
												setCheckInPatDayCaseValue(doApp);
											} else {
												Factory.getInstance().addErrorMessage("Patient has not registered.");
												setActionType(null);
												exitPanel();
											}
										}
									});
								}
							}
						});
					}
				}
			});
		}
	}

	private void showOTLogDetail() {
		if (memOTLID == null) {
			return;
		}

		doOT();
		doSecond();
		getSelected();
		doDocProc();
		if (memOTLID != null) {
			//dataRequery(false);
		}
	}

	private void postShowOTLogDetail() {
		setActionType(QueryUtil.ACTION_FETCH);
		enableButton();
	}

	private void doOTReady(MessageQueue mQueue) {
		if (!mQueue.success()) {
			return;
		} else {
			OT = mQueue.getContentField();

			getDateOfOper().setText(OT[2]);
			getOperRoom().setText(OT[6]);
			getSetupTime().setText(OT[13]);
			getPatType().setText(OT[5]);
			getPatIn().setText(OT[14]);
			getPatOut().setText(OT[15]);
			getAnesthStart().setText(OT[16]);
			getAnesthEnd().setText(OT[17]);
			getOperStart().setText(OT[18]);
			getOperEnd().setText(OT[19]);
			getIntoRecovery().setText(OT[20]);
			getLeftRecovery().setText(OT[21]);
			getCleanuptime().setText(OT[22]);
			getPhoneWardTime().setText(OT[39]);
			getWard().setText(OT[7]);
			getReason().setText(OT[23]);
			getTourOn().setText(OT[24]);
			getTourOff().setText(OT[25]);
			getBloodType().setText(OT[26]);
			getScheType().setText(OT[27]);
			getOutcome().setText(OT[28]);
			getDress().setText(OT[29]);
			getReasonProc().setText(OT[30]);
			getSpecimens().setSelected("-1".equals(OT[31]));
			getSpecimenTo().setText(OT[32]);
			getRemark().setText(OT[37]);
			getComments().setText(rtf2Html(OT[38]));

			getSlipNo().setText(OT[4]);

			getPrimaryProc().setText(OT[33]);
			getPrimaryAnes().setText(OT[34]);
			getPrimarySur().setText(OT[35]);
			getPrimaryAnesMan().setText(OT[36]);
			getEndoscopist().setText(OT[40]);
			getReferralDoctor().setText(OT[41]);
			memOTSTS = OT[8];

			postShowOTLogDetail();
		}
	}

	private void doOTAction() {
		QueryUtil.executeMasterFetch(getUserInfo(), "OTLOGDETAIL", new String[] {getParameter("OTLID")}, new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				doOTReady(mQueue);
			}});
	}

	private void doOT() {
		memOTLID = getParameter("OTLID");
		doOTAction();
	}

	private void setAllFieldsReadOnly(boolean readOnly) {
		setAllLeftFieldsEnabled(!readOnly);
		getPatNo().setReadOnly(readOnly);
		getPrimaryProcSearch().setEnabled(false);
		PanelUtil.setAllFieldsReadOnly(getGeneralPanel(), readOnly);
		PanelUtil.setAllFieldsReadOnly(getProcedurePanel(), readOnly);
		PanelUtil.setAllFieldsReadOnly(getManpowerPanel(), readOnly);
		PanelUtil.setAllFieldsReadOnly(getMaterialPanel(), readOnly);
		PanelUtil.setAllFieldsReadOnly(getDoctorProceduresPanel(), readOnly);
		//PanelUtil.setAllFieldsReadOnly(getConsignmentPanel(), false);
	}

	private void doSecond() {
		getSecProcTable().setListTableContent(ConstantsTx.OTLOGPROC_TXCODE, new String[] {memOTLID});
		getSecAnesTable().setListTableContent(ConstantsTx.OTLOGMETH_TXCODE, new String[] {memOTLID});
		getSecSurTable().setListTableContent(ConstantsTx.OTLOGSURG_TXCODE, new String[] {memOTLID});
		getSecAnesManTable().setListTableContent(ConstantsTx.OTLOGANES_TXCODE, new String[] {memOTLID});
		getTeamTable().setListTableContent(ConstantsTx.OTLOGTEAM_TXCODE, new String[] {memOTLID});
		getSelImpTable().setListTableContent(ConstantsTx.OTLOGIMPL_TXCODE, new String[] {memOTLID});
		getSelEquTable().setListTableContent(ConstantsTx.OTLOGEQUI_TXCODE, new String[] {memOTLID});
		getSelInsTable().setListTableContent(ConstantsTx.OTLOGINST_TXCODE, new String[] {memOTLID});
		getSelDrugTable().setListTableContent(ConstantsTx.OTLOGDRUG_TXCODE, new String[] {memOTLID});

		getDelSecProcTable().removeAllRow();
		getDelSecAnesTable().removeAllRow();
		getDelSecSurTable().removeAllRow();
		getDelSecAnesManTable().removeAllRow();
		getDelTeamTable().removeAllRow();
		getDelSelImpTable().removeAllRow();
		getDelSelEquTable().removeAllRow();
		getDelSelInsTable().removeAllRow();
		getDelSelDrugTable().removeAllRow();

		removeExistRow(getAvaImpTable(), getSelImpTable());
		removeExistRow(getAvaEquTable(), getSelEquTable());
		removeExistRow(getAvaInsTable(), getSelInsTable());
		removeExistRow(getAvaDrugTable(), getSelDrugTable());
	}

	private void getSelected() {
	}

	private void doDocProc() {
		getReportTable().setListTableContent(ConstantsTx.LOOKUP_TXCODE, new String[] {"drpreport","drpid,otlid,drpdesc","otlid = '"+memOTLID+"'"});
/*
		if (ReportTable.getRowCount()>0) {
			for (int i=0;i<ReportTable.getRowCount();i++) {
				getListTable().setListTableContent("DRPREPORTDTLS",
						new String[] {ReportTable.getValueAt(i, 0).toString(),"Saved"});
			}

		}
*/
	}

	private void replaceRow(EditorTableList fromTable, TableList toTable, int rowIndex) {
		if (rowIndex<0)
			return;
		String[] selectedRow = fromTable.getRowContent(rowIndex);
		fromTable.removeRow(rowIndex);
		toTable.addRow(selectedRow);
	}

	private void replaceRow(TableList fromTable, EditorTableList toTable, int rowIndex) {
		if (rowIndex<0)
			return;
		String[] selectedRow = fromTable.getRowContent(rowIndex);
		fromTable.removeRow(rowIndex);
		toTable.addRow(selectedRow);
	}

	private void removeExistRow(TableList fromTable, EditorTableList toTable) {
		for (int i = 0; i < toTable.getRowCount(); i++) {
			for (int j = fromTable.getRowCount() - 1; j >= 0 ; j--) {
				if (toTable.getValueAt(i, 1) != null && toTable.getValueAt(i, 1).equals(fromTable.getValueAt(j, 1))) {
					fromTable.removeRow(j);
				}
			}
		}
	}

	private TableList getDelTable(String tableName) {
		if (ConstantsTx.OTLOGPROC_TXCODE.equals(tableName)) {
			return getDelSecProcTable();
		} else if (ConstantsTx.OTLOGANES_TXCODE.equals(tableName)) {
			return getDelSecAnesTable();
		} else if (ConstantsTx.OTLOGSURG_TXCODE.equals(tableName)) {
			return getDelSecSurTable();
		} else if (ConstantsTx.OTLOGMETH_TXCODE.equals(tableName)) {
			return getDelSecAnesManTable();
		} else if (ConstantsTx.OTLOGTEAM_TXCODE.equals(tableName)) {
			return getDelTeamTable();
		} else if (ConstantsTx.OTLOGIMPL_TXCODE.equals(tableName)) {
			return getDelSelImpTable();
		} else if (ConstantsTx.OTLOGEQUI_TXCODE.equals(tableName)) {
			return getDelSelEquTable();
		} else if (ConstantsTx.OTLOGINST_TXCODE.equals(tableName)) {
			return getDelSelInsTable();
		} else if (ConstantsTx.OTLOGDRUG_TXCODE.equals(tableName)) {
			return getDelSelDrugTable();
		}
		return null;
	}

	private void rowsToDel(TableList selTable, int rowIndex) {
		String tableName = selTable.getData(ConstantsVariable.NAME_VALUE);
		TableList delTable = getDelTable(tableName);
//		System.out.println("DEBUG rowsToDel delTable="+delTable+", rowIndex="+rowIndex);
		if (delTable != null) {
			String[] cals = selTable.getRowContent(rowIndex);
//			System.out.println("DEBUG cals="+cals +",len="+cals.length);
			for (int i = 0; i < cals.length; i++) {
//				System.out.println(" ["+i+"]="+cals[i]);
			}

			delTable.addRow(selTable.getRowContent(rowIndex));
		}
	}

	private void rowsToDel(EditorTableList selTable, int rowIndex) {
		String tableName = selTable.getData(ConstantsVariable.NAME_VALUE);
		TableList delTable = getDelTable(tableName);
//		System.out.println("DEBUG rowsToDel delTable="+delTable+", rowIndex="+rowIndex);
		if (delTable != null) {
			String[] cals = selTable.getRowContent(rowIndex);
//			System.out.println("DEBUG cals="+cals +",len="+cals.length);
			for (int i = 0; i < cals.length; i++) {
//				System.out.println(" ["+i+"]="+cals[i]);
			}

			delTable.addRow(selTable.getRowContent(rowIndex));
		}
	}

	private boolean saveValidation(boolean check) {
		getTabbedPane().setSelectedIndexWithoutStateChange(4);
		getTabbedPane().setSelectedIndexWithoutStateChange(3);
		getTabbedPane().setSelectedIndexWithoutStateChange(2);
		getTabbedPane().setSelectedIndexWithoutStateChange(1);
		getTabbedPane().setSelectedIndexWithoutStateChange(0);

		if (getPatNo().getText().trim().length() == 0) {
			Factory.getInstance().addErrorMessage("patient number is empty!" , getPatNo());
			return false;
		}
		if (!DateTimeUtil.isDate(getDateOfOper().getText().trim())) {
			Factory.getInstance().addErrorMessage("Invalid Operation date!", getDateOfOper());
			return false;
		}

		getTabbedPane().setSelectedIndexWithoutStateChange(2);

		if (getPrimarySur().getText().trim().length() == 0 && getSecSurTable().getRowCount() > 1) {
			Factory.getInstance().addErrorMessage("Surgeon Secondary should be empty!");
			return false;
		}
		if (getPrimarySur().isEmpty() && getEndoscopist().isEmpty()) {
			Factory.getInstance().addErrorMessage("Surgeon/Endoscopist are empty!", getPrimarySur());
			return false;
		}
		if (check && !getPrimarySur().isEmpty() && !getEndoscopist().isEmpty()) {
			MessageBoxBase.confirm(MSG_PBA_SYSTEM, "Surgeon/Endoscopist are in conflict, Continue?",
					new Listener<MessageBoxEvent>() {
				@Override
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						saveAction(false);
					}
				}
			});
			return false;
		}

		getTabbedPane().setSelectedIndexWithoutStateChange(0);

		if (ConstantsProperties.OT == 1) {
			if ("0".equals(getPatNo().getText())) {
				Factory.getInstance().addErrorMessage("Invalid patient no!");
				return false;
			}

			QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.OTACTIVESLIP_TXCODE,
					new String[] {getPatNo().getText(), getPatType().getText(), getDateOfOper().getText()},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success() && mQueue.getContentField().length > 1) {
						setParameter("PatTypIndex", getPatType().getText());
						setParameter("Pat_NO", getPatNo().getText());
						setParameter("reg_Date", getDateOfOper().getText());
						if (!bisEdit) {
							getDlgOTSltSlip().showDialog(getPatNo().getText(),
									getDateOfOper().getText().substring(0, 10), getPatType().getText());
						}
					} else {
						Factory.getInstance().addErrorMessage("No available slip number!");
					}
				}
			});
		}

		if ("".equals(memSLPNO)) {
			getTabbedPane().setSelectedIndexWithoutStateChange(0);
			Factory.getInstance().addErrorMessage("No exist slip number!");
			return false;
		}

		if (!checkOTValid()) {
			return false;
		}

		// Check GRID
		if (!checkGrid(getSecProcTable(), 3, "Secondary Procedure", 1)
				|| !checkGrid(getSecAnesTable(), 3, "Secondary Anesthetics Method", 1)
				|| !checkGrid(getSecSurTable(), 4, "Secondary Surgeon", 2)
				|| !checkGrid(getSecAnesManTable(), 4, "Secondary Anesthetist", 2)
				|| !checkGrid(getTeamTable(), 1, 3, "Team Memebers", 2)
				|| !checkGridDrug(getSelDrugTable(), 3)) {
			return false;
		}

		//bShowDocInactiveMsg = false;

		return true;
	}

	private boolean checkOTValid() {
		boolean success = true;
		StringBuffer errorStr = new StringBuffer();
		Component comp = null;
		int focusTab = -1;
		int errorCount = 0;

		if (getDateOfOper().getText().isEmpty()) {
			errorStr.append("Date of Operation");
			if (comp == null) {
				comp = getDateOfOper();
				focusTab = 0;
			}
			errorCount++;
			success = false;
		}
		if (getSlipNo().getText().isEmpty()) {
			if (errorStr.length() > 0) {
				errorStr.append(COMMA_VALUE);
				errorStr.append(SPACE_VALUE);
			}
			errorStr.append("Slip No");
			if (comp == null) {
				comp = getSlipNo();
				focusTab = 0;
			}
			errorCount++;
			success = false;
		}
		if (getOperRoom().getText().isEmpty()) {
			if (errorStr.length() > 0) {
				errorStr.append(COMMA_VALUE);
				errorStr.append(SPACE_VALUE);
			}
			errorStr.append("Operation Room");
			if (comp == null) {
				comp = getOperRoom();
				focusTab = 0;
			}
			errorCount++;
			success = false;
		}
		if ("I".equals(memSlpType) && getWard().getText().isEmpty()) {
			if (errorStr.length() > 0) {
				errorStr.append(COMMA_VALUE);
				errorStr.append(SPACE_VALUE);
			}
			errorStr.append("Ward");
			if (comp == null) {
				comp = getWard();
				focusTab = 0;
			}
			errorCount++;
			success = false;
		}
		if (getScheType().getText().isEmpty()) {
			if (errorStr.length() > 0) {
				errorStr.append(COMMA_VALUE);
				errorStr.append(SPACE_VALUE);
			}
			errorStr.append("Schedule Type");
			if (comp == null) {
				comp = getScheType();
				focusTab = 1;
			}
			errorCount++;
			success = false;
		}
		if (getOutcome().getText().isEmpty()) {
			if (errorStr.length() > 0) {
				errorStr.append(COMMA_VALUE);
				errorStr.append(SPACE_VALUE);
			}
			errorStr.append("Outcome");
			if (comp == null) {
				comp = getOutcome();
				focusTab = 1;
			}
			errorCount++;
			success = false;
		}
		if (getPrimaryProc().getText().isEmpty()) {
			if (errorStr.length() > 0) {
				errorStr.append(COMMA_VALUE);
				errorStr.append(SPACE_VALUE);
			}
			errorStr.append("Primary Procedure");
			if (comp == null) {
				comp = getPrimaryProc();
				focusTab = 1;
			}
			errorCount++;
			success = false;
		}
		if (getPrimaryAnes().getText().isEmpty()) {
			if (errorStr.length() > 0) {
				errorStr.append(COMMA_VALUE);
				errorStr.append(SPACE_VALUE);
			}
			errorStr.append("Primary Anesthetics Method");
			if (comp == null) {
				comp = getPrimaryAnes();
				focusTab = 1;
			}
			errorCount++;
			success = false;
		}
		if (getPrimaryAnesMan().getText().isEmpty()) {
			if (errorStr.length() > 0) {
				errorStr.append(COMMA_VALUE);
				errorStr.append(SPACE_VALUE);
			}
			errorStr.append("Primary Anesthetist");
			if (comp == null) {
				comp = getPrimaryAnesMan();
				focusTab = 2;
			}
			errorCount++;
			success = false;
		}

		if (!success) {
			getTabbedPane().setSelectedIndexWithoutStateChange(focusTab);
			if (errorCount <= 1) {
				errorStr.append(" is");
			} else {
				errorStr.append(" are");
			}
			errorStr.append(" mandatory field(s).");
			Factory.getInstance().addErrorMessage(errorStr.toString(), comp);
		}

		return success;
	}

	private boolean checkGrid(TableList table, int keyField, String tableName, int tabNo) {
		if (table.getRowCount() > 1) {
			for (int i = 0; i < table.getRowCount() - 1; i++) {
				for (int j = i + 1; j < table.getRowCount(); j++) {
					if (table.getRowContent(i)[keyField].equals(table.getRowContent(j)[keyField])) {
						Factory.getInstance().addErrorMessage("Duplicate entries in grid " + tableName + ".");
						getTabbedPane().setSelectedIndexWithoutStateChange(tabNo);
						return false;
					}
				}
			}
		}
		return true;
	}

	private boolean checkGrid(TableList table, int keyField1, int keyField2, String tableName, int tabNo) {
		if (table.getRowCount() > 1) {
			for (int i = 0; i < table.getRowCount() - 1; i++) {
				for (int j = i + 1; j < table.getRowCount(); j++) {
					if (table.getRowContent(i)[keyField1].equals(table.getRowContent(j)[keyField1])
							&& table.getRowContent(i)[keyField2].equals(table.getRowContent(j)[keyField2])) {
						Factory.getInstance().addErrorMessage("Duplicate entries in grid " + tableName + ".");
						getTabbedPane().setSelectedIndexWithoutStateChange(tabNo);
						return false;
					}
				}
			}
		}
		return true;
	}

	private boolean checkGrid(EditorTableList table, int keyField, String tableName, int tabNo) {
		String field1 = null;
		String field2 = null;
		if (table.getRowCount() > 1) {
			for (int i = 0; i < table.getRowCount() - 1; i++) {
				for (int j = i + 1; j < table.getRowCount(); j++) {
					field1 = getUpdatedContent(table, i, keyField).trim();
					field2 = getUpdatedContent(table, j, keyField).trim();
					if (field1.length() == 0 || field2.length() == 0) {
						Factory.getInstance().addErrorMessage("Empty entries in grid " + tableName + ".");
						getTabbedPane().setSelectedIndexWithoutStateChange(tabNo);
						return false;
					} else if (field1.equals(field2)) {
						Factory.getInstance().addErrorMessage("Duplicate entries in grid " + tableName + ".");
						getTabbedPane().setSelectedIndexWithoutStateChange(tabNo);
						return false;
					}
				}
			}
		}
		return true;
	}

	private boolean checkGridDrug(EditorTableList table, int tabNo) {
		String qty = null;

//		List<TableData> tableList = table.getStore().getModels();
//		int iCurrent = tableList.size();
		final ListStore<TableData> store = table.getStore();

		for (int i = 0; i < table.getRowCount(); i++) {
			if (table.getRowContent(i)[1] == null || table.getRowContent(i)[1].length() == 0) {
				Factory.getInstance().addErrorMessage("Drug is missing in grid Drug.");
				getTabbedPane().setSelectedIndexWithoutStateChange(tabNo);
				return false;
			}

			if (table.getRowContent(i)[3] == null || table.getRowContent(i)[3].length() == 0) {
				Factory.getInstance().addErrorMessage("Cost is missing in grid Drug.");
				getTabbedPane().setSelectedIndexWithoutStateChange(tabNo);
				return false;
			}

			if (table.getRowContent(i)[4] == null || table.getRowContent(i)[4].length() == 0) {
				Factory.getInstance().addErrorMessage("Unit is missing in grid Drug.");
				getTabbedPane().setSelectedIndexWithoutStateChange(tabNo);
				return false;
			}

			final TableData rowData = store.getAt(i);

			try {
				qty = rowData.get(TableUtil.getName2ID("Qty")).toString();
			} catch ( Exception e) {
				qty = null;
			}

			if (qty == null || qty.trim().length() == 0) {
				Factory.getInstance().addErrorMessage("Quantity is missing in grid Drug.");
				getTabbedPane().setSelectedIndexWithoutStateChange(tabNo);
				return false;
			}
		}
		return true;
	}

	private String getUpdatedContent(EditorTableList table, int rowIndex, int colIndex) {
		table.getView().ensureVisible(rowIndex, colIndex, true);
//		System.err.println("[getUpdatedContent][rowIndex]:"+rowIndex+";[colIndex]:"+colIndex);
		return table.getRowContent(rowIndex)[colIndex];
	}

	private void saveOT() {
		String[] parm = new String[] {
				// 1
				memOTLID,
				getDateOfOper().getText(),
				getPatNo().getText(),
				getOperRoom().getText(),
				// 5
				getWard().getText(),
				getUserInfo().getUserID(),
				getSetupTime().getText(),
				getPatIn().getText(),
				getPatOut().getText(),
				// 10
				getAnesthStart().getText(),
				getAnesthEnd().getText(),
				getOperStart().getText(),
				getOperEnd().getText(),
				getIntoRecovery().getText(),
				// 15
				getLeftRecovery().getText(),
				getCleanuptime().getText(),
				getReason().getText(),
				getTourOn().getText(),
				getTourOff().getText(),
				// 20
				getBloodType().getText(),
				getScheType().getText(),
				getOutcome().getText(),
				getDress().getText(),
				getReasonProc().getText(),
				// 25
				getSpecimens().isSelected()? "-1":"0",
				getSpecimenTo().getText(),
				getPrimaryProc().getText(),
				getPrimaryAnes().getText(),
				getPrimarySur().getText(),
				// 30
				getPrimaryAnesMan().getText(),
				getRemark().getText(),
				html2Rtf(getComments().getText()),
				getPhoneWardTime().getText(),
				getEndoscopist().getText(),
				// 35
				getReferralDoctor().getText(),
				getFERequested().getText(),
				getFEReceived().getText(),
				memOTAID,
				memSLPNO
				// table
		};

		preProcessDbArrayObj();
		QueryUtil.executeMasterAction(getUserInfo(), getTxCode(),
				getActionType(), parm, getDbArrayObjCodes(), getDbArrayObjVals(),
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					bisInsert = false;
					bisEdit = false;
					if (QueryUtil.ACTION_APPEND.equals(getActionType())) {
						memOTLID = mQueue.getReturnCode();
						setParameter("OTLID", mQueue.getReturnCode());
					}
					saveOTA();
				} else {
					savePostAction(false, mQueue);
				}
			}
		});
	}

	private void resetOTInfo() {
		memOTLID = "";
		getDateOfOper().clear();
		getOperRoom().clear();
		getWard().clear();
		getSetupTime().clear();
		getPatIn().clear();
		getPatOut().clear();
		getAnesthStart().clear();
		getAnesthEnd().clear();
		getOperStart().clear();
		getOperEnd().clear();
		getIntoRecovery().clear();
		getLeftRecovery().clear();
		getCleanuptime().clear();
		getReason().clear();
		getTourOn().clear();
		getTourOff().clear();
		getBloodType().clear();
		getScheType().clear();
		getOutcome().clear();
		getDress().clear();
		getReasonProc().clear();
		getSpecimens().clear();
		getSpecimenTo().clear();
		getPrimaryProc().clear();
		getPrimaryAnes().clear();
		getPrimarySur().clear();
		getPrimaryAnesMan().clear();
		getRemark().clear();
		getComments().clear();
		getPhoneWardTime().clear();
		getEndoscopist().clear();
		getReferralDoctor().clear();

		getSecProcTable().removeAllRow();
		getDelSecProcTable().removeAllRow();
		getSecAnesTable().removeAllRow();
		getDelSecAnesTable().removeAllRow();
		getSecSurTable().removeAllRow();
		getDelSecSurTable().removeAllRow();
		getSecAnesManTable().removeAllRow();
		getDelSecAnesManTable().removeAllRow();
		getTeamTable().removeAllRow();
		getDelTeamTable().removeAllRow();
		getSelImpTable().removeAllRow();
		getDelSelImpTable().removeAllRow();
		getSelEquTable().removeAllRow();
		getDelSelEquTable().removeAllRow();
		getSelInsTable().removeAllRow();
		getDelSelInsTable().removeAllRow();
		getSelDrugTable().removeAllRow();
		getDelSelDrugTable().removeAllRow();
	}

	private void preProcessDbArrayObj() {
		// remove blank rows
		getSecProcTable().removeBlankRow(true);
		getDelSecProcTable().removeBlankRow(true);
		getSecAnesTable().removeBlankRow(true);
		getDelSecAnesTable().removeBlankRow(true);
		getSecSurTable().removeBlankRow(true);
		getDelSecSurTable().removeBlankRow(true);
		getSecAnesManTable().removeBlankRow(true);
		getDelSecAnesManTable().removeBlankRow(true);
		getTeamTable().removeBlankRow(true);
		getDelTeamTable().removeBlankRow(true);
		getSelImpTable().removeBlankRow(true);
		getDelSelImpTable().removeBlankRow(true);
		getSelEquTable().removeBlankRow(true);
		getDelSelEquTable().removeBlankRow(true);
		getSelInsTable().removeBlankRow(true);
		getDelSelInsTable().removeBlankRow(true);
		getSelDrugTable().removeBlankRow(true);
		getDelSelDrugTable().removeBlankRow(true);
	}

	private void saveOTA() {
		if (memFromOT_A && memOTAID != null && memOTAID.length() > 0) {

			QueryUtil.executeMasterAction(getUserInfo(), "OTAPP",
					QueryUtil.ACTION_MODIFY, new String[] {OT_APPSTS_F, memOTAID});

			if (mem_OTA_no_PatNo) {
				QueryUtil.executeMasterAction(getUserInfo(), ConstantsTx.UPDATE_TXCODE,
						QueryUtil.ACTION_MODIFY, new String[] {"OT_APP",
								"PATNO = '"+getPatNo().getText()+"',otaFName='"+getPatFName().getText()+"',otaGName='"+getPatGName().getText()+
								"',otaHKID='"+patIDNO+"',otasex='"+getSex().getText()+"',otaBDate=to_date('"+
								getDOB().getText()+"','dd/mm/yyyy')",
								"OTAID ='"+memOTAID+"'"});

				mem_OTA_no_PatNo = false;
			}
		}
		savePostAction(true, null);
	}

	private void savePostAction(boolean success, MessageQueue mQueue) {
		if (success) {
			setActionType(null);
			//showOTLogDetail();
			getTabbedPane().setSelectedIndexWithoutStateChange(0);
			//enableCmdAction(true,false,true);

			enableButton("afterSave");
			//getChange().setEnabled(true);
			// Doctor Procedures Report
			Factory.getInstance().addInformationMessage("OT Log Saved.");

			// refresh
			showOTLogDetail();
		} else {
			Factory.getInstance().addErrorMessage("OT Log Save Failed due to " + mQueue.getReturnMsg());
		}
	}

	private void enableCmdAction(boolean flag1, boolean flag2, boolean flag3) {
		getCharges().setEnabled(flag1);
		getCloseLog().setEnabled(flag2);
		getPrintLog().setEnabled(flag3);
	}

	private void selTableRemoveItem(EditorTableList selTable, TableList avaTable) {
		if (!selTable.isEditing()) {
			rowsToDel(selTable, selTable.getSelectedRow());
			replaceRow(selTable, avaTable, selTable.getSelectedRow());
			selTable.getView().refresh(true);
		}
	}

	private void controlTableColEditing(EditorTableList table) {
		if (!isModify() && !isAppend()) {
			table.stopEditing(true);
		}
	}

	private void refreshSlipNumber() {
		String dOperateDate = otAppDate;
		memSLPNO = "";
		if (DateTimeUtil.isDate(getDateOfOper().getText().trim())) {
			int iYear = 0;
			iYear = Integer.parseInt(getDateOfOper().getText().split("/")[2]);
			if (iYear > 1900) {
				dOperateDate = getDateOfOper().getText();
			}

			QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.OTACTIVESLIP_TXCODE,
					new String[] {memPatNo, getPatType().getText(), dOperateDate},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						memSLPNO = mQueue.getContentField()[0];
						getSlipNo().setText(memSLPNO);
						memSlpType = mQueue.getContentField()[1];
					} else {
						memSLPNO = "";
						getSlipNo().resetText();
						memSlpType = "";
					}
				}
			});
		} else {
			if (getDateOfOper().getText().trim().isEmpty() == false) {
				Factory.getInstance().addErrorMessage("Invalid Operation date!");
			}
		}
	}

	private void clearPatientInfo() {
		memSLPNO = "";
		memPatNo = "";
		memSlpType = "";

		getPatFName().resetText();
		getPatGName().resetText();
		getDOB().resetText();
		getSex().resetText();
		getPatCName().resetText();

		currentPatNo = null;
	}

	@Override
	public void deleteAction() {
		if (memOTLID == null)
			return;

		MessageBoxBase.confirm(MSG_PBA_SYSTEM, "Are you sure to delete this OT Log?",new Listener<MessageBoxEvent>() {
			public void handleEvent(MessageBoxEvent be) {
				if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
					QueryUtil.executeMasterAction(getUserInfo(), ConstantsTx.UPDATE_TXCODE,
							QueryUtil.ACTION_MODIFY, new String[] {"OT_LOG", "OTLSTS = '"+ConstantsGlobal.OT_STS_DELETE+"'", "OTLID ='" + memOTLID + "'"},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							setParameter("OTSTS", ConstantsGlobal.OT_STS_DELETE);
							Factory.getInstance().addInformationMessage("OT Log deleted.");
							memOTSTS = ConstantsGlobal.OT_STS_DELETE;
							exitPanel(true);
						}

						@Override
						public void onFailure(Throwable caught) {
							Factory.getInstance().addErrorMessage("Error in delete OT Log.");
						}
					});
				}
			}
		});
		//super.deleteAction();
	}

	/* >>> process procedure template ========================== <<< */
	public void lockDoctorProcedures(boolean editing) {
		// lock tables
		getReportTable().setEnabled(false);
		if (editing) {
			getTabbedPane().setSelectedIndexWithoutStateChange(4);
		}
		enableButtonReport();
	}

	public static String getAppletName() {
		return Factory.getInstance().getPrtAppletName();
	}

	public static native String openTmp(String otlid) /*-{
		var appletName = @com.hkah.client.tx.ot.OTLogBook::getAppletName()();
		if (appletName == '') {
			alert('Cannot load applet: ' + appletName);
			return;
		}

		var applet = $wnd.document.getElementById(appletName);
		return applet.openReport(otNo, seqNo, version, regID, patNo, path,
			readOnly, user);
	}-*/;

	private String html2Rtf(String text) {
		return text;
	}

	private String rtf2Html(String text) {
		StringBuffer strBuf = new StringBuffer();

		if (text != null && text.length() > 0) {
			String[] record = TextUtil.split(text, LINE_FEED);
			int index = -1;
			for (int i = 0; i < record.length; i++) {
				if (record[i].indexOf(RTF_PREFIX) >= 0 || record[i].indexOf(RTF_SUFFIX) >= 0) {
					continue;
				} else if (record[i].indexOf(RTF_BODY) >= 0) {
					index = record[i].indexOf(SPACE_VALUE);
					if (index > 0) {
						strBuf.append(record[i].substring(index + 1));
					}
				} else {
					strBuf.append(record[i]);
				}
			}
		}
		return strBuf.toString();
	}

	/*
	 * BufferedTableList addRow() method is not working...
	 * (non-Javadoc)
	 * @see com.hkah.client.tx.MasterPanelBase#isTableViewOnly()
	 */
	@Override
	public boolean isTableViewOnly() {
		return false;
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	@Override
	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.setSize(779, 460);
			leftPanel.add(getTabbedPane(), null);
		}
		return leftPanel;
	}

	protected BasePanel getRightPanel() {
		if (rightPanel == null) {
			rightPanel = new BasePanel();
		}
		return rightPanel;
	}

	private TabbedPaneBase getTabbedPane() {
		if (TabbedPane == null) {
			TabbedPane = new TabbedPaneBase() {
				@Override
				public void onStateChange() {
					String patno = getPatNo().getText();
					if (TabbedPane.getSelectedIndex() > 0 && (patno == null || patno.length() == 0)) {
						Factory.getInstance().addErrorMessage("Please search with a patient.");
						TabbedPane.setSelectedIndexWithoutStateChange(0);
						return;
					}
					/*
					if(TabbedPane.getSelectedIndex() == 5){
						showConsignmentSystem();
					}*/
				}
			};
			TabbedPane.setBounds(0, 1, 779, 580);
			TabbedPane.addTab("General", getGeneralPanel(), !getMainFrame().isDisaCmdNameOfOTLogBookFrm("TabOT", "General Tab"));
			TabbedPane.addTab("Procedures", getProcedurePanel(), !getMainFrame().isDisaCmdNameOfOTLogBookFrm("TabOT", "Procedures Tab"));
			TabbedPane.addTab("Manpower", getManpowerPanel(), !getMainFrame().isDisaCmdNameOfOTLogBookFrm("TabOT", "Manpower Tab"));
			TabbedPane.addTab("Material", getMaterialPanel(), !getMainFrame().isDisaCmdNameOfOTLogBookFrm("TabOT", "Material Tab"));
			TabbedPane.addTab("Doctor Procedures", getDoctorProceduresPanel());
			TabbedPane.addTab("Implant Tracking System", getConsignmentPanel());
//			TabbedPane.addTab("Registration", getRegPanel());
		}
		return TabbedPane;
	}

	private BasePanel getGeneralPanel() {
		if (GeneralPanel == null) {
			GeneralPanel = new BasePanel();
			GeneralPanel.setBounds(10, 10, 779, 431);
			GeneralPanel.add(getGenPatPanel(), null);
			GeneralPanel.add(getDateOfOperDesc(), null);
			GeneralPanel.add(getDateOfOper(), null);
			GeneralPanel.add(getOperRoomDesc(), null);
			GeneralPanel.add(getOperRoom(), null);
			GeneralPanel.add(getSetupTimeDesc(), null);
			GeneralPanel.add(getSetupTime(), null);
			GeneralPanel.add(getPatType(), null);
			GeneralPanel.add(getPatInDesc(), null);
			GeneralPanel.add(getPatIn(), null);
			GeneralPanel.add(getPatOutDesc(), null);
			GeneralPanel.add(getPatOut(), null);
			GeneralPanel.add(getAnesthStartDesc(), null);
			GeneralPanel.add(getAnesthStart(), null);
			GeneralPanel.add(getAnesthEndDesc(), null);
			GeneralPanel.add(getAnesthEnd(), null);
			GeneralPanel.add(getOperStartDesc(), null);
			GeneralPanel.add(getOperStart(), null);
			GeneralPanel.add(getOperEndDesc(), null);
			GeneralPanel.add(getIntoRecoveryDesc(), null);
			GeneralPanel.add(getIntoRecovery(), null);
			GeneralPanel.add(getLeftRecoveryDesc(), null);
			GeneralPanel.add(getPhoneWardTimeDesc(), null);
			GeneralPanel.add(getWardDesc(), null);
			GeneralPanel.add(getWard(), null);
			GeneralPanel.add(getCleanuptimeDesc(), null);
			GeneralPanel.add(getCleanuptime(), null);
			GeneralPanel.add(getReasonDesc(), null);
			GeneralPanel.add(getReason(), null);
			GeneralPanel.add(getSlipNoDesc(), null);
			GeneralPanel.add(getSlipNo(), null);
			GeneralPanel.add(getCharges(), null);
			GeneralPanel.add(getCloseLog(), null);
			GeneralPanel.add(getPrintLog(), null);
			GeneralPanel.add(getChange(), null);
			GeneralPanel.add(getPhoneWardTime(), null);
			GeneralPanel.add(getOperEnd(), null);
			GeneralPanel.add(getPatTypeDesc(), null);
			GeneralPanel.add(getLeftRecovery(), null);
		}
		return GeneralPanel;
	}

	private BasePanel getGenPatPanel() {
		if (GenPatPanel == null) {
			GenPatPanel = new BasePanel();
			GenPatPanel.add(getPatNoDesc(), null);
			GenPatPanel.add(getPatNo(), null);
			GenPatPanel.add(getPatNameDesc(), null);
			GenPatPanel.add(getPatFName(), null);
			GenPatPanel.add(getPatGName(), null);
			GenPatPanel.add(getPatCName(), null);
			GenPatPanel.add(getDOBDesc(), null);
			GenPatPanel.add(getDOB(), null);
			GenPatPanel.add(getSexDesc(), null);
			GenPatPanel.add(getSex(), null);
			GenPatPanel.add(getAllergy(), null);
			GenPatPanel.setLocation(10, 10);
			GenPatPanel.setSize(751, 72);
			GenPatPanel.setBorders(true);
		}
		return GenPatPanel;
	}

	private LabelBase getPatNoDesc() {
		if (PatNoDesc == null) {
			PatNoDesc = new LabelBase();
			PatNoDesc.setText("Patient No");
			PatNoDesc.setBounds(10, 10, 114, 20);
		}
		return PatNoDesc;
	}

	public TextPatientNoSearch getPatNo() {
		if (PatNo == null) {
			PatNo = new TextPatientNoSearch() {
				@Override
				public void onBlur() {
					super.onBlur();
					boolean isReadOnly = this.isReadOnly();
					if (!PatNo.isEmpty() && !PatNo.isReadOnly()) {
						if (PatNo.getText().startsWith("R")) {
							showPatientInfo(null, null);
							memPatNo = null;
							memSLPNO = null;
							memSlpType = null;
							currentPatNo = null;
						} else {
							if (QueryUtil.ACTION_APPEND.equals(getActionType())) {
								showPatientInfo(PatNo.getText(), OT_LOG_MODE_NEW);
							} else {
								showPatientInfo(PatNo.getText(), SEARCH_MODE);
							}
						}
					}

					if (memSLPNO == null || memSLPNO.length() == 0) {
						memPatNo = PatNo.getText();

						String dOperateDate = otAppDate;
						if (DateTimeUtil.isDate(getDateOfOper().getText().trim())) {
							int iYear = 0;
							iYear = Integer.parseInt(getDateOfOper().getText().split("/")[2]);
							if (iYear > 1900) {
								dOperateDate = getDateOfOper().getText();
							}
						}

						QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.OTACTIVESLIP_TXCODE,
								new String[] {memPatNo, getPatType().getText(), dOperateDate},
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									memSLPNO = mQueue.getContentField()[0];
									getSlipNo().setText(memSLPNO);
									memSlpType = mQueue.getContentField()[1];
								} else {
									memSLPNO = "";
									memSlpType = "";
									getSlipNo().setText(memSLPNO);
								}
							}
						});
					}
					this.setReadOnly(isReadOnly);
				};

				@Override
				public void onPressed() {
					if (!PatNo.isEmpty() && !PatNo.isReadOnly()) {
						clearPatientInfo();
					}
					/*
					if (!PatNo.isReadOnly() && currentPatNo != null && currentPatNo.length() > 0) {
						if (QueryUtil.ACTION_APPEND.equals(getActionType())) {
							showPatientInfo(PatNo.getText(), OT_LOG_MODE_NEW);
						} else {
							showPatientInfo(PatNo.getText(), SEARCH_MODE);
						}
						currentPatNo = null;
						memSLPNO = "";
						getSlipNo().setText(memSLPNO);
					}
					*/
				}
			};
			PatNo.setBounds(123, 10, 116, 20);
		}
		return PatNo;
	}

	private LabelBase getPatNameDesc() {
		if (PatNameDesc == null) {
			PatNameDesc = new LabelBase();
			PatNameDesc.setText("Name");
			PatNameDesc.setBounds(274, 10, 95, 20);
		}
		return PatNameDesc;
	}

	public TextReadOnly getPatFName() {
		if (PatFName == null) {
			PatFName = new TextReadOnly();
			PatFName.setBounds(367, 9, 120, 20);
		}
		return PatFName;
	}

	public TextReadOnly getPatGName() {
		if (PatGName == null) {
			PatGName = new TextReadOnly();
			PatGName.setBounds(495, 9, 128, 20);
		}
		return PatGName;
	}

	public TextReadOnly getPatCName() {
		if (PatCName == null) {
			PatCName = new TextReadOnly();
			PatCName.setBounds(630, 9, 73, 20);
		}
		return PatCName;
	}

	private LabelBase getDOBDesc() {
		if (DOBDesc == null) {
			DOBDesc = new LabelBase();
			DOBDesc.setText("D.O.B.");
			DOBDesc.setBounds(10, 40, 114, 20);
		}
		return DOBDesc;
	}

	public TextReadOnly getDOB() {
		if (DOB == null) {
			DOB = new TextReadOnly();
			DOB.setBounds(123, 40, 116, 20);
		}
		return DOB;
	}

	private LabelBase getSexDesc() {
		if (SexDesc == null) {
			SexDesc = new LabelBase();
			SexDesc.setText("Sex");
			SexDesc.setBounds(274, 40, 95, 20);
		}
		return SexDesc;
	}

	public TextReadOnly getSex() {
		if (Sex == null) {
			Sex = new TextReadOnly();
			Sex.setBounds(367, 40, 120, 20);
		}
		return Sex;
	}

	private ButtonBase getAllergy() {
		if (Allergy == null) {
			Allergy = new ButtonBase() {
				@Override
				public void onClick() {
					Factory.getInstance().addErrorMessage("Cannot access Clinical System, the alleray information cannot be displayed.");
				}
			};
			Allergy.setText("Allergy");
			Allergy.setBounds(495, 40, 88, 20);
		}
		return Allergy;
	}

	private LabelBase getDateOfOperDesc() {
		if (DateOfOperDesc == null) {
			DateOfOperDesc = new LabelBase();
			DateOfOperDesc.setText("Date of Operation");
			DateOfOperDesc.setBounds(20, 100, 114, 20);
		}
		return DateOfOperDesc;
	}

	public TextDate getDateOfOper() {
		if (DateOfOper == null) {
			DateOfOper = new TextDate() {
				@Override
				public void onBlur() {
					refreshSlipNumber();
				}
			};
			DateOfOper.setBounds(135, 100, 140, 20);
		}
		return DateOfOper;
	}

	private LabelBase getOperRoomDesc() {
		if (OperRoomDesc == null) {
			OperRoomDesc = new LabelBase();
			OperRoomDesc.setText("Operation Room");
			OperRoomDesc.setBounds(300, 100, 95, 20);
		}
		return OperRoomDesc;
	}

	private ComboOTCodeType getOperRoom() {
		if (OperRoom == null) {
			OperRoom = new ComboOTCodeType(new String[] {null, null, "Y"});
//			sOperRoom.removeItemAt(4);
			OperRoom.setBounds(400, 99, 140, 20);
		}
		return OperRoom;
	}

	private LabelBase getSetupTimeDesc() {
		if (SetupTimeDesc == null) {
			SetupTimeDesc = new LabelBase();
			SetupTimeDesc.setText("Setup Time (mins)");
			SetupTimeDesc.setBounds(20, 130, 114, 20);
		}
		return SetupTimeDesc;
	}

	public TextString getSetupTime() {
		if (SetupTime == null) {
			SetupTime = new TextString();
			SetupTime.setBounds(135, 130, 140, 20);
		}
		return SetupTime;
	}

	private LabelBase getPatTypeDesc() {
		if (PatTypeDesc == null) {
			PatTypeDesc = new LabelBase();
			PatTypeDesc.setText("Patient Type");
			PatTypeDesc.setBounds(300, 129, 95, 20);
		}
		return PatTypeDesc;
	}

	public ComboPatientType getPatType() {
		if (PatType == null) {
			PatType = new ComboPatientType() {
				@Override
				protected void onSelected() {
					String dOperateDate = otAppDate;
					if (DateTimeUtil.isDate(getDateOfOper().getText().trim())) {
						int iYear = 0;
						iYear = Integer.parseInt(getDateOfOper().getText().split("/")[2]);
						if (iYear > 1900) {
							dOperateDate = getDateOfOper().getText();
						}
					}

					QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.OTACTIVESLIP_TXCODE,
							new String[] {memPatNo, getPatType().getText(), dOperateDate},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								memSLPNO = mQueue.getContentField()[0];
								getSlipNo().setText(memSLPNO);
								memSlpType = mQueue.getContentField()[1];
							} else {
								memSLPNO = "";
								getSlipNo().resetText();
								memSlpType = "";
							}
						}
					});
				}
			};
			PatType.setBounds(400, 129, 140, 20);
		}
		return PatType;
	}

	private LabelBase getPatInDesc() {
		if (PatInDesc == null) {
			PatInDesc = new LabelBase();
			PatInDesc.setText("Patient In");
			PatInDesc.setBounds(20, 160, 114, 20);
		}
		return PatInDesc;
	}

	public TextDateTimeWithoutSecondWithCheckBox getPatIn() {
		if (PatIn == null) {
			PatIn = new TextDateTimeWithoutSecondWithCheckBox();
			PatIn.setBounds(135, 160, 140, 20);
		}
		return PatIn;
	}

	private LabelBase getPatOutDesc() {
		if (PatOutDesc == null) {
			PatOutDesc = new LabelBase();
			PatOutDesc.setText("Out");
			PatOutDesc.setBounds(300, 159, 95, 20);
		}
		return PatOutDesc;
	}

	public TextDateTimeWithoutSecondWithCheckBox getPatOut() {
		if (PatOut == null) {
			PatOut = new TextDateTimeWithoutSecondWithCheckBox();
			PatOut.setBounds(400, 159, 140, 20);
		}
		return PatOut;
	}

	private LabelBase getAnesthStartDesc() {
		if (AnesthStartDesc == null) {
			AnesthStartDesc = new LabelBase();
			AnesthStartDesc.setText("Anesthetics Start");
			AnesthStartDesc.setBounds(20, 190, 114, 20);
		}
		return AnesthStartDesc;
	}

	public TextDateTimeWithoutSecondWithCheckBox getAnesthStart() {
		if (AnesthStart == null) {
			AnesthStart = new TextDateTimeWithoutSecondWithCheckBox();
			AnesthStart.setBounds(135, 190, 140, 20);
		}
		return AnesthStart;
	}

	private LabelBase getAnesthEndDesc() {
		if (AnesthEndDesc == null) {
			AnesthEndDesc = new LabelBase();
			AnesthEndDesc.setText("End");
			AnesthEndDesc.setBounds(300, 189, 95, 20);
		}
		return AnesthEndDesc;
	}

	public TextDateTimeWithoutSecondWithCheckBox getAnesthEnd() {
		if (AnesthEnd == null) {
			AnesthEnd = new TextDateTimeWithoutSecondWithCheckBox();
			AnesthEnd.setBounds(400, 189, 140, 20);
		}
		return AnesthEnd;
	}

	private LabelBase getOperStartDesc() {
		if (OperStartDesc == null) {
			OperStartDesc = new LabelBase();
			OperStartDesc.setText("Operation Start");
			OperStartDesc.setBounds(20, 220, 114, 20);
		}
		return OperStartDesc;
	}

	public TextDateTimeWithoutSecondWithCheckBox getOperStart() {
		if (OperStart == null) {
			OperStart = new TextDateTimeWithoutSecondWithCheckBox();
			OperStart.setBounds(135, 220, 140, 20);
		}
		return OperStart;
	}

	private LabelBase getOperEndDesc() {
		if (OperEndDesc == null) {
			OperEndDesc = new LabelBase();
			OperEndDesc.setText("End");
			OperEndDesc.setBounds(300, 219, 95, 20);
		}
		return OperEndDesc;
	}

	public TextDateTimeWithoutSecondWithCheckBox getOperEnd() {
		if (OperEnd == null) {
			OperEnd = new TextDateTimeWithoutSecondWithCheckBox();
			OperEnd.setBounds(400, 219, 140, 20);
		}
		return OperEnd;
	}

	private LabelBase getIntoRecoveryDesc() {
		if (IntoRecoveryDesc == null) {
			IntoRecoveryDesc = new LabelBase();
			IntoRecoveryDesc.setText("Into Recovery");
			IntoRecoveryDesc.setBounds(20, 250, 114, 20);
		}
		return IntoRecoveryDesc;
	}

	public TextDateTimeWithoutSecondWithCheckBox getIntoRecovery() {
		if (IntoRecovery == null) {
			IntoRecovery = new TextDateTimeWithoutSecondWithCheckBox();
			IntoRecovery.setBounds(135, 250, 140, 20);
		}
		return IntoRecovery;
	}

	private LabelBase getLeftRecoveryDesc() {
		if (LeftRecoveryDesc == null) {
			LeftRecoveryDesc = new LabelBase();
			LeftRecoveryDesc.setText("Left Recovery");
			LeftRecoveryDesc.setBounds(300, 249, 95, 20);
		}
		return LeftRecoveryDesc;
	}

	public TextDateTimeWithoutSecondWithCheckBox getLeftRecovery() {
		if (LeftRecovery == null) {
			LeftRecovery = new TextDateTimeWithoutSecondWithCheckBox();
			LeftRecovery.setBounds(400, 249, 140, 20);
		}
		return LeftRecovery;
	}

	private LabelBase getPhoneWardTimeDesc() {
		if (PhoneWardTimeDesc == null) {
			PhoneWardTimeDesc = new LabelBase();
			PhoneWardTimeDesc.setText("Phone Ward Time");
			PhoneWardTimeDesc.setBounds(20, 280, 114, 20);
		}
		return PhoneWardTimeDesc;
	}

	public TextDateTimeWithoutSecondWithCheckBox getPhoneWardTime() {
		if (PhoneWardTime == null) {
			PhoneWardTime = new TextDateTimeWithoutSecondWithCheckBox();
			PhoneWardTime.setBounds(135, 280, 140, 20);
		}
		return PhoneWardTime;
	}

	private LabelBase getWardDesc() {
		if (WardDesc == null) {
			WardDesc = new LabelBase();
			WardDesc.setText("Ward");
			WardDesc.setBounds(300, 279, 95, 20);
		}
		return WardDesc;
	}

	private ComboWard getWard() {
		if (Ward == null) {
			Ward = new ComboWard();
			Ward.setBounds(400, 279, 140, 20);
		}
		return Ward;
	}

	private LabelBase getCleanuptimeDesc() {
		if (CleanuptimeDesc == null) {
			CleanuptimeDesc = new LabelBase();
			CleanuptimeDesc.setText("Clean up Time(mins)");
			CleanuptimeDesc.setBounds(20, 310, 114, 20);
		}
		return CleanuptimeDesc;
	}

	public TextString getCleanuptime() {
		if (Cleanuptime == null) {
			Cleanuptime = new TextString();
			Cleanuptime.setBounds(135, 310, 140, 20);
		}
		return Cleanuptime;
	}

	private LabelBase getReasonDesc() {
		if (ReasonDesc == null) {
			ReasonDesc = new LabelBase();
			ReasonDesc.setText("Reason For Late");
			ReasonDesc.setBounds(20, 340, 114, 20);
		}
		return ReasonDesc;
	}

	private ComboReasonLate getReason() {
		if (Reason == null) {
			Reason = new ComboReasonLate();
			Reason.setBounds(135, 340, 407, 20);
		}
		return Reason;
	}

	private LabelBase getSlipNoDesc() {
		if (SlipNoDesc == null) {
			SlipNoDesc = new LabelBase();
			SlipNoDesc.setText("Slip Number");
			SlipNoDesc.setBounds(20, 370, 114, 20);
		}
		return SlipNoDesc;
	}

	public TextReadOnly getSlipNo() {
		if (SlipNo == null) {
			SlipNo = new TextReadOnly();
			SlipNo.setBounds(135, 370, 140, 20);
		}
		return SlipNo;
	}

	private ButtonBase getCharges() {
		if (Charges == null) {
			Charges = new ButtonBase() {
				@Override
				public void onClick() {
					setParameter("SlpNo", SlipNo.getText());
					setParameter("From", "OT_LOG");
					if (ConstantsProperties.OT == 1) {
						if ("EMERGENCY".equalsIgnoreCase(getScheType().getDisplayText())) {
							setParameter("From_OT", ConstantsGlobal.OT_EMERGENCY);
						} else {
							setParameter("From_OT", ConstantsGlobal.OT_NOT_EMERGENCY);
						}
					}
					showPanel(new TransactionDetail());
				}
			};
			Charges.setText("Charges");
			Charges.setBounds(10, 420, 94, 25);
			Charges.setVisible(!getMainFrame().isDisaCmdNameOfOTLogBookFrm("cmdAction", "Charge"));
		}
		return Charges;
	}

	private ButtonBase getCloseLog() {
		if (CloseLog == null) {
			CloseLog = new ButtonBase() {
				@Override
				public void onClick() {
					MessageBoxBase.confirm(MSG_PBA_SYSTEM, "Are you sure to close this OT Log?",new Listener<MessageBoxEvent>() {
						public void handleEvent(MessageBoxEvent be) {
							if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
								QueryUtil.executeMasterAction(getUserInfo(), ConstantsTx.UPDATE_TXCODE,
										QueryUtil.ACTION_MODIFY, new String[] {"OT_LOG","OTLSTS = 'C'","OTLID ='"+memOTLID+"'"},
										new MessageQueueCallBack() {
									@Override
									public void onPostSuccess(MessageQueue mQueue) {
										if (mQueue.success()) {
											setParameter("OTSTS", OT_STS_CLOSE);
											Factory.getInstance().addInformationMessage("OT Log closed.");
											showOTLogDetail();
//											System.out.println("enableCmdAction getCloseLog false");
											TabbedPane.setSelectedIndex(0);
											memOTSTS = OT_STS_CLOSE;
										} else {
											Factory.getInstance().addErrorMessage("Error in close OT Log.");
										}
									}
								});
							}
						}
					});
				}
			};
			CloseLog.setText("Close Log");
			CloseLog.setBounds(116, 420, 94, 25);
			CloseLog.setVisible(!getMainFrame().isDisaCmdNameOfOTLogBookFrm("cmdAction", "Close Log"));
		}
		return CloseLog;
	}

	private ButtonBase getPrintLog() {
		if (PrintLog == null) {
			PrintLog = new ButtonBase() {
				@Override
				public void onClick() {
					HashMap<String, String> map = new HashMap<String, String>();
					map.put("${PatNo}", getPatNo().getText()); //getDisplayText
					map.put("${Name}", getPatFName().getText());
					map.put("${Chinese}", getPatCName().getText());
					map.put("${BirDate}", getDOB().getText());
					map.put("${Sex}", getSex().getText());
					map.put("${DofOper}", getDateOfOper().getText());
					map.put("${Room}", getOperRoom().getText());
					map.put("${SetTime}", getSetupTime().getText());
					map.put("${PatInTime}", getPatIn().getText());
					map.put("${OTime}", getPatOut().getText());
					map.put("${AneTime}", getAnesthStart().getText());
					map.put("${ETime}", getAnesthEnd().getText());
					map.put("${OperStart}", getOperStart().getText());
					map.put("${EdTime}", getOperEnd().getText());
					map.put("${IntoRec}", getIntoRecovery().getText());
					map.put("${LeftRec}", getLeftRecovery().getText());
					map.put("${PWT}", getPhoneWardTime().getText());
					map.put("${Ward}", getWard().getDisplayText());
					map.put("${CUT}", getCleanuptime().getText());
					map.put("${RFL}", getReason().getDisplayText());
//					PrintWord app = new PrintWord();
//					String path = System.getProperty("user.dir");
//					app.print(path + "\\doc\\template\\RptOTLogBook.doc", "C:\\temp\\LogBook.doc", map);
				}
			};
			PrintLog.setText("Print Log");
			PrintLog.setBounds(222, 420, 94, 25);
			PrintLog.setVisible(!getMainFrame().isDisaCmdNameOfOTLogBookFrm("cmdAction", "Print Log"));
		}
		return PrintLog;
	}

	public DlgOTSltSlip getDlgOTSltSlip() {
		if (dlgOTSltSlip == null) {
			dlgOTSltSlip = new DlgOTSltSlip(getMainFrame(), this);
		}
		return dlgOTSltSlip;
	}

	private ButtonBase getChange() {
		if (Change == null) {
			Change = new ButtonBase() {
				@Override
				public void onClick() {
					//setParameter("fromOTPatNo", getPatNo().getText());
					setParameter("fromOTLId", memOTLID);
					setParameter("SlipNo", getSlipNo().getText());
					getDlgOTSltSlip().showDialog(getPatNo().getText(),
					getDateOfOper().getText().substring(0, 10), getPatType().getText());
/*
							bFlag = True
							'-----------------------------------
							'copy Edit_Action start'
							ActMode = OT_LOG_MODE_EDIT
							EnableFrames (True)
							'----end------------------
							Call EnableCmdAction(True, True, True)
							'--------------------------
							Parameter("fromOTPatNo") = txtPatNum.Text
							Parameter("fromOTLId") = lId
							OTSltSlip.StartForm
							If Parameter("sltSlipSave") = True Then
								Save_Action
								txtSlipNo.ReadOnly = True
								Parameter("sltSlipSave") = False
								PBAMain.TBar.Buttons(7).Enabled = False 'cancel button
							Else
								ActMode = OT_LOG_MODE_SEARCH
								SyncToolBar Me
								PBAMain.TBar.Buttons(3).Enabled = True 'edit button
								PBAMain.TBar.Buttons(4).Enabled = True 'delete button
								PBAMain.TBar.Buttons(5).Enabled = False 'save button
								If Parameter("sltSlipSave") = False Then
									PBAMain.TBar.Buttons(6).Enabled = False 'accept button
									PBAMain.TBar.Buttons(7).Enabled = False 'cancel button
								End If
							End If
							EnableFrames (False)
*/
				}
			};
			Change.setText("Change operation date/pat type");
			Change.setBounds(330, 420, 215, 25);
		}
		return Change;
	}

	private BasePanel getProcedurePanel() {
		if (ProcedurePanel == null) {
			ProcedurePanel = new BasePanel();
			ProcedurePanel.add(getTourOnDesc(), null);
			ProcedurePanel.add(getTourOn(), null);
			ProcedurePanel.add(getTourOffDesc(), null);
			ProcedurePanel.add(getTourOff(), null);
			ProcedurePanel.add(getBloodTypeDesc(), null);
			ProcedurePanel.add(getBloodType(), null);
			ProcedurePanel.add(getScheTypeDesc(), null);
			ProcedurePanel.add(getScheType(), null);
			ProcedurePanel.add(getOutcomeDesc(), null);
			ProcedurePanel.add(getOutcome(), null);
			ProcedurePanel.add(getDressDesc(), null);
			ProcedurePanel.add(getDress(), null);
			ProcedurePanel.add(getReasonProcDesc(), null);
			ProcedurePanel.add(getReasonProc(), null);
			ProcedurePanel.add(getSpecimensDesc(), null);
			ProcedurePanel.add(getSpecimens(), null);
			ProcedurePanel.add(getSpecimenToDesc(), null);
			ProcedurePanel.add(getSpecimenTo(), null);
			ProcedurePanel.add(getFERequestedDesc(), null);
			ProcedurePanel.add(getFERequested(), null);
			ProcedurePanel.add(getFEReceivedDesc(), null);
			ProcedurePanel.add(getFEReceived(), null);
			ProcedurePanel.add(getProcPanel(), null);
			ProcedurePanel.add(getAnesthMedPanel(), null);
			ProcedurePanel.add(getCommentsDesc(), null);
			ProcedurePanel.add(getComments(), null);
			ProcedurePanel.add(getBFont(), null);
			ProcedurePanel.add(getIFont(), null);
			ProcedurePanel.add(getUFont(), null);
			ProcedurePanel.add(getCFont(), null);
		}
		return ProcedurePanel;
	}

	private LabelBase getTourOnDesc() {
		if (TourOnDesc == null) {
			TourOnDesc = new LabelBase();
			TourOnDesc.setText("Tourniquet On");
			TourOnDesc.setBounds(20, 5, 95, 20);
		}
		return TourOnDesc;
	}

	public TextDateTimeWithoutSecondWithCheckBox getTourOn() {
		if (TourOn == null) {
			TourOn = new TextDateTimeWithoutSecondWithCheckBox();
			TourOn.setBounds(115, 5, 140, 20);
		}
		return TourOn;
	}

	private LabelBase getTourOffDesc() {
		if (TourOffDesc == null) {
			TourOffDesc = new LabelBase();
			TourOffDesc.setText("Tourniquet Off");
			TourOffDesc.setBounds(270, 5, 106, 20);
		}
		return TourOffDesc;
	}

	public TextDateTimeWithoutSecondWithCheckBox getTourOff() {
		if (TourOff == null) {
			TourOff = new TextDateTimeWithoutSecondWithCheckBox();
			TourOff.setBounds(365, 5, 140, 20);
		}
		return TourOff;
	}

	private LabelBase getBloodTypeDesc() {
		if (BloodTypeDesc == null) {
			BloodTypeDesc = new LabelBase();
			BloodTypeDesc.setText("Blood Type");
			BloodTypeDesc.setBounds(526, 5, 92, 20);
		}
		return BloodTypeDesc;
	}

	private ComboBloodType getBloodType() {
		if (BloodType == null) {
			BloodType = new ComboBloodType();
			BloodType.setBounds(618, 5, 120, 20);
		}
		return BloodType;
	}

	private LabelBase getScheTypeDesc() {
		if (ScheTypeDesc == null) {
			ScheTypeDesc = new LabelBase();
			ScheTypeDesc.setText("Schedule Type");
			ScheTypeDesc.setBounds(20, 30, 95, 20);
		}
		return ScheTypeDesc;
	}

	private ComboScheduleType getScheType() {
		if (ScheType == null) {
			ScheType = new ComboScheduleType();
			ScheType.setBounds(115, 30, 140, 20);
		}
		return ScheType;
	}

	private LabelBase getOutcomeDesc() {
		if (OutcomeDesc == null) {
			OutcomeDesc = new LabelBase();
			OutcomeDesc.setText("Outcome");
			OutcomeDesc.setBounds(270, 30, 106, 20);
		}
		return OutcomeDesc;
	}

	private ComboOutcome getOutcome() {
		if (Outcome == null) {
			Outcome = new ComboOutcome();
			Outcome.setBounds(365, 30, 140, 20);
		}
		return Outcome;
	}

	private LabelBase getDressDesc() {
		if (DressDesc == null) {
			DressDesc = new LabelBase();
			DressDesc.setText("Dressing");
			DressDesc.setBounds(525, 30, 93, 20);
		}
		return DressDesc;
	}

	private ComboDressing getDress() {
		if (Dress == null) {
			Dress = new ComboDressing();
			Dress.setBounds(618, 30, 120, 20);
		}
		return Dress;
	}

	private LabelBase getReasonProcDesc() {
		if (ReasonProcDesc == null) {
			ReasonProcDesc = new LabelBase();
			ReasonProcDesc.setText("Reason");
			ReasonProcDesc.setBounds(20, 55, 95, 20);
		}
		return ReasonProcDesc;
	}

	private ComboOTLogReason getReasonProc() {
		if (ReasonProc == null) {
			ReasonProc = new ComboOTLogReason();
			ReasonProc.setBounds(115, 55, 622, 20);
		}
		return ReasonProc;
	}

	private LabelBase getSpecimensDesc() {
		if (SpecimensDesc == null) {
			SpecimensDesc = new LabelBase();
			SpecimensDesc.setText("Specimens");
			SpecimensDesc.setBounds(20, 80, 95, 20);
		}
		return SpecimensDesc;
	}

	public CheckBoxBase getSpecimens() {
		if (Specimens == null) {
			Specimens = new CheckBoxBase();
			Specimens.setBounds(80, 80, 20, 20);
		}
		return Specimens;
	}

	private LabelBase getSpecimenToDesc() {
		if (SpecimenToDesc == null) {
			SpecimenToDesc = new LabelBase();
			SpecimenToDesc.setText("Specimen To");
			SpecimenToDesc.setBounds(120, 80, 106, 20);
		}
		return SpecimenToDesc;
	}

	private ComboSpecDest getSpecimenTo() {
		if (SpecimenTo == null) {
			SpecimenTo = new ComboSpecDest();
			SpecimenTo.setBounds(200, 80, 140, 20);
		}
		return SpecimenTo;
	}

	public LabelBase getFERequestedDesc() {
		if (FERequestedDesc == null) {
			FERequestedDesc = new LabelBase();
			FERequestedDesc.setText("FE Requested");
			FERequestedDesc.setBounds(360, 80, 106, 20);
		}
		return FERequestedDesc;
	}

	public ComboYesNo getFERequested() {
		if (FERequested == null) {
			FERequested = new ComboYesNo();
			FERequested.setBounds(445, 80, 100, 20);
		}
		return FERequested;
	}

	public LabelBase getFEReceivedDesc() {
		if (FEReceivedDesc == null) {
			FEReceivedDesc = new LabelBase();
			FEReceivedDesc.setText("FE Received");
			FEReceivedDesc.setBounds(560, 80, 106, 20);
		}
		return FEReceivedDesc;
	}

	public ComboYesNo getFEReceived() {
		if (FEReceived == null) {
			FEReceived = new ComboYesNo();
			FEReceived.setBounds(638, 80, 100, 20);
		}
		return FEReceived;
	}

	private FieldSetBase getProcPanel() {
		if (ProcPanel == null) {
			ProcPanel = new FieldSetBase();
			ProcPanel.setHeading("Procedure");
			ProcPanel.add(getPrimaryProcDesc(), null);
			ProcPanel.add(getPrimaryProc(), null);
			ProcPanel.add(getPrimaryProcSearch(), null);
			ProcPanel.add(getSecProcDesc(), null);
			ProcPanel.add(getSecProcAdd(), null);
			ProcPanel.add(getSecProcRemove(), null);
			ProcPanel.add(getSecProcJScrollPane());
			ProcPanel.setBounds(10, 104, 751, 155);
		}
		return ProcPanel;
	}

	private LabelBase getPrimaryProcDesc() {
		if (PrimaryProcDesc == null) {
			PrimaryProcDesc = new LabelBase();
			PrimaryProcDesc.setText("Primary");
			PrimaryProcDesc.setBounds(10, 0, 86, 20);
		}
		return PrimaryProcDesc;
	}

	private ComboProcPrim getPrimaryProc() {
		if (PrimaryProc == null) {
			PrimaryProc = new ComboProcPrim();
			PrimaryProc.setBounds(96, 0, 591, 20);
		}
		return PrimaryProc;
	}

	private ButtonBase getPrimaryProcSearch() {
		if (PrimaryProcSearch == null) {
			PrimaryProcSearch = new ButtonBase() {
				@Override
				public void onClick() {
					showPanel(new OTProcedureCode());
				}
			};
			PrimaryProcSearch.setText("...");
			PrimaryProcSearch.setBounds(688, 0, 38, 20);
		}
		return PrimaryProcSearch;
	}

	private LabelBase getSecProcDesc() {
		if (SecProcDesc == null) {
			SecProcDesc = new LabelBase();
			SecProcDesc.setText("Secondary");
			SecProcDesc.setBounds(10, 25, 86, 20);
		}
		return SecProcDesc;
	}

	private ButtonBase getSecProcAdd() {
		if (secProcAdd == null) {
			secProcAdd = new ButtonBase() {
				@Override
				public void onClick() {
//					System.out.println("getSecProcAdd click rowIdx");
					getSecProcTable().addRow(new String[] {null, null, null, null, null, null});
				}
			};
			secProcAdd.setText("+");
			secProcAdd.setBounds(15, 50, 20, 20);
		}
		return secProcAdd;
	}

	private ButtonBase getSecProcRemove() {
		if (secProcRemove == null) {
			secProcRemove = new ButtonBase() {
				@Override
				public void onClick() {
					int rowIdx = getSecProcTable().getSelectedRow();
//					System.out.println("getSecProcRemove click rowIdx="+rowIdx);
					if (rowIdx >= 0) {
						rowsToDel(getSecProcTable(), rowIdx);
						getSecProcTable().removeRow(rowIdx);
					}
				}
			};
			secProcRemove.setText("-");
			secProcRemove.setBounds(45, 50, 20, 20);
		}
		return secProcRemove;
	}

	private JScrollPane getSecProcJScrollPane() {
		if (SecProcJScrollPane == null) {
			SecProcJScrollPane = new JScrollPane();
			SecProcJScrollPane.setViewportView(getSecProcTable());
			SecProcJScrollPane.setBounds(96, 25, 630, 100);
		}
		return SecProcJScrollPane;
	}

	private ComboProcPrim getComboProcPrim() {
		if (comboProcPrim == null) {
			comboProcPrim = new ComboProcPrim() {
				@Override
				protected void setTextPanel(ModelData modelData) {
					super.setTextPanel(modelData);

					if (modelData != null) {
						String text = modelData.get(ONE_VALUE).toString();
						String otpcode = null;
						String[] temp = text.split("  ");
						if (temp.length > 1) {
							otpcode = temp[temp.length - 1];
						}

						getSecProcTable().setValueAt(otpcode,
								getSecProcTable().getSelectedRow(), 5);
						getSecProcTable().setValueAt(text,
								getSecProcTable().getSelectedRow(), 4);
						getSecProcTable().setValueAt(modelData.get(ZERO_VALUE).toString(),
								getSecProcTable().getSelectedRow(), 3);
					}
				}
			};
		}
		return comboProcPrim;
	}

	private EditorTableList getSecProcTable() {
		if (SecProcTable == null) {
			SecProcTable = new EditorTableList(
					getSecProcTableColumnNames(),
					getSecProcTableColumnWidths(),
					getSecProcTableEditors());
			SecProcTable.setTableLength(getListWidth());
//			SecProcTable.setColumnClass(4, new ComboProcPrim(), true);
			SecProcTable.setData(ConstantsVariable.NAME_VALUE, ConstantsTx.OTLOGPROC_TXCODE);
		}
		return SecProcTable;
	}

	protected String[] getSecProcTableColumnNames() {
		return new String[] {
				"","olpid","otlid","otpid",
				"Description",
				"ICD Code"
			};
	}

	protected int[] getSecProcTableColumnWidths() {
		return new int[] { 5, 0, 0, 0, 350, 100};
	}

	private Field<? extends Object>[] getSecProcTableEditors() {
		return new Field[] {
				null, null, null, null, getComboProcPrim(), null
		};
	}

	private TableList getDelSecProcTable() {
		if (delSecProcTable == null) {
			delSecProcTable = new TableList(getSecProcTableColumnNames(), getSecProcTableColumnWidths());
		}
		return delSecProcTable;
	}

	private FieldSetBase getAnesthMedPanel() {
		if (AnesthMedPanel == null) {
			AnesthMedPanel = new FieldSetBase();
			AnesthMedPanel.setHeading("Anesthetics Method");
			AnesthMedPanel.add(getPrimaryAnesDesc(), null);
			AnesthMedPanel.add(getPrimaryAnes(), null);
			AnesthMedPanel.add(getSecAnesDesc(), null);
			AnesthMedPanel.add(getSecAnesAdd(), null);
			AnesthMedPanel.add(getSecAnesRemove(), null);
			AnesthMedPanel.add(getSecAnesManJScrollPane(), null);
			AnesthMedPanel.add(getRemarkDesc(), null);
			AnesthMedPanel.add(getRemark(), null);
			AnesthMedPanel.setBounds(9, 261, 751, 155);
		}
		return AnesthMedPanel;
	}

	private LabelBase getPrimaryAnesDesc() {
		if (PrimaryAnesDesc == null) {
			PrimaryAnesDesc = new LabelBase();
			PrimaryAnesDesc.setText("Primary");
			PrimaryAnesDesc.setBounds(10, 0, 101, 20);
		}
		return PrimaryAnesDesc;
	}

	private ComboAppAnesMeth getPrimaryAnes() {
		if (PrimaryAnes == null) {
			PrimaryAnes = new ComboAppAnesMeth();
			PrimaryAnes.setBounds(97, 0, 285, 20);
		}
		return PrimaryAnes;
	}

	private LabelBase getSecAnesDesc() {
		if (SecAnesDesc == null) {
			SecAnesDesc = new LabelBase();
			SecAnesDesc.setText("Secondary");
			SecAnesDesc.setBounds(10, 25, 101, 20);
		}
		return SecAnesDesc;
	}

	private ButtonBase getSecAnesAdd() {
		if (secAnesAdd == null) {
			secAnesAdd = new ButtonBase() {
				@Override
				public void onClick() {
//					System.out.println("getSecAnesAdd click rowIdx");
					getSecAnesTable().addRow(new String[] {null, null, null, null, null});
				}
			};
			secAnesAdd.setText("+");
			secAnesAdd.setBounds(15, 50, 20, 20);
		}
		return secAnesAdd;
	}

	private ButtonBase getSecAnesRemove() {
		if (secAnesRemove == null) {
			secAnesRemove = new ButtonBase() {
				@Override
				public void onClick() {
					int rowIdx = getSecAnesTable().getSelectedRow();
//					System.out.println("getSecAnesRemove click rowIdx="+rowIdx);
					if (rowIdx >= 0) {
						rowsToDel(getSecAnesTable(), rowIdx);
						getSecAnesTable().removeRow(rowIdx);
					}
				}
			};
			secAnesRemove.setText("-");
			secAnesRemove.setBounds(45, 50, 20, 20);
		}
		return secAnesRemove;
	}

	private LabelBase getRemarkDesc() {
		if (RemarkDesc == null) {
			RemarkDesc = new LabelBase();
			RemarkDesc.setText("Remark");
			RemarkDesc.setBounds(407, 0, 79, 20);
		}
		return RemarkDesc;
	}

	public TextAreaBase getRemark() {
		if (Remark == null) {
			Remark = new TextAreaBase(2, 30);
			Remark.setWhiteBackgroundColor(true);
			Remark.setBounds(488, 0, 237, 124);
		}
		return Remark;
	}

	private JScrollPane getSecAnesJScrollPane() {
		if (SecAnesJScrollPane == null) {
			SecAnesJScrollPane = new JScrollPane();
			SecAnesJScrollPane.setViewportView(getSecAnesManTable());
			SecAnesJScrollPane.setBounds(92, 25, 260, 110);
		}
		return SecAnesJScrollPane;
	}

	private EditorTableList getSecAnesTable() {
		if (SecAnesTable == null) {
			SecAnesTable = new EditorTableList(
					getSecAnesTableColumnNames(),
					getSecAnesTableColumnWidths(),
					getSecAnesTableEditors());
			SecAnesTable.setTableLength(getListWidth());
			SecAnesTable.setData(ConstantsVariable.NAME_VALUE, ConstantsTx.OTLOGANES_TXCODE);
		}
		return SecAnesTable;
	}

	private TableList getDelSecAnesTable() {
		if (delSecAnesTable == null) {
			delSecAnesTable = new TableList(getSecAnesTableColumnNames(), getSecAnesTableColumnWidths());
		}
		return delSecAnesTable;
	}

	protected String[] getSecAnesTableColumnNames() {
		return new String[] {
				"", "OLMID", "OTLID", "OTCID", "Method"
			};
	}

	protected int[] getSecAnesTableColumnWidths() {
		return new int[] { 10,0, 0, 0, 250};
	}

	private Field<? extends Object>[] getSecAnesTableEditors() {
		ComboAppAnesMeth cb = new ComboAppAnesMeth() {
			@Override
			protected void onFocus(ComponentEvent ce) {
				super.onFocus(ce);
				controlTableColEditing(getSecAnesTable());
			}
		};
		cb.addListener(Events.Change, new Listener<FieldEvent>() {
			public void handleEvent(FieldEvent be) {
				String text = ((ComboBoxBase)be.getSource()).getDisplayText();

				getSecAnesTable().setValueAt(
						((ComboBoxBase)be.getSource()).getText(),
						getSecAnesTable().getSelectedRow(),
						3);

				getSecAnesTable().setValueAt(
						text,
						getSecAnesTable().getSelectedRow(),
						4);
			}
		});
		Field<? extends Object>[] editors = new Field<?>[5];
		editors[0] = null;
		editors[1] = null;
		editors[2] = null;
		editors[3] = null;
		editors[4] = cb;
		return editors;
	}

	private LabelBase getCommentsDesc() {
		if (CommentsDesc == null) {
			CommentsDesc = new LabelBase();
			CommentsDesc.setText("Comments");
			CommentsDesc.setBounds(20, 420, 57, 20);
		}
		return CommentsDesc;
	}

	private TextAreaBase getComments() {
		if (Comments == null) {
//			Comments = new HtmlEditor();
//			Comments.setHideLabel(true);
			Comments = new TextAreaBase(2, 30);
			Comments.setWhiteBackgroundColor(true);
			Comments.setBounds(109, 420, 625, 100);
		}
		return Comments;
	}

	private ButtonBase getBFont() {
		if (BFont == null) {
			BFont = new ButtonBase() {
				@Override
				public void onClick() {
				}
			};
			BFont.setText("B");
//			BFont.setStyleAttribute("fontWeight", "bold");
			// com.google.gwt.core.client.JavaScriptException: (Error)
			BFont.setBounds(80, 420, 20, 20);
		}
		return BFont;
	}

	private ButtonBase getIFont() {
		if (IFont == null) {
			IFont = new ButtonBase() {
				@Override
				public void onClick() {
				}
			};
			IFont.setText("I");
//			IFont.setStyleAttribute("fontWeight", "bold,italic");
			// com.google.gwt.core.client.JavaScriptException: (Error)
//			IFont.setFont(new Font("Dialog", Font.BOLD | Font.ITALIC, 12));
			IFont.setBounds(80, 446, 20, 20);
		}
		return IFont;
	}

	private ButtonBase getUFont() {
		if (UFont == null) {
			UFont = new ButtonBase() {
				@Override
				public void onClick() {
				}
			};
			UFont.setText("U");
//			UFont.setStyleAttribute("fontWeight", "bold");
			// com.google.gwt.core.client.JavaScriptException: (Error)
			UFont.setBounds(80, 471, 20, 20);
		}
		return UFont;
	}

	private ButtonBase getCFont() {
		if (CFont == null) {
			CFont = new ButtonBase() {
				@Override
				public void onClick() {
				}
			};
			CFont.setText("C");
			CFont.setStyleAttribute("color", "red");
			CFont.setBounds(80, 496, 20, 20);
		}
		return CFont;
	}

	private BasePanel getManpowerPanel() {
		if (ManpowerPanel == null) {
			ManpowerPanel = new BasePanel();
			ManpowerPanel.add(getSurgeonPanel(), null);
			ManpowerPanel.add(getAnesthManPanel(), null);
			ManpowerPanel.add(getEndosPanel(), null);
			ManpowerPanel.add(getReferDoctorPanel(), null);
			ManpowerPanel.add(getTeamMembersPanel(), null);

		}
		return ManpowerPanel;
	}

	private FieldSetBase getSurgeonPanel() {
		if (SurgeonPanel == null) {
			SurgeonPanel = new FieldSetBase();
			SurgeonPanel.setHeading("Surgeon");
			SurgeonPanel.add(getPrimarySurDesc(), null);
			SurgeonPanel.add(getPrimarySur(), null);
			SurgeonPanel.add(getSecSurDesc(), null);
			SurgeonPanel.add(getSecSurAdd(), null);
			SurgeonPanel.add(getSecSurRemove(), null);
			SurgeonPanel.add(getSecSurJScrollPane(), null);
			SurgeonPanel.setBounds(10, 10, 370, 162);

		}
		return SurgeonPanel;
	}

	private LabelBase getPrimarySurDesc() {
		if (PrimarySurDesc == null) {
			PrimarySurDesc = new LabelBase();
			PrimarySurDesc.setText("Primary");
			PrimarySurDesc.setBounds(10, 0, 62, 20);
		}
		return PrimarySurDesc;
	}

	public ComboDoctorSU getPrimarySur() {
		if (PrimarySur == null) {
			PrimarySur = new ComboDoctorSU();
			PrimarySur.setBounds(92, 0, 260, 20);
		}
		return PrimarySur;
	}

	private LabelBase getSecSurDesc() {
		if (SecSurDesc == null) {
			SecSurDesc = new LabelBase();
			SecSurDesc.setText("Secondary");
			SecSurDesc.setBounds(10, 25, 62, 20);
		}
		return SecSurDesc;
	}

	private ButtonBase getSecSurAdd() {
		if (secSurAdd == null) {
			secSurAdd = new ButtonBase() {
				@Override
				public void onClick() {
//					System.out.println("getSecSurAdd click rowIdx");
					getSecSurTable().addRow(new String[] {null, null, null, null, null});
				}
			};
			secSurAdd.setText("+");
			secSurAdd.setBounds(15, 50, 20, 20);
		}
		return secSurAdd;
	}

	private ButtonBase getSecSurRemove() {
		if (secSurRemove == null) {
			secSurRemove = new ButtonBase() {
				@Override
				public void onClick() {
					int rowIdx = getSecSurTable().getSelectedRow();
//					System.out.println("getSecSurRemove click rowIdx="+rowIdx);
					if (rowIdx >= 0) {
						rowsToDel(getSecSurTable(), rowIdx);
						getSecSurTable().removeRow(rowIdx);
					}
				}
			};
			secSurRemove.setText("-");
			secSurRemove.setBounds(45, 50, 20, 20);
		}
		return secSurRemove;
	}

	private JScrollPane getSecSurJScrollPane() {
		if (SecSurJScrollPane == null) {
			SecSurJScrollPane = new JScrollPane();
			SecSurJScrollPane.setViewportView(getSecSurTable());
			SecSurJScrollPane.setBounds(92, 25, 260,110);
		}
		return SecSurJScrollPane;
	}

	public EditorTableList getSecSurTable() {
		if (SecSurTable == null) {
			SecSurTable = new EditorTableList(getSecSurTableColumnNames(), getSecSurTableColumnWidths(),
					getSecSurTableEditors());
			SecSurTable.setTableLength(getListWidth());
			SecSurTable.setData(ConstantsVariable.NAME_VALUE, ConstantsTx.OTLOGSURG_TXCODE);
		}
		return SecSurTable;
	}

	private TableList getDelSecSurTable() {
		if (delSecSurTable == null) {
			delSecSurTable = new TableList(getSecSurTableColumnNames(), getSecSurTableColumnWidths());
			delSecSurTable.setTableLength(getListWidth());
			delSecSurTable.setData(ConstantsVariable.NAME_VALUE, ConstantsTx.OTLOGSURG_TXCODE);
		}
		return delSecSurTable;
	}

	protected String[] getSecSurTableColumnNames() {
		return new String[] {
				"","OLSID", "OTLID",
				"Doctor",
				"Code"
			};
	}

	protected int[] getSecSurTableColumnWidths() {
		return new int[] { 10,0,0,200,60};
	}

	private Field<? extends Object>[] getSecSurTableEditors() {
		ComboDoctorSU cb = new ComboDoctorSU() {
			@Override
			protected void onFocus(ComponentEvent ce) {
				super.onFocus(ce);
				controlTableColEditing(getSecSurTable());
			}
		};
		cb.addListener(Events.Change, new Listener<FieldEvent>() {
			public void handleEvent(FieldEvent be) {
				String text = ((ComboBoxBase)be.getSource()).getDisplayText();

				getSecSurTable().setValueAt(
						((ComboBoxBase)be.getSource()).getText(),
						getSecSurTable().getSelectedRow(),
						4);

				getSecSurTable().setValueAt(text,
						getSecSurTable().getSelectedRow(),
						3);
			}
		});
		Field<? extends Object>[] editors = new Field<?>[5];
		editors[0] = null;
		editors[1] = null;
		editors[2] = null;
		editors[3] = cb;
		editors[4] = null;
		return editors;
	}

	private FieldSetBase getAnesthManPanel() {
		if (AnesthManPanel == null) {
			AnesthManPanel = new FieldSetBase();
			AnesthManPanel.setHeading("Anesthetist");
			AnesthManPanel.add(getPrimaryAnesManDesc(), null);
			AnesthManPanel.add(getPrimaryAnesMan(), null);
			AnesthManPanel.add(getSecAnesManDesc(), null);
			AnesthManPanel.add(getSecAnesManAdd(), null);
			AnesthManPanel.add(getSecAnesManRemove(), null);
			AnesthManPanel.add(getSecAnesJScrollPane(), null);
			AnesthManPanel.setBounds(386, 10, 370, 162);
		}
		return AnesthManPanel;
	}

	private LabelBase getPrimaryAnesManDesc() {
		if (PrimaryAnesManDesc == null) {
			PrimaryAnesManDesc = new LabelBase();
			PrimaryAnesManDesc.setText("Primary");
			PrimaryAnesManDesc.setBounds(10, 0, 62, 20);
		}
		return PrimaryAnesManDesc;
	}

	private ComboDoctorAN getPrimaryAnesMan() {
		if (PrimaryAnesMan == null) {
			PrimaryAnesMan = new ComboDoctorAN(null, false);
			PrimaryAnesMan.setBounds(92, 0, 260, 20);
		}
		return PrimaryAnesMan;
	}

	private LabelBase getSecAnesManDesc() {
		if (SecAnesManDesc == null) {
			SecAnesManDesc = new LabelBase();
			SecAnesManDesc.setText("Secondary");
			SecAnesManDesc.setBounds(10, 25, 62, 20);
		}
		return SecAnesManDesc;
	}

	private ButtonBase getSecAnesManAdd() {
		if (secAnesManAdd == null) {
			secAnesManAdd = new ButtonBase() {
				@Override
				public void onClick() {
//					System.out.println("getSecAnesManAdd click rowIdx");
					getSecAnesManTable().addRow(new String[] {null, null, null, null, null});
				}
			};
			secAnesManAdd.setText("+");
			secAnesManAdd.setBounds(15, 50, 20, 20);
		}
		return secAnesManAdd;
	}

	private ButtonBase getSecAnesManRemove() {
		if (secAnesManRemove == null) {
			secAnesManRemove = new ButtonBase() {
				@Override
				public void onClick() {
					int rowIdx = getSecAnesManTable().getSelectedRow();
//					System.out.println("getSecProcRemove click rowIdx="+rowIdx);
					if (rowIdx >= 0) {
						rowsToDel(getSecAnesManTable(), rowIdx);
						getSecAnesManTable().removeRow(rowIdx);
					}
				}
			};
			secAnesManRemove.setText("-");
			secAnesManRemove.setBounds(45, 50, 20, 20);
		}
		return secAnesManRemove;
	}

	private JScrollPane getSecAnesManJScrollPane() {
		if (SecAnesManJScrollPane == null) {
			SecAnesManJScrollPane = new JScrollPane();
			SecAnesManJScrollPane.setViewportView(getSecAnesTable());
			SecAnesManJScrollPane.setBounds(97, 25, 285, 100);
		}
		return SecAnesManJScrollPane;
	}

	private EditorTableList getSecAnesManTable() {
		if (SecAnesManTable == null) {
			SecAnesManTable = new EditorTableList(getSecAnesManTableColumnNames(), getSecAnesManTableColumnWidths(),
					getSecAnesManTableEditors());
			SecAnesManTable.setTableLength(getListWidth());
//			SecAnesManTable.setColumnClass(3, new ComboDoctorAN(false, true), true);
			SecAnesManTable.setData(ConstantsVariable.NAME_VALUE, ConstantsTx.OTLOGMETH_TXCODE);
		}
		return SecAnesManTable;
	}

	private TableList getDelSecAnesManTable() {
		if (delSecAnesManTable == null) {
			delSecAnesManTable = new TableList(getSecAnesManTableColumnNames(), getSecAnesManTableColumnWidths());
		}
		return delSecAnesManTable;
	}

	protected String[] getSecAnesManTableColumnNames() {
		return new String[] {
				"","otaid","otlid",
				"Doctor",
				"Code"
			};
	}

	protected int[] getSecAnesManTableColumnWidths() {
		return new int[] { 10, 0, 0, 200, 60 };
	}

	private Field<? extends Object>[] getSecAnesManTableEditors() {
		ComboDoctorAN cb = new ComboDoctorAN() {
			@Override
			protected void onFocus(ComponentEvent ce) {
				super.onFocus(ce);
				controlTableColEditing(getSecAnesManTable());
			}
		};
		cb.addListener(Events.Change, new Listener<FieldEvent>() {
			public void handleEvent(FieldEvent be) {
				String text = ((ComboBoxBase)be.getSource()).getDisplayText();
				getSecAnesManTable().setValueAt(
						((ComboBoxBase)be.getSource()).getText(),
						getSecAnesManTable().getSelectedRow(),
						4);

				getSecAnesManTable().setValueAt(
						text,
						getSecAnesManTable().getSelectedRow(),
						3);
			}
		});
		Field<? extends Object>[] editors = new Field<?>[5];
		editors[0] = null;
		editors[1] = null;
		editors[2] = null;
		editors[3] = cb;
		editors[4] = null;
		return editors;
	}

	private FieldSetBase getEndosPanel() {
		if (EndosPanel == null) {
			EndosPanel = new FieldSetBase();
			EndosPanel.setHeading("Endoscopist");
			EndosPanel.add(getEndoscopistDesc(), null);
			EndosPanel.add(getEndoscopist(), null);
			EndosPanel.setBounds(10, 174, 370, 49);
		}
		return EndosPanel;
	}

	private LabelBase getEndoscopistDesc() {
		if (EndoscopistDesc == null) {
			EndoscopistDesc = new LabelBase();
			EndoscopistDesc.setText("Endoscopist");
			EndoscopistDesc.setBounds(10, 0, 62, 20);
		}
		return EndoscopistDesc;
	}

	private ComboDoctorEN getEndoscopist() {
		if (Endoscopist == null) {
			Endoscopist = new ComboDoctorEN();
			Endoscopist.setBounds(92, 0, 260, 20);
		}
		return Endoscopist;
	}

	private FieldSetBase getReferDoctorPanel() {
		if (ReferDoctorPanel == null) {
			ReferDoctorPanel = new FieldSetBase();
			ReferDoctorPanel.setHeading("Referral Doctor");
			ReferDoctorPanel.add(getReferralDoctorDesc(), null);
			ReferDoctorPanel.add(getReferralDoctor(), null);
			ReferDoctorPanel.setBounds(386, 174, 370, 49);
		}
		return ReferDoctorPanel;
	}

	private LabelBase getReferralDoctorDesc() {
		if (ReferralDoctorDesc == null) {
			ReferralDoctorDesc = new LabelBase();
			ReferralDoctorDesc.setText("Referral Dr.");
			ReferralDoctorDesc.setBounds(10, 0, 82, 20);
		}
		return ReferralDoctorDesc;
	}

	private ComboReferDotor getReferralDoctor() {
		if (ReferralDoctor == null) {
			ReferralDoctor = new ComboReferDotor();
			ReferralDoctor.setBounds(92, 0, 260, 20);
		}
		return ReferralDoctor;
	}

	private FieldSetBase getTeamMembersPanel() {
		if (TeamMembersPanel == null) {
			TeamMembersPanel = new FieldSetBase();
			TeamMembersPanel.setHeading("Team Members");
			TeamMembersPanel.setBounds(10, 227, 746, 311);
			TeamMembersPanel.add(getAvaStaffDesc(), null);
			TeamMembersPanel.add(getAvaStaffJScrollPane(), null);
			TeamMembersPanel.add(getFunctionDesc(), null);
			TeamMembersPanel.add(getFunctionJScrollPane(), null);
			TeamMembersPanel.add(getResultJScrollPane(), null);
			TeamMembersPanel.add(getSelect(), null);
			TeamMembersPanel.add(getRemove(), null);
		}
		return TeamMembersPanel;
	}

	private LabelBase getAvaStaffDesc() {
		if (AvaStaffDesc == null) {
			AvaStaffDesc = new LabelBase();
			AvaStaffDesc.setText("<html>Available<br>Staff</html>");
			AvaStaffDesc.setBounds(10, 0, 62, 27);
		}
		return AvaStaffDesc;
	}

	private JScrollPane getAvaStaffJScrollPane() {
		if (AvaStaffJScrollPane == null) {
			AvaStaffJScrollPane = new JScrollPane();
			AvaStaffJScrollPane.setViewportView(getAvaStaffTable());
			AvaStaffJScrollPane.setBounds(92, 0, 260,140);
		}
		return AvaStaffJScrollPane;
	}

	private TableList getAvaStaffTable() {
		if (AvaStaffTable == null) {
			AvaStaffTable = new TableList(getAvaStaffTableColumnNames(), getAvaStaffTableColumnWidths());
			AvaStaffTable.setTableLength(getListWidth());
		}
		return AvaStaffTable;
	}

	protected String[] getAvaStaffTableColumnNames() {
		return new String[] {
				"","otcid",
				"Staff", "", "", ""
			};
	}

	protected int[] getAvaStaffTableColumnWidths() {
		return new int[] { 10, 0, 260, 0, 0, 0 };
	}

	private LabelBase getFunctionDesc() {
		if (FunctionDesc == null) {
			FunctionDesc = new LabelBase();
			FunctionDesc.setText("Function");
			FunctionDesc.setBounds(386, 0, 82, 20);
		}
		return FunctionDesc;
	}

	private JScrollPane getFunctionJScrollPane() {
		if (FunctionJScrollPane == null) {
			FunctionJScrollPane = new JScrollPane();
			FunctionJScrollPane.setViewportView(getFunctionTable());
			FunctionJScrollPane.setBounds(468, 0, 260,140);
		}
		return FunctionJScrollPane;
	}

	private TableList getFunctionTable() {
		if (FunctionTable == null) {
			FunctionTable = new TableList(getFunctionTableColumnNames(), getFunctionTableColumnWidths());
			FunctionTable.setTableLength(getListWidth());
		}
		return FunctionTable;
	}

	protected String[] getFunctionTableColumnNames() {
		return new String[] {
				"","otcid",
				"Function",
				"", "", ""
			};
	}

	protected int[] getFunctionTableColumnWidths() {
		return new int[] { 10, 0, 260, 0, 0, 0 };
	}

	private JScrollPane getResultJScrollPane() {
		if (ResultJScrollPane == null) {
			ResultJScrollPane = new JScrollPane();
			ResultJScrollPane.setViewportView(getTeamTable());
			ResultJScrollPane.setBounds(92, 150, 637, 130);
		}
		return ResultJScrollPane;
	}

	private TableList getTeamTable() {
		if (TeamTable == null) {
			TeamTable = new TableList(getTeamTableColumnNames(), getTeamTableColumnWidths());
			TeamTable.setTableLength(getListWidth());
			TeamTable.setData(ConstantsVariable.NAME_VALUE, ConstantsTx.OTLOGTEAM_TXCODE);
		}
		return TeamTable;
	}

	private TableList getDelTeamTable() {
		if (delTeamTable == null) {
			delTeamTable = new TableList(getTeamTableColumnNames(), getTeamTableColumnWidths());
		}
		return delTeamTable;
	}

	protected String[] getTeamTableColumnNames() {
		return new String[] {
				"","otcid_sf",
				"Staff","otcid_fn",
				"Function","oltid",
				"oltid"
			};
	}

	protected int[] getTeamTableColumnWidths() {
		return new int[] { 10,0,300,0,300,0,0};
	}

	private ButtonBase getSelect() {
		if (Select == null) {
			Select = new ButtonBase() {
				@Override
				public void onClick() {
					if (getAvaStaffTable().getRowCount() > 0 && getFunctionTable().getRowCount() > 0) {
						String[] selTeam = new String[] {"",
								getAvaStaffTable().getSelectedRowContent()[1], getAvaStaffTable().getSelectedRowContent()[2],
								getFunctionTable().getSelectedRowContent()[1], getFunctionTable().getSelectedRowContent()[2],
								"", memOTLID};
						getTeamTable().addRow(selTeam);
					}
				}
			};
			Select.setText("Select");
			Select.setBounds(5, 150, 83, 20);
		}
		return Select;
	}

	private ButtonBase getRemove() {
		if (Remove == null) {
			Remove = new ButtonBase() {
				@Override
				public void onClick() {
					rowsToDel(getTeamTable(), getTeamTable().getSelectedRow());
					getTeamTable().removeRow(getTeamTable().getSelectedRow());
				}
			};
			Remove.setText("Remove");
			Remove.setBounds(5, 180, 83, 20);
		}
		return Remove;
	}

	private BasePanel getMaterialPanel() {
		if (MaterialPanel == null) {
			MaterialPanel = new BasePanel();
			MaterialPanel.add(getImplantPanel(), null);
			MaterialPanel.add(getEquipmentPanel(), null);
			MaterialPanel.add(getInstrumentPanel(), null);
			MaterialPanel.add(getDrugPanel(), null);
		}
		return MaterialPanel;
	}

	private FieldSetBase getImplantPanel() {
		if (ImplantPanel == null) {
			ImplantPanel = new FieldSetBase();
			ImplantPanel.setHeading("Implant");
			ImplantPanel.add(getAvaImpDesc(), null);
			ImplantPanel.add(getAvaImpJScrollPane(), null);
			ImplantPanel.add(getSelImpDesc(), null);
			ImplantPanel.add(getSelImpJScrollPane(), null);
			ImplantPanel.add(getImpbtn(), null);
			ImplantPanel.setBounds(10, 10, 754, 135);
		}
		return ImplantPanel;
	}

	private LabelBase getAvaImpDesc() {
		if (AvaImpDesc == null) {
			AvaImpDesc = new LabelBase();
			AvaImpDesc.setText("Available");
			AvaImpDesc.setBounds(10, 0, 52, 20);
		}
		return AvaImpDesc;
	}

	private JScrollPane getAvaImpJScrollPane() {
		if (AvaImpJScrollPane == null) {
			AvaImpJScrollPane = new JScrollPane();
			AvaImpJScrollPane.setViewportView(getAvaImpTable());
			AvaImpJScrollPane.setBounds(62, 0, 300, 105);
		}
		return AvaImpJScrollPane;
	}

	private TableList getAvaImpTable() {
		if (AvaImpTable == null) {
			AvaImpTable = new TableList(getAvaImpTableColumnNames(), getAvaImpTableColumnWidths()) {
				@Override
				public void doubleClick() {
					if (isModify() || isAppend()) {
						replaceRow(getAvaImpTable(), getSelImpTable(), getAvaImpTable().getSelectedRow());
					}
				};
			};
			AvaImpTable.setTableLength(getListWidth());
		}
		return AvaImpTable;
	}

	protected String[] getAvaImpTableColumnNames() {
		return new String[] {
				"","Otcid","Description","","","otlid"
			};
	}

	protected int[] getAvaImpTableColumnWidths() {
		return new int[] { 10, 0, 260, 0, 0, 0 };
	}

	private LabelBase getSelImpDesc() {
		if (SelImpDesc == null) {
			SelImpDesc = new LabelBase();
			SelImpDesc.setText("Selected");
			SelImpDesc.setBounds(388, 0, 50, 20);
		}
		return SelImpDesc;
	}

	private JScrollPane getSelImpJScrollPane() {
		if (SelImpJScrollPane == null) {
			SelImpJScrollPane = new JScrollPane();
			SelImpJScrollPane.setViewportView(getSelImpTable());
			SelImpJScrollPane.setBounds(438, 0, 300, 105);
		}
		return SelImpJScrollPane;
	}

	private EditorTableList getSelImpTable() {
		if (SelImpTable == null) {
			SelImpTable = new EditorTableList(getSelImpTableColumnNames(), getSelImpTableColumnWidths(),
					getSelImpTableEditors()) {
				public void doubleClick() {
					if (isModify() || isAppend()) {
						selTableRemoveItem(this, getAvaImpTable());
					}
				}
			};
			SelImpTable.setTableLength(getListWidth());
			SelImpTable.setData(ConstantsVariable.NAME_VALUE, ConstantsTx.OTLOGIMPL_TXCODE);
		}
		return SelImpTable;
	}

	private TableList getDelSelImpTable() {
		if (delSelImpTable == null) {
			delSelImpTable = new TableList(getSelImpTableColumnNames(), getSelImpTableColumnWidths());
		}
		return delSelImpTable;
	}

	protected String[] getSelImpTableColumnNames() {
		return new String[] {
				"","otcid",
				"Description",
				"Remark","Oliid",
				"otlid"
			};
	}

	protected int[] getSelImpTableColumnWidths() {
		return new int[] { 10,0,130,150,0,0};
	}

	private Field<? extends Object>[] getSelImpTableEditors() {
		Field<? extends Object>[] editors = new Field<?>[6];
		editors[0] = null;
		editors[1] = null;
		editors[2] = null;
		editors[3] = new TextString() {
			@Override
			protected void onFocus() {
				super.onFocus();
				controlTableColEditing(getSelImpTable());
			}
		};
		editors[4] = null;
		editors[5] = null;
		return editors;
	}

	private ButtonBase getImpbtn() {
		if (Impbtn == null) {
			Impbtn = new ButtonBase() {
				@Override
				public void onClick() {
					setParameter("OT_LOG_MATERIAL",ConstantsGlobal.OT_GRD_IM);
					showPanel(new com.hkah.client.tx.ot.OTMiscCodeTable());
				}
			};
			Impbtn.setText("...");
			Impbtn.setBounds(387, 55, 30, 20);
		}
		return Impbtn;
	}

	private FieldSetBase getEquipmentPanel() {
		if (EquipmentPanel == null) {
			EquipmentPanel = new FieldSetBase();
			EquipmentPanel.setHeading("Equipment");
			EquipmentPanel.add(getAvaEquDesc(), null);
			EquipmentPanel.add(getAvaEquJScrollPane(), null);
			EquipmentPanel.add(getSelEquDesc(), null);
			EquipmentPanel.add(getSelEquJScrollPane(), null);
			EquipmentPanel.add(getEqubtn(), null);
			EquipmentPanel.setBounds(10, 143, 754, 135);
		}
		return EquipmentPanel;
	}

	private LabelBase getAvaEquDesc() {
		if (AvaEquDesc == null) {
			AvaEquDesc = new LabelBase();
			AvaEquDesc.setText("Available");
			AvaEquDesc.setBounds(10, 0, 52, 20);
		}
		return AvaEquDesc;
	}

	private JScrollPane getAvaEquJScrollPane() {
		if (AvaEquJScrollPane == null) {
			AvaEquJScrollPane = new JScrollPane();
			AvaEquJScrollPane.setViewportView(getAvaEquTable());
			AvaEquJScrollPane.setBounds(62, 0, 300, 105);
		}
		return AvaEquJScrollPane;
	}

	private TableList getAvaEquTable() {
		if (AvaEquTable == null) {
			AvaEquTable = new TableList(getEquInsTableColumnNames(), getAvaEquTableColumnWidths()) {
				@Override
				public void doubleClick() {
					if (isModify() || isAppend()) {
						replaceRow(getAvaEquTable(), getSelEquTable(), getAvaEquTable().getSelectedRow());
					}
				};
			};
			AvaEquTable.setTableLength(getListWidth());
		}
		return AvaEquTable;
	}

	protected String[] getEquInsTableColumnNames() {
		return new String[] {
				"","Otcid",
				"Description","","","otlid"
				};
	}

	protected int[] getAvaEquTableColumnWidths() {
		return new int[] { 10, 0, 260, 0, 0, 0 };
	}

	private LabelBase getSelEquDesc() {
		if (SelEquDesc == null) {
			SelEquDesc = new LabelBase();
			SelEquDesc.setText("Selected");
			SelEquDesc.setBounds(388, 0, 50, 20);
		}
		return SelEquDesc;
	}

	private JScrollPane getSelEquJScrollPane() {
		if (SelEquJScrollPane == null) {
			SelEquJScrollPane = new JScrollPane();
			SelEquJScrollPane.setViewportView(getSelEquTable());
			SelEquJScrollPane.setBounds(438, 0, 300, 105);
		}
		return SelEquJScrollPane;
	}

	private EditorTableList getSelEquTable() {
		if (SelEquTable == null) {
			SelEquTable = new EditorTableList(getSelEquTableColumnNames(), getSelEquTableColumnWidths(),
					getSelEquTableEditors()) {
				public void doubleClick() {
					if (isModify() || isAppend()) {
						selTableRemoveItem(this, getAvaEquTable());
					}
				}
			};
			SelEquTable.setTableLength(getListWidth());
			SelEquTable.setData(ConstantsVariable.NAME_VALUE, ConstantsTx.OTLOGEQUI_TXCODE);
		}
		return SelEquTable;
	}

	private TableList getDelSelEquTable() {
		if (delSelEquTable == null) {
			delSelEquTable = new TableList(getSelEquTableColumnNames(), getSelEquTableColumnWidths());
		}
		return delSelEquTable;
	}

	protected String[] getSelEquTableColumnNames() {
		return new String[] {
				"","otcid",
				"Description",
				"Remark","oleid",
				"otlid"
			};
	}

	protected int[] getSelEquTableColumnWidths() {
		return new int[] { 10,0,130,150,0,0};
	}

	private Field<? extends Object>[] getSelEquTableEditors() {
		Field<? extends Object>[] editors = new Field<?>[6];
		editors[0] = null;
		editors[1] = null;
		editors[2] = null;
		editors[3] = new TextString() {
			@Override
			protected void onFocus() {
				super.onFocus();
				controlTableColEditing(getSelEquTable());
			}
		};
		editors[4] = null;
		editors[5] = null;
		return editors;
	}

	private ButtonBase getEqubtn() {
		if (Equbtn == null) {
			Equbtn = new ButtonBase() {
				@Override
				public void onClick() {
					setParameter("OT_LOG_MATERIAL",ConstantsGlobal.OT_GRD_EQ);
					showPanel(new com.hkah.client.tx.ot.OTMiscCodeTable());
				}
			};
			Equbtn.setText("...");
			Equbtn.setBounds(387, 55, 30, 20);
		}
		return Equbtn;
	}

	private FieldSetBase getInstrumentPanel() {
		if (InstrumentPanel == null) {
			InstrumentPanel = new FieldSetBase();
			InstrumentPanel.setHeading("Instrument");
			InstrumentPanel.add(getAvaInsDesc(), null);
			InstrumentPanel.add(getAvaInsJScrollPane(), null);
			InstrumentPanel.add(getSelInsDesc(), null);
			InstrumentPanel.add(getSelInsJScrollPane(), null);
			InstrumentPanel.add(getInsbtn(), null);
			InstrumentPanel.setBounds(10, 276, 754, 135);

		}
		return InstrumentPanel;
	}

	private LabelBase getAvaInsDesc() {
		if (AvaInsDesc == null) {
			AvaInsDesc = new LabelBase();
			AvaInsDesc.setText("Available");
			AvaInsDesc.setBounds(10, 0, 52, 20);
		}
		return AvaInsDesc;
	}

	private JScrollPane getAvaInsJScrollPane() {
		if (AvaInsJScrollPane == null) {
			AvaInsJScrollPane = new JScrollPane();
			AvaInsJScrollPane.setViewportView(getAvaInsTable());
			AvaInsJScrollPane.setBounds(62, 0, 300, 105);
		}
		return AvaInsJScrollPane;
	}

	private TableList getAvaInsTable() {
		if (AvaInsTable == null) {
			AvaInsTable = new TableList(getInsInsTableColumnNames(), getAvaInsTableColumnWidths()) {
				@Override
				public void doubleClick() {
					if (isModify() || isAppend()) {
						replaceRow(AvaInsTable, SelInsTable,AvaInsTable.getSelectedRow());
					}
				};
			};
			AvaInsTable.setTableLength(getListWidth());
		}
		return AvaInsTable;
	}

	protected String[] getInsInsTableColumnNames() {
		return new String[] {
				"","Otcid",
				"Description","","","otlid"
			};
	}

	protected int[] getAvaInsTableColumnWidths() {
		return new int[] { 10, 0, 260, 0, 0, 0 };
	}

	private LabelBase getSelInsDesc() {
		if (SelInsDesc == null) {
			SelInsDesc = new LabelBase();
			SelInsDesc.setText("Selected");
			SelInsDesc.setBounds(388, 0, 50, 20);
		}
		return SelInsDesc;
	}

	private JScrollPane getSelInsJScrollPane() {
		if (SelInsJScrollPane == null) {
			SelInsJScrollPane = new JScrollPane();
			SelInsJScrollPane.setViewportView(getSelInsTable());
			SelInsJScrollPane.setBounds(438, 0, 300, 105);
		}
		return SelInsJScrollPane;
	}

	private EditorTableList getSelInsTable() {
		if (SelInsTable == null) {
			SelInsTable = new EditorTableList(getSelInsTableColumnNames(), getSelInsTableColumnWidths(),
					getSelInsTableEditors()) {
				public void doubleClick() {
					if (isModify() || isAppend()) {
						selTableRemoveItem(this, getAvaInsTable());
					}
				}
			};
			SelInsTable.setTableLength(getListWidth());
			SelInsTable.setData(ConstantsVariable.NAME_VALUE, ConstantsTx.OTLOGINST_TXCODE);
		}
		return SelInsTable;
	}

	private TableList getDelSelInsTable() {
		if (delSelInsTable == null) {
			delSelInsTable = new TableList(getSelInsTableColumnNames(), getSelInsTableColumnWidths());
		}
		return delSelInsTable;
	}

	protected String[] getSelInsTableColumnNames() {
		return new String[] {
				"","otcid",
				"Description",
				"Remark","oluid",
				"otlid"
			};
	}

	protected int[] getSelInsTableColumnWidths() {
		return new int[] { 10,0,130,150,0,0};
	}

	private Field<? extends Object>[] getSelInsTableEditors() {
		Field<? extends Object>[] editors = new Field<?>[6];
		editors[0] = null;
		editors[1] = null;
		editors[2] = null;
		editors[3] = new TextString() {
			@Override
			protected void onFocus() {
				super.onFocus();
				controlTableColEditing(getSelInsTable());
			}
		};
		editors[4] = null;
		editors[5] = null;
		return editors;
	}

	private ButtonBase getInsbtn() {
		if (Insbtn == null) {
			Insbtn = new ButtonBase() {
				@Override
				public void onClick() {
					setParameter("OT_LOG_MATERIAL",ConstantsGlobal.OT_GRD_IN);
					showPanel(new com.hkah.client.tx.ot.OTMiscCodeTable());
				}
			};
			Insbtn.setText("...");
			Insbtn.setBounds(387, 55, 30, 20);
		}
		return Insbtn;
	}

	private FieldSetBase getDrugPanel() {
		if (DrugPanel == null) {
			DrugPanel = new FieldSetBase();
			DrugPanel.setHeading("Drug");
			DrugPanel.add(getAvaDrugDesc(), null);
			DrugPanel.add(getAvaDrugJScrollPane(), null);
			DrugPanel.add(getSelDrugDesc(), null);
			DrugPanel.add(getSelDrugJScrollPane(), null);
			DrugPanel.add(getDrugbtn(), null);
			DrugPanel.setBounds(10, 411, 754, 135);

		}
		return DrugPanel;
	}

	private LabelBase getAvaDrugDesc() {
		if (AvaDrugDesc == null) {
			AvaDrugDesc = new LabelBase();
			AvaDrugDesc.setText("Available");
			AvaDrugDesc.setBounds(10, 0, 52, 20);
		}
		return AvaDrugDesc;
	}

	private JScrollPane getAvaDrugJScrollPane() {
		if (AvaDrugJScrollPane == null) {
			AvaDrugJScrollPane = new JScrollPane();
			AvaDrugJScrollPane.setViewportView(getAvaDrugTable());
			AvaDrugJScrollPane.setBounds(62, 0, 300, 105);
		}
		return AvaDrugJScrollPane;
	}

	private TableList getAvaDrugTable() {
		if (AvaDrugTable == null) {
			AvaDrugTable = new TableList(getDrugDrugTableColumnNames(), getAvaDrugTableColumnWidths()) {
				@Override
				public void doubleClick() {
					if (isModify() || isAppend()) {
						replaceRow(AvaDrugTable, SelDrugTable,AvaDrugTable.getSelectedRow());
					}
				};
			};
			AvaDrugTable.setTableLength(getListWidth());
		}
		return AvaDrugTable;
	}

	protected String[] getDrugDrugTableColumnNames() {
		return new String[] {
				"","Otcid","Description","num_1","chr_1","qty","oldcmt","oldid",
				"otlid"
				};
	}

	protected int[] getAvaDrugTableColumnWidths() {
		return new int[] { 10,0,260,0,0,0,0,0,0};
	}

	private LabelBase getSelDrugDesc() {
		if (SelDrugDesc == null) {
			SelDrugDesc = new LabelBase();
			SelDrugDesc.setText("Selected");
			SelDrugDesc.setBounds(388, 0, 50, 20);
		}
		return SelDrugDesc;
	}

	private JScrollPane getSelDrugJScrollPane() {
		if (SelDrugJScrollPane == null) {
			SelDrugJScrollPane = new JScrollPane();
			SelDrugJScrollPane.setViewportView(getSelDrugTable());
			SelDrugJScrollPane.setBounds(438, 0, 300, 105);
		}
		return SelDrugJScrollPane;
	}

	private EditorTableList getSelDrugTable() {
		if (SelDrugTable == null) {
			SelDrugTable = new EditorTableList(getSelDrugTableColumnNames(), getSelDrugTableColumnWidths(),
					getSelDrugTableEditors()) {
				public void doubleClick() {
					if (isModify() || isAppend()) {
						selTableRemoveItem(this, getAvaDrugTable());
					}
				}
			};
			SelDrugTable.setTableLength(getListWidth());
			SelDrugTable.setData(ConstantsVariable.NAME_VALUE, ConstantsTx.OTLOGDRUG_TXCODE);
		}
		return SelDrugTable;
	}

	private TableList getDelSelDrugTable() {
		if (delSelDrugTable == null) {
			delSelDrugTable = new TableList(getSelDrugTableColumnNames(), getSelDrugTableColumnWidths());
		}
		return delSelDrugTable;
	}

	protected String[] getSelDrugTableColumnNames() {
		return new String[] {
				"","otcid",
				"Description","Cost","Unit","Qty",
				"Remark","oldid","otlid"
				};
	}

	protected int[] getSelDrugTableColumnWidths() {
		return new int[] { 10,0,130,50,50,50,150,0,0};
	}

	private Field<? extends Object>[] getSelDrugTableEditors() {
		Field<? extends Object>[] editors = new Field<?>[9];
		editors[0] = null;
		editors[1] = null;
		editors[2] = null;
		editors[3] = null;
		editors[4] = null;
		editors[5] = new TextNum(8,0,false,false,true) {
			@Override
			protected void onFocus() {
				super.onFocus();
				controlTableColEditing(getSelDrugTable());
			}
		};
		editors[6] = new TextString() {
			@Override
			protected void onFocus() {
				super.onFocus();
				controlTableColEditing(getSelDrugTable());
			}
		};
		editors[7] = null;
		editors[8] = null;
		return editors;
	}

	private ButtonBase getDrugbtn() {
		if (Drugbtn == null) {
			Drugbtn = new ButtonBase() {
				@Override
				public void onClick() {
					setParameter("OT_LOG_MATERIAL",ConstantsGlobal.OT_GRD_DG);
					showPanel(new com.hkah.client.tx.ot.OTMiscCodeTable());
				}
			};
			Drugbtn.setText("...");
			Drugbtn.setBounds(387, 55, 30, 20);
		}
		return Drugbtn;
	}

	private BasePanel getDoctorProceduresPanel () {
		if (DoctorProceduresPanel == null) {
			DoctorProceduresPanel = new BasePanel();
			DoctorProceduresPanel.add(getReportDesc(), null);
			DoctorProceduresPanel.add(getHistoryDesc(), null);
			DoctorProceduresPanel.add(getReportJScrollPane(), null);
			DoctorProceduresPanel.add(getJScrollPane(), null);
			DoctorProceduresPanel.add(getCreateRpt(), null);
			DoctorProceduresPanel.add(getModifyRpt(), null);
			DoctorProceduresPanel.add(getViewRpt(), null);
			DoctorProceduresPanel.add(getPrintRpt(), null);
		}
		return DoctorProceduresPanel;
	}

	private LabelBase getReportDesc() {
		if (ReportDesc == null) {
			ReportDesc = new LabelBase();
			ReportDesc.setText("Report Description");
			ReportDesc.setBounds(10, 10, 107, 20);
		}
		return ReportDesc;
	}

	private LabelBase getHistoryDesc() {
		if (HistoryDesc == null) {
			HistoryDesc = new LabelBase();
			HistoryDesc.setText("History");
			HistoryDesc.setBounds(350, 11, 62, 20);
		}
		return HistoryDesc;
	}

	private JScrollPane getReportJScrollPane() {
		if (ReportJScrollPane == null) {
			ReportJScrollPane = new JScrollPane();
			ReportJScrollPane.setViewportView(getReportTable());
			ReportJScrollPane.setBounds(10, 35, 315, 370);
		}
		return ReportJScrollPane;
	}

	private TableList getReportTable() {
		if (ReportTable == null) {
			ReportTable = new TableList(getReportTableColumnNames(), getReportTableColumnWidths()) {
				public void onSelectionChanged() {
					if (!keepListTableRow) {
						if (ReportTable.getSelectedRow() > -1) {
							String drpid = ReportTable.getSelectedRowContent()[0];
							getListTable().setListTableContent("DRPREPORTDTLS",
									new String[] {drpid, "Saved"});
						}
					} else {
						keepListTableRow = false;
					}
				};
			};
			ReportTable.setTableLength(getListWidth());
		}
		return ReportTable;
	}

	protected String[] getReportTableColumnNames() {
		return new String[] {
				"","",
				"Description"
			};
	}

	protected int[] getReportTableColumnWidths() {
		return new int[] {0,0, 200};
	}

	private ButtonBase getCreateRpt() {
		if (CreateRpt == null) {
			CreateRpt = new ButtonBase() {
				@Override
				public void onClick() {
					// GetTemplatePath
					String tPath = getSysParameter("templ_path");
					if (tPath == null) {
						Factory.getInstance().addErrorMessage("Cannot get OT template path.");
						return;
					}
					/*
					if (getComments().getText().isEmpty()) {
						getComments().setText("\t");
					}
					*/
					getDlgOTTemplate().setTPath(tPath);
					getDlgOTTemplate().resetTmpTypeList();
					getDlgOTTemplate().show();
				}
			};
			CreateRpt.setText("Create Report");
			CreateRpt.setBounds(10, 423, 116, 20);
		}
		return CreateRpt;
	}

	public DlgOTTemplate getDlgOTTemplate() {
		if (dlgOTTemplate == null) {
			dlgOTTemplate = new DlgOTTemplate(getMainFrame(), this) {
				@Override
				protected void post() {
					String fname = getTmpNameListTable().getSelectedRowContent()[0];
					String fpath = getTmpNameListTable().getSelectedRowContent()[1];
					if (fname == null || fname.isEmpty()) {
						Factory.getInstance().addErrorMessage("Template name is empty.");
						return;
					}
					// generate template to local
					OTTmpUtil.generateReport(fpath, getTplValueJSON(), new CallbackListener() {
						@Override
						public void handleRetBool(boolean ret, String result, MessageQueue mQueue) {
//							System.out.println("DEBUG OTLogBook OTTmpUtil.generateReport return mQueue="+mQueue.getContentAsQueue());
							if (mQueue.success()) {
								String drpid = mQueue.getReturnCode();
//								System.out.println("drpid="+drpid+", memOTLID="+memOTLID+", desc="+dlgOTTemplate.getRptDesc().getText());
								if (drpid != null) {
									// success
									getReportTable().addRow(new String[] {
											drpid, memOTLID,
											dlgOTTemplate.getRptDesc().getText()});
									keepListTableRow = true;
									getReportTable().setSelectRow(getReportTable().getRowCount() - 1);

									getListTable().removeAllRow();
									getListTable().addRow(new String[] {
											drpid,
											"1",
											Factory.getInstance().getMainFrame().getServerDateTime(),
											"P",
											"Processing",
											Factory.getInstance().getUserInfo().getUserName()
									});
									isProcessingReport = true;

//									System.out.println("DEBUG" + getListTable().getRowCount());

									lockDoctorProcedures(true);
								}
							} else {
								Factory.getInstance().addErrorMessage(mQueue.getReturnMsg());
							}
						}
					});
				}
			};
		}
		return dlgOTTemplate;
	}

	private ButtonBase getModifyRpt() {
		if (ModifyRpt == null) {
			ModifyRpt = new ButtonBase() {
				@Override
				public void onClick() {
					String drpid = getListTable().getSelectedRowContent()[0];
					String drseq = getListTable().getSelectedRowContent()[1];
					String status = getListTable().getSelectedRowContent()[3];
					String fpath = null;
					if ("P".equals(status)) {
						fpath = "LOCALTEMP";
					} else if ("S".equals(status)) {
						fpath = getSysParameter("OTRPTPATH") + drpid + "\\" + drseq;
					}
					OTTmpUtil.openOTReport(drpid, fpath, false, null, false, getUserInfo().getUserID());
				}
			};
			ModifyRpt.setText("Modify Report");
			ModifyRpt.setBounds(132, 423, 116, 20);
		}
		return ModifyRpt;
	}

	private ButtonBase getViewRpt() {
		if (ViewRpt == null) {
			ViewRpt = new ButtonBase() {
				@Override
				public void onClick() {
				}
			};
			ViewRpt.setText("View Report");
			ViewRpt.setBounds(254, 423, 116, 20);
		}
		return ViewRpt;
	}

	private ButtonBase getPrintRpt() {
		if (PrintRpt == null) {
			PrintRpt = new ButtonBase() {
				@Override
				public void onClick() {
				}
			};
			PrintRpt.setText("Print Report");
			PrintRpt.setBounds(377, 423, 116, 20);
		}
		return PrintRpt;
	}
	

	private BasePanel getConsignmentPanel () {
		if (ConsignmentTrackingPanel == null) {
			ConsignmentTrackingPanel = new BasePanel();
			ConsignmentTrackingPanel.add(getConsignmentSystemButton(), null);
			ConsignmentTrackingPanel.add(getConsignmentSearchButton(), null);
		}
		return ConsignmentTrackingPanel;
	}

	private ButtonBase getConsignmentSystemButton() {
		if (consignmentSystemButton == null){ 
			consignmentSystemButton = new ButtonBase("Implant Tracking System"){
				@Override
				public void onClick() {
					showConsignmentSystem();
				}
			};
			consignmentSystemButton.setBounds(5, 5, 300, 50);
		}
		return consignmentSystemButton;
	}
	
	private ButtonBase getConsignmentSearchButton() {
		if (consignmentSearchButton == null){ 
			consignmentSearchButton = new ButtonBase("Search Implant List"){
				@Override
				public void onClick() {
					if(consignSearchUrl==null){
						consignSearchUrl = getSysParameter("CONSEARLNK");
					}
					openNewWindow("_blank", consignSearchUrl + "?patno="+ memPatNo ,"resizable=1,scrollbars=1");
				}
			};
			consignmentSearchButton.setBounds(5, 60, 300, 25);
		}
		return consignmentSearchButton;
	}
	
	private void showConsignmentSystem(){
		if(consignUrl==null){
			consignUrl = getSysParameter("CONSIGNLNK");
		}
		String newUrl = consignUrl + "?source=HATS&patno="+ memPatNo + "&otlid=" + memOTLID + "&userid=" + Factory.getInstance().getUserInfo().getUserID();
		openNewWindow("_blank", newUrl,"resizable=1,scrollbars=1");
	}
}
