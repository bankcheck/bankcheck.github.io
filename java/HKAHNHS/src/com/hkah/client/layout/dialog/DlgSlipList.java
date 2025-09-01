package com.hkah.client.layout.dialog;

import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.BufferedTableList;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public abstract class DlgSlipList extends DialogBase {
	private final static int m_frameWidth = 650;
	private final static int m_frameHeight = 380;

	private BufferedTableList slipListTable = null;
	private BasePanel contentPanel = null;
	private JScrollPane slipListScrollPane = null;

	public DlgSlipList(MainFrame owner) {
		super(owner, OKCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Slip List");
		setContentPane(getContentPanel());

		// change label
		getButtonById(OK).setText("Accept", 'A');

		getSlipListTable().setColumnAmount(17);
		getSlipListTable().setColumnAmount(18);
		getSlipListTable().setColumnAmount(19);
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String patno) {
		showDialog(patno, null);
	}

	public void showDialog(String patno, String slpSts) {
		setVisible(false);

		getSlipListTable().removeAllRow();
		QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.TRANSACTION_DETAIL_TXCODE,
				new String[] {
					patno,
					EMPTY_VALUE,
					EMPTY_VALUE,
					slpSts==null?EMPTY_VALUE:slpSts,
					EMPTY_VALUE,
					EMPTY_VALUE,
					EMPTY_VALUE,
					EMPTY_VALUE,
					NO_VALUE,
					Factory.getInstance().getUserInfo().getUserID()
				},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getSlipListTable().setListTableContent(mQueue);
					setVisible(true);
				} else {
					Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_NO_RECORD_FOUND);
				}
			}
		});

		getButtonById(OK).setEnabled(!Factory.getInstance().isDisableFunction("mnuTransDetail", ""));
	}

	@Override
	protected void doOkAction() {
		if (!Factory.getInstance().isDisableFunction("mnuTransDetail", "")) {
			if (getSlipListTable().getSelectedRow() >= 0) {
				post(getSlipListTable().getSelectedRowContent()[4]);
			} else {
				Factory.getInstance().addErrorMessage("Select a slip, please!");
			}
		}
	}

	public abstract void post(String slipNo);

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	private BasePanel getContentPanel() {
		if (contentPanel == null) {
			contentPanel = new BasePanel();
			contentPanel.setBounds(0, 0, 650, 380);
			contentPanel.add(getSlipListScrollPane(), null);
		}
		return contentPanel;
	}

	private JScrollPane getSlipListScrollPane() {
		if (slipListScrollPane == null) {
			slipListScrollPane = new JScrollPane();
			slipListScrollPane.setBounds(5, 5, 612, 290);
			slipListScrollPane.setViewportView(getSlipListTable());
		}
		return slipListScrollPane;
	}

	protected BufferedTableList getSlipListTable() {
		if (slipListTable == null) {
			slipListTable = new BufferedTableList(getSlipListColumnNames(), getSlipListColumnWidths());
		}
		return slipListTable;
	}

	private int[] getSlipListColumnWidths() {
		return new int[] {
				15,
				15,
				20,
				YES_VALUE.equals(getMainFrame().getSysParameter("TxRegDt")) ? 110 : 0,
				80,
				35,
				40,
				55,
				60,
				60,
				110,
				110,
				55,
				90,
				120,
				110,
				110,
				85,
				90,
				100,
				60,
				0,
				0,
				0,
				110
		};
	}

	private String[] getSlipListColumnNames() {
		return new String[] {
				EMPTY_VALUE,
				EMPTY_VALUE,
				EMPTY_VALUE,
				"Reg Date",
				"Slip No.",
				"Type",
				"Status",
				"AR Code",
				"AR Name",
				"Patient No",
				"Patient Family Name",
				"Patient Given Name",
				"Dr. Code",
				"Dr. Family Name",
				"Dr. Given Name",
				"Reg Date",
				"Discharge Date",
				"Total Charge",
				"Total Payment",
				"Total Net Amount",
				"User ID",
				EMPTY_VALUE,
				EMPTY_VALUE,
				EMPTY_VALUE,
				"Slip Date"
		};
	}
}