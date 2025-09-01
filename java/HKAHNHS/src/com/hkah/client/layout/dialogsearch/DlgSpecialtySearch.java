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

public class DlgSpecialtySearch extends DialogSearchBase {
	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.SPECIALTY_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.SPECIALTY_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Specialty Code",
				"Specialty Name"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				100,
				300
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private BasePanel searchPanel = null;
	private ColumnLayout columnPanel = null;
	private LabelSmallBase LeftJLabel_SpecialtyCode = null;
	private TextString LeftJText_SpecialtyCode = null;
	private LabelSmallBase LeftJLabel_SpecialtyName = null;
	private TextString LeftJText_SpecialtyName = null;
	private JScrollPane specialtyScrollPane = null;

	public DlgSpecialtySearch(SearchTriggerField textField) {
		super(textField, 800, 500);
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		getLeftPanel().setPosition(10, 20);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return getLeftJText_SpecialtyCode();
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
				getLeftJText_SpecialtyCode().getText(),
				getLeftJText_SpecialtyName().getText()
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

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected boolean isSearchFieldsEmpty() {
		return getLeftJText_SpecialtyCode().isEmpty()
			&& getLeftJText_SpecialtyName().isEmpty();
	}

	@Override
	protected String getInputCriteriaMessage() {
		return ConstantsMessage.MSG_INPUT_CRITERIA;
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/**
	 * This method initializes leftPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected BasePanel getSearchPanel() {
		if (searchPanel == null) {
			searchPanel = new BasePanel();
//			leftPanel.setSize(399, 100);
			searchPanel.add(getSpecialtySearchPanel(), null);
			searchPanel.add(getSpecialtyScrollPanel());
			searchPanel.setSize(800, 175);
		}
		return searchPanel;
	}

	/**
	 * This method initializes leftPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected ColumnLayout getSpecialtySearchPanel() {
		if (columnPanel == null) {
			columnPanel = new ColumnLayout(4,1);
			columnPanel.setHeading("Specialty Information");
			columnPanel.add(0,0,getLeftJLabel_SpecialtyCode());
			columnPanel.add(1,0,getLeftJText_SpecialtyCode());
			columnPanel.add(2,0,getLeftJLabel_SpecialtyName());
			columnPanel.add(3,0,getLeftJText_SpecialtyName());
			columnPanel.setBounds(15, 10, 734, 80);
		}
		return columnPanel;
	}

	/**
	 * This method initializes jScrollPane
	 *
	 * @return JScrollPane
	 */
	protected JScrollPane getSpecialtyScrollPanel() {
		if (specialtyScrollPane == null) {
			specialtyScrollPane = new JScrollPane();
			specialtyScrollPane.setViewportView(getListTable());
			specialtyScrollPane.setBounds(15, 100, 734, 315);
		}
		return specialtyScrollPane;
	}

	/**
	 * This method initializes LeftJLabel_SpecialtyCode
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getLeftJLabel_SpecialtyCode() {
		if (LeftJLabel_SpecialtyCode == null) {
			LeftJLabel_SpecialtyCode = new LabelSmallBase();
			LeftJLabel_SpecialtyCode.setText("Specialty Code:");
			LeftJLabel_SpecialtyCode.setOptionalLabel();
		}
		return LeftJLabel_SpecialtyCode;
	}

	/**
	 * This method initializes LeftJText_SpecialtyCode
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getLeftJText_SpecialtyCode() {
		if (LeftJText_SpecialtyCode == null) {
			LeftJText_SpecialtyCode = new TextString(10,true);
		}
		return LeftJText_SpecialtyCode;
	}

	/**
	 * This method initializes LeftJLabel_SpecialtyName
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getLeftJLabel_SpecialtyName() {
		if (LeftJLabel_SpecialtyName == null) {
			LeftJLabel_SpecialtyName = new LabelSmallBase();
			LeftJLabel_SpecialtyName.setText("Specialty Name:");
			LeftJLabel_SpecialtyName.setOptionalLabel();
		}
		return LeftJLabel_SpecialtyName;
	}

	/**
	 * This method initializes LeftJText_SpecialtyName
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getLeftJText_SpecialtyName() {
		if (LeftJText_SpecialtyName == null) {
			LeftJText_SpecialtyName = new TextString(50,true);
		}
		return LeftJText_SpecialtyName;
	}
}
