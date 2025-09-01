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
public class DepartmentService extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.DEPTSERVICE_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.DEPTSERVICE_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Dept. Service Code",
				"Dept. Service Description",
				"Dept. Service CDescription"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				110,
				130,
				130
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;  //  @jve:decl-index=0:visual-constraint="4,204"
	private LabelBase LeftJLabel_DeptServiceCode = null;
	private TextString LeftJText_DeptServiceCode = null;
	private LabelBase LeftJLabel_DeptServiceDesc = null;
	private TextString LeftJText_DeptServiceDesc = null;
	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;  //  @jve:decl-index=0:visual-constraint="12,14"
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_DeptServiceCode = null;
	private TextString RightJText_DeptServiceCode = null;
	private LabelBase RightJLabel_DeptServiceDesc = null;
	private TextString RightJText_DeptServiceDesc = null;
	private LabelBase RightJLabel_DeptServiceCDesc = null;
	private TextString RightJText_DeptServiceCDesc = null;

	/**
	 * This method initializes
	 *
	 */
	public DepartmentService() {
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
		return getLeftJText_DeptServiceCode();
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
		getRightJText_DeptServiceCode().setEnabled(false);
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
				getLeftJText_DeptServiceCode().getText(),
				getLeftJText_DeptServiceDesc().getText()
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
		getRightJText_DeptServiceCode().setText(outParam[index++]);
		getRightJText_DeptServiceDesc().setText(outParam[index++]);
		getRightJText_DeptServiceCDesc().setText(outParam[index++]);
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {
		if (getRightJText_DeptServiceCode().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Dept. Service Code!", getRightJText_DeptServiceCode());
			actionValidationReady(actionType, false);
		} else if (getRightJText_DeptServiceDesc().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Dept. Service Description!", getRightJText_DeptServiceDesc());
			actionValidationReady(actionType, false);
		} else {
			actionValidationReady(actionType, true);
		}
	}

	/* >>> ~22~ Set Action Input Parameters per table ===================== <<< */
	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		// TODO Auto-generated method stub
		return new String[] {
				selectedContent[0],
				selectedContent[1],
				selectedContent[2]
		};
	}

	/* >>> ~23~ Set Action Validation per table =========================== <<< */
	@Override
	protected boolean actionValidation(String[] selectedContent) {
		// TODO Auto-generated method stub
		if (selectedContent[0].trim().length()==0 || selectedContent[0]==null) {
			Factory.getInstance().addErrorMessage("Empty Dept.Service Code!");
			return false;
		} else if (selectedContent[1].trim().length()==0 || selectedContent[1]==null) {
			Factory.getInstance().addErrorMessage("Empty Dept.Service Description1");
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
			leftPanel.add(0,0,getLeftJLabel_DeptServiceCode());
			leftPanel.add(1,0,getLeftJText_DeptServiceCode());
			leftPanel.add(2,0,getLeftJLabel_DeptServiceDesc());
			leftPanel.add(3,0,getLeftJText_DeptServiceDesc());
	}
		return leftPanel;
	}
	/**
	 * This method initializes LeftJLabel_DeptServiceCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getLeftJLabel_DeptServiceCode() {
		if (LeftJLabel_DeptServiceCode == null) {
			LeftJLabel_DeptServiceCode = new LabelBase();
			LeftJLabel_DeptServiceCode.setText("Dept. Service Code :");
			LeftJLabel_DeptServiceCode.setOptionalLabel();
		}
		return LeftJLabel_DeptServiceCode;
	}

	/**
	 * This method initializes LeftJText_DeptServiceCode
	 *
	 * @return com.hkah.client.layout.textfield.TextDeptServiceCode
	 */
	private TextString getLeftJText_DeptServiceCode() {
		if (LeftJText_DeptServiceCode == null) {
			LeftJText_DeptServiceCode = new TextString(2,false);

		}
		return LeftJText_DeptServiceCode;
	}
	/**
	 * This method initializes LeftJLabel_DeptServiceDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getLeftJLabel_DeptServiceDesc() {
		if (LeftJLabel_DeptServiceDesc == null) {
			LeftJLabel_DeptServiceDesc = new LabelBase();
			LeftJLabel_DeptServiceDesc.setText("Dept. Service Description :");
			LeftJLabel_DeptServiceDesc.setOptionalLabel();
		}
		return LeftJLabel_DeptServiceDesc;
	}

	/**
	 * This method initializes LeftJText_DeptServiceDesc
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getLeftJText_DeptServiceDesc() {
		if (LeftJText_DeptServiceDesc == null) {
			LeftJText_DeptServiceDesc = new TextString(10,false);
		}
		return LeftJText_DeptServiceDesc;
	}

	/**
	 * This method initializes generalPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected ColumnLayout getActionPanel() {
		if (generalPanel == null) {
			generalPanel = new ColumnLayout(4,2);
			generalPanel.setHeading("DeptService Information");
			generalPanel.add(0,0,getRightJLabel_DeptServiceCode());
			generalPanel.add(1,0,getRightJText_DeptServiceCode());
			generalPanel.add(2,0,getRightJLabel_DeptServiceDesc());
			generalPanel.add(3,0,getRightJText_DeptServiceDesc());
			generalPanel.add(0,1,getRightJLabel_DeptServiceCDesc());
			generalPanel.add(1,1,getRightJText_DeptServiceCDesc());


		}
		return generalPanel;
	}

	/**
	 * This method initializes RightJLabel_DeptServiceCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_DeptServiceCode() {
		if (RightJLabel_DeptServiceCode == null) {
			RightJLabel_DeptServiceCode = new LabelBase();
			RightJLabel_DeptServiceCode.setText("Dept. Service Code");
		}
		return RightJLabel_DeptServiceCode;
	}

	/**
	 * This method initializes RightJText_DeptServiceCode
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_DeptServiceCode() {
		if (RightJText_DeptServiceCode == null) {
			RightJText_DeptServiceCode = new TextString(2,getListTable(),0,false);
		}
		return RightJText_DeptServiceCode;
	}

	/**
	 * This method initializes RightJLabel_DeptServiceDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_DeptServiceDesc() {
		if (RightJLabel_DeptServiceDesc == null) {
			RightJLabel_DeptServiceDesc = new LabelBase();
			RightJLabel_DeptServiceDesc.setText("Dept. Service Description");
		}
		return RightJLabel_DeptServiceDesc;
	}

	/**
	 * This method initializes RightJText_DeptServiceDesc
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_DeptServiceDesc() {
		if (RightJText_DeptServiceDesc == null) {
			RightJText_DeptServiceDesc = new TextString(20,getListTable(),1,false);
		}
		return RightJText_DeptServiceDesc;
	}
	/**
	 * This method initializes RightJLabel_DeptServiceDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_DeptServiceCDesc() {
		if (RightJLabel_DeptServiceCDesc == null) {
			RightJLabel_DeptServiceCDesc = new LabelBase();
			RightJLabel_DeptServiceCDesc.setText("Dept. Service CDescription");
		}
		return RightJLabel_DeptServiceCDesc;
	}
	/**
	 * This method initializes RightJText_DeptServiceCDesc
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_DeptServiceCDesc() {
		if (RightJText_DeptServiceCDesc == null) {
			RightJText_DeptServiceCDesc = new TextString(20,getListTable(), 2,false);
		}
		return RightJText_DeptServiceCDesc;
	}
}