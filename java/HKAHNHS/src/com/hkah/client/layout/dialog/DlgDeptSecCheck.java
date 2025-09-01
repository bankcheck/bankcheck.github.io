package com.hkah.client.layout.dialog;

import com.extjs.gxt.ui.client.widget.Component;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextPassword;
import com.hkah.client.layout.textfield.TextUserID;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.PasswordUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public abstract class DlgDeptSecCheck extends DialogBase implements ConstantsVariable {

	private final static int m_frameWidth = 370;
	private final static int m_frameHeight = 170;
	private BasePanel jPanel = null;
	private ButtonBase jButton = null;
	private ButtonBase jButton1 = null;
	private LabelBase jLabel = null;
	private LabelBase jLabel1 = null;
	private LabelBase jLabel2 = null;
	private LabelBase jLabel3 = null;
	private TextUserID jTextField = null;
	private TextUserID jTextField1 = null;
	private TextPassword jPasswordField = null;
	private TextPassword jPasswordField1 = null;
	private String numOfUser = null;

	public DlgDeptSecCheck (MainFrame owner, String numOfUser) {
		super(owner, m_frameWidth, m_frameHeight);
		init();
		this.numOfUser = numOfUser;
	}

	protected void init() {
		setTitle("Security Check");
		getContentPane().add(getJPanel());
		getJTextUser1().focus();
	}

	public void dblCheck() {
		final String usr1 = getJTextUser1().getText().trim();
		final String usr2 = getJTextUser2().getText().trim();
		final String pwd1 = new String(getTextPassword().getPassword());
		final String pwd2 = new String(getTextPassword1().getPassword());
		if(!numOfUser.equals("single")){
			if (usr1.equals(usr2)) {
				Factory.getInstance().addSystemMessage("The second User ID should be different from the first User ID.");
				getJTextUser2().resetText();
				return;
			}
		}

		if (!(usr1.length() > 0 && usr2.length() > 0 && pwd1.length() > 0 && pwd2.length() > 0)) {
			Factory.getInstance().addSystemMessage("User ID or Password should not be blank.");
			return;
		}

		QueryUtil.executeTx(getUserInfo(), "ACT_LOGON_SECHK",
				new String[] { usr1, PasswordUtil.cisEncryption(pwd1),CommonUtil.getComputerName() },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					QueryUtil.executeTx(getUserInfo(), "ACT_LOGON_SECHK",
							new String[] { usr2, PasswordUtil.cisEncryption(pwd2),CommonUtil.getComputerName()},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								dispose();
								saveApp();
							} else {
								Factory.getInstance().addSystemMessage("The second User ID or password do not match.");
								getJTextUser2().resetText();
								getTextPassword1().resetText();
							}
						}
					});
				} else {
					Factory.getInstance().addSystemMessage("The first User ID or password do not match.");
					getJTextUser1().resetText();
					getTextPassword().resetText();
				}
			}
		});
	}
	
	 public abstract void saveApp();
	 
	@Override
	public Component getDefaultFocusComponent() {
		return getJTextUser1();
	}

	private BasePanel getJPanel() {
		if (jPanel == null) {
			jLabel3 = new LabelBase();
			jLabel3.setBounds(188, 55, 63, 18);
			jLabel3.setText("Password");
			jLabel2 = new LabelBase();
			jLabel2.setText("Password");
			jLabel2.setPosition(188, 18);
			jLabel2.setSize(63, 18);
			jLabel1 = new LabelBase();
			jLabel1.setText("User ID");
			jLabel1.setSize(54, 18);
			jLabel1.setPosition(12, 56);
			jLabel = new LabelBase();
			jLabel.setBounds(12, 18, 54, 18);
			jLabel.setText("User ID");
			jPanel = new BasePanel();
			jPanel.setLayout(null);
			jPanel.setSize(367, 126);
			jPanel.add(jLabel, null);
			jPanel.add(getJTextUser1(), null);
			jPanel.add(getTextPassword(), null);
			jPanel.add(jLabel1, null);
			jPanel.add(jLabel2, null);
			jPanel.add(jLabel3, null);
			jPanel.add(getJTextUser2(), null);
			jPanel.add(getTextPassword1(), null);
			jPanel.add(getButtonBaseOK(), null);
			jPanel.add(getButtonBaseCancel(), null);
			jPanel.setEtchedBorder();
		}
		return jPanel;
	}

	private ButtonBase getButtonBaseOK() {
		if (jButton == null) {
			jButton = new ButtonBase() {
				@Override
				public void onClick() {
					dblCheck();
				}
			};
			jButton.setBounds(93, 90, 77, 24);
			jButton.setText("OK");
		}
		return jButton;
	}

	private ButtonBase getButtonBaseCancel() {
		if (jButton1 == null) {
			jButton1 = new ButtonBase() {
				@Override
				public void onClick() {
					dispose();
				}
			};
			jButton1.setBounds(199, 90, 77, 24);
			jButton1.setText("Cancel");
		}
		return jButton1;
	}

	private TextUserID getJTextUser1() {
		if (jTextField == null) {
			jTextField = new TextUserID() {
				public void onEnter() {
					dblCheck();
				}
			};
			jTextField.setBounds(74, 18, 80, 22);
		}
		return jTextField;
	}

	private TextUserID getJTextUser2() {
		if (jTextField1 == null) {
			jTextField1 = new TextUserID() {
				public void onEnter() {
					dblCheck();
				}
			};
			jTextField1.setBounds(74, 54, 81, 22);
		}
		return jTextField1;
	}

	private TextPassword getTextPassword() {
		if (jPasswordField == null) {
			jPasswordField = new TextPassword(false) {
				public void onEnter() {
					dblCheck();
				}
			};	
			jPasswordField.setBounds(254, 16, 88, 22);
		}
		return jPasswordField;
	}

	private TextPassword getTextPassword1() {
		if (jPasswordField1 == null) {
			jPasswordField1 = new TextPassword(false) {
				public void onEnter() {
					dblCheck();
				}
			};
			jPasswordField1.setBounds(254,53,88, 22);
		}
		return jPasswordField1;
	}
}