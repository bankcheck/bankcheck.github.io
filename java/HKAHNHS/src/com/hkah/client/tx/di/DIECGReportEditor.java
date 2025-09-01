package com.hkah.client.tx.di;

import java.util.Date;
import java.util.HashMap;
import java.util.List;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.MessageBox;
import com.google.gwt.i18n.client.DateTimeFormat;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.dialog.DlgDIReportReopen;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.dialog.DlgDIReportApprove;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.radiobutton.RadioButtonBase;
import com.hkah.client.layout.table.GeneralGridCellRenderer;
import com.hkah.client.layout.textfield.TextAreaBase;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DIECGReportEditor extends MasterPanel {

	public DIECGReportEditor(BasePanel panelFrom) {
		super();
		//this.panelFrom = panelFrom;
	}

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.ECGREPORTEDITOR_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.ECGREPORTEDITOR_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] { "Report" };
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] { 100 };
	}

	/* >>> ~4b~ Set Table Column Cell Renderer ============================ <<< */
	protected GeneralGridCellRenderer[] getColumnRenderer() {
		return new GeneralGridCellRenderer[] { null };
	}

	private BasePanel rightPanel = null;
	private BasePanel leftPanel = null;

	private BasePanel ParaPanel = null;

	private LabelBase PatNoDesc = null;
	private TextReadOnly PatNo = null;
	private LabelBase PatNameDesc = null;
	private TextReadOnly PatName = null;
	private LabelBase DOBDesc = null;
	private TextReadOnly DOB = null;
	private LabelBase GenderDesc = null;
	private TextReadOnly Gender = null;
	private LabelBase ExamNameDesc = null;
	private TextReadOnly ExamName = null;
	private LabelBase LocDesc = null;
	private TextReadOnly Loc = null;
	private LabelBase DINoDesc = null;
	private TextReadOnly DINo = null;
	private LabelBase ReportDateDesc = null;
	private TextReadOnly ReportDate = null;

