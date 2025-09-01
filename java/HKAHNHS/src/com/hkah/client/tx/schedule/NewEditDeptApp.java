package com.hkah.client.tx.schedule;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.event.BaseEvent;
import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.KeyListener;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.event.SelectionChangedEvent;
import com.extjs.gxt.ui.client.event.SelectionChangedListener;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.google.gwt.event.dom.client.KeyCodes;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboBedCode;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.combobox.ComboDeptAppPatType;
import com.hkah.client.layout.combobox.ComboDeptAppRoomType;
import com.hkah.client.layout.combobox.ComboDeptProc;
import com.hkah.client.layout.combobox.ComboReferDotorDeptApp;
import com.hkah.client.layout.combobox.ComboSex;
import com.hkah.client.layout.combobox.ComboWard;
import com.hkah.client.layout.combobox.PagingComboBoxBase;
import com.hkah.client.layout.dialog.DlgDeptSecCheck;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.TabbedPaneBase;
import com.hkah.client.layout.table.EditorTableList;
import com.hkah.client.layout.textfield.SearchTriggerField;
import com.hkah.client.layout.textfield.TextAreaBase;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextDateTimeWithoutSecond;
import com.hkah.client.layout.textfield.TextDateTimeWithoutSecondWithCheckBox;
import com.hkah.client.layout.textfield.TextDateWithCheckBox;
import com.hkah.client.layout.textfield.TextNum;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.PanelUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTableColumn;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class NewEditDeptApp extends MasterPanel implements ConstantsVariable, ConstantsTableColumn {
	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		return ConstantsTx.NEWEDITDEPTAPP_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.NEWEDITDEPTAPP_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	protected int[] getColumnWidths() {
		return new int[] {};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private BasePanel leftPanel = null;

	private int TabbedPaneIndex=0;
	private TabbedPaneBase TabbedPane = null;
	private BasePanel DeptAPPPanel = null;
	private LabelBase PatNoDesc = null;
	private TextPatientNoSearch PatNo = null;
	private LabelBase SpecBookDesc = null;
	private CheckBoxBase SpecBook = null;
	private TextString DeptaId = null;
	private LabelBase PatFNameDesc = null;
	private TextString PatFName = null;
	private LabelBase PatGNameDesc = null;
	private TextString PatGName = null;
	private LabelBase DocNoDesc = null;
	private TextString DocNo = null;
	private LabelBase DOBDesc = null;
	private TextDateWithCheckBox DOB = null;
	private LabelBase PhoneNoDesc = null;
	private TextString PhoneNo = null;
	private LabelBase SexDesc = null;
	private ComboSex Sex = null;
	private LabelBase PatMobNoDesc = null;
	private TextString PatMobNo = null;
	private LabelBase PatTypeDesc = null;
	private ComboDeptAppPatType PatType = null;
	private LabelBase StartDateDesc = null;
	private TextDateTimeWithoutSecond StartDate = null;
	private LabelBase EndDateDesc = null;
	private TextDateTimeWithoutSecond EndDate = null;
	private LabelBase RoomDesc = null;
	private ComboDeptAppRoomType Room = null;
	private LabelBase ReferDoctorDesc = null;
	private ComboReferDotorDeptApp ReferDoctor = null;
	private FieldSetBase ProcPanel = null;
	
	private LabelBase nurseNoteDesc = null;
	private TextAreaBase nurseNote = null;
	private CheckBoxBase isNNoteUneventFul = null;
	private LabelBase nNoteUneventFulDesc = null;
	
	private LabelBase PrimaryProcDesc = null;
	private ComboDeptProc PrimaryProc = null;
	private LabelBase ProcRmkDesc = null;
	private TextAreaBase ProcRmk = null;

	private FieldSetBase AlertPanel = null;
	private TextAreaBase AlertRmk = null;

	private String strOldPatNo = null;
	private String strOldPatFName = null;
	private String strOldPatGName = null;
	private String strOldRefDoctor = null;
	private boolean bMem_bIsEdit = false;

	private boolean isFrmAllergyLoaded = false;
	private boolean isNurseNote = false;

	private String memPatNo = null;
	private String memPatFName = null;
	private String memPatGName = null;
	private String memDocNo = null;
	private String memDOB = null;
	private String memPhoneNo = null;
	private String memSex = null;
	private String memMobileNo = null;
	private String memBedCode = null;
	private String memSDate = null;
	private String memEDate = null;
	private boolean allToolBarDisable = false;
	private String memRoom = null;
	private boolean isContinueMultiBooking = false;
	private boolean isContinueOverlap = false;
	private boolean init = true;
	private String memDeptType = null;
	private LabelBase WardDesc = null;
	private ComboWard Ward = null;
	private LabelBase ReportDrDesc = null;
	private ComboReferDotorDeptApp ReportDr = null;

	private LabelBase bedCodeDesc = null;
	private ComboBedCode bed = null;

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;

	/**
	 * This method initializes
	 *
	 */
	public NewEditDeptApp() {
		super();
	}

	public NewEditDeptApp(String deptType) {
		super();
		memDeptType = deptType;
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		setLeftAlignPanel();
		getJScrollPane().setBounds(5, 190, 759, 220);
		return true;
	}

	private void initSetting() {
		strOldPatNo = null;
		strOldPatFName = null;
		strOldPatGName = null;
		bMem_bIsEdit = false;
		isFrmAllergyLoaded = false;
		memSDate = null;
		memEDate = null;
		allToolBarDisable = false;
		memRoom = null;
		isContinueMultiBooking = false;
		isContinueOverlap = false;
		init = true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		getMainFrame().setLoading(true);
		initSetting();
		bMem_bIsEdit = YES_VALUE.equals(getParameter("deptApp_bIsEdit"));
		
		allToolBarDisable = false;

		setReloadSpecCboSql(getPrimaryProc(), true, null);

		setReloadSpecCboSql(getReferDoctor(), true, null);
		setReloadSpecCboSql(getReportDr(), true, null);

		disableField(getPatMobNo());
		getNurseNote().setEditable(false);

		isFrmAllergyLoaded = false;

		//--------------Start GetParameter---------------
		setActionType(getParameter("ActionType"));
		strOldPatNo = getParameter("patno");	
		strOldPatFName = getParameter("patFName");
		strOldPatGName = getParameter("patGName");
		strOldRefDoctor = getParameter("refDoctor");
		isNurseNote = "Y".equals(getParameter("isNurseNote"));
		resetParameter("patno");
		resetParameter("patFName");
		resetParameter("patFName");
		resetParameter("refDoctor");
		resetParameter("isNurseNote");
		

		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] {"HPSTATUS", "HPRMK", "HPTYPE ='CPLABAPP' AND HPKEY='ALERT' "},
				new MessageQueueCallBack() {
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getAlert().setText(mQueue.getContentField()[0]);
				}
			}});

		if (isAppend()) {
			getRoom().setText(getParameter("exam_room"));
			if (strOldPatNo != null && strOldPatNo.length() > 0) {
				getPatNo().setText(strOldPatNo);
				fillPatDetail();
				getRoom().resetText();
			} else {
				if (strOldPatFName != null && strOldPatFName.length() > 0) {
					getPatFName().setText(strOldPatFName);
				}
				if (strOldPatGName != null && strOldPatGName.length() > 0) {
					getPatGName().setText(strOldPatGName);
				}
				getRoom().resetText();
			}
			if (strOldRefDoctor != null && strOldRefDoctor.length() > 0) {
				getReferDoctor().setText(strOldRefDoctor);
			}
			getParaAction();
		} else if (isNurseNote) {
			getParaAction();
			PanelUtil.setAllFieldsEditable(getDeptAPPPanel(), false);
			getNurseNote().setEditable(true);
			getNNoteUneventFul().setEditable(true);
		} else if (isModify()) {
			getParaAction();
		} else {
			getMainFrame().setLoading(false);
		}
		setReloadSpecCboSql(getRoom(), true, null);
	}

	private void initAfterReadyPost() {
		if (isFrmAllergyLoaded) {
			isFrmAllergyLoaded = false;
		}

		init = false;
		enableButton();

		// fix cannot get other tab's fields value problem
		getTabbedPane().setSelectedIndexWithoutStateChange(1);
		getTabbedPane().setSelectedIndexWithoutStateChange(0);
	}

	@Override
	public void rePostAction() {
	}

	private void resetPatDetail() {
		getPatFName().resetText();
		getPatGName().resetText();
		getPatMobNo().resetText();
		getPhoneNo().resetText();
		getDocNo().resetText();
		getDOB().resetText();
		getSex().resetText();
		getSex().clear();
		//tWard().resetText();
		getBedCode().resetText();
		strOldPatNo = null;
		memBedCode = null;
		memPatNo = null;
		memPatFName = null;
		memPatGName = null;
		memDocNo = null;
		memDOB = null;
		memSex = null;
		memMobileNo = null;
	}

	private void fillPatDetail() {
		String curPatNo = getPatNo().getText().trim();
		if (curPatNo != null && curPatNo.length() > 0) {
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.PATIENT_TXCODE,
					new String[] { curPatNo },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						fillPatDetail(mQueue);
					}
				}
			});
		}
	}

	private void fillPatDetail(MessageQueue mQueue) {
		memPatNo = mQueue.getContentField()[PATIENT_NUMBER];
		memPatFName = mQueue.getContentField()[PATIENT_FAMILY_NAME];
		memPatGName = mQueue.getContentField()[PATIENT_GIVEN_NAME];
		memDocNo = mQueue.getContentField()[PATIENT_ID_NO];
		memDOB = mQueue.getContentField()[PATIENT_DOB];
		memSex = mQueue.getContentField()[PATIENT_SEX];
		memMobileNo = mQueue.getContentField()[PATIENT_MOBILE_PHONE];
		if(!bMem_bIsEdit && !isNurseNote) {
			memPhoneNo = mQueue.getContentField()[PATIENT_MOBILE_PHONE]; //update to mobile phone
			getPhoneNo().setText(memPhoneNo);
		}
		getPatFName().setText(memPatFName);
		getPatGName().setText(memPatGName);
		getDocNo().setText(memDocNo);
		getDOB().setText(memDOB);

		getSex().setText(memSex);

		QueryUtil.executeMasterFetch(getUserInfo(), "INPBEDPATNO",
				new String[] { EMPTY_VALUE, memPatNo },
				new MessageQueueCallBack() {
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getWard().setText(mQueue.getContentField()[2]);
					getBedCode().setText(mQueue.getContentField()[1]);
					memBedCode = mQueue.getContentField()[1];
					getPatType().setText("I");
				}
			}});
	}

	private void getParaAction() {
		if (isAppend()) {
			initAfterReadyPost();
			getMainFrame().setLoading(false);

			if (getPatType().getStore().getCount() > 1) {
				getPatType().setSelectedIndex(3);
			}
			initAllSDT();
		} else if (isModify() || isNurseNote) {
			lockRecord(memDeptType + "Appointment", getParameter("deptaid"));
			// callback go to lockRecordReady
		}
	}

	@Override
	protected void lockRecordReady(final String lockType, final String lockKey, String[] record, boolean lock, String returnMessage) {
		if (!lock) {
			Factory.getInstance().addErrorMessage(returnMessage);
			setActionType(null);
			exitPanel();
		} else {
			getDeptaDetail(getParameter("deptaid"));
		}
		Factory.getInstance().getMainFrame().setLoading(false);
	}

	private void txtPatNoEnable() {
		if (!(getPatFName().getText().equals(memPatFName) &&
					getPatGName().getText().equals(memPatGName) &&
					getDocNo().getText().equals(memDocNo) &&
					//getPhoneNo().getText().equals(memPhoneNo) &&
					getDOB().getText().equals(memDOB))
				&&
			(getPatFName().getText().length() > 0 ||
					getPatGName().getText().length() > 0 ||
					getDocNo().getText().length() > 0 ||
					//getPhoneNo().getText().length() > 0 ||
					getDOB().getText().length() > 0)) {
			disableField(getPatNo());
		} else {
			enableField(getPatNo());
		}
	}

	private void enableField(Component comp) {
		setField(comp, true);
	}

	private void disableField(Component comp) {
		setField(comp, false);
	}

	private void setField(Component comp, boolean enable) {
		if (comp instanceof TextBase){
			((TextBase) comp).setEditableForever(enable);
			((TextBase) comp).setReadOnly(!enable);
		} else if (comp instanceof TextNum){
			((TextNum) comp).setEditableForever(enable);
			((TextNum) comp).setReadOnly(!enable);
		} else if (comp instanceof TextAreaBase) {
			((TextAreaBase) comp).setEditableForever(enable);
			((TextAreaBase) comp).setReadOnly(!enable);
		} else if (comp instanceof ComboBoxBase) {
			((ComboBoxBase) comp).setEditableForever(enable);
			((ComboBoxBase) comp).setReadOnly(!enable);
		} else if (comp instanceof PagingComboBoxBase) {
			((PagingComboBoxBase) comp).setEditableForever(enable);
			((PagingComboBoxBase) comp).setReadOnly(!enable);
		} else if (comp instanceof TextDate) {
			((TextDate) comp).setEditableForever(enable);
			((TextDate) comp).setReadOnly(!enable);
		} else if (comp instanceof TextDateWithCheckBox) {
			((TextDateWithCheckBox) comp).getDateField().setEditableForever(enable);
			((TextDateWithCheckBox) comp).setReadOnly(!enable);
		} else if (comp instanceof TextDateTimeWithoutSecond) {
			((TextDateTimeWithoutSecond) comp).setEditableForever(enable);
			((TextDateTimeWithoutSecond) comp).setReadOnly(!enable);
		} else if (comp instanceof TextDateTimeWithoutSecondWithCheckBox) {
			((TextDateTimeWithoutSecondWithCheckBox) comp).getDateField().setEditableForever(enable);
			((TextDateTimeWithoutSecondWithCheckBox) comp).setReadOnly(!enable);
		} else if (comp instanceof SearchTriggerField) {
			((SearchTriggerField) comp).setEditableForever(enable);
			((SearchTriggerField) comp).setReadOnly(!enable);
		} else if (comp instanceof CheckBoxBase) {
			((CheckBoxBase) comp).setEditable(enable);
			((CheckBoxBase) comp).setReadOnly(!enable);
		}
	}

	private void initAllSDT() {
		String currentDateTimeWithoutSecond = getMainFrame().getServerDateTime();
		if (currentDateTimeWithoutSecond != null && currentDateTimeWithoutSecond.length() > 16) {
			currentDateTimeWithoutSecond = currentDateTimeWithoutSecond.substring(0, 16);
		}
		getStartDate().setText(currentDateTimeWithoutSecond);
		getEndDate().setText(currentDateTimeWithoutSecond);
		getDOB().clear();

		if (getParameter("Slt_SDate")!=null &&!"".equals(getParameter("Slt_SDate"))) {
			getStartDate().setText(getParameter("Slt_SDate"));
		}
		if (getParameter("Slt_EDate")!=null &&!"".equals(getParameter("Slt_EDate"))) {
			getEndDate().setText(getParameter("Slt_EDate"));
		}
		//setCurRecordProperties();
	}

	public void getDeptaDetail(final String deptaid) {
		QueryUtil.executeMasterFetch(
			Factory.getInstance().getUserInfo(),"DEPTAPPBYNO", new String[] {deptaid},
			new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						getFetchOutputValues(mQueue.getContentField());
					} else {
						Factory.getInstance().addErrorMessage(mQueue.getReturnMsg());
					}
				}
			});
	}

	public void getPbDetail(final String pbpid) {
		QueryUtil.executeMasterFetch(
				Factory.getInstance().getUserInfo(), "BEDPREBOKBYNO", new String[] {pbpid},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getFetchOutputValuesPbp(mQueue.getContentField());
					// get the remaining pat details
					getPatNo().onBlur();
				} else {
					Factory.getInstance().addErrorMessage(mQueue.getReturnMsg());
				}
			}
		});
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
	protected void getFetchOutputValues(String[] outParam) {
		//0-9,22,26,27
		memPatNo = outParam[0];
		memPatFName = outParam[1];
		memPatGName = outParam[2];
		memPhoneNo = outParam[12];
		memSex = outParam[3];

		getPatNo().setText(outParam[0]);
		getPatFName().setText(outParam[1]);
		getPatGName().setText(outParam[2]);
		getSex().setText(outParam[3]);
		getPatType().setText(outParam[4]);
		getStartDate().setText(outParam[5]);
		getEndDate().setText(outParam[6]);
		getRoom().setText(outParam[7]);
		getPrimaryProc().setText(outParam[8]);
		getReferDoctor().setText(outParam[9]);
		getDocNo().setText(outParam[11]);
		getPhoneNo().setText(outParam[12]);
		getProcRmk().setText(outParam[13]);
		getSpecBook().setSelected(YES_VALUE.equals(outParam[14]));
		getWard().setText(outParam[15]);
		getBedCode().setText(outParam[16]);
		getReportDr().setText(outParam[17]);
		getNurseNote().setText(outParam[18]);
		initAfterReadyPost();

		getDeptaId().setText(getParameter("deptaid"));

		// set mem fields
		memSDate = outParam[5];
		memEDate = outParam[6];
		memRoom = outParam[7];

		if (isModify()) {
			setReloadSpecCboSql(getRoom(), false, outParam[7]);
			setReloadSpecCboSql(getPrimaryProc(), false, outParam[8]);
			setReloadSpecCboSql(getReferDoctor(), false, outParam[9]);
		}

		disableField(getPatMobNo());

		/*if (getPatNo().getText().length() == 0) {
			getPatFName().focus();
			txtPatNoEnable();
		}*/
	}

	protected void getFetchOutputValuesPbp(String[] outParam) {
		if (isAppend()) {

		}

		initAfterReadyPost();
	}

	/* >>> ~15~ Set Fetch Output Results ============================== <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return new String[] {
				memDeptType,
				getDeptaId().getText(),
				getPatNo().getText(),
				getPatFName().getText(),
				getPatGName().getText(),
				getDocNo().getText(),
				getDOB().getText(),
				getPhoneNo().getText(),
				getStartDate().getText(),
				getEndDate().getText(),
				getRoom().getText(),
				getPrimaryProc().getText(),
				Factory.getInstance().getUserInfo().getSsoUserID(),
				getSex().getText(),
				getPatType().getText(),
				getReferDoctor().getText(),
				memSDate,
				memEDate,
				memRoom,
				isContinueMultiBooking?YES_VALUE:NO_VALUE,
				isContinueOverlap?YES_VALUE:NO_VALUE,
				getProcRmk().getText(),
				YES_VALUE.equals(getSpecBook().getText())?ONE_VALUE:ZERO_VALUE,	 //AR_ACTIVE
				getWard().getText(),
				getBedCode().getText(),
				getReportDr().getText(),
				getNurseNote().getText()
			};
	}
//79
	/* >>> ~16.1~ Set Action Output Parameters =========================== <<< */
	@Override
	protected void getNewOutputValue(String returnValue) {}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void performAction(String actionType) {
		actionValidation(actionType);
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected void actionValidation(final String actionType) {
		if (getPatFName().isEmpty()) {
			getTabbedPane().setSelectedIndexWithoutStateChange(0);
			Factory.getInstance().addErrorMessage("Family Name is empty!", getPatFName());
			return;
		} else if (getPatGName().isEmpty()) {
			getTabbedPane().setSelectedIndexWithoutStateChange(0);
			Factory.getInstance().addErrorMessage("Given Name is empty!", getPatGName());
			return;
		} else if (getStartDate().isEmpty()) {
			getTabbedPane().setSelectedIndexWithoutStateChange(0);
			Factory.getInstance().addErrorMessage("Start Date/Time is empty!", getStartDate());
			return;
		} else if (!getStartDate().isValid()) {
			getTabbedPane().setSelectedIndexWithoutStateChange(0);
			Factory.getInstance().addErrorMessage("Invalid Start Date/Time!", getStartDate());
			return;
		} else if (getEndDate().isEmpty()) {
			getTabbedPane().setSelectedIndexWithoutStateChange(0);
			Factory.getInstance().addErrorMessage("End Date/Time is empty!", getEndDate());
			return;
		} else if (!getEndDate().isValid()) {
			getTabbedPane().setSelectedIndexWithoutStateChange(0);
			Factory.getInstance().addErrorMessage("Invalid End Date/Time!", getEndDate());
			return;
		} else if (getRoom().isEmpty()) {
			getTabbedPane().setSelectedIndexWithoutStateChange(0);
			Factory.getInstance().addErrorMessage("Room is empty!", getRoom());
			return;
		} else if (!getRoom().isValid()) {
			getTabbedPane().setSelectedIndexWithoutStateChange(0);
			Factory.getInstance().addErrorMessage("Invalid room!", getRoom());
			return;
		} else if (!getSex().isValid()) {
			getTabbedPane().setSelectedIndexWithoutStateChange(0);
			Factory.getInstance().addErrorMessage("Invalid sex!", getSex());
			return;
		} else if (getPrimaryProc().isEmpty()) {
			getTabbedPane().setSelectedIndexWithoutStateChange(0);
			Factory.getInstance().addErrorMessage("Procedure is empty!", getPrimaryProc());
			return;
		} else if (!getPrimaryProc().isValid()) {
			getTabbedPane().setSelectedIndexWithoutStateChange(0);
			Factory.getInstance().addErrorMessage("Invalid procedure!", getPrimaryProc());
			return;
		} else if (!getDOB().isEmpty() && !getDOB().isValid()) {
			getTabbedPane().setSelectedIndexWithoutStateChange(0);
			Factory.getInstance().addErrorMessage("Invalid Date!", getDOB());
			return;
		} else if (!getDOB().isEmpty() &&
				DateTimeUtil.dateDiff(getDOB().getText(), getMainFrame().getServerDate()) > 0) {
			getTabbedPane().setSelectedIndexWithoutStateChange(0);
			Factory.getInstance().addErrorMessage(MSG_BIRTHDAY_DATE, getDOB());
			return;
		} else if  (getReferDoctor().isEmpty()) {
			getTabbedPane().setSelectedIndexWithoutStateChange(0);
			Factory.getInstance().addErrorMessage("Doctor is empty!", getReferDoctor());
			return;
		}

		if (isAppend() ||
					(isModify() &&
						(!getStartDate().getText().equals(memSDate) ||
						 !getEndDate().getText().equals(memEDate) ||
						 !getRoom().getText().equals(memRoom)))) {
			if (DateTimeUtil.dateTimeDiff(getStartDate().getText() + ":00", getEndDate().getText() + ":00") >= 0) {
				getTabbedPane().setSelectedIndexWithoutStateChange(0);
				Factory.getInstance().addErrorMessage(MSG_END_DT_FOLLOW_START_DT, getEndDate());
				return;
			}
		}
		String[] date = getStartDate().getText().split(" ");
		if (Factory.getInstance().getSysParameter("deptDCheck") != null &&
				((Factory.getInstance().getSysParameter("deptDCheck").length() > 0 &&
				Factory.getInstance().getSysParameter("deptDCheck").equals(getRoom().getDeptCID()))
				 || (DateTimeUtil.timeDiff(date[1] ,"07:30") <= 0 && DateTimeUtil.timeDiff(date[1] ,"08:30") >= 0))){
			DlgDeptSecCheck jdialog = new DlgDeptSecCheck(getMainFrame(), "single"){
				@Override
				public void setVisible(boolean visible) {
					super.setVisible(visible);
				}

				@Override
				public void saveApp() {
					actionValidationReady(actionType, true);
				}
			};
			jdialog.setResizable(false);
			jdialog.setVisible(true);
		} else {
			actionValidationReady(actionType, true);
		}
	}

//Submitting form
	@Override
	protected void actionValidationReady(String actionType, boolean isValidationReady) {
		if (isValidationReady) {
			QueryUtil.executeMasterAction(
					getUserInfo(), getTxCode(), getActionType(),
					getActionInputParamaters(),
						new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(final MessageQueue mQueue) {
					if (mQueue.success()) {
						String sFuncName = memDeptType + " Appointment";
						String patno = getPatNo().getText();

						Map<String, String> params = new HashMap<String, String>();
						params.put("Room", getRoom().getText());
						params.put("App Start Date", getStartDate().getText());
						params.put("App End Date", getEndDate().getText());
						getAlertCheck().checkAltAccess(patno, sFuncName, false, true, params);

						setActionType(null);
						exitPanel();
					} else if ("-200".equals(mQueue.getReturnCode())) {
						// overlap period
						MessageBoxBase.alert("Confirm",
								"Appointment period is overlapped!",
								new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								isContinueOverlap = false;
								getTabbedPane().setSelectedIndexWithoutStateChange(0);
							}
						});
					}
				}
			});
		}
	}

	@Override
	protected boolean triggerSearchField() {
		if (getPatNo().isFocusOwner()) {
			getPatNo().checkTriggerBySearchKey();
			return true;
		} else {
			return false;
		}
	}

	@Override
	protected void enableButton() {
		disableButton();
		//getSearchButton().setEnabled(!allToolBarDisable);
		getSaveButton().setEnabled((isAppend() || isModify() || isNurseNote) && !allToolBarDisable);
		getClearButton().setEnabled(getDeptAPPPanel().isEnabled()&& !isNurseNote && !allToolBarDisable);

	}

	@Override
	protected void proExitPanel() {
		// for child class call
		if (getParameter("deptaid") != null) {
			unlockRecord(memDeptType+"Appointment", getParameter("deptaid"));
		}
	}

	@Override
	public void clearAction() {
		getPatNo().resetText();
		getPatFName().resetText();
		getPatGName().resetText();
		getDocNo().resetText();
		getPhoneNo().resetText();
		initAllSDT();
		getRoom().resetText();
		getRoom().clear();
		getPrimaryProc().resetText();
		getPrimaryProc().clear();
		getPatType().resetText();
		getPatType().clear();
		getDeptaId().resetText();
		getProcRmk().resetText();
		getSex().resetText();
		getReferDoctor().resetText();
		getWard().resetText();
		getReportDr().resetText();
		getBedCode().resetText();
		getPatType().setText("O");

		defaultFocus();
	}

	protected void controlTableColEditing(EditorTableList table) {
		if (!isModify() && !isAppend()) {
			table.stopEditing(true);
		}
	}

	/***************************************************************************
	 * Dialog Method
	 **************************************************************************/

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void setTabbedPaneIndex(int index) {
		this.TabbedPaneIndex = index;
	}

	public int getTabbedPaneIndex() {
		return TabbedPaneIndex;
	}

	private void showOverdueMsg(final ComboBoxBase docCombo,
			final boolean iStyle, final boolean onlyLb1) {
		final String docCode = docCombo != null ? docCombo.getText() : null;
		if (docCombo.getText().length() > 0) {
		// RealQuery "doctor", "doctdate, docsts", "doccode='" & drCode.Value(0) & "'", docTDate, isActive
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] {"doctor", "doccode, to_char(doctdate, 'dd/mm/yyyy'), docsts",
					"doccode='" + docCode + "'"}, new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						String doccode = mQueue.getContentField()[0];
						String docCtdate = mQueue.getContentField()[1];
						String docSts = mQueue.getContentField()[2];
						String warnMsg = null;

						if (!onlyLb1) {
							if (ZERO_VALUE.equals(docSts)) {
								if (docCtdate != null && docCtdate.length() > 0) {
									warnMsg = "Inactive doctor is selected, his/her admission expiry date is " + docCtdate;
								} else {
									warnMsg = "Inactive doctor is selected";
								}
								MessageBoxBase.addWarningMessage("Inactive doctor", warnMsg, null);
							}

							String startDate = getStartDate().getText();
							String endDate = getEndDate().getText();
							String deptaDate = null;

							if (startDate.isEmpty() || endDate.isEmpty() || doccode == null || doccode.length() <= 0) {
								return;
							}

							deptaDate = startDate;

							try {
								if (docCtdate != null && docCtdate.length() > 0 && deptaDate != null &&
										!deptaDate.isEmpty() &&
										DateTimeUtil.dateDiff(deptaDate.substring(0, 10), docCtdate) > 0) {
									if (iStyle) {
										docCombo.focus();
									} else {
										String tmpMsg = null;
										Factory.getInstance().isConfirmYesNoDialog(docCode + tmpMsg, new Listener<MessageBoxEvent>() {
											@Override
											public void handleEvent(MessageBoxEvent be) {
												if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
													//showOverdueMsgPostAction(docCombo, false);
												} else {
													//showOverdueMsgPostAction(docCombo, true);
													docCombo.focus();
												}
											}
										});
									}
								} else {
									if (deptaDate == null || deptaDate.isEmpty()) {
										Factory.getInstance().addErrorMessage("Type mismatch");
									}
									//showOverdueMsgPostAction(docCombo, false);
								}
							} catch (Exception e) {
								Factory.getInstance().addErrorMessage(e.getMessage());
							}
						} else {
							//showOverdueMsgPostAction(docCombo, false);
						}
					} else {
						//showOverdueMsgPostAction(docCombo, false);
					}
				}

				@Override
				public void onFailure(Throwable caught) {
					//showOverdueMsgPostAction(docCombo, false);
				}
			});
		}
	}

	private void setReloadSpecCboSql(ComboBoxBase cbo, boolean activeOnly, String savedKeyValue) {
		if (cbo == getRoom()) {
			getRoom().removeAllItems();
			if (activeOnly) {
				getRoom().refreshContent(new String[] {null, null, YES_VALUE, memDeptType});
			} else {
				getRoom().refreshContent(new String[] {NO_VALUE, savedKeyValue, YES_VALUE, memDeptType});
			}
		} else if (cbo == getPrimaryProc()) {
			getPrimaryProc().removeAllItems();
			if (activeOnly) {
				getPrimaryProc().refreshContent(new String[] {null, null, YES_VALUE, memDeptType});
			} else {
				getPrimaryProc().refreshContent(new String[] {NO_VALUE, savedKeyValue, YES_VALUE, memDeptType});
			}
		} else if (cbo == getReferDoctor()) {
			getReferDoctor().removeAllItems();
			if (activeOnly) {
				getReferDoctor().refreshContent(new String[] {null, null});
			} else {
				getReferDoctor().refreshContent(new String[] {NO_VALUE, savedKeyValue});
			}
		} else if (cbo == getReportDr()) {
			getReportDr().removeAllItems();
			if (activeOnly) {
				getReportDr().refreshContent(new String[] {null, null});
			} else {
				getReportDr().refreshContent(new String[] {NO_VALUE, savedKeyValue});
			}
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
			leftPanel.setSize(788, 485);
			leftPanel.add(getTabbedPane(), null);
		}
		return leftPanel;
	}

	protected BasePanel getRightPanel() {
		if (rightPanel == null) {
			rightPanel = new BasePanel();
//			leftPanel.setSize(800, 530));
		}
		return rightPanel;
	}

	public TabbedPaneBase getTabbedPane() {
		if (TabbedPane == null) {
			TabbedPane = new TabbedPaneBase() {
				@Override
				public void onStateChange() {
				}
			};
			TabbedPane.setBounds(0, 0, 800, 620);
			TabbedPane.addTab(memDeptType + " APP", getDeptAPPPanel());
		}
		return TabbedPane;
	}
	public BasePanel getDeptAPPPanel() {
		if (DeptAPPPanel == null) {
			DeptAPPPanel = new BasePanel();
			DeptAPPPanel.setBounds(10, 10, 800, 510);
			DeptAPPPanel.add(getAlertPanel(), null);
			DeptAPPPanel.add(getPatNoDesc(), null);
			DeptAPPPanel.add(getPatNo(), null);
			DeptAPPPanel.add(getSpecBookDesc(), null);
			DeptAPPPanel.add(getSpecBook(), null);
			DeptAPPPanel.add(getDeptaId(), null);
			DeptAPPPanel.add(getPatFNameDesc(), null);
			DeptAPPPanel.add(getPatFName(), null);
			DeptAPPPanel.add(getPatGNameDesc(), null);
			DeptAPPPanel.add(getPatGName(), null);
			DeptAPPPanel.add(getDocNoDesc(), null);
			DeptAPPPanel.add(getDocNo(), null);
			DeptAPPPanel.add(getDOBDesc(), null);
			DeptAPPPanel.add(getDOB(), null);
			DeptAPPPanel.add(getPhoneNoDesc(), null);
			DeptAPPPanel.add(getPhoneNo(), null);
			DeptAPPPanel.add(getSexDesc(), null);
			DeptAPPPanel.add(getSex(), null);
			DeptAPPPanel.add(getPatMobNoDesc(), null);
			DeptAPPPanel.add(getPatMobNo(), null);
			DeptAPPPanel.add(getPatTypeDesc(), null);
			DeptAPPPanel.add(getPatType(), null);
			DeptAPPPanel.add(getStartDateDesc(), null);
			DeptAPPPanel.add(getStartDate(), null);
			DeptAPPPanel.add(getEndDateDesc(), null);
			DeptAPPPanel.add(getEndDate(), null);
			DeptAPPPanel.add(getRoomDesc(), null);
			DeptAPPPanel.add(getRoom(), null);
			DeptAPPPanel.add(getPrimaryProcDesc(), null);
			DeptAPPPanel.add(getPrimaryProc(), null);
//			DeptAPPPanel.add(getPrimaryProcSearch(), null);
			DeptAPPPanel.add(getReferDoctorDesc(), null);
			DeptAPPPanel.add(getReferDoctor(), null);
			//DeptAPPPanel.add(getWardDesc(), null);
			//DeptAPPPanel.add(getWard(), null);
			DeptAPPPanel.add(getReportDrDesc(),null);
			DeptAPPPanel.add(getReportDr(),null);
			DeptAPPPanel.add(getBedCodeDesc(), null);
			DeptAPPPanel.add(getBedCode(), null);
			DeptAPPPanel.add(getProcPanel(), null);
			DeptAPPPanel.add(getNurseNoteDesc(), null);
			DeptAPPPanel.add(getNurseNote(), null);
			DeptAPPPanel.add(getNNoteUneventFul(), null);
			DeptAPPPanel.add(getNNoteUneventFulDesc(), null);
		}
		return DeptAPPPanel;
	}

	public FieldSetBase getAlertPanel() {
		if (AlertPanel == null) {
			AlertPanel = new FieldSetBase();
			AlertPanel.setHeading("<font color='red'>ALERT</font>");
			AlertPanel.add(getAlert(), null);
			AlertPanel.setBounds(0, 0, 750, 95);
		}
		return AlertPanel;
	}

	public TextAreaBase getAlert() {
		if (AlertRmk == null) {
			AlertRmk = new TextAreaBase(false);
			AlertRmk.setInputStyleAttribute("color", "red");
			AlertRmk.setBounds(5, 0, 700, 65);
		}
		return AlertRmk;
	}

	public LabelBase getPatNoDesc() {
		if (PatNoDesc == null) {
			PatNoDesc = new LabelBase();
			PatNoDesc.setText("Patient No");
			PatNoDesc.setBounds(10, 100, 106, 20);
		}
		return PatNoDesc;
	}

	@SuppressWarnings("unchecked")
	public TextPatientNoSearch getPatNo() {
		if (PatNo == null) {
			PatNo = new TextPatientNoSearch(true) {
				@Override
				protected void actionAfterOK() {
					fillPatDetail();

				}
				@Override
				protected void checkDeathPatientDialogNo() {
					if (!init && !bMem_bIsEdit && !isNurseNote) {
						resetPatDetail();
					}
				}

				protected void checkDeathPatientFailPost() {
					resetText();
					Factory.getInstance().addErrorMessage(MSG_INVALID_PATIENTNO, getText());
					defaultFocus();
				}

				@Override
				public void onBlurPost() {
					if(!isNurseNote) {
						if ((memPatNo != null && memPatNo.length()> 0)) {
							if (!memPatNo.equals(getText())) {
								clearPatientInfo();
								fillPatDetail();
							}
						} else {
							clearPatientInfo();
							fillPatDetail();
						}
					}
				}

				@Override
				public void onReleased() {
					if (!isNurseNote) {
						clearPatientInfo();
					}
				}

			};
			PatNo.setBounds(115, 100, 195, 20);
			PatNo.setCheckDeathPatient(true);
		}
		return PatNo;
	}

	public void clearPatientInfo() {
		if (getPatNo().getText().length() > 0) {
			getPatFName().resetText();
			getPatGName().resetText();
			getPatMobNo().resetText();
			getDocNo().resetText();
			getDOB().resetText();
			getSex().resetText();
			getSex().clear();
			getWard().resetText();
			getBedCode().resetText();
			strOldPatNo = null;
			memBedCode = null;
			getPatType().setText("O");
			getPhoneNo().resetText();

			disableField(getPatFName());
			disableField(getPatGName());
			disableField(getPatMobNo());
			//disableField(getPhoneNo());
			disableField(getDOB());
			disableField(getSex());
			disableField(getDocNo());
		} else {
			getPatFName().resetText();
			getPatGName().resetText();
			getPatMobNo().resetText();
			getPhoneNo().resetText();
			getDocNo().resetText();
			getDOB().resetText();
			getSex().resetText();
			getSex().clear();
			getWard().resetText();
			getBedCode().resetText();
			strOldPatNo = null;
			memBedCode = null;
			getPatType().setText("O");

			enableField(getPatFName());
			enableField(getPatGName());
			enableField(getPhoneNo());
			enableField(getDOB());
			enableField(getSex());
			enableField(getDocNo());
		}
	}

	public LabelBase getSpecBookDesc() {
		if (SpecBookDesc == null) {
			SpecBookDesc = new LabelBase();
			SpecBookDesc.setText("Special Booking");
			SpecBookDesc.setBounds(430, 100, 106, 20);
		}
		return SpecBookDesc;
	}

	private CheckBoxBase getSpecBook() {
		if (SpecBook == null) {
			SpecBook = new CheckBoxBase(){
				@Override
				public void onClick() {
				}
			};
			SpecBook.setBounds(530, 100, 20, 20);
		}
		return SpecBook;
	}


	public TextString getDeptaId() {
		if (DeptaId == null) {
			DeptaId = new TextString();
			DeptaId.setBounds(310, 0, 50, 20);
			DeptaId.setVisible(false);
		}
		return DeptaId;
	}

	public LabelBase getPatFNameDesc() {
		if (PatFNameDesc == null) {
			PatFNameDesc = new LabelBase();
			PatFNameDesc.setText("Family Name");
			PatFNameDesc.setBounds(10, 123, 106, 20);
		}
		return PatFNameDesc;
	}

	public TextString getPatFName() {
		if (PatFName == null) {
			PatFName = new TextString(40) {
				@Override
				public void onBlur() {
					super.onBlur();
					//txtPatNoEnable();
				}

				@Override
				protected void onFocus() {
					super.onFocus();
					//txtPatNoEnable();
				}
			};
			PatFName.setBounds(115, 123, 195, 20);
			PatFName.addKeyListener(new KeyListener() {
				@Override
				public void componentKeyUp(ComponentEvent event) {
					txtPatNoEnable();
				}
			});
		}
		return PatFName;
	}

	public LabelBase getPatGNameDesc() {
		if (PatGNameDesc == null) {
			PatGNameDesc = new LabelBase();
			PatGNameDesc.setText("Given Name");
			PatGNameDesc.setBounds(430, 123, 111, 20);
		}
		return PatGNameDesc;
	}

	public TextString getPatGName() {
		if (PatGName == null) {
			PatGName = new TextString(40) {
				@Override
				public void onBlur() {
					super.onBlur();
					//txtPatNoEnable();
				}

				@Override
				protected void onFocus() {
					super.onFocus();
					//txtPatNoEnable();
				}
			};
			PatGName.setBounds(530, 123, 195, 20);
			PatGName.addKeyListener(new KeyListener() {
				@Override
				public void componentKeyUp(ComponentEvent event) {
					txtPatNoEnable();
				}
			});
		}
		return PatGName;
	}

	public LabelBase getDocNoDesc() {
		if (DocNoDesc == null) {
			DocNoDesc = new LabelBase();
			DocNoDesc.setText("Document No");
			DocNoDesc.setBounds(10, 146, 106, 20);
		}
		return DocNoDesc;
	}

	public TextString getDocNo() {
		if (DocNo == null) {
			DocNo = new TextString() {
				@Override
				public void onBlur() {
					super.onBlur();
					//txtPatNoEnable();
				}

				@Override
				protected void onFocus() {
					super.onFocus();
					//txtPatNoEnable();
				}
			};
			DocNo.setBounds(115, 146, 195, 20);
			DocNo.addKeyListener(new KeyListener() {
				public void componentKeyUp(ComponentEvent event) {
					txtPatNoEnable();
				}
			});
		}
		return DocNo;
	}

	public LabelBase getDOBDesc() {
		if (DOBDesc == null) {
			DOBDesc = new LabelBase();
			DOBDesc.setText("DOB");
			DOBDesc.setBounds(430, 146, 111, 20);
		}
		return DOBDesc;
	}

	public TextDateWithCheckBox getDOB() {
		if (DOB == null) {
			DOB = new TextDateWithCheckBox() {
				@Override
				public void onBlur() {
					super.onBlur();
					//txtPatNoEnable();
				}

				@Override
				protected void onFocus() {
					super.onFocus();
					//txtPatNoEnable();
				}
			};
			DOB.setBounds(530, 146, 195, 20);
			DOB.addKeyListener(new KeyListener() {
				@Override
				public void componentKeyUp(ComponentEvent event) {
					txtPatNoEnable();
				}
			});
		}
		return DOB;
	}

	public LabelBase getPhoneNoDesc() {
		if (PhoneNoDesc == null) {
			PhoneNoDesc = new LabelBase();
			PhoneNoDesc.setText("Contact Phone No.");
			PhoneNoDesc.setBounds(10, 169, 106, 20);
		}
		return PhoneNoDesc;
	}

	public TextString getPhoneNo() {
		if (PhoneNo == null) {
			PhoneNo = new TextString() {
				@Override
				public void onBlur() {
					super.onBlur();
					//txtPatNoEnable();
				}

				@Override
				protected void onFocus() {
					super.onFocus();
					//txtPatNoEnable();
				}
			};
			PhoneNo.setBounds(115, 169, 195, 20);
			PhoneNo.addKeyListener(new KeyListener() {
				@Override
				public void componentKeyDown(ComponentEvent event) {
					if (KeyCodes.KEY_TAB == event.getKeyCode()) {
						if(PhoneNo.getText().trim().length() < 8){
							Factory.getInstance().addErrorMessage("Contact Number should not less than 8 dight");
							PhoneNo.requestFocus();
						}
					} else {
						super.componentKeyDown(event);
					}
				}
			});
		}
		return PhoneNo;
	}

	public LabelBase getSexDesc() {
		if (SexDesc == null) {
			SexDesc = new LabelBase();
			SexDesc.setText("Sex");
			SexDesc.setBounds(430, 169, 111, 20);
		}
		return SexDesc;
	}

	public ComboSex getSex() {
		if (Sex == null) {
			Sex = new ComboSex();
			Sex.setBounds(530, 169, 118, 20);
		}
		return Sex;
	}

	public LabelBase getPatMobNoDesc() {
		if (PatMobNoDesc == null) {
			PatMobNoDesc = new LabelBase();
			PatMobNoDesc.setText("Patient Mobile No.");
			PatMobNoDesc.setBounds(10, 192, 106, 20);
		}
		return PatMobNoDesc;
	}

	public TextString getPatMobNo() {
		if (PatMobNo == null) {
			PatMobNo = new TextString();
			PatMobNo.setBounds(115, 192, 195, 20);
		}
		return PatMobNo;
	}

	public LabelBase getPatTypeDesc() {
		if (PatTypeDesc == null) {
			PatTypeDesc = new LabelBase();
			PatTypeDesc.setText("Patient Type");
			PatTypeDesc.setBounds(430, 192, 111, 20);
		}
		return PatTypeDesc;
	}

	public ComboDeptAppPatType getPatType() {
		if (PatType == null) {
			PatType = new ComboDeptAppPatType();
			PatType.setBounds(530, 192, 195, 20);
		}
		return PatType;
	}

	public LabelBase getStartDateDesc() {
		if (StartDateDesc == null) {
			StartDateDesc = new LabelBase();
			StartDateDesc.setText("Start Date/Time");
			StartDateDesc.setBounds(10, 215, 106, 20);
		}
		return StartDateDesc;
	}

	@SuppressWarnings("unchecked")
	public TextDateTimeWithoutSecond getStartDate() {
		if (StartDate == null) {
			StartDate = new TextDateTimeWithoutSecond();
			StartDate.setBounds(115, 215, 195, 20);

			StartDate.addListener(Events.OnBlur, new Listener() {
				@Override
				public void handleEvent(BaseEvent be) {
					String[] date = getStartDate().getText().split(" ");
					if(date != null && date.length == 2){
						if(DateTimeUtil.timeDiff(date[1] ,"07:30") <= 0 && DateTimeUtil.timeDiff(date[1] ,"08:30") >= 0){
							getSpecBook().setValue(true);
						} else if(DateTimeUtil.timeDiff(date[1],"17:00") <= 0 && DateTimeUtil.timeDiff(date[1],"22:00") >= 0){
							getSpecBook().setValue(true);
						} else {
							getSpecBook().setValue(false);
						}
					}
					if (!StartDate.isEmpty()) {
						if (StartDate.isValid()) {
							getEndDate().setText(StartDate.getText());
							getEndDate().setSelectionRange(StartDate.getText().substring(0, 10).length()+1, 2);
						}
					}
				}
			});
		}
		return StartDate;
	}

	public LabelBase getEndDateDesc() {
		if (EndDateDesc == null) {
			EndDateDesc = new LabelBase();
			EndDateDesc.setText("End");
			EndDateDesc.setBounds(430, 215, 111, 20);
		}
		return EndDateDesc;
	}

	public TextDateTimeWithoutSecond getEndDate() {
		if (EndDate == null) {
			EndDate = new TextDateTimeWithoutSecond();
			EndDate.setBounds(530, 215, 195, 20);

			EndDate.addListener(Events.OnBlur, new Listener() {
				@Override
				public void handleEvent(BaseEvent be) {
				}
			});
		}
		return EndDate;
	}

	public LabelBase getRoomDesc() {
		if (RoomDesc == null) {
			RoomDesc = new LabelBase();
			RoomDesc.setText("Exam Room");
			RoomDesc.setBounds(10, 238, 106, 20);
		}
		return RoomDesc;
	}

	public ComboDeptAppRoomType getRoom() {
		if (Room == null) {
			Room = new ComboDeptAppRoomType(memDeptType, false);
			Room.setBounds(115, 238, 195, 20);
		}
		return Room;
	}

	public LabelBase getWardDesc() {
		if (WardDesc == null) {
			WardDesc = new LabelBase();
			WardDesc.setText("Ward");
			WardDesc.setBounds(10, 260, 106, 20);
		}
		return WardDesc;
	}

	public ComboWard getWard() {
		if (Ward == null) {
			Ward = new ComboWard();
			Ward.setBounds(115, 260, 195, 20);
		}
		return Ward;
	}

	public LabelBase getReportDrDesc() {
		if (ReportDrDesc == null) {
			ReportDrDesc = new LabelBase();
			ReportDrDesc.setText("Reporting Doctor");
			ReportDrDesc.setBounds(10, 260, 106, 20);
		}
		return ReportDrDesc;
	}
	public ComboReferDotorDeptApp getReportDr() {
		if (ReportDr == null) {
			ReportDr = new ComboReferDotorDeptApp(false) {
				@Override
				protected void setTextPanel(ModelData modelData) {
					setToolTip(getDisplayText());
					if (!init && (getOriginalValue() == null || !getOriginalValue().equals(getText()))) {
						showOverdueMsg(this, true, false);
					}
					setOriginalValue(this.getText());
				}

			};
			ReportDr.setBounds(115, 260, 195, 20);
			ReportDr.setMinListWidth(300);
			ReportDr.setForceSelection(false);
		}
		return ReportDr;
	}

	public LabelBase getBedCodeDesc() {
		if (bedCodeDesc == null) {
			bedCodeDesc = new LabelBase();
			bedCodeDesc.setText("Bed Code");
			bedCodeDesc.setBounds(430, 260, 106, 20);
		}
		return bedCodeDesc;
	}

	public ComboBedCode getBedCode() {
		if (bed == null) {
			bed = new ComboBedCode(){
				protected void onSelected() {
					if(!bMem_bIsEdit&&(!"".equals(getText().trim()) &&
							((memBedCode == null || memBedCode.length() == 0)||
									!memBedCode.equals(getText().trim())))) {
							QueryUtil.executeMasterFetch(getUserInfo(), "INPBEDPATNO",
									new String[] { getText().trim(),"" },
									new MessageQueueCallBack() {
								public void onPostSuccess(MessageQueue mQueue) {
									if (mQueue.success()) {
										if(!"".equals(mQueue.getContentField()[0])){
											getPatNo().setText(mQueue.getContentField()[0]);
											getPatType().setText("I");
											fillPatDetail();
										} else {
											fillPatDetail();
										}
									} else {
										getPatNo().resetText();
										getPatFName().resetText();
										getPatGName().resetText();
										getPatMobNo().resetText();
										//getPhoneNo().resetText();
										getDocNo().resetText();
										getDOB().resetText();
										getSex().resetText();
										getSex().clear();
										getWard().resetText();
										getReportDr().resetText();
										getReferDoctor().resetText();
										getProcRmk().resetText();
										getPatType().resetText();
										strOldPatNo = null;
										memBedCode = null;
									}
								}});
					}
				}
				protected void clearPostAction() {
					if(isFocusOwner() && !bMem_bIsEdit && !isNurseNote) {
						getPatNo().resetText();
						getPatFName().resetText();
						getPatGName().resetText();
						getPatMobNo().resetText();
						getPhoneNo().resetText();
						getDocNo().resetText();
						getDOB().resetText();
						getSex().resetText();
						getSex().clear();
						getWard().resetText();
						getReferDoctor().resetText();
						getReportDr().resetText();
						getProcRmk().resetText();
						strOldPatNo = null;
						memBedCode = null;
					}
				}
			};
			bed.setBounds(530, 260, 195, 20);
		}
		return bed;
	}

	public FieldSetBase getProcPanel() {
		if (ProcPanel == null) {
			ProcPanel = new FieldSetBase();
			ProcPanel.setHeading("Procedure");
			ProcPanel.add(getPrimaryProcDesc(), null);
			ProcPanel.add(getPrimaryProc(), null);
			ProcPanel.add(getProcRmkDesc(), null);
			ProcPanel.add(getProcRmk(), null);
//			ProcPanel.add(getPrimaryProcSearch(), null);
			ProcPanel.setBounds(0, 281, 750, 115);
		}
		return ProcPanel;
	}

	public LabelBase getPrimaryProcDesc() {
		if (PrimaryProcDesc == null) {
			PrimaryProcDesc = new LabelBase();
			PrimaryProcDesc.setText("Procedure");
			PrimaryProcDesc.setBounds(10, -10, 86, 20);
		}
		return PrimaryProcDesc;
	}

	public ComboDeptProc getPrimaryProc() {
		if (PrimaryProc == null) {
			PrimaryProc = new ComboDeptProc("memDeptType", false){
				@Override
				protected void setTextPanel(ModelData modelData) {
					setToolTip(getDisplayText());
					if (!init && (getOriginalValue() == null || !getOriginalValue().equals(getText()))) {
						getProcDuration(getPrimaryProc().getText());
					}
					setOriginalValue(this.getText());
				}
			};
/*			PrimaryProc.addSelectionChangedListener(
						new SelectionChangedListener<ModelData>() {
					@Override
					public void selectionChanged(SelectionChangedEvent<ModelData> se) {
						getPrimaryProc().setToolTip(getPrimaryProc().getDisplayText());
						getProcDuration(getPrimaryProc().getText());

					}
				});*/
			PrimaryProc.setBounds(114, -10, 570, 20);
		}
		return PrimaryProc;
	}

	private void getProcDuration(String pid){
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] {"DEPT_PROC", "DEPTPDUR",
				"deptpid='" + pid + "'"}, new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					if(!"".equals(mQueue.getContentField()[0])){
						int duration = Integer.valueOf(mQueue.getContentField()[0]);
						String endTimeOfApp = DateTimeUtil.formatDateTime
								(new Date(DateTimeUtil.parseDateTime(getStartDate().getText()+":00").getTime()+((duration) * 60000)));
						getEndDate().setText(endTimeOfApp);
					}
				}
			}
		});
	}

	public LabelBase getProcRmkDesc() {
		if (ProcRmkDesc == null) {
			ProcRmkDesc = new LabelBase();
			ProcRmkDesc.setText("<html>Procedure<br>Remarks</html>");
			ProcRmkDesc.setBounds(10, 15, 86, 20);
		}
		return ProcRmkDesc;
	}

	public TextAreaBase getProcRmk() {
		if (ProcRmk == null) {
			ProcRmk = new TextAreaBase(3, 80);
			ProcRmk.setBounds(114, 20, 570, 55);
		}
		return ProcRmk;
	}

	public LabelBase getReferDoctorDesc() {
		if (ReferDoctorDesc == null) {
			ReferDoctorDesc = new LabelBase();
			ReferDoctorDesc.setText("Referral Doctor");
			ReferDoctorDesc.setBounds(430, 238, 106, 20);
		}
		return ReferDoctorDesc;
	}

	public ComboReferDotorDeptApp getReferDoctor() {
		if (ReferDoctor == null) {
			ReferDoctor = new ComboReferDotorDeptApp(false) {
				@Override
				protected void setTextPanel(ModelData modelData) {
					setToolTip(getDisplayText());
					if (!init && (getOriginalValue() == null || !getOriginalValue().equals(getText()))) {
						showOverdueMsg(this, true, false);
					}
					setOriginalValue(this.getText());
				}
			};
			ReferDoctor.setBounds(530, 238, 195, 20);
			ReferDoctor.setMinListWidth(300);
			ReferDoctor.setForceSelection(false);
		}
		return ReferDoctor;
	}
	
	public LabelBase getNurseNoteDesc() {
		if (nurseNoteDesc == null) {
			nurseNoteDesc = new LabelBase();
			nurseNoteDesc.setText("Nurse Note");
			nurseNoteDesc.setBounds(10, 400, 86, 20);
		}
		return nurseNoteDesc;
	}

	public TextAreaBase getNurseNote() {
		if (nurseNote == null) {
			nurseNote = new TextAreaBase(10, 80);
			nurseNote.setStringLength(2000);
			nurseNote.setBounds(115, 400, 570, 80);
		}
		return nurseNote;
	}
	
	private CheckBoxBase getNNoteUneventFul() {
		if (isNNoteUneventFul == null) {
			isNNoteUneventFul = new CheckBoxBase(){
				@Override
				public void onClick() {
					QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] {"HPSTATUS", "HPRMK", "HPTYPE ='CPLABAPP' AND HPKEY='NNTEXT' AND HPSTATUS = 'UNEVENTFUL' "},
							new MessageQueueCallBack() {
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								getNurseNote().setText(getNurseNote().getText()+(getNurseNote().getText().length()> 0?"\n":"")
										+getPrimaryProc().getDisplayText().split("-")[1].trim()+" "+mQueue.getContentField()[0]);
								getNurseNote().focus();
							}
						}});
				}
			};
			isNNoteUneventFul.setBounds(115, 482, 20, 20);
		}
		return isNNoteUneventFul;
	}
	
	public LabelBase getNNoteUneventFulDesc() {
		if (nNoteUneventFulDesc == null) {
			nNoteUneventFulDesc = new LabelBase();
			nNoteUneventFulDesc.setText("Uneventful");
			nNoteUneventFulDesc.setBounds(138, 482, 86, 20);
		}
		return nNoteUneventFulDesc;
	}
}