package com.hkah.client.tx.admin.codetable;


import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.combobox.ComboCashierStatus;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MaintenancePanel;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class Cashier extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.CASHIER_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.CASHIER_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		// CSHCODE,
        // CSHSTS,
        // USRID,
		// CSHMAC,
        // TO_CHAR(CSHODATE,'DD/MM/YYYY hh24:mm:ss'),
        // TO_CHAR(CSHFDATE,'DD/MM/YYYY hh24:mm:ss'),
        // CSHRCNT
		// CSHVCNT
		return new String[] {
				"Cashier Code",
				"Cashier Status",
				"User ID",
				"Sign on Machine",
				"Sign on Time",
				"Sign off Time",
				"Reprint",
				"Void"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				80,
				80,
				60,
				80,
				80,
				80,
				60,
				60
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;  //  @jve:decl-index=0:visual-constraint="38,28"
	private LabelBase LeftJLabel_CashierCode = null;
	private LabelBase LeftJLabel_UserID = null;
	private TextString LeftJText_UserID = null;
	private TextString LeftJText_CashierCode = null;
	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;  //  @jve:decl-index=0:visual-constraint="19,322"
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_CashierCode = null;
	private LabelBase RightJLabel_UserID = null;
	private TextString RightJText_CashierCode = null;
	private TextString RightJText_UserID = null;
	private LabelBase RightJLabel_CashierStatus = null;
	private LabelBase RightJLabel_SignOnMachine = null;
	private LabelBase RightJLabel_SignOnTime = null;
	private LabelBase RightJLabel_SignOffTime = null;
	private ComboCashierStatus RightJCombo_CashierStatus = null;
	private TextString RightJText_SignOnMachine = null;
	private TextString RightJText_SignOnTime = null;
	private TextString RightJText_SignOffTime = null;

	/**
	 * This method initializes
	 *
	 */
	public Cashier() {
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

		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		//performList();
		getListTable().setColumnClass(1, new ComboCashierStatus(), false);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return getLeftJText_CashierCode();
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
		getRightJText_SignOnTime().setEnabled(false);
		getRightJText_SignOffTime().setEnabled(false);
		getRightJText_CashierCode().setEditable(true);
	}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
		// enable/disable field
		getRightJText_CashierCode().setEnabled(false);
		getRightJText_SignOnMachine().setEnabled(false);
		getRightJText_SignOnTime().setEnabled(false);
		getRightJText_SignOffTime().setEnabled(false);
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
			getLeftJText_CashierCode().getText(),
			getLeftJText_UserID().getText()
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
		// CSHCODE,
        // CSHSTS,
        // USRID,
		// CSHMAC,
        // TO_CHAR(CSHODATE,'DD/MM/YYYY hh24:mm:ss'),
        // TO_CHAR(CSHFDATE,'DD/MM/YYYY hh24:mm:ss'),
        // CSHRCNT
		// CSHVCNT
		int index = 0;
		getRightJText_CashierCode().setText(outParam[index++]);
		getRightJCombo_CashierStatus().setText(outParam[index++]);
		getRightJText_UserID().setText(outParam[index++]);
		getRightJText_SignOnMachine().setText(outParam[index++]);
		getRightJText_SignOnTime().setText(outParam[index++]);
		getRightJText_SignOffTime().setText(outParam[index++]);
		}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {}

	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		// TODO Auto-generated method stub
		String[] param=new String[] {
				selectedContent[0],
				selectedContent[1],
				selectedContent[2],
				selectedContent[3],
				selectedContent[4],
				selectedContent[5]
		};
		return param;
	}

	@Override
	protected boolean actionValidation(String[] selectedContent) {
		// TODO Auto-generated method stub
		if (selectedContent[0].trim().length() == 0|| selectedContent[0]==null) {
			Factory.getInstance().addErrorMessage("Empty cashier code!");
			return false;
		} else if (selectedContent[1].trim().length() == 0 || selectedContent[1]==null) {
			Factory.getInstance().addErrorMessage("Empty Cashier Status!");
			return false;
		} else if (selectedContent[2].trim().length() == 0 || selectedContent[2]==null) {
			Factory.getInstance().addErrorMessage("Empty user ID!");
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
			LeftJLabel_UserID = new LabelBase();
//			LeftJLabel_UserID.setBounds(15, 50, 91, 20);
			LeftJLabel_UserID.setText("User ID");
			LeftJLabel_CashierCode = new LabelBase();
//			LeftJLabel_CashierCode.setBounds(15, 15, 91, 20);
			LeftJLabel_CashierCode.setText("Cashier Code");
			leftPanel = new ColumnLayout(2,2);
//			leftPanel.setSize(452, 90);
			leftPanel.add(0,0,LeftJLabel_CashierCode);
			leftPanel.add(0,1,LeftJLabel_UserID);
			leftPanel.add(1,1,getLeftJText_UserID());
			leftPanel.add(1,0,getLeftJText_CashierCode());
		}
		return leftPanel;
	}


			//rightPanel.setSize(925, 20);


	/**
	 * This method initializes generalPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected ColumnLayout getActionPanel() {
		if (generalPanel == null) {
			generalPanel = new ColumnLayout(4,3);
			RightJLabel_SignOffTime = new LabelBase();
//			RightJLabel_SignOffTime.setBounds(300, 150, 106, 20);
			RightJLabel_SignOffTime.setText("Sign Off time");
			RightJLabel_SignOnTime = new LabelBase();
//			RightJLabel_SignOnTime.setBounds(15, 150, 106, 20);
			RightJLabel_SignOnTime.setText("Sign On Time");
			RightJLabel_SignOnMachine = new LabelBase();
//			RightJLabel_SignOnMachine.setBounds(15, 120, 106, 20);
			RightJLabel_SignOnMachine.setText("Sign On Machine");
			RightJLabel_CashierStatus = new LabelBase();
//			RightJLabel_CashierStatus.setBounds(15, 90, 106, 20);
			RightJLabel_CashierStatus.setText("Cashier Status");
			RightJLabel_UserID = new LabelBase();
//			RightJLabel_UserID.setBounds(15, 60, 91, 20);
			RightJLabel_UserID.setText("User ID");
			RightJLabel_CashierCode = new LabelBase();
//			RightJLabel_CashierCode.setBounds(15, 30, 91, 20);
			RightJLabel_CashierCode.setText("Cashier Code");
//			generalPanel.setLayout(null);
//			generalPanel.setBounds(0, 0, 600, 205);
			generalPanel.setHeading("Cashier Information");
			generalPanel.add(0,0,RightJLabel_CashierCode);
			generalPanel.add(0,1,RightJLabel_UserID);
			generalPanel.add(1,0,getRightJText_CashierCode());
			generalPanel.add(1,1,getRightJText_UserID());
			generalPanel.add(2,0,RightJLabel_CashierStatus);
			generalPanel.add(2,1,RightJLabel_SignOnMachine);
			generalPanel.add(0,2,RightJLabel_SignOnTime);
			generalPanel.add(2,2,RightJLabel_SignOffTime);
			generalPanel.add(3,0,getRightJCombo_CashierStatus());
			generalPanel.add(3,1,getRightJText_SignOnMachine());
			generalPanel.add(1,2,getRightJText_SignOnTime());
			generalPanel.add(3,2,getRightJText_SignOffTime());
		}
		return generalPanel;
	}

	/**
	 * This method initializes LeftJText_UserID
	 *
	 * @return javax.swing.JTextField
	 */
	private TextString getLeftJText_UserID() {
		if (LeftJText_UserID == null) {
			LeftJText_UserID = new TextString();
//			LeftJText_UserID.setBounds(120, 50, 151, 20);
		}
		return LeftJText_UserID;
	}

	/**
	 * This method initializes LeftJText_CashierCode
	 *
	 * @return javax.swing.JTextField
	 */
	private TextString getLeftJText_CashierCode() {
		if (LeftJText_CashierCode == null) {
			LeftJText_CashierCode = new TextString();
//			LeftJText_CashierCode.setBounds(120, 15, 91, 20);
		}
		return LeftJText_CashierCode;
	}

	/**
	 * This method initializes RightJText_CashierCode
	 *
	 * @return javax.swing.JTextField
	 */
	private TextString getRightJText_CashierCode() {
		if (RightJText_CashierCode == null) {
			RightJText_CashierCode = new TextString(3,getListTable(), 0);
		}
		return RightJText_CashierCode;
	}

	/**
	 * This method initializes RightJText_UserID
	 *
	 * @return javax.swing.JTextField
	 */
	private TextString getRightJText_UserID() {
		if (RightJText_UserID == null) {
			RightJText_UserID = new TextString(10) {
				public void onReleased() {
					setCurrentTable(2,RightJText_UserID.getText());
				}
				public void onBlur() {
					QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] {"Usr","UsrID","UsrID='"+RightJText_UserID.getText()+"'"},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								setCurrentTable(2,RightJText_UserID.getText());
							} else {
								RightJText_UserID.resetText();
								RightJText_UserID.requestFocus();
								Factory.getInstance().addErrorMessage("Validate UserID.");
							}
						}
					});

				};
			};
