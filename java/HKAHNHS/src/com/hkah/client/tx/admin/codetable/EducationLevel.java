package com.hkah.client.tx.admin.codetable;

import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.combobox.ComboStatus;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MaintenancePanel;
import com.hkah.shared.constants.ConstantsTx;

public class EducationLevel extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.EDUCATIONLEVEL_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.EDUCATIONLEVEL_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"ID",
				"Education Description",
				"Status"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				0,
				200,
				100
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;  //  @jve:decl-index=0:visual-constraint="58,28"
	private LabelBase LeftJLabel_EducationLevel = null;
	private TextString LeftJText_EducationLevel = null;

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;  //  @jve:decl-index=0:visual-constraint="19,322"
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_EducationLevel = null;
	private TextString RightJText_EducationLevel = null;
	private LabelBase RightJLabel_Status = null;
	private ComboStatus RightJCombo_Status = null;

	private String id = null;  //  @jve:decl-index=0:

	/**
	 * This method initializes
	 *
	 */
	public EducationLevel() {
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
		getListTable().setColumnClass(2, new ComboStatus(), false);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return null;//getLeftJText_EducationLevel();
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
		//id = null;
	}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
		// enable/disable field
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
				getLeftJText_EducationLevel().getText()
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
		getRightJText_EducationLevel().setText(outParam[index++]);
		getRightJCombo_Status().setText(outParam[index++]);
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {}

	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		// TODO Auto-generated method stub
		return new String[] {
				selectedContent[0],
				selectedContent[1],
				selectedContent[2]
		};
	}

	@Override
	protected boolean actionValidation(String[] selectedContent) {
		// TODO Auto-generated method stub
		if (selectedContent[1].trim().length() == 0 || selectedContent[1]== null) {
			Factory.getInstance().addErrorMessage("Empty Education Level");
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
			LeftJLabel_EducationLevel = new LabelBase();
//			LeftJLabel_EducationLevel.setBounds(15, 30, 121, 20);
			LeftJLabel_EducationLevel.setText("Education Level");
			leftPanel = new ColumnLayout(2,1);
//			leftPanel.setSize(471,70);
			leftPanel.add(0,0,LeftJLabel_EducationLevel);
			leftPanel.add(1,0,getLeftJText_EducationLevel());
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
			generalPanel = new ColumnLayout(4,1);
			RightJLabel_Status = new LabelBase();
//			RightJLabel_Status.setBounds(30, 80, 121, 20);
			RightJLabel_Status.setText("Status");
			RightJLabel_EducationLevel = new LabelBase();
//			RightJLabel_EducationLevel.setBounds(30, 45, 121, 20);
			RightJLabel_EducationLevel.setText("Education Level");
//			generalPanel.setLayout(null);
//			generalPanel.setBounds(0, 15, 601, 129);
			generalPanel.setHeading("Education Information");
			generalPanel.add(0,0,RightJLabel_EducationLevel);
			generalPanel.add(1,0,getRightJText_EducationLevel());
			generalPanel.add(2,0,RightJLabel_Status);
			generalPanel.add(3,0,getRightJCombo_Status());
		}
		return generalPanel;
	}

	/**
	 * This method initializes LeftJText_EducationLevel
	 *
	 * @return javax.swing.TextString
	 */
	private TextString getLeftJText_EducationLevel() {
		if (LeftJText_EducationLevel == null) {
			LeftJText_EducationLevel = new TextString(25);
//			LeftJText_EducationLevel.setBounds(150, 30, 196, 20);
		}
		return LeftJText_EducationLevel;
	}

	/**
	 * This method initializes RightJText_EducationLevel
	 *
	 * @return javax.swing.TextString
	 */
	private TextString getRightJText_EducationLevel() {
		if (RightJText_EducationLevel == null) {
			RightJText_EducationLevel = new TextString(25,getListTable(), 1);
		}
		return RightJText_EducationLevel;
	}

	/**
	 * This method initializes RightJCombo_Status
	 *
	 * @return javax.swing.JComboBox
	 */
	private ComboStatus getRightJCombo_Status() {
		if (RightJCombo_Status == null) {
			RightJCombo_Status = new ComboStatus() {
				public void onClick() {
					setCurrentTable(2,RightJCombo_Status.getText());
				}
			};
//			RightJCombo_Status.setBounds(165, 80, 196, 20);
		}
		return RightJCombo_Status;
	}
}