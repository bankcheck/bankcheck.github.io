/*
 * Created on July 3, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.hkah.client.layout.dialog;

import com.extjs.gxt.ui.client.widget.Dialog;
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
public class DlgOSBillAlert extends DialogBase {

	private final static int m_frameWidth = 460;
	private final static int m_frameHeight = 290;

	private BasePanel dialogTopPanel = null;
	private TableList specListTable = null;
	private JScrollPane specScrollPane = null;

	public DlgOSBillAlert(MainFrame owner) {
		super(owner, Dialog.OK, m_frameWidth, m_frameHeight);
		init();
	}

	protected void init() {
		setTitle("Outstanding Bill");

		setContentPane(getDialogTopPanel());
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected void doOkAction() {
		post(true);
		super.doOkAction();
	}

	protected void post(boolean success) {
		// for child class implement
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String patno) {
		setVisible(false);

		String osAlert = Factory.getInstance().getMainFrame().getSysParameter("OSALERT");

		// check system param
		if (osAlert != null
				&& osAlert.length() > 0
				&& YES_VALUE.equals(osAlert.toUpperCase())) {
			QueryUtil.executeMasterBrowse(Factory.getInstance().getUserInfo(),
					"OSBILLALERT", new String[] { patno },
					new MessageQueueCallBack() {
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						getSpecListTable().setListTableContent(mQueue);
						setVisible(true);
					} else {
						post(false);
					}
				}
			});
		} else {
			post(false);
		}
	}

	/***************************************************************************
	* Layout Method
	**************************************************************************/

	public BasePanel getDialogTopPanel() {
		if (dialogTopPanel == null) {
			dialogTopPanel = new BasePanel();
			dialogTopPanel.setBounds(5, 5, 420, 195);
			dialogTopPanel.add(getSpecScrollPane(), null);
		}
		return dialogTopPanel;
	}

	public TableList getSpecListTable() {
		if (specListTable == null) {
			specListTable = new TableList(getSpecColumnNames(), getSpecColumnWidths());
			specListTable.setColumnAmount(2);
		}
		return specListTable;
	}

	public JScrollPane getSpecScrollPane() {
		if (specScrollPane == null) {
			specScrollPane = new JScrollPane();
			specScrollPane.setBounds(0, 0, 420, 195);
			specScrollPane.setViewportView(getSpecListTable());
		}
		return specScrollPane;
	}

	private int[] getSpecColumnWidths() {
		return new int[] { 90, 150, 150};
	}

	private String[] getSpecColumnNames() {
		return new String[] { "Patient Type", "Slip No.", "Amount($)"};
	}
}