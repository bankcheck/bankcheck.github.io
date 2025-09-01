package com.hkah.client.tx.ot;

import java.util.HashMap;
import java.util.Map;

import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.event.BaseEvent;
import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.FieldEvent;
import com.extjs.gxt.ui.client.event.KeyListener;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.event.SelectionChangedEvent;
import com.extjs.gxt.ui.client.event.SelectionChangedListener;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.form.Field;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboACMCode;
import com.hkah.client.layout.combobox.ComboARCompany;
import com.hkah.client.layout.combobox.ComboAnesMeth;
import com.hkah.client.layout.combobox.ComboAppRoomType;
import com.hkah.client.layout.combobox.ComboBedCode;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.combobox.ComboCoPayRefType;
import com.hkah.client.layout.combobox.ComboDoctor;
import com.hkah.client.layout.combobox.ComboDoctorAN;
import com.hkah.client.layout.combobox.ComboDoctorEN;
import com.hkah.client.layout.combobox.ComboDoctorSU;
import com.hkah.client.layout.combobox.ComboOTProc;
import com.hkah.client.layout.combobox.ComboPackage;
import com.hkah.client.layout.combobox.ComboPatientType;
import com.hkah.client.layout.combobox.ComboProcPrim;
import com.hkah.client.layout.combobox.ComboReferDotor;
import com.hkah.client.layout.combobox.ComboSex;
import com.hkah.client.layout.combobox.ComboWard;
import com.hkah.client.layout.combobox.ComboYesNo;
import com.hkah.client.layout.dialog.DlgBedPreBookDupl;
import com.hkah.client.layout.dialog.DlgBudgetEstBase;
import com.hkah.client.layout.dialog.DlgDocPrivilege;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.panel.TabbedPaneBase;
import com.hkah.client.layout.table.EditorTableList;
import com.hkah.client.layout.textfield.TextAreaBase;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextDateTimeWithoutSecond;
import com.hkah.client.layout.textfield.TextDateTimeWithoutSecondWithCheckBox;
import com.hkah.client.layout.textfield.TextDateWithCheckBox;
import com.hkah.client.layout.textfield.TextDoctorSearch;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.PanelUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsGlobal;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTableColumn;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class NewEditOTApp extends MasterPanel implements ConstantsVariable, ConstantsTableColumn {

	private final static String MSG_ALLERGY_DOWN = "Cannot access Clinical System, the allergy information cannot be displayed.";

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		return ConstantsTx.NEWEDITOTAPP_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.NEWEDITOTAPP_TITLE;
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

	private int TabbedPaneIndex = 0;
	private TabbedPaneBase TabbedPane = null;
	private BasePanel OTAPPPanel = null;
	private LabelBase PatNoDesc = null;
	private TextPatientNoSearch PatNo = null;
	private TextString OtaId = null;
	private LabelBase PatCNameDesc = null;
	private TextString PatCName = null;
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
	private ButtonBase Allergy = null;
	private LabelBase PatMobNoDesc = null;
	private TextString PatMobNo = null;
	private LabelBase PatTypeDesc = null;
	private ComboPatientType PatType = null;
	private LabelBase StartDateDesc = null;
	private TextDateTimeWithoutSecond StartDate = null;
	private LabelBase EndDateDesc = null;
	private TextDateTimeWithoutSecond EndDate = null;
	private LabelBase RoomDesc = null;
	private ComboAppRoomType Room = null;
//	private LabelBase ProcDesc = null;
//	private ComboOTProc Proc = null;
//	private ButtonBase SearchProc = null;
	private ComboProcPrim comboProcPrim = null;
	private LabelBase ReferDotorDesc = null;
	private ComboReferDotor ReferDotor = null;
	private LabelBase ProcRmkDesc = null;
	private TextAreaBase ProcRmk = null;
	private LabelBase DiagnoDesc = null;
	private TextAreaBase Diagno = null;
	private LabelBase SurgeonDesc = null;
	private ComboDoctorSU Surgeon = null;
	private LabelBase SurNotifyDesc = null;
	private LabelBase surExpDateDesc = null;
	private TextDateTimeWithoutSecondWithCheckBox SurNotify = null;
	private LabelBase SecSurgeonDesc = null;
	private ComboDoctorSU SecSurgeon = null;
	private LabelBase SecSurExpDateDesc = null;
	private LabelBase SecSurNotifyDesc = null;
	private TextDateTimeWithoutSecondWithCheckBox SecSurNotify = null;
	private LabelBase AnesthDesc = null;
	private ComboDoctorAN Anesth = null;
	private LabelBase AnesNotifyDesc = null;
	private LabelBase anesExpDateDesc = null;
	private TextDateTimeWithoutSecondWithCheckBox AnesNotify = null;
	private LabelBase AnesMethodDesc = null;
	private ComboAnesMeth AnesMethod = null;
	private LabelBase EndoscopistDesc = null;
	private ComboDoctorEN Endoscopist = null;
	private LabelBase EndNotifyDesc = null;
	private LabelBase endExpDateDesc = null;
	private TextDateTimeWithoutSecondWithCheckBox EndNotify = null;
	private LabelBase OTRmkDesc = null;
	private TextAreaBase OTRmk = null;
	private LabelBase FERequestedDesc = null;
	private ComboYesNo FERequested = null;
	private LabelBase FEReceivedDesc = null;
	private ComboYesNo FEReceived = null;

	private FieldSetBase ProcPanel = null;
	private LabelBase PrimaryProcDesc = null;
	private ComboOTProc PrimaryProc = null;
	private ButtonBase PrimaryProcSearch = null;
	private LabelBase SecProcDesc = null;
	private ButtonBase secProcAdd = null;
	private ButtonBase secProcRemove = null;
	private EditorTableList SecProcTable = null;
	private JScrollPane SecProcJScrollPane= null;

	private BasePanel BedBookPanel = null;
	private FieldSetBase BookInfPanel = null;
	private LabelBase SchdAdmDateDesc = null;
	private TextDateTimeWithoutSecondWithCheckBox SchdAdmDate = null;
	private LabelBase OrderbyDoctorDesc = null;
	private ComboDoctor OrderbyDoctor = null;
	private TextDoctorSearch drCodeSearchDelegate = null;
	private LabelBase ForDeliveryDesc = null;
	private CheckBoxBase ForDelivery = null;
	private LabelBase MaincizenDesc = null;
	private CheckBoxBase Maincizen = null;
	private LabelBase ACMDesc = null;
	private ComboACMCode ACM = null;
	private LabelBase WardDesc = null;
	private ComboWard Ward = null;
	private LabelBase PBORmkDesc = null;
	private TextString PBORmk = null;
	private LabelBase CathLabRmkDesc = null;
	private TextString CathLabRmk = null;
	private LabelBase bpbOTRmkDesc = null;
	private TextString bpbOTRmk = null;
	private LabelBase bedCodeDesc = null;
	private ComboBedCode bed = null;
	private LabelBase estLenOfStayDesc = null;
	private TextString estLenOfStay = null;
	private LabelBase RightJLabel_Pkg = null;
	private ComboPackage RightJCombo_Pkg = null;
	private LabelBase RightJLabel_Misc = null;
	private ComboBoxBase RightJCombo_Misc = null;
	private LabelBase RightJLabel_Source = null;
	private ComboBoxBase RightJCombo_Source = null;
	private LabelBase RightJLabel_Package = null;
	private ComboBoxBase RightJCombo_Package = null;
	private LabelBase RightJLabel_SourceNo = null;
	private TextString RightJText_SourceNo = null;
	private ButtonBase RightButton_BudgetEst = null;
	private DlgBudgetEstBase dlgBudgetEst = null;
	private LabelBase PJCheckBox_BEDesc = null;
	private CheckBoxBase PJCheckBox_BE = null;

	private FieldSetBase ARInfPanel = null;
	private LabelBase ARCodeDesc = null;
	private ComboARCompany ARCode = null;
	private LabelBase PolicyNoDesc = null;
	private TextString PolicyNo = null;
	private LabelBase CoPayTypeDesc = null;
	private ComboCoPayRefType CoPayType = null;
	private TextString Amt = null;
	private LabelBase VouNoDesc = null;
	private TextString VouNo = null;
	private LabelBase InsCoverDesc = null;
	private TextDate InsCover = null;
	private LabelBase InsLimitAmtDesc = null;
	private TextString InsLimitAmt = null;
	private LabelBase CoverItemDesc = null;
	private LabelBase DoctorDesc = null;
	private CheckBoxBase Doctor = null;
	private LabelBase HospitalDesc = null;
	private CheckBoxBase Hospital = null;;
	private LabelBase SpecialDesc = null;
	private CheckBoxBase Special = null;;
	private LabelBase OtherDesc = null;
	private CheckBoxBase Other = null;

	private FieldSetBase DeclinationPanel = null;
	private LabelBase DeclinedDesc = null;
	private CheckBoxBase Declind = null;
	private LabelBase ReasonDesc = null;
	private TextString Reason = null;
	private LabelBase ByDesc = null;
	private TextString By1 = null;
	private TextDate By2 = null;
	private LabelBase ActivatebyDesc = null;
	private TextString Activateby1 = null;
	private TextDate Activateby2 = null;
	private DlgDocPrivilege dlgDocPrivilege = null;
	private LabelBase cancelWarning = null;
	private DlgBedPreBookDupl duplicateDialog = null;

	private TextReadOnly ARDescription = null;

	private String strOldPatNo = null;
	private boolean bMem_bIsEdit = false;

	private int lotPBPID = 0;	//
	private boolean otaBed = false;
	private boolean isFromPB = false;
	private boolean isFlag = false;
	private boolean isFrmAllergyLoaded = false;
	private String preArcCde = null;
	private String oriRefuseStatus = null;
	private String tempQActionType = null;
	private String tempActionType = null;
	private boolean autoAdd = false;

	private String memPatNo = null;
	private String memPatCName = null;
	private String memPatFName = null;
	private String memPatGName = null;
	private String memDocNo = null;
	private String memDOB = null;
	private String memPhoneNo = null;
	private String memSex = null;
	private String memMobileNo = null;
	private String memSDate = null;
	private String memEDate = null;
	private String memSNDate = null;
	private String memANDate = null;
	private String memENDate = null;
	private boolean memDeclined = false;
	private boolean allToolBarDisable = false;
	private String memBPBStatus = null;
	private String memRoom = null;
	private String memSavedValProc = null;
	private String memSavedValSDr = null;
	private String memSavedValRDr = null;
	private String memSavedValADr = null;
	private String memSavedValEDr = null;
	private boolean isContinueMultiBooking = false;
	private boolean isContinueOverlap = false;
	private boolean isContinueOverlapSDoc = false;
	private boolean isContinueOverlapADoc = false;
	private boolean isContinueOverlapEDoc = false;
	private boolean isContinueOverdueSDoc = false;
	private boolean isContinueOverdueADoc = false;
	private boolean isContinueOverdueEDoc = false;
	private boolean isContinueProPrivSDoc = false;
	private boolean isContinueProPrivEDoc = false;
	private boolean isContinueDuplicate = false;
	private boolean init = true;
	private boolean surgeonOverride = false;
	private String memFestID = null;

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;

	/**
	 * This method initializes
	 *
	 */
	public NewEditOTApp() {
		super();
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
		bMem_bIsEdit = false;
		lotPBPID = 0;
		otaBed = false;
		isFromPB = false;
		isFlag = false;
		isFrmAllergyLoaded = false;
		preArcCde = null;
		oriRefuseStatus = null;
		tempQActionType = null;
		tempActionType = null;
		memSDate = null;
		memEDate = null;
		memSNDate = null;
		memANDate = null;
		memENDate = null;
		memDeclined = false;
		allToolBarDisable = false;
		memBPBStatus = null;
		memRoom = null;
		memSavedValProc = null;
		memSavedValSDr = null;
		memSavedValRDr = null;
		memSavedValADr = null;
		memSavedValEDr = null;
		isContinueMultiBooking = false;
		isContinueOverlap = false;
		isContinueOverlapSDoc = false;
		isContinueOverlapADoc = false;
		isContinueOverlapEDoc = false;
		isContinueOverdueSDoc = false;
		isContinueOverdueADoc = false;
		isContinueOverdueEDoc = false;
		isContinueProPrivSDoc = false;
		isContinueProPrivEDoc = false;
		isContinueDuplicate = false;
		init = true;
		surgeonOverride = false;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
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

		getMainFrame().setLoading(true);
		initSetting();
		String OTABed = getSysParameter("OTABed");
		bMem_bIsEdit = YES_VALUE.equals(getParameter("otApp_bIsEdit"));
		otaBed = YES_VALUE.equals(OTABed);
		allToolBarDisable = false;

		isFlag = false;

		try {
			lotPBPID = Integer.parseInt(getParameter("lotPBPID"));	//
			resetParameter("lotPBPID");
		} catch (Exception e) {
			lotPBPID = 0;
		}

		setReloadSpecCboSql(getPrimaryProc(), true, null);
		setReloadSpecCboSql(getRoom(), true, null);
		setReloadSpecCboSql(getAnesMethod(), true, null);
		setReloadSpecCboSql(getSurgeon(), true, null);
		setReloadSpecCboSql(getSecSurgeon(), true, null);
		setReloadSpecCboSql(getAnesth(), true, null);
		setReloadSpecCboSql(getEndoscopist(), true, null);
		setReloadSpecCboSql(getReferDotor(), true, null);

		getRightButton_BudgetEst().removeStyleName("button-alert-green");

		if (!otaBed) {
			disableField(getPatCName());
			disableField(getPatMobNo());
			getARInfPanel().disable();
			getBookInfPanel().disable();
			getDeclinationPanel().disable();
		}

		isFrmAllergyLoaded = false;

		//--------------Start GetParameter---------------
		setActionType(getParameter("ActionType"));

		strOldPatNo = getParameter("patno");
		resetParameter("patno");
		if (strOldPatNo != null && strOldPatNo.length() > 0) {
			getPatNo().setText(strOldPatNo);
			fillPatDetail();
		}

		if (isAppend()) {
			getParaAction();
			if (lotPBPID > 0) {
				isFromPB = true;
				getPatNo().onBlur();
				disableField(getPatNo());
			}
		} else if (isModify()) {
			getParaAction();
		} else {
			getMainFrame().setLoading(false);
		}
	}

	private void initAfterReadyPost() {
		int newOtApp = 0;
		try {
			newOtApp = Integer.valueOf(getParameter("NEW_OT_APP"));
		} catch (Exception e) {}

		ComboBoxBase cbo = null;
		String cboValue = "";

		if (newOtApp == ConstantsGlobal.CBO_PROCEDURE) {
			cbo = getPrimaryProc();
			cboValue = getPrimaryProc().getText();
		} else if (newOtApp == ConstantsGlobal.CBO_SURGEON) {
			cbo = getSurgeon();
			cboValue = getSurgeon().getText();
		} else if (newOtApp == ConstantsGlobal.CBO_SURGEON) {
			cbo = getSecSurgeon();
			cboValue = getSecSurgeon().getText();
		} else if (newOtApp == ConstantsGlobal.CBO_ANESTHETIST) {
			cbo = getAnesth();
			cboValue = getAnesth().getText();
		}

		if (cbo != null) {
			if (isModify()) {
				cbo.setText(cboValue);
				setReloadSpecCboSql(cbo, false, cboValue);
			} else if (isAppend()) {
				cbo.resetText();
				setReloadSpecCboSql(cbo, true, null);
			}
		}

		showOverdueMsg(getSurgeon(), true, true);
		showOverdueMsg(getSecSurgeon(), true, true);
		showOverdueMsg(getAnesth(), true, true);
		showOverdueMsg(getEndoscopist(), true, true);

		if (isFrmAllergyLoaded) {
			SetCmdAllergy();
			isFrmAllergyLoaded = false;
		}

		if (!"".equals(memFestID) && memFestID != null) {
			getRightButton_BudgetEst().addStyleName("button-alert-green");
		} else {
			getRightButton_BudgetEst().removeStyleName("button-alert-green");
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

	private void SetCmdAllergy() {
		getAllergy().setToolTip(MSG_ALLERGY_DOWN);
		getAllergy().setStyleAttribute("color","#HFF0000");
		getAllergy().setStyleAttribute("font-weight","normal");
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
		memPatCName = mQueue.getContentField()[PATIENT_CHINESE_NAME];
		memPatFName = mQueue.getContentField()[PATIENT_FAMILY_NAME];
		memPatGName = mQueue.getContentField()[PATIENT_GIVEN_NAME];
		memDocNo = mQueue.getContentField()[PATIENT_ID_NO];
		memDOB = mQueue.getContentField()[PATIENT_DOB];
		memPhoneNo = mQueue.getContentField()[PATIENT_HOME_PHONE];
		memSex = mQueue.getContentField()[PATIENT_SEX];
		memMobileNo = mQueue.getContentField()[PATIENT_MOBILE_PHONE];

		getPatFName().setText(memPatFName);
		getPatGName().setText(memPatGName);
		getDocNo().setText(memDocNo);
		getDOB().setText(memDOB);
		getPhoneNo().setText(memPhoneNo);
		getSex().setText(memSex);

		if (otaBed) {
			getPatCName().setText(memPatCName);
			getPatMobNo().setText(memMobileNo);
		}
	}

	private void addDefaultRows() {
		if (getSecProcTable().getRowCount() == 0) {
			getSecProcTable().addRow(new Object[6]);
		}
	}

	private void getParaAction() {
		if (isAppend()) {
			if (lotPBPID > 0) {
				getPbDetail(String.valueOf(lotPBPID));

				getARInfPanel().disable();
				getBookInfPanel().disable();
				getDeclinationPanel().disable();
				getCancelWarning().setText("<b style='color:red;font-size:16px'>" + ConstantsMessage.MSG_NEW_OTAPP_LINK_PB + "</b>");
				getCancelWarning().setVisible(true);
			} else {
				initAfterReadyPost();
			}
			getFERequested().setText(NO_VALUE);
			getFEReceived().setText(NO_VALUE);
			getMainFrame().setLoading(false);

			if (getPatType().getStore().getCount() > 1) {
				getPatType().setSelectedIndex(1);
			}
			initAllSDT();
		} else if (isModify()) {
			lockRecord("OTAppointment", getParameter("otaid"));
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
			getOtaDetail(getParameter("otaid"));
		}
		Factory.getInstance().getMainFrame().setLoading(false);
	}

	private void txtPatNoEnable() {
		if (!(getPatFName().getText().equals(memPatFName) &&
					getPatGName().getText().equals(memPatGName) &&
					getDocNo().getText().equals(memDocNo) &&
					getPhoneNo().getText().equals(memPhoneNo) &&
					getDOB().getText().equals(memDOB))
				&&
			(getPatFName().getText().length() > 0 ||
					getPatGName().getText().length() > 0 ||
					getDocNo().getText().length() > 0 ||
					getPhoneNo().getText().length() > 0 ||
					getDOB().getText().length() > 0)) {
			disableField(getPatNo());
		} else {
			enableField(getPatNo());
		}

		if (lotPBPID > 0 && isFromPB) {
			disableField(getPatNo());
		}
	}

	private void enableField(Component comp) {
		PanelUtil.setAllFieldsReadOnly(comp, false, true);
	}

	private void disableField(Component comp) {
		PanelUtil.setAllFieldsReadOnly(comp, true, true);
	}

	private void initAllSDT() {
		String currentDateTimeWithoutSecond = getMainFrame().getServerDateTime();
		if (currentDateTimeWithoutSecond != null && currentDateTimeWithoutSecond.length() > 16) {
			currentDateTimeWithoutSecond = currentDateTimeWithoutSecond.substring(0, 16);
		}
		getStartDate().setText(currentDateTimeWithoutSecond);
		getEndDate().setText(currentDateTimeWithoutSecond);
		getSurNotify().setText(currentDateTimeWithoutSecond);
		getSecSurNotify().setText(currentDateTimeWithoutSecond);
		getAnesNotify().setText(currentDateTimeWithoutSecond);
		getEndNotify().setText(currentDateTimeWithoutSecond);
		getDOB().clear();

		if (getParameter("Slt_SDate")!=null &&!"".equals(getParameter("Slt_SDate"))) {
			getStartDate().setText(getParameter("Slt_SDate"));
		}
		if (getParameter("Slt_EDate")!=null &&!"".equals(getParameter("Slt_EDate"))) {
			getEndDate().setText(getParameter("Slt_EDate"));
		}
		//setCurRecordProperties();
	}

	public void getOtaDetail(final String otaid) {
		QueryUtil.executeMasterFetch(
				Factory.getInstance().getUserInfo(), "OTAPPBYNO", new String[] {otaid},
				new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							getFetchOutputValues(mQueue.getContentField());
							//initAfterReady2(otaid);
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
		memPatNo = outParam[0];
		memPatCName = outParam[28];
		memPatFName = outParam[1];
		memPatGName = outParam[2];
		memDocNo = outParam[26];
		memDOB = outParam[21];
		memPhoneNo = outParam[27];
		memSex = outParam[3];
		memMobileNo = outParam[29];

		getPatNo().setText(outParam[0]);
		getPatFName().setText(outParam[1]);
		getPatGName().setText(outParam[2]);
		getSex().setText(outParam[3]);
		getPatType().setText(outParam[4]);
		getStartDate().setText(outParam[5]);
		getEndDate().setText(outParam[6]);
		getRoom().setText(outParam[7]);
		getPrimaryProc().setText(outParam[8]);
		getReferDotor().setText(outParam[9]);
		getOTRmk().setText(outParam[10]);
		getDiagno().setText(outParam[11]);
		getSurgeon().setText(outParam[12]);
		getSurNotify().setText(outParam[13]);
		getAnesth().setText(outParam[14]);
		getAnesNotify().setText(outParam[15]);
		getAnesMethod().setText(outParam[16]);
		getEndoscopist().setText(outParam[17]);
		getEndNotify().setText(outParam[18]);
		getProcRmk().setText(outParam[19]);
		getDOB().setText(outParam[21]);
		getDocNo().setText(outParam[26]);
		getPhoneNo().setText(outParam[27]);
		getPatCName().setText(outParam[28]);
		getPatMobNo().setText(outParam[29]);
		getSecSurgeon().setText(outParam[30]);
		getSecSurNotify().setText(outParam[31]);
		getFERequested().setText(outParam[32]);
		getFEReceived().setText(outParam[33]);

		try {
			lotPBPID = Integer.parseInt(outParam[20]);
			getPbDetail(outParam[20]);
		} catch (Exception e) {
			lotPBPID = 0;
			initAfterReadyPost();
		}
		getOtaId().setText(getParameter("otaid"));

		// set mem fields
		memSDate = outParam[5];
		memEDate = outParam[6];
		memSNDate = outParam[13];
		memANDate = outParam[15];
		memENDate = outParam[18];
		memRoom = outParam[7];
		memSavedValProc = outParam[8];
		memSavedValSDr = outParam[12];
		memSavedValRDr = outParam[9];
		memSavedValADr = outParam[14];
		memSavedValEDr = outParam[17];

		getSecProcTable().setListTableContent(ConstantsTx.OTAPPPROC_TXCODE, new String[] {getParameter("otaid")});

		if (isModify()) {
			setReloadSpecCboSql(getRoom(), false, outParam[7]);
			setReloadSpecCboSql(getPrimaryProc(), false, outParam[8]);
			setReloadSpecCboSql(getSurgeon(), false, outParam[12]);
			setReloadSpecCboSql(getReferDotor(), false, outParam[9]);
			setReloadSpecCboSql(getAnesth(), false, outParam[14]);
			setReloadSpecCboSql(getEndoscopist(), false, outParam[17]);
			setReloadSpecCboSql(getAnesMethod(), false, outParam[16]);
			setReloadSpecCboSql(getSecSurgeon(), false, outParam[30]);
		}

		if (lotPBPID != 0) {
			memBPBStatus = outParam[22];
			if (ConstantsGlobal.PB_DELETE_STS.equals(outParam[22])) {
				getARInfPanel().disable();
				getBookInfPanel().disable();
				getDeclinationPanel().disable();
				getCancelWarning().setVisible(true);
			} else {
				getDeclined().setEditable(false);

				if (MINUS_ONE_VALUE.equals(outParam[23])) {
					oriRefuseStatus = MINUS_ONE_VALUE;
					getDeclined().setValue(true);
				} else {
					oriRefuseStatus = ZERO_VALUE;
					getDeclined().setValue(false);
				}

				getBy1().setText(outParam[24]);
				getActivateby1().setText(outParam[25]);
			}
		} else {
			disableField(getPatCName());
			disableField(getPatMobNo());
			getARInfPanel().disable();
			getBookInfPanel().disable();
			getDeclinationPanel().disable();
		}

		if (getPatNo().getText().length() == 0) {
			getPatFName().focus();
			txtPatNoEnable();
		}
	}

	protected void getFetchOutputValuesPbp(String[] outParam) {
		getSchdAdmDate().setText(outParam[1]);
		getOrderbyDoctor().setSelectedIndex(outParam[2]);
		getForDelivery().setValue(MINUS_ONE_VALUE.equals(outParam[3]));
		getMaincizen().setValue(MINUS_ONE_VALUE.equals(outParam[4]));
		getACM().setText(outParam[5]);
		getWard().setText(outParam[6]);
		getPBORmk().setText(outParam[7]);
		getCathLabRmk().setText(outParam[8]);
		getBpbOTRmk().setText(outParam[9]);
		getBedCode().setText(outParam[10]);
		getEstLenOfStay().setText(outParam[11]);

		getARCode().setText(outParam[12]);
		getPolicyNo().setText(outParam[13]);
		getCoPayType().setText(outParam[14]);
		getAmt().setText(outParam[15]);
		getVouNo().setText(outParam[16]);
		getInsCover().setText(outParam[17]);
		getInsLimitAmt().setText(outParam[18]);
		getDoctor().setValue(MINUS_ONE_VALUE.equals(outParam[19]));
		getSpecial().setValue(MINUS_ONE_VALUE.equals(outParam[20]));
		getHospital().setValue(MINUS_ONE_VALUE.equals(outParam[21]));
		getOther().setValue(MINUS_ONE_VALUE.equals(outParam[22]));

		getDeclined().setValue(MINUS_ONE_VALUE.equals(outParam[23]));
		memDeclined = MINUS_ONE_VALUE.equals(outParam[23]);
		getReason().setText(outParam[24]);
		getBy1().setText(outParam[25]);
		getBy2().setText(outParam[26]);
		getActivateby1().setText(outParam[27]);
		getActivateby2().setText(outParam[28]);

		if (isFromPB) {
			memPatNo = outParam[29];
			memPatCName = outParam[34];
			memPatFName = outParam[30];
			memPatGName = outParam[31];
			memDocNo = outParam[32];
			memDOB = outParam[36];
			memPhoneNo = outParam[33];
			memSex = outParam[37];
			memMobileNo = outParam[35];

			getPatNo().setText(outParam[29]);
			getPatFName().setText(outParam[30]);
			getPatGName().setText(outParam[31]);
			getDocNo().setText(outParam[32]);
			getPhoneNo().setText(outParam[33]);

			if (otaBed && isAppend()) {
				getPatCName().setText(outParam[34]);
				getPatMobNo().setText(outParam[35]);
			} else if (isModify()) {
				getPatCName().setText(outParam[34]);
				getPatMobNo().setText(outParam[35]);
			}
			getDOB().setText(outParam[36]);
			getSex().setText(outParam[37]);
		}
		getRightJCombo_Misc().setText(outParam[38]); //misc
		getRightJCombo_Source().setText(outParam[39]);
		getRightJText_SourceNo().setText(outParam[40]);
		getRightJCombo_Package().setText(outParam[41]);

		memFestID = outParam[42];
		getPJCheckBox_BE().setSelected("-1".equals(outParam[43]));
		getRightJCombo_Pkg().setText(outParam[44]);

		if (isAppend()) {
			if (lotPBPID > 0) {
				//getPatNo().onBlur();
			}
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
						getOtaId().getText(),
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
						getAnesMethod().getText(),
						getSurgeon().getText(),
						getAnesth().getText(),
						getSurNotify().getText(),
						getAnesNotify().getText(),
						getOTRmk().getText(),
						Factory.getInstance().getUserInfo().getUserID(),
						getSex().getText(),
						(isFromPB && lotPBPID > 0)?String.valueOf(lotPBPID):
													(otaBed?String.valueOf(lotPBPID):null),
						getPatType().getText(),
						getProcRmk().getText(),
						getDiagno().getText(),
						getEndoscopist().getText(),
						getEndNotify().getText(),
						getReferDotor().getText(),
						autoAdd?YES_VALUE:(otaBed?YES_VALUE:NO_VALUE),
						isFromPB?YES_VALUE:NO_VALUE,
						autoAdd?(getEndoscopist().isEmpty()?getSurgeon().getText():getEndoscopist().getText()):getOrderbyDoctor().getText(),
						autoAdd?getStartDate().getText():getSchdAdmDate().getText(),
						getPatCName().getText(),
						getACM().getText(),
						getWard().getText(),
						getPBORmk().getText(),
						getARCode().getText(),
						getCoPayType().getText(),
						getAmt().getText(),
						getPolicyNo().getText(),
						getInsLimitAmt().getText(),
						getInsCover().getText(),
						getDoctor().isSelected()?MINUS_ONE_VALUE:ZERO_VALUE,
						getSpecial().isSelected()?MINUS_ONE_VALUE:ZERO_VALUE,
						getHospital().isSelected()?MINUS_ONE_VALUE:ZERO_VALUE,
						getOther().isSelected()?MINUS_ONE_VALUE:ZERO_VALUE,
						getVouNo().getText(),
						getMaincizen().isSelected()?MINUS_ONE_VALUE:ZERO_VALUE,
						getForDelivery().isSelected()?MINUS_ONE_VALUE:ZERO_VALUE,
						getPatMobNo().getText(),
						getCathLabRmk().getText(),
						getBedCode().getText(),
						getDeclined().isSelected()?MINUS_ONE_VALUE:ZERO_VALUE,
						memDeclined != getDeclined().isSelected()?YES_VALUE:NO_VALUE,
						getReason().getText(),
						getBy1().getText(),
						getBy2().getText(),
						getActivateby1().getText(),
						getActivateby2().getText(),
						getEstLenOfStay().getText(),
						getBpbOTRmk().getText(),
						memSDate,
						memEDate,
						memRoom,
						memSavedValSDr,
						memSavedValADr,
						memSavedValEDr,
						isContinueMultiBooking?YES_VALUE:NO_VALUE,
						isContinueOverlap?YES_VALUE:NO_VALUE,
						isContinueOverlapSDoc?YES_VALUE:NO_VALUE,
						isContinueOverlapADoc?YES_VALUE:NO_VALUE,
						isContinueOverlapEDoc?YES_VALUE:NO_VALUE,
						isContinueOverdueSDoc?YES_VALUE:NO_VALUE,
						isContinueOverdueADoc?YES_VALUE:NO_VALUE,
						isContinueOverdueEDoc?YES_VALUE:NO_VALUE,
						isContinueProPrivSDoc?YES_VALUE:NO_VALUE,
						isContinueProPrivEDoc?YES_VALUE:NO_VALUE,
						isContinueDuplicate?YES_VALUE:NO_VALUE,
						getSecSurgeon().getText(),
						getSecSurNotify().getText(),
						getFERequested().getText(),
						getFEReceived().getText(),
						getRightJCombo_Misc().getText(), //misc
						getRightJCombo_Source().getText(),
						getRightJText_SourceNo().getText(),
						getRightJCombo_Package().getText(),
						getPJCheckBox_BE().isSelected()?MINUS_ONE_VALUE:ZERO_VALUE,
						getRightJCombo_Pkg().getText(),
						getSecProcTableData()
				};
	}

	/* >>> ~16.1~ Set Action Output Parameters =========================== <<< */
	@Override
	protected void getNewOutputValue(String returnValue) {}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void performAction(String actionType) {
		tempActionType = actionType;
		tempQActionType = getActionType();
		actionValidation(actionType);
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected void actionValidation(String actionType) {
		final String tmpActionType = actionType;		
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
		} else if (getSex().isEmpty()) {
			getTabbedPane().setSelectedIndexWithoutStateChange(0);
			Factory.getInstance().addErrorMessage("Sex is empty!", getSex());
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
		} else if (getSurgeon().isEmpty() && getEndoscopist().isEmpty()) {
			getTabbedPane().setSelectedIndexWithoutStateChange(0);
			Factory.getInstance().addErrorMessage("Surgeon/Endoscopist are empty!", getSurgeon());
			return;
		} else if (!surgeonOverride && !getSurgeon().isEmpty() && !getEndoscopist().isEmpty()) {
			getTabbedPane().setSelectedIndexWithoutStateChange(0);

			MessageBoxBase.confirm(MSG_PBA_SYSTEM, "Surgeon/Endoscopist are in conflict, Continue?",
					new Listener<MessageBoxEvent>() {
				@Override
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						surgeonOverride = true;
						actionValidation(tmpActionType);
					} else {
						return;
					}
				}
			});
			return;
		} else if (!getSurgeon().isEmpty() && !getSurgeon().isValid()) {
			getTabbedPane().setSelectedIndexWithoutStateChange(0);
			Factory.getInstance().addErrorMessage("Invalid surgeon!", getSurgeon());
			return;
		} else if (!getEndoscopist().isEmpty() && !getEndoscopist().isValid()) {
			getTabbedPane().setSelectedIndexWithoutStateChange(0);
			Factory.getInstance().addErrorMessage("Invalid endoscopist!", getEndoscopist());
			return;
		} else if (getAnesth().isEmpty()) {
			getTabbedPane().setSelectedIndexWithoutStateChange(0);
			Factory.getInstance().addErrorMessage("Anesthetist is empty!", getAnesth());
			return;
		} else if (!getAnesth().isValid()) {
			getTabbedPane().setSelectedIndexWithoutStateChange(0);
			Factory.getInstance().addErrorMessage("Invalid anesthetist!", getAnesth());
			return;
		} else if (getAnesMethod().isEmpty()) {
			getTabbedPane().setSelectedIndexWithoutStateChange(0);
			Factory.getInstance().addErrorMessage("Anes. Method is empty!", getAnesMethod());
			return;
		} else if (!getAnesMethod().isValid()) {
			getTabbedPane().setSelectedIndexWithoutStateChange(0);
			Factory.getInstance().addErrorMessage("Invalid anes. method!", getAnesMethod());
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
		} else if (!getInsCover().isEmpty() && !getInsCover().isValid()) {
			getTabbedPane().setSelectedIndexWithoutStateChange(1);
			Factory.getInstance().addErrorMessage("Invalid Date", getInsCover());
			return;
		}
		if (isModify() && (!getStartDate().getText().equals(memSDate) || !getEndDate().getText().equals(memEDate))) {
			if (ConstantsGlobal.PB_NORMAL_STS.equals(memBPBStatus)) {
				Factory.getInstance().addErrorMessage("OT Appointment modified, please change pre-booking information");
			}
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

		if (otaBed && !isFromPB) {
			if (getSchdAdmDate().isEmpty() && getOrderbyDoctor().isEmpty() && getACM().isEmpty() &&
					getWard().isEmpty() && 
					(TWAH_VALUE.equals(getUserInfo().getSiteCode()) || 
							(HKAH_VALUE.equals(getUserInfo().getSiteCode()) && !"D".equals(getPatType().getText())))) {
				MessageBoxBase.confirm(MSG_PBA_SYSTEM, "There will be no Bed Pre-Booking added, Continue?",
						new Listener<MessageBoxEvent>() {
					@Override
					public void handleEvent(MessageBoxEvent be) {
						if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
							if("D".equals(getPatType().getText()) && HKAH_VALUE.equals(getUserInfo().getSiteCode())){
								autoAdd = true;								
								actionValidationReady(tmpActionType, true);								
							}else{
								otaBed = false;
								actionValidationReady(tmpActionType, true);								
							}
						} else {
							return;
						}
					}
				});
				return;
			} else {
				if(("D".equals(getPatType().getText()) && "SaveAction".equals(actionType)) && HKAH_VALUE.equals(getUserInfo().getSiteCode())){
					autoAdd = true;
				}else{
					if (getSchdAdmDate().isEmpty()) {
						getTabbedPane().setSelectedIndexWithoutStateChange(1);
						Factory.getInstance().addErrorMessage("Sche Adm Date is empty!", getSchdAdmDate());
						return;
					} else if (!getSchdAdmDate().isValid()) {
						getTabbedPane().setSelectedIndexWithoutStateChange(1);
						Factory.getInstance().addErrorMessage("Invalid Sche Adm Date!", getSchdAdmDate());
						return;
					} else if (getOrderbyDoctor().isEmpty()) {
						getTabbedPane().setSelectedIndexWithoutStateChange(1);
						Factory.getInstance().addErrorMessage("Order by Doctor is empty!", getOrderbyDoctor());
						return;
					} else if (!getOrderbyDoctor().isValid()) {
						getTabbedPane().setSelectedIndexWithoutStateChange(1);
						Factory.getInstance().addErrorMessage("Invalid Order by Doctor!", getOrderbyDoctor());
						return;
					} else if (getACM().isEmpty()) {
						getTabbedPane().setSelectedIndexWithoutStateChange(1);
						Factory.getInstance().addErrorMessage("Accommdation Code is empty!", getACM());
						return;
					} else if (!getACM().isValid()) {
						getTabbedPane().setSelectedIndexWithoutStateChange(1);
						Factory.getInstance().addErrorMessage("Invalid Accommdation Code!", getACM());
						return;
					} else if (getWard().isEmpty()) {
						getTabbedPane().setSelectedIndexWithoutStateChange(1);
						Factory.getInstance().addErrorMessage("Ward Code is empty!", getWard());
						return;
					} else if (!getWard().isValid()) {
						getTabbedPane().setSelectedIndexWithoutStateChange(1);
						Factory.getInstance().addErrorMessage("Invalid Ward Code!", getWard());
						return;
					} else if (getDeclined().isSelected()) {
						if (getReason().isEmpty()) {
							getTabbedPane().setSelectedIndexWithoutStateChange(1);
							Factory.getInstance().addErrorMessage("Declined Reason is empty!", getReason());
							return;
						}
					} else if (getBedCode().isEmpty() && getSysParameter("BEDCDEMUST").equals(YES_VALUE)) {
						getTabbedPane().setSelectedIndexWithoutStateChange(1);
						Factory.getInstance().addErrorMessage("Please Input Bed Code!", getBedCode());
						return;
					} else if (!getBedCode().isEmpty() && !getBedCode().isValid()) {
						getTabbedPane().setSelectedIndexWithoutStateChange(1);
						Factory.getInstance().addErrorMessage(MSG_WRONG_BEDCODE, getBedCode());
						return;
					} else if (!getEstLenOfStay().isEmpty() &&
							!TextUtil.isInteger(getEstLenOfStay().getText().toString())) {
						getTabbedPane().setSelectedIndexWithoutStateChange(1);
						Factory.getInstance().addErrorMessage("Please input Integer.", getEstLenOfStay());
						return;
					} else if (getEstLenOfStay().isEmpty() && getSysParameter("ESTLENMUST").equals(YES_VALUE)) {
						getTabbedPane().setSelectedIndexWithoutStateChange(1);
						Factory.getInstance().addErrorMessage("Please input estimated length of stay!", getEstLenOfStay());
						return;
					} else if (!getEstLenOfStay().isEmpty()) {
						try {
							int lenOfStay = Integer.parseInt(getEstLenOfStay().getText().trim());
							if (lenOfStay <= 0) {
								getTabbedPane().setSelectedIndexWithoutStateChange(1);
								if (getSysParameter("ESTLENMUST").equals(YES_VALUE)) {
									Factory.getInstance().addErrorMessage("Estimated Length of Stay should be > 0", getEstLenOfStay());
								} else {
									Factory.getInstance().addErrorMessage("Estimated Length of Stay should be > 0 or null", getEstLenOfStay());
								}
								return;
							}
						} catch (Exception e) {
							getTabbedPane().setSelectedIndexWithoutStateChange(1);
							Factory.getInstance().addErrorMessage("Invalid estimated length of stay!", getEstLenOfStay());
							return;
						}
					}					
				}
			}
		}
		actionValidationReady(actionType, true);
	}

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
						String header = "";
						String sFuncName = "OT Appointment";
						String sFuncName_BPB = "OT Appointment -> Bed Pre-Book";
						String patno = getPatNo().getText();
						String itemContent =
							"\tPatient No. :\t\t" + getPatNo().getText() + "<br />" +
							"\tPatient Name:\t\t" + getPatFName().getText() + " " + getPatGName().getText() + "<br />" +
							"\tSex:\t\t" + getSex().getDisplayText() + "<br />" +
							"\tSch Adm Date:\t\t" + getSchdAdmDate().getText() + "<br />" +
							"\tSch OT Date:\t\t" + getStartDate().getText() + "<br />" +
							"\tWard Code:\t\t" + getWard().getDisplayText() + "<br />" +
							"\tACM Code:\t\t" + getACM().getDisplayText() + "<br />" +
							"\tProcedure:\t\t" + getPrimaryProc().getDisplayText() + "<br />" +
							"\tSurgeon/Endoscopist:\t" + (!getSurgeon().isEmpty() ? getSurgeon().getDisplayText() : getEndoscopist().getDisplayText()) + "<br />" +
							"\tType of Anesthesia:\t" + getAnesMethod().getDisplayText() + "<br />" +
							"\tAnesthetist Name:\t" + getAnesth().getDisplayText() + "<br />";

						if (isAppend()) {
							lotPBPID = 0;
							if (otaBed) {
								header +=
									"Bookings for admission and Operating Room are saved successfully<br /><br />" +
									"NEW<br />" +
									"===<br />" +
									"Please be informed that new appointment has been make under Operating Room. Please check.<br /><br />";
								sFuncName += " -> New";
								sFuncName_BPB += " -> New";

								Factory.getInstance().addErrorMessage(header + itemContent,
										new Listener<MessageBoxEvent>() {
									@Override
									public void handleEvent(MessageBoxEvent be) {
										setActionType(null);
										exitPanel();
									}
								});
							}
						} else if (isModify()) {
							if (otaBed) {
								header +=
									"Bookings for admission and Operating Room are changed successfully<br /><br />" +
									"CHANGED<br />" +
									"=======<br />" +
									"Please be informed that appointment under Operating Room is changed. Please check.<br /><br />";
								sFuncName += " -> Edit";
								sFuncName_BPB += " -> Edit";

								Factory.getInstance().addErrorMessage(header + itemContent,
										new Listener<MessageBoxEvent>() {
									@Override
									public void handleEvent(MessageBoxEvent be) {
										setActionType(null);
										exitPanel();
									}
								});
							}
						}

						Map<String, String> params = new HashMap<String, String>();
						params.put("Room", getRoom().getText());
						params.put("App Start Date", getStartDate().getText());
						params.put("App End Date", getEndDate().getText());
						if (!getSurgeon().isEmpty()) {
							params.put("Surgeon", getSurgeon().getText());
						}
						if (!getEndoscopist().isEmpty()) {
							params.put("Endoscopist", getEndoscopist().getText());
						}
						params.put("Anesthetist", getAnesth().getText());
						getAlertCheck().checkAltAccess(patno, sFuncName, false, true, params);

						if (!getSchdAdmDate().isEmpty()) {
							params.clear();
							params.put("Ward", getWard().getText());
							params.put("Order By Doctor", getOrderbyDoctor().getText());
							params.put("Schd Adm Date", getSchdAdmDate().getText());
							getAlertCheck().checkAltAccess(patno, sFuncName_BPB, false, true, params);
						}

						if (!otaBed) {
							setActionType(null);
							exitPanel();
						}
					} else if (mQueue.getReturnCode().equals("-100")) {
						// warn multi ot booking
						Factory.getInstance().isConfirmYesNoDialog("Confirm",
								mQueue.getReturnMsg(),
								new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equals(be.getButtonClicked().getItemId())) {
									isContinueMultiBooking = true;
									actionValidationReady(null, true);
								} else {
									isContinueMultiBooking = false;
								}
							}
						});
					} else if (mQueue.getReturnCode().equals("-200")) {
						// overlap period
						MessageBoxBase.confirm("Confirm",
								MSG_OVERLAP_APP_PERIOD,
								new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									isContinueOverlap = true;
									actionValidationReady(null, true);
								} else {
									isContinueOverlap = false;
									getTabbedPane().setSelectedIndexWithoutStateChange(0);
								}
							}
						});
					} else if (mQueue.getReturnCode().equals("-300") ||
								mQueue.getReturnCode().equals("-310") ||
								mQueue.getReturnCode().equals("-320")) {
						// show overlap msg
						String docText = "";
						if (mQueue.getReturnCode().equals("-300")) {
							docText = getSurgeon().getDisplayText();
						} else if (mQueue.getReturnCode().equals("-310")) {
							docText = getAnesth().getDisplayText();
						} else if (mQueue.getReturnCode().equals("-320")) {
							docText = getEndoscopist().getDisplayText();
						}

						MessageBoxBase.confirm("Confirm",
								docText+" "+MSG_OVERLAP_APP_PERIOD,
								new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									if (mQueue.getReturnCode().equals("-300")) {
										isContinueOverlapSDoc = true;
									} else if (mQueue.getReturnCode().equals("-310")) {
										isContinueOverlapADoc = true;
									} else if (mQueue.getReturnCode().equals("-320")) {
										isContinueOverlapEDoc = true;
									}
									actionValidationReady(null, true);
								} else {
									getTabbedPane().setSelectedIndexWithoutStateChange(0);
									if (mQueue.getReturnCode().equals("-300")) {
										isContinueOverlapSDoc = false;
										getSurgeon().focus();
									} else if (mQueue.getReturnCode().equals("-310")) {
										isContinueOverlapADoc = false;
										getAnesth().focus();
									} else if (mQueue.getReturnCode().equals("-320")) {
										isContinueOverlapEDoc = false;
										getEndoscopist().focus();
									}
								}
							}
						});
					} else if (mQueue.getReturnCode().equals("-410") ||
								mQueue.getReturnCode().equals("-420") ||
								mQueue.getReturnCode().equals("-430")) {
						// show overdue msg
						Factory.getInstance().addInformationMessage(
								"Inactive doctor is selected",
								new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								if (mQueue.getReturnCode().equals("410")) {
									isContinueOverdueSDoc = true;
								} else if (mQueue.getReturnCode().equals("420")) {
									isContinueOverdueADoc = true;
								} else if (mQueue.getReturnCode().equals("430")) {
									isContinueOverdueEDoc = true;
								}
								actionValidationReady(null, true);
							}
						});
					} else if (mQueue.getReturnCode().equals("-400") ||
								mQueue.getReturnCode().equals("-402") ||
								mQueue.getReturnCode().equals("-404")) {
						// show overdue msg
						Factory.getInstance().addInformationMessage(
								"Inactive doctor is selected, his/her admission expiry date is "+mQueue.getReturnMsg());

						String docCodeValue = null;
						if (mQueue.getReturnCode().equals("-400")) {
							docCodeValue = getSurgeon().getDisplayText();
						} else if (mQueue.getReturnCode().equals("-402")) {
							docCodeValue = getAnesth().getDisplayText();
						} else if (mQueue.getReturnCode().equals("-404")) {
							docCodeValue = getEndoscopist().getDisplayText();
						}

						MessageBoxBase.confirm("Confirm",
								docCodeValue+" "+MSG_DOC_TERMINATION,
								new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									if (mQueue.getReturnCode().equals("-400")) {
										isContinueOverdueSDoc = true;
									} else if (mQueue.getReturnCode().equals("-402")) {
										isContinueOverdueADoc = true;
									} else if (mQueue.getReturnCode().equals("-404")) {
										isContinueOverdueEDoc = true;
									}
									actionValidationReady(null, true);
								} else {
									getTabbedPane().setSelectedIndexWithoutStateChange(0);
									if (mQueue.getReturnCode().equals("-400")) {
										isContinueOverdueSDoc = false;
										getSurgeon().focus();
									} else if (mQueue.getReturnCode().equals("-402")) {
										isContinueOverdueADoc = false;
										getAnesth().focus();
									} else if (mQueue.getReturnCode().equals("-404")) {
										isContinueOverdueEDoc = false;
										getEndoscopist().focus();
									}
								}
							}
						});
					} else if (mQueue.getReturnCode().equals("-401") ||
								mQueue.getReturnCode().equals("-403") ||
								mQueue.getReturnCode().equals("-405")) {
						// show overdue msg
						String docCodeValue = null;
						if (mQueue.getReturnCode().equals("-401")) {
							docCodeValue = getSurgeon().getDisplayText();
						} else if (mQueue.getReturnCode().equals("-403")) {
							docCodeValue = getAnesth().getDisplayText();
						} else if (mQueue.getReturnCode().equals("-405")) {
							docCodeValue = getEndoscopist().getDisplayText();
						}

						MessageBoxBase.confirm("Confirm",
								docCodeValue+" "+MSG_DOC_TERMINATION,
								new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									if (mQueue.getReturnCode().equals("-401")) {
										isContinueOverdueSDoc = true;
									} else if (mQueue.getReturnCode().equals("-403")) {
										isContinueOverdueADoc = true;
									} else if (mQueue.getReturnCode().equals("-405")) {
										isContinueOverdueEDoc = true;
									}
									actionValidationReady(null, true);
								} else {
									getTabbedPane().setSelectedIndexWithoutStateChange(0);
									if (mQueue.getReturnCode().equals("-401")) {
										isContinueOverdueSDoc = false;
										getSurgeon().focus();
									} else if (mQueue.getReturnCode().equals("-403")) {
										isContinueOverdueADoc = false;
										getAnesth().focus();
									} else if (mQueue.getReturnCode().equals("-405")) {
										isContinueOverdueEDoc = false;
										getEndoscopist().focus();
									}
								}
							}
						});
					} else if (mQueue.getReturnCode().equals("-500") ||
								mQueue.getReturnCode().equals("-501")) {
						// show overdue msg
						String docCodeValue = null;
						if (mQueue.getReturnCode().equals("-500")) {
							docCodeValue = getSurgeon().getDisplayText();
						} else if (mQueue.getReturnCode().equals("-501")) {
							docCodeValue = getEndoscopist().getDisplayText();
						}

						MessageBoxBase.confirm("Confirm",
								docCodeValue+" has no privilege for <br/>"+getPrimaryProc().getText()+
								"<br/>are you sure to continue?",
								new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									if (mQueue.getReturnCode().equals("-500")) {
										isContinueProPrivSDoc = true;
									} else if (mQueue.getReturnCode().equals("-501")) {
										isContinueProPrivEDoc = true;
									}
									actionValidationReady(null, true);
								} else {
									getTabbedPane().setSelectedIndexWithoutStateChange(0);
									if (mQueue.getReturnCode().equals("-500")) {
										isContinueProPrivSDoc = false;
									} else if (mQueue.getReturnCode().equals("-501")) {
										isContinueProPrivEDoc = false;
									}
								}
							}
						});
					} else if (mQueue.getReturnCode().equals("-600")) {
						//Duplicate Pre-Booking
						getDuplicateDialog().showDialog(
								getActionType(),
								getPatNo().getText(),
								getDocNo().getText(),
								getPatFName().getText(),
								getPatGName().getText()
							);
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
		getSaveButton().setEnabled((isAppend() || isModify() || memDeclined != getDeclined().isSelected()) && !allToolBarDisable);
		getClearButton().setEnabled(getOTAPPPanel().isEnabled() && !allToolBarDisable);
		if (lotPBPID > 0 && isFromPB) {
			getClearButton().setEnabled(false);
		}
		getRightButton_BudgetEst().setEnabled(lotPBPID > 0);

		if (isModify()) {
			addDefaultRows();
		}

	}

	@Override
	protected void proExitPanel() {
		// for child class call
		if (getParameter("otaid") != null) {
			unlockRecord("OTAppointment", getParameter("otaid"));
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
		getSurgeon().resetText();
		getSurgeon().clear();
		getAnesth().resetText();
		getAnesth().clear();
		getEndoscopist().resetText();
		getEndoscopist().clear();
		getProcRmk().resetText();
		getDiagno().resetText();
		getPatType().resetText();
		getPatType().clear();
		getAnesMethod().resetText();
		getAnesMethod().clear();
		getOtaId().resetText();
		getAnesExpDateDesc().resetText();
		getSurExpDateDesc().resetText();
		getSecSurExpDateDesc().resetText();
		getEndExpDateDesc().resetText();

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

	private DlgBedPreBookDupl getDuplicateDialog() {
		if (duplicateDialog == null) {
			duplicateDialog = new DlgBedPreBookDupl(getMainFrame()) {
				@Override
				public void continueAction() {
					isContinueDuplicate = true;
				}
			};
		}
		return duplicateDialog;
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	private String getSecProcTableData() {
		StringBuffer data = new StringBuffer();
		for (int i = 0; i < getSecProcTable().getRowCount(); i++) {
			if (getSecProcTable().getValueAt(i, 3) != null && !getSecProcTable().getValueAt(i, 3).equals(SPACE_VALUE)) {
				if (i > 0) {
					data.append(",");
				}
				data.append(getSecProcTable().getValueAt(i, 3));
			}
		}
		return data.toString();
	}

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
						String labelDesc = null;
						String warnMsg = null;

						if (docCtdate != null && docCtdate.length() > 0) {
							labelDesc = "Admission Expiry Date: " + docCtdate;
							if (getSurgeon().equals(docCombo)) {
								getSurExpDateDesc().setText(labelDesc);
							} else if (getSecSurgeon().equals(docCombo)) {
								getSecSurExpDateDesc().setText(labelDesc);
							} else if (getAnesth().equals(docCombo)) {
								getAnesExpDateDesc().setText(labelDesc);
							} else if (getEndoscopist().equals(docCombo)) {
								getEndExpDateDesc().setText(labelDesc);
							}
						} else {
							if (getSurgeon().equals(docCombo)) {
								getSurExpDateDesc().resetText();
							} else if (getSecSurgeon().equals(docCombo)) {
								getSecSurExpDateDesc().resetText();
							} else if (getAnesth().equals(docCombo)) {
								getAnesExpDateDesc().resetText();
							} else if (getEndoscopist().equals(docCombo)) {
								getEndExpDateDesc().resetText();
							}
						}

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
							String otaDate = null;

							if (startDate.isEmpty() || endDate.isEmpty() || doccode == null || doccode.length() <= 0) {
								return;
							}

							otaDate = startDate;
							boolean isOrderbyDoctor = getOrderbyDoctor().equals(docCombo);
							if (isOrderbyDoctor) {
								otaDate = getSchdAdmDate().getText();
							}

							try {
								if (docCtdate != null && docCtdate.length() > 0 && otaDate != null &&
										!otaDate.isEmpty() &&
										DateTimeUtil.dateDiff(otaDate.substring(0, 10), docCtdate) > 0) {
									if (iStyle) {
										if (isOrderbyDoctor) {
											MessageBoxBase.addWarningMessage("Doctor expired", docCombo.getDisplayText() + " admission date > expiry date", null);
											//ShowMessage Me, drCode.Value(1) & " admission date > expiry date", vbExclamation + vbOKOnly
										} else {
											MessageBoxBase.addWarningMessage("Doctor expired", docCombo.getDisplayText() + " surgery date > admission expiry date", null);
											//ShowMessage Me, drCode.Value(1) & MSG_DOC_TERMINATION_OKONLY, vbExclamation + vbOKOnly
										}
										docCombo.focus();
									} else {
										String tmpMsg = null;
										if (isOrderbyDoctor) {
											tmpMsg = " admission date > expiry date, continue to save?";
										} else {
											tmpMsg = ConstantsMessage.MSG_DOC_TERMINATION;
										}
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
									if (otaDate == null || otaDate.isEmpty()) {
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

	private void showOverlapMsg(final ComboBoxBase docCombo, final boolean iStyle) {
		String startDate = getStartDate().getText();
		String endDate = getEndDate().getText();
		final String docCode = docCombo != null ? docCombo.getText() : null;

		if (!startDate.isEmpty() && !endDate.isEmpty() && docCode != null && !docCode.isEmpty()) {
			boolean isSur = false;
			boolean isAnes = false;
			boolean isEnd = false;
			if (getSurgeon().equals(docCombo)) {
				isSur = true;
			} else if (getAnesth().equals(docCombo)) {
				isAnes = true;
			} else if (getEndoscopist().equals(docCombo)) {
				isEnd = true;
			}
			final String memSavedValDr = isSur ? memSavedValSDr : (isAnes ? memSavedValADr : (isEnd ? memSavedValEDr : null));

			String criteria = null;
			if (isSur || isEnd) {
				criteria =
					"( otaOSDate < to_date('" + startDate + "', 'dd/mm/yyyy hh24:mi') OR otaOSDate < to_date('" + endDate + "', 'dd/mm/yyyy hh24:mi')) " +
					" AND ( otaOEDate > to_date('" + startDate + "', 'dd/mm/yyyy hh24:mi') OR otaOEDate > to_date('" + endDate + "', 'dd/mm/yyyy hh24:mi')) " +
					" and (doccode_s = '" + docCode + "'" +
					"      or doccode_e = '" + docCode + "')" +
					" and otasts <> '" + OTAppointmentBrowse.OT_APPSTS_C + "'";
			} else if (isAnes) {
				criteria =
					"( otaOSDate < to_date('" + startDate + "', 'dd/mm/yyyy hh24:mi') OR otaOSDate < to_date('" + endDate + "', 'dd/mm/yyyy hh24:mi')) " +
					" AND ( otaOEDate > to_date('" + startDate + "', 'dd/mm/yyyy hh24:mi') OR otaOEDate > to_date('" + endDate + "', 'dd/mm/yyyy hh24:mi')) " +
					" and doccode_a = '" + docCode + "'" +
					" and otasts <> '" + OTAppointmentBrowse.OT_APPSTS_C + "'";
			} else {
				criteria = "1=2";
			}

			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] {"ot_app", "otaid", criteria},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						boolean isOverlapped = false;
						if (isAppend()) {
							if (mQueue.getContentLineCount() > 0) {
								isOverlapped = true;
							}
						} else if (isModify()) {
							if (!(mQueue.getContentLineCount() == 0 ||
									(mQueue.getContentLineCount() == 1 && docCode.equals(memSavedValDr)))) {
								isOverlapped = true;
							}
						}

						//System.out.println("(showOverlapMsg) docCode"+docCode + ", otaid="+otaid + ", memSavedValDr="+memSavedValDr + ", isOverlapped="+isOverlapped);
						if (isOverlapped) {
							if (iStyle) {
								Factory.getInstance().addErrorMessage(docCombo.getDisplayText() + " Appointment period is overlapped!");
								docCombo.focus();
							} else {
								Factory.getInstance().isConfirmYesNoDialog(docCombo.getDisplayText() + " " + ConstantsMessage.MSG_OVERLAP_APP_PERIOD, new Listener<MessageBoxEvent>() {
									@Override
									public void handleEvent(MessageBoxEvent be) {
										if (Dialog.YES.equals(be.getButtonClicked().getItemId())) {
											//showOverlapMsgPostAction(docCombo, false);
										} else {
											//showOverlapMsgPostAction(docCombo, true);
											docCombo.focus();
										}
									}
								});
							}
						} else {
							//showOverlapMsgPostAction(docCombo, false);
						}
					} else {
						//showOverlapMsgPostAction(docCombo, false);
					}
				}

				@Override
				public void onFailure(Throwable caught) {
					//showOverlapMsgPostAction(docCombo, false);
				}
			});
		} else {
			//showOverlapMsgPostAction(docCombo, false);
		}
	}

	private void setReloadSpecCboSql(ComboBoxBase cbo, boolean activeOnly, String savedKeyValue) {
		if (cbo == getRoom()) {
			getRoom().removeAllItems();
			if (activeOnly) {
				getRoom().refreshContent(new String[] {null, null, YES_VALUE});
			} else {
				getRoom().refreshContent(new String[] {NO_VALUE, savedKeyValue, YES_VALUE});
			}
		} else if (cbo == getPrimaryProc()) {
			getPrimaryProc().removeAllItems();
			if (activeOnly) {
				getPrimaryProc().refreshContent(new String[] {null, null, YES_VALUE});
			} else {
				getPrimaryProc().refreshContent(new String[] {NO_VALUE, savedKeyValue, YES_VALUE});
			}
		} else if (cbo == getReferDotor()) {
			getReferDotor().removeAllItems();
			if (activeOnly) {
				getReferDotor().refreshContent(new String[] {null, null});
			} else {
				getReferDotor().refreshContent(new String[] {NO_VALUE, savedKeyValue});
			}
		} else if (cbo == getSurgeon()) {
			getSurgeon().removeAllItems();
			if (activeOnly) {
				getSurgeon().refreshContent(new String[] {null, null});
			} else {
				getSurgeon().refreshContent(new String[] {NO_VALUE, savedKeyValue});
			}
		} else if (cbo == getSecSurgeon()) {
			getSecSurgeon().removeAllItems();
			if (activeOnly) {
				getSecSurgeon().refreshContent(new String[] {null, null});
			} else {
				getSecSurgeon().refreshContent(new String[] {NO_VALUE, savedKeyValue});
			}
		} else if (cbo == getAnesth()) {
			getAnesth().removeAllItems();
			if (activeOnly) {
				getAnesth().refreshContent(new String[] {null, null});
			} else {
				getAnesth().refreshContent(new String[] {NO_VALUE, savedKeyValue});
			}
		} else if (cbo == getEndoscopist()) {
			getEndoscopist().removeAllItems();
			if (activeOnly) {
				getEndoscopist().refreshContent(new String[] {null, null});
			} else {
				getEndoscopist().refreshContent(new String[] {NO_VALUE, savedKeyValue});
			}
		} else if (cbo == getAnesMethod()) {
			getAnesMethod().removeAllItems();
			if (activeOnly) {
				getAnesMethod().refreshContent(new String[] {null, null});
			} else {
				getAnesMethod().refreshContent(new String[] {NO_VALUE, savedKeyValue});
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
			TabbedPane.addTab("OT APP", getOTAPPPanel());
			TabbedPane.addTab("Bed Pre-Book", getBedBookPanel());
//			TabbedPane.addTab("General View", getGVPanel());
//			TabbedPane.setSelectedIndex(1);
		}
		return TabbedPane;
	}
	public BasePanel getOTAPPPanel() {
		if (OTAPPPanel == null) {
			OTAPPPanel = new BasePanel();
			OTAPPPanel.setBounds(10, 10, 800, 510);
			OTAPPPanel.add(getPatNoDesc(), null);
			OTAPPPanel.add(getPatNo(), null);
			OTAPPPanel.add(getOtaId(), null);
			OTAPPPanel.add(getPatCNameDesc(), null);
			OTAPPPanel.add(getPatCName(), null);
			OTAPPPanel.add(getPatFNameDesc(), null);
			OTAPPPanel.add(getPatFName(), null);
			OTAPPPanel.add(getPatGNameDesc(), null);
			OTAPPPanel.add(getPatGName(), null);
			OTAPPPanel.add(getDocNoDesc(), null);
			OTAPPPanel.add(getDocNo(), null);
			OTAPPPanel.add(getDOBDesc(), null);
			OTAPPPanel.add(getDOB(), null);
			OTAPPPanel.add(getPhoneNoDesc(), null);
			OTAPPPanel.add(getPhoneNo(), null);
			OTAPPPanel.add(getSexDesc(), null);
			OTAPPPanel.add(getSex(), null);
			OTAPPPanel.add(getAllergy(), null);
			OTAPPPanel.add(getPatMobNoDesc(), null);
			OTAPPPanel.add(getPatMobNo(), null);
			OTAPPPanel.add(getPatTypeDesc(), null);
			OTAPPPanel.add(getPatType(), null);
			OTAPPPanel.add(getStartDateDesc(), null);
			OTAPPPanel.add(getStartDate(), null);
			OTAPPPanel.add(getEndDateDesc(), null);
			OTAPPPanel.add(getEndDate(), null);
			OTAPPPanel.add(getRoomDesc(), null);
			OTAPPPanel.add(getRoom(), null);
			OTAPPPanel.add(getPrimaryProcDesc(), null);
			OTAPPPanel.add(getPrimaryProc(), null);
			OTAPPPanel.add(getPrimaryProcSearch(), null);
			OTAPPPanel.add(getReferDotorDesc(), null);
			OTAPPPanel.add(getReferDotor(), null);
			OTAPPPanel.add(getProcRmkDesc(), null);
			OTAPPPanel.add(getProcRmk(), null);
			OTAPPPanel.add(getDiagnoDesc(), null);
			OTAPPPanel.add(getDiagno(), null);
			OTAPPPanel.add(getSurgeonDesc(), null);
			OTAPPPanel.add(getSurgeon(), null);
			OTAPPPanel.add(getSurNotifyDesc(), null);
			OTAPPPanel.add(getSurNotify(), null);
			OTAPPPanel.add(getSecSurgeonDesc(), null);
			OTAPPPanel.add(getSecSurgeon(), null);
			OTAPPPanel.add(getSecSurNotifyDesc(), null);
			OTAPPPanel.add(getSecSurNotify(), null);
			OTAPPPanel.add(getAnesthDesc(), null);
			OTAPPPanel.add(getAnesth(), null);
			OTAPPPanel.add(getAnesNotify(), null);
			OTAPPPanel.add(getAnesMethodDesc(), null);
			OTAPPPanel.add(getAnesMethod(), null);
			OTAPPPanel.add(getEndoscopistDesc(), null);
			OTAPPPanel.add(getEndoscopist(), null);
			OTAPPPanel.add(getEndNotifyDesc(), null);
			OTAPPPanel.add(getEndNotify(), null);
			OTAPPPanel.add(getOTRmkDesc(), null);
			OTAPPPanel.add(getOTRmk(), null);
			OTAPPPanel.add(getAnesNotifyDesc(), null);
			OTAPPPanel.add(getSurExpDateDesc(), null);
			OTAPPPanel.add(getSecSurExpDateDesc(), null);
			OTAPPPanel.add(getAnesExpDateDesc(), null);
			OTAPPPanel.add(getEndExpDateDesc(), null);
			OTAPPPanel.add(getProcPanel(), null);
			OTAPPPanel.add(getFERequestedDesc(), null);
			OTAPPPanel.add(getFERequested(), null);
			OTAPPPanel.add(getFEReceivedDesc(), null);
			OTAPPPanel.add(getFEReceived(), null);
		}
		return OTAPPPanel;
	}

	public LabelBase getPatNoDesc() {
		if (PatNoDesc == null) {
			PatNoDesc = new LabelBase();
			PatNoDesc.setText("Patient No");
			PatNoDesc.setBounds(10, 0, 106, 20);
		}
		return PatNoDesc;
	}

	@SuppressWarnings("unchecked")
	public TextPatientNoSearch getPatNo() {
		if (PatNo == null) {
			PatNo = new TextPatientNoSearch() {
				@Override
				protected void checkDeathPatientDialogYes(MessageQueue chkDeath) {
					if (init) {
						return;
					}

					// fields value already set in FillPatDetail
					fillPatDetail(chkDeath);

					String curPatNo = getText().trim();
					if (curPatNo.length() > 0 && !curPatNo.equals(strOldPatNo)) {
						getAlertCheck().checkAltAccess(curPatNo, "OT Appointment", true, false, null);
						strOldPatNo = curPatNo;
					}
				}

				@Override
				protected void checkDeathPatientDialogNo() {
					if (!init && !bMem_bIsEdit) {
						getPatFName().resetText();
						getPatGName().resetText();
						getDocNo().resetText();
						getPhoneNo().resetText();
						initAllSDT();
						getRoom().resetText();
						getPrimaryProc().resetText();
						getSurgeon().resetText();
						getAnesth().resetText();
						getProcRmk().resetText();
						getDiagno().resetText();
						getPatType().resetText();
						getEndoscopist().resetText();
						getAnesMethod().resetText();
						getSex().resetText();
						getPatNo().focus();
						strOldPatNo = null;
					}
				}

				@Override
				public void onPressed() {
					if (getPatNo().getText().length() > 0) {
						getPatFName().resetText();
						getPatGName().resetText();
						getPatCName().resetText();
						getPatMobNo().resetText();
						getPhoneNo().resetText();
						getDocNo().resetText();
						getDOB().resetText();
						getSex().resetText();
						getSex().clear();
						strOldPatNo = null;

						disableField(getPatFName());
						disableField(getPatGName());
						disableField(getPatCName());
						disableField(getPatMobNo());
						disableField(getPhoneNo());
						disableField(getDOB());
						disableField(getSex());
						disableField(getDocNo());
					} else {
						enableField(getPatFName());
						enableField(getPatGName());

						if (otaBed) {
							enableField(getPatCName());
							enableField(getPatMobNo());
						}

						enableField(getPhoneNo());
						enableField(getDOB());
						enableField(getSex());
						enableField(getDocNo());
					}
				}
			};
			PatNo.setBounds(115, 0, 195, 20);
			PatNo.setCheckDeathPatient(true);
		}
		return PatNo;
	}

	public TextString getOtaId() {
		if (OtaId == null) {
			OtaId = new TextString();
			OtaId.setBounds(310, 0, 50, 20);
			OtaId.setVisible(false);
		}
		return OtaId;
	}

	public LabelBase getPatCNameDesc() {
		if (PatCNameDesc == null) {
			PatCNameDesc = new LabelBase();
			PatCNameDesc.setText("Patient Chinese Name");
			PatCNameDesc.setBounds(380, 0, 131, 20);
		}
		return PatCNameDesc;
	}

	public TextString getPatCName() {
		if (PatCName == null) {
			PatCName = new TextString() {
				@Override
				public void onBlur() {
					super.onBlur();
					txtPatNoEnable();
				}

				@Override
				protected void onFocus() {
					super.onFocus();
					txtPatNoEnable();
				}
			};
			PatCName.setBounds(530, 0, 195, 20);
		}
		return PatCName;
	}

	public LabelBase getPatFNameDesc() {
		if (PatFNameDesc == null) {
			PatFNameDesc = new LabelBase();
			PatFNameDesc.setText("Family Name");
			PatFNameDesc.setBounds(10, 23, 106, 20);
		}
		return PatFNameDesc;
	}

	public TextString getPatFName() {
		if (PatFName == null) {
			PatFName = new TextString(40) {
				@Override
				public void onBlur() {
					super.onBlur();
					txtPatNoEnable();
				}

				@Override
				protected void onFocus() {
					super.onFocus();
					txtPatNoEnable();
				}
			};
			PatFName.setBounds(115, 23, 195, 20);
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
			PatGNameDesc.setBounds(430, 23, 111, 20);
		}
		return PatGNameDesc;
	}

	public TextString getPatGName() {
		if (PatGName == null) {
			PatGName = new TextString(40) {
				@Override
				public void onBlur() {
					super.onBlur();
					txtPatNoEnable();
				}

				@Override
				protected void onFocus() {
					super.onFocus();
					txtPatNoEnable();
				}
			};
			PatGName.setBounds(530, 23, 195, 20);
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
			DocNoDesc.setBounds(10, 46, 106, 20);
		}
		return DocNoDesc;
	}

	public TextString getDocNo() {
		if (DocNo == null) {
			DocNo = new TextString() {
				@Override
				public void onBlur() {
					super.onBlur();
					txtPatNoEnable();
				}

				@Override
				protected void onFocus() {
					super.onFocus();
					txtPatNoEnable();
				}
			};
			DocNo.setBounds(115, 46, 195, 20);
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
			DOBDesc.setBounds(430, 46, 111, 20);
		}
		return DOBDesc;
	}

	public TextDateWithCheckBox getDOB() {
		if (DOB == null) {
			DOB = new TextDateWithCheckBox() {
				@Override
				public void onBlur() {
					super.onBlur();
					txtPatNoEnable();
				}

				@Override
				protected void onFocus() {
					super.onFocus();
					txtPatNoEnable();
				}
			};
			DOB.setBounds(530, 46, 195, 20);
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
			PhoneNoDesc.setBounds(10, 69, 106, 20);
		}
		return PhoneNoDesc;
	}

	public TextString getPhoneNo() {
		if (PhoneNo == null) {
			PhoneNo = new TextString() {
				@Override
				public void onBlur() {
					super.onBlur();
					txtPatNoEnable();
				}

				@Override
				protected void onFocus() {
					super.onFocus();
					txtPatNoEnable();
				}
			};
			PhoneNo.setBounds(115, 69, 195, 20);
			PhoneNo.addKeyListener(new KeyListener() {
				@Override
				public void componentKeyUp(ComponentEvent event) {
					txtPatNoEnable();
				}
			});
		}
		return PhoneNo;
	}

	public LabelBase getSexDesc() {
		if (SexDesc == null) {
			SexDesc = new LabelBase();
			SexDesc.setText("Sex");
			SexDesc.setBounds(430, 69, 111, 20);
		}
		return SexDesc;
	}

	public ComboSex getSex() {
		if (Sex == null) {
			Sex = new ComboSex();
			Sex.setBounds(530, 69, 118, 20);
		}
		return Sex;
	}

	public ButtonBase getAllergy() {
		if (Allergy == null) {
			Allergy = new ButtonBase() {
				@Override
				public void onClick() {
					isFrmAllergyLoaded = true;
					Factory.getInstance().addErrorMessage("Cannot access <font color=red'>Clinical System</font>, the allergy information cannot be displayed.");
				}
			};
			Allergy.setText("Allergy");
			Allergy.setBounds(651, 69, 76, 23);
		}
		return Allergy;
	}

	public LabelBase getPatMobNoDesc() {
		if (PatMobNoDesc == null) {
			PatMobNoDesc = new LabelBase();
			PatMobNoDesc.setText("Patient Mobile No.");
			PatMobNoDesc.setBounds(10, 92, 106, 20);
		}
		return PatMobNoDesc;
	}

	public TextString getPatMobNo() {
		if (PatMobNo == null) {
			PatMobNo = new TextString();
			PatMobNo.setBounds(115, 92, 195, 20);
		}
		return PatMobNo;
	}

	public LabelBase getPatTypeDesc() {
		if (PatTypeDesc == null) {
			PatTypeDesc = new LabelBase();
			PatTypeDesc.setText("Patient Type");
			PatTypeDesc.setBounds(430, 92, 111, 20);
		}
		return PatTypeDesc;
	}

	public ComboPatientType getPatType() {
		if (PatType == null) {
			PatType = new ComboPatientType();
			PatType.setBounds(530, 92, 195, 20);
		}
		return PatType;
	}

	public LabelBase getStartDateDesc() {
		if (StartDateDesc == null) {
			StartDateDesc = new LabelBase();
			StartDateDesc.setText("Start Date/Time");
			StartDateDesc.setBounds(10, 115, 106, 20);
		}
		return StartDateDesc;
	}

	public TextDateTimeWithoutSecond getStartDate() {
		if (StartDate == null) {
			StartDate = new TextDateTimeWithoutSecond();
			StartDate.setBounds(115, 115, 195, 20);

			StartDate.addListener(Events.OnBlur, new Listener() {
				@Override
				public void handleEvent(BaseEvent be) {
					if (isModify()) {
						if (!getStartDate().getText().equals(memSDate) ||
								!getEndDate().getText().equals(memEDate)) {
							getAnesNotify().resetText();
							getSurNotify().resetText();
							getEndNotify().resetText();
						} else {
							getAnesNotify().setText(memANDate);
							getSurNotify().setText(memSNDate);
							getEndNotify().setText(memENDate);
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
			EndDateDesc.setBounds(430, 115, 111, 20);
		}
		return EndDateDesc;
	}

	public TextDateTimeWithoutSecond getEndDate() {
		if (EndDate == null) {
			EndDate = new TextDateTimeWithoutSecond();
			EndDate.setBounds(530, 115, 195, 20);

			EndDate.addListener(Events.OnBlur, new Listener() {
				@Override
				public void handleEvent(BaseEvent be) {
					if (isModify()) {
						if (!getStartDate().getText().equals(memSDate) ||
								!getEndDate().getText().equals(memEDate)) {
							getAnesNotify().resetText();
							getSurNotify().resetText();
							getEndNotify().resetText();
						} else {
							getAnesNotify().setText(memANDate);
							getSurNotify().setText(memSNDate);
							getEndNotify().setText(memENDate);
						}
					}
				}
			});
		}
		return EndDate;
	}

	public LabelBase getRoomDesc() {
		if (RoomDesc == null) {
			RoomDesc = new LabelBase();
			RoomDesc.setText("Room");
			RoomDesc.setBounds(10, 138, 106, 20);
		}
		return RoomDesc;
	}

	public ComboAppRoomType getRoom() {
		if (Room == null) {
			Room = new ComboAppRoomType(false);
			Room.setBounds(115, 138, 195, 20);
		}
		return Room;
	}

/*
	public LabelBase getPrimaryProcDesc() {
		if (ProcDesc == null) {
			ProcDesc = new LabelBase();
			ProcDesc.setText("Procedure");
			ProcDesc.setBounds(10, 161, 106, 20);
		}
		return ProcDesc;
	}

	public ComboOTProc getPrimaryProc() {
		if (Proc == null) {
			Proc = new ComboOTProc(false);
			Proc.addSelectionChangedListener(
						new SelectionChangedListener<ModelData>() {
					@Override
					public void selectionChanged(SelectionChangedEvent<ModelData> se) {
						getPrimaryProc().setToolTip(getPrimaryProc().getDisplayText());
					}
				});
			Proc.setBounds(115, 161, 190, 20);
		}
		return Proc;
	}

	public ButtonBase getSearchProc() {
		if (SearchProc == null) {
			SearchProc = new ButtonBase() {
				@Override
				public void onClick() {
					showPanel(new com.hkah.client.tx.ot.OTProcedureCode());
				}
			};
			SearchProc.setText("...");
			SearchProc.setBounds(309, 161, 27, 20);
		}
		return SearchProc;
	}
*/
	public FieldSetBase getProcPanel() {
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
			ProcPanel.setBounds(0, 161, 750, 115);
		}
		return ProcPanel;
	}

	public LabelBase getPrimaryProcDesc() {
		if (PrimaryProcDesc == null) {
			PrimaryProcDesc = new LabelBase();
			PrimaryProcDesc.setText("Primary");
			PrimaryProcDesc.setBounds(10, -10, 86, 20);
		}
		return PrimaryProcDesc;
	}

	public ComboOTProc getPrimaryProc() {
		if (PrimaryProc == null) {
			PrimaryProc = new ComboOTProc(false);
			PrimaryProc.addSelectionChangedListener(
						new SelectionChangedListener<ModelData>() {
					@Override
					public void selectionChanged(SelectionChangedEvent<ModelData> se) {
						getPrimaryProc().setToolTip(getPrimaryProc().getDisplayText());
					}
				});
			PrimaryProc.setBounds(114, -10, 570, 20);
		}
		return PrimaryProc;
	}


	public ButtonBase getPrimaryProcSearch() {
		if (PrimaryProcSearch == null) {
			PrimaryProcSearch = new ButtonBase() {
				@Override
				public void onClick() {
					showPanel(new com.hkah.client.tx.ot.OTProcedureCode());
				}
			};
			PrimaryProcSearch.setText("...");
			PrimaryProcSearch.setBounds(688, -10, 38, 20);
		}
		return PrimaryProcSearch;
	}

	public LabelBase getSecProcDesc() {
		if (SecProcDesc == null) {
			SecProcDesc = new LabelBase();
			SecProcDesc.setText("Secondary");
			SecProcDesc.setBounds(10, 15, 86, 20);
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
			secProcAdd.setBounds(15, 40, 20, 20);
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
//						rowsToDel(getSecProcTable(), rowIdx);
						getSecProcTable().removeRow(rowIdx);
					}
				}
			};
			secProcRemove.setText("-");
			secProcRemove.setBounds(45, 40, 20, 20);
		}
		return secProcRemove;
	}

	private JScrollPane getSecProcJScrollPane() {
		if (SecProcJScrollPane == null) {
			SecProcJScrollPane = new JScrollPane();
			SecProcJScrollPane.setViewportView(getSecProcTable());
			SecProcJScrollPane.setBounds(114, 15, 612, 70);
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
//			SecProcTable.setData(NAME_VALUE, ConstantsTx.OTAPPPROC_TXCODE);
		}
		return SecProcTable;
	}

	public LabelBase getReferDotorDesc() {
		if (ReferDotorDesc == null) {
			ReferDotorDesc = new LabelBase();
			ReferDotorDesc.setText("Referral Doctor");
			ReferDotorDesc.setBounds(430, 138, 106, 20);
		}
		return ReferDotorDesc;
	}

	public ComboReferDotor getReferDotor() {
		if (ReferDotor == null) {
			ReferDotor = new ComboReferDotor(false) {
				@Override
				protected void setTextPanel(ModelData modelData) {
					setToolTip(getDisplayText());
					if (!init && (getOriginalValue() == null || !getOriginalValue().equals(getText()))) {
						getSurNotify().resetText();
						if (!isEmpty()) {
							getDlgDocPrivilege().showDialog(getText());
						}
						showOverdueMsg(this, true, false);
					}

					setOriginalValue(this.getText());
				}
			};
			ReferDotor.setBounds(530, 138, 195, 20);
		}
		return ReferDotor;
	}

	public LabelBase getProcRmkDesc() {
		if (ProcRmkDesc == null) {
			ProcRmkDesc = new LabelBase();
			ProcRmkDesc.setText("<html>Procedure<br>Remarks</html>");
			ProcRmkDesc.setBounds(10, 279, 108, 27);
		}
		return ProcRmkDesc;
	}

	public TextAreaBase getProcRmk() {
		if (ProcRmk == null) {
			ProcRmk = new TextAreaBase(3, 80);
			ProcRmk.setBounds(115, 279, 614, 35);
		}
		return ProcRmk;
	}

	public LabelBase getDiagnoDesc() {
		if (DiagnoDesc == null) {
			DiagnoDesc = new LabelBase();
			DiagnoDesc.setText("Diagnostics");
			DiagnoDesc.setBounds(10, 317, 106, 20);
		}
		return DiagnoDesc;
	}

	public TextAreaBase getDiagno() {
		if (Diagno == null) {
			Diagno = new TextAreaBase(3, 80);
			Diagno.setBounds(115, 317, 614, 35);
		}
		return Diagno;
	}

	public LabelBase getSurgeonDesc() {
		if (SurgeonDesc == null) {
			SurgeonDesc = new LabelBase();
			SurgeonDesc.setText("Surgeon");
			SurgeonDesc.setBounds(10, 355, 106, 20);
		}
		return SurgeonDesc;
	}

	public ComboDoctorSU getSurgeon() {
		if (Surgeon == null) {
			Surgeon = new ComboDoctorSU(false) {
				@Override
				public void onBlur() {
					super.onBlur();
					if (getText().length() == 0) {
						getSurExpDateDesc().resetText();
					}
				}

				@Override
				protected void setTextPanel(ModelData modelData) {
					setToolTip(getDisplayText());
					if (!init && (getOriginalValue() == null || !getOriginalValue().equals(getText()))) {
						getSurNotify().resetText();
						if (!isEmpty()) {
							getDlgDocPrivilege().showDialog(getText());
						}
						showOverlapMsg(this, true);
						showOverdueMsg(this, true, false);
					}

					setOriginalValue(getText());
				}
			};
			Surgeon.setBounds(115, 355, 195, 20);
		}
		return Surgeon;
	}

	public LabelBase getSurExpDateDesc() {
		if (surExpDateDesc == null) {
			surExpDateDesc = new LabelBase();
			surExpDateDesc.setBounds(320, 355, 250, 20);
		}
		return surExpDateDesc;
	}

	public LabelBase getSurNotifyDesc() {
		if (SurNotifyDesc == null) {
			SurNotifyDesc = new LabelBase();
			SurNotifyDesc.setText("Notify");
			SurNotifyDesc.setBounds(540, 355, 111, 20);
		}
		return SurNotifyDesc;
	}

	public TextDateTimeWithoutSecondWithCheckBox getSurNotify() {
		if (SurNotify == null) {
			SurNotify = new TextDateTimeWithoutSecondWithCheckBox();
			SurNotify.setBounds(580, 355, 145, 20);
		}
		return SurNotify;
	}

	public LabelBase getSecSurgeonDesc() {
		if (SecSurgeonDesc == null) {
			SecSurgeonDesc = new LabelBase();
			SecSurgeonDesc.setText("Sec. Surgeon");
			SecSurgeonDesc.setBounds(10, 378, 106, 20);
		}
		return SecSurgeonDesc;
	}

	public ComboDoctorSU getSecSurgeon() {
		if (SecSurgeon == null) {
			SecSurgeon = new ComboDoctorSU(false) {
				@Override
				public void onBlur() {
					super.onBlur();
					if (getText().length() == 0) {
						getSecSurExpDateDesc().resetText();
					}
				}

				@Override
				protected void setTextPanel(ModelData modelData) {
					setToolTip(getDisplayText());
					if (!init && (getOriginalValue() == null || !getOriginalValue().equals(getText()))) {
						getSecSurNotify().resetText();
						if (!isEmpty()) {
							getDlgDocPrivilege().showDialog(getText());
						}
						showOverlapMsg(this, true);
						showOverdueMsg(this, true, false);
					}

					setOriginalValue(getText());
				}
			};
			SecSurgeon.setBounds(115, 378, 195, 20);
		}
		return SecSurgeon;
	}

	public LabelBase getSecSurExpDateDesc() {
		if (SecSurExpDateDesc == null) {
			SecSurExpDateDesc = new LabelBase();
			SecSurExpDateDesc.setBounds(320, 378, 250, 20);
		}
		return SecSurExpDateDesc;
	}

	public LabelBase getSecSurNotifyDesc() {
		if (SecSurNotifyDesc == null) {
			SecSurNotifyDesc = new LabelBase();
			SecSurNotifyDesc.setText("Notify");
			SecSurNotifyDesc.setBounds(540, 378, 111, 20);
		}
		return SecSurNotifyDesc;
	}

	public TextDateTimeWithoutSecondWithCheckBox getSecSurNotify() {
		if (SecSurNotify == null) {
			SecSurNotify = new TextDateTimeWithoutSecondWithCheckBox();
			SecSurNotify.setBounds(580, 378, 145, 20);
		}
		return SecSurNotify;
	}

	public LabelBase getAnesthDesc() {
		if (AnesthDesc == null) {
			AnesthDesc = new LabelBase();
			AnesthDesc.setText("Anesthetist");
			AnesthDesc.setBounds(10, 401, 106, 20);
		}
		return AnesthDesc;
	}

	public ComboDoctorAN getAnesth() {
		if (Anesth == null) {
			Anesth = new ComboDoctorAN(false, false) {
				@Override
				public void onBlur() {
					super.onBlur();
					if (getText().length() == 0) {
						getAnesExpDateDesc().resetText();
					}
				}

				@Override
				protected void setTextPanel(ModelData modelData) {
					setToolTip(getDisplayText());
					if (!init && (getOriginalValue() == null || !getOriginalValue().equals(getText()))) {
						getAnesNotify().resetText();
						if (!isEmpty()) {
							getDlgDocPrivilege().showDialog(getText());
						}
						showOverlapMsg(this, true);
						showOverdueMsg(this, true, false);
					}

					setOriginalValue(getText());
				}
			};
			Anesth.setBounds(115, 401, 195, 20);
		}
		return Anesth;
	}

	public LabelBase getAnesExpDateDesc() {
		if (anesExpDateDesc == null) {
			anesExpDateDesc = new LabelBase();
			anesExpDateDesc.setBounds(320, 401, 250, 20);
		}
		return anesExpDateDesc;
	}

	public LabelBase getAnesNotifyDesc() {
		if (AnesNotifyDesc == null) {
			AnesNotifyDesc = new LabelBase();
			AnesNotifyDesc.setText("Notify");
			AnesNotifyDesc.setBounds(540, 401, 111, 20);
		}
		return AnesNotifyDesc;
	}

	public TextDateTimeWithoutSecondWithCheckBox getAnesNotify() {
		if (AnesNotify == null) {
			AnesNotify = new TextDateTimeWithoutSecondWithCheckBox();
			AnesNotify.setBounds(580, 401, 145, 20);
		}
		return AnesNotify;
	}

	public LabelBase getAnesMethodDesc() {
		if (AnesMethodDesc == null) {
			AnesMethodDesc = new LabelBase();
			AnesMethodDesc.setText("Anes. Method");
			AnesMethodDesc.setBounds(10, 424, 106, 20);
		}
		return AnesMethodDesc;
	}

	public ComboAnesMeth getAnesMethod() {
		if (AnesMethod == null) {
			AnesMethod = new ComboAnesMeth(false);
			AnesMethod.setBounds(115, 424, 195, 20);
		}
		return AnesMethod;
	}

	public LabelBase getEndoscopistDesc() {
		if (EndoscopistDesc == null) {
			EndoscopistDesc = new LabelBase();
			EndoscopistDesc.setText("Endoscopist");
			EndoscopistDesc.setBounds(10, 447, 106, 20);
		}
		return EndoscopistDesc;
	}

	public ComboDoctorEN getEndoscopist() {
		if (Endoscopist == null) {
			Endoscopist = new ComboDoctorEN(false) {
				@Override
				public void onBlur() {
					super.onBlur();
					if (getText().length() == 0) {
						getEndExpDateDesc().resetText();
					}
				}

				@Override
				protected void setTextPanel(ModelData modelData) {
					setToolTip(getDisplayText());
					if (!init && (getOriginalValue() == null || !getOriginalValue().equals(getText()))) {
						getEndNotify().resetText();
						if (!isEmpty()) {
							getDlgDocPrivilege().showDialog(getText());
						}
						showOverlapMsg(this, true);
						showOverdueMsg(this, true, false);
					}

					setOriginalValue(getText());
				}
			};
			Endoscopist.setBounds(115, 447, 195, 20);
		}
		return Endoscopist;
	}

	public LabelBase getEndExpDateDesc() {
		if (endExpDateDesc == null) {
			endExpDateDesc = new LabelBase();
			endExpDateDesc.setBounds(320, 447, 250, 20);
		}
		return endExpDateDesc;
	}

	public LabelBase getEndNotifyDesc() {
		if (EndNotifyDesc == null) {
			EndNotifyDesc = new LabelBase();
			EndNotifyDesc.setText("Notify");
			EndNotifyDesc.setBounds(540, 447, 111, 20);
		}
		return EndNotifyDesc;
	}

	public TextDateTimeWithoutSecondWithCheckBox getEndNotify() {
		if (EndNotify == null) {
			EndNotify = new TextDateTimeWithoutSecondWithCheckBox();
			EndNotify.setBounds(580, 447, 145, 20);
		}
		return EndNotify;
	}

	public LabelBase getOTRmkDesc() {
		if (OTRmkDesc == null) {
			OTRmkDesc = new LabelBase();
			OTRmkDesc.setText("OT Remark");
			OTRmkDesc.setBounds(10, 470, 106, 20);
		}
		return OTRmkDesc;
	}

	public TextAreaBase getOTRmk() {
		if (OTRmk == null) {
//			OTRmk = new JTextArea();
			OTRmk = new TextAreaBase(3, 80);
			OTRmk.setBounds(115, 470, 614, 35);
		}
		return OTRmk;
	}

	public LabelBase getFERequestedDesc() {
		if (FERequestedDesc == null) {
			FERequestedDesc = new LabelBase();
			FERequestedDesc.setText("FE Requested");
			FERequestedDesc.setBounds(10, 507, 106, 20);
		}
		return FERequestedDesc;
	}

	public ComboYesNo getFERequested() {
		if (FERequested == null) {
			FERequested = new ComboYesNo();
			FERequested.setBounds(115, 507, 195, 20);
		}
		return FERequested;
	}

	public LabelBase getFEReceivedDesc() {
		if (FEReceivedDesc == null) {
			FEReceivedDesc = new LabelBase();
			FEReceivedDesc.setText("FE Received");
			FEReceivedDesc.setBounds(430, 507, 106, 20);
		}
		return FEReceivedDesc;
	}

	public ComboYesNo getFEReceived() {
		if (FEReceived == null) {
			FEReceived = new ComboYesNo();
			FEReceived.setBounds(530, 507, 195, 20);
		}
		return FEReceived;
	}

	protected String[] getSecProcTableColumnNames() {
		return new String[] {
				"","oapid","otaid","otpid",
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

	public FieldSetBase getBookInfPanel() {
		if (BookInfPanel == null) {
			BookInfPanel = new FieldSetBase();
			BookInfPanel.setHeading("Pre-Book Information");
			BookInfPanel.setBounds(10, 24, 765, 230);
			BookInfPanel.add(getSchdAdmDateDesc(), null);
			BookInfPanel.add(getSchdAdmDate(), null);
			BookInfPanel.add(getOrderbyDoctorDesc(), null);
			BookInfPanel.add(getOrderbyDoctor(), null);
			BookInfPanel.add(getForDeliveryDesc(), null);
			BookInfPanel.add(getForDelivery(), null);
			BookInfPanel.add(getMaincizenDesc(), null);
			BookInfPanel.add(getMaincizen(), null);
			BookInfPanel.add(getACMDesc(), null);
			BookInfPanel.add(getACM(), null);
			BookInfPanel.add(getWardDesc(), null);
			BookInfPanel.add(getWard(), null);
			BookInfPanel.add(getPBORmkDesc(), null);
			BookInfPanel.add(getPBORmk(), null);
			BookInfPanel.add(getCathLabRmkDesc(), null);
			BookInfPanel.add(getCathLabRmk(), null);
			BookInfPanel.add(getBpbOTRmkDesc(), null);
			BookInfPanel.add(getBpbOTRmk(), null);
			BookInfPanel.add(getBedCodeDesc(), null);
			BookInfPanel.add(getBedCode(), null);
			BookInfPanel.add(getEstLenOfStayDesc(), null);
			BookInfPanel.add(getEstLenOfStay(), null);
			BookInfPanel.add(getRightJLabel_Pkg(), null);
			BookInfPanel.add(getRightJCombo_Pkg(), null);
			if (HKAH_VALUE.equals(getUserInfo().getSiteCode())) {
				BookInfPanel.add(getRightJLabel_Misc(), null);
				BookInfPanel.add(getRightJCombo_Misc(), null);
				BookInfPanel.add(getRightJLabel_Source(), null);
				BookInfPanel.add(getRightJCombo_Source(), null);
				BookInfPanel.add(getRightJLabel_SourceNo(), null);
				BookInfPanel.add(getRightJText_SourceNo(), null);
				BookInfPanel.add(getRightJLabel_Package(), null);
				BookInfPanel.add(getRightJCombo_Package(), null);
				BookInfPanel.add(getRightButton_BudgetEst(), null);
				BookInfPanel.add(getPJCheckBox_BEDesc(), null);
				BookInfPanel.add(getPJCheckBox_BE(), null);
			}
		}
		return BookInfPanel;
	}

	public LabelBase getCancelWarning() {
		if (cancelWarning == null) {
			cancelWarning = new LabelBase();
			cancelWarning.setVisible(false);
			cancelWarning.setText(ConstantsMessage.MSG_PB_APP_CANC);
			cancelWarning.addStyleName("otappbse-bedpb-warning");
			cancelWarning.setBounds(10, 5, 764, 20);
		}
		return cancelWarning;
	}

	public LabelBase getSchdAdmDateDesc() {
		if (SchdAdmDateDesc == null) {
			SchdAdmDateDesc = new LabelBase();
			SchdAdmDateDesc.setText("Schd Adm Date");
			SchdAdmDateDesc.setBounds(10, 0, 98, 20);
		}
		return SchdAdmDateDesc;
	}

	public TextDateTimeWithoutSecondWithCheckBox getSchdAdmDate() {
		if (SchdAdmDate == null) {
			SchdAdmDate = new TextDateTimeWithoutSecondWithCheckBox();
			SchdAdmDate.setBounds(107, 0, 180, 20);
		}
		return SchdAdmDate;
	}

	public LabelBase getOrderbyDoctorDesc() {
		if (OrderbyDoctorDesc == null) {
			OrderbyDoctorDesc = new LabelBase();
			OrderbyDoctorDesc.setText("Order By Doctor");
			OrderbyDoctorDesc.setBounds(400, 0, 150, 20);
		}
		return OrderbyDoctorDesc;
	}

	public ComboDoctor getOrderbyDoctor() {
		if (OrderbyDoctor == null) {
			OrderbyDoctor = new ComboDoctor(false, "OrderByName") {
				@Override
				public void initContent(String source) {
					// initial combobox
					resetContent(ConstantsTx.DOCTOR_TXCODE, new String[] { "OrderByNameOT", "N" });
				}
				@Override
				protected void setTextPanel(ModelData modelData) {
					if (!init && (getOriginalValue() == null || !getOriginalValue().equals(getText()))) {
						showOverdueMsg(this, true, false);
					}

					setOriginalValue(getText());
				}
			};
			OrderbyDoctor.setMinListWidth(330);
			OrderbyDoctor.setBounds(501, 0, 250, 20);
		}
		return OrderbyDoctor;
	}

	public TextDoctorSearch getDrCodeSearchDelegate() {
		if (drCodeSearchDelegate == null) {
			drCodeSearchDelegate = new TextDoctorSearch() {
				@Override
				public void searchAfterAcceptAction() {
					getOrderbyDoctor().setText(getValue());
				}
			};
			drCodeSearchDelegate.setBounds(505, 97, 225, 20);
			drCodeSearchDelegate.setVisible(false);
		}
		return drCodeSearchDelegate;
	}

	public LabelBase getForDeliveryDesc() {
		if (ForDeliveryDesc == null) {
			ForDeliveryDesc = new LabelBase();
			ForDeliveryDesc.setText("For Delivery");
			ForDeliveryDesc.setBounds(10, 30, 98, 20);
		}
		return ForDeliveryDesc;
	}

	public CheckBoxBase getForDelivery() {
		if (ForDelivery == null) {
			ForDelivery = new CheckBoxBase();
			ForDelivery.setBounds(107, 30, 22, 20);
		}
		return ForDelivery;
	}

	public LabelBase getMaincizenDesc() {
		if (MaincizenDesc == null) {
			MaincizenDesc = new LabelBase();
			MaincizenDesc.setText("Mainland Citizen");
			MaincizenDesc.setBounds(164, 30, 101, 20);
		}
		return MaincizenDesc;
	}

	public CheckBoxBase getMaincizen() {
		if (Maincizen == null) {
			Maincizen = new CheckBoxBase();
			Maincizen.setBounds(270, 30, 22, 20);
		}
		return Maincizen;
	}

	public LabelBase getACMDesc() {
		if (ACMDesc == null) {
			ACMDesc = new LabelBase();
			ACMDesc.setText("ACM");
			ACMDesc.setBounds(320, 30, 49, 20);
		}
		return ACMDesc;
	}

	public ComboACMCode getACM() {
		if (ACM == null) {
			ACM = new ComboACMCode();
			ACM.setBounds(369, 30, 145, 20);
		}
		return ACM;
	}

	public LabelBase getWardDesc() {
		if (WardDesc == null) {
			WardDesc = new LabelBase();
			WardDesc.setText("Ward");
			WardDesc.setBounds(558, 30, 49, 20);
		}
		return WardDesc;
	}

	public ComboWard getWard() {
		if (Ward == null) {
			Ward = new ComboWard();
			Ward.setBounds(606, 30, 145, 20);
		}
		return Ward;
	}

	public LabelBase getPBORmkDesc() {
		if (PBORmkDesc == null) {
			PBORmkDesc = new LabelBase();
			PBORmkDesc.setText("PBO Remark");
			PBORmkDesc.setBounds(10, 60, 98, 20);
		}
		return PBORmkDesc;
	}

	public TextString getPBORmk() {
		if (PBORmk == null) {
			PBORmk = new TextString(200, true);
			PBORmk.setBounds(108, 60, 643, 20);
		}
		return PBORmk;
	}

	public LabelBase getCathLabRmkDesc() {
		if (CathLabRmkDesc == null) {
			CathLabRmkDesc = new LabelBase();
			CathLabRmkDesc.setText("Cath Lab Remark");
			CathLabRmkDesc.setBounds(10, 90, 98, 20);
		}
		return CathLabRmkDesc;
	}

	public TextString getCathLabRmk() {
		if (CathLabRmk == null) {
			CathLabRmk = new TextString(75, true);
			CathLabRmk.setBounds(108, 90, 643, 20);
		}
		return CathLabRmk;
	}

	public LabelBase getBpbOTRmkDesc() {
		if (bpbOTRmkDesc == null) {
			bpbOTRmkDesc = new LabelBase();
			bpbOTRmkDesc.setText("OT Remark");
			bpbOTRmkDesc.setBounds(10, 120, 98, 20);
		}
		return bpbOTRmkDesc;
	}

	public TextString getBpbOTRmk() {
		if (bpbOTRmk == null) {
			bpbOTRmk = new TextString(75, true);
			bpbOTRmk.setBounds(108, 120, 643, 20);
		}
		return bpbOTRmk;
	}

	public LabelBase getBedCodeDesc() {
		if (bedCodeDesc == null) {
			bedCodeDesc = new LabelBase();
			bedCodeDesc.setText("Bed Code");
			bedCodeDesc.setBounds(10, 150, 98, 20);
		}
		return bedCodeDesc;
	}

	public ComboBedCode getBedCode() {
		if (bed == null) {
			bed = new ComboBedCode();
			bed.setBounds(108, 150, 145, 20);
		}
		return bed;
	}

	public LabelBase getEstLenOfStayDesc() {
		if (estLenOfStayDesc == null) {
			estLenOfStayDesc = new LabelBase();
			estLenOfStayDesc.setText("Estimated Length of Stay");
			estLenOfStayDesc.setBounds(273, 150, 148, 20);
		}
		return estLenOfStayDesc;
	}

	public TextString getEstLenOfStay() {
		if (estLenOfStay == null) {
			estLenOfStay = new TextString();
			estLenOfStay.setBounds(441, 150, 80, 20);
			estLenOfStay.addListener(Events.OnBlur, new Listener<FieldEvent>() {
				@Override
				public void handleEvent(FieldEvent be) {
					try {
						if (!getEstLenOfStay().isEmpty() &&
								!TextUtil.isInteger(getEstLenOfStay().getText().toString())) {
							Factory.getInstance().addErrorMessage("Please input Integer.", getEstLenOfStay());
							return;
						}

						if (!getEstLenOfStay().isEmpty() &&
								Integer.parseInt(getEstLenOfStay().getText()) <= 0) {
							if (getSysParameter("ESTSTAYLEN").equals(YES_VALUE)) {
								Factory.getInstance().addErrorMessage("Estimated Length of Stay should be > 0", getEstLenOfStay());
							} else {
								Factory.getInstance().addErrorMessage("Estimated Length of Stay should be > 0 or null", getEstLenOfStay());
							}
						}
					} catch (Exception e) {
					}
				}
			});
		}
		return estLenOfStay;
	}

	protected LabelBase getRightJLabel_Pkg() {
		if (RightJLabel_Pkg == null) {
			RightJLabel_Pkg = new LabelBase();
			RightJLabel_Pkg.setText("Package");
			RightJLabel_Pkg.setBounds(530, 150, 30, 20);
		}
		return RightJLabel_Pkg;
	}

	private ComboPackage getRightJCombo_Pkg() {
		if (RightJCombo_Pkg == null) {
			RightJCombo_Pkg = new ComboPackage(true, "PKGTYPE <> 'P'");
			RightJCombo_Pkg.setBounds(580, 150, 150, 20);
			RightJCombo_Pkg.setMinListWidth(300);
			RightJCombo_Pkg.setShowKeyOnly(false);
		}
		return RightJCombo_Pkg;
	}
	
	public LabelBase getRightJLabel_Misc() {
		if (RightJLabel_Misc == null) {
			RightJLabel_Misc = new LabelBase();
			RightJLabel_Misc.setText("Rmk");
			RightJLabel_Misc.setBounds(10, 176, 25, 20);
		}
		return RightJLabel_Misc;
	}

	public ComboBoxBase getRightJCombo_Misc() {
		if (RightJCombo_Misc == null) {
			RightJCombo_Misc = new ComboBoxBase("TRANSMISC", false, false, true);
			RightJCombo_Misc.setBounds(40,176, 65, 20);
		}
		return RightJCombo_Misc;
	}

	public LabelBase getRightJLabel_Source() {
		if (RightJLabel_Source == null) {
			RightJLabel_Source = new LabelBase();
			RightJLabel_Source.setText("Src");
			RightJLabel_Source.setBounds(110, 176, 20, 20);
		}
		return RightJLabel_Source;
	}

	public ComboBoxBase getRightJCombo_Source() {
		if (RightJCombo_Source == null) {
			RightJCombo_Source = new ComboBoxBase("TRANSSRC", false, false, true);
			RightJCombo_Source.setBounds(135, 176, 65, 20);
		}
		return RightJCombo_Source;
	}

	private LabelBase getRightJLabel_SourceNo() {
		if (RightJLabel_SourceNo == null) {
			RightJLabel_SourceNo = new LabelBase();
			RightJLabel_SourceNo.setText("Src #");
			RightJLabel_SourceNo.setBounds(205, 176, 32, 20);
		}
		return RightJLabel_SourceNo;
	}

	private TextString getRightJText_SourceNo() {
		if (RightJText_SourceNo == null) {
			RightJText_SourceNo = new TextString(20);
			RightJText_SourceNo.setBounds(242, 176, 100, 20);
		}
		return RightJText_SourceNo;
	}

	private LabelBase getRightJLabel_Package() {
		if (RightJLabel_Package == null) {
			RightJLabel_Package = new LabelBase();
			RightJLabel_Package.setText("Package");
			RightJLabel_Package.setBounds(349, 176, 60, 20);
		}
		return RightJLabel_Package;
	}

	private ComboBoxBase getRightJCombo_Package() {
		if (RightJCombo_Package == null) {
			RightJCombo_Package = new ComboBoxBase("BPBPKG", false, false, true);
			RightJCombo_Package.setBounds(414, 176, 200, 20);
		}
		return RightJCombo_Package;
	}

	private ButtonBase getRightButton_BudgetEst() {
		if (RightButton_BudgetEst == null) {
			RightButton_BudgetEst = new ButtonBase() {
				@Override
				public void onClick() {
					getDlgBudgetEst().showDialog(memFestID, "PreBook", String.valueOf(lotPBPID),
												 getPatNo().getText().trim(),
												 getPatFName().getText() + SPACE_VALUE + getPatGName().getText(),
												 getOrderbyDoctor().getText());
				}
			};
			RightButton_BudgetEst.setText("Budget Est");
			RightButton_BudgetEst.setEnabled(false);
			RightButton_BudgetEst.setBounds(620, 176, 80, 22);
		}
		return RightButton_BudgetEst;
	}

	private DlgBudgetEstBase getDlgBudgetEst() {
		if (dlgBudgetEst == null) {
			dlgBudgetEst = new DlgBudgetEstBase(getMainFrame()){
				@Override
				public void post(String srcNo,boolean isBE) {
					memFestID = srcNo;
					if(isBE) {
						getRightButton_BudgetEst().el().addStyleName("button-alert-green");
					} else {
						getRightButton_BudgetEst().el().removeStyleName("button-alert-green");
					}
					getPJCheckBox_BE().setSelected(isBE);
				}
			};
		}
		return dlgBudgetEst;
	}

	protected LabelBase getPJCheckBox_BEDesc() {
		if (PJCheckBox_BEDesc == null) {
			PJCheckBox_BEDesc = new LabelBase();
			PJCheckBox_BEDesc.setText("*BE");
			PJCheckBox_BEDesc.setBounds(710, 176, 20, 20);
		}
		return PJCheckBox_BEDesc;
	}

	protected CheckBoxBase getPJCheckBox_BE() {
		if (PJCheckBox_BE == null) {
			PJCheckBox_BE = new CheckBoxBase();
			PJCheckBox_BE.setBounds(730, 176, 20, 20);
		}
		return PJCheckBox_BE;
	}

	public BasePanel getBedBookPanel() {
		if (BedBookPanel == null) {
			BedBookPanel = new BasePanel();
			BedBookPanel.setBounds(5, 5, 800, 610);
			BedBookPanel.add(getCancelWarning(), null);
			BedBookPanel.add(getBookInfPanel(), null);
			BedBookPanel.add(getARInfPanel(), null);
			BedBookPanel.add(getDeclinationPanel(), null);
		}
		return BedBookPanel;
	}

	public FieldSetBase getARInfPanel() {
		if (ARInfPanel == null) {
			ARInfPanel = new FieldSetBase();
			ARInfPanel.setBounds(10, 268, 764, 164);
			ARInfPanel.setHeading("AR Information");
			ARInfPanel.add(getARCodeDesc(), null);
			ARInfPanel.add(getARCode(), null);
			ARInfPanel.add(getAR_Description(), null);
			ARInfPanel.add(getPolicyNoDesc(), null);
			ARInfPanel.add(getPolicyNo(), null);
			ARInfPanel.add(getCoPayTypeDesc(), null);
			ARInfPanel.add(getCoPayType(), null);
			ARInfPanel.add(getAmt(), null);
			ARInfPanel.add(getVouNoDesc(), null);
			ARInfPanel.add(getVouNo(), null);
			ARInfPanel.add(getInsCoverDesc(), null);
			ARInfPanel.add(getInsCover(), null);
			ARInfPanel.add(getInsLimitAmtDesc(), null);
			ARInfPanel.add(getInsLimitAmt(), null);
			ARInfPanel.add(getCoverItemDesc(), null);
			ARInfPanel.add(getDoctorDesc(), null);
			ARInfPanel.add(getDoctor(), null);
			ARInfPanel.add(getHospitalDesc(), null);
			ARInfPanel.add(getHospital(), null);
			ARInfPanel.add(getSpecialDesc(), null);
			ARInfPanel.add(getSpecial(), null);
			ARInfPanel.add(getOtherDesc(), null);
			ARInfPanel.add(getOther(), null);
		}
		return ARInfPanel;
	}

	public LabelBase getARCodeDesc() {
		if (ARCodeDesc == null) {
			ARCodeDesc = new LabelBase();
			ARCodeDesc.setText("AR Code");
			ARCodeDesc.setBounds(10, 0, 107, 20);
		}
		return ARCodeDesc;
	}

	public ComboARCompany getARCode() {
		if (ARCode == null) {
			ARCode = new ComboARCompany() {
				@Override
				protected String getTxFrom() {
					return "NewEditOtApp";
				}

				@Override
				public void onClick() {
					if (getARCode().getText().length() == 0) {
						getCoPayType().resetText();
						disableField(getCoPayType());

						getAmt().resetText();
						disableField(getAmt());

						getInsLimitAmt().resetText();
						disableField(getInsLimitAmt());

						getInsCover().resetText();
						disableField(getInsCover());

						getPolicyNo().resetText();
						disableField(getPolicyNo());

						getVouNo().resetText();
						disableField(getVouNo());

						getDoctor().setSelected(false);
						getDoctor().setEditable(false);
						getDoctor().disable();

						getHospital().setSelected(false);
						getHospital().setEditable(false);
						getHospital().disable();

						getSpecial().setSelected(false);
						getSpecial().setEditable(false);
						getSpecial().disable();

						getOther().setSelected(false);
						getOther().setEditable(false);
						getOther().disable();
					} else {
						if (isModify()) {
							if (!isFlag) {
								preArcCde = getARCode().getText();
							}
							isFlag = true;
						} else {
							preArcCde = null;
						}

						QueryUtil.executeMasterFetch(getUserInfo(), "ARCODEBYACODE",
								new String[] {
										getARCode().getText(),
										preArcCde,
										String.valueOf(lotPBPID)
								},
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									getCoPayType().setText(mQueue.getContentField()[0]);
									getAmt().setText(mQueue.getContentField()[1]);
									getInsLimitAmt().setText(mQueue.getContentField()[2]);
									getInsCover().setText(mQueue.getContentField()[3]);
									if (ZERO_VALUE.equals(mQueue.getContentField()[4])) {
										getDoctor().setSelected(false);
									} else {
										getDoctor().setSelected(true);
									}
									if (ZERO_VALUE.equals(mQueue.getContentField()[5])) {
										getHospital().setSelected(false);
									} else {
										getHospital().setSelected(true);
									}
									if (ZERO_VALUE.equals(mQueue.getContentField()[6])) {
										getSpecial().setSelected(false);
									} else {
										getSpecial().setSelected(true);
									}
									if (ZERO_VALUE.equals(mQueue.getContentField()[7])) {
										getOther().setSelected(false);
									} else {
										getOther().setSelected(true);
									}
								}

								enableField(getCoPayType());
								enableField(getAmt());
								enableField(getInsLimitAmt());
								enableField(getInsCover());
								enableField(getPolicyNo());
								enableField(getVouNo());
								enableField(getDoctor());
								enableField(getHospital());
								enableField(getSpecial());
								enableField(getOther());
							}
						});
					}
				}
			};
			ARCode.setShowTextPanel(getAR_Description());
			ARCode.setBounds(117, 0, 73, 20);
		}
		return ARCode;
	}

	public TextReadOnly getAR_Description() {
		if (ARDescription == null) {
			ARDescription  = new TextReadOnly();
			ARDescription.setBounds(212, 0, 160, 20);
		}
		return ARDescription;
	}

	public LabelBase getPolicyNoDesc() {
		if (PolicyNoDesc == null) {
			PolicyNoDesc = new LabelBase();
			PolicyNoDesc.setText("Policy No");
			PolicyNoDesc.setBounds(397, 0, 138, 20);
		}
		return PolicyNoDesc;
	}

	public TextString getPolicyNo() {
		if (PolicyNo == null) {
			PolicyNo = new TextString();
			PolicyNo.setBounds(533, 0, 220, 20);
		}
		return PolicyNo;
	}

	public LabelBase getCoPayTypeDesc() {
		if (CoPayTypeDesc == null) {
			CoPayTypeDesc = new LabelBase();
			CoPayTypeDesc.setText("Co-Payment Type");
			CoPayTypeDesc.setBounds(10, 30, 107, 20);
		}
		return CoPayTypeDesc;
	}

	public ComboCoPayRefType getCoPayType() {
		if (CoPayType == null) {
			CoPayType = new ComboCoPayRefType();
			CoPayType.setBounds(117, 30, 90, 20);
		}
		return CoPayType;
	}

	public TextString getAmt() {
		if (Amt == null) {
			Amt = new TextString();
			Amt.setBounds(212, 30, 135, 20);
		}
		return Amt;
	}

	public LabelBase getVouNoDesc() {
		if (VouNoDesc == null) {
			VouNoDesc = new LabelBase();
			VouNoDesc.setText("Voucher No");
			VouNoDesc.setBounds(397, 30, 138, 20);
		}
		return VouNoDesc;
	}

	public TextString getVouNo() {
		if (VouNo == null) {
			VouNo = new TextString();
			VouNo.setBounds(533, 30, 220, 20);
		}
		return VouNo;
	}

	public LabelBase getInsCoverDesc() {
		if (InsCoverDesc == null) {
			InsCoverDesc = new LabelBase();
			InsCoverDesc.setText("<html>Insurance Coverage<br>End-Date</html>");
			InsCoverDesc.setBounds(10, 60, 107, 27);
		}
		return InsCoverDesc;
	}

	public TextDate getInsCover() {
		if (InsCover == null) {
			InsCover = new TextDate();
			InsCover.setBounds(117, 60, 230, 20);
		}
		return InsCover;
	}

	public LabelBase getInsLimitAmtDesc() {
		if (InsLimitAmtDesc == null) {
			InsLimitAmtDesc = new LabelBase();
			InsLimitAmtDesc.setText("Insurance Limit Amount");
			InsLimitAmtDesc.setBounds(397, 60, 138, 20);
		}
		return InsLimitAmtDesc;
	}

	public TextString getInsLimitAmt() {
		if (InsLimitAmt == null) {
			InsLimitAmt = new TextString();
			InsLimitAmt.setBounds(534, 60, 220, 20);
		}
		return InsLimitAmt;
	}

	public LabelBase getCoverItemDesc() {
		if (CoverItemDesc == null) {
			CoverItemDesc = new LabelBase();
			CoverItemDesc.setText("Covered Item");
			CoverItemDesc.setBounds(10, 110, 107, 20);
		}
		return CoverItemDesc;
	}

	public LabelBase getDoctorDesc() {
		if (DoctorDesc == null) {
			DoctorDesc = new LabelBase();
			DoctorDesc.setText("Doctor");
			DoctorDesc.setBounds(117, 110, 52, 20);
		}
		return DoctorDesc;
	}

	public CheckBoxBase getDoctor() {
		if (Doctor == null) {
			Doctor = new CheckBoxBase();
			Doctor.setBounds(169, 110, 22, 20);
			Doctor.setEditable(false);
			Doctor.disable();
		}
		return Doctor;
	}

	public LabelBase getHospitalDesc() {
		if (HospitalDesc == null) {
			HospitalDesc = new LabelBase();
			HospitalDesc.setText("Hospital");
			HospitalDesc.setBounds(219, 110, 52, 20);
		}
		return HospitalDesc;
	}

	public CheckBoxBase getHospital() {
		if (Hospital == null) {
			Hospital = new CheckBoxBase();
			Hospital.setBounds(271, 110, 22, 20);
			Hospital.setEditable(false);
			Hospital.disable();
		}
		return Hospital;
	}

	public LabelBase getSpecialDesc() {
		if (SpecialDesc == null) {
			SpecialDesc = new LabelBase();
			SpecialDesc.setText("Special");
			SpecialDesc.setBounds(318, 110, 52, 20);
		}
		return SpecialDesc;
	}

	public CheckBoxBase getSpecial() {
		if (Special == null) {
			Special = new CheckBoxBase();
			Special.setBounds(371, 110, 22, 20);
			Special.setEditable(false);
			Special.disable();
		}
		return Special;
	}

	public LabelBase getOtherDesc() {
		if (OtherDesc == null) {
			OtherDesc = new LabelBase();
			OtherDesc.setText("Other");
			OtherDesc.setBounds(421, 110, 52, 20);
		}
		return OtherDesc;
	}

	public CheckBoxBase getOther() {
		if (Other == null) {
			Other = new CheckBoxBase();
			Other.setBounds(472, 110, 22, 20);
			Other.setEditable(false);
			Other.disable();
		}
		return Other;
	}

	public FieldSetBase getDeclinationPanel() {
		if (DeclinationPanel == null) {
			DeclinationPanel = new FieldSetBase();
			DeclinationPanel.setHeading("Declination");
			DeclinationPanel.setBounds(9, 444, 764, 85);
			DeclinationPanel.add(getDeclinedDesc(), null);
			DeclinationPanel.add(getDeclined(), null);
			DeclinationPanel.add(getReasonDesc(), null);
			DeclinationPanel.add(getReason(), null);
			DeclinationPanel.add(getByDesc(), null);
			DeclinationPanel.add(getBy1(), null);
			DeclinationPanel.add(getBy2(), null);
			DeclinationPanel.add(geActivatebyDesc(), null);
			DeclinationPanel.add(getActivateby1(), null);
			DeclinationPanel.add(getActivateby2(), null);
		}
		return DeclinationPanel;
	}

	public LabelBase getDeclinedDesc() {
		if (DeclinedDesc == null) {
			DeclinedDesc = new LabelBase();
			DeclinedDesc.setText("Declined");
			DeclinedDesc.setBounds(10, 0, 89, 20);
		}
		return DeclinedDesc;
	}

	public CheckBoxBase getDeclined() {
		if (Declind == null) {
			Declind = new CheckBoxBase() {
				@Override
				public void onClick() {
					if (isEnabled() && !isReadOnly()) {
						enableField(getBy1());
						enableField(getBy2());
						enableField(getActivateby1());
						enableField(getActivateby2());

						if (isSelected()) {
							getReason().setEditableForever(true);
							getReason().enable();
						} else {
							getReason().setEditableForever(false);
							getReason().disable();
						}

						if (memDeclined) {
							if (!isSelected()) {
								getActivateby1().setText(Factory.getInstance().getUserInfo().getUserName());
								getActivateby2().setText(getMainFrame().getServerDate());
							}
						} else {
							if (isSelected()) {
								getBy1().setText(Factory.getInstance().getUserInfo().getUserName());
								getBy2().setText(getMainFrame().getServerDate());
							}
						}
					}
				}
			};
			Declind.setBounds(95, 0, 23, 20);
			Declind.setEditable(false);
			Declind.disable();
		}
		return Declind;
	}

	public LabelBase getReasonDesc() {
		if (ReasonDesc == null) {
			ReasonDesc = new LabelBase();
			ReasonDesc.setText("Reason");
			ReasonDesc.setBounds(229, 0, 52, 20);
		}
		return ReasonDesc;
	}

	public TextString getReason() {
		if (Reason == null) {
			Reason = new TextString() {
				@Override
				protected void onFocus() {
					if (!getDeclined().isSelected()) {
						getReason().setEditableForever(false);
						getReason().disable();
					}
				}
			};
			Reason.setBounds(281, 0, 471, 20);
			Reason.setEditableForever(false);
			Reason.disable();
		}
		return Reason;
	}

	public LabelBase getByDesc() {
		if (ByDesc == null) {
			ByDesc = new LabelBase();
			ByDesc.setText("By");
			ByDesc.setBounds(10, 30, 89, 20);
		}
		return ByDesc;
	}

	public TextString getBy1() {
		if (By1 == null) {
			By1 = new TextString() {
				@Override
				protected void onFocus() {
					getBy1().setEditableForever(false);
					getBy1().disable();
				}
			};
			By1.setBounds(99, 30, 132, 20);
			By1.setEditableForever(false);
			By1.disable();
		}
		return By1;
	}

	public TextDate getBy2() {
		if (By2 == null) {
			By2 = new TextDate() {
				@Override
				protected void onFocus() {
					getBy2().setEditableForever(false);
					getBy2().disable();
				}
			};
			By2.setBounds(237, 30, 132, 20);
			By2.setEditableForever(false);
			By2.disable();
		}
		return By2;
	}

	public LabelBase geActivatebyDesc() {
		if (ActivatebyDesc == null) {
			ActivatebyDesc = new LabelBase();
			ActivatebyDesc.setText("Activated by");
			ActivatebyDesc.setBounds(411, 30, 73, 20);
		}
		return ActivatebyDesc;
	}

	public TextString getActivateby1() {
		if (Activateby1 == null) {
			Activateby1 = new TextString() {
				@Override
				protected void onFocus() {
					getActivateby1().setEditableForever(false);
					getActivateby1().disable();
				}
			};
			Activateby1.setBounds(483, 30, 132, 20);
			Activateby1.setEditableForever(false);
			Activateby1.disable();
		}
		return Activateby1;
	}

	public TextDate getActivateby2() {
		if (Activateby2 == null) {
			Activateby2 = new TextDate() {
				@Override
				protected void onFocus() {
					getActivateby2().setEditableForever(false);
					getActivateby2().disable();
				}
			};
			Activateby2.setBounds(620, 30, 132, 20);
			Activateby2.setEditableForever(false);
			Activateby2.disable();
		}
		return Activateby2;
	}

	private DlgDocPrivilege getDlgDocPrivilege() {
		if (dlgDocPrivilege == null) {
			dlgDocPrivilege = new DlgDocPrivilege(getMainFrame());
		}
		return dlgDocPrivilege;
	}
}