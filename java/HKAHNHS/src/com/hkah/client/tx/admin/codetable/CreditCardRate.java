package com.hkah.client.tx.admin.codetable;


import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.combobox.ComboPay2Code;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextNum;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MaintenancePanel;
import com.hkah.shared.constants.ConstantsTx;

public class CreditCardRate extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.CREDITCARDRATE_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.CREDITCARDRATE_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Card Name",
				"Charge Rate",
				"Pay Type"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				100,
				80,
				120
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;  //  @jve:decl-index=0:visual-constraint="58,28"
	private LabelBase LeftJLabel_CardName = null;
	private TextString LeftJText_CardName = null;

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;  //  @jve:decl-index=0:visual-constraint="19,322"
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_CardName = null;
	private TextString RightJText_CardName = null;
	private LabelBase RightJLabel_ChargeRate = null;
	private TextNum RightJText_ChargeRate = null;
	private LabelBase RightJLabel_PayType = null;
	private ComboPay2Code RightJCombo_PayType = null;


	/**
	 * This method initializes
	 *
	 */
	public CreditCardRate() {
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
		getListTable().setColumnClass(2, new ComboPay2Code(), false);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return getLeftJText_CardName();
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
		getRightJText_CardName().setEnabled(false);
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
				getLeftJText_CardName().getText()
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
		getRightJText_CardName().setText(outParam[index++]);
		getRightJText_ChargeRate().setText(outParam[index++]);
		getRightJCombo_PayType().setText(outParam[index++]);
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {}

	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		return new String[] {
				selectedContent[0],
				selectedContent[1],
				selectedContent[2]
		};
	}

	@Override
	protected boolean actionValidation(String[] selectedContent) {
		// TODO Auto-generated method stub
		if (selectedContent[0]==null || selectedContent[0].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty Card Name!");
			return false;
		} else if (selectedContent[1]==null || selectedContent[1].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty Charge Rate!");
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
			LeftJLabel_CardName = new LabelBase();
//			LeftJLabel_CardName.setBounds(15, 15, 106, 20);
			LeftJLabel_CardName.setText("Card Name");
			leftPanel = new ColumnLayout(2,1);
//			leftPanel.setSize(471,80);
			leftPanel.add(0,0,LeftJLabel_CardName);
			leftPanel.add(1,0,getLeftJText_CardName());
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
			generalPanel = new ColumnLayout(4,2);
			RightJLabel_PayType = new LabelBase();
//			RightJLabel_PayType.setBounds(15, 120, 136, 20);
			RightJLabel_PayType.setText("Pay Type");
			RightJLabel_ChargeRate = new LabelBase();
//			RightJLabel_ChargeRate.setBounds(15, 75, 136, 20);
			RightJLabel_ChargeRate.setText("Charge Rate");
			RightJLabel_CardName = new LabelBase();
//			RightJLabel_CardName.setBounds(15, 30, 136, 20);
			RightJLabel_CardName.setText("Card Name");
//			generalPanel.setBounds(0, 0, 601, 211);
			generalPanel.setHeading("Credit Card Rate Information");
			generalPanel.add(0,0,RightJLabel_CardName);
			generalPanel.add(1,0,getRightJText_CardName());
			generalPanel.add(2,0,RightJLabel_ChargeRate);
			generalPanel.add(3,0,getRightJText_ChargeRate());
			generalPanel.add(0,1,RightJLabel_PayType);
			generalPanel.add(1,1,getRightJCombo_PayType());
		}
		return generalPanel;
	}

	/**
	 * This method initializes LeftJText_CardName
	 *
	 * @return javax.swing.TextString
	 */
	private TextString getLeftJText_CardName() {
		if (LeftJText_CardName == null) {
			LeftJText_CardName = new TextString(10);
//			LeftJText_CardName.setBounds(135, 15, 211, 20);
		}
		return LeftJText_CardName;
	}

	/**
	 * This method initializes RightJText_CardName
	 *
	 * @return javax.swing.TextString
	 */
	private TextString getRightJText_CardName() {
		if (RightJText_CardName == null) {
			RightJText_CardName = new TextString(10,getListTable(), 0);
		}
		return RightJText_CardName;
	}

	/**
	 * This method initializes RightJText_ChargeRate
	 *
	 * @return javax.swing.TextString
	 */
	private TextNum getRightJText_ChargeRate() {
		if (RightJText_ChargeRate == null) {
			RightJText_ChargeRate = new TextNum(8, 2) {
				public void onReleased() {
					setCurrentTable(1,RightJText_ChargeRate.getText());
				}
			};
//			RightJText_ChargeRate.setBounds(165, 75, 196, 20);
		}
		return RightJText_ChargeRate;
	}

	/**
	 * This method initializes RightJCombo_PayType
	 *
	 * @return javax.swing.JComboBox
	 */
	private ComboPay2Code getRightJCombo_PayType() {
		if (RightJCombo_PayType == null) {
			RightJCombo_PayType = new ComboPay2Code() {
				public void onClick() {
					setCurrentTable(2,RightJCombo_PayType.getText());
				}
			};
//			RightJCombo_PayType.setBounds(165, 120, 196, 31);
		}
		return RightJCombo_PayType;
	}
}