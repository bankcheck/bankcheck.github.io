package com.hkah.client.layout.dialog;

import com.extjs.gxt.ui.client.event.BaseEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.Listener;
import com.hkah.client.MainFrame;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTableColumn;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class DlgDIReportHist extends DialogBase implements ConstantsTableColumn {

    private final static int m_frameWidth = 450;
    private final static int m_frameHeight = 280;

	private BasePanel dialogTopPanel = null;
	private TableList specListTable = null;
	private JScrollPane specScrollPane = null;

	public DlgDIReportHist(MainFrame owner) {
        super(owner, OK, m_frameWidth, m_frameHeight);
        initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Report History");

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

	public void showDialog(String xrgid) {
		setVisible(false);

		QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.ECGREPORTEDITOR_TXCODE,
				new String[] { "HIST", xrgid },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getSpecListTable().setListTableContent(mQueue);
					setVisible(true);
				} else {
					post(false);
				}
			}
		});
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
			//dialogTopPanel.add(getAlertTabbedPanel(), null);
			dialogTopPanel.add(getSpecScrollPane(), null);
		}
		return dialogTopPanel;
	}

	public JScrollPane getSpecScrollPane() {
		if (specScrollPane == null) {
			specScrollPane = new JScrollPane();
			specScrollPane.setBounds(0, 0, 420, 190);
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
		return new int[] { 
				120, 60, 355, 80, 80,
				50, 80, 0, 120, 0, 
				0, 0
				};
	}

	private String[] getSpecColumnNames() {
		return new String[] { 
				"Report Date", "Report Dr.", "Report Title", "Perform", "Typist", 
				"Status", "Approve By", "", "Approve Date", "" ,
				"", ""
				};
	}

}