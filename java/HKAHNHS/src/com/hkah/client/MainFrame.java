package com.hkah.client;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;

import org.timepedia.exporter.client.Export;
import org.timepedia.exporter.client.Exportable;

import com.extjs.gxt.ui.client.Registry;
import com.extjs.gxt.ui.client.event.BaseEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MenuEvent;
import com.extjs.gxt.ui.client.event.SelectionListener;
import com.extjs.gxt.ui.client.widget.menu.Menu;
import com.extjs.gxt.ui.client.widget.menu.MenuBarItem;
import com.extjs.gxt.ui.client.widget.menu.SeparatorMenuItem;
import com.google.gwt.core.client.GWT;
import com.google.gwt.dom.client.NativeEvent;
import com.google.gwt.event.logical.shared.CloseEvent;
import com.google.gwt.event.logical.shared.CloseHandler;
import com.google.gwt.user.client.Event;
import com.google.gwt.user.client.Event.NativePreviewEvent;
import com.google.gwt.user.client.Event.NativePreviewHandler;
import com.google.gwt.user.client.Timer;
import com.google.gwt.user.client.Window;
import com.google.gwt.user.client.Window.ClosingEvent;
import com.google.gwt.user.client.Window.ClosingHandler;
import com.google.gwt.user.client.rpc.AsyncCallback;
import com.hkah.client.common.Factory;
import com.hkah.client.config.MenuConfig;
import com.hkah.client.layout.menu.MenuItemBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.services.CommonUtilServiceAsync;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;
import com.hkah.shared.model.PrinterInfo;

/**
 * Entry point classes define <code>onModuleLoad()</code>.
 */
public class MainFrame extends MainFrameBase {

	private final static String m_title = "PBA";
	private final static String LOGON_TXCODE = "ACT_LOGON";
//	private final static String CALL_CHART_MENU = "menu.13";
//	private final static String PATIENTCARD_MENU = "menu.14";

	private long dbTimeDiff = 0;
	private PrinterInfo ptInfo = new PrinterInfo();
	private HashMap<String, String> disableFunc = new HashMap<String, String>();
	private HashMap<String, String> sysParams = new HashMap<String, String>();
	private HashMap<String, String> rptDescMap = new HashMap<String, String>();
	private HashSet<MenuBarItem> changeMenuBarItem = new HashSet<MenuBarItem>();
	private String currentSteCode = null;

	private MenuBarItem currentMenuBarItem = null;
	private Menu currentSubMenu = null;

	@Override
	protected MainFrame getMainFrame() {
		return this;
	}

	@Override
	protected String getTitle() {
		// return project title
		return m_title;
	}

	/***************************************************************************
	 * create menu
	 **************************************************************************/

	protected void loadMenu() {
		int no_of_menu = Integer.parseInt(MenuConfig.get("menu.no"));
		MenuBarItem menuBarItem = null;
		Menu menu = null;
		String src = null;
		String dest = null;
		String mnemonic = null;
		String variableName = null;
		String menuKey = null;

		changeMenuBarItem.clear();
		for (int i = 1; i <= no_of_menu; i++) {
			menuKey = MENU_VALUE + DOT_VALUE + i;
			src = MenuConfig.get(menuKey + DOT_VALUE + NAME_VALUE);
			dest = MenuConfig.get(menuKey + DOT_VALUE + DESTINATION_VALUE);
			mnemonic = MenuConfig.get(menuKey + DOT_VALUE + MNEMONIC_VALUE);
			variableName = MenuConfig.getMenuVariable(menuKey + DOT_VALUE + NAME_VALUE);

			// skip disable menu
			if (variableName != null && Factory.getInstance().isDisableFunction(variableName))
				continue;

			if (dest != null && dest.startsWith(MENU_DELIMITER)) {
				menu = createMenuHelper(dest.substring(1));
			} else {
				menu = new Menu();
			}

			if (mnemonic != null) {
				menu.setItemId(mnemonic.toUpperCase());
			}

			menuBarItem = new MenuBarItem(src, menu);

			// allow menu enable/disable
//			if (!CALL_CHART_MENU.equals(menuKey) && !PATIENTCARD_MENU.equals(menuKey)) {
				changeMenuBarItem.add(menuBarItem);
//			}

			getMenuBar().add(menuBarItem);
		}
	}

