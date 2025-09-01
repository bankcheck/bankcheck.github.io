package com.hkah.client.layout.dialog;

import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgDocPrivilege extends DialogBase {
	private final static int m_frameWidth = 800;
	private final static int m_frameHeight = 330;

	private LabelBase doctorName = null;
	private LabelBase expiryDate = null;
	private TableList privilegeList = null;
	private BasePanel privilegePanel = null;
	private JScrollPane privilegeScrollPane = null;

	public DlgDocPrivilege(MainFrame owner) {
		super(owner, OK, m_frameWidth, m_frameHeight);
		initialize();
	}

	private void initialize() {
		setTitle("Doctor Privilege");
		setContentPane(getPrivilegePanel());
	}

	public void showDialog(String docCode) {
		QueryUtil.executeMasterBrowse(Factory.getInstance().getUserInfo(),
				ConstantsTx.LIST_DOCTOR_PRIVILEGE_TXCODE,
				new String[] { docCode, "N" },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(
					MessageQueue mQueue) {
				// TODO Auto-generated method stub
				if (mQueue.success()) {
					if (mQueue.getContentLineCount() > 0) {
						getPrivilegeList().setListTableContent(mQueue);
						getDoctorName().setText(mQueue.getContentField()[4]);
						if (mQueue.getContentField()[5].trim().length() > 0) {
							getExpiryDate().setText("<b>Expiry Date = "+mQueue.getContentField()[5]+"</b>");
						}
						getThis().setVisible(true);
					}
				}
			}
		});
	}

	public DlgDocPrivilege getThis() {
		return this;
	}

	public BasePanel getPrivilegePanel() {
		if (privilegePanel == null) {
			privilegePanel = new BasePanel();
			privilegePanel.setBounds(5, 5, 390, 390);
			privilegePanel.add(getDoctorName());
			privilegePanel.add(getExpiryDate());
			privilegePanel.add(getPrivilegeScrollPane(), null);
		}
		return privilegePanel;
	}

	public LabelBase getDoctorName() {
		if (doctorName == null) {
			doctorName = new LabelBase();
			doctorName.setBounds(5, 5, 300, 20);
		}
		return doctorName;
	}

	public LabelBase getExpiryDate() {
		if (expiryDate == null) {
			expiryDate = new LabelBase();
			expiryDate.setBounds(310, 5, 200, 20);
		}
		return expiryDate;
	}

	public JScrollPane getPrivilegeScrollPane() {
		if (privilegeScrollPane == null) {
			privilegeScrollPane = new JScrollPane();
			privilegeScrollPane.setBounds(5, 30, 750, 200);
			privilegeScrollPane.setViewportView(getPrivilegeList());
		}
		return privilegeScrollPane;
	}

	public TableList getPrivilegeList() {
		if (privilegeList == null) {
			privilegeList = new TableList(
				new String[] {
						"Privilege Code",
						"Privilege Name",
						"Start Date",
						"End Date",
						"Doctor Name",
						"Expiry Date"
				},
				new int[] {
						100, 300, 100, 100, 0, 0
				}
			);
			privilegeList.setBorders(false);
		}
		return privilegeList;
	}
}