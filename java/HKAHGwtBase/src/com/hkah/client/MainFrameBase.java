package com.hkah.client;

import java.util.HashMap;
import java.util.Stack;

import com.extjs.gxt.ui.client.Registry;
import com.extjs.gxt.ui.client.Style.LayoutRegion;
import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.util.KeyNav;
import com.extjs.gxt.ui.client.util.Margins;
import com.extjs.gxt.ui.client.widget.Viewport;
import com.extjs.gxt.ui.client.widget.layout.BorderLayout;
import com.extjs.gxt.ui.client.widget.layout.BorderLayoutData;
import com.extjs.gxt.ui.client.widget.menu.Menu;
import com.extjs.gxt.ui.client.widget.menu.MenuBar;
import com.extjs.gxt.ui.client.widget.menu.MenuBarItem;
import com.extjs.gxt.ui.client.widget.toolbar.FillToolItem;
import com.extjs.gxt.ui.client.widget.toolbar.ToolBar;
import com.google.gwt.dom.client.Element;
import com.google.gwt.event.dom.client.KeyCodes;
import com.google.gwt.user.client.Event;
import com.google.gwt.user.client.Event.NativePreviewEvent;
import com.google.gwt.user.client.Event.NativePreviewHandler;
import com.google.gwt.user.client.Timer;
import com.google.gwt.user.client.rpc.AsyncCallback;
import com.google.gwt.user.client.ui.RootPanel;
import com.hkah.client.common.Factory;
import com.hkah.client.config.MenuConfig;
import com.hkah.client.layout.ContinousProgressBar;
import com.hkah.client.layout.label.StatusBase;
import com.hkah.client.layout.menu.MenuItemBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.DefaultPanel;
import com.hkah.client.services.CommonUtilServiceAsync;
import com.hkah.client.tx.MasterPanelBase;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.PanelUtil;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.UserInfo;

/**
 * Entry point classes define <code>onModuleLoad()</code>.
 */
public abstract class MainFrameBase extends AbstractEntryPoint implements ConstantsVariable {
	private static final int DEFAULT_INIT_SYSCOUNT = 30000;
	private static final int ONE_SECOND = 1000;
	private static final String SYSTEM_OUT = "System timeout";

	protected String m_computerIP = null;
	protected String m_computerName = null;

	protected ToolBar m_status = null;
	protected StatusBase m_countDown;
	protected StatusBase m_time;
	protected StatusBase m_moduleName;
	protected ContinousProgressBar m_statusBar = null;
	protected StatusBase m_siteName = null;
	protected StatusBase m_remark = null;
	protected StatusBase m_version = null;

	protected BasePanel m_bodyPanel = null;
	protected Stack <BasePanel> stack = new Stack<BasePanel>();
	// per user store
	protected HashMap <String, Object> valueObjectPerUser = new HashMap<String, Object>();
	// per pass parameter from panel to panel
	protected HashMap <String, Object> valueObjectPerPanel = new HashMap<String, Object>();
	protected MenuBar menuBar = null;
	protected Timer countTask = null;
	protected Viewport viewport = null;

	private int sysCount = 0;

	@Override
	protected void loadModule() {
		initComponent();
		initKeyListener();
	}

	protected void initComponent() {
		viewport = new Viewport();
		final BorderLayout borderLayout = new BorderLayout();
		viewport.setLayout(borderLayout);

		BorderLayoutData menuBarToolBarLayoutData = new BorderLayoutData(LayoutRegion.NORTH, 25);
		menuBarToolBarLayoutData.setCollapsible(false);
		menuBarToolBarLayoutData.setSplit(false);
		viewport.add(getMenuBar(), menuBarToolBarLayoutData);

		BorderLayoutData mainContentsLayoutData = new BorderLayoutData(LayoutRegion.CENTER);
		mainContentsLayoutData.setCollapsible(false);
		mainContentsLayoutData.setFloatable(true);
		viewport.add(getBodyPanel(), mainContentsLayoutData);

		BorderLayoutData footerLayoutData = new BorderLayoutData(LayoutRegion.SOUTH, 28);
		footerLayoutData.setMargins(new Margins(0,5,0,0));
		viewport.add(getFooter(), footerLayoutData);

		RootPanel.get().add(viewport);
	}

