package com.hkah.client.tx.transaction;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.event.BaseEvent;
import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.EventType;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.FieldEvent;
import com.extjs.gxt.ui.client.event.GridEvent;
import com.extjs.gxt.ui.client.event.KeyListener;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.store.ListStore;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.form.Field;
import com.extjs.gxt.ui.client.widget.form.TextField;
import com.google.gwt.event.dom.client.KeyCodes;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboSuppCategory;
import com.hkah.client.layout.combobox.ComboSuppCode;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.table.EditorTableList;
import com.hkah.client.layout.table.TableData;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.SearchTriggerField;
import com.hkah.client.layout.textfield.TextAmount;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.tx.ActionPanel;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TableUtil;
import com.hkah.shared.constants.ConstantsTransaction;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class SupplementaryLink extends ActionPanel {

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

	private LabelBase RightJLabel_SuppCategory = null;
	private ComboSuppCategory RightJText_SuppCategory = null;
	private LabelBase RightJLabel_SuppCode = null;
	private ComboSuppCode RightJText_SuppCode = null;
	private LabelBase RightJLabel_AvailableSupp = null;
	private TableList RightJTable_AvailableSupp = null;
	private LabelBase RightJLabel_SelectedSupp = null;
	private EditorTableList RightJTable_SelectedSupp = null;
	private LabelBase RightJLabel_ShowHist = null;
	private CheckBoxBase RightJCheckBox_ShowHist = null;

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
	private int orgSelectedSuppRow = 0;
	private boolean isDocChecking = false;
	private boolean isRemarkChecking = false;

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		return null;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.SUPP_TITLE;
	}

	public SupplementaryLink() {
		super();
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		stnID = getParameter("StnID");
		patNo = getParameter("PatNo");
		patName = getParameter("PatName");
		patCName = getParameter("PatCName");
		patSex = getParameter("PatSex");
		itmCode = getParameter("ItmCode");
		itmDesc = getParameter("ItmDesc");

		disableButton();
		getModifyButton().setEnabled(true);

		getRightJText_SuppCategory().setEnabled(true);
		getRightJTable_AvailableSupp().setEnabled(true);
		getRightJTable_SelectedSupp().setEnabled(true);
		getRightJCheckBox_ShowHist().setEnabled(true);
		getRightJText_SuppCode().setEnabled(true);

		getRightJText_PatientNum().setText(patNo);
		getRightJText_PatientName().setText(patName);
		getRightJText_PatientCName().setText(patCName);
		getRightJText_PatientSex().setText(patSex);
		getRightJText_ChargeCode().setText(itmCode);
		getRightJText_ChargeName().setText(itmDesc);

		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] { "SLIPTX", "SLPNO, DOCCODE", "STNID = '" + stnID + "' " },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				slpNo = mQueue.getContentField()[0];
				docCode_O = mQueue.getContentField()[1];
