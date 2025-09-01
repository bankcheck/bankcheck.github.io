/*
 * Created on January 7, 2015
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.hkah.client.layout.dialog;

import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
@SuppressWarnings("serial")
public abstract class DlgPbleBudgetEst extends DialogBase {

    private final static int m_frameWidth = 560;
    private final static int m_frameHeight = 395;

	private BasePanel dialogTopPanel = null;
	private TableList ListTable = null;
	private JScrollPane ScrollPane = null;

	public DlgPbleBudgetEst(MainFrame owner) {
        super(owner, "okyesnocancel", m_frameWidth, m_frameHeight);
        initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Possible Budget Estimation");
    	setContentPane(getDialogTopPanel());
    	// change label
		getButtonById(OK).setText("Copy Form A");
		getButtonById(YES).setText("Copy Form B");
		getButtonById(NO).setText("Copy Both");

	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String patNo, String patName, String docCode) {
		setVisible(false);

		QueryUtil.executeMasterBrowse(getUserInfo(), "CHKEXTFINEST",
				new String[] { patNo,patName,docCode },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getListTable().setListTableContent(mQueue);
				}
			}
		});
		setVisible(true);
	}
	
	@Override
	protected void doOkAction() {
		//Copy Both
			if (getListTable().getSelectedRow() >= 0) {
				post(getListTable().getSelectedRowContent(),"A");
			} else {
				Factory.getInstance().addErrorMessage("Select a slip, please!");
			}
	}
	
	@Override
	protected void doNoAction() {
		//Copy Both
			if (getListTable().getSelectedRow() >= 0) {
				post(getListTable().getSelectedRowContent(),"both");
			} else {
				Factory.getInstance().addErrorMessage("Select a slip, please!");
			}
	}
	
	@Override
	protected void doYesAction() {
			if (getListTable().getSelectedRow() >= 0) {
				post(getListTable().getSelectedRowContent(),"B");
			} else {
				Factory.getInstance().addErrorMessage("Select a slip, please!");
			}
	}
	
	public abstract void post(String[] value,String option);

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getDialogTopPanel() {
		if (dialogTopPanel == null) {
			dialogTopPanel = new BasePanel();
			dialogTopPanel.setBounds(0, 0, 530, 310);
			dialogTopPanel.add(getScrollPane(), null);
		}
		return dialogTopPanel;
	}

	public TableList getListTable() {
		if (ListTable == null) {
			ListTable = new TableList(getColumnNames(), getColumnWidths());
		}
		return ListTable;
	}

	public JScrollPane getScrollPane() {
		if (ScrollPane == null) {
			ScrollPane = new JScrollPane();
			ScrollPane.setBounds(5, 5, 520, 300);
			ScrollPane.setViewportView(getListTable());
		}
		return ScrollPane;
	}

	private int[] getColumnWidths() {
		return new int[] { 120,50, 120, 80,0, 150,120,
						   50,0, 50, 80, 80,80,
						   80,80,80,80,80,
						   80,80,80,80,80,
						   80,80,80};
	}

	private String[] getColumnNames() {
		return new String[] {
					"Create Date","Pat No.","Pat Name","Dr. Code","proccode","Procedure","Diagnosis", //5
					"LOS","acmcode","ACM","Dr.Round Fee Min","Dr.Round Fee Max","Surgical Fee Min","Surgical Fee Max",
					"Anaesthetist Fee Min","Anaesthetist Fee Max","Other Sp Fee Min","Other Sp Fee Max","Other Dr Fee Min",
					"Other Dr Fee Max","Rm Charge Min","Rm Charge Max","OT Fee Min","OT Fee Max",
					"Other Hos Fee Min","Other Hos Fee Max"
				};
	}
}