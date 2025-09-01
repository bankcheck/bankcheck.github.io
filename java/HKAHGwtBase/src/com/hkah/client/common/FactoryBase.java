/*
 * Created on July 3, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.common;

import java.util.ArrayList;
import java.util.HashMap;

import com.extjs.gxt.ui.client.event.ButtonEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.event.SelectionListener;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.Info;
import com.extjs.gxt.ui.client.widget.MessageBox;
import com.extjs.gxt.ui.client.widget.MessageBox.MessageBoxType;
import com.extjs.gxt.ui.client.widget.Window;
import com.extjs.gxt.ui.client.widget.form.FormPanel;
import com.extjs.gxt.ui.client.widget.form.TextArea;
import com.extjs.gxt.ui.client.widget.form.TextField;
import com.extjs.gxt.ui.client.widget.layout.FitLayout;
import com.extjs.gxt.ui.client.widget.layout.FormData;
import com.google.gwt.core.client.Scheduler;
import com.google.gwt.dom.client.Document;
import com.google.gwt.user.client.DOM;
import com.google.gwt.user.client.ui.RootPanel;
import com.hkah.client.MainFrame;
import com.hkah.client.event.CallbackListener;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.DefaultPanel;
import com.hkah.client.layout.textfield.SearchTriggerField;
import com.hkah.client.layout.textfield.TextAreaBase;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextDateTimeWithoutSecondWithCheckBox;
import com.hkah.client.layout.textfield.TextDateWithCheckBox;
import com.hkah.client.layout.textfield.TextNum;
import com.hkah.client.tx.MasterPanelBase;
import com.hkah.shared.constants.ConstantsErrorMessage;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.ClientConfigObject;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;
import com.hkah.shared.model.UserInfo;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public abstract class FactoryBase implements ConstantsVariable, ConstantsErrorMessage {

	// variable
	private static FactoryBase factory = null;
	private MainFrame mainFrame = null;
	private String clientLogDir = null;
	private boolean isSkipLogin = false;
	private boolean isDevelopment = false;
	private ArrayList<String> permissionList = null;
	private ClientConfigObject clientConfigObject = new ClientConfigObject();
	private Window logConsole = null;

	private static HashMap<String, Integer> accessMode = new HashMap<String, Integer>();
	private static MessageQueueCallBack  performListCallBack = null;
	private static MasterPanelBase currentBasePanel = null;

	private static MessageQueueCallBack listTableCallBack = null;
	private static MessageQueueCallBack syslogCallBack = null;
	private static MasterPanelBase currentPanel = null;

	static {
		accessMode.put(INVISIBLE_VALUE, new Integer(0));
		accessMode.put(FULL_ACCESS_VALUE, new Integer(2));
	}

	// hidden constructor
	protected FactoryBase() {
		// do nothing
	}

	/***************************************************************************
	 * Create/Show Panel Method
	 **************************************************************************/

	public void showPanel() {
		showPanel(getMainFrame(), (BasePanel) null, false, false);
	}

	public void showPanel(BasePanel panel) {
		showPanel(getMainFrame(), panel, false, false);
	}

	public void showPanel(BasePanel panel, boolean keepPanel) {
		showPanel(getMainFrame(), panel, keepPanel, false);
	}

	public void showPanel(MainFrame mainFrame) {
		showPanel(mainFrame, (BasePanel) null, false, false);
	}

	public void showPanel(MainFrame mainFrame, BasePanel panel) {
		showPanel(mainFrame, panel, false,false);
	}

	public void showPanel(MainFrame mainFrame, BasePanel panel, final boolean keepPanel) {
		showPanel(mainFrame, panel, keepPanel,false);
	}

	public void showPanel(final MainFrame mainFrame, final BasePanel panel, final boolean keepPanel, final boolean keepParam) {
		BasePanel oldPanel = null;
		if (hasPanel(mainFrame)) {
			oldPanel = mainFrame.getAppletBodyPanel();
		}
		boolean isOldPanel = false;

		if (panel != null
				&& panel.getPermissionName() != null
				&& !checkPermission(panel.getPermissionName())) {
			MessageBoxBase.addWarningMessage("Warning", "Access Denied", null);
			return;
		}

		if (panel != null) {
			if (!keepPanel && !keepParam) {
				// clear parameter if not keep panel
				mainFrame.getValueObjectPerPanel().clear();
			}

			// store mainFrame
			panel.setMainFrame(mainFrame);
		}

		// remove old panel with confirm
		if (oldPanel != null) {
			if (keepPanel) {
				// store the old panel to stack
//				oldPanel.saveButtonStatus();
				oldPanel.hideAction();
				mainFrame.getStack().push(oldPanel);

				showPanel2(mainFrame, panel, keepPanel, oldPanel, isOldPanel);
			} else {
				final BasePanel oldPanelCB = oldPanel;
				oldPanel.performEscAction(new CallbackListener() {
					@Override
					public void handleRetBool(boolean ret, String result, MessageQueue mQueue) {
						if (ret) {
							boolean isOldPanel = false;
							BasePanel panelCB = null;
							if (!mainFrame.getStack().empty()) {
								isOldPanel = true;
								// show the stack panel
								panelCB = (BasePanel) mainFrame.getStack().pop();
								//panel.loadButtonStatus();
							} else {
								panelCB = panel;
							}

							showPanel2(mainFrame, panelCB, keepPanel, oldPanelCB, isOldPanel);
						} else {
							// revert status (i.e. menu highlight)
						}
					}
				});
			}
		} else {
			showPanel2(mainFrame, panel, keepPanel, oldPanel, isOldPanel);
		}
	}

	public void showPanel2(MainFrame mainFrame, BasePanel panel, boolean keepPanel,
			BasePanel oldPanel, boolean isOldPanel) {
		// add new panel to body panel
		if (panel != null) {
			// attach panel to body
			mainFrame.modifyBodyPanel(panel);

			if (isOldPanel) {
				// call rePostAction method if panel is created
				panel.rePostAction();
			} else {
				// call preAction method when initial panel
				if (panel.preAction()) {
					// call postAction method when initial panel
					panel.postAction();
				} else {
					if (oldPanel != null) {
						mainFrame.modifyBodyPanel(oldPanel);

						// call rePostAction method if panel is created
						oldPanel.rePostAction();
					} else {
						// clear body panel
						mainFrame.clearBodyPanel();
					}
					panel = null;
				}
			}

			if (panel != null) {
				// ensure components show on screen
				panel.layout();

				if (panel instanceof DefaultPanel && ((DefaultPanel) panel).getTitle() != null) {
					// set panel title
					mainFrame.setTitle(((DefaultPanel) panel).getTitle());
				}

				defaultFocus(panel);
			}

			// enable close button
//			getCloseButton(mainFrame.getUserInfo()).setEnabled(true);
		} else {
			// clear body panel
			mainFrame.clearBodyPanel();

			// clear panel title
			mainFrame.setTitle(null);

			// disable close button
//			getCloseButton(mainFrame.getUserInfo()).setEnabled(false);
		}

		// apply and repaint the new panel
		mainFrame.getAppletBodyPanel().setVisible(true);
		mainFrame.getAppletBodyPanel().layout();
	}

	public boolean hasPanel(MainFrame mainFrame) {
		return mainFrame != null && mainFrame.hasBodyPanel() && mainFrame.getAppletBodyPanel() != null;
	}

	public boolean clearPanel(MainFrame mainFrame) {
		if (hasPanel(mainFrame)) {
			showPanel(mainFrame);
			return false;
		} else {
			return true;
		}
	}

	public void clearAllPanel(MainFrame mainFrame) {
		mainFrame.getStack().clear();
		showPanel(mainFrame);
	}

	public void focusPanel(MainFrame mainFrame) {
		if (mainFrame != null) {
			if (hasPanel(mainFrame)) {
				defaultFocus(mainFrame.getAppletBodyPanel());
			} else {
				mainFrame.getAppletBodyPanel().focus();
			}
		}
	}

	public void defaultFocus(final BasePanel panel) {
		if (panel.getDefaultFocusComponent() != null) {
			// set focus when panel is ready
			Scheduler.get().scheduleDeferred(new Scheduler.ScheduledCommand () {
				public void execute () {
					panel.getDefaultFocusComponent().focus();
				}
			});
		}

	}

	/***************************************************************************
	 * get function info
	 **************************************************************************/

