/*
 * Created on January 7, 2015
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.hkah.client.layout.dialog;

import com.hkah.client.MainFrame;
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
public class DlgTxHistory extends DialogBase {

    private final static int m_frameWidth = 560;
    private final static int m_frameHeight = 395;

	private BasePanel dialogTopPanel = null;
	private TableList slipTxListTable = null;
	private JScrollPane slipTxScrollPane = null;

	public DlgTxHistory(MainFrame owner) {
        super(owner, OK, m_frameWidth, m_frameHeight);
        initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("The slip has future service date item(s)");
    	setContentPane(getDialogTopPanel());
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String slipNo) {
		setVisible(false);

		QueryUtil.executeMasterBrowse(getUserInfo(), "TXNSLIP_AFTERDISCHARGE",
				new String[] { slipNo },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getslipTxListTable().setListTableContent(mQueue);
					setVisible(true);
				}
			}
		});
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getDialogTopPanel() {
		if (dialogTopPanel == null) {
			dialogTopPanel = new BasePanel();
			dialogTopPanel.setBounds(0, 0, 530, 310);
			dialogTopPanel.add(getslipTxScrollPane(), null);
		}
		return dialogTopPanel;
	}

	public TableList getslipTxListTable() {
		if (slipTxListTable == null) {
			slipTxListTable = new TableList(getslipTxColumnNames(), getslipTxColumnWidths());
		}
		return slipTxListTable;
	}

	public JScrollPane getslipTxScrollPane() {
		if (slipTxScrollPane == null) {
			slipTxScrollPane = new JScrollPane();
			slipTxScrollPane.setBounds(5, 5, 520, 300);
			slipTxScrollPane.setViewportView(getslipTxListTable());
		}
		return slipTxScrollPane;
	}

	private int[] getslipTxColumnWidths() {
		return new int[] { 50, 120, 80, 250 };
	}

	private String[] getslipTxColumnNames() {
		return new String[] {
				"Seq#",
				"Service date / time",
				"Item Code",
				"Description"};
	}
}