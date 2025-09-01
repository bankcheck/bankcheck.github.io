package com.hkah.client.tx.medrecord;

import java.util.ArrayList;

import com.extjs.gxt.ui.client.Style.Scroll;
import com.extjs.gxt.ui.client.data.BaseModelData;
import com.extjs.gxt.ui.client.data.ModelData;
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
import com.extjs.gxt.ui.client.widget.form.TextField;
import com.extjs.gxt.ui.client.widget.layout.FlowLayout;
import com.google.gwt.dom.client.Element;
import com.google.gwt.user.client.Event;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboDest;
import com.hkah.client.layout.combobox.ComboMRIPRmk;
import com.hkah.client.layout.combobox.ComboWard;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.table.EditorTableList;
import com.hkah.client.layout.textfield.SearchTriggerField;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextNum;
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

public class DischagePatient extends MaintenancePanel{

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.DISCHARGEDPAT_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.DISCHARGEDPAT_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
			"NB", 				"Inpid", 			"Patient No.", 			"Patient Name", 	"Mother Pat. No.",
			"New Born", 		"Admission Date", 	"Discharged Date", 		"Ward", 			"Sub-Disease Code", 
			"Discharge To", 	"Sub-reason Code",	"Dr.Splty",				"Received Date", 	"Nursery", 			
			"Code Date", 		"Still Born", 		"Comp", 				"Inpat Remark", 	"Original NB",
			"regid", 			"ISPAIRED", 		"Birthday", 			"NBdata", 			"CompData",
			"Inp.Rmk(COVID)"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				28, 0, 50, 110, 75,
				40, 110, 110, 40, 80, 
				80, 80,	80,	80, 80, 
				80, 55, 50, 150, 0,
				0, 0, 0, 0, 0, 150
		};
	}

	private Field<? extends Object>[] getItemDetailEditor() {
		Field<? extends Object>[] editors = new Field<?>[26];
		editors[0] = null;
		editors[1] = null;
		editors[2] = null;
		editors[3] = null;
		editors[4] = null;
		editors[5] = new CheckBoxBase();
		editors[6] = null;
		editors[7] = null;
		editors[8] = null;
		editors[12] = null;
		editors[13] = new TextDate() {
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
						alertError(parseDate(getRawValue()) != null, "Invalid receive date!", getEditorListTable().getSelectedRow(), 13);
						return parseDate(getRawValue()) != null;
					} else {
						alertError(false, "Invalid receive date!", getEditorListTable().getSelectedRow(), 13);
						return false;
					}
				}
			}
		};
		editors[14] = new TextDate() {
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
						alertError(parseDate(getRawValue()) != null, "Invalid nursery date!", getEditorListTable().getSelectedRow(), 14);
						return parseDate(getRawValue()) != null;
					} else {
						alertError(false, "Invalid nursery date!", getEditorListTable().getSelectedRow(), 14);
						return false;
					}
				}
			}
		};
		editors[9] = getSDCode();
		editors[10] = getDestinationCombo();
		editors[11] = getRSNCode();
		editors[15] = new TextDate() {
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
						alertError(parseDate(getRawValue()) != null, "Invalid code date!", getEditorListTable().getSelectedRow(), 15);
						return parseDate(getRawValue()) != null;
					} else {
						alertError(false, "Invalid code date!", getEditorListTable().getSelectedRow(), 15);
						return false;
					}
				}
			}
		};
		editors[16] = new TextNum();
		editors[17] = new CheckBoxBase();
		editors[18] = new TextField<String>();
		editors[19] = null;
		editors[20] = null;
		editors[21] = null; //ispaired
		editors[22] = null;
		editors[23] = null;
		editors[24] = null;
		editors[25] = getMRIPRmkCombo();

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
					alertError(false, "Invalid destination!", getEditorListTable().getSelectedRow(), 10);
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
	
	private ComboMRIPRmk getMRIPRmkCombo() {
		return new ComboMRIPRmk(){
			public boolean isValid(String text) {
				boolean valid = isEmpty() || super.isValid(text);
				if (isEmpty() || !valid) {
					setValue(null);
				}
				
				if (valid) {
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
				getEditorListTable().setValueAt(getText(), getEditorListTable().getSelectedRow(), 11);
			}

			@Override
			public boolean isValid() {
				disableButton();
				if (isEmpty()) {
					setValue(EMPTY_VALUE);
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
										alertError(false, "Invalid sub-reason code!", row, 11);
									}
									else {
										if (continueSave) {
											enableButton();
											saveAction();
										}
									}
								} else {
									alertError(false, "Invalid sub-reason code!", row, 11);
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
						alertError(false, "Invalid sub-reason code!", getEditorListTable().getSelectedRow(), 11);
						return false;
					}
				}
			}
		};
		return srn;
	}

	//Arran Added
	private TextSubDiseaseSearch getSDCode() {
		TextSubDiseaseSearch txt = new TextSubDiseaseSearch(false, true) {
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
										alertError(false, "Invalid sub-disease code!", row, 9);
									}
									else {
										if (continueSave) {
											enableButton();
											saveAction();
										}
									}
								} else {
									alertError(false, "Invalid sub-disease code!", row, 9);
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
						alertError(false, "Invalid sub-disease code!", getEditorListTable().getSelectedRow(), 9);
						return false;
					}
				}
			}
		};
		txt.setMaxLength(3);

		return txt;
	}
	

	



	// property declare start
	private ColumnLayout leftPanel = null;
	private BasePanel btmPanel = null;
	private LabelBase fromDateDesc = null;
	private TextDate fromDate = null;
	private LabelBase toDateDesc = null;
	private TextDate toDate = null;
	private LabelBase subDisCodeDesc = null;
	private TextSubDiseaseSearch subDisCode = null;
	private LabelBase wardDesc = null;
	private ComboWard ward = null;
	private LabelBase patNoDesc = null;
	private TextPatientNoSearch patNo = null;
	private LabelBase codeTotalDesc = null;
	private TextReadOnly codeTotal = null;

	private LabelBase oTotalDesc = null;
	private TextReadOnly oTotal = null;
	private LabelBase NoOfAdmissionDesc = null;
	private TextReadOnly NoOfAdmission = null;
	private LabelBase NoOfDischargeDesc = null;
	private TextReadOnly NoOfDischarge = null;
	private LabelBase NoOfNewBornAdmissionDesc = null;
	private TextReadOnly NoOfNewBornAdmission = null;
	private LabelBase NoOfNewBornDischargeDesc = null;
	private TextReadOnly NoOfNewBornDischarge = null;
	private EditorTableList listTable = null;
	private ArrayList<Integer> redRow = new ArrayList<Integer>();
	private boolean isShowReasonAlert = false;
	private boolean continueSave = false;

	// property declare end

	/**
	 * This method initializes
	 *
	 */
	public DischagePatient() {
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
		getFromDate().setText("01/04/2022");
		getToDate().setText("01/05/2022");
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
			Factory.getInstance().addErrorMessage("Date range start, date range end must be entered!", getFromDate());
			return false;
		} else {
			if (!getFromDate().isValid()) {
				getFromDate().resetText();
				Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_INVALID_DATE, getFromDate());
				return false;
			}

			if (!getToDate().isValid()) {
				getToDate().resetText();
				Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_INVALID_DATE, getToDate());
				return false;
			}

			if (DateTimeUtil.dateDiff(toDate.getText(), fromDate.getText()) < 0) {
				Factory.getInstance().addErrorMessage("Date range end date must after or equal to the start date!", getToDate());
				return false;
			}
		}

		return true;
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
				getUserInfo().getSiteCode(),
				getFromDate().getText(),
				getToDate().getText(),
				getSubDisCode().getText().replace(",","/"),
				getWard().getText(),
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
	protected void getFetchOutputValues(String[] outParam) {}

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

	public ColumnLayout getSearchPanel() {
		if (leftPanel == null) {
			leftPanel = new ColumnLayout(6,2, new int[] {133, 200, 50, 230, 68, 200});
			leftPanel.setHeading("Selection Criteria");
			leftPanel.setSize(770, 88);
			leftPanel.add(0,0,getFromDateDesc());
			leftPanel.add(1,0,getFromDate());
			leftPanel.add(2,0,getToDateDesc());
			leftPanel.add(3,0,getToDate());
			leftPanel.add(0,1,getSubDisCodeDesc());
			leftPanel.add(1,1,getSubDisCode());
			leftPanel.add(2,1,getWardDesc());
			leftPanel.add(3,1,getWard());
			leftPanel.add(4,1,getPatNoDesc());
			leftPanel.add(5,1,getPatNo());
		}
		return leftPanel;
	}

	public BasePanel getBtmPanel() {
		if (btmPanel == null) {
			btmPanel = new BasePanel();
			btmPanel.setHeading("Summary");
			btmPanel.setSize(765, 67);
			btmPanel.setLocation(3, 20);
			btmPanel.add(getCodeTotalDesc(),null);
			btmPanel.add(getCodeTotal(),null);
			btmPanel.add(getOTotalDesc(),null);
			btmPanel.add(getOTotal(),null);
			btmPanel.add(getNoOfAdmissionDesc(),null);
			btmPanel.add(getNoOfAdmission(),null);
			btmPanel.add(getNoOfDischargeDesc(),null);
			btmPanel.add(getNoOfDischarge(),null);
			btmPanel.add(getNoOfNewBornAdmissionDesc(),null);
			btmPanel.add(getNoOfNewBornAdmission(),null);
			btmPanel.add(getNoOfNewBornDischargeDesc(),null);
			btmPanel.add(getNoOfNewBornDischarge(),null);

		}
		return btmPanel;
	}

	public LabelBase getFromDateDesc() {
		if (fromDateDesc == null) {
			fromDateDesc = new LabelBase();
			fromDateDesc.setText("Date Range From");
			fromDateDesc.setBounds(5, 20, 110, 20);
		}
		return fromDateDesc;
	}

	public TextDate getFromDate() {
		if (fromDate == null) {
			fromDate = new TextDate();
			//fromDate.setBounds(125, 20, 120, 20);
			fromDate.setSize(120, 20);
		}
		return fromDate;
	}

	public LabelBase getToDateDesc() {
		if (toDateDesc == null) {
			toDateDesc = new LabelBase();
			toDateDesc.setText("To");
			toDateDesc.setBounds(250, 20, 30, 20);
		}
		return toDateDesc;
	}

	public TextDate getToDate() {
		if (toDate == null) {
			toDate = new TextDate();
			//toDate.setBounds(291, 20, 120, 20);
			toDate.setSize(120, 20);
		}
		return toDate;
	}

	public LabelBase getSubDisCodeDesc() {
		if (subDisCodeDesc == null) {
			subDisCodeDesc = new LabelBase();
			subDisCodeDesc.setText("Sub-Disease Code");
			subDisCodeDesc.setBounds(6, 45, 110, 20);
		}
		return subDisCodeDesc;
	}

	public TextSubDiseaseSearch getSubDisCode() {
		if (subDisCode == null) {
			subDisCode = new TextSubDiseaseSearch(false, true) {
				@Override
				public void checkTriggerBySearchKeyPost() {
					if (isModify()) {
						String acceptValue = getText();
						resetText();
						getEditorListTable().setValueAt(acceptValue, getEditorListTable().getSelectedRow(), 9);
					}
				}
			};
			subDisCode.setBounds(0, 0, 120, 20);
		}
		return subDisCode;
	}

	public LabelBase getWardDesc() {
		if (wardDesc == null) {
			wardDesc = new LabelBase();
			wardDesc.setText("Ward");
			wardDesc.setBounds(250, 45, 35, 20);
		}
		return wardDesc;
	}

	public ComboWard getWard() {
		if (ward == null) {
			ward = new ComboWard();
			ward.setBounds(0, 0, 150, 20);
		}
		return ward;
	}

	public LabelBase getPatNoDesc() {
		if (patNoDesc == null) {
			patNoDesc = new LabelBase();
			patNoDesc.setText("Patient No.");
			patNoDesc.setBounds(435, 45, 85, 20);
		}
		return patNoDesc;
	}

	public TextPatientNoSearch getPatNo() {
		if (patNo == null) {
			patNo = new TextPatientNoSearch(false) {
				@Override
				protected void checkPatient(boolean isExistPatient, boolean bySearchKey) {
					if (bySearchKey) {
						super.checkPatient(isExistPatient, bySearchKey);
					}
				}

				@Override
				public void onBlurPost() {
					// override in child class
					searchAction(false);
				}
			};
			patNo.setBounds(0, 0, 100, 20);
		}
		return patNo;
	}

	public LabelBase getCodeTotalDesc() {
		if (codeTotalDesc == null) {
			codeTotalDesc = new LabelBase();
			codeTotalDesc.setText("Coded Total");
			codeTotalDesc.setBounds(5, 20, 80, 20);
		}
		return codeTotalDesc;
	}

	public TextReadOnly getCodeTotal() {
		if (codeTotal == null) {
			codeTotal = new TextReadOnly();
			codeTotal.setBounds(5, 40, 80, 20);
		}
		return codeTotal;
	}

	public LabelBase getOTotalDesc() {
		if (oTotalDesc == null) {
			oTotalDesc = new LabelBase();
			oTotalDesc.setText("\"000\" Total");
			oTotalDesc.setBounds(90, 20, 80, 20);
		}
		return oTotalDesc;
	}

	public TextReadOnly getOTotal() {
		if (oTotal == null) {
			oTotal = new TextReadOnly();
			oTotal.setBounds(90, 40, 80, 20);
		}
		return oTotal;
	}

	public LabelBase getNoOfAdmissionDesc() {
		if (NoOfAdmissionDesc == null) {
			NoOfAdmissionDesc = new LabelBase();
			NoOfAdmissionDesc.setText("No. of admission");
			NoOfAdmissionDesc.setBounds(175, 20, 110, 20);
		}
		return NoOfAdmissionDesc;
	}

	public TextReadOnly getNoOfAdmission() {
		if (NoOfAdmission == null) {
			NoOfAdmission = new TextReadOnly();
			NoOfAdmission.setBounds(175, 40, 110, 20);
		}
		return NoOfAdmission;
	}

	public LabelBase getNoOfDischargeDesc() {
		if (NoOfDischargeDesc == null) {
			NoOfDischargeDesc = new LabelBase();
			NoOfDischargeDesc.setText("No. of discharged");
			NoOfDischargeDesc.setBounds(290, 20, 110, 20);
		}
		return NoOfDischargeDesc;
	}

	public TextReadOnly getNoOfDischarge() {
		if (NoOfDischarge == null) {
			NoOfDischarge = new TextReadOnly();
			NoOfDischarge.setBounds(290, 40, 110, 20);
		}
		return NoOfDischarge;
	}

	public LabelBase getNoOfNewBornAdmissionDesc() {
		if (NoOfNewBornAdmissionDesc == null) {
			NoOfNewBornAdmissionDesc = new LabelBase();
			NoOfNewBornAdmissionDesc.setText("No. of new born admission");
			NoOfNewBornAdmissionDesc.setBounds(405, 20, 170, 20);
		}
		return NoOfNewBornAdmissionDesc;
	}

	public TextReadOnly getNoOfNewBornAdmission() {
		if (NoOfNewBornAdmission == null) {
			NoOfNewBornAdmission = new TextReadOnly();
			NoOfNewBornAdmission.setBounds(405, 40, 170, 20);
		}
		return NoOfNewBornAdmission;
	}

	public LabelBase getNoOfNewBornDischargeDesc() {
		if (NoOfNewBornDischargeDesc == null) {
			NoOfNewBornDischargeDesc = new LabelBase();
			NoOfNewBornDischargeDesc.setText("No. of new born discharged");
			NoOfNewBornDischargeDesc.setBounds(580, 20, 170, 20);
		}
		return NoOfNewBornDischargeDesc;
	}

	public TextReadOnly getNoOfNewBornDischarge() {
		if (NoOfNewBornDischarge == null) {
			NoOfNewBornDischarge = new TextReadOnly();
			NoOfNewBornDischarge.setBounds(580, 40, 170, 20);
		}
		return NoOfNewBornDischarge;
	}

	protected void getSummary() {
		int cntcde = 0;
		int cnt000 = 0;
		int cntadm = 0;
		int cntnba = 0;
		int cntnbd = 0;

		for (int i = 0; i < getEditorListTable().getRowCount(); i++) {
			if (getEditorListTable().getValueAt(i, 9).toString().trim().length() > 0) {
				cntcde++;
			}

			if ("000".equals(getEditorListTable().getValueAt(i, 9).toString().trim())) {
				cnt000++;
			}

			String regdate = getEditorListTable().getValueAt(i, 6).toString();

			if (DateTimeUtil.dateDiff(regdate, getFromDate().getText()) >= 0 &&
					DateTimeUtil.dateDiff(regdate, getToDate().getText()) < 1) {
				cntadm++;
			}

			if (DateTimeUtil.dateDiff(regdate, getFromDate().getText()) >= 0 &&
					getEditorListTable().getValueAt(i, 5).equals(YES_VALUE) &&
					DateTimeUtil.dateDiff(getEditorListTable().getValueAt(i, 22).toString(), regdate) == 0 &&
					DateTimeUtil.dateDiff(regdate, getToDate().getText()) < 1) {
				cntnba++;
			}

			if (getEditorListTable().getValueAt(i, 5).equals(YES_VALUE) &&
					DateTimeUtil.dateDiff(getEditorListTable().getValueAt(i, 22).toString(), regdate) == 0) {
				cntnbd++;
			}
		}

		getNoOfDischarge().setText(String.valueOf(getEditorListTable().getRowCount()));
		getCodeTotal().setText(String.valueOf(cntcde));
		getOTotal().setText(String.valueOf(cnt000));
		getNoOfAdmission().setText(String.valueOf(cntadm));
		getNoOfNewBornAdmission().setText(String.valueOf(cntnba));
		getNoOfNewBornDischarge().setText(String.valueOf(cntnbd));
	}
	
	private void checkInpRmkCombo() {
		for (int i = 0; i < getEditorListTable().getRowCount(); i++) {
			String ComboValue = ((String) getEditorListTable().getStore().getAt(i).getValue(25)).trim();
			final Element inpRmkComboCell = getEditorListTable().getView().getCell(i, 25);
			
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] { "HPSTATUS", "COUNT(1)", "HPTYPE = 'MRINPRMK' AND HPKEY = '"+ComboValue+"' " },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						if ("0".equals(mQueue.getContentField()[0])) {
							inpRmkComboCell.setInnerHTML("");
						} else {
							inpRmkComboCell.setInnerHTML("");
						}
					}
				}
			});
		}	
		

	}

	private void checkRsncode() {
		//to set some cell color to red or black
		redRow.clear();

		for (int i = 0; i < getEditorListTable().getRowCount(); i++) {
			String isPaired = ((String) getEditorListTable().getStore().getAt(i).getValue(21)).trim();
			String subReason = ((String) getEditorListTable().getStore().getAt(i).getValue(11)).trim();

			if (isPaired.length() == 0 || isPaired.equals("0")) {
				continue;
			} else if (isPaired.equals("-1")) {
				if (subReason.length() == 0) {
					Element patNoCell = getEditorListTable().getView().getCell(i, 2);
					Element patNameCell = getEditorListTable().getView().getCell(i, 3);
					Element subDiseaseCell = getEditorListTable().getView().getCell(i, 9);
					Element subReasoneCell = getEditorListTable().getView().getCell(i, 11);

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
			Element subDiseaseCell = getEditorListTable().getView().getCell(redRow.get(i), 9);
			Element subReasoneCell = getEditorListTable().getView().getCell(redRow.get(i), 11);

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
				if (getEditorListTable().getActiveEditor().col == 9 || 
						getEditorListTable().getActiveEditor().col == 11 || 
						getEditorListTable().getActiveEditor().col == 13 || 
						getEditorListTable().getActiveEditor().col == 14 || 
						getEditorListTable().getActiveEditor().col == 15) {
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

	//Arran Added
	protected LayoutContainer getBodyPanel() {
		LayoutContainer panel = new LayoutContainer();
		panel.setLayout(new FlowLayout(10));
		panel.setStyleAttribute("padding-left","10px");
		panel.add(getLeftPanel());
		panel.add(getTablePanel());
		panel.add(getBtmPanel());
		return panel;
	}

	protected EditorTableList getEditorListTable() {
		int sum = 0;
		if (listTable == null) {
			for (int element : getColumnWidths()) {
		        sum = sum + element;
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

				public void setListTableContentPost() {
					getMainFrame().setLoading(false);
					if (getRowCount() <= 0) {
						Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_NO_RECORD_FOUND);
					}
					getSummary();
					checkRsncode();
					checkInpRmkCombo();
					enableButton();
					//getEditorListTable().disableTextSelection(true);//getEditorListTable().disableEvents(true);
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
			//listTable.disableEvents(true);

			listTable.addListener(Events.AfterEdit, new Listener<GridEvent>() {
				@Override
				public void handleEvent(GridEvent be) {
					// TODO Auto-generated method stub
					resetColumnColor();
				}
			});
		}
		return listTable;
	}

	private BasePanel getTablePanel() {
		BasePanel tablePanel = new BasePanel();
		tablePanel.setWidth(769);
		tablePanel.setBorders(true);
		tablePanel.setScrollMode(Scroll.AUTO);
		tablePanel.add(getEditorListTable());
		tablePanel.setHeight(220);
		return tablePanel;
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