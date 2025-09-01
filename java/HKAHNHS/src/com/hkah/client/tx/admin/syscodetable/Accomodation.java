/*
 * Created on July 23, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.tx.admin.syscodetable;

import com.extjs.gxt.ui.client.widget.LayoutContainer;
import com.extjs.gxt.ui.client.widget.form.FormPanel;
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
public class Accomodation extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.ACCOMODATION_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.ACCOMODATION_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Accomodation Code",
				"Accomodation Name",
				"Accomodation CName"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				50,
				80,
				80
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;  //  @jve:decl-index=0:visual-constraint="10,204"
	private LabelBase LeftJLabel_AccomodationCode = null;
	private TextString LeftJText_AccomodationCode = null;
	private LabelBase LeftJLabel_AccomodationName = null;
	private TextString LeftJText_AccomodationName = null;
	private LabelBase LeftJLabel_AccomodationCName = null;
	private TextString LeftJText_AccomodationCName = null;


	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;  //  @jve:decl-index=0:visual-constraint="12,14"
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_AccomodationCode = null;
	private TextString RightJText_AccomodationCode = null;
	private LabelBase RightJLabel_AccomodationName = null;
	private TextString RightJText_AccomodationName = null;
	private LabelBase RightJLabel_AccomodationCName = null;
	private TextString RightJText_AccomodationCName = null;

	/**
	 * This method initializes
	 *
	 */
	public Accomodation() {
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
		return getLeftJText_AccomodationCode();
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
		getRightJText_AccomodationCode().setEnabled(false);
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
				getLeftJText_AccomodationCode().getText(),
				getLeftJText_AccomodationName().getText(),
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
		getRightJText_AccomodationCode().setText(outParam[index++]);
		getRightJText_AccomodationName().setText(outParam[index++]);
		getRightJText_AccomodationCName().setText(outParam[index++]);
	}

	/* >>> ~22~ Set Action Input Parameters per table ===================== <<< */
	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		// TODO Auto-generated method stub
		return new String[] {
				selectedContent[0],
				selectedContent[1],
				selectedContent[2]
		};
	}

	/* >>> ~23~ Set Action Validation per table =========================== <<< */
	@Override
	protected boolean actionValidation(String[] selectedContent) {
		// TODO Auto-generated method stub
		if (selectedContent[0].trim().length()==0 || selectedContent[0]==null) {
			Factory.getInstance().addErrorMessage("Empty Accomodation Code!");
			return false;
		} else if (selectedContent[1].trim().length()==0 || selectedContent[1]==null) {
			Factory.getInstance().addErrorMessage("Empty Accomodation Name!");
			return false;
		}
		return true;
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	protected LayoutContainer getBodyPanel() {
		FormPanel panle = new FormPanel();
		//LayoutContainer panle = new LayoutContainer();
		//panle.setLayout(new FlowLayout());
		panle.setFrame(false);
		panle.setHeaderVisible(false);
		panle.setBorders(false);
		panle.setBodyBorder(false);
		panle.add(getLeftPanel());
		//panle.add(getRightPanel());
		//panle.add(getSearchPanel());
		panle.add(getActionPanel());
		panle.add(getListTable());
		return panle;
	}

	public ColumnLayout getSearchPanel() {
		if (leftPanel == null) {
			leftPanel = new ColumnLayout(2,2);
			leftPanel.setSize(400,100);
			leftPanel.setHeading("Search Criteria");
			leftPanel.add(0,0,getLeftJLabel_AccomodationCode());
			leftPanel.add(1,0,getLeftJText_AccomodationCode());
			leftPanel.add(0,1,getLeftJLabel_AccomodationName());
			leftPanel.add(1,1,getLeftJText_AccomodationName());
		}
		return leftPanel;
	}

	/**
	 * This method initializes LeftJLabel_AccomodationCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */


	private LabelBase getLeftJLabel_AccomodationCode() {
		if (LeftJLabel_AccomodationCode == null) {
			LeftJLabel_AccomodationCode = new LabelBase();
			LeftJLabel_AccomodationCode.setText("Accomodation Code :");
			LeftJLabel_AccomodationCode.setOptionalLabel();
		}
		return LeftJLabel_AccomodationCode;
	}

	/**
	 * This method initializes LeftJText_AccomodationCode
	 *
	 * @return com.hkah.client.layout.textfield.TextAccomodationCode
	 */
	private TextString getLeftJText_AccomodationCode() {
		if (LeftJText_AccomodationCode == null) {
			LeftJText_AccomodationCode = new TextString(1,false);

		}
		return LeftJText_AccomodationCode;
	}
	/**
	 * This method initializes LeftJLabel_AccomodationName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getLeftJLabel_AccomodationName() {
		if (LeftJLabel_AccomodationName == null) {
			LeftJLabel_AccomodationName = new LabelBase();
			LeftJLabel_AccomodationName.setText("Accomodation Name :");
			LeftJLabel_AccomodationName.setOptionalLabel();
		}
		return LeftJLabel_AccomodationName;
	}

	/**
	 * This method initializes LeftJText_AccomodationName
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getLeftJText_AccomodationName() {
		if (LeftJText_AccomodationName == null) {
			LeftJText_AccomodationName = new TextString(20,false);
		}
		return LeftJText_AccomodationName;
	}
	/**
	 * This method initializes LeftJLabel_AccomodationCName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getLeftJLabel_AccomodationCName() {
		if (LeftJLabel_AccomodationCName == null) {
			LeftJLabel_AccomodationCName = new LabelBase();
			LeftJLabel_AccomodationCName.setText("Accomdation CName :");
			LeftJLabel_AccomodationCName.setBounds(16, 97, 143, 30);
			LeftJLabel_AccomodationCName.setOptionalLabel();
		}
		return LeftJLabel_AccomodationCName;
	}
	/**
	 * This method initializes LeftJText_AccomodationCName
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getLeftJText_AccomodationCName() {
		if (LeftJText_AccomodationCName == null) {
			LeftJText_AccomodationCName = new TextString(20,false);
			LeftJText_AccomodationCName.setBounds(174, 95, 195, 30);
		}
		return LeftJText_AccomodationCName;
	}

	/**
	 * This method initializes generalPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	public ColumnLayout getActionPanel() {
		if (generalPanel == null) {
			generalPanel = new ColumnLayout(4,2);
			generalPanel.setSize(600,100);
			generalPanel.setHeading("Accomodation Information");
			generalPanel.add(0,0,getRightJLabel_AccomodationCode());
			generalPanel.add(1,0,getRightJText_AccomodationCode());
			generalPanel.add(2,0,getRightJLabel_AccomodationName());
			generalPanel.add(3,0,getRightJText_AccomodationName());
			generalPanel.add(0,1,getRightJLabel_AccomodationCName());
			generalPanel.add(1,1,getRightJText_AccomodationCName());
		}
		return generalPanel;
	}

	/**
	 * This method initializes RightJLabel_AccomodationCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_AccomodationCode() {
		if (RightJLabel_AccomodationCode == null) {
			RightJLabel_AccomodationCode = new LabelBase();
			RightJLabel_AccomodationCode.setText("Accomodation Code");
		}
		return RightJLabel_AccomodationCode;
	}

	/**
	 * This method initializes RightJText_AccomodationCode
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_AccomodationCode() {
		if (RightJText_AccomodationCode == null) {
			RightJText_AccomodationCode = new TextString(1,getListTable(), 0,false);
		}
		return RightJText_AccomodationCode;
	}

	/**
	 * This method initializes RightJLabel_AccomodationName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_AccomodationName() {
		if (RightJLabel_AccomodationName == null) {
			RightJLabel_AccomodationName = new LabelBase();
			RightJLabel_AccomodationName.setText("Accomodation Name");
		}
		return RightJLabel_AccomodationName;
	}

	/**
	 * This method initializes RightJText_AccomodationName
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_AccomodationName() {
		if (RightJText_AccomodationName == null) {
			RightJText_AccomodationName = new TextString(20,getListTable(), 1,false);
		}
		return RightJText_AccomodationName;
	}

	/**
	 * This method initializes RightJLabel_AccomodationCName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_AccomodationCName() {
		if (RightJLabel_AccomodationCName == null) {
			RightJLabel_AccomodationCName = new LabelBase();
			RightJLabel_AccomodationCName.setText("Accomodation CName");
		}
		return RightJLabel_AccomodationCName;
	}

	/**
	 * This method initializes RightJText_AccomodationCName
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_AccomodationCName() {
		if (RightJText_AccomodationCName == null) {
			RightJText_AccomodationCName = new TextString(20,getListTable(), 2,false);
		}
		return RightJText_AccomodationCName;
	}
}