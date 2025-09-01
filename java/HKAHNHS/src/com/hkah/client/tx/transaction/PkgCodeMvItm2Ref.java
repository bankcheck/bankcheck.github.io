package com.hkah.client.tx.transaction;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.event.BaseEvent;
import com.extjs.gxt.ui.client.event.EventType;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.FieldEvent;
import com.extjs.gxt.ui.client.event.GridEvent;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.store.ListStore;
import com.extjs.gxt.ui.client.widget.form.Field;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboDeptServ;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.table.TableData;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.ActionPanel;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TableUtil;


public class PkgCodeMvItm2Ref extends ActionPanel {

	private BasePanel rightPanel = null;
	private BasePanel patAndItemDetailPanel = null;
	private BasePanel suppPanel = null;

	private LabelBase RightJLabel_PatientNum = null;
	private TextReadOnly RightJText_PatientNum = null;
	private LabelBase RightJLabel_PatientName = null;
	private TextReadOnly RightJText_PatientName = null;
	private TextReadOnly RightJText_PatientCName = null;
	private LabelBase RightJLabel_PatientSex = null;
	private TextReadOnly RightJText_PatientSex = null;
	private LabelBase RightJLabel_ChargeCode = null;
	private TextReadOnly RightJText_ChargeCode = null;
	private LabelBase RightJLabel_ChargeName = null;
	private TextReadOnly RightJText_ChargeName = null;
	private TextReadOnly RightJText_StnID = null;

	private LabelBase RightJLabel_PkgCode = null;
	private TextString pkgCode = null;
	private LabelBase RightJLabel_ServCode = null;
	private ComboDeptServ ServCode = null;
	private ButtonBase BtnMoveAll = null;
	private LabelBase RightJLabel_ShowPkg = null;
	private CheckBoxBase RightJCheckBox_ShowPkg = null;
	private LabelBase RightJLabel_AvailableChg = null;
	private TableList RightJTable_AvailableChg = null;
	private LabelBase RightJLabel_SelectedChg = null;
	private TableList RightJTable_SelectedChg = null;

	private LinkedList<Integer> editGridColIdx = null;

	private String stnID = null;
	private String patNo = null;
	private String patName = null;
	private String patCName = null;
	private String patSex = null;
	private String itmCode = null;
	private String itmDesc = null;
	private String slpNo = null;
	private String docCode_O = null;
	private String docCode_T = null;

