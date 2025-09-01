/*
 * Created on July 23, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.tx.admin.codetable;

import com.extjs.gxt.ui.client.data.ModelData;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboDocExSMSType;
import com.hkah.client.layout.combobox.ComboDoctor;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
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
public class DoctorExtra extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.DOCTOR_EXTRA_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.DOCTOR_EXTRA_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Doctor Code",
				"Doctor Name",
				"SMS Tel 1",
				"SMS Tel 2",
				"SMSTYPE",
				"SMSTYPES",
				"SMS Types"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				100,
				200,
				100,
				100,
				0,
				0,
				100
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;  //  @jve:decl-index=0:visual-constraint="10,649"

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;  //  @jve:decl-index=0:visual-constraint="12,14"
	private FieldSetBase generalPanel = null;
	private LabelBase RightJLabel_DocCode = null;
	private ComboDoctor RightJText_DocCode = null;
	private LabelBase RightJLabel_SmsTel = null;
	private TextString RightJText_SmsTel = null;
	private LabelBase RightJLabel_SmsTel2 = null;
	private TextString RightJText_SmsTel2 = null;
	private LabelBase RightJLabel_SmsType = null;
	private ComboDocExSMSType RightJCombo_SmsType = null;
	private LabelBase RightJText_SmsType1 = null;
	private LabelBase RightJText_SmsType2 = null;
	private LabelBase RightJText_SmsType4 = null;
	private CheckBoxBase RightJCheckBox_SmsType1 = null;
	private CheckBoxBase RightJCheckBox_SmsType2 = null;
	private CheckBoxBase RightJCheckBox_SmsType4 = null;
	
	private String oldCode = null;
	/**
	 * This method initializes
	 *
	 */
	public DoctorExtra() {
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
	public ComboDoctor getDefaultFocusComponent() {
		return RightJText_DocCode;
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {
		// override function if necessary
	}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {
		getRightJText_DocCode().setEnabled(true);
		getRightJText_DocCode().resetText();
//		getRightJCombo_SmsType().setEnabled(true);
//		getRightJCombo_SmsType().resetText();
		getRightJText_SmsTel().setEnabled(true);
		getRightJText_SmsTel().resetText();
		getRightJText_SmsTel2().setEnabled(true);
		getRightJText_SmsTel2().resetText();
		getRightJCheckBox_SmsType1().setEnabled(true);
		getRightJCheckBox_SmsType2().setEnabled(true);
		getRightJCheckBox_SmsType4().setEnabled(true);

	}
	
	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
		getRightJText_DocCode().setEnabled(true);
		getRightJText_SmsTel().setEnabled(true);
		getRightJText_SmsTel2().setEnabled(true);
//		getRightJCombo_SmsType().setEnabled(true);
		getRightJCheckBox_SmsType1().setEnabled(true);
		getRightJCheckBox_SmsType2().setEnabled(true);
		getRightJCheckBox_SmsType4().setEnabled(true);
		oldCode = getRightJText_DocCode().getText();
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
		System.err.println("DE getFetchOutputValues");
		
		int index = 0;
		getRightJText_DocCode().setText(outParam[index++]);
		index++;
		getRightJText_SmsTel().setText(outParam[index++]);
		getRightJText_SmsTel2().setText(outParam[index++]);		
//		getRightJCombo_SmsType().setSelectedIndex(outParam[index++]);
		index++;
		String smsTypeStr = outParam[index++];
		
		resetSmsTypeCheckBox();
		if (smsTypeStr != null) {
			String[] smsTypes = smsTypeStr.split(",");
			for (String smsType : smsTypes) {
				if ("1".equals(smsType)) {
					getRightJCheckBox_SmsType1().setSelected(true);
				} else if ("2".equals(smsType)) {
					getRightJCheckBox_SmsType2().setSelected(true);
				} else if ("4".equals(smsType)) {
					getRightJCheckBox_SmsType4().setSelected(true);
				}
			}
		}
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {
		if (getRightJText_DocCode().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Doctor Code!", getRightJText_DocCode());
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
		String tempSmsType = null;
		if(getRightJCheckBox_SmsType1().getValue()){
			tempSmsType = "1";
		};
		if(getRightJCheckBox_SmsType2().getValue()){
			if(tempSmsType!=null){
				tempSmsType = tempSmsType+",2";
			}else{
				tempSmsType = "2";
			}
		}		
		if(getRightJCheckBox_SmsType4().getValue()){
			if(tempSmsType!=null){
				tempSmsType = tempSmsType+",4";
			}else{
				tempSmsType = "4";
			}
		}
		
		return new String[] {
				selectedContent[0],
				selectedContent[2],
				selectedContent[3],
				getUserInfo().getUserID(),
				tempSmsType,
				oldCode
		};
	}

	@Override
	protected boolean actionValidation(String[] selectedContent) {
		// TODO Auto-generated method stub
		if (selectedContent[0]==null || selectedContent[0].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty Doctor Code!");
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
		getRightJText_DocCode().setText(EMPTY_VALUE);
		getRightJText_SmsTel().setText(EMPTY_VALUE);
		getRightJText_SmsTel2().setText(EMPTY_VALUE);
//		getRightJCombo_SmsType().setText(EMPTY_VALUE);
		getRightJCheckBox_SmsType1().setSelected(false);
		getRightJCheckBox_SmsType2().setSelected(false);
		getRightJCheckBox_SmsType4().setSelected(false);
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	protected ColumnLayout getSearchPanel() {
		if (leftPanel == null) {
//			leftPanel.setSize(495, 110);
		
	}
		return leftPanel;
	}

	protected FieldSetBase getActionPanel() {
		if (generalPanel == null) {
			//generalPanel = new ColumnLayout(4,3);
			generalPanel = new FieldSetBase();
			generalPanel.setBounds(0, 0, 600, 130);
			generalPanel.setHeading("Doctor Extra Information");
			generalPanel.add(getRightJLabel_DocCode());
			generalPanel.add(getRightJText_DocCode());
			
//			generalPanel.add(getRightJCombo_SmsType());
			generalPanel.add(getRightJLabel_SmsTel());
			generalPanel.add(getRightJText_SmsTel());
			generalPanel.add(getRightJLabel_SmsTel2());
			generalPanel.add(getRightJText_SmsTel2());
			
			generalPanel.add(getRightJLabel_SmsType());
			
			//LayoutContainer smsTypes = new LayoutContainer();
			generalPanel.add(getRightJText_SmsType1());
			generalPanel.add(getRightJCheckBox_SmsType1());
			generalPanel.add(getRightJText_SmsType2());
			generalPanel.add(getRightJCheckBox_SmsType2());
			generalPanel.add(getRightJText_SmsType4());
			generalPanel.add(getRightJCheckBox_SmsType4());
			//generalPanel.add(smsTypes);
			/*
			generalPanel.add(1,2,getRightJText_SmsType1());
			generalPanel.add(1,2,getRightJCheckBox_SmsType1());
			generalPanel.add(2,2,getRightJText_SmsType2());
			generalPanel.add(2,2,getRightJCheckBox_SmsType2());
			generalPanel.add(3,2,getRightJText_SmsType4());
			generalPanel.add(3,2,getRightJCheckBox_SmsType4());
			*/
		}
		return generalPanel;
	}

	private LabelBase getRightJLabel_DocCode() {
		if (RightJLabel_DocCode == null) {
			RightJLabel_DocCode = new LabelBase();
			RightJLabel_DocCode.setText("Doctor Code");
			RightJLabel_DocCode.setBounds(10, 10, 100, 20);
		}
		return RightJLabel_DocCode;
	}
	
	private ComboDoctor getRightJText_DocCode() {
		if (RightJText_DocCode == null) {
			RightJText_DocCode = new ComboDoctor() {
				@Override
				protected void setTextPanel(ModelData modelData) {
					getRightJText_DocCode().setToolTip(getDisplayText());
				}

				@Override
				public void onClick() {
					super.onClick();
					getRightJText_DocCode().setToolTip(getDisplayText());
					setCurrentTable(0, getRightJText_DocCode().getText());
				}
				
				@Override
				public void onReleased() {
					super.onReleased();
					setCurrentTable(0, getRightJText_DocCode().getText());
				}
			};
			RightJText_DocCode.setBounds(120, 10, 100, 20);
		}
		return RightJText_DocCode;
	}

		
	private LabelBase getRightJLabel_SmsTel() {
		if (RightJLabel_SmsTel == null) {
			RightJLabel_SmsTel = new LabelBase();
			RightJLabel_SmsTel.setText("SMS Tel 1");
			RightJLabel_SmsTel.setBounds(10, 40, 100, 20);
		}
		return RightJLabel_SmsTel;
	}

	private TextString getRightJText_SmsTel() {
		if (RightJText_SmsTel == null) {
			RightJText_SmsTel = new TextString(20,getListTable(),2,false){
				@Override
				public void onReleased() {
					super.onReleased();
					setCurrentTable(2, getRightJText_SmsTel().getText());
				}
			};
			RightJText_SmsTel.setBounds(120, 40, 100, 20);
		}
		return RightJText_SmsTel;
	}
	
	private LabelBase getRightJLabel_SmsTel2() {
		if (RightJLabel_SmsTel2 == null) {
			RightJLabel_SmsTel2 = new LabelBase();
			RightJLabel_SmsTel2.setText("SMS Tel 2");
			RightJLabel_SmsTel2.setBounds(240, 40, 100, 20);
		}
		return RightJLabel_SmsTel2;
	}

	private TextString getRightJText_SmsTel2() {
		if (RightJText_SmsTel2 == null) {
			RightJText_SmsTel2 = new TextString(20,getListTable(),3,false){
				@Override
				public void onReleased() {
					super.onReleased();
					setCurrentTable(3, getRightJText_SmsTel2().getText());
				}
			};
			RightJText_SmsTel2.setBounds(350, 40, 100, 20);
		}
		return RightJText_SmsTel2;
	}
	
	private LabelBase getRightJLabel_SmsType() {
		if (RightJLabel_SmsType == null) {
			RightJLabel_SmsType = new LabelBase();
			RightJLabel_SmsType.setText("SMS Type");
			RightJLabel_SmsType.setBounds(10, 70, 100, 20);
		}
		return RightJLabel_SmsType;
	}
/*
	private ComboDocExSMSType getRightJCombo_SmsType() {
		if (RightJCombo_SmsType == null) {
			RightJCombo_SmsType = new ComboDocExSMSType() {
				public void onClick() {
					setCurrentTable(4,
							(getValue() == null ? "" : (String)getValue().get(ONE_VALUE)));
				}
								
				protected void clearPostAction() {
					setCurrentTable(4,"");
				}
			};
			RightJCombo_SmsType.setBounds(350, 10, 100, 20);
		}
		return RightJCombo_SmsType;
	}
*/	
	private LabelBase getRightJText_SmsType1() {
		if (RightJText_SmsType1 == null) {
			RightJText_SmsType1 = new LabelBase();
			RightJText_SmsType1.setText("OT");
			RightJText_SmsType1.setBounds(120, 70, 30, 20);
		}
		return RightJText_SmsType1;
	}
	
	private CheckBoxBase getRightJCheckBox_SmsType1() {
		if (RightJCheckBox_SmsType1 == null) {
			RightJCheckBox_SmsType1 = new CheckBoxBase() {
				public void onClick() {
					setCurrentTableSmsTypeDesc();
				}
			};
			RightJCheckBox_SmsType1.setBounds(155, 70, 20, 20);
			RightJCheckBox_SmsType1.setData("SMSTYPEDESC", "OT");
		}
		return RightJCheckBox_SmsType1;
	}
	
	private LabelBase getRightJText_SmsType2() {
		if (RightJText_SmsType2 == null) {
			RightJText_SmsType2 = new LabelBase();
			RightJText_SmsType2.setText("IP");
			RightJText_SmsType2.setBounds(200, 70, 30, 20);
		}
		return RightJText_SmsType2;
	}
	
	private CheckBoxBase getRightJCheckBox_SmsType2() {
		if (RightJCheckBox_SmsType2 == null) {
			RightJCheckBox_SmsType2 = new CheckBoxBase() {
				public void onClick() {
					setCurrentTableSmsTypeDesc();
				}
			};
			RightJCheckBox_SmsType2.setBounds(235, 70, 20, 20);
			RightJCheckBox_SmsType2.setData("SMSTYPEDESC", "IP");
		}
		return RightJCheckBox_SmsType2;
	}
	
	private LabelBase getRightJText_SmsType4() {
		if (RightJText_SmsType4 == null) {
			RightJText_SmsType4 = new LabelBase();
			RightJText_SmsType4.setText("JUST ADMIT");
			RightJText_SmsType4.setBounds(285, 70, 70, 20);
		}
		return RightJText_SmsType4;
	}
	
	private CheckBoxBase getRightJCheckBox_SmsType4() {
		if (RightJCheckBox_SmsType4 == null) {
			RightJCheckBox_SmsType4 = new CheckBoxBase() {
				public void onClick() {
					setCurrentTableSmsTypeDesc();
				}
			};
			RightJCheckBox_SmsType4.setBounds(350, 70, 20, 20);
			RightJCheckBox_SmsType4.setData("SMSTYPEDESC", "JUST ADMIT");
		}
		return RightJCheckBox_SmsType4;
	}
	
	private void resetSmsTypeCheckBox() {
		getRightJCheckBox_SmsType1().setSelected(false);
		getRightJCheckBox_SmsType2().setSelected(false);
		getRightJCheckBox_SmsType4().setSelected(false);
	}
	
	private void setCurrentTableSmsTypeDesc() {
		int smsTypeDescIdx = 6;
		String valueMulti = "";
		
		if (getRightJCheckBox_SmsType1().isSelected()) {
			if (!valueMulti.isEmpty()) {
				valueMulti += ", ";
			}
			valueMulti += getRightJCheckBox_SmsType1().getData("SMSTYPEDESC");
		}
		if (getRightJCheckBox_SmsType2().isSelected()) {
			if (!valueMulti.isEmpty()) {
				valueMulti += ", ";
			}
			valueMulti += getRightJCheckBox_SmsType2().getData("SMSTYPEDESC");
		}
		if (getRightJCheckBox_SmsType4().isSelected()) {
			if (!valueMulti.isEmpty()) {
				valueMulti += ", ";
			}
			valueMulti += getRightJCheckBox_SmsType4().getData("SMSTYPEDESC");
		}
		setCurrentTable(smsTypeDescIdx, valueMulti);
	}
}