
package com.hkah.client.tx.schedule;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.FieldEvent;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.util.Rectangle;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.MessageBox;
import com.google.gwt.user.client.Timer;
import com.hkah.client.common.Factory;
import com.hkah.client.event.CallbackListener;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.combobox.ComboDayOfweek;
import com.hkah.client.layout.combobox.ComboDept;
import com.hkah.client.layout.combobox.ComboDoctorLocation;
import com.hkah.client.layout.combobox.ComboSpecialtyCode;
import com.hkah.client.layout.dialog.DialogBase;
import com.hkah.client.layout.dialog.DlgAddSch;
import com.hkah.client.layout.dialog.DlgBlock;
import com.hkah.client.layout.dialog.DlgChgScheduleDetail;
import com.hkah.client.layout.dialog.DlgGenerateSchedule;
import com.hkah.client.layout.dialog.DlgLabelPrint;
import com.hkah.client.layout.dialog.DlgQuotaCheck;
import com.hkah.client.layout.dialog.DlgSameDateAppAlert;
import com.hkah.client.layout.dialog.DlgSlotSearch;
import com.hkah.client.layout.dialog.DlgTodayAppAlert;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelSmallBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextDateTime;
import com.hkah.client.layout.textfield.TextDoctorSearch;
import com.hkah.client.layout.textfield.TextNum;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.layout.textfield.TextPhone;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.ActionPanel;
import com.hkah.client.tx.registration.PatientPriority;
import com.hkah.client.tx.registration.PatientUrgentCare;
import com.hkah.client.tx.registration.PatientWalkIn;
import com.hkah.client.tx.registration.RegistrationSearch;
import com.hkah.client.util.AlertCheck;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.PanelUtil;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTableColumn;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DoctorAppointment extends ActionPanel implements ConstantsMessage, ConstantsVariable, ConstantsTableColumn {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.DOCAPPOINTMENT_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.DOCAPPOINTMENT_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {EMPTY_VALUE, "Loc", "Day", "From", "To", "Code",
				"Dr. FName", "Dr. Given Name", "%", "Remarks", "Doctor Practice Remark",
				"Status", "Last user",
				"Blocked By", "Blocked Date/Time",
				"Unblocked By", "Unblocked Date/Time",
				"Modified By", "Modified Date/Time",
				"SCHLEN", "SCHCNT","RMID"};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {0, 60, 35, 100, 40, 40,
				60, 100, 40, 70, 150,
				40, 70,
				70, 120,
				80, 120,
				70, 120,
				0, 0,0};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private BasePanel actionPanel = null;

	private BasePanel rightBasePanel = null;
	private BasePanel rightTopPanel = null;
	private BasePanel rightMidPanel = null;
	private BasePanel rightBtmPanel = null;
	private BasePanel rightRightPanel = null;

	private LabelSmallBase scheduleDayDesc = null;
	private ComboDayOfweek scheduleDay = null;
	private LabelSmallBase deptDesc = null;
	private ComboDept dept = null;
	private LabelSmallBase specialtyDesc = null;
	private ComboSpecialtyCode specialty = null;
	private LabelSmallBase onlyBlockedDesc = null;
	private CheckBoxBase onlyBlocked = null;
	private LabelSmallBase dateFromDesc = null;
	private TextDateTime dateFrom = null;
	private LabelSmallBase dateToDesc = null;
	private TextDateTime dateTo = null;
	private LabelSmallBase drCodeDesc = null;
	private TextDoctorSearch drCode = null;
	private LabelSmallBase includeBlockedDesc = null;
	private CheckBoxBase includeBlocked = null;
	private LabelSmallBase sortByTimeDesc = null;
	private CheckBoxBase sortByTime = null;
	private LabelSmallBase docLocationDesc = null;
	private ComboDoctorLocation docLocation = null;
	private LabelSmallBase drRoomDesc = null;
	private TextReadOnly drRoom = null;

	private TableList tslotListTable = null;
//	private JScrollPane schScrollPane = null;
//	private JScrollPane slotScrollPane = null;
	private TableList registrationCheckListTable = null;
	private JScrollPane registrationCheckScrollPane = null;

	private LabelSmallBase patientNoDesc = null;
	private TextPatientNoSearch patientNo = null;
	private LabelSmallBase govStaffDesc = null;
	private CheckBoxBase govStaff = null;
	private boolean isGovStaff = false;
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
	private LabelSmallBase otherLblDtlDesc = null;
	private TextString otherLblDtl = null;
	private LabelSmallBase timedesc = null;
	private TextReadOnly time = null;
	private LabelSmallBase durationDesc = null;
	private TextReadOnly duration = null;
	private LabelSmallBase minsDesc = null;
	private LabelSmallBase ofAptMadeDesc = null;
	private TextReadOnly ofAptMade = null;
	private LabelSmallBase doctorDesc = null;
	private TextReadOnly doctor;
	private LabelSmallBase sourceDesc = null;
	private ComboBoxBase source = null;
	private LabelSmallBase SMSContentDesc = null;
	private ComboBoxBase SMSContent = null;
	private LabelSmallBase natureOfVisitDesc = null;
	private ComboBoxBase natureOfVisit = null;
	private LabelSmallBase alertDesc = null;
	private ComboBoxBase alert = null;
	private LabelSmallBase LMPDesc = null;
	private TextDate LMP = null;
	private LabelSmallBase EDCDesc = null;
	private TextDate EDC = null;
	private LabelSmallBase birthOrderDesc = null;
	private TextString birthOrder = null;
	private LabelSmallBase referralDoctorDesc = null;
	private TextString referralDoctor = null;
	private LabelSmallBase weeksDesc = null;
	private TextNum weeks = null;

	private LabelSmallBase alertDesc_RegCheck = null;
	private ComboBoxBase alert_RegCheck = null;

	// action button
	private ButtonBase addSchAction = null;
	private ButtonBase weekSchAction = null;
	private ButtonBase generateAction = null;
	private ButtonBase blockAction = null;
	private ButtonBase unBlockAction = null;
	private ButtonBase slotSearchAction = null;
	private ButtonBase quotaCheckAction = null;
	private ButtonBase remarkAction = null;
	private ButtonBase regCheckAction = null;
	private ButtonBase walkInAction = null;
	private ButtonBase priorityAction = null;
	private ButtonBase urgentCareAction = null;
	private ButtonBase appBrowseAcction = null;
	private ButtonBase appBrowseRmAcction = null;
	private ButtonBase panelDrAction = null;
	private ButtonBase regSearchAcction = null;
	private ButtonBase updateSchAction = null;
	
	// info start
	private DlgLabelPrint infoDialog = null;
	private String mrhvollab = null;
	// info end

	// block dialog start
	private DlgBlock blockDialog = null;
	// block dialog end

	//remark dialog start
	private DialogBase remarkDialog = null;
	private FieldSetBase remarkTopPanel = null;
	private TextString remark_update = null;
	// remark dialog end

	// dialog start
	private DlgAddSch schDialog = null;
	private DlgSlotSearch slotSearchDialog = null;
	private DlgQuotaCheck quotaCheckDialog = null;
	private DlgTodayAppAlert dlgTodayAppAlert = null;
	private DlgSameDateAppAlert dlgSameDateAppAlert = null;
	// dialog end

	//window start
	private String govUrl = null;
	//window end

	private AlertCheck alertCheck = null;

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */

	private String memScheduleID = null;
	private String memCurrdate = null;
	private String memSlotSearchTime = null;
	private boolean memIsOverrideBooking = false;
	private boolean memIsOverrideAgeLimit = false;
	private boolean memIsOverrideVaccine = false;
	private boolean memIsOverrideC19InitAsseHC = false;
	private DlgGenerateSchedule generateDialog = null;
	private DlgChgScheduleDetail chgSchDialog = null;

	private String newBkgID = "";
	private boolean isChangeBooking = false;
	private String memRLockID = null;
	private boolean isShowHomeVisit = false;
	private String memDoctorCode = null;
	private String memDoctorName = null;
	private int tslotLastScrollTop = 0;
	
	private final int GrdPb_bkgid = 0;
	private final int GrdPb_dlid = 1;
	private final int GrdPb_timeFrom = 3;
	private final int GrdPb_timeTo = 4;
	private final int GrdPb_docCode = 5;
	private final int GrdPb_docFName = 6;
	private final int GrdPb_docGName = 7;
	private final int GrdPb_percentage = 8;
	private final int GrdPb_remark = 9;
	private final int GrdPb_status = 11;
	private final int GrdPb_schlen = 19;
	private final int GrdPb_schDrRoom = 21;

	private boolean isVaccineBooking = false;

	// business method start

	/**
	 * This method initializes
	 *
	 */
	public DoctorAppointment() {
		super();
	}

	@Override
	public void performEscAction(final CallbackListener callbackListener) {
		if (isVaccineBooking) {
			MessageBoxBase.confirm("Message", "The second slot of vaccine booking is not completed, continue?",
					new Listener<MessageBoxEvent>() {
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						isVaccineBooking = false;
						performEscActionHelper(callbackListener);
					}
				}
			});
		} else {
			performEscActionHelper(callbackListener);
		}
	}

	private void performEscActionHelper(final CallbackListener callbackListener) {
		super.performEscAction(callbackListener);
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		if (HKAH_VALUE.equals(getUserInfo().getSiteCode())) {
			getNatureOfVisit().setVisible(true);
			getNatureOfVisitDesc().setVisible(true);

		} else {
			getAlertDesc().setText("Nature of Visit:");
			getSMSContent().setWidth(370);
			getNatureOfVisit().setVisible(false);
			getNatureOfVisitDesc().setVisible(false);
			getupdateSchAction().setVisible(false);

		}
		
		if (YES_VALUE.equals(getSysParameter("ISHIDEPRI"))) {
			getPriorityAction().setVisible(false);
			getAppBrowseAction().setBounds(522, 490, 110, 23);
			getAppBrowseRmAction().setBounds(635, 490, 145, 23);
		}

		memCurrdate = getMainFrame().getServerDate();
		isShowHomeVisit = YES_VALUE.equals(getSysParameter("HomeVisit"));
		PanelUtil.setAllFieldsEditable(getLeftBasePanel(), true);

		// TslotListTable
		getListTable().setColumnClass(GrdPb_dlid, new ComboDoctorLocation(), false);
		getListTable().setColumnNumber(GrdPb_percentage);
		getListTable().setColumnColor(GrdPb_remark, "red");
		getTslotListTable().setColumnNumber(4);
		getTslotListTable().setColumnColor(5, "red");
		// TslotListTable

		boolean mfmFields = !isDisableFunction("grantMFM", "schAppoint");
		if (mfmFields) {
			getRightBtmPanel().setBounds(10, 350, 760, 135);
		} else {
			getRightBtmPanel().setBounds(10, 360, 760, 110);
		}
		getLMPDesc().setVisible(mfmFields);
		getLMP().setVisible(mfmFields);
		getEDCDesc().setVisible(mfmFields);
		getEDC().setVisible(mfmFields);
		getBirthOrderDesc().setVisible(mfmFields);
		getBirthOrder().setVisible(mfmFields);
		getReferralDoctorDesc().setVisible(mfmFields);
		getReferralDoctor().setVisible(mfmFields);
		getWeeksDesc().setVisible(mfmFields);
		getWeeks().setVisible(mfmFields);
		getRightRightPanel().setVisible(false);

		getRegCheckAction().removeStyleName("button-alert");

		setNoListDB(false);
		clearAction();

		isChangeBooking = false;
		memRLockID = null;
		getDrCode().setText(getParameter("memDocCode"));
		if ("TxnDetail".equals(getParameter("From"))) {
			getDateTo().resetText();
			String patno = getParameter("PatNo");
			if (patno != null && patno.length() > 0) {
				getPatientNo().setText(patno);
				getPatientNo().onBlur();
				getDateFrom().requestFocus();
			}
		}

		if ("ChangeBooking".equals(getParameter("START_TYPE"))) {
			isChangeBooking = true;
			String patno = getParameter("BKPatNo");
			if (patno != null && patno.length() > 0) {
				getPatientNo().setText(patno);
			} else {
				getPatientNo().resetText();
				getNames().setText(getParameter("PatName"));
				getPhoneH().setText(getParameter("PatHTel"));
				getPhoneM().setText(getParameter("PatMTel"));
			}
			getSource().setText(getParameter("Source"));
			getRemark().setText(getParameter("Remark"));
			getSMSContent().setText(getParameter("SMSContent"));

			String patAlert = getParameter("PatAlert");
			// hard code to handle covid-19
			if (HKAH_VALUE.equals(getUserInfo().getSiteCode()) && ("21".equals(patAlert) || "22".equals(patAlert) || "23".equals(patAlert))) {
				getAlert().setText("20");
				getSpecialty().setText("GP");
				getDrCode().setText(EMPTY_VALUE);
			} else {
				getAlert().setText(patAlert);
				getSpecialty().setText(EMPTY_VALUE);
				getDrCode().setText(getParameter("BKDocCode"));
			}

			getSession().setText(getParameter("BKGSCnt"));
			String doclocid = getParameter("DocLoc");
			if (doclocid != null && doclocid.length() > 0) {
				getDocLocation().setText(doclocid);
			}
			String appointmentDate = getParameter("AppointmentDate");
			if (appointmentDate != null && appointmentDate.length() == 10) {
				getDateFrom().setText(appointmentDate);
				getDateTo().setText(appointmentDate);
			}

			memRLockID = getParameter("RLockID");
			String govStaff = getParameter("GovStaff");
			if (govStaff != null && govStaff.length() > 0) {
				getGovStaff().setSelected(true);
			}
			getLMP().setText(getParameter("OBLMP"));
			getEDC().setText(getParameter("OBEDC"));
			getBirthOrder().setText(getParameter("OBBirthOrder"));
			getReferralDoctor().setText(getParameter("OBReferralDoctor"));
			getWeeks().setText(getParameter("OBWeeks"));
			getNatureOfVisit().setText(getParameter("PatNatOfVis"));

			if (patno != null && patno.length() > 0) {
				getPatientNo().requestFocus();
			} else {
				getNames().requestFocus();
			}
		}

		resetParameter("START_TYPE");
		resetParameter("memDocCode");
		resetParameter("From");

		enableButton();
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public Component getDefaultFocusComponent() {
		if (getListTable().getRowCount() > 0) {
			return getListTable();
		} else {
			return getDateFrom();
		}
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {
		// enable/disable field
	}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
		// enable/disable field
	}

	/* >>> ~13~ Set Disable Fields When Delete ButtonBase Is Clicked ====== <<< */
	@Override
	protected void deleteDisabledFields() {
		getSaveButton().setEnabled(true);
		getAcceptButton().setEnabled(false);
	}

	/* >>> ~14~ Set Browse Validation ===================================== <<< */
	@Override
	protected boolean browseValidation() {
		if (!getDept().isEmpty() && !getDept().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid Department.", getDept());
			return false;
		} else if (!getSpecialty().isEmpty() && !getSpecialty().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid Speciality.", getSpecialty());
			return false;
		} else if (!getDateFrom().isEmpty() && !getDateFrom().isValid()) {
			Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_INVALID_REGDATE, getDateFrom());
			return false;
		} else if (!getDateTo().isEmpty() && !getDateTo().isValid()) {
			Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_INVALID_REGDATE, getDateTo());
			return false;
		} else {
			return true;
		}
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
				getScheduleDay().getText().trim(),
				getDept().getText().trim(),
				getSpecialty().getText().trim(),
				getDateFrom().getText().trim(),
				getDateTo().getText().trim(),
				getDrCode().getText().trim(),
				getDocLocation().getText().trim(),
				getOnlyBlocked().isSelected()?YES_VALUE:NO_VALUE,
				getIncludeBlocked().isSelected()?"B":NO_VALUE,
				getSortByTime().isSelected()?YES_VALUE:NO_VALUE,
				getUserInfo().getUserID()
		};
	}

	/* >>> ~16~ Set Fetch Input Parameters ================================ <<< */
	@Override
	protected String[] getFetchInputParameters() {
		// fetch template detail by doctor code
		return new String[] { };
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {
		// get data from table list
		updateSlotTable();
		PanelUtil.setAllFieldsEditable(getRightTopPanel(), true);
		PanelUtil.setAllFieldsEditable(getRightMidPanel(), true);
		PanelUtil.setAllFieldsEditable(getRightBtmPanel(), true);
	}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		// add/update/delete to db para
		return null;
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(final String actionType) {
		checkPatientNo(actionType);
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	protected String getDefaultSpecCode() {
		return null;
	}

	private void checkPatientNo(final String actionType) {
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
									checkPatientNoPost(actionType);
								} else {
									getNames().resetText();
									getPhoneH().resetText();
									getPhoneM().resetText();
									Factory.getInstance().addErrorMessage(MSG_BOOKING_NOINFO,
											"PBA - [Doctor Appointment]", getNames());
								}
							} catch (Exception e) {
								e.printStackTrace();
								getNames().resetText();
								getPhoneH().resetText();
								getPhoneM().resetText();
								Factory.getInstance().addErrorMessage(MSG_BOOKING_NOINFO,
										"PBA - [Doctor Appointment]", getNames());
							}
						} else {
							getNames().resetText();
							getPhoneH().resetText();
							getPhoneM().resetText();
							Factory.getInstance().addErrorMessage(MSG_BOOKING_NOINFO,
									"PBA - [Doctor Appointment]", getNames());
						}
					} else {
						getNames().resetText();
						getPhoneH().resetText();
						getPhoneM().resetText();
						Factory.getInstance().addErrorMessage(MSG_BOOKING_NOINFO,
								"PBA - [Doctor Appointment]", getNames());
					}
				}
			});
		} else {
			checkPatientNoPost(actionType);
		}
	}

	private void checkPatientNoPost(final String actionType) {
		boolean returnValue = true;
		if (getListTable().getSelectionModel().getSelectedItems().size() <= 0) {
			Factory.getInstance().addErrorMessage("Please select a schedule.", "PBA - [Doctor Appointment]", null, getListTable());
			returnValue = false;
		} else if (DateTimeUtil.dateDiff(getListTable().getSelectedRowContent()[GrdPb_timeFrom].substring(0, 10),
								DateTimeUtil.getCurrentDate()) < 0) {
			Factory.getInstance().addErrorMessage("No backdate booking is allowed.", "PBA - [Doctor Appointment]", null, getListTable());
			returnValue = false;
		} else if (YES_VALUE.equals(getSysParameter("BOKSRCMUST")) && getSource().isEmpty()) {
			Factory.getInstance().addErrorMessage("Please Input Source.", "PBA - [Doctor Appointment]", getSource());
			returnValue = false;
		} else if (!getSource().isEmpty() && !getSource().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid Input Source.", "PBA - [Doctor Appointment]", getSource());
			returnValue = false;
		} else if (getDoctor().isEmpty()) {
			Factory.getInstance().addErrorMessage("Inactive doctor.", "PBA - [Doctor Appointment]", getDoctor());
			returnValue = false;
		} else if (getNames().isEmpty()) {
			Factory.getInstance().addErrorMessage(MSG_BOOKING_NOINFO, "PBA - [Doctor Appointment]", getNames());
			returnValue = false;
		} else if ((getPhoneH().isEmpty() && getPhoneM().isEmpty())) {
			Factory.getInstance().addErrorMessage(MSG_BOOKING_NOINFO, "PBA - [Doctor Appointment]", getPhoneH());
			returnValue = false;
		} else {
			int session = -1;
			try { session = Integer.valueOf(getSession().getText().trim()); } catch(Exception e) {}

			String startDate = getListTable().getSelectedRowContent()[GrdPb_timeFrom];
			String endTimeOfSlot = getListTable().getSelectedRowContent()[GrdPb_timeTo];
			endTimeOfSlot = startDate.substring(0, startDate.lastIndexOf(SLASH_VALUE) + 6) + endTimeOfSlot + ":00";
			String startTime = getTime().getText();
			int duration = Integer.valueOf(getDuration().getText());
			String endTimeOfBk = DateTimeUtil.formatDateTime(new Date(DateTimeUtil.parseDateTime(startTime).getTime() + (((session * duration) - 1) * 60000)));

			int endTimeDiff = (int) DateTimeUtil.dateTimeDiff(endTimeOfSlot, endTimeOfBk);

			if (session <= 0) {
				Factory.getInstance().addErrorMessage("Invalid Session.", "PBA - [Doctor Appointment]", getSession());
				returnValue = false;
			} else if (endTimeDiff < 0) {
				Factory.getInstance().addErrorMessage("Session exceed doctor schedule.", "PBA - [Doctor Appointment]", getSession());
				returnValue = false;
			} else if (!getSMSContent().isEmpty() && getPhoneM().isEmpty()) {
				Factory.getInstance().addErrorMessage("SMS is checked, please input Mobile Phone.", "PBA - [Doctor Appointment]", getPhoneM());
				returnValue = false;
			} else if (!getSMSContent().isEmpty() && !getSMSContent().isValid()) {
				Factory.getInstance().addErrorMessage("Invalid SMS Message Content.", "PBA - [Doctor Appointment]", getSMSContent());
				returnValue = false;
			} else if (YES_VALUE.equals(getSysParameter("AppAltEnty")) && getAlert().isEmpty()) {
				Factory.getInstance().addErrorMessage("Initial Assessed is mandatory, please select one option.", "PBA - [Doctor Appointment]", getAlert());
				returnValue = false;
			} else if (!getAlert().isEmpty() && !getAlert().isValid()) {
				Factory.getInstance().addErrorMessage("Invalid Initial Assessed.", "PBA - [Doctor Appointment]", getAlert());
				returnValue = false;
			} else if (!getAlert().isEmpty() && HKAH_VALUE.equals(getUserInfo().getSiteCode()) && YES_VALUE.equals(getSysParameter("ISCompNOV")) && getNatureOfVisit().isEmpty()) {
				Factory.getInstance().addErrorMessage("Invalid Nature of Visit.", "PBA - [Doctor Appointment]", getNatureOfVisit());
				returnValue = false;
			} else if (!getLMP().isEmpty() && !getLMP().isValid()) {
				Factory.getInstance().addErrorMessage("Invalid LMP.", "PBA - [Doctor Appointment]", getLMP());
				returnValue = false;
			} else if (!getEDC().isEmpty() && !getEDC().isValid()) {
				Factory.getInstance().addErrorMessage("Invalid EDC.", "PBA - [Doctor Appointment]", getEDC());
				returnValue = false;
			} else if (!getWeeks().isEmpty() && !getWeeks().isValid()) {
				Factory.getInstance().addErrorMessage("Invalid Weeks.", "PBA - [Doctor Appointment]", getWeeks());
				returnValue = false;
			}
		}
		checkChangeBooking(actionType, returnValue);
	}

	private void checkChangeBooking(final String actionType, final boolean returnValue) {
		if (returnValue && isChangeBooking) {
			MessageBoxBase.confirm(MSG_PBA_SYSTEM,
					"Are you sure to change appointment?",
					new Listener<MessageBoxEvent>() {
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						actionValidationReady(actionType, returnValue);
					} else {
						//defaultFocus();
					}
				}
			});
		} else {
			actionValidationReady(actionType, returnValue);
		}
	}

	// generate dialog start
	private DlgGenerateSchedule getGenerateDialog() {
		if (generateDialog == null) {
			generateDialog = new DlgGenerateSchedule(getMainFrame()) {
				@Override
				public void dispose() {
					super.dispose();
					searchAction(true);
				}
			};
		}
		return generateDialog;
	}

	private String getDate(String date, int len) {
		return date.substring(0, len);
	}

	private void resetBookingEntry() {
		getPatientNo().resetText();
		getSex().resetText();
		getNames().resetText();
		getPhoneH().resetText();
		getPhoneM().resetText();
		getSession().setText(ONE_VALUE);
		getSource().resetText();
//		getRemark().setText("FM WEB");
		getRemark().resetText();
		getGovStaff().reset();
		getSMSContent().resetText();
		getOtherLblDtl().resetText();
		if (YES_VALUE.equals(getSysParameter("AppAltShow")) && !YES_VALUE.equals(getSysParameter("AppAltEnty"))) {
			getAlert().setText(ZERO_VALUE);
		} else {
			getAlert().resetText();
		}
		getLMP().resetText();
		getEDC().resetText();
		getBirthOrder().resetText();
		getReferralDoctor().resetText();
		getWeeks().resetText();
		getNatureOfVisit().resetText();

		memIsOverrideBooking = false;
		memIsOverrideAgeLimit = false;
		memIsOverrideVaccine = false;
		memIsOverrideC19InitAsseHC = false;
	}

	private void updateSlotTable() {
//		System.out.println("Enter updateSlotTable.....");
		if (getListTable().getRowCount() > 0) {
//			System.out.println("[updateSlotTable] The records of list table are more than 0.....");
//			System.out.println("[updateSlotTable] set slot table data.....");
			getTslotListTable().setListTableContent(ConstantsTx.SLOT_TXCODE, new String[] { getListTable().getSelectedRowContent()[GrdPb_bkgid] });

			if (getTslotListTable().getRowCount() > 0 && getTslotListTable().getSelectedRow() >= 0) {
				//System.out.println("[updateSlotTable] select value if slot data is selected....");
				getTime().setText(getTslotListTable().getSelectedRowContent()[2]) ;
				getDuration().setText(getListTable().getSelectedRowContent()[GrdPb_schlen]);
				getDoctor().setText(getListTable().getSelectedRowContent()[GrdPb_docCode]);
				getDrRoom().setText(getListTable().getSelectedRowContent()[GrdPb_schDrRoom]);
				
			} else {
				getTime().setText(EMPTY_VALUE) ;
				getDuration().resetText();
				getOfAptMade().resetText();
				getDoctor().resetText();
				// clean up slot table
				getTslotListTable().removeAllRow();
			}
		}
		checkNewPatient();
	}

