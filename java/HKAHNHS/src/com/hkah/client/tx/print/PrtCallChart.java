package com.hkah.client.tx.print;

import com.hkah.client.layout.dialog.DlgPrtCallChart;
import com.hkah.client.layout.panel.DefaultPanel;

public class PrtCallChart extends DefaultPanel {

	DlgPrtCallChart dlgPrtCallChart = null;

	/**
	 * This method initializes
	 *
	 */
	public PrtCallChart() {
		super();
	}

	public boolean preAction() {
		getDlgPrtCallChart().showDialog();
		return false;
	}

	public DlgPrtCallChart getDlgPrtCallChart() {
		if (dlgPrtCallChart == null) {
			dlgPrtCallChart = new DlgPrtCallChart(getMainFrame());
		}
		return dlgPrtCallChart;
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