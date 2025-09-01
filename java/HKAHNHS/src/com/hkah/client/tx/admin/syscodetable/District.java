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
import com.hkah.client.layout.textfield.TextDesc;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MaintenancePanel;
import com.hkah.shared.constants.ConstantsTx;


/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class District extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.DISTRICT_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.DISTRICT_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"District Code",
				"District Name"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				100,
				150
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;  //  @jve:decl-index=0:visual-constraint="14,162"
	private LabelBase LeftJLabel_DistrictCode = null;
	private TextString LeftJText_DistrictCode = null;
	private LabelBase LeftJLabel_DistrictName = null;
	private TextString LeftJText_DistrictName = null;
	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;  //  @jve:decl-index=0:visual-constraint="12,14"
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_DistrictCode = null;
	private TextString RightJText_DistrictCode = null;
	private LabelBase RightJLabel_DistrictName = null;
	private TextString RightJText_DistrictName = null;
	/**
	 * This method initializes
	 *
	 */
	public District() {
		//super(MasterPanel.FLAT_LAYOUT);
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
		return getLeftJText_DistrictCode();
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
		getRightJText_DistrictCode().setEnabled(false);
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
				getLeftJText_DistrictCode().getText(),
				getLeftJText_DistrictName().getText()
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
		getRightJText_DistrictCode().setText(outParam[index++]);
		getRightJText_DistrictName().setText(outParam[index++]);
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {
		if (getRightJText_DistrictCode().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty District Code!", getRightJText_DistrictCode());
			actionValidationReady(actionType, false);
		} else if (getRightJText_DistrictName().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty District Name!", getRightJText_DistrictName());
			actionValidationReady(actionType, false);
		} else {
			actionValidationReady(actionType, true);
		}
	}

	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		// TODO Auto-generated method stub
		return new String[] {
			selectedContent[0],
			selectedContent[1]
		};
	}

	@Override
	protected boolean actionValidation(String[] selectedContent) {
		// TODO Auto-generated method stub
		if (selectedContent[0].trim().length()==0 || selectedContent[0]==null) {
			Factory.getInstance().addErrorMessage("Empty District Code!");
			return false;
		} else if (selectedContent[1].trim().length()==0 || selectedContent[1]==null) {
			Factory.getInstance().addErrorMessage("Empty District Name!");
			return false;
		}
		return true;
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
//			leftPanel.setSize(476, 105);
			leftPanel.add(0,0,getLeftJLabel_DistrictCode());
			leftPanel.add(1,0,getLeftJText_DistrictCode());
			leftPanel.add(2,0,getLeftJLabel_DistrictName());
			leftPanel.add(3,0,getLeftJText_DistrictName());
		}
		return leftPanel;
	}

	/**
	 * This method initializes LeftJLabel_DistrictCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */


	private LabelBase getLeftJLabel_DistrictCode() {
		if (LeftJLabel_DistrictCode == null) {
			LeftJLabel_DistrictCode = new LabelBase();
			LeftJLabel_DistrictCode.setText("District Code :");
			LeftJLabel_DistrictCode.setOptionalLabel();
		}
		return LeftJLabel_DistrictCode;
	}

	/**
	 * This method initializes LeftJText_DistrictCode
	 *
	 * @return com.hkah.client.layout.textfield.TextDistrictCode
	 */
	private TextString getLeftJText_DistrictCode() {
		if (LeftJText_DistrictCode == null) {
			LeftJText_DistrictCode = new TextString(50,false);
		}
		return LeftJText_DistrictCode;
	}

	/**
	 * This method initializes LeftJLabel_DistrictName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getLeftJLabel_DistrictName() {
		if (LeftJLabel_DistrictName == null) {
			LeftJLabel_DistrictName = new LabelBase();
			LeftJLabel_DistrictName.setText("District Name :");
			LeftJLabel_DistrictName.setOptionalLabel();
		}
		return LeftJLabel_DistrictName;
	}

	/**
	 * This method initializes LeftJText_DistrictName
	 *
	 * @return com.hkah.client.layout.textfield.TextBase
	 */
	private TextBase getLeftJText_DistrictName() {
		if (LeftJText_DistrictName == null) {
			LeftJText_DistrictName = new TextDesc();
		}
		return LeftJText_DistrictName;
	}



	/**
	 * This method initializes generalPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected ColumnLayout getActionPanel() {
		if (generalPanel == null) {
			generalPanel = new ColumnLayout(4,1);
			generalPanel.setHeading("District Information");
			generalPanel.add(0,0,getRightJLabel_DistrictCode());
			generalPanel.add(1,0,getRightJText_DistrictCode());
			generalPanel.add(2,0,getRightJLabel_DistrictName());
			generalPanel.add(3,0,getRightJText_DistrictName());

		}
		return generalPanel;
	}

	/**
	 * This method initializes RightJLabel_DistrictCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_DistrictCode() {
		if (RightJLabel_DistrictCode == null) {
			RightJLabel_DistrictCode = new LabelBase();
			RightJLabel_DistrictCode.setText("District Code");
		}
		return RightJLabel_DistrictCode;
	}

	/**
	 * This method initializes RightJText_DistrictCode
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_DistrictCode() {
		if (RightJText_DistrictCode == null) {
			RightJText_DistrictCode = new TextString(10,getListTable(),0,false);

		}
		return RightJText_DistrictCode;
	}

	/**
	 * This method initializes RightJLabel_DistrictName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_DistrictName() {
		if (RightJLabel_DistrictName == null) {
			RightJLabel_DistrictName = new LabelBase();
			RightJLabel_DistrictName.setText("District Name");
		}
		return RightJLabel_DistrictName;
	}

	/**
	 * This method initializes RightJText_DistrictName
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_DistrictName() {
		if (RightJText_DistrictName == null) {
			RightJText_DistrictName = new TextString(50,getListTable(), 1,false);
		}
		return RightJText_DistrictName;
	}
}