//	private void getMrhvollab(String patno) {
//		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
//				new String[] {"MedRecHdr", "mrhvollab", "mrhsts='N' and patno= '"+patno+"' order by mrhvollab desc"},
//				new MessageQueueCallBack() {
//			public void onPostSuccess(MessageQueue mQueue) {
//				if (mQueue.success()) {
//					int temp = Integer.parseInt(mQueue.getContentField()[0]);
//					if (temp <= 0) {
//						mrhvollab = "00";
//					} else {
//						mrhvollab = mQueue.getContentField()[0];
//					}
//				} else {
//					mrhvollab = "   ";
//				}
//			}
//		});
//	}

	private void doRemark() {
		QueryUtil.executeMasterAction(getUserInfo(), "SCHEDULE_RMK", QueryUtil.ACTION_MODIFY,
				new String[] {
					getListTable().getSelectedRowContent()[GrdPb_bkgid],
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

	private void checkStaff() {
		QueryUtil.executeMasterFetch(getUserInfo(), "OTHERLBLDTL",
				new String[] { getPatientNo().getText(), Factory.getInstance().getUserInfo().getUserID() },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getOtherLblDtl().setText(mQueue.getContentField()[0]);
				}
			}
		});
	}

	private void checkNewPatient() {
		if (!isVaccineBooking && YES_VALUE.equals(getSysParameter("RegChkDoc")) && !getDoctor().isEmpty() && !getPatientNo().isEmpty()) {
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] { "REG", "COUNT(1)", "PATNO = '" + getPatientNo().getText() + "' AND DOCCODE = '" + getDoctor().getText() + "' AND REGSTS = 'N'" },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success() && ZERO_VALUE.equals(mQueue.getContentField()[0])) {
						Factory.getInstance().addErrorMessage("New Patient for doctor " + getDoctor().getText() + ".");
					}
				}
			});
		}
	}

	protected void showAppointmentBrowsePanel() {
		if (isVaccineBooking) {
			MessageBoxBase.confirm("Message", "The second slot of vaccine booking is not completed, continue?",
					new Listener<MessageBoxEvent>() {
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						isVaccineBooking = false;
						showPanel(new AppointmentBrowse());
					}
				}
			});
		} else {
			showPanel(new AppointmentBrowse());
		}
	}
	
	protected void showAppointmentBrowseRmPanel() {
		if (isVaccineBooking) {
			MessageBoxBase.confirm("Message", "The second slot of vaccine booking is not completed, continue?",
					new Listener<MessageBoxEvent>() {
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						isVaccineBooking = false;
						showPanel(new AppointmentBrowseByRoom());
					}
				}
			});
		} else {
			showPanel(new AppointmentBrowseByRoom());
		}
	}

	protected void showInsurancePanelDr(){
		openNewWindow(null, Factory.getInstance().getSysParameter("PANELDR"), null, true);
	}

	protected void showRegistrationSearchPanel() {
		setParameter("qPATNO", getPatientNo().getText().trim());
		setParameter("spec", getSpecialty().getText().trim());
		setParameter("from", "docAppBse");
		showPanel(new RegistrationSearch());
	}

	private String combineOverride() {
		StringBuilder result = new StringBuilder();
		result.append(memIsOverrideBooking?YES_VALUE:NO_VALUE);
		result.append(memIsOverrideAgeLimit?YES_VALUE:NO_VALUE);
		result.append(memIsOverrideVaccine?YES_VALUE:NO_VALUE);
		result.append(memIsOverrideC19InitAsseHC?YES_VALUE:NO_VALUE);
		return result.toString();
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	// paper priority
	@Override
	protected void actionValidationReady(final String actionType, final boolean isValidationReady) {
		if (isValidationReady) {
			final String[] inParam = new String[] {
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
					getLMP().getText().trim(),
					getEDC().getText().trim(),
					getBirthOrder().getText().trim(),
					getReferralDoctor().getText().trim(),
					getWeeks().getText().trim(),
					isChangeBooking?memRLockID:EMPTY_VALUE,
					combineOverride(),
					getUserInfo().getUserID(),
					CommonUtil.getComputerName(),
					getOtherLblDtl().getText().trim(),
					getNatureOfVisit().getText().trim()
				};
			QueryUtil.executeMasterAction(getUserInfo(), ConstantsTx.APPOINTMENTBROWSE_TXCODE, QueryUtil.ACTION_APPEND, inParam,
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						newBkgID = mQueue.getReturnCode();
						getInfoDialog().getCurBKID().setText(newBkgID);
						memSlotSearchTime = getTslotListTable().getSelectedRowContent()[2].substring(11, 16);
						memDoctorCode = inParam[0];
						memDoctorName = getListTable().getSelectedRowContent()[GrdPb_docFName] + SPACE_VALUE + getListTable().getSelectedRowContent()[GrdPb_docGName];
						isGovStaff = getGovStaff().getValue();
						final String appPatno = inParam[4];
						final String appDate = inParam[1];

						if (isChangeBooking) {
							// after cancel original appointment
							if (isGovStaff) {
								QueryUtil.executeMasterAction(getUserInfo(), "UPDATE", QueryUtil.ACTION_APPEND,
										new String[] {"GOVREG", "BKGID=" + newBkgID , "BKGID=" + memRLockID});
							}

							// back to appointment browse
							exitPanel();
							Factory.getInstance().addSystemMessage("Booking is changed.", "PBA - [Doctor Appointment]");
						}

						getInfoDialog().hide();

							if (!getPatientNo().isEmpty()) {
								QueryUtil.executeMasterFetch(getUserInfo(), "MEDRECGETWPAPER",
										new String[] { appPatno },
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
										String docfname = getListTable().getSelectedRowContent()[GrdPb_docFName];
										String docgname = getListTable().getSelectedRowContent()[GrdPb_docGName];

										Map<String, String> params = new HashMap<String, String>();
										params.put("App. Date", appDate);
										params.put("Doctor Name", docfname + SPACE_VALUE + docgname);

										getAlertCheck().checkAltAccess(appPatno, funname, false, true, params);

										StringBuffer desc = new StringBuffer();
										String isPaper = null;
										boolean isCallChtEnable = true;
										boolean creatNewVol = false;
										if (mQueue.getContentField().length > 0) {
											desc.append(mQueue.getContentField()[0]);
											if (mQueue.getContentField().length > 1) {
												desc.append("(");
												desc.append(mQueue.getContentField()[1]);
												desc.append(")");
												if ("-1".equals(mQueue.getContentField()[2])) {
													isCallChtEnable = false;
												}
												isPaper = mQueue.getContentField()[3];
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

										getInfoDialog().showDialog(appPatno, memDoctorCode, memDoctorName,
												true, true, desc.toString(), isShowHomeVisit, isChangeBooking, isCallChtEnable, isPaper, creatNewVol, appDate);
									}
								});
							} else {
								getInfoDialog().showDialog(appPatno, memDoctorCode, memDoctorName,
										false, false, null, isShowHomeVisit, false, appDate);
							}
						

						setActionType(null);
						if (!"OK".equals(mQueue.getReturnMsg())) {
							Factory.getInstance().addErrorMessage(mQueue.getReturnMsg(), "PBA - [Doctor Appointment]", null, getDefaultFocusComponent());
						}
					} else if (MINUS_TWO_VALUE.equals(mQueue.getReturnCode())) {
						newBkgID = "";
						MessageBox mb = MessageBoxBase.confirm(MSG_PBA_SYSTEM, mQueue.getReturnMsg(),
								new Listener<MessageBoxEvent>() {
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									memIsOverrideBooking = true;
									// resubmit again
									actionValidationReady(actionType, isValidationReady);
								} else {
//									defaultFocus();
								}
							}
						});

						mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
					} else if (MINUS_THREE_VALUE.equals(mQueue.getReturnCode())) {
						newBkgID = "";
						MessageBox mb = MessageBoxBase.confirm(MSG_PBA_SYSTEM, mQueue.getReturnMsg(),
								new Listener<MessageBoxEvent>() {
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									memIsOverrideAgeLimit = true;
									// resubmit again
									actionValidationReady(actionType, isValidationReady);
								} else {
//									defaultFocus();
								}
							}
						});

						mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
					} else if (MINUS_FOUR_VALUE.equals(mQueue.getReturnCode())) {
						newBkgID = "";
						MessageBox mb = MessageBoxBase.confirm(MSG_PBA_SYSTEM, mQueue.getReturnMsg(),
								new Listener<MessageBoxEvent>() {
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									memIsOverrideVaccine = true;
									// resubmit again
									actionValidationReady(actionType, isValidationReady);
								} else {
//									defaultFocus();
								}
							}
						});

						mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
					} else if (MINUS_FIVE_VALUE.equals(mQueue.getReturnCode())) {
						newBkgID = "";
						MessageBox mb = MessageBoxBase.confirm(MSG_PBA_SYSTEM, mQueue.getReturnMsg(),
								new Listener<MessageBoxEvent>() {
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									memIsOverrideC19InitAsseHC = true;
									// resubmit again
									actionValidationReady(actionType, isValidationReady);
								} else {
//									defaultFocus();
								}
							}
						});

						mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
					} else {
						newBkgID = "";
						Factory.getInstance().addErrorMessage(mQueue.getReturnMsg(), "PBA - [Doctor Appointment]", null, getDefaultFocusComponent());
						setActionType(null);
					}
				}
			});
		}
	}

	@Override
	protected void performListPost() {
		super.performListPost();
		if (getListTable().getRowCount() == 0) {
			getTslotListTable().removeAllRow();
		} else {
			// show Dr. Room after search
			getDrRoom().setText(getListTable().getSelectedRowContent()[GrdPb_schDrRoom]);
			
			if (HKAH_VALUE.equals(getUserInfo().getSiteCode())) {
				QueryUtil.executeMasterFetch(getUserInfo(), "BOOKINGINFO",
						new String[] { getDrCode().getText() },
						new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									if (mQueue.getContentField()[0].length() > 0) {
										if (isChangeBooking && !"".equals(getParameter("Remark"))){
											String bookinginfoRemark = mQueue.getContentField()[0];
											if (!(getParameter("Remark") != null && getParameter("Remark").contains(bookinginfoRemark))) {
												getRemark().setText(getParameter("Remark") + " "+ mQueue.getContentField()[0]);
											}
										} else {
											getRemark().setText(mQueue.getContentField()[0]);
										}
									} else {
										if (isChangeBooking && !"".equals(getParameter("Remark"))){
											getRemark().setText(getParameter("Remark"));
										} else {
											getRemark().resetText();
										}
									}
									if (mQueue.getContentField()[1].length() > 0) {
										getSMSContent().setText(mQueue.getContentField()[1]);
									} else {
										getSMSContent().resetText();
									}
								}
							}
						}
					);

				QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
						new String[] {
							"HPSTATUS", "HPSTATUS", "HPTYPE = 'NATUREOFVISIT_PRESET' AND HPACTIVE = -1 AND HPKEY = '" + getDrCode().getText() + "'"
						},
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							getNatureOfVisit().setText(mQueue.getContentField()[0]);
						} else {
							getNatureOfVisit().setText("");
						}
					}
				});
			}
		}

		// registration check
		if (getRightRightPanel().isVisible()) {
			getRegistrationCheckListTable().setListTableContent(
					"REGISTRATIONCHECK",
					new String[] { getSpecialty().getText(), getAlert_RegCheck().getText(), getDateFrom().getText(), getDateTo().getText().trim() }
			);
		}
	}

	@Override
	public void searchAction() {
		if (getDrCode().isFocusOwner() && getDrCode().isEmpty()) {
			getDrCode().showSearchPanel();
		} else if (getPatientNo().isFocusOwner() && getPatientNo().isEmpty()) {
			getPatientNo().showSearchPanel();
		} else {
			super.searchAction();
		}
	}

	@Override
	public void clearAction() {
		super.clearAction();
		getScheduleDay().resetText();
		getDept().resetText();
		getSpecialty().resetText();
		getDateFrom().setText(memCurrdate);
		getDateTo().setText(memCurrdate);
		getDrCode().resetText();
		getDocLocation().resetText();
		resetBookingEntry();
	}

	@Override
	protected void enableButton(String mode) {
		disableButton();
		getSearchButton().setEnabled(true);
		getSaveButton().setEnabled(true);
		getClearButton().setEnabled(true);

		getAddSchAction().setEnabled(!isChangeBooking && !isDisableFunction("btnAddSch", "schAppoint"));
		getWeekSchAction().setEnabled(!isChangeBooking && !isDisableFunction("btnTemplate", "schAppoint"));
		getGenerateAction().setEnabled(!isChangeBooking && !isDisableFunction("btnGenerate", "schAppoint"));
		getBlockAction().setEnabled(!isChangeBooking && !isDisableFunction("btnBlock", "schAppoint"));
		getUnBlockAction().setEnabled(!isChangeBooking && !isDisableFunction("btnUnBlock", "schAppoint"));
		getSlotSearchAction().setEnabled(!isDisableFunction("btnSlotSearch", "schAppoint"));
		getQuotaCheckAction().setEnabled(!isDisableFunction("btnQuota", "schAppoint"));
		getRemarkAction().setEnabled(!isChangeBooking && !isDisableFunction("btnRemark", "schAppoint"));
		getRegCheckAction().setEnabled(!isDisableFunction("btnRegCheck", "schAppoint"));
		getWalkInAction().setEnabled(!isChangeBooking && !isDisableFunction("btnWalkIn", "schAppoint"));
		getPriorityAction().setEnabled(!isChangeBooking && !isDisableFunction("btnPriority", "schAppoint"));
		getUrgentCareAction().setEnabled(!isChangeBooking && !isDisableFunction("btnUrgentCare", "schAppoint"));
		getAppBrowseAction().setEnabled(!isChangeBooking && !isDisableFunction("btnBrowse", "schAppoint"));
		getAppBrowseRmAction().setEnabled(!isChangeBooking && !isDisableFunction("btnBrowse", "schAppoint"));
		getPanelDrAction().setEnabled(!isDisableFunction("btnPanelDr", "schAppoint"));
		getRegSearchAcction().setEnabled(!isChangeBooking && !isDisableFunction("btnBrowse", "schAppoint"));
	}

	@Override
	protected void lockRecordReady(final String lockType, final String lockKey, String[] record, boolean lock, String returnMessage) {
		if (lock) {
			if ("Remark".equals(record[0])) {
				memScheduleID = lockKey;
				getRemarkDialog().setVisible(true);
				getRemark_update().setText(getListTable().getSelectedRowContent()[GrdPb_remark]);
			} else if ("Block".equals(record[0])) {
				if ("B".equals(getListTable().getSelectedRowContent()[GrdPb_status])) {
					Factory.getInstance().addErrorMessage("Schedule already blocked.", "PBA - [Schedule Blocking]", null, getListTable());
				} else {
					memScheduleID = lockKey;
					getBlockDialog().showDialog(
							getListTable().getSelectedRowContent()[GrdPb_bkgid],	// bkgid
							getListTable().getSelectedRowContent()[GrdPb_timeFrom],	// from
							getListTable().getSelectedRowContent()[GrdPb_timeTo],	// to
							getListTable().getSelectedRowContent()[GrdPb_docCode],	// dr code
							getListTable().getSelectedRowContent()[GrdPb_docFName],	// doc fname
							getListTable().getSelectedRowContent()[GrdPb_docGName],	// doc gname
							getListTable().getSelectedRowContent()[GrdPb_schlen]	// SCHLEN
					);
				}
			} else if ("UnBlock".equals(record[0])) {
				if (NO_VALUE.equals(getListTable().getSelectedRowContent()[GrdPb_status])) {
					Factory.getInstance().addErrorMessage("Schedule is not currently blocked.", "PBA - [Schedule Blocking]", null, getListTable());
				} else {
					MessageBoxBase.confirm(MSG_PBA_SYSTEM, "Are you sure to UNBLOCK the selected appointment?",
							new Listener<MessageBoxEvent>() {
						public void handleEvent(MessageBoxEvent be) {
							if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
								QueryUtil.executeMasterAction(getUserInfo(), "SCHEDULE_UNBLOCK", QueryUtil.ACTION_MODIFY,
										new String[] { getListTable().getSelectedRowContent()[GrdPb_bkgid], getUserInfo().getUserID() },
										new MessageQueueCallBack() {
									@Override
									public void onPostSuccess(MessageQueue mQueue) {
										if (mQueue.success()) {
											Factory.getInstance().addInformationMessage("Schedule unblock successfully.", "PBA - [Schedule Appointment]", getDefaultFocusComponent());
										} else {
											Factory.getInstance().addErrorMessage(mQueue, null, getDefaultFocusComponent());
										}
										unlockRecord("Schedule", lockKey);
										searchAction();
									}
								});
							} else {
								//defaultFocus();
								unlockRecord("Schedule", lockKey);
							}
						}
					});
				}
			}
		} else {
			Factory.getInstance().addErrorMessage(returnMessage, null, null, getDefaultFocusComponent());
		}
	}

	@Override
	protected void resetCurrentFields() {
//		PanelUtil.resetAllFields(getRightBtmPanel());
	}

	@Override
	protected boolean triggerSearchField() {
		if (getPatientNo().isFocusOwner()) {
			getPatientNo().checkTriggerBySearchKey();
			return true;
		} else if (getDrCode().isFocusOwner()) {
			getDrCode().checkTriggerBySearchKey();
			return true;
		} else {
			return false;
		}
	}

	protected void performListNoRecordPostMsg(final MessageQueue mQueue) {
		if (!getDrCode().isEmpty()) {
			QueryUtil.executeMasterFetch(getUserInfo(), "DOCTOR_BYAPPOINTMENT",
					new String[] { getSpecialty().getText(), getDrCode().getText() },
					new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue2) {
							if (mQueue2.success()) {
								// by appointment
								getDrCode().clear();
								Factory.getInstance().addErrorMessage(mQueue2.getContentField()[0], getDrCode());
							} else {
								Factory.getInstance().addErrorMessage(mQueue, null, getDefaultFocusComponent());
							}
						}
					}
				);
		} else {
			Factory.getInstance().addErrorMessage(mQueue, null, getDefaultFocusComponent());
		}
	}


	/***************************************************************************
	 * Create Instance Method
	 **************************************************************************/

	@Override
	protected AlertCheck getAlertCheck() {
		if (alertCheck == null) {
			alertCheck = new AlertCheck() {
				@Override
				public void checkAltAccessPostAction(boolean ret) {
					if (ret) {
						refreshAction();
					}
				}
			};
		}
		return alertCheck;
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	// getter method start
	@Override
	protected BasePanel getActionPanel() {
		if (actionPanel == null) {
			actionPanel = new BasePanel();
			actionPanel.setSize(800, 530);
			actionPanel.add(getLeftBasePanel(), null);
		}
		return actionPanel;
	}

	public TableList getTslotListTable() {
		if (tslotListTable == null) {
			tslotListTable = new TableList(getTslotColumnNames(), getTslotColumnWidths()) {
				@Override
				public void onClick() {
					//System.out.println("getScrollTop: "+getView().getRow(getSelectedRow()).getOffsetTop());
					tslotLastScrollTop = getView().getRow(getSelectedRow()).getOffsetTop() - 20;
				};

				public void onSelectionChanged() {
					//getSlotScrollPane().setVScrollPosition(0);
					//System.out.println("[onSelectionChanged] Start.....");
					//getTslotListTable().getView().layout();

					if (getTslotListTable().getRowCount() > 0) {
						//getSlotScrollPane().layout(true);
						if (getTslotListTable().getSelectedRow() == 0) {
							//getTslotListTable().getView().refresh(false);
							getTslotListTable().setSelectRow(0);
							getView().getBody().setScrollTop(0);
							tslotLastScrollTop = 0;
							//getTslotListTable().getView().scrollToTop();
						} else {
							//System.out.println("getScrollTop: "+getView().getRow(getSelectedRow()).getOffsetTop());
							tslotLastScrollTop = getView().getRow(getSelectedRow()).getOffsetTop() - 20;
							if (getView().getBody().getScrollTop() > tslotLastScrollTop ||
									getTslotListTable().getView().getBody().getScrollTop() +
									getTslotListTable().getHeight() - 80 < tslotLastScrollTop) {
								getView().getBody().setScrollTop(tslotLastScrollTop);
							}
						}

						if (getTslotListTable().getSelectedRowContent() != null) {
							getTime().setText(getTslotListTable().getSelectedRowContent()[2]);
							getDuration().setText(getListTable().getSelectedRowContent()[GrdPb_schlen]);
							getOfAptMade().setText(getTslotListTable().getSelectedRowContent()[4]);
							getDoctor().setText(getListTable().getSelectedRowContent()[GrdPb_docCode]);
							defaultFocus();
						}
					}
				}

				@Override
				public void setListTableContentPost() {
					//getTslotListTable().setSelectRow(0);
					//getTslotListTable().getView().refresh(false);
					//getSlotScrollPane().setVScrollPosition(0);
					//System.out.println("[setListTableContentPost] Start.....");
					getTslotListTable().getView().layout();

					if (memSlotSearchTime != null) {
						boolean isFound = false;
						for (int i=0; i < getTslotListTable().getRowCount() && !isFound; i++) {
							if (memSlotSearchTime.equals(getTslotListTable().getRowContent(i)[2].substring(11, 16)) &&
									memDoctorCode.equals(getListTable().getSelectedRowContent()[GrdPb_docCode])) {
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
			tslotListTable.setBounds(655, 0, 105, 260);
		}

		return tslotListTable;
	}
/*
	public JScrollPane getSchScrollPane() {
		if (schScrollPane == null) {
			schScrollPane = new JScrollPane();
			getJScrollPane().removeViewportView(getListTable());
			schScrollPane.setViewportView(getListTable());
			schScrollPane.setBounds(0, 0, 650, 310);
		}
		return schScrollPane;
	}

	public JScrollPane getSlotScrollPane() {
		if (slotScrollPane == null) {
			slotScrollPane = new JScrollPane() {
				@Override
				protected void afterRender() {
					super.afterRender();
					setVScrollPosition(0);
				}
			};
			slotScrollPane.setViewportView(getTslotListTable());
			slotScrollPane.setBounds(655, 0, 105, 310);
		}
		return slotScrollPane;
	}
*/
	// all list table end

	public BasePanel getLeftBasePanel() {
		if (rightBasePanel == null) {
			rightBasePanel = new BasePanel();
			rightBasePanel.setLayout(null);
			rightBasePanel.setBounds(new Rectangle(0, 0, 800, 530));
			rightBasePanel.add(getRightTopPanel(), null);
			rightBasePanel.add(getRightMidPanel(), null);
			rightBasePanel.add(getRightBtmPanel(), null);
			rightBasePanel.add(getAddSchAction(), null);
			rightBasePanel.add(getWeekSchAction(), null);
			rightBasePanel.add(getGenerateAction(), null);
			rightBasePanel.add(getBlockAction(), null);
			rightBasePanel.add(getUnBlockAction(), null);
			rightBasePanel.add(getSlotSearchAction(), null);
			rightBasePanel.add(getQuotaCheckAction(), null);
			rightBasePanel.add(getRemarkAction(), null);
			rightBasePanel.add(getRegCheckAction(), null);
			rightBasePanel.add(getWalkInAction(), null);
			rightBasePanel.add(getPriorityAction(), null);
			rightBasePanel.add(getUrgentCareAction(), null);
			rightBasePanel.add(getAppBrowseAction(), null);
			rightBasePanel.add(getAppBrowseRmAction(), null);
			rightBasePanel.add(getPanelDrAction(), null);
			rightBasePanel.add(getRegSearchAcction(), null);
			rightBasePanel.add(getupdateSchAction(), null);
			rightBasePanel.add(getRightRightPanel(), null);
		}
		return rightBasePanel;
	}

	public BasePanel getRightTopPanel() {
		if (rightTopPanel == null) {
			rightTopPanel = new BasePanel();
			rightTopPanel.setBounds(5, 5, 790, 60);
			rightTopPanel.add(getScheduleDayDesc(), null);
			rightTopPanel.add(getScheduleDay(), null);
			rightTopPanel.add(getDeptDesc(), null);
			rightTopPanel.add(getDept(), null);
			rightTopPanel.add(getSpecialtyDesc(), null);
			rightTopPanel.add(getSpecialty(), null);
			rightTopPanel.add(getOnlyBlockedDesc(), null);
			rightTopPanel.add(getOnlyBlocked(), null);
			rightTopPanel.add(getDateFromDesc(), null);
			rightTopPanel.add(getDateFrom(), null);
			rightTopPanel.add(getDateToDesc(), null);
			rightTopPanel.add(getDateTo(), null);
			rightTopPanel.add(getDrCodeDesc(), null);
			rightTopPanel.add(getDrCode(), null);
			rightTopPanel.add(getIncludeBlockedDesc(), null);
			rightTopPanel.add(getIncludeBlocked(), null);
			rightTopPanel.add(getSortByTimeDesc(), null);
			rightTopPanel.add(getSortByTime(), null);
			rightTopPanel.add(getDocLocationDesc(), null);
			rightTopPanel.add(getDocLocation(), null);
			rightTopPanel.add(getDrRoomDesc(), null);
			rightTopPanel.add(getDrRoom(), null);
		}
		return rightTopPanel;
	}

	public BasePanel getRightMidPanel() {
		if (rightMidPanel == null) {
			rightMidPanel = new BasePanel();
			rightMidPanel.setBounds(10, 83, 790, 315);
			getJScrollPane().removeViewportView(getListTable());
			getListTable().setBounds(0, 0, 650, 260);
			rightMidPanel.add(getListTable(), null);
			rightMidPanel.add(getTslotListTable(), null);
		}
		return rightMidPanel;
	}

	public BasePanel getRightBtmPanel() {
		if (rightBtmPanel == null) {
			rightBtmPanel = new BasePanel();
			rightBtmPanel.setBounds(10, 350, 760, 135);
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
			rightBtmPanel.add(getSourceDesc(), null);
			rightBtmPanel.add(getSource(), null);
			rightBtmPanel.add(getGovStaffDesc(), null);
			rightBtmPanel.add(getGovStaff(), null);
			rightBtmPanel.add(getRemarkDesc(), null);
			rightBtmPanel.add(getRemark(), null);
			rightBtmPanel.add(getOtherLblDtlDesc(), null);
			rightBtmPanel.add(getOtherLblDtl(), null);
			rightBtmPanel.add(getSMSContentDesc(), null);
			rightBtmPanel.add(getSMSContent(), null);
			rightBtmPanel.add(getNatureOfVisitDesc(), null);
			rightBtmPanel.add(getNatureOfVisit(), null);
			rightBtmPanel.add(getAlertDesc(), null);
			rightBtmPanel.add(getAlert(), null);
			rightBtmPanel.add(getLMPDesc(), null);
			rightBtmPanel.add(getLMP(), null);
			rightBtmPanel.add(getEDCDesc(), null);
			rightBtmPanel.add(getEDC(), null);
			rightBtmPanel.add(getBirthOrderDesc(), null);
			rightBtmPanel.add(getBirthOrder(), null);
			rightBtmPanel.add(getReferralDoctorDesc(), null);
			rightBtmPanel.add(getReferralDoctor(), null);
			rightBtmPanel.add(getWeeksDesc(), null);
			rightBtmPanel.add(getWeeks(), null);
		}
		return rightBtmPanel;
	}

	private LabelSmallBase getScheduleDayDesc() {
		if (scheduleDayDesc == null) {
			scheduleDayDesc = new LabelSmallBase();
			scheduleDayDesc.setText("Day of Week");
			scheduleDayDesc.setBounds(5, 0, 80, 20);
			scheduleDayDesc.setOptionalLabel();
		}
		return scheduleDayDesc;
	}

	private ComboDayOfweek getScheduleDay() {
		if (scheduleDay == null) {
			scheduleDay = new ComboDayOfweek();
			scheduleDay.setBounds(90, 0, 120, 20);
		}
		return scheduleDay;
	}

	private LabelSmallBase getDeptDesc() {
		if (deptDesc == null) {
			deptDesc = new LabelSmallBase();
			deptDesc.setText("Dept");
			deptDesc.setBounds(225, 0, 80, 20);
			deptDesc.setOptionalLabel();
		}
		return deptDesc;
	}

	private ComboDept getDept() {
		if (dept == null) {
			dept = new ComboDept();
			dept.setBounds(300, 0, 120, 20);
		}
		return dept;
	}

	private LabelSmallBase getSpecialtyDesc() {
		if (specialtyDesc == null) {
			specialtyDesc = new LabelSmallBase();
			specialtyDesc.setText("Specialty");
			specialtyDesc.setBounds(435, 0, 80, 20);
			specialtyDesc.setOptionalLabel();
		}
		return specialtyDesc;
	}

	protected ComboSpecialtyCode getSpecialty() {
		if (specialty == null) {
			specialty = new ComboSpecialtyCode();
			specialty.setBounds(510, 0, 120, 20);
		}
		return specialty;
	}

	private LabelSmallBase getOnlyBlockedDesc() {
		if (onlyBlockedDesc == null) {
			onlyBlockedDesc = new LabelSmallBase();
			onlyBlockedDesc.setText("Only Blocked");
			onlyBlockedDesc.setBounds(650, 3, 90, 20);
			onlyBlockedDesc.setOptionalLabel();
		}
		return onlyBlockedDesc;
	}

	public CheckBoxBase getOnlyBlocked() {
		if (onlyBlocked == null) {
			onlyBlocked = new CheckBoxBase();
			onlyBlocked.setBounds(735, 3, 30, 20);
		}
		return onlyBlocked;
	}

	private LabelSmallBase getDateFromDesc() {
		if (dateFromDesc == null) {
			dateFromDesc = new LabelSmallBase();
			dateFromDesc.setText("Date From");
			dateFromDesc.setBounds(5, 25, 80, 20);
			dateFromDesc.setOptionalLabel();
		}
		return dateFromDesc;
	}

	private TextDateTime getDateFrom() {
		if (dateFrom == null) {
			dateFrom = new TextDateTime(true);
			dateFrom.addListener(Events.OnFocus, new Listener<FieldEvent>() {
				@Override
				public void handleEvent(FieldEvent be) {
					getDateFrom().select(0, 0);
				}
			});
			dateFrom.setBounds(90, 25, 120, 20);
		}
		return dateFrom;
	}

	private LabelSmallBase getDateToDesc() {
		if (dateToDesc == null) {
			dateToDesc = new LabelSmallBase();
			dateToDesc.setText("Date To");
			dateToDesc.setBounds(225, 25, 80, 20);
			dateToDesc.setOptionalLabel();
		}
		return dateToDesc;
	}

	private TextDateTime getDateTo() {
		if (dateTo == null) {
			dateTo = new TextDateTime(true);
			dateTo.addListener(Events.OnFocus, new Listener<FieldEvent>() {
				@Override
				public void handleEvent(FieldEvent be) {
					getDateTo().select(0, 0);
				}
			});
			dateTo.setBounds(300, 25, 120, 20);
		}
		return dateTo;
	}

	private LabelSmallBase getDrCodeDesc() {
		if (drCodeDesc == null) {
			drCodeDesc = new LabelSmallBase();
			drCodeDesc.setText("Dr. Code");
			drCodeDesc.setBounds(435, 25, 80, 20);
			drCodeDesc.setOptionalLabel();
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
					searchAction(true);
				}
			};
			drCode.setBounds(510, 25, 120, 20);
		}
		return drCode;
	}

	private LabelSmallBase getIncludeBlockedDesc() {
		if (includeBlockedDesc == null) {
			includeBlockedDesc = new LabelSmallBase();
			includeBlockedDesc.setText("Include Blocked");
			includeBlockedDesc.setBounds(650, 19, 90, 20);
			includeBlockedDesc.setOptionalLabel();
		}
		return includeBlockedDesc;
	}

	public CheckBoxBase getIncludeBlocked() {
		if (includeBlocked == null) {
			includeBlocked = new CheckBoxBase();
			includeBlocked.setBounds(735, 19, 30, 20);
		}
		return includeBlocked;
	}

	private LabelSmallBase getSortByTimeDesc() {
		if (sortByTimeDesc == null) {
			sortByTimeDesc = new LabelSmallBase();
			sortByTimeDesc.setText("Sort By Time");
			sortByTimeDesc.setBounds(650, 35, 90, 20);
			sortByTimeDesc.setOptionalLabel();
		}
		return sortByTimeDesc;
	}

	public CheckBoxBase getSortByTime() {
		if (sortByTime == null) {
			sortByTime = new CheckBoxBase();
			sortByTime.setBounds(735, 35, 30, 20);
		}
		return sortByTime;
	}

	private LabelSmallBase getDocLocationDesc() {
		if (docLocationDesc == null) {
			docLocationDesc = new LabelSmallBase();
			docLocationDesc.setText("Location");
			docLocationDesc.setBounds(5, 50, 80, 20);
			docLocationDesc.setOptionalLabel();
		}
		return docLocationDesc;
	}

	private ComboDoctorLocation getDocLocation() {
		if (docLocation == null) {
			docLocation = new ComboDoctorLocation();
			docLocation.setBounds(90, 50, 120, 20);
		}
		return docLocation;
	}
	
	private LabelSmallBase getDrRoomDesc() {
		if (drRoomDesc == null) {
			drRoomDesc = new LabelSmallBase();
			drRoomDesc.setText("Dr. Room");
			drRoomDesc.setBounds(225, 50, 80, 20);
			drRoomDesc.setOptionalLabel();
		}
		return drRoomDesc;
	}

	private TextReadOnly getDrRoom() {
		if (drRoom == null) {
			drRoom = new TextReadOnly();
			drRoom.setBounds(300, 50, 120, 20);
		}
		return drRoom;
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
					if (getListTable().getSelectionModel().getSelectedItems().size() <= 0) {
						resetBookingEntry();
						Factory.getInstance().addErrorMessage("No backdate booking is allowed.", "PBA - [Doctor Appointment]", null, getListTable());
					} else if (getListTable().getSelectionModel().getSelectedItems().size() > 0) {
						if (DateTimeUtil.compareTo(memCurrdate, getDate(getListTable().getSelectedRowContent()[GrdPb_timeFrom].toString(), 10)) > 0) {
							resetBookingEntry();
							Factory.getInstance().addErrorMessage("No backdate booking is allowed.", "PBA - [Doctor Appointment]", null, getListTable());
						} else if ("B".equals(getListTable().getSelectedRowContent()[GrdPb_status])) {
							resetBookingEntry();
							Factory.getInstance().addErrorMessage("Schedule already blocked.", "PBA - [Schedule Blocking]", null, getListTable());
						}
					}
				}

				@Override
				public void onBlur() {
					// clear fields
					getNames().resetText();
					getPhoneH().resetText();
					getPhoneM().resetText();

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
										if (ONE_VALUE.equals(getDocLocation().getText().trim()) && TWAH_VALUE.equals(getUserInfo().getSiteCode())) {
											checkTodayApp(patNO);
										} else if (!isChangeBooking && HKAH_VALUE.equals(getUserInfo().getSiteCode())) {
											if (getListTable().getSelectionModel().getSelectedItems().size() > 0) {
												getDlgSameDateAppAlert().showDialog(patNO,getDate(getListTable().getSelectedRowContent()[GrdPb_timeFrom].toString(), 10));
											}
										}
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
					checkStaff();
					checkNewPatient();
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
			remarkDesc.setBounds(5, 55, 60, 20);
		}
		return remarkDesc;
	}

	private TextString getRemark() {
		if (remark == null) {
			remark = new TextString(175);
			remark.setBounds(70, 55, 360, 20);
		}
		return remark;
	}

	private LabelSmallBase getGovStaffDesc() {
		if (govStaffDesc == null) {
			govStaffDesc = new LabelSmallBase();
			govStaffDesc.setText("Gov. Staff");
			govStaffDesc.setBounds(445, 55, 60, 20);
		}
		return govStaffDesc;
	}

	private CheckBoxBase getGovStaff() {
		if (govStaff == null) {
			govStaff = new CheckBoxBase() {
				@Override
				public void onClick() {
					getRemark().setText("CIVIL SERVANT");
				}
			};
			govStaff.setBounds(500, 55, 30, 20);
		}
		return govStaff;
	}

	private LabelSmallBase getOtherLblDtlDesc() {
		if (otherLblDtlDesc == null) {
			otherLblDtlDesc = new LabelSmallBase();
			otherLblDtlDesc.setText("Label Rmk");
			otherLblDtlDesc.setBounds(545, 55, 80, 20);
		}
		return otherLblDtlDesc;
	}

	private TextString getOtherLblDtl() {
		if (otherLblDtl == null) {
			otherLblDtl = new TextString(22);
			otherLblDtl.setBounds(605, 55, 145, 20);
		}
		return otherLblDtl;
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

	private LabelSmallBase getSourceDesc() {
		if (sourceDesc == null) {
			sourceDesc = new LabelSmallBase();
			sourceDesc.setText("Source");
			sourceDesc.setBounds(548, 30, 50, 20);
		}
		return sourceDesc;
	}

	protected ComboBoxBase getSource() {
		if (source == null) {
			source = new ComboBoxBase("BOOKINGSRC", false, false, true);
			source.setBounds(592, 30, 158, 20);
		}
		return source;
	}

	private LabelSmallBase getSMSContentDesc() {
		if (SMSContentDesc == null) {
			SMSContentDesc = new LabelSmallBase();
			SMSContentDesc.setText("SMS Message Content");
			SMSContentDesc.setBounds(5, 80, 170, 20);
		}
		return SMSContentDesc;
	}

	private ComboBoxBase getSMSContent() {
		if (SMSContent == null) {
			SMSContent = new ComboBoxBase("SMSCONTENT", false, false, true);
			SMSContent.setBounds(130, 80, 150, 20);
		}
		return SMSContent;
	}

	private LabelSmallBase getNatureOfVisitDesc() {
		if (natureOfVisitDesc == null) {
			natureOfVisitDesc = new LabelSmallBase();
			natureOfVisitDesc.setText("Nature Of Visit");
			natureOfVisitDesc.setBounds(285, 80, 100, 20);
		}
		return natureOfVisitDesc;
	}

	private ComboBoxBase getNatureOfVisit() {
		if (natureOfVisit == null) {
			natureOfVisit = new ComboBoxBase("NATUREOFVISIT", false, false, true);
			natureOfVisit.setBounds(363, 80, 130, 20);
		}
		return natureOfVisit;
	}

	private LabelSmallBase getAlertDesc() {
		if (alertDesc == null) {
			alertDesc = new LabelSmallBase();
			alertDesc.setText("Initial Assessed");
			alertDesc.setBounds(508, 80, 100, 20);
		}
		return alertDesc;
	}

	private ComboBoxBase getAlert() {
		if (alert == null) {
			alert = new ComboBoxBase("ALERTSRC_BOOKING", false, false, true);
			alert.setBounds(592, 80, 158, 20);
		}
		return alert;
	}

	private LabelSmallBase getLMPDesc() {
		if (LMPDesc == null) {
			LMPDesc = new LabelSmallBase();
			LMPDesc.setText("LMP");
			LMPDesc.setBounds(5, 105, 30, 20);
		}
		return LMPDesc;
	}

	private TextDate getLMP() {
		if (LMP == null) {
			LMP = new TextDate();
			LMP.setBounds(40, 105, 95, 20);
		}
		return LMP;
	}

	private LabelSmallBase getEDCDesc() {
		if (EDCDesc == null) {
			EDCDesc = new LabelSmallBase();
			EDCDesc.setText("EDC");
			EDCDesc.setBounds(140, 105, 30, 20);
		}
		return EDCDesc;
	}

	private TextDate getEDC() {
		if (EDC == null) {
			EDC = new TextDate();
			EDC.setBounds(175, 105, 95, 20);
		}
		return EDC;
	}

	private LabelSmallBase getBirthOrderDesc() {
		if (birthOrderDesc == null) {
			birthOrderDesc = new LabelSmallBase();
			birthOrderDesc.setText("Birth Order");
			birthOrderDesc.setBounds(280, 105, 70, 20);
		}
		return birthOrderDesc;
	}

	private TextString getBirthOrder() {
		if (birthOrder == null) {
			birthOrder = new TextString(10);
			birthOrder.setBounds(345, 105, 50, 20);
		}
		return birthOrder;
	}

	private LabelSmallBase getReferralDoctorDesc() {
		if (referralDoctorDesc == null) {
			referralDoctorDesc = new LabelSmallBase();
			referralDoctorDesc.setText("Referral Doctor");
			referralDoctorDesc.setBounds(410, 105, 100, 20);
		}
		return referralDoctorDesc;
	}

	private TextString getReferralDoctor() {
		if (referralDoctor == null) {
			referralDoctor = new TextString(81);
			referralDoctor.setBounds(500, 105, 150, 20);
		}
		return referralDoctor;
	}

	private LabelSmallBase getWeeksDesc() {
		if (weeksDesc == null) {
			weeksDesc = new LabelSmallBase();
			weeksDesc.setText("Weeks");
			weeksDesc.setBounds(660, 105, 40, 20);
		}
		return weeksDesc;
	}

	private TextNum getWeeks() {
		if (weeks == null) {
			weeks = new TextNum(2, 2, false, false);
			weeks.setBounds(700, 105, 50, 20);
		}
		return weeks;
	}

	private ButtonBase getAddSchAction() {
		if (addSchAction == null) {
			addSchAction = new ButtonBase() {
				@Override
				public void onClick() {
					getSchDialog().showDialog(
							getMainFrame().getUserInfo().getSiteCode().trim(),
							getDrCode().getText().trim(),
							memCurrdate,
							getDefaultSpecCode()
						);
				}
			};
			addSchAction.setText("Add Schedule", 'A');
			addSchAction.setBounds(10, 490, 100, 23);
		}
		return addSchAction;
	}

	private ButtonBase getWeekSchAction() {
		if (weekSchAction == null) {
			weekSchAction = new ButtonBase() {
				@Override
				public void onClick() {
					setParameter("DOCCODE", getDrCode().getText());
					setParameter("SPCCODE", getDefaultSpecCode());
					showPanel(new WeekSchedule());
				}
			};
			weekSchAction.setText("Weekly Schedule", 'e');
			weekSchAction.setBounds(10, 515, 100, 23);
		}
		return weekSchAction;
	}

	private ButtonBase getGenerateAction() {
		if (generateAction == null) {
			generateAction = new ButtonBase() {
				@Override
				public void onClick() {
					getGenerateDialog().showDialog(getDrCode().getText(), null, getDefaultSpecCode());
				}
			};
			generateAction.setText("Generate", 'G');
			generateAction.setBounds(112, 490, 80, 48);
		}
		return generateAction;
	}

	private ButtonBase getBlockAction() {
		if (blockAction == null) {
			blockAction = new ButtonBase() {
				@Override
				public void onClick() {
					if (getListTable().getRowCount() > 0) {
						lockRecord("Schedule", getListTable().getSelectedRowContent()[GrdPb_bkgid], new String[] { "Block" });
					} else {
						Factory.getInstance().addErrorMessage("No schedule is selected to block.", "PBA - [Schedule Blocking]", null, getDefaultFocusComponent());
					}
				}
			};
			blockAction.setText("Block", 'B');
			blockAction.setBounds(194, 490, 80, 23);
		}
		return blockAction;
	}

	private ButtonBase getUnBlockAction() {
		if (unBlockAction == null) {
			unBlockAction = new ButtonBase() {
				@Override
				public void onClick() {
					if (getListTable().getRowCount() > 0 && getListTable().getSelectedRow() >= 0) {
						lockRecord("Schedule", getListTable().getSelectedRowContent()[GrdPb_bkgid], new String[] { "UnBlock" });
					} else {
						Factory.getInstance().addErrorMessage("No schedule is selected to unblock.", "PBA - [Schedule Blocking]", null, getDefaultFocusComponent());
					}
				}
			};
			unBlockAction.setText("UnBlock", 'U');
			unBlockAction.setBounds(194, 515, 80, 23);
		}
		return unBlockAction;
	}

	private ButtonBase getSlotSearchAction() {
		if (slotSearchAction == null) {
			slotSearchAction = new ButtonBase() {
				@Override
				public void onClick() {
					getSlotSearchDialog().showDialog(getDefaultSpecCode());
				}
			};
			slotSearchAction.setText("Slot Search", 'o');
			slotSearchAction.setBounds(276, 490, 80, 23);
		}
		return slotSearchAction;
	}

	private ButtonBase getQuotaCheckAction() {
		if (quotaCheckAction == null) {
			quotaCheckAction = new ButtonBase() {
				@Override
				public void onClick() {
					getQuotaCheckDialog().showDialog(getAlert().getText());
				}
			};
			quotaCheckAction.setText("Quota Check", 'Q');
			quotaCheckAction.setBounds(276, 515, 80, 23);
		}
		return quotaCheckAction;
	}

	private ButtonBase getRemarkAction() {
		if (remarkAction == null) {
			remarkAction = new ButtonBase() {
				@Override
				public void onClick() {
					if (getListTable().getRowCount() > 0) {
						lockRecord("Schedule", getListTable().getSelectedRowContent()[GrdPb_bkgid], new String[] { "Remark" });
					} else {
						Factory.getInstance().addErrorMessage("No schedule is selected to add remark.", "PBA - [Schedule Blocking]", null, getDefaultFocusComponent());
					}
				}
			};
			remarkAction.setText("Remark", 'R');
			remarkAction.setBounds(358, 490, 80, 23);
		}
		return remarkAction;
	}

	private ButtonBase getRegCheckAction() {
		if (regCheckAction == null) {
			regCheckAction = new ButtonBase() {
				@Override
				public void onClick() {
					getRightRightPanel().setVisible(!getRightRightPanel().isVisible());
					if (getRightRightPanel().isVisible()) {
						regCheckAction.el().addStyleName("button-alert");
						getAlert_RegCheck().setSelectedIndex("20");
						getRegistrationCheckListTable().removeAllRow();
					} else {
						regCheckAction.removeStyleName("button-alert");
					}
				}
			};
			regCheckAction.setText("Quota Alloc");
			regCheckAction.setBounds(358, 515, 80, 23);
		}
		return regCheckAction;
	}

	private ButtonBase getWalkInAction() {
		if (walkInAction == null) {
			walkInAction = new ButtonBase() {
				@Override
				public void onClick() {
					resetParameter("PatNo");
					resetParameter("BkgID");
					resetParameter("DocCode");
					showPanel(new PatientWalkIn());
				}
			};
			walkInAction.setText("Walk-In", 'W');
			walkInAction.setBounds(440, 490, 80, 48);
		}
		return walkInAction;
	}

	private ButtonBase getPriorityAction() {
		if (priorityAction == null) {
			priorityAction = new ButtonBase() {
				@Override
				public void onClick() {
					resetParameter("PatNo");
					resetParameter("BkgID");
					resetParameter("DocCode");
					showPanel(new PatientPriority());
				}
			};
			priorityAction.setText("Priority (Non-UC)", 'P');
			priorityAction.setBounds(522, 490, 110, 23);
		}
		return priorityAction;
	}

	private ButtonBase getUrgentCareAction() {
		if (urgentCareAction == null) {
			urgentCareAction = new ButtonBase() {
				@Override
				public void onClick() {
					resetParameter("PatNo");
					resetParameter("BkgID");
					resetParameter("DocCode");
					showPanel(new PatientUrgentCare());
				}
			};
			urgentCareAction.setText("Urgent Care", 'n');
			urgentCareAction.setBounds(522, 515, 100, 23);
		}
		return urgentCareAction;
	}

	private ButtonBase getAppBrowseAction() {
		if (appBrowseAcction == null) {
			appBrowseAcction = new ButtonBase() {
				@Override
				public void onClick() {
					showAppointmentBrowsePanel();
				}
			};
			appBrowseAcction.setText("Appointment Browse", 's');
			appBrowseAcction.setBounds(635, 490, 145, 23);
		}
		return appBrowseAcction;
	}
	
	private ButtonBase getAppBrowseRmAction() {
		if (appBrowseRmAcction == null) {
			appBrowseRmAcction = new ButtonBase() {
				@Override
				public void onClick() {
					showAppointmentBrowseRmPanel();
				}
			};
			appBrowseRmAcction.setText("Appt Browse (RM)", 'M');
			appBrowseRmAcction.setBounds(522, 490, 110, 23);
		}
		return appBrowseRmAcction;
	}

	private ButtonBase getPanelDrAction() {
		if (panelDrAction == null) {
			panelDrAction = new ButtonBase() {
				@Override
				public void onClick() {
					showInsurancePanelDr();
				}
			};
			panelDrAction.setText("Insurance Panel Dr", 'I');
			panelDrAction.setBounds(635, 515, 145, 23);
		}
		return panelDrAction;
	}

	private ButtonBase getRegSearchAcction() {
		if (regSearchAcction == null) {
			regSearchAcction = new ButtonBase() {
				@Override
				public void onClick() {
					showRegistrationSearchPanel();
				}
			};
			regSearchAcction.setText("Registration Search");
			regSearchAcction.setBounds(522, 515, 110, 23);
		}
		return regSearchAcction;
	}
	
	private ButtonBase getupdateSchAction() {
		if (updateSchAction == null) {
			updateSchAction = new ButtonBase() {
				@Override
				public void onClick() {
					getChgSchDialog().showDialog(getListTable().getSelectedRowContent()[GrdPb_bkgid],
							("".equals(getDrCode().getText())?getListTable().getSelectedRowContent()[GrdPb_docCode]:getDrCode().getText())
							,"DOCAPP");
				}
			};
			updateSchAction.setText("Chg Sch.Details");
			updateSchAction.setBounds(10, 540, 100, 23);
		}
		return updateSchAction;
	}

	// Info dialog start
	private DlgLabelPrint getInfoDialog() {
		if (infoDialog == null) {
			infoDialog = new DlgLabelPrint(getMainFrame()) {
				public void showGovBookingForm() {
					govUrl = Factory.getInstance().getSysParameter("GOVBKG");
					govUrl = govUrl + "?bkgid=" + newBkgID ;
					openNewWindow(govUrl);
				}

				@Override
				public void setVisible(boolean visible) {
					super.setVisible(visible);
					if (!visible) {
						searchAction();
						resetBookingEntry();
						getCurBKID().resetText();
						super.setVisible(false);
						if (isGovStaff) {
							Timer timer = new Timer() {
								 @Override
								 public void run() {
									 showGovBookingForm();
								 }
							 };
							timer.schedule(1500);
						}
					} else {
						super.setVisible(true);
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
									map.put("bkgsDate", getTime().getText().substring(0, getTime().getText().length() - 3));
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
					map.put("otherLblDtl", getOtherLblDtl().getText());
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

	private void checkTodayApp(final String patno) {
/*		QueryUtil.executeMasterBrowse(getUserInfo(), "SHOWTODAYAPP",
				new String[] { patno },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					final String patNo = mQueue.getContentField()[5];
//					final String patName = mQueue.getContentField()[6];
					String docName = null;
					String timeDate = null;
					String docLoc = null;
					List<String[]> rs = mQueue.getContentAsArray();
					if (mQueue.getContentField().length > 0) {
						for (String[] f : rs) {
							if (docName != null) {
								docName = docName + ConstantsVariable.SLASH_VALUE + f[2] + SPACE_VALUE + f[3];
								timeDate = timeDate + ConstantsVariable.SLASH_VALUE + f[4];
								docLoc = docLoc + ConstantsVariable.SLASH_VALUE + f[7];
							} else {
								docName = f[2] + SPACE_VALUE + f[3];
								timeDate = f[4];
								docLoc = f[7];
							}
						}
						getDlgTodayAppAlert().showDialog(patNo);
					}
				}
			}
		});*/
		getDlgTodayAppAlert().showDialog(patno);
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

	private DlgSameDateAppAlert getDlgSameDateAppAlert() {
		if (dlgSameDateAppAlert == null) {
			dlgSameDateAppAlert = new DlgSameDateAppAlert(getMainFrame());
		}
		return dlgSameDateAppAlert;
	}

	// block dialog start
	private DlgBlock getBlockDialog() {
		if (blockDialog == null) {
			blockDialog = new DlgBlock(getMainFrame()) {
				@Override
				public void post() {
					getThis().rePostAction();
				}

				@Override
				public void setVisible(boolean visible) {
					super.setVisible(visible);
					if (!visible && memScheduleID != null) {
						unlockRecord("Schedule", memScheduleID);
						memScheduleID = null;
					}
				}
			};
		}
		return blockDialog;
	}

	// remark dialog start
	public DialogBase getRemarkDialog() {
		if (remarkDialog == null) {
			remarkDialog = new DialogBase(getMainFrame(), DialogBase.OKCANCEL, 390, 130) {
				@Override
				public TextString getDefaultFocusComponent() {
					return getRemark_update();
				}

				@Override
				public void doOkAction() {
					doRemark();
				}

				@Override
				public void setVisible(boolean visible) {
					super.setVisible(visible);
					if (!visible && memScheduleID != null) {
						unlockRecord("Schedule", memScheduleID);
						memScheduleID = null;
					}
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
			remarkTopPanel.setBounds(5, 5, 365, 50);
			remarkTopPanel.setHeading("Remark");
			remarkTopPanel.add(getRemark_update(), null);
		}
		return remarkTopPanel;
	}

	private TextString getRemark_update() {
		if (remark_update == null) {
			remark_update = new TextString(120, false);
			remark_update.setBounds(10, 0, 340, 20);
		}
		return remark_update;
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

	private DlgSlotSearch getSlotSearchDialog() {
		if (slotSearchDialog == null) {
			slotSearchDialog = new DlgSlotSearch(getMainFrame()) {
				protected void post(String[] para) {
					getDrCode().setText(para[2]);
					getDateFrom().setText(para[3].substring(0,10));
					getDateTo().setText(para[3].substring(0,10));
					getSpecialty().setText(getSlotSearchSpeciality().getText().trim());
					memSlotSearchTime = para[3].substring(11, 16);
					memDoctorCode = para[2];
					searchAction();
				}
			};
		}
		return slotSearchDialog;
	}

	private DlgQuotaCheck getQuotaCheckDialog() {
		if (quotaCheckDialog == null) {
			quotaCheckDialog = new DlgQuotaCheck(getMainFrame());
		}
		return quotaCheckDialog;
	}
	
	private DlgChgScheduleDetail getChgSchDialog() {
		if (chgSchDialog == null) {
			chgSchDialog = new DlgChgScheduleDetail(getMainFrame()) {
				@Override
				public void dispose() {
					super.dispose();
					searchAction(true);
				}
			};
		}
		return chgSchDialog;
	}

	/*
	 * >>> override getSearchHeight for adjust the height of search panel========<<<<
	 */
	protected int getSearchHeight() {
		return 200;
	}

	/* >>> override getListWidth for adjust the width of the table list========<<<< */
	protected int getListWidth() {
		return 790;
	}

	public BasePanel getRightRightPanel() {
		if (rightRightPanel == null) {
			rightRightPanel = new BasePanel();
			rightRightPanel.setBounds(780, 5, 200, 343);
			rightRightPanel.add(getAlertDesc_RegCheck(), null);
			rightRightPanel.add(getAlert_RegCheck(), null);
			rightRightPanel.add(getRegistrationCheckScrollPane(), null);
			rightRightPanel.setVisible(false);
		}
		return rightRightPanel;
	}

	private LabelSmallBase getAlertDesc_RegCheck() {
		if (alertDesc_RegCheck == null) {
			alertDesc_RegCheck = new LabelSmallBase();
			alertDesc_RegCheck.setText("Initial Assessed");
			alertDesc_RegCheck.setBounds(5, 10, 100, 20);
		}
		return alertDesc_RegCheck;
	}

	private ComboBoxBase getAlert_RegCheck() {
		if (alert_RegCheck == null) {
			alert_RegCheck = new ComboBoxBase("ALERTSRC_BOOKING", false, false, true);
			alert_RegCheck.setBounds(5, 35, 158, 20);
		}
		return alert_RegCheck;
	}

	private int[] getTslotColumnWidths() {
		if (TWAH_VALUE.equals(getUserInfo().getSiteCode())) {
			return new int[] {0, 0, 0, 45, 37, 0};
		} else {
			return new int[] {0, 0, 0, 43, 20, 20};
		}
	}

	private String[] getTslotColumnNames() {
		return new String[] {EMPTY_VALUE, "SCHID", "SLTSTIME", "Time", "#", "N"};
	}

	private int[] getRegistrationCheckColumnWidths() {
		return new int[] {10, 120, 50};
	}

	private String[] getRegistrationCheckColumnNames() {
		return new String[] {EMPTY_VALUE, "Doctor", "Reg."};
	}

	private TableList getRegistrationCheckListTable() {
		if (registrationCheckListTable == null) {
			registrationCheckListTable = new TableList(getRegistrationCheckColumnNames(), getRegistrationCheckColumnWidths());
			registrationCheckListTable.setColumnResize(false);
		}
		return registrationCheckListTable;
	}

	public JScrollPane getRegistrationCheckScrollPane() {
		if (registrationCheckScrollPane == null) {
			registrationCheckScrollPane = new JScrollPane();
			registrationCheckScrollPane.setViewportView(getRegistrationCheckListTable());
			registrationCheckScrollPane.setBounds(0, 78, 200, 260);
		}
		return registrationCheckScrollPane;
	}

	private DoctorAppointment getThis() {
		return this;
	}
}