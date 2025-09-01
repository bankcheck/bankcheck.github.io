/*
 * Created on July 3, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.hkah.client.layout.dialog;

import com.hkah.client.MainFrame;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.TableList;
import com.hkah.shared.model.MessageQueue;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class DlgEhrPmiDupl extends DialogBase {

    private final static int m_frameWidth = 900;
    private final static int m_frameHeight = 200;

	private BasePanel dialogTopPanel = null;
	private TableList ehrPmiListTable = null;
	private JScrollPane ehrPmiScrollPane = null;

	public DlgEhrPmiDupl(MainFrame owner, String methodType) {
        super(owner, OKCANCEL, m_frameWidth, m_frameHeight);
		init(methodType);
	}

	protected void init(String methodType) {
		setTitle("Duplicate PMI found" + (methodType == null ? "" : " (Check type: " + methodType + ")"));
		setContentPane(getDialogTopPanel());
		getButtonById(DialogBase.OK).setText("Save Anyway");
		getButtonById(DialogBase.CANCEL).setText("Cancel");
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected void doOkAction() {
		post();
		super.doOkAction();
	}
	
	protected void post() {
		// for child class implement
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(MessageQueue mQueue) {
		getEhrPmiListTable().setListTableContent(mQueue);
	    setVisible(true);
	}

	/***************************************************************************
	* Layout Method
	**************************************************************************/

	public BasePanel getDialogTopPanel() {
		if (dialogTopPanel == null) {
			dialogTopPanel = new BasePanel();
			dialogTopPanel.setBounds(5, 5, 860, 105);
			dialogTopPanel.add(getEhrPmiScrollPane(), null);
		}
		return dialogTopPanel;
	}

	public TableList getEhrPmiListTable() {
		if (ehrPmiListTable == null) {
			ehrPmiListTable = new TableList(getEhrPmiColumnNames(), getEhrPmiColumnWidths());
		}
		return ehrPmiListTable;
	}

	public JScrollPane getEhrPmiScrollPane() {
		if (ehrPmiScrollPane == null) {
			ehrPmiScrollPane = new JScrollPane();
			ehrPmiScrollPane.setBounds(0, 0, 860, 105);
			ehrPmiScrollPane.setViewportView(getEhrPmiListTable());
		}
		return ehrPmiScrollPane;
	}

	private int[] getEhrPmiColumnWidths() {
		return new int[] { 80, 100, 100, 100, 80, 40, 30, 80, 120, 120};
	}

	private String[] getEhrPmiColumnNames() {
		return new String[] { "Patient No.", "eHR No.", "Family Name", "Given Name",
				"Date of Birth", "Exact DOB ind.", "Sex", "HKID No.", 
				"Type of Identity Document", "Identity Document Number"
		};
	}
}