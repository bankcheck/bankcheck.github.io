package com.hkah.client.tx.registration;

import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.SearchPanel;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;

public class MomBabySearch extends SearchPanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.MOMBABYSEARCH_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.MOMBABYSEARCH_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
			"Mother PNo",
			"Mother Family Name",
			"Given Name",
			"Chinese Name",
			"Baby PNo",
			"Sex",
			"Baby Family ",
			"Baby Given Name",
			"Baby Chinese Name",
			"Date of Birth",
			"Remark"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				80,
				80,
				100,
				100,
				100,
				60,
				100,
				100,
				100,
				100,
				200
		};
	}

	private BasePanel searchPanel = null;
	private BasePanel ParaPanel = null;

	private LabelBase LJLabel_PatNo = null;
	private TextString LJText_PatNo = null;
	private LabelBase LJLabel_FamName = null;
	private TextString LJText_FamName = null;
	private LabelBase LJLabel_GivenName = null;
	private TextString LJText_GivenName = null;

	private FieldSetBase ListPanel = null;

	/**
	 * This method initializes
	 *
	 */
	public MomBabySearch() {
		super();
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		getJScrollPane().setBounds(10, 0, 735, 300);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return getLJText_PatNo();
	}

	/* >>> ~14~ Set Browse Validation ===================================== <<< */
	@Override
	protected boolean browseValidation() {
		if (getLJText_PatNo().getText().trim().length() == 0 &&
				getLJText_FamName().getText().trim().length() == 0 &&
				getLJText_GivenName().getText().trim().length() == 0) {
			Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_INPUT_CRITERIA, "Mom Baby Search", getDefaultFocusComponent());
			cleanTable();
			return false;
		}
		return true;
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
			getLJText_PatNo().getText().trim(),
			getLJText_FamName().getText().trim(),
			getLJText_GivenName().getText().trim(),
			"ALL" // Search both mother or baby's details
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
	protected void getFetchOutputValues(String[] outParam) {}

	/***************************************************************************
	 * Override Methods
	 **************************************************************************/

	@Override
	public void clearAction() {
		if (getClearButton().isEnabled()) {
			getLJText_PatNo().clear();
			getLJText_FamName().clear();
			getLJText_GivenName().clear();
		}
	}

	protected void enableButton(String mode) {
		disableButton();
		getClearButton().setEnabled(true);
		getSearchButton().setEnabled(true);
	}

	/***************************************************************************
	 * Layout Methods
	 **************************************************************************/

	@Override
	protected BasePanel getSearchPanel() {
		if (searchPanel == null) {
			searchPanel = new BasePanel();
			searchPanel.setSize(779, 528);
			searchPanel.add(getParaPanel(),null);
			searchPanel.add(getListPanel(), null);
		}
		return searchPanel;
	}

	public BasePanel getParaPanel() {
		if (ParaPanel == null) {
			ParaPanel = new BasePanel();
			ParaPanel.setBorders(true);
			ParaPanel.add(getLJLabel_PatNo(), null);
			ParaPanel.add(getLJText_PatNo(), null);
			ParaPanel.add(getLJLabel_FamName(), null);
			ParaPanel.add(getLJText_FamName(), null);
			ParaPanel.add(getLJLabel_GivenName(), null);
			ParaPanel.add(getLJText_GivenName(), null);
			ParaPanel.setBounds(5, 5, 757, 72);
		}
		return ParaPanel;
	}

	public LabelBase getLJLabel_PatNo() {
		if (LJLabel_PatNo == null) {
			LJLabel_PatNo = new LabelBase();
			LJLabel_PatNo.setText("Patient Number");
			LJLabel_PatNo.setBounds(74, 5, 104, 20);
		}
		return LJLabel_PatNo;
	}

	public TextString getLJText_PatNo() {
		if (LJText_PatNo == null) {
			LJText_PatNo = new TextString();
			LJText_PatNo.setBounds(178, 5, 149, 20);
		 }
		return LJText_PatNo;
	}

	public LabelBase getLJLabel_FamName() {
		if (LJLabel_FamName == null) {
			LJLabel_FamName = new LabelBase();
			LJLabel_FamName.setText("Patient Family Name");
			LJLabel_FamName.setBounds(390, 5, 141, 20);
		}
		return LJLabel_FamName;
	}

	public TextString getLJText_FamName() {
		if (LJText_FamName == null) {
			LJText_FamName = new TextString();
			LJText_FamName.setBounds(532, 5, 149, 20);
		 }
		return LJText_FamName;
	}

	public LabelBase getLJLabel_GivenName() {
		if (LJLabel_GivenName == null) {
			LJLabel_GivenName = new LabelBase();
			LJLabel_GivenName.setText("Patient Given Name");
			LJLabel_GivenName.setBounds(390, 35, 141, 20);
		}
		return LJLabel_GivenName;
	}

	public TextString getLJText_GivenName() {
		if (LJText_GivenName == null) {
			LJText_GivenName = new TextString();
			LJText_GivenName.setBounds(532, 35, 149, 20);
		 }
		return LJText_GivenName;
	}

	public FieldSetBase getListPanel() {
		if (ListPanel == null) {
			ListPanel = new FieldSetBase();
			ListPanel.setHeading("Mother Baby Information");
			ListPanel.setBounds(5, 84, 757, 336);
			ListPanel.add(getJScrollPane());
		}
		return ListPanel;
	}
}