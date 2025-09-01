package com.hkah.client.layout.dialogsearch;

import com.extjs.gxt.ui.client.widget.Component;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.combobox.ComboDept;
import com.hkah.client.layout.combobox.ComboDeptServ;
import com.hkah.client.layout.combobox.ComboItemType;
import com.hkah.client.layout.dialog.DialogSearchBase;
import com.hkah.client.layout.label.LabelSmallBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.textfield.SearchTriggerField;
import com.hkah.client.layout.textfield.TextItemCode;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;

public class DlgItemSearch extends DialogSearchBase {
	protected String dptCode = null;
	protected boolean isLockDptCode = true;
	protected String itemCategoryExcl = null;

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		return ConstantsTx.ITEM_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return "Patient Business Administration System - [Item Search]";
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Item Code",
				"Item Name",
				"",
				"Item Type",
				"Report Level",
				"Dept Service Code",
				"Dept Service Desc",
				"Dept Code",
				"Dept Name",
				"","","","",""
				};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
			65,
			100,
			0,
			65,
			80,
			120,
			120,
			75,
			120,
			0,0,0,0,0
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private BasePanel searchPanel = null;
	private ColumnLayout columnPanel = null;

	private LabelSmallBase itemCodeDesc = null;
	private TextItemCode itemCode = null;
	private LabelSmallBase itemNameDesc = null;
	private TextString itemName = null;
	private LabelSmallBase itemTypeDesc = null;
	private ComboItemType itemType = null;
	private LabelSmallBase dptNameDesc = null;
	private ComboDept dptName = null;
	private LabelSmallBase dptServiceCodeDesc = null;
	private ComboDeptServ dptServiceCode = null;
	private JScrollPane itemScrollPanel = null;

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */

	/**
	* This method initializes
	*
	*/
	public DlgItemSearch(SearchTriggerField textfField) {
		this(textfField, null);
	}

	public DlgItemSearch(SearchTriggerField textfField, String itemCategoryExcl) {
		super(textfField, 780, 500);

		this.itemCategoryExcl = itemCategoryExcl;

		dptCode = getUserInfo().getDeptCode();
		if (dptCode != null && !dptCode.isEmpty() && isLockDptCode) {
			getDptName().setEditableForever(false);
		}
		getDptName().initContent(dptCode);
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		getListTable().setColumnClass(3, new ComboItemType(), false);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public Component getDefaultFocusComponent() {
		return getItemCode();
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
				getItemCode().getText().trim(),
				getItemName().getText().trim(),
				getItemType().getText().trim(),
				getDptName().getText().trim(),
				getDptServiceCode().getText().trim(),
				getParameter("ITMCAT"),
				itemCategoryExcl
		};
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected boolean isSearchFieldsEmpty() {
		return getItemCode().isEmpty()
			&& getItemName().isEmpty()
			&& getItemType().isEmpty()
			&& getDptName().isEmpty()
			&& getDptServiceCode().isEmpty();
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
			columnPanel = new ColumnLayout(4, 4);
			columnPanel.setBounds(15, 5, 735, 110);
			columnPanel.setHeading("Item Information");
			columnPanel.add(0, 0, getItemCodeDesc());
			columnPanel.add(1, 0, getItemCode());
			columnPanel.add(2, 0, getItemNameDesc());
			columnPanel.add(3, 0, getItemName());
			columnPanel.add(0, 1, getItemTypeDesc());
			columnPanel.add(1, 1, getItemType());
			columnPanel.add(2, 1, getDptNameDesc());
			columnPanel.add(3, 1, getDptName());
			columnPanel.add(0, 2, getDptServiceCodeDesc());
			columnPanel.add(1, 2, getDptServiceCode());
		}
		return columnPanel;
	}

	public LabelSmallBase getItemCodeDesc() {
		if (itemCodeDesc == null) {
			itemCodeDesc = new LabelSmallBase();
			itemCodeDesc.setText("Item Code");
//			itemCodeDesc.setBounds(5, 15, 90, 20);
		}
		return itemCodeDesc;
	}

	public TextItemCode getItemCode() {
		if (itemCode == null) {
			itemCode = new TextItemCode();
//			itemCode.setBounds(100, 15, 150, 20);
		}
		return itemCode;
	}

	public LabelSmallBase getItemNameDesc() {
		if (itemNameDesc == null) {
			itemNameDesc = new LabelSmallBase();
			itemNameDesc.setText("Item Name");
//			itemNameDesc.setBounds(255,15,90,20);
		}
		return itemNameDesc;
	}

	public TextString getItemName() {
		if (itemName == null) {
			itemName = new TextString();
//			itemName.setBounds(350,15,150,20);
		}
		return itemName;
	}

	public LabelSmallBase getItemTypeDesc() {
		if (itemTypeDesc == null) {
			itemTypeDesc = new LabelSmallBase();
			itemTypeDesc.setText("Item Type");
//			itemTypeDesc.setBounds(505, 15, 90, 20);
		}
		return itemTypeDesc;
	}

	public ComboItemType getItemType() {
		if (itemType == null) {
			itemType = new ComboItemType();
//			itemType.setBounds(600, 15, 150, 20);
		}
		return itemType;
	}

	public LabelSmallBase getDptNameDesc() {
		if (dptNameDesc == null) {
			dptNameDesc = new LabelSmallBase();
			dptNameDesc.setText("Department Name");
		}
		return dptNameDesc;
	}

	public ComboDept getDptName() {
		if (dptName == null) {
			dptName = new ComboDept();
//			dptName.setBounds(100, 40, 150, 20);
		}
		return dptName;
	}

	public LabelSmallBase getDptServiceCodeDesc() {
		if (dptServiceCodeDesc == null) {
			dptServiceCodeDesc = new LabelSmallBase();
			dptServiceCodeDesc.setText("Dept Service Code");
//			dptServiceCodeDesc.setBounds(5, 65, 90, 20);
		}
		return dptServiceCodeDesc;
	}

	public ComboDeptServ getDptServiceCode() {
		if (dptServiceCode == null) {
			dptServiceCode = new ComboDeptServ();
//			dptServiceCode.setBounds(100, 65, 150, 20);
		}
		return dptServiceCode;
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
			itemScrollPanel.setBounds(15, 130, 735, 285);
		}
		return itemScrollPanel;
	}
}