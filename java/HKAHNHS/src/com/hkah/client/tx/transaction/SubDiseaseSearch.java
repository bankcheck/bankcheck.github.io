package com.hkah.client.tx.transaction;

import com.extjs.gxt.ui.client.util.Rectangle;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MasterPanel;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;

public class SubDiseaseSearch extends MasterPanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.SUBDISEASE_SEARCH_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.SUBDISEASE_SEARCH_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
			"Sub-Disease",
			"Sub-Disease Name",
			"Sick Code",
			"Sick Description",
			};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				120,
				250,
				80,
				250
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private BasePanel rightPanel=null;
	private BasePanel leftPanel=null;
	private BasePanel ParaPanel = null;
	private LabelBase sdsCodeDesc=null;
	private TextString sdsCode=null;
	private LabelBase sdsNameDesc=null;
	private TextString sdsName=null;
	private LabelBase sickCodeDesc=null;
	private TextString sickCode=null;
	private JScrollPane JScrollPane = null;
	private BasePanel ListPanel = null;

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */

	/**
	 * This method initializes
	 *
	 */
	public SubDiseaseSearch() {
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
		disableButton();
		getSearchButton().setEnabled(true);
		getCancelButton().setEnabled(true);
	    getAcceptButton().setEnabled(true);
		getRefreshButton().setEnabled(true);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return getSdsCode();
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
		if (getSdsCode().getText().trim().length()>0) {
			i++;
		}
		if (getSdsName().getText().trim().length()>0) {
			i++;
		}
		if (getSickCode().getText().trim().length()>0) {
			i++;
		}
		if (i == 0) {
			Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_INPUT_CRITERIA, "Sub Disease Search", getDefaultFocusComponent());
			return false;
		} else {
			return true;
		}
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
//		logger.info("sdscode>>>>"+getSdsCode().getText().trim());
		return new String[] {
				getSdsCode().getText().trim(),
				getSdsName().getText().trim(),
				getSickCode().getText().trim()};
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
	protected void getBrowseOutputValues(String[] outParam) {
	}

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

		if (getListTable().getRowCount() > 0) {
			if (getListTable().getSelectedRowCount() > 0) {
				// store sds code from selected
				setParameter("sdsCode", getListTable().getSelectedRowContent()[0]);
				setParameter("sdsName", getListTable().getSelectedRowContent()[1]);
				exitPanel();
			}
		}
		// back to previous page
	}

//	/***************************************************************************
//	 * Layout Method
//	 **************************************************************************/
//
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
			ParaPanel.setHeading("Sub Disease Information");
			ParaPanel.setSize(757, 80);
			ParaPanel.add(getSdsCodeDesc(),null);
			ParaPanel.add(getSdsCode(),null);
			ParaPanel.add(getSdsNameDesc(),null);
			ParaPanel.add(getSdsName(),null);
			ParaPanel.add(getSickCodeDesc(),null);
			ParaPanel.add(getSickCode(),null);
		}
		return ParaPanel;
	}

   public LabelBase getSdsCodeDesc() {
	    if (sdsCodeDesc==null) {
	    	sdsCodeDesc=new LabelBase();
	    	sdsCodeDesc.setText("Sub-Disease Code");
	    	sdsCodeDesc.setBounds(5,20, 120, 20);
	    }
		return sdsCodeDesc;
	}

	public TextString getSdsCode() {
		 if (sdsCode==null) {
			 sdsCode=new TextString();
			 sdsCode.setBounds(130,20, 120, 20);
		    }
		return sdsCode;
	}

	public LabelBase getSdsNameDesc() {
		if (sdsNameDesc==null) {
			sdsNameDesc=new LabelBase();
			sdsNameDesc.setText("Sub-Disease Name");
			sdsNameDesc.setBounds(255,20, 120, 20);
	    }
		return sdsNameDesc;
	}

	public TextString getSdsName() {
		if (sdsName==null) {
			sdsName=new TextString();
			sdsName.setBounds(380,20, 120, 20);
		    }
		return sdsName;
	}

	public LabelBase getSickCodeDesc() {
		 if (sickCodeDesc==null) {
			 sickCodeDesc=new LabelBase();
			 sickCodeDesc.setText("Sick Code");
			 sickCodeDesc.setBounds(5,45, 120, 20);
		    }

		return sickCodeDesc;
	}

	public TextString getSickCode() {
		if (sickCode==null) {
			sickCode=new TextString();
			sickCode.setBounds(130,45, 120, 20);
		    }
		return sickCode;
	}

	public BasePanel getListPanel() {
		if (ListPanel == null) {
			ListPanel = new BasePanel();
			ListPanel.setHeading("Sub Disease List");
			ListPanel.setBounds(new Rectangle(5, 110, 757, 336));
			this.getLeftPanel().remove(this.getJScrollPane());
			ListPanel.add(getJScrollPane());
		}
		return ListPanel;
	}
}