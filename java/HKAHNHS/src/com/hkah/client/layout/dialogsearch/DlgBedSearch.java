package com.hkah.client.layout.dialogsearch;

import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.combobox.ComboACMCode;
import com.hkah.client.layout.combobox.ComboRomSex;
import com.hkah.client.layout.combobox.ComboWard;
import com.hkah.client.layout.combobox.ComboYesNo;
import com.hkah.client.layout.dialog.DialogSearchBase;
import com.hkah.client.layout.label.LabelSmallBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.textfield.SearchTriggerField;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextRoomSearch;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgBedSearch extends DialogSearchBase {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.BEDRESERVATION_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return "Patient Business Administration System - [Bed Assignment]";

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

	private BasePanel searchPanel = null;

	private FieldSetBase ParaPanel = null;

	private LabelSmallBase CrJLabel_BedCodeDesc = null;
	private TextString CrJText_BedCode = null;
	private LabelSmallBase CrJLabel_RoomCodeDesc = null;
	private TextRoomSearch CrJText_RoomCode = null;
	private LabelSmallBase CrJLabel_WardCodeDesc = null;
	private ComboWard CrJCombo_WardCode = null;
	private LabelSmallBase CrJLabel_SexDesc = null;
	private ComboRomSex CrJCombo_Sex = null;
	private LabelSmallBase CrJLabel_CleanDesc = null;
	private ComboYesNo CrJCombo_Clean = null;
	private LabelSmallBase CrJLabel_AcmCodeDesc = null;
	private ComboACMCode CrJCombo_AcmCode = null;
	private LabelSmallBase CrJLabel_VacantDesc = null;
	private ComboYesNo CrJCombo_Vacant = null;
	private LabelSmallBase CrJLabel_OfficialDesc = null;
	private ComboYesNo CrJCombo_Official = null;
	private LabelSmallBase CrJLabel_DateFromDesc = null;
	private TextDate CrJText_DateFrom = null;
	private LabelSmallBase CrJLabel_DateToDesc = null;
	private TextDate CrJText_DateTo = null;

	private FieldSetBase ListPanel = null;

	private FieldSetBase StatisticsPanel = null;
	private LabelSmallBase BedAvailDesc = null;
	private TextReadOnly BedAvail = null;
	private LabelSmallBase CountDesc = null;
	private TextReadOnly Count = null;

	private FieldSetBase BedReservation = null;
	private LabelSmallBase RemarksDesc = null;
	private TextReadOnly Remarks = null;
	private LabelSmallBase DateDesc = null;
	private TextReadOnly Date = null;

	private JScrollPane bedScrollPane = null;

	/**
	 * This method initializes
	 *
	 */
	public DlgBedSearch(SearchTriggerField textfField) {
		super(textfField, 730, 580);
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		getJScrollPane().setBounds(15, 0, 650, 170);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return getCrJText_BedCode();
	}

	/* >>> ~14~ Set Browse Validation ===================================== <<< */
	@Override
	protected boolean browseValidation() {
		if (!getCrJText_DateFrom().isEmpty() && !getCrJText_DateFrom().isValid()) {
			getCrJText_DateFrom().resetText();
			Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_INVALID_DATE, getCrJText_DateFrom());
			return false;
		} else if (!getCrJText_DateTo().isEmpty() && !getCrJText_DateTo().isValid()) {
			getCrJText_DateTo().resetText();
			Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_INVALID_DATE, getCrJText_DateTo());
			return false;
		} else {
			return super.browseValidation();
		}
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
				getCrJText_BedCode().getText().trim(),
				getCrJText_RoomCode().getText().trim(),
				getCrJCombo_WardCode().getText().trim(),
				getCrJCombo_Sex().isValid() ? getCrJCombo_Sex().getText().trim() : getCrJCombo_Sex().getRawValue(),
				getCrJCombo_AcmCode().isValid() ? getCrJCombo_AcmCode().getText().trim() : getCrJCombo_AcmCode().getRawValue(),
				getCrJCombo_Vacant().isValid() ? getCrJCombo_Vacant().getText().trim() : getCrJCombo_Vacant().getRawValue(),
				getCrJCombo_Clean().isValid() ? getCrJCombo_Clean().getText().trim() : getCrJCombo_Clean().getRawValue(),
				getCrJCombo_Official().isValid() ? getCrJCombo_Official().getText().trim() : getCrJCombo_Official().getRawValue(),
				getCrJText_DateFrom().getText().trim(),
				getCrJText_DateTo().getText().trim()
		};
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {
		getRemarks().setText(outParam[7]);
		getDate().setText(outParam[8]);

		getSearchDialog().getButtonById(Dialog.NO).setEnabled(!"O".equals(outParam[2]));
	}


	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected boolean isSearchFieldsEmpty() {
		return getCrJText_BedCode().isEmpty()
			&& getCrJText_RoomCode().isEmpty()
			&& getCrJCombo_WardCode().isEmpty()
			&& getCrJCombo_Sex().isEmpty()
			&& getCrJCombo_AcmCode().isEmpty()
			&& getCrJText_DateFrom().isEmpty()
			&& getCrJText_DateTo().isEmpty();
	}

	@Override
	protected String getInputCriteriaMessage() {
		return ConstantsMessage.MSG_INPUT_CRITERIA;
	}

	@Override
	protected void performListPost() {
		// for child class call
		int rowCnt = getListTable().getRowCount();
		int bedAvailCnt = 0;

		getCount().setText(String.valueOf(rowCnt));
		for (int i = 0; i < rowCnt; i++) {
			if ("F".equals(getListTable().getValueAt(i, 2).toString().trim())) {
				bedAvailCnt++;
			}
		}
		getBedAvail().setText(String.valueOf(bedAvailCnt));
	}

	@Override
	protected boolean triggerSearchField() {
		if (getCrJText_RoomCode().isFocusOwner()) {
			getCrJText_RoomCode().checkTriggerBySearchKey();
			return true;
		} else {
			return false;
		}
	}
	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/* >>> getter methods for init the Component start from here================================== <<< */
	@Override
	protected BasePanel getSearchPanel() {
		if (searchPanel == null) {
			searchPanel = new BasePanel();
			searchPanel.setSize(800, 175);
			searchPanel.add(getParaPanel(),null);
			searchPanel.add(getListPanel(), null);
			searchPanel.add(getStatisticsPanel(), null);
			searchPanel.add(getBedReservation(), null);
		}
		return searchPanel;
	}

	public FieldSetBase getParaPanel() {
		if (ParaPanel == null) {
			ParaPanel = new FieldSetBase();
			ParaPanel.setBounds(15, 5, 682, 140);
			ParaPanel.setHeading("Bed Information");
			ParaPanel.add(getCrJLabel_BedCodeDesc(), null);
			ParaPanel.add(getCrJText_BedCode(), null);
			ParaPanel.add(getCrJLabel_RoomCodeDesc(), null);
			ParaPanel.add(getCrJText_RoomCode(), null);
			ParaPanel.add(getCrJLabel_WardCodeDesc(), null);
			ParaPanel.add(getCrJCombo_WardCode(), null);
			ParaPanel.add(getCrJLabel_SexDesc(), null);
			ParaPanel.add(getCrJCombo_Sex(), null);
			ParaPanel.add(getCrJLabel_CleanDesc(), null);
			ParaPanel.add(getCrJCombo_Clean(), null);
			ParaPanel.add(getCrJLabel_AcmCodeDesc(), null);
			ParaPanel.add(getCrJCombo_AcmCode(), null);
			ParaPanel.add(getCrJLabel_VacantDesc(), null);
			ParaPanel.add(getCrJCombo_Vacant(), null);
			ParaPanel.add(getCrJLabel_OfficialDesc(), null);
			ParaPanel.add(getCrJCombo_Official(), null);
			ParaPanel.add(getCrJLabel_DateFromDesc(), null);
			ParaPanel.add(getCrJText_DateFrom(), null);
			ParaPanel.add(getCrJLabel_DateToDesc(), null);
			ParaPanel.add(getCrJText_DateTo(), null);
		}
		return ParaPanel;
	}

	public LabelSmallBase getCrJLabel_BedCodeDesc() {
		if (CrJLabel_BedCodeDesc == null) {
			CrJLabel_BedCodeDesc = new LabelSmallBase();
			CrJLabel_BedCodeDesc.setText("Bed Code");
			CrJLabel_BedCodeDesc.setBounds(44, 0, 80, 20);
		}
		return CrJLabel_BedCodeDesc;
	}

	public TextString getCrJText_BedCode() {
		if (CrJText_BedCode == null) {
			CrJText_BedCode = new TextString();
			CrJText_BedCode.setBounds(133, 0, 175, 20);
		}
		return CrJText_BedCode;
	}

	public LabelSmallBase getCrJLabel_RoomCodeDesc() {
		if (CrJLabel_RoomCodeDesc == null) {
			CrJLabel_RoomCodeDesc = new LabelSmallBase();
			CrJLabel_RoomCodeDesc.setText("Room Code");
			CrJLabel_RoomCodeDesc.setBounds(369, 0, 80, 20);
		}
		return CrJLabel_RoomCodeDesc;
	}

	public TextRoomSearch getCrJText_RoomCode() {
		if (CrJText_RoomCode == null) {
			CrJText_RoomCode = new TextRoomSearch() {
				@Override
				protected void onBlur(ComponentEvent ce) {
					super.onBlur();
					if (!isEmpty()) {
						QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
								new String[] { "ROOM", "ROMCODE", "ROMCODE = '"+getText()+"'"},
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(
									MessageQueue mQueue) {
								// TODO Auto-generated method stub
								if (mQueue.success()) {
									if (mQueue.getContentLineCount() == 0) {
										getCrJText_RoomCode().resetText();
										Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_ROOM_CODE, getCrJText_RoomCode());
									}
								} else {
									getCrJText_RoomCode().resetText();
									Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_ROOM_CODE, getCrJText_RoomCode());
								}
							}
						});
					}
				}
			};
			CrJText_RoomCode.setBounds(458, 0, 175, 20);
		}
		return CrJText_RoomCode;
	}

	public LabelSmallBase getCrJLabel_WardCodeDesc() {
		if (CrJLabel_WardCodeDesc == null) {
			CrJLabel_WardCodeDesc = new LabelSmallBase();
			CrJLabel_WardCodeDesc.setText("Ward Code");
			CrJLabel_WardCodeDesc.setBounds(44, 30, 80, 20);
		}
		return CrJLabel_WardCodeDesc;
	}

	public ComboWard getCrJCombo_WardCode() {
		if (CrJCombo_WardCode == null) {
			CrJCombo_WardCode = new ComboWard();
			CrJCombo_WardCode.setBounds(133, 30, 175, 20);
		}
		return CrJCombo_WardCode;
	}

	public LabelSmallBase getCrJLabel_SexDesc() {
		if (CrJLabel_SexDesc == null) {
			CrJLabel_SexDesc = new LabelSmallBase();
			CrJLabel_SexDesc.setText("Sex");
			CrJLabel_SexDesc.setBounds(369, 30, 80, 20);
		}
		return CrJLabel_SexDesc;
	}

	public ComboRomSex getCrJCombo_Sex() {
		if (CrJCombo_Sex == null) {
			CrJCombo_Sex = new ComboRomSex();
			CrJCombo_Sex.setBounds(458, 30, 80, 20);
		}
		return CrJCombo_Sex;
	}

	public LabelSmallBase getCrJLabel_CleanDesc() {
		if (CrJLabel_CleanDesc == null) {
			CrJLabel_CleanDesc = new LabelSmallBase();
			CrJLabel_CleanDesc.setText("Clean");
			CrJLabel_CleanDesc.setBounds(545, 30, 80, 20);
		}
		return CrJLabel_CleanDesc;
	}

	public ComboYesNo getCrJCombo_Clean() {
		if (CrJCombo_Clean == null) {
			CrJCombo_Clean = new ComboYesNo();
			CrJCombo_Clean.setBounds(590, 30, 80, 20);
		}
		return CrJCombo_Clean;
	}

	public LabelSmallBase getCrJLabel_AcmCodeDesc() {
		if (CrJLabel_AcmCodeDesc == null) {
			CrJLabel_AcmCodeDesc = new LabelSmallBase();
			CrJLabel_AcmCodeDesc.setText("Acm. Code");
			CrJLabel_AcmCodeDesc.setBounds(44, 60, 80, 20);
		}
		return CrJLabel_AcmCodeDesc;
	}

	public ComboACMCode getCrJCombo_AcmCode() {
		if (CrJCombo_AcmCode == null) {
			CrJCombo_AcmCode = new ComboACMCode();
			CrJCombo_AcmCode.setBounds(133, 60, 175, 20);
		}
		return CrJCombo_AcmCode;
	}

	public LabelSmallBase getCrJLabel_VacantDesc() {
		if (CrJLabel_VacantDesc == null) {
			CrJLabel_VacantDesc = new LabelSmallBase();
			CrJLabel_VacantDesc.setText("Vacant");
			CrJLabel_VacantDesc.setBounds(369, 60, 80, 20);
		}
		return CrJLabel_VacantDesc;
	}

	public ComboYesNo getCrJCombo_Vacant() {
		if (CrJCombo_Vacant == null) {
			CrJCombo_Vacant = new ComboYesNo() {
				@Override
				public void resetText() {
					setText(YES_VALUE);
				}
			};
			CrJCombo_Vacant.setBounds(458, 60, 80, 20);
		}
		return CrJCombo_Vacant;
	}

	public LabelSmallBase getCrJLabel_OfficialDesc() {
		if (CrJLabel_OfficialDesc == null) {
			CrJLabel_OfficialDesc = new LabelSmallBase();
			CrJLabel_OfficialDesc.setText("Official");
			CrJLabel_OfficialDesc.setBounds(545, 60, 80, 20);
		}
		return CrJLabel_OfficialDesc;
	}

	public ComboYesNo getCrJCombo_Official() {
		if (CrJCombo_Official == null) {
			CrJCombo_Official = new ComboYesNo();
			CrJCombo_Official.setBounds(590, 60, 80, 20);
		}
		return CrJCombo_Official;
	}

	public LabelSmallBase getCrJLabel_DateFromDesc() {
		if (CrJLabel_DateFromDesc == null) {
			CrJLabel_DateFromDesc = new LabelSmallBase();
			CrJLabel_DateFromDesc.setText("Date From");
			CrJLabel_DateFromDesc.setBounds(44, 90, 80, 20);
		}
		return CrJLabel_DateFromDesc;
	}

	public TextDate getCrJText_DateFrom() {
		if (CrJText_DateFrom == null) {
			CrJText_DateFrom = new TextDate();
			CrJText_DateFrom.setBounds(133, 90, 175, 20);
		}
		return CrJText_DateFrom;
	}

	public LabelSmallBase getCrJLabel_DateToDesc() {
		if (CrJLabel_DateToDesc == null) {
			CrJLabel_DateToDesc = new LabelSmallBase();
			CrJLabel_DateToDesc.setText("Date To");
			CrJLabel_DateToDesc.setBounds(369, 90, 80, 20);
		}
		return CrJLabel_DateToDesc;
	}

	public TextDate getCrJText_DateTo() {
		if (CrJText_DateTo == null) {
			CrJText_DateTo = new TextDate();
			CrJText_DateTo.setBounds(458, 90, 175, 20);
		}
		return CrJText_DateTo;
	}

	/**
	 * This method initializes jScrollPane
	 *
	 * @return JScrollPane
	 */
	protected JScrollPane getBedScrollPane() {
		if (bedScrollPane == null) {
			bedScrollPane = new JScrollPane();
			bedScrollPane.setViewportView(getListTable());
			bedScrollPane.setBounds(15, 150, 682, 220);
		}
		return bedScrollPane;
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

	public LabelSmallBase getBedAvailDesc() {
		if (BedAvailDesc == null) {
			BedAvailDesc = new LabelSmallBase();
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

	public LabelSmallBase getCountDesc() {
		if (CountDesc == null) {
			CountDesc = new LabelSmallBase();
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

	public LabelSmallBase getRemarksDesc() {
		if (RemarksDesc == null) {
			RemarksDesc = new LabelSmallBase();
			RemarksDesc.setText("Remarks");
			RemarksDesc.setBounds(44, 0, 95, 20);
		}
		return RemarksDesc;
	}

	public TextReadOnly getRemarks() {
		if (Remarks == null) {
			Remarks = new TextReadOnly();
			Remarks.setBounds(139, 0, 172, 20);
		}
		return Remarks;
	}

	public LabelSmallBase getDateDesc() {
		if (DateDesc == null) {
			DateDesc = new LabelSmallBase();
			DateDesc.setText("Date");
			DateDesc.setBounds(369, 0, 95, 20);
		}
		return DateDesc;
	}

	public TextReadOnly getDate() {
		if (Date == null) {
			Date = new TextReadOnly();
			Date.setBounds(464, 0, 172, 20);
		}
		return Date;
	}
}