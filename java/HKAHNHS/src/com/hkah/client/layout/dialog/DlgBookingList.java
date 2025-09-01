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
public class DlgBookingList extends DialogBase {

	private final static int m_frameWidth = 500;
	private final static int m_frameHeight = 290;

	private BasePanel dialogTopPanel = null;
	private TableList listTable = null;
	private JScrollPane scrollPane = null;

	public DlgBookingList(MainFrame owner) {
		super(owner, Dialog.OK, m_frameWidth, m_frameHeight);
		init();
	}

	protected void init() {
		setTitle("Booking List");

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

	public void showDialog(String patno,String pbpNo, String bkgID) {
		setVisible(false);

		String bkListDiag = Factory.getInstance().getMainFrame().getSysParameter("BKLISTDIG");

		// check system param
		if (bkListDiag != null
				&& bkListDiag.length() > 0
				&& YES_VALUE.equals(bkListDiag.toUpperCase())) {
			QueryUtil.executeMasterBrowse(Factory.getInstance().getUserInfo(),
					"BOOKINGDIAG", new String[] { patno,pbpNo, bkgID },
					new MessageQueueCallBack() {
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						getListTable().setListTableContent(mQueue);
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
			dialogTopPanel.setBounds(5, 5, 460, 195);
			dialogTopPanel.add(getScrollPane(), null);
		}
		return dialogTopPanel;
	}

	public TableList getListTable() {
		if (listTable == null) {
			listTable = new TableList(getColumnNames(), getColumnWidths());
			listTable.setColumnAmount(2);
		}
		return listTable;
	}

	public JScrollPane getScrollPane() {
		if (scrollPane == null) {
			scrollPane = new JScrollPane();
			scrollPane.setBounds(0, 0, 460, 195);
			scrollPane.setViewportView(getListTable());
		}
		return scrollPane;
	}

	private int[] getColumnWidths() {
		return new int[] { 80, 80, 150,150};
	}

	private String[] getColumnNames() {
		return new String[] { "Patient Type", "Dr.Code", "Dr.Name","App.Date"};
	}
}