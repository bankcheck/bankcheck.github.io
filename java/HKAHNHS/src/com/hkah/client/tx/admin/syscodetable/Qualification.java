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
public class Qualification extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.QUALIFICATION_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.QUALIFICATION_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Qualification Code",
				"Qualification Name"
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
	private LabelBase LeftJLabel_QualificationCode = null;
	private TextString LeftJText_QualificationCode = null;
	private LabelBase LeftJLabel_QualificationName = null;
	private TextString LeftJText_QualificationName = null;
	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_QualificationCode = null;
	private TextString RightJText_QualificationCode = null;
	private LabelBase RightJLabel_QualificationName = null;
	private TextString RightJText_QualificationName = null;
	/**
	 * This method initializes
	 *
	 */
	public Qualification() {
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
		return getLeftJText_QualificationCode();
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
		getRightJText_QualificationCode().setEnabled(false);
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
				getLeftJText_QualificationCode().getText(),
				getLeftJText_QualificationName().getText()
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
		getRightJText_QualificationCode().setText(outParam[index++]);
		getRightJText_QualificationName().setText(outParam[index++]);
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {
		if (getRightJText_QualificationCode().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Qualification Code!", getRightJText_QualificationCode());
			actionValidationReady(actionType, false);
		} else if (getRightJText_QualificationName().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Qualification Name!", getRightJText_QualificationName());
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
		if (selectedContent[0]==null || selectedContent[0].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty Qualfication Code!");
			return false;
		} else if (selectedContent[1]==null || selectedContent[1].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty Qualification Name!");
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
			leftPanel.add(0,0,getLeftJLabel_QualificationCode());
			leftPanel.add(1,0,getLeftJText_QualificationCode());
			leftPanel.add(2,0,getLeftJLabel_QualificationName());
			leftPanel.add(3,0,getLeftJText_QualificationName());
		}
		return leftPanel;
	}

	/**
	 * This method initializes LeftJLabel_QualificationCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */


	private LabelBase getLeftJLabel_QualificationCode() {
		if (LeftJLabel_QualificationCode == null) {
			LeftJLabel_QualificationCode = new LabelBase();
//			LeftJLabel_QualificationCode.setBounds(14, 15, 130, 20);
			LeftJLabel_QualificationCode.setText("Qualification Code:");
			LeftJLabel_QualificationCode.setOptionalLabel();
		}
		return LeftJLabel_QualificationCode;
	}

	/**
	 * This method initializes LeftJText_QualificationCode
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getLeftJText_QualificationCode() {
		if (LeftJText_QualificationCode == null) {
			LeftJText_QualificationCode = new TextString(22,true);
//			LeftJText_QualificationCode.setLocation(155, 15);
//			LeftJText_QualificationCode.setSize(123, 20);

		}
		return LeftJText_QualificationCode;
	}

	/**
	 * This method initializes LeftJLabel_QualificationName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getLeftJLabel_QualificationName() {
		if (LeftJLabel_QualificationName == null) {
			LeftJLabel_QualificationName = new LabelBase();
//			LeftJLabel_QualificationName.setBounds(14, 55, 132, 20);
			LeftJLabel_QualificationName.setText("Qualification Name:");
			LeftJLabel_QualificationName.setOptionalLabel();
		}
		return LeftJLabel_QualificationName;
	}

	/**
	 * This method initializes LeftJText_QualificationName
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getLeftJText_QualificationName() {
		if (LeftJText_QualificationName == null) {
			LeftJText_QualificationName = new TextString(50,true);
//			LeftJText_QualificationName.setLocation(156, 56);
//			LeftJText_QualificationName.setSize(232, 20);
		}
		return LeftJText_QualificationName;
	}


			//rightPanel.setSize(925, 151);

	/**
	 * This method initializes generalPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected ColumnLayout getActionPanel() {
		if (generalPanel == null) {
			generalPanel = new ColumnLayout(4,1);

			//generalPanel.setBounds(1, 0, 607, 140);
			generalPanel.setHeading("Qualification Information");
			generalPanel.add(0,0,getRightJLabel_QualificationCode());
			generalPanel.add(1,0,getRightJText_QualificationCode());
			generalPanel.add(2,0,getRightJLabel_QualificationName());
			generalPanel.add(3,0,getRightJText_QualificationName());
		}
		return generalPanel;
	}

	/**
	 * This method initializes RightJLabel_QualificationCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_QualificationCode() {
		if (RightJLabel_QualificationCode == null) {
			RightJLabel_QualificationCode = new LabelBase();
			RightJLabel_QualificationCode.setText("Qualification Code");
//			RightJLabel_QualificationCode.setBounds(46, 33, 122, 20);
		}
		return RightJLabel_QualificationCode;
	}

	/**
	 * This method initializes RightJText_QualificationCode
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_QualificationCode() {
		if (RightJText_QualificationCode == null) {
			RightJText_QualificationCode = new TextString(22,getListTable(),0);
//			RightJText_QualificationCode.setBounds(184, 33, 123, 20);

		}
		return RightJText_QualificationCode;
	}

	/**
	 * This method initializes RightJLabel_QualificationName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_QualificationName() {
		if (RightJLabel_QualificationName == null) {
			RightJLabel_QualificationName = new LabelBase();
			RightJLabel_QualificationName.setText("Qualification Name");
//			RightJLabel_QualificationName.setBounds(46, 75, 127, 20);
		}
		return RightJLabel_QualificationName;
	}

	/**
	 * This method initializes RightJText_QualificationName
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_QualificationName() {
		if (RightJText_QualificationName == null) {
			RightJText_QualificationName = new TextString(50,getListTable(), 1,true);
//			RightJText_QualificationName.setLocation(184, 75);
//			RightJText_QualificationName.setSize(352, 20);
		}
		return RightJText_QualificationName;
	}
}