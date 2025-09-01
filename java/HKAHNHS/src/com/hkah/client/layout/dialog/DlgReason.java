package com.hkah.client.layout.dialog;

import com.hkah.client.MainFrame;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextString;

public abstract class DlgReason extends DialogBase{
	private final static int m_frameWidth = 480;
	private final static int m_frameHeight = 220;

	private BasePanel basePanel = null;
	private LabelBase reasonDesc = null;
	private TextString reason = null;

	private String m_stnID = null;
	private String m_stnxref = null;
	private String m_stnSeq = null;
	private boolean m_isDIReported = false;
	private boolean m_isDIPayed = false;
	private boolean m_isDIPayedDr = false;
	private boolean m_isCancelItem = false;

	public DlgReason(MainFrame owner) {
		super(owner, OKCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Reason");
		setContentPane(getBasePanel());

		// change label
		getButtonById(OK).setText("Confirm", 'C');
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String stnID, String stnSeq, String stnxref,
			boolean isDIReported, boolean isDIPayed, boolean isDIPayedDr, boolean isCancelItem) {
		m_stnID = stnID;
		m_stnxref = stnxref;
		m_stnSeq = stnSeq;
		m_isDIReported = isDIReported;
		m_isDIPayed = isDIPayed;
		m_isDIPayedDr = isDIPayedDr;
		m_isCancelItem = isCancelItem;

		getReason().resetText();

		setVisible(true);
	}

	@Override
	public void doOkAction() {
		if (getReason().isEmpty()) {
			addText("Reason is empty");
			return;
		}
		dispose();
		post(m_stnID, m_stnxref, m_stnSeq, m_isDIReported, m_isDIPayed, m_isDIPayedDr, getReason().getText().trim(), m_isCancelItem);
	}

	public abstract void post(String stnID, String m_stnxref, String m_stnSeq,
			boolean isDIReported, boolean isDIPayed, boolean isDIPayedDr, String cancelReason, boolean isCancelItem);

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getBasePanel() {
		if (basePanel == null) {
			basePanel = new BasePanel();
			basePanel.setBounds(5, 5, 421, 122);
			basePanel.add(getReasonDesc(),null);
			basePanel.add(getReason(),null);
		}
		return basePanel;
	}

	public LabelBase getReasonDesc() {
		if (reasonDesc == null) {
			reasonDesc = new LabelBase();
			reasonDesc.setText("Reason");
			reasonDesc.setBounds(20, 45, 80, 20);
		}
		return reasonDesc;
	}

	public TextString getReason() {
		if (reason == null) {
			reason = new TextString();
			reason.setBounds(110, 45, 298, 20);
		}
		return reason;
	}
}