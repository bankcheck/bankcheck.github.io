package com.hkah.client.layout.dialog;

import java.util.List;

import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.combobox.ComboCMCode;
import com.hkah.client.layout.combobox.ComboDeptServ;
import com.hkah.client.layout.combobox.ComboItemCode;
import com.hkah.client.layout.combobox.ComboPatientType;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgComContractAmend extends DialogBase {

	private List<String[]> list;
	private String actionType;
	private String TableFlag ;
	private BasePanel panel = null;
	private ButtonBase btnOK = null;
	private ButtonBase btnCancel = null;
	private LabelBase patNoDesc = null;
	public TextDate fromDate = null;
	private LabelBase descDesc = null;
	public TextReadOnly desc = null;
	private LabelBase patNoDesc12 = null;
	private LabelBase typyDesc = null;
	public ComboCMCode appContract = null;
	public ComboPatientType itemType = null;
	private LabelBase patNoDesc121 = null;
	public ComboDeptServ deptServ = null;
	public ComboItemCode itemCode = null;
	private LabelBase patNoDesc122 = null;
	public TextDate toDate = null;

	public boolean isOK = false;

	/**
	 * This method initializes
	 *
	 */
	public DlgComContractAmend(MainFrame owner, String tableFlag) {
		super(owner, 431, 330);
		this.TableFlag = tableFlag;
		initialize();
	}
	
	public void showDialog(List<String[]> list) {
		this.list = list;
		this.actionType = list.get(0)[0];
		afterInit();
		this.setVisible(true);
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		this.setContentPane(getPanel());
        this.setTitle("Special Commission Contract - Amend ");
	}

	protected void afterInit() {
		clearField();
		enableField();
		
		if (!QueryUtil.ACTION_APPEND.equals(actionType) && list.size()>1) {
			itemType.setText(list.get(1)[3]);
			appContract.setText(list.get(1)[6]);
			fromDate.setText(list.get(1)[7]);
			toDate.setText(list.get(1)[8]);
			fromDate.setEnabled(false);
			toDate.setEnabled(false);
			if (ConstantsVariable.ZERO_VALUE.equals(TableFlag)) {
				getDeptServ().setText(list.get(1)[4]);
				desc.setText(deptServ.getDisplayText().toString().substring(deptServ.getText().length()+1));
			} else {
				getItemCode().setText(list.get(1)[4]);
				desc.setText(itemCode.getDisplayText().toString().substring(itemCode.getText().length()+1));
			}
			
			if (QueryUtil.ACTION_DELETE.equals(actionType)) {
				itemType.setEnabled(false);
				appContract.setEnabled(false);

				if (ConstantsVariable.ZERO_VALUE.equals(TableFlag)) {
					getDeptServ().setEnabled(false);
				} else {
					getItemCode().setEnabled(false);
				}
			}
		}
	}
	
	private void enableField() {
		itemType.setEnabled(true);
		appContract.setEnabled(true);
		fromDate.setEnabled(true);
		toDate.setEnabled(true);
		if (ConstantsVariable.ZERO_VALUE.equals(TableFlag)) {
			getDeptServ().setEnabled(true);
		} else {
			getItemCode().setEnabled(true);
		}
	}
	
	private void clearField() {
		itemType.resetText();
		appContract.resetText();
		fromDate.resetText();
		toDate.resetText();
		desc.resetText();
		if (ConstantsVariable.ZERO_VALUE.equals(TableFlag)) {
			getDeptServ().resetText();
		}
		else {
			getItemCode().resetText();
		}
	}

	protected boolean validation() {
		if (QueryUtil.ACTION_DELETE.equals(actionType)) {
			return true;
		}
		if (itemType.isEmpty()) {
			Factory.getInstance().addErrorMessage("Item Charge Type is mandatory.", itemType);
			return false;
		}
		if (ConstantsVariable.ZERO_VALUE.equals(TableFlag) && deptServ.isEmpty()) {
			Factory.getInstance().addErrorMessage("Department Service is mandatory.", deptServ);
			return false;
		}
		if (ConstantsVariable.ONE_VALUE.equals(TableFlag) && itemCode.isEmpty()) {
			Factory.getInstance().addErrorMessage("Item Code is mandatory.", itemCode);
			return false;
		}
		if (appContract.isEmpty()) {
			Factory.getInstance().addErrorMessage("Contract Applied is mandatory.", appContract);
			return false;
		}
		if (fromDate.isEmpty()) {
			Factory.getInstance().addErrorMessage("Effective Date From is mandatory.", fromDate);
			return false;
		} else if (toDate.isEmpty()) {
			Factory.getInstance().addErrorMessage("Effective Date To is mandatory.", toDate);
			return false;
		} else if (DateTimeUtil.dateDiff(fromDate.getText(), toDate.getText()) > 0) {
			Factory.getInstance().addErrorMessage("Effective To Date must not be ealier than From Date.", fromDate);
			return false;
		}
		return true;
	}

	protected void save() {
		if (!validation()) {
			return;
		}
		String cid = ConstantsVariable.EMPTY_VALUE;
		if (!(QueryUtil.ACTION_APPEND.equals(actionType)) && list.size()>1) {
			cid = list.get(1)[1];
		}
		String[] saveParam = new String[] {
				cid,
				list.get(0)[1],
				ConstantsVariable.ZERO_VALUE.equals(TableFlag) ? deptServ.getText():itemCode.getText(),
				itemType.getText(),
				appContract.getText(),
				getUserInfo().getSiteCode(),
				fromDate.getText(),
				toDate.getText()
		};
		MessageQueueCallBack callBack = new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				savePost();
				dispose();
			}
		};
		if (ConstantsVariable.ZERO_VALUE.equals(TableFlag)) {
			QueryUtil.executeMasterAction(getUserInfo(), ConstantsTx.COMCONDPSERV_TXCODE, actionType, saveParam, callBack);
		} else {
			QueryUtil.executeMasterAction(getUserInfo(), ConstantsTx.COMCONITEM_TXCODE, actionType, saveParam, callBack);
		}
	}
	
	protected void savePost() {
		
	}

	/**
	 * This method initializes panel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	private BasePanel getPanel() {
		if (panel == null) {
			patNoDesc122 = new LabelBase();
			patNoDesc122.setBounds(38, 201, 110, 20);
			patNoDesc122.setText("Effective Date To");
			patNoDesc121 = new LabelBase();
			patNoDesc121.setBounds(38, 126, 110, 20);
			patNoDesc121.setText("Contract Applied");
			itemType = new ComboPatientType();
			itemType.setBounds(162, 21, 120, 20);
			typyDesc = new LabelBase();
			typyDesc.setBounds(38, 58, 110, 20);
			typyDesc.setText("Department Service");
			patNoDesc12 = new LabelBase();
			patNoDesc12.setBounds(38, 163, 110, 20);
			patNoDesc12.setText("Effective Date From");
			desc = new TextReadOnly();
			desc.setBounds(162, 86, 172, 20);
			descDesc = new LabelBase();
			descDesc.setBounds(38, 86, 112, 20);
			descDesc.setText("Description");
			patNoDesc = new LabelBase();
			patNoDesc.setBounds(38, 21, 110, 20);
			patNoDesc.setText("Item Charge Type");
			panel = new BasePanel();
			panel.add(getBtnOK(), null);
			panel.add(getBtnCancel(), null);
			panel.add(patNoDesc, null);
			panel.add(getFromDate(), null);
			panel.add(descDesc, null);
			panel.add(desc, null);
			panel.add(patNoDesc12, null);
			panel.add(typyDesc, null);
			panel.add(getAppContract(), null);
			panel.add(itemType, null);
			panel.add(patNoDesc121, null);
			//panel.add(getDeptServ(), null);
			panel.add(patNoDesc122, null);
			panel.add(getToDate(), null);
			if (ConstantsVariable.ZERO_VALUE.equals(TableFlag)) {
				panel.add(getDeptServ(), null);
			} else {
				panel.add(getItemCode(), null);
				typyDesc.setText("Item Code");
				descDesc.setText("Item Name");
			}
		}
		return panel;
	}

	/**
	 * This method initializes btnOK
	 *
	 * @return com.hkah.client.layout.button.ButtonBase
	 */
	private ButtonBase getBtnOK() {
		if (btnOK == null) {
			btnOK = new ButtonBase() {
				@Override
				public void onClick() {
					save();
				}
			};
			btnOK.setBounds(108, 250, 78, 24);
			btnOK.setText("OK");
			btnOK.focus();
		}
		return btnOK;
	}

	/**
	 * This method initializes btnCancel
	 *
	 * @return com.hkah.client.layout.button.ButtonBase
	 */
	private ButtonBase getBtnCancel() {
		if (btnCancel == null) {
			btnCancel = new ButtonBase() {
				@Override
				public void onClick() {
					savePost();
					dispose();
				}
			};
			btnCancel.setBounds(242, 250, 78, 24);
			btnCancel.setText("Cancel");
		}
		return btnCancel;
	}

	/**
	 * This method initializes fromDate
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextDate getFromDate() {
		if (fromDate == null) {
			fromDate = new TextDate();
			fromDate.setBounds(162, 163, 120, 20);
		}
		return fromDate;
	}

	/**
	 * This method initializes deptServ
	 *
	 * @return javax.swing.JComboBox
	 */
	private ComboDeptServ getDeptServ() {
		if (deptServ == null) {
			deptServ = new ComboDeptServ() {
				public void onClick() {
					desc.setText(deptServ.getDisplayText().toString().substring(deptServ.getText().length()+1));
				}
			};
			deptServ.setBounds(162, 58, 172, 20);
		}
		return deptServ;
	}

	private ComboItemCode getItemCode() {
		if (itemCode == null) {
			itemCode = new ComboItemCode(desc);
			itemCode.setBounds(162, 58, 172, 20);
		}
		return itemCode;
	}

	private ComboCMCode getAppContract() {
		if (appContract == null) {
			appContract = new ComboCMCode(true);
			appContract.setBounds(162, 126, 172, 20);
		}
		return appContract;
	}

	/**
	 * This method initializes toDate
	 *
	 * @return com.hkah.client.layout.textfield.TextDate
	 */
	private TextDate getToDate() {
		if (toDate == null) {
			toDate = new TextDate();
			toDate.setBounds(162, 201, 120, 20);
		}
		return toDate;
	}
}