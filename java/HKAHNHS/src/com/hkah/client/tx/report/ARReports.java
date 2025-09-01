package com.hkah.client.tx.report;

import java.util.HashMap;
import java.util.Map;

import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboSiteType;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextARCode;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.Report;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;

public class ARReports extends MasterPanel{

	private static final long serialVersionUID = 1L;

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.ARREPORTS_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.ARREPORTS_TITLE;
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

	private BasePanel CheckBoxPanel = null;
	private LabelBase CARNPTRDesc = null;
	private CheckBoxBase CARNPTR = null;
	private LabelBase ARAADesc = null;
	private CheckBoxBase ARAA = null;
	private LabelBase ARSADesc = null;
	private CheckBoxBase ARSA = null;
	private LabelBase ARAASDesc = null;
	private CheckBoxBase ARAAS = null;

	private FieldSetBase StatAccPanel = null;
	private FieldSetBase AROtherPanel = null;	
	
	private LabelBase ARSlipRmkDesc = null;
	private CheckBoxBase ARSlipRmk = null;	
	private LabelBase ARSARmk1Desc = null;
	private CheckBoxBase ARSARmk1 = null;
	private LabelBase ARSARmk2Desc = null;
	private CheckBoxBase ARSARmk2 = null;


	private BasePanel TextPanel = null;
	private LabelBase DateRangeStartDesc = null;
	private TextDate DateRangeStart = null;
	private LabelBase DateRangeEndDesc = null;
	private TextDate DateRangeEnd = null;
	private LabelBase SiteCodeDesc = null;
	private ComboSiteType SiteCode = null;
	private LabelBase ARCCodeDesc = null;
	private TextString ARCCode = null;
	private LabelBase PrinttoFileDesc = null;
	private CheckBoxBase PrinttoFile = null;
	private LabelBase PrinttoScreenDesc = null;
	private CheckBoxBase PrinttoScreen = null;
	private String fileType = "PDF";

