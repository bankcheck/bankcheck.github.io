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
public class MotherLang extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.MOTHERLANG_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.MOTHERLANG_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Mother Language Code",
				"Mother Language Description"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				80,
				120
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;  //  @jve:decl-index=0:visual-constraint="10,649"
	private LabelBase LeftJLabel_MotherLanguageCode = null;
	private TextString LeftJText_MotherLanguageCode = null;
	private LabelBase LeftJLabel_MotherLanguageDesc = null;
	private TextString LeftJText_MotherLanguageDesc = null;
	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;  //  @jve:decl-index=0:visual-constraint="12,14"
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_MotherLanguageCode = null;
	private TextString RightJText_MotherLanguageCode = null;
	private LabelBase RightJLabel_MotherLanguageDesc = null;
	private TextString RightJText_MotherLanguageDesc = null;
	/**
	 * This method initializes
	 *
	 */
	public MotherLang() {
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
		return getLeftJText_MotherLanguageCode();
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
		getRightJText_MotherLanguageCode().setEnabled(false);
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
				getLeftJText_MotherLanguageCode().getText(),
				getLeftJText_MotherLanguageDesc().getText()
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
		getRightJText_MotherLanguageCode().setText(outParam[index++]);
		getRightJText_MotherLanguageDesc().setText(outParam[index++]);
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {
		if (getRightJText_MotherLanguageCode().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty MotherLanguage Code!", getRightJText_MotherLanguageCode());
			actionValidationReady(actionType, false);
		} else if (getRightJText_MotherLanguageDesc().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty MotherLanguage Description!", getRightJText_MotherLanguageDesc());
			actionValidationReady(actionType, false);
		} else {
			actionValidationReady(actionType, true);
		}
	}

	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		return new String[] {
				selectedContent[0],
				selectedContent[1]
		};
	}

	@Override
	protected boolean actionValidation(String[] selectedContent) {
		if (selectedContent[0]==null || selectedContent[0].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty Mother Language Code!");
			return false;
		} else if (selectedContent[1]==null || selectedContent[1].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty MotherLanguage Description!");
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
//			leftPanel.setSize(495, 90);
			leftPanel.add(0,0,getLeftJLabel_MotherLanguageCode());
			leftPanel.add(1,0,getLeftJText_MotherLanguageCode());
			leftPanel.add(2,0,getLeftJLabel_MotherLanguageDesc());
			leftPanel.add(3,0,getLeftJText_MotherLanguageDesc());
	}
		return leftPanel;
	}

	/**
	 * This method initializes LeftJLabel_MotherLanguageCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */


	private LabelBase getLeftJLabel_MotherLanguageCode() {
		if (LeftJLabel_MotherLanguageCode == null) {
			LeftJLabel_MotherLanguageCode = new LabelBase();
//			LeftJLabel_MotherLanguageCode.setBounds(16, 15, 166, 20);
			LeftJLabel_MotherLanguageCode.setText("Mother Language Code :");
			LeftJLabel_MotherLanguageCode.setOptionalLabel();
		}
		return LeftJLabel_MotherLanguageCode;
	}

	/**
	 * This method initializes LeftJText_MotherLanguageCode
	 *
	 * @return com.hkah.client.layout.textfield.TextMotherLanguageCode
	 */
	private TextString getLeftJText_MotherLanguageCode() {
		if (LeftJText_MotherLanguageCode == null) {
			LeftJText_MotherLanguageCode = new TextString(3,false);
//			LeftJText_MotherLanguageCode.setLocation(225, 17);
//			LeftJText_MotherLanguageCode.setSize(50, 20);

		}
		return LeftJText_MotherLanguageCode;
	}
	/**
	 * This method initializes LeftJLabel_MotherLanguageDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getLeftJLabel_MotherLanguageDesc() {
		if (LeftJLabel_MotherLanguageDesc == null) {
			LeftJLabel_MotherLanguageDesc = new LabelBase();
//			LeftJLabel_MotherLanguageDesc.setBounds(16, 50, 196, 20);
			LeftJLabel_MotherLanguageDesc.setText("Mother Language Description :");
			LeftJLabel_MotherLanguageDesc.setOptionalLabel();
		}
		return LeftJLabel_MotherLanguageDesc;
	}

	/**
	 * This method initializes LeftJText_MotherLanguageDesc
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getLeftJText_MotherLanguageDesc() {
		if (LeftJText_MotherLanguageDesc == null) {
			LeftJText_MotherLanguageDesc = new TextString(20,false);
//			LeftJText_MotherLanguageDesc.setLocation(226, 50);
//			LeftJText_MotherLanguageDesc.setSize(158, 20);
		}
		return LeftJText_MotherLanguageDesc;
	}




			//rightPanel.setSize(610, 120);

	/**
	 * This method initializes generalPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected ColumnLayout getActionPanel() {
		if (generalPanel == null) {
			generalPanel = new ColumnLayout(4,1);
			//generalPanel.setBounds(1, 0, 607, 100);
			generalPanel.setHeading("Mother Language Information");
			generalPanel.add(0,0,getRightJLabel_MotherLanguageCode());
			generalPanel.add(1,0,getRightJText_MotherLanguageCode());
			generalPanel.add(2,0,getRightJLabel_MotherLanguageDesc());
			generalPanel.add(3,0,getRightJText_MotherLanguageDesc());
		}
		return generalPanel;
	}

	/**
	 * This method initializes RightJLabel_MotherLanguageCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_MotherLanguageCode() {
		if (RightJLabel_MotherLanguageCode == null) {
			RightJLabel_MotherLanguageCode = new LabelBase();
			RightJLabel_MotherLanguageCode.setText("Mother Language Code");
//			RightJLabel_MotherLanguageCode.setBounds(44, 33, 149, 20);
		}
		return RightJLabel_MotherLanguageCode;
	}

	/**
	 * This method initializes RightJText_MotherLanguageCode
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_MotherLanguageCode() {
		if (RightJText_MotherLanguageCode == null) {
			RightJText_MotherLanguageCode = new TextString(3,getListTable(), 0,false);
//			RightJText_MotherLanguageCode.setBounds(249, 32, 64, 20);

		}
		return RightJText_MotherLanguageCode;
	}

	/**
	 * This method initializes RightJLabel_MotherLanguageDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_MotherLanguageDesc() {
		if (RightJLabel_MotherLanguageDesc == null) {
			RightJLabel_MotherLanguageDesc = new LabelBase();
			RightJLabel_MotherLanguageDesc.setText("MotherLanguage Description");
//			RightJLabel_MotherLanguageDesc.setBounds(44, 70, 187, 20);
		}
		return RightJLabel_MotherLanguageDesc;
	}

	/**
	 * This method initializes RightJText_MotherLanguageDesc
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_MotherLanguageDesc() {
		if (RightJText_MotherLanguageDesc == null) {
			RightJText_MotherLanguageDesc = new TextString(20,getListTable(),1,false);
//			RightJText_MotherLanguageDesc.setLocation(250, 70);
//			RightJText_MotherLanguageDesc.setSize(225, 20);
		}
		return RightJText_MotherLanguageDesc;
	}
}