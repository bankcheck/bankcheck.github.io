/*
 * Created on July 23, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.tx.admin.syscodetable;

import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextNum;
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
public class SubReason extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.SUBREASON_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.SUBREASON_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Sub-Reason Code",
				"Sub-Reason Description",
				"New Code",
				"Tab No.",   //
				"Row No.",
				"Reason Code",
				"Reason Description"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				100,
				120,
				0,
				80,
				80,
				100,
				0
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;  //  @jve:decl-index=0:visual-constraint="29,-1"
	private LabelBase LeftJLabel_SubReasonCode = null;
	private TextString LeftJText_SubReasonCode = null;
	private CheckBoxBase LeftCheckBox_NewCode = null;
	private LabelBase LeftJLabel_NewCode=null;

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;  //  @jve:decl-index=0:visual-constraint="10,112"
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_SubReasonCode = null;
	private TextString RightJText_SubReasonCode = null;
	private LabelBase RightJLabel_SubReasonDesc = null;
	private TextString RightJText_SubReasonDesc = null;

	private LabelBase RightJLabel_TabNo = null;
	private TextNum RightJText_TabNo = null;
	private LabelBase RightJLabel_RowNo = null;
	private TextNum RightJText_RowNo = null;
	private LabelBase RightJLabel_ReasonCode = null;
	private TextString RightJText_ReasonCode = null;
	private LabelBase RightJLabel_NewCode = null;
	private CheckBoxBase RightJCheckBox_NewCode = null;
	/**
	 * This method initializes
	 *
	 */
	public SubReason() {
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
//		getListTable().setColumnClass(1, new ComboPayType(), false);
//		getListTable().setColumnClass(9, new CheckBoxBase(), false);


	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return getLeftJText_SubReasonCode();
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
		getRightJText_SubReasonCode().setEnabled(false);
	}

	/* >>> ~13~ Set Disable Fields When Delete ButtonBase Is Clicked ====== <<< */
	@Override
	protected void deleteDisabledFields() {
		// enable/disable field
	}

	/* >>> ~14~ Set Browse Validation ===================================== <<< */
	@Override
	protected boolean browseValidation() {
		/*if (getLeftJText_SubReasonCode().getText().trim().length()==0 || getLeftJText_SubReasonCode().getText()==null) {
			return false;
		}*/
		return true;
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
				getLeftJText_SubReasonCode().getText(),getLeftCheckBox_NewCode().isSelected()?"-1":"0"
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
		getRightJText_SubReasonCode().setText(outParam[index++]);
		getRightJText_SubReasonDesc().setText(outParam[index++]);
		getRightJCheckBox_NewCode().setSelected("Y".equals(outParam[index++]));
		getRightJText_TabNo().setText(outParam[index++]);
		getRightJText_RowNo().setText(outParam[index++]);
		getRightJText_ReasonCode().setText(outParam[index++]);
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {
		if (getRightJText_SubReasonCode().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty SubReason Code!", getRightJText_SubReasonCode());
			actionValidationReady(actionType, false);
		} else if (getRightJText_SubReasonDesc().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Sub-Reason Description!", getRightJText_SubReasonDesc());
			actionValidationReady(actionType, false);
		} else {
			actionValidationReady(actionType, true);
		}
	}

	/* >>> ~21~ Set Add New Row toclearPostAction table ============================== <<< */
	@Override
	protected void clearTableFields() {
		super.clearTableFields();
		setCurrentTable(2, "N");
	}

	/* >>> ~22~ Set Action Input Parameters per table ===================== <<< */
	protected String[] getActionInputParamaters(String[] selectedContent) {
		// TODO Auto-generated method stub
		String[] param=new String[] {
				selectedContent[0],
				selectedContent[1],
				"Y".equals(selectedContent[2])?"-1":"0",
				selectedContent[3],
				selectedContent[4],
				selectedContent[5],
		};
		return param;
	}

	/* >>> ~23~ Set Action Validation per table =========================== <<< */
	@Override
	protected boolean actionValidation(String[] selectedContent) {
		// TODO Auto-generated method stub
		if (selectedContent[0]==null || selectedContent[0].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty Sub-Reason Code!");
			return false;
		} else if (selectedContent[1]==null || selectedContent[1].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty Sub-Reason Description!");
			return false;
		} else if (selectedContent[5]==null || selectedContent[5].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty Reason Code!");
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
//			leftPanel.setSize(398, 78);
			//leftPanel.add(getLeftJLabel_SubReasonCode());
			//leftPanel.add(getLeftJText_SubReasonCode());
			leftPanel.add(0,0,getLeftCheckBox_NewCode());
			leftPanel.add(1,0,getLeftJLabel_NewCode());
		}
		return leftPanel;
	}

	/**
	 * This method initializes LeftJLabel_SubReasonCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */


	private LabelBase getLeftJLabel_SubReasonCode() {
		if (LeftJLabel_SubReasonCode == null) {
			LeftJLabel_SubReasonCode = new LabelBase();
			LeftJLabel_SubReasonCode.setText("Sub-Reason Code:");
			LeftJLabel_SubReasonCode.setOptionalLabel();
		}
		return LeftJLabel_SubReasonCode;
	}

	/**
	 * This method initializes LeftJText_SubReasonCode
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getLeftJText_SubReasonCode() {
		if (LeftJText_SubReasonCode == null) {
			LeftJText_SubReasonCode = new TextString(5,true);
		}
		return LeftJText_SubReasonCode;
	}
	/**
	 * This method initializes LeftCheckBox_NewCode
	 *
	 * @return com.hkah.client.layout.checkbox.CheckBoxBase
	 */
	private CheckBoxBase getLeftCheckBox_NewCode() {
		if (LeftCheckBox_NewCode == null) {
			LeftCheckBox_NewCode = new CheckBoxBase() {
				public void onClick() {
						searchAction();
				}
			};
		}
		return LeftCheckBox_NewCode;
	}

	/**
	 * This method initializes LeftJLabel_NewCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getLeftJLabel_NewCode() {
		if (LeftJLabel_NewCode == null) {
			LeftJLabel_NewCode = new LabelBase();
			LeftJLabel_NewCode.setText("New Code :");
			LeftJLabel_NewCode.setOptionalLabel();
		}
		return LeftJLabel_NewCode;
	}
			//rightPanel.setSize(821, 223);


	/**
	 * This method initializes generalPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected ColumnLayout getActionPanel() {
		if (generalPanel == null) {
			generalPanel = new ColumnLayout(4,4);
			generalPanel.setHeading("Sub-Reason Information");
			generalPanel.add(0,0,getRightJLabel_SubReasonCode());
			generalPanel.add(1,0,getRightJText_SubReasonCode());
			generalPanel.add(2,0,getRightJLabel_SubReasonDesc());
			generalPanel.add(3,0,getRightJText_SubReasonDesc());
			generalPanel.add(0,1,getRightJLabel_TabNo());
			generalPanel.add(1,1,getRightJText_TabNo());
			generalPanel.add(2,1,getRightJLabel_RowNo());
			generalPanel.add(3,1,getRightJText_RowNo());
			generalPanel.add(0,2,getRightJLabel_ReasonCode());
			generalPanel.add(1,2,getRightJText_ReasonCode());
			generalPanel.add(0,3,getRightJLabel_NewCode());
			generalPanel.add(1,3,getRightJCheckBox_NewCode());

		}
		return generalPanel;
	}

	/**
	 * This method initializes RightJLabel_SubReasonCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_SubReasonCode() {
		if (RightJLabel_SubReasonCode == null) {
			RightJLabel_SubReasonCode = new LabelBase();
			RightJLabel_SubReasonCode.setText("Sub-Reason Code");
		}
		return RightJLabel_SubReasonCode;
	}

	/**
	 * This method initializes RightJText_SubReasonCode
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_SubReasonCode() {
		if (RightJText_SubReasonCode == null) {
			RightJText_SubReasonCode = new TextString(5,getListTable(),0,true);
		}
		return RightJText_SubReasonCode;
	}

	/**
	 * This method initializes RightJLabel_SubReasonDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_SubReasonDesc() {
		if (RightJLabel_SubReasonDesc == null) {
			RightJLabel_SubReasonDesc = new LabelBase();
			RightJLabel_SubReasonDesc.setText("Sub-Reason Description");
		}
		return RightJLabel_SubReasonDesc;
	}

	/**
	 * This method initializes RightJText_SubReasonDesc
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_SubReasonDesc() {
		if (RightJText_SubReasonDesc == null) {
			RightJText_SubReasonDesc = new TextString(50,getListTable(),1,true);
		}
		return RightJText_SubReasonDesc;
	}
	/**
	 * This method initializes RightJLabel_TabNo
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_TabNo() {
		if (RightJLabel_TabNo == null) {
			RightJLabel_TabNo = new LabelBase();
			RightJLabel_TabNo.setText("Tab No.");
		}
		return RightJLabel_TabNo;
	}
	/**
	 * This method initializes RightJLabel_RowNo
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_RowNo() {
		if (RightJLabel_RowNo == null) {
			RightJLabel_RowNo = new LabelBase();
			RightJLabel_RowNo.setText("Row No.");
		}
		return RightJLabel_RowNo;
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
	 * This method initializes RightJLabel_NewCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_NewCode() {
		if (RightJLabel_NewCode == null) {
			RightJLabel_NewCode = new LabelBase();
			RightJLabel_NewCode.setText("New Code");
		}
		return RightJLabel_NewCode;
	}

	/**
	 * This method initializes RightJText_RowNo
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextNum getRightJText_RowNo() {
		if (RightJText_RowNo == null) {
			RightJText_RowNo = new TextNum(30,0) {
				public void onReleased() {
					setCurrentTable(4,RightJText_RowNo.getText());
				}
			};
		}
		return RightJText_RowNo;
	}

	/**
	 * This method initializes RightJCheckBox_NewCode
	 *
	 * @return com.hkah.client.layout.checkbox.CheckBoxBase
	 */
	private CheckBoxBase getRightJCheckBox_NewCode() {
		if (RightJCheckBox_NewCode == null) {
			RightJCheckBox_NewCode = new CheckBoxBase(getListTable(),2);
		}
		return RightJCheckBox_NewCode;
	}

	/**
	 * This method initializes RightJText_TabNo
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextNum getRightJText_TabNo() {
		if (RightJText_TabNo == null) {
			RightJText_TabNo = new TextNum(8,0) {
				public void onReleased() {
					setCurrentTable(3,RightJText_TabNo.getText());
				}
			};
		}
		return RightJText_TabNo;
	}
	/**
	 * This method initializes RightJText_ReasonCode
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_ReasonCode() {
		if (RightJText_ReasonCode == null) {
			RightJText_ReasonCode = new TextString() {
				public void onBlur() {
					QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] {"REASON","RSNCODE","RSNCODE='"+RightJText_ReasonCode.getText()+"'"},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								setCurrentTable(5,RightJText_ReasonCode.getText());
							} else {
								getRightJText_ReasonCode().resetText();
								Factory.getInstance().addErrorMessage("Invalid Code value.",getRightJText_ReasonCode());
								getRightJText_ReasonCode().requestFocus();
							}
						}
					});
				};
			};
		}
		return RightJText_ReasonCode;
	}
}