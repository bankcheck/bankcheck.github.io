package com.hkah.client.layout.dialog;

import java.util.Map;

import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.widget.Component;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextPassword;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.layout.textfield.TextUserID;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.PanelUtil;
import com.hkah.client.util.PasswordUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsErrorMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public abstract class DlgPatSecCheck extends DialogBase implements ConstantsVariable {

	private final static int m_frameWidth = 480;
	private final static int m_frameHeight = 600;
	private BasePanel patPanel = null;
	private BasePanel jPanel = null;
	private LabelBase lbl_From = null;
	private LabelBase lbl_To = null;
	
	private LabelBase lbl_PatGName = null;
	private LabelBase lbl_PatGNameFrom = null;
	private TextReadOnly Text_OldPatGName = null;
	private LabelBase lbl_PatGNameTo = null;
	private TextReadOnly Text_NewPatGName = null;
	
	private LabelBase lbl_PatFName = null;
	private TextReadOnly Text_OldPatFName = null;
	private LabelBase lbl_PatFNameFrom = null;
	private LabelBase lbl_PatFNameTo = null;
	private TextReadOnly Text_NewPatFName = null;
	
	private LabelBase lbl_PatCName = null;
	private TextReadOnly Text_OldPatCName = null;
	private TextReadOnly Text_NewPatCName = null;
	
	private LabelBase lbl_PatDOB = null;
	private TextReadOnly Text_OldPatDOB = null;
	private TextReadOnly Text_NewPatDOB = null;
	
	private LabelBase lbl_PatSex = null;
	private TextReadOnly Text_OldPatSex = null;
	private TextReadOnly Text_NewPatSex = null;
	
	private LabelBase lbl_PatDocID = null;
	private TextReadOnly Text_OldPatDocID = null;
	private TextReadOnly Text_NewPatDocID = null;
	
	private LabelBase lbl_PatDocType = null;
	private ComboBoxBase Text_OldPatDocType = null;
	private ComboBoxBase Text_NewPatDocType = null;
	
	private LabelBase lbl_PatDocA1ID = null;
	private TextReadOnly Text_OldPatDocA1ID = null;
	private TextReadOnly Text_NewPatDocA1ID = null;
	
	private LabelBase lbl_PatDocA1Type = null;
	private ComboBoxBase Text_OldPatDocA1Type = null;
	private ComboBoxBase Text_NewPatDocA1Type = null;
	
	private LabelBase lbl_PatDocA2ID = null;
	private TextReadOnly Text_OldPatDocA2ID = null;
	private TextReadOnly Text_NewPatDocA2ID = null;
	
	private LabelBase lbl_PatDocA2Type = null;
	private ComboBoxBase Text_OldPatDocA2Type = null;
	private ComboBoxBase Text_NewPatDocA2Type = null;
	
	private LabelBase jLabel = null;
	private LabelBase jLabel1 = null;
	private LabelBase jLabel2 = null;
	private LabelBase jLabel3 = null;
	private TextReadOnly jTextField = null;
	private TextUserID jTextField1 = null;
	private TextPassword jPasswordField = null;
	private TextPassword jPasswordField1 = null;
	
	private String patNo = null;
	private String docTypeDesc = null;

	public DlgPatSecCheck (MainFrame owner) {
		super(owner,"okcancel", m_frameWidth, m_frameHeight);
		init();
	}

	protected void init() {
		setTitle("Patient Information Change");
		getContentPane().add(getPatPanel());
		getContentPane().add(getJPanel());
		getJTextUser1().focus();
	}
	
	public void showDialog(Map<String,String> patInf,String patNum) {
		setVisible(false);
		PanelUtil.resetAllFields(getPatPanel());
		PanelUtil.resetAllFields(getJPanel());
		patNo = patNum;
		if (patInf.size() > 0) {
			if(!"".equals(patInf.get("GNAME")) && patInf.get("GNAME")!= null) {
				getText_OldPatGName().setText(patInf.get("GNAME").split("<N>")[0]);
				getText_NewPatGName().setText(patInf.get("GNAME").split("<N>").length > 1? patInf.get("GNAME").split("<N>")[1]:"");
			}
			if(!"".equals(patInf.get("FNAME")) && patInf.get("FNAME")!= null) {
				getText_OldPatFName().setText(patInf.get("FNAME").split("<N>")[0]);
				getText_NewPatFName().setText(patInf.get("FNAME").split("<N>").length > 1? patInf.get("FNAME").split("<N>")[1]:"");
			}
			if(!"".equals(patInf.get("CNAME")) && patInf.get("CNAME")!= null) {
				getText_OldPatCName().setText(patInf.get("CNAME").split("<N>")[0]);
				getText_NewPatCName().setText(patInf.get("CNAME").split("<N>").length > 1? patInf.get("CNAME").split("<N>")[1]:"");
			}
			if(!"".equals(patInf.get("DOB")) && patInf.get("DOB")!= null) {
				getText_OldPatDOB().setText(patInf.get("DOB").split("<N>")[0]);
				getText_NewPatDOB().setText(patInf.get("DOB").split("<N>").length > 1? patInf.get("DOB").split("<N>")[1]:"");
			}
			if(!"".equals(patInf.get("SEX")) && patInf.get("SEX")!= null) {
				getText_OldPatSex().setText(patInf.get("SEX").split("<N>")[0]);
				getText_NewPatSex().setText(patInf.get("SEX").split("<N>")[1]);
			}
			if(!"".equals(patInf.get("DOCID")) && patInf.get("DOCID")!= null) {
				getText_OldPatDocID().setText(patInf.get("DOCID").split("<N>")[0]);
				getText_NewPatDocID().setText(patInf.get("DOCID").split("<N>").length > 1? patInf.get("DOCID").split("<N>")[1]:"");
			}
			if(!"".equals(patInf.get("DOCTYPE")) && patInf.get("DOCTYPE")!= null) {
				getText_OldPatDocType().setText(patInf.get("DOCTYPE").split("<N>")[0]);
				getText_NewPatDocType().setText(patInf.get("DOCTYPE").split("<N>").length > 1? patInf.get("DOCTYPE").split("<N>")[1]:"");
			}			
			if(!"".equals(patInf.get("DOCA1ID")) && patInf.get("DOCA1ID")!= null) {
				getText_OldPatDocA1ID().setText(patInf.get("DOCA1ID").split("<N>")[0]);
				getText_NewPatDocA1ID().setText(patInf.get("DOCA1ID").split("<N>").length > 1? patInf.get("DOCA1ID").split("<N>")[1]:"");
			}
			if(!"".equals(patInf.get("DOCA1TYPE")) && patInf.get("DOCA1TYPE")!= null) {
				getText_OldPatDocA1Type().setText(patInf.get("DOCA1TYPE").split("<N>")[0]);
				getText_NewPatDocA1Type().setText(patInf.get("DOCA1TYPE").split("<N>").length > 1? patInf.get("DOCA1TYPE").split("<N>")[1]:"");
			}
			if(!"".equals(patInf.get("DOCA2ID")) && patInf.get("DOCA2ID")!= null) {
				getText_OldPatDocA2ID().setText(patInf.get("DOCA2ID").split("<N>")[0]);
				getText_NewPatDocA2ID().setText(patInf.get("DOCA2ID").split("<N>").length > 1? patInf.get("DOCA2ID").split("<N>")[1]:"");
			}
			if(!"".equals(patInf.get("DOCA2TYPE")) && patInf.get("DOCA2TYPE")!= null) {
				getText_OldPatDocA2Type().setText(patInf.get("DOCA2TYPE").split("<N>")[0]);
				getText_NewPatDocA2Type().setText(patInf.get("DOCA2TYPE").split("<N>").length > 1? patInf.get("DOCA2TYPE").split("<N>")[1]:"");
			}
		}
/*		if (TWAH_VALUE.equals(getUserInfo().getSiteCode())) {
			getLbl_PatDocID().setVisible(false);
			getLbl_PatDocType().setVisible(false);
			getText_OldPatDocID().setVisible(false);
			getText_NewPatDocID().setVisible(false);
			getText_OldPatDocType().setVisible(false);
			getText_NewPatDocType().setVisible(false);
			
			//additional document
			getLbl_PatDocA1ID().setVisible(false);
			getLbl_PatDocA1Type().setVisible(false);
			getText_OldPatDocA1ID().setVisible(false);
			getText_NewPatDocA1ID().setVisible(false);
			getText_OldPatDocA1Type().setVisible(false);
			getText_NewPatDocA1Type().setVisible(false);
			
			getLbl_PatDocA2ID().setVisible(false);
			getLbl_PatDocA2Type().setVisible(false);
			getText_OldPatDocA2ID().setVisible(false);
			getText_NewPatDocA2ID().setVisible(false);
			getText_OldPatDocA2Type().setVisible(false);
			getText_NewPatDocA2Type().setVisible(false);
		}*/
		getJTextUser1().setText(getUserInfo().getSsoUserID());
		getJTextUser1().setEditable(false);
		
		setVisible(true);
	}

	public void secCheck() {
		final String usr1 = getJTextUser1().getText().trim();
		final String usr2 = getJTextUser2().getText().trim();
		final String pwd1 = new String(getTextPassword().getPassword());
		final String pwd2 = new String(getTextPassword1().getPassword());

		if (usr1.toUpperCase().equals(usr2.toUpperCase())) {
			Factory.getInstance().addErrorMessage("The Verify User ID should be different from the Update User ID.");
			getJTextUser2().resetText();
			getTextPassword1().resetText();
			getJTextUser2().requestFocus();
			return;
		}

		if (!(usr2.length() > 0  && pwd2.length() > 0)) {
			Factory.getInstance().addErrorMessage("User ID or Password should not be blank.");
			return;
		}

//		QueryUtil.executeTx(getUserInfo(), "ACT_LOGON_SECHKUPPAT",
//				new String[] { usr1, PasswordUtil.cisEncryption(pwd1),"",getUserInfo().getSsoModuleCode() },
//				new MessageQueueCallBack() {
//			@Override
//			public void onPostSuccess(MessageQueue mQueue) {
//				if (mQueue.success()) {
					QueryUtil.executeTx(getUserInfo(), "ACT_LOGON_SECHKUPPAT",
							new String[] { usr2,PasswordUtil.cisEncryption(pwd2),"counterSign2",getUserInfo().getSsoModuleCode()},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								if ("counterSign2".equals(mQueue.getContentField()[0])) {
									Factory.getInstance().addErrorMessage("The Verify User is not authorized counter Sign User");
									getJTextUser2().resetText();
									getTextPassword1().resetText();
								} else {
									QueryUtil.executeMasterAction(
											Factory.getInstance().getUserInfo(),
											"UPATEPATLOG", QueryUtil.ACTION_APPEND,
											new String[] {
													patNo,
													getText_OldPatFName().getText(),
													getText_NewPatFName().getText(),
													getText_OldPatGName().getText(),
													getText_NewPatGName().getText(),
													getText_OldPatCName().getText(),
													getText_NewPatCName().getText(),
													getText_OldPatDOB().getText(),
													getText_NewPatDOB().getText(),
													getText_OldPatSex().getText(),
													getText_NewPatSex().getText(),
													getText_OldPatDocType().getText(),
													getText_NewPatDocType().getText(),
													getText_OldPatDocID().getText(),
													getText_NewPatDocID().getText(),
													getText_OldPatDocA1Type().getText(),
													getText_NewPatDocA1Type().getText(),
													getText_OldPatDocA1ID().getText(),
													getText_NewPatDocA1ID().getText(),
													getText_OldPatDocA2Type().getText(),
													getText_NewPatDocA2Type().getText(),
													getText_OldPatDocA2ID().getText(),
													getText_NewPatDocA2ID().getText(),
													usr1,usr2
												},
											new MessageQueueCallBack() {
												@Override
												public void onPostSuccess(MessageQueue mQueue) {
													if (mQueue.success()) {
														Factory.getInstance().addInformationMessage("Patient Information Update Counter Sign Success!");
														post(true);
														dispose();
													}
												}
											});
								}

							} else {
								Factory.getInstance().addErrorMessage("The Verify User ID or password do not match.");
								getJTextUser2().resetText();
								getTextPassword1().resetText();
							}
						}
					});
