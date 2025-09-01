// Menu Name : Pending Exam
package com.hkah.client.tx.di;

import java.util.Date;
import java.util.List;

import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.store.ListStore;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.form.Field;
import com.google.gwt.user.datepicker.client.CalendarUtil;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.combobox.ComboDeptServ;
import com.hkah.client.layout.combobox.ComboDoctor;
import com.hkah.client.layout.combobox.ComboExcat;
import com.hkah.client.layout.combobox.ComboSpecialtyCode;
import com.hkah.client.layout.dialog.DlgDIECGExamRptHist;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.EditorTableList;
import com.hkah.client.layout.table.TableData;
import com.hkah.client.layout.textfield.TextDateWithCheckBox;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TableUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DIECGPendExam extends MasterPanel {

	public DIECGPendExam(BasePanel panelFrom) {
		super();
		// this.panelFrom = panelFrom;
	}

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.EGCPENDEXAM_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.EGCPENDEXAM_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] { 
				"Slip no", "Patient", "F. Name", "G. Name", "Type",
				//
				"Doc", "Date", "Pkg", "Code", "Exam Name", 
				//
				"Selected", "App. Time", "Room", "O Amt", "B Amt", 
				//
				"Disc %", "N Amt", "18", "19", "20",
				//
				"21", "22", "23", "24", "25",
				//
				"26", "27", "28"
				
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] { 
				100, 60, 100, 150, 50,
				//
				50, 80, 60, 60, 180, 
				//
				0, 80, 40, 60, 60, 
				//
				60, 60, 0, 0, 0,
				//
				0, 0, 0, 0, 0,
				//
				0, 0, 0
		};
	}

	/*
	 * private BasePanel panelFrom = null;
	 */
	private BasePanel rightPanel = null;
	private BasePanel leftPanel = null;

	private BasePanel ParaPanel = null;
	private TextDateWithCheckBox dateFrom = null;
	private LabelBase dateFromDesc = null;
	private TextDateWithCheckBox dateTo = null;
	private LabelBase dateToDesc = null;	
	private EditorTableList UpperTable = null;
	private JScrollPane UpperJScrollPane = null;
	private ComboBoxBase comboOrder = null;
	private LabelBase patNoDesc = null;
	private LabelBase slpNoDesc = null;
	private TextString slpNo = null;
	private LabelBase deptServiceCodeDesc = null;
	private ComboBoxBase deptServiceCode = null;
	private LabelBase patFNameDesc = null;
	private TextString patFName = null;
	private LabelBase patGNameDesc = null;
	private TextString patGName = null;
	private LabelBase showCancelDesc = null;
	private CheckBoxBase showCancel = null;
	private LabelBase patCountDesc = null;
	private TextReadOnly patCount = null;
	private LabelBase examCountDesc = null;
	private TextReadOnly examCount = null;
	private CheckBoxBase selected = null;
	private ComboDoctor comboDoctor = null;
	private LabelBase homeTelDesc = null;
	private TextReadOnly homeTel = null;
	private LabelBase locDesc = null;
	private TextReadOnly loc = null;
	private ButtonBase examRegistration = null;
	private ButtonBase appointment = null;
	private ButtonBase refund = null;
	private ButtonBase cancelApt = null;
	private ButtonBase preCharge = null;
	private ButtonBase refRegistration = null;

	
	private TextPatientNoSearch patNo = null;
	
	
	private DlgDIECGExamRptHist dlgDIECGExamRptHist = null;
	
	private JScrollPane getUpperJScrollPane() {
		if (UpperJScrollPane == null) {
			UpperJScrollPane = new JScrollPane();
			UpperJScrollPane.setViewportView(getUpperTable());			
			//UpperJScrollPane.setBounds(5, 90, 1200, 530);
			UpperJScrollPane.setBounds(5, 90, 1200, 650);
			UpperJScrollPane.setVisible(false);
		}
		return UpperJScrollPane;
	}

	private EditorTableList getUpperTable() {
		if (UpperTable == null) {
			UpperTable = new EditorTableList(getColumnNames(), getColumnWidths(), 

getSecProcTableEditors(), false) {
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
				//getSelected(), null, null, null, null,
				null, null, null, null, null,
				null, null, null, null, null,
				null, null, null, null, null,
				null, null, null
		};
	}
	
	private ComboDoctor getComboDoctor() {
		if (comboDoctor == null) {			
		}
		return comboDoctor;
	}
	
	private CheckBoxBase getSelected() {
		if (selected == null) {
			selected = new CheckBoxBase();
		}
		return selected;
	}
	
	/**
	 * This method initializes test
	 * 
	 */
	public DIECGPendExam() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		setLeftAlignPanel();
		//getJScrollPane().setBounds(5, 500, 1200, 200);
		getJScrollPane().setBounds(5, 90, 1200, 650);
		getClearButton().setEnabled(true);
		return true;
	}

	private void setInitValue() {
		Date fromDate = DateTimeUtil.parseDateTime(getMainFrame()
				.getServerDateTime());
		//CalendarUtil.addMonthsToDate(fromDate, -1);
		//getDateFrom().setText(DateTimeUtil.formatDate(fromDate));		
		getDateFrom().setText(getMainFrame().getServerDate());
		getDateTo().setText(getMainFrame().getServerDate());
		getPatCount().setText(ZERO_VALUE);
		getExamCount().setText(ZERO_VALUE);
		getUpperTable().removeAllRow();
	}
	
	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		// getPatNo().setText(getParameter("PatNo"));
		// getEGCReportDate().setText(getMainFrame().getServerDate());
		setInitValue();
		// searchAction();
		getUpperTable().removeAllRow();
		
		//getJScrollPane().setVisible(false);
		//getListTable().setVisible(false);		

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
		getDateFrom().setEnabled(true);
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
		getPatCount().setText(ZERO_VALUE);
		
	}

	@Override
	protected void searchPostAction() {
		// for override if necessary	
		getPatCount().setText(getPatTotCount());
	}

	private String getPatTotCount() {
		int patCount = 0;
		String currPatNo = "";
		String basePatNo = "";
		
		getJScrollPane().setVisible(true);
		getListTable().setVisible(true);
		
		if (getListTable().getRowCount() > 0) {
			for (int i = 0; i < getListTable().getRowCount(); i++) {
				getListTable().setSelectRow(i);
				currPatNo = getListTable().getSelectedRowContent()[1];
				if (!currPatNo.equals(basePatNo )) {
					patCount = patCount + 1;				
					basePatNo = getListTable().getSelectedRowContent()[1];
				}
			}
		}
		
		
		QueryUtil.executeMasterBrowse(getUserInfo(), "ECGPENDEXAM",
				new String[] { "1", getDateFrom().getText(), getDateTo().getText(), getSlpNo

().getText(), 
			 					getDeptServiceCode().getText(), getPatNo().getText

(), 
			 					getPatFName().getText(), getPatGName().getText(), 

getShowCancel().getText() }, new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						//String patCnt = null;
						// Can loop through record set
						if (mQueue.success()) {
							List<String[]> rs = mQueue.getContentAsArray();
							if (mQueue.getContentField().length > 0) {
								getPatCount().setText(rs.get(0)[0]);
								}
							}
						}									

	
				});	
		
		//getJScrollPane().setVisible(false);
		//getListTable().setVisible(false);
		
		return Integer.toString(patCount);

	}
	
	@Override
	protected void enableButton(String mode) {
		// disable all button
		disableButton();
		getSearchButton().setEnabled(true);
		getDateFrom().setEnabled(true);
		getClearButton().setEnabled(true);
		getExamCount().setText(Integer.toString(getListTable().getRowCount()));
		//getPatCount().setText(getPatTotCount());
		getExamRegistration().setEnabled(false);
		getAppointment().setEnabled(false);
		getRefund().setEnabled(false);
		getCancelApt().setEnabled(false);
		getPreCharge().setEnabled(false);
		getRefRegistration().setEnabled(false);
	}

	@Override
	protected void performListPost() {
		// for child class call
		int selRow;
		
		getJScrollPane().setVisible(true);
		getListTable().setVisible(true);
		
		getUpperTable().removeAllRow();
		
		ListStore<TableData> store;
		TableData rowData; 
		//getUpperTable().setListTableContent(getListTable().getStore().getModels());
		
		for (int i = 0; i < getListTable().getRowCount(); i++) {
			getUpperTable().addEmptyRow(1);			
			//getListTable().setRowSelectionInterval(i, i);			
			//getListTable().setSelectRow(i);
			selRow = i; //getUpperTable().getSelectedRow();
			store = getUpperTable().getStore();
			rowData = store.getAt(selRow);
			rowData.set(TableUtil.getName2ID("Slip no"),getListTable().getRowContent(i)[0]);
			rowData.set(TableUtil.getName2ID("Patient"),getListTable().getRowContent(i)[1]);
			rowData.set(TableUtil.getName2ID("F. Name"),getListTable().getRowContent(i)[2]);
			rowData.set(TableUtil.getName2ID("G. Name"),getListTable().getRowContent(i)[3]);
			rowData.set(TableUtil.getName2ID("Type"),getListTable().getRowContent(i)[4]);
			//
			rowData.set(TableUtil.getName2ID("Doc"),getListTable().getRowContent(i)[5]);
			rowData.set(TableUtil.getName2ID("Date"),getListTable().getRowContent(i)[6]);
			rowData.set(TableUtil.getName2ID("Pkg"),getListTable().getRowContent(i)[7]);
			rowData.set(TableUtil.getName2ID("Code"),getListTable().getRowContent(i)[8]);
			rowData.set(TableUtil.getName2ID("Exam Name"),getListTable().getRowContent(i)[9]);
			//
			//rowData.set(TableUtil.getName2ID("Selected"),getListTable().getRowContent(i)[10]);
			rowData.set(TableUtil.getName2ID("App. Time"),getListTable().getRowContent(i)[11]);
			rowData.set(TableUtil.getName2ID("Room"),getListTable().getRowContent(i)[12]);
			rowData.set(TableUtil.getName2ID("O Amt"),getListTable().getRowContent(i)[13]);
			rowData.set(TableUtil.getName2ID("B Amt"),getListTable().getRowContent(i)[14]);
			//
			rowData.set(TableUtil.getName2ID("Disc %"),getListTable().getRowContent(i)[15]);
			rowData.set(TableUtil.getName2ID("N Amt"),getListTable().getRowContent(i)[16]);
			rowData.set(TableUtil.getName2ID("18"),getListTable().getRowContent(i)[17]);
			rowData.set(TableUtil.getName2ID("19"),getListTable().getRowContent(i)[18]);
			rowData.set(TableUtil.getName2ID("20"),getListTable().getRowContent(i)[19]);
			//
			rowData.set(TableUtil.getName2ID("21"),getListTable().getRowContent(i)[20]);
			rowData.set(TableUtil.getName2ID("22"),getListTable().getRowContent(i)[21]);
			rowData.set(TableUtil.getName2ID("23"),getListTable().getRowContent(i)[22]);
			rowData.set(TableUtil.getName2ID("24"),getListTable().getRowContent(i)[23]);
			rowData.set(TableUtil.getName2ID("25"),getListTable().getRowContent(i)[24]);
			//
			rowData.set(TableUtil.getName2ID("26"),getListTable().getRowContent(i)[25]);
			rowData.set(TableUtil.getName2ID("27"),getListTable().getRowContent(i)[26]);
			rowData.set(TableUtil.getName2ID("28"),getListTable().getRowContent(i)[27]);			


		}
		getUpperTable().getView().refresh(true);
		
		//getJScrollPane().setVisible(false);
		//getListTable().setVisible(false);
		
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public Component getDefaultFocusComponent() {
		return getDateFrom().getDateField();
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
		if (getDateFrom().isValid() && (getDateTo().isValid())) {
			return true;
		} else {
			return false;
		}
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {	
		
		System.out.println("getDateFrom().getText() : " + getDateFrom().getText());
		System.out.println("getDateTo().getText() : " + getDateTo().getText());
		System.out.println("getSlpNo().getText() : " + getSlpNo().getText());
		System.out.println("getPatNo().getText() : " + getPatNo().getText());
		
		
		String[] inParm = new String[] { "0", getDateFrom().getText(), getDateTo().getText(), getSlpNo

().getText(), 
										 getDeptServiceCode().getText(), 

getPatNo().getText(), 
										 getPatFName().getText(), 

getPatGName().getText(), getShowCancel().getText()
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
	@Override
	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.add(getParaPanel());
			leftPanel.add(getJScrollPane());
			leftPanel.add(getUpperJScrollPane());
			//leftPanel.add(getExamRptHist());
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
			ParaPanel.setBounds(5, 10, 1200, 70);
			ParaPanel.setBorders(true);
			ParaPanel.add(getslpNoDesc(), null);
			ParaPanel.add(getSlpNo(), null);
			ParaPanel.add(getDeptServiceCodeDesc(), null);
			ParaPanel.add(getDeptServiceCode(), null);
			ParaPanel.add(getDateFromDesc(), null);
			ParaPanel.add(getDateFrom(), null);
			ParaPanel.add(getDateToDesc(), null);
			ParaPanel.add(getDateTo(), null);
			ParaPanel.add(getpatNoDesc(), null);
			ParaPanel.add(getPatNo(), null);
			ParaPanel.add(getPatFNameDesc(), null);
			ParaPanel.add(getPatFName(), null);
			ParaPanel.add(getPatGNameDesc(), null);
			ParaPanel.add(getPatGName(), null);
			ParaPanel.add(getShowCancelDesc(), null);
			ParaPanel.add(getShowCancel(), null);
			ParaPanel.add(getPatCountDesc(), null);
			ParaPanel.add(getPatCount(), null);
			ParaPanel.add(getExamCountDesc(), null);
			ParaPanel.add(getExamCount(), null);
			ParaPanel.add(getHomeTelDesc(), null);
			ParaPanel.add(getHomeTel(), null);
			ParaPanel.add(getLocDesc(), null);
			ParaPanel.add(getLoc(), null);			
			ParaPanel.setHeading("Criteria");
			ParaPanel.setTitle("Criteria");
			ParaPanel.add(getExamRegistration(), null);
			ParaPanel.add(getAppointment(), null);
			ParaPanel.add(getRefund(), null);
			ParaPanel.add(getCancelApt(), null);
			ParaPanel.add(getPreCharge(), null);
			ParaPanel.add(getRefRegistration(), null);
		}
		return ParaPanel;
	}
	
	private LabelBase getpatNoDesc() {
		if (patNoDesc == null) {
			patNoDesc = new LabelBase();
			patNoDesc.setText("Patient No");
			patNoDesc.setBounds(5, 40, 95, 20);
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
              patNo.setBounds(85, 40, 95, 20);
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
	private LabelBase getslpNoDesc() {
		if (slpNoDesc == null) {
			slpNoDesc = new LabelBase();
			slpNoDesc.setText("Slip No");
			slpNoDesc.setBounds(5, 10, 95, 20);
		}
		return slpNoDesc;
	}

	private TextString getSlpNo() {
		if (slpNo == null) {
			slpNo = new TextString(81);
			slpNo.setBounds(85, 10, 95, 20);
		}
		return slpNo;
	}
	
	private LabelBase getDeptServiceCodeDesc() {
		if (deptServiceCodeDesc == null) {
			deptServiceCodeDesc = new LabelBase();
			deptServiceCodeDesc.setText("Dept Service Code");
			deptServiceCodeDesc.setBounds(195, 10, 150, 20);
		}
		return deptServiceCodeDesc;
	}
	
	protected ComboBoxBase getDeptServiceCode() {
		if (deptServiceCode == null) {
			deptServiceCode = new ComboExcat();
			deptServiceCode.setBounds(305, 10, 95, 20);
		}
		return deptServiceCode;
	}

	private LabelBase getDateFromDesc() {
		if (dateFromDesc == null) {
			dateFromDesc = new LabelBase();
			dateFromDesc.setText("Date From");
			dateFromDesc.setBounds(415, 10, 95, 20);
		}
		return dateFromDesc;
	}

	public TextDateWithCheckBox getDateFrom() {
		if (dateFrom == null) {
			dateFrom = new TextDateWithCheckBox();
			dateFrom.setBounds(490, 10, 120, 20);
		}
		return dateFrom;
	}

	private LabelBase getDateToDesc() {
		if (dateToDesc == null) {
			dateToDesc = new LabelBase();
			dateToDesc.setText("Date To");
			dateToDesc.setBounds(620, 10, 95, 20);
		}
		return dateToDesc;
	}

	public TextDateWithCheckBox getDateTo() {
		if (dateTo == null) {
			dateTo = new TextDateWithCheckBox();
			dateTo.setBounds(685, 10, 120, 20);
		}
		return dateTo;
	}

	private LabelBase getPatFNameDesc() {
		if (patFNameDesc == null) {
			patFNameDesc = new LabelBase();
			patFNameDesc.setText("Patient F. Name");
			patFNameDesc.setBounds(195, 40, 95, 20);
		}
		return patFNameDesc;
	}

	private TextString getPatFName() {
		if (patFName == null) {
			patFName = new TextString(81);
			patFName.setBounds(305, 40, 150, 20);
		}
		return patFName;
	}

	private LabelBase getPatGNameDesc() {
		if (patGNameDesc == null) {
			patGNameDesc = new LabelBase();
			patGNameDesc.setText("Patient F. Name");
			patGNameDesc.setBounds(480, 40, 95, 20);
		}
		return patGNameDesc;
	}

	private TextString getPatGName() {
		if (patGName == null) {
			patGName = new TextString(81);
			patGName.setBounds(590, 40, 150, 20);
		}
		return patGName;
	}

	private LabelBase getShowCancelDesc() {
		if (showCancelDesc == null) {
			showCancelDesc = new LabelBase();
			showCancelDesc.setText("Show Cancel");
			showCancelDesc.setBounds(750, 40, 95, 20);
		}
		return showCancelDesc;
	}
	
	public CheckBoxBase getShowCancel() {
		if (showCancel == null) {
			showCancel = new CheckBoxBase();
			showCancel.setBounds(800, 40, 70, 20);
		}
		return showCancel;
	}

	/*
	
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
	*/

	private LabelBase getPatCountDesc() {
		if (patCountDesc == null) {
			patCountDesc = new LabelBase();
			patCountDesc.setText("Patient Count");
			patCountDesc.setBounds(820, 730, 150, 20);
		}
		return patCountDesc;
	}

	private TextReadOnly getPatCount() {
		if (patCount == null) {
			patCount = new TextReadOnly();
			patCount.setBounds(900, 730, 73, 20);
		}
		return patCount;
	}
	
	private LabelBase getExamCountDesc() {
		if (examCountDesc == null) {
			examCountDesc = new LabelBase();
			examCountDesc.setText("Exam Count");
			examCountDesc.setBounds(1000, 730, 150, 20);
		}
		return examCountDesc;
	}

	private TextReadOnly getExamCount() {
		if (examCount == null) {
			examCount = new TextReadOnly();
			examCount.setBounds(1080, 730, 73, 20);
		}
		return examCount;
	}

	private LabelBase getHomeTelDesc() {
		if (homeTelDesc == null) {
			homeTelDesc = new LabelBase();
			homeTelDesc.setText("Home Tel");
			homeTelDesc.setBounds(5, 730, 150, 20);
		}
		return homeTelDesc;
	}

	private TextReadOnly getHomeTel() {
		if (homeTel == null) {
			homeTel = new TextReadOnly();
			homeTel.setBounds(100, 730, 73, 20);
		}
		return homeTel;
	}

	private LabelBase getLocDesc() {
		if (locDesc == null) {
			locDesc = new LabelBase();
			locDesc.setText("Location");
			locDesc.setBounds(200, 730, 150, 20);
		}
		return examCountDesc;
	}
	
	private TextReadOnly getLoc() {
		if (loc == null) {
			loc = new TextReadOnly();
			loc.setBounds(250, 730, 73, 20);
		}
		return loc;
	}

	private ButtonBase getExamRegistration() {
		
		if (examRegistration == null) {
			examRegistration = new ButtonBase() {
			};
			examRegistration.setText("Registration", 'R');
			examRegistration.setBounds(5, 760, 100, 20);
		}
		return examRegistration;
	}
	
	private ButtonBase getAppointment() {
		
		if (appointment == null) {
			appointment = new ButtonBase() {
			};
			appointment.setText("Appointment", 'A');
			appointment.setBounds(110, 760, 100, 20);
		}
		return appointment;
	}

	private ButtonBase getRefund() {
		
		if (refund  == null) {
			refund = new ButtonBase() {
			};
			refund.setText("Refund", 'f');
			refund.setBounds(215, 760, 60, 20);
		}
		return refund;
	}
	
	private ButtonBase getCancelApt() {
		
		if (cancelApt  == null) {
			cancelApt = new ButtonBase() {
			};
			cancelApt.setText("Cancel APT", 'C');
			cancelApt.setBounds(280, 760, 80, 20);
		}
		return cancelApt;
	}

	private ButtonBase getPreCharge() {
		
		if (preCharge  == null) {
			preCharge = new ButtonBase() {
			};
			preCharge.setText("Pre Charges", 'r');
			preCharge.setBounds(365, 760, 100, 20);
		}
		return preCharge;
	}

	private ButtonBase getRefRegistration () {
		
		if (refRegistration   == null) {
			refRegistration = new ButtonBase() {
			};
			refRegistration.setText("Referral Registration", 'g');
			refRegistration.setBounds(470, 760, 100, 20);
		}
		return refRegistration;
	}
}