	protected Menu createMenuHelper(String itemKey) {
		// create sub-menu
		int no_of_submenu = Integer.parseInt(MenuConfig.get(itemKey + ".no"));

		Menu jmenu = new Menu();
		MenuItemBase menuItem = null;
		String name = null;
//		String keys = null;
//		String mask = null;
		String mnemonic = null;
		String dest = null;
		String variableName = null;
		String menuKey = null;
		BasePanel destPanel = null;

		for (int i = 1; i <= no_of_submenu; i++) {
			menuKey = itemKey + DOT_VALUE + i;
			name = MenuConfig.get(menuKey + DOT_VALUE + NAME_VALUE);
			if (name != null) {
				dest = MenuConfig.get(menuKey + DOT_VALUE + DESTINATION_VALUE);
				destPanel = MenuConfig.getPanel(menuKey + DOT_VALUE + DESTINATION_VALUE);
//				keys = MenuConfig.get(menuKey + DOT_VALUE + KEYS_VALUE);
//				mask = MenuConfig.get(menuKey + DOT_VALUE + MASK_VALUE);
				mnemonic = MenuConfig.get(menuKey + DOT_VALUE + MNEMONIC_VALUE);
				variableName = MenuConfig.getMenuVariable(menuKey + DOT_VALUE + NAME_VALUE);

				// skip disable menu
				if (variableName != null && Factory.getInstance().isDisableFunction(variableName)) {
					continue;
				}

				menuItem = new MenuItemBase(name) {
					public void callActivate(boolean autoExpand) {
						activate(autoExpand);
					}
				};

				if (dest != null && dest.startsWith(MENU_DELIMITER)) {
					// create sub-menu
					menuItem.setSubMenu(createMenuHelper(dest.substring(1)));
				} else {
					if (CLOSE_VALUE.equals(name)) {
						menuItem.addSelectionListener(new SelectionListener<MenuEvent>() {
							@Override
							public void componentSelected(MenuEvent ce) {
								exitPanel();
							}
						});
//					} else if (EXIT_VALUE.equals(name)) {
//						menuItem.addSelectionListener(new SelectionListener<MenuEvent>() {
//							@Override
//							public void componentSelected(MenuEvent ce) {
//								// logout system
//								Factory.getInstance().clearAllPanel(getApplet());
//								processLogin();
//							}
//						});
					} else if (destPanel != null) {
						createMenuItemHelper(menuItem, destPanel);
					} else {
						// set menu item disable if destination is empty
						menuItem.setEnabled(false);
					}
				}

				// set shortcut key
//				if (keys != null && mask != null) {
//					 menuItem.setAccelerator(KeyStroke.getKeyStroke(mask.toLowerCase().trim()
//					 + " released " + keys.toUpperCase().trim()));
//				}

				// set mnemonic key
				if (mnemonic != null) {
					// menuItem.setMnemonic(mnemonic.charAt(0));
					menuItem.setItemId(mnemonic.toUpperCase());
				}

				if (name.equals(MenuConfig.NO_SUB_MENU_NAME)) {
					menuItem.setVisible(false);
				}

				jmenu.add(menuItem);
			} else {
				// add menu separator
				jmenu.add(new SeparatorMenuItem());
			}
		}
		return jmenu;
	}

