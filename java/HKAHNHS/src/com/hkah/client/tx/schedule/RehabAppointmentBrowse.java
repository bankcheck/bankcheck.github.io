package com.hkah.client.tx.schedule;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

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
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class RehabAppointmentBrowse extends MasterPanel {

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;
	private static final int DVATableWidth = 490;

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.REHABAPPOINTMENTBROWSE_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.REHABAPPOINTMENTBROWSE_TITLE;
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
	private ButtonBase editAppAction = null;
	private ButtonBase changeAppDetailAction = null;
	private ButtonBase cancelAppAction = null;
	private ButtonBase confirmAppAction = null;

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
	private LabelSmallBase alertDesc = null;
	private ComboBoxBase alert = null;
	private LabelSmallBase durationDesc = null;
	private TextReadOnly duration = null;
	private LabelSmallBase minsDesc = null;
	private LabelSmallBase ofAptMadeDesc = null;
	private TextReadOnly ofAptMade = null;
	private LabelSmallBase doctorDesc = null;
	private TextReadOnly doctor;
	private LabelBase docLocationDESC = null;
	private ComboDoctorLocation docLocation = null;
	private LabelSmallBase timedesc = null;
	private TextReadOnly time = null;
	private LabelSmallBase sourceDesc = null;
	private ComboBoxBase source = null;
	private LabelSmallBase SMSContentDesc = null;
	private ComboBoxBase SMSContent = null;

	private DlgLabelPrint infoDialog = null;
	private String mrhvollab = null;

	private Menu contextMenu = null;
	private MenuItemBase cancelBookingMenu = null;
	private MenuItemBase editBookingMenu = null;
	private MenuItemBase changeBookingDetailMenu = null;
	private MenuItemBase confirmBookingMenu = null;

	private DialogBase changeBookingDialog = null;
	private BasePanel changeBookingPanel = null;
	private LabelSmallBase cPatNoDESC = null;
	private TextReadOnly cPatNo = null;
	private LabelSmallBase cPatNameDESC = null;
	private TextReadOnly cPatName = null;
	private LabelSmallBase cPatCNameDESC = null;
	private TextReadOnly cPatCName = null;
	private LabelSmallBase cPatTelDESC = null;
	private TextString cPatTel = null;
	private LabelSmallBase cPatMTelDESC = null;
	private TextString cPatMTel = null;
	private LabelSmallBase cRemarkDESC = null;
	private TextString cRemark = null;
	private ButtonBase change = null;
	private ButtonBase cancel = null;

	private LabelSmallBase onlyBlockedDesc = null;
	private CheckBoxBase onlyBlocked = null;
	private LabelSmallBase includeBlockedDesc = null;
	private CheckBoxBase includeBlocked = null;
	private LabelSmallBase sortByTimeDesc = null;
	private CheckBoxBase sortByTime = null;
	private LabelSmallBase onlyRehabDesc = null;
	private CheckBoxBase onlyRehab = null;

	private DlgPrintAppList dlgPrintAppListing = null;


	private boolean memIsOverrideBooking = false;
	private String newBkgID = "";
	private String memDoctorName = null;
	private String memDoctorCode = null;
	private String memSlotSearchTime = null;

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
			"ot-cell-bkgcolorBlock",".ot-cell-bkgcolorWhite"
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
	private final int SchCol_11 = 11;
	private final int SchCol_REMARK = 12;
	private final int SchCol_SLOTID = 13;
	private final int SchCol_SCHID = 14;

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
	private final int DocSchCol_SCHDESC = 9;
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

	private String isPHorSat = null;


	private String selectedRoom = null;

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;

	/**
	 * This method initializes
	 *
	 */
	public RehabAppointmentBrowse() {
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
		getDVBTable().setContextMenu(getPopupMenu());
		firstLoadDate = null;

		memCurrDT = getMainFrame().getServerDate();
		missedCol = getRtnSlotRowNo(getSysParameter("RHSTIME"),getSysParameter("RHSTIME"), null)[0];
		maxCol = getRtnSlotRowNo(getSysParameter("RHETIME"),getSysParameter("RHETIME"), null)[1];
		getDVBTable().setColumnColor(DVBCol_REMARK, "red");
		initDateField();
		initDVATableColumns();
		resetBookingEntry();

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
	public TextPatientNoSearch getDefaultFocusComponent() {
		return getPatientNo();
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
	public void saveAction(){
		actionValidation();
	}

	@Override
	public void cancelAction() {
		isChangeBooking = false;
		resetBookingEntry();
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
		getPrintButton().setEnabled(true);
		if (isChangeBooking) {
			getCancelButton().setEnabled(true);
		}
		getSearchButton().setEnabled(true);
		getRefreshButton().setEnabled(true);
		getSaveButton().setEnabled(true);

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
			getScheduleTable().setListTableContent("REHABSCHEDULE",
					new String[] {
					SDate,
					EDate,
					getDrCode().getText(),
					"",
					getOnlyBlocked().isSelected()?YES_VALUE:NO_VALUE,
					getIncludeBlocked().isSelected()?"B":NO_VALUE,
					getSortByTime().isSelected()?YES_VALUE:NO_VALUE,Factory.getInstance().getUserInfo().getUserID(),
					getOnlyRehab().isSelected()?YES_VALUE:NO_VALUE,
					});
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

	@Override
	public void printAction() {
		getDlgPrintAppList().showDialog();
	}

	protected void actionValidation() {
		checkPatientNo();
	}

	private void checkPatientNo() {
		if (!getPatientNo().isEmpty()) {
			QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] { "PATIENT", "COUNT(1)", "PATNO = '"+getPatientNo().getText()+"'" },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						String result = mQueue.getContentField()[0];
						if (result != null && result.length() > 0) {
							try {
								if (Integer.parseInt(result)> 0) {
									checkPatientNoPost();
								} else {
									getNames().resetText();
									getPhoneH().resetText();
									getPhoneM().resetText();
									Factory.getInstance().addErrorMessage(MSG_BOOKING_NOINFO,
											"PBA - [Appointment]", getNames());
								}
							} catch (Exception e) {
								e.printStackTrace();
								getNames().resetText();
								getPhoneH().resetText();
								getPhoneM().resetText();
								Factory.getInstance().addErrorMessage(MSG_BOOKING_NOINFO,
										"PBA - [Appointment]", getNames());
							}
						} else {
							getNames().resetText();
							getPhoneH().resetText();
							getPhoneM().resetText();
							Factory.getInstance().addErrorMessage(MSG_BOOKING_NOINFO,
									"PBA - [Appointment]", getNames());
						}
					} else {
						getNames().resetText();
						getPhoneH().resetText();
						getPhoneM().resetText();
						Factory.getInstance().addErrorMessage(MSG_BOOKING_NOINFO,
								"PBA - [Appointment]", getNames());
					}
				}
			});
		} else {
			checkPatientNoPost();
		}
	}

	private void checkPatientNoPost() {
		boolean returnValue = true;
		if (getScheduleTable().getSelectionModel().getSelectedItems().size() <= 0) {
			Factory.getInstance().addErrorMessage("Please select a schedule.", "PBA - [Appointment]", null, getScheduleTable());
			returnValue = false;
		} else if (DateTimeUtil.dateDiff(getScheduleTable().getSelectedRowContent()[GrdPb_timeFrom].substring(0, 10),
								DateTimeUtil.getCurrentDate()) < 0) {
			Factory.getInstance().addErrorMessage("No backdate booking is allowed.", "PBA - [Appointment]", null, getScheduleTable());
			returnValue = false;
		}  else if (getDoctor().isEmpty()) {
			Factory.getInstance().addErrorMessage("Inactive doctor.", "PBA - [Appointment]", getDoctor());
			returnValue = false;
		} else if (getNames().isEmpty()) {
			Factory.getInstance().addErrorMessage(MSG_BOOKING_NOINFO, "PBA - [Appointment]", getNames());
			returnValue = false;
		} else if (YES_VALUE.equals(getSysParameter("AppAltEnty")) && getAlert().isEmpty()) {
			Factory.getInstance().addErrorMessage("Initial Assessed is mandatory, please select one option.", "PBA - [Doctor Appointment]", getAlert());
			returnValue = false;
		} else if (!getAlert().isEmpty() && !getAlert().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid Initial Assessed.", "PBA - [Doctor Appointment]", getAlert());
			returnValue = false;
		} else if (YES_VALUE.equals(getSysParameter("BOKSRCMUST")) && getSource().isEmpty()) {
			Factory.getInstance().addErrorMessage("Please Input Source.", "PBA - [Doctor Appointment]", getSource());
			returnValue = false;
		} else if (!getSource().isEmpty() && !getSource().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid Input Source.", "PBA - [Doctor Appointment]", getSource());
			returnValue = false;
		} else if ((getPhoneH().isEmpty() && getPhoneM().isEmpty())) {
			Factory.getInstance().addErrorMessage(MSG_BOOKING_NOINFO, "PBA - [Appointment]", getPhoneH());
			returnValue = false;
		} else {
			int session = -1;
			try { session = Integer.valueOf(getSession().getText().trim()); } catch(Exception e) {}

			String startDate = getScheduleTable().getSelectedRowContent()[GrdPb_timeFrom];
			String endTimeOfSlot = getScheduleTable().getSelectedRowContent()[GrdPb_timeTo];
			endTimeOfSlot = startDate.substring(0, startDate.lastIndexOf(SLASH_VALUE) + 6) + endTimeOfSlot + ":00";
			String startTime = getTime().getText();
			int duration = Integer.valueOf(getDuration().getText());
			String endTimeOfBk = DateTimeUtil.formatDateTime(new Date(DateTimeUtil.parseDateTime(startTime).getTime() + (((session * duration) - 1) * 60000)));

			int endTimeDiff = (int) DateTimeUtil.dateTimeDiff(endTimeOfSlot, endTimeOfBk);

			if (session <= 0) {
				Factory.getInstance().addErrorMessage("Invalid Session.", "PBA - [Appointment]", getSession());
				returnValue = false;
			} else if (endTimeDiff < 0) {
				Factory.getInstance().addErrorMessage("Session exceed doctor schedule.", "PBA - [Appointment]", getSession());
				returnValue = false;
			}
		}
		checkChangeBooking(returnValue);
	}

	private void checkChangeBooking(final boolean returnValue) {
		if (returnValue && isChangeBooking) {
			MessageBoxBase.confirm(MSG_PBA_SYSTEM,
					"Are you sure to change appointment?",
					new Listener<MessageBoxEvent>() {
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						actionValidationReady(returnValue);
					} else {
						//defaultFocus();
					}
				}
			});
		} else {
			actionValidationReady(returnValue);
		}
	}

	protected void actionValidationReady(final boolean isValidationReady) {
		if (isValidationReady) {
			String[] inParam = new String[] {
					getDoctor().getText(),
					getTime().getText(),
					getTslotListTable().getSelectedRowContent()[0],
					getTslotListTable().getSelectedRowContent()[1],
					getPatientNo().getText().trim(),
					getNames().getText().trim(),
					getPhoneH().getText().trim(),
					getPhoneM().getText().trim(),
					getSession().getText().trim(),
					getSource().getText().trim(),
					getRemark().getText().trim(),
					getSMSContent().getText().trim(),
					getDuration().getText().trim(),
					getAlert().getText().trim(),
					"",
					"",
					"",
					"",
					"",
					isChangeBooking?memRLockID:EMPTY_VALUE,
					memIsOverrideBooking?YES_VALUE:NO_VALUE,
					getUserInfo().getUserID(),
					CommonUtil.getComputerName(),
					"",
					"",
				};

			QueryUtil.executeMasterAction(getUserInfo(), ConstantsTx.APPOINTMENTBROWSE_TXCODE, QueryUtil.ACTION_APPEND, inParam,
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						newBkgID = mQueue.getReturnCode();
						getInfoDialog().getCurBKID().setText(newBkgID);
						memSlotSearchTime = getTslotListTable().getSelectedRowContent()[2].substring(11, 16);
						memDoctorCode = getDoctor().getText();
						memDoctorName = getScheduleTable().getSelectedRowContent()[GrdPb_docFName] + SPACE_VALUE + getScheduleTable().getSelectedRowContent()[GrdPb_docGName];
						final String appDate = getTime().getText();

						if (isChangeBooking) {
							// after cancel original appointment

							// back to appointment browse
							Factory.getInstance().addSystemMessage("Booking is changed.", "PBA - [Doctor Apointment]");
							isChangeBooking = false;
							getDVATable().enable();
							refreshAction();
						}

						if (!getPatientNo().isEmpty()) {
							QueryUtil.executeMasterFetch(getUserInfo(), "MEDRECGETWPAPER",
									new String[] { getPatientNo().getText().trim() },
									new MessageQueueCallBack() {
								@Override
								public void onPostSuccess(MessageQueue mQueue) {
									String funname = null;
									if (isChangeBooking) {
										funname = "Change Appointment";
									} else {
										funname = "New Appointment";
									}
									// send alert mail
									String appDate = getTslotListTable().getSelectedRowContent()[2];
									String docfname = getScheduleTable().getSelectedRowContent()[GrdPb_docFName];
									String docgname = getScheduleTable().getSelectedRowContent()[GrdPb_docGName];

									Map<String, String> params = new HashMap<String, String>();
									params.put("App. Date", appDate);
									params.put("Doctor Name", docfname + SPACE_VALUE + docgname);

									getAlertCheck().checkAltAccess(
											getPatientNo().getText().trim(),
											funname, false, true, params);

									StringBuffer desc = new StringBuffer();
									String isPaper = null;
									boolean isCallChtEnable = true;
									boolean creatNewVol = false;
									if (mQueue.getContentField().length > 0) {
										desc.append(mQueue.getContentField()[0]);
										desc.append("(");
										if (mQueue.getContentField().length > 1) {
											desc.append(mQueue.getContentField()[1]);
											desc.append(")");
											if ("-1".equals(mQueue.getContentField()[2])) {
												isCallChtEnable = false;
											}
											isPaper = mQueue.getContentField()[3];
										} else {
											desc.append(")");
										}
									}
									int volCnt = -1;
									try {
										volCnt = Integer.parseInt(mQueue.getContentField()[4]);
									} catch (Exception e) {
										System.out.println("[e]:" + e);
									}
									if (volCnt == 0 && !ONE_VALUE.equals(isPaper)) {
										creatNewVol = true;
									}

									getInfoDialog().showDialog(getPatientNo().getText().trim(), memDoctorCode, memDoctorName,
											true, true, desc.toString(), false, false, isCallChtEnable, isPaper, creatNewVol, appDate);
								}
							});
						} else {
							getInfoDialog().showDialog(getPatientNo().getText().trim(), memDoctorCode, memDoctorName, false, false, null, false, false, appDate);
						}

						setActionType(null);
						if (!"OK".equals(mQueue.getReturnMsg())) {
							Factory.getInstance().addErrorMessage(mQueue.getReturnMsg(), "PBA - [Doctor Apointment]", null, getDefaultFocusComponent());
						}
					} else if ("-2".equals(mQueue.getReturnCode())) {
						newBkgID = "";
						MessageBox mb = MessageBoxBase.confirm(MSG_PBA_SYSTEM, mQueue.getReturnMsg(),
								new Listener<MessageBoxEvent>() {
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									memIsOverrideBooking = true;
									// resubmit again
									actionValidationReady(isValidationReady);
								} else {
									//defaultFocus();
								}
							}
						});

						mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
//					} else if ("-3".equals(mQueue.getReturnCode())) {
//						MessageBox mb = MessageBoxBase.confirm(MSG_PBA_SYSTEM, mQueue.getReturnMsg(),
//								new Listener<MessageBoxEvent>() {
//							public void handleEvent(MessageBoxEvent be) {
//								memIsUpdatePatSMS = Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId()) ? YES_VALUE : NO_VALUE;
//								// resubmit again
//								actionValidationReady(actionType, isValidationReady);
//							}
//						});
//
//						mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
					} else {
						newBkgID = "";
						Factory.getInstance().addErrorMessage(mQueue.getReturnMsg(), "PBA - [Doctor Apointment]", null, getDefaultFocusComponent());
						setActionType(null);
					}
				}
			});
		}
	}

	private void cancelAppointmentPre() {
		if (getDVBTable().getSelectedRow() >= 0) {
			QueryUtil.executeMasterAction(
				getUserInfo(),
				"RECORDLOCK",
				QueryUtil.ACTION_APPEND,
				new String[] {
						"Booking",
						getDVBTable().getSelectedCellContent(DVBCol_BKGID),
						CommonUtil.getComputerName(),
						getUserInfo().getUserID()
				},
				new MessageQueueCallBack() {
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							memRLockID = getDVBTable().getSelectedCellContent(DVBCol_BKGID);

							if ("N".equals(getDVBTable().getSelectedCellContent(DVBCol_STATUSCODE))) {
								MessageBoxBase.confirm(MSG_PBA_SYSTEM, MSG_CANCELAPT_CONFIRM, new Listener<MessageBoxEvent>() {
									public void handleEvent(MessageBoxEvent be) {
										if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
											QueryUtil.executeMasterAction(
													getUserInfo(), "BOOKING_CANCEL", QueryUtil.ACTION_APPEND,
													new String[] { memRLockID, getUserInfo().getUserID() },
													new MessageQueueCallBack() {
												@Override
												public void onPostSuccess(MessageQueue mQueue) {
													if (mQueue.success()) {
														// send alert mail
														String funname = "Cancel Appointment";
														String docname = getDVBTable().getSelectedCellContent(DVBCol_DOCTOR);

														Map<String, String> params = new HashMap<String, String>();
														params.put("App. Date", getDVBTable().getSelectedCellContent(DVBCol_APPSDATE));
														params.put("Doctor Name", docname);
														getAlertCheck().checkAltAccess(
																getListTable().getSelectedCellContent(DVBCol_PATNO).trim(),
																funname, true, true, params);

														Factory.getInstance().addInformationMessage(MSG_CANCELAPT_SUCCESS, "PBA-[Appointment Browse]");
														searchAction(false);
													} else {
														Factory.getInstance().addErrorMessage(MSG_CANCELAPT_FAIL, "PBA-[Appointment Browse]");
													}

													unlockRecord("Booking", memRLockID);
												}

												@Override
												public void onFailure(Throwable caught) {
													unlockRecord("Booking", memRLockID);
													Factory.getInstance().addErrorMessage(MSG_CANCELAPT_FAIL, "PBA-[Appointment Browse]");
												}

												@Override
												public void onComplete() {
													super.onComplete();
													getMainFrame().setLoading(false);
													refreshAction();
												}
											});
										}
										else {
											unlockRecord("Booking", memRLockID);
										}
									}
								});
							} else {
								unlockRecord("Booking", memRLockID);

								Factory.getInstance().addErrorMessage(MSG_CANCELAPT_INVALID, "PBA-[Appointment Browse]");

								//ensure disable loading
								getMainFrame().setLoading(false);
								refreshAction();
							}
						} else {
							memRLockID = null;
							Factory.getInstance().addErrorMessage(MSG_BOOKING_LOCK, "PBA-[Appointment Browse]");
						}
					}

					@Override
					public void onFailure(Throwable caught) {
						memRLockID = null;
						Factory.getInstance().addErrorMessage(MSG_BOOKING_LOCK, "PBA-[Appointment Browse]");
					}
			});
		}
	}

	private void confirmApp() {
		QueryUtil.executeMasterAction(
				getUserInfo(),
				"BOOKING_CHECK",
				QueryUtil.ACTION_APPEND,
				new String[] {
					getDVBTable().getSelectedCellContent(DVBCol_BKGID),
					CommonUtil.getComputerName(),
					getUserInfo().getUserID()
				},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					memRLockID = getDVBTable().getSelectedCellContent(DVBCol_BKGID);

					setParameter("START_TYPE", "N");
					setParameter("CallForm", "schBooking");
					setParameter("BkgID", memRLockID);
					setParameter("PatNo", getDVBTable().getSelectedCellContent(DVBCol_PATNO));
					setParameter("PatFName", getDVBTable().getSelectedCellContent(DVBCol_PATNAME));
					//setParameter("PatCName", getDVBTable().getSelectedCellContent(GrdPb_bkgpcname));
					setParameter("DocCode", getDVBTable().getSelectedCellContent(DVBCol_DOCCODE));
					setParameter("Tel", getDVBTable().getSelectedCellContent(DVBCol_BKGPTEL));
					setParameter("FromBk", "bkgz");
					setParameter("MTel", getDVBTable().getSelectedCellContent(DVBCol_BKGMTEL));
					setParameter("BkgSDate", getDVBTable().getSelectedCellContent(DVBCol_APPSDATE));
					setParameter("showPatientProfile", "YES");

					showPanel(new PatientOut());

					if (memRLockID != null) {
						unlockRecord("Booking", memRLockID);
					}
				} else {
					Factory.getInstance().addErrorMessage(mQueue);
				}
			}
		});
	}

	private void editAppointment() {
		if (getDVBTable().getSelectedRow() >= 0) {
			if ("N".equals(getDVBTable().getSelectedCellContent(DVBCol_STATUSCODE))) {
				QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.APPOINTMENTBROWSE_TXCODE,
						new String[] { getDVBTable().getSelectedCellContent(DVBCol_BKGID)},
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							// get first return value and assign to district
							String[] para = mQueue.getContentField();
							if (para.length > 0) {
								isChangeBooking = true;
								String doccode = getDVBTable().getSelectedCellContent(DVBCol_DOCCODE);
								String appointmentDate = getDVBTable().getSelectedCellContent(DVBCol_APPSDATE);
								memRLockID = getDVBTable().getSelectedCellContent(DVBCol_BKGID);
								resetBookingEntry();
								String patno = para[0];
								if (patno != null && patno.length() > 0) {
									getPatientNo().setText(patno);

								} else {
									getPatientNo().resetText();
									getNames().setText(para[1]);
									getPhoneH().setText(para[3]);
									getPhoneM().setText(para[4]);
								}
								getSource().setText(para[6]);
								getAlert().setText(para[8]);
								getRemark().setText(para[5]);
								getSession().setText(para[14]);
								getDrCode().setText(doccode);
								if (appointmentDate != null && appointmentDate.length() == 10) {
									getDVStartDate().setText(appointmentDate);
									getFromDate().setText(appointmentDate);
									getToDate().setText(appointmentDate);
								}
								;
								refreshAction();
								//getDVATable().disable();
							}
						}
					}
				});
			} else {
				Factory.getInstance().addErrorMessage("Can't change the selected record", "PBA-[Appointment Browse]");
			}
		}
	}

	private void changeBookingDetail() {
		if (getDVBTable().getSelectedRow() >= 0) {
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.APPOINTMENTBROWSE_TXCODE,
					new String[] { getDVBTable().getSelectedCellContent(DVBCol_BKGID)},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					getCPatNo().resetText();
					getCPatName().resetText();
					getCPatCName().resetText();
					getCPatTel().resetText();
					getCPatMTel().resetText();
					getCRemark().resetText();


					if (mQueue.success()) {
						// get first return value and assign to district
						String[] para = mQueue.getContentField();
						if (para.length > 0) {
							getCPatNo().setText(para[0]);
							getCPatNo().setOriginalValue(para[0]);
							getCPatName().setText(para[1]);
							getCPatCName().setText(para[2]);
							getCPatTel().setText(para[3]);
							getCPatMTel().setText(para[4]);
							getCRemark().setText(para[5]);
							//-------------------------------------
							getChangeBookingDialog().setVisible(true);
						}
					}
				}
			});
		}
	}


	/***************************************************************************
	* Helper Method
	**************************************************************************/

	private RehabAppointmentBrowse getThis() {
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
			boolean allowCancel = compare < 1 && normalStatus && !isDisableFunction("btnCancelApp", "schBooking");
			boolean allowChange = !isDisableFunction("btnChgBooking", "schBooking");
			boolean allowRegFuture = !isDisableFunction("btnAllowRegFuture", "schBooking");

			Factory.getInstance().writeLogToLocal("[DEBUG] allowCancel="+allowCancel+", allowChange="+allowChange+", allowRegFuture="+allowRegFuture);

			getConfirmBookingMenu().setEnabled((compare == 0 || allowRegFuture) && normalStatus);
			getConfirmAppAction().setEnabled((compare == 0 || allowRegFuture) && normalStatus);

			getCancelAppAction().setEnabled(allowCancel);
			getChangeAppDetailAction().setEnabled(allowChange);
			getEditAppAction().setEnabled(allowChange);

			getCancelBookingMenu().setEnabled(allowCancel);
			getEditBookingMenu().setEnabled(allowChange);
			getChangeBookingDetailMenu().setEnabled(allowChange);


		} else {
			getCancelAppAction().setEnabled(false);
			getChangeAppDetailAction().setEnabled(false);
			getEditAppAction().setEnabled(false);
			getConfirmAppAction().setEnabled(false);

			getCancelBookingMenu().setEnabled(false);
			getEditBookingMenu().setEnabled(false);
			getConfirmBookingMenu().setEnabled(false);
			getChangeBookingDetailMenu().setEnabled(false);
		}

		if (!isDisableFunction("btnDeptAppDisable", "reg") &&
				!Factory.getInstance().getUserInfo().getSiteCode().equals(Factory.getInstance().getUserInfo().getUserID())) {
			disableAllAppButtons();
		}
	}


	private void disableAllAppButtons() {
		getCancelAppAction().setEnabled(false);
		getChangeAppDetailAction().setEnabled(false);
		getEditAppAction().setEnabled(false);
		getConfirmAppAction().setEnabled(false);
		getCancelBookingMenu().setEnabled(false);
		getEditBookingMenu().setEnabled(false);
		getConfirmBookingMenu().setEnabled(false);
		getChangeBookingDetailMenu().setEnabled(false);
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
		memCurrSelectedCellColID = colNo;
		memCurrSelectedCellRowNo = rowNo;

		if (tempDeptAID == null) {
			DeptAID_sql.append(" and 1=2 ");
		} else {
			DeptAID_Count = tempDeptAID.size();
			DeptAID_sql.append(" and B.BKGID in (");
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

		getDVBTable().setListTableContent("REHABDVBTABLELIST", new String[] {DeptAID_sql.toString(), Factory.getInstance().getUserInfo().getUserID()});

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
		QueryUtil.executeMasterBrowse(getUserInfo(), "REHABSCHEDULE",
				new String[] {
			dvStartDate,
			dvStartDate,
			null,
			"","","N","",Factory.getInstance().getUserInfo().getUserID(),"S"
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
						if (((String)rowT[DocSchCol_DOCCODE]).startsWith("R")) {
							colnoT = getRoomId2Col((String) rowT[DocSchCol_DOCCODE]); //assign column
							if (colnoT > -1) {
								slotRowT = getRtnSlotRowNo(String.valueOf(rowT[DocSchCol_SCHSDATE]), String.valueOf(rowT[DocSchCol_SCHEDATE]), dvStartDate);
								S_SlotRowNoT = slotRowT[0];
								E_SlotRowNoT = slotRowT[1];

								if (S_SlotRowNoT == E_SlotRowNoT) {
									setBackgroundColor(tempBkgColorData, S_SlotRowNoT, colnoT, null,null,isPHorSat,false,true);

								} else {
									for (int k = S_SlotRowNoT; k <= E_SlotRowNoT; k++) {
										setBackgroundColor(tempBkgColorData, k, colnoT, null,null,isPHorSat,false,true);
									}
								}
							}
						}
					}
				}
				QueryUtil.executeMasterBrowse(getUserInfo(), "REHABDVATABLELIST", new String[] {dvStartDate},
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
										colno = getRoomId2Col((String) row[SchCol_DOCCODE]); //assign column
										if (colno > -1) {
											slotRow = getRtnSlotRowNo(String.valueOf(row[SchCol_ASDATE]), String.valueOf(row[SchCol_AEDATE]), dvStartDate);
											S_SlotRowNo = slotRow[0];
											E_SlotRowNo = slotRow[1];

											String appointSts = String.valueOf(row[SchCol_ASTS]);
											String content = "";
											if ("B".equals(appointSts)){
												content = "(BLOCKED)";
											} else {
												content = row[SchCol_BKGPNAME] + "(" + row[SchCol_REMARK] + "); ";
											}


											if (S_SlotRowNo == E_SlotRowNo) {
												temp.setLength(0);
												temp.append((String) tempTextData.get(S_SlotRowNo).getValue(colno));
												String con = (String) tempTextData.get(S_SlotRowNo).getValue(colno)+content;
												if (temp.length() > 0) { //append content if there exist content in cell
													String t = con.replaceAll(";", "");
													int occ = (con.length() - t.length());
													temp.setLength(0);
													temp.append(Integer.toString(occ)+" bookings"+":"+con);
													isMulti = true;
												} else {
													temp.append(content);
													isMulti = false;
												}
												tempTextData.get(S_SlotRowNo).setValue(colno, temp.toString());
												//setCellColor(tempTxtColorData, S_SlotRowNo, colno, row[1].toString());
												setBackgroundColor(tempBkgColorData, S_SlotRowNo, colno, null,appointSts,isPHorSat,isMulti,false);
												setAddDeptAID(S_SlotRowNo, colno, row[SchCol_AID].toString());
											} else {

												for (int k = S_SlotRowNo; k <= E_SlotRowNo; k++) {
														temp.setLength(0);
														temp.append((String) tempTextData.get(k).getValue(colno));
														String con = null;
														if (tempTextData.get(S_SlotRowNo).getValue(colno).toString().indexOf(content) < 0) {
															con = (String) tempTextData.get(S_SlotRowNo).getValue(colno)+content;
														} else {
															con = (String) tempTextData.get(S_SlotRowNo).getValue(colno);
														}
														if (temp.toString().length() > 0) { //append content if there exist content in cell
															String t = con.replace(";", "");
															int occ = (con.length() - t.length());
															temp.setLength(0);
															temp.append(Integer.toString(occ)+" bookings"+":"+con);
															isMulti = true;
														} else {
															temp.append(content);
															isMulti = false;
														}
														tempTextData.get(k).setValue(colno, temp.toString());

													//setCellColor(tempTxtColorData, k, colno, row[1].toString());
													setBackgroundColor(tempBkgColorData, k, colno, null,appointSts,isPHorSat,isMulti,false);
													setAddDeptAID(k, colno, row[0].toString());
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

	private int[] getRtnSlotRowNo(String appSTime, String appETime, String dCurDate) {

		int SlotNo1 = DateTimeUtil.timeDiff(DEFAULT_HOURS, appSTime.substring(11, 16)) / Integer.parseInt(getSysParameter("rehabTUnit"));
		int SlotNo2 = DateTimeUtil.timeDiff(DEFAULT_HOURS, appETime.substring(11, 16)) / Integer.parseInt(getSysParameter("rehabTUnit"));
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

	private void setBackgroundColor(List<TableData> bkgColorData, int rowNo, int colNo, String specBook, String appSts, String isPHorSat,
			boolean isMultiBooking,boolean isSchedule) {
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
		/*if("1".equals(specBook)){
			bgcolor = bkgColorTemplate[1];
			if("F".equals(appSts)) {
				bgcolor = bkgColorTemplate[10];
			}
		}*/
		if (isSchedule) {
			bgcolor = bkgColorTemplate[12];
		}
		if(isMultiBooking) {
			bgcolor = bkgColorTemplate[1];
		}
		if(!bkgColorTemplate[10].equals(bkgColorData.get(rowNo).getValue(colNo))){
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
					} else if (cell.getClassName().contains("ot-cell-bkgcolorWhite")){
						cell.removeClassName("ot-cell-bkgcolor10");
					}  else {
						cell.addClassName("ot-cell-bkgcolor10");
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
		int timeUnit = Integer.parseInt(getSysParameter("rehabTUnit"));
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
					hour = String.valueOf(h);}
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
//      DVATable = null; // reset table to feed dynamic column names and widths
		getDVATable().getStore().removeAll();
		getDVATable().getView().refresh(true);
		getDVATable().getView().setSortingEnabled(false);

//		DVATableRefresh(, true);

			getDVAJScrollPane().setViewportView(getDVATable());
			getDVAJScrollPane().layout();
			getDVPanel().layout();
	}

	private void initDVATableColumns() {
		QueryUtil.executeMasterBrowse(getUserInfo(), "DEPT_ROOM",
				new String[] { "RH", "" },
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
					columnWidths[0] = 40;
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


	private void resetBookingEntry() {
		getPatientNo().resetText();
		getSex().resetText();
		getNames().resetText();
		getPhoneH().resetText();
		getPhoneM().resetText();
		getSession().setText(ONE_VALUE);
		getRemark().resetText();
		getSource().resetText();
		getAlert().resetText();

		memIsOverrideBooking = false;
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

	private void doChangeBookingDetail() {
		if (getCPatTel().isEmpty() && getCPatMTel().isEmpty()) {
			Factory.getInstance().addErrorMessage("Missing Patient Telephone No/Mobile Phone.", "PBA - [Appointment Browse]", getCPatTel());
		} else if (getCPatName().isEmpty()) {
			Factory.getInstance().addErrorMessage("Missing Patient Name.", "PBA - [Appointment Browse]", getCPatTel());
		}else {
			doChangeBookingDetailHelper(EMPTY_VALUE);
		}
	}

	private void doChangeBookingDetailHelper(String isUpdatePatientSMS) {
		QueryUtil.executeMasterAction(getUserInfo(), ConstantsTx.BOOKINGCHANGE_TXCODE, QueryUtil.ACTION_APPEND,
				new String[] {
					getDVBTable().getSelectedCellContent(DVBCol_BKGID),
					getCPatNo().getText().trim(),
					getCPatName().getText().trim(),
					getCPatCName().getText().trim(),
					getCPatTel().getText().trim(),
					getCPatMTel().getText().trim(),
					getCRemark().getText().trim(),
					null,
					null,
					null,
					null,
					null,
					null,
					null,
					null,
					null,
					getUserInfo().getUserID()
					//--------------------------------------
				},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					if ("2".equals(mQueue.getReturnCode())) {
						MessageBoxBase.addWarningMessage(
								"PBA - [Dental App]",
								mQueue.getReturnMsg(),
								new Listener<MessageBoxEvent>() {
									public void handleEvent(MessageBoxEvent be) {
										doChangeBookingDetailHelperSuccess();
									}
								});
					} else {
						doChangeBookingDetailHelperSuccess();
					}
				} else {
					Factory.getInstance().addErrorMessage(mQueue.getReturnMsg(), "PBA - [Appointment Browse]");
				}
			}
		});
	}

	private void doChangeBookingDetailHelperSuccess() {
		searchAction();
		getChangeBookingDialog().dispose();
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
			DVPanel.setBounds(5, 5, 790, 480);
			DVPanel.add(getDVStartDateDesc(), null);
			DVPanel.add(getPrevDate(), null);
			DVPanel.add(getDVStartDate(), null);
			DVPanel.add(getNextDate(), null);
			DVPanel.add(getFromDateDesc(), null);
			DVPanel.add(getFromDate(), null);
			DVPanel.add(getToDateDesc(), null);
			DVPanel.add(getToDate(), null);
			DVPanel.add(getDrCodeDesc(), null);
			DVPanel.add(getDrCode(), null);
			DVPanel.add(getIncludeBlockedDesc(), null);
			DVPanel.add(getIncludeBlocked(), null);
			DVPanel.add(getSortByTimeDesc(), null);
			DVPanel.add(getSortByTime(), null);
			DVPanel.add(getOnlyRehabDesc(), null);
			DVPanel.add(getOnlyRehab(), null);
			DVPanel.add(getOnlyBlockedDesc(), null);
			DVPanel.add(getOnlyBlocked(), null);
			DVPanel.add(getDVAJScrollPane(), null);
			DVPanel.add(getSchedulePanel(), null);
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
//						QueryUtil.executeMasterFetch(getUserInfo(), "CHECKDEPTAPPPHORSAT",
//								new String[] {DVStartDate.getText()},
//								new MessageQueueCallBack() {
//							public void onPostSuccess(MessageQueue mQueue) {
//								if (mQueue.success()) {
//									if(!"".equals(mQueue.getContentField()[0]) && mQueue.getContentField()[0] != null) {
//										isPHorSat = mQueue.getContentField()[0];
//									} else {
//										isPHorSat = null;
//									}
//									onDVStartDateChange();
//								}
//							}});
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
//						QueryUtil.executeMasterFetch(getUserInfo(), "CHECKDEPTAPPPHORSAT",
//								new String[] {DVStartDate.getText()},
//								new MessageQueueCallBack() {
//							public void onPostSuccess(MessageQueue mQueue) {
//								if (mQueue.success()) {
//									if(!"".equals(mQueue.getContentField()[0]) && mQueue.getContentField()[0] != null) {
//										isPHorSat = mQueue.getContentField()[0];
//									} else {
//										isPHorSat = null;
//									}
//									onDVStartDateChange();
//								}
//							}});
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
			selectedTimeDesc.setBounds(260, 10, 100, 20);
		}
		return selectedTimeDesc;
	}

	private TextReadOnly getSelectedTime() {
		if (selectedTime == null) {
			selectedTime = new TextReadOnly();
			selectedTime.setBounds(350, 10, 86, 20);
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
			DVAJScrollPane.setBounds(10, 80, 290, 270);
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
			DVBJScrollPane.setBounds(10, 360, 790, 120);
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
			rightBtmPanel.add(getPatientNoDesc(), null);
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
			rightBtmPanel.add(getSource(), null);
			rightBtmPanel.add(getAppBrowseAction(),null);
			rightBtmPanel.add(getWalkInAction(),null);
			rightBtmPanel.add(getEditAppAction(),null);
			rightBtmPanel.add(getCancelAppAction(),null);
			rightBtmPanel.add(getConfirmAppAction(),null);
			rightBtmPanel.add(getChangeAppDetailAction(),null);

			rightBtmPanel.setBounds(10, 480, 786, 130);
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

	private TextPatientNoSearch getPatientNo() {
		if (patientNo == null) {
			patientNo = new TextPatientNoSearch() {
				@Override
				public void onFocus() {
					if (getTslotListTable().getView().getBody().getScrollTop() > tslotLastScrollTop ||
							getTslotListTable().getView().getBody().getScrollTop() +
							getTslotListTable().getHeight() - 80 < tslotLastScrollTop) {
						getTslotListTable().getView().getBody().setScrollTop(tslotLastScrollTop);
					}
				}

				@Override
				public void onReleased() {
					if (getScheduleTable().getSelectionModel().getSelectedItems().size() <= 0) {
						resetBookingEntry();
						Factory.getInstance().addErrorMessage("No backdate booking is allowed.", "PBA - [Doctor Appointment]", null, getScheduleTable());
					} else if (getScheduleTable().getSelectionModel().getSelectedItems().size() > 0) {
						if (DateTimeUtil.compareTo(memCurrDT, getDate(getScheduleTable().getSelectedRowContent()[GrdPb_timeFrom].toString(), 10)) > 0) {
							resetBookingEntry();
							Factory.getInstance().addErrorMessage("No backdate booking is allowed.", "PBA - [Doctor Appointment]", null, getScheduleTable());
						} else if ("B".equals(getScheduleTable().getSelectedRowContent()[GrdPb_status])) {
							resetBookingEntry();
							Factory.getInstance().addErrorMessage("Schedule already blocked.", "PBA - [Schedule Blocking]", null, getScheduleTable());
						}
					}
				}

				@Override
				public void onBlur() {
					// clear fields
//					getNames().resetText();
//					getPhoneH().resetText();
//					getPhoneM().resetText();

					if (!getPatientNo().isEmpty()) {
						QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.PATIENT_TXCODE,
								new String[] { getPatientNo().getText().trim() },
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									final String[] para = mQueue.getContentField();
									if (para.length > 0) {
										String patNO= para[PATIENT_NUMBER];
										// only check for TWAH
/*										if (ONE_VALUE.equals(getDocLocation().getText().trim()) && "TWAH".equals(getUserInfo().getSiteCode())) {
											checkTodayApp(patNO);
										}*/
										if (para[PATIENT_DEATH] != null && para[PATIENT_DEATH].trim().length() > 0) {
											MessageBox mb =
												MessageBoxBase.confirm("PBA - [Doctor Appointment]",
														MSG_PATIENT_DEATH,
														new Listener<MessageBoxEvent>() {
													@Override
													public void handleEvent(MessageBoxEvent be) {
														if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
															getSex().setText(para[PATIENT_SEX] + SLASH_VALUE + para[PATIENT_AGE]);
															getNames().setText(para[PATIENT_FAMILY_NAME] + SPACE_VALUE + para[PATIENT_GIVEN_NAME]);
															getPhoneH().setText(para[PATIENT_HOME_PHONE]);
															getPhoneM().setText(para[PATIENT_MOBILE_PHONE]);

															// call alert
															onSuperBlur();
														} else {
															getPatientNo().resetText();
															getSex().resetText();
															getNames().resetText();
															getPhoneH().resetText();
															getPhoneM().resetText();
															getRemark().resetText();
														}
														//defaultFocus();
													}
												});

											mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
										} else {
											getSex().setText(para[PATIENT_SEX] + SLASH_VALUE + para[PATIENT_AGE]);
											getNames().setText(para[PATIENT_FAMILY_NAME] + SPACE_VALUE + para[PATIENT_GIVEN_NAME]);
											getPhoneH().setText(para[PATIENT_HOME_PHONE]);
											getPhoneM().setText(para[PATIENT_MOBILE_PHONE]);

											// call alert
											onSuperBlur();
										}
									} else {
										onSuperBlur();
										//getPatientNo().resetText();
									}
								} else {
									onSuperBlur();
									//getPatientNo().resetText();
								}
							}
						});
					}
				};

				private void onSuperBlur() {
					super.onBlur();
/*					checkStaff();
					checkNewPatient();*/
				}
			};
			patientNo.setBounds(70, 5, 75, 20);
		}
		return patientNo;
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


	// Info dialog start
	private DlgLabelPrint getInfoDialog() {
		if (infoDialog == null) {
			infoDialog = new DlgLabelPrint(getMainFrame()) {

				@Override
				public void setVisible(boolean visible) {
					super.getWalkIn().setVisible(false);
					super.getWalkInDESC().setVisible(false);
					super.setVisible(visible);
					if (!visible) {
						searchAction();
						resetBookingEntry();
						getCurBKID().resetText();
						super.setVisible(false);
					}
				}

				@Override
				public void doPrintCCL() {
					final String tempPatno = getPatientNo().getText().trim();
					final String tempPatname = getNames().getText().trim();

					QueryUtil.executeMasterFetch(getUserInfo(), "MEDREC_FILL_PAPERPRI",
							new String[] { tempPatno },
							new MessageQueueCallBack() {
						public void onPostSuccess(final MessageQueue mQueue) {
							if (mQueue.success()) {

								int temp = Integer.parseInt(mQueue.getContentField()[5]);
								if (temp <= 0) {
									mrhvollab = "00";
								} else {
									mrhvollab = mQueue.getContentField()[5];
								}

								if (getSysParameter("LBLTYP") != null &&
										"A".equals(getSysParameter("LBLTYP").toUpperCase())) {
									int appLabNum = 0;
									try {
										appLabNum = Integer.parseInt(getSysParameter("AppLabNum"));
									} catch (Exception e) {
									}

									if (appLabNum > 0) {
										printPickLstLblNewApp(mrhvollab);
									} else {
										Factory.getInstance().addInformationMessage("Appointment label number is not set.", null, getDefaultFocusComponent());
									}
								} else {
									final HashMap<String, String> map = new HashMap<String, String>();
									map.put("bkgsDate", getTime().getText().substring(0, getTime().getText().length()-3));
									map.put("SteName", getUserInfo().getSiteName());
									map.put("Volume",  mrhvollab == null?SPACE_VALUE:"("+mrhvollab + ")");
									map.put("walkin", getWalkIn().getValue()?"WI":(getHomeVisit().getValue()?"HV":""));
									map.put("pcName", CommonUtil.getComputerName());

									if (Factory.getInstance().getSysParameter("CLCHARTLOG").equals("Y")) {
										if (mrhvollab == null ||  mrhvollab.length() == 0) {
											Factory.getInstance().addErrorMessage("It does not have any medical chart");
											return;
										}

										QueryUtil.executeMasterAction(
												Factory.getInstance().getUserInfo(),
												ConstantsTx.MEDRECDTL_TXCODE, QueryUtil.ACTION_APPEND,
												new String[] {
													memDoctorCode,
													EMPTY_VALUE,
													"Appointment",
													Factory.getInstance().getUserInfo().getUserID(),
													CommonUtil.getComputerName(),
													mrhvollab == null?SPACE_VALUE:mrhvollab,
													tempPatno
												},
												new MessageQueueCallBack() {
													@Override
													public void onPostSuccess(MessageQueue mQueue) {
														if (mQueue.success()) {
															PrintingUtil.print(getMainFrame().getSysParameter("PRTRMEDLBL"),
																	"RegPrtCallChtDrApp", map, null,
																	 new String[]{
																			tempPatname,
																			tempPatno,
																			getUserInfo().getSiteCode(),
																			getDocCode(),
																			newBkgID,
																			"",
																			getMainFrame().getSysParameter("AppLabNum")
																	},
																new String[]{"bkgname","patno","patnoA",
																			 "patnoB","patnoC","patnoD",
																			 "patnoE","docName","docCode",
																			 "spcname",
																			 "bkgsdate2","bkgsdate","stename",
																			  "isStaff","alert","userID"
																			 }, 2);
														}
													}
												});
										} else {
											PrintingUtil.print(getMainFrame().getSysParameter("PRTRMEDLBL"),
													"RegPrtCallChtDrApp", map, null,
													 new String[]{
															tempPatname,
															tempPatno,
															getUserInfo().getSiteCode(),
															getDocCode(),
															newBkgID,
															"",
															getMainFrame().getSysParameter("AppLabNum")
													},
												new String[]{"bkgname","patno","patnoA",
															 "patnoB","patnoC","patnoD",
															 "patnoE","docName","docCode",
															 "spcname",
															 "bkgsdate2","bkgsdate","stename",
															  "isStaff","alert","userID"
															 }, 2);
										}
									}
							}
						}
					});
					setVisible(false);
				}

				@Override
				public void doPrintAppLbl() {
					HashMap<String, String> map = new HashMap<String, String>();
					map.put("otherLblDtl", "");
					PrintingUtil.print(getSysParameter("PRTRLBL"), "APP2DBARCODE",
							map, "",
							new String[] {
								getPatientNo().getText().trim(),
								getTslotListTable().getSelectedRowContent()[0],
								getTslotListTable().getSelectedRowContent()[1],
								getCurBKID().getText(),
								getUserInfo().getUserID()},
							new String[] {
									"patno", "patname", "patcname", "appointdate",
									"docname", "barcode", "chiAppointDate"
							});
					if (YES_VALUE.equals(Factory.getInstance().getSysParameter("CLAPPLBL"))) {
						setVisible(false);
					}
				}
			};
		}
		return infoDialog;
	}

	private void printPickLstLblNewApp(final String volNum) {
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] {
					"BOOKING B, SCHEDULE S, DOCTOR D, SITE SIT",
					"SIT.STENAME, S.DOCCODE, D.DOCFNAME, D.DOCGNAME, TO_CHAR(B.BKGSDATE, 'DD/MM/YYYY'), "+
						"TO_CHAR(B.BKGSDATE, 'HH24:MI') AS STRBKGSDT, B.PATNO, B.BKGPNAME, "+
						"B.BKGPTEL, B.BKGSCNT, B.BKGCDATE, TO_CHAR(B.BKGCDATE, 'HH24:MI') AS STRBKGCDT, "+
						"B.USRID",
					"B.STECODE = SIT.STECODE AND B.SCHID = S.SCHID AND S.DOCCODE = D.DOCCODE "+
					"AND BKGID = '"+newBkgID+"'"
				},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					boolean isAsterisk = getSysParameter("Chk*").equals("YES");
					final String docCode = mQueue.getContentField()[1];
					final String docName = mQueue.getContentField()[2] + SPACE_VALUE + mQueue.getContentField()[3];
					final String timeDate = mQueue.getContentField()[5] + "("+mQueue.getContentField()[4] + ")" + (isAsterisk?" *":"");
					final String patNo = mQueue.getContentField()[6];
					final String patName = mQueue.getContentField()[7];

					QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] {
								"MEDRECHDR H, MEDRECDTL D, MEDRECLOC L, DOCTOR DOC",
								"H.PATNO || '/' || H.MRHVOLLAB AS MEDRECID, L.MRLDESC AS LOCATION, "+
								"H.MRHVOLLAB AS VOLNUMBER, DOC.DOCFNAME || ' ' || DOC.DOCGNAME AS DOCNAME",
								"H.PATNO = '"+patNo+"' "+
								"AND D.DOCCODE = DOC.DOCCODE(+) "+
								"AND H.MRHVOLLAB = "+
										"( "+
											"SELECT MAX(MRHVOLLAB) AS MAXVOL "+
											"FROM MEDRECHDR "+
											"WHERE PATNO = H.PATNO "+
											"AND MRHSTS = 'N' "+
										") "+
								"AND H.MRDID = D.MRDID "+
								"AND NVL(D.MRLID_R, MRLID_L) = L.MRLID "
							},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							String location = "";
							String sendTo = "OPD";
							if (mQueue.success()) {
								location = mQueue.getContentField()[1];
								if (mQueue.getContentField()[3].length() > 1) {
									location += "("+mQueue.getContentField()[3]+")";
								}

								final HashMap<String, String> map = new HashMap<String, String>();
								map.put("DOCNAME", docName);
								map.put("BKGSDATE", timeDate);
								map.put("PATNO", patNo);
								map.put("VOLNUM", volNum);
								map.put("PATNAME", patName);
								map.put("LOCATION", location);
								map.put("SENDTO", sendTo);

								if (Factory.getInstance().getSysParameter("CLCHARTLOG").equals("Y")) {
									if (volNum == null ||  volNum.length() == 0) {
										Factory.getInstance().addErrorMessage("It does not have any medical chart");
										return;
									}

									QueryUtil.executeMasterAction(
											Factory.getInstance().getUserInfo(),
											ConstantsTx.MEDRECDTL_TXCODE, QueryUtil.ACTION_APPEND,
											new String[] {
												docCode,
												EMPTY_VALUE,
												"Appointment",
												Factory.getInstance().getUserInfo().getUserID(),
												CommonUtil.getComputerName(),
												volNum,
												patNo
											},
											new MessageQueueCallBack() {
												@Override
												public void onPostSuccess(MessageQueue mQueue) {
													if (mQueue.success()) {
														PrintingUtil.print(getSysParameter("PRTRMEDLBL"),
																"PickLslLblNewAppointment",map,null);
													}
												}
											});
								}
								else {
									PrintingUtil.print(getSysParameter("PRTRMEDLBL"),
											"PickLslLblNewAppointment",map,null);
								}
							} else {
								Factory.getInstance()
									.addErrorMessage("Printing is failed. ",
													 "PBA - [Doctor Appointment]");
							}
						}
					});
				} else {
					Factory.getInstance()
						.addErrorMessage("Printing is failed. ",
										 "PBA - [Doctor Appointment]");
				}
			}
		});
	}

	private LabelSmallBase getSourceDesc() {
		if (sourceDesc == null) {
			sourceDesc = new LabelSmallBase();
			sourceDesc.setText("Source");
			sourceDesc.setBounds(325, 60, 50, 20);
		}
		return sourceDesc;
	}

	protected ComboBoxBase getSource() {
		if (source == null) {
			source = new ComboBoxBase("BOOKINGSRC", false, false, true);
			source.setBounds(365, 60, 158, 20);
		}
		return source;
	}

	private LabelSmallBase getSMSContentDesc() {
		if (SMSContentDesc == null) {
			SMSContentDesc = new LabelSmallBase();
			SMSContentDesc.setText("SMS Message Content");
			SMSContentDesc.setBounds(5, 60, 130, 20);
		}
		return SMSContentDesc;
	}

	private ComboBoxBase getSMSContent() {
		if (SMSContent == null) {
			SMSContent = new ComboBoxBase("SMSCONTENT", false, false, true);
			SMSContent.setBounds(130, 60, 190, 20);
		}
		return SMSContent;
	}

	private LabelSmallBase getAlertDesc() {
		if (alertDesc == null) {
			alertDesc = new LabelSmallBase();
			alertDesc.setText("Initial Assessed");
			alertDesc.setBounds(530, 60, 100, 20);
		}
		return alertDesc;
	}

	private ComboBoxBase getAlert() {
		if (alert == null) {
			alert = new ComboBoxBase("ALERTSRC", false, false, true);
			alert.setBounds(610, 60, 158, 20);
		}
		return alert;
	}

	private ButtonBase getConfirmAppAction() {
		if (confirmAppAction == null) {
			confirmAppAction = new ButtonBase() {
				@Override
				public void onClick() {
					confirmApp();
				}
			};
			confirmAppAction.setText("Check-in");
			confirmAppAction.setBounds(5, 90, 123, 30);
		}
		return confirmAppAction;
	}

	private ButtonBase getCancelAppAction() {
		if (cancelAppAction == null) {
			cancelAppAction = new ButtonBase() {
				@Override
				public void onClick() {
					cancelAppointmentPre();
				}
			};
			cancelAppAction.setText("Cancel Appointment", 'C');
			cancelAppAction.setBounds(130, 90, 123, 30);
		}
		return cancelAppAction;
	}

	private ButtonBase getEditAppAction() {
		if (editAppAction == null) {
			editAppAction = new ButtonBase() {
				@Override
				public void onClick() {
					editAppointment();
				}
			};
			editAppAction.setText("Edit Appointment",'E');
			editAppAction.setBounds(255, 90, 133, 30);
		}
		return editAppAction;
	}

	private ButtonBase getChangeAppDetailAction() {
		if (changeAppDetailAction == null) {
			changeAppDetailAction = new ButtonBase() {
				@Override
				public void onClick() {
					changeBookingDetail();
				}
			};
			changeAppDetailAction.setText("Change Booking Detail");
			changeAppDetailAction.setBounds(390, 90, 133, 30);
		}
		return changeAppDetailAction;
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
			walkInAction.setBounds(525, 90, 80, 30);
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
			appBrowseAction.setBounds(610, 90, 145, 30);
		}
		return appBrowseAction;
	}



	protected void showAppointmentBrowsePanel() {
		if (getDVBTable().getRowCount() > 0) {
			if (getDVBTable().getSelectedRow() == 0) {
				setParameter("qPATNO", getDVBTable().getSelectedRowContent()[DVBCol_PATNO]);
				setParameter("qLocation", getDVBTable().getSelectedRowContent()[DVBCol_LOCID]);
				setParameter("fromWellBaby","Y");
			}
		}
		showPanel(new AppointmentBrowse());
	}

	private Menu getPopupMenu() {
		if (contextMenu == null) {
			contextMenu = new Menu();

			// set context menu
			contextMenu.setWidth(140);
			contextMenu.add(getCancelBookingMenu());
			contextMenu.add(getEditBookingMenu());
			contextMenu.add(getConfirmBookingMenu());
			contextMenu.add(getChangeBookingDetailMenu());
		}
		return contextMenu;
	}

	private MenuItemBase getCancelBookingMenu() {
		if (cancelBookingMenu == null) {
			cancelBookingMenu = new MenuItemBase();
			cancelBookingMenu.setText("Cancel Appointment");
			cancelBookingMenu.setIcon(Resources.ICONS.delete());
			cancelBookingMenu.addSelectionListener(new SelectionListener<MenuEvent>() {
				public void componentSelected(MenuEvent ce) {
					cancelAppointmentPre();
				}
			});
		}
		return cancelBookingMenu;
	}

	private MenuItemBase getEditBookingMenu() {
		if (editBookingMenu == null) {
			editBookingMenu = new MenuItemBase();
			editBookingMenu.setText("Edit Appointment");
			editBookingMenu.setIcon(Resources.ICONS.edit());
			editBookingMenu.addSelectionListener(new SelectionListener<MenuEvent>() {
				public void componentSelected(MenuEvent ce) {
					editAppointment();
				}
			});
		}
		return editBookingMenu;
	}


	private MenuItemBase getConfirmBookingMenu() {
		if (confirmBookingMenu == null) {
			confirmBookingMenu = new MenuItemBase();
			confirmBookingMenu.setText("Confirm Booking");
			confirmBookingMenu.setIcon(Resources.ICONS.accept());
			confirmBookingMenu.addSelectionListener(new SelectionListener<MenuEvent>() {
				public void componentSelected(MenuEvent ce) {
					confirmApp();
				}
			});
		}
		return confirmBookingMenu;
	}

	private MenuItemBase getChangeBookingDetailMenu() {
		if (changeBookingDetailMenu == null) {
			changeBookingDetailMenu = new MenuItemBase();
			changeBookingDetailMenu.setText("Change Booking Detail");
			changeBookingDetailMenu.setIcon(Resources.ICONS.save());
			changeBookingDetailMenu.addSelectionListener(new SelectionListener<MenuEvent>() {
				public void componentSelected(MenuEvent ce) {
					changeBookingDetail();
				}
			});
		}
		return changeBookingDetailMenu;
	}

	private DialogBase getChangeBookingDialog() {
		if (changeBookingDialog == null) {
			changeBookingDialog = new DialogBase() {
				public TextString getDefaultFocusComponent() {
					return getCPatTel();
				}
			};
			changeBookingDialog.setLayout(null);
			changeBookingDialog.setBounds(300, 100, 400, 230);
			changeBookingDialog.setTitle("Change Booking Detail");
			changeBookingDialog.add(getChangeBookingPanel(), null);
		}
		return changeBookingDialog;
	}

	private BasePanel getChangeBookingPanel() {
		if (changeBookingPanel == null) {
			changeBookingPanel = new BasePanel();
			changeBookingPanel.setBounds(5, 5, 375, 230);
			changeBookingPanel.add(getCPatNoDESC(), null);
			changeBookingPanel.add(getCPatNo(), null);
			changeBookingPanel.add(getCPatNameDESC() , null);
			changeBookingPanel.add(getCPatName(), null);
			changeBookingPanel.add(getCPatCNameDESC(), null);
			changeBookingPanel.add(getCPatCName(), null);
			changeBookingPanel.add(getCPatTelDESC(), null);
			changeBookingPanel.add(getCPatTel(), null);
			changeBookingPanel.add(getCPatMTelDESC(), null);
			changeBookingPanel.add(getCPatMTel(), null);
			changeBookingPanel.add(getCRemarkDESC(), null);
			changeBookingPanel.add(getCRemark(), null);
			changeBookingPanel.add(getChange(), null);
			changeBookingPanel.add(getCancel(), null);
		}
		return changeBookingPanel;
	}

	private LabelSmallBase getCPatNoDESC() {
		if (cPatNoDESC == null) {
			cPatNoDESC = new LabelSmallBase();
			cPatNoDESC.setBounds(5, 5, 150, 20);
			cPatNoDESC.setText("Patient Number");
		}
		return cPatNoDESC;
	}

	private TextReadOnly getCPatNo() {
		if (cPatNo == null) {
			cPatNo = new TextReadOnly();
			cPatNo.setBounds(160, 5, 210, 20);
		}
		return cPatNo;
	}

	private LabelSmallBase getCPatNameDESC() {
		if (cPatNameDESC == null) {
			cPatNameDESC = new LabelSmallBase();
			cPatNameDESC.setBounds(5, 30, 150, 20);
			cPatNameDESC.setText("Patient Name");
		}
		return cPatNameDESC;
	}

	private TextReadOnly getCPatName() {
		if (cPatName == null) {
			cPatName = new TextReadOnly();
			cPatName.setBounds(160, 30, 210, 20);
		}
		return cPatName;
	}

	private LabelSmallBase getCPatCNameDESC() {
		if (cPatCNameDESC == null) {
			cPatCNameDESC = new LabelSmallBase();
			cPatCNameDESC.setBounds(5, 55, 150, 20);
			cPatCNameDESC.setText("Patient Chinese Name");
		}
		return cPatCNameDESC;
	}

	private TextReadOnly getCPatCName() {
		if (cPatCName == null) {
			cPatCName = new TextReadOnly();
			cPatCName.setBounds(160, 55, 210, 20);
		}
		return cPatCName;
	}

	private LabelSmallBase getCPatTelDESC() {
		if (cPatTelDESC == null) {
			cPatTelDESC = new LabelSmallBase();
			cPatTelDESC.setBounds(5, 80, 150, 20);
			cPatTelDESC.setText("Patient Telephone No");
		}
		return cPatTelDESC;
	}

	private TextString getCPatTel() {
		if (cPatTel == null) {
			cPatTel = new TextString();
			cPatTel.setBounds(160, 80, 210, 20);
		}
		return cPatTel;
	}

	private LabelSmallBase getCPatMTelDESC() {
		if (cPatMTelDESC == null) {
			cPatMTelDESC = new LabelSmallBase();
			cPatMTelDESC.setBounds(5, 105, 150, 20);
			cPatMTelDESC.setText("Patient Mobile Phone");
		}
		return cPatMTelDESC;
	}

	private TextString getCPatMTel() {
		if (cPatMTel == null) {
			cPatMTel = new TextString();
			cPatMTel.setBounds(160, 105, 210, 20);
		}
		return cPatMTel;
	}

	private LabelSmallBase getCRemarkDESC() {
		if (cRemarkDESC == null) {
			cRemarkDESC = new LabelSmallBase();
			cRemarkDESC.setBounds(5, 130, 150, 20);
			cRemarkDESC.setText("Remark");
		}
		return cRemarkDESC;
	}

	private TextString getCRemark() {
		if (cRemark == null) {
			cRemark = new TextString(175);
			cRemark.setBounds(160, 130, 210, 20);
		}
		return cRemark;
	}


	private ButtonBase getChange() {
		if (change == null) {
			change = new ButtonBase() {
				@Override
				public void onClick() {
					doChangeBookingDetail();
				}
			};
			change.setBounds(95, 160, 80, 25);
			change.setText("Change");
		}
		return change;
	}

	private ButtonBase getCancel() {
		if (cancel == null) {
			cancel = new ButtonBase() {
				@Override
				public void onClick() {
					getChangeBookingDialog().dispose();
				}
			};
			cancel.setBounds(180, 160, 80, 25);
			cancel.setText("Cancel");
		}
		return cancel;
	}

	@Override
	protected String[] getFetchInputParameters() {
		// TODO Auto-generated method stub
		return null;
	}

	private LabelSmallBase getOnlyBlockedDesc() {
		if (onlyBlockedDesc == null) {
			onlyBlockedDesc = new LabelSmallBase();
			onlyBlockedDesc.setText("Only Blocked");
			onlyBlockedDesc.setBounds(680, 3, 90, 20);
			onlyBlockedDesc.setOptionalLabel();
		}
		return onlyBlockedDesc;
	}

	public CheckBoxBase getOnlyBlocked() {
		if (onlyBlocked == null) {
			onlyBlocked = new CheckBoxBase();
			onlyBlocked.setBounds(765, 3, 30, 20);
		}
		return onlyBlocked;
	}

	private LabelSmallBase getIncludeBlockedDesc() {
		if (includeBlockedDesc == null) {
			includeBlockedDesc = new LabelSmallBase();
			includeBlockedDesc.setText("Include Blocked");
			includeBlockedDesc.setBounds(680, 19, 90, 20);
			includeBlockedDesc.setOptionalLabel();
		}
		return includeBlockedDesc;
	}

	public CheckBoxBase getIncludeBlocked() {
		if (includeBlocked == null) {
			includeBlocked = new CheckBoxBase();
			includeBlocked.setBounds(765, 19, 30, 20);
		}
		return includeBlocked;
	}

	private LabelSmallBase getSortByTimeDesc() {
		if (sortByTimeDesc == null) {
			sortByTimeDesc = new LabelSmallBase();
			sortByTimeDesc.setText("Sort By Time");
			sortByTimeDesc.setBounds(680, 35, 90, 20);
			sortByTimeDesc.setOptionalLabel();
		}
		return sortByTimeDesc;
	}

	public CheckBoxBase getSortByTime() {
		if (onlyRehab == null) {
			onlyRehab = new CheckBoxBase();
			onlyRehab.setBounds(765, 35, 30, 20);
		}
		return onlyRehab;
	}
	private LabelSmallBase getOnlyRehabDesc() {
		if (onlyRehabDesc == null) {
			onlyRehabDesc = new LabelSmallBase();
			onlyRehabDesc.setText("Only Rehab");
			onlyRehabDesc.setBounds(680, 51, 90, 20);
			onlyRehabDesc.setOptionalLabel();
		}
		return onlyRehabDesc;
	}

	public CheckBoxBase getOnlyRehab() {
		if (sortByTime == null) {
			sortByTime = new CheckBoxBase();
			sortByTime.setBounds(765, 51, 30, 20);
		}
		return sortByTime;
	}

	private DlgPrintAppList getDlgPrintAppList() {
		if (dlgPrintAppListing == null) {
			dlgPrintAppListing = new DlgPrintAppList(getMainFrame()){
				@Override
				public boolean printRpt() {

					Map<String, String> map = new HashMap<String, String>();
					map.put("SiteName", getUserInfo().getSiteName());

					if (getBookingDateFrom().getText().length()==0) {
						Factory.getInstance().addErrorMessage("Please supply Booking Date.");
						getBookingDateFrom().focus();
						return false;
					}


					PrintingUtil.print("DentAppListing", map,null,
							new String[] {
							getBookingDateFrom().getText() + "+" + "00:00",
							getBookingDateTo().getText() + "+" + "23:59",
							getDrCode().getText()
							},
							new String[] {
									"DOCCODE",
									"DOCCODEWITHCHKDGT",
									"DOCCODEWITHOUTCHKDGT",
									"DOCNAME",
									"BKGSDATE",
									"ATIME",
									"PATNO",
									"PATNAME",
									"PATCNAME",
									"BKGPTEL",
									"BKGSCNT",
									"BKGCDATE",
									"CTIME",
									"USRID",
									"MOBILE",
									"BKGRMK",
									"OFFICETEL",
									"ALERT",
									"STENAME",
									"SMS",
									"SMSSDTOK",
									"SMSRTNMSG",
									"TESTDONE",
									"PATNO_T"
							});

					return true;
				}
			};
			dlgPrintAppListing.getDrCodeDesc().setEnabled(true);
			dlgPrintAppListing.getDrCode().setEnabled(true);
		}
		return dlgPrintAppListing;
	}
}