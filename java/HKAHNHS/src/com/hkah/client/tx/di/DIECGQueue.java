//menu name : E.C.G Queue
package com.hkah.client.tx.di;

import java.util.Date;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.google.gwt.user.datepicker.client.CalendarUtil;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.dialog.DlgEcgQueueReport;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextDateWithCheckBox;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DIECGQueue extends MasterPanel {

	public DIECGQueue(BasePanel panelFrom) {
		super();
		// this.panelFrom = panelFrom;
	}

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.ECGQUEUE_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.ECGQUEUE_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] { 
				"DI No", "", "Patient No", "Name", "Doctor",
				"Exam", "Exam Date", "Loc.", "Desc.", "Stn Desc",
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] { 
				80, 30, 70, 150, 50,
				150, 150, 50, 100, 0,
		};
	}

	private BasePanel rightPanel = null;
	private BasePanel leftPanel = null;

	private BasePanel ParaPanel = null;
	private LabelBase ECGQueueRemoveDesc = null;
	private CheckBoxBase ECGQueueRemove = null;
	private LabelBase ECGQueueFromDesc = null;
	private TextDateWithCheckBox ECGQueueFrom = null;
	private LabelBase ECGQueueToDesc = null;
	private TextDateWithCheckBox ECGQueueTo = null;
	private ButtonBase RemoveRow = null;
	private LabelBase CountDesc = null;
	private TextReadOnly Count = null;

	private TableList LowerTable = null;
	private JScrollPane lowerScrollPane = null;

	private TableList UpperTable = null;
	private JScrollPane UpperJScrollPane = null;

	private FieldSetBase grpUpperTable = null; // Master Personal Information
	private FieldSetBase grpLowerTable = null; // Master Personal Information

	protected DlgEcgQueueReport dlgEcgQueueReport = null;

	private String selectedXRGID = "";

	/**
	 * This method initializes test
	 */
	public DIECGQueue() {
		super();
	}

	private JScrollPane getUpperJScrollPane() {
		if (UpperJScrollPane == null) {
			UpperJScrollPane = new JScrollPane();
			UpperJScrollPane.setViewportView(getUpperTable());
			UpperJScrollPane.setBounds(10, 50, 850, 300);
		}
		return UpperJScrollPane;
	}

	private JScrollPane getlowerScrollPane() {
		if (lowerScrollPane == null) {
			lowerScrollPane = new JScrollPane();
			lowerScrollPane.setViewportView(getLowerTable());
			lowerScrollPane.setBounds(10, 0, 850, 300);
		}
		return lowerScrollPane;
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		setLeftAlignPanel();
		getJScrollPane().setBounds(800, 50, 1, 1);
		getListTable().setVisible(false);
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		Date fromDate = DateTimeUtil.parseDateTime(getMainFrame().getServerDateTime());
		CalendarUtil.addMonthsToDate(fromDate, -1);
		getECGQueueFrom().setText(DateTimeUtil.formatDate(fromDate));
		getECGQueueTo().setText(getMainFrame().getServerDate());
		getCount().setText(ZERO_VALUE);
	}

	@Override
	public void saveAction() {
		// for override if necessary
		selectedXRGID = "";
		if (getListTable().getRowCount() > 0) {
			for (int i = 0; i < getLowerTable().getRowCount(); i++) {
				getLowerTable().setSelectRow(i);
				if (selectedXRGID.length() > 0) {
					selectedXRGID += ";";
				}
				selectedXRGID += getLowerTable().getSelectedRowContent()[9];
			}
			super.saveAction();
		}

	}
	
	@Override
	protected void savePostAction() {
		// for override if necessary
		super.saveAction();
		super.savePostAction();
		System.out.println("savePostAction()");
		getPrintButton().setEnabled(true);
	}

	@Override
	protected void cancelPostAction() {
		// for override if necessary
		initAfterReady();
		searchAction();

	}

	/*
	 * @Override 
	 * public void searchAction() { super.searchAction(); }
	 */
	
	@Override
	protected void searchPostAction() {
		// for override if necessary
		getListTable().removeAllRow();
		getLowerTable().removeAllRow();
		if (getECGQueueRemove().getValue()) {
			grpLowerTable.setHeading("Selected to E. C. G. Queue");
			setActionType(QueryUtil.ACTION_MODIFY);
		} else {
			grpLowerTable.setHeading("Selected to OPD");
			setActionType(QueryUtil.ACTION_APPEND);
		}

	}
	
	@Override
	public void printAction() {
		/*
		 * Date fromDate =
		 * DateTimeUtil.parseDateTime(getMainFrame().getServerDateTime()); String
		 * pFromDate = DateTimeUtil.formatDate(fromDate); String pToDate =
		 * DateTimeUtil.formatDate(fromDate); Map<String, String> map = new
		 * HashMap<String, String>();
		 * 
		 * map.put("fromDate", pFromDate); map.put("toDate", pToDate);
		 * Report.print(Factory.getInstance().getUserInfo(), "ECGQUEUE", map, new
		 * String[] {pFromDate, pToDate}, new String[] {"PATNO", "PATTITLE"});
		 */
		getDlgEcgQueueReport().show();

	}

	@Override
	protected void enableButton(String mode) {
		// disable all button
		disableButton();

		getSearchButton().setEnabled(true);
		getPrintButton().setEnabled(true);
		if (getECGQueueRemove().getValue()) {
			getECGQueue().setEnabled(false);
		} else {
			getECGQueue().setEnabled(true);
		}
	}

	@Override
	protected void performListPost() {
		// for child class call
		getUpperTable().setListTableContent(getListTable().getStore().getModels());
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public Component getDefaultFocusComponent() {
		return getECGQueueFrom().getDateField();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {
		getSearchButton().setEnabled(true);
		getSaveButton().setEnabled(false);
		getCancelButton().setEnabled(false);

		getListTable().removeAllRow();
		getUpperTable().removeAllRow();
		getLowerTable().removeAllRow();

	}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {
	}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
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
		String[] inParm = new String[] { 
				(getECGQueueRemove().getValue() ? "1" : "-1"), 
				getECGQueueFrom().getText(),
				getECGQueueTo().getText() };

		return inParm;
	}

	/* >>> ~16~ Set Fetch Input Parameters ================================ <<< */
	@Override
	protected String[] getFetchInputParameters() {
		String[] selectedContent = getListSelectedRow();
		return new String[] { selectedContent[0] };
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {

	}

	/* >>> ~15~ Set Fetch Output Results ============================== <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {
	}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return new String[] { selectedXRGID };
	}

	/* >>> ~16.1~ Set Action Output Parameters =========================== <<< */
	@Override
	protected void getNewOutputValue(String returnValue) {
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	private ButtonBase getECGQueue() {
		if (RemoveRow == null) {
			RemoveRow = new ButtonBase() {
				@Override
				public void onClick() {
					if (getListTable().getRowCount() > 0) {
						Factory.getInstance().isConfirmYesNoDialog(
								"Do you want to remove the selected exam from E.C.G. queue ?",
								new Listener<MessageBoxEvent>() {
									@Override
									public void handleEvent(MessageBoxEvent be) {
										if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
											QueryUtil.executeMasterAction(getUserInfo(), getTxCode(),
													QueryUtil.ACTION_DELETE,
													new String[] { getUpperTable().getSelectedRowContent()[9]},
													new MessageQueueCallBack() {
														@Override
														public void onPostSuccess(MessageQueue mQueue) {
															// TODO Auto-generated
															// method stub
															if (mQueue.success()) {
																getUpperTable().removeRow(getUpperTable().getSelectedRow());
															}
														}
													});
										}
									}
								});
					}
				}
			};
			RemoveRow.setText("Remove from Queue", 'R');
			RemoveRow.setBounds(10, 355, 115, 25);
		}
		return RemoveRow;
	}

	public DlgEcgQueueReport getDlgEcgQueueReport() {
		if (dlgEcgQueueReport == null) {
			dlgEcgQueueReport = new DlgEcgQueueReport(getMainFrame());
		}
		return dlgEcgQueueReport;
	}

	private void tblRowToRow(TableList srcTbl, TableList tgtTbl) {
		String row[] = new String[] { 
				srcTbl.getSelectedRowContent()[0], 
				srcTbl.getSelectedRowContent()[1],
				srcTbl.getSelectedRowContent()[2], 
				srcTbl.getSelectedRowContent()[3], 
				srcTbl.getSelectedRowContent()[4],
				srcTbl.getSelectedRowContent()[5], 
				srcTbl.getSelectedRowContent()[6], 
				srcTbl.getSelectedRowContent()[7],
				srcTbl.getSelectedRowContent()[8], 
				srcTbl.getSelectedRowContent()[9] };
		tgtTbl.addRow(row);

		int selectrow = srcTbl.getSelectedRow();
		int rowcount = srcTbl.getRowCount();
		srcTbl.removeRow(selectrow);
		if (selectrow == (rowcount - 1)) {
			srcTbl.setRowSelectionInterval(selectrow - 1, selectrow - 1);
		} else {
			srcTbl.setRowSelectionInterval(selectrow, selectrow);
		}
		getCount().setText(Integer.toString(getLowerTable().getRowCount()));
		getSaveButton().setEnabled(getLowerTable().getRowCount() > 0);
		getCancelButton().setEnabled(getLowerTable().getRowCount() > 0);
		getECGQueue().setEnabled(false);
		
	}

	public FieldSetBase getgrpUpperTable() {
		if (grpUpperTable == null) {
			grpUpperTable = new FieldSetBase();
			grpUpperTable.setBounds(5, 10, 800, 800);
			grpUpperTable.setHeading("E. C. G. Queue");
			grpUpperTable.setSize(880, 410);
			grpUpperTable.add(getParaPanel(), null);
			grpUpperTable.add(getECGQueue(), null);
			grpUpperTable.add(getUpperJScrollPane(), null);
		}
		return grpUpperTable;
	}

	public FieldSetBase getgrpLowerTable() {
		if (grpLowerTable == null) {
			grpLowerTable = new FieldSetBase();
			grpLowerTable.setBounds(5, 440, 800, 800);
			grpLowerTable.setHeading("Selected to OPD");
			grpLowerTable.setSize(880, 370);
			grpLowerTable.add(getlowerScrollPane(), null);
			grpLowerTable.add(getJScrollPane());
			grpLowerTable.add(getCountDesc(), null);
			grpLowerTable.add(getCount(), null);
		}
		return grpLowerTable;
	}

	@Override
	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.add(getgrpUpperTable());
			leftPanel.add(getgrpLowerTable());
		}
		return leftPanel;
	}

	private TableList getLowerTable() {
		if (LowerTable == null) {
			LowerTable = new TableList(getColumnNames(), getColumnWidths()) {
				@Override
				public void doubleClick() {
					tblRowToRow(getLowerTable(), getUpperTable());

				}
			};
		}
		return LowerTable;
	}

	private TableList getUpperTable() {
		if (UpperTable == null) {
			UpperTable = new TableList(getColumnNames(), getColumnWidths()) {
				public void doubleClick() {
					tblRowToRow(getUpperTable(), getLowerTable());
				}
			};
		}
		return UpperTable;
	}

	protected BasePanel getRightPanel() {

		if (rightPanel == null) {
			rightPanel = new BasePanel();
		}
		return rightPanel;
	}

	public BasePanel getParaPanel() {
		if (ParaPanel == null) {
			ParaPanel = new BasePanel();
			ParaPanel.setBounds(10, 10, 771, 40);
			ParaPanel.setBorders(true);
			ParaPanel.add(getECGQueueRemoveDesc(), null);
			ParaPanel.add(getECGQueueRemove(), null);
			ParaPanel.add(getECGQueueFromDesc(), null);
			ParaPanel.add(getECGQueueFrom(), null);
			ParaPanel.add(getECGQueueToDesc(), null);
			ParaPanel.add(getECGQueueTo(), null);
		}
		return ParaPanel;
	}

	private LabelBase getECGQueueRemoveDesc() {
		if (ECGQueueRemoveDesc == null) {
			ECGQueueRemoveDesc = new LabelBase();
			ECGQueueRemoveDesc.setText("Remove");
			ECGQueueRemoveDesc.setBounds(195, 10, 95, 20);
		}
		return ECGQueueRemoveDesc;
	}

	public CheckBoxBase getECGQueueRemove() {
		if (ECGQueueRemove == null) {
			ECGQueueRemove = new CheckBoxBase();
			ECGQueueRemove.setBounds(220, 10, 70, 20);
		}
		return ECGQueueRemove;
	}

	private LabelBase getECGQueueFromDesc() {
		if (ECGQueueFromDesc == null) {
			ECGQueueFromDesc = new LabelBase();
			ECGQueueFromDesc.setText("Exam From Date");
			ECGQueueFromDesc.setBounds(305, 10, 95, 20);
		}
		return ECGQueueFromDesc;
	}

	public TextDateWithCheckBox getECGQueueFrom() {
		if (ECGQueueFrom == null) {
			ECGQueueFrom = new TextDateWithCheckBox();
			ECGQueueFrom.setBounds(405, 10, 120, 20);
		}
		return ECGQueueFrom;
	}

	private LabelBase getECGQueueToDesc() {
		if (ECGQueueToDesc == null) {
			ECGQueueToDesc = new LabelBase();
			ECGQueueToDesc.setText("Exam To Date");
			ECGQueueToDesc.setBounds(555, 10, 95, 20);
		}
		return ECGQueueToDesc;
	}

	public TextDateWithCheckBox getECGQueueTo() {
		if (ECGQueueTo == null) {
			ECGQueueTo = new TextDateWithCheckBox();
			ECGQueueTo.setBounds(640, 10, 120, 20);
		}
		return ECGQueueTo;
	}

	private LabelBase getCountDesc() {
		if (CountDesc == null) {
			CountDesc = new LabelBase();
			CountDesc.setText("Selected Exam");
			CountDesc.setBounds(600, 305, 150, 20);
		}
		return CountDesc;
	}

	private TextReadOnly getCount() {
		if (Count == null) {
			Count = new TextReadOnly();
			Count.setBounds(700, 305, 73, 20);
		}
		return Count;
	}
}