package com.hkah.client.layout.dialog;

import java.util.HashMap;
import java.util.Map;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.form.RadioGroup;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.radiobutton.RadioButtonBase;
import com.hkah.client.layout.textfield.TextNum;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsRegistration;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public abstract class DlgNoOfLblToBePrt extends DialogBase {
	private final static int m_frameWidth = 400;
    private final static int m_frameHeight1 = 180;
    private final static int m_frameHeight2 = 280;

    private BasePanel reprintPanel = null;
	private TextNum noToBePrinted = null;
	private LabelBase printLabel = null;
	private LabelBase patNoLabel = null;
	private RadioButtonBase smallOpt = null;
	private RadioButtonBase largeOpt = null;

	private boolean memIsInpatient = true;
	private int memMaxNoOfLbl = 0;
	private static int maxNoOfLabel = 99;
	private static int defaultNoOfLabel = 1;	
	private String memPatientNo = null;
	private String memPatname1 = null;
	private String memPatname2 = null;
	private String memPatbdate = null;
	private String memPatsex = null;
	private String memPatcname = null;
	private String memRegId = null;
	private String memRegType = null;
	private String memRegAdmDate = null;
	private boolean memAuto = false;
	private boolean showConfirm = true;
	protected final static String PATNO_LABEL = "(Patient No. patno)";
	
	private LabelBase patientTypeLabel = null;
	private LabelBase patientType = null;
	private	LabelBase regDateLabel = null;
	private	LabelBase regDate = null;
	private LabelBase admDateLabel = null;
	private LabelBase admDate = null;
	
	private RadioButtonBase printToCounter = null;
	private RadioButtonBase printToMR = null;
	
	private LabelBase isPrintTicketLblDesc = null;
	private CheckBoxBase isPrintTicketLbl = null;
	
	public DlgNoOfLblToBePrt(MainFrame owner, boolean isInpatient) {
		super(owner, OKCANCEL, m_frameWidth, (isInpatient&& Factory.getInstance().getSysParameter("2DLBLREGID").equals("Y"))?m_frameHeight2:m_frameHeight1);
//		super.setResizable(true);
		this.memIsInpatient = isInpatient;
		initialize();
	}
	
	public DlgNoOfLblToBePrt(MainFrame owner, boolean isInpatient, boolean showConfirm) {
		super(owner, OKCANCEL, m_frameWidth, (isInpatient&& Factory.getInstance().getSysParameter("2DLBLREGID").equals("Y"))?m_frameHeight2:m_frameHeight1);
//		super.setResizable(true);
		this.memIsInpatient = isInpatient;
		this.showConfirm = showConfirm;
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Print Label");
		setContentPane(getReprintPanel());
	}

	public Component getDefaultFocusComponent() {
		if (getNoToBePrinted().isEnabled()) {
			return getNoToBePrinted();
		}
		else {
			return getButtonBar().getItemByItemId(Dialog.OK);
		}
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String patNo, String regId, String regType, String regDate, boolean fromRegTab) {
		showDialog(patNo, regId, regType, regDate, false, fromRegTab);
	}

	public void showDialog(String patNo, String regId, String regType, String regDate, final boolean auto, boolean fromRegTab) {
		memPatientNo = patNo;
		memRegId = regId == null?"":regId;
		memRegType = regType == null?"":regType;
		memRegAdmDate = regDate == null?"":regDate;
		memAuto = auto;
		getSmallOpt().setVisible(memIsInpatient);
		getLargeOpt().setVisible(memIsInpatient);
		getPatNoLabel().setText(PATNO_LABEL.replaceFirst("patno", patNo == null ? "N/A" : patNo));
		setVisible(false);
		getNoToBePrinted().setEditable(true);
		getNoToBePrinted().setEnabled(true);
    	getNoToBePrinted().setRawValue(String.valueOf(defaultNoOfLabel));
    	getNoToBePrinted().setText(String.valueOf(defaultNoOfLabel));		
		
		getPrintToCounter().setVisible(fromRegTab && !memIsInpatient && 
				Factory.getInstance().getSysParameter("REGLBLMULI").equals("Y"));
		getPrintToMR().setVisible(fromRegTab && !memIsInpatient && 
				Factory.getInstance().getSysParameter("REGLBLMULI").equals("Y"));
		getPrintToCounter().setSelected(fromRegTab && !memIsInpatient && 
				Factory.getInstance().getSysParameter("REGLBLMULI").equals("Y"));
		getIsPrintTicketLabelDesc().setVisible(fromRegTab && !memIsInpatient &&
				Factory.getInstance().getSysParameter("TICKETOPT").equals("Y"));
		getIsPrintTicketLabel().setVisible(fromRegTab && !memIsInpatient &&
				Factory.getInstance().getSysParameter("TICKETOPT").equals("Y"));
		getIsPrintTicketLabel().setSelected(false);

		//update layout
		updatelayout();
		
		String maxNoOfLblStr = null;
		if (memIsInpatient) {
			if ("S".equals(getSysParameter("LABELCTYPE"))) {
				getSmallOpt().setSelected(true);
			} else {				
				getLargeOpt().setSelected(true);
			}
			if(auto){				
				maxNoOfLblStr = getSysParameter("WBLBLNO");
			}else{				
				maxNoOfLblStr = getSysParameter("2DIPGENLBN");
			}
		} else {			
			maxNoOfLblStr = getSysParameter("LblPrnNo");
		}

		try {			
			memMaxNoOfLbl = Integer.parseInt(maxNoOfLblStr);
		} catch (Exception e) {
			memMaxNoOfLbl = 0;	
			maxNoOfLblStr = ZERO_VALUE;
		}
		
		if("0".equals(maxNoOfLblStr)){
			maxNoOfLblStr = String.valueOf(defaultNoOfLabel);
		}
		
		getNoToBePrinted().setText(maxNoOfLblStr);
		
		if (Factory.getInstance().getSysParameter("2DLBLREGID").equals("Y") && !auto) {
			if (memIsInpatient) {
				getPatientType().resetText();
				getRegDate().resetText();
				getAdmDate().resetText();
				
				if (regType != null) {
					if (regType.equals(ConstantsRegistration.REG_TYPE_OUTPATIENT) && regId != null) {
						getPatientType().setText("Out-Patient");
						getRegDate().setText(regDate);
						getNoToBePrinted().setText(ZERO_VALUE);
						getNoToBePrinted().setEditable(false);
						getNoToBePrinted().setEnabled(false);
					}
					else if (regType.equals(ConstantsRegistration.REG_TYPE_DAYCASE) && regId != null) {
						getPatientType().setText("DayCase");
						getRegDate().setText(regDate);
					}
					else if (regType.equals(ConstantsRegistration.REG_TYPE_INPATIENT) && regId != null) {
						getPatientType().setText("In-Patient");
						getAdmDate().setText(regDate);
					}
				}
				else {
					getNoToBePrinted().setText(ZERO_VALUE);
					getNoToBePrinted().setEditable(false);
					getNoToBePrinted().setEnabled(false);
				}
			}
		}

		QueryUtil.executeMasterFetch(
				getUserInfo(),
				"PATIENTBYNO",
				new String[] { memPatientNo },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					memPatname1 = mQueue.getContentField()[0];
					memPatname2 = mQueue.getContentField()[1];
					memPatbdate = mQueue.getContentField()[3];
					memPatsex = mQueue.getContentField()[5];
					memPatcname = mQueue.getContentField()[6];
					if (auto) {
						doOkAction();
					} else {
						setFocusWidget(getDefaultFocusComponent());
						setVisible(true);
					}
				} else {
					post(null);
				}
			}
		});
	}

	@Override
	protected void doOkAction() {
		if (memIsInpatient) {
			label4Inpatient();
		} else {
			final int noToBePrint = Integer.valueOf(getNoToBePrinted().getText());
			if (Factory.getInstance().getUserInfo().getSiteCode().toUpperCase().equals("HKAH")) {
				int maxNoOfLabel = 0;
				try {
					maxNoOfLabel = Integer.parseInt(getSysParameter("MaxLabel"));
				} catch(Exception e) {
				}
				
				if (noToBePrint > maxNoOfLabel) {
					Factory.getInstance().addErrorMessage("It is larger than "+ String.valueOf(maxNoOfLabel)+"!");
					return;
				}
				else {
					label4Outpatient(noToBePrint);
				}
			}
			else {
				if (noToBePrint > memMaxNoOfLbl && showConfirm) {
					MessageBoxBase.confirm(ConstantsMessage.MSG_PBA_SYSTEM,
							"Excess maximum number of general label allowed. Print "
									+ memMaxNoOfLbl
									+ " label(s) instead?",
							new Listener<MessageBoxEvent>() {
						@Override
						public void handleEvent(MessageBoxEvent be) {
							if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
								label4Outpatient(memMaxNoOfLbl);
							} else {
								label4Outpatient(noToBePrint);
							}
						}
					});
				} else {
					label4Outpatient(noToBePrint);
				}
			}
		}
		post(memPatientNo);
		dispose();
	}

	@Override
	protected void doCancelAction() {
		dispose();
	}

	private String getSysParameter(String parcde) {
		return getMainFrame().getSysParameter(parcde);
	}

	protected int getDefaultMaximumNoOfLabel() {
		return memMaxNoOfLbl;
	}

	protected abstract void post(String patNo);

	private void label4Inpatient() {
		HashMap<String, String> map = new HashMap<String, String>();
		
		String newbarcode = memPatientNo + ("YES".equals(getSysParameter("ChkDigit")) ? 
												PrintingUtil.generateCheckDigit(memPatientNo).toString()+"#" : "#");
		map.put("patbdate", memPatbdate);
		map.put("patno", memPatientNo);
		map.put("patname", memPatname1 + " " + memPatname2);
		map.put("patsex", memPatsex);
		map.put("newbarcode", newbarcode);
		map.put("isasterisk", String.valueOf("YES".equals(getSysParameter("Chk*"))));
		map.put("checkDigit", PrintingUtil.generateCheckDigit(memPatientNo).toString());
		map.put("regid", memRegId);
		map.put("regType", memRegType);
		map.put("regDate", memRegAdmDate);
		map.put("showRegID", Factory.getInstance().getSysParameter("2DLBLREGID"));
		map.put("SUBREPORT_DIR", CommonUtil.getReportDir());
		//map.put("isCheckDight", getSysParameter("ChkDigit"));

		PrintingUtil.print(getSysParameter("PRTRLBLC"),
				"RptLabC_" + (getSmallOpt().isSelected()?"small":"large"),
				map, memPatcname,
				new String[]{
/*unionlbl*/	getSysParameter("IPGENLAB3"),
/*mrLbl*/		getSysParameter("IPGENLAB2"),
/*wblbl*/  		getNoToBePrinted().getText(),
				memPatientNo
			},
			new String[]{"rid", "isTwoD_1", "isTwoD_2" ,"isTwoD_3", "isTwoD_4","mrLblContent"});
	}

	protected void label4Outpatient(int noToBePrint) {
/*		
		HashMap<String, String> map1 = new HashMap<String, String>();
		map1.put("SteCode", getUserInfo().getSiteCode());
		map1.put("newbarcode", memPatientNo + ("YES".equals(getSysParameter("ChkDigit")) ? PrintingUtil.generateCheckDigit(memPatientNo).toString()+"#" : "#"));
		map1.put("isasterisk", String.valueOf("YES".equals(getSysParameter("Chk*"))));

		PrintingUtil.print(getSysParameter("PRTRLBL"),
				ConstantsTx.REGSEARCHPRINTDOBWTHNO,
				map1, null,
				new String[] {memPatientNo, String.valueOf(noToBePrint)},
				new String[] {"stecode","patno","patname","patcname","patbdate","patsex"});
*/
		final boolean isasterisk = "YES".equals(getSysParameter("Chk*"));
		final boolean isChkDigit = "YES".equals(getSysParameter("ChkDigit"));
		String tempChkDigit = "#";
		if (isChkDigit) {
			if (memPatientNo != null
				&& !"".equals(memPatientNo.trim())) {
				tempChkDigit = PrintingUtil.generateCheckDigit(memPatientNo.trim()).toString()+"#";
			}
		}
		final String checkDigit = tempChkDigit;
		if (Integer.parseInt(getSysParameter("NOPATLABEL")) > 0 &&
				Integer.parseInt(getNoToBePrinted().getText()) > 0) {
			if (Integer.parseInt(getNoToBePrinted().getText()) > getMaxNoOfLabel()) {
				Factory.getInstance().addErrorMessage("It is larger than "+ String.valueOf(getMaxNoOfLabel())+"!");
				return;
			} else {
				QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.REGSEARCHPRINTDOB,
					new String[] { memPatientNo },
					new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mq) {
							HashMap<String, String> map = new HashMap<String, String>();
							map.put("stecode", mq.getContentField()[0] + (isasterisk ? "*" : ""));
							map.put("patno", mq.getContentField()[1]);
							map.put("name", mq.getContentField()[2]);
							map.put("patcname", mq.getContentField()[3]);
							map.put("patsex", mq.getContentField()[5]);
							map.put("patno1", mq.getContentField()[1] + (isChkDigit ? checkDigit : "#"));
							map.put("patdob",mq.getContentField()[4]);

							StringBuffer mapKey = new StringBuffer();
							StringBuffer mapValue = new StringBuffer();
							String patcname = null;
							for (Map.Entry<String, String> pairs : map.entrySet()) {
								if (!"patcname".equals(pairs.getKey())) {
									mapKey.append(pairs.getKey()+"<FIELD/>");
									mapValue.append(pairs.getValue()+"<FIELD/>");
								} else {
									patcname = pairs.getValue();
								}
							}

							PrintingUtil.print(getSysParameter("PRTRLBL"),
									"RegPatientLabel",
									map, patcname,
									Integer.parseInt(getNoToBePrinted().getText()));
							}
					});
			}
		}
		dispose();		

	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/
	private void updatelayout() {
		if (memIsInpatient && Factory.getInstance().getSysParameter("2DLBLREGID").equals("Y")) {
			getPrintLabel().setBounds(5, 100, 300, 20);
			getNoToBePrinted().setBounds(5, 130, 200, 20);
			getPatNoLabel().setBounds(215, 130, 150, 25);
			getSmallOpt().setBounds(5, 160, 150, 25);
			getLargeOpt().setBounds(200, 160, 150, 25);
		}
		else {
			getPrintLabel().setBounds(5, 5, 300, 20);
			getNoToBePrinted().setBounds(5, 30, 200, 20);
			getPatNoLabel().setBounds(215, 30, 150, 25);
			getSmallOpt().setBounds(5, 60, 150, 25);
			getLargeOpt().setBounds(200, 60, 150, 25);
		}
		layout();
	}

	private BasePanel getReprintPanel() {
		if (reprintPanel == null) {
			reprintPanel = new BasePanel();
	    	RadioGroup btngrp = new RadioGroup();
	    	btngrp.add(getSmallOpt());
	    	btngrp.add(getLargeOpt());
	    	reprintPanel.add(getPrintLabel());
	    	reprintPanel.add(getNoToBePrinted());
	    	reprintPanel.add(getSmallOpt());
	    	reprintPanel.add(getLargeOpt());
	    	reprintPanel.add(getPatNoLabel());
	    	
	    	if (memIsInpatient && Factory.getInstance().getSysParameter("2DLBLREGID").equals("Y")) {
	    		reprintPanel.add(getPatientTypeLabel());
	    		reprintPanel.add(getPatientType());
	    		reprintPanel.add(getRegDateLabel());
	    		reprintPanel.add(getRegDate());
	    		reprintPanel.add(getAdmDateLabel());
	    		reprintPanel.add(getAdmDate());
	    	}
	    	RadioGroup printGrp = new RadioGroup();
	    	printGrp.add(getPrintToCounter());
	    	printGrp.add(getPrintToMR());
	    	
    		reprintPanel.add(getPrintToCounter());
	    	reprintPanel.add(getPrintToMR());
	    	reprintPanel.add(getIsPrintTicketLabelDesc());
	    	reprintPanel.add(getIsPrintTicketLabel());
	    	
			reprintPanel.setBounds(5, 5, 360, memIsInpatient && Factory.getInstance().getSysParameter("2DLBLREGID").equals("Y")?200:100);
		}
		return reprintPanel;
	}
	
	private LabelBase getPatientTypeLabel() {
		if (patientTypeLabel == null) {
			patientTypeLabel = new LabelBase();
			patientTypeLabel.setText("Patient Type: ");
			patientTypeLabel.setBounds(5, 15, 150, 20);
		}
		return patientTypeLabel;
	}
	
	private LabelBase getPatientType() {
		if (patientType == null) {
			patientType = new LabelBase();
			patientType.setBounds(160, 15, 200, 20);
		}
		return patientType;
	}
	
	private	LabelBase getRegDateLabel() {
		if (regDateLabel == null) {
			regDateLabel = new LabelBase();
			regDateLabel.setText("Registration Date: ");
			regDateLabel.setBounds(5, 40, 150, 20);
		}
		return regDateLabel;
	}
	
	private	LabelBase getRegDate() {
		if (regDate == null) {
			regDate = new LabelBase();
			regDate.setBounds(160, 40, 200, 20);
		}
		return regDate;
	}
	
	private LabelBase getAdmDateLabel() {
		if (admDateLabel == null) {
			admDateLabel = new LabelBase();
			admDateLabel.setText("Admission Date: ");
			admDateLabel.setBounds(5, 65, 150, 20);
		}
		return admDateLabel;
	}
	
	private LabelBase getAdmDate() {
		if (admDate == null) {
			admDate = new LabelBase();
			admDate.setBounds(160, 65, 200, 20);
		}
		return admDate;
	}

	public LabelBase getPrintLabel() {
		if (printLabel == null) {
			printLabel = new LabelBase();
			printLabel.setText("How many Label to be printed?");
			printLabel.setBounds(5, 5, 300, 20);
		}
		return printLabel;
	}

	private TextNum getNoToBePrinted() {
		if (noToBePrinted == null) {
			noToBePrinted = new TextNum(2, 0);
			noToBePrinted.setBounds(5, 30, 200, 20);
		}
		return noToBePrinted;
	}

	private RadioButtonBase getSmallOpt() {
		if (smallOpt == null) {
			smallOpt = new RadioButtonBase();
			smallOpt.setText("Small Label (13 rows)");
			smallOpt.setBounds(5, 60, 150, 25);
		}
		return smallOpt;
	}

	private RadioButtonBase getLargeOpt() {
		if (largeOpt == null) {
			largeOpt = new RadioButtonBase();
			largeOpt.setText("Large label (9 rows)");
			largeOpt.setBounds(200, 60, 150, 25);
		}
		return largeOpt;
	}
	
	public RadioButtonBase getPrintToCounter() {
		if (printToCounter == null) {
			printToCounter = new RadioButtonBase();
			printToCounter.setText("Print to Counter");
			printToCounter.setBounds(5, 60, 100, 25);
		}
		return printToCounter;
	}
	
	public RadioButtonBase getPrintToMR() {
		if (printToMR == null) {
			printToMR = new RadioButtonBase();
			printToMR.setText("Print to MR");
			printToMR.setBounds(120, 60, 100, 25);
		}
		return printToMR;
	}
	
	private LabelBase getIsPrintTicketLabelDesc() {
		if (isPrintTicketLblDesc == null) {
			isPrintTicketLblDesc = new LabelBase();
			isPrintTicketLblDesc.setText("Ticket Label Only");
			isPrintTicketLblDesc.setBounds(275, 60, 80, 25);
		}
		return isPrintTicketLblDesc;
	}
	
	public CheckBoxBase getIsPrintTicketLabel() {
		if (isPrintTicketLbl == null) {
			isPrintTicketLbl = new CheckBoxBase();
			isPrintTicketLbl.setText("Ticket Label Only");
			isPrintTicketLbl.setBounds(240, 60, 30, 25);
		}
		return isPrintTicketLbl;
	}
	
	private LabelBase getPatNoLabel() {
		if (patNoLabel == null) {
			patNoLabel = new LabelBase();
			patNoLabel.setText("(Patient No.");
			patNoLabel.setBounds(215, 30, 150, 25);
		}
		return patNoLabel;
	}
	
	public boolean getAutoPrint() {
		return memAuto;
	}
	
	@Override
	protected void afterShow() {
		super.afterShow();
		getDefaultFocusComponent().focus();
	}
	
	/**
	 * @return the maxNoOfLabel
	 */
	public static int getMaxNoOfLabel() {
		return maxNoOfLabel;
	}	
}