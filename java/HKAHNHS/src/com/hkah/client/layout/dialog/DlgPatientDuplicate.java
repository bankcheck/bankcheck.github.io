package com.hkah.client.layout.dialog;

import com.extjs.gxt.ui.client.widget.Dialog;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public abstract class DlgPatientDuplicate extends DialogBase {
    private final static int m_frameWidth = 370;
    private final static int m_frameHeight = 120;

	private int tableListWidth = 0;
	private JScrollPane JScrollPane_CheckListTable = null;
	private TableList CheckListTable = null;
	private DialogBase duplicateDialog = null;
	private DialogBase thisDialog = this;

	public DlgPatientDuplicate(MainFrame owner) {
		super(owner, YESNOCANCEL, m_frameWidth, m_frameHeight);
	initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("PBA - Create Patient Confirmation");
		addText("<html><br>Some possible patients have been found.</html>");

	// change label
		getButtonById(Dialog.YES).setText("View");
		getButtonById(Dialog.NO).setText("Create");

	    setVisible(false);
	}

	public abstract void continueAction();

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String patNo, String birthday, String familyName, String givenName) {
	    setVisible(false);

		QueryUtil.executeMasterBrowse(getUserInfo(), "DUPLPATIENT",
				new String[] {
					patNo,
					birthday,
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
				Factory.getInstance().addErrorMessage("Check possible duplicate patients error.");
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
		return new String[] {
				"Patient No",		// PATNO
				"Family Name",		// PATFNAME
				"Given name",		// PATGNAME
				"Maiden Name",		// PATMNAME
				"Chinese Name",		// PATCNAME
				"EHR Family Name",	// E.EHRFNAME
				"EHR Given Name",	// E.EHRGNAME
				"Sex",				// PATSEX
				"Date of Birth",	// PATBDATE
				"Mobile Phone",		// PATPAGER
				"Home Phone",		// PATHTEL
				"ID Number",		// PATIDNO
				"No. of Visit",		// PATVCNT
				"Last Visit"		// LASTUPD
		};
	}

	protected int[] getPreListTableColumnWidths() {
		return new int[] {
				60,		// PATNO
				70,		// PATFNAME
				110,	// PATGNAME
				80,		// PATMNAME
				85,		// PATCNAME
				0, 	// E.EHRFNAME
				0,	// E.EHRGNAME
				30,		// PATSEX
				70,		// PATBDATE
				75,		// PATPAGER
				75,		// PATHTEL
				60,		// PATIDNO
				65,		// PATVCNT
				65		// LASTUPD
		};
	}

	private DialogBase getDuplicationCheckDialog() {
		if (duplicateDialog == null) {
			duplicateDialog = new DialogBase(getMainFrame(), null, 700, 410) {
				@Override
				public void onClose() {
					thisDialog.setVisible(true);
				}
			};
			duplicateDialog.setHeading("PBA - Patient Similar Record List");
			duplicateDialog.add(getJScrollPane_CheckListTable());
		}
		return duplicateDialog;
	}
}