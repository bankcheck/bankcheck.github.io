package com.hkah.client.layout.dialog;

import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.combobox.ComboCalRefItemDept;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgCalRefItem extends DialogBase {
    private final static int m_frameWidth = 380;
    private final static int m_frameHeight = 270;

    private BasePanel calRefItemPanel = null;
	private LabelBase calRefItemPkgCodeDesc = null;
	private TextString calRefItemPkgCode = null;
	private LabelBase calRefItemDeptCodeDesc = null;
	private ComboCalRefItemDept calRefItemDeptCode = null;
	private LabelBase calRefItemItmCodeDesc = null;
	private TextString calRefItemItmCode = null;
	private LabelBase calRefItemAmtDesc = null;
	private TextReadOnly calRefItemAmt = null;
	private String memSlpNo = EMPTY_VALUE;

    public DlgCalRefItem(MainFrame owner) {
    	super(owner, OKCANCEL, m_frameWidth, m_frameHeight);
    	initialize();
    }

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
    	setTitle("Calculate Reference Item");
    	setContentPane(getCalRefItemPanel());

    	// change label
    	getButtonById(OK).setText("Calculate", 'a');
	}

	@Override
	public TextString getDefaultFocusComponent() {
		return getCalRefItemPkgCode();
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String slpNo) {
    	memSlpNo = slpNo;
    	getCalRefItemPkgCode().resetText();
    	getCalRefItemDeptCode().initContent(memSlpNo);
    	getCalRefItemItmCode().resetText();
    	getCalRefItemAmt().resetText();

    	setVisible(true);
	}

	@Override
	protected void doOkAction() {
		calculate();
	}

    private void calculate() {
    	QueryUtil.executeMasterFetch(getUserInfo(), "TXNCalRefItem",
    				new String[] { getCalRefItemPkgCode().getText(), getCalRefItemItmCode().getText(), getCalRefItemDeptCode().getText(), memSlpNo },
    				new MessageQueueCallBack() {
    		@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					String returnCode = mQueue.getContentField()[0];
					String returnMsg = mQueue.getContentField()[1];
					String returnValue = mQueue.getContentField()[2];

					getCalRefItemAmt().resetText();
					if (ZERO_VALUE.equals(returnCode)) {
						getCalRefItemAmt().setText(returnValue);
						setFocusWidget(getDefaultFocusComponent());
					} else if ("-100".equals(returnCode)) {
						getCalRefItemPkgCode().resetText();
						setFocusWidget(getCalRefItemPkgCode());
						Factory.getInstance().addErrorMessage(returnMsg, getCalRefItemPkgCode());
					} else if ("-200".equals(returnCode)) {
						setFocusWidget(getCalRefItemDeptCode());
						Factory.getInstance().addErrorMessage(returnMsg, getCalRefItemDeptCode());
					} else if ("-300".equals(returnCode)) {
						getCalRefItemPkgCode().resetText();
						setFocusWidget(getCalRefItemPkgCode());
						Factory.getInstance().addErrorMessage(returnMsg, getCalRefItemPkgCode());
					} else {
						setFocusWidget(getDefaultFocusComponent());
						Factory.getInstance().addErrorMessage(returnMsg, getDefaultFocusComponent());
					}
				}
			}
		});
	}

    /***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getCalRefItemPanel() {
		if (calRefItemPanel == null) {
			calRefItemPanel = new BasePanel();
			calRefItemPanel.setBounds(5, 5, 350, 240);
			calRefItemPanel.add(getCalRefItemPkgCodeDesc(),null);
			calRefItemPanel.add(getCalRefItemPkgCode(),null);
			calRefItemPanel.add(getCalRefItemDeptCodeDesc(),null);
			calRefItemPanel.add(getCalRefItemDeptCode(),null);
			calRefItemPanel.add(getCalRefItemItmCodeDesc(),null);
			calRefItemPanel.add(getCalRefItemItmCode(),null);
			calRefItemPanel.add(getCalRefItemAmtDesc(),null);
			calRefItemPanel.add(getCalRefItemAmt(),null);
		}
		return calRefItemPanel;
	}

	public LabelBase getCalRefItemPkgCodeDesc() {
		if (calRefItemPkgCodeDesc == null) {
			calRefItemPkgCodeDesc = new LabelBase();
			calRefItemPkgCodeDesc.setBounds(50, 30, 100, 20);
			calRefItemPkgCodeDesc.setText("Package Code");
		}
		return calRefItemPkgCodeDesc;
	}

	public TextString getCalRefItemPkgCode() {
		if (calRefItemPkgCode == null) {
			calRefItemPkgCode = new TextString(10);
			calRefItemPkgCode.setBounds(160, 30, 120, 20);
		}
		return calRefItemPkgCode;
	}

	public LabelBase getCalRefItemDeptCodeDesc() {
		if (calRefItemDeptCodeDesc == null) {
			calRefItemDeptCodeDesc = new LabelBase();
			calRefItemDeptCodeDesc.setBounds(50, 70, 100, 20);
			calRefItemDeptCodeDesc.setText("Dept Code");
		}
		return calRefItemDeptCodeDesc;
	}

	public ComboCalRefItemDept getCalRefItemDeptCode() {
		if (calRefItemDeptCode == null) {
			calRefItemDeptCode = new ComboCalRefItemDept();
			calRefItemDeptCode.setBounds(160, 70, 120, 20);
			calRefItemDeptCode.setMinListWidth(150);
		}
		return calRefItemDeptCode;
	}

	public LabelBase getCalRefItemItmCodeDesc() {
		if (calRefItemItmCodeDesc == null) {
			calRefItemItmCodeDesc = new LabelBase();
			calRefItemItmCodeDesc.setBounds(50, 110, 100, 20);
			calRefItemItmCodeDesc.setText("Item Code");
		}
		return calRefItemItmCodeDesc;
	}

	public TextString getCalRefItemItmCode() {
		if (calRefItemItmCode == null) {
			calRefItemItmCode = new TextString(10);
			calRefItemItmCode.setBounds(160, 110, 120, 20);
		}
		return calRefItemItmCode;
	}

	public LabelBase getCalRefItemAmtDesc() {
		if (calRefItemAmtDesc == null) {
			calRefItemAmtDesc = new LabelBase();
			calRefItemAmtDesc.setBounds(50, 150, 100, 20);
			calRefItemAmtDesc.setText("Amount");
		}
		return calRefItemAmtDesc;
	}

	public TextReadOnly getCalRefItemAmt() {
		if (calRefItemAmt == null) {
			calRefItemAmt = new TextReadOnly();
			calRefItemAmt.setBounds(160, 150, 120, 20);
		}
		return calRefItemAmt;
	}
}