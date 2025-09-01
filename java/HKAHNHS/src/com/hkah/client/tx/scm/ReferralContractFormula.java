package com.hkah.client.tx.scm;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.util.Rectangle;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.LayoutContainer;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MaintenancePanel;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class ReferralContractFormula extends MaintenancePanel{

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.REFERRALCONTRACTFORM_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.REFERRALCONTRACTFORM_TITLE;
	}

	private BasePanel viewPanel = null;
	private BasePanel leftPanel = null;

	private LabelBase CtCodeDesc = null;
	private TextString CtCode = null;
	private LabelBase CtNameDesc = null;
	private TextBase CtName = null;
	private LabelBase CtFormulaDesc = null;
	private TextString CtFormula = null;
	private LabelBase StnOAmtDesc = null;
	private TextString StnOAmt = null;
	private LabelBase StnBAmtDesc = null;
	private TextString StnBAmt = null;
	private LabelBase StnNAmtDesc = null;
	private TextString StnNAmt = null;
	private LabelBase CommissionDesc = null;
	private TextString Commission = null;
	private ButtonBase Calculate = null;
	/**
	 * This method initializes
	 *
	 */
	public ReferralContractFormula() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		//setNoGetDB(true);
		//getJScrollPane().setBounds(25, 150, 600, 220);
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		//setLeftAlignPanel();
		getListTable().setBounds(10, 200, 600, 200);
		//enableButton();
		searchAction();
	}
	
	private void enableField() {
		getCtCode().setEditable(isAppend() || isModify());
		getCtCode().setReadOnly(!isAppend() && !isModify());
		getCtName().setEditable(isAppend() || isModify());
		getCtName().setReadOnly(!isAppend() && !isModify());
		getCtFormula().setEditable(isAppend() || isModify());
		getCtFormula().setReadOnly(!isAppend() && !isModify());
		getStnOAmt().setEditable(isAppend() || isModify());
		getStnOAmt().setReadOnly(!isAppend() && !isModify());
		getStnBAmt().setEditable(isAppend() || isModify());
		getStnBAmt().setReadOnly(!isAppend() && !isModify());
		getStnNAmt().setEditable(isAppend() || isModify());
		getStnNAmt().setReadOnly(!isAppend() && !isModify());
		getCommission().setEditable(isAppend() || isModify());
		getCommission().setReadOnly(!isAppend() && !isModify());
		layout();
	}
	
	@Override
	protected void enableButton(String mode) {
		disableButton();
		
		getAppendButton().setEnabled(true);
		getModifyButton().setEnabled(getListTable().getRowCount() > 0 && !isAppend() && !isModify());
		getDeleteButton().setEnabled(getListTable().getRowCount() > 0);
		getSaveButton().setEnabled(isAppend() || isModify());
		getCancelButton().setEnabled(isAppend() || isModify());
		getCalculate().setEnabled(isAppend() || isModify());
		
		enableField();
	}
	
	@Override
	protected void performListPost() {
		enableButton();
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return getCtCode();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {}

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
				ConstantsVariable.EMPTY_VALUE
		};
	}

	/* >>> ~16~ Set Fetch Input Parameters ================================ <<< */
	@Override
	protected String[] getFetchInputParameters() {
		String[] selectedContent = getListSelectedRow();
		return new String[] {
				selectedContent[0],
		};
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {
		int index = 2;
		getCtCode().setText(outParam[index++]);
		getCtName().setText(outParam[index++]);
		getCtFormula().setText(outParam[index++]);
	}

	/* >>> ~22~ Set Action Input Parameters per table ===================== <<< */
	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		return new String[] {
				selectedContent[1],
				selectedContent[2],
				selectedContent[3],
				selectedContent[4]
		};
	}

	/* >>> ~23~ Set Action Validation per table =========================== <<< */
	@Override
	protected boolean actionValidation(String[] selectedContent) {
		if (selectedContent[2].isEmpty()) {
			Factory.getInstance().addErrorMessage("Contract Code cannot be empty.");
			return false;
		}
		if (selectedContent[3].isEmpty()) {
			Factory.getInstance().addErrorMessage("Contract Name cannot be empty.");
			return false;
		}
		if (selectedContent[4].trim().isEmpty()) {
			Factory.getInstance().addErrorMessage("Contract Formula cannot be empty.");
			return false;
		}
		return true;
	}

	@Override
	public void appendAction() {
		if (getAppendButton().isEnabled()) {
			setActionType(QueryUtil.ACTION_APPEND);
			getListTable().addRow(new String[] {null, null, null, null, null});
			getListTable().setSelectRow(getListTable().getRowCount() - 1);
			getStnOAmt().resetText();
			getStnBAmt().resetText();
			getStnNAmt().resetText();
			getCommission().resetText();
			enableButton();
		}
	}
	
	@Override
	public void modifyAction() {
		if (getModifyButton().isEnabled()) {
			setActionType(QueryUtil.ACTION_MODIFY);
			getStnOAmt().resetText();
			getStnBAmt().resetText();
			getStnNAmt().resetText();
			getCommission().resetText();
			enableButton();
		}
	}
	
	@Override
	public void deleteAction() {
		if (getDeleteButton().isEnabled()) {
			MessageBoxBase.confirm("PBA - ["+getTitle()+"]", 
				"Are you sure to delete this formula?", 
				new Listener<MessageBoxEvent>() {
					@Override
					public void handleEvent(MessageBoxEvent be) {
						// TODO Auto-generated method stub
						if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
							setActionType(QueryUtil.ACTION_DELETE);
							actionValidation(getActionType());
						}
					}
			});
		}
	}
	
	@Override
	public void cancelYesAction() {
		setActionType(null);
		searchAction();
	}
	
	@Override
	public void saveAction() {
		if (getSaveButton().isEnabled()) {
			if (checkInputField() && validTestField()) {
				validFormula(getCtFormula().getText().trim(), true);
			}
		}
	}
	
	@Override
	public boolean isTableViewOnly() {
		return false;
	}
	
	protected void validFormulaReady(String formula, boolean isSave) {
		if (isSave) {
			if (formula.length() <= 0) {
				Factory.getInstance().addErrorMessage("Contract Formula is invalid.");
			}
			else {
				actionValidation(getActionType());
			}
		}
		else {
			getCommission().setText(formula);
			if (getCommission().isEmpty()) {
				Factory.getInstance().addErrorMessage("Contract Formula is invalid.");
			} else {
				Factory.getInstance().addErrorMessage("Contract Formula is valid.");
			}
		}
	}

	protected void validFormula(String foumula, final boolean isSave) {
		if (validTestField()) {
			foumula = foumula.toUpperCase().replaceAll(ConstantsVariable.SPACE_VALUE, ConstantsVariable.EMPTY_VALUE);
			foumula = foumula.replaceAll("\\{", "").replaceAll("\\}", "")
								.replaceAll("STNNAMT", getStnNAmt().getText().trim())
								.replaceAll("STNOAMT", getStnOAmt().getText().trim())
								.replaceAll("STNBAMT", getStnBAmt().getText().trim())
								.replaceAll("\\%", "\\/100").replaceAll("ISCFIX=", "")
								.replaceAll("IF", "IFF");
			QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] {"dual",foumula,"1=1"},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						try {
							Double.parseDouble(mQueue.getContentField()[0]);
						} catch (Exception e) {
							validFormulaReady(ConstantsVariable.EMPTY_VALUE, isSave);
						}
						validFormulaReady(String.valueOf(Math.round(Double.parseDouble(mQueue.getContentField()[0]))), isSave);
					} else {
						validFormulaReady(ConstantsVariable.EMPTY_VALUE, isSave);
					}
				}
			});
		}
	}

	protected boolean validTestField() {
		if (getCtFormula().getText().indexOf("{STNOAMT}")>-1) {
			if (getStnOAmt().getText().trim().isEmpty()) {
				Factory.getInstance().addErrorMessage("STNOAMT cannot be empty.", getStnOAmt());
				return false;
			}
		}
		if (getCtFormula().getText().indexOf("{STNBAMT}")>-1) {
			if (getStnBAmt().getText().trim().isEmpty()) {
				Factory.getInstance().addErrorMessage("STNBAMT cannot be empty.", getStnBAmt());
				return false;
			}
		}
		if (getCtFormula().getText().indexOf("{STNNAMT}")>-1) {
			if (getStnNAmt().getText().trim().isEmpty()) {
				Factory.getInstance().addErrorMessage("STNNAMT cannot be empty.", getStnNAmt());
				return false;
			}
		}
		return true;
	}

	protected boolean checkInputField() {
		if (getCtCode().getText().trim().isEmpty()) {
			Factory.getInstance().addErrorMessage("Contract Code cannot be empty.", getCtCode());
			return false;
		}
		if (getCtName().getText().trim().isEmpty()) {
			Factory.getInstance().addErrorMessage("Contract Name cannot be empty.", getCtName());
			return false;
		}
		if (getCtFormula().getText().trim().isEmpty()) {
			Factory.getInstance().addErrorMessage("Contract Formula cannot be empty.", getCtFormula());
			return false;
		}
		return true;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"","",
				"Contract Code",
				"Contract Name",
				"Contract Formula"

		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				10,0,
				120,
				130,
				200
		};
	}

	/* >>> getter methods for init the Component start from here================================== <<< */
	protected BasePanel getViewPanel() {
		if (viewPanel == null) {
			viewPanel = new BasePanel();
			viewPanel.add(getStnOAmtDesc(), null);
			viewPanel.add(getStnOAmt(), null);
			viewPanel.add(getStnBAmt(), null);
			viewPanel.add(getStnBAmtDesc(), null);
			viewPanel.add(getStnNAmtDesc(), null);
			viewPanel.add(getStnNAmt(), null);
			viewPanel.add(getCommissionDesc(), null);
			viewPanel.add(getCommission(), null);
			viewPanel.add(getCalculate(), null);
			viewPanel.add(getCtNameDesc(), null);
			viewPanel.add(getCtName(), null);
			viewPanel.add(getCtFormulaDesc(), null);
			viewPanel.add(getCtFormula(), null);
			viewPanel.add(getCtCode(), null);
			viewPanel.add(getCtCodeDesc(), null);
		}
		return viewPanel;
	}

	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.setSize(761, 10);
		}
		return leftPanel;
	}

	public LabelBase getCtCodeDesc() {
		if (CtCodeDesc == null) {
			CtCodeDesc = new LabelBase();
			CtCodeDesc.setText("Contract Code");
			CtCodeDesc.setBounds(new Rectangle(23, 34, 106, 20));
		}
		return CtCodeDesc;
	}

	public TextString getCtCode() {
		if (CtCode == null) {
			CtCode = new TextString(getListTable(), 2);
			CtCode.setBounds(new Rectangle(129, 34, 468, 20));
		}
		return CtCode;
	}

	public LabelBase getCtNameDesc() {
		if (CtNameDesc == null) {
			CtNameDesc = new LabelBase();
			CtNameDesc.setText("Contract Name");
			CtNameDesc.setBounds(new Rectangle(23, 63, 106, 20));
		}
		return CtNameDesc;
	}

	public TextBase getCtName() {
		if (CtName == null) {
			CtName = new TextBase(getListTable(), 3);
			CtName.setBounds(new Rectangle(129, 63, 468, 20));
		 }
		return CtName;
	}

	public LabelBase getCtFormulaDesc() {
		if (CtFormulaDesc == null) {
			CtFormulaDesc = new LabelBase();
			CtFormulaDesc.setText("Contract Formula");
			CtFormulaDesc.setBounds(new Rectangle(23, 93, 106, 20));
		}
		return CtFormulaDesc;
	}

	public TextString getCtFormula() {
		if (CtFormula == null) {
			CtFormula = new TextString(getListTable(), 4);
			CtFormula.setBounds(new Rectangle(129, 93, 468, 20));
		 }
		return CtFormula;
	}

	public LabelBase getStnOAmtDesc() {
		if (StnOAmtDesc == null) {
			StnOAmtDesc = new LabelBase();
			StnOAmtDesc.setText("STNOAMT");
			StnOAmtDesc.setBounds(new Rectangle(38, 153, 91, 20));
		}
		return StnOAmtDesc;
	}

	public TextString getStnOAmt() {
		if (StnOAmt == null) {
			StnOAmt = new TextString();
			StnOAmt.setBounds(new Rectangle(38, 172, 91, 20));
		 }
		return StnOAmt;
	}

	public LabelBase getStnBAmtDesc() {
		if (StnBAmtDesc == null) {
			StnBAmtDesc = new LabelBase();
			StnBAmtDesc.setText("STNBAMT");
			StnBAmtDesc.setBounds(new Rectangle(136, 153, 91, 20));
		}
		return StnBAmtDesc;
	}

	public TextString getStnBAmt() {
		if (StnBAmt == null) {
			StnBAmt = new TextString();
			StnBAmt.setBounds(new Rectangle(136, 172, 91, 20));
		 }
		return StnBAmt;
	}

	public LabelBase getStnNAmtDesc() {
		if (StnNAmtDesc == null) {
			StnNAmtDesc = new LabelBase();
			StnNAmtDesc.setText("STNNAMT");
			StnNAmtDesc.setBounds(new Rectangle(233, 153, 91, 20));
		}
		return StnNAmtDesc;
	}

	public TextString getStnNAmt() {
		if (StnNAmt == null) {
			StnNAmt = new TextString();
			StnNAmt.setBounds(new Rectangle(233, 172, 91, 20));
		 }
		return StnNAmt;
	}

	public LabelBase getCommissionDesc() {
		if (CommissionDesc == null) {
			CommissionDesc = new LabelBase();
			CommissionDesc.setText("Commission");
			CommissionDesc.setBounds(new Rectangle(330, 153, 91, 20));
		}
		return CommissionDesc;
	}

	public TextString getCommission() {
		if (Commission == null) {
			Commission = new TextString();
			Commission.setBounds(new Rectangle(330, 172, 91, 20));
		 }
		return Commission;
	}

	public ButtonBase getCalculate() {
		if (Calculate==null) {
			Calculate = new ButtonBase() {
				@Override
				public void onClick() {
					String formula = getCtFormula().getText().trim();
					if (formula.isEmpty()) {
						Factory.getInstance().addErrorMessage("Contract Formula cannot be empty.", CtFormula);
						return ;
					}
					if (!validTestField()) {
						return;
					}
					validFormula(formula, false);
				}
			};
			Calculate.setText("Calculate");
			Calculate.setBounds(new Rectangle(430, 172, 93, 20));
		 }
		return Calculate;
	}

	@Override
	protected ColumnLayout getSearchPanel() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	protected LayoutContainer getActionPanel() {
		// TODO Auto-generated method stub
		return getViewPanel();
	}
}