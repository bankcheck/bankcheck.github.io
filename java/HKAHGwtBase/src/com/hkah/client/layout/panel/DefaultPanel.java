package com.hkah.client.layout.panel;

import com.extjs.gxt.ui.client.event.ButtonEvent;
import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.IconButtonEvent;
import com.extjs.gxt.ui.client.event.SelectionListener;
import com.extjs.gxt.ui.client.util.KeyNav;
import com.extjs.gxt.ui.client.widget.button.ToolButton;
import com.extjs.gxt.ui.client.widget.layout.FlowLayout;
import com.extjs.gxt.ui.client.widget.toolbar.FillToolItem;
import com.extjs.gxt.ui.client.widget.toolbar.SeparatorToolItem;
import com.extjs.gxt.ui.client.widget.toolbar.ToolBar;
import com.google.gwt.user.client.Element;
import com.hkah.client.Resources;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.util.PanelUtil;

public abstract class DefaultPanel extends BasePanel {

	private ButtonBase searchButton = null;
	private ButtonBase appendButton = null;
	private ButtonBase modifyButton = null;
	private ButtonBase deleteButton = null;
	private ButtonBase saveButton = null;
	private ButtonBase acceptButton = null;
	private ButtonBase cancelButton = null;
	private ButtonBase clearButton = null;
	private ButtonBase refreshButton = null;
	private ButtonBase printButton = null;
	private ToolButton closeButton = null;
	private ToolBar toolBar = null;
	private DefaultPanel thisPanel = this;

	private boolean searchButtonEnabled = true;
	private boolean appendButtonEnabled = true;
	private boolean modifyButtonEnabled = true;
	private boolean deleteButtonEnabled = true;
	private boolean acceptButtonEnabled = true;
	private boolean cancelButtonEnabled = true;
	private boolean clearButtonEnabled = true;
	private boolean isHideToolBar = false;

	@Override
	protected void onRender(Element parent, int index) {
		super.onRender(parent, index);
		setLayout(new FlowLayout());

		// modified by Ricky
		if (!isHideToolBar()) {
			add(getToolBar());
		}

		layout();
		// keyListener move to MainFrameBase
	}

	public ToolBar getToolBar() {
		if (toolBar == null) {
			SeparatorToolItem separator = new SeparatorToolItem();
			
			toolBar = new ToolBar();
			toolBar.add(getSearchButton());
			toolBar.add(separator);
			toolBar.add(getAppendButton());
			toolBar.add(separator);
			toolBar.add(getModifyButton());
			toolBar.add(separator);
			toolBar.add(getDeleteButton());
			toolBar.add(separator);
			toolBar.add(getSaveButton());
			toolBar.add(separator);
			toolBar.add(getAcceptButton());
			toolBar.add(separator);
			toolBar.add(getCancelButton());
			toolBar.add(separator);
			toolBar.add(getClearButton());
			toolBar.add(separator);
			toolBar.add(getRefreshButton());
			toolBar.add(separator);
			toolBar.add(getPrintButton());
			toolBar.add(separator);
			toolBar.add(new FillToolItem());
			toolBar.add(getCloseButton());
		}
		return toolBar;
	}

	/***************************************************************************
	 * Abstract Method
	 **************************************************************************/

	public abstract void searchAction();

	public abstract void appendAction();

	public abstract void modifyAction();

	public abstract void deleteAction();

	public abstract void saveAction();

	public abstract void acceptAction();

	public abstract void cancelAction();

	public abstract void clearAction();

	public abstract void refreshAction();

	public abstract void printAction();

	/***************************************************************************
	 * ButtonBase Method
	 **************************************************************************/

	protected ButtonBase getSearchButton() {
		if (searchButton == null) {
			searchButton = new ButtonBase("Search", Resources.ICONS.search(), new SelectionListener<ButtonEvent>() {
				@Override
				public void componentSelected(ButtonEvent ce) {
					searchAction();
				}
			});
		}
		return searchButton;
	}

	protected ButtonBase getAppendButton() {
		if (appendButton == null) {
			appendButton = new ButtonBase("New", Resources.ICONS.new1(), new SelectionListener<ButtonEvent>() {
				@Override
				public void componentSelected(ButtonEvent ce) {
					appendAction();
				}
			});
		}
		return appendButton;
	}

	protected ButtonBase getModifyButton() {
		if (modifyButton == null) {
			modifyButton = new ButtonBase("Edit", Resources.ICONS.edit(), new SelectionListener<ButtonEvent>() {
				@Override
				public void componentSelected(ButtonEvent ce) {
					modifyAction();
				}
			});
		}
		return modifyButton;
	}

	protected ButtonBase getDeleteButton() {
		if (deleteButton == null) {
			deleteButton = new ButtonBase("Delete", Resources.ICONS.delete(), new SelectionListener<ButtonEvent>() {
				@Override
				public void componentSelected(ButtonEvent ce) {
					deleteAction();
				}
			});
		}
		return deleteButton;
	}

	protected ButtonBase getSaveButton() {
		if (saveButton == null) {
			saveButton = new ButtonBase("Save", Resources.ICONS.save(), new SelectionListener<ButtonEvent>() {
				@Override
				public void componentSelected(ButtonEvent ce) {
					saveAction();
				}
			});
		}
		return saveButton;
	}

	protected ButtonBase getAcceptButton() {
		if (acceptButton == null) {
			acceptButton = new ButtonBase("Accept", Resources.ICONS.accept(), new SelectionListener<ButtonEvent>() {
				@Override
				public void componentSelected(ButtonEvent ce) {
					acceptAction();
				}
			});
		}
		return acceptButton;
	}

	protected ButtonBase getCancelButton() {
		if (cancelButton == null) {
			cancelButton = new ButtonBase("Cancel", Resources.ICONS.cancel(), new SelectionListener<ButtonEvent>() {
				@Override
				public void componentSelected(ButtonEvent ce) {
					cancelAction();
				}
			});
		}
		return cancelButton;
	}

	protected ButtonBase getClearButton() {
		if (clearButton == null) {
			clearButton = new ButtonBase("Clear", Resources.ICONS.clear(), new SelectionListener<ButtonEvent>() {
				@Override
				public void componentSelected(ButtonEvent ce) {
					clearAction();
				}
			});
		}
		return clearButton;
	}

	protected ButtonBase getRefreshButton() {
		if (refreshButton == null) {
			refreshButton = new ButtonBase("Refresh", Resources.ICONS.refresh(), new SelectionListener<ButtonEvent>() {
				@Override
				public void componentSelected(ButtonEvent ce) {
					refreshAction();
				}
			});
		}
		return refreshButton;
	}

	protected ButtonBase getPrintButton() {
		if (printButton == null) {
			printButton = new ButtonBase("Print", Resources.ICONS.print(), new SelectionListener<ButtonEvent>() {
				@Override
				public void componentSelected(ButtonEvent ce) {
					printAction();
				}
			});
		}
		return printButton;
	}

	protected ToolButton getCloseButton() {
		if (closeButton == null) {
			closeButton = new ToolButton(".x-tool-close",new SelectionListener<IconButtonEvent>() {
				@Override
				public void componentSelected(IconButtonEvent ce) {
					exitPanel();
				}
			});
		}
		return closeButton;
	}
	
	public void exitPanel() {
		getMainFrame().exitPanel();
	}

	/**
	 * @return the searchButtonEnabled
	 */
	protected boolean isSearchButtonEnabled() {
		return searchButtonEnabled;
	}

	/**
	 * @return the appendButtonEnabled
	 */
	protected boolean isAppendButtonEnabled() {
		return appendButtonEnabled;
	}

	/**
	 * @return the modifyButtonEnabled
	 */
	protected boolean isModifyButtonEnabled() {
		return modifyButtonEnabled;
	}

	/**
	 * @return the deleteButtonEnabled
	 */
	protected boolean isDeleteButtonEnabled() {
		return deleteButtonEnabled;
	}

	/**
	 * @return the acceptButtonEnabled
	 */
	protected boolean isacceptButtonEnabled() {
		return acceptButtonEnabled;
	}

	/**
	 * @return the cancelButtonEnabled
	 */
	protected boolean isCancelButtonEnabled() {
		return cancelButtonEnabled;
	}

	/**
	 * @return the clearButtonEnabled
	 */
	protected boolean isClearButtonEnabled() {
		return clearButtonEnabled;
	}

	/**
	 * @param searchButtonEnabled the searchButtonEnabled to set
	 */
	protected void setSearchButtonEnabled(boolean searchButtonEnabled) {
		this.searchButtonEnabled = searchButtonEnabled;
	}

	/**
	 * @param appendButtonEnabled the appendButtonEnabled to set
	 */
	protected void setAppendButtonEnabled(boolean appendButtonEnabled) {
		this.appendButtonEnabled = appendButtonEnabled;
	}

	/**
	 * @param modifyButtonEnabled the modifyButtonEnabled to set
	 */
	protected void setModifyButtonEnabled(boolean modifyButtonEnabled) {
		this.modifyButtonEnabled = modifyButtonEnabled;
	}

	/**
	 * @param deleteButtonEnabled the deleteButtonEnabled to set
	 */
	protected void setDeleteButtonEnabled(boolean deleteButtonEnabled) {
		this.deleteButtonEnabled = deleteButtonEnabled;
	}

	/**
	 * @param acceptButtonEnabled the acceptButtonEnabled to set
	 */
	protected void setAcceptButtonEnabled(boolean acceptButtonEnabled) {
		this.acceptButtonEnabled = acceptButtonEnabled;
	}

	/**
	 * @param cancelButtonEnabled the cancelButtonEnabled to set
	 */
	protected void setCancelButtonEnabled(boolean cancelButtonEnabled) {
		this.cancelButtonEnabled = cancelButtonEnabled;
	}

	/**
	 * @param clearButtonEnabled the clearButtonEnabled to set
	 */
	protected void setClearButtonEnabled(boolean clearButtonEnabled) {
		this.clearButtonEnabled = clearButtonEnabled;
	}

	protected void disableButton() {
		setEnabledButton(false);
	}

	private void setEnabledButton(boolean enabled) {
		getSearchButton().setEnabled(enabled);
		getAppendButton().setEnabled(enabled);
		getModifyButton().setEnabled(enabled);
		getDeleteButton().setEnabled(enabled);
		getSaveButton().setEnabled(enabled);
		getAcceptButton().setEnabled(enabled);
		getCancelButton().setEnabled(enabled);
		getRefreshButton().setEnabled(enabled);
		getPrintButton().setEnabled(enabled);
		getClearButton().setEnabled(enabled);

		// reset button color
		getAppendButton().setFocus(enabled);
		getModifyButton().setFocus(enabled);
		getDeleteButton().setFocus(enabled);
	}

	public boolean isHideToolBar() {
		return isHideToolBar;
	}

	public void setHideToolBar(boolean isHideToolBar) {
		this.isHideToolBar = isHideToolBar;
		if (rendered) {
			if (toolBar == null) {
				add(getToolBar());
			}
			getToolBar().setVisible(!isHideToolBar);
		}
	}

	/***************************************************************************
	 * Abstract Method for implement in Default Panel
	 **************************************************************************/

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	public abstract String getTxCode();

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	public abstract String getTitle();
}