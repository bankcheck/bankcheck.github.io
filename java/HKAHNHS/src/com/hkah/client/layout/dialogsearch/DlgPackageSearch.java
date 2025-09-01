package com.hkah.client.layout.dialogsearch;

import com.extjs.gxt.ui.client.widget.Component;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.dialog.DialogSearchBase;
import com.hkah.client.layout.label.LabelSmallBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.textfield.SearchTriggerField;
import com.hkah.client.layout.textfield.TextNum;
import com.hkah.client.layout.textfield.TextPackageCode;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;

public class DlgPackageSearch extends DialogSearchBase {
	protected String dptCode = null;
	protected boolean isLockDptCode = true;
	protected String packageCategoryExcl = null;

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		return ConstantsTx.PACKAGE_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return "Patient Business Administration System - [Package Search]";
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
			"Package Code",
			"Package Name",
			EMPTY_VALUE,
			EMPTY_VALUE,
			"Report Level",
			EMPTY_VALUE,
			EMPTY_VALUE,
			"Amount"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
			150,
			350,
			0,
			0,
			100,
			0,
			0,
			100
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private BasePanel searchPanel = null;
	private ColumnLayout columnPanel = null;

	private LabelSmallBase packageCodeDesc = null;
	private TextPackageCode packageCode = null;
	private LabelSmallBase packageNameDesc = null;
	private TextString packageName = null;
	private LabelSmallBase reportLevelDesc = null;
	private TextNum reportLevel = null;
	private JScrollPane itemScrollPanel = null;
	private String slpNo = null;	

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */

	/**
	* This method initializes
	*
	*/
	public DlgPackageSearch(SearchTriggerField textfField) {
		this(textfField, null);
	}

	public DlgPackageSearch(SearchTriggerField textfField, String packageCategoryExcl) {
		super(textfField, 780, 500);

		this.packageCategoryExcl = packageCategoryExcl;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		getListTable().setColumnNumber(4);
		getListTable().setColumnAmount(7);		
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public Component getDefaultFocusComponent() {
		return getPackageCode();
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {	
		return new String[] {
				getPackageCode().getText().trim(),
				getPackageName().getText().trim(),
				getReportLevel().getText().trim(),
				getUserInfo().getDeptCode(),
				getParameter("SlpNo")
		};
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected boolean isSearchFieldsEmpty() {
		return getPackageCode().isEmpty()
			&& getPackageName().isEmpty()
			&& getReportLevel().isEmpty();
	}

	@Override
	protected String getInputCriteriaMessage() {
		return ConstantsMessage.MSG_INPUT_CRITERIA;
	}

	/***************************************************************************
	* Layout Method
	**************************************************************************/

	/* >>> getter methods for init the Component start from here ================================== <<< */
	@Override
	protected BasePanel getSearchPanel() {
		if (searchPanel == null) {
			searchPanel = new BasePanel();
			searchPanel.add(getItemSearchPanel(), null);
			searchPanel.add(getItemScrollPane());
			searchPanel.setSize(800, 175);
		}
		return searchPanel;
	}

	protected ColumnLayout getItemSearchPanel() {
		if (columnPanel == null) {
			columnPanel = new ColumnLayout(4, 2);
			columnPanel.setBounds(15, 5, 735, 90);
			columnPanel.setHeading("Package Information");
			columnPanel.add(0, 0, getPackageCodeDesc());
			columnPanel.add(1, 0, getPackageCode());
			columnPanel.add(2, 0, getPackageNameDesc());
			columnPanel.add(3, 0, getPackageName());
			columnPanel.add(0, 1, getReportLevelDesc());
			columnPanel.add(1, 1, getReportLevel());
		}
		return columnPanel;
	}

	public LabelSmallBase getPackageCodeDesc() {
		if (packageCodeDesc == null) {
			packageCodeDesc = new LabelSmallBase();
			packageCodeDesc.setText("Package Code");
		}
		return packageCodeDesc;
	}

	public TextPackageCode getPackageCode() {
		if (packageCode == null) {
			packageCode = new TextPackageCode();
			packageCode.setSize(150, 20);
		}
		return packageCode;
	}

	public LabelSmallBase getPackageNameDesc() {
		if (packageNameDesc == null) {
			packageNameDesc = new LabelSmallBase();
			packageNameDesc.setText("Package Name");
		}
		return packageNameDesc;
	}

	public TextString getPackageName() {
		if (packageName == null) {
			packageName = new TextString();
			packageName.setSize(150, 20);
		}
		return packageName;
	}

	public LabelSmallBase getReportLevelDesc() {
		if (reportLevelDesc == null) {
			reportLevelDesc = new LabelSmallBase();
			reportLevelDesc.setText("Report Level");
		}
		return reportLevelDesc;
	}

	public TextNum getReportLevel() {
		if (reportLevel == null) {
			reportLevel = new TextNum(1);
			reportLevel.setSize(150, 20);
		}
		return reportLevel;
	}

	/**
	 * This method initializes itemScrollPanel
	 *
	 * @return JScrollPane
	 */
	protected JScrollPane getItemScrollPane() {
		if (itemScrollPanel == null) {
			itemScrollPanel = new JScrollPane();
			itemScrollPanel.setViewportView(getListTable());
			itemScrollPanel.setBounds(15, 110, 735, 305);
		}
		return itemScrollPanel;
	}
}