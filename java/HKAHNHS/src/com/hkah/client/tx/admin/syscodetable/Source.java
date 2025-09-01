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
public class Source extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.SOURCE_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.SOURCE_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Source Code",
				"Source Description"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				100,
				100
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;  //  @jve:decl-index=0:visual-constraint="12,180"
	private LabelBase LeftJLabel_SourceCode = null;
	private TextString LeftJText_SourceCode = null;
	private LabelBase LeftJLabel_SourceDesc = null;
	private TextString LeftJText_SourceDesc = null;
	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;  //  @jve:decl-index=0:visual-constraint="12,14"
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_SourceCode = null;
	private TextString RightJText_SourceCode = null;
	private LabelBase RightJLabel_SourceDesc = null;
	private TextString RightJText_SourceDesc = null;
	/**
	 * This method initializes
	 *
	 */
	public Source() {
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
		return getLeftJText_SourceCode();
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
		getRightJText_SourceCode().setEnabled(false);
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
				getLeftJText_SourceCode().getText(),
				getLeftJText_SourceDesc().getText()
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
		getRightJText_SourceCode().setText(outParam[index++]);
		getRightJText_SourceDesc().setText(outParam[index++]);
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {
		if (getRightJText_SourceCode().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Source Code!", getRightJText_SourceCode());
			actionValidationReady(actionType, false);
		} else if (getRightJText_SourceDesc().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Source Description!", getRightJText_SourceDesc());
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
			Factory.getInstance().addErrorMessage("Empty Source Code!");
			return false;
		} else if (selectedContent[1].trim().length()==0 || selectedContent[1]==null) {
			Factory.getInstance().addErrorMessage("Empty Source Description!");
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
//			leftPanel.setSize(495, 110);
			leftPanel.add(0,0,getLeftJLabel_SourceCode());
			leftPanel.add(1,0,getLeftJText_SourceCode());
			leftPanel.add(2,0,getLeftJLabel_SourceDesc());
			leftPanel.add(3,0,getLeftJText_SourceDesc());
	}
		return leftPanel;
	}

	/**
	 * This method initializes LeftJLabel_SourceCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */


	private LabelBase getLeftJLabel_SourceCode() {
		if (LeftJLabel_SourceCode == null) {
			LeftJLabel_SourceCode = new LabelBase();
			LeftJLabel_SourceCode.setText("Source Code :");
			LeftJLabel_SourceCode.setOptionalLabel();
		}
		return LeftJLabel_SourceCode;
	}

	/**
	 * This method initializes LeftJText_SourceCode
	 *
	 * @return com.hkah.client.layout.textfield.TextSourceCode
	 */
	private TextString getLeftJText_SourceCode() {
		if (LeftJText_SourceCode == null) {
			LeftJText_SourceCode = new TextString(5,false);

		}
		return LeftJText_SourceCode;
	}
	/**
	 * This method initializes LeftJLabel_SourceDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getLeftJLabel_SourceDesc() {
		if (LeftJLabel_SourceDesc == null) {
			LeftJLabel_SourceDesc = new LabelBase();
			LeftJLabel_SourceDesc.setText("Source Description :");
			LeftJLabel_SourceDesc.setOptionalLabel();
		}
		return LeftJLabel_SourceDesc;
	}

	/**
	 * This method initializes LeftJText_SourceDesc
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getLeftJText_SourceDesc() {
		if (LeftJText_SourceDesc == null) {
			LeftJText_SourceDesc = new TextString(50,false);
		}
		return LeftJText_SourceDesc;
	}


			//rightPanel.setSize(695, 145);


	/**
	 * This method initializes generalPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected ColumnLayout getActionPanel() {
		if (generalPanel == null) {
			generalPanel = new ColumnLayout(4,1);
			generalPanel.setHeading("Source Information");
			generalPanel.add(0,0,getRightJLabel_SourceCode());
			generalPanel.add(1,0,getRightJText_SourceCode());
			generalPanel.add(2,0,getRightJLabel_SourceDesc());
			generalPanel.add(3,0,getRightJText_SourceDesc());



		}
		return generalPanel;
	}

	/**
	 * This method initializes RightJLabel_SourceCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_SourceCode() {
		if (RightJLabel_SourceCode == null) {
			RightJLabel_SourceCode = new LabelBase();
			RightJLabel_SourceCode.setText("Source Code");
		}
		return RightJLabel_SourceCode;
	}

	/**
	 * This method initializes RightJText_SourceCode
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_SourceCode() {
		if (RightJText_SourceCode == null) {
			RightJText_SourceCode = new TextString(5,getListTable(),0,false);
		}
		return RightJText_SourceCode;
	}

	/**
	 * This method initializes RightJLabel_SourceDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_SourceDesc() {
		if (RightJLabel_SourceDesc == null) {
			RightJLabel_SourceDesc = new LabelBase();
			RightJLabel_SourceDesc.setText("Source Description");
		}
		return RightJLabel_SourceDesc;
	}

	/**
	 * This method initializes RightJText_SourceDesc
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_SourceDesc() {
		if (RightJText_SourceDesc == null) {
			RightJText_SourceDesc = new TextString(50,getListTable(),1,false);
		}
		return RightJText_SourceDesc;
	}
}