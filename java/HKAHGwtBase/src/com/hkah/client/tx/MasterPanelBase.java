/*
 * Created on 2011-04-06
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.tx;

import java.util.List;

import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.GridEvent;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.LayoutContainer;
import com.google.gwt.user.client.Timer;
import com.google.gwt.user.client.Window;
import com.hkah.client.common.Factory;
import com.hkah.client.event.CallbackListener;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.BrowserPanel;
import com.hkah.client.layout.panel.DefaultPanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.BufferedTableList;
import com.hkah.client.layout.table.GeneralGridCellRenderer;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.util.PanelUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsErrorMessage;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public abstract class MasterPanelBase extends DefaultPanel implements ConstantsVariable, ConstantsErrorMessage {

//	protected KeyNavListener enterSendKeyListener = null;
//	protected KeyNavListener enterSaveKeyListener = null;

	protected final static String SPLIT_LAYOUT = "split";
	protected final static String FLAT_LAYOUT = "flat";

	protected final static String ACTION_ACCEPT = "AcceptAction";
	protected final static String ACTION_REFRESH = "RefreshAction";
	protected final static String ACTION_SAVE = "SaveAction";

	// Split pane layout constants
	private final static int SCROLL_PANEL_SEARCH_HEIGHT = 100;
	private final static int SCROLL_PANEL_LIST_WIDTH_FULL = 980;
	private final static int SCROLL_PANEL_LIST_WIDTH = 400;

	protected final static String SEARCH_MODE = "SearchMode";
	protected final static String ACCEPT_MODE = "AcceptMode";
	protected final static String SKIP_CLEAR_MODE = "SkipClearMode";
	protected final static String ALLOW_EDIT_MODE = "AllowEditMode";
	protected final static String PRINT_MODE = "PrintMode";

	private String actionType = null;	// only for append/update/delete
	private boolean recordFound = false;

	private TableList listTable = null;
	private JScrollPane jScrollPane = null;
//	private LayoutContainer jSplitPane = null;

	// indicate the left-right-side show status
	private final static String LEFT_ALIGN_STATUS = "Left";
	private final static String RIGHT_ALIGN_STATUS = "Right";
	private String alignStatus = null;
	private String layoutMode = SPLIT_LAYOUT;

	private boolean requiredScroll = false;
	private boolean fullEntry = false;
	private boolean noGetDB = false;
	private boolean noListDB = false;
	private boolean hasLeftPanel = true;
	private boolean newRefresh = false;
	private boolean runOnce = false;
	private boolean forceExit = false;
	private Timer timer = null;
	private boolean  isShowSort = false;
	private boolean isNotShowMenu = true;
	private boolean showMsgAfterSearch = false;

//	private int editRow = -1;

	private final static String BLANK_TARGET = "_blank";

	public MasterPanelBase() {
		super();
	}

	public MasterPanelBase(boolean hasLeftPanel) {
		super();
		setHasLeftPanel(hasLeftPanel);
	}

	public MasterPanelBase(String layoutMode) {
		super();
		this.layoutMode = layoutMode;
	}

	public void rePostAction() {
		// refresh search
		searchAction(false);
	}

	/**
	 * do the security checking before the panel initial
	 */
	public boolean preAction() {
		// hide browse panel
		setLeftAlignPanel();//default
		if (!isHasLeftPanel()) {
			setRightAlignPanel();
		}
		// call child init function
		if (!init()) {
			return false;
		}
		return super.preAction();
	}

	public void hideAction() {
		super.hideAction();
		cancelTimer();
	}

	/**
	 * initial the screen layout and listener
	 */
	public void postAction() {
		// for parent class call
		super.postAction();

		// only execute once
		if (!runOnce) {
			// set all key listener related
			initialize();			// initial table
			initializeListeners();	// initial listener
			enableButton();			// initial action button

			// attach key listener to left panel
			if (isHasLeftPanel()) {
				PanelUtil.initUpDownEnterKeyListener(getLeftPanel(), getSearchButton());
//				PanelUtil.addLastFieldKeyListener(getLeftPanel(), getSearchButton(), enterSendKeyListener);
			}
			runOnce = true;
		}

		// clean up previous data if any
		getListTable().removeAllRow();
		resetAllFields();

		// don't call db in get action
		setNoGetDB(true);

		// for child class call
		initAfterReady();

		// call clean up
		clearPostAction();
	}

	public void performEscAction(final CallbackListener callbackListener) {
		if (!isForceExit() && (isAppend() || isModify() || isDelete())) {
			MessageBoxBase.confirm("Message", "Unsaved data present! Close anyway?",
					new Listener<MessageBoxEvent>() {
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						cancelTimer();

						// do pro exit action
						proExitPanel();

						// reset action type
						resetActionType();

						if (callbackListener != null) {
							callbackListener.handleRetBool(true, null, null);
						} else {
							// set force exit and exit panel
							exitPanel(true);
						}
					} else {
						if (callbackListener != null) {
							callbackListener.handleRetBool(false, null, null);
						}
					}
				}
			});
		} else {
			cancelTimer();

			// do pro exit action
			proExitPanel();

			//removeParameter();
			if (callbackListener != null) {
				callbackListener.handleRetBool(true, null, null);
			}
		}
	}

	protected void defaultFocus() {
		// call focus component
		if (getDefaultFocusComponent() != null) {
			getDefaultFocusComponent().focus();
		} else if (getSearchButton().isEnabled()) {
			getSearchButton().focus();
		}
	}

	/***************************************************************************
	 * Store Value for Panel to Panel
	 **************************************************************************/

	public void setParameter(String key, String value) {
		Factory.getInstance().getValueObjectPerPanel().put(key, value);
	}

	public void resetParameter(String key) {
		Factory.getInstance().getValueObjectPerPanel().put(key, EMPTY_VALUE);
	}

	public void removeParameter(String key) {
		Factory.getInstance().getValueObjectPerPanel().remove(key);
	}

	public void setParameter(String key, List <String[]> list) {
		Factory.getInstance().getValueObjectPerPanel().put(key, list);
	}

	public String getParameter(String key) {
		return (String) Factory.getInstance().getValueObjectPerPanel().get(key);
	}

	/***************************************************************************
	 * Inner Helper Methods
	 **************************************************************************/

	protected boolean isRequiredScroll() {
		return requiredScroll;
	}

	protected void setRequiredScroll(boolean requiredScroll) {
		this.requiredScroll = requiredScroll;
	}

	protected void emptyAllRightPanelFields() {
		PanelUtil.resetAllFields(getRightPanel());
	}

	@SuppressWarnings("unchecked")
	public List <String[]> getListParameter(String key) {
		return  (List<String[]>) Factory.getInstance().getValueObjectPerPanel().get(key);
	}

	public void removeParameter() {
		Factory.getInstance().getValueObjectPerPanel().clear();
	}

	protected void showPanel(BasePanel panelClass) {
		showPanel(panelClass, true,true);
	}

	protected void showPanel(BasePanel panelClass, boolean keepPanel) {
		getMainFrame().showPanel(panelClass, keepPanel, false);
	}


	protected void showPanel(BasePanel panelClass, boolean keepPanel, boolean keepParam) {
		getMainFrame().showPanel(panelClass, keepPanel, keepParam);
	}

	public void exitPanel() {
		exitPanel(false);
	}

	protected void exitPanel(boolean forceExit) {
		preExitPanel();
		if (forceExit) setForceExit(true);
		getMainFrame().exitPanel();
	}

	public void disableCloseButton() {
		getCloseButton().setEnabled(false);
	}

	protected void resetCurrentFields() {
		if (isLeftAlignPanel()) {
			PanelUtil.resetAllFields(getLeftPanel());
		} else if (isRightAlignPanel()) {
			PanelUtil.resetAllFields(getRightPanel());
		} else {
			PanelUtil.resetAllFields(getLeftPanel());
			PanelUtil.resetAllFields(getRightPanel());
		}
	}

	protected void resetAllFields() {
		PanelUtil.resetAllFields(getLeftPanel());
		PanelUtil.resetAllFields(getRightPanel());
	}

