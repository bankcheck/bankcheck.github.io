package com.hkah.client.layout.dialog;

import java.util.List;

import com.hkah.client.MainFrame;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextAreaBase;
import com.hkah.client.layout.textfield.TextRemark;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgPaymentInstruction extends DialogBase {
	private final static int m_frameWidth = 735;
	private final static int m_frameHeight = 390;

	private BasePanel piPanel = null;
	private JScrollPane piScroll = null;
	private TableList piList = null;
	private TextRemark piRemark = null;

	public DlgPaymentInstruction(MainFrame mainFrame) {
		super(mainFrame, OK, m_frameWidth, m_frameHeight);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Payment Instruction");
		setContentPane(getPiPanel());
		getPiRemark().setEditable(false);
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(final String slpno) {
		getPiList().removeAllRow();
		QueryUtil.executeMasterFetch(
				getUserInfo(), "ISSHWPYINSTN", new String[] { slpno },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					String cnt = mQueue.getContentField()[0];
					if (cnt != null && Integer.valueOf(cnt) > 0) {
						showDetailInstruction(slpno);
					} else {
						dispose();
					}
				} else {
					dispose();
				}
			}});
		
//		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_WITHDB_TXCODE,
//				new String[] { "doctor", "count(1)", "payinstruction is not null and (doccode in (select distinct doccode from sliptx where stnsts = 'N' and slpno = '" + slpno + "') or doccode in (select doccode  from slip where slpno = '" + slpno + "'))"},
//				new MessageQueueCallBack() {
//			@Override
//			public void onPostSuccess(MessageQueue mQueue) {
//				if (mQueue.success()) {
//					String cnt = mQueue.getContentField()[0];
//					if (cnt != null && Integer.valueOf(cnt) > 0) {
//						showDetailInstruction(slpno);
//					} else {
//						dispose();
//					}
//				} else {
//					dispose();
//				}
//			}
//		});
	}

	private void showDetailInstruction(String slpno) {
		QueryUtil.executeMasterFetch(
				getUserInfo(), "DRPYINSTN", new String[] { slpno },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					List<String[]> results = mQueue.getContentAsArray();
					for (String[] res : results) {
						if (res != null) {
							getPiList().addRow(new String[] {
									res[0],
									res[1],
									res[2],
									res[3]
							});
						}
					}

					if (results.size()>0) {
						getPiRemark().setText(getPiList().getValueAt(0, 2));
						getPiRemark().setText("Payment Instruction:\n"+getPiList().getValueAt(0, 2)
								+"\nStaff Medical Instruction:\n"+getPiList().getValueAt(0, 3));
					}
				}
			}});
		
//		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_WITHDB_TXCODE,
//				new String[] {
//			"doctor a, (select distinct doccode, slpno from (select distinct doccode, slpno from sliptx where stnsts = 'N' and slpno = '" + slpno + "' union select doccode, slpno from slip where slpno= '" + slpno + "')) b",
//			"a.doccode, a.docfname || ' ' || a.docgname, payinstruction",
//			"a.DocCode = b.DocCode and payinstruction is not null"},
//				new MessageQueueCallBack() {
//			@Override
//			public void onPostSuccess(MessageQueue mQueue) {
//				if (mQueue.success()) {
//					List<String[]> results = mQueue.getContentAsArray();
//					for (String[] res : results) {
//						if (res != null) {
//							getPiList().addRow(new String[] {
//									res[0],
//									res[1],
//									res[2]
//							});
//						}
//					}
//
//					if (results.size()>0) {
//						getPiRemark().setText(getPiList().getValueAt(0, 2));
//					}
//				}
//			}
//		});
		setVisible(true);
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getPiPanel() {
		if (piPanel == null) {
			piPanel=new BasePanel();
			piPanel.setBounds(5, 5, 700, 370);
			piPanel.add(getPiScroll(), null);
			piPanel.add(getPiRemark(), null);
		}
		return piPanel;
	}

	public JScrollPane getPiScroll() {
		if (piScroll == null) {
			piScroll = new JScrollPane();
			piScroll.setBounds(0, 0, 695, 180);
			piScroll.setViewportView(getPiList());
		}
		return piScroll;
	}

	public TableList getPiList() {
		if (piList == null) {
			piList = new TableList(
				new String[] {"Dr. Code", "Dr. Name", "Payment Instruction", "Staff Medical Instruction"},
				new int[] {80, 150, 440, 440}) {
				@Override
				public void onSelectionChanged() {
					int row = getPiList().getSelectedRow();
					getPiRemark().setText("Payment Instruction:\n"+getPiList().getValueAt(row, 2)
								+"\n\nStaff Medical Instruction:\n"+getPiList().getValueAt(row, 3));
				};
			};
			piList.setBounds(0, 0, 695, 180);
		}
		return piList;
	}
	
	public TextRemark getPiRemark() {
		if (piRemark == null) {
			piRemark = new TextRemark();
			piRemark.setBounds(0, 190, 695, 100);
		}
		return piRemark;
	}
}