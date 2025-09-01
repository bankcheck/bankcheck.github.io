/*
 * Created on July 23, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.tx.admin.security;

import com.extjs.gxt.ui.client.widget.layout.ColumnData;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboSiteType;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextDesc;
import com.hkah.client.layout.textfield.TextName;
import com.hkah.client.layout.textfield.TextPassword;
import com.hkah.client.tx.MaintenancePanel;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class User extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.USER_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.USER_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"User ID",			//USRID
				"User Password",	//USRPWD
				"User Name",		//USRNAME
				"Status",			//USRSTS
				"Inpatient",		//USRINP
				"Outpatient",		//USROUT
				"Day Case",			//USRDAY
				"PBO User",			//USRPBO
				"Dept. Code",		//DPTCODE
				"isusing",			//ISUSING
				"User Site"			//STECODE
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				80,		//USRID
				0,		//USRPWD
				100,	//USRNAME
				60,		//USRSTS
				80,		//USRINP
				80,		//USROUT
				80,		//USRDAY
				80,		//USRPBO
				80,		//DPTCODE
				0,		//ISUSING
				80		//STECODE
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;
	private LabelBase LeftJLabel_UserID = null;
	private TextName LeftJText_UserID = null;
	private LabelBase LeftJLabel_UserName = null;
	private TextDesc LeftJText_UserName = null;

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private ColumnLayout generalPanel = null;
	private FieldSetBase rightPanel = null;
	private LabelBase RightJLabel_UserID = null;
	private TextName RightJText_UserID = null;
	private LabelBase RightJLabel_UserName = null;
	private TextDesc RightJText_UserName = null;

	private LabelBase RightJLabel_Department = null;
	private TextName RightJText_Department = null;

	private CheckBoxBase RightCheckBox_Active = null;
	private LabelBase RightJLabel_Active = null;

	private LabelBase RightJLabel_Site = null;
	private ComboSiteType RightJCombo_Site = null;
	private LabelBase RightJLabel_Password = null;
	private TextPassword RightJpassword_Password = null;
	private LabelBase RightJLabel_ConfirmPassword = null;
	private TextPassword RightJPassword_ConfirmPassword = null;

	private CheckBoxBase RightCheckBox_Inpatient = null;
	private LabelBase RightJLabel_Inpatient = null;
	private CheckBoxBase RightCheckBox_Outpatient = null;
	private LabelBase RightJLabel_Outpatient = null;
	private CheckBoxBase RightCheckBox_DayCase = null;
	private LabelBase RightJLabel_DayCase = null;
	private CheckBoxBase RightCheckBox_PBOUser = null;
	private LabelBase RightJLabel_PBOUser = null;
	private CheckBoxBase RightCheckBox_Online = null;
	private LabelBase RightJLabel_Online = null;
	private ColumnLayout RightPanel_CheckList = null;

	/**
	 * This method initializes
	 *
	 */
	public User() {
		super();
		getListTable().setHeight(180);
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		/* >>> ~7.1~ Init action (e.g. Listing, Init Comobbox ========= <<< */
		//setFullEntry(true);
		setNoGetDB(true);

		/* >>> ~7.2~ Disable Add/Modify/Delete Buttons ================ <<< */
		//setAppendButtonEnabled(false);
		//setModifyButtonEnabled(false);
		//setDeleteButtonEnabled(false);

		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		//performList();
		getSaveButton().setEnabled(false);
		getListTable().setColumnClass(3, new CheckBoxBase(), false);
		getListTable().setColumnClass(4, new CheckBoxBase(), false);
		getListTable().setColumnClass(5, new CheckBoxBase(), false);
		getListTable().setColumnClass(6, new CheckBoxBase(), false);
		getListTable().setColumnClass(7, new CheckBoxBase(), false);
		getListTable().setColumnClass(9, new CheckBoxBase(), false);
		getListTable().setColumnClass(10, new ComboSiteType(), false);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return getLeftJText_UserID();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {
		// override function if necessary
	}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {
		// enable/disable field
		getListTable().setEnabled(false);
		getRightCheckBox_Active().setSelected(false);
		getRightJText_Department().resetText();
		getRightJpassword_Password().resetText();
		getRightJPassword_ConfirmPassword().resetText();
		getRightCheckBox_Inpatient().setSelected(false);
		getRightCheckBox_Outpatient().setSelected(false);
		getRightCheckBox_DayCase().setSelected(false);
		getRightCheckBox_PBOUser().setSelected(false);
		getRightCheckBox_Online().setSelected(false);
	}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
		// enable/disable field
		getRightJText_UserID().setEditable(false);
		getRightJText_UserName().setEnabled(true);
		getRightJText_UserName().requestFocus();
	}

	/* >>> ~13~ Set Disable Fields When Delete ButtonBase Is Clicked ====== <<< */
	@Override
	protected void deleteDisabledFields() {
		// enable/disable field
	}

	/* >>> ~14~ Set Browse Validation ===================================== <<< */
	@Override
	protected boolean browseValidation() {
		/*if (getRightJText_UserID().getText()==null || getRightJText_UserID().getText().trim().length()==0) {
			return false;
		}*/
		return true;
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
				getLeftJText_UserID().getText(),
				getLeftJText_UserName().getText()
		};
	}

	/* >>> ~16~ Set Fetch Input Parameters ================================ <<< */
	@Override
	protected String[] getFetchInputParameters() {
		String[] selectedContent = getListSelectedRow();
		return new String[] {selectedContent[0]};
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {
		int index = 0;
		getRightJText_UserID().setText(outParam[index++]);                  //USRID
		getRightJpassword_Password().setText(outParam[index]);				//USRPWD
		getRightJPassword_ConfirmPassword().setText(outParam[index++]);
		getRightJText_UserName().setText(outParam[index++]);               	//USRNAME
		getRightCheckBox_Active().setText(outParam[index++]);				//USRSTS
		getRightCheckBox_Inpatient().setText(outParam[index++]);			//USRINP
		getRightCheckBox_Outpatient().setText(outParam[index++]);			//USROUT
		getRightCheckBox_DayCase().setText(outParam[index++]);				//USRDAY
		getRightCheckBox_PBOUser().setText(outParam[index++]);				//USRPBO
		getRightJText_Department().setText(outParam[index++]);				//DPTCODE
		getRightJCombo_Site().setText(outParam[index++]);					//STECODE
		getRightCheckBox_Online().setText(outParam[index++]);				//ISUSING
	}

	/* >>> ~21~ Set Add New Row toclearPostAction table ============================== <<< */
	@Override
	protected void clearTableFields() {
		super.clearTableFields();
		setCurrentTable(3, "N");
		setCurrentTable(4, "N");
		setCurrentTable(5, "N");
		setCurrentTable(6, "N");
		setCurrentTable(7, "N");
		setCurrentTable(9, "N");
	}

	/* >>> ~22~ Set Action Input Parameters per table ===================== <<< */
	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		// TODO Auto-generated method stub
		return new String[] {
				selectedContent[0],
				selectedContent[1],
				selectedContent[2],
				"Y".equals(selectedContent[3])?"-1":"0",
				"Y".equals(selectedContent[4])?"-1":"0",
				"Y".equals(selectedContent[5])?"-1":"0",
				"Y".equals(selectedContent[6])?"-1":"0",
				"Y".equals(selectedContent[7])?"-1":"0",
				selectedContent[8],
				"Y".equals(selectedContent[9])?"-1":"0",
				selectedContent[10]
		};
	}

	/* >>> ~23~ Set Action Validation per table =========================== <<< */
	@Override
	protected boolean actionValidation(String[] selectedContent) {
		/*String passwd=new String(getRightJpassword_Password().getPassword());
		String cpasswd=new String(getRightJPassword_ConfirmPassword().getPassword());
		if (passwd == null || cpasswd == null || !passwd.equals(cpasswd)) {
			Factory.getInstance().addErrorMessage("Empty Password!", getRightJpassword_Password());
			return false;
		} else*/
		if (selectedContent[0]==null|| selectedContent[0].trim().length() == 0) {
			Factory.getInstance().addErrorMessage("Empty User ID!", getRightJText_UserID());
			return false;
		} else if (selectedContent[2].trim().length() == 0 || selectedContent[2]==null) {
			Factory.getInstance().addErrorMessage("Empty User Name!", getRightJText_UserName());
			//getRightJText_UserName().requestFocus();
			return false;
		}
		return true;
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	public void saveAction() {
		getRightJText_Department().onBlur();
		super.saveAction();
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/
	/**
	 * This method initializes leftPanel
	 *
	 * @return com.hkah.client.layout.ColumnLayout
	 */
	protected ColumnLayout getSearchPanel() {
		if (leftPanel == null) {
			leftPanel = new ColumnLayout(4, 1, new int[] {85, 150, 85, 150});
//			leftPanel.setSize(440, 68);
			leftPanel.add(0, 0, getLeftJLabel_UserID());
			leftPanel.add(1, 0, getLeftJText_UserID());
			leftPanel.add(2, 0, getLeftJLabel_UserName());
			leftPanel.add(3, 0, getLeftJText_UserName());
		}
		return leftPanel;
	}

	/**
	 * This method initializes LeftJLabel_UserID
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getLeftJLabel_UserID() {
		if (LeftJLabel_UserID == null) {
			LeftJLabel_UserID = new LabelBase();
			LeftJLabel_UserID.setText("User ID :");
			LeftJLabel_UserID.setOptionalLabel();
		}
		return LeftJLabel_UserID;
	}

	/**
	 * This method initializes LeftJText_UserID
	 *
	 * @return com.hkah.client.layout.textfield.TextUserID
	 */
	private TextName getLeftJText_UserID() {
		if (LeftJText_UserID == null) {
			LeftJText_UserID = new TextName();
		}
		return LeftJText_UserID;
	}

	/**
	 * This method initializes LeftJLabel_UserName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getLeftJLabel_UserName() {
		if (LeftJLabel_UserName == null) {
			LeftJLabel_UserName = new LabelBase();
			LeftJLabel_UserName.setText("User Name :");
			LeftJLabel_UserName.setOptionalLabel();
		}
		return LeftJLabel_UserName;
	}

	/**
	 * This method initializes LeftJText_UserName
	 *
	 * @return com.hkah.client.layout.textfield.TextBase
	 */
	private TextBase getLeftJText_UserName() {
		if (LeftJText_UserName == null) {
			LeftJText_UserName = new TextDesc();
		}
		return LeftJText_UserName;
	}

	/**
	 * This method initializes generalPanel
	 *
	 * @return com.hkah.client.layout.ColumnLayout
	 */
	protected FieldSetBase getActionPanel() {
		if (rightPanel == null) {
			ColumnData columnData1 = new ColumnData(0.8);
			ColumnData columnData2 = new ColumnData(0.2);
			rightPanel = new FieldSetBase();
			rightPanel.setBounds(0, 0, 720, 180);
			rightPanel.setHeading("User Information");
			rightPanel.add(getGeneralPanel(), columnData1);
			rightPanel.add(getRightPanel_CheckList(), columnData2);
		}
		return rightPanel;
	}

	private ColumnLayout getGeneralPanel() {
		if (generalPanel == null) {
			generalPanel = new ColumnLayout(4, 4, new int[] {90, 180, 120, 180});
			generalPanel.setBounds(5, 0, 560, 150);
			generalPanel.add(0, 0, getRightJLabel_UserID());
			generalPanel.add(1, 0, getRightJText_UserID());
			generalPanel.add(2, 0, getRightJLabel_UserName());
			generalPanel.add(3, 0, getRightJText_UserName());
			generalPanel.add(0, 1, getRightJLabel_Active());
			generalPanel.add(1, 1, getRightCheckBox_Active());
			generalPanel.add(2, 1, getRightJLabel_Site());
			generalPanel.add(3, 1, getRightJCombo_Site());
			generalPanel.add(0, 2, getRightJLabel_Department());
			generalPanel.add(1, 2, getRightJText_Department());
			generalPanel.add(0, 3, getRightJLabel_Password());
			generalPanel.add(1, 3, getRightJpassword_Password());
			generalPanel.add(2, 3, getRightJLabel_ConfirmPassword());
			generalPanel.add(3, 3, getRightJPassword_ConfirmPassword());
			generalPanel.setBorders(false);
		}
		return generalPanel;
	}

	/**
	 * This method initializes RightJLabel_UserID
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_UserID() {
		if (RightJLabel_UserID == null) {
			RightJLabel_UserID = new LabelBase();
			RightJLabel_UserID.setText("User ID");
		}
		return RightJLabel_UserID;
	}

	/**
	 * This method initializes RightJText_UserID
	 *
	 * @return com.hkah.client.layout.textfield.TextUserID
	 */
	private TextName getRightJText_UserID() {
		if (RightJText_UserID == null) {
			RightJText_UserID = new TextName(getListTable(), 0);
		}
		return RightJText_UserID;
	}

	/**
	 * This method initializes RightJLabel_UserName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_UserName() {
		if (RightJLabel_UserName == null) {
			RightJLabel_UserName = new LabelBase();
			RightJLabel_UserName.setText("User Name");
		}
		return RightJLabel_UserName;
	}

	/**
	 * This method initializes RightJText_UserName
	 *
	 * @return com.hkah.client.layout.textfield.TextName
	 */
	private TextDesc getRightJText_UserName() {
		if (RightJText_UserName == null) {
			RightJText_UserName = new TextDesc(getListTable(), 2) {
				@Override
				public void onBlur() {
					if (getRightJText_UserName().getText().trim().length()!=0 ||getRightJText_UserName().getText()!=null) {
						getRightJpassword_Password().requestFocus();
					} else {
						getRightJText_UserName().requestFocus();
					}
				}
			};
		}
		return RightJText_UserName;
	}

	/**
	 * This method initializes RightJLabel_Department
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_Department() {
		if (RightJLabel_Department == null) {
			RightJLabel_Department = new LabelBase();
			RightJLabel_Department.setText("Department");
		}
		return RightJLabel_Department;
	}

	/**
	 * This method initializes RightJText_Department
	 *
	 * @return com.hkah.client.layout.textfield.Department
	 */
	private TextName getRightJText_Department() {
		if (RightJText_Department == null) {
			RightJText_Department = new TextName(getListTable(), 8) {
				@Override
				public void onBlur() {
					if (RightJText_Department.getText().trim().length()==0) {
						return;
					}

					QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] {"Dept","DptCode","DptCode='"+RightJText_Department.getText()+"'"},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							// TODO Auto-generated method stub
							if (mQueue.success()) {
								getListTable().setValueAt(RightJText_Department.getText(),
										getListTable().getSelectedRow(),8);
							} else {
								getRightJText_Department().resetText();
								getListTable().setValueAt("",
										getListTable().getSelectedRow(),8);
								getRightJText_Department().requestFocus();
								Factory.getInstance().addErrorMessage("Invalid Department Code.",getRightJText_Department());
							}
						}

						@Override
						public void onFailure(Throwable caught) {
							// TODO Auto-generated method stub
							getRightJText_Department().resetText();
							getListTable().setValueAt("", getListTable().getSelectedRow(), 8);
							getRightJText_Department().requestFocus();
							Factory.getInstance().addErrorMessage("Invalid Department Code.",getRightJText_Department());
							caught.printStackTrace();
						}
					});
				}
			};
		}
		return RightJText_Department;
	}

	/**
	 * This method initializes getRightJLabel_Active
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_Active() {
		if (RightJLabel_Active == null) {
			RightJLabel_Active = new LabelBase();
			RightJLabel_Active.setText("Active");
		}
		return RightJLabel_Active;
	}

	/**
	 * This method initializes RightCheckBox_Active
	 *
	 * @return com.hkah.client.layout.checkbox.CheckBoxBase
	 */
	private CheckBoxBase getRightCheckBox_Active() {
		if (RightCheckBox_Active == null) {
			RightCheckBox_Active = new CheckBoxBase(getListTable(), 3);
		}
		return RightCheckBox_Active;
	}

	/**
	 * This method initializes getRightJLabel_Site
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */

	private LabelBase getRightJLabel_Site() {
		if (RightJLabel_Site == null) {
			RightJLabel_Site = new LabelBase();
			RightJLabel_Site.setText("Site");
		}
		return RightJLabel_Site;
	}

	/**
	 * This method initializes RightJCombo_Site1
	 *
	 * @return com.hkah.client.layout.combobox.ComboSiteType
	 */
	private ComboSiteType getRightJCombo_Site() {
		if (RightJCombo_Site == null) {
			RightJCombo_Site = new ComboSiteType(getListTable(), 10);
		}
		return RightJCombo_Site;
	}

	/**
	 * This method initializes RightJLabel_Password
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_Password() {
		if (RightJLabel_Password == null) {
			RightJLabel_Password = new LabelBase();
			RightJLabel_Password.setText("Password");
		}
		return RightJLabel_Password;
	}

	/**
	 * This method initializes RightJpassword_Password
	 *
	 * @return javax.swing.TextPassword
	 */
	private TextPassword getRightJpassword_Password() {
		if (RightJpassword_Password == null) {
			RightJpassword_Password = new TextPassword(getListTable(), 1) {
				@Override
				public void onBlur() {
					String password=new String(getRightJpassword_Password().getPassword());
					if (password.equals("") || password.trim().length()==0) {
						Factory.getInstance().addErrorMessage("Empty Pssword !");
					}
				}
			};
		}
		return RightJpassword_Password;
	}

	/**
	 * This method initializes RightJLabel_ConfirmPassword
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_ConfirmPassword() {
		if (RightJLabel_ConfirmPassword == null) {
			RightJLabel_ConfirmPassword = new LabelBase();
			RightJLabel_ConfirmPassword.setText("Confirm Password");
		}
		return RightJLabel_ConfirmPassword;
	}

	/**
	 * This method initializes RightJPassword_PasswordConfirm
	 *
	 * @return javax.swing.TextPassword
	 */
	private TextPassword getRightJPassword_ConfirmPassword() {
		if (RightJPassword_ConfirmPassword == null) {
			RightJPassword_ConfirmPassword = new TextPassword() {
				public void onBlur() {
					String pass = new String(RightJpassword_Password.getPassword());
					String Rpass = new String(RightJPassword_ConfirmPassword.getPassword());
					if (!pass.equals(Rpass)) {
						Factory.getInstance().addErrorMessage("Password not match, please retry.");
						getRightJpassword_Password().requestFocus();
						getRightJpassword_Password().resetText();
						getRightJPassword_ConfirmPassword().resetText();
					}
				}
			};
		}
		return RightJPassword_ConfirmPassword;
	}

	/**
	 * This method initializes RightCheckBox_InPatient
	 *
	 * @return com.hkah.client.layout.checkbox.CheckBoxBase
	 */
	private CheckBoxBase getRightCheckBox_Inpatient() {
		if (RightCheckBox_Inpatient == null) {
			RightCheckBox_Inpatient = new CheckBoxBase(getListTable(), 4);
		}
		return RightCheckBox_Inpatient;
	}

	/**
	 * This method initializes getRightJLabel_Outpatient
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */

	private LabelBase getRightJLabel_Outpatient() {
		if (RightJLabel_Outpatient == null) {
			RightJLabel_Outpatient = new LabelBase();
			RightJLabel_Outpatient.setText("Outpatient");
		}
		return RightJLabel_Outpatient;
	}

	/**
	 * This method initializes RightCheckBox_Outpatient
	 *
	 * @return com.hkah.client.layout.checkbox.CheckBoxBase
	 */
	private CheckBoxBase getRightCheckBox_Outpatient() {
		if (RightCheckBox_Outpatient == null) {
			RightCheckBox_Outpatient = new CheckBoxBase(getListTable(), 5);
		}
		return RightCheckBox_Outpatient;
	}

	/**
	 * This method initializes getRightJLabel_DayCase
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_Inpatient() {
		if (RightJLabel_Inpatient == null) {
			RightJLabel_Inpatient = new LabelBase();
			RightJLabel_Inpatient.setText("Inpatient");
		}
		return RightJLabel_Inpatient;
	}

	/**
	 * This method initializes RightCheckBox_DayCase
	 *
	 * @return com.hkah.client.layout.checkbox.CheckBoxBase
	 */
	private CheckBoxBase getRightCheckBox_DayCase() {
		if (RightCheckBox_DayCase == null) {
			RightCheckBox_DayCase = new CheckBoxBase(getListTable(), 6);
		}
		return RightCheckBox_DayCase;
	}

	/**
	 * This method initializes getRightJLabel_DayCase
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_DayCase() {
		if (RightJLabel_DayCase == null) {
			RightJLabel_DayCase = new LabelBase();
			RightJLabel_DayCase.setText("DayCase");
		}
		return RightJLabel_DayCase;
	}

	/**
	 * This method initializes RightCheckBox_PBOUser
	 *
	 * @return com.hkah.client.layout.checkbox.CheckBoxBase
	 */
	private CheckBoxBase getRightCheckBox_PBOUser() {
		if (RightCheckBox_PBOUser == null) {
			RightCheckBox_PBOUser = new CheckBoxBase(getListTable(), 7);

		}
		return RightCheckBox_PBOUser;
	}

	/**
	 * This method initializes getRightJLabel_PBOUser
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_PBOUser() {
		if (RightJLabel_PBOUser == null) {
			RightJLabel_PBOUser = new LabelBase();
			RightJLabel_PBOUser.setText("PBOUser");
		}
		return RightJLabel_PBOUser;
	}

	/**
	 * This method initializes RightCheckBox_Online
	 *
	 * @return com.hkah.client.layout.checkbox.CheckBoxBase
	 */
	private CheckBoxBase getRightCheckBox_Online() {
		if (RightCheckBox_Online == null) {
			RightCheckBox_Online = new CheckBoxBase(getListTable(), 9);
		}
		return RightCheckBox_Online;
	}

	/**
	 * This method initializes getRightJLabel_Online
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_Online() {
		if (RightJLabel_Online == null) {
			RightJLabel_Online = new LabelBase();
			RightJLabel_Online.setText("Online");
		}
		return RightJLabel_Online;
	}

	/**
	 * This method initializes RightPanel_CheckList
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	private ColumnLayout getRightPanel_CheckList() {
		if (RightPanel_CheckList == null) {
			RightPanel_CheckList = new ColumnLayout(2, 5, new int[] {20, 40});
			RightPanel_CheckList.setBounds(570, 0, 140, 150);
			RightPanel_CheckList.add(0, 0, getRightCheckBox_Inpatient());
			RightPanel_CheckList.add(1, 0, getRightJLabel_Inpatient());
			RightPanel_CheckList.add(0, 1, getRightCheckBox_Outpatient());
			RightPanel_CheckList.add(1, 1, getRightJLabel_Outpatient());
			RightPanel_CheckList.add(0, 2, getRightCheckBox_DayCase());
			RightPanel_CheckList.add(1, 2, getRightJLabel_DayCase());
			RightPanel_CheckList.add(0, 3, getRightCheckBox_PBOUser());
			RightPanel_CheckList.add(1, 3, getRightJLabel_PBOUser());
			RightPanel_CheckList.add(0, 4, getRightCheckBox_Online());
			RightPanel_CheckList.add(1, 4, getRightJLabel_Online());
			RightPanel_CheckList.setBorders(false);
		}
		return RightPanel_CheckList;
	}
}