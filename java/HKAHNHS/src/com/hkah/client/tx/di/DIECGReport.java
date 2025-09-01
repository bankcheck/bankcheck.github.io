package com.hkah.client.tx.di;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.event.BaseEvent;
import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.DatePickerEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.GridEvent;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.store.ListStore;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.grid.ColumnData;
import com.extjs.gxt.ui.client.widget.grid.Grid;
import com.extjs.gxt.ui.client.widget.grid.GridView;
import com.extjs.gxt.ui.client.widget.grid.CellSelectionModel.CellSelection;
import com.extjs.gxt.ui.client.widget.layout.FitLayout;
import com.google.gwt.dom.client.Element;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.combobox.ComboAppRoomType;
import com.hkah.client.layout.combobox.ComboAppSortby;
import com.hkah.client.layout.combobox.ComboDoctorAN;
import com.hkah.client.layout.combobox.ComboDoctorEN;
import com.hkah.client.layout.combobox.ComboDoctorSU;
import com.hkah.client.layout.combobox.ComboOTCodeType;
import com.hkah.client.layout.combobox.ComboOTLogStatus;
import com.hkah.client.layout.combobox.ComboOTProc;
import com.hkah.client.layout.combobox.ComboOTStatus;
import com.hkah.client.layout.combobox.ComboPatientType;
import com.hkah.client.layout.dialog.DlgDoctorInactive;
import com.hkah.client.layout.dialog.DlgOTAppCancelReasonSel;
import com.hkah.client.layout.dialog.DlgSecCheck;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.panel.TabbedPaneBase;
import com.hkah.client.layout.table.GeneralGridCellRenderer;
import com.hkah.client.layout.table.MultiCellSelectionModel;
import com.hkah.client.layout.table.TableData;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextDateTimeWithoutSecond;
import com.hkah.client.layout.textfield.TextDateTimeWithoutSecondWithCheckBox;
import com.hkah.client.layout.textfield.TextDateWithCheckBox;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.tx.ot.NewEditOTApp;
import com.hkah.client.tx.ot.OTAppBseGenAlgyRenderer;
import com.hkah.client.tx.ot.OTLogBook;
import com.hkah.client.tx.registration.PatientStatView;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.Report;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsGlobal;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DIECGReport extends MasterPanel{

	public DIECGReport(BasePanel panelFrom) {
		super();
		this.panelFrom = panelFrom;
	}

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.DIECGREPORT_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.DIECGREPORT_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Report"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				100
		};
	}

	/* >>> ~4b~ Set Table Column Cell Renderer ============================ <<< */
	protected GeneralGridCellRenderer[] getColumnRenderer() {
		return new GeneralGridCellRenderer[] {
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

	/**
	 * This method initializes
	 *
	 */
	public DIECGReport() {
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
		getPatNo().setText(getParameter("PatNo"));
		getOperationFrom().setText(getMainFrame().getServerDate());
		getOperationTo().setText(getMainFrame().getServerDate());

		getCount().setText(ZERO_VALUE);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public Component getDefaultFocusComponent() {
		return getOperationFrom().getDateField();
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
					if (otlid == null || "".equals(otlid))
						return;
					/*
					DlgSecCheck jdialog = new DlgSecCheck(getMainFrame(), otlid) {
						@Override
						public void setVisible(boolean visible) {
							super.setVisible(visible);
							searchAction();
						}
					};
					
					jdialog.setResizable(false);
					jdialog.setVisible(true);
					*/
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
}