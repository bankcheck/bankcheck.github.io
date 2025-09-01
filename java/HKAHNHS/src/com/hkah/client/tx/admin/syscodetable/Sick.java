/*
 * Created on July 23, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.tx.admin.syscodetable;

import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
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
public class Sick extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.SICK_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.SICK_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Sick Code",
				"Sick Description"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				100,
				150
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;  //  @jve:decl-index=0:visual-constraint="9,154"
	private LabelBase LeftJLabel_SickCode = null;
	private TextString LeftJText_SickCode = null;
	private LabelBase LeftJLabel_SickDesc = null;
	private TextString LeftJText_SickDesc = null;
	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;  //  @jve:decl-index=0:visual-constraint="12,14"
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_SickCode = null;
	private TextString RightJText_SickCode = null;
	private LabelBase RightJLabel_SickDesc = null;
	private TextString RightJText_SickDesc = null;
	/**
	 * This method initializes
	 *
	 */
	public Sick() {
		//super(MasterPanel.FLAT_LAYOUT);
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
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return getLeftJText_SickCode();
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
		getRightJText_SickCode().setEnabled(false);
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
				getLeftJText_SickCode().getText(),
				getLeftJText_SickDesc().getText()
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
		getRightJText_SickCode().setText(outParam[index++]);
		getRightJText_SickDesc().setText(outParam[index++]);
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {
		if (getRightJText_SickCode().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Sick Code!", getRightJText_SickCode());
			actionValidationReady(actionType, false);
		} else if (getRightJText_SickDesc().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Sick Description!", getRightJText_SickDesc());
			actionValidationReady(actionType, false);
		} else {
			actionValidationReady(actionType, true);
		}
	}

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
		if (selectedContent[0].trim().length()==0 || selectedContent[0]==null) {
			Factory.getInstance().addErrorMessage("Empty Sick Code!");
			return false;
		} else if (selectedContent[1].trim().length()==0 || selectedContent[1]==null) {
			Factory.getInstance().addErrorMessage("Empty Sick Description!");
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
//			leftPanel.setSize(495, 110);
			leftPanel.add(0,0,getLeftJLabel_SickCode());
			leftPanel.add(1,0,getLeftJText_SickCode());
			leftPanel.add(2,0,getLeftJLabel_SickDesc());
			leftPanel.add(3,0,getLeftJText_SickDesc());
	}
		return leftPanel;
	}

	/**
	 * This method initializes LeftJLabel_SickCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */


	private LabelBase getLeftJLabel_SickCode() {
		if (LeftJLabel_SickCode == null) {
			LeftJLabel_SickCode = new LabelBase();
			LeftJLabel_SickCode.setText("Sick Code :");
			LeftJLabel_SickCode.setOptionalLabel();
		}
		return LeftJLabel_SickCode;
	}

	/**
	 * This method initializes LeftJText_SickCode
	 *
	 * @return com.hkah.client.layout.textfield.TextSickCode
	 */
	private TextString getLeftJText_SickCode() {
		if (LeftJText_SickCode == null) {
			LeftJText_SickCode = new TextString(10,false);

		}
		return LeftJText_SickCode;
	}
	/**
	 * This method initializes LeftJLabel_SickDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getLeftJLabel_SickDesc() {
		if (LeftJLabel_SickDesc == null) {
			LeftJLabel_SickDesc = new LabelBase();
			LeftJLabel_SickDesc.setText("Sick Description :");
			LeftJLabel_SickDesc.setOptionalLabel();
		}
		return LeftJLabel_SickDesc;
	}

	/**
	 * This method initializes LeftJText_SickDesc
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getLeftJText_SickDesc() {
		if (LeftJText_SickDesc == null) {
			LeftJText_SickDesc = new TextString(40,false);
		}
		return LeftJText_SickDesc;
	}

			//rightPanel.setSize(658, 117);

	/**
	 * This method initializes generalPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected ColumnLayout getActionPanel() {
		if (generalPanel == null) {
			generalPanel = new ColumnLayout(4,1);
			generalPanel.setHeading("Sick Information");
			generalPanel.add(0,0,getRightJLabel_SickCode());
			generalPanel.add(1,0,getRightJText_SickCode());
			generalPanel.add(2,0,getRightJLabel_SickDesc());
			generalPanel.add(3,0,getRightJText_SickDesc());



		}
		return generalPanel;
	}

	/**
	 * This method initializes RightJLabel_SickCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_SickCode() {
		if (RightJLabel_SickCode == null) {
			RightJLabel_SickCode = new LabelBase();
			RightJLabel_SickCode.setText("Sick Code");
		}
		return RightJLabel_SickCode;
	}

	/**
	 * This method initializes RightJText_SickCode
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_SickCode() {
		if (RightJText_SickCode == null) {
			RightJText_SickCode = new TextString(10,getListTable(),0,false);
		}
		return RightJText_SickCode;
	}

	/**
	 * This method initializes RightJLabel_SickDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_SickDesc() {
		if (RightJLabel_SickDesc == null) {
			RightJLabel_SickDesc = new LabelBase();
			RightJLabel_SickDesc.setText("Sick Description");
		}
		return RightJLabel_SickDesc;
	}

	/**
	 * This method initializes RightJText_SickDesc
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_SickDesc() {
		if (RightJText_SickDesc == null) {
			RightJText_SickDesc = new TextString(400,getListTable(),1,false);
		}
		return RightJText_SickDesc;
	}
}