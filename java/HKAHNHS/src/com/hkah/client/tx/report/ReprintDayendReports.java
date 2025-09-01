package com.hkah.client.tx.report;

import com.extjs.gxt.ui.client.Registry;
import com.extjs.gxt.ui.client.Style.SelectionMode;
import com.extjs.gxt.ui.client.widget.form.Radio;
import com.extjs.gxt.ui.client.widget.form.RadioGroup;
import com.google.gwt.user.client.rpc.AsyncCallback;
import com.hkah.client.AbstractEntryPoint;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.panel.TabbedPaneBase;
import com.hkah.client.layout.radiobutton.RadioButtonBase;
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

public class ReprintDayendReports extends MasterPanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.REPRINTDAYENDREPORTS_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.REPRINTDAYENDREPORTS_TITLE;
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

	private TabbedPaneBase TabbedPanel = null;
	private BasePanel WeeklyPanel = null;
	private BasePanel HistoryPanel = null;
	private BasePanel RadioPanel = null;
	private RadioGroup Week = null;
	protected RadioButtonBase Sun = null;
	protected RadioButtonBase Mon = null;
	protected RadioButtonBase Tues = null;
	protected RadioButtonBase Wed = null;
	protected RadioButtonBase Thu = null;
	protected RadioButtonBase Fri = null;
	protected RadioButtonBase Sat = null;

	private LabelBase WeeklyPrinterSelectDesc = null;
	private CheckBoxBase WeeklyPrinterSelect = null;
	private LabelBase WeeklyPrinttoScreenDesc = null;
	private CheckBoxBase WeeklyPrinttoScreen = null;

	private LabelBase ReportDateDesc = null;
	private TextDate ReportDate = null;

	private LabelBase HistoryPrinterSelectDesc = null;
	private CheckBoxBase HistoryPrinterSelect = null;
	private LabelBase HistoryPrinttoScreenDesc = null;
	private CheckBoxBase HistoryPrinttoScreen = null;

	private JScrollPane HistoryScrollPane = null;
	private TableList HistoryTableList = null;

	protected String lastDayOfWeek = null;

	/**
	 * This method initializes
	 *
	 */
	public ReprintDayendReports() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		setNoListDB(true);
		setLeftAlignPanel();
		getJScrollPane().setBounds(5, 110, 770, 290);
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		enableButton();
		getListTable().setSelectionMode(SelectionMode.MULTI);
		getTabbedPane().setSelectedIndex(0);

		lastDayOfWeek = null;
		int curDayOfWeek = DateTimeUtil.getCurrentDayofWeek();

		if (curDayOfWeek == -1) {
			getSun().setSelected(true);
		} else {
			if (curDayOfWeek == 0) {
				getSat().setSelected(true);
			} else if (curDayOfWeek == 1) {
				getSun().setSelected(true);
			} else if (curDayOfWeek == 2) {
				getMon().setSelected(true);
			} else if (curDayOfWeek == 3) {
				getTues().setSelected(true);
			} else if (curDayOfWeek == 4) {
				getWed().setSelected(true);
			} else if (curDayOfWeek == 5) {
				getThu().setSelected(true);
			} else if (curDayOfWeek == 6) {
				getFri().setSelected(true);
			}
		}

		getReportDate().setText(DateTimeUtil.getRollDate(DateTimeUtil.getCurrentDate(), -1));

//		getWeeklyPrinterSelect().setEnabled(false);
		getWeeklyPrinttoScreen().setSelected(true);
		getWeeklyPrinttoScreen().setEnabled(false);
