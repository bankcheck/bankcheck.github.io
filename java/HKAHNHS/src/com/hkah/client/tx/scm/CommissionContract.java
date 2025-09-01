package com.hkah.client.tx.scm;

import java.util.ArrayList;

import com.extjs.gxt.ui.client.util.Rectangle;
import com.hkah.client.layout.combobox.ComboDeptServ;
import com.hkah.client.layout.combobox.ComboItemCode;
import com.hkah.client.layout.combobox.ComboPatientType;
import com.hkah.client.layout.dialog.DlgComContractAmend;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.panel.TabbedPaneBase;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class CommissionContract extends MasterPanel{

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.COMMISSIONCONTRACT_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.COMMISSIONCONTRACT_TITLE;
	}

	private BasePanel rightPanel=null;
	private BasePanel leftPanel=null;
	private TabbedPaneBase TabbedPane=null;

	private BasePanel GCPanel=null;
	private BasePanel GCGLPanel = null;
	private TableList GCGLTable=null;
	private JScrollPane GCGLJScrollPane = null;
	private JScrollPane JScrollPane = null;
	private BasePanel ListPanel = null;

	private BasePanel TMCPanel=null;
	private BasePanel TMCGLPanel = null;
	private TableList TMCGLTable=null;
	private JScrollPane TMCGLJScrollPane = null;
	private BasePanel CSAEIPanel = null;
	private TableList CSAEITable=null;
	private JScrollPane CSAEIJScrollPane = null;
	private DlgComContractAmend dlgGeneralContractAmend = null;
	private DlgComContractAmend dlgCustomContractAmend = null;

	/**
	 * This method initializes
	 *
	 */
	public CommissionContract() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		setLeftAlignPanel();
		getJScrollPane().setBounds(12, 22, 725, 180);
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		enableButton();
		
		getListTable().setColumnClass(3, new ComboPatientType(), false);
		getListTable().setColumnClass(5, new ComboDeptServ(false), false);

		getCSAEITable().setColumnClass(3, new ComboPatientType(), false);
		getCSAEITable().setColumnClass(5, new ComboItemCode(false), false);

		QueryUtil.executeMasterBrowse(
				getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] {"PATCAT"," '', PCYID, PCYCODE, PCYDESC","1=1 ORDER BY PCYCODE"},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getGCGLTable().setListTableContent(mQueue);
					getTMCGLTable().setListTableContent(mQueue);
				}
			}
		});
	}
	
	@Override
	protected void listTableContentPost() {
		super.listTableContentPost();
		enableButton();
	}

	protected void showDetail() {
		getListTable().removeAllRow();
		getCSAEITable().removeAllRow();
		
		String pcyid ;
		if (getTabbedPane().getSelectedIndex() == 0) {
			pcyid = getGCGLTable().getSelectedRowContent()[1];
			getListTable().setListTableContent(ConstantsTx.GENCONTRACT_TXCODE, new String[] {pcyid});
		} else if (getTabbedPane().getSelectedIndex() == 1) {
			pcyid = getTMCGLTable().getSelectedRowContent()[1];
			getCSAEITable().setListTableContent(ConstantsTx.TMCONTRACT_TXCODE, new String[] {pcyid});
		}

	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return null;
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
		return new String[] {};
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

	}

	/* >>> ~15~ Set Fetch Output Results ============================== <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return new String[] {};
	}

	/* >>> ~16.1~ Set Action Output Parameters =========================== <<< */
	@Override
	protected void getNewOutputValue(String returnValue) {}

	@Override
	public void appendAction() {
		setActionType(QueryUtil.ACTION_APPEND);
		amend();
	}

	@Override
	public void modifyAction() {
		setActionType(QueryUtil.ACTION_MODIFY);
		amend();
	}

	@Override
	public void deleteAction() {
		setActionType(QueryUtil.ACTION_DELETE);
		amend();
	}
	
	@Override
	protected void enableButton(String mode) {
		disableButton();
		
		getAppendButton().setEnabled(getGCGLTable().getRowCount() > 0 || 
										getTMCGLTable().getRowCount() > 0);
		getModifyButton().setEnabled((getListTable().getRowCount() > 0 || 
										getCSAEITable().getRowCount() > 0) && 
										!isModify() &&!isAppend());
		getDeleteButton().setEnabled((getListTable().getRowCount() > 0 || 
										getCSAEITable().getRowCount() > 0));
		getSaveButton().setEnabled(isAppend() || isModify());
		getCancelButton().setEnabled(isAppend() || isModify());
	}

	protected void amend() {
		if (getGCGLTable().getRowCount()<=0) {
			return;
		}
		
		java.util.List<String[]> list = new ArrayList<String[]>();
		String[] parm ;
		if (getTabbedPane().getSelectedIndex() == 0) {
			parm = new String[] {
				getActionType(),
				getGCGLTable().getSelectedRowContent()[1],
				ConstantsVariable.ZERO_VALUE
			};
			list.add(parm);
			if (!QueryUtil.ACTION_APPEND.equals(getActionType())) {
				if (getListTable().getRowCount() <= 0 ) {
					return;
				}
				list.add(getListSelectedRow());
			}
		} else {
			parm = new String[] {
				getActionType(),
				getTMCGLTable().getSelectedRowContent()[1],
				ConstantsVariable.ONE_VALUE
			};
			list.add(parm);
			if (!QueryUtil.ACTION_APPEND.equals(getActionType())) {
				if (getCSAEITable().getRowCount() > 0 ) {
					list.add(getCSAEITable().getSelectedRowContent());
					int i=0;
					for (String string : getCSAEITable().getSelectedRowContent()) {
						//System.out.println(string);
						i++;
					}
					//System.out.println(i);
				}
			}
		}
		
		if (getTabbedPane().getSelectedIndex() == 0) {
			getDlgGeneralContractAmend().showDialog(list);
		}
		else {
			getDlgCustomContractAmend().showDialog(list);
		}
	}
	
	private DlgComContractAmend getDlgGeneralContractAmend() {
		if (dlgGeneralContractAmend == null) {
			dlgGeneralContractAmend = new DlgComContractAmend(getMainFrame(), ConstantsVariable.ZERO_VALUE) {
				@Override 
				public void onClose() {
					setActionType(null);
					showDetail();
				}
				
				@Override
				protected void savePost() {
					setActionType(null);
					showDetail();
				}
			};
		}
		
		return dlgGeneralContractAmend;
	}
	
	private DlgComContractAmend getDlgCustomContractAmend() {
		if (dlgCustomContractAmend == null) {
			dlgCustomContractAmend = new DlgComContractAmend(getMainFrame(), ConstantsVariable.ONE_VALUE) {
				@Override 
				public void onClose() {
					setActionType(null);
					showDetail();
				}
				
				@Override
				protected void savePost() {
					setActionType(null);
					showDetail();
				}
			};
		}
		
		return dlgCustomContractAmend;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
			"","","",
			"Item Charge Type",
			"Dept. Service",
			"Description",
			"Contract Applied",
			"Effective Date From",
			"Effective Date To"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				10,0,0,
				120,
				100,
				150,
				120,
				128,
				120
		};
	}

	/* >>> getter methods for init the Component start from here================================== <<< */
	@Override
	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.setSize(779, 510);
			leftPanel.add(getTabbedPane(),null);
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

	public TabbedPaneBase getTabbedPane() {
		if (TabbedPane == null) {
			TabbedPane = new TabbedPaneBase() {
				public void onStateChange() {
					showDetail();
				}
			};
			TabbedPane.setLocation(0, 1);
			TabbedPane.setSize(785, 509);
			TabbedPane.addTab("General Contract",getGCPanel());
			TabbedPane.addTab("Tailor Made Contract", getTMCPanel());
		}
		return TabbedPane;
	}
	public BasePanel getGCPanel() {
		if (GCPanel == null) {
			GCPanel = new BasePanel();
			GCPanel.setLocation(5, 5);
			GCPanel.setSize(790,480);
			GCPanel.add(getGCGLPanel(),null);
			GCPanel.add(getListPanel(), null);

		}
		return GCPanel;
	}

	public BasePanel getGCGLPanel() {
		if (GCGLPanel == null) {
			GCGLPanel = new BasePanel();
			GCGLPanel.setHeading("Contract Listing");
			GCGLPanel.setBounds(new Rectangle(12, 14, 759, 222));
			GCGLPanel.add(getGCGLJScrollPane(),null);

			//ListTable_JScrollPane.setBounds(new Rectangle(6, 46, 380, 95));
		}
		return GCGLPanel;
	}

	private JScrollPane getGCGLJScrollPane() {
		if (GCGLJScrollPane == null) {
			GCGLJScrollPane = new JScrollPane();
			GCGLJScrollPane.setViewportView(getGCGLTable());
			GCGLJScrollPane.setBounds(new Rectangle(12, 22, 725, 180));
		}
		return GCGLJScrollPane;
	}

	private TableList getGCGLTable() {
		if (GCGLTable == null) {
			GCGLTable = new TableList(getGCGLTableColumnNames(), getGCGLTableColumnWidths()) {
				public void onSelectionChanged() {
					showDetail();
				}
			};
		}
		return GCGLTable;
	}


	protected String[] getGCGLTableColumnNames() {
		return new String[] {
				"","",
				"Patient Category",
				"Description"
				};
	}

	protected int[] getGCGLTableColumnWidths() {
		return new int[] { 10,0,150,180};
	}

	public BasePanel getListPanel() {
		if (ListPanel == null) {
			ListPanel = new BasePanel();
			ListPanel.setHeading("Contract Share Among Department Service");
			ListPanel.setBounds(new Rectangle(12, 241, 757, 222));
			this.getLeftPanel().remove(this.getJScrollPane());
			ListPanel.add(getJScrollPane());

			//ListTable_JScrollPane.setBounds(new Rectangle(6, 46, 380, 95));
		}
		return ListPanel;
	}

	public BasePanel getTMCPanel() {
		if (TMCPanel == null) {
			TMCPanel = new BasePanel();
			TMCPanel.setLocation(5, 5);
			TMCPanel.setSize(790,480);
			TMCPanel.add(getTMCGLPanel(),null);
			TMCPanel.add(getCSAEIPanel(), null);

		}
		return TMCPanel;
	}

	public BasePanel getTMCGLPanel() {
		if (TMCGLPanel == null) {
			TMCGLPanel = new BasePanel();
			TMCGLPanel.setHeading("Contract Listing");
			TMCGLPanel.setBounds(new Rectangle(12, 14, 759, 222));
			TMCGLPanel.add(getTMCGLJScrollPane(),null);

			//ListTable_JScrollPane.setBounds(new Rectangle(6, 46, 380, 95));
		}
		return TMCGLPanel;
	}

	private JScrollPane getTMCGLJScrollPane() {
		if (TMCGLJScrollPane == null) {
			TMCGLJScrollPane = new JScrollPane();
			TMCGLJScrollPane.setViewportView(getTMCGLTable());
			TMCGLJScrollPane.setBounds(new Rectangle(12, 22, 725, 180));
		}
		return TMCGLJScrollPane;
	}

	private TableList getTMCGLTable() {
		if (TMCGLTable == null) {
			TMCGLTable = new TableList(getTMCGLTableColumnNames(), getTMCGLTableColumnWidths()) {
				public void onSelectionChanged() {
					showDetail();
				}
			};

			int length = 0;
			if (getTMCGLTableColumnWidths() != null) {
				for (int i = 0; i < getTMCGLTableColumnWidths().length; i++) {
					length += getTMCGLTableColumnWidths()[i];
				}
			}
		//	TMCGLTable.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
		}
		return TMCGLTable;
	}

	protected String[] getTMCGLTableColumnNames() {
		return new String[] {
				"","",
				"Patient Category",
				"Description"
				};
	}

	protected int[] getTMCGLTableColumnWidths() {
		return new int[] { 10,0,150,180};
	}

	public BasePanel getCSAEIPanel() {
		if (CSAEIPanel == null) {
			CSAEIPanel = new BasePanel();
			CSAEIPanel.setHeading("Contract Share Among Exam Item");
			CSAEIPanel.setBounds(new Rectangle(12, 241, 759, 222));
			CSAEIPanel.add(getCSAEIJScrollPane(),null);

			//ListTable_JScrollPane.setBounds(new Rectangle(6, 46, 380, 95));
		}
		return CSAEIPanel;
	}

	private JScrollPane getCSAEIJScrollPane() {
		if (CSAEIJScrollPane == null) {
			CSAEIJScrollPane = new JScrollPane();
			CSAEIJScrollPane.setViewportView(getCSAEITable());
			CSAEIJScrollPane.setBounds(new Rectangle(12, 22, 725, 180));
		}
		return CSAEIJScrollPane;
	}

	private TableList getCSAEITable() {
		if (CSAEITable == null) {
			CSAEITable = new TableList(getCSAEITableColumnNames(), getCSAEITableColumnWidths()) {
				@Override
				public void setListTableContentPost() {
					super.setListTableContentPost();
					enableButton();
				}
			};
			CSAEITable.setTableLength(getListWidth());
			//PatStatusTable.setColumnClass(0, ComboPackage.class, true);
			//PatStatusTable.setColumnClass(1, String.class, true);
		}
		return CSAEITable;
	}

	protected String[] getCSAEITableColumnNames() {
		return new String[] {
				" ","","",
				"Item Charge Type",
				"Item Code",
				"Item Name",
				"Contract Applied",
				"Effective Date From",
				"Effective Date To"
				};
	}

	protected int[] getCSAEITableColumnWidths() {
		return new int[] {
				10,0,0,
				120,
				80,
				140,
				120,
				128,
				120};
	}
}