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
public class Religious extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.RELIGIOUS_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.RELIGIOUS_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Religious Code",
				"Religious Description"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				200,
				400
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;  //  @jve:decl-index=0:visual-constraint="10,649"

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;  //  @jve:decl-index=0:visual-constraint="12,14"
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_ReligiousCode = null;
	private TextString RightJText_ReligiousCode = null;
	private LabelBase RightJLabel_ReligiousDesc = null;
	private TextString RightJText_ReligiousDesc = null;
	
	private String oldCode = null;
	/**
	 * This method initializes
	 *
	 */
	public Religious() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		/* >>> ~7.1~ Init action (e.g. Listing, Init Comobbox ========= <<< */
		//setFullEntry(true);
		setNoGetDB(true);
		getLeftPanel().setBounds(0, 0, 0, 0);
		/* >>> ~7.2~ Disable Add/Modify/Delete Buttons ================ <<< */
		//setAppendButtonEnabled(false);
		//setModifyButtonEnabled(false);
		//setDeleteButtonEnabled(false);
		getListTable().setHeight(300);

		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		searchAction();		
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return RightJText_ReligiousCode;
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {
		// override function if necessary
	}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {
		getRightJText_ReligiousCode().setEnabled(true);
		getRightJText_ReligiousCode().resetText();
		getRightJText_ReligiousDesc().setEnabled(true);
		getRightJText_ReligiousDesc().resetText();

	}
	
	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
		getRightJText_ReligiousCode().setEnabled(true);
		getRightJText_ReligiousDesc().setEnabled(true);
		
		oldCode = getRightJText_ReligiousCode().getText();
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
				EMPTY_VALUE,
				EMPTY_VALUE
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
		getRightJText_ReligiousCode().setText(outParam[index++]);
		getRightJText_ReligiousDesc().setText(outParam[index++]);
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {
		if (getRightJText_ReligiousCode().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Religious Code!", getRightJText_ReligiousCode());
			actionValidationReady(actionType, false);
		} else if (getRightJText_ReligiousDesc().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Religious Description!", getRightJText_ReligiousDesc());
			actionValidationReady(actionType, false);
		} else {
			actionValidationReady(actionType, true);
		}
	}
	
	@Override
	public boolean isTableViewOnly() {
		return false;
	}

	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		// TODO Auto-generated method stub
		return new String[] {
				selectedContent[0],
				selectedContent[1],
				oldCode
		};
	}

	@Override
	protected boolean actionValidation(String[] selectedContent) {
		// TODO Auto-generated method stub
		if (selectedContent[0]==null || selectedContent[0].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty Religious Code!");
			return false;
		} else if (selectedContent[1]==null || selectedContent[1].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty Religious Description!");
			return false;
		}
		return true;
	}
	
	@Override
	protected void enableButton(String mode) {	
		super.enableButton(mode);
		if (isAppend() || isModify()){
			getClearButton().setEnabled(true);
			getSearchButton().setEnabled(false);
		}else{
			getClearButton().setEnabled(false);
			getSearchButton().setEnabled(true);
		}
		getRefreshButton().setEnabled(false);
	}
	
	@Override
	public void cancelYesAction() {
		searchAction();		
	}
	
	@Override
	protected void performListPost() {
		if(getListTable().getRowCount() > 0){
			getListTable().setSelectRow(0);
		}
	}
	
	@Override
	public void clearAction() {
		clearTableFields();
		getRightJText_ReligiousCode().setText(EMPTY_VALUE);
		getRightJText_ReligiousDesc().setText(EMPTY_VALUE);
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
//			leftPanel.setSize(495, 110);
		
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
			generalPanel = new ColumnLayout(4,1);
			generalPanel.setBounds(0, 0, 600, 80);
			generalPanel.setHeading("Religious Information");
			generalPanel.add(0,0,getRightJLabel_ReligiousCode());
			generalPanel.add(1,0,getRightJText_ReligiousCode());
			generalPanel.add(2,0,getRightJLabel_ReligiousDesc());
			generalPanel.add(3,0,getRightJText_ReligiousDesc());
		}
		return generalPanel;
	}

	/**
	 * This method initializes RightJLabel_ReligiousCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_ReligiousCode() {
		if (RightJLabel_ReligiousCode == null) {
			RightJLabel_ReligiousCode = new LabelBase();
			RightJLabel_ReligiousCode.setText("Religious Code");
//			RightJLabel_ReligiousCode.setBounds(44, 33, 121, 20);
		}
		return RightJLabel_ReligiousCode;
	}

	/**
	 * This method initializes RightJText_ReligiousCode
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_ReligiousCode() {
		if (RightJText_ReligiousCode == null) {
			RightJText_ReligiousCode = new TextString(2,getListTable(), 0,false) {
				@Override
				public void onReleased() {
					super.onReleased();
					setCurrentTable(0, getRightJText_ReligiousCode().getText());
				}
			};
//			RightJText_ReligiousCode.setBounds(200, 32, 101, 20);
		}
		return RightJText_ReligiousCode;
	}

	/**
	 * This method initializes RightJLabel_ReligiousDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_ReligiousDesc() {
		if (RightJLabel_ReligiousDesc == null) {
			RightJLabel_ReligiousDesc = new LabelBase();
			RightJLabel_ReligiousDesc.setText("Religious Description");
//			RightJLabel_ReligiousDesc.setBounds(44, 89, 140, 20);
		}
		return RightJLabel_ReligiousDesc;
	}

	/**
	 * This method initializes RightJText_ReligiousDesc
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_ReligiousDesc() {
		if (RightJText_ReligiousDesc == null) {
			RightJText_ReligiousDesc = new TextString(20,getListTable(),1,false){
				@Override
				public void onReleased() {
					super.onReleased();
					setCurrentTable(1, getRightJText_ReligiousDesc().getText());
				}
			};
//			RightJText_ReligiousDesc.setLocation(204, 88);
//			RightJText_ReligiousDesc.setSize(372, 20);

		}
		return RightJText_ReligiousDesc;
	}
}