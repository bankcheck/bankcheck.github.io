package com.hkah.client.tx.print;

import com.hkah.client.layout.dialog.DlgChangePrinter;
import com.hkah.client.layout.panel.DefaultPanel;

public class ChangePrinterSet extends DefaultPanel {
	DlgChangePrinter dlgChangePrinter = null;
	
	public ChangePrinterSet() {
		super();
	}

	public boolean preAction() {
		getDlgChangePrinter().showDialog();
		return false;
	}

	public DlgChangePrinter getDlgChangePrinter() {
		if (dlgChangePrinter == null) {
			dlgChangePrinter = new DlgChangePrinter(getMainFrame());
		}
		return dlgChangePrinter;
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
	public String getTxCode() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getTitle() {
		// TODO Auto-generated method stub
		return null;
	}

}
