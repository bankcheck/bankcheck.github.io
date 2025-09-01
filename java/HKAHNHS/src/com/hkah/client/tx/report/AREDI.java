package com.hkah.client.tx.report;

import java.util.HashMap;
import java.util.Map;

import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboSiteType;
import com.hkah.client.layout.combobox.ComboSlipType;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.label.LabelSmallBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.TableData;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextARCode;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.layout.textfield.TextSlipNo;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.Report;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class AREDI extends MasterPanel{

	private static final long serialVersionUID = 1L;

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.AREDI_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.AREDI_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {};
	}

	private BasePanel rightPanel = null;
	private BasePanel leftPanel = null;

	private BasePanel TextPanel = null;
	private LabelBase DateRangeStartDesc = null;
	private TextDate DateRangeStart = null;
	private LabelBase DateRangeEndDesc = null;
	private TextDate DateRangeEnd = null;
	private LabelBase SiteCodeDesc = null;
	private ComboSiteType SiteCode = null;
	private LabelBase ARCCodeDesc = null;
	private TextString ARCCode = null;
	private LabelBase PatTypeDesc = null;
	private ComboSlipType PatType = null; 
	private LabelBase PatNoDesc = null;
	private TextPatientNoSearch PatNo = null;
	private LabelBase SlipNoDesc = null;
	private TextSlipNo SlipNo = null;
	
	private LabelBase available = null;
	private TableList leftListTable = null;
	private TableList rightListTable = null;
	private ButtonBase printListBtn = null;
	private LabelBase PrinttoScreenDesc = null;
	private CheckBoxBase PrinttoScreen = null;
	private ButtonBase moveAllRightButtonBase = null;
	private ButtonBase moveRightButtonBase = null;
	private ButtonBase moveLeftButtonBase = null;
	private ButtonBase moveAllLeftButtonBase = null;
	private LabelBase selected = null;
	private JScrollPane jScrollPaneRight = null;
	private JScrollPane jScrollPaneLeft = null;
	
	private MessageQueue allSlipList = null;
	private MessageQueue leftSlipList = null;
	private MessageQueue rightSlipList = null;

	/**
	 * This method initializes
	 *
	 */
	public AREDI() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		setNoListDB(true);
		//setLeftAlignPanel();
		setRightAlignPanel();
		//getRightPanel().setEnabled(true);
		getJScrollPane().setBounds(15, 25, 900, 550);
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		// disable all buttons except print
		setPrintMode();
		getSearchButton().setEnabled(true);
		getClearButton().setEnabled(true);
		setAllRightFieldsEnabled(true);
		
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return getARCCode();
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
		// at least 3 criteria

		int criteria = 0;
		if (!getPatNo().isEmpty()) criteria = 1;
		if (!getSlipNo().isEmpty()) criteria = 1;
		if (!getPatType().isEmpty() && !getARCCode().isEmpty()) criteria = 2;
		if (!getDateRangeStart().isValidEmpty() && !getARCCode().isEmpty() ) criteria = 2;
		if (!getDateRangeEnd().isValidEmpty() && !getARCCode().isEmpty() ) criteria = 2;
		if (!getDateRangeStart().isValidEmpty() && !getDateRangeEnd().isValidEmpty() ) criteria = 2;
		if (criteria < 1) {
			Factory.getInstance().addErrorMessage("Please enter sufficient Criteria", "AREDI", getDefaultFocusComponent());
			return false;
		} else {
			return true;
		}
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
	
	protected String[] getLeftColumnNames() {
		return new String[] {"", "",
				"Type",
				"Patient No.",
				"Bill Date",
				"Slip No.",
				"Reg.Date",
				"Balance",
				"SORTDATE",
				"PATREFNO"};
	}

	protected int[] getLeftColumnWidths() {
		return new int[] {20, 0,
				30,
				70,
				90,
				90,
				0,
				50,
				0,
				0};
	}

	protected String[] getRightColumnNames() {
		return new String[] {"", "",
				"Type",
				"Patient No.",
				"Bill Date",
				"Slip No.",
				"Reg.Date",
				"Balance",
				"SORTDATE",
				"PATREFNO"};
	}

	protected int[] getRightColumnWidths() {
		return new int[] {20, 0,
				30,
				70,
				90,
				90,
				0,
				50,
				0,
				0};
	}
	
	private void moveAllItemLeft() {
		getLeftListTable().removeAllRow();
		getRightListTable().removeAllRow();

		if (allSlipList == null) {
			QueryUtil.executeMasterBrowse(
					getUserInfo(), "EDIAVILSLIP", new String[] {getARCCode().getText().trim(), getDateRangeStart().getText(), getDateRangeEnd().getText(),getSiteCode().getText().trim()},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					allSlipList = mQueue;
					getLeftListTable().setListTableContent(allSlipList);
					if (getLeftListTable().getRowCount() > 0) {
						getLeftListTable().setSelectRow(0);
					}
				}
			});
		} else {
			getLeftListTable().setListTableContent(allSlipList);
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
			
			QueryUtil.executeMasterBrowse(
					getUserInfo(), "EDIAVILSLIP", 
					new String[] {getARCCode().getText().trim(), getDateRangeStart().getText(), getDateRangeEnd().getText(),
						getPatNo().getText().trim(),getSlipNo().getText(),getPatType().getText().trim(),getSiteCode().getText().trim()},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					allSlipList = mQueue;
					getRightListTable().setListTableContent(mQueue);
					if (getRightListTable().getRowCount() > 0) {
						getRightListTable().setSelectRow(0);
					}
				}
			});
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
	 * Helper Method
	 **************************************************************************/

	@Override
	protected void proExitPanel() {
		getMainFrame().resetSysTimeout();
	}

	private boolean validatePrintAction() {

		if (!getDateRangeStart().isEmpty() && !getDateRangeStart().isValid()) {
			Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_ERR_INVALIDDATE+"Start Date.", getDateRangeStart());
			return false;
		}

		if (!getDateRangeEnd().isEmpty() && !getDateRangeEnd().isValid()) {
			Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_ERR_INVALIDDATE+"End Date.", getDateRangeEnd());
			return false;
		}

		boolean error = false;
		StringBuffer sb = new StringBuffer();
		String steCode = getSiteCode().getText().trim();
		String rptName = null;

		if (error) {
			Factory.getInstance().addErrorMessage(sb.toString());
			return false;
		}
		return true;
	}

	@Override
	public void printAction() {
		//checking
		if (!validatePrintAction()) {
			return;
		}
		StringBuffer slpList = new StringBuffer();
		StringBuffer slpListIn = new StringBuffer();
		
		for (int i = 0; i < getRightListTable().getRowCount(); i++) {
			if ("T0115".equals(getARCCode().getText().trim()) || "T0128".equals(getARCCode().getText().trim())) {
					if (i < getRightListTable().getRowCount()) {
						if("I".equals(getRightListTable().getRowContent(i)[2])) {
							slpListIn.append(getRightListTable().getRowContent(i)[5]);
							slpListIn.append("/");
						} else {
							slpList.append(getRightListTable().getRowContent(i)[5]);
							slpList.append("/");
						}
					} else {
						if("I".equals(getRightListTable().getRowContent(i)[2])) {
							slpListIn.append(getLeftListTable().getRowContent(i)[5]);
							slpListIn.append("/");
						} else {
							slpList.append(getLeftListTable().getRowContent(i)[5]);
							slpList.append("/");
						}
					}
			} else {
				if (i < getRightListTable().getRowCount()) {
					slpList.append(getRightListTable().getRowContent(i)[5]);
					slpList.append("/");
				} else {
					slpList.append(getLeftListTable().getRowContent(i)[5]);
					slpList.append("/");
				}
			}
		}
		
		String startDate = getDateRangeStart().getText().trim();
		String endDate = getDateRangeEnd().getText().trim();
		Map<String, String> map = new HashMap<String, String>();
		
		if ("T0115".equals(getARCCode().getText().trim()) || "T0128".equals(getARCCode().getText().trim())) {
			if (slpListIn.length() > 0) {
				PrintingUtil.print("DEFAULT","RptEDI_AIA_xls",map,"",
						 new String[] {slpListIn.toString().trim(),getARCCode().getText().trim()},
						 new String[] {"REGTYPE","PROID","PRONAME","INVNO","INVDATE",
									   "MEMID","MEMNAME","INCDATE","SERVTYPE","DIAGCODE",
									   "DIAGDESC","DIAGCODE2","DIAGDESC2","PROCODE","PRODESC",
									   "PREAMT","COPAY","START_SICK","END_SICK","VONO",
									   "REFPROID","REFPRONA","REFNO","REFDATE",
									   "REMARKS","REFNO2","SEQNO","PACKAGE"},
						0, null, null, null, null, 1,
						false, true, new String[] { "xls" });
			}
			if (slpList.length() > 0) {
				PrintingUtil.print("DEFAULT","RptEDI_AIA_xls",map,"",
						 new String[] {slpList.toString().trim(),getARCCode().getText().trim()},
						 new String[] {"REGTYPE","PROID","PRONAME","INVNO","INVDATE",
									   "MEMID","MEMNAME","INCDATE","SERVTYPE","DIAGCODE",
									   "DIAGDESC","DIAGCODE2","DIAGDESC2","PROCODE","PRODESC",
									   "PREAMT","COPAY","START_SICK","END_SICK","VONO",
									   "REFPROID","REFPRONA","REFNO","REFDATE",
									   "REMARKS","REFNO2","SEQNO","PACKAGE"},
						0, null, null, null, null, 1,
						false, true, new String[] { "xls" });
			}
		} else {
			PrintingUtil.print("DEFAULT","RptEDI_xls",map,"",
					 new String[] {slpList.toString().trim()},
					 new String[] {"REGTYPE","PROVIDER","LOCATION","PATNO","IDATE",
								   "SLPVCHNO","SLPPLYNO","PATFNAME","PATGNAME","DOCNAME",
								   "INSPREAUTHNO","ADATE","DCODE","DDESC","DDATE",
								   "DREASON","INCDATE","ITEMCAT","ITMCODE","DESCRIPTION",
								   "AMOUNT","HPSTATUS","SLPNO","DSCDESC"},
					0, null, null, null, null, 1,
					false, true, new String[] { "xls" });
		}
	}
	
	@Override
	public void searchAction() {
		if (browseValidation()) {
		getLeftListTable().setListTableContent("EDIAVILSLIP", 
				new String[] {getARCCode().getText().trim(), getDateRangeStart().getText(), getDateRangeEnd().getText(),
				getPatNo().getText().trim(),getSlipNo().getText(),getPatType().getText().trim(),getSiteCode().getText().trim()  });
		}
	}
	@Override
	public  void clearAction(){
		getDateRangeStart().resetText();
		getDateRangeEnd().resetText();
		getPatNo().resetText();
		getSlipNo().resetText();
		getPatType().resetText();
		getARCCode().resetText();
		getLeftListTable().removeAllRow();
		getRightListTable().removeAllRow();
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/* >>> getter methods for init the Component start from here================================== <<< */
	@Override
	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
//			leftPanel.setSize(779, 321));
		}
		return leftPanel;
	}

	protected BasePanel getRightPanel() {
		if (rightPanel == null) {
			rightPanel = new BasePanel();
			rightPanel.setSize(900, 550);
			rightPanel.add(getTextPanel(),null);
			//leftPanel.setSize(800, 530));
		}
		return rightPanel;
	}
	

	public BasePanel getTextPanel() {
		if (TextPanel == null) {
			TextPanel = new BasePanel();
			TextPanel.setBorders(true);
			TextPanel.add(getDateRangeStartDesc(), null);
			TextPanel.add(getDateRangeStart(), null);
			TextPanel.add(getDateRangeEndDesc(), null);
			TextPanel.add(getDateRangeEnd(), null);
			TextPanel.add(getSiteCodeDesc(), null);
			TextPanel.add(getSiteCode(), null);
			TextPanel.add(getARCCodeDesc(), null);
			TextPanel.add(getARCCode(), null);
			TextPanel.add(getPatTypeDesc(), null);
			TextPanel.add(getPatType(), null);
			TextPanel.add(getPatNoDesc(), null);
			TextPanel.add(getPatNo(), null);
			TextPanel.add(getSlipNoDesc(), null);
			TextPanel.add(getSlipNo(), null);
			TextPanel.add(getPrintListBtn(), null);
			TextPanel.add(getPrinttoScreenDesc(), null);
			TextPanel.add(getPrinttoScreen(), null);
			TextPanel.add(getAvailable(), null);
			TextPanel.add(getSelected(), null);
			TextPanel.add(getMoveAllRightButtonBase(), null);
			TextPanel.add(getMoveRightButtonBase(), null);
			TextPanel.add(getMoveLeftButtonBase(), null);
			TextPanel.add(getMoveAllLeftButtonBase(), null);
			TextPanel.add(getJScrollPaneRight(), null);
			TextPanel.add(getJScrollPaneLeft(), null);	
			TextPanel.setLocation(6, 6);
			TextPanel.setSize(900, 550);
		}
		return TextPanel;
	}

	public LabelBase getDateRangeStartDesc() {
		if (DateRangeStartDesc == null) {
			DateRangeStartDesc = new LabelBase();
			DateRangeStartDesc.setText("<html>Date range start<br>(dd/mm/yyyy)</html>");
			DateRangeStartDesc.setBounds(100, 40, 100, 30);
		}
		return DateRangeStartDesc;
	}

	public TextDate getDateRangeStart() {
		if (DateRangeStart == null) {
			DateRangeStart = new TextDate() {
				@Override
				public void onBlur() {
					if (!isEmpty() && !isValid()) {
						Factory.getInstance().addErrorMessage("Invalid date.", getDateRangeStart());
						resetText();
						return;
					}
				};
			};
			DateRangeStart.setBounds(190, 41, 181, 20);
		}
		return DateRangeStart;
	}

	public LabelBase getDateRangeEndDesc() {
		if (DateRangeEndDesc == null) {
			DateRangeEndDesc = new LabelBase();
			DateRangeEndDesc.setText("<html>Date range end<br>(dd/mm/yyyy)</html>");
			DateRangeEndDesc.setBounds(426, 41, 100, 30);
		}
		return DateRangeEndDesc;
	}

	public TextDate getDateRangeEnd() {
		if (DateRangeEnd == null) {
			DateRangeEnd = new TextDate() {
				@Override
				public void onBlur() {
					if (!isEmpty() && !isValid()) {
						Factory.getInstance().addErrorMessage("Invalid date.", getDateRangeEnd());
						resetText();
						return;
					}
				};
			};
			DateRangeEnd.setBounds(513, 41, 181, 20);
		}
		return DateRangeEnd;
	}

	public LabelBase getSiteCodeDesc() {
		if (SiteCodeDesc == null) {
			SiteCodeDesc = new LabelBase();
			SiteCodeDesc.setText("Site Code");
			SiteCodeDesc.setBounds(101, 80, 87, 20);
		}
		return SiteCodeDesc;
	}

	public ComboSiteType getSiteCode() {
		if (SiteCode == null) {
			SiteCode = new ComboSiteType();
			SiteCode.setBounds(187, 80, 181, 20);
		}
		return SiteCode;
	}

	public LabelBase getARCCodeDesc() {
		if (ARCCodeDesc == null) {
			ARCCodeDesc = new LabelBase();
			ARCCodeDesc.setText("Arc Code");
			ARCCodeDesc.setBounds(427, 80, 87, 20);
		}
		return ARCCodeDesc;
	}

	public TextString getARCCode() {
		if (ARCCode == null) {
			ARCCode = new TextARCode();
			ARCCode.setBounds(513, 80, 181, 20);
		}
		return ARCCode;
	}
	
	public LabelBase getPatTypeDesc() {
		if (PatTypeDesc == null) {
			PatTypeDesc = new LabelBase();
			PatTypeDesc.setText("Pat. Type");
			PatTypeDesc.setBounds(101, 110, 87, 20);
		}
		return PatTypeDesc;
	}

	public ComboSlipType getPatType() {
		if (PatType == null) {
			PatType = new ComboSlipType();
			PatType.setBounds(187, 110, 100, 20);
		}
		return PatType;
	}
	
	public LabelBase getPatNoDesc() {
		if (PatNoDesc == null) {
			PatNoDesc = new LabelBase();
			PatNoDesc.setText("Pat. No");
			PatNoDesc.setBounds(320, 110, 50, 20);
		}
		return PatNoDesc;
	}
	public TextPatientNoSearch getPatNo() {
		if (PatNo == null) {
			PatNo = new TextPatientNoSearch(true, false);
			PatNo.setBounds(370, 110, 120, 20);
		}
		return PatNo;
	}
	
	private LabelBase getSlipNoDesc() {
		if (SlipNoDesc == null) {
			SlipNoDesc = new LabelBase();
			SlipNoDesc.setText("Slip No");
			SlipNoDesc.setBounds(500, 110, 80, 20);
		}
		return SlipNoDesc;
	}

	private TextSlipNo getSlipNo() {
		if (SlipNo == null) {
			SlipNo = new TextSlipNo();
			SlipNo.setBounds(555, 110, 150, 20);
		}
		return SlipNo;
	}
	
	private ButtonBase getPrintListBtn() {
		if (printListBtn == null) {
			printListBtn = new ButtonBase() {
				@Override
				public void onClick() {
					if (getRightListTable().getRowCount() > 0) {
						StringBuffer slpList = new StringBuffer();
						
						for (int i = 0; i < getRightListTable().getRowCount(); i++) {
							if (i < getRightListTable().getRowCount()) {
								slpList.append(getRightListTable().getRowContent(i)[5]);
								slpList.append("/");
							} else {
								slpList.append(getLeftListTable().getRowContent(i)[5]);
								slpList.append("/");
							}
						}
						
						Map<String, String> map = new HashMap<String, String>();
						map.put("StartDate", getDateRangeStart().getText());
						map.put("EndDate", getDateRangeEnd().getText());
						if (getPrinttoScreen().isSelected()) {
							Report.print(Factory.getInstance().getUserInfo(), "RptEDIList", map,
									new String[] {
										slpList.toString().trim(),getSiteCode().getText().trim()
									},
									new String[] {
										"TYPE", "PATNO", "BILLDATE", "SLPNO", "BAL",
										"SORTDATE", "PATREFNO", "STENAME"
									});
						} else {
							PrintingUtil.print("RptEDIList", map, "",
									new String[] {
									slpList.toString().trim(),getSiteCode().getText().trim()
								},
								new String[] {
										"TYPE", "PATNO", "BILLDATE", "SLPNO", "BAL",
										"SORTDATE", "PATREFNO", "STENAME"
									});
						}
					} else {
						Factory.getInstance().addErrorMessage("Please select slip(s)");
					}
				}
			};
			printListBtn.setText("Print List");
			printListBtn.setBounds(620, 140, 80, 25);
		}
		return printListBtn;
	}
	
	public LabelBase getPrinttoScreenDesc() {
		if (PrinttoScreenDesc == null) {
			PrinttoScreenDesc = new LabelBase();
			PrinttoScreenDesc.setText("Print To Screen");
			PrinttoScreenDesc.setBounds(735, 140, 105, 20);
		}
		return PrinttoScreenDesc;
	}

	public CheckBoxBase getPrinttoScreen() {
		if (PrinttoScreen == null) {
			PrinttoScreen = new CheckBoxBase();
			PrinttoScreen.setBounds(710, 140, 23, 20);
		}
		return PrinttoScreen;
	}
	
	public LabelBase getAvailable() {	
		if (available == null) {
			available = new LabelBase();
			available.setText("Available");
			available.setBounds(10, 140, 90, 28);
		}
		return available;
	}

	public LabelBase getSelected() {
		if (selected == null) {
			selected = new LabelBase();
			selected.setText("Selected");
			selected.setBounds(480, 140, 120, 28);
		}
		return selected;
	}

	private TableList getLeftListTable() {
		if (leftListTable == null) {
			leftListTable = new TableList(
					getLeftColumnNames(), 
					getLeftColumnWidths(),true){
						@Override
						public void doubleClick() {
							moveItemRight();
				};
			};
		}
		return leftListTable;
	}

	private TableList getRightListTable() {
		if (rightListTable == null) {
			rightListTable = new TableList(getRightColumnNames(), getRightColumnWidths(),true){
				@Override
				public void doubleClick() {
					moveItemLeft();
		};
			};
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
			moveAllRightButtonBase.setBounds(420, 230, 52, 25);
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
			moveRightButtonBase.setBounds(420, 260, 52, 25);
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
			moveLeftButtonBase.setBounds(420, 290, 52, 25);
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
			moveAllLeftButtonBase.setBounds(420, 310, 52, 25);
		}
		return moveAllLeftButtonBase;
	}

	private JScrollPane getJScrollPaneRight() {
		if (jScrollPaneRight == null) {
			jScrollPaneRight = new JScrollPane();
			jScrollPaneRight.setBounds(480, 170, 400, 310);
			jScrollPaneRight.setViewportView(getRightListTable());
		}
		return jScrollPaneRight;
	}

	private JScrollPane getJScrollPaneLeft() {
		if (jScrollPaneLeft == null) {
			jScrollPaneLeft = new JScrollPane();
			jScrollPaneLeft.setBounds(10, 170, 400, 310);
			jScrollPaneLeft.setViewportView(getLeftListTable());
		}
		return jScrollPaneLeft;
	}

}