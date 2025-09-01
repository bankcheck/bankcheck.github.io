package com.hkah.client.layout.dialog;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.FieldEvent;
import com.extjs.gxt.ui.client.event.KeyListener;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.form.RadioGroup;
import com.google.gwt.event.dom.client.KeyCodes;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.radiobutton.RadioButtonBase;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.Report;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgIPOfficialReceipt extends DialogSlipBase {
	private final static int m_frameWidth = 500;
	private final static int m_frameHeight = 520;

	private BasePanel IPOfficePanel = null;
	private BasePanel midPanel = null;
	private LabelBase isCopyDesc = null;
	private RadioButtonBase yesOpt = null;
	private RadioButtonBase noOpt = null;
	private FieldSetBase seqPanel = null;
	private LabelBase seqDesc = null;
	private TextString seq = null;
	private TableList seqList = null;
	private String sPrnRange = "";
	private JScrollPane seqScrollPane = null;

	private boolean memIsPreview = false;

	public DlgIPOfficialReceipt(MainFrame owner) {
		super(owner, YESNOCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	private void initialize() {
		setTitle("Print IP/DayCase Official Receipt");

		// change label
		getButtonById(YES).setText("Preview");
		getButtonById(NO).setText("Print", 'P');

		setContentPane(getIPOfficePanel());

		RadioGroup btngrp = new RadioGroup();
		btngrp.add(getYesOpt());
		btngrp.add(getNoOpt());

		// layout
	}

	@Override
	public Component getDefaultFocusComponent() {
		return getIPOfficePanel();
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String patNo, String slpNo, String slpType, String rptLang) {
		setMemSlipNo(slpNo);
		setMemSlipType(slpType);

		clearSlipField();

		setParameter("PatNo", patNo);
		setLanguage(rptLang);

		getNoOpt().setSelected(true);

		loadOldSlipNo();

		QueryUtil.executeMasterBrowse(
				getUserInfo(), "IPRPTHIS", new String[] {getMemSlipNo(),"RECEIPT"},
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
	protected void doYesAction() {
		memIsPreview = true;
		validation();
	}

	@Override
	protected void doNoAction() {
		memIsPreview = false;
		validation();
	}

	private void printReceipt(String rptName) {
		Map<String,String> map = new HashMap<String,String>();
		map.put("SUBREPORT_DIR", CommonUtil.getReportDir());
		map.put("P_SLPNO", getSlpNo().getText() );
		map.put("ALLSLPNO", getAllSlip(true) );
		map.put("ISCOPY", getYesOpt().isSelected()?"Y":"");
		map.put("SteCode", getUserInfo().getSiteCode());
		if (getSeq().getValue() != null && getSeq().getValue().length() > 0) {
			map.put("PRNRANGENOTE", "Note: Printing Sequence number "+getSeq().getValue());
		}
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
		map.put("watermark", CommonUtil.getReportImg("copy_watermark.gif"));
		map.put("DOCBKGCPY",Factory.getInstance().getSysParameter("DOCBKGCPY"));
		if (getSeq().getValue() != null && getSeq().getValue().length() > 0) {
			map.put("PRNRANGENOTE", "Note: Printing Sequence number "+getSeq().getValue());
		}
		map.put("AppIOSQRImg",CommonUtil.getReportImg("AppIOSQRCode.png"));
		map.put("AppAndImg",CommonUtil.getReportImg("AppAndQRCode.png"));
		map.put("isShwPromo",Factory.getInstance().getSysParameter("isShwPromo"));
		map.put("slpType",getMemSlipType());
		
		String paperSize = "A4";
		String printerName = "";

		if ("DayCaseReceipt".equals(rptName)) {
			Factory.getInstance()
			.addRequiredReportDesc(map,new String[] {"MapLanguage"},new String[] {"Date"},getLanguage());

			paperSize = Factory.getInstance().getSysParameter("DCPageSize");
			if (paperSize != null && paperSize.length() > 0) {
				printerName = "HATS_"+paperSize;
			}
		} else {
			paperSize = Factory.getInstance().getSysParameter("RpPageSize");
			if (paperSize != null && paperSize.length() > 0) {
				printerName = "HATS_"+paperSize;
			}
		}

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

		if (memIsPreview) {
			Report.print(getUserInfo(), rptName, map,
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
							false, false, false},
					new String[] {
							"IPRECEIPT_SUB"
					},
					new String[][] {
							{
									getAllSlip(true),sPrnRange
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
									false, true, false, false
							}
					},
					"", true, false, true, false, null, null, null, false);
		} else {
			PrintingUtil.print(printerName, rptName, map, null,
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
							"IPRECEIPT_SUB"
					},
					new String[][] {
							{
									getAllSlip(true),sPrnRange
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
									false, true, false, false
							}
					}, 1, paperSize);
		}

		if (memIsPreview) {
			memIsPreview = false;
		} else {
			unlockSlips();
		}
		if (getSeq().getValue() != null && getSeq().getValue().length() > 0) {
			QueryUtil.executeMasterAction(getUserInfo(), "IPSTATPRINTHIST",
					QueryUtil.ACTION_MODIFY,
					new String[] { getYesOpt().isSelected()?"Y":"N",
							getSeq().getValue() != null ?
									getSeq().getValue().trim() :
									"", getUserInfo().getUserID(), getMemSlipNo(),
									String.valueOf("4") },
					new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
							}
						}
					});
		}
	}

	private void printIPReceiptMB() {
		Map<String,String> map = new HashMap<String,String>();
		map.put("SUBREPORT_DIR", CommonUtil.getReportDir());
		map.put("P_SLPNO", getSlpNo().getText() );
		map.put("ALLSLPNO", getAllSlip(true) );
		map.put("ISCOPY", getYesOpt().isSelected()?"Y":"");

		Factory.getInstance().addRequiredReportDesc(map,
				new String[] {
							"MapLanguage", "MapLanguage", "MapLanguage",
							"MapLanguage", "MapLanguage", "MapLanguage",
							"MapLanguage", "MapLanguage", "MapLanguage",
							"MapLanguage", "MapLanguage", "MapLanguage",
							"MapLanguage", "MapLanguage", "MapLanguage",
							 "MapLanguage"
				},
				new String[] {
							"receipt", "BillNo", "PatName", "AdmDtTime",
							"DisDtTime", "TreDr", "PatNo", "BedNo", "Copy",
							"Page", "TotReceipt", "patM", "patB", "DelDr",
							"BirthDt","AdmDtTime"
				},
				getLanguage());
		map.put("watermark", CommonUtil.getReportImg("copy_watermark.gif"));
		map.put("DOCBKGCPY",Factory.getInstance().getSysParameter("DOCBKGCPY"));

		String paperSize = "A4";
		String printerName = "";

		paperSize = Factory.getInstance().getSysParameter("RpPageSize");
		if (paperSize != null && paperSize.length() > 0) {
			printerName = "HATS_" + paperSize;
		}

		if (memIsPreview) {
			Report.print(getUserInfo(), "IPReceiptMB",
					map,
					new String[] {getMemSlipNo(), getAllSlip(false)},
					new String[] {"MB", "PATNAME", "PATCNAME", "SLPNO", "PATNO", "REGDATE", "REGTIME", "BEDACM", "INPDDATE", "INPDTIME", "DOCNAME", "DOCCNAME"},
					new boolean[] {false, false, false, false, false, false, false, false, false, false, false, false},
					new String[] {"IPRECEIPTMB_SUB"},
					new String[][] {{getMemSlipNo(), getAllSlip(false)}},
					new String[][] {{"MB", "STNTDATE", "DESCRIPTION", "AMOUNT", "CDESCCODE"}},
					new boolean[][] {{false,false,false,true, false}},
					"", true, false, true, false, null, null, null, false);
		} else {
			PrintingUtil.print(printerName, "IPReceiptMB",
					map, null,
					new String[] {getMemSlipNo(), getAllSlip(false)},
					new String[] {"MB", "PATNAME", "PATCNAME", "SLPNO", "PATNO", "REGDATE", "REGTIME", "BEDACM", "INPDDATE", "INPDTIME", "DOCNAME", "DOCCNAME"},
					1,
					new String[] {"IPRECEIPTMB_SUB"},
					new String[][] {{getMemSlipNo(), getAllSlip(false)}},
					new String[][] {{"MB", "STNTDATE", "DESCRIPTION", "AMOUNT", "CDESCCODE"}},
					new boolean[][] {{false,false,false,true, false}}, 1, paperSize);
		}

		if (memIsPreview) {
			memIsPreview = false;
		} else {
			unlockSlips();
		}
	}

	@Override
	public void isImplementMBReady(int i) {
		int iTemp = i;
		if (iTemp == 1) {
			printIPReceiptMB();
		} else if (iTemp == 2) {
			printReceipt("IPReceipt");
		}
	}

	@Override
	protected void printReport() {
		if ("I".equals(getMemSlipType())) {
			isImplementMB(getUserInfo(),
					getMemSlipNo(),
					getMergeWith1().getText().trim(),
					getMergeWith2().getText().trim(),
					getMergeWith3().getText().trim(),
					getMergeWith4().getText().trim(),
					getMergeWith5().getText().trim(),
					getMergeWith6().getText().trim(),
					getMergeWith7().getText().trim(),
					getMergeWith8().getText().trim(),
					getMergeWith9().getText().trim(),
					getMergeWith10().getText().trim()
				);
		} else if ("O".equals(getMemSlipType())) {
			printReceipt("OPReceipt");
		} else if ("D".equals(getMemSlipType())) {
			printReceipt("DayCaseReceipt");
		}
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	private BasePanel getIPOfficePanel() {
		if (IPOfficePanel == null) {
			IPOfficePanel = new BasePanel();
			IPOfficePanel.setBounds(5, 5, 460, 450);
			IPOfficePanel.add(getSlipPanel(), null);
			IPOfficePanel.add(getMidPanel(), null);
			IPOfficePanel.add(getSeqPanel(), null);
		}
		return IPOfficePanel;
	}

	private BasePanel getMidPanel() {
		if (midPanel == null) {
			midPanel = new BasePanel();
			midPanel.setBounds(5, 200, 450, 60);
			midPanel.setBorders(true);
			midPanel.add(getIsCopyDesc(), null);
			midPanel.add(getYesOpt(), null);
			midPanel.add(getNoOpt(), null);
		}
		return midPanel;
	}

	private LabelBase getIsCopyDesc() {
		if (isCopyDesc == null) {
			isCopyDesc = new LabelBase();
			isCopyDesc.setBounds(20, 10, 100, 20);
			isCopyDesc.setText("Is it a copy?");
		}
		return isCopyDesc;
	}

	private RadioButtonBase getYesOpt() {
		if (yesOpt == null) {
			yesOpt = new RadioButtonBase();
			yesOpt.setText("Yes");
			yesOpt.setBounds(130, 10, 200, 20);
			yesOpt.setSelected(true);
		}
		return yesOpt;
	}

	private RadioButtonBase getNoOpt() {
		if (noOpt == null) {
			noOpt = new RadioButtonBase();
			noOpt.setText("No");
			noOpt.setBounds(130, 35, 200, 20);
		 }
		return noOpt;
	}

	public FieldSetBase getSeqPanel() {
		if (seqPanel == null) {
			seqPanel = new FieldSetBase();
			seqPanel.setBounds(5, 260, 450, 165);
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
			seq.setBounds(105, 0, 200, 20);
		}
		return seq;
	}

	public TableList getSeqList() {
		if (seqList == null) {
			seqList = new TableList(
					new String[] {"", "Date", "Copy", "Print Sequence", "User" },
					new int[] {10, 100, 50, 150, 80}) {
				@Override
				public void onSelectionChanged() {
					if (getSelectionModel().getSelectedItems().size() > 0) {
						int row = getSeqList().getSelectedRow();
						String seqNo = getSeqList().getValueAt(row, 3);
						if (seqNo != null && seqNo.length() > 0) {
							getSeq().setText(seqNo);
						}
					}
				}

				@Override
				public void setListTableContentPost() {
					getSelectionModel().deselectAll();
					getSeq().resetText();
				}
			};
			seqList.setBounds(0, 0, 420, 60);
			seqList.setBorders(false);
		}
		return seqList;
	}

	public JScrollPane getSeqScrollPane() {
		if (seqScrollPane == null) {
			seqScrollPane = new JScrollPane();
			seqScrollPane.setBounds(5, 30, 430, 100);
			seqScrollPane.setViewportView(getSeqList());
		}
		return seqScrollPane;
	}
}