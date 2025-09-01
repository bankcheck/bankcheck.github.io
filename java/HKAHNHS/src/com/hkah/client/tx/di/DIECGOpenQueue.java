package com.hkah.client.tx.di;

import java.util.Date;
import java.util.List;

import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.store.ListStore;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.form.Field;
import com.google.gwt.user.datepicker.client.CalendarUtil;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.combobox.ComboDoctor;
import com.hkah.client.layout.dialog.DlgDIECGExamRptHist;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.EditorTableList;
import com.hkah.client.layout.table.TableData;
import com.hkah.client.layout.textfield.TextDateWithCheckBox;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TableUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DIECGOpenQueue extends MasterPanel {

	public DIECGOpenQueue(BasePanel panelFrom) {
		super();
		// this.panelFrom = panelFrom;
	}

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.EGCOEPNQUEUE_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.EGCQOPENUEUE_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] { "Report Date", "Report Dr", "DI No", "Code", "Description",
				//
				"Perform", "Type", "Typist", "", "", ""
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] { 120, 120, 80, 60, 120,
				//
				120, 120, 60, 0, 0, 0 };
	}

	/*
	 * private BasePanel panelFrom = null;
	 */
	private BasePanel rightPanel = null;
	private BasePanel leftPanel = null;

	private BasePanel ParaPanel = null;
	private LabelBase EGCReportDesc = null;
	private TextDateWithCheckBox EGCReportDate = null;
	private LabelBase EGCOrderbyDesc = null;
	private ButtonBase ExamRptHist = null;

	private EditorTableList UpperTable = null;
	private JScrollPane UpperJScrollPane = null;
	private ComboDoctor comboDoctor = null;
	private ComboBoxBase comboOrder = null;
	private LabelBase patNoDesc = null;
	private LabelBase comboDoctorDesc = null;
	private TextPatientNoSearch patNo = null;
	
	private DlgDIECGExamRptHist dlgDIECGExamRptHist = null;
	
	private JScrollPane getUpperJScrollPane() {
		if (UpperJScrollPane == null) {
			UpperJScrollPane = new JScrollPane();
			UpperJScrollPane.setViewportView(getUpperTable());
			// CLJScrollPane.setBounds(10, 300, 771, 200);
			UpperJScrollPane.setBounds(5, 90, 900, 530);
		}
		return UpperJScrollPane;
	}

	private EditorTableList getUpperTable() {
		if (UpperTable == null) {
			UpperTable = new EditorTableList(getColumnNames(), getColumnWidths(), getSecProcTableEditors()) {
				public void doubleClick() {

				}
			};
		}
		return UpperTable;
	}
	
	private Field<? extends Object>[] getSecProcTableEditors() {
		return new Field[] {
				null, null, null, null, null, 
				null, null, null, null, null,
				null, null, null, null, null,
				null, null
		};
	}
	
	/**
	 * This method initializes test
	 * 
	 */
	public DIECGOpenQueue() {
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
		getClearButton().setEnabled(true);
		return true;
	}

	private void setInitValue() {
		Date fromDate = DateTimeUtil.parseDateTime(getMainFrame()
				.getServerDateTime());
		CalendarUtil.addMonthsToDate(fromDate, -1);
		getEGCReportDate().setText(DateTimeUtil.formatDate(fromDate));
		getComboOrder().setSelectedIndex(0);
	}
	
	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		// getPatNo().setText(getParameter("PatNo"));
		// getEGCReportDate().setText(getMainFrame().getServerDate());
		setInitValue();
		// searchAction();
	}

	@Override
	protected void clearPostAction() {
		super.clearPostAction();
		setInitValue();
	}
	
	@Override
	protected void cancelPostAction() {
		// for override if necessary
		super.cancelPostAction();
		searchAction();
		getEGCReportDate().setEnabled(true);
	}

	@Override
	protected void savePostAction() {
		// for override if necessary
		super.savePostAction();
		System.out.println("savePostAction()");
		searchAction();
	}

	
	@Override
	public void searchAction() {
		super.searchAction();
	}

	@Override
	protected void searchPostAction() {
		// for override if necessary

	}

	@Override
	protected void enableButton(String mode) {
		// disable all button
		disableButton();
		getSearchButton().setEnabled(true);
		getEGCReportDate().setEnabled(true);
		getClearButton().setEnabled(true);
		// getSaveButton().setEnabled(getListTable().getRowCount() > 0);
		// getCancelButton().setEnabled(getListTable().getRowCount() > 0);

		/*
		 * getSearchButton().setEnabled(true);
		 * getAcceptButton().setEnabled(!isDisableFunction("Accept", "srhReg")
		 * && !isDisableFunction("TB_ACCEPT", "srhReg") &&
		 * getListTable().getRowCount() > 0 && getListTable().getSelectedRow()
		 * >= 0 &&
		 * "N".equals(getListTable().getSelectedRowContent()[GrdCol_regsts]));
		 * getCancelButton().setEnabled(getListTable().getRowCount() > 0);
		 * getClearButton().setEnabled(true);
		 * getRefreshButton().setEnabled(true);
		 */
		//setActionType(QueryUtil.ACTION_MODIFY);
	}

	@Override
	protected void performListPost() {
		// for child class call
		getUpperTable().setListTableContent(
				getListTable().getStore().getModels());
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public Component getDefaultFocusComponent() {
		return getEGCReportDate().getDateField();
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
		String xrptState = null;
		//String removed = null;

		// removed = getEGCQueueRemove().getValue();
		xrptState = "P";
		
		System.out.println("xrptState : " + xrptState);
		System.out.println("getComboDoctor().getText() : " + getComboDoctor().getText());
		System.out.println("getPatNo().getText() : " + getPatNo().getText());
		System.out.println("getEGCReportDate().getText() : " + getEGCReportDate().getText());
		System.out.println("getComboOrder().getText() : " + getComboOrder().getText() );
		
		
		String[] inParm = new String[] { xrptState, getComboDoctor().getText(), 
										getPatNo().getText(), getEGCReportDate().getText(), getComboOrder().getText()
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
		return new String[] {};
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
	private ButtonBase getExamRptHist() {
		
		if (ExamRptHist == null) {
			ExamRptHist = new ButtonBase() {
				@Override
				public void onClick() {
					if (getUpperTable().getRowCount() > 0) {
					  getDlgDIECGExamRptHist().showDialog("", "");
					}
				}
			};
			ExamRptHist.setText("Exam Report History", 'E');
			ExamRptHist.setBounds(10, 625, 135, 25);
		}
		return ExamRptHist;
	}

	@Override
	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.add(getParaPanel());
			leftPanel.add(getJScrollPane());
			leftPanel.add(getUpperJScrollPane());
			leftPanel.add(getExamRptHist());
		}
		return leftPanel;
	}

	protected BasePanel getRightPanel() {

		if (rightPanel == null) {
			rightPanel = new BasePanel();
			// leftPanel.setSize(800, 530));
		}
		return rightPanel;
	}

	public BasePanel getParaPanel() {
		if (ParaPanel == null) {
			ParaPanel = new BasePanel();
			ParaPanel.setBounds(10, 10, 771, 70);
			ParaPanel.setBorders(true);
			ParaPanel.add(getpatNoDesc(), null);
			ParaPanel.add(getPatNo(), null);
			ParaPanel.add(getcomboDoctorDesc(), null);
			ParaPanel.add(getComboDoctor(), null);
			ParaPanel.add(getEGCReportDesc(), null);
			ParaPanel.add(getEGCReportDate(), null);
			ParaPanel.add(getEGCOrderbyDesc(), null);
			ParaPanel.add(getComboOrder(), null);
			ParaPanel.setHeading("Criteria");
			ParaPanel.setTitle("Criteria");

		}
		return ParaPanel;
	}
	
	private LabelBase getpatNoDesc() {
		if (patNoDesc == null) {
			patNoDesc = new LabelBase();
			patNoDesc.setText("Patient No");
			patNoDesc.setBounds(5, 10, 95, 20);
		}
		return patNoDesc;
	}
	
	private TextPatientNoSearch getPatNo() {
        if (patNo == null) {
        	patNo = new TextPatientNoSearch(true, false) {
                    protected void checkPatient(boolean isExistPatient, boolean bySearchKey) {
                          super.checkPatient(isExistPatient, bySearchKey);
                          if (isExistPatient && bySearchKey) {
                        	  getPatNo().checkPatientAlert();
                                searchAction(true);
                          }
                    }

                    @Override
                    protected void showMergeFromPatientPost() {
                    	getPatNo().checkPatientAlert();
//                        searchAction(true);
//                        getLeftJText_SlipNo().focus();
                    }

                    @Override
                    protected void showMergePatientPost() {
                          showSearchPanel();
                          resetText();
                    }
              };
//            LeftJText_PatientNo.setShowAllAlert(false);
              patNo.setBounds(85, 10, 95, 20);
              patNo.setShowAlertByRequest(true);
        }
        return patNo;
  }

/*
	private TextString getPatNo() {
		if (patNo == null) {
			patNo = new TextString();
			patNo.setBounds(85, 10, 95, 20);
		}
		return patNo;
	}
*/
	private LabelBase getcomboDoctorDesc() {
		if (comboDoctorDesc == null) {
			comboDoctorDesc = new LabelBase();
			comboDoctorDesc.setText("Doctor Code");
			comboDoctorDesc.setBounds(5, 40, 95, 20);
		}
		return comboDoctorDesc;
	}

	private ComboDoctor getComboDoctor() {
		if (comboDoctor == null) {
			comboDoctor = new ComboDoctor("EGCOpenQueue") {
				@Override
				protected void setTextPanel(ModelData modelData) {
					super.setTextPanel(modelData);

					if (modelData != null) {
						String text = modelData.get(ONE_VALUE).toString();
						String otpcode = null;
						String[] temp = text.split("  ");
						if (temp.length > 1) {
							otpcode = temp[temp.length - 1];
						}

						//getListTable().setValueAt(otpcode,
						//		getListTable().getSelectedRow(), 5);
						//getListTable().setValueAt(text,
						//		getListTable().getSelectedRow(), 4);
						//getListTable().setValueAt(modelData.get(ZERO_VALUE).toString(),
						//		getListTable().getSelectedRow(), 3);
					}
				}
				
				@Override
				protected void onSelected() {
					// override by child class when selected
					//getSearchButton().setEnabled(false);
					//getSaveButton().setEnabled(true);
					//getCancelButton().setEnabled(true);
					//getEGCReportDate().setEnabled(false);
				}
			};
			comboDoctor.setBounds(85, 40, 95, 20);
		}
		return comboDoctor;
	}
	
	private LabelBase getEGCReportDesc() {
		if (EGCReportDesc == null) {
			EGCReportDesc = new LabelBase();
			EGCReportDesc.setText("Report Date");
			EGCReportDesc.setBounds(538, 10, 95, 20);
		}
		return EGCReportDesc;
	}

	public TextDateWithCheckBox getEGCReportDate() {
		if (EGCReportDate == null) {
			EGCReportDate = new TextDateWithCheckBox();
			EGCReportDate.setBounds(635, 10, 120, 20);
		}
		return EGCReportDate;
	}


	private LabelBase getEGCOrderbyDesc() {
		if (EGCOrderbyDesc == null) {
			EGCOrderbyDesc = new LabelBase();
			EGCOrderbyDesc.setText("Order by");
			EGCOrderbyDesc.setBounds(538, 40, 95, 20);
		}
		return EGCOrderbyDesc;
	}

	private ComboBoxBase getComboOrder() {
		if (comboOrder == null) {
			comboOrder = new ComboBoxBase();
			
			comboOrder.addItem("reportdate desc,dino desc", "Report Date");
			comboOrder.addItem("reportdr,reportdate desc,dino desc", "Report Dr.");
			comboOrder.addItem("dino desc", "DI NO.");
			
			//comboOrder.add(new String[] {"reportdate desc,dino desc"});
			//comboOrder.add(new String[] {"reportdr,reportdate desc,dino desc"});
			//comboOrder.add(new String[] {"dino desc"});
			comboOrder.setBounds(600, 40, 150, 20);
		}
		return comboOrder;
		
	}
	
	private DlgDIECGExamRptHist getDlgDIECGExamRptHist() {
		if (dlgDIECGExamRptHist == null) {
			dlgDIECGExamRptHist = new DlgDIECGExamRptHist(getMainFrame());
		}
		return dlgDIECGExamRptHist;
	}
}