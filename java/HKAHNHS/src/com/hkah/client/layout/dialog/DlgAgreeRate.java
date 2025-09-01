/*
 * Created on July 3, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.hkah.client.layout.dialog;

import java.util.ArrayList;
import java.util.List;

import com.extjs.gxt.ui.client.event.BaseEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.Listener;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.panel.TabbedPaneBase;
import com.hkah.client.layout.table.TableData;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextAreaBase;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsTableColumn;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;
import com.hkah.shared.model.UserInfo;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class DlgAgreeRate extends DialogBase implements ConstantsTableColumn {

    private final static int m_frameWidth = 450;
    private final static int m_frameHeight = 280;

	private BasePanel dialogTopPanel = null;
	private TableList specListTable = null;
	private JScrollPane specScrollPane = null;


	public DlgAgreeRate(MainFrame owner) {
        super(owner, OK, m_frameWidth, m_frameHeight);
        initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Agree Rate by Doctor");

		setContentPane(getDialogTopPanel());
		addListener(Events.Hide, new Listener<BaseEvent>() {
			@Override
			public void handleEvent(BaseEvent be) {
				dlgClose();
			}
		});
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

	public void showDialog(final String data) {
		setVisible(false);
		getSpecListTable().removeAllRow();
		if(data != null) {
			String[] record = TextUtil.split(data, "<L/>");
			String[] fields = null;
			for (int i = 0; i < record.length; i++) {
				fields = TextUtil.split(record[i],"<F/>");
				if (!"<F/>".equals(record[i])) {
					getSpecListTable().addRow(fields);
				}
			}
		}
		setVisible(true);
	}

	protected void dlgClose() {
		post(true);
	};


	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getDialogTopPanel() {
		if (dialogTopPanel == null) {
			dialogTopPanel = new BasePanel();
			dialogTopPanel.setBounds(0, 0, 420, 190);
			dialogTopPanel.add(getSpecScrollPane(), null);
		}
		return dialogTopPanel;
	}


	public JScrollPane getSpecScrollPane() {
		if (specScrollPane == null) {
			specScrollPane = new JScrollPane();
			specScrollPane.setBounds(5, 5, 415, 166);
			specScrollPane.setViewportView(getSpecListTable());
		}
		return specScrollPane;
	}

	public TableList getSpecListTable() {
		if (specListTable == null) {
			specListTable = new TableList(getSpecColumnNames(), getSpecColumnWidths());
		}
		return specListTable;
	}

	private int[] getSpecColumnWidths() {
		return new int[] { 50, 70, 70, 70, 70, 70 };
	}

	private String[] getSpecColumnNames() {
		return new String[] { "Dr. Code", "Item Code", "Amt from", "Amt To", "Dis. from","Dis. To" };
	}




}