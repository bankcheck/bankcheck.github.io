package com.hkah.client.tx.admin.codetable;

import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextNum;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MaintenancePanel;
import com.hkah.shared.constants.ConstantsTx;

public class MedicalChartLocation extends MaintenancePanel {


	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.MEDICALCHARTLOC_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.MEDICALCHARTLOC_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Location ID",
				"Location Description",
				""
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				100,
				200,
				0
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;  //  @jve:decl-index=0:visual-constraint="58,28"
	private LabelBase LeftJLabel_LocationID = null;
	private TextNum LeftJText_LocationID = null;
	private LabelBase LeftJLabel_LocationDescription = null;
	private TextString LeftJText_LocationDesc = null;

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;  //  @jve:decl-index=0:visual-constraint="19,322"
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_LocationID = null;
	private LabelBase RightJLabel_LocationDesc = null;
	private TextNum RightJText_LocationID = null;
	private TextString RightJText_LocationDesc = null;

	/**
	 * This method initializes
	 *
	 */
	public MedicalChartLocation() {
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

	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return null;//getLeftJText_LocationID();
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
		getRightJText_LocationID().setEnabled(false);
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
				getLeftJText_LocationID().getText(),
				getLeftJText_LocationDesc().getText()
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
		getRightJText_LocationID().setText(outParam[index++]);
		getRightJText_LocationDesc().setText(outParam[index++]);
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {}

	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		// TODO Auto-generated method stub
		return new String[] {
				selectedContent[0],
				selectedContent[1]
		};
	}

	@Override
	protected boolean actionValidation(String[] selectedContent) {
		// TODO Auto-generated method stub
		if (selectedContent[0].trim().length() == 0 || selectedContent[0]==null) {
			Factory.getInstance().addErrorMessage("Empty Location ID!");
			return false;
		} else if (selectedContent[1].trim().length() == 0||selectedContent[1]==null) {
			Factory.getInstance().addErrorMessage("Empty Location Description!");
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
			LeftJLabel_LocationDescription = new LabelBase();
//			LeftJLabel_LocationDescription.setBounds(15, 45, 136, 20);
			LeftJLabel_LocationDescription.setText("Location Description");
			LeftJLabel_LocationID = new LabelBase();
//			LeftJLabel_LocationID.setBounds(15, 15, 91,20);
			LeftJLabel_LocationID.setText("Location ID");
			leftPanel = new ColumnLayout(2,2);
//			leftPanel.setSize(471, 87);
			leftPanel.add(0,0,LeftJLabel_LocationID);
			leftPanel.add(1,0,getLeftJText_LocationID());
			leftPanel.add(0,1,LeftJLabel_LocationDescription);
			leftPanel.add(1,1,getLeftJText_LocationDesc());
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
			RightJLabel_LocationDesc = new LabelBase();
//			RightJLabel_LocationDesc.setBounds(15, 60, 136,20);
			RightJLabel_LocationDesc.setText("Location Description");
			RightJLabel_LocationID = new LabelBase();
//			RightJLabel_LocationID.setBounds(15, 30, 136,20);
			RightJLabel_LocationID.setText("Location ID");
//			generalPanel.setLayout(null);
//			generalPanel.setBounds(0, 0, 601, 106);
			generalPanel.setHeading("Location Information");
			generalPanel.add(0,0,RightJLabel_LocationID);
			generalPanel.add(1,0,getRightJText_LocationID());
			generalPanel.add(2,0,RightJLabel_LocationDesc);
			generalPanel.add(3,0,getRightJText_LocationDesc());
		}
		return generalPanel;
	}

	/**
	 * This method initializes LeftJText_LocationID
	 *
	 * @return javax.swing.TextString
	 */
	private TextNum getLeftJText_LocationID() {
		if (LeftJText_LocationID == null) {
			LeftJText_LocationID = new TextNum(22);
//			LeftJText_LocationID.setBounds(165, 15, 151,20);
		}
		return LeftJText_LocationID;
	}

	/**
	 * This method initializes LeftJText_LocationDesc
	 *
	 * @return javax.swing.TextString
	 */
	private TextString getLeftJText_LocationDesc() {
		if (LeftJText_LocationDesc == null) {
			LeftJText_LocationDesc = new TextString(20);
//			LeftJText_LocationDesc.setBounds(165, 45, 211,20);
		}
		return LeftJText_LocationDesc;
	}

	/**
	 * This method initializes RightJText_LocationID
	 *
	 * @return javax.swing.TextString
	 */
	private TextNum getRightJText_LocationID() {
		if (RightJText_LocationID == null) {
			RightJText_LocationID = new TextNum(22) {
				public void onReleased() {
					setCurrentTable(0,RightJText_LocationID.getText());
				}
			};
//			RightJText_LocationID.setBounds(165, 30, 181,20);
		}
		return RightJText_LocationID;
	}

	/**
	 * This method initializes RightJText_LocationDesc
	 *
	 * @return javax.swing.TextString
	 */
	private TextString getRightJText_LocationDesc() {
		if (RightJText_LocationDesc == null) {
			RightJText_LocationDesc = new TextString(20,getListTable(), 1);
		}
		return RightJText_LocationDesc;
	}
}