//	public HashMap<String, String> getFunctionInfo(final UserInfo userInfo) {
//		if (userInfo.getApplet().getFunctionObject().size() == 0) {
//			QueryUtil.executeMasterBrowse(
//					userInfo,
//					FUNCTION_CONTROL_TXCODE,
//					new String[] { EMPTY_VALUE },
//					new MessageQueueCallBack() {
//						public void onPostSuccess(MessageQueue mQueue) {
//							if (mQueue.success()) {
//								String[] content = TextUtil.split(mQueue.getContentAsQueue(), TextUtil.LINE_DELIMITER);
//								String[] result = null;
//								for (int i = 0; i < content.length; i++) {
//									result = TextUtil.split(content[i]);
//									userInfo.getApplet().getFunctionObject().put(result[0], result[2]);
//								}
//							}
//						}
//					});
//		}
//		return userInfo.getApplet().getFunctionObject();
//	}

	/***************************************************************************
	 * access control
	 **************************************************************************/

	public boolean checkPermission(String functionName) {
		if (getMainFrame().getCurProjectModule() != null
				&& getMainFrame().getCurProjectModule().equals("CMS")) {
			return checkCMSPermission(functionName);
		} else {
			return true;
		}
	}

	public boolean checkCMSPermission(String functionName) {
		if (getUserInfo().isAdmin()) {
			return true;
		}
		if (getPermissionList() == null) {
			return false;
		}
		if (functionName == null) {
			return true;
		}
		return getPermissionList().contains(functionName);
	}

	public void addElementToPermissionList(String functionName) {
		if (getPermissionList() == null) {
			permissionList = new ArrayList<String>();
		}
		getPermissionList().add(functionName);
	}

	public void clearPermissionList() {
		if (getPermissionList() != null) {
			getPermissionList().clear();
		}
	}

	public boolean isFunctionKey(int keyCode) {
		return false;
	}

	/**
	 * check user permission by transaction code
	 * @param applet
	 * @param txCode
	 * @return
	 */
	public boolean checkPermission(UserInfo userInfo, String txCode) {
//		if (userInfo.getUserID() != null && txCode != null) {
//			// submit to validate
//			HashMap<String, String> hashMap = getPermission(userInfo, txCode);
//			if (hashMap != null					// must contain permission value
//			 && hashMap.containsKey(ALL_VALUE)	// contain minimum requirement
//			 && accessMode.get(hashMap.get(ALL_VALUE)).intValue() == accessMode.get(INVISIBLE_VALUE).intValue()
//												// must be invisible
//			) {
//				return false;
//			} else {
//				return true;
//			}
//		} else {
			return true;
//		}
	}

