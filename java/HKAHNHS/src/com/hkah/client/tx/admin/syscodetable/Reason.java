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
public class Reason extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.REASON_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.REASON_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Reason Code",
				"Reason Description"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				100,
				100
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;  //  @jve:decl-index=0:visual-constraint="19,144"
	private LabelBase LeftJLabel_ReasonCode = null;
	private TextString LeftJText_ReasonCode = null;
	private LabelBase LeftJLabel_ReasonDesc = null;
	private TextString LeftJText_ReasonDesc = null;
	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;  //  @jve:decl-index=0:visual-constraint="12,14"
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_ReasonCode = null;
	private TextString RightJText_ReasonCode = null;
	private LabelBase RightJLabel_ReasonDesc = null;
	private TextString RightJText_ReasonDesc = null;
	/**
	 * This method initializes
	 *
	 */
	public Reason() {
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
		return getLeftJText_ReasonCode();
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
		getRightJText_ReasonCode().setEnabled(false);
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
				getLeftJText_ReasonCode().getText(),
				getLeftJText_ReasonDesc().getText()
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
		getRightJText_ReasonCode().setText(outParam[index++]);
		getRightJText_ReasonDesc().setText(outParam[index++]);
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {
		if (getRightJText_ReasonCode().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Reason Code!", getRightJText_ReasonCode());
			actionValidationReady(actionType, false);
		} else if (getRightJText_ReasonDesc().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Reason Description!", getRightJText_ReasonDesc());
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
		if (selectedContent[0].trim().length()==0 || selectedContent==null) {
			Factory.getInstance().addErrorMessage("Empty Reason Code!");
			return false;
		} else if (selectedContent[1].trim().length()==0 || selectedContent==null) {
			Factory.getInstance().addErrorMessage("Empty Reason Description!");
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
			leftPanel.add(0,0,getLeftJLabel_ReasonCode());
			leftPanel.add(1,0,getLeftJText_ReasonCode());
			leftPanel.add(2,0,getLeftJLabel_ReasonDesc());
			leftPanel.add(3,0,getLeftJText_ReasonDesc());
	}
		return leftPanel;
	}

	/**
	 * This method initializes LeftJLabel_ReasonCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */


	private LabelBase getLeftJLabel_ReasonCode() {
		if (LeftJLabel_ReasonCode == null) {
			LeftJLabel_ReasonCode = new LabelBase();
			LeftJLabel_ReasonCode.setText("Reason Code :");
			LeftJLabel_ReasonCode.setOptionalLabel();
		}
		return LeftJLabel_ReasonCode;
	}

	/**
	 * This method initializes LeftJText_ReasonCode
	 *
	 * @return com.hkah.client.layout.textfield.TextReasonCode
	 */
	private TextString getLeftJText_ReasonCode() {
		if (LeftJText_ReasonCode == null) {
			LeftJText_ReasonCode = new TextString(10,false);

		}
		return LeftJText_ReasonCode;
	}
	/**
	 * This method initializes LeftJLabel_ReasonDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getLeftJLabel_ReasonDesc() {
		if (LeftJLabel_ReasonDesc == null) {
			LeftJLabel_ReasonDesc = new LabelBase();
			LeftJLabel_ReasonDesc.setText("Reason Description :");
			LeftJLabel_ReasonDesc.setOptionalLabel();
		}
		return LeftJLabel_ReasonDesc;
	}

	/**
	 * This method initializes LeftJText_ReasonDesc
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getLeftJText_ReasonDesc() {
		if (LeftJText_ReasonDesc == null) {
			LeftJText_ReasonDesc = new TextString(50,false);
		}
		return LeftJText_ReasonDesc;
	}

			//rightPanel.setSize(711, 121);


	/**
	 * This method initializes generalPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected ColumnLayout getActionPanel() {
		if (generalPanel == null) {
			generalPanel = new ColumnLayout(4,1);
			generalPanel.setHeading("Reason Information");
			generalPanel.add(0,0,getRightJLabel_ReasonCode());
			generalPanel.add(1,0,getRightJText_ReasonCode());
			generalPanel.add(2,0,getRightJLabel_ReasonDesc());
			generalPanel.add(3,0,getRightJText_ReasonDesc());
		}
		return generalPanel;
	}

	/**
	 * This method initializes RightJLabel_ReasonCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_ReasonCode() {
		if (RightJLabel_ReasonCode == null) {
			RightJLabel_ReasonCode = new LabelBase();
			RightJLabel_ReasonCode.setText("Reason Code");
		}
		return RightJLabel_ReasonCode;
	}

	/**
	 * This method initializes RightJText_ReasonCode
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_ReasonCode() {
		if (RightJText_ReasonCode == null) {
			RightJText_ReasonCode = new TextString(10,getListTable(), 0,false);
		}
		return RightJText_ReasonCode;
	}

	/**
	 * This method initializes RightJLabel_ReasonDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_ReasonDesc() {
		if (RightJLabel_ReasonDesc == null) {
			RightJLabel_ReasonDesc = new LabelBase();
			RightJLabel_ReasonDesc.setText("Reason Description");
		}
		return RightJLabel_ReasonDesc;
	}

	/**
	 * This method initializes RightJText_ReasonDesc
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_ReasonDesc() {
		if (RightJText_ReasonDesc == null) {
			RightJText_ReasonDesc = new TextString(50,getListTable(), 1,false);
		}
		return RightJText_ReasonDesc;
	}
}