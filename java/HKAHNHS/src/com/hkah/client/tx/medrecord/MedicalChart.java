package com.hkah.client.tx.medrecord;

import java.util.HashMap;
import java.util.Map;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.dialog.DlgMRAdd;
import com.hkah.client.layout.dialog.DlgMRAmend;
import com.hkah.client.layout.dialog.DlgMRMoveHist;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.panel.TabbedPaneBase;
import com.hkah.client.layout.table.BufferedTableList;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsGlobal;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class MedicalChart extends MasterPanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.MEDCHART_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.MEDCHART_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"",
				"Record ID","",
				"User","",
				"Storage Location","",
				"Current Location","",
				"Doctor",
				"Remarks","",
				"Media Type","",
				"Chart Status",
				"At",
				"","","","","",""
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				10,
				80,0,
				100,0,
				120,0,
				120,0,
				120,
				120,0,
				100,0,
				100,
				120,
				0,0,0,0,0,0
		};
	}

	// property declare start
	private BasePanel rightPanel = null;
	private TabbedPaneBase tabbedpane = null;
	private BasePanel leftPanel = null;
	private BasePanel paraPanel = null;
	private BasePanel listPanel = null;
	private LabelBase patNoDesc = null;
	private TextPatientNoSearch patNo = null;
	private LabelBase patNameDesc = null;
	private TextReadOnly patName = null;
	private LabelBase patCNameDesc = null;
	private TextReadOnly patCName = null;
	private LabelBase patSexDesc = null;
	private TextReadOnly patSex = null;
	private LabelBase HKIDDesc = null;
	private TextReadOnly HKID = null;
	private LabelBase DOBDesc = null;
	private TextReadOnly DOB = null;
	private LabelBase showHistoryDesc = null;
	private CheckBoxBase showHistory = null;
	private JScrollPane listScrollPane = null;
	private LabelBase recordIDDesc = null;
	private TextReadOnly recordID = null;
	private JScrollPane historyScrollPane = null;
	private BasePanel historyPanel = null;
	private BufferedTableList historyListTable = null;
	private ButtonBase dispatchAction = null;
	private ButtonBase ReceiveAction = null;
	private ButtonBase recordViewTabBtn = null;
	private ButtonBase recordHistoryTabBtn = null;
	private ButtonBase moveHistoryButton = null;
	private ButtonBase deleteHistoryButton = null;

	private DlgMRAdd dlgAdd = null;
	private DlgMRAmend dlgAmend = null;
	private DlgMRMoveHist dlgMRMoveHist = null;

	private boolean showPatient = false;
	private String currentPatNo = null;
//	protected boolean isFucntionKey = false;

	/**
	 * This method initializes
	 *
	 */
	public MedicalChart() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		setLeftAlignPanel();
/*
		this.addListener(Events.OnKeyDown, new Listener<BoxComponentEvent>() {
			@Override
			public void handleEvent(BoxComponentEvent be) {
				// TODO Auto-generated method stub
				//getPatNo().resetText();
				if (Factory.getInstance().isFunctionKey(be.getEvent().getKeyCode()) ||
						be.getEvent().getKeyCode() == 9) {
					if (be.getEvent().getAltKey() || be.getEvent().getCtrlKey() ||
							be.getEvent().getShiftKey()) {
						isFucntionKey = true;
					}
					return;
				}

				if (isFucntionKey) {
					isFucntionKey = false;
					return;
				}

				if (getTabbedpane().getSelectedIndex() == 1) {
					getTabbedpane().setSelectedIndex(0);
				}
				Factory.getInstance().writeLogToLocal("[MedicalChart - onKeyDownEvent]getPatNo().isFocusOwner(): "+getPatNo().isFocusOwner());
				Factory.getInstance().writeLogToLocal("[MedicalChart - onKeyDownEvent]currentPatNo: "+currentPatNo);
				if (!getPatNo().isFocusOwner()) {
					if (getPatNo().getText().length() > 0) {
						getPatNo().resetText();
					}
					getPatNo().focus();
				}

				if (currentPatNo != null && currentPatNo.length() > 0) {
					// clear field
					currentPatNo = null;
					getPatNo().resetText();
					getPatNo().onBlur();
				}
			}
		});
*/
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		// clean up
		resetCurrentFields();

		getTabbedpane().setSelectedIndex(0);
		getDispatchAction().setVisible(!isDisableFunction("cmdDispatch", "medRecMain"));
		getReceiveAction().setVisible(!isDisableFunction("cmdReceive", "medRecMain"));
		
		getMoveHistoryButton().setVisible(false);
		getDeleteHistoryButton().setVisible(false);

		getPatNo().focus();

