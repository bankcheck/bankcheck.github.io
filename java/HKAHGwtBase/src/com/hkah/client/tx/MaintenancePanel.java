package com.hkah.client.tx;

import java.util.ArrayList;

import com.extjs.gxt.ui.client.widget.LayoutContainer;
import com.extjs.gxt.ui.client.widget.layout.FlowLayout;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.util.PanelUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;


public abstract class MaintenancePanel extends MasterPanel {

	private BasePanel leftPanel = null;
	private BasePanel rightPanel = null;

	private int lastRowNo = 0;
	private ArrayList deleteRows = new ArrayList();
	private LayoutContainer bodyPanel = null;

	public MaintenancePanel() {
		super(MasterPanel.FLAT_LAYOUT);
	}

	protected LayoutContainer getBodyPanel() {
		if (bodyPanel == null) {
			bodyPanel = new LayoutContainer();
//			bodyPanel.setBorders(true);
			bodyPanel.setLayout(new FlowLayout(0));
			bodyPanel.setStyleAttribute("padding-left","10px");
			if (getSearchPanel() != null) {
				bodyPanel.add(getLeftPanel());
			}
			if (getActionPanel() != null) {
				bodyPanel.add(getActionPanel());
			}
			bodyPanel.add(getListTable());
		}
		return bodyPanel;
	}

	/**
	 * This method initializes leftPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	@Override
	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			if (getSearchPanel() != null) {
				leftPanel.add(getSearchPanel());
				leftPanel.setSize(600, 100);
			} else {
				leftPanel.setSize(0, 0);
			}
		}
		return leftPanel;
	}

	/**
	 * This method initializes rightPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	@Override
	protected final BasePanel getRightPanel() {
		if (rightPanel == null) {
			rightPanel = new BasePanel();
			if (getActionPanel() != null) {
				rightPanel.add(getActionPanel());
				rightPanel.setSize(600, 200);
			} else {
				rightPanel.setSize(0, 0);
			}
		}
		return rightPanel;
	}

	@Override
	public void appendAction() {
		if (getAppendButton().isEnabled() && addActionValidation()) {
			// add row
			getListTable().addRow(getAddActionInputParamaters());
			setLastRowNo(getListTable().getRowCount() - 1);
			getListTable().setSelectRow(getLastRowNo());

			// set default value
			clearTableFields();

			super.appendAction();
		}
	}

	@Override
	public void modifyAction() {
		if (getModifyButton().isEnabled()) {
			super.modifyAction();

			// allow save
			getSaveButton().setEnabled(true);
		}
	}

	@Override
	public void deleteAction() {
		if (getDeleteButton().isEnabled()) {
			super.deleteAction();

			// allow save
			getSaveButton().setEnabled(true);

			int selectrow = getListTable().getSelectedRow();
			int rowcount = getListTable().getRowCount();
			if (getListTable().getRowCount() > 0) {
				deleteRows.add(getListTable().getSelectedRowContent());

				// remove selected row from table
				getListTable().removeRow(getListTable().getSelectedRow());
				if (getListTable().getRowCount() > 0) {
					// set select row
					if (selectrow == (rowcount - 1)) {
						getListTable().setSelectRow(selectrow - 1);
					} else {
						getListTable().setSelectRow(selectrow);
					}
				}
			}
		}
	}

	@Override
	public void saveAction() {
		saveAction(true);
	}

	public void saveAction(final boolean refreshSearch) {
		if (getSaveButton().isEnabled()) {
			String[] tablevalue = null;

			if (isAppend() || isModify()) {
				if (actionValidation(getListSelectedRow())) {
					QueryUtil.executeMasterAction(getUserInfo(), getTxCode(), getActionType(), getActionInputParamaters(),
							new MessageQueueCallBack() {
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								Factory.getInstance().addInformationMessage("Save successful!");
								if (refreshSearch) {
									searchAction();
								} else {
									savePostAction();									
									setActionType(null);
								}
							} else {
								Factory.getInstance().addErrorMessage(mQueue.getReturnMsg());
							}
						}
					});
				}
			} else if (isDelete() && deleteRows.size() > 0) {
				for (int i = 0; i < deleteRows.size(); i++) {
					tablevalue = (String[]) deleteRows.get(i);
					QueryUtil.executeMasterAction(getUserInfo(), getTxCode(), getActionType(), getActionInputParamaters(tablevalue),
							new MessageQueueCallBack() {
						public void onPostSuccess(MessageQueue mQueue) {
							// refresh from db
							searchAction();
						}
					});
				}
				deleteRows.clear();
			}
		}
	}

	@Override
	public void cancelAction() {
		super.cancelAction();
		deleteRows.clear();

		// 20140520 Ricky: cannot searchAction while system waiting user to
		//                 confirm cancel!!
	}

	/**
	 * clear storage and do search again
	 */
	@Override
	protected void cancelPostAction() {
		// clear vector
		deleteRows.clear();

		// trigger search from db again
		searchAction();
	}

