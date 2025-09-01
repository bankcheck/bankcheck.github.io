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
import com.hkah.client.util.PrintingUtil;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class DlgPrintAddress extends DialogBase {

    private final static int m_frameWidth = 580;
    private final static int m_frameHeight = 240;

	private BasePanel dialogTopPanel = null;
	private LabelBase Label_PatientAddr = null;
	private LabelBase Label_PatientPatFName = null;
	private LabelBase Label_PatientPatGName = null;
	private LabelBase Label_PatientCountry = null;
	private TextString patientPatFName = null;
	private TextString patientPatGName = null;
	private TextString patientAddr1 = null;
	private TextString patientAddr2 = null;
	private TextString patientAddr3 = null;
	private ComboCountry patientCountry = null;

	private String memPatNo = null;

	public DlgPrintAddress(MainFrame owner) {
        super(owner, YESNOCANCEL, m_frameWidth, m_frameHeight);
        setClosable(true);	
        initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Print Patient Address");

		setContentPane(getDialogTopPanel());

    	// change label
		getButtonById(YES).setText("Print Address", 'P');
		getButtonById(NO).setText("Print Envelope", 'E');
		getButtonById(CANCEL).setText("Print Address Label", 'L');
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String patNo, String familyName, String givenName,
			String address1, String address2, String address3, String country) {
		memPatNo = patNo;

		getPatientPatFName().setText(familyName);
		getPatientPatGName().setText(givenName);
		getPatientAddr1().setText(address1);
		getPatientAddr2().setText(address2);
		getPatientAddr3().setText(address3);
		getPatientCountry().setText(country);
		
		if (Factory.getInstance().getSysParameter("HIDEADRLBL").equals("Y")) {
			if (getButtonById(CANCEL) != null) {
				getButtonById(CANCEL).removeFromParent();
			}
		}

	    setVisible(true);
	}

	@Override
	protected void doYesAction() {
		doPrintAddress(true, false);
	}

	@Override
	protected void doNoAction() {
		doPrintAddress(false, false);
	}
	
	@Override
	protected void doCancelAction() {
		doPrintAddress(false, true);
	}

	private void doPrintAddress(boolean isWord, boolean isLabel) {
		HashMap<String, String> map = new HashMap<String, String>();
		if(containsChinese(getPatientPatFName().getText()
				+getPatientPatGName().getText()
				+getPatientAddr1().getText()
				+getPatientAddr2().getText()
				+getPatientAddr3().getText())){
			map.put("containChinese","Y");
		}else{
			map.put("containChinese","N");
		}
		map.put("patName",(getPatientPatFName().getText()==null?"":getPatientPatFName().getText())
							+" "+(getPatientPatGName().getText()==null?"":getPatientPatGName().getText()));
		map.put("patAddr1",(getPatientAddr1().getText()==null?"":getPatientAddr1().getText()));
		map.put("patAddr2",(getPatientAddr2().getText()==null?"":getPatientAddr2().getText()));

		if (isWord) {
			map.put("patAddr3",(getPatientAddr3().getText()==null?"":getPatientAddr3().getText()));

			PrintingUtil.print("patAddr",map,"",
			getMainFrame().getSysParameter("PATADDRPTH")
			+ "\\"+ memPatNo + "_"
			+ (getMainFrame().getServerDate().replace("/","").substring(4,8))
			+ (getMainFrame().getServerDate().replace("/","").substring(2,4))
			+ (getMainFrame().getServerDate().replace("/","").substring(0,2))
			+ ".doc");
		} else {
			if (isLabel) {
				map.put("patAddr3",(getPatientAddr3().getText()==null?"":getPatientAddr3().getText()));
				
				PrintingUtil.print(Factory.getInstance().getSysParameter("PRTRLBL"), "patAddrLabel", map, "");
			}
			else {
				map.put("patAddr3", (getPatientAddr3().getText()==null?"":getPatientAddr3().getText())
						+ (getPatientAddr3().getText()==null || getPatientAddr3().getText().trim().length() == 0?"":", ")
						+ getPatientCountry().getDisplayTextWithoutKey().replace(getPatientCountry().getText(),""));
	
				PrintingUtil.print("HATS_A4", "patAddrEnvelope", map, "");
			}
		}

		dispose();
	}
	
	public static boolean containsChinese(String str) {
		char[] s = str.toCharArray();
	    for (int i = 0; i < s.length;i++) {
	    	try {
				byte[] tpByte = Character.toString(s[i]).getBytes("UTF-8");
		        if (tpByte.length > 1) {
		            return true;
		        }
			} catch (UnsupportedEncodingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return false;
			}
	    }
	    return false;
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getDialogTopPanel() {
		if (dialogTopPanel == null) {
			dialogTopPanel = new BasePanel();
			dialogTopPanel.setBounds(0, 0, 550, 140);
			dialogTopPanel.add(getLabel_PatientPatFName(), null);
			dialogTopPanel.add(getPatientPatFName(), null);
			dialogTopPanel.add(getLabel_PatientPatGName(), null);
			dialogTopPanel.add(getPatientPatGName(), null);
			dialogTopPanel.add(getLabel_PatientAddr(), null);
			dialogTopPanel.add(getPatientAddr1(), null);
			dialogTopPanel.add(getPatientAddr2(), null);
			dialogTopPanel.add(getPatientAddr3(), null);
			dialogTopPanel.add(getLabel_PatientCountry(), null);
			dialogTopPanel.add(getPatientCountry(), null);
		}
		return dialogTopPanel;
	}

	public LabelBase getLabel_PatientPatFName() {
		if (Label_PatientPatFName == null) {
			Label_PatientPatFName = new LabelBase();
			Label_PatientPatFName.setText("Patient Family Name");
			Label_PatientPatFName.setBounds(5, 5, 135, 20);
		}
		return Label_PatientPatFName;
	}

	public TextString getPatientPatFName() {
		if (patientPatFName == null) {
			patientPatFName = new TextString();
			patientPatFName.setBounds(140, 5, 400, 20);
		}
		return patientPatFName;
	}

	public LabelBase getLabel_PatientPatGName() {
		if (Label_PatientPatGName == null) {
			Label_PatientPatGName = new LabelBase();
			Label_PatientPatGName.setText("Patient Given Name");
			Label_PatientPatGName.setBounds(5, 30, 135, 20);
		}
		return Label_PatientPatGName;
	}

	public TextString getPatientPatGName() {
		if (patientPatGName == null) {
			patientPatGName = new TextString();
			patientPatGName.setBounds(140, 30, 400, 20);
		}
		return patientPatGName;
	}

	public LabelBase getLabel_PatientAddr() {
		if (Label_PatientAddr == null) {
			Label_PatientAddr = new LabelBase();
			Label_PatientAddr.setText("Address");
			Label_PatientAddr.setBounds(5, 55, 135, 20);
		}
		return Label_PatientAddr;
	}

	public TextString getPatientAddr1() {
		if (patientAddr1 == null) {
			patientAddr1 = new TextString();
			patientAddr1.setBounds(140, 55, 400, 20);
		}
		return patientAddr1;
	}

	public TextString getPatientAddr2() {
		if (patientAddr2 == null) {
			patientAddr2 = new TextString();
			patientAddr2.setBounds(140, 80, 400, 20);
		}
		return patientAddr2;
	}

	public TextString getPatientAddr3() {
		if (patientAddr3 == null) {
			patientAddr3 = new TextString();
			patientAddr3.setBounds(140, 105, 400, 20);
		}
		return patientAddr3;
	}

	public LabelBase getLabel_PatientCountry() {
		if (Label_PatientCountry == null) {
			Label_PatientCountry = new LabelBase();
			Label_PatientCountry.setText("Country");
			Label_PatientCountry.setBounds(5, 130, 135, 20);
		}
		return Label_PatientCountry;
	}

	public ComboCountry getPatientCountry() {
		if (patientCountry == null) {
			patientCountry = new ComboCountry();
			patientCountry.setBounds(140, 130, 400, 20);
		}
		return patientCountry;
	}
}