	protected void initKeyListener() {
		/*
		 * http://pgt.de/2012/03/21/how-to-cancel-backspace-key-from-navigating-back/
		 */
		Event.addNativePreviewHandler(new NativePreviewHandler() {
			@Override
			public void onPreviewNativeEvent(NativePreviewEvent event) {
				if (event.getNativeEvent().getAltKey() &&
						event.getNativeEvent().getKeyCode() == KeyCodes.KEY_ENTER) {
					event.getNativeEvent().stopPropagation();
					event.getNativeEvent().preventDefault();
				}

				if (event.getNativeEvent().getKeyCode() == KeyCodes.KEY_BACKSPACE) {
					if (event.getNativeEvent().getEventTarget() != null) {
						Element as = Element.as(event.getNativeEvent().getEventTarget());
						if (as == RootPanel.getBodyElement()) {
							event.getNativeEvent().stopPropagation();
							event.getNativeEvent().preventDefault();
						}
					}
				}
			}
		});

		KeyNav<ComponentEvent> keyNav = new KeyNav<ComponentEvent>(viewport) {
			@Override
			public void handleEvent(ComponentEvent ce) {
				DefaultPanel dPanel = getAppletBodyPanel() instanceof DefaultPanel ? (DefaultPanel)getAppletBodyPanel() : null;
				if (ce.isControlKey() && ce.getKeyCode() == 90) {
					if (dPanel != null && dPanel instanceof MasterPanelBase) {
						((MasterPanelBase) getAppletBodyPanel()).exitPanel();
					} else {
						exitPanel();
					}
				} else if (!(ce.isAltKey() || ce.isRightClick() ||
						ce.isShiftKey() || ce.isSpecialKey())) {
					if (dPanel != null) {
						if (ce.getKeyCode() == 112) {
							((DefaultPanel) getAppletBodyPanel()).searchAction();
						} else if (ce.getKeyCode() == 113) {
							((DefaultPanel) getAppletBodyPanel()).appendAction();
						} else if (ce.getKeyCode() == 114) {
							((DefaultPanel) getAppletBodyPanel()).modifyAction();
						} else if (ce.getKeyCode() == 116) {
							ce.preventDefault();
							((DefaultPanel) getAppletBodyPanel()).deleteAction();
						} else if (ce.getKeyCode() == 117) {
							((DefaultPanel) getAppletBodyPanel()).saveAction();
						} else if (ce.getKeyCode() == 118) {
							((DefaultPanel) getAppletBodyPanel()).acceptAction();
						} else if (ce.getKeyCode() == 119) {
							((DefaultPanel) getAppletBodyPanel()).cancelAction();
						} else if (ce.getKeyCode() == 120) {
							((DefaultPanel) getAppletBodyPanel()).clearAction();
						} else if (ce.getKeyCode() == 122) {
							((DefaultPanel) getAppletBodyPanel()).refreshAction();
						} else if (ce.getKeyCode() == 123) {
							((DefaultPanel) getAppletBodyPanel()).printAction();
						}
					}
				} else if (ce.isAltKey() && ce.getKeyCode() >= 65 && ce.getKeyCode() <= 90) {
					altKeyHandle(dPanel, (char) ce.getKeyCode());
				} else if (ce.isAltKey() && ce.getKeyCode() == 13) {
					ce.stopEvent();
				} else if (ce.getKeyCode() == KeyCodes.KEY_BACKSPACE) {//cancel the backspace action
//					ce.preventDefault();
					ce.cancelBubble();
				}
			}
		};
	}

	protected void altKeyHandle(DefaultPanel dPanel, char keycode) {
		if (dPanel != null) {
			PanelUtil.getButton2Click(((DefaultPanel) getAppletBodyPanel()), keycode);
		}
	}

	public BasePanel getAppletBodyPanel() {
		if (getBodyPanel().getItemCount() > 0 && getBodyPanel().getItem(0) instanceof DefaultPanel) {
			return (DefaultPanel) getBodyPanel().getItem(0);
		} else {
			return getBodyPanel();
		}
	}

	public void modifyBodyPanel(BasePanel panel) {
		getBodyPanel().removeAllListeners();
		getBodyPanel().removeAll();

		if (panel != null) {
			getBodyPanel().add(panel);
		} else {
//			getToolBar().setEnabled(false);
		}
		getBodyPanel().focus();
		getBodyPanel().layout();
	}

	public void clearBodyPanel() {
		modifyBodyPanel(null);
	}

	public boolean hasBodyPanel() {
		return getBodyPanel().getItemCount() > 0;
	}

	public void setTitle(String subTitle) {
		if (subTitle != null) {
			StringBuilder sb = new StringBuilder();
			sb.append(getTitle());
			sb.append(" - [");
			sb.append(subTitle);
			sb.append("]");
			Factory.getInstance().setTitle(sb.toString());
		} else {
			Factory.getInstance().setTitle(getTitle());
		}
	}

	/***************************************************************************
	 * UserInfo
	 **************************************************************************/

	@Override
	public void initUserInfoFromDB() {
		// override for child class
		loadModule();
	}

