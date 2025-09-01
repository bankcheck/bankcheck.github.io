package com.hkah.client.tx.report;

import com.extjs.gxt.ui.client.Registry;
import com.extjs.gxt.ui.client.Style.SelectionMode;
import com.google.gwt.user.client.rpc.AsyncCallback;
import com.hkah.client.AbstractEntryPoint;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.TableData;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.services.DayendReportListServiceAsync;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.util.CrystalReport;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.TableUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;

public class ReprintWeeklyBill extends MasterPanel {
	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.REPRINTWEEKLYBILL_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.REPRINTWEEKLYBILL_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] { "Name" };
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] { 700 };
	}
	
	@Override
	public boolean isTableViewOnly() {
		return false;
	}
	
	private BasePanel rightPanel = null;
	private BasePanel leftPanel = null;
	
	private BasePanel HistoryPanel = null;
	private LabelBase ReportDateDesc = null;
	private TextDate ReportDate = null;
	
	private LabelBase HistoryPrinterSelectDesc = null;
	private CheckBoxBase HistoryPrinterSelect = null;
	private LabelBase HistoryPrinttoScreenDesc = null;
	private CheckBoxBase HistoryPrinttoScreen = null;
	
	private JScrollPane HistoryScrollPane = null;
	private TableList HistoryTableList = null;
	
	/**
	 * This method initializes
	 *
	 */
	public ReprintWeeklyBill() {
		super();
	}
	
	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		setNoListDB(true);
		setLeftAlignPanel();
		getJScrollPane().setBounds(5, 50, 770, 350);
		return true;
	}
	
	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		enableButton();
		getListTable().setSelectionMode(SelectionMode.MULTI);
		getReportDate().setText(DateTimeUtil.getRollDate(DateTimeUtil.getCurrentDate(), -1));
		searchAction();
	}
	
	@Override
	protected void enableButton(String mode) {
		disableButton();
		getSearchButton().setEnabled(true);
		getPrintButton().setEnabled(true);
	}
	
	@Override
	public void searchAction() {
		if (getSearchButton().isEnabled()) {
			showReportList(getReportDate().getText().substring(6, 10)+
							getReportDate().getText().substring(3, 5)+
							getReportDate().getText().substring(0, 2), true);
		}
	}
	
	@Override
	public void printAction() {
		if (getListTable().getSelectedRow() > -1) {
			canProceed();
		}
	}
	
	@Override
	protected void canProceedReady(boolean isProceedReady) {
		if (isProceedReady) {
			if (getHistoryPrinttoScreen().isSelected()) {
				for (int i = 0; i < getListTable().getSelectedItems().size(); i++) {
					CrystalReport.print(getMainFrame(),
										Factory.getInstance().getSysParameter("DERptPath"),
										"DayEnd",
										getReportDate().getText().substring(6, 10)+
										getReportDate().getText().substring(3, 5)+
										getReportDate().getText().substring(0, 2),
										getListTable().getSelectedItems().get(i).getValue(0).toString(),
										true);
				}
			} 
		} else {
			Factory.getInstance().addErrorMessage(ConstantsMessage.ERROR_DISABLE);
		}
	}
	
	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return null;//getContent();
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

	/* >>> getter methods for init the Component start from here================================== <<< */
	@Override
	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.setSize(800, 500);
			leftPanel.add(getHistoryPanel(), null);
		}
		return leftPanel;
	}
	
	protected BasePanel getRightPanel() {
		if (rightPanel == null) {
			rightPanel = new BasePanel();
		}
		return rightPanel;
	}
	
	
	private BasePanel getHistoryPanel() {
		if (HistoryPanel == null) {
			HistoryPanel = new BasePanel();
			HistoryPanel.setSize(779, 492);
			HistoryPanel.add(getReportDateDesc(), null);
			HistoryPanel.add(getReportDate(), null);
			HistoryPanel.add(getHistoryPrinttoScreenDesc(), null);
			HistoryPanel.add(getHistoryPrinttoScreen(), null);
			HistoryPanel.add(getJScrollPane(), null);
		}
		return HistoryPanel;
	}
	
	/**
	 * @return the reportDateDesc
	 */
	private LabelBase getReportDateDesc() {
		if (ReportDateDesc == null) {
			ReportDateDesc = new LabelBase();
			ReportDateDesc.setText("Report Date:");
			ReportDateDesc.setBounds(10, 10, 100, 20);
		}
		return ReportDateDesc;
	}

	/**
	 * @return the reportDate
	 */
	private TextDate getReportDate() {
		if (ReportDate == null) {
			ReportDate = new TextDate() {
				@Override
				public void setRawValue(String value) {
					super.setRawValue(value);
					getListTable().removeAllRow();
					getListTable().getView().layout();
				}
				
				@Override
				protected void onPressed() {
					getListTable().removeAllRow();
					getListTable().getView().layout();
				}
			};
			ReportDate.setBounds(120, 10, 100, 20);
		}
		return ReportDate;
	}
	
	/**
	 * @return the historyPrinttoScreenDesc
	 */
	private LabelBase getHistoryPrinttoScreenDesc() {
		if (HistoryPrinttoScreenDesc == null) {
			HistoryPrinttoScreenDesc = new LabelBase();
			HistoryPrinttoScreenDesc.setText("Print To Screen");
			HistoryPrinttoScreenDesc.setBounds(686, 10, 100, 20);
		}
		return HistoryPrinttoScreenDesc;
	}

	/**
	 * @return the historyPrinttoScreen
	 */
	private CheckBoxBase getHistoryPrinttoScreen() {
		if (HistoryPrinttoScreen == null) {
			HistoryPrinttoScreen = new CheckBoxBase();
			HistoryPrinttoScreen.setBounds(661, 10, 23, 20);
		}
		return HistoryPrinttoScreen;
	}

	private void showReportList(String dayOfWeek, final boolean isHistory) {
		getMainFrame().setLoading(true);
		((DayendReportListServiceAsync) Registry
				.get(AbstractEntryPoint.DAYEND_REPORT_LIST_SERVICE))
				.getReportList(Factory.getInstance().getSysParameter("DERptPath"), dayOfWeek, isHistory, 
								Factory.getInstance().getSysParameter("FILTERBILL"),
						new AsyncCallback<String[]>() {
					@Override
					public void onSuccess(String[] result) {
						if (result != null) {
							getListTable().removeAllRow();
							getListTable().getView().layout();
							
							for (int i = 0; i < result.length; i++) {
								//System.out.println(result[i]);
								TableData td = new TableData(new String[]{
																	TableUtil.getName2ID("Name")
															 },
															 new Object[]{
																	result[i]
															 });
								getListTable().getStore().add(td);
							}
							getListTable().getView().layout();
						}
						getMainFrame().setLoading(false);
					}

					@Override
					public void onFailure(Throwable caught) {
						getListTable().removeAllRow();
						getMainFrame().setLoading(false);
						Factory.getInstance().addErrorMessage(caught.getMessage());
						caught.printStackTrace();
					}
				});
	}
	
	public static native boolean print(String subDirPath, String rptName, String printerName,
										String noOfCopies, String paperSize, String selectPrinter,
										boolean alertSuccess) /*-{
		var appletName = @com.hkah.client.util.PrintingUtil::getAppletName()();
		if (appletName == null || appletName == '') {
			alert('Cannot get applet:' + appletName);
		}

		var applet = $wnd.document.getElementById(appletName);
		var result = applet.printDayEndReport(subDirPath, rptName, printerName, noOfCopies, paperSize, selectPrinter);

		if (result) {
			if (alertSuccess) {
				alert("print successfully !");
			}
		} else {
			alert(result);
			alert("print fail");
		}
		return result;
	}-*/;
}
