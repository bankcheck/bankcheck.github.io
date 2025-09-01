/*
 * Created on July 23, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.tx.admin.security;

import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextDesc;
import com.hkah.client.layout.textfield.TextName;
import com.hkah.client.tx.MaintenancePanel;
import com.hkah.shared.constants.ConstantsTx;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class Role extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.ROLE_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.ROLE_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Role Name",              // ROLNAM
				"Description"             // ROLDESC
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				80,                     // ROLNAM
				150                     // ROLDESC
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;  //  @jve:decl-index=0:visual-constraint="29,32"
	private LabelBase LeftJLabel_RoleName = null;
	private TextName LeftJText_RoleName = null;
	private LabelBase LeftJLabel_Description = null;
	private TextDesc LeftJText_Description = null;
	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;  //  @jve:decl-index=0:visual-constraint="27,141"
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_RoleName = null;
	private TextName RightJText_RoleName = null;
	private LabelBase RightJLabel_Description = null;
	private TextDesc RightJText_Description = null;

	/**
	 * This method initializes
	 *
	 */
	public Role() {
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
		return getLeftJText_RoleName();
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
		getRightJText_RoleName().setEnabled(false);
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
				getLeftJText_RoleName().getText(),
				getLeftJText_Description().getText()
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
		getRightJText_RoleName().setText(outParam[index++]);                          // ROLNAM
		getRightJText_Description().setText(outParam[index++]);                       // ROLDESC
		}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {
		if (getRightJText_RoleName().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Role Name!", getRightJText_RoleName());
			actionValidationReady(actionType, false);
		} else if (getRightJText_Description().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Description!", getRightJText_Description());
			actionValidationReady(actionType, false);
		} else {
			actionValidationReady(actionType, true);
		}
	}

	/* >>> ~22~ Set Action Input Parameters per table ===================== <<< */
	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		return new String[] {
				selectedContent[0],
				selectedContent[1]
		};
	}

	/* >>> ~23~ Set Action Validation per table =========================== <<< */
	@Override
	protected boolean actionValidation(String[] selectedContent) {
		// TODO Auto-generated method stub
		if (selectedContent[0].trim().length()==0 || selectedContent[0]==null) {
			Factory.getInstance().addErrorMessage("Empty Role Name!");
			return false;
		} else if (selectedContent[1].trim().length()==0 || selectedContent[1]==null) {
			Factory.getInstance().addErrorMessage("Empty Description!");
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
			leftPanel = new ColumnLayout(2,2);
			leftPanel.setSize(445, 85);
			leftPanel.add(0, 0, getLeftJLabel_RoleName());
			leftPanel.add(1, 0, getLeftJText_RoleName());
			leftPanel.add(0, 1, getLeftJLabel_Description());
			leftPanel.add(1, 1, getLeftJText_Description());
		}
		return leftPanel;
	}

	/**
	 * This method initializes LeftJLabel_RoleName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */


	private LabelBase getLeftJLabel_RoleName() {
		if (LeftJLabel_RoleName == null) {
			LeftJLabel_RoleName = new LabelBase();
			LeftJLabel_RoleName.setText("Role Name");
			LeftJLabel_RoleName.setOptionalLabel();
		}
		return LeftJLabel_RoleName;
	}

	/**
	 * This method initializes LeftJText_RoleName
	 *
	 * @return com.hkah.client.layout.textfield.TextRoleName
	 */
	private TextName getLeftJText_RoleName() {
		if (LeftJText_RoleName == null) {
			LeftJText_RoleName = new TextName();
		}
		return LeftJText_RoleName;
	}

	/**
	 * This method initializes LeftJLabel_Description
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getLeftJLabel_Description() {
		if (LeftJLabel_Description == null) {
			LeftJLabel_Description = new LabelBase();
			LeftJLabel_Description.setText("Description");
			LeftJLabel_Description.setOptionalLabel();
		}
		return LeftJLabel_Description;
	}

	/**
	 * This method initializes LeftJText_Description
	 *
	 * @return com.hkah.client.layout.textfield.TextBase
	 */
	private TextBase getLeftJText_Description() {
		if (LeftJText_Description == null) {
			LeftJText_Description = new TextDesc();
		}
		return LeftJText_Description;
	}

	/**
	 * This method initializes generalPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected ColumnLayout getActionPanel() {
		if (generalPanel == null) {
			generalPanel = new ColumnLayout(2,2);
			generalPanel.setHeading("Role Information");
			generalPanel.setSize(445, 85);
			generalPanel.add(0, 0, getRightJLabel_RoleName());
			generalPanel.add(1, 0, getRightJText_RoleName());
			generalPanel.add(0, 1, getRightJLabel_Description());
			generalPanel.add(1, 1, getRightJText_Description());
		}
		return generalPanel;
	}

	/**
	 * This method initializes RightJLabel_RoleName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_RoleName() {
		if (RightJLabel_RoleName == null) {
			RightJLabel_RoleName = new LabelBase();
			RightJLabel_RoleName.setText("Role Name");
		}
		return RightJLabel_RoleName;
	}

	/**
	 * This method initializes RightJText_RoleName
	 *
	 * @return com.hkah.client.layout.textfield.TextRoleName
	 */
	private TextName getRightJText_RoleName() {
		if (RightJText_RoleName == null) {
			RightJText_RoleName = new TextName(getListTable(), 0);
		}
		return RightJText_RoleName;
	}

	/**
	 * This method initializes RightJLabel_RoleName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_Description() {
		if (RightJLabel_Description == null) {
			RightJLabel_Description = new LabelBase();
			RightJLabel_Description.setText("Description");
		}
		return RightJLabel_Description;
	}

	/**
	 * This method initializes RightJText_RoleName
	 *
	 * @return com.hkah.client.layout.textfield.TextName
	 */
	private TextDesc getRightJText_Description() {
		if (RightJText_Description == null) {
			RightJText_Description = new TextDesc(getListTable(), 1);
		}
		return RightJText_Description;
	}
}