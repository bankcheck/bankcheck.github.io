	package com.hkah.client.tx.registration;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboDest;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextDateTime;
import com.hkah.client.layout.textfield.TextDoctorSearch;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.layout.textfield.TextSubDiseaseSearch;
import com.hkah.client.layout.textfield.TextSubReasonSearch;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.tx.report.LabSummaryReport;
import com.hkah.client.util.AppStmtUtil;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.PanelUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class RegistrationDischarge extends MasterPanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.REGDISCHARGE_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.REGDISCHARGE_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {};
	}

	private BasePanel rightPanel = null;
	private BasePanel leftPanel = null;
	// patient information
	private FieldSetBase patInfoPanel = null;
	private LabelBase patDesc = null;
	private TextReadOnly patNo = null;
	private TextReadOnly patName = null;
	private TextReadOnly patCName = null;
	private LabelBase patSexDesc = null;
	private TextReadOnly patSex = null;
	private LabelBase admissionByDesc = null;
	private TextReadOnly docCode_A = null;
	private TextReadOnly docName_A = null;
	private TextReadOnly docCName_A = null;
	private LabelBase onDateDesc = null;
	private TextReadOnly onDate = null;
	private LabelBase treatmentByDesc = null;
	private TextReadOnly docCode = null;
	private TextReadOnly docName = null;
	private TextReadOnly docCName = null;
	private LabelBase patknameDesc = null;
	private TextReadOnly patkname = null;
	private LabelBase patkrelaDesc = null;
	private TextReadOnly patkrela = null;
	private LabelBase  patkhtelDesc = null;
	private TextReadOnly patkhtel = null;
	private LabelBase  patkptelDesc = null;
	private TextReadOnly patkptel = null;
	private LabelBase  patkotelDesc = null;
	private TextReadOnly patkotel = null;
	private LabelBase patmtelDesc = null;
	private TextReadOnly patkmtel = null;
	private ButtonBase discharge = null;
	// patient discharge
	private FieldSetBase patDischgPanel = null;
	private LabelBase dischargerByDesc = null;
	private TextDoctorSearch dischgDocCode = null;
	private TextReadOnly dischgDocName = null;
	private LabelBase dischgOnDateDesc = null;
	private TextDateTime dischgOnDate = null;
	private LabelBase  specailtyDesc = null;
	private TextReadOnly specCode = null;
	private TextReadOnly specName = null;
	private CheckBoxBase dischargeWithMother = null;
	private LabelBase dischargeWithMotherDesc = null;
	private CheckBoxBase updAllBabyInf = null;
	private LabelBase updAllBabyInfDesc = null;
	private LabelBase destinationDesc = null;
	private ComboDest destination = null;
	// medical record
	private FieldSetBase medRcdPanel = null;
	private LabelBase diseaseDesc = null;
	private TextSubDiseaseSearch sdsCode = null;
	private TextReadOnly sdsName = null;
	private LabelBase reasonDesc = null;
	private TextSubReasonSearch srsnCode = null;
	private TextReadOnly srsnName = null;
	private LabelBase stillBornDesc = null;
	private TextString stillBorn = null;

//	private DlgPatientAlert dlgPatientAlert = null;

	private String inpid = "";
	private Date dDate = null;
	private String bNewDischarge = "0";
	private String dDischargeDate = "";
	private String bedcode = "";
	private String currSlpNo = null;
	private String currRegID = null;
	private String callForm = null;
	private boolean hasLabReport = false;

	/**
	 * This method initializes
	 *
	 */
	public RegistrationDischarge() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		//setLeftAlignPanel();
		setRightAlignPanel();
		getJScrollPane().setBounds(15, 25, 725, 290);

		getDischargeWithMother().setVisible(false);
		getDischargeWithMotherDesc().setVisible(false);

		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		currSlpNo = getParameter("SlpNo");
		currRegID = getParameter("RegID");
		callForm = getParameter("CallForm");

		resetParameter("SlpNo");
		resetParameter("RegID");

		disableButton();