//		getListTable().addMouseListener(getListTableListener());

//		getListTable().setColumnClass(4,new ComboMedChartStatus(), false);
//		getListTable().setColumnClass(5,new ComboMedChartStatus(), false);
//		getListTable().setColumnClass(9,new ComboMedMediaType(), false);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public Component getDefaultFocusComponent() {
		return getPatNo();
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
		Factory.getInstance().writeLogToLocal("[MedicalChart - browseValidation]getPatNo().isEmpty(): "+getPatNo().isEmpty());
		if (getPatNo().isEmpty()) {
			getPatNo().setErrorField(true);
			getPatNo().focus();
			//Factory.getInstance().addErrorMessage(ConstantsGlobal.MSG_PATNO_NO_BLANK, getPatNo());
			return false;
		}

		return true;
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
				getPatNo().getText().trim(),
				getShowHistory().isSelected()? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE
		};
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
		enableButton();
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
	 * Helper Methods
	 **************************************************************************/

	private DlgMRAdd getDlgMRAdd() {
		if (dlgAdd == null) {
			dlgAdd = new DlgMRAdd(getMainFrame()) {
				@Override
				public void dispose() {
					super.dispose();
					getAppendButton().setEnabled(true);					
					Factory.getInstance().writeLogToLocal("[MedicalChart - getDlgMRAdd]Show Patient Info");
					showPatInfo();
				}
			};
		}
		return dlgAdd;
	}

	private DlgMRAmend getDlgMRAmend() {
		if (dlgAmend == null) {
			dlgAmend = new DlgMRAmend(getMainFrame()) {
				@Override
				public void dispose() {
					super.dispose();
					Factory.getInstance().writeLogToLocal("[MedicalChart - getDlgMRAmend]Show Patient Info");
					showPatInfo();
				}
			};
		}
		return dlgAmend;
	}

	private void updateMecRec() {
		if (getListTable().getRowCount() > 0) {
			getDlgMRAmend().showDialog(
					getActionType(),
					getPatNo().getText(),
					getPatName().getText(),
					getListSelectedRow()
			);
//			searchAction();
		}
	}

	private void showPatInfo() {
		Factory.getInstance().writeLogToLocal("[MedicalChart - showPatInfo]Show Patient Info");
		Factory.getInstance().writeLogToLocal("[MedicalChart - showPatInfo]currentPatNo: " + currentPatNo);
		Factory.getInstance().writeLogToLocal("[MedicalChart - showPatInfo]getPatNo().getText(): " + getPatNo().getText());

		if (currentPatNo == null || !getPatNo().getText().trim().equals(currentPatNo)) {
			resetSearchResult();

			if (!getPatNo().isEmpty()) {
				QueryUtil.executeMasterFetch(getUserInfo(), "PATIENTBYNO",
						new String[] { getPatNo().getText().trim() },
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							getPatName().setText(mQueue.getContentField()[0] + " " + mQueue.getContentField()[1]);
							getHKID().setText(mQueue.getContentField()[2]);
							getPatCName().setText(mQueue.getContentField()[6]);
							getDOB().setText(mQueue.getContentField()[3]);
							getPatSex().setText(mQueue.getContentField()[5]);

							showPatient = true;
							currentPatNo = getPatNo().getText().trim();

							enableButton();
							searchAction(true);
						}
					}
				});
			}
		} else {
			searchAction(true);
		}
	}

	private void getHistInfo() {
		getRecordID().reset();
		getHistoryListTable().removeAllRow();

		if (getListTable().getRowCount() > 0) {
			getRecordID().setText(getListSelectedRow()[1]);
			String[] inParam = new String[] {
					getListSelectedRow()[16], //mrhid
					showHistory.isSelected()? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE
			};
			getHistoryListTable().setListTableContent(ConstantsTx.MEDRCDHIS_TXCODE, inParam);
		}
	}

	private void resetSearchResult() {
		getPatName().resetText();
		getPatCName().resetText();
		getPatSex().resetText();
		getDOB().resetText();
		getHKID().resetText();

		getListTable().removeAllRow();
		getHistoryListTable().removeAllRow();

		showPatient = false;
		currentPatNo = null;
	}
	
	private DlgMRMoveHist getDlgMRMoveHist() {
		if (dlgMRMoveHist == null) {
			dlgMRMoveHist = new DlgMRMoveHist(this.getMainFrame(), currentPatNo) {
				@Override
				public void dispose() {
					super.dispose();
					searchAction();
					getTabbedpane().setSelectedIndex(1);
				}
			};
		}
		return dlgMRMoveHist;
	}

	/***************************************************************************
	 * Override Methods
	 **************************************************************************/

	@Override
	protected void enableButton(String mode) {
		boolean showTable = getListTable().getRowCount() > 0;

		disableButton();
		getSearchButton().setEnabled(true);
		getAppendButton().setEnabled(showPatient && !isDisableFunction("TB_INSERT", "medRecMain"));
		getModifyButton().setEnabled(showPatient && showTable &&
										getListTable().getSelectedRow() != -1 &&
										!getListTable().getSelectedRowContent()[13].equals("P") &&
										!isDisableFunction("TB_MODIFY", "medRecMain"));
		getDeleteButton().setEnabled(showPatient && showTable &&
										getListTable().getSelectedRow() != -1 &&
										!getListTable().getSelectedRowContent()[13].equals("P") &&
										!getListTable().getSelectedRowContent()[13].equals("D") &&
										!isDisableFunction("TB_DELETE", "medRecMain"));
		getClearButton().setEnabled(true);
		getPrintButton().setEnabled(showTable);
	}

	@Override
	protected void performListPost() {
		defaultFocus();
	}

	@Override
	public void searchAction() {
		Factory.getInstance().writeLogToLocal("[MedicalChart - searchAction]Show Patient Info");
		showPatInfo();
		super.searchAction();
	}

	@Override
	protected void searchPostAction() {
		super.searchPostAction();
		getTabbedpane().setSelectedIndex(0);
		if (getListTable().getRowCount() > 0) {
			getListTable().setSelectRow(0);
		}
	}

	@Override
	public void appendAction() {
		getAppendButton().setEnabled(false);
		getDlgMRAdd().showDialog(getPatNo().getText().trim(), getPatName().getText().trim());
//		searchAction();
	}

	@Override
	public void modifyAction() {
		if (ConstantsGlobal.MEDICAL_RECORD_PERMANENT.equals( getListSelectedRow()[13])) {
			return;
		}
		setActionType(QueryUtil.ACTION_MODIFY);
		updateMecRec();
	}

	@Override
	public void deleteAction() {
		if (ConstantsGlobal.MEDICAL_RECORD_PERMANENT.equals( getListSelectedRow()[13]) ||
				ConstantsGlobal.MEDICAL_RECORD_DELETE.equals( getListSelectedRow()[13])) {
			return;
		}
		setActionType(QueryUtil.ACTION_DELETE);
		updateMecRec();
	}

	@Override
	public void printAction() {
		final boolean isasterisk = "YES".equals(getSysParameter("Chk*"));
		final boolean isChkDigit = "YES".equals(getSysParameter("ChkDigit"));
		String tempChkDigit = "#";
		if (isChkDigit) {
			if (getListSelectedRow()[1] != null
				&& !"".equals(getListSelectedRow()[1].trim())) {
				tempChkDigit = PrintingUtil.generateCheckDigit("-C/"+getListSelectedRow()[1].trim()).toString()+"#";
			}
		}
		Map<String,String> map = new HashMap<String,String>();
		map.put("recordID",getListSelectedRow()[1]+tempChkDigit);
		//map.put("ChkDigit",tempChkDigit);
		map.put("isasterisk",getSysParameter("Chk*"));
		map.put("isChkDigit",getSysParameter("ChkDigit"));

		PrintingUtil.print(getMainFrame().getSysParameter("PRTRLBL"),"MedChartLbl",
				map,null);

		defaultFocus();
	}

	@Override
	protected boolean triggerSearchField() {
		Factory.getInstance().writeLogToLocal("[MedicalChart - triggerSearchField]Set currentPatNo = "+getPatNo().getText().trim());
		currentPatNo = getPatNo().getText().trim();

		Factory.getInstance().writeLogToLocal("[MedicalChart - triggerSearchField]Patient No field focus: "+getPatNo().isFocusOwner());
		if (getPatNo().isFocusOwner()) {
			getPatNo().checkTriggerBySearchKey();
			return true;
		} else {
			return false;
		}
	}

	@Override
	protected void focusComponentAfterSearch() {
		defaultFocus();
	}

	@Override
	protected void resetCurrentFields() {
		getPatNo().resetText();
		resetSearchResult();
	}

	/***************************************************************************
	 * Layout Methods
	 **************************************************************************/

	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.setSize(779, 728);
			leftPanel.add(getParaPanel(), null);
			leftPanel.add(getTabbedpane(), null);
			leftPanel.add(getShowHistoryDesc(), null);
			leftPanel.add(getShowHistory(), null);
			leftPanel.add(getDispatchAction(), null);
			leftPanel.add(getReceiveAction(), null);
			leftPanel.add(getMoveHistoryButton(), null);
			leftPanel.add(getDeleteHistoryButton(), null);
			leftPanel.add(getRecordViewButton(), null);
			leftPanel.add(getRecordHistoryButton(), null);
		}
		return leftPanel;
	}

	protected BasePanel getRightPanel() {

		if (rightPanel == null) {
			rightPanel = new BasePanel();
			//leftPanel.setSize(800, 530));
		}
		return rightPanel;
	}

	public BasePanel getParaPanel() {
		if (paraPanel == null) {
			paraPanel = new BasePanel();
			paraPanel.setLocation(5, 5);
			paraPanel.setSize(757, 40);
			paraPanel.setEtchedBorder();
			paraPanel.add(getPatNoDesc(), null);
			paraPanel.add(getPatNo(), null);
			paraPanel.add(getPatNameDesc(), null);
			paraPanel.add(getPatName(), null);
			paraPanel.add(getPatCNameDesc(), null);
			paraPanel.add(getPatCName(), null);
			paraPanel.add(getPatSexDesc(), null);
			paraPanel.add(getPatSex(), null);
			paraPanel.add(getHKIDDesc(), null);
			paraPanel.add(getHKID(), null);
			paraPanel.add(getDOBDesc(), null);
			paraPanel.add(getDOB(), null);
		}
		return paraPanel;
	}

	public LabelBase getPatNoDesc() {
		if (patNoDesc == null) {
			patNoDesc = new LabelBase();
			patNoDesc.setText("Patient No.");
			patNoDesc.setBounds(5, 10, 70, 20);
		}
		return patNoDesc;
	}

	public TextPatientNoSearch getPatNo() {
		if (patNo == null) {
			patNo = new TextPatientNoSearch(true, true) {
				@Override
				public void onBlur() {
					super.onBlur();
					if (getPatNo().isEmpty() && currentPatNo != null) {
						clearAction();
					}
				}

				@Override
				public void onBlurPost() {
					Factory.getInstance().writeLogToLocal("[MedicalChart]Call Search from onBlurPost......");
					showPatInfo();
				}

				@Override
				public void onPressed() {
					if (currentPatNo != null && currentPatNo.length() > 0) {
						// clear field
						clearAction();
					}
				}

				@Override
				protected void checkPatient(boolean isExistPatient, boolean bySearchKey) {
					if (!isExistPatient && !bySearchKey) {
						clearAction();
					} else {
						super.checkPatient(isExistPatient, bySearchKey);
					}
				}

				@Override
				protected void actionAfterOK() {
					Factory.getInstance().writeLogToLocal("[MedicalChart]Call Search from actionAfterOK......");
					showPatInfo();
				}
			};
			patNo.setBounds(73, 10, 80, 20);
		}
		return patNo;
	}

	public LabelBase getPatNameDesc() {
		if (patNameDesc == null) {
			patNameDesc = new LabelBase();
			patNameDesc.setText("Name");
			patNameDesc.setBounds(158, 10, 40, 20);
		}
		return patNameDesc;
	}

	public TextReadOnly getPatName() {
		if (patName == null) {
			patName = new TextReadOnly();
			patName.setBounds(201, 10, 110, 20);
		}
		return patName;
	}

	public LabelBase getPatCNameDesc() {
		if (patCNameDesc == null) {
			patCNameDesc = new LabelBase();
			patCNameDesc.setText("C.Name");
			patCNameDesc.setBounds(316, 10, 50, 20);
		}
		return patCNameDesc;
	}

	public TextReadOnly getPatCName() {
		if (patCName == null) {
			patCName = new TextReadOnly();
			patCName.setBounds(369, 10, 70, 20);
		}
		return patCName;
	}

	public LabelBase getPatSexDesc() {
		if (patSexDesc == null) {
			patSexDesc = new LabelBase();
			patSexDesc.setText("Sex");
			patSexDesc.setBounds(444, 10, 30, 20);
		}
		return patSexDesc;
	}

	public TextReadOnly getPatSex() {
		if (patSex == null) {
			patSex = new TextReadOnly();
			patSex.setBounds(477, 10, 30, 20);
		}
		return patSex;
	}

	public LabelBase getHKIDDesc() {
		if (HKIDDesc == null) {
			HKIDDesc = new LabelBase();
			HKIDDesc.setText("HKID");
			HKIDDesc.setBounds(512, 10, 40, 20);
		}
		return HKIDDesc;
	}

	public TextReadOnly getHKID() {
		if (HKID == null) {
			HKID = new TextReadOnly();
			HKID.setBounds(555, 10, 70, 20);
		}
		return HKID;
	}

	public LabelBase getDOBDesc() {
		if (DOBDesc == null) {
			DOBDesc = new LabelBase();
			DOBDesc.setText("D.O.B");
			DOBDesc.setBounds(630, 10, 40, 20);
		}
		return DOBDesc;
	}

	public TextReadOnly getDOB() {
		if (DOB == null) {
			DOB = new TextReadOnly();
			DOB.setBounds(673, 10, 75, 20);
		}
		return DOB;
	}

	public TabbedPaneBase getTabbedpane() {
		if (tabbedpane == null) {
			tabbedpane = new TabbedPaneBase() {
				public void onStateChange() {
					if (tabbedpane.getSelectedIndex() == 1) {
						if (getPatNo().isEmpty()) {
							setSelectedIndexWithoutStateChange(0);
							return;
						}

						getHistInfo();
						getDispatchAction().setVisible(false);
						getReceiveAction().setVisible(false);
						getMoveHistoryButton().setVisible(!isDisableFunction("cmdMovHist", "medRecMain"));
						getDeleteHistoryButton().setVisible(!isDisableFunction("cmdDelHist", "medRecMain"));
					} else {
						getDispatchAction().setVisible(!isDisableFunction("cmdDispatch", "medRecMain"));
						getReceiveAction().setVisible(!isDisableFunction("cmdReceive", "medRecMain"));
						getMoveHistoryButton().setVisible(false);
						getDeleteHistoryButton().setVisible(false);

						if (getListTable().getSelectedRow() != -1 && getListTable().getRowCount() > 0) {
							getListTable().setSelectRow(0);
						}
					}
					getPatNo().focus();
				}
			};
			tabbedpane.setBounds(5, 50, 757, 420);
			tabbedpane.addTab("Patient Record <u>V</u>iew", getListPanel());
			tabbedpane.addTab("Patient Record <u>H</u>istory", getHistoryPanel());
		}
		return tabbedpane;
	}

	public BasePanel getListPanel() {
		if (listPanel == null) {
			listPanel = new BasePanel();
			listPanel.setEtchedBorder();
			listPanel.add(getListScrollPanel());
		}
		return listPanel;
	}

	public LabelBase getShowHistoryDesc() {
		if (showHistoryDesc == null) {
			showHistoryDesc = new LabelBase();
			showHistoryDesc.setText("Show History");
			showHistoryDesc.setBounds(580, 52, 100, 20);
		}
		return showHistoryDesc;
	}

	public CheckBoxBase getShowHistory() {
		if (showHistory == null) {
			showHistory = new CheckBoxBase() {
				public void onClick() {
					tabbedpane.setSelectedIndex(0);
					showPatInfo();
				}
			};
			showHistory.setBounds(555, 52, 25, 20);
		}
		return showHistory;
	}

	public JScrollPane getListScrollPanel() {
		if (listScrollPane == null) {
			listScrollPane = new JScrollPane();
			getJScrollPane().removeViewportView(getListTable());
			listScrollPane.setViewportView(getListTable());
			listScrollPane.setBounds(5, 5, 745, 380);
		}
		return listScrollPane;
	}

	public LabelBase getRecordIDDesc() {
		if (recordIDDesc == null) {
			recordIDDesc = new LabelBase();
			recordIDDesc.setText("Record ID");
			recordIDDesc.setBounds(15, 10, 80, 20);
		}
		return recordIDDesc;
	}

	public TextReadOnly getRecordID() {
		if (recordID == null) {
			recordID = new TextReadOnly();
			recordID.setBounds(100, 10, 120, 20);
		}
		return recordID;
	}

	public JScrollPane getHistoryScrollPane() {
		if (historyScrollPane == null) {
			historyScrollPane = new JScrollPane();
			historyScrollPane.setViewportView(getHistoryListTable());
			historyScrollPane.setBounds(5, 45, 733, 325);
		}
		return historyScrollPane;
	}

	public BasePanel getHistoryPanel() {
		if (historyPanel == null) {
			historyPanel = new BasePanel();
			historyPanel.setEtchedBorder();
			historyPanel.setBounds(5, 5, 745, 380);
			historyPanel.add(getHistoryScrollPane());
			historyPanel.add(getRecordIDDesc(), null);
			historyPanel.add(getRecordID(), null);
		}
		return historyPanel;
	}

	protected String[] getHistoryColumnNames() {
		return new String[] {
			"","","",
			"Activity",
			"Date/Time","",
			"Dispatch","",
			"Doctor",
			"Remarks","",
			"Return",
			"Return Date/Time",
			"Request Location","",
			"Media Type","",
			"User"
		};
	}

	protected int[] getHistoryColumnWidths() {
		return new int[] {
				10,0,0,
				70,
				120,0,
				100,0,
				80,
				150,0,
				80,
				120,
				110,0,
				100,0,
				110
		};
	}

	public BufferedTableList getHistoryListTable() {
		if (historyListTable == null) {
			historyListTable = new BufferedTableList(getHistoryColumnNames(), getHistoryColumnWidths()) {
				@Override
				public void setListTableContentPost() {
					defaultFocus();
				}
			};
			historyListTable.setTableLength(getListWidth());
		}
		return historyListTable;
	}

	public ButtonBase getDispatchAction() {
		if (dispatchAction == null) {
			dispatchAction = new ButtonBase() {
				@Override
				public void onClick() {
					showPanel(new MedicalRecordDispatch());
				}
			};
			dispatchAction.setText("Dispatch/Batch Transfer", 'D');
			dispatchAction.setBounds(5, 475, 180, 25);
		}
		return dispatchAction;
	}

	public ButtonBase getReceiveAction() {
		if (ReceiveAction == null) {
			ReceiveAction = new ButtonBase() {
				@Override
				public void onClick() {
					showPanel(new MedicalRecordReceive());
				}
			};
			ReceiveAction.setText("Receive/Batch Transfer", 'R');
			ReceiveAction.setBounds(190, 475, 180, 25);
		}
		return ReceiveAction;
	}

	private ButtonBase getRecordViewButton() {
		if (recordViewTabBtn == null) {
			recordViewTabBtn = new ButtonBase() {
				public void onClick() {
					getTabbedpane().setSelectedIndex(0);
					defaultFocus();
				}
			};
			recordViewTabBtn.setVisible(false);
			recordViewTabBtn.setHotkey('V');
		}
		return recordViewTabBtn;
	}

	private ButtonBase getRecordHistoryButton() {
		if (recordHistoryTabBtn == null) {
			recordHistoryTabBtn = new ButtonBase() {
				public void onClick() {
					getTabbedpane().setSelectedIndex(1);
					defaultFocus();
				}
			};
			recordHistoryTabBtn.setVisible(false);
			recordHistoryTabBtn.setHotkey('H');
		}
		return recordHistoryTabBtn;
	}
	
	public ButtonBase getMoveHistoryButton() {
		if (moveHistoryButton == null) {
			moveHistoryButton = new ButtonBase() {
				@Override
				public void onClick() {
					String thisVol = null;
					try {
						thisVol = getRecordID().getText().split("/")[1];
					} catch (Exception ex) {
						System.err.println("cannot split volume by " + getRecordID().getText());
					}
					String mrdid = getHistoryListTable().getSelectedRowContent()[1];
					getDlgMRMoveHist().showDialog(currentPatNo, thisVol, mrdid);
				}
			};
			moveHistoryButton.setText("Move History", 'M');
			moveHistoryButton.setBounds(5, 475, 180, 25);
		}
		return moveHistoryButton;
	}
	
	public ButtonBase getDeleteHistoryButton() {
		if (deleteHistoryButton == null) {
			deleteHistoryButton = new ButtonBase() {
				@Override
				public void onClick() {
					final String mrdid = getHistoryListTable().getSelectedRowContent()[1];
					String mrdddate = getHistoryListTable().getSelectedRowContent()[4];
					
					MessageBoxBase.confirm("Confirm", "Are you sure to DELETE record date/time at: " + mrdddate + " ?",
							new Listener<MessageBoxEvent>() {
						@Override
						public void handleEvent(MessageBoxEvent be) {
							if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
								QueryUtil.executeMasterAction(getUserInfo(), ConstantsTx.MEDRECDTL_MOV_TXCODE, QueryUtil.ACTION_DELETE,
										new String[] { 
											currentPatNo,
											mrdid,
											null
										},
										new MessageQueueCallBack() {
									@Override
									public void onPostSuccess(MessageQueue mQueue) {
										if (mQueue.success()) {
											Factory.getInstance().addErrorMessage(mQueue.getReturnMsg());
											searchAction();
											getTabbedpane().setSelectedIndex(1);
										} else {
											Factory.getInstance().addErrorMessage("Cannot delete selected record. Error: " + mQueue.getReturnMsg() + " [" + mQueue.getReturnCode() + "]");
										}
									}
								});
							}
						}
					});
				}
			};
			deleteHistoryButton.setText("Delete History", 'D');
			deleteHistoryButton.setBounds(190, 475, 180, 25);
		}
		return deleteHistoryButton;
	}

}