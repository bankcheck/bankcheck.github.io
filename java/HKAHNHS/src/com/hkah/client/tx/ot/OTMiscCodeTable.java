package com.hkah.client.tx.ot;

import java.util.ArrayList;
import java.util.List;
import com.extjs.gxt.ui.client.store.Record;
import com.extjs.gxt.ui.client.widget.form.Field;
import com.extjs.gxt.ui.client.widget.form.TextField;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboOTCType;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.table.EditorTableList;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextNum;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MaintenancePanel;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class OTMiscCodeTable extends MaintenancePanel {
	/**
	 *
	 */
	private static final long serialVersionUID = 1L;

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.OTMISCCODETABLE_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.OTMISCCODETABLE_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] { " ", "OT Code Type", "Sort Order", "Description",
				"Active", "Numeric Att 1", "Text Att 1", "otcid" };
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] { 10, 120, 80, 160, 50, 95, 95, 0 };
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;
	private LabelBase OTMiscTypeDesc = null;
	private ComboOTCType OTMiscType = null;
	//private LabelBase ShowInactiveDesc = null;
	private CheckBoxBase ShowInactive = null;

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private ColumnLayout viewPanel = null;
	private LabelBase SortOrderDesc = null;
	private TextNum SortOrder = null;
	private LabelBase ActiveDesc = null;
	private CheckBoxBase Active = null;
	private LabelBase DescrDesc = null;
	private TextString Descr = null;
	private LabelBase NumAtt1Desc = null;
	private TextNum NumAtt1 = null;
	private LabelBase TextAtt1Desc = null;
	private TextString TextAtt1 = null;

	/**
	 * This method initializes
	 *
	 */
	public OTMiscCodeTable() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		/* >>> ~7.1~ Init action (e.g. Listing, Init Comobbox ========= <<< */
		//setFullEntry(true);

		/* >>> ~7.2~ Disable Add/Modify/Delete Buttons ================ <<< */
		//setAppendButtonEnabled(false);
		//setModifyButtonEnabled(false);
		//setDeleteButtonEnabled(false);

		getLeftPanel().setHeight("50");
		getBodyPanel().add(getRightBasePanel_OT_Code());
		getListTable().hide();
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		getRightJTable_OT_Code().setColumnClass(1, new ComboOTCType(), false);

		// set default OT Misc Type
		/*
		int material = 0;
		try {
			material = Integer.parseInt(getParameter("OT_LOG_MATERIAL"));
		} catch (Exception e) {}

		if (material > 0) {
			if (ConstantsGlobal.OT_GRD_IM == material) {
				getOTMiscType().setText("IM");
			} else if (ConstantsGlobal.OT_GRD_EQ == material) {
				getOTMiscType().setText("EQ");
			} else if (ConstantsGlobal.OT_GRD_IN == material) {
				getOTMiscType().setText("IN");
			} else if (ConstantsGlobal.OT_GRD_DG == material) {
				getOTMiscType().setText("DG");
			}
			*/

		if (getParameter("OT_LOG_MATERIAL") != null) {
			getOTMiscType().setText(getParameter("OT_LOG_MATERIAL"));
			searchAction();
		}
		enableButton(null);
		getRightJTable_OT_Code().removeAllRow();
		clearAction();
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return null;//getOTMiscType();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {
		// override function if necessary
	}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {
		// enable/disable field
		getOTMiscType().setEnabled(false);

		getSortOrder().setEditable(false);
		getDescr().setEditable(false);
		getActive().setEditable(false);
		getNumAtt1().setEditable(false);
		getTextAtt1().setEditable(false);
	}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
		// enable/disable field
		//getShowInactiveDesc().setEnabled(false);
		getOTMiscType().setEnabled(false);

		getSortOrder().setEditable(false);
		getDescr().setEditable(false);
		getActive().setEditable(false);
		getNumAtt1().setEditable(false);
		getTextAtt1().setEditable(false);
	}

	/* >>> ~13~ Set Disable Fields When Delete ButtonBase Is Clicked ====== <<< */
	@Override
	protected void deleteDisabledFields() {
		// enable/disable field
	}

	/* >>> ~14~ Set Browse Validation ===================================== <<< */
	@Override
	protected boolean browseValidation() {
		if (getOTMiscType().getText() == null
				|| getOTMiscType().isEmpty()) {
			return false;
		}
		return true;
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
				getOTMiscType().getText(), getShowInactive().isSelected() ? "0" : "-1"
			};
	}

	/* >>> ~16.1~ Set Fetch Input Parameters ============================ <<< */
	@Override
	protected String[] getFetchInputParameters() {
		String[] selectedContent = getListSelectedRow();
		return new String[] { selectedContent[7] };
	}

	/* >>> ~16.2~ Set Fetch Output Results ============================== <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {
		int index = 0;
		index++;
		index++;
		getSortOrder().setText(outParam[index++]);
		getDescr().setText(outParam[index++]);
		getActive().setSelected(Boolean.parseBoolean(outParam[index++]));
		getNumAtt1().setText(outParam[index++]);
		getTextAtt1().setText(outParam[index++]);
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {
		if (getSortOrder().isEmpty()) {
			Factory.getInstance().addErrorMessage("Order is mandatory.", getSortOrder());
			actionValidationReady(actionType, false);
		} else if (getDescr().isEmpty()) {
			Factory.getInstance().addErrorMessage("Description is mandatory.", getDescr());
			actionValidationReady(actionType, false);
		} else {
			actionValidationReady(actionType, true);
		}
	}

	/* >>> ~19~ Set Add Action Validation ================================= <<< */
	@Override
	protected boolean addActionValidation() {
		if (getOTMiscType().isEmpty()) {
			Factory.getInstance().addErrorMessage("Please enter the OT Misc Type.", getOTMiscType());
			return false;
		} else {
			return true;
		}
	}

	/* >>> ~21~ Set Add New Row to table ============================== <<< */
	@Override
	protected void clearTableFields() {
		super.clearTableFields();

		setCurrentTable(1, getOTMiscType().getText());
		setCurrentTable(4, ConstantsVariable.NO_VALUE);
	}

	/* >>> ~22~ Set Action Input Parameters per table ===================== <<< */
	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		return new String[] {
				selectedContent[1],
				selectedContent[2],
				selectedContent[3],
				"Y".equals(selectedContent[4]) ? "-1" : "0",
				selectedContent[5],
				selectedContent[6],
				selectedContent[7],
				getUserInfo().getSiteCode()
			};
	}

	/* >>> ~23~ Set Action Validation per table =========================== <<< */
	@Override
	protected boolean actionValidation(String[] selectedContent) {
		boolean success = true;

		if (selectedContent[2] == null || selectedContent[2].trim().length() == 0) {
			Factory.getInstance().addErrorMessage("Order is mandatory.");
			success =  false;
		} else if (selectedContent[3] == null || selectedContent[3].trim().length() == 0) {
			Factory.getInstance().addErrorMessage("Description is mandatory.");
			success = false;
		}
		return success;
	}

	@Override
	protected void setCurrentTable(int columnIndex, String value) {
		if (getRightJTable_OT_Code().getRowCount() > 0) {
			getRightJTable_OT_Code().setValueAt(value, getRightJTable_OT_Code().getSelectedRow(), columnIndex);
		}
	}

	@Override
	public void appendAction() {
		if (getAppendButton().isEnabled() && addActionValidation()) {
			getRightJTable_OT_Code().addRow(new Object[] {null, getOTMiscType().getText(), null, null, new Boolean(false), null, null, null});
			setLastRowNo(getRightJTable_OT_Code().getRowCount() - 1);
			getRightJTable_OT_Code().setSelectRow(getLastRowNo());

			super.appendAction(false);
		}
	}

	private ArrayList deleteRowsOT_Code = new ArrayList();
	@Override
	public void deleteAction() {
		if (getDeleteButton().isEnabled()) {
			deleteAction(false);
			getSaveButton().setEnabled(true);

			deleteSelectedRows(getRightJTable_OT_Code(), deleteRowsOT_Code);
		}
	}

	private void deleteSelectedRows(EditorTableList selectedTable, ArrayList deleteRows) {
		int selectrow = selectedTable.getSelectedRow();
		int rowcount = selectedTable.getRowCount();
		if (selectedTable.getRowCount() > 0) {
			deleteRows.add(selectedTable.getSelectedRowContent());

			// remove selected row from table
			selectedTable.removeRow(selectedTable.getSelectedRow());
			if (selectedTable.getRowCount() > 0) {
				// set select row
				if (selectrow == (rowcount - 1)) {
					selectedTable.setSelectRow(selectrow - 1);
				} else {
					selectedTable.setSelectRow(selectrow);
				}
			} else {
				getSortOrder().clear();
				getActive().clear();
				getDescr().clear();
				getNumAtt1().clear();
				getTextAtt1().clear();
			}
		}
	}

	private void deleteSelectedRowsAction(ArrayList deleteRows, int itemID) {
		if (deleteRows.size() > 0) {
			for (int i = 0; i < deleteRows.size(); i++) {
				String[] tablevalue = (String[]) deleteRows.get(i);
					QueryUtil.executeMasterAction(getUserInfo(), "OTMISCCODETABLE_M_D", QueryUtil.ACTION_DELETE,
							new String[] {tablevalue[itemID]},
							new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						searchAction();
					}
				});
			}
			deleteRows.clear();
		} else {
			searchAction();
		}
	}

	private boolean checkTableValues(String tabNum, EditorTableList eList, boolean noError) {
		List<Record> modRecords = eList.getStore().getModifiedRecords();

		if (modRecords.size() > 0) {
			int rowCount = eList.getRowCount();
			int colCount = eList.getColumnCount();
			int colStart = 0;
			int colEnd = colCount;

			String[][] sourceTableV = null;
			sourceTableV = new String[rowCount][colCount];

			for (int k = 0; k < rowCount; k++) {
				for (int l = colStart, i = 0; l < colEnd || i < colCount; l++, i++) {
					eList.setSelectRow(k);
					sourceTableV[k][i] = eList.getValueAt(k, l);
				}

				String[] selectedContent = sourceTableV[k];
				if (!actionValidation(selectedContent)) {
					noError = false;
					eList.setSelectRow(k);
					break;
				}
			}
		}
		return noError;
	}

	@Override
	public void saveAction() {
		boolean noError = true;

		noError = checkTableValues("1", getRightJTable_OT_Code(), noError);
		if (noError) {
			if (getRightJTable_OT_Code().getStore().getModifiedRecords().size() > 0) {
				getRightJTable_OT_Code().saveTable("OTMISCCODETABLE_M",
						new String[] {getUserInfo().getSiteCode()},
						true, true, false, true, false, "");
			} else {
				deleteSelectedRowsAction(deleteRowsOT_Code, 7);
			}
		}
	}

	@Override
	protected void focusComponentAfterSearch() {
	}

	@Override
	public void searchAction() {
		super.searchAction(false);
	}

	@Override
	protected void loadRelatedTable() {
		getRightJTable_OT_Code().setListTableContent(ConstantsTx.OTMISCCODETABLE_TXCODE, new String[] { getOTMiscType().getText(), getShowInactive().isSelected() ? "0" : "-1" });
	}

	@Override
	public boolean isTableViewOnly() {
		return false;
	}

	@Override
	protected void enableButton(String mode) {
		super.enableButton(mode);
		getAppendButton().setEnabled(!isDisableFunction("TB_INSERT", "mntOTCodeTable"));
		getModifyButton().setEnabled(!isDisableFunction("TB_MODIFY", "mntOTCodeTable"));
		getDeleteButton().setEnabled(!isDisableFunction("TB_DELETE", "mntOTCodeTable"));

		if (isAppend() || isModify() || isDelete()) {
			getModifyButton().setEnabled(false);
			getSearchButton().setEnabled(false);
			getClearButton().setEnabled(true);

			editors2.setEditable(true);
			editors3.setEnabled(true);
			editors4.setEditable(true);
			editors5.setEditable(true);
			editors6.setEnabled(true);
		} else {
			getClearButton().setEnabled(false);
			getRefreshButton().setEnabled(false);

			getSearchButton().setEnabled(true);
			getOTMiscType().setEnabled(true);

			editors2.setEditable(false);
			editors3.setEnabled(false);
			editors4.setEditable(false);
			editors5.setEditable(false);
			editors6.setEnabled(false);
		}

		if (getListTable().getRowCount() == 0) {
			getModifyButton().setEnabled(false);
			getDeleteButton().setEnabled(false);
		}
	}

	@Override
	public void cancelYesAction() {
		searchAction();
	}

	@Override
	public void clearAction() {
		clearTableFields();
		getSortOrder().clear();
		getActive().clear();
		getDescr().clear();
		getNumAtt1().clear();
		getTextAtt1().clear();
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/**
	 * This method initializes leftPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected ColumnLayout getSearchPanel() {
		if (leftPanel == null) {
			leftPanel = new ColumnLayout(3,1);
			//leftPanel.setSize(440, 68);
			leftPanel.add(0,0,getOTMiscTypeDesc());
			leftPanel.add(1,0,getOTMiscType());
			//leftPanel.add(2,0,getShowInactiveDesc());
			leftPanel.add(2,0,getShowInactive());
		}
		return leftPanel;

	}

	public LabelBase getOTMiscTypeDesc() {
		if (OTMiscTypeDesc == null) {
			OTMiscTypeDesc = new LabelBase();
			OTMiscTypeDesc.setText("OT Misc Type");
			//OTMiscTypeDesc.setBounds(74, 10, 88, 20);
		}
		return OTMiscTypeDesc;
	}

	public ComboOTCType getOTMiscType() {
		if (OTMiscType == null) {
			OTMiscType = new ComboOTCType();
			OTMiscType.setSize(149, 20);
			//OTMiscType.setBounds(162, 10, 149, 20);
		}
		return OTMiscType;
	}

/*
	 public LabelBase getShowInactiveDesc() {

		if (ShowInactiveDesc == null) {
			ShowInactiveDesc = new LabelBase();
			ShowInactiveDesc.setText("Show Inactive");
			//ShowInactiveDesc.setBounds(390, 10, 73, 20);
		}
		return ShowInactiveDesc;
	}
*/

	public CheckBoxBase getShowInactive() {
		if (ShowInactive == null) {
			ShowInactive = new CheckBoxBase();
			ShowInactive.setBoxLabel("Show Inactive");
			//ShowInactive.setBounds(464, 10, 18, 20);
		}
		return ShowInactive;
	}

	protected ColumnLayout getActionPanel() {
		if (viewPanel == null) {
			viewPanel = new ColumnLayout(4,3, new int[] {120,200,100,230});
			viewPanel.setBorders(true);
			viewPanel.add(0,0,getSortOrderDesc());
			viewPanel.add(1,0,getSortOrder());
			viewPanel.add(2,0,getActiveDesc());
			viewPanel.add(3,0,getActive());
			viewPanel.add(0,1,getDescrDesc());
			viewPanel.add(1,1,getDescr());
			viewPanel.add(0,2,getNumAtt1Desc());
			viewPanel.add(1,2,getNumAtt1());
			viewPanel.add(2,2,getTextAtt1Desc());
			viewPanel.add(3,2,getTextAtt1());
			//viewPanel.setSize(610, 108);
			viewPanel.setBounds(0, 0, 610, 108);
		}
		return viewPanel;
	}

	public LabelBase getSortOrderDesc() {
		if (SortOrderDesc == null) {
			SortOrderDesc = new LabelBase();
			SortOrderDesc.setText("Sort Order");
			//SortOrderDesc.setBounds(61, 10, 88, 20);
		}
		return SortOrderDesc;
	}

	public TextNum getSortOrder() {
		if (SortOrder == null) {
			SortOrder = new TextNum(10, 0) {
				public void onReleased() {
					 //getRightJTable_OT_Code().set
					getRightJTable_OT_Code().setValueAt(SortOrder.isEmpty() ? "0" : SortOrder.getText(),
							getRightJTable_OT_Code().getSelectedRow(), 2);

				}
			};
			SortOrder.setEditable(false);
			//SortOrder.setBounds(149, 10, 149, 20);
		}
		return SortOrder;
	}

	public LabelBase getActiveDesc() {
		if (ActiveDesc == null) {
			ActiveDesc = new LabelBase();
			ActiveDesc.setText("Active");
			//ActiveDesc.setBounds(377, 10, 74, 20);
		}
		return ActiveDesc;
	}

	public CheckBoxBase getActive() {
		if (Active == null) {
			Active = new CheckBoxBase() {
				public void onClick() {
					getRightJTable_OT_Code().setValueAt(getText(),
							getRightJTable_OT_Code().getSelectedRow(), 4);
				}
			};
			Active.setWidth(1);
			Active.setEditable(false);
		//	Active.setBounds(451, 10, 21, 20);
		}
		return Active;
	}

	public LabelBase getDescrDesc() {
		if (DescrDesc == null) {
			DescrDesc = new LabelBase();
			DescrDesc.setText("Description");
		//	DescrDesc.setBounds(61, 40, 88, 20);
		}
		return DescrDesc;
	}

	public TextString getDescr() {
		if (Descr == null) {
			Descr = new TextString(50) {
				public void onReleased() {
					getRightJTable_OT_Code().setValueAt(getText(),
							getRightJTable_OT_Code().getSelectedRow(), 3);
				}
			};
			Descr.setEditable(false);
		//	Descr.setBounds(149, 40, 149, 20);
		}
		return Descr;
	}

	public LabelBase getNumAtt1Desc() {
		if (NumAtt1Desc == null) {
			NumAtt1Desc = new LabelBase();
			NumAtt1Desc.setText("Numeric Att 1");
		//	NumAtt1Desc.setBounds(61, 70, 88, 20);
		}
		return NumAtt1Desc;
	}

	public TextNum getNumAtt1() {
		if (NumAtt1 == null) {
			NumAtt1 = new TextNum(10) {
				public void onReleased() {
					getRightJTable_OT_Code().setValueAt(getText(),
							getRightJTable_OT_Code().getSelectedRow(), 5);
				}
			};
			NumAtt1.setEditable(false);
		//	NumAtt1.setBounds(149, 71, 149, 20);
		}
		return NumAtt1;
	}

	public LabelBase getTextAtt1Desc() {
		if (TextAtt1Desc == null) {
			TextAtt1Desc = new LabelBase();
			TextAtt1Desc.setText("Text Att 1");
		//	TextAtt1Desc.setBounds(377, 71, 73, 20);
		}
		return TextAtt1Desc;
	}

	public TextString getTextAtt1() {
		if (TextAtt1 == null) {
			TextAtt1 = new TextString(10) {
				public void onReleased() {
					getRightJTable_OT_Code().setValueAt(getText(),
							getRightJTable_OT_Code().getSelectedRow(), 6);
				}
			};
			TextAtt1.setEditable(false);
		}
		return TextAtt1;
	}

	private BasePanel RightBasePanel_OT_Code = null;
	private BasePanel getRightBasePanel_OT_Code() {
		if (RightBasePanel_OT_Code == null) {
			RightBasePanel_OT_Code = new BasePanel();
			RightBasePanel_OT_Code.setHeight(175);
			RightBasePanel_OT_Code.setLayout(null);
			RightBasePanel_OT_Code.add(getRightJTable_OT_Code(), null);
		}
		return RightBasePanel_OT_Code;
	}

	private EditorTableList RightJTable_OT_Code = null;
	private EditorTableList getRightJTable_OT_Code() {
		if (RightJTable_OT_Code == null) {
			RightJTable_OT_Code = new EditorTableList(
					new String[] { " ", "OT Code Type", "Sort Order", "Description",
							"Active", "Numeric Att 1", "Text Att 1", "otcid" },
					new int[] { 10, 120, 80, 160, 50, 95, 95, 0 }, getOT_CodeEditor()
			) {
				@Override
				public void postSaveTable(boolean success, Integer rtnCode, String rtnMsg) {
					if (success) {
						deleteSelectedRowsAction(deleteRowsOT_Code, 7);
						searchAction();
					}
				}

				@Override
				public void onSelectionChanged() {
					if (isAppend() || isModify()) {
						getView().focusRow(getRightJTable_OT_Code().getSelectedRow());
						getSelectionModel().select(getRightJTable_OT_Code().getSelectedRow(), false);
						if (getRightJTable_OT_Code().getSelectedRowContent() != null) {
							getFetchOutputValues(getRightJTable_OT_Code().getSelectedRowContent());
						}
//					} else if (isNoGetDB()) {
					} else if (!isAppend() && getRightJTable_OT_Code().getSelectedRow() > -1) {
						getFetchOutputValues(getRightJTable_OT_Code().getSelectedRowContent());
					}
				};

				@Override
				public void setListTableContentPost() {
					if (getRightJTable_OT_Code().getRowCount() > 0) {
						if (getRightJTable_OT_Code().getSelectedRow() < 0) {
							getRightJTable_OT_Code().setSelectRow(0);
						}
						getRightJTable_OT_Code().focus();
					}
				}
			};
			RightJTable_OT_Code.setHeight(300);
		}
		return RightJTable_OT_Code;
	}

	private TextNum editors2 =  new TextNum(10, 0);
	private TextField<String> editors3 = new TextField<String>();
	private CheckBoxBase editors4 = new CheckBoxBase();
	private TextNum editors5 = new TextNum(10);
	private TextField<String> editors6 = new TextField<String>();
	@SuppressWarnings("unchecked")
	private Field<? extends Object>[] getOT_CodeEditor() {
		Field<? extends Object>[] editors = new Field<?>[8];
		editors[0] = null;
		editors[1] = null;
		editors[2] = editors2;
		editors[3] = editors3;
		editors[4] = editors4;
		editors[5] = editors5;
		editors[6] = editors6;
		editors[7] = null;
		return editors;
	}
}