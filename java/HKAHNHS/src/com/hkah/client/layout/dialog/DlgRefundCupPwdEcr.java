package com.hkah.client.layout.dialog;

import com.hkah.client.MainFrame;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextPassword;
import com.hkah.client.layout.textfield.TextString;

public class DlgRefundCupPwdEcr extends DialogBase{
    private final static int m_frameWidth = 350;
    private final static int m_frameHeight = 180;
    private final static String OK_COMMAND = "OK";
    private final static String Cancel_COMMAND = "Cancel";
    private BasePanel dialogPanel = null;
    private LabelBase passwordDesc=null;
    private TextPassword password=null;
    private LabelBase ecrDesc=null;
    private TextString ecr=null;
    private ButtonBase ButtonBase_Ok = null;
    private ButtonBase ButtonBase_Cancel = null;
    private String pwdStr="";
	private String ecrStr="";

	public DlgRefundCupPwdEcr(MainFrame owner) {
    	super(owner, m_frameWidth, m_frameHeight);
    	init();
    }

	public DlgRefundCupPwdEcr() {
		init();
	}
	protected void init() {
    	setTitle("Cup Transaction Refund Information");
    	getContentPane().add(getDialogPanel(),null);
    }

	public BasePanel getDialogPanel() {
		if (dialogPanel == null) {
			dialogPanel = new BasePanel();
			dialogPanel.setLocation(5, 5);
			dialogPanel.setEtchedBorder();
			dialogPanel.setSize(333, 120);
			dialogPanel.add(getPasswordDesc(), null);
			dialogPanel.add(getPassword(), null);
			dialogPanel.add(getEcrDesc(), null);
			dialogPanel.add(getEcr(), null);
		}
		return dialogPanel;
	}

	public LabelBase getPasswordDesc() {
		if (passwordDesc==null) {
			passwordDesc=new LabelBase();
			passwordDesc.setText("Password");
			passwordDesc.setBounds(20, 20, 120, 20);
		}
		return passwordDesc;
	}

	public TextPassword getPassword() {
		if (password==null) {
			password=new TextPassword();
			password.setBounds(150, 20, 120, 20);
		}
		return password;
	}

	public LabelBase getEcrDesc() {
		if (ecrDesc==null) {
			ecrDesc=new LabelBase();
			ecrDesc.setText("ECR Reference No.");
			ecrDesc.setBounds(20,45, 120, 20);
		}
		return ecrDesc;
	}

	public TextString getEcr() {
		if (ecr==null) {
			ecr=new TextString();
			ecr.setBounds(150, 45, 120, 20);
		}
		return ecr;
	}

	public ButtonBase getButtonBase_Ok() {
		if (ButtonBase_Ok==null) {
			ButtonBase_Ok=new ButtonBase() {
				@Override
				public void onClick() {
					pwdStr=getPwd().intern().trim();
					ecrStr=getEcr().getText().trim();
					dispose();
				}
			};
			ButtonBase_Ok.setText(OK_COMMAND);
			ButtonBase_Ok.setBounds(60, 70, 80, 20);
		}
		return ButtonBase_Ok;
	}

	public ButtonBase getButtonBase_Cancel() {
		if (ButtonBase_Cancel==null) {
			ButtonBase_Cancel=new ButtonBase() {
				@Override
				public void onClick() {
					pwdStr="";
					ecrStr="";
					dispose();
				}
			};
			ButtonBase_Cancel.setText(Cancel_COMMAND);
			ButtonBase_Cancel.setBounds(150, 70, 80, 20);
		}
		return ButtonBase_Cancel;
	}

    public String getPwd() {
    	return pwdStr+"|"+ecrStr;
    }
}