package com.hkah.client.tx.report;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.extjs.gxt.ui.client.Registry;
import com.extjs.gxt.ui.client.Style.SelectionMode;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.google.gwt.core.client.GWT;
import com.google.gwt.user.client.Window;
import com.google.gwt.user.client.rpc.AsyncCallback;
import com.google.gwt.user.client.ui.HTML;
import com.hkah.client.AbstractEntryPoint;
import com.hkah.client.Resources;
import com.hkah.client.common.Factory;
import com.hkah.client.event.CallbackListener;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboRollbackBillType;
import com.hkah.client.layout.combobox.ComboSiteType;
import com.hkah.client.layout.dialog.DlgBrowserPanel;
import com.hkah.client.layout.dialog.DlgWeeklyBillHistory;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.panel.TabbedPaneBase;
import com.hkah.client.layout.table.TableData;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.services.DayendReportListServiceAsync;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.Report;
import com.hkah.client.util.TableUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class ReprintCoverLetter extends MasterPanel {
	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.REPRINTCL_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.REPRINTCL_TITLE;
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
	private BasePanel HistoryPanel = null;
	private BasePanel linePanel = null;
	private LabelBase ReportDateDesc = null;
	private TextDate ReportDate = null;
	
	private BasePanel WeeklyPanel = null;
	private LabelBase WeeklySiteCodeDesc = null;
	private ComboSiteType WeeklySiteCode = null;	
	private TextString WeeklySlpNO = null;
	private LabelBase WeeklySlpNoDesc = null;
	private LabelBase WeeklyDateStartDesc = null;
	private TextDate WeeklyDateStart = null;	
	
	private LabelBase HistoryPrinterSelectDesc = null;
	private CheckBoxBase HistoryPrinterSelect = null;
	private LabelBase HistoryPrinttoScreenDesc = null;
	private CheckBoxBase HistoryPrinttoScreen = null;
	
	private JScrollPane HistoryScrollPane = null;
	private TableList HistoryTableList = null;

	private LabelBase PrinttoScreenDesc = null;
	private CheckBoxBase PrinttoScreen = null;	
	private CheckBoxBase PrintToFile = null;
	private LabelBase PrintToFileDesc = null;
			
	private BasePanel WeeklyStatPanel = null;
	private LabelBase SiteCodeDesc = null;
	private ComboSiteType SiteCode = null;	
	private LabelBase DateRangeStartDesc = null;
	private TextDate DateRangeStart = null;
	private LabelBase DateRangeEndDesc = null;
	private TextDate DateRangeEnd = null;		
	private TextString SlpNO = null;
	private LabelBase SlpNoDesc = null;
	private LabelBase WeeklyPrinttoScreenDesc = null;
	private CheckBoxBase WeeklyPrinttoScreen = null;
	private CheckBoxBase WeeklyPrintToFile = null;
	private LabelBase WeeklyPrintToFileDesc = null;
	
	private LabelBase WBillDesc = null;
	private CheckBoxBase WBill = null;
	private LabelBase CovLetterDesc = null;
	private CheckBoxBase CovLetter = null;
	private LabelBase IPStatmentWBDesc = null;
	private CheckBoxBase IPStatmentWB = null;
	private LabelBase PatientCodeDesc = null;
	private TextString PatientCode = null;
	private LabelBase IsTWAHDesc = null;
	private CheckBoxBase IsTWAH = null;
	
	
	private ButtonBase saveButton = null;
	private ButtonBase showHistoryButton = null;
	private ButtonBase postToAppButton = null;
	private ComboRollbackBillType rollbackBillType = null;
	private HTML Line = null;	
	private String currDate = null;	
	private boolean isPostToApp = false;
	
	private DlgWeeklyBillHistory weeklyBillHistoryDialog = null;	

//	DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
//	Date date = new Date();
//	Calendar cal = Calendar.getInstance();


		
	/**
	 * This method initializes
	 *
	 */
	public ReprintCoverLetter() {
		super();
	}
	
	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		setNoListDB(true);
		setLeftAlignPanel();
		getPrintButton().setText("Open");
		getPrintButton().setIcon(Resources.ICONS.open());
		getJScrollPane().setBounds(5, 50, 770, 350);
		return true;
	}
	
	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		enableButton();
		getListTable().setSelectionMode(SelectionMode.MULTI);
		getReportDate().setText(DateTimeUtil.getRollDate(DateTimeUtil.getCurrentDate(), -1));
		getWeeklyPrinttoScreen().setSelected(true);
		currDate = getMainFrame().getServerDate();		
		getWeeklyDateStart().setText(getMainFrame().getServerDate());
		if (TWAH_VALUE.equals(getUserInfo().getSiteCode())) {
			getIsTWAHDesc().setVisible(true);
			getIsTWAH().setVisible(true);
			getIsTWAH().setSelected(true);
			getWeeklyPrinttoScreen().setSelected(false);
			getIPStatmentWBDesc().setText("Cover Letter/IP Statement Summary");
		}
		searchAction();
	}
	
	@Override
	protected void enableButton(String mode) {
		disableButton();
		getSearchButton().setEnabled(true);
		getPrintButton().setEnabled(true);
		getSaveButton().setEnabled(true);
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
		if (getTabbedPane().getSelectedIndex() == 0) {
			if (getListTable().getSelectedRow() > -1) {
				canProceed();
			}
		} else if(getTabbedPane().getSelectedIndex() == 1) {
			//checking
			if (!validatePrintAction()) {
				return;
			}

//			String steCode = getWeeklySiteCode().getText().trim();
			String steCode = getUserInfo().getSiteCode();
			String stename = getWeeklySiteCode().getDisplayText();
			String startDate = getWeeklyDateStart().getText().trim();
//			String endDate = getWeeklyDateEnd().getText().trim();
//			String dateRange = startDate+" to "+endDate;
			final String dateRange = startDate;		
			Map<String, String> map = new HashMap<String, String>();
			map.put("SteCode", steCode);
			map.put("SteName", stename);
			map.put("StartDate", startDate);
//			map.put("EndDate", endDate);
			map.put("SUBREPORT_DIR", CommonUtil.getReportDir());
			map.put("printDate",dateRange);
			final Map<String, String> mapTWAH = map;			
			
			if (getIsTWAH().isSelected()) {
				QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
						new String[] {"DAYENDSLIPS", "PATNO,SLPNO", "ENABLED = 1 AND SLPTYPE = 'I' AND TO_CHAR(PRINTDATE,'DD/MM/YYYY') ='" + startDate + "'"},
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {							
							final List<String[]> list = mQueue.getContentAsArray();
							
							Factory.getInstance().isConfirmYesNoDialog("Confirm to print "+list.size()+"set of Cover Letter and IP Statement Summary?",new Listener<MessageBoxEvent>() {
								public void handleEvent(MessageBoxEvent be) {
									if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
										Map<String,String> mapWB = new HashMap<String,String>();
										Map<String,String> mapChrgSmy = new HashMap<String,String>();
										String startDateTWAH = getWeeklyDateStart().getText().trim();										
										String slpnoTWAH = null;
										
										for (String[] f : list) {
											slpnoTWAH = f[1];
											mapWB.put("SUBREPORT_DIR", CommonUtil.getReportDir());
											mapWB.put("DOCBKGCPY",Factory.getInstance().getSysParameter("DOCBKGCPY"));
											mapWB.put("watermark", CommonUtil.getReportImg("copy_watermark.gif"));
											mapWB.put("ISCOPY", "Y");								
											mapWB.put("ALLSLPNO",slpnoTWAH);
											
											mapChrgSmy.put("SUBREPORT_DIR", CommonUtil.getReportDir());
											mapChrgSmy.put("P_SLPNO", slpnoTWAH );
											mapChrgSmy.put("ALLSLPNO", slpnoTWAH );
											mapChrgSmy.put("ISCOPY", "");
											mapChrgSmy.put("NEWACM", null);
											mapChrgSmy.put("watermark", CommonUtil.getReportImg("copy_watermark.gif"));
											mapChrgSmy.put("DOCBKGCPY",Factory.getInstance().getSysParameter("DOCBKGCPY"));
											mapChrgSmy.put("printDate",dateRange);
/*											
											PrintingUtil.print("DEFAULTPRT","DAYENDCOVERLETTER_TWAH",mapTWAH,"",
													new String[] {
													startDateTWAH,
													slpnoTWAH
													},
													new String[] {"ALLSLPNO", "DSLP.PATNO", "PATNAME", 
													"PATFNAME", "BEDCODE", "PATTITLE", "AMT", "PRINTDATE",
													"FROMDATE","TODATE"},
													0, null, null, null, null, 1, false);
*/											
											Factory.getInstance()
											.addRequiredReportDesc(mapChrgSmy,
												new String[] {
														"MapLanguage", "MapLanguage", "MapLanguage",
														"MapLanguage", "MapLanguage", "MapLanguage",
														"MapLanguage", "MapLanguage", "MapLanguage",
														"MapLanguage", "MapLanguage", "MapLanguage",
														"MapLanguage", "MapLanguage", "MapLanguage",
														"MapLanguage", "MapLanguage", "MapLanguage",
														"MapLanguage", "MapLanguage", "MapLanguage"
												},
												new String[] {
														"TotChgTtl", "Copy", "BillNo", "BedNo", "DisDtTime",
														"PatName", "TreDr", "AdmDtTime", "PatNo", "Page",
														"SpecialFee", "DocCredit", "Credits", "HosCharge",
														"DocCharge", "HosCredit", "Charges", "Refund",
														"SpecialSrv", "Packages", "Balance"
												},
												"HKAH".equals(getUserInfo().getSiteCode())?"CTE":"CHT");								
											if (isPostToApp) {
												final String slpno = slpnoTWAH;
												final Map<String,String> map = mapChrgSmy;
												final String startDate = startDateTWAH;
												QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
														new String[] {"APPBILLS", "COUNT(1)", "SLPNO='" + slpnoTWAH
													+ "' AND BILLSTS='N' "},
														new MessageQueueCallBack() {
													@Override
													public void onPostSuccess(MessageQueue mQueue) {
														if (mQueue.success()) {
															int value = 0;
															try {
																value = Integer.parseInt(mQueue.getContentField()[0]);
																if (value > 0) {
																	MessageBoxBase.confirm("Mobile Bill", ConstantsMessage.MSG_BILL_ISCREATEBILL,
																			new Listener<MessageBoxEvent>() {
																		public void handleEvent(MessageBoxEvent be) {
																			if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
																				genWeekBillTWAH(slpno, map, startDate);
																				isPostToApp = false;
																			} 
																		}
																	});
																} else {
																	genWeekBillTWAH(slpno, map, startDate);
																	isPostToApp = false;
																}
															} catch (Exception e) {
															}
														}
													}
												});
											} else {
													PrintingUtil.print("WEEKLYBILLPRT", "ChrgSmyCoverLetterSet",
															mapChrgSmy, null, new String[] { 
																startDateTWAH,
																slpnoTWAH 
															},
															new String[] {
																	"PATNAME", "PATCNAME", "SLPNO", "PATNO",
																	"REGDATE", "REGTIME", "BEDACM", "INPDDATE",
																	"INPDTIME", "DOCNAME", "DOCCNAME",
																	"BEDCODE", "ACMNAME", "ALLSLPNO", "PATFNAME",
																	"PATTITLE", "AMT", "FROMDATE", "TODATE"
															}, 1,
															new String[] { 
																			"CHRGSMYWB_SUB",
																			"CHRGSMYWB_SUB1"													
																		},
															new String[][] {
																	{ 
																		getAllSlip(slpnoTWAH), null, startDateTWAH
																	},
																	{
																		slpnoTWAH, startDateTWAH
																	}
															},
															new String[][] {
																	{
																		"DESCRIPTION", "QTY", "AMOUNT", "STNTYPE", "ITMTYPE",
																		"DOCCODE", "DOCNAME", "DOCCNAME", "CDESCCODE"
																	},
																	{
																		"STNTDATE", "AMOUNT" ,"DESCRIPTION", "QTY","CDESCCODE"
																	}
															},
															new boolean[][] {
																	{ 
																		false, true, false, false, false, false, false, false, false 
																	},
																	{
																		false, true, false, true, false
																	}															
															}, 1, false);
											}
										}
										Factory.getInstance().addInformationMessage("Printing completed!");
									}
								}
							});							
						}else{
							Factory.getInstance().addErrorMessage("No record found on "+getWeeklyDateStart()+"!", getWeeklyDateStart());;			
						}
					}
				});							
			}else{
				if (getWeeklyPrinttoScreen().isSelected()) {//use report panel				
					// Weekly Bill Report
					if (getWeekBill().isSelected()) {
						map.put("dateRange",dateRange);
						Report.print(Factory.getInstance().getUserInfo(), "RptWeekBill_xls",
								map,
								new String[] {"rptNameWDate",startDate},
								new String[] {"PATNO","SLPNO","PATNAME",
										"PATFNAME","BEDCODE","TITDESC","REGDATE",
										"SLPTYPE","ARCODE","OUTAMT"});
					}
					
					// Cover Letter
					if (getCoverLetter().isSelected()) {
						map.put("printDate",dateRange);
						/*					
						Report.print(Factory.getInstance().getUserInfo(), "DAYENDCOVERLETTER",
								map,
								new String[] {
										startDate,
										getWeeklySlpNoCode().getText()
										},
								new String[] {"ALLSLPNO", "DSLP.PATNO", "PATNAME", 
								"PATFNAME", "BEDCODE", "PATTITLE", "AMT", "PRINTDATE",
								"FROMDATE","TODATE"});
						*/						

						PrintingUtil.print("", "DAYENDCOVERLETTER", map, "",
								new String[] {
								startDate,
								getWeeklySlpNoCode().getText()
								},
								new String[] {
								"ALLSLPNO", "DSLP.PATNO", "PATNAME", 
								"PATFNAME", "BEDCODE", "PATTITLE", "AMT", "PRINTDATE",
								"FROMDATE","TODATE"
								},
								0, null, null, null, null, 1,
								false, true, new String[] { "docx" }, true);
														
					}
					
					if (getIPStatmentWB().isSelected()) {
						if (TWAH_VALUE.equals(getUserInfo().getSiteCode())) {
							String slpnoTWAH = getWeeklySlpNoCode().getText();							
							Report.print(getUserInfo(), "ChrgSmy", map,
									 new String[] {
										slpnoTWAH
									 },
									 new String[] {
											"PATNAME", "PATCNAME", "SLPNO", "PATNO",
											"REGDATE", "REGTIME", "BEDACM", "INPDDATE",
											"INPDTIME", "DOCNAME", "DOCCNAME"
									 },
									 new boolean[] {
											false, false, false, false, false, false,
											false, false, false, false, false
									 },
									 new String[] {
											"CHRGSMY_SUB"
									 } ,
									 new String[][] {
											{
													getAllSlip(slpnoTWAH), null
											}
									 },
									 new String[][] {
											{
													"DESCRIPTION" ,"QTY", "AMOUNT",
													"STNTYPE", "ITMTYPE", "DOCCODE",
													"DOCNAME", "DOCCNAME", "CDESCCODE"
											}
									 },
									 new boolean[][] {
											{
													false, true, false, false, false,
													false, false, false, false
											}
									 }, "", true, false, true, false, null, null, null, false);							
						}else{
							Map<String,String> mapWB = new HashMap<String,String>();				
							mapWB.put("SUBREPORT_DIR", CommonUtil.getReportDir());
							mapWB.put("DOCBKGCPY",Factory.getInstance().getSysParameter("DOCBKGCPY"));
							mapWB.put("watermark", CommonUtil.getReportImg("InterimBill.gif"));
							mapWB.put("ALLSLPNO",getWeeklySlpNoCode().getText());
							mapWB.put("ISCOPY", "Y");					
							
							Factory.getInstance()
							.addRequiredReportDesc(mapWB,
									new String[] {
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage", 
									"MapLanguage", "MapLanguage", "MapLanguage"
									},
									new String[] {
											"StaOfAut", "AdmDtTime", "PatName",
											"DisDtTime", "TreDr", "BillNo",
											"PatNo", "BedNo", "Copy",
											"Page", "Date", "Item",
											"Amount", "TotChg", "TotRfd",
											"Balance", "Credits", "StatBalance",
											"BalanceFwd", "BedNum", "BedClass"
									},
									"HKAH".equals(getUserInfo().getSiteCode())?"CTE":"CHT");
							
							if (isPostToApp) {
								final Map<String,String> mapW =  mapWB;
								final String sDate = startDate;
								QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
										new String[] {"APPBILLS", "COUNT(1)", "SLPNO='" + getWeeklySlpNoCode().getText()
									+ "' AND BILLSTS='N' "},
										new MessageQueueCallBack() {
									@Override
									public void onPostSuccess(MessageQueue mQueue) {
										if (mQueue.success()) {
											int value = 0;
											try {
												value = Integer.parseInt(mQueue.getContentField()[0]);
												if (value > 0) {
													MessageBoxBase.confirm("Mobile Bill", ConstantsMessage.MSG_BILL_ISCREATEBILL,
															new Listener<MessageBoxEvent>() {
														public void handleEvent(MessageBoxEvent be) {
															if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
																genWeekBillHKAH(mapW,sDate);
																isPostToApp = false;
															} 
														}
													});
												} else {
													genWeekBillHKAH(mapW,sDate);
													isPostToApp = false;
												}
											} catch (Exception e) {
											}
										}
									}
								});
							} else {							
								Report.print(getUserInfo(), "IPStatementWB", mapWB,
										new String[] { getWeeklySlpNoCode().getText(), startDate },
										new String[] {
												"PATNAME", "PATCNAME" ,"SLPNO", "PATNO",
												"REGDATE", "REGTIME", "BEDACM", "INPDDATE",
												"INPDTIME", "DOCNAME", "DOCCNAME", "FROM_WBDATE", 
												"TO_WBDATE"
										},
										new boolean[] {
												false, false, false, false, false, false,
												false, false, false, false, false, false, false
										},
										new String[] {
												"IPStatementWB_Sub4",
												"IPStatementWB_Sub1",
												"IPStatementWB_Sub3"								
										} ,
										new String[][] {
												{
													getWeeklySlpNoCode().getText(), startDate
												},
												{
													getWeeklySlpNoCode().getText(), startDate
												},
												{
													getWeeklySlpNoCode().getText(), startDate
												}
										},
										new String[][] {
												{
														"STNTDATE", "AMOUNT", "DESCRIPTION", "QTY", "CDESCCODE"
														
												},
												{
														"STNTDATE", "AMOUNT", "DESCRIPTION", "QTY",
														"TOTALREFUND", "TOTALCHARGE", "CDESCCODE", "CDESCCODE2"
												},
												{
														"STNTDATE", "AMOUNT", "DESCRIPTION", "QTY", "CDESCCODE"
												},
										},
										new boolean[][] {
												{
														false, true, false, true, false
												},
												{
														false, true, false, true, true, true, false, false
												},
												{
														false, true, false, true, false
												}
										}, Factory.getInstance().getSysParameter("IpPageSize"));			
							}
						}	
					}				
				} else if (getWeeklyPrintToFile().isSelected()) {
					// print xls				
					// Weekly Bill Report
					if (getWeekBill().isSelected()) {				
						map.put("dateRange",dateRange);
						Report.print(Factory.getInstance().getUserInfo(), "RptWeekBill_xls",
								map,
								new String[] {startDate},
								new String[] {"PATNO","SLPNO","PATNAME",
							"PATFNAME","BEDCODE","TITDESC","REGDATE",
							"SLPTYPE","ARCODE","OUTAMT"});				
					}			
					
					// Cover Letter
					if (getCoverLetter().isSelected()) {
						map.put("printDate",dateRange);
					
						PrintingUtil.print("", "DAYENDCOVERLETTER", map, "",
								new String[] {
								startDate,
								getWeeklySlpNoCode().getText()
								},
								new String[] {
								"ALLSLPNO", "DSLP.PATNO", "PATNAME", 
								"PATFNAME", "BEDCODE", "PATTITLE", "AMT", "PRINTDATE",
								"FROMDATE","TODATE"
								},
								0, null, null, null, null, 1,
								false, true, new String[] { "docx" }, true);					
/*					
						Report.print(Factory.getInstance().getUserInfo(), "DAYENDCOVERLETTER",
								map,
								new String[] {
										startDate,
										getWeeklySlpNoCode().getText()
										},
								new String[] {"ALLSLPNO", "DSLP.PATNO", "PATNAME", 
								"PATFNAME", "BEDCODE", "PATTITLE", "AMT", "PRINTDATE",
								"FROMDATE","TODATE"});
*/								
					}
					
					// IP Statement WB
					if (getIPStatmentWB().isSelected()) {
						if (TWAH_VALUE.equals(getUserInfo().getSiteCode())) {
							String slpnoTWAH = getWeeklySlpNoCode().getText();							
							Report.print(getUserInfo(), "ChrgSmy", map,
									 new String[] {
										slpnoTWAH
									 },
									 new String[] {
											"PATNAME", "PATCNAME", "SLPNO", "PATNO",
											"REGDATE", "REGTIME", "BEDACM", "INPDDATE",
											"INPDTIME", "DOCNAME", "DOCCNAME"
									 },
									 new boolean[] {
											false, false, false, false, false, false,
											false, false, false, false, false
									 },
									 new String[] {
											"CHRGSMY_SUB"
									 } ,
									 new String[][] {
											{
													getAllSlip(slpnoTWAH), null
											}
									 },
									 new String[][] {
											{
													"DESCRIPTION" ,"QTY", "AMOUNT",
													"STNTYPE", "ITMTYPE", "DOCCODE",
													"DOCNAME", "DOCCNAME", "CDESCCODE"
											}
									 },
									 new boolean[][] {
											{
													false, true, false, false, false,
													false, false, false, false
											}
									 }, "", true, false, true, false, null, null, null, false);							
						}else{
							Map<String,String> mapWB = new HashMap<String,String>();				

							mapWB.put("SUBREPORT_DIR", CommonUtil.getReportDir());
							mapWB.put("DOCBKGCPY",Factory.getInstance().getSysParameter("DOCBKGCPY"));
							mapWB.put("watermark", CommonUtil.getReportImg("copy_watermark.gif"));
							mapWB.put("ALLSLPNO",getWeeklySlpNoCode().getText());	
							mapWB.put("ISCOPY", "Y");
							
							Factory.getInstance()
							.addRequiredReportDesc(mapWB,
									new String[] {
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage", 
									"MapLanguage", "MapLanguage", "MapLanguage"
									},
									new String[] {
											"StaOfAut", "AdmDtTime", "PatName",
											"DisDtTime", "TreDr", "BillNo",
											"PatNo", "BedNo", "Copy",
											"Page", "Date", "Item",
											"Amount", "TotChg", "TotRfd",
											"Balance", "Credits", "StatBalance",
											"BalanceFwd", "BedNum", "BedClass"
									},
									"HKAH".equals(getUserInfo().getSiteCode())?"CTE":"CHT");				
							
							Report.print(getUserInfo(), "IPStatementWB", mapWB,
									new String[] { getWeeklySlpNoCode().getText(), startDate },
									new String[] {
											"PATNAME", "PATCNAME" ,"SLPNO", "PATNO",
											"REGDATE", "REGTIME", "BEDACM", "INPDDATE",
											"INPDTIME", "DOCNAME", "DOCCNAME", "FROM_WBDATE", 
											"TO_WBDATE"
									},
									new boolean[] {
											false, false, false, false, false, false,
											false, false, false, false, false, false, false
									},
									new String[] {
											"IPStatementWB_Sub4",
											"IPStatementWB_Sub1",
											"IPStatementWB_Sub3"								
									} ,
									new String[][] {
											{
												getWeeklySlpNoCode().getText(), startDate
											},
											{
												getWeeklySlpNoCode().getText(), startDate
											},
											{
												getWeeklySlpNoCode().getText(), startDate
											}
									},
									new String[][] {

											{
													"STNTDATE", "AMOUNT", "DESCRIPTION", "QTY", "CDESCCODE"
											},
											{
													"STNTDATE", "AMOUNT", "DESCRIPTION", "QTY",
													"TOTALREFUND", "TOTALCHARGE", "CDESCCODE", "CDESCCODE2"
											},								
											{
													"STNTDATE", "AMOUNT", "DESCRIPTION", "QTY", "CDESCCODE"
											}
									},
									new boolean[][] {
											{
													false, true, false, true, false
											},					
											{
													false, true, false, true, true, true, false, false
											},
											{
													false, true, false, true, false
											}
									}, Factory.getInstance().getSysParameter("IpPageSize"));							
						}
					}
				} else {
					// print to printer
					// Weekly Bill Report
					if (getWeekBill().isSelected()) {
						map.put("dateRange",dateRange);
						Report.print(Factory.getInstance().getUserInfo(), "RptWeekBill_xls",
								map,
								new String[] {"rptNameWDate",startDate},
								new String[] {"PATNO","SLPNO","PATNAME",
										"PATFNAME","BEDCODE","TITDESC","REGDATE",
										"SLPTYPE","ARCODE","OUTAMT"},
										true,
										null,
										null,
										"RptWeekBill_xls"+startDate.replaceAll("/", ""),
										false);
					}
					
					// Cover Letter
					if (getCoverLetter().isSelected()) {
						map.put("printDate",dateRange);
/*						
						PrintingUtil.print("DEFAULTPRT","DAYENDCOVERLETTER",map,"",
								new String[] {
								startDate,
								getWeeklySlpNoCode().getText()
								},
								new String[] {"ALLSLPNO", "DSLP.PATNO", "PATNAME", 
								"PATFNAME", "BEDCODE", "PATTITLE", "AMT", "PRINTDATE",
								"FROMDATE","TODATE"});

*/					
						PrintingUtil.print("", "DAYENDCOVERLETTER", map, "",
								new String[] {
								startDate,
								getWeeklySlpNoCode().getText()
								},
								new String[] {
								"ALLSLPNO", "DSLP.PATNO", "PATNAME", 
								"PATFNAME", "BEDCODE", "PATTITLE", "AMT", "PRINTDATE",
								"FROMDATE","TODATE"
								},
								0, null, null, null, null, 1,
								false, true, new String[] { "docx" }, true);												
								
					}
					
					if (getIPStatmentWB().isSelected()) {
						if (TWAH_VALUE.equals(getUserInfo().getSiteCode())) {
							Map<String,String> mapWB = new HashMap<String,String>();
							Map<String,String> mapChrgSmy = new HashMap<String,String>();							
							String slpnoTWAH = getWeeklySlpNoCode().getText();
							String startDateTWAH = getWeeklyDateStart().getText().trim();							
							
							mapWB.put("SUBREPORT_DIR", CommonUtil.getReportDir());
							mapWB.put("DOCBKGCPY",Factory.getInstance().getSysParameter("DOCBKGCPY"));
							mapWB.put("watermark", CommonUtil.getReportImg("copy_watermark.gif"));
							mapWB.put("ISCOPY", "Y");								
							mapWB.put("ALLSLPNO",slpnoTWAH);
							
							mapChrgSmy.put("SUBREPORT_DIR", CommonUtil.getReportDir());
							mapChrgSmy.put("P_SLPNO", slpnoTWAH );
							mapChrgSmy.put("ALLSLPNO", slpnoTWAH );
							mapChrgSmy.put("ISCOPY", "");
							mapChrgSmy.put("NEWACM", null);
							mapChrgSmy.put("watermark", CommonUtil.getReportImg("copy_watermark.gif"));
							mapChrgSmy.put("DOCBKGCPY",Factory.getInstance().getSysParameter("DOCBKGCPY"));
							mapChrgSmy.put("printDate",dateRange);
/*											
							PrintingUtil.print("DEFAULTPRT","DAYENDCOVERLETTER_TWAH",mapTWAH,"",
									new String[] {
									startDateTWAH,
									slpnoTWAH
									},
									new String[] {"ALLSLPNO", "DSLP.PATNO", "PATNAME", 
									"PATFNAME", "BEDCODE", "PATTITLE", "AMT", "PRINTDATE",
									"FROMDATE","TODATE"},
									0, null, null, null, null, 1, false);
*/											
							Factory.getInstance()
							.addRequiredReportDesc(mapChrgSmy,
								new String[] {
										"MapLanguage", "MapLanguage", "MapLanguage",
										"MapLanguage", "MapLanguage", "MapLanguage",
										"MapLanguage", "MapLanguage", "MapLanguage",
										"MapLanguage", "MapLanguage", "MapLanguage",
										"MapLanguage", "MapLanguage", "MapLanguage",
										"MapLanguage", "MapLanguage", "MapLanguage",
										"MapLanguage", "MapLanguage", "MapLanguage"
								},
								new String[] {
										"TotChgTtl", "Copy", "BillNo", "BedNo", "DisDtTime",
										"PatName", "TreDr", "AdmDtTime", "PatNo", "Page",
										"SpecialFee", "DocCredit", "Credits", "HosCharge",
										"DocCharge", "HosCredit", "Charges", "Refund",
										"SpecialSrv", "Packages", "Balance"
								},
								"HKAH".equals(getUserInfo().getSiteCode())?"CTE":"CHT");
							
							
															
							PrintingUtil.print("DEFAULTPRT", "ChrgSmyCoverLetterSet",
									mapChrgSmy, null, new String[] { 
										startDateTWAH,
										slpnoTWAH 
									},
									new String[] {
											"PATNAME", "PATCNAME", "SLPNO", "PATNO",
											"REGDATE", "REGTIME", "BEDACM", "INPDDATE",
											"INPDTIME", "DOCNAME", "DOCCNAME",
											"BEDCODE", "ACMNAME", "ALLSLPNO", "PATFNAME",
											"PATTITLE", "AMT", "FROMDATE", "TODATE"
									}, 1,
									new String[] { 
													"CHRGSMYWB_SUB",
													"CHRGSMYWB_SUB1"
												},
									new String[][] {
											{ 
												getAllSlip(slpnoTWAH), null, startDateTWAH
											},
											{
												getWeeklySlpNoCode().getText(), startDateTWAH
											}
									},
									new String[][] {
											{
												"DESCRIPTION", "QTY", "AMOUNT", "STNTYPE", "ITMTYPE",
												"DOCCODE", "DOCNAME", "DOCCNAME", "CDESCCODE"
											},
											{
												"STNTDATE", "AMOUNT" ,"DESCRIPTION", "QTY","CDESCCODE"
											}											
									},
									new boolean[][] {
											{ 
												false, true, false, false, false, false, false, false, false 
											},
											{
												false, true, false, true, false
											}
									}, 1, false);
						}else{
							map.put("printDate",dateRange);
							Map<String,String> mapWB = new HashMap<String,String>();				
							mapWB.put("SUBREPORT_DIR", CommonUtil.getReportDir());
							mapWB.put("DOCBKGCPY",Factory.getInstance().getSysParameter("DOCBKGCPY"));
							mapWB.put("watermark", CommonUtil.getReportImg("copy_watermark.gif"));
							mapWB.put("ALLSLPNO",getWeeklySlpNoCode().getText());
							mapWB.put("ISCOPY", "Y");
							
							Factory.getInstance()
							.addRequiredReportDesc(mapWB,
									new String[] {
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage", 
									"MapLanguage", "MapLanguage", "MapLanguage"
									},
									new String[] {
											"StaOfAut", "AdmDtTime", "PatName",
											"DisDtTime", "TreDr", "BillNo",
											"PatNo", "BedNo", "Copy",
											"Page", "Date", "Item",
											"Amount", "TotChg", "TotRfd",
											"Balance", "Credits", "StatBalance",
											"BalanceFwd", "BedNum", "BedClass"
									},
									"HKAH".equals(getUserInfo().getSiteCode())?"CTE":"CHT");						
							if (isPostToApp) {
								final Map<String,String> mapW =  mapWB;
								final String sDate = startDate;
								QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
										new String[] {"APPBILLS", "COUNT(1)", "SLPNO='" + getWeeklySlpNoCode().getText()
									+ "' AND BILLSTS='N' "},
										new MessageQueueCallBack() {
									@Override
									public void onPostSuccess(MessageQueue mQueue) {
										if (mQueue.success()) {
											int value = 0;
											try {
												value = Integer.parseInt(mQueue.getContentField()[0]);
												if (value > 0) {
													MessageBoxBase.confirm("Mobile Bill", ConstantsMessage.MSG_BILL_ISCREATEBILL,
															new Listener<MessageBoxEvent>() {
														public void handleEvent(MessageBoxEvent be) {
															if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
																genWeekBillHKAH(mapW,sDate);
																isPostToApp = false;
															} 
														}
													});
												} else {
													genWeekBillHKAH(mapW,sDate);
													isPostToApp = false;
												}
											} catch (Exception e) {
											}
										}
									}
								});
							} else {
										PrintingUtil.print("DEFAULTPRT", "IPStatementWB", mapWB, null,
												new String[] {
															getWeeklySlpNoCode().getText(), startDate
															
												},
												new String[] {
														"PATNAME", "PATCNAME", "SLPNO", "PATNO",
														"REGDATE", "REGTIME", "BEDACM", "INPDDATE",
														"INPDTIME", "DOCNAME", "DOCCNAME", "FROM_WBDATE", 
														"TO_WBDATE"
												}, 3,
												new String[] {
														"IPStatementWB_Sub4", 
														"IPStatementWB_Sub1",
														"IPStatementWB_Sub3"								
												},
												new String[][] {
														{
															getWeeklySlpNoCode().getText(), startDate
														},
														{
															getWeeklySlpNoCode().getText(), startDate
														},
														{
															getWeeklySlpNoCode().getText(), startDate
														}
												},
												new String[][] {
														{
																"STNTDATE", "AMOUNT" ,"DESCRIPTION", "QTY","CDESCCODE"
														},
														{
																"STNTDATE", "AMOUNT" ,"DESCRIPTION", "QTY",
																"TOTALREFUND", "TOTALCHARGE", "CDESCCODE", "CDESCCODE2"
														},								
														{
																"STNTDATE", "AMOUNT" ,"DESCRIPTION", "QTY","CDESCCODE"
														}
												},
												new boolean[][] {
														{
																false, true, false, true, false
														},						
														{
																false, true, false, true, true, true, false, false
														},
														{
																false, true, false, true, false
														}
												}, 1, Factory.getInstance().getSysParameter("IpPageSize"));	
									}
						}							
					}
				}
			}						
		}			
	}
		
	@Override
	protected void canProceedReady(boolean isProceedReady) {
		if (isProceedReady) {
				Window.open(Factory.getInstance().getSysParameter("DERptPath")
						+getListTable().getSelectedRowContent()[0],null,null);
				
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
	
	public BasePanel getLinePanel() {
		if (linePanel == null) {
			linePanel = new BasePanel();
			linePanel.setBounds(10, 130, 750, 10);
			linePanel.add(getLine(), null);
		}
		return linePanel;
	}	
	
	public TabbedPaneBase getTabbedPane() {
		if (TabbedPanel == null) {
			TabbedPanel = new TabbedPaneBase() {
				public void onStateChange() {
					enableButton();
					if (getSelectedIndex() == 0) {
						searchAction();
					}
				}
			};
			TabbedPanel.setBounds(5, 5, 800, 500);
			TabbedPanel.addTab("Cover Letter", getHistoryPanel());
			TabbedPanel.addTab("Weekly Bill List", getWeeklyPanel());
		}
		return TabbedPanel;
	}	
	
	private BasePanel getHistoryPanel() {
		if (HistoryPanel == null) {
			HistoryPanel = new BasePanel();
			HistoryPanel.setSize(779, 492);
			HistoryPanel.add(getReportDateDesc(), null);
			HistoryPanel.add(getReportDate(), null);
			//HistoryPanel.add(getHistoryPrinttoScreenDesc(), null);
			//HistoryPanel.add(getHistoryPrinttoScreen(), null);
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
	
	public HTML getLine() {
		if (Line == null) {
			Line = new HTML("<hr COLOR=\"red\" />");
		}
		return Line;
	}	
	
	public BasePanel getWeeklyPanel() {
		if (WeeklyPanel == null) {
			WeeklyPanel = new BasePanel();
			WeeklyPanel.setSize(779, 492);
			WeeklyPanel.add(getWeeklyPrinttoScreenDesc(), null);
			WeeklyPanel.add(getWeeklyPrinttoScreen(), null);
//			WeeklyPanel.add(getWeeklyPrintToFileDesc(), null);
//			WeeklyPanel.add(getWeeklyPrintToFile(), null);			
			WeeklyPanel.add(getWeeklyDateStartDesc(), null);
			WeeklyPanel.add(getWeeklyDateStart(), null);
//			WeeklyPanel.add(getWeeklySiteCodeDesc(), null);
			//WeeklyPanel.add(getWeeklySiteCode(), null);			
			WeeklyPanel.add(getWeeklySlpNoCodeDesc(), null);
			WeeklyPanel.add(getWeeklySlpNoCode(), null);
			WeeklyPanel.add(getPatientCodeDesc(), null);
			WeeklyPanel.add(getPatientCode(), null);
			WeeklyPanel.add(getWeekBillDesc(), null);
			WeeklyPanel.add(getWeekBill(), null);
			WeeklyPanel.add(getLinePanel(), null);
			WeeklyPanel.add(getCoverLetterDesc(), null);
			WeeklyPanel.add(getCoverLetter(), null);
			WeeklyPanel.add(getIPStatmentWBDesc(), null);
			WeeklyPanel.add(getIPStatmentWB(), null);
			WeeklyPanel.add(getSaveButton(), null);
			WeeklyPanel.add(getShowHistoryButton(), null);
			WeeklyPanel.add(getPostToAppButton(), null);
//			WeeklyPanel.add(getRollbackBillType(), null);
			WeeklyPanel.add(getIsTWAHDesc(), null);
			WeeklyPanel.add(getIsTWAH(), null);
		}
		return WeeklyPanel;
	}
	
	public LabelBase getWeekBillDesc() {
		if (WBillDesc == null) {
			WBillDesc = new LabelBase();
			WBillDesc.setText("Weekly Bill List");
			WBillDesc.setBounds(559,10, 100, 20);
		}
		return WBillDesc;
	}

	public CheckBoxBase getWeekBill() {
		if (WBill == null) {
			WBill = new CheckBoxBase(){
				@Override
				public void onClick() {
					if (WBill.isSelected()) {
						getIsTWAH().setSelected(false);
					}
			}
		};
			WBill.setBounds(537, 10, 23, 20);
		}
		return WBill;
	}
	
	public LabelBase getIsTWAHDesc() {
		if (IsTWAHDesc == null) {
			IsTWAHDesc = new LabelBase();
			IsTWAHDesc.setText("HKAH - TW");
			IsTWAHDesc.setBounds(692,10, 100, 20);
			IsTWAHDesc.setVisible(false);
		}
		return IsTWAHDesc;
	}

	public CheckBoxBase getIsTWAH() {
		if (IsTWAH == null) {
			IsTWAH = new CheckBoxBase(){
				@Override
				public void onClick() {
					if (IsTWAH.isSelected()) {
						getWeekBill().setSelected(false);
						getCoverLetter().setSelected(false);
						getIPStatmentWB().setSelected(false);
					}
			}
		};
		IsTWAH.setBounds(664, 10, 23, 20);
		IsTWAH.setVisible(false);			
		}
		return IsTWAH;
	}		
	
	public LabelBase getCoverLetterDesc() {
		if (CovLetterDesc == null) {
			CovLetterDesc = new LabelBase();
			CovLetterDesc.setText("Cover Letter");
			CovLetterDesc.setBounds(559, 45, 197, 20);
		}
		return CovLetterDesc;
	}

	public CheckBoxBase getCoverLetter() {
		if (CovLetter == null) {
			CovLetter = new CheckBoxBase(){
				@Override
				public void onClick() {
					if (CovLetter.isSelected()) {
						getIsTWAH().setSelected(false);
					}
			}
		};
			CovLetter.setBounds(537, 45, 23, 20);
		}
		return CovLetter;
	}
	
	public LabelBase getIPStatmentWBDesc() {
		if (IPStatmentWBDesc == null) {
			IPStatmentWBDesc = new LabelBase();
			IPStatmentWBDesc.setText("Interim Statement");
			IPStatmentWBDesc.setBounds(559, 80, 197, 15);
		}
		return IPStatmentWBDesc;
	}
	
	public CheckBoxBase getIPStatmentWB() {
		if (IPStatmentWB == null) {
			IPStatmentWB = new CheckBoxBase(){
				@Override
				public void onClick() {
					if (IPStatmentWB.isSelected()) {
						getIsTWAH().setSelected(false);
					}
			}
		};
		IPStatmentWB.setBounds(537,80, 23, 5);			
		}
		return IPStatmentWB;
	}

	public LabelBase getWeeklyDateStartDesc() {
		if (WeeklyDateStartDesc == null) {
			WeeklyDateStartDesc = new LabelBase();
			WeeklyDateStartDesc.setText("<html>Date range start<br>(dd/mm/yyyy)</html>");
			WeeklyDateStartDesc.setBounds(10, 10, 103, 30);
		}
		return WeeklyDateStartDesc;
	}

	public TextDate getWeeklyDateStart() {
		if (WeeklyDateStart == null) {
			WeeklyDateStart = new TextDate() {
				@Override
				public void onBlur() {
					if (!isEmpty() && !isValid()) {
						Factory.getInstance().addErrorMessage("Invalid date.", DateRangeStart);
						resetText();
						return;
					}
				};
			};
			WeeklyDateStart.setBounds(112, 10, 125, 20);
		}
		return WeeklyDateStart;
	}	
	
	public LabelBase getWeeklyPrinttoScreenDesc() {
		if (WeeklyPrinttoScreenDesc == null) {
			WeeklyPrinttoScreenDesc = new LabelBase();
			WeeklyPrinttoScreenDesc.setText("Print To Screen");
			WeeklyPrinttoScreenDesc.setBounds(410, 10, 100, 20);
		}
		return WeeklyPrinttoScreenDesc;
	}

	public CheckBoxBase getWeeklyPrinttoScreen() {
		if (WeeklyPrinttoScreen == null) {
			WeeklyPrinttoScreen = new CheckBoxBase(){
				@Override
				public void onClick() {
					if (getWeeklyPrinttoScreen().isSelected()) {
						getWeeklyPrintToFile().setSelected(false);
					}
			}
		};
			WeeklyPrinttoScreen.setBounds(380, 10, 23, 20);
		 }
		return WeeklyPrinttoScreen;
	}	
	
	public LabelBase getWeeklyPrintToFileDesc() {
		if (WeeklyPrintToFileDesc == null) {
			WeeklyPrintToFileDesc = new LabelBase();
			WeeklyPrintToFileDesc.setText("Print To File");
			WeeklyPrintToFileDesc.setBounds(410, 45, 100, 20);
		}
		return WeeklyPrintToFileDesc;
	}	
	
	public CheckBoxBase getWeeklyPrintToFile() {
		if (WeeklyPrintToFile == null) {
			WeeklyPrintToFile = new CheckBoxBase(){
				@Override
				public void onClick() {
					if (getWeeklyPrintToFile().isSelected()) {
						getWeeklyPrinttoScreen().setSelected(false);
					}
				}
			};
			WeeklyPrintToFile.setBounds(380, 45, 23, 20);
		}
		return WeeklyPrintToFile;
	}	
	
	public LabelBase getWeeklySiteCodeDesc() {
		if (WeeklySiteCodeDesc == null) {
			WeeklySiteCodeDesc = new LabelBase();
			WeeklySiteCodeDesc.setText("Site Code");
			WeeklySiteCodeDesc.setBounds(10, 80, 80, 20);
		}
		return WeeklySiteCodeDesc;
	}

	public ComboSiteType getWeeklySiteCode() {
		if (WeeklySiteCode == null) {
			WeeklySiteCode = new ComboSiteType();
			WeeklySiteCode.setBounds(112, 80, 150, 20);
		}
		return WeeklySiteCode;
	}	
		
	public LabelBase getWeeklySlpNoCodeDesc() {
		if (WeeklySlpNoDesc == null) {
			WeeklySlpNoDesc = new LabelBase();
			WeeklySlpNoDesc.setText("Slip NO.");
			WeeklySlpNoDesc.setBounds(10, 45, 103, 20);
		}
		return WeeklySlpNoDesc;
	}	
	
	public TextString getWeeklySlpNoCode() {
		if (WeeklySlpNO == null) {
			WeeklySlpNO = new TextString();
			WeeklySlpNO.setBounds(112, 45, 125, 20);
		}
		return WeeklySlpNO;
	}
	
	public LabelBase getPatientCodeDesc() {
		if (PatientCodeDesc == null) {
			PatientCodeDesc = new LabelBase();
			PatientCodeDesc.setText("Patient No.");
			PatientCodeDesc.setBounds(10, 155, 80, 20);
		}
		return PatientCodeDesc;
	}

	public TextString getPatientCode() {
		if (PatientCode == null) {
			PatientCode = new TextString();
			PatientCode.setBounds(112, 155, 150, 20);
		}
		return PatientCode;
	}	
	
	public ComboRollbackBillType getRollbackBillType(){
		if(rollbackBillType == null){
			rollbackBillType = new ComboRollbackBillType();
			rollbackBillType.setBounds(537, 200, 200, 20);
		}
		return rollbackBillType;
	}	
	
	private boolean validatePrintAction() {
/*		
		if (!getWeeklySiteCode().isEmpty() && !getWeeklySiteCode().isValid()) {
			Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_ERR_INVALIDDATE+"Start Date.", getWeeklySiteCode());
			return false;
		}
*/
		boolean error = false;
		StringBuffer sb = new StringBuffer();
		
		// Weekly Bill
		if (getWeekBill().isSelected()) {
			if (error) {
				sb.append("<br/>");
			}
/*
			if (getWeeklySiteCode().getText().trim().length() == 0 ||
					!getWeeklySiteCode().isValid() ||
					getWeeklySiteCode().isEmpty()) {
				error = true;
				sb.append("Fail to print: Weekly Bill Report (RptWeekBill_xls)<br/><br/>");
			}

			if (getWeeklySiteCode().getText().trim().length() == 0 || !getWeeklySiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
*/
			if (getWeeklyDateStart().isEmpty() || !getWeeklyDateStart().isValid()) {
				error = true;				
				sb.append("Please supply Start Date.<br/>");
			}
		}
		
		// Cover Letter
		if (getCoverLetter().isSelected()) {
			if (error) {
				sb.append("<br/>");
			}
/*
			if (getWeeklySiteCode().getText().trim().length() == 0 ||
					!getWeeklySiteCode().isValid() ||
					getWeeklySiteCode().isEmpty()) {
				error = true;
				sb.append("Fail to print: Cover Letter <br/><br/>");
			}

			if (getWeeklySiteCode().getText().trim().length() == 0 || !getWeeklySiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
*/			

			if (getWeeklyDateStart().isEmpty() || !getWeeklyDateStart().isValid()) {
				error = true;
				sb.append("Please supply Start Date.<br/>");
			}

			if (getWeeklySlpNoCode().isEmpty() || !getWeeklySlpNoCode().isValid()) {
				error = true;				
				sb.append("Please enter slip NO..<br/>");
			}			
		}
		
		// Inpatient Statement
		if (getIPStatmentWB().isSelected()) {
			if (error) {
				sb.append("<br/>");
			}
/*
			if (getWeeklySiteCode().getText().trim().length() == 0 ||
					!getWeeklySiteCode().isValid() ||
					getWeeklySiteCode().isEmpty()) {
				error = true;
				sb.append("Fail to print: Inpatient Statement <br/><br/>");
			}

			if (getWeeklySiteCode().getText().trim().length() == 0 || !getWeeklySiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
*/		
			if (getWeeklySlpNoCode().isEmpty()) {
				error = true;				
				sb.append("Please slip NO.<br/>");
			}
			
			if (getWeeklyDateStart().isEmpty() || !getWeeklyDateStart().isValid()) {
				error = true;				
				sb.append("Please supply Start Date.<br/>");
			}			
		}		

		if (error) {
			Factory.getInstance().addErrorMessage(sb.toString());
			return false;
		}

		return true;
	}	

	private void showReportList(String dayOfWeek, final boolean isHistory) {
		getMainFrame().setLoading(true);
		((DayendReportListServiceAsync) Registry
				.get(AbstractEntryPoint.DAYEND_REPORT_LIST_SERVICE))
				.getReportList(Factory.getInstance().getSysParameter("DERptPath"), "", true, 
								Factory.getInstance().getSysParameter("FILTERCL")+dayOfWeek,
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

	protected String getAllSlip(String slipNo) {
		StringBuffer allSlip = new StringBuffer();
		allSlip.append(SINGLE_QUOTE_VALUE);
		allSlip.append(slipNo);
		allSlip.append(SINGLE_QUOTE_VALUE);
		return allSlip.toString();
	}		
	
	public ButtonBase getSaveButton() {
		if (saveButton == null) {
			saveButton = new ButtonBase("Gen High Bill"){
				@Override
				public void onClick() {
//					cal.add(Calendar.DATE, 1);								
					final String printDate = getMainFrame().getServerDate(); 
					
					if (!getPatientCode().isEmpty() && !printDate.isEmpty()) {
						QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
								new String[] {"DAYENDSLIPS", "count(1)", "patno = '"+ getPatientCode().getText() +"' and TO_CHAR(PRINTDATE,'DD/MM/YYYY') ='" + printDate + "' and ENABLED = 1"},
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {	
									if("0".equals(mQueue.getContentField()[0])){
										MessageBoxBase.confirm(MSG_PBA_SYSTEM, "Confirm generate high bill for Pat NO.: "+getPatientCode().getText()+" ?",new Listener<MessageBoxEvent>() {
											@Override
											public void handleEvent(MessageBoxEvent be) {
												if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
													getMainFrame().setLoading(true);									
													QueryUtil.executeMasterAction(getUserInfo(), "GENALLPATLETTER_WPAT", "MOD",
															new String[] {					
																printDate,
																getPatientCode().getText(),
																null,
																Factory.getInstance().getUserInfo().getUserID()
															},
														new MessageQueueCallBack() {
														@Override
														public void onPostSuccess(MessageQueue mQueue) {
															if (mQueue.success()) {																
																getMainFrame().setLoading(false);												
																Factory.getInstance().addInformationMessage(
																		"Save success.",
																		new Listener<MessageBoxEvent>() {
																			@Override
																			public void handleEvent(
																					MessageBoxEvent be) {
																			}
																		});
															} else {																
																getMainFrame().setLoading(false);
															}
														}
													});												
												}
											}
										});
									}else if("-999".equals(mQueue.getContentField()[0])){
										Factory.getInstance().addErrorMessage("No high bill generate for Patient NO.:"+getPatientCode().getText()+" on " + printDate);										
									}else{
										Factory.getInstance().addErrorMessage("Patient NO.:"+getPatientCode().getText()+" already generated on " + printDate);										
									}
								}
							}
						});	
					} else {
						Factory.getInstance().addErrorMessage("Please enter Patient NO");
					}
				}	
			};
			saveButton.setEnabled(false);
			saveButton.setBounds(537, 155, 210, 30);
		}
		return saveButton;
	}
		
	private ButtonBase getShowHistoryButton() {
		if (showHistoryButton == null) {
			showHistoryButton = new ButtonBase("Show History"){
				@Override
				public void onClick() {
					if(getWeeklySlpNoCode().getText() != null && getWeeklySlpNoCode().getText().length() > 0 || 
							(getPatientCode().getText() != null && getPatientCode().getText().length() > 0)){
						getWeeklyBillHistoryDialog().showDialog(getWeeklySlpNoCode().getText(),getPatientCode().getText());	
					}else{
						Factory.getInstance().addErrorMessage("Please enter patient NO. or slip NO.", "PBA-[Weekly Bill History]", getPatientCode());
					}
				};				
			};
			showHistoryButton.setEnabled(false);			
			showHistoryButton.setBounds(10, 200, 90, 25);
		}
		return showHistoryButton;
	}	
	
	
	private DlgWeeklyBillHistory getWeeklyBillHistoryDialog() {
		if (weeklyBillHistoryDialog == null) {
			weeklyBillHistoryDialog = new DlgWeeklyBillHistory(getMainFrame()){
			};
		}
		return weeklyBillHistoryDialog;
	}	
	
	private ButtonBase getPostToAppButton() {
		if ( postToAppButton == null) {
			postToAppButton = new ButtonBase("Post To App"){
				@Override
				public void onClick() {
					isPostToApp = true;
					if (!getIsTWAH().isSelected()) {
						getIPStatmentWB().setSelected(true);
					}
					printAction();
				};				
			};
			postToAppButton.setEnabled(false);			
			postToAppButton.setBounds(10, 90, 90, 25);
		}
		return postToAppButton;
	}
	
	private void genWeekBillHKAH(final Map<String,String> mapWB, final String startDate) {
		QueryUtil.executeMasterAction(getUserInfo(), "APPBILL_SLIP", QueryUtil.ACTION_APPEND,
				new String[] {getWeeklySlpNoCode().getText(),"INTERIMBILL", "Slip "+getWeeklySlpNoCode().getText(),
			"N",  getUserInfo().getUserID()},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					final String billID = mQueue.getReturnCode();
					mapWB.put("watermark", CommonUtil.getReportImg("app_watermark.gif"));
					Report.print(getUserInfo(), "IPStatementWBAPP", mapWB,
							new String[] { getWeeklySlpNoCode().getText(), startDate },
							new String[] {
									"PATNAME", "PATCNAME" ,"SLPNO", "PATNO",
									"REGDATE", "REGTIME", "BEDACM", "INPDDATE",
									"INPDTIME", "DOCNAME", "DOCCNAME", "FROM_WBDATE", 
									"TO_WBDATE"
							},
							new boolean[] {
									false, false, false, false, false, false,
									false, false, false, false, false, false, false
							},
							new String[] {
									"IPStatementWB_Sub4",
									"IPStatementWB_Sub1",
									"IPStatementWB_Sub3"								
							} ,
							new String[][] {
									{
										getWeeklySlpNoCode().getText(), startDate
									},
									{
										getWeeklySlpNoCode().getText(), startDate
									},
									{
										getWeeklySlpNoCode().getText(), startDate
									}
							},
							new String[][] {
									{
											"STNTDATE", "AMOUNT", "DESCRIPTION", "QTY", "CDESCCODE"
											
									},
									{
											"STNTDATE", "AMOUNT", "DESCRIPTION", "QTY",
											"TOTALREFUND", "TOTALCHARGE", "CDESCCODE", "CDESCCODE2"
									},
									{
											"STNTDATE", "AMOUNT", "DESCRIPTION", "QTY", "CDESCCODE"
									},
							},
							new boolean[][] {
									{
											false, true, false, true, false
									},
									{
											false, true, false, true, true, true, false, false
									},
									{
											false, true, false, true, false
									}
							},  "", true, false, false, false, new CallbackListener() {
						@Override
						public void handleRetBool(boolean ret, String result, MessageQueue mQueue) {
							if(ret){
								DlgBrowserPanel browserPanel = new DlgBrowserPanel(getMainFrame());
								//browserPanel.showDialog("http://localhost:8080/intranet/mobile/genPatientStmtV2.jsp?slpNo="
								browserPanel.showDialog(Factory.getInstance().getSysParameter("ABillPathW")+"?slpNo="
										+getWeeklySlpNoCode().getText()
										+"&baseURL="+GWT.getModuleBaseURL()+"&rptPath="+result
										+"&slpType=O&billID="+billID+"&lang="+(HKAH_VALUE.equals(getUserInfo().getSiteCode())?"CTE":"CHT"));
								browserPanel.dispose();
							}
						}
					}, null, "APPBILL", false);	
				}}});
		Factory.getInstance().addInformationMessage("Post Succeed.");

	}
	
	private void genWeekBillTWAH(final String slpnoTWAH, final Map<String,String> mapChrgSmy, final String startDateTWAH){
		final String slip = slpnoTWAH;
		QueryUtil.executeMasterAction(getUserInfo(), "APPBILL_SLIP", QueryUtil.ACTION_APPEND,
				new String[] {slip,"INTERIMBILL", "Slip "+slip,"Y",  getUserInfo().getUserID()},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					Factory.getInstance().addInformationMessage("Post Succeed.");
					final String billID = mQueue.getReturnCode();
					final String slp = slip;
					Report.print(getUserInfo(),
							"ChrgSmyCoverLetterSet", mapChrgSmy,
							 new String[] { 
									startDateTWAH,
									slip 
								},
								new String[] {
										"PATNAME", "PATCNAME", "SLPNO", "PATNO",
										"REGDATE", "REGTIME", "BEDACM", "INPDDATE",
										"INPDTIME", "DOCNAME", "DOCCNAME",
										"BEDCODE", "ACMNAME", "ALLSLPNO", "PATFNAME",
										"PATTITLE", "AMT", "FROMDATE", "TODATE"
								},
							new boolean[] {
									false, false, false, false,
									false, false, false, false,
									false, false, false,
									false, false, false, false,
									false, false, false, false
							},
							new String[] {"CHRGSMY_SUB","CHRGSMYWB_SUB1"},
							new String[][] {
									{ getAllSlip(slip), null },
									{
										slip, startDateTWAH
									}
							},
							new String[][] {
									{
											"DESCRIPTION", "QTY", "AMOUNT", "STNTYPE", "ITMTYPE",
											"DOCCODE", "DOCNAME", "DOCCNAME", "CDESCCODE"
									},
									{
										"STNTDATE", "AMOUNT" ,"DESCRIPTION", "QTY","CDESCCODE"
									}
							},
							new boolean[][] {
						{ 
							false, true, false, false, false, false, false, false, false 
						},
						{
							false, true, false, true, false
						}
							}, "", true, false, false, false, new CallbackListener() {
								@Override
								public void handleRetBool(boolean ret, String result, MessageQueue mQueue) {
									if(ret){
										DlgBrowserPanel browserPanel = new DlgBrowserPanel(getMainFrame());
										//browserPanel.showDialog("http://localhost:8080/intranet/mobile/genPatientStmtV2.jsp?slpNo="
										browserPanel.showDialog(Factory.getInstance().getSysParameter("ABillPathW")+"?slpNo="
												+slpnoTWAH
												+"&baseURL="+GWT.getModuleBaseURL()+"&rptPath="+result
												+"&from=txnDetail&slpType=O&billID="+billID+"&lang="+(HKAH_VALUE.equals(getUserInfo().getSiteCode())?"CTE":"CHT"));
										browserPanel.dispose();
									}
								}
							}, null, "APPBILL", false);
				}}});
			
	}
}
