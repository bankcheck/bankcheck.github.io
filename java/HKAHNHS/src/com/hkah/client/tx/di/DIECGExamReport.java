// Menu Name Exam Report
package com.hkah.client.tx.di;

import java.util.Date;
import java.util.HashMap;

import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.MessageBox;
import com.google.gwt.user.datepicker.client.CalendarUtil;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.dialog.DlgDIReportApprove;
import com.hkah.client.layout.dialog.DlgDIReportHist;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.radiobutton.RadioButtonBase;
import com.hkah.client.layout.table.EditorTableList;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;


public class DIECGExamReport extends MasterPanel {

	public DIECGExamReport(BasePanel panelFrom) {
		super();
		// this.panelFrom = panelFrom;
	}

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.ECGEXAMREPORT_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.ECGEXAMREPORT_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] { 
				"XRGID", "Exam Date", "DI No", "Code", "Description", //0, 1, 2, 3, 4, 
				//
				"Status", "Report Date", "Report Dr", "Perform", "Typist", //5, 6, 7, 8, 9 
				//
				"Ver.", "Approve Date", "P.Cnt", "XRGREMARK", "PKGCODE", //10, 11, 12, 13, 14
				//
				"XRPID", "XRPCOMBINE", "COMBINED", "REPORTED", "XRPTITLE", //15, 16, 17, 18, 19
				//
				"CLINICNO", "TRANSVER", "XRGRPTFLAG", "XRPTSTS"//20, 21, 22, 23
		};
	}
	
	public TableList getListTable() {
		if (listTable == null) {
			listTable = new TableList(getColumnNames(), getColumnWidths()) {
				@Override
				public void onClick() {
					listTableRowChange();

				}
			};
		}
		return listTable;
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] { 
				0, 80, 80, 50, 200,
				//
				120, 80, 80, 80, 80,
				//
				50, 80, 50,
				//
				0, 0, 0, 0, 0,
				//
				0, 0, 0, 0, 0,
				//
				0,
		
		};
	}
	private TableList listTable = null;
	private BasePanel rightPanel = null;
	private BasePanel leftPanel = null;

	private BasePanel ParaPanel = null;

	private LabelBase patNoDesc = null;
	private LabelBase diNoDesc = null;
	private TextString diNo = null;
	private LabelBase patNameDesc = null;
	private TextReadOnly patName = null;
	private LabelBase patChiNameDesc = null;
	private TextReadOnly patChiName = null;
	private LabelBase patHKIDDesc = null;
	private TextReadOnly patHKID = null;
	private LabelBase patLocDesc = null;
	private TextReadOnly patLoc = null;
	private LabelBase patSexDesc = null;
	private TextReadOnly patSex = null;	
	private LabelBase patAttDoctorDesc = null;
	private TextReadOnly patAttDoctor = null;

	private TextReadOnly examCount = null;
	
	private ButtonBase reportHistory = null;

	
	private DlgDIReportHist dlgDiReportHist = null;
	private DlgDIReportApprove dlgDiReportApprove = null;
	
	private TextPatientNoSearch patNo = null;
	private String varPatFName;
	private String varPatGName;
	private String varIDNo;
	private String varDOB;
	private String varSex;
	private String varPatCName;
	private String varSlipNo;
	private String varRegDate;
	private String varDocCode;
	private String varPatType;
	private String varCurLocation;
	private String varBedCode;
	private String varAcmCode;
	private String varJobNo;
	private String varLastVisit;
	private String varExpiryDate;
	private String varDisposed;
	private String varFilmInDI;
		
	/**
	 * This method initializes test
	 * 
	 */
	public DIECGExamReport() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		setLeftAlignPanel();
		getJScrollPane().setBounds(10, 160, 1000, 420);
		getClearButton().setEnabled(true);
		return true;
	}

	private void setInitValue() {
		//setDIinfo();
		Date fromDate = DateTimeUtil.parseDateTime(getMainFrame().getServerDateTime());
		CalendarUtil.addMonthsToDate(fromDate, -1);
	}
	
	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		getPatNo().setText(getParameter("PatNo"));
		if(getPatNo().getText().length()>0){
			searchAction();
		}
		setInitValue();
		listTableRowChange();
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
	}

	@Override
	protected void savePostAction() {
		super.savePostAction();
		searchAction();
	}

	@Override
	protected void searchPostAction() {
		if ((!"".equals(getPatNo().getText().trim()) || !"".equals(getDINo().getText().trim()))) {
			bDICheckPatNo(diNo.getText().trim());
			if (getPatNo().isMergePatientNo()) { // sGetMergePatNo(getPatNo().getText().trim());
				return;
			}
			// Fill patient information
			getPatInfo(getPatNo().getText().trim(), getDINo().getText().trim());
		}
	}
	
	@Override
	public void appendAction() {
		if(getListTable().getRowCount() > 0){
			showReportEditor();
		}else{
			MessageBox mb = MessageBoxBase.info("Error", "Please select at least one record.", null);
		}
	}
	
	@Override
	public void modifyAction() {
		if(getListTable().getRowCount() > 0){
			showReportEditor();
		}else{
			MessageBox mb = MessageBoxBase.info("Error", "Please select at least one record.", null);
		}
	}
	
	@Override
	public void acceptAction() {
		getDIReportApprove().showDialog(
				//XRGID, XRPID, DOCCODE
				getListTable().getSelectedRowContent()[0],
				getListTable().getSelectedRowContent()[15],
				getListTable().getSelectedRowContent()[7]
			);
	}
	
	private DlgDIReportApprove getDIReportApprove() {
		if (dlgDiReportApprove == null) {
			dlgDiReportApprove = new DlgDIReportApprove(getMainFrame()){
				@Override
				public void post(boolean success) {
					// TODO Auto-generated method stub
					if(success){
						searchAction();
					}
					dispose();
				}
			};
		}
		return dlgDiReportApprove;
	}
	
	@Override
	public void printAction() {
		printReport();
	}
	
	@Override
	protected void enableButton(String mode) {
		// disable all button
		disableButton();
		getSearchButton().setEnabled(true);
		getClearButton().setEnabled(true);
		getExamCount().setText(Integer.toString(getListTable().getRowCount()));
		getReportHist().setEnabled(getListTable().getRowCount() > 0);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public Component getDefaultFocusComponent() {
		return getPatNo();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {
		getSearchButton().setEnabled(true);
		getSaveButton().setEnabled(false);
		getCancelButton().setEnabled(false);
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
		String[] inParm = new String[] {
				getPatNo().getText(), 
				getDINo().getText()
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
		listTableRowChange();
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
	 * Helper Method
	 **************************************************************************/

	// VB DI_Module Function
	private void bDICheckPatNo(String DINo) {
		QueryUtil.executeMasterFetch(getUserInfo(), "ECGDICHECKPATNO", new String[] { DINo },
				new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							System.out.println("[sFmPatNo]:" + mQueue.getContentField()[0] + ";[sToPatNo]:" + mQueue.getContentField()[1]);
							if (!"".equals(mQueue.getContentField()[0])) {
								Factory.getInstance().addInformationMessage(
										"Patient " + mQueue.getContentField()[0] + " has been merged to patient " + mQueue.getContentField()[1]);
							}
						}

					}
				});
	}
	
	private void getPatInfo(final String patNo, final String diNo) {
		QueryUtil.executeMasterFetch(getUserInfo(), "ECGGETPATINFO", new String[] { patNo, diNo },
				new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							varPatFName = mQueue.getContentField()[1];
							varPatGName = mQueue.getContentField()[2];
							varIDNo = mQueue.getContentField()[3];
							varDOB = mQueue.getContentField()[4];
							varSex = mQueue.getContentField()[5];
							varPatCName = mQueue.getContentField()[6];
							varSlipNo = mQueue.getContentField()[7];
							varRegDate = mQueue.getContentField()[8];
							varDocCode = mQueue.getContentField()[18];
							varCurLocation = mQueue.getContentField()[19];

							
							if("".equals(patNo) || patNo.isEmpty()){
								getPatNo().setText(mQueue.getContentField()[0]);
							}
							getpatName().setText(varPatFName + " " + varPatGName);
							getpatChiName().setText(varPatCName);
							getPatHKID().setText(varIDNo);
							getPatSex().setText(varSex);
							getPatAttDoctor().setText(varDocCode);
							getPatLoc().setText(varCurLocation);
						}
					}
				});
	}
	
	private void printReport(){
		HashMap<String, String> map = new HashMap<String, String>();
		
		map.put("SUBREPORT_DIR", CommonUtil.getReportDir());																
		map.put("LogoImg", CommonUtil.getReportImg("TWAH_rpt_logo.jpg"));
		
		map.put("userID", Factory.getInstance().getUserInfo().getUserID());
		map.put("userName", Factory.getInstance().getUserInfo().getUserName());
		//map.put("newbarcode", newbarcode);
		
		
		PrintingUtil.print(
				"DIEchoReport", 										
				map, 													
				null,													
				new String[]{ getListTable().getSelectedRowContent()[0] },								
				new String[]{	"PATNAME", "PATNO", "EXAMNAME", 
								"DOCCODE", "EDRNAME", "ECHTITLEF", "ECHTITLES", "ECHTITLET", "XJBNO", "XRPDATE", 
								"USRID_P", "PATBDATE", "PATSEX", "XJBTLOC", "XJBTLOCDESC", 
								"XRPTITLE", "XRPCONTENT"
					},
				2
		);
	}
	
	private void listTableRowChange() {
		if (getListTable().getRowCount() > 0 && getListTable().getSelectedRow() >= 0) {
			String logUsr = getUserInfo().getUserID().toUpperCase();
			String rptDr = getListTable().getSelectedRowContent()[7];
			boolean isDoctor = "DR".equals(logUsr.substring(0,2));
			boolean canOpen = (!isDoctor || (rptDr.equals(logUsr.substring(2))));
			
			if("".equals(getListTable().getSelectedRowContent()[15]) && "HT002".equals(getListTable().getSelectedRowContent()[3])){ // RPTID IS NULL & only ECHO can write report 
				getAppendButton().setEnabled(true);
				getModifyButton().setEnabled(false);
				getAcceptButton().setEnabled(false);
				getPrintButton().setEnabled(false);
			}else{
				getAppendButton().setEnabled(false);
				if ("P".equals(getListTable().getSelectedRowContent()[23]) && canOpen) { // Draft
					getModifyButton().setEnabled(true); // view, edit
					getAcceptButton().setEnabled(true); // approve
					getPrintButton().setEnabled(false);
				}else if("A".equals(getListTable().getSelectedRowContent()[23]) && canOpen){ // Approved
					getModifyButton().setEnabled(true); // view, reopen
					getAcceptButton().setEnabled(false); 
					getPrintButton().setEnabled(true); // print report
				}else{
					getModifyButton().setEnabled(false);
					getAcceptButton().setEnabled(false);
					getPrintButton().setEnabled(false);
				}
			}
		}
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected void performListPost() {
		listTableRowChange();
	}
	
	/***************************************************************************
	 * Layout Method
	 **************************************************************************/
	@Override
	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.add(getParaPanel());
			leftPanel.add(getJScrollPane());
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
			ParaPanel.setBounds(10, 10, 1000, 140);
			ParaPanel.setBorders(true);
			ParaPanel.add(getDIDesc(), null);
			ParaPanel.add(getDINo(), null);						
			ParaPanel.add(getpatNoDesc(), null);
			ParaPanel.add(getPatNo(), null);
			ParaPanel.add(getpatNameDesc(), null);
			ParaPanel.add(getpatName(), null);
			ParaPanel.add(getpatChiNameDesc(), null);
			ParaPanel.add(getpatChiName(), null);
			ParaPanel.add(getPatHKIDDesc(), null);
			ParaPanel.add(getPatHKID(), null);
			ParaPanel.add(getPatLocDesc(), null);
			ParaPanel.add(getPatLoc(), null);
			ParaPanel.add(getPatSexDesc(), null);
			ParaPanel.add(getPatSex(), null);
			ParaPanel.add(getPatAttDoctorDesc(), null);
			ParaPanel.add(getPatAttDoctor(), null);
			ParaPanel.setHeading("Criteria");
			ParaPanel.setTitle("Criteria");
			ParaPanel.add(getReportHist(), null);
			
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
        	patNo = new TextPatientNoSearch(true, true) {
				@Override
				public void onFocus() {
//					setlcFocus(0);
				};

				@Override
				public void onBlur() {
					super.onBlur();
				}

				@Override
				public void onBlurPost() {
					//isSearching = true;
					searchAction(true);
				}
			};
              patNo.setBounds(85, 40, 95, 20);
              //patNo.setShowAlertByRequest(true);
        }
        return patNo;
  }

	private LabelBase getDIDesc() {
		if (diNoDesc == null) {
			diNoDesc = new LabelBase();
			diNoDesc.setText("DI No");
			diNoDesc.setBounds(5, 10, 95, 20);
		}
		return diNoDesc;
	}

	private TextString getDINo() {
		if (diNo == null) {
			diNo = new TextString(81){
				@Override
				public void onFocus() {
//					setlcFocus(0);
				};

				@Override
				public void onBlur() {
					super.onBlur();
					searchAction(true);
				}

				/*@Override
				public void onBlurPost() {
					//isSearching = true;
					searchAction(true);
				}*/
			};
			diNo.setBounds(85, 10, 95, 20);
		}
		return diNo;
	}
	
	private LabelBase getpatNameDesc() {
		if (patNameDesc == null) {
			patNameDesc = new LabelBase();
			patNameDesc.setText("Name");
			patNameDesc.setBounds(195, 40, 95, 20);
		}
		return patNameDesc;
	}

	private TextReadOnly getpatName() {
		if (patName == null) {
			patName = new TextReadOnly();
			patName.setBounds(305, 40, 150, 20);
			patName.setEditable(false);
		}
		return patName;
	}

	private LabelBase getpatChiNameDesc() {
		if (patChiNameDesc == null) {
			patChiNameDesc = new LabelBase();
			patChiNameDesc.setText("Chi. Name");
			patChiNameDesc.setBounds(480, 40, 95, 20);
		}
		return patChiNameDesc;
	}

	private TextReadOnly getpatChiName() {
		if (patChiName == null) {
			patChiName = new TextReadOnly();
			patChiName.setBounds(590, 40, 150, 20);
			patChiName.setEditable(false);
		}
		return patChiName;
	}
	
	private LabelBase getPatHKIDDesc() {
		if (patHKIDDesc == null) {
			patHKIDDesc = new LabelBase();
			patHKIDDesc.setText("HKID");
			patHKIDDesc.setBounds(5, 70, 95, 20);
		}
		return patHKIDDesc;
	}
	
	private TextReadOnly getPatHKID() {
		if (patHKID == null) {
			patHKID = new TextReadOnly();
			patHKID.setBounds(85, 70, 95, 20);
			patHKID.setEditable(false);
		}
		return patHKID;
	}
	
	private LabelBase getPatSexDesc() {
		if (patSexDesc == null) {
			patSexDesc = new LabelBase();
			patSexDesc.setText("Sex");
			patSexDesc.setBounds(195, 70, 95, 20);
		}
		return patSexDesc;
	}	

	private TextReadOnly getPatSex() {
		if (patSex == null) {
			patSex = new TextReadOnly();
			patSex.setBounds(305, 70, 150, 20);
			patSex.setEditable(false);
		}
		return patSex;
	}

	
	private LabelBase getPatLocDesc() {
		if (patLocDesc == null) {
			patLocDesc = new LabelBase();
			patLocDesc.setText("Location");
			patLocDesc.setBounds(195, 100, 95, 20);
		}
		return patLocDesc;
	}

	private TextReadOnly getPatLoc() {
		if (patLoc == null) {
			patLoc = new TextReadOnly();
			patLoc.setBounds(305, 100, 150, 20);
			patLoc.setEditable(false);
		}
		return patLoc;
	}
	
	private LabelBase getPatAttDoctorDesc() {
		if (patAttDoctorDesc == null) {
			patAttDoctorDesc = new LabelBase();
			patAttDoctorDesc.setText("Att. Doctor");
			patAttDoctorDesc.setBounds(5, 100, 95, 20);
		}
		return patAttDoctorDesc;
	}

	private TextReadOnly getPatAttDoctor() {
		if (patAttDoctor == null) {
			patAttDoctor = new TextReadOnly();
			patAttDoctor.setBounds(85, 100, 95, 20);
			patAttDoctor.setEditable(false);
		}
		return patAttDoctor;
	}

	private TextReadOnly getExamCount() {
		if (examCount == null) {
			examCount = new TextReadOnly();
			examCount.setBounds(80, 5, 73, 20);
		}
		return examCount;
	}

  //////////////////////////////////

	protected void showReportEditor() {
		setParameter("PatNo", getPatNo().getText());
		setParameter("PatName", getpatName().getText());
		setParameter("ExamName", getListTable().getSelectedRowContent()[4]);
		setParameter("DINo", getListTable().getSelectedRowContent()[2]);
		setParameter("XRGID", getListTable().getSelectedRowContent()[0]);
		
		showPanel(new DIECGReportEditor());// change to "DI Report Editor"
	}
	
	private ButtonBase getReportHist() {
		if (reportHistory == null) {
			reportHistory = new ButtonBase() {
				@Override
				public void onClick() {
					getDIReportHist().showDialog(getListTable().getSelectedRowContent()[0]);
				}
				
			};
			reportHistory.setText("Report History", 'H');
			reportHistory.setBounds(5, 600, 100, 20);
		}
		return reportHistory;
	}
	
	private DlgDIReportHist getDIReportHist() {
		if (dlgDiReportHist == null) {
			dlgDiReportHist = new DlgDIReportHist(getMainFrame());
		}
		return dlgDiReportHist;
	}

}