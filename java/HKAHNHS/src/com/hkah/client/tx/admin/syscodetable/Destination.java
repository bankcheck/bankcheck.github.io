/*
 * Created on July 23, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.tx.admin.syscodetable;

import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.combobox.ComboDestType;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MaintenancePanel;
import com.hkah.shared.constants.ConstantsTx;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class Destination extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.DESTINATION_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.DESTINATION_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Destination Code",
				"Destination Description",
				"Destination Type"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				100,
				150,
				100
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;  //  @jve:decl-index=0:visual-constraint="13,32"
	private LabelBase LeftJLabel_DestCode = null;
	private TextString LeftJText_DestCode = null;
	private LabelBase LeftJLabel_DestDesc = null;
	private TextString LeftJText_DestDesc = null;
	private LabelBase LeftJLabel_DestType = null;
	private ComboDestType LeftJCombo_DestType = null;
	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;  //  @jve:decl-index=0:visual-constraint="11,207"
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_DestCode = null;
	private TextString RightJText_DestCode = null;
	private LabelBase RightJLabel_DestDesc = null;
	private TextString RightJText_DestDesc = null;
	private LabelBase RightJLabel_DestType = null;
	private ComboDestType RightJCombo_DestType = null;
	/**
	 * This method initializes
	 *
	 */
	public Destination() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		/* >>> ~7.1~ Init action (e.g. Listing, Init Comobbox ========= <<< */
		//setFullEntry(true);
		setNoGetDB(true);

		/* >>> ~7.2~ Disable Add/Modify/Delete Buttons ================ <<< */
		//setAppendButtonEnabled(false);
		//setModifyButtonEnabled(false);
		//setDeleteButtonEnabled(false);

		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		//performList();
		//getListTable().setColumnClass(2,new ComboDestType(), false);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return getLeftJText_DestCode();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {
		// override function if necessary
	}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {
		// enable/disable field
	}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
		// enable/disable field
		getRightJText_DestCode().setEnabled(false);
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
				getLeftJText_DestCode().getText(),
				getLeftJText_DestDesc().getText()
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
		int index = 0;
		getRightJText_DestCode().setText(outParam[index++]);
		getRightJText_DestDesc().setText(outParam[index++]);
		getRightJCombo_DestType().setText(outParam[index++]);

		}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return new String[] {
				getRightJText_DestCode().getText(),
				getRightJText_DestDesc().getText(),
				getRightJCombo_DestType().getText(),
			};
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {
		if (getRightJText_DestCode().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Dest. Code!", getRightJText_DestCode());
			actionValidationReady(actionType, false);
		} else if (getRightJText_DestDesc().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Dest. Desc.!", getRightJText_DestDesc());
			actionValidationReady(actionType, false);
		} else {
			actionValidationReady(actionType, true);
		}
	}

	/* >>> ~22~ Set Action Input Parameters per table ===================== <<< */
	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		// TODO Auto-generated method stub
		String[] param=new String[] {
				selectedContent[0],
				selectedContent[1],
				selectedContent[2]
		};
		return param;
	}

	/* >>> ~23~ Set Action Validation per table =========================== <<< */
	@Override
	protected boolean actionValidation(String[] selectedContent) {
		// TODO Auto-generated method stub
		if (selectedContent[0]==null || selectedContent[0].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty Dest.Code!");
			return false;
		} else if (selectedContent[1]==null || selectedContent[1].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty Dest.Desc!");
			return false;
		} else if (selectedContent[2]==null || selectedContent[2].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty Dest.Type!");
			return false;
		}
		return true;
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/**
	 * This method initializes leftPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected ColumnLayout getSearchPanel() {
		if (leftPanel == null) {
			leftPanel = new ColumnLayout(4,1);
//			leftPanel.setSize(399, 136);
			leftPanel.add(0,0,getLeftJLabel_DestCode());
			leftPanel.add(1,0,getLeftJText_DestCode());
			leftPanel.add(2,0,getLeftJLabel_DestDesc());
			leftPanel.add(3,0,getLeftJText_DestDesc());
	//		leftPanel.add(getLeftJCombo_DestType(), null);
	//		leftPanel.add(getLeftJLabel_DestType(), null);
		}
		return leftPanel;
	}

	/**
	 * This method initializes LeftJLabel_DestCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */


	private LabelBase getLeftJLabel_DestCode() {
		if (LeftJLabel_DestCode == null) {
			LeftJLabel_DestCode = new LabelBase();
//			LeftJLabel_DestCode.setBounds(14, 15, 102, 20);
			LeftJLabel_DestCode.setText("Dest. Code:");
			LeftJLabel_DestCode.setOptionalLabel();
		}
		return LeftJLabel_DestCode;
	}

	/**
	 * This method initializes LeftJText_DestCode
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getLeftJText_DestCode() {
		if (LeftJText_DestCode == null) {
			LeftJText_DestCode = new TextString(10,true);
//			LeftJText_DestCode.setLocation(133, 15);
		}
		return LeftJText_DestCode;
	}

	/**
	 * This method initializes LeftJLabel_DestDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getLeftJLabel_DestDesc() {
		if (LeftJLabel_DestDesc == null) {
			LeftJLabel_DestDesc = new LabelBase();
//			LeftJLabel_DestDesc.setBounds(14, 55, 103, 20);
			LeftJLabel_DestDesc.setText("Dest. Desc.:");
			LeftJLabel_DestDesc.setOptionalLabel();
		}
		return LeftJLabel_DestDesc;
	}

	/**
	 * This method initializes LeftJText_DestDesc
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getLeftJText_DestDesc() {
		if (LeftJText_DestDesc == null) {
			LeftJText_DestDesc = new TextString(50,true);
//			LeftJText_DestDesc.setBounds(133, 56, 255, 20);
		}
		return LeftJText_DestDesc;
	}

	/**
	 * This method initializes LeftJLabel_DestType
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getLeftJLabel_DestType() {
		if (LeftJLabel_DestType == null) {
			LeftJLabel_DestType = new LabelBase();
			LeftJLabel_DestType.setText("Dest. Type:");
//			LeftJLabel_DestType.setBounds(14, 94, 103, 30);
			LeftJLabel_DestType.setOptionalLabel();
		}
		return LeftJLabel_DestType;
	}

	/**
	 * This method initializes LeftJComboDestType
	 *
	 * @return com.hkah.client.layout.combobox.Combo_DestType
	 */
	private ComboDestType getLeftJCombo_DestType() {
		if (LeftJCombo_DestType == null) {
			LeftJCombo_DestType = new ComboDestType();
//			LeftJCombo_DestType.setBounds(134, 94, 88, 29);
		}
		return LeftJCombo_DestType;
	}


	/**
	 * This method initializes generalPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected ColumnLayout getActionPanel() {
		if (generalPanel == null) {
			generalPanel = new ColumnLayout(4,2);
			//generalPanel.setBounds(1, 0, 607, 169);
			generalPanel.setHeading("Destination Information");
			generalPanel.add(0,0,getRightJLabel_DestCode());
			generalPanel.add(1,0,getRightJText_DestCode());
			generalPanel.add(2,0,getRightJLabel_DestDesc());
			generalPanel.add(3,0,getRightJText_DestDesc());
			generalPanel.add(0,1,getRightJLabel_DestType());
			generalPanel.add(1,1,getRightJCombo_DestType());
		}
		return generalPanel;
	}

	/**
	 * This method initializes RightJLabel_DestCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_DestCode() {
		if (RightJLabel_DestCode == null) {
			RightJLabel_DestCode = new LabelBase();
			RightJLabel_DestCode.setText("Dest. Code");
//			RightJLabel_DestCode.setBounds(43, 33, 108, 20);
		}
		return RightJLabel_DestCode;
	}

	/**
	 * This method initializes RightJText_DestCode
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_DestCode() {
		if (RightJText_DestCode == null) {
			RightJText_DestCode = new TextString(10,getListTable(), 0,true);
		}
		return RightJText_DestCode;
	}

	/**
	 * This method initializes RightJLabel_DestDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_DestDesc() {
		if (RightJLabel_DestDesc == null) {
			RightJLabel_DestDesc = new LabelBase();
			RightJLabel_DestDesc.setText("Dest. Desc.");
//			RightJLabel_DestDesc.setBounds(43, 75, 106, 20);
		}
		return RightJLabel_DestDesc;
	}

	/**
	 * This method initializes RightJText_DestDesc
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_DestDesc() {
		if (RightJText_DestDesc == null) {
			RightJText_DestDesc = new TextString(50,getListTable(), 1,true);
		}
		return RightJText_DestDesc;
	}
	/**
	 * This method initializes RightJLabel_DestType
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_DestType() {
		if (RightJLabel_DestType == null) {
			RightJLabel_DestType = new LabelBase();
			RightJLabel_DestType.setText("Dest. Type:");
//			RightJLabel_DestType.setBounds(43, 117, 103, 20);
			RightJLabel_DestType.setOptionalLabel();
		}
		return RightJLabel_DestType;
	}

	/**
	 * This method initializes RightJCombo_DestType
	 *
	 * @return com.hkah.client.layout.combobox.ComboDestType
	 */
	private ComboDestType getRightJCombo_DestType() {
		if (RightJCombo_DestType == null) {
			RightJCombo_DestType = new ComboDestType() {
				public void onClick() {
					setCurrentTable(2,RightJCombo_DestType.getText());
				}
			};
//			RightJCombo_DestType.setBounds(184, 117, 106, 20);
		}
		return RightJCombo_DestType;
	}
}