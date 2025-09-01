package com.hkah.client.layout.dialog;

import com.hkah.client.MainFrame;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextPassword;

public class DlgVoidCUPPwd extends DialogBase {

    private final static int m_frameWidth = 380;
    private final static int m_frameHeight = 180;

    private BasePanel basePanel = null;
	private LabelBase passwordDesc = null;
	private TextPassword password = null;

	private String memCashierTransactionID = null;
	private String memSlipNo = null;
	private String memSlipSeq = null;
	private String memCtnID = null;
	private String memCtxTrace = null;
	private String memCtxMethod = null;

	public DlgVoidCUPPwd(MainFrame mainFrame) {
    	super(mainFrame, OKCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
    	setTitle("VOID CUP Transaction");
		setContentPane(getBasePanel());
	}

	public TextPassword getDefaultFocusComponent() {
		return getPassword();
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String cashierTransactionID, String slipNo, String slipSeq, String ctnID, String ctxTrace, String ctxMethod) {
		memCashierTransactionID = cashierTransactionID;
		memSlipNo = slipNo;
		memSlipSeq = slipSeq;
		memCtnID = ctnID;
		memCtxTrace = ctxTrace;
		memCtxMethod = ctxMethod;

		getPassword().resetText();

		setVisible(true);
	}

	@Override
	protected void doOkAction() {
		post(memCashierTransactionID, memSlipNo, memSlipSeq, memCtnID, memCtxTrace, memCtxMethod, getPassword().getText().trim());
	}

	@Override
	protected void doCancelAction() {
		post(memCashierTransactionID, memSlipNo, memSlipSeq, memCtnID, memCtxTrace, memCtxMethod, null);
	}

	public void post(String cashierTransactionID, String slipNo, String slipSeq, String ctnID, String ctxTrace, String ctxMethod, String password) {
		dispose();
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getBasePanel() {
		if (basePanel == null) {
			basePanel = new BasePanel();
			basePanel.setBounds(5, 5, 340, 80);
			basePanel.add(getPasswordDesc(), null);
			basePanel.add(getPassword(), null);
		}
		return basePanel;
	}

	public LabelBase getPasswordDesc() {
		if (passwordDesc == null) {
			passwordDesc = new LabelBase();
			passwordDesc.setText("Enter password to void CUP Transaction:");
			passwordDesc.setBounds(10, 10, 250, 20);
		}
		return passwordDesc;
	}

	public TextPassword getPassword() {
		if (password == null) {
			password = new TextPassword();
		    password.setBounds(40, 45, 250, 20);
		}
		return password;
	}
}