//	/**
//	 * load permission hash from database
//	 * @param applet
//	 * @param txCode
//	 * @return
//	 */
//	@SuppressWarnings("unchecked")
//	private HashMap<String, String> getPermission(final UserInfo userInfo, final String txCode) {
//		if (!userInfo.getApplet().getPermissionObject().containsKey(txCode)) {
//			// submit to validate
//			QueryUtil.executePermission(
//					userInfo,
//					new String[] { userInfo.getUserID(), txCode },
//					new MessageQueueCallBack() {
//						public void onPostSuccess(MessageQueue mQueue) {
//							if (mQueue.success()) {
//								String[] content = TextUtil.split(mQueue.getContentAsQueue(), TextUtil.LINE_DELIMITER);
//								HashMap<String, String> permissionHashMap = new HashMap<String, String>();
//								HashMap<String, Integer> accessLevelHashMap = getAccess(userInfo);
//								String[] result = null;
//								for (int i = 0; i < content.length; i++) {
//									result = TextUtil.split(content[i]);
//
//									if ((ALL_VALUE.equals(result[0]) || userInfo.getSiteCode().equals(result[0]))		// check site code
//									 && (ALL_VALUE.equals(result[3]) || accessLevelHashMap.get(userInfo.getDeptCode()).intValue() >= accessLevelHashMap.get(result[3]).intValue())
//																																	// check user group
//									 && (ALL_VALUE.equals(result[4]) || userInfo.getUserID().equals(result[4]))			// check user id
//									) {
//										// compare the access mode between db value and hash map value
//										if (!permissionHashMap.containsKey(result[2])
//												|| accessMode.get(result[5]).intValue() > accessMode.get(permissionHashMap.get(result[2])).intValue()) {
//											// save in hash map
//											permissionHashMap.put(result[2], result[5]);
//										}
//									}
//								}
//								userInfo.getApplet().getPermissionObject().put(txCode, permissionHashMap);
//							} else {
//								// store empty null
//								userInfo.getApplet().getPermissionObject().put(txCode, null);
//							}
//						}
//					});
//		}
//		return (HashMap<String, String>) userInfo.getApplet().getPermissionObject().get(txCode);
//	}
//
//	/**
//	 * load user group level from database
//	 * @param applet
//	 * @return
//	 */
//	private HashMap<String, Integer> getAccess(final UserInfo userInfo) {
//		if (userInfo.getApplet().getAccessObject().size() == 0) {
//			QueryUtil.executeComboBox(
//					userInfo,
//					USER_GROUP_ID_TXCODE,
//					new String[] {},
//					new MessageQueueCallBack() {
//						public void onPostSuccess(MessageQueue mQueue) {
//							if (mQueue.success()) {
//								try {
//									String[] content = TextUtil.split(mQueue.getContentAsQueue(), TextUtil.LINE_DELIMITER);
//									String[] result = null;
//									for (int i = 0; i < content.length; i++) {
//										result = TextUtil.split(content[i]);
//										userInfo.getApplet().getAccessObject().put(result[0], new Integer(result[2]));
//									}
//								} catch (Exception e) {
//									e.printStackTrace();
//								}
//							}
//						}
//					});
//		}
//		return userInfo.getApplet().getAccessObject();
//	}
//
//	@SuppressWarnings("unchecked")
//	public void setAccessField(UserInfo userInfo, String txCode, JComponent panel) {
//		HashMap<String, String> hashMap = userInfo.getApplet().getPermissionObject().get(txCode);
//		if (hashMap != null && hashMap.size() > 0) {
//			String fieldKey = null;
//			String fieldAccess = null;
//			for (Iterator<String> i=hashMap.keySet().iterator(); i.hasNext(); ) {
//				fieldKey = i.next();
//				fieldAccess = hashMap.get(fieldKey);
//				if (INVISIBLE_VALUE.equals(fieldAccess)) {
//					PanelUtil.setFieldsVisible(panel, fieldKey, false);
//				}
//			}
//		}
//	}