	@Override
	public void initUserInfoFromConfig() {
		((CommonUtilServiceAsync) Registry.get(AbstractEntryPoint.COMMONUTIL_SERVICE)).getUserInfo(
				new AsyncCallback<UserInfo>() {
			@Override
			public void onSuccess(UserInfo userInfo) {
				getUserInfo().setSiteCode(userInfo.getSiteCode());
				getUserInfo().setSiteName(userInfo.getSiteName());
				getUserInfo().setDeptCode(userInfo.getDeptCode());
				getUserInfo().setUserID(userInfo.getUserID());
				getUserInfo().setUserName(userInfo.getUserName());

				initUserInfoFromDB();
			}

			@Override
			public void onFailure(Throwable caught) {
				getUserInfo().setSiteCode(null);
				getUserInfo().setSiteName(null);
				getUserInfo().setDeptCode(null);
				getUserInfo().setUserID(null);
				getUserInfo().setUserName(null);

				loginFailAlert();
			}
		});
	}

	/***************************************************************************
	 * create menu
	 **************************************************************************/

	public MenuBar getMenuBar() {
		if (menuBar == null) {
			menuBar = new MenuBar() {
				// support no sub menu item
				@Override
				public void onComponentEvent(ComponentEvent ce) {
					boolean isEventHandled = false;
					int type = ce.getEventTypeInt();
					MenuBarItem item = findItem(ce.getTarget());
					if (item != null) {
						Menu menu = item.getMenu();
						if (menu != null) {
							MenuItemBase menuItem = (MenuItemBase) menu.getItem(0);

							if (MenuConfig.NO_SUB_MENU_NAME.equals(menuItem.getHtml())) {
								switch (type) {
									case Event.ONCLICK:
										if (menuItem != null) {
											menuItem.fireEvent(Events.Open);
										}
										isEventHandled = true;
									break;
								}
							}
						}
					}
					if (!isEventHandled) {
						super.onComponentEvent(ce);
					}
				}

				@Override
				protected void expand(MenuBarItem item, boolean selectFirst) {
					super.expand(item, selectFirst);
					setCurrentMenuBarItem(item);
				}

				@Override
				protected void collapse(MenuBarItem item) {
					super.collapse(item);
					setCurrentMenuBarItem(null);
				}
			};
			menuBar.setBorders(true);
			menuBar.setStyleAttribute("borderTop", "none");
		}
		return menuBar;
	}

	protected void setCurrentMenuBarItem(MenuBarItem mbi) {}

	public void refreshMenuBarStatus() {
		getMenuBar().setEnabled(!hasBodyPanel() && sysCount > 0);
	}

	/***************************************************************************
	 * Helper method
	 **************************************************************************/

	public void showPanel(BasePanel panelClass) {
		showPanel(panelClass, true,true);
	}

	public void showPanel(BasePanel panelClass, boolean keepPanel) {
		Factory.getInstance().showPanel(getMainFrame(), panelClass, keepPanel, false);
	}

	public void showPanel(BasePanel panelClass, boolean keepPanel, boolean keepParam) {
		Factory.getInstance().showPanel(getMainFrame(), panelClass, keepPanel, keepParam);
	}

	public void exitPanel() {
		Factory.getInstance().showPanel(getMainFrame());
	}

	public native void loginFailAlert() /*-{
		alert('Login Fail.');
	}-*/;

	/***************************************************************************
	 * getter/setter method
	 **************************************************************************/

	/**
	 * @return the computerIP
	 */
	public String getComputerIP() {
		return m_computerIP;
	}

	/**
	 * @param computerIP
	 *            the computerIP to set
	 */
	public void setComputerIP(String computerIP) {
		m_computerIP = computerIP;
	}

	/**
	 * @return the computerName
	 */
	public String getComputerName() {
		return m_computerName;
	}

	/**
	 * @param computerName
	 * the computerName to set
	 */
	public void setComputerName(String computerName) {
		m_computerName = computerName;
	}

	/**
	 * @return the stack
	 */
	public Stack<BasePanel> getStack() {
		return stack;
	}

	/**
	 * @param stack the stack to set
	 */
	public void setStack(Stack<BasePanel> panel) {
		this.stack = panel;
	}

	/**
	 * @return the valueObject
	 */
	public HashMap<String, Object> getValueObjectPerUser() {
		return valueObjectPerUser;
	}

	/**
	 * @return the valueObject
	 */
	public HashMap<String, Object> getValueObjectPerPanel() {
		return valueObjectPerPanel;
	}

	public void setLoading(boolean load) {
		if (load) {
			if (m_statusBar != null) {
				m_statusBar.start();
			}
			Factory.getInstance().showWaitCursor();
		} else {
			if (m_statusBar != null) {
				m_statusBar.stop();
			}
			Factory.getInstance().showDefaultCursor();
		}
	}

	public int getSysTimeoutInit() {
		return DEFAULT_INIT_SYSCOUNT;
	}