//  **********************************************************************
//	************ Please don't get current date time from here ************
//  **********************************************************************
//  ************ Please use getMainFrame().getServerDate()    ************
//  ************ to get database date                         ************
//  **********************************************************************
//	protected String getCurDate() {
//		return DateTimeUtil.getCurrentDate();
//	}
//
//	protected String getCurDateTime() {
//		return DateTimeUtil.getCurrentDateTimeWithoutSecond();
//	}
//
//	protected String getCurDateStartTime(String datetime) {
//		String sdt=datetime;
//		return sdt.substring(0,10) + " 00:00";
//	}
//
//	protected String getCurDateEndTime(String datetime) {
//		String edt=datetime;
//		return  edt.substring(0,10) + " 23:59";
//	}

	protected boolean isForceExit() {
		return forceExit;
	}

	protected void setForceExit(boolean exit) {
		forceExit = exit;
	}

	/***************************************************************************
	 * Methods for child class
	 **************************************************************************/

	/**
	 * set the search criteria height
	 */
	protected int getSearchHeight() {
		return SCROLL_PANEL_SEARCH_HEIGHT;
	}

	/**
	 * set the table width
	 */
	protected int getListWidth() {
		if (isFullEntry()) {
			return SCROLL_PANEL_LIST_WIDTH_FULL;
		} else {
			return SCROLL_PANEL_LIST_WIDTH;
		}
	}

	/**
	 * @return the fullEntry
	 */
	protected boolean isFullEntry() {
		return fullEntry;
	}

	/**
	 * @param fullEntry the fullEntry to set
	 */
	protected void setFullEntry(boolean fullEntry) {
		this.fullEntry = fullEntry;
	}

	/**
	 * @return the noGetDB
	 */
	protected boolean isNoGetDB() {
		return noGetDB;
	}

	/**
	 * @param noGetDB the noGetDB to set
	 */
	protected void setNoGetDB(boolean noGetDB) {
		this.noGetDB = noGetDB;
	}


	/**
	 * @return the noListDB
	 */
	protected boolean isNoListDB() {
		return noListDB;
	}

	/**
	 * @param noListDB the noListDB to set
	 */
	protected void setNoListDB(boolean noListDB) {
		this.noListDB = noListDB;
	}

	protected void setPrintMode() {
		enableButton(PRINT_MODE);
	}

	/**
	 * @return the noNewRefresh
	 */
	protected boolean isNewRefresh() {
		return newRefresh;
	}

	/**
	 * @param newRefresh the newRefresh to set
	 */
	protected void setNewRefresh(boolean newRefresh) {
		this.newRefresh = newRefresh;
	}

	public void cleanTable() {
		getListTable().removeAllRow();
	}

	protected boolean triggerSearchField() {
		return false;
	}

	protected boolean isAddNumberingColumn() {
		return false;
	}

	protected GeneralGridCellRenderer[] getActionCellRenderer() {
		return null;
	};

	protected String getTableStyleName() {
		return "master-panel-table-list";
	}

	/**
	 * @return the isTableViewOnly
	 */
	public boolean isTableViewOnly() {
		return true;
	}

	public void setNotShowSort(boolean isShowSrt) {
		isShowSort = isShowSrt;
	}

	public boolean getShowSort() {
		return isShowSort;
	}

	public boolean getNotShowMenu() {
		return isNotShowMenu;
	}

	public void setNotShowMenu(boolean isShowMenu) {
		this.isNotShowMenu = isNotShowMenu;
	}

	/***************************************************************************
	 * Window Methods
	 **************************************************************************/

	public void openNewWindow(String url) {
		openNewWindow(BLANK_TARGET, url, null, false, true);
	}

	public void openNewWindow(String target, String url) {
		openNewWindow(target, url, null, false, true);
	}

	public void openNewWindow(String target, String url, String feature) {
		openNewWindow(target, url, feature, false, true);
	}
	
	public void openNewWindow(String target, String url, String feature, boolean embeded) {
		openNewWindow(target, url, feature, embeded, true);
	}

	public void openNewWindow(String target, String url, String feature, boolean embeded, boolean keepPanel) {
		if (embeded) {
			BrowserPanel browserPanel = new BrowserPanel(); 
			Factory.getInstance().showPanel(browserPanel, keepPanel);
			browserPanel.setBrowserUrl(url);
		} else {
			Window.open(url, target, feature);
		}
	}
	
	/***************************************************************************
	 * Timer Methods
	 **************************************************************************/

	public Timer getTimer() {
		return this.timer;
	}

	public void setTimer(Timer timer) {
		this.timer = timer;
	}

	public void cancelTimer() {
		if (getTimer() != null) {
			getTimer().cancel();
		}
	}

	public void resetTimer() {
	}

	/***************************************************************************
	 * Implement Abstract Methods
	 **************************************************************************/

	public void searchAction() {
		if (!triggerSearchField()) {
			searchAction(true);
		}
	}

	public void searchAction(boolean showMessage) {
		performList(showMessage);
		resetActionType();
		if (hasLeftPanel) {
			// focus on search panel
//			PanelUtil.setFirstComponentFocus(getLeftPanel());
		} else {
//			PanelUtil.setFirstComponentFocus(getRightPanel());
		}

		resetTimer();
		// call after all action done
		searchPostAction();
	}

	protected void searchPostAction() {
		// for override if necessary
		defaultFocus();
	}

	/**
	 * action when click append button
	 */
	public void appendAction() {
		appendAction(false);
	}

	public void appendAction(boolean force) {
		if (getAppendButton().isEnabled() || force) {
			setActionType(QueryUtil.ACTION_APPEND);

			enableButton();
			appendDisabledFields();

			// call after all action done
			appendPostAction();
		}
	}

	/**
	 * action when click modify button
	 */
	public void modifyAction() {
		modifyAction(false);
	}

	public void modifyAction(boolean force) {
		if (getModifyButton().isEnabled() || force) {
			// let action type set before call performGet()
			setActionType(QueryUtil.ACTION_MODIFY);
			getListTable().setEditRow();
			enableButton();
			modifyDisabledFields();

			// call after all action done
			modifyPostAction();
		}
	}

	/**
	 * action when click delete button
	 */
	public void deleteAction() {
		deleteAction(false);
	}

	public void deleteAction(boolean force) {
		if (getDeleteButton().isEnabled() || force) {
			// let action type set before call performGet()
			setActionType(QueryUtil.ACTION_DELETE);

			enableButton();
			deleteDisabledFields();

			// call after all action done
			deletePostAction();
		}
	}

	/**
	 * action when click save button
	 */
	public void saveAction() {
		if (getSaveButton().isEnabled()) {
			performAction(ACTION_SAVE);
		}
	}

	protected void savePostAction() {
		// for override if necessary
	}

	/**
	 * action when click confirm button
	 */
	public void acceptAction() {
		if (getAcceptButton().isEnabled()) {
			if ((isAppend() || isModify() || isDelete())) {
				performAction(ACTION_ACCEPT);
			} else {
				performGet(ACTION_ACCEPT);
			}
		}
	}

	protected void acceptPostAction() {
		// for override if necessary
	}

	/**
	 * action when click cancel button
	 */
	public void cancelAction() {
		if (getCancelButton().isEnabled() && getActionType() != null) {
			MessageBoxBase.confirm("Message", "Are you sure to cancel all unsaved operations?",
					new Listener<MessageBoxEvent>() {
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						// do action after click yes
						cancelYesAction();
					}
				}
			});
		} else {
			// do action after click yes
			cancelYesAction();
		}
	}

	protected void cancelYesAction() {
		if (getActionType() != null) {
			if (isAppend()) {
				resetActionType();
				resetAllFields();
			} else {
				setActionType(QueryUtil.ACTION_FETCH);
			}
		}
		enableButton();
		confirmCancelButtonClicked();

		// call after all action done
		cancelPostAction();
	}

	protected void cancelPostAction() {
		// for override if necessary
		defaultFocus();
	}

	/**
	 * action when click clear button
	 */
	public void clearAction() {
		if (getClearButton().isEnabled()) {
			resetCurrentFields();

			// clear record found
			setRecordFound(false);

			enableButton();

			// call after all action done
			clearPostAction();

			// call focus component
			defaultFocus();
		}
	}

	protected void clearPostAction() {
		// for override if necessary
	}

	/**
	 * action when click refresh button
	 */
	public void refreshAction() {
		if (getRefreshButton().isEnabled()) {
			if (getActionType() == null) {
				searchAction(false);
			} else {
				performGet(ACTION_REFRESH);
			}
		}
	}

	/**
	 * action when click pint button
	 */
	public void printAction() {
		if (getPrintButton().isEnabled()) {
		}
	}

	public void initTimer() {}

	/**
	 * Constant in QueryUtil
	 * - ACTION_APPEND = ADD
	 * - ACTION_MODIFY = MOD
	 * - ACTION_DELETE = DEL
	 * - ACTION_BROWSE = LIS
	 * - ACTION_FETCH = GET
	 * @return the actionType
	 */
	protected String getActionType() {
		return actionType;
	}

	/**
	 * @param actionType the actionType to set
	 */
	protected void setActionType(String actionType) {
		this.actionType = actionType;
	}

	protected void resetActionType() {
		setActionType(null);
	}

	public boolean isAppend() {
		return QueryUtil.ACTION_APPEND.equals(getActionType());
	}

	public boolean isModify() {
		return QueryUtil.ACTION_MODIFY.equals(getActionType());
	}

	public boolean isDelete() {
		return QueryUtil.ACTION_DELETE.equals(getActionType());
	}

	public boolean isFetch() {
		return QueryUtil.ACTION_FETCH.equals(getActionType());
	}

	/**
	 * @return the recordFound
	 */
	public boolean isRecordFound() {
		return recordFound;
	}

	/**
	 * @param recordFound the recordFound to set
	 * to decide whether edit/delete button enable or not
	 */
	public void setRecordFound(boolean recordFound) {
		this.recordFound = recordFound;
	}

	/***************************************************************************
	 * ButtonBase Action Methods
	 **************************************************************************/

	protected void enableButton() {
		enableButton(null);
	}

	protected void enableButton(String mode) {
		// disable all button
		disableButton();

		// set tip bar as view status
//		getUserInfo().getApplet().setViewModel();

		// set button focus color
		if (PRINT_MODE.equals(mode)) {
			getSearchButton().setEnabled(false);
			getAppendButton().setEnabled(false);
			getModifyButton().setEnabled(false);
			getDeleteButton().setEnabled(false);
			getSaveButton().setEnabled(false);
			getAcceptButton().setEnabled(false);
			getCancelButton().setEnabled(false);
			getClearButton().setEnabled(false);
			getRefreshButton().setEnabled(false);
			getPrintButton().setEnabled(true);
		} else if (getActionType() != null && (isAppend() || isModify() || isDelete())) {
			getSearchButton().setEnabled(false);
			getAppendButton().setFocus(isAppend());
			getModifyButton().setFocus(isModify());
			getDeleteButton().setFocus(isDelete());
			getSaveButton().setEnabled(!isDelete());
			getAcceptButton().setEnabled(isDelete());
			getCancelButton().setEnabled(true);
			getClearButton().setEnabled(isModify());

			// disable browse panel
			setAllLeftFieldsEnabled(false);
			if (isAppend()) {
				// empty entry panel content
				emptyAllRightPanelFields();
			}
			// enable all right panel field
			setAllRightFieldsEnabled(isAppend() || isModify());
//			if (isAppend()) {
//				appendDisabledFields();
//			} else if (isModify()) {
//				modifyDisabledFields();
//			} else {
				// set field key listener
//				PanelUtil.initUpDownEnterKeyListener(getRightPanel());
//				PanelUtil.addLastFieldKeyListener(getRightPanel(), enterSaveKeyListener);

				// set tip bar as edit status
//				getUserInfo().getApplet().setEditModel();
//			}
		} else if (ALLOW_EDIT_MODE.equals(mode) || (getActionType() != null && isFetch())) {
			getSearchButton().setEnabled(isSearchButtonEnabled());
			getAppendButton().setEnabled(true);
			getModifyButton().setEnabled(isModifyButtonEnabled() && isRecordFound());
			getDeleteButton().setEnabled(isDeleteButtonEnabled() && isRecordFound());
			getClearButton().setEnabled(true);

			// disable browse panel
			setAllLeftFieldsEnabled(false);
			// enable all right panel field
			setAllRightFieldsEnabled(false);
		} else if (ACCEPT_MODE.equals(mode)) {
			getAppendButton().setEnabled(true);
		} else {
			// Initial Status or search model
			getSearchButton().setEnabled(isSearchButtonEnabled());
			getAppendButton().setEnabled(isAppendButtonEnabled() && (getAlignStatus() == null || isRightAlignPanel()));
			getAcceptButton().setEnabled(getAlignStatus() == null || isLeftAlignPanel());
			getClearButton().setEnabled(getAlignStatus() == null || isLeftAlignPanel());
			getRefreshButton().setEnabled(getAlignStatus() == null || isLeftAlignPanel());

//			if (!isNoGetDB() && !SKIP_CLEAR_MODE.equals(mode)) {
//				// empty entry panel content
//				emptyAllRightPanelFields();
//			}

			// enable browse panel
			setAllLeftFieldsEnabled(true);
			// disable and clear all right panel field
			setAllRightFieldsEnabled(false);
		}

		// hide search panel
		if (hasLeftPanel && isFullEntry()) {
			if (getActionType() == null) {
				setLeftAlignPanel();
			} else {
				setRightAlignPanel();
			}
		}
	}

	/***************************************************************************
	 * List Records Methods
	 **************************************************************************/

	protected void performList() {
		performList(true);
	}

	protected void performListFieldsEnable() {
		// set enable left fields
		setAllLeftFieldsEnabled(true);
		if (isAppend()) {
			setAllRightFieldsEnabled(true);
			appendDisabledFields();
		} else if (isModify()) {
			setAllRightFieldsEnabled(true);
			modifyDisabledFields();
		} else if (isDelete()) {
			setAllRightFieldsEnabled(true);
			deleteDisabledFields();
		}
	}

	protected void performList(final boolean showMessage) {
		if (isNoListDB()) {
			// skip list
			return;
		}
		if (browseValidation()) {
			// set disable fields
			this.showMsgAfterSearch = showMessage;
			setAllLeftFieldsEnabled(false);
			setAllRightFieldsEnabled(false);

			// Ensure Cannot Accept during Search action
//			final boolean acceptBtnStatus = getAcceptButton().isEnabled();
			getAcceptButton().setEnabled(false);

			// set loading flag true
			getMainFrame().setLoading(true);

			QueryUtil.executeMasterBrowse(
					getUserInfo(), getTxCode(), getBrowseInputParameters(),
					Factory.getInstance().getPerformListCallBack(this));
		}
	}

	public void performListCallBackPost(MessageQueue mQueue) {
		if (mQueue != null) {
			performListSetListTable(mQueue);
			if (showMsgAfterSearch) {
				if (mQueue.success()) {
//					Factory.getInstance().addSystemMessage("Search Completed.");
				} else {
					performListNoRecordPostMsg(mQueue);
				}
			}
		} else {
			//Factory.getInstance().addErrorMessage("Fail to connect server");
		}

		performListCallBackAfterPost();
	}

	public void performListCallBackAfterPost() {
		performListFieldsEnable();

		// enable button in search mode
		enableButton(SEARCH_MODE);

		performListPost();

		focusComponentAfterSearch();

		loadRelatedTable();
	}

	protected void focusComponentAfterSearch() {
		// call focus component
		if (getCurrentListTable().getRowCount() > 0) {
			if (getCurrentListTable().getSelectedRow() < 0) {
				if (getColumnKey() < 0) {
					getCurrentListTable().setSelectRow(0);
				}
			}
			getCurrentListTable().focus();
		} else {
			defaultFocus();
		}
	}

	// for custom override
	protected void performListNoRecordPostMsg(MessageQueue mQueue) {
		Factory.getInstance().addErrorMessage(mQueue, null, getDefaultFocusComponent());
		/*
		new Listener<MessageBoxEvent>() {
			@Override
			public void handleEvent(MessageBoxEvent be) {
				defaultFocus();
			}
		});*/
	}

	protected void performListSetListTable(MessageQueue mQueue) {
		// set table
		getCurrentListTable().setListTableContent(mQueue);

		// handle data one by one if necessary
		if (getCurrentListTable().getRowCount() > 0) {
			getBrowseOutputValues(mQueue.getContentField());
		}
	}

	protected TableList getCurrentListTable() {
		// for override to another table
		return getListTable();
	}

	protected void performListPost() {
		// for child class call
	}

	protected void preExitPanel() {
		// for child class call before exit
	}

	protected void proExitPanel() {
		// for child class call after exit
	}

	protected void loadRelatedTable() {
		// for child class call
	}

	/***************************************************************************
	 * Get Record Methods
	 **************************************************************************/

	protected String[] getListSelectedRow() {
		return getListTable().getSelectedRowContent();
	}

	private void performGet(final String actionType) {
		if (!isRightAlignPanel() && getListTable().getSelectedRow() < 0) {
			Factory.getInstance().addErrorMessage("No Record Selected.");
			performGetPreReady(actionType, false);
		} else if (isNoGetDB() && getListTable().getSelectedRow() >= 0) {
			getFetchOutputValues(getListTable().getSelectedRowContent());
//			Factory.getInstance().addSystemMessage("Get Record Completed.");
			performGetPreReady(actionType, true);
		} else {
			// set loading flag true
			getMainFrame().setLoading(true);
			QueryUtil.executeMasterFetch(getUserInfo(), getTxCode(), getFetchInputParameters(), new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						getFetchOutputValues(mQueue.getContentField());
//						Factory.getInstance().addSystemMessage("Get Record Completed.");
						performGetPreReady(actionType, true);
					} else {
						Factory.getInstance().addErrorMessage(mQueue);
						performGetPreReady(actionType, false);
					}
				}

				@Override
				public void onComplete() {
					super.onComplete();

					// set loading flag false
					getMainFrame().setLoading(false);
				}
			});
		}
	}

	private void performGetPreReady(String actionType, boolean isGetReady) {
		// indicate whether any record is fetched
		setRecordFound(isGetReady);

		// go to next function call
		performGetReady(actionType, isGetReady);
	}

	private void performGetReady(String actionType, boolean isGetReady) {
		if (isGetReady) {
			if (ACTION_ACCEPT.equals(actionType)) {
				setActionType(QueryUtil.ACTION_FETCH);

				enableButton();
				deleteDisabledFields();

				// call after all action done
				acceptPostAction();
			} else if (ACTION_REFRESH.equals(actionType)) {
				setActionType(QueryUtil.ACTION_FETCH);

				enableButton();
				deleteDisabledFields();
			}
		}
	}

	/***************************************************************************
	 * Perform Actions Methods
	 **************************************************************************/

	protected void performAction(String actionType) {
		actionValidation(actionType);
	}

	protected void actionValidationReady(final String actionType, boolean isValidationReady) {
		// set action type
//		setActionType(actionType);

		if (isValidationReady) {
			// set loading flag true
			getMainFrame().setLoading(true);
			QueryUtil.executeMasterAction(getUserInfo(), getTxCode(), getActionType(), getActionInputParamaters(),
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
//						Factory.getInstance().addSystemMessage("Action Completed.");

						actionValidationReadyHelper(actionType, mQueue);

						// reset action type
						resetActionType();

						// call post ready
						actionValidationPostReady(actionType);
					} else {
						Factory.getInstance().addErrorMessage(mQueue);
						if (mQueue.getContentField().length >= 2) {
							String msg = mQueue.getContentField()[1];
							if (msg != null && !"".equals(msg.trim())) {
								Factory.getInstance().addSystemMessage(msg);
							}
						}
					}
				}

				@Override
				public void onComplete() {
					super.onComplete();

					// set loading flag false
					getMainFrame().setLoading(false);
				}
			});
		}
	}

	protected void actionValidationReadyHelper(String actionType, MessageQueue mQueue) {
		if (isAppend()) {
			getNewOutputValue(mQueue.getReturnCode());
		}
		if (isDelete()) {
			clearAction();
		}
		if ((isNewRefresh() && isAppend())
			|| isModify()) {
			// retrieve from database again
			performGet(null);
		} else if (!isRightAlignPanel()) {
			performList(false);
		}
	}

	protected void actionValidationPostReady(String actionType) {
		enableButton();
		confirmCancelButtonClicked();

		// call after all action done
		if (ACTION_SAVE.equals(actionType)) {
			savePostAction();
		} else if (ACTION_ACCEPT.equals(actionType)) {
			acceptPostAction();
		}
	}

	/***************************************************************************
	 * Left Panel Methods
	 **************************************************************************/

	protected void setAllLeftFieldsEnabled(boolean enable) {
		if (getLeftPanel() != null) {
			// reset field status
			PanelUtil.resetAllFieldsStatus(getLeftPanel());
			// disable field
			PanelUtil.setAllFieldsEditable(getLeftPanel(), enable);
//			this.setWorking(!enable);
		}
	}

	/**
	 * @return hasLeftPanel
	 */
	private boolean isHasLeftPanel() {
		return hasLeftPanel;
	}

	/**
	 * @param newRefresh the newRefresh to set
	 */
	private void setHasLeftPanel(boolean hasLeftPanel) {
		this.hasLeftPanel = hasLeftPanel;
	}

	/***************************************************************************
	 * Right Panel Methods
	 **************************************************************************/

	protected void setAllRightFieldsEnabled(boolean enable) {
		if (getRightPanel() != null) {
			// reset field status
			PanelUtil.resetAllFieldsStatus(getRightPanel());
			// disable field
			PanelUtil.setAllFieldsEditable(getRightPanel(), enable);
//			this.setWorking(!enable);
		}
	}

	/***************************************************************************
	 * General Panel Methods
	 **************************************************************************/

	public boolean isLeftAlignPanel() {
		return LEFT_ALIGN_STATUS.equals(getAlignStatus());
	}

	public boolean isRightAlignPanel() {
		return RIGHT_ALIGN_STATUS.equals(getAlignStatus());
	}

	private String getAlignStatus() {
		return alignStatus;
	}

	/**
	 * shift the split panel to left side
	 */
	protected void setLeftAlignPanel() {
		if (getLeftPanel() != null) getLeftPanel().show();
		if (getJScrollPane() != null) getJScrollPane().show();
		if (getRightPanel() != null) getRightPanel().hide();
		setAlignStatus(LEFT_ALIGN_STATUS);
	}

	/**
	 * shift the split panel to right side
	 */
	protected void setRightAlignPanel() {
		if (getLeftPanel() != null) getLeftPanel().hide();
		if (getJScrollPane() != null) getJScrollPane().hide();
		if (getRightPanel() != null) getRightPanel().show();
		setAlignStatus(RIGHT_ALIGN_STATUS);
	}

	private void setAlignStatus(String alignStatus) {
		this.alignStatus = alignStatus;
	}

	/***************************************************************************
	 * Initial Methods
	 **************************************************************************/

	/**
	 * This method initializes this
	 *
	 * @return void
	 */
	protected void initialize() {
		if (FLAT_LAYOUT.equals(layoutMode)) {
			add(getBodyPanel());   // for manitenancePanel
		} else {
			try {
				// only add column if column name is not empty
				//this.getListTable().addColumn(getColumnNames(), getColumnWidths());
				//this.setRightPanel(getRightPanel());

				if (getLeftPanel() != null) add(getLeftPanel());
//				add(getListTable());
				if (getRightPanel() != null) add(getRightPanel());

				if (LEFT_ALIGN_STATUS.equals(getAlignStatus())) {
					setLeftAlignPanel();
				} else {
					setRightAlignPanel();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	private void initializeListeners() {
//		enterSendKeyListener = new KeyNavListener() {
//			public void handleEvent(ComponentEvent e) {
//				EventType type = e.getType();
//				switch (type.getEventCode()) {
//					case KeyCodes.KEY_ENTER:
//						searchAction();
//						break;
//				}
//			}
//		};

//		enterSaveKeyListener = new KeyNavListener() {
//			public void handleEvent(ComponentEvent e) {
//				EventType type = e.getType();
//				switch (type.getEventCode()) {
//					case KeyCodes.KEY_ENTER:
//						saveAction();
//				}
//			}
//		};
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/**
	 * This method initializes jScrollPane
	 *
	 * @return JScrollPane
	 */
	protected JScrollPane getJScrollPane() {
		if (jScrollPane == null) {
			jScrollPane = new JScrollPane();
			jScrollPane.setViewportView(getListTable());
		}
		return jScrollPane;
	}

	protected LayoutContainer getBodyPanel() {
		return null;
	}

	public int getColumnKey() {
		return -1;
	}

//	protected JSplitPane getjSplitPane() {
//		if (jSplitPane==null)
//			jSplitPane=new JSplitPane();
//		return jSplitPane;
//	}

	/**
	 * This method initializes listTable
	 *
	 * @return com.hkah.layout.ListTable
	 */
	public TableList getListTable() {
		if (listTable == null) {
			if (isTableViewOnly()) {
				listTable = new BufferedTableList(getColumnNames(), getColumnWidths(),
													isAddNumberingColumn(),getShowSort(),getNotShowMenu(),
													getActionCellRenderer(),
													getColumnKey()) {
					@Override
					public void onSelectionChanged() {
						if (isAppend() || isModify()) {
							getView().focusRow(getEditRow());
							getSelectionModel().select(getEditRow(), false);
							if (getListSelectedRow() != null) {
								getFetchOutputValues(getListSelectedRow());
							}
	//					} else if (isNoGetDB()) {
						} else if (!isAppend() && getListTable().getSelectedRow() > -1) {
							getFetchOutputValues(getListSelectedRow());
						}
					};

					@Override
					public void postSaveTable(boolean success, Integer rtnCode, String rtnMsg) {
						listTablePostSaveTable(success);
					}

					@Override
					public void setListTableContentPrev() {
						listTableContentPrev();
					}

					@Override
					public void setListTableContentPost() {
						listTableContentPost();
					}

					@Override
					public boolean getSelectOnList() {
						return getListTableSelectOnList();
					}
					@Override
					public boolean[] getMenuDefault1Listing() {
						return getMenuDefault1List();
					}
				};
			} else {
				listTable = new TableList(getColumnNames(), getColumnWidths(), getActionCellRenderer()) {
					@Override
					public void onSelectionChanged() {
						if (isAppend() || isModify()) {
							getView().focusRow(getEditRow());
							getSelectionModel().select(getEditRow(), false);
							if (getListSelectedRow() != null) {
								getFetchOutputValues(getListSelectedRow());
							}
//						} else if (isNoGetDB()) {
						} else if (!isAppend() && getListTable().getSelectedRow() > -1) {
							getFetchOutputValues(getListSelectedRow());
						}
					};

					@Override
					public void postSaveTable(boolean success, Integer rtnCode, String rtnMsg) {
						listTablePostSaveTable(success);
					}

					@Override
					public void setListTableContentPrev() {
						listTableContentPrev();
					}

					@Override
					public void setListTableContentPost() {
						listTableContentPost();
					}
				};
			}
			listTable.addStyleName(getTableStyleName());

			listTable.addListener(Events.RowDoubleClick, new Listener<GridEvent>() {
				@Override
				public void handleEvent(GridEvent be) {
					rowDoubleClick(be);
				}
			});
		}
		return listTable;
	}

	protected void listTablePostSaveTable(boolean success) {}

	protected void rowDoubleClick(GridEvent be) {}

	protected void listTableContentPrev() {}

	protected void listTableContentPost() {}

	protected boolean getListTableSelectOnList() {
		return true;
	}

	protected boolean[] getMenuDefault1List() {
		return null;
	}

	/***************************************************************************
	 * Abstract Method for implement in Master Panel
	 **************************************************************************/

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
//	public abstract String getTxCode();

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
//	public abstract String getTitle();

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	protected abstract String[] getColumnNames();

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	protected abstract int[] getColumnWidths();

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	protected abstract BasePanel getLeftPanel();

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	protected abstract BasePanel getRightPanel();

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	protected abstract boolean init();

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	protected abstract void initAfterReady();

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
//	public abstract Component getDefaultFocusComponent();

	/* >>> ~10~ Do something after action perform ========================= <<< */
	// action after ok/cancel button clicked
	protected abstract void confirmCancelButtonClicked();

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	// append disable fields
	protected abstract void appendDisabledFields();

	/* >>> ~11.1~ Set Disable Fields When Append ButtonBase Is Clicked ==== <<< */
	public void appendPostAction() {
		// focus on entry panel
//		PanelUtil.setFirstComponentFocus(getRightPanel());
	}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	// modify disable fields
	protected abstract void modifyDisabledFields();

	/* >>> ~12.1~ Set Disable Fields When Modify ButtonBase Is Clicked ==== <<< */
	public void modifyPostAction() {
		// focus on entry panel
//		PanelUtil.setFirstComponentFocus(getRightPanel());
	}

	/* >>> ~13~ Set Disable Fields When Delete ButtonBase Is Clicked ====== <<< */
	// delete disable fields
	protected abstract void deleteDisabledFields();

	/* >>> ~13.1~ Set Disable Fields When Delete ButtonBase Is Clicked ==== <<< */
	public void deletePostAction() {
		// for override if necessary
	}

	/* >>> ~14~ Set Browse Validation ===================================== <<< */
	protected boolean browseValidation() {
		return true;
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	// action parameter
	protected abstract String[] getBrowseInputParameters();

	/* >>> ~15.1~ Set Browse Output Results =============================== <<< */
	/* get the record field one by one */
	protected void getBrowseOutputValues(String[] outParam) {
	}

	/* >>> ~16~ Set Fetch Input Parameters ================================ <<< */
	protected abstract String[] getFetchInputParameters();

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	protected abstract void getFetchOutputValues(String[] outParam);

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	protected abstract String[] getActionInputParamaters();

	/* >>> ~17.1~ Set Action Output Parameters ============================ <<< */
	protected void getNewOutputValue(String returnValue) {
		// override by child class
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	protected void actionValidation(String actionType) {
		actionValidationReady(actionType, true);
	}
}