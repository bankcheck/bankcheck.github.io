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
public class CustomReport extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.CUSTOMREPORT_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.CUSTOMREPORT_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"report ID",
				"Report Name",
				"Report Path"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				0,
				100,
				100
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;  //  @jve:decl-index=0:visual-constraint="10,649"
	private LabelBase LeftJLabel_ReportName = null;
	private TextString LeftJText_ReportName = null;
	private LabelBase LeftJLabel_ReportPath = null;
	private TextString LeftJText_ReportPath = null;
	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;  //  @jve:decl-index=0:visual-constraint="12,14"
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_ReportName = null;
	private TextString RightJText_ReportName = null;
	private LabelBase RightJLabel_ReportPath = null;
	private TextString RightJText_ReportPath = null;
	/**
	 * This method initializes
	 *
	 */
	public CustomReport() {
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
		return getLeftJText_ReportName();
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
		getRightJText_ReportName().setEnabled(false);
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
				getLeftJText_ReportName().getText(),
				getLeftJText_ReportPath().getText()
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
		index++;
		getRightJText_ReportName().setText(outParam[index++]);
		getRightJText_ReportPath().setText(outParam[index++]);
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {
		if (getRightJText_ReportName().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Report Name!", getRightJText_ReportName());
			actionValidationReady(actionType, false);
		} else if (getRightJText_ReportPath().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Report Path!", getRightJText_ReportPath());
			actionValidationReady(actionType, false);
		} else {
			actionValidationReady(actionType, true);
		}
	}

	/* >>> ~22~ Set Action Input Parameters per table ===================== <<< */
	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		return new String[] {
				//selectedContent[0],
				selectedContent[1],
				selectedContent[2]
		};
	}

	/* >>> ~23~ Set Action Validation per table =========================== <<< */
	@Override
	protected boolean actionValidation(String[] selectedContent) {
		// TODO Auto-generated method stub
		if (selectedContent[1]==null || selectedContent[1].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty Report Name!");
			return false;
		} else if (selectedContent[2]==null || selectedContent[2].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty Report Path!");
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
//			leftPanel.setSize(495, 110);
			leftPanel.add(0,0,getLeftJLabel_ReportName());
			leftPanel.add(1,0,getLeftJText_ReportName());
			leftPanel.add(0,1,getLeftJLabel_ReportPath());
			leftPanel.add(1,1,getLeftJText_ReportPath());
	}
		return leftPanel;
	}

	/**
	 * This method initializes LeftJLabel_ReportName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */


	private LabelBase getLeftJLabel_ReportName() {
		if (LeftJLabel_ReportName == null) {
			LeftJLabel_ReportName = new LabelBase();
//			LeftJLabel_ReportName.setBounds(16, 15, 98, 20);
			LeftJLabel_ReportName.setText("Report Name :");
			LeftJLabel_ReportName.setOptionalLabel();
		}
		return LeftJLabel_ReportName;
	}

	/**
	 * This method initializes LeftJText_ReportName
	 *
	 * @return com.hkah.client.layout.textfield.TextReportName
	 */
	private TextString getLeftJText_ReportName() {
		if (LeftJText_ReportName == null) {
			LeftJText_ReportName = new TextString(50,false);
//			LeftJText_ReportName.setBounds(129, 14, 130, 20);

		}
		return LeftJText_ReportName;
	}
	/**
	 * This method initializes LeftJLabel_ReportPath
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getLeftJLabel_ReportPath() {
		if (LeftJLabel_ReportPath == null) {
			LeftJLabel_ReportPath = new LabelBase();
//			LeftJLabel_ReportPath.setBounds(16, 55, 98, 20);
			LeftJLabel_ReportPath.setText("Report Path :");
			LeftJLabel_ReportPath.setOptionalLabel();
		}
		return LeftJLabel_ReportPath;
	}

	/**
	 * This method initializes LeftJText_ReportPath
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getLeftJText_ReportPath() {
		if (LeftJText_ReportPath == null) {
			LeftJText_ReportPath = new TextString(200,false);
//			LeftJText_ReportPath.setBounds(130, 53, 222, 20);
		}
		return LeftJText_ReportPath;
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
//			generalPanel.setBounds(1, 0, 607, 195);
			generalPanel.setHeading("Custom Information");
			generalPanel.add(0,0,getRightJLabel_ReportName());
			generalPanel.add(1,0,getRightJText_ReportName());
			generalPanel.add(2,0,getRightJLabel_ReportPath());
			generalPanel.add(3,0,getRightJText_ReportPath());
		}
		return generalPanel;
	}

	/**
	 * This method initializes RightJLabel_ReportName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_ReportName() {
		if (RightJLabel_ReportName == null) {
			RightJLabel_ReportName = new LabelBase();
			RightJLabel_ReportName.setText("Report Name");
//			RightJLabel_ReportName.setBounds(44, 33, 96, 20);
		}
		return RightJLabel_ReportName;
	}

	/**
	 * This method initializes RightJText_ReportName
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_ReportName() {
		if (RightJText_ReportName == null) {
			RightJText_ReportName = new TextString(50,getListTable(),1,false);

		}
		return RightJText_ReportName;
	}

	/**
	 * This method initializes RightJLabel_ReportPath
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_ReportPath() {
		if (RightJLabel_ReportPath == null) {
			RightJLabel_ReportPath = new LabelBase();
			RightJLabel_ReportPath.setText("Report Path");
//			RightJLabel_ReportPath.setBounds(44, 89, 94, 20);
		}
		return RightJLabel_ReportPath;
	}

	/**
	 * This method initializes RightJText_ReportPath
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_ReportPath() {
		if (RightJText_ReportPath == null) {
			RightJText_ReportPath = new TextString(200,getListTable(), 2,false);

		}
		return RightJText_ReportPath;
	}
}