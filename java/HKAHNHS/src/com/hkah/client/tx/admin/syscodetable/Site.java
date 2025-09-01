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
public class Site extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.SITE_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.SITE_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Site Code",
				"Site Name",
				"Site Logo"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				100,
				150,
				100
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;  //  @jve:decl-index=0:visual-constraint="12,200"
	private LabelBase LeftJLabel_SiteCode = null;
	private TextString LeftJText_SiteCode = null;
	private LabelBase LeftJLabel_SiteName = null;
	private TextString LeftJText_SiteName = null;
	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;  //  @jve:decl-index=0:visual-constraint="12,14"
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_SiteCode = null;
	private TextString RightJText_SiteCode = null;
	private LabelBase RightJLabel_SiteName = null;
	private TextString RightJText_SiteName = null;
	private LabelBase RightJLabel_SiteLogo = null;
	private TextString RightJText_SiteLogo = null;

	/**
	 * This method initializes
	 *
	 */
	public Site() {
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
		return getLeftJText_SiteCode();
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
		getRightJText_SiteCode().setEnabled(false);
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
				getLeftJText_SiteCode().getText(),
				getLeftJText_SiteName().getText()
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
		getRightJText_SiteCode().setText(outParam[index++]);
		getRightJText_SiteName().setText(outParam[index++]);
		getRightJText_SiteLogo().setText(outParam[index++]);
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {
		if (getRightJText_SiteCode().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Site Code!", getRightJText_SiteCode());
			actionValidationReady(actionType, false);
		} else if (getRightJText_SiteName().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Site Name!", getRightJText_SiteName());
			actionValidationReady(actionType, false);
		} else if (getRightJText_SiteLogo().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Site Logo!", getRightJText_SiteName());
			actionValidationReady(actionType, false);
		} else {
			actionValidationReady(actionType, true);
		}
	}

	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		return new String[] {
				selectedContent[0],
				selectedContent[1],
				selectedContent[2]
        };
	}

	@Override
	protected boolean actionValidation(String[] selectedContent) {
		// TODO Auto-generated method stub
		if (selectedContent[0]==null || selectedContent[0].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty site Code!");
			return false;
		} else if (selectedContent[1]==null || selectedContent[1].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty site Name!");
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
//			leftPanel.setSize(458, 90);
			leftPanel.add(0,0,getLeftJLabel_SiteCode());
			leftPanel.add(1,0,getLeftJText_SiteCode());
			leftPanel.add(2,0,getLeftJLabel_SiteName());
			leftPanel.add(3,0,getLeftJText_SiteName());
		}
		return leftPanel;
	}

	/**
	 * This method initializes LeftJLabel_SiteCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */


	private LabelBase getLeftJLabel_SiteCode() {
		if (LeftJLabel_SiteCode == null) {
			LeftJLabel_SiteCode = new LabelBase();
			LeftJLabel_SiteCode.setText("Site Code :");
			LeftJLabel_SiteCode.setOptionalLabel();
		}
		return LeftJLabel_SiteCode;
	}

	/**
	 * This method initializes LeftJText_SiteCode
	 *
	 * @return com.hkah.client.layout.textfield.TextSiteCode
	 */
	private TextString getLeftJText_SiteCode() {
		if (LeftJText_SiteCode == null) {
			LeftJText_SiteCode = new TextString(50,false);
		}
		return LeftJText_SiteCode;
	}

	/**
	 * This method initializes LeftJLabel_SiteName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getLeftJLabel_SiteName() {
		if (LeftJLabel_SiteName == null) {
			LeftJLabel_SiteName = new LabelBase();
			LeftJLabel_SiteName.setText("Site Name :");
			LeftJLabel_SiteName.setOptionalLabel();
		}
		return LeftJLabel_SiteName;
	}

	/**
	 * This method initializes LeftJText_SiteName
	 *
	 * @return com.hkah.client.layout.textfield.TextBase
	 */
	private TextBase getLeftJText_SiteName() {
		if (LeftJText_SiteName == null) {
			LeftJText_SiteName = new TextDesc();
		}
		return LeftJText_SiteName;
	}



	/**
	 * This method initializes rightPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */

			//rightPanel.setSize(526, 125);



	@Override
	protected ColumnLayout getActionPanel() {
		if (generalPanel == null) {
			generalPanel = new ColumnLayout(4,2);
			generalPanel.setHeading("Site Information");
			generalPanel.add(0,0,getRightJLabel_SiteCode());
			generalPanel.add(1,0,getRightJText_SiteCode());
			generalPanel.add(2,0,getRightJLabel_SiteName());
			generalPanel.add(3,0,getRightJText_SiteName());
			generalPanel.add(0,1,getRightJLabel_SiteLogo());
			generalPanel.add(1,1,getRightJText_SiteLogo());
		}
		return generalPanel;
	}

	/**
	 * This method initializes RightJLabel_SiteCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_SiteCode() {
		if (RightJLabel_SiteCode == null) {
			RightJLabel_SiteCode = new LabelBase();
			RightJLabel_SiteCode.setText("Site Code");
		}
		return RightJLabel_SiteCode;
	}

	/**
	 * This method initializes RightJText_SiteCode
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_SiteCode() {
		if (RightJText_SiteCode == null) {
			RightJText_SiteCode = new TextString(10,getListTable(),0,false);
		}
		return RightJText_SiteCode;
	}

	/**
	 * This method initializes RightJLabel_SiteName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_SiteName() {
		if (RightJLabel_SiteName == null) {
			RightJLabel_SiteName = new LabelBase();
			RightJLabel_SiteName.setText("Site Name");
		}
		return RightJLabel_SiteName;
	}

	/**
	 * This method initializes RightJText_SiteName
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_SiteName() {
		if (RightJText_SiteName == null) {
			RightJText_SiteName = new TextString(50,getListTable(),1,false);
		}
		return RightJText_SiteName;
	}


	/**
	 * This method initializes RightJLabel_SiteLogo
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_SiteLogo() {
		if (RightJLabel_SiteLogo == null) {
			RightJLabel_SiteLogo = new LabelBase();
			RightJLabel_SiteLogo.setText("Site Logo");
		}
		return RightJLabel_SiteLogo;
	}

	/**
	 * This method initializes RightJText_SiteLogo
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_SiteLogo() {
		if (RightJText_SiteLogo == null) {
			RightJText_SiteLogo = new TextString(100,getListTable(), 2,false);

		}
		return RightJText_SiteLogo;
	}
}