package com.hkah.client.tx.schedule;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.event.BaseEvent;
import com.extjs.gxt.ui.client.event.DatePickerEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.GridEvent;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MenuEvent;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.event.SelectionListener;
import com.extjs.gxt.ui.client.store.ListStore;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.MessageBox;
import com.extjs.gxt.ui.client.widget.grid.ColumnData;
import com.extjs.gxt.ui.client.widget.grid.Grid;
import com.extjs.gxt.ui.client.widget.grid.GridView;
import com.extjs.gxt.ui.client.widget.layout.FitLayout;
import com.extjs.gxt.ui.client.widget.menu.Menu;
import com.google.gwt.dom.client.Element;
import com.google.gwt.user.datepicker.client.CalendarUtil;
import com.hkah.client.Resources;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.combobox.ComboDoctorLocation;
import com.hkah.client.layout.dialog.DialogBase;
import com.hkah.client.layout.dialog.DlgAddSch;
import com.hkah.client.layout.dialog.DlgLabelPrint;
import com.hkah.client.layout.dialog.DlgPrintAppList;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.label.LabelSmallBase;
import com.hkah.client.layout.menu.MenuItemBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.GeneralGridCellRenderer;
import com.hkah.client.layout.table.MultiCellSelectionModel;
import com.hkah.client.layout.table.TableData;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextDoctorSearch;
import com.hkah.client.layout.textfield.TextNum;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.layout.textfield.TextPhone;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.tx.registration.PatientOut;
import com.hkah.client.tx.registration.PatientWalkIn;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class AppointmentBrowseByRoom extends MasterPanel {

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;
	private static final int DVATableWidth = 490;

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return null;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return "Room Allocation";
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

	private BasePanel DVPanel = null;
	private LabelBase DVStartDateDesc = null;
	private TextDate DVStartDate = null;

	private LabelBase fromDateDesc = null;
	private TextDate fromDate = null;
	private LabelBase toDateDesc = null;
	private TextDate toDate = null;

	private LabelBase selectedTimeDesc = null;
	private TextReadOnly selectedTime = null;
	private LabelBase drCodeDesc = null;
	private TextDoctorSearch drCode = null;

	private boolean isChangeBooking = false;
	private String memRLockID = null;

	private LabelBase showMoreTimeDesc = null;
	private CheckBoxBase showMoreTime = null;
	private ButtonBase NextDate = null;
	private ButtonBase PrevDate = null;
	private ButtonBase appBrowseAction = null;
	private ButtonBase walkInAction = null;
	private ButtonBase docAppAction = null;
	private ButtonBase changeAppDetailAction = null;
	private ButtonBase addSchAction = null;


	private TableList DVATable = null;
	private JScrollPane DVAJScrollPane = null;
	private TableList DVBTable = null;
	private JScrollPane DVBJScrollPane = null;
	private TableList ScheduleTable = null;
	private JScrollPane ScheduleJScrollPane = null;
	private BasePanel SchedulePanel = null;

	private TableList tslotListTable = null;
	private int tslotLastScrollTop = 0;

	private BasePanel rightBtmPanel = null;
	private LabelSmallBase patientNoDesc = null;
	private TextPatientNoSearch patientNo = null;
	private LabelSmallBase namesDesc = null;
	private TextString names = null;
	private LabelSmallBase sex = null;
	private LabelSmallBase phoneHDesc = null;
	private TextPhone phoneH = null;
	private LabelSmallBase phoneMDesc = null;
	private TextPhone phoneM = null;
	private LabelSmallBase sessionDesc = null;
	private TextNum session = null;
	private LabelSmallBase remarkDesc = null;
	private TextString remark = null;
	private LabelSmallBase locationDesc = null;
	private ComboBoxBase location = null;
	private LabelSmallBase durationDesc = null;
	private TextReadOnly duration = null;
	private LabelSmallBase minsDesc = null;
	private LabelSmallBase ofAptMadeDesc = null;
	private TextReadOnly ofAptMade = null;
	private LabelSmallBase doctorDesc = null;
	private TextReadOnly doctor;
	private LabelSmallBase timedesc = null;
	private TextReadOnly time = null;
	private LabelBase Closed = null;
	private LabelBase WalkIn = null;
	private LabelBase Appointment = null;


	private LabelSmallBase onlyBlockedDesc = null;
	private CheckBoxBase onlyBlocked = null;
	private LabelSmallBase includeBlockedDesc = null;
	private CheckBoxBase includeBlocked = null;
	private CheckBoxBase sortByTime = null;

	private DlgAddSch schDialog = null;


	private String memDoctorCode = null;
	private String memSlotSearchTime = null;
	private String memDoctorName = null;

	private int prevSelectedRow =  0;
	private int prevSelectedColumn = 0;


	private Map<String, Integer> roomId2Col = new HashMap<String, Integer>();
	private Map<Integer, String> col2Room = new HashMap<Integer, String>();
	private String memCurrDT = null;
	private String firstLoadDate = null;
	private int memCurrSelectedCellColID = 0;
	private int memCurrSelectedCellRowNo = 0;
	private int missedCol = 0;
	private int maxCol = 0;

/*	private int missedCol = getRtnSlotRowNo(getSysParameter("DENSTIME"),getSysParameter("DENSTIME"), null)[0];
	private int maxCol = getRtnSlotRowNo(getSysParameter("DENETIME"),getSysParameter("DENETIME"), null)[1];*/

	private Map<String, List<String>> RowColID_Col = new LinkedHashMap<String, List<String>>();
	private String[] bkgColorTemplate = new String[] {
			"ot-cell-bkgcolor1", "ot-cell-bkgcolor2", "ot-cell-bkgcolor3",
			"ot-cell-bkgcolor4", "ot-cell-bkgcolor5", "ot-cell-bkgcolor6",
			"ot-cell-bkgcolor7", "ot-cell-bkgcolor8", "ot-cell-bkgcolor9",
			"ot-cell-bkgcolor3confirmed", "ot-cell-bkgcolor2confirmed",
			"ot-cell-bkgcolorBlock",".ot-cell-bkgcolorWhite","ot-cell-bkgcolor10"
	};
	private int bkgColorTemplateUsed = 0;
	private String[] DVATableColumnNames = null;
	private int[] DVATableColumnWidths = null;
	private GeneralGridCellRenderer[] DVATableColumnCellRenderers = null;   // dynamic
	private MultiCellSelectionModel<TableData> cellSelectionModel = null;

	private final int SchCol_AID = 0;
	private final int SchCol_ASTS = 1;
	private final int SchCol_ASDATE = 2;
	private final int SchCol_AEDATE = 3;
	private final int SchCol_DOCCODE = 4;
	private final int SchCol_BKGPNAME = 5;
	private final int SchCol_6 = 6;
	private final int SchCol_PATNO = 7;
	private final int SchCol_DOCNAME = 8;
	private final int SchCol_9 = 9;
	private final int SchCol_10 = 10;
	private final int SchCol_APPFROM = 11;
	private final int SchCol_REMARK = 12;
	private final int SchCol_SLOTID = 13;
	private final int SchCol_SCHID = 14;
	private final int SchCol_RMID = 15;

	private final int GrdPb_bkgid = 0;
	private final int GrdPb_timeFrom = 3;
	private final int GrdPb_timeTo = 4;
	private final int GrdPb_docCode = 5;
	private final int GrdPb_docFName = 6;
	private final int GrdPb_docGName = 7;
	private final int GrdPb_schlen = 19;
	private final int GrdPb_status = 11;


	private final int DVBCol_ALERT = 0;
	private final int DVBCol_SCHID = 1;
	private final int DVBCol_SLTID = 2;
	private final int DVBCol_BKGID = 3;
	private final int DVBCol_APPSDATE = 4;
	private final int DVBCol_APPEDATE = 5;
	private final int DVBCol_DOCTOR = 6;
	private final int DVBCol_PATNO = 7;
	private final int DVBCol_PATNAME = 8;
	private final int DVBCol_STATUSCODE = 9;
	private final int DVBCol_BKGMTEL = 10;
	private final int DVBCol_ROOM = 11;
	private final int DVBCol_REMARK = 12;
	private final int DVBCol_CREATEDATE = 13;
	private final int DVBCol_U1USER = 14;
	private final int DVBCol_ADATE = 15;
	private final int DVBCol_U2USER = 16;
	private final int DVBCol_LOCID = 17;
	private final int DVBCol_DOCCODE = 18;
	private final int DVBCol_BKGPTEL = 19;

	private final int DocSchCol_SCHID = 0;
	private final int DocSchCol_DOCLOCID = 1;
	private final int DocSchCol_WEEKDAY = 2;
	private final int DocSchCol_SCHSDATE = 3;
	private final int DocSchCol_SCHETIME = 4;
	private final int DocSchCol_DOCCODE = 5;
	private final int DocSchCol_DOCFNAME = 6;
	private final int DocSchCol_DOCGNAME = 7;
	private final int DocSchCol_PERCENT = 8;
	private final int DocSchCol_ODDEVEN = 9;
	private final int DocSchCol_DOCPRACTICE = 10;
	private final int DocSchCol_SCHSTS = 11;
	private final int DocSchCol_USRNAME = 12;
	private final int DocSchCol_13 = 13;
	private final int DocSchCol_14 = 14;
	private final int DocSchCol_15 = 15;
	private final int DocSchCol_16 = 16;
	private final int DocSchCol_17 = 17;
	private final int DocSchCol_18 = 18;
	private final int DocSchCol_SCHLEN = 19;
	private final int DocSchCol_SCHCNT = 20;
	private final int DocSchCol_SCHEDATE = 21;
	private final int DocSchCol_SPCCODE = 22;

	private String isPHorSat = null;


	private String selectedRoom = null;

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;

	/**
	 * This method initializes
	 *
	 */
	public AppointmentBrowseByRoom() {
		super();
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
		firstLoadDate = null;

		memCurrDT = getMainFrame().getServerDate();
		missedCol = getRtnSlotRowNo(getSysParameter("RMSTIME"),getSysParameter("RMSTIME"), null)[0];
		maxCol = getRtnSlotRowNo(getSysParameter("RMETIME"),getSysParameter("RMETIME"), null)[1];
		getLocation().setText("G");
		getDVBTable().setColumnColor(DVBCol_REMARK, "red");
		initDateField();
		initDVATableColumns();

		isChangeBooking = false;
		memRLockID = null;


		resetParameter("START_TYPE");

		enableButton();
	}

	@Override
	public void rePostAction() {
		refreshAction();
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextDate getDefaultFocusComponent() {
		return getDVStartDate();
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

		};
	}

	/* >>> ~15~ Set Fetch Output Results ============================== <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {}

	/* >>> ~16~ Set Fetch Input Parameters ================================ <<< */

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {
		enableButton();
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

	@Override
	public void cancelAction() {
		isChangeBooking = false;
		getDrCode().resetText();
		getDVATable().setEnabled(true);
		refreshAction();
	}

	/***************************************************************************
	* Override Method
	**************************************************************************/

	@Override
	protected void proExitPanel() {

	}

	@Override
	protected void enableButton() {
		disableButton();
		//getPrintButton().setEnabled(false);
		if (isChangeBooking) {
			getCancelButton().setEnabled(true);
		}
		getSearchButton().setEnabled(true);
		getRefreshButton().setEnabled(true);
		getSaveButton().setEnabled(false);

		controlAppButtons();
	}

	@Override
	public void searchAction() {
		DVATableRefresh(true);
		searchScheduleAction(getFromDate().getText(),getToDate().getText());
	}

	@Override
	public void refreshAction() {
		DVATableRefresh(true);
		searchScheduleAction(getFromDate().getText(),getToDate().getText());
	}

	protected void searchScheduleAction(String SDate,String EDate){
		if (searchScheduleValidation()){
			/*getScheduleTable().setListTableContent("APPBWSERM",
					new String[] {
					SDate,
					EDate,
					getDrCode().getText(),
					"",
					getOnlyBlocked().isSelected()?YES_VALUE:NO_VALUE,
					getIncludeBlocked().isSelected()?"B":NO_VALUE,
					getSortByTime().isSelected()?YES_VALUE:NO_VALUE,Factory.getInstance().getUserInfo().getUserID()
					});*/
		}
	}

	protected boolean searchScheduleValidation(){
		if (getDVStartDate().isEmpty() || !getDVStartDate().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid Date.", "PBA - [Rehab App]", null, getDVStartDate());
			return false;
		}  else {
			return true;
		}
	}


	@Override
	protected void performListPost() {
		// for child class call
		enableButton();
	}





	/***************************************************************************
	* Helper Method
	**************************************************************************/

	private AppointmentBrowseByRoom getThis() {
		return this;
	}

	private void initDateField() {
		getDVStartDate().setText(memCurrDT);
		getFromDate().setText(memCurrDT);
		getToDate().setText(memCurrDT);
	}

	private void resetVariable(){
		getSelectedTime().setText("");
		setSelectedRoom("");
	}

	private void controlAppButtons() {
		disableAllAppButtons();
		if (getDVBTable().getRowCount() > 0 && getDVBTable().getSelectedRow() >= 0) {
			int compare = DateTimeUtil.compareTo(getMainFrame().getServerDate(),
					getDate(getDVBTable().getSelectedCellContent(DVBCol_APPSDATE).toString(), 10));
			boolean normalStatus = ConstantsVariable.NO_VALUE.equals(getDVBTable().getSelectedCellContent(DVBCol_STATUSCODE));



			getWalkInAction().setEnabled(!isDisableFunction("btnWalkIn", "schAppoint"));
			getAppBrowseAction().setEnabled(!isDisableFunction("btnBrowse", "schAppoint"));
			getDocAppAction().setEnabled(!isDisableFunction("mnuAppoint"));



		} else {
			getDocAppAction().setEnabled(!isDisableFunction("mnuAppoint"));

		}

		if (!isDisableFunction("btnDeptAppDisable", "reg") &&
				!Factory.getInstance().getUserInfo().getSiteCode().equals(Factory.getInstance().getUserInfo().getUserID())) {
			disableAllAppButtons();
		}
	}


	private void disableAllAppButtons() {
	}

	private Map<String, List<String>> getRowColID_Col() {
			return RowColID_Col;
	}

	private String getCol2Room(int colID) {
			return col2Room.get(colID);
	}

	private int getRoomId2Col(String roomID) {
		if( roomId2Col.get(roomID) != null){
			return roomId2Col.get(roomID);
		} else {
			return -1;
		}
	}

	private void setRoomID2Col(String roomID, int column) {
			roomId2Col.put(roomID, column);
			col2Room.put(column, roomID);
	}

	public void setSelectedRoom(String selectedRoom) {
		this.selectedRoom = selectedRoom;
	}

	public String getSelectedRoom() {
		return selectedRoom;
	}

	private int addMissCols(){
		//int missCols = 0;

		return missedCol;
	}

	private void setGrdAppBseViewRefresh(int rowNo, int colNo) {
		List<String> tempDeptAID = getRowColID_Col().get(String.valueOf(rowNo + addMissCols()) + "-" + String.valueOf(colNo));
		
		int DeptAID_Count = -1;
		int i = -1;
		StringBuffer DeptAID_sql = new StringBuffer();
		StringBuffer RID_sql = new StringBuffer();
		memCurrSelectedCellColID = colNo;
		memCurrSelectedCellRowNo = rowNo;

		if (tempDeptAID == null) {
			DeptAID_sql.append(" and 1=2 ");
			RID_sql.append("  1=2");
		} else {
			DeptAID_Count = tempDeptAID.size();

			i = 0;
			String[] value = TextUtil.split(tempDeptAID.get(i)); //0 =aid 1=from
/*			if ("R".equals(value[1])) {
				RID_sql.append(" R.REGID in (");
				RID_sql.append("'");
				RID_sql.append(value[0]);
				RID_sql.append("'");
			} else {
				DeptAID_sql.append(" and B.BKGID in (");
				DeptAID_sql.append("'");
				DeptAID_sql.append(value[0]);
				DeptAID_sql.append("'");
			}*/


			for (i = 0; i <= DeptAID_Count - 1; i++) {
				value = TextUtil.split(tempDeptAID.get(i)); //0 =aid 1=from		
					if ("R".equals(value[1])) {
						if (RID_sql.length() == 0) {
							RID_sql.append(" R.REGID in (");
							RID_sql.append("'");
							RID_sql.append(value[0]);
							RID_sql.append("'");
						} else {
							RID_sql.append(", '");
							RID_sql.append(value[0]);
							RID_sql.append("'");						
						}							
					} else {
						if (DeptAID_sql.length() == 0) {
							DeptAID_sql.append(" and B.BKGID in (");
							DeptAID_sql.append("'");
							DeptAID_sql.append(value[0]);
							DeptAID_sql.append("'");
						} else {
							DeptAID_sql.append(", '");
							DeptAID_sql.append(value[0]);
							DeptAID_sql.append("'");
						}
					}
			}

/*			if ("R".equals(value[1])) {
				RID_sql.append(") ");
			} else {
				DeptAID_sql.append(") ");

			}*/
			
			if(RID_sql.length() == 0){
				RID_sql.append("  1=2");
			} else {
				RID_sql.append(") ");
			}
			if(DeptAID_sql.length() == 0) {
				DeptAID_sql.append(" and 1=2 ");
			} else {
				DeptAID_sql.append(") ");
			}
		}

		getDVBTable().setListTableContent("APPRMDVBTABLELIST", new String[] {DeptAID_sql.toString(),RID_sql.toString(), Factory.getInstance().getUserInfo().getUserID()});

	}

	private void DVATableRefresh(boolean skipcheck) {
			if (firstLoadDate == null || !getDVStartDate().getText().equals(firstLoadDate) || skipcheck) {
				firstLoadDate = getDVStartDate().getText();

				DVATableRefreshHelper(getBlankDVATableData(), getBlankDVATableData(), getBlankDVATableData(),
						getDVStartDate().getText());
			}
	}

	private void DVATableRefreshHelper(final List<TableData> tempTextData, final List<TableData> tempTxtColorData, final List<TableData> tempBkgColorData,
			final String dvStartDate) {
		Factory.getInstance().showMask();
		getMainFrame().setLoading(true);
		getDVBTable().removeAllRow();
		getDVATable().removeAllRow();
		getDVATable().getStore().removeAll();
		getDVATable().getStore().add(getBlankDVATableData());
		getDVATable().getView().refresh(true);
		getDVATable().getView().layout();
		getRowColID_Col().clear();

		final String listTxCode = null;
		final String[] listTxParam = null;
		QueryUtil.executeMasterBrowse(getUserInfo(), "APPBWSERM",
				new String[] {
			dvStartDate,
			dvStartDate,
			null,
			getLocation().getText(),"","N","",Factory.getInstance().getUserInfo().getUserID()
			},
		new MessageQueueCallBack() {
		@Override
		public void onPostSuccess(MessageQueue mQueue) {
		if (mQueue.success()) {

				String[] recordT = TextUtil.split(mQueue.getContentAsQueue(), TextUtil.LINE_DELIMITER);
				String[] fieldsT = null;
				Object[] rowT = null;
				int colnoT = -1;
				int[] slotRowT = null;
				int S_SlotRowNoT = -1;
				int E_SlotRowNoT = -1;
				for (int i = 0; i < recordT.length; i++) {
					fieldsT = TextUtil.split(recordT[i]);
					rowT = new Object[fieldsT.length];
					if (!TextUtil.FIELD_DELIMITER.equals(recordT[i])) {
//		                  addRow(fields);
						for (int n = 0; n < fieldsT.length; n++) {
							if (fieldsT[n] == null) {
								rowT[n] = "";
							} else {
								rowT[n] = fieldsT[n];//split record
							}
						}
							colnoT = getRoomId2Col((String) rowT[DocSchCol_DOCLOCID]); //assign column
							if (colnoT > -1) {
								slotRowT = getRtnSlotRowNo(String.valueOf(rowT[DocSchCol_SCHSDATE]), String.valueOf(rowT[DocSchCol_SCHEDATE]), dvStartDate);
								S_SlotRowNoT = slotRowT[0];
								E_SlotRowNoT = slotRowT[1];
								if (!"B".equals(String.valueOf(rowT[DocSchCol_SCHSTS]))) {
									tempTextData.get(S_SlotRowNoT).setValue(colnoT, "["+rowT[DocSchCol_DOCCODE]+"]<br>"
										+rowT[DocSchCol_DOCFNAME]+"<br>"
										+"(<span style=\"color: blue\">"+rowT[DocSchCol_SPCCODE]+"</span>)<br>"
										);
								}
								if (S_SlotRowNoT == E_SlotRowNoT) {
									setBackgroundColor(tempBkgColorData, S_SlotRowNoT, colnoT, String.valueOf(rowT[DocSchCol_ODDEVEN]),null,
											String.valueOf(rowT[DocSchCol_ODDEVEN]),false,true);

								} else {
									for (int k = S_SlotRowNoT; k <= E_SlotRowNoT; k++) {
										setBackgroundColor(tempBkgColorData, k, colnoT, String.valueOf(rowT[DocSchCol_ODDEVEN]),null,
												String.valueOf(rowT[DocSchCol_SCHSTS]),false,true);
									}
								}
							}

					}
				}
				QueryUtil.executeMasterBrowse(getUserInfo(), "APPRMDVATABLELIST", new String[] {dvStartDate, getLocation().getText()},
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
								boolean isMulti = false;
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
												row[n] = fields[n];//split record
											}
										}
										colno = getRoomId2Col((String) row[SchCol_RMID]); //assign column
										if (colno > -1) {
											slotRow = getRtnSlotRowNo(String.valueOf(row[SchCol_ASDATE]), String.valueOf(row[SchCol_AEDATE]), dvStartDate);
											S_SlotRowNo = slotRow[0];
											E_SlotRowNo = slotRow[1];

											String appointSts = String.valueOf(row[SchCol_ASTS]);
											String content = "";
											if ("B".equals(appointSts)){
												content = "(BLOCKED)";
											} else {
												content = (("".equals(row[SchCol_PATNO])|| row[SchCol_PATNO] == null)?row[SchCol_BKGPNAME]:row[SchCol_PATNO]) + ";";
											}
											
											if("W".equals(row[SchCol_REMARK])) {
												appointSts = "W";
											}


											if (S_SlotRowNo == E_SlotRowNo) {
												temp.setLength(0);
												temp.append((String) tempTextData.get(S_SlotRowNo).getValue(colno));
												String con = (String) tempTextData.get(S_SlotRowNo).getValue(colno)+content;
												if (temp.length() > 0) { //append content if there exist content in cell
													temp.setLength(0);
													temp.append(getUpdatedContent(con));
													isMulti = true;
												} else {
													temp.append(content);
													isMulti = false;
												}
												tempTextData.get(S_SlotRowNo).setValue(colno, temp.toString());
												//setCellColor(tempTxtColorData, S_SlotRowNo, colno, row[1].toString());
												setBackgroundColor(tempBkgColorData, S_SlotRowNo, colno, null,appointSts,isPHorSat,isMulti,false);
												setAddDeptAID(S_SlotRowNo, colno, row[SchCol_AID].toString()+TextUtil.FIELD_DELIMITER+row[SchCol_APPFROM].toString());
											} else {

												for (int k = S_SlotRowNo; k <= E_SlotRowNo; k++) {
													if (tempTextData.get(k).getSize() >= colno) { 
														temp.setLength(0);
														temp.append((String) tempTextData.get(k).getValue(colno));
														String con = null;
														if (tempTextData.get(S_SlotRowNo).getValue(colno).toString().indexOf(content) < 0) { //if start cell <>  content
															con = (String) tempTextData.get(S_SlotRowNo).getValue(colno)+content; //start cell+content
														} else {
															con = (String) tempTextData.get(S_SlotRowNo).getValue(colno); //content = start cell
														}
														if (temp.toString().length() > 0) { //append content if there exist content in cell
															temp.setLength(0);
															temp.append(getUpdatedContent(con));
															isMulti = true;
														} else {
															temp.append(content);
															isMulti = false;
														}
														tempTextData.get(k).setValue(colno, temp.toString());
	
													//setCellColor(tempTxtColorData, k, colno, row[1].toString());
													setBackgroundColor(tempBkgColorData, k, colno, null,appointSts,isPHorSat,isMulti,false);
													setAddDeptAID(k, colno, row[SchCol_AID].toString()+TextUtil.FIELD_DELIMITER+row[SchCol_APPFROM].toString());
												}
											}
											}
										}
									}
								}
												if (record.length > 0) {
									setTextColor(tempTextData, tempTxtColorData);
									removeWordings(tempTextData, tempBkgColorData);
									getDVATable().getStore().removeAll();
									getDVATable().getStore().add(tempTextData);
									setBackgroundColorToView(tempBkgColorData);
								}

						} else if (!"".equals(isPHorSat) && isPHorSat != null) {
							getDVATable().getView().getCell(35, 1).setInnerText(isPHorSat);
						}
						removeWordings(tempTextData, tempBkgColorData);
						getDVATable().getStore().removeAll();
						getDVATable().getStore().add(tempTextData);
						setBackgroundColorToView(tempBkgColorData);
						getDVATable().getView().layout();

						if (memCurrSelectedCellColID > 0 && memCurrSelectedCellRowNo > 0) {
							GridEvent gridEvent = new GridEvent(getDVATable());
						    gridEvent.setRowIndex(memCurrSelectedCellRowNo);
						    gridEvent.setColIndex(memCurrSelectedCellColID);
							getDVATable().fireEvent(Events.CellClick,gridEvent);
						}
						getMainFrame().setLoading(false);
						Factory.getInstance().hideMask();
						removeRows(getDVATable().getStore());
					}
				});
	} else {
		setBackgroundColorToView(tempBkgColorData);
		getDVATable().getView().layout();
		getMainFrame().setLoading(false);
		Factory.getInstance().hideMask();
	}
	}});
	}
	
	private String getUpdatedContent(String con) {
		String docCode = "";
		String t = con.replaceAll(";", "");
		if (t.indexOf("bookings") > -1){  
			t = TextUtil.split(t, "bookings:")[1]; 
			con = TextUtil.split(con, "bookings:")[1];
		}
		int occ = (con.length() - t.length());
		
		if (con.indexOf(")") > -1){
			docCode = TextUtil.split(t, ")")[0]+")<br>";
			if (occ > 1) {
				//return docCode + Integer.toString(occ)+" bookings"+":"+TextUtil.split(con, ")")[1];
				return docCode + Integer.toString(occ)+" bookings"+":"+TextUtil.split(con, ")<br>")[1];
			} else {
				return con;
			}
		} else {
			if (occ > 1) {
				return Integer.toString(occ)+" bookings"+":"+con;
			} else {
				return con;
			}
		}
		
	}

	private int[] getRtnSlotRowNo(String appSTime, String appETime, String dCurDate) {

		int SlotNo1 = DateTimeUtil.timeDiff(DEFAULT_HOURS, appSTime.substring(11, 16)) / Integer.parseInt(getSysParameter("RMTUNIT"));
		int SlotNo2 = DateTimeUtil.timeDiff(DEFAULT_HOURS, appETime.substring(11, 16)) / Integer.parseInt(getSysParameter("RMTUNIT"));
		int S_SlotRowNo = SlotNo1;
		int E_SlotRowNo = SlotNo2;
//		int SlotTotal = 96;

//		if (dCurDate != null && !"".equals(dCurDate)) { //cross day handling
//			if (DateTimeUtil.dateDiff(appSTime.substring(0, 10), appETime.substring(0, 10)) != 0) {
//				if (DateTimeUtil.toDate(dCurDate, DEFAULT_HOURS_FORMAT).equals(DateTimeUtil.toDate(appSTime.substring(0, 10), DEFAULT_HOURS_FORMAT))) {
//					E_SlotRowNo = SlotTotal - 1;
//				} else if (DateTimeUtil.toDate(dCurDate, DEFAULT_HOURS_FORMAT).equals(DateTimeUtil.toDate(appETime.substring(0, 10), DEFAULT_HOURS_FORMAT))) {
//					S_SlotRowNo = 0;
//				} else {
//					S_SlotRowNo = 0;
//					E_SlotRowNo = SlotTotal - 1;
//				}
//			}
//		}
		return new int[] {S_SlotRowNo, E_SlotRowNo};
	}

	private void setAddDeptAID(int rowNo, int colNo, String deptaID) {
		List<String> SlotDeptAID_COL  = getRowColID_Col().get(String.valueOf(rowNo) + "-" + String.valueOf(colNo));
		if (SlotDeptAID_COL == null) {
			SlotDeptAID_COL = new ArrayList<String>();
			SlotDeptAID_COL.add(deptaID);
			getRowColID_Col().put(String.valueOf(rowNo) + "-" + String.valueOf(colNo), SlotDeptAID_COL);
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

	private void setBackgroundColor(List<TableData> bkgColorData, int rowNo, int colNo, String oddEven, String appSts, String isClosed,
			boolean isMultiBooking,boolean isSchedule) {
		String bgcolor = bkgColorTemplate[2]; //purple


		if("F".equals(appSts)) {
			bgcolor = bkgColorTemplate[9]; //grey purple
		} else if ("B".equals(appSts)) {
			bgcolor = bkgColorTemplate[11]; //red
		} else if ("W".equals(appSts)){
			bgcolor = bkgColorTemplate[10]; //deep purple
		}

		if (isSchedule) {
			if("1".equals(oddEven)){
				bgcolor = bkgColorTemplate[0]; //green
			} else {
				bgcolor = bkgColorTemplate[7]; //blue
			}
		}
		
		if (isClosed != null && "B".equals(isClosed)){
			bgcolor = bkgColorTemplate[13]; //dark grey
		}
		/*if(isMultiBooking) {
			bgcolor = bkgColorTemplate[1]; //pink
		}*/
		if(!bkgColorTemplate[10].equals(bkgColorData.get(rowNo).getValue(colNo)) &&
				(("B".equals(isClosed) && "".equals(bkgColorData.get(rowNo).getValue(colNo)))
						||!"B".equals(isClosed))){		
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

	private void removeRows(ListStore tempData) {
		for (int i = tempData.getCount() -1 ; i >= 0; i--) {
				if((i < missedCol || i > maxCol) && i >= 0){
					tempData.remove(i);
				}
		}
	}

	private void setBackgroundColorToView(List<TableData> bkgColor) {
		Element cell = null;
		for (int i = 0; i < bkgColor.size(); i++) {
			for (int j = 1; j < bkgColor.get(0).getSize(); j++) {
				cell = getDVATable().getView().getCell(i, j);
				if (cell != null) {
/*					if(i < 35 && bkgColor.get(i).getValue(j).toString().isEmpty()){
						cell.addClassName("ot-cell-bkgcolor10");
					}
					if(i > 34 && i < 38  && (!"".equals(isPHorSat) && isPHorSat != null)
							&& bkgColor.get(i).getValue(j).toString().isEmpty()){
						cell.addClassName("ot-cell-bkgcolorBlock");
					}*/
					if (!bkgColor.get(i).getValue(j).toString().isEmpty()) {
						cell.addClassName(bkgColor.get(i).getValue(j).toString());
						cell.addClassName(i+"-"+j);
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

	private List<TableData> getBlankDVATableData() {
		List<TableData> blankDVATableData = new ArrayList<TableData>();
		int timeUnit = Integer.parseInt(getSysParameter("RMTUNIT"));
		double value = ((double) 60) / timeUnit;
/*min by sysparam*/
		for (int i = 0; i < (value*24); i++) {
			String hour;
			String second;
			int h = (int) (i/(value));
			int s = (int) ((i % (value)) * timeUnit);
			if (h != 0) {
				if (h < 10) {
					hour = "0".concat(String.valueOf(h));
				} else {
					hour = String.valueOf(h);
				}
			} else {
				hour = "00";
			}
			if (s < 10) {
				second = "0".concat(String.valueOf(s));
			} else {
				second = String.valueOf(s);
			}

			if (getDVATableColumnNames() != null) {
				int colLen2 = getDVATableColumnNames().length;
				String[] values2 = new String[colLen2];

				if (values2 != null && values2.length > 0) {
					values2[0] = hour.concat(":").concat(second);
				}

				blankDVATableData.add(new TableData(getDVATableColumnNames(), values2));
			}
		}

/*		10min
 * for (int i = 0; i < 144; i++) {
			String hour;
			String second;
			int h = i/6;
			int s = (i % 6) * 10;
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

			if (getDVATableColumnNames() != null) {
				int colLen2 = getDVATableColumnNames().length;
				String[] values2 = new String[colLen2];

				if (values2 != null && values2.length > 0) {
					values2[0] = hour.concat(":").concat(second);
				}

				blankDVATableData.add(new TableData(getDVATableColumnNames(), values2));
			}
		}*/

		return blankDVATableData;
	}

	private void initDVATable() {

		DVATable = null; // reset table to feed dynamic column names and widths
		getDVATable().getStore().removeAll();
		getDVATable().getView().refresh(true);
		getDVATable().getView().setSortingEnabled(false);

		DVATableRefresh(true);
			
		getDVAJScrollPane().removeAll(); // reset scrollPane
		getDVAJScrollPane().setViewportView(getDVATable());
		getDVAJScrollPane().layout();
		getDVPanel().layout();
	}

	private void initDVATableColumns() {
		QueryUtil.executeMasterBrowse(getUserInfo(), "DEPT_ROOM",
				new String[] { "APPRM", getLocation().getText().isEmpty()?"G":getLocation().getText() },
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
					if ("1".equals(getLocation().getText())){
						columnWidths[0] = 80;

					} else {
						columnWidths[0] = 60;
					}
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

						setRoomID2Col((String) row[0], colIdx);
						columnNames[colIdx] = (String) row[1];
						//columnWidths[colIdx] = (DVATableWidth - 270) / record.length;
						columnWidths[colIdx] = 60;
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

					setDVATableColumnNames(columnNames);
					setDVATableColumnWidths(columnWidths);
					setDVATableColumnCellRenderers(columnCellRenderers);
					initDVATable();
					DVATableRefresh(true);
					searchScheduleAction(getFromDate().getText(),getToDate().getText());
				}
			}
		});
	}

	protected String[] getDVATableColumnNames() {
		return DVATableColumnNames;
	}

	protected void setDVATableColumnNames(String[] columnNames) {
		DVATableColumnNames = columnNames;
	}

	protected int[] getDVATableColumnWidths() {
		return DVATableColumnWidths;
	}

	protected void setDVATableColumnWidths(int[] columnWidths) {
		DVATableColumnWidths = columnWidths;
	}

	protected GeneralGridCellRenderer[] getDVATableColumnCellRenderers() {
		return DVATableColumnCellRenderers;
	}

	protected void setDVATableColumnCellRenderers(GeneralGridCellRenderer[] columnCellRenderers) {
		DVATableColumnCellRenderers = columnCellRenderers;
	}

	protected void onDVStartDateChange() {
		DVATableRefresh(false);
		//searchScheduleAction(getDVStartDate().getText(),getDVStartDate().getText());
	}


	private void updateSlotTable() {
		if (getScheduleTable().getRowCount() > 0) {
			getTslotListTable().setListTableContent(ConstantsTx.SLOT_TXCODE, new String[] { getScheduleTable().getSelectedRowContent()[GrdPb_bkgid] });

			if (getTslotListTable().getRowCount() > 0 && getTslotListTable().getSelectedRow() >= 0) {
				getTime().setText(getTslotListTable().getSelectedRowContent()[2]) ;
				getDuration().setText(getScheduleTable().getSelectedRowContent()[GrdPb_schlen]);
				getDoctor().setText(getScheduleTable().getSelectedRowContent()[GrdPb_docCode]);
			} else {
				getTime().setText(EMPTY_VALUE) ;
				getDuration().resetText();
				getOfAptMade().resetText();
				getDoctor().resetText();
				// clean up slot table
				getTslotListTable().removeAllRow();
			}
		}
	}

	private String getDate(String date, int len) {
		return date.substring(0, len);
	}



	/***************************************************************************
	* Layout Method
	**************************************************************************/

	/* >>> getter methods for init the Component start from here================================== <<< */
	@Override
	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.setSize(940, 525);
			leftPanel.add(getDVPanel(), null);
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

/*	private TabbedPaneBase getTabbedPane() {
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
			TabbedPane.addTab("General View", getGVPanel());
			TabbedPane.addListener(Events.Select, new Listener<ComponentEvent>() {
				@Override
				public void handleEvent(ComponentEvent be) {
					enableButton();
				}
			});
		}
		return TabbedPane;
	}*/

	// DEPT Tab
	private BasePanel getDVPanel() {
		if (DVPanel == null) {
			DVPanel = new BasePanel();
			DVPanel.setBounds(5, 5, 930, 520);
			DVPanel.add(getDVStartDateDesc(), null);
			DVPanel.add(getPrevDate(), null);
			DVPanel.add(getDVStartDate(), null);
			DVPanel.add(getNextDate(), null);
			DVPanel.add(getLocationDesc(), null);
			DVPanel.add(getLocation(), null);
			DVPanel.add(getClosed(), null);
			DVPanel.add(getWalkIn(), null);
			DVPanel.add(getAppointment(), null);
			//DVPanel.add(getSelectedTimeDesc(), null);
			//DVPanel.add(getSelectedTime(), null);
			DVPanel.add(getDVAJScrollPane(), null);
			DVPanel.add(getDVBJScrollPane(), null);
			DVPanel.add(getRightBtmPanel(), null);


		}
		return DVPanel;
	}

	private LabelBase getDVStartDateDesc() {
		if (DVStartDateDesc == null) {
			DVStartDateDesc = new LabelBase();
			DVStartDateDesc.setText("Date");
			DVStartDateDesc.setBounds(10, 10, 30, 20);
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
						onDVStartDateChange();
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
						onDVStartDateChange();
					}
					if (!DVStartDate.isEmpty() && !DVStartDate.isValid()) {
						Factory.getInstance().addErrorMessage("Invalid Date.", DVStartDate);
					}
				}
			});
			DVStartDate.setBounds(70, 10, 113, 20);
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
							onDVStartDateChange();
						} catch (Exception e) {
							Factory.getInstance().addErrorMessage("Invalid Date.", getDVStartDate());
						}
					} else {
						Factory.getInstance().addErrorMessage("Invalid Date.", getDVStartDate());
					}
				}
			};
			PrevDate.setText("<<");
			PrevDate.setBounds(40, 10, 30, 20);
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
							onDVStartDateChange();
						} catch (Exception e) {
							Factory.getInstance().addErrorMessage("Invalid Date.", getDVStartDate());
						}
					} else {
						Factory.getInstance().addErrorMessage("Invalid Date.", getDVStartDate());
					}
				}
			};
			NextDate.setText(">>");
			NextDate.setBounds(185, 10, 30, 20);
		}
		return NextDate;
	}

	protected LabelBase getSelectedTimeDesc() {
		if (selectedTimeDesc == null) {
			selectedTimeDesc = new LabelBase();
			selectedTimeDesc.setText("Selected  Time:");
			selectedTimeDesc.setBounds(760, 10, 100, 20);
		}
		return selectedTimeDesc;
	}

	private TextReadOnly getSelectedTime() {
		if (selectedTime == null) {
			selectedTime = new TextReadOnly();
			selectedTime.setBounds(870, 10, 86, 20);
		}
		return selectedTime;
	}

	private LabelBase getFromDateDesc() {
		if (fromDateDesc == null) {
			fromDateDesc = new LabelBase();
			fromDateDesc.setText("From");
			fromDateDesc.setBounds(270, 10, 30, 20);
		}
		return fromDateDesc;
	}

	@SuppressWarnings("unchecked")
	private TextDate getFromDate() {
		if (fromDate == null) {
			fromDate = new TextDate();
			fromDate.getDatePicker().addListener(Events.Select,
					new Listener<DatePickerEvent>() {
				@Override
				public void handleEvent(DatePickerEvent be) {
					if (!fromDate.isEmpty() && !fromDate.isValid()) {
						Factory.getInstance().addErrorMessage("Invalid Date.", fromDate);
					}
				}
			});
			fromDate.addListener(Events.Blur, new Listener() {
				@Override
				public void handleEvent(BaseEvent be) {
					if (!fromDate.isEmpty() && !fromDate.isValid()) {
						Factory.getInstance().addErrorMessage("Invalid Date.", fromDate);
					}
				}
			});
			fromDate.setBounds(300, 10, 113, 20);
		}
		return fromDate;
	}

	private LabelBase getToDateDesc() {
		if (toDateDesc == null) {
			toDateDesc = new LabelBase();
			toDateDesc.setText("To");
			toDateDesc.setBounds(420, 10, 30, 20);
		}
		return toDateDesc;
	}

	@SuppressWarnings("unchecked")
	private TextDate getToDate() {
		if (toDate == null) {
			toDate = new TextDate();
			toDate.getDatePicker().addListener(Events.Select,
					new Listener<DatePickerEvent>() {
				@Override
				public void handleEvent(DatePickerEvent be) {
					if (!toDate.isEmpty() && !toDate.isValid()) {
						Factory.getInstance().addErrorMessage("Invalid Date.", toDate);
					}
				}
			});
			toDate.addListener(Events.Blur, new Listener() {
				@Override
				public void handleEvent(BaseEvent be) {
					if (!toDate.isEmpty() && !toDate.isValid()) {
						Factory.getInstance().addErrorMessage("Invalid Date.", toDate);
					}
				}
			});
			toDate.setBounds(440, 10, 113, 20);
		}
		return toDate;
	}

	private LabelBase getDrCodeDesc() {
		if (drCodeDesc == null) {
			drCodeDesc = new LabelBase();
			drCodeDesc.setText("Dr.");
			drCodeDesc.setBounds(560, 10, 20, 20);
		}
		return drCodeDesc;
	}

	private TextDoctorSearch getDrCode() {
		if (drCode == null) {
			drCode = new TextDoctorSearch() {
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
					searchScheduleAction(getFromDate().getText(),getToDate().getText());
				}
			};
			drCode.setShowClearButton(true);
			drCode.setBounds(580, 10, 80, 20);
		}
		return drCode;
	}

	private JScrollPane getDVAJScrollPane() {
		if (DVAJScrollPane == null) {
			DVAJScrollPane = new JScrollPane();
			// dynamically set list table
			DVAJScrollPane.setBounds(10, 50, 990, 330);
			DVAJScrollPane.setLayout(new FitLayout());
		}
		return DVAJScrollPane;
	}

	private TableList getDVATable() {
		if (DVATable == null) {
			DVATable = new TableList(getDVATableColumnNames(), getDVATableColumnWidths(), getDVATableColumnCellRenderers()){
				public boolean isNotShowMenu() {
					return true;
				}
			};
			DVATable.setTableLength(DVATableWidth);
			DVATable.setBorders(true);
			DVATable.setColumnLines(true);
			DVATable.setStripeRows(false);
			DVATable.setView(new GridView());
			DVATable.setSelectionModel(getCellSelectionModel());
			DVATable.getStore().add(getBlankDVATableData());
			DVATable.addListener(Events.CellClick, new Listener<GridEvent<TableData>>() {
				@Override
				public void handleEvent(GridEvent<TableData> be) {
					if (be.getGrid().isViewReady() && !isChangeBooking) {
						int col= be.getColIndex();
						int row = be.getRowIndex();
						String selectedTime = DVATable.getRowContent(row)[0];
						getSelectedTime().setText(selectedTime);
						if (col == 0) {
							be.cancelBubble();
							be.setCancelled(true);
//							DVATable.getView().getCell(prevSelectedRow, prevSelectedColumn)
//							.removeClassName("ot-cell-bkgcolorSelected");
//							prevSelectedRow = 0;
//							prevSelectedColumn = 0;
						} else {
/*							if(prevSelectedColumn != 0 && DVATable.getView().getCell(prevSelectedRow, prevSelectedColumn) != null ){
								if (DVATable.getView().getBody().dom.toString().indexOf("ot-cell-bkgcolorSelected") > -1) {
									DVATable.getView().getCell(prevSelectedRow, prevSelectedColumn)
									.removeClassName("ot-cell-bkgcolorSelected");
								}
							}
							DVATable.getView().getCell(row, col)
							.addClassName("ot-cell-bkgcolorSelected");

							prevSelectedRow = row;
							prevSelectedColumn = col;*/

							setGrdAppBseViewRefresh(row, col);
							//searchScheduleAction(getDVStartDate().getText()+" "+selectedTime,getDVStartDate().getText()+" 23:59");
						}
					}
				}
			});

			DVATable.addListener(Events.DoubleClick, new Listener<GridEvent<TableData>>() {
				@Override
				public void handleEvent(GridEvent<TableData> be) {
					if (be.getGrid().isViewReady()) {
						int col= be.getColIndex();
						int row = be.getRowIndex();
						String selectedTime = DVATable.getRowContent(row)[0];
/*						getSelectedTime().setText(selectedTime);*/
						if (col == 0) {
							be.cancelBubble();
							be.setCancelled(true);
						} else {
							setGrdAppBseViewRefresh(row, col);
						}
					}
				}
			});
		}
		return DVATable;
	}

	// DEPT Tab
	private JScrollPane getDVBJScrollPane() {
		if (DVBJScrollPane == null) {
			DVBJScrollPane = new JScrollPane();
			DVBJScrollPane.setViewportView(getDVBTable());
			DVBJScrollPane.setBounds(10, 390, 990, 120);
		}
		return DVBJScrollPane;
	}

	private TableList getDVBTable() {
		if (DVBTable == null) {
			DVBTable = new TableList(getDVBTableColumnNames(),
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
			DVBTable.setTableLength(getListWidth());
		}
		return DVBTable;
	}

	private String[] getDVBTableColumnNames() {
		return new String[] {
					"ALERT","SCHID","SLTID","BKGID","Start Date/Time",
					"End Date/Time","Doctor","Pat No","Name","Sts",
					"Mobile","Room","Remark","Create Date","Create User","Modify User",
					"Modify Date","LOCID","DOCCODE","BKGPTEL"

				};
	}

	private int[] getDVBTableColumnWidths() {
		return new int[] {
							30, 0, 0,0,100,
							50, 120,50,150, 30,
							80,0,150,80,80,80,
							80,0,0,0
						};
	}

	private GeneralGridCellRenderer[] getDVBTableColumnRenderer() {
		return new GeneralGridCellRenderer[] {
				null,null,null,null,null,
				null,null,null,null,null,
				null,null,null,null,null,null,
				null,null,null,null

		};
	}

	public BasePanel getSchedulePanel() {
		if (SchedulePanel == null) {
			SchedulePanel = new BasePanel();
			SchedulePanel.add(getScheduleJScrollPane(), null);
			SchedulePanel.add(getTslotListTable(), null);
			SchedulePanel.setBounds(305, 80, 480, 270);

		}
		return SchedulePanel;
	}

	private JScrollPane getScheduleJScrollPane() {
		if (ScheduleJScrollPane == null) {
			ScheduleJScrollPane = new JScrollPane();
			ScheduleJScrollPane.setViewportView(getScheduleTable());
			ScheduleJScrollPane.setBounds(0, 0, 390, 270);
		}
		return ScheduleJScrollPane;
	}

	private TableList getScheduleTable() {
		if (ScheduleTable == null) {
			ScheduleTable = new TableList(getScheduleTableColumnNames(),
										getScheduleTableColumnWidths()) {
				@Override
				public void setListTableContentPost() {
					if (getRowCount() == 0) {
						getTslotListTable().removeAllRow();
					} else {
						updateSlotTable();
					}
				}

				@Override
				public void onSelectionChanged() {
				}
			};
			ScheduleTable.addListener(Events.RowClick, new Listener<GridEvent<TableData>>() {
				@Override
				public void handleEvent(GridEvent<TableData> be) {
					updateSlotTable();
				}
			});
			ScheduleTable.setTableLength(790);
		}
		return ScheduleTable;
	}

	private String[] getScheduleTableColumnNames() {
		return new String[] {EMPTY_VALUE, "Loc", "Day", "From", "To", "Code",
				"Dr. FName", "Dr. Given Name", "%", "Remarks", "Doctor Practice Remark",
				"Status", "Last user",
				"Blocked By", "Blocked Date/Time",
				"Unblocked By", "Unblocked Date/Time",
				"Modified By", "Modified Date/Time",
				"SCHLEN", "SCHCNT","ENDDATE"};
	}

	private int[] getScheduleTableColumnWidths() {
		return new int[] {0, 0, 35, 100, 40, 40,
				60, 100, 40, 70, 150,
				40, 70,
				70, 120,
				80, 120,
				70, 120,
				0, 0,0};
	}

	public TableList getTslotListTable() {
		if (tslotListTable == null) {
			tslotListTable = new TableList(getTslotColumnNames(), getTslotColumnWidths()) {
				@Override
				public void onClick() {
					tslotLastScrollTop = getView().getRow(getSelectedRow()).getOffsetTop() - 20;
				};

				public void onSelectionChanged() {

					if (getTslotListTable().getRowCount() > 0) {
						if (getTslotListTable().getSelectedRow() == 0) {
							getTslotListTable().setSelectRow(0);
							getView().getBody().setScrollTop(0);
							tslotLastScrollTop = 0;
						} else {
							tslotLastScrollTop = getView().getRow(getSelectedRow()).getOffsetTop() - 20;
							if (getView().getBody().getScrollTop() > tslotLastScrollTop ||
									getTslotListTable().getView().getBody().getScrollTop() +
									getTslotListTable().getHeight() - 80 < tslotLastScrollTop) {
								getView().getBody().setScrollTop(tslotLastScrollTop);
							}
						}

						if (getTslotListTable().getSelectedRowContent() != null) {
							getTime().setText(getTslotListTable().getSelectedRowContent()[2]);
							getDuration().setText(getScheduleTable().getSelectedRowContent()[GrdPb_schlen]);
							getOfAptMade().setText(getTslotListTable().getSelectedRowContent()[4]);
							getDoctor().setText(getScheduleTable().getSelectedRowContent()[GrdPb_docCode]);

							getDVBTable().removeAllRow();
							enableButton();

							defaultFocus();
						}
					}
				}

				@Override
				public void setListTableContentPost() {
					getTslotListTable().getView().layout();

					if (memSlotSearchTime != null) {
						boolean isFound = false;
						for (int i=0; i < getTslotListTable().getRowCount() && !isFound; i++) {
							if (memSlotSearchTime.equals(getTslotListTable().getRowContent(i)[2].substring(11, 16)) &&
									memDoctorCode.equals(getScheduleTable().getSelectedRowContent()[GrdPb_docCode])) {
								isFound = true;
								getTslotListTable().setSelectRow(i);
								getView().getBody().setScrollTop(getView().getRow(i).getOffsetTop() - 20);
							}
						}
						memSlotSearchTime = null;
						memDoctorCode = null;
						memDoctorName = null;

						if (!isFound) {
							if (getTslotListTable().getRowCount() > 0) {
								getTslotListTable().setSelectRow(0);
								getView().getBody().setScrollTop(0);
								tslotLastScrollTop = 0;
							}
						}
					} else {
						if (getTslotListTable().getRowCount() > 0) {
							getTslotListTable().setSelectRow(0);
							getView().getBody().setScrollTop(0);
							tslotLastScrollTop = 0;
						}
					}

					defaultFocus();
				}
			};

			tslotListTable.setColumnResize(false);
			tslotListTable.setBounds(395, 0, 95, 270);
		}

		return tslotListTable;
	}

	private int[] getTslotColumnWidths() {
		return new int[] {0, 0, 0, 55, 37, 0};
	}

	private String[] getTslotColumnNames() {
		return new String[] {EMPTY_VALUE, "SCHID", "SLTSTIME", "Time", "#", ""};
	}

	public BasePanel getRightBtmPanel() {
		if (rightBtmPanel == null) {
			rightBtmPanel = new BasePanel();
			rightBtmPanel.setEtchedBorder();
/*			rightBtmPanel.add(getPatientNoDesc(), null);
			rightBtmPanel.add(getPatientNo(), null);
			rightBtmPanel.add(getSex(), null);
			rightBtmPanel.add(getNamesDesc(), null);
			rightBtmPanel.add(getNames(), null);
			rightBtmPanel.add(getPhoneHDesc(), null);
			rightBtmPanel.add(getPhoneH(), null);
			rightBtmPanel.add(getPhoneMDesc(), null);
			rightBtmPanel.add(getPhoneM(), null);
			rightBtmPanel.add(getSessionDesc(), null);
			rightBtmPanel.add(getSession(), null);
			rightBtmPanel.add(getTimedesc(), null);
			rightBtmPanel.add(getTime(), null);
			rightBtmPanel.add(getDurationDesc(), null);
			rightBtmPanel.add(getDuration(), null);
			rightBtmPanel.add(getMinsDesc(), null);
			rightBtmPanel.add(getOfAptMadeDesc(), null);
			rightBtmPanel.add(getOfAptMade(), null);
			rightBtmPanel.add(getDoctorDesc(), null);
			rightBtmPanel.add(getDoctor(), null);
			rightBtmPanel.add(getRemarkDesc(), null);
			rightBtmPanel.add(getRemark(), null);
			rightBtmPanel.add(getSMSContentDesc(), null);
			rightBtmPanel.add(getSMSContent(), null);
			rightBtmPanel.add(getSourceDesc(), null);
			rightBtmPanel.add(getAlertDesc(), null);
			rightBtmPanel.add(getAlert(), null);
			rightBtmPanel.add(getSource(), null);*/
			rightBtmPanel.add(getAppBrowseAction(),null);
			rightBtmPanel.add(getWalkInAction(),null);
			rightBtmPanel.add(getDocAppAction(),null);
			//rightBtmPanel.add(getAddSchAction(),null);
			//rightBtmPanel.add(getCancelAppAction(),null);
			//rightBtmPanel.add(getConfirmAppAction(),null);
			//rightBtmPanel.add(getChangeAppDetailAction(),null);

			rightBtmPanel.setBounds(10, 520, 990, 40);
		}
		return rightBtmPanel;
	}

	private LabelSmallBase getPatientNoDesc() {
		if (patientNoDesc == null) {
			patientNoDesc = new LabelSmallBase();
			patientNoDesc.setText("Patient No");
			patientNoDesc.setBounds(5, 5, 80, 20);
		}
		return patientNoDesc;
	}



	private LabelSmallBase getSex() {
		if (sex == null) {
			sex = new LabelSmallBase();
			sex.setBounds(150, 5, 20, 20);
		}
		return sex;
	}

	private LabelSmallBase getNamesDesc() {
		if (namesDesc == null) {
			namesDesc = new LabelSmallBase();
			namesDesc.setText("Name");
			namesDesc.setBounds(182, 5, 50, 20);
		}
		return namesDesc;
	}

	private TextString getNames() {
		if (names == null) {
			names = new TextString(81);
			names.setBounds(220, 5, 135, 20);
		}
		return names;
	}

	private LabelSmallBase getPhoneHDesc() {
		if (phoneHDesc == null) {
			phoneHDesc = new LabelSmallBase();
			phoneHDesc.setText("Home Phone");
			phoneHDesc.setBounds(365, 5, 90, 20);
		}
		return phoneHDesc;
	}

	private TextPhone getPhoneH() {
		if (phoneH == null) {
			phoneH = new TextPhone();
			phoneH.setBounds(436, 5, 80, 20);
		}
		return phoneH;
	}

	private LabelSmallBase getPhoneMDesc() {
		if (phoneMDesc == null) {
			phoneMDesc = new LabelSmallBase();
			phoneMDesc.setText("Mobile Phone");
			phoneMDesc.setBounds(525, 5, 90, 20);
		}
		return phoneMDesc;
	}

	private TextPhone getPhoneM() {
		if (phoneM == null) {
			phoneM = new TextPhone();
			phoneM.setBounds(600, 5, 80, 20);
		}
		return phoneM;
	}

	private LabelSmallBase getSessionDesc() {
		if (sessionDesc == null) {
			sessionDesc = new LabelSmallBase();
			sessionDesc.setText("Session");
			sessionDesc.setBounds(685, 5, 50, 20);
		}
		return sessionDesc;
	}

	private TextNum getSession() {
		if (session == null) {
			session = new TextNum(3);//session = new TextNum(2, 0);
			session.setBounds(730, 5, 20, 20);
		}
		return session;
	}

	private LabelSmallBase getRemarkDesc() {
		if (remarkDesc == null) {
			remarkDesc = new LabelSmallBase();
			remarkDesc.setText("Remark");
			remarkDesc.setBounds(535, 30, 60, 20);
		}
		return remarkDesc;
	}

	private TextString getRemark() {
		if (remark == null) {
			remark = new TextString(175);
			remark.setBounds(580, 30, 200, 20);
		}
		return remark;
	}

	private LabelSmallBase getTimedesc() {
		if (timedesc == null) {
			timedesc = new LabelSmallBase();
			timedesc.setText("Time");
			timedesc.setBounds(5, 30, 80, 20);
		}
		return timedesc;
	}

	private TextReadOnly getTime() {
		if (time == null) {
			time = new TextReadOnly();
			time.setBounds(70, 30, 130, 20);
		}
		return time;
	}

	private LabelSmallBase getDurationDesc() {
		if (durationDesc == null) {
			durationDesc = new LabelSmallBase();
			durationDesc.setText("Duration");
			durationDesc.setBounds(215, 30, 80, 20);
		}
		return durationDesc;
	}

	private TextReadOnly getDuration() {
		if (duration == null) {
			duration = new TextReadOnly();
			duration.setBounds(263, 30, 25, 20);
		}
		return duration;
	}

	private LabelSmallBase getMinsDesc() {
		if (minsDesc == null) {
			minsDesc = new LabelSmallBase();
			minsDesc.setText("mins");
			minsDesc.setBounds(290, 30, 60, 20);
		}
		return minsDesc;
	}

	private LabelSmallBase getOfAptMadeDesc() {
		if (ofAptMadeDesc == null) {
			ofAptMadeDesc = new LabelSmallBase();
			ofAptMadeDesc.setText("# of Apt made");
			ofAptMadeDesc.setBounds(330, 30, 100, 20);
		}
		return ofAptMadeDesc;
	}

	private TextReadOnly getOfAptMade() {
		if (ofAptMade == null) {
			ofAptMade = new TextReadOnly();
			ofAptMade.setBounds(410, 30, 25, 20);
		}
		return ofAptMade;
	}

	private LabelSmallBase getDoctorDesc() {
		if (doctorDesc == null) {
			doctorDesc = new LabelSmallBase();
			doctorDesc.setText("Doctor");
			doctorDesc.setBounds(445, 30, 60, 20);
		}
		return doctorDesc;
	}

	private TextReadOnly getDoctor() {
		if (doctor == null) {
			doctor = new TextReadOnly();
			doctor.setBounds(485, 30, 50, 20);
		}
		return doctor;
	}


	private LabelSmallBase getLocationDesc() {
		if (locationDesc == null) {
			locationDesc = new LabelSmallBase();
			locationDesc.setText("location");
			locationDesc.setBounds(220, 10, 60, 20);
		}
		return locationDesc;
	}

	private ComboBoxBase getLocation() {
		if (location == null) {
			location = new ComboBoxBase("DRRMLOCATION", false, false, true){
				@Override
				protected void setTextPanel(ModelData modelData) {
					initDVATableColumns();
	
				}
			};
			location.setBounds(275, 10, 158, 20);
		}
		return location;
	}
	
	private LabelBase getClosed() {
		if (Closed == null) {
			Closed = new LabelBase();
			Closed.setBounds(490, 10, 80, 20);
			Closed.setText("Closed Room");
			Closed.addStyleName("ot-cell-bkgcolor10");
			Closed.setBorders(true);
		}
		return Closed;
	}
	
	private LabelBase getWalkIn() {
		if (WalkIn == null) {
			WalkIn = new LabelBase();
			WalkIn.setBounds(580, 10, 80, 20);
			WalkIn.setText("Walk-In");
			WalkIn.addStyleName("ot-cell-bkgcolor2confirmed");
			WalkIn.setBorders(true);
		}
		return WalkIn;
	}
	
	private LabelBase getAppointment() {
		if (Appointment == null) {
			Appointment = new LabelBase();
			Appointment.setBounds(670, 10, 80, 20);
			Appointment.setText("Appointment");
			Appointment.addStyleName("ot-cell-bkgcolor3");
			Appointment.setBorders(true);
		}
		return Appointment;
	}


	private ButtonBase getDocAppAction() {
		if (docAppAction == null) {
			docAppAction = new ButtonBase() {
				@Override
				public void onClick() {
					removeParameter();
					showPanel(new DoctorAppointment(), false, true);
				}
			};
			docAppAction.setText("Doctor Appointment");
			docAppAction.setBounds(240, 5, 133, 30);
		}
		return docAppAction;
	}


	private ButtonBase getWalkInAction() {
		if (walkInAction == null) {
			walkInAction = new ButtonBase() {
				@Override
				public void onClick() {
					showPanel(new PatientWalkIn());
				}
			};
			walkInAction.setText("Walk-In", 'W');
			walkInAction.setBounds(5, 5, 80, 30);
		}
		return walkInAction;
	}

	private ButtonBase getAppBrowseAction() {
		if (appBrowseAction == null) {
			appBrowseAction = new ButtonBase() {
				@Override
				public void onClick() {
					showAppointmentBrowsePanel();
				}
			};
			appBrowseAction.setText("Appointment Browse", 's');
			appBrowseAction.setBounds(90, 5, 145, 30);
		}
		return appBrowseAction;
	}



	protected void showAppointmentBrowsePanel() {
		if (getDVBTable().getRowCount() > 0) {
			if (getDVBTable().getSelectedRow() == 0) {
				setParameter("qPATNO", getDVBTable().getSelectedRowContent()[DVBCol_PATNO]);
			}
		}
		showPanel(new AppointmentBrowse());
	}
	
	private ButtonBase getAddSchAction() {
		if (addSchAction == null) {
			addSchAction = new ButtonBase() {
				@Override
				public void onClick() {
					getSchDialog().showDialog(
							getMainFrame().getUserInfo().getSiteCode().trim(),
							"",
							getDVStartDate().getText(),
							null
						);
				}
			};
			addSchAction.setText("Add Schedule", 'A');
			addSchAction.setBounds(380, 5, 145, 30);
		}
		return addSchAction;
	}


	private DlgAddSch getSchDialog() {
		if (schDialog == null) {
			schDialog = new DlgAddSch(getMainFrame()) {
				@Override
				public void doCancelAction() {
					rePostAction();
					super.doCancelAction();
				}

				@Override
				protected void post(boolean override) {
					QueryUtil.executeMasterAction(getUserInfo(), ConstantsTx.DOCAPPOINTMENT_TXCODE + "_SINGLE",
							QueryUtil.ACTION_APPEND, new String[] {
									getSchDocCode().getText().trim(),
									getSchStartTime().getText().trim(),
									getSchEndTime().getText().trim(),
									getSchDuration().getText().trim(),
									getDocPrRemark().getText().trim(),
									getDocLocation().getText().trim(),
									getDocRoom().getText().trim(),
									getAllowPublicHoliday().isSelected() ? YES_VALUE : NO_VALUE,
									override ? YES_VALUE : NO_VALUE,
									CommonUtil.getComputerName(),
									getUserInfo().getUserID()
								},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success() && Integer.valueOf(mQueue.getReturnCode()) >= 0) {
								Factory.getInstance().addErrorMessage(mQueue.getReturnMsg(), "PBA - [Add Schedule]");
								clearAction();
								rePostAction();
							} else if ("-100".equals(mQueue.getReturnCode())) {
								MessageBoxBase.confirm(ConstantsMessage.MSG_PBA_SYSTEM, mQueue.getReturnMsg(), new Listener<MessageBoxEvent>() {
									public void handleEvent(MessageBoxEvent be) {
										if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
											post(true);
										} else {
											Factory.getInstance().addErrorMessage("Schedule add failed.", "PBA - [Add Schedule]");
											clearAction();
										}
									}
								});
							} else {
								Factory.getInstance().addErrorMessage(mQueue.getReturnMsg() + " Schedule add failed.", "PBA - [Add Schedule]");
								clearAction();
							}
						}
					});
				}
			};
		}
		return schDialog;
	}

	@Override
	protected String[] getFetchInputParameters() {
		// TODO Auto-generated method stub
		return null;
	}



	public CheckBoxBase getOnlyBlocked() {
		if (onlyBlocked == null) {
			onlyBlocked = new CheckBoxBase();
			onlyBlocked.setBounds(765, 3, 30, 20);
		}
		return onlyBlocked;
	}


	public CheckBoxBase getIncludeBlocked() {
		if (includeBlocked == null) {
			includeBlocked = new CheckBoxBase();
			includeBlocked.setBounds(765, 19, 30, 20);
		}
		return includeBlocked;
	}


	public CheckBoxBase getOnlyRehab() {
		if (sortByTime == null) {
			sortByTime = new CheckBoxBase();
			sortByTime.setBounds(765, 51, 30, 20);
		}
		return sortByTime;
	}

}