//menu name : Report Queue
package com.hkah.client.tx.di;

import java.util.Date;

import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.event.EditorEvent;
import com.extjs.gxt.ui.client.event.FieldEvent;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.form.Field;
import com.google.gwt.user.datepicker.client.CalendarUtil;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboDoctor;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.EditorTableList;
import com.hkah.client.layout.textfield.TextDateWithCheckBox;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DIECGQueueReport extends MasterPanel {

	public DIECGQueueReport(BasePanel panelFrom) {
		super();
		// this.panelFrom = panelFrom;
	}

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.ECGREPORT_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.ECGREPORT_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] { 
				"DI No.", "Doctor", " ", "Patient No", "Name",
				//
				"Report Date", "Exam", "Update by", "Send Date", "",
				//
				"", "", "", "", "",
				//
				""
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] { 100, 150, 20, 100, 150,
				//
				150, 150, 80, 150, 80,
				//
				0, 0, 0, 0, 0,
				//
				0 
		};
	}

	private BasePanel rightPanel = null;
	private BasePanel leftPanel = null;

	private BasePanel ParaPanel = null;
	private LabelBase ECGReportDesc = null;
	private CheckBoxBase ECGReported = null;
	private LabelBase ECGReportFromDesc = null;
	private TextDateWithCheckBox ECGReportFrom = null;
	private LabelBase ECGReportToDesc = null;
	private TextDateWithCheckBox ECGReportTo = null;

	private ButtonBase ReturnRow = null;
	private LabelBase CountDesc = null;
	private TextReadOnly Count = null;
	private String msg = null;

	private EditorTableList UpperTable = null;
	private JScrollPane UpperJScrollPane = null;
	private ComboDoctor comboDoctor = null;

	private JScrollPane getUpperJScrollPane() {
		if (UpperJScrollPane == null) {
			UpperJScrollPane = new JScrollPane();
			UpperJScrollPane.setViewportView(getUpperTable());
			UpperJScrollPane.setBounds(5, 60, 900, 430);
		}
		return UpperJScrollPane;
	}

	private EditorTableList getUpperTable() {
		if (UpperTable == null) {
			UpperTable = new EditorTableList(getColumnNames(), getColumnWidths(), getSecProcTableEditors()) {
				
				// for stop edit by typing tab or click away
				@Override
				protected void columnBlurHandler(FieldEvent be, int editingCol) {
					if (editingCol == 0 && getUpperTable().isEditing()) {
						int r = getUpperTable().getActiveEditor().row;
						getUpperTable().stopEditing();
						getUpperTable().setValueAt(((ComboDoctor) be.getSource()).getDisplayTextWithoutKey(), r, 1);
					}
				}
				
				// for click trigger and select only
				@Override
				protected void columnCancelEditHandler(EditorEvent be, int editingCol) {
					if (editingCol == 0) {
						int r = getUpperTable().getActiveEditor().row;

						getUpperTable().stopEditing();

						int editingRow = getUpperTable().getSelectedRow();
						String rv = getUpperTable().getValueAt(editingRow, editingCol);

						getUpperTable().setValueAt(rv, r, 0);
					}
				}
				
				public void doubleClick() {

				}
			};
		}
		return UpperTable;
	}
	
	private Field<? extends Object>[] getSecProcTableEditors() {
		return new Field[] {
				null, getComboDoctor(), null, null, null, 
				null, null, null, null, null,
				null, null, null, null, null,
				null, null
		};
	}
	
	private ComboDoctor getComboDoctor() {
		if (comboDoctor == null) {
			comboDoctor = new ComboDoctor("ECGRPTQUEUE") {
			//comboDoctor = new ComboDoctor() {	
				@Override
				protected void setTextPanel(ModelData modelData) {
					super.setTextPanel(modelData);
					
					if (modelData != null) {
						getUpperTable().setValueAt(modelData.get(ZERO_VALUE).toString(),
													getUpperTable().getSelectedRow(), 1);
					}
				}
				
				@Override
				protected void onSelected() {
					// override by child class when selected
					getSearchButton().setEnabled(false);
					getSaveButton().setEnabled(true);
					getCancelButton().setEnabled(true);
					getECGReportFrom().setEnabled(false);
					getECGReportTo().setEnabled(false);
					getECGReported().setEnabled(false);
				}
			};
		}
		return comboDoctor;
	}

	protected void preExitPanel() {
		// for child class call before exit
		getUpperTable().removeAllRow();	
	}
	
	/**
	 * This method initializes test
	 * 
	 */
	public DIECGQueueReport() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		setLeftAlignPanel();
		// getJScrollPane().setBounds(5, 60, 900, 430);
		getJScrollPane().setBounds(5, 60, 1, 1);
		getListTable().setVisible(false);
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		// getPatNo().setText(getParameter("PatNo"));
		// getECGReportFrom().setText(getMainFrame().getServerDate());
		Date fromDate = DateTimeUtil.parseDateTime(getMainFrame().getServerDateTime());
		CalendarUtil.addMonthsToDate(fromDate, -1);
		getECGReportFrom().setText(DateTimeUtil.formatDate(fromDate));
		getECGReportTo().setText(getMainFrame().getServerDate());

		getCount().setText(ZERO_VALUE);
		// searchAction();
	}

	@Override
	protected void cancelPostAction() {
		// for override if necessary
		super.cancelPostAction();
		searchAction();
		getCount().setText(ZERO_VALUE);
		getECGReportFrom().setEnabled(true);
		getECGReportTo().setEnabled(true);
		getECGReported().setEnabled(true);
	}

	@Override
	public void saveAction() {
		String newDocCode = null;
		String oldDocCode = null;
		String xrgid = null;
		String updateRecord = "";
		// for override if necessary
		if (getUpperTable().getRowCount() > 0) {
			System.out.println("getRowCount : " + getUpperTable().getRowCount());
			for (int i = 0; i < getUpperTable().getRowCount(); i++) {
				getUpperTable().setSelectRow(i);
				String[] records = getUpperTable().getSelectedRowContent();
				
				//newDocCode = getComboDoctor().getDisplayText();
				//newDocCode = getUpperTable().getValueAt(i, 1);
				newDocCode = records[1];
				oldDocCode = records[15];
				xrgid = records[9];
				
				
				System.out.print("newDocCode : " + newDocCode);
				System.out.print("||oldDocCode : " + oldDocCode);
				System.out.print("||xrgid : " + xrgid);
				System.out.println("---" + i);
				
				
				if("".equals(oldDocCode)) {
					if(!"".equals(newDocCode) && newDocCode.length() > 0) {
						setActionType(QueryUtil.ACTION_APPEND);
						if(updateRecord.length() > 0 ) {
							updateRecord += ";";
						}
						updateRecord += xrgid + "," + newDocCode ;
						System.out.println("[DEBUG]insertRecord: " +i+">>>"+ updateRecord);
					}
				}else if (!newDocCode.equals(oldDocCode)) {
					setActionType(QueryUtil.ACTION_MODIFY);
					if(updateRecord.length() > 0 ) {
						updateRecord += ";";
					}
					updateRecord += xrgid + "," + newDocCode ;
					System.out.println("[DEBUG]updateRecord: " +i+">>>"+ updateRecord);
				}
				
			}
			
			System.out.println("ActionType : " + getActionType());
			System.out.println("[DEBUG]Records: " + updateRecord);
			QueryUtil.executeMasterAction(getUserInfo(), ConstantsTx.ECGREPORT_TXCODE, getActionType(), 
				new String[] {
						updateRecord,
						getUserInfo().getUserID()
					},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						savePostAction();
					} 
				}
				public void onComplete() {
					super.onComplete();
				}
			});
			
		}

	}
	
	@Override
	protected void savePostAction() {
		// for override if necessary
		super.savePostAction();
		Factory.getInstance().addSystemMessage("Save Completed.");
		searchAction();
		getCount().setText("0");
		getECGReportFrom().setEnabled(true);
		getECGReportTo().setEnabled(true);
		getECGReported().setEnabled(true);
	}


	@Override
	protected void enableButton(String mode) {
		// disable all button
		disableButton();
		getSearchButton().setEnabled(true);
		getECGReportFrom().setEnabled(true);
		getECGReportTo().setEnabled(true);
		getECGReported().setEnabled(true);

		getCount().setText(Integer.toString(getUpperTable().getRowCount()));
	}

	@Override
	protected void performListPost() {
		// for child class call
		getUpperTable().setListTableContent(getListTable().getStore().getModels());
		getCount().setText(Integer.toString(getUpperTable().getRowCount()));
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public Component getDefaultFocusComponent() {
		return getECGReportFrom().getDateField();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {
		getSearchButton().setEnabled(true);
		getSaveButton().setEnabled(false);
		getCancelButton().setEnabled(false);
		getUpperTable().removeAllRow();
	}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {
	}

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
		return true;
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		//String removed = null;

		// removed = getECGQueueRemove().getValue();

		String[] inParm = new String[] { 
				(getECGReported().getValue() ? "1" : "0"),
				getECGReportFrom().getText(),
				getECGReportTo().getText()
				 };

		return inParm;
	}

	/* >>> ~16~ Set Fetch Input Parameters ================================ <<< */
	@Override
	protected String[] getFetchInputParameters() {
		String[] selectedContent = getListSelectedRow();
		return new String[] { selectedContent[0] };
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
		return new String[] {				
		};
	}

	/* >>> ~16.1~ Set Action Output Parameters =========================== <<< */
	@Override
	protected void getNewOutputValue(String returnValue) {
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	private ButtonBase getReturnRow() {
		
		if (ReturnRow == null) {
			ReturnRow = new ButtonBase() {
				@Override
				public void onClick() {
					if (getECGReported().getValue()) {
						msg = "Paid doctor fee would be reverse and the selected exam become non-report. "
								+ "Do you want to continue?";
					} else {
						msg = "Return the non-reported exam to E.C.G. "
								+ "Do you want to continue?";
					}
					if (getUpperTable().getRowCount() > 0) {
						Factory.getInstance().isConfirmYesNoDialog(msg,
								new Listener<MessageBoxEvent>() {
									@Override
									public void handleEvent(MessageBoxEvent be) {
										if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
											String xrgid = getUpperTable().getSelectedRowContent()[9];											
											System.out.println("[getReturnRow] XRGID = " + xrgid);
											QueryUtil.executeMasterAction(getUserInfo(), "ECGRPTQCLICK", QueryUtil.ACTION_MODIFY, 
												new String[] { 
													xrgid, "", getUserInfo().getUserID()
												});
											searchPostAction();
											enableButton("");
										}
									}
								});
					}
				}
			};
			ReturnRow.setText("Return to E.G.C Queue", 'R');
			ReturnRow.setBounds(10, 500, 135, 25);
		}
		return ReturnRow;
	}

	@Override
	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.add(getParaPanel());
			leftPanel.add(getJScrollPane());
			leftPanel.add(getUpperJScrollPane());
			leftPanel.add(getReturnRow());
			leftPanel.add(getCountDesc());
			leftPanel.add(getCount());
		}
		return leftPanel;
	}

	protected BasePanel getRightPanel() {

		if (rightPanel == null) {
			rightPanel = new BasePanel();
		}
		return rightPanel;
	}

	public BasePanel getParaPanel() {
		if (ParaPanel == null) {
			ParaPanel = new BasePanel();
			ParaPanel.setBounds(10, 10, 771, 40);
			ParaPanel.setBorders(true);
			ParaPanel.add(getECGReportDesc(), null);
			ParaPanel.add(getECGReported(), null);
			ParaPanel.add(getECGReportFromDesc(), null);
			ParaPanel.add(getECGReportFrom(), null);
			ParaPanel.add(getECGReportToDesc(), null);
			ParaPanel.add(getECGReportTo(), null);
			ParaPanel.setHeading("Criteria");
			ParaPanel.setTitle("Criteria");

		}
		return ParaPanel;
	}

	private LabelBase getECGReportDesc() {
		if (ECGReportDesc == null) {
			ECGReportDesc = new LabelBase();
			ECGReportDesc.setText("Reported");
			ECGReportDesc.setBounds(195, 10, 95, 20);
		}
		return ECGReportDesc;
	}

	public CheckBoxBase getECGReported() {
		if (ECGReported == null) {
			ECGReported = new CheckBoxBase();
			ECGReported.setBounds(220, 10, 70, 20);
		}
		return ECGReported;
	}

	private LabelBase getECGReportFromDesc() {
		if (ECGReportFromDesc == null) {
			ECGReportFromDesc = new LabelBase();
			ECGReportFromDesc.setText("Send From Date");
			ECGReportFromDesc.setBounds(305, 10, 95, 20);
		}
		return ECGReportFromDesc;
	}

	public TextDateWithCheckBox getECGReportFrom() {
		if (ECGReportFrom == null) {
			ECGReportFrom = new TextDateWithCheckBox();
			ECGReportFrom.setBounds(405, 10, 120, 20);
		}
		return ECGReportFrom;
	}

	private LabelBase getECGReportToDesc() {
		if (ECGReportToDesc == null) {
			ECGReportToDesc = new LabelBase();
			ECGReportToDesc.setText("Send To Date");
			ECGReportToDesc.setBounds(555, 10, 95, 20);
		}
		return ECGReportToDesc;
	}

	public TextDateWithCheckBox getECGReportTo() {
		if (ECGReportTo == null) {
			ECGReportTo = new TextDateWithCheckBox();
			ECGReportTo.setBounds(640, 10, 120, 20);
		}
		return ECGReportTo;
	}

	private LabelBase getCountDesc() {
		if (CountDesc == null) {
			CountDesc = new LabelBase();
			CountDesc.setText("Count");
			CountDesc.setBounds(780, 500, 150, 20);
		}
		return CountDesc;
	}

	private TextReadOnly getCount() {
		if (Count == null) {
			Count = new TextReadOnly();
			Count.setBounds(830, 500, 73, 20);
		}
		return Count;
	}
}