	/**
	 * This method initializes
	 *
	 */
	public ARReports() {
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
		getJScrollPane().setBounds(15, 25, 725, 290);
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		// disable all buttons except print
		setPrintMode();
		setAllRightFieldsEnabled(true);
		getMainFrame().resetSysTimeout();
		getMainFrame().stopSysTimeoutCount();
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return null;//getDateRangeStart();
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

	@Override
	protected void proExitPanel() {
		getMainFrame().resetSysTimeout();
	}

	private boolean validatePrintAction() {
		if (!getCARNPTR().isSelected() && !getARAA().isSelected() &&
				!getARSA().isSelected() && !getARAAS().isSelected()) {
			Factory.getInstance().addErrorMessage("No report in Print Queue. ABORT TO PRINT.");
		}

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

		//Company AR Non-Patient Transation Report
		if (getCARNPTR().isSelected()) {
			if (error) {
				sb.append("<br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 ||
					!getSiteCode().isValid() ||
					getDateRangeStart().isEmpty() ||
					getDateRangeEnd().isEmpty()) {
				error = true;
				sb.append("Fail to print: Company AR Non-Patient Transation Report (rptArAdjust)<br/><br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 || !getSiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
			if (getDateRangeStart().isEmpty()) {
				sb.append("Please supply Start Date.<br/>");
			}
			if (getDateRangeEnd().isEmpty()) {
				sb.append("Please supply End Date.<br/>");
			}
		}

		//AR Aging Analysis
		if (getARAA().isSelected()) {
			if (error) {
				sb.append("<br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 ||
					!getSiteCode().isValid()) {
				error = true;
				sb.append("Fail to print: AR Aging Analysis (rptArAging)<br/><br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 || !getSiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
		}

		//AR Statement of Account
		if (getARSA().isSelected()) {
			if (error) {
				sb.append("<br/>");
			}

			if("AMC".equals(steCode)){
				rptName = "RptArStmtAMC";
			}else{
				rptName = "rptArStmt";	
			}
			
			if (getSiteCode().getText().trim().length() == 0 ||
					!getSiteCode().isValid()) {
				error = true;
				sb.append("Fail to print: AR Aging Analysis ("+rptName+")<br/><br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 || !getSiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
		}

		//AR Aging Analysis Summary
		if (getARAAS().isSelected()) {
			if (error) {
				sb.append("<br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 ||
					!getSiteCode().isValid()) {
				error = true;
				sb.append("Fail to print: AR Aging Analysis Summary (rptArAgingSmy)<br/><br/>");
			}

			if (getSiteCode().getText().trim().length() == 0 || !getSiteCode().isValid()) {
				sb.append("Please supply Site Code.<br/>");
			}
		}

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

		String steCode = getSiteCode().getText().trim();
		String stename = getSiteCode().getDisplayText();
		String startDate = getDateRangeStart().getText().trim();
		String endDate = getDateRangeEnd().getText().trim();
		String arcCode = getARCCode().getText().trim();
		String rptName = null;
		Map<String, String> map = new HashMap<String, String>();
		map.put("SteCode", steCode);
		map.put("SteName", stename);
		map.put("StartDate", startDate);
		map.put("EndDate", endDate);
		map.put("ArCode", arcCode);
		map.put("Rmk0",getARSlipRmk().isSelected()?"1":"0"); 		
		map.put("Rmk1",getARSARmk1().isSelected()?"1":"0"); 
		map.put("Rmk2",getARSARmk2().isSelected()?"1":"0");
		map.put("SUBREPORT_DIR", CommonUtil.getReportDir())
		;
		
		if (getPrinttoScreen().isSelected()) {//use report panel
			//Company AR Non-Patient Transation Report
			if (getCARNPTR().isSelected()) {
				Report.print(Factory.getInstance().getUserInfo(), "RptArAdjust", map,
						new String[] {
							steCode, arcCode, startDate, endDate
						},
						new String[] {
							"DATERANGESTART", "DATERANGEEND", "ARTYPE", "ARCCODE",
							"ARCNAME", "CDATE", "PNUM", "FNAME", "GNAME", "REF",
							"AMT", "PTYPE", "STENAME", "USRID"
						});
			}

			//AR Aging Analysis
			if (getARAA().isSelected()) {
				Report.print(Factory.getInstance().getUserInfo(), "RptArAging", map,
						new String[] {
							getMainFrame().getServerDate(), arcCode, steCode
						},
						new String[] {
							"ARCCODE", "ARCNAME", "PNUM", "PATIENT", "REF",
							"ATXCDATE", "AMT", "STENAME", "PTYPE", "AGE"
						});
			}


			if (getARSA().isSelected()) {
				if (startDate.length() > 0 || endDate.length() > 0) {
					map.put("Title", "AR Billing Listing");
				} else {
					map.put("Title", "Outstanding Account");
				}

				map.put("fileType", fileType);

				if("AMC".equals(steCode)){
					rptName = "RptArStmtAMC";
				}else{
					rptName = "RptArStmt";	
				}
				System.out.println("1[steCode]:"+steCode+";[rptName]:"+rptName);				
				Report.print(Factory.getInstance().getUserInfo(), rptName, map,
						new String[] {
							arcCode, steCode, startDate, endDate 
						},
						new String[] {
								"ARCCODE", "ARCNAME", "ARCADD1", "ARCADD2", "ARCADD3",
								"ARCADD4", "ARCCT", "ARCTITLE", "PTYPE", "PNUM", "FNAME",
								"GNAME", "REF", "BDATE", "ARTYPE", "ORG", "SETTLE",
								"STENAME", "SLPPLYNO", "SLPVCHNO", "SLPREMARK", "BAL",
								"MONTHGROUP", "SORTDATE", "SENDBILLDATE", "PATREFNO", 
								"SLPDATE", "REGDATE", "INPDDAT"
						});
			}

			//AR Aging Analysis Summary
			System.err.println("[getMainFrame().getServerDate()]"+getMainFrame().getServerDate());
			if (getARAAS().isSelected()) {
				Report.print(Factory.getInstance().getUserInfo(), "RptArAgingSmy", map,
						new String[] {
							getMainFrame().getServerDate(), arcCode, steCode
						},
						new String[] {
							"ARCCODE", "ARCNAME", "PTYPE", "CUR", "DAY30",
							"DAY60", "DAY90", "DAY120"
						});
			}
		} else if (getPrinttoFile().isSelected()) {//print xls
			//Company AR Non-Patient Transation Report
			if (getCARNPTR().isSelected()) {
				PrintingUtil.print("", "RptArAdjust", map, "",
						new String[] {
							steCode, arcCode, startDate, endDate
						},
						new String[] {
							"DATERANGESTART", "DATERANGEEND", "ARTYPE", "ARCCODE",
							"ARCNAME", "CDATE", "PNUM", "FNAME", "GNAME", "REF",
							"AMT", "PTYPE", "STENAME", "USRID"
						},
						0, null, null, null, null, 1,
						false, true, new String[] { "xls" });
			}

			//AR Aging Analysis
			if (getARAA().isSelected()) {
				PrintingUtil.print("", "RptArAging", map, "",
						new String[] {
							getMainFrame().getServerDate(), arcCode, steCode
						},
						new String[] {
							"ARCCODE", "ARCNAME", "PNUM", "PATIENT", "REF",
							"ATXCDATE", "AMT", "STENAME", "PTYPE", "AGE"
						},
						0, null, null, null, null, 1,
						false, true, new String[] { "xls" });
			}

			//AR Statement of Account
			if (getARSA().isSelected()) {
				fileType = "XLS";

				if (startDate.length() > 0 || endDate.length() > 0) {
					map.put("Title", "AR Billing Listing");
				} else {
					map.put("Title", "Outstanding Account");
				}

				map.put("fileType", fileType);

				if("AMC".equals(steCode)){
					rptName = "RptArStmtAMC_xls";
				}else{
					rptName = "RptArStmt_xls";	
				}
				System.out.println("4[steCode]:"+steCode+";[rptName]:"+rptName);				
				PrintingUtil.print("", rptName, map, "",
						new String[] {
							arcCode, steCode, startDate, endDate
						},
						new String[] {
								"ARCCODE", "ARCNAME", "ARCADD1", "ARCADD2", "ARCADD3",
								"ARCADD4", "ARCCT", "ARCTITLE", "PTYPE", "PNUM", "FNAME",
								"GNAME", "REF", "BDATE", "ARTYPE", "ORG", "SETTLE",
								"STENAME", "SLPPLYNO", "SLPVCHNO", "SLPREMARK", "BAL",
								"MONTHGROUP", "SORTDATE", "ROW_COUNT", "SENDBILLDATE", "PATREFNO", 
								"SLPDATE", "REGDATE", "INPDDAT"
						},
						0, null, null, null, null, 1,
						false, true, new String[] { "xls" });
			}

			//AR Aging Analysis Summary
			if (getARAAS().isSelected()) {
				PrintingUtil.print("", "RptArAgingSmy", map, "",
						new String[] {
							getMainFrame().getServerDate(), arcCode, steCode
						},
						new String[] {
							"ARCCODE", "ARCNAME", "PTYPE", "CUR", "DAY30",
							"DAY60", "DAY90", "DAY120"
						},
						0, null, null, null, null, 1,
						false, true, new String[] { "xls" });
			}
		} else {//print to printer
			//Company AR Non-Patient Transation Report
			if (getCARNPTR().isSelected()) {
				PrintingUtil.print("RptArAdjust", map, "",
						new String[] {
							steCode, arcCode, startDate, endDate
						},
						new String[] {
							"DATERANGESTART", "DATERANGEEND", "ARTYPE", "ARCCODE",
							"ARCNAME", "CDATE", "PNUM", "FNAME", "GNAME", "REF",
							"AMT", "PTYPE", "STENAME", "USRID"
						});
			}

			//AR Aging Analysis
			if (getARAA().isSelected()) {
				PrintingUtil.print("RptArAging", map, "",
						new String[] {
							getMainFrame().getServerDate(), arcCode, steCode
						},
						new String[] {
							"ARCCODE", "ARCNAME", "PNUM", "PATIENT", "REF",
							"ATXCDATE", "AMT", "STENAME", "PTYPE", "AGE"
						});
			}

			//AR Statement of Account
			if (getARSA().isSelected()) {
				if (startDate.length() > 0 || endDate.length() > 0) {
					map.put("Title", "AR Billing Listing");
				} else {
					map.put("Title", "Outstanding Account");
				}

				map.put("fileType", fileType);

				if("AMC".equals(steCode)){
					rptName = "RptArStmtAMC";
				}else{
					rptName = "RptArStmt";	
				}
				System.out.println("2[steCode]:"+steCode+";[rptName]:"+rptName);				
				PrintingUtil.print("", rptName, map, "",
						new String[] {
							arcCode, steCode, startDate, endDate
						},
						new String[] {
								"ARCCODE", "ARCNAME", "ARCADD1", "ARCADD2", "ARCADD3",
								"ARCADD4", "ARCCT", "ARCTITLE", "PTYPE", "PNUM", "FNAME",
								"GNAME", "REF", "BDATE", "ARTYPE", "ORG", "SETTLE",
								"STENAME", "SLPPLYNO", "SLPVCHNO", "SLPREMARK", "BAL",
								"MONTHGROUP", "SORTDATE", "SENDBILLDATE", "PATREFNO", 
								"SLPDATE", "REGDATE", "INPDDAT"
						});
			}

			//AR Aging Analysis Summary
			if (getARAAS().isSelected()) {
				PrintingUtil.print("", "RptArAgingSmy", map, "",
						new String[] {
							getMainFrame().getServerDate(), arcCode, steCode
						},
						new String[] {
							"ARCCODE", "ARCNAME", "PTYPE", "CUR", "DAY30",
							"DAY60", "DAY90", "DAY120"
						});
			}
		}
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
			rightPanel.setSize(779, 321);
			rightPanel.add(getTextPanel(),null);
			rightPanel.add(getCheckBoxPanel(), null);
			//leftPanel.setSize(800, 530));
		}
		return rightPanel;
	}

	public BasePanel getCheckBoxPanel() {
		if (CheckBoxPanel == null) {
			CheckBoxPanel = new BasePanel();
			CheckBoxPanel.setBorders(true);
			CheckBoxPanel.add(getAROtherPanel(), null);			
			CheckBoxPanel.add(getStatAccPanel(), null);	
/*
			CheckBoxPanel.add(getCARNPTRDesc(), null);
			CheckBoxPanel.add(getCARNPTR(), null);
			CheckBoxPanel.add(getARAADesc(), null);
			CheckBoxPanel.add(getARAA(), null);
			CheckBoxPanel.add(getARSADesc(), null);
			CheckBoxPanel.add(getARSA(), null);
			CheckBoxPanel.add(getARAASDesc(), null);
			CheckBoxPanel.add(getARAAS(), null); * 			
			CheckBoxPanel.add(getARSlipRmkDesc(), null);
			CheckBoxPanel.add(getARSlipRmk(), null);			
			CheckBoxPanel.add(getARSARmk1Desc(), null);
			CheckBoxPanel.add(getARSARmk1(), null);
			CheckBoxPanel.add(getARSARmk2Desc(), null);
			CheckBoxPanel.add(getARSARmk2(), null);
*/			
			CheckBoxPanel.setLocation(5, 24);
			CheckBoxPanel.setSize(769, 150);
		}
		return CheckBoxPanel;
	}
	
	private FieldSetBase getStatAccPanel() {
		if (StatAccPanel == null) {
			StatAccPanel = new FieldSetBase();
			StatAccPanel.setHeading("AR Statement of Account");
			StatAccPanel.setBounds(5, 2, 374, 140);
			StatAccPanel.add(getARSADesc(), null);
			StatAccPanel.add(getARSA(), null);			
			StatAccPanel.add(getARSlipRmkDesc(), null);
			StatAccPanel.add(getARSlipRmk(), null);			
			StatAccPanel.add(getARSARmk1Desc(), null);
			StatAccPanel.add(getARSARmk1(), null);
			StatAccPanel.add(getARSARmk2Desc(), null);
			StatAccPanel.add(getARSARmk2(), null);
		}
		return StatAccPanel;
	}
	
	private FieldSetBase getAROtherPanel() {
		if (AROtherPanel == null) {
			AROtherPanel = new FieldSetBase();
			AROtherPanel.setHeading("AR Report(Others)");
			AROtherPanel.setBounds(384, 2, 374, 140);
			AROtherPanel.add(getCARNPTRDesc(), null);
			AROtherPanel.add(getCARNPTR(), null);
			AROtherPanel.add(getARAADesc(), null);
			AROtherPanel.add(getARAA(), null);
			AROtherPanel.add(getARAASDesc(), null);
			AROtherPanel.add(getARAAS(), null);	
		}
		return AROtherPanel;
	}	

	public LabelBase getCARNPTRDesc() {
		if (CARNPTRDesc == null) {
			CARNPTRDesc = new LabelBase();
			CARNPTRDesc.setText("Company AR Non-Patient Transation Report");
			CARNPTRDesc.setBounds(30, 5, 263, 20);
		}
		return CARNPTRDesc;
	}

	public CheckBoxBase getCARNPTR() {
		if (CARNPTR == null) {
			CARNPTR = new CheckBoxBase();
			CARNPTR.setBounds(5, 5, 23, 20);
		}
		return CARNPTR;
	}

	public LabelBase getARAADesc() {
		if (ARAADesc == null) {
			ARAADesc = new LabelBase();
			ARAADesc.setText("AR Aging Analysis");
			ARAADesc.setBounds(30, 30, 224, 20);
		}
		return ARAADesc;
	}

	public CheckBoxBase getARAA() {
		if (ARAA == null) {
			ARAA = new CheckBoxBase();
			ARAA.setBounds(5, 30, 23, 20);
		}
		return ARAA;
	}

	public LabelBase getARSADesc() {
		if (ARSADesc == null) {
			ARSADesc = new LabelBase();
			ARSADesc.setText("AR Statement of Account");
			ARSADesc.setBounds(30, 5, 250, 20);
		}
		return ARSADesc;
	}

	public CheckBoxBase getARSA() {
		if (ARSA == null) {
			ARSA = new CheckBoxBase(){
				@Override
				public void onClick() {
					if(ARSA.isSelected()){
						getARSlipRmk().setSelected(true);
						getARSARmk1().setSelected(true);
						getARSARmk2().setSelected(true);
					}else{
						getARSlipRmk().setSelected(false);
						getARSARmk1().setSelected(false);
						getARSARmk2().setSelected(false);
					}
				}
			};
			ARSA.setBounds(5, 2, 23, 20);
		}
		return ARSA;
	}
	
	public LabelBase getARSlipRmkDesc() {
		if (ARSlipRmkDesc == null) {
			ARSlipRmkDesc = new LabelBase();
			ARSlipRmkDesc.setText("Show Slip Rmk");
			ARSlipRmkDesc.setBounds(54, 30, 100, 20);
		}
		return ARSlipRmkDesc;
	}	
	
	public CheckBoxBase getARSlipRmk() {
		if (ARSlipRmk == null) {
			ARSlipRmk = new CheckBoxBase();
			ARSlipRmk.setBounds(30, 30, 23, 20);
		}
		return ARSlipRmk;
	}	
	
	public LabelBase getARSARmk1Desc() {
		if (ARSARmk1Desc == null) {
			ARSARmk1Desc = new LabelBase();
			ARSARmk1Desc.setText("Show SendBillDt");
			ARSARmk1Desc.setBounds(54, 55, 100, 20);
		}
		return ARSARmk1Desc;
	}	
	
	public CheckBoxBase getARSARmk1() {
		if (ARSARmk1 == null) {
			ARSARmk1 = new CheckBoxBase();
			ARSARmk1.setBounds(30, 55, 23, 20);
		}
		return ARSARmk1;
	}
	
	public LabelBase getARSARmk2Desc() {
		if (ARSARmk2Desc == null) {
			ARSARmk2Desc = new LabelBase();
			ARSARmk2Desc.setText("Show Ref NO.");
			ARSARmk2Desc.setBounds(54, 80, 100, 20);
		}
		return ARSARmk2Desc;
	}	
	
	public CheckBoxBase getARSARmk2() {
		if (ARSARmk2 == null) {
			ARSARmk2 = new CheckBoxBase();
			ARSARmk2.setBounds(30, 80, 23, 20);
		}
		return ARSARmk2;
	}	

	public LabelBase getARAASDesc() {
		if (ARAASDesc == null) {
			ARAASDesc = new LabelBase();
			ARAASDesc.setText("AR Aging Analysis Summary");
			ARAASDesc.setBounds(30, 55, 224, 20);
		}
		return ARAASDesc;
	}

	public CheckBoxBase getARAAS() {
		if (ARAAS == null) {
			ARAAS = new CheckBoxBase();
			ARAAS.setBounds(5, 55, 23, 20);
		}
		return ARAAS;
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
			TextPanel.add(getPrinttoFileDesc(), null);
			TextPanel.add(getPrinttoFile(), null);
			TextPanel.add(getPrinttoScreenDesc(), null);
			TextPanel.add(getPrinttoScreen(), null);
			TextPanel.setLocation(6, 180);
			TextPanel.setSize(769, 148);
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

	public LabelBase getPrinttoFileDesc() {
		if (PrinttoFileDesc == null) {
			PrinttoFileDesc = new LabelBase();
			PrinttoFileDesc.setText("Print To File");
			PrinttoFileDesc.setBounds(493, 10, 100, 20);
		}
		return PrinttoFileDesc;
	}

	public CheckBoxBase getPrinttoFile() {
		if (PrinttoFile == null) {
			PrinttoFile = new CheckBoxBase() {
				@Override
				public void onClick() {
					if (getPrinttoFile().isSelected()) {
						getPrinttoScreen().setSelected(false);
					}
				}
			};
			PrinttoFile.setBounds(473, 10, 23, 20);
		}
		return PrinttoFile;
	}

	public LabelBase getPrinttoScreenDesc() {
		if (PrinttoScreenDesc == null) {
			PrinttoScreenDesc = new LabelBase();
			PrinttoScreenDesc.setText("Print To Screen");
			PrinttoScreenDesc.setBounds(608, 10, 105, 20);
		}
		return PrinttoScreenDesc;
	}

	public CheckBoxBase getPrinttoScreen() {
		if (PrinttoScreen == null) {
			PrinttoScreen = new CheckBoxBase() {
				@Override
				public void onClick() {
					if (getPrinttoScreen().isSelected()) {
						getPrinttoFile().setSelected(false);
					}
				}
			};
			PrinttoScreen.setBounds(583, 10, 23, 20);
		}
		return PrinttoScreen;
	}
}