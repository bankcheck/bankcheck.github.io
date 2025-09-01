package com.hkah.client.tx.schedule;

import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.LayoutContainer;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.combobox.ComboDayOfweek;
import com.hkah.client.layout.combobox.ComboDoctorLocation;
import com.hkah.client.layout.dialog.DlgChgScheduleDetail;
import com.hkah.client.layout.dialog.DlgClearSchedule;
import com.hkah.client.layout.dialog.DlgGenerateSchedule;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.label.LabelSmallBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextDoctorSearch;
import com.hkah.client.layout.textfield.TextNum;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.layout.textfield.TextTime;
import com.hkah.client.tx.MaintenancePanel;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.PanelUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class WeekSchedule extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.TEMPLATE_TXCODE;
	}

	@Override
	public boolean isTableViewOnly() {
		return false;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.DOCAPPOINTMENT_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
			EMPTY_VALUE,
			EMPTY_VALUE,
			"Day of Week",
			"Time Slot Duration",
			"Start Time",
			"End Time",
			"Doctor Practice Remark",
			"Location",
			EMPTY_VALUE,
			EMPTY_VALUE,
			EMPTY_VALUE,
			"Room"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
			0, 0, 100, 100, 80, 80, 260, 100, 0, 0,0, 
			"Y".equals(Factory.getInstance().getSysParameter("DISABLERM"))?0:60
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private BasePanel leftPanel = null;
	private FieldSetBase leftTopPanel = null;
	private LabelBase doctorCodeDesc = null;
	private TextDoctorSearch doctorCode = null;
	private LabelBase doctorNameDesc = null;
	private TextReadOnly doctorName = null;
	private LabelBase dayOfWeekDesc = null;
	private ComboDayOfweek dayOfWeek = null;
	private LabelBase timeSlotDurationDesc = null;
	private TextNum timeSlotDuration = null;
	private LabelBase startTimeDesc = null;
	private TextTime startTime = null;
	private LabelBase endTimeDesc = null;
	private TextTime endTime = null;
	private LabelBase docPrRemarkDesc = null;
	private TextString docPrRemark = null;
	private LabelBase docLocationDesc = null;
	private ComboDoctorLocation docLocation = null;
	private LabelBase docRoomDesc = null;
	private ComboBoxBase docRoom = null;
	private ButtonBase updateSchAction = null;
	private ButtonBase generateLAction = null;
	private ButtonBase clearDrAction = null;
	
	private DlgChgScheduleDetail chgSchDialog = null;
	private DlgGenerateSchedule generateDialog = null;
	private DlgClearSchedule clearDrDialog = null;

	private String temid = EMPTY_VALUE;
//	private int numberOfInsert = 0;
	private String memDocCode = null;
	private String memSlotTime = null;
	private String memSpecCode = null;
	private boolean validDocCode = false;

	private final int GrdPb_DocName = 0;
	private final int GrdPb_TemDay = 1;
	private final int GrdPb_DayOfWeek = 2;
	private final int GrdPb_TemLen = 3;
	private final int GrdPb_TemSTime = 4;
	private final int GrdPb_TemETime = 5;
	private final int GrdPb_DocPractice = 6;
	private final int GrdPb_DocLocation = 7;
	private final int GrdPb_TemID = 8;
	private final int GrdPb_DocCode = 9;
	private final int GrdPb_ROOMID = 10;
	private final int GrdPb_ROOM = 11;

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */

	/**
	 * This method initializes
	 *
	 */
	public WeekSchedule() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		/* >>> ~7.1~ Init action (e.g. Listing, Init Comobbox ========= <<< */
		setNoGetDB(true);
		getJScrollPane().setBounds(5, 185, 790, 270);

		/* >>> ~7.2~ Disable Add/Modify/Delete Buttons ================ <<< */
		memDocCode = EMPTY_VALUE;
		memSpecCode = EMPTY_VALUE;
		
		getGenerateLAction().setEnabled(!isDisableFunction("btnGenerate", "schAppoint"));
		System.err.println("[WS] getGenerateLAction().isEnabled()=" + getGenerateLAction().isEnabled());
		
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		memSpecCode = getParameter("SPCCODE");
		resetParameter("SPCCODE");

		// validate if come from doctor start
		if (getParameter("DOCCODE") != null && getParameter("DOCCODE").length() > 0) {
			getDoctorCode().setText(getParameter("DOCCODE"));
			resetParameter("DOCCODE");
			searchAction();
		} else {
			clearAction();
			enableButton();
		}

		getListTable().setColumnClass(GrdPb_DocLocation, new ComboDoctorLocation(), false);

		getListTable().setEnabled(true);
		getListTable().removeAllRow();
		
		if ("Y".equals(Factory.getInstance().getSysParameter("DISABLERM"))) {
			getDocRoomDesc().setVisible(false);
			getDocRoom().setVisible(false);
		}

		// validate if come from doctor end
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextDoctorSearch getDefaultFocusComponent() {
		return getDoctorCode();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {
	}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {
		// enable/disable field
		getDoctorCode().setEditable(false);
		getDayOfWeek().setEditable(true);
		getTimeSlotDuration().setEditable(true);
		getStartTime().setEditable(true);
		getEndTime().setEditable(true);
		getDocPrRemark().setEditable(true);
		getDocLocation().setEditable(true);
		getDocRoom().setEditable(true);

		getDayOfWeek().resetText();
//		getTimeSlotDuration().resetText();
		getStartTime().resetText();
		getEndTime().resetText();
		getDocPrRemark().resetText();
		getDocLocation().setText(EMPTY_VALUE);
		setTemid(EMPTY_VALUE);
		getDocRoom().resetText();

		getDayOfWeek().focus();
	}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
		// enable/disable field
		getDoctorCode().setEditable(false);
		getDayOfWeek().setEditable(true);
		getTimeSlotDuration().setEditable(true);
		getStartTime().setEditable(true);
		getEndTime().setEditable(true);
		getDocPrRemark().setEditable(true);
		getDocLocation().setEditable(true);

		getDayOfWeek().focus();
	}

	/* >>> ~13~ Set Disable Fields When Delete ButtonBase Is Clicked ====== <<< */
	@Override
	protected void deleteDisabledFields() {
		// enable/disable field
	}

	/* >>> ~14~ Set Browse Validation ===================================== <<< */
	@Override
	protected boolean browseValidation() {
		if (getDoctorCode().isEmpty()) {
			Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_DOCTOR_CODE, "PBA - [Week Schedule Template]", getDoctorCode());
			return false;
		} else {
			return true;
		}
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] { getDoctorCode().getText().trim(), memSpecCode };
	}

	/* >>> ~15.1~ Set Browse Output Results =============================== <<< */
	/* get the record field one by one */
	protected void getBrowseOutputValues(String[] outParam) {
		if (outParam != null && outParam.length > 0) {
			int index = 0;
			getDoctorName().setText(outParam[index++]);
			getDayOfWeek().setText(outParam[index++]);
			index++;
			getTimeSlotDuration().setText(outParam[index++]);
			getStartTime().setText(outParam[index++]);
			getEndTime().setText(outParam[index++]);
			getDocPrRemark().setText(outParam[index++]);
			getDocLocation().setText(outParam[index++]);
			setTemid(outParam[index++]);
			getDoctorCode().setText(outParam[index++]);
			getDocRoom().setText(outParam[index++]);
			
		}
	}

	/* >>> ~16~ Set Fetch Input Parameters ================================ <<< */
	@Override
	protected String[] getFetchInputParameters() {
		// fetch template detail by doctor code
		return new String[] { getDoctorCode().getText().trim() };
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {
		getDayOfWeek().setText(outParam[GrdPb_TemDay].equals(MINUS_ONE_VALUE)?EMPTY_VALUE:outParam[GrdPb_TemDay]);
		getTimeSlotDuration().setText(outParam[GrdPb_TemLen]);
		getStartTime().setText(outParam[GrdPb_TemSTime]);
		getEndTime().setText(outParam[GrdPb_TemETime]);
		getDocPrRemark().setText(outParam[GrdPb_DocPractice]);
		getDocLocation().setText(outParam[GrdPb_DocLocation]);
		getDoctorCode().setText(outParam[GrdPb_DocCode]);
		getDocRoom().setText(outParam[GrdPb_ROOMID]);
		if (!isAppend()) {
			enableButton();
		}
	}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		// add/update/delete to db para
		return new String[] {
			getTemid(),
			getDoctorCode().getText().trim(),
			getDayOfWeek().getText().trim(),
			getTimeSlotDuration().getText().trim(),
			getStartTime().getText().trim(),
			getEndTime().getText().trim(),
			getDocPrRemark().getText().trim(),
			getDocLocation().getText().trim()
		};
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {
		boolean returnValue = true;
		if (getDoctorCode().getText().trim().length() > 0) {
			if (getDayOfWeek().isEmpty()) {
				Factory.getInstance().addErrorMessage("Please select Day of week.", "PBA - [Week Schedule Template]", getDayOfWeek());
				returnValue = false;
			} else if (getTimeSlotDuration().isEmpty()) {
				Factory.getInstance().addErrorMessage("Please select Day of week.", "PBA - [Week Schedule Template]", getTimeSlotDuration());
				returnValue = false;
			} else if (!getStartTime().isValid()) {
				Factory.getInstance().addErrorMessage("The time of schedule is invalid.", "PBA - [Week Schedule Template]", getStartTime());
				getStartTime().resetText();
				returnValue = false;
			} else if (!getEndTime().isValid()) {
				Factory.getInstance().addErrorMessage("The time of schedule is invalid.", "PBA - [Week Schedule Template]", getEndTime());
				getEndTime().resetText();
				returnValue = false;
			} else if (DateTimeUtil.timeCompare(getStartTime().getText().trim(), getEndTime().getText().trim())) {
				Factory.getInstance().addErrorMessage("End time must be larger than start time.", "PBA - [Week Schedule Template]", getStartTime());
				returnValue = false;
			} else if (getDocLocation().getKeySize() > 0 && getDocLocation().isEmpty()) {
				Factory.getInstance().addErrorMessage("Doctor Location is empty.", "PBA - [Week Schedule Template]", getDocLocation());
				returnValue = false;
			}
		} else {
			returnValue = false;
		}
		actionValidationReady(actionType, returnValue);
	}

	/* >>> ~23~ Set Action Validation per table =========================== <<< */
	@Override
	protected boolean actionValidation(String[] selectedContent) {
		boolean success = true;
		boolean timeSlotIsNotNumeric = false;
		try {
			Integer.parseInt(selectedContent[GrdPb_TemLen]);
		} catch(Exception e) {
			timeSlotIsNotNumeric = true;
		}

		if (selectedContent[GrdPb_DayOfWeek].trim().length() == 0) {
			Factory.getInstance().addErrorMessage("Please select Day of week.", "PBA - [Week Schedule Template]");
			success = false;
		} else if (selectedContent[GrdPb_TemLen].length() == 0) {
			Factory.getInstance().addErrorMessage("Time slot duration cannot be empty", "PBA - [Week Schedule Template]");
			success = false;
		} else if (timeSlotIsNotNumeric) {
			Factory.getInstance().addErrorMessage("Time slot duration must be number", "PBA - [Week Schedule Template]");
			success = false;
		} else if (!DateTimeUtil.isValidTime(selectedContent[GrdPb_TemSTime].trim())) {
			Factory.getInstance().addErrorMessage("Start time is invalid.", "PBA - [Week Schedule Template]");
			getStartTime().resetText();
			success = false;
		} else if (!DateTimeUtil.isValidTime(selectedContent[GrdPb_TemETime].trim())) {
			Factory.getInstance().addErrorMessage("End time is invalid.", "PBA - [Week Schedule Template]");
			getEndTime().resetText();
			success = false;
		} else if (!selectedContent[GrdPb_TemSTime].trim().equals(selectedContent[GrdPb_TemETime].trim()) && DateTimeUtil.timeCompare(selectedContent[GrdPb_TemSTime].trim(), selectedContent[GrdPb_TemETime].trim())) {
			Factory.getInstance().addErrorMessage("End time must be larger than start time.", "PBA - [Week Schedule Template]");
			success = false;
		} else if (getDocLocation().getKeySize() > 0 && selectedContent[GrdPb_DocLocation].length() == 0) {
			Factory.getInstance().addErrorMessage("Doctor Location is empty.", "PBA - [Week Schedule Template]");
			success = false;
		}
		return success;
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected void proExitPanel() {
		if (memDocCode != null && memDocCode.length() > 0) {
			unlockRecord("Template", memDocCode);
		}
	}

	@Override
	protected void setAllRightFieldsEnabled(boolean enable) {
		PanelUtil.setAllFieldsEditable(getTopPanel(), enable);
		PanelUtil.setAllFieldsEditable(getJScrollPane(), enable);
	}

	@Override
	protected void enableButton(String mode) {
		super.enableButton(mode);

		boolean isAction = getActionType() != null && (isAppend() || isModify() || isDelete());
		boolean isDoctorFound = memDocCode != null && memDocCode.length() > 0;

		getAppendButton().setEnabled(!isAction);
		getModifyButton().setEnabled(getListTable().getRowCount() > 0 && isDoctorFound && !isModify());
		getDeleteButton().setEnabled(getListTable().getRowCount() > 0 && isDoctorFound && !isModify());
		getupdateSchAction().setEnabled((getListTable().getRowCount() > 0 && isDoctorFound && !isModify()));

		getSaveButton().setEnabled(isAction);
		getCancelButton().setEnabled(isAction);
		getClearButton().setEnabled(isAction);

		getAcceptButton().setEnabled(false);
		getRefreshButton().setEnabled(false);

		getGenerateLAction().setEnabled(!isDisableFunction("btnGenerate", "schAppoint"));
		getClearDrAction().setEnabled(!isDisableFunction("clearDoctorSchedule", "schAppoint"));

		getDoctorCode().setEditable(!isAction);
		getListTable().setEnabled(true);
	}

	@Override
	protected void cancelPostAction() {
		super.cancelPostAction();

		getDoctorCode().setEditable(getActionType() == null);
		getDayOfWeek().setEditable(false);
		getTimeSlotDuration().setEditable(false);
		getStartTime().setEditable(false);
		getEndTime().setEditable(false);
		getDocPrRemark().setEditable(false);
		getDocLocation().setEditable(false);
//		memDocCode = null;
	}

	@Override
	protected void cancelYesAction() {
		setActionType(null);
		getDoctorCode().setText(memDocCode);
		super.cancelYesAction();
	}

	@Override
	protected void clearPostAction() {
		super.clearPostAction();
//		memDocCode = null;
	}

	@Override
	public void searchAction() {
		clearAllFieldForSearch();

		// if locked doctor code is changed and previous doctor code
		if (!getDoctorCode().getText().trim().equals(memDocCode)
				&& memDocCode != null && memDocCode.length() > 0) {
			unlockRecord("Template", memDocCode);
		}

		if (!getDoctorCode().isEmpty() ) {
			validDocCode = false;
			QueryUtil.executeMasterFetch(getUserInfo(), "DOCTOR_ACTIVE",
					new String[] { getDoctorCode().getText().trim() },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						getDoctorName().setText(mQueue.getContentField()[GrdPb_DocName]);
						memSlotTime = mQueue.getContentField()[GrdPb_TemDay];
						validDocCode = memSpecCode == null || memSpecCode.equals(mQueue.getContentField()[GrdPb_TemLen]);

						if (!getDoctorCode().getText().trim().equals(memDocCode)) {
							// current doctor code
							lockRecord("Template", getDoctorCode().getText().trim());
						} else {
							lockRecordReady("Template", getDoctorCode().getText().trim(), null, true, null);
						}
					} else {
						enableButton(SEARCH_MODE);
						getDoctorCode().resetText();
						getDoctorCode().requestFocus();
						triggerSearchField();
					}
				}
			});
		}
	}

	@Override
	public void appendAction() {
		//super.appendAction();
		appendPostAction();
		appendDisabledFields();
		enableButton();
		modifyAction();
		setActionType(QueryUtil.ACTION_APPEND);
		// allow append during appendAction()
		getAppendButton().setEnabled(true);
	}

	@Override
	public void appendPostAction() {
		getListTable().addRow(new String[] {
			getDoctorName().getText(),
			EMPTY_VALUE,
			EMPTY_VALUE,
			memSlotTime,
			EMPTY_VALUE,
			EMPTY_VALUE,
			EMPTY_VALUE,
			EMPTY_VALUE,
			EMPTY_VALUE,
			getDoctorCode().getText()
		});
		setLastRowNo(getListTable().getRowCount() - 1);
		getListTable().setSelectRow(getLastRowNo());
	}

	@Override
	public void modifyAction() {
		if (getModifyButton().isEnabled()) {
			// let action type set before call performGet()
			setActionType(QueryUtil.ACTION_MODIFY);
			//
			enableButton();
			modifyDisabledFields();
//			getListTable().setEditRow();	// allow edit multiple row at once

			// call after all action done
			modifyPostAction();
		}
	}

	@Override
	public void deleteAction() {
		if (getDeleteButton().isEnabled()) {
			setActionType(QueryUtil.ACTION_DELETE);
			MessageBoxBase.confirm(MSG_PBA_SYSTEM, "Are you sure to delete this record?",
					new Listener<MessageBoxEvent>() {
				@Override
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						// set temid negative value to be deleted in listtable
						String deleteTemId = getListTable().getSelectedRowContent()[GrdPb_TemID];
						getListTable().setValueAt("-" + deleteTemId,
								getListTable().getSelectedRow(), GrdPb_TemID);

						getListTable().saveTable(getTxCode(),
								new String[] {getUserInfo().getUserID()},
								"Template");
					}
				}
			});
		}
	}

	@Override
	public void saveAction() {
		boolean noError = true;
		for (int i = 0; i < getListTable().getRowCount(); i++) {
			String[] selectedContent = getListTable().getRowContent(i);
			if (!actionValidation(selectedContent)) {
				noError = false;
				getListTable().setSelectRow(i);
				break;
			}
		}
		if (noError) {
			getListTable().saveTable(getTxCode(),
					new String[] {getUserInfo().getUserID()},
					"Template");
		}
	}

	@Override
	protected void listTablePostSaveTable(boolean success) {
		// post insert/update msg popup by TableList, delete msg here
		if (success) {
			if (isDelete()) {
				Factory.getInstance().addInformationMessage("Record deleted.");
			}
			setActionType(null);
			enableButton();
			searchAction();
		} else {
			if (isDelete()) {
				Factory.getInstance().addErrorMessage("Record delete fail.");
			}
		}
	}

	@Override
	public void clearAction() {
		if (getClearButton().isEnabled()) {
			getListTable().setValueAt(EMPTY_VALUE, getListTable().getSelectedRow(), GrdPb_TemDay);
			getListTable().setValueAt(EMPTY_VALUE, getListTable().getSelectedRow(), GrdPb_DayOfWeek);
			getListTable().setValueAt(EMPTY_VALUE, getListTable().getSelectedRow(), GrdPb_TemLen);
			getListTable().setValueAt(EMPTY_VALUE, getListTable().getSelectedRow(), GrdPb_TemSTime);
			getListTable().setValueAt(EMPTY_VALUE, getListTable().getSelectedRow(), GrdPb_TemETime);
			getListTable().setValueAt(EMPTY_VALUE, getListTable().getSelectedRow(), GrdPb_DocPractice);
			getListTable().setValueAt(EMPTY_VALUE, getListTable().getSelectedRow(), GrdPb_DocLocation);
			getListTable().setValueAt(EMPTY_VALUE, getListTable().getSelectedRow(), GrdPb_ROOM);

			getDayOfWeek().resetText();
			getTimeSlotDuration().resetText();
			//getStartTime().resetText();
			//getEndTime().resetText();
			getDocPrRemark().resetText();
			getDocLocation().resetText();
		}
	}

	@Override
	protected void lockRecordReady(final String lockType, final String lockKey, String[] record, boolean lock, String returnMessage) {
		if (lock) {
			memDocCode = lockKey;
			searchAction(true);
		} else {
			memDocCode = null; // no need to unlock when exit
			memSpecCode = null;
			Factory.getInstance().addErrorMessage(returnMessage, "PBA - [Week Schedule Template]");
			enableButton();
		}
	}

	@Override
	protected boolean triggerSearchField() {
		if (getDoctorCode().isFocusOwner()) {
			getDoctorCode().checkTriggerBySearchKey();
			return true;
		} else {
			return false;
		}
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/
	private void setListTableSelection(boolean disable) {
		getListTable().disableEvents(disable);
		getListTable().disableTextSelection(disable);
	}


	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		return new String[] {
			selectedContent[GrdPb_TemID].trim(),
			selectedContent[GrdPb_DocCode].trim(),
			selectedContent[GrdPb_TemDay].trim(),
			selectedContent[GrdPb_TemLen].trim(),
			selectedContent[GrdPb_TemSTime].trim(),
			selectedContent[GrdPb_TemETime].trim(),
			selectedContent[GrdPb_DocPractice].trim(),
			selectedContent[GrdPb_DocLocation].trim()
		};
	}

	private void clearAllFieldForSearch() {
		setListTableSelection(false);
		String tempDocCode = getDoctorCode().getText().trim();
		PanelUtil.resetAllFields(getLeftPanel());
		getDoctorCode().setText(tempDocCode);
	}

	public String getTemid() {
		return temid;
	}

	public void setTemid(String temid) {
		this.temid = temid;
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

	// generate dialog start
	public DlgGenerateSchedule getGenerateDialog() {
		if (generateDialog == null) {
			generateDialog = new DlgGenerateSchedule(getMainFrame());
		}
		return generateDialog;
	}

	public DlgClearSchedule getClearDrDialog() {
		if (clearDrDialog == null) {
			clearDrDialog = new DlgClearSchedule(getMainFrame());
		}
		return clearDrDialog;
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	@Override
	protected LayoutContainer getBodyPanel() {
		LayoutContainer panel = new LayoutContainer();
		panel.setStyleAttribute("padding-left", "10px");
		panel.add(getLeftPanel());
		return panel;
	}

	@Override
	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.add(getTopPanel(), null);
			leftPanel.add(getJScrollPane());
			leftPanel.add(getupdateSchAction(), null);
			leftPanel.add(getGenerateLAction(), null);
			leftPanel.add(getClearDrAction(), null);
			leftPanel.setSize(800, 500);
		}
		return leftPanel;
	}

	@Override
	protected ColumnLayout getSearchPanel() {
		return null;
	}

	@Override
	protected LayoutContainer getActionPanel() {
		return null;
	}

	public FieldSetBase getTopPanel() {
		if (leftTopPanel == null) {
			leftTopPanel = new FieldSetBase();
			leftTopPanel.setBounds(5, 5, 790, 175);
			leftTopPanel.setHeading("Template Information");
			leftTopPanel.add(getDoctorCodeDesc(), null);
			leftTopPanel.add(getDoctorCode(), null);
			leftTopPanel.add(getDoctorNameDesc(), null);
			leftTopPanel.add(getDoctorName(), null);
			leftTopPanel.add(getDayOfWeekDesc(), null);
			leftTopPanel.add(getDayOfWeek(), null);
			leftTopPanel.add(getTimeSlotDurationDesc(), null);
			leftTopPanel.add(getTimeSlotDuration(), null);
			leftTopPanel.add(getStartTimeDesc(), null);
			leftTopPanel.add(getStartTime(), null);
			leftTopPanel.add(getEndTimeDesc(), null);
			leftTopPanel.add(getEndTime(), null);
			leftTopPanel.add(getDocPrRemarkDesc(), null);
			leftTopPanel.add(getDocPrRemark(), null);
			leftTopPanel.add(getDocLocationDesc(), null);
			leftTopPanel.add(getDocLocation(), null);
			leftTopPanel.add(getDocRoomDesc(), null);
			leftTopPanel.add(getDocRoom(), null);
		}
		return leftTopPanel;
	}
	
	private ButtonBase getupdateSchAction() {
		if (updateSchAction == null) {
			updateSchAction = new ButtonBase() {
				@Override
				public void onClick() {
					getChgSchDialog().showDialog(null,
							getDoctorCode().getText()
							,"WEEKLY");
				}
			};
			updateSchAction.setText("Chg Room/Dr. Prac Rmk");
			updateSchAction.setBounds(350, 460, 150, 25);
		}
		return updateSchAction;
	}

	public ButtonBase getGenerateLAction() {
		if (generateLAction == null) {
			generateLAction = new ButtonBase() {
				@Override
				public void onClick() {
					if (validDocCode) {
						getGenerateDialog().showDialog(
								getDoctorCode().getText(),
								getDoctorName().getText(),
								memSpecCode
						);
					} else {
						getGenerateDialog().showDialog(
								EMPTY_VALUE,
								EMPTY_VALUE,
								memSpecCode
						);
					}
				}
			};
			generateLAction.setText("Generate");
			generateLAction.setBounds(550, 460, 90, 25);
		}
		return generateLAction;
	}

	public ButtonBase getClearDrAction() {
		if (clearDrAction == null) {
			clearDrAction = new ButtonBase() {
				@Override
				public void onClick() {
					getClearDrDialog().showDialog(
							getDoctorCode().getText(),
							getDoctorName().getText()
					);
				}
			};
			clearDrAction.setText("Clear Doctor Schedule");
			clearDrAction.setBounds(645, 460, 150, 25);
		}
		return clearDrAction;
	}

	public LabelBase getDoctorCodeDesc() {
		if (doctorCodeDesc == null) {
			doctorCodeDesc = new LabelBase();
			doctorCodeDesc.setText("Doctor Code");
			doctorCodeDesc.setBounds(20, 0, 120, 20);
		}
		return doctorCodeDesc;
	}

	public TextDoctorSearch getDoctorCode() {
		if (doctorCode == null) {
			doctorCode = new TextDoctorSearch() {
				@Override
				public void onBlur() {
					// override by child class when lost focus
					if (isEmpty()) {
						memDocCode = null;
					}

					if (!getText().equals(memDocCode)) {
						searchAction();
					}
				}

				@Override
				public String getText() {
					return super.getText().toUpperCase();
				}
			};
			doctorCode.setBounds(160, 0, 120, 20);
		}
		return doctorCode;
	}

	public LabelBase getDoctorNameDesc() {
		if (doctorNameDesc == null) {
			doctorNameDesc = new LabelBase();
			doctorNameDesc.setText("Doctor Name");
			doctorNameDesc.setBounds(400, 0, 120, 20);
		}
		return doctorNameDesc;
	}

	public TextReadOnly getDoctorName() {
		if (doctorName == null) {
			doctorName = new TextReadOnly();
			doctorName.setBounds(530, 0, 230, 20);
		}
		return doctorName;
	}

	public LabelBase getDayOfWeekDesc() {
		if (dayOfWeekDesc == null) {
			dayOfWeekDesc = new LabelBase();
			dayOfWeekDesc.setText("Day of Week");
			dayOfWeekDesc.setBounds(20, 30, 120, 20);
		}
		return dayOfWeekDesc;
	}

	public ComboDayOfweek getDayOfWeek() {
		if (dayOfWeek == null) {
			dayOfWeek = new ComboDayOfweek() {
				@Override
				protected void setTextPanel(ModelData modelData) {
					if (isModify() || isAppend()) {
						getListTable().setValueAt(Integer.toString(getSelectedIndex()), getListTable().getSelectedRow(), GrdPb_TemDay);
						getListTable().setValueAt(getDisplayText(), getListTable().getSelectedRow(), GrdPb_DayOfWeek);
					}
				}
			};
			dayOfWeek.setBounds(160, 30, 120, 20);

		}
		return dayOfWeek;
	}

	public LabelBase getTimeSlotDurationDesc() {
		if (timeSlotDurationDesc == null) {
			timeSlotDurationDesc = new LabelBase();
			timeSlotDurationDesc.setText("Time Slot Duration");
			timeSlotDurationDesc.setBounds(400, 30, 120, 20);
		}
		return timeSlotDurationDesc;
	}

	public TextNum getTimeSlotDuration() {
		if (timeSlotDuration == null) {
			timeSlotDuration = new TextNum() {
				@Override
				public void onReleased() {
					getListTable().setValueAt(getText(), getListTable().getSelectedRow(), GrdPb_TemLen);
				}

				@Override
				public void onBlur() {
					int decimalPointIndex = getText().trim().indexOf(".");
					if (decimalPointIndex == -1) {
						decimalPointIndex = getText().trim().length();
					}

					if (!isEmpty()) {
						try {
							Double.parseDouble(getText().trim());
						} catch (Exception e) {
							Factory.getInstance().addErrorMessage("Time slot duration must be a number.",
																	"PBA - [Week Schedule Template]", this);
							resetText();
							focus();
							return;
						}

						if (getText().trim().substring(0, decimalPointIndex).length() > 3) {
							Factory.getInstance().addErrorMessage("Integer part too long.",
																	"PBA - [Week Schedule Template]", this);
							resetText();
							return;
						}
					}
					getListTable().setValueAt(getText().trim().substring(0, decimalPointIndex), getListTable().getSelectedRow(), GrdPb_TemLen);
				}

			};
			timeSlotDuration.setBounds(530, 30, 120, 20);
		}
		return timeSlotDuration;
	}

	public LabelBase getStartTimeDesc() {
		if (startTimeDesc == null) {
			startTimeDesc = new LabelBase();
			startTimeDesc.setText("Start Time");
			startTimeDesc.setBounds(20, 60, 120, 20);
		}
		return startTimeDesc;
	}

	public TextTime getStartTime() {
		if (startTime == null) {
			startTime = new TextTime() {
				@Override
				public void onReleased() {
					getListTable().setValueAt(getText(), getListTable().getSelectedRow(), GrdPb_TemSTime);
				}

				@Override
				public void onBlur() {
					if (!isValid()) {
						Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_INVALID_TIME, "PBA - [Week Schedule Template]", startTime);
						setText(EMPTY_VALUE);
					}
					getListTable().setValueAt(getText(), getListTable().getSelectedRow(), GrdPb_TemSTime);
				}
			};
			startTime.setBounds(160, 60, 120, 20);
		}
		return startTime;
	}

	public LabelBase getEndTimeDesc() {
		if (endTimeDesc == null) {
			endTimeDesc = new LabelBase();
			endTimeDesc.setText("End Time");
			endTimeDesc.setBounds(400, 60, 120, 20);
		}
		return endTimeDesc;
	}

	public TextTime getEndTime() {
		if (endTime == null) {
			endTime = new TextTime() {
				@Override
				public void onReleased() {
					getListTable().setValueAt(getText(), getListTable().getSelectedRow(), GrdPb_TemETime);
				}

				@Override
				public void onBlur() {
					if (!isValid()) {
						Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_INVALID_TIME, "PBA - [Week Schedule Template]", endTime);
						setText(EMPTY_VALUE);
					}
					getListTable().setValueAt(getText(), getListTable().getSelectedRow(), GrdPb_TemETime);
				}
			};
			endTime.setBounds(530, 60, 120, 20);
		}
		return endTime;
	}

	public LabelBase getDocPrRemarkDesc() {
		if (docPrRemarkDesc == null) {
			docPrRemarkDesc = new LabelBase();
			docPrRemarkDesc.setText("Doctor Practice Remark");
			docPrRemarkDesc.setBounds(20, 90, 150, 20);
		}
		return docPrRemarkDesc;
	}

	public TextString getDocPrRemark() {
		if (docPrRemark == null) {
			docPrRemark = new TextString(250, false) {
				@Override
				public void onReleased() {
					getListTable().setValueAt(getDocPrRemark().getText(), getListTable().getSelectedRow(), GrdPb_DocPractice);
				};
			};
			docPrRemark.setBounds(160, 90, 600, 20);
		}
		return docPrRemark;
	}

	public LabelBase getDocLocationDesc() {
		if (docLocationDesc == null) {
			docLocationDesc = new LabelBase();
			docLocationDesc.setText("Doctor Location");
			docLocationDesc.setBounds(20, 120, 150, 20);
		}
		return docLocationDesc;
	}
	


	public ComboDoctorLocation getDocLocation() {
		if (docLocation == null) {
			docLocation = new ComboDoctorLocation() {
				@Override
				protected void setTextPanel(ModelData modelData) {
					if (isModify() || isAppend()) {
						getListTable().setValueAt(getText(), getListTable().getSelectedRow(), GrdPb_DocLocation);
					}
				}
			};
			docLocation.setBounds(160, 120, 120, 20);
		}
		return docLocation;
	}
	
	private LabelBase getDocRoomDesc() {
		if (docRoomDesc == null) {
			docRoomDesc = new LabelBase();
			docRoomDesc.setText("Room");
			docRoomDesc.setBounds(290, 120, 60, 20);
		}
		return docRoomDesc;
	}

	private ComboBoxBase getDocRoom() {
		if (docRoom == null) {
			docRoom = new ComboBoxBase("DRROOM", false, true, true){
				@Override
				protected void setTextPanel(ModelData modelData) {
					if (isModify() || isAppend()) {
						getListTable().setValueAt(getText(), getListTable().getSelectedRow(), GrdPb_ROOMID);
						getListTable().setValueAt(getDisplayText(), getListTable().getSelectedRow(), GrdPb_ROOM);
					}
				}
			};
			docRoom.setBounds(350, 120, 158, 20);
		}
		return docRoom;
	}
}