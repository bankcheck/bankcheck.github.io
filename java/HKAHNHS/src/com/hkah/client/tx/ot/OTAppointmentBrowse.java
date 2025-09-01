package com.hkah.client.tx.ot;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.event.BaseEvent;
import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.DatePickerEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.GridEvent;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MenuEvent;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.event.SelectionListener;
import com.extjs.gxt.ui.client.store.ListStore;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.grid.CellSelectionModel.CellSelection;
import com.extjs.gxt.ui.client.widget.grid.ColumnData;
import com.extjs.gxt.ui.client.widget.grid.Grid;
import com.extjs.gxt.ui.client.widget.grid.GridView;
import com.extjs.gxt.ui.client.widget.layout.FitLayout;
import com.extjs.gxt.ui.client.widget.menu.Menu;
import com.google.gwt.dom.client.Element;
import com.hkah.client.Resources;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.combobox.ComboAppRoomType;
import com.hkah.client.layout.combobox.ComboAppSortby;
import com.hkah.client.layout.combobox.ComboDoctorAN;
import com.hkah.client.layout.combobox.ComboDoctorEN;
import com.hkah.client.layout.combobox.ComboDoctorSU;
import com.hkah.client.layout.combobox.ComboOTProc;
import com.hkah.client.layout.combobox.ComboOTStatus;
import com.hkah.client.layout.dialog.DlgDoctorInactive;
import com.hkah.client.layout.dialog.DlgOTAppCancelReasonSel;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.menu.MenuItemBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.panel.TabbedPaneBase;
import com.hkah.client.layout.table.GeneralGridCellRenderer;
import com.hkah.client.layout.table.MultiCellSelectionModel;
import com.hkah.client.layout.table.TableData;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextDateTimeWithoutSecond;
import com.hkah.client.layout.textfield.TextDateTimeWithoutSecondWithCheckBox;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.tx.registration.PatientStatView;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.Report;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsGlobal;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class OTAppointmentBrowse extends MasterPanel{

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;
	private static final int DVATableWidth = 969;

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.OTAPPOINTMENTBROWSE_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.OTAPPOINTMENTBROWSE_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {	
		return new String[] {
				"Otaid",
				"Allergy",
				"Reg Type",
				"Start Date/Time",
				"End Date/Time",
				"",				//MERGED
				"Patient No",
				"OTAFNAME",
				"OTAGNAME",
				"Patient Name",
				"Age",
				"Room",
				"Procedure",
				"Surgeon",
				"Notify Date/Time (Surgeon)",
				"Sec. Surgeon",
				"Notify Date/Time (Sec. Surgeon)",
				"Anesthetist",
				"Notify Date/Time (Anesthetist)",
				"Endoscopist",
				"Notify Date/Time (Endoscopist)",
				"Status",
				"Remark",
				"User",
				"Status-code",
				"SMS Sent Date/Time",
				"SMS Successful Sent Date/Time",
				"SMS Return Message"
		};		
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		int showOrHideOtExtra = 0;
		if ("TWAH".equals(siteCode)) {
			showOrHideOtExtra = 100;
		}
		return new int[] {
				0,
				20,
				40, //reg type
				120,
				120,
				30,
				80,
				0,
				0,
				120,
				50,
				60,
				120,
				100,
				120,
				100,
				120,
				100,
				120,
				100,
				120,
				60,
				60,
				60,
				0, 
				showOrHideOtExtra,
				showOrHideOtExtra,
				showOrHideOtExtra
		};		
	}

	/* >>> ~4b~ Set Table Column Cell Renderer ============================ <<< */
	protected GeneralGridCellRenderer[] getColumnRenderer() {
		return new GeneralGridCellRenderer[] {
				null,
				new OTAppBseGenAlgyRenderer(),
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null				
		};	
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private BasePanel leftPanel = null;

	public String memAlertMailPath = null;
	public final static String OT_APPSTS_N = "N";
	public final static String OT_APPSTS_C = "C";
	public final static String OT_APPSTS_F = "F";
	private final static String  memGridColorBack = "#FFFFFF";		//&H00FFFFFF&
	private final static String  memGridColorConfirm = "#00C000";	//&H0000C000&
	private final static String  memGridColorNormal = "#C00000";		//&H000000C0&
	private final static String  memGridColorMixed = "#808000";		//&H00008080&
	private final static String  memGridColorBackNormal = "#000000";	//&H00000000&
	private final static String DEFAULT_HOURS = "00:00";
	private final static String DEFAULT_HOURS_FORMAT = "dd/mm/yyyy";
	
	private final int GrdCol_OTAID = 0;
	private final int GrdCol_ALLERGY = 1;
	private final int GrdCol_PATTYPE = 2;
	private final int GrdCol_SDATE = 3;
	private final int GrdCol_EDATE = 4;
	private final int GrdCol_MERGED = 5;
	private final int GrdCol_PATNO = 6;
	private final int GrdCol_OTAFNAME = 7;
	private final int GrdCol_OTAGNAME = 8;
	private final int GrdCol_PNAME = 9;
	private final int GrdCol_AGE = 10;
	private final int GrdCol_RM = 11;
	private final int GrdCol_PROC = 12;
	private final int GrdCol_SURG = 13;
	private final int GrdCol_SNOTDATE = 14;
	private final int GrdCol_SSURG = 15;
	private final int GrdCol_SSNOTDATE = 16;
	private final int GrdCol_ANEST = 17;
	private final int GrdCol_ANOTDATE = 18;
	private final int GrdCol_ENDOPT = 19;
	private final int GrdCol_ENOTDATE = 20;
	private final int GrdCol_STATUS = 21;
	private final int GrdCol_RMK = 22;
	private final int GrdCol_USR = 23;
	private final int GrdCol_STSCODE = 24;
	private final int GrdCol_SMSDATE = 25;
	private final int GrdCol_SMSSTDATE = 26;
	private final int GrdCol_SMSRMSG = 27;

	private String[] tabType = new String[] { "OR", "ENDO", null,"CCIC" };
	private int TabbedPaneIndex = 0;
	private int tabIndex_GeneralView = 1;
	private TabbedPaneBase TabbedPane = null;

	private BasePanel GVPanel = null;
	private LabelBase CountDesc = null;
	private TextReadOnly Count = null;

	private BasePanel ParaPanel = null;
	private LabelBase StartDateDesc = null;
	private TextDateTimeWithoutSecondWithCheckBox startDate = null;
	private LabelBase EndDateDesc = null;
	private TextDateTimeWithoutSecondWithCheckBox endDate = null;
	private LabelBase StatusDesc = null;
	private ComboOTStatus Status = null;
	private LabelBase PatNoDesc = null;
	private TextPatientNoSearch PatNo = null;
	private LabelBase PatNameDesc = null;
	private TextString PatName = null;
	private LabelBase RoomDesc = null;
	private ComboAppRoomType Room = null;
	private LabelBase ProCodeDesc = null;
	private ComboOTProc ProCode = null;
	private LabelBase SurgeonDesc = null;
	private ComboDoctorSU Surgeon = null;
	private LabelBase SecSurgeonDesc = null;
	private ComboDoctorSU SecSurgeon = null;
	private LabelBase AnesthDesc = null;
	private ComboDoctorAN Anesth = null;
	private LabelBase EndoscopDesc = null;
	private ComboDoctorEN Endoscop = null;
	private LabelBase SortByDesc = null;
	private ComboAppSortby SortBy = null;

	private BasePanel DVPanel = null;
	private LabelBase DVStartDateDesc = null;
	private TextDate DVStartDate = null;
	private LabelBase Normal = null;
	private LabelBase Confirmed = null;
	private LabelBase Mixed = null;
	private TableList[] DVATable = new TableList[4];
	private JScrollPane DVAJScrollPane = null;
	private TableList[] DVBTable = new TableList[4];
	private JScrollPane DVBJScrollPane = null;

	private BasePanel DVPanel2 = null;
	private LabelBase DVStartDateDesc2 = null;
	private TextDate DVStartDate2 = null;
	private LabelBase Normal2 = null;
	private LabelBase Confirmed2 = null;
	private LabelBase Mixed2 = null;
	private JScrollPane DVAJScrollPane2 = null;
	private JScrollPane DVBJScrollPane2 = null;

	private BasePanel DVPanel3 = null;
	private LabelBase DVStartDateDesc3 = null;
	private TextDate DVStartDate3 = null;
	private LabelBase Normal3 = null;
	private LabelBase Confirmed3 = null;
	private LabelBase Mixed3 = null;
	private JScrollPane DVAJScrollPane3 = null;
	private JScrollPane DVBJScrollPane3 = null;
	
	
	private BasePanel DVPanel4 = null;
	private LabelBase DVStartDateDesc4 = null;
	private TextDate DVStartDate4 = null;
	private LabelBase Normal4 = null;
	private LabelBase Confirmed4 = null;
	private LabelBase Mixed4 = null;
	private JScrollPane DVAJScrollPane4 = null;
	private JScrollPane DVBJScrollPane4 = null;

	private ButtonBase NewApp = null;
	private ButtonBase EditApp = null;
	private ButtonBase CancelApp = null;
	private ButtonBase ConfirmApp = null;
	private ButtonBase PrintPicklist = null;
	private ButtonBase PreBooking = null;
	private ButtonBase inActiveDoctor = null;

	private DlgDoctorInactive dlgDoctorInactive = null;

	private Map<String, Integer> roomId2Col = new HashMap<String, Integer>();
	private Map<String, Integer> roomId2Col2 = new HashMap<String, Integer>();
	private Map<String, Integer> roomId2Col3 = new HashMap<String, Integer>();
	private Map<String, Integer> roomId2Col4 = new HashMap<String, Integer>();
	private int lotPBPID = 0;
	private String memCurrDT = null;
	private String memFromPreBooking = null;
	private String[] firstLoadDate = new String[] { null, null, null, null };

	private Map<String, List<String>> RowColID_Col = new LinkedHashMap<String, List<String>>();
	private Map<String, List<String>> RowColID_Col2 = new LinkedHashMap<String, List<String>>();
	private Map<String, List<String>> RowColID_Col3 = new LinkedHashMap<String, List<String>>();
	private Map<String, List<String>> RowColID_Col4 = new LinkedHashMap<String, List<String>>();
	private String[] bkgColorTemplate = new String[] {
			"ot-cell-bkgcolor1", "ot-cell-bkgcolor2", "ot-cell-bkgcolor3",
			"ot-cell-bkgcolor4", "ot-cell-bkgcolor5", "ot-cell-bkgcolor6",
			"ot-cell-bkgcolor7", "ot-cell-bkgcolor8", "ot-cell-bkgcolor9"
	};
	private int bkgColorTemplateUsed = 0;
	private String[][] DVATableColumnNames = new String[4][];    // dynamic
	private int[][] DVATableColumnWidths = new int[4][];  // dynamic
	private GeneralGridCellRenderer[][] DVATableColumnCellRenderers = new GeneralGridCellRenderer[4][];   // dynamic
	private MultiCellSelectionModel<TableData> cellSelectionModel = null;

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;
	private final String siteCode = Factory.getInstance().getSysParameter("curtSite");

	private Menu contextMenu = null;
	private MenuItemBase editAppMenu = null;
	private MenuItemBase cancelAppMenu = null;
	private MenuItemBase confirmAppMenu = null;

	/**
	 * This method initializes
	 *
	 */
	public OTAppointmentBrowse() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		setLeftAlignPanel();
		getJScrollPane().setBounds(5, 135, 759, 275);
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		getListTable().setContextMenu(getPopupMenu());

		firstLoadDate[0] = null;
		firstLoadDate[1] = null;
		firstLoadDate[2] = null;
		memFromPreBooking = getParameter("FromPreBooking");

		try {
			lotPBPID = Integer.parseInt(getParameter("lotPBPID"));
		} catch (Exception e) {
			lotPBPID = 0;
		}

		if (lotPBPID > 0) {
			QueryUtil.executeMasterFetch(
					getUserInfo(),
					ConstantsTx.LOOKUP_TXCODE,
					new String[] {"BEDPREBOK", "TO_CHAR(BPBHDATE, 'DD/MM/YYYY')", "PBPID = '" + lotPBPID + "'"},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						memCurrDT = mQueue.getContentField()[0];
					} else {
						memCurrDT = getMainFrame().getServerDate();
					}
					initDateField();
				}
			});
		} else {
			memCurrDT = getMainFrame().getServerDate();
			initDateField();
		}

		if (getSysParameter("OTTABVIEW").isEmpty() || getSysParameter("OTTABVIEW").equals("S")) {
			tabIndex_GeneralView = 1;
			initDVATableColumns(0);
		} else if (HKAH_VALUE.equals(getUserInfo().getSiteCode())) {
			tabIndex_GeneralView = 3;
			initDVATableColumns(0);
			initDVATableColumns(1);
			initDVATableColumns(2);
		} else {
			tabIndex_GeneralView = 4;
			initDVATableColumns(0);
			initDVATableColumns(1);
			initDVATableColumns(2);
			initDVATableColumns(3);
		}
		getTabbedPane().setSelectedIndex(tabIndex_GeneralView);

		getCount().setText(ZERO_VALUE);

		enableButton();
	}

	@Override
	public void rePostAction() {
		refreshAction();
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextDateTimeWithoutSecond getDefaultFocusComponent() {
		return getStartDate().getDateField();
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
		return true;
	}
	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
				getStartDate().getText(),
				getEndDate().getText(),
				getStatus().getText(),
				getPatNo().getText(),
				getPatName().getText(),
				getRoom().getText(),
				getProCode().getText(),
				getSurgeon().getText(),
				getSecSurgeon().getText(),
				getAnesth().getText(),
				getEndoscop().getText(),
				getSortBy().getText()
		};
	}

	/* >>> ~15~ Set Fetch Output Results ============================== <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {}

	/* >>> ~16~ Set Fetch Input Parameters ================================ <<< */
	@Override
	protected String[] getFetchInputParameters() {
		String[] selectedContent = getListSelectedRow();
		return new String[] {
				selectedContent[GrdCol_OTAID]
		};
	}
	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {
		enableButton();
		setTotalCount();
	}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return new String[] {};
	}

	/* >>> ~16.1~ Set Action Output Parameters =========================== <<< */
	@Override
	protected void getNewOutputValue(String returnValue) {}

	@Override
	protected void performListNoRecordPostMsg(MessageQueue mQueue) {}

	/***************************************************************************
	* Override Method
	**************************************************************************/

	@Override
	protected void proExitPanel() {
		if (lotPBPID > 0) {
			setParameter("CallBackPSV", "T");
		}
	}

	@Override
	protected void enableButton() {
		disableButton();

		int tabIndex = getTabbedPane().getSelectedIndex();
		if (tabIndex == tabIndex_GeneralView) {
			getSearchButton().setEnabled(true);
			getRefreshButton().setEnabled(false);
		} else {
			getSearchButton().setEnabled(false);
			getRefreshButton().setEnabled(true);
		}

		controlAppButtons();
	}

	@Override
	public void refreshAction() {
		DVATableRefresh(getTabbedPane().getSelectedIndex(), true);
	}

	@Override
	protected void performListPost() {
		// for child class call
		enableButton();
	}

	/***************************************************************************
	* Helper Method
	**************************************************************************/

	private void initDateField() {
		getStartDate().setText(memCurrDT + " 00:00");
		getEndDate().setText(memCurrDT + " 23:59");
		getDVStartDate().setText(memCurrDT);
		getDVStartDate2().setText(memCurrDT);
		getDVStartDate3().setText(memCurrDT);
		getDVStartDate4().setText(memCurrDT);
	}

	private void setTotalCount() {
		getCount().setText(String.valueOf(getListTable().getRowCount()));
	}

	private void controlAppButtons() {
		boolean isAppEditable = false;
		String otasts = null;

		int tabIndex = getTabbedPane().getSelectedIndex();
		if (tabIndex == tabIndex_GeneralView) {
			if (getListTable() != null && getListTable().getSelectedRow() >= 0) {
				otasts = getListTable().getSelectedRowContent()[GrdCol_STSCODE];
			}
		} else if (tabIndex >= 0) {
			if (getDVBTable(tabIndex) != null && getDVBTable(tabIndex).getSelectedRow() >= 0) {
				otasts = getDVBTable(tabIndex).getSelectedRowContent()[19];
			}
		}

		if (OT_APPSTS_N.equals(otasts)) {
			isAppEditable = true;
		}

		if (isAppEditable) {
			getEditApp().setEnabled(true);
			getCancelApp().setEnabled(true);
			getConfirmApp().setEnabled(true);

			getEditAppMenu().setEnabled(true);
			getCancelAppMenu().setEnabled(true);
			getConfirmAppMenu().setEnabled(true);
		} else {
			getEditApp().setEnabled(false);
			getCancelApp().setEnabled(false);
			getConfirmApp().setEnabled(false);

			getEditAppMenu().setEnabled(false);
			getCancelAppMenu().setEnabled(false);
			getConfirmAppMenu().setEnabled(false);
		}

		getPreBooking().setEnabled(true);
		if (memFromPreBooking != null && "srhPatStsView".equals(memFromPreBooking)) {
			getPreBooking().setEnabled(false);
		}

		if (!isDisableFunction("btnOTAppDisable", "otAppBrowse")) {
			getNewApp().setEnabled(false);
			getEditApp().setEnabled(false);
			getCancelApp().setEnabled(false);
			getConfirmApp().setEnabled(false);
			getPreBooking().setEnabled(false);
			getInActiveDoctor().setEnabled(false);

			getEditAppMenu().setEnabled(false);
			getCancelAppMenu().setEnabled(false);
			getConfirmAppMenu().setEnabled(false);

			getPrintPicklist().setEnabled(true);
		}
	}

	private String getSelectedOtaid() {
		String otaid = null;

		int tabIndex = getTabbedPane().getSelectedIndex();
		if (tabIndex == tabIndex_GeneralView) {
			otaid = getListTable().getSelectedRowContent()[GrdCol_OTAID];
		} else if (tabIndex >= 0) {
			otaid = getDVBTable(tabIndex).getSelectedRowContent()[1];
		}

		return otaid;
	}
	
	private String getSelectedRegType() {
		String regType = null;

		int tabIndex = getTabbedPane().getSelectedIndex();
		if (tabIndex == tabIndex_GeneralView) {
			regType = getListTable().getSelectedRowContent()[GrdCol_PATTYPE];
		}

		return regType;
	}	

	private Map<String, List<String>> getRowColID_Col(int tabNo) {
		if (tabNo == 3) {
			return RowColID_Col4;
		} else if (tabNo == 2) {
			return RowColID_Col3;
		} else if (tabNo == 1) {
			return RowColID_Col2;
		} else {
			return RowColID_Col;
		}
	}

	private int getRoomId2Col(int tabNo, String roomID) {
		if (tabNo == 3) {
			return roomId2Col4.get(roomID);
		} else if (tabNo == 2) {
			return roomId2Col3.get(roomID);
		} else if (tabNo == 1) {
			return roomId2Col2.get(roomID);
		} else {
			return roomId2Col.get(roomID);
		}
	}

	private void setRoomID2Col(int tabNo, String roomID, int column) {
		if (tabNo == 3) {
			roomId2Col4.put(roomID, column);
		}else if (tabNo == 2) {
			roomId2Col3.put(roomID, column);
		} else if (tabNo == 1) {
			roomId2Col2.put(roomID, column);
		} else {
			roomId2Col.put(roomID, column);
		}
	}

	private TextDate getDVStartDate(int tabNo) {
		if (tabNo == 3) {
			return getDVStartDate4();
		} else if (tabNo == 2) {
			return getDVStartDate3();
		} else if (tabNo == 1) {
			return getDVStartDate2();
		} else {
			return getDVStartDate();
		}
	}

	private void setGrdAppBseViewRefresh(int tabNo, int rowNo, int colNo) {
		List<String> tempOTAID = getRowColID_Col(tabNo).get(String.valueOf(rowNo) + "-" + String.valueOf(colNo));
		int OTAID_Count = -1;
		int i = -1;
		StringBuffer OTAID_sql = new StringBuffer();

		if (tempOTAID == null) {
			OTAID_sql.append(" and 1=2 ");
		} else {
			OTAID_Count = tempOTAID.size();
			OTAID_sql.append(" and a.otaid in (");
			i = 0;
			OTAID_sql.append("'");
			OTAID_sql.append(tempOTAID.get(i));
			OTAID_sql.append("'");

			for (i = 1; i <= OTAID_Count - 1; i++) {
				OTAID_sql.append(", '");
				OTAID_sql.append(tempOTAID.get(i));
				OTAID_sql.append("'");
			}

			OTAID_sql.append(") ");
		}

		getDVBTable(tabNo).setListTableContent("DVBTABLELIST", new String[] {OTAID_sql.toString()});
	}

	private void DVATableRefresh(int tabNo, boolean skipcheck) {
		if (tabNo >= 0 && tabNo < tabIndex_GeneralView) {
			if (firstLoadDate[tabNo] == null || !getDVStartDate(tabNo).getText().equals(firstLoadDate[tabNo]) || skipcheck) {
				firstLoadDate[tabNo] = getDVStartDate(tabNo).getText();
				DVATableRefreshHelper(tabNo,
						getBlankDVATableData(tabNo), getBlankDVATableData(tabNo), getBlankDVATableData(tabNo),
						getDVStartDate(tabNo).getText());
			}
		}
	}

	private void DVATableRefreshHelper(final int tabNo,
			final List<TableData> tempTextData, final List<TableData> tempTxtColorData, final List<TableData> tempBkgColorData,
			final String dvStartDate) {
		Factory.getInstance().showMask();
		getMainFrame().setLoading(true);
		getDVBTable(tabNo).removeAllRow();
		getDVATable(tabNo).removeAllRow();
		getDVATable(tabNo).getStore().removeAll();
		getDVATable(tabNo).getStore().add(getBlankDVATableData(tabNo));
		getDVATable(tabNo).getView().refresh(true);
		getDVATable(tabNo).getView().layout();
		getRowColID_Col(tabNo).clear();

		String listTxCode = null;
		String[] listTxParam = null;
		if ((getSysParameter("OTTABVIEW").isEmpty() || getSysParameter("OTTABVIEW").equals("S")) && tabNo < 2) {
			listTxCode = "DVATABLELIST";
			listTxParam = new String[] {dvStartDate, getUserInfo().getSiteCode()};
		} else {
			listTxCode = "DVATABLELIST2";
			listTxParam = new String[] {dvStartDate, getUserInfo().getSiteCode(), tabType[tabNo]};
		}

		QueryUtil.executeMasterBrowse(getUserInfo(), listTxCode, listTxParam,
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					String[] record = TextUtil.split(mQueue.getContentAsQueue(), TextUtil.LINE_DELIMITER);
					String[] fields = null;
					Object[] row = null;
					int colno = -1;
					int[] slotRow = null;
					int S_SlotRowNo = -1;
					int E_SlotRowNo = -1;
					StringBuffer temp = new StringBuffer();
					for (int i = 0; i < record.length; i++) {
						fields = TextUtil.split(record[i]);
						row = new Object[fields.length];
						if (!TextUtil.FIELD_DELIMITER.equals(record[i])) {
//                          addRow(fields);
							for (int n = 0; n < fields.length; n++) {
								if (fields[n] == null) {
									row[n] = "";
								} else {
									row[n] = fields[n];
								}
							}

							colno = getRoomId2Col(tabNo, (String) row[4]);

							slotRow = getRtnSlotRowNo(String.valueOf(row[2]), String.valueOf(row[3]), dvStartDate);
							S_SlotRowNo = slotRow[0];
							E_SlotRowNo = slotRow[1];
							String content = row[7] + " - " + row[8] + " (" + row[0] + ")";

							if (S_SlotRowNo == E_SlotRowNo) {
								temp.setLength(0);
								temp.append((String) tempTextData.get(S_SlotRowNo).getValue(colno));
								if (temp.length() > 0) {
									temp.append(COMMA_VALUE);
									temp.append(SPACE_VALUE);
								}
								temp.append(content);

								tempTextData.get(S_SlotRowNo).setValue(colno, temp.toString());
								setCellColor(tempTxtColorData, S_SlotRowNo, colno, row[1].toString());
								setAddOTAID(tabNo, S_SlotRowNo, colno, row[0].toString());
							} else {
								temp.setLength(0);
								temp.append((String) tempTextData.get(S_SlotRowNo).getValue(colno));
								if (temp.length() > 0) {
									temp.append(COMMA_VALUE);
									temp.append(SPACE_VALUE);
								}
								temp.append(content);

								tempTextData.get(S_SlotRowNo).setValue(colno, temp.toString());
								setCellColor(tempTxtColorData, S_SlotRowNo, colno, row[1].toString());
								setAddOTAID(tabNo, S_SlotRowNo, colno, row[0].toString());

								for (int k = S_SlotRowNo + 1; k <= E_SlotRowNo; k++) {
									temp.setLength(0);
									temp.append((String) tempTextData.get(k).getValue(colno));
									if (temp.length() > 0) {
										temp.append(COMMA_VALUE);
										temp.append(SPACE_VALUE);
									}
									temp.append(content);

									tempTextData.get(k).setValue(colno, temp.toString());
									setCellColor(tempTxtColorData, k, colno, row[1].toString());
									setAddOTAID(tabNo, k, colno, row[0].toString());
								}
							}
						}
					}

					if (record.length > 0) {
						setBackgroundColor(tempTextData, tempBkgColorData);
						setTextColor(tempTextData, tempTxtColorData);
						getDVATable(tabNo).getStore().removeAll();
						getDVATable(tabNo).getStore().add(tempTextData);
						setBackgroundColorToView(tabNo, tempBkgColorData);
					}
				}

				getDVATable(tabNo).getView().layout();
				getMainFrame().setLoading(false);
				Factory.getInstance().hideMask();
			}
		});
	}

	private int[] getRtnSlotRowNo(String appSTime, String appETime, String dCurDate) {

		int SlotNo1 = DateTimeUtil.timeDiff(DEFAULT_HOURS, appSTime.substring(11, 16)) / 15;
		int SlotNo2 = DateTimeUtil.timeDiff(DEFAULT_HOURS, appETime.substring(11, 16)) / 15;
		int S_SlotRowNo = SlotNo1;
		int E_SlotRowNo = SlotNo2;
		int SlotTotal = 96;

		if (dCurDate != null && !"".equals(dCurDate)) {
			if (DateTimeUtil.dateDiff(appSTime.substring(0, 10), appETime.substring(0, 10)) != 0) {
				if (DateTimeUtil.toDate(dCurDate, DEFAULT_HOURS_FORMAT).equals(DateTimeUtil.toDate(appSTime.substring(0, 10), DEFAULT_HOURS_FORMAT))) {
					E_SlotRowNo = SlotTotal - 1;
				} else if (DateTimeUtil.toDate(dCurDate, DEFAULT_HOURS_FORMAT).equals(DateTimeUtil.toDate(appETime.substring(0, 10), DEFAULT_HOURS_FORMAT))) {
					S_SlotRowNo = 0;
				} else {
					S_SlotRowNo = 0;
					E_SlotRowNo = SlotTotal - 1;
				}
			}
		}
		return new int[] {S_SlotRowNo, E_SlotRowNo};
	}

	private void setAddOTAID(int tabNo, int rowNo, int colNo, String otaID) {
		List<String> SlotOTAID_COL  = getRowColID_Col(tabNo).get(String.valueOf(rowNo) + "-" + String.valueOf(colNo));
		if (SlotOTAID_COL == null) {
			SlotOTAID_COL = new ArrayList<String>();
			SlotOTAID_COL.add(otaID);
			getRowColID_Col(tabNo).put(String.valueOf(rowNo) + "-" + String.valueOf(colNo), SlotOTAID_COL);
		} else {
			SlotOTAID_COL.add(otaID);
		 }
	}

	private void setCellColor(List<TableData> tempData, int rowNo, int colNo, String status) {
		String color = (String) tempData.get(rowNo).getValue(colNo);
		if (color == null || color.length() == 0) {
			color = memGridColorBackNormal;
		}

		if (OT_APPSTS_N.equals(status) && memGridColorBackNormal.equals(color)) {
			color = memGridColorNormal;
		} else if (OT_APPSTS_F.equals(status) && memGridColorBackNormal.equals(color)) {
			color = memGridColorConfirm;
		} else if ((OT_APPSTS_N.equals(status) && memGridColorConfirm.equals(color))
					||
				(OT_APPSTS_F.equals(status) && memGridColorNormal.equals(color))) {
			color = memGridColorMixed;
		} else {
			if (memGridColorBackNormal.equals(color)) {
				color = "";
			}
		}

		tempData.get(rowNo).setValue(colNo, color);
	}

	private void setTextColor(List<TableData> tempData, List<TableData> txtColorData) {
		for (int i = 0; i < tempData.size(); i++) {
			for (int j = 1; j < txtColorData.get(0).getSize(); j++) {
				if (((String) txtColorData.get(i).getValue(j)).length() > 0) {
					tempData.get(i).setValue(j, "<span style='color:" + txtColorData.get(i).getValue(j) + "'>" + tempData.get(i).getValue(j) + "</span>");
				}
			}
		}
	}

	private void setBackgroundColor(List<TableData> tempData, List<TableData> bkgColorData) {
		bkgColorTemplateUsed = 0;
		String cellValue1 = null;
		String cellValue2 = null;
		for (int j = 1; j < bkgColorData.get(0).getSize(); j++) {
			for (int i = tempData.size() - 1; i > 0; i--) {
				cellValue1 = ((String) tempData.get(i - 1).getValue(j)).trim();
				cellValue2 = ((String) tempData.get(i).getValue(j)).trim();

				if (cellValue1.length() > 0 && cellValue2.length() > 0) {
					if (cellValue1.equals(cellValue2)) {
						bkgColorData.get(i).setValue(j, bkgColorTemplate[bkgColorTemplateUsed % bkgColorTemplate.length]);
						bkgColorData.get(i - 1).setValue(j, bkgColorTemplate[bkgColorTemplateUsed % bkgColorTemplate.length]);
						tempData.get(i).setValue(j, EMPTY_VALUE);
					} else {
						bkgColorData.get(i).setValue(j, bkgColorTemplate[bkgColorTemplateUsed % bkgColorTemplate.length]);
						bkgColorTemplateUsed++;
						bkgColorData.get(i - 1).setValue(j, bkgColorTemplate[bkgColorTemplateUsed % bkgColorTemplate.length]);
					}
				} else if (cellValue1.length() > 0 && cellValue2.length() == 0) {
					bkgColorTemplateUsed++;
					bkgColorData.get(i - 1).setValue(j, bkgColorTemplate[bkgColorTemplateUsed % bkgColorTemplate.length]);
				} else if (cellValue1.length() == 0 && cellValue2.length() > 0) {
					bkgColorData.get(i).setValue(j, bkgColorTemplate[bkgColorTemplateUsed % bkgColorTemplate.length]);
					bkgColorTemplateUsed++;
				}
			}
		}
	}

	private void setBackgroundColorToView(int tabNo, List<TableData> bkgColor) {
		Element cell = null;
		for (int i = 0; i < bkgColor.size(); i++) {
			for (int j = 1; j < bkgColor.get(0).getSize(); j++) {
				cell = getDVATable(tabNo).getView().getCell(i, j);
				if (cell != null) {
					if (!bkgColor.get(i).getValue(j).toString().isEmpty()) {
						cell.addClassName(bkgColor.get(i).getValue(j).toString());
					}
				}
			}
		}
	}

	private MultiCellSelectionModel<TableData> getCellSelectionModel() {
		if (cellSelectionModel == null) {
			cellSelectionModel = new MultiCellSelectionModel<TableData>() {
				@Override
				public void selectCell(int row, int cell) {
					if (cell != 0) {
						return;
					} else {
						super.selectCell(row, cell);
					}
				}
			};
		}

		return cellSelectionModel;
	}

	private List<TableData> getBlankDVATableData(int tabNo) {
		List<TableData> blankDVATableData = new ArrayList<TableData>();

		for (int i = 0; i < 96; i++) {
			String hour;
			String second;
			int h = i/4;
			int s = (i % 4) * 15;
			if (h != 0) {
				if (h < 10) {
					hour = "0".concat(String.valueOf(h));
				} else {
					hour = String.valueOf(h);}
			} else {
				hour = "00";
			}
			if (s != 0) {
				second = String.valueOf(s);
			} else {
				second = "00";
			}

			if (getDVATableColumnNames(tabNo) != null) {
				int colLen2 = getDVATableColumnNames(tabNo).length;
				String[] values2 = new String[colLen2];

				if (values2 != null && values2.length > 0) {
					values2[0] = hour.concat(":").concat(second);
				}

				blankDVATableData.add(new TableData(getDVATableColumnNames(tabNo), values2));
			}
		}

		return blankDVATableData;
	}

	private void initDVATable(final int tabNo) {
//      DVATable = null; // reset table to feed dynamic column names and widths
		getDVATable(tabNo).getStore().removeAll();
		getDVATable(tabNo).getView().refresh(true);
		getDVATable(tabNo).getView().setSortingEnabled(false);
//		DVATableRefresh(tabNo, true);
		if (tabNo == 3) {
			getDVAJScrollPane4().setViewportView(getDVATable(tabNo));
			getDVAJScrollPane4().layout();
			getDVPanel4().layout();
		} else if (tabNo == 2) {
			getDVAJScrollPane3().setViewportView(getDVATable(tabNo));
			getDVAJScrollPane3().layout();
			getDVPanel3().layout();
		} else if (tabNo == 1) {
			getDVAJScrollPane2().setViewportView(getDVATable(tabNo));
			getDVAJScrollPane2().layout();
			getDVPanel2().layout();
		} else {
			getDVAJScrollPane().setViewportView(getDVATable(tabNo));
			getDVAJScrollPane().layout();
			getDVPanel().layout();
		}
	}

	private void initDVATableColumns(final int tabNo) {
		QueryUtil.executeMasterBrowse(getUserInfo(), "OT_ROOM",
				new String[] { tabType[tabNo] },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					String[] record = TextUtil.split(mQueue.getContentAsQueue(),
							TextUtil.LINE_DELIMITER);

					String[] columnNames = new String[record.length + 1];
					int[] columnWidths = new int[record.length + 1];
					GeneralGridCellRenderer[] columnCellRenderers = new GeneralGridCellRenderer[record.length + 1];

					columnNames[0] = " ";
					columnWidths[0] = 50;
					columnCellRenderers[0] = new GeneralGridCellRenderer() {
						@Override
						public Object render(TableData model, String property,
								ColumnData config,
								int rowIndex, int colIndex, ListStore<TableData> store,
								Grid<TableData> grid) {
							return renderHelper((String) model.getValue(colIndex), null);
						}
					};

					String[] fields = null;
					Object[] row = null;
					for (int i = 0; i < record.length; i++) {
						fields = TextUtil.split(record[i]);
						row = new Object[fields.length];
						if (!TextUtil.FIELD_DELIMITER.equals(record[i])) {
//                          addRow(fields);
							for (int n = 0; n < fields.length; n++) {
								if (fields[n].equals(null)) {
									row[n] = "";
								} else {
									row[n] = fields[n];
								}
							}
						}
						int colIdx = i + 1;

						setRoomID2Col(tabNo, (String) row[0], colIdx);
						columnNames[colIdx] = (String) row[1];
						columnWidths[colIdx] = (DVATableWidth - 270) / record.length;
						columnCellRenderers[colIdx] = new GeneralGridCellRenderer() {
							@Override
							public Object render(TableData model, String property,
									ColumnData config,
									int rowIndex, int colIndex, ListStore<TableData> store,
									Grid<TableData> grid) {
								return renderHelper((String) model.getValue(colIndex), null);
							}
						};
					}

					setDVATableColumnNames(tabNo, columnNames);
					setDVATableColumnWidths(tabNo, columnWidths);
					setDVATableColumnCellRenderers(tabNo, columnCellRenderers);
					initDVATable(tabNo);
				}
			}
		});
	}

	protected String[] getDVATableColumnNames(int tabNo) {
		return DVATableColumnNames[tabNo];
	}

	protected void setDVATableColumnNames(int tabNo, String[] columnNames) {
		DVATableColumnNames[tabNo] = columnNames;
	}

	protected int[] getDVATableColumnWidths(int tabNo) {
		return DVATableColumnWidths[tabNo];
	}

	protected void setDVATableColumnWidths(int tabNo, int[] columnWidths) {
		DVATableColumnWidths[tabNo] = columnWidths;
	}

	protected GeneralGridCellRenderer[] getDVATableColumnCellRenderers(int tabNo) {
		return DVATableColumnCellRenderers[tabNo];
	}

	protected void setDVATableColumnCellRenderers(int tabNo, GeneralGridCellRenderer[] columnCellRenderers) {
		DVATableColumnCellRenderers[tabNo] = columnCellRenderers;
	}

	public void setTabbedPaneIndex(int index) {
		this.TabbedPaneIndex = index;
	}

	public int getTabbedPaneIndex() {
		return TabbedPaneIndex;
	}

	protected void onDVStartDateChange(int tabNo) {
		DVATableRefresh(tabNo, false);
	}

	private void editApp() {
		setParameter("otaid", getSelectedOtaid());
		setParameter("ActionType", QueryUtil.ACTION_MODIFY);
		setParameter("otApp_bIsEdit", YES_VALUE);
		showPanel(new NewEditOTApp());
	}

	protected void cancelAppAlert() {
		Factory.getInstance().isConfirmYesNoDialog(ConstantsMessage.MSG_CANCEL_OT_APP,
				new Listener<MessageBoxEvent>() {
			@Override
			public void handleEvent(MessageBoxEvent be) {
				if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
					cancelApp();
				}
			}
		});
	}

	protected void cancelApp() {
		DlgOTAppCancelReasonSel dlg = new DlgOTAppCancelReasonSel(getMainFrame()) {
			@Override
			protected void save(String cancelCode,String isAdmittedCode, String cancelByCode, String otherCode, String remark) {
				cancelApp2(cancelCode, isAdmittedCode, cancelByCode, otherCode, remark);
			}
		};
		dlg.show();
	}

	protected void cancelApp2(String cancelCode,String isAdmittedCode, String cancelByCode, String otherCode, String remark) {
		QueryUtil.executeMasterAction(
				Factory.getInstance().getUserInfo(), "OTAPP_CANC",
				QueryUtil.ACTION_MODIFY,
				new String[] {getSelectedOtaid(), cancelCode, isAdmittedCode, cancelByCode, otherCode, remark},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					cancelApp3(getSelectedOtaid(),getSelectedRegType());
				} else {
					Factory.getInstance().addErrorMessage(mQueue);
				}
			}
		});
	}

	protected void cancelApp3(final String otaid, final String regType) {
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] {"BedPreBok", "count(*)", "otaid = '" + otaid + "' and BPBSTS = '" + ConstantsGlobal.PB_NORMAL_STS +"'"},
				new MessageQueueCallBack() {
			public void onPostSuccess(MessageQueue m) {
				if (m.success()) {
					int ret = 0;
					try {
						ret = Integer.parseInt(m.getContentField()[0]);
					} catch (Exception e) {}

					if (ret > 0) {
						if("D".equals(regType)){
							cancelAppPostAction(true);
						}else{
							Factory.getInstance().addErrorMessage(
									"You may want to delete the pre-booking record if the patient is not going to admit.",
									new Listener<MessageBoxEvent>() {
								@Override
								public void handleEvent(MessageBoxEvent be) {
									cancelAppPostAction(true);
								}
							});							
						}
					} else {
						cancelAppPostAction(false);
					}
				}
			}

			@Override
			public void onFailure(Throwable caught) {
				cancelAppPostAction(false);
			}
		});
	}

	protected void cancelAppPostAction(boolean ret) {
		String patno = null;
		String startDate = null;
		String endDate = null;
		String roomName = null;
		String surgeon = null;
		String anes = null;
		String endo = null;

		int tabIndex = getTabbedPane().getSelectedIndex();
		if (tabIndex == tabIndex_GeneralView) {
			patno = getListSelectedRow()[6];
			startDate = getListSelectedRow()[3];
			endDate = getListSelectedRow()[4];
			roomName = getListSelectedRow()[11];
			surgeon = getListSelectedRow()[13];
			anes = getListSelectedRow()[15];
			endo = getListSelectedRow()[17];
		} else if (tabIndex >= 0) {
			patno = getDVBTable(tabIndex).getSelectedRowContent()[5];
			startDate = getDVBTable(tabIndex).getSelectedRowContent()[2];
			endDate = getDVBTable(tabIndex).getSelectedRowContent()[3];
			roomName = getDVBTable(tabIndex).getSelectedRowContent()[20];
			surgeon = getDVBTable(tabIndex).getSelectedRowContent()[14];
			anes = getDVBTable(tabIndex).getSelectedRowContent()[15];
			endo = getDVBTable(tabIndex).getSelectedRowContent()[16];
		}

		String funname = "OT Appointment -> Cancel App";
		Map<String, String> params = new HashMap<String, String>();
		if (endo == null || "".equals(endo)) {
			params.put("Room", roomName);
			params.put("App Start Date", startDate);
			params.put("App End Date", endDate);
			params.put("Surgeon", surgeon);
			params.put("Anesthetist", anes);
		} else {
			params.put("Room", roomName);
			params.put("App Start Date", startDate);
			params.put("App End Date", endDate);
			params.put("Anesthetist", anes);
			params.put("Endoscopist", endo);
		}
		getAlertCheck().checkAltAccess(patno, funname, true, true, params);
		searchAction();
	}

	private void confirmApp() {
		int tabIndex = getTabbedPane().getSelectedIndex();
		if (tabIndex == tabIndex_GeneralView) {
			setParameter("OTAID", getListSelectedRow()[GrdCol_OTAID]);
			setParameter("PATNO", getListSelectedRow()[GrdCol_PATNO]);
		} else if (tabIndex >= 0) {
			setParameter("OTAID", getDVBTable(tabIndex).getSelectedRowContent()[1]);
			setParameter("PATNO", getDVBTable(tabIndex).getSelectedRowContent()[5]);
		}
		setParameter("MODE", ConstantsGlobal.OT_LOG_MODE_NEW);

		if (getListSelectedRow() != null) {
			setParameter("OTASDATE", getListSelectedRow()[GrdCol_SDATE].substring(0, 10));
		}
		resetParameter("OTLID");
		setParameter("ActionType", QueryUtil.ACTION_APPEND);

		showPanel(new OTLogBook());
	}

	protected void printRptOtAppListing() {
		String patno = getPatNo().getText();
		String patNmae = getPatName().getText();
		String startDate = null;
		String endDate = null;
		String statusDisplay = getStatus().getDisplayText();
		String proCodeDisplay = getProCode().getDisplayText();
		String roomNameDisplay = getRoom().getDisplayText();
		String surgeonDisplay = getSurgeon().getDisplayText();
		String anesDisplay = getAnesth().getDisplayText();
		String endoDisplay = getEndoscop().getDisplayText();
		int tabSelected = 0;
		int tabIndex = getTabbedPane().getSelectedIndex();

		if (tabIndex == tabIndex_GeneralView) {
			startDate = TextUtil.parseStrUTF8(getStartDate().getText());
			endDate = TextUtil.parseStrUTF8(getEndDate().getText());
			tabSelected = 1;
		} else {
			if (getTabbedPane().getSelectedIndex() == 2) {
				startDate = getDVStartDate3().getText();
				endDate = getDVStartDate3().getText();
			} else if (getTabbedPane().getSelectedIndex() == 1) {
				startDate = getDVStartDate2().getText();
				endDate = getDVStartDate2().getText();
			} else {
				startDate = getDVStartDate().getText();
				endDate = getDVStartDate().getText();
			}
			tabSelected = 0;
		}

		HashMap<String, String> map = new HashMap<String, String>();
		map.put("OT_AppSDate", startDate);
		map.put("OT_AppEDate", endDate);
		map.put("PatNo", patno);
		map.put("PatName", patNmae);
		map.put("Status", statusDisplay);
		map.put("ProCode", proCodeDisplay);
		map.put("Surgeon", surgeonDisplay);
		map.put("Anesth", anesDisplay);
		map.put("Endoscop", endoDisplay);
		map.put("Room", roomNameDisplay);
		map.put("DialyReport", String.valueOf(tabSelected)); //if NOT on General View show start date ONLY
		map.put("SiteName", Factory.getInstance().getUserInfo().getSiteName());
		map.put("SUBREPORT_DIR",CommonUtil.getReportDir());

		Report.print(Factory.getInstance().getUserInfo(),
					"RptOTAppListing", map,
					new String[] {
							startDate,
							endDate,
							getStatus().getText(),
							getPatNo().getText(),
							getPatName().getText(),
							getRoom().getText(),
							getProCode().getText(),
							getSurgeon().getText(),
							getAnesth().getText(),
							getEndoscop().getText(),
							String.valueOf(tabSelected),
							"DAYCASE".equals(getSortBy().getText())?"D":""
					},
					new String[] {
							"RMDESC",
							"DOCCODE_S",
							"DOCCODE",
							"STARTTIME",
							"PATNO",
							"PATNAME",
							"OTATEL",
							"DURATION",
							"NUM_SESSION",
							"OTACDATE",
							"USRNAME",
							"AMDESC",
							"DOCNAME_A",
							"DOCNAME_E",
							"SEX",
							"AGE",
							"DOB",
							"OTPCODE",
							"OT_PAA",
							"OTARMK",
							"OTADIAG",
							"PATTYPE",
							"SECSDRNAME",
							"OTAID",
							"SECPROC"
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

	/***************************************************************************
	* Layout Method
	**************************************************************************/

	/* >>> getter methods for init the Component start from here================================== <<< */
	@Override
	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.setSize(788, 525);
			leftPanel.add(getTabbedPane(), null);
			leftPanel.add(getNewApp(), null);
			leftPanel.add(getEditApp(), null);
			leftPanel.add(getCancelApp(), null);
			leftPanel.add(getConfirmApp(), null);
			leftPanel.add(getPreBooking(), null);
			leftPanel.add(getPrintPicklist(), null);
			leftPanel.add(getInActiveDoctor(), null);
		}
		return leftPanel;
	}

	protected BasePanel getRightPanel() {
		if (rightPanel == null) {
			rightPanel = new BasePanel();
//			rightPanel.setSize(800, 530);
		}
		return rightPanel;
	}

	private TabbedPaneBase getTabbedPane() {
		if (TabbedPane == null) {
			TabbedPane = new TabbedPaneBase() {
				@Override
				public void onStateChange() {
					if (!isDisableFunction("btnOTAppDisable", "otAppBrowse") && !"HKAH".equals(Factory.getInstance().getUserInfo().getUserID())) {
						String errMsg = null;
						if (getSelectedIndex() != tabIndex_GeneralView) {
							errMsg = "You cannot access other Tab.";
						}

						if (errMsg != null) {
							Factory.getInstance().addErrorMessage(errMsg);
							getMainFrame().setLoading(false);
							TabbedPane.setSelectedIndexWithoutStateChange(tabIndex_GeneralView);
							return;
						}
					} else {
						DVATableRefresh(getSelectedIndex(), false);
					}
				}
			};
			TabbedPane.setBounds(0, 1, 784, 480);

			if (getSysParameter("OTTABVIEW").isEmpty() || getSysParameter("OTTABVIEW").equals("S")) {
				TabbedPane.addTab("Daily View", getDVPanel());
			} else if (HKAH_VALUE.equals(getUserInfo().getSiteCode())) {
				TabbedPane.addTab("Daily View(OR)", getDVPanel());
				TabbedPane.addTab("Daily View(ENDO)", getDVPanel2());
				TabbedPane.addTab("Daily View(OTHERS)", getDVPanel3());
			} else {
				TabbedPane.addTab("Daily View(OR)", getDVPanel());
				TabbedPane.addTab("Daily View(ENDO)", getDVPanel2());
				TabbedPane.addTab("Daily View(OTHERS)", getDVPanel3());
				TabbedPane.addTab("Daily View(CCIC)", getDVPanel4());
			}

			TabbedPane.addTab("General View", getGVPanel());
			TabbedPane.addListener(Events.Select, new Listener<ComponentEvent>() {
				@Override
				public void handleEvent(ComponentEvent be) {
					enableButton();
				}
			});
		}
		return TabbedPane;
	}

	private BasePanel getGVPanel() {
		if (GVPanel == null) {
			GVPanel = new BasePanel();
			GVPanel.setBounds(5, 5, 790, 480);
			GVPanel.add(getCountDesc(), null);
			GVPanel.add(getCount(), null);
			GVPanel.add(getParaPanel(), null);
			GVPanel.add(getJScrollPane(), null);
		}
		return GVPanel;
	}

	private LabelBase getCountDesc() {
		if (CountDesc == null) {
			CountDesc = new LabelBase();
			CountDesc.setText("Count");
			CountDesc.setBounds(622, 419, 54, 20);
		}
		return CountDesc;
	}

	private TextReadOnly getCount() {
		if (Count == null) {
			Count = new TextReadOnly();
			Count.setBounds(678, 419, 86, 20);
		}
		return Count;
	}

	private BasePanel getParaPanel() {
		if (ParaPanel == null) {
			ParaPanel = new BasePanel();
			ParaPanel.setBorders(true);
			ParaPanel.add(getStartDateDesc(), null);
			ParaPanel.add(getStartDate(), null);
			ParaPanel.add(getEndDateDesc(), null);
			ParaPanel.add(getEndDate(), null);
			ParaPanel.add(getStatusDesc(), null);
			ParaPanel.add(getStatus(), null);
			ParaPanel.add(getPatNoDesc(), null);
			ParaPanel.add(getPatNo(), null);
			ParaPanel.add(getPatNameDesc(), null);
			ParaPanel.add(getPatName(), null);
			ParaPanel.add(getRoomDesc(), null);
			ParaPanel.add(getRoom(), null);
			ParaPanel.add(getProCodeDesc(), null);
			ParaPanel.add(getProCode(), null);
			ParaPanel.add(getSurgeonDesc(), null);
			ParaPanel.add(getSurgeon(), null);
			ParaPanel.add(getAnesthDesc(), null);
			ParaPanel.add(getAnesth(), null);
			ParaPanel.add(getEndoscopDesc(), null);
			ParaPanel.add(getEndoscop(), null);
			ParaPanel.add(getSecSurgeonDesc(), null);
			ParaPanel.add(getSecSurgeon(), null);
			ParaPanel.add(getSortByDesc(), null);
			ParaPanel.add(getSortBy(), null);
			ParaPanel.add(getJScrollPane());
			ParaPanel.setBounds(5, 5, 759, 120);
		}
		return ParaPanel;
	}

	private LabelBase getStartDateDesc() {
		if (StartDateDesc == null) {
			StartDateDesc = new LabelBase();
			StartDateDesc.setText("Start Date");
			StartDateDesc.setBounds(20, 10, 90, 20);
		}
		return StartDateDesc;
	}

	private TextDateTimeWithoutSecondWithCheckBox getStartDate() {
		if (startDate == null) {
			startDate = new TextDateTimeWithoutSecondWithCheckBox();
			startDate.setBounds(110, 10, 140, 20);
		}
		return startDate;
	}

	private LabelBase getEndDateDesc() {
		if (EndDateDesc == null) {
			EndDateDesc = new LabelBase();
			EndDateDesc.setText("End Date");
			EndDateDesc.setBounds(275, 10, 90, 20);
		}
		return EndDateDesc;
	}

	private TextDateTimeWithoutSecondWithCheckBox getEndDate() {
		if (endDate == null) {
			endDate = new TextDateTimeWithoutSecondWithCheckBox();
			endDate.setBounds(365, 10, 140, 20);
		}
		return endDate;
	}


	private LabelBase getStatusDesc() {
		if (StatusDesc == null) {
			StatusDesc = new LabelBase();
			StatusDesc.setText("Status");
			StatusDesc.setBounds(530, 10, 90, 20);
		}
		return StatusDesc;
	}

	private ComboOTStatus getStatus() {
		if (Status == null) {
			Status = new ComboOTStatus();
			Status.setBounds(610, 10, 140, 20);
		}
		return Status;
	}

	private LabelBase getPatNoDesc() {
		if (PatNoDesc == null) {
			PatNoDesc = new LabelBase();
			PatNoDesc.setText("Patient No");
			PatNoDesc.setBounds(20, 35, 90, 20);
		}
		return PatNoDesc;
	}

	private TextPatientNoSearch getPatNo() {
		if (PatNo == null) {
			PatNo = new TextPatientNoSearch(true, false) {
				@Override
				protected void showMergePatientPost() {
					getPatNo().resetText();
					getPatNo().focus();
				}
			};
			PatNo.setBounds(110, 35, 140, 20);
		}
		return PatNo;
	}

	private LabelBase getPatNameDesc() {
		if (PatNameDesc == null) {
			PatNameDesc = new LabelBase();
			PatNameDesc.setText("Patient Name");
			PatNameDesc.setBounds(275, 35, 90, 20);
		}
		return PatNameDesc;
	}

	private TextString getPatName() {
		if (PatName == null) {
			PatName = new TextString();
			PatName.setBounds(365, 35, 140, 20);
		}
		return PatName;
	}

	private LabelBase getRoomDesc() {
		if (RoomDesc == null) {
			RoomDesc = new LabelBase();
			RoomDesc.setText("Room");
			RoomDesc.setBounds(530, 35, 90, 20);
		}
		return RoomDesc;
	}

	private ComboAppRoomType getRoom() {
		if (Room == null) {
			Room = new ComboAppRoomType();
			Room.setBounds(610, 35, 140, 20);
		}
		return Room;
	}

	private LabelBase getProCodeDesc() {
		if (ProCodeDesc == null) {
			ProCodeDesc = new LabelBase();
			ProCodeDesc.setText("Procedure Code");
			ProCodeDesc.setBounds(20, 60, 90, 20);
		}
		return ProCodeDesc;
	}

	private ComboOTProc getProCode() {
		if (ProCode == null) {
			ProCode = new ComboOTProc() {
				@Override
				protected void setTextPanel(ModelData modelData) {
					getProCode().setToolTip(getDisplayText());
				}

				@Override
				public void onBlur() {
					super.onBlur();
					getProCode().setToolTip(getDisplayText());
				}
			};
			ProCode.setBounds(110, 60, 140, 20);
		}
		return ProCode;
	}

	private LabelBase getSurgeonDesc() {
		if (SurgeonDesc == null) {
			SurgeonDesc = new LabelBase();
			SurgeonDesc.setText("Surgeon");
			SurgeonDesc.setBounds(275, 60, 90, 20);
		}
		return SurgeonDesc;
	}

	private ComboDoctorSU getSurgeon() {
		if (Surgeon == null) {
			Surgeon = new ComboDoctorSU() {
				@Override
				protected void setTextPanel(ModelData modelData) {
					getSurgeon().setToolTip(getDisplayText());
				}

				@Override
				public void onBlur() {
					super.onBlur();
					getSurgeon().setToolTip(getDisplayText());
				}
			};
			Surgeon.setBounds(365, 60, 140, 20);
		}
		return Surgeon;
	}

	private LabelBase getAnesthDesc() {
		if (AnesthDesc == null) {
			AnesthDesc = new LabelBase();
			AnesthDesc.setText("Anesthetist");
			AnesthDesc.setBounds(530, 60, 90, 20);
		}
		return AnesthDesc;
	}

	private ComboDoctorAN getAnesth() {
		if (Anesth == null) {
			Anesth = new ComboDoctorAN() {
				@Override
				protected void setTextPanel(ModelData modelData) {
					getAnesth().setToolTip(getDisplayText());
				}

				@Override
				public void onBlur() {
					super.onBlur();
					getAnesth().setToolTip(getDisplayText());
				}
			};
			Anesth.setBounds(610, 60, 140, 20);
		}
		return Anesth;
	}

	private LabelBase getEndoscopDesc() {
		if (EndoscopDesc == null) {
			EndoscopDesc = new LabelBase();
			EndoscopDesc.setText("Endoscopist");
			EndoscopDesc.setBounds(20, 85, 90, 20);
		}
		return EndoscopDesc;
	}

	private ComboDoctorEN getEndoscop() {
		if (Endoscop == null) {
			Endoscop = new ComboDoctorEN() {
				@Override
				protected void setTextPanel(ModelData modelData) {
					getEndoscop().setToolTip(getDisplayText());
				}

				@Override
				public void onBlur() {
					super.onBlur();
					getEndoscop().setToolTip(getDisplayText());
				}
			};
			Endoscop.setBounds(110, 85, 140, 20);
		}
		return Endoscop;
	}

	private LabelBase getSecSurgeonDesc() {
		if (SecSurgeonDesc == null) {
			SecSurgeonDesc = new LabelBase();
			SecSurgeonDesc.setText("Sec. Surgeon");
			SecSurgeonDesc.setBounds(275, 85, 90, 20);
		}
		return SecSurgeonDesc;
	}

	private ComboDoctorSU getSecSurgeon() {
		if (SecSurgeon == null) {
			SecSurgeon = new ComboDoctorSU() {
				@Override
				protected void setTextPanel(ModelData modelData) {
					getSecSurgeon().setToolTip(getDisplayText());
				}

				@Override
				public void onBlur() {
					super.onBlur();
					getSecSurgeon().setToolTip(getDisplayText());
				}
			};
			SecSurgeon.setBounds(365, 85, 140, 20);
		}
		return SecSurgeon;
	}

	private LabelBase getSortByDesc() {
		if (SortByDesc == null) {
			SortByDesc = new LabelBase();
			SortByDesc.setText("Sort By");
			SortByDesc.setBounds(530, 85, 90, 20);
		}
		return SortByDesc;
	}

	private ComboAppSortby getSortBy() {
		if (SortBy == null) {
			SortBy = new ComboAppSortby();
			SortBy.setBounds(610, 85, 140, 20);
		}
		return SortBy;
	}

	private ButtonBase getNewApp() {
		if (NewApp == null) {
			NewApp = new ButtonBase() {
				@Override
				public void onClick() {
					Collections.sort(getCellSelectionModel().getSelections(),
							new Comparator<CellSelection>() {
						@Override
						public int compare(CellSelection o1, CellSelection o2) {
							return o1.row - o2.row;
						}
					});

					setParameter("ActionType", QueryUtil.ACTION_APPEND);
					setParameter("lotPBPID", Integer.toString(lotPBPID));

					if (getCellSelectionModel().getSelections().size() <= 0) {
						setParameter("Slt_SDate", getDVStartDate().getText() + " 00:00");
						setParameter("Slt_EDate", getDVStartDate().getText() + " 00:00");
					} else {
						String sTime = getDVATable(0).getValueAt(getCellSelectionModel().getSelections().get(0).row, 0);
						String eTime = getDVATable(0).getValueAt(
													getCellSelectionModel().getSelections().get(
															getCellSelectionModel().getSelections().size()-1).row, 0);
						final long minuteInMillis = 60L * 1000L;

						setParameter("Slt_SDate", getDVStartDate().getText() + " " + sTime);
						setParameter("Slt_EDate", getDVStartDate().getText() + " " + DateTimeUtil.formatTime(new java.util.Date(DateTimeUtil.parseTime(eTime+":00").getTime()+(14L*minuteInMillis))).substring(0, 5));
					}
						showPanel(new NewEditOTApp(){
							@Override
							protected void proExitPanel() {
								super.proExitPanel();
								newOTAppPostAction();
							}
						}
					);
				}
			};
			NewApp.setText("New App");
			NewApp.setBounds(5, 490, 105, 30);
		}
		return NewApp;
	}
	
	private void newOTAppPostAction(){
		resetParameter("lotPBPID");
		lotPBPID = 0;
		searchAction();
	}

	private ButtonBase getEditApp() {
		if (EditApp == null) {
			EditApp = new ButtonBase() {
				@Override
				public void onClick() {
					editApp();
				}
			};
			EditApp.setText("Edit App");
			EditApp.setBounds(117, 490, 105, 30);
		}
		return EditApp;
	}

	private ButtonBase getCancelApp() {
		if (CancelApp == null) {
			CancelApp = new ButtonBase() {
				@Override
				public void onClick() {
					cancelAppAlert();
				}
			};
			CancelApp.setText("Cancel App");
			CancelApp.setBounds(229, 490, 105, 30);
		}
		return CancelApp;
	}

	private ButtonBase getConfirmApp() {
		if (ConfirmApp == null) {
			ConfirmApp = new ButtonBase() {
				@Override
				public void onClick() {
					confirmApp();
				}
			};
			ConfirmApp.setText("Confirm App");
			ConfirmApp.setBounds(341, 490, 105, 30);
		}
		return ConfirmApp;
	}

	private ButtonBase getPrintPicklist() {
		if (PrintPicklist == null) {
			PrintPicklist = new ButtonBase() {
				@Override
				public void onClick() {
					printRptOtAppListing();
				}
			};
			PrintPicklist.setText("Print Picklist");
			PrintPicklist.setBounds(453, 490, 105, 30);

		}
		return PrintPicklist;
	}

	private ButtonBase getPreBooking() {
		if (PreBooking == null) {
			PreBooking = new ButtonBase() {
				@Override
				public void onClick() {
					setParameter("FROM", "OT");
					Factory.getInstance().writeLogToLocal("[Pre Booking]OT APP PRESS PREBOOK :"+getParameter("FROM"));
					showPanel(new PatientStatView());
				}
			};
			PreBooking.setText("Pre-Booking");
			PreBooking.setBounds(563, 490, 105, 30);
		}
		return PreBooking;
	}

	private ButtonBase getInActiveDoctor() {
		if (inActiveDoctor == null) {
			inActiveDoctor = new ButtonBase() {
				@Override
				public void onClick() {
					getDlgDoctorInactive().showDialog();
				}
			};
			inActiveDoctor.setText("InActiveDoctor");
			inActiveDoctor.setBounds(675, 490, 105, 30);
		}
		return inActiveDoctor;
	}

	private DlgDoctorInactive getDlgDoctorInactive() {
		if (dlgDoctorInactive == null) {
			dlgDoctorInactive = new DlgDoctorInactive(getMainFrame());
		}
		return dlgDoctorInactive;
	}

	// OT Tab
	private BasePanel getDVPanel() {
		if (DVPanel == null) {
			DVPanel = new BasePanel();
			DVPanel.setBounds(5, 5, 790, 480);
			DVPanel.add(getDVStartDateDesc(), null);
			DVPanel.add(getDVStartDate(), null);
			DVPanel.add(getNormal(), null);
			DVPanel.add(getConfirmed(), null);
			DVPanel.add(getMixed(), null);
			DVPanel.add(getDVAJScrollPane(), null);
			DVPanel.add(getDVBJScrollPane(), null);
		}
		return DVPanel;
	}

	private LabelBase getDVStartDateDesc() {
		if (DVStartDateDesc == null) {
			DVStartDateDesc = new LabelBase();
			DVStartDateDesc.setText("Start Date");
			DVStartDateDesc.setBounds(10, 10, 89, 20);
		}
		return DVStartDateDesc;
	}

	private TextDate getDVStartDate() {
		if (DVStartDate == null) {
			DVStartDate = new TextDate();
			DVStartDate.getDatePicker().addListener(Events.Select,
					new Listener<DatePickerEvent>() {
				@Override
				public void handleEvent(DatePickerEvent be) {
					if (!DVStartDate.isEmpty() && DVStartDate.isValid()) {
						onDVStartDateChange(0);
					}
					if (!DVStartDate.isEmpty() && !DVStartDate.isValid()) {
						Factory.getInstance().addErrorMessage("Invalid Date.", DVStartDate);
					}
				}
			});
			DVStartDate.addListener(Events.Blur, new Listener() {
				@Override
				public void handleEvent(BaseEvent be) {
					if (!DVStartDate.isEmpty() && DVStartDate.isValid()) {
						onDVStartDateChange(0);
					}
					if (!DVStartDate.isEmpty() && !DVStartDate.isValid()) {
						Factory.getInstance().addErrorMessage("Invalid Date.", DVStartDate);
					}
				}
			});
			DVStartDate.setBounds(100, 10, 113, 20);
		}
		return DVStartDate;
	}

	private LabelBase getNormal() {
		if (Normal == null) {
			Normal = new LabelBase();
			//Normal.setHorizontalAlignment(TextString.CENTER);
			Normal.setBounds(409, 10, 113, 20);
			Normal.setText("Normal");
			Normal.addStyleName("otappbse-dv-normal");
			Normal.setBorders(true);
		}
		return Normal;
	}

	private LabelBase getConfirmed() {
		if (Confirmed == null) {
			Confirmed = new LabelBase();
			//Confirmed.setHorizontalAlignment(TextString.CENTER);
			Confirmed.setBounds(533, 10, 113, 20);
			Confirmed.setText("Confirmed");
			Confirmed.addStyleName("otappbse-dv-confirmed");
			Confirmed.setBorders(true);
		}
		return Confirmed;
	}

	private LabelBase getMixed() {
		if (Mixed == null) {
			Mixed = new LabelBase();
			//Mixed.setHorizontalAlignment(TextString.CENTER);
			Mixed.setBounds(655, 10, 113, 20);
			Mixed.setText("Mix");
			Mixed.addStyleName("otappbse-dv-mixed");
			Mixed.setBorders(true);
		}
		return Mixed;
	}

	private JScrollPane getDVAJScrollPane() {
		if (DVAJScrollPane == null) {
			DVAJScrollPane = new JScrollPane();
			// dynamically set list table
			DVAJScrollPane.setBounds(10, 40, 759, 240);
			DVAJScrollPane.setLayout(new FitLayout());
		}
		return DVAJScrollPane;
	}

	// ENDO Tab
	private BasePanel getDVPanel2() {
		if (DVPanel2 == null) {
			DVPanel2 = new BasePanel();
			DVPanel2.setLocation(5, 5);
			DVPanel2.setSize(790,480);
			DVPanel2.add(getDVStartDateDesc2(), null);
			DVPanel2.add(getDVStartDate2(), null);
			DVPanel2.add(getNormal2(), null);
			DVPanel2.add(getConfirmed2(), null);
			DVPanel2.add(getMixed2(), null);
			DVPanel2.add(getDVAJScrollPane2(), null);
			DVPanel2.add(getDVBJScrollPane2(), null);
		}
		return DVPanel2;
	}

	private LabelBase getDVStartDateDesc2() {
		if (DVStartDateDesc2 == null) {
			DVStartDateDesc2 = new LabelBase();
			DVStartDateDesc2.setText("Start Date");
			DVStartDateDesc2.setBounds(10, 10, 89, 20);
		}
		return DVStartDateDesc2;
	}

	private TextDate getDVStartDate2() {
		if (DVStartDate2 == null) {
			DVStartDate2 = new TextDate();
			DVStartDate2.getDatePicker().addListener(Events.Select,
					new Listener<DatePickerEvent>() {
				@Override
				public void handleEvent(DatePickerEvent be) {
					if (!DVStartDate2.isEmpty() && DVStartDate2.isValid()) {
						onDVStartDateChange(1);
					}
					if (!DVStartDate2.isEmpty() && !DVStartDate2.isValid()) {
						Factory.getInstance().addErrorMessage("Invalid Date.", DVStartDate2);
					}
				}
			});
			DVStartDate2.addListener(Events.Blur, new Listener() {
				@Override
				public void handleEvent(BaseEvent be) {
					if (!DVStartDate2.isEmpty() && DVStartDate2.isValid()) {
						onDVStartDateChange(1);
					}
					if (!DVStartDate2.isEmpty() && !DVStartDate2.isValid()) {
						Factory.getInstance().addErrorMessage("Invalid Date.", DVStartDate2);
					}
				}
			});
			DVStartDate2.setBounds(100, 10, 113, 20);
		}
		return DVStartDate2;
	}

	private LabelBase getNormal2() {
		if (Normal2 == null) {
			Normal2 = new LabelBase();
			//Normal.setHorizontalAlignment(TextString.CENTER);
			Normal2.setBounds(409, 10, 113, 20);
			Normal2.setText("Normal");
			Normal2.addStyleName("otappbse-dv-normal");
			Normal2.setBorders(true);
		}
		return Normal2;
	}

	private LabelBase getConfirmed2() {
		if (Confirmed2 == null) {
			Confirmed2 = new LabelBase();
			//Confirmed.setHorizontalAlignment(TextString.CENTER);
			Confirmed2.setBounds(533, 10, 113, 20);
			Confirmed2.setText("Confirmed");
			Confirmed2.addStyleName("otappbse-dv-confirmed");
			Confirmed2.setBorders(true);
		}
		return Confirmed2;
	}

	private LabelBase getMixed2() {
		if (Mixed2 == null) {
			Mixed2 = new LabelBase();
			//Mixed.setHorizontalAlignment(TextString.CENTER);
			Mixed2.setBounds(655, 10, 113, 20);
			Mixed2.setText("Mix");
			Mixed2.addStyleName("otappbse-dv-mixed");
			Mixed2.setBorders(true);
		}
		return Mixed2;
	}

	private JScrollPane getDVAJScrollPane2() {
		if (DVAJScrollPane2 == null) {
			DVAJScrollPane2 = new JScrollPane();
			// dynamically set list table
			DVAJScrollPane2.setBounds(10, 40, 759, 240);
			DVAJScrollPane2.setLayout(new FitLayout());
		}
		return DVAJScrollPane2;
	}

	// Others Tab
	private BasePanel getDVPanel3() {
		if (DVPanel3 == null) {
			DVPanel3 = new BasePanel();
			DVPanel3.setLocation(5, 5);
			DVPanel3.setSize(790,480);
			DVPanel3.add(getDVStartDateDesc3(), null);
			DVPanel3.add(getDVStartDate3(), null);
			DVPanel3.add(getNormal3(), null);
			DVPanel3.add(getConfirmed3(), null);
			DVPanel3.add(getMixed3(), null);
			DVPanel3.add(getDVAJScrollPane3(), null);
			DVPanel3.add(getDVBJScrollPane3(), null);
		}
		return DVPanel3;
	}

	private LabelBase getDVStartDateDesc3() {
		if (DVStartDateDesc3 == null) {
			DVStartDateDesc3 = new LabelBase();
			DVStartDateDesc3.setText("Start Date");
			DVStartDateDesc3.setBounds(10, 10, 89, 20);
		}
		return DVStartDateDesc3;
	}

	private TextDate getDVStartDate3() {
		if (DVStartDate3 == null) {
			DVStartDate3 = new TextDate();
			DVStartDate3.getDatePicker().addListener(Events.Select,
					new Listener<DatePickerEvent>() {
				@Override
				public void handleEvent(DatePickerEvent be) {
					if (!DVStartDate3.isEmpty() && DVStartDate3.isValid()) {
						onDVStartDateChange(2);
					}
					if (!DVStartDate3.isEmpty() && !DVStartDate3.isValid()) {
						Factory.getInstance().addErrorMessage("Invalid Date.", DVStartDate3);
					}
				}
			});
			DVStartDate3.addListener(Events.Blur, new Listener() {
				@Override
				public void handleEvent(BaseEvent be) {
					if (!DVStartDate3.isEmpty() && DVStartDate3.isValid()) {
						onDVStartDateChange(2);
					}
					if (!DVStartDate3.isEmpty() && !DVStartDate3.isValid()) {
						Factory.getInstance().addErrorMessage("Invalid Date.", DVStartDate3);
					}
				}
			});
			DVStartDate3.setBounds(100, 10, 113, 20);
		}
		return DVStartDate3;
	}

	private LabelBase getNormal3() {
		if (Normal3 == null) {
			Normal3 = new LabelBase();
			//Normal.setHorizontalAlignment(TextString.CENTER);
			Normal3.setBounds(409, 10, 113, 20);
			Normal3.setText("Normal");
			Normal3.addStyleName("otappbse-dv-normal");
			Normal3.setBorders(true);
		}
		return Normal3;
	}

	private LabelBase getConfirmed3() {
		if (Confirmed3 == null) {
			Confirmed3 = new LabelBase();
			//Confirmed.setHorizontalAlignment(TextString.CENTER);
			Confirmed3.setBounds(533, 10, 113, 20);
			Confirmed3.setText("Confirmed");
			Confirmed3.addStyleName("otappbse-dv-confirmed");
			Confirmed3.setBorders(true);
		}
		return Confirmed3;
	}

	private LabelBase getMixed3() {
		if (Mixed3 == null) {
			Mixed3 = new LabelBase();
			//Mixed.setHorizontalAlignment(TextString.CENTER);
			Mixed3.setBounds(655, 10, 113, 20);
			Mixed3.setText("Mix");
			Mixed3.addStyleName("otappbse-dv-mixed");
			Mixed3.setBorders(true);
		}
		return Mixed3;
	}

	private JScrollPane getDVAJScrollPane3() {
		if (DVAJScrollPane3 == null) {
			DVAJScrollPane3 = new JScrollPane();
			// dynamically set list table
			DVAJScrollPane3.setBounds(10, 40, 759, 240);
			DVAJScrollPane3.setLayout(new FitLayout());
		}
		return DVAJScrollPane3;
	}
	
	// CCIC Tab
	private BasePanel getDVPanel4() {
		if (DVPanel4 == null) {
			DVPanel4 = new BasePanel();
			DVPanel4.setLocation(5, 5);
			DVPanel4.setSize(790,480);
			DVPanel4.add(getDVStartDateDesc4(), null);
			DVPanel4.add(getDVStartDate4(), null);
			DVPanel4.add(getNormal4(), null);
			DVPanel4.add(getConfirmed4(), null);
			DVPanel4.add(getMixed4(), null);
			DVPanel4.add(getDVAJScrollPane4(), null);
			DVPanel4.add(getDVBJScrollPane4(), null);
		}
		return DVPanel4;
	}
	
	private LabelBase getDVStartDateDesc4() {
		if (DVStartDateDesc4 == null) {
			DVStartDateDesc4 = new LabelBase();
			DVStartDateDesc4.setText("Start Date");
			DVStartDateDesc4.setBounds(10, 10, 89, 20);
		}
		return DVStartDateDesc4;
	}

	private TextDate getDVStartDate4() {
		if (DVStartDate4 == null) {
			DVStartDate4 = new TextDate();
			DVStartDate4.getDatePicker().addListener(Events.Select,
					new Listener<DatePickerEvent>() {
				@Override
				public void handleEvent(DatePickerEvent be) {
					if (!DVStartDate4.isEmpty() && DVStartDate4.isValid()) {
						onDVStartDateChange(3);
					}
					if (!DVStartDate4.isEmpty() && !DVStartDate4.isValid()) {
						Factory.getInstance().addErrorMessage("Invalid Date.", DVStartDate4);
					}
				}
			});
			DVStartDate4.addListener(Events.Blur, new Listener() {
				@Override
				public void handleEvent(BaseEvent be) {
					if (!DVStartDate4.isEmpty() && DVStartDate4.isValid()) {
						onDVStartDateChange(3);
					}
					if (!DVStartDate4.isEmpty() && !DVStartDate4.isValid()) {
						Factory.getInstance().addErrorMessage("Invalid Date.", DVStartDate4);
					}
				}
			});
			DVStartDate4.setBounds(100, 10, 113, 20);
		}
		return DVStartDate4;
	}

	private LabelBase getNormal4() {
		if (Normal4 == null) {
			Normal4 = new LabelBase();
			//Normal.setHorizontalAlignment(TextString.CENTER);
			Normal4.setBounds(409, 10, 113, 20);
			Normal4.setText("Normal");
			Normal4.addStyleName("otappbse-dv-normal");
			Normal4.setBorders(true);
		}
		return Normal4;
	}

	private LabelBase getConfirmed4() {
		if (Confirmed4 == null) {
			Confirmed4 = new LabelBase();
			//Confirmed.setHorizontalAlignment(TextString.CENTER);
			Confirmed4.setBounds(533, 10, 113, 20);
			Confirmed4.setText("Confirmed");
			Confirmed4.addStyleName("otappbse-dv-confirmed");
			Confirmed4.setBorders(true);
		}
		return Confirmed4;
	}

	private LabelBase getMixed4() {
		if (Mixed4 == null) {
			Mixed4 = new LabelBase();
			//Mixed.setHorizontalAlignment(TextString.CENTER);
			Mixed4.setBounds(655, 10, 113, 20);
			Mixed4.setText("Mix");
			Mixed4.addStyleName("otappbse-dv-mixed");
			Mixed4.setBorders(true);
		}
		return Mixed4;
	}

	private JScrollPane getDVAJScrollPane4() {
		if (DVAJScrollPane4 == null) {
			DVAJScrollPane4 = new JScrollPane();
			// dynamically set list table
			DVAJScrollPane4.setBounds(10, 40, 759, 240);
			DVAJScrollPane4.setLayout(new FitLayout());
		}
		return DVAJScrollPane4;
	}

	private TableList getDVATable(final int tabNo) {
		if (DVATable[tabNo] == null) {
			DVATable[tabNo] = new TableList(getDVATableColumnNames(tabNo), getDVATableColumnWidths(tabNo), getDVATableColumnCellRenderers(tabNo));
			DVATable[tabNo].setTableLength(DVATableWidth);
			DVATable[tabNo].setBorders(true);
			DVATable[tabNo].setColumnLines(true);
			DVATable[tabNo].setStripeRows(false);
			DVATable[tabNo].setView(new GridView());
			DVATable[tabNo].setSelectionModel(getCellSelectionModel());
			DVATable[tabNo].getStore().add(getBlankDVATableData(tabNo));
			DVATable[tabNo].addListener(Events.CellClick, new Listener<GridEvent<TableData>>() {
				@Override
				public void handleEvent(GridEvent<TableData> be) {
					if (be.getGrid().isViewReady()) {
						int col= be.getColIndex();
						int row = be.getRowIndex();

						if (col == 0) {
							be.cancelBubble();
							be.setCancelled(true);
						} else {
							setGrdAppBseViewRefresh(tabNo, row, col);
						}
					}
				}
			});
		}
		return DVATable[tabNo];
	}

	// OT Tab
	private JScrollPane getDVBJScrollPane() {
		if (DVBJScrollPane == null) {
			DVBJScrollPane = new JScrollPane();
			DVBJScrollPane.setViewportView(getDVBTable(0));
			DVBJScrollPane.setBounds(10, 290, 759, 150);
		}
		return DVBJScrollPane;
	}

	private TableList getDVBTable(int tabNo) {
		if (DVBTable[tabNo] == null) {
			DVBTable[tabNo] = new TableList(getDVBTableColumnNames(),
										getDVBTableColumnWidths(),
										getDVBTableColumnRenderer()) {
				@Override
				public void setListTableContentPost() {
					enableButton();
				}

				@Override
				public void onSelectionChanged() {
					controlAppButtons();
				}
			};
			DVBTable[tabNo].setTableLength(getListWidth());
		}
		return DVBTable[tabNo];
	}

	private String[] getDVBTableColumnNames() {
		return new String[] {
					"Allergy",
					"",
					"App. Date/Time",
					"End Date/Time",
					" ",
					"Patient No",
					"",
					"",
					"Name",
					"Tel",
					"Age",
					"Procedure",
					"Anes. Meth",
					"",
					"Surgeon",
					"Anesthetist",
					"Endoscopist",
					"Status",
					"Remark",
					"Status-code",
					""
				};
	}

	private int[] getDVBTableColumnWidths() {
		return new int[] {
							20, 0, 100, 100, 50,
							80, 0, 0, 120, 80,
							50, 200, 120, 0, 120,
							120, 120, 60, 120, 0, 0
						};
	}

	private GeneralGridCellRenderer[] getDVBTableColumnRenderer() {
		return new GeneralGridCellRenderer[] {
				new OTAppBseGenAlgyRenderer(),
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null
		};
	}

	// ENDO Tab

	private JScrollPane getDVBJScrollPane2() {
		if (DVBJScrollPane2 == null) {
			DVBJScrollPane2 = new JScrollPane();
			DVBJScrollPane2.setViewportView(getDVBTable(1));
			DVBJScrollPane2.setBounds(10, 290, 759, 150);
		}
		return DVBJScrollPane2;
	}

	// Others Tab

	private JScrollPane getDVBJScrollPane3() {
		if (DVBJScrollPane3 == null) {
			DVBJScrollPane3 = new JScrollPane();
			DVBJScrollPane3.setViewportView(getDVBTable(2));
			DVBJScrollPane3.setBounds(10, 290, 759, 150);
		}
		return DVBJScrollPane3;
	}
	
	private JScrollPane getDVBJScrollPane4() {
		if (DVBJScrollPane4 == null) {
			DVBJScrollPane4 = new JScrollPane();
			DVBJScrollPane4.setViewportView(getDVBTable(3));
			DVBJScrollPane4.setBounds(10, 290, 759, 150);
		}
		return DVBJScrollPane4;
	}

	private Menu getPopupMenu() {
		if (contextMenu == null) {
			contextMenu = new Menu();

			// set context menu
			contextMenu.setWidth(140);
			contextMenu.add(getEditAppMenu());
			contextMenu.add(getCancelAppMenu());
			contextMenu.add(getConfirmAppMenu());
		}
		return contextMenu;
	}

	private MenuItemBase getEditAppMenu() {
		if (editAppMenu == null) {
			editAppMenu = new MenuItemBase();
			editAppMenu.setText("Edit App");
			editAppMenu.setIcon(Resources.ICONS.edit());
			editAppMenu.addSelectionListener(new SelectionListener<MenuEvent>() {
				public void componentSelected(MenuEvent ce) {
					editApp();
				}
			});
		}
		return editAppMenu;
	}

	private MenuItemBase getCancelAppMenu() {
		if (cancelAppMenu == null) {
			cancelAppMenu = new MenuItemBase();
			cancelAppMenu.setText("Cancel App");
			cancelAppMenu.setIcon(Resources.ICONS.delete());
			cancelAppMenu.addSelectionListener(new SelectionListener<MenuEvent>() {
				public void componentSelected(MenuEvent ce) {
					cancelAppAlert();
				}
			});
		}
		return cancelAppMenu;
	}

	private MenuItemBase getConfirmAppMenu() {
		if (confirmAppMenu == null) {
			confirmAppMenu = new MenuItemBase();
			confirmAppMenu.setText("Confirm App");
			confirmAppMenu.setIcon(Resources.ICONS.save());
			confirmAppMenu.addSelectionListener(new SelectionListener<MenuEvent>() {
				public void componentSelected(MenuEvent ce) {
					confirmApp();
				}
			});
		}
		return confirmAppMenu;
	}
}