package com.hkah.client.tx.admin;

import com.extjs.gxt.ui.client.data.ModelData;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.combobox.ComboMedMediaType;
import com.hkah.client.layout.combobox.ComboMedRecLoc;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.panel.TabbedPaneBase;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class SystemParameter extends MasterPanel{

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.SYSTEMPARAMETER_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.SYSTEMPARAMETER_TITLE;
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

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private BasePanel rightPanel=null;
	private BasePanel leftPanel=null;

	private int TabbedPaneIndex=0;
	private TabbedPaneBase TabbedPane=null;

	private BasePanel DIPanel = null;
	private TableList DITable=null;
	private JScrollPane DIJScrollPane = null;

	private BasePanel PYPanel=null;
	private TableList PYTable=null;
	private JScrollPane PYJScrollPane = null;

	private BasePanel PBAPanel=null;
	private TableList PBATable=null;
	private JScrollPane PBAJScrollPane = null;

	private BasePanel MRPanel=null;
	private TableList LocTable=null;
	private JScrollPane LocJScrollPane = null;
	private TableList VolTable=null;
	private JScrollPane VolJScrollPane = null;
	private TableList MedTable=null;
	private JScrollPane MedJScrollPane = null;

	private LabelBase PSDesc=null;
	private LabelBase LocationDesc=null;
	private LabelBase VolumnNoDesc=null;
	private LabelBase MediaTypeDesc=null;
	private ButtonBase GenMenu=null;

	private ComboMedRecLoc recLoc =null;
	private LabelBase LocationDesc1 = null;
	private LabelBase LocationDesc11 = null;
	private ComboMedMediaType medType = null;
	private int t1=0;
	private int t2=0;
	private int t3=0;
	private int t4=0;
	private int t5=0;
	private int t6=0;

	/**
	 * This method initializes
	 *
	 *
	 */
	public SystemParameter() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		setLeftAlignPanel();
		getJScrollPane().setBounds(10, 90, 725, 160);
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		getTabbedPane().setSelectedIndex(2);
		//searchAction();
		fillTables();
		getLocTable().setColumnClass(2, getRecLoc(), false);
		getMedTable().setColumnClass(2, medType, false);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return null;//getTabbedPane();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {
	}

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

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {
		String parcde=null;
		for (int i = 0; i < getPBATable().getRowCount(); i++) {
			parcde = getPBATable().getValueAt(i, 4).toString();
			if ("DUPBPCHKF".equals(parcde)) {
				if ("Y".equals(getPBATable().getValueAt(i, 2).toString()) || "N".equals(getPBATable().getValueAt(i, 2).toString())) {
					continue;
				} else {
					Factory.getInstance().addErrorMessage("Please input (Y/N)", getPBATable());
					getTabbedPane().setSelectedIndex(2);
					getPBATable().getView().focusCell(i,2,false);
//					getPBATable().getEditorComponent().requestFocus();
					actionValidationReady(actionType, false);
				}
			}
			if ("DUPBPDAY".equals(parcde)) {
				if (TextUtil.isPositiveInteger(getPBATable().getValueAt(i, 2).toString())) {
					if (Integer.parseInt(getPBATable().getValueAt(i, 2).toString())>=1 && Integer.parseInt(getPBATable().getValueAt(i, 2).toString())<1000) {
						continue;
					} else {
						getMsg(i, "Please input (1-999)");
						actionValidationReady(actionType, false);
					}
				} else {
					getMsg(i, "Please input (1-999)");
					actionValidationReady(actionType, false);
				}
			}
			if ("DUPBPDOC".equals(parcde)) {
				if (TextUtil.isPositiveInteger(getPBATable().getValueAt(i, 2).toString())) {
					if (Integer.parseInt(getPBATable().getValueAt(i, 2).toString())>=1 && Integer.parseInt(getPBATable().getValueAt(i, 2).toString())<10) {
						continue;
					} else {
						getMsg(i, "Please input (1-9)");
						actionValidationReady(actionType, false);
					}
				} else {
					getMsg(i, "Please input (1-9)");
					actionValidationReady(actionType, false);
				}
			}
			if ("DUPBPGN".equals(parcde)) {
				if (TextUtil.isPositiveInteger(getPBATable().getValueAt(i, 2).toString())) {
					if (Integer.parseInt(getPBATable().getValueAt(i, 2).toString())>=1 && Integer.parseInt(getPBATable().getValueAt(i, 2).toString())<101) {
						continue;
					} else {
						getMsg(i, "Please input (1-100)");
						actionValidationReady(actionType, false);
					}
				} else {
					getMsg(i, "Please input (1-100)");
					actionValidationReady(actionType, false);
				}
			}
		}
		actionValidationReady(actionType, true);
	}

	private void fillTables() {
		setActionType(QueryUtil.ACTION_BROWSE);
		getSearchButton().setEnabled(false);
		getAppendButton().setEnabled(false);
		getModifyButton().setEnabled(true);
		getDeleteButton().setEnabled(false);
		getSaveButton().setEnabled(false);
		getAcceptButton().setEnabled(false);
		getCancelButton().setEnabled(false);
		getClearButton().setEnabled(false);
		getRefreshButton().setEnabled(false);
		getPrintButton().setEnabled(false);

		getRecLoc().setEditable(false);
		getMedType().setEditable(false);

		getDITable().setListTableContent(getTxCode(), new String[] {"DI"});
		getPYTable().setListTableContent(getTxCode(), new String[] {"PHAR"});
		getPBATable().setListTableContent(getTxCode(), new String[] {"PBA"});
		getLocTable().setListTableContent(getTxCode(), new String[] {"MRLC"});
		getVolTable().setListTableContent(getTxCode(), new String[] {"MRVN"});
		getMedTable().setListTableContent(getTxCode(), new String[] {"MRMT"});

		setTableEditable(false);
		getLocTable().setSelectRow(1);
		getMedTable().setSelectRow(1);

		recLoc.setText(getLocTable().getSelectedRowContent()[2]);
		medType.setText(getMedTable().getSelectedRowContent()[2]);
	}

	private void getMsg(int column,String msg) {
		Factory.getInstance().addErrorMessage(msg,getPBATable());
		getTabbedPane().setSelectedIndex(2);
		getPBATable().setRowSelectionInterval(column, column);
		getPBATable().getView().focusCell(column,2,false);
	}

	/***************************************************************************
	 * Implement Abstract Methods
	 **************************************************************************/