//	@SuppressWarnings("unchecked")
//	private boolean isButtonEnabled(UserInfo userInfo, String txCode, String action) {
//		HashMap<String, String> accessHashMap = userInfo.getApplet().getPermissionObject().get(txCode);
//		if (accessHashMap != null && accessHashMap.size() > 0 && accessHashMap.containsKey(action)) {
//			return accessMode.get(accessHashMap.get(action)).intValue()
//				>= accessMode.get(FULL_ACCESS_VALUE).intValue();
//		} else {
//			return true;
//		}
//	}
//
//	public boolean isSearchButtonEnabled(UserInfo userInfo, String txCode) {
//		return isButtonEnabled(userInfo, txCode, SEARCH_VALUE);
//	}
//
//	public boolean isAppendButtonEnabled(UserInfo userInfo, String txCode) {
//		return isButtonEnabled(userInfo, txCode, APPEND_VALUE);
//	}
//
//	public boolean isModifyButtonEnabled(UserInfo userInfo, String txCode) {
//		return isButtonEnabled(userInfo, txCode, MODIFY_VALUE);
//	}
//
//	public boolean isDeleteButtonEnabled(UserInfo userInfo, String txCode) {
//		return isButtonEnabled(userInfo, txCode, DELETE_VALUE);
//	}

	/***************************************************************************
	 * Message Method
	 **************************************************************************/

	public void addSystemMessage(String message) {
		Info.display("Message", message);
	}

	public void addSystemMessage(String message, String title) {
		Info.display(title, message);
	}

	public void addInformationMessage(String message) {
		addMessageHelper(false, message, null, null, null, null);
	}

	public void addInformationMessage(String message, Component comp) {
		addMessageHelper(false, message, null, null, comp, null);
	}

	public void addInformationMessage(String message, String title) {
		addMessageHelper(false, message, title, null, null, null);
	}

	public void addInformationMessage(String message,
			Listener<MessageBoxEvent> onCloseCallback) {
		addMessageHelper(false, message, null, null, null, onCloseCallback);
	}

	public void addInformationMessage(String message, String title,
			Listener<MessageBoxEvent> onCloseCallback) {
		addMessageHelper(false, message, title, null, null, onCloseCallback);
	}

	public void addInformationMessage(String message, String title,
			Component comp) {
		addMessageHelper(false, message, null, null, comp, null);
	}

	public void addErrorMessage(String message) {
		addMessageHelper(true, message, null, null, null, null);
	}

	public void addErrorMessage(String message, String title) {
		addMessageHelper(true, message, title, null, null, null);
	}

	public void addErrorMessage(String message, Component comp) {
		addMessageHelper(true, message, null, comp, null, null);
	}

	public void addErrorMessage(String message, Component comp,
			Listener<MessageBoxEvent> onCloseCallback) {
		addMessageHelper(true, message, null, comp, null, onCloseCallback);
	}

	public void addErrorMessage(String message, Component comp, Component focusComponent,
			Listener<MessageBoxEvent> onCloseCallback) {
		addMessageHelper(true, message, null, comp, focusComponent, onCloseCallback);
	}

	public void addErrorMessage(String message, Listener<MessageBoxEvent> onCloseCallback) {
		addMessageHelper(true, message, null, null, null, onCloseCallback);
	}

	public void addErrorMessage(String message, String title, Component comp) {
		addMessageHelper(true, message, title, comp, null, null);
	}

	public void addErrorMessage(String message, String title, Component comp, Component focusComponent) {
		addMessageHelper(true, message, title, comp, focusComponent, null);
	}

	public void addErrorMessage(String message, String title, Component comp,
								Listener<MessageBoxEvent> onCloseCallback) {
		addMessageHelper(true, message, title, comp, null, onCloseCallback);
	}

	public void addErrorMessage(String message, String title, Component comp,
								Component focusComponent,
								Listener<MessageBoxEvent> onCloseCallback) {
		addMessageHelper(true, message, title, comp, focusComponent, onCloseCallback);
	}

	public void addErrorMessage(MessageQueue mQueue) {
		addMessageHelper(true, mQueue.getReturnMsg(), null, null, null, null);
	}

	public void addErrorMessage(MessageQueue mQueue, Component comp) {
		addMessageHelper(true, mQueue.getReturnMsg(), null, comp, null, null);
	}

	public void addErrorMessage(MessageQueue mQueue, Component comp, Component focusComponent) {
		addMessageHelper(true, mQueue.getReturnMsg(), null, comp, focusComponent, null);
	}

	public void addErrorMessage(MessageQueue mQueue, Listener<MessageBoxEvent> callback) {
		addMessageHelper(true, mQueue.getReturnMsg(), null, null, null, callback);
	}

	public void clearMessage() {
		addMessageHelper(false, ConstantsVariable.EMPTY_VALUE, null, null, null, null);
	}

	private void addMessageHelper(boolean alert, final String message, String title,
			final Component comp, final Component focusComponent,
			Listener<MessageBoxEvent> callback) {
		if (message != null) {
			MessageBox mb = new MessageBox();
			if (title != null) {
				mb.setTitleHtml(title);
			}
			mb.setMessage(message);
			mb.setType(MessageBoxType.ALERT);
			if (alert) {
				mb.setIcon(MessageBox.WARNING);
			} else {
				mb.setIcon(MessageBox.QUESTION);
			}
			mb.setButtons(Dialog.OK);

			if (callback != null) {
				mb.addListener(Events.BeforeHide, callback);
			}

			if (comp != null) {
				mb.addCallback(new Listener<MessageBoxEvent>() {
					@Override
					public void handleEvent(MessageBoxEvent be) {
						setErrorField(comp, message);
					}
				});
			} else if (focusComponent != null) {
				mb.addCallback(new Listener<MessageBoxEvent>() {
					@Override
					public void handleEvent(MessageBoxEvent be) {
						focusComponent.focus();
					}
				});
			} else {
				mb.addCallback(new Listener<MessageBoxEvent>() {
					@Override
					public void handleEvent(MessageBoxEvent be) {
						if (getMainFrame().getBodyPanel().getDefaultFocusComponent() != null) {
							getMainFrame().getBodyPanel().getDefaultFocusComponent().focus();
						} else {
							getMainFrame().getBodyPanel().focus();
						}
					}
				});
			}
			mb.show();
		}
	}

	private void setErrorField(Component comp, String message) {
		if (comp != null) {
			if (comp instanceof TextBase) {
				((TextBase) comp).setErrorField(true, message);
				((TextBase) comp).requestFocus();
				((TextBase) comp).setCursorPos(((TextBase) comp).getText().length());
			} else if (comp instanceof TextAreaBase) {
				((TextAreaBase) comp).setErrorField(true, message);
				((TextAreaBase) comp).requestFocus();
				((TextAreaBase) comp).setCursorPos(((TextAreaBase) comp).getText().length());
			} else if (comp instanceof TextNum) {
				((TextNum) comp).setErrorField(true, message);
				((TextNum) comp).requestFocus();
				((TextNum) comp).setCursorPos(((TextNum) comp).getText().length());
			} else if (comp instanceof TextDate) {
				((TextDate) comp).setErrorField(true, message);
				((TextDate) comp).requestFocus();
				((TextDate) comp).setCursorPos(((TextDate) comp).getText().length());
			} else if (comp instanceof ComboBoxBase) {
				((ComboBoxBase) comp).setErrorField(true, message);
				((ComboBoxBase) comp).requestFocus();
			} else if (comp instanceof SearchTriggerField) {
				((SearchTriggerField) comp).setErrorField(true, message);
				((SearchTriggerField) comp).requestFocus();
				((SearchTriggerField) comp).setCursorPos(((SearchTriggerField) comp).getText().length());
			} else if (comp instanceof TextDateWithCheckBox) {
				((TextDateWithCheckBox) comp).setErrorField(true, message);
				((TextDateWithCheckBox) comp).requestFocus();
			} else if (comp instanceof TextDateTimeWithoutSecondWithCheckBox) {
				((TextDateTimeWithoutSecondWithCheckBox) comp).setErrorField(true, message);
				((TextDateTimeWithoutSecondWithCheckBox) comp).requestFocus();
			}
		}
	}

