package com.hkah.client.tx.admin.codetable;

import com.extjs.gxt.ui.client.widget.Component;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MaintenancePanel;
import com.hkah.shared.constants.ConstantsTx;

public class Alert extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.ALERT_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.ALERT_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Alert Code",
				"Alert Description",
				"Email Notification",
				"Print"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				80,
				140,
				100,
				100
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;
	private LabelBase LeftJLabel_AlertCode = null;
	private TextString LeftJText_AlertCode = null;
	private LabelBase LeftJLabel_AlertDescription = null;
	private TextString LeftJText_AlertDescription = null;

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_AlertCode = null;
	private LabelBase RightJTLabel_AlertDescription = null;
	private TextString RightJText_AlertDescription = null;
	private TextString RightJText_AlertCode = null;
	private LabelBase RightJLabel_Print = null;
	private LabelBase RightJLabel_EmailNotification = null;
	private CheckBoxBase RightJCheckBox_Print = null;
	private CheckBoxBase RightJCheckBox_EmailNotification = null;

	/**
	 * This method initializes
	 *
	 */
	public Alert() {
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
		getListTable().setColumnClass(2, new CheckBoxBase(), false);
		getListTable().setColumnClass(3, new CheckBoxBase(), false);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public Component getDefaultFocusComponent() {
		return getLeftJText_AlertCode();
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
		getRightJText_AlertCode().setEnabled(false);
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
				getLeftJText_AlertCode().getText(),
				getLeftJText_AlertDescription().getText()
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
		getRightJText_AlertCode().setText(outParam[index++]);
		getRightJText_AlertDescription().setText(outParam[index++]);
		getRightJCheckBox_EmailNotification().setText(outParam[index++]);
		getRightJCheckBox_Print().setText(outParam[index++]);
	}

	/* >>> ~21~ Set Add New Row toclearPostAction table ============================== <<< */
	@Override
	protected final void clearTableFields() {
		super.clearTableFields();
		setCurrentTable(2, "N");
		setCurrentTable(3, "N");
	}

	/* >>> ~22~ Set Action Input Parameters per table ===================== <<< */
	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		return new String[] {
				selectedContent[0],
				selectedContent[1],
				"Y".equals(selectedContent[2])?"-1":"0",
				"Y".equals(selectedContent[3])?"-1":"0"
		};
	}

	/* >>> ~23~ Set Action Validation per table =========================== <<< */
	@Override
	protected boolean actionValidation(String[] selectedContent) {
		// TODO Auto-generated method stub
		if (selectedContent[0]==null || selectedContent[0].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty Alert Code!");
			return false;
		} else if (selectedContent[1]==null || selectedContent[1].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty Alert Description!");
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
			LeftJLabel_AlertDescription = new LabelBase();
//			LeftJLabel_AlertDescription.setBounds(15, 60, 121, 20);
			LeftJLabel_AlertDescription.setText("Alert Description");
			LeftJLabel_AlertCode = new LabelBase();
//			LeftJLabel_AlertCode.setBounds(15, 15, 91, 31);
			LeftJLabel_AlertCode.setText("Alert Code");
			leftPanel = new ColumnLayout(2,2);
//			leftPanel.setSize(471, 130);
			leftPanel.add(0,0,LeftJLabel_AlertCode);
			leftPanel.add(1,0,getLeftJText_AlertCode());
			leftPanel.add(0,1,LeftJLabel_AlertDescription);
			leftPanel.add(1,1,getLeftJText_AlertDescription());
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
			RightJLabel_EmailNotification = new LabelBase();
//			RightJLabel_EmailNotification.setBounds(15, 165, 121, 20);
			RightJLabel_EmailNotification.setText("Email Notification");
			RightJLabel_Print = new LabelBase();
//			RightJLabel_Print.setBounds(15, 120, 121, 20);
			RightJLabel_Print.setText("Print");
			RightJTLabel_AlertDescription = new LabelBase();
//			RightJTLabel_AlertDescription.setBounds(15, 75, 121, 20);
			RightJTLabel_AlertDescription.setText("Alert Description");
			RightJLabel_AlertCode = new LabelBase();
//			RightJLabel_AlertCode.setBounds(15, 30, 121, 20);
			RightJLabel_AlertCode.setText("Alert Code");
			generalPanel = new ColumnLayout(6,2);
//			generalPanel.setLayout(null);
//			generalPanel.setBounds(0, 15, 601, 226);
			generalPanel.setHeading("Alert Information");
			generalPanel.add(0,0,RightJLabel_AlertCode);
			generalPanel.add(1,0,getRightJText_AlertCode());
			generalPanel.add(2,0,RightJLabel_Print);
			generalPanel.add(3,0,getRightJCheckBox_Print());
			generalPanel.add(4,0,RightJLabel_EmailNotification);
			generalPanel.add(5,0,getRightJCheckBox_EmailNotification());
			generalPanel.add(0,1,RightJTLabel_AlertDescription);
			generalPanel.add(1,1,getRightJText_AlertDescription());
		}
		return generalPanel;
	}

	/**
	 * This method initializes LeftJText_AlertCode
	 *
	 * @return javax.swing.JTextField
	 */
	private TextString getLeftJText_AlertCode() {
		if (LeftJText_AlertCode == null) {
			LeftJText_AlertCode = new TextString(5);
//			LeftJText_AlertCode.setBounds(150, 15, 136, 20);
		}
		return LeftJText_AlertCode;
	}

	/**
	 * This method initializes LeftJText_AlertDescription
	 *
	 * @return javax.swing.JTextField
	 */
	private TextString getLeftJText_AlertDescription() {
		if (LeftJText_AlertDescription == null) {
			LeftJText_AlertDescription = new TextString(100);
//			LeftJText_AlertDescription.setBounds(150, 60, 196, 20);
		}
		return LeftJText_AlertDescription;
	}

	/**
	 * This method initializes RightJText_AlertDescription
	 *
	 * @return javax.swing.JTextField
	 */
	private TextString getRightJText_AlertDescription() {
		if (RightJText_AlertDescription == null) {
			RightJText_AlertDescription = new TextString(100,getListTable(),1);
		}
		return RightJText_AlertDescription;
	}

	/**
	 * This method initializes RightJText_AlertCode
	 *
	 * @return javax.swing.JTextField
	 */
	private TextString getRightJText_AlertCode() {
		if (RightJText_AlertCode == null) {
			RightJText_AlertCode = new TextString(5,getListTable(),0);
//			RightJText_AlertCode.setBounds(150, 30, 166, 20);
		}
		return RightJText_AlertCode;
	}

	/**
	 * This method initializes RightJCheckBox_Print
	 *
	 * @return javax.swing.JCheckBox
	 */
	private CheckBoxBase getRightJCheckBox_Print() {
		if (RightJCheckBox_Print == null) {
			RightJCheckBox_Print = new CheckBoxBase(getListTable(),3);
		}
		return RightJCheckBox_Print;
	}

	/**
	 * This method initializes RightJCheckBox_EmailNotification
	 *
	 * @return javax.swing.JCheckBox
	 */
	private CheckBoxBase getRightJCheckBox_EmailNotification() {
		if (RightJCheckBox_EmailNotification == null) {
			RightJCheckBox_EmailNotification = new CheckBoxBase(getListTable(),2);
//			RightJCheckBox_EmailNotification.setBounds(150, 165, 31, 31);
		}
		return RightJCheckBox_EmailNotification;
	}
}