package com.hkah.client.tx.registration;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.FieldEvent;
import com.extjs.gxt.ui.client.event.KeyListener;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.google.gwt.event.dom.client.KeyCodes;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboACMCode;
import com.hkah.client.layout.combobox.ComboARCompany;
import com.hkah.client.layout.combobox.ComboBedCode;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.combobox.ComboCoPayRefType;
import com.hkah.client.layout.combobox.ComboDocName;
import com.hkah.client.layout.combobox.ComboFaInfoSource;
import com.hkah.client.layout.combobox.ComboMTravelDocType;
import com.hkah.client.layout.combobox.ComboPackage;
import com.hkah.client.layout.combobox.ComboSex;
import com.hkah.client.layout.combobox.ComboWard;
import com.hkah.client.layout.combobox.ComboYesNo;
import com.hkah.client.layout.dialog.DlgARCardRemark;
import com.hkah.client.layout.dialog.DlgARCardTypeSel;
import com.hkah.client.layout.dialog.DlgBedPreBookDupl;
import com.hkah.client.layout.dialog.DlgBudgetEstBase;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.TabbedPaneBase;
import com.hkah.client.layout.textfield.TextAmount;
import com.hkah.client.layout.textfield.TextAreaBase;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextDateTime;
import com.hkah.client.layout.textfield.TextDateTimeWithoutSecond;
import com.hkah.client.layout.textfield.TextDoctorSearch;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.ActionPanel;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.PanelUtil;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class EditPreBooking extends ActionPanel {
	private static final long serialVersionUID = 1L;

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.EDITPREBOOKING_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.EDITPREBOOKING_TITLE;
	}

	private BasePanel actionPanel = null;
	protected BasePanel paraPanel = null;
	private FieldSetBase withinPanel = null;
	private FieldSetBase middlePanel = null;
	private FieldSetBase declinePanel = null;

	private LabelBase warningMsg = null;
	private LabelBase header = null;

	private TabbedPaneBase tabbedPane = null;

	// Master Information
	private BasePanel masterPanel = null;
	private LabelBase PJLabel_PatNo = null;
	private TextPatientNoSearch AJText_PatNo = null;
	private LabelBase PJLabel_Sex = null;
	private ComboSex PJCombo_Sex = null;
	private LabelBase PJLabel_GivenName = null;
	private TextString AJText_GivenName = null;
	private LabelBase PJLabel_ContactPhone = null;
	private TextString AJText_ContactPhone = null;
	private LabelBase PJLabel_MobilePhone = null;
	private TextString AJText_MobilePhone = null;
	private LabelBase PJLabel_SchdAdmDate = null;
	private TextDateTime PJDate_SchdAdmDate = null;
	private LabelBase PJLabel_EDC = null;
	private TextDateTime PJDate_EDC = null;
	private LabelBase PJLabel_ForDelivery = null;
	private CheckBoxBase PJCheckBox_ForDelivery = null;
	private LabelBase PJLabel_MainCitizen = null;
	private CheckBoxBase PJCheckBox_MainCitizen = null;
	private LabelBase PJLabel_Document = null;
	private TextString AJText_Document = null;
	private LabelBase PJLabel_FamilyName = null;
	private TextString AJText_FamilyName = null;
	private LabelBase PJLabel_DocType = null;
	private ComboMTravelDocType PJCombo_DocType = null;
	private LabelBase PJLabel_ChineseName = null;
	private TextString AJText_ChineseName = null;
	private LabelBase PJLabel_ACM = null;
	private ComboACMCode PJCombo_ACM = null;
	private LabelBase PJLabel_OrderByDoctor = null;
	private ComboDocName PJCombo_OrderByDoctor = null;
	private LabelBase PJLabel_Ward = null;
	private ComboWard PJCombo_Ward = null;
	private LabelBase RightJLabel_Misc = null;
	private ComboBoxBase RightJCombo_Misc = null;
	private LabelBase RightJLabel_Source = null;
	private ComboBoxBase RightJCombo_Source = null;
	private LabelBase RightJLabel_Package = null;
	private ComboBoxBase RightJCombo_Package = null;
	private LabelBase RightJLabel_Pkg = null;
	private ComboPackage RightJCombo_Pkg = null;
	private LabelBase RightJLabel_DOB = null;
	private TextDate RightJText_Birthday = null;
	private ButtonBase RightButton_BudgetEst = null;
	private DlgBudgetEstBase dlgBudgetEst = null;
	private LabelBase PJCheckBox_BEDesc = null;
	private CheckBoxBase PJCheckBox_BE = null;
	private LabelBase RightJLabel_SourceNo = null;
	private TextString RightJText_SourceNo = null;
	private LabelBase PJLabel_PBORemark = null;
	private TextAreaBase AJText_PBORemark = null;
	private LabelBase PJLabel_CathLabRemark = null;
	private TextString AJText_CathLabRemark = null;
	private LabelBase PJLabel_OtRemark = null;
	private TextString AJText_OtRemark = null;
	private ComboBedCode PJCombo_BedCode = null;
	private LabelBase PJLabel_BedCode = null;
	private LabelBase PJLabel_AvailableTime = null;
	private TextDateTimeWithoutSecond PJDate_AvailableTime = null;
	private LabelBase PJLabel_Stay = null;
	private TextAmount AJText_Stay = null;
	private TextDoctorSearch drCodeSearchDelegate = null;

	// Baby's Father Information
	private BasePanel fatherPanel = null;
	private LabelBase Fa_PJLabel_PatNo = null;
	private TextPatientNoSearch Fa_AJText_PatNo = null;
	private LabelBase Fa_PJLabel_FamilyName = null;
	private TextString Fa_AJText_FamilyName = null;
	private LabelBase Fa_PJLabel_ChineseName = null;
	private TextString Fa_AJText_ChineseName = null;
	private LabelBase Fa_PJLabel_GivenName = null;
	private TextString Fa_AJText_GivenName = null;
	private LabelBase Fa_PJLabel_ContactPhone = null;
	private TextString Fa_AJText_ContactPhone = null;
	private LabelBase Fa_PJLabel_DOB = null;
	private TextDate Fa_AJText_DOB = null;
	private LabelBase Fa_PJLabel_EDOB = null;
	private ComboYesNo Fa_AJText_EDOB = null;
	private LabelBase Fa_PJLabel_Document = null;
	private TextString Fa_AJText_Document = null;
	private LabelBase Fa_PJLabel_Holder = null;
	private ComboYesNo Fa_AJText_Holder = null;
	private LabelBase Fa_PJLabel_PassportNo = null;
	private TextString Fa_AJText_PassportNo = null;
	private LabelBase Fa_PJLabel_PassportType = null;
	private ComboMTravelDocType Fa_AJText_PassportType = null;
	private LabelBase Fa_PJLabel_Residence = null;
	private TextString Fa_AJText_Residence = null;
	private LabelBase Fa_PJLabel_InfoSource = null;
	private ComboFaInfoSource Fa_AJText_InfoSource = null;
	private LabelBase Fa_PJLabel_DOBFormat = null;
	private LabelBase Fa_PJLabel_HKIDFormat = null;

	// Antenatal Check-up Information
	private BasePanel checkPanel = null;
	private LabelBase checkDesc1 = null;
	private LabelBase checkDesc2 = null;
	private LabelBase checkDesc3 = null;
	private LabelBase checkDesc4 = null;
	private LabelBase checkDesc5 = null;
	private LabelBase checkDesc6 = null;
	private LabelBase checkDesc7 = null;
	private LabelBase checkDesc8 = null;
	private LabelBase checkDesc9 = null;
	private LabelBase checkDesc10 = null;
	private TextDate check1 = null;
	private TextDate check2 = null;
	private TextDate check3 = null;
	private TextDate check4 = null;
	private TextDate check5 = null;
	private TextDate check6 = null;
	private TextDate check7 = null;
	private TextDate check8 = null;
	private TextDate check9 = null;
	private TextDate check10 = null;

	// AR Information
	private LabelBase PJLabel_ArCode = null;
	private ComboARCompany PJCombo_ArCode = null;
	private TextReadOnly PJText_ARCompanyDesc = null;
	private TextReadOnly PJText_ARCardType = null;
	private LabelBase PJLabel_PolicyNo = null;
	private TextString AJText_PolicyNo = null;
	private ComboCoPayRefType PJCombo_PaymentType = null;
	private LabelBase PJLabel_PaymentType = null;
	private LabelBase PJLabel_VoucherNo = null;
	private TextString AJText_VoucherNo = null;
	private LabelBase PJLabel_PreAuthNo = null;
	private TextString AJText_PreAuthNo = null;
	private LabelBase PJLabel_CoPayActualNo = null;
	private TextAmount AJText_CoPayActualAmount = null;
	private TextAmount AJText_LimitAmount = null;
	private LabelBase PJLabel_Amount = null;
	private LabelBase PJLabel_GuarAmt = null;
	private TextAmount AJText_GuarAmt = null;
	private LabelBase PJLabel_GuarDate = null;
	private TextDate AJText_GuarDate = null;
	private LabelBase PJLabel_InsCoverageEndDate = null;
	private TextDate AJText_InsCoverageEndDate = null;
	private LabelBase PJLabel_CoveredItem = null;
	private TextAmount AJText_PaymentType = null;
	private LabelBase PJLabel_Doctor = null;
	private CheckBoxBase PJCheckBox_Doctor = null;
	private CheckBoxBase PJCheckBox_Hospital = null;
	private LabelBase PJLabel_Hospital = null;
	private LabelBase PJLabel_Special = null;
	private CheckBoxBase PJCheckBox_Special = null;
	private LabelBase PJLabel_RevLog = null;
	private CheckBoxBase PJCheckBox_RevLog = null;
	private LabelBase PJLabel_EstGiven = null;
	private CheckBoxBase PJCheckBox_EstGiven = null;
	private LabelBase RightJLabel_LogCvrCls = null;
	private ComboACMCode RightJCombo_LogCvrCls = null;
	private LabelBase PJLabel_Othen = null;
	private CheckBoxBase PJCheckBox_Othen = null;
	private LabelBase PJLabel_Declined = null;
	private CheckBoxBase PJCheckBox_Declined = null;
	private LabelBase PJLabel_Reacon = null;
	private TextString AJText_Reacon = null;
	private LabelBase PJLabel_By = null;
	private TextReadOnly AJText_By = null;
	private TextReadOnly AJText_By1 = null;
	private TextReadOnly AJText_ActivatedBy = null;
	private TextReadOnly AJText_ActivatedBy1 = null;
	private LabelBase PJLabel_ActivatedBy = null;

	private String memArcCode = null;
	private String memActID = EMPTY_VALUE;
	private String memFestID = EMPTY_VALUE;
	protected String memBpbRegType = EMPTY_VALUE;

	private String obWardcode = null;
	private String curPatNo = "";
	private String curFaPatNo = "";
	private String oldHospDate = EMPTY_VALUE;
	private String OBBookType = EMPTY_VALUE;
	private String bookStatus = EMPTY_VALUE;

	private String pbpID = null;
	private String refusedUserID = null;
	private String activatedUserID = null;

	protected boolean referralCase = false;
	private boolean OriRefuseStatus = false;
	private boolean isFromOBBooking = false;
	private boolean isExitPanel = false;
	private boolean isMustConfirm = false;
	private boolean isWaitingList = false;
	private boolean memIsRefuse = false;
	private String currentAction = EMPTY_VALUE;