//  panel 2
	private BasePanel ParaPanel2 = null;
	private LabelBase reportByDrDesc = null;
	private ComboBoxBase reportByDr = null;
	private LabelBase performedByDesc = null;
	private ComboBoxBase performedBy = null;
	private LabelBase reportTitleDesc = null;
	private TextString reportTitle = null;
	private RadioButtonBase reportDefault = null;
	private RadioButtonBase reportSaved = null;

	private TextAreaBase ReportEditor = null;

	private ButtonBase SaveReport = null;
	private ButtonBase logReport = null;
	private LabelBase CountDesc = null;
	private TextReadOnly Count = null;

	private String varRptNo = null;
	private String varXRGID = null;
	private String varPatNo = null;
	private String varDINo = null;
	private String varPatName = null;
	private String varExamName = null;
	private String varRefDr = null;
	private String varRptDate = null;

	private String varReportDr = null;
	private String varReportTitle = null;
	private String varPerformedBy = null;
	private String varApproveBy = null;
	private String varApproveDate = null;
	private String varVerNo = null;
	private String varContent = null;
	
	
	private String report = null;  
	private DlgDIReportApprove dlgDiReportApprove = null;
	private DlgDIReportReopen dlgDiReportReopen = null;
	
	/**
	 * This method initializes
	 * 
	 */
	public DIECGReportEditor() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setDIinfo();
		setNoGetDB(true);
		setLeftAlignPanel();
		getJScrollPane().setBounds(10, 145, 1000, 352);
		//searchAction();
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		setReportInfo();
		setPatInfo(getParameter("XRGID"));
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public Component getDefaultFocusComponent() {
		return getReportByDr();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {
	}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {
		getReportByDr().setEnabled(false);
		getPerformedBy().setEnabled(false);
		getEditor().setEnabled(true);
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
		return null;
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

	/* >>> ~15~ Set Fetch Output Results ============================== <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {
	}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return new String[] {
				report,
				varXRGID,
				varRptNo,
				getReportByDr().getText(),
				getPerformedBy().getText(),
				varExamName,
				getReportDate().getText(),
				varVerNo,
				getEditor().getText(),
				getUserInfo().getUserID()
		};
	}

	/* >>> ~16.1~ Set Action Output Parameters =========================== <<< */
	@Override
	protected void getNewOutputValue(String returnValue) {
		varRptNo = returnValue;
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	private void setDIinfo() {
		QueryUtil.executeMasterBrowse(getUserInfo(), "DIINFO", new String[] { "DIDOC", null },
				new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							getReportByDr().removeAllItems();
							List<String[]> results = mQueue.getContentAsArray();
							for (String[] r : results) {
								reportByDr.addItem(r[0], r[1]);
								reportByDr.setShowKey(true);
							}
						} else {
							getReportByDr().removeAllItems();
						}
					}
				});
		QueryUtil.executeMasterBrowse(getUserInfo(), "DIINFO", new String[] { "DIUSER", null },
				new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							getPerformedBy().removeAllItems();
							List<String[]> results = mQueue.getContentAsArray();
							for (String[] r : results) {
								performedBy.addItem(r[0]);
							}
						} else {
							getPerformedBy().removeAllItems();
						}
					}
				});
	}
	
	private void setReportInfo() {
		varPatNo = getParameter("PatNo");
		varPatName = getParameter("PatName");
		varExamName = getParameter("ExamName");
		varDINo = getParameter("DINo");
		varXRGID = getParameter("XRGID");
		
		getPatNo().setText(varPatNo);
		getPatName().setText(varPatName);
		getExamName().setText(varExamName);
		getDINo().setText(varDINo);
		
		QueryUtil.executeMasterBrowse(getUserInfo(), getTxCode(), new String[] { "INFO", varXRGID },
				new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							varRptDate = mQueue.getContentField()[0];
							varReportDr = mQueue.getContentField()[1];
							varReportTitle = mQueue.getContentField()[2];
							varPerformedBy = mQueue.getContentField()[3];
							varApproveBy = mQueue.getContentField()[6];
							varApproveDate = mQueue.getContentField()[8];
							varVerNo = mQueue.getContentField()[10];
							varContent = mQueue.getContentField()[11];
							varRptNo = mQueue.getContentField()[9];
							
							getReportDate().setText(varRptDate);
							getReportByDr().setText(varReportDr);
							//getReportTitle().setText(varReportTitle);
							getPerformedBy().setText(varPerformedBy);
							getEditor().setText(varContent);
							
							if("A".equals(mQueue.getContentField()[5])){
								enableButton("LOCK");
							}else{
								enableButton("EDIT");
							}
						}else{
							enableButton("NEW");
							setDefaultData();
						}
					}
				});		
	}
	
	private void setDefaultData(){
		varVerNo = "1";
		String logUsr = getUserInfo().getUserID().toUpperCase();
		if ("DR".equals(logUsr.substring(0,2))){
			getReportByDr().setText(logUsr.substring(2));
		}
		getPerformedBy().setText("OPD");
		getReportDate().setText(DateTimeFormat.getFormat("dd/MM/yyyy HH:mm:ss").format(new Date()));
	}
	
	private void setPatInfo(String xrgid){
		QueryUtil.executeMasterFetch(getUserInfo(), "ECHOREPORTINFO", new String[] { xrgid },
				new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {							
							getPatName().setText(mQueue.getContentField()[0]);
							getGender().setText(mQueue.getContentField()[5]);
							getDOB().setText(mQueue.getContentField()[4]);
							String room = "O".equals(mQueue.getContentField()[6])?"Outpatient" : mQueue.getContentField()[6];
							room += mQueue.getContentField()[7].length() > 0 ?"-" + mQueue.getContentField()[7]: "";
							getLoc().setText(room);
						}
					}
				});
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/
	@Override
	protected void enableButton(String mode) {
		if(mode == null){
			return;
		}
		report = mode;

		// disable all button
		disableButton();

		// getAppendButton().setEnabled(true); // New
		// getSearchButton().setEnabled(true); // Search
		// getDeleteButton().setEnabled(true); // Delete
		// getSaveButton().setEnabled(true); // Save
		// getAcceptButton().setEnabled(true); // Accept
		// getCancelButton().setEnabled(true); // Cancel
		// getClearButton().setEnabled(true); // Clear
		// getPrintButton().setEnabled(true); // Print

		if ("LOCK".equals(mode)) {
			getEditor().setEditableForever(false);
			getReportByDr().setEditableForever(false);
			getPerformedBy().setEditableForever(false);
			//getReportTitle().setEnabled(false);
			
			getModifyButton().setEnabled(true);
			getPrintButton().setEnabled(true);
		}else if ("EDIT".equals(mode)) {
			getEditor().setEnabled(true);
			getReportByDr().setEnabled(true);
			getPerformedBy().setEnabled(true);
			//getReportTitle().setEnabled(true);
			
			getSaveButton().setEnabled(true);
			getAcceptButton().setEnabled(true);
			getClearButton().setEnabled(true);
		}
		else if ("NEW".equals(mode)) {
			getEditor().setEnabled(false);
			getReportByDr().setEnabled(true);
			getPerformedBy().setEnabled(true);
			//getReportTitle().setEnabled(true);
			
			getAppendButton().setEnabled(true);
			getClearButton().setEnabled(true);
		}
	}
	
	@Override
	public void appendAction() {
		if (!getReportByDr().isEmpty() && !getPerformedBy().isEmpty()) {
			QueryUtil.executeMasterAction(getUserInfo(), getTxCode(), QueryUtil.ACTION_APPEND, getActionInputParamaters(),
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						getNewOutputValue(mQueue.getReturnCode());
						String rptTemp = mQueue.getReturnMsg();
						if("null".equals(rptTemp)){
							getEditor().setText("");
						}else{
							getEditor().setText(rptTemp);
						}
						enableButton("EDIT");
					} else {
						Factory.getInstance().addErrorMessage(mQueue);
						if (mQueue.getContentField().length >= 2) {
							String msg = mQueue.getContentField()[1];
							if (msg != null && !"".equals(msg.trim())) {
								Factory.getInstance().addSystemMessage(msg);
							}
						}
					}
				}
			});
		} else {
			MessageBox mb = MessageBoxBase.info("Error", "Please enter the information required.", null);
		}
	}

	@Override
	public void modifyAction() {
		if("LOCK".equals(report)){
			getDIReportReopen().showDialog(
					varXRGID,
					varRptNo,
					getReportByDr().getText()
				);
		}
		if (!getReportByDr().isEmpty() && !getPerformedBy().isEmpty()) {
			super.appendAction();
		} else {
			MessageBox mb = MessageBoxBase.info("Error", "Please enter the information required.", null);
		}
	}
	
	private DlgDIReportReopen getDIReportReopen() {
		if (dlgDiReportReopen == null) {
			dlgDiReportReopen = new DlgDIReportReopen(getMainFrame()){
				@Override
				public void post(boolean success) {
					// TODO Auto-generated method stub
					if(success){
						enableButton("EDIT");
					}
					dispose();
				}
			};

		}
		return dlgDiReportReopen;
	}
	

	@Override
	public void saveAction() {
		QueryUtil.executeMasterAction(getUserInfo(), getTxCode(), QueryUtil.ACTION_MODIFY, getActionInputParamaters(),
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					String rptTemp = mQueue.getReturnMsg();
					if("null".equals(rptTemp)){
						getEditor().setText("");
					}else{
						getEditor().setText(rptTemp);
					}
					Factory.getInstance().addSystemMessage("Report updated.");
					enableButton("EDIT");
				} else {
					Factory.getInstance().addErrorMessage(mQueue);
					if (mQueue.getContentField().length >= 2) {
						String msg = mQueue.getContentField()[1];
						if (msg != null && !"".equals(msg.trim())) {
							Factory.getInstance().addSystemMessage(msg);
						}
					}
				}
			}
		});
	}
	
	@Override
	public void acceptAction() {
		saveAction();
		getDIReportApprove().showDialog(
			varXRGID,
			varRptNo,
			getReportByDr().getText()
		);
	}
	
	private DlgDIReportApprove getDIReportApprove() {
		if (dlgDiReportApprove == null) {
			dlgDiReportApprove = new DlgDIReportApprove(getMainFrame()){
				@Override
				public void post(boolean success) {
					// TODO Auto-generated method stub
					if(success){
						enableButton("LOCK");
					}
					dispose();
				}
			};
		}
		return dlgDiReportApprove;
	}

	@Override
	public void clearAction() {
		if ("EDIT".equals(report)) {
			getEditor().setText("");
		}
		else if ("NEW".equals(report)) {
			getReportByDr().setText("");
			getPerformedBy().setText("OPD");
			//getReportTitle().setText("");
		}
	}

	@Override
	public void printAction() {
		printReport();
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
				new String[]{ varXRGID },	//xrgid							
				new String[]{	"PATNAME", "PATNO", "EXAMNAME", 
								"DOCCODE", "EDRNAME", "ECHTITLEF", "ECHTITLES", "ECHTITLET", "XJBNO", "XRPDATE", 
								"USRID_P", "PATBDATE", "PATSEX", "XJBTLOC", "XJBTLOCDESC", 
								"XRPTITLE", "XRPCONTENT"
					},
				2
		);
	}
	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	@Override
	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.setSize(780, 328);
			leftPanel.add(getParaPanel());
			leftPanel.add(getParaPanel2());
			leftPanel.add(getEditor());
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
			ParaPanel.setBounds(10, 10, 1000, 105);
			ParaPanel.setBorders(true);
			ParaPanel.add(getPatNoDesc(), null);
			ParaPanel.add(getPatNo(), null);
			ParaPanel.add(getPatNameDesc(), null);
			ParaPanel.add(getPatName(), null);
			ParaPanel.add(getDOBDesc(), null);
			ParaPanel.add(getDOB(), null);
			ParaPanel.add(getGenderDesc(), null);
			ParaPanel.add(getGender(), null);
			ParaPanel.add(getLocDesc(), null);
			ParaPanel.add(getLoc(), null);
		}
		return ParaPanel;
	}

	public BasePanel getParaPanel2() {
		if (ParaPanel2 == null) {
			ParaPanel2 = new BasePanel();
			ParaPanel2.setBounds(10, 130, 1000, 105);
			ParaPanel2.setBorders(true);
			ParaPanel2.add(getDINoDesc(), null);
			ParaPanel2.add(getDINo(), null);
			ParaPanel2.add(getReportDateDesc(), null);
			ParaPanel2.add(getReportDate(), null);
			ParaPanel2.add(getExamNameDesc(), null);
			ParaPanel2.add(getExamName(), null);
			ParaPanel2.add(getReportByDrDesc(), null);
			ParaPanel2.add(getReportByDr(), null);
			ParaPanel2.add(getPerformedByDesc(), null);
			ParaPanel2.add(getPerformedBy(), null);
			//ParaPanel2.add(getReportTitleDesc(), null);
			//ParaPanel2.add(getReportTitle(), null);
		}
		return ParaPanel2;
	}
	
	private LabelBase getPatNoDesc() {
		if (PatNoDesc == null) {
			PatNoDesc = new LabelBase();
			PatNoDesc.setText("Patient No.");
			PatNoDesc.setBounds(10, 10, 95, 20);
		}
		return PatNoDesc;
	}

	private TextReadOnly getPatNo() {
		if (PatNo == null) {
			PatNo = new TextReadOnly();
			PatNo.setBounds(105, 10, 240, 20);
		}
		return PatNo;
	}

	private LabelBase getPatNameDesc() {
		if (PatNameDesc == null) {
			PatNameDesc = new LabelBase();
			PatNameDesc.setText("Patient Name");
			PatNameDesc.setBounds(10, 40, 95, 20);
		}
		return PatNameDesc;
	}

	private TextReadOnly getPatName() {
		if (PatName == null) {
			PatName = new TextReadOnly();
			PatName.setBounds(105, 40, 240, 20);
		}
		return PatName;
	}
	
	private LabelBase getGenderDesc() {
		if (GenderDesc == null) {
			GenderDesc = new LabelBase();
			GenderDesc.setText("Gender");
			GenderDesc.setBounds(420, 40, 95, 20);
		}
		return GenderDesc;
	}

	private TextReadOnly getGender() {
		if (Gender == null) {
			Gender = new TextReadOnly();
			Gender.setBounds(505, 40, 240, 20);
		}
		return Gender;
	}
	
	private LabelBase getDOBDesc() {
		if (DOBDesc == null) {
			DOBDesc = new LabelBase();
			DOBDesc.setText("Date of Birth");
			DOBDesc.setBounds(10, 70, 95, 20);
		}
		return DOBDesc;
	}

	private TextReadOnly getDOB() {
		if (DOB == null) {
			DOB = new TextReadOnly();
			DOB.setBounds(105, 70, 240, 20);
		}
		return DOB;
	}

	private LabelBase getLocDesc() {
		if (LocDesc == null) {
			LocDesc = new LabelBase();
			LocDesc.setText("Room No");
			LocDesc.setBounds(420, 70, 95, 20);
		}
		return LocDesc;
	}

	private TextReadOnly getLoc() {
		if (Loc == null) {
			Loc = new TextReadOnly();
			Loc.setBounds(505, 70, 240, 20);
		}
		return Loc;
	}

	private LabelBase getDINoDesc() {
		if (DINoDesc == null) {
			DINoDesc = new LabelBase();
			DINoDesc.setText("DI No.");
			DINoDesc.setBounds(10, 10, 95, 20);
		}
		return DINoDesc;
	}

	private TextReadOnly getDINo() {
		if (DINo == null) {
			DINo = new TextReadOnly();
			DINo.setBounds(105, 10, 240, 20);
		}
		return DINo;
	}
	
	private LabelBase getReportDateDesc() {
		if (ReportDateDesc == null) {
			ReportDateDesc = new LabelBase();
			ReportDateDesc.setText("Report Date");
			ReportDateDesc.setBounds(420, 10, 95, 20);
		}
		return ReportDateDesc;
	}

	private TextReadOnly getReportDate() {
		if (ReportDate == null) {
			ReportDate = new TextReadOnly();
			ReportDate.setBounds(505, 10, 240, 20);
		}
		return ReportDate;
	}

	private LabelBase getExamNameDesc() {
		if (ExamNameDesc == null) {
			ExamNameDesc = new LabelBase();
			ExamNameDesc.setText("Exam Name");
			ExamNameDesc.setBounds(10, 40, 95, 20);
		}
		return ExamNameDesc;
	}

	private TextReadOnly getExamName() {
		if (ExamName == null) {
			ExamName = new TextReadOnly();
			ExamName.setBounds(105, 40, 240, 20);
		}
		return ExamName;
	}
	private LabelBase getReportByDrDesc() {
		if (reportByDrDesc == null) {
			reportByDrDesc = new LabelBase();
			reportByDrDesc.setText("Report by Dr.");
			reportByDrDesc.setBounds(10, 70, 95, 20);
		}
		return reportByDrDesc;
	}

	private ComboBoxBase getReportByDr() {
		if (reportByDr == null) {
			reportByDr = new ComboBoxBase(){
				@Override
				public void onClick() {
					if(varRptNo != null && varRptNo.length() > 0){
						Factory.getInstance().isConfirmYesNoDialog("Change Doctor",
								"Are you sure you want to update the doctor ? <br/><br/><< All unsaved content will be deleted after changing the report doctor. >>",
								new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									saveAction();
									varReportDr = getReportByDr().getText();
								}else{
									getReportByDr().setText(varReportDr);
								}
							}
						});
					}
				}
			};
			reportByDr.setBounds(105, 70, 240, 20);
		}
		return reportByDr;
	}

	private LabelBase getPerformedByDesc() {
		if (performedByDesc == null) {
			performedByDesc = new LabelBase();
			performedByDesc.setText("Performed by");
			performedByDesc.setBounds(420, 70, 95, 20);
		}
		return performedByDesc;
	}

	private ComboBoxBase getPerformedBy() {
		if (performedBy == null) {
			performedBy = new ComboBoxBase();
			performedBy.setBounds(505, 70, 240, 20);
		}
		return performedBy;
	}

/*	private LabelBase getReportTitleDesc() {
		if (reportTitleDesc == null) {
			reportTitleDesc = new LabelBase();
			reportTitleDesc.setText("Report Title");
			reportTitleDesc.setBounds(5, 35, 150, 20);
		}
		return reportTitleDesc;
	}

	private TextString getReportTitle() {
		if (reportTitle == null) {
			reportTitle = new TextString(81);
			reportTitle.setBounds(85, 35, 550, 20);
		}
		return reportTitle;
	}
*/
	
	private TextAreaBase getEditor() {
		if (ReportEditor == null) {
			ReportEditor = new TextAreaBase(4000);
			ReportEditor.setBounds(10, 250, 1000, 500);
			ReportEditor.setStyleName("biggerFont");
		}
		return ReportEditor;
	}

}