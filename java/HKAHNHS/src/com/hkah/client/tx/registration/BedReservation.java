package com.hkah.client.tx.registration;

import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.combobox.ComboACMCode;
import com.hkah.client.layout.combobox.ComboRomSex;
import com.hkah.client.layout.combobox.ComboWard;
import com.hkah.client.layout.combobox.ComboYesNo;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextRoomSearch;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.util.PanelUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class BedReservation extends MasterPanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.BEDRESERVATION_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.BEDRESERVATION_TITLE;

	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
			"Bed Code",
			"Acm Type",
			"Status",
			"Clean",
			"PatNo",
			"PatName",
			"Sex",
			"Remark",
			"Date",
			"DocCode",
			""
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				90,
				80,
				50,
				50,
				80,
				150,
				60,
				200,
				100,
				80,
				0
		};
	}

	private BasePanel leftPanel = null;
	private BasePanel rightPanel = null;

	private FieldSetBase ParaPanel = null;

	private LabelBase BedCodeDesc = null;
	private TextString BedCode = null;
	private LabelBase RoomCodeDesc = null;
	private TextRoomSearch RoomCode = null;
	private LabelBase WardCodeDesc = null;
	private ComboWard WardCode = null;
	private LabelBase SexDesc = null;
	private ComboRomSex Sex = null;
	private LabelBase CleanDesc = null;
	private ComboYesNo Clean = null;
	private LabelBase AcmCodeDesc = null;
	private ComboACMCode AcmCode = null;
	private LabelBase VacantDesc = null;
	private ComboYesNo Vacant = null;
	private LabelBase OfficialDesc = null;
	private ComboYesNo Official = null;
	private LabelBase DateFromDesc = null;
	private TextDate DateFrom = null;
	private LabelBase DateToDesc = null;
	private TextDate DateTo = null;

	private FieldSetBase ListPanel = null;

	private FieldSetBase StatisticsPanel = null;
	private LabelBase BedAvailDesc = null;
	private TextReadOnly BedAvail = null;
	private LabelBase CountDesc = null;
	private TextReadOnly Count = null;

	private FieldSetBase BedReservation = null;
	private LabelBase RemarksDesc = null;
	private TextBase Remarks = null;
	private LabelBase DateDesc = null;
	private TextDate Date = null;

	/**
	 * This method initializes
	 *
	 */
	public BedReservation() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		setLeftAlignPanel();
		getJScrollPane().setBounds(15, 0, 650, 170);
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		clearPostAction();
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return getBedCode();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {
		PanelUtil.setAllFieldsEditable(getParaPanel(), true);
		searchAction(true);
	}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
		getRemarks().requestFocus();
	}

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
				getBedCode().getText().trim(),
				getRoomCode().getText().trim(),
				getWardCode().getText().trim(),
				getSex().getText().trim(),
				getAcmCode().getText().trim(),
				getVacant().getText().trim(),
				getClean().getText().trim(),
				getOfficial().getText().trim(),
				getDateFrom().getText().trim(),
				getDateTo().getText().trim()
		};
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
		getRemarks().setText(outParam[7]);
		getDate().setText(outParam[8]);

		getModifyButton().setEnabled(getListTable().getRowCount() > 0);
	}

	/* >>> ~15~ Set Fetch Output Results ============================== <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return new String[] {
				getListTable().getValueAt(getListTable().getSelectedRow(), 0).toString(), //BEDCODE
				getRemarks().getText(),
				getDate().getText()
		};
	}

	/* >>> ~16.1~ Set Action Output Parameters =========================== <<< */
	@Override
	protected void getNewOutputValue(String returnValue) {}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {
		if (!getDate().isEmpty() && !getDate().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid date", getDate());
			actionValidationReady(actionType, false);
		} else {
			actionValidationReady(actionType, true);
		}
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected void enableButton(String mode) {
		super.enableButton(mode);

		boolean isAction = getActionType() != null && (isAppend() || isModify() || isDelete());
		int rowCnt = getListTable().getRowCount();

		getSearchButton().setEnabled(!isAction);
		getAppendButton().setEnabled(false);
		getModifyButton().setEnabled(rowCnt > 0 && !isAction);
		getDeleteButton().setEnabled(false);
		getAcceptButton().setEnabled(false);
		getRefreshButton().setEnabled(!isAction);
	}

	@Override
	protected void performListPost() {
		// for child class call
		int rowCnt = getListTable().getRowCount();
		int bedAvailCnt = 0;

		getModifyButton().setEnabled(rowCnt > 0);
		getCount().setText(String.valueOf(rowCnt));
		for (int i = 0; i < rowCnt; i++) {
			if ("F".equals(getListTable().getValueAt(i, 2).toString().trim())) {
				bedAvailCnt++;
			}
		}
		getBedAvail().setText(String.valueOf(bedAvailCnt));
	}

	public void clearAction() {
		boolean isAction = getActionType() != null && (isAppend() || isModify() || isDelete());
		if (isAction) {
			PanelUtil.resetAllFields(getBedReservation());
		} else {
			super.clearAction();
		}
	}

	@Override
	protected void clearPostAction() {
		getVacant().setText(YES_VALUE);
		getClean().resetText();
		getOfficial().resetText();
	}

	@Override
	protected void setAllLeftFieldsEnabled(boolean enable) {
		// reset field status
		PanelUtil.resetAllFieldsStatus(getParaPanel());
		PanelUtil.resetAllFieldsStatus(getStatisticsPanel());
		// disable field
		PanelUtil.setAllFieldsEditable(getParaPanel(), enable);
		PanelUtil.setAllFieldsEditable(getStatisticsPanel(), enable);
	}

	@Override
	protected void setAllRightFieldsEnabled(boolean enable) {
		// reset field status
		PanelUtil.resetAllFieldsStatus(getBedReservation());
		// disable field
		PanelUtil.setAllFieldsEditable(getBedReservation(), enable);
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/* >>> getter methods for init the Component start from here================================== <<< */
	@Override
	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.setSize(699, 514);
			leftPanel.add(getParaPanel(),null);
			leftPanel.add(getListPanel(), null);
			leftPanel.add(getStatisticsPanel(), null);
			leftPanel.add(getBedReservation(), null);
		}
		return leftPanel;
	}

	protected BasePanel getRightPanel() {
		if (rightPanel == null) {
			rightPanel = new BasePanel();
		}
		return rightPanel;
	}

	public FieldSetBase getParaPanel() {
		if (ParaPanel == null) {
			ParaPanel = new FieldSetBase();
			ParaPanel.setBounds(15, 5, 682, 140);
			ParaPanel.setHeading("Bed Information");
			ParaPanel.add(getBedCodeDesc(), null);
			ParaPanel.add(getBedCode(), null);
			ParaPanel.add(getRoomCodeDesc(), null);
			ParaPanel.add(getRoomCode(), null);
			ParaPanel.add(getWardCodeDesc(), null);
			ParaPanel.add(getWardCode(), null);
			ParaPanel.add(getSexDesc(), null);
			ParaPanel.add(getSex(), null);
			ParaPanel.add(getCleanDesc(), null);
			ParaPanel.add(getClean(), null);
			ParaPanel.add(getAcmCodeDesc(), null);
			ParaPanel.add(getAcmCode(), null);
			ParaPanel.add(getVacantDesc(), null);
			ParaPanel.add(getVacant(), null);
			ParaPanel.add(getOfficialDesc(), null);
			ParaPanel.add(getOfficial(), null);
			ParaPanel.add(getDateFromDesc(), null);
			ParaPanel.add(getDateFrom(), null);
			ParaPanel.add(getDateToDesc(), null);
			ParaPanel.add(getDateTo(), null);
		}
		return ParaPanel;
	}

	public LabelBase getBedCodeDesc() {
		if (BedCodeDesc == null) {
			BedCodeDesc = new LabelBase();
			BedCodeDesc.setText("Bed Code");
			BedCodeDesc.setBounds(44, 0, 80, 20);
		}
		return BedCodeDesc;
	}

	public TextString getBedCode() {
		if (BedCode == null) {
			BedCode = new TextString();
			BedCode.setBounds(133, 0, 175, 20);
		}
		return BedCode;
	}

	public LabelBase getRoomCodeDesc() {
		if (RoomCodeDesc == null) {
			RoomCodeDesc = new LabelBase();
			RoomCodeDesc.setText("Room Code");
			RoomCodeDesc.setBounds(369, 0, 80, 20);
		}
		return RoomCodeDesc;
	}

	public TextRoomSearch getRoomCode() {
		if (RoomCode == null) {
			RoomCode = new TextRoomSearch() {
				@Override
				public void checkTriggerBySearchKeyPost() {
					searchAction(true);
				}
				
				@Override
				protected void onBlur(ComponentEvent ce) {
					super.onBlur();
					if (!isEmpty()) {
						QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] { "ROOM", "ROMCODE", "ROMCODE = '" + getText() + "'"},
							new MessageQueueCallBack() {
								@Override
								public void onPostSuccess(
										MessageQueue mQueue) {
									// TODO Auto-generated method stub
									if (mQueue.success()) {
										if (mQueue.getContentLineCount() == 0) {
											getRoomCode().resetText();
											Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_ROOM_CODE, getRoomCode());
										}
									} else {
										getRoomCode().resetText();
										Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_ROOM_CODE, getRoomCode());
									}
								}
							});
						}
					}
				};
			RoomCode.setBounds(458, 0, 175, 20);
		}
		return RoomCode;
	}

	public LabelBase getWardCodeDesc() {
		if (WardCodeDesc == null) {
			WardCodeDesc = new LabelBase();
			WardCodeDesc.setText("Ward Code");
			WardCodeDesc.setBounds(44, 30, 80, 20);
		}
		return WardCodeDesc;
	}

	public ComboWard getWardCode() {
		if (WardCode == null) {
			WardCode = new ComboWard();
			WardCode.setBounds(133, 30, 175, 20);
		}
		return WardCode;
	}

	public LabelBase getSexDesc() {
		if (SexDesc == null) {
			SexDesc = new LabelBase();
			SexDesc.setText("Sex");
			SexDesc.setBounds(369, 30, 80, 20);
		}
		return SexDesc;
	}

	public ComboRomSex getSex() {
		if (Sex == null) {
			Sex = new ComboRomSex();
			Sex.setBounds(458, 30, 80, 20);
		}
		return Sex;
	}

	public LabelBase getCleanDesc() {
		if (CleanDesc == null) {
			CleanDesc = new LabelBase();
			CleanDesc.setText("Clean");
			CleanDesc.setBounds(545, 30, 80, 20);
		}
		return CleanDesc;
	}

	public ComboYesNo getClean() {
		if (Clean == null) {
			Clean = new ComboYesNo();
			Clean.setBounds(590, 30, 80, 20);
		}
		return Clean;
	}

	public LabelBase getAcmCodeDesc() {
		if (AcmCodeDesc == null) {
			AcmCodeDesc = new LabelBase();
			AcmCodeDesc.setText("Acm. Code");
			AcmCodeDesc.setBounds(44, 60, 80, 20);
		}
		return AcmCodeDesc;
	}

	public ComboACMCode getAcmCode() {
		if (AcmCode == null) {
			AcmCode = new ComboACMCode();
			AcmCode.setBounds(133, 60, 175, 20);
		}
		return AcmCode;
	}

	public LabelBase getVacantDesc() {
		if (VacantDesc == null) {
			VacantDesc = new LabelBase();
			VacantDesc.setText("Vacant");
			VacantDesc.setBounds(369, 60, 80, 20);
		}
		return VacantDesc;
	}

	public ComboYesNo getVacant() {
		if (Vacant == null) {
			Vacant = new ComboYesNo();
			Vacant.setBounds(458, 60, 80, 20);
		}
		return Vacant;
	}

	public LabelBase getOfficialDesc() {
		if (OfficialDesc == null) {
			OfficialDesc = new LabelBase();
			OfficialDesc.setText("Official");
			OfficialDesc.setBounds(545, 60, 80, 20);
		}
		return OfficialDesc;
	}

	public ComboYesNo getOfficial() {
		if (Official == null) {
			Official = new ComboYesNo();
			Official.setBounds(590, 60, 80, 20);
		}
		return Official;
	}

	public LabelBase getDateFromDesc() {
		if (DateFromDesc == null) {
			DateFromDesc = new LabelBase();
			DateFromDesc.setText("Date From");
			DateFromDesc.setBounds(44, 90, 80, 20);
		}
		return DateFromDesc;
	}

	public TextDate getDateFrom() {
		if (DateFrom == null) {
			DateFrom = new TextDate();
			DateFrom.setBounds(133, 90, 175, 20);
		}
		return DateFrom;
	}

	public LabelBase getDateToDesc() {
		if (DateToDesc == null) {
			DateToDesc = new LabelBase();
			DateToDesc.setText("Date To");
			DateToDesc.setBounds(369, 90, 80, 20);
		}
		return DateToDesc;
	}

	public TextDate getDateTo() {
		if (DateTo == null) {
			DateTo = new TextDate();
			DateTo.setBounds(458, 90, 175, 20);
		}
		return DateTo;
	}

	public FieldSetBase getListPanel() {
		if (ListPanel == null) {
			ListPanel = new FieldSetBase();
			ListPanel.setHeading("Bed Assignment Details");
			ListPanel.setBounds(15, 160, 682, 210);
			ListPanel.add(getJScrollPane());
		}
		return ListPanel;
	}

	public FieldSetBase getStatisticsPanel() {
		if (StatisticsPanel == null) {
			StatisticsPanel = new FieldSetBase();
			StatisticsPanel.setHeading("Bed Statistics");
			StatisticsPanel.setBounds(15, 380, 682, 50);
			StatisticsPanel.add(getBedAvailDesc(), null);
			StatisticsPanel.add(getBedAvail(), null);
			StatisticsPanel.add(getCount(), null);
			StatisticsPanel.add(getCountDesc(), null);
			StatisticsPanel.add(getCount(), null);
		}
		return StatisticsPanel;
	}

	public LabelBase getBedAvailDesc() {
		if (BedAvailDesc == null) {
			BedAvailDesc = new LabelBase();
			BedAvailDesc.setText("Bed Available");
			BedAvailDesc.setBounds(44, 0, 95, 20);
		}
		return BedAvailDesc;
	}

	public TextReadOnly getBedAvail() {
		if (BedAvail == null) {
			BedAvail = new TextReadOnly();
			BedAvail.setBounds(139, 0, 172, 20);

		}
		return BedAvail;
	}

	public LabelBase getCountDesc() {
		if (CountDesc == null) {
			CountDesc = new LabelBase();
			CountDesc.setText("Count");
			CountDesc.setBounds(369, 0, 95, 20);

		}
		return CountDesc;
	}

	public TextReadOnly getCount() {
		if (Count == null) {
			Count = new TextReadOnly();
			Count.setBounds(464, 0, 172, 20);
		}
		return Count;
	}

	public FieldSetBase getBedReservation() {
		if (BedReservation == null) {
			BedReservation = new FieldSetBase();
			BedReservation.setHeading("Bed Reservation");
			BedReservation.setBounds(15, 440, 682, 50);
			BedReservation.add(getRemarksDesc(), null);
			BedReservation.add(getRemarks(), null);
			BedReservation.add(getDateDesc(), null);
			BedReservation.add(getDate(), null);
		}
		return BedReservation;
	}

	public LabelBase getRemarksDesc() {
		if (RemarksDesc == null) {
			RemarksDesc = new LabelBase();
			RemarksDesc.setText("Remarks");
			RemarksDesc.setBounds(44, 0, 95, 20);
		}
		return RemarksDesc;
	}

	public TextBase getRemarks() {
		if (Remarks == null) {
			Remarks = new TextBase(false);
			Remarks.setBounds(139, 0, 172, 20);
		}
		return Remarks;
	}

	public LabelBase getDateDesc() {
		if (DateDesc == null) {
			DateDesc = new LabelBase();
			DateDesc.setText("Date");
			DateDesc.setBounds(369, 0, 95, 20);
		}
		return DateDesc;
	}

	public TextDate getDate() {
		if (Date == null) {
			Date = new TextDate();
			Date.setBounds(464, 0, 172, 20);
		}
		return Date;
	}

	@Override
	protected boolean triggerSearchField() {
		// TODO Auto-generated method stub
		if (getRoomCode().isFocusOwner()) {
			getRoomCode().checkTriggerBySearchKey();
			return true;
		}
		
		return false;
	}
}