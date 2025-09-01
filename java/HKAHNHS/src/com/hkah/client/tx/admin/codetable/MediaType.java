package com.hkah.client.tx.admin.codetable;


import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextNum;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MaintenancePanel;
import com.hkah.shared.constants.ConstantsTx;

public class MediaType extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.MEDIATYPE_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.MEDIATYPE_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Media ID",
				"Media Type Description",
				"Auto Add"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				100,
				200,
				100
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;  //  @jve:decl-index=0:visual-constraint="58,28"
	private LabelBase LeftJLabel_MediaID = null;
	private TextNum LeftJText_MediaID = null;

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;  //  @jve:decl-index=0:visual-constraint="19,322"
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_MediaID = null;
	private TextNum RightJText_MediaID = null;
	private LabelBase RightJLabel_MediaTypeDesc = null;
	private TextString RightJText_MediaTypeDesc = null;
	private LabelBase RightJLabel_AutoAdd = null;
	private CheckBoxBase RightJCheckBox_AutoAdd = null;


	/**
	 * This method initializes
	 *
	 */
	public MediaType() {
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
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return null;//getLeftJText_MediaID();
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
		getRightJText_MediaID().setEnabled(false);
	}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
		// enable/disable field
		getRightJText_MediaID().setEnabled(false);
		getRightJText_MediaTypeDesc().setEnabled(false);
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
				getLeftJText_MediaID().getText()
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
		getRightJText_MediaID().setText(outParam[index++]);
		getRightJText_MediaTypeDesc().setText(outParam[index++]);
		getRightJCheckBox_AutoAdd().setText(outParam[index++]);
	}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return new String[] {
//				getRightJText_MediaID().getText(),
				getRightJText_MediaTypeDesc().getText(),
				getRightJCheckBox_AutoAdd().isSelected()?"-1":""
			};
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {}

	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		// TODO Auto-generated method stub
		return new String[] {
				selectedContent[1],
				"Y".equals(selectedContent[2])?"-1":"0"
		};
	}

	@Override
	protected boolean actionValidation(String[] selectedContent) {
		// TODO Auto-generated method stub
		if (selectedContent[1].trim().length() == 0|| selectedContent[1]==null) {
			Factory.getInstance().addErrorMessage("Empty Media Type Description!");
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
			LeftJLabel_MediaID = new LabelBase();
//			LeftJLabel_MediaID.setBounds(15, 15, 76, 20);
			LeftJLabel_MediaID.setText("Media ID");
			leftPanel = new ColumnLayout(2,1);
//			leftPanel.setSize(471, 100);
			leftPanel.add(0,0,LeftJLabel_MediaID);
			leftPanel.add(1,0,getLeftJText_MediaID());
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
			RightJLabel_AutoAdd = new LabelBase();
//			RightJLabel_AutoAdd.setBounds(15, 120, 76, 20);
			RightJLabel_AutoAdd.setText("Auto Add");
			RightJLabel_MediaTypeDesc = new LabelBase();
//			RightJLabel_MediaTypeDesc.setBounds(15, 75, 151, 20);
			RightJLabel_MediaTypeDesc.setText("Media Type Description");
			RightJLabel_MediaID = new LabelBase();
//			RightJLabel_MediaID.setBounds(15, 30, 76, 20);
			RightJLabel_MediaID.setText("Media ID");
			//generalPanel.setBounds(0, 0, 601, 181);
			generalPanel.setHeading("Media Tyoe Information");
			generalPanel.add(0,0,RightJLabel_MediaID);
			generalPanel.add(1,0,getRightJText_MediaID());
			generalPanel.add(2,0,RightJLabel_MediaTypeDesc);
			generalPanel.add(3,0,getRightJText_MediaTypeDesc());
			generalPanel.add(0,1,RightJLabel_AutoAdd);
			generalPanel.add(1,1,getRightJCheckBox_AutoAdd());
		}
		return generalPanel;
	}

	/**
	 * This method initializes LeftJText_MediaID
	 *
	 * @return javax.swing.TextString
	 */
	private TextNum getLeftJText_MediaID() {
		if (LeftJText_MediaID == null) {
			LeftJText_MediaID = new TextNum(22);
//			LeftJText_MediaID.setBounds(105, 15, 136, 20);
		}
		return LeftJText_MediaID;
	}

	/**
	 * This method initializes RightJText_MediaID
	 *
	 * @return javax.swing.TextString
	 */
	private TextNum getRightJText_MediaID() {
		if (RightJText_MediaID == null) {
			RightJText_MediaID = new TextNum(22);
//			RightJText_MediaID.setBounds(180, 30, 121,20);
		}
		return RightJText_MediaID;
	}
	/**
	 * This method initializes RightJText_MediaTypeDesc
	 *
	 * @return javax.swing.TextString
	 */
	private TextString getRightJText_MediaTypeDesc() {
		if (RightJText_MediaTypeDesc == null) {
			RightJText_MediaTypeDesc = new TextString(10,getListTable(), 1);
		}
		return RightJText_MediaTypeDesc;
	}

	/**
	 * This method initializes RightJCheckBox_AutoAdd
	 *
	 * @return javax.swing.JCheckBox
	 */
	private CheckBoxBase getRightJCheckBox_AutoAdd() {
		if (RightJCheckBox_AutoAdd == null) {
			RightJCheckBox_AutoAdd = new CheckBoxBase(getListTable(),2);
//			RightJCheckBox_AutoAdd.setBounds(180, 120, 31,20);
		}
		return RightJCheckBox_AutoAdd;
	}
}