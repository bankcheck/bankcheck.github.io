/*
 * Created on July 23, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.tx.admin.codetable;

import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MaintenancePanel;
import com.hkah.shared.constants.ConstantsTx;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class Bed extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.BED_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.BED_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Bed Code",
				"Official",
				"Bed Description",
				"Room Code",
				"Room Sex",
				"Bedddate",
				"BedRemark",
				"Beddrdate",
				"Site Code",    //site code
				"Phone Extension"

		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				80,
				50,
				100,
				80,
				0,
				0,
				0,
				0,
				0,
				50
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel1 = null;  //  @jve:decl-index=0:visual-constraint="29,32"
	private LabelBase LeftJLabel_BedCode = null;
	private TextString LeftJText_BedCode = null;
	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private ColumnLayout rightPanel = null;
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_BedCode = null;
	private TextString RightJText_BedCode = null;
	private LabelBase RightJLabel_BedDesc = null;
	private TextString RightJText_BedDesc = null;

	private LabelBase RightJLabel_PhoneExt = null;
	private LabelBase RightJLabel_RoomCode = null;
	private LabelBase RightJLabel_Official = null;
	private TextString RightJText_PhoneExt = null;
	private CheckBoxBase RightJCheckBox_Official = null;
	private TextString RightJText_RoomCode = null;
	/**
	 * This method initializes
	 *
	 */
	public Bed() {
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
		getListTable().setColumnClass(1, new CheckBoxBase(), false);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return getLeftJText_BedCode();
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
		getRightJText_BedCode().setEnabled(false);
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
				getLeftJText_BedCode().getText()
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
		getRightJText_BedCode().setText(outParam[index++]);
		getRightJCheckBox_Official().setText(outParam[index++]);
		getRightJText_BedDesc().setText(outParam[index++]);
		getRightJText_RoomCode().setText(outParam[index++]);
        index++;
		index++;
		index++;
		index++;
		index++;
		getRightJText_PhoneExt().setText(outParam[index++]);
		if (getParameter("From")!=null&&"Pat".equals(getParameter("From"))) {
			setParameter("From","");
			setParameter("BedCode", getRightJText_BedCode().getText());
			exitPanel();
		}
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {
//		else if (getRightJText_RefundRoomCode().isEmpty()) {
//		Factory.getInstance().addErrorMessage("Empty Refund Room Code!", getRightJText_RefundRoomCode());
	}

	/* >>> ~22~ Set Action Input Parameters per table ===================== <<< */
	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		// TODO Auto-generated method stub
		String[] param=new String[] {
			selectedContent[0],
			"Y".equals(selectedContent[1])?"-1":"0",
			selectedContent[2],
			selectedContent[3],
			selectedContent[9]
		};
		return param;
	}

	/* >>> ~23~ Set Action Validation per table =========================== <<< */
	@Override
	protected boolean actionValidation(String[] selectedContent) {
		// TODO Auto-generated method stub
		if (selectedContent[0].trim().length() == 0 || selectedContent[0]==null) {
			Factory.getInstance().addErrorMessage("Empty Bed Code!");
			return false;
		} else if (selectedContent[3].trim().length() == 0 || selectedContent[3]==null) {
			Factory.getInstance().addErrorMessage("Empty Room Code!");
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
		if (leftPanel1 == null) {
			leftPanel1 = new ColumnLayout(2,1);
//			leftPanel1.setSize(300, 50);
			leftPanel1.add(0,0,getLeftJLabel_BedCode());
			leftPanel1.add(1,0,getLeftJText_BedCode());
		}
		return leftPanel1;
	}

	/**
	 * This method initializes LeftJLabel_BedCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */


	private LabelBase getLeftJLabel_BedCode() {
		if (LeftJLabel_BedCode == null) {
			LeftJLabel_BedCode = new LabelBase();
//			LeftJLabel_BedCode.setBounds(14, 15, 102, 20);
			LeftJLabel_BedCode.setText("Bed Code:");
			LeftJLabel_BedCode.setOptionalLabel();
		}
		return LeftJLabel_BedCode;
	}

	/**
	 * This method initializes LeftJText_BedCode
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getLeftJText_BedCode() {
		if (LeftJText_BedCode == null) {
			LeftJText_BedCode = new TextString(5,true);
//			LeftJText_BedCode.setBounds(133, 15, 164, 20);
		}
		return LeftJText_BedCode;
	}

	/**
	 * This method initializes rightPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
//
//
//			// create tabbed panel
//
//			rightPanel.setSize(925,200);
//
//		}
//
//	}

	/**
	 * This method initializes generalPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected ColumnLayout getActionPanel() {
		if (generalPanel == null) {
			generalPanel = new ColumnLayout(4,3);
			////generalPanel.setBounds(4, 0, 648, 460);
			generalPanel.setHeading("Bed Information");
			generalPanel.add(0,0,getRightJLabel_BedCode());
			generalPanel.add(1,0,getRightJText_BedCode());
			generalPanel.add(2,0,getRightJLabel_Official());
			generalPanel.add(3,0,getRightJCheckBox_Official());
			generalPanel.add(0,1,getRightJLabel_RoomCode());
			generalPanel.add(1,1,getRightJText_RoomCode());
			generalPanel.add(2,1,getRightJLabel_BedDesc());
			generalPanel.add(3,1,getRightJText_BedDesc());
			generalPanel.add(0,2,getRightJLabel_PhoneExt());
			generalPanel.add(1,2,getRightJText_PhoneExt());

		}
		return generalPanel;
	}

	/**
	 * This method initializes RightJLabel_BedCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_BedCode() {
		if (RightJLabel_BedCode == null) {
			RightJLabel_BedCode = new LabelBase();
			RightJLabel_BedCode.setText("Bed Code");
//			RightJLabel_BedCode.setBounds(32, 27, 82, 20);
		}
		return RightJLabel_BedCode;
	}

	/**
	 * This method initializes RightJText_BedCode
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_BedCode() {
		if (RightJText_BedCode == null) {
			RightJText_BedCode = new TextString(4,getListTable(), 0);

		}
		return RightJText_BedCode;
	}

	/**
	 * This method initializes RightJLabel_BedDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_BedDesc() {
		if (RightJLabel_BedDesc == null) {
			RightJLabel_BedDesc = new LabelBase();
			RightJLabel_BedDesc.setText("Bed Desc.");
//			RightJLabel_BedDesc.setBounds(306, 60, 74, 20);
		}
		return RightJLabel_BedDesc;
	}

	/**
	 * This method initializes RightJText_BedDesc
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_BedDesc() {
		if (RightJText_BedDesc == null) {
			RightJText_BedDesc = new TextString(50,getListTable(), 2);

		}
		return RightJText_BedDesc;
	}
	/**
	 * This method initializes RightJLabel_PhoneExt
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_PhoneExt() {
		if (RightJLabel_PhoneExt == null) {
			RightJLabel_PhoneExt = new LabelBase();
			RightJLabel_PhoneExt.setText("Phone Extension");
//			RightJLabel_PhoneExt.setBounds(32,90, 108, 20);
		}
		return RightJLabel_PhoneExt;
	}
	/**
	 * This method initializes RightJLabel_RoomCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_RoomCode() {
		if (RightJLabel_RoomCode == null) {
			RightJLabel_RoomCode = new LabelBase();
			RightJLabel_RoomCode.setText("Room Code");
//			RightJLabel_RoomCode.setBounds(32,60, 88, 20);
		}
		return RightJLabel_RoomCode;
	}
	/**
	 * This method initializes RightJLabel_Official
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_Official() {
		if (RightJLabel_Official == null) {
			RightJLabel_Official = new LabelBase();
			RightJLabel_Official.setText("Official");
//			RightJLabel_Official.setBounds(306, 27, 61, 20);
		}
		return RightJLabel_Official;
	}

	/**
	 * This method initializes RightJText_PhoneExt
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_PhoneExt() {
		if (RightJText_PhoneExt == null) {
			RightJText_PhoneExt =new TextString(8,getListTable(), 9);

		}
		return RightJText_PhoneExt;
	}

	/**
	 * This method initializes RightJCheckBox_Official
	 *
	 * @return com.hkah.client.layout.checkbox.CheckBoxBase
	 */
	private CheckBoxBase getRightJCheckBox_Official() {
		if (RightJCheckBox_Official == null) {
			RightJCheckBox_Official = new CheckBoxBase(getListTable(),1);
//			RightJCheckBox_Official.setBounds(415, 27, 22, 23);
		}
		return RightJCheckBox_Official;
	}

	/**
	 * This method initializes RightJText_RoomCode
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_RoomCode() {
		if (RightJText_RoomCode == null) {
			RightJText_RoomCode = new TextString(3,true) {
				public void onReleased() {
					setCurrentTable(3,RightJText_RoomCode.getText());
				}
			};
//			RightJText_RoomCode.setBounds(158,60, 118, 20);
		}
		return RightJText_RoomCode;
	}
}