	@Override
	protected void clearPostAction() {
		if (isAppend() || isModify()) {
			// clear all field
			clearTableFields();
		}
	}

	protected void setLastRowNo(int lastRowNo) {
		this.lastRowNo = lastRowNo;
	}

	protected int getLastRowNo() {
		return lastRowNo;
	}
	
	protected void savePostAction() {
		// for override if necessary
	}	

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected void enableButton(String mode) {
		super.enableButton(mode);

		// special handle accept button
		if (!isAppend() && !isModify() && !isDelete()) {
			getAcceptButton().setEnabled(false);

			getAppendButton().setEnabled(isAppendButtonEnabled());

			// enable modify and delete button
			if (getListTable().getRowCount() > 0) {
				getModifyButton().setEnabled(isModifyButtonEnabled());
				getDeleteButton().setEnabled(isDeleteButtonEnabled());
			}
		} else if (isDelete()) {
			getDeleteButton().setFocus(false);
			getDeleteButton().setEnabled(true);
			getAcceptButton().setEnabled(false);
		}
	}

	@Override
	protected void setAllRightFieldsEnabled(boolean enable) {
		if (getActionPanel() != null) {
			PanelUtil.setAllFieldsEditable(getActionPanel(), enable);
		}
	}

	@Override
	protected void performListPost() {
		getListTable().setEnabled(true);
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	protected void setCurrentTable(int columnIndex, String value) {
		getListTable().setValueAt(value, getListTable().getSelectedRow(), columnIndex);
	}

	/**
	 * Get Add New Row to table
	 * @return string array
	 */
	private String[] getAddActionInputParamaters() {
		String[] param = new String[getListTable().getColumnCount()];
		for (int i = 0; i < getListTable().getColumnCount() ; i++) {
			param[i] = ConstantsVariable.EMPTY_VALUE;
		}
		return param;
	}

	/***************************************************************************
	 * Abstract Method
	 **************************************************************************/

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return getActionInputParamaters(getListSelectedRow());
	}

	/* >>> ~19~ Set Add Action Validation ================================= <<< */
	protected boolean addActionValidation() {
		return true;
	}

	/* >>> ~21~ Set Add New Row toclearPostAction table ============================== <<< */
	protected void clearTableFields() {
		for (int i = 0; i < getListTable().getColumnCount(); i++) {
			setCurrentTable(i, ConstantsVariable.EMPTY_VALUE);
		}
	}

	/* >>> ~22~ Set Action Input Parameters per table ===================== <<< */
	protected String[] getActionInputParamaters(String[] selectedContent) {
		return selectedContent;
	}

	/* >>> ~23~ Set Action Validation per table =========================== <<< */
	protected abstract boolean actionValidation(String[] selectedContent);

	protected abstract ColumnLayout getSearchPanel();

	protected abstract LayoutContainer getActionPanel();
}