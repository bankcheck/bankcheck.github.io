package com.hkah.client.layout.dialog;

import java.util.HashMap;

import com.extjs.gxt.ui.client.widget.form.RadioGroup;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.radiobutton.RadioButtonBase;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgPrintARList extends DialogBase {

    private final static int m_frameWidth = 282;
    private final static int m_frameHeight = 198;

    private BasePanel panel = null;
	private TextString textReceiptNo = null;
	private RadioButtonBase radioReciept = null;
	private RadioButtonBase radioArpid = null;
	private RadioGroup useArpIDRG = null;

	/**
	 * This method initializes
	 *
	 */
	public DlgPrintARList(MainFrame owner) {
        super(owner, OKCANCEL, m_frameWidth, m_frameHeight);
        initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Company Allocation List");

		setContentPane(getPanel());

		// change label
		getButtonById(OK).setText("Print", 'P');
		setFocusWidget(getTextReceiptNo());
	}

	public TextString getDefaultFocusComponent() {
		return getTextReceiptNo();
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog() {
		getTextReceiptNo().resetText();
		getRadioReciept().setSelected(true);
		getRadioArpid().setSelected(false);
		
	    setVisible(true);
	    getTextReceiptNo().focus();
	}

	@Override
	protected void doOkAction() {
		if (getTextReceiptNo().isEmpty()) {
			Factory.getInstance().addErrorMessage("Please Enter Receipt No/AR ID", getTextReceiptNo());
		} else {
			getMainFrame().setLoading(true);
			final String siteCode = getMainFrame().getUserInfo().getSiteCode();
			String arpid = null;
			String arprecno = null;
			if (getRadioReciept().isSelected()) {
				arprecno = getTextReceiptNo().getText();
			} else {
				arpid = getTextReceiptNo().getText();
			}

			final String tempArpid = arpid;
			final String tempArprecno = arprecno;
			QueryUtil.executeTx(getUserInfo(), "RPT_CMPALLOCLIST",
					new String[] {siteCode,	tempArpid, tempArprecno},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					HashMap<String, String> map = new HashMap<String, String>();
					map.put("SITECODE", siteCode);
					map.put("SITENAME", Factory.getInstance().getUserInfo().getSiteName());
					map.put("ARPID", tempArpid);
					map.put("ARPRECNO", tempArprecno);

					if (mQueue.success()) {
						PrintingUtil.print("", "CmpAllocList", map,"",
								new String[] {siteCode, tempArpid, tempArprecno},
								new String[] {"SLPNO","PATNO","ARCCODE","CHDATE",
								"ALLOCATE","CHAMT","ARPRECNO",
								"BILLAMT","BILLDATE","PATNAME","ARCNAME","SLPTYPE"});
					} else {
						PrintingUtil.print("CmpAllocListEmpty", map, null);
					}
					getMainFrame().setLoading(false);
				}
			});
			hide();
		}
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
			panel.add(getTextReceiptNo(), null);
			panel.add(getRadioReciept(), null);
			panel.add(getRadioArpid(), null);
			getUseArpIDRG();
		}
		return panel;
	}

	/**
	 * This method initializes NO
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getTextReceiptNo() {
		if (textReceiptNo == null) {
			textReceiptNo = new TextString();
			textReceiptNo.setBounds(50, 30, 169, 22);
		}
		return textReceiptNo;
	}

	/**
	 * This method initializes reciept
	 *
	 * @return com.hkah.client.layout.checkbox.CheckBoxBase
	 */
	private RadioButtonBase getRadioReciept() {
		if (radioReciept == null) {
			radioReciept = new RadioButtonBase();
			radioReciept.setBounds(45, 75, 100, 20);
			radioReciept.setText("Reciept No");
			radioReciept.setSelected(true);
		}
		return radioReciept;
	}

	/**
	 * This method initializes ar
	 *
	 * @return com.hkah.client.layout.button.RadioButtonBase
	 */
	private RadioButtonBase getRadioArpid() {
		if (radioArpid == null) {
			radioArpid = new RadioButtonBase();
			radioArpid.setBounds(158, 75, 70, 22);
			radioArpid.setText("AR ID");
		}
		return radioArpid;
	}

	private RadioGroup getUseArpIDRG() {
		if (useArpIDRG == null) {
			useArpIDRG = new RadioGroup();
			useArpIDRG.add(getRadioReciept());
			useArpIDRG.add(getRadioArpid());
		}
		return useArpIDRG;
	}
	
	public void enterEvent() {
		doOkAction();
	}
}