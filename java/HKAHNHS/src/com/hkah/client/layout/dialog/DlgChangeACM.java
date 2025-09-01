package com.hkah.client.layout.dialog;

import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.combobox.ComboACMCode;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public abstract class DlgChangeACM extends DialogBase {
	private final static int m_frameWidth = 400;
	private final static int m_frameHeight = 250;

	private BasePanel chgAcmPanel = null;
	private LabelBase chgAcmInfoDesc = null;
	private LabelBase chgAcmDesc = null;
	private ComboACMCode chgAcm = null;
	private LabelBase chgAcmSeqFromDesc = null;
	private TextString chgAcmSeqFrom = null;
	private LabelBase chgAcmSeqToDesc = null;
	private TextString chgAcmSeqTo = null;

	private String memSlipNo = null;

	public DlgChangeACM(MainFrame owner) {
		super(owner, OKCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Change Accommodation Code");
//		setLocation(250, 200);
		setContentPane(getChgAcmPanel());
	}

	/***************************************************************************
	 * Abstract Method
	 **************************************************************************/
	public abstract void post();

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String slipNo, String acm) {
		memSlipNo = slipNo;

		setVisible(true);

		// set default value
		getChgAcm().setText(acm);
		getChgAcmSeqFrom().resetText();
		getChgAcmSeqTo().resetText();
	}

	@Override
	public TextString getDefaultFocusComponent() {
		return getChgAcmSeqFrom();
	}

	@Override
	protected void doOkAction() {
		if (ConstantsVariable.EMPTY_VALUE.equals(getChgAcm().getText().trim())) {
			Factory.getInstance().addErrorMessage("Accommadation code can't be null.", "PBA-[Change Accommodation Code]", getChgAcm());
			return;
		} else if (getChgAcmSeqFrom().isEmpty() || !TextUtil.isNumber(getChgAcmSeqFrom().getText().trim())) {
			Factory.getInstance().addErrorMessage("Start sequence number should be numeric.", "PBA-[Change Report Level]", getChgAcmSeqFrom());
		} else if (getChgAcmSeqTo().isEmpty() || !TextUtil.isNumber(getChgAcmSeqTo().getText().trim())) {
			Factory.getInstance().addErrorMessage("End sequence number should be numeric.", "PBA-[Change Report Level]", getChgAcmSeqTo());
		} else {
			int startNum = Integer.valueOf(getChgAcmSeqFrom().getText().trim());
			int endNum = Integer.valueOf(getChgAcmSeqTo().getText().trim());

			if (startNum < 1) {
				Factory.getInstance().addErrorMessage("Start sequence number must be positive", "PBA-[Change Accommodation Code]", getChgAcmSeqFrom());
				return;
			} else if (endNum < 1) {
				Factory.getInstance().addErrorMessage("End sequence number must be positive", "PBA-[Change Accommodation Code]", getChgAcmSeqTo());
				return;
			} else if (startNum > endNum) {
				Factory.getInstance().addErrorMessage("End sequence number must equal or large than start sequence number.","PBA-[Change Accommodation Code]", getChgAcmSeqTo());
				return;
			}
		}

		QueryUtil.executeMasterAction(getUserInfo(), ConstantsTx.CHANGEACM_TXCODE, QueryUtil.ACTION_APPEND,
				new String[] { memSlipNo, getChgAcm().getText(),
					getChgAcmSeqFrom().getText().trim(), getChgAcmSeqTo().getText().trim(),
					getUserInfo().getUserID()},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					StringBuffer msgbuff = new StringBuffer();
					msgbuff.append("<html>Completed successfully<br><br>");
					msgbuff.append("Note: The process does not update any doctor items, credit items, items having adjustments and packages having doctor items.<br>");

					if (mQueue.getReturnMsg().length() > 0 && !mQueue.getReturnMsg().equals("null")) {
						msgbuff.append("<br>The following package or items cannot be proceed:<br>");
						msgbuff.append(mQueue.getReturnMsg());
					}

					msgbuff.append("<html>");

					Factory.getInstance().addErrorMessage(msgbuff.toString(), "PBA-[Transaction Detail]");
					dispose();
					post();
				}
			}
		});
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getChgAcmPanel() {
		if (chgAcmPanel == null) {
			chgAcmPanel = new BasePanel();
			chgAcmPanel.setBounds(5, 5, 390, 210);
			chgAcmPanel.add(getChgAcmInfoDesc(), null);
			chgAcmPanel.add(getChgAcmDesc(), null);
			chgAcmPanel.add(getChgAcm(), null);
			chgAcmPanel.add(getChgAcmSeqFromDesc(), null);
			chgAcmPanel.add(getChgAcmSeqFrom(), null);
			chgAcmPanel.add(getChgAcmSeqToDesc(), null);
			chgAcmPanel.add(getChgAcmSeqTo(), null);
		}
		return chgAcmPanel;
	}

	public LabelBase getChgAcmInfoDesc() {
		if (chgAcmInfoDesc == null) {
			chgAcmInfoDesc = new LabelBase();
			chgAcmInfoDesc.setText("<html>This function changes the accommodation code of Transaction Detail item that is included in the following range.<html>");
			chgAcmInfoDesc.setBounds(5, 5, 380, 40);
		}
		return chgAcmInfoDesc;
	}

	public LabelBase getChgAcmDesc() {
		if (chgAcmDesc == null) {
			chgAcmDesc = new LabelBase();
			chgAcmDesc.setText("New Accommodation Code:");
			chgAcmDesc.setBounds(10, 70, 160, 20);
		}
		return chgAcmDesc;
	}

	public ComboACMCode getChgAcm() {
		if (chgAcm == null) {
			chgAcm = new ComboACMCode();
			chgAcm.setBounds(180, 70, 150, 20);
		}
		return chgAcm;
	}

	public LabelBase getChgAcmSeqFromDesc() {
		if (chgAcmSeqFromDesc == null) {
			chgAcmSeqFromDesc = new LabelBase();
			chgAcmSeqFromDesc.setText("Item sequence range from :");
			chgAcmSeqFromDesc.setBounds(10, 100, 160, 20);
		}
		return chgAcmSeqFromDesc;
	}

	public TextString getChgAcmSeqFrom() {
		if (chgAcmSeqFrom == null) {
			chgAcmSeqFrom = new TextString(5);
			chgAcmSeqFrom.setBounds(180, 100, 50, 20);
		}
		return chgAcmSeqFrom;
	}

	public LabelBase getChgAcmSeqToDesc() {
		if (chgAcmSeqToDesc == null) {
			chgAcmSeqToDesc = new LabelBase();
			chgAcmSeqToDesc.setText("To");
			chgAcmSeqToDesc.setBounds(235, 100, 20, 20);
		}
		return chgAcmSeqToDesc;
	}

	public TextString getChgAcmSeqTo() {
		if (chgAcmSeqTo == null) {
			chgAcmSeqTo = new TextString(5);
			chgAcmSeqTo.setBounds(260, 100, 50, 20);
		}
		return chgAcmSeqTo;
	}
}