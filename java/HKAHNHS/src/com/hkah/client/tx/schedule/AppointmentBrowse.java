package com.hkah.client.tx.schedule;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MenuEvent;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.event.SelectionListener;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.menu.Menu;
import com.google.gwt.dom.client.Element;
import com.google.gwt.user.datepicker.client.CalendarUtil;
import com.hkah.client.Resources;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.combobox.ComboBookingStatus;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.combobox.ComboCountry;
import com.hkah.client.layout.combobox.ComboDoctorLocation;
import com.hkah.client.layout.combobox.ComboYN;
import com.hkah.client.layout.dialog.DialogBase;
import com.hkah.client.layout.dialog.DlgPrintAppList;
import com.hkah.client.layout.dialog.DlgRptAppListing;
import com.hkah.client.layout.dialog.DlgRptBookingList;
import com.hkah.client.layout.dialog.DlgSameDateAppAlert;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelSmallBase;
import com.hkah.client.layout.menu.MenuItemBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextDateWithCheckBox;
import com.hkah.client.layout.textfield.TextDoctorSearch;
import com.hkah.client.layout.textfield.TextNum;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextSpecialtySearch;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.tx.registration.PatientOut;
import com.hkah.client.tx.registration.PatientPriority;
import com.hkah.client.tx.registration.PatientUrgentCare;
import com.hkah.client.tx.registration.PatientWalkIn;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsRegistration;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class AppointmentBrowse extends MasterPanel implements ConstantsRegistration {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.APPOINTMENTBROWSE_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.APPOINTMENTBROWSE_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Loc",
				"Alert",
				EMPTY_VALUE,//"Booking ID",
				"Start Date/Time",
				"End Time",
				"#",
				"Patient No",
				"Patient Name",
				"Sex/Age",
				(TWAH_VALUE.equals(getUserInfo().getSiteCode())?"":"Nature of Visit"),
				"Remark",
				"Dr. Code",
				"Dr. FName",
				"Dr. GName",
				"Spec",
				"Country",
				"Mobile",
				"Phone",
				(TWAH_VALUE.equals(getUserInfo().getSiteCode())?"Nature of Visit":"Initial Assessed"),
				"Status",
				"Patient Chinese Name",
				"Interpreter",
				"Made By",
				"Capture Date/Time",
				"Remark Modified By",
				"Remark Modified Date/Time",
				"Cancelled By",
				"Cancelled Date/Time",
				"SMS",
				"SMS Sent Time",
				"SMS Real Sent Time",
				"SMS Return Msg",
				"SMS Sent Time (Doctor)",
				"SMS Real Sent Time (Doctor)",
				"SMS Return Msg (Doctor)",
				"LMP",
				"EDC",
				"Birth Order",
				"Referral Dr.",
				"Weeks",
				"SlotID",
				"ScheduleID",
				"Dental No.",
				"Source"
		 };
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		if (!isDisableFunction("grantMFM", "schAppoint")) {
			return new int[] { 60, 45, 0, 100, 55, 20, 60, 150, 55,
					(TWAH_VALUE.equals(getUserInfo().getSiteCode())?0:90),
					120, 55, 80, 120, 80, 100, 75, 75, 110, 60, 140, 60, 80, 120, 80, 120, 80, 120, 40,
					110, 110, 110,
					110, 110, 110,
					70, 70, 80, 120, 50,
					0, 0, ("DENTIST".equals(getDefaultSpecCode())?60:0),80 };
		} else {
			return new int[] { 60, 45, 0, 100, 55, 20, 60, 150, 55,
					(TWAH_VALUE.equals(getUserInfo().getSiteCode())?0:90),
					120, 55, 80, 120, 80, 100, 75, 75, 110, 60, 140, 60, 80, 120, 80, 120, 80, 120, 40,
					110, 110, 110,
					110, 110, 110,
					0, 0, 0, 0, 0,
					0, 0, ("DENTIST".equals(getDefaultSpecCode())?60:0),80 };
		}
	}

	@Override
	public boolean getNotShowMenu() {
		if (YES_VALUE.equals(getSysParameter("TxDtlColMu"))) {
			return false;
		} else {
			return true;
		}
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private BasePanel leftPanel = null;
	private BasePanel leftTopPanel = null;
	private LabelSmallBase startDateDESC = null;
	private TextDateWithCheckBox startDate = null;
	private LabelSmallBase endDateDESC = null;
	private TextDateWithCheckBox endDate = null;
	private LabelSmallBase DrCodeDESC = null;
	private TextDoctorSearch DrCode = null;
	private LabelSmallBase statusDESC = null;
	private ComboBookingStatus status = null;
	private LabelSmallBase patNoDESC = null;
	private TextPatientNoSearch patNo = null;
	private LabelSmallBase patNameDESC = null;
	private TextString patName = null;
	private LabelSmallBase docLocationDesc = null;
	private ComboDoctorLocation docLocation = null;
	private LabelSmallBase specialtyDESC = null;
	private TextSpecialtySearch specialty = null;
	private LabelSmallBase natureOfVisitDESC = null;
	private ComboBoxBase natureOfVisit = null;
	private LabelSmallBase initialAssessedDESC = null;
	private ComboBoxBase initialAssessed = null;
	private LabelSmallBase remarkDESC = null;
	private TextString remark = null;
	private LabelSmallBase sortByDESC = null;
	private ComboBoxBase sortBy = null;
	private LabelSmallBase sourceDesc = null;
	private ComboBoxBase source = null;
	// left top panel end
	// property on the bottom start
	private LabelSmallBase NoGLAPDESC = null;
	private TextString NoGLAP = null;
	private LabelSmallBase countDesc = null;
	private TextReadOnly count = null;
	// property on the bottom end
	// action button start
	private ButtonBase printPicklist = null;
	private ButtonBase printPicklistLabel = null;
	private ButtonBase cancelApp = null;
	private ButtonBase changeBooking = null;
	private ButtonBase pickListMR = null;
	private ButtonBase printAppLbl = null;
	private ButtonBase bookingListLabel = null;
	private ButtonBase printAppList = null;
	private ButtonBase editBooking = null;
	private ButtonBase editGovBooking = null;
	private ButtonBase printPicklistMR = null;
	private ButtonBase printApplistCS = null;
	private ButtonBase printPatientLabel = null;
	// action button end
	private BasePanel rightPanel = null;
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
	private LabelSmallBase cSourceDESC = null;
	private ComboBoxBase cSource = null;
	private LabelSmallBase cSMSContentDESC = null;
	private ComboBoxBase cSMSContent = null;
	private LabelSmallBase cAlertDESC = null;
	private ComboBoxBase cAlert = null;
	private LabelSmallBase cNatureOfVisitDESC = null;
	private ComboBoxBase cNatureOfVisit = null;
	private LabelSmallBase cLMPDesc = null;
	private TextDate cLMP = null;
	private LabelSmallBase cEDCDesc = null;
	private TextDate cEDC = null;
	private LabelSmallBase cBirthOrderDesc = null;
	private TextString cBirthOrder = null;
	private LabelSmallBase cReferralDoctorDesc = null;
	private TextString cReferralDoctor = null;
	private LabelSmallBase cWeeksDesc = null;
	private TextNum cWeeks = null;
	private ButtonBase change = null;
	private ButtonBase cancel = null;

	private String currDate = null;
	private String toSearchDate = null;
	private String memRLockID = null;

	private Menu contextMenu = null;
	private MenuItemBase cancelBookingMenu = null;
	private MenuItemBase editBookingMenu = null;
	private MenuItemBase changeBookingDetailMenu = null;

	private final int GrdPb_dlid = 0;
	private final int GrdPb_alert = 1;
	private final int GrdPb_bkgID = 2;
	private final int GrdPb_bkgsdate = 3;
	private final int GrdPb_patno = 6;
	private final int GrdPb_patname = 7;
	private final int GrdPb_natureOfVisit = 9;
	private final int GrdPb_remark = 10;
	private final int GrdPb_doccode = 11;
	private final int GrdPb_docfname = 12;
	private final int GrdPb_docgname = 13;
	private final int GrdPb_country = 15;
	private final int GrdPb_bkgmtel = 16;
	private final int GrdPb_bkgptel = 17;
	private final int GrdPb_bkgalert = 18;
	private final int GrdPb_bkgsts = 19;
	private final int GrdPb_bkgpcname = 20;
	private final int GrdPb_bkgsms = 28;
	private final int GrdPbCol_SlotID = 37;
	private final int GrdPbCol_SchID = 38;
	private final int GrdPbCol_DENTID = 39;
	private final int GrdPbCol_BKGSID = 40;

	private boolean rePost = false;

	private DlgRptAppListing dlgRptAppListing = null;
	private DlgRptBookingList dlgRptBookingListLabel = null;
	private DlgPrintAppList dlgPrintAppListing = null;
	private DlgSameDateAppAlert dlgSameDateAppAlert = null;

	private final static String STATUS_NORMAL = "N";
	private final static String STATUS_PENDING = "P";

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */

	/**
	 * This method initializes
	 *
	 */
	public AppointmentBrowse() {
		super();
	}

	@Override
	public void rePostAction() {
		if ("YES".equals(getParameter("showPatientProfile"))) {
			resetParameter("showPatientProfile");
		} else {
			if (getParameter("PatNo") != null) {
				getPatNo().setText(getParameter("PatNo"));
				removeParameter("PatNo");
				getPatNo().requestFocus();
			}
			if (getParameter("DocCode") != null) {
				getDrCode().setText(getParameter("DocCode"));
				removeParameter("DocCode");
				getDrCode().requestFocus();
			}
		}

		// unlock when exit previous screen
		if (memRLockID != null) {
			unlockRecord("Booking", memRLockID, new String[] { "searchAction" });
		} else {
			rePost = true;
			super.rePostAction();
		}
	}

	@Override
	protected void focusComponentAfterSearch() {
		// for child class call
		if (rePost) {
			getPatNo().selectAll();
			rePost = false;
		}
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	protected boolean init() {
		setNoGetDB(true);
		setLeftAlignPanel();
		getJScrollPane().setBounds(5, 135, 790, 300);
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		getListTable().setContextMenu(getPopupMenu());

		if (TWAH_VALUE.equals(getUserInfo().getSiteCode())) {
			getInitialAssessedDESC().setText("Nature of Visit:");
			getCAlertDESC().setText("Nature of Visit:");
			getNatureOfVisitDESC().setVisible(false);
			getNatureOfVisit().setVisible(false);
			getCNatureOfVisitDESC().setVisible(false);
			getCNatureOfVisit().setVisible(false);
		}

		boolean mfmFields = !isDisableFunction("grantMFM", "schAppoint");
		if (mfmFields) {
			getChangeBookingDialog().setBounds(300, 100, 400, 450);
			getChangeBookingPanel().setBounds(5, 5, 375, 370);
			getChange().setBounds(95, 380, 80, 25);
			getCancel().setBounds(180, 380, 80, 25);
		} else {
			getChangeBookingDialog().setBounds(300, 100, 400, 335);
			getChangeBookingPanel().setBounds(5, 5, 375, 260);
			getChange().setBounds(95, 265, 80, 25);
			getCancel().setBounds(180, 265, 80, 25);
		}
		getCLMPDesc().setVisible(mfmFields);
		getCLMP().setVisible(mfmFields);
		getCEDCDesc().setVisible(mfmFields);
		getCEDC().setVisible(mfmFields);
		getCBirthOrderDesc().setVisible(mfmFields);
		getCBirthOrder().setVisible(mfmFields);
		getCReferralDoctorDesc().setVisible(mfmFields);
		getCReferralDoctor().setVisible(mfmFields);
		getCWeeksDesc().setVisible(mfmFields);
		getCWeeks().setVisible(mfmFields);

		getNoGLAP().setText(getSysParameter("GenLabel"));

		currDate = getMainFrame().getServerDate();

		// limit the date selection
		Date toSearchDateInDate = null;
		try {
			toSearchDateInDate = DateTimeUtil.parseDate(currDate);
			CalendarUtil.addDaysToDate(toSearchDateInDate, Integer.parseInt(getSysParameter("SEARCHTODT")));
			toSearchDate = DateTimeUtil.formatDate(toSearchDateInDate);
		} catch (Exception e) {
		}

		clearAction();

		//getNoGLAP().setText(CommonUtil.getSysparam(getUserInfo(), "GenLabel"));
		getCount().setText(ZERO_VALUE);
		getListTable().setColumnClass(GrdPb_dlid, new ComboDoctorLocation(), false);
		getListTable().setColumnColor(GrdPb_alert, "red");
		//getListTable().setColumnClass(GrdPb_natureOfVisit, new ComboBoxBase("NATUREOFVISIT", false, false, true), false);
		getListTable().setColumnColor(GrdPb_remark, "blue");
		getListTable().setColumnClass(GrdPb_country, new ComboCountry(), false);
		getListTable().setColumnClass(GrdPb_bkgalert, new ComboBoxBase("ALERTSRC", false, false, true), false);
		getListTable().setColumnClass(GrdPb_bkgsts, new ComboBookingStatus(), false);
		getListTable().setColumnClass(GrdPb_bkgsms, new ComboYN(), false);

		if (getParameter("qPATNO") != null) {
			getPatNo().setText(getParameter("qPATNO"));
			getPatName().setText(getParameter("qPATNAME"));
			getEndDate().setText(getParameter("qENDDATE"));
			getDrCode().setText(getParameter("qDOCCODE"));
			setParameter("qPATNO", ConstantsVariable.EMPTY_VALUE);
			setParameter("qPATNAME", ConstantsVariable.EMPTY_VALUE);
			setParameter("qENDDATE", ConstantsVariable.EMPTY_VALUE);
			setParameter("qDOCCODE", ConstantsVariable.EMPTY_VALUE);
		}
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public Component getDefaultFocusComponent() {
		return getPatNo();
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
		// enable/disable field
	}

	/* >>> ~14~ Set Browse Validation ===================================== <<< */
	@Override
	protected boolean browseValidation() {
		if (getStatus().isEmpty() &&
				getStartDate().isEmpty() && getEndDate().isEmpty() &&
				getDrCode().isEmpty() && getPatNo().isEmpty() &&
				getPatName().isEmpty()) {
			Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_INPUT_CRITERIA, "Appointment Browse", getStartDate());
			return false;
		} else if (getStartDate().getText().length() == 0) {
			Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_DATE_REQUIRED, "Appointment Browse", getStartDate());
			return false;
		} else if (!getDocLocation().isEmpty() && !getDocLocation().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid Doctor Location.", "Appointment Browse", getDocLocation());
			return false;
//		} else if (!getSpecialty().isEmpty() && !getSpecialty().isValid()) {
//			Factory.getInstance().addErrorMessage("Invalid Speciality.", "Appointment Browse", getSpecialty());
//			return false;
		}
//		if (!getPatNo().isEmpty()) {
//			MessageQueue mQueue = QueryUtil.executeMasterFetch(getUserInfo(), "PATIENT",
//				new String[] {getPatNo().getText().trim()});
//			if (!mQueue.success()) {
//				setParameter("qPATNO", getPatNo().getText().trim());
//				setParameter("qPATNAME", getPatName().getText().trim());
//				setParameter("qENDDATE", getEndDate().getText().trim());
//				setParameter("qDOCCODE", getDrCode().getText().trim());
//				showPanel(OutPatient.class);
//				return false;
//			}
//		}
		return true;
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
				getStartDate().getText().trim(),
				getEndDate().getText().trim(),
				getDrCode().getText().trim(),
				getStatus().getText().trim(),
				getPatNo().getText().trim(),
				getPatName().getText().trim(),
				getDocLocation().getText().trim(),
				getSpecialty().getText().trim(),
				getDefaultSpecCode(),
				getRemark().getText().trim(),
				getNatureOfVisit().getText().trim(),
				getInitialAssessed().getText().trim(),
				getSource().getText().trim(),
				getSortBy().getText().trim(),
				getUserInfo().getUserID()
		};
	}

	/* >>> ~15.1~ Set Browse Output Results =============================== <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {/*
		getCount().setText(String.valueOf(getListTable().getRowCount()));
		if (outParam != null && outParam.length > 0) {
			if ("Normal".equals(outParam[11])) {
				if (date.equals(getDate(outParam[1].toString(),10))) {
					 getAcceptButton().setEnabled(true);
				} else {
					getAcceptButton().setEnabled(false);
					if (DateTimeUtil.compareTo(date,getDate(outParam[1].toString(),10)) == -1) {
					}
				}
			}
		}*/
	}

	/* >>> ~16~ Set Fetch Input Parameters ================================ <<< */
	@Override
	protected String[] getFetchInputParameters() {
		// fetch template detail by doctor code
		return null;
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {
		listTableRowChange();
	}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return null;
	}

	@Override
	protected boolean isAddNumberingColumn() {
		return true;
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	protected String getDefaultSpecCode() {
		return getUserInfo().getOtherCode();
	}

	private void doChangeBookingDetail() {
		if (getCPatTel().isEmpty() && getCPatMTel().isEmpty()) {
			Factory.getInstance().addErrorMessage("Missing Patient Telephone No/Mobile Phone.", "PBA - [Appointment Browse]", getCPatTel());
		} else if (getCPatName().isEmpty()) {
			Factory.getInstance().addErrorMessage("Missing Patient Name.", "PBA - [Appointment Browse]", getCPatTel());
		} else if (YES_VALUE.equals(getSysParameter("BOKSRCMUST")) && getCSource().isEmpty()) {
			Factory.getInstance().addErrorMessage("Please input source.", "PBA - [Appointment Browse]", getCSource());
		} else if (!getCSMSContent().isEmpty() && getCPatMTel().isEmpty()) {
			Factory.getInstance().addErrorMessage("SMS is checked, please input Mobile Phone.", "PBA - [Appointment Browse]", getCPatMTel());
		} else if (YES_VALUE.equals(getSysParameter("AppAltEnty")) && getCAlert().isEmpty()) {
			Factory.getInstance().addErrorMessage("Initial Assessed is mandatory, please select one option.", "PBA - [Appointment Browse]", getCAlert());
		} else if (YES_VALUE.equals(getSysParameter("AppAltEnty")) && !getCAlert().isEmpty() && !getCAlert().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid Initial Assessed.", "PBA - [Doctor Appointment]", getCAlert());
		} else if (!getCAlert().isEmpty() && HKAH_VALUE.equals(getUserInfo().getSiteCode()) && getCNatureOfVisit().isEmpty()) {
			Factory.getInstance().addErrorMessage("Invalid Nature of Visit.", "PBA - [Doctor Appointment]", getCNatureOfVisit());
		} else if (!getCLMP().isEmpty() && !getCLMP().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid LMP.", "PBA - [Appointment Browse]", getCLMP());
		} else if (!getCEDC().isEmpty() && !getCEDC().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid EDC.", "PBA - [Appointment Browse]", getCEDC());
		} else {
			doChangeBookingDetailHelper(EMPTY_VALUE);
		}
	}

	private void doChangeBookingDetailHelper(String isUpdatePatientSMS) {
		QueryUtil.executeMasterAction(getUserInfo(), ConstantsTx.BOOKINGCHANGE_TXCODE, QueryUtil.ACTION_APPEND,
				new String[] {
					getListTable().getSelectedCellContent(GrdPb_bkgID),
					getCPatNo().getText().trim(),
					getCPatName().getText().trim(),
					getCPatCName().getText().trim(),
					getCPatTel().getText().trim(),
					getCPatMTel().getText().trim(),
					getCRemark().getText().trim(),
					getCSource().getText().trim(),
					getCSMSContent().getText().trim(),
					getCAlert().getText().trim(),
					getCLMP().getText().trim(),
					getCEDC().getText().trim(),
					getCBirthOrder().getText().trim(),
					getCReferralDoctor().getText().trim(),
					getCWeeks().getText().trim(),
					getCNatureOfVisit().getText().trim(),
					//----Add Param by Andrew 27/02/2012----
					getUserInfo().getUserID()
					//--------------------------------------
				},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					if ("2".equals(mQueue.getReturnCode())) {
						MessageBoxBase.addWarningMessage(
								"PBA - [Appointment Browse]",
								mQueue.getReturnMsg(),
								new Listener<MessageBoxEvent>() {
									public void handleEvent(MessageBoxEvent be) {
										doChangeBookingDetailHelperSuccess();
									}
								});
					} else {
						doChangeBookingDetailHelperSuccess();
					}
//				} else if ("-100".equals(mQueue.getReturnCode())) {
//					MessageBoxBase.confirm(MSG_PBA_SYSTEM, mQueue.getReturnMsg(),
//							new Listener<MessageBoxEvent>() {
//						@Override
//						public void handleEvent(MessageBoxEvent be) {
//							if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
//								doChangeBookingDetailHelper(YES_VALUE);
//							} else {
//								doChangeBookingDetailHelper(NO_VALUE);
//							}
//						}
//					});
				} else {
					Factory.getInstance().addErrorMessage(mQueue.getReturnMsg(), "PBA - [Appointment Browse]");
				}
			}
		});
	}

	private void doChangeBookingDetailHelperSuccess() {
		searchAction();
//		getChangeBookingDialog().hide();
		getChangeBookingDialog().dispose();
//		setChangeBookingDialog(null);
	}

	private void cancelAppointmentPre() {
		if (getListTable().getSelectedRow() >= 0) {
			QueryUtil.executeMasterAction(
				getUserInfo(),
				"RECORDLOCK",
				QueryUtil.ACTION_APPEND,
				new String[] {
						"Booking",
						getListTable().getSelectedCellContent(GrdPb_bkgID),
						CommonUtil.getComputerName(),
						getUserInfo().getUserID()
				},
				new MessageQueueCallBack() {
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							memRLockID = getListTable().getSelectedCellContent(GrdPb_bkgID);

							if (STATUS_NORMAL.equals(getListTable().getSelectedCellContent(GrdPb_bkgsts)) || STATUS_PENDING.equals(getListTable().getSelectedCellContent(GrdPb_bkgsts))) {
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
														String docfname = getListTable().getSelectedCellContent(GrdPb_docfname);
														String docgname = getListTable().getSelectedCellContent(GrdPb_docgname);

														Map<String, String> params = new HashMap<String, String>();
														params.put("App. Date", getListTable().getSelectedCellContent(GrdPb_bkgsdate));
														params.put("Doctor Name", docfname + " " + docgname);
														getAlertCheck().checkAltAccess(
																getListTable().getSelectedCellContent(GrdPb_patno).trim(),
																funname, true, true, params);

														Factory.getInstance().addInformationMessage(MSG_CANCELAPT_SUCCESS, "PBA-[Appointment Browse]");
														getDlgSameDateAppAlert().showDialog(getListTable().getSelectedCellContent(GrdPb_patno).trim(),getDate(getListTable().getSelectedCellContent(GrdPb_bkgsdate).toString(), 10));
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

	private void editAppointment() {
		if (getListTable().getSelectedRow() >= 0) {
			if ("N".equals(getListTable().getSelectedCellContent(GrdPb_bkgsts))) {
				QueryUtil.executeMasterFetch(getUserInfo(), getTxCode(),
						new String[] { getListTable().getSelectedCellContent(GrdPb_bkgID)},
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							// get first return value and assign to district
							String[] para = mQueue.getContentField();
							if (para.length > 0) {
								setParameter("START_TYPE", "ChangeBooking");
								setParameter("BKPatNo", para[0]);
								setParameter("PatName", para[1]);
								setParameter("PatHTel", para[3]);
								setParameter("PatMTel", para[4]);
								setParameter("Remark", para[5]);
								setParameter("Source", para[6]);
//								setParameter("SMS", para[7]);
								setParameter("SMSContent", para[7]);
								setParameter("PatAlert", para[8]);
								setParameter("OBLMP", para[9]);
								setParameter("OBEDC", para[10]);
								setParameter("OBBirthOrder", para[11]);
								setParameter("OBReferralDoctor", para[12]);
								setParameter("OBWeeks", para[13]);
								setParameter("BKGSCnt", para[14]);
								setParameter("BKDocCode", getListTable().getSelectedCellContent(GrdPb_doccode));
								setParameter("DocLoc", getListTable().getSelectedCellContent(GrdPb_dlid));
								String appointmentDate = getListTable().getSelectedCellContent(GrdPb_bkgsdate);
								final String docLocation = para[15];
								setParameter("PatNatOfVis", para[16]);
								if (appointmentDate != null && appointmentDate.length() > 10) {
									setParameter("AppointmentDate", appointmentDate.substring(0, 10));
								} else {
									resetParameter("AppointmentDate");
								}
								setParameter("RLockID", getListTable().getSelectedCellContent(GrdPb_bkgID));
								QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
										new String[] { "GOVREG", "BKGID, GOVJOBCODE, GOVSEX, TO_CHAR(TESTDATE,'DD/MM/YYYY HH24:MI') ", "BKGID = '"+getListTable().getSelectedCellContent(GrdPb_bkgID)+"'"},
										new MessageQueueCallBack() {
									@Override
									public void onPostSuccess(MessageQueue mQueue) {
										if (mQueue.success()) {
											String[] para1 = mQueue.getContentField();
											if (para1 != null && para1.length > 0) {
													setParameter("GovStaff", para1[0]);
											} else {
												resetParameter("GovStaff");
											}
										} else {
											resetParameter("GovStaff");
										}
										if (DOCLOCTION_WELLBABY.equals(docLocation)) {
											showWellBabyAppointmentPanel();
										} else {
											showDoctorAppointmentPanel();
										}
									}
								});

							}
						}
					}
				});
			} else {
				Factory.getInstance().addErrorMessage("Can't change the selected record", "PBA-[Appointment Browse]");
			}
		}
	}

	private void showGovBookingForm() {
		if (getListTable().getSelectedRow() >= 0) {
			String govUrl = Factory.getInstance().getSysParameter("GOVBKG");
			govUrl = govUrl + "?bkgid=" + getListTable().getSelectedCellContent(GrdPb_bkgID) ;
			openNewWindow(govUrl);
		} else {
			Factory.getInstance().addErrorMessage("Please select a vaild record", "PBA-[Appointment Browse]");
		}
	}

	private void changeBookingDetail() {
		if (getListTable().getSelectedRow() >= 0) {
			QueryUtil.executeMasterFetch(getUserInfo(), getTxCode(),
					new String[] { getListTable().getSelectedCellContent(GrdPb_bkgID)},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					getCPatNo().resetText();
					getCPatName().resetText();
					getCPatCName().resetText();
					getCPatTel().resetText();
					getCPatMTel().resetText();
					getCRemark().resetText();
					getCSource().resetText();
					getCSMSContent().resetText();
					getCAlert().resetText();
					getCLMP().resetText();
					getCEDC().resetText();
					getCBirthOrder().resetText();
					getCReferralDoctor().resetText();
					getCWeeks().resetText();
					getCNatureOfVisit().resetText();

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
							getCSource().setText(para[6]);
							getCSMSContent().setText(para[7]);
							getCAlert().setText(para[8]);
							getCLMP().setText(para[9]);
							getCEDC().setText(para[10]);
							getCBirthOrder().setText(para[11]);
							getCReferralDoctor().setText(para[12]);
							getCWeeks().setText(para[13]);
							getCNatureOfVisit().setText(para[16]);
							//-------------------------------------
							getChangeBookingDialog().setVisible(true);
						}
					}
				}
			});
		}
	}

