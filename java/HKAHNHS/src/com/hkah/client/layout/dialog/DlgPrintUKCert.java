/*
 * Created on July 3, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.hkah.client.layout.dialog;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;

import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.combobox.ComboCountry;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.PrintingUtil;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class DlgPrintUKCert extends DialogBase {

    private final static int m_frameWidth = 580;
    private final static int m_frameHeight = 200;

	private BasePanel dialogTopPanel = null;
	private LabelBase Label_ChildrregidenUnder11 = null;
	private LabelBase Label_UKAddress = null;
	private LabelBase Label_VisaCat = null;

	private TextString childrenUnder11 = null;
	private TextString ukAddress = null;
	private TextString visaCat = null;
	
	private String memRegID = null;

	public DlgPrintUKCert(MainFrame owner) {
        super(owner, YES, m_frameWidth, m_frameHeight);
        setClosable(true);	
        initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Print UK Pre-Departure Med Cert");

		setContentPane(getDialogTopPanel());

    	// change label
		getButtonById(YES).setText("Print", 'P');

	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String regID) {
		memRegID = regID;

	    setVisible(true);
	}

	@Override
	protected void doYesAction() {
		doPrintUKCert();
	}


	private void doPrintUKCert() {
		HashMap<String, String> map = new HashMap<String, String>();

		map.put("LogoImg",CommonUtil.getReportImg("ukvisa.png"));
		map.put("ImgTick", CommonUtil.getReportImg("tick1.gif"));
		map.put("noOfChild", getChildrenUnder11().getText());
		map.put("ukAddress", getUKAddress().getText());
		map.put("visaCat", getVisaCat().getText());
		
		PrintingUtil.print("UKCERT",
				map,null,new String[] {
							memRegID
				}, new String[] {
						"CERTNO","PATNO", "ISSUEDATE", 
						"CITY", "GNAME", "FNAME", 
						"SEX", "COUNTRY", "IDNO", "DOB", "ADDRESS"
				});
		dispose();
	}


	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getDialogTopPanel() {
		if (dialogTopPanel == null) {
			dialogTopPanel = new BasePanel();
			dialogTopPanel.setBounds(0, 0, 550, 140);
			dialogTopPanel.add(getLabel_ChildrregidenUnder11(), null);
			dialogTopPanel.add(getChildrenUnder11(), null);
			dialogTopPanel.add(getLabel_UKAddress(), null);
			dialogTopPanel.add(getUKAddress(), null);
			dialogTopPanel.add(getLabel_VisaCat(), null);
			dialogTopPanel.add(getVisaCat(), null);
		
		}
		return dialogTopPanel;
	}

	public LabelBase getLabel_ChildrregidenUnder11() {
		if (Label_ChildrregidenUnder11 == null) {
			Label_ChildrregidenUnder11 = new LabelBase();
			Label_ChildrregidenUnder11.setText("Number of accompanying <br>children under 11");
			Label_ChildrregidenUnder11.setBounds(5, 5, 200, 20);
		}
		return Label_ChildrregidenUnder11;
	}

	public TextString getChildrenUnder11() {
		if (childrenUnder11 == null) {
			childrenUnder11 = new TextString();
			childrenUnder11.setText("0");
			childrenUnder11.setBounds(140, 5, 350, 20);
		}
		return childrenUnder11;
	}

	public LabelBase getLabel_UKAddress() {
		if (Label_UKAddress == null) {
			Label_UKAddress = new LabelBase();
			Label_UKAddress.setText("Address in UK");
			Label_UKAddress.setBounds(5, 35, 200, 20);
		}
		return Label_UKAddress;
	}

	public TextString getUKAddress() {
		if (ukAddress == null) {
			ukAddress = new TextString(120);
			ukAddress.setText("N/A");
			ukAddress.setBounds(140, 35, 350, 20);
		}
		return ukAddress;
	}

	public LabelBase getLabel_VisaCat() {
		if (Label_VisaCat == null) {
			Label_VisaCat = new LabelBase();
			Label_VisaCat.setText("Visa Category");
			Label_VisaCat.setBounds(5, 60, 200, 20);
		}
		return Label_VisaCat;
	}

	public TextString getVisaCat() {
		if (visaCat == null) {
			visaCat = new TextString();
			visaCat.setText("BNO VISA");
			visaCat.setBounds(140, 60, 350, 20);
		}
		return visaCat;
	}


}