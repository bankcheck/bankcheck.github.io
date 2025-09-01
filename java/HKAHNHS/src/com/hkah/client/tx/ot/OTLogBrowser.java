package com.hkah.client.tx.ot;


import java.util.HashMap;
import java.util.Map;

import com.extjs.gxt.ui.client.widget.Component;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.combobox.ComboDoctorAN;
import com.hkah.client.layout.combobox.ComboDoctorEN;
import com.hkah.client.layout.combobox.ComboDoctorSU;
import com.hkah.client.layout.combobox.ComboOTCodeType;
import com.hkah.client.layout.combobox.ComboOTLogStatus;
import com.hkah.client.layout.combobox.ComboOTProc;
import com.hkah.client.layout.combobox.ComboPatientType;
import com.hkah.client.layout.dialog.DlgSecCheck;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.table.GeneralGridCellRenderer;
import com.hkah.client.layout.textfield.TextDateWithCheckBox;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.Report;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class OTLogBrowser extends MasterPanel{

	public OTLogBrowser(BasePanel panelFrom) {
		super();
		this.panelFrom = panelFrom;
	}

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.OTLOGBROWSER_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.OTLOGBROWSER_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				" ",
				"OTLID",
				"A",
				"Operation Date",
				"Start Time",
				"End Time",
				" ",
				"OP RM",
				"Patient No",
				"Patient Name",
				"Type",
				"Age",
				"Procedure Code",
				"Surgeon",
				"Anesthetist",
				"Endoscopist",
				"Status",
				"Remark",
				"FE Req",
				"FE Rec"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				10, 0, 20, 80, 60, 60, 40, 80, 60, 100, 40, 40, 100, 70, 80, 80, 50, 70, 50, 50
		};
	}

	/* >>> ~4b~ Set Table Column Cell Renderer ============================ <<< */
	protected GeneralGridCellRenderer[] getColumnRenderer() {
		return new GeneralGridCellRenderer[] {
				null,
				null,
				new OTAppBseGenAlgyRenderer(),
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null
		};
	}

	private BasePanel panelFrom = null;
	private BasePanel rightPanel = null;
	private BasePanel leftPanel = null;

	private BasePanel ParaPanel = null;
	private LabelBase OperationFromDesc = null;
	private TextDateWithCheckBox OperationFrom = null;
	private LabelBase OperationToDesc = null;
	private TextDateWithCheckBox OperationTo = null;
	private LabelBase StatusDesc = null;
	private ComboOTLogStatus Status = null;
	private LabelBase TypeDesc = null;
	private ComboPatientType Type = null;
	private LabelBase PatNoDesc = null;
	private TextPatientNoSearch PatNo = null;
	private LabelBase PatNameDesc = null;
	private TextReadOnly PatName = null;
	private LabelBase ProcedureDesc = null;
	private ComboOTProc Procedure = null;
	private LabelBase SurgeonDesc = null;
	private ComboDoctorSU Surgeon = null;
	private LabelBase AnesthDesc = null;
	private ComboDoctorAN Anesth = null;
	private LabelBase EndoscopistDesc = null;
	private ComboDoctorEN Endoscopist = null;
	private LabelBase OperRoomDesc = null;
	private ComboOTCodeType OperRoom = null;

	private ButtonBase ReopenLog = null;
	private ButtonBase logReport = null;
	private LabelBase CountDesc = null;
	private TextReadOnly Count = null;

	private DlgSecCheck dlgSecCheck = null;

	/**
	 * This method initializes
	 *
	 */
	public OTLogBrowser() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		setLeftAlignPanel();
		getJScrollPane().setBounds(10, 145, 771, 352);
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
//		getAppendButton().setEnabled(false);
//		getCancelButton().setEnabled(true);
//		getPrintButton().setEnabled(false);
//		getRefreshButton().setEnabled(false);
//		getCancelButton().setEnabled(false);
//		getAcceptButton().setEnabled(false);

		getPatNo().setText(getParameter("PatNo"));
		getOperationFrom().setText(getMainFrame().getServerDate());
		getOperationTo().setText(getMainFrame().getServerDate());

		performListPost();
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public Component getDefaultFocusComponent() {
//		setAllergyCol();
		return getOperationFrom().getDateField();
	}

