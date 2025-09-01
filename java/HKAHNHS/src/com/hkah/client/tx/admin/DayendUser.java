package com.hkah.client.tx.admin;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.google.gwt.user.client.Timer;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.combobox.ComboSiteType;
import com.hkah.client.layout.dialog.DialogBase;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextPassword;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.util.Crypt;
import com.hkah.client.util.PanelUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;


public class DayendUser extends MasterPanel{

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.DAYENDUSER_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.DAYENDUSER_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {};
	}

	private BasePanel rightPanel = null;
	private BasePanel leftPanel = null;
	private DialogBase DayendUserDialog = null;
	private BasePanel ParaPanel = null;
	private LabelBase SiteCodeDesc = null;
	private ComboSiteType SiteCode = null;
	private LabelBase UserIDDesc = null;
	private TextString UserID = null;
	private LabelBase PasswordDesc = null;
	private TextPassword Password = null;
	private LabelBase CofirmPwdDesc = null;
	private TextPassword CofirmPwd = null;
	private ButtonBase NewUser = null;
	private ButtonBase EditUser = null;
	private ButtonBase Save = null;
	private ButtonBase Cancel = null;
	private ButtonBase Exit = null;

	private String userID = "";
	private String userPwd = "";

	private boolean isDirty = false;
	/**
	 * This method initializes
	 *
	 */
	public DayendUser() {
		super();
	}

	@Override
	public boolean preAction() {
		showDayendUserDialog();
		return false;
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		setRightAlignPanel();
		//setLeftAlignPanel();
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		getAppendButton().setEnabled(false);
		getCancelButton().setEnabled(true);
		getPrintButton().setEnabled(false);
		getRefreshButton().setEnabled(false);
		getCancelButton().setEnabled(false);
		getAcceptButton().setEnabled(false);
		getSearchButton().setEnabled(false);
		getClearButton().setEnabled(false);
		showDayendUserDialog();
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return null;// getSiteCode();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {}

	/* >>> ~13~ Set Disable Fields When Delete ButtonBase Is Clicked ====== <<< */
	@Override
	protected void deleteDisabledFields() {
		// enable/disable field
	}

	/* >>> ~14~ Set Browse Validation ===================================== <<< */
	@Override
	protected boolean browseValidation() {
		return true;
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {

		return new String[] {};
	}

	/* >>> ~16~ Set Fetch Input Parameters ================================ <<< */
	@Override
	protected String[] getFetchInputParameters() {
		String[] selectedContent = getListSelectedRow();
		return new String[] {
				selectedContent[0]
		};
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {}

	/* >>> ~15~ Set Fetch Output Results ============================== <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return new String[] {};
	}

	/* >>> ~16.1~ Set Action Output Parameters =========================== <<< */
	@Override
	protected void getNewOutputValue(String returnValue) {}

	/* >>> getter methods for init the Component start from here================================== <<< */

	private void getUserDetail() {
		PanelUtil.setAllFieldsEditable(getParaPanel(), false);
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] {"DAYEND","*","SITECODE='"+getSiteCode().getText()+"'"},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					userID=mQueue.getContentField()[1];
					userPwd=Crypt.xorString(mQueue.getContentField()[2]);
					getUserID().setText(userID);
					getPassword().setText(userPwd);
					getEditUser().setEnabled(true);
				} else {
					getUserID().resetText();
					getPassword().resetText();
					getNewUser().setEnabled(true);
				}
			}
		});
		getExit().setEnabled(true);
		getCofirmPwd().resetText();
	}

	private void save() {
		String password = String.valueOf(getPassword().getPassword());
		String password2 = String.valueOf(getCofirmPwd().getPassword());
		if ((!password.equals(password2)) ||password2.length()==0 ) {
			Factory.getInstance().addErrorMessage( "Please confirm the password before save!");
			return;
		}
		if (userID.equals(UserID.getText())) {
			setActionType(QueryUtil.ACTION_MODIFY);
		} else {
			setActionType(QueryUtil.ACTION_APPEND);
		}
		QueryUtil.executeMasterAction(getUserInfo(), getTxCode(), getActionType(),
					new String[] {SiteCode.getText(),UserID.getText(),password,Crypt.xorString(password)},
					new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					Factory.getInstance().addErrorMessage("Record Saved.");
					getUserDetail();
					isDirty = false;
				} else {
					Factory.getInstance().addErrorMessage("Please ensure that you have the privilage to add the user. The dayend username should not be the same as the user login name.");
				}
			}
		});
	}

	private void showDayendUserDialog() {
		if (DayendUserDialog == null) {
			DayendUserDialog = new DialogBase(getMainFrame(), null, true);
			DayendUserDialog.setTitle("Dayend User");
//			DayendUserDialog.setLayout(null);
			DayendUserDialog.setBounds(320, 260, 400, 250);
			DayendUserDialog.add(getParaPanel(),null);
		}

		Timer timer = new Timer() {
			@Override
			public void run() {
				getUserDetail();
			}
		};
		timer.schedule(500);

		DayendUserDialog.setResizable(false);
		DayendUserDialog.setVisible(true);
	}

	@Override
	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
		}
		return leftPanel;
	}

	protected BasePanel getRightPanel() {
		if (rightPanel == null) {
			rightPanel = new BasePanel();
		}
		return rightPanel;
	}

	protected BasePanel getParaPanel() {
		if (ParaPanel == null) {
			ParaPanel = new BasePanel();
			ParaPanel.setSize(400, 240);
			ParaPanel.add(getSiteCodeDesc(),null);
			ParaPanel.add(getSiteCode(),null);
			ParaPanel.add(getUserIDDesc(),null);
			ParaPanel.add(getUserID(),null);
			ParaPanel.add(getPasswordDesc(),null);
			ParaPanel.add(getPassword(),null);
			ParaPanel.add(getCofirmPwdDesc(),null);
			ParaPanel.add(getCofirmPwd(),null);
			ParaPanel.add(getNewUser(),null);
			ParaPanel.add(getEditUser(),null);
			ParaPanel.add(getSave(),null);
			ParaPanel.add(getCancel(),null);
			ParaPanel.add(getExit(),null);
		}
		return ParaPanel;
	}

	public LabelBase getSiteCodeDesc() {
		if (SiteCodeDesc == null) {
			SiteCodeDesc = new LabelBase();
//			SiteCodeDesc.setHorizontalAlignment(LabelBase.RIGHT);
			SiteCodeDesc.setText("Site Code:");
			SiteCodeDesc.setBounds(20, 20, 104, 20);
		}
		return SiteCodeDesc;
	}

	public ComboSiteType getSiteCode() {
		if (SiteCode == null) {
			SiteCode = new ComboSiteType();
			SiteCode.setBounds(133, 20, 190, 20);
		}
		return SiteCode;
	}

	public LabelBase getUserIDDesc() {
		if (UserIDDesc == null) {
			UserIDDesc = new LabelBase();
//			UserIDDesc.setHorizontalAlignment(LabelBase.RIGHT);
			UserIDDesc.setText("User ID:");
			UserIDDesc.setBounds(20, 50, 104, 20);
		}
		return UserIDDesc;
	}

	public TextString getUserID() {
		if (UserID == null) {
			UserID = new TextString();
			UserID.setBounds(133, 50, 190, 20);
		}
		return UserID;
	}

	public LabelBase getPasswordDesc() {
		if (PasswordDesc == null) {
			PasswordDesc = new LabelBase();
//			PasswordDesc.setHorizontalAlignment(LabelBase.RIGHT);
			PasswordDesc.setText("Password:");
			PasswordDesc.setBounds(20, 80, 104, 20);
		}
		return PasswordDesc;
	}

	public TextPassword getPassword() {
		if (Password == null) {
			Password = new TextPassword();
			Password.setBounds(133, 80, 190, 20);
		}
		return Password;
	}

	public LabelBase getCofirmPwdDesc() {
		if (CofirmPwdDesc == null) {
			CofirmPwdDesc = new LabelBase();
//			CofirmPwdDesc.setHorizontalAlignment(LabelBase.RIGHT);
			CofirmPwdDesc.setText("Confirm Password:");
			CofirmPwdDesc.setBounds(20, 110, 104, 20);
		}
		return CofirmPwdDesc;
	}

	public TextPassword getCofirmPwd() {
		if (CofirmPwd == null) {
			CofirmPwd = new TextPassword();
			CofirmPwd.setBounds(133, 110, 190, 20);
		}
		return CofirmPwd;
	}

	public ButtonBase getNewUser() {
		if (NewUser == null) {
			NewUser = new ButtonBase() {
				@Override
				public void onClick() {
					getUserDetail();

					getUserID().setEditable(true);
					getUserID().focus();
					getPassword().setEditable(true);
					getCofirmPwd().setEditable(true);

					getSave().setEnabled(true);
					getCancel().setEnabled(true);

					isDirty = true;
				}
			};
			NewUser.setText("New User");
			NewUser.setBounds(56, 148, 84, 25);
		}
		return NewUser;
	}

	public ButtonBase getEditUser() {
		if (EditUser == null) {
			EditUser = new ButtonBase() {
				@Override
				public void onClick() {
					PanelUtil.setAllFieldsEditable(getParaPanel(), true);
					NewUser.setEnabled(false);
					isDirty = true;
				}
			};
			EditUser.setText("Edit User");
			EditUser.setBounds(151, 148, 84, 25);
		}
		return EditUser;
	}

	public ButtonBase getSave() {
		if (Save == null) {
			Save = new ButtonBase() {
				@Override
				public void onClick() {
					save();
				}
			};
			Save.setText("Save");
			Save.setBounds(245, 148, 84, 25);
		}
		return Save;
	}

	public ButtonBase getCancel() {
		if (Cancel == null) {
			Cancel = new ButtonBase() {
				@Override
				public void onClick() {
					getUserDetail();
					isDirty = false;
				}
			};
			Cancel.setText("Cancel");
			Cancel.setBounds(103, 175, 84, 25);
		}
		return Cancel;
	}

	public ButtonBase getExit() {
		if (Exit == null) {
			Exit = new ButtonBase() {
				@Override
				public void onClick() {
					if (isDirty) {
						MessageBoxBase.confirm("Message", "Exit without saving the changes?",
								new Listener<MessageBoxEvent>() {
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									// do action after click yes
//									DayendUserDialog.close();
									DayendUserDialog.hide();
									DayendUserDialog = null;
									PanelUtil.resetAllFields(getParaPanel());
								}
							}
						});
					} else {
//						DayendUserDialog.close();
						DayendUserDialog.hide();
						DayendUserDialog = null;
						PanelUtil.resetAllFields(getParaPanel());
					}
				}
			};
			Exit.setText("Exit");
			Exit.setBounds(198, 175, 84, 25);
		}
		return Exit;
	}
}