//	public void searchAction() {
//		performList();
//		setActionType(null);
//		enableButton(SEARCH_MODE);
//		// focus on search panel
//		PanelUtil.setFirstComponentFocus(getLeftPanel());
//		fillTables();
//	}

	/**
	 * action when click modify button
	 */
	public void modifyAction() {
		setActionType(QueryUtil.ACTION_MODIFY);
		getSaveButton().setEnabled(true);
		getCancelButton().setEnabled(true);
		getRecLoc().setEditable(true);
		getMedType().setEditable(true);
		setTableEditable(true);
	}

	private void setTableEditable(boolean isEditable) {
		getDITable().setColumnClass(2, String.class,isEditable);
		getDITable().setColumnClass(3, String.class,isEditable);

		getPYTable().setColumnClass(2, String.class,isEditable);
		getPYTable().setColumnClass(3, String.class,isEditable);

		getPBATable().setColumnClass(2, String.class,isEditable);
		getPBATable().setColumnClass(3, String.class,isEditable);

		getVolTable().setColumnClass(2, String.class,isEditable);
	}

	public void cancelPostAction() {
		super.cancelPostAction();
		fillTables();
	}

	protected void actionValidationReady(final String actionType, boolean isValidationReady) {
		if (isValidationReady) {
			t1 = 0;
			t2 = 0;
			t3 = 0;
			t4 = 0;
			t5 = 0;
			t6 = 0;

			for (int i = 0; i < getDITable().getRowCount() && t1 == 0; i++) {
				QueryUtil.executeMasterAction(getUserInfo(), getTxCode(), getActionType(),
						new String[] {
							getDITable().getValueAt(i, 4).toString(),
							getDITable().getValueAt(i, 2).toString(),
							getDITable().getValueAt(i, 3).toString(),
							""
						},
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (!mQueue.success()) {
							Factory.getInstance().addErrorMessage(mQueue.getReturnMsg());
							t1=-1;
						}
					}
				});
			}

			for (int i = 0; i < getPYTable().getRowCount() && t2 == 0; i++) {
				QueryUtil.executeMasterAction(getUserInfo(),getTxCode(), getActionType(),
						new String[] {
							getPYTable().getValueAt(i, 4).toString(),
							getPYTable().getValueAt(i, 2).toString(),
							getPYTable().getValueAt(i, 3).toString(),
							""
						},
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (!mQueue.success()) {
							Factory.getInstance().addErrorMessage(mQueue.getReturnMsg());
							t2=-1;
						}
					}
				});

			}

			for (int i = 0; i < getPBATable().getRowCount() && t3 == 0; i++) {
				 QueryUtil.executeMasterAction(getUserInfo(),getTxCode(), getActionType(),
						new String[] {
					 		getPBATable().getValueAt(i, 4).toString(),
					 		getPBATable().getValueAt(i, 2).toString(),
					 		getPBATable().getValueAt(i, 3).toString(),
					 		""
						},
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (!mQueue.success()) {
							Factory.getInstance().addErrorMessage(mQueue.getReturnMsg());
							t3=-1;
						}
					}
				});
			}

			for (int i = 0; i < getLocTable().getRowCount() && t4 == 0; i++) {
				QueryUtil.executeMasterAction(getUserInfo(),getTxCode(), getActionType(),
						new String[] {
							getLocTable().getValueAt(i, 4).toString(),
							getLocTable().getValueAt(i, 2).toString(),
							getLocTable().getValueAt(i, 3).toString(),
							"N"
						},
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (!mQueue.success()) {
							Factory.getInstance().addErrorMessage(mQueue.getReturnMsg());
							t4 = -1;
						}
					}
				});
			}

			for (int i = 0; i < getVolTable().getRowCount() && t5 == 0; i++) {
				QueryUtil.executeMasterAction(getUserInfo(),getTxCode(), getActionType(),
						new String[] {
							getVolTable().getValueAt(i, 4).toString(),
							getVolTable().getValueAt(i, 2).toString(),
							getVolTable().getValueAt(i, 3).toString(),
							"N"
						},
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (!mQueue.success()) {
							Factory.getInstance().addErrorMessage(mQueue.getReturnMsg());
							t5=-1;
						}
					}
				});
			}

			for (int i = 0; i < getMedTable().getRowCount() && t6 == 0; i++) {
				QueryUtil.executeMasterAction(getUserInfo(),getTxCode(), getActionType(),
						new String[] {
							getMedTable().getValueAt(i, 4).toString(),
							getMedTable().getValueAt(i, 2).toString(),
							getMedTable().getValueAt(i, 3).toString(),
							"N"
						},
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (!mQueue.success()) {
							Factory.getInstance().addErrorMessage(mQueue.getReturnMsg());
							t6=-1;
						}
					}
				});
			}

			fillTables();
		}
	}

	/* >>> getter methods for init the Component start from here================================== <<< */

	private ComboMedRecLoc getRecLoc() {
		if (recLoc == null) {
			recLoc = new ComboMedRecLoc(false) {
				@Override
				protected void setTextPanel(ModelData modelData) {
					if (isModify()) {
						getLocTable().setValueAt(recLoc.getText(), getLocTable().getSelectedRow(), 2);
					}
				}
			};
			recLoc.setBounds(570, 81, 190, 20);
		}
		return recLoc;
	}


	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.setSize(788, 540);
			leftPanel.add(getTabbedPane(),null);
			leftPanel.add(getGenMenu(), null);
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

	public ButtonBase getGenMenu() {
		if (GenMenu == null) {
			GenMenu = new ButtonBase() {
				@Override
				public void onClick() {
					//add something
				}
			};
			GenMenu.setText("Gen Menu");
			GenMenu.setBounds(18, 503, 93, 20);
			GenMenu.setStyleAttribute("margin","0px");

		}
		return GenMenu;
	}

	public TabbedPaneBase getTabbedPane() {
		if (TabbedPane == null) {
			TabbedPane = new TabbedPaneBase() {
				public void onStateChange() {
					setTabbedPaneIndex(TabbedPane.getSelectedIndex());
				}
			};
			TabbedPane.setLocation(0, 1);
			TabbedPane.setSize(784, 460);
			TabbedPane.addTab("Diagnosis Imaging", getDIPanel());
			TabbedPane.addTab("Pharmacy", getPYPanel());
			TabbedPane.addTab("PBA", getPBAPanel());
			TabbedPane.addTab("Medical Record", getMRPanel());

		}
		return TabbedPane;
	}

	public BasePanel getDIPanel() {
		if (DIPanel == null) {
			DIPanel = new BasePanel();
			DIPanel.add(getDIJScrollPane(), null);
			DIPanel.setLocation(5, 5);
			DIPanel.setSize(759, 127);

		}
		return DIPanel;
	}

	private JScrollPane getDIJScrollPane() {
		if (DIJScrollPane == null) {
			DIJScrollPane = new JScrollPane();
			DIJScrollPane.setViewportView(getDITable());
			DIJScrollPane.setBounds(15, 25, 740, 390);
		}
		return DIJScrollPane;
	}

	private TableList getDITable() {
		if (DITable == null) {
			DITable = new TableList(getDIColumnNames(), getDITableColumnWidths());
			DITable.setTableLength(getListWidth());
			//PatStatusTable.setColumnClass(0, ComboPackage.class, true);
			//PatStatusTable.setColumnClass(1, String.class, true);
		}
		return DITable;
	}

	protected String[] getDIColumnNames() {
		return new String[] {"",
				"Description",
				"Parameter",
				"Chinese Parameter",""};
	}

	protected int[] getDITableColumnWidths() {
		return new int[] { 10,200,200,200,0};
	}



	public BasePanel getPYPanel() {
		if (PYPanel == null) {
			PYPanel = new BasePanel();
			PYPanel.add(getPYJScrollPane(), null);
			PYPanel.add(getPSDesc(), null);
			PYPanel.setLocation(5, 5);
			PYPanel.setSize(759, 127);
		}
		return PYPanel;
	}

	public LabelBase getPSDesc() {
		if (PSDesc == null) {
			PSDesc = new LabelBase();
			PSDesc.setText("<html>P.S. Prescription Instruction: Input %d for dosage. Input %f for frequenty<br>Drug Interaction Significant Level: zero represent not applied</html>");
			PSDesc.setBounds(15, 354, 382, 47);
		}
		return PSDesc;
	}

	private JScrollPane getPYJScrollPane() {
		if (PYJScrollPane == null) {
			PYJScrollPane = new JScrollPane();
			PYJScrollPane.setViewportView(getPYTable());
			PYJScrollPane.setBounds(15, 25, 740,320);
		}
		return PYJScrollPane;
	}

	private TableList getPYTable() {
		if (PYTable == null) {
			PYTable = new TableList(getPYTableColumnNames(), getPYTableColumnWidths());
			PYTable.setTableLength(getListWidth());
			//PatStatusTable.setColumnClass(0, ComboPackage.class, true);
			//PatStatusTable.setColumnClass(1, String.class, true);
		}
		return PYTable;
	}


	protected String[] getPYTableColumnNames() {
		return new String[] {"",
				"Description",
				"Parameter",
				"Chinese Parameter",""
				};
	}

	protected int[] getPYTableColumnWidths() {
		return new int[] { 10,200,200,200,0};
	}

	public BasePanel getPBAPanel() {
		if (PBAPanel == null) {
			PBAPanel = new BasePanel();
			PBAPanel.add(getPBAJScrollPane(), null);
			PBAPanel.setLocation(5, 5);
			PBAPanel.setSize(759, 127);
		}
		return PBAPanel;
	}

	private JScrollPane getPBAJScrollPane() {
		if (PBAJScrollPane == null) {
			PBAJScrollPane = new JScrollPane();
			PBAJScrollPane.setViewportView(getPBATable());
			PBAJScrollPane.setBounds(15, 25, 740,390);
		}
		return PBAJScrollPane;
	}

	private TableList getPBATable() {
		if (PBATable == null) {
			PBATable = new TableList(getPBATableColumnNames(), getPBATableColumnWidths());
			PBATable.setTableLength(getListWidth());
			//PatStatusTable.setColumnClass(0, ComboPackage.class, true);
			//PatStatusTable.setColumnClass(1, String.class, true);
		}
		return PBATable;
	}

	protected String[] getPBATableColumnNames() {
		return new String[] {"",
				"Description",
				"Parameter",
				"Chinese Parameter",""
				};
	}

	protected int[] getPBATableColumnWidths() {
		return new int[] { 10,200,200,200,0};
	}

	public BasePanel getMRPanel() {
		if (MRPanel == null) {
			LocationDesc11 = new LabelBase();
			LocationDesc11.setBounds(570, 351, 51, 18);
			LocationDesc11.setText("Parameter:");
			LocationDesc1 = new LabelBase();
			LocationDesc1.setBounds(570, 59, 65, 17);
			LocationDesc1.setText("Parameter:");
			MRPanel = new BasePanel();
			MRPanel.add(getLocationDesc(), null);
			MRPanel.add(getVolumnNoDesc(), null);
			MRPanel.add(getMediaTypeDesc(), null);
			MRPanel.add(getLocJScrollPane(), null);
			MRPanel.add(getVolJScrollPane(), null);
			MRPanel.add(getMedJScrollPane(), null);
			MRPanel.setLocation(5, 5);
			MRPanel.setSize(759, 127);
			MRPanel.add(LocationDesc1, null);
			MRPanel.add(getRecLoc(), null);
			MRPanel.add(LocationDesc11, null);
			MRPanel.add(getMedType(), null);
		}
		return MRPanel;
	}

	public LabelBase getLocationDesc() {
		if (LocationDesc == null) {
			LocationDesc = new LabelBase();
			LocationDesc.setText("Location");
			LocationDesc.setBounds(15, 5, 66, 20);
		}
		return LocationDesc;
	}

	public LabelBase getVolumnNoDesc() {
		if (VolumnNoDesc == null) {
			VolumnNoDesc = new LabelBase();
			VolumnNoDesc.setText("Volumn No");
			VolumnNoDesc.setBounds(15, 230, 66, 20);
		}
		return VolumnNoDesc;
	}

	public LabelBase getMediaTypeDesc() {
		if (MediaTypeDesc == null) {
			MediaTypeDesc = new LabelBase();
			MediaTypeDesc.setText("Media Type");
			MediaTypeDesc.setBounds(15, 324, 66, 20);
		}
		return MediaTypeDesc;
	}

	private JScrollPane getLocJScrollPane() {
		if (LocJScrollPane == null) {
			LocJScrollPane = new JScrollPane();
			LocJScrollPane.setViewportView(getLocTable());
			LocJScrollPane.setBounds(15, 25, 540, 200);
		}
		return LocJScrollPane;
	}

	private TableList getLocTable() {
		if (LocTable == null) {
			LocTable = new TableList(getLocTableColumnNames(), getLocTableColumnWidths()) {
				public void onSelectionChanged() {
					if (LocTable.isStateful()) {
						getRecLoc().setText(LocTable.getSelectedRowContent()[2]);
					} else {
//						LocTable.addRowSelectionInterval(0,0);
						getRecLoc().setText(LocTable.getSelectedRowContent()[2]);
					}
				}
			};
			LocTable.setTableLength(getListWidth());
//			LocTable.setColumnClass(2, getRecLoc(), false);
		}
		return LocTable;
	}


	protected String[] getLocTableColumnNames() {
		return new String[] {
				"",
				"Description",
				"Parameter","",""
		};
	}

	protected int[] getLocTableColumnWidths() {
		return new int[] { 10, 200, 200, 0, 0};
	}

	private JScrollPane getVolJScrollPane() {
		if (VolJScrollPane == null) {
			VolJScrollPane = new JScrollPane();
			VolJScrollPane.setViewportView(getVolTable());
			VolJScrollPane.setBounds(15, 250, 540,70);
		}
		return VolJScrollPane;
	}

	private TableList getVolTable() {
		if (VolTable == null) {
			VolTable = new TableList(getVolTableColumnNames(), getVolTableColumnWidths());
			VolTable.setTableLength(getListWidth());
			//PatStatusTable.setColumnClass(0, ComboPackage.class, true);
			//PatStatusTable.setColumnClass(1, String.class, true);
		}
		return VolTable;
	}

	protected String[] getVolTableColumnNames() {
		return new String[] {
				"",
				"Description",
				"Parameter",
				"",
				""
		};
	}

	protected int[] getVolTableColumnWidths() {
		return new int[] { 10,200,200,0,0};
	}

	private JScrollPane getMedJScrollPane() {
		if (MedJScrollPane == null) {
			MedJScrollPane = new JScrollPane();
			MedJScrollPane.setViewportView(getMedTable());
			MedJScrollPane.setBounds(15, 345, 540, 70);
		}
		return MedJScrollPane;
	}

	private TableList getMedTable() {
		if (MedTable == null) {
			MedTable = new TableList(getMedTableColumnNames(), getMedTableColumnWidths()) {
				public void onSelectionChanged() {
					if (MedTable.isAttached()) {
						getMedType().setText(MedTable.getSelectedRowContent()[2]);
					} else {
						MedTable.setRowSelectionInterval(0,0);
						getMedType().setText(MedTable.getSelectedRowContent()[2]);
					}
				}
			};
			MedTable.setTableLength(getListWidth());
		}
		return MedTable;
	}

	protected String[] getMedTableColumnNames() {
		return new String[] {"",
				"Description",
				"Parameter","",""
				};
	}

	protected int[] getMedTableColumnWidths() {
		return new int[] { 10, 200, 200, 0, 0};
	}

	public void setTabbedPaneIndex(int index) {
		this.TabbedPaneIndex = index;
	}

	public int getTabbedPaneIndex() {
		return TabbedPaneIndex;
	}

	/**
	 * This method initializes jComboBox
	 *
	 * @return javax.swing.JComboBox
	 */
	private ComboMedMediaType getMedType() {
		if (medType == null) {
			medType = new ComboMedMediaType() {
				@Override
				protected void setTextPanel(ModelData modelData) {
					if (isModify()) {
						getMedTable().setValueAt(medType.getText(), getMedTable().getSelectedRow(), 2);
					}
				}
			};
			medType.setBounds(570, 370, 190, 20);
		}
		return medType;
	}
}