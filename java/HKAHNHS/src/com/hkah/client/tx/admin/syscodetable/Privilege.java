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
public class Privilege extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.PRIVILEGE_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.PRIVILEGE_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Privilege Code",
				"Privilege Name"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				50,
				150
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;  //  @jve:decl-index=0:visual-constraint="29,32"
	private LabelBase LeftJLabel_PrivilegeCode = null;
	private TextString LeftJText_PrivilegeCode = null;
	private LabelBase LeftJLabel_PrivilegeName = null;
	private TextString LeftJText_PrivilegeName = null;
	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;  //  @jve:decl-index=0:visual-constraint="10,142"
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_PrivilegeCode = null;
	private TextString RightJText_PrivilegeCode = null;
	private LabelBase RightJLabel_PrivilegeName = null;
	private TextString RightJText_PrivilegeName = null;
	/**
	 * This method initializes
	 *
	 */
	public Privilege() {
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
		return getLeftJText_PrivilegeCode();
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
		getRightJText_PrivilegeCode().setEnabled(false);
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
				getLeftJText_PrivilegeCode().getText(),
				getLeftJText_PrivilegeName().getText()
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
		getRightJText_PrivilegeCode().setText(outParam[index++]);                          // ROLNAM
		getRightJText_PrivilegeName().setText(outParam[index++]);                       // ROLDESC
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {
		if (getRightJText_PrivilegeCode().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Privilege Code!", getRightJText_PrivilegeCode());
			actionValidationReady(actionType, false);
		} else if (getRightJText_PrivilegeName().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Privilege Name!", getRightJText_PrivilegeName());
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
			Factory.getInstance().addErrorMessage("Empty Privilege Code!");
			return false;
		} else if (selectedContent[1].trim().length()==0 || selectedContent[1]==null) {
			Factory.getInstance().addErrorMessage("Empty Privilege Name!");
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
			leftPanel.setSize(399, 100);
			leftPanel.add(0,0,getLeftJLabel_PrivilegeCode());
			leftPanel.add(1,0,getLeftJText_PrivilegeCode());
			leftPanel.add(2,0,getLeftJLabel_PrivilegeName());
			leftPanel.add(3,0,getLeftJText_PrivilegeName());
		}
		return leftPanel;
	}

	/**
	 * This method initializes LeftJLabel_PrivilegeCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */


	private LabelBase getLeftJLabel_PrivilegeCode() {
		if (LeftJLabel_PrivilegeCode == null) {
			LeftJLabel_PrivilegeCode = new LabelBase();
			LeftJLabel_PrivilegeCode.setText("Privilege Code:");
			LeftJLabel_PrivilegeCode.setOptionalLabel();
		}
		return LeftJLabel_PrivilegeCode;
	}

	/**
	 * This method initializes LeftJText_PrivilegeCode
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getLeftJText_PrivilegeCode() {
		if (LeftJText_PrivilegeCode == null) {
			LeftJText_PrivilegeCode = new TextString(2,true);
		}
		return LeftJText_PrivilegeCode;
	}

	/**
	 * This method initializes LeftJLabel_PrivilegeName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getLeftJLabel_PrivilegeName() {
		if (LeftJLabel_PrivilegeName == null) {
			LeftJLabel_PrivilegeName = new LabelBase();
			LeftJLabel_PrivilegeName.setText("Privilege Name:");
			LeftJLabel_PrivilegeName.setOptionalLabel();
		}
		return LeftJLabel_PrivilegeName;
	}

	/**
	 * This method initializes LeftJText_PrivilegeName
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getLeftJText_PrivilegeName() {
		if (LeftJText_PrivilegeName == null) {
			LeftJText_PrivilegeName = new TextString(20,true);
		}
		return LeftJText_PrivilegeName;
	}


			//rightPanel.setSize(544, 121);

	/**
	 * This method initializes generalPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected ColumnLayout getActionPanel() {
		if (generalPanel == null) {
			generalPanel = new ColumnLayout(4,1);
			generalPanel.setHeading("Privilege Information");
			generalPanel.add(0,0,getRightJLabel_PrivilegeCode());
			generalPanel.add(1,0,getRightJText_PrivilegeCode());
			generalPanel.add(2,0,getRightJLabel_PrivilegeName());
			generalPanel.add(3,0,getRightJText_PrivilegeName());
		}
		return generalPanel;
	}

	/**
	 * This method initializes RightJLabel_PrivilegeCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_PrivilegeCode() {
		if (RightJLabel_PrivilegeCode == null) {
			RightJLabel_PrivilegeCode = new LabelBase();
			RightJLabel_PrivilegeCode.setText("Privilege Code");
		}
		return RightJLabel_PrivilegeCode;
	}

	/**
	 * This method initializes RightJText_PrivilegeCode
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_PrivilegeCode() {
		if (RightJText_PrivilegeCode == null) {
			RightJText_PrivilegeCode = new TextString(2,getListTable(),0,true);
		}
		return RightJText_PrivilegeCode;
	}

	/**
	 * This method initializes RightJLabel_PrivilegeName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_PrivilegeName() {
		if (RightJLabel_PrivilegeName == null) {
			RightJLabel_PrivilegeName = new LabelBase();
			RightJLabel_PrivilegeName.setText("Privilege Name");
		}
		return RightJLabel_PrivilegeName;
	}

	/**
	 * This method initializes RightJText_PrivilegeName
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_PrivilegeName() {
		if (RightJText_PrivilegeName == null) {
			RightJText_PrivilegeName = new TextString(20,getListTable(), 1,true);
		}
		return RightJText_PrivilegeName;
	}
}