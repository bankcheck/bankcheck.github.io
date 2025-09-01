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
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;


/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class Ward extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.WARD_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.WARD_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Ward Code",
				"Ward Name",
				"Department Code",
				"Department Name",
				"Site Code"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				100,
				120,
				100,
				120,
				0
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;  //  @jve:decl-index=0:visual-constraint="10,649"
	private LabelBase LeftJLabel_WardCode = null;
	private TextString LeftJText_WardCode = null;
	private LabelBase LeftJLabel_WardName = null;
	private TextString LeftJText_WardName = null;
	private LabelBase LeftJLabel_DepartmentCode = null;
	private TextString LeftJText_DepartmentCode = null;

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;  //  @jve:decl-index=0:visual-constraint="12,14"
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_WardCode = null;
	private TextString RightJText_WardCode = null;
	private LabelBase RightJLabel_WardName = null;
	private TextString RightJText_WardName = null;
	private LabelBase RightJLabel_DepartmentCode = null;
	private TextString RightJText_DepartmentCode = null;

	/**
	 * This method initializes
	 *
	 */
	public Ward() {
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
		return getLeftJText_WardCode();
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
		getRightJText_WardCode().setEnabled(false);
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
				getLeftJText_WardCode().getText()
				//getLeftJText_WardName().getText(),
				//getLeftJText_DepartmentCode().getText()
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
		getRightJText_WardCode().setText(outParam[index++]);
		getRightJText_WardName().setText(outParam[index++]);
		getRightJText_DepartmentCode().setText(outParam[index++]);
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {
		/* === ~16~ Validation before call right panel action */
		if (getRightJText_WardCode().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Ward Code!", getRightJText_WardCode());
			actionValidationReady(actionType, false);
		} else if (getRightJText_WardName().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Ward Name!", getRightJText_WardName());
			actionValidationReady(actionType, false);
		} else if (getRightJText_DepartmentCode().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Department Code!", getRightJText_DepartmentCode());
			actionValidationReady(actionType, false);
		} else {
			actionValidationReady(actionType, true);
		}
	}

	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		return new String[] {
				selectedContent[0],
				selectedContent[1],
				selectedContent[2],
		};
	}

	@Override
	protected boolean actionValidation(String[] selectedContent) {
		// TODO Auto-generated method stub
		if (selectedContent[0]==null || selectedContent[0].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty Ward Code!");
			return false;
		} else if (selectedContent[1]==null || selectedContent[1].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty Ward Name!");
			return false;
		} else if (selectedContent[2]==null || selectedContent[2].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty Department Code!");
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
			leftPanel = new ColumnLayout(2,1);
//			leftPanel.setSize(495, 65);
			leftPanel.add(0,0,getLeftJLabel_WardCode());
			leftPanel.add(1,0,getLeftJText_WardCode());
	//		leftPanel.add(getLeftJLabel_WardName(),null);
	//		leftPanel.add(getLeftJText_WardName(),null);
		//	leftPanel.add(getLeftJLabel_DepartmentCode(),null);
		//	leftPanel.add(getLeftJText_DepartmentCode(),null);
		}
		return leftPanel;
	}

	/**
	 * This method initializes LeftJLabel_WardCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getLeftJLabel_WardCode() {
		if (LeftJLabel_WardCode == null) {
			LeftJLabel_WardCode = new LabelBase();
//			LeftJLabel_WardCode.setBounds(16, 15, 104, 20);
			LeftJLabel_WardCode.setText("Ward Code :");
			LeftJLabel_WardCode.setOptionalLabel();
		}
		return LeftJLabel_WardCode;
	}

	/**
	 * This method initializes LeftJText_WardCode
	 *
	 * @return com.hkah.client.layout.textfield.TextWardCode
	 */
	private TextString getLeftJText_WardCode() {
		if (LeftJText_WardCode == null) {
			LeftJText_WardCode = new TextString(10,false);
//			LeftJText_WardCode.setLocation(127, 15);
//			LeftJText_WardCode.setSize(95, 20);

		}
		return LeftJText_WardCode;
	}

	/**
	 * This method initializes LeftJLabel_WardName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getLeftJLabel_WardName() {
		if (LeftJLabel_WardName == null) {
			LeftJLabel_WardName = new LabelBase();
//			LeftJLabel_WardName.setBounds(16, 55, 104, 20);
			LeftJLabel_WardName.setText("Ward Name :");
			LeftJLabel_WardName.setOptionalLabel();
		}
		return LeftJLabel_WardName;
	}

	/**
	 * This method initializes LeftJText_WardName
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getLeftJText_WardName() {
		if (LeftJText_WardName == null) {
			LeftJText_WardName = new TextString(50,false);
//			LeftJText_WardName.setLocation(127, 55);
//			LeftJText_WardName.setSize(233, 20);
		}
		return LeftJText_WardName;
	}



	/**
	 * This method initializes LeftJLabel_DepartmentCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getLeftJLabel_DepartmentCode() {
		if (LeftJLabel_DepartmentCode == null) {
			LeftJLabel_DepartmentCode = new LabelBase();
//			LeftJLabel_DepartmentCode.setBounds(16, 97, 104, 20);
			LeftJLabel_DepartmentCode.setText("Department Code :");
			LeftJLabel_DepartmentCode.setOptionalLabel();
		}
		return LeftJLabel_DepartmentCode;
	}

	/**
	 * This method initializes LeftJText_DepartmentCode
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getLeftJText_DepartmentCode() {
		if (LeftJText_DepartmentCode == null) {
			LeftJText_DepartmentCode = new TextString(10,false);
//			LeftJText_DepartmentCode.setLocation(127, 97);
//			LeftJText_DepartmentCode.setSize(152, 20);
		}
		return LeftJText_DepartmentCode;
	}

	/**
	 * This method initializes generalPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected ColumnLayout getActionPanel() {
		if (generalPanel == null) {
			generalPanel = new ColumnLayout(4,2);
			//generalPanel.setBounds(1, 0, 607, 136);
			generalPanel.setHeading("Ward Information");
			generalPanel.add(0,0,getRightJLabel_WardCode());
			generalPanel.add(1,0,getRightJText_WardCode());
			generalPanel.add(2,0,getRightJLabel_WardName());
			generalPanel.add(3,0,getRightJText_WardName());
			generalPanel.add(0,1,getRightJLabel_DepartmentCode());
			generalPanel.add(1,1,getRightJText_DepartmentCode());
		}
		return generalPanel;
	}

	/**
	 * This method initializes RightJLabel_WardCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_WardCode() {
		if (RightJLabel_WardCode == null) {
			RightJLabel_WardCode = new LabelBase();
			RightJLabel_WardCode.setText("Ward Code");
//			RightJLabel_WardCode.setBounds(44, 33, 98, 20);
		}
		return RightJLabel_WardCode;
	}

	/**
	 * This method initializes RightJText_WardCode
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_WardCode() {
		if (RightJText_WardCode == null) {
			RightJText_WardCode = new TextString(10,false) {
				public void onReleased() {
					setCurrentTable(0,RightJText_WardCode.getText());
				}
			};
//			RightJText_WardCode.setBounds(172, 33, 101, 20);
		}
		return RightJText_WardCode;
	}

	/**
	 * This method initializes RightJLabel_WardName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_WardName() {
		if (RightJLabel_WardName == null) {
			RightJLabel_WardName = new LabelBase();
			RightJLabel_WardName.setText("Ward Name");
//			RightJLabel_WardName.setBounds(44, 60, 101, 20);
		}
		return RightJLabel_WardName;
	}

	/**
	 * This method initializes RightJText_WardName
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_WardName() {
		if (RightJText_WardName == null) {
			RightJText_WardName = new TextString(50,false) {
				public void onReleased() {
					setCurrentTable(1,RightJText_WardName.getText());
				}
			};
//			RightJText_WardName.setLocation(172, 60);
//			RightJText_WardName.setSize(257, 20);
		}
		return RightJText_WardName;
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
//			RightJLabel_DepartmentCode.setBounds(44, 91, 118, 20);
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
			RightJText_DepartmentCode = new TextString(50,false) {
				public void onReleased() {
					setCurrentTable(2,RightJText_DepartmentCode.getText());
				}
				public void onBlur() {
					String txCode=ConstantsTx.LOOKUP_TXCODE;
					String[] para=new String[] {"DEPT","dptcode","dptcode='"+getRightJText_DepartmentCode().getText().trim()+"'"};
					QueryUtil.executeMasterFetch(
							getUserInfo(), txCode, para,
							new MessageQueueCallBack() {
								@Override
								public void onPostSuccess(MessageQueue mQueue) {
									if (!mQueue.success()) {
										Factory.getInstance().addErrorMessage("Invalid Department Code!", getRightJText_DepartmentCode());
									} else {
										setCurrentTable(2,RightJText_DepartmentCode.getText());
									}
								}
							});
				};
			};
//			RightJText_DepartmentCode.setLocation(172, 91);
//			RightJText_DepartmentCode.setSize(103, 20);
		}
		return RightJText_DepartmentCode;
	}
}