//			RightJText_UserID.setBounds(135, 60, 166, 20);
		}
		return RightJText_UserID;
	}

	/**
	 * This method initializes RightJCombo_CashierStatus
	 *
	 * @return javax.swing.JComboBox
	 */
	private ComboCashierStatus getRightJCombo_CashierStatus() {
		if (RightJCombo_CashierStatus == null) {
			RightJCombo_CashierStatus = new ComboCashierStatus() {
				public void onClick() {
					setCurrentTable(1,RightJCombo_CashierStatus.getText());
				}
			};
//			RightJCombo_CashierStatus.setBounds(135,90, 166, 20);
		}
		return RightJCombo_CashierStatus;
	}

	/**
	 * This method initializes RightJText_SignOnMachine
	 *
	 * @return javax.swing.JTextField
	 */
	private TextString getRightJText_SignOnMachine() {
		if (RightJText_SignOnMachine == null) {
			RightJText_SignOnMachine = new TextString(20,getListTable(), 3);
//			RightJText_SignOnMachine.setBounds(135, 120, 166, 20);

		}
		return RightJText_SignOnMachine;
	}

	/**
	 * This method initializes RightJText_SignOnTime
	 *
	 * @return javax.swing.JTextField
	 */
	private TextString getRightJText_SignOnTime() {
		if (RightJText_SignOnTime == null) {
			RightJText_SignOnTime = new TextString(getListTable(), 4);
		}
		return RightJText_SignOnTime;
	}

	/**
	 * This method initializes RightJText_SignOffTime
	 *
	 * @return javax.swing.JTextField
	 */
	private TextString getRightJText_SignOffTime() {
		if (RightJText_SignOffTime == null) {
			RightJText_SignOffTime = new TextString(getListTable(), 5);
		}
		return RightJText_SignOffTime;
	}
}