	private int prevSelectedRow = -1;
	private int prevSelectedCol = -1;
	private boolean validating = false;
	private int orgSelectedChgRow = 0;
	private boolean isDocChecking = false;

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		return null;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return "Move Package to Ref(x)";
	}

	public PkgCodeMvItm2Ref() {
		super();
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		patNo = getParameter("PatNo");
		patName = getParameter("PatName");
		patCName = getParameter("PatCName");
		patSex = getParameter("PatSex");
		slpNo = getParameter("SlpNo");
		disableButton();
		getModifyButton().setEnabled(true);

		getPkgCode().setEnabled(false);
		getRightJTable_AvailableChg().setEnabled(true);
		getRightJTable_SelectedChg().setEnabled(true);

		getRightJText_PatientNum().setText(patNo);
		getRightJText_PatientName().setText(patName);
		getRightJText_PatientCName().setText(patCName);
		getRightJText_PatientSex().setText(patSex);
		getRightJText_ChargeCode().setText(itmCode);
		getRightJText_ChargeName().setText(itmDesc);
		getRightJCheckBox_ShowPkg().setSelected(false);
		getBtnMoveAll().setEnabled(false);
		getRightJTable_AvailableChg().setListTableContent("TRANSACTION_SUBDTLFRPG",
				new String[] { slpNo,getRightJCheckBox_ShowPkg().isSelected()?"Y":"N",getServCode().getText(),
						Factory.getInstance().getUserInfo().getUserID()});
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextString getDefaultFocusComponent() {
		return getPkgCode();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {
		disableButton();
		getPkgCode().setEnabled(true);
		getRightJTable_AvailableChg().setEnabled(true);
		getRightJTable_SelectedChg().setEnabled(true);
		getModifyButton().setEnabled(true);

		ArrayList listeners = (ArrayList)getRightJTable_AvailableChg().getListeners(Events.RowDoubleClick);
		for (int i = 0; i < listeners.size(); i++) {
			getRightJTable_AvailableChg().removeListener(Events.RowDoubleClick,
					(Listener<? extends BaseEvent>) listeners.get(i));
		}
		reloadTableList();
	}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {}

	/* >>> ~13~ Set Disable Fields When Delete ButtonBase Is Clicked ====== <<< */
	@Override
	protected void deleteDisabledFields() {}

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
		return null;
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {
	}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return null;
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	public void modifyAction() {
		setActionType(QueryUtil.ACTION_MODIFY);
		modifyPostAction();
	}

	@Override
	public void modifyPostAction() {
		enableButton(null);

		if (!getRightJTable_AvailableChg().hasListeners(Events.RowDoubleClick)) {
			getRightJTable_AvailableChg().addListener(Events.RowDoubleClick,
					getAvailableChgListener(Events.RowDoubleClick));
		}
		if (!getRightJTable_AvailableChg().hasListeners(Events.OnKeyPress)) {
			getRightJTable_AvailableChg().addListener(Events.OnKeyPress,
					getAvailableChgListener(Events.OnKeyPress));
		}
		getPkgCode().setEnabled(true);
		getPkgCode().focus();
	}

	@Override
	public void saveAction() {
		if (!validating && getPkgCode().getText().length() > 0) {
			enableButton(null);
			getMainFrame().setLoading(true);

			getRightJTable_SelectedChg().saveTable(
					"MOVEITEMTOREF2",
					new String[]{slpNo,
							getPkgCode().getText(),
							getUserInfo().getUserID()},
					false,
					false,
					false,
					false,
					true,
					null);
		}
	}

	@Override
	protected void savePostAction() {

	}

	@Override
	protected void cancelPostAction() {
		super.cancelPostAction();
		getPkgCode().resetText();
		getPkgCode().setEnabled(false);
		getServCode().resetText();
		enableButton(null);
	}

	@Override
	protected void enableButton(String mode) {
		disableButton();
		getModifyButton().setEnabled(!isModify() && !isDisableFunction("TB_MODIFY", "secTxnSupp"));
		getDeleteButton().setEnabled(!isModify() && !isDisableFunction("TB_DELETE", "secTxnSupp") &&
				getRightJTable_SelectedChg().getRowCount() > 0);
		getCancelButton().setEnabled(isModify());
		getBtnMoveAll().setEnabled(isModify()&& (getRightJTable_AvailableChg().getRowCount()>0));
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/



	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	@Override
	protected BasePanel getActionPanel() {
		if (rightPanel == null) {
			rightPanel = new BasePanel();
			rightPanel.setSize(800, 528);
			rightPanel.setPosition(5,5);
			rightPanel.add(getPatientAndItemDetailPanel(), null);
			rightPanel.add(getSuppPanel(), null);
		}
		return rightPanel;
	}

	public BasePanel getPatientAndItemDetailPanel() {
		if (patAndItemDetailPanel == null) {
			patAndItemDetailPanel = new BasePanel();
			patAndItemDetailPanel.setEtchedBorder();
			patAndItemDetailPanel.setBounds(5, 5, 810, 60);
			patAndItemDetailPanel.add(getRightJLabel_PatientNum(), null);
			patAndItemDetailPanel.add(getRightJText_PatientNum(), null);
			patAndItemDetailPanel.add(getRightJLabel_PatientName(), null);
			patAndItemDetailPanel.add(getRightJText_PatientName(), null);
			patAndItemDetailPanel.add(getRightJText_PatientCName(), null);
			patAndItemDetailPanel.add(getRightJLabel_PatientSex(), null);
			patAndItemDetailPanel.add(getRightJText_PatientSex(), null);
			patAndItemDetailPanel.add(getRightJLabel_ChargeCode(), null);
			patAndItemDetailPanel.add(getRightJText_ChargeCode(), null);
			patAndItemDetailPanel.add(getRightJLabel_ChargeName(), null);
			patAndItemDetailPanel.add(getRightJText_ChargeName(), null);
		}
		return patAndItemDetailPanel;
	}

	public BasePanel getSuppPanel() {
		if (suppPanel == null) {
			suppPanel = new BasePanel();
			suppPanel.setEtchedBorder();
			suppPanel.setBounds(5, 70, 810, 420);
			suppPanel.add(getRightJLabel_PkgCode(), null);
			suppPanel.add(getPkgCode(), null);
			suppPanel.add(getRightJLabel_ServCode(), null);
			suppPanel.add(getServCode(), null);
			suppPanel.add(getBtnMoveAll(), null);
			suppPanel.add(getRightJLabel_ShowPkg(), null);
			suppPanel.add(getRightJCheckBox_ShowPkg(), null);
			suppPanel.add(getRightJLabel_AvailableChg(), null);
			suppPanel.add(getRightJTable_AvailableChg(), null);
			suppPanel.add(getRightJLabel_SelectedChg(), null);
			suppPanel.add(getRightJTable_SelectedChg(), null);
		}
		return suppPanel;
	}

	public LabelBase getRightJLabel_PatientNum() {
		if (RightJLabel_PatientNum == null) {
			RightJLabel_PatientNum = new LabelBase();
			RightJLabel_PatientNum.setText("Patient Number");
			RightJLabel_PatientNum.setBounds(15, 5, 90, 20);
		}
		return RightJLabel_PatientNum;
	}

	public TextReadOnly getRightJText_PatientNum() {
		if (RightJText_PatientNum == null) {
			RightJText_PatientNum = new TextReadOnly();
			RightJText_PatientNum.setBounds(110, 5, 90, 20);
		}
		return RightJText_PatientNum;
	}

	public LabelBase getRightJLabel_PatientName() {
		if (RightJLabel_PatientName == null) {
			RightJLabel_PatientName = new LabelBase();
			RightJLabel_PatientName.setText("Patient Name");
			RightJLabel_PatientName.setBounds(230, 5, 90, 20);
		}
		return RightJLabel_PatientName;
	}

	public TextReadOnly getRightJText_PatientName() {
		if (RightJText_PatientName == null) {
			RightJText_PatientName = new TextReadOnly();
			RightJText_PatientName.setBounds(325, 5, 200, 20);
		}
		return RightJText_PatientName;
	}

	public TextReadOnly getRightJText_PatientCName() {
		if (RightJText_PatientCName == null) {
			RightJText_PatientCName = new TextReadOnly();
			RightJText_PatientCName.setBounds(530, 5, 90, 20);
		}
		return RightJText_PatientCName;
	}

	public LabelBase getRightJLabel_PatientSex() {
		if (RightJLabel_PatientSex == null) {
			RightJLabel_PatientSex = new LabelBase();
			RightJLabel_PatientSex.setText("Sex");
			RightJLabel_PatientSex.setBounds(650, 5, 30, 20);
		}
		return RightJLabel_PatientSex;
	}

	public TextReadOnly getRightJText_PatientSex() {
		if (RightJText_PatientSex == null) {
			RightJText_PatientSex = new TextReadOnly();
			RightJText_PatientSex.setBounds(685, 5, 50, 20);
		}
		return RightJText_PatientSex;
	}

	public LabelBase getRightJLabel_ChargeCode() {
		if (RightJLabel_ChargeCode == null) {
			RightJLabel_ChargeCode = new LabelBase();
			RightJLabel_ChargeCode.setText("Charge Code");
			RightJLabel_ChargeCode.setBounds(15, 30, 90, 20);
		}
		return RightJLabel_ChargeCode;
	}

	public TextReadOnly getRightJText_ChargeCode() {
		if (RightJText_ChargeCode == null) {
			RightJText_ChargeCode = new TextReadOnly();
			RightJText_ChargeCode.setBounds(110, 30, 90, 20);
		}
		return RightJText_ChargeCode;
	}

	public LabelBase getRightJLabel_ChargeName() {
		if (RightJLabel_ChargeName == null) {
			RightJLabel_ChargeName = new LabelBase();
			RightJLabel_ChargeName.setText("Charge Name");
			RightJLabel_ChargeName.setBounds(230, 30, 90, 20);
		}
		return RightJLabel_ChargeName;
	}

	public TextReadOnly getRightJText_ChargeName() {
		if (RightJText_ChargeName == null) {
			RightJText_ChargeName = new TextReadOnly();
			RightJText_ChargeName.setBounds(325, 30, 295, 20);
		}
		return RightJText_ChargeName;
	}

	public TextReadOnly getRightJText_StnID() {
		if (RightJText_StnID == null) {
			RightJText_StnID = new TextReadOnly();
			RightJText_StnID.setBounds(400, 30, 295, 20);
		}
		return RightJText_StnID;
	}

	public LabelBase getRightJLabel_PkgCode() {
		if (RightJLabel_PkgCode == null) {
			RightJLabel_PkgCode = new LabelBase();
			RightJLabel_PkgCode.setText("Package Code");
			RightJLabel_PkgCode.setBounds(5, 5, 90, 20);
		}
		return RightJLabel_PkgCode;
	}

	public TextString getPkgCode() {
		if (pkgCode == null) {
			pkgCode = new TextString();
			pkgCode.setBounds(100, 5, 200, 20);
		}
		return pkgCode;
	}

	public LabelBase getRightJLabel_ServCode() {
		if (RightJLabel_ServCode == null) {
			RightJLabel_ServCode = new LabelBase();
			RightJLabel_ServCode.setText("Service Code");
			RightJLabel_ServCode.setBounds(303, 5, 90, 20);
		}
		return RightJLabel_ServCode;
	}

	public ComboDeptServ getServCode() {
		if (ServCode == null) {
			ServCode = new ComboDeptServ(){
				@Override
				protected void setTextPanel(ModelData modelData) {
					super.setTextPanel(modelData);
					reloadTableList();
				}
			};
			ServCode.setBounds(395, 5, 150, 20);

		}
		return ServCode;
	}

	public ButtonBase getBtnMoveAll() {
		if (BtnMoveAll == null) {
			BtnMoveAll = new ButtonBase() {
				@Override
				public void onClick() {
					TableList etl = getRightJTable_AvailableChg();
						List<TableData> tmpAChgCont = etl.getStore().getModels();
						etl.getStore().removeAll();
						getRightJTable_SelectedChg().getStore().add(tmpAChgCont);
						getRightJTable_SelectedChg().setSelectRow(0);
						getRightJTable_SelectedChg().getView().focusRow(0);
						BtnMoveAll.setEnabled(false);
						getSaveButton().setEnabled(true);
				}
			};
			BtnMoveAll.setText("Move All");
			BtnMoveAll.setBounds(548, 5, 88, 25);
		}
		return BtnMoveAll;
	}

	public LabelBase getRightJLabel_ShowPkg() {
		if (RightJLabel_ShowPkg == null) {
			RightJLabel_ShowPkg = new LabelBase();
			RightJLabel_ShowPkg.setText("Show Package");
			RightJLabel_ShowPkg.setBounds(685, 5, 80, 20);
		}
		return RightJLabel_ShowPkg;
	}

	public CheckBoxBase getRightJCheckBox_ShowPkg() {
		if (RightJCheckBox_ShowPkg == null) {
			RightJCheckBox_ShowPkg = new CheckBoxBase();
			RightJCheckBox_ShowPkg.setBounds(770, 5, 10, 20);
			RightJCheckBox_ShowPkg.addListener(Events.OnClick,
				new Listener<FieldEvent>() {
					@Override
					public void handleEvent(FieldEvent be) {
						boolean checked = getRightJCheckBox_ShowPkg().getValue();
						reloadTableList();
					}
				});
		}
		return RightJCheckBox_ShowPkg;
	}


	public LabelBase getRightJLabel_AvailableChg() {
		if (RightJLabel_AvailableChg == null) {
			RightJLabel_AvailableChg = new LabelBase();
			RightJLabel_AvailableChg.setText("Available Charge");
			RightJLabel_AvailableChg.setStyleAttribute("font-wight", "bold");
			RightJLabel_AvailableChg.setBounds(5, 40, 150, 20);
		}
		return RightJLabel_AvailableChg;
	}

	public TableList getRightJTable_AvailableChg() {
		if (RightJTable_AvailableChg == null) {
			RightJTable_AvailableChg =
					new TableList(getAvailableChgColumnNames(), getAvailableChgColumnWidths()) {
				@Override
				public void setListTableContentPost() {
					getBtnMoveAll().setEnabled(isModify()&& (getRightJTable_AvailableChg().getRowCount()>0));
				}
			};
			RightJTable_AvailableChg.setId("available-chg-table");
//			RightJTable_AvailableChg.setAutoHeight(true);
			RightJTable_AvailableChg.setBounds(5, 65, 790, 150);
		}
		return RightJTable_AvailableChg;
	}

	private Listener<GridEvent> getAvailableChgListener(EventType et) {
		if (et.equals(Events.RowDoubleClick)) {
			return new Listener<GridEvent>() {
				@Override
				public void handleEvent(GridEvent be) {
					TableList etl = getRightJTable_AvailableChg();
					String[] selectedContent = etl.getSelectedRowContent();
					int targetColCount = getRightJTable_SelectedChg().getColumnCount();

					String[] columnNames = getRightJTable_SelectedChg().getColumnIDs();
					Object[] fields = new Object[targetColCount];

					fields[0] = "";
					for (int i = 0; i < selectedContent.length; i++) {
						fields[i] = selectedContent[i];
					}

					TableData newModel = new TableData(columnNames, fields);
					etl.getStore().remove(etl.getSelectedRow());
					getRightJTable_SelectedChg().getStore().insert(newModel, 0);
					getRightJTable_SelectedChg().setSelectRow(0);
					getRightJTable_SelectedChg().getView().focusRow(0);

					getSaveButton().setEnabled(true);
				}
			};
		} else if (et.equals(Events.OnKeyPress)) {
			return new Listener<GridEvent>() {
				@Override
				public void handleEvent(GridEvent be) {
						if (be.getKeyCode() == 13) {
							TableList etl = getRightJTable_AvailableChg();
							if (etl.getSelectedRow() >= 0) {
								String[] selectedContent = etl.getSelectedRowContent();
								int targetColCount = getRightJTable_SelectedChg()
																	.getColumnCount();

								String[] columnNames = getRightJTable_SelectedChg()
																			.getColumnIDs();
								Object[] fields = new Object[targetColCount];

								fields[0] = "";
								for (int i = 0; i < selectedContent.length; i++) {
									fields[i] = selectedContent[i];
								}
//								fields[4] = docCode_O;
//								fields[5] = docCode_T;
//								fields[6] = "";
//								fields[7] = getUserInfo().getUserID();
//								fields[8] = getMainFrame().getServerDate();
//								fields[9] = "";
//								fields[10] = "";
//								fields[11] = getMainFrame().getServerTime();
//								fields[12] = "";

								TableData newModel = new TableData(columnNames, fields);
								etl.getStore().remove(etl.getSelectedRow());
								getRightJTable_SelectedChg().getStore().insert(newModel, 0);
								getRightJTable_SelectedChg().setSelectRow(0);
								getRightJTable_SelectedChg().getView().focusRow(0);

								getSaveButton().setEnabled(true);
							}
						}
					}
			};
		}
		return null;
	}

	private String[] getAvailableChgColumnNames() {
		return new String[] {
				"Seq No", "Pkg", "Ref", "Item", "Type", "Description", "Unit", "I-Ref", "Disc %", "Net Amount",
				"Amount", "Dr Code", "Txn Date", "Service Code", "Status", "Speciality", "User ID", "Class", "Report Level", "Capture Date",
				"Glc", "Doctor Name", "STNID", "STNADOC", "STNXREF", "XRGID", "Stntype", "stncpsflag"};
	}

	private int[] getAvailableChgColumnWidths() {
		return new int[] {
				45, 45, 45, 45, 0,  200, 30, 50, 45, 0,
				70, 50, 65, 75, 40, 120, 70, 50, 70, 110,
				0,  0,  0,  0,  0,   0,  0,  0};
	}

	public LabelBase getRightJLabel_SelectedChg() {
		if (RightJLabel_SelectedChg == null) {
			RightJLabel_SelectedChg = new LabelBase();
			RightJLabel_SelectedChg.setText("Selected Charge");
			RightJLabel_SelectedChg.setStyleAttribute("font-wight", "bold");
			RightJLabel_SelectedChg.setBounds(5, 220, 150, 20);
		}
		return RightJLabel_SelectedChg;
	}


	public TableList getRightJTable_SelectedChg() {
		if (RightJTable_SelectedChg == null) {
			RightJTable_SelectedChg =
				new TableList(getSelectedChgColumnNames(),
									getSelectedChgColumnWidths()) {
				@Override
				public void setListTableContentPost() {
					if (getStore().getCount() > 0) {
						orgSelectedChgRow = getStore().getCount();
						enableButton(null);
					} else {
//						getDeleteButton().setEnabled(false);
					}
				}

				@Override
				public void postSaveTable(boolean success, Integer rtnCode, String rtnMsg) {
					if (success) {
						reloadTableList();
						getPkgCode().resetText();
						setActionType(null);
					} else if(rtnCode < 1 && rtnMsg.indexOf("Invalid Package Code")> -1 ){
						getPkgCode().setErrorField(true);
						getPkgCode().focus();
						getSaveButton().setEnabled(true);
					} else if (!success){
						reloadTableList();
						getPkgCode().resetText();
						cancelAction();
					}

					getMainFrame().setLoading(false);
				}

			};
			RightJTable_SelectedChg.setId("selected-chg-table");
//			RightJTable_SelectedChg.setAutoHeight(true);
			RightJTable_SelectedChg.setBounds(5, 245, 790, 150);
			RightJTable_SelectedChg.addListener(Events.RowClick,
				new Listener<GridEvent>() {
					@Override
					public void handleEvent(GridEvent be) {
						if (prevSelectedRow == -1) {
							prevSelectedRow = getRightJTable_SelectedChg().getSelectedRow();
						} else {
							if (validating) {
								getRightJTable_SelectedChg().setSelectRow(prevSelectedRow);
							} else {
								prevSelectedRow = getRightJTable_SelectedChg().getSelectedRow();
							}
						}
					}
				});

			RightJTable_SelectedChg.addListener(Events.RowDoubleClick,
				new Listener<GridEvent>() {
					@Override
					public void handleEvent(GridEvent be) {
						TableList etl = getRightJTable_SelectedChg();
						String[] content = etl.getSelectedRowContent();

							int targetColCount = getRightJTable_AvailableChg().getColumnCount();

							String[] columnNames = getRightJTable_AvailableChg().getColumnIDs();
							Object[] fields = new Object[targetColCount];

							fields[0] = "";
							for (int i = 0; i < content.length; i++) {
								fields[i] = content[i];
							}

							TableData newModel = new TableData(columnNames, fields);
							etl.getStore().remove(etl.getSelectedRow());
							getRightJTable_AvailableChg().getStore().insert(newModel, 0);
							getRightJTable_AvailableChg().setSelectRow(0);
							getRightJTable_AvailableChg().getView().focusRow(0);

							if (etl.getRowCount() == orgSelectedChgRow && etl.getStore().getModifiedRecords().size() == 0) {
								getSaveButton().setEnabled(false);
							}
					}
				});

			RightJTable_SelectedChg.addListener(Events.OnKeyPress,
					new Listener<GridEvent>() {
						@Override
						public void handleEvent(GridEvent be) {
							if (be.getKeyCode() == 13) {
								TableList etl = getRightJTable_SelectedChg();
								if (etl.getSelectedRow() >= 0) {
									String[] content = etl.getSelectedRowContent();

									if (content[0].length() > 0) {
										return;
									} else {
										int targetColCount = getRightJTable_AvailableChg().getColumnCount();
										String[] columnNames = getRightJTable_AvailableChg().getColumnIDs();
										Object[] fields = new Object[targetColCount];

										fields[0] = content[1];
										fields[1] = content[2];
										fields[2] = content[3];

										TableData newModel = new TableData(columnNames, fields);
										etl.getStore().remove(etl.getSelectedRow());
										getRightJTable_AvailableChg().getStore().insert(newModel, 0);
										getRightJTable_AvailableChg().setSelectRow(0);
										getRightJTable_AvailableChg().getView().focusRow(0);

										if (etl.getRowCount() == orgSelectedChgRow &&
											etl.getStore().getModifiedRecords().size() == 0) {
											getSaveButton().setEnabled(false);
										}
									}
								}
							}
						}
					});
		}
		return RightJTable_SelectedChg;
	}

	private String[] getSelectedChgColumnNames() {
		return new String[] {
				"Seq No", "Pkg", "Ref", "Item", "Type", "Description", "Unit", "I-Ref", "Disc %", "Net Amount",
				"Amount", "Dr Code", "Txn Date", "Service Code", "Status", "Speciality", "User ID", "Class", "Report Level", "Capture Date",
				"Glc", "Doctor Name", "STNID", "STNADOC", "STNXREF", "XRGID", "Stntype", "stncpsflag"};
	}

	private int[] getSelectedChgColumnWidths() {
		return new int[] {
				45, 45, 45, 45, 0,  200, 30, 50, 45, 0,
				70, 50, 65, 75, 40, 120, 70, 50, 70, 110,
				0,  0,  0,  0,  0,   0,  0,  0};
	}

	private Field[] getSelectedChgFields() {

		return new Field[] { null, null, null, null, null, null, null, null, null, null,
							 null, null, null, null, null, null, null, null, null, null,
							 null, null, null, null, null, null, null, null, null, null,
							 null, null, null, null, null, null, null};
	}


	public void reloadTableList() {
		getRightJTable_AvailableChg().setListTableContent("TRANSACTION_SUBDTLFRPG",
				new String[] { slpNo,getRightJCheckBox_ShowPkg().isSelected()?"Y":"N",
						getServCode().getText(),
						Factory.getInstance().getUserInfo().getUserID()});
		getRightJTable_SelectedChg().removeAllRow();
	}

	public int checkExistItemInList(String checkValue) {
		List<TableData> tableList = getRightJTable_AvailableChg().getStore().getModels();
		int noOfRow = tableList.size();

		final ListStore<TableData> store = getRightJTable_AvailableChg().getStore();
		for(int i = 0; i < noOfRow; i++) {
			final TableData rowData = store.getAt(i);
			if (checkValue.equals(rowData.get(TableUtil.getName2ID("Supp Code")))) {
				return i+1;
			}
		}
		return -1;
	}
}