package com.hkah.client.layout.dialog;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Component;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgInsuranceOptions extends DialogBase {
	private final static int m_frameWidth = 550;
	private final static int m_frameHeight = 600;
	
	private String memActID = EMPTY_VALUE;
	private String memType = EMPTY_VALUE;
	
	private BasePanel contentPanel = null;
	/* Part A Registration */
	private LabelBase registrationDesc = null;

	private LabelBase checkList01Desc = null;
	private CheckBoxBase checkList01 = null;	
	private LabelBase checkList02Desc = null;
	private CheckBoxBase checkList2 = null;
	private LabelBase checkList03Desc = null;
	private CheckBoxBase checkList03 = null;	
	private LabelBase checkList04Desc = null;
	private CheckBoxBase checkList04 = null;
	private LabelBase checkList05Desc = null;
	private CheckBoxBase checkList05 = null;	
	private LabelBase getCheckList06Desc = null;
	private CheckBoxBase getCheckList06 = null;
	private LabelBase checkList07Desc = null;
	private CheckBoxBase checkList07 = null;	
	private LabelBase checkList08Desc = null;
	private CheckBoxBase checkList08 = null;
	private LabelBase checkList09Desc = null;
	private CheckBoxBase checkList09 = null;	
	private LabelBase checkList10Desc = null;
	private CheckBoxBase checkList10 = null;
	private LabelBase checkList11Desc = null;
	private CheckBoxBase checkList11 = null;
	private LabelBase checkList12Desc = null;
	private CheckBoxBase checkList12 = null;	
	private LabelBase checkList13Desc = null;
	private CheckBoxBase checkList13 = null;	
	private LabelBase getCheckList14Desc = null;
	private LabelBase getCheckList15Desc = null;	
	private CheckBoxBase checkList14 = null;
	private CheckBoxBase checkList15 = null;	
	private TextString checkList14Remark = null;
	private TextString checkList15Remark = null;
	/* Part B Payment */
	private LabelBase paymentDesc = null;
	private LabelBase checkList16Desc = null;
	private CheckBoxBase checkList16 = null;
	private LabelBase checkList17Desc = null;
	private CheckBoxBase checkList17 = null;
	private LabelBase checkList18Desc = null;
	private CheckBoxBase checkList18 = null;	
	private LabelBase checkList19Desc = null;
	private CheckBoxBase checkList19 = null;
	private TextString checkList19Remark = null;
	private LabelBase checkList20Desc = null;
	private CheckBoxBase checkList20 = null;
	private TextString checkList20Remark = null;
	private CheckBoxBase checkList21 = null;
	private LabelBase checkList21Desc = null;	
	private CheckBoxBase checkList22 = null;
	private LabelBase checkList22Desc = null;	
	
	private ButtonBase saveButton = null;	
	
	public DlgInsuranceOptions(MainFrame owner) {
		super(owner, m_frameWidth, m_frameHeight);
		initialize();
	}
	
	private void initialize() {
		setTitle("Checklist");
		setContentPane(getOptionsPanel());
	}
	
	@Override
	public Component getDefaultFocusComponent() {
		return null;
	}

	public void showDialog(String arCode, String actID, String type) {
		setVisible(true);
		resetContent();
		memActID = actID;
		memType = type;
		QueryUtil.executeMasterBrowse(getUserInfo(), "ARCHECKLIST",
				new String[] { actID, type },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success() && mQueue.getContentField().length > 0) {
					String[] outParam = mQueue.getContentField();
					int index = 0;

					//Regstration Checklist
					getCheckList01().setSelected(MINUS_ONE_VALUE.equals(outParam[index++])); // [01][R][Policy card/certificate photocopy]
					getCheckList02().setSelected(MINUS_ONE_VALUE.equals(outParam[index++])); // [02][R][Accept by LOG/ LOA]					
					getCheckList03().setSelected(MINUS_ONE_VALUE.equals(outParam[index++])); // [03][R][Phone eligibility confirmation]
					getCheckList04().setSelected(MINUS_ONE_VALUE.equals(outParam[index++])); // [04][R][Accept by Benefit Table from Portal]
					getCheckList05().setSelected(MINUS_ONE_VALUE.equals(outParam[index++])); // [05][R][Passport/ ID photocopy]
					getCheckList06().setSelected(MINUS_ONE_VALUE.equals(outParam[index++])); // [06][R][Admission Acknowledgement]
					getCheckList07().setSelected(MINUS_ONE_VALUE.equals(outParam[index++])); // [07][R][Cost estimation]
					getCheckList08().setSelected(MINUS_ONE_VALUE.equals(outParam[index++])); // [08][R][Claim form]
					getCheckList09().setSelected(MINUS_ONE_VALUE.equals(outParam[index++])); // [09][R][Voucher]
					getCheckList10().setSelected(MINUS_ONE_VALUE.equals(outParam[index++])); // [10][R][HKAH-SR Consent]
					getCheckList11().setSelected(MINUS_ONE_VALUE.equals(outParam[index++])); // [11][R][Medical Report]
					getCheckList12().setSelected(MINUS_ONE_VALUE.equals(outParam[index++])); // [12][R][Diagnosis Label]
					getCheckList13().setSelected(MINUS_ONE_VALUE.equals(outParam[index++])); // [13][R][Memo to Doctor]					
					getCheckList14().setSelected(MINUS_ONE_VALUE.equals(outParam[index++])); // [14][R][Other1]					
					getCheckList15().setSelected(MINUS_ONE_VALUE.equals(outParam[index++])); // [15][R][Other2]					

					//Payment Checklist
					getCheckList16().setSelected(MINUS_ONE_VALUE.equals(outParam[index++])); // [16][P][Collect Co-pay/ Deductible / Exclusions]					
					getCheckList17().setSelected(MINUS_ONE_VALUE.equals(outParam[index++])); // [17][P][Collect Exceeding amount]
					getCheckList18().setSelected(MINUS_ONE_VALUE.equals(outParam[index++])); // [18][P][Further Guarantee for exceeded amount]					
					getCheckList19().setSelected(MINUS_ONE_VALUE.equals(outParam[index++])); // [19][P][Other1]
					getCheckList20().setSelected(MINUS_ONE_VALUE.equals(outParam[index++])); // [20][P][Other2]
					getCheckList21().setSelected(MINUS_ONE_VALUE.equals(outParam[index++])); // [19][P][discharge summary]
					getCheckList22().setSelected(MINUS_ONE_VALUE.equals(outParam[index++])); // [20][P][medication breakdown]					
										
					/*
					01	R	Accept by card/ policy cert, make photocopy
					02	R	Accept by LOG/ LOA
					03	R	Phone eligibility confirmation (make slip remark)
					04	R	Accept by Benefit Table from Portal
					05	R	Passport/ ID photocopy
					06	R	Admission Acknowledgement 
					07	R	Cost estimation
					08	R	Claim form
					09	R	Voucher
					10	R	HKAH-SR Consent
					11	R	Medical Report
					12	R	Diagnosis Label
					13	R	Memo to Doctor
					14	R	Other1
					15	R	Other2
					16	P	Collect Co-pay/ Deductible / Exclusions
					17	P	Collect Exceeding amount
					18	P	Further Guarantee for exceeded amount					
					19	P	Other1
					20	P	Other2
					21	P	discharge summary -- DISABLED
					22	P	medication breakdown*/					
				}
			}
		});
		
		QueryUtil.executeMasterBrowse(getUserInfo(), "ARCHECKLIST_RMK",
				new String[] { actID, type, "14", "15", "19", "20" },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success() && mQueue.getContentField().length > 0) {
					String[] outParam = mQueue.getContentField();
					int index = 0;
					
					getCheckList14Remark().setText(outParam[index++]); // [14][P][Other1]					
					getCheckList15Remark().setText(outParam[index++]); // [15][P][Other2]					
					getcheckList19Remark().setText(outParam[index++]); // [19][P][Other1]
					getcheckList20Remark().setText(outParam[index++]); // [20][P][Other2]					

					/*
					01	R	Accept by card/ policy cert, make photocopy
					02	R	Accept by LOG/ LOA
					03	R	Phone eligibility confirmation (make slip remark)
					04	R	Accept by Benefit Table from Portal
					05	R	Passport/ ID photocopy
					06	R	Admission Acknowledgement 
					07	R	Cost estimation
					08	R	Claim form
					09	R	Voucher
					10	R	HKAH-SR Consent
					11	R	Medical Report
					12	R	Diagnosis Label
					13	R	Memo to Doctor
					14	R	Other1
					15	R	Other2
					16	P	Collect Co-pay/ Deductible / Exclusions
					17	P	Collect Exceeding amount
					18	P	Further Guarantee for exceeded amount
					19	P	Other1
					20	P	Other2
					21	P	discharge summary
					22	P	medication breakdown*/					
				}
			}
		});						
	}
	
	private void resetContent() {
		
	}
	
	private String[] getInputParamaters() {
		return new String[] {
				memActID,
				memType,
				getCheckList01().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE, // Accept by card/ policy cert, make photocopy
				getCheckList02().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE, // Accept by LOG/ LOA
				getCheckList03().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE, // Phone eligibility confirmation (make slip remark)						
				getCheckList04().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE, // Accept by Benefit Table from Portal						
				getCheckList05().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE, // Passport/ ID photocopy
				getCheckList06().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE, // Admission Acknowledgement						
				getCheckList07().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE, // Cost estimation
				getCheckList08().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE, // Claim form
				getCheckList09().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE, // Voucher
				getCheckList10().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE, // HKAH-SR Consent
				getCheckList11().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE, // Medical Report
				getCheckList12().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE, // Diagnosis Label						
				getCheckList13().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE, // Memo to Doctor
				getCheckList14().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE, // Other1
				getCheckList15().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE, // Other2						
				getCheckList16().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE, // Collect Co-pay/ Deductible / Exclusions
				getCheckList17().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE, // Collect Exceeding amount						
				getCheckList18().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE, // Further Guarantee for exceeded amount						
				getCheckList19().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE, // Other1						
				getCheckList20().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE, // Other2
				ZERO_VALUE, // discharge summary -- DISABLED						
				getCheckList22().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE, // medication breakdown						
				getCheckList14Remark().getText(), // Other1
				getCheckList15Remark().getText(), // Other2						
				getcheckList19Remark().getText(), // Other1
				getcheckList20Remark().getText() // Other2						
		};
	}	
	
	protected BasePanel getOptionsPanel() {
		if (contentPanel == null) {
			contentPanel = new BasePanel();
			contentPanel.add(getRegistrationDesc(), null);
			contentPanel.add(getCheckList01Desc(), null);
			contentPanel.add(getCheckList01(), null);			
			contentPanel.add(getCheckList02Desc(), null);
			contentPanel.add(getCheckList02(), null);
			contentPanel.add(getCheckList03Desc(), null);
			contentPanel.add(getCheckList03(), null);
			contentPanel.add(getCheckList04Desc(), null);
			contentPanel.add(getCheckList04(), null);			
			contentPanel.add(getCheckList05Desc(), null);
			contentPanel.add(getCheckList05(), null);			
			contentPanel.add(getCheckList06Desc(), null);
			contentPanel.add(getCheckList06(), null);
			contentPanel.add(getCheckList07Desc(), null);
			contentPanel.add(getCheckList07(), null);
			contentPanel.add(getCheckList08Desc(), null);
			contentPanel.add(getCheckList08(), null);
			contentPanel.add(getCheckList09Desc(), null);
			contentPanel.add(getCheckList09(), null);			
			contentPanel.add(getCheckList10Desc(), null);
			contentPanel.add(getCheckList10(), null);
			contentPanel.add(getCheckList11Desc(), null);
			contentPanel.add(getCheckList11(), null);
			contentPanel.add(getCheckList12Desc(), null);
			contentPanel.add(getCheckList12(), null);
			contentPanel.add(getCheckList13Desc(), null);
			contentPanel.add(getCheckList13(), null);
			contentPanel.add(getCheckList14Desc(), null);
			contentPanel.add(getCheckList15Desc(), null);
			contentPanel.add(getCheckList14(), null);			
			contentPanel.add(getCheckList15(), null);
			contentPanel.add(getCheckList14Remark(), null);			
			contentPanel.add(getCheckList15Remark(), null);
			contentPanel.add(getPaymentDesc(), null);
			contentPanel.add(getCheckList11Desc(), null);
			contentPanel.add(getCheckList11(), null);
			contentPanel.add(getCheckList09Desc(), null);
			contentPanel.add(getCheckList09(), null);
			contentPanel.add(getCheckList16Desc(), null);
			contentPanel.add(getCheckList16(), null);
			contentPanel.add(getCheckList17Desc(), null);
			contentPanel.add(getCheckList17(), null);
			contentPanel.add(getCheckList18Desc(), null);
			contentPanel.add(getCheckList18(), null);			
//			contentPanel.add(getCheckList21Desc(), null);
//			contentPanel.add(getCheckList21(), null);	
			contentPanel.add(getCheckList22Desc(), null);
			contentPanel.add(getCheckList22(), null);				
			contentPanel.add(getcheckList19Desc(), null);
			contentPanel.add(getCheckList19(), null);
			contentPanel.add(getcheckList19Remark(), null);
			contentPanel.add(getcheckList20Desc(), null);
			contentPanel.add(getCheckList20(), null);			
			contentPanel.add(getcheckList20Remark(), null);			
			contentPanel.add(getSaveButton(), null);
		}
		return contentPanel;
	}
	
	/**
	 * @return the registrationDesc
	 */
	private LabelBase getRegistrationDesc() {
		if (registrationDesc == null) {
			registrationDesc = new LabelBase();
			registrationDesc.setText("<b>Registration</b>");
			registrationDesc.setBounds(5, 5, 200, 20);
		}
		return registrationDesc;
	}
	
	/**
	 * @return the checkList01Desc
	 */
	private LabelBase getCheckList01Desc() {
		if (checkList01Desc == null) {
			checkList01Desc = new LabelBase();
			checkList01Desc.setText("Accept by card/ policy cert, make photocopy");
			checkList01Desc.setBounds(5, 30, 200, 20);
		}
		return checkList01Desc;
	}

	/**
	 * @return the checkList01
	 */
	private CheckBoxBase getCheckList01() {
		if (checkList01 == null) {
			checkList01 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			checkList01.setBounds(210, 30, 20, 20);
		}
		return checkList01;
	}	

	/**
	 * @return the checkList02Desc
	 */
	private LabelBase getCheckList02Desc() {
		if (checkList02Desc == null) {
			checkList02Desc = new LabelBase();
			checkList02Desc.setText("Accept by LOG/ LOA");
			checkList02Desc.setBounds(5, 55, 200, 20);
		}
		return checkList02Desc;
	}

	/**
	 * @return the checkList2
	 */
	private CheckBoxBase getCheckList02() {
		if (checkList2 == null) {
			checkList2 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			checkList2.setBounds(210, 55, 20, 20);
		}
		return checkList2;
	}
	
	/**
	 * @return the checkList04Desc
	 */
	private LabelBase getCheckList03Desc() {
		if (checkList03Desc == null) {
			checkList03Desc = new LabelBase();
			checkList03Desc.setText("Phone eligibility confirmation (make slip remark)");
			checkList03Desc.setBounds(5, 90, 200, 20);
		}
		return checkList03Desc;
	}

	/**
	 * @return the checkList03
	 */
	private CheckBoxBase getCheckList03() {
		if (checkList03 == null) {
			checkList03 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			checkList03.setBounds(210, 90, 20, 20);
		}
		return checkList03;
	}
	
	/**
	 * @return the checkList04Desc
	 */
	private LabelBase getCheckList04Desc() {
		if (checkList04Desc == null) {
			checkList04Desc = new LabelBase();
			checkList04Desc.setText("Accept by Benefit Table from Portal");
			checkList04Desc.setBounds(5, 125, 200, 20);
		}
		return checkList04Desc;
	}

	/**
	 * @return the checkList04
	 */
	private CheckBoxBase getCheckList04() {
		if (checkList04 == null) {
			checkList04 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			checkList04.setBounds(210, 125, 20, 20);
		}
		return checkList04;
	}	

	/**
	 * @return the checkList05Desc
	 */
	private LabelBase getCheckList05Desc() {
		if (checkList05Desc == null) {
			checkList05Desc = new LabelBase();
			checkList05Desc.setText("Passport / ID copy");
			checkList05Desc.setBounds(5, 150, 200, 20);
		}
		return checkList05Desc;
	}

	/**
	 * @return the checkList05
	 */
	private CheckBoxBase getCheckList05() {
		if (checkList05 == null) {
			checkList05 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			checkList05.setBounds(210, 150, 20, 20);
		}
		return checkList05;
	}
	
	/**
	 * @return the getCheckList06Desc
	 */
	private LabelBase getCheckList06Desc() {
		if (getCheckList06Desc == null) {
			getCheckList06Desc = new LabelBase();
			getCheckList06Desc.setText("Admission Acknowledgement");
			getCheckList06Desc.setBounds(5, 175, 200, 20);
		}
		return getCheckList06Desc;
	}

	/**
	 * @return the getCheckList06
	 */
	private CheckBoxBase getCheckList06() {
		if (getCheckList06 == null) {
			getCheckList06 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			getCheckList06.setBounds(210, 175, 20, 20);
		}
		return getCheckList06;
	}	
		
	/**
	 * @return the checkList07Desc
	 */
	private LabelBase getCheckList07Desc() {
		if (checkList07Desc == null) {
			checkList07Desc = new LabelBase();
			checkList07Desc.setText("Cost estimation");
			checkList07Desc.setBounds(5, 200, 200, 20);
		}
		return checkList07Desc;
	}

	/**
	 * @return the checkList07
	 */
	private CheckBoxBase getCheckList07() {
		if (checkList07 == null) {
			checkList07 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			checkList07.setBounds(210, 200, 20, 20);
		}
		return checkList07;
	}	

	/**
	 * @return the checkList08Desc
	 */
	private LabelBase getCheckList08Desc() {
		if (checkList08Desc == null) {
			checkList08Desc = new LabelBase();
			checkList08Desc.setText("Claim form");;
			checkList08Desc.setBounds(5, 225, 200, 20);
		}
		return checkList08Desc;
	}

	/**
	 * @return the checkList08
	 */
	private CheckBoxBase getCheckList08() {
		if (checkList08 == null) {
			checkList08 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			checkList08.setBounds(210, 225, 20, 20);
		}
		return checkList08;
	}
	
	/**
	 * @return the checkList10Desc
	 */
	private LabelBase getCheckList09Desc() {
		if (checkList09Desc == null) {
			checkList09Desc = new LabelBase();
			checkList09Desc.setText("Voucher");
			checkList09Desc.setBounds(5, 250, 200, 20);
		}
		return checkList09Desc;
	}

	/**
	 * @return the checkList10
	 */
	private CheckBoxBase getCheckList09() {
		if (checkList09 == null) {
			checkList09 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			checkList09.setBounds(210, 250, 20, 20);
		}
		return checkList09;
	}	
	
	/**
	 * @return the checkList10Desc
	 */
	private LabelBase getCheckList10Desc() {
		if (checkList10Desc == null) {
			checkList10Desc = new LabelBase();
			checkList10Desc.setText("HKAH-SR Consent");
			checkList10Desc.setBounds(5, 275, 200, 20);
		}
		return checkList10Desc;
	}

	/**
	 * @return the checkList10
	 */
	private CheckBoxBase getCheckList10() {
		if (checkList10 == null) {
			checkList10 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			checkList10.setBounds(210, 275, 20, 20);
		}
		return checkList10;
	}	

	/**
	 * @return the checkList11Desc
	 */
	private LabelBase getCheckList11Desc() {
		if (checkList11Desc == null) {
			checkList11Desc = new LabelBase();
			checkList11Desc.setText("Medical report");
			checkList11Desc.setBounds(5, 300, 200, 20);
		}
		return checkList11Desc;
	}

	/**
	 * @return the checkList11
	 */
	private CheckBoxBase getCheckList11() {
		if (checkList11 == null) {
			checkList11 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			checkList11.setBounds(210, 300, 20, 20);
		}
		return checkList11;
	}
	
	/**
	 * @return the checkList12Desc
	 */
	private LabelBase getCheckList12Desc() {
		if (checkList12Desc == null) {
			checkList12Desc = new LabelBase();
			checkList12Desc.setText("Diagnosis On Statement/Diagnosis Label");
			checkList12Desc.setBounds(5, 325, 200, 20);
		}
		return checkList12Desc;
	}

	/**
	 * @return the checkList12
	 */
	private CheckBoxBase getCheckList12() {
		if (checkList12 == null) {
			checkList12 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			checkList12.setBounds(210, 325, 20, 20);
		}
		return checkList12;
	}	

	/**
	 * @return the checkList16Desc
	 */
	private LabelBase getCheckList13Desc() {
		if (checkList13Desc == null) {
			checkList13Desc = new LabelBase();
			checkList13Desc.setText("Memo To Doctor");
			checkList13Desc.setBounds(5, 350, 200, 20);
		}
		return checkList13Desc;
	}

	/**
	 * @return the checkList13
	 */
	private CheckBoxBase getCheckList13() {
		if (checkList13 == null) {
			checkList13 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			checkList13.setBounds(210, 350, 20, 20);
		}
		return checkList13;
	}
	
	/**
	 * @return the getCheckList14Desc
	 */
	private LabelBase getCheckList14Desc() {
		if (getCheckList14Desc == null) {
			getCheckList14Desc = new LabelBase();
			getCheckList14Desc.setText("Other1");
			getCheckList14Desc.setBounds(5, 375, 200, 20);
		}
		return getCheckList14Desc;
	}
	
	/**
	 * @return the checkList14
	 */
	private CheckBoxBase getCheckList14() {
		if (checkList14 == null) {
			checkList14 = new CheckBoxBase() {
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);

					if (isSelected()) {
						getCheckList14Remark().setEnabled(true);
					}
					else {
						getCheckList14Remark().setEnabled(false);
					}
				}
			};
			checkList14.setBounds(210, 375, 20, 20);
		}
		return checkList14;
	}
	
	/**
	 * @return the checkList14Remark
	 */
	private TextString getCheckList14Remark() {
		if (checkList14Remark == null) {
			checkList14Remark = new TextString(){
				@Override
				public void onBlur() {
					if(checkList14Remark.isDirty()){
						getSaveButton().setEnabled(true);
					}
				}				
			};
			checkList14Remark.setBounds(5, 400, 200, 20);
		}
		return checkList14Remark;
	}	
	
	/**
	 * @return the getCheckList15Desc
	 */
	private LabelBase getCheckList15Desc() {
		if (getCheckList15Desc == null) {
			getCheckList15Desc = new LabelBase();
			getCheckList15Desc.setText("Other2");
			getCheckList15Desc.setBounds(5, 425, 200, 20);
		}
		return getCheckList15Desc;
	}
	
	/**
	 * @return the checkList15
	 */
	private CheckBoxBase getCheckList15() {
		if (checkList15 == null) {
			checkList15 = new CheckBoxBase() {
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);

					if (isSelected()) {
						getCheckList15Remark().setEnabled(true);
					}
					else {
						getCheckList15Remark().setEnabled(false);
					}
				}
			};
			checkList15.setBounds(210, 425, 20, 20);
		}
		return checkList15;
	}	
	
	/**
	 * @return the checkList15Remark
	 */
	private TextString getCheckList15Remark() {
		if (checkList15Remark == null) {
			checkList15Remark = new TextString(){
				@Override
				public void onBlur() {
					if(checkList15Remark.isDirty()){
						getSaveButton().setEnabled(true);
					}
				}				
			};
			checkList15Remark.setBounds(5, 450, 200, 20);
		}
		return checkList15Remark;
	}		
	
	/**
	 * @return the paymentDesc
	 */
	private LabelBase getPaymentDesc() {
		if (paymentDesc == null) {
			paymentDesc = new LabelBase();
			paymentDesc.setText("<b>Payment</b>");
			paymentDesc.setBounds(290, 5, 200, 20);
		}
		return paymentDesc;
	}	
	
	/**
	 * @return the checkList16Desc
	 */
	private LabelBase getCheckList16Desc() {
		if (checkList16Desc == null) {
			checkList16Desc = new LabelBase();
			checkList16Desc.setText("Collect Co-pay/ Deductible / Exclusions");
			checkList16Desc.setBounds(290, 30, 200, 20);
		}
		return checkList16Desc;
	}

	/**
	 * @return the checkList16
	 */
	private CheckBoxBase getCheckList16() {
		if (checkList16 == null) {
			checkList16 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			checkList16.setBounds(500, 30, 20, 20);
		}
		return checkList16;
	}
	
	/**
	 * @return the checkList17Desc
	 */
	private LabelBase getCheckList17Desc() {
		if (checkList17Desc == null) {
			checkList17Desc = new LabelBase();
			checkList17Desc.setText("Collect Exceeding amount");
			checkList17Desc.setBounds(290, 65, 200, 20);
		}
		return checkList17Desc;
	}

	/**
	 * @return the checkList17
	 */
	private CheckBoxBase getCheckList17() {
		if (checkList17 == null) {
			checkList17 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			checkList17.setBounds(500, 65, 20, 20);
		}
		return checkList17;
	}
	
	/**
	 * @return the checkList18Desc
	 */
	private LabelBase getCheckList18Desc() {
		if (checkList18Desc == null) {
			checkList18Desc = new LabelBase();
			checkList18Desc.setText("Further Guarantee for exceeded amount");
			checkList18Desc.setBounds(290, 90, 200, 20);
		}
		return checkList18Desc;
	}

	/**
	 * @return the checkList18
	 */
	private CheckBoxBase getCheckList18() {
		if (checkList18 == null) {
			checkList18 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			checkList18.setBounds(500, 90, 20, 20);
		}
		return checkList18;
	}
	
	/**
	 * @return the checkList21Desc
	 */
	private LabelBase getCheckList21Desc() {
		if (checkList21Desc == null) {
			checkList21Desc = new LabelBase();
			checkList21Desc.setText("Discharge Summary");
			checkList21Desc.setBounds(290, 130, 200, 20);
		}
		return checkList21Desc;
	}

	/**
	 * @return the checkList21
	 */
	private CheckBoxBase getCheckList21() {
		if (checkList21 == null) {
			checkList21 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			checkList21.setBounds(500, 130, 20, 20);
		}
		return checkList21;
	}
	
	/**
	 * @return the checkList22Desc
	 */
	private LabelBase getCheckList22Desc() {
		if (checkList22Desc == null) {
			checkList22Desc = new LabelBase();
			checkList22Desc.setText("Medication Breakdown");
			checkList22Desc.setBounds(290, 155, 200, 20);			
		}
		return checkList22Desc;
	}

	/**
	 * @return the checkList22
	 */
	private CheckBoxBase getCheckList22() {
		if (checkList22 == null) {
			checkList22 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			checkList22.setBounds(500, 155, 20, 20);
		}
		return checkList22;
	}	

	/**
	 * @return the checkList19Desc
	 */
	private LabelBase getcheckList19Desc() {
		if (checkList19Desc == null) {
			checkList19Desc = new LabelBase();
			checkList19Desc.setText("Other1");
			checkList19Desc.setBounds(290, 180, 200, 20);
		}
		return checkList19Desc;
	}

	/**
	 * @return the checkList19
	 */
	private CheckBoxBase getCheckList19() {
		if (checkList19 == null) {
			checkList19 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
					
					if (isSelected()) {
						getcheckList19Remark().setEnabled(true);
					}
					else {
						getcheckList19Remark().setEnabled(false);
					}				
				}
			};
			checkList19.setBounds(500, 180, 20, 20);
		}
		return checkList19;
	}

	/**
	 * @return the checkList19Remark
	 */
	private TextString getcheckList19Remark() {
		if (checkList19Remark == null) {
			checkList19Remark = new TextString(){
				@Override
				public void onBlur() {
					if(checkList19Remark.isDirty()){
						getSaveButton().setEnabled(true);
					}
				}
			};
			checkList19Remark.setBounds(290, 205, 200, 20);
		}
		return checkList19Remark;
	}
	
	/**
	 * @return the checkList20Desc
	 */
	private LabelBase getcheckList20Desc() {
		if (checkList20Desc == null) {
			checkList20Desc = new LabelBase();
			checkList20Desc.setText("Other2");
			checkList20Desc.setBounds(290, 230, 200, 20);
		}
		return checkList20Desc;
	}

	/**
	 * @return the checkList20
	 */
	private CheckBoxBase getCheckList20() {
		if (checkList20 == null) {
			checkList20 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
					
					if (isSelected()) {
						getcheckList20Remark().setEnabled(true);
					}
					else {
						getcheckList20Remark().setEnabled(false);
					}				
				}
			};
			checkList20.setBounds(500, 230, 20, 20);
		}
		return checkList20;
	}

	/**
	 * @return the checkList20Remark
	 */
	private TextString getcheckList20Remark() {
		if (checkList20Remark == null) {
			checkList20Remark = new TextString(){
				@Override
				public void onBlur() {
					if(checkList20Remark.isDirty()){
						getSaveButton().setEnabled(true);
					}
				}				
			};
			checkList20Remark.setBounds(290, 255, 200, 20);
		}
		return checkList20Remark;
	}
		
	private ButtonBase getSaveButton() {
		if (saveButton == null) {
			saveButton = new ButtonBase("Save"){
				@Override
				public void onClick() {
					QueryUtil.executeMasterAction(getUserInfo(), "ARCHECKLIST", "MOD",
							getInputParamaters(),
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							doOkAction();							
							Factory.getInstance().addInformationMessage(
									"Save success.",
									new Listener<MessageBoxEvent>() {
	
										@Override
										public void handleEvent(
												MessageBoxEvent be) {
												dispose();
										}
									});
						}
				});
				}	
			};
			saveButton.setEnabled(false);			
			saveButton.setBounds(450, 520, 60, 25);
		}
		return saveButton;
	}	
}
