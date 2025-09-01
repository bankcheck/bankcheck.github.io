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
public class Title extends MaintenancePanel {
	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.TITLE_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.TITLE_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Title",
				"Title2"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				100,0
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;  //  @jve:decl-index=0:visual-constraint="10,649"
	private LabelBase LeftJLabel_Title = null;
	private TextString LeftJText_Title = null;
	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;  //  @jve:decl-index=0:visual-constraint="12,14"
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_Title = null;
	private TextString RightJText_Title = null;
	/**
	 * This method initializes
	 *
	 */
	public Title() {
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
		return getLeftJText_Title();
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
		getListTable().setEnabled(false);
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
				getLeftJText_Title().getText()
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
		getRightJText_Title().setText(outParam[index++]);
	}


	/* >>> ~22~ Set Action Input Parameters per table ===================== <<< */
	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		// TODO Auto-generated method stub
		String[] param=new String[] {
			selectedContent[0],
			selectedContent[1]
		};
		return param;
	}

	/* >>> ~23~ Set Action Validation per table =========================== <<< */
	@Override
	protected boolean actionValidation(String[] selectedContent) {
		// TODO Auto-generated method stub
		if (selectedContent[0]==null ||selectedContent[0].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty Title!");
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
			leftPanel = new ColumnLayout(2,1);
//			leftPanel.setSize(495, 80);
			leftPanel.add(0,0,getLeftJLabel_Title());
			leftPanel.add(1,0,getLeftJText_Title());
		}
		return leftPanel;
	}

	/**
	 * This method initializes LeftJLabel_Title
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getLeftJLabel_Title() {
		if (LeftJLabel_Title == null) {
			LeftJLabel_Title = new LabelBase();
//			LeftJLabel_Title.setBounds(16, 15, 74, 20);
			LeftJLabel_Title.setText("Title :");
			LeftJLabel_Title.setOptionalLabel();
		}
		return LeftJLabel_Title;
	}

	/**
	 * This method initializes LeftJText_Title
	 *
	 * @return com.hkah.client.layout.textfield.TextTitle
	 */
	private TextString getLeftJText_Title() {
		if (LeftJText_Title == null) {
			LeftJText_Title = new TextString(20,false);
//			LeftJText_Title.setLocation(129, 17);
//			LeftJText_Title.setSize(164, 20);

		}
		return LeftJText_Title;
	}
			//rightPanel.add(getGeneralPanel());

	/**
	 * This method initializes generalPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected ColumnLayout getActionPanel() {
		if (generalPanel == null) {
			generalPanel = new ColumnLayout(2,1);
			//generalPanel.setBounds(1, 0, 607, 195);
			generalPanel.setHeading("Title Information");
			generalPanel.add(0,0,getRightJLabel_Title());
			generalPanel.add(1,0,getRightJText_Title());
		}
		return generalPanel;
	}

	/**
	 * This method initializes RightJLabel_Title
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_Title() {
		if (RightJLabel_Title == null) {
			RightJLabel_Title = new LabelBase();
			RightJLabel_Title.setText("Title");
//			RightJLabel_Title.setBounds(44, 33, 61, 20);
		}
		return RightJLabel_Title;
	}

	/**
	 * This method initializes RightJText_Title
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_Title() {
		if (RightJText_Title == null) {
			RightJText_Title = new TextString(20,getListTable(),0,false);

		}
		return RightJText_Title;
	}
}