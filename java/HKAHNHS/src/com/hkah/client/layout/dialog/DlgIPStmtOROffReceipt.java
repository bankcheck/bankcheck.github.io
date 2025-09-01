package com.hkah.client.layout.dialog;

import java.util.HashMap;
import java.util.Map;

import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.form.RadioGroup;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.radiobutton.RadioButtonBase;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.PrintingUtil;

public class DlgIPStmtOROffReceipt extends DialogSlipBase {
	private final static int m_frameWidth = 500;
	private final static int m_frameHeight = 430;

	private BasePanel IPOfficePanel = null;
	private BasePanel midPanel = null;
	private BasePanel stmtPanel = null;
	private LabelBase isCopyDesc = null;
	private RadioButtonBase yesOpt = null;
	private RadioButtonBase noOpt = null;
	private LabelBase selectStmtLabel = null;
	private CheckBoxBase ipStmt = null;
	private LabelBase ipStmtDesc = null;
	private CheckBoxBase ipStmtSum = null;
	private LabelBase ipStmtSumDesc = null;
	private DlgReprintRpt reprintReceiptDialog = null;
	private DlgReprintRpt reprintStmtSmyDialog = null;
	private DlgReprintRpt reprintStmtDialog = null;

	private boolean memIsReprint = false;
	private String printType = null;

