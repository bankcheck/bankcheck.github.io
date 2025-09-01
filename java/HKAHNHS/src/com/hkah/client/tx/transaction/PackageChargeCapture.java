package com.hkah.client.tx.transaction;

import java.util.LinkedList;

import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.FieldEvent;
import com.extjs.gxt.ui.client.event.GridEvent;
import com.extjs.gxt.ui.client.event.KeyListener;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.form.DateField;
import com.extjs.gxt.ui.client.widget.form.Field;
import com.google.gwt.event.dom.client.KeyCodes;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboACMCode;
import com.hkah.client.layout.combobox.ComboPkgJoined;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.EditorTableList;
import com.hkah.client.layout.textfield.SearchTriggerField;
import com.hkah.client.layout.textfield.TextAmount;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextDoctorSearch;
import com.hkah.client.layout.textfield.TextItemCodeSearch;
import com.hkah.client.layout.textfield.TextPackageCodeSearch;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.ActionPanel;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTransaction;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class PackageChargeCapture extends ActionPanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.PKGCAPTURE_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.PKGCAPTURE_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Pkg Code",			// 00
				"Item Code",		// 01
				"Amount",			// 02
				"Doctor Code",		// 03
				"Transaction Date",	// 04
				"Description",		// 05
				"Acm",				// 06
				"CPS",				// 07
			    "I-Ref",			// 08
				"itmrlvl",			// 09
			    "cpsid",			// 10
				"PTNOAMT",			// 11
				"ISPKG"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				60,					// 00
				60,					// 01
				60,					// 02
				80,					// 03
				100,				// 04
				180,				// 05
				40,					// 06
				40,					// 07
				100,				// 08
				0,					// 09
				0,					// 10
				0,					// 11
				0
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel actionPanel = null;
	private BasePanel paraPanel1 = null;
	private LabelBase slipNoDesc = null;
	private TextReadOnly slipNo = null;
	private LabelBase patientDesc = null;
	private TextReadOnly patNo;
	private TextReadOnly patName;
	private LabelBase bedCodeDesc = null;
	private TextReadOnly bedCode = null;
	private LabelBase admissionDateDesc = null;
	private TextReadOnly admissionDate = null;
	private LabelBase doctorDesc = null;
	private TextReadOnly docCode = null;
	private TextReadOnly docName = null;
	private LabelBase acmCodeDesc1 = null;
	private TextReadOnly acmCode1 = null;

	private BasePanel paraPanel2 = null;
	private LabelBase standardRateDesc = null;
	private CheckBoxBase standardRate = null;
	private LabelBase acmCodeDesc2 = null;
	private ComboACMCode acmCode2 = null;
	private LabelBase itmpkgCodeDesc = null;
	private TextItemCodeSearch itmpkgCode = null;
	private LabelBase transactionDateDesc = null;
	private TextDate transactionDate = null;
	private LabelBase packageJoinedDesc = null;
	private ComboPkgJoined packageJoined = null;
	private LabelBase pkgCodeDesc = null;
	private TextPackageCodeSearch pkgCode = null;
	private int lastListCount = 0;
	private LinkedList<Integer> editGridColIdx = null;

	private String memSlipType = null;

