/*
 * Created on July 23, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.tx.admin.codetable;

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
public class GLCode extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.GLCODE_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.GLCODE_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"GLCode Code",
				"General Ledger Name",
				"Site Code"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				80,
				100,
				0
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;  //  @jve:decl-index=0:visual-constraint="10,649"
	private LabelBase LeftJLabel_GLCodeCode = null;
	private TextString LeftJText_GLCodeCode = null;
	private LabelBase LeftJLabel_GLCodeName = null;
	private TextString LeftJText_GLCodeName = null;
	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;  //  @jve:decl-index=0:visual-constraint="12,14"
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_GLCodeCode = null;
	private TextString RightJText_GLCodeCode = null;
	private LabelBase RightJLabel_GLCodeName = null;
	private TextString RightJText_GLCodeName = null;
	/**
	 * This method initializes
	 *
	 */
	public GLCode() {
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
		return getLeftJText_GLCodeCode();
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
		getRightJText_GLCodeCode().setEnabled(false);
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
				getLeftJText_GLCodeCode().getText(),
				getLeftJText_GLCodeName().getText()
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
		getRightJText_GLCodeCode().setText(outParam[index++]);
		getRightJText_GLCodeName().setText(outParam[index++]);
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {
		if (getRightJText_GLCodeCode().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty GLCode Code!", getRightJText_GLCodeCode());
			actionValidationReady(actionType, false);
		} else if (getRightJText_GLCodeName().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty General Ledger Name!", getRightJText_GLCodeName());
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
				selectedContent[1],
		};
	}

	@Override
	protected boolean actionValidation(String[] selectedContent) {
		// TODO Auto-generated method stub
		if (selectedContent[0] == null || selectedContent[0].trim().length() == 0) {
			Factory.getInstance().addErrorMessage("Empty GLCode Code!");
			return false;
		} else if (selectedContent[1] == null || selectedContent[1].trim().length() == 0) {
			Factory.getInstance().addErrorMessage("Empty General Ledger Name!");
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
			leftPanel = new ColumnLayout(2,2);
//			leftPanel.setSize(495, 91);
			leftPanel.add(0,0,getLeftJLabel_GLCodeCode());
			leftPanel.add(1,0,getLeftJText_GLCodeCode());
			leftPanel.add(0,1,getLeftJLabel_GLCodeName());
			leftPanel.add(1,1,getLeftJText_GLCodeName());
	}
		return leftPanel;
	}

	/**
	 * This method initializes LeftJLabel_GLCodeCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getLeftJLabel_GLCodeCode() {
		if (LeftJLabel_GLCodeCode == null) {
			LeftJLabel_GLCodeCode = new LabelBase();
//			LeftJLabel_GLCodeCode.setBounds(16, 15, 146, 20);
			LeftJLabel_GLCodeCode.setText("GLCode Code :");
			LeftJLabel_GLCodeCode.setOptionalLabel();
		}
		return LeftJLabel_GLCodeCode;
	}

	/**
	 * This method initializes LeftJText_GLCodeCode
	 *
	 * @return com.hkah.client.layout.textfield.TextGLCodeCode
	 */
	private TextString getLeftJText_GLCodeCode() {
		if (LeftJText_GLCodeCode == null) {
			LeftJText_GLCodeCode = new TextString(8,false);
//			LeftJText_GLCodeCode.setLocation(172, 17);
//			LeftJText_GLCodeCode.setSize(95, 20);

		}
		return LeftJText_GLCodeCode;
	}
	/**
	 * This method initializes LeftJLabel_GLCodeName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getLeftJLabel_GLCodeName() {
		if (LeftJLabel_GLCodeName == null) {
			LeftJLabel_GLCodeName = new LabelBase();
//			LeftJLabel_GLCodeName.setBounds(16, 50, 147, 20);
			LeftJLabel_GLCodeName.setText("General Ledger Name :");
			LeftJLabel_GLCodeName.setOptionalLabel();
		}
		return LeftJLabel_GLCodeName;
	}

	/**
	 * This method initializes LeftJText_GLCodeName
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getLeftJText_GLCodeName() {
		if (LeftJText_GLCodeName == null) {
			LeftJText_GLCodeName = new TextString(20,false);
//			LeftJText_GLCodeName.setLocation(172, 50);
//			LeftJText_GLCodeName.setSize(202, 20);
		}
		return LeftJText_GLCodeName;
	}

	/**
	 * This method initializes generalPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected ColumnLayout getActionPanel() {
		if (generalPanel == null) {
			generalPanel = new ColumnLayout(4,1);
			//generalPanel.setBounds(1, 0, 607, 115);
			generalPanel.setHeading("GLCode Information");
			generalPanel.add(0,0,getRightJLabel_GLCodeCode());
			generalPanel.add(1,0,getRightJText_GLCodeCode());
			generalPanel.add(2,0,getRightJLabel_GLCodeName());
			generalPanel.add(3,0,getRightJText_GLCodeName());
		}
		return generalPanel;
	}

	/**
	 * This method initializes RightJLabel_GLCodeCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_GLCodeCode() {
		if (RightJLabel_GLCodeCode == null) {
			RightJLabel_GLCodeCode = new LabelBase();
			RightJLabel_GLCodeCode.setText("GLCode Code");
//			RightJLabel_GLCodeCode.setBounds(44, 33, 143, 20);
		}
		return RightJLabel_GLCodeCode;
	}

	/**
	 * This method initializes RightJText_GLCodeCode
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_GLCodeCode() {
		if (RightJText_GLCodeCode == null) {
			RightJText_GLCodeCode = new TextString(8,false) {
				public void onReleased() {
					setCurrentTable(0,RightJText_GLCodeCode.getText());
				}
			};
//			RightJText_GLCodeCode.setBounds(217, 34, 101, 20);
		}
		return RightJText_GLCodeCode;
	}

	/**
	 * This method initializes RightJLabel_GLCodeName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_GLCodeName() {
		if (RightJLabel_GLCodeName == null) {
			RightJLabel_GLCodeName = new LabelBase();
			RightJLabel_GLCodeName.setText("General Ledger Name");
//			RightJLabel_GLCodeName.setBounds(44, 65, 144, 20);
		}
		return RightJLabel_GLCodeName;
	}

	/**
	 * This method initializes RightJText_GLCodeName
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_GLCodeName() {
		if (RightJText_GLCodeName == null) {
			RightJText_GLCodeName = new TextString(20,false) {
				public void onReleased() {
					setCurrentTable(1,RightJText_GLCodeName.getText());
				}
			};
//			RightJText_GLCodeName.setLocation(216, 65);
//			RightJText_GLCodeName.setSize(257, 20);
		}
		return RightJText_GLCodeName;
	}
}