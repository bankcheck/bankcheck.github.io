package com.hkah.client.layout.dialogsearch;

import com.extjs.gxt.ui.client.widget.Component;
import com.hkah.client.layout.dialog.DialogSearchBase;
import com.hkah.client.layout.label.LabelSmallBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.textfield.SearchTriggerField;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;

public class DlgARCardSearch extends DialogSearchBase {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		return ConstantsTx.ARCARD_SEARCH_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return "Patient Business Administration System - [AR Code Search]";
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
			"actid",						//actid
			"AR Code",						//ArcCode
			"Card Name",					//ACTCODE			
			"AR Company",					//ArcName
			"Card ID",						//ACTDESC
			"Phone Number",					//ArcTel
			"Contact Person",				//ArcCt
			"Address1",						//ArcAdd1
			"Address2",						//ArcAdd2
			"Address3",						//ArcAdd3
			"Contact Person Titler", 		//ArcTitle
			"Unallocated Amount", 			//ArcUAmt
			"Current Outstanding Balance",	//ArcAmt
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
			0,		//actid
			80,		//ArcCode
			600,	//ArcName			
			300,	//ACTCODE
			150,	//ACTDESC			
			100,	//ArcTel
			120,	//ArcCt
			150, 	//ArcAdd1
			150,	//ArcAdd2
			150,	//ArcAdd3
			150, 	//ArcTitle
			100,	//ArcUAmt
			100,	//ArcAmt
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private BasePanel searchPanel = null;

	private BasePanel arCodeInfoPanel = null; // criteria part 1 panel
	private LabelSmallBase arCodeDesc = null;
	private TextString arCode = null;
	private LabelSmallBase arCompanyDesc = null;
	private TextString arCompany = null;
	private LabelSmallBase phoneNumberDesc = null;
	private TextString phoneNumber = null;
	private LabelSmallBase contactPersonDesc = null;
	private TextString contactPerson = null;
	private JScrollPane arCodeScrollPane = null;
	private String showActive = "0";

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */

	/**
	* This method initializes
	*
	*/
	public DlgARCardSearch(SearchTriggerField textfField,String showActive) {
		super(textfField);
		this.showActive = showActive;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public Component getDefaultFocusComponent() {
		return getArCode();
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
				getArCode().getText().trim(),
				showActive
			};
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected boolean isSearchFieldsEmpty() {
		return getArCode().isEmpty();
	}

	@Override
	protected String getInputCriteriaMessage() {
		return ConstantsMessage.MSG_INPUT_CRITERIA;
	}
	
	@Override
	protected void acceptPostAction() {
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/* >>> getter methods for init the Component start from here ================================== <<< */
	@Override
	protected BasePanel getSearchPanel() {
		if (searchPanel == null) {
			searchPanel = new BasePanel();
			searchPanel.add(getArCodeInfoPanel(), null);
			searchPanel.add(getARCodeScrollPane());
			searchPanel.setSize(800, 175);
		}
		return searchPanel;
	}

	// Left Search criteria part1
	public BasePanel getArCodeInfoPanel() {
		if (arCodeInfoPanel == null) {
			arCodeInfoPanel = new BasePanel();
			arCodeInfoPanel.setTitledBorder();
			arCodeInfoPanel.add(getArCodeDesc(), null);
			arCodeInfoPanel.add(getArCode(), null);
//			arCodeInfoPanel.add(getArCompanyDesc(), null);
//			arCodeInfoPanel.add(getArCompany(), null);
//			arCodeInfoPanel.add(getPhoneNumberDesc(), null);
//			arCodeInfoPanel.add(getPhoneNumber(), null);
//			arCodeInfoPanel.add(getContactPersonDesc(), null);
//			arCodeInfoPanel.add(getContactPerson(), null);
			arCodeInfoPanel.setLocation(15, 15);
			arCodeInfoPanel.setSize(734, 80);
		}
		return arCodeInfoPanel;
	}

	public LabelSmallBase getArCodeDesc() {
		if (arCodeDesc == null) {
			arCodeDesc = new LabelSmallBase();
			arCodeDesc.setText("<b>Keyword</b>");
			arCodeDesc.setBounds(10, 18, 120, 20);
		}
		return arCodeDesc;
	}

	public TextString getArCode() {
		if (arCode == null) {
			arCode = new TextString();
			arCode.setBounds(100, 18, 400, 30);
		}
		return arCode;
	}

	public LabelSmallBase getArCompanyDesc() {
		if (arCompanyDesc == null) {
			arCompanyDesc = new LabelSmallBase();
			arCompanyDesc.setText("AR Company");
			arCompanyDesc.setBounds(334, 18, 100, 20);
		}
		return arCompanyDesc;
	}

	public TextString getArCompany() {
		if (arCompany == null) {
			arCompany = new TextString(false);
			arCompany.setBounds(439, 18, 200, 20);
		}
		return arCompany;
	}

	public LabelSmallBase getPhoneNumberDesc() {
		if (phoneNumberDesc == null) {
			phoneNumberDesc = new LabelSmallBase();
			phoneNumberDesc.setText("Phone Number");
			phoneNumberDesc.setBounds(54, 43, 120, 20);
		}
		return phoneNumberDesc;
	}

	public TextString getPhoneNumber() {
		if (phoneNumber == null) {
			phoneNumber = new TextString(false);
			phoneNumber.setBounds(159, 43, 120, 20);
		}
		return phoneNumber;
	}

	public LabelSmallBase getContactPersonDesc() {
		if (contactPersonDesc == null) {
			contactPersonDesc = new LabelSmallBase();
			contactPersonDesc.setText("Contact Person");
			contactPersonDesc.setBounds(334, 43, 100, 20);
		}
		return contactPersonDesc;
	}

	public TextString getContactPerson() {
		if (contactPerson == null) {
			contactPerson = new TextString(false);
			contactPerson.setBounds(439, 43, 200, 20);
		}
		return contactPerson;
	}

	/**
	 * This method initializes jScrollPane
	 *
	 * @return JScrollPane
	 */
	protected JScrollPane getARCodeScrollPane() {
		if (arCodeScrollPane == null) {
			arCodeScrollPane = new JScrollPane();
			arCodeScrollPane.setViewportView(getListTable());
			arCodeScrollPane.setBounds(15, 110, 734, 380);
		}
		return arCodeScrollPane;
	}
/*
	if(memActIDMap.containsKey(memActCode.substring(memActCode.indexOf("-")+1).trim())){
		post(memArcCode, memActIDMap.get(memActCode.substring(memActCode.indexOf("-")+1).trim()), 
				memActCode, memArDescMap.get(memActCode.substring(memActCode.indexOf("-")+1).trim()),
				memARCardCodeMap.get(memActCode.substring(memActCode.indexOf("-")+1).trim()));
		dispose();
*/			
}