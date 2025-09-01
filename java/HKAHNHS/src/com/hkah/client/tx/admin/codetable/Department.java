/*
 * Created on July 23, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.tx.admin.codetable;

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
public class Department extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.DEPARTMENT_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.DEPARTMENT_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Department Code",
				"Department Name",
				"Department CName",
				"Site Code"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				100,
				120,
				120,
				0
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;  //  @jve:decl-index=0:visual-constraint="10,649"
	private LabelBase LeftJLabel_DepartmentCode = null;
	private TextString LeftJText_DepartmentCode = null;
	private LabelBase LeftJLabel_DepartmentName = null;
	private TextString LeftJText_DepartmentName = null;
	private LabelBase LeftJLabel_DepartmentCName = null;  //  @jve:decl-index=0:visual-constraint="515,633"
	private TextString LeftJText_DepartmentCName = null;  //  @jve:decl-index=0:visual-constraint="683,633"


	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;  //  @jve:decl-index=0:visual-constraint="12,14"
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_DepartmentCode = null;
	private TextString RightJText_DepartmentCode = null;
	private LabelBase RightJLabel_DepartmentName = null;
	private TextString RightJText_DepartmentName = null;
	private LabelBase RightJLabel_DepartmentCName = null;
	private TextString RightJText_DepartmentCName = null;

	/**
	 * This method initializes
	 *
	 */
	public Department() {
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
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return getLeftJText_DepartmentCode();
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
		getRightJText_DepartmentCode().setEnabled(false);
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
				getLeftJText_DepartmentCode().getText(),
				getLeftJText_DepartmentName().getText()
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
		getRightJText_DepartmentCode().setText(outParam[index++]);
		getRightJText_DepartmentName().setText(outParam[index++]);
		getRightJText_DepartmentCName().setText(outParam[index++]);
	}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return new String[] {
				getRightJText_DepartmentCode().getText(),
				getRightJText_DepartmentName().getText(),
				getRightJText_DepartmentCName().getText()
			};
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {
		if (getRightJText_DepartmentCode().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Department Code!", getRightJText_DepartmentCode());
			actionValidationReady(actionType, false);
		} else if (getRightJText_DepartmentName().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Department Description!", getRightJText_DepartmentName());
			actionValidationReady(actionType, false);
		} else {
			actionValidationReady(actionType, true);
		}
	}

	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		// TODO Auto-generated method stub
		String[] param=new String[] {
				selectedContent[0],
				selectedContent[1],
				selectedContent[2]
		};
		return param;
	}

	@Override
	protected boolean actionValidation(String[] selectedContent) {
		// TODO Auto-generated method stub
		if (selectedContent[0]==null || selectedContent[0].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty Department Code!");
			return false;
		} else if (selectedContent[1]==null || selectedContent[1].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty Department Name!");
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
//			leftPanel.setSize(495, 85);
			leftPanel.add(0,0,getLeftJLabel_DepartmentCode());
			leftPanel.add(1,0,getLeftJText_DepartmentCode());
			leftPanel.add(2,0,getLeftJLabel_DepartmentName());
			leftPanel.add(3,0,getLeftJText_DepartmentName());
		//	leftPanel.add(getLeftJLabel_DepartmentCName(),null);
		//	leftPanel.add(getLeftJText_DepartmentCName(),null);
		}
		return leftPanel;
	}

	/**
	 * This method initializes LeftJLabel_DepartmentCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */


	private LabelBase getLeftJLabel_DepartmentCode() {
		if (LeftJLabel_DepartmentCode == null) {
			LeftJLabel_DepartmentCode = new LabelBase();
//			LeftJLabel_DepartmentCode.setBounds(16, 15, 123, 20);
			LeftJLabel_DepartmentCode.setText("Department Code :");
			LeftJLabel_DepartmentCode.setOptionalLabel();
		}
		return LeftJLabel_DepartmentCode;
	}

	/**
	 * This method initializes LeftJText_DepartmentCode
	 *
	 * @return com.hkah.client.layout.textfield.TextDepartmentCode
	 */
	private TextString getLeftJText_DepartmentCode() {
		if (LeftJText_DepartmentCode == null) {
			LeftJText_DepartmentCode = new TextString(10,false);
		//	LeftJText_DepartmentCode.setBounds(154, 16, 95, 20);

		}
		return LeftJText_DepartmentCode;
	}
	/**
	 * This method initializes LeftJLabel_DepartmentName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getLeftJLabel_DepartmentName() {
		if (LeftJLabel_DepartmentName == null) {
			LeftJLabel_DepartmentName = new LabelBase();
//			LeftJLabel_DepartmentName.setBounds(16, 50, 124, 20);
			LeftJLabel_DepartmentName.setText("Department Name :");
			LeftJLabel_DepartmentName.setOptionalLabel();
		}
		return LeftJLabel_DepartmentName;
	}

	/**
	 * This method initializes LeftJText_DepartmentName
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getLeftJText_DepartmentName() {
		if (LeftJText_DepartmentName == null) {
			LeftJText_DepartmentName = new TextString(50,false);
		//	LeftJText_DepartmentName.setBounds(153, 50, 233, 20);
		}
		return LeftJText_DepartmentName;
	}
	/**
	 * This method initializes LeftJLabel_DepartmentCName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getLeftJLabel_DepartmentCName() {
		if (LeftJLabel_DepartmentCName == null) {
			LeftJLabel_DepartmentCName = new LabelBase();
//			LeftJLabel_DepartmentCName.setBounds(16, 97, 139, 30);
			LeftJLabel_DepartmentCName.setText("Department CName :");
			LeftJLabel_DepartmentCName.setOptionalLabel();
		}
		return LeftJLabel_DepartmentCName;
	}

	/**
	 * This method initializes LeftJText_DepartmentCName
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getLeftJText_DepartmentCName() {
		if (LeftJText_DepartmentCName == null) {
			LeftJText_DepartmentCName = new TextString(10,false);
			//LeftJText_DepartmentCName.setBounds(127, 97, 152, 30);
		}
		return LeftJText_DepartmentCName;
	}

	/**
	 * This method initializes generalPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected ColumnLayout getActionPanel() {
		if (generalPanel == null) {
			generalPanel = new ColumnLayout(4,2);

			//generalPanel.setBounds(1, 0, 607, 142);
			generalPanel.setHeading("Department Information");
			generalPanel.add(0,0,getRightJLabel_DepartmentCode());
			generalPanel.add(1,0,getRightJText_DepartmentCode());
			generalPanel.add(2,0,getRightJLabel_DepartmentName());
			generalPanel.add(3,0,getRightJText_DepartmentName());
			generalPanel.add(0,1,getRightJLabel_DepartmentCName());
			generalPanel.add(1,1,getRightJText_DepartmentCName());



		}
		return generalPanel;
	}

	/**
	 * This method initializes RightJLabel_DepartmentCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_DepartmentCode() {
		if (RightJLabel_DepartmentCode == null) {
			RightJLabel_DepartmentCode = new LabelBase();
			RightJLabel_DepartmentCode.setText("Department Code");
//			RightJLabel_DepartmentCode.setBounds(44, 33, 138, 20);
		}
		return RightJLabel_DepartmentCode;
	}

	/**
	 * This method initializes RightJText_DepartmentCode
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_DepartmentCode() {
		if (RightJText_DepartmentCode == null) {
			RightJText_DepartmentCode = new TextString(10,false) {
				public void onReleased() {
					setCurrentTable(0,RightJText_DepartmentCode.getText());
				}
			};
			//RightJText_DepartmentCode.setBounds(226, 33, 101, 20);

		}
		return RightJText_DepartmentCode;
	}

	/**
	 * This method initializes RightJLabel_DepartmentName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_DepartmentName() {
		if (RightJLabel_DepartmentName == null) {
			RightJLabel_DepartmentName = new LabelBase();
			RightJLabel_DepartmentName.setText("Department Name");
			//RightJLabel_DepartmentName.setBounds(44, 65, 154, 20);
		}
		return RightJLabel_DepartmentName;
	}

	/**
	 * This method initializes RightJText_DepartmentName
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_DepartmentName() {
		if (RightJText_DepartmentName == null) {
			RightJText_DepartmentName = new TextString(50,false) {
				public void onReleased() {
					setCurrentTable(1,RightJText_DepartmentName.getText());
				}
			};
//			RightJText_DepartmentName.setBounds(226, 65, 257, 20);
		}
		return RightJText_DepartmentName;
	}


	/**
	 * This method initializes RightJLabel_DepartmentCName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_DepartmentCName() {
		if (RightJLabel_DepartmentCName == null) {
			RightJLabel_DepartmentCName = new LabelBase();
			RightJLabel_DepartmentCName.setText("Department CName");
//			RightJLabel_DepartmentCName.setBounds(44, 95, 152, 20);
		}
		return RightJLabel_DepartmentCName;
	}

	/**
	 * This method initializes RightJText_DepartmentCName
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_DepartmentCName() {
		if (RightJText_DepartmentCName == null) {
			RightJText_DepartmentCName = new TextString(20,false) {
				public void onReleased() {
					setCurrentTable(2, RightJText_DepartmentCName.getText());
				}
			};
//			RightJText_DepartmentCName.setBounds(224, 95, 103, 20);
		}
		return RightJText_DepartmentCName;
	}
}