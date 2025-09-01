/*
 * Created on February 14, 2019
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.hkah.client.layout.dialog;

import java.util.Date;

import com.extjs.gxt.ui.client.Style.LayoutRegion;
import com.extjs.gxt.ui.client.widget.Viewport;
import com.extjs.gxt.ui.client.widget.Window;
import com.extjs.gxt.ui.client.widget.layout.BorderLayout;
import com.extjs.gxt.ui.client.widget.layout.BorderLayoutData;
import com.google.gwt.user.client.ui.Frame;
import com.google.gwt.user.client.ui.HTML;
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
public class DlgPDFPanel extends DialogBase {

	private final static int m_frameWidth = 800;
	private final static int m_frameHeight = 600;

	private BasePanel panel = null;
	private Frame frame = null;

	public DlgPDFPanel(MainFrame owner) {
		super(owner,null, m_frameWidth, m_frameHeight);

		initialize();
	}
	
	public DlgPDFPanel() {
		super(null,null, m_frameWidth, m_frameHeight);

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
		setURL(url);
		setVisible(true);

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
		}
		return panel;
	}
	
	public void setURL(String url) {
		HTML pdf = new HTML("<embed src='"+url+"' width='750px' height='550px'></embed>");
		getPanel().removeAll();
		getPanel().add(pdf);
		layout();
	}
	

}