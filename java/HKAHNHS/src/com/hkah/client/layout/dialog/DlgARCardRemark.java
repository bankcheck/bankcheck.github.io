/*
 * Created on July 3, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.hkah.client.layout.dialog;

import com.extjs.gxt.ui.client.widget.ContentPanel;
import com.google.gwt.user.client.Window;
import com.hkah.client.MainFrame;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextAreaBase;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTransaction;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
@SuppressWarnings("serial")
public class DlgARCardRemark extends DialogBase {

    private final static int m_frameWidth = 700;
    private final static int m_frameHeight = 500;

	private final static String OK_COMMAND = "OK";
	private final static String WEBSIT_COMMAND = "Show Web Site";
	private final static String ALLREMARK_COMMAND = "Show All Remarks";
	private final static String CONTINUE_COMMAND = "Continue";
	private final static String CANCEL_COMMAND = "Cancel";

	private BasePanel dialogTopPanel = null;
	private BasePanel dialogBtmPanel = null;
	private TextAreaBase remarkTextArea = null;
	private ContentPanel ContentPanelURL = null;
	private ButtonBase ButtonBase_Ok = null;
	private ButtonBase ButtonBase_WebSite = null;
	private ButtonBase ButtonBase_AllRemark = null;
	private ButtonBase ButtonBase_Cancel = null;
	private LabelBase Label_RegType = null;

	private DlgARCardRmkAll dlgARCardRmkAll = null;

	private String memSource = null;
	private String memActID = null;
	private String memActCode = null;
	private String memArcCode = null;
	private String memRegType = null;
	private boolean memIsRegistration = true;
	private String memUrl = null;
	private boolean memOkOnly = true;

	public boolean isContinue = false;

	public DlgARCardRemark(MainFrame owner) {
        super(owner, null, m_frameWidth, m_frameHeight);
        initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("AR Card Remark");

		BasePanel panel = new BasePanel();
		panel.setLayout(null);
		panel.setSize(640, 496);
		panel.add(getDialogTopPanel(), null);
		panel.add(getDialogBtmPanel(), null);
		getContentPane().add(panel, null);

		setClosable(false);
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String source, String arcode, String actID, String regType,
			boolean isRegistration, boolean okOnly) {
		isContinue = false;
		memSource = source;
        memActID = actID;
        memArcCode = arcode;
        memRegType = regType;
        memIsRegistration = isRegistration;
        memOkOnly = okOnly;
        addButton(okOnly);
        setVisible(false);

		QueryUtil.executeMasterBrowse(getUserInfo(), "ARCARDTYPE",
				new String[] { memArcCode, memActID, "-1" },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success() && mQueue.getContentField().length > 0) {
					memActCode = mQueue.getContentField()[0];

					if (memActCode != null && memActCode.length() > 0) {
						setTitle(memActCode + " Remark");
					}

					String regTypeLabel = null;
					String remark = null;
	
					if (ConstantsTransaction.SLIP_TYPE_INPATIENT.equals(memRegType)) {
						if (memIsRegistration) {							
							regTypeLabel = "In-patient Pop-up Alert";
							remark = mQueue.getContentField()[4];
							memUrl = mQueue.getContentField()[10];
						} else {							
							regTypeLabel = "In-patient Pop-up Alert";
							remark = mQueue.getContentField()[4];
							memUrl = mQueue.getContentField()[10];
						}
					} else if (ConstantsTransaction.SLIP_TYPE_OUTPATIENT.equals(memRegType)) {
						if (memIsRegistration) {							
							regTypeLabel = "Out-patient Pop-up Alert";
							remark = mQueue.getContentField()[5];
							memUrl = mQueue.getContentField()[11];
						} else {							
							regTypeLabel = "Out-patient Pop-up Alert";
							remark = mQueue.getContentField()[5];
							memUrl = mQueue.getContentField()[11];
						}
					} else if (ConstantsTransaction.SLIP_TYPE_DAYCASE.equals(memRegType)) {
						if (memIsRegistration) {							
							regTypeLabel = "Day-case Registration Remark";
//							remark = mQueue.getContentField()[3];
//							memUrl = mQueue.getContentField()[9];
							remark = mQueue.getContentField()[4];
							memUrl = mQueue.getContentField()[10];							
						} else {							
							regTypeLabel = "Day-case Payment Remark";
//							remark = mQueue.getContentField()[6];
//							memUrl = mQueue.getContentField()[12];
							remark = mQueue.getContentField()[4];
							memUrl = mQueue.getContentField()[10];							
						}
					}

					getLabel_RegType().setText(regTypeLabel);
					getButtonBase_WebSite().setEnabled(memUrl != null && memUrl.length() > 0);
					
					if (remark != null && remark.length() > 0) {						
						getRemarkTextArea().setText(remark);
						setVisible(true);						
					}
				}
			}
		});
	}

	public void post(String source, String actCode, String actId) {}

	public DlgARCardRmkAll getDlgARCardRmkAll() {
		if (dlgARCardRmkAll == null) {
			dlgARCardRmkAll = new DlgARCardRmkAll(getMainFrame());
		}
		return dlgARCardRmkAll;
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getDialogTopPanel() {
		if (dialogTopPanel == null) {
			dialogTopPanel = new BasePanel();
			dialogTopPanel.setEtchedBorder();
			dialogTopPanel.setBounds(6, 8, 650, 395);
			dialogTopPanel.add(getLabel_RegType(), null);
			dialogTopPanel.add(getRemarkTextArea(), null);
		}
		return dialogTopPanel;
	}

	public BasePanel getDialogBtmPanel() {
		if (dialogBtmPanel == null) {
			dialogBtmPanel = new BasePanel();
			dialogBtmPanel.setEtchedBorder();
			dialogBtmPanel.setBounds(6, 400, 650, 50);
			dialogBtmPanel.add(getButtonBase_Ok(), null);

			if (!memOkOnly) {
				dialogBtmPanel.add(getButtonBase_Cancel(), null);
			}
			dialogBtmPanel.add(getButtonBase_WebSite(), null);
			dialogBtmPanel.add(getButtonBase_AllRemark(), null);
//			dialogBtmPanel.add(getContentPanel(), null);
		}
		return dialogBtmPanel;
	}

	public LabelBase getLabel_RegType() {
		if (Label_RegType == null) {
			Label_RegType = new LabelBase();
			Label_RegType.setText("Registration Remark");
			Label_RegType.setBounds(5, 5, 200, 20);
		}
		return Label_RegType;
	}

	public TextAreaBase getRemarkTextArea() {
		if (remarkTextArea == null) {
			remarkTextArea = new TextAreaBase(false);
			remarkTextArea.setBounds(10, 30, 630, 350);
		}
		return remarkTextArea;
	}

	public ContentPanel getContentPanel() {
		if (ContentPanelURL == null) {
			ContentPanelURL = new ContentPanel();
		}
		return ContentPanelURL;
	}

	public ButtonBase getButtonBase_Ok() {
		if (ButtonBase_Ok == null) {
			ButtonBase_Ok = new ButtonBase() {
				@Override
				public void onClick() {
					if (!memOkOnly) {
						isContinue = true;
					}
					post(memSource, memActCode, memActID);
					dispose();
				}
			};
			if (memOkOnly) {
				ButtonBase_Ok.setText(OK_COMMAND);
				ButtonBase_Ok.setBounds(180, 11, 80, 20);
			} else {
				ButtonBase_Ok.setText(CONTINUE_COMMAND);
				ButtonBase_Ok.setBounds(95, 11, 80, 20);
			}
		}
		return ButtonBase_Ok;
	}

	public ButtonBase getButtonBase_Cancel() {
		if (ButtonBase_Cancel == null) {
			ButtonBase_Cancel = new ButtonBase() {
				@Override
				public void onClick() {
					post(memSource, memActCode, memActID);
				}
			};
			ButtonBase_Cancel.setText(CANCEL_COMMAND);
			ButtonBase_Cancel.setBounds(180, 11, 80, 20);
		}
		return ButtonBase_Cancel;
	}

	public ButtonBase getButtonBase_WebSite() {
		if (ButtonBase_WebSite == null) {
			ButtonBase_WebSite = new ButtonBase() {
				@Override
				public void onClick() {
					openNewWindow(memUrl);
				}
			};
			ButtonBase_WebSite.setText(WEBSIT_COMMAND);
			ButtonBase_WebSite.setBounds(265, 11, 130, 20);
		}
		return ButtonBase_WebSite;
	}

	public ButtonBase getButtonBase_AllRemark() {
		if (ButtonBase_AllRemark == null) {
			ButtonBase_AllRemark = new ButtonBase() {
				@Override
				public void onClick() {
					getThis().hide();
					getDlgARCardRmkAll().showDialog(memArcCode, memActID,
							memRegType, memIsRegistration, memOkOnly, getThis());
				}
			};
			ButtonBase_AllRemark.setText(ALLREMARK_COMMAND);
			ButtonBase_AllRemark.setBounds(400, 11, 130, 20);
		}
		return ButtonBase_AllRemark;
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

	public boolean isContinue() {
		return isContinue;
	}

	public DlgARCardRemark getThis() {
		return this;
	}
	
	public void addButton(boolean okOnly) {
		if (!okOnly) {
			ButtonBase_Ok.setBounds(95, 11, 80, 20);
			if (ButtonBase_Cancel == null) {
				dialogBtmPanel.add(getButtonBase_Cancel(), null);				
			}
		}		
	}
}