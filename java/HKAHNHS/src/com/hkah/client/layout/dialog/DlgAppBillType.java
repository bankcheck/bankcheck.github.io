/*
 * Created on July 3, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.hkah.client.layout.dialog;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;

import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.combobox.ComboAppBillType;
import com.hkah.client.layout.combobox.ComboCountry;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextAreaBase;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class DlgAppBillType extends DialogBase {

    private final static int m_frameWidth = 580;
    private final static int m_frameHeight = 300;

	private BasePanel dialogTopPanel = null;
	private LabelBase Label_BillType = null;
	private LabelBase Label_Rmk = null;

	private ComboAppBillType appBillType = null;
	private TextAreaBase remark = null;
	
	String memStmtType = null;
	String memPatNo = null;
	
	public DlgAppBillType(MainFrame owner) {
        super(owner, YESNO, m_frameWidth, m_frameHeight);
        setClosable(true);	
        initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Post to App Billing");

		setContentPane(getDialogTopPanel());

    	// change label
		getButtonById(YES).setText("Preview");
		getButtonById(NO).setText("Post");
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String stmtType) {
		memStmtType = stmtType;
		getAppBillType().refreshContent(new String[]{memStmtType});
		layout();
	    setVisible(true);
	}
	
	public void showDialog(String stmtType, String patNo) {
		memStmtType = stmtType;
		memPatNo = patNo;
		getAppBillType().refreshContent(new String[]{memStmtType});
		layout();
	    setVisible(true);
	}

	@Override
	protected void doYesAction() {
		doPreview();
	}
	
	@Override
	protected void doNoAction() {
		doPostToApp();
	}


	public  void doPostToApp() {
	}
	
	public  void doPreview() {
	}


	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getDialogTopPanel() {
		if (dialogTopPanel == null) {
			dialogTopPanel = new BasePanel();
			dialogTopPanel.setBounds(0, 0, 550, 140);
			dialogTopPanel.add(getLabel_BillType(), null);
			dialogTopPanel.add(getAppBillType(), null);
			dialogTopPanel.add(getLabel_Rmk(), null);
			dialogTopPanel.add(getRemark(), null);
		
		}
		return dialogTopPanel;
	}

	public LabelBase getLabel_BillType() {
		if (Label_BillType == null) {
			Label_BillType = new LabelBase();
			Label_BillType.setText("Bill Type");
			Label_BillType.setBounds(5, 5, 100, 20);
		}
		return Label_BillType;
	}

	public ComboAppBillType getAppBillType() {
		if (appBillType == null) {
			appBillType = new ComboAppBillType(memStmtType){
				@Override
				protected void onSelected() {
					if (!"".equals(getText())){
						QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
								new String[] {"PATIENT", "NHS_UTL_ERRORMESSAGE('MOBILEAPP','CL_'||'"+getText()+"',MOTHCODE)", "PATNO = '"+memPatNo+"' "},
								new MessageQueueCallBack() {
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									if (!"".equals(mQueue.getContentField()[0])&& mQueue.getContentField()[0] != null) {
										getRemark().setText(mQueue.getContentField()[0]);
										getRemark().setStyleAttribute("white-space", "pre-wrap");
									} else {
										getRemark().setText("");
									}
								}
							}
						});
					}
				}
			};
			appBillType.setBounds(140, 5, 200, 20);
		}
		return appBillType;
	}

	public LabelBase getLabel_Rmk() {
		if (Label_Rmk == null) {
			Label_Rmk = new LabelBase();
			Label_Rmk.setText("Remark");
			Label_Rmk.setBounds(5, 35, 100, 20);
		}
		return Label_Rmk;
	}

	public TextAreaBase getRemark() {
		if (remark == null) {
			remark = new TextAreaBase(true);
			remark.setBounds(140, 35, 400, 200);
		}
		return remark;
	}



}