/*
 * Created on 2013-03-21
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.layout.dialog;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.textfield.SearchTriggerField;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.SearchPanel;
import com.hkah.client.util.PanelUtil;

public abstract class DialogSearchBase extends SearchPanel {

	protected DialogBase dialog = null;
	protected SearchTriggerField searchTriggerField = null;
	protected DialogSearchBase dialogSearchBase = this;

	private boolean isClear = false;

	private int dialogWidth = 780;
	private int dialogHeight = 570;

	public boolean isClear() {
		return isClear;
	}

	public void setClear(boolean isClear) {
		this.isClear = isClear;
	}

	public DialogSearchBase(SearchTriggerField textfField) {
		super();
		setMainFrame(Factory.getInstance().getMainFrame());
		searchTriggerField = textfField;

		initAfterReady();
	}

	public DialogSearchBase(SearchTriggerField textfField, int width, int height) {
		super();
		setMainFrame(Factory.getInstance().getMainFrame());
		searchTriggerField = textfField;
		dialogWidth = width;
		dialogHeight = height;

		initAfterReady();
	}

	/* >>> ~14~ Set Browse Validation ===================================== <<< */
	@Override
	protected boolean browseValidation() {
		if (isSearchFieldsEmpty()) {
			Factory.getInstance().addErrorMessage(getInputCriteriaMessage(), "Dialog Search", getDefaultFocusComponent());
			return false;
		} else {
			return true;
		}
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {
		super.getFetchOutputValues(outParam);

		if (outParam.length > 2) {
			getSearchDialog().getButtonById(Dialog.NO).setEnabled(!"O".equals(outParam[2]));
		}
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	protected abstract boolean isSearchFieldsEmpty();

	protected abstract String getInputCriteriaMessage();

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showPanel() {
		getSearchDialog().show();

		if (!isClear) {
			// clear all values
			PanelUtil.resetAllFields(getSearchPanel());

			// get value from text field to search field
			if (getDefaultFocusComponent() != null && searchTriggerField != null) {
				((TextString) getDefaultFocusComponent()).setText(searchTriggerField.getText());
			}
		}

//		getDefaultFocusComponent().focus();

		// disable accept button
		getSearchDialog().getButtonById(Dialog.NO).setEnabled(false);
	}

	public int acceptTableColumn() {
		return 0;
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected void performListPost() {
		getSearchDialog().getButtonById(Dialog.NO).setEnabled(getListTable().getRowCount() > 0);

		if (getListTable().getRowCount() > 0) {
			getSearchDialog().setFocusWidget(getListTable());
		} else {
			getSearchDialog().setFocusWidget(getDefaultFocusComponent());
		}
	}

	@Override
	public final void acceptAction() {
		if (getListTable().getRowCount() > 0) {
			if (getListTable().getSelectedRow() >= 0) {
				searchTriggerField.setText(getListTable().getSelectedRowContent()[acceptTableColumn()]);
				getSearchDialog().setVisible(false);
				searchTriggerField.focus();

				// call after all action done
				acceptPostAction();
			}
		}
	}

	@Override
	public void cancelAction() {
		PanelUtil.resetAllFields(getSearchPanel());
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	protected DialogBase getSearchDialog() {
		if (dialog == null) {
			dialog = new DialogBase(Factory.getInstance().getMainFrame(), Dialog.YESNOCANCEL+Dialog.CLOSE, dialogWidth, dialogHeight) {
				@Override
				public Component getDefaultFocusComponent() {
					return dialogSearchBase.getDefaultFocusComponent();
				}

				@Override
				protected void otherHandleEvent(ComponentEvent ce) {
					if (!(ce.isAltKey() || ce.isRightClick() ||
							ce.isShiftKey() || ce.isSpecialKey())) {
						if (ce.getKeyCode() == 112) {
							searchAction();
						} else if (ce.getKeyCode() == 118) {
							acceptAction();
						} else if (ce.getKeyCode() == 120) {
							doCancelAction();
						}
					}
				}

				@Override
				protected void doYesAction() {
					searchAction();
					setDefaultFocus();
				}

				@Override
				protected void doNoAction() {
					acceptAction();
					setDefaultFocus();
				}

				@Override
				protected void doCancelAction() {
					cancelAction();
					setDefaultFocus();
				}

				private void setDefaultFocus() {
					setFocusWidget(getDefaultFocusComponent());
					defaultFocus();
				}
			};
			dialog.setHeadingHtml(getTitle());
			dialog.add(getSearchPanel());
			dialog.setClosable(true);
		    dialog.getButtonById(Dialog.YES).setText("Search", 'S');
		    dialog.getButtonById(Dialog.NO).setText("Accept", 'A');
		    dialog.getButtonById(Dialog.CANCEL).setText("Clear", 'C');
		}
		return dialog;
	}
}