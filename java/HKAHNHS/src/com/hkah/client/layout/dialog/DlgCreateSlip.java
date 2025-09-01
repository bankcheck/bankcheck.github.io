package com.hkah.client.layout.dialog;

import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.form.TextField;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.combobox.ComboDoctor;
import com.hkah.client.layout.combobox.ComboRegOPCategory;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextDoctorSearch;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTableColumn;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public abstract class DlgCreateSlip extends DialogBase implements ConstantsTableColumn {
	private final static int m_frameWidth = 387;
	private final static int m_frameHeight = 290;
	private final static String OUTPAT_DPTCODE = "4320";

	private BasePanel slpPanel = null;
	private LabelBase slpPatNoDesc = null;
	private TextPatientNoSearch slpPatNo = null;
	private LabelBase slpPatFnameDesc = null;
	private TextString slpPatFname = null;
	private LabelBase slpPatGnameDesc = null;
	private TextString slpPatGname = null;
	private LabelBase slpDocCodeDesc = null;
	private ComboDoctor slpDocCode = null;
	private TextDoctorSearch slpDocCodeSearch = null;
	private LabelBase slpDocNameDesc = null;
	private TextReadOnly slpDocName = null;
	private LabelBase slpRegOPCatDesc = null;
	private ComboRegOPCategory slpRegOPCat = null;
	private LabelBase slpInitialAssessedDesc = null;
	private ComboBoxBase slpInitialAssessed = null;
	private boolean allowAcceptSlip = false;

	public DlgCreateSlip(MainFrame owner) {
		super(owner, OKCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	private void initialize() {
		setTitle("New Slip");
		setContentPane(getSlpPanel());

		// change label
		getButtonById(OK).setText("Post", 'P');
	}

	public TextField getDefaultFocusComponent() {
		if (getSlpPatNo().isEditable()) {
			return getSlpPatNo();
		} else {
			return getSlpDocCode();
		}
	}

	public abstract void post(String slipNo);

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(boolean allow) {
		showDialog(allow, null);
	}
	
	public void showDialog(boolean allow, String patno) {
		getSlpPatNo().resetText();
		getSlpPatFname().resetText();
		getSlpPatGname().resetText();
		getSlpDocCode().resetText();
		getSlpDocName().resetText();
		getSlpRegOPCat().resetText();
		getSlpInitialAssessed().resetText();

		getSlpPatFname().setEditable(true);
		getSlpPatGname().setEditable(true);
		getButtonById(OK).setEnabled(true);

		if (patno != null && patno.length() > 0) {
			getSlpPatNo().setText(patno);
		} else {
			getSlpPatNo().setEditable(true);
		}

		// only hkah pbo
//		if (HKAH_VALUE.equals(getUserInfo().getSiteCode()) && getUserInfo().getUserName().indexOf("PB - ") == 0) {
//			getSlpInitialAssessedDesc().setVisible(true);
//			getSlpInitialAssessed().setVisible(true);
//		} else {
			getSlpInitialAssessedDesc().setVisible(false);
			getSlpInitialAssessed().setVisible(false);
//		}

		allowAcceptSlip = allow;

		setVisible(true);
	}

	@Override
	protected void doOkAction() {
		if (getSlpPatFname().isEmpty()) {
			Factory.getInstance().addErrorMessage("Please enter patient family name.", "PBA - [New Slip]", getSlpPatFname());
		} else if (getSlpPatGname().isEmpty()) {
			Factory.getInstance().addErrorMessage("Please enter patient given name.", "PBA - [New Slip]", getSlpPatGname());
		} else if (getSlpDocCode().isEmpty() || getSlpDocName().isEmpty()) {
			Factory.getInstance().addErrorMessage("Invalid doctor code.", "PBA - [New Slip]", getSlpDocCode());
		} else if (getSlpRegOPCat().isEmpty()) {
			Factory.getInstance().addErrorMessage("Please select registration category.", "PBA - [New Slip]", getSlpRegOPCat());
		} else if (getSlpInitialAssessed().isVisible() && YES_VALUE.equals(Factory.getInstance().getSysParameter("AppAltEnty")) && getSlpInitialAssessed().isEmpty()) {
			Factory.getInstance().addErrorMessage("Initial Assessed is mandatory, please select one option.", "PBA - [New Slip]", getSlpInitialAssessed());
		} else if (getSlpInitialAssessed().isVisible() && !getSlpInitialAssessed().isEmpty() && !getSlpInitialAssessed().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid Initial Assessed.", "PBA - [New Slip]", getSlpInitialAssessed());
		} else {
			validateField();
		}
	}

	private void validateField() {
		getButtonById(OK).setEnabled(false);
		if (!getSlpPatNo().isEmpty()) {
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.PATIENT_TXCODE,
					new String[] { getSlpPatNo().getText().trim() },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						getSlpPatNo().setEditable(false);
						getSlpPatFname().setText(mQueue.getContentField()[PATIENT_FAMILY_NAME]);
						getSlpPatGname().setText(mQueue.getContentField()[PATIENT_GIVEN_NAME]);
						checkFields();
					} else {
						getButtonById(OK).setEnabled(true);
					}
				}
			});
		} else {
			checkFields();
		}
	}

	private void checkFields() {
		if (!getSlpPatFname().isEmpty()) {
			if (!getSlpPatGname().isEmpty()) {
				if (!slpDocCode.isEmpty()) {
					QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.DOCTORCB_TXCODE,
							new String[] {getSlpDocCode().getText().trim()},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								String slpPatFname = EMPTY_VALUE;
								String slpPatGname = EMPTY_VALUE;
								if (getSlpPatNo().isEmpty()) {
									slpPatFname = getSlpPatFname().getText().trim();
									slpPatGname = getSlpPatGname().getText().trim();
								}

								QueryUtil.executeMasterAction(getUserInfo(), ConstantsTx.CREATESLIP_TXCODE,
										QueryUtil.ACTION_APPEND,
										new String[] {
												EMPTY_VALUE,
												getSlpDocCode().getText(),
												getSlpRegOPCat().getText(),
												OUTPAT_DPTCODE,
												slpPatFname,
												slpPatGname,
												getSlpPatNo().getText().trim(),
												EMPTY_VALUE,
												getSlpInitialAssessed().getText(),
												getUserInfo().getSiteCode(),
												getUserInfo().getUserID()
										},
										new MessageQueueCallBack() {
									@Override
									public void onPostSuccess(final MessageQueue mQueue) {
										if (mQueue.success()) {
											if (allowAcceptSlip) {
												MessageBoxBase.confirm(ConstantsMessage.MSG_PBA_SYSTEM, "Slip successfully created. Do you want to open?",
														new Listener<MessageBoxEvent>() {
													@Override
													public void handleEvent(MessageBoxEvent be) {
														if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
															post(mQueue.getReturnCode());
														} else {
															dispose();
														}
													}
												});
											} else {
												Factory.getInstance().addInformationMessage("Slip successfully created.", "PBA - [New Slip]");
												dispose();
											}
										} else {
											Factory.getInstance().addErrorMessage(mQueue.getReturnMsg(), "PBA - [New Slip]");
											getButtonById(OK).setEnabled(true);
										}
									}
								});
							}
						}

						@Override
						public void onFailure(Throwable caught) {
							Factory.getInstance().addErrorMessage("Invalid doctor code.", "PBA - [New Slip]", getSlpDocCode());
							getButtonById(OK).setEnabled(true);
							getSlpDocCode().resetText();
						}
					});
				}
			} else {
				Factory.getInstance().addErrorMessage("Invalid Patient Given Name.", "PBA - [New Slip]", getSlpPatGname());
				getButtonById(OK).setEnabled(true);
				getSlpPatGname().focus();
			}
		} else {
			Factory.getInstance().addErrorMessage("Invalid Patient Family Name.", "PBA - [New Slip]", getSlpPatFname());
			getButtonById(OK).setEnabled(true);
			getSlpPatFname().focus();
		}
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	private BasePanel getSlpPanel() {
		if (slpPanel == null) {
			slpPanel = new BasePanel();
			slpPanel.setBounds(5, 5, 360, 220);
			slpPanel.add(getSlpPatNoDesc(), null);
			slpPanel.add(getSlpPatNo(), null);
			slpPanel.add(getSlpPatFnameDesc(), null);
			slpPanel.add(getSlpPatFname(), null);
			slpPanel.add(getSlpPatGnameDesc(), null);
			slpPanel.add(getSlpPatGname(), null);
			slpPanel.add(getSlpDocCodeDesc(), null);
			slpPanel.add(getSlpDocCode(), null);
			slpPanel.add(getSlpDocCodeSearch(), null);
			slpPanel.add(getSlpDocNameDesc(), null);
			slpPanel.add(getSlpDocName(), null);
			slpPanel.add(getSlpRegOPCatDesc(), null);
			slpPanel.add(getSlpRegOPCat(), null);
			slpPanel.add(getSlpInitialAssessedDesc(), null);
			slpPanel.add(getSlpInitialAssessed(), null);
		}
		return slpPanel;
	}

	private LabelBase getSlpPatNoDesc() {
		if (slpPatNoDesc == null) {
			slpPatNoDesc = new LabelBase();
			slpPatNoDesc.setText("Patient No.");
			slpPatNoDesc.setBounds(20, 10, 120, 20);
		}
		return slpPatNoDesc;
	}

	private TextPatientNoSearch getSlpPatNo() {
		if (slpPatNo == null) {
			slpPatNo = new TextPatientNoSearch(true, true) {
				@Override
				public void onPressed() {
					if (!slpPatNo.isEmpty()) {
						getSlpPatFname().resetText();
						getSlpPatGname().resetText();
						getSlpPatFname().setEditable(false);
						getSlpPatGname().setEditable(false);
					} else {
						getSlpPatFname().setEditable(true);
						getSlpPatGname().setEditable(true);
					}
				}

				@Override
				public void onReleased() {
					if (!slpPatNo.isEmpty()) {
						getSlpPatFname().resetText();
						getSlpPatGname().resetText();
						getSlpPatFname().setEditable(false);
						getSlpPatGname().setEditable(false);
					} else {
						getSlpPatFname().setEditable(true);
						getSlpPatGname().setEditable(true);
					}
				}

				@Override
				public void onBlur() {
					super.onBlur();
					if (!slpPatNo.isEmpty()) {
						QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.PATIENT_TXCODE,
								new String[] {slpPatNo.getText().trim()},
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									slpPatNo.setEditable(false);
									getSlpPatFname().setText(mQueue.getContentField()[PATIENT_FAMILY_NAME]);
									getSlpPatGname().setText(mQueue.getContentField()[PATIENT_GIVEN_NAME]);
								} else {
									Factory.getInstance().addErrorMessage("Invalid patient number.", "PBA - [New Slip]", getSlpPatNo());
									slpPatNo.resetText();
								}
							}

							@Override
							public void onFailure(Throwable caught) {
								Factory.getInstance().addErrorMessage("Invalid patient number.", "PBA - [New Slip]", getSlpPatNo());
								slpPatNo.resetText();
							}
						});
					}
				}
			};
			slpPatNo.setBounds(150, 10, 180, 20);
		}
		return slpPatNo;
	}

	private LabelBase getSlpPatFnameDesc() {
		if (slpPatFnameDesc == null) {
			slpPatFnameDesc = new LabelBase();
			slpPatFnameDesc.setText("Patient Family Name");
			slpPatFnameDesc.setBounds(20, 35, 120, 20);
		}
		return slpPatFnameDesc;
	}

	private TextString getSlpPatFname() {
		if (slpPatFname == null) {
			slpPatFname = new TextString() {
				@Override
				protected void onFocus() {
					if (slpPatFname.isReadOnly()) {
						getSlpDocCode().focus();
					}
				}
			};
			slpPatFname.setBounds(150, 35, 180, 20);
		}
		return slpPatFname;
	}

	private LabelBase getSlpPatGnameDesc() {
		if (slpPatGnameDesc == null) {
			slpPatGnameDesc = new LabelBase();
			slpPatGnameDesc.setText("Patient Given Name");
			slpPatGnameDesc.setBounds(20, 60, 120, 20);
		}
		return slpPatGnameDesc;
	}

	private TextString getSlpPatGname() {
		if (slpPatGname == null) {
			slpPatGname = new TextString() {
				@Override
				protected void onFocus() {
					if (slpPatGname.isReadOnly()) {
						getSlpDocCode().focus();
					}
				}
			};
			slpPatGname.setBounds(150, 60, 180, 20);
		}
		return slpPatGname;
	}

	private LabelBase getSlpDocCodeDesc() {
		if (slpDocCodeDesc == null) {
			slpDocCodeDesc = new LabelBase();
			slpDocCodeDesc.setText("Doctor Code");
			slpDocCodeDesc.setBounds(20, 85, 120, 20);
		}
		return slpDocCodeDesc;
	}

	private ComboDoctor getSlpDocCode() {
		if (slpDocCode == null) {
			slpDocCode = new ComboDoctor(getSlpDocName()) {
				@Override
				public void onSearchTriggerClick(ComponentEvent ce) {
					getSlpDocCodeSearch().setValue(this.getText());
					getSlpDocCodeSearch().showSearchPanel();
				}

				@Override
				protected void onBlurInvalid() {
					Factory.getInstance().addErrorMessage("Invalid Doctor number.", "PBA - [New Slip]", slpDocCode);
					slpDocCode.resetText();
					getSlpDocName().resetText();
				}
			};
			slpDocCode.setShowTextSearhPanel(true);
			slpDocCode.setBounds(150, 85, 180, 20);
		}
		return slpDocCode;
	}

	private TextDoctorSearch getSlpDocCodeSearch() {
		if (slpDocCodeSearch == null) {
			slpDocCodeSearch = new TextDoctorSearch() {
				@Override
				public void searchAfterAcceptAction() {
					getSlpDocCode().setText(getValue());
				}
			};
			slpDocCodeSearch.setBounds(150, 85, 180, 20);
			slpDocCodeSearch.setVisible(false);
		}
		return slpDocCodeSearch;
	}

	private LabelBase getSlpDocNameDesc() {
		if (slpDocNameDesc == null) {
			slpDocNameDesc = new LabelBase();
			slpDocNameDesc.setText("Doctor Name");
			slpDocNameDesc.setBounds(20, 110, 120, 20);
		}
		return slpDocNameDesc;
	}

	private TextReadOnly getSlpDocName() {
		if (slpDocName == null) {
			slpDocName = new TextReadOnly();
			slpDocName.setBounds(150, 110, 180, 20);
		}
		return slpDocName;
	}

	private LabelBase getSlpRegOPCatDesc() {
		if (slpRegOPCatDesc == null) {
			slpRegOPCatDesc = new LabelBase();
			slpRegOPCatDesc.setText("Registration Category");
			slpRegOPCatDesc.setBounds(20, 135, 120, 20);
		}
		return slpRegOPCatDesc;
	}

	private ComboRegOPCategory getSlpRegOPCat() {
		if (slpRegOPCat == null) {
			slpRegOPCat = new ComboRegOPCategory();
			slpRegOPCat.setBounds(150, 135, 180, 20);
		}
		return slpRegOPCat;
	}

	private LabelBase getSlpInitialAssessedDesc() {
		if (slpInitialAssessedDesc == null) {
			slpInitialAssessedDesc = new LabelBase();
			slpInitialAssessedDesc.setText("Initial Assessed");
			slpInitialAssessedDesc.setBounds(20, 160, 120, 20);
		}
		return slpInitialAssessedDesc;
	}

	private ComboBoxBase getSlpInitialAssessed() {
		if (slpInitialAssessed == null) {
			slpInitialAssessed = new ComboBoxBase("ALERTSRC_SLIP", false, true, true);
			slpInitialAssessed.setBounds(150, 160, 180, 20);
		}
		return slpInitialAssessed;
	}
}