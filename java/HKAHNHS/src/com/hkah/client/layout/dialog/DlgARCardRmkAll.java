package com.hkah.client.layout.dialog;

import com.google.gwt.user.client.Window;
import com.hkah.client.MainFrame;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextAreaBase;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
@SuppressWarnings("serial")
public class DlgARCardRmkAll extends DialogBase {

    private final static int m_frameWidth = 680;
    private final static int m_frameHeight = 600;

	private final static String OK_COMMAND = "OK";
	private final static String WEBSIT_COMMAND = "Show Web Site";

	private BasePanel dialogTopPanel = null;
	private BasePanel dialogBtmPanel = null;
	private LabelBase Label_ActCode = null;
	private LabelBase Label_RegType1 = null;
	private ButtonBase ButtonBase_WebSite1 = null;
	private TextAreaBase remarkTextArea1 = null;
	private LabelBase Label_RegType2 = null;
	private ButtonBase ButtonBase_WebSite2 = null;
	private TextAreaBase remarkTextArea2 = null;
	private LabelBase Label_RegType3 = null;
	private ButtonBase ButtonBase_WebSite3 = null;
	private TextAreaBase remarkTextArea3 = null;
	private LabelBase Label_RegType4 = null;
	private ButtonBase ButtonBase_WebSite4 = null;
	private TextAreaBase remarkTextArea4 = null;
	private LabelBase Label_RegType5 = null;
	private ButtonBase ButtonBase_WebSite5 = null;
	private TextAreaBase remarkTextArea5 = null;
	private LabelBase Label_RegType6 = null;
	private ButtonBase ButtonBase_WebSite6 = null;
	private TextAreaBase remarkTextArea6 = null;
	private ButtonBase ButtonBase_Close = null;

	private String memActID = null;
	private String memActCode = null;
	private String memArcCode = null;
//	private String memRegType = null;
//	private boolean memIsRegistration = true;
	private String memUrl1 = null;
	private String memUrl2 = null;
	private String memUrl3 = null;
	private String memUrl4 = null;
	private String memUrl5 = null;
	private String memUrl6 = null;
//	private boolean memOkOnly = true;

	private DlgARCardRemark source = null;

