/*
 * Created on July 3, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.hkah.client.layout.dialog;


import com.hkah.client.MainFrame;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
@SuppressWarnings("serial")
public abstract class DlgSelectSlip extends DialogBase {

    private final static int m_frameWidth = 670;
    private final static int m_frameHeight = 465;

	private BasePanel dialogTopPanel = null;
	private TableList specListTable = null;
	private JScrollPane specScrollPane = null;
	private ButtonBase BtnOk;
	private ButtonBase BtnCancel;
	protected String selectSlpNo;

	public DlgSelectSlip(MainFrame owner) {
        super(owner,m_frameWidth, m_frameHeight);
        initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Select Slip");
    	setContentPane(getDialogTopPanel());

		setVisible(true);
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String currentRegID) {
		QueryUtil.executeMasterBrowse(getUserInfo(),ConstantsTx.SELECTSLIP_TXCODE,
				new String[] {currentRegID},
				new MessageQueueCallBack() {
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getSpecListTable().setListTableContent(mQueue);
				}

			}
		});

		setVisible(true);
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getDialogTopPanel() {
		if (dialogTopPanel == null) {
			dialogTopPanel = new BasePanel();
			dialogTopPanel.setBounds(0, 0, 640, 380);
			dialogTopPanel.add(getSpecScrollPane(), null);
			dialogTopPanel.add(getBtnOk(), null);
			dialogTopPanel.add(getBtnCancel(), null);
		}
		return dialogTopPanel;
	}

	public TableList getSpecListTable() {
		if (specListTable == null) {
			specListTable = new TableList(getSpecColumnNames(), getSpecColumnWidths());
		}
		return specListTable;
	}

	public JScrollPane getSpecScrollPane() {
		if (specScrollPane == null) {
			specScrollPane = new JScrollPane();
			specScrollPane.setBounds(5, 5, 630, 370);
			specScrollPane.setViewportView(getSpecListTable());
		}
		return specScrollPane;
	}

	private int[] getSpecColumnWidths() {
		return new int[] { 0, 80, 70, 70, 80, 100, 140, 0, 170, 0, 0, 0, 0, 0, 0};
	}

	private String[] getSpecColumnNames() {
		return new String[] {
				"",
				"Slip No.",				
				"Type",
				"Slip Status",
				"Patient No",
				"Patient Family Name",
				"Patient Given Name",
				"",
				"Doctor Code",
				"",
				"",
				"",
				"",
				"",				
				""};
	}

	private ButtonBase getBtnOk() {
		if (BtnOk == null) {
			BtnOk = new ButtonBase("OK") {
				@Override
				public void onClick() {
					selectSlpNo = specListTable.getSelectedRowContent()[1];
					post();
					dispose();
				}
			};
			BtnOk.setBounds(235, 390, 50, 20);
		}
		return BtnOk;
	}

	private ButtonBase getBtnCancel() {
		if (BtnCancel == null) {
			BtnCancel = new ButtonBase("Cancel") {
				@Override
				public void onClick() {
					// TODO Auto-generated method stub
					super.onClick();
					dispose() ;
				}
			};
			BtnCancel.setBounds(350, 390, 50, 20);
		}
		return BtnCancel;
	}

	public abstract void post();
}