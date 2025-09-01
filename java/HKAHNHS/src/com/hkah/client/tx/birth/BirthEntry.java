package com.hkah.client.tx.birth;

import java.util.Date;

import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.KeyListener;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.combobox.ComboArea;
import com.hkah.client.layout.combobox.ComboCordCutDesc;
import com.hkah.client.layout.combobox.ComboCordCutPlace;
import com.hkah.client.layout.combobox.ComboFaInfoSource;
import com.hkah.client.layout.combobox.ComboMTravelDocType;
import com.hkah.client.layout.combobox.ComboSex;
import com.hkah.client.layout.combobox.ComboYesNo;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.TabbedPaneBase;
import com.hkah.client.layout.textfield.TextAreaBase;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextDateTime;
import com.hkah.client.layout.textfield.TextNum;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.ActionPanel;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.PanelUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class BirthEntry extends ActionPanel {

	private static final String NOT_CONFIRMED = "N";
//	private static final String MANUAL = "M";

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.EBIRTHDTLUPDATE_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.EBIRTHDTLUPDATE_TITLE;
	}

	private BasePanel actionPanel = null;

	private BasePanel ParaPanel = null;
	private LabelBase LeftJLabel_MotherPatNoDesc = null;
	private LabelBase LeftJText_MotherPatNo = null;
	private LabelBase LeftJLabel_MotherNameDesc = null;
	private LabelBase LeftJText_MotherName = null;
	private LabelBase LeftJLabel_MotherDOBDesc = null;
	private LabelBase LeftJText_MotherDOB = null;
	private LabelBase LeftJLabel_BBPatNoDesc = null;
	private LabelBase LeftJText_BBPatNo = null;
	private LabelBase LeftJLabel_BBNameDesc = null;
	private LabelBase LeftJText_BBName = null;
	private LabelBase LeftJLabel_BBDOBDesc = null;
	private LabelBase LeftJText_BBDOB = null;

	private TextReadOnly BP_BBPatNo = null;
	private LabelBase SendDateFromDesc = null;
	private TextDateTime BP_DOBDT = null;
	private LabelBase slipDesc = null;
	private LabelBase BP_SexDesc = null;
	private ComboSex BP_Sex = null;
	private LabelBase redDot = null;
	private LabelBase BatchNoDesc = null;
	private TextNum order = null;
	private LabelBase BirthReturnNoDesc = null;
	private TextString BP_FName = null;

	private LabelBase HistoryDesc = null;
	private LabelBase LeftJLabel_ConfirmedByDesc = null;
	private LabelBase LeftJText_ConfirmedBy = null;
	private LabelBase LeftJLabel_ConfirmedOnDesc = null;
	private LabelBase LeftJText_ConfirmedOn = null;

	private ButtonBase LeftJButton_Confirm = null;
	private ButtonBase LeftJButton_DHRecord = null;

	private TabbedPaneBase jTabbedPane = null;
	private BasePanel babyPanel = null;
	private LabelBase LeftJLabel_MotherPatNoDesc1 = null;
	private LabelBase BP_BBPatNoDesc = null;
	private LabelBase BBDesc2 = null;
	private LabelBase BBDesc3 = null;
	private LabelBase BP_BirthDateTimeDesc = null;
	private LabelBase BBDesc5 = null;
	private LabelBase BBDesc6 = null;
	private LabelBase BBDesc7 = null;
	private LabelBase BBDesc8 = null;
	private LabelBase BBDesc9 = null;
	private LabelBase BP_BBPatNoDesc0 = null;
	private TextString BP_CFName = null;
	private TextString BP_CGName = null;
	private TextNum BP_BirthType = null;
	private ComboYesNo BP_Arrival = null;
	private TextAreaBase remark = null;
	private LabelBase BP_RefNo = null;
	private LabelBase BP_ReturnNo = null;
	private ComboCordCutPlace BP_Place = null;
	private ComboCordCutDesc BP_BirthStatus = null;
	private LabelBase BBDesc21 = null;
	private LabelBase BBDesc211 = null;
	private LabelBase BP_SlipNo = null;
	private TextString BP_PlaceDesc = null;
	private TextString BP_GName = null;
	private ComboYesNo BP_OnArrival = null;
	private LabelBase redDot1 = null;
	private LabelBase redDot11 = null;
	private LabelBase redDot12 = null;
	private LabelBase redDot13 = null;
	private LabelBase redDot14 = null;
	private LabelBase redDot15 = null;
	private LabelBase redDot141 = null;
	private LabelBase redDot142 = null;
	private LabelBase BP_MandatoryForConfirmDesc = null;
	private BasePanel motherPanel = null;
	private TextDate MDOB = null;
	private LabelBase slipDesc1 = null;
	private ComboYesNo MHolder = null;
	private TextReadOnly moPatNo = null;
	private TextString MFName = null;
	private TextString MEmail = null;
	private LabelBase redDot2 = null;
	private LabelBase BP_SexDesc1 = null;
	private LabelBase HistoryDesc1 = null;
	private LabelBase LeftJLabel_MotherPatNoDesc11 = null;
	private LabelBase BP_BBPatNoDesc1 = null;
	private LabelBase BBDesc22 = null;
	private LabelBase BBDesc31 = null;
	private LabelBase BBDesc32 = null;
	private LabelBase BP_BirthDateTimeDesc1 = null;
	private LabelBase BBDesc51 = null;
	private LabelBase BBDesc61 = null;
	private LabelBase BBDesc71 = null;
	private LabelBase BBDesc81 = null;
	private LabelBase BBDesc91 = null;
	private LabelBase BP_BBPatNoDesc01 = null;
	private TextString MFCName = null;
	private TextString MGCName = null;
	private TextString MHKID = null;
	private TextString MPNo = null;
	private TextString MResidence = null;
	private ComboMTravelDocType MPType = null;
	private TextString MContactNO = null;
	private LabelBase BBDesc212 = null;
	private LabelBase MSlipNo = null;
	private TextString MGName = null;
	private ComboYesNo MExact = null;
	private LabelBase redDot16 = null;
	private LabelBase redDot143 = null;
	private LabelBase BP_MandatoryForConfirmDesc1 = null;
	private TextString MCase = null;
	private BasePanel fatherPanel = null;
	private TextDate FDOB = null;
	private ComboYesNo FHolder = null;
	private TextPatientNoSearch FPatNo = null;
	private TextString FFName = null;
	private TextString FEmail = null;
	private LabelBase redDot21 = null;
	private LabelBase BP_SexDesc11 = null;
	private LabelBase FInfoSourceDesc = null;
	private LabelBase BP_BBPatNoDesc11 = null;
	private LabelBase BBDesc221 = null;
	private LabelBase BBDesc311 = null;
	private LabelBase BBDesc313 = null;
	private LabelBase BP_BirthDateTimeDesc11 = null;
	private LabelBase BBDesc511 = null;
	private LabelBase BBDesc611 = null;
	private LabelBase BBDesc711 = null;
	private LabelBase BBDesc811 = null;
	private LabelBase BBDesc911 = null;
	private LabelBase BP_BBPatNoDesc011 = null;
	private TextString FFCName = null;
	private TextString FGCName = null;
	private TextString FHKID = null;
	private TextString FPNo = null;
	private TextString FResidence = null;
	private ComboMTravelDocType FPType = null;
	private TextString FContactNo = null;
	private LabelBase BBDesc2121 = null;
	private TextString FGName = null;
	private ComboYesNo FExact = null;
	private LabelBase redDot161 = null;
	private LabelBase redDot1431 = null;
	private LabelBase BP_MandatoryForConfirmDesc11 = null;
	private ComboFaInfoSource FInfoSource = null;
	private LabelBase redDot14311 = null;
	private BasePanel addressPanel = null;
	private TextString bldg = null;
	private LabelBase slipDesc12 = null;
	private TextString lot = null;
	private TextString flat = null;
	private ComboArea area = null;
	private LabelBase redDot22 = null;
	private LabelBase HistoryDesc12 = null;
	private LabelBase BP_BBPatNoDesc12 = null;
	private LabelBase BBDesc222 = null;
	private LabelBase BBDesc312 = null;
	private LabelBase BP_BirthDateTimeDesc12 = null;
	private LabelBase BBDesc412 = null;
	private LabelBase BBDesc512 = null;
	private LabelBase BBDesc612 = null;
	private LabelBase BBDesc712 = null;
	private LabelBase BBDesc812 = null;
	private LabelBase BBDesc912 = null;
	private LabelBase AP_NameOfHospitalDesc = null;
	private TextString house = null;
	private TextString estate = null;
	private TextString street = null;
	private TextString hospital = null;
	private TextString district = null;
	private TextString lotNo = null;
	private LabelBase BBDesc2122 = null;
	private TextString floor = null;
	private TextString block = null;
	private LabelBase redDot162 = null;
	private LabelBase redDot1432 = null;
	private LabelBase BP_MandatoryForConfirmDesc12 = null;
	private LabelBase redDot14321 = null;

	private String memBBPatNo;
	private String sClickStatus;
	private boolean bCanEdit = false;
	private boolean bCanConfirm = false;
	private boolean bConfirmEnabled = false;
	private boolean bToDHEnabled = false;

	private LabelBase BP_BBDTFormat = null;
	private LabelBase MDTFormat = null;
	private LabelBase FDTFormat = null;

	boolean fHKIDValie = true;
	boolean mHKIDValie = true;
	/**
	 * This method initializes
	 *
	 */

	public BirthEntry() {
		super();//
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		// screen need to render in order to get value
		getJTabbedPane().setSelectedIndexWithoutStateChange(3);
		getJTabbedPane().setSelectedIndexWithoutStateChange(2);
		getJTabbedPane().setSelectedIndexWithoutStateChange(1);
		getJTabbedPane().setSelectedIndexWithoutStateChange(0);

		bCanEdit = "YES".equals(getParameter("sCanEdit"));
		bCanConfirm = "YES".equals(getParameter("sCanConfirm"));
		bConfirmEnabled = !isDisableFunction("cmdConfirm", "BirthEntry");
		bToDHEnabled = !isDisableFunction("cmdToDH", "BirthEntry");

		getHospital().setText(getSysParameter("HosSupName"));

		memBBPatNo = EMPTY_VALUE;
		if (getParameter("BB_PATNO") != null) {
			memBBPatNo = getParameter("BB_PATNO");
		}

		if (!memBBPatNo.isEmpty()) {
			showInfo(memBBPatNo);
			getBP_BBPatNo().setText(memBBPatNo);
		}

		setAllRightFieldsEnabled(false);
		enableButton();
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextReadOnly getDefaultFocusComponent() {
		return getBP_BBPatNo();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {
		setAllRightFieldsEnabled(false);
		showInfo(memBBPatNo);
	}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {
	}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
		getClearButton().setEnabled(false);
		setAllRightFieldsEnabled(true);
	}

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
	protected void getFetchOutputValues(String[] outParam) {
	}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		String[] param = new String[] {
				getBP_BBPatNo().getText(),
				getBP_GName().getText(),
				getBP_FName().getText(),
				getBP_CFName().getText(),
//				getBP_CGName().getText(),
				getBP_Sex().getText(),
				getBP_DOBDT().getText().length() >= 10 ? getBP_DOBDT().getText().substring(0, 10).trim() : EMPTY_VALUE,
				getBP_DOBDT().getText().length() > 10 ? getBP_DOBDT().getText().substring(10).trim() : EMPTY_VALUE,
				getBP_BirthType().getText(),
				getOrder().getText(),
				getBP_Arrival().getText(),
				getBP_OnArrival().getText(),
				getBP_Place().getText(),
				getBP_PlaceDesc().getText(),
				getBP_BirthStatus().getText(),
				getRemark().getText(),
				getMoPatNo().getText(),
				getMHKID().getText(),
				getMPNo().getText(),
				getMPType().getText(),
				getMGName().getText(),
				getMFName().getText(),
				getMFCName().getText(),
//				getMGCName().getText(),
				getMDOB().getText(),
				getMContactNO().getText(),
				getMHolder().getText(),
				getMExact().getText(),
				getMResidence().getText(),
				getMEmail().getText(),
				getHospital().getText(),
				getFInfoSource().getText(),
				getFPatNo().getText(),
				getFHKID().getText(),
				getFPNo().getText(),
				getFPType().getText(),
				getFGName().getText(),
				getFFName().getText(),
				getFFCName().getText(),
//				getFGCName().getText(),
				getFDOB().getText(),
				getFHolder().getText(),
				getFExact().getText(),
				getMCase().getText(),
				getFContactNo().getText(),
				getFResidence().getText(),
				getAddType(),//ADDTYPE...
				getFlat().getText(),
				getFloor().getText(),
//				getBlock().getText(),
				getHouse().getText(),
				getLot().getText(),
				getLotNo().getText(),
				getBldg().getText(),
				getEstate().getText(),
				getStreet().getText(),
				getDistrict().getText(),
				getArea().getText(),
				getUserInfo().getUserID()
		};
		return param;
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {
		boolean returnValue = true;
		int birthOrder = 0;
		int birthType = 0;

		if (getOrder().getText() != null && getOrder().getText().length() > 0) {
			birthOrder = Integer.parseInt(getOrder().getText());
		}

		getJTabbedPane().setSelectedIndexWithoutStateChange(0);

		if (!getBP_BirthType().isEmpty()) {
			if (TextUtil.isNumber(getBP_BirthType().getText().trim())) {
				birthType = Integer.parseInt(getBP_BirthType().getText());
				if (birthType < 1) {
					Factory.getInstance().addErrorMessage("Baby's Exact No. of Foetus is invalid.", getBP_BirthType());
					return;
				}
			} else {
				Factory.getInstance().addErrorMessage("Baby's Exact No. of Foetus is invalid.", getBP_BirthType());
				return;
			}
		 }

		if (getOrder().isEmpty()) {
			Factory.getInstance().addErrorMessage("Baby's birth order is empty.", getOrder());
			return;
		} else {
			if (TextUtil.isNumber(getOrder().getText().trim())) {
				birthOrder = Integer.parseInt(getOrder().getText().trim());
				if (birthOrder < 1) {
					Factory.getInstance().addErrorMessage("Birth Order is invalid. Please input a digit.", getOrder());
					return;
				}
			} else {
				Factory.getInstance().addErrorMessage("Birth Order is invalid. Please input a digit.", getOrder());
				return;
			}
		}

		if (birthOrder > birthType) {
			Factory.getInstance().addErrorMessage("Baby's birth order is invalid.", getOrder());
			return;
		}

		if (!getBP_DOBDT().isEmpty()) {
			if (getBP_DOBDT().isValid()) {
				if (getBP_DOBDT().getText() != null && getBP_DOBDT().getText().length()>0) {
					int dobYear = Integer.parseInt(getBP_DOBDT().getText().substring(0, 4));
					if (dobYear < Integer.parseInt(DateTimeUtil.getCurrentYear()) - 1 ||
							dobYear > Integer.parseInt(DateTimeUtil.getCurrentYear())) {
						Factory.getInstance().addErrorMessage("Baby's birth date is invalid.", getBP_DOBDT());
						return;
					}
				}
			} else {
				Factory.getInstance().addErrorMessage("Baby's birth date is invalid.", getBP_DOBDT());
				return;
			}
		}

		getJTabbedPane().setSelectedIndexWithoutStateChange(1);

		if (!getMDOB().isEmpty()) {
			int dobYear = Integer.parseInt(getMDOB().getText().substring(0, 4));
			if (!getMDOB().isValid()) {
				Factory.getInstance().addErrorMessage("Mother's birth date is invalid.", getMDOB());
				return;
			} else if (dobYear < 1901) {
				Factory.getInstance().addErrorMessage("Mother's birth date is invalid.", getMDOB());
				return;
			}
		}

		if (!getMHKID().isEmpty()) {
			if (!check_hkid(getMHKID().getText().trim())) {
				Factory.getInstance().addErrorMessage("Mother's HKID number is invalid.", getMHKID());
				return;
			}
		}

		getJTabbedPane().setSelectedIndexWithoutStateChange(2);

		if (!getFDOB().isEmpty()) {
			int dobYear = 0;
			if (getFDOB().getText() != null && getFDOB().getText().length() > 0) {
				dobYear = Integer.parseInt(getFDOB().getText().substring(0, 4));
			}

			if (!getFDOB().isValid()) {
				Factory.getInstance().addErrorMessage("Father's birth date is invalid.", getFDOB());
				return;
			} else if (dobYear < 1901) {
				Factory.getInstance().addErrorMessage("Father's birth date is invalid.", getFDOB());
				return;
			}
		}

		if (!getFHKID().isEmpty()) {
			if (!check_hkid(getFHKID().getText().trim())) {
				Factory.getInstance().addErrorMessage("Father's HKID number is invalid.", getFHKID());
				return;
			}
		}

		if (!checkIsChinese_All()) {
			return;
		};

		if (!checkFatherInfo()) {
			return;
		}

		if (!checkTxtBoxExp()) {
			return;
		}

		getJTabbedPane().setSelectedIndexWithoutStateChange(0);

		actionValidationReady(actionType, returnValue);
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected void actionValidationReady(final String actionType, boolean isValidationReady) {
		if (isValidationReady) {
			updateEBirthDtl();
		}
	}

	@Override
	protected void savePostAction() {
		sClickStatus = null;
		enableButton();

		getLeftJButton_Confirm().setEnabled(bConfirmEnabled && bCanConfirm);
		getLeftJButton_DHRecord().setEnabled(bToDHEnabled);

		setParameter("AFTER_ENTRY","YES");
	}

	@Override
	public void cancelAction() {
		getLeftJButton_Confirm().setEnabled(bConfirmEnabled && bCanConfirm);
		getLeftJButton_DHRecord().setEnabled(bToDHEnabled);

		super.cancelAction();
	}

	@Override
	public void modifyAction() {
		sClickStatus = "E";
		getBP_FName().requestFocus();
		getLeftJButton_Confirm().setEnabled(false);
		getLeftJButton_DHRecord().setEnabled(false);
		super.modifyAction();
	}

	@Override
	public void deleteAction() {
		Factory.getInstance().isConfirmYesNoDialog("Confirm delete?",
				new Listener<MessageBoxEvent>() {
			@Override
			public void handleEvent(MessageBoxEvent be) {
				if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
					QueryUtil.executeMasterAction(
							getUserInfo(), ConstantsTx.EBIRTHDTLUPDATE_TXCODE, QueryUtil.ACTION_DELETE,
							getActionInputParamaters(),
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								bCanEdit = false;
								bCanConfirm = false;
								exitPanel();
							}
							Factory.getInstance().addErrorMessage(mQueue.getReturnMsg());
						}
					});
				}
			}
		});
	}

	@Override
	protected void enableButton(String mode) {
		super.enableButton(mode);
		getSearchButton().setEnabled(false);
		getAppendButton().setEnabled(false);

		if (sClickStatus != null) {
			getSaveButton().setEnabled(true);
		} else {
			getSaveButton().setEnabled(false);
		}

		if (sClickStatus != null) {
			getCancelButton().setEnabled(true);
		} else {
			getCancelButton().setEnabled(false);
		}

		if (bCanEdit && !isDisableFunction("Edit", "BirthEntry")) {
			if (sClickStatus == null && getBP_BBPatNo().getText() != null && getBP_BBPatNo().getText().length() > 0) {
				getModifyButton().setEnabled(true);
			} else {
				getModifyButton().setEnabled(false);
			}
		} else {
			getModifyButton().setEnabled(false);
		}

		getDeleteButton().setEnabled(!isDisableFunction("Delete", "BirthEntry"));

		boolean isAction = getActionType() != null && (isAppend() || isModify() || isDelete());

		getLeftJButton_Confirm().setEnabled(mode == null && !isAction && bConfirmEnabled && bCanConfirm);
	}

	@Override
	protected void setAllRightFieldsEnabled(boolean enable) {
		PanelUtil.setAllFieldsEditable(getBabyPanel(), enable);
		PanelUtil.setAllFieldsEditable(getMotherPanel(), enable);
		PanelUtil.setAllFieldsEditable(getFatherPanel(), enable);
		PanelUtil.setAllFieldsEditable(getAddressPanel(), enable);
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	private boolean checkIsChinese_All() {
		getJTabbedPane().setSelectedIndexWithoutStateChange(0);

		if (TextUtil.isChinese(getBP_BBPatNo().getText())) {
			Factory.getInstance().addErrorMessage("Chinese characters are not allowed.", getBP_BBPatNo());
			return false;
		}
		if (TextUtil.isChinese(getRemark().getText())) {
			Factory.getInstance().addErrorMessage("Chinese characters are not allowed.", getRemark());
			return false;
		}
		if (TextUtil.isChinese(getBP_PlaceDesc().getText())) {
			Factory.getInstance().addErrorMessage("Chinese characters are not allowed.", getBP_PlaceDesc());
			return false;
		}
		if (TextUtil.isChinese(getBP_GName().getText())) {
			Factory.getInstance().addErrorMessage("Chinese characters are not allowed.", getBP_GName());
			return false;
		}
		if (TextUtil.isChinese(getBP_FName().getText())) {
			Factory.getInstance().addErrorMessage("Chinese characters are not allowed.", getBP_FName());
			return false;
		}
		if (TextUtil.isChinese(getBP_DOBDT().getText())) {
			Factory.getInstance().addErrorMessage("Chinese characters are not allowed.", getBP_DOBDT());
			return false;
		}

		getJTabbedPane().setSelectedIndexWithoutStateChange(1);

		if (TextUtil.isChinese(getMDOB().getText())) {
			Factory.getInstance().addErrorMessage("Chinese characters are not allowed.", getMDOB());
			return false;
		}
		if (TextUtil.isChinese(getMoPatNo().getText())) {
			Factory.getInstance().addErrorMessage("Chinese characters are not allowed.", getMoPatNo());
			return false;
		}
		if (TextUtil.isChinese(getMFName().getText())) {
			Factory.getInstance().addErrorMessage("Chinese characters are not allowed.", getMFName());
			return false;
		}
		if (TextUtil.isChinese(getMEmail().getText())) {
			Factory.getInstance().addErrorMessage("Chinese characters are not allowed.", getMEmail());
			return false;
		}
		if (TextUtil.isChinese(getMHKID().getText())) {
			Factory.getInstance().addErrorMessage("Chinese characters are not allowed.", getMHKID());
			return false;
		}
		if (TextUtil.isChinese(getMPNo().getText())) {
			Factory.getInstance().addErrorMessage("Chinese characters are not allowed.", getMPNo());
			return false;
		}
		if (TextUtil.isChinese(getMResidence().getText())) {
			Factory.getInstance().addErrorMessage("Chinese characters are not allowed.", getMResidence());
			return false;
		}
		if (TextUtil.isChinese(getMContactNO().getText())) {
			Factory.getInstance().addErrorMessage("Chinese characters are not allowed.", getMContactNO());
			return false;
		}
		if (TextUtil.isChinese(getMGName().getText())) {
			Factory.getInstance().addErrorMessage("Chinese characters are not allowed.", getMGName());
			return false;
		}
		if (TextUtil.isChinese(getMCase().getText())) {
			Factory.getInstance().addErrorMessage("Chinese characters are not allowed.", getMCase());
			return false;
		}

		getJTabbedPane().setSelectedIndexWithoutStateChange(2);

		if (TextUtil.isChinese(getFDOB().getText())) {
			Factory.getInstance().addErrorMessage("Chinese characters are not allowed.", getFDOB());
			return false;
		}
		if (TextUtil.isChinese(getFPatNo().getText())) {
			Factory.getInstance().addErrorMessage("Chinese characters are not allowed.", getFPatNo());
			return false;
		}
		if (TextUtil.isChinese(getFFName().getText())) {
			Factory.getInstance().addErrorMessage("Chinese characters are not allowed.", getFFName());
			return false;
		}
		if (TextUtil.isChinese(getFHKID().getText())) {
			Factory.getInstance().addErrorMessage("Chinese characters are not allowed.", getFHKID());
			return false;
		}
		if (TextUtil.isChinese(getFPNo().getText())) {
			Factory.getInstance().addErrorMessage("Chinese characters are not allowed.", getFPNo());
			return false;
		}
		if (TextUtil.isChinese(getFResidence().getText())) {
			Factory.getInstance().addErrorMessage("Chinese characters are not allowed.", getFResidence());
			return false;
		}
		if (TextUtil.isChinese(getFContactNo().getText())) {
			Factory.getInstance().addErrorMessage("Chinese characters are not allowed.", getFContactNo());
			return false;
		}

		getJTabbedPane().setSelectedIndexWithoutStateChange(3);

		if (TextUtil.isChinese(getHospital().getText())) {
			Factory.getInstance().addErrorMessage("Chinese characters are not allowed.", getHospital());
			return false;
		}
		return true;
	}

	private boolean checkFatherInfo() {
//		if (getFInfoSource().getSelectedIndex() == 0 || getFInfoSource().getSelectedIndex() == 1) {
			if (getFInfoSource().getText() != null) {
			if (getFFName().getText() != null) {
				if (getFGName().getText() != null) {
					if (getFDOB().getText() != null) {
						if (getFHKID().getText() != null ||getFPNo().getText() != null) {
							return true;
						} else {
							getJTabbedPane().setSelectedIndexWithoutStateChange(2);
							Factory.getInstance().addErrorMessage("Father's information is missing. (Family Name, Given Name, Date of Birth and HKID/Passport No.)", getFHKID());
							return false;
						}
					} else {
						getJTabbedPane().setSelectedIndexWithoutStateChange(2);
						Factory.getInstance().addErrorMessage("Father's information is missing. (Family Name, Given Name, Date of Birth and HKID/Passport No.)", getFDOB());
						return false;
					}
				} else {
					getJTabbedPane().setSelectedIndexWithoutStateChange(2);
					Factory.getInstance().addErrorMessage("Father's information is missing. (Family Name, Given Name, Date of Birth and HKID/Passport No.)", getFGName());
					return false;
				}
			} else {
				getJTabbedPane().setSelectedIndexWithoutStateChange(2);
				Factory.getInstance().addErrorMessage("Father's information is missing. (Family Name, Given Name, Date of Birth and HKID/Passport No.)", getFFName());
				return false;
			}
		} else {
			return true;
		}
	}

	private boolean checkTxtBoxExp() {
		getJTabbedPane().setSelectedIndexWithoutStateChange(0);

		if (TextUtil.isExceedMaxLengthByAscCode(getBP_CFName().getText(), 20)) {
			Factory.getInstance().addErrorMessage("Baby's name is too long.", getBP_CFName());
			return false;
		}
		if (TextUtil.isExceedMaxLengthByAscCode(getBP_CGName().getText(), 10)) {
			Factory.getInstance().addErrorMessage("Baby's name is too long.", getBP_CGName());
			return false;
		}

		getJTabbedPane().setSelectedIndexWithoutStateChange(1);

		if (TextUtil.isExceedMaxLengthByAscCode(getMFCName().getText(), 20)) {
			Factory.getInstance().addErrorMessage("Mother's name is too long.", getMFCName());
			return false;
		}
		if (TextUtil.isExceedMaxLengthByAscCode(getMGCName().getText(), 10)) {
			Factory.getInstance().addErrorMessage("Mother's name is too long.", getMGCName());
			return false;
		}

		getJTabbedPane().setSelectedIndexWithoutStateChange(2);

		if (TextUtil.isExceedMaxLengthByAscCode(getFFCName().getText(), 20)) {
			Factory.getInstance().addErrorMessage("Father's name is too long.", getFFCName());
			return false;
		}
		if (TextUtil.isExceedMaxLengthByAscCode(getFGCName().getText(), 10)) {
			Factory.getInstance().addErrorMessage("Father's name is too long.", getFGCName());
			return false;
		}

		getJTabbedPane().setSelectedIndexWithoutStateChange(3);

		if (TextUtil.isExceedMaxLengthByAscCode(getFlat().getText(), 8)) {
			Factory.getInstance().addErrorMessage("Flat is too long.", getFlat());
			return false;
		}
		if (TextUtil.isExceedMaxLengthByAscCode(getFloor().getText(), 4)) {
			Factory.getInstance().addErrorMessage("Floor is too long.", getFloor());
			return false;
		}
		if (TextUtil.isExceedMaxLengthByAscCode(getBlock().getText(), 15)) {
			Factory.getInstance().addErrorMessage("Block is too long", getBlock());
			return false;
		}
		if (TextUtil.isExceedMaxLengthByAscCode(getHouse().getText(), 8)) {
			Factory.getInstance().addErrorMessage("House is too long.", getHouse());
			return false;
		}
		if (TextUtil.isExceedMaxLengthByAscCode(getBldg().getText(), 44)) {
			Factory.getInstance().addErrorMessage("Bldg is too long.", getBldg());
			return false;
		}
		if (TextUtil.isExceedMaxLengthByAscCode(getEstate().getText(), 44)) {
			Factory.getInstance().addErrorMessage("Estate is too long.", getEstate());
			return false;
		}
		if (TextUtil.isExceedMaxLengthByAscCode(getStreet().getText(), 44)) {
			Factory.getInstance().addErrorMessage("Street is too long.", getStreet());
			return false;
		}
		if (TextUtil.isExceedMaxLengthByAscCode(getDistrict().getText(), 30)) {
			Factory.getInstance().addErrorMessage("District is too long.", getDistrict());
			return false;
		}
		if (TextUtil.isExceedMaxLengthByAscCode(getHospital().getText(), 25)) {
			Factory.getInstance().addErrorMessage("Name of Hospital is too long.", getHospital());
			return false;
		}
		if (TextUtil.isExceedMaxLengthByAscCode(getLot().getText(), 10)) {
			Factory.getInstance().addErrorMessage("Lot prefix is too long.", getLot());
			return false;
		}
		if (TextUtil.isExceedMaxLengthByAscCode(getLotNo().getText(), 5)) {
			Factory.getInstance().addErrorMessage("Lot No is too long.", getLotNo());
			return false;
		}

		getJTabbedPane().setSelectedIndexWithoutStateChange(0);

		return true;
	}

	private void updateEBirthDtl() {
		QueryUtil.executeMasterAction(getUserInfo(), ConstantsTx.EBIRTHDTLUPDATE_TXCODE,
				QueryUtil.ACTION_MODIFY, getActionInputParamaters(),
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
//					edit();
					setAllRightFieldsEnabled(false);
					setActionType(null);
					savePostAction();
					showInfo(memBBPatNo);
					Factory.getInstance().addInformationMessage("Save success...");
				} else {
					Factory.getInstance().addErrorMessage(mQueue.getReturnMsg());
				}
			}
		});
	}

	private void confirm() {
		int birthOrder = 0;
		int birthType = 0;

		//---------------------------baby---------------------------
		getJTabbedPane().setSelectedIndexWithoutStateChange(0);

		if (!TextUtil.isNumber(getOrder().getText().trim())) {
			Factory.getInstance().addErrorMessage("Baby's birth order is invalid.", getOrder());
			return;
		} else {
			birthOrder = Integer.parseInt(getOrder().getText().trim());
		}

		if (!TextUtil.isNumber(getOrder().getText().trim())) {
			Factory.getInstance().addErrorMessage("Baby's birth type is invalid.", getBP_BirthType());
			return;
		} else {
			birthType = Integer.parseInt(getBP_BirthType().getText().trim());
		}

		if (getBP_DOBDT().isEmpty()) {
			Factory.getInstance().addErrorMessage("Baby's birth date is empty.", getBP_DOBDT());
			return;
		} else {
			if (getBP_DOBDT().isValid()) {
				Date DOBDT = null;
				int dobYear = -1;
				int currentYear = Integer.parseInt(DateTimeUtil.getCurrentYear());
				if (getBP_DOBDT().getText().length() > 10) {
					DOBDT = DateTimeUtil.parseDateReverse(getBP_DOBDT().getText().substring(0, 10));
					if (DOBDT != null) {
						dobYear = Integer.parseInt(getBP_DOBDT().getText().substring(0, 4));
					}
				}
				if (DOBDT == null || (dobYear < currentYear - 1) || (dobYear > currentYear)) {
					Factory.getInstance().addErrorMessage("Baby's birth date is invalid.", getBP_DOBDT());
					return;
				}
			} else {
				Factory.getInstance().addErrorMessage("Baby's birth date is invalid.", getBP_DOBDT());
				return;
			}
		}

		if (getBP_Sex().isEmpty()) {
			Factory.getInstance().addErrorMessage("Baby's sex is empty.", getBP_Sex());
			return;
		}

		if (getBP_BirthType().isEmpty() || birthType < 1) {
			Factory.getInstance().addErrorMessage("Baby's Exact No. of Foetus is invalid.", getBP_BirthType());
			return;
		}

		if (getOrder().isEmpty() || birthOrder < 1 || birthOrder > birthType) {
			Factory.getInstance().addErrorMessage("Baby's birth order is invalid.", getOrder());
			return;
		}

		if (getBP_OnArrival().isEmpty()) {
			Factory.getInstance().addErrorMessage("Born on Arrival is empty.", getBP_OnArrival());
			return;
		}

		if (getBP_Arrival().isEmpty()) {
			Factory.getInstance().addErrorMessage("Born Before Arrival is empty.", getBP_Arrival());
			return;
		}

		if (getBP_Place().isEmpty()) {
			Factory.getInstance().addErrorMessage("Place of Cord Cut is empty.", getBP_Place());
			return;
		}
		//3:Other      4:Unknown
		if (getBP_Place().getSelectedIndex() == 1 ||
				getBP_Place().getSelectedIndex() == 3 ||
				getBP_Place().getSelectedIndex() == 4) {
			if (getBP_PlaceDesc().isEmpty()) {
				Factory.getInstance().addErrorMessage("Description - Place of Birth is empty.", getBP_PlaceDesc());
				return;
			}
		}

		if (getBP_BirthStatus().isEmpty()) {
			Factory.getInstance().addErrorMessage("Birth Status is empty.", getBP_BirthStatus());
			return;
		}

		//---------------------------mother-------------------------
		getJTabbedPane().setSelectedIndexWithoutStateChange(1);

		if (getMDOB().isEmpty()) {
			Factory.getInstance().addErrorMessage("Mother's birth date is empty.", getMDOB());
			return;
		}

		if (!getMDOB().isValid() || Integer.parseInt(MDOB.getText().substring(0, 4)) < 1901) {
			Factory.getInstance().addErrorMessage("Mother's birth date is invalid.", getMDOB());
			return;
		}

		if (getMGName().isEmpty()) {
			Factory.getInstance().addErrorMessage("Mother's given name is empty.", getMGName());
			return;
		}

		if (!getMPNo().isEmpty() && getMPType().isEmpty()) {
			Factory.getInstance().addErrorMessage("Mother's Passport Type is empty.", getMPType());
			return;
		}

		if (getMPNo().isEmpty() && (!getMPType().isEmpty() &&
				!"9".equals(getMPType().getText().substring(0, 1)))) {
			Factory.getInstance().addErrorMessage("Mother's Passport Type is empty.", getMPNo());
			return;
		}

		if ("N".equals(getMHolder().getText()) && getMResidence().isEmpty()) {
//			Factory.getInstance().addErrorMessage("Mother's residence is empty due to not HKID card holder.", getMResidence());
//			return;
		}

		if (getMExact().isEmpty()) {
			Factory.getInstance().addErrorMessage("Mother's Date of Birth Exact Flag is empty.", getMExact());
			return;
		}

		//-----------------------Father---------------------------------
		getJTabbedPane().setSelectedIndexWithoutStateChange(2);

		if (getFInfoSource().isEmpty()) {
			Factory.getInstance().addErrorMessage("Father Info. Source is empty.", getFInfoSource());
			return;
		}

		if (!getFPNo().isEmpty() && getFPType().isEmpty()) {
			Factory.getInstance().addErrorMessage("Father's Passport Type is empty.", getFPType());
			return;
		}

		if (getFPNo().isEmpty() &&
				(!getFPType().isEmpty() && !"9".equals(getFPType().getText().substring(0, 1)))) {
			Factory.getInstance().addErrorMessage("Father's Passport No is empty.", getFPNo());
			return;
		}

		if ("N".equals(getFHolder().getText()) && getFResidence().isEmpty()) {
			Factory.getInstance().addErrorMessage("Father's residence is empty due to not HKID card holder.", getFResidence());
			return;
		}

		if (!getFDOB().isEmpty() && getFExact().isEmpty()) {
			Factory.getInstance().addErrorMessage("Father's Date of Birth Exact Flag is empty.", getFDOB());
			return;
		}

		//-----------------------Address--------------------------------
		getJTabbedPane().setSelectedIndexWithoutStateChange(3);

		if (getDistrict().isEmpty()) {
			Factory.getInstance().addErrorMessage("District of address is empty.", getDistrict());
			return;
		}

		if (getArea().isEmpty()) {
			Factory.getInstance().addErrorMessage("Area of address is empty.", getArea());
			return;
		}

		if (getHospital().isEmpty()) {
			Factory.getInstance().addErrorMessage("Superintendent is empty.", getHospital());
			return;
		}

		if (!checkTxtBoxExp()) {
			return;
		}

		getJTabbedPane().setSelectedIndexWithoutStateChange(0);

		QueryUtil.executeMasterAction(getUserInfo(),
				ConstantsTx.EBIRTHCONFIRM_TXCODE, QueryUtil.ACTION_MODIFY,
				new String[] {memBBPatNo, getUserInfo().getUserID()},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getLeftJButton_Confirm().setEnabled(false);
					setParameter("AFTER_ENTRY","YES");
					exitPanel();
				}
			}
		});
	}

	private void edit() {
		//QueryUtil.executeMasterAction(getUserInfo(), ConstantsTx.EBIRTHCONFIRM_TXCODE, getActionType(),
		QueryUtil.executeMasterAction(getUserInfo(), "EBIRTHEDIT", QueryUtil.ACTION_MODIFY,
				new String[] {memBBPatNo, getUserInfo().getUserID()},
				new MessageQueueCallBack() {
				@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					QueryUtil.executeMasterFetch(
						Factory.getInstance().getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
								new String[] {
									"DHBIRTHDTL",
									"BBPATNO, RECSTATUS",
									"BBPATNO='" + memBBPatNo + "'"
								},
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									if (mQueue.getContentField()[0].length() > 0) {
										if (mQueue.getContentField()[1].equals("N")) {
											QueryUtil.executeMasterAction(
													getUserInfo(), ConstantsTx.DHBIRTHDTLUPDATE_TXCODE, QueryUtil.ACTION_MODIFY,
													new String[] {
														memBBPatNo,
														getBP_DOBDT().getText(),
														getOrder().getText(),
														null,
														null,
														null,
														getMHKID().getText().trim().length()>0?getMHKID().getText().trim():getMPNo().getText().trim(),
														getMPType().getText(),
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
														"N"
													},
													new MessageQueueCallBack() {
												@Override
												public void onPostSuccess(
														MessageQueue mQueue) {
													if (mQueue.success()) {
														setAllRightFieldsEnabled(false);
														showInfo(memBBPatNo);
														Factory.getInstance().addInformationMessage("Save success...");
													} else {
														Factory.getInstance().addErrorMessage("Fail to save DHBIRTHDTL.");
													}
												}
											});
										}
									}
								} else {
									Factory.getInstance().addErrorMessage("Fail to get data from DHBIRTHDTL.");
								}
							}
						});
				} else {
					Factory.getInstance().addErrorMessage("Fail to save EBIRTHEDIT.");
				}
			}
		});
	}

	private void DHRecord() {
		final String DHPatno  = getBP_BBPatNo().getText().trim();

		setParameter("FROMEBIRTH", "True");
		setParameter("PATNO", DHPatno);
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] {"dhbirthdtl", "COUNT(1)", "bbpatno='" + DHPatno + "'"},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					if (Integer.parseInt(mQueue.getContentField()[0]) == 0 && !DHPatno.isEmpty()) {
						MessageBoxBase.confirm(MSG_PBA_SYSTEM, "Create record for Health Department?",
								new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									QueryUtil.executeMasterAction(
											getUserInfo(), ConstantsTx.DHBIRTHDTLUPDATE_TXCODE, QueryUtil.ACTION_APPEND,
											new String[] {
												DHPatno, EMPTY_VALUE, EMPTY_VALUE, EMPTY_VALUE, EMPTY_VALUE,
												EMPTY_VALUE, EMPTY_VALUE, EMPTY_VALUE, EMPTY_VALUE, EMPTY_VALUE,
												EMPTY_VALUE, EMPTY_VALUE, EMPTY_VALUE, EMPTY_VALUE, EMPTY_VALUE,
												EMPTY_VALUE, EMPTY_VALUE, EMPTY_VALUE, EMPTY_VALUE, EMPTY_VALUE},
											new MessageQueueCallBack() {
										@Override
										public void onPostSuccess(MessageQueue mQueue) {
											if (mQueue.success()) {
												showPanel(new DHBirthEntry());
											}
										}
									});
								}
							}
						});
					} else {
						setParameter("FROMEBIRTH", "True");
						setParameter("BB_PATNO", DHPatno);
						showPanel(new DHBirthEntry());
					}
				}
			}
		});
		//showPanel(DHBirthEntry.class);
	}

	private void showInfo(String BBPatNo) {
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.EBIRTHDTLUPDATE_TXCODE, new String[] {BBPatNo},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.getContentNum() > 0) {
					String[] outParam =  mQueue.getContentField();
					getLeftJText_MotherPatNo().setText(outParam[17]);
					getLeftJText_MotherName().setText(outParam[22] + " " + outParam[21]);
					getLeftJText_MotherDOB().setText(outParam[66]);
					getLeftJText_BBPatNo().setText(outParam[0]);
					getLeftJText_BBName().setText(outParam[2] + " " + outParam[1]);
					getLeftJText_BBDOB().setText(outParam[6]);

					// Baby
					getBP_BBPatNo().setText(outParam[0]);
					getBP_GName().setText(outParam[1]);
					getBP_FName().setText(outParam[2]);
					getBP_CFName().setText(outParam[3]);
//					getBP_CGName().setText(outParam[4]);
					getBP_DOBDT().setText(outParam[64]);
					if ("M".equals(outParam[5]) || "F".equals(outParam[5]) || "U".equals(outParam[5])) {
						getBP_Sex().setText(outParam[5]);
					} else {
						getBP_Sex().setSelectedIndex(-1);
					}
					getBP_SlipNo().setText(outParam[8]);
					getBP_BirthType().setText(outParam[9]);
					getOrder().setText(outParam[10]);
					getBP_Arrival().setText(outParam[11].length() == 0 ? "N" : outParam[11]);
					getBP_OnArrival().setText(outParam[12].length() == 0 ? "N" : outParam[12]);
					getBP_Place().setText(outParam[13].length() == 0 ? "H" : outParam[13]);
					getBP_PlaceDesc().setText(outParam[14]);
					getBP_BirthStatus().setText(outParam[15].length() == 0 ? "1" : outParam[15]);
					getRemark().setText(outParam[16]);
					getBP_RefNo().setText(outParam[60]);
					getBP_ReturnNo().setText(outParam[61]);

					// Mother
					getMoPatNo().setText(outParam[17]);
					getMHKID().setText(outParam[18]);
					getMPNo().setText(outParam[19]);
					getMPType().setText(outParam[20]);
					getMGName().setText(outParam[21]);
					getMFName().setText(outParam[22]);
					getMFCName().setText(outParam[23]);
//					getMGCName().setText(outParam[24]);
					getMSlipNo().setText(outParam[25]);
					getMDOB().setText(outParam[26]);
					getMContactNO().setText(outParam[27]);
					getMHolder().setText(outParam[28]);
					getMExact().setText(outParam[29].length() == 0 ? "Y" : outParam[29]);
					getMResidence().setText(outParam[30]);
					getMEmail().setText(outParam[31]);
					getMCase().setText(outParam[43]);

					// Father
					getFInfoSource().setText(outParam[33]);
					getFPatNo().setText(outParam[34]);
					getFHKID().setText(outParam[35]);
					getFPNo().setText(outParam[36]);
					getFPType().setText(outParam[37]);

					if (outParam[37] != null && outParam[37].length() > 0) {
						int fTravelDocType = outParam[37].toCharArray()[0];
						if (outParam[37] != null && outParam[37].length() > 0) {
							if (fTravelDocType >= 1 && fTravelDocType <= 9) {
								getFPType().setSelectedIndex(fTravelDocType - (int)'1'+1);
							} else if (fTravelDocType >= (int)'A' && fTravelDocType <= (int)'E') {
								getFPType().setSelectedIndex(fTravelDocType - (int)'A'+10);
							} else if (fTravelDocType >= (int)'G' && fTravelDocType <= (int)'N') {
								// there is no F
								getFPType().setSelectedIndex(fTravelDocType-(int)'A'+9);
							} else {
								getFPType().setSelectedIndex(-1);
							}
						} else {
							getFPType().setSelectedIndex(-1);
						}
					}
					getFGName().setText(outParam[38]);
					getFFName().setText(outParam[39]);
					getFFCName().setText(outParam[40]);
//					getFGCName(.setText(outParam[41]);
					getFDOB().setText(outParam[42]);
					getFHolder().setText(outParam[45]);
					getFExact().setText(outParam[46]);
					getFContactNo().setText(outParam[44]);
					getFResidence().setText(outParam[47]);

					// Address
					getFlat().setText(outParam[49]);
					getFloor().setText(outParam[50]);
//					getBlock().setText(outParam[51]);
					getHouse().setText(outParam[52]);
					getLot().setText(outParam[53]);
					getLotNo().setText(outParam[54]);
					getBldg().setText(outParam[55]);
					getEstate().setText(outParam[56]);
					getStreet().setText(outParam[57]);
					getDistrict().setText(outParam[58]);
					getArea().setText(outParam[59]);
					getHospital().setText(outParam[32]);

					getLeftJText_ConfirmedBy().setText(outParam[62]);
					getLeftJText_ConfirmedOn().setText(outParam[63]);

//					bCanEdit = NOT_CONFIRMED.equals(outParam[65]) || MANUAL.equals(outParam[66]);
					bCanConfirm = NOT_CONFIRMED.equals(outParam[65]);

					setRecordFound(true);
				} else {
					setRecordFound(false);
				}
			}
		});
	}

	private String getAddType() {
		String getAddType = "E_SAD";
		if (TextUtil.isChinese(getFlat().getText()) ||
				TextUtil.isChinese(getFloor().getText()) ||
				TextUtil.isChinese(getHouse().getText()) ||
				TextUtil.isChinese(getBldg().getText()) ||
				TextUtil.isChinese(getEstate().getText()) ||
				TextUtil.isChinese(getStreet().getText()) ||
				TextUtil.isChinese(getLot().getText()) ||
				TextUtil.isChinese(getLotNo().getText()) ||
				TextUtil.isChinese(getDistrict().getText())
				) {
			getAddType = "C_SAD";
		}
		return getAddType;
	}

	private Boolean check_hkid(String HKID) {
		boolean check_hkid = false;
		if (HKID.trim().length() == 10 || HKID.trim().length() == 11) {
			if (")".equals(HKID.trim().substring(HKID.length()-1, HKID.length())) &&
					"(".equals(HKID.trim().substring(HKID.length() - 3, HKID.length()).substring(0, 1))) {
				if ((int)HKID.charAt(0) >= (int)'A' &&
						(int)HKID.charAt(0) <= (int)'Z' &&
						(HKID.length() == 11 &&
							(int)HKID.substring(1, 2).charAt(0) >= (int)'A' &&
							(int)HKID.substring(1, 2).charAt(0) <= (int)'Z')
						|| HKID.length() == 10) {
					check_hkid = true;
				}
			}
		}
		return check_hkid;
	}