//	private void setAllergyCol() {
//		getListTable().getCellRenderer(1, 5)
//		getListTable().getCellRenderer()
//		.getTableCellRendererComponent(getListTable(), "888", true, true, 1, 0)
//		.setBackground(Color.RED);
		//NOT finish yet
//		String test = CommonUtil.getCISColor(getUserInfo(), "400711", " ");
//	}

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
		String[] inParm = new String[] {
				getOperationFrom().getText(),
				getOperationTo().getText(),
				getStatus().getText(),
				getPatNo().getText(),
				getProcedure().getText(),
				getPatientType().getText(),
				getSurgeon().getText(),
				getAnesth().getText(),
				getEndoscopist().getText(),
				getOperRoom().getText()
		};

		return inParm;
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
	protected void getBrowseOutputValues(String[] outParam) {
	}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return new String[] {};
	}

	/* >>> ~16.1~ Set Action Output Parameters =========================== <<< */
	@Override
	protected void getNewOutputValue(String returnValue) {}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected void performListPost() {
		// for child class call
		int rowCount = getListTable().getRowCount();
		getCount().setText(String.valueOf(rowCount));
		getReopenLog().setEnabled("C".equals(getStatus().getText()) && rowCount > 0);
		getLogReport().setEnabled(rowCount > 0);
	}

	@Override
	protected void enableButton(String mode) {
		disableButton();
		getSearchButton().setEnabled(true);
		getAcceptButton().setEnabled(getListTable().getRowCount() > 0);
		getClearButton().setEnabled(true);
		getPrintButton().setEnabled(getListTable().getRowCount() > 0);
	}

	@Override
	public void acceptAction() {
		if (getListTable().getRowCount() == 0)
			return;

		setParameter("MODE", "3");//int: ConstantsGlobal.OT_LOG_MODE_EDIT
		setParameter("PATNO", getListSelectedRow()[8] );
		setParameter("OTLID", getListSelectedRow()[1] );

		setParameter("OTSTS", getListSelectedRow()[16]);
		if (panelFrom != null) {
			showPanel(panelFrom, false, true);
		} else {
			showPanel(new com.hkah.client.tx.ot.OTLogBook());
		}
	}

	@Override
	public void clearAction() {
		super.clearAction();
		getOperationFrom().setText(getMainFrame().getServerDate());
		getOperationTo().setText(getMainFrame().getServerDate());
	}

	@Override
	public void printAction() {
		String SteName = getUserInfo().getSiteName();
		String startDate = getOperationFrom().getText().trim();
		String endDate = getOperationTo().getText().trim();

		Map<String,String> map = new HashMap<String,String>();
		map.put("SteName", SteName);
		map.put("StartDate", startDate);
		map.put("EndDate", endDate);

		if (startDate != null && startDate.length() > 0 && endDate != null && endDate.length() > 0) {
			if (Factory.getInstance().getUserInfo().getSiteCode().toUpperCase().equals("HKAH")) {
				PrintingUtil.print("RptOTLogListing", map, "",
						getBrowseInputParameters(),
						new String[] {
							"OTLID",
							"OTLOSDATE",
							"OTLOEDATE",
							"PATNO",
							"PATNAME",
							"PATSEX",
							"BEDNO",
							"OPRM",
							"PATDOB",
							"OTLSPEC",
							"PATTYPE",
							"OTLRMK",
							"OTL_AM_PRIM",
							"OTPNAME",
							"OTLANESMETH",
							"OTLPROC",
							"OTMEMBER",
							"OTFUNCTION",
							"FEREQ",
							"FEREC"});
			} else {
				Report.print(getUserInfo(),
						"RptOTLogListing", map,
						getBrowseInputParameters(),
						new String[] {
								"OTLID",
								"OTLOSDATE",
								"OTLOEDATE",
								"PATNO",
								"PATNAME",
								"PATSEX",
								"BEDNO",
								"OPRM",
								"PATDOB",
								"OTLSPEC",
								"PATTYPE",
								"OTLRMK",
								"OTL_AM_PRIM",
								"OTPNAME",
								"OTLANESMETH",
								"OTLPROC",
								"OTMEMBER",
								"OTFUNCTION",
								"FEREQ",
								"FEREC"});
			}
		}
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	protected void showPatientInfo(String toPatno) {
		if (toPatno.length() > 0) {
			QueryUtil.executeMasterFetch(getUserInfo(), "PATIENTBYNO",
					new String[] {getPatNo().getText()},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						getPatName().setText(mQueue.getContentField()[0] + " " + mQueue.getContentField()[1]);
					} else {
						getPatNo().resetText();
						getPatName().resetText();
					}
				}
			});
		} else {
//			getPatNo().requestFocus();
			getPatName().resetText();
		}
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	@Override
	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.setSize(780, 528);
			leftPanel.add(getParaPanel(), null);
			leftPanel.add(getJScrollPane());
			leftPanel.add(getReopenLog(), null);
			leftPanel.add(getLogReport(), null);
			leftPanel.add(getCountDesc(), null);
			leftPanel.add(getCount(), null);
		}
		return leftPanel;
	}

	protected BasePanel getRightPanel() {

		if (rightPanel == null) {
			rightPanel = new BasePanel();
//			leftPanel.setSize(800, 530));
		}
		return rightPanel;
	}

	public BasePanel getParaPanel() {
		if (ParaPanel == null) {
			ParaPanel = new BasePanel();
			ParaPanel.setBounds(10, 10, 771, 130);
			ParaPanel.setBorders(true);
			ParaPanel.add(getOperationFromDesc(), null);
			ParaPanel.add(getOperationFrom(), null);
			ParaPanel.add(getOperationToDesc(), null);
			ParaPanel.add(getOperationTo(), null);
			ParaPanel.add(getStatusDesc(), null);
			ParaPanel.add(getStatus(), null);
			ParaPanel.add(getTypeDesc(), null);
			ParaPanel.add(getPatientType(), null);
			ParaPanel.add(getPatNoDesc(), null);
			ParaPanel.add(getPatNo(), null);
			ParaPanel.add(getPatNameDesc(), null);
			ParaPanel.add(getPatName(), null);
			ParaPanel.add(getProcedureDesc(), null);
			ParaPanel.add(getProcedure(), null);
			ParaPanel.add(getSurgeonDesc(), null);
			ParaPanel.add(getSurgeon(), null);
			ParaPanel.add(getAnesthDesc(), null);
			ParaPanel.add(getAnesth(), null);
			ParaPanel.add(getEndoscopistDesc(), null);
			ParaPanel.add(getEndoscopist(), null);
			ParaPanel.add(getOperRoomDesc(), null);
			ParaPanel.add(getOperRoom(), null);
		}
		return ParaPanel;
	}

	private LabelBase getOperationFromDesc() {
		if (OperationFromDesc == null) {
			OperationFromDesc = new LabelBase();
			OperationFromDesc.setText("Operation From");
			OperationFromDesc.setBounds(10, 10, 95, 20);
		}
		return OperationFromDesc;
	}

	public TextDateWithCheckBox getOperationFrom() {
		if (OperationFrom == null) {
			OperationFrom = new TextDateWithCheckBox();
			OperationFrom.setBounds(105, 10, 120, 20);
		}
		return OperationFrom;
	}

	private LabelBase getOperationToDesc() {
		if (OperationToDesc == null) {
			OperationToDesc = new LabelBase();
			OperationToDesc.setText("To");
			OperationToDesc.setBounds(240, 10, 68, 20);
		}
		return OperationToDesc;
	}

	public TextDateWithCheckBox getOperationTo() {
		if (OperationTo == null) {
			OperationTo = new TextDateWithCheckBox();
			OperationTo.setBounds(310, 10, 120, 20);
		}
		return OperationTo;
	}

	private LabelBase getStatusDesc() {
		if (StatusDesc == null) {
			StatusDesc = new LabelBase();
			StatusDesc.setText("Status");
			StatusDesc.setBounds(445, 10, 68, 20);
		}
		return StatusDesc;
	}

	public ComboOTLogStatus getStatus() {
		if (Status == null) {
			Status = new ComboOTLogStatus();
			Status.setBounds(518, 10, 85, 20);
		}
		return Status;
	}

	private LabelBase getTypeDesc() {
		if (TypeDesc == null) {
			TypeDesc = new LabelBase();
			TypeDesc.setText("Type");
			TypeDesc.setBounds(615, 10, 41, 20);
		}
		return TypeDesc;
	}

	public ComboPatientType getPatientType() {
		if (Type == null) {
			Type = new ComboPatientType();
			Type.setBounds(651, 10, 105, 20);
//			Type.setSelectedIndex(3);
		}
		return Type;
	}

	private LabelBase getPatNoDesc() {
		if (PatNoDesc == null) {
			PatNoDesc = new LabelBase();
			PatNoDesc.setText("Patient No");
			PatNoDesc.setBounds(9, 40, 95, 20);
		}
		return PatNoDesc;
	}

	private TextPatientNoSearch getPatNo() {
		if (PatNo == null) {
			PatNo = new TextPatientNoSearch() {
				public void onBlur() {
					super.onBlur();
					showPatientInfo(PatNo.getText().trim());
				};
			};
			PatNo.setBounds(105, 40, 120, 20);
		}
		return PatNo;
	}

	private LabelBase getPatNameDesc() {
		if (PatNameDesc == null) {
			PatNameDesc = new LabelBase();
			PatNameDesc.setText("Name");
			PatNameDesc.setBounds(240, 40, 68, 20);
		}
		return PatNameDesc;
	}

	private TextReadOnly getPatName() {
		if (PatName == null) {
			PatName = new TextReadOnly();
			PatName.setBounds(310, 40, 120, 20);
		}
		return PatName;
	}

	private LabelBase getProcedureDesc() {
		if (ProcedureDesc == null) {
			ProcedureDesc = new LabelBase();
			ProcedureDesc.setText("Procedure");
			ProcedureDesc.setBounds(445, 40, 68, 20);
		}
		return ProcedureDesc;
	}

	private ComboOTProc getProcedure() {
		if (Procedure == null) {
			Procedure = new ComboOTProc();
			Procedure.setBounds(518, 40, 238, 20);
		}
		return Procedure;
	}

	private LabelBase getSurgeonDesc() {
		if (SurgeonDesc == null) {
			SurgeonDesc = new LabelBase();
			SurgeonDesc.setText("Surgeon");
			SurgeonDesc.setBounds(9, 70, 95, 20);
		}
		return SurgeonDesc;
	}

	private ComboDoctorSU getSurgeon() {
		if (Surgeon == null) {
			Surgeon = new ComboDoctorSU();
			Surgeon.setBounds(105, 70, 120, 20);
		}
		return Surgeon;
	}

	private LabelBase getAnesthDesc() {
		if (AnesthDesc == null) {
			AnesthDesc = new LabelBase();
			AnesthDesc.setText("Anesthetist");
			AnesthDesc.setBounds(240, 70, 68, 20);
		}
		return AnesthDesc;
	}

	private ComboDoctorAN getAnesth() {
		if (Anesth == null) {
			Anesth = new ComboDoctorAN();
			Anesth.setBounds(310, 70, 120, 20);
		}
		return Anesth;
	}

	private LabelBase getEndoscopistDesc() {
		if (EndoscopistDesc == null) {
			EndoscopistDesc = new LabelBase();
			EndoscopistDesc.setText("Endoscopist");
			EndoscopistDesc.setBounds(445, 70, 68, 20);
		}
		return EndoscopistDesc;
	}

	private ComboDoctorEN getEndoscopist() {
		if (Endoscopist == null) {
			Endoscopist = new ComboDoctorEN();
			Endoscopist.setBounds(518, 70, 238, 20);
		}
		return Endoscopist;
	}

	private LabelBase getOperRoomDesc() {
		if (OperRoomDesc == null) {
			OperRoomDesc = new LabelBase();
			OperRoomDesc.setText("Operation Room");
			OperRoomDesc.setBounds(10, 100, 95, 20);
		}
		return OperRoomDesc;
	}

	private ComboOTCodeType getOperRoom() {
		if (OperRoom == null) {
			OperRoom = new ComboOTCodeType(new String[]{null, null, "Y"});
//			sOperRoom.removeItemAt(4);
			OperRoom.setBounds(105, 100, 120, 20);
			OperRoom.setMinListWidth(150);
		}
		return OperRoom;
	}

	private ButtonBase getReopenLog() {
		if (ReopenLog == null) {
			ReopenLog = new ButtonBase() {
				@Override
				public void onClick() {
					String otlid = getListSelectedRow()[1];
					if (otlid == null || "".equals(otlid)) {
						return;
					}

					getDlgSecCheck().showDialog(otlid);
				}
			};
			ReopenLog.setText("Reopen Log");
			ReopenLog.setBounds(10, 505, 105, 25);
		}
		return ReopenLog;
	}

	private ButtonBase getLogReport() {
		if (logReport == null) {
			logReport = new ButtonBase() {
				@Override
				public void onClick() {
					Map<String, String> map = new HashMap<String, String>();

					PrintingUtil.print("", "RPTOTLOG", map, "",
							getBrowseInputParameters(),
							new String[] {
								"OTLID", "OperationDate", "StartTime", "EndTime",
								"Merged", "OPRM", "PatientNo", "PatientName", "Type", "Age",
								"ProcedureCode", "Surgeon", "Anesthetist", "Endoscopist", "Status", "Remark"
							},
							0, null, null, null, null, 1,
							false, true, new String[] { "xls" });

//					PrintingUtil.print("RPTOTLOG", map, "",
//							new String[] {
//								getOperationFrom().getText(),getOperationTo().getText(),
//								getStatus().getText(),getPatNo().getText(),
//								getProcedure().getText(),
//								getPatientType().getText(),getSurgeon().getText(),
//								getAnesth().getText(),getEndoscopist().getText(),
//								getOperRoom().getText()
//							},
//							new String[] {
//								"OTLID","OperationDate","StartTime",
//								"EndTime"," ","OPRM","PatientNo","PatientName",
//								"Type","Age","Procedure Code","Surgeon","Anesthetist",
//								"Endoscopist","Status","Remark"
//							},true, new String[] { "xls" });

				}
			};
			logReport.setEnabled(false);
			logReport.setText("Print Log Report");
			logReport.setBounds(120, 505, 120, 25);
		}
		return logReport;
	}

	private LabelBase getCountDesc() {
		if (CountDesc == null) {
			CountDesc = new LabelBase();
			CountDesc.setText("Count");
			CountDesc.setBounds(652, 505, 58, 20);
		}
		return CountDesc;
	}

	private TextReadOnly getCount() {
		if (Count == null) {
			Count = new TextReadOnly();
			Count.setBounds(708, 505, 73, 20);
		}
		return Count;
	}

	public DlgSecCheck getDlgSecCheck() {
		if (dlgSecCheck == null) {
			dlgSecCheck = new DlgSecCheck(getMainFrame()) {
				@Override
				public void setVisible(boolean visible) {
					super.setVisible(visible);
					searchAction();
				}
			};
		}
		return dlgSecCheck;
	}
}