package com.hkah.client.tx.transaction;


import com.extjs.gxt.ui.client.util.Rectangle;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.combobox.ComboItemType;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextItemCode;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MasterPanel;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;

public class PkgSearch extends MasterPanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.PACKAGE_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.PACKAGE_TITLE + " Search";
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
			"Package Code",
			"Package Name",
			"PKGCNAME",
			"DPTCODE",
			"Report Level",
			"PKGTYPE",
			"PKGALERT",
			""
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				80,
				80,
				0,
				0,
				80,
				0,
				0,
				0
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private BasePanel rightPanel=null;
	private BasePanel leftPanel=null;
	private BasePanel ParaPanel = null;
	private LabelBase pkgCodeDesc=null;
	private TextItemCode pkgCode=null;
	private LabelBase pkgNameDesc=null;
	private TextString pkgName=null;
	private LabelBase pkgReportLvlDesc=null;
	private TextString pkgReportLvl=null;
	private JScrollPane JScrollPane = null;
	private BasePanel ListPanel = null;

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */

	/**
	 * This method initializes
	 *
	 */
	public PkgSearch() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		setLeftAlignPanel();
		getJScrollPane().setBounds(15, 25, 725, 290);
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		getAppendButton().setEnabled(false);
		getCancelButton().setEnabled(true);
		getPrintButton().setEnabled(false);
		getRefreshButton().setEnabled(false);
		getCancelButton().setEnabled(false);
		getAcceptButton().setEnabled(true);
		getRefreshButton().setEnabled(true);
		if (getParameter("itmCode") != null && getParameter("itmCode").length() > 0) {
			getPkgCode().setText(getParameter("itmCode"));
			setParameter("itmCode", ConstantsVariable.EMPTY_VALUE);
		}
		this.getListTable().setColumnClass(2, new ComboItemType(), false);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return getPkgCode();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {}

	/* >>> ~13~ Set Disable Fields When Delete ButtonBase Is Clicked ====== <<< */
	@Override
	protected void deleteDisabledFields() {}

	/* >>> ~14~ Set Browse Validation ===================================== <<< */
	@Override
	protected boolean browseValidation() {
		int i=0;
		if (!getPkgCode().isEmpty()) i++;
		if (!getPkgName().isEmpty()) i++;
		if (!getPkgReportLvl().isEmpty()) i++;

		if (i == 0) {
			Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_INPUT_CRITERIA, "Package Search", getDefaultFocusComponent());
			return false;
		} else {
			return true;
		}
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
				getPkgCode().getText().trim(),
				getPkgName().getText().trim(),
				getPkgReportLvl().getText(),

		};
	}

	/* >>> ~16~ Set Fetch Input Parameters ================================ <<< */
	@Override
	protected String[] getFetchInputParameters() {
		return null;
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {}

	/* >>> ~15~ Set Fetch Output Results ============================== <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return null;
	}

	/***************************************************************************
	 * Overload Method
	 **************************************************************************/

	public void acceptAction() {
		// clear store value
		setParameter("pkgCode1", ConstantsVariable.EMPTY_VALUE);
		if (getListTable().getRowCount() > 0) {
			if (getListTable().getSelectedRowCount() > 0) {
				// store item code from selected
				setParameter("pkgCode1", getListTable().getSelectedRowContent()[0]);
			}
		}
		// back to previous page
		exitPanel();
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

//	protected JSplitPane getBodyPanel(boolean requiredScroll) {
//		// add button to left panel
//		//getLeftPanel().add(getJScrollPane(), null);
//		// add left/right pannel
//		getjSplitPane().setLeftComponent(getLeftPanel());
//
//		if (isRequiredScroll()) {
//			JScrollPane jScrollPanel = new JScrollPane(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS, JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
//			jScrollPanel.setViewportView(getRightPanel());
//			//getjSplitPane().setRightComponent(jScrollPanel);
//			//jSplitPane.setRightComponent(new JScrollPane(getRightPanel(), JScrollPane.VERTICAL_SCROLLBAR_ALWAYS, JScrollPane.HORIZONTAL_SCROLLBAR_NEVER));
//		} else {
//			//getjSplitPane().setRightComponent(getRightPanel());
//		}
//
//		getjSplitPane().setPreferredSize(new Dimension(1017, 619));
//		getjSplitPane().setDividerLocation(395);
//		getjSplitPane().setDividerSize(3);
//		//setLeftAlignPanel();
//		return getjSplitPane();
//	}

	//action method override end
	/* >>> getter methods for init the Component start from here ================================== <<< */
	@Override
	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.setSize(779, 528);
			leftPanel.add(getParaPanel(),null);
			leftPanel.add(getListPanel(), null);
		}
		return leftPanel;
	}

	protected BasePanel getRightPanel() {
		if (rightPanel == null) {
			rightPanel = new BasePanel();
			//leftPanel.setSize(800, 530));
		}
		return rightPanel;
	}

	public BasePanel getParaPanel() {
		if (ParaPanel == null) {
			ParaPanel = new BasePanel();
			ParaPanel.setLocation(5, 5);
			ParaPanel.setHeading("Package Information");
			ParaPanel.setSize(757, 100);
			ParaPanel.add(getPkgCodeDesc(),null);
			ParaPanel.add(getPkgCode(),null);
			ParaPanel.add(getPkgNameDesc(),null);
			ParaPanel.add(getPkgName(),null);
			ParaPanel.add(getPkgReportLvlDesc(),null);
			ParaPanel.add(getPkgReportLvl(),null);

		}
		return ParaPanel;
	}


	public LabelBase getPkgCodeDesc() {
		if (pkgCodeDesc == null) {
			pkgCodeDesc = new LabelBase();
			pkgCodeDesc.setText("Package Code");
			pkgCodeDesc.setBounds(50, 15, 97, 20);
		}
		return pkgCodeDesc;
	}

	public TextItemCode getPkgCode() {
		if (pkgCode == null) {
			pkgCode = new TextItemCode();
			pkgCode.setBounds(151, 15, 150, 20);
		}
		return pkgCode;
	}

	public LabelBase getPkgNameDesc() {
		if (pkgNameDesc == null) {
			pkgNameDesc = new LabelBase();
			pkgNameDesc.setText("Package Name");
			pkgNameDesc.setBounds(355,15,100,20);
	 }
		return pkgNameDesc;
	}

	public TextString getPkgName() {
		if (pkgName == null) {
			pkgName = new TextString();
			pkgName.setBounds(460,15,150,20);
	 }
		return pkgName;
	}

	public LabelBase getPkgReportLvlDesc() {
		if (pkgReportLvlDesc == null) {
			pkgReportLvlDesc = new LabelBase();
			pkgReportLvlDesc.setText("Report Level");
			pkgReportLvlDesc.setBounds(50, 40, 97, 20);
	 }
		return pkgReportLvlDesc;
	}

	public TextString getPkgReportLvl() {
		if (pkgReportLvl == null) {
			pkgReportLvl = new TextString();
			pkgReportLvl.setBounds(151, 40, 150, 20);
		}
		return pkgReportLvl;
	}

	public BasePanel getListPanel() {
		if (ListPanel == null) {
			ListPanel = new BasePanel();
			ListPanel.setHeading("Package List");
			ListPanel.setBounds(new Rectangle(5, 110, 757, 336));
			this.getLeftPanel().remove(this.getJScrollPane());
			ListPanel.add(getJScrollPane());
		}
		return ListPanel;
	}
}