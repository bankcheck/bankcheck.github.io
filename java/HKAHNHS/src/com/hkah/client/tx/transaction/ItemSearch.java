package com.hkah.client.tx.transaction;


import com.extjs.gxt.ui.client.util.Rectangle;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.combobox.ComboDept;
import com.hkah.client.layout.combobox.ComboDeptServ;
import com.hkah.client.layout.combobox.ComboItemType;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextItemCode;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MasterPanel;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;

public class ItemSearch extends MasterPanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.ITEM_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.ITEM_TITLE + " Search";
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
			"Item Code",
			"Item Name",
			"ITMCNAME",
			"Item Type",
			"Report Level",
			"Dept Service Code",
			"Dept Service Desc",
			"Dept Code",
			"Dept Name",
			"STECODE",
			"ITMPOVERRD",
			"ITMDOCCR",
			"ITMCAT",
			"ITMGRP"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				80,
				80,
				0,
				80,
				120,
				120,
				80,
				120,
				120,
				0,
				0,
				0,
				0,
				0
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private BasePanel rightPanel=null;
	private BasePanel leftPanel=null;
	private BasePanel ParaPanel = null;
	private LabelBase itemCodeDesc=null;
	private TextItemCode itemCode=null;
	private LabelBase itemNameDesc=null;
	private TextString itemName=null;
	private LabelBase itemTypeDesc=null;
	private ComboItemType itemType=null;
	private LabelBase dptNameDesc=null;
	private ComboDept dptName=null;
	private LabelBase dptServiceCodeDesc=null;
	private ComboDeptServ dptServiceCode=null;
	private JScrollPane JScrollPane = null;
	private BasePanel ListPanel = null;

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */

	/**
	 * This method initializes
	 *
	 */
	public ItemSearch() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		setLeftAlignPanel();
		getJScrollPane().setBounds(15, 25, 725, 290);
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		getAppendButton().setEnabled(false);
		getCancelButton().setEnabled(true);
		getPrintButton().setEnabled(false);
		getRefreshButton().setEnabled(false);
		getCancelButton().setEnabled(false);
		getAcceptButton().setEnabled(true);
		getRefreshButton().setEnabled(true);
		System.out.println("itemCode==="+getParameter("itmCode"));
		if (getParameter("itmCode") != null && getParameter("itmCode").length() > 0) {
			getItemCode().setValue(getParameter("itmCode"));

			setParameter("itmCode", ConstantsVariable.EMPTY_VALUE);
		}
		this.getListTable().setColumnClass(2, new ComboItemType(), false);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return getItemCode();
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
	protected void deleteDisabledFields() {}

	/* >>> ~14~ Set Browse Validation ===================================== <<< */
	@Override
	protected boolean browseValidation() {
		int i=0;
		if (!getItemCode().isEmpty()) i++;
		if (!getItemName().isEmpty()) i++;
		if (!getItemType().isEmpty()) i++;
		if (!getDptName().isEmpty()) i++;
		if (!getDptServiceCode().isEmpty()) i++;
		if (i == 0) {
			Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_INPUT_CRITERIA, "Item Search", getDefaultFocusComponent());
			return false;
		} else {
			return true;
		}
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
				getItemCode().getText().trim(),
				getItemName().getText().trim(),
				getItemType().getText(),
				getDptName().getText(),
				getDptServiceCode().getText(),
				getParameter("ITMCAT"),
				""
		};
	}

	/* >>> ~16~ Set Fetch Input Parameters ================================ <<< */
	@Override
	protected String[] getFetchInputParameters() {
		return null;
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {}

	/* >>> ~15~ Set Fetch Output Results ============================== <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return null;
	}

	/***************************************************************************
	 * Overload Method
	 **************************************************************************/

	public void acceptAction() {
		// clear store value
		setParameter("itmCode1", ConstantsVariable.EMPTY_VALUE);
		if (getListTable().getRowCount() > 0) {
			if (getListTable().getSelectedRowCount() > 0) {
				// store item code from selected
				setParameter("itmCode1", getListTable().getSelectedRowContent()[0]);
				setParameter("itmName", getListTable().getSelectedRowContent()[1]);
			}
		}
		// back to previous page
		exitPanel();
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

//	protected JSplitPane getBodyPanel(boolean requiredScroll) {
//		// add button to left panel
//		//getLeftPanel().add(getJScrollPane(), null);
//		// add left/right pannel
//		getjSplitPane().setLeftComponent(getLeftPanel());
//
//		if (isRequiredScroll()) {
//			JScrollPane jScrollPanel = new JScrollPane(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS, JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
//			jScrollPanel.setViewportView(getRightPanel());
//			//getjSplitPane().setRightComponent(jScrollPanel);
//			//jSplitPane.setRightComponent(new JScrollPane(getRightPanel(), JScrollPane.VERTICAL_SCROLLBAR_ALWAYS, JScrollPane.HORIZONTAL_SCROLLBAR_NEVER));
//		} else {
//			//getjSplitPane().setRightComponent(getRightPanel());
//		}
//
//		getjSplitPane().setPreferredSize(new Dimension(1017, 619));
//		getjSplitPane().setDividerLocation(395);
//		getjSplitPane().setDividerSize(3);
//		//setLeftAlignPanel();
//		return getjSplitPane();
//	}

	//action method override end
	/* >>> getter methods for init the Component start from here ================================== <<< */
	@Override
	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.setSize(779, 528);
			leftPanel.add(getParaPanel(),null);
			leftPanel.add(getListPanel(), null);
		}
		return leftPanel;
	}

	protected BasePanel getRightPanel() {
		if (rightPanel == null) {
			rightPanel = new BasePanel();
			//leftPanel.setSize(800, 530));
		}
		return rightPanel;
	}

	public BasePanel getParaPanel() {
		if (ParaPanel == null) {
			ParaPanel = new BasePanel();
			ParaPanel.setLocation(5, 5);
			ParaPanel.setHeading("Item Information");
			ParaPanel.setSize(757, 100);
			ParaPanel.add(getItemCodeDesc(),null);
			ParaPanel.add(getItemCode(),null);
			ParaPanel.add(getItemNameDesc(),null);
			ParaPanel.add(getItemName(),null);
			ParaPanel.add(getItemTypeDesc(),null);
			ParaPanel.add(getItemType(),null);
			ParaPanel.add(getDptNameDesc(),null);
			ParaPanel.add(getDptName(),null);
			ParaPanel.add(getDptServiceCodeDesc(),null);
			ParaPanel.add(getDptServiceCode(),null);
		}
		return ParaPanel;
	}


	public LabelBase getItemCodeDesc() {
		if (itemCodeDesc == null) {
			itemCodeDesc = new LabelBase();
			itemCodeDesc.setText("Item Code");
			itemCodeDesc.setBounds(50, 15, 97, 20);
		}
		return itemCodeDesc;
	}

	public TextItemCode getItemCode() {
		if (itemCode == null) {
			itemCode = new TextItemCode();
			itemCode.setBounds(151, 15, 150, 20);
		}
		return itemCode;
	}

	public LabelBase getItemNameDesc() {
		if (itemNameDesc == null) {
			itemNameDesc = new LabelBase();
			itemNameDesc.setText("Item Name");
			itemNameDesc.setBounds(355,15,100,20);
	 }
		return itemNameDesc;
	}

	public TextString getItemName() {
		if (itemName == null) {
			itemName = new TextString();
			itemName.setBounds(460,15,150,20);
	 }
		return itemName;
	}

	public LabelBase getItemTypeDesc() {
		if (itemTypeDesc == null) {
			itemTypeDesc = new LabelBase();
			itemTypeDesc.setText("Item Type");
			itemTypeDesc.setBounds(50, 40, 97, 20);
	 }
		return itemTypeDesc;
	}

	public ComboItemType getItemType() {
		if (itemType == null) {
			itemType = new ComboItemType();
			itemType.setBounds(151, 40, 150, 20);
	 }
		return itemType;
	}

	public LabelBase getDptNameDesc() {
		if (dptNameDesc == null) {
			dptNameDesc = new LabelBase();
			dptNameDesc.setText("Department Name");
			dptNameDesc.setBounds(355, 40, 100, 20);
		}
		return dptNameDesc;
	}

	public ComboDept getDptName() {
		if (dptName == null) {
			dptName = new ComboDept();
			dptName.setBounds(460, 40, 150, 20);
		}
		return dptName;
	}

	public LabelBase getDptServiceCodeDesc() {
		if (dptServiceCodeDesc == null) {
			dptServiceCodeDesc = new LabelBase();
			dptServiceCodeDesc.setText("Dept Service Code");
			dptServiceCodeDesc.setBounds(50, 65, 97, 20);
		}
		return dptServiceCodeDesc;
	}

	public ComboDeptServ getDptServiceCode() {
		if (dptServiceCode == null) {
			dptServiceCode = new ComboDeptServ();
			dptServiceCode.setBounds(151, 65, 150, 20);
		}
		return dptServiceCode;
	}

	public BasePanel getListPanel() {
		if (ListPanel == null) {
			ListPanel = new BasePanel();
			ListPanel.setHeading("Item List");
			ListPanel.setBounds(new Rectangle(5, 110, 757, 336));
			this.getLeftPanel().remove(this.getJScrollPane());
			ListPanel.add(getJScrollPane());
		}
		return ListPanel;
	}
}