//	public boolean isConfirmYesNoDialog(UserInfo userInfo, String message) {
//		MessageBox mb=new MessageBox();
//		mb.setMessage(message);
//		mb.setTitle("Message");
//		mb.setButtons(MessageBox.YESNOCANCEL);
//		mb.show();
//		return false;
//	}

	public MessageBox isConfirmYesNoDialog(String message, Listener<MessageBoxEvent> callback) {
		return MessageBoxBase.confirm("Message", message, callback);
	}

	public MessageBox isConfirmYesNoDialog(String title, String message, Listener<MessageBoxEvent> callback) {
		return MessageBoxBase.confirm(title, message, callback);
	}

//	public int isConfirmYesNoCancelDialog(UserInfo userInfo, String message) {
////		return JOptionPane.showConfirmDialog(userInfo.getApplet(), message, null, JOptionPane.YES_NO_CANCEL_OPTION);
//		return 0;
//	}

	/***************************************************************************
	 * getter/setter method
	 **************************************************************************/

	public void setTitle(String title) {
		Document.get().setTitle(title);
	}

	/***************************************************************************
	 * logging method
	 **************************************************************************/

	public void addLogConsoleMsg(String msg, int logLevel) {
		if (logConsole == null) {
			logConsole = new Window();
			logConsole.setPlain(true);
			logConsole.setSize(700, 200);
			logConsole.setHeadingHtml("Log Console");
			logConsole.setLayout(new FitLayout());

			FormPanel panel = new FormPanel();
			panel.setItemId("logConsole-p");
			panel.setBorders(false);
			panel.setBodyBorder(false);
			panel.setLabelWidth(55);
			panel.setPadding(5);
			panel.setHeaderVisible(false);
			FormData fd = new FormData("100%");

			TextField<String> field = new TextField<String>();
			field.setFieldLabel("Search");
			panel.add(field, fd);

			final TextArea message = new TextArea();
			message.setItemId("logConsole-message");
			message.setFieldLabel("Log");
			panel.add(message, fd);

			ButtonBase clearBtn = new ButtonBase("Clear", new SelectionListener<ButtonEvent>() {
				@Override
				public void componentSelected(ButtonEvent ce) {
					message.setValue("");
				}
			});

			ButtonBase copyBtn = new ButtonBase("Copy", new SelectionListener<ButtonEvent>() {
				@Override
				public void componentSelected(ButtonEvent ce) {
					copyToClipboard(message.getValue());
				}
			});

			logConsole.addButton(clearBtn);
			logConsole.addButton(copyBtn);
			logConsole.add(panel);
		}
		TextArea message = ((TextArea) ((FormPanel)logConsole.getItemByItemId("logConsole-p"))
				.getItemByItemId("logConsole-message"));

		if (message.getValue() != null) {
			msg = message.getValue() + "\n" + msg;
		}
		message.setValue(msg);
		logConsole.show();
	}

	public void clientLog(UserInfo userInfo, Object exception) {
//		if (getClientLogDir() == null) {
//			return;
//		} else {
//			try {
//				StringBuilder sb = new StringBuilder();
//				sb.append(getClientLogDir());
//				sb.append(File.separator);
//				sb.append(QueryUtil.getContextRoot());
//				sb.append((Calendar.getInstance().get(Calendar.DAY_OF_WEEK) - 1));
//				sb.append(".log");
//				File LogFileName = new File (sb.toString());
//
//				// create directory if necessary
//				(new File (getClientLogDir())).mkdirs ();
//
//				// check the log file last modified date
//				// if the last modified date is today, no need to delete log file
//				Date currentTime = new Date();
//				Date logFileTime = currentTime;
//				logFileTime.setTime(LogFileName.lastModified());
//
//				// append string
//				OutputStream os = new FileOutputStream(LogFileName, DateTimeUtil.formatDateTime(currentTime).equals(DateTimeUtil.formatDateTime(logFileTime)));
//				PrintWriter out = new PrintWriter(new BufferedWriter(new OutputStreamWriter(os)));
//				out.print(currentTime);
//				out.print("\t");
//				if (exception instanceof Exception) {
//					((Exception) exception).printStackTrace(out);
//				} else {
//					out.println(exception.toString());
//				}
//				out.flush();
//				out.close();
//			} catch (Exception ex) {
//				ex.printStackTrace();
//			}
//		}
	}

	/***************************************************************************
	 * getter/setter method
	 **************************************************************************/

	/**
	 * @return the mainFrame
	 */
	public MainFrame getMainFrame() {
		return mainFrame;
	}

	/**
	 * @param mainFrame the mainFrame to set
	 */
	public void setMainframe(MainFrame mainFrame) {
		this.mainFrame = mainFrame;
	}

	/**
	 * @return the userInfo
	 */
	public UserInfo getUserInfo() {
		return getMainFrame().getUserInfo();
	}

	/**
	 * @return Returns the clientLogDir.
	 */
	public String getClientLogDir() {
		return clientLogDir;
	}

	/**
	 * @param clientLogDir The clientLogDir to set.
	 */
	public void setClientLogDir(String clientLogDir) {
		this.clientLogDir = clientLogDir;
	}

	/**
	 * @return the isSkipLogin
	 */
	public boolean isSkipLogin() {
		return isSkipLogin;
	}

	/**
	 * @param isSkipLogin the isSkipLogin to set
	 */
	public void setSkipLogin(boolean isSkipLogin) {
		this.isSkipLogin = isSkipLogin;
	}

	/**
	 * @return the isDevelopment
	 */
	public boolean isDevelopment() {
		return isDevelopment;
	}

	/**
	 * @param isDevelopment the isDevelopment to set
	 */
	public void setDevelopment(boolean isDevelopment) {
		this.isDevelopment = isDevelopment;
	}

	/**
	 * @return the valueObject
	 */
	public HashMap<String, Object> getValueObjectPerUser() {
		return getMainFrame().getValueObjectPerUser();
	}

	/**
	 * @return the valueObject
	 */
	public HashMap<String, Object> getValueObjectPerPanel() {
		return getMainFrame().getValueObjectPerPanel();
	}

	/**
	 * @return the permissionList
	 */
	public ArrayList<String> getPermissionList() {
		return permissionList;
	}

	/**
	 * @param permissionList the permissionList to set
	 */
	public void setPermissionList(ArrayList<String> permissionList) {
		this.permissionList = permissionList;
	}

	// not open to client
	public ClientConfigObject getClientConfigObject() {
		return this.clientConfigObject;
	}

	public void setClientConfigObject(ClientConfigObject clientConfigObject) {
		this.clientConfigObject = clientConfigObject;
	}

	public MessageQueueCallBack getPerformListCallBack(MasterPanelBase panel) {
		this.currentBasePanel = panel;
		if (performListCallBack == null) {
			performListCallBack =
				new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						currentBasePanel.performListCallBackPost(mQueue);
					}

					@Override
					public void onFailure(Throwable caught) {
						super.onFailure(caught);

						writeLog("FactoryBase", "Failure @ getPerformListCallBack", caught.getMessage());

						// enable fields
						currentBasePanel.performListCallBackAfterPost();
					}

					@Override
					public void onComplete() {
						super.onComplete();

						// set loading flag false
						getMainFrame().setLoading(false);
					}
				};
		}
		return performListCallBack;
	}

	/***************************************************************************
	 * extra method
	 **************************************************************************/

	public void showMask() {
		if (getMainFrame() != null) {
			showMask(getMainFrame().getBodyPanel());
		}
	}

	public void showMask(Component comp) {
		if (comp == null) {
			return;
		}
		comp.mask("Loading", "x-mask-loading");
	}

	public void hideMask() {
		if (getMainFrame() != null) {
			hideMask(getMainFrame().getBodyPanel());
		}
	}

	public void hideMask(Component comp) {
		if (comp == null) {
			return;
		}
		comp.unmask();
	}

	public void resetSysTimeout() {
		if (getMainFrame() != null) {
			getMainFrame().resetSysTimeout();
		}
	}

	public void showWaitCursor() {
		DOM.setStyleAttribute(RootPanel.getBodyElement(), "cursor", "wait");
	}

	public void showDefaultCursor() {
		DOM.setStyleAttribute(RootPanel.getBodyElement(), "cursor", "default");
	}

	public native void consoleLog(String log) /*-{
		if (console) {
			console.log(log);
		}
	}-*/;

	public native void consoleLog(String log, String objName) /*-{
		if (console) {
			console.log(log + ' %o', objName);
		}
	}-*/;

	public native void copyToClipboard(String txt) /*-{
		var copied = false;
		 if(window.clipboardData) {
			window.clipboardData.clearData();
			window.clipboardData.setData("Text", txt);
			copied = true;
		 } else if (window.netscape) {
			try {
			   netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
			} catch (e) {
			   alert("Browser denied copy function.\nPlease enter 'about:config' in the address bar.\nSet property: 'signed.applets.codebase_principal_support' to 'true'.");
			}
			var clip = Components.classes['@mozilla.org/widget/clipboard;1']
			.createInstance(Components.interfaces.nsIClipboard);
			if (!clip)
			   return;
			var trans = Components.classes['@mozilla.org/widget/transferable;1']
			.createInstance(Components.interfaces.nsITransferable);
			if (!trans)
			   return;
			trans.addDataFlavor('text/unicode');
			var str = new Object();
			var len = new Object();
			var str = Components.classes["@mozilla.org/supports-string;1"]
			.createInstance(Components.interfaces.nsISupportsString);
			var copytext = txt;
			str.data = copytext;
			trans.setTransferData("text/unicode",str,copytext.length*2);
			var clipid = Components.interfaces.nsIClipboard;
			if (!clip)
			   return false;
			clip.setData(trans,null,clipid.kGlobalClipboard);
			copied = true;
		 }
		 if (copied)
			 return true;
		 else
			 return false;
	}-*/;

	public String getPrtAppletName() {
		return clientConfigObject.getAppletName();
	}

	public String getVersionNumber() {
		return clientConfigObject.getVersionNo();
	}

	/***************************************************************************
	 * Call Back Method
	 **************************************************************************/

	public MessageQueueCallBack getListTableCallBack(MasterPanelBase panel) {
		this.currentPanel = panel;
		if (listTableCallBack == null) {
			listTableCallBack = new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					currentPanel.getListTable().setListTableContent(mQueue);
				}
			};
		}
		return listTableCallBack;
	}

	/***************************************************************************
	 * Log Method
	 **************************************************************************/

	public void writeLog(String module, String logAction, String remark) {
		// implement in base class
	}

	public MessageQueueCallBack getSyslogCallBack() {
		if (syslogCallBack == null) {
			syslogCallBack = new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					// TODO Auto-generated method stub
				}
			};
		}
		return syslogCallBack;
	}

	public native void writeLogToLocal(String text) /*-{
		var appletName = @com.hkah.client.util.PrintingUtil::getAppletName()();
		if (appletName == null || appletName == '') {
			alert('Cannot get applet:' + appletName);
		}

//		$wnd.getApplet(appletName).writeLog(text);
	}-*/;
}