	public void stopSysTimeoutCount() {
		getCountTask().cancel();
	}

	public void resetSysTimeout() {
		sysCount = getSysTimeoutInit();
		stopSysTimeoutCount();
		getCountTask().scheduleRepeating(ONE_SECOND);
	}

	// override to do action when system timeout
	protected void sysTimeoutExpired() {
		sysTimeoutExpired(SYSTEM_OUT);
	}

	protected void sysTimeoutExpired(final String message) {
		sysCount = 0;
		getToolBarCountDown().clearStatus(ZERO_VALUE);
		stopSysTimeoutCount();

		Factory.getInstance().showMask();
		Factory.getInstance().addInformationMessage(
				message, new Listener<MessageBoxEvent>() {
			@Override
			public void handleEvent(MessageBoxEvent be) {
				sysTimeoutExpiredPost();
			}
		});
	}

	protected void sysTimeoutExpiredPost() {
		Factory.getInstance().hideMask();
		resetSysTimeout();
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/**
	 * This method initializes bodyPanel
	 *
	 * @return BasePanel
	 */
	public BasePanel getBodyPanel() {
		if (m_bodyPanel == null) {
			m_bodyPanel = new BasePanel();
		}
		return m_bodyPanel;
	}

	public void setM_bodyPanelId(String id) {
		if (m_bodyPanel != null) {
			m_bodyPanel.setId(id);
		}
	}

	private Timer getCountTask() {
		if (countTask == null) {
			sysCount = getSysTimeoutInit();
			countTask = new Timer() {
				@Override
				public void run() {
					getToolBarCountDown().clearStatus(String.valueOf(sysCount--));
					if (sysCount < 0) {
						sysTimeoutExpired();
					}
				}
			};
			countTask.scheduleRepeating(ONE_SECOND);
		}
		return countTask;
	}

	protected ToolBar getFooter() {
		if (m_status == null) {
			getCountTask();

			Timer timer = new Timer() {
				String currentDateTime = null;

				@Override
				public void run() {
					currentDateTime = getServerDateTime();
					m_time.setText(currentDateTime);
					checkTime(currentDateTime);
				}
			};
			timer.scheduleRepeating(ONE_SECOND);

			m_status = new ToolBar();
			m_status.add(getToolBarTime());
			m_status.add(getToolBarCountDown());
			m_status.add(new FillToolItem());
			m_status.add(getToolBarSiteName());
			m_status.add(getToolBarRemark());
			m_status.add(getToolBarVersion());
			m_status.add(new FillToolItem());
			m_status.add(getToolBarModuleName());
			m_status.add(getToolBarStatusBar());
		}
		return m_status;
	}

	private StatusBase getToolBarTime() {
		if (m_time == null) {
			m_time = new StatusBase();
			m_time.setWidth(115);
			m_time.setBox(true);
			m_time.setText(DateTimeUtil.getCurrentDateTime());
		}
		return m_time;
	}

	private StatusBase getToolBarCountDown() {
		if (m_countDown == null) {
			m_countDown = new StatusBase();
			m_countDown.setWidth(45);
			m_countDown.setBox(true);
			m_countDown.setText(String.valueOf("32560"));
		}
		return m_countDown;
	}

	protected StatusBase getToolBarModuleName() {
		if (m_moduleName == null) {
			m_moduleName = new StatusBase();
			m_moduleName.setWidth(120);
			m_moduleName.setBox(true);
		}
		return m_moduleName;
	}

	private ContinousProgressBar getToolBarStatusBar() {
		if (m_statusBar == null) {
			m_statusBar = new ContinousProgressBar();
			m_statusBar.setWidth(100);
//			m_statusBar.setBox(true);
		}
		return m_statusBar;
	}

	protected StatusBase getToolBarSiteName() {
		if (m_siteName == null) {
			m_siteName = new StatusBase();
			m_siteName.setWidth(225);
			m_siteName.setBox(true);
		}
		return m_siteName;
	}

	protected StatusBase getToolBarRemark() {
		if (m_remark == null) {
			m_remark = new StatusBase();
			m_remark.setWidth(130);
			m_remark.setBox(true);
		}
		return m_remark;
	}

	protected StatusBase getToolBarVersion() {
		if (m_version == null) {
			m_version = new StatusBase();
			m_version.setWidth(100);
			m_version.setBox(true);
		}
		return m_version;
	}

	protected void checkTime(String datetime) {
		// check time schedule
	}

	protected abstract String getTitle();

	/***************************************************************************
	 * Server Date Time
	 **************************************************************************/

	public String getServerDateTime() {
		return DateTimeUtil.getCurrentDateTime();
	}

	public String getServerDate() {
		return DateTimeUtil.getCurrentDate();
	}

	public String getServerTime() {
		return DateTimeUtil.getCurrentTime();
	}
}