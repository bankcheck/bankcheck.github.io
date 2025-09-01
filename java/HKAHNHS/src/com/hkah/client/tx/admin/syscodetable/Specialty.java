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
public class Specialty extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.SPECIALTY_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.SPECIALTY_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Specialty Code",
				"Specialty Name"
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
	private ColumnLayout leftPanel = null;  //  @jve:decl-index=0:visual-constraint="29,32"
	private LabelBase LeftJLabel_SpecialtyCode = null;
	private TextString LeftJText_SpecialtyCode = null;
	private LabelBase LeftJLabel_SpecialtyName = null;
	private TextString LeftJText_SpecialtyName = null;
	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;  //  @jve:decl-index=0:visual-constraint="10,142"
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_SpecialtyCode = null;
	private TextString RightJText_SpecialtyCode = null;
	private LabelBase RightJLabel_SpecialtyName = null;
	private TextString RightJText_SpecialtyName = null;
	/**
	 * This method initializes
	 *
	 */
	public Specialty() {
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
		return getLeftJText_SpecialtyCode();
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
		getRightJText_SpecialtyCode().setEnabled(false);
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
				getLeftJText_SpecialtyCode().getText(),
				getLeftJText_SpecialtyName().getText()
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
		getRightJText_SpecialtyCode().setText(outParam[index++]);                          // ROLNAM
		getRightJText_SpecialtyName().setText(outParam[index++]);                       // ROLDESC
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {
		if (getRightJText_SpecialtyCode().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Specialty Code!", getRightJText_SpecialtyCode());
			actionValidationReady(actionType, false);
		} else if (getRightJText_SpecialtyName().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Specialty Name!", getRightJText_SpecialtyName());
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
			Factory.getInstance().addErrorMessage("Empty Specialty Code!");
			return false;
		} else if (selectedContent[1].trim().length()==0 || selectedContent[1]==null) {
			Factory.getInstance().addErrorMessage("Empty Specialty Name!");
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
//			leftPanel.setSize(399, 100);
			leftPanel.add(0,0,getLeftJLabel_SpecialtyCode());
			leftPanel.add(1,0,getLeftJText_SpecialtyCode());
			leftPanel.add(2,0,getLeftJLabel_SpecialtyName());
			leftPanel.add(3,0,getLeftJText_SpecialtyName());
		}
		return leftPanel;
	}

	/**
	 * This method initializes LeftJLabel_SpecialtyCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */


	private LabelBase getLeftJLabel_SpecialtyCode() {
		if (LeftJLabel_SpecialtyCode == null) {
			LeftJLabel_SpecialtyCode = new LabelBase();
			LeftJLabel_SpecialtyCode.setText("Specialty Code:");
			LeftJLabel_SpecialtyCode.setOptionalLabel();
		}
		return LeftJLabel_SpecialtyCode;
	}

	/**
	 * This method initializes LeftJText_SpecialtyCode
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getLeftJText_SpecialtyCode() {
		if (LeftJText_SpecialtyCode == null) {
			LeftJText_SpecialtyCode = new TextString(10,true);
		}
		return LeftJText_SpecialtyCode;
	}

	/**
	 * This method initializes LeftJLabel_SpecialtyName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getLeftJLabel_SpecialtyName() {
		if (LeftJLabel_SpecialtyName == null) {
			LeftJLabel_SpecialtyName = new LabelBase();
			LeftJLabel_SpecialtyName.setText("Specialty Name:");
			LeftJLabel_SpecialtyName.setOptionalLabel();
		}
		return LeftJLabel_SpecialtyName;
	}

	/**
	 * This method initializes LeftJText_SpecialtyName
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getLeftJText_SpecialtyName() {
		if (LeftJText_SpecialtyName == null) {
			LeftJText_SpecialtyName = new TextString(50,true);
		}
		return LeftJText_SpecialtyName;
	}



			//rightPanel.setSize(684, 135);

	/**
	 * This method initializes generalPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected ColumnLayout getActionPanel() {
		if (generalPanel == null) {
			generalPanel = new ColumnLayout(4,1);
			generalPanel.setHeading("Specialty Information");
			generalPanel.add(0,0,getRightJLabel_SpecialtyCode());
			generalPanel.add(1,0,getRightJText_SpecialtyCode());
			generalPanel.add(2,0,getRightJLabel_SpecialtyName());
			generalPanel.add(3,0,getRightJText_SpecialtyName());
		}
		return generalPanel;
	}

	/**
	 * This method initializes RightJLabel_SpecialtyCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_SpecialtyCode() {
		if (RightJLabel_SpecialtyCode == null) {
			RightJLabel_SpecialtyCode = new LabelBase();
			RightJLabel_SpecialtyCode.setText("Specialty Code");
		}
		return RightJLabel_SpecialtyCode;
	}

	/**
	 * This method initializes RightJText_SpecialtyCode
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_SpecialtyCode() {
		if (RightJText_SpecialtyCode == null) {
			RightJText_SpecialtyCode = new TextString(10,getListTable(),0,true);
		}
		return RightJText_SpecialtyCode;
	}

	/**
	 * This method initializes RightJLabel_SpecialtyName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_SpecialtyName() {
		if (RightJLabel_SpecialtyName == null) {
			RightJLabel_SpecialtyName = new LabelBase();
			RightJLabel_SpecialtyName.setText("Specialty Name");
		}
		return RightJLabel_SpecialtyName;
	}

	/**
	 * This method initializes RightJText_SpecialtyName
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_SpecialtyName() {
		if (RightJText_SpecialtyName == null) {
			RightJText_SpecialtyName = new TextString(50,getListTable(),1,true);
		}
		return RightJText_SpecialtyName;
	}
}