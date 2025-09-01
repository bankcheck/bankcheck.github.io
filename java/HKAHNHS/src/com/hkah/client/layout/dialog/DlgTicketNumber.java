package com.hkah.client.layout.dialog;

import com.extjs.gxt.ui.client.event.BaseEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.Listener;
import com.hkah.client.MainFrame;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextNum;

public abstract class DlgTicketNumber extends DialogBase {
	private final static int m_frameWidth = 400;
    private final static int m_frameHeight = 120;

    private BasePanel ticketPanel = null;
	private LabelBase ticketNumberLabel = null;
	private TextNum ticketNumber = null;

	private String actionType = null;
	private boolean returnValue = false;

	public DlgTicketNumber(MainFrame owner) {
		super(owner, OKCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

    private void initialize() {
		setTitle("Ticket Number");
		setContentPane(getTicketPanel());

		addListener(Events.Hide, new Listener<BaseEvent>() {
			@Override
			public void handleEvent(BaseEvent be) {
				dlgClose();
			}
		});
    }

    public TextNum getDefaultFocusComponent() {
		return getTicketNumber();
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

    public void showDialog(String actionType, boolean returnValue) {
    	this.actionType = actionType;
    	this.returnValue = returnValue;
    	setVisible(true);
    }

    @Override
	protected void doOkAction() {
    	post(actionType, returnValue, getTicketNumber().getText());
    	dispose();
    }

    @Override
	protected void doCancelAction() {
    	post(actionType, false, getTicketNumber().getText());
    	dispose();
    }

    protected void dlgClose() {
    	doCancelAction();
	};

	public abstract void post(String actionType, boolean returnValue, String tid);

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

    private BasePanel getTicketPanel() {
		if (ticketPanel == null) {
			ticketPanel = new BasePanel();
			ticketPanel.add(getTicketNumberLabel());
			ticketPanel.add(getTicketNumber());
			ticketPanel.setBounds(5, 5, 360, 100);
		}
		return ticketPanel;
	}

    protected LabelBase getTicketNumberLabel() {
		if (ticketNumberLabel == null) {
			ticketNumberLabel = new LabelBase();
			ticketNumberLabel.setText("Ticket Number:");
			ticketNumberLabel.setBounds(5, 5, 150, 20);
		}
		return ticketNumberLabel;
	}

	protected TextNum getTicketNumber() {
		if (ticketNumber == null) {
			ticketNumber = new TextNum(5, 0);
			ticketNumber.setBounds(150, 5, 100, 20);
		}
		return ticketNumber;
	}
}