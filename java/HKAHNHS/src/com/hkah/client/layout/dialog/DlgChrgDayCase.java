package com.hkah.client.layout.dialog;

import java.util.HashMap;
import java.util.Map;

import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.form.RadioGroup;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.radiobutton.RadioButtonBase;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.Report;

public class DlgChrgDayCase extends DialogSlipBase {
	private final static int m_frameWidth = 500;
	private final static int m_frameHeight = 370;

	private BasePanel OPOfficePanel = null;
	private RadioButtonBase yesOpt = null;
	private RadioButtonBase noOpt = null;
	private LabelBase copyDesc = null;
	private DlgReprintRpt reprintStatementDialog = null;
	private DlgReprintRpt reprintReceiptDialog = null;
	private BasePanel copyPanel = null;

	private boolean memIsPreview = false;
	private boolean memIsReprint = false;

	public DlgChrgDayCase(MainFrame owner) {
		super(owner, YESNOCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Print report");
		setContentPane(getOPOfficePanel());

		// change label
		getButtonById(YES).setText("Preview");
		getButtonById(NO).setText("Print", 'P');

		RadioGroup btngrp = new RadioGroup();
		btngrp.add(getYesOpt());
		btngrp.add(getNoOpt());

		// layout
	}

	public void showDialog(String patNo, String slpNo, String slpType, boolean isReprint, String rptLang) {
		setMemSlipNo(slpNo);
//		setSlipType(slpType);
		memIsReprint = isReprint;

		clearSlipField();

		setParameter("PatNo", patNo);
		setLanguage(rptLang);

		getNoOpt().setSelected(true);

		loadOldSlipNo();

		setVisible(true);
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
	public Component getDefaultFocusComponent() {
		return getOPOfficePanel();
	}

	@Override
	protected void printReport() {
		Map<String,String> map = new HashMap<String,String>();
		map.put("SUBREPORT_DIR", CommonUtil.getReportDir());
		map.put("P_SLPNO", getSlpNo().getText() );
		map.put("ALLSLPNO", getAllSlip(true) );
		map.put("ISCOPY", getYesOpt().isSelected()?"Y":"");

		String paperSize = Factory.getInstance().getSysParameter("CsPageSize");
		String printerName = "";
		if (paperSize != null && paperSize.length() > 0) {
			printerName = "HATS_"+paperSize;
		}

		Factory.getInstance().addRequiredReportDesc(map,
			new String[] {
				"MapLanguage", "MapLanguage", "MapLanguage",
				"MapLanguage", "MapLanguage", "MapLanguage",
				"MapLanguage", "MapLanguage", "MapLanguage",
				"MapLanguage", "MapLanguage", "MapLanguage",
				"MapLanguage", "MapLanguage", "MapLanguage",
				"MapLanguage", "MapLanguage", "MapLanguage",
				"MapLanguage"
			},
			new String[] {
				"DCTotChgTtl", "Copy", "BillNo",
				"PatName", "TreDr", "Date", "PatNo", "Page",
				"SpecialFee", "DocCredit", "Credits", "HosCharge",
				"DocCharge", "HosCredit", "Charges", "Refund",
				"SpecialSrv", "Packages", "Balance"
			},
			getLanguage());

		if (memIsPreview) {
			Report.print(getUserInfo(),
					"ChrgDayCase", map,
					new String[] {
						getMemSlipNo()
					},
					new String[] {
						"PATNAME", "PATCNAME", "SLPNO", "PATNO",
						"REGDATE", "REGTIME", "BEDACM", "INPDDATE",
						"INPDTIME", "DOCNAME", "DOCCNAME"
					},
					new boolean[] {
						false, false, false, false,
						false, false, false, false,
						false, false, false
					},
					new String[] {
						"CHRGDAYCASE_SUB"
					},
					new String[][] {{ getAllSlip(true) }},
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
		} else {
			PrintingUtil.print(
					printerName, "ChrgDayCase", map, null,
				new String[] {
					getMemSlipNo()
				},
				new String[] {
					"PATNAME", "PATCNAME", "SLPNO", "PATNO",
					"REGDATE", "REGTIME", "BEDACM", "INPDDATE",
					"INPDTIME", "DOCNAME", "DOCCNAME"
				},
				1,
				new String[] {
					"CHRGDAYCASE_SUB"
				},
				new String[][] {
					{
						getAllSlip(true)
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
				}, 1);
		}

		if (memIsPreview) {
			memIsPreview = false;
		} else if (memIsReprint) {
			showReprintStatementDialog();
		} else {
			unlockSlips();
		}
	}

	private void printDayCaseReceipt() {
		Map<String,String> map = new HashMap<String,String>();
		map.put("SUBREPORT_DIR", CommonUtil.getReportDir());
		map.put("P_SLPNO", getSlpNo().getText() );
		map.put("ALLSLPNO", getAllSlip(true) );
		map.put("ISCOPY", getYesOpt().isSelected()?"Y":"");

		String paperSize = Factory.getInstance().getSysParameter("DCPageSize");
		String printerName = "";
		if (paperSize != null && paperSize.length() > 0) {
			printerName = "HATS_"+paperSize;
		}

		Factory.getInstance().addRequiredReportDesc(map,
			new String[] {
				"MapLanguage", "MapLanguage", "MapLanguage",
				"MapLanguage", "MapLanguage", "MapLanguage",
				"MapLanguage", "MapLanguage", "MapLanguage",
				"MapLanguage", "MapLanguage"
			},
			new String[] {
				"receipt", "BillNo", "PatName",
				"DisDtTime","Date", "TreDr",
				"PatNo", "BedNo", "Copy",
				"Page", "TotReceipt"
			},
			getLanguage());

		if (PrintingUtil.print(
			printerName, "DayCaseReceipt", map, null,
			new String[] {
				getMemSlipNo()
			},
			new String[] {
				"PATNAME", "PATCNAME", "SLPNO",
				"PATNO", "REGDATE", "REGTIME",
				"BEDACM", "INPDDATE", "INPDTIME",
				"DOCNAME", "DOCCNAME"
			}, 1,
			new String[] {
				"IPRECEIPT_SUB"
			},
			new String[][] {
				{
					getAllSlip(true),""
				}
			},
			new String[][] {
				{
					"STNTDATE", "AMOUNT",
					"DESCRIPTION",
					"CDESCCODE"
				}
			},
			new boolean[][] {
				{
					false, true,
					false, false
				}
			}, 1,
			Factory.getInstance().getSysParameter("DCPageSize")) && !memIsReprint) {
		}

		if (memIsPreview) {
			memIsPreview = false;
		} else if (memIsReprint) {
			showReprintReceiptDialog();
		} else {
			unlockSlips();
		}
	}

	/***************************************************************************
	 * Dialog Method
	 **************************************************************************/

	private void showReprintStatementDialog() {
		if (reprintStatementDialog == null) {
			reprintStatementDialog = new DlgReprintRpt(getMainFrame(), "Day Case Statement Of Account(Summary)") {
				@Override
				public void reprint() {
					printReport();
					dispose();
					showReprintStatementDialog();
				}

				@Override
				protected void doNoAction() {
					super.doNoAction();
					printDayCaseReceipt();
				}
			};
			reprintStatementDialog.setResizable(false);
		}
		reprintStatementDialog.showDialog();
		reprintStatementDialog.setZIndex(20000);

	}

	private void showReprintReceiptDialog() {
		if (reprintReceiptDialog == null) {
			reprintReceiptDialog = new DlgReprintRpt(getMainFrame(), "Day Case Official Receipt") {
				@Override
				public void reprint() {
					printDayCaseReceipt();
				}

				@Override
				protected void doNoAction() {
					super.doNoAction();
					unlockSlips();
				}
			};
			reprintReceiptDialog.setResizable(false);
		}
		reprintReceiptDialog.showDialog();
		reprintReceiptDialog.setZIndex(20000);
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getOPOfficePanel() {
		if (OPOfficePanel == null) {
			OPOfficePanel = new BasePanel();
			OPOfficePanel.setBounds(5, 5, 460, 280);
			OPOfficePanel.add(getSlipPanel(), null);
			OPOfficePanel.add(getCopyPanel(), null);
		}
		return OPOfficePanel;
	}

	private BasePanel getCopyPanel() {
		if (copyPanel == null) {
			copyPanel = new BasePanel();
			copyPanel.setBounds(5, 205, 450, 65);
			copyPanel.setBorders(true);
			copyPanel.add(getCopyDesc(), null);
			copyPanel.add(getYesOpt(), null);
			copyPanel.add(getNoOpt(), null);
		}
		return copyPanel;
	}

	public LabelBase getCopyDesc() {
		if (copyDesc == null) {
			copyDesc = new LabelBase();
			copyDesc.setText("Is it a copy?");
			copyDesc.setBounds(30, 10, 120, 20);
		}
		return copyDesc;
	}

	public RadioButtonBase getYesOpt() {
		if (yesOpt == null) {
			yesOpt = new RadioButtonBase();
			yesOpt.setText("Yes");
			yesOpt.setBounds(150, 10, 180, 20);
		}
		return yesOpt;
	}

	public RadioButtonBase getNoOpt() {
		if (noOpt == null) {
			noOpt = new RadioButtonBase();
			noOpt.setText("No");
			noOpt.setSelected(true);
			noOpt.setBounds(150, 35, 180, 20);
		}
		return noOpt;
	}
}