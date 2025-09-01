package com.hkah.client.layout.dialog;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextDateTime;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.shared.constants.ConstantsMessage;

public class DlgCardInfo_Octopus extends DialogBase {
	private final static int m_frameWidth = 380;
	private final static int m_frameHeight = 200;

	private BasePanel dialogPanel = null;
	private LabelBase descLabel = null;
	private LabelBase cardNoDesc = null;
	private TextString cardNo = null;
	private LabelBase tDateDesc = null;
	private TextDateTime tDate = null;

	private String memActionType = null;
	private String memActionDescription = null;

	public DlgCardInfo_Octopus(MainFrame owner) {
		super(owner, OKCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Octopus Card Info");
		setContentPane(getDialogPanel());

    	// change label
    	getButtonById(OK).setText("Confirm", 'C');
	}

	public TextString getDefaultFocusComponent() {
		return getCardNo();
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String actionType, String actionDescription) {
    	getCardNo().resetText();
		getTDate().setText(getMainFrame().getServerDateTime());

		memActionType = actionType;
		memActionDescription = actionDescription;

		setVisible(true);
	}

	@Override
	protected void doOkAction() {
		if (getCardNo().isEmpty()) {
			Factory.getInstance().addErrorMessage("Input Card No. of the Octopus Card, please!", getCardNo());
			return;
		} else if (getTDate().isEmpty()) {
			Factory.getInstance().addErrorMessage("Transaction date is empty.", getTDate());
			return;
		} else if (!getTDate().isValid()) {
			Factory.getInstance().addErrorMessage("Transaction date is not a date type.", getTDate());
			return;
		}
		MessageBoxBase.confirm(ConstantsMessage.MSG_PBA_SYSTEM, ConstantsMessage.MSG_CARDINFO_CONFIRM,
				new Listener<MessageBoxEvent>() {
			public void handleEvent(MessageBoxEvent be) {
				post(
						memActionType,
						memActionDescription,
						Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId()),
						getCardNo().getText(),
						getTDate().getText()
					);
			}
		});
	}

	@Override
	protected void doCancelAction() {
		post(memActionType, memActionDescription, false, null, null);
	}

	public void post(String actionType, String actionDescription, boolean confirmed, String cardNo, String transactionDateTime) {
		dispose();
	}

	/***************************************************************************
	* Layout Method
	**************************************************************************/

	public BasePanel getDialogPanel() {
		if (dialogPanel == null) {
			dialogPanel = new BasePanel();
			dialogPanel.setLocation(5, 5);
			dialogPanel.add(getDescLabel(), null);
			dialogPanel.add(getCardNoDesc(), null);
			dialogPanel.add(getCardNo(), null);
			dialogPanel.add(getTDateDesc(), null);
			dialogPanel.add(getTDate(), null);
		}
		return dialogPanel;
	}

	public LabelBase getDescLabel() {
		if (descLabel == null) {
			descLabel = new LabelBase();
			descLabel.setText("Please enter the Card No. of the Octopus Card");
			descLabel.setBounds(20, 20, 300, 20);
		}
		return descLabel;
	}

	public LabelBase getCardNoDesc() {
		if (cardNoDesc == null) {
			cardNoDesc = new LabelBase();
			cardNoDesc.setText("Card No.:");
			cardNoDesc.setBounds(20, 45, 120, 20);
		}
		return cardNoDesc;
	}

	public TextString getCardNo() {
		if (cardNo == null) {
			cardNo = new TextString(19);
			cardNo.setBounds(150, 45, 150, 20);
		}
		return cardNo;
	}

	public LabelBase getTDateDesc() {
		if (tDateDesc == null) {
			tDateDesc = new LabelBase();
			tDateDesc.setText("Transaction Date:");
			tDateDesc.setBounds(20, 70, 120, 20);
		}
		return tDateDesc;
	}

	public TextDateTime getTDate() {
		if (tDate == null) {
			tDate = new TextDateTime();
			tDate.setBounds(150, 70, 150, 20);
		}
		return tDate;
	}
}