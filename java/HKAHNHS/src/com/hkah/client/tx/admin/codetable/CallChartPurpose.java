package com.hkah.client.tx.admin.codetable;

import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MaintenancePanel;
import com.hkah.shared.constants.ConstantsTx;

public class CallChartPurpose extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.CALLCHARTPURPOSE_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.CALLCHARTPURPOSE_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Seq",
				"Purpose"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				0,
				500
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;  //  @jve:decl-index=0:visual-constraint="58,28"
	
	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;  //  @jve:decl-index=0:visual-constraint="19,322"
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_CallChartPurpose = null;
	private TextString RightJText_CallChartPurpose = null;

	private String seq = null;  //  @jve:decl-index=0:

	/**
	 * This method initializes
	 *
	 */
	public CallChartPurpose() {
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
		//setModifyButtonEnabled(true);
		//setDeleteButtonEnabled(false);
		//setConfirmButtonEnabled(false);
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
		return getRightJText_CallChartPurpose();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {
		// override function if necessary
	}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {
		seq = null;
		
		getRightJText_CallChartPurpose().setEnabled(true);
		getRightJText_CallChartPurpose().resetText();
	}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
		getRightJText_CallChartPurpose().setEnabled(true);
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
		seq = outParam[index++];
		getRightJText_CallChartPurpose().setText(outParam[index++]);
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {
		if (getRightJText_CallChartPurpose().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Call Chart Purpose");//, getRightJText_CallChartPurpose());
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
				selectedContent[1]
		};
	}

	/* >>> ~23~ Set Action Validation per table =========================== <<< */
	@Override
	protected boolean actionValidation(String[] selectedContent) {
		// TODO Auto-generated method stub
		if (selectedContent[1]==null || selectedContent[1].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty Call Chart Purpose!");
			return false;
		}
		return true;
	}
	
	@Override
	public boolean isTableViewOnly() {
		return false;
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
		getRightJText_CallChartPurpose().setText(EMPTY_VALUE);		
	}


	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	protected ColumnLayout getSearchPanel() {
		if (leftPanel == null) {
						
		}
		return leftPanel;
	}

	protected ColumnLayout getActionPanel() {
		if (generalPanel == null) {
			RightJLabel_CallChartPurpose = new LabelBase();
			//RightJLabel_CallChartPurpose.setBounds(0, 0, 400, 60);
			RightJLabel_CallChartPurpose.setText("Call Chart Purpose");
			generalPanel = new ColumnLayout(2,1, new int[] {120,380});
			generalPanel.setBounds(0, 0, 500, 65);
			generalPanel.setHeading("Call Chart Purpose");
			generalPanel.add(0,0,RightJLabel_CallChartPurpose);
			generalPanel.add(1,0,getRightJText_CallChartPurpose());
		}
		return generalPanel;
	}

	private TextString getRightJText_CallChartPurpose() {
		if (RightJText_CallChartPurpose == null) {
			RightJText_CallChartPurpose = new TextString(50,getListTable(), 1){
				@Override
				public void onReleased() {
					super.onReleased();
					setCurrentTable(1, getRightJText_CallChartPurpose().getText());
				}
			};
//			RightJText_CallChartPurpose.setBounds(165, 45, 406, 20);
		}
		return RightJText_CallChartPurpose;
	}
}