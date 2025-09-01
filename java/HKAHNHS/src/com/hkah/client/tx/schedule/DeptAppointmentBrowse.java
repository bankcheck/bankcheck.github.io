package com.hkah.client.tx.schedule;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
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
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.store.ListStore;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.grid.CellSelectionModel.CellSelection;
import com.extjs.gxt.ui.client.widget.grid.ColumnData;
import com.extjs.gxt.ui.client.widget.grid.Grid;
import com.extjs.gxt.ui.client.widget.grid.GridView;
import com.extjs.gxt.ui.client.widget.layout.FitLayout;
import com.google.gwt.dom.client.Element;
import com.google.gwt.user.datepicker.client.CalendarUtil;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboDeptAppRoomType;
import com.hkah.client.layout.combobox.ComboDeptAppSortBy;
import com.hkah.client.layout.combobox.ComboDeptProc;
import com.hkah.client.layout.combobox.ComboDeptStatus;
import com.hkah.client.layout.dialog.DialogBase;
import com.hkah.client.layout.dialog.DlgBlock;
import com.hkah.client.layout.dialog.DlgBlockDeptApp;
import com.hkah.client.layout.dialog.DlgDeptAppCancelReasonSel;
import com.hkah.client.layout.dialog.DlgDeptSecCheck;
import com.hkah.client.layout.dialog.DlgSlipList;
import com.hkah.client.layout.dialog.DlgSlipListWithNewSlip;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.panel.TabbedPaneBase;
import com.hkah.client.layout.table.GeneralGridCellRenderer;
import com.hkah.client.layout.table.MultiCellSelectionModel;
import com.hkah.client.layout.table.TableData;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextAreaBase;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextDateTimeWithoutSecond;
import com.hkah.client.layout.textfield.TextDateTimeWithoutSecondWithCheckBox;
import com.hkah.client.layout.textfield.TextDoctorSearch;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.tx.ot.OTAppBseGenAlgyRenderer;
import com.hkah.client.tx.registration.Patient;
import com.hkah.client.tx.transaction.TransactionDetail;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DeptAppointmentBrowse extends MasterPanel{

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;
	private static final int DVATableWidth = 969;

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.DEPTAPPOINTMENTBROWSE_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.DEPTAPPOINTMENTBROWSE_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Deptaid",
				"Allergy",
				"Patient Type",
				"Start Date/Time",
				"Bed",
				"Patient No",
				"Patient Name",
				"Procedure",
				"Referring Doctor",
				"Reporting Doctor",
				"Proc.Remark",
				"Sex",
				"Age",
				"End Date/Time",												
				"Room",				
				"",				//MERGED				
				"DEPTAFNAME",
				"DEPTAGNAME",				
				"Status",
				"User",
				"Status-code",

		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				0,  //deptaid
				0, //allergy
				100, //pattype
				120,//sdate
				40,  //bed
				80, //patno
				120, //patname
				100, //procedure
				120, //refdoctorname
				120, //repdoctorname
				100, //procedureRmk
				40, //sex
				40,  //age
				120, //edate
				90,	//Room				
				0,  //merged				
				0,  //deptfname
				0,  //deptgname												
				60, //status
				100, //user
				0,  //statuscode
				

		};
	}

	/* >>> ~4b~ Set Table Column Cell Renderer ============================ <<< */
	protected GeneralGridCellRenderer[] getColumnRenderer() {
		return new GeneralGridCellRenderer[] {
				null,                            //deptaid         
				null,						   //allergy         
				null,                             //pattype        
				null,                            //sdate           
				null,                             //bed           
				null,                            //patno           
				null,                             //patname       
				null,                             //procedure      
				null,                             //doctorname
				null,                             //doctorname
				null,                             //procedureRmk  				     
				null,                            //sex             
				null,                             //age            
				null,                             //edate          
				null,                            //Room				  
				null,                            //merged			 
				null,                            //deptfname       
				null,                            //deptgname			
				null, 							 //status         
				null,                             //user          
				null,                            //statuscode      

		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private BasePanel leftPanel = null;

	public String memAlertMailPath = null;
	public final static String DEPT_APPSTS_N = "N";
	public final static String DEPT_APPSTS_C = "C";
	public final static String DEPT_APPSTS_F = "F";
	public final static String DEPT_APPSTS_B = "B";
	private final static String  memGridColorBack = "#FFFFFF";		//&H00FFFFFF&
	private final static String  memGridColorConfirm = "#00C000";	//&H0000C000&
	private final static String  memGridColorNormal = "#C00000";		//&H000000C0&
	private final static String  memGridColorMixed = "#808000";		//&H00008080&
	private final static String  memGridColorBackNormal = "#000000";	//&H00000000&
	private final static String DEFAULT_HOURS = "00:00";
	private final static String DEFAULT_HOURS_FORMAT = "dd/mm/yyyy";

	private String[] tabType = new String[] { "DAILY", "SLEEP", null };
	private int TabbedPaneIndex = 0;
	private int tabIndex_GeneralView = 2;
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
	private ComboDeptStatus Status = null;
	private LabelBase PatNoDesc = null;
	private TextPatientNoSearch PatNo = null;
	private LabelBase PatNameDesc = null;
	private TextString PatName = null;
	private LabelBase RoomDesc = null;
	private ComboDeptAppRoomType Room = null;
	private LabelBase ProCodeDesc = null;
	private ComboDeptProc ProCode = null;
	private LabelBase DocCodeDesc = null;
	private TextDoctorSearch DocCode = null;	
	private LabelBase SortByDesc = null;
	private ComboDeptAppSortBy SortBy = null;

	private BasePanel DVPanel = null;
	private LabelBase DVStartDateDesc = null;
	private TextDate DVStartDate = null;
	
	private LabelBase selectedTimeDesc = null;
	private TextReadOnly selectedTime = null;
	
	private LabelBase showMoreTimeDesc = null;
	private CheckBoxBase showMoreTime = null;
	private ButtonBase NextDate = null;
	private ButtonBase PrevDate = null;
	
	private TableList[] DVATable = new TableList[3];
	private JScrollPane DVAJScrollPane = null;
	private TableList[] DVBTable = new TableList[3];
	private JScrollPane DVBJScrollPane = null;
	
	private BasePanel DVPanel2 = null;
	private LabelBase DVStartDateDesc2 = null;
	private TextDate DVStartDate2 = null;
	private JScrollPane DVAJScrollPane2 = null;
	private JScrollPane DVBJScrollPane2 = null;
	
	private LabelBase selectedTime2Desc = null;
	private TextReadOnly selectedTime2 = null;
	private int prevSelectedRow =  0;
	private int prevSelectedColumn = 0;
	
	private LabelBase showMoreTime2Desc = null;
	private CheckBoxBase showMoreTime2 = null;
	private ButtonBase NextDate2 = null;
	private ButtonBase PrevDate2 = null;

	private ButtonBase NewApp = null;
	private ButtonBase EditApp = null;
	private ButtonBase CancelApp = null;
	private ButtonBase RestoreApp = null;

	private ButtonBase ConfirmApp = null;
	private ButtonBase SlipBtn = null;
	private ButtonBase PatientReg = null;
	private DlgSlipListWithNewSlip DlgSlipList = null;
	private ButtonBase BlockBtn = null;
	private DlgBlockDeptApp blockDialog = null;
	
	private ButtonBase remarkAction = null;
	private DialogBase remarkDialog = null;
	private FieldSetBase remarkTopPanel = null;
	private TextAreaBase remark_update = null;
	
	private ButtonBase nurseNotes = null;

	private Map<String, Integer> roomId2Col = new HashMap<String, Integer>();
	private Map<Integer, String> col2Room = new HashMap<Integer, String>();
	private Map<String, Integer> roomId2Col2 = new HashMap<String, Integer>();
	private Map<Integer, String> col2Room2 = new HashMap<Integer, String>();
	private String memCurrDT = null;
	private String memDeptType = null;
	private String[] firstLoadDate = new String[] { null, null, null };
	private int memCurrSelectedCellColID = 0;
	private int memCurrSelectedCellRowNo = 0;

	private Map<String, List<String>> RowColID_Col = new LinkedHashMap<String, List<String>>();
	private Map<String, List<String>> RowColID_Col2 = new LinkedHashMap<String, List<String>>();
	private String[] bkgColorTemplate = new String[] {
			"ot-cell-bkgcolor1", "ot-cell-bkgcolor2", "ot-cell-bkgcolor3",
			"ot-cell-bkgcolor4", "ot-cell-bkgcolor5", "ot-cell-bkgcolor6",
			"ot-cell-bkgcolor7", "ot-cell-bkgcolor8", "ot-cell-bkgcolor9",
			"ot-cell-bkgcolor3confirmed", "ot-cell-bkgcolor2confirmed",
			"ot-cell-bkgcolorBlock"
	};
	private int bkgColorTemplateUsed = 0;
	private String[][] DVATableColumnNames = new String[3][];    // dynamic
	private int[][] DVATableColumnWidths = new int[3][];  // dynamic
	private GeneralGridCellRenderer[][] DVATableColumnCellRenderers = new GeneralGridCellRenderer[3][];   // dynamic
	private MultiCellSelectionModel<TableData> cellSelectionModel = null;
	
	private final int DailyCol_Allergy = 0;
	private final int DailyCol_APPAID = 1;
	private final int DailyCol_PATTYPE = 2;
	private final int DailyCol_APPSDATE = 3;
	private final int DailyCol_BED = 4;
	private final int DailyCol_APPEDATE = 5;
	private final int DailyCol_DOCTOR = 6;
	private final int DailyCol_REPORTDOC = 7;
	
	private final int DailyCol_PATNO = 9;
	private final int DailyCol_PATFNAME = 10;
	private final int DailyCol_PATGNAME = 11;
	private final int DailyCol_PATNAME = 12;
	
	private final int DailyCol_AGE = 13;
	private final int DailyCol_PROCEDURE = 14;
	
	private final int DailyCol_STATUSCODE = 15;
	private final int DailyCol_ROOM = 16;
	private final int DailyCol_RMK = 17;
	private final int DailyCol_TEL = 18;
	private final int DailyCol_USRID = 19;
	private final int DailyCol_DEPTACDATE = 20;
	private final int DailyCol_MODUSER = 21;
	private final int DailyCol_MODDATE = 22;
	private final int DailyCol_STATUS = 23;
	
	private final int GenCol_Deptaid = 0;
	private final int GenCol_Allergy = 1;
	private final int GenCol_patTypeDetail = 2;
	private final int GenCol_SDate = 3;	
	private final int GenCol_Bed = 4;
	private final int GenCol_patNo = 5;
	private final int GenCol_patName = 6;	
	private final int GenCol_Procedure = 7;
	private final int GenCol_RefDoctor = 8;
	private final int GenCol_RepDoctor = 9;
	private final int GenCol_ProcRemark = 10;
	private final int GenCol_Sex = 11;
	private final int GenCol_Age = 12;
	private final int GenCol_EDate = 13;	
	private final int GenCol_Room = 14;	
	private final int GenCol_Merged = 15;	
	private final int GenCol_deptAFName = 16;
	private final int GenCol_deptAGName = 17;		
	private final int GenCol_Status = 18;	
	private final int GenCol_User = 19;
	private final int GenCol_StatusCode = 20;
	

	private String isPHorSat = null; 
	private boolean isShowMoreTime = false;
	private boolean isShowMoreTime2 = false;

	
	private String selectedRoom = null;

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;

	/**
	 * This method initializes
	 *
	 */
	public DeptAppointmentBrowse() {
		super();
	}
	
	public DeptAppointmentBrowse(String deptCode) {
		super();
		memDeptType = deptCode;
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		setLeftAlignPanel();
		getJScrollPane().setBounds(5, 105, 759, 305);
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		firstLoadDate[0] = null;
		firstLoadDate[1] = null;
		firstLoadDate[2] = null;

		memCurrDT = getMainFrame().getServerDate();
		QueryUtil.executeMasterFetch(getUserInfo(), "CHECKDEPTAPPPHORSAT",
				new String[] {memCurrDT},
				new MessageQueueCallBack() {
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					if(!"".equals(mQueue.getContentField()[0]) && mQueue.getContentField()[0] != null) {
						isPHorSat = mQueue.getContentField()[0];
					} else {
						isPHorSat = null;
					}
				}
			}});
		initDateField();
		tabIndex_GeneralView = 2;
		initDVATableColumns(0);
		initDVATableColumns(1);
		getTabbedPane().setSelectedIndex(2);
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
				memDeptType, 
				getStartDate().getText(),
				getEndDate().getText(),
				getStatus().getText(),
				getPatNo().getText(),
				getPatName().getText(),
				getRoom().getText(),
				getProCode().getText(),
				getDocCode().getText(),
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
				selectedContent[GenCol_Deptaid]
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
		
	}

	@Override
	protected void enableButton() {
		disableButton();

		int tabIndex = getTabbedPane().getSelectedIndex();
		if (tabIndex == tabIndex_GeneralView) {
			getSearchButton().setEnabled(true);
			getRefreshButton().setEnabled(false);
			getPrintButton().setEnabled(true);
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
	
	@Override
	public void printAction() {
		Map<String,String> map = new HashMap<String,String>();
		map.put("SiteName", getUserInfo().getSiteName());
		map.put("startDate", getStartDate().getText());
		map.put("endDate", getEndDate().getText());

		PrintingUtil.print("DeptAppListing",
				map,"",
				new String[] {
					memDeptType,
					getStartDate().getText(),
					getEndDate().getText(),
					getStatus().getText(),
					getRoom().getText(),
					getProCode().getText(),
					getDocCode().getText()
				},
				new String[] {
					"DEPTAID",  "PATTYPE","ATIME",
					"PATNO", "PATNAME", "PDESC",
					"DOCCODE","DOCNAME","SEXAGE",
					"DEPTPRMK","BKGSDATE","BKGEDATE",
					"ROOM","STATUS","BKGCDATE"
				});

		defaultFocus();
	}

	/***************************************************************************
	* Helper Method
	**************************************************************************/
	
	private DeptAppointmentBrowse getThis() {
		return this;
	}

	private void initDateField() {
		getStartDate().setText(memCurrDT + " 00:00");
		getEndDate().setText(memCurrDT + " 23:59");
		getDVStartDate().setText(memCurrDT);
		getDVStartDate2().setText(memCurrDT);
	}
	
	private void resetVariable(){
		getSelectedTime().setText("");
/*		getShowMoreTime().setSelected(false);
		getShowMoreTime2().setSelected(false);
		isShowMoreTime = false;
		isShowMoreTime2 = false;*/
		setSelectedRoom("");
	}

	private void setTotalCount() {
		getCount().setText(String.valueOf(getListTable().getRowCount()));
	}

	private void controlAppButtons() {
		boolean isAppEditable = false;
		String deptasts = null;
		String patno = null;
		int tabIndex = getTabbedPane().getSelectedIndex();
		if (tabIndex == tabIndex_GeneralView) {
			if (getListTable() != null && getListTable().getSelectedRow() >= 0) {
				deptasts = getListTable().getSelectedRowContent()[GenCol_StatusCode];
				patno = getListTable().getSelectedRowContent()[GenCol_patNo];

			}
		} else if (tabIndex >= 0) {
			if (getDVBTable(tabIndex) != null && getDVBTable(tabIndex).getSelectedRow() >= 0) {
				deptasts = getDVBTable(tabIndex).getSelectedRowContent()[DailyCol_STATUSCODE];
				patno = getDVBTable(getTabbedPane().getSelectedIndex()).getSelectedRowContent()[DailyCol_PATNO];
			}
		}
		
		disableAllAppButtons();

		if (DEPT_APPSTS_N.equals(deptasts)) {
			isAppEditable = true;
		}

		if (isAppEditable) {
			if ("".equals(patno) || patno == null){
				getNewApp().setEnabled(true);
				getEditApp().setEnabled(true);
				getCancelApp().setEnabled(true);
				getConfirmApp().setEnabled(true);
				getPatientReg().setEnabled(true);
				getRemarkAction().setEnabled(true);
			} else {
				getNewApp().setEnabled(true);
				getEditApp().setEnabled(true);
				getCancelApp().setEnabled(true);
				getConfirmApp().setEnabled(true);
				getSlipBtn().setEnabled(true);
				getPatientReg().setEnabled(true);
				getRemarkAction().setEnabled(true);
			}
		} 
		
		if (DEPT_APPSTS_C.equals(deptasts)) {
			getNewApp().setEnabled(true);
			getRestoreApp().setEnabled(true);
			getRemarkAction().setEnabled(true);
		}
		
		if (DEPT_APPSTS_F.equals(deptasts)) {
			getCancelApp().setEnabled(true);
			getNewApp().setEnabled(true);
			getSlipBtn().setEnabled(true);
			getPatientReg().setEnabled(true);
			getRemarkAction().setEnabled(true);
			getNurseNotes().setEnabled(true);
		}
			
		if (DEPT_APPSTS_B.equals(deptasts)) {
			getCancelApp().setEnabled(true);
			getRemarkAction().setEnabled(true);
		}
		
		if("".equals(deptasts) || deptasts == null) {
			getNewApp().setEnabled(true);
			getBlockBtn().setEnabled(true);
			getPatientReg().setEnabled(true);
			getRemarkAction().setEnabled(true);
		}
		if (!isDisableFunction("btnDeptAppDisable", "reg") && 
				!Factory.getInstance().getUserInfo().getSiteCode().equals(Factory.getInstance().getUserInfo().getUserID())) {
			disableAllAppButtons();
		}
	}
	
	private void disableAllAppButtons() {
		getNewApp().setEnabled(false);
		getEditApp().setEnabled(false);
		getCancelApp().setEnabled(false);
		getConfirmApp().setEnabled(false);
		getRestoreApp().setEnabled(false);
		getSlipBtn().setEnabled(false);
		getPatientReg().setEnabled(false);
		getBlockBtn().setEnabled(false);
		getRemarkAction().setEnabled(false);
		getNurseNotes().setEnabled(false);
	}
	
	

	private String getSelectedDeptaid() {
		String deptaid = null;

		int tabIndex = getTabbedPane().getSelectedIndex();
		if (tabIndex == tabIndex_GeneralView) {
			deptaid = getListTable().getSelectedRowContent()[GenCol_Deptaid];
		} else if (tabIndex >= 0) {
			deptaid = getDVBTable(tabIndex).getSelectedRowContent()[DailyCol_APPAID];
		}

		return deptaid;
	}

	private Map<String, List<String>> getRowColID_Col(int tabNo) {
		if (tabNo == 1) {
			return RowColID_Col2;
		} else {
			return RowColID_Col;
		}
	}
	
	private String getCol2Room(int tabNo, int colID) {
		if (tabNo == 1) {
			return col2Room2.get(colID);
		} else {
			return col2Room.get(colID);
		}
	}

	private int getRoomId2Col(int tabNo, String roomID) {
		if (tabNo == 1) {
			return roomId2Col2.get(roomID);
		} else {
			return roomId2Col.get(roomID);
		}
	}

	private void setRoomID2Col(int tabNo, String roomID, int column) {
		if (tabNo == 1) {
			roomId2Col2.put(roomID, column);
			col2Room2.put(column, roomID);
		} else {
			roomId2Col.put(roomID, column);
			col2Room.put(column, roomID);
		}
	}

	public void setSelectedRoom(String selectedRoom) {
		this.selectedRoom = selectedRoom;
	}

	public String getSelectedRoom() {
		return selectedRoom;
	}

	private TextDate getDVStartDate(int tabNo) {
		if (tabNo == 1) {
			return getDVStartDate2();
		} else {
			return getDVStartDate();
		}
	}
	
	private int addMissCols(int tabNo){
		int missCols = 0;
		if(tabNo == 0 && !isShowMoreTime){
			missCols = 30;
		} else if (tabNo == 1 && !isShowMoreTime2){
			missCols = 80;
		}
		return missCols;
	}

	private void setGrdAppBseViewRefresh(int tabNo, int rowNo, int colNo) {		
		List<String> tempDeptAID = getRowColID_Col(tabNo).get(String.valueOf(rowNo + addMissCols(tabNo)) + "-" + String.valueOf(colNo));
		int DeptAID_Count = -1;
		int i = -1;
		StringBuffer DeptAID_sql = new StringBuffer();
		memCurrSelectedCellColID = colNo;
		memCurrSelectedCellRowNo = rowNo;
		
		if (tempDeptAID == null) {
			DeptAID_sql.append(" and 1=2 ");
		} else {
			DeptAID_Count = tempDeptAID.size();
			DeptAID_sql.append(" and a.deptaid in (");
			i = 0;
			DeptAID_sql.append("'");
			DeptAID_sql.append(tempDeptAID.get(i));
			DeptAID_sql.append("'");

			for (i = 1; i <= DeptAID_Count - 1; i++) {
				DeptAID_sql.append(", '");
				DeptAID_sql.append(tempDeptAID.get(i));
				DeptAID_sql.append("'");
			}

			DeptAID_sql.append(") ");
		}

		getDVBTable(tabNo).setListTableContent("DEPTDVBTABLELIST", new String[] {DeptAID_sql.toString()});
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
		
		setBackgroundColorToView(tabNo, tempBkgColorData);
		

		
		listTxCode = "DEPTDVATABLELIST";
		listTxParam = new String[] {dvStartDate, getUserInfo().getSiteCode(), memDeptType, tabType[tabNo]};

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
							
							String appointSts = String.valueOf(row[13]);
							String specBook = String.valueOf(row[12]);
							String content = "";
							if ("B".equals(appointSts)){
								content = "(" + row[14] + ")"; 
							} else if ((!"".equals(isPHorSat) && isPHorSat != null) && ("".equals(appointSts) || appointSts == null)) {
								content =  isPHorSat ; 
							} else {
								content = row[7] + "(" + row[9] + ") - " + row[10] + "(" + row[11] + ")";
							}
																										
							if(tabNo == 0 && !isShowMoreTime){
								if(S_SlotRowNo < 30 && S_SlotRowNo >= 0){
									getShowMoreTime().setSelected(true);
									isShowMoreTime = true;
								}
							}
							
							if(tabNo == 1 && !isShowMoreTime2){
								if(S_SlotRowNo < 80 && S_SlotRowNo >= 0){
									getShowMoreTime2().setSelected(true);
									isShowMoreTime2 = true;
								}
							}
							if (S_SlotRowNo == E_SlotRowNo) {
								temp.setLength(0);
								temp.append((String) tempTextData.get(S_SlotRowNo).getValue(colno));
								if (temp.length() > 0) {
									temp.append(COMMA_VALUE);
									temp.append(SPACE_VALUE);
								}
								temp.append(content);

								tempTextData.get(S_SlotRowNo).setValue(colno, temp.toString());
								//setCellColor(tempTxtColorData, S_SlotRowNo, colno, row[1].toString());
								setBackgroundColor(tempBkgColorData, S_SlotRowNo, colno, specBook,appointSts,isPHorSat);
								setAddDeptAID(tabNo, S_SlotRowNo, colno, row[0].toString());
							} else {
								temp.setLength(0);
								temp.append((String) tempTextData.get(S_SlotRowNo).getValue(colno));
								if (temp.length() > 0) {
									temp.append(COMMA_VALUE);
									temp.append(SPACE_VALUE);
								}
								temp.append(content);

								tempTextData.get(S_SlotRowNo).setValue(colno, temp.toString());
								//setCellColor(tempTxtColorData, S_SlotRowNo, colno, row[1].toString());								
								setBackgroundColor(tempBkgColorData, S_SlotRowNo, colno, specBook,appointSts,isPHorSat);
								setAddDeptAID(tabNo, S_SlotRowNo, colno, row[0].toString());

								for (int k = S_SlotRowNo + 1; k <= E_SlotRowNo; k++) {
									temp.setLength(0);
									temp.append((String) tempTextData.get(k).getValue(colno));
									if (temp.length() > 0) {
										temp.append(COMMA_VALUE);
										temp.append(SPACE_VALUE);
									}
									temp.append(content);
									tempTextData.get(k).setValue(colno, temp.toString());
									//setCellColor(tempTxtColorData, k, colno, row[1].toString());
									setBackgroundColor(tempBkgColorData, k, colno, specBook,appointSts,isPHorSat);
									setAddDeptAID(tabNo, k, colno, row[0].toString());									
								}
							}
						}
					}
					if (record.length > 0) {
						setTextColor(tempTextData, tempTxtColorData);
						removeWordings(tempTextData, tempBkgColorData);
						getDVATable(tabNo).getStore().removeAll();
						getDVATable(tabNo).getStore().add(tempTextData);
						setBackgroundColorToView(tabNo, tempBkgColorData);
					}
				} else if (!"".equals(isPHorSat) && isPHorSat != null) {
					getDVATable(tabNo).getView().getCell(35, 1).setInnerText(isPHorSat);
				}
				getDVATable(tabNo).getView().layout();

				if (memCurrSelectedCellColID > 0 && memCurrSelectedCellRowNo > 0) {
					GridEvent gridEvent = new GridEvent(getDVATable(tabNo));
				    gridEvent.setRowIndex(memCurrSelectedCellRowNo);
				    gridEvent.setColIndex(memCurrSelectedCellColID);
					getDVATable(tabNo).fireEvent(Events.CellClick,gridEvent);
				}
				getMainFrame().setLoading(false);
				Factory.getInstance().hideMask();
				removeRows(getDVATable(tabNo).getStore(), tabNo,isShowMoreTime,isShowMoreTime2);
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

	private void setAddDeptAID(int tabNo, int rowNo, int colNo, String deptaID) {
		List<String> SlotDeptAID_COL  = getRowColID_Col(tabNo).get(String.valueOf(rowNo) + "-" + String.valueOf(colNo));
		if (SlotDeptAID_COL == null) {
			SlotDeptAID_COL = new ArrayList<String>();
			SlotDeptAID_COL.add(deptaID);
			getRowColID_Col(tabNo).put(String.valueOf(rowNo) + "-" + String.valueOf(colNo), SlotDeptAID_COL);
		} else {
			SlotDeptAID_COL.add(deptaID);
		 }
	}

	private void setCellColor(List<TableData> tempData, int rowNo, int colNo, String status) {
		String color = (String) tempData.get(rowNo).getValue(colNo);
		if (color == null || color.length() == 0) {
			color = memGridColorBackNormal;
		}

		if (status.equals(DEPT_APPSTS_N) && memGridColorBackNormal.equals(color)) {
			color = memGridColorNormal;
		} else if (DEPT_APPSTS_F.equals(status) && memGridColorBackNormal.equals(color)) {
			color = memGridColorConfirm;
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

	private void setBackgroundColor(List<TableData> bkgColorData, int rowNo, int colNo, String specBook, String appSts, String isPHorSat) {
		String bgcolor = bkgColorTemplate[2];
		if ((appSts==null || "".equals(appSts)) && isPHorSat != null && !"".equals(isPHorSat) 
			&& ( rowNo > 35 && rowNo < 39 )){
			bgcolor = bkgColorTemplate[11];
		}
		if("F".equals(appSts)) {
			bgcolor = bkgColorTemplate[9];
		} else if ("B".equals(appSts)) {
			bgcolor = bkgColorTemplate[11];
		}
		if("1".equals(specBook)){
			bgcolor = bkgColorTemplate[1];
			if("F".equals(appSts)) {
				bgcolor = bkgColorTemplate[10];
			}
		}
		if(!bkgColorTemplate[1].equals(bkgColorData.get(rowNo).getValue(colNo))||
				!bkgColorTemplate[10].equals(bkgColorData.get(rowNo).getValue(colNo))){
			bkgColorData.get(rowNo).setValue(colNo, bgcolor);
		}		
	}
	
	private void removeWordings(List<TableData> tempData, List<TableData> bkgColorData) {
		String cellValue1 = null;
		String cellValue2 = null;
		for (int j = 1; j < bkgColorData.get(0).getSize(); j++) {
			for (int i = tempData.size() - 1; i > 0; i--) {
				cellValue1 = ((String) tempData.get(i - 1).getValue(j)).trim();
				cellValue2 = ((String) tempData.get(i).getValue(j)).trim();
				if (cellValue1.length() > 0 && cellValue2.length() > 0) {
					if (cellValue1.equals(cellValue2)) {
						tempData.get(i).setValue(j, EMPTY_VALUE);
					} else {

					}
				}
			}
		}
	}

	private void removeRows(ListStore tempData, int tabNo, boolean isShowMoreTime, boolean isShowMoreTime2) {
		for (int i = tempData.getCount() -1 ; i >= 0; i--) {
			if(tabNo == 0 && !isShowMoreTime){
				if(i < 30 && i >= 0){
					tempData.remove(i);
				}
			} else if(tabNo == 1 && !isShowMoreTime2) {
				if(i < 80 && i >= 0){
					tempData.remove(i);
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
					if(i < 35 && bkgColor.get(i).getValue(j).toString().isEmpty()){
						cell.addClassName("ot-cell-bkgcolor10");
					}
					if(i > 34 && i < 38  && (!"".equals(isPHorSat) && isPHorSat != null) 
							&& bkgColor.get(i).getValue(j).toString().isEmpty()){
						cell.addClassName("ot-cell-bkgcolorBlock");
					}
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
/*
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
*/
		for (int i = 0; i < 96; i++) {
			String hour;
			String second;
			int h = i/4;
			int s = (i % 4) * 15;
			if (h != 0) {
				if (h < 10) {
					hour = "0".concat(String.valueOf(h));
				} else {
					hour = String.valueOf(h);
				}
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
		
		if (tabNo == 1) {
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
		QueryUtil.executeMasterBrowse(getUserInfo(), "DEPT_ROOM",
				new String[] { memDeptType, tabType[tabNo] },
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

	protected void cancelAppAlert() {
		String deptasts = null;
		int tabIndex = getTabbedPane().getSelectedIndex();
		
		if (tabIndex == tabIndex_GeneralView) {
			if (getListTable() != null && getListTable().getSelectedRow() >= 0) {
				deptasts = getListTable().getSelectedRowContent()[GenCol_StatusCode];
			}
		} else if (tabIndex >= 0) {
			if (getDVBTable(tabIndex) != null && getDVBTable(tabIndex).getSelectedRow() >= 0) {
				deptasts = getDVBTable(tabIndex).getSelectedRowContent()[DailyCol_STATUSCODE];
			}
		}
		
		Factory.getInstance().isConfirmYesNoDialog(("B".equals(deptasts)?"Do you want to unblock?":
															("Do you want to cancel the " + memDeptType + " appointment?")),
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
		String deptasts = null;
		int tabIndex = getTabbedPane().getSelectedIndex();
		
		if (tabIndex == tabIndex_GeneralView) {
			if (getListTable() != null && getListTable().getSelectedRow() >= 0) {
				deptasts = getListTable().getSelectedRowContent()[GenCol_StatusCode];
			}
		} else if (tabIndex >= 0) {
			if (getDVBTable(tabIndex) != null && getDVBTable(tabIndex).getSelectedRow() >= 0) {
				deptasts = getDVBTable(tabIndex).getSelectedRowContent()[DailyCol_STATUSCODE];
			}
		}
		if("B".equals(deptasts)) {
				cancelApp2("", "", "", "", "UNBLOCK");
		} else {
			DlgDeptAppCancelReasonSel dlg = new DlgDeptAppCancelReasonSel(getMainFrame()) {
				@Override
				protected void save(String cancelCode,String isAdmittedCode, String cancelByCode, String otherCode, String remark) {
					cancelApp2(cancelCode, isAdmittedCode, cancelByCode, otherCode, remark);
				}
			};
			dlg.show();
		}
	}

	protected void cancelApp2(String cancelCode,String isAdmittedCode, String cancelByCode, String otherCode, String remark) {
		QueryUtil.executeMasterAction(
				Factory.getInstance().getUserInfo(), "DEPTAPP_CANC",
				QueryUtil.ACTION_MODIFY,
				new String[] {getSelectedDeptaid(), cancelCode, isAdmittedCode, cancelByCode, otherCode, remark},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					cancelAppPostAction(true);
				} else {
					Factory.getInstance().addErrorMessage(mQueue);
					cancelAppPostAction(false);
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

		int tabIndex = getTabbedPane().getSelectedIndex();
		if (tabIndex == tabIndex_GeneralView) {
			patno = getListSelectedRow()[GenCol_patNo];
			startDate = getListSelectedRow()[GenCol_SDate];
			endDate = getListSelectedRow()[GenCol_EDate];
			roomName = getListSelectedRow()[GenCol_Room];
			
		} else if (tabIndex >= 0) {
			patno = getDVBTable(tabIndex).getSelectedRowContent()[DailyCol_PATNO];
			startDate = getDVBTable(tabIndex).getSelectedRowContent()[DailyCol_APPSDATE];
			endDate = getDVBTable(tabIndex).getSelectedRowContent()[DailyCol_APPEDATE];
			roomName = getDVBTable(tabIndex).getSelectedRowContent()[DailyCol_ROOM];
		}

		String funname = memDeptType + " Appointment -> Cancel App";
		Map<String, String> params = new HashMap<String, String>();	
		params.put("Room", roomName);
		params.put("App Start Date", startDate);
		params.put("App End Date", endDate);
			
		getAlertCheck().checkAltAccess(patno, funname, true, true, params);
		if (tabIndex == tabIndex_GeneralView) {
			searchAction();
		} else if (tabIndex >= 0) {
			DVATableRefresh(tabIndex, true);
		}
	}
	
	protected void confirmApp() {
		QueryUtil.executeMasterAction(
				Factory.getInstance().getUserInfo(), "DEPTAPP_CONFIRM",
				QueryUtil.ACTION_MODIFY,
				new String[] {getSelectedDeptaid()},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					confirmAppPostAction(true);
				} else {
					Factory.getInstance().addErrorMessage(mQueue);
					confirmAppPostAction(false);
				}
			}
			
			@Override
			public void onFailure(Throwable caught) {
				confirmAppPostAction(false);
			}
		});
	}
	
	protected void confirmAppPostAction(boolean ret) {
		String patno = null;
		String startDate = null;
		String endDate = null;
		String roomName = null;
		

		int tabIndex = getTabbedPane().getSelectedIndex();
		if (tabIndex == tabIndex_GeneralView) {
			patno = getListSelectedRow()[GenCol_patNo];
			startDate = getListSelectedRow()[GenCol_SDate];
			endDate = getListSelectedRow()[GenCol_EDate];
			roomName = getListSelectedRow()[GenCol_Room];
			
		} else if (tabIndex >= 0) {
			patno = getDVBTable(tabIndex).getSelectedRowContent()[DailyCol_PATNO];
			startDate = getDVBTable(tabIndex).getSelectedRowContent()[DailyCol_APPSDATE];
			endDate = getDVBTable(tabIndex).getSelectedRowContent()[DailyCol_APPEDATE];
			roomName = getDVBTable(tabIndex).getSelectedRowContent()[DailyCol_ROOM];
		}

		String funname = memDeptType + " Appointment -> Confirm App";
		Map<String, String> params = new HashMap<String, String>();	
		params.put("Room", roomName);
		params.put("App Start Date", startDate);
		params.put("App End Date", endDate);
			
		getAlertCheck().checkAltAccess(patno, funname, true, true, params);
		if (tabIndex == tabIndex_GeneralView) {
			searchAction();
		} else if (tabIndex >= 0) {
			DVATableRefresh(tabIndex, true);
		}
	}
	
	protected void restoreApp() {
		QueryUtil.executeMasterAction(
				Factory.getInstance().getUserInfo(), "DEPTAPP_RESTORE",
				QueryUtil.ACTION_MODIFY,
				new String[] {getSelectedDeptaid()},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					restoreAppPostAction(true);
				} else {
					Factory.getInstance().addErrorMessage(mQueue);
					restoreAppPostAction(false);
				}
			}
			
			@Override
			public void onFailure(Throwable caught) {
				restoreAppPostAction(false);
			}
		});
	}
	
	protected void restoreAppPostAction(boolean ret) {
		String patno = null;
		String startDate = null;
		String endDate = null;
		String roomName = null;
		

		int tabIndex = getTabbedPane().getSelectedIndex();
		if (tabIndex == tabIndex_GeneralView) {
			patno = getListSelectedRow()[GenCol_patNo];
			startDate = getListSelectedRow()[GenCol_SDate];
			endDate = getListSelectedRow()[GenCol_EDate];
			roomName = getListSelectedRow()[GenCol_Room];
			
		} else if (tabIndex >= 0) {
			patno = getDVBTable(tabIndex).getSelectedRowContent()[DailyCol_PATNO];
			startDate = getDVBTable(tabIndex).getSelectedRowContent()[DailyCol_APPSDATE];
			endDate = getDVBTable(tabIndex).getSelectedRowContent()[DailyCol_APPEDATE];
			roomName = getDVBTable(tabIndex).getSelectedRowContent()[DailyCol_ROOM];
		}

		String funname = memDeptType + " Appointment -> Restore App";
		Map<String, String> params = new HashMap<String, String>();	
		params.put("Room", roomName);
		params.put("App Start Date", startDate);
		params.put("App End Date", endDate);
			
		getAlertCheck().checkAltAccess(patno, funname, true, true, params);
		if (tabIndex == tabIndex_GeneralView) {
			searchAction();
		} else if (tabIndex >= 0) {
			DVATableRefresh(tabIndex, true);
		}
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
			leftPanel.add(getRestoreApp(), null);
			leftPanel.add(getConfirmApp(), null);
			leftPanel.add(getSlipBtn(), null);
			leftPanel.add(getPatientReg(), null);
			leftPanel.add(getBlockBtn(), null);
			leftPanel.add(getRemarkAction(), null);
			leftPanel.add(getNurseNotes(), null);
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
					if (!isDisableFunction("btnDeptAppDisable", "reg") && 
							!Factory.getInstance().getUserInfo().getSiteCode().equals(Factory.getInstance().getUserInfo().getUserID())) {
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
					resetVariable();
					DVATableRefresh(getSelectedIndex(), false);
					}
				}
			};
			TabbedPane.setBounds(0, 1, 784, 480);
			
			TabbedPane.addTab("Daily View", getDVPanel());
			TabbedPane.addTab("Sleep Study", getDVPanel2());
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
			ParaPanel.add(getDocCodeDesc(), null);
			ParaPanel.add(getDocCode(), null);
			ParaPanel.add(getSortByDesc(), null);
			ParaPanel.add(getSortBy(), null);
			ParaPanel.add(getJScrollPane());
			ParaPanel.setBounds(5, 5, 759, 95);
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

	private ComboDeptStatus getStatus() {
		if (Status == null) {
			Status = new ComboDeptStatus();
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

	private ComboDeptAppRoomType getRoom() {
		if (Room == null) {
			Room = new ComboDeptAppRoomType(memDeptType);
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

	private ComboDeptProc getProCode() {
		if (ProCode == null) {
			ProCode = new ComboDeptProc(memDeptType) {
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
	
	private LabelBase getDocCodeDesc() {
		if (DocCodeDesc == null) {
			DocCodeDesc = new LabelBase();
			DocCodeDesc.setText("Dr. Code");
			DocCodeDesc.setBounds(275, 60, 90, 20);
		}
		return DocCodeDesc;
	}
	
	private TextDoctorSearch getDocCode() {
		if (DocCode == null) {
			DocCode = new TextDoctorSearch() {
				@Override
				public void checkTriggerBySearchKey() {
					if (!getText().isEmpty() && (getText().indexOf("%") > -1 || getText().indexOf(",") > -1)) {
						checkTriggerBySearchKeyPost();
					} else {
						super.checkTriggerBySearchKey();
					}
				}
				@Override
				public void checkTriggerBySearchKeyPost() {
					searchAction(true);
				}
			};
			DocCode.setBounds(365, 60, 120, 20);
		}
		return DocCode;
	}

	private LabelBase getSortByDesc() {
		if (SortByDesc == null) {
			SortByDesc = new LabelBase();
			SortByDesc.setText("Sort By");
			SortByDesc.setBounds(530, 60, 90, 20);
		}
		return SortByDesc;
	}

	private ComboDeptAppSortBy getSortBy() {
		if (SortBy == null) {
			SortBy = new ComboDeptAppSortBy();
			SortBy.setBounds(610, 60, 140, 20);
		}
		return SortBy;
	}

	private ButtonBase getNewApp() {
		if (NewApp == null) {
			NewApp = new ButtonBase() {
				@Override
				public void onClick() {
					newAppAction();
				}
			};
			NewApp.setText("New App");
			NewApp.setBounds(5, 490, 105, 30);
		}
		return NewApp;
	}
	
	private void newAppAction() {
		Collections.sort(getCellSelectionModel().getSelections(),
				new Comparator<CellSelection>() {
			@Override
			public int compare(CellSelection o1, CellSelection o2) {
				return o1.row - o2.row;
			}
		});

		setParameter("ActionType", QueryUtil.ACTION_APPEND);
							
		if (getCellSelectionModel().getSelections().size() <= 0 && getTabbedPane().getSelectedIndex()== tabIndex_GeneralView) {
			setParameter("Slt_SDate", getDVStartDate().getText() + " 00:00");
			setParameter("Slt_EDate", getDVStartDate().getText() + " 00:00");
			if (getListTable().getSelectedRowContent()!= null ){
			setParameter("patno",getListTable().getSelectedRowContent()[GenCol_patNo]);
			}
			
		} else {
			
			String sTime = "".equals(getSelectedTime().getText())?"00:00":getSelectedTime().getText();
			if (getDVBTable(getTabbedPane().getSelectedIndex()).getSelectedRowContent() != null ){ 
				if (!"".equals(getDVBTable(getTabbedPane().getSelectedIndex()).getSelectedRowContent()[DailyCol_PATNO])) {
					setParameter("patno",getDVBTable(getTabbedPane().getSelectedIndex()).getSelectedRowContent()[DailyCol_PATNO]);
				} else {
					setParameter("patFName",getDVBTable(getTabbedPane().getSelectedIndex()).getSelectedRowContent()[DailyCol_PATFNAME]);
					setParameter("patGName",getDVBTable(getTabbedPane().getSelectedIndex()).getSelectedRowContent()[DailyCol_PATGNAME]);
				}
				sTime = "00:00";
				setSelectedRoom("");
				setParameter("refDoctor",getDVBTable(getTabbedPane().getSelectedIndex()).getSelectedRowContent()[DailyCol_DOCTOR]);
			}
			
				final long minuteInMillis = 60L * 1000L;
				if (getTabbedPane().getSelectedIndex()== 0) {
					setParameter("Slt_SDate", getDVStartDate().getText() + " " + sTime);
					//setParameter("Slt_EDate", getDVStartDate().getText() + " " + DateTimeUtil.formatTime(new java.util.Date(DateTimeUtil.parseTime(eTime+":00").getTime()+(14L*minuteInMillis))).substring(0, 5));
					setParameter("Slt_EDate", getDVStartDate().getText() + " " + sTime);
				} else {
					setParameter("Slt_SDate", getDVStartDate2().getText() + " " + sTime);
					//setParameter("Slt_EDate", getDVStartDate().getText() + " " + DateTimeUtil.formatTime(new java.util.Date(DateTimeUtil.parseTime(eTime+":00").getTime()+(14L*minuteInMillis))).substring(0, 5));
					setParameter("Slt_EDate", getDVStartDate2().getText() + " " + sTime);
				}
				setParameter("exam_room",getSelectedRoom());
		}
			showPanel(new NewEditDeptApp(memDeptType){
				@Override
				protected void proExitPanel() {
					super.proExitPanel();
					newDeptAppPostAction();
				}
			}
		);
	}
	
	private void newDeptAppPostAction(){
		resetVariable();
		//refreshAction();
	}

	private ButtonBase getEditApp() {
		if (EditApp == null) {
			EditApp = new ButtonBase() {
				@Override
				public void onClick() {
					editAppAction();
				}
			};
			EditApp.setText("Edit App");
			EditApp.setBounds(117, 490, 80, 30);
		}
		return EditApp;
	}
	
	private void editAppAction() {
		setParameter("deptaid", getSelectedDeptaid());
		setParameter("ActionType", QueryUtil.ACTION_MODIFY);
		setParameter("deptApp_bIsEdit", "Y");
		showPanel(new NewEditDeptApp(memDeptType){
			@Override
			protected void proExitPanel() {
				super.proExitPanel();
				newDeptAppPostAction();
			}
		});
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
			CancelApp.setBounds(204, 490, 80, 30);
		}
		return CancelApp;
	}
	
	private ButtonBase getRestoreApp() {
		if (RestoreApp == null) {
			RestoreApp = new ButtonBase() {
				@Override
				public void onClick() {
					DlgDeptSecCheck jdialog = new DlgDeptSecCheck(getMainFrame(), "single"){
						@Override
						public void setVisible(boolean visible) {
							super.setVisible(visible);
						}

						@Override
						public void saveApp() {
							restoreApp();
						}
					};
					jdialog.setResizable(false);
					jdialog.setVisible(true);
				}
			};
			
			RestoreApp.setText("Restore App");
			RestoreApp.setEnabled(false);
			RestoreApp.setBounds(286, 490, 80, 30);
		}
		return RestoreApp;
	}
	
	
	
	private ButtonBase getConfirmApp() {
		if (ConfirmApp == null) {
			ConfirmApp = new ButtonBase() {
				@Override
				public void onClick() {
					Factory.getInstance().isConfirmYesNoDialog("Do you want to confirm the " + memDeptType + " appointment?",
							new Listener<MessageBoxEvent>() {
						@Override
						public void handleEvent(MessageBoxEvent be) {
							if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
								confirmApp();
							}
						}
					});
				}
			};
			ConfirmApp.setText("Confirm App");
			ConfirmApp.setBounds(370, 490, 105, 30);
		}
		return ConfirmApp;
	}

	private ButtonBase getSlipBtn() {
		if (SlipBtn == null) {
			SlipBtn = new ButtonBase() {
				@Override
				public void onClick() {
					String tmpPatNo = "";
					int tabIndex = getTabbedPane().getSelectedIndex();
					if (tabIndex == tabIndex_GeneralView) {
						if (getListTable() != null && getListTable().getSelectedRow() >= 0) {
							tmpPatNo = getListTable().getSelectedRowContent()[GenCol_patNo];
						}
					} else if (tabIndex >= 0) {
						if (getDVBTable(tabIndex) != null && getDVBTable(tabIndex).getSelectedRow() >= 0) {
							tmpPatNo = getDVBTable(tabIndex).getSelectedRowContent()[DailyCol_PATNO];
						}
					}
					if(tmpPatNo != null && tmpPatNo.length() > 0){
						getDlgSlipList().showDialog(tmpPatNo);
					}
				}
			};
			SlipBtn.setBounds(478, 490, 105, 30);
			SlipBtn.setText("Slip");
		}
		return SlipBtn;
	}

	private ButtonBase getPatientReg() {
		if (PatientReg == null) {
			PatientReg = new ButtonBase() {
				@Override
				public void onClick() {
					String tmpPatNo = "";
					int tabIndex = getTabbedPane().getSelectedIndex();
					if (tabIndex == tabIndex_GeneralView) {
						if (getListTable() != null && getListTable().getSelectedRow() >= 0) {
							tmpPatNo = getListTable().getSelectedRowContent()[GenCol_patNo];
						}
					} else if (tabIndex >= 0) {
						if (getDVBTable(tabIndex) != null && getDVBTable(tabIndex).getSelectedRow() >= 0) {
							tmpPatNo = getDVBTable(tabIndex).getSelectedRowContent()[DailyCol_PATNO];
						}
					}
/*					if(tmpPatNo != null && tmpPatNo.length() > 0){
						getDlgSlipList().showDialog(tmpPatNo);
					}*/
					
					if(!"".equals(tmpPatNo) && tmpPatNo.length() > 0){
						setParameter("PatNo", tmpPatNo);
					}
					showPanel(new Patient());
				}
			};
			PatientReg.setText("Patient Registration");
			PatientReg.setBounds(585, 490, 105, 30);
		}
		return PatientReg;
	}
	
	private void postPatientRegAction(final String updatedPatientNo){
		String patno = null;
		String patname = null;
		String deptaid = null;
		int tabIndex = getTabbedPane().getSelectedIndex();
		if (tabIndex == tabIndex_GeneralView) {
			if (getListTable() != null && getListTable().getSelectedRow() >= 0) {
				patno = getListTable().getSelectedRowContent()[GenCol_patNo];
				patname = getListTable().getSelectedRowContent()[GenCol_patName];
				deptaid = getSelectedDeptaid();
			}
		} else if (tabIndex >= 0) {
			if (getDVBTable(tabIndex) != null && getDVBTable(tabIndex).getSelectedRow() >= 0) {
				patno = getDVBTable(getTabbedPane().getSelectedIndex()).getSelectedRowContent()[DailyCol_PATNO];
				patname = getDVBTable(getTabbedPane().getSelectedIndex()).getSelectedRowContent()[DailyCol_PATNAME];
				deptaid = getSelectedDeptaid();
			}
		}
		if ((patno == null || "".equals(patno)) && (deptaid != null && !"".equals(deptaid))) {
			Factory.getInstance().isConfirmYesNoDialog("Do you want to edit appointment of "
					+patname+" with patient number("+updatedPatientNo+") ?",
					new Listener<MessageBoxEvent>() {
				@Override
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						setParameter("deptaid", getSelectedDeptaid());
						setParameter("patno",updatedPatientNo);
						setParameter("ActionType", QueryUtil.ACTION_MODIFY);
						setParameter("deptApp_bIsEdit", "Y");
						showPanel(new NewEditDeptApp(memDeptType){
							@Override
							protected void proExitPanel() {
								super.proExitPanel();
								newDeptAppPostAction();
							}
						});
					}
				}
			});
		}
		resetVariable();
		searchAction();
	}
	


	private DlgSlipListWithNewSlip getDlgSlipList() {
		if (DlgSlipList == null) {
			DlgSlipList = new DlgSlipListWithNewSlip(getMainFrame()) {
				@Override
				public void post(String newSlipNo) {
					if (newSlipNo != null && newSlipNo.length() > 0) {
						getDlgSlipList().dispose();
						showTransactions(newSlipNo);
					}
				}
				@Override
				public void showDialog(String patno) {
					super.showDialog(patno,true);
					setVisible(true);
				}
			};
		}
		return DlgSlipList;
	}
	
	private void showTransactions(String slpNo) {
		setParameter("SlpNo", slpNo);
		setParameter("From", "PATREG");
		showPanel(new TransactionDetail());
	}
	
	private ButtonBase getBlockBtn() {
		if (BlockBtn == null) {
			BlockBtn = new ButtonBase() {
				@Override
				public void onClick() {
					int tabIndex = getTabbedPane().getSelectedIndex();
					
							getBlockDialog().showDialog(
									getSelectedRoom(),
									getDVStartDate().getText(),
									"".equals(getSelectedTime().getText())?"00:00":getSelectedTime().getText(),
									memDeptType
							);
					
				}
			};
			BlockBtn.setText("Block", 'B');
			BlockBtn.setEnabled(false);
			BlockBtn.setBounds(695, 490, 80, 30);
		}
		return BlockBtn;
	}
	
	// block dialog start
	private DlgBlockDeptApp getBlockDialog() {
		if (blockDialog == null) {
			blockDialog = new DlgBlockDeptApp(getMainFrame()) {
				@Override
				public void post() {
					getThis().rePostAction();
				}
			};
		}
		return blockDialog;
	}
	
	private ButtonBase getRemarkAction() {
		if (remarkAction == null) {
			remarkAction = new ButtonBase() {
				@Override
				public void onClick() {
					QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] {"HPSTATUS", "HPRMK", "HPTYPE ='CPLABAPP' AND HPKEY='ALERT' "},
							new MessageQueueCallBack() {
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								getRemark_update().setText(mQueue.getContentField()[0]);
								getRemarkDialog().setVisible(true);
							}
						}});
					
				}
			};
			remarkAction.setText("Remark", 'R');
			remarkAction.setBounds(5, 525, 80, 30);
		}
		return remarkAction;
	}
	
	// remark dialog start
	public DialogBase getRemarkDialog() {
		if (remarkDialog == null) {
			remarkDialog = new DialogBase(getMainFrame(), DialogBase.OKCANCEL, 390, 200) {
				@Override
				public TextAreaBase getDefaultFocusComponent() {
					return getRemark_update();
				}

				@Override
				public void doOkAction() {
					doRemark();
				}
			};
			remarkDialog.setTitle("Remark");
			remarkDialog.setLayout(null);
			remarkDialog.setPosition(300, 100);
			remarkDialog.add(getRemarkTopPanel(), null);

			// change label
			remarkDialog.getButtonById(DialogBase.OK).setText("Update");
		}
		return remarkDialog;
	}

	private FieldSetBase getRemarkTopPanel() {
		if (remarkTopPanel == null) {
			remarkTopPanel = new FieldSetBase();
			remarkTopPanel.setBounds(5, 5, 365, 150);
			remarkTopPanel.setHeading("Update remark");
			remarkTopPanel.add(getRemark_update(), null);
		}
		return remarkTopPanel;
	}

	private TextAreaBase getRemark_update() {
		if (remark_update == null) {
			remark_update = new TextAreaBase();
			remark_update.setMaxLength(200);
			remark_update.setBounds(10, 5, 340, 90);
		}
		return remark_update;
	}
	
	private void doRemark() {
		QueryUtil.executeMasterAction(getUserInfo(), "DEPTAPP_RMK", QueryUtil.ACTION_MODIFY,
				new String[] {
					"CPLABAPP",
					"ALERT",
					getRemark_update().getText().trim(),
					getUserInfo().getUserID()
				},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getRemark_update().resetText();
					getRemarkDialog().setVisible(false);
					searchAction();
				} else {
					Factory.getInstance().addErrorMessage(mQueue);
				}
			}
		});
	}
	
	private ButtonBase getNurseNotes() {
		if (nurseNotes == null) {
			nurseNotes = new ButtonBase() {
				@Override
				public void onClick() {
					setParameter("deptaid", getSelectedDeptaid());
					setParameter("ActionType",QueryUtil.ACTION_MODIFY);
					setParameter("deptApp_bIsEdit", "N");
					setParameter("isNurseNote", "Y");
					showPanel(new NewEditDeptApp(memDeptType){
						@Override
						protected void proExitPanel() {
							super.proExitPanel();
							newDeptAppPostAction();
						}
					});
				}
			};
			nurseNotes.setText("Nurse Notes", 'N');
			nurseNotes.setBounds(87, 525, 80, 30);
		}
		return nurseNotes;
	}
	

	// DEPT Tab
	private BasePanel getDVPanel() {
		if (DVPanel == null) {
			DVPanel = new BasePanel();
			DVPanel.setBounds(5, 5, 790, 480);
			DVPanel.add(getDVStartDateDesc(), null);
			DVPanel.add(getPrevDate(), null);
			DVPanel.add(getDVStartDate(), null);
			DVPanel.add(getNextDate(), null);
			DVPanel.add(getShowMoreTimeDesc(), null);
			DVPanel.add(getSelectedTimeDesc(), null);
			DVPanel.add(getSelectedTime(), null);
			DVPanel.add(getShowMoreTime(), null);
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

	@SuppressWarnings("unchecked")
	private TextDate getDVStartDate() {
		if (DVStartDate == null) {
			DVStartDate = new TextDate();
			DVStartDate.getDatePicker().addListener(Events.Select,
					new Listener<DatePickerEvent>() {
				@Override
				public void handleEvent(DatePickerEvent be) {
					if (!DVStartDate.isEmpty() && DVStartDate.isValid()) {
						QueryUtil.executeMasterFetch(getUserInfo(), "CHECKDEPTAPPPHORSAT",
								new String[] {DVStartDate.getText()},
								new MessageQueueCallBack() {
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									if(!"".equals(mQueue.getContentField()[0]) && mQueue.getContentField()[0] != null) {
										isPHorSat = mQueue.getContentField()[0];
									} else {
										isPHorSat = null;
									}
									onDVStartDateChange(0);
								}
							}});
						
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
						QueryUtil.executeMasterFetch(getUserInfo(), "CHECKDEPTAPPPHORSAT",
								new String[] {DVStartDate.getText()},
								new MessageQueueCallBack() {
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									if(!"".equals(mQueue.getContentField()[0]) && mQueue.getContentField()[0] != null) {
										isPHorSat = mQueue.getContentField()[0];
									} else {
										isPHorSat = null;
									}
									onDVStartDateChange(0);
								}
							}});
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
	
	private ButtonBase getPrevDate() {
		if (PrevDate == null) {
			PrevDate = new ButtonBase() {
				@Override
				public void onClick() {
					if (!getDVStartDate().isEmpty() && getDVStartDate().isValid()) {

						Date PrevDate = null;
						try {
							PrevDate = DateTimeUtil.parseDate(getDVStartDate().getText());
							CalendarUtil.addDaysToDate(PrevDate, -1);
							getDVStartDate().setText(DateTimeUtil.formatDate(PrevDate));
							onDVStartDateChange(0);
						} catch (Exception e) {
							Factory.getInstance().addErrorMessage("Invalid Date.", getDVStartDate());
						}
					} else {
						Factory.getInstance().addErrorMessage("Invalid Date.", getDVStartDate());
					}
				}
			};
			PrevDate.setText("<<");
			PrevDate.setBounds(65, 10, 30, 20);
		}
		return PrevDate;
	}
	
	private ButtonBase getNextDate() {
		if (NextDate == null) {
			NextDate = new ButtonBase() {
				@Override
				public void onClick() {
					if (!getDVStartDate().isEmpty() && getDVStartDate().isValid()) {

						Date nextDate = null;
						try {
							nextDate = DateTimeUtil.parseDate(getDVStartDate().getText());
							CalendarUtil.addDaysToDate(nextDate, 1);
							getDVStartDate().setText(DateTimeUtil.formatDate(nextDate));
							onDVStartDateChange(0);
						} catch (Exception e) {
							Factory.getInstance().addErrorMessage("Invalid Date.", getDVStartDate());
						}
					} else {
						Factory.getInstance().addErrorMessage("Invalid Date.", getDVStartDate());
					}
				}
			};
			NextDate.setText(">>");
			NextDate.setBounds(215, 10, 30, 20);
		}
		return NextDate;
	}
	
	protected CheckBoxBase getShowMoreTime() {
		if (showMoreTime == null) {
			showMoreTime = new CheckBoxBase(){
				@Override
				public void onClick() {
					super.onClick();
					int tabNo = getTabbedPane().getSelectedIndex();
					if (isSelected()) {
						isShowMoreTime = true;
					} else {
						isShowMoreTime = false;
					}
					DVATableRefreshHelper(tabNo,
							getBlankDVATableData(tabNo), getBlankDVATableData(tabNo), getBlankDVATableData(tabNo),
							getDVStartDate(tabNo).getText());
				}
			};
			showMoreTime.setBounds(245, 10, 40, 20);
		}
		return showMoreTime;
	}
	
	protected LabelBase getShowMoreTimeDesc() {
		if (showMoreTimeDesc == null) {
			showMoreTimeDesc = new LabelBase();
			showMoreTimeDesc.setText("Show More Time");
			showMoreTimeDesc.setBounds(275, 10, 100, 20);
		}
		return showMoreTimeDesc;
	}
	
	protected LabelBase getSelectedTimeDesc() {
		if (selectedTimeDesc == null) {
			selectedTimeDesc = new LabelBase();
			selectedTimeDesc.setText("Current Selected  Time:");
			selectedTimeDesc.setBounds(400, 10, 180, 20);
		}
		return selectedTimeDesc;
	}
	
	private TextReadOnly getSelectedTime() {
		if (selectedTime == null) {
			selectedTime = new TextReadOnly();
			selectedTime.setBounds(530, 10, 86, 20);
		}
		return selectedTime;
	}

	private JScrollPane getDVAJScrollPane() {
		if (DVAJScrollPane == null) {
			DVAJScrollPane = new JScrollPane();
			// dynamically set list table
			DVAJScrollPane.setBounds(10, 40, 759, 310);
			DVAJScrollPane.setLayout(new FitLayout());
		}
		return DVAJScrollPane;
	}
	
	private TableList getDVATable(final int tabNo) {
		if (DVATable[tabNo] == null) {
			DVATable[tabNo] = new TableList(getDVATableColumnNames(tabNo), getDVATableColumnWidths(tabNo), getDVATableColumnCellRenderers(tabNo)){
				public boolean isNotShowMenu() {
					return true;
				}
			};
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
						String selectedTime = DVATable[tabNo].getRowContent(row)[0];
						setSelectedRoom(getCol2Room(tabNo,col));
						getSelectedTime().setText(selectedTime);
						if (col == 0) {
							be.cancelBubble();
							be.setCancelled(true);
							DVATable[tabNo].getView().getCell(prevSelectedRow, prevSelectedColumn)
							.removeClassName("ot-cell-bkgcolorSelected");
							prevSelectedRow = 0;
							prevSelectedColumn = 0;
						} else {
							if(DVATable[tabNo].getView().getCell(prevSelectedRow, prevSelectedColumn).getClassName() != null ){
								if (DVATable[tabNo].getView().getCell(prevSelectedRow, prevSelectedColumn).getClassName().indexOf("ot-cell-bkgcolorSelected") > -1) {
									DVATable[tabNo].getView().getCell(prevSelectedRow, prevSelectedColumn)
									.removeClassName("ot-cell-bkgcolorSelected");
								}
							}
							DVATable[tabNo].getView().getCell(row, col)
							.addClassName("ot-cell-bkgcolorSelected");
							
							prevSelectedRow = row;
							prevSelectedColumn = col;
							
							setGrdAppBseViewRefresh(tabNo, row, col);
						}
					}
				}
			});
			
			DVATable[tabNo].addListener(Events.DoubleClick, new Listener<GridEvent<TableData>>() {
				@Override
				public void handleEvent(GridEvent<TableData> be) {
					if (be.getGrid().isViewReady()) {
						int col= be.getColIndex();
						int row = be.getRowIndex();
						String selectedTime = DVATable[tabNo].getRowContent(row)[0];
						getSelectedTime().setText(selectedTime);
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

	// DEPT Tab
	private JScrollPane getDVBJScrollPane() {
		if (DVBJScrollPane == null) {
			DVBJScrollPane = new JScrollPane();
			DVBJScrollPane.setViewportView(getDVBTable(0));
			DVBJScrollPane.setBounds(10, 360, 759, 75);
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
					"",
					"",
					"Pat Type",
					"App. Date/Time",
					"Bed",//5
					"End Date/Time",
					"Referring Doctor",
					"Reporting Doctor",
					" ",
					"Pat No",
					"",
					"",
					"Name",				
					"Age",
					"Procedure",
					"Status-code",
					"Room",
					"Rmk",
					"Tel",
					"Create User",
					"Create Date",
					"Modify User",
					"Modify Date",
					"Status"
					
				};
	}

	private int[] getDVBTableColumnWidths() {
		return new int[] {
							0, 0, 0,100,40, 
							50, 100,80, 0,60, 0, 
							0, 120,40, 150,
							0, 0, 150, 80,80,
							80,80,80,50 
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
				null,
				null,
				null,
				null
		};
	}
	
	// Sleep Tab
	private BasePanel getDVPanel2() {
		if (DVPanel2 == null) {
			DVPanel2 = new BasePanel();
			DVPanel2.setLocation(5, 5);
			DVPanel2.setSize(790,480);
			DVPanel2.add(getDVStartDateDesc2(), null);
			DVPanel2.add(getPrevDate2(), null);
			DVPanel2.add(getDVStartDate2(), null);
			DVPanel2.add(getNextDate2(), null);
			DVPanel2.add(getShowMoreTime2Desc(), null);
			DVPanel2.add(getShowMoreTime2(), null);
			DVPanel2.add(getDVAJScrollPane2(), null);
			DVPanel2.add(getDVBJScrollPane2(), null);
		}
		return DVPanel2;
	}
	
	private ButtonBase getPrevDate2() {
		if (PrevDate2 == null) {
			PrevDate2 = new ButtonBase() {
				@Override
				public void onClick() {
					if (!getDVStartDate2().isEmpty() && getDVStartDate2().isValid()) {

						Date PrevDate = null;
						try {
							PrevDate = DateTimeUtil.parseDate(getDVStartDate2().getText());
							CalendarUtil.addDaysToDate(PrevDate, -1);
							getDVStartDate2().setText(DateTimeUtil.formatDate(PrevDate));
							onDVStartDateChange(1);
						} catch (Exception e) {
							Factory.getInstance().addErrorMessage("Invalid Date.", getDVStartDate2());
						}
					} else {
						Factory.getInstance().addErrorMessage("Invalid Date.", getDVStartDate2());
					}
				}
			};
			PrevDate2.setText("<<");
			PrevDate2.setBounds(65, 10, 30, 20);
		}
		return PrevDate2;
	}
	
	private ButtonBase getNextDate2() {
		if (NextDate2 == null) {
			NextDate2 = new ButtonBase() {
				@Override
				public void onClick() {
					if (!getDVStartDate2().isEmpty() && getDVStartDate2().isValid()) {

						Date nextDate = null;
						try {
							nextDate = DateTimeUtil.parseDate(getDVStartDate2().getText());
							CalendarUtil.addDaysToDate(nextDate, 1);
							getDVStartDate2().setText(DateTimeUtil.formatDate(nextDate));
							onDVStartDateChange(1);
						} catch (Exception e) {
							Factory.getInstance().addErrorMessage("Invalid Date.", getDVStartDate2());
						}
					} else {
						Factory.getInstance().addErrorMessage("Invalid Date.", getDVStartDate2());
					}
				}
			};
			NextDate2.setText(">>");
			NextDate2.setBounds(215, 10, 30, 20);
		}
		return NextDate2;
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
	
	protected CheckBoxBase getShowMoreTime2() {
		if (showMoreTime2 == null) {
			showMoreTime2 = new CheckBoxBase(){
				@Override
				public void onClick() {
					super.onClick();
					int tabNo = getTabbedPane().getSelectedIndex();
					if (isSelected()) {
						isShowMoreTime2 = true;
					} else {
						isShowMoreTime2 = false;
					}
					DVATableRefreshHelper(tabNo,
							getBlankDVATableData(tabNo), getBlankDVATableData(tabNo), getBlankDVATableData(tabNo),
							getDVStartDate(tabNo).getText());
				}
			};
			showMoreTime2.setBounds(245, 10, 40, 20);
		}
		return showMoreTime2;
	}
	
	protected LabelBase getShowMoreTime2Desc() {
		if (showMoreTime2Desc == null) {
			showMoreTime2Desc = new LabelBase();
			showMoreTime2Desc.setText("Show More Time");
			showMoreTime2Desc.setBounds(275, 10, 100, 20);
		}
		return showMoreTime2Desc;
	}
	

	private JScrollPane getDVAJScrollPane2() {
		if (DVAJScrollPane2 == null) {
			DVAJScrollPane2 = new JScrollPane();
			// dynamically set list table
			DVAJScrollPane2.setBounds(10, 40, 759, 320);
			DVAJScrollPane2.setLayout(new FitLayout());
		}
		return DVAJScrollPane2;
	}

	private JScrollPane getDVBJScrollPane2() {
		if (DVBJScrollPane2 == null) {
			DVBJScrollPane2 = new JScrollPane();
			DVBJScrollPane2.setViewportView(getDVBTable(1));
			DVBJScrollPane2.setBounds(10, 290, 759, 150);
		}
		return DVBJScrollPane2;
	}
}