// 				Should be check in getDocCodeFieldEvent
/*
				QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
						new String[] { "SLIP", "DOCCODE", "SLPNO = '" + slpNo + "' " },
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						docCode_T = mQueue.getContentField()[0];
					}
				});
*/
			}
		});
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public ComboSuppCategory getDefaultFocusComponent() {
		return getRightJText_SuppCategory();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {
		disableButton();
		getRightJCheckBox_ShowHist().setEnabled(true);
		getRightJText_SuppCategory().setEnabled(true);
		getRightJText_SuppCode().setEnabled(true);
		getRightJTable_AvailableSupp().setEnabled(true);
		getRightJTable_SelectedSupp().setEnabled(true);
		getModifyButton().setEnabled(true);

		ArrayList listeners = (ArrayList)getRightJTable_AvailableSupp().getListeners(Events.RowDoubleClick);
		for (int i = 0; i < listeners.size(); i++) {
			getRightJTable_AvailableSupp().removeListener(Events.RowDoubleClick,
					(Listener<? extends BaseEvent>) listeners.get(i));
		}
		reloadTableList(true, true);
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
//		setActionType(QueryUtil.ACTION_MODIFY);
		enableButton(null);
		getRightJCheckBox_ShowHist().setEnabled(false);
		getRightJTable_SelectedSupp().getColumnModel().getEditor(4).getField().setReadOnly(false);
		getRightJTable_SelectedSupp().getColumnModel().getEditor(5).getField().setReadOnly(false);
		getRightJTable_SelectedSupp().getColumnModel().getEditor(6).getField().setReadOnly(false);
		getRightJTable_SelectedSupp().getColumnModel().getEditor(7).getField().setReadOnly(false);
		
		if (!getRightJTable_AvailableSupp().hasListeners(Events.RowDoubleClick)) {
			getRightJTable_AvailableSupp().addListener(Events.RowDoubleClick,
					getAvailableSuppListener(Events.RowDoubleClick));
		}
		if (!getRightJTable_AvailableSupp().hasListeners(Events.OnKeyPress)) {
			getRightJTable_AvailableSupp().addListener(Events.OnKeyPress,
					getAvailableSuppListener(Events.OnKeyPress));
		}
		getRightJText_SuppCategory().focus();
	}

	@Override
	public void deleteAction() {
		Factory.getInstance().isConfirmYesNoDialog("PBA-["+getTitle()+"]","Delete the Supp?", new Listener<MessageBoxEvent>() {
			@Override
			public void handleEvent(MessageBoxEvent be) {
				if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
					setActionType(QueryUtil.ACTION_DELETE);
					deletePostAction();
				}
			}
		});
	}

	@Override
	public void deletePostAction() {
		QueryUtil.executeMasterAction(getUserInfo(), ConstantsTx.SUPP_TXCODE,
				QueryUtil.ACTION_DELETE,
				new String[] {
					stnID,
					getUserInfo().getUserID(),
					getRightJTable_SelectedSupp().getSelectedRowContent()[0]
				},
				new String[1][EditorTableList.DEFAULT_STRUCT_DESC_COLUMN],
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				setActionType(null);
				enableButton(null);
				reloadTableList(true, true);
			}
		});
	}

	@Override
	public void saveAction() {
		isDocChecking = true;
		if (!validating) {
			enableButton(null);
			getMainFrame().setLoading(true);
			getRightJCheckBox_ShowHist().setEnabled(true);

			getRightJTable_SelectedSupp().saveTable(ConstantsTx.SUPP_TXCODE,
					new String[] {
						stnID,
						getUserInfo().getUserID(),
						getUserInfo().getUserID()
					},
					false,
					false,
					false,
					true,
					false,
					"Supp");
		}
	}

	@Override
	protected void savePostAction() {
		isDocChecking = false;
		isRemarkChecking = false;
	}

	@Override
	protected void cancelPostAction() {
		super.cancelPostAction();
		docCode_T = null;
	}

	@Override
	protected void enableButton(String mode) {
		disableButton();
		getModifyButton().setEnabled(!isModify() && !isDisableFunction("TB_MODIFY", "secTxnSupp") &&
				!getRightJCheckBox_ShowHist().getValue());
		getDeleteButton().setEnabled(!isModify() && !isDisableFunction("TB_DELETE", "secTxnSupp") &&
				getRightJTable_SelectedSupp().getRowCount() > 0 && !getRightJCheckBox_ShowHist().getValue());
		getCancelButton().setEnabled(isModify());
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	private void tableFieldHelper(FieldEvent be, int editingCol) {
		if (be.getKeyCode() == 112) { //F1
			if (be.getSource() instanceof SearchTriggerField) {
				((SearchTriggerField)be.getSource()).showSearchPanel();
			}
		} else if (be.getKeyCode() == 113) {	// F2
			if (getAppendButton().isEnabled()) {
				getRightJTable_SelectedSupp().stopEditing(false);
				appendAction();
			}
		} else if (be.getKeyCode() == 116) {	// F5
			if (getDeleteButton().isEnabled()) {
				be.preventDefault();
				getRightJTable_SelectedSupp().stopEditing(true);
				deleteAction();
			}
		} else if (be.getKeyCode() == 117) { //F6
			if (getSaveButton().isEnabled()) {
				be.preventDefault();
				getRightJTable_SelectedSupp().stopEditing(false);
				saveAction();
			}
		} else if (be.getKeyCode() == 119) { //F8
			if (getCancelButton().isEnabled()) {
				be.preventDefault();
				getRightJTable_SelectedSupp().stopEditing(true);
				cancelAction();
			}
		} else if (be.getKeyCode() == KeyCodes.KEY_TAB) {
			int idx = getEditGridColIdx().indexOf(editingCol) + (be.isShiftKey() ? -1 : 1);

			if (idx < 0) {
				be.preventDefault();
				getRightJTable_SelectedSupp().stopEditing(false);
				getRightJText_SuppCode().requestFocus();
			} else if (idx >= getEditGridColIdx().size()) {
				be.preventDefault();
				getRightJTable_SelectedSupp().stopEditing(false);
				getRightJText_SuppCategory().requestFocus();
			}
		}
	}

	private void handleArrowKey(int keyCode, int editColumn) {
		if (keyCode == 38) {	// arrow_up
			moveToNextRowField(true, false, editColumn);
		} else if (keyCode == 40) {	// arrow_down
			moveToNextRowField(false, true, editColumn);
		}
	}

	private void moveToNextRowField(boolean up, boolean down, int editColumn) {
		int editRow = getRightJTable_SelectedSupp().getActiveEditor().row;
		int nextRow = up ? editRow - 1 : editRow + 1;

		if (nextRow >= 0 && nextRow < getRightJTable_SelectedSupp().getRowCount()) {
			getRightJTable_SelectedSupp().stopEditing();
			getRightJTable_SelectedSupp().setSelectRow(nextRow);
			getRightJTable_SelectedSupp().startEditing(nextRow, editColumn);
		}
	}

	private LinkedList<Integer> getEditGridColIdx() {
		if (editGridColIdx == null) {
			editGridColIdx = new LinkedList<Integer>();
			Field<? extends Object>[] list = getSelectedSuppFields();
			for (int i = 0; i < list.length; i++) {
				if (list[i] != null) {
					editGridColIdx.add(i);
				}
			}
		}
		return editGridColIdx;
	}

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
//			patAndItemDetailPanel.add(getRightJText_StnID(), null);
		}
		return patAndItemDetailPanel;
	}

	public BasePanel getSuppPanel() {
		if (suppPanel == null) {
			suppPanel = new BasePanel();
			suppPanel.setEtchedBorder();
			suppPanel.setBounds(5, 70, 810, 420);
			suppPanel.add(getRightJLabel_SuppCategory(), null);
			suppPanel.add(getRightJText_SuppCategory(), null);
			suppPanel.add(getRightJText_SuppCode(), null);
			suppPanel.add(getRightJLabel_SuppCode(), null);
			suppPanel.add(getRightJLabel_AvailableSupp(), null);
			suppPanel.add(getRightJTable_AvailableSupp(), null);
			suppPanel.add(getRightJLabel_SelectedSupp(), null);
			suppPanel.add(getRightJLabel_ShowHist(), null);
			suppPanel.add(getRightJCheckBox_ShowHist(), null);
			suppPanel.add(getRightJTable_SelectedSupp(), null);
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

	public LabelBase getRightJLabel_SuppCategory() {
		if (RightJLabel_SuppCategory == null) {
			RightJLabel_SuppCategory = new LabelBase();
			RightJLabel_SuppCategory.setText("Supp. Category");
			RightJLabel_SuppCategory.setBounds(5, 5, 90, 20);
		}
		return RightJLabel_SuppCategory;
	}

	public ComboSuppCategory getRightJText_SuppCategory() {
		if (RightJText_SuppCategory == null) {
			RightJText_SuppCategory = new ComboSuppCategory() {
				@Override
				protected void setTextPanel(ModelData modelData) {
					if (modelData != null) {
						if (getText() != null) {
							getRightJText_SuppCode().initContent(getText(), stnID);
						} else {
							getRightJText_SuppCode().initContent(null, stnID);
						}
					} else {
						getRightJText_SuppCode().removeAllItems();
					}
				}

				@Override
				protected void resetContentPost() {
					this.setSelectedIndex(0);
					getRightJText_SuppCode().removeAllItems();
//					this.fireEvent(Events.Select);
				}
			};
			RightJText_SuppCategory.setBounds(100, 5, 200, 20);
//			RightJText_SuppCategory.addListener(Events.Select,
//				new Listener<FieldEvent>() {
//					@Override
//					public void handleEvent(FieldEvent be) {
//						reloadTableList(true, true);
//					}
//				});
		}
		return RightJText_SuppCategory;
	}

	public LabelBase getRightJLabel_SuppCode() {
		if (RightJLabel_SuppCode == null) {
			RightJLabel_SuppCode = new LabelBase();
			RightJLabel_SuppCode.setText("Supp. Code");
			RightJLabel_SuppCode.setBounds(325, 5, 90, 20);
		}
		return RightJLabel_SuppCode;
	}

	public ComboSuppCode getRightJText_SuppCode() {
		if (RightJText_SuppCode == null) {
			RightJText_SuppCode = new ComboSuppCode(getRightJText_SuppCategory().getText(), stnID) {
				@Override
				protected void resetContentPost() {
					reloadTableList(true, true);
				}
			};
			RightJText_SuppCode.setBounds(400, 5, 200, 20);
			RightJText_SuppCode.addKeyListener(new KeyListener() {
				@Override
				public void componentKeyDown(ComponentEvent event) {
					if (event.getKeyCode() == KeyCodes.KEY_TAB && !event.isShiftKey()) {
						if (getRightJTable_SelectedSupp().getRowCount() > 0) {
							if (!(getRightJTable_SelectedSupp().getSelectedRow() >= 0)) {
								getRightJTable_SelectedSupp().setSelectRow(0);
							}
							getRightJTable_SelectedSupp().startEditing(getRightJTable_SelectedSupp().getSelectedRow(), 4);
						} else {
							getRightJTable_AvailableSupp().focus();
						}
					}
				}

				@Override
				public void componentKeyPress(ComponentEvent event) {
					super.componentKeyPress(event);
					if (RightJText_SuppCode.getText() != null && RightJText_SuppCode.getText().length() > 0) {
						if (event.getKeyCode() == KeyCodes.KEY_ENTER && QueryUtil.ACTION_MODIFY.equals(getActionType())) {
							if (RightJText_SuppCode.getStore().getCount() > 0) {
								TableList etl = getRightJTable_AvailableSupp();
								if (checkExistItemInList(RightJText_SuppCode.getText()) > -1) {
									etl.setSelectRow(checkExistItemInList(RightJText_SuppCode.getText()) - 1);
									String[] selectedContent = etl.getSelectedRowContent();
									int targetColCount = getRightJTable_SelectedSupp().getColumnCount();

									String[] columnNames = getRightJTable_SelectedSupp().getColumnIDs();
									Object[] fields = new Object[targetColCount];

									fields[0] = "";
									for (int i = 0; i < selectedContent.length; i++) {
										fields[i + 1] = selectedContent[i];
									}
									if (getRightJTable_SelectedSupp().getStore().getCount() > 0) {
										ListStore<TableData> store = getRightJTable_SelectedSupp().getStore();
										TableData rowData = store.getAt(0);
										fields[4] = rowData.get(TableUtil.getName2ID("Order By"));
									} else {
										fields[4] = docCode_O;
									}
									fields[5] = docCode_T;
									fields[6] = "";
									fields[7] = "";
									fields[8] = getUserInfo().getUserID();
									fields[9] = getMainFrame().getServerDate();
									fields[10] = "";
									fields[11] = "";
									fields[12] = getMainFrame().getServerTime();
									fields[13] = "";

									TableData newModel = new TableData(columnNames, fields);
									//etl.getStore().remove(etl.getSelectedRow());
									getRightJTable_SelectedSupp().getStore().insert(newModel, 0);
									getRightJTable_SelectedSupp().setSelectRow(0);
									getRightJTable_SelectedSupp().getView().focusRow(0);
									getSaveButton().setEnabled(true);
									getRightJText_SuppCode().resetText();
									getRightJText_SuppCode().focus();
								} else {
									getRightJText_SuppCode().resetText();
									getRightJText_SuppCode().focus();
								}
							}
						}
					}
				}
			});
		}
		return RightJText_SuppCode;
	}

	public LabelBase getRightJLabel_AvailableSupp() {
		if (RightJLabel_AvailableSupp == null) {
			RightJLabel_AvailableSupp = new LabelBase();
			RightJLabel_AvailableSupp.setText("Available Supp");
			RightJLabel_AvailableSupp.setStyleAttribute("font-wight", "bold");
			RightJLabel_AvailableSupp.setBounds(5, 40, 90, 20);
		}
		return RightJLabel_AvailableSupp;
	}

	public TableList getRightJTable_AvailableSupp() {
		if (RightJTable_AvailableSupp == null) {
			RightJTable_AvailableSupp =
					new TableList(getAvailableSuppColumnNames(), getAvailableSuppColumnWidths()) {
				@Override
				public void setListTableContentPost() {
					getRightJText_SuppCode().focus();
				}
			};
			RightJTable_AvailableSupp.setId("available-supp-table");
//			RightJTable_AvailableSupp.setAutoHeight(true);
			RightJTable_AvailableSupp.setBounds(5, 65, 790, 150);
		}
		return RightJTable_AvailableSupp;
	}

	private Listener<GridEvent> getAvailableSuppListener(EventType et) {
		if (et.equals(Events.RowDoubleClick)) {
			return new Listener<GridEvent>() {
				@Override
				public void handleEvent(GridEvent be) {
					TableList etl = getRightJTable_AvailableSupp();
					String[] selectedContent = etl.getSelectedRowContent();
					int targetColCount = getRightJTable_SelectedSupp().getColumnCount();

					String[] columnNames = getRightJTable_SelectedSupp().getColumnIDs();
					Object[] fields = new Object[targetColCount];

					fields[0] = "";
					for (int i = 0; i < selectedContent.length; i++) {
						fields[i + 1] = selectedContent[i];
					}

					if (getRightJTable_SelectedSupp().getStore().getCount() > 0) {
						ListStore<TableData> store = getRightJTable_SelectedSupp().getStore();
						TableData rowData = store.getAt(0);
						fields[4] = rowData.get(TableUtil.getName2ID("Order By"));
					} else {
						fields[4] = docCode_O;
					}
					fields[5] = docCode_T;
					fields[6] = "";
					fields[7] = "";
					fields[8] = getUserInfo().getUserID();
					fields[9] = getMainFrame().getServerDate();
					fields[10] = "";
					fields[11] = "";
					fields[12] = getMainFrame().getServerTime();
					fields[13] = "";

					TableData newModel = new TableData(columnNames, fields);
					//etl.getStore().remove(etl.getSelectedRow());
					getRightJTable_SelectedSupp().getStore().insert(newModel, 0);
					getRightJTable_SelectedSupp().setSelectRow(0);
					getRightJTable_SelectedSupp().getView().focusRow(0);

					getSaveButton().setEnabled(true);
				}
			};
		} else if (et.equals(Events.OnKeyPress)) {
			return new Listener<GridEvent>() {
				@Override
				public void handleEvent(GridEvent be) {
						if (be.getKeyCode() == 13) {
							TableList etl = getRightJTable_AvailableSupp();
							if (etl.getSelectedRow() >= 0) {
								String[] selectedContent = etl.getSelectedRowContent();
								int targetColCount = getRightJTable_SelectedSupp()
																	.getColumnCount();

								String[] columnNames = getRightJTable_SelectedSupp()
																			.getColumnIDs();
								Object[] fields = new Object[targetColCount];

								fields[0] = "";
								for (int i = 0; i < selectedContent.length; i++) {
									fields[i+1] = selectedContent[i];
								}
								fields[4] = docCode_O;
								fields[5] = docCode_T;
								fields[6] = "";
								fields[7] = "";
								fields[8] = getUserInfo().getUserID();
								fields[9] = getMainFrame().getServerDate();
								fields[10] = "";
								fields[11] = "";
								fields[12] = getMainFrame().getServerTime();
								fields[13] = "";

								TableData newModel = new TableData(columnNames, fields);
								//etl.getStore().remove(etl.getSelectedRow());
								getRightJTable_SelectedSupp().getStore().insert(newModel, 0);
								getRightJTable_SelectedSupp().setSelectRow(0);
								getRightJTable_SelectedSupp().getView().focusRow(0);

								getSaveButton().setEnabled(true);
							}
						}
					}
			};
		}
		return null;
	}

	private String[] getAvailableSuppColumnNames() {
		return new String[] { "Category Code", "Supp Code", "Description" };
	}

	private int[] getAvailableSuppColumnWidths() {
		return new int[] { 200, 200, 300 };
	}

	private Field[] getAvailableSuppFields() {
		return new Field[] { null, null, null };
	}

	public LabelBase getRightJLabel_SelectedSupp() {
		if (RightJLabel_SelectedSupp == null) {
			RightJLabel_SelectedSupp = new LabelBase();
			RightJLabel_SelectedSupp.setText("Selected Supp");
			RightJLabel_SelectedSupp.setStyleAttribute("font-wight", "bold");
			RightJLabel_SelectedSupp.setBounds(5, 220, 90, 20);
		}
		return RightJLabel_SelectedSupp;
	}

	public LabelBase getRightJLabel_ShowHist() {
		if (RightJLabel_ShowHist == null) {
			RightJLabel_ShowHist = new LabelBase();
			RightJLabel_ShowHist.setText("Show History");
			RightJLabel_ShowHist.setBounds(685, 220, 80, 20);
		}
		return RightJLabel_ShowHist;
	}

	public CheckBoxBase getRightJCheckBox_ShowHist() {
		if (RightJCheckBox_ShowHist == null) {
			RightJCheckBox_ShowHist = new CheckBoxBase();
			RightJCheckBox_ShowHist.setBounds(770, 220, 10, 20);
			RightJCheckBox_ShowHist.addListener(Events.OnClick,
				new Listener<FieldEvent>() {
					@Override
					public void handleEvent(FieldEvent be) {
						boolean checked = getRightJCheckBox_ShowHist().getValue();

						getModifyButton().setEnabled(!checked);
						reloadTableList(false, true);
					}
				});
		}
		return RightJCheckBox_ShowHist;
	}
	
	private TextAmount getAmount() {
		TextAmount amt = new TextAmount(true);
		return amt;
	}

	public EditorTableList getRightJTable_SelectedSupp() {
		if (RightJTable_SelectedSupp == null) {
			RightJTable_SelectedSupp =
				new EditorTableList(getSelectedSuppColumnNames(),
									getSelectedSuppColumnWidths(),
									getSelectedSuppFields(), false,
									null, null) {
				@Override
				public void setListTableContentPost() {
					if (getStore().getCount() > 0) {
						boolean checked = getRightJCheckBox_ShowHist().getValue();
						getRightJTable_SelectedSupp().setSelectRow(1);
						getRightJTable_SelectedSupp().getColumnModel().getEditor(4).getField().setReadOnly(!isModify() || checked);
						getRightJTable_SelectedSupp().getColumnModel().getEditor(5).getField().setReadOnly(!isModify() || checked);
						getRightJTable_SelectedSupp().getColumnModel().getEditor(6).getField().setReadOnly(!isModify() || checked);
						getRightJTable_SelectedSupp().getColumnModel().getEditor(7).getField().setReadOnly(!isModify() || checked);


						orgSelectedSuppRow = getStore().getCount();
						enableButton(null);
					} else {
//						getDeleteButton().setEnabled(false);
					}
				}

				@Override
				public void postSaveTable(boolean success, Integer rtnCode, String rtnMsg) {
					if (success) {
						reloadTableList(true, true);
						setActionType(null);
					}

					getMainFrame().setLoading(false);
				}

				@Override
				protected void columnKeyDownHandler(FieldEvent be, int editingCol) {
					handleArrowKey(be.getKeyCode(), editingCol);
					if (!(be.getSource() instanceof CheckBoxBase)) {
						tableFieldHelper(be, editingCol);
					}
				}
			};
			RightJTable_SelectedSupp.setId("selected-supp-table");
//			RightJTable_SelectedSupp.setAutoHeight(true);
			RightJTable_SelectedSupp.setBounds(5, 245, 790, 150);
			RightJTable_SelectedSupp.addListener(Events.RowClick,
				new Listener<GridEvent>() {
					@Override
					public void handleEvent(GridEvent be) {
						if (prevSelectedRow == -1) {
							prevSelectedRow = getRightJTable_SelectedSupp().getSelectedRow();
						} else {
							if (validating) {
								getRightJTable_SelectedSupp().setSelectRow(prevSelectedRow);
							} else {
								prevSelectedRow = getRightJTable_SelectedSupp().getSelectedRow();
							}
						}
					}
				});

			RightJTable_SelectedSupp.addListener(Events.CellClick,
				new Listener<GridEvent>() {
					@Override
					public void handleEvent(GridEvent be) {
						if (prevSelectedRow ==
								getRightJTable_SelectedSupp().getSelectedRow()) {
							if (getRightJTable_SelectedSupp().getActiveEditor() != null) {
								if (prevSelectedCol == getRightJTable_SelectedSupp().getActiveEditor().col || prevSelectedCol == -1) {
									getRightJTable_SelectedSupp().getActiveEditor().getField().fireEvent(Events.OnBlur);
								}
							}
						}
					}
				});

			RightJTable_SelectedSupp.addListener(Events.RowDoubleClick,
				new Listener<GridEvent>() {
					@Override
					public void handleEvent(GridEvent be) {
						EditorTableList etl = ((EditorTableList)be.getGrid());
						String[] content = etl.getSelectedRowContent();

						if (content[0].length() > 0) {
							return;
						} else {
							int targetColCount = getRightJTable_AvailableSupp().getColumnCount();

							String[] columnNames = getRightJTable_AvailableSupp().getColumnIDs();
							Object[] fields = new Object[targetColCount];

							fields[0] = content[1];
							fields[1] = content[2];
							fields[2] = content[3];

							TableData newModel = new TableData(columnNames, fields);
							etl.getStore().remove(etl.getSelectedRow());
							//getRightJTable_AvailableSupp().getStore().insert(newModel, 0);
							getRightJTable_AvailableSupp().setSelectRow(0);
							getRightJTable_AvailableSupp().getView().focusRow(0);

							if (etl.getRowCount() == orgSelectedSuppRow && etl.getStore().getModifiedRecords().size() == 0) {
								getSaveButton().setEnabled(false);
							}
						}
					}
				});

			RightJTable_SelectedSupp.addListener(Events.OnKeyPress,
					new Listener<GridEvent>() {
						@Override
						public void handleEvent(GridEvent be) {
							if (be.getKeyCode() == 13) {
								EditorTableList etl = ((EditorTableList)be.getGrid());
								if (etl.getSelectedRow() >= 0) {
									String[] content = etl.getSelectedRowContent();

									if (content[0].length() > 0) {
										return;
									} else {
										int targetColCount = getRightJTable_AvailableSupp().getColumnCount();
										String[] columnNames = getRightJTable_AvailableSupp().getColumnIDs();
										Object[] fields = new Object[targetColCount];

										fields[0] = content[1];
										fields[1] = content[2];
										fields[2] = content[3];

										TableData newModel = new TableData(columnNames, fields);
										//etl.getStore().remove(etl.getSelectedRow());
										getRightJTable_AvailableSupp().getStore().insert(newModel, 0);
										getRightJTable_AvailableSupp().setSelectRow(0);
										getRightJTable_AvailableSupp().getView().focusRow(0);

										if (etl.getRowCount() == orgSelectedSuppRow &&
											etl.getStore().getModifiedRecords().size() == 0) {
											getSaveButton().setEnabled(false);
										}
									}
								}
							}
						}
					});
		}
		return RightJTable_SelectedSupp;
	}

	private String[] getSelectedSuppColumnNames() {
		return new String[] { "TSLID", "Category Code", "Supp Code", "Description",
						"Order By", "Treat By", "Remark","Amount", "Added By",
						"Add Date", "Cancel By", "Cancel Date", "Add Time",
						"Cancel Time" };
	}

	private int[] getSelectedSuppColumnWidths() {
		return new int[] { 0, 180, 150, 300,
						100, 100, 300,120, 120,
						150, 120, 150, 0,
						0 };
	}

	private Field[] getSelectedSuppFields() {
		TextField<String> docCode_O_Field = new TextField<String>();
		TextField<String> docCode_T_Field = new TextField<String>();
		TextField<String> remark = new TextField<String>();
		TextField<String> amt = new TextField<String>();

		docCode_O_Field.setName("docCode_O");
		docCode_O_Field.addListener(Events.OnBlur, getDocCodeFieldEvent());
		docCode_O_Field.addListener(Events.SpecialKey, getDocCodeFieldEvent());

		docCode_T_Field.setName("docCode_T");
		docCode_T_Field.addListener(Events.OnBlur, getDocCodeFieldEvent());
		docCode_T_Field.addListener(Events.SpecialKey, getDocCodeFieldEvent());

		remark.setName("remark");
		remark.addListener(Events.OnBlur, getRemarkEvent());
		remark.addListener(Events.SpecialKey, getRemarkEvent());
		
		amt.setName("amount");
		amt.addListener(Events.OnBlur, getAmountEvent());
		amt.addListener(Events.SpecialKey, getAmountEvent());

		return new Field[] { null, null, null, null, docCode_O_Field,
						docCode_T_Field, remark,amt, null, null, null, null, null,
						null };
	}
	
	public Listener<FieldEvent> getAmountEvent() {
		return new Listener<FieldEvent>() {
			@Override
			public void handleEvent(FieldEvent be) {
				if (be.getKeyCode() == 8 || be.getKeyCode() == 46 || validating) {
					return;
				}

				validating = true;
				TextField<String> f = (TextField<String>) be.getField();
				String amt = f.getValue();

				prevSelectedCol = 7;

				if (amt != null && amt.length() > 0) {
					if (Double.parseDouble(amt) < 0) {
						final int sr = prevSelectedRow;
						getRightJTable_SelectedSupp().setSelectRow(sr);

						Factory.getInstance().addErrorMessage(
								"Amount can not be negative",
								new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
									getRightJTable_SelectedSupp().startEditing(sr, 7);
									validating = false;
							}
						});
					} else {
						validating = false;
					}
				} else {
					validating = false;
				}

				if (getRightJTable_SelectedSupp().getRowCount() == orgSelectedSuppRow &&
					getRightJTable_SelectedSupp().getStore().getModifiedRecords().size() == 0) {
					getSaveButton().setEnabled(false);
				} else {
					getSaveButton().setEnabled(true);
				}
			}
		};
	}

	public Listener<FieldEvent> getRemarkEvent() {
		return new Listener<FieldEvent>() {
			@Override
			public void handleEvent(FieldEvent be) {
				if (be.getKeyCode() == 8 || be.getKeyCode() == 46 || validating) {
					return;
				}

				validating = true;
				TextField<String> f = (TextField<String>) be.getField();
				String remark = f.getValue();

				prevSelectedCol = 6;

				if (remark != null && remark.length() > 0) {
					if (remark.length() > 100) {
						final int sr = prevSelectedRow;
						getRightJTable_SelectedSupp().setSelectRow(sr);

						Factory.getInstance().addErrorMessage(
								"Remark field can not be longer than 100.",
								new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
									getRightJTable_SelectedSupp().startEditing(sr, 6);
									validating = false;
							}
						});
					} else {
						validating = false;
					}
				} else {
					validating = false;
				}

				if (getRightJTable_SelectedSupp().getRowCount() == orgSelectedSuppRow &&
					getRightJTable_SelectedSupp().getStore().getModifiedRecords().size() == 0) {
					getSaveButton().setEnabled(false);
				} else {
					getSaveButton().setEnabled(true);
				}
			}
		};
	}

	public Listener<FieldEvent> getDocCodeFieldEvent() {
		return
			new Listener<FieldEvent>() {
				@Override
				public void handleEvent(FieldEvent be) {
					if (be.getKeyCode() == 8 || be.getKeyCode() == 46 ||
							validating) {
						return;
					}

					validating = true;
					final TextField<String> f = (TextField<String>) be.getField();
					String docCode = f.getValue();

					if (f.getName().equals("docCode_O")) {
						prevSelectedCol = 4;
					} else if (f.getName().equals("docCode_T")) {
						prevSelectedCol = 5;
					}

					if (docCode != null && docCode.length() > 0) {
						QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
								new String[] { "DOCTOR", "DOCCODE, DOCSTS", "DOCCODE = '" + docCode + "' " },
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								boolean error = false;

								if (mQueue.getContentField().length > 0) {
									if (mQueue.getContentField()[0] != null && mQueue.getContentField()[0].length() > 0) {
										String docCode = mQueue.getContentField()[0];
										String isActive = mQueue.getContentField()[1];

										if (docCode == null ||
											docCode.length() <= 0 ||
											Integer.parseInt(isActive) == 0) {
											error = true;
										} else {
											if (f.getName().equals("docCode_T")) {
												docCode_T = docCode;
											}
											error = false;
										}
									} else {
										error = true;
									}
								} else {
									error = true;
								}

								if (error) {
									final int sr = prevSelectedRow;
									getRightJTable_SelectedSupp().setSelectRow(sr);

									Factory.getInstance().addErrorMessage("Invalid Doctor Code.",
											new Listener<MessageBoxEvent>() {
										@Override
										public void handleEvent(MessageBoxEvent be) {
											if (f.getName().equals("docCode_O")) {
												getRightJTable_SelectedSupp().startEditing(sr, 4);
											} else if (f.getName().equals("docCode_T")) {
												getRightJTable_SelectedSupp().startEditing(sr, 5);
											}
											validating = false;
										}
									});
									isDocChecking = false;
								} else {
									validating = false;
									if (isDocChecking) {
										isDocChecking = false;
										saveAction();
									}

								}
							}
						});
					} else {
						validating = false;
						isDocChecking = false;
					}

					if (getRightJTable_SelectedSupp().getRowCount() == orgSelectedSuppRow
							&& getRightJTable_SelectedSupp().getStore().getModifiedRecords().size() == 0) {
						getSaveButton().setEnabled(false);
					} else {
						getSaveButton().setEnabled(true);
					}
				}
			};
	}

	public void reloadTableList(boolean isAvailable, boolean isSelected) {
		if (isAvailable) {
			getRightJTable_AvailableSupp().setListTableContent(ConstantsTx.SUPP_TXCODE,
					new String[] { "true",
									getRightJCheckBox_ShowHist().getValue().toString(), stnID,
									getRightJText_SuppCategory().getText() });
			getRightJText_SuppCode().initContent(getRightJText_SuppCategory().getText(),stnID);
		}
		if (isSelected) {
			getRightJTable_SelectedSupp().setListTableContent(ConstantsTx.SUPP_TXCODE,
					new String[] { "false",
									getRightJCheckBox_ShowHist().getValue().toString(),
									stnID, "" });
		}
	}

	public int checkExistItemInList(String checkValue) {
		List<TableData> tableList = getRightJTable_AvailableSupp().getStore().getModels();
		int noOfRow = tableList.size();

		final ListStore<TableData> store = getRightJTable_AvailableSupp().getStore();
		for(int i = 0; i < noOfRow; i++) {
			final TableData rowData = store.getAt(i);
			if (checkValue.equals(rowData.get(TableUtil.getName2ID("Supp Code")))) {
				return i+1;
			}
		}
		return -1;
	}
}