/*
	private void canReg(String bkgId) {
		if (bkgId == null || bkgId.isEmpty()) {
			return;
		}
		bkgId = bkgId.trim();

		if (bkgId.length() > 0) {
			QueryUtil.executeMasterFetch( getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] { "booking", "bkgsts", "bkgid= '"+bkgId+"'" },
					new MessageQueueCallBack() {
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						String bkgsts = mQueue.getContentField()[0];

						if ("B".equals(bkgsts)) {
							Factory.getInstance()
								.addErrorMessage(MSG_APP_BLOCKED,
										"PBA-[Appointment Browse]");
						} else if ("C".equals(bkgsts)) {
							Factory.getInstance()
								.addErrorMessage(MSG_APP_CANCELLED,
										"PBA-[Appointment Browse]");
						} else if ("F".equals(bkgsts)) {
							Factory.getInstance()
								.addErrorMessage(MSG_APP_REGISTERED,
										"PBA-[Appointment Browse]");
						} else {
							afterCanReg();
						}
					}
				}
			});
		} else {
			afterCanReg();
		}
	}
*/
	private void afterCanReg() {
		QueryUtil.executeMasterAction(
				getUserInfo(),
				"BOOKING_CHECK",
				QueryUtil.ACTION_APPEND,
				new String[] {
					getListTable().getSelectedCellContent(GrdPb_bkgID),
					CommonUtil.getComputerName(),
					getUserInfo().getUserID()
				},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					memRLockID = getListTable().getSelectedCellContent(GrdPb_bkgID);

					setParameter("START_TYPE", REG_NORMAL);
					setParameter("CallForm", "schBooking");
					setParameter("BkgID", memRLockID);
					setParameter("PatNo", getListTable().getSelectedCellContent(GrdPb_patno));
					setParameter("PatFName", getListTable().getSelectedCellContent(GrdPb_patname));
					setParameter("PatCName", getListTable().getSelectedCellContent(GrdPb_bkgpcname));
					setParameter("DocCode", getListTable().getSelectedCellContent(GrdPb_doccode));
					setParameter("Tel", getListTable().getSelectedCellContent(GrdPb_bkgptel));
					setParameter("FromBk", "bkgz");
					setParameter("MTel", getListTable().getSelectedCellContent(GrdPb_bkgmtel));
					setParameter("BkgSDate", getListTable().getSelectedCellContent(GrdPb_bkgsdate));
					setParameter("showPatientProfile", "YES");
					setParameter("BkgNatureOfVisit", getListTable().getSelectedCellContent(GrdPb_natureOfVisit));

					String docLocID = getListTable().getSelectedCellContent(GrdPb_dlid);
					if (docLocID != null && docLocID.length() > 0) {
						QueryUtil.executeMasterFetch( getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
								new String[] { "doclocation", "regopcat,doctype", "doclocid='" + docLocID + "'" },
								new MessageQueueCallBack() {
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									String regOPCat = mQueue.getContentField()[0];
									String docType = mQueue.getContentField()[1];

									if (DOCLOCTION_WELLBABY.equals(docType)) {
										setParameter("isAlertClinic", "WellBaby");
									}
									if (REG_CAT_URGENTCARE.equals(regOPCat)) {
										showPanel(new PatientUrgentCare());
									} else if (REG_CAT_PRIORITY.equals(regOPCat)) {
										showPanel(new PatientPriority());
									} else if (REG_CAT_WALKIN.equals(regOPCat)) {
										showPanel(new PatientWalkIn());
									} else {
										showPanel(new PatientOut());
									}
								} else {
									showPanel(new PatientOut());
								}
							}
						});
					} else {
						showPanel(new PatientOut());
					}

					if (memRLockID != null) {
						unlockRecord("Booking", memRLockID);
					}
				} else {
					Factory.getInstance().addErrorMessage(mQueue);
				}
			}
		});
	}

	private String getDate(String date, int len) {
		return date.substring(0, len);
	}

	private void listTableRowChange() {
		Factory.getInstance().writeLogToLocal("[DEBUG][AppointmentBrowse] listTableRowChange");
		int count = getListTable().getRowCount();
		getCount().setText(String.valueOf(count));

		getPrintPicklist().setEnabled(!isDisableFunction("btnPrintPicklist", "schBooking"));
		getPrintPicklistLabel().setEnabled(!isDisableFunction("btnPrintPicklistLbl", "schBooking"));

		Factory.getInstance().writeLogToLocal("[DEBUG] count=" + count + ", selRowIndex=" + getListTable().getSelectedRow());

		if (count > 0 && getListTable().getSelectedRow() >= 0) {
			int compare = DateTimeUtil.compareTo(currDate, getDate(getListTable().getSelectedCellContent(GrdPb_bkgsdate).toString(), 10));
			boolean normalStatus = STATUS_NORMAL.equals(getListTable().getSelectedCellContent(GrdPb_bkgsts)) || STATUS_PENDING.equals(getListTable().getSelectedCellContent(GrdPb_bkgsts));
			boolean allowCancel = compare < 1 && normalStatus && !isDisableFunction("btnCancelApp", "schBooking");
			boolean allowChange = !isDisableFunction("btnChgBooking", "schBooking");
			boolean allowRegFuture = !isDisableFunction("btnAllowRegFuture", "schBooking");
			boolean allowAccept = isDisableFunction("btnNotAllowAcceptReg", "schBooking")
			||getUserInfo().getUserID().equals(getUserInfo().getSiteCode());

			Factory.getInstance().writeLogToLocal("[DEBUG] allowCancel="+allowCancel+", allowChange="+allowChange
					+", allowRegFuture="+allowRegFuture+", allowAccept="+allowAccept);

			getAcceptButton().setEnabled((compare == 0 || allowRegFuture) && normalStatus && allowAccept);
			getCancelApp().setEnabled(allowCancel);
			getChangeBooking().setEnabled(allowChange);
			getEditBooking().setEnabled(allowChange);
			getEditGovBooking().setEnabled(allowChange);
			getCancelBookingMenu().setEnabled(allowCancel);
			getEditBookingMenu().setEnabled(allowCancel);
			getChangeBookingDetailMenu().setEnabled(allowChange);
			getModifyButton().setEnabled(allowCancel);
			getDeleteButton().setEnabled(allowCancel);
		} else {
			getAcceptButton().setEnabled(false);
			getCancelApp().setEnabled(false);
			getChangeBooking().setEnabled(false);
			getEditBooking().setEnabled(false);
			getEditGovBooking().setEnabled(false);
			getCancelBookingMenu().setEnabled(false);
			getEditBookingMenu().setEnabled(false);
			getChangeBookingDetailMenu().setEnabled(false);
			getModifyButton().setEnabled(false);
			getDeleteButton().setEnabled(false);
		}
		if (isDisableFunction("btnPrintAppList", "schAppoint")) {
			getPrintAppList().setEnabled(false);
			getPrintPicklistMR().setEnabled(true);
		} else {
			getPrintAppList().setEnabled(true);
			getPrintPicklistMR().setEnabled(false);
		}
		getPickListMR().setEnabled(!isDisableFunction("btnMedRec", "schBooking"));
		getBookingListLabel().setEnabled(!isDisableFunction("btnPrintPicklistLbl", "schBooking"));
	}

	private void charge(int type, boolean mrChartLocation) {
		if (type == 1) {
			getDlgRptAppListing().showDialog(type, mrChartLocation, getNoGLAP().getText());
		} else {
			getDlgRptAppListing().showDialog(type, mrChartLocation, null);
		}
	}

	protected void showDoctorAppointmentPanel() {
		showPanel(new DoctorAppointment());
	}

	protected void showWellBabyAppointmentPanel() {
		showPanel(new WellBabyAppointmentBrowse());
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected void unlockRecordReady(final String lockType, final String lockKey, String[] record, boolean unlock, String returnMessage) {
		memRLockID = null;
		if (record != null) {
			searchAction();
		}
	}

	@Override
	protected void enableButton(String mode) {
		Factory.getInstance().writeLogToLocal("[DEBUG][AppointmentBrowse] enableButton mode="+mode);

		disableButton();
		getSearchButton().setEnabled(true);
		getRefreshButton().setEnabled(true);
		getClearButton().setEnabled(true);

		listTableRowChange();
	}

	/* >>> override getSearchHeight for adjust the height of search panel========<<<< */
	@Override
	protected int getSearchHeight() {
		return 95;
	}

	/* >>> override getListWidth for adjust the width of the table list========<<<< */
	@Override
	protected int getListWidth() {
		return 790;
	}

	@Override
	public void modifyAction() {
		editAppointment();
	}

	@Override
	public void deleteAction() {
		cancelAppointmentPre();
	}

	@Override
	public void clearAction() {
		getDrCode().resetText();
		getPatNo().resetText();
		getPatName().resetText();
		getStartDate().setText(currDate);
		getEndDate().setText(toSearchDate);
		getStatus().setSelectedIndex(0);
		getDocLocation().resetText();
	}

	@Override
	public void acceptAction() {
		// canReg() // done canReg checking in NHS_ACT_BOOKING_CHECK
		if (getAcceptButton().isEnabled()) {
			afterCanReg();
		}
	}

	@Override
	protected boolean triggerSearchField() {
		if (getPatNo().isFocusOwner()) {
			getPatNo().checkTriggerBySearchKey();
			return true;
		} else if (getDrCode().isFocusOwner()) {
			getDrCode().checkTriggerBySearchKey();
			return true;
		} else {
			return false;
		}
	}
	
	/*
	@Override
	protected void performListPost() {
		super.performListPost();
		setBackgroundColorToView();
	}
	
	-- bug: cannot get cell outside visible container in BufferedTableList, set color in sql
	private void setBackgroundColorToView() {		
		Element cell = null;
		int IDX_NATUREOFVISIT = 10;
		for (int j = 0; j < getListTable().getRowCount(); j++) {
			// highlight Tent Case cell
			String natureOfVisit = getListTable().getValueAt(j, IDX_NATUREOFVISIT);
			if ("Tent".equals(natureOfVisit)) {
				cell = getListTable().getView().getCell(j, IDX_NATUREOFVISIT);
				if (cell != null) {
					cell.addClassName("cell-alert1");
				}
			}
		}
	}
	*/

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/**
	 * init the left panel
	 */
	@Override
	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.add(getLeftTopPanel(), null);
			leftPanel.add(getJScrollPane());
			leftPanel.add(getNoGLAPDESC(), null);
			leftPanel.add(getNoGLAP(), null);
			leftPanel.add(getCountDesc(), null);
			leftPanel.add(getCount(), null);
			leftPanel.add(getPrintPicklist(), null);
			leftPanel.add(getPrintPicklistLabel(), null);
			leftPanel.add(getCancelApp(), null);
			leftPanel.add(getChangeBooking(), null);
			leftPanel.add(getPickListMR(), null);
			leftPanel.add(getPrintAppLbl(), null);
			leftPanel.add(getBookingListLabel(), null);
			leftPanel.add(getPrintAppList(), null);
			leftPanel.add(getEditBooking(), null);
			leftPanel.add(getEditGovBooking(), null);
			leftPanel.add(getPrintPicklistMR(), null);
			leftPanel.add(getPrintApplistCS(), null);
			leftPanel.add(getPrintPatientLabel(), null);
			leftPanel.setSize(800, 530);
		}
		return leftPanel;
	}

	/**
	 * init the right panel
	 */
	@Override
	protected BasePanel getRightPanel() {
		if (rightPanel == null) {
			rightPanel = new BasePanel();
		}
		return rightPanel;
	}

	private BasePanel getLeftTopPanel() {
		if (leftTopPanel == null) {
			leftTopPanel = new BasePanel();
			leftTopPanel.setEtchedBorder();
			leftTopPanel.setBounds(5, 5, 790, 140);
			leftTopPanel.add(getStartDateDESC(), null);
			leftTopPanel.add(getStartDate(), null);
			leftTopPanel.add(getEndDateDESC(), null);
			leftTopPanel.add(getEndDate(), null);
			leftTopPanel.add(getDrCodeDESC(), null);
			leftTopPanel.add(getDrCode(), null);
			leftTopPanel.add(getStatusDESC(), null);
			leftTopPanel.add(getStatus(), null);
			leftTopPanel.add(getPatNoDESC(), null);
			leftTopPanel.add(getPatNo(), null);
			leftTopPanel.add(getPatNameDESC(), null);
			leftTopPanel.add(getPatName(), null);
			leftTopPanel.add(getDocLocationDesc(), null);
			leftTopPanel.add(getDocLocation(), null);
			leftTopPanel.add(getSpecialtyDESC(), null);
			leftTopPanel.add(getSpecialty(), null);
			leftTopPanel.add(getRemarkDESC(), null);
			leftTopPanel.add(getRemark(), null);
			leftTopPanel.add(getNatureOfVisitDESC(), null);
			leftTopPanel.add(getNatureOfVisit(), null);
			leftTopPanel.add(getInitialAssessedDESC(), null);
			leftTopPanel.add(getInitialAssessed(), null);
			leftTopPanel.add(getSortByDESC(), null);
			leftTopPanel.add(getSortBy(), null);
			leftTopPanel.add(getSourceDesc(), null);
			leftTopPanel.add(getSource(), null);
		}
		return leftTopPanel;
	}

	private LabelSmallBase getStartDateDESC() {
		if (startDateDESC == null) {
			startDateDESC = new LabelSmallBase();
			startDateDESC.setText("Start Date/time");
			startDateDESC.setBounds(5, 5, 100, 20);
			startDateDESC.setOptionalLabel();
		}
		return startDateDESC;
	}

	private TextDateWithCheckBox getStartDate() {
		if (startDate == null) {
			startDate = new TextDateWithCheckBox();
			startDate.setBounds(110, 5, 120, 20);
		}
		return startDate;
	}

	private LabelSmallBase getEndDateDESC() {
		if (endDateDESC == null) {
			endDateDESC = new LabelSmallBase();
			endDateDESC.setText("End Date/time");
			endDateDESC.setBounds(270, 5, 100, 20);
			endDateDESC.setOptionalLabel();
		}
		return endDateDESC;
	}

	private TextDateWithCheckBox getEndDate() {
		if (endDate == null) {
			endDate = new TextDateWithCheckBox();
			endDate.setBounds(375, 5, 120, 20);
		}
		return endDate;
	}

	private LabelSmallBase getDrCodeDESC() {
		if (DrCodeDESC == null) {
			DrCodeDESC = new LabelSmallBase();
			DrCodeDESC.setText("Dr. Code [?]");
			DrCodeDESC.setBounds(535, 5, 100, 20);
			DrCodeDESC.setToolTip("Use ',' to search multiple doctors");
			DrCodeDESC.setOptionalLabel();
		}
		return DrCodeDESC;
	}

	private TextDoctorSearch getDrCode() {
		if (DrCode == null) {
			DrCode = new TextDoctorSearch() {
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
			DrCode.setBounds(640, 5, 120, 20);
		}
		return DrCode;
	}

	private LabelSmallBase getStatusDESC() {
		if (statusDESC == null) {
			statusDESC = new LabelSmallBase();
			statusDESC.setText("Status");
			statusDESC.setBounds(5, 30, 100, 20);
			statusDESC.setOptionalLabel();
		}
		return statusDESC;
	}

	private ComboBookingStatus getStatus() {
		if (status == null) {
			status = new ComboBookingStatus();
			status.setBounds(110, 30, 120, 20);
		}
		return status;
	}

	private LabelSmallBase getPatNoDESC() {
		if (patNoDESC == null) {
			patNoDESC = new LabelSmallBase();
			patNoDESC.setText("Patient Number");
			patNoDESC.setBounds(270, 30, 100, 20);
			patNoDESC.setOptionalLabel();
		}
		return patNoDESC;
	}

	private TextPatientNoSearch getPatNo() {
		if (patNo == null) {
			patNo = new TextPatientNoSearch(true,false) {
				@Override
				protected void checkPatient(boolean isExistPatient, boolean bySearchKey) {
					super.checkPatient(isExistPatient, bySearchKey);
					if (isExistPatient && bySearchKey) {
						searchAction(true);
					}
				}

				@Override
				protected boolean isSkipCheckPatient() {
					return false;
				}
			};
			patNo.setBounds(375, 30, 120, 20);
		}
		return patNo;
	}

	private LabelSmallBase getPatNameDESC() {
		if (patNameDESC == null) {
			patNameDESC = new LabelSmallBase();
			patNameDESC.setText("Patient Name");
			patNameDESC.setBounds(535, 30, 100, 20);
			patNameDESC.setOptionalLabel();
		}
		return patNameDESC;
	}

	private TextString getPatName() {
		if (patName == null) {
			patName = new TextString();
			patName.setBounds(640, 30, 120, 20);
		}
		return patName;
	}

	private LabelSmallBase getDocLocationDesc() {
		if (docLocationDesc == null) {
			docLocationDesc = new LabelSmallBase();
			docLocationDesc.setText("Location");
			docLocationDesc.setBounds(5, 55, 100, 20);
			docLocationDesc.setOptionalLabel();
		}
		return docLocationDesc;
	}

	private ComboDoctorLocation getDocLocation() {
		if (docLocation == null) {
			docLocation = new ComboDoctorLocation(){
				@Override
				protected void resetContentPost() {
					// override for child class
					if (getKeySize() > 0) {
						// default set to first item
						setSelectedIndex(0);

						if (getParameter("fromWellBaby") != null && getParameter("qLocation")!= null) {
							setText(getParameter("qLocation"));
							resetParameter("qLocation");
							resetParameter("fromWellBaby");
						}
					}

				}
			};
			docLocation.setBounds(110, 55, 120, 20);
		}
		return docLocation;
	}

	private LabelSmallBase getSpecialtyDESC() {
		if (specialtyDESC == null) {
			specialtyDESC = new LabelSmallBase();
			specialtyDESC.setText("Specialty [?]");
			specialtyDESC.setBounds(270, 55, 100, 20);
			specialtyDESC.setToolTip("Use ',' to search multiple specialities");
			specialtyDESC.setOptionalLabel();
		}
		return specialtyDESC;
	}

	protected TextSpecialtySearch getSpecialty() {
		if (specialty == null) {
			specialty = new TextSpecialtySearch();
			specialty.setBounds(375, 55, 120, 20);
		}
		return specialty;
	}

	private LabelSmallBase getRemarkDESC() {
		if (remarkDESC == null) {
			remarkDESC = new LabelSmallBase();
			remarkDESC.setText("Remark");
			remarkDESC.setBounds(535, 55, 100, 20);
			remarkDESC.setOptionalLabel();
		}
		return remarkDESC;
	}

	private TextString getRemark() {
		if (remark == null) {
			remark = new TextString();
			remark.setBounds(640, 55, 120, 20);
		}
		return remark;
	}

	private LabelSmallBase getNatureOfVisitDESC() {
		if (natureOfVisitDESC == null) {
			natureOfVisitDESC = new LabelSmallBase();
			natureOfVisitDESC.setText("Nature of Visit");
			natureOfVisitDESC.setBounds(5, 80, 100, 20);
			natureOfVisitDESC.setOptionalLabel();
		}
		return natureOfVisitDESC;
	}

	private ComboBoxBase getNatureOfVisit() {
		if (natureOfVisit == null) {
			natureOfVisit = new ComboBoxBase("NATUREOFVISIT", false, true, true);
			natureOfVisit.setBounds(110, 80, 120, 20);
		}
		return natureOfVisit;
	}

	private LabelSmallBase getInitialAssessedDESC() {
		if (initialAssessedDESC == null) {
			initialAssessedDESC = new LabelSmallBase();
			initialAssessedDESC.setText("Initial Assessed");
			initialAssessedDESC.setBounds(270, 80, 100, 20);
			initialAssessedDESC.setOptionalLabel();
		}
		return initialAssessedDESC;
	}

	private ComboBoxBase getInitialAssessed() {
		if (initialAssessed == null) {
			initialAssessed = new ComboBoxBase("ALERTSRC", false, true, true);
			initialAssessed.setBounds(375, 80, 120, 20);
		}
		return initialAssessed;
	}

	private LabelSmallBase getSortByDESC() {
		if (sortByDESC == null) {
			sortByDESC = new LabelSmallBase();
			sortByDESC.setText("Sort By");
			sortByDESC.setBounds(535, 80, 100, 20);
			sortByDESC.setOptionalLabel();
		}
		return sortByDESC;
	}

	private ComboBoxBase getSortBy() {
		if (sortBy == null) {
			sortBy = new ComboBoxBase() {
				@Override
				public void resetText() {
					setSelectedIndex(0);
				}
			};
			sortBy.addItem(EMPTY_VALUE, "Default");
			sortBy.addItem("R", "By Remark");
			sortBy.setBounds(640, 80, 120, 20);
		}
		return sortBy;
	}
	
	private LabelSmallBase getSourceDesc() {
		if (sourceDesc == null) {
			sourceDesc = new LabelSmallBase();
			sourceDesc.setText("Source");
			sourceDesc.setOptionalLabel();
			sourceDesc.setBounds(5, 105, 100, 20);
		}
		return sourceDesc;
	}

	protected ComboBoxBase getSource() {
		if (source == null) {
			source = new ComboBoxBase("BOOKINGSRC", false, true, true);
			source.setBounds(110, 105, 120, 20);
		}
		return source;
	}

	private LabelSmallBase getNoGLAPDESC() {
		if (NoGLAPDESC == null) {
			NoGLAPDESC = new LabelSmallBase();
			NoGLAPDESC.setText("No. of General Label After Picklist");
			NoGLAPDESC.setBounds(5, 432, 230, 20);
		}

		return NoGLAPDESC;
	}

	private TextString getNoGLAP() {
		if (NoGLAP == null) {
			NoGLAP = new TextString();
			NoGLAP.setBounds(200, 433, 50, 20);
		}
		return NoGLAP;
	}

	private LabelSmallBase getCountDesc() {
		if (countDesc == null) {
			countDesc = new LabelSmallBase();
			countDesc.setText("Count");
			countDesc.setBounds(640, 432, 80, 20);
		}
		return countDesc;
	}

	private TextReadOnly getCount() {
		if (count == null) {
			count = new TextReadOnly();
			count.setBounds(710, 433, 85, 20);
		}
		return count;
	}

	private ButtonBase getPrintPicklist() {
		if (printPicklist == null) {
			printPicklist = new ButtonBase() {
				@Override
				public void onClick() {
					charge(1, false);
				}
			};
			printPicklist.setText("Print Picklist", 'P');
			printPicklist.setBounds(5, 455, 93, 25);
		}
		return printPicklist;
	}

	private ButtonBase getPrintPicklistLabel() {
		if (printPicklistLabel == null) {
			printPicklistLabel = new ButtonBase() {
				@Override
				public void onClick() {
					charge(2, false);
				}
			};
			printPicklistLabel.setText("Print Pick List Label", 'L');
			printPicklistLabel.setBounds(100, 455, 120, 25);
		}
		return printPicklistLabel;
	}

	private ButtonBase getCancelApp() {
		if (cancelApp == null) {
			cancelApp = new ButtonBase() {
				@Override
				public void onClick() {
					cancelAppointmentPre();
				}
			};
			cancelApp.setText("Cancel Appointment", 'C');
			cancelApp.setBounds(222, 455, 123, 25);
		}
		return cancelApp;
	}

	private ButtonBase getChangeBooking() {
		if (changeBooking == null) {
			changeBooking = new ButtonBase() {
				@Override
				public void onClick() {
					changeBookingDetail();
				}
			};
			changeBooking.setText("Change Booking Detail");
			changeBooking.setBounds(347, 455, 133, 25);
		}
		return changeBooking;
	}

	private ButtonBase getPickListMR() {
		if (pickListMR == null) {
			pickListMR = new ButtonBase() {
				@Override
				public void onClick() {
					charge(3, false);
				}
			};
			pickListMR.setText("PickList for Medical Record");
			pickListMR.setBounds(482, 455, 163, 52);
		}
		return pickListMR;
	}

	private ButtonBase getPrintAppLbl() {
		if (printAppLbl == null) {
			printAppLbl = new ButtonBase() {
				@Override
				public void onClick() {
					if (getListTable().getSelectedRow() >= 0) {
						PrintingUtil.print(getSysParameter("PRTRLBL"),
								"APP2DBARCODE",
								new HashMap<String, String>(),"",
								new String[] {
										getListTable().getSelectedCellContent(GrdPb_patno).trim(),
										getListTable().getSelectedCellContent(GrdPbCol_SlotID),
										getListTable().getSelectedCellContent(GrdPbCol_SchID),
										getListTable().getSelectedCellContent(GrdPb_bkgID),
										Factory.getInstance().getUserInfo().getUserID()
								},
								new String[] {
									"patno",  "patname","patcname",
									"appointdate", "docname", "barcode",
									"chiAppointDate"
								});
					} else {
						Factory.getInstance().addErrorMessage("Please select an appointment to print.");
					}
				}
			};
			printAppLbl.setText("Print Appointment Label");
			printAppLbl.setBounds(647, 455, 148, 52);
		}
		return printAppLbl;
	}

	private ButtonBase getBookingListLabel() {
		if (bookingListLabel == null) {
			bookingListLabel = new ButtonBase() {
				@Override
				public void onClick() {
					getDlgRptBookingList().showDialog();
				}
			};
			bookingListLabel.setBounds(5, 482, 215, 25);
			bookingListLabel.setText("Print Booking List Label");
		}
		return bookingListLabel;
	}

	private ButtonBase getPrintAppList() {
		if (printAppList == null) {
			printAppList = new ButtonBase() {
				@Override
				public void onClick() {
					getDlgPrintAppList().showDialog();
				}
			};
			printAppList.setText("Print Appt List");
			printAppList.setBounds(222, 482, 123, 25);
		}
		return printAppList;
	}

	private ButtonBase getEditBooking() {
		if (editBooking == null) {
			editBooking = new ButtonBase() {
				@Override
				public void onClick() {
					editAppointment();
				}
			};
			editBooking.setText("Edit Appointment");
			editBooking.setBounds(347, 482, 133, 25);
		}
		return editBooking;
	}

	private ButtonBase getEditGovBooking() {
		if (editGovBooking == null) {
			editGovBooking = new ButtonBase() {
				@Override
				public void onClick() {
					showGovBookingForm();
				}
			};
			editGovBooking.setText("Edit Government Appointment");
			editGovBooking.setBounds(5, 509, 215, 25);
		}
		return editGovBooking;
	}

	private ButtonBase getPrintPicklistMR() {
		if (printPicklistMR == null) {
			printPicklistMR = new ButtonBase() {
				@Override
				public void onClick() {
					charge(4, true);
				}
			};
			printPicklistMR.setText("Print Pick List (MR)");
			printPicklistMR.setBounds(222, 509, 123, 25);
		}
		return printPicklistMR;
	}

	private ButtonBase getPrintApplistCS() {
		if (printApplistCS == null) {
			printApplistCS = new ButtonBase() {
				@Override
				public void onClick() {
					if (getListTable().getSelectedRow() >= 0) {
						String tempChkDigit = "#";
						if ("YES".equals(getSysParameter("ChkDigit"))) {
								tempChkDigit = PrintingUtil.generateCheckDigit(
										getListTable().getSelectedRowContent()[GrdPb_patno].trim()).toString()+"#";
						}
						Map<String,String> mapGeneral = new HashMap<String,String>();
						mapGeneral.put("newbarcode", getListTable().getSelectedCellContent(GrdPb_patno) + tempChkDigit);
						mapGeneral.put("isasterisk", String.valueOf("YES".equals(getMainFrame().getSysParameter("Chk*"))));

						PrintingUtil.print(getSysParameter("PRTRLBL"),
												"CHGSLPAPPLABEL", mapGeneral, null,
												new String[] {
														getListTable().getSelectedCellContent(GrdPb_patno),
														getListTable().getSelectedCellContent(GrdPb_bkgID)},
												new String[] {
														"stecode", "patno", "patname",
														"patcname", "patbdate", "patsex",
														"docname", "bkgdate", "plblrmk"
												});
					} else {
						Factory.getInstance().addErrorMessage("Please select an appointment to print.");
					}
				}
			};
			printApplistCS.setText("Print Appt Label (Chg Slip)");
			printApplistCS.setBounds(347, 509, 299, 25);
		}
		return printApplistCS;
	}

	private ButtonBase getPrintPatientLabel() {
		if (printPatientLabel == null) {
			printPatientLabel = new ButtonBase() {
				@Override
				public void onClick() {
					if (getListTable().getSelectedRow() >= 0) {
						final boolean isasterisk = "YES".equals(getSysParameter("Chk*"));
						final boolean isChkDigit = "YES".equals(getSysParameter("ChkDigit"));
						String tempChkDigit = "#";
						if ("YES".equals(getSysParameter("ChkDigit"))) {
								tempChkDigit = PrintingUtil.generateCheckDigit(
										getListTable().getSelectedCellContent(GrdPb_patno)).toString()+"#";
						}

						final String checkDigit = tempChkDigit;
						if (Integer.parseInt(getSysParameter("NOPATLABEL")) > 0) {
							QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.REGSEARCHPRINTDOB,
									new String[] { getListTable().getSelectedCellContent(GrdPb_patno) },
									new MessageQueueCallBack() {
								@Override
								public void onPostSuccess(MessageQueue mQueue) {
									if (mQueue.success()) {
										HashMap<String, String> map = new HashMap<String, String>();
										map.put("stecode", mQueue.getContentField() [0] + (isasterisk ? "*" : ""));
										map.put("patno", mQueue.getContentField()[1]);
										map.put("name", mQueue.getContentField()[2]);
										map.put("patsex", mQueue.getContentField()[5]);
										map.put("patno1", mQueue.getContentField()[1] + (isChkDigit ? checkDigit : "#"));
										String patcname =  mQueue.getContentField()[3];

										PrintingUtil.print(getSysParameter("PRTRLBL"),
												"PatientLabel", map, patcname,
												Integer.parseInt(getSysParameter("NOPATLABEL")));
									} else {
										Factory.getInstance().addErrorMessage("Invalid Patient Number.");
									}
								}
							});
						}
					} else {
						Factory.getInstance().addErrorMessage("Please select an appointment to print.");
					}
				}
			};
			printPatientLabel.setText("Print Patient Label");
			printPatientLabel.setBounds(647, 509, 148, 25);
		}
		return printPatientLabel;
	}

	private DialogBase getChangeBookingDialog() {
		if (changeBookingDialog == null) {
			changeBookingDialog = new DialogBase() {
				public TextString getDefaultFocusComponent() {
					return getCPatTel();
				}
			};
			changeBookingDialog.setLayout(null);
			changeBookingDialog.setBounds(300, 100, 400, 330);
			changeBookingDialog.setTitle("Change Booking Detail");
			changeBookingDialog.add(getChangeBookingPanel(), null);
		}
		return changeBookingDialog;
	}

	private BasePanel getChangeBookingPanel() {
		if (changeBookingPanel == null) {
			changeBookingPanel = new BasePanel();
			changeBookingPanel.setBounds(5, 5, 375, 260);
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
			changeBookingPanel.add(getCSourceDESC(), null);
			changeBookingPanel.add(getCSource(), null);
			changeBookingPanel.add(getCSMSContentDESC(), null);
			changeBookingPanel.add(getCSMSContent(), null);
			changeBookingPanel.add(getCAlertDESC(), null);
			changeBookingPanel.add(getCAlert(), null);
			changeBookingPanel.add(getCLMPDesc(), null);
			changeBookingPanel.add(getCLMP(), null);
			changeBookingPanel.add(getCEDCDesc(), null);
			changeBookingPanel.add(getCEDC(), null);
			changeBookingPanel.add(getCBirthOrderDesc(), null);
			changeBookingPanel.add(getCBirthOrder(), null);
			changeBookingPanel.add(getCReferralDoctorDesc(), null);
			changeBookingPanel.add(getCReferralDoctor(), null);
			changeBookingPanel.add(getCWeeksDesc(), null);
			changeBookingPanel.add(getCWeeks(), null);
			changeBookingPanel.add(getCNatureOfVisitDESC(), null);
			changeBookingPanel.add(getCNatureOfVisit(), null);
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

	private LabelSmallBase getCSourceDESC() {
		if (cSourceDESC == null) {
			cSourceDESC = new LabelSmallBase();
			cSourceDESC.setBounds(5, 155, 150, 20);
			cSourceDESC.setText("Booking Source");
		}
		return cSourceDESC;
	}

	private ComboBoxBase getCSource() {
		if (cSource == null) {
			cSource = new ComboBoxBase("BOOKINGSRC", false);
			cSource.setBounds(160, 155, 210, 20);
		}
		return cSource;
	}

	private LabelSmallBase getCSMSContentDESC() {
		if (cSMSContentDESC == null) {
			cSMSContentDESC = new LabelSmallBase();
			cSMSContentDESC.setBounds(5, 180, 150, 20);
			cSMSContentDESC.setText("SMS Message Content");
		}
		return cSMSContentDESC;
	}

	private ComboBoxBase getCSMSContent() {
		if (cSMSContent == null) {
			cSMSContent = new ComboBoxBase("SMSCONTENT", false);
			cSMSContent.setBounds(160, 180, 210, 20);
		}
		return cSMSContent;
	}

	private LabelSmallBase getCAlertDESC() {
		if (cAlertDESC == null) {
			cAlertDESC = new LabelSmallBase();
			cAlertDESC.setText("Initial Assessed");
			cAlertDESC.setBounds(5, 205, 150, 20);
		}
		return cAlertDESC;
	}

	private ComboBoxBase getCAlert() {
		if (cAlert == null) {
			cAlert = new ComboBoxBase("ALERTSRC", false, false, true);
			cAlert.setBounds(160, 205, 210, 20);
		}
		return cAlert;
	}

	private LabelSmallBase getCNatureOfVisitDESC() {
		if (cNatureOfVisitDESC == null) {
			cNatureOfVisitDESC = new LabelSmallBase();
			cNatureOfVisitDESC.setText("Nature of Visit");
			cNatureOfVisitDESC.setBounds(5, 230, 150, 20);
		}
		return cNatureOfVisitDESC;
	}

	private ComboBoxBase getCNatureOfVisit() {
		if (cNatureOfVisit == null) {
			cNatureOfVisit = new ComboBoxBase("NATUREOFVISIT", false, false, true);
			cNatureOfVisit.setBounds(160, 230, 210, 20);
		}
		return cNatureOfVisit;
	}

	private LabelSmallBase getCLMPDesc() {
		if (cLMPDesc == null) {
			cLMPDesc = new LabelSmallBase();
			cLMPDesc.setText("LMP");
			cLMPDesc.setBounds(5, 255, 150, 20);
		}
		return cLMPDesc;
	}

	private TextDate getCLMP() {
		if (cLMP == null) {
			cLMP = new TextDate();
			cLMP.setBounds(160, 255, 210, 20);
		}
		return cLMP;
	}

	private LabelSmallBase getCEDCDesc() {
		if (cEDCDesc == null) {
			cEDCDesc = new LabelSmallBase();
			cEDCDesc.setText("EDC");
			cEDCDesc.setBounds(5, 280, 150, 20);
		}
		return cEDCDesc;
	}

	private TextDate getCEDC() {
		if (cEDC == null) {
			cEDC = new TextDate();
			cEDC.setBounds(160, 280, 210, 20);
		}
		return cEDC;
	}

	private LabelSmallBase getCBirthOrderDesc() {
		if (cBirthOrderDesc == null) {
			cBirthOrderDesc = new LabelSmallBase();
			cBirthOrderDesc.setText("Birth Order");
			cBirthOrderDesc.setBounds(5, 305, 150, 20);
		}
		return cBirthOrderDesc;
	}

	private TextString getCBirthOrder() {
		if (cBirthOrder == null) {
			cBirthOrder = new TextString(10);
			cBirthOrder.setBounds(160, 305, 210, 20);
		}
		return cBirthOrder;
	}

	private LabelSmallBase getCReferralDoctorDesc() {
		if (cReferralDoctorDesc == null) {
			cReferralDoctorDesc = new LabelSmallBase();
			cReferralDoctorDesc.setText("Referral Doctor");
			cReferralDoctorDesc.setBounds(5, 330, 150, 20);
		}
		return cReferralDoctorDesc;
	}

	private TextString getCReferralDoctor() {
		if (cReferralDoctor == null) {
			cReferralDoctor = new TextString(81);
			cReferralDoctor.setBounds(160, 330, 210, 20);
		}
		return cReferralDoctor;
	}

	private LabelSmallBase getCWeeksDesc() {
		if (cWeeksDesc == null) {
			cWeeksDesc = new LabelSmallBase();
			cWeeksDesc.setText("Weeks");
			cWeeksDesc.setBounds(5, 355, 150, 20);
		}
		return cWeeksDesc;
	}

	private TextNum getCWeeks() {
		if (cWeeks == null) {
			cWeeks = new TextNum(2, 2, false, false);
			cWeeks.setBounds(160, 355, 210, 20);
		}
		return cWeeks;
	}

	private ButtonBase getChange() {
		if (change == null) {
			change = new ButtonBase() {
				@Override
				public void onClick() {
					doChangeBookingDetail();
				}
			};
			change.setBounds(95, 380, 80, 25);
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
			cancel.setBounds(180, 380, 80, 25);
			cancel.setText("Cancel");
		}
		return cancel;
	}

	private DlgSameDateAppAlert getDlgSameDateAppAlert() {
		if (dlgSameDateAppAlert == null) {
			dlgSameDateAppAlert = new DlgSameDateAppAlert(getMainFrame());
		}
		return dlgSameDateAppAlert;
	}

	private DlgRptAppListing getDlgRptAppListing() {
		if (dlgRptAppListing == null) {
			dlgRptAppListing = new DlgRptAppListing(getMainFrame());
		}
		return dlgRptAppListing;
	}

	private DlgRptBookingList getDlgRptBookingList() {
		if (dlgRptBookingListLabel == null) {
			dlgRptBookingListLabel = new DlgRptBookingList(getMainFrame());
		}
		return dlgRptBookingListLabel;
	}

	private DlgPrintAppList getDlgPrintAppList() {
		if (dlgPrintAppListing == null) {
			dlgPrintAppListing = new DlgPrintAppList(getMainFrame()){
				public boolean printRpt() {
				if (!"".equals(getDrCode().getText()) && getDrCode().getText() != null ) {
						Map<String, String> map = new HashMap<String, String>();
	
						if (getBookingDateFrom().getText().length()==0) {
							Factory.getInstance().addErrorMessage("Please supply Booking Date.");
							getBookingDateFrom().focus();
							return false;
						}
	
	
						map.put("BOOKINGDATEFROM", getBookingDateFrom().getText());
						map.put("BOOKINGDATETO", getBookingDateTo().getText());
						map.put("SiteName", getUserInfo().getSiteName());
						map.put("SPEC", getUserInfo().getOtherCode());
	
	
	
						PrintingUtil.print("DOCAPPLISTING",
											map, null,
											new String[] {
													getBookingDateFrom().getText(),
													getBookingDateTo().getText(),
													getDrCode().getText()
											},
											new String[] {
													"BKGDATE","DOCNAME", "PATNO", "DENTALNO", 
													"BKGPNAME","PATBDATE", "BKGMTEL","BKGRMK"
											});
					} else {
						super.printRpt();
					}
					return true;
				}
			};
			dlgPrintAppListing.getDrCodeDesc().setEnabled(true);
			dlgPrintAppListing.getDrCode().setEnabled(true);
		}
		return dlgPrintAppListing;
	}

	private Menu getPopupMenu() {
		if (contextMenu == null) {
			contextMenu = new Menu();

			// set context menu
			contextMenu.setWidth(140);
			contextMenu.add(getCancelBookingMenu());
			contextMenu.add(getEditBookingMenu());
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
}