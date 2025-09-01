/*
 * Created on July 3, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.hkah.client.layout.dialog;

import java.io.File;

import com.extjs.gxt.ui.client.event.BaseEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.MessageBox;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextPassword;
import com.hkah.client.layout.textfield.TextUserID;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.PasswordUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTableColumn;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public abstract class DlgDIReportReopen extends DialogBase implements ConstantsTableColumn {

    private final static int m_frameWidth = 450;
    private final static int m_frameHeight = 280;

	private BasePanel dialogTopPanel = null;
	private LabelBase Label_Info = null;
	private LabelBase Label_UserDesc = null;
	private TextUserID Text_UserNo = null;
	private LabelBase Label_PwDesc = null;
	private TextPassword Text_Password = null;
	private LabelBase Label_Note = null;
	
	private String SignDir = null;
	private String jpgSignDir = null;
	private String bmpSignDir = null;
	
	private String xrgid = null;
	private String xrpid = null;
	private String doccode = null; 
	
	public DlgDIReportReopen(MainFrame owner) {
        super(owner, OKCANCEL, m_frameWidth, m_frameHeight);
        initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Report Reopen");

		setContentPane(getDialogTopPanel());
		addListener(Events.Hide, new Listener<BaseEvent>() {
			@Override
			public void handleEvent(BaseEvent be) {
				dlgClose();
			}
		});
	}
	
	public abstract void post(boolean success);


	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected void doOkAction() {
		checkReopenUser();
	}
	
	@Override
	protected void doCancelAction() {
		//System.out.println("[DEBUG]: doCancelAction() FALSE");
		post(false);
	}	
	
	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String regid, String rptid, String rptdr) {//XRGID, XRPID, DOCCODE
		xrgid = regid;
		xrpid = rptid;
		doccode = rptdr.toUpperCase();
		
		getJTextUser().resetText();
		getTextPassword().resetText();
		getJTextUser().focus();
		
		setVisible(true);
	}

	protected void dlgClose() {
		post(false);
	};
	
	private void checkReopenUser(){
		final String usr1 = getJTextUser().getText().trim().toUpperCase();
		final String pwd1 = new String(getTextPassword().getPassword());
		final String logUsr = getUserInfo().getUserID();
		System.out.println("[DEBUG] user: " + usr1 + " ; pwd: " + pwd1 + " ; logUsr: " + logUsr );
		
		if (!(usr1.length() > 0  && pwd1.length() > 0 )) {
			Factory.getInstance().addSystemMessage("User ID or Password should not be blank.");
			return;
		}

		if (!doccode.equals(usr1.substring(2))) {
			Factory.getInstance().addSystemMessage("The reopen user should be the reported doctor.");
			return;
		}
		
		QueryUtil.executeTx(getUserInfo(), "ACT_LOGON_SECHK", // check portal password
				new String[] { usr1, PasswordUtil.cisEncryption(pwd1),CommonUtil.getComputerName() },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					//Reopen Report
					reopenReport(usr1);
				} else {
					Factory.getInstance().addSystemMessage("Invalid user name or password.");
					getJTextUser().resetText();
					getTextPassword().resetText();
				}
			}
		});
	}

	public void reopenReport(String usr1) {
		QueryUtil.executeMasterAction(getUserInfo(), "DIREOPENREPORT", QueryUtil.ACTION_APPEND, 
				new String[] { xrgid, xrpid, usr1, getUserInfo().getUserID()},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					Factory.getInstance().addSystemMessage("Report Reopend.");
					//mQueue.getReturnCode();
					post(true);
				}else{
					Factory.getInstance().addSystemMessage("Report cannot be reopen.");
					post(false);
				}
			}
		});
	}
	
	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getDialogTopPanel() {
		if (dialogTopPanel == null) {
			dialogTopPanel = new BasePanel();
			dialogTopPanel.setBounds(0, 0, 420, 190);
			//dialogTopPanel.add(getRemarkPanel(), null);
			dialogTopPanel.add(getLabel_Info(), null);
			dialogTopPanel.add(getLabel_UserDesc(), null);
			dialogTopPanel.add(getJTextUser(), null);
			dialogTopPanel.add(getLabel_PwDesc(), null);
			dialogTopPanel.add(getTextPassword(), null);
			dialogTopPanel.add(getLabel_Note(), null);
			dialogTopPanel.add(getLabel_Info(), null);
			
		}
		return dialogTopPanel;
	}

	public LabelBase getLabel_Info() {
		if (Label_Info == null) {
			Label_Info = new LabelBase();
			Label_Info.setText("Are you sure to reopen?");
			Label_Info.setBounds(40, 25, 200, 20);
		}
		return Label_Info;
	}
	
	public LabelBase getLabel_UserDesc() {
		if (Label_UserDesc == null) {
			Label_UserDesc = new LabelBase();
			Label_UserDesc.setText("User ID");
			Label_UserDesc.setBounds(60, 60, 100, 20);
		}
		return Label_UserDesc;
	}

	public TextUserID getJTextUser() {
		if (Text_UserNo == null) {
			Text_UserNo = new TextUserID(){
				public void onEnter() {
					checkReopenUser();
				}
			};
			Text_UserNo.setBounds(170, 60, 135, 20);
		}
		return Text_UserNo;
	}

	public LabelBase getLabel_PwDesc() {
		if (Label_PwDesc == null) {
			Label_PwDesc = new LabelBase();
			Label_PwDesc.setText("Password");
			Label_PwDesc.setBounds(60, 90, 100, 20);
		}
		return Label_PwDesc;
	}

	public TextPassword getTextPassword() {
		if (Text_Password == null) {
			Text_Password = new TextPassword(false) {
				public void onEnter() {
					checkReopenUser();
				}
			};
			Text_Password.setBounds(170, 90, 135, 20);
		}
		return Text_Password;
	}
	
	public LabelBase getLabel_Note() {
		if (Label_Note == null) {
			Label_Note = new LabelBase();
			Label_Note.setText(	"Note: <br> The reopen user should be the reported doctor.");
			Label_Note.setBounds(40, 120, 350, 50);
		}
		return Label_Note;
	}
	
}