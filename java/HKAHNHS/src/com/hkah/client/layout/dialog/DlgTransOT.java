package com.hkah.client.layout.dialog;

import com.hkah.client.MainFrame;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.TableList;
import com.hkah.shared.constants.ConstantsTx;

public class DlgTransOT extends DialogBase{
	private final static int m_frameWidth = 750;
	private final static int m_frameHeight = 380;

	private BasePanel otPanel = null;
	private JScrollPane otScroll = null;
	private TableList otList = null;

	public DlgTransOT(MainFrame mainFrame) {
		super(mainFrame, OK, m_frameWidth, m_frameHeight);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("OT Procedure");
		setContentPane(getOtPanel());
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String slpno) {
		getOtList().setListTableContent(ConstantsTx.SHOWOT_TXCODE, new String[] { slpno });

		setVisible(true);
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getOtPanel() {
		if (otPanel == null) {
			otPanel = new BasePanel();
			otPanel.setBounds(5, 5, 700, 350);
			otPanel.add(getOtScroll(),null);
		}
		return otPanel;
	}

	public JScrollPane getOtScroll() {
		if (otScroll == null) {
			otScroll = new JScrollPane();
			otScroll.setBounds(0, 0, 710, 280);
			otScroll.setViewportView(getOtList());
		}
		return otScroll;
	}

	public TableList getOtList() {
		if (otList == null) {
			otList = new TableList(new String[] {
							"Operation Date",
							"Primary Procedure",
							"Referral Dr. Code",
							"Referral Dr. Name",
							"Specimen",
							"Specimen To"
					},
					new int[] {
							80,250,80,100,70,150
					}
			);
			otList.setBounds(0, 0, 670, 240);
		}
		return otList;
	}
}