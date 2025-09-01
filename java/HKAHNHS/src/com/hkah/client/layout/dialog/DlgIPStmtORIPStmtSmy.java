package com.hkah.client.layout.dialog;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.FieldEvent;
import com.extjs.gxt.ui.client.event.KeyListener;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.LayoutContainer;
import com.extjs.gxt.ui.client.widget.form.RadioGroup;
import com.google.gwt.core.client.GWT;
import com.google.gwt.event.dom.client.KeyCodes;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.event.CallbackListener;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboACMCode;
import com.hkah.client.layout.combobox.ComboDeptServ;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.radiobutton.RadioButtonBase;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextSlipMergeSearch;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.util.AppStmtUtil;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.Report;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgIPStmtORIPStmtSmy extends DialogSlipBase {
	private final static int m_frameWidth = 730;
	private final static int m_frameHeight = 600;

	private BasePanel IPOfficePanel = null;
	private FieldSetBase whichReportPanel = null;
	private CheckBoxBase ipStmt = null;
	private LabelBase ipStmtDesc = null;
	private CheckBoxBase ipStmtSum = null;
	private LabelBase ipStmtSumDesc = null;
	private CheckBoxBase ipDscStmt = null;
	private LabelBase ipDscStmtDesc = null;
	private ComboDeptServ dptServiceCode = null;
	private FieldSetBase slipPanel = null;
	private FieldSetBase seqPanel = null;
	private LabelBase seqDesc = null;
	private TextString seq = null;
	private TableList seqList = null;
	private JScrollPane seqScrollPane = null;
	private FieldSetBase copyPanel = null;
	private RadioButtonBase yesOpt = null;
	private RadioButtonBase noOpt = null;
	private FieldSetBase signPanel = null;
	private RadioButtonBase signYesOpt = null;
	private RadioButtonBase signNoOpt = null;
	private LabelBase chgAcmDesc = null;
	private ComboACMCode chgAcm = null;
	private CheckBoxBase printNewAcm = null;

	private boolean memIsPreview = false;
	private ArrayList<String> checkList = new ArrayList<String>();
	private ArrayList<String> finishList = new ArrayList<String>();
	private String sPrnRange = "";
	private String memAcm = null;
	private LabelBase noticeDesc = null;
	private String mothLang = null;

	private ButtonBase createAppBills = null;
	private boolean isCreateAppBill = false;
	private DlgAppBillType dlgAppBillType = null;


	
	public DlgIPStmtORIPStmtSmy(MainFrame owner) {
		super(owner, YESNOCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Print which report?");

		// change label
		getButtonById(YES).setText("Preview");
		getButtonById(NO).setText("Print", 'P');
		
		getButtonBar().add(getCreateABills());

		setContentPane(getIPOfficePanel());

		RadioGroup btngrp = new RadioGroup();
		btngrp.add(getYesOpt());
		btngrp.add(getNoOpt());

		RadioGroup signStngrp = new RadioGroup();
		signStngrp.add(getSignYesOpt());
		signStngrp.add(getSignNoOpt());

		getChgAcm().setEnabled(!Factory.getInstance().isDisableFunction("getChgAcm", "mntIPStmtORIPStmtSmy"));

		// layout
		getSlpNoDesc().setBounds(10, 0, 120, 20);
		getSlpNo().setBounds(150, 0, 130, 20);
		getSaveMergeSlip().setBounds(300, 0, 130, 20);
		getMergeWithDesc().setBounds(30, 25, 130, 20);
		getMergeWith1().setBounds(150, 25, 130, 20);
		getMergeWith2().setBounds(150, 50, 130, 20);
		getMergeWith3().setBounds(150, 75, 130, 20);
		getMergeWith4().setBounds(150, 100, 130, 20);
		getMergeWith5().setBounds(150, 125, 130, 20);
		getMergeWith6().setBounds(300, 25, 130, 20);
		getMergeWith7().setBounds(300, 50, 130, 20);
		getMergeWith8().setBounds(300, 75, 130, 20);
		getMergeWith9().setBounds(300, 100, 130, 20);
		getMergeWith10().setBounds(300, 125, 130, 20);

		if (HKAH_VALUE.equals(getUserInfo().getSiteCode())) {
			getCopyPanel().setBounds(10, 420, 330, 80);
			getYesOpt().setBounds(40, 0, 180, 20);
			getNoOpt().setBounds(40, 25, 180, 20);;
			getSignPanel().setVisible(true);
			getSignPanel().setBounds(350, 420, 330, 80);
			getSignYesOpt().setBounds(40, 0, 180, 20);
			getSignNoOpt().setBounds(40, 25, 180, 20);
		}
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String patNo, String slpNo, String slpType, String rptLang, String acm, boolean arSign,String mothLang) {
		setMemSlipNo(slpNo);
//		setSlipType(slpType);
		memAcm = acm;
		this.mothLang = mothLang;
		clearSlipField();
		getButtonById(YES).setEnabled(false);
		getButtonById(NO).setEnabled(false);
		getIpStmt().setSelected(false);
		getIpStmtSum().setSelected(false);
		getIpDscStmt().setSelected(false);
		getDptServiceCode().clear();
		getPrintNewAcm().setSelected(false);
		getChgAcm().resetText();
		getSeqList().getSelectionModel().deselectAll();
		getSeq().resetText();

		setParameter("PatNo", patNo);
		setLanguage(rptLang);

		getNoOpt().setSelected(true);

		loadOldSlipNo();

		if (Factory.getInstance().getSysParameter("SHOWSIGN").equals("Y")) {
			//specified AR
			if (arSign) {
				getSignYesOpt().setSelected(true);
			} else {
				getSignNoOpt().setSelected(true);
			}
		}

		QueryUtil.executeMasterBrowse(
				getUserInfo(), "IPRPTHIS", new String[] {getMemSlipNo(),""},
				new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							getSeqList().setListTableContent(mQueue);
						}
						getDefaultFocusComponent().focus();
					}
				});

		setVisible(true);
	}

	@Override
	public Component getDefaultFocusComponent() {
		return getIpStmt();
	}

	@Override
	protected void doYesAction() {
		memIsPreview = true;
		validation();
	}

	@Override
	protected void doNoAction() {
		memIsPreview = false;
		validation();
	}
	
	protected ButtonBase getCreateABills() {
		if (createAppBills == null) {
			createAppBills = new ButtonBase() {
				@Override
				public void onClick() {
					getDlgAppBillType().showDialog("IPSTATEMENT",getParameter("PatNo"));
				}
			};
			createAppBills.setText("Post to App");
		}
		return createAppBills;
	}
	
	private DlgAppBillType getDlgAppBillType(){
		if (dlgAppBillType  == null) {
			dlgAppBillType = new DlgAppBillType(getMainFrame()) {
				@Override
				public  void doPostToApp() {
					final Map<String,String> map = new HashMap<String,String>();
					map.put("SUBREPORT_DIR", CommonUtil.getReportDir());
					map.put("P_SLPNO", getSlpNo().getText() );
					map.put("ALLSLPNO", getAllSlip(true) );
					map.put("ISCOPY", "Y");
					map.put("remark", dlgAppBillType.getRemark().getText());
				
					Factory.getInstance()
						.addRequiredReportDesc(map,
								   new String[] {
											"MapLanguage", "MapLanguage", "MapLanguage",
											"MapLanguage", "MapLanguage", "MapLanguage",
											"MapLanguage", "MapLanguage", "MapLanguage",
											"MapLanguage", "MapLanguage", "MapLanguage",
											"MapLanguage", "MapLanguage", "MapLanguage",
											"MapLanguage", "MapLanguage", "MapLanguage",
											"MapLanguage", "MapLanguage"
									},
								   new String[] {
											"StaOfAut", "AdmDtTime", "PatName", "DisDtTime",
											"TreDr", "BillNo", "PatNo", "BedNo", "Copy",
											"Page", "Date", "Item", "Amount", "TotChg",
											"TotRfd", "Balance", "patM", "patB", "BirthDt",
											"DelDr"
									},
									getLanguage());

					String printSeq = getSeq().getValue() != null ?
										getSeq().getValue().trim() :
									null;
					if (printSeq != null && printSeq.length() > 0) {
						map.put("PRNRANGENOTE", "Note: Printing Sequence number "+printSeq);
					}
					map.put("watermark", CommonUtil.getReportImg("app_watermark.gif"));
					map.put("DOCBKGCPY",Factory.getInstance().getSysParameter("DOCBKGCPY"));
					
					QueryUtil.executeMasterFetch(getUserInfo(), "ABILLANDTX_EXIST",
							new String[] {getSlpNo().getText() },
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								int value = 0;
								int txValue = 0;
								try {
									value = Integer.parseInt(mQueue.getContentField()[0]);
									txValue = Integer.parseInt(mQueue.getContentField()[1]);
									if (value > 0 && !isCreateAppBill) {
										if(txValue > 0) {
											Factory.getInstance()
											.addErrorMessage(ConstantsMessage.MSG_BILL_UNSETTLEDBILL);
										} else {	
											MessageBoxBase.confirm("Mobile Bill", ConstantsMessage.MSG_BILL_ISCREATEBILL,
													new Listener<MessageBoxEvent>() {
												public void handleEvent(MessageBoxEvent be) {
													if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
														AppStmtUtil.createAppBill(true, dlgAppBillType.getRemark().getText(), dlgAppBillType.getAppBillType().getText(),
																					"N", getSlpNo().getText(), map, getParameter("PatNo"));
													} 
												}
											});
										}
									} else {
										AppStmtUtil.createAppBill(true, dlgAppBillType.getRemark().getText(), dlgAppBillType.getAppBillType().getText(),
												"N", getSlpNo().getText(), map, getParameter("PatNo"));

									}
								} catch (Exception e) {
								}
							}
						}
					});
					dlgAppBillType.setVisible(false);
				}
			};
		}
		return dlgAppBillType;
	}

	protected void slipNoChange(String slpno, final TextSlipMergeSearch slpnoField) {
		if (slpno.length() > 0) {
			seq.resetText();
			seq.setEnabled(false);
		}

		if (getMergeWith1().getText().trim().length()
				+ getMergeWith2().getText().trim().length()
				+ getMergeWith3().getText().trim().length()
				+ getMergeWith4().getText().trim().length()
				+ getMergeWith5().getText().trim().length()
				+ getMergeWith6().getText().trim().length()
				+ getMergeWith7().getText().trim().length()
				+ getMergeWith8().getText().trim().length()
				+ getMergeWith9().getText().trim().length()
				+ getMergeWith10().getText().trim().length() == 0) {
			seq.setEnabled(true);
		}
	}

	@Override
	protected void bExistSlipNo(final boolean printout) {
		if (getMergeWith1().getText().trim().length() > 0
				|| getMergeWith2().getText().trim().length() > 0
				|| getMergeWith3().getText().trim().length() > 0
				|| getMergeWith4().getText().trim().length() > 0
				|| getMergeWith5().getText().trim().length() > 0
				|| getMergeWith6().getText().trim().length() > 0
				|| getMergeWith7().getText().trim().length() > 0
				|| getMergeWith8().getText().trim().length() > 0
				|| getMergeWith9().getText().trim().length() > 0
				|| getMergeWith10().getText().trim().length() > 0) {
			super.bExistSlipNo(printout);
		} else {
			if (getOldSlpNoSize() > 0) {
				dispose();
			} else {
				dispose();
				if (printout) {
					printReport(true);//isImplementMBReady(2);
				}
			}
		}
	}

	protected void validation(boolean printout) {
		if (!getIpStmt().isSelected() && !getIpStmtSum().isSelected() && !getIpDscStmt().isSelected() ) {
			Factory.getInstance().addErrorMessage("You must select one report.");
			return;
		}

		super.validation(printout);
	}

	@Override
	public void isImplementMBReady(int i) {
		super.isImplementMBReady(i);
		int iTemp = i;
		int printName = 0;
		unlockSlips();

		if (getIpStmt().getValue()) {
			if (iTemp == 1) {
				printIPStatementMB();
			} else if (iTemp == 2) {
				if (checkList.size() == finishList.size()) {
					printStatement();
				}
			}
			printName += 1;
		}

		if (getIpStmtSum().getValue()) {
			if (iTemp == 1) {
				printChrgSmyMB();
			} else if (iTemp == 2) {
				if (checkList.size() == finishList.size()) {
					printChrgSmy();
				}
			}
			printName += 2;
		}

		if (getIpDscStmt().getValue()) {
			if (checkList.size() == finishList.size()) {
				printDscStmt();
			}

			printName += 3;
		}

		if (printName > 0 && getSeq().getValue() != null &&
				getSeq().getValue().length() > 0) {
			QueryUtil.executeMasterAction(getUserInfo(), "IPSTATPRINTHIST",
					QueryUtil.ACTION_MODIFY,
					new String[] { getYesOpt().isSelected()?"Y":"N",
							getSeq().getValue() != null ?
									getSeq().getValue().trim() :
									"", getUserInfo().getUserID(), getMemSlipNo(),
									String.valueOf(printName) },
					new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
							}
						}
					});
		}
	}
	
/*	private void createAppBill(boolean isCreateBill, final String remark, String stmtType) {
		if(isCreateBill) {
			QueryUtil.executeMasterAction(getUserInfo(), "APPBILL_SLIP", QueryUtil.ACTION_APPEND,
					new String[] {getMemSlipNo(),stmtType, remark,"N",  getUserInfo().getUserID()},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						Factory.getInstance().addInformationMessage("Post Succeed.");
						
						Map<String,String> map = new HashMap<String,String>();
						map.put("SUBREPORT_DIR", CommonUtil.getReportDir());
						map.put("P_SLPNO", getSlpNo().getText() );
						map.put("ALLSLPNO", getAllSlip(true) );
						map.put("ISCOPY", "Y");
						map.put("remark", remark);
					
						Factory.getInstance()
							.addRequiredReportDesc(map,
									   new String[] {
												"MapLanguage", "MapLanguage", "MapLanguage",
												"MapLanguage", "MapLanguage", "MapLanguage",
												"MapLanguage", "MapLanguage", "MapLanguage",
												"MapLanguage", "MapLanguage", "MapLanguage",
												"MapLanguage", "MapLanguage", "MapLanguage",
												"MapLanguage", "MapLanguage", "MapLanguage",
												"MapLanguage", "MapLanguage"
										},
									   new String[] {
												"StaOfAut", "AdmDtTime", "PatName", "DisDtTime",
												"TreDr", "BillNo", "PatNo", "BedNo", "Copy",
												"Page", "Date", "Item", "Amount", "TotChg",
												"TotRfd", "Balance", "patM", "patB", "BirthDt",
												"DelDr"
										},
										getLanguage());

						String printSeq = getSeq().getValue() != null ?
											getSeq().getValue().trim() :
										null;
						if (printSeq != null && printSeq.length() > 0) {
							map.put("PRNRANGENOTE", "Note: Printing Sequence number "+printSeq);
						}
						map.put("watermark", CommonUtil.getReportImg("app_watermark.gif"));
						map.put("DOCBKGCPY",Factory.getInstance().getSysParameter("DOCBKGCPY"));

						final String billID = mQueue.getReturnCode();
						
						AppStmtUtil.genIPStatement(getMemSlipNo(), billID, getParameter("PatNo"), remark, map);


					} else {
						//Factory.getInstance().addErrorMessage(mQueue, getPkgCode());
					}
				}
			});
		}
	}*/
	
/*	private void getAppChrgSmy(final String billID,final String ipStmtPath){
		final Map<String,String> map = new HashMap<String,String>();
		map.put("SUBREPORT_DIR", CommonUtil.getReportDir());
		map.put("P_SLPNO", getSlpNo().getText() );
		map.put("ALLSLPNO", getAllSlip(true) );
		map.put("NEWACM", null);

		String printSeq = getSeq().getValue() != null ?
							getSeq().getValue().trim() :
							null;
		if (printSeq != null && printSeq.length() > 0) {
			map.put("PRNRANGENOTE", "Note: Printing Sequence number "+printSeq);
		}

		Factory.getInstance()
			.addRequiredReportDesc(map,
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
				getLanguage());
		map.put("watermark", CommonUtil.getReportImg("app_watermark.gif"));

		Report.print(getUserInfo(), "ChrgSmyAPP", map,
				 new String[] {
						getMemSlipNo()
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
								getAllSlip(true), sPrnRange
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
				 },  "", true, false, false, false, new CallbackListener() {
			@Override
			public void handleRetBool(boolean ret, String result, MessageQueue mQueue) {
				if(ret){
					DlgBrowserPanel browserPanel = new DlgBrowserPanel(getMainFrame());
					//browserPanel.showDialog("http://localhost:8080/intranet/mobile/genPatientStmtV2.jsp?slpNo="
					browserPanel.showDialog(Factory.getInstance().getSysParameter("ABillPathW")+"?slpNo="
							+getMemSlipNo()
							+"&patno="+getParameter("PatNo")+"&baseURL="+GWT.getModuleBaseURL()+"&rptPath="+ipStmtPath
							+"&docPath="+result
							+"&from=txnDetail&slpType=I&billID="+billID+"&lang="+getLanguage());
					browserPanel.dispose();
				}
			}
		}, null, "APPBILL", false);
	}*/

	private void printRpt(boolean skipMB) {
		if (skipMB) {
			isImplementMBReady(2);
		} else {
			isImplementMB(
					getUserInfo(),
					getMemSlipNo(),
					getMergeWith1().getText(),
					getMergeWith2().getText(),
					getMergeWith3().getText(),
					getMergeWith4().getText(),
					getMergeWith5().getText().trim(),
					getMergeWith6().getText().trim(),
					getMergeWith7().getText().trim(),
					getMergeWith8().getText().trim(),
					getMergeWith9().getText().trim(),
					getMergeWith10().getText().trim());
		}
	}

	protected void printReport() {
		printReport(false);
	}

	private void printReport(boolean skipMB) {
		sPrnRange = "";

		String printRange = getSeq().getValue() != null ? getSeq().getValue().trim() : null;
		String marge1 = getMergeWith1().getValue() != null ? getMergeWith1().getValue().trim() : null;
		String marge2 = getMergeWith2().getValue() != null ? getMergeWith2().getValue().trim() : null;
		String marge3 = getMergeWith3().getValue() != null ? getMergeWith3().getValue().trim() : null;
		String marge4 = getMergeWith4().getValue() != null ? getMergeWith4().getValue().trim() : null;
		String marge5 = getMergeWith5().getValue() != null ? getMergeWith5().getValue().trim() : null;
		String marge6 = getMergeWith6().getValue() != null ? getMergeWith6().getValue().trim() : null;
		String marge7 = getMergeWith7().getValue() != null ? getMergeWith7().getValue().trim() : null;
		String marge8 = getMergeWith8().getValue() != null ? getMergeWith8().getValue().trim() : null;
		String marge9 = getMergeWith9().getValue() != null ? getMergeWith9().getValue().trim() : null;
		String marge10 = getMergeWith10().getValue() != null ? getMergeWith10().getValue().trim() : null;

		ArrayList<String> colRange = new ArrayList<String>();

		if ((printRange != null && printRange.length() > 0)
				&& (marge1 == null || marge1.length() == 0)
				&& (marge2 == null || marge2.length() == 0)
				&& (marge3 == null || marge3.length() == 0)
				&& (marge4 == null || marge4.length() == 0)
				&& (marge5 == null || marge5.length() == 0)
				&& (marge6 == null || marge6.length() == 0)
				&& (marge7 == null || marge7.length() == 0)
				&& (marge8 == null || marge8.length() == 0)
				&& (marge9 == null || marge9.length() == 0)
				&& (marge10 == null || marge10.length() == 0)) {
			sPrnRange = " and ( ";
			int i = printRange.indexOf(",");

			while (i > 0) {
				colRange.add(printRange.substring(0, i));
				printRange = printRange.substring(i + 1);
				i = printRange.indexOf(",");
			}
			colRange.add(printRange);

			for (String range : colRange) {
				if (range.indexOf("-") > -1) {
					sPrnRange += " (st.stnseq >= " +
								range.substring(0, range.indexOf("-")) +
								" and st.stnseq <= " +
								range.substring(range.indexOf("-") + 1) +
								") or ";
				} else {
					sPrnRange += "st.stnseq = " + range + " or ";
				}
			}
			sPrnRange = sPrnRange.substring(0, sPrnRange.length() - 3);
			sPrnRange += " ) ";
		}
		printRpt(skipMB);
	}

	private void printChrgSmyMB() {
		final Map<String,String> map = new HashMap<String,String>();
		map.put("SUBREPORT_DIR", CommonUtil.getReportDir());
		map.put("P_SLPNO", getSlpNo().getText() );
		map.put("ALLSLPNO", getAllSlip(true) );
		map.put("ISCOPY", getYesOpt().isSelected()?"Y":"");
		if (getPrintNewAcm().isSelected() &&
				getChgAcm().getText() != null &&
				getChgAcm().getText().length()>0 &&
				!memAcm.equals(getChgAcm().getText())) {
			map.put("NEWACM", getChgAcm().getText());
		} else {
			map.put("NEWACM", null);
		}

		String printSeq = getSeq().getValue() != null ?
							getSeq().getValue().trim() :
							null;
		if (printSeq != null && printSeq.length() > 0) {
			map.put("PRNRANGENOTE", "Note: Printing Sequence number "+printSeq);
		}

		Factory.getInstance()
			.addRequiredReportDesc(map,
			   new String[] {
						"MapLanguage", "MapLanguage", "MapLanguage",
						"MapLanguage", "MapLanguage", "MapLanguage",
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
						"SpecialSrv", "Packages", "Balance", "patM", "patB",
						"BirthDt", "DelDr", "BabyName", "BabyNo"
				},
				getLanguage());
		map.put("watermark", CommonUtil.getReportImg("copy_watermark.gif"));
		map.put("DOCBKGCPY",Factory.getInstance().getSysParameter("DOCBKGCPY"));

		String paperSize = Factory.getInstance().getSysParameter("CsPageSize");
		String printerName = "";
		if (paperSize != null && paperSize.length() > 0) {
			printerName = "HATS_"+paperSize;
		}

		final String finalPrinterName = printerName;

		if (memIsPreview) {
			if (getPrintNewAcm().isSelected() &&
					getChgAcm().getText() != null &&
					getChgAcm().getText().length() > 0 &&
					!memAcm.equals(getChgAcm().getText())) {
				QueryUtil.executeMasterAction(getUserInfo(), "CHANGEACM_FORRPT", QueryUtil.ACTION_APPEND,
						new String[] {
							getAllSlip(true),
							getChgAcm().getText(),
							null,
							null,
							getUserInfo().getUserID()
						},
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							Report.print(getUserInfo(), "ChrgSmyMB_chgAcm", map,
									new String[] {
											getMemSlipNo(), getAllSlip(false), getChgAcm().getText()
									},
									new String[] {
											"MB", "PATNAME", "PATCNAME", "SLPNO",
											"PATNO", "REGDATE", "REGTIME", "BEDACM",
											"INPDDATE", "INPDTIME", "DOCNAME",
											"DOCCNAME", "NEWACMENAME", "NEWACMCNAME",
											"BEDCODE", "ACMNAME"
									},
									new boolean[] {
											false, false, false, false, false, false,
											false, false, false, false, false, false, false, false
									},
									new String[] {
											"CHRGSMYMB_CHGACM_SUB"
									},
									new String[][] {
											{
													"'"+getSlpNo().getText()+"'",
													getAllSlip(false), sPrnRange
											}
									},
									new String[][] {
											{
													"DESCRIPTION", "QTY", "AMOUNT",
													"STNTYPE", "ITMTYPE", "DOCCODE",
													"DOCNAME", "DOCCNAME", "CDESCCODE"
											}
									},
									new boolean[][] {
											{
													false, true, false,
													false, false, false,
													false, false, false
											}
									}, "", true, false, true, false, null, null, null, false);
						} else {
							Factory.getInstance().addErrorMessage(mQueue.getReturnMsg(), getChgAcm());
							return;
						}
					}
				});
			} else {
				Report.print(getUserInfo(), "ChrgSmyMB", map,
						new String[] {
								getMemSlipNo(),getAllSlip(false)
						},
						new String[] {
								"MB", "PATNAME", "PATCNAME", "SLPNO",
								"PATNO", "REGDATE", "REGTIME", "BEDACM",
								"INPDDATE", "INPDTIME", "DOCNAME",
								"DOCCNAME", "BEDCODE", "ACMNAME"
						},
						new boolean[] {
								false, false, false, false, false, false,
								false, false, false, false, false, false
						},
						new String[] {
								"CHRGSMYMB_SUB"
						},
						new String[][] {
								{
										"'"+getSlpNo().getText()+"'",
										getAllSlip(false), sPrnRange
								}
						},
						new String[][] {
								{
										"DESCRIPTION", "QTY", "AMOUNT",
										"STNTYPE", "ITMTYPE", "DOCCODE",
										"DOCNAME", "DOCCNAME", "CDESCCODE"
								}
						},
						new boolean[][] {
								{
										false, true, false, false,
										false, false, false, false,
										false
								}
						}, "", true, false, true, false, null, null, null, false);
			}
		} else {
			if (getPrintNewAcm().isSelected() &&
					getChgAcm().getText() != null &&
					getChgAcm().getText().length()>0 &&
					!memAcm.equals(getChgAcm().getText())) {
				QueryUtil.executeMasterAction(getUserInfo(), "CHANGEACM_FORRPT", QueryUtil.ACTION_APPEND,
						new String[] {
							getAllSlip(true),
							getChgAcm().getText(),
							null,
							null,
							getUserInfo().getUserID()
						},
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							if (PrintingUtil.print(finalPrinterName, "ChrgSmyMB_chgAcm", map, null,
									new String[] {
											getMemSlipNo(), getAllSlip(false),getChgAcm().getText()
									},
									new String[] {
											"MB", "PATNAME", "PATCNAME", "SLPNO",
											"PATNO", "REGDATE", "REGTIME", "BEDACM",
											"INPDDATE", "INPDTIME", "DOCNAME",
											"DOCCNAME", "NEWACMENAME", "NEWACMCNAME",
											"BEDCODE", "ACMNAME"
									},
									1,
									new String[] {
											"CHRGSMYMB_CHGACM_SUB"
									},
									new String[][] {
											{
													"'"+getSlpNo().getText()+"'",
													getAllSlip(false), sPrnRange
											}
									},
									new String[][] {
											{
													"DESCRIPTION", "QTY", "AMOUNT",
													"STNTYPE", "ITMTYPE", "DOCCODE",
													"DOCNAME", "DOCCNAME", "CDESCCODE"
											}
									},
									new boolean[][] {
											{
													false, true, false,
													false, false, false,
													false, false, false
											}
									}, 1)) {

								unlockSlips();
							}
						} else {
							Factory.getInstance().addErrorMessage(mQueue.getReturnMsg(), getChgAcm());
							return;
						}
					}
				});
			} else {
				if (PrintingUtil.print(printerName, "ChrgSmyMB", map, null,
						new String[] {
								getMemSlipNo(), getAllSlip(false)
						},
						new String[] {
								"MB", "PATNAME", "PATCNAME", "SLPNO",
								"PATNO", "REGDATE", "REGTIME", "BEDACM",
								"INPDDATE", "INPDTIME", "DOCNAME",
								"DOCCNAME", "BEDCODE", "ACMNAME"
						},
						1,
						new String[] {
								"CHRGSMYMB_SUB"
						},
						new String[][] {
								{
										"'"+getSlpNo().getText()+"'",
										getAllSlip(false), sPrnRange
								}
						},
						new String[][] {
								{
										"DESCRIPTION", "QTY", "AMOUNT",
										"STNTYPE", "ITMTYPE", "DOCCODE",
										"DOCNAME", "DOCCNAME", "CDESCCODE"
								}
						},
						new boolean[][] {
								{
										false, true, false,
										false, false, false,
										false, false, false
								}
						}, 1)) {

					unlockSlips();
				}
			}
		}
	}

	private void printChrgSmy() {
		final Map<String,String> map = new HashMap<String,String>();
		map.put("SUBREPORT_DIR", CommonUtil.getReportDir());
		map.put("P_SLPNO", getSlpNo().getText() );
		map.put("ALLSLPNO", getAllSlip(true) );
		map.put("ISCOPY", getYesOpt().isSelected()?"Y":"");
		if (getPrintNewAcm().isSelected() &&
				getChgAcm().getText() != null &&
				getChgAcm().getText().length() > 0 &&
				!memAcm.equals(getChgAcm().getText())) {
			map.put("NEWACM", getChgAcm().getText());
		} else {
			map.put("NEWACM", null);
		}

		String printSeq = getSeq().getValue() != null ?
							getSeq().getValue().trim() :
							null;
		if (printSeq != null && printSeq.length() > 0) {
			map.put("PRNRANGENOTE", "Note: Printing Sequence number "+printSeq);
		}

		Factory.getInstance()
			.addRequiredReportDesc(map,
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
				getLanguage());
		map.put("watermark", CommonUtil.getReportImg("copy_watermark.gif"));
		map.put("DOCBKGCPY",Factory.getInstance().getSysParameter("DOCBKGCPY"));
		if (getSignYesOpt().isSelected()) {
			map.put("mothLang", mothLang);
		}
		map.put("siteCode", getUserInfo().getSiteCode());

		String paperSize = Factory.getInstance().getSysParameter("CsPageSize");
		String printerName = "";
		if (paperSize != null && paperSize.length() > 0) {
			printerName = "HATS_"+paperSize;
		}

		final String finalPrinterName =  printerName;

		if (memIsPreview) {
			if (getPrintNewAcm().isSelected() &&
					getChgAcm().getText() != null &&
					getChgAcm().getText().length() > 0 &&
					!memAcm.equals(getChgAcm().getText())) {

				QueryUtil.executeMasterAction(getUserInfo(), "CHANGEACM_FORRPT", QueryUtil.ACTION_APPEND,
						new String[] {
							getAllSlip(true),
							getChgAcm().getText(),
							null,
							null,
							getUserInfo().getUserID()
						},
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							Report.print(getUserInfo(), "ChrgSmy_chgAcm", map,
									new String[] {
											getMemSlipNo(), getChgAcm().getText()
									},
									new String[] {
											"PATNAME", "PATCNAME", "SLPNO", "PATNO",
											"REGDATE", "REGTIME", "BEDACM", "INPDDATE",
											"INPDTIME", "DOCNAME", "DOCCNAME", "NEWACMENAME", "NEWACMCNAME"
									},
									new boolean[] {
											false, false, false, false, false, false,
											false, false, false, false, false, false, false
									},
									new String[] {
											"CHRGSMY_CHGACM_SUB"
									} ,
									new String[][] {
											{
													getAllSlip(true), sPrnRange
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
						} else {
							Factory.getInstance().addErrorMessage(mQueue.getReturnMsg(), getChgAcm());
							return;
						}
					}
				});
			} else {
				Report.print(getUserInfo(), "ChrgSmy", map,
						 new String[] {
								getMemSlipNo()
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
										getAllSlip(true), sPrnRange
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
			}
		} else {
			if (getPrintNewAcm().isSelected() &&
					getChgAcm().getText() != null &&
					getChgAcm().getText().length() > 0 &&
					!memAcm.equals(getChgAcm().getText())) {
				QueryUtil.executeMasterAction(getUserInfo(), "CHANGEACM_FORRPT", QueryUtil.ACTION_APPEND,
						new String[] {
							getAllSlip(true),
							getChgAcm().getText(),
							null,
							null,
							getUserInfo().getUserID()
						},
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							if (PrintingUtil.print(finalPrinterName, "ChrgSmy_chgAcm",
									map, null, new String[] { getMemSlipNo(), getChgAcm().getText() },
									new String[] {
											"PATNAME", "PATCNAME", "SLPNO", "PATNO",
											"REGDATE", "REGTIME", "BEDACM", "INPDDATE",
											"INPDTIME", "DOCNAME", "DOCCNAME", "NEWACMENAME", "NEWACMCNAME"
									}, 1,
									new String[] { "CHRGSMY_CHGACM_SUB" },
									new String[][] {
											{
													getAllSlip(true), sPrnRange
											}
									},
									new String[][] {
											{
													"DESCRIPTION", "QTY", "AMOUNT", "STNTYPE", "ITMTYPE",
													"DOCCODE", "DOCNAME", "DOCCNAME", "CDESCCODE"
											}
									},
									new boolean[][] {
											{ false, true, false, false, false, false, false, false, false }
									}, 1)) {

								unlockSlips();
							}
						} else {
							Factory.getInstance().addErrorMessage(mQueue.getReturnMsg(), getChgAcm());
							return;
						}
					}
				});
			} else {
				if (PrintingUtil.print(printerName, "ChrgSmy",
						map, null, new String[] { getMemSlipNo() },
						new String[] {
								"PATNAME", "PATCNAME", "SLPNO", "PATNO",
								"REGDATE", "REGTIME", "BEDACM", "INPDDATE",
								"INPDTIME", "DOCNAME", "DOCCNAME"
						}, 1,
						new String[] { "CHRGSMY_SUB" },
						new String[][] {
								{ getAllSlip(true), sPrnRange }
						},
						new String[][] {
								{
										"DESCRIPTION", "QTY", "AMOUNT", "STNTYPE", "ITMTYPE",
										"DOCCODE", "DOCNAME", "DOCCNAME", "CDESCCODE"
								}
						},
						new boolean[][] {
								{ false, true, false, false, false, false, false, false, false }
						}, 1)) {

					unlockSlips();
				}
			}
		}
	}

	private void printIPStatementMB() {
		Map<String,String> map = new HashMap<String,String>();
		map.put("SUBREPORT_DIR", CommonUtil.getReportDir());
		map.put("P_SLPNO", getSlpNo().getText() );
		map.put("ALLSLPNO", getAllSlip(true) );
		map.put("ISCOPY", getYesOpt().isSelected()?"Y":"");

		Factory.getInstance()
			.addRequiredReportDesc(map,
					   new String[] {
								"MapLanguage", "MapLanguage", "MapLanguage",
								"MapLanguage", "MapLanguage", "MapLanguage",
								"MapLanguage", "MapLanguage", "MapLanguage",
								"MapLanguage", "MapLanguage", "MapLanguage",
								"MapLanguage", "MapLanguage", "MapLanguage",
								"MapLanguage", "MapLanguage", "MapLanguage",
								"MapLanguage", "MapLanguage"
						},
					   new String[] {
								"StaOfAut", "AdmDtTime", "PatName", "DisDtTime",
								"TreDr", "BillNo", "PatNo", "BedNo", "Copy",
								"Page", "Date", "Item", "Amount", "TotChg",
								"TotRfd", "Balance", "patM", "patB", "BirthDt",
								"DelDr"
						},
						getLanguage());

		String printSeq = getSeq().getValue() != null ?
							getSeq().getValue().trim() :
						null;
		if (printSeq != null && printSeq.length() > 0) {
			map.put("PRNRANGENOTE", "Note: Printing Sequence number "+printSeq);
		}
		map.put("watermark", CommonUtil.getReportImg("copy_watermark.gif"));
		map.put("DOCBKGCPY",Factory.getInstance().getSysParameter("DOCBKGCPY"));
		String paperSize = Factory.getInstance().getSysParameter("IpPageSize");
		map.put("siteCode", getUserInfo().getSiteCode());

		String printerName = "";
		if (paperSize != null && paperSize.length() > 0) {
			printerName = "HATS_"+paperSize;
		}

		if (memIsPreview) {
			Report.print(getUserInfo(), "IPStatementMB", map,
						new String[] {
								getMemSlipNo(), getAllSlip(false)
						},
						new String[] {
								"MB", "PATNAME", "PATCNAME", "SLPNO", "PATNO",
								"REGDATE", "REGTIME", "BEDACM", "INPDDATE",
								"INPDTIME", "DOCNAME", "DOCCNAME"
						},
						new boolean[] {
								false, false, false, false, false, false, false,
								false, false, false, false, false
						},
						new String[] {
								"IPStatement_Sub1",
						},
						new String[][] {
								{
										getAllSlip(true), sPrnRange
								}
						},
						new String[][] {
								{
										"STNTDATE", "AMOUNT", "DESCRIPTION", "QTY",
										"TOTALREFUND", "TOTALCHARGE", "CDESCCODE"
								}
						 },
						 new boolean[][] {
								{
										false, true, false, true, true, true, false
								}
						 }, "", true, false, true, false, null, null, null, false);
		} else {
			if (PrintingUtil.print(printerName, "IPStatementMB",
					map,null,
					new String[] {getMemSlipNo(), getAllSlip(false)},
					new String[] {"MB", "PATNAME", "PATCNAME", "SLPNO", "PATNO", "REGDATE",
					"REGTIME", "BEDACM", "INPDDATE", "INPDTIME", "DOCNAME", "DOCCNAME"},
					1,new String[] {"IPStatement_Sub1"}, new String[][] {{getAllSlip(true), sPrnRange}},
					new String[][] {{"STNTDATE", "AMOUNT", "DESCRIPTION", "QTY", "TOTALREFUND", "TOTALCHARGE", "CDESCCODE"}},
					new boolean[][] {{false,true,false,true, true, true, false}}, 1)) {

				unlockSlips();
			}
		}
	}

	private void printStatement() {
		Map<String,String> map = new HashMap<String,String>();
		map.put("SUBREPORT_DIR",CommonUtil.getReportDir());
		map.put("P_SLPNO",getSlpNo().getText() );
		map.put("ALLSLPNO",getAllSlip(true) );
		map.put("ISCOPY",getYesOpt().isSelected()?"Y":"");

		Factory.getInstance()
			.addRequiredReportDesc(map,
							new String[] {
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage"
							},
							new String[] {
									"StaOfAut", "AdmDtTime", "PatName",
									"DisDtTime", "TreDr", "BillNo",
									"PatNo", "BedNo", "Copy", "Page",
									"Date", "Item", "Amount", "TotChg",
									"TotRfd", "Balance"
							},
							getLanguage());

		String printSeq = getSeq().getValue() != null ?
							getSeq().getValue().trim() :
							null;
		if (printSeq != null && printSeq.length() > 0) {
			map.put("PRNRANGENOTE", "Note: Printing Sequence number "+printSeq);
		}
		map.put("watermark", CommonUtil.getReportImg("copy_watermark.gif"));
		map.put("DOCBKGCPY",Factory.getInstance().getSysParameter("DOCBKGCPY"));
		map.put("siteCode", getUserInfo().getSiteCode());

		String paperSize = Factory.getInstance().getSysParameter("IpPageSize");
		String printerName = "";
		if (paperSize != null && paperSize.length() > 0) {
			printerName = "HATS_"+paperSize;
		}

		// another report .
		if (memIsPreview) {
			Report.print(getUserInfo(), "IPStatement", map,
					new String[] { getMemSlipNo() },
					new String[] {
							"PATNAME", "PATCNAME" ,"SLPNO", "PATNO",
							"REGDATE", "REGTIME", "BEDACM", "INPDDATE",
							"INPDTIME", "DOCNAME", "DOCCNAME"
					},
					new boolean[] {
							false, false, false, false, false, false,
							false, false, false, false, false
					},
					new String[] {
							"IPStatement_Sub1",
							"IPStatement_Sub2"
					} ,
					new String[][] {
							{
									getAllSlip(true), sPrnRange
							},
							{
									getAllSlip(true), sPrnRange
							}
					},
					new String[][] {
							{
									"STNTDATE", "AMOUNT", "DESCRIPTION", "QTY",
									"TOTALREFUND", "TOTALCHARGE", "CDESCCODE"
							},
							{
									"ARCCODE", "ARCNAME", "ATXAMT"
							}
					},
					new boolean[][] {
							{
									false, true, false, true, true, true, false
							},
							{
									false, false, true
							}
					}, Factory.getInstance().getSysParameter("IpPageSize"));
		} else {
			if (PrintingUtil.print(printerName, "IPStatement", map, null,
					new String[] {
							getMemSlipNo()
					},
					new String[] {
							"PATNAME", "PATCNAME", "SLPNO", "PATNO",
							"REGDATE", "REGTIME", "BEDACM", "INPDDATE",
							"INPDTIME", "DOCNAME", "DOCCNAME"
					}, 2,
					new String[] {
							"IPStatement_Sub1", "IPStatement_Sub2"
					},
					new String[][] {
							{
									getAllSlip(true), sPrnRange
							},
							{
									getAllSlip(true), sPrnRange
							}
					},
					new String[][] {
							{
									"STNTDATE", "AMOUNT" ,"DESCRIPTION", "QTY",
									"TOTALREFUND", "TOTALCHARGE", "CDESCCODE"
							},
							{
									"ARCCODE", "ARCNAME", "ATXAMT"
							}
					},
					new boolean[][] {
							{
									false, true, false, true, true, true, false
							},
							{
									false, false, true
							}
					}, 1, Factory.getInstance().getSysParameter("IpPageSize"))) {

				unlockSlips();
			}
		}
	}

	private void printDscStmt() {
		Map<String,String> map = new HashMap<String,String>();
		map.put("SUBREPORT_DIR",CommonUtil.getReportDir());
		map.put("P_SLPNO",getSlpNo().getText() );
		map.put("ALLSLPNO",getAllSlip(true) );
		map.put("ISCOPY",getYesOpt().isSelected()?"Y":"");

		Factory.getInstance()
			.addRequiredReportDesc(map,
							new String[] {
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage", "MapLanguage",
									"MapLanguage", "MapLanguage"
							},
							new String[] {
									"AdmDtTime", "PatName","DisDtTime",
									"TreDr", "BillNo","PatNo",
									"BedNo", "Copy","Page",
									"Date", "Item","Amount",
									"TotChg","TotRfd","Balance",
									"SerDtl","ServName"
							},
							getLanguage());

		String printSeq = getSeq().getValue() != null ?
							getSeq().getValue().trim() :
							null;
		if (printSeq != null && printSeq.length() > 0) {
			map.put("PRNRANGENOTE", "Note: Printing Sequence number "+printSeq);
		}
		map.put("watermark", CommonUtil.getReportImg("copy_watermark.gif"));
		map.put("DOCBKGCPY",Factory.getInstance().getSysParameter("DOCBKGCPY"));

		String paperSize = Factory.getInstance().getSysParameter("IpPageSize");
		String printerName = "";
		if (paperSize != null && paperSize.length() > 0) {
			printerName = "HATS_"+paperSize;
		}

		// another report .
		if (memIsPreview) {
			Report.print(getUserInfo(), "ServDetails", map,
					new String[] { getMemSlipNo(),getDptServiceCode().getText() },
					new String[] {
							"PATNAME", "PATCNAME" ,"SLPNO", "PATNO",
							"REGDATE", "REGTIME", "BEDACM", "INPDDATE",
							"INPDTIME", "DOCNAME", "DOCCNAME","DSCNAME",
							"DSCCNAME"
					},
					new boolean[] {
							false, false, false, false, false, false,
							false, false, false, false, false, false,
							false
					},
					new String[] {
							"ServDetails_Sub"
					} ,
					new String[][] {
							{
									getAllSlip(true),getDptServiceCode().getText(), sPrnRange
							}
					},
					new String[][] {
							{
									"STNTDATE", "AMOUNT", "DESCRIPTION", "QTY",
									"TOTALREFUND", "TOTALCHARGE", "CDESCCODE"
							}
					},
					new boolean[][] {
							{
									false, true, false, true, true, true, false
							}
					}, Factory.getInstance().getSysParameter("IpPageSize")
					, true, false, true, false, null, null, null, false);
		} else {
			if (PrintingUtil.print(printerName, "ServDetails", map, null,
					new String[] {
							getMemSlipNo(),getDptServiceCode().getText()
					},
					new String[] {
							"PATNAME", "PATCNAME", "SLPNO", "PATNO",
							"REGDATE", "REGTIME", "BEDACM", "INPDDATE",
							"INPDTIME", "DOCNAME", "DOCCNAME","DSCNAME",
							"DSCCNAME"
					}, 1,
					new String[] {
							"ServDetails_Sub"
					},
					new String[][] {
							{
									getAllSlip(true),getDptServiceCode().getText(), sPrnRange
							}
					},
					new String[][] {
							{
									"STNTDATE", "AMOUNT" ,"DESCRIPTION", "QTY",
									"TOTALREFUND", "TOTALCHARGE", "CDESCCODE"
							}
					},
					new boolean[][] {
							{
									false, true, false, true, true, true, false
							}
					}, 1, Factory.getInstance().getSysParameter("IpPageSize"))) {

				unlockSlips();
			}
		}
	}

/*
	private void addCheckList(String[] param) {
		finishList.clear();
		checkList.clear();

		for (String s : param) {
			if (s != null && s.length() > 0) {
				checkList.add(s);
			}
		}
	}
*/
	public void enablePreviewBtn() {
		getButtonById(YES).setEnabled(getIpStmtSum().isSelected() || getIpStmt().isSelected() || getIpDscStmt().isSelected());
		getButtonById(NO).setEnabled(getIpStmtSum().isSelected() || getIpStmt().isSelected() || getIpDscStmt().isSelected());
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getIPOfficePanel() {
		if (IPOfficePanel == null) {
			IPOfficePanel = new BasePanel();
			IPOfficePanel.setBounds(5, 5, 720, 670);
			IPOfficePanel.add(getWhichReportPanel(), null);
			IPOfficePanel.add(getSlipPanel(), null);
			IPOfficePanel.add(getSeqPanel(), null);
			IPOfficePanel.add(getCopyPanel(), null);
			IPOfficePanel.add(getSignPanel(), null);
		}
		return IPOfficePanel;
	}

	public FieldSetBase getWhichReportPanel() {
		if (whichReportPanel == null) {
			whichReportPanel = new FieldSetBase();
			whichReportPanel.setBounds(10, 5, 675, 60);
			whichReportPanel.setHeading("Print Which Report?");
			whichReportPanel.add(getIpStmt(), null);
			whichReportPanel.add(getIpStmtDesc(), null);
			whichReportPanel.add(getIpStmtSum(), null);
			whichReportPanel.add(getIpStmtSumDesc(), null);
			whichReportPanel.add(getIpDscStmt(), null);
			whichReportPanel.add(getIpDscStmtDesc(), null);
			whichReportPanel.add(getDptServiceCode(), null);
		}
		return whichReportPanel;
	}

	public CheckBoxBase getIpStmt() {
		if (ipStmt == null) {
			ipStmt = new CheckBoxBase() {
				@Override
				public void onClick() {
					enablePreviewBtn();
				}
			};
			ipStmt.setBounds(120, 0, 24, 20);
			ipStmt.setSelected(false);
		}
		return ipStmt;
	}

	public LabelBase getIpStmtDesc() {
		if (ipStmtDesc == null) {
			ipStmtDesc = new LabelBase();
			ipStmtDesc.setBounds(145, 0, 80, 20);
			ipStmtDesc.setText("IP Statement");
		}
		return ipStmtDesc;
	}

	public CheckBoxBase getIpStmtSum() {
		if (ipStmtSum == null) {
			ipStmtSum = new CheckBoxBase() {
				@Override
				public void onClick() {
					enablePreviewBtn();
				}
			};
			ipStmtSum.setBounds(250, 0, 24, 20);
		}
		return ipStmtSum;
	}

	public LabelBase getIpStmtSumDesc() {
		if (ipStmtSumDesc == null) {
			ipStmtSumDesc = new LabelBase();
			ipStmtSumDesc.setBounds(275, 0, 150, 20);
			ipStmtSumDesc.setText("IP Statement Summary");
		}
		return ipStmtSumDesc;
	}

	public CheckBoxBase getIpDscStmt() {
		if (ipDscStmt == null) {
			ipDscStmt = new CheckBoxBase() {
				@Override
				public void onClick() {
					enablePreviewBtn();
				}
			};
			ipDscStmt.setBounds(445, 0, 24, 20);
		}
		return ipDscStmt;
	}

	public LabelBase getIpDscStmtDesc() {
		if (ipDscStmtDesc == null) {
			ipDscStmtDesc = new LabelBase();
			ipDscStmtDesc.setBounds(470, 0, 100, 20);
			ipDscStmtDesc.setText("Service Details");
		}
		return ipDscStmtDesc;
	}

	public ComboDeptServ getDptServiceCode() {
		if (dptServiceCode == null) {
			dptServiceCode = new ComboDeptServ();
			dptServiceCode.setMinListWidth(190);
			dptServiceCode.setBounds(555, 0, 100, 20);
		}
		return dptServiceCode;
	}

	protected LayoutContainer getSlipPanel() {
		if (slipPanel == null) {
			slipPanel = new FieldSetBase();
			slipPanel.setBounds(10, 75, 675, 175);
			slipPanel.setHeading("Slip");
			slipPanel.add(getSlpNoDesc(), null);
			slipPanel.add(getSlpNo(), null);
			slipPanel.add(getSaveMergeSlip(), null);
			slipPanel.add(getMergeWithDesc(), null);
			slipPanel.add(getMergeWith1(), null);
			slipPanel.add(getMergeWith2(), null);
			slipPanel.add(getMergeWith3(), null);
			slipPanel.add(getMergeWith4(), null);
			slipPanel.add(getMergeWith5(), null);
			slipPanel.add(getMergeWith6(), null);
			slipPanel.add(getMergeWith7(), null);
			slipPanel.add(getMergeWith8(), null);
			slipPanel.add(getMergeWith9(), null);
			slipPanel.add(getMergeWith10(), null);
			slipPanel.add(getChgAcmDesc(), null);
			slipPanel.add(getChgAcm(), null);
			slipPanel.add(getPrintNewAcm(), null);
			slipPanel.add(getNoticeDesc(), null);
		}
		return slipPanel;
	}

	public LabelBase getChgAcmDesc() {
		if (chgAcmDesc == null) {
			chgAcmDesc = new LabelBase();
			chgAcmDesc.setText("New Accommodation<br>Code: <font color='red'>(For print ONLY)</font>");
			chgAcmDesc.setBounds(500, 0, 150, 20);
		}
		return chgAcmDesc;
	}

	public ComboACMCode getChgAcm() {
		if (chgAcm == null) {
			chgAcm = new ComboACMCode() {
				@Override
				public void onSelected() {
					getPrintNewAcm().setSelected(true);
				}
			};
			chgAcm.setBounds(500, 50, 150, 20);
		}
		return chgAcm;
	}

	public CheckBoxBase getPrintNewAcm() {
		if (printNewAcm == null) {
			printNewAcm = new CheckBoxBase();
			printNewAcm.setBounds(630, 0, 20, 20);
		}
		return printNewAcm;
	}

	public LabelBase getNoticeDesc() {
		if (noticeDesc == null) {
			noticeDesc = new LabelBase();
			noticeDesc.setText("<i>Notice: The printout is according to the current Price List</i>");
			noticeDesc.setBounds(500, 90, 150, 20);
			noticeDesc.setStyleAttribute("color", "#FF0000");
		}
		return noticeDesc;
	}

	public FieldSetBase getSeqPanel() {
		if (seqPanel == null) {
			seqPanel = new FieldSetBase();
			seqPanel.setBounds(10, 260, 675, 150);
			seqPanel.setHeading("Print Sequence");
			seqPanel.add(getSeq(), null);
			seqPanel.add(getSeqDesc(), null);
			seqPanel.add(getSeqScrollPane(), null);
		}
		return seqPanel;
	}

	public LabelBase getSeqDesc() {
		if (seqDesc == null) {
			seqDesc = new LabelBase();
			seqDesc.setText("Sequence #:");
			seqDesc.setBounds(20, 0, 80, 20);
		}
		return seqDesc;
	}

	public TextString getSeq() {
		if (seq == null) {
			seq = new TextString();
			seq.addKeyListener(new KeyListener() {
				@Override
				public void componentKeyPress(ComponentEvent event) {
					int curKey = event.getKeyCode();

					if ((curKey >= 44 && curKey <= 57 &&
							(curKey != 46 && curKey != 47)) ||
							curKey == KeyCodes.KEY_BACKSPACE) {
					} else {
						event.stopEvent();
					}
				}
			});

			seq.addListener(Events.OnBlur, new Listener<FieldEvent>() {
				@Override
				public void handleEvent(FieldEvent be) {
					TextString t = (TextString)be.getField();
					String value = t.getValue();

					if (value != null) {
						if ((value.trim().lastIndexOf(",") == value.trim().length() - 1)
								|| (value.trim().indexOf(",") == 0)) {
							t.resetText();
							t.focus();
						}
					}
				}
			});
			//seq.setReadOnly(true);
			seq.setBounds(105, 0, 540, 20);
		}
		return seq;
	}

	public TableList getSeqList() {
		if (seqList == null) {
			seqList = new TableList(
					new String[] {"", "Date", "Copy", "Print Sequence", "User" },
					new int[] {10, 120, 80, 180 ,80}) {
				@Override
				public void onSelectionChanged() {
					if (getSelectionModel().getSelectedItems().size() > 0) {
						int row = getSeqList().getSelectedRow();
						String seqNo = getSeqList().getValueAt(row, 3);
						if (seqNo != null && seqNo.length() > 0) {
							getSeq().setText(seqNo);
						}
					}
				};

				@Override
				public void setListTableContentPost() {
					getSelectionModel().deselectAll();
					getSeq().resetText();
				}
			};
			seqList.setBounds(0, 0, 625, 90);
			seqList.setBorders(false);
		}
		return seqList;
	}

	public JScrollPane getSeqScrollPane() {
		if (seqScrollPane == null) {
			seqScrollPane = new JScrollPane();
			seqScrollPane.setBounds(20, 25, 625, 90);
			seqScrollPane.setViewportView(getSeqList());
		}
		return seqScrollPane;
	}

	public FieldSetBase getCopyPanel() {
		if (copyPanel == null) {
			copyPanel = new FieldSetBase();
			copyPanel.setBounds(10, 420, 675, 80);
			copyPanel.setHeading("Is It A Copy?");
			copyPanel.add(getYesOpt(), null);
			copyPanel.add(getNoOpt(), null);
		}
		return copyPanel;
	}

	public RadioButtonBase getYesOpt() {
		if (yesOpt == null) {
			yesOpt = new RadioButtonBase();
			yesOpt.setText("Yes, it is a Copy.");
			yesOpt.setBounds(250, 0, 180, 20);
		}
		return yesOpt;
	}

	public RadioButtonBase getNoOpt() {
		if (noOpt == null) {
			noOpt = new RadioButtonBase();
			noOpt.setText("No, it is the Original.");
			noOpt.setSelected(true);
			noOpt.setBounds(250, 25, 180, 20);
		}
		return noOpt;
	}

	public FieldSetBase getSignPanel() {
		if (signPanel == null) {
			signPanel = new FieldSetBase();
			signPanel.setBounds(350, 420, 330, 80);
			signPanel.setHeading("Print Signature (Summary)?");
			signPanel.add(getSignYesOpt(), null);
			signPanel.add(getSignNoOpt(), null);
			signPanel.setVisible(false);
		}
		return signPanel;
	}

	public RadioButtonBase getSignYesOpt() {
		if (signYesOpt == null) {
			signYesOpt = new RadioButtonBase();
			signYesOpt.setText("Yes, print with Signature on Summary.");
			signYesOpt.setBounds(40, 0, 180, 20);
		}
		return signYesOpt;
	}

	public RadioButtonBase getSignNoOpt() {
		if (signNoOpt == null) {
			signNoOpt = new RadioButtonBase();
			signNoOpt.setText("No, print without Signature.");
			signNoOpt.setSelected(true);
			signNoOpt.setBounds(40, 25, 180, 20);
		}
		return signNoOpt;
	}
}