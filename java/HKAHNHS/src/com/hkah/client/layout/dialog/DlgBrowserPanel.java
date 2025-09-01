/*
 * Created on February 14, 2019
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.hkah.client.layout.dialog;

import java.util.Date;

import com.google.gwt.user.datepicker.client.CalendarUtil;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.BrowserPanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.PanelUtil;
import com.hkah.shared.constants.ConstantsErrorMessage;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
@SuppressWarnings("serial")
public class DlgBrowserPanel extends DialogBase {

	private final static int m_frameWidth = 1100;
	private final static int m_frameHeight = 900;

	private BasePanel panel = null;
	private BrowserPanel bPanel = null;


	public DlgBrowserPanel(MainFrame owner) {
		super(owner, OK, m_frameWidth, m_frameHeight);

		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setPosition(320, 150);
		setContentPane(getPanel());
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String url) {
		getBrowserPanel().setBrowserUrl(url,m_frameWidth-50,m_frameHeight-80);

		setVisible(true);

		// change label
		getButtonById(DialogBase.OK).setText("Close", 'C');
		
	}

	@Override
	public void doOkAction() {
		
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getPanel() {
		if (panel == null) {
			panel = new BasePanel();
			panel.setBounds(5, 5, 590, 390);
			panel.add(getBrowserPanel(),null);
		}
		return panel;
	}
	
	public BrowserPanel getBrowserPanel() {
		if (bPanel == null) {
			bPanel = new BrowserPanel();

		}
		return bPanel;
	}

}