	private void createMenuItemHelper(MenuItemBase menuItem,
			final BasePanel destPanel) {
		if (destPanel != null) {
			menuItem.addSelectionListener(new SelectionListener<MenuEvent>() {
				@Override
				public void componentSelected(MenuEvent ce) {
					// show new panel
					currentMenuBarItem = null;
					currentSubMenu = null;
					showPanel(destPanel, false);
				}
			});
			// support no sub menu item
			menuItem.addListener(Events.Open, new Listener<BaseEvent>() {
				@Override
				public void handleEvent(BaseEvent be) {
					// show new panel
					currentMenuBarItem = null;
					currentSubMenu = null;
					showPanel(destPanel, false);
				}
			});
		}
	}

//	@Override
//	public void refreshMenuBarStatus() {
//		boolean disableMenu = !hasBodyPanel();
//		MenuBarItem menuBarItem = null;
//
//		// set menu enable/disable to listed item
//		if (changeMenuBarItem.size() > 0) {
//			for (Iterator<MenuBarItem> i = changeMenuBarItem.iterator(); i.hasNext();) {
//				menuBarItem = i.next();
//				menuBarItem.setEnabled(disableMenu);
//				menuBarItem.getMenu().setEnabled(disableMenu);
//			}
//		}
//	}

	/***************************************************************************
	 * Initial Method
	 **************************************************************************/

	@Override
	public void initUserInfoFromDB() {
		// initial main frame
		getToolBarModuleName().setText(EMPTY_VALUE);
		getToolBarSiteName().setText(EMPTY_VALUE);

		QueryUtil.executeTx(getUserInfo(), LOGON_TXCODE,
				new String[] {
					getUserInfo().getUserID(),
					EMPTY_VALUE,
					NO_VALUE,
					CommonUtil.getComputerIP(),
					NO_VALUE,
					getUserInfo().getSsoSessionID()
				},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success() && mQueue.getContentField().length > 0) {
					getUserInfo().setUserName(mQueue.getContentField()[0]);
					getUserInfo().setDeptCode(mQueue.getContentField()[1]);
					getUserInfo().setInPatient(mQueue.getContentField()[2]);
					getUserInfo().setOutPatient(mQueue.getContentField()[3]);
					getUserInfo().setDayCase(mQueue.getContentField()[4]);
					getUserInfo().setPBO(mQueue.getContentField()[5]);
					getUserInfo().setSiteCode(mQueue.getContentField()[6]);
					getUserInfo().setSiteName(mQueue.getContentField()[7]);

					// set main frame
					getToolBarModuleName().setText(getUserInfo().getUserName());
					getToolBarSiteName().setText(getUserInfo().getSiteName());
					getToolBarRemark().setText(mQueue.getContentField()[8]);
					getToolBarVersion().setText(Factory.getInstance().getVersionNumber());

					// save sessionID in SSO
					if (getUserInfo().getSsoSessionID() != null && !getUserInfo().getSsoSessionID().isEmpty()) {
						QueryUtil.executeMasterAction(getUserInfo(), ConstantsTx.LOGON_SSO_TXCODE,
								QueryUtil.ACTION_APPEND,
								new String[] {
									getUserInfo().getUserID(),
									getUserInfo().getDeptCode(),
									getUserInfo().getSsoModuleCode(),
									getUserInfo().getSsoSessionID()
								},
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
//								System.out.println("DEBUG NHS Mainframe ACT_LOGON_SSO success");
							}
						});
					}

					if (!ZERO_VALUE.equals(mQueue.getContentField()[9])) {
						Factory.getInstance().addErrorMessage(ConstantsMessage.ERROR_DAYEND);
					}

					// other code
					getUserInfo().setOtherCode(mQueue.getContentField()[10]);

