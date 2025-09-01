package com.hkah.client.layout.dialogsearch;

import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.dialog.DialogSearchBase;
import com.hkah.client.layout.label.LabelSmallBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.textfield.SearchTriggerField;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;

public class DlgRoomSearch extends DialogSearchBase {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.ROOM_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return "Room Search";
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
			"Room Code",
			"Room Sex",
			"Ward Code",
			"Ward Name",
			"Acm. Code",
			"Acm. Description",
			"Site Code"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				70,
				70,
				70,
				130,
				70,
				100,
				0
		};
	}

	private BasePanel searchPanel = null;
	private ColumnLayout paraPanel = null;

	private LabelSmallBase roomCodeDesc = null;
	private TextString roomCode = null;
	private LabelSmallBase roomSexDesc = null;
	private TextString roomSex = null;
	private LabelSmallBase wardCodeDesc = null;
	private TextString wardCode = null;
	private LabelSmallBase acmCodeDesc = null;
	private TextString acmCode = null;
	private JScrollPane roomScrollPane = null;

	public DlgRoomSearch(SearchTriggerField textfField) {
		super(textfField, 730, 590);
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return getRoomCode();
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return 	new String[] {
					getRoomCode().getText(),
					getRoomSex().getText(),
					getWardCode().getText(),
					getAcmCode().getText()
				};
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected boolean isSearchFieldsEmpty() {
		return getRoomCode().isEmpty()
			&& getRoomSex().isEmpty()
			&& getWardCode().isEmpty()
			&& getAcmCode().isEmpty();
	}

	@Override
	protected String getInputCriteriaMessage() {
		return ConstantsMessage.MSG_INPUT_CRITERIA;
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/* >>> getter methods for init the Component start from here================================== <<< */
	@Override
	protected BasePanel getSearchPanel() {
		if (searchPanel == null) {
			searchPanel = new BasePanel();
			searchPanel.setSize(682, 175);
			searchPanel.add(getParaPanel(),null);
			searchPanel.add(getRoomScrollPane());
		}
		return searchPanel;
	}

	public ColumnLayout getParaPanel() {
		if (paraPanel == null) {
			paraPanel = new ColumnLayout(4, 4);
			paraPanel.setBounds(15, 5, 682, 110);
			paraPanel.setHeading("Room Information");
			paraPanel.add(0, 0, getRoomCodeDesc());
			paraPanel.add(1, 0, getRoomCode());
			paraPanel.add(2, 0, getRoomSexDesc());
			paraPanel.add(3, 0, getRoomSex());
			paraPanel.add(0, 1, getWardCodeDesc());
			paraPanel.add(1, 1, getWardCode());
			paraPanel.add(2, 1, getAcmCodeDesc());
			paraPanel.add(3, 1, getAcmCode());
		}
		return paraPanel;
	}

	public LabelSmallBase getRoomCodeDesc() {
		if (roomCodeDesc == null) {
			roomCodeDesc=new LabelSmallBase();
			roomCodeDesc.setText("Room Code");
		}
		return roomCodeDesc;
	}

	public TextString getRoomCode() {
		if (roomCode == null) {
			roomCode=new TextString();
		 }
		return roomCode;
	}

	public LabelSmallBase getRoomSexDesc() {
		if (roomSexDesc == null) {
			roomSexDesc=new LabelSmallBase();
			roomSexDesc.setText("Room Sex");
		}
		return roomSexDesc;
	}

	public TextString getRoomSex() {
		if (roomSex == null) {
			roomSex=new TextString();
		 }
		return roomSex;
	}

	public LabelSmallBase getWardCodeDesc() {
		if (wardCodeDesc == null) {
			wardCodeDesc=new LabelSmallBase();
			wardCodeDesc.setText("Ward Code");
		}
		return wardCodeDesc;
	}

	public TextString getWardCode() {
		if (wardCode == null) {
			wardCode=new TextString();
		 }
		return wardCode;
	}

	public LabelSmallBase getAcmCodeDesc() {
		if (acmCodeDesc == null) {
			acmCodeDesc=new LabelSmallBase();
			acmCodeDesc.setText("Acm. Code");
		}
		return acmCodeDesc;
	}

	public TextString getAcmCode() {
		if (acmCode == null) {
			acmCode = new TextString();
		}
		return acmCode;
	}

	protected JScrollPane getRoomScrollPane() {
		if (roomScrollPane == null) {
			roomScrollPane = new JScrollPane();
			roomScrollPane.setViewportView(getListTable());
			roomScrollPane.setBounds(15, 130, 682, 320);
		}
		return roomScrollPane;
	}
}