//				} else {
//					Factory.getInstance().addSystemMessage("The first User ID or password do not match.");
//					getJTextUser1().resetText();
//					getTextPassword().resetText();
//				}
//			}
//		});
	}
	
	public abstract void post(boolean result);

	
	private BasePanel getPatPanel() {
		if (patPanel == null) {
			patPanel = new BasePanel();
			patPanel.setBorders(true);
			patPanel.add(getLbl_From(),null);
			patPanel.add(getLbl_To(),null);
			patPanel.add(getLbl_PatFName(),null);
			patPanel.add(getlbl_PatFNameFrom(),null);
			patPanel.add(getText_OldPatFName(),null);
			patPanel.add(getLbl_PatFNameTo(),null);
			patPanel.add(getText_NewPatFName(),null);
			patPanel.add(getLbl_PatGName(),null);
			patPanel.add(getlbl_PatGNameFrom(),null);
			patPanel.add(getText_OldPatGName(),null);
			patPanel.add(getLbl_PatGNameTo(),null);
			patPanel.add(getText_NewPatGName(),null);
			patPanel.add(getLbl_PatCName(),null);
			patPanel.add(getText_OldPatCName(),null);
			patPanel.add(getText_NewPatCName(),null);
			patPanel.add(getLbl_PatDOB(),null);
			patPanel.add(getText_OldPatDOB(),null);
			patPanel.add(getText_NewPatDOB(),null);
			patPanel.add(getLbl_PatSex(),null);
			patPanel.add(getText_OldPatSex(),null);
			patPanel.add(getText_NewPatSex(),null);
			patPanel.add(getLbl_PatDocID(),null);
			patPanel.add(getText_OldPatDocID(),null);
			patPanel.add(getText_NewPatDocID(),null);
			patPanel.add(getLbl_PatDocType(),null);
			patPanel.add(getText_OldPatDocType(),null);
			patPanel.add(getText_NewPatDocType(),null);
			patPanel.add(getLbl_PatDocA1ID(),null);
			patPanel.add(getText_OldPatDocA1ID(),null);
			patPanel.add(getText_NewPatDocA1ID(),null);
			patPanel.add(getLbl_PatDocA1Type(),null);
			patPanel.add(getText_OldPatDocA1Type(),null);
			patPanel.add(getText_NewPatDocA1Type(),null);
			patPanel.add(getLbl_PatDocA2ID(),null);
			patPanel.add(getText_OldPatDocA2ID(),null);
			patPanel.add(getText_NewPatDocA2ID(),null);
			patPanel.add(getLbl_PatDocA2Type(),null);
			patPanel.add(getText_OldPatDocA2Type(),null);
			patPanel.add(getText_NewPatDocA2Type(),null);
			patPanel.setBounds(0,5,450, 400);
		}
		return patPanel;
	}

	private BasePanel getJPanel() {
		if (jPanel == null) {
			

			jLabel = new LabelBase();
			jLabel.setBounds(12, 18, 80, 18);
			jLabel.setText("Update Staff");
			
			jLabel2 = new LabelBase();
			jLabel2.setText("Password");
			jLabel2.setBounds(200, 18,63,18);
			
			jLabel1 = new LabelBase();
			jLabel1.setText("Verify Staff");
			jLabel1.setBounds(12, 45,70,18);
			
			jLabel3 = new LabelBase();
			jLabel3.setBounds(200, 45, 63, 18);
			jLabel3.setText("Password");
			
			jPanel = new BasePanel();
			jPanel.setLayout(null);
			jPanel.setBounds(0,10,450, 80);
			
			jPanel.add(jLabel, null);
			jPanel.add(getJTextUser1(), null);
			//jPanel.add(getTextPassword(), null);
			//jPanel.add(jLabel2, null);
			
			jPanel.add(jLabel1, null);
			jPanel.add(jLabel3, null);
			jPanel.add(getJTextUser2(), null);
			jPanel.add(getTextPassword1(), null);
			jPanel.setEtchedBorder();
		}
		return jPanel;
	}
	
	@Override
	protected void doOkAction() {
		secCheck();
	}

	@Override
	protected void doCancelAction() {
		dispose();
	}
	
	@Override
	public Component getDefaultFocusComponent() {
		return getJTextUser2();
	}
	
	protected LabelBase getLbl_PatFName() {
		if (lbl_PatFName == null) {
			lbl_PatFName = new LabelBase();
			lbl_PatFName.setStyleAttribute("color", "blue");
			lbl_PatFName.setText("Family Name:");
			lbl_PatFName.setBounds(5, 5, 100, 20);
		}
		return lbl_PatFName;
	}
	
	protected LabelBase getlbl_PatFNameFrom() {
		if (lbl_PatFNameFrom == null) {
			lbl_PatFNameFrom = new LabelBase();
			lbl_PatFNameFrom.setStyleAttribute("font-weight", "bold");
			lbl_PatFNameFrom.setStyleAttribute("text-align","center");
			lbl_PatFNameFrom.setText("From");
			lbl_PatFNameFrom.setBounds(50, 20, 50, 20);
		}
		return lbl_PatFNameFrom;
	}
	
	private TextReadOnly getText_OldPatFName() {
		if (Text_OldPatFName == null) {
			Text_OldPatFName = new TextReadOnly();
			Text_OldPatFName.addInputStyleName("pat-info-from");
			Text_OldPatFName.setBounds(110, 20, 315, 20);
		}
		return Text_OldPatFName;
	}
	
	protected LabelBase getLbl_PatFNameTo() {
		if ( lbl_PatFNameTo == null) {
			lbl_PatFNameTo = new LabelBase();                          
			lbl_PatFNameTo.setStyleAttribute("font-weight", "bold");   
			lbl_PatFNameTo.setStyleAttribute("text-align","center");   
			lbl_PatFNameTo.setText("To");                              
			lbl_PatFNameTo.setBounds(50, 47, 50, 20);                 
		}
		return lbl_PatFNameTo;
	}
	
	private TextReadOnly getText_NewPatFName() {
		if (Text_NewPatFName == null) {
			Text_NewPatFName = new TextReadOnly();
			Text_NewPatFName.addInputStyleName("pat-info-to");
			Text_NewPatFName.setBounds(110, 47, 315, 20);
		}
		return Text_NewPatFName;
	}
	
	protected LabelBase getLbl_PatGName() {
		if (lbl_PatGName == null) {
			lbl_PatGName = new LabelBase();
			lbl_PatGName.setStyleAttribute("color", "blue");
			lbl_PatGName.setText("Given Name:");
			lbl_PatGName.setBounds(5, 80, 100, 20);
		}
		return lbl_PatGName;
	}
	
	protected LabelBase getlbl_PatGNameFrom() {
		if (lbl_PatGNameFrom == null) {
			lbl_PatGNameFrom = new LabelBase();
			lbl_PatGNameFrom.setStyleAttribute("font-weight", "bold");
			lbl_PatGNameFrom.setStyleAttribute("text-align","center");
			lbl_PatGNameFrom.setText("From");
			lbl_PatGNameFrom.setBounds(50, 100, 50, 20);
		}
		return lbl_PatGNameFrom;
	}
	
	private TextReadOnly getText_OldPatGName() {
		if (Text_OldPatGName == null) {
			Text_OldPatGName = new TextReadOnly();
			Text_OldPatGName.addInputStyleName("pat-info-from");
			Text_OldPatGName.setReadOnly(true);
			Text_OldPatGName.setBounds(110, 100, 315, 20);
		}
		return Text_OldPatGName;
	}
	
	protected LabelBase getLbl_PatGNameTo() {
		if ( lbl_PatGNameTo == null) {
			lbl_PatGNameTo = new LabelBase();                          
			lbl_PatGNameTo.setStyleAttribute("font-weight", "bold");   
			lbl_PatGNameTo.setStyleAttribute("text-align","center");   
			lbl_PatGNameTo.setText("To");                              
			lbl_PatGNameTo.setBounds(50, 125, 50, 20);                 
		}
		return lbl_PatGNameTo;
	}
	
	private TextReadOnly getText_NewPatGName() {
		if (Text_NewPatGName == null) {
			Text_NewPatGName = new TextReadOnly();
			Text_NewPatGName.addInputStyleName("pat-info-to");
			Text_NewPatGName.setReadOnly(true);
			Text_NewPatGName.setBounds(110, 125, 315, 20);
		}
		return Text_NewPatGName;
	}
	
	protected LabelBase getLbl_From() {
		if (lbl_From == null) {
			lbl_From = new LabelBase();
			lbl_From.setStyleAttribute("font-weight", "bold");
			lbl_From.setStyleAttribute("text-align","center");
			lbl_From.setText("From");
			lbl_From.setBounds(110, 150, 150, 20);
		}
		return lbl_From;
	}
	
	protected LabelBase getLbl_To() {
		if (lbl_To == null) {
			lbl_To = new LabelBase();
			lbl_To.setStyleAttribute("font-weight", "bold");
			lbl_To.setStyleAttribute("text-align","center");
			lbl_To.setText("To");
			lbl_To.setBounds(275, 150, 150, 20);
		}
		return lbl_To;
	}
	
	protected LabelBase getLbl_PatCName() {
		if (lbl_PatCName == null) {
			lbl_PatCName = new LabelBase();
			lbl_PatCName.setStyleAttribute("color", "blue");
			lbl_PatCName.setText("Chinese Name:");
			lbl_PatCName.setBounds(5, 175, 100, 20);
		}
		return lbl_PatCName;
	}
	
	private TextReadOnly getText_OldPatCName() {
		if (Text_OldPatCName == null) {
			Text_OldPatCName = new TextReadOnly();
			Text_OldPatCName.addInputStyleName("pat-info-from");
			Text_OldPatCName.setBounds(110, 175, 150, 20);
		}
		return Text_OldPatCName;
	}
	
	private TextReadOnly getText_NewPatCName() {
		if (Text_NewPatCName == null) {
			Text_NewPatCName = new TextReadOnly();
			Text_NewPatCName.addInputStyleName("pat-info-to");
			Text_NewPatCName.setBounds(275, 175, 150, 20);
		}
		return Text_NewPatCName;
	}
	
	protected LabelBase getLbl_PatDOB() {
		if (lbl_PatDOB == null) {
			lbl_PatDOB = new LabelBase();
			lbl_PatDOB.setStyleAttribute("color", "blue");
			lbl_PatDOB.setText("DOB:");
			lbl_PatDOB.setBounds(5, 200, 100, 20);
		}
		return lbl_PatDOB;
	}
	
	private TextReadOnly getText_OldPatDOB() {
		if (Text_OldPatDOB == null) {
			Text_OldPatDOB = new TextReadOnly();
			Text_OldPatDOB.setInputStyleAttribute("text-align","center");
			Text_OldPatDOB.setBounds(110, 200, 150, 20);
		}
		return Text_OldPatDOB;
	}
	
	private TextReadOnly getText_NewPatDOB() {
		if (Text_NewPatDOB == null) {
			Text_NewPatDOB = new TextReadOnly();
			Text_NewPatDOB.addInputStyleName("pat-info-to");
			Text_NewPatDOB.setBounds(275, 200, 150, 20);
		}
		return Text_NewPatDOB;
	}
	
	protected LabelBase getLbl_PatSex() {
		if (lbl_PatSex == null) {
			lbl_PatSex = new LabelBase();
			lbl_PatSex.setStyleAttribute("color", "blue");
			lbl_PatSex.setText("Sex:");
			lbl_PatSex.setBounds(5, 225, 100, 20);
		}
		return lbl_PatSex;
	}
	
	private TextReadOnly getText_OldPatSex() {
		if (Text_OldPatSex == null) {
			Text_OldPatSex = new TextReadOnly();
			Text_OldPatSex.setInputStyleAttribute("text-align","center");
			Text_OldPatSex.setBounds(110, 225, 150, 20);
		}
		return Text_OldPatSex;
	}
	
	private TextReadOnly getText_NewPatSex() {
		if (Text_NewPatSex == null) {
			Text_NewPatSex = new TextReadOnly();
			Text_NewPatSex.addInputStyleName("pat-info-to");
			Text_NewPatSex.setBounds(275, 225, 150, 20);
		}
		return Text_NewPatSex;
	}
	
	protected LabelBase getLbl_PatDocID() {
		if (lbl_PatDocID == null) {
			lbl_PatDocID = new LabelBase();
			lbl_PatDocID.setStyleAttribute("color", "blue");
			lbl_PatDocID.setText("ID/Passport No.:");
			lbl_PatDocID.setBounds(5, 250, 100, 20);
		}
		return lbl_PatDocID;
	}
	
	private TextReadOnly getText_OldPatDocID() {
		if (Text_OldPatDocID == null) {
			Text_OldPatDocID = new TextReadOnly();
			Text_OldPatDocID.addInputStyleName("pat-info-from");
			Text_OldPatDocID.setBounds(110, 250, 150, 20);
		}
		return Text_OldPatDocID;
	}
	
	private TextReadOnly getText_NewPatDocID() {
		if (Text_NewPatDocID == null) {
			Text_NewPatDocID = new TextReadOnly();
			Text_NewPatDocID.addInputStyleName("pat-info-to");
			Text_NewPatDocID.setBounds(275, 250, 150, 20);
		}
		return Text_NewPatDocID;
	}
	
	protected LabelBase getLbl_PatDocType() {
		if (lbl_PatDocType == null) {
			lbl_PatDocType = new LabelBase();
			lbl_PatDocType.setStyleAttribute("color", "blue");
			lbl_PatDocType.setText("Document Type:");
			lbl_PatDocType.setBounds(5, 275, 100, 20);
		}
		return lbl_PatDocType;
	}
	
	private ComboBoxBase getText_OldPatDocType() {
		if (Text_OldPatDocType == null) {
			Text_OldPatDocType = new ComboBoxBase("PATDOCTYPE", false, false, true);
			Text_OldPatDocType.setBounds(110, 275, 150, 20);
			Text_OldPatDocType.addInputStyleName("pat-info-from");
			Text_OldPatDocType.setHideTrigger(true);
			Text_OldPatDocType.setEditableForever(false);
		}
		return Text_OldPatDocType;
	}
	
	private ComboBoxBase getText_NewPatDocType() {
		if (Text_NewPatDocType == null) {
			Text_NewPatDocType = new ComboBoxBase("PATDOCTYPE", false, false, true);
			Text_NewPatDocType.setBounds(275, 275, 150, 20);
			Text_NewPatDocType.addInputStyleName("pat-info-to");
			Text_NewPatDocType.setHideTrigger(true);
			Text_NewPatDocType.setEditableForever(false);
		}
		return Text_NewPatDocType;
	}
	
	//additional Document
	
	protected LabelBase getLbl_PatDocA1ID() {
		if (lbl_PatDocA1ID == null) {
			lbl_PatDocA1ID = new LabelBase();
			lbl_PatDocA1ID.setStyleAttribute("color", "blue");
			lbl_PatDocA1ID.setText("Add. Doc No(1):");
			lbl_PatDocA1ID.setBounds(5, 300, 100, 20);
		}
		return lbl_PatDocA1ID;
	}
	
	private TextReadOnly getText_OldPatDocA1ID() {
		if (Text_OldPatDocA1ID == null) {
			Text_OldPatDocA1ID = new TextReadOnly();
			Text_OldPatDocA1ID.addInputStyleName("pat-info-from");
			Text_OldPatDocA1ID.setBounds(110, 300, 150, 20);
		}
		return Text_OldPatDocA1ID;
	}
	
	private TextReadOnly getText_NewPatDocA1ID() {
		if (Text_NewPatDocA1ID == null) {
			Text_NewPatDocA1ID = new TextReadOnly();
			Text_NewPatDocA1ID.addInputStyleName("pat-info-to");
			Text_NewPatDocA1ID.setBounds(275, 300, 150, 20);
		}
		return Text_NewPatDocA1ID;
	}
	
	protected LabelBase getLbl_PatDocA1Type() {
		if (lbl_PatDocA1Type == null) {
			lbl_PatDocA1Type = new LabelBase();
			lbl_PatDocA1Type.setStyleAttribute("color", "blue");
			lbl_PatDocA1Type.setText("Add.Doc(1) Type:");
			lbl_PatDocA1Type.setBounds(5, 325, 100, 20);
		}
		return lbl_PatDocA1Type;
	}
	
	private ComboBoxBase getText_OldPatDocA1Type() {
		if (Text_OldPatDocA1Type == null) {
			Text_OldPatDocA1Type = new ComboBoxBase("PATDOCTYPE", false, false, true);
			Text_OldPatDocA1Type.setBounds(110, 325, 150, 20);
			Text_OldPatDocA1Type.addInputStyleName("pat-info-from");
			Text_OldPatDocA1Type.setHideTrigger(true);
			Text_OldPatDocA1Type.setEditableForever(false);
		}
		return Text_OldPatDocA1Type;
	}
	
	private ComboBoxBase getText_NewPatDocA1Type() {
		if (Text_NewPatDocA1Type == null) {
			Text_NewPatDocA1Type = new ComboBoxBase("PATDOCTYPE", false, false, true);
			Text_NewPatDocA1Type.setBounds(275, 325, 150, 20);
			Text_NewPatDocA1Type.addInputStyleName("pat-info-to");
			Text_NewPatDocA1Type.setHideTrigger(true);
			Text_NewPatDocA1Type.setEditableForever(false);
		}
		return Text_NewPatDocA1Type;
	}
	
	protected LabelBase getLbl_PatDocA2ID() {
		if (lbl_PatDocA2ID == null) {
			lbl_PatDocA2ID = new LabelBase();
			lbl_PatDocA2ID.setStyleAttribute("color", "blue");
			lbl_PatDocA2ID.setText("Add. Doc No(2):");
			lbl_PatDocA2ID.setBounds(5, 350, 100, 20);
		}
		return lbl_PatDocA2ID;
	}
	
	private TextReadOnly getText_OldPatDocA2ID() {
		if (Text_OldPatDocA2ID == null) {
			Text_OldPatDocA2ID = new TextReadOnly();
			Text_OldPatDocA2ID.addInputStyleName("pat-info-from");
			Text_OldPatDocA2ID.setBounds(110, 350, 150, 20);
		}
		return Text_OldPatDocA2ID;
	}
	
	private TextReadOnly getText_NewPatDocA2ID() {
		if (Text_NewPatDocA2ID == null) {
			Text_NewPatDocA2ID = new TextReadOnly();
			Text_NewPatDocA2ID.addInputStyleName("pat-info-to");
			Text_NewPatDocA2ID.setBounds(275, 350, 150, 20);
		}
		return Text_NewPatDocA2ID;
	}
	
	protected LabelBase getLbl_PatDocA2Type() {
		if (lbl_PatDocA2Type == null) {
			lbl_PatDocA2Type = new LabelBase();
			lbl_PatDocA2Type.setStyleAttribute("color", "blue");
			lbl_PatDocA2Type.setText("Add.Doc(2) Type:");
			lbl_PatDocA2Type.setBounds(5, 375, 100, 20);
		}
		return lbl_PatDocA2Type;
	}
	
	private ComboBoxBase getText_OldPatDocA2Type() {
		if (Text_OldPatDocA2Type == null) {
			Text_OldPatDocA2Type = new ComboBoxBase("PATDOCTYPE", false, false, true);
			Text_OldPatDocA2Type.setBounds(110, 375, 150, 20);
			Text_OldPatDocA2Type.addInputStyleName("pat-info-from");
			Text_OldPatDocA2Type.setHideTrigger(true);
			Text_OldPatDocA2Type.setEditableForever(false);
		}
		return Text_OldPatDocA2Type;
	}
	
	private ComboBoxBase getText_NewPatDocA2Type() {
		if (Text_NewPatDocA2Type == null) {
			Text_NewPatDocA2Type = new ComboBoxBase("PATDOCTYPE", false, false, true);
			Text_NewPatDocA2Type.setBounds(275, 375, 150, 20);
			Text_NewPatDocA2Type.addInputStyleName("pat-info-to");
			Text_NewPatDocA2Type.setHideTrigger(true);
			Text_NewPatDocA2Type.setEditableForever(false);
		}
		return Text_NewPatDocA2Type;
	}
		
	private TextReadOnly getJTextUser1() {
		if (jTextField == null) {
			jTextField = new TextReadOnly() {
				public void onEnter() {
					secCheck();
				}
			};
			jTextField.setBounds(90, 18, 150, 22);
		}
		return jTextField;
	}

	private TextUserID getJTextUser2() {
		if (jTextField1 == null) {
			jTextField1 = new TextUserID() {
				public void onEnter() {
					secCheck();
				}
			};
			jTextField1.setBounds(90, 45, 100, 22);
		}
		return jTextField1;
	}

	private TextPassword getTextPassword() {
		if (jPasswordField == null) {
			jPasswordField = new TextPassword(false) {
				public void onEnter() {
					secCheck();
				}
			};
			jPasswordField.setBounds(274, 18, 100, 22);
		}
		return jPasswordField;
	}

	private TextPassword getTextPassword1() {
		if (jPasswordField1 == null) {
			jPasswordField1 = new TextPassword(false) {
				public void onEnter() {
					secCheck();
				}
			};
			jPasswordField1.setBounds(274,45,100, 22);
		}
		return jPasswordField1;
	}
}