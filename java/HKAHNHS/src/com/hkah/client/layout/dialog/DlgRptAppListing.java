package com.hkah.client.layout.dialog;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.event.FieldEvent;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.combobox.ComboPickListOrderBy;
import com.hkah.client.layout.combobox.ComboSpecialtyCode;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.TableData;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextDateTimeWithoutSecond;
import com.hkah.client.layout.textfield.TextDoctorSearch;
import com.hkah.client.layout.textfield.TextTime;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgRptAppListing extends DialogBase {

	private static final long serialVersionUID = 1L;
	private final static int m_frameWidth = 550;
	private final static int m_frameHeight = 550;
	protected static Logger logger = Logger.getLogger(DlgRptAppListing.class.getName());

	private int rptType = 0;
	private boolean mrChartLocation = false;
	private int noGLAP = 0;

	private BasePanel paraPanel = null;
	private BasePanel panel = null;
	private LabelBase appDate = null;
	private TextDate appDateDesc = null;
	private LabelBase fromTime = null;
	private TextTime fromTimeDesc = null;
	private LabelBase toTime = null;
	private TextTime toTimeDesc = null;
	private LabelBase capture = null;
	private TextDateTimeWithoutSecond captureDesc = null;
	private LabelBase orderByDesc = null;
	private ComboPickListOrderBy orderBy = null;
	private LabelBase doctorCode = null;
	private TextDoctorSearch doctorCodeDesc = null;
	private LabelBase specCode = null;
	private ComboSpecialtyCode specCodeDesc = null;

	private LabelBase available = null;
	private TableList leftListTable = null;
	private TableList rightListTable = null;
	private ButtonBase moveAllRightButtonBase = null;
	private ButtonBase moveRightButtonBase = null;
	private ButtonBase moveLeftButtonBase = null;
	private ButtonBase moveAllLeftButtonBase = null;
	private LabelBase selected = null;
	private JScrollPane jScrollPaneRight = null;
	private JScrollPane jScrollPaneLeft = null;

	private boolean isasterisk = "YES".equals(getMainFrame().getSysParameter("Chk*"));
	private boolean isChkDigit = "YES".equals(getMainFrame().getSysParameter("ChkDigit"));

	private MessageQueue allDocList = null;
	private MessageQueue leftDocList = null;
	private MessageQueue rightDocList = null;

	/**
	* This method initializes
	*
	*/
	public DlgRptAppListing(MainFrame owner) {
		super(owner, OKCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	private void initialize() {
		setTitle("Print Appointment Listing Report");
		setContentPane(getParaPanel());

		// change label
		getButtonById(OK).setText("Print", 'P');
	}

	public TextDate getDefaultFocusComponent() {
		return getAppDateDesc();
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(int type, boolean location, String noGLAPStr) {
		rptType = type;
		mrChartLocation = location;
		noGLAP = 0;
		try {
			noGLAP = Integer.parseInt(noGLAPStr);
		} catch(Exception e) {
		}

		getAppDateDesc().resetText();
		getFromTimeDesc().resetText();
		getToTimeDesc().resetText();
		getCaptureDesc().resetText();
		getDoctorCodeDesc().resetText();
		getSpecCodeDesc().resetText();
		getLeftListTable().removeAllRow();
		getRightListTable().removeAllRow();
		controlMoveButtons();

		if (rptType == 1 || rptType == 4) {
			getOrderBy().resetContentForOPD();
		} else if (rptType == 2) {
			getOrderBy().resetContentForIPD();
		}

		if ((rptType == 2 || rptType == 4) && Factory.getInstance().getSysParameter("PICKLBLORD").length() > 0) {
			getOrderBy().setSelectedIndex(Factory.getInstance().getSysParameter("PICKLBLORD"));
		}

		boolean showOrder = rptType == 1 || rptType == 2 || rptType == 4;
		getOrderByDesc().setVisible(showOrder);
		getOrderBy().setVisible(showOrder);

		setVisible(true);
	}

	@Override
	protected void doOkAction() {
		if (printReceipt()) {
			dispose();
		}
	}

	private boolean printReceipt() {
		StringBuffer docList = new StringBuffer();
		String toTime = getToTimeDesc().getText().length()==0 ? "23:59" : toTimeDesc.getText();
		final boolean isChkDigit = "YES".equals(getMainFrame().getSysParameter("ChkDigit"));
		Map<String, String> map = new HashMap<String, String>();
		if (getAppDateDesc().getText().length() == 0) {
			Factory.getInstance().addErrorMessage("Please supply Appointment Date.");
			getAppDateDesc().requestFocus();
			return false;
		}
		for (int i = 0; i < getRightListTable().getRowCount(); i++) {
			if (i < getRightListTable().getRowCount() - 1) {
				docList.append(getRightListTable().getRowContent(i)[1]);
				docList.append("/");
			} else {
				docList.append(getRightListTable().getRowContent(i)[1]);
			}
		}

		// cannot pass variable too long in URL
		if (docList.length() > 999) {
			docList.setLength(0);
			docList.append("-1");
		}

		if (rptType == 1) {
//			System.out.println("rptType=1---------");
//			System.out.println("applisting par====sdate"+appDateDesc.getText()+" "+fromTimeDesc.getText()+"edate="+appDateDesc.getText()+" "+toTime+"cdate="+
//					captureDesc.getText()+"="+getUserInfo().getSiteCode()+"="+doctorCodeDesc.getText()+"="+docList);
			map.put("isCheckDigit", isChkDigit ? "YES" : "NO");
			map.put("mrChartLocation", mrChartLocation ? "1" : "0");
			map.put("SiteName", getUserInfo().getSiteName());

			PrintingUtil.print("AppListing", map,null,
						new String[] {
							getAppDateDesc().getText() + "+" + getFromTimeDesc().getText().trim(),
							getAppDateDesc().getText() + "+" + toTime.trim(),
							getCaptureDesc().getText(),
							getUserInfo().getSiteCode(),
							getDoctorCodeDesc().getText(),
							docList.toString().trim(),
							getOrderBy().getText()
						},
						new String[] {
								"DOCCODE",
								"DOCCODEWITHCHKDGT",
								"DOCCODEWITHOUTCHKDGT",
								"DOCNAME",
								"SEXAGE",
								"COUNTRY",
								"BKGSDATE",
								"ATIME",
								"PATNO",
								"PATNAME",
								"PATCNAME",
								"BKGPTEL",
								"BKGSCNT",
								"BKGCDATE",
								"CTIME",
								"USRID",
								"MOBILE",
								"BKGRMK",
								"OFFICETEL",
								"ALERT",
								"STENAME",
								"SMS",
								"SMSSDTOK",
								"SMSRTNMSG",
								"TESTDONE",
								"PATNO_T",
								"LOC",
								"VOLNUM",
								"MFM"
						});

			map.clear();

			printLabelA(getAppDateDesc().getText() + "+" + getFromTimeDesc().getText().trim(),
						getAppDateDesc().getText() + "+" + toTime.trim(),
						getCaptureDesc().getText(),
						getUserInfo().getSiteCode(),
						getDoctorCodeDesc().getText(),
						docList.toString().trim());
		} else if (rptType == 2) {
			map.put("APPDATE", getAppDateDesc().getText());
			map.put("CAPTDATE", getCaptureDesc().getText());
			map.put("DOCCODE", getDoctorCodeDesc().getText());

			PrintingUtil.print(getMainFrame().getSysParameter("PRTRLBL"),
					"PickLstLblCriteria",
						map,null,
						new String[] {
								getAppDateDesc().getText() + "+" + getFromTimeDesc().getText().trim(),
								getAppDateDesc().getText() + "+" + toTime, getCaptureDesc().getText(),
								getUserInfo().getSiteCode(),
								getDoctorCodeDesc().getText(),
								getOrderBy().getText()
						},
						new String[] {"DOCNAME","BKGSDATE","PATNO","PATNAME","LOC","VOLNUM","DOCLOCID","MRLBLCONTENT"});

		} else if (rptType == 3) {
			PrintingUtil.print(getMainFrame().getSysParameter("PRTRMEDLBL"), "ABMedRecord", map, "",
					new String[] {
						getAppDateDesc().getText() + " " + getFromTimeDesc().getText(),
						getAppDateDesc().getText() + " " + toTime,
						getCaptureDesc().getText(),
						getUserInfo().getSiteCode(),
						getDoctorCodeDesc().getText()
					},
					new String[] {
							"STENAME",
							"PATNOA",
							"PATNOB",
							"PATNOC",
							"PATNOD",
							"PATNOE",
							"NAME",
							"SPNAME",
							"DOCNAME",
							"BKGSDATE",
							"CALLEDBY",
							"ALERT"
					}
			);
		} else if (rptType == 4) {
//			System.out.println("rptType=4---------");
//			System.out.println("applisting par====sdate"+appDateDesc.getText()+" "+fromTimeDesc.getText()+"edate="+appDateDesc.getText()+" "+toTime+"cdate="+
//					captureDesc.getText()+"="+getUserInfo().getSiteCode()+"="+doctorCodeDesc.getText()+"="+docList);
			map.put("isCheckDigit",isChkDigit ? "YES" : "NO");
			map.put("mrChartLocation",mrChartLocation ? "1" : "0");
			map.put("SiteName", getUserInfo().getSiteName());

			if ("-1".equals(docList.toString())) {
				docList.setLength(0);
				docList.append("-2"); //retrieve all active doctor but exclude rehab
			}

			PrintingUtil.print("AppListing", map,null,
						new String[] {
							getAppDateDesc().getText() + "+" + getFromTimeDesc().getText().trim(),
							getAppDateDesc().getText() + "+" + toTime.trim(),
							getCaptureDesc().getText(),
							getUserInfo().getSiteCode(),
							getDoctorCodeDesc().getText(),
							docList.toString().trim(),
							getOrderBy().getText()
						},
						new String[] {
								"DOCCODE",
								"DOCCODEWITHCHKDGT",
								"DOCCODEWITHOUTCHKDGT",
								"DOCNAME",
								"SEXAGE",
								"COUNTRY",
								"BKGSDATE",
								"ATIME",
								"PATNO",
								"PATNAME",
								"PATCNAME",
								"BKGPTEL",
								"BKGSCNT",
								"BKGCDATE",
								"CTIME",
								"USRID",
								"MOBILE",
								"BKGRMK",
								"OFFICETEL",
								"ALERT",
								"STENAME",
								"SMS",
								"SMSSDTOK",
								"SMSRTNMSG",
								"TESTDONE",
								"PATNO_T",
								"LOC",
								"VOLNUM"
						});

			map.clear();

			printLabelA(
					getAppDateDesc().getText() + "+" + getFromTimeDesc().getText().trim(),
					getAppDateDesc().getText() + "+" + toTime.trim(),
					getCaptureDesc().getText(),
					getUserInfo().getSiteCode(),
					getDoctorCodeDesc().getText(),
					docList.toString().trim());
		}
		return true;
	}

	private boolean printLabelA(String appDateFrom, String appDateTo, String capture,
			String siteCode, String docCode, String docList) {
		final int noGLAPInt2 = noGLAP;
		if (noGLAPInt2 > 0) {
			QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.APPLISTING_TXCODE + "_PAT",
					new String[] {appDateFrom, appDateTo, capture,siteCode,
								docCode, docList},
				new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						List<String[]> results = mQueue.getContentAsArray();
						List<String> patnos = new ArrayList<String>();
						for (String[] r : results) {
							patnos.add(r[0]);
						}
						printLabelA(patnos, noGLAPInt2, 0);
					}
			});
		}
		return true;
	}

	private boolean printLabelA(List<String> patnos, int totalPrint, int pCounter) {
		final HashMap<String, String> map1 = new HashMap<String, String>();
		// show print success in ui only for last call
		boolean alertSuccess = false;
		if (pCounter + 1 == patnos.size()) {
			alertSuccess = true;
		}

		if (patnos.get(pCounter) != null && !"".equals(patnos.get(pCounter))) {
			map1.put("newbarcode", patnos.get(pCounter)
					+ (isChkDigit ?  PrintingUtil.generateCheckDigit(patnos.get(pCounter)).toString()+"#" : "#"));
			map1.put("isasterisk", String.valueOf(isasterisk));
		}

		map1.put("SteCode", getUserInfo().getSiteCode());
		boolean result = PrintingUtil.print(getMainFrame().getSysParameter("PRTRLBL"),
				ConstantsTx.REGSEARCHPRINTDOBWTHNO,
				map1,null,
				new String[] {patnos.get(pCounter), String.valueOf(totalPrint)},
				new String[] {"stecode","patno","patname"
					,"patcname","patbdate","patsex"}, alertSuccess);
		logger.info("Print <general label> printer:" +
				getMainFrame().getSysParameter("PRTRLBL") + ", patno:" + patnos.get(pCounter) +
				" total:" + totalPrint + ", " + (result ? "success" : "fail"));
		if (result && pCounter + 1 < patnos.size()) {
			pCounter++;
			return printLabelA(patnos, totalPrint, pCounter);
		}
		return result;
	}

	protected String[] getLeftColumnNames() {
		return new String[] {"", "", "Doctor Name"};
	}

	protected int[] getLeftColumnWidths() {
		return new int[] {10, 0, 150};
	}

	protected String[] getRightColumnNames() {
		return new String[] {"", "", "Doctor Name"};
	}

	protected int[] getRightColumnWidths() {
		return new int[] {10, 0, 150};
	}

	private void moveAllItemLeft() {
		getLeftListTable().removeAllRow();
		getRightListTable().removeAllRow();

		if (allDocList == null) {
			QueryUtil.executeMasterBrowse(
					getUserInfo(), ConstantsTx.SCHEDULE_PRINTAPP, new String[] {ZERO_VALUE, EMPTY_VALUE, EMPTY_VALUE},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					allDocList = mQueue;
					getLeftListTable().setListTableContent(allDocList);
					if (getLeftListTable().getRowCount() > 0) {
						getLeftListTable().setSelectRow(0);
					}
				}
			});
		} else {
			getLeftListTable().setListTableContent(allDocList);
			if (getLeftListTable().getRowCount() > 0) {
				getLeftListTable().setSelectRow(0);
			}
		}
	}

	private void moveItemLeft() {
		TableData td = getRightListTable().getSelectionModel().getSelectedItem();
		if (td != null) {
			removeRow(getRightListTable(), td);
			getLeftListTable().getStore().add(td);
			if (getRightListTable().getRowCount() > 0) {
				getRightListTable().setSelectRow(0);
			}
		}
	}

	protected void moveItemRight() {
		TableData td = getLeftListTable().getSelectionModel().getSelectedItem();
		if (td != null) {
			removeRow(getLeftListTable(), td);
			getRightListTable().getStore().add(td);
			if (getLeftListTable().getRowCount() > 0) {
				getLeftListTable().setSelectRow(0);
			}
		}
	}

	protected void moveAllItemRight() {
		getLeftListTable().removeAllRow();
		getRightListTable().removeAllRow();

		if (allDocList == null) {
			QueryUtil.executeMasterBrowse(
					getUserInfo(), ConstantsTx.SCHEDULE_PRINTAPP, new String[] {ZERO_VALUE, EMPTY_VALUE, EMPTY_VALUE},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					allDocList = mQueue;
					getRightListTable().setListTableContent(allDocList);
					if (getRightListTable().getRowCount() > 0) {
						getRightListTable().setSelectRow(0);
					}
				}
			});
		} else {
			getRightListTable().setListTableContent(allDocList);
			if (getRightListTable().getRowCount() > 0) {
				getRightListTable().setSelectRow(0);
			}
		}
	}

	public String[] getLeftListSelectedRow() {
		return getLeftListTable().getSelectedRowContent();
	}

	public String[] getRightListSelectedRow() {
		return getRightListTable().getSelectedRowContent();
	}

	public void removeRow(TableList table, TableData td) {
		table.getStore().remove(td);
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getParaPanel() {
		if (paraPanel == null) {
			paraPanel = new BasePanel();
			paraPanel.add(getPanel(), null);
		}
		return paraPanel;
	}

	public BasePanel getPanel() {
		if (panel == null) {
			panel = new BasePanel();
			panel.setBounds(15, 8, 512, 432);
			panel.add(getAppDateDesc(), null);
			panel.add(getAppDate(), null);
			panel.add(getFromTimeDesc(), null);
			panel.add(getFromTime(), null);
			panel.add(getToTimeDesc(), null);
			panel.add(getToTime(), null);
			panel.add(getCaptureDesc(), null);
			panel.add(getCapture(), null);
			panel.add(getOrderByDesc(), null);
			panel.add(getOrderBy(), null);
			panel.add(getDoctorCodeDesc(), null);
			panel.add(getDoctorCode(), null);
			panel.add(getSpecCodeDesc(), null);
			panel.add(getSpecCode(), null);
			panel.add(getAvailable(), null);
			panel.add(getSelected(), null);
			panel.add(getMoveAllRightButtonBase(), null);
			panel.add(getMoveRightButtonBase(), null);
			panel.add(getMoveLeftButtonBase(), null);
			panel.add(getMoveAllLeftButtonBase(), null);
			panel.add(getJScrollPaneRight(), null);
			panel.add(getJScrollPaneLeft(), null);
		}
		return panel;
	}

	public LabelBase getAppDate() {
		if (appDate == null) {
			appDate = new LabelBase();
			appDate.setText("<font color='blue'>Appointment Date:</font><br>(dd/mm/yyyy)");
			appDate.setBounds(15, 20, 120, 30);
		}
		return appDate;
	}

	public TextDate getAppDateDesc() {
		if (appDateDesc == null) {
			appDateDesc = new TextDate();
			appDateDesc.setBounds(130, 25, 120, 20);
		}
		return appDateDesc;
	}

	public LabelBase getFromTime() {
		if (fromTime == null) {
			fromTime = new LabelBase();
			fromTime.setText("From:<br>(hh:mm)<br>(optional)");
			fromTime.setBounds(255, 19, 54, 45);
		}
		return fromTime;
	}

	public TextTime getFromTimeDesc() {
		if (fromTimeDesc == null) {
			fromTimeDesc = new TextTime();
			fromTimeDesc.setBounds(315, 24, 60, 20);
		}
		return fromTimeDesc;
	}

	public LabelBase getToTime() {
		if (toTime == null) {
			toTime = new LabelBase();
			toTime.setText("To:<br>(hh:mm)<br>(optional)");
			toTime.setBounds(385, 19, 54, 45);
		}
		return toTime;
	}

	public TextTime getToTimeDesc() {
		if (toTimeDesc == null) {
			toTimeDesc = new TextTime();
			toTimeDesc.setBounds(445, 24, 60, 20);
		}
		return toTimeDesc;
	}

	public LabelBase getCapture() {
		if (capture == null) {
			capture = new LabelBase();
			capture.setText("Capture Date<br>(dd/mm/yyy hh:mm)<br>(optional)");
			capture.setBounds(15, 70, 120, 48);
		}
		return capture;
	}

	public TextDateTimeWithoutSecond getCaptureDesc() {
		if (captureDesc == null) {
			captureDesc = new TextDateTimeWithoutSecond();
			captureDesc.setBounds(130, 80, 120, 20);
		}
		return captureDesc;
	}

	public LabelBase getOrderByDesc() {
		if (orderByDesc == null) {
			orderByDesc = new LabelBase();
			orderByDesc.setText("Order by:");
			orderByDesc.setBounds(250, 80, 55, 35);
		}
		return orderByDesc;
	}

	public ComboPickListOrderBy getOrderBy() {
		if (orderBy == null) {
			orderBy = new ComboPickListOrderBy();
			orderBy.setBounds(310, 80, 110, 20);
		}
		return orderBy;
	}

	public LabelBase getDoctorCode() {
		if (doctorCode == null) {
			doctorCode = new LabelBase();
			doctorCode.setText("Doctor Code<br>(optional)");
			doctorCode.setBounds(15, 135, 120, 35);
		}
		return doctorCode;
	}

	public TextDoctorSearch getDoctorCodeDesc() {
		if (doctorCodeDesc == null) {
			doctorCodeDesc = new TextDoctorSearch() {
				@Override
				protected void onKeyUp(FieldEvent fe) {
					controlMoveButtons();
				}

				@Override
				public void onBlur() {
					final String doccode = doctorCodeDesc.getText();
					if (doccode != null && doccode.length() > 0) {
						QueryUtil.executeMasterBrowse(
								getUserInfo(), ConstantsTx.SCHEDULE_PRINTAPP, new String[] {THREE_VALUE, doccode, EMPTY_VALUE},
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								getRightListTable().setListTableContent(mQueue);
								if (getRightListTable().getRowCount() > 0) {
									getRightListTable().setSelectRow(0);
								}
							}
						});
					}
				}
			};
			doctorCodeDesc.setBounds(130, 140, 110, 20);
		}
		return doctorCodeDesc;
	}

	public LabelBase getSpecCode() {
		if (specCode == null) {
			specCode = new LabelBase();
			specCode.setText("Specialty<br>(optional)");
			specCode.setBounds(15, 175, 120, 35);
		}
		return specCode;
	}

	public ComboSpecialtyCode getSpecCodeDesc() {
		if (specCodeDesc == null) {
			specCodeDesc = new ComboSpecialtyCode() {
				@Override
				protected void setTextPanel(ModelData modelData) {
					controlMoveButtons();
				}
			};
			specCodeDesc.setBounds(130, 180, 110, 20);
		}
		return specCodeDesc;
	}

	private void controlMoveButtons() {
		boolean isAppointmentDateFocus = getAppDateDesc().isFocusOwner();
		boolean isCaptureDateFocus = getCaptureDesc().isFocusOwner();
		boolean isDoctorCodeFocus = getDoctorCodeDesc().isFocusOwner();
		boolean isSpecCodeFocus = getSpecCodeDesc().isFocusOwner();
		String doccode = getDoctorCodeDesc().getText();
		String speccode = getSpecCodeDesc().getText();
		boolean enableMove = false;

		if (doccode != null && doccode.trim().length() > 0) {
			getLeftListTable().removeAllRow();
			getRightListTable().removeAllRow();

			getSpecCodeDesc().setEnabled(false);
		} else if (speccode != null && speccode.trim().length() > 0) {
			getLeftListTable().removeAllRow();
			getRightListTable().setListTableContent(ConstantsTx.SCHEDULE_PRINTAPP, new String[] {FIVE_VALUE, EMPTY_VALUE, speccode});

			getDoctorCodeDesc().setEnabled(false);
		} else {
			if (leftDocList == null) {
				QueryUtil.executeMasterBrowse(
						getUserInfo(), ConstantsTx.SCHEDULE_PRINTAPP, new String[] {TWO_VALUE, EMPTY_VALUE, EMPTY_VALUE},
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						leftDocList = mQueue;
						getLeftListTable().setListTableContent(leftDocList);
						if (getLeftListTable().getRowCount() > 0) {
							getLeftListTable().setSelectRow(0);
						}
					}
				});
			} else {
				getLeftListTable().setListTableContent(leftDocList);
				if (getLeftListTable().getSelectedRow() < 0 && getLeftListTable().getRowCount() > 0) {
					getLeftListTable().setSelectRow(0);
				}
			}

			if (rightDocList == null) {
				QueryUtil.executeMasterBrowse(
						getUserInfo(), ConstantsTx.SCHEDULE_PRINTAPP, new String[] {ONE_VALUE, EMPTY_VALUE, EMPTY_VALUE},
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						rightDocList = mQueue;
						getRightListTable().setListTableContent(rightDocList);
						if (getRightListTable().getRowCount() > 0) {
							getRightListTable().setSelectRow(0);
						}
					}
				});
			} else {
				getRightListTable().setListTableContent(rightDocList);
				if (getRightListTable().getSelectedRow() < 0 && getRightListTable().getRowCount() > 0) {
					getRightListTable().setSelectRow(0);
				}
			}
			getSpecCodeDesc().setEnabled(true);
			getDoctorCodeDesc().setEnabled(true);
			enableMove = true;
		}

		getMoveAllLeftButtonBase().setEnabled(enableMove);
		getMoveLeftButtonBase().setEnabled(enableMove);
		getMoveRightButtonBase().setEnabled(enableMove);
		getMoveAllRightButtonBase().setEnabled(enableMove);

		// set focus
		if (isAppointmentDateFocus) {
			getAppDateDesc().requestFocus();
		} else if (isCaptureDateFocus) {
			getCaptureDesc().requestFocus();
		} else if (isDoctorCodeFocus) {
			getDoctorCodeDesc().requestFocus();
		} else if (isSpecCodeFocus) {
			getSpecCodeDesc().requestFocus();
		} else {
			getDefaultFocusComponent().requestFocus();
		}
	}

	public LabelBase getAvailable() {
		if (available == null) {
			available = new LabelBase();
			available.setText("Available Doctor");
			available.setBounds(18, 215, 90, 28);
		}
		return available;
	}

	public LabelBase getSelected() {
		if (selected == null) {
			selected = new LabelBase();
			selected.setText("Selected Doctor");
			selected.setBounds(300, 215, 120, 28);
		}
		return selected;
	}

	private TableList getLeftListTable() {
		if (leftListTable == null) {
			leftListTable = new TableList(getLeftColumnNames(), getLeftColumnWidths());
//			leftListTable.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
		}
		return leftListTable;
	}

	private TableList getRightListTable() {
		if (rightListTable == null) {
			rightListTable = new TableList(getRightColumnNames(), getRightColumnWidths());
//			rightListTable.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
		}
		return rightListTable;
	}

	private ButtonBase getMoveAllRightButtonBase() {
		if (moveAllRightButtonBase == null) {
			moveAllRightButtonBase = new ButtonBase() {
				@Override
				public void onClick() {
					moveAllItemRight();
					moveAllRightButtonBase.focus();
				}
			};
			moveAllRightButtonBase.setText("All >>");
			moveAllRightButtonBase.setBounds(228, 280, 52, 25);
		}
		return moveAllRightButtonBase;
	}

	private ButtonBase getMoveRightButtonBase() {
		if (moveRightButtonBase == null) {
			moveRightButtonBase = new ButtonBase() {
				@Override
				public void onClick() {
					moveItemRight();
					moveRightButtonBase.focus();
				}
			};
			moveRightButtonBase.setText(">>");
			moveRightButtonBase.setBounds(228, 310, 52, 25);
		}
		return moveRightButtonBase;
	}

	private ButtonBase getMoveLeftButtonBase() {
		if (moveLeftButtonBase == null) {
			moveLeftButtonBase = new ButtonBase() {
				@Override
				public void onClick() {
					moveItemLeft();
					moveLeftButtonBase.focus();
				}
			};
			moveLeftButtonBase.setText("<<");
			moveLeftButtonBase.setBounds(228, 340, 52, 25);
		}
		return moveLeftButtonBase;
	}

	private ButtonBase getMoveAllLeftButtonBase() {
		if (moveAllLeftButtonBase == null) {
			moveAllLeftButtonBase = new ButtonBase() {
				@Override
				public void onClick() {
					moveAllItemLeft();
					moveAllLeftButtonBase.focus();
				}
			};
			moveAllLeftButtonBase.setText("<< All");
			moveAllLeftButtonBase.setBounds(228, 370, 52, 25);
		}
		return moveAllLeftButtonBase;
	}

	private JScrollPane getJScrollPaneRight() {
		if (jScrollPaneRight == null) {
			jScrollPaneRight = new JScrollPane();
			jScrollPaneRight.setBounds(295, 240, 190, 210);
			jScrollPaneRight.setViewportView(getRightListTable());
		}
		return jScrollPaneRight;
	}

	private JScrollPane getJScrollPaneLeft() {
		if (jScrollPaneLeft == null) {
			jScrollPaneLeft = new JScrollPane();
			jScrollPaneLeft.setBounds(13, 240, 190, 210);
			jScrollPaneLeft.setViewportView(getLeftListTable());
		}
		return jScrollPaneLeft;
	}
}