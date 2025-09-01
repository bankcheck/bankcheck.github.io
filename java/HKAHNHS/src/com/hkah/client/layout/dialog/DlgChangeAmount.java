package com.hkah.client.layout.dialog;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.line.Line;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextNum;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.util.PanelUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public abstract class DlgChangeAmount extends DialogBase {

	private final static int m_frameWidth = 390;
	private final static int m_frameHeight = 280;

	private BasePanel chgAmtPanel = null;
	private BasePanel chgAmtTopPanel = null;
	private LabelBase chgAmtChgCodeDesc = null;
	private TextReadOnly chgAmtChgCode = null;
	private LabelBase chgAmtDescDesc = null;
	private TextReadOnly chgAmtDesc = null;
	private BasePanel chgAmtBtmPanel = null;
	private Line line = null;
	private LabelBase chgAmtChgAmtDesc = null;
	private TextNum chgAmtChgAmt = null;
	private LabelBase chgAmtDiscountDesc = null;
	private TextNum chgAmtDiscount = null;
	private LabelBase chgAmtPercentage = null;
	private LabelBase chgAmtMessage = null;

	private String memSlipNo = null;
	private String memStnID = null;
	private String memTDate = null;
	private String memChgAmtChgAmt = null;
	private String memChgAmtDiscount = null;

	public DlgChangeAmount(MainFrame owner) {
		super(owner, DialogBase.OKCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Change $/%");
		setContentPane(getChgAmtPanel());
		setLocation(250, 200);

		// change label
		getButtonById(OK).setText("Update", 'U');
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String slipNo, String stnID, String tDate,
			String chgAmtChgAmt, String chgAmtDiscount,
			String chgAmtChgCode, String chgAmtDesc,
			boolean chgAmtFlg) {
		memSlipNo = slipNo;
		memStnID = stnID;
		memTDate = tDate;
		memChgAmtChgAmt = chgAmtChgAmt;
		memChgAmtDiscount = chgAmtDiscount;

		setVisible(true);

		getChgAmtChgCode().setText(chgAmtChgCode);
		getChgAmtDesc().setText(chgAmtDesc);
		getChgAmtChgAmt().setText(chgAmtChgAmt);
		getChgAmtDiscount().setText(chgAmtDiscount);
		getChgAmtDiscount().setEditable(!chgAmtFlg);
		getChgAmtMessage().setVisible(chgAmtFlg);
	}

	@Override
	public TextNum getDefaultFocusComponent() {
		return getChgAmtChgAmt();
	}

	@Override
	protected void doOkAction() {
		if (!TextUtil.isNumber(getChgAmtChgAmt().getText().trim())) {
			Factory.getInstance().addErrorMessage("Charge Amount must be numeric.", "PBA", getChgAmtChgAmt());
			return;
		}
		if (!TextUtil.isNumber(getChgAmtDiscount().getText().trim())) {
			Factory.getInstance().addErrorMessage("Discount must be numeric.", "PBA", getChgAmtDiscount());
			return;
		}
		if (Integer.valueOf(getChgAmtDiscount().getText().trim())<0||Integer.valueOf(getChgAmtDiscount().getText().trim())>100) {
			Factory.getInstance().addErrorMessage("Discount must between 0 and 100!", "PBA", getChgAmtDiscount());
			return;
		}
		if ("0".equals(getChgAmtChgAmt().getText())) {
			MessageBoxBase.confirm(ConstantsMessage.MSG_PBA_SYSTEM, "Charge Amount is 0, Continue?",
					new Listener<MessageBoxEvent>() {
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						chgAmtAction();
					}
				}
			});
		} else {
			chgAmtAction();
		}
	}

	public void chgAmtAction() {
		if (memChgAmtChgAmt.equals(getChgAmtChgAmt().getText().trim())
				&& memChgAmtDiscount.equals(getChgAmtDiscount().getText().trim())) {
			dispose();
			return;
		}

		QueryUtil.executeMasterAction(getUserInfo(), "CHGAMTDIS", QueryUtil.ACTION_APPEND,
				new String[] { memSlipNo, memStnID, memTDate, getChgAmtChgAmt().getText().trim(), getChgAmtDiscount().getText().trim(), getUserInfo().getUserID() },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				post(memSlipNo);
			}
		});

		dispose();
	}

	@Override
	public void setVisible(boolean visible) {
		super.setVisible(visible);
		PanelUtil.resetAllFields(getChgAmtBtmPanel());
	}

	public abstract void post(String slipNo);

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getChgAmtPanel() {
		if (chgAmtPanel == null) {
			chgAmtPanel = new BasePanel();
			chgAmtPanel.setBounds(5, 5, 380, 250);
			chgAmtPanel.add(getChgAmtTopPanel(), null);
			chgAmtPanel.add(getChgAmtBtmPanel(), null);
		}
		return chgAmtPanel;
	}

	public BasePanel getChgAmtTopPanel() {
		if (chgAmtTopPanel == null) {
			chgAmtTopPanel = new BasePanel();
			chgAmtTopPanel.setBounds(0, 0, 350, 80);
			chgAmtTopPanel.add(getChgAmtChgCodeDesc(), null);
			chgAmtTopPanel.add(getChgAmtChgCode(), null);
			chgAmtTopPanel.add(getChgAmtDescDesc(), null);
			chgAmtTopPanel.add(getChgAmtDesc(), null);
			chgAmtTopPanel.add(getLine(), null);
		}
		return chgAmtTopPanel;
	}

	public LabelBase getChgAmtChgCodeDesc() {
		if (chgAmtChgCodeDesc == null) {
			chgAmtChgCodeDesc = new LabelBase();
			chgAmtChgCodeDesc.setBounds(50, 10, 100, 20);
			chgAmtChgCodeDesc.setText("Charge Code:");
		}
		return chgAmtChgCodeDesc;
	}

	public TextReadOnly getChgAmtChgCode() {
		if (chgAmtChgCode == null) {
			chgAmtChgCode = new TextReadOnly();
			chgAmtChgCode.setBounds(145, 10, 120, 20);
		}
		return chgAmtChgCode;
	}

	public LabelBase getChgAmtDescDesc() {
		if (chgAmtDescDesc == null) {
			chgAmtDescDesc = new LabelBase();
			chgAmtDescDesc.setBounds(50, 40, 100, 20);
			chgAmtDescDesc.setText("Description:");
		}
		return chgAmtDescDesc;
	}

	public TextReadOnly getChgAmtDesc() {
		if (chgAmtDesc == null) {
			chgAmtDesc = new TextReadOnly();
			chgAmtDesc.setBounds(145, 40, 120, 20);
		}
		return chgAmtDesc;
	}

	public Line getLine() {
		if (line == null) {
			line = new Line();
			line.setBounds(0, 75, 350);
		}
		return line;
	}

	public BasePanel getChgAmtBtmPanel() {
		if (chgAmtBtmPanel == null) {
			chgAmtBtmPanel = new BasePanel();
			chgAmtBtmPanel.setBounds(0, 80, 350, 110);
			chgAmtBtmPanel.add(getChgAmtChgAmtDesc(), null);
			chgAmtBtmPanel.add(getChgAmtChgAmt(), null);
			chgAmtBtmPanel.add(getChgAmtDiscountDesc(), null);
			chgAmtBtmPanel.add(getChgAmtDiscount(), null);
			chgAmtBtmPanel.add(getChgAmtPercentage(), null);
			chgAmtBtmPanel.add(getChgAmtMessage(), null);
		}
		return chgAmtBtmPanel;
	}

	public LabelBase getChgAmtChgAmtDesc() {
		if (chgAmtChgAmtDesc == null) {
			chgAmtChgAmtDesc = new LabelBase();
			chgAmtChgAmtDesc.setBounds(50, 10, 100, 20);
			chgAmtChgAmtDesc.setText("Charge Amount:");
		}
		return chgAmtChgAmtDesc;
	}

	public TextNum getChgAmtChgAmt() {
		if (chgAmtChgAmt == null) {
			chgAmtChgAmt = new TextNum();
			chgAmtChgAmt.setBounds(145, 10, 120, 20);
		}
		return chgAmtChgAmt;
	}

	public LabelBase getChgAmtDiscountDesc() {
		if (chgAmtDiscountDesc == null) {
			chgAmtDiscountDesc = new LabelBase();
			chgAmtDiscountDesc.setBounds(50, 40, 100, 20);
			chgAmtDiscountDesc.setText("Discount:");
		}
		return chgAmtDiscountDesc;
	}

	public TextNum getChgAmtDiscount() {
		if (chgAmtDiscount == null) {
			chgAmtDiscount = new TextNum(3);
			chgAmtDiscount.setBounds(145, 40, 120, 20);
		}
		return chgAmtDiscount;
	}

	public LabelBase getChgAmtPercentage() {
		if (chgAmtPercentage == null) {
			chgAmtPercentage = new LabelBase();
			chgAmtPercentage.setText("%");
			chgAmtPercentage.setBounds(275, 40, 10, 20);
		}
		return chgAmtPercentage;
	}

	public LabelBase getChgAmtMessage() {
		if (chgAmtMessage == null) {
			chgAmtMessage = new LabelBase();
			chgAmtMessage.setText("<font color='red'>This is a percentage contract; therefore % cannot be changed.</font>");
			chgAmtMessage.setBounds(0, 90, 360, 20);
		}
		return chgAmtMessage;
	}
}