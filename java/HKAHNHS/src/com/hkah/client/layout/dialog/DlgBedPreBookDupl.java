package com.hkah.client.layout.dialog;

import com.extjs.gxt.ui.client.widget.Dialog;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public abstract class DlgBedPreBookDupl extends DialogBase {
    private final static int m_frameWidth = 370;
    private final static int m_frameHeight = 120;

	private int tableListWidth = 0;
	private JScrollPane JScrollPane_CheckListTable = null;
	private TableList CheckListTable = null;
	private DialogBase duplicateDialog = null;
	private DialogBase thisDialog = this;

	public DlgBedPreBookDupl(MainFrame owner) {
		super(owner, YESNOCANCEL, m_frameWidth, m_frameHeight);
        initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("PBA - Bed-Prebok confirmation");
		addText("<html><br>Some possible duplicate bookings have been found.</html>");

    	// change label
		getButtonById(Dialog.YES).setText("View");
		getButtonById(Dialog.NO).setText("Save");

	    setVisible(false);
	}

	public abstract void continueAction();

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String actionType, String patNo, String docNo, String familyName, String givenName) {
	    setVisible(false);

		QueryUtil.executeMasterBrowse(getUserInfo(), "DUPLPREBOK",
				new String[] {
					actionType,
					patNo,
					docNo,
					familyName,
					givenName
				},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getCheckListTable().setListTableContent(mQueue);
					if (getCheckListTable().getRowCount() > 0) {
						thisDialog.setVisible(true);
					} else {
						doNoAction();
					}
				} else {
					doNoAction();
				}
			}

			@Override
			public void onFailure(Throwable caught) {
				Factory.getInstance().addErrorMessage("Check possible duplicate pre-booking error.");
				super.onFailure(caught);
			}
		});
	}

	@Override
	protected void doYesAction() {
		setVisible(false);
		getDuplicationCheckDialog().setVisible(true);
	}

	@Override
	protected void doNoAction() {
		dispose();
		continueAction();
	}

	/***************************************************************************
	 * Duplication Dialogbox
	 **************************************************************************/

	private JScrollPane getJScrollPane_CheckListTable() {
		if (JScrollPane_CheckListTable == null) {
			JScrollPane_CheckListTable = new JScrollPane();
			JScrollPane_CheckListTable.setViewportView(getCheckListTable());
			//JScrollPane_CheckListTable.setBounds(new Rectangle(0, 0, 680, 360));
			JScrollPane_CheckListTable.setSize(670, 360);
		}
		return JScrollPane_CheckListTable;
	}

	private TableList getCheckListTable() {
		if (CheckListTable == null) {
			CheckListTable = new TableList(getPreListTableColumnNames(), getPreListTableColumnWidths());
			CheckListTable.setTableLength(tableListWidth);
		}
		return CheckListTable;
	}

	protected String[] getPreListTableColumnNames() {
		return new String[] {"",
				"Reg Type",
				"Patient Name",
				"Patient No",
				"Document #",
				"Ordered By",
				"Ward",
				"Schd Adm Date",
				"Order Date",
				"Created By"
		};
	}

	protected int[] getPreListTableColumnWidths() {
		return new int[] {10, 60, 130, 80, 80, 130, 65, 130, 130, 130};
	}

	private DialogBase getDuplicationCheckDialog() {
		if (duplicateDialog == null) {
			duplicateDialog = new DialogBase(getMainFrame(), null, 700, 410) {
				@Override
				public void onClose() {
					thisDialog.setVisible(true);
				}
			};
			duplicateDialog.setHeading("PBA - Bed Pre-Booking Similar Record List");
			duplicateDialog.add(getJScrollPane_CheckListTable());
		}
		return duplicateDialog;
	}
}