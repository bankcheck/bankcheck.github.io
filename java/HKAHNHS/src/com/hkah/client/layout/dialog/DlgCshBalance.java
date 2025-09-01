package com.hkah.client.layout.dialog;

import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.label.LabelSmallBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgCshBalance extends DialogBase {
	/**
	 *
	 */
	private static final long serialVersionUID = 1L;
	private final static int m_frameWidth = 440;
	private final static int m_frameHeight = 490;
	private BasePanel cshBalancePanel = null;
	private FieldSetBase statisticPanel = null;
	private BasePanel numPanel = null;
	private TableList statListTable = null;
	private JScrollPane statScrollPane = null;
	private LabelSmallBase ARDesc = null;
	private LabelSmallBase ARPrefix = null;
	private TextReadOnly AR = null;
	private LabelSmallBase NoOfCRDesc = null;
	private TextReadOnly NoOfCR;
	private LabelSmallBase NoOfReprintDesc = null;
	private TextReadOnly NoOfReprint = null;
	private LabelSmallBase NoOfVoidDesc = null;
	private TextReadOnly NoOfVoid = null;

	public DlgCshBalance(MainFrame owner) {
		super(owner, OKCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Cashier Balance Statistic ");
		setContentPane(getCshBalancePanel());

		getStatListTable().setColumnAmount(2);
		getStatListTable().setColumnAmount(3);
		getStatListTable().setColumnAmount(4);

		// change label
		getButtonById(DialogBase.CANCEL).setText("Refresh");
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog() {
		setVisible(true);

		getButtonById(DialogBase.CANCEL).setEnabled("YES".equals(getMainFrame().getSysParameter("CshBalRef")));

		showBalance();
	}

	public void showBalance() {
		if (getUserInfo().isCashier()) {
			Factory.getInstance().showMask(getCshBalancePanel());

			QueryUtil.executeMasterBrowse(getUserInfo(),
					ConstantsTx.CASHSTAT_TXCODE,
					new String[] { getUserInfo().getCashierCode() },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						getStatListTable().setListTableContent(mQueue);
						getAR().setText(TextUtil.formatCurrency(mQueue.getContentField()[5]));
						getNoOfCR().setText(mQueue.getContentField()[6]);
						getNoOfReprint().setText(mQueue.getContentField()[7]);
						getNoOfVoid().setText(mQueue.getContentField()[8]);
					}
				}

				@Override
				public void onComplete() {
					super.onComplete();
					Factory.getInstance().hideMask(getCshBalancePanel());
				}
			});
		}
	}

	protected void doCancelAction() {
		if (getUserInfo().isCashier()) {
			QueryUtil.executeMasterAction(getUserInfo(),
					ConstantsTx.CASHSTAT_TXCODE,
					QueryUtil.ACTION_APPEND,
					new String[] { getUserInfo().getCashierCode() },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					showBalance();
				}
			});
		}
	}

	/***************************************************************************
	* Layout Method
	**************************************************************************/

	public BasePanel getCshBalancePanel() {
		if (cshBalancePanel == null) {
			cshBalancePanel = new BasePanel();
			cshBalancePanel.setBounds(0, 0, 410, 420);
			cshBalancePanel.add(getStatisticPanel(), null);
		}
		return cshBalancePanel;
	}

	public FieldSetBase getStatisticPanel() {
		if (statisticPanel == null) {
			statisticPanel = new FieldSetBase();
			statisticPanel.setBounds(5, 5, 398, 395);
			statisticPanel.setHeading("Cashier Statistic");
			statisticPanel.add(getStatScrollPane(), null);
			statisticPanel.add(getARDesc(), null);
			statisticPanel.add(getARPrefix(), null);
			statisticPanel.add(getAR(), null);
			statisticPanel.add(getNumPanel(), null);
		}
		return statisticPanel;
	}

	public TableList getStatListTable() {
		if (statListTable == null) {
			statListTable = new TableList(getStatColumnNames(), getStatColumnWidths());
		}
		return statListTable;
	}

	public JScrollPane getStatScrollPane() {
		if (statScrollPane == null) {
			statScrollPane = new JScrollPane();
			statScrollPane.setBounds(5, 0, 385, 255);
			statScrollPane.setViewportView(getStatListTable());
		}
		return statScrollPane;
	}

	private String[] getStatColumnNames() {
		return new String[] { "", "Type", "Receipt", "Payout", "Net", "", "", "", "" };
	}

	private int[] getStatColumnWidths() {
		return new int[] { 0, 150, 75, 75, 75, 0, 0, 0, 0 };
	}

	public LabelSmallBase getARDesc() {
		if (ARDesc == null) {
			ARDesc = new LabelSmallBase();
			ARDesc.setBounds(110, 260, 50, 20);
			ARDesc.setText("AR");
		}
		return ARDesc;
	}

	private LabelSmallBase getARPrefix() {
		if (ARPrefix == null) {
			ARPrefix = new LabelSmallBase();
			ARPrefix.setBounds(180, 260, 50, 20);
			ARPrefix.setText("$");
		}
		return ARPrefix;
	}

	public TextReadOnly getAR() {
		if (AR == null) {
			AR = new TextReadOnly();
			AR.setBounds(190, 260, 80, 20);
		}
		return AR;
	}

	public BasePanel getNumPanel() {
		if (numPanel == null) {
			numPanel = new BasePanel();
			numPanel.setBounds(59, 285, 220, 80);
			numPanel.setEtchedBorder();
			numPanel.add(getNoOfCRDesc(), null);
			numPanel.add(getNoOfCR(), null);
			numPanel.add(getNoOfReprintDesc(), null);
			numPanel.add(getNoOfReprint(), null);
			numPanel.add(getNoOfVoidDesc(), null);
			numPanel.add(getNoOfVoid(), null);
		}
		return numPanel;
	}

	public LabelSmallBase getNoOfCRDesc() {
		if (NoOfCRDesc == null) {
			NoOfCRDesc = new LabelSmallBase();
			NoOfCRDesc.setText("No. of CR issued");
			NoOfCRDesc.setBounds(5, 5, 120, 20);
		}
		return NoOfCRDesc;
	}

	public TextReadOnly getNoOfCR() {
		if (NoOfCR == null) {
			NoOfCR = new TextReadOnly();
			NoOfCR.setBounds(130, 5, 80, 20);
		}
		return NoOfCR;
	}

	public LabelSmallBase getNoOfReprintDesc() {
		if (NoOfReprintDesc == null) {
			NoOfReprintDesc = new LabelSmallBase();
			NoOfReprintDesc.setText("No. of Reprint");
			NoOfReprintDesc.setBounds(5, 30, 120, 20);
		}
		return NoOfReprintDesc;
	}

	public TextReadOnly getNoOfReprint() {
		if (NoOfReprint == null) {
			NoOfReprint = new TextReadOnly();
			NoOfReprint.setBounds(130, 30, 80, 20);
		}
		return NoOfReprint;
	}

	public LabelSmallBase getNoOfVoidDesc() {
		if (NoOfVoidDesc == null) {
			NoOfVoidDesc = new LabelSmallBase();
			NoOfVoidDesc.setText("No. of Void");
			NoOfVoidDesc.setBounds(5, 55, 120, 20);
		}
		return NoOfVoidDesc;
	}

	public TextReadOnly getNoOfVoid() {
		if (NoOfVoid == null) {
			NoOfVoid = new TextReadOnly();
			NoOfVoid.setBounds(130, 55, 80, 20);
		}
		return NoOfVoid;
	}
}