					Factory.getInstance().writeLogToLocal(Factory.getInstance().getUserInfo().getUserID()+" logged in.....");
					CommonUtil.loadPortalHost();
					// load user access right
					initUserAccessRight();
				} else {
					loginFailAlert();
				}
			}

			public void onFailure(Throwable caught) {
				super.onFailure(caught);
				loginFailAlert();
			}
		});
	}

	private void initUserAccessRight() {
		disableFunc.clear();

		QueryUtil.executeMasterBrowse(getUserInfo(),
				ConstantsTx.DISABLEFUNC_TXCODE,
				new String[] { getUserInfo().getUserID() },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					String[] record = TextUtil.split(
							mQueue.getContentAsQueue(), LINE_DELIMITER);
					String[] row = null;
					for (int i = 0; i < record.length; i++) {
						row = TextUtil.split(record[i]);
						if (row.length > 1) {
							disableFunc.put(row[0], row[1]);
						} else {
							disableFunc.put(row[0], null);
						}
					}
				}

				initSystemParameter();
			}
		});
	}

	private void initSystemParameter() {
		sysParams.clear();

		QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] { "SysParam", "ParCde, Param1", "1 = 1" },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					String[] record = TextUtil.split(
							mQueue.getContentAsQueue(), LINE_DELIMITER);
					String[] row = null;
					for (int i = 0; i < record.length; i++) {
						row = TextUtil.split(record[i]);
						sysParams.put(row[0], row[1]);
					}
				}

				initRptDescMap();
			}
		});

		QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] { "dual", "GET_CURRENT_STECODE", "1=1" },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					currentSteCode = mQueue.getContentField()[0];
				}
			}
		});
	}

	private void initRptDescMap() {
		rptDescMap.clear();

		QueryUtil.executeMasterBrowse(
				getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] { "DESCRIPTION_MAPPING",
						"TYPE, ID, LANGUAGE, DESCRIPTION",
						"TYPE IN ('MAPLANGUAGE', 'PAYMENTMETHOD') AND ENABLE = 1" },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					String[] record = TextUtil.split(
							mQueue.getContentAsQueue(),
							LINE_DELIMITER);
					String[] row = null;
					for (int i = 0; i < record.length; i++) {
						row = TextUtil.split(record[i]);
						rptDescMap.put(row[0].toUpperCase()
								+ "_" + row[1].toUpperCase()
								+ "_" + row[2].toUpperCase(),
								row[3]);
					}
				}

				initFinished();
			}
		});
	}

	private void initFinished() {
		// load menu
		loadMenu();

		// init load module
		loadModule();

		//add event for menu
		NativePreviewHandler nativePreviewHandler = new NativePreviewHandler() {
			@Override
			public void onPreviewNativeEvent(NativePreviewEvent event) {
				if (event.getTypeInt() != Event.ONKEYDOWN) {
					return;
				}
				final NativeEvent nativeEvent = event.getNativeEvent();
				final boolean altKey = nativeEvent.getAltKey();

				handleMenuBarByKey(event, altKey, nativeEvent.getKeyCode());
			}
		};
		Event.addNativePreviewHandler(nativePreviewHandler);
	}

	@Override
	protected void loadModule() {
		// load user id from parameter
		super.loadModule();

		((CommonUtilServiceAsync) Registry
				.get(AbstractEntryPoint.COMMONUTIL_SERVICE))
				.getComputerIP(new AsyncCallback<String>() {
					@Override
					public void onSuccess(String result) {
						initPrinterInfo(result);
					}

					@Override
					public void onFailure(Throwable caught) {
					}
				});

		// call once initial
		updateTimeDiff();

		// update timestamp from db
		Timer timer = new Timer() {
			@Override
			public void run() {
				updateTimeDiff();
			}
		};
		// each 10 minutes refresh
		timer.scheduleRepeating(600000);
	}

	protected void setCurrentMenuBarItem(MenuBarItem mbi) {
		currentMenuBarItem = mbi;
	}

	protected boolean handleMenuBarByKey(NativePreviewEvent event, boolean isAltKey, int keyCode) {
		if (keyCode == 27) {
			if (currentMenuBarItem != null) {
				getMenuBar().toggle(currentMenuBarItem);
			}

			if (currentSubMenu != null) {
				currentSubMenu.hide(true);
			}
			currentMenuBarItem = null;
			currentSubMenu = null;
		}

		if (getMenuBar().isEnabled()) {
			if (isAltKey) {
				if (currentMenuBarItem != null) {
					if (handleMenuByKey(event, currentMenuBarItem.getMenu(), keyCode)) {
						return true;
					}
				}

				for (int i = 0; i < getMenuBar().getItemCount(); i++) {
					MenuBarItem mi = getMenuBar().getItem(i);

					if (mi.isEnabled()) {
						if (mi.getMenu().getItemId().charAt(0) == keyCode) {
							Menu menu = mi.getMenu();
							if (menu != null) {
								MenuItemBase menuItem = (MenuItemBase) menu
										.getItem(0);

								if (MenuConfig.NO_SUB_MENU_NAME.equals(menuItem.getText())) {
									menuItem.fireEvent(Events.Open);
									event.getNativeEvent().preventDefault();
								} else {
									currentMenuBarItem = mi;
									getMenuBar().toggle(mi);
									mi.getMenu().setActiveItem(mi.getMenu().getItem(0), false);

									if (currentSubMenu != null) {
										currentSubMenu.hide(true);
									}
								}
								return true;
							}
							return false;
						}
					}
				}
				return false;
			} else {
				if (currentMenuBarItem != null) {
					return handleMenuByKey(event, currentMenuBarItem.getMenu(), keyCode);
				} else {
					if (currentSubMenu != null) {
						return handleMenuByKey(event, currentSubMenu, keyCode);
					}
					else {
						return false;
					}
				}
			}
		}
		return false;
	}

	protected boolean handleMenuByKey(NativePreviewEvent event, Menu menu, int keyCode) {
		ArrayList<MenuItemBase> menuList = new ArrayList<MenuItemBase>();

		for (int i = 0; i < menu.getItemCount(); i++) {
			if (menu.getItem(i) instanceof SeparatorMenuItem) {
				continue;
			}
			MenuItemBase mi = (MenuItemBase) menu.getItem(i);

			if (mi.isActivate()) {
				mi.callDeActivate();
				mi.setActivate(true);
				//menu.setActiveItem(c, autoExpand)
			}

			if (mi.getItemId().charAt(0) == keyCode) {
				menuList.add(mi);
			}
		}

		if (menuList.size() > 1) {
			for (int i = 0; i < menuList.size(); i++) {
				if (menuList.get(i).isActivate()) {
					menuList.get(i).callDeActivate();

					if (i + 1 == menuList.size()) {
						menuList.get(0).callActivate(false);
					} else {
						menuList.get(i + 1).callActivate(false);
					}
					return true;
				}
			}
			menuList.get(0).callActivate(true);
			return true;
		} else if (menuList.size() == 1) {
			if (menuList.get(0).getSubMenu() == null) {
				getMenuBar().toggle(currentMenuBarItem);
				menuList.get(0).fireEvent(Events.Open);
				currentMenuBarItem = null;
				currentSubMenu = null;
				event.getNativeEvent().preventDefault();
				return true;
			} else {
//				getMenuBar().toggle(currentMenuBarItem);
				currentSubMenu = menuList.get(0).getSubMenu();
				currentMenuBarItem = null;
				menuList.get(0).callActivate(true);
				return true;
			}
		} else {
			return false;
		}
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public boolean isDisableFunction(String fscKey) {
		return isDisableFunction(fscKey, EMPTY_VALUE);
	}

	public boolean isDisableFunction(String fscKey, String fscParent) {
		return getDisableFunc().containsKey(
				(fscKey + ConstantsVariable.UNDERSCORE_VALUE + fscParent)
						.toUpperCase());
	}

	public boolean isDisaCmdNameOfOTLogBookFrm(String fscKey, String sCmdName) {
		if (fscKey != null && sCmdName != null) {
			Iterator<String> itr = getDisableFunc().keySet().iterator();
			while (itr.hasNext()) {
				String key = itr.next();
				String fscDesc = getDisableFunc().get(key);
				String[] fsc = key.split(ConstantsVariable.UNDERSCORE_VALUE);
				if (fsc != null && fsc.length > 1
						&& fscKey.toUpperCase().equals(fsc[0])
						&& "otLogBook".toUpperCase().equals(fsc[1])) {
					int lgtIdx = fscDesc.lastIndexOf(ConstantsVariable.GREATER_THAN_DELIMITER);
					if (lgtIdx >= 0) {
						if (sCmdName.toUpperCase().equals(
								fscDesc.substring(lgtIdx + 1, fscDesc.length()).trim().toUpperCase())) {
							return true;
						}
					}
				}
			}
		}
		return false;
	}

	public HashMap<String, String> getDisableFunc() {
		return disableFunc;
	}

	public String getSysParameter(String parcde) {
		String value = sysParams.get(parcde);
		if (value != null) {
			return value;
		} else {
			return EMPTY_VALUE;
		}
	}

	public String getCurrentSteCode() {
		return currentSteCode;
	}

	public String getRptDescMap(String key) {
		String value = rptDescMap.get(key);
		if (value != null) {
			return value;
		} else {
			return EMPTY_VALUE;
		}
	}

	private void initPrinterInfo(String clientIP) {
		QueryUtil.executeMasterFetch(getUserInfo(), "PRINTERINFO",
				new String[] { clientIP }, new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							for (int i = 0; i < mQueue.getContentLineCount(); i++) {
								getPrinterInfo().setPtrName(
										mQueue.getContentField()[i + i].trim()
												.replaceAll("<LINE/>", ""),
										mQueue.getContentField()[i + (i + 1)]);
							}
						}
					}
				});
	}

	@Override
	public PrinterInfo getPrinterInfo() {
		return ptInfo;
	}

	private void updateTimeDiff() {
		QueryUtil.executeTx(getUserInfo(), "CHK_KEEPALIVE",
				new String[] { getUserInfo().getUserID(), CommonUtil.getComputerIP(), getUserInfo().getSsoModuleCode(), getUserInfo().getSsoSessionID() },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					dbTimeDiff = DateTimeUtil.dateTimeDiff(
							DateTimeUtil.getCurrentDateTime(),
							mQueue.getContentField()[0]);

					String returnCode = mQueue.getContentField()[1];
					String returnMsg = mQueue.getContentField()[2];
					if (returnMsg != null && returnMsg.length() > 0) {
						if (MINUS_ONE_VALUE.equals(returnCode)) {
							Factory.getInstance().addSystemMessage(returnMsg);
						} else if (MINUS_TWO_VALUE.equals(returnCode)) {
							Factory.getInstance().addErrorMessage(returnMsg);
						} else if (MINUS_THREE_VALUE.equals(returnCode)) {
							sysTimeoutExpired(returnMsg);
						}
					}
				}
			}

			@Override
			public void onFailure(Throwable caught) {
				// stay away all error message
				onComplete();
			}
		});
	}

	public void writeLog(String module, String logAction, String remark) {
		Factory.getInstance().writeLog(module, logAction, remark);
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	public int getSysTimeoutInit() {
		try {
			return Integer.parseInt(getSysParameter("SYSTIMEOT2"));
		} catch (Exception e) {
			return super.getSysTimeoutInit();
		}
	}

	@Override
	protected void sysTimeoutExpiredPost() {
		Factory.getInstance().hideMask();
		getMenuBar().setEnabled(false);
	}

	/***************************************************************************
	 * Server Date Time
	 **************************************************************************/

	@Override
	public String getServerDateTime() {
		return DateTimeUtil.getCurrentDateTime(dbTimeDiff);
	}

	@Override
	public String getServerDate() {
		return DateTimeUtil.getCurrentDate(dbTimeDiff);
	}

	@Override
	public String getServerTime() {
		return DateTimeUtil.getCurrentTime(dbTimeDiff);
	}

	protected void checkTime(String datetime) {
		if (getUserInfo().isCashier()) {
			// check time schedule
			String currentTime = datetime.substring(11);
			if ("23:30:00".equals(currentTime)) {
				Factory.getInstance().addInformationMessage(
						"Please close the cashier at once!", "Logout Box");
			} else if ("23:45:00".equals(currentTime)) {
				Factory.getInstance().addInformationMessage(
						"Last Warning !!! Please close the cashier at once!",
						"Logout Box");
			}
		}
	}

	/***************************************************************************
	 * For Testing Only
	 **************************************************************************/

	@Override
	public void onModuleLoad() {
		super.onModuleLoad();
		GWT.create(ExportJsMethod.class);

		//Add temp cashier forced sign off method
		Window.addWindowClosingHandler(new ClosingHandler() {
			@Override
			public void onWindowClosing(ClosingEvent event) {
				event.setMessage("You are closing the window. do you want to continue. Click 'Ok' to close or click 'Cancel' to stay back");

				String cshOffCls = Factory.getInstance().getSysParameter("CSHOFFCLS");
				String userAgent = Window.Navigator.getUserAgent();
				if (userAgent.contains("MSIE") && "Y".equals(cshOffCls)) {
					QueryUtil.executeMasterAction(getUserInfo(),
							ConstantsTx.SIGNOFF_TXCODE,
							QueryUtil.ACTION_APPEND,
							new String[] {
								getUserInfo().getUserID(),
								getUserInfo().getCashierCode(),
								CommonUtil.getComputerName()
							},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(final MessageQueue mQueue) {
							if (mQueue.success()) {
								if (getUserInfo().isCashier()) {
									Factory.getInstance().addSystemMessage("Cashier Signed off");
									getUserInfo().setCashierCode(EMPTY_VALUE);
								}
							}
						}
					});
				}
			}
		});

		Window.addCloseHandler(new CloseHandler<Window>() {
			@Override
			public void onClose(CloseEvent<Window> event) {
				// user sign off
				QueryUtil.executeMasterAction(getUserInfo(),
						ConstantsTx.SIGNOFF_TXCODE,
						QueryUtil.ACTION_APPEND,
						new String[] {
							getUserInfo().getUserID(),
							getUserInfo().getCashierCode(),
							CommonUtil.getComputerName()
						},
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(final MessageQueue mQueue) {
						if (mQueue.success()) {
							if (getUserInfo().isCashier()) {
								Factory.getInstance().addSystemMessage("Cashier Signed off");
								getUserInfo().setCashierCode(EMPTY_VALUE);
							}
						}
					}
				});

				// remove sso session
				QueryUtil.executeMasterAction(getUserInfo(),
						ConstantsTx.LOGON_SSO_TXCODE,
						QueryUtil.ACTION_DELETE,
						new String[] {
							getUserInfo().getUserID(),
							null,
							Factory.getInstance().getUserInfo().getSsoModuleCode(),
							Factory.getInstance().getUserInfo().getSsoSessionID()
						});
			}
		});
	}

	/***************************************************************************
	 * Native Method
	 **************************************************************************/

	static class ExportJsMethod implements Exportable {
		@Export("$wnd.GetUserID")
		public static String GetUserID() {
			return Factory.getInstance().getUserInfo().getUserID();
		}

		@Export("$wnd.GetCashierCode")
		public static String GetCashierCode() {
			return Factory.getInstance().getUserInfo().getCashierCode();
		}

		@Export("$wnd.GetComputerName")
		public static String GetComputerName() {
			return CommonUtil.getComputerName();
		}

		@Export("$wnd.GetSsoSessionId")
		public static String GetSsoSessionId() {
			return Factory.getInstance().getUserInfo().getSsoSessionID();
		}

		@Export("$wnd.GetSsoModuleCode")
		public static String GetSsoModuleCode() {
			return Factory.getInstance().getUserInfo().getSsoModuleCode();
		}
	}
}