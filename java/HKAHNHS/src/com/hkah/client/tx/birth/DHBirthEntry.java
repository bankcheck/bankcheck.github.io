package com.hkah.client.tx.birth;

import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboMTravelDocType;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextNum;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.ActionPanel;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.PanelUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DHBirthEntry extends ActionPanel {

	private static final String NOT_CONFIRMED = "N";
	private static final String MANUAL = "M";

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.DHBIRTHLOG_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.DHBIRTHLOG_TITLE;
	}

	private BasePanel actionPanel = null;

	private BasePanel ParaPanel = null;
	private LabelBase BBPatNoDesc = null;
	private TextString MDNo = null;
	private LabelBase ChildEverBornAliveDesc = null;
	private TextDate BBDOB = null;
	private LabelBase MalformationDetectedDesc = null;
	private LabelBase MotherSlipNoDesc = null;
	private LabelBase MotherPatNoDesc = null;
	private LabelBase BBNameDesc = null;
	private LabelBase WeightAtBirthDesc = null;
	private LabelBase DateOfLastLiveBirthDesc = null;
	private TextNum BirthOrder = null;
	private ButtonBase LeftJButton_Confirm = null;
	private LabelBase MotherPatNo = null;
	private LabelBase BBPatNo = null;
	private LabelBase motherNameDesc = null;
	private LabelBase motherName = null;
	private LabelBase BBName = null;
	private LabelBase MotherSlipNo = null;
	private TextNum weight = null;
	private LabelBase BirthOrderDesc = null;
	private LabelBase MotherDocumentTypeDesc = null;
	private LabelBase BirthReturnNoDesc = null;
	private TextNum ChildEverBornAlive = null;
	private LabelBase WeightInUnit = null;
	private LabelBase BirthReturnNo = null;
	private LabelBase MotherDocumentTypeDesc11 = null;
	private ComboMTravelDocType MPType = null;
	private LabelBase MandatoryForConfirmDesc = null;
	private LabelBase redDot1 = null;
	private LabelBase redDot2 = null;
	private LabelBase redDot3 = null;

	private FieldSetBase addressPanel = null;
	private LabelBase M1Desc = null;
	private TextString M1 = null;
	private LabelBase M2Desc = null;
	private TextString M2 = null;
	private LabelBase M3Desc = null;
	private TextString M3 = null;
	private LabelBase M4Desc = null;
	private TextString M4 = null;
	private LabelBase M5Desc = null;
	private TextString M5 = null;
	private LabelBase M6Desc = null;
	private TextString M6 = null;
	private LabelBase M7Desc = null;
	private TextString M7 = null;
	private LabelBase M8Desc = null;
	private TextString M8 = null;
	private LabelBase M9Desc = null;
	private TextString M9 = null;

	private LabelBase LeftJLabel_ConfirmedByDesc = null;
	private LabelBase LeftJText_ConfirmedBy = null;
	private LabelBase LeftJLabel_ConfirmedOnDesc = null;
	private LabelBase LeftJText_ConfirmOn = null;

	private String memBBPatNo;
	private CheckBoxBase MalformationDetected = null;
	private LabelBase unitDesc = null;
	private boolean bFromEBirth;
	private boolean bConfirmEnabled;
    private String sCanEdit = null;
	private String sCanConfirm = null;

	/**
	 * This method initializes
	 *
	 */

	public DHBirthEntry() {
		super();//FROMEBIRTH
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
	    sCanEdit = null;
		sCanEdit = getParameter("sCanEdit");
		sCanConfirm = null;
		sCanConfirm = getParameter("sCanConfirm");
		memBBPatNo = null;
		getLeftJText_ConfirmedBy().setText(EMPTY_VALUE);
		getLeftJText_ConfirmOn().setText(EMPTY_VALUE);
		getMotherPatNo().setText(EMPTY_VALUE);
		getBBPatNo().setText(EMPTY_VALUE);
		getMotherName().setText(EMPTY_VALUE);
		getMotherSlipNo().setText(EMPTY_VALUE);
		getBBName().setText(EMPTY_VALUE);
		getBirthReturnNo().setText(EMPTY_VALUE);

		getLeftJButton_Confirm().setEnabled(false);
		bConfirmEnabled = !isDisableFunction("cmdConfirm", "DHBirthEntry");

		if ("True".equals(getParameter("FROMEBIRTH"))) {
			bFromEBirth = true;
		} else{
			bFromEBirth = false;
		}

		if (bFromEBirth) {   //come from ebirthlog
			if (getParameter("PATNO") != null) {
				memBBPatNo = getParameter("PATNO");

				if (!memBBPatNo.isEmpty()) {
					showInfo(memBBPatNo);

					QueryUtil.executeMasterFetch(
							Factory.getInstance().getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] {
								"DHBIRTHDTL",
								"RECSTATUS",
								"BBPATNO='" + memBBPatNo + "'"
							},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							// TODO Auto-generated method stub
							if (mQueue.success()) {
								if (mQueue.getContentField()[0].equals("N")) {
						            sCanEdit = "YES";
							        sCanConfirm = "YES";

							        if (bConfirmEnabled) {
							    		getLeftJButton_Confirm().setEnabled(true);
							        }
							        else {
							        	getLeftJButton_Confirm().setEnabled(false);
							        }
								}
								else {
									getLeftJButton_Confirm().setEnabled(false);
								}
							}
						}
					});
				}
			}
		} else{	//from DHBirthLog
			if (getParameter("BB_PATNO") != null) {
				memBBPatNo = getParameter("BB_PATNO");
				if (!memBBPatNo.isEmpty()) {
					showInfo(memBBPatNo);
					if (bConfirmEnabled) {
			    		getLeftJButton_Confirm().setEnabled(true);
			        }
					else {
						getLeftJButton_Confirm().setEnabled(false);
					}
				} else{
					getUnitDesc().setText("Gram");
				}
			}
		}
		setControlsEnabled(false);

		if (getMalformationDetected().isSelected()) {
			getAddressPanel().setEnabled(true);
		} else{
			getAddressPanel().setEnabled(false);
		}

		enableButton();
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextNum getDefaultFocusComponent() {
		return getWeight();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {
		setEditable(false);
		showInfo(memBBPatNo);
	}

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

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		String[] param = new String[] {
				getBBPatNo().getText(),
				getBBDOB().getText(),
				getBirthOrder().getText(),
				getChildEverBornAlive().getText(),
				getWeight().getText(),
				getUnitDesc().getText(),
				getMDNo().getText(),
				getMPType().getText(),
				getMalformationDetected().isSelected()?"1":"0",
				getM1().getText(), getM2().getText(), getM3().getText(),
				getM4().getText(), getM5().getText(), getM6().getText(),
				getM7().getText(), getM8().getText(), getM9().getText(),
				getUserInfo().getUserID(), "Y"
		};
		return param;
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {
		if (getWeight().isEmpty()) {
			Factory.getInstance().addErrorMessage("Weight at Birth is empty.", getWeight());
			return;
		} else if (getChildEverBornAlive().isEmpty()) {
			Factory.getInstance().addErrorMessage("Birth Order is empty.", getChildEverBornAlive());
			return;
		} else if (getBirthOrder().isEmpty()) {
			Factory.getInstance().addErrorMessage("Child Ever Born Alive is empty.", getBirthOrder());
			return;
		}

		if (TextUtil.isNumber(getBirthOrder().getText().trim())) {
			if (Integer.parseInt(getBirthOrder().getText()) < 1) {
				Factory.getInstance().addErrorMessage("Birth Order is invalid. Please input a digit(>0).", getBirthOrder());
				return;
			}
		} else{
			Factory.getInstance().addErrorMessage("Birth Order is invalid. Please input a digit(>0).", getBirthOrder());
			return;
		}

		if (TextUtil.isNumber(getChildEverBornAlive().getText().trim())) {
			if (Integer.parseInt(getChildEverBornAlive().getText()) < 0) {
				Factory.getInstance().addErrorMessage("Child Ever Born Alive is invalid. Please input a digit.", getChildEverBornAlive());
				return;
			}
		} else{
			Factory.getInstance().addErrorMessage("Child Ever Born Alive is invalid. Please input a digit.", getChildEverBornAlive());
			return;
		}

		if (TextUtil.isNumber(getWeight().getText().trim())) {
			if (Integer.parseInt(getWeight().getText()) < 0) {
				Factory.getInstance().addErrorMessage("Weight At Birth is invalid. Please input a digit.", getWeight());
				return;
			}
		} else{
			Factory.getInstance().addErrorMessage("Weight At Birth is invalid. Please input a digit.", getWeight());
			return;
		}

		chkValidBBDOB(null);
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected void actionValidationReady(final String actionType, boolean isValidationReady) {
		if (isValidationReady) {
			updateDHBirthDtl();
		}
	}

	@Override
	public void deleteAction() {
		delete();
	}

	@Override
	protected void cancelPostAction() {
		showInfo(memBBPatNo);
		setControlsEnabled(false);
		getLeftJButton_Confirm().setEnabled(bConfirmEnabled);
		enableButton();
	}

	@Override
	public void modifyAction() {
        setControlsEnabled(true);
		getAddressPanel().setEnabled(getMalformationDetected().isSelected());
		getWeight().focus();
		getLeftJButton_Confirm().setEnabled(false);
		super.modifyAction();
	}

	@Override
	protected void enableButton(String mode) {
		disableButton();
		
		getSaveButton().setEnabled(isModify());
		getCancelButton().setEnabled(isModify());
		getModifyButton().setEnabled("YES".equals(sCanEdit) && 
									!isDisableFunction("Edit", "BirthEntry") && 
									!isModify());
		getDeleteButton().setEnabled(!isDisableFunction("Delete", "BirthEntry"));
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	private void updateDHBirthDtl() {
		QueryUtil.executeMasterAction(getUserInfo(),
				ConstantsTx.DHBIRTHDTLUPDATE_TXCODE,
				QueryUtil.ACTION_MODIFY,
				getActionInputParamaters(),
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				// TODO Auto-generated method stub
				if (mQueue.success()) {
					setControlsEnabled(false);

					getLeftJButton_Confirm().setEnabled(bConfirmEnabled && "YES".equals(sCanConfirm));
					// reset action type
					setActionType(null);
					Factory.getInstance().addErrorMessage("Save success.");
				} else {
					Factory.getInstance().addErrorMessage(mQueue.getReturnMsg());
				}
			}
		});
	}

	private void delete() {
		QueryUtil.executeMasterAction(
				getUserInfo(), ConstantsTx.DHBIRTHDTLUPDATE_TXCODE, 
				QueryUtil.ACTION_DELETE,
				new String[] {
						memBBPatNo, null, null, null, null, null, null, null,
						null, null, null, null, null, null, null, null, null,
						null, null, null
					},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				// TODO Auto-generated method stub
				if (mQueue.success()) {
					Factory.getInstance().addErrorMessage(mQueue.getReturnMsg());
					if (!bFromEBirth) {
						setParameter("DHBIRTHLOGTAG","YES");
					}
					exitPanel();
				}
				else {
					Factory.getInstance().addErrorMessage(mQueue.getReturnMsg());
				}
			}
		});
	}

	private void confirm() {
		QueryUtil.executeMasterAction(getUserInfo(), ConstantsTx.DHBIRTHCONFIRM_TXCODE, 
				QueryUtil.ACTION_MODIFY,
				new String[] {memBBPatNo, getUserInfo().getUserID()},
				new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						// TODO Auto-generated method stub
						if (mQueue.success()) {
							getLeftJText_ConfirmedBy().setText(getUserInfo().getUserID());
							getLeftJText_ConfirmOn().setText(getMainFrame().getServerDateTime());

							if (!bFromEBirth) {
								setParameter("DHBIRTHLOGTAG","YES");
							}
				    		getLeftJButton_Confirm().setEnabled(false);
							exitPanel();
						}
					}
				});
	}

	private void showInfo(String BBPatNo) {
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.DHBIRTHDTLUPDATE_TXCODE,
				new String[] {BBPatNo},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				// TODO Auto-generated method stub
				if (mQueue.success()) {
					String[] outParam =  mQueue.getContentField();
					getMotherPatNo().setText(outParam[0]);
					getMotherName().setText(outParam[2]);
					getMotherSlipNo().setText(outParam[4]);
					getBBPatNo().setText(outParam[1]);
					getBBName().setText(outParam[3]);
					getWeight().setText(outParam[5]);
					getBirthOrder().setText(outParam[7]);
					getChildEverBornAlive().setText(outParam[9]);
					getBBDOB().setText(outParam[8]);
					getMPType().setText(outParam[11]);
					getMDNo().setText(outParam[12]);
					getMalformationDetected().setSelected(ConstantsVariable.ONE_VALUE.equals(outParam[10]));

					// init M1-M9 editable
					if (getMalformationDetected().getValue()) {
						getM1().setEditable(true);
						getM2().setEditable(true);
						getM3().setEditable(true);
						getM4().setEditable(true);
						getM5().setEditable(true);
						getM6().setEditable(true);
						getM7().setEditable(true);
						getM8().setEditable(true);
						getM9().setEditable(true);
					} else {
						getM1().setEditable(false);
						getM2().setEditable(false);
						getM3().setEditable(false);
						getM4().setEditable(false);
						getM5().setEditable(false);
						getM6().setEditable(false);
						getM7().setEditable(false);
						getM8().setEditable(false);
						getM9().setEditable(false);
					}

					getBirthReturnNo().setText(outParam[24]);
					getM1().setText(outParam[13]);
					getM2().setText(outParam[14]);
					getM3().setText(outParam[15]);
					getM4().setText(outParam[16]);
					getM5().setText(outParam[17]);
					getM6().setText(outParam[18]);
					getM7().setText(outParam[19]);
					getM8().setText(outParam[20]);
					getM9().setText(outParam[21]);
					getLeftJText_ConfirmedBy().setText(outParam[22]);
					getLeftJText_ConfirmOn().setText(outParam[23]);

					//bCanEdit = NOT_CONFIRMED.equals(outParam[24]) || MANUAL.equals(outParam[24]);
					//bCanConfirm = NOT_CONFIRMED.equals(outParam[24]);
					
					if (NOT_CONFIRMED.equals(outParam[25])) {
						getLeftJButton_Confirm().setEnabled(true);
					}
				}
			}
		});

	}

	private void setEditable(boolean editable) {
		PanelUtil.setAllFieldsEditable(getAddressPanel(), false);
	}

	private void setControlsEnabled(boolean enabled) {
		PanelUtil.setAllFieldsEditable(getParaPanel(), enabled);
		PanelUtil.setAllFieldsEditable(getAddressPanel(), enabled);
		getLeftJButton_Confirm().setEnabled(enabled);
	}

	private void chkValidBBDOB(final String actionType) {
		QueryUtil.executeMasterFetch(
				Factory.getInstance().getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
						new String[] {
							"DHBirthdtl dh, patient p, ebirthdtl e",
							"COUNT(dh.dhbirthid)",
							"dh.mopatno='" + getBBPatNo().getText().trim() + "'" +
							" and dh.mopatno=p.patno(+) and dh.mopatno=e.mo_patno(+)"
						},
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						// TODO Auto-generated method stub
						if (mQueue.success()) {
							if (Integer.parseInt(mQueue.getContentField()[0])>0) {
								QueryUtil.executeMasterFetch(
										Factory.getInstance().getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
												new String[] {
													"DHBirthdtl dh, patient p, ebirthdtl e",
													"TO_CHAR(decode(e.mo_dob,null,p.patbdate,e.mo_dob),'dd/mm/yyyy') as MODOB ",
													"dh.mopatno='" + getBBPatNo().getText().trim() + "'" +
													" and dh.mopatno=p.patno(+) and dh.mopatno=e.mo_patno(+)"
												},
												new MessageQueueCallBack() {
											@Override
											public void onPostSuccess(MessageQueue mQueue) {
												// TODO Auto-generated method stub
												if (mQueue.success()) {
													String dMODOB = mQueue.getContentField()[0];
													String chkValidBBDOB = null;
													int childEverBornAlive = 0;

													if (TextUtil.isNumber(getChildEverBornAlive().getText().trim())) {
														childEverBornAlive = Integer.parseInt(getChildEverBornAlive().getText().trim());
													}

													if (childEverBornAlive==0 && !getBBDOB().isEmpty()) {
														chkValidBBDOB = "Date of Last Live Birth must be blank.";
													} 
													if (!getBBDOB().isEmpty()) {
														if (!getBBDOB().isValid()) {
															chkValidBBDOB = "Date of Last Live Birth is invalid Date Format.";
														} 
														else if (DateTimeUtil.compareTo(getBBDOB().getText(),
																getMainFrame().getServerDateTime()) > 0) {
												           chkValidBBDOB = "Date of Last Live Birth must not be a future date.";
														}
														else if (!dMODOB.isEmpty()) {
															if (DateTimeUtil.compareTo(getBBDOB().getText(),
																	dMODOB) < 0) {
																chkValidBBDOB = "Date of Last Live Birth must not earlier than mother's birthday.";
															}
														}
													} 

													if ("confirm".equals(actionType)) {
														if (bCheckCanSave(chkValidBBDOB)) {
															confirm();
														}
													} else{
														if (chkValidBBDOB!=null && chkValidBBDOB.length()>0) {
															Factory.getInstance().addErrorMessage(chkValidBBDOB, getBBDOB());
														} else{
															if (chkMalfFields()) {
																actionValidationReady(null,true);
															}
														}
													}
												}
											}
										}
								);
							} else{
								String chkValidBBDOB = null;
								int childEverBornAlive = 0;
								
								if (TextUtil.isNumber(getChildEverBornAlive().getText().trim())) {
									childEverBornAlive = Integer.parseInt(getChildEverBornAlive().getText().trim());
								}

								if (childEverBornAlive==0 && !getBBDOB().isEmpty()) {
									chkValidBBDOB = "Date of Last Live Birth must be blank.";
								} 
								
								if (!getBBDOB().isEmpty()) {
									if (!getBBDOB().isValid()) {
										chkValidBBDOB = "Date of Last Live Birth is invalid Date Format.";
									} 
									else if (DateTimeUtil.compareTo(getBBDOB().getText(),
											getMainFrame().getServerDateTime()) > 0) {
							           chkValidBBDOB = "Date of Last Live Birth must not be a future date.";
									}
								} 
								
								if ("confirm".equals(actionType)) {
									if (bCheckCanSave(chkValidBBDOB)) {
										confirm();
									}
								} else{
									if (chkValidBBDOB!=null && chkValidBBDOB.length()>0) {
										Factory.getInstance().addErrorMessage(chkValidBBDOB, getBBDOB());
									} else{
										if (chkMalfFields()) {
											actionValidationReady(null,true);
										}
									}
								}
							}
						}
					}
		});
	}

	private boolean bCheckCanSave(String tmpErrMsg) {
		if (tmpErrMsg!=null && tmpErrMsg.length()>0) {
			Factory.getInstance().addErrorMessage(tmpErrMsg, getBBDOB());
			return false;
		}

		if (!getWeight().isEmpty()) {
			if (TextUtil.isNumber(getWeight().getText().trim())) {
				if (Integer.parseInt(getWeight().getText())<0) {
					Factory.getInstance().addErrorMessage("Child's weight at birth is invalid.", getWeight());
					return false;
				}
			} else{
				Factory.getInstance().addErrorMessage("Child's weight at birth is invalid.", getWeight());
				return false;
			}
		} else{
			Factory.getInstance().addErrorMessage("Child's weight at birth is invalid.", getWeight());
			return false;
		}

		if (!getChildEverBornAlive().isEmpty()) {
			if (!TextUtil.isNumber(getChildEverBornAlive().getText().trim())) {
				Factory.getInstance().addErrorMessage("Child ever born alive is invalid.", getChildEverBornAlive());
				return false;
			}
		} else{
			Factory.getInstance().addErrorMessage("Child ever born alive is invalid.", getChildEverBornAlive());
			return false;
		}

		if (!getBirthOrder().isEmpty()) {
			if (TextUtil.isNumber(getWeight().getText().trim())) {
				if (Integer.parseInt(getBirthOrder().getText())<1) {
					Factory.getInstance().addErrorMessage("Baby's birth order is invalid.", getBirthOrder());
					return false;
				}
			} else{
				Factory.getInstance().addErrorMessage("Baby's birth order is invalid.", getBirthOrder());
				return false;
			}
		} else{
			Factory.getInstance().addErrorMessage("Baby's birth order is invalid.", getBirthOrder());
			return false;
		}

		return chkMalfFields();
	}

	private boolean chkMalfFields() {
		String strMalf = null;
		strMalf = getM1().getText().trim() + getM2().getText().trim() + getM3().getText().trim() +
				  getM4().getText().trim() + getM5().getText().trim() + getM6().getText().trim() +
				  getM7().getText().trim() + getM8().getText().trim() + getM9().getText().trim();

		if (getMalformationDetected().isSelected()) {
			if (strMalf.length()<=0) {
				Factory.getInstance().addErrorMessage("At lease 1 of malf1 - malf9 must not be empty!", getM1());
				return false;
			}
		} else{
			if (strMalf.length()>0) {
				Factory.getInstance().addErrorMessage("Malf1 - malf9 must all be empty!", getMalformationDetected());
				return false;
			}
		}
		return true;
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	@Override
	protected BasePanel getActionPanel() {
		if (actionPanel == null) {
			actionPanel = new BasePanel();
			actionPanel.setSize(945, 575);
			actionPanel.add(getParaPanel(), null);
			actionPanel.add(getAddressPanel(), null);
			actionPanel.add(getLeftJLabel_ConfirmedByDesc(), null);
			actionPanel.add(getLeftJText_ConfirmedBy(), null);
			actionPanel.add(getLeftJLabel_ConfirmedOnDesc(), null);
			actionPanel.add(getLeftJText_ConfirmOn(), null);
			actionPanel.add(getLeftJButton_Confirm(), null);
			actionPanel.add(getMandatoryForConfirmDesc(), null);
		}
		return actionPanel;
	}

	public BasePanel getParaPanel() {
		if (ParaPanel == null) {
			ParaPanel = new BasePanel();
			ParaPanel.setBounds(10, 5, 710, 220);
			ParaPanel.setEtchedBorder();
			ParaPanel.add(getMotherPatNoDesc(), null);
			ParaPanel.add(getMotherPatNo(), null);
			ParaPanel.add(getMotherSlipNoDesc(), null);
			ParaPanel.add(getMotherNameDesc(), null);
			ParaPanel.add(getMotherName(), null);
			ParaPanel.add(getMotherSlipNo(), null);
			ParaPanel.add(getBBPatNoDesc(), null);
			ParaPanel.add(getBBPatNo(), null);
			ParaPanel.add(getBBNameDesc(), null);
			ParaPanel.add(getBBName(), null);
			ParaPanel.add(getWeightAtBirthDesc(), null);
			ParaPanel.add(getWeight(), null);
			ParaPanel.add(getWeightInUnit(), null);
			ParaPanel.add(getBirthOrderDesc(), null);
			ParaPanel.add(getMotherDocumentNoDesc(), null);
			ParaPanel.add(getUnitDesc(), null);
			ParaPanel.add(getBirthReturnNoDesc(), null);
			ParaPanel.add(getBirthOrder(), null);
			ParaPanel.add(getChildEverBornAliveDesc(), null);
			ParaPanel.add(getChildEverBornAlive(), null);
			ParaPanel.add(getDateOfLastLiveBirthDesc(), null);
			ParaPanel.add(getBBDOB(), null);
			ParaPanel.add(getMotherDocumentTypeDesc(), null);
			ParaPanel.add(getMPType(), null);
			ParaPanel.add(getMDNo(), null);
			ParaPanel.add(getMalformationDetectedDesc(), null);
			ParaPanel.add(getBirthReturnNo(), null);
			ParaPanel.add(getMalformationDetected(), null);
			ParaPanel.add(getredDot1(), null);
			ParaPanel.add(getredDot2(), null);
			ParaPanel.add(getredDot3(), null);
		}
		return ParaPanel;
	}

	public LabelBase getMotherPatNoDesc() {
		if (MotherPatNoDesc == null) {
			MotherPatNoDesc = new LabelBase();
			MotherPatNoDesc.setText("Mother Patient. No:");
			MotherPatNoDesc.setBounds(10, 10, 110, 20);
		}
		return MotherPatNoDesc;
	}

	public LabelBase getMotherPatNo() {
		if (MotherPatNo == null) {
			MotherPatNo = new LabelBase();
			MotherPatNo.setBounds(120, 10, 100, 20);
			MotherPatNo.setStyleAttribute("color", "red");
		}
		return MotherPatNo;
	}

	public LabelBase getMotherNameDesc() {
		if (motherNameDesc == null) {
			motherNameDesc = new LabelBase();
			motherNameDesc.setBounds(240, 10, 42, 20);
			motherNameDesc.setText("Name:");
		}
		return motherNameDesc;
	}

	public LabelBase getMotherName() {
		if (motherName == null) {
			motherName = new LabelBase();
			motherName.setStyleAttribute("color", "red");
			motherName.setBounds(280, 10, 140, 20);
		}
		return motherName;
	}

	public LabelBase getMotherSlipNoDesc() {
		if (MotherSlipNoDesc == null) {
			MotherSlipNoDesc = new LabelBase();
			MotherSlipNoDesc.setText("Mother Slip No.:");
			MotherSlipNoDesc.setBounds(456, 10, 91, 20);
		}
		return MotherSlipNoDesc;
	}

	public LabelBase getMotherSlipNo() {
		if (MotherSlipNo == null) {
			MotherSlipNo = new LabelBase();
			MotherSlipNo.setStyleAttribute("color", "red");
			MotherSlipNo.setBounds(551, 10, 100, 20);
		}
		return MotherSlipNo;
	}

	public LabelBase getBBPatNoDesc() {
		if (BBPatNoDesc == null) {
			BBPatNoDesc = new LabelBase();
			BBPatNoDesc.setText("Baby Patient No:");
			BBPatNoDesc.setBounds(10, 45, 100, 20);
		}
		return BBPatNoDesc;
	}

	public LabelBase getBBPatNo() {
		if (BBPatNo == null) {
			BBPatNo = new LabelBase();
			BBPatNo.setStyleAttribute("color", "red");
			BBPatNo.setBounds(120, 45, 100, 20);
		}
		return BBPatNo;
	}

	public LabelBase getBBNameDesc() {
		if (BBNameDesc == null) {
			BBNameDesc = new LabelBase();
			BBNameDesc.setText("Name:");
			BBNameDesc.setBounds(240, 45, 42, 20);
		}
		return BBNameDesc;
	}

	public LabelBase getBBName() {
		if (BBName == null) {
			BBName = new LabelBase();
			BBName.setStyleAttribute("color", "red");
			BBName.setBounds(280, 45, 140, 20);
		}
		return BBName;
	}

	public LabelBase getWeightAtBirthDesc() {
		if (WeightAtBirthDesc == null) {
			WeightAtBirthDesc = new LabelBase();
			WeightAtBirthDesc.setText("Weight at Birth:");
			WeightAtBirthDesc.setBounds(456, 45, 91, 20);
		}
		return WeightAtBirthDesc;
	}

	public TextNum getWeight() {
		if (weight == null) {
			weight = new TextNum(6);
			weight.setBounds(551, 45, 55, 20);
		}
		return weight;
	}

	public LabelBase getWeightInUnit() {
		if (WeightInUnit == null) {
			WeightInUnit = new LabelBase();
			WeightInUnit.setText("in Unit:");
			WeightInUnit.setBounds(617, 45, 42, 20);
		}
		return WeightInUnit;
	}

	public LabelBase getUnitDesc() {
		if (unitDesc == null) {
			unitDesc = new LabelBase();
			unitDesc.setBounds(663, 45, 32, 20);
			unitDesc.setText("Gram");
		}
		return unitDesc;
	}

	public LabelBase getBirthOrderDesc() {
		if (BirthOrderDesc == null) {
			BirthOrderDesc = new LabelBase();
			BirthOrderDesc.setText("Birth Order:");
			BirthOrderDesc.setBounds(10, 80, 87, 20);
		}
		return BirthOrderDesc;
	}

	public TextNum getBirthOrder() {
		if (BirthOrder == null) {
			BirthOrder = new TextNum(1);
			BirthOrder.setBounds(120, 80, 100, 20);
		}
		return BirthOrder;
	}

	public LabelBase getChildEverBornAliveDesc() {
		if (ChildEverBornAliveDesc == null) {
			ChildEverBornAliveDesc = new LabelBase();
			ChildEverBornAliveDesc.setText("Child Ever Born Alive:");
			ChildEverBornAliveDesc.setBounds(240, 80, 125, 20);
		}
		return ChildEverBornAliveDesc;
	}

	/**
	 * This method initializes alive
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextNum getChildEverBornAlive() {
		if (ChildEverBornAlive == null) {
			ChildEverBornAlive = new TextNum(1);
			ChildEverBornAlive.setBounds(360, 80, 65, 20);
		}
		return ChildEverBornAlive;
	}

	public TextDate getBBDOB() {
		if (BBDOB == null) {
			BBDOB = new TextDate();
			BBDOB.setBounds(576, 80, 120, 20);
		}
		return BBDOB;
	}

	public LabelBase getMotherDocumentTypeDesc() {
		if (MotherDocumentTypeDesc == null) {
			MotherDocumentTypeDesc = new LabelBase();
			MotherDocumentTypeDesc.setText("Mother Document Type:");
			MotherDocumentTypeDesc.setBounds(10, 115, 135, 20);
		}
		return MotherDocumentTypeDesc;
	}

	public TextString getMDNo() {
		if (MDNo == null) {
			MDNo = new TextString(10);
			MDNo.setBounds(140, 150, 556, 20);
		}
		return MDNo;
	}

	public LabelBase getDateOfLastLiveBirthDesc() {
		if (DateOfLastLiveBirthDesc == null) {
			DateOfLastLiveBirthDesc = new LabelBase();
			DateOfLastLiveBirthDesc.setText("Date of Last Live Birth:<br>(DD/MM/YYYY)");
			DateOfLastLiveBirthDesc.setBounds(456, 80, 140, 40);
		}
		return DateOfLastLiveBirthDesc;
	}

	/**
	 * This method initializes MPType
	 *
	 * @return com.hkah.client.layout.combobox.ComboCordCutPlace
	 */
	private ComboMTravelDocType getMPType() {
		if (MPType == null) {
			MPType = new ComboMTravelDocType();
			MPType.setBounds(140, 115, 556, 20);
		}
		return MPType;
	}

	public LabelBase getMotherDocumentNoDesc() {
		if (MotherDocumentTypeDesc11 == null) {
			MotherDocumentTypeDesc11 = new LabelBase();
			MotherDocumentTypeDesc11.setText("Mother Document#:");
			MotherDocumentTypeDesc11.setBounds(10, 150, 129, 20);
		}
		return MotherDocumentTypeDesc11;
	}

	public LabelBase getBirthReturnNoDesc() {
		if (BirthReturnNoDesc == null) {
			BirthReturnNoDesc = new LabelBase();
			BirthReturnNoDesc.setText("Birth Return No:");
			BirthReturnNoDesc.setBounds(484, 185, 93, 20);
		}
		return BirthReturnNoDesc;
	}

	public LabelBase getBirthReturnNo() {
		if (BirthReturnNo == null) {
			BirthReturnNo = new LabelBase();
			BirthReturnNo.setBounds(576, 185, 120, 20);
			BirthReturnNo.setStyleAttribute("color", "red");
		}
		return BirthReturnNo;
	}

	public LabelBase getMalformationDetectedDesc() {
		if (MalformationDetectedDesc == null) {
			MalformationDetectedDesc = new LabelBase();
			MalformationDetectedDesc.setText("Malformation Detected:");
			MalformationDetectedDesc.setBounds(10, 185, 135, 20);
		}
		return MalformationDetectedDesc;
	}

	/**
	 * This method initializes MalformationDetected
	 *
	 * @return javax.swing.JCheckBox
	 */
	private CheckBoxBase getMalformationDetected() {
		if (MalformationDetected == null) {
			MalformationDetected = new CheckBoxBase() {
				public void onClick() {
					if (MalformationDetected.isSelected()) {
						addressPanel.setEnabled(true);
					} else{
						addressPanel.setEnabled(false);
					}
				}
			};
			MalformationDetected.setBounds(137, 185, 21, 21);
		}

/*
		MalformationDetected.addListener(Events.OnClick, new Listener<FieldEvent>() {

            @Override
            public void handleEvent(FieldEvent be) {
                // TODO Auto-generated method stub

            	addressPanel.setEnabled(false);
                if (((CheckBoxBase)be.getField()).getValue()) {
                	//listTable.setValueAt("-1", selRow, 24);
                	getM1().setEditable(true);
                	getM2().setEditable(true);
                	getM3().setEditable(true);
                	getM4().setEditable(true);
                	getM5().setEditable(true);
                	getM6().setEditable(true);
                	getM7().setEditable(true);
                	getM8().setEditable(true);
                	getM9().setEditable(true);
                } else {
                	getM1().setEditable(false);
                	getM2().setEditable(false);
                	getM3().setEditable(false);
                	getM4().setEditable(false);
                	getM5().setEditable(false);
                	getM6().setEditable(false);
                	getM7().setEditable(false);
                	getM8().setEditable(false);
                	getM9().setEditable(false);
                }
            }
		});
*/
		return MalformationDetected;
	}

	private LabelBase getredDot1() {
		if (redDot1 == null) {
			redDot1 = new LabelBase();
			redDot1.setStyleAttribute("color", "red");
			redDot1.setText("*");
			redDot1.setBounds(606, 47, 10, 14);
		}
		return redDot1;
	}

	public LabelBase getredDot2() {
		if (redDot2 == null) {
			redDot2 = new LabelBase();
			redDot2.setBounds(220, 82, 10, 14);
			redDot2.setStyleAttribute("color", "red");
			redDot2.setText("*");
		}
		return redDot2;
	}

	public LabelBase getredDot3() {
		if (redDot3 == null) {
			redDot3 = new LabelBase();
			redDot3.setBounds(425, 82, 10, 14);
			redDot3.setStyleAttribute("color", "red");
			redDot3.setText("*");
		}
		return redDot3;
	}

	/**
	 * This method initializes addressPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	private FieldSetBase getAddressPanel() {
		if (addressPanel == null) {
			addressPanel = new FieldSetBase();
			addressPanel.setBounds(11, 238, 710, 260);
			addressPanel.setHeading("Congenital Malformation Detected");
			addressPanel.add(getM1Desc(), null);
			addressPanel.add(getM1(), null);
			addressPanel.add(getM2Desc(), null);
			addressPanel.add(getM2(), null);
			addressPanel.add(getM3Desc(), null);
			addressPanel.add(getM3(), null);
			addressPanel.add(getM4Desc(), null);
			addressPanel.add(getM4(), null);
			addressPanel.add(getM5Desc(), null);
			addressPanel.add(getM5(), null);
			addressPanel.add(getM6Desc(), null);
			addressPanel.add(getM6(), null);
			addressPanel.add(getM7Desc(), null);
			addressPanel.add(getM7(), null);
			addressPanel.add(getM8Desc(), null);
			addressPanel.add(getM8(), null);
			addressPanel.add(getM9Desc(), null);
			addressPanel.add(getM9(), null);
		}
		return addressPanel;
	}

	private LabelBase getM1Desc() {
		if (M1Desc == null) {
			M1Desc = new LabelBase();
			M1Desc.setBounds(10, 0, 50, 20);
			M1Desc.setText("Malf1:");
		}
		return M1Desc;
	}

	/**
	 * This method initializes M1
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getM1() {
		if (M1 == null) {
			M1 = new TextString();
			M1.setBounds(60, 0, 636, 20);
		}
		return M1;
	}

	private LabelBase getM2Desc() {
		if (M2Desc == null) {
			M2Desc = new LabelBase();
			M2Desc.setBounds(10, 25, 50, 20);
			M2Desc.setText("Malf2:");
		}
		return M2Desc;
	}

	/**
	 * This method initializes M2
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getM2() {
		if (M2 == null) {
			M2 = new TextString();
			M2.setBounds(60, 25, 636, 20);
		}
		return M2;
	}

	private LabelBase getM3Desc() {
		if (M3Desc == null) {
			M3Desc = new LabelBase();
			M3Desc.setBounds(10, 50, 50, 20);
			M3Desc.setText("Malf3:");
		}
		return M3Desc;
	}

	/**
	 * This method initializes M3
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getM3() {
		if (M3 == null) {
			M3 = new TextString();
			M3.setBounds(60, 50, 636, 20);
		}
		return M3;
	}

	private LabelBase getM4Desc() {
		if (M4Desc == null) {
			M4Desc = new LabelBase();
			M4Desc.setBounds(10, 75, 50, 20);
			M4Desc.setText("Malf4:");
		}
		return M4Desc;
	}

	/**
	 * This method initializes M4
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getM4() {
		if (M4 == null) {
			M4 = new TextString();
			M4.setBounds(60, 75, 636, 20);
		}
		return M4;
	}

	private LabelBase getM5Desc() {
		if (M5Desc == null) {
			M5Desc = new LabelBase();
			M5Desc.setBounds(10, 100, 50, 20);
			M5Desc.setText("Malf5:");
		}
		return M5Desc;
	}

	/**
	 * This method initializes M5
	 *
	 * @return com.hkah.client.layout.textfield.TextDate
	 */
	private TextString getM5() {
		if (M5 == null) {
			M5 = new TextString();
			M5.setBounds(60, 100, 636, 20);
		}
		return M5;
	}

	private LabelBase getM6Desc() {
		if (M6Desc == null) {
			M6Desc = new LabelBase();
			M6Desc.setBounds(10, 125, 50, 20);
			M6Desc.setText("Malf6:");
		}
		return M6Desc;
	}

	/**
	 * This method initializes M6
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getM6() {
		if (M6 == null) {
			M6 = new TextString();
			M6.setBounds(60, 125, 636, 20);
		}
		return M6;
	}

	private LabelBase getM7Desc() {
		if (M7Desc == null) {
			M7Desc = new LabelBase();
			M7Desc.setBounds(10, 150, 50, 20);
			M7Desc.setText("Malf7:");
		}
		return M7Desc;
	}

	/**
	 * This method initializes M7
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getM7() {
		if (M7 == null) {
			M7 = new TextString();
			M7.setBounds(60, 150, 636, 20);
		}
		return M7;
	}

	private LabelBase getM8Desc() {
		if (M8Desc == null) {
			M8Desc = new LabelBase();
			M8Desc.setBounds(10, 175, 50, 20);
			M8Desc.setText("Malf8:");
		}
		return M8Desc;
	}

	/**
	 * This method initializes M8
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getM8() {
		if (M8 == null) {
			M8 = new TextString();
			M8.setBounds(60, 175, 636, 20);
		}
		return M8;
	}

	private LabelBase getM9Desc() {
		if (M9Desc == null) {
			M9Desc = new LabelBase();
			M9Desc.setBounds(10, 200, 50, 20);
			M9Desc.setText("Malf9:");
		}
		return M9Desc;
	}

	/**
	 * This method initializes M9
	 *
	 * @return com.hkah.client.layout.combobox.TextString
	 */
	private TextString getM9() {
		if (M9 == null) {
			M9 = new TextString();
			M9.setBounds(60, 200, 636, 20);
		}
		return M9;
	}

	public ButtonBase getLeftJButton_Confirm() {
		if (LeftJButton_Confirm == null) {
			LeftJButton_Confirm = new ButtonBase() {
				@Override
				public void onClick() {
//					actionValidation("confirm");
					chkValidBBDOB("confirm");
				}
			};
			LeftJButton_Confirm.setText("Confirm");
			LeftJButton_Confirm.setBounds(12, 505, 82, 25);
		}
		return LeftJButton_Confirm;
	}

	public LabelBase getLeftJLabel_ConfirmedByDesc() {
		if (LeftJLabel_ConfirmedByDesc == null) {
			LeftJLabel_ConfirmedByDesc = new LabelBase();
			LeftJLabel_ConfirmedByDesc.setText("Confirmed By:");
			LeftJLabel_ConfirmedByDesc.setBounds(114, 505, 85, 20);
		}
		return LeftJLabel_ConfirmedByDesc;
	}

	public LabelBase getLeftJText_ConfirmedBy() {
		if (LeftJText_ConfirmedBy == null) {
			LeftJText_ConfirmedBy = new LabelBase();
			LeftJText_ConfirmedBy.setBounds(194, 505, 98, 20);
		}
		return LeftJText_ConfirmedBy;
	}

	public LabelBase getLeftJLabel_ConfirmedOnDesc() {
		if (LeftJLabel_ConfirmedOnDesc == null) {
			LeftJLabel_ConfirmedOnDesc = new LabelBase();
			LeftJLabel_ConfirmedOnDesc.setText("Confirmed On:");
			LeftJLabel_ConfirmedOnDesc.setBounds(340, 505, 89, 20);
		}
		return LeftJLabel_ConfirmedOnDesc;
	}

	public LabelBase getLeftJText_ConfirmOn() {
		if (LeftJText_ConfirmOn == null) {
			LeftJText_ConfirmOn = new LabelBase();
			LeftJText_ConfirmOn.setBounds(430, 505, 150, 20);
		}
		return LeftJText_ConfirmOn;
	}

	/**
	 * This method initializes fatherPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	private LabelBase getMandatoryForConfirmDesc() {
		if (MandatoryForConfirmDesc == null) {
			MandatoryForConfirmDesc = new LabelBase();
			MandatoryForConfirmDesc.setText("*- mandatory for confirm");
			MandatoryForConfirmDesc.setBounds(575, 500, 150, 20);
			MandatoryForConfirmDesc.setStyleAttribute("color", "red");
		}
		return MandatoryForConfirmDesc;
	}
}