package com.hkah.client.tx;

import java.util.List;

import com.extjs.gxt.ui.client.dnd.GridDragSource;
import com.extjs.gxt.ui.client.dnd.GridDropTarget;
import com.extjs.gxt.ui.client.widget.layout.FlowLayout;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.DefaultPanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.TableData;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public abstract class ShufflePanel extends DefaultPanel implements ConstantsVariable {

	private BasePanel jPanel = null;
	private BasePanel leftTablePanel = null;
	private BasePanel rightTablePanel = null;
	private LabelBase comboLabel = null;
	private JScrollPane leftJScrollPane = null;
	private TableList leftListTable = null;
	private String actionType = null;
	private JScrollPane rightJScrollPane = null;
	private TableList rightListTable = null;
	private BasePanel comboJPanel = null;

	private LabelBase leftTableLabel = null;
	private LabelBase rightTableLabel = null;

	public List<TableData> originalList = null;

	private GridDragSource gdrag1=null;
	private GridDropTarget target1 = null;
    private GridDragSource gdrag2=null;
    private GridDropTarget target2 =null;

	protected ShufflePanel() {
		super();
	}

	/***************************************************************************
	 * Initial Methods
	 **************************************************************************/

	/**
	 * This method initializes this
	 *
	 * @return void
	 */
	private void initialize() {
		try {
			// only add column if column name is not empty
			add(getBodyPanel());
			getComboJPanel().add(getComboBox());
			comboLabel.setText(getComboLabelText());
			leftTableLabel.setText(getLeftTableText());
			rightTableLabel.setText(getRightTableText());

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	protected void getComboBoxSelect() {
		actionType = null;
		enableButton();
	}
	private void initializeListeners() {

	}

	/**
	 * initial the screen layout and listener
	 */
	public void postAction() {
		// for parent class call
		super.postAction();

		// set all key listener related
		initialize();			// initial table
		initializeListeners();	// initial listener
		enableButton();			// initial action button
		initAfterReady();
//		originalList = getRightListTable().getStore().getModels();

	}

	protected BasePanel getBodyPanel() {
		return getJPanel();
	}

	public void acceptAction() {
	}

	public void appendAction() {
	}

	public void cancelAction() {
		if (getCancelButton().isEnabled()) {
			actionType = QueryUtil.ACTION_FETCH;
			performGet();
			enableButton();
		}
	}

	public void clearAction() {
	}

	public void deleteAction() {
	}


	public void modifyAction() {
		if (getModifyButton().isEnabled()) {
				actionType = QueryUtil.ACTION_MODIFY;
				enableButton();

				gdrag1=new GridDragSource(leftListTable);
				target1 = new GridDropTarget(leftListTable);
			    target1.setAllowSelfAsSource(false);

			    gdrag2=new GridDragSource(rightListTable);
			    target2 = new GridDropTarget(rightListTable);
			    target2.setAllowSelfAsSource(false);
		}
	}

	public void printAction() {
	}

	public void refreshAction() {
		if (getRefreshButton().isEnabled()) {
			actionType = QueryUtil.ACTION_FETCH;
			performGet();
		}
	}

	public void saveAction() {
		if (getSaveButton().isEnabled()) {
			performAction();
			actionType = QueryUtil.ACTION_FETCH;
			performGet();
			enableButton();

			gdrag1.disable();
			target1.disable();
		    gdrag2.disable();
		    target2.disable();
		}
	}

	public void searchAction() {
	}

	protected void enableButton() {
		getSearchButton().setEnabled(false);
		getAppendButton().setEnabled(false);
		getModifyButton().setEnabled(false);
		getDeleteButton().setEnabled(false);
		getSaveButton().setEnabled(false);
		getAcceptButton().setEnabled(false);
		getCancelButton().setEnabled(false);
		getRefreshButton().setEnabled(false);
		getClearButton().setEnabled(false);
		getPrintButton().setEnabled(false);

		// set button focus color
		if (actionType != null && isFetch()) {
			getModifyButton().setEnabled(true);
			getComboBox().setEnabled(true);
			getRefreshButton().setEnabled(true);

//			getUserInfo().getApplet().setViewModel();
		} else if (actionType != null && isModify()) {
//			getModifyButton().setFocus(true);
			getSaveButton().setEnabled(true);
			getRefreshButton().setEnabled(true);
			getCancelButton().setEnabled(true);
			getComboBox().setEnabled(false);

		} else {
			getModifyButton().setEnabled(true);
			getComboBox().setEnabled(true);
		}
	}


	/***************************************************************************
	 * Abstract Methods for all functions
	 **************************************************************************/

	protected abstract String[] getColumnNames();
	protected abstract int[] getColumnWidths();

	protected  abstract ComboBoxBase getComboBox();

//	protected abstract boolean init();

	protected abstract void initAfterReady();

	protected abstract String getComboLabelText();
	protected abstract String getLeftTableText();
	protected abstract String getRightTableText();


	/**
	 * @param actionType the actionType to set
	 */
	public void setActionType(String actionType) {
		this.actionType = actionType;
	}

	public boolean isAppend() {
		return QueryUtil.ACTION_APPEND.equals(actionType);
	}

	public boolean isModify() {
		return QueryUtil.ACTION_MODIFY.equals(actionType);
	}

	public boolean isDelete() {
		return QueryUtil.ACTION_DELETE.equals(actionType);
	}

	public boolean isFetch() {
		return QueryUtil.ACTION_FETCH.equals(actionType);
	}

	protected void callDefaultFocusComponent() {
		getDefaultFocusComponent().focus();
	}

	/***************************************************************************
	 * List Records Methods
	 **************************************************************************/

	protected boolean browseValidation() {
		return true;
	}

	protected boolean performList() {
		return performList(true);
	}

	protected boolean performList(final boolean showMessage){
		boolean result = true;

		try {
			if ("".equals(getComboBox().getText().trim())) {
				getLeftListTable().removeAllRow();
				getRightListTable().removeAllRow();
			} else {
				QueryUtil.executeMasterBrowse(getUserInfo(), getTxCode(),
						new String[] {"AVAILABLE", getComboBox().getText()}, new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueueLeft) {
						// TODO Auto-generated method stub
						if (mQueueLeft != null) {
							// set table
							getLeftListTable().setListTableContent(mQueueLeft);

							if (!mQueueLeft.success()) {
								Factory.getInstance().addErrorMessage(mQueueLeft);
							}
						} else {
							Factory.getInstance().addErrorMessage("Fail to connect server");
							actionType = null;
						}
					}
				});
				QueryUtil.executeMasterBrowse(getUserInfo(), getTxCode(),
						new String[] {"SELECTED", getComboBox().getText()},new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueueRight) {
						if ( mQueueRight != null) {
							// set table
							getRightListTable().setListTableContent(mQueueRight);

							originalList = getRightListTable().getStore().getModels();

							if (!mQueueRight.success()) {
								Factory.getInstance().addErrorMessage(mQueueRight);
							}
						} else {
							Factory.getInstance().addErrorMessage("Fail to connect server");
							actionType = null;
						}
					}
				});

			}
		} finally {
//						getUserInfo().getApplet().getStatusBar().setLoading(false);
//			enableButton();
		}



		return result;
	}

	/***************************************************************************
	 * Get Record Methods
	 **************************************************************************/

	protected boolean performGet() {
		return performList();

	}

	/***************************************************************************
	 * Perform Actions Methods
	 **************************************************************************/

	boolean result = true;


	protected boolean performAction() {
		result = true;
		String comboValue = getComboBox().getText();
		List<TableData> rightTableDataVector = getRightListTable().getStore().getModels();
		List<TableData> leftTableDataVector = getLeftListTable().getStore().getModels();

		// Insert fields
		for (int i = 0; i < getRightListTable().getRowCount(); i++) {
			TableData fields = (TableData) rightTableDataVector.get(i);
			if (!originalList.contains(fields)) {
				String[] values = new String[fields.getSize() + 1];
				values[0] = comboValue;
				for (int j = 0; j < fields.getSize(); j++) {
					values[j + 1] = (String) fields.getValue(j);
				}

				QueryUtil.executeMasterAction(getUserInfo(), getTxCode(), QueryUtil.ACTION_APPEND, values, new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						// TODO Auto-generated method stub
						if (!mQueue.success()){
							result = false;
							Factory.getInstance().addErrorMessage(mQueue);
							if (mQueue.getContentField().length >= 2) {
								String msg = mQueue.getContentField()[1];
								if (msg != null && !"".equals(msg.trim())) {
									Factory.getInstance().addErrorMessage(msg);
								}
							}
						}
					}
				});


			}

		}

		// Delete fields
		for (int i = 0; i < getLeftListTable().getRowCount(); i++) {
			TableData fields = (TableData) leftTableDataVector.get(i);

			if (originalList.contains(fields)) {
				String[] values = new String[fields.getSize() + 1];
				values[0] = comboValue;
				for (int j = 0; j < fields.getSize(); j++) {
					values[j + 1] = (String) fields.getValue(j);
				}
				QueryUtil.executeMasterAction(getUserInfo(), getTxCode(), QueryUtil.ACTION_DELETE, values,new MessageQueueCallBack() {

					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						// TODO Auto-generated method stub
						if (!mQueue.success()){
							result = false;
							Factory.getInstance().addErrorMessage(mQueue);
							if (mQueue.getContentField().length >= 2) {
								String msg = mQueue.getContentField()[1];
								if (msg != null && !"".equals(msg.trim())) {
									Factory.getInstance().addErrorMessage(msg);
								}
							}
						}
					}

				});

			}

		}


		return result;
	}


	/**
	 * This method initializes jPanel
	 *
	 * @return javax.swing.JPanel
	 */
	private BasePanel getJPanel() {
		if (jPanel == null) {
			rightTableLabel = new LabelBase();
			rightTableLabel.setBounds(420, 105, 301, 31);
			rightTableLabel.setText("JLabel");
			leftTableLabel = new LabelBase();
			leftTableLabel.setBounds(30, 105, 316, 31);
			leftTableLabel.setText("JLabel");
			comboLabel = new LabelBase();
			comboLabel.setBounds(30, 30, 361, 31);
			comboLabel.setText("JLabel");
			jPanel = new BasePanel();
			jPanel.setSize(841, 504);
			jPanel.add(comboLabel, null);
			jPanel.add(getLeftTablePanel(), null);
			jPanel.add(getRightTablePanel(), null);
			jPanel.add(getComboJPanel(), null);
			jPanel.add(leftTableLabel, null);
			jPanel.add(rightTableLabel, null);
		}
		return jPanel;
	}

	/**
	 * This method initializes leftTablePanel
	 *
	 * @return javax.swing.JPanel
	 */
	private BasePanel getLeftTablePanel() {
		if (leftTablePanel == null) {
			leftTablePanel = new BasePanel();
//			leftTablePanel.setBorders(true);
//			leftTablePanel.setLayout(new FitLayout());
			leftTablePanel.setBounds(30, 135, 316, 331);
			leftTablePanel.add(getLeftJScrollPane());
		}
		return leftTablePanel;
	}

	/**
	 * This method initializes rightTablePanel
	 *
	 * @return javax.swing.JPanel
	 */
	private BasePanel getRightTablePanel() {
		if (rightTablePanel == null) {
			rightTablePanel = new BasePanel();
//			rightTablePanel.setLayout(new FlowLayout());
			rightTablePanel.setBounds(420, 135, 301, 331);
			rightTablePanel.add(getRightJScrollPane());
		}
		return rightTablePanel;
	}

	/**
	 * This method initializes leftJScrollPane
	 *
	 * @return javax.swing.JScrollPane
	 */
	private JScrollPane getLeftJScrollPane() {
		if (leftJScrollPane == null) {
			leftJScrollPane = new JScrollPane();
			leftJScrollPane.setViewportView(getLeftListTable());
		}
		return leftJScrollPane;
	}

	/**
	 * This method initializes leftListTable
	 *
	 * @return javax.swing.JTable
	 */
	protected TableList getLeftListTable() {
		if (leftListTable == null) {
			leftListTable = new TableList(getColumnNames(), getColumnWidths());
			leftListTable.setSize(301, 331);

		}
		return leftListTable;
	}

	/**
	 * This method initializes rightJScrollPane
	 *
	 * @return javax.swing.JScrollPane
	 */
	private JScrollPane getRightJScrollPane() {
		if (rightJScrollPane == null) {
			rightJScrollPane = new JScrollPane();
			rightJScrollPane.setViewportView(getRightListTable());
		}
		return rightJScrollPane;
	}

	/**
	 * This method initializes rightListTable
	 *
	 * @return javax.swing.JTable
	 */
	protected TableList getRightListTable() {
		if (rightListTable == null) {
			rightListTable = new TableList(getColumnNames(), getColumnWidths());
			rightListTable.setSize(301, 331);

		}
		return rightListTable;
	}

	/**
	 * This method initializes comboJPanel
	 *
	 * @return javax.swing.JPanel
	 */
	private BasePanel getComboJPanel() {
		if (comboJPanel == null) {
			comboJPanel = new BasePanel();
			comboJPanel.setLayout(new FlowLayout());
			comboJPanel.setBounds(30, 60, 361, 31);
		}
		return comboJPanel;
	}
}
