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
import com.hkah.client.util.PanelUtil;
import com.hkah.shared.constants.ConstantsTx;


/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class Location extends MaintenancePanel {

	@Override
	public void clearAction() {
		PanelUtil.resetColumnLayoutAllFields(getActionPanel());
	}

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.LOCATION_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.LOCATION_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Location Code",
				"Location Name",
				"District Code",
				"District Name",
				"Site Code"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				100,
				120,
				100,
				120,
				0
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;  //  @jve:decl-index=0:visual-constraint="15,217"
	private LabelBase LeftJLabel_LocationCode = null;
	private TextString LeftJText_LocationCode = null;
	private LabelBase LeftJLabel_LocationName = null;
	private TextString LeftJText_LocationName = null;
	private LabelBase LeftJLabel_DistrictCode = null;
	private TextString LeftJText_DistrictCode = null;


	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;  //  @jve:decl-index=0:visual-constraint="12,14"
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_LocationCode = null;
	private TextString RightJText_LocationCode = null;
	private LabelBase RightJLabel_LocationName = null;
	private TextString RightJText_LocationName = null;
	private LabelBase RightJLabel_DistrictCode = null;
	private TextString RightJText_DistrictCode = null;

//	@Override
//	protected void onRender(Element parent, int index) {
//		super.onRender(parent, index);
//		initUI();
//	}
//
//	protected void initUI() {
//		add(getBodyPanel());
//	}
//
//	protected LayoutContainer getBodyPanel() {
//		FormPanel panle = new FormPanel();
//		panle.setLayout(new FlowLayout());
//		panle.setFrame(false);
//		panle.setHeaderVisible(false);
//		panle.setBorders(false);
//		panle.setBodyBorder(false);
//		//panle.add(getSearchPanel());
//		panle.add(getLeftPanel());
//		panle.add(getActionPanel());
//		//panle.add(getRightPanel());
//		panle.add(getListTable());
//		return panle;
//	}


	/**
	 * This method initializes
	 *
	 */
	public Location() {
		//super(MasterPanel.FLAT_LAYOUT);
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		/* >>> ~7.1~ Init action (e.g. Listing, Init Comobbox ========= <<< */
		setNoGetDB(true);
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
		System.out.println("FocusComponent getListTable().getRowCount() is :"+getListTable().getRowCount());
		System.out.println("FocusComponent getListTable().getStore().getCount() is :"+getListTable().getStore().getCount());
		return getLeftJText_LocationCode();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {
		// override function if necessary
	}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {
		getRightJText_LocationCode().setEnabled(true);
	}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
		// enable/disable field
		getRightJText_LocationCode().setEnabled(false);
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
				getLeftJText_LocationCode().getText(),
				getLeftJText_LocationName().getText(),
				getLeftJText_DistrictCode().getText(),
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
		getRightJText_LocationCode().setText(outParam[index++]);
		getRightJText_LocationName().setText(outParam[index++]);
		getRightJText_DistrictCode().setText(outParam[index++]);
		setCurrentTable(4, getUserInfo().getSiteCode());
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {
		if (getRightJText_LocationCode().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Location Code!", getRightJText_LocationCode());
			actionValidationReady(actionType, false);
		} else if (getRightJText_LocationName().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Location Name!", getRightJText_LocationName());
			actionValidationReady(actionType, false);
		}  else if (getRightJText_DistrictCode().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty District Code!", getRightJText_DistrictCode());
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
				selectedContent[2],
				getUserInfo().getSiteCode()
		};
	}

	@Override
	protected boolean actionValidation(String[] selectedContent) {
		if (selectedContent[0].trim().length()== 0 || selectedContent[0]==null) {
			Factory.getInstance().addErrorMessage("Empty Location Code!");
			return false;
		} else if (selectedContent[1].trim().length()== 0 || selectedContent[1]==null) {
			Factory.getInstance().addErrorMessage("Empty Location Name!");
			return false;
		}  else if (selectedContent[2].trim().length()== 0 || selectedContent[2]==null) {
			Factory.getInstance().addErrorMessage("Empty District Code!");
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
			leftPanel.setSize(700, 80);
			leftPanel.setHeading("Search Criteria");
			leftPanel.add(0,0,getLeftJLabel_LocationCode());
			leftPanel.add(1,0,getLeftJText_LocationCode());
			leftPanel.add(2,0,getLeftJLabel_LocationName());
			leftPanel.add(3,0,getLeftJText_LocationName());
		//	leftPanel.add(getLeftJText_DistrictCode(),null);
		}
		return leftPanel;
	}

	/**
	 * This method initializes LeftJLabel_LocationCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */

	private LabelBase getLeftJLabel_LocationCode() {
		if (LeftJLabel_LocationCode == null) {
			LeftJLabel_LocationCode = new LabelBase();
			LeftJLabel_LocationCode.setText("Location Code :");
			LeftJLabel_LocationCode.setOptionalLabel();
		}
		return LeftJLabel_LocationCode;
	}

	/**
	 * This method initializes LeftJText_LocationCode
	 *
	 * @return com.hkah.client.layout.textfield.TextLocationCode
	 */
	private TextString getLeftJText_LocationCode() {
		if (LeftJText_LocationCode == null) {
			LeftJText_LocationCode = new TextString(10,true);
		}
		return LeftJText_LocationCode;
	}
	/**
	 * This method initializes LeftJLabel_LocationName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getLeftJLabel_LocationName() {
		if (LeftJLabel_LocationName == null) {
			LeftJLabel_LocationName = new LabelBase();
			LeftJLabel_LocationName.setText("Location Name :");
			LeftJLabel_LocationName.setOptionalLabel();
		}
		return LeftJLabel_LocationName;
	}

	/**
	 * This method initializes LeftJText_LocationName
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getLeftJText_LocationName() {
		if (LeftJText_LocationName == null) {
			LeftJText_LocationName = new TextString(50,false);
		}
		return LeftJText_LocationName;
	}
	/**
	 * This method initializes LeftJLabel_DistrictCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getLeftJLabel_DistrictCode() {
		if (LeftJLabel_DistrictCode == null) {
			LeftJLabel_DistrictCode = new LabelBase();
			LeftJLabel_DistrictCode.setBounds(16, 97, 104, 30);
			LeftJLabel_DistrictCode.setText("District Code :");
			LeftJLabel_DistrictCode.setOptionalLabel();
		}
		return LeftJLabel_DistrictCode;
	}

	/**
	 * This method initializes LeftJText_DistrictCode
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getLeftJText_DistrictCode() {
		if (LeftJText_DistrictCode == null) {
			LeftJText_DistrictCode = new TextString(10,false);
			LeftJText_DistrictCode.setLocation(127, 97);
			LeftJText_DistrictCode.setSize(152, 30);
		}
		return LeftJText_DistrictCode;
	}


	/**
	 * This method initializes generalPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected ColumnLayout getActionPanel() {
		if (generalPanel == null) {
			generalPanel = new ColumnLayout(4,2);
			generalPanel.setSize(700, 120);
			generalPanel.setHeading("Location Information");
			generalPanel.add(0,0,getRightJLabel_LocationCode());
			generalPanel.add(1,0,getRightJText_LocationCode());
			generalPanel.add(2,0,getRightJLabel_LocationName());
			generalPanel.add(3,0,getRightJText_LocationName());
			generalPanel.add(0,1,getRightJLabel_DistrictCode());
			generalPanel.add(1,1,getRightJText_DistrictCode());
		}
		return generalPanel;
	}


	/**
	 * This method initializes RightJLabel_LocationCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_LocationCode() {
		if (RightJLabel_LocationCode == null) {
			RightJLabel_LocationCode = new LabelBase();
			RightJLabel_LocationCode.setText("Location Code");
		}
		return RightJLabel_LocationCode;
	}

	/**
	 * This method initializes RightJText_LocationCode
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_LocationCode() {
		if (RightJText_LocationCode == null) {
			RightJText_LocationCode = new TextString(10,getListTable(), 0,false);
		}
		return RightJText_LocationCode;
	}

	/**
	 * This method initializes RightJLabel_LocationName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_LocationName() {
		if (RightJLabel_LocationName == null) {
			RightJLabel_LocationName = new LabelBase();
			RightJLabel_LocationName.setText("Location Name");
		}
		return RightJLabel_LocationName;
	}

	/**
	 * This method initializes RightJText_LocationName
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_LocationName() {
		if (RightJText_LocationName == null) {
			RightJText_LocationName = new TextString(50,getListTable(), 1,false);
		}
		return RightJText_LocationName;
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
			RightJText_DistrictCode = new TextString(50,getListTable(), 2,false);
		}
		return RightJText_DistrictCode;
	}
}