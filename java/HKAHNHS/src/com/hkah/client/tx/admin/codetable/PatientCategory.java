package com.hkah.client.tx.admin.codetable;

import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MaintenancePanel;
import com.hkah.shared.constants.ConstantsTx;

public class PatientCategory extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.PATIENTCATEGORY_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.PATIENTCATEGORY_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"ID",
				"Category",
				"Category Description",
				"With Reference Indicator",
				"Sepecial Commission For"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				0,
				80,
				140,
				140,
				140
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;  //  @jve:decl-index=0:visual-constraint="58,28"
	private LabelBase LeftJLabel_CategoryCode = null;
	private LabelBase LeftJLabel_CategoryDescription = null;
	private TextString LeftJText_CategoryCode = null;
	private TextString LeftJText_CategoryDescription = null;

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;  //  @jve:decl-index=0:visual-constraint="19,322"
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_CategoryCode = null;
	private LabelBase RightJLabel_CategoryDescription = null;
	private LabelBase RightJLabel_WithRefIndicator = null;
	private LabelBase RightJLabel_SpecialCommission = null;
	private TextString RightJText_CategoryCode = null;
	private TextString RightJText_CategoryDescription = null;
	private CheckBoxBase RightJCheckBox_WithRefIndicator = null;
	private CheckBoxBase RightJCheckBox_SpecialCommission = null;

	private String id = null;

	/**
	 * This method initializes
	 *
	 */
	public PatientCategory() {
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
		//setModifyButtonEnabled(true);
		//setDeleteButtonEnabled(false);
		//setConfirmButtonEnabled(false);

		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		//performList();
		getListTable().setColumnClass(3, new CheckBoxBase(), false);
		getListTable().setColumnClass(4, new CheckBoxBase(), false);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return getLeftJText_CategoryCode();
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
		getRightJText_CategoryCode().setEnabled(false);
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
				getLeftJText_CategoryCode().getText(),
				getLeftJText_CategoryDescription().getText()
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
		id = outParam[index++];
		getRightJText_CategoryCode().setText(outParam[index++]);
		getRightJText_CategoryDescription().setText(outParam[index++]);
		getRightJCheckBox_WithRefIndicator().setText(outParam[index++]);
		getRightJCheckBox_SpecialCommission().setText(outParam[index++]);
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {}

	@Override
	protected void clearTableFields() {
		super.clearTableFields();
		setCurrentTable(3, "N");
		setCurrentTable(4, "N");
	}

	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		// TODO Auto-generated method stub
		return new String[] {
				id,
				selectedContent[1],
				selectedContent[2],
				"Y".equals(selectedContent[3])?"-1":"0",
				"Y".equals(selectedContent[4])?"-1":"0"
		};
	}

	@Override
	protected boolean actionValidation(String[] selectedContent) {
		// TODO Auto-generated method stub
		if (selectedContent[1].trim().length() == 0 || selectedContent[1]==null) {
			Factory.getInstance().addErrorMessage("Empty Category Code!");
			return false;
		} else if (selectedContent[2].trim().length() == 0 || selectedContent[2]==null) {
			Factory.getInstance().addErrorMessage("Empty Category Description!");
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
			LeftJLabel_CategoryDescription = new LabelBase();
//			LeftJLabel_CategoryDescription.setBounds(15, 60, 136,20);
			LeftJLabel_CategoryDescription.setText("Category Description");
			LeftJLabel_CategoryCode = new LabelBase();
//			LeftJLabel_CategoryCode.setBounds(15, 15, 136,20);
			LeftJLabel_CategoryCode.setText("Category Code");
			leftPanel = new ColumnLayout(2,2);
//			leftPanel.setSize(471,130);
			leftPanel.add(0,0,LeftJLabel_CategoryCode);
			leftPanel.add(0,1,LeftJLabel_CategoryDescription);
			leftPanel.add(1,0,getLeftJText_CategoryCode());
			leftPanel.add(1,1,getLeftJText_CategoryDescription());
		}
		return leftPanel;
	}


	/**
	 * This method initializes generalPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected ColumnLayout getActionPanel() {
		if (generalPanel == null) {
			generalPanel = new ColumnLayout(4,2);
			RightJLabel_SpecialCommission = new LabelBase();
//			RightJLabel_SpecialCommission.setBounds(13, 132, 196, 20);
			RightJLabel_SpecialCommission.setText("Special Commission for Patient");
			RightJLabel_WithRefIndicator = new LabelBase();
//			RightJLabel_WithRefIndicator.setBounds(13, 96, 196, 20);
			RightJLabel_WithRefIndicator.setText("With Reference Indicator");
			RightJLabel_CategoryDescription = new LabelBase();
//			RightJLabel_CategoryDescription.setBounds(15, 61, 136, 20);
			RightJLabel_CategoryDescription.setText("Category Description");
			RightJLabel_CategoryCode = new LabelBase();
//			RightJLabel_CategoryCode.setBounds(15, 30, 136,20);
			RightJLabel_CategoryCode.setText("Category Code");
//			generalPanel.setLayout(null);
//			generalPanel.setBounds(0, 0, 601, 179);
			generalPanel.setHeading("Patient Category");
			generalPanel.add(0,0,RightJLabel_CategoryCode);
			generalPanel.add(2,0,RightJLabel_CategoryDescription);
			generalPanel.add(0,1,RightJLabel_WithRefIndicator);
			generalPanel.add(2,1,RightJLabel_SpecialCommission);
			generalPanel.add(1,0,getRightJText_CategoryCode());
			generalPanel.add(3,0,getRightJText_CategoryDescription());
			generalPanel.add(1,1,getRightJCheckBox_WithRefIndicator());
			generalPanel.add(3,1,getRightJCheckBox_SpecialCommission());
		}
		return generalPanel;
	}

	/**
	 * This method initializes LeftJText_CategoryCode
	 *
	 * @return javax.swing.TextString
	 */
	private TextString getLeftJText_CategoryCode() {
		if (LeftJText_CategoryCode == null) {
			LeftJText_CategoryCode = new TextString(2);
//			LeftJText_CategoryCode.setBounds(165, 15, 136,20);
		}
		return LeftJText_CategoryCode;
	}

	/**
	 * This method initializes LeftJText_CategoryDescription
	 *
	 * @return javax.swing.TextString
	 */
	private TextString getLeftJText_CategoryDescription() {
		if (LeftJText_CategoryDescription == null) {
			LeftJText_CategoryDescription = new TextString(40);
//			LeftJText_CategoryDescription.setBounds(165, 60, 211,20);
		}
		return LeftJText_CategoryDescription;
	}

	/**
	 * This method initializes RightJText_CategoryCode
	 *
	 * @return javax.swing.TextString
	 */
	private TextString getRightJText_CategoryCode() {
		if (RightJText_CategoryCode == null) {
			RightJText_CategoryCode = new TextString(2,getListTable(), 1);
		}
		return RightJText_CategoryCode;
	}

	/**
	 * This method initializes RightJText_CategoryDescription
	 *
	 * @return javax.swing.TextString
	 */
	private TextString getRightJText_CategoryDescription() {
		if (RightJText_CategoryDescription == null) {
			RightJText_CategoryDescription = new TextString(40,getListTable(), 2);
		}
		return RightJText_CategoryDescription;
	}

	/**
	 * This method initializes RightJCheckBox_WithRefIndicator
	 *
	 * @return javax.swing.JCheckBox
	 */
	private CheckBoxBase getRightJCheckBox_WithRefIndicator() {
		if (RightJCheckBox_WithRefIndicator == null) {
			RightJCheckBox_WithRefIndicator = new CheckBoxBase() {
				public void onClick() {
					if (RightJCheckBox_WithRefIndicator.isSelected()) {
						setCurrentTable(3,"Y");
					} else {
						setCurrentTable(3,"N");
					}
				}
			};
//			RightJCheckBox_WithRefIndicator.setBounds(226, 90, 31, 31);
		}
		return RightJCheckBox_WithRefIndicator;
	}

	/**
	 * This method initializes RightJCheckBox_SpecialCommission
	 *
	 * @return javax.swing.JCheckBox
	 */
	private CheckBoxBase getRightJCheckBox_SpecialCommission() {
		if (RightJCheckBox_SpecialCommission == null) {
			RightJCheckBox_SpecialCommission = new CheckBoxBase(getListTable(),4);
		}
		return RightJCheckBox_SpecialCommission;
	}
}