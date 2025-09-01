package com.hkah.client.tx.insuranceCard;

import com.hkah.client.common.Factory;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.tx.ActionPanel;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTableColumn;
import com.hkah.shared.constants.ConstantsVariable;

public class PanelDoctor extends ActionPanel implements ConstantsMessage, ConstantsVariable, ConstantsTableColumn {
	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return "PANELDOCTOR";
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return "Panel Doctor";
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private BasePanel actionPanel = null;
	
	/**
	 * This method initializes
	 *
	 */
	public PanelDoctor() {
		super();
	}
	
	@Override
	protected void initAfterReady() {
		openNewWindow(null, Factory.getInstance().getSysParameter("PANELDR"), null, true, false);
	}

	@Override
	public void searchAction() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void appendAction() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void modifyAction() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deleteAction() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void saveAction() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void acceptAction() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void cancelAction() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void clearAction() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void refreshAction() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void printAction() {
		// TODO Auto-generated method stub
		
	}

	@Override
	protected BasePanel getActionPanel() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	protected void confirmCancelButtonClicked() {
		// TODO Auto-generated method stub
		
	}

	@Override
	protected void appendDisabledFields() {
		// TODO Auto-generated method stub
		
	}

	@Override
	protected void modifyDisabledFields() {
		// TODO Auto-generated method stub
		
	}

	@Override
	protected void deleteDisabledFields() {
		// TODO Auto-generated method stub
		
	}

	@Override
	protected String[] getFetchInputParameters() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	protected void getFetchOutputValues(String[] outParam) {
		// TODO Auto-generated method stub
		
	}

	@Override
	protected String[] getActionInputParamaters() {
		// TODO Auto-generated method stub
		return null;
	}

}