	public DlgARCardRmkAll(MainFrame owner) {
        super(owner, null, m_frameWidth, m_frameHeight);
        initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("AR Card Type All Remark");

		BasePanel panel = new BasePanel();
		panel.setLayout(null);
		panel.setSize(m_frameWidth, m_frameHeight);
		panel.add(getDialogTopPanel(), null);
		panel.add(getDialogBtmPanel(), null);
		getContentPane().add(panel, null);

		setClosable(false);
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String arcode, String actID,
			String regType, boolean isRegistration, boolean okOnly,
			DlgARCardRemark dlg) {
        memActID = actID;
        memArcCode = arcode;
//        memRegType = regType;
//        memIsRegistration = isRegistration;
//        memOkOnly = okOnly;
        source = dlg;
		setVisible(false);

        QueryUtil.executeMasterBrowse(getUserInfo(), "ARCARDTYPE",
				new String[] { memArcCode, memActID, "-1" },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success() && mQueue.getContentField().length > 0) {
					memActCode = mQueue.getContentField()[0];
					getLabel_ActCode().setText(memActCode);

					getRemarkTextArea1().setText(mQueue.getContentField()[1]);
					getRemarkTextArea2().setText(mQueue.getContentField()[4]);
					getRemarkTextArea3().setText(mQueue.getContentField()[2]);
					getRemarkTextArea4().setText(mQueue.getContentField()[5]);
					getRemarkTextArea5().setText(mQueue.getContentField()[3]);
					getRemarkTextArea6().setText(mQueue.getContentField()[6]);

					memUrl1 = mQueue.getContentField()[7];//RegRmkIPUrl
					memUrl2 = mQueue.getContentField()[10];//PayRmkIPUrl
					memUrl3 = mQueue.getContentField()[8];//RegRmkOPUrl
					memUrl4 = mQueue.getContentField()[11];//PayRmkOPUrl
					memUrl5 = mQueue.getContentField()[9];//RegRmkDCUrl
					memUrl6 = mQueue.getContentField()[12];//PayRmkDCUrl

					getButtonBase_WebSite1().setEnabled(memUrl1 != null && memUrl1.length() > 0);
					getButtonBase_WebSite2().setEnabled(memUrl4 != null && memUrl4.length() > 0);
					getButtonBase_WebSite3().setEnabled(memUrl2 != null && memUrl2.length() > 0);
					getButtonBase_WebSite4().setEnabled(memUrl5 != null && memUrl5.length() > 0);
					getButtonBase_WebSite5().setEnabled(memUrl3 != null && memUrl3.length() > 0);
					getButtonBase_WebSite6().setEnabled(memUrl6 != null && memUrl6.length() > 0);

					setVisible(true);
				}
			}
		});
	}

	public void post() {
		// return to child class
		source.show();
		dispose();
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getDialogTopPanel() {
		if (dialogTopPanel == null) {
			dialogTopPanel = new BasePanel();
			dialogTopPanel.setEtchedBorder();
			dialogTopPanel.setBounds(0, 0, 650, 500);
			dialogTopPanel.add(getLabel_ActCode(), null);
			dialogTopPanel.add(getLabel_RegType1(), null);
			dialogTopPanel.add(getButtonBase_WebSite1(), null);
			dialogTopPanel.add(getRemarkTextArea1(), null);
			dialogTopPanel.add(getLabel_RegType2(), null);
			dialogTopPanel.add(getButtonBase_WebSite2(), null);
			dialogTopPanel.add(getRemarkTextArea2(), null);
			dialogTopPanel.add(getLabel_RegType3(), null);
			dialogTopPanel.add(getButtonBase_WebSite3(), null);
			dialogTopPanel.add(getRemarkTextArea3(), null);
			dialogTopPanel.add(getLabel_RegType4(), null);
			dialogTopPanel.add(getButtonBase_WebSite4(), null);
			dialogTopPanel.add(getRemarkTextArea4(), null);
			dialogTopPanel.add(getLabel_RegType5(), null);
			dialogTopPanel.add(getButtonBase_WebSite5(), null);
			dialogTopPanel.add(getRemarkTextArea5(), null);
			dialogTopPanel.add(getLabel_RegType6(), null);
			dialogTopPanel.add(getButtonBase_WebSite6(), null);
			dialogTopPanel.add(getRemarkTextArea6(), null);
		}
		return dialogTopPanel;
	}

	public BasePanel getDialogBtmPanel() {
		if (dialogBtmPanel == null) {
			dialogBtmPanel = new BasePanel();
			dialogBtmPanel.setEtchedBorder();
			dialogBtmPanel.setBounds(0, 510, 650, 30);
			dialogBtmPanel.add(getButtonBase_Close(), null);
		}
		return dialogBtmPanel;
	}

	public LabelBase getLabel_ActCode() {
		if (Label_ActCode == null) {
			Label_ActCode = new LabelBase();
			Label_ActCode.setBounds(5, 5, 120, 20);
		}
		return Label_ActCode;
	}

	public LabelBase getLabel_RegType1() {
		if (Label_RegType1 == null) {
			Label_RegType1 = new LabelBase();
			Label_RegType1.setText("In-Patient Registration Remark");
			Label_RegType1.setBounds(5, 30, 200, 20);
		}
		return Label_RegType1;
	}

	public ButtonBase getButtonBase_WebSite1() {
		if (ButtonBase_WebSite1 == null) {
			ButtonBase_WebSite1 = new ButtonBase() {
				@Override
				public void onClick() {
					openNewWindow(memUrl1);
				}
			};
			ButtonBase_WebSite1.setText(WEBSIT_COMMAND);
			ButtonBase_WebSite1.setBounds(185, 30, 130, 20);
		}
		return ButtonBase_WebSite1;
	}

	public TextAreaBase getRemarkTextArea1() {
		if (remarkTextArea1 == null) {
			remarkTextArea1 = new TextAreaBase(false);
			remarkTextArea1.setBounds(5, 50, 310, 120);
		}
		return remarkTextArea1;
	}

	public LabelBase getLabel_RegType2() {
		if (Label_RegType2 == null) {
			Label_RegType2 = new LabelBase();
			Label_RegType2.setText("In-Patient Payment Remark");
			Label_RegType2.setBounds(325, 30, 200, 20);
		}
		return Label_RegType2;
	}

	public ButtonBase getButtonBase_WebSite2() {
		if (ButtonBase_WebSite2 == null) {
			ButtonBase_WebSite2 = new ButtonBase() {
				@Override
				public void onClick() {
					openNewWindow(memUrl2);
				}
			};
			ButtonBase_WebSite2.setText(WEBSIT_COMMAND);
			ButtonBase_WebSite2.setBounds(505, 30, 130, 20);
		}
		return ButtonBase_WebSite2;
	}

	public TextAreaBase getRemarkTextArea2() {
		if (remarkTextArea2 == null) {
			remarkTextArea2 = new TextAreaBase(false);
			remarkTextArea2.setBounds(325, 50, 310, 120);
		}
		return remarkTextArea2;
	}

	public LabelBase getLabel_RegType3() {
		if (Label_RegType3 == null) {
			Label_RegType3 = new LabelBase();
			Label_RegType3.setText("Out-patient Registration Remark");
			Label_RegType3.setBounds(5, 190, 200, 20);
		}
		return Label_RegType3;
	}

	public ButtonBase getButtonBase_WebSite3() {
		if (ButtonBase_WebSite3 == null) {
			ButtonBase_WebSite3 = new ButtonBase() {
				@Override
				public void onClick() {
					openNewWindow(memUrl3);
				}
			};
			ButtonBase_WebSite3.setText(WEBSIT_COMMAND);
			ButtonBase_WebSite3.setBounds(185, 190, 130, 20);
		}
		return ButtonBase_WebSite3;
	}

	public TextAreaBase getRemarkTextArea3() {
		if (remarkTextArea3 == null) {
			remarkTextArea3 = new TextAreaBase(false);
			remarkTextArea3.setBounds(5, 210, 310, 120);
		}
		return remarkTextArea3;
	}

	public LabelBase getLabel_RegType4() {
		if (Label_RegType4 == null) {
			Label_RegType4 = new LabelBase();
			Label_RegType4.setText("Out-patient Payment Remark");
			Label_RegType4.setBounds(325, 190, 200, 20);
		}
		return Label_RegType4;
	}

	public ButtonBase getButtonBase_WebSite4() {
		if (ButtonBase_WebSite4 == null) {
			ButtonBase_WebSite4 = new ButtonBase() {
				@Override
				public void onClick() {
					openNewWindow(memUrl4);
				}
			};
			ButtonBase_WebSite4.setText(WEBSIT_COMMAND);
			ButtonBase_WebSite4.setBounds(505, 190, 130, 20);
		}
		return ButtonBase_WebSite4;
	}

	public TextAreaBase getRemarkTextArea4() {
		if (remarkTextArea4 == null) {
			remarkTextArea4 = new TextAreaBase(false);
			remarkTextArea4.setBounds(325, 210, 310, 120);
		}
		return remarkTextArea4;
	}

	public LabelBase getLabel_RegType5() {
		if (Label_RegType5 == null) {
			Label_RegType5 = new LabelBase();
			Label_RegType5.setText("Day Case Registration Remark");
			Label_RegType5.setBounds(5, 350, 200, 20);
		}
		return Label_RegType5;
	}

	public ButtonBase getButtonBase_WebSite5() {
		if (ButtonBase_WebSite5 == null) {
			ButtonBase_WebSite5 = new ButtonBase() {
				@Override
				public void onClick() {
					openNewWindow(memUrl5);
				}
			};
			ButtonBase_WebSite5.setText(WEBSIT_COMMAND);
			ButtonBase_WebSite5.setBounds(185, 350, 130, 20);
		}
		return ButtonBase_WebSite5;
	}

	public TextAreaBase getRemarkTextArea5() {
		if (remarkTextArea5 == null) {
			remarkTextArea5 = new TextAreaBase(false);
			remarkTextArea5.setBounds(5, 370, 310, 120);
		}
		return remarkTextArea5;
	}

	public LabelBase getLabel_RegType6() {
		if (Label_RegType6 == null) {
			Label_RegType6 = new LabelBase();
			Label_RegType6.setText("Day Case Payment Remark");
			Label_RegType6.setBounds(325, 350, 200, 20);
		}
		return Label_RegType6;
	}

	public ButtonBase getButtonBase_WebSite6() {
		if (ButtonBase_WebSite6 == null) {
			ButtonBase_WebSite6 = new ButtonBase() {
				@Override
				public void onClick() {
					openNewWindow(memUrl6);
				}
			};
			ButtonBase_WebSite6.setText(WEBSIT_COMMAND);
			ButtonBase_WebSite6.setBounds(505, 350, 130, 20);
		}
		return ButtonBase_WebSite6;
	}

	public TextAreaBase getRemarkTextArea6() {
		if (remarkTextArea6 == null) {
			remarkTextArea6 = new TextAreaBase(false);
			remarkTextArea6.setBounds(325, 370, 310, 120);
		}
		return remarkTextArea6;
	}

	public ButtonBase getButtonBase_Close() {
		if (ButtonBase_Close == null) {
			ButtonBase_Close = new ButtonBase() {
				@Override
				public void onClick() {
					post();
				}
			};
			ButtonBase_Close.setText(OK_COMMAND);
			ButtonBase_Close.setBounds(270, 5, 80, 20);
		}
		return ButtonBase_Close;
	}

	/**
	 * Opens a new windows with a specified URL..
	 *
	 * @param name String with the name of the window.
	 * @param url String with your URL.
	 */
	public static void openNewWindow(String url) {
		Window.open(url, "_blank", null);
	}
}