/*
 * Created on July 23, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.tx.admin.syscodetable;

import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MaintenancePanel;
import com.hkah.shared.constants.ConstantsTx;


/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class Country extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.COUNTRY_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.COUNTRY_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Country Code",
				"Country Description"
		};
	}


	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				80,
				50
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;
	private LabelBase LeftJLabel_CountryCode = null;
	private TextString LeftJText_CountryCode = null;
	private LabelBase LeftJLabel_CountryDesc = null;
	private TextString LeftJText_CountryDesc = null;

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_CountryCode = null;
	private TextString RightJText_CountryCode = null;
	private LabelBase RightJLabel_CountryDesc = null;
	private TextString RightJText_CountryDesc = null;
	/**
	 * This method initializes
	 *
	 */
	public Country() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		/* >>> ~7.1~ Init action (e.g. Listing, Init Comobbox ========= <<< */
		//setFullEntry(true);
		setNoGetDB(true);

		/* >>> ~7.2~ Disable Add/Modify/Delete Buttons ================ <<< */
		//setAppendButtonEnabled(false);
		//setModifyButtonEnabled(false);
		//setDeleteButtonEnabled(false);

		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		//performList();
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return getLeftJText_CountryCode();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {
		// override function if necessary
	}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {
		// enable/disable field
	}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
		// enable/disable field
		getRightJText_CountryCode().setEnabled(false);
	}

	/* >>> ~13~ Set Disable Fields When Delete ButtonBase Is Clicked ====== <<< */
	@Override
	protected void deleteDisabledFields() {
		// enable/disable field
	}

	/* >>> ~14~ Set Browse Validation ===================================== <<< */
	@Override
	protected boolean browseValidation() {
		return true;
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
				getLeftJText_CountryCode().getText(),
				getLeftJText_CountryDesc().getText()
		};
	}

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
	protected void getFetchOutputValues(String[] outParam) {
		int index = 0;
		getRightJText_CountryCode().setText(outParam[index++]);
		getRightJText_CountryDesc().setText(outParam[index++]);
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {
		if (getRightJText_CountryCode().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Country Code!", getRightJText_CountryCode());
			actionValidationReady(actionType, false);
		} else if (getRightJText_CountryDesc().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Country Description!", getRightJText_CountryDesc());
			actionValidationReady(actionType, false);
		} else {
			actionValidationReady(actionType, true);
		}
	}

	/* >>> ~22~ Set Action Input Parameters per table ===================== <<< */
	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		// TODO Auto-generated method stub
		return new String[] {
				selectedContent[0],
				selectedContent[1]
		};
	}

	/* >>> ~23~ Set Action Validation per table =========================== <<< */
	@Override
	protected boolean actionValidation(String[] selectedContent) {
		// TODO Auto-generated method stub
		if (selectedContent[0]==null || selectedContent[0].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty Country Code!");
			return false;
		} else if (selectedContent[1]==null || selectedContent[1].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty Country Description!");
			return false;
		}
		return true;
	}

	@Override
	public void saveAction() {
		// TODO Auto-generated method stub
		super.saveAction();
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/**
	 * This method initializes leftPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected ColumnLayout getSearchPanel() {
		if (leftPanel == null) {
			leftPanel = new ColumnLayout(4,1);
//			leftPanel.setSize(495, 110);
			leftPanel.add(0,0,getLeftJLabel_CountryCode());
			leftPanel.add(1,0,getLeftJText_CountryCode());
			leftPanel.add(2,0,getLeftJLabel_CountryDesc());
			leftPanel.add(3,0,getLeftJText_CountryDesc());
	}
		return leftPanel;
	}

	/**
	 * This method initializes LeftJLabel_CountryCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */


	private LabelBase getLeftJLabel_CountryCode() {
		if (LeftJLabel_CountryCode == null) {
			LeftJLabel_CountryCode = new LabelBase();
//			LeftJLabel_CountryCode.setBounds(16, 15, 146, 20);
			LeftJLabel_CountryCode.setText("Country Code :");
			LeftJLabel_CountryCode.setOptionalLabel();
		}
		return LeftJLabel_CountryCode;
	}

	/**
	 * This method initializes LeftJText_CountryCode
	 *
	 * @return com.hkah.client.layout.textfield.TextCountryCode
	 */
	private TextString getLeftJText_CountryCode() {
		if (LeftJText_CountryCode == null) {
			LeftJText_CountryCode = new TextString(3,false);
//			LeftJText_CountryCode.setBounds(172, 17, 95, 20);

		}
		return LeftJText_CountryCode;
	}
	/**
	 * This method initializes LeftJLabel_CountryDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getLeftJLabel_CountryDesc() {
		if (LeftJLabel_CountryDesc == null) {
			LeftJLabel_CountryDesc = new LabelBase();
//			LeftJLabel_CountryDesc.setBounds(16, 55, 147, 30);
			LeftJLabel_CountryDesc.setText("Country Description :");
			LeftJLabel_CountryDesc.setOptionalLabel();
		}
		return LeftJLabel_CountryDesc;
	}

	/**
	 * This method initializes LeftJText_CountryDesc
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getLeftJText_CountryDesc() {
		if (LeftJText_CountryDesc == null) {
			LeftJText_CountryDesc = new TextString(50,false);
//			LeftJText_CountryDesc.setBounds(172, 54, 202, 30);
		}
		return LeftJText_CountryDesc;
	}



	/**
	 * This method initializes rightPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */

	/**
	 * This method initializes generalPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected ColumnLayout getActionPanel() {
		if (generalPanel == null) {
			generalPanel = new ColumnLayout(4,1);
//			generalPanel.setSize(495, 110);
			//generalPanel.setBounds(1, 0, 607, 195);
			generalPanel.setHeading("Country Information");
			generalPanel.add(0,0,getRightJLabel_CountryCode());
			generalPanel.add(1,0,getRightJText_CountryCode());
			generalPanel.add(2,0,getRightJLabel_CountryDesc());
			generalPanel.add(3,0,getRightJText_CountryDesc());
		}
		return generalPanel;
	}

	/**
	 * This method initializes RightJLabel_CountryCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_CountryCode() {
		if (RightJLabel_CountryCode == null) {
			RightJLabel_CountryCode = new LabelBase();
			RightJLabel_CountryCode.setText("Country Code");
//			RightJLabel_CountryCode.setBounds(44, 33, 121, 20);
		}
		return RightJLabel_CountryCode;
	}

	/**
	 * This method initializes RightJText_CountryCode
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_CountryCode() {
		if (RightJText_CountryCode == null) {
			RightJText_CountryCode = new TextString(3,getListTable(), 0,false);

		}
		return RightJText_CountryCode;
	}

	/**
	 * This method initializes RightJLabel_CountryDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_CountryDesc() {
		if (RightJLabel_CountryDesc == null) {
			RightJLabel_CountryDesc = new LabelBase();
			RightJLabel_CountryDesc.setText("Country Description");
//			RightJLabel_CountryDesc.setBounds(44, 89, 133, 20);
		}
		return RightJLabel_CountryDesc;
	}

	/**
	 * This method initializes RightJText_CountryDesc
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_CountryDesc() {
		if (RightJText_CountryDesc == null) {
			RightJText_CountryDesc = new TextString(50,getListTable(), 1,false);
		}
		return RightJText_CountryDesc;
	}
}