package com.hkah.client.layout.dialog;

import java.util.HashMap;
import java.util.Map;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.form.RadioGroup;
import com.google.gwt.core.client.GWT;
import com.hkah.client.layout.dialog.DlgBrowserPanel;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.event.CallbackListener;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.radiobutton.RadioButtonBase;
import com.hkah.client.layout.textfield.TextAreaBase;
import com.hkah.client.util.AppStmtUtil;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.Report;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgOPDayCaseStatement extends DialogSlipBase {
	private final static int m_frameWidth = 500;
	private final static int m_frameHeight = 460;

	private BasePanel OPOfficePanel = null;
	private RadioButtonBase yesOpt = null;
	private RadioButtonBase noOpt = null;	
	private LabelBase copyDesc = null;
	private RadioButtonBase signYesOpt = null;
	private RadioButtonBase signNoOpt = null;
	private LabelBase signDesc = null;
	private RadioButtonBase diagYesOpt = null;
	private RadioButtonBase diagNoOpt = null;
	private LabelBase diagDesc = null;
	private LabelBase rmkTxtDesc = null;
	private DlgReprintRpt dlgReprintRpt = null;
	private BasePanel copyPanel = null;
	private TextAreaBase remarkTextArea = null;
	
	private DlgAppBillType dlgAppBillType = null;

	private boolean memIsPreview = false;
	private boolean memIsReprint = false;
	private String memReportType = "";
	private boolean isAR = false;
	private String mothLang = null;
	private boolean isDirBilWfPatPay =  false;
	private boolean isARSign = false;
//	private boolean isShowSign = false;
	private boolean isDiagAlert = false;
	private boolean isCreateAppBill = false;
	
	private ButtonBase createAppBills = null;

	public DlgOPDayCaseStatement(MainFrame owner) {
		super(owner, YESNOCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Print OP/Day Case Statement");
		setContentPane(getOPOfficePanel());

		// change label
		getButtonById(YES).setText("Preview");
		getButtonById(NO).setText("Print", 'P');

		RadioGroup btngrp = new RadioGroup();
		btngrp.add(getYesOpt());
		btngrp.add(getNoOpt());

		RadioGroup signBtngrp = new RadioGroup();
		signBtngrp.add(getSignYesOpt());
		signBtngrp.add(getSignNoOpt());
		
		RadioGroup diagBtngrp = new RadioGroup();
		diagBtngrp.add(getDiagYesOpt());
		diagBtngrp.add(getDiagNoOpt());
		
		getButtonBar().add(getCreateABills());

		// layout
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	@Override
	public Component getDefaultFocusComponent() {
		return getOPOfficePanel();
	}

	public void showDialog(String patNo, String slpNo, String slpType, boolean isReprint,
			String rptType, final boolean isAutoPrint, String rptLang, String mothLang,
			boolean isAR, boolean arSign) {
		showDialog(patNo, slpNo, slpType, isReprint, rptType, isAutoPrint, rptLang, mothLang, null, isAR, arSign);
	}

	public void showDialog(String patNo, String slpNo, String slpType, boolean isReprint,
							String rptType, final boolean isAutoPrint, String rptLang,
							String mothLang, String smtRemark, boolean isAR, boolean arSign) {
		setMemSlipNo(slpNo);
//		setSlipType(slpType);
		memIsReprint = isReprint;
		memReportType = rptType;
		this.isAR = isAR;
		this.mothLang = mothLang;
		isDirBilWfPatPay = false;

		getRemarkTextArea().setText(smtRemark);
		clearSlipField();

		setParameter("PatNo", patNo);
		setLanguage(rptLang);

		getNoOpt().setSelected(true);

		loadOldSlipNo(isAutoPrint);
		
		if (HKAH_VALUE.equals(getUserInfo().getSiteCode())) {
			QueryUtil.executeMasterFetch(getUserInfo(), "CHECKSTAFFALERT",
					new String[] {slpNo},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						int value = 0;
						try {
							value = Integer.parseInt(mQueue.getContentField()[0]);
							if (value > 0) {
								isDiagAlert = true;
								getDiagNoOpt().setSelected(true);
							} else {
								isDiagAlert = false;
							}
						} catch (Exception e) {
						}
					}
				}
			});
		} else {
			isDiagAlert = false;
			getDiagYesOpt().setSelected(true);
		}
		

		if (!isReprint && Factory.getInstance().getSysParameter("OPStmtCopy").equals("Y")) {
			getYesOpt().setSelected(true);
		}

		if (Factory.getInstance().getSysParameter("SHOWSIGN").equals("Y")) {
			if (Factory.getInstance().getSysParameter("ArSignMeth").equals("A")) {
				if (isAR) {
					QueryUtil.executeMasterFetch(getUserInfo(), "SLIPCNTPAYMENT",
							new String[] { slpNo },
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								isDirBilWfPatPay = (Integer.parseInt(mQueue.getContentField()[1]))>0?true:false;
							}
						}
					});
					//specified AR
					if (arSign) {
						isARSign = arSign;
						getSignYesOpt().setSelected(true);
					} else {
						getSignNoOpt().setSelected(true);
					}
				} else {
					getSignNoOpt().setSelected(true);
				}
			} else {
				QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
						new String[] {"ARTX", "COUNT(1)", "SLPNO='" + slpNo + "' AND  ATXSTS = 'N' "},
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							int value = 0;
							try {
								value = Integer.parseInt(mQueue.getContentField()[0]);
								if (value > 0) {
									getSignYesOpt().setSelected(true);
								} else {
									getSignNoOpt().setSelected(true);
								}
							} catch (Exception e) {
							}
						}
					}
				});
			}
		}

		if (!isAutoPrint) {
			setVisible(true);
		}
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

	@Override
	protected void printReport() {
		if (getRemarkTextArea().getText().length() > 0 &&
				!"N".equals(Factory.getInstance().getSysParameter("SHOWDGNS"))) {
			QueryUtil.executeMasterAction(getUserInfo(), "SLIPSMTRMK", QueryUtil.ACTION_APPEND,
					new String[] {getMemSlipNo(), getRemarkTextArea().getText(),getUserInfo().getUserID()},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						Factory.getInstance().addSystemMessage(Factory.getInstance().getSysParameter("SHOWDGNS")+" Updated");
					}
				}
			});
		}
 		printOPStatement(Factory.getInstance().getSysParameter("SHOWSIGN").equals("Y")?
  							getSignYesOpt().isSelected():false, getYesOpt().isSelected(), false);
	}

	private Map<String,String> getOPStatementParamSet(boolean signature, boolean copy,boolean memIsReprint) {
		Map<String,String> map = new HashMap<String,String>();
		map.put("SUBREPORT_DIR", CommonUtil.getReportDir());
		map.put("P_SLPNO", getAllSlip(true) );
		map.put("ISCOPY", copy?"Y":"");
		map.put("RPTTYPE", memReportType);
		map.put("watermark", CommonUtil.getReportImg("copy_watermark.gif"));
		map.put("ISSHOWDIAG", memIsReprint?(copy?"":(getDiagYesOpt().isSelected()?"Y":"")):getDiagYesOpt().isSelected()?"Y":"");
		map.put("AppIOSQRImg",CommonUtil.getReportImg("AppIOSQRCode.png"));
		map.put("AppAndImg",CommonUtil.getReportImg("AppAndQRCode.png"));
		map.put("isShwPromo",Factory.getInstance().getSysParameter("isShwPromo"));
		map.put("AppWatermark", CommonUtil.getReportImg("app_watermark.gif"));

		Factory.getInstance().addRequiredReportDesc(map,
				new String[] {
					"MapLanguage", "MapLanguage", "MapLanguage",
					"MapLanguage", "MapLanguage", "MapLanguage",
					"MapLanguage", "MapLanguage", "MapLanguage",
					"MapLanguage", "MapLanguage", "MapLanguage",
					"MapLanguage", "MapLanguage","Maplanguage"
				},
				new String[] {
					"receipt", "offsta", "PatNo",
					"PatName", "TreDr", "BillNo",
					"Copy", "Page", "Date",
					"Item", "Amount", "HKD",
					"Signature","Diagnosis","OpTreDr"
				},
				getLanguage());

		if (signature) {
			map.put("mothLang", mothLang);
		}

		map.put("isShowSign", signature?"Y":"N");
		map.put("isOpShowSignL", Factory.getInstance().getSysParameter("OpShowSgnL"));
		map.put("Diagnosis", Factory.getInstance().getSysParameter("SHOWDGNS"));
		map.put("DiagnosisContent", getRemarkTextArea().getText());

		return map;
	}

	private int[] getOPStatementCopyNoSet(boolean isReprint, boolean isDirBillWfPatPay,boolean isAR) {
		int[] CopyNoSet = new int[] {0,0,0};
		String[] copyNoAR = Factory.getInstance().getSysParameter("OPSTAR").split(",");
		String[] copyNoCash = Factory.getInstance().getSysParameter("OPSTCASH").split(","); 		
		int[] CopyNoSetAR = new int[copyNoAR.length];
		int[] CopyNoSetCash = new int[copyNoCash.length];
		
		for(int i = 0; i < 3; i++) {
			CopyNoSetAR[i] = Integer.parseInt(copyNoAR[i]);
			CopyNoSetCash[i] = Integer.parseInt(copyNoCash[i]);
		}
		
		if (isReprint || !memIsReprint) {
			CopyNoSet[0] = 1;
		//} else if (!isDirBillWfPatPay&&isAR) {
		} else if (isAR) {
			CopyNoSet = CopyNoSetAR;
		} else {
			CopyNoSet = CopyNoSetCash;
		}

		return CopyNoSet;
	}

	private String[] getOPStatementColNameSet() {
		return new String[] {
				"SLPNO",
				"PATNO",
				"PATNAME",
				"PATCNAME",
				"DOCNAME",
				"DOCCNAME",
				"TITLE"
		};
	}

	private String[][] getOPStatementSubColNameSet() {
		return new String[][] {
				{
					"STNTDATE",
					"AMOUNT",
					"DESCRIPTION",
					"QTY",
					"ITMFLAG",
					"CDESCCODE"
				},
				{
					"ARCODE",
					"ARDESC",
					"ARAMOUNT",
					"SLPPLYNO",
					"SLPVCHNO"
				},
				{
					"DIAGNOSIS","DOCCODE","DOCNAME",
					"ECERT1","ECERT2","ECERT3","ECERT4","ECERT5",
					"ECERT6","ECERT7","ECERT8","ECERT9","ECERT10",
					"PROCEDURES","STECODE"
				}};
	}

	private boolean[][] getOPStatementSubNumericSet() {
		return new boolean[][] {
				{
					false,
					true,
					false,
					true,
					false,
					false
				},
				{
					false,
					false,
					true,
					false,
					false
				},
				{
					false,false,false,
					false,false,false,false,false,
					false,false,false,false,false,
					false,false
				}};
	}

	private String[][] getOPStatementSubParamSet() {
		return new String[][] {{ getAllSlip(true) },
							   { getAllSlip(true)},
							   {getSlpNo().getText(),getDiagYesOpt().isSelected()?"Y":"N"}};
	}

	private void printOPStatement(boolean signature, boolean copy, boolean reprint) {
		String paperSize = Factory.getInstance().getSysParameter("OpPageSize");
		String opStmtSite = Factory.getInstance().getSysParameter("OpStmtSite");
		String printerName = "";
		if (paperSize != null && paperSize.length() > 0) {
			printerName = "HATS_" + paperSize;
		}

		if (Factory.getInstance().getSysParameter("SHOWSIGN").equals("Y") &&
			Factory.getInstance().getSysParameter("ArSignMeth").equals("A")
			//&& !reprint
			//&&memIsReprint
			//&& isAR
			) {
			Map<String,Map<String,String>> mapBatchMap = new HashMap<String,Map<String,String>>();
			mapBatchMap.put("1", getOPStatementParamSet(signature, copy,memIsReprint));
			mapBatchMap.put("2", getOPStatementParamSet(false, (!isDirBilWfPatPay&&isAR),memIsReprint));
			mapBatchMap.put("3", getOPStatementParamSet(false, true,memIsReprint));

			Map<Integer, String[]> subRptNameMap = new HashMap<Integer, String[]>();
			subRptNameMap.put(0, new String[] { "OPSTATEMENT_SUB", "AR_BILL","OP_DIAGNOSIS" });
			subRptNameMap.put(1, new String[] { "OPSTATEMENT_SUB", "AR_BILL","OP_DIAGNOSIS" });
			subRptNameMap.put(2, new String[] { "OPSTATEMENT_SUB", "AR_BILL","OP_DIAGNOSIS" });

			Map<Integer, String[][]> sub_dbParamMap = new HashMap<Integer, String[][]>();
			sub_dbParamMap.put(0, getOPStatementSubParamSet());
			sub_dbParamMap.put(1, getOPStatementSubParamSet());
			sub_dbParamMap.put(2, getOPStatementSubParamSet());

			Map<Integer, String[][]> sub_colNameMap = new HashMap<Integer, String[][]>();
			sub_colNameMap.put(0, getOPStatementSubColNameSet());
			sub_colNameMap.put(1, getOPStatementSubColNameSet());
			sub_colNameMap.put(2, getOPStatementSubColNameSet());

			Map<Integer, boolean[][]>isNumericColMap = new HashMap<Integer, boolean[][]>();
			isNumericColMap.put(0, getOPStatementSubNumericSet());
			isNumericColMap.put(1, getOPStatementSubNumericSet());
			isNumericColMap.put(2, getOPStatementSubNumericSet());

			if (memIsPreview) {
				Report.print(getUserInfo(),
						"OPStatement", getOPStatementParamSet(signature, copy,false),
						new String[] {
								getMemSlipNo()
						},
						getOPStatementColNameSet(),
						new boolean[] {
								false, false, false, false, false, false, false
						},
						new String[] {
								"OPSTATEMENT_SUB", "AR_BILL","OP_DIAGNOSIS"
						},
						getOPStatementSubParamSet(),
						getOPStatementSubColNameSet(),
						getOPStatementSubNumericSet(), "", true, false, true, false, null, null, null, false);
			} else {
				PrintingUtil.printBatch(
						printerName,
						new String[] {
								"OPStatement", "OPStatement", "OPStatement"
						},
						mapBatchMap, null,
						new String[][] { //inparam
							new String[] {
									getMemSlipNo()
							},
							new String[] {
									getMemSlipNo()
							},
							new String[] {
									getMemSlipNo()
							}
						},
						new String[][] {
								getOPStatementColNameSet(),
								getOPStatementColNameSet(),
								getOPStatementColNameSet()
						},
						new int[] { 3, 3, 3 },
						subRptNameMap, sub_dbParamMap, sub_colNameMap, isNumericColMap, null, null,
						null, null, null, null,
						getOPStatementCopyNoSet(reprint,isDirBilWfPatPay,isAR),
						new String[] {
								Factory.getInstance().getSysParameter("OpPageSize"),
								Factory.getInstance().getSysParameter("OpPageSize"),
								Factory.getInstance().getSysParameter("OpPageSize")
						},
						Factory.getInstance().getSysParameter("OpPageOrie"), true);
			}
		} else if ("A5".equals(paperSize)) {
			if (memIsPreview) {
				Report.print(getUserInfo(),
						"OPStatement", getOPStatementParamSet(signature, copy,false),
						new String[] {
								getMemSlipNo()
						},getOPStatementColNameSet(),
						new boolean[] {
								false, false, false, false, false, false, false
						},
						new String[] {
								"OPSTATEMENT_SUB",
						},
						new String[][] {{ getAllSlip(true) }},
						new String[][] {
								{
									"STNTDATE",
									"AMOUNT",
									"DESCRIPTION",
									"QTY",
									"ITMFLAG",
									"CDESCCODE"
								}
						},
						new boolean[][] {
								{
									false,
									true,
									false,
									true,
									false,
									false
								}
						}, Factory.getInstance().getSysParameter("OpPageSize"),
						true, false, true, false, null, null, null, false);
			} else {
				PrintingUtil.print(printerName,
						(!"".equals(opStmtSite)?opStmtSite:"")+"OPStatement", getOPStatementParamSet(signature, copy,false), null,
						new String[] {
								getMemSlipNo()
						},
						getOPStatementColNameSet(),
						1,
						new String[] {
								"OPSTATEMENT_SUB",
						},
						new String[][] {{ getAllSlip(true) }},
						new String[][] {
								{
									"STNTDATE",
									"AMOUNT",
									"DESCRIPTION",
									"QTY",
									"ITMFLAG",
									"CDESCCODE"
								}
						},
						new boolean[][] {
								{
									false,
									true,
									false,
									true,
									false,
									false
								}
						}, 1, Factory.getInstance().getSysParameter("OpPageSize"),
						Factory.getInstance().getSysParameter("OpPageOrie"));
			}
		} else {
			if (memIsPreview) {
				Report.print(getUserInfo(),
						"OPStatement", getOPStatementParamSet(signature, copy,false),
						new String[] {
								getMemSlipNo()
						},
						getOPStatementColNameSet(),
						new boolean[] {
								false, false, false, false, false, false, false
						},
						new String[] {
								"OPSTATEMENT_SUB","AR_BILL","OP_DIAGNOSIS"
						},
						getOPStatementSubParamSet(),
						getOPStatementSubColNameSet(),
						getOPStatementSubNumericSet(), "", true, false, true, false, null, null, null, false);
			} else {
				PrintingUtil.print(printerName,
						"OPStatement", getOPStatementParamSet(signature, copy,false), null,
						new String[] {
								getMemSlipNo()
						},
						getOPStatementColNameSet(),
						3,
						new String[] {
								"OPSTATEMENT_SUB","AR_BILL","OP_DIAGNOSIS"
						},
						getOPStatementSubParamSet(),
						getOPStatementSubColNameSet(),
						getOPStatementSubNumericSet(),
						1, Factory.getInstance().getSysParameter("OpPageSize"),
						Factory.getInstance().getSysParameter("OpPageOrie"));
			}
		}
/*
		if (Factory.getInstance().getSysParameter("SHOWSIGN").equals("Y")) {
			if (Factory.getInstance().getSysParameter("ArSignMeth").equals("A") && !reprint &&
					memIsReprint && isAR) {
				printOPStatement(false, true, true);
			}
		}
*/		if (memIsPreview) {
			memIsPreview = false;
		} else if (memIsReprint) {
			showDlgReprintRpt();
		} else {
			unlockSlips();
		}
	}

	/***************************************************************************
	 * Dialog Method
	 **************************************************************************/

	private void showDlgReprintRpt() {
		if (dlgReprintRpt == null) {
			dlgReprintRpt = new DlgReprintRpt(getMainFrame(), "OP/Day Case Statement") {
				@Override
				public void reprint() {
					if (Factory.getInstance().getSysParameter("SHOWSIGN").equals("Y")) {
						if (Factory.getInstance().getSysParameter("ArSignMeth").equals("A")) {
							printOPStatement(false, getCopyYesOpt().isSelected(), true);
						} else {
							printOPStatement(getSignYesOpt().isSelected(), getYesOpt().isSelected(), true);
						}
					} else {
						printOPStatement(false, getYesOpt().isSelected(), true);
					}

					dispose();
					showDlgReprintRpt();
				}

				@Override
				protected void doNoAction() {
					super.doNoAction();
					unlockSlips();
				}

				@Override
				public void showDialog(boolean copyOpt, String parameter[]) {
					if (copyOpt) {
						getCopyDesc().show();
						getCopyYesOpt().show();
						getCopyNoOpt().show();
						getCopyYesOpt().setSelected(true);
					}
					else {
						getCopyDesc().hide();
						getCopyYesOpt().hide();
						getCopyNoOpt().hide();
					}
					getCopyNoOpt().setSelected(isDirBilWfPatPay);
					setParameter(parameter);
					layout();
					setVisible(true);
					setFocusWidget(getButtonById(NO));
				}
			};
			dlgReprintRpt.setResizable(false);
		}

		if (Factory.getInstance().getSysParameter("SHOWSIGN").equals("Y")) {
			if (Factory.getInstance().getSysParameter("ArSignMeth").equals("A")) {
				dlgReprintRpt.showDialog(true, null);
			} else {
				dlgReprintRpt.showDialog();
			}
		} else {
			dlgReprintRpt.showDialog();
		}
		dlgReprintRpt.setZIndex(20000);
		dlgReprintRpt.focus();
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getOPOfficePanel() {
		if (OPOfficePanel == null) {
			OPOfficePanel = new BasePanel();
			OPOfficePanel.setBounds(5, 5, 460, 360);
			OPOfficePanel.add(getSlipPanel(), null);
			OPOfficePanel.add(getCopyPanel(), null);
		}
		return OPOfficePanel;
	}

	private BasePanel getCopyPanel() {
		if (copyPanel == null) {
			copyPanel = new BasePanel();
			copyPanel.setBounds(5, 205, 450, 150);
			copyPanel.setBorders(true);
			copyPanel.add(getCopyDesc(), null);
			copyPanel.add(getYesOpt(), null);
			copyPanel.add(getNoOpt(), null);

			if ("Y".equals(Factory.getInstance().getSysParameter("SHOWSIGN"))) {
				copyPanel.add(getSignDesc(), null);
				copyPanel.add(getSignYesOpt(), null);
				copyPanel.add(getSignNoOpt(), null);
			} else if ("Y".equals(Factory.getInstance().getSysParameter("SHOWDGNS"))) {
				copyPanel.add(getRmkTxtDesc(), null);
				copyPanel.add(getRemarkTextArea(), null);
			}
			if (HKAH_VALUE.equals(getUserInfo().getSiteCode())) {
				copyPanel.add(getDiagDesc(), null);
				copyPanel.add(getDiagYesOpt(), null);
				copyPanel.add(getDiagNoOpt(), null);
			}
		}
		return copyPanel;
	}
	
	private DlgAppBillType getDlgAppBillType(){
		if (dlgAppBillType  == null) {
			dlgAppBillType = new DlgAppBillType(getMainFrame()) {
				@Override
				public  void doPostToApp() {
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
														createAppBill(true, dlgAppBillType.getRemark().getText(), dlgAppBillType.getAppBillType().getText());
													} 
												}
											});
										}
									} else {
										createAppBill(true, dlgAppBillType.getRemark().getText(), dlgAppBillType.getAppBillType().getText());

									}
								} catch (Exception e) {
								}
							}
						}
					});
					dlgAppBillType.setVisible(false);
				}
				public void doPreview(){
					Map<String,String> map = getOPStatementParamSet(false, true,false);
					map.put("remark", getRemark().getText());
					String result = AppStmtUtil.previewOPStatement(getMemSlipNo(), getRemark().getText(), map);
					

				}
			};
		}
		return dlgAppBillType;
	}
	
	protected ButtonBase getCreateABills() {
		if (createAppBills == null) {
			createAppBills = new ButtonBase() {
				@Override
				public void onClick() {
					getDlgAppBillType().showDialog(memReportType, getParameter("PatNo"));
				}
			};
			createAppBills.setText("Post to App");
		}
		return createAppBills;
	}
	
	private void createAppBill(boolean isCreateBill, final String remark, String stmtType) {
		if(isCreateBill) {
			QueryUtil.executeMasterAction(getUserInfo(), "APPBILL_SLIP", QueryUtil.ACTION_APPEND,
					new String[] {getMemSlipNo(),stmtType, remark,"N",  getUserInfo().getUserID()},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						Factory.getInstance().addInformationMessage("Post Succeed.");
						Map<String,String> map = getOPStatementParamSet(false, true,false);
						map.put("remark", remark);
						final String billID = mQueue.getReturnCode();
						AppStmtUtil.genOPStatement(getMemSlipNo(), billID, remark, map, getParameter("PatNo"));

					} else {
						//Factory.getInstance().addErrorMessage(mQueue, getPkgCode());
					}
				}
			});
		}
	}
	

	private LabelBase getCopyDesc() {
		if (copyDesc == null) {
			copyDesc = new LabelBase();
			copyDesc.setText("Is it a copy?");
			copyDesc.setBounds(30, 10, 120, 20);
		}
		return copyDesc;
	}

	private RadioButtonBase getYesOpt() {
		if (yesOpt == null) {
			yesOpt = new RadioButtonBase(){
				@Override
				  public void setValue(Boolean value) {
					super.setValue(value);
					if (HKAH_VALUE.equals(getUserInfo().getSiteCode())) {
						getDiagNoOpt().setSelected(value);
					}
				}
			};
			yesOpt.setText("Yes");
			yesOpt.setBounds(160, 10, 180, 20);
		}
		return yesOpt;
	}

	private RadioButtonBase getNoOpt() {
		if (noOpt == null) {
			noOpt = new RadioButtonBase(){
				@Override
				  public void setValue(Boolean value) {
					super.setValue(value);
					if (HKAH_VALUE.equals(getUserInfo().getSiteCode())) {
						if(isDiagAlert) {
							getDiagNoOpt().setSelected(true);
						} else {
							getDiagYesOpt().setSelected(value);
						}
					}
				}
			};
			noOpt.setText("No");
			noOpt.setSelected(true);
			noOpt.setBounds(160, 35, 180, 20);
		}
		return noOpt;
	}

	private LabelBase getSignDesc() {
		if (signDesc == null) {
			signDesc = new LabelBase();
			signDesc.setText("Print Signature?");
			signDesc.setBounds(30, 60, 110, 20);
		}
		return signDesc;
	}

	private RadioButtonBase getSignYesOpt() {
 		if (signYesOpt == null) {
			signYesOpt = new RadioButtonBase();
			signYesOpt.setText("Yes");
			signYesOpt.setBounds(160, 60, 170, 20);
		}
		return signYesOpt;
	}

	private RadioButtonBase getSignNoOpt() {
		if (signNoOpt == null) {
			signNoOpt = new RadioButtonBase();
			signNoOpt.setText("No");
			signNoOpt.setSelected(true);
			signNoOpt.setBounds(160, 85, 170, 20);
		}
		return signNoOpt;
	}
	
	private LabelBase getDiagDesc() {
		if (diagDesc == null) {
			diagDesc = new LabelBase();
			diagDesc.setText("Print Diagnosis/Procedure?");
			diagDesc.setBounds(5, 110, 180, 20);
		}
		return diagDesc;
	}
	
	private RadioButtonBase getDiagYesOpt() {
		if (diagYesOpt == null) {
			diagYesOpt = new RadioButtonBase();
			diagYesOpt.setText("Yes");
			diagYesOpt.setBounds(160, 110, 200, 20);
		}
		return diagYesOpt;
	}

	private RadioButtonBase getDiagNoOpt() {
		if (diagNoOpt == null) {
			diagNoOpt = new RadioButtonBase();
			diagNoOpt.setText("No");
			diagNoOpt.setBounds(160, 130, 200, 20);
		}
		return diagNoOpt;
	}

	private LabelBase getRmkTxtDesc() {
		if (rmkTxtDesc == null) {
			rmkTxtDesc = new LabelBase();
			rmkTxtDesc.setText(Factory.getInstance().getSysParameter("SHOWDGNS"));
			rmkTxtDesc.setBounds(30, 70, 120, 20);
		}
		return rmkTxtDesc;
	}

	private TextAreaBase getRemarkTextArea() {
		if (remarkTextArea == null) {
			remarkTextArea = new TextAreaBase(false);
			remarkTextArea.setEditable(true);
			remarkTextArea.setMaxLength(2000);
			remarkTextArea.setBounds(150, 70, 280, 60);
		}
		return remarkTextArea;
	}
}