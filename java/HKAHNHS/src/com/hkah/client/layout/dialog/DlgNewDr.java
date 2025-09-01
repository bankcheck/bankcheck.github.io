package com.hkah.client.layout.dialog;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboDocType;
import com.hkah.client.layout.combobox.ComboSex;
import com.hkah.client.layout.combobox.ComboSpecialtyCode;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextNum;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public abstract class DlgNewDr extends DialogBase {
	private final static int m_frameWidth = 580;
	private final static int m_frameHeight = 410;

	private BasePanel panel = null;
	private FieldSetBase curDocPanel = null;
	private FieldSetBase relatedDocPanel = null;

	private LabelBase doctorCodeLB = null;
	private LabelBase doctorTypeLB = null;
	private LabelBase familyNameLB = null;
	private LabelBase sexLB = null;
	private LabelBase givenNameLB = null;
	private LabelBase inpatShareLB = null;
	private LabelBase outPatShareLB = null;
	private LabelBase daycaseShareLB = null;
	private LabelBase specialtyCodeLB = null;
	private LabelBase tsdurationLB = null;
	private LabelBase minutesLB = null;
	private LabelBase activeLB = null;
	private LabelBase isDoctorLB = null;
	private LabelBase relatedDocCode = null;
	private LabelBase relatedDocFName = null;
	private LabelBase relatedDocGName = null;
	private LabelBase relatedDocCName = null;

	private TextString doctorCodeTS = null;
	private ComboDocType doctorTypeCB = null;
	private TextString familyNameTS = null;
	private ComboSex sexCB = null;
	private TextString givenNameTS = null;
	private TextNum inpatShareTS = null;
	private TextNum outPatShareTS = null;
	private TextNum daycaseShareTS = null;
	private ComboSpecialtyCode specialtyCodeCB = null;
	private TextNum tsDurationTS = null;

	private CheckBoxBase activeCheckB = null;
	private CheckBoxBase isDoctorCheckB = null;

	private TextString RTJText_relatedDocCode = null;
	private TextReadOnly RTJText_relatedDocFName = null;
	private TextReadOnly RTJText_relatedDocGName = null;
	private TextReadOnly RTJText_relatedDocCName = null;
	private TextReadOnly RTJText_relatedDocSpec = null;

	private	String errMsg = "";
	private	String[] datas = new String[12];
	private	Component[] comps = new Component[12];

	public DlgNewDr(MainFrame owner) {
		super(owner, OKCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("New Doctor Profile");
		setContentPane(getPanel());

		// change label
		getButtonById(OK).setText("Save", 'S');
	}

	public TextString getDefaultFocusComponent() {
		return getDoctorCodeTS();
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog() {
		getDoctorCodeTS().resetText();
		getDoctorTypeCB().resetText();
		getFamilyNameTS().resetText();
		getSexCB().resetText();
		getGivenNameTS().resetText();
		getInpatShareTS().resetText();
		getOutpatShareTS().resetText();
		getDaycaseShareTS().resetText();
		getSpecialtyCodeCB().resetText();
		getTsDurationTS().resetText();
		getIsDoctorCheckB().setValue(true);
		getActiveCheckB().setValue(true);

		getRTJText_RelatedDocCode().resetText();
		getRTJText_RelatedDocFName().resetText();
		getRTJText_RelatedDocGName().resetText();
		getRTJText_RelatedDocCName().resetText();
		getRTJText_RelatedDocSpec().resetText();

		setVisible(true);
	}

	@Override
	protected void doOkAction() {
		CheckAndSaveData();
	}

	private Component[] getComps() {
		Component[] comps = new Component[12];
		comps[0] = getDoctorCodeTS();
		comps[1] = getDoctorTypeCB();
		comps[2] = getFamilyNameTS();
		comps[3] = getSexCB();
		comps[4] = getGivenNameTS();
		comps[5] = getInpatShareTS();
		comps[6] = getOutpatShareTS();
		comps[7] = getDaycaseShareTS();
		comps[8] = getSpecialtyCodeCB();
		comps[9] = getTsDurationTS();
		comps[10] = getActiveCheckB();
		comps[11] = getIsDoctorCheckB();
		return comps;
	}

	private String[] getDatas() {
		String[] datas = new String[12];
		datas[0] = getDoctorCodeTS().getText();
		datas[1] = getDoctorTypeCB().getText();
		datas[2] = getFamilyNameTS().getText();
		datas[3] = getSexCB().getText();
		datas[4] = getGivenNameTS().getText();
		datas[5] = getInpatShareTS().getText();
		datas[6] = getOutpatShareTS().getText();
		datas[7] = getDaycaseShareTS().getText();
		datas[8] = getSpecialtyCodeCB().getText();
		datas[9] = getTsDurationTS().getText();
		datas[10] = getActiveCheckB().isSelected()? ConstantsVariable.MINUS_ONE_VALUE:ConstantsVariable.ZERO_VALUE;
		datas[11] = getIsDoctorCheckB().isSelected()? ConstantsVariable.MINUS_ONE_VALUE:ConstantsVariable.ZERO_VALUE;
		return datas;
	}

	private String[] getTexts() {
		String[] datas = new String[12];
		datas[0]= getDoctorCodeLB().getText();
		datas[1]= getDoctorTypeLB().getText();
		datas[2]= getFamilyNameLB().getText();
		datas[3]= getSexLB().getText();
		datas[4]= getGivenNameLB().getText();
		datas[5]= getInpatShareLB().getText();
		datas[6]= getOutpatShareLB().getText();
		datas[7]= getDaycaseShareLB().getText();
		datas[8]= getSpecialtyCodeLB().getText();
		datas[9]= getTsDurationLB().getText();
		datas[10]= getActiveLB().getText();
		datas[11]= getIsDoctorLB().getText();
		return datas;
	}

	private void checkDataReady(boolean ready,String errMsg, Component comp) {
		if (ready==true) {
			System.out.println("save begin==============");
			QueryUtil.executeMasterAction(getUserInfo(), "DOCTOR", QueryUtil.ACTION_APPEND,
					new String[] {
						datas[0],
						datas[2],
						datas[4],
						null,
						null,
						datas[3],
						datas[8],
						datas[10],
						datas[1],
						datas[5],
						datas[6],
						datas[7],
						null,
						null,
						null,
						null,
						null,
						null,
						datas[9],
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						datas[11],
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						ConstantsVariable.MINUS_ONE_VALUE,
						null,
						null,
						null,
						null,
						null,
						null,
						null,	//company
						getRTJText_RelatedDocCode().getText(),	//related doctor
						null, //EHRUID
						null,
						null,
						getUserInfo().getSiteCode(),	//site code,
						getUserInfo().getUserID()

					},
					new MessageQueueCallBack() {
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						Factory.getInstance().addInformationMessage("Save successful!");
						createNewDRComplete(datas[0]);
						dispose();
					}
				}
			});
		} else {
			Factory.getInstance().addErrorMessage(errMsg, comp);
			errMsg = "";
		}
	}

	public abstract void createNewDRComplete(String docCode);

	private void checkCopyRelDocInfo() {
		if (getRTJText_RelatedDocFName().getText()!=null && getRTJText_RelatedDocFName().getText().length()>0 &&
				getRTJText_RelatedDocGName().getText()!=null && getRTJText_RelatedDocGName().getText().length()>0 &&
				(!getFamilyNameTS().getText().trim().equals(getRTJText_RelatedDocFName().getText().trim()) ||
				!getGivenNameTS().getText().trim().equals(getRTJText_RelatedDocGName().getText().trim()) ||
				!getSpecialtyCodeCB().getText().trim().equals(getRTJText_RelatedDocSpec().getText().trim()))) {
			MessageBoxBase.confirm(ConstantsMessage.MSG_PBA_SYSTEM, "RELATED Doctor Name or Specialty Code difference with NEW Doctor. Do you want to copy the RELATED Doctor details to NEW Doctor? ",
					new Listener<MessageBoxEvent>() {
						@Override
						public void handleEvent(MessageBoxEvent be) {
							if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
								System.err.println("[YES]");
								checkDataReady(true,"", null);
							} else {
								System.err.println("[select NO]");
							}
						}
					});
		} else {
			System.err.println("[SAME]");
			checkDataReady(true,"", null);
		}
	}

	private void CheckAndSaveData() {
		datas = getDatas();
		comps = getComps();
		String[] texts = getTexts();
		for (int i = 0; i < datas.length; i++) {
			if (datas[i] == null||datas[i].trim().length() == 0) {
				 errMsg = texts[i]+ " is empty.";
				 checkDataReady(false, errMsg, comps[i]);
				 return ;
			}
		}

		try {
			if (!(0<=Integer.valueOf(datas[5])&&Integer.valueOf(datas[5])<=100)) {
				 errMsg = texts[5] +" is invalid.";
				 checkDataReady(false, errMsg, comps[5]);
			} else {
				try {
					if (!(0 <= Integer.valueOf(datas[6])&&Integer.valueOf(datas[6])<=100)) {
						 errMsg = texts[6] +" is invalid.";
						 checkDataReady(false, errMsg, comps[6]);
					} else {
						try {
							if (!(0 <= Integer.valueOf(datas[7]) && Integer.valueOf(datas[7]) <= 100)) {
								 errMsg = texts[7] +" is invalid.";
								 checkDataReady(false, errMsg, comps[7]);
							} else {
								try {
									if (!datas[9].equals((Integer.valueOf(datas[9]).toString()))) {
										 errMsg = texts[7] +" is invalid.";
										 checkDataReady(false, errMsg, comps[9]);
									} else {
										System.out.println("save begin------doccode="+datas[0]);

										QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
												new String[] {"Doctor", "DocCODE", "DocCODE='"+datas[0]+"'"},
												new MessageQueueCallBack() {
											@Override
											public void onPostSuccess(MessageQueue mQueue) {
												if (mQueue.success()) {
													String errMsg = ConstantsMessage.MSG_DUPLICATE_RECORD;
													checkDataReady(false, errMsg, comps[0]);
												} else {
													checkCopyRelDocInfo();
//													checkDataReady(true,"", null);
												}
											}
										});
										System.out.println("save end------");
									}
								} catch (Exception e) {
									errMsg = texts[7] +" is invalid.";
									checkDataReady(false, errMsg, comps[7]);
								}
							}
						} catch (Exception e) {
							errMsg = texts[7] +" is invalid.";
							checkDataReady(false, errMsg, comps[7]);
						}
					}
				} catch (Exception e) {
					errMsg = texts[6] +" is invalid.";
					checkDataReady(false, errMsg, comps[6]);
				}
			}
		} catch (Exception e) {
			errMsg = texts[5] +" is invalid.";
			checkDataReady(false, errMsg, comps[5]);
		}
	}

	private void getDocInfo(String docCode) {
		if (docCode != null && docCode.length() > 0) {
			QueryUtil.executeMasterFetch(getUserInfo(), "DOCTOR",
					new String[] { docCode },
					new MessageQueueCallBack() {
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						String docFName = mQueue.getContentField()[1];
						String docGName = mQueue.getContentField()[2];
						String docCName = mQueue.getContentField()[3];
						String specCode = mQueue.getContentField()[7];
						String docSex = mQueue.getContentField()[5];
						getRTJText_RelatedDocFName().setText(docFName);
						getRTJText_RelatedDocGName().setText(docGName);
						getRTJText_RelatedDocCName().setText(docCName);
						getRTJText_RelatedDocSpec().setText(specCode);
						getFamilyNameTS().setText(docFName);
						getGivenNameTS().setText(docGName);
						getSexCB().setText(docSex);
						getSpecialtyCodeCB().setText(specCode);
					} else {
						getRelatedDocCode().resetText();
						getRTJText_RelatedDocFName().resetText();
						getRTJText_RelatedDocGName().resetText();
						getRTJText_RelatedDocCName().resetText();
						Factory.getInstance().addErrorMessage("Invalid doctor code.", getRelatedDocCode());
					}
				}
			});
		} else {
			getRelatedDocCode().resetText();
		}
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	private BasePanel getPanel() {
		if (panel == null) {
			panel = new BasePanel();
//			panel.setSize(410, 200);
			panel.add(getCurDocPanel(), null);
			panel.add(getRelDocInfoPanel(), null);
		}
		return panel;
	}

	public FieldSetBase getCurDocPanel() {
		if (curDocPanel == null) {
			curDocPanel = new FieldSetBase();
			curDocPanel.setBounds(5, 5, 540, 200);
			curDocPanel.setHeading("New Doctor Profile");
			curDocPanel.add(getDoctorCodeLB(), null);
			curDocPanel.add(getDoctorCodeTS(), null);
			curDocPanel.add(getDoctorTypeLB(), null);
			curDocPanel.add(getDoctorTypeCB(), null);

			curDocPanel.add(getFamilyNameLB(), null);
			curDocPanel.add(getFamilyNameTS(), null);
			curDocPanel.add(getSexLB(), null);
			curDocPanel.add(getSexCB(), null);

			curDocPanel.add(getGivenNameLB(), null);
			curDocPanel.add(getGivenNameTS(), null);

			curDocPanel.add(getInpatShareLB(), null);
			curDocPanel.add(getInpatShareTS(), null);
			curDocPanel.add(getOutpatShareLB(), null);
			curDocPanel.add(getOutpatShareTS(), null);
			curDocPanel.add(getDaycaseShareLB(), null);
			curDocPanel.add(getDaycaseShareTS(), null);

			curDocPanel.add(getSpecialtyCodeLB(), null);
			curDocPanel.add(getSpecialtyCodeCB(), null);
			curDocPanel.add(getTsDurationLB(), null);
			curDocPanel.add(getTsDurationTS(), null);
			curDocPanel.add(getMinutesLB(), null);

			curDocPanel.add(getActiveLB(), null);
			curDocPanel.add(getActiveCheckB(), null);
			curDocPanel.add(getIsDoctorLB(), null);
			curDocPanel.add(getIsDoctorCheckB(), null);
		}
		return curDocPanel;
	}

	public FieldSetBase getRelDocInfoPanel() {
		if (relatedDocPanel == null) {
			relatedDocPanel = new FieldSetBase();
			relatedDocPanel.setBounds(5, 210, 540, 110);
			relatedDocPanel.setHeading("Related Doctor Info");
			relatedDocPanel.add(getRelatedDocCode(), null);
			relatedDocPanel.add(getRTJText_RelatedDocCode(), null);
			relatedDocPanel.add(getRelatedDocFName(), null);
			relatedDocPanel.add(getRTJText_RelatedDocFName(), null);
			relatedDocPanel.add(getRelatedDocGName(), null);
			relatedDocPanel.add(getRTJText_RelatedDocGName(), null);
			relatedDocPanel.add(geRelatedDocCName(), null);
			relatedDocPanel.add(getRTJText_RelatedDocCName(), null);
			relatedDocPanel.add(getRTJText_RelatedDocSpec(), null);
		}
		return relatedDocPanel;
	}

	private LabelBase getDoctorCodeLB() {
		if (doctorCodeLB == null) {
			doctorCodeLB = new LabelBase("Doctor Code");
			doctorCodeLB.setBounds(10, 10, 100, 20);
		}
		return doctorCodeLB;
	}

	private TextString getDoctorCodeTS() {
		if (doctorCodeTS == null) {
			doctorCodeTS = new TextString(10);
			doctorCodeTS.setBounds(95, 10, 180, 20);
		}
		return doctorCodeTS;
	}

	private LabelBase getDoctorTypeLB() {
		if (doctorTypeLB == null) {
			doctorTypeLB = new LabelBase("Doctor Type");
			doctorTypeLB.setBounds(305, 10, 75, 20);
		}
		return doctorTypeLB;
	}

	private ComboDocType getDoctorTypeCB() {
		if (doctorTypeCB == null) {
			doctorTypeCB = new ComboDocType();
			doctorTypeCB.setBounds(390, 10, 120, 20);
		}
		return doctorTypeCB;
	}

	private LabelBase getFamilyNameLB() {
		if (familyNameLB == null) {
			familyNameLB = new LabelBase("Family Name");
			familyNameLB.setBounds(10, 35, 80, 20);
		}
		return familyNameLB;
	}

	private TextString getFamilyNameTS() {
		if (familyNameTS == null) {
			familyNameTS = new TextString();
			familyNameTS.setBounds(95, 35, 180, 20);
		}
		return familyNameTS;
	}

	private LabelBase getSexLB() {
		if (sexLB == null) {
			sexLB = new LabelBase("Sex");
			sexLB.setBounds(305, 35, 75, 20);
		}
		return sexLB;
	}

	private ComboSex getSexCB() {
		if (sexCB == null) {
			sexCB = new ComboSex();
			sexCB.setBounds(390, 35, 120, 20);
		}
		return sexCB;
	}

	private LabelBase getGivenNameLB() {
		if (givenNameLB == null) {
			givenNameLB = new LabelBase("Given Name");
			givenNameLB.setBounds(10, 60, 70, 20);
		}
		return givenNameLB;
	}

	private TextString getGivenNameTS() {
		if (givenNameTS == null) {
			givenNameTS = new TextString();
			givenNameTS.setBounds(95, 60, 180, 20);
		}
		return givenNameTS;
	}

	private LabelBase getInpatShareLB() {
		if (inpatShareLB == null) {
			inpatShareLB = new LabelBase("Inpat % Share");
			inpatShareLB.setBounds(10, 85, 100, 20);
		}
		return inpatShareLB;
	}

	private TextNum getInpatShareTS() {
		if (inpatShareTS == null) {
			inpatShareTS = new TextNum(3,0);
			inpatShareTS.setBounds(95, 85, 60, 20);
		}
		return inpatShareTS;
	}

	private LabelBase getOutpatShareLB() {
		if (outPatShareLB == null) {
			outPatShareLB = new LabelBase("Outpat % Share");
			outPatShareLB.setBounds(165, 85, 100, 20);
		}
		return outPatShareLB;
	}

	private TextNum getOutpatShareTS() {
		if (outPatShareTS == null) {
			outPatShareTS = new TextNum(3,0);
			outPatShareTS.setBounds(260, 85, 60, 20);
		}
		return outPatShareTS;
	}

	private LabelBase getDaycaseShareLB() {
		if (daycaseShareLB == null) {
			daycaseShareLB= new LabelBase("Daycase % Share");
			daycaseShareLB.setBounds(330, 85, 100, 20);
		}
		return daycaseShareLB;
	}

	private TextNum getDaycaseShareTS() {
		if (daycaseShareTS == null) {
			daycaseShareTS = new TextNum(3,0);
			daycaseShareTS.setBounds(430, 85,60, 20);
		}
		return daycaseShareTS;
	}

	private LabelBase getSpecialtyCodeLB() {
		if (specialtyCodeLB == null) {
			specialtyCodeLB = new LabelBase("Specialty Code");
			specialtyCodeLB.setBounds(10, 110, 100, 20);
		}
		return specialtyCodeLB;
	}

	private ComboSpecialtyCode getSpecialtyCodeCB() {
		if (specialtyCodeCB == null) {
			specialtyCodeCB = new ComboSpecialtyCode();
			specialtyCodeCB.setBounds(95, 110, 180, 20);
		}
		return specialtyCodeCB;
	}

	private LabelBase getTsDurationLB() {
		if (tsdurationLB == null) {
			tsdurationLB = new LabelBase("Time Slot Duration");
			tsdurationLB.setBounds(305, 110, 110, 20);
		}
		return tsdurationLB;
	}

	private TextNum getTsDurationTS() {
		if (tsDurationTS == null) {
			tsDurationTS = new TextNum(2,0);
			tsDurationTS.setBounds(415, 110, 50, 20);
		}
		return tsDurationTS;
	}

	private LabelBase getMinutesLB() {
		if (minutesLB == null) {
			minutesLB = new LabelBase("minute(s)");
			minutesLB.setBounds(470, 110, 60, 20);
		}
		return minutesLB;
	}

	private LabelBase getActiveLB() {
		if (activeLB == null) {
			activeLB = new LabelBase("Active");
			activeLB.setBounds(10, 135, 70, 20);
		}
		return activeLB;
	}

	private CheckBoxBase getActiveCheckB() {
		if (activeCheckB == null) {
			activeCheckB = new CheckBoxBase();
			activeCheckB.setBounds(95, 135, 20, 20);
		}
		return activeCheckB;
	}

	private LabelBase getIsDoctorLB() {
		if (isDoctorLB == null) {
			isDoctorLB = new LabelBase("Is Doctor");
			isDoctorLB.setBounds(200, 135, 85, 20);
		}
		return isDoctorLB;
	}

	private CheckBoxBase getIsDoctorCheckB() {
		if (isDoctorCheckB == null) {
			isDoctorCheckB = new CheckBoxBase();
			isDoctorCheckB.setBounds(295, 135, 20, 20);
		}
		return isDoctorCheckB;
	}

	private LabelBase getRelatedDocCode() {
		if (relatedDocCode == null) {
			relatedDocCode = new LabelBase("Doctor Code");
			relatedDocCode.setBounds(10, 10, 80, 20);
		}
		return relatedDocCode;
	}

	public TextString getRTJText_RelatedDocCode() {
		if (RTJText_relatedDocCode == null) {
			RTJText_relatedDocCode = new TextString(10) {
				@Override
				public void onBlur() {
					getDocInfo(RTJText_relatedDocCode.getText());
				}
			};
			RTJText_relatedDocCode.setBounds(95, 10, 100, 20);
		}
		return RTJText_relatedDocCode;
	}

	private LabelBase getRelatedDocFName() {
		if (relatedDocFName == null) {
			relatedDocFName = new LabelBase("Family Name");
			relatedDocFName.setBounds(200, 10, 80, 20);
		}
		return relatedDocFName;
	}

	public TextReadOnly getRTJText_RelatedDocFName() {
		if (RTJText_relatedDocFName == null) {
			RTJText_relatedDocFName = new TextReadOnly();
			RTJText_relatedDocFName.setBounds(275, 10, 80, 20);
		}
		return RTJText_relatedDocFName;
	}

	private LabelBase getRelatedDocGName() {
		if (relatedDocGName == null) {
			relatedDocGName = new LabelBase("Given Name");
			relatedDocGName.setBounds(360, 10, 70, 20);
		}
		return relatedDocGName;
	}

	public TextReadOnly getRTJText_RelatedDocGName() {
		if (RTJText_relatedDocGName == null) {
			RTJText_relatedDocGName = new TextReadOnly();
			RTJText_relatedDocGName.setBounds(435, 10, 100, 20);
		}
		return RTJText_relatedDocGName;
	}

	private LabelBase geRelatedDocCName() {
		if (relatedDocCName == null) {
			relatedDocCName = new LabelBase("Doctor Chinese Name");
			relatedDocCName.setBounds(10, 35, 80, 20);
		}
		return relatedDocCName;
	}

	public TextReadOnly getRTJText_RelatedDocCName() {
		if (RTJText_relatedDocCName == null) {
			RTJText_relatedDocCName = new TextReadOnly();
			RTJText_relatedDocCName.setBounds(95, 35, 100, 20);
		}
		return RTJText_relatedDocCName;
	}

	public TextReadOnly getRTJText_RelatedDocSpec() {
		if (RTJText_relatedDocSpec == null) {
			RTJText_relatedDocSpec = new TextReadOnly();
			RTJText_relatedDocSpec.setBounds(200, 35, 100, 20);
		}
		return RTJText_relatedDocSpec;
	}
}