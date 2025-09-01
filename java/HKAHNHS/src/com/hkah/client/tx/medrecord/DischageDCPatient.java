package com.hkah.client.tx.medrecord;

import java.util.ArrayList;

import com.extjs.gxt.ui.client.event.BaseEvent;
import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.FieldEvent;
import com.extjs.gxt.ui.client.event.GridEvent;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.LayoutContainer;
import com.extjs.gxt.ui.client.widget.form.DateField;
import com.extjs.gxt.ui.client.widget.form.Field;
import com.extjs.gxt.ui.client.widget.layout.FlowLayout;
import com.google.gwt.dom.client.Element;
import com.google.gwt.user.client.Event;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboDest;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.EditorTableList;
import com.hkah.client.layout.textfield.SearchTriggerField;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextSubDiseaseSearch;
import com.hkah.client.layout.textfield.TextSubReasonSearch;
import com.hkah.client.tx.MaintenancePanel;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DischageDCPatient extends MaintenancePanel{
	// property declare start
	private ColumnLayout leftPanel = null;
	private FieldSetBase btmPanel = null;
	private LabelBase fromDateDesc = null;
	private TextDate fromDate = null;
	private LabelBase toDateDesc = null;
	private TextDate toDate = null;
	private LabelBase subDisCodeDesc = null;
	private TextSubDiseaseSearch subDisCode = null;
	private LabelBase patNoDesc = null;
	private TextPatientNoSearch patNo = null;
	private LabelBase codeTotalDesc = null;
	private TextReadOnly codeTotal = null;
	private BasePanel tablePanel = null;
	private JScrollPane tableScrollPanel = null;
	private LabelBase oTotalDesc = null;
	private TextReadOnly oTotal = null;
	private LabelBase NoOfCaseDesc = null;
	private TextReadOnly NoOfCase = null;
//	private ColumnLayout rightPanel;
//	private BasePanel viewPanel = null;
//	private LabelBase received = null;
//	private TextDate receivedDate = null;
//	private LabelBase subDisCodeDesc1 = null;
//	private TextString subReson = null;
//	private LabelBase wardDesc1 = null;
//	private TextString subDis = null;
//	private LabelBase dischg = null;
//	private ComboDest discharges = null;
//	private LabelBase codedateNoDesc11 = null;
//	private TextDate codeDate = null;
	private EditorTableList listTable = null;
	private ArrayList<Integer> redRow = new ArrayList<Integer>();
	private boolean isShowReasonAlert = false;
	private boolean continueSave = false;

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.DISCHARGEDAYPAT_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.DISCHARGEDAYPAT_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
			"","daypid","Patient No.","Patient Name","Registration Date",
			"Dr.Splty","Received","Sub-Disease","Destination","Sub-reason",
			"Code Date","REGID","ISPAIRED","BIRTHDATE"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				10,0,80,120,120,
				70,80,80,80,80,
				80,0,0,0
		};
	}

	private Field<? extends Object>[] getItemDetailEditor() {
		Field<? extends Object>[] editors = new Field<?>[14];
		editors[0] = null;
		editors[1] = null;
		editors[2] = null;
		editors[3] = null;
		editors[4] = null;
		editors[5] = null;
		editors[6] = new TextDate() {
			@Override
			public boolean isValid() {
				disableButton();
				if (isEmpty()) {
					enableButton();
					if (continueSave) {
						saveAction();
					}
					return true;
				} else {
					if (super.isValid() && getRawValue().trim().length() == getStringLength()) {
						alertError(parseDate(getRawValue()) != null, "Invalid receive date!", getEditorListTable().getSelectedRow(), 6);
						return parseDate(getRawValue()) != null;
					} else {
						alertError(false, "Invalid receive date!", getEditorListTable().getSelectedRow(), 6);
						return false;
					}
				}
			}
		};
		editors[7] = getSDCode();
		editors[8] = getDestinationCombo();
		editors[9] = getRSNCode();
		editors[10] = new TextDate() {
			@Override
			public boolean isValid() {
				disableButton();
				if (isEmpty()) {
					enableButton();
					if (continueSave) {
						saveAction();
					}
					return true;
				} else {
					if (super.isValid() && getRawValue().trim().length() == getStringLength()) {
						alertError(parseDate(getRawValue()) != null, "Invalid code date!", getEditorListTable().getSelectedRow(), 10);
						return parseDate(getRawValue()) != null;
					} else {
						alertError(false, "Invalid code date!", getEditorListTable().getSelectedRow(), 10);
						return false;
					}
				}
			}
		};
		editors[11] = null;
		editors[12] = null;
		editors[13] = null;

		return editors;
	}

	private void alertError(boolean noError, String errorMsg, final int row, final int col) {
		if (!noError) {
			continueSave = false;
			Factory.getInstance().addErrorMessage(errorMsg,
					new Listener<MessageBoxEvent>() {
						@Override
						public void handleEvent(MessageBoxEvent be) {
							// TODO Auto-generated method stub
							if (isModify()) {
								getEditorListTable().setValueAt(EMPTY_VALUE, row, col);
								getEditorListTable().setSelectRow(row);
								getEditorListTable().startEditing(row, col);
								enableButton();
							}
						}
			});
		}
		else {
			enableButton();
			if (continueSave) {
				saveAction();
			}
		}
	}
	
	private ComboDest getDestinationCombo() {
		return new ComboDest() {
			public boolean isValid(String text) {
				boolean valid = isEmpty() || super.isValid(text);
				if (isEmpty()) {
					setValue(null);
				}
				
				if (!valid) {
					alertError(false, "Invalid destination!", getEditorListTable().getSelectedRow(), 8);
				}
				else {
					if (continueSave) {
						saveAction();
					}
				}
				return valid;
			}
		};
	}

	private TextSubReasonSearch getRSNCode() {
		TextSubReasonSearch srn = new TextSubReasonSearch() {
			@Override
			public void checkTriggerBySearchKeyPost() {
				getEditorListTable().setValueAt(getText(), getEditorListTable().getSelectedRow(), 9);
			}

			@Override
			public boolean isValid() {
				disableButton();
				if (isEmpty()) {
					enableButton();
					if (continueSave) {
						saveAction();
					}
					return true;
				} else {
					if (super.isValid()) {
						final int row = getEditorListTable().getSelectedRow();
						QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
								new String[] { "SReason", "SRsnCode, SRsnDesc",
												"UPPER(SRsnCode) ='" + getText().toUpperCase() + "' and SRSNNEW = -1 "
								},
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									if (mQueue == null ||
											mQueue.getContentField().length == 0 ||
											mQueue.getContentField()[0].length() == 0) {
										alertError(false, "Invalid sub-reason code!", row, 9);
									}
									else {
										if (continueSave) {
											enableButton();
											saveAction();
										}
									}
								} else {
									alertError(false, "Invalid sub-reason code!", row, 9);
								}
							}
							
							@Override
							public void onComplete() {
								super.onComplete();
								enableButton();
							}
						});
						return true;
					} else {
						alertError(false, "Invalid sub-reason code!", getEditorListTable().getSelectedRow(), 9);
						return false;
					}
				}
			}
		};
		return srn;
	}

	private TextSubDiseaseSearch getSDCode() {
		TextSubDiseaseSearch txt = new TextSubDiseaseSearch(false, true) {
			@Override
			public void checkTriggerBySearchKeyPost() {
				getEditorListTable().setValueAt(getText(), getEditorListTable().getSelectedRow(), 7);
			}

			@Override
			public boolean isValid() {
				disableButton();
				if (isEmpty()) {
					enableButton();
					if (continueSave) {
						saveAction();
					}
					return true;
				} else {
					if (super.isValid()) {
						final int row = getEditorListTable().getSelectedRow();
						QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
								new String[] { "SDisease", "SdsCode, SdsDesc",
												"UPPER(SdsCode) ='"  + getText().toUpperCase() + "' and SDSNEW = -1 "
								},
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									if (mQueue == null ||
											mQueue.getContentField().length == 0 ||
											mQueue.getContentField()[0].length() == 0) {
										alertError(false, "Invalid sub-disease code!", row, 7);
									}
									else {
										if (continueSave) {
											enableButton();
											saveAction();
										}
									}
								} else {
									alertError(false, "Invalid sub-disease code!", row, 7);
								}
							}
							
							@Override
							public void onComplete() {
								super.onComplete();
								enableButton();
							}
						});
						return true;
					} else {
						alertError(false, "Invalid sub-disease code!", getEditorListTable().getSelectedRow(), 7);
						return false;
					}
				}
			}
		};
		txt.setMaxLength(3);

		return txt;
	}

	/**
	 * This method initializes
	 *
	 */
	public DischageDCPatient() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		isShowReasonAlert = false;
		continueSave = false;
		getEditorListTable().removeAllRow();
		getSummary();
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public Component getDefaultFocusComponent() {
		enableButton();
		return getFromDate();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
		getAppendButton().setEnabled(false);
	}

	/* >>> ~13~ Set Disable Fields When Delete ButtonBase Is Clicked ====== <<< */
	@Override
	protected void deleteDisabledFields() {
		// enable/disable field
	}

	/* >>> ~14~ Set Browse Validation ===================================== <<< */
	@Override
	protected boolean browseValidation() {
		if (getFromDate().isEmpty() || getToDate().isEmpty()) {
			Factory.getInstance().addErrorMessage("Date range start, date range to must be entered!", getFromDate());
			return false;
		} else if (DateTimeUtil.dateDiff(getToDate().getText(), getFromDate().getText()) < 0) {
			Factory.getInstance().addErrorMessage("Date range to date must after or equal to the start date!", getToDate());
			return false;
		} else {
			return true;
		}
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
				getUserInfo().getSiteCode(),
				getFromDate().getText(),
				getToDate().getText(),
				getSubDisCode().getText().replace(",","/"),
				getPatNo().getText()
		};
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

	@Override
	public void searchAction() {
		if (!triggerSearchField()) {
			searchAction(false);
		}
	}

	@Override
	public void searchAction(boolean showMessage) {
		if (browseValidation() && (getActionType() == null || getActionType().equals(QueryUtil.ACTION_FETCH))) {
			getMainFrame().setLoading(true);
			getEditorListTable().setListTableContent(getTxCode(), getBrowseInputParameters());
		}
	}

	@Override
	public void modifyAction() {
		setActionType(QueryUtil.ACTION_MODIFY);
		//getEditorListTable().disableEvents(false);
		enableButton();
	}

	@Override
	public void saveAction() {
		if (getSaveButton().isEnabled()) {
			continueSave = false;
			getEditorListTable().saveTable(getTxCode(),
					new String[] {
						getUserInfo().getUserID()
					},
					false,
					false,
					false,
					true,
					false,
					getTitle());
		}
		else {
			continueSave = false;
		}
	}

	@Override
	protected void cancelPostAction() {
		super.cancelPostAction();
		setActionType(null);
		searchAction(false);
	}

	@Override
	protected String[] getListSelectedRow() {
		return getEditorListTable().getSelectedRowContent();
	}

	@Override
	protected void enableButton(String mode) {
		disableButton();

		getSearchButton().setEnabled(true);
		getModifyButton().setEnabled(getEditorListTable().getRowCount() > 0 && !isModify());
		getSaveButton().setEnabled(isModify());
		getCancelButton().setEnabled(isModify());
	}

	/* >>> ~22~ Set Action Input Parameters per table ===================== <<< */
	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		return null;
	}

	/* >>> ~23~ Set Action Validation per table =========================== <<< */
	@Override
	protected boolean actionValidation(String[] selectedContent) {
		return true;
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	private void checkRsncode() {
		//to set some cell color to red or black
		redRow.clear();

		for (int i = 0; i < getEditorListTable().getRowCount(); i++) {
			String isPaired = ((String) getEditorListTable().getStore().getAt(i).getValue(12)).trim();
			String subReason = ((String) getEditorListTable().getStore().getAt(i).getValue(9)).trim();

			if (isPaired.length() == 0 || ZERO_VALUE.equals(isPaired)) {
				continue;
			} else if (isPaired.equals("-1")) {
				if (subReason.length() == 0) {
					Element patNoCell = getEditorListTable().getView().getCell(i, 2);
					Element patNameCell = getEditorListTable().getView().getCell(i, 3);
					Element subDiseaseCell = getEditorListTable().getView().getCell(i, 7);
					Element subReasoneCell = getEditorListTable().getView().getCell(i, 9);

					if (patNoCell != null && patNoCell.getInnerHTML().toLowerCase().indexOf("background-color") == -1) {
						redRow.add(i);
						patNoCell.setInnerHTML("<span style='background-color:red'>"+
													patNoCell.getInnerHTML()+
												"</span>");
					}

					if (patNameCell != null && patNameCell.getInnerHTML().toLowerCase().indexOf("background-color") == -1) {
						patNameCell.setInnerHTML("<span style='background-color:red'>"+
													patNameCell.getInnerHTML()+
												"</span>");
					}

					if (subDiseaseCell != null && subDiseaseCell.getInnerHTML().toLowerCase().indexOf("background-color") == -1) {
						subDiseaseCell.setInnerHTML("<span style='background-color:red'>"+
													subDiseaseCell.getInnerHTML()+
													"</span>");
					}

					if (subReasoneCell != null && subReasoneCell.getInnerHTML().toLowerCase().indexOf("background-color") == -1) {
						subReasoneCell.setInnerHTML("<span style='background-color:red'>"+
														subReasoneCell.getInnerHTML()+
													"</span>");
					}
				}
			}
		}

		if (redRow.size() > 0) {
			if (isShowReasonAlert) {
				Factory.getInstance().addInformationMessage("Missing Reason Code.");
				isShowReasonAlert = false;
			}
		} else {
			isShowReasonAlert = false;
		}

		getEditorListTable().getView().layout();
	}

	private void resetColumnColor() {
		for (int i = 0; i < redRow.size(); i++) {
			Element patNoCell = getEditorListTable().getView().getCell(redRow.get(i), 2);
			Element patNameCell = getEditorListTable().getView().getCell(redRow.get(i), 3);
			Element subDiseaseCell = getEditorListTable().getView().getCell(redRow.get(i), 7);
			Element subReasoneCell = getEditorListTable().getView().getCell(redRow.get(i), 9);

			if (patNoCell != null && patNoCell.getInnerHTML().toLowerCase().indexOf("background-color") == -1) {
				patNoCell.setInnerHTML("<span style='background-color:red'>"+
											patNoCell.getInnerHTML()+
										"</span>");
			}

			if (patNameCell != null && patNameCell.getInnerHTML().toLowerCase().indexOf("background-color") == -1) {
				patNameCell.setInnerHTML("<span style='background-color:red'>"+
											patNameCell.getInnerHTML()+
										"</span>");
			}

			if (subDiseaseCell != null && subDiseaseCell.getInnerHTML().toLowerCase().indexOf("background-color") == -1) {
				subDiseaseCell.setInnerHTML("<span style='background-color:red'>"+
											subDiseaseCell.getInnerHTML()+
											"</span>");
			}

			if (subReasoneCell != null && subReasoneCell.getInnerHTML().toLowerCase().indexOf("background-color") == -1) {
				subReasoneCell.setInnerHTML("<span style='background-color:red'>"+
												subReasoneCell.getInnerHTML()+
											"</span>");
			}
		}
	}

	private void getSummary() {
		int cntcde = 0, cnt000=0, cntcas=0;
		for (int i = 0; i < getEditorListTable().getRowCount(); i++) {
			if (getEditorListTable().getStore().getAt(i).getValue(7).toString().trim().length() > 0) {
				cntcde++;
			}

			if ("000".equals(getEditorListTable().getStore().getAt(i).getValue(7).toString().trim())) {
				cnt000++;
			}

			if (!getFromDate().isEmpty() && !getToDate().isEmpty()) {
				String regdate = getEditorListTable().getStore().getAt(i).getValue(4).toString().substring(0, 10);
				String fromdate = getFromDate().getText();
				String todate = getToDate().getText();
				if (DateTimeUtil.dateDiff(regdate, fromdate) >=0 && DateTimeUtil.dateDiff(regdate, todate) <= 0) {
					cntcas++;
				}
			}
		}
		getCodeTotal().setText(String.valueOf(cntcde));
		getOTotal().setText(String.valueOf(cnt000));
		getNoOfCase().setText(String.valueOf(cntcas));
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	@Override
	protected LayoutContainer getBodyPanel() {
		LayoutContainer panel = new LayoutContainer();
		panel.setBorders(false);
		panel.setLayout(new FlowLayout(10));
		panel.setStyleAttribute("padding-left","10px");
		panel.add(getLeftPanel());
		panel.add(getTablePanel());
		panel.add(getBtmPanel());
		return panel;
	}

	public ColumnLayout getSearchPanel() {
		if (leftPanel == null) {
			leftPanel = new ColumnLayout(4, 2);
			leftPanel.setSize(800, 90);
			leftPanel.setHeading("Selection Criteria");
			leftPanel.add(0, 0, getFromDateDesc());
			leftPanel.add(1, 0, getFromDate());
			leftPanel.add(2, 0, getSubDisCodeDesc());
			leftPanel.add(3, 0, getSubDisCode());
			leftPanel.add(0, 1, getToDateDesc());
			leftPanel.add(1, 1, getToDate());
			leftPanel.add(2, 1, getPatNoDesc());
			leftPanel.add(3, 1, getPatNo());
		}
		return leftPanel;
	}

	public LabelBase getFromDateDesc() {
		if (fromDateDesc == null) {
			fromDateDesc = new LabelBase();
			fromDateDesc.setText("Date Range From");
			fromDateDesc.setBounds(9, 20, 110, 20);
		}
		return fromDateDesc;
	}

	public TextDate getFromDate() {
		if (fromDate == null) {
			fromDate = new TextDate();
			fromDate.setBounds(0, 0, 120, 20);
		}
		return fromDate;
	}

	public LabelBase getToDateDesc() {
		if (toDateDesc == null) {
			toDateDesc = new LabelBase();
			toDateDesc.setText("To");
			toDateDesc.setBounds(270, 20, 57, 20);
		}
		return toDateDesc;
	}

	public TextDate getToDate() {
		if (toDate == null) {
			toDate = new TextDate();
			toDate.setBounds(0, 0, 120, 20);
		}
		return toDate;
	}

	public LabelBase getSubDisCodeDesc() {
		if (subDisCodeDesc == null) {
			subDisCodeDesc = new LabelBase();
			subDisCodeDesc.setText("Sub-Disease Code");
			subDisCodeDesc.setBounds(9, 55, 110, 20);
		}
		return subDisCodeDesc;
	}

	public TextSubDiseaseSearch getSubDisCode() {
		if (subDisCode == null) {
			subDisCode = new TextSubDiseaseSearch();
			subDisCode.setBounds(0, 0, 120, 20);
		}
		return subDisCode;
	}

	public LabelBase getPatNoDesc() {
		if (patNoDesc == null) {
			patNoDesc = new LabelBase();
			patNoDesc.setText("Patient No.");
			patNoDesc.setBounds(270, 55, 100, 20);
		}
		return patNoDesc;
	}

	public TextPatientNoSearch getPatNo() {
		if (patNo == null) {
			patNo = new TextPatientNoSearch();
			patNo.setBounds(0, 0, 120, 20);
		}
		return patNo;
	}

	public FieldSetBase getBtmPanel() {
		if (btmPanel == null) {
			btmPanel = new FieldSetBase();
			btmPanel.setHeading("Summary");
			btmPanel.add(getCodeTotalDesc(), null);
			btmPanel.add(getCodeTotal(), null);
			btmPanel.add(getOTotalDesc(), null);
			btmPanel.add(getOTotal(), null);
			btmPanel.add(getNoOfCaseDesc(), null);
			btmPanel.add(getNoOfCase(), null);
			btmPanel.setSize(800, 69);
		}
		return btmPanel;
	}

	public LabelBase getCodeTotalDesc() {
		if (codeTotalDesc == null) {
			codeTotalDesc = new LabelBase();
			codeTotalDesc.setText("Coded Total");
			codeTotalDesc.setBounds(5, 0, 80, 20);
		}
		return codeTotalDesc;
	}

	public TextReadOnly getCodeTotal() {
		if (codeTotal == null) {
			codeTotal = new TextReadOnly();
			codeTotal.setBounds(5, 20, 80, 20);
		}
		return codeTotal;
	}

	public LabelBase getOTotalDesc() {
		if (oTotalDesc == null) {
			oTotalDesc = new LabelBase();
			oTotalDesc.setText("\"000\" Total");
			oTotalDesc.setBounds(90, 0, 80, 20);
		}
		return oTotalDesc;
	}

	public TextReadOnly getOTotal() {
		if (oTotal == null) {
			oTotal = new TextReadOnly();
			oTotal.setBounds(90, 20, 80, 20);
		}
		return oTotal;
	}

	public LabelBase getNoOfCaseDesc() {
		if (NoOfCaseDesc == null) {
			NoOfCaseDesc = new LabelBase();
			NoOfCaseDesc.setText("No. of Cases");
			NoOfCaseDesc.setBounds(175, 0, 110, 20);
		}
		return NoOfCaseDesc;
	}

	public TextReadOnly getNoOfCase() {
		if (NoOfCase == null) {
			NoOfCase = new TextReadOnly();
			NoOfCase.setBounds(175, 20, 110, 20);
		}
		return NoOfCase;
	}
	
	private void handleArrowKey(int keyCode, int editColumn) {
		if (keyCode == 38) {	// arrow_up
			moveToNextRowField(true, false, editColumn);
		} else if (keyCode == 40) {	// arrow_down
			moveToNextRowField(false, true, editColumn);
		}
	}
	
	private void moveToNextRowField(boolean up, boolean down, int editColumn) {
		int editRow = getEditorListTable().getActiveEditor().row;
		int nextRow = up ? editRow - 1 : editRow + 1;

		if (nextRow >= 0 && nextRow < getEditorListTable().getRowCount()) {
			getEditorListTable().stopEditing();
			getEditorListTable().setSelectRow(nextRow);
			getEditorListTable().startEditing(nextRow, editColumn);
		}
	}
	
	private void tableFieldHelper(FieldEvent be, int editingCol) {
		if (be.getKeyCode() == 112) { //F1
			if (be.getSource() instanceof SearchTriggerField) {
				((SearchTriggerField)be.getSource()).showSearchPanel();
			}
		} else if (be.getKeyCode() == 117) { //F6
			if (getSaveButton().isEnabled()) {
				be.preventDefault();
				if (getEditorListTable().getActiveEditor().col == 6 || 
						getEditorListTable().getActiveEditor().col == 7 || 
						//getEditorListTable().getActiveEditor().row == 8 || 
						getEditorListTable().getActiveEditor().col == 9 || 
						getEditorListTable().getActiveEditor().col == 10) {
					Field f = getEditorListTable().getActiveEditor().getField();
					boolean isEmpty = f.getRawValue() == null || (f.getRawValue().toString()).length() == 0;
					boolean isDate = f.getRawValue() != null && f instanceof TextDate;
					if (isEmpty || isDate) {
						getEditorListTable().getActiveEditor().completeEdit();
					}
					continueSave = true;
					getEditorListTable().stopEditing();
					if (isEmpty || isDate) {
						f.isValid();
					}
				}
				else {
					if (getEditorListTable().getActiveEditor() != null) {
						Field f = getEditorListTable().getActiveEditor().getField();
						boolean isEmpty = f.getRawValue() == null || (f.getRawValue().toString()).length() == 0;
						if (isEmpty) {
							getEditorListTable().getActiveEditor().completeEdit();
						}
					}
					getEditorListTable().stopEditing();
					saveAction();
				}
			}
		} else if (be.getKeyCode() == 119) { //F8
			if (getCancelButton().isEnabled()) {
				be.preventDefault();
				getEditorListTable().stopEditing(true);
				cancelAction();
			}
		}
	}


	protected EditorTableList getEditorListTable() {
		int sum = 0;
		if (listTable == null) {
			for (int element : getColumnWidths()) {
				sum += element;
			}

			listTable = new EditorTableList(getColumnNames(), getColumnWidths(),
											getItemDetailEditor()) {
				@Override
				public void postSaveTable(boolean success, Integer rtnCode, String rtnMsg) {
					if (success) {
						setActionType(null);
						isShowReasonAlert = true;
						searchAction(false);
					} else {
						Factory.getInstance().addErrorMessage("Invalid Data, cannot save data!");
					}
				}

				@Override
				public void setListTableContentPost() {
					getMainFrame().setLoading(false);
					if (getRowCount() <= 0) {
						Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_NO_RECORD_FOUND);
					}
					getSummary();
					checkRsncode();
					enableButton();
				}

				@Override
				public void onComponentEvent(ComponentEvent ce) {
					if (ce.getEventTypeInt() == Event.ONCLICK ||
							ce.getEventTypeInt() == Event.ONDBLCLICK) {
						if (isModify()) {
							super.onComponentEvent(ce);
						}
					} else {
						super.onComponentEvent(ce);
					}
				}

				@Override
				public void setValueAt(String aValue, int row, int column) {
					super.setValueAt(aValue, row, column);
					resetColumnColor();
				}
				
				@Override
				protected void columnKeyDownHandler(FieldEvent be, int editingCol) {
					if (be.getSource() instanceof DateField) {
						if (be.getKeyCode() == 8 || be.getKeyCode() == 46) {
							return;
						}
 					}
					
					handleArrowKey(be.getKeyCode(), editingCol);
					if (!(be.getSource() instanceof CheckBoxBase)) {
						tableFieldHelper(be, editingCol);
					}
				}

				@Override
				protected void afterRenderView() {
					super.afterRenderView();
					for (int i = 0; i < getColumnCount(); i++) {
						if (getColumnModel().getColumn(i) != null &&
								getColumnModel().getColumn(i).getEditor() != null) {
							getColumnModel().getColumn(i).getEditor().addListener(Events.Complete,
									new Listener<BaseEvent>() {
										@Override
										public void handleEvent(BaseEvent be) {
											// TODO Auto-generated method stub
											resetColumnColor();
										}
							});
						}
					}

					getView().addListener(Events.Refresh, new Listener<BaseEvent>() {
						@Override
						public void handleEvent(BaseEvent be) {
							// TODO Auto-generated method stub
							resetColumnColor();
						}
					});
				}

			};
			listTable.setWidth(sum);
			listTable.setAutoHeight(true);
			listTable.addStyleName("master-panel-table-list");

			listTable.addListener(Events.AfterEdit, new Listener<GridEvent>() {
				@Override
				public void handleEvent(GridEvent be) {
					resetColumnColor();
				}
			});
		}
		return listTable;
	}

	private BasePanel getTablePanel() {
		if (tablePanel == null) {
			tablePanel = new BasePanel();
			tablePanel.setEtchedBorder();
			tablePanel.add(getTableScrollPanel());
			tablePanel.setSize(800, 220);
		}
		return tablePanel;
	}

	private JScrollPane getTableScrollPanel() {
		if (tableScrollPanel == null) {
			tableScrollPanel = new JScrollPane();
			tableScrollPanel.setViewportView(getEditorListTable());
			tableScrollPanel.setBounds(5, 5, 790, 210);
		}
		return tableScrollPanel;
	}

	@Override
	protected boolean triggerSearchField() {
		if (getPatNo().isFocusOwner()) {
			getPatNo().setOldPatientNo(EMPTY_VALUE);
			getPatNo().checkTriggerBySearchKey();
			return true;
		} else if (isModify()) {
			getSubDisCode().checkTriggerBySearchKey();
			return true;
		}

		return false;
	}

	@Override
	protected LayoutContainer getActionPanel() {
		// TODO Auto-generated method stub
		return null;
	}
}