//	private JScrollPane JScrollPane = null;
	private BasePanel ListPanel = null;
	private boolean validating = false;
	private boolean saving = false;
	private int prevSelectedRow = -1;

	// ======== change to editable grid. ==========
	private JScrollPane editGridScrollPane = null;
	private EditorTableList editGridList = null;

	/**
	 * This method initializes
	 *
	 */
	public PackageChargeCapture() {
		super();
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		if (getParameter("SlpNo") != null) {
			getSlipNo().setText(getParameter("SlpNo"));
			getPatNo().setText(getParameter("PatNo"));
			getPatName().setText(getParameter("PatName"));
			getBedCode().setText(getParameter("BedCode"));
			getAdmissionDate().setText(getParameter("RegDate"));
			getDocCode().setText(getParameter("DocCode"));
			getDocName().setText(getParameter("DocName"));
			getAcmCode1().setText(getParameter("AcmCode"));
			getStandardRate().setSelected(true);
			getTransactionDate().setText(getMainFrame().getServerDate());
		}

		memSlipType = getParameter("SlpType");
		if (ConstantsTransaction.SLIP_TYPE_INPATIENT.equals(memSlipType)) {
			if (!getAcmCode1().isEmpty()) {
				getAcmCode2().setText(getAcmCode1().getText());
			}
			getAcmCode2().setEnabled(true);
//			getPackageJoined().setEnabled(true);
		} else {
			getAcmCode2().setEnabled(false);
//			getPackageJoined().setEnabled(false);
		}

		// reset parameter from previous screen
//		resetParameter("SlpNo");
//		resetParameter("PatNo");
//		resetParameter("PatName");
//		resetParameter("BedCode");
//		resetParameter("AdmDate");
//		resetParameter("DocCode");
//		resetParameter("DocName");
//		resetParameter("AcmCode");
//		resetParameter("SlpType");

		// inital comobobox
		getPackageJoined().initContent(getSlipNo().getText());

		enableButton();
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public Component getDefaultFocusComponent() {
		return getPkgCode(); //getItmpkgCode();
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

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return new String[] {};
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	public void deleteAction() {
		if (getDeleteButton().isEnabled()) {
			if (getEditGridList().getSelectedRow() < 0) {
				Factory.getInstance().addErrorMessage("Please select a row.");
				return;
			}
			getEditGridList().removeRow(getEditGridList().getSelectedRow());

			getItmpkgCode().resetText();
			getItmpkgCode().focus();
			enableButton();
		}
	}

	@Override
	public void appendAction() {
		if (getAppendButton().isEnabled()) {
			setActionType(QueryUtil.ACTION_APPEND);
			if  (!getPkgCode().isEmpty()) {
				QueryUtil.executeMasterBrowse(getUserInfo(), getTxCode(),
						new String[] {
							getSlipNo().getText(),
							getPkgCode().getText().trim(),
							getItmpkgCode().getText().trim(),
							getTransactionDate().getText().trim(),
							getStandardRate().getValue()?"Y":"N",
							getUserInfo().getUserID(),
						},
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							int errorCode = 0;
							try {
								errorCode = Integer.parseInt(mQueue.getContentField()[0]);
							} catch (Exception e) {
							}

							if (errorCode < 0) {
								if (errorCode == -100) {
									Factory.getInstance().addErrorMessage(mQueue.getContentField()[1], getItmpkgCode());
									getItmpkgCode().resetText();
								} else {
									Factory.getInstance().addErrorMessage(mQueue.getContentField()[1], getPkgCode());
									getPkgCode().resetText();
								}
							} else {
								lastListCount = getEditGridList().getRowCount();
								getEditGridList().setListTableContent(mQueue, false);
								getItmpkgCode().resetText();
								getItmpkgCode().focus();
								enableButton();
							}
						} else {
							Factory.getInstance().addErrorMessage(mQueue);
						}
					}
				});
			} else {
				Factory.getInstance().addErrorMessage(MSG_PKG_CODE, getPkgCode());
			}
		}
		enableButton();
	}

	@Override
	public void saveAction() {
		if (getSaveButton().isEnabled()) {
			if (!validating) {
				//save table
				getEditGridList().saveTable(
						getTxCode(),
						new String[] {
								getSlipNo().getText(),
								memSlipType,
								getBedCode().getText(),
								Factory.getInstance().getUserInfo().getUserID()
						},
						"ADDCHARGES_INFO",
						true,
						false,
						false,
						true,
						false,
						getTitle());
			} else {
				saving = true;
			}
		}
	}

	@Override
	public void cancelAction() {
		super.cancelAction();
	}

	@Override
	protected void cancelYesAction() {
		setActionType(null);
		if (getEditGridList().getRowCount() > 0) {
			getEditGridList().removeAllRow();
		}

		enableButton();
		getItmpkgCode().resetText();
		getItmpkgCode().focus();
	}

	@Override
	protected void enableButton(String mode) {
		// disable all button
		disableButton();
		getAppendButton().setEnabled(true);
		if (getEditGridList() != null && getEditGridList().getRowCount() > 0) {
			getSaveButton().setEnabled(true);
			getDeleteButton().setEnabled(true);
			getCancelButton().setEnabled(true);
		} else {
			setActionType(null);
			getSaveButton().setEnabled(false);
			getDeleteButton().setEnabled(false);
			getCancelButton().setEnabled(false);
		}
	}

	/***************************************************************************
	 * EditorTable Methods
	 **************************************************************************/

	private JScrollPane getEditGridScrollPane() {
		if (editGridScrollPane == null) {
			editGridScrollPane = new JScrollPane();
			editGridScrollPane.setViewportView(getEditGridList());
			editGridScrollPane.setBounds(1, 1, 753, 296);
		}
		return editGridScrollPane;
	}

	private EditorTableList getEditGridList() {
		if (editGridList == null) {
			editGridList = new EditorTableList(getColumnNames(),
												getColumnWidths(),
												editGridListEditor()) {
				@Override
				public void postSaveTable(boolean success, Integer rtnCode, String rtnMsg) {
					setActionType(null);
					getEditGridList().removeAllRow();

					enableButton();
					getItmpkgCode().resetText();
					getPkgCode().focus();
				}
				
				@Override
				protected void columnKeyDownHandler(FieldEvent be, int editingCol) {
					if (be.getSource() instanceof DateField) {
						if (be.getKeyCode() == 8 || be.getKeyCode() == 46) {
							return;
						}
					}
					
					handleArrowKey(be.getKeyCode(), editingCol);
					tableFieldHelper(be, editingCol);
				}
			};

			editGridList.addListener(Events.RowClick,
					new Listener<GridEvent>() {
				@Override
				public void handleEvent(GridEvent be) {
					if (prevSelectedRow == -1) {
						prevSelectedRow = getEditGridList().getSelectedRow();
					} else {
						if (validating) {
							getEditGridList().setSelectRow(prevSelectedRow);
						} else {
							prevSelectedRow = getEditGridList().getSelectedRow();
						}
					}
				}
			});
		}
		return editGridList;
	}

	private Field<? extends Object>[] editGridListEditor() {
		Field<? extends Object>[] editors = new Field<?>[13];

		TextAmount amt = new TextAmount(10, false) {
/*
			@Override
			protected void onKeyDown(FieldEvent fe) {
				super.onKeyDown(fe);
				handleArrowKey(fe.getKeyCode(), 2);
				tableFieldHelper(fe, 2);
			}
*/
			@Override
			protected void beforeBlur() {
				validating = true;
				String amount = getText();

				if (amount.length() <= 0) {
					getEditGridList().setValueAt(ConstantsVariable.EMPTY_VALUE,
							getEditGridList().getSelectedRow(), 2);

					Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_POSITIVE_AMOUNT,
							new Listener<MessageBoxEvent>() {
						@Override
						public void handleEvent(MessageBoxEvent be) {
							// TODO Auto-generated method stub
							getEditGridList().setSelectRow(prevSelectedRow);
							getEditGridList().startEditing(prevSelectedRow, 2);
						}
					});
					validating = false;
					return;
				}

				try {
					int value = Integer.parseInt(amount);

					if (value < 0) {
						getEditGridList().setValueAt(ConstantsVariable.EMPTY_VALUE,
								getEditGridList().getSelectedRow(), 2);

						Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_POSITIVE_AMOUNT,
								new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								// TODO Auto-generated method stub
								getEditGridList().setSelectRow(prevSelectedRow);
								getEditGridList().startEditing(prevSelectedRow, 2);
							}
						});
						validating = false;
						return;
					}
					validating = false;
				} catch (Exception e) {
					getEditGridList().setValueAt(ConstantsVariable.EMPTY_VALUE,
							getEditGridList().getSelectedRow(), 2);

					Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_POSITIVE_AMOUNT,
							new Listener<MessageBoxEvent>() {
						@Override
						public void handleEvent(MessageBoxEvent be) {
							// TODO Auto-generated method stub
							getEditGridList().setSelectRow(prevSelectedRow);
							getEditGridList().startEditing(prevSelectedRow, 2);
						}
					});
					validating = false;
					return;
				}
			}
		 };

		TextDoctorSearch docCode = new TextDoctorSearch() {
			/*
			@Override
			protected void onKeyDown(FieldEvent fe) {
				super.onKeyDown(fe);
				handleArrowKey(fe.getKeyCode(), 3);
				tableFieldHelper(fe, 3);
			}
			*/
			@Override
			protected void beforeBlur() {
				String docCode = getValue();

				validating = true;
				if (docCode != null && docCode.length() > 0) {
					QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.DOCTOR_ACTIVE_TXCODE,
							new String[] { docCode },
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(
								MessageQueue mQueue) {
							// TODO Auto-generated method stub
							if (mQueue.success()) {
								validating = false;
							} else {
								Factory.getInstance().addErrorMessage("Invalid Doctor Code.",
										new Listener<MessageBoxEvent>() {
									@Override
									public void handleEvent(
											MessageBoxEvent be) {
										// TODO Auto-generated method stub
										getEditGridList().setSelectRow(prevSelectedRow);
										getEditGridList().startEditing(prevSelectedRow, 3);
										validating = false;
									}
								});
							}
						}
					});
				} else {
					validating = false;
				}
			}
		};

		TextDate dateField = new TextDate() {
			/*
			@Override
			protected void onKeyDown(FieldEvent fe) {
				super.onKeyDown(fe);
				handleArrowKey(fe.getKeyCode(), 4);
				tableFieldHelper(fe, 4);
			}
			*/
			
			@Override
			protected void beforeBlur() {
				validating = true;
				if (!isEmpty() && !isValid()) {
					Factory.getInstance().addErrorMessage("Invalid date.",
							new Listener<MessageBoxEvent>() {
						@Override
						public void handleEvent(MessageBoxEvent be) {
							getEditGridList().setSelectRow(prevSelectedRow);
							getEditGridList().startEditing(prevSelectedRow, 4);
						}
					});
				}
				validating = false;
			}
		};

		editors[0] = null;
		editors[1] = null;
		editors[2] = amt;
		editors[3] = docCode;
		editors[4] = dateField;
		editors[5] = null;
		editors[6] = null;
		editors[7] = new TextString(4) {
			/*
			@Override
			protected void onKeyDown(FieldEvent fe) {
				super.onKeyDown(fe);
				handleArrowKey(fe.getKeyCode(), 7);
				tableFieldHelper(fe, 7);
			}
			*/
		};
		editors[8] = new TextString(90) {
			/*
			@Override
			protected void onKeyDown(FieldEvent fe) {
				super.onKeyDown(fe);
				handleArrowKey(fe.getKeyCode(), 8);
				tableFieldHelper(fe, 8);
			}
			*/
		};
		editors[9] = null;
		editors[10] = null;
		editors[11] = null;
		editors[12] = null;

		return editors;
	}
	
	private LinkedList<Integer> getEditGridColIdx() {
		if (editGridColIdx == null) {
		    editGridColIdx = new LinkedList<Integer>();
		    Field<? extends Object>[] list = editGridListEditor();
		    for (int i = 0; i < list.length; i++) {
		    	if (list[i] != null) {
		    		editGridColIdx.add(i);
		    	}
		    }
		}
	    return editGridColIdx;
	}
	
	private void tableFieldHelper(FieldEvent be, int editingCol) {
		if (be.getKeyCode() == 112) { //F1
			if (be.getSource() instanceof SearchTriggerField) {
				((SearchTriggerField)be.getSource()).showSearchPanel();
			}
		}
		else if (be.getKeyCode() == 113) {	// F2
			if (getAppendButton().isEnabled()) {
				getEditGridList().stopEditing(false);
				appendAction();
			}
		} else if (be.getKeyCode() == 116) {	// F5
			if (getDeleteButton().isEnabled()) {
				be.preventDefault();
				getEditGridList().stopEditing(true);
				deleteAction();
			}
		} else if (be.getKeyCode() == 117) { //F6
			if (getSaveButton().isEnabled()) {
				be.preventDefault();
				getEditGridList().stopEditing(false);
				saveAction();
			}
		} else if (be.getKeyCode() == 119) { //F8
			if (getCancelButton().isEnabled()) {
				be.preventDefault();
				getEditGridList().stopEditing(true);
				cancelAction();
			}
		} else if (be.getKeyCode() == KeyCodes.KEY_TAB) {
			int idx = getEditGridColIdx().indexOf(editingCol) + (be.isShiftKey() ? -1 : 1);
			
			if (idx < 0) {
				be.preventDefault();
				getEditGridList().stopEditing(false);
				getItmpkgCode().requestFocus();
			} else if (idx >= getEditGridColIdx().size()) {
				be.preventDefault();
				getEditGridList().stopEditing(false);
				getPkgCode().requestFocus();
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
		int editRow = getEditGridList().getActiveEditor().row;
		int nextRow = up ? editRow - 1 : editRow + 1;
		
		if (nextRow >= 0 && nextRow < getEditGridList().getRowCount()) {
			getEditGridList().stopEditing();
			getEditGridList().setSelectRow(nextRow);
			getEditGridList().startEditing(nextRow, editColumn);
		}
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/* >>> getter methods for init the Component start from here================================== <<< */
	@Override
	protected BasePanel getActionPanel() {
		if (actionPanel == null) {
			actionPanel = new BasePanel();
			actionPanel.setSize(779, 528);
			actionPanel.add(getListPanel(), null);
			actionPanel.add(getParaPanel1(), null);
			actionPanel.add(getParaPanel2(), null);
		}
		return actionPanel;
	}

	public BasePanel getParaPanel1() {
		if (paraPanel1 == null) {
			paraPanel1 = new BasePanel();
			paraPanel1.setBounds(5, 5, 757, 60);
			paraPanel1.setBorders(true);
			paraPanel1.add(getSlipNoDesc(), null);
			paraPanel1.add(getSlipNo(), null);
			paraPanel1.add(getPatientDesc(), null);
			paraPanel1.add(getPatNo(), null);
			paraPanel1.add(getPatName(), null);
			paraPanel1.add(getBedCodeDesc(), null);
			paraPanel1.add(getBedCode(), null);
			paraPanel1.add(getAdmissionDateDesc(), null);
			paraPanel1.add(getAdmissionDate(), null);
			paraPanel1.add(getDoctorDesc(), null);
			paraPanel1.add(getDocCode(), null);
			paraPanel1.add(getDocName(), null);
			paraPanel1.add(getAcmCodeDesc1(), null);
			paraPanel1.add(getAcmCode1(), null);
		}
		return paraPanel1;
	}

	public BasePanel getParaPanel2() {
		if (paraPanel2 == null) {
			paraPanel2 = new BasePanel();
			paraPanel2.setBounds(5, 75, 757, 60);
			paraPanel2.setBorders(true);
			paraPanel2.add(getStandardRateDesc(), null);
			paraPanel2.add(getStandardRate(), null);
			paraPanel2.add(getAcmCodeDesc2(), null);
			paraPanel2.add(getAcmCode2(), null);
			paraPanel2.add(getItmpkgCodeDesc(), null);
			paraPanel2.add(getItmpkgCode(), null);
			paraPanel2.add(getTransactionDateDesc(), null);
			paraPanel2.add(getTransactionDate(), null);
			paraPanel2.add(getPackageJoinedDesc(), null);
			paraPanel2.add(getPackageJoined(), null);
			paraPanel2.add(getPkgCodeDesc(), null);
			paraPanel2.add(getPkgCode(), null);
		}
		return paraPanel2;
	}

	public BasePanel getListPanel() {
		if (ListPanel == null) {
			ListPanel = new BasePanel();
			ListPanel.setEtchedBorder();
			ListPanel.setBounds(5, 150, 757, 300);
			ListPanel.add(getEditGridScrollPane());
		}
		return ListPanel;
	}

	public LabelBase getSlipNoDesc() {
		if (slipNoDesc == null) {
			slipNoDesc = new LabelBase();
			slipNoDesc.setText("Slip Number");
			slipNoDesc.setBounds(5, 5, 80, 20);
		}
		return slipNoDesc;
	}

	public TextReadOnly getSlipNo() {
		if (slipNo == null) {
			slipNo = new TextReadOnly();
			slipNo.setBounds(100, 5, 125, 20);
		}
		return slipNo;
	}

	public LabelBase getPatientDesc() {
		if (patientDesc == null) {
			patientDesc = new LabelBase();
			patientDesc.setText("Patient");
			patientDesc.setBounds(237, 5, 60, 20);
		}
		return patientDesc;
	}

	public TextReadOnly getPatNo() {
		if (patNo == null) {
			patNo = new TextReadOnly();
			patNo.setBounds(301, 5, 69, 20);
		}
		return patNo;
	}

	public TextReadOnly getPatName() {
		if (patName == null) {
			patName = new TextReadOnly();
			patName.setBounds(374, 5, 190, 20);
		}
		return patName;
	}

	public LabelBase getBedCodeDesc() {
		if (bedCodeDesc == null) {
			bedCodeDesc = new LabelBase();
			bedCodeDesc.setText("Bed Code");
			bedCodeDesc.setBounds(575, 5, 78, 20);
		}
		return bedCodeDesc;
	}

	public TextReadOnly getBedCode() {
		if (bedCode == null) {
			bedCode = new TextReadOnly();
			bedCode.setBounds(650, 5, 99, 20);
		}
		return bedCode;
	}

	public LabelBase getAdmissionDateDesc() {
		if (admissionDateDesc == null) {
			admissionDateDesc = new LabelBase();
			admissionDateDesc.setText("Admission Date");
			admissionDateDesc.setBounds(5, 30, 90, 20);
		}
		return admissionDateDesc;
	}

	public TextReadOnly getAdmissionDate() {
		if (admissionDate == null) {
			admissionDate = new TextReadOnly();
			admissionDate.setBounds(100, 30, 125, 20);
		}
		return admissionDate;
	}

	public LabelBase getDoctorDesc() {
		if (doctorDesc == null) {
			doctorDesc = new LabelBase();
			doctorDesc.setText("Doctor");
			doctorDesc.setBounds(237, 30, 60, 20);
		}
		return doctorDesc;
	}

	public TextReadOnly getDocCode() {
		if (docCode == null) {
			docCode = new TextReadOnly();
			docCode.setBounds(301, 30, 69, 20);
		}
		return docCode;
	}

	public TextReadOnly getDocName() {
		if (docName == null) {
			docName = new TextReadOnly();
			docName.setBounds(374, 30, 190, 20);
		}
		return docName;
	}

	public LabelBase getAcmCodeDesc1() {
		if (acmCodeDesc1 == null) {
			acmCodeDesc1 = new LabelBase();
			acmCodeDesc1.setText("Acm Code");
			acmCodeDesc1.setBounds(575, 30, 78, 20);
		}
		return acmCodeDesc1;
	}

	public TextReadOnly getAcmCode1() {
		if (acmCode1 == null) {
			acmCode1 = new TextReadOnly();
			acmCode1.setBounds(650, 30, 99, 20);
		}
		return acmCode1;
	}

	public LabelBase getStandardRateDesc() {
		if (standardRateDesc == null) {
			standardRateDesc = new LabelBase();
			standardRateDesc.setText("Standard Rate");
			standardRateDesc.setBounds(5, 5, 90, 20);
		}
		return standardRateDesc;
	}

	public CheckBoxBase getStandardRate() {
		if (standardRate == null) {
			standardRate = new CheckBoxBase();
			standardRate.setBounds(60, 5, 120, 20);
		}
		return standardRate;
	}

	public LabelBase getAcmCodeDesc2() {
		if (acmCodeDesc2 == null) {
			acmCodeDesc2 = new LabelBase();
			acmCodeDesc2.setText("Acm Code");
			acmCodeDesc2.setBounds(225, 5, 100, 20);
		}
		return acmCodeDesc2;
	}

	public ComboACMCode getAcmCode2() {
		if (acmCode2 == null) {
			acmCode2 = new ComboACMCode();
			acmCode2.setBounds(300, 5, 150, 20);
		}
		return acmCode2;
	}

	public LabelBase getItmpkgCodeDesc() {
		if (itmpkgCodeDesc == null) {
			itmpkgCodeDesc = new LabelBase();
			itmpkgCodeDesc.setText("Item/Pkg Code");
			itmpkgCodeDesc.setBounds(465, 5, 120, 20);
		}
		return itmpkgCodeDesc;
	}

	public TextItemCodeSearch getItmpkgCode() {
		if (itmpkgCode == null) {
			setParameter("itemCategoryExcl", ConstantsTransaction.ITEM_CATEGORY_CREDIT);
			itmpkgCode = new TextItemCodeSearch();

			itmpkgCode.addKeyListener(new KeyListener() {
				public void componentKeyDown(ComponentEvent event) {
					if (event.getKeyCode() == KeyCodes.KEY_TAB) {
						if (getEditGridList().getRowCount() > 0) {
							int selRow = lastListCount > 0 && lastListCount < getEditGridList().getRowCount() ? lastListCount : 0;
							getEditGridList().setSelectRow(selRow);
							getEditGridList().startEditing(selRow, 2);
						}
					}
				}
			});

			itmpkgCode.setBounds(570, 5, 150, 20);
		}
		return itmpkgCode;
	}

	public LabelBase getTransactionDateDesc() {
		if (transactionDateDesc == null) {
			transactionDateDesc = new LabelBase();
			transactionDateDesc.setText("Transaction Date");
			transactionDateDesc.setBounds(5, 30, 100, 20);
		}
		return transactionDateDesc;
	}

	public TextDate getTransactionDate() {
		if (transactionDate == null) {
			transactionDate = new TextDate();
			transactionDate.setBounds(110, 30, 100, 20);
		}
		return transactionDate;
	}

	public LabelBase getPackageJoinedDesc() {
		if (packageJoinedDesc == null) {
			packageJoinedDesc = new LabelBase();
			packageJoinedDesc.setText("Pkg Joined");
			packageJoinedDesc.setBounds(225, 30, 100, 20);
		}
		return packageJoinedDesc;
	}

	public ComboPkgJoined getPackageJoined() {
		if (packageJoined == null) {
			packageJoined = new ComboPkgJoined();
			packageJoined.setBounds(300, 30, 150, 20);
		}
		return packageJoined;
	}

	public LabelBase getPkgCodeDesc() {
		if (pkgCodeDesc == null) {
			pkgCodeDesc = new LabelBase();
			pkgCodeDesc.setText("Pkg Code");
			pkgCodeDesc.setBounds(465, 30, 80, 20);
		}
		return pkgCodeDesc;
	}

	public TextPackageCodeSearch getPkgCode() {
		if (pkgCode == null) {
			pkgCode = new TextPackageCodeSearch();
			pkgCode.setBounds(570, 30, 150, 20);
		}
		return pkgCode;
	}
}