/*
	' return true if hkid in valid format
	check_hkid = False
	If Len(ID) = 10 Or Len(ID) = 11 Then
		If Right(ID, 1) = ")" And Left(Right(ID, 3), 1) = "(" Then  ' having a pair of ()
			If Left(ID, 1) >= "A" And Left(ID, 1) <= "Z" And _
			   ((Len(ID) = 11 And (Mid(ID, 2, 1) >= "A" And Mid(ID, 2, 1) <= "Z")) Or Len(ID) = 10) Then

				check_hkid = True
			End If
		End If
	End If
End Function
 */

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/* >>> getter methods for init the Component start from here================================== <<< */
	@Override
	protected BasePanel getActionPanel() {
		if (actionPanel == null) {
			actionPanel = new BasePanel();
			actionPanel.setSize(945, 548);
			actionPanel.add(getParaPanel(), null);
			actionPanel.add(getJTabbedPane(), null);
			actionPanel.add(getLeftJLabel_ConfirmedByDesc(), null);
			actionPanel.add(getLeftJText_ConfirmedBy(), null);
			actionPanel.add(getLeftJLabel_ConfirmedOnDesc(), null);
			actionPanel.add(getLeftJText_ConfirmedOn(), null);
			actionPanel.add(getLeftJButton_Confirm(), null);
			actionPanel.add(getLeftJButton_DHRecord(), null);
		}
		return actionPanel;
	}

	public BasePanel getParaPanel() {
		if (ParaPanel == null) {
			ParaPanel = new BasePanel();
			ParaPanel.setEtchedBorder();
			ParaPanel.setBounds(5, 5, 778, 60);
			ParaPanel.add(getLeftJLabel_MotherPatNoDesc(), null);
			ParaPanel.add(getLeftJText_MotherPatNo(), null);
			ParaPanel.add(getLeftJLabel_MotherNameDesc(), null);
			ParaPanel.add(getLeftJText_MotherName(), null);
			ParaPanel.add(getLeftJLabel_MotherDOBDesc(), null);
			ParaPanel.add(getLeftJText_MotherDOB(), null);
			ParaPanel.add(getLeftJLabel_BBPatNoDesc(), null);
			ParaPanel.add(getLeftJText_BBPatNo(), null);
			ParaPanel.add(getLeftJLabel_BBNameDesc(), null);
			ParaPanel.add(getLeftJText_BBName(), null);
			ParaPanel.add(getLeftJLabel_BBDOBDesc(), null);
			ParaPanel.add(getLeftJText_BBDOB(), null);
		}
		return ParaPanel;
	}

	/***************************************************************************
	 * Mother/Baby Information Panel
	 **************************************************************************/

	public LabelBase getLeftJLabel_MotherPatNoDesc() {
		if (LeftJLabel_MotherPatNoDesc == null) {
			LeftJLabel_MotherPatNoDesc = new LabelBase();
			LeftJLabel_MotherPatNoDesc.setText("Mother Patient No:");
			LeftJLabel_MotherPatNoDesc.setBounds(10, 5, 110, 20);
		}
		return LeftJLabel_MotherPatNoDesc;
	}

	public LabelBase getLeftJText_MotherPatNo() {
		if (LeftJText_MotherPatNo == null) {
			LeftJText_MotherPatNo = new LabelBase();
			LeftJText_MotherPatNo.setStyleAttribute("color", "red");
			LeftJText_MotherPatNo.setStyleAttribute("fontWeight", "bold");
			LeftJText_MotherPatNo.setBounds(120, 5, 100, 20);
		}
		return LeftJText_MotherPatNo;
	}

	public LabelBase getLeftJLabel_MotherNameDesc() {
		if (LeftJLabel_MotherNameDesc == null) {
			LeftJLabel_MotherNameDesc = new LabelBase();
			LeftJLabel_MotherNameDesc.setBounds(240, 5, 51, 20);
			LeftJLabel_MotherNameDesc.setText("Name:");
		}
		return LeftJLabel_MotherNameDesc;
	}

	public LabelBase getLeftJText_MotherName() {
		if (LeftJText_MotherName == null) {
			LeftJText_MotherName = new LabelBase();
			LeftJText_MotherName.setStyleAttribute("color", "red");
			LeftJText_MotherName.setStyleAttribute("fontWeight", "bold");
			LeftJText_MotherName.setBounds(295, 5, 140, 20);
		}
		return LeftJText_MotherName;
	}

	public LabelBase getLeftJLabel_MotherDOBDesc() {
		if (LeftJLabel_MotherDOBDesc == null) {
			LeftJLabel_MotherDOBDesc = new LabelBase();
			LeftJLabel_MotherDOBDesc.setText("Date of Birth:");
			LeftJLabel_MotherDOBDesc.setBounds(495, 5, 110, 20);
		}
		return LeftJLabel_MotherDOBDesc;
	}

	public LabelBase getLeftJText_MotherDOB() {
		if (LeftJText_MotherDOB == null) {
			LeftJText_MotherDOB = new LabelBase();
			LeftJText_MotherDOB.setStyleAttribute("color", "red");
			LeftJText_MotherDOB.setStyleAttribute("fontWeight", "bold");
			LeftJText_MotherDOB.setBounds(590, 5, 150, 20);
		}
		return LeftJText_MotherDOB;
	}

	public LabelBase getLeftJLabel_BBPatNoDesc() {
		if (LeftJLabel_BBPatNoDesc == null) {
			LeftJLabel_BBPatNoDesc = new LabelBase();
			LeftJLabel_BBPatNoDesc.setText("Baby Patient No:");
			LeftJLabel_BBPatNoDesc.setBounds(10, 30, 110, 20);
		}
		return LeftJLabel_BBPatNoDesc;
	}

	public LabelBase getLeftJText_BBPatNo() {
		if (LeftJText_BBPatNo == null) {
			LeftJText_BBPatNo = new LabelBase();
			LeftJText_BBPatNo.setStyleAttribute("color", "red");
			LeftJText_BBPatNo.setStyleAttribute("fontWeight", "bold");
			LeftJText_BBPatNo.setBounds(120, 30, 100, 20);
		}
		return LeftJText_BBPatNo;
	}

	public LabelBase getLeftJLabel_BBNameDesc() {
		if (LeftJLabel_BBNameDesc == null) {
			LeftJLabel_BBNameDesc = new LabelBase();
			LeftJLabel_BBNameDesc.setText("Name:");
			LeftJLabel_BBNameDesc.setBounds(240, 30, 51, 20);
		}
		return LeftJLabel_BBNameDesc;
	}

	public LabelBase getLeftJText_BBName() {
		if (LeftJText_BBName == null) {
			LeftJText_BBName = new LabelBase();
			LeftJText_BBName.setStyleAttribute("color", "red");
			LeftJText_BBName.setStyleAttribute("fontWeight", "bold");
			LeftJText_BBName.setBounds(295, 30, 140, 20);
		}
		return LeftJText_BBName;
	}

	public LabelBase getLeftJLabel_BBDOBDesc() {
		if (LeftJLabel_BBDOBDesc == null) {
			LeftJLabel_BBDOBDesc = new LabelBase();
			LeftJLabel_BBDOBDesc.setText("Date of Birth:");
			LeftJLabel_BBDOBDesc.setBounds(495, 30, 110, 20);
		}
		return LeftJLabel_BBDOBDesc;
	}

	public LabelBase getLeftJText_BBDOB() {
		if (LeftJText_BBDOB == null) {
			LeftJText_BBDOB = new LabelBase();
			LeftJText_BBDOB.setStyleAttribute("color", "red");
			LeftJText_BBDOB.setStyleAttribute("fontWeight", "bold");
			LeftJText_BBDOB.setBounds(590, 30, 150, 20);
		}
		return LeftJText_BBDOB;
	}

	public LabelBase getHistoryDesc() {
		if (HistoryDesc == null) {
			HistoryDesc = new LabelBase();
			HistoryDesc.setText("File Reference No:");
			HistoryDesc.setBounds(12, 360, 120, 20);
		}
		return HistoryDesc;
	}

	/***************************************************************************
	 * Mother/Baby Information Panel
	 **************************************************************************/

	/**
	 * This method initializes jTabbedPane
	 *
	 * @return javax.swing.JTabbedPane
	 */
	private TabbedPaneBase getJTabbedPane() {
		if (jTabbedPane == null) {
			jTabbedPane = new TabbedPaneBase() {
				public void onStateChange() {
					int selectedIndex = jTabbedPane.getSelectedIndex();
					if ("E".equals(sClickStatus)) {
						if (selectedIndex == 0) {
							getBP_FName().focus();
						} else if (selectedIndex == 1) {
							getMFName().focus();
						} else if (selectedIndex == 2) {
							getFPatNo().focus();
						} else if (selectedIndex == 3) {
							getFlat().focus();
						}
					}
				}
			};
			jTabbedPane.setBounds(5, 70, 778, 420);
			jTabbedPane.addTab("Baby", getBabyPanel());
			jTabbedPane.addTab("Mother", getMotherPanel());
			jTabbedPane.addTab("Father", getFatherPanel());
			jTabbedPane.addTab("Address", getAddressPanel());
		}
		return jTabbedPane;
	}

	/***************************************************************************
	 * Baby Panel
	 **************************************************************************/

	/**
	 * This method initializes babyPanel
	 *
	 * @return javax.swing.JPanel
	 */
	private BasePanel getBabyPanel() {
		if (babyPanel == null) {
			redDot1 = new LabelBase();
			redDot1.setBounds(250, 159, 10, 14);
			redDot1.setText("*");
			redDot1.setStyleAttribute("color", "red");
			redDot142 = new LabelBase();
			redDot142.setBounds(580, 156, 10, 14);
			redDot142.setText("*");
			redDot142.setStyleAttribute("color", "red");
			redDot11 = new LabelBase();
			redDot11.setBounds(250, 193, 10, 14);
			redDot11.setText("*");
			redDot11.setStyleAttribute("color", "red");
			redDot141 = new LabelBase();
			redDot141.setBounds(580, 194, 10, 14);
			redDot141.setText("*");
			redDot141.setStyleAttribute("color", "red");
			redDot12 = new LabelBase();
			redDot12.setBounds(250, 232, 10, 14);
			redDot12.setText("*");
			redDot12.setStyleAttribute("color", "red");
			redDot15 = new LabelBase();
			redDot15.setBounds(750, 231, 10, 14);
			redDot15.setText("*");
			redDot15.setStyleAttribute("color", "red");
			redDot14 = new LabelBase();
			redDot14.setBounds(580, 268, 10, 14);
			redDot14.setText("*");
			redDot14.setStyleAttribute("color", "red");
			redDot13 = new LabelBase();
			redDot13.setBounds(250, 267, 10, 14);
			redDot13.setText("*");
			redDot13.setStyleAttribute("color", "red");
			BBDesc211 = new LabelBase();
			BBDesc211.setBounds(307, 84, 95, 20);
			BBDesc211.setText("Chi. Given Name:");
			BBDesc21 = new LabelBase();
			BBDesc21.setBounds(307, 48, 100, 20);
			BBDesc21.setText("Given Name:");
			BP_BBPatNoDesc0 = new LabelBase();
			BP_BBPatNoDesc0.setBounds(12, 302,102, 20);
			BP_BBPatNoDesc0.setText("Remarks :");
			BBDesc9 = new LabelBase();
			BBDesc9.setBounds(12, 266, 102, 20);
			BBDesc9.setText("Birth Status:");
			BBDesc8 = new LabelBase();
			BBDesc8.setBounds(12, 230, 102, 20);
			BBDesc8.setText("Place of Cord Cut:");
			BBDesc7 = new LabelBase();
			BBDesc7.setBounds(12, 207, 102, 15);
			BBDesc7.setText("(at the hospital)");
			BBDesc6 = new LabelBase();
			BBDesc6.setBounds(12, 192, 150, 15);
			BBDesc6.setText("Born Before Arrival:");
			BBDesc5 = new LabelBase();
			BBDesc5.setBounds(12, 156, 120, 20);
			BBDesc5.setText("Exact No. of Foetus:");
			BBDesc3 = new LabelBase();
			BBDesc3.setBounds(12, 84, 102, 20);
			BBDesc3.setText("Chi. Name:");
			BBDesc2 = new LabelBase();
			BBDesc2.setBounds(12, 48, 102, 20);
			BBDesc2.setText("Family Name:");
			LeftJLabel_MotherPatNoDesc1 = new LabelBase();
			LeftJLabel_MotherPatNoDesc1.setBounds(307, 266, 80, 18);
			LeftJLabel_MotherPatNoDesc1.setText("Birth Order:");
			babyPanel = new BasePanel();
			babyPanel.setLayout(null);
			babyPanel.add(getSendDateFromDesc(), null);
			babyPanel.add(getBP_DOBDT(), null);
			babyPanel.add(getSlipDesc(), null);
			babyPanel.add(getBP_Sex(), null);
			babyPanel.add(getBP_BBPatNo(), null);
			babyPanel.add(getBP_FName(), null);
			babyPanel.add(getBirthReturnNoDesc(), null);
			babyPanel.add(getOrder(), null);
			babyPanel.add(getBatchNoDesc(), null);
			babyPanel.add(getRedDot(), null);
			babyPanel.add(getBP_SexDesc(), null);
			babyPanel.add(getHistoryDesc(), null);
			babyPanel.add(LeftJLabel_MotherPatNoDesc1, null);
			babyPanel.add(getBP_BBPatNoDesc(), null);
			babyPanel.add(BBDesc2, null);
			babyPanel.add(BBDesc3, null);
			babyPanel.add(getBP_BirthDateTimeDesc(), null);
			babyPanel.add(BBDesc5, null);
			babyPanel.add(BBDesc6, null);
			babyPanel.add(BBDesc7, null);
			babyPanel.add(BBDesc8, null);
			babyPanel.add(BBDesc9, null);
			babyPanel.add(BP_BBPatNoDesc0, null);
			babyPanel.add(getBP_CFName(), null);
//			babyPanel.add(getBP_CGName(), null);
			babyPanel.add(getBP_BirthType(), null);
			babyPanel.add(getBP_Arrival(), null);
			babyPanel.add(getRemark(), null);
			babyPanel.add(getBP_RefNo(), null);
			babyPanel.add(getBP_ReturnNo(), null);
			babyPanel.add(getBP_Place(), null);
			babyPanel.add(getBP_BirthStatus(), null);
			babyPanel.add(BBDesc21, null);
//			babyPanel.add(BBDesc211, null);
			babyPanel.add(getBP_SlipNo(), null);
			babyPanel.add(getBP_PlaceDesc(), null);
			babyPanel.add(getBP_GName(), null);
			babyPanel.add(getBP_OnArrival(), null);
			babyPanel.add(redDot1, null);
			babyPanel.add(redDot11, null);
			babyPanel.add(redDot12, null);
			babyPanel.add(redDot13, null);
			babyPanel.add(redDot14, null);
			babyPanel.add(redDot15, null);
			babyPanel.add(redDot141, null);
			babyPanel.add(redDot142, null);
			babyPanel.add(getBP_BBDTFormat(), null);
			babyPanel.add(getBP_MandatoryForConfirmDesc(), null);
		}
		return babyPanel;
	}

	public LabelBase getBP_BBPatNoDesc() {
		if (BP_BBPatNoDesc == null) {
			BP_BBPatNoDesc = new LabelBase();
			BP_BBPatNoDesc.setBounds(12, 12, 102, 20);
			BP_BBPatNoDesc.setText("BB Pat. No:");
		}
		return BP_BBPatNoDesc;
	}

	public TextReadOnly getBP_BBPatNo() {
		if (BP_BBPatNo == null) {
			BP_BBPatNo = new TextReadOnly();
			BP_BBPatNo.setBounds(130, 12, 120, 20);
		 }
		return BP_BBPatNo;
	}

	public LabelBase getBP_SlipNo() {
		if (BP_SlipNo == null) {
			BP_SlipNo = new LabelBase();
			BP_SlipNo.setBounds(460, 12, 120, 20);
			BP_SlipNo.setStyleAttribute("fontWeight", "bold");
		}
		return BP_SlipNo;
	}

	public TextString getBP_FName() {
		if (BP_FName == null) {
			BP_FName = new TextString();
			BP_FName.setBounds(130, 50, 120, 20);
		 }
		return BP_FName;
	}

	/**
	 * This method initializes GName
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getBP_GName() {
		if (BP_GName == null) {
			BP_GName = new TextString();
			BP_GName.setBounds(460, 48, 120, 20);
		}
		return BP_GName;
	}

	/**
	 * This method initializes CName
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getBP_CFName() {
		if (BP_CFName == null) {
			BP_CFName = new TextString();
			BP_CFName.setBounds(130, 85, 120, 20);
		}
		return BP_CFName;
	}

	private TextString getBP_CGName() {
		if (BP_CGName == null) {
			BP_CGName = new TextString();
			BP_CGName.setBounds(460, 85, 120, 20);
		}
		return BP_CGName;
	}

	public LabelBase getBP_BirthDateTimeDesc() {
		if (BP_BirthDateTimeDesc == null) {
			BP_BirthDateTimeDesc = new LabelBase();
			BP_BirthDateTimeDesc.setBounds(11, 120, 102, 20);
			BP_BirthDateTimeDesc.setText("Birth Date/Time:");
		}
		return BP_BirthDateTimeDesc;
	}

	public TextDateTime getBP_DOBDT() {
		if (BP_DOBDT == null) {
			BP_DOBDT = new TextDateTime() {
				@Override
				protected String getDateTimePattern() {
					return "yyyy/MM/dd HH:mm:ss";
				}

				@Override
				public void onBlur() {
					if (!BP_DOBDT.isEmpty()) {
						if (!BP_DOBDT.isValid()) {
							getJTabbedPane().setSelectedIndexWithoutStateChange(0);
							Factory.getInstance().addErrorMessage("Baby's birth date is invalid.", BP_DOBDT);
							BP_DOBDT.resetText();
						} else {
							int dobYear = Integer.parseInt(BP_DOBDT.getText().substring(0, 4));
							if (dobYear < Integer.parseInt(DateTimeUtil.getCurrentYear()) - 1 ||
									dobYear > Integer.parseInt(DateTimeUtil.getCurrentYear())) {
								getJTabbedPane().setSelectedIndexWithoutStateChange(0);
								Factory.getInstance().addErrorMessage("Baby's birth date is invalid due to not current year.", BP_DOBDT);
								BP_DOBDT.resetText();
							}
						}
					}
				}
			};
			BP_DOBDT.setBounds(130, 121, 145, 20);
		 }
		return BP_DOBDT;
	}

	public LabelBase getRedDot() {
		if (redDot == null) {
			redDot = new LabelBase();
			redDot.setText("*");
			redDot.setStyleAttribute("color", "red");
			redDot.setBounds(275, 124, 10, 14);
		}
		return redDot;
	}

	private LabelBase getBP_BBDTFormat() {
		if (BP_BBDTFormat == null) {
			BP_BBDTFormat = new LabelBase();
			BP_BBDTFormat.setText("(YYYY/MM/DD HH:MM:SS)");
			BP_BBDTFormat.setBounds(300, 120, 200, 20);
		}
		return BP_BBDTFormat;
	}

	public LabelBase getSendDateFromDesc() {
		if (SendDateFromDesc == null) {
			SendDateFromDesc = new LabelBase();
			SendDateFromDesc.setText("Born on Arrival:");
			SendDateFromDesc.setBounds(307, 195, 93, 20);
		}
		return SendDateFromDesc;
	}

	public LabelBase getSlipDesc() {
		if (slipDesc == null) {
			slipDesc = new LabelBase();
			slipDesc.setText("Slip No :");
			slipDesc.setBounds(307, 12, 77, 20);
		}
		return slipDesc;
	}

	public LabelBase getBatchNoDesc() {
		if (BatchNoDesc == null) {
			BatchNoDesc = new LabelBase();
			BatchNoDesc.setText("Description-Place of Birth:");
			BatchNoDesc.setBounds(307, 230, 150, 20);
		}
		return BatchNoDesc;
	}

	public TextNum getOrder() {
		if (order == null) {
			order = new TextNum(1);
			order.setBounds(460, 266, 114, 20);
		 }
		return order;
	}

	public LabelBase getBirthReturnNoDesc() {
		if (BirthReturnNoDesc == null) {
			BirthReturnNoDesc = new LabelBase();
			BirthReturnNoDesc.setText("Birth Return No.:");
			BirthReturnNoDesc.setBounds(307, 360, 100, 20);
		}
		return BirthReturnNoDesc;
	}

	/**
	 * This method initializes birthType
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextNum getBP_BirthType() {
		if (BP_BirthType == null) {
			BP_BirthType = new TextNum(1);
			BP_BirthType.setBounds(130, 156, 120, 20);
		}
		return BP_BirthType;
	}

	public LabelBase getBP_SexDesc() {
		if (BP_SexDesc == null) {
			BP_SexDesc = new LabelBase();
			BP_SexDesc.setText("Sex:");
			BP_SexDesc.setBounds(307, 156, 75, 20);
		}
		return BP_SexDesc;
	}

	public ComboSex getBP_Sex() {
		if (BP_Sex == null) {
			BP_Sex = new ComboSex();
			BP_Sex.removeItemAt(0);
			BP_Sex.setBounds(460, 156, 120, 20);
		 }
		return BP_Sex;
	}

	/**
	 * This method initializes arrival
	 *
	 * @return com.hkah.client.layout.combobox.ComboYesNo
	 */
	private ComboYesNo getBP_Arrival() {
		if (BP_Arrival == null) {
			BP_Arrival = new ComboYesNo();
			BP_Arrival.setBounds(130, 192, 120, 20);
		}
		return BP_Arrival;
	}

	/**
	 * This method initializes remark
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextAreaBase getRemark() {
		if (remark == null) {
			remark = new TextAreaBase();
			remark.setBounds(130, 302, 605, 50);
		}
		return remark;
	}

	/**
	 * This method initializes palce
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private ComboCordCutPlace getBP_Place() {
		if (BP_Place == null) {
			BP_Place = new ComboCordCutPlace();
			BP_Place.setBounds(130, 231, 120, 20);
		}
		return BP_Place;
	}

	/**
	 * This method initializes birthStatus
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private ComboCordCutDesc getBP_BirthStatus() {
		if (BP_BirthStatus == null) {
			BP_BirthStatus = new ComboCordCutDesc();
			BP_BirthStatus.setBounds(130, 266, 120, 20);
		}
		return BP_BirthStatus;
	}

	/**
	 * This method initializes placeDesc
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getBP_PlaceDesc() {
		if (BP_PlaceDesc == null) {
			BP_PlaceDesc = new TextString(10);
			BP_PlaceDesc.setBounds(460, 230, 282, 20);
		}
		return BP_PlaceDesc;
	}

	/**
	 * This method initializes BP_OnArrival
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private ComboYesNo getBP_OnArrival() {
		if (BP_OnArrival == null) {
			BP_OnArrival = new ComboYesNo();
			BP_OnArrival.setBounds(460, 194, 120, 20);
		}
		return BP_OnArrival;
	}

	public LabelBase getBP_RefNo() {
		if (BP_RefNo == null) {
			BP_RefNo = new LabelBase();
			BP_RefNo.setBounds(130, 360, 120, 20);
			BP_RefNo.setStyleAttribute("fontWeight", "bold");
		}
		return BP_RefNo;
	}

	public LabelBase getBP_ReturnNo() {
		if (BP_ReturnNo == null) {
			BP_ReturnNo = new LabelBase();
			BP_ReturnNo.setBounds(460, 360, 120, 20);
			BP_ReturnNo.setStyleAttribute("fontWeight", "bold");
		}
		return BP_ReturnNo;
	}

	public LabelBase getBP_MandatoryForConfirmDesc() {
		if (BP_MandatoryForConfirmDesc == null) {
			BP_MandatoryForConfirmDesc = new LabelBase();
			BP_MandatoryForConfirmDesc.setBounds(598, 360, 200, 20);
			BP_MandatoryForConfirmDesc.setStyleAttribute("color", "red");
			BP_MandatoryForConfirmDesc.setText("*- mandatory for confirm");
		}
		return BP_MandatoryForConfirmDesc;
	}

	/***************************************************************************
	 * Mother Panel
	 **************************************************************************/

	/**
	 * This method initializes motherPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	private BasePanel getMotherPanel() {
		if (motherPanel == null) {
			redDot143 = new LabelBase();
			redDot143.setBounds(580, 126, 10, 14);
			redDot143.setStyleAttribute("color", "red");
			redDot143.setText("*");
			redDot16 = new LabelBase();
			redDot16.setBounds(252, 159, 80, 14);
			redDot16.setText("AB123456(7)");
			BBDesc212 = new LabelBase();
			BBDesc212.setBounds(350, 48, 80, 20);
			BBDesc212.setText("Given Name:");
			BP_BBPatNoDesc01 = new LabelBase();
			BP_BBPatNoDesc01.setBounds(12, 302, 102, 20);
			BP_BBPatNoDesc01.setText("Residence Desc :");
			BBDesc91 = new LabelBase();
			BBDesc91.setBounds(12, 266, 102, 20);
			BBDesc91.setText("Contact No:");
			BBDesc81 = new LabelBase();
			BBDesc81.setBounds(12, 230, 102, 20);
			BBDesc81.setText("Passport Type:");
			BBDesc71 = new LabelBase();
			BBDesc71.setBounds(350, 124, 83, 20);
			BBDesc71.setText("Exact DOB:");
			BBDesc61 = new LabelBase();
			BBDesc61.setBounds(12, 192, 102, 20);
			BBDesc61.setText("Passport No:");
			BBDesc51 = new LabelBase();
			BBDesc51.setBounds(12, 156, 102, 20);
			BBDesc51.setText("HKID:");
			BP_BirthDateTimeDesc1 = new LabelBase();
			BP_BirthDateTimeDesc1.setBounds(11, 120, 102, 20);
			BP_BirthDateTimeDesc1.setText("Date of Birth:");
			BBDesc31 = new LabelBase();
			BBDesc31.setBounds(12, 84, 102, 20);
			BBDesc31.setText("Chi. Name:");
			BBDesc32 = new LabelBase();
			BBDesc32.setBounds(350, 84, 102, 20);
			BBDesc32.setText("Chi. Given Name:");
			BBDesc22 = new LabelBase();
			BBDesc22.setBounds(12, 48, 102, 20);
			BBDesc22.setText("Family Name:");
			BP_BBPatNoDesc1 = new LabelBase();
			BP_BBPatNoDesc1.setBounds(12, 12, 102, 20);
//			BP_BBPatNoDesc1.setText("BB Pat. No:"); // Wrong label fixed by Arran
			BP_BBPatNoDesc1.setText("Patient No:");
			LeftJLabel_MotherPatNoDesc11 = new LabelBase();
			LeftJLabel_MotherPatNoDesc11.setBounds(350, 266, 93, 18);
			LeftJLabel_MotherPatNoDesc11.setText("E-Mail Address:");
			HistoryDesc1 = new LabelBase();
			HistoryDesc1.setBounds(12, 338, 120, 20);
			HistoryDesc1.setText("Police/ImmD case:");
			BP_SexDesc1 = new LabelBase();
			BP_SexDesc1.setBounds(350, 156, 120, 20);
			BP_SexDesc1.setText("HKID Card Holder:");
			redDot2 = new LabelBase();
			redDot2.setBounds(250, 121, 15, 20);
			redDot2.setStyleAttribute("color", "red");
			redDot2.setText("*");
			slipDesc1 = new LabelBase();
			slipDesc1.setBounds(350, 12, 77, 20);
			slipDesc1.setText("Slip No :");
			MDTFormat = new LabelBase();
			MDTFormat.setBounds(260, 120, 200, 20);
			MDTFormat.setText("(YYYY/MM/DD)");
			motherPanel = new BasePanel();
			motherPanel.setLayout(null);
			motherPanel.add(getMDOB(), null);
			motherPanel.add(slipDesc1, null);
			motherPanel.add(getMHolder(), null);
			motherPanel.add(getMoPatNo(), null);
			motherPanel.add(getMFName(), null);
			motherPanel.add(getMEmail(), null);
			motherPanel.add(redDot2, null);
			motherPanel.add(BP_SexDesc1, null);
			motherPanel.add(HistoryDesc1, null);
			motherPanel.add(LeftJLabel_MotherPatNoDesc11, null);
			motherPanel.add(BP_BBPatNoDesc1, null);
			motherPanel.add(BBDesc22, null);
			motherPanel.add(BBDesc31, null);
//			motherPanel.add(BBDesc32, null);
			motherPanel.add(BP_BirthDateTimeDesc1, null);
			motherPanel.add(BBDesc51, null);
			motherPanel.add(BBDesc61, null);
			motherPanel.add(BBDesc71, null);
			motherPanel.add(BBDesc81, null);
			motherPanel.add(BBDesc91, null);
			motherPanel.add(BP_BBPatNoDesc01, null);
			motherPanel.add(getMFCName(), null);
//			motherPanel.add(getMGCName(), null);
			motherPanel.add(getMHKID(), null);
			motherPanel.add(getMPNo(), null);
			motherPanel.add(getMResidence(), null);
			motherPanel.add(getMPType(), null);
			motherPanel.add(getMContactNO(), null);
			motherPanel.add(BBDesc212, null);
			motherPanel.add(getMSlipNo(), null);
			motherPanel.add(getMGName(), null);
			motherPanel.add(getMExact(), null);
			motherPanel.add(redDot16, null);
			motherPanel.add(redDot143, null);
			motherPanel.add(getBP_MandatoryForConfirmDesc1(), null);
			motherPanel.add(getMCase(), null);
			motherPanel.add(MDTFormat, null);
		}
		return motherPanel;
	}

	/**
	 * This method initializes MDOB
	 *
	 * @return com.hkah.client.layout.textfield.TextDateTime
	 */
	private TextDate getMDOB() {
		if (MDOB == null) {
			MDOB = new TextDate() {
				@Override
				protected String getDateTimePattern() {
					return "yyyy/MM/dd";
				}

				public void onBlur() {
					if (!MDOB.isEmpty()) {
						if (!MDOB.isValid()) {
							getJTabbedPane().setSelectedIndexWithoutStateChange(1);
							Factory.getInstance().addErrorMessage("Mother's birth date is invalid.", MDOB);
						} else {
							int dobYear = Integer.parseInt(MDOB.getText().substring(0, 4));
							if (dobYear < 1901) {
								getJTabbedPane().setSelectedIndexWithoutStateChange(1);
								Factory.getInstance().addErrorMessage("Mother's birth date is invalid.", MDOB);
							}
						}
					}
				}
			};
			MDOB.setBounds(130, 121, 120, 20);
		}
		return MDOB;
	}



	private LabelBase getMSlipNo() {
		if (MSlipNo == null) {
			MSlipNo = new LabelBase();
			MSlipNo.setBounds(460, 12, 120, 20);
			MSlipNo.setStyleAttribute("fontWeight", "bold");
		}
		return MSlipNo;
	}

	/**
	 * This method initializes MHolder
	 *
	 * @return com.hkah.client.layout.combobox.ComboSex
	 */
	private ComboYesNo getMHolder() {
		if (MHolder == null) {
			MHolder = new ComboYesNo();
			MHolder.setBounds(460, 156, 120, 20);
			MHolder.addItem(ConstantsVariable.EMPTY_VALUE, ConstantsVariable.EMPTY_VALUE);
		}
		return MHolder;
	}

	/**
	 * This method initializes moPatNo
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextReadOnly getMoPatNo() {
		if (moPatNo == null) {
			moPatNo = new TextReadOnly();
			moPatNo.setBounds(130, 12, 120, 20);
		}
		return moPatNo;
	}

	/**
	 * This method initializes MFName
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getMFName() {
		if (MFName == null) {
			MFName = new TextString();
			MFName.setBounds(130, 50, 120, 20);
		}
		return MFName;
	}

	/**
	 * This method initializes MEmail
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getMEmail() {
		if (MEmail == null) {
			MEmail = new TextString();
			MEmail.setBounds(460, 266, 276, 20);
		}
		return MEmail;
	}

	/**
	 * This method initializes MFCName
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getMFCName() {
		if (MFCName == null) {
			MFCName = new TextString();
			MFCName.setBounds(130, 85, 120, 20);
		}
		return MFCName;
	}

	private TextString getMGCName() {
		if (MGCName == null) {
			MGCName = new TextString();
			MGCName.setBounds(460, 85, 120, 20);
		}
		return MGCName;
	}

	/**
	 * This method initializes MHKID
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getMHKID() {
		if (MHKID == null) {
			MHKID = new TextString(11, true);
			MHKID.addKeyListener(new KeyListener() {
				@Override
				public void componentKeyDown(ComponentEvent event) {
					MHKID.setOriginalValue(MHKID.getText().trim());
				}

				@Override
				public void componentKeyPress(ComponentEvent event) {
					MHKID.setId(String.valueOf((char)event.getKeyCode()));
					int keyAscii = event.getKeyCode();
					if (keyAscii >= (int)'!' && keyAscii <= (int)'z') {
						// convert to upper case
						keyAscii = (int)Character.toUpperCase((char)keyAscii);
						if (!((keyAscii >= (int)'A' && keyAscii <= (int)'z') ||
								(keyAscii >= (int)'0' && keyAscii <= (int)'9') ||
								keyAscii == (int)'(' ||
								keyAscii == (int)')')) {
							mHKIDValie = false;
						}
					}
				}

				@Override
				public void componentKeyUp(ComponentEvent event) {
					if (!mHKIDValie) {
						MHKID.setText(MHKID.getOriginalValue());
					}
					mHKIDValie = true;
					MHKID.setOriginalValue(null);

					if (!MHKID.isEmpty()) {
						getMHolder().setSelectedIndex(0);
						getMPNo().setText(EMPTY_VALUE);
						getMPNo().setEditable(false);
						getMPType().setSelectedIndex(9);
						getMPType().setReadOnly(true);
					} else {
						getMPNo().setEditable(true);
						getMPType().setSelectedIndex(0);
						getMHolder().setSelectedIndex(1);
					}
				}
			});

/*
			MHKID = new TextString(11, true) {
				public void onBlur() {
					CommonUtil.checkHKID(MHKID.getText().trim());
				}
			};

			MHKID.addListener(Events.SpecialKey, new Listener<FieldEvent>() {
				@Override
				public void handleEvent(FieldEvent be) {
					if (be.getKeyCode() == KeyCodes.KEY_TAB) {
						CommonUtil.checkHKID(MHKID.getText().trim());
					}
				}
			});
*/
			MHKID.setBounds(130, 156, 120, 20);
		}
		return MHKID;
	}

	/**
	 * This method initializes MPNo
	 *
	 * @return com.hkah.client.layout.combobox.ComboYesNo
	 */
	private TextString getMPNo() {
		if (MPNo == null) {
			MPNo = new TextString();
			MPNo.setBounds(130, 192, 317, 20);
		}
		return MPNo;
	}

	/**
	 * This method initializes MResidence
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getMResidence() {
		if (MResidence == null) {
			MResidence = new TextString();
			MResidence.setBounds(130, 302, 600, 20);
		}
		return MResidence;
	}

	/**
	 * This method initializes MPType
	 *
	 * @return com.hkah.client.layout.combobox.ComboCordCutPlace
	 */
	private ComboMTravelDocType getMPType() {
		if (MPType == null) {
			MPType = new ComboMTravelDocType();
			MPType.setBounds(130, 231, 600, 20);
		}
		return MPType;
	}

	/**
	 * This method initializes MContactNO
	 *
	 * @return com.hkah.client.layout.combobox.ComboCordCutDesc
	 */
	private TextString getMContactNO() {
		if (MContactNO == null) {
			MContactNO = new TextString();
			MContactNO.setBounds(130, 266, 120, 20);
		}
		return MContactNO;
	}

	/**
	 * This method initializes MGName
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getMGName() {
		if (MGName == null) {
			MGName = new TextString();
			MGName.setBounds(460, 48, 120, 20);
		}
		return MGName;
	}

	/**
	 * This method initializes MExact
	 *
	 * @return com.hkah.client.layout.combobox.ComboYesNo
	 */
	private ComboYesNo getMExact() {
		if (MExact == null) {
			MExact = new ComboYesNo();
			MExact.setBounds(460, 125, 120, 20);
		}
		return MExact;
	}

	/**
	 * This method initializes MCase
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getMCase() {
		if (MCase == null) {
			MCase = new TextString();
			MCase.setBounds(130, 338, 317, 20);
		}
		return MCase;
	}

	public LabelBase getBP_MandatoryForConfirmDesc1() {
		if (BP_MandatoryForConfirmDesc1 == null) {
			BP_MandatoryForConfirmDesc1 = new LabelBase();
			BP_MandatoryForConfirmDesc1.setBounds(592, 360, 200, 20);
			BP_MandatoryForConfirmDesc1.setText("*- mandatory for confirm");
			BP_MandatoryForConfirmDesc1.setStyleAttribute("color", "red");
		}
		return BP_MandatoryForConfirmDesc1;
	}

	/***************************************************************************
	 * Father Panel
	 **************************************************************************/

	/**
	 * This method initializes fatherPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	private BasePanel getFatherPanel() {
		if (fatherPanel == null) {
			redDot14311 = new LabelBase();
			redDot14311.setBounds(450, 339, 10, 14);
			redDot14311.setStyleAttribute("color", "red");
			redDot14311.setText("*");
			BP_MandatoryForConfirmDesc11 = new LabelBase();
			BP_MandatoryForConfirmDesc11.setBounds(592, 360, 200, 20);
			BP_MandatoryForConfirmDesc11.setText("*- mandatory for confirm");
			BP_MandatoryForConfirmDesc11.setStyleAttribute("color", "red");
			redDot1431 = new LabelBase();
			redDot1431.setBounds(580, 126, 10, 14);
			redDot1431.setStyleAttribute("color", "red");
			redDot1431.setText("*");
			redDot161 = new LabelBase();
			redDot161.setBounds(250, 159, 80, 14);
			redDot161.setText("AB123456(7)");
			//FSlipNo = new TextReadOnly();
			//FSlipNo.setBounds(460, 12, 120, 20);
			//FSlipNo.setStyleAttribute("fontWeight", "bold");
			BBDesc2121 = new LabelBase();
			BBDesc2121.setBounds(350, 48, 80, 20);
			BBDesc2121.setText("Given Name:");
			BP_BBPatNoDesc011 = new LabelBase();
			BP_BBPatNoDesc011.setBounds(12, 302, 102, 20);
			BP_BBPatNoDesc011.setText("Residence Desc :");
			BBDesc911 = new LabelBase();
			BBDesc911.setBounds(12, 266, 102, 20);
			BBDesc911.setText("Contact No:");
			BBDesc811 = new LabelBase();
			BBDesc811.setBounds(12, 230, 102, 20);
			BBDesc811.setText("Passport Type:");
			BBDesc711 = new LabelBase();
			BBDesc711.setBounds(350, 124, 83, 20);
			BBDesc711.setText("Exact DOB:");
			BBDesc611 = new LabelBase();
			BBDesc611.setBounds(12, 192, 102, 20);
			BBDesc611.setText("Passport No:");
			BBDesc511 = new LabelBase();
			BBDesc511.setBounds(12, 156, 102, 20);
			BBDesc511.setText("HKID:");
			BP_BirthDateTimeDesc11 = new LabelBase();
			BP_BirthDateTimeDesc11.setBounds(11, 120, 102, 20);
			BP_BirthDateTimeDesc11.setText("Date of Birth:");
			BBDesc311 = new LabelBase();
			BBDesc311.setBounds(12, 84, 102, 20);
			BBDesc311.setText("Chi. Name:");
			BBDesc313 = new LabelBase();
			BBDesc313.setBounds(350, 84, 102, 20);
			BBDesc313.setText("Chi. Given Name:");
			BBDesc221 = new LabelBase();
			BBDesc221.setBounds(12, 48, 102, 20);
			BBDesc221.setText("Family Name:");
			BP_BBPatNoDesc11 = new LabelBase();
			BP_BBPatNoDesc11.setBounds(12, 12, 102, 20);
//			BP_BBPatNoDesc11.setText("BB Pat. No:"); // Wrong label fixed by Arran
			BP_BBPatNoDesc11.setText("Patient No:");
			BP_SexDesc11 = new LabelBase();
			BP_SexDesc11.setBounds(350, 156, 120, 20);
			BP_SexDesc11.setText("HKID Card Holder:");
			redDot21 = new LabelBase();
			redDot21.setBounds(250, 121, 15, 20);
			redDot21.setStyleAttribute("color", "red");
			redDot21.setText("*");
			//slipDesc11 = new LabelBase();
			//slipDesc11.setBounds(350, 12, 77, 20);
			//slipDesc11.setText("Slip No :");
			FDTFormat = new LabelBase();
			FDTFormat.setBounds(260, 120, 200, 20);
			FDTFormat.setText("(YYYY/MM/DD)");
			fatherPanel = new BasePanel();
			fatherPanel.setLayout(null);
			fatherPanel.add(getFDOB(), null);
			//fatherPanel.add(slipDesc11, null);
			fatherPanel.add(getFHolder(), null);
			fatherPanel.add(getFPatNo(), null);
			fatherPanel.add(getFFName(), null);
			//fatherPanel.add(getFEmail(), null);
			fatherPanel.add(redDot21, null);
			fatherPanel.add(BP_SexDesc11, null);
			fatherPanel.add(getFInfoSourceDesc(), null);
			fatherPanel.add(BP_BBPatNoDesc11, null);
			fatherPanel.add(BBDesc221, null);
			fatherPanel.add(BBDesc311, null);
//			fatherPanel.add(BBDesc313, null);
			fatherPanel.add(BP_BirthDateTimeDesc11, null);
			fatherPanel.add(BBDesc511, null);
			fatherPanel.add(BBDesc611, null);
			fatherPanel.add(BBDesc711, null);
			fatherPanel.add(BBDesc811, null);
			fatherPanel.add(BBDesc911, null);
			fatherPanel.add(BP_BBPatNoDesc011, null);
			fatherPanel.add(getFFCName(), null);
//			fatherPanel.add(getFGCName(), null);
			fatherPanel.add(getFHKID(), null);
			fatherPanel.add(getFPNo(), null);
			fatherPanel.add(getFResidence(), null);
			fatherPanel.add(getFPType(), null);
			fatherPanel.add(getFContactNo(), null);
			fatherPanel.add(BBDesc2121, null);
			//fatherPanel.add(FSlipNo, null);
			fatherPanel.add(getFGName(), null);
			fatherPanel.add(getFExact(), null);
			fatherPanel.add(redDot161, null);
			fatherPanel.add(redDot1431, null);
			fatherPanel.add(BP_MandatoryForConfirmDesc11, null);
			fatherPanel.add(getFInfoSource(), null);
			fatherPanel.add(redDot14311, null);
			fatherPanel.add(FDTFormat, null);
		}
		return fatherPanel;
	}

	/**
	 * This method initializes FDOB
	 *
	 * @return com.hkah.client.layout.textfield.TextDate
	 */
	private TextDate getFDOB() {
		if (FDOB == null) {
			FDOB = new TextDate() {
				@Override
				protected String getDateTimePattern() {
					return "yyyy/MM/dd";
				}

				public void onBlur() {
					if (!FDOB.isEmpty()) {
						if (!FDOB.isValid()) {
							getJTabbedPane().setSelectedIndexWithoutStateChange(2);
							Factory.getInstance().addErrorMessage("Father's birth date is invalid.", FDOB);
						} else {
							int dobYear = Integer.parseInt(FDOB.getText().substring(0, 4));
							if (dobYear < 1901) {
								getJTabbedPane().setSelectedIndexWithoutStateChange(2);
								Factory.getInstance().addErrorMessage("Father's birth date is invalid.", FDOB);
							}
						}
					}
				}
			};
			FDOB.setBounds(130, 121, 120, 20);
		}
		return FDOB;
	}

	/**
	 * This method initializes FHolder
	 *
	 * @return com.hkah.client.layout.combobox.ComboYesNo
	 */
	private ComboYesNo getFHolder() {
		if (FHolder == null) {
			FHolder = new ComboYesNo();
			FHolder.setBounds(460, 156, 120, 20);
			FHolder.addItem(ConstantsVariable.EMPTY_VALUE, ConstantsVariable.EMPTY_VALUE);
		}
		return FHolder;
	}

	/**
	 * This method initializes FPatNo
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextPatientNoSearch getFPatNo() {
		if (FPatNo == null) {
			FPatNo = new TextPatientNoSearch();
			FPatNo.setBounds(130, 12, 120, 20);
		}
		return FPatNo;
	}

	/**
	 * This method initializes FFName
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getFFName() {
		if (FFName == null) {
			FFName = new TextString();
			FFName.setBounds(130, 50, 120, 20);
		}
		return FFName;
	}

	/**
	 * This method initializes FEmail
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getFEmail() {
		if (FEmail == null) {
			FEmail = new TextString();
			FEmail.setBounds(460, 266, 276, 20);
		}
		return FEmail;
	}

	/**
	 * This method initializes FCName
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getFFCName() {
		if (FFCName == null) {
			FFCName = new TextString();
			FFCName.setBounds(130, 85, 120, 20);
		}
		return FFCName;
	}

	private TextString getFGCName() {
		if (FGCName == null) {
			FGCName = new TextString();
			FGCName.setBounds(460, 85, 120, 20);
		}
		return FGCName;
	}

	/**
	 * This method initializes FHKID
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getFHKID() {
		if (FHKID == null) {
			FHKID = new TextString(11,true);
			FHKID.addKeyListener(new KeyListener() {
				@Override
				public void componentKeyDown(ComponentEvent event) {
					FHKID.setOriginalValue(FHKID.getText().trim());
				}

				@Override
				public void componentKeyPress(ComponentEvent event) {
					FHKID.setId(String.valueOf((char)event.getKeyCode()));
					int keyAscii = event.getKeyCode();
					if (keyAscii >= (int)'!' && keyAscii <= (int)'z') {
						// convert to upper case
						keyAscii = (int)Character.toUpperCase((char)keyAscii);
						if (!((keyAscii >= (int)'A' && keyAscii <= (int)'z') ||
								(keyAscii >= (int)'0' && keyAscii <= (int)'9') ||
								keyAscii == (int)'(' ||
								keyAscii == (int)')')) {
							fHKIDValie = false;
						}
					}
				}

				@Override
				public void componentKeyUp(ComponentEvent event) {
					if (!fHKIDValie) {
						FHKID.setText(FHKID.getOriginalValue());
					}
					fHKIDValie = true;
					FHKID.setOriginalValue(null);

					if (!FHKID.isEmpty()) {
						getFHolder().setSelectedIndex(0);
						getFPNo().setText(EMPTY_VALUE);
						getFPNo().setEditable(false);
						getFPType().setSelectedIndex(9);
						getFPType().setReadOnly(true);
					} else {
						getFPNo().setEditable(true);
						getFPType().setSelectedIndex(0);
						getFHolder().setSelectedIndex(1);
					}
				}
			});

			FHKID.setBounds(130, 156, 120, 20);
		}
		return FHKID;
	}

	/**
	 * This method initializes FPNo
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getFPNo() {
		if (FPNo == null) {
			FPNo = new TextString();
			FPNo.setBounds(130, 192, 317, 20);
		}
		return FPNo;
	}

	/**
	 * This method initializes FResidence
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getFResidence() {
		if (FResidence == null) {
			FResidence = new TextString();
			FResidence.setBounds(130, 302, 600, 20);
		}
		return FResidence;
	}

	/**
	 * This method initializes FPType
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private ComboMTravelDocType getFPType() {
		if (FPType == null) {
			FPType = new ComboMTravelDocType();
			FPType.setBounds(130, 231, 600, 20);
		}
		return FPType;
	}

	/**
	 * This method initializes FContactNo
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getFContactNo() {
		if (FContactNo == null) {
			FContactNo = new TextString();
			FContactNo.setBounds(130, 266, 120, 20);
		}
		return FContactNo;
	}

	/**
	 * This method initializes FGName
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getFGName() {
		if (FGName == null) {
			FGName = new TextString();
			FGName.setBounds(460, 48, 120, 20);
		}
		return FGName;
	}

	/**
	 * This method initializes FExact
	 *
	 * @return com.hkah.client.layout.combobox.ComboYesNo
	 */
	private ComboYesNo getFExact() {
		if (FExact == null) {
			FExact = new ComboYesNo();
			FExact.setBounds(460, 125, 120, 20);
			FExact.addItem(ConstantsVariable.EMPTY_VALUE, ConstantsVariable.EMPTY_VALUE);
		}
		return FExact;
	}

	private LabelBase getFInfoSourceDesc() {
		if (FInfoSourceDesc == null) {
			FInfoSourceDesc = new LabelBase();
			FInfoSourceDesc.setBounds(12, 338, 110, 20);
			FInfoSourceDesc.setText("Father Info. Source:");
		}
		return FInfoSourceDesc;
	}

	/**
	 * This method initializes FInfoSource
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private ComboFaInfoSource getFInfoSource() {
		if (FInfoSource == null) {
			FInfoSource = new ComboFaInfoSource();
			FInfoSource.setBounds(130, 338, 317, 20);
		}
		return FInfoSource;
	}

	/***************************************************************************
	 * Address Panel
	 **************************************************************************/

	/**
	 * This method initializes addressPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	private BasePanel getAddressPanel() {
		if (addressPanel == null) {
			redDot14321 = new LabelBase();
			redDot14321.setBounds(590, 310, 10, 14);
			redDot14321.setStyleAttribute("color", "red");
			redDot14321.setText("*");
			redDot1432 = new LabelBase();
			redDot1432.setBounds(590, 232, 10, 14);
			redDot1432.setStyleAttribute("color", "red");
			redDot1432.setText("*");
			redDot162 = new LabelBase();
			BBDesc2122 = new LabelBase();
			BBDesc2122.setBounds(253, 48, 55, 20);
			BBDesc2122.setText("Floor:");
			BBDesc912 = new LabelBase();
			BBDesc912.setBounds(66, 266, 50, 20);
			BBDesc912.setText("Area:");
			BBDesc812 = new LabelBase();
			BBDesc812.setBounds(66, 230, 50, 20);
			BBDesc812.setText("District:");
			BBDesc712 = new LabelBase();
			BBDesc712.setBounds(430, 84, 50, 20);
			BBDesc712.setText("Lot No:");
			BBDesc612 = new LabelBase();
			BBDesc612.setBounds(66, 192, 50, 20);
			BBDesc612.setText("Street:");
			BBDesc512 = new LabelBase();
			BBDesc512.setBounds(66, 156, 50, 20);
			BBDesc512.setText("Estate:");
			BBDesc412 = new LabelBase();
			BBDesc412.setBounds(430, 48, 50, 20);
			BBDesc412.setText("Block:");
			BP_BirthDateTimeDesc12 = new LabelBase();
			BP_BirthDateTimeDesc12.setBounds(66, 120, 50, 20);
			BP_BirthDateTimeDesc12.setText("Bldg:");
			BBDesc312 = new LabelBase();
			BBDesc312.setBounds(66, 84, 50, 20);
			BBDesc312.setText("House:");
			BBDesc222 = new LabelBase();
			BBDesc222.setBounds(66, 48, 50, 20);
			BBDesc222.setText("Flat:");
			BP_BBPatNoDesc12 = new LabelBase();
			BP_BBPatNoDesc12.setBounds(12, 12, 102, 20);
			BP_BBPatNoDesc12.setText("Address:");
			HistoryDesc12 = new LabelBase();
			redDot22 = new LabelBase();
			redDot22.setBounds(310, 266, 15, 20);
			redDot22.setStyleAttribute("color", "red");
			redDot22.setText("*");
			slipDesc12 = new LabelBase();
			slipDesc12.setBounds(253, 84, 70, 20);
			slipDesc12.setText("Lot Prefix:");
			addressPanel = new BasePanel();
			addressPanel.setLayout(null);
			addressPanel.add(getBldg(), null);
			addressPanel.add(slipDesc12, null);
			addressPanel.add(getLot(), null);
			addressPanel.add(getFlat(), null);
			addressPanel.add(getArea(), null);
			addressPanel.add(redDot22, null);
			addressPanel.add(HistoryDesc12, null);
			addressPanel.add(BP_BBPatNoDesc12, null);
			addressPanel.add(BBDesc222, null);
			addressPanel.add(BBDesc312, null);
			addressPanel.add(BP_BirthDateTimeDesc12, null);
//			addressPanel.add(BBDesc412, null);
			addressPanel.add(BBDesc512, null);
			addressPanel.add(BBDesc612, null);
			addressPanel.add(BBDesc712, null);
			addressPanel.add(BBDesc812, null);
			addressPanel.add(BBDesc912, null);
			addressPanel.add(getAP_NameOfHospitalDesc(), null);
			addressPanel.add(getHouse(), null);
			addressPanel.add(getEstate(), null);
			addressPanel.add(getStreet(), null);
			addressPanel.add(getHospital(), null);
			addressPanel.add(getDistrict(), null);
			addressPanel.add(getLotNo(), null);
			addressPanel.add(BBDesc2122, null);
			addressPanel.add(getFloor(), null);
//			addressPanel.add(getBlock(), null);
			addressPanel.add(redDot162, null);
			addressPanel.add(redDot1432, null);
			addressPanel.add(getBP_MandatoryForConfirmDesc12(), null);
			addressPanel.add(redDot14321, null);
		}
		return addressPanel;
	}

	/**
	 * This method initializes bldg
	 *
	 * @return com.hkah.client.layout.textfield.TextDate
	 */
	private TextString getBldg() {
		if (bldg == null) {
			bldg = new TextString();
			bldg.setBounds(130, 121, 460, 20);
		}
		return bldg;
	}

	/**
	 * This method initializes lot
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getLot() {
		if (lot == null) {
			lot = new TextString();
			lot.setBounds(308, 84, 100, 20);
		}
		return lot;
	}

	/**
	 * This method initializes flat
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getFlat() {
		if (flat == null) {
			flat = new TextString();
			flat.setBounds(130, 48, 100, 20);
		}
		return flat;
	}

	/**
	 * This method initializes area
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private ComboArea getArea() {
		if (area == null) {
			area = new ComboArea();
			area.setBounds(130, 266, 174, 20);
		}
		return area;
	}

	/**
	 * This method initializes house
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getHouse() {
		if (house == null) {
			house = new TextString();
			house.setBounds(130, 85, 100, 20);
		}
		return house;
	}

	/**
	 * This method initializes estate
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getEstate() {
		if (estate == null) {
			estate = new TextString();
			estate.setBounds(130, 156, 460, 20);
		}
		return estate;
	}

	/**
	 * This method initializes street
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getStreet() {
		if (street == null) {
			street = new TextString();
			street.setBounds(130, 192, 460, 20);
		}
		return street;
	}

	/**
	 * This method initializes hospital
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getHospital() {
		if (hospital == null) {
			hospital = new TextString();
			hospital.setBounds(130, 308, 460, 20);
		}
		return hospital;
	}

	/**
	 * This method initializes district
	 *
	 * @return com.hkah.client.layout.combobox.ComboMTravelDocType
	 */
	private TextString getDistrict() {
		if (district == null) {
			district = new TextString();
			district.setBounds(130, 231, 460, 20);
		}
		return district;
	}

	/**
	 * This method initializes lotNo
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getLotNo() {
		if (lotNo == null) {
			lotNo = new TextString();
			lotNo.setBounds(479, 84, 100, 20);
		}
		return lotNo;
	}

	/**
	 * This method initializes floor
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getFloor() {
		if (floor == null) {
			floor = new TextString();
			floor.setBounds(308, 48, 100, 20);
		}
		return floor;
	}

	private TextString getBlock() {
		if (block == null) {
			block = new TextString();
			block.setBounds(479, 48, 100, 20);
		}
		return block;
	}

	private LabelBase getAP_NameOfHospitalDesc() {
		if (AP_NameOfHospitalDesc == null) {
			AP_NameOfHospitalDesc = new LabelBase();
			AP_NameOfHospitalDesc.setBounds(18, 300, 150, 80);
			AP_NameOfHospitalDesc.setText("Name of Hospital<br/> Superintendent /<br/> Registered Midwife:");
		}
		return AP_NameOfHospitalDesc;
	}

	private LabelBase getBP_MandatoryForConfirmDesc12() {
		if (BP_MandatoryForConfirmDesc12 == null) {
			BP_MandatoryForConfirmDesc12 = new LabelBase();
			BP_MandatoryForConfirmDesc12.setBounds(592, 360, 200, 20);
			BP_MandatoryForConfirmDesc12.setText("*- mandatory for confirm");
			BP_MandatoryForConfirmDesc12.setStyleAttribute("color", "red");
		}
		return BP_MandatoryForConfirmDesc12;
	}

	/***************************************************************************
	 * Bottom Panel
	 **************************************************************************/

	public ButtonBase getLeftJButton_Confirm() {
		if (LeftJButton_Confirm == null) {
			LeftJButton_Confirm = new ButtonBase() {
				@Override
				public void onClick() {
					confirm();
				}
			};
			LeftJButton_Confirm.setText("Confirm");
			LeftJButton_Confirm.setBounds(12, 500, 82, 25);
		}
		return LeftJButton_Confirm;
	}

	public LabelBase getLeftJLabel_ConfirmedByDesc() {
		if (LeftJLabel_ConfirmedByDesc == null) {
			LeftJLabel_ConfirmedByDesc = new LabelBase();
			LeftJLabel_ConfirmedByDesc.setText("Confirmed By:");
			LeftJLabel_ConfirmedByDesc.setBounds(114, 500, 100, 20);
		}
		return LeftJLabel_ConfirmedByDesc;
	}

	public LabelBase getLeftJText_ConfirmedBy() {
		if (LeftJText_ConfirmedBy == null) {
			LeftJText_ConfirmedBy = new LabelBase();
			LeftJText_ConfirmedBy.setBounds(194, 500, 100, 20);
		}
		return LeftJText_ConfirmedBy;
	}

	public LabelBase getLeftJLabel_ConfirmedOnDesc() {
		if (LeftJLabel_ConfirmedOnDesc == null) {
			LeftJLabel_ConfirmedOnDesc = new LabelBase();
			LeftJLabel_ConfirmedOnDesc.setText("Confirmed On:");
			LeftJLabel_ConfirmedOnDesc.setBounds(350, 500, 89, 20);
		}
		return LeftJLabel_ConfirmedOnDesc;
	}

	public LabelBase getLeftJText_ConfirmedOn() {
		if (LeftJText_ConfirmedOn == null) {
			LeftJText_ConfirmedOn = new LabelBase();
			LeftJText_ConfirmedOn.setBounds(439, 500, 150, 20);
		}
		return LeftJText_ConfirmedOn;
	}

	public ButtonBase getLeftJButton_DHRecord() {
		if (LeftJButton_DHRecord == null) {
			LeftJButton_DHRecord = new ButtonBase() {
				@Override
				public void onClick() {
					DHRecord();
				}
			};
			LeftJButton_DHRecord.setText("DH Record");
			LeftJButton_DHRecord.setBounds(685, 500, 94, 25);
		}
		return LeftJButton_DHRecord;
	}
}