//	private boolean pSavePBOk = false;

	private String paraFromWhere = null;
	private String funname = null;
	private boolean isNewPB = false;
	private String BPBSTS = null;
	private boolean initPBReady = false;
	private boolean isCloseDlgARCardRemark = false;
	private boolean isCloseDlgARCardTypeSel = false;

	private DlgBedPreBookDupl duplicateDialog = null;
	private DlgARCardTypeSel dlgARCardTypeSel = null;
	private DlgARCardRemark dlgARCardRemark = null;
	/**
	 * This method initializes
	 *
	 */
	public EditPreBooking() {
		super();
	}

	public void rePostAction() {
		if (isExitPanel) {
			isCloseDlgARCardRemark = false;
			isCloseDlgARCardTypeSel = false;
			exitPanel(true);
		}
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		// load ob ward code
		initPBReady = false;
		obWardcode = getSysParameter("obwardcode");
		memBpbRegType = getParameter("BPBREGTYPE");
		referralCase = YES_VALUE.equals(getSysParameter("REFMANDATY"));
		Factory.getInstance().writeLogToLocal("[Pre Booking]editPreBooking initAfterReady:getParameter(\"ACTIONTYPE\").length()"
												+getParameter("ACTIONTYPE").length());
		if (getParameter("ACTIONTYPE") != null && getParameter("ACTIONTYPE").length() > 0) {
			currentAction = getParameter("ACTIONTYPE");
			setActionType(currentAction);
			resetParameter("ACTIONTYPE");
		}
		pbpID = null;
		if ((isModify() || isFetch()) && getParameter("PBPID") != null) {
			pbpID = getParameter("PBPID");
			fillPBInfo(pbpID);
		} else {
			initPBReady = true;
		}

		if ("TRU".equals(getParameter("isfromobbooking"))) {
			isFromOBBooking = true;
			bookStatus = getParameter("bcheckwaiting");
			if ("W".equals(bookStatus)) {
				getHeader().setVisible(true);
			}
//			fillPBInfo(getParameter("obpatno"));
		}
		if ("TRU-MOD".equals(getParameter("isfromobbooking"))) {
			bookStatus = getParameter("bcheckwaiting");
		}

		if ("S".equals(bookStatus)) {
			OBBookType = "W";
		} else {
			OBBookType = bookStatus;
		}

		isExitPanel = true;
		isMustConfirm = false;
		isWaitingList = false;
//		pSavePBOk = false;

// Start TBM_GETPARAMETER code
		paraFromWhere = getParameter("From");
//		String sobWardCode = null;

		enableButton();

		if (isFromOBBooking) {
			String sPatno = getParameter("obpatno");
			isNewPB = true;
			if (sPatno != null && !sPatno.isEmpty()) {
				getAJText_PatNo().setValue(sPatno);
				getPJLabel_FamilyName().focus();
			}
			getPJCheckBox_Doctor().setSelected(false);
			getPJCheckBox_Hospital().setSelected(false);
			getPJCheckBox_Special().setSelected(false);
			getPJCheckBox_Other().setSelected(false);
			getPJDate_SchdAdmDate().setText(getParameter("confinementdate"));
			getPJDate_SchdAdmDate().setEditable(false);
			if (!getPJDate_SchdAdmDate().isEmpty() && getPJDate_EDC().isEmpty()) {
				getPJDate_EDC().setText(getPJDate_SchdAdmDate().getText());
			}
			getPJCombo_Ward().setEditable(false);
			getPJCheckBox_ForDelivery().setSelected(true);
			getPJCheckBox_ForDelivery().setEditable(false);
			getPJCombo_Ward().setText(obWardcode);
			getPJCheckBox_BE().setSelected(true);
		} else {
			if (getParameter("Patno") != null && getParameter("Patno").length() > 0) {
				if (pbpID.isEmpty()) {
					isNewPB = true;
					getPJCheckBox_Doctor().setSelected(false);
					getPJCheckBox_Hospital().setSelected(false);
					getPJCheckBox_Special().setSelected(false);
					getPJCheckBox_Other().setSelected(false);
					if (getPJDate_SchdAdmDate().getText().isEmpty()) {
						getPJDate_SchdAdmDate().setText(getMainFrame().getServerDateTime());
					}
				} else {
					isNewPB = false;
					fillPBInfo(pbpID);
					cboWard_Change();
				}
			} else {
				getAJTextPatNoLostFocus();
			}
			getPJCheckBox_ForDelivery().setSelected(isDeliveryPB());
			getPJCheckBox_ForDelivery().setEditable(false);
		}

		oldHospDate = EMPTY_VALUE;
		if (!isNewPB) {
			if (isDeliveryPB() && "W".equals(OBBookType)) {
				getPJDate_SchdAdmDate().setEditable(false);
				getPJCombo_Ward().setEditable(false);
				oldHospDate = EMPTY_VALUE;
			} else {
				getPJDate_SchdAdmDate().setEditable(true);
				getPJDate_SchdAdmDate().setEditable(true);
				oldHospDate = getMainFrame().getServerDateTime();
			}
		}

		getPJCheckBox_Declined().setEditable(true);

		// field only for hkah
		boolean hkahOnly = HKAH_VALUE.equals(getUserInfo().getSiteCode());
		getRightJLabel_Misc().setVisible(hkahOnly);
		getRightJCombo_Misc().setVisible(hkahOnly);
		getRightJLabel_Source().setVisible(hkahOnly);
		getRightJCombo_Source().setVisible(hkahOnly);
		getRightJLabel_SourceNo().setVisible(hkahOnly);
		getRightJText_SourceNo().setVisible(hkahOnly);
		getRightJLabel_Package().setVisible(hkahOnly);
		getRightJCombo_Package().setVisible(hkahOnly);
		getRightButton_BudgetEst().setVisible(hkahOnly);
		getPJCheckBox_BEDesc().setVisible(hkahOnly);
		getPJCheckBox_BE().setVisible(hkahOnly);
		getPJText_Birthday().setVisible(false);
		getRightJLabel_DOB().setVisible(false);
		
		if (TWAH_VALUE.equals(getUserInfo().getSiteCode())) {
			getRightJLabel_Pkg().setText("Package");
			getRightJLabel_Pkg().setBounds(375, 145, 60, 20);
			getRightJCombo_Pkg().setBounds(505, 145, 225, 20);
		}

		if (referralCase) {
			getRightJLabel_Source().setText("<font color='blue'>Source</font>");
		} else {
			getRightJLabel_Source().setText("Source");
		}

		if (isCloseDlgARCardRemark || isCloseDlgARCardTypeSel) {
			getAJText_PolicyNo().focus();
		} else {
			getAJText_PatNo().focus();
		}
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
//	@Override
//	public Component getDefaultFocusComponent() {
//		// bug: UI will disappeared if getTabbedPane() is called
//		/*
//		if (isDeliveryPB()) {
//			if (getTabbedPane().getSelectedIndex() == 1) {
//				return getFa_AJText_PatNo();
//			} else if (getTabbedPane().getSelectedIndex() == 2) {
//				return getCheck1();
//			} else {
//				return getAJText_PatNo();
//			}
//		} else {
//			return getAJText_PatNo();
//		}
//		*/
//
//		if (isCloseDlgARCardRemark||isCloseDlgARCardTypeSel) {
//			return getAJText_PolicyNo();
//		} else {
//			return getAJText_PatNo();
//		}
//	}

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
		return new String[] {
				isAppend() ? EMPTY_VALUE : pbpID,  //index=0,PBPID
				getAJText_PatNo().getText(),
				getPJCombo_Sex().getText(),
				getAJText_Document().getText(),
				getAJText_GivenName().getText(),
				getAJText_FamilyName().getText(),
				getAJText_ContactPhone().getText(),
				getAJText_ChineseName().getText(),
				getAJText_MobilePhone().getText(),
				getPJCombo_ACM().getText(),
				getPJDate_SchdAdmDate().getText(),
				getPJCombo_OrderByDoctor().getText(),
				isDeliveryPB()?"-1":"0",
				getPJCheckBox_MainCitizen().isSelected()?"-1":"0",
				getPJCombo_Ward().getText(),
				getAJText_PBORemark().getText(),
				getAJText_CathLabRemark().getText(),
				getPJCombo_BedCode().getText(),
				getPJDate_AvailableTime().getText(),
				// ArCode
				getPJCombo_ArCode().getText(),
				getAJText_PolicyNo().getText(),
				getPJCombo_PaymentType().getText(),
				getAJText_PaymentType().getText(),
				getAJText_VoucherNo().getText(),
				getAJText_PreAuthNo().getText(),
				getAJText_InsCoverageEndDate().getText(),
				getAJText_LimitAmount().getText(),
				getAJText_GuarAmt().getText(),
				getAJText_GuarDate().getText(),
				// Cover Item
				getPJCheckBox_Doctor().isSelected()?"-1":"0",
				getPJCheckBox_Hospital().isSelected()?"-1":"0",
				getPJCheckBox_Special().isSelected()?"-1":"0",
				getPJCheckBox_Other().isSelected()?"-1":"0",
				getPJCheckBox_Declined().isSelected()?"-1":"0", //ISREFUSED
				getAJText_Reacon().getText(), // index = 31 ,total=32
				//REFUSEDUSERID
				((OriRefuseStatus != getPJCheckBox_Declined().isSelected())&&PJCheckBox_Declined.isSelected())?getUserInfo().getUserID():refusedUserID,
				//REFUSEDDATE
				((OriRefuseStatus != getPJCheckBox_Declined().isSelected())&&PJCheckBox_Declined.isSelected())?getMainFrame().getServerDateTime():getAJText_By1().getText(),
				//ACTIVATEDUSERID
				((OriRefuseStatus != getPJCheckBox_Declined().isSelected())&& !PJCheckBox_Declined.isSelected())?getUserInfo().getUserID():activatedUserID,
				//ACTIVATEDDATE
				((OriRefuseStatus != getPJCheckBox_Declined().isSelected())&& !PJCheckBox_Declined.isSelected())?getMainFrame().getServerDateTime():getAJText_ActivatedBy1().getText(),
				OBBookType,
				//EMPTY_VALUE,//PBPNO
				getUserInfo().getUserID(),
				getUserInfo().getSiteCode(),
				getAJText_Stay().getText(),
				getPJCombo_DocType().getText(),
				//baby's father
				getFa_AJText_PassportNo().getText(),
				getFa_AJText_PassportType().getText(),
				getFa_AJText_GivenName().getText(),
				getFa_AJText_FamilyName().getText(),
				getFa_AJText_PatNo().getText(),
				getFa_AJText_Document().getText(),
				getFa_AJText_ChineseName().getText(),
				getFa_AJText_DOB().getText(),
				getFa_AJText_ContactPhone().getText(),
				getFa_AJText_Holder().getText(),
				getFa_AJText_Residence().getText(),
				getFa_AJText_EDOB().getText(),
				getFa_AJText_InfoSource().getText(),
				//Antenatal check-up
				getCheck1().getText(),
				getCheck2().getText(),
				getCheck3().getText(),
				getCheck4().getText(),
				getCheck5().getText(),
				getCheck6().getText(),
				getCheck7().getText(),
				getCheck8().getText(),
				getCheck9().getText(),
				getCheck10().getText(),
				isMustConfirm ? YES_VALUE : NO_VALUE,
				isWaitingList ? YES_VALUE : NO_VALUE,
				getAJText_OtRemark().getText(),
				isDeliveryPB() ? YES_VALUE : NO_VALUE,
				memActID, //arCard
				getRightJCombo_Misc().getText(), //misc
				getRightJCombo_Source().getText(),
				getRightJText_SourceNo().getText(),
				getPJCheckBox_Revlog().isSelected()?"-1":"0",
				getRightJCombo_LogCvrCls().getText(),
				"D".equals(memBpbRegType)?null:getRightJCombo_Package().getText(),
				getPJCheckBox_EstGiven().isSelected()?"-1":"0",
				getAJText_CoPayActualAmount().getText(),
				getPJDate_EDC().getText(),
				getPJCheckBox_BE().isSelected()?"-1":"0",
				isAppend() ? memBpbRegType != null ? memBpbRegType : "" : null,  //Default OB is inpat
				getRightJCombo_Pkg().getText()		
		};
	}

	/* >>> ~16.1~ Set Action Output Parameters =========================== <<< */
	@Override
	protected void getNewOutputValue(String returnValue) {}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(final String actionType) {
//		boolean returnValue = true;
		isCloseDlgARCardRemark = false;
		isCloseDlgARCardTypeSel = false;

		if (isDeliveryPB() && !isNewPB) {
			if (!oldHospDate.isEmpty()) {
				if (DateTimeUtil.dateDiff(getPJDate_SchdAdmDate().getText().substring(0, 10),
						oldHospDate.substring(0, 10)) == 1 ||
					DateTimeUtil.dateDiff(getPJDate_SchdAdmDate().getText().substring(0, 10),
						oldHospDate.substring(0, 10)) == -1) {
					final String obWaitingcnt = getSysParameter("obwaitcnt");

					QueryUtil.executeMasterFetch(getUserInfo(), "WAITINGBOOKCNT",
							new String[] { getPJDate_SchdAdmDate().getText().substring(0, 10) },
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								int curWaitingcnt = Integer.parseInt(mQueue.getContentField()[0]);
								int obBookCnt = Integer.parseInt(mQueue.getContentField()[1]);
								int TotalCnt = Integer.parseInt(mQueue.getContentField()[2]);
								int iobWaitingcnt = 0;
								try{
									iobWaitingcnt = Integer.parseInt(obWaitingcnt);
								}catch(Exception e) {
									iobWaitingcnt = 0;
								}

								if (TotalCnt == 0) {
									actionValidation1(actionType);
								} else {
									if (TotalCnt+1>iobWaitingcnt) {
										MessageBoxBase.confirm(MSG_PBA_SYSTEM, "There are " + obBookCnt + " booked and " + curWaitingcnt + " are in waiting list.  Do you want to save this record?",
												new Listener<MessageBoxEvent>() {
											@Override
											public void handleEvent(MessageBoxEvent be) {
												if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
													actionValidation1(actionType);
												}
											}
										});
									} else {
										actionValidation1(actionType);
									}
								}
							}
						}
					});
				} else {
					actionValidation1(actionType);
				}
			} else {
				actionValidation1(actionType);
			}
		} else {
			actionValidation1(actionType);
		}
	}

	protected void  actionValidation1(String actionType) {
		boolean returnValue = true;
		if (getAJText_PatNo().isEmpty()
				&& getAJText_FamilyName().isEmpty()
				&& getAJText_Document().isEmpty()) {
			Factory.getInstance().addErrorMessage("Please input Patient no/Document#/Family name.", getAJText_PatNo());
			if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
			return;
//		} else if (getPJCombo_DocType().isEmpty()) {
//			Factory.getInstance().addErrorMessage("Please input Patient Document Type.", getPJCombo_DocType());
//			getTabbedPane().setSelectedIndex(0);
//			return;
		} else if (getPJCombo_OrderByDoctor().isEmpty()) {
			Factory.getInstance().addErrorMessage("Please input Doctor Code.", getPJCombo_OrderByDoctor());
			if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
			return;
		} else if (!getPJCombo_OrderByDoctor().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid Doctor Code.", getPJCombo_OrderByDoctor());
			if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
			return;
		} else if (getPJCombo_Sex().isEmpty()) {
			Factory.getInstance().addErrorMessage("Please input Sex.", getPJCombo_Sex());
			if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
			return;
		} else if (getPJDate_SchdAdmDate().isEmpty()) {
			Factory.getInstance().addErrorMessage("Please input Hospital Date.", getPJDate_SchdAdmDate());
			if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
			return;
		} else if (!getPJDate_SchdAdmDate().isValid()) {
			Factory.getInstance().addErrorMessage("Hospital Date is invalid.", getPJDate_SchdAdmDate());
			if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
			return;
		} else if (referralCase && getRightJCombo_Source().isEmpty()) {
			Factory.getInstance().addErrorMessage("Please input source.", getRightJCombo_Source());
			if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
			return;
		} else if (!getPJCombo_ArCode().isEmpty() && !getPJCombo_ArCode().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid Arcode.", getPJCombo_ArCode());
			if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
			return;
		} else if (!getAJText_InsCoverageEndDate().isEmpty() && !getAJText_InsCoverageEndDate().isValid()) {
			Factory.getInstance().addErrorMessage("Coverage End Date is invalid.", getAJText_InsCoverageEndDate());
			if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
			return;
		}

		int insuranceAmount = 0;
		int guaranteeAmount = 0;
		if (!getAJText_LimitAmount().isEmpty()) {
			insuranceAmount = Integer.parseInt(getAJText_LimitAmount().getText());
			if (insuranceAmount < 0) {
				Factory.getInstance().addErrorMessage("Insurance Amount Limit can't be less than 0.", getAJText_LimitAmount());
				if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
				return;
			}
		}

		if (!getAJText_GuarAmt().isEmpty()) {
			guaranteeAmount = Integer.parseInt(getAJText_GuarAmt().getText());
			if (guaranteeAmount < 0) {
				Factory.getInstance().addErrorMessage("Further Guarantee Amount can't be less than 0.", getAJText_GuarAmt());
				if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
				return;
			}
		}

		if (!getAJText_LimitAmount().isEmpty() && !getAJText_GuarAmt().isEmpty() && guaranteeAmount > insuranceAmount) {
			Factory.getInstance().addErrorMessage("Further Guarantee Amount should less than or equal to Insurance Limit Amount.", getAJText_GuarAmt());
			if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
			return;
		} else if (!getAJText_GuarDate().isEmpty() && !getAJText_GuarDate().isValid()) {
			Factory.getInstance().addErrorMessage("Further Guarantee Date is invalid.", getAJText_GuarDate());
			if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
			return;
		}

		if (getPJCombo_BedCode().isEmpty() && YES_VALUE.equals(getSysParameter("BEDCDEMUST"))) {
			Factory.getInstance().addErrorMessage("Please input Bed Code.", getPJCombo_BedCode());
			if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
			return;
		}

		if (getAJText_Stay().isEmpty() && YES_VALUE.equals(getSysParameter("ESTLENMUST"))) {
			Factory.getInstance().addErrorMessage("Please input Estimated Length of Stay.", getAJText_Stay());
			if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
			return;
		} else if (!getAJText_Stay().isEmpty() && Integer.parseInt(getAJText_Stay().getText()) < 0) {
			if (YES_VALUE.equals(getSysParameter("ESTLENMUST"))) {
				Factory.getInstance().addErrorMessage("Estimated Length of Stay should be > 0", getAJText_Stay());
			} else {
				Factory.getInstance().addErrorMessage("Estimated Length of Stay should be > 0 or null", getAJText_Stay());
			}
			if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
			return;
		}

		if (!getPJCombo_PaymentType().isEmpty() && !getAJText_PaymentType().isEmpty()) {
			int paymentAmount = Integer.parseInt(getAJText_PaymentType().getText());
			if (getPJCombo_PaymentType().getText().equals("AMT") && paymentAmount < 0) {
				Factory.getInstance().addErrorMessage("The Co-Payment Amount can't be less than 0.", getAJText_PaymentType());
				if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
				return;
			} else if (getPJCombo_PaymentType().getText().equals("%") && (paymentAmount < 0 || paymentAmount > 100)) {
				Factory.getInstance().addErrorMessage("The Co-Payment Amount should be within 0 to 100.", getAJText_PaymentType());
				if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
				return;
			}
		}

		if (getPJCheckBox_Declined().isSelected() && getAJText_Reacon().isEmpty()) {
			Factory.getInstance().addErrorMessage("Please input Declined Reason.", getAJText_Reacon());
			if (isDeliveryPB()) getTabbedPane().setSelectedIndex(0);
			return;
		}
		actionValidationReady(actionType, returnValue);
	}

	@Override
	protected void proExitPanel() {
		setParameter("NewPB",isAppend() ? "True" : "False");
		setParameter("CONFINEMENTDATE", EMPTY_VALUE);
		setParameter("OBPatNo", EMPTY_VALUE);
		setParameter("BCHECKWAITING", EMPTY_VALUE);
		setParameter("From",paraFromWhere);
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	protected boolean isDeliveryPB() {
		return getPJCheckBox_ForDelivery().isSelected();
	}

	private void fillPBInfo(String pbpid) {
		QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.BEDPREBOK_TXCODE,
				new String[] { pbpid }, new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				// TODO Auto-generated method stub
				if (mQueue.success()) {
					String[] outParam = mQueue.getContentField();
					getPJCombo_OrderByDoctor().setText(outParam[1]);
					getPJDate_SchdAdmDate().setText(outParam[3]);
					getPJDate_EDC().setText(outParam[79]);
					getAJText_PatNo().setText(outParam[7]);
					getAJText_ChineseName().setText(outParam[9]);
					getPJCombo_ACM().setText(outParam[10]);
					getPJCombo_Ward().setText(outParam[11]);
					getAJText_PBORemark().setText(outParam[12]);
					memArcCode = outParam[14];
					getPJCombo_ArCode().setText(outParam[14]);
					memActID = outParam[80];
					getRightJText_ARCardType().setText(outParam[81]);
					getRightJText_ARCompanyDesc().setText(outParam[82]);
					getPJCombo_PaymentType().setText(outParam[15]);
					getAJText_PaymentType().setText(outParam[16]);
					getAJText_PolicyNo().setText(outParam[17]);
					getAJText_InsCoverageEndDate().setText(outParam[18]);
					getAJText_LimitAmount().setText(outParam[19]);
					getAJText_GuarAmt().setText(outParam[20]);
					getAJText_GuarDate().setText(outParam[21]);
					getPJCheckBox_Doctor().setSelected("-1".equals(outParam[22]));
					getPJCheckBox_Special().setSelected("-1".equals(outParam[23]));
					getPJCheckBox_Hospital().setSelected("-1".equals(outParam[24]));
					getPJCheckBox_Other().setSelected("-1".equals(outParam[25]));
					getAJText_VoucherNo().setText(outParam[26]);
					getAJText_PreAuthNo().setText(outParam[93]);
					getAJText_FamilyName().setText(outParam[27]);
					getAJText_GivenName().setText(outParam[28]);
					getPJCheckBox_MainCitizen().setSelected("-1".equals(outParam[29]));
					getPJCheckBox_ForDelivery().setSelected("-1".equals(outParam[30]));
					getAJText_ContactPhone().setText(outParam[31]);
					getAJText_MobilePhone().setText(outParam[32]);
					getAJText_Document().setText(outParam[33]);
					getAJText_CathLabRemark().setText(outParam[36]);
					getPJCombo_BedCode().setText(outParam[37]);
					getPJDate_AvailableTime().setText(outParam[38]);
					getPJCombo_Sex().setText(outParam[39]);
					memIsRefuse = "-1".equals(outParam[43]);
					getPJCheckBox_Declined().setSelected(memIsRefuse); //ISREFUSED
					getAJText_Reacon().setText(outParam[44]); // index = 31 ;total=32
					getAJText_By().setText(outParam[45]);
					getAJText_By1().setText(outParam[46]);
					getAJText_ActivatedBy().setText(outParam[47]);
					getAJText_ActivatedBy1().setText(outParam[48]);
					getAJText_Stay().setText(outParam[49]);
					getPJCombo_DocType().setText(outParam[50]);

					//Baby's Father info
					getFa_AJText_PassportNo().setText(outParam[51]);
					getFa_AJText_PassportType().setText(outParam[52]);
					getFa_AJText_GivenName().setText(outParam[53]);
					getFa_AJText_FamilyName().setText(outParam[54]);
					getFa_AJText_PatNo().setText(outParam[57]);
					getFa_AJText_Document().setText(outParam[58]);
					getFa_AJText_ChineseName().setText(outParam[59]);
					getFa_AJText_DOB().setText(outParam[60]);
					getFa_AJText_ContactPhone().setText(outParam[61]);
					getFa_AJText_Holder().setText(outParam[62]);
					getFa_AJText_Residence().setText(outParam[63]);
					getFa_AJText_EDOB().setText(outParam[64]);
					getFa_AJText_InfoSource().setText(outParam[65]);

					//Antenatal Check-up
					getCheck1().setText(outParam[66]);
					getCheck2().setText(outParam[67]);
					getCheck3().setText(outParam[68]);
					getCheck4().setText(outParam[69]);
					getCheck5().setText(outParam[70]);
					getCheck6().setText(outParam[71]);
					getCheck7().setText(outParam[72]);
					getCheck8().setText(outParam[73]);
					getCheck9().setText(outParam[74]);
					getCheck10().setText(outParam[75]);

					refusedUserID = outParam[76];
					activatedUserID = outParam[77];

					getAJText_OtRemark().setText(outParam[78]);

					OBBookType = outParam[34];
					oldHospDate = outParam[3].substring(0, 10);
					OriRefuseStatus = "-1".equals(outParam[41]);

					BPBSTS = outParam[5];

					getRightJCombo_Misc().setText(outParam[83]); //misc
					getRightJCombo_Source().setText(outParam[84]);
					getRightJText_SourceNo().setText(outParam[85]);
					getPJCheckBox_Revlog().setSelected("-1".equals(outParam[86]));
					getRightJCombo_LogCvrCls().setText(outParam[87]);
					if ("D".equals(memBpbRegType)) {
						getPJText_Birthday().setText(outParam[88]);
					} else {
						getRightJCombo_Package().setText(outParam[88]);
					}
					getPJCheckBox_EstGiven().setSelected("-1".equals(outParam[89]));
					getAJText_CoPayActualAmount().setText(outParam[90]);
					memFestID = outParam[91];
					if (!"".equals(memFestID)) {
						getRightButton_BudgetEst().el().addStyleName("button-alert-green");
					} else {
						getRightButton_BudgetEst().el().removeStyleName("button-alert-green");
					}
					getPJCheckBox_BE().setSelected("-1".equals(outParam[92]));
//					sPreArcCde = outParam[14];
					getRightJCombo_Pkg().setText(outParam[94]);	
					enableMiddlePanel();
					enableDeclinePanel();

					cboWard_Change();
				}
			}
		});
	}

	private void cboWard_Change() {
		if ((!isDeliveryPB()) && getPJCombo_Ward().getText().equals(obWardcode)) {
			getWarningMsg().setText("This booking is not for delivery!");
		} else {
			getWarningMsg().resetText();
		}
	}

	private void showPatInfo(final String patno) {
		QueryUtil.executeMasterFetch(getUserInfo(), "PATIENTBYNO",
				new String[] { patno },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getAJText_FamilyName().setText(mQueue.getContentField()[0]);
					getAJText_GivenName().setText(mQueue.getContentField()[1]);
					getAJText_Document().setText(mQueue.getContentField()[2]);
					getAJText_ContactPhone().setText(mQueue.getContentField()[4]);
					getPJCombo_Sex().setText(mQueue.getContentField()[5]);
					getAJText_ChineseName().setText(mQueue.getContentField()[6]);
					getAJText_MobilePhone().setText(mQueue.getContentField()[7]);

					if (isFromOBBooking) {
						funname = "OB Booking -> Search Patient No";
					} else {
						funname = "Pre-Booking -> Search Patient No";
					}
					getAlertCheck().checkAltAccess(patno, funname, true, true, null);
				} else {
					Factory.getInstance().addErrorMessage("Patient No doesn't exist");
					getAJText_PatNo().resetText();
					getAJText_FamilyName().resetText();
					getAJText_GivenName().resetText();
					getAJText_Document().resetText();
					getAJText_ContactPhone().resetText();
					getPJCombo_Sex().setSelectedIndex(0);
					getAJText_ChineseName().resetText();
					getAJText_MobilePhone().resetText();
				}
			}
		});
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
//						String doccode = mQueue.getContentField()[0];
						String docCtdate = mQueue.getContentField()[1];
						String docSts = mQueue.getContentField()[2];
//						String labelDesc = null;
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

	private void showFaPatInfo(String patno) {
		QueryUtil.executeMasterFetch(getUserInfo(), "PATIENTBYNO",
				new String[] { patno },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getFa_AJText_FamilyName().setText(mQueue.getContentField()[0]);
					getFa_AJText_GivenName().setText(mQueue.getContentField()[1]);
					getFa_AJText_Document().setText(mQueue.getContentField()[2]);
					getFa_AJText_DOB().setText(mQueue.getContentField()[3]);
					getFa_AJText_ChineseName().setText(mQueue.getContentField()[6]);
					getFa_AJText_ContactPhone().setText(mQueue.getContentField()[7]);
				} else {
					Factory.getInstance().addErrorMessage("Patient No doesn't exist");
					getFa_AJText_PatNo().resetText();
					getFa_AJText_FamilyName().resetText();
					getFa_AJText_GivenName().resetText();
					getFa_AJText_Document().resetText();
					getFa_AJText_DOB().resetText();
					getFa_AJText_ChineseName().resetText();
					getFa_AJText_ContactPhone().resetText();
				}
			}
		});
	}

	private void retrieveAR() {
		QueryUtil.executeMasterFetch(getUserInfo(), "ARCODEBYACODE",
				new String[] {getPJCombo_ArCode().getText(), null, null},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getPJCombo_PaymentType().setText(mQueue.getContentField()[0]);
					getAJText_LimitAmount().setText(mQueue.getContentField()[2]);
					getAJText_InsCoverageEndDate().setText(mQueue.getContentField()[3]);
					getAJText_PaymentType().setText(mQueue.getContentField()[1]);
					getAJText_GuarAmt().setText(mQueue.getContentField()[8]);
					getAJText_GuarDate().setText(mQueue.getContentField()[9]);
					getPJCheckBox_Doctor().setSelected("-1".equals(mQueue.getContentField()[4]));
					getPJCheckBox_Hospital().setSelected("-1".equals(mQueue.getContentField()[5]));
					getPJCheckBox_Special().setSelected("-1".equals(mQueue.getContentField()[6]));
					getPJCheckBox_Other().setSelected("-1".equals(mQueue.getContentField()[7]));
					getRightJText_ARCompanyDesc().setText(mQueue.getContentField()[10]);
				}
			}
		});
	}

	private void savePB(final boolean showMessage) {
		Factory.getInstance().writeLogToLocal("[Pre Booking]editPreBooking savePB:getParameter(\"ACTIONTYPE\").length()"
				+getParameter("ACTIONTYPE").length()+" isAppend():"+Boolean.toString(isAppend()));
		QueryUtil.executeMasterAction(getUserInfo(), ConstantsTx.BEDPREBOK_TXCODE, isAppend() ? QueryUtil.ACTION_APPEND : QueryUtil.ACTION_MODIFY,
				getActionInputParamaters(), new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					Map<String, String> params = new HashMap<String, String>();
					params.put("Ward", getPJCombo_Ward().getText());
					params.put("Order by Doctor", getPJCombo_OrderByDoctor().getDisplayText());
					params.put("Schd Adm Date", getPJDate_SchdAdmDate().getText());
					String patno = getAJText_PatNo() != null ? getAJText_PatNo().getText().trim() : "";
					if (isFromOBBooking) {
						if (isAppend()) {
							funname = "OB Booking -> New";
						} else {
							funname = "OB Booking -> Edit";
						}
					} else {
						if (isAppend()) {
							funname = "Pre-Booking -> New";
						} else {
							funname = "Pre-Booking -> Edit";
						}
					}

					if (isAppend()) {
						if ("999".equals(mQueue.getReturnCode())) {
							Factory.getInstance().addInformationMessage("Waiting List Booking is created");
							exitPanel(true);
							return;
						} else {
							pbpID = mQueue.getReturnCode();
							savePBReady(true, isAppend(), showMessage, mQueue.getReturnCode());
						}
					} else {
						savePBReady(true, isAppend(), showMessage, pbpID);
					}

					getAlertCheck().checkAltAccess(patno, funname, false, true, params);

					setActionType(null);
					fillPBInfo(pbpID);
					enableButton();
				} else {
					if (isAppend() && "-100".equals(mQueue.getReturnCode())) {
						MessageBoxBase.confirm(MSG_PBA_SYSTEM, mQueue.getReturnMsg(),
								new Listener<MessageBoxEvent>() {
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									// change to waiting booking
									isMustConfirm = false;
									isWaitingList = true;
									getHeader().setVisible(true);
									enableWaitingQueuePanel(true);
									savePB(true);
								} else {
									MessageBoxBase.confirm(MSG_PBA_SYSTEM, "Force to Confirm Booking?",
											new Listener<MessageBoxEvent>() {
										@Override
										public void handleEvent(MessageBoxEvent be) {
											if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
												isMustConfirm = true;
												isWaitingList = false;
												getHeader().setVisible(false);
												enableWaitingQueuePanel(false);
												savePB(true);
											}
										}
									});
								}
							}
						});
					} else {
						Factory.getInstance().addErrorMessage(mQueue.getReturnMsg());
					}
				}
			}
		});
	}

	private void checkWardReady(int maxMPreBok, int maxDPreBok, int curMPreBok, int curDPreBok) {
		final String curHostDateDD = getPJDate_SchdAdmDate().getText().substring(0, 10);
		if ((maxMPreBok >= 0 || maxDPreBok >= 0) && getPJCombo_Ward().getText().equalsIgnoreCase(obWardcode) && isDeliveryPB()) {
			StringBuffer message  = new StringBuffer();
			if (maxMPreBok >= 0 && maxDPreBok >= 0) {
				if (curMPreBok < maxMPreBok && curDPreBok < maxDPreBok) {
					// day & month both not exceed
					savePB(true);
				} else if (curMPreBok >= maxMPreBok && curDPreBok >= maxDPreBok) {
					// day & month both exceed
					message.append("There are ");
					message.append(curMPreBok);
					message.append(" patients booked already in unit ");
					message.append(getPJCombo_Ward().getText());
					message.append(" and the maximum number allowed is ");
					message.append(maxMPreBok);
					message.append(". for the month of ");
					message.append(curHostDateDD.substring(3, 10));
					message.append(". There are ");
					message.append(curDPreBok);
					message.append(" patients booked already in unit ");
					message.append(PJCombo_Ward.getText());
					message.append(" and the maximum number allowed is ");
					message.append(maxDPreBok);
					message.append(".  for this date ");
					message.append(curHostDateDD);
					message.append("\nDo you want to book this anyway?");
					MessageBoxBase.confirm(MSG_PBA_SYSTEM, message.toString(),
							new Listener<MessageBoxEvent>() {
						@Override
						public void handleEvent(MessageBoxEvent be) {
							if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
								savePB(true);
							}
						}
					});
				} else if (curMPreBok >= maxMPreBok && curDPreBok < maxDPreBok) {
					// month exceed only
					message.append("There are ");
					message.append(curMPreBok);
					message.append(" patients booked already in unit ");
					message.append(getPJCombo_Ward().getText());
					message.append(" and the maximum number allowed is ");
					message.append(maxMPreBok);
					message.append(".  for the month of ");
					message.append(curHostDateDD.substring(3, 10));
					message.append("\nDo you want to book this anyway?");
					MessageBoxBase.confirm(MSG_PBA_SYSTEM, message.toString(),
							new Listener<MessageBoxEvent>() {
						@Override
						public void handleEvent(MessageBoxEvent be) {
							if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
								savePB(true);
							}
						}
					});
				} else if (curMPreBok < maxMPreBok && curDPreBok >= maxDPreBok) {
					// day exceed only
					message.append("There are ");
					message.append(curDPreBok);
					message.append(" patients booked already in unit ");
					message.append(getPJCombo_Ward().getText());
					message.append(" and the maximum number allowed is ");
					message.append(maxDPreBok);
					message.append(". for this date ");
					message.append(curHostDateDD);
					message.append(".\nDo you want to book this anyway?");
					MessageBoxBase.confirm(MSG_PBA_SYSTEM, message.toString(),
							new Listener<MessageBoxEvent>() {
						@Override
						public void handleEvent(MessageBoxEvent be) {
							if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
								savePB(true);
							}
						}
					});
				}
			} else if (maxMPreBok >= 0 && maxDPreBok < 0) {
				if (curMPreBok < maxMPreBok) {
					savePB(true);
				} else if (curMPreBok >= maxMPreBok) {
					message.append("There are ");
					message.append(curMPreBok);
					message.append(" patients booked already in unit ");
					message.append(getPJCombo_Ward().getText());
					message.append(" and the maximum number allowed is ");
					message.append(maxMPreBok);
					message.append(". for the month of ");
					message.append(curHostDateDD.substring(3, 10));
					message.append(".\nDo you want to book this anyway?");
					MessageBoxBase.confirm(MSG_PBA_SYSTEM, message.toString(),
							new Listener<MessageBoxEvent>() {
						@Override
						public void handleEvent(MessageBoxEvent be) {
							if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
								savePB(true);
							}
						}
					});
				}
			} else if (maxMPreBok < 0 && maxDPreBok >= 0) {
				if (curDPreBok < maxDPreBok) {
					savePB(true);
				} else if (curDPreBok >= maxDPreBok) {
					message.append("There are ");
					message.append(curDPreBok);
					message.append(" patients booked already in unit ");
					message.append(getPJCombo_Ward().getText());
					message.append(" and the maximum number allowed is ");
					message.append(maxDPreBok);
					message.append("  for this date ");
					message.append(curHostDateDD);
					message.append("\nDo you want to book this anyway?");
					MessageBoxBase.confirm(MSG_PBA_SYSTEM, message.toString(),
							new Listener<MessageBoxEvent>() {
						@Override
						public void handleEvent(MessageBoxEvent be) {
							if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
								savePB(true);
							}
						}
					});
				}
			}
		} else {
			savePB(false);
		}
	}

	private void checkWard() {
		String curHostDateDD = getPJDate_SchdAdmDate().getText().substring(0, 10);
		QueryUtil.executeMasterFetch(getUserInfo(), "PREBOOKING", new String[] {curHostDateDD},
				new MessageQueueCallBack() {
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					checkWardReady(
							Integer.parseInt(mQueue.getContentField()[0]),
							Integer.parseInt(mQueue.getContentField()[1]),
							Integer.parseInt(mQueue.getContentField()[2]),
							Integer.parseInt(mQueue.getContentField()[3]));
				}
			}
		});
	}

	private void save() {
		if (isModify() && isDeliveryPB() && (oldHospDate == null || oldHospDate.length() == 0 || oldHospDate.equals(PJDate_SchdAdmDate.getText().substring(0, 10)))) {
			savePB(false);
		} else {
			checkWard();
		}
	}

	private void savePBReady(boolean isReady, final boolean isAppend, final boolean showMessage, final String pbpid) {
		if (isReady && isDeliveryPB()) {
			final String curHostDateDD = getPJDate_SchdAdmDate().getText().substring(0, 10);
			QueryUtil.executeMasterFetch(getUserInfo(), "PREBOOKING", new String[] {curHostDateDD},
					new MessageQueueCallBack() {
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						// change status
						currentAction = EMPTY_VALUE;
						cancelYesAction();
						// print ob letter
						if (showMessage) {
							String dStr = curHostDateDD.substring(0, 10);
							String curHostDateDDMth = DateTimeUtil.formatPbMsgDateTime(DateTimeUtil.parseDate(dStr));

							StringBuffer message  = new StringBuffer();
							message.append("<html>There are ");
							message.append(mQueue.getContentField()[2]);
							message.append(" patients booked in unit ");
							message.append(getPJCombo_Ward().getText());
							message.append(" for the month of ");
							message.append(curHostDateDDMth);
							message.append("<br>There are ");
							message.append(mQueue.getContentField()[3]);
							message.append(" patients booked in unit ");
							message.append(getPJCombo_Ward().getText());
							message.append(" for this date ");
							message.append(curHostDateDD);
							message.append("</html>");

							MessageBoxBase.addWarningMessage("PBA - [Add New Pre-Booking]", message.toString(), new Listener<MessageBoxEvent>() {
								public void handleEvent(MessageBoxEvent be) {
									if (Dialog.OK.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
										checkPrint(isAppend, pbpid);
									}
								}
							});
						} else {
							checkPrint(isAppend, pbpid);
						}
					}
				}
			});
		}
	}

	private void checkPrint(final boolean isAppend, final String pbpid) {
		QueryUtil.executeMasterFetch(getUserInfo(), "SYSPARAM", new String[] {"obprint"},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					if ("YES".equals(mQueue.getContentField()[1]) && isDeliveryPB()) {
						MessageBoxBase.confirm(MSG_PBA_SYSTEM, "Do you want the booking letter to be printed?",
								new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									//print..   obBooking.PrintBooking (doPB.Fields("pbpid"))
									HashMap<String, String> map = new HashMap<String, String>();
									map.put("Image", CommonUtil.getReportImg("rpt_logo2.jpg"));
									PrintingUtil.print(
											"OBBooking_"+Factory.getInstance().getUserInfo().getSiteCode(),
											map,"",new String[] {pbpid},
											new String[] {"PATNAME","PATCNAME","BPBHDATE",
											"BPBNO","DOCNAME","DOCFAXNO","DOCOTEL","PRINTDATE"});

									isExitPanel = isAppend && isFromOBBooking;
								} else {
									if (isAppend && isFromOBBooking) {
										exitPanel(true);
									} else {
										enableButton();
									}
								}
							}
						});
					} else if (isAppend && isFromOBBooking) {
						exitPanel(true);
					} else {
						cancelAction();
					}
				}
			}
		});
	}

	private void enableMiddlePanel() {
		enableMiddlePanel(!getPJCombo_ArCode().isEmpty());
	}

	private void enableMiddlePanel(boolean enable) {
		if (getActionType() != null) {
			if (Factory.getInstance().getSysParameter("ArBlockEvt").length() == 0) {
				PanelUtil.setAllFieldsEditable(getMiddlePanel(), enable);
			}
			else {
				PanelUtil.setAllFieldsEditable(getMiddlePanel(), true);
			}
			getMiddlePanel().setEnabled(true);
			getPJCombo_ArCode().setEditable(true);
		} else {
			PanelUtil.setAllFieldsEditable(getMiddlePanel(), false);
		}
	}

	private void enableDeclinePanel() {
		enableDeclinePanel(getPJCheckBox_Declined().isSelected());
	}

	private void enableDeclinePanel(boolean enable) {
		if (getActionType() != null) {
			getAJText_Reacon().setEditable(enable);
			if (!memIsRefuse) {
				if (enable && getAJText_By().isEmpty()) {
					refusedUserID = getUserInfo().getUserID();
					getAJText_By().setText(getUserInfo().getUserName());
					getAJText_By1().setText(getMainFrame().getServerDateTime());
				}
			} else {
				if (!enable && !getAJText_By().isEmpty()) {
					activatedUserID = getUserInfo().getUserID();
					getAJText_ActivatedBy().setText(getUserInfo().getUserName());
					getAJText_ActivatedBy1().setText(getMainFrame().getServerDateTime());
				}
			}
			getAJText_Reacon().setEditable(enable);
			getAJText_By().setEnabled(enable);
			getAJText_By1().setEnabled(enable);
			getAJText_ActivatedBy().setEnabled(!enable);
			getAJText_ActivatedBy1().setEnabled(!enable);
		} else {
			PanelUtil.setAllFieldsEditable(getDeclinePanel(), false);
		}
	}

	private void enableWaitingQueuePanel(boolean enable) {
		getPJCombo_DocType().setEditable(!enable);
		getPJCombo_ACM().setEditable(!enable);
		getAJText_CathLabRemark().setEditable(!enable);
		getPJCombo_BedCode().setEditable(!enable);
		getPJDate_AvailableTime().setEditable(!enable);
		getAJText_Stay().setEditable(!enable);
		enableMiddlePanel(!enable);
		enableDeclinePanel(!enable);
		getFa_AJText_EDOB().setEditable(!enable);
		getFa_AJText_Residence().setEditable(!enable);
		getFa_AJText_InfoSource().setEditable(!enable);
		getCheck6().setEditable(!enable);
		getCheck7().setEditable(!enable);
		getCheck8().setEditable(!enable);
		getCheck9().setEditable(!enable);
		getCheck10().setEditable(!enable);
	}

	private void getAJTextPatNoLostFocus() {
		if ((!AJText_PatNo.getText().equals(curPatNo)) && !AJText_PatNo.isEmpty()) {
			curPatNo = AJText_PatNo.getText();
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] { "patient", "death", "patno= '" + curPatNo + "'" },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue chkDeath) {
					if (chkDeath.success()) {
						if (chkDeath.getContentField()[0].length() > 0) {
							MessageBoxBase.confirm(MSG_PBA_SYSTEM," Current patient is dead.Continue?",
									new Listener<MessageBoxEvent>() {
								@Override
								public void handleEvent(MessageBoxEvent be) {
									if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
										if (pbpID == null || pbpID.length() == 0) {
											showPatInfo(curPatNo);
										}
									} else {
										AJText_PatNo.resetText();
										AJText_PatNo.focus();
									}
								}
							});
						} else {
							if (pbpID == null || pbpID.length() == 0) {
								showPatInfo(curPatNo);
							}
						}
					} else {
						if (pbpID == null || pbpID.length() == 0) {
							showPatInfo(curPatNo);
						}
					}
				}
			});
		}
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected void actionValidationReady(String actionType,boolean isValidationReady) {
		if (ACTION_SAVE.equals(actionType)) {
			if (isValidationReady) {
				getDuplicateDialog().showDialog(
					getActionType(),
					getAJText_PatNo().getText(),
					getAJText_Document().getText(),
					getAJText_FamilyName().getText(),
					getAJText_GivenName().getText()
				);
			}
		} else {
			super.actionValidationReady(actionType,isValidationReady);
		}
	}

	@Override
	protected void enableButton() {
		disableButton();
		getSaveButton().setEnabled(!"D".equals(BPBSTS));
		//disable searchButton to prevent reset actionType and no search action is really needed
		//getSearchButton().setEnabled(true);

		if (getActionType() != null) {
			PanelUtil.setAllFieldsEditable(getMasterPanel(), true);
			PanelUtil.setAllFieldsEditable(getWithinPanel(), true);
			PanelUtil.setAllFieldsEditable(getFatherPanel(), true);
			PanelUtil.setAllFieldsEditable(getCheckPanel(), true);
			getPJDate_EDC().setEditable(!isDisableFunction("preBkEditEDC", "obBooking")&& getParameter("isfromobbooking")!=null);
			enableMiddlePanel();
			enableDeclinePanel();
			getRightButton_BudgetEst().setEnabled(pbpID!=null);

		} else {
			PanelUtil.setAllFieldsEditable(getActionPanel(), false);
			getSearchButton().setEnabled(true);
			getModifyButton().setEnabled(true);
			getSaveButton().setEnabled(false);
			getRightButton_BudgetEst().setEnabled(pbpID!=null);

		}
		if (isModify()) {
			getSaveButton().setEnabled(true);
		}
	}

	@Override
	public void cancelAction() {
		exitPanel(true);
	}

	private DlgBedPreBookDupl getDuplicateDialog() {
		if (duplicateDialog == null) {
			duplicateDialog = new DlgBedPreBookDupl(getMainFrame()) {
				@Override
				public void continueAction() {
					save();
				}
			};
		}
		return duplicateDialog;
	}

	public TextDoctorSearch getDrCodeSearchDelegate() {
		if (drCodeSearchDelegate == null) {
			drCodeSearchDelegate = new TextDoctorSearch() {
				@Override
				public void searchAfterAcceptAction() {
					getPJCombo_OrderByDoctor().setText(getValue());
				}
			};
			drCodeSearchDelegate.setBounds(505, 97, 225, 20);
			drCodeSearchDelegate.setVisible(false);
		}
		return drCodeSearchDelegate;
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	@Override
	protected BasePanel getActionPanel() {
		if (actionPanel == null) {
			actionPanel = new BasePanel();
			actionPanel.setSize(770, 600);
			actionPanel.add(getHeader(), null);
			actionPanel.add(getParaPanel(), null);
			actionPanel.add(getMiddlePanel(), null);
		  //actionPanel.add(getDeclinePanel(), null);
			actionPanel.add(getWarningMsg(), null);
		}
		return actionPanel;
	}

	private LabelBase getHeader() {
		if (header == null) {
			header = new LabelBase();
			header.setBounds(10, 2, 750, 20);
			header.setStyleAttribute("color", "red");
			header.setStyleAttribute("font-wight", "bold");
			header.setStyleAttribute("background-color", "black");
			header.setStyleAttribute("text-align", "center");
			header.setText("WAITING QUEUE");
			header.setVisible(false);
		}
		return header;
	}

	public BasePanel getParaPanel() {
		if (paraPanel == null) {
			paraPanel = new BasePanel();
			paraPanel.setHeading("Pre-Book Information");
			paraPanel.setBounds(5, 29, 750, 347);
			paraPanel.add(getTabbedPane());
		}
		return paraPanel;
	}

	public TabbedPaneBase getTabbedPane() {
		if (tabbedPane == null) {
			tabbedPane = new TabbedPaneBase();
			tabbedPane.setSize(748, 345);
			tabbedPane.setTitle("Pre-EDITBook Information");
			tabbedPane.addTab("Master", getMasterPanel());
			tabbedPane.addTab("Baby's Father", getFatherPanel());
			tabbedPane.addTab("Antenatal Check-up", getCheckPanel());

		}
		return tabbedPane;
	}

	public BasePanel getMasterPanel() {
		if (masterPanel == null) {
			masterPanel = new BasePanel();
			masterPanel.add(getPJLabel_PatNo(), null);
			masterPanel.add(getAJText_PatNo(), null);
			masterPanel.add(getPJLabel_Sex(), null);
			masterPanel.add(getPJCombo_Sex(), null);
			masterPanel.add(getPJLabel_Document(), null);
			masterPanel.add(getAJText_Document(), null);
			masterPanel.add(getPJLabel_GivenName(), null);
			masterPanel.add(getAJText_GivenName(), null);
			masterPanel.add(getPJLabel_FamilyName(), null);
			masterPanel.add(getAJText_FamilyName(), null);
			masterPanel.add(getPJLabel_ContactPhone(), null);
			masterPanel.add(getAJText_ContactPhone(), null);
			masterPanel.add(getPJLabel_ChineseName(), null);
			masterPanel.add(getAJText_ChineseName(), null);
			masterPanel.add(getPJLabel_MobilePhone(), null);
			masterPanel.add(getAJText_MobilePhone(), null);
			masterPanel.add(getPJLabel_ACM(), null);
			masterPanel.add(getPJCombo_ACM(), null);
			masterPanel.add(getPJLabel_SchdAdmDate(), null);
			masterPanel.add(getPJDate_SchdAdmDate(), null);
			masterPanel.add(getPJLabel_EDC(), null);
			masterPanel.add(getPJDate_EDC(), null);
			masterPanel.add(getPJLabel_OrderByDoctor(), null);
			masterPanel.add(getPJCombo_OrderByDoctor(), null);
			masterPanel.add(getPJLabel_ForDelivery(), null);
			masterPanel.add(getPJCheckBox_ForDelivery(), null);
			masterPanel.add(getPJLabel_MainCitizen(), null);
			masterPanel.add(getPJCheckBox_MainCitizen(), null);
			masterPanel.add(getPJLabel_Ward(), null);
			masterPanel.add(getPJCombo_Ward(), null);
			masterPanel.add(getRightJLabel_Misc(), null);
			masterPanel.add(getRightJCombo_Misc(), null);
			masterPanel.add(getRightJLabel_Source(), null);
			masterPanel.add(getRightJCombo_Source(), null);
			masterPanel.add(getRightJLabel_SourceNo(), null);
			masterPanel.add(getRightJText_SourceNo(), null);
			masterPanel.add(getRightJLabel_Package(), null);
			masterPanel.add(getRightJLabel_Pkg(), null);
			masterPanel.add(getRightJCombo_Pkg(), null);
			masterPanel.add(getRightJCombo_Package(), null);
			masterPanel.add(getRightJLabel_DOB(), null);
			masterPanel.add(getPJText_Birthday(), null);
			masterPanel.add(getRightButton_BudgetEst(), null);
			masterPanel.add(getPJCheckBox_BEDesc(), null);
			masterPanel.add(getPJCheckBox_BE(), null);
			masterPanel.add(getPJLabel_PBORemark(), null);
			masterPanel.add(getAJText_PBORemark(), null);
			masterPanel.add(getPJLabel_CathLabRemark(), null);
			masterPanel.add(getAJText_CathLabRemark(), null);
			masterPanel.add(getPJLabel_OtRemark(), null);
			masterPanel.add(getAJText_OtRemark(), null);
			masterPanel.add(getPJLabel_DocType(), null);
			masterPanel.add(getPJCombo_DocType(), null);
			masterPanel.add(getWithinPanel(), null);
			masterPanel.add(getPJLabel_Stay(), null);
			masterPanel.add(getAJText_Stay(), null);
		}
		return masterPanel;
	}

	public LabelBase getPJLabel_PatNo() {
		if (PJLabel_PatNo == null) {
			PJLabel_PatNo = new LabelBase();
			PJLabel_PatNo.setText("<font color='blue'>Patient No.</font>");
			PJLabel_PatNo.setBounds(10, 5, 135, 20);
		}
		return PJLabel_PatNo;
	}

	public TextPatientNoSearch getAJText_PatNo() {
		if (AJText_PatNo == null) {
			AJText_PatNo = new TextPatientNoSearch() {
				public void onBlur() {
					checkMergePatient();
					getAJTextPatNoLostFocus();
				}
			};
			AJText_PatNo.setBounds(140, 5, 105, 20);
		}
		return AJText_PatNo;
	}

	public LabelBase getPJLabel_Sex() {
		if (PJLabel_Sex == null) {
			PJLabel_Sex = new LabelBase();
			PJLabel_Sex.setText("Sex");
			PJLabel_Sex.setBounds(255, 5, 20, 20);
		}
		return PJLabel_Sex;
	}

	public ComboSex getPJCombo_Sex() {
		if (PJCombo_Sex == null) {
			PJCombo_Sex = new ComboSex();
			PJCombo_Sex.setBounds(280, 5, 85, 20);
		}
		return PJCombo_Sex;
	}

	public LabelBase getPJLabel_ChineseName() {
		if (PJLabel_ChineseName == null) {
			PJLabel_ChineseName = new LabelBase();
			PJLabel_ChineseName.setText("Patient Chinese Name");
			PJLabel_ChineseName.setBounds(375, 5, 135, 20);
		}
		return PJLabel_ChineseName;
	}

	public TextString getAJText_ChineseName() {
		if (AJText_ChineseName == null) {
			AJText_ChineseName = new TextString(20, false);
			AJText_ChineseName.setBounds(505, 5, 225, 20);
		}
		return AJText_ChineseName;
	}

	public LabelBase getPJLabel_FamilyName() {
		if (PJLabel_FamilyName == null) {
			PJLabel_FamilyName = new LabelBase();
			PJLabel_FamilyName.setText("<font color='blue'>Patient Family Name</font>");
			PJLabel_FamilyName.setBounds(10, 28, 135, 20);
		}
		return PJLabel_FamilyName;
	}

	public TextString getAJText_FamilyName() {
		if (AJText_FamilyName == null) {
			AJText_FamilyName = new TextString(40, true);
			AJText_FamilyName.setBounds(140, 28, 225, 20);
		}
		return AJText_FamilyName;
	}

	public LabelBase getPJLabel_GivenName() {
		if (PJLabel_GivenName == null) {
			PJLabel_GivenName = new LabelBase();
			PJLabel_GivenName.setText("Patient Given name");
			PJLabel_GivenName.setBounds(375, 28, 135, 20);
		}
		return PJLabel_GivenName;
	}

	public TextString getAJText_GivenName() {
		if (AJText_GivenName == null) {
			AJText_GivenName = new TextString(40, true);
			AJText_GivenName.setBounds(505, 28, 225, 20);
		}
		return AJText_GivenName;
	}

	public LabelBase getPJLabel_Document() {
		if (PJLabel_Document == null) {
			PJLabel_Document = new LabelBase();
			PJLabel_Document.setText("<font color='blue'>Patient Document #</font>");
			PJLabel_Document.setBounds(10, 51, 135, 20);
		}
		return PJLabel_Document;
	}

	public TextString getAJText_Document() {
		if (AJText_Document == null) {
			AJText_Document = new TextString(20, true);
			AJText_Document.setBounds(140, 51, 225, 20);
		}
		return AJText_Document;
	}

	public LabelBase getPJLabel_DocType() {
		if (PJLabel_DocType == null) {
			PJLabel_DocType = new LabelBase();
			PJLabel_DocType.setText("Patient Document Type");
			PJLabel_DocType.setBounds(375, 51, 135, 20);
		}
		return PJLabel_DocType;
	}

	public ComboMTravelDocType getPJCombo_DocType() {
		if (PJCombo_DocType == null) {
			PJCombo_DocType = new ComboMTravelDocType();
//			PJCombo_DocType.addItem("X", "(MAC) Document issued by Macau SAR");
			PJCombo_DocType.setBounds(505, 51, 225, 20);
		}
		return PJCombo_DocType;
	}

	public LabelBase getPJLabel_ContactPhone() {
		if (PJLabel_ContactPhone == null) {
			PJLabel_ContactPhone = new LabelBase();
			PJLabel_ContactPhone.setText("Contact Phone No");
			PJLabel_ContactPhone.setBounds(10, 74, 135, 20);
		}
		return PJLabel_ContactPhone;
	}

	public TextString getAJText_ContactPhone() {
		if (AJText_ContactPhone == null) {
			AJText_ContactPhone = new TextString(20, false);
			AJText_ContactPhone.setBounds(140, 74, 225, 20);
		}
		return AJText_ContactPhone;
	}

	public LabelBase getPJLabel_MobilePhone() {
		if (PJLabel_MobilePhone == null) {
			PJLabel_MobilePhone = new LabelBase();
			PJLabel_MobilePhone.setText("Patient Mobile Phone");
			PJLabel_MobilePhone.setBounds(375, 74, 135, 20);
		}
		return PJLabel_MobilePhone;
	}

	public TextString getAJText_MobilePhone() {
		if (AJText_MobilePhone == null) {
			AJText_MobilePhone = new TextString(20, false);
			AJText_MobilePhone.setBounds(505, 74, 225, 20);
		}
		return AJText_MobilePhone;
	}

	public LabelBase getPJLabel_SchdAdmDate() {
		if (PJLabel_SchdAdmDate == null) {
			PJLabel_SchdAdmDate = new LabelBase();
			PJLabel_SchdAdmDate.setText("<font color='blue'>Schd Adm Date</font>");
			PJLabel_SchdAdmDate.setBounds(10, 97, 100, 20);
		}
		return PJLabel_SchdAdmDate;
	}

	public TextDateTime getPJDate_SchdAdmDate() {
		if (PJDate_SchdAdmDate == null) {
			PJDate_SchdAdmDate = new TextDateTime(true, true) {
				@Override
				public void setValue(Date value) {
					//if (isAppend() || isModify()) {
						if (value != null) {
							value.setHours(0);
							value.setMinutes(0);
							value.setSeconds(0);
						}
					//}
					super.setValue(value);
					if (value != null  && isRendered()) {
						setSelectionRange(11, 8);
					}
				}

				@Override
				public void onBlur() {
					if (!isEmpty()) {
						if (getPJDate_EDC().isEmpty() && isFromOBBooking) {
							getPJDate_EDC().setText(getText());
						}
					}
				}
			};
			PJDate_SchdAdmDate.setBounds(140, 97, 110, 20);
		}
		return PJDate_SchdAdmDate;
	}

	public LabelBase getPJLabel_EDC() {
		if (PJLabel_EDC == null) {
			PJLabel_EDC = new LabelBase();
			PJLabel_EDC.setText("EDC");
			PJLabel_EDC.setBounds(260, 97, 50, 20);
		}
		return PJLabel_EDC;
	}

	public TextDateTime getPJDate_EDC() {
		if (PJDate_EDC == null) {
			PJDate_EDC = new TextDateTime(true, true) {
				@Override
				public void setValue(Date value) {
					//if (isAppend() || isModify()) {
						if (value != null) {
							value.setHours(0);
							value.setMinutes(0);
							value.setSeconds(0);
						}
					//}
					super.setValue(value);
					if (value != null  && isRendered()) {
						setSelectionRange(11, 8);
					}
				}
			};
			PJDate_EDC.setBounds(290, 97, 75, 20);
		}
		return PJDate_EDC;
	}

	public LabelBase getPJLabel_OrderByDoctor() {
		if (PJLabel_OrderByDoctor == null) {
			PJLabel_OrderByDoctor = new LabelBase();
			PJLabel_OrderByDoctor.setText("<font color='blue'>Order By Doctor</font>");
			PJLabel_OrderByDoctor.setBounds(375, 97, 135, 20);
		}
		return PJLabel_OrderByDoctor;
	}

	public ComboDocName getPJCombo_OrderByDoctor() {
		if (PJCombo_OrderByDoctor == null) {
			PJCombo_OrderByDoctor = new ComboDocName(true, true) {
				@Override
				public void onSearchTriggerClick(ComponentEvent ce) {
					getDrCodeSearchDelegate().setValue(this.getText());
					getDrCodeSearchDelegate().showSearchPanel();
				}

				@Override
				protected void setTextPanel(ModelData modelData) {
					setToolTip(getDisplayText());
					if ((getOriginalValue() == null || !getOriginalValue().equals(getText()))) {
						showOverdueMsg(this, true, false);
					}

					setOriginalValue(this.getText());
				}
			};
			PJCombo_OrderByDoctor.setShowTextSearhPanel(true);
			PJCombo_OrderByDoctor.setBounds(505, 97, 225, 20);
		}
		return PJCombo_OrderByDoctor;
	}

	public LabelBase getPJLabel_ForDelivery() {
		if (PJLabel_ForDelivery == null) {
			PJLabel_ForDelivery = new LabelBase();
			PJLabel_ForDelivery.setText("For Delivery");
			PJLabel_ForDelivery.setBounds(10, 120, 135, 20);
		}
		return PJLabel_ForDelivery;
	}

	public CheckBoxBase getPJCheckBox_ForDelivery() {
		if (PJCheckBox_ForDelivery == null) {
			PJCheckBox_ForDelivery = new CheckBoxBase();
			PJCheckBox_ForDelivery.setBounds(135, 120, 20, 20);
		}
		return PJCheckBox_ForDelivery;
	}

	public LabelBase getPJLabel_MainCitizen() {
		if (PJLabel_MainCitizen == null) {
			PJLabel_MainCitizen = new LabelBase();
			PJLabel_MainCitizen.setText("Mainland Citizen");
			PJLabel_MainCitizen.setBounds(225, 120, 105, 20);
		}
		return PJLabel_MainCitizen;
	}

	public CheckBoxBase getPJCheckBox_MainCitizen() {
		if (PJCheckBox_MainCitizen == null) {
			PJCheckBox_MainCitizen = new CheckBoxBase();
			PJCheckBox_MainCitizen.setBounds(345, 120, 20, 20);
		}
		return PJCheckBox_MainCitizen;
	}

	public LabelBase getPJLabel_ACM() {
		if (PJLabel_ACM == null) {
			PJLabel_ACM = new LabelBase();
			PJLabel_ACM.setText("Class");
			PJLabel_ACM.setBounds(375, 120, 135, 20);
		}
		return PJLabel_ACM;
	}

	public ComboACMCode getPJCombo_ACM() {
		if (PJCombo_ACM == null) {
			PJCombo_ACM = new ComboACMCode(true);
			PJCombo_ACM.setBounds(505, 120, 80, 20);
		}
		return PJCombo_ACM;
	}

	public LabelBase getPJLabel_Ward() {
		if (PJLabel_Ward == null) {
			PJLabel_Ward = new LabelBase();
			PJLabel_Ward.setText("Ward");
			PJLabel_Ward.setBounds(590, 120, 60, 20);
		}
		return PJLabel_Ward;
	}

	public ComboWard getPJCombo_Ward() {
		if (PJCombo_Ward == null) {
			PJCombo_Ward = new ComboWard() {
				@Override
				protected void setTextPanel(ModelData modelData) {
					if ((!isDeliveryPB()) && PJCombo_Ward.getText().equals(obWardcode)) {
						getWarningMsg().setText("This booking is not for delivery!");
					} else {
						getWarningMsg().resetText();
					}
				}

				@Override
				public void onSelected() {
					 cboWard_Change();
				}
			};
			PJCombo_Ward.setBounds(620, 120, 110, 20);
		}
		return PJCombo_Ward;
	}

	public LabelBase getRightJLabel_Misc() {
		if (RightJLabel_Misc == null) {
			RightJLabel_Misc = new LabelBase();
			RightJLabel_Misc.setText("Remark");
			RightJLabel_Misc.setBounds(10, 145, 65, 20);
		}
		return RightJLabel_Misc;
	}

	public ComboBoxBase getRightJCombo_Misc() {
		if (RightJCombo_Misc == null) {
			RightJCombo_Misc = new ComboBoxBase("TRANSMISC", false, false, true);
			RightJCombo_Misc.setBounds(65, 145, 50, 20);
		}
		return RightJCombo_Misc;
	}

	protected LabelBase getRightJLabel_Source() {
		if (RightJLabel_Source == null) {
			RightJLabel_Source = new LabelBase();
			RightJLabel_Source.setText("Source");
			RightJLabel_Source.setBounds(120, 145, 40, 20);
		}
		return RightJLabel_Source;
	}

	protected ComboBoxBase getRightJCombo_Source() {
		if (RightJCombo_Source == null) {
			RightJCombo_Source = new ComboBoxBase("TRANSSRC", false, false, true);
			RightJCombo_Source.setBounds(165, 145, 65, 20);
		}
		return RightJCombo_Source;
	}

	protected LabelBase getRightJLabel_SourceNo() {
		if (RightJLabel_SourceNo == null) {
			RightJLabel_SourceNo = new LabelBase();
			RightJLabel_SourceNo.setText("Source#");
			RightJLabel_SourceNo.setBounds(235, 145, 50, 20);
		}
		return RightJLabel_SourceNo;
	}

	protected TextString getRightJText_SourceNo() {
		if (RightJText_SourceNo == null) {
			RightJText_SourceNo = new TextString(20);
			RightJText_SourceNo.setBounds(280, 145, 80, 20);
		}
		return RightJText_SourceNo;
	}

	protected LabelBase getRightJLabel_Package() {
		if (RightJLabel_Package == null) {
			RightJLabel_Package = new LabelBase();
			RightJLabel_Package.setText("Package");
			RightJLabel_Package.setBounds(362, 145, 50, 20);
		}
		return RightJLabel_Package;
	}

	protected ComboBoxBase getRightJCombo_Package() {
		if (RightJCombo_Package == null) {
			RightJCombo_Package = new ComboBoxBase("BPBPKG", false, false, true);
			RightJCombo_Package.setBounds(410, 145, 100, 20);
			RightJCombo_Package.setMinListWidth(230);
		}
		return RightJCombo_Package;
	}
	
	protected LabelBase getRightJLabel_Pkg() {
		if (RightJLabel_Pkg == null) {
			RightJLabel_Pkg = new LabelBase();
			RightJLabel_Pkg.setText("Pkg");
			RightJLabel_Pkg.setBounds(515, 145, 30, 20);
		}
		return RightJLabel_Pkg;
	}

	private ComboPackage getRightJCombo_Pkg() {
		if (RightJCombo_Pkg == null) {
			RightJCombo_Pkg = new ComboPackage(true, "PKGTYPE <> 'P'");
			RightJCombo_Pkg.setBounds(540, 145, 100, 20);
			RightJCombo_Pkg.setMinListWidth(300);
			RightJCombo_Pkg.setShowKeyOnly(false);
		}
		return RightJCombo_Pkg;
	}

	protected ButtonBase getRightButton_BudgetEst() {
		if (RightButton_BudgetEst == null) {
			RightButton_BudgetEst = new ButtonBase() {
				@Override
				public void onClick() {
					getDlgBudgetEst().showDialog(memFestID, "PreBook", pbpID, getAJText_PatNo().getText(),
													getAJText_FamilyName().getText() + " " + getAJText_GivenName().getText(),
													getPJCombo_OrderByDoctor().getText());
				}
			};
			RightButton_BudgetEst.setText("BE");
			RightButton_BudgetEst.setEnabled(false);
			RightButton_BudgetEst.setBounds(645, 145, 40, 22);
		}
		return RightButton_BudgetEst;
	}

	private DlgBudgetEstBase getDlgBudgetEst() {
		if (dlgBudgetEst == null) {
			dlgBudgetEst = new DlgBudgetEstBase(getMainFrame()) {
				@Override
				public void post(String srcNo,boolean isBE) {
					memFestID = srcNo;
					if (isBE) {
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
			PJCheckBox_BEDesc.setBounds(690, 145, 20, 20);
		}
		return PJCheckBox_BEDesc;
	}

	protected CheckBoxBase getPJCheckBox_BE() {
		if (PJCheckBox_BE == null) {
			PJCheckBox_BE = new CheckBoxBase();
			PJCheckBox_BE.setBounds(710, 145, 20, 20);
		}
		return PJCheckBox_BE;
	}

	protected LabelBase getPJLabel_PBORemark() {
		if (PJLabel_PBORemark == null) {
			PJLabel_PBORemark = new LabelBase();
			PJLabel_PBORemark.setText("PBO Remark");
			PJLabel_PBORemark.setBounds(10, 173, 135, 20);
		}
		return PJLabel_PBORemark;
	}

	protected TextAreaBase getAJText_PBORemark() {
		if (AJText_PBORemark == null) {
			AJText_PBORemark = new TextAreaBase(200,true);
			AJText_PBORemark.addKeyListener(new KeyListener() {
				public void componentKeyPress(ComponentEvent event) {
					super.componentKeyPress(event);
				}
			});

			AJText_PBORemark.setBounds(140, 173, 590, 50);
		}
		return AJText_PBORemark;
	}

	protected LabelBase getPJLabel_CathLabRemark() {
		if (PJLabel_CathLabRemark == null) {
			PJLabel_CathLabRemark = new LabelBase();
			PJLabel_CathLabRemark.setText("Cath Lab Remark");
			PJLabel_CathLabRemark.setBounds(10, 226, 135, 20);
		}
		return PJLabel_CathLabRemark;
	}

	protected TextString getAJText_CathLabRemark() {
		if (AJText_CathLabRemark == null) {
			AJText_CathLabRemark = new TextString(75, true);
			AJText_CathLabRemark.setBounds(140, 226, 590, 20);
		}
		return AJText_CathLabRemark;
	}

	protected LabelBase getPJLabel_OtRemark() {
		if (PJLabel_OtRemark == null) {
			PJLabel_OtRemark = new LabelBase();
			PJLabel_OtRemark.setText("OT Remark");
			PJLabel_OtRemark.setBounds(10, 251, 135, 20);
		}
		return PJLabel_OtRemark;
	}

	protected TextString getAJText_OtRemark() {
		if (AJText_OtRemark == null) {
			AJText_OtRemark = new TextString(75, true);
			AJText_OtRemark.setBounds(140, 251, 590, 20);
		}
		return AJText_OtRemark;
	}

	protected FieldSetBase getWithinPanel() {
		if (withinPanel == null) {
			withinPanel = new FieldSetBase();
			withinPanel.setHeading("Availability");
			withinPanel.setBounds(10, 273, 480, 40);
			withinPanel.add(getPJLabel_BedCode(), null);
			withinPanel.add(getPJCombo_BedCode(), null);
			withinPanel.add(getPJLabel_AvailableTime(), null);
			withinPanel.add(getPJDate_AvailableTime(), null);
		}
		return withinPanel;
	}

	private LabelBase getPJLabel_BedCode() {
		if (PJLabel_BedCode == null) {
			PJLabel_BedCode = new LabelBase();
			PJLabel_BedCode.setText("Bed code");
			PJLabel_BedCode.setBounds(25, -10, 70, 20);
		}
		return PJLabel_BedCode;
	}

	protected ComboBedCode getPJCombo_BedCode() {
		if (PJCombo_BedCode == null) {
			PJCombo_BedCode = new ComboBedCode() {
				@Override
				protected void setTextPanel(ModelData modelData) {
					if (EMPTY_VALUE.equals(PJCombo_BedCode.getText())) {
						getPJDate_AvailableTime().resetText();
					} else {
						getPJDate_AvailableTime().setText(getPJDate_SchdAdmDate().getText().substring(0, 16));
					}
				}
			};
			PJCombo_BedCode.setBounds(110, -10, 120, 20);
		}
		return PJCombo_BedCode;
	}

	private LabelBase getPJLabel_AvailableTime() {
		if (PJLabel_AvailableTime == null) {
			PJLabel_AvailableTime = new LabelBase();
			PJLabel_AvailableTime.setText("Available Time");
			PJLabel_AvailableTime.setBounds(250, -10, 100, 20);
		}
		return PJLabel_AvailableTime;
	}

	private TextDateTimeWithoutSecond getPJDate_AvailableTime() {
		if (PJDate_AvailableTime == null) {
			PJDate_AvailableTime = new TextDateTimeWithoutSecond();
			PJDate_AvailableTime.setBounds(340, -10, 130, 20);
		}
		return PJDate_AvailableTime;
	}

	protected LabelBase getPJLabel_Stay() {
		if (PJLabel_Stay == null) {
			PJLabel_Stay = new LabelBase();
			PJLabel_Stay.setText("Estimated Length of Stay");
			PJLabel_Stay.setBounds(500,285, 140, 20);
		}
		return PJLabel_Stay;
	}

	protected LabelBase getRightJLabel_DOB() {
		if (RightJLabel_DOB == null) {
			RightJLabel_DOB = new LabelBase();
			RightJLabel_DOB.setText("DOB");
			RightJLabel_DOB.setBounds(400, 145, 60, 20);
		}
		return RightJLabel_DOB;
	}

	protected TextDate getPJText_Birthday() {
		if (RightJText_Birthday == null) {
			RightJText_Birthday = new TextDate() {
				@Override
				public void onBlur() {
					if (!isEmpty() && !isValid()) {
						Factory.getInstance().addErrorMessage(
								ConstantsMessage.MSG_ADMISSION_DATE,
								getPJText_Birthday());
						resetText();
						return;
					} else if (!isEmpty()) {
						if ((DateTimeUtil.dateDiff(getMainFrame().getServerDate(),
													getPJText_Birthday().getText().trim()) < 0)) {
							Factory.getInstance().addErrorMessage(
									ConstantsMessage.MSG_BIRTHDAY_DATE,
									getPJText_Birthday());
							resetText();
							return;
						}
					}
				}
			};
			RightJText_Birthday.setBounds(455, 145, 100, 20);
		}
		return RightJText_Birthday;
	}

	protected TextAmount getAJText_Stay() {
		if (AJText_Stay == null) {
			AJText_Stay = new TextAmount();
			AJText_Stay.setBounds(640, 285, 90, 20);
		}
		return AJText_Stay;
	}

	private BasePanel getFatherPanel() {
		if (fatherPanel == null) {
			fatherPanel = new BasePanel();
			fatherPanel.add(getFa_PJLabel_PatNo());
			fatherPanel.add(getFa_AJText_PatNo());
			fatherPanel.add(getFa_PJLabel_ChineseName(), null);
			fatherPanel.add(getFa_AJText_ChineseName(), null);
			fatherPanel.add(getFa_PJLabel_FamilyName(), null);
			fatherPanel.add(getFa_AJText_FamilyName(), null);
			fatherPanel.add(getFa_PJLabel_GivenName(), null);
			fatherPanel.add(getFa_AJText_GivenName(), null);
			fatherPanel.add(getFa_PJLabel_ContactPhone(), null);
			fatherPanel.add(getFa_AJText_ContactPhone(), null);
			fatherPanel.add(getFa_PJLabel_DOB(), null);
			fatherPanel.add(getFa_AJText_DOB(), null);
			fatherPanel.add(getFa_PJLabel_DOBFormat(), null);
			fatherPanel.add(getFa_PJLabel_EDOB(), null);
			fatherPanel.add(getFa_AJText_EDOB(), null);
			fatherPanel.add(getFa_PJLabel_Document(), null);
			fatherPanel.add(getFa_AJText_Document(), null);
			fatherPanel.add(getFa_PJLabel_HKIDFormat(), null);
			fatherPanel.add(getFa_PJLabel_Holder(), null);
			fatherPanel.add(getFa_AJText_Holder(), null);
			fatherPanel.add(getFa_PJLabel_PassportNo(), null);
			fatherPanel.add(getFa_AJText_PassportNo(), null);
			fatherPanel.add(getFa_PJLabel_PassportType(), null);
			fatherPanel.add(getFa_AJText_PassportType(), null);
			fatherPanel.add(getFa_PJLabel_Residence(), null);
			fatherPanel.add(getFa_AJText_Residence(), null);
			fatherPanel.add(getFa_PJLabel_InfoSource(), null);
			fatherPanel.add(getFa_AJText_InfoSource(), null);
		}
		return fatherPanel;
	}

	private LabelBase getFa_PJLabel_PatNo() {
		if (Fa_PJLabel_PatNo == null) {
			Fa_PJLabel_PatNo = new LabelBase();
			Fa_PJLabel_PatNo.setText("Patient No.");
			Fa_PJLabel_PatNo.setBounds(10, 15, 95, 20);
		}
		return Fa_PJLabel_PatNo;
	}

	private TextPatientNoSearch getFa_AJText_PatNo() {
		if (Fa_AJText_PatNo == null) {
			Fa_AJText_PatNo = new TextPatientNoSearch() {
				public void onBlur() {
					checkMergePatient();
					if ((!Fa_AJText_PatNo.getText().equals(curFaPatNo)) && !Fa_AJText_PatNo.isEmpty()) {
						curFaPatNo = Fa_AJText_PatNo.getText();
						QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
								new String[] { "patient", "death", "patno= '" + curFaPatNo + "'" },
								new MessageQueueCallBack() {
							public void onPostSuccess(MessageQueue chkDeath) {
								if (chkDeath.success()) {
									if (chkDeath.getContentField()[0].length() > 0) {
										MessageBoxBase.confirm(MSG_PBA_SYSTEM," Current patient is dead.Continue?",
												new Listener<MessageBoxEvent>() {
											@Override
											public void handleEvent(MessageBoxEvent be) {
												if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
													if (pbpID == null || pbpID.length() == 0) {
														showFaPatInfo(curFaPatNo);
													}
												} else {
													Fa_AJText_PatNo.resetText();
													Fa_AJText_PatNo.focus();
												}
											}
										});
									} else {
										if (pbpID == null || pbpID.length() == 0) {
											showFaPatInfo(curFaPatNo);
										}
									}
								} else {
									if (pbpID == null || pbpID.length() == 0) {
										showFaPatInfo(curFaPatNo);
									}
								}
							}
						});
					}
				}
			};
			Fa_AJText_PatNo.setBounds(120, 15, 160, 20);
		}
		return Fa_AJText_PatNo;
	}

	private LabelBase getFa_PJLabel_ChineseName() {
		if (Fa_PJLabel_ChineseName == null) {
			Fa_PJLabel_ChineseName = new LabelBase();
			Fa_PJLabel_ChineseName.setText("Chi. Name:");
			Fa_PJLabel_ChineseName.setBounds(370, 15, 70, 20);
		}
		return Fa_PJLabel_ChineseName;
	}

	private TextString getFa_AJText_ChineseName() {
		if (Fa_AJText_ChineseName == null) {
			Fa_AJText_ChineseName = new TextString();
			Fa_AJText_ChineseName.setBounds(495, 15, 160, 20);
		}
		return Fa_AJText_ChineseName;
	}

	private LabelBase getFa_PJLabel_FamilyName() {
		if (Fa_PJLabel_FamilyName == null) {
			Fa_PJLabel_FamilyName = new LabelBase();
			Fa_PJLabel_FamilyName.setText("Family Name");
			Fa_PJLabel_FamilyName.setBounds(10, 40, 120, 20);
		}
		return Fa_PJLabel_FamilyName;
	}

	private TextString getFa_AJText_FamilyName() {
		if (Fa_AJText_FamilyName == null) {
			Fa_AJText_FamilyName = new TextString(20, true);
			Fa_AJText_FamilyName.setBounds(120, 40, 160, 20);
		}
		return Fa_AJText_FamilyName;
	}

	private LabelBase getFa_PJLabel_GivenName() {
		if (Fa_PJLabel_GivenName == null) {
			Fa_PJLabel_GivenName = new LabelBase();
			Fa_PJLabel_GivenName.setText("Given Name:");
			Fa_PJLabel_GivenName.setBounds(370, 40, 115, 20);
		}
		return Fa_PJLabel_GivenName;
	}

	private TextString getFa_AJText_GivenName() {
		if (Fa_AJText_GivenName == null) {
			Fa_AJText_GivenName = new TextString(20, true);
			Fa_AJText_GivenName.setBounds(495, 40, 160, 20);
		}
		return Fa_AJText_GivenName;
	}

	private LabelBase getFa_PJLabel_ContactPhone() {
		if (Fa_PJLabel_ContactPhone == null) {
			Fa_PJLabel_ContactPhone = new LabelBase();
			Fa_PJLabel_ContactPhone.setText("Contact No.:");
			Fa_PJLabel_ContactPhone.setBounds(10, 65, 110, 20);
		}
		return Fa_PJLabel_ContactPhone;
	}

	private TextString getFa_AJText_ContactPhone() {
		if (Fa_AJText_ContactPhone == null) {
			Fa_AJText_ContactPhone = new TextString();
			Fa_AJText_ContactPhone.setBounds(120, 65, 160, 20);
		}
		return Fa_AJText_ContactPhone;
	}

	private LabelBase getFa_PJLabel_DOB() {
		if (Fa_PJLabel_DOB == null) {
			Fa_PJLabel_DOB = new LabelBase();
			Fa_PJLabel_DOB.setText("Date of Birth:");
			Fa_PJLabel_DOB.setBounds(10, 90, 120, 20);
		}
		return Fa_PJLabel_DOB;
	}

	private TextDate getFa_AJText_DOB() {
		if (Fa_AJText_DOB == null) {
			Fa_AJText_DOB = new TextDate();
			Fa_AJText_DOB.setBounds(120, 90, 160, 20);
		}
		return Fa_AJText_DOB;
	}

	private LabelBase getFa_PJLabel_DOBFormat() {
		if (Fa_PJLabel_DOBFormat == null) {
			Fa_PJLabel_DOBFormat = new LabelBase();
			Fa_PJLabel_DOBFormat.setText("(DD/MM/YYYY)");
			Fa_PJLabel_DOBFormat.setBounds(285, 90, 95, 20);
		}
		return Fa_PJLabel_DOBFormat;
	}

	private LabelBase getFa_PJLabel_EDOB() {
		if (Fa_PJLabel_EDOB == null) {
			Fa_PJLabel_EDOB = new LabelBase();
			Fa_PJLabel_EDOB.setText("Exact DOB:");
			Fa_PJLabel_EDOB.setBounds(370, 90, 100, 20);
		}
		return Fa_PJLabel_EDOB;
	}

	private ComboYesNo getFa_AJText_EDOB() {
		if (Fa_AJText_EDOB == null) {
			Fa_AJText_EDOB = new ComboYesNo();
			Fa_AJText_EDOB.setBounds(495, 90, 160, 20);
		}
		return Fa_AJText_EDOB;
	}

	private LabelBase getFa_PJLabel_Document() {
		if (Fa_PJLabel_Document == null) {
			Fa_PJLabel_Document = new LabelBase();
			Fa_PJLabel_Document.setText("HKID:");
			Fa_PJLabel_Document.setBounds(10, 115, 70, 20);
		}
		return Fa_PJLabel_Document;
	}

	private TextString getFa_AJText_Document() {
		if (Fa_AJText_Document == null) {
			Fa_AJText_Document = new TextString(20, true);
			Fa_AJText_Document.setBounds(120, 115, 160, 20);
		}
		return Fa_AJText_Document;
	}

	private LabelBase getFa_PJLabel_HKIDFormat() {
		if (Fa_PJLabel_HKIDFormat == null) {
			Fa_PJLabel_HKIDFormat = new LabelBase();
			Fa_PJLabel_HKIDFormat.setText("AB123456(7)");
			Fa_PJLabel_HKIDFormat.setBounds(285, 115, 95, 20);
		}
		return Fa_PJLabel_HKIDFormat;
	}

	private LabelBase getFa_PJLabel_Holder() {
		if (Fa_PJLabel_Holder == null) {
			Fa_PJLabel_Holder = new LabelBase();
			Fa_PJLabel_Holder.setText("HK ID Card Holder:");
			Fa_PJLabel_Holder.setBounds(370, 115, 120, 20);
		}
		return Fa_PJLabel_Holder;
	}

	private ComboYesNo getFa_AJText_Holder() {
		if (Fa_AJText_Holder == null) {
			Fa_AJText_Holder = new ComboYesNo();
			Fa_AJText_Holder.setBounds(495, 115, 160, 20);
		}
		return Fa_AJText_Holder;
	}

	private LabelBase getFa_PJLabel_PassportNo() {
		if (Fa_PJLabel_PassportNo == null) {
			Fa_PJLabel_PassportNo = new LabelBase();
			Fa_PJLabel_PassportNo.setText("Passport No.:");
			Fa_PJLabel_PassportNo.setBounds(10, 140, 95, 20);
		}
		return Fa_PJLabel_PassportNo;
	}

	private TextString getFa_AJText_PassportNo() {
		if (Fa_AJText_PassportNo == null) {
			Fa_AJText_PassportNo = new TextString();
			Fa_AJText_PassportNo.setBounds(120, 140, 320, 20);
		}
		return Fa_AJText_PassportNo;
	}

	private LabelBase getFa_PJLabel_PassportType() {
		if (Fa_PJLabel_PassportType == null) {
			Fa_PJLabel_PassportType = new LabelBase();
			Fa_PJLabel_PassportType.setText("Passport Type:");
			Fa_PJLabel_PassportType.setBounds(10, 165, 95, 20);
		}
		return Fa_PJLabel_PassportType;
	}

	private ComboMTravelDocType getFa_AJText_PassportType() {
		if (Fa_AJText_PassportType == null) {
			Fa_AJText_PassportType = new ComboMTravelDocType();
			Fa_AJText_PassportType.setBounds(120, 165, 535, 20);
		}
		return Fa_AJText_PassportType;
	}

	private LabelBase getFa_PJLabel_Residence() {
		if (Fa_PJLabel_Residence == null) {
			Fa_PJLabel_Residence = new LabelBase();
			Fa_PJLabel_Residence.setText("Residence Desc:");
			Fa_PJLabel_Residence.setBounds(10, 190, 120, 20);
		}
		return Fa_PJLabel_Residence;
	}

	private TextString getFa_AJText_Residence() {
		if (Fa_AJText_Residence == null) {
			Fa_AJText_Residence = new TextString();
			Fa_AJText_Residence.setBounds(120, 190, 535, 20);
		}
		return Fa_AJText_Residence;
	}

	private LabelBase getFa_PJLabel_InfoSource() {
		if (Fa_PJLabel_InfoSource == null) {
			Fa_PJLabel_InfoSource = new LabelBase();
			Fa_PJLabel_InfoSource.setText("Father Info. Source:");
			Fa_PJLabel_InfoSource.setBounds(10, 215, 120, 20);
		}
		return Fa_PJLabel_InfoSource;
	}

	private ComboFaInfoSource getFa_AJText_InfoSource() {
		if (Fa_AJText_InfoSource == null) {
			Fa_AJText_InfoSource = new ComboFaInfoSource();
			Fa_AJText_InfoSource.setBounds(120, 215, 320, 20);
		}
		return Fa_AJText_InfoSource;
	}

	private BasePanel getCheckPanel() {
		if (checkPanel == null) {
			checkPanel = new BasePanel();
			checkPanel.add(getCheckDesc1());
			checkPanel.add(getCheck1());
			checkPanel.add(getCheckDesc2());
			checkPanel.add(getCheck2());
			checkPanel.add(getCheckDesc3());
			checkPanel.add(getCheck3());
			checkPanel.add(getCheckDesc4());
			checkPanel.add(getCheck4());
			checkPanel.add(getCheckDesc5());
			checkPanel.add(getCheck5());
			checkPanel.add(getCheckDesc6());
			checkPanel.add(getCheck6());
			checkPanel.add(getCheckDesc7());
			checkPanel.add(getCheck7());
			checkPanel.add(getCheckDesc8());
			checkPanel.add(getCheck8());
			checkPanel.add(getCheckDesc9());
			checkPanel.add(getCheck9());
			checkPanel.add(getCheckDesc10());
			checkPanel.add(getCheck10());
		}
		return checkPanel;
	}

	public LabelBase getCheckDesc1() {
		if (checkDesc1 == null) {
			checkDesc1 = new LabelBase();
			checkDesc1.setText("Antenatal Check-up Day1");
			checkDesc1.setBounds(20, 40, 150, 20);
		}
		return checkDesc1;
	}

	public TextDate getCheck1() {
		if (check1 == null) {
			check1 = new TextDate();
			check1.setBounds(170, 40, 160, 20);
		}
		return check1;
	}

	public LabelBase getCheckDesc2() {
		if (checkDesc2 == null) {
			checkDesc2 = new LabelBase();
			checkDesc2.setText("Antenatal Check-up Day2");
			checkDesc2.setBounds(20, 65, 150, 20);
		}
		return checkDesc2;
	}

	public TextDate getCheck2() {
		if (check2 == null) {
			check2 = new TextDate();
			check2.setBounds(170, 65, 160, 20);
		}
		return check2;
	}

	public LabelBase getCheckDesc3() {
		if (checkDesc3 == null) {
			checkDesc3 = new LabelBase();
			checkDesc3.setText("Antenatal Check-up Day3");
			checkDesc3.setBounds(20, 90, 150, 20);
		}
		return checkDesc3;
	}

	public TextDate getCheck3() {
		if (check3 == null) {
			check3 = new TextDate();
			check3.setBounds(170, 90, 160, 20);
		}
		return check3;
	}

	public LabelBase getCheckDesc4() {
		if (checkDesc4 == null) {
			checkDesc4 = new LabelBase();
			checkDesc4.setText("Antenatal Check-up Day4");
			checkDesc4.setBounds(20, 115, 150, 20);
		}
		return checkDesc4;
	}

	public TextDate getCheck4() {
		if (check4 == null) {
			check4 = new TextDate();
			check4.setBounds(170, 115, 160, 20);
		}
		return check4;
	}

	public LabelBase getCheckDesc5() {
		if (checkDesc5 == null) {
			checkDesc5 = new LabelBase();
			checkDesc5.setText("Antenatal Check-up Day5");
			checkDesc5.setBounds(20, 140, 150, 20);
		}
		return checkDesc5;
	}

	public TextDate getCheck5() {
		if (check5 == null) {
			check5 = new TextDate();
			check5.setBounds(170, 140, 160, 20);
		}
		return check5;
	}

	public LabelBase getCheckDesc6() {
		if (checkDesc6 == null) {
			checkDesc6 = new LabelBase();
			checkDesc6.setText("Antenatal Check-up Day6");
			checkDesc6.setBounds(370, 40, 150, 20);
		}
		return checkDesc6;
	}

	public TextDate getCheck6() {
		if (check6 == null) {
			check6 = new TextDate();
			check6.setBounds(520, 40, 160, 20);
		}
		return check6;
	}

	public LabelBase getCheckDesc7() {
		if (checkDesc7 == null) {
			checkDesc7 = new LabelBase();
			checkDesc7.setText("Antenatal Check-up Day7");
			checkDesc7.setBounds(370, 65, 150, 20);
		}
		return checkDesc7;
	}

	public TextDate getCheck7() {
		if (check7 == null) {
			check7 = new TextDate();
			check7.setBounds(520, 65, 160, 20);
		}
		return check7;
	}

	public LabelBase getCheckDesc8() {
		if (checkDesc8 == null) {
			checkDesc8 = new LabelBase();
			checkDesc8.setText("Antenatal Check-up Day8");
			checkDesc8.setBounds(370, 90, 150, 20);
		}
		return checkDesc8;
	}

	public TextDate getCheck8() {
		if (check8 == null) {
			check8 = new TextDate();
			check8.setBounds(520, 90, 160, 20);
		}
		return check8;
	}

	public LabelBase getCheckDesc9() {
		if (checkDesc9 == null) {
			checkDesc9 = new LabelBase();
			checkDesc9.setText("Antenatal Check-up Day9");
			checkDesc9.setBounds(370, 115, 150, 20);
		}
		return checkDesc9;
	}

	public TextDate getCheck9() {
		if (check9 == null) {
			check9 = new TextDate();
			check9.setBounds(520, 115, 160, 20);
		}
		return check9;
	}

	public LabelBase getCheckDesc10() {
		if (checkDesc10 == null) {
			checkDesc10 = new LabelBase();
			checkDesc10.setText("Antenatal Check-up Day10");
			checkDesc10.setBounds(370, 140, 150, 20);
		}
		return checkDesc10;
	}

	public TextDate getCheck10() {
		if (check10 == null) {
			check10 = new TextDate();
			check10.setBounds(520, 140, 160, 20);
		}
		return check10;
	}

	public FieldSetBase getMiddlePanel() {
		if (middlePanel == null) {
			middlePanel = new FieldSetBase();
			middlePanel.setBounds(5, 375, 750, 110);
			middlePanel.setHeading("AR Information");
			middlePanel.add(getPJLabel_ArCode(), null);
			middlePanel.add(getPJCombo_ArCode(), null);
			middlePanel.add(getRightJText_ARCompanyDesc(), null);
			middlePanel.add(getRightJText_ARCardType(), null);
			middlePanel.add(getPJLabel_PolicyNo(), null);
			middlePanel.add(getAJText_PolicyNo(), null);
			middlePanel.add(getPJLabel_PaymentType(), null);
			middlePanel.add(getPJCombo_PaymentType(), null);
			middlePanel.add(getAJText_PaymentType(), null);
			middlePanel.add(getPJLabel_VoucherNo(), null);
			middlePanel.add(getAJText_VoucherNo(), null);
			middlePanel.add(getPJLabel_PreAuthNo(), null);
			middlePanel.add(getAJText_PreAuthNo(), null);
			middlePanel.add(getPJLabel_CoPayActualNo(), null);
			middlePanel.add(getAJText_CoPayActualAmount(), null);
			middlePanel.add(getPJLabel_InsCoverageEndDate(), null);
			middlePanel.add(getAJText_InsCoverageEndDate(), null);
			middlePanel.add(getPJLabel_Amount(), null);
			middlePanel.add(getAJText_LimitAmount(), null);
			middlePanel.add(getPJLabel_GuarAmt(), null);
			middlePanel.add(getAJText_GuarAmt(), null);
			middlePanel.add(getPJLabel_GuarDate(), null);
			middlePanel.add(getAJText_GuarDate(), null);
			middlePanel.add(getPJLabel_CoveredItem(), null);
			middlePanel.add(getPJLabel_Doctor(), null);
			middlePanel.add(getPJCheckBox_Doctor(), null);
			middlePanel.add(getPJLabel_Hospital(), null);
			if (YES_VALUE.equals(getSysParameter("PBkAMCCMP"))) {
				middlePanel.add(getPJLabel_RevLog(), null);
				middlePanel.add(getPJCheckBox_Revlog(), null);
				middlePanel.add(getPJLabel_EstGiven(), null);
				middlePanel.add(getPJCheckBox_EstGiven(), null);
				middlePanel.add(getRightJLabel_LogCvrCls(), null);
				middlePanel.add(getRightJCombo_LogCvrCls(), null);
			}
			middlePanel.add(getPJCheckBox_Hospital(), null);
			middlePanel.add(getPJLabel_Special(), null);
			middlePanel.add(getPJCheckBox_Special(), null);
			middlePanel.add(getPJLabel_Othen(), null);
			middlePanel.add(getPJCheckBox_Other(), null);
		}
		return middlePanel;
	}

	public LabelBase getPJLabel_ArCode() {
		if (PJLabel_ArCode == null) {
			PJLabel_ArCode = new LabelBase();
			PJLabel_ArCode.setText("AR Co");
			PJLabel_ArCode.setBounds(10, -10, 80, 20);
		}
		return PJLabel_ArCode;
	}

	public ComboARCompany getPJCombo_ArCode() {
		if (PJCombo_ArCode == null) {
			PJCombo_ArCode = new ComboARCompany(true) {

				@Override
				protected void onPressed(FieldEvent fe) {
					if (fe.getKeyCode() == KeyCodes.KEY_TAB) {
						if (!isEmpty()) {
							final String arccode = getText();
							if (findModelByKey(arccode, true) == null) {
								resetText();
								return;
							}

							if (!isShowPopUp) {
								QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
										new String[] {"ARCARDTYPE", "COUNT(1)", "arccode = upper('" + arccode + "') and actactive = -1"},
										new MessageQueueCallBack() {
									@Override
									public void onPostSuccess(MessageQueue mQueue) {
										if (mQueue.success()) {
											if (!arccode.equals(memArcCode)) {
												memActID = ConstantsVariable.EMPTY_VALUE;
												getRightJText_ARCardType().resetText();
											}
											getDlgARCardTypeSel().showDialog(arccode, memActID);
										} else {
											memActID = ConstantsVariable.EMPTY_VALUE;
											getRightJText_ARCardType().resetText();
										}
									}
								});
							}
						}
					}
				}
				@Override
				public void setSelectedIndex(ModelData modelData) {
					super.setSelectedIndex(modelData);
					if (modelData != null && previousModelData != null &&
							modelData.equals(previousModelData)) {
						enableMiddlePanel(true);
					}
				}

				@Override
				protected void setTextPanel(ModelData modelData) {
					if (modelData != null) {
						enableMiddlePanel(true);
						if (initPBReady) {
							if (Factory.getInstance().getSysParameter("ArBlockEvt").length() > 0 &&
									(Factory.getInstance().getSysParameter("ArBlockEvt").equals(getText()) ||
									(memArcCode != null && Factory.getInstance().getSysParameter("ArBlockEvt").equals(memArcCode)))) {
								return;
							}
							retrieveAR();
						} else {
							initPBReady = true;
						}
					} else {
						if (Factory.getInstance().getSysParameter("ArBlockEvt").length() > 0) {
							if ((memArcCode != null && Factory.getInstance().getSysParameter("ArBlockEvt").equals(memArcCode)) ||
									getText().length() == 0) {
								return;
							}
						}
						enableMiddlePanel(false);
						clearAREntry();
					}
				}

				@Override
				protected void clearPostAction() {
					if (Factory.getInstance().getSysParameter("ArBlockEvt").length() > 0) {
						if ((memArcCode != null && Factory.getInstance().getSysParameter("ArBlockEvt").equals(memArcCode)) ||
								getText().length() == 0) {
							return;
						}
					}
					enableMiddlePanel(false);
					clearAREntry();
				}
				/*
				@Override
				public void onSelected() {
					if (!PJCombo_ArCode.isEmpty()) {
						enableMiddlePanel(true);
						if (initPBReady) {
							retrieveAR();
						} else {
							initPBReady = true;
						}
					} else {
						enableMiddlePanel(false);
						getPJCombo_PaymentType().reset();
						getAJText_LimitAmount().setText(ZERO_VALUE);
						getAJText_InsCoverageEndDate().reset();
						getAJText_PaymentType().setText(ZERO_VALUE);
						getAJText_GuarAmt().setText(ZERO_VALUE);
						getAJText_GuarDate().reset();
						getPJCheckBox_Doctor().reset();
						getPJCheckBox_Hospital().reset();
						getPJCheckBox_Special().reset();
						getPJCheckBox_Other().reset();
					}
				}
				*/
			};
			PJCombo_ArCode.setBounds(125, -10, 100, 20);
		}
		return PJCombo_ArCode;
	}

	private void clearAREntry() {
		getPJCombo_PaymentType().reset();
		getAJText_LimitAmount().setText(ZERO_VALUE);
		getAJText_InsCoverageEndDate().reset();
		getAJText_PaymentType().setText(ZERO_VALUE);
		getAJText_GuarAmt().setText(ZERO_VALUE);
		getAJText_CoPayActualAmount().setText(ZERO_VALUE);
		getAJText_GuarDate().reset();
		getPJCheckBox_Doctor().reset();
		getPJCheckBox_Hospital().reset();
		getPJCheckBox_Special().reset();
		getPJCheckBox_Other().reset();
	}

	private DlgARCardTypeSel getDlgARCardTypeSel() {
		dlgARCardTypeSel = new DlgARCardTypeSel(Factory.getInstance().getMainFrame())  {
			@Override
			public void post(String ArcCode, String ARCardType, String ARCardName, String ARCardDesc, String ARCardCode) {
				if (ARCardType != null && ARCardType.trim().length() > 0) {
					memActID = ARCardType;
				} else {
					memActID = EMPTY_VALUE;
				}
				getRightJText_ARCardType().setText(ARCardName);

				if (memActID.length() > 0) {
					getDlgARCardRemark().showDialog(null, ArcCode, memActID, "I", true, true);
				}
			}

			@Override
			public void dispose() {
				super.dispose();
				isCloseDlgARCardTypeSel = true;
			}
		};

		return dlgARCardTypeSel;
	}

	private DlgARCardRemark getDlgARCardRemark() {
		if (dlgARCardRemark == null) {
			dlgARCardRemark = new DlgARCardRemark(getMainFrame()) {
				@Override
				public void post(String source, String actCode, String actId) {
					// return to child class
					dispose();
				}

				@Override
				public void dispose() {
					super.dispose();
					isCloseDlgARCardRemark = true;
				}
			};
		}
		return dlgARCardRemark;
	}

	private TextReadOnly getRightJText_ARCompanyDesc() {
		if (PJText_ARCompanyDesc == null) {
			PJText_ARCompanyDesc = new TextReadOnly();
			PJText_ARCompanyDesc.setBounds(230, -10, 80, 20);
		}
		return PJText_ARCompanyDesc;
	}

	private TextReadOnly getRightJText_ARCardType() {
		if (PJText_ARCardType == null) {
			PJText_ARCardType = new TextReadOnly();
			PJText_ARCardType.setBounds(312, -10, 80, 20);
		}
		return PJText_ARCardType;
	}

	public LabelBase getPJLabel_PolicyNo() {
		if (PJLabel_PolicyNo == null) {
			PJLabel_PolicyNo = new LabelBase();
			PJLabel_PolicyNo.setText("Policy No.");
			PJLabel_PolicyNo.setBounds(400, -10, 80, 20);
		}
		return PJLabel_PolicyNo;
	}

	public TextString getAJText_PolicyNo() {
		if (AJText_PolicyNo == null) {
			AJText_PolicyNo = new TextString(20, true) {
				@Override
				public void onBlur() {
					isCloseDlgARCardRemark = false;
					isCloseDlgARCardTypeSel = false;
				}
			};
			AJText_PolicyNo.setBounds(485, -10, 255, 20);
		}
		return AJText_PolicyNo;
	}

	public LabelBase getPJLabel_PaymentType() {
		if (PJLabel_PaymentType == null) {
			PJLabel_PaymentType = new LabelBase();
			PJLabel_PaymentType.setText("Co-Pay");
			PJLabel_PaymentType.setBounds(10, 13, 120, 20);
		}
		return PJLabel_PaymentType;
	}

	public ComboCoPayRefType getPJCombo_PaymentType() {
		if (PJCombo_PaymentType == null) {
			PJCombo_PaymentType = new ComboCoPayRefType();
			PJCombo_PaymentType.setBounds(125, 13, 80, 20);
		}
		return PJCombo_PaymentType;
	}

	public TextAmount getAJText_PaymentType() {
		if (AJText_PaymentType == null) {
			AJText_PaymentType = new TextAmount();
			AJText_PaymentType.setBounds(210, 13, 80, 20);
		}
		return AJText_PaymentType;
	}

	public LabelBase getPJLabel_VoucherNo() {
		if (PJLabel_VoucherNo == null) {
			PJLabel_VoucherNo = new LabelBase();
			PJLabel_VoucherNo.setText("Vchr #");
			PJLabel_VoucherNo.setBounds(300, 13, 80, 20);
		}
		return PJLabel_VoucherNo;
	}

	public TextString getAJText_VoucherNo() {
		if (AJText_VoucherNo == null) {
			AJText_VoucherNo = new TextString(40, true);
			AJText_VoucherNo.setBounds(345, 13, 90, 20);
		}
		return AJText_VoucherNo;
	}

	private LabelBase getPJLabel_PreAuthNo() {
		if (PJLabel_PreAuthNo == null) {
			PJLabel_PreAuthNo = new LabelBase();
			PJLabel_PreAuthNo.setText("Auth #");
			PJLabel_PreAuthNo.setBounds(440, 13, 80, 20);
		}
		return PJLabel_PreAuthNo;
	}

	private TextString getAJText_PreAuthNo() {
		if (AJText_PreAuthNo == null) {
			AJText_PreAuthNo = new TextString(20, true);
			AJText_PreAuthNo.setBounds(485, 13, 90, 20);
		}
		return AJText_PreAuthNo;
	}

	public LabelBase getPJLabel_CoPayActualNo() {
		if (PJLabel_CoPayActualNo == null) {
			PJLabel_CoPayActualNo = new LabelBase();
			PJLabel_CoPayActualNo.setText("Deductible");
			PJLabel_CoPayActualNo.setBounds(600, 13, 80, 20);
		}
		return PJLabel_CoPayActualNo;
	}

	public TextAmount getAJText_CoPayActualAmount() {
		if (AJText_CoPayActualAmount == null) {
			AJText_CoPayActualAmount = new TextAmount() {
				@Override
				public void onBlur() {
					if (!isEmpty()) {
						if (!TextUtil.isInteger(AJText_CoPayActualAmount.getText().toString())) {
							Factory.getInstance().addErrorMessage("Please enter a integer Deductible Amount.", this);
							AJText_CoPayActualAmount.setText(ZERO_VALUE);
							return;
						}
					}
				}
			};
			AJText_CoPayActualAmount.setBounds(670, 13, 70, 20);
		}
		return AJText_CoPayActualAmount;
	}

	public LabelBase getPJLabel_InsCoverageEndDate() {
		if (PJLabel_InsCoverageEndDate == null) {
			PJLabel_InsCoverageEndDate = new LabelBase();
			PJLabel_InsCoverageEndDate.setText("<html>Insurance Coverage<br>End-Date</html>");
			PJLabel_InsCoverageEndDate.setStyleAttribute("font-size", "10");
			PJLabel_InsCoverageEndDate.setBounds(10, 30, 120, 70);
		}
		return PJLabel_InsCoverageEndDate;
	}

	public TextDate getAJText_InsCoverageEndDate() {
		if (AJText_InsCoverageEndDate == null) {
			AJText_InsCoverageEndDate = new TextDate() {
				@Override
				public void onBlur() {
					if (!AJText_InsCoverageEndDate.isEmpty()) {
						if (!AJText_InsCoverageEndDate.isValid()) {
							Factory.getInstance().addErrorMessage("The Coverage End Date is Invalid.", this);
							resetText();
							return;
						}

						getAJText_GuarDate().setText(calFurGrtDate(AJText_InsCoverageEndDate.getText()));
					}
				}
			};
			AJText_InsCoverageEndDate.setBounds(125, 36, 95, 20);
		}
		return AJText_InsCoverageEndDate;
	}

	public LabelBase getPJLabel_Amount() {
		if (PJLabel_Amount == null) {
			PJLabel_Amount = new LabelBase();
			PJLabel_Amount.setText("<html>Insurance Limit<br>Amount</html>");
			PJLabel_Amount.setStyleAttribute("font-size", "10");
			PJLabel_Amount.setBounds(222, 30, 88, 20);
		}
		return PJLabel_Amount;
	}

	public TextAmount getAJText_LimitAmount() {
		if (AJText_LimitAmount == null) {
			AJText_LimitAmount = new TextAmount() {
				@Override
				public void onBlur() {
					if (!isEmpty()) {
						if (!TextUtil.isInteger(AJText_LimitAmount.getText().toString())) {
							Factory.getInstance().addErrorMessage("Please enter a integer Limit Amount.", this);
							AJText_LimitAmount.setText(ZERO_VALUE);
							return;
						}

						getAJText_GuarAmt().setText(calFurGrtAmt(AJText_LimitAmount.getText()));
					}
				}
			};
			AJText_LimitAmount.setBounds(309, 36, 61, 20);
		}
		return AJText_LimitAmount;
	}

	public LabelBase getPJLabel_GuarAmt() {
		if (PJLabel_GuarAmt == null) {
			PJLabel_GuarAmt = new LabelBase();
			PJLabel_GuarAmt.setText("<html>Further Guarantee<br>Amount</html>");
			PJLabel_GuarAmt.setStyleAttribute("font-size", "10");
			PJLabel_GuarAmt.setBounds(380, 30, 120, 20);
		}
		return PJLabel_GuarAmt;
	}

	public TextAmount getAJText_GuarAmt() {
		if (AJText_GuarAmt == null) {
			AJText_GuarAmt = new TextAmount();
			AJText_GuarAmt.setBounds(485, 36, 64, 20);
		}
		return AJText_GuarAmt;
	}

	public LabelBase getPJLabel_GuarDate() {
		if (PJLabel_GuarDate == null) {
			PJLabel_GuarDate = new LabelBase();
			PJLabel_GuarDate.setText("<html>Further Guarantee<br>Date</html>");
			PJLabel_GuarDate.setStyleAttribute("font-size", "10");
			PJLabel_GuarDate.setBounds(550, 30, 120, 20);
		}
		return PJLabel_GuarDate;
	}

	public TextDate getAJText_GuarDate() {
		if (AJText_GuarDate == null) {
			AJText_GuarDate = new TextDate() {
				@Override
				public void onBlur() {
					if (!AJText_GuarDate.isEmpty() && !AJText_GuarDate.isValid()) {
						Factory.getInstance().addErrorMessage("The Fur.Gu.Date is Invalid.", this);
						resetText();
						return;
					}
				}
			};
			AJText_GuarDate.setBounds(650, 36, 90, 20);
		}
		return AJText_GuarDate;
	}

	public LabelBase getPJLabel_CoveredItem() {
		if (PJLabel_CoveredItem == null) {
			PJLabel_CoveredItem = new LabelBase();
			PJLabel_CoveredItem.setText("Covered Item");
			PJLabel_CoveredItem.setBounds(10, 59, 110, 70);
		}
		return PJLabel_CoveredItem;
	}
	public LabelBase getPJLabel_Doctor() {
		if (PJLabel_Doctor == null) {
			PJLabel_Doctor = new LabelBase();
			PJLabel_Doctor.setText("Dr");
			PJLabel_Doctor.setBounds(125, 59, 22, 13);
		}
		return PJLabel_Doctor;
	}

	public CheckBoxBase getPJCheckBox_Doctor() {
		if (PJCheckBox_Doctor == null) {
			PJCheckBox_Doctor = new CheckBoxBase();
			PJCheckBox_Doctor.setBounds(147, 59, 20, 20);
		}
		return PJCheckBox_Doctor;
	}

	public LabelBase getPJLabel_Hospital() {
		if (PJLabel_Hospital == null) {
			PJLabel_Hospital = new LabelBase();
			PJLabel_Hospital.setText("Hosp");
			PJLabel_Hospital.setBounds(169, 59, 45, 13);
		}
		return PJLabel_Hospital;
	}

	public CheckBoxBase getPJCheckBox_Hospital() {
		if (PJCheckBox_Hospital == null) {
			PJCheckBox_Hospital = new CheckBoxBase();
			PJCheckBox_Hospital.setBounds(214, 59, 20, 20);
		}
		return PJCheckBox_Hospital;
	}

	public LabelBase getPJLabel_Special() {
		if (PJLabel_Special == null) {
			PJLabel_Special = new LabelBase();
			PJLabel_Special.setText("Spec");
			PJLabel_Special.setBounds(236, 59, 40, 13);
		}
		return PJLabel_Special;
	}

	public CheckBoxBase getPJCheckBox_Special() {
		if (PJCheckBox_Special == null) {
			PJCheckBox_Special = new CheckBoxBase();
			PJCheckBox_Special.setBounds(276, 59, 20, 20);
		}
		return PJCheckBox_Special;
	}

	public LabelBase getPJLabel_Othen() {
		if (PJLabel_Othen == null) {
			PJLabel_Othen = new LabelBase();
			PJLabel_Othen.setText("Other");
			PJLabel_Othen.setBounds(298, 59, 35, 13);
		}
		return PJLabel_Othen;
	}

	public CheckBoxBase getPJCheckBox_Other() {
		if (PJCheckBox_Othen == null) {
			PJCheckBox_Othen = new CheckBoxBase();
			PJCheckBox_Othen.setBounds(330, 59, 20, 20);
		}
		return PJCheckBox_Othen;
	}

	public LabelBase getPJLabel_RevLog() {
		if (PJLabel_RevLog == null) {
			PJLabel_RevLog = new LabelBase();
			PJLabel_RevLog.setText("Rec'd LOG");
			PJLabel_RevLog.setBounds(352, 59, 70, 13);
		}
		return PJLabel_RevLog;
	}

	private CheckBoxBase getPJCheckBox_Revlog() {
		if (PJCheckBox_RevLog == null) {
			PJCheckBox_RevLog = new CheckBoxBase();
			PJCheckBox_RevLog.setBounds(416, 59, 20, 20);
		}
		return PJCheckBox_RevLog;
	}

	private LabelBase getRightJLabel_LogCvrCls() {
		if (RightJLabel_LogCvrCls == null) {
			RightJLabel_LogCvrCls = new LabelBase();
			RightJLabel_LogCvrCls.setText("LOG Cover Class");
			RightJLabel_LogCvrCls.setBounds(446, 59, 110, 20);
		}
		return RightJLabel_LogCvrCls;
	}

	private ComboACMCode getRightJCombo_LogCvrCls() {
		if (RightJCombo_LogCvrCls == null) {
			RightJCombo_LogCvrCls = new ComboACMCode();
			RightJCombo_LogCvrCls.setBounds(548, 59, 100, 20);
		}
		return RightJCombo_LogCvrCls;
	}

	private LabelBase getPJLabel_EstGiven() {
		if (PJLabel_EstGiven == null) {
			PJLabel_EstGiven = new LabelBase();
			PJLabel_EstGiven.setText("Est. Given");
			PJLabel_EstGiven.setBounds(660, 59, 60, 13);
		}
		return PJLabel_EstGiven;
	}

	private CheckBoxBase getPJCheckBox_EstGiven() {
		if (PJCheckBox_EstGiven == null) {
			PJCheckBox_EstGiven = new CheckBoxBase();
			PJCheckBox_EstGiven.setBounds(721, 59, 20, 20);
		}
		return PJCheckBox_EstGiven;
	}

	private FieldSetBase getDeclinePanel() {
		if (declinePanel == null) {
			declinePanel = new FieldSetBase();
			declinePanel.setHeading("Declination");
			declinePanel.setBounds(5, 420, 750, 65);
			declinePanel.add(getPJLabel_Declined(), null);
			declinePanel.add(getPJCheckBox_Declined(), null);
			declinePanel.add(getPJLabel_Reacon(), null);
			declinePanel.add(getAJText_Reacon(), null);
			declinePanel.add(getPJLabel_By(), null);
			declinePanel.add(getAJText_By(), null);
			declinePanel.add(getAJText_By1(), null);
			declinePanel.add(getPJLabel_ActivatedBy(), null);
			declinePanel.add(getAJText_ActivatedBy(), null);
			declinePanel.add(getAJText_ActivatedBy1(), null);
		}
		return declinePanel;
	}

	private LabelBase getPJLabel_Declined() {
		if (PJLabel_Declined == null) {
			PJLabel_Declined = new LabelBase();
			PJLabel_Declined.setText("Declined");
			PJLabel_Declined.setBounds(10, -10, 100, 20);
		}
		return PJLabel_Declined;
	}

	protected CheckBoxBase getPJCheckBox_Declined() {
		if (PJCheckBox_Declined == null) {
			PJCheckBox_Declined = new CheckBoxBase() {
				public void onClick() {
					enableDeclinePanel();
				}
			};
			PJCheckBox_Declined.setBounds(115, -10, 20, 20);
		}
		return PJCheckBox_Declined;
	}

	private LabelBase getPJLabel_Reacon() {
		if (PJLabel_Reacon == null) {
			PJLabel_Reacon = new LabelBase();
			PJLabel_Reacon.setText("Reason");
			PJLabel_Reacon.setBounds(195, -10, 40, 20);
		}
		return PJLabel_Reacon;
	}

	protected TextString getAJText_Reacon() {
		if (AJText_Reacon == null) {
			AJText_Reacon = new TextString(100);
			AJText_Reacon.setBounds(245, -10, 495, 20);
		}
		return AJText_Reacon;
	}

	private LabelBase getPJLabel_By() {
		if (PJLabel_By == null) {
			PJLabel_By = new LabelBase();
			PJLabel_By.setText("By");
			PJLabel_By.setBounds(10, 13, 20, 20);
		}
		return PJLabel_By;
	}

	private TextReadOnly getAJText_By() {
		if (AJText_By == null) {
			AJText_By = new TextReadOnly();
			AJText_By.setBounds(120, 13, 120, 20);
		}
		return AJText_By;
	}

	private TextReadOnly getAJText_By1() {
		if (AJText_By1 == null) {
			AJText_By1 = new TextReadOnly();
			AJText_By1.setBounds(245, 13, 130, 20);
		}
		return AJText_By1;
	}

	private LabelBase getPJLabel_ActivatedBy() {
		if (PJLabel_ActivatedBy == null) {
			PJLabel_ActivatedBy = new LabelBase();
			PJLabel_ActivatedBy.setText("Activated By");
			PJLabel_ActivatedBy.setBounds(400, 13, 70, 20);
		}
		return PJLabel_ActivatedBy;
	}

	private TextReadOnly getAJText_ActivatedBy() {
		if (AJText_ActivatedBy == null) {
			AJText_ActivatedBy = new TextReadOnly();
			AJText_ActivatedBy.setBounds(475, 13, 130, 20);
		}
		return AJText_ActivatedBy;
	}

	private TextReadOnly getAJText_ActivatedBy1() {
		if (AJText_ActivatedBy1 == null) {
			AJText_ActivatedBy1 = new TextReadOnly();
			AJText_ActivatedBy1.setBounds(610, 13, 130, 20);
		}
		return AJText_ActivatedBy1;
	}

	private LabelBase getWarningMsg() {
		if (warningMsg == null) {
			warningMsg = new LabelBase();
			warningMsg.setStyleAttribute("color", "red");
			warningMsg.setStyleAttribute("fontWeight", "bold");
			warningMsg.setStyleAttribute("fontSize", "18px");
			warningMsg.setBounds(18, 485, 606, 25);
		}
		return warningMsg;
	}
}