//		getSearchButton().setEnabled(true);
		PanelUtil.setAllFieldsEditable(getRightPanel(), true);

		QueryUtil.executeMasterFetch(getUserInfo(), getTxCode(), getFetchInputParameters(),
				new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							getFetchOutputValues(mQueue.getContentField());
						} else {
							exitPanel();
						}
					}
				});

		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] {"REG", "inpid,to_char(regdate,'dd/MM/yyyy hh24:mi:ss'), regnb", " regid="+currRegID},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					 inpid=mQueue.getContentField()[0];
					 if (inpid == null || inpid.trim().length() == 0) {
						 getOnDate().resetText();
						 getDischarge().setEnabled(false);
					 } else {
						 getOnDate().setText(mQueue.getContentField()[1]);
					 }
				 } else {
					exitPanel();
				 }
			}
		});
		isExistLabReport();
		getPatDischgPanel().setVisible(false);
		getMedRcdPanel().setVisible(false);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return null;
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
		 return new String[] {
				currRegID
		};
	}

	@Override
	public void searchAction() {
		triggerSearchField();
	}

	/**
	 * action when click save button
	 */

	public void saveAction() {
		if (getSaveButton().isEnabled()) {
			actionValidation(ACTION_SAVE);
		}
	}
	@Override
	public void rePostAction() {
		// refresh search
		if ("".equals(getParameter("repostFrom"))) {
			searchAction(false);
		}
			
	}
	
	protected void openLabReport() {
		showPanel(new LabSummaryReport(){
			@Override
			public String getCommandLine() {
				return " "+Factory.getInstance().getUserInfo().getUserID()+
					   " "+getPatNo().getText().trim()+					   
					   " "+("".equals(getOnDate().getText())?
							   getMainFrame().getServerDate():getOnDate().getText().trim().substring(0, 10))+							 
					   " "+("".equals(getDischgOnDate().getText())?
							   getMainFrame().getServerDate():getDischgOnDate().getText().trim().substring(0, 10));
			}
			@Override
			public boolean preAction() {
				setParameter("repostFrom", "LAB");
				return super.preAction();
			}
			@Override
			public void postAction() {
				super.postAction();
				resetParameter("repostFrom");
				exitPanel();
			}
		});
	}
	
	protected boolean isExistLabReport() {
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] {
								"sliptx sx,slip s",
								"COUNT(1)",
								"s.slpno = sx.slpno AND s.SlpNo ='"+currSlpNo+"' AND sx.dsccode='CL' "+
								"and  SX.STNSTS IN ('N','A') and s.slptype = 'I'"
							},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					hasLabReport =  !"0".equals(mQueue.getContentField()[0]);
				} 
			}
		});
		return hasLabReport;
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {
		if (outParam!=null&&outParam.length>0) {
			getPatNo().setText(outParam[0]);
			getPatName().setText(outParam[1]);
			getPatCName().setText(outParam[2]);
			getPatSex().setText(outParam[3]);
			getDocCode_A().setText(outParam[4]);
			getDocName_A().setText(outParam[5]);
			getDocCName_A().setText(outParam[6]);
			//getOnDate().setText(outParam[7]);
			getDocCode().setText(outParam[8]);
			getDocName().setText(outParam[10]);
			getDocCName().setText(outParam[9]);
			getPatkname().setText(outParam[11]);
			getPatkrela().setText(outParam[12]);
			getPatkhtel().setText(outParam[13]);
			getPatkptel().setText(outParam[14]);
			getPatkotel().setText(outParam[15]);
			getPatkmtel().setText(outParam[16]);
		}
	}

	/* >>> ~15~ Set Fetch Output Results ============================== <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return new String[] {};
	}

	/* >>> ~16.1~ Set Action Output Parameters =========================== <<< */
	@Override
	protected void getNewOutputValue(String returnValue) {}

	@Override
	protected void actionValidationReady(final String actionType, boolean isValidationReady) {
		if (isValidationReady) {
			MessageBoxBase.confirm(MSG_PBA_SYSTEM, "Update the discharge information?",
					new Listener<MessageBoxEvent>() {
				@Override
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						getSaveButton().setEnabled(false);
						getCancelButton().setEnabled(false);
						
						writeLog("Discharge", "Param", "1. inpid: "+inpid);
						writeLog("Discharge", "Param", "2. ["+inpid+"]Doc code: "+getDischgDocCode().getText().trim());
						writeLog("Discharge", "Param", "3. ["+inpid+"]disease code: "+getSdsCode().getText().trim());
						writeLog("Discharge", "Param", "4. ["+inpid+"]reason code: "+getSrsnCode().getText().trim());
						writeLog("Discharge", "Param", "5. ["+inpid+"]destination: "+getDestination().getText());
						writeLog("Discharge", "Param", "6. ["+inpid+"]still born: "+getStillBorn().getText().trim());
						writeLog("Discharge", "Param", "7. ["+inpid+"]bNewDischarge: "+bNewDischarge);
						writeLog("Discharge", "Param", "8. ["+inpid+"]Update Bed info: "+(getUpdAllBabyInf().isSelected()?"1":"0"));
						writeLog("Discharge", "Param", "9. ["+inpid+"]reg id: "+currRegID);
						writeLog("Discharge", "Param", "10. ["+inpid+"]computer name: "+CommonUtil.getComputerName());
						writeLog("Discharge", "Param", "11. ["+inpid+"]userid: "+getUserInfo().getUserID());

						QueryUtil.executeMasterAction(getUserInfo(), "PATIENTDISCHARGE",
								QueryUtil.ACTION_APPEND,
								new String[] {
												inpid,
												getDischgDocCode().getText().trim(),
												getDischgOnDate().getText().trim(),
												getSdsCode().getText().trim(),
												getSrsnCode().getText().trim(),
												getDestination().getText(),
												getStillBorn().getText().trim(),
												bNewDischarge,
												getUpdAllBabyInf().isSelected()?"1":"0",
												currRegID,
												CommonUtil.getComputerName(),
												getUserInfo().getUserID()
											},
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									if ("1".equalsIgnoreCase(bNewDischarge)) {
										QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
												new String[] {
																"reg r, inpat i, bed b, slip s, doctor d",
																"b.ROMCODE, d.DOCFNAME || ' ' || d.DOCGNAME as docname",
																"r.inpid = i.inpid and b.bedcode = i.bedcode and r.slpno = s.slpno and s.DOCCODE = d.DOCCODE and  r.RegID ="+currRegID
															},
												new MessageQueueCallBack() {
											@Override
											public void onPostSuccess(MessageQueue mQueue) {
												if (mQueue.success()) {
													String RoomNo = mQueue.getContentField()[0];
													String DocName = mQueue.getContentField()[1];

													Map<String, String> params = new HashMap<String, String>();
													params.put("Doctor Name", DocName);
													params.put("Room No", RoomNo);
													params.put("Adm. Date", getOnDate().getText().trim());
													params.put("Dischrg. Date", getDischgOnDate().getText().trim());
													getAlertCheck().checkAltAccess(
																getPatNo().getText(),
																"Inpatient Discharge",
																false, true, params);
												}
											}
										});
									}

									//process patient's dead date end
									setParameter("SUCCESSSAVEDISCHARGE", "true");

									if (!getDischgOnDate().isEmpty() &&
											"0".equalsIgnoreCase(bNewDischarge) &&
											dDischargeDate != null &&
											dDischargeDate.length() > 0 &&
											!dDischargeDate.substring(0, 10).equalsIgnoreCase(
													getDischgOnDate().getText().trim().substring(0, 10))) {
										MessageBoxBase.confirm(MSG_PBA_SYSTEM, "Discharge Date has been changed. Do you want to modify Doctor/Bed History?",
												new Listener<MessageBoxEvent>() {
											@Override
											public void handleEvent(MessageBoxEvent be) {
												if (Dialog.YES.equalsIgnoreCase(
														be.getButtonClicked().getItemId())) {
													dDischargeDate = getDischgOnDate().getText().trim();
													setParameter("PatNo", getPatNo().getText());
													setParameter("SlpNo", currSlpNo);
													setParameter("From", "regDischarge");
													setParameter("CallFrom", "regDischarge");
													showPanel(new DoctorBedTransfer(), true);
												} else {
													disableButton();
													getSearchButton().setEnabled(true);

													unlockRecord("Bed", bedcode);
													exitPanel();
												}
											}
										});
										return;
									}

									disableButton();
									getSearchButton().setEnabled(true);

									unlockRecord("Bed", bedcode);
									if (((("1".equalsIgnoreCase(bNewDischarge))||
											(!getDischgOnDate().isEmpty() && "0".equalsIgnoreCase(bNewDischarge)))
											 && hasLabReport)&& !"DEATH".equals(getDestination().getText())
											 && (HKAH_VALUE.equals(getUserInfo().getSiteCode()))) {
										openLabReport();
									} else {
										exitPanel();
									}
									if (TWAH_VALUE.equals(getUserInfo().getSiteCode())) {
										QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
												new String[] {"APPBILLS", "BILLID", "SLPNO = "+currSlpNo+" AND BILLSTS = 'N'"},
												new MessageQueueCallBack() {
											@Override
											public void onPostSuccess(MessageQueue mQueue) {
												if (mQueue.success()) {
													final String bID = mQueue.getContentField()[0];
													QueryUtil.executeMasterAction(getUserInfo(), "APPBILL_CLOSE", QueryUtil.ACTION_APPEND,
															new String[] {mQueue.getContentField()[0]},
															new MessageQueueCallBack() {
														@Override
														public void onPostSuccess(MessageQueue mQueue) {
															if (mQueue.success()) {
																//Factory.getInstance().addInformationMessage("Related Mobile Bill Closed");
															} else {
																//Factory.getInstance().addErrorMessage(mQueue, getPkgCode());
															}
														}
													});
												}
											}
										});
									}
								} else {
									if (mQueue.getReturnCode().equals("-400")) {
										Factory.getInstance().addErrorMessage(mQueue.getReturnMsg(), getDischgOnDate());
										getDischgOnDate().setText(getMainFrame().getServerDateTime());
									} else if (mQueue.getReturnCode().equals("-300")) {
										Factory.getInstance().addErrorMessage(mQueue.getReturnMsg(), getSrsnCode());
									} else if (mQueue.getReturnCode().equals("-200")) {
										Factory.getInstance().addErrorMessage(mQueue.getReturnMsg(), getSdsCode());
									} else if (mQueue.getReturnCode().equals("-100")) {
										Factory.getInstance().addErrorMessage(mQueue.getReturnMsg(), getDischgDocCode());
									} else {
										Factory.getInstance().addErrorMessage(mQueue.getReturnMsg());
									}
									getDischarge().setEnabled(true);
									getSaveButton().setEnabled(true);
									getCancelButton().setEnabled(true);
								}
							}
						});
						
						QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
								new String[] {"APPBILLS", "BILLID", "SLPNO = "+currSlpNo+" AND BILLSTS = 'N'"},
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									final String bID = mQueue.getContentField()[0];
									QueryUtil.executeMasterAction(getUserInfo(), "APPBILL_CLOSE", QueryUtil.ACTION_APPEND,
											new String[] {mQueue.getContentField()[0]},
											new MessageQueueCallBack() {
										@Override
										public void onPostSuccess(MessageQueue mQueue) {
											if (mQueue.success()) {
												//Factory.getInstance().addInformationMessage("Related Mobile Bill Closed");
												AppStmtUtil.closeSlipRegen(getPatNo().getText(), currSlpNo, bID);
											} else {
												//Factory.getInstance().addErrorMessage(mQueue, getPkgCode());
											}
										}
									});
								}
							}
						});
					}
				}
			});
		}
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(final String actionType) {
		if (!getDischgOnDate().isEmpty()) {
			boolean isdate = false;

			if (getDischgOnDate().getText().trim().indexOf(":") == -1) {
				isdate = DateTimeUtil.isDate(getDischgOnDate().getText().trim());
			} else {
				isdate = DateTimeUtil.isDateTime(getDischgOnDate().getText().trim());
			}

			if (isdate) {
				if (getDischgOnDate().getText().trim().indexOf(":") == -1) {
					dDate = DateTimeUtil.parseDate(getDischgOnDate().getText().trim());
				} else {
					dDate = DateTimeUtil.parseDateTime(getDischgOnDate().getText().trim());
				}

				boolean success = true;

				if (dDate.before(DateTimeUtil.parseDateTime(getOnDate().getText()))) {
					Factory.getInstance().addErrorMessage(
							MSG_DISCHARGE_DATE,
						"PBA-[Admission/Discharge detail]",
						getDischgOnDate());

					getDischgOnDate().setText(getMainFrame().getServerDateTime());
					actionValidationReady(actionType, false);
					success = false;
				}

				if ("DEATH".equals(getDestination().getText())) {
					if (dDate.after(DateTimeUtil.parseDateTime(getMainFrame().getServerDateTime()))) {
						Factory.getInstance().addErrorMessage(
							"Discharge date cannot be later than current date.",
							"PBA-[Admission/Discharge detail]",
							getDischgOnDate());
						getDischgOnDate().setText(getMainFrame().getServerDateTime());
						actionValidationReady(actionType, false);
						success = false;
					}
				}

				if (success) {
					if (ConstantsVariable.EMPTY_VALUE.equals(getDestination().getText().trim())) {
						Factory.getInstance().addErrorMessage(
								"Please enter Discharge Destination.",
								"PBA-[Admission/Discharge detail]",
								getDestination());
						actionValidationReady(actionType, false);
					} else {
						actionValidationReady(actionType, true);
					}
				}
			} else {
				// check destination
				Factory.getInstance().addErrorMessage(
						"Invalid Date Value.",
						"PBA-[Admission/Discharge detail]",
						getDischgOnDate());
				getDischgOnDate().setText(getMainFrame().getServerDateTime());
				actionValidationReady(actionType, false);
			}
		} else {
//			// check destination
//			if (getDestination().isEmpty() || !getDestination().isValid()) {
//				Factory.getInstance().addErrorMessage(
//						"Please enter Discharge Destination.",
//						"PBA-[Admission/Discharge detail]",
//						getDestination());
//				actionValidationReady(actionType, false);
//			} else {
				actionValidationReady(actionType, true);
//			}
		}
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	@Override
	protected void proExitPanel() {
		// for child class call
		if (callForm != null && callForm.equals("txndetail")) {
		}
		setParameter("REFRESH_SLIP_ONLY", "true");
	}

	private void lookUpRsnCode() {
		if (!getSrsnCode().isEmpty()) {
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] { "SReason", "SRsnCode, SRsnDesc", "UPPER(SRsnCode) ='" + getSrsnCode().getText().toUpperCase() + "' and SRSNNEW = -1 " },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						if (mQueue == null ||
								mQueue.getContentField().length == 0 ||
								mQueue.getContentField()[0].length() == 0) {
							Factory.getInstance()
							.addErrorMessage("Invalid Reason Code.",
								new Listener<MessageBoxEvent>() {
									@Override
									public void handleEvent(
											MessageBoxEvent be) {
										getSrsnCode().resetText();
										getSrsnName().resetText();
										getSrsnCode().focus();
									}
							});
						}

						getSrsnName().setText(mQueue.getContentField()[1]);
					} else {
						Factory.getInstance().addErrorMessage("Invalid Reason Code.",
								new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(
									MessageBoxEvent be) {
								getSrsnCode().resetText();
								getSrsnName().resetText();
								getSrsnCode().focus();
							}
						});
					}
				}
			});
		}
	}

	private void lookUpSdsCode() {
		if (!getSdsCode().isEmpty()) {
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] { "SDisease", "SdsCode, SdsDesc", "UPPER(SdsCode) ='"  + getSdsCode().getText().toUpperCase() + "' and SDSNEW = -1 "},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						if (mQueue == null ||
								mQueue.getContentField().length == 0 ||
								mQueue.getContentField()[0].length() == 0) {

							Factory.getInstance().addErrorMessage("Invalid Disease Code.",
									new Listener<MessageBoxEvent>() {
								@Override
								public void handleEvent(
										MessageBoxEvent be) {
									getSdsCode().resetText();
									getSdsName().resetText();
									getSdsCode().focus();
								}
							});
						}

						getSdsName().setText(mQueue.getContentField()[1]);
					} else {
						Factory.getInstance()
						.addErrorMessage("Invalid Disease Code.",
							new Listener<MessageBoxEvent>() {
								@Override
								public void handleEvent(
										MessageBoxEvent be) {
									getSdsCode().resetText();
									getSdsName().resetText();
									getSdsCode().focus();
								}
						});
					}
				}
			});
		}
	}

	private void lookUpDocCode() {
		if (!getDischgDocCode().isEmpty()) {
			QueryUtil.executeMasterFetch(
				getUserInfo(),
				ConstantsTx.LOOKUP_TXCODE,
				new String[] { "doctor d, spec s",
								"d.docCode, d.spccode, d.docfname || ' ' ||  d.docgname, s.spcname",
								"UPPER(doccode) ='" + getDischgDocCode().getText().toUpperCase() + "' AND s.spccode = d.spccode and docsts = '-1'"
							},
				new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							if (mQueue == null ||
									mQueue.getContentField().length == 0 ||
									mQueue.getContentField()[0].length() == 0) {
								Factory.getInstance().addErrorMessage("Invalid Doctor Code.",
										new Listener<MessageBoxEvent>() {
									@Override
									public void handleEvent(
											MessageBoxEvent be) {
										getDischgDocCode().resetText();
										getDischgDocName().resetText();
										getSpecCode().resetText();
										getSpecName().resetText();
										getDischgDocCode().focus();
									}
								});
							}

							getSpecCode().setText(mQueue.getContentField()[1]);
							getDischgDocName().setText(mQueue.getContentField()[2]);
							getSpecName().setText(mQueue.getContentField()[3]);
					} else {
						Factory.getInstance().addErrorMessage("Invalid Doctor Code.",
								new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(
									MessageBoxEvent be) {
								getDischgDocCode().resetText();
								getDischgDocName().resetText();
								getSpecCode().resetText();
								getSpecName().resetText();
								getDischgDocCode().focus();
							}
						});
					}
				}
			});
		}
	}

	// some util method start
	@Override
	public void cancelAction() {
		if (getCancelButton().isEnabled()) {
			MessageBoxBase.confirm(MSG_PBA_SYSTEM, MSG_CANCEL_WARNING,
					new Listener<MessageBoxEvent>() {
				@Override
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						// do action after click yes
						cancelYesAction();
					}
				}
			});
		}
	}

	@Override
	protected void cancelYesAction() {
		exitPanel();
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/* >>> getter methods for init the Component start from here================================== <<< */
	@Override
	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
		}
		return leftPanel;
	}

	protected BasePanel getRightPanel() {
		if (rightPanel == null) {
			rightPanel = new BasePanel();
			rightPanel.setSize(779, 460);
			rightPanel.add(getPatDischgPanel(), null);
			rightPanel.add(getPatInfoPanel(), null);
			rightPanel.add(getMedRcdPanel(), null);
		}
		return rightPanel;
	}

	// patient information
	public FieldSetBase getPatInfoPanel() {
		if (patInfoPanel == null) {
			patInfoPanel = new FieldSetBase();
			patInfoPanel.setHeading("Patient Information");
			patInfoPanel.setBounds(5, 5, 770, 190);
			patInfoPanel.add(getPatDesc(), null);
			patInfoPanel.add(getPatNo(), null);
			patInfoPanel.add(getPatName(), null);
			patInfoPanel.add(getPatCName(), null);
			patInfoPanel.add(getPatSexDesc(), null);
			patInfoPanel.add(getPatSex(), null);
			patInfoPanel.add(getAdmissionByDesc(), null);
			patInfoPanel.add(getDocCode_A(), null);
			patInfoPanel.add(getDocName_A(), null);
			patInfoPanel.add(getDocCName_A(), null);
			patInfoPanel.add(getOnDateDesc(), null);
			patInfoPanel.add(getOnDate(), null);
			patInfoPanel.add(getTreatmentByDesc(), null);
			patInfoPanel.add(getDocCode() , null);
			patInfoPanel.add(getDocName(), null);
			patInfoPanel.add(getDocCName(), null);
			patInfoPanel.add(getPatknameDesc(), null);
			patInfoPanel.add(getPatkname(), null);
			patInfoPanel.add(getPatkrelaDesc(), null);
			patInfoPanel.add(getPatkrela(), null);
			patInfoPanel.add(getPatkhtelDesc(), null);
			patInfoPanel.add(getPatkhtel(), null);
			patInfoPanel.add(getPatkptelDesc(), null);
			patInfoPanel.add(getPatkptel(), null);
			patInfoPanel.add(getPatkotelDesc(), null);
			patInfoPanel.add(getPatkotel(), null);
			patInfoPanel.add(getPatmtelDesc(), null);
			patInfoPanel.add(getPatkmtel(), null);
			patInfoPanel.add(getDischarge(), null);
		}
		return patInfoPanel;
	}

   public LabelBase getPatDesc() {
		if (patDesc == null) {
			patDesc = new LabelBase();
			patDesc.setText("Patient");
			patDesc.setBounds(5, 0, 80, 20);
		}
		return patDesc;
	}

	public TextReadOnly getPatNo() {
		if (patNo == null) {
			patNo = new TextReadOnly();
			patNo.setBounds(90, 0, 80, 20);
		}
		return patNo;
	}

	public TextReadOnly getPatName() {
		if (patName == null) {
			patName = new TextReadOnly();
			patName.setBounds(175, 0, 180, 20);
		}
		return patName;
	}

	public TextReadOnly getPatCName() {
		if (patCName == null) {
			patCName = new TextReadOnly();
			patCName.setBounds(360, 0, 120, 20);
		}
		return patCName;
	}

	public LabelBase getPatSexDesc() {
		if (patSexDesc == null) {
			patSexDesc = new LabelBase();
			patSexDesc.setText("Sex");
			patSexDesc.setBounds(495, 0, 50, 20);
		}
		return patSexDesc;
	}

	public TextReadOnly getPatSex() {
		if (patSex == null) {
			patSex = new TextReadOnly();
			patSex.setBounds(540, 0, 80, 20);
		}
		return patSex;
	}

	public LabelBase getAdmissionByDesc() {
		if (admissionByDesc == null) {
			admissionByDesc = new LabelBase();
			admissionByDesc.setText("Admission By");
			admissionByDesc.setBounds(5, 25, 80, 20);
		}
		return admissionByDesc;
	}

	public TextReadOnly getDocCode_A() {
		 if (docCode_A == null) {
			 docCode_A = new TextReadOnly();
			 docCode_A.setBounds(90, 25, 80, 20);
		}
		return docCode_A;
	}

	public TextReadOnly getDocName_A() {
		if (docName_A == null) {
			docName_A = new TextReadOnly();
			docName_A.setBounds(175, 25, 180, 20);
		}
		return docName_A;
	}

	public TextReadOnly getDocCName_A() {
		if (docCName_A == null) {
			docCName_A = new TextReadOnly();
			docCName_A.setBounds(360, 25, 120, 20);
		}
		return docCName_A;
	}

	public LabelBase getOnDateDesc() {
		if (onDateDesc == null) {
			onDateDesc = new LabelBase();
			onDateDesc.setText("On");
			onDateDesc.setBounds(495, 25, 50, 20);
		}
		return onDateDesc;
	}

	public TextReadOnly getOnDate() {
		if (onDate == null) {
			onDate = new TextReadOnly();
			onDate.setBounds(540, 25, 130, 20);
		}
		return onDate;
	}

	public LabelBase getTreatmentByDesc() {
		if (treatmentByDesc == null) {
			treatmentByDesc = new LabelBase();
			treatmentByDesc.setText("Treatment By");
			treatmentByDesc.setBounds(5, 50, 80, 20);
		}
		return treatmentByDesc;
	}

	public TextReadOnly getDocCode() {
		if (docCode == null) {
			docCode = new TextReadOnly();
			docCode.setBounds(90, 50, 80, 20);
		}
		return docCode;
	}

	public TextReadOnly getDocName() {
		if (docName == null) {
			docName = new TextReadOnly();
			docName.setBounds(175, 50, 180, 20);
		}
		return docName;
	}

	public TextReadOnly getDocCName() {
		if (docCName == null) {
			docCName = new TextReadOnly();
			docCName.setBounds(360, 50, 120, 20);
		}
		return docCName;
	}

	public LabelBase getPatknameDesc() {
		if (patknameDesc == null) {
			patknameDesc = new LabelBase();
			patknameDesc.setText("Kin Name");
			patknameDesc.setBounds(5, 85, 80, 20);
		}
		return patknameDesc;
	}

	public TextReadOnly getPatkname() {
		if (patkname == null) {
			patkname = new TextReadOnly();
			patkname.setBounds(90, 85, 180, 20);
		}
		return patkname;
	}

	public LabelBase getPatkrelaDesc() {
		if (patkrelaDesc == null) {
			patkrelaDesc = new LabelBase();
			patkrelaDesc.setText("Relation");
			patkrelaDesc.setBounds(285, 85, 80, 20);
		}
		return patkrelaDesc;
	}

	public TextReadOnly getPatkrela() {
		if (patkrela == null) {
			patkrela = new TextReadOnly();
			patkrela.setBounds(360, 85, 180, 20);
		}
		return patkrela;
	}

	public LabelBase getPatkhtelDesc() {
		if (patkhtelDesc == null) {
			patkhtelDesc = new LabelBase();
			patkhtelDesc.setText("Home Tel.");
			patkhtelDesc.setBounds(5, 110, 80, 20);
		}
		return patkhtelDesc;
	}

	public TextReadOnly getPatkhtel() {
		if (patkhtel == null) {
			patkhtel = new TextReadOnly();
			patkhtel.setBounds(90, 110, 180, 20);
		}
		return patkhtel;
	}

	public LabelBase getPatkptelDesc() {
		if (patkptelDesc == null) {
			patkptelDesc = new LabelBase();
			patkptelDesc.setText("Pager");
			patkptelDesc.setBounds(285, 110, 80, 20);
		}
		return patkptelDesc;
	}

	public TextReadOnly getPatkptel() {
		if (patkptel == null) {
			patkptel = new TextReadOnly();
			patkptel.setBounds(360, 110, 180, 20);
		}
		return patkptel;
	}

	public LabelBase getPatkotelDesc() {
		if (patkotelDesc == null) {
			patkotelDesc = new LabelBase();
			patkotelDesc.setText("Office Tel.");
			patkotelDesc.setBounds(5, 135, 80, 20);
		}
		return patkotelDesc;
	}

	public TextReadOnly getPatkotel() {
		if (patkotel == null) {
			patkotel = new TextReadOnly();
			patkotel.setBounds(90, 135, 180, 20);
		}
		return patkotel;
	}

	public LabelBase getPatmtelDesc() {
		if (patmtelDesc == null) {
			patmtelDesc = new LabelBase();
			patmtelDesc.setText("Mobile");
			patmtelDesc.setBounds(285, 135, 80, 20);
		}
		return patmtelDesc;
	}

	public TextReadOnly getPatkmtel() {
		if (patkmtel == null) {
			patkmtel = new TextReadOnly();
			patkmtel.setBounds(360, 135, 180, 20);
		}
		return patkmtel;
	}

	public ButtonBase getDischarge() {
		if (discharge == null) {
			discharge = new ButtonBase() {
				@Override
				public void onClick() {
					QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] { "Inpat", "InpDDate, doccode_d, to_char(inpddate,'dd/mm/yyyy hh24:mi:ss'), sdscode, rsncode, descode, inpsbcnt", "InpID="+inpid },
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								String InpDDate = mQueue.getContentField()[0];
								if (InpDDate == null || InpDDate.trim().length()==0) {

									bNewDischarge = "1";
									setParameter("newDischarge", "yes");

									getDischgDocCode().setText(getDocCode().getText());
									setParameter("oldDocCode", getDischgDocCode().getText().trim());
									lookUpDocCode();

									getDischgOnDate().setText(getMainFrame().getServerDateTime());

									String disPatDest = getSysParameter("DisPatDest");
									if (disPatDest != null && disPatDest.length() > 0) {
										getDestination().setText(getSysParameter("DisPatDest"));
									}
									//checkPatientAlert();
									getAlertCheck().checkAltAccess(getPatNo().getText(), "Inpatient Discharge", true, false, null);
								} else if (inpid != null && inpid.trim().length() > 0) {
									bNewDischarge = "0";
									setParameter("newDischarge", "no");

									getDischgDocCode().setText(mQueue.getContentField()[1]);
									setParameter("oldDocCode", getDischgDocCode().getText().trim());
									lookUpDocCode();

									getDischgOnDate().setText(mQueue.getContentField()[2]);
									dDischargeDate = mQueue.getContentField()[2];

									String SdsCode, SRsnCode, DesCode, SBCount;

									SdsCode = mQueue.getContentField()[3];
									SRsnCode = mQueue.getContentField()[4];
									DesCode = mQueue.getContentField()[5];
									SBCount = mQueue.getContentField()[6];

									if (SdsCode != null && SdsCode.trim().length() > 0) {
										getSdsCode().setText(SdsCode);
										lookUpSdsCode();
									}

									if (SRsnCode != null && SRsnCode.trim().length() > 0) {
										getSrsnCode().setText(SRsnCode);
										lookUpRsnCode();
									}

									if (SBCount != null && SBCount.trim().length() > 0) {
										getStillBorn().setText(SBCount);
									}

									if (DesCode != null && DesCode.trim().length() > 0) {
										getDestination().setText(DesCode);
									}
								}
								
								discharge.setEnabled(false);
								getPatDischgPanel().setVisible(true);
								getMedRcdPanel().setVisible(true);
								getSaveButton().setEnabled(true);
								getCancelButton().setEnabled(true);
							}
						}
					});
				}
			};
			discharge.setText("Discharge>>", 'D');
			discharge.setBounds(600, 135, 110, 25);
		}
		return discharge;
	}

	// patient discharge
	public FieldSetBase getPatDischgPanel() {
		if (patDischgPanel == null) {
			patDischgPanel = new FieldSetBase();
			patDischgPanel.setHeading("Patient Discharge");
			patDischgPanel.setBounds(5, 200, 770, 100);
			patDischgPanel.add(getDischargerByDesc(), null);
			patDischgPanel.add(getDischgDocCode(), null);
			patDischgPanel.add(getDischgDocName(), null);
			patDischgPanel.add(getDischgOnDateDesc(), null);
			patDischgPanel.add(getDischgOnDate(), null);
			patDischgPanel.add(getSpecailtyDesc(), null);
			patDischgPanel.add(getSpecCode(), null);
			patDischgPanel.add(getSpecName(), null);
			patDischgPanel.add(getDischargeWithMother(), null);
			patDischgPanel.add(getDischargeWithMotherDesc(), null);
			patDischgPanel.add(getUpdAllBabyInf(), null);
			patDischgPanel.add(getUpdAllBabyInfDesc(), null);
			patDischgPanel.add(getDestinationDesc(), null);
			patDischgPanel.add(getDestination(), null);
		}
		return patDischgPanel;
	}

	public LabelBase getDischargerByDesc() {
		if (dischargerByDesc == null) {
			dischargerByDesc = new LabelBase();
			dischargerByDesc.setText("Discharge By");
			dischargerByDesc.setBounds(5, 0, 80, 20);
		}
		return dischargerByDesc;
	}

	public TextDoctorSearch getDischgDocCode() {
		if (dischgDocCode == null) {
			dischgDocCode = new TextDoctorSearch() {
				public void onBlur() {
					lookUpDocCode();
			 	}
			};
			dischgDocCode.setBounds(90, 0, 80, 20);
		}
		return dischgDocCode;
	}

	public TextReadOnly getDischgDocName() {
		if (dischgDocName == null) {
			 dischgDocName = new TextReadOnly();
			 dischgDocName.setBounds(175, 0, 180, 20);
		}
		return dischgDocName;
	}

	public LabelBase getDischgOnDateDesc() {
		if (dischgOnDateDesc == null) {
			dischgOnDateDesc = new LabelBase();
			dischgOnDateDesc.setText("On");
			dischgOnDateDesc.setBounds(380, 0, 50, 20);
		}
		return dischgOnDateDesc;
	}

	public TextDateTime getDischgOnDate() {
		if (dischgOnDate == null) {
			dischgOnDate = new TextDateTime(true, true);
			dischgOnDate.setBounds(415, 0, 150, 20);
		}
		return dischgOnDate;
	}

	public CheckBoxBase getDischargeWithMother() {
		if (dischargeWithMother == null) {
			dischargeWithMother = new CheckBoxBase();
			dischargeWithMother.setBounds(550, 0, 20, 20);
		}
		return dischargeWithMother;
	}

	public LabelBase getDischargeWithMotherDesc() {
		if (dischargeWithMotherDesc == null) {
			dischargeWithMotherDesc = new LabelBase();
			dischargeWithMotherDesc.setText("Discharge with Mother");
			dischargeWithMotherDesc.setBounds(570, 0, 130, 20);
		}
		return dischargeWithMotherDesc;
	}

	public LabelBase getSpecailtyDesc() {
		if (specailtyDesc == null) {
			specailtyDesc = new LabelBase();
			specailtyDesc.setText("Specailty");
			specailtyDesc.setBounds(5, 25, 80, 20);
		}
		return specailtyDesc;
	}

	public TextReadOnly getSpecCode() {
		if (specCode == null) {
			specCode = new TextReadOnly();
			specCode.setBounds(90, 25, 80, 20);
		}
		return specCode;
	}

	public TextReadOnly getSpecName() {
		if (specName == null) {
			specName = new TextReadOnly();
			specName.setBounds(175, 25, 180, 20);
		}
		return specName;
	}

	public CheckBoxBase getUpdAllBabyInf() {
		if (updAllBabyInf == null) {
			updAllBabyInf = new CheckBoxBase();
			updAllBabyInf.setBounds(550, 25, 20, 20);
		}
		return updAllBabyInf;
	}

	public LabelBase getUpdAllBabyInfDesc() {
		if (updAllBabyInfDesc == null) {
			updAllBabyInfDesc = new LabelBase();
			updAllBabyInfDesc.setText("Update All Baby Info");
			updAllBabyInfDesc.setBounds(570, 25, 130, 20);
		}
		return updAllBabyInfDesc;
	}

	public LabelBase getDestinationDesc() {
		if (destinationDesc == null) {
			destinationDesc = new LabelBase();
			destinationDesc.setText("Destination");
			destinationDesc.setBounds(5, 50, 80, 20);
		}
		return destinationDesc;
	}

	public ComboDest getDestination() {
		if (destination == null) {
			destination = new ComboDest();
			destination.setBounds(90, 50, 265, 20);
		}
		return destination;
	}

	//  medical record
	public FieldSetBase getMedRcdPanel() {
		if (medRcdPanel == null) {
			medRcdPanel = new FieldSetBase();
			medRcdPanel.setHeading("Medical Record");
			medRcdPanel.setBounds(5, 305, 770, 80);
			medRcdPanel.add(getDiseaseDesc(), null);
			medRcdPanel.add(getSdsCode(), null);
			medRcdPanel.add(getSdsName(), null);
			medRcdPanel.add(getReasonDesc(), null);
			medRcdPanel.add(getSrsnCode(), null);
			medRcdPanel.add(getSrsnName(), null);
			medRcdPanel.add(getStillBornDesc(), null);
			medRcdPanel.add(getStillBorn(), null);
		}
		return medRcdPanel;
	}

	public LabelBase getDiseaseDesc() {
		if (diseaseDesc == null) {
			diseaseDesc = new LabelBase();
			diseaseDesc.setText("Disease");
			diseaseDesc.setBounds(5, 0, 80, 20);
		}
		return diseaseDesc;
	}

	public TextSubDiseaseSearch getSdsCode() {
		if (sdsCode == null) {
			sdsCode = new TextSubDiseaseSearch() {
				@Override
				public void checkTriggerBySearchKeyPost() {
					lookUpSdsCode();
				}

				public void onBlur() {
					lookUpSdsCode();
				}

				@Override
				public void resetText() {
					super.resetText();
					getSdsName().resetText();
				}
			};
			sdsCode.setBounds(90, 0, 80, 20);
		}
		return sdsCode;
	}

	public TextReadOnly getSdsName() {
		if (sdsName == null) {
			sdsName = new TextReadOnly();
			sdsName.setBounds(175, 0, 330, 20);
		}
		return sdsName;
	}

	public LabelBase getReasonDesc() {
		if (reasonDesc == null) {
			reasonDesc = new LabelBase();
			reasonDesc.setText("Reason");
			reasonDesc.setBounds(5, 25, 80, 20);
		}
		return reasonDesc;
	}

	public TextSubReasonSearch getSrsnCode() {
		if (srsnCode == null) {
			srsnCode = new TextSubReasonSearch() {
				@Override
				public void checkTriggerBySearchKeyPost() {
					lookUpRsnCode();
				}

				public void onBlur() {
					lookUpRsnCode();
				}

				@Override
				public void resetText() {
					super.resetText();
					getSrsnName().resetText();
				}
			};

			srsnCode.setBounds(90, 25, 80, 20);
		}
		return srsnCode;
	}

	public TextReadOnly getSrsnName() {
		if (srsnName == null) {
			srsnName = new TextReadOnly();
			srsnName.setBounds(175, 25, 330, 20);
		}
		return srsnName;
	}

	public LabelBase getStillBornDesc() {
		if (stillBornDesc == null) {
			stillBornDesc = new LabelBase();
			stillBornDesc.setText("Still Born Count");
			stillBornDesc.setBounds(540, 0, 90, 20);
		}
		return stillBornDesc;
	}

	public TextString getStillBorn() {
		if (stillBorn == null) {
			stillBorn = new TextString();
			stillBorn.setBounds(635, 0, 80, 20);
		}
		return stillBorn;
	}

	@Override
	protected boolean triggerSearchField() {
		if (getSrsnCode().isFocusOwner()) {
			getSrsnCode().checkTriggerBySearchKey();
			return true;
		} else if (getSdsCode().isFocusOwner()) {
			getSdsCode().checkTriggerBySearchKey();
			return true;
		} else {
			return false;
		}
	}
}