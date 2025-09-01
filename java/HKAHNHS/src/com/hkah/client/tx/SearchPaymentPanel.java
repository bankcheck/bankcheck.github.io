/*
 * Created on 2019-01-30
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.tx;

import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.util.PanelUtil;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public abstract class SearchPaymentPanel extends MasterPaymentPanel {

	private BasePanel leftPanel = null;
	private BasePanel rightPanel = null;

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public final boolean init() {
		setNoGetDB(true);
		setLeftAlignPanel();
		return true;
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected final void confirmCancelButtonClicked() {}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected final void appendDisabledFields() {}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected final void modifyDisabledFields() {}

	/* >>> ~12.1~ Set Disable Fields When Modify ButtonBase Is Clicked ==== <<< */
	@Override
	public final void modifyPostAction() {}

	/* >>> ~13~ Set Disable Fields When Delete ButtonBase Is Clicked ====== <<< */
	@Override
	protected final void deleteDisabledFields() {}

	/* >>> ~15~ Set Fetch Output Results ============================== <<< */
	@Override
	protected final void getBrowseOutputValues(String[] outParam) {}

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

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected final String[] getActionInputParamaters() {
		return null;
	}

	/* >>> ~17.1~ Set Action Output Parameters =========================== <<< */
	@Override
	protected final void getNewOutputValue(String returnValue) {}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	protected final void actionValidationReady(boolean ready) {
	}

	/***************************************************************************
	* Override Method
	**************************************************************************/

	/**
	 * This method initializes leftPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	@Override
	protected final BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			if (getSearchPanel() != null){
				leftPanel.add(getSearchPanel());
			}
		}
		return leftPanel;
	}

	/**
	 * This method initializes rightPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	@Override
	protected final BasePanel getRightPanel() {
		if (rightPanel == null) {
			rightPanel = new BasePanel();
		}
		return rightPanel;
	}

	@Override
	protected void setAllLeftFieldsEnabled(boolean enable) {
		if (getSearchPanel() != null) {
			// reset field status
			PanelUtil.resetAllFieldsStatus(getSearchPanel());
			// disable field
			PanelUtil.setAllFieldsEditable(getSearchPanel(), enable);
//			this.setWorking(!enable);
		}
	}

	@Override
	protected void setAllRightFieldsEnabled(boolean enable) {
	}

	/***************************************************************************
	* Abstract Method
	**************************************************************************/

	protected abstract BasePanel getSearchPanel();
}