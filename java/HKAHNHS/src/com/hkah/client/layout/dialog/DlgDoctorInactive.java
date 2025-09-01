package com.hkah.client.layout.dialog;

import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgDoctorInactive extends DialogBase {
	private final static int m_frameWidth = 800;
	private final static int m_frameHeight = 330;

	private TableList inactiveDoctorList = null;
	private BasePanel inactiveDoctorPanel = null;
	private JScrollPane inactiveDoctorScrollPane = null;

	public DlgDoctorInactive(MainFrame owner) {
		super(owner, OK, m_frameWidth, m_frameHeight);
		initialize();
	}

	private void initialize() {
		setTitle("List of inactive doctors who have future IP booking");
		setContentPane(getInactiveDoctorPanel());
	}

	public BasePanel getInactiveDoctorPanel() {
		if (inactiveDoctorPanel == null) {
			inactiveDoctorPanel = new BasePanel();
			inactiveDoctorPanel.setBounds(5, 5, 390, 390);
			inactiveDoctorPanel.add(getInactiveDoctorScrollPane(), null);
		}
		return inactiveDoctorPanel;
	}

	public JScrollPane getInactiveDoctorScrollPane() {
		if (inactiveDoctorScrollPane == null) {
			inactiveDoctorScrollPane = new JScrollPane();
			inactiveDoctorScrollPane.setBounds(5, 5, 750, 240);
			inactiveDoctorScrollPane.setViewportView(getInactiveDoctorList());
		}
		return inactiveDoctorScrollPane;
	}

	public TableList getInactiveDoctorList() {
		if (inactiveDoctorList == null) {
			inactiveDoctorList = new TableList(
				new String[] {
						"Patient No",
						"Patient Name",
						"Chi. Name",
						"Physician",
						"Adm Expiry Date",
						"Scheduled Adm Date",
						"Surgery Date",
						"Ward",
						"OT Procedure",
						"Document #",
						"Order Date",
						"Created By",
						"Edit Date",
						"Edit By"
				},
				new int[] {
						100, 150, 80, 150, 150, 150, 150, 50, 200, 100, 150, 120, 150, 120
				}
			);
			inactiveDoctorList.setBorders(false);
		}
		return inactiveDoctorList;
	}

	public void showDialog() {
		QueryUtil.executeMasterBrowse(Factory.getInstance().getUserInfo(),
				ConstantsTx.INACTIVEDOCTOR_PREBOK,
				null,
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(
					MessageQueue mQueue) {
				// TODO Auto-generated method stub
				if (mQueue.success()) {
					if (mQueue.getContentLineCount() > 0) {
						getInactiveDoctorList().setListTableContent(mQueue);
						getThis().setVisible(true);
					} else {
						Factory.getInstance().addErrorMessage("No Inactive Doctor.",
								"List of inactive doctors who have future IP booking");
					}
				} else {
					Factory.getInstance().addErrorMessage("No Inactive Doctor.",
							"List of inactive doctors who have future IP booking");
				}
			}
		});
	}

	public DlgDoctorInactive getThis() {
		return this;
	}
}