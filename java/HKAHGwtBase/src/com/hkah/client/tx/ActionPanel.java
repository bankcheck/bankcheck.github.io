/*
 * Created on 2012-08-06
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
public abstract class ActionPanel extends MasterPanel {

	private BasePanel leftPanel = null;
	private BasePanel rightPanel = null;

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	protected int[] getColumnWidths() {
		return new int[] {};
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		setNoListDB(true);
		setRightAlignPanel();
		return true;
	}

	/* >>> ~14~ Set Browse Validation ===================================== <<< */
	@Override
	protected boolean browseValidation() {
		return true;
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[]{};
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
			if (getActionPanel() != null){
				rightPanel.add(getActionPanel());
			}
		}
		return rightPanel;
	}

	@Override
	protected void setAllLeftFieldsEnabled(boolean enable) {
	}

	@Override
	protected void setAllRightFieldsEnabled(boolean enable) {
		if (getActionPanel() != null) {
			// reset field status
			PanelUtil.resetAllFieldsStatus(getActionPanel());
			// disable field
			PanelUtil.setAllFieldsEditable(getActionPanel(), enable);
//			this.setWorking(!enable);
		}
	}

	@Override
	protected final void performListFieldsEnable() {
		super.performListFieldsEnable();
		PanelUtil.setAllFieldsEditable(getActionPanel(), true);
	}

	/***************************************************************************
	* Abstract Method
	**************************************************************************/

	protected abstract BasePanel getActionPanel();
}