//		getHistoryPrinterSelect().setEnabled(false);
		getHistoryPrinttoScreen().setSelected(true);
		getHistoryPrinttoScreen().setEnabled(false);
	}

	@Override
	protected void enableButton(String mode) {
		disableButton();
		getSearchButton().setEnabled(getTabbedPane().getSelectedIndex() == 1);
		getPrintButton().setEnabled(true);
	}

	@Override
	public void searchAction() {
		if (getSearchButton().isEnabled()) {
			if (getTabbedPane().getSelectedIndex() == 1) {
				showReportList(getReportDate().getText().substring(6, 10) +
								getReportDate().getText().substring(3, 5) +
								getReportDate().getText().substring(0, 2), true);
			}
		}
	}

	@Override
	public void printAction() {
		if (getListTable().getSelectedRow() > -1 || getHistoryTableList().getSelectedRow() > -1) {
			canProceed();
		}
	}

	@Override
	protected void canProceedReady(boolean isProceedReady) {
		if (isProceedReady) {
			if (getTabbedPane().getSelectedIndex() == 0) {
				if (getWeeklyPrinttoScreen().isSelected()) {	
					for (int i = 0; i < getListTable().getSelectedItems().size(); i++) {
						CrystalReport.print(getMainFrame(),
											Factory.getInstance().getSysParameter("DERptPath"),
											"DayEnd",
											lastDayOfWeek,
											getListTable().getSelectedItems().get(i).getValue(0).toString(),
											false,false);
					}
				} else {
//					for (int i = 0; i < getListTable().getSelectedItems().size(); i++) {
//						print("DayEnd\\\\"+lastDayOfWeek+"\\\\",
//								getListTable().getSelectedItems().get(i).getValue(0).toString(), "", "1", "A4",
//								String.valueOf(getWeeklyPrinterSelect().isSelected()), false);
//					}
				}
			} else {
				if (getHistoryPrinttoScreen().isSelected()) {
					for (int i = 0; i < getHistoryTableList().getSelectedItems().size(); i++) {
						
						CrystalReport.print(getMainFrame(),
											Factory.getInstance().getSysParameter("DERptPath"),
											"DayEnd",
											getReportDate().getText().substring(6, 10)+
											getReportDate().getText().substring(3, 5)+
											getReportDate().getText().substring(0, 2),
											getHistoryTableList().getSelectedItems().get(i).getValue(0).toString(),
											true,false);
					}
				} else {
//					for (int i = 0; i < getHistoryTableList().getSelectedItems().size(); i++) {
//						print("DayEnd\\\\Report\\\\"+
//									getReportDate().getText().substring(6, 10)+
//									getReportDate().getText().substring(3, 5)+
//									getReportDate().getText().substring(0, 2)+"\\\\",
//									getHistoryTableList().getSelectedItems().get(i).getValue(0).toString(),
//									"", "1", "A4",
//									String.valueOf(getHistoryPrinterSelect().isSelected()), false);
//					}
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

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	protected TableData filterReportList(String result) {
		return new TableData(new String[]{ TableUtil.getName2ID("Name") }, new Object[]{ result });
	}

	protected void showReportList(String dayOfWeek, final boolean isHistory) {
		getMainFrame().setLoading(true);
		lastDayOfWeek = dayOfWeek;

		if (!isHistory) {
			getListTable().removeAllRow();
			getListTable().getView().layout();
		} else {
			getHistoryTableList().removeAllRow();
			getHistoryTableList().getView().layout();
		}

		((DayendReportListServiceAsync) Registry
				.get(AbstractEntryPoint.DAYEND_REPORT_LIST_SERVICE))
				.getReportList(Factory.getInstance().getSysParameter("DERptPath"), dayOfWeek, isHistory, null,
						new AsyncCallback<String[]>() {
					@Override
					public void onSuccess(String[] result) {
						if (result != null) {
							TableData td = null;
							if (!isHistory) {
								for (int i = 0; i < result.length; i++) {
									td = filterReportList(result[i]);
									if (td != null) {
										getListTable().getStore().add(td);
									}
								}
								if (result.length > 0) {
									getListTable().setSelectRow(0);
								}
								getListTable().getView().layout();
							} else {
								for (int i = 0; i < result.length; i++) {
									td = filterReportList(result[i]);
									if (td != null) {
										getHistoryTableList().getStore().add(td);
									}
								}
								if (result.length > 0) {
									getHistoryTableList().setSelectRow(0);
								}
								getHistoryTableList().getView().layout();
							}
						}
						getMainFrame().setLoading(false);
					}

					@Override
					public void onFailure(Throwable caught) {
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

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/* >>> getter methods for init the Component start from here================================== <<< */
	@Override
	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.setSize(800, 500);
			leftPanel.add(getTabbedPane(), null);
		}
		return leftPanel;
	}

	protected BasePanel getRightPanel() {
		if (rightPanel == null) {
			rightPanel = new BasePanel();
		}
		return rightPanel;
	}

	public TabbedPaneBase getTabbedPane() {
		if (TabbedPanel == null) {
			TabbedPanel = new TabbedPaneBase() {
				public void onStateChange() {
					enableButton();
					if (getSelectedIndex() == 1) {
						searchAction();
					}
				}
			};
			TabbedPanel.setBounds(5, 5, 800, 500);
			TabbedPanel.addTab("Weekly", getWeeklyPanel());
			TabbedPanel.addTab("History", getHistoryPanel());
		}
		return TabbedPanel;
	}

	public BasePanel getWeeklyPanel() {
		if (WeeklyPanel == null) {
			WeeklyPanel = new BasePanel();
			WeeklyPanel.setSize(779, 492);
			WeeklyPanel.add(getRadioPanel(),null);
//			WeeklyPanel.add(getWeeklyPrinterSelectDesc(), null);
//			WeeklyPanel.add(getWeeklyPrinterSelect(), null);
			WeeklyPanel.add(getWeeklyPrinttoScreenDesc(), null);
			WeeklyPanel.add(getWeeklyPrinttoScreen(), null);
			WeeklyPanel.add(getJScrollPane(), null);
		}
		return WeeklyPanel;
	}

	private BasePanel getHistoryPanel() {
		if (HistoryPanel == null) {
			HistoryPanel = new BasePanel();
			HistoryPanel.setSize(779, 492);
			HistoryPanel.add(getReportDateDesc(), null);
			HistoryPanel.add(getReportDate(), null);
//			HistoryPanel.add(getHistoryPrinterSelectDesc(), null);
//			HistoryPanel.add(getHistoryPrinterSelect(), null);
			HistoryPanel.add(getHistoryPrinttoScreenDesc(), null);
			HistoryPanel.add(getHistoryPrinttoScreen(), null);
			HistoryPanel.add(getHistoryScrollPane(), null);
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
					getHistoryTableList().removeAllRow();
					getHistoryTableList().getView().layout();
				}

				@Override
				protected void onPressed() {
					getHistoryTableList().removeAllRow();
					getHistoryTableList().getView().layout();
				}
			};
			ReportDate.setBounds(120, 10, 100, 20);
		}
		return ReportDate;
	}

	/**
	 * @return the historyPrinterSelectDesc
	 */
	private LabelBase getHistoryPrinterSelectDesc() {
		if (HistoryPrinterSelectDesc == null) {
			HistoryPrinterSelectDesc = new LabelBase();
			HistoryPrinterSelectDesc.setText("Printer Select");
			HistoryPrinterSelectDesc.setBounds(571, 10, 100, 20);
		}
		return HistoryPrinterSelectDesc;
	}

	/**
	 * @return the historyPrinterSelect
	 */
	private CheckBoxBase getHistoryPrinterSelect() {
		if (HistoryPrinterSelect == null) {
			HistoryPrinterSelect = new CheckBoxBase();
			HistoryPrinterSelect.setBounds(542, 10, 23, 20);
		}
		return HistoryPrinterSelect;
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

	/**
	 * @return the historyScrollPane
	 */
	private JScrollPane getHistoryScrollPane() {
		if (HistoryScrollPane == null) {
			HistoryScrollPane = new JScrollPane();
			HistoryScrollPane.setViewportView(getHistoryTableList());
			HistoryScrollPane.setBounds(10, 45, 770, 400);
		}
		return HistoryScrollPane;
	}

	/**
	 * @return the historyTableList
	 */
	protected TableList getHistoryTableList() {
		if (HistoryTableList == null) {
			HistoryTableList = new TableList(getHistoryColumnNames(), getHistoryColumnWidths());
		}
		return HistoryTableList;
	}

	private String[] getHistoryColumnNames() {
		return new String[] { "Name" };
	}

	private int[] getHistoryColumnWidths() {
		return new int[] { 700 };
	}

	public BasePanel getRadioPanel() {
		if (RadioPanel == null) {
			RadioPanel = new BasePanel();
			RadioPanel.setHeading("Please select week day to reprint");
			RadioPanel.add(getSun(), null);
			RadioPanel.add(getMon(), null);
			RadioPanel.add(getTues(), null);
			RadioPanel.add(getWed(), null);
			RadioPanel.add(getThu(), null);
			RadioPanel.add(getFri(), null);
			RadioPanel.add(getSat(), null);
			RadioPanel.setLocation(5, 10);
			RadioPanel.setSize(769, 60);
		}
		return RadioPanel;
	}

	public RadioButtonBase getSun() {
		if (Sun == null) {
			Sun = new RadioButtonBase();
			Sun.setText("Sunday");
			Sun.setId("Sun");
			Sun.setBounds(29, 23, 70, 20);
			getWeek().add(getSun());
		}
		return Sun;
	}

	public RadioButtonBase getMon() {
		if (Mon == null) {
			Mon = new RadioButtonBase();
			Mon.setText("Monday");
			Mon.setId("Mon");
			Mon.setBounds(116, 23, 70, 20);
			getWeek().add(getMon());
		}
		return Mon;
	}

	public RadioButtonBase getTues() {
		if (Tues == null) {
			Tues = new RadioButtonBase();
			Tues.setText("Tuesday");
			Tues.setId("Tue");
			Tues.setBounds(211, 23, 70, 20);
			getWeek().add(getTues());
		}
		return Tues;
	}

	public RadioButtonBase getWed() {
		if (Wed == null) {
			Wed = new RadioButtonBase();
			Wed.setText("Wednesday");
			Wed.setId("Wed");
			Wed.setBounds(307, 23, 89, 20);
			getWeek().add(getWed());

		}
		return Wed;
	}

	public RadioButtonBase getThu() {
		if (Thu == null) {
			Thu = new RadioButtonBase();
			Thu.setText("Thursday");
			Thu.setId("Thu");
			Thu.setBounds(415, 23, 77, 20);
			getWeek().add(getThu());

		}
		return Thu;
	}

	public RadioButtonBase getFri() {
		if (Fri == null) {
			Fri = new RadioButtonBase();
			Fri.setText("Friday");
			Fri.setId("Fri");
			Fri.setBounds(518, 23, 70, 20);
			getWeek().add(getFri());

		}
		return Fri;
	}

	public RadioButtonBase getSat() {
		if (Sat == null) {
			Sat = new RadioButtonBase();
			Sat.setText("Saturday");
			Sat.setId("Sat");
			Sat.setBounds(599, 23, 70, 20);
			getWeek().add(getSat());
		}
		return Sat;
	}

	public LabelBase getWeeklyPrinterSelectDesc() {
		if (WeeklyPrinterSelectDesc == null) {
			WeeklyPrinterSelectDesc = new LabelBase();
			WeeklyPrinterSelectDesc.setText("Printer Select");
			WeeklyPrinterSelectDesc.setBounds(571, 79, 100, 20);
		}
		return WeeklyPrinterSelectDesc;
	}

	public CheckBoxBase getWeeklyPrinterSelect() {
		if (WeeklyPrinterSelect == null) {
			WeeklyPrinterSelect = new CheckBoxBase();
			WeeklyPrinterSelect.setBounds(542, 79, 23, 20);
		 }
		return WeeklyPrinterSelect;
	}

	public LabelBase getWeeklyPrinttoScreenDesc() {
		if (WeeklyPrinttoScreenDesc == null) {
			WeeklyPrinttoScreenDesc = new LabelBase();
			WeeklyPrinttoScreenDesc.setText("Print To Screen");
			WeeklyPrinttoScreenDesc.setBounds(686, 79,100, 20);
		}
		return WeeklyPrinttoScreenDesc;
	}

	public CheckBoxBase getWeeklyPrinttoScreen() {
		if (WeeklyPrinttoScreen == null) {
			WeeklyPrinttoScreen = new CheckBoxBase();
			WeeklyPrinttoScreen.setBounds(661, 79, 23, 20);
		 }
		return WeeklyPrinttoScreen;
	}

	public RadioGroup getWeek() {
		if (Week == null) {
			Week = new RadioGroup() {
				@Override
				protected void onRadioSelected(Radio radio) {
					super.onRadioSelected(radio);
					showReportList(radio.getId(), false);
				}
			};
		}
		return Week;
	}
}