	public DlgIPStmtOROffReceipt(MainFrame owner) {
		super(owner, YESNOCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Print which report?");
		setContentPane(getIPOfficePanel());

		// change label
		getButtonById(NO).setText("Save", 'S');

		RadioGroup btngrp = new RadioGroup();
		btngrp.add(getYesOpt());
		btngrp.add(getNoOpt());

		// layout
		getSlipPanel().setBounds(5, 85, 450, 185);
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	@Override
	public Component getDefaultFocusComponent() {
		return getIpStmt();
	}

	public void showDialog(String slpNo, String slpType, boolean isReprint, String rptLang) {
		setMemSlipNo(slpNo);
		setMemSlipType(slpType);
		memIsReprint = isReprint;

		clearSlipField();

		setLanguage(rptLang);

		getIpStmt().setSelected(true);
		getIpStmtSum().setSelected(true);
		getNoOpt().setSelected(true);

		loadOldSlipNo();

		setVisible(true);
	}

	private void printReceipt(String rptName) {
		Map<String,String> map = new HashMap<String,String>();
		map.put("SUBREPORT_DIR", CommonUtil.getReportDir());
		map.put("P_SLPNO", getSlpNo().getText() );
		map.put("ALLSLPNO", getAllSlip(true) );
		map.put("ISCOPY", getYesOpt().isSelected()?"Y":"");
		map.put("DOCBKGCPY",Factory.getInstance().getSysParameter("DOCBKGCPY"));
		map.put("watermark", CommonUtil.getReportImg("copy_watermark.gif"));
		Factory.getInstance()
			.addRequiredReportDesc(map,
					new String[] {
							"MapLanguage", "MapLanguage", "MapLanguage",
							"MapLanguage", "MapLanguage", "MapLanguage",
							"MapLanguage", "MapLanguage", "MapLanguage",
							"MapLanguage", "MapLanguage"
					},
					new String[] {
							"receipt", "BillNo", "PatName", "AdmDtTime",
							"DisDtTime", "TreDr", "PatNo", "BedNo", "Copy",
							"Page", "TotReceipt"
					},
					getLanguage());

		String paperSize = "A4";
		String printerName = "";

		if ("DayCaseReceipt".equals(rptName)) {
			Factory.getInstance()
			.addRequiredReportDesc(map,new String[] {"MapLanguage"},new String[] {"Date"},getLanguage());
			paperSize = Factory.getInstance().getSysParameter("DCPageSize");
			if (paperSize != null && paperSize.length() > 0) {
				printerName = "HATS_"+paperSize;
			}
		}

		if (PrintingUtil.print(
				printerName, rptName, map, null,
				new String[] {
						getMemSlipNo()
				},
				new String[] {
						"PATNAME", "PATCNAME", "SLPNO",
						"PATNO", "REGDATE", "REGTIME",
						"BEDACM", "INPDDATE", "INPDTIME",
						"DOCNAME", "DOCCNAME"
				},
				1,
				new String[] {
						"IPRECEIPT_SUB"
				},
				new String[][] {
						{
								getAllSlip(true)
						}
				},
				new String[][] {
						{
								"STNTDATE", "AMOUNT",
								"DESCRIPTION", "CDESCCODE"
						}
				},
				new boolean[][] {
						{
								false, true, false,
								false
						}
				}, 1, paperSize) && !memIsReprint) {
			}

		if (memIsReprint) {
			showReprintReceiptDialog();
		} else {
			unlockSlips();
		}
	}

	private void printIPReceiptMB() {
		//Factory.getInstance().addErrorMessage("printIPReceiptMB();");

		Map<String,String> map = new HashMap<String,String>();
		map.put("SUBREPORT_DIR", CommonUtil.getReportDir());
		map.put("P_SLPNO", getSlpNo().getText() );
		map.put("ALLSLPNO", getAllSlip(true) );
		map.put("ISCOPY", getYesOpt().isSelected()?"Y":"");
		map.put("DOCBKGCPY",Factory.getInstance().getSysParameter("DOCBKGCPY"));
		map.put("watermark", CommonUtil.getReportImg("copy_watermark.gif"));
		Factory.getInstance().addRequiredReportDesc(map,
				new String[] {
						"MapLanguage", "MapLanguage", "MapLanguage",
						"MapLanguage", "MapLanguage", "MapLanguage",
						"MapLanguage", "MapLanguage", "MapLanguage",
						"MapLanguage", "MapLanguage", "MapLanguage",
						"MapLanguage", "MapLanguage", "MapLanguage"
				},
				new String[] {
						"receipt", "BillNo", "PatName", "AdmDtTime",
						"DisDtTime", "TreDr", "PatNo", "BedNo", "Copy",
						"Page", "TotReceipt", "patM", "patB", "DelDr",
						"BirthDt"
				},
				getLanguage());

		if (PrintingUtil.print("IPReceiptMB", map, null,
				new String[] {getMemSlipNo(), getAllSlip(false)},
				new String[] {"MB", "PATNAME", "PATCNAME", "SLPNO", "PATNO",
				"REGDATE", "REGTIME", "BEDACM", "INPDDATE", "INPDTIME", "DOCNAME", "DOCCNAME"},
				1,new String[] {"IPRECEIPTMB_SUB"}, new String[][] {{getMemSlipNo(), getAllSlip(false)}},
				new String[][] {{"MB", "STNTDATE", "DESCRIPTION", "AMOUNT", "CDESCCODE"}},
				new boolean[][] {{false,false,false,true,false}}) && !memIsReprint) {
		}

		if (memIsReprint) {
			showReprintReceiptDialog();
		} else {
			unlockSlips();
		}
	}
/*
	protected void validation() {
		if (!getIpStmt().isSelected() && !getIpStmtSum().isSelected()) {
			Factory.getInstance().addErrorMessage("You must select one report.");
			return;
		}
		super.validation();
	}
*/
	@Override
	public void isImplementMBReady(int i) {
		super.isImplementMBReady(i);
		int iTemp = i;
		if (iTemp == 1) {
			if (printType.equals("receipt")) {
				printIPReceiptMB();
			} else if (printType.equals("stmtsum")) {
				printChrgSmyMB();
			} else if (printType.equals("stmt")) {
				printIPStatementMB();
			}
		} else if (iTemp == 2) {
			if (printType.equals("receipt")) {
				printReceipt("IPReceipt");
			} else if (printType.equals("stmtsum")) {
				printChrgSmy();
			} else if (printType.equals("stmt")) {
				printIPStatement();
			}
		}
	}

	@Override
	protected void printReport() {
		printType = "receipt";
		if ("I".equals(getMemSlipType())) {
			isImplementMB(getUserInfo(), getMemSlipNo(),
					getMergeWith1().getText(), getMergeWith2().getText(), getMergeWith3().getText(), getMergeWith4().getText(), getMergeWith5().getText(),
					getMergeWith6().getText(), getMergeWith7().getText(), getMergeWith8().getText(), getMergeWith9().getText(), getMergeWith10().getText());
		} else if ("D".equals(getMemSlipType())) {
			printReceipt("DayCaseReceipt");
		}
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getIPOfficePanel() {
		if (IPOfficePanel == null) {
			IPOfficePanel = new BasePanel();
			IPOfficePanel.setBounds(5, 5, 460, 420);
			IPOfficePanel.add(getStmtPanel(), null);
			IPOfficePanel.add(getSlipPanel(), null);
			IPOfficePanel.add(getMidPanel(), null);
		}
		return IPOfficePanel;
	}

	public BasePanel getStmtPanel() {
		if (stmtPanel == null) {
			stmtPanel = new BasePanel();
			stmtPanel.setBorders(true);
			stmtPanel.setBounds(5, 5, 450, 70);
			stmtPanel.add(getSelectStmtLabel(), null);
			stmtPanel.add(getIpStmt(), null);
			stmtPanel.add(getIpStmtDesc(), null);
			stmtPanel.add(getIpStmtSum(), null);
			stmtPanel.add(getIpStmtSumDesc(), null);
		}
		return stmtPanel;
	}

	public LabelBase getSelectStmtLabel() {
		if (selectStmtLabel == null) {
			selectStmtLabel = new LabelBase();
			selectStmtLabel.setBounds(20, 10, 160, 20);
			selectStmtLabel.setText("Report to be printed:");
		}
		return selectStmtLabel;
	}

	public CheckBoxBase getIpStmt() {
		if (ipStmt == null) {
			ipStmt = new CheckBoxBase();
			ipStmt.setBounds(200, 10, 24, 20);
			ipStmt.setSelected(false);
			ipStmt.setValue(true);
		}
		return ipStmt;
	}

	public LabelBase getIpStmtDesc() {
		if (ipStmtDesc == null) {
			ipStmtDesc = new LabelBase();
			ipStmtDesc.setBounds(225, 10, 80, 20);
			ipStmtDesc.setText("IP Statement");
		}
		return ipStmtDesc;
	}

	public CheckBoxBase getIpStmtSum() {
		if (ipStmtSum == null) {
			ipStmtSum = new CheckBoxBase();
			ipStmtSum.setBounds(200, 30, 24, 20);
			ipStmtSum.setValue(true);
		}
		return ipStmtSum;
	}

	public LabelBase getIpStmtSumDesc() {
		if (ipStmtSumDesc == null) {
			ipStmtSumDesc = new LabelBase();
			ipStmtSumDesc.setBounds(225, 30, 160, 20);
			ipStmtSumDesc.setText("IP Statement (Summary)");
		}
		return ipStmtSumDesc;
	}

	public BasePanel getMidPanel() {
		if (midPanel == null) {
			midPanel = new BasePanel();
			midPanel.setBorders(true);
			midPanel.setBounds(5, 280, 450, 60);
			midPanel.add(getIsCopyDesc(), null);
			midPanel.add(getYesOpt(), null);
			midPanel.add(getNoOpt(), null);
		}
		return midPanel;
	}

	public LabelBase getIsCopyDesc() {
		if (isCopyDesc == null) {
			isCopyDesc = new LabelBase();
			isCopyDesc.setBounds(20, 10, 100, 20);
			isCopyDesc.setText("Is it a copy?");
		}
		return isCopyDesc;
	}

	public RadioButtonBase getYesOpt() {
		if (yesOpt == null) {
			yesOpt = new RadioButtonBase();
			yesOpt.setText("Yes");
			yesOpt.setBounds(130, 10, 200, 20);
		}
		return yesOpt;
	}

	public RadioButtonBase getNoOpt() {
		if (noOpt == null) {
			noOpt = new RadioButtonBase();
			noOpt.setText("No");
			noOpt.setBounds(130, 35, 200, 20);
			noOpt.setSelected(true);
		}
		return noOpt;
	}

	public void showReprintReceiptDialog() {
		if (reprintReceiptDialog == null) {
			reprintReceiptDialog = new DlgReprintRpt(getMainFrame(), "IP Official Receipt") {
				@Override
				public void reprint() {
					printReport();
				}

				@Override
				public void postAction() {
					printStmtSumRpt();

				}
			};
			reprintReceiptDialog.setResizable(false);
		}
		reprintReceiptDialog.showDialog();
		reprintReceiptDialog.setZIndex(20000);
	}

	public void showReprintStmtSumDialog() {
		if (reprintStmtSmyDialog == null) {
			reprintStmtSmyDialog = new DlgReprintRpt(getMainFrame(), "IP Statement of Account (Summary)") {
				@Override
				public void reprint() {
					printStmtSumRpt();
				}

				@Override
				public void postAction() {
					printStmtRpt();
				}
			};
			reprintStmtSmyDialog.setResizable(false);
		}
		reprintStmtSmyDialog.showDialog();
		reprintStmtSmyDialog.setZIndex(20000);
	}

	public void showReprintStmtDialog() {
		if (reprintStmtDialog == null) {
			reprintStmtDialog = new DlgReprintRpt(getMainFrame(), "IP Statement of Account") {
				@Override
				public void reprint() {
					printStmtRpt();
				}

				@Override
				public void postAction() {
					unlockSlips();
				}
			};
			reprintStmtDialog.setResizable(false);
		}
		reprintStmtDialog.showDialog();
		reprintStmtDialog.setZIndex(20000);
	}

	public void printStmtSumRpt() {
		if (getIpStmtSum().getValue()) {
			printType = "stmtsum";
			isImplementMB(
					getUserInfo(),
					getMemSlipNo(),
					getMergeWith1().getText(),
					getMergeWith2().getText(),
					getMergeWith3().getText(),
					getMergeWith4().getText(),
					getMergeWith5().getText(),
					getMergeWith6().getText(),
					getMergeWith7().getText(),
					getMergeWith8().getText(),
					getMergeWith9().getText(),
					getMergeWith10().getText());
		} else {
			printStmtRpt();
		}
	}

	public void printStmtRpt() {
		if (getIpStmt().getValue()) {
			printType = "stmt";
			isImplementMB(
					getUserInfo(),
					getMemSlipNo(),
					getMergeWith1().getText(),
					getMergeWith2().getText(),
					getMergeWith3().getText(),
					getMergeWith4().getText(),
					getMergeWith5().getText(),
					getMergeWith6().getText(),
					getMergeWith7().getText(),
					getMergeWith8().getText(),
					getMergeWith9().getText(),
					getMergeWith10().getText());
		} else {
			unlockSlips();
		}
	}

	private void printChrgSmyMB() {
		Map<String,String> map = new HashMap<String,String>();
		map.put("SUBREPORT_DIR", CommonUtil.getReportDir());
		map.put("P_SLPNO", getSlpNo().getText() );
		map.put("ALLSLPNO", getAllSlip(true) );
		map.put("ISCOPY", getYesOpt().isSelected()?"Y":"");
		map.put("DOCBKGCPY",Factory.getInstance().getSysParameter("DOCBKGCPY"));
		map.put("watermark", CommonUtil.getReportImg("copy_watermark.gif"));
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

		if (PrintingUtil.print("", "ChrgSmyMB", map, null,
								new String[] {
									getMemSlipNo(), getAllSlip(false)
								},
								new String[] {
										"MB", "PATNAME", "PATCNAME", "SLPNO",
										"PATNO", "REGDATE", "REGTIME",
										"BEDACM", "INPDDATE", "INPDTIME",
										"DOCNAME", "DOCCNAME",
										"BEDCODE", "ACMNAME"
								},
								1,
								new String[] {
										"CHRGSMYMB_SUB"
								},
								new String[][] {
										{
											"'"+getSlpNo().getText()+"'",
											getAllSlip(false),
											""
										}
								},
								new String[][] {
										{
											"DESCRIPTION", "QTY",
											"AMOUNT", "STNTYPE",
											"ITMTYPE", "DOCCODE",
											"DOCNAME", "DOCCNAME",
											"CDESCCODE"
										}
								},
								new boolean[][] {
										{
											false, true, false,
											false, false, false,
											false, false, false
										}
								}, 1) && !memIsReprint) {
/*
			unlockSlips();
*/
		}

		if (memIsReprint) {
			showReprintStmtSumDialog();
		} else {
			unlockSlips();
		}
	}

	private void printChrgSmy() {
		Map<String,String> map = new HashMap<String,String>();
		map.put("SUBREPORT_DIR", CommonUtil.getReportDir());
		map.put("P_SLPNO", getSlpNo().getText() );
		map.put("ALLSLPNO", getAllSlip(true) );
		map.put("ISCOPY", getYesOpt().isSelected()?"Y":"");
		map.put("DOCBKGCPY",Factory.getInstance().getSysParameter("DOCBKGCPY"));
		map.put("watermark", CommonUtil.getReportImg("copy_watermark.gif"));
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

		if (PrintingUtil.print("", "ChrgSmy",
				map, null, new String[] { getMemSlipNo() },
				new String[] {
								"PATNAME", "PATCNAME", "SLPNO", "PATNO",
								"REGDATE", "REGTIME", "BEDACM", "INPDDATE",
								"INPDTIME", "DOCNAME", "DOCCNAME"
				}, 1,
				new String[] { "CHRGSMY_SUB" },
				new String[][] {
									{ getAllSlip(true), "" }
				},
				new String[][] {
									{ "DESCRIPTION", "QTY", "AMOUNT", "STNTYPE", "ITMTYPE",
									  "DOCCODE", "DOCNAME", "DOCCNAME", "CDESCCODE" }
				},
				new boolean[][] {
									{ false, true, false, false, false, false, false, false, false }
				}, 1) && !memIsReprint) {
		}

		if (memIsReprint) {
			showReprintStmtSumDialog();
		} else {
			unlockSlips();
		}
	}

	private void printIPStatementMB() {
		Map<String,String> map = new HashMap<String,String>();
		map.put("SUBREPORT_DIR", CommonUtil.getReportDir());
		map.put("P_SLPNO", getSlpNo().getText() );
		map.put("ALLSLPNO", getAllSlip(true) );
		map.put("ISCOPY", getYesOpt().isSelected()?"Y":"");
		map.put("DOCBKGCPY",Factory.getInstance().getSysParameter("DOCBKGCPY"));
		map.put("watermark", CommonUtil.getReportImg("copy_watermark.gif"));
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

		if (PrintingUtil.print("", "IPStatementMB",map, "",
				new String[] {getMemSlipNo(), getAllSlip(false)},
				new String[] {"MB", "PATNAME", "PATCNAME", "SLPNO", "PATNO",
				"REGDATE", "REGTIME", "BEDACM", "INPDDATE", "INPDTIME", "DOCNAME", "DOCCNAME"},
				1,new String[] {"IPStatement_Sub1"},
				new String[][] {{getAllSlip(true), ""}},
				new String[][] {{"STNTDATE", "AMOUNT", "DESCRIPTION", "QTY", "TOTALREFUND", "TOTALCHARGE", "CDESCCODE"}},
				new boolean[][] {{false,true,false,true, true, true, false}}, 1)
				&& !memIsReprint) {
		}

		if (memIsReprint) {
			showReprintStmtDialog();
		} else {
			unlockSlips();
		}
	}

	private void printIPStatement() {
		Map<String,String> map = new HashMap<String,String>();
		map.put("SUBREPORT_DIR", CommonUtil.getReportDir());
		map.put("P_SLPNO", getSlpNo().getText() );
		map.put("ALLSLPNO", getAllSlip(true) );
		map.put("ISCOPY", getYesOpt().isSelected()?"Y":"");
		map.put("DOCBKGCPY",Factory.getInstance().getSysParameter("DOCBKGCPY"));
		map.put("watermark", CommonUtil.getReportImg("copy_watermark.gif"));
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

		if (PrintingUtil.print("", "IPStatement", map,"",
				new String[] {getMemSlipNo()},
				new String[] {"PATNAME", "PATCNAME", "SLPNO", "PATNO", "REGDATE",
				"REGTIME", "BEDACM", "INPDDATE", "INPDTIME", "DOCNAME", "DOCCNAME"},
				2,new String[] {"IPStatement_Sub1", "IPStatement_Sub2"} ,
				new String[][] {{getAllSlip(true), ""}, {getAllSlip(true), ""}},
				new String[][] {{"STNTDATE", "AMOUNT", "DESCRIPTION", "QTY", "TOTALREFUND", "TOTALCHARGE", "CDESCCODE"},
				{"ARCCODE", "ARCNAME", "ATXAMT"}},
				new boolean[][] {{false,true,false,true, true, true, false},
				{false, false, true}}, 1) && !memIsReprint) {
		}

		if (memIsReprint) {
			showReprintStmtDialog();
		} else {
			unlockSlips();
		}
	}
}