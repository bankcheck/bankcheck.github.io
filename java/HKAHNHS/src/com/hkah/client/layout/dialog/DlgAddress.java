package com.hkah.client.layout.dialog;

import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgAddress extends DialogBase {

    private final static int m_frameWidth = 380;
    private final static int m_frameHeight = 276;

    private BasePanel panel = null;
	private LabelBase payeeDesc = null;
	private TextString payee = null;
	private LabelBase addressDesc = null;
	private TextString add1 = null;
	private TextString add2 = null;
	private TextString add3 = null;
	private LabelBase countryDesc = null;
	private TextString country = null;
	private LabelBase reasonDesc = null;
	private TextString reason = null;

	private String memActionType = null;

	/**
	 * This method initializes
	 *
	 */
	public DlgAddress(MainFrame owner) {
		super(owner, OKCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Please enter the address");
		setContentPane(getPanel());
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(final String actionType, String patNo) {
		QueryUtil.executeMasterBrowse(
				getUserInfo(), "PATIENTADD", new String[] { patNo },
				new MessageQueueCallBack() {
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							showDialog(
								actionType,
								mQueue.getContentField()[0],
								mQueue.getContentField()[1],
								mQueue.getContentField()[2],
								mQueue.getContentField()[3],
								mQueue.getContentField()[4]
							);
						}
					}
				});
	}

	public void showDialog(String actionType, String payee, String add1, String add2, String add3, String country) {
		getPayee().setText(payee);
		getAdd1().setText(add1);
		getAdd2().setText(add2);
		getAdd3().setText(add3);
		getCountry().setText(country);
		getReason().resetText();
		memActionType = actionType;

		setVisible(true);
	}

	@Override
	public TextString getDefaultFocusComponent() {
		return getPayee();
	}

	@Override
	protected void doOkAction() {
		if (getPayee().isEmpty()) {
			Factory.getInstance().addErrorMessage("Payee Field cannot be empty", getPayee());
		} else {
			post(
				memActionType,
				getPayee().getText(),
				getAdd1().getText(),
				getAdd2().getText(),
				getAdd3().getText(),
				getCountry().getText(),
				getReason().getText()
			);
		}
	}

	@Override
	protected void doCancelAction() {
		post(null, null, null, null, null, null, null);
	}

	protected void post(String actionType, String strPayee, String strAdd1, String strAdd2, String strAdd3,
			String strCountry, String strReason) {
		dispose();
	}

	/***************************************************************************
	* Layout Method
	**************************************************************************/

	/**
	 * This method initializes panel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	private BasePanel getPanel() {
		if (panel == null) {
			panel = new BasePanel();
			panel.add(getPayeeDesc(), null);
			panel.add(getPayee(), null);
			panel.add(getAddressDesc(), null);
			panel.add(getAdd1(), null);
			panel.add(getAdd2(), null);
			panel.add(getAdd3(), null);
			panel.add(getCountryDesc(), null);
			panel.add(getCountry(), null);
			panel.add(getReasonDesc(), null);
			panel.add(getReason(), null);
		}
		return panel;
	}

	/**
	 * This method initializes payeeDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getPayeeDesc() {
		if (payeeDesc == null) {
			payeeDesc = new LabelBase();
			payeeDesc.setBounds(23, 18, 55, 20);
			payeeDesc.setText("Payee");
		}
		return payeeDesc;
	}

	/**
	 * This method initializes payee
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getPayee() {
		if (payee == null) {
			payee = new TextString(50);
			payee.setBounds(93, 18, 235, 20);
		}
		return payee;
	}

	/**
	 * This method initializes addressDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getAddressDesc() {
		if (addressDesc == null) {
			addressDesc = new LabelBase();
			addressDesc.setBounds(23, 45, 56, 20);
			addressDesc.setText("Address");
		}
		return addressDesc;
	}

	/**
	 * This method initializes add1
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getAdd1() {
		if (add1 == null) {
			add1 = new TextString(40);
			add1.setBounds(93, 45, 235, 20);
		}
		return add1;
	}

	/**
	 * This method initializes add2
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getAdd2() {
		if (add2 == null) {
			add2 = new TextString(40);
			add2.setBounds(93, 71, 235, 20);
		}
		return add2;
	}

	/**
	 * This method initializes add3
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getAdd3() {
		if (add3 == null) {
			add3 = new TextString(40);
			add3.setBounds(93, 97, 235, 20);
		}
		return add3;
	}

	/**
	 * This method initializes countryDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getCountryDesc() {
		if (countryDesc == null) {
			countryDesc = new LabelBase();
			countryDesc.setBounds(23, 129, 65, 20);
			countryDesc.setText("Country");
		}
		return countryDesc;
	}

	/**
	 * This method initializes country
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getCountry() {
		if (country == null) {
			country = new TextString(40);
			country.setBounds(93, 129, 235, 20);
		}
		return country;
	}

	/**
	 * This method initializes reasonDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getReasonDesc() {
		if (reasonDesc == null) {
			reasonDesc = new LabelBase();
			reasonDesc.setBounds(23, 157, 65, 20);
			reasonDesc.setText("Reason");
		}
		return reasonDesc;
	}

	/**
	 * This method initializes reason
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getReason() {
		if (reason == null) {
			reason = new TextString(40);
			reason.setBounds(93, 157, 235, 20);
		}
		return reason;
	}
}