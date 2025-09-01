package com.hkah.client.layout.dialog;

import java.util.HashMap;
import java.util.Map;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Component;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTransaction;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgGeneralExclusions extends DialogBase {
	private final static int m_frameWidth = 800;
	private final static int m_frameHeight = 600;
	
	private String memActID = EMPTY_VALUE;	
	
	private BasePanel contentPanel = null;
	/* Part A Exclusions */
	private LabelBase deseaseDesc = null;
	private LabelBase exclusions01Desc = null;
	private CheckBoxBase exclusions01 = null;
	private LabelBase exclusions02Desc = null;
	private CheckBoxBase exclusions02 = null;
	private LabelBase exclusions03Desc = null;
	private CheckBoxBase exclusions03 = null;
	private LabelBase exclusions04Desc = null;
	private CheckBoxBase exclusions04 = null;
	private LabelBase exclusions05Desc = null;
	private CheckBoxBase exclusions05 = null;
	private LabelBase exclusions06Desc = null;
	private CheckBoxBase exclusions06 = null;
	private LabelBase exclusions07Desc = null;
	private CheckBoxBase exclusions07 = null;
	private LabelBase exclusions08Desc = null;
	private CheckBoxBase exclusions08 = null;
	private LabelBase exclusions09Desc = null;
	private CheckBoxBase exclusions09 = null;
	private LabelBase exclusions10Desc = null;
	private CheckBoxBase exclusions10 = null;
	/* Part B Exclusions */
	private LabelBase treatmentDesc = null;
	private LabelBase exclusions11Desc = null;
	private CheckBoxBase exclusions11 = null;
	/* Part C Exclusions */
	private LabelBase medicalAidsDesc = null;
	private LabelBase exclusions12Desc = null;
	private CheckBoxBase exclusions12 = null;
	private LabelBase exclusions13Desc = null;
	private CheckBoxBase exclusions13 = null;
	private LabelBase exclusions14Desc = null;
	private CheckBoxBase exclusions14 = null;
	private LabelBase exclusions15Desc = null;
	private CheckBoxBase exclusions15 = null;
	private LabelBase exclusions16Desc = null;
	private CheckBoxBase exclusions16 = null;
	private LabelBase exclusions17Desc = null;
	private CheckBoxBase exclusions17 = null;
	private LabelBase exclusions18Desc = null;
	private CheckBoxBase exclusions18 = null;
	/* Part D Exclusions */
	private LabelBase othersDesc = null;
	private LabelBase exclusions19Desc = null;
	private CheckBoxBase exclusions19 = null;
	private LabelBase exclusions20Desc = null;
	private CheckBoxBase exclusions20 = null;
	private LabelBase exclusions21Desc = null;
	private CheckBoxBase exclusions21 = null;
	private LabelBase exclusions22Desc = null;
	private CheckBoxBase exclusions22 = null;
	private LabelBase exclusions23Desc = null;
	private CheckBoxBase exclusions23 = null;
	private LabelBase exclusions24Desc = null;
	private CheckBoxBase exclusions24 = null;
	private LabelBase exclusions25Desc = null;
	private CheckBoxBase exclusions25 = null;
	private LabelBase exclusions26Desc = null;
	private CheckBoxBase exclusions26 = null;
	private LabelBase exclusions27Desc = null;
	private CheckBoxBase exclusions27 = null;
	private LabelBase exclusions28Desc = null;
	private CheckBoxBase exclusions28 = null;
	private LabelBase exclusions29Desc = null;
	private CheckBoxBase exclusions29 = null;
	private LabelBase exclusions30Desc = null;
	private CheckBoxBase exclusions30 = null;
	private LabelBase exclusions31Desc = null;
	private CheckBoxBase exclusions31 = null;
	private LabelBase exclusions32Desc = null;
	private CheckBoxBase exclusions32 = null;
	private LabelBase exclusions33Desc = null;
	private CheckBoxBase exclusions33 = null;
	
/*	
	private LabelBase exclusions34Desc = null;
	private CheckBoxBase exclusions34 = null;
	private LabelBase exclusions35Desc = null;
	private CheckBoxBase exclusions35 = null;
	private LabelBase exclusions36Desc = null;
	private CheckBoxBase exclusions36 = null;
	private LabelBase exclusions37Desc = null;
	private CheckBoxBase exclusions37 = null;
	private LabelBase exclusions38Desc = null;
	private CheckBoxBase exclusions38 = null;
	private LabelBase exclusions39Desc = null;
	private CheckBoxBase exclusions39 = null;
	private LabelBase exclusions40Desc = null;
	private CheckBoxBase exclusions40 = null;
	private LabelBase exclusions41Desc = null;
	private CheckBoxBase exclusions41 = null;	
	private LabelBase exclusions42Desc = null;	
	private CheckBoxBase exclusions42 = null;
	private LabelBase exclusions43Desc = null;
	private CheckBoxBase exclusions43 = null;
	private LabelBase exclusions44Desc = null;
	private CheckBoxBase exclusions44 = null;
	private LabelBase exclusions45Desc = null;
	private CheckBoxBase exclusions45 = null;
	private LabelBase exclusions46Desc = null;
	private CheckBoxBase exclusions46 = null;
	private LabelBase exclusions47Desc = null;
	private CheckBoxBase exclusions47 = null;
*/
	private ButtonBase saveButton = null;
	
	public DlgGeneralExclusions(MainFrame owner) {
		super(owner, m_frameWidth, m_frameHeight);
		initialize();
	}
	
	private void initialize() {
		setTitle("General Exclusions");
		setContentPane(getGeneralExclusionsPanel());
	}
	
	@Override
	public Component getDefaultFocusComponent() {
		return null;
	}

	public void showDialog() {
		setVisible(true);
		resetContent();
	}
	
	public void showDialog(String arcode, String actID) {
		memActID = actID;
		setVisible(true);
		resetContent();
				
		QueryUtil.executeMasterBrowse(getUserInfo(), "AREXCLUSIONS",
				new String[] { arcode, actID },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success() && mQueue.getContentField().length > 0) {
					String[] outParam = mQueue.getContentField();
					int index = 0;
					getExclusions01().setSelected(ONE_VALUE.equals(outParam[index++]));	//	Administration fee
					getExclusions02().setSelected(ONE_VALUE.equals(outParam[index++]));	//	Back support/ Girdle
					getExclusions03().setSelected(ONE_VALUE.equals(outParam[index++]));	//	BET/ Pilates
					getExclusions04().setSelected(ONE_VALUE.equals(outParam[index++]));	//	Birth Defects
					getExclusions05().setSelected(ONE_VALUE.equals(outParam[index++]));	//	Companion Beds
					getExclusions06().setSelected(ONE_VALUE.equals(outParam[index++]));	//	Congenital conditions
					getExclusions07().setSelected(ONE_VALUE.equals(outParam[index++]));	//	Contraception
					getExclusions08().setSelected(ONE_VALUE.equals(outParam[index++]));	//	Cosmetic related
					getExclusions09().setSelected(ONE_VALUE.equals(outParam[index++]));	//	Dental related
					getExclusions10().setSelected(ONE_VALUE.equals(outParam[index++]));	//	Developmental Abnormalities
					getExclusions11().setSelected(ONE_VALUE.equals(outParam[index++]));	//	Dietician/ Dietary Consultation
					getExclusions12().setSelected(ONE_VALUE.equals(outParam[index++]));	//	Eating Disorder
					getExclusions13().setSelected(ONE_VALUE.equals(outParam[index++]));	//	Fertility related
					getExclusions14().setSelected(ONE_VALUE.equals(outParam[index++]));	//	Hearing aids/Kit
					getExclusions15().setSelected(ONE_VALUE.equals(outParam[index++]));	//	Non-medical services
					getExclusions16().setSelected(ONE_VALUE.equals(outParam[index++]));	//	HIV and related disease
					getExclusions17().setSelected(ONE_VALUE.equals(outParam[index++]));	//	Medical devices/ equipment
					getExclusions18().setSelected(ONE_VALUE.equals(outParam[index++]));	//	Wheel chair
					getExclusions19().setSelected(ONE_VALUE.equals(outParam[index++]));	//	Mental Health related
					getExclusions20().setSelected(ONE_VALUE.equals(outParam[index++]));	//	Occupational Therapy
					getExclusions21().setSelected(ONE_VALUE.equals(outParam[index++]));	//	Non-medical expenses
					getExclusions22().setSelected(ONE_VALUE.equals(outParam[index++]));	//	Overweight treatment
					getExclusions23().setSelected(ONE_VALUE.equals(outParam[index++]));	//	Personal expenses
					getExclusions24().setSelected(ONE_VALUE.equals(outParam[index++]));	//	Pregnancy related
					getExclusions25().setSelected(ONE_VALUE.equals(outParam[index++]));	//	Private nursing
					getExclusions26().setSelected(ONE_VALUE.equals(outParam[index++]));	//	Psychiatric Condition
					getExclusions27().setSelected(ONE_VALUE.equals(outParam[index++]));	//	Sexually transmitted disease
					getExclusions28().setSelected(ONE_VALUE.equals(outParam[index++]));	//	Sleep disorder
					getExclusions29().setSelected(ONE_VALUE.equals(outParam[index++]));	//	Smoking ceasation
					getExclusions30().setSelected(ONE_VALUE.equals(outParam[index++]));	//	Speech Therapy
					getExclusions31().setSelected(ONE_VALUE.equals(outParam[index++]));	//	Supplements
					getExclusions32().setSelected(ONE_VALUE.equals(outParam[index++]));	//	Transplantation
					getExclusions33().setSelected(ONE_VALUE.equals(outParam[index++]));	//	Walking aids/ Wheel Chair/ Crutches
/*					
					getExclusions34().setSelected(ONE_VALUE.equals(outParam[index++]));
					getExclusions35().setSelected(ONE_VALUE.equals(outParam[index++]));
					getExclusions36().setSelected(ONE_VALUE.equals(outParam[index++]));
					getExclusions37().setSelected(ONE_VALUE.equals(outParam[index++]));
					getExclusions38().setSelected(ONE_VALUE.equals(outParam[index++]));
					getExclusions39().setSelected(ONE_VALUE.equals(outParam[index++]));
					getExclusions40().setSelected(ONE_VALUE.equals(outParam[index++]));
					getExclusions41().setSelected(ONE_VALUE.equals(outParam[index++]));
					getExclusions42().setSelected(ONE_VALUE.equals(outParam[index++]));
					getExclusions43().setSelected(ONE_VALUE.equals(outParam[index++]));
					getExclusions44().setSelected(ONE_VALUE.equals(outParam[index++]));
					getExclusions45().setSelected(ONE_VALUE.equals(outParam[index++]));
					getExclusions46().setSelected(ONE_VALUE.equals(outParam[index++]));
					getExclusions47().setSelected(ONE_VALUE.equals(outParam[index++]));
*/					
				}
			}
		});	
	}
	
	private void resetContent() {
		
	}
	
	private String[] getInputParamaters() {
		return new String[] {
			memActID,	
			getExclusions01().isSelected() ? "01" : ZERO_VALUE,
			getExclusions02().isSelected() ? "02" : ZERO_VALUE,
			getExclusions03().isSelected() ? "03" : ZERO_VALUE,
			getExclusions04().isSelected() ? "04" : ZERO_VALUE,
			getExclusions05().isSelected() ? "05" : ZERO_VALUE,
			getExclusions06().isSelected() ? "06" : ZERO_VALUE,
			getExclusions07().isSelected() ? "07" : ZERO_VALUE,
			getExclusions08().isSelected() ? "08" : ZERO_VALUE,
			getExclusions09().isSelected() ? "09" : ZERO_VALUE,
			getExclusions10().isSelected() ? "10" : ZERO_VALUE,
			getExclusions11().isSelected() ? "11" : ZERO_VALUE,
			getExclusions12().isSelected() ? "12" : ZERO_VALUE,
			getExclusions13().isSelected() ? "13" : ZERO_VALUE,
			getExclusions14().isSelected() ? "14" : ZERO_VALUE,
			getExclusions15().isSelected() ? "15" : ZERO_VALUE,
			getExclusions16().isSelected() ? "16" : ZERO_VALUE,
			getExclusions17().isSelected() ? "17" : ZERO_VALUE,
			getExclusions18().isSelected() ? "18" : ZERO_VALUE,
			getExclusions19().isSelected() ? "19" : ZERO_VALUE,
			getExclusions20().isSelected() ? "20" : ZERO_VALUE,
			getExclusions21().isSelected() ? "21" : ZERO_VALUE,
			getExclusions22().isSelected() ? "22" : ZERO_VALUE,
			getExclusions23().isSelected() ? "23" : ZERO_VALUE,
			getExclusions24().isSelected() ? "24" : ZERO_VALUE,
			getExclusions25().isSelected() ? "25" : ZERO_VALUE,
			getExclusions26().isSelected() ? "26" : ZERO_VALUE,
			getExclusions27().isSelected() ? "27" : ZERO_VALUE,
			getExclusions28().isSelected() ? "28" : ZERO_VALUE,
			getExclusions29().isSelected() ? "29" : ZERO_VALUE,
			getExclusions30().isSelected() ? "30" : ZERO_VALUE,
			getExclusions31().isSelected() ? "31" : ZERO_VALUE,
			getExclusions32().isSelected() ? "32" : ZERO_VALUE,
			getExclusions33().isSelected() ? "33" : ZERO_VALUE
/*				
			,getExclusions34().isSelected() ? "34" : ZERO_VALUE
			,getExclusions35().isSelected() ? "35" : ZERO_VALUE
			,getExclusions36().isSelected() ? "36" : ZERO_VALUE
			,getExclusions37().isSelected() ? "37" : ZERO_VALUE
			,getExclusions38().isSelected() ? "38" : ZERO_VALUE
			,getExclusions39().isSelected() ? "39" : ZERO_VALUE
			,getExclusions40().isSelected() ? "40" : ZERO_VALUE
			,getExclusions41().isSelected() ? "41" : ZERO_VALUE
			,getExclusions42().isSelected() ? "42" : ZERO_VALUE
			,getExclusions43().isSelected() ? "43" : ZERO_VALUE
			,getExclusions44().isSelected() ? "44" : ZERO_VALUE
			,getExclusions45().isSelected() ? "45" : ZERO_VALUE
			,getExclusions46().isSelected() ? "46" : ZERO_VALUE
			,getExclusions47().isSelected() ? "47" : ZERO_VALUE
*/			
		};
	}
	
	protected BasePanel getGeneralExclusionsPanel() {
		if (contentPanel == null) {
			contentPanel = new BasePanel();
//			contentPanel.add(getDeseaseDesc(), null);
			contentPanel.add(getExclusions01Desc(), null);
			contentPanel.add(getExclusions01(), null);
			contentPanel.add(getExclusions02Desc(), null);
			contentPanel.add(getExclusions02(), null);
			contentPanel.add(getExclusions03Desc(), null);
			contentPanel.add(getExclusions03(), null);
			contentPanel.add(getExclusions04Desc(), null);
			contentPanel.add(getExclusions04(), null);
			contentPanel.add(getExclusions05Desc(), null);
			contentPanel.add(getExclusions05(), null);
			contentPanel.add(getExclusions06Desc(), null);
			contentPanel.add(getExclusions06(), null);
			contentPanel.add(getExclusions07Desc(), null);
			contentPanel.add(getExclusions07(), null);
			contentPanel.add(getExclusions08Desc(), null);
			contentPanel.add(getExclusions08(), null);
			contentPanel.add(getExclusions09Desc(), null);
			contentPanel.add(getExclusions09(), null);
			contentPanel.add(getExclusions10Desc(), null);
			contentPanel.add(getExclusions10(), null);
//			contentPanel.add(getTreatmentDesc(), null);
			contentPanel.add(getExclusions11Desc(), null);
			contentPanel.add(getExclusions11(), null);
//			contentPanel.add(getMedicalAidsDesc(), null);
			contentPanel.add(getExclusions12Desc(), null);
			contentPanel.add(getExclusions12(), null);
			contentPanel.add(getExclusions13Desc(), null);
			contentPanel.add(getExclusions13(), null);
			contentPanel.add(getExclusions14Desc(), null);
			contentPanel.add(getExclusions14(), null);
			contentPanel.add(getExclusions15Desc(), null);
			contentPanel.add(getExclusions15(), null);
			contentPanel.add(getExclusions16Desc(), null);
			contentPanel.add(getExclusions16(), null);
			contentPanel.add(getExclusions17Desc(), null);
			contentPanel.add(getExclusions17(), null);
			contentPanel.add(getExclusions18Desc(), null);
			contentPanel.add(getExclusions18(), null);
//			contentPanel.add(getOthersDesc(), null);
			contentPanel.add(getExclusions19Desc(), null);
			contentPanel.add(getExclusions19(), null);
			contentPanel.add(getExclusions20Desc(), null);
			contentPanel.add(getExclusions20(), null);
			contentPanel.add(getExclusions21Desc(), null);
			contentPanel.add(getExclusions21(), null);
			contentPanel.add(getExclusions22Desc(), null);
			contentPanel.add(getExclusions22(), null);
			contentPanel.add(getExclusions23Desc(), null);
			contentPanel.add(getExclusions23(), null);
			contentPanel.add(getExclusions24Desc(), null);
			contentPanel.add(getExclusions24(), null);
			contentPanel.add(getExclusions25Desc(), null);
			contentPanel.add(getExclusions25(), null);
//			contentPanel.add(getExclusions26Desc(), null);
//			contentPanel.add(getExclusions26(), null);
			contentPanel.add(getExclusions27Desc(), null);
			contentPanel.add(getExclusions27(), null);
			contentPanel.add(getExclusions28Desc(), null);
			contentPanel.add(getExclusions28(), null);
			contentPanel.add(getExclusions29Desc(), null);
			contentPanel.add(getExclusions29(), null);
			contentPanel.add(getExclusions30Desc(), null);
			contentPanel.add(getExclusions30(), null);
			contentPanel.add(getExclusions31Desc(), null);
			contentPanel.add(getExclusions31(), null);
			contentPanel.add(getExclusions32Desc(), null);
			contentPanel.add(getExclusions32(), null);
			contentPanel.add(getExclusions33Desc(), null);
			contentPanel.add(getExclusions33(), null);
/*			
			contentPanel.add(getExclusions34Desc(), null);
			contentPanel.add(getExclusions34(), null);
			contentPanel.add(getExclusions35Desc(), null);
			contentPanel.add(getExclusions35(), null);
			contentPanel.add(getExclusions36Desc(), null);
			contentPanel.add(getExclusions36(), null);
			contentPanel.add(getExclusions37Desc(), null);
			contentPanel.add(getExclusions37(), null);
			contentPanel.add(getExclusions38Desc(), null);
			contentPanel.add(getExclusions38(), null);
			contentPanel.add(getExclusions39Desc(), null);
			contentPanel.add(getExclusions39(), null);
			contentPanel.add(getExclusions40Desc(), null);
			contentPanel.add(getExclusions40(), null);
			contentPanel.add(getExclusions41Desc(), null);
			contentPanel.add(getExclusions41(), null);
			contentPanel.add(getExclusions42Desc(), null);
			contentPanel.add(getExclusions42(), null);
			contentPanel.add(getExclusions43Desc(), null);
			contentPanel.add(getExclusions43(), null);
			contentPanel.add(getExclusions44Desc(), null);
			contentPanel.add(getExclusions44(), null);
			contentPanel.add(getExclusions45Desc(), null);
			contentPanel.add(getExclusions45(), null);
			contentPanel.add(getExclusions46Desc(), null);
			contentPanel.add(getExclusions46(), null);
			contentPanel.add(getExclusions47Desc(), null);
			contentPanel.add(getExclusions47(), null);
*/			
			contentPanel.add(getSaveButton(), null);			
		}
		return contentPanel;
	}

	/**
	 * @return the deseaseDesc
	 */
	private LabelBase getDeseaseDesc() {
		if (deseaseDesc == null) {
			deseaseDesc = new LabelBase();
			deseaseDesc.setText("<b>A. Desease / Illnesses</b>");
			deseaseDesc.setBounds(5, 5, 200, 20);
		}
		return deseaseDesc;
	}

	/**
	 * @return the exclusions01Desc
	 */
	private LabelBase getExclusions01Desc() {
		if (exclusions01Desc == null) {
			exclusions01Desc = new LabelBase();
			exclusions01Desc.setText("Administration fee");
			exclusions01Desc.setBounds(5, 30, 200, 20);
		}
		return exclusions01Desc;
	}

	/**
	 * @return the exclusions01
	 */
	private CheckBoxBase getExclusions01() {
		if (exclusions01 == null) {
			exclusions01 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions01.setBounds(210, 30, 20, 20);
		}
		return exclusions01;
	}

	/**
	 * @return the exclusions02Desc
	 */
	private LabelBase getExclusions02Desc() {
		if (exclusions02Desc == null) {
			exclusions02Desc = new LabelBase();
			exclusions02Desc.setText("Back support/ Girdle");
			exclusions02Desc.setBounds(5, 55, 200, 20);
		}
		return exclusions02Desc;
	}

	/**
	 * @return the drugAlcoholaddiction
	 */
	private CheckBoxBase getExclusions02() {
		if (exclusions02 == null) {
			exclusions02 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions02.setBounds(210, 55, 20, 20);
		}
		return exclusions02;
	}

	/**
	 * @return the hairLossDesc
	 */
	private LabelBase getExclusions03Desc() {
		if (exclusions03Desc == null) {
			exclusions03Desc = new LabelBase();
			exclusions03Desc.setText("BET/ Pilates");
			exclusions03Desc.setBounds(5, 80, 200, 20);
		}
		return exclusions03Desc;
	}

	/**
	 * @return the hairLoss
	 */
	private CheckBoxBase getExclusions03() {
		if (exclusions03 == null) {
			exclusions03 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions03.setBounds(210, 80, 20, 20);
		}
		return exclusions03;
	}

	/**
	 * @return the exclusions04Desc
	 */
	private LabelBase getExclusions04Desc() {
		if (exclusions04Desc == null) {
			exclusions04Desc = new LabelBase();
			exclusions04Desc.setText("Birth Defects");
			exclusions04Desc.setBounds(5, 105, 200, 20);
		}
		return exclusions04Desc;
	}

	/**
	 * @return the exclusions04
	 */
	private CheckBoxBase getExclusions04() {
		if (exclusions04 == null) {
			exclusions04 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions04.setBounds(210, 105, 20, 20);
		}
		return exclusions04;
	}

	/**
	 * @return the exclusions05Desc
	 */
	private LabelBase getExclusions05Desc() {
		if (exclusions05Desc == null) {
			exclusions05Desc = new LabelBase();
			exclusions05Desc.setText("Companion Beds");
			exclusions05Desc.setBounds(5, 130, 200, 20);
		}
		return exclusions05Desc;
	}

	/**
	 * @return the recreationSporting
	 */
	private CheckBoxBase getExclusions05() {
		if (exclusions05 == null) {
			exclusions05 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions05.setBounds(210, 130, 20, 20);
		}
		return exclusions05;
	}

	/**
	 * @return the exclusions06Desc
	 */
	private LabelBase getExclusions06Desc() {
		if (exclusions06Desc == null) {
			exclusions06Desc = new LabelBase();
			exclusions06Desc.setText("Congenital conditions");
			exclusions06Desc.setBounds(5, 155, 200, 20);
		}
		return exclusions06Desc;
	}

	/**
	 * @return the exclusions06
	 */
	private CheckBoxBase getExclusions06() {
		if (exclusions06 == null) {
			exclusions06 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions06.setBounds(210, 155, 20, 20);
		}
		return exclusions06;
	}

	/**
	 * @return the exclusions07Desc
	 */
	private LabelBase getExclusions07Desc() {
		if (exclusions07Desc == null) {
			exclusions07Desc = new LabelBase();
			exclusions07Desc.setText("Contraception");
			exclusions07Desc.setBounds(5, 180, 200, 20);
		}
		return exclusions07Desc;
	}

	/**
	 * @return the getExclusions07
	 */
	private CheckBoxBase getExclusions07() {
		if (exclusions07 == null) {
			exclusions07 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions07.setBounds(210, 180, 20, 20);
		}
		return exclusions07;
	}

	/**
	 * @return the exclusions08Desc
	 */
	private LabelBase getExclusions08Desc() {
		if (exclusions08Desc == null) {
			exclusions08Desc = new LabelBase();
			exclusions08Desc.setText("Cosmetic related");
			exclusions08Desc.setBounds(5, 205, 200, 20);
		}
		return exclusions08Desc;
	}

	/**
	 * @return the exclusions08
	 */
	private CheckBoxBase getExclusions08() {
		if (exclusions08 == null) {
			exclusions08 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions08.setBounds(210, 205, 20, 20);
		}
		return exclusions08;
	}

	/**
	 * @return the exclusions09Desc
	 */
	private LabelBase getExclusions09Desc() {
		if (exclusions09Desc == null) {
			exclusions09Desc = new LabelBase();
			exclusions09Desc.setText("Dental related");
			exclusions09Desc.setBounds(5, 230, 200, 20);
		}
		return exclusions09Desc;
	}

	/**
	 * @return the exclusions09
	 */
	private CheckBoxBase getExclusions09() {
		if (exclusions09 == null) {
			exclusions09 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions09.setBounds(210, 230, 20, 20);
		}
		return exclusions09;
	}

	/**
	 * @return the exclusions10Desc
	 */
	private LabelBase getExclusions10Desc() {
		if (exclusions10Desc == null) {
			exclusions10Desc = new LabelBase();
			exclusions10Desc.setText("Developmental Abnormalities");
			exclusions10Desc.setBounds(5, 255, 200, 20);
		}
		return exclusions10Desc;
	}

	/**
	 * @return the exclusions10
	 */
	private CheckBoxBase getExclusions10() {
		if (exclusions10 == null) {
			exclusions10 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions10.setBounds(210, 255, 20, 20);
		}
		return exclusions10;
	}

	/**
	 * @return the treatmentDesc
	 */
	private LabelBase getTreatmentDesc() {
		if (treatmentDesc == null) {
			treatmentDesc = new LabelBase();
			treatmentDesc.setText("<b>B. Treatment</b>");
			treatmentDesc.setBounds(5, 280, 200, 20);
		}
		return treatmentDesc;
	}

	/**
	 * @return the exclusions11Desc
	 */
	private LabelBase getExclusions11Desc() {
		if (exclusions11Desc == null) {
			exclusions11Desc = new LabelBase();
			exclusions11Desc.setText("Dietician/ Dietary Consultation");
			exclusions11Desc.setBounds(5, 305, 200, 20);
		}
		return exclusions11Desc;
	}

	/**
	 * @return the exclusions11
	 */
	private CheckBoxBase getExclusions11() {
		if (exclusions11 == null) {
			exclusions11 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions11.setBounds(210, 305, 20, 20);
		}
		return exclusions11;
	}

	/**
	 * @return the medicalAidsDesc
	 */
	private LabelBase getMedicalAidsDesc() {
		if (medicalAidsDesc == null) {
			medicalAidsDesc = new LabelBase();
			medicalAidsDesc.setText("<b>C. Medical Aids</b>");
			medicalAidsDesc.setBounds(5, 330, 200, 20);
		}
		return medicalAidsDesc;
	}

	/**
	 * @return the exclusions12Desc
	 */
	private LabelBase getExclusions12Desc() {
		if (exclusions12Desc == null) {
			exclusions12Desc = new LabelBase();
			exclusions12Desc.setText("Eating Disorder");
			exclusions12Desc.setBounds(5, 355, 200, 20);
		}
		return exclusions12Desc;
	}

	/**
	 * @return the exclusions12
	 */
	private CheckBoxBase getExclusions12() {
		if (exclusions12 == null) {
			exclusions12 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions12.setBounds(210, 355, 20, 20);
		}
		return exclusions12;
	}

	/**
	 * @return the getExclusions12()
	 */
	private LabelBase getExclusions13Desc() {
		if (exclusions13Desc == null) {
			exclusions13Desc = new LabelBase();
			exclusions13Desc.setText("Fertility related");
			exclusions13Desc.setBounds(5, 380, 200, 20);
		}
		return exclusions13Desc;
	}

	/**
	 * @return the exclusions13
	 */
	private CheckBoxBase getExclusions13() {
		if (exclusions13 == null) {
			exclusions13 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions13.setBounds(210, 380, 20, 20);
		}
		return exclusions13;
	}

	/**
	 * @return the exclusions14Desc
	 */
	private LabelBase getExclusions14Desc() {
		if (exclusions14Desc == null) {
			exclusions14Desc = new LabelBase();
			exclusions14Desc.setText("Foot orthotics");
			exclusions14Desc.setBounds(5, 405, 200, 20);
		}
		return exclusions14Desc;
	}

	/**
	 * @return the exclusions14
	 */
	private CheckBoxBase getExclusions14() {
		if (exclusions14 == null) {
			exclusions14 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions14.setBounds(210, 405, 20, 20);
		}
		return exclusions14;
	}

	/**
	 * @return the exclusions15Desc
	 */
	private LabelBase getExclusions15Desc() {
		if (exclusions15Desc == null) {
			exclusions15Desc = new LabelBase();
			exclusions15Desc.setText("Hearing aids");
			exclusions15Desc.setBounds(5, 430, 200, 20);
		}
		return exclusions15Desc;
	}

	/**
	 * @return the nonMedicalServices
	 */
	private CheckBoxBase getExclusions15() {
		if (exclusions15 == null) {
			exclusions15 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions15.setBounds(210, 430, 20, 20);
		}
		return exclusions15;
	}

	/**
	 * @return the exclusions16Desc
	 */
	private LabelBase getExclusions16Desc() {
		if (exclusions16Desc == null) {
			exclusions16Desc = new LabelBase();
			exclusions16Desc.setText("HIV and related disease");
			exclusions16Desc.setBounds(5, 455, 200, 20);
		}
		return exclusions16Desc;
	}

	/**
	 * @return the exclusions16
	 */
	private CheckBoxBase getExclusions16() {
		if (exclusions16 == null) {
			exclusions16 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions16.setBounds(210, 455, 20, 20);
		}
		return exclusions16;
	}

	/**
	 * @return the preventativeMedicineDesc
	 */
	private LabelBase getExclusions17Desc() {
		if (exclusions17Desc == null) {
			exclusions17Desc = new LabelBase();
			exclusions17Desc.setText("Medical devices/ equipment");
			exclusions17Desc.setBounds(5, 480, 200, 40);
		}
		return exclusions17Desc;
	}

	/**
	 * @return the exclusions17
	 */
	private CheckBoxBase getExclusions17() {
		if (exclusions17 == null) {
			exclusions17 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions17.setBounds(210, 480, 20, 40);
		}
		return exclusions17;
	}

	/**
	 * @return the exclusions18Desc
	 */
	private LabelBase getExclusions18Desc() {
		if (exclusions18Desc == null) {
			exclusions18Desc = new LabelBase();
			exclusions18Desc.setText("Medical report or any document fee");
			exclusions18Desc.setBounds(5, 525, 200, 20);
		}
		return exclusions18Desc;
	}

	/**
	 * @return the exclusions18
	 */
	private CheckBoxBase getExclusions18() {
		if (exclusions18 == null) {
			exclusions18 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions18.setBounds(210, 525, 20, 20);
		}
		return exclusions18;
	}

	/**
	 * @return the othersDesc
	 */
	private LabelBase getOthersDesc() {
		if (othersDesc == null) {
			othersDesc = new LabelBase();
			othersDesc.setText("<b>D. Others</b>");
			othersDesc.setBounds(240, 5, 200, 20);
		}
		return othersDesc;
	}

	/**
	 * @return the expiredInsurancePlanDesc
	 */
	private LabelBase getExclusions19Desc() {
		if (exclusions19Desc == null) {
			exclusions19Desc = new LabelBase();
			exclusions19Desc.setText("Mental Health related");
			exclusions19Desc.setBounds(240, 30, 200, 20);
		}
		return exclusions19Desc;
	}

	/**
	 * @return the exclusions19
	 */
	private CheckBoxBase getExclusions19() {
		if (exclusions19 == null) {
			exclusions19 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions19.setBounds(450, 30, 20, 20);
		}
		return exclusions19;
	}

	/**
	 * @return the bookletDesc
	 */
	private LabelBase getExclusions20Desc() {
		if (exclusions20Desc == null) {
			exclusions20Desc = new LabelBase();
			exclusions20Desc.setText("Occupational Therapy");
			exclusions20Desc.setBounds(240, 55, 200, 20);
		}
		return exclusions20Desc;
	}

	/**
	 * @return the exclusions20
	 */
	private CheckBoxBase getExclusions20() {
		if (exclusions20 == null) {
			exclusions20 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions20.setBounds(450, 55, 20, 20);
		}
		return exclusions20;
	}

	/**
	 * @return the exclusions21Desc
	 */
	private LabelBase getExclusions21Desc() {
		if (exclusions21Desc == null) {
			exclusions21Desc = new LabelBase();
			exclusions21Desc.setText("Optical/ Eye refractive error and sight defect related");
			exclusions21Desc.setBounds(240, 80, 200, 20);
		}
		return exclusions21Desc;
	}

	/**
	 * @return the exclusions21
	 */
	private CheckBoxBase getExclusions21() {
		if (exclusions21 == null) {
			exclusions21 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions21.setBounds(450, 80, 20, 20);
		}
		return exclusions21;
	}

	/**
	 * @return the exclusions22Desc
	 */
	private LabelBase getExclusions22Desc() {
		if (exclusions22Desc == null) {
			exclusions22Desc = new LabelBase();
			exclusions22Desc.setText("Overweight treatment");
			exclusions22Desc.setBounds(240, 105, 200, 20);
		}
		return exclusions22Desc;
	}

	/**
	 * @return the exclusions22
	 */
	private CheckBoxBase getExclusions22() {
		if (exclusions22 == null) {
			exclusions22 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions22.setBounds(450, 105, 20, 20);
		}
		return exclusions22;
	}

	/**
	 * @return the exclusions23Desc
	 */
	private LabelBase getExclusions23Desc() {
		if (exclusions23Desc == null) {
			exclusions23Desc = new LabelBase();
			exclusions23Desc.setText("Personal expenses");
			exclusions23Desc.setBounds(240, 130, 200, 20);
		}
		return exclusions23Desc;
	}

	/**
	 * @return the exclusions23
	 */
	private CheckBoxBase getExclusions23() {
		if (exclusions23 == null) {
			exclusions23 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions23.setBounds(450, 130, 20, 20);
		}
		return exclusions23;
	}

	/**
	 * @return the exclusions24Desc
	 */
	private LabelBase getExclusions24Desc() {
		if (exclusions24Desc == null) {
			exclusions24Desc = new LabelBase();
			exclusions24Desc.setText("Pregnancy related");
			exclusions24Desc.setBounds(240, 155, 200, 20);
		}
		return exclusions24Desc;
	}

	/**
	 * @return the exclusions24
	 */
	private CheckBoxBase getExclusions24() {
		if (exclusions24 == null) {
			exclusions24 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions24.setBounds(450, 155, 20, 20);
		}
		return exclusions24;
	}

	/**
	 * @return the exclusions25Desc
	 */
	private LabelBase getExclusions25Desc() {
		if (exclusions25Desc == null) {
			exclusions25Desc = new LabelBase();
			exclusions25Desc.setText("Private nursing");
			exclusions25Desc.setBounds(240, 180, 200, 20);
		}
		return exclusions25Desc;
	}

	/**
	 * @return the exclusions25
	 */
	private CheckBoxBase getExclusions25() {
		if (exclusions25 == null) {
			exclusions25 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions25.setBounds(450, 180, 20, 20);
		}
		return exclusions25;
	}

	/**
	 * @return the exclusions26Desc
	 */
	private LabelBase getExclusions26Desc() {
		if (exclusions26Desc == null) {
			exclusions26Desc = new LabelBase();
			exclusions26Desc.setText("Psychiatric Condition");
			exclusions26Desc.setBounds(240, 205, 200, 20);
		}
		return exclusions26Desc;
	}

	/**
	 * @return the exclusions26
	 */
	private CheckBoxBase getExclusions26() {
		if (exclusions26 == null) {
			exclusions26 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions26.setBounds(450, 205, 20, 20);
		}
		return exclusions26;
	}

	/**
	 * @return the exclusions27Desc
	 */
	private LabelBase getExclusions27Desc() {
		if (exclusions27Desc == null){
			exclusions27Desc = new LabelBase();
			exclusions27Desc.setText("Sexually transmitted disease");
			exclusions27Desc.setBounds(240, 230, 200, 20);
		}
		return exclusions27Desc;
	}

	/**
	 * @return the exclusions27
	 */
	private CheckBoxBase getExclusions27() {
		if (exclusions27 == null) {
			exclusions27 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions27.setBounds(450, 230, 20, 20);
		}
		return exclusions27;
	}

	/**
	 * @return the exclusions28Desc
	 */
	private LabelBase getExclusions28Desc() {
		if (exclusions28Desc == null) {
			exclusions28Desc = new LabelBase();
			exclusions28Desc.setText("Sleep disorder");
			exclusions28Desc.setBounds(240, 255, 200, 20);
		}
		return exclusions28Desc;
	}

	/**
	 * @return the exclusions28
	 */
	private CheckBoxBase getExclusions28() {
		if (exclusions28 == null) {
			exclusions28 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions28.setBounds(450, 255, 20, 20);
		}
		return exclusions28;
	}

	/**
	 * @return the exclusions29Desc
	 */
	private LabelBase getExclusions29Desc() {
		if (exclusions29Desc == null) {
			exclusions29Desc = new LabelBase();
			exclusions29Desc.setText("Smoking ceasation");
			exclusions29Desc.setBounds(240, 280, 200, 40);
		}
		return exclusions29Desc;
	}

	/**
	 * @return the exclusions29
	 */
	private CheckBoxBase getExclusions29() {
		if (exclusions29 == null) {
			exclusions29 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions29.setBounds(450, 280, 20, 40);
		}
		return exclusions29;
	}

	/**
	 * @return the exclusions30Desc
	 */
	private LabelBase getExclusions30Desc() {
		if (exclusions30Desc == null) {
			exclusions30Desc = new LabelBase();
			exclusions30Desc.setText("Speech Therapy");
			exclusions30Desc.setBounds(240, 325, 200, 20);
		}
		return exclusions30Desc;
	}

	/**
	 * @return the exclusions30
	 */
	private CheckBoxBase getExclusions30() {
		if (exclusions30 == null) {
			exclusions30 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions30.setBounds(450, 325, 20, 20);
		}
		return exclusions30;
	}

	/**
	 * @return the exclusions31Desc
	 */
	private LabelBase getExclusions31Desc() {
		if (exclusions31Desc == null) {
			exclusions31Desc = new LabelBase();
			exclusions31Desc.setText("Supplements");
			exclusions31Desc.setBounds(240, 350, 200, 20);
		}
		return exclusions31Desc;
	}

	/**
	 * @return the exclusions31
	 */
	private CheckBoxBase getExclusions31() {
		if (exclusions31 == null) {
			exclusions31 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions31.setBounds(450, 350, 20, 20);
		}
		return exclusions31;
	}

	/**
	 * @return the exclusions32Desc
	 */
	private LabelBase getExclusions32Desc() {
		if (exclusions32Desc == null) {
			exclusions32Desc = new LabelBase();
			exclusions32Desc.setText("Transplantation");
			exclusions32Desc.setBounds(240, 375, 200, 20);
		}
		return exclusions32Desc;
	}

	/**
	 * @return the exclusions32
	 */
	private CheckBoxBase getExclusions32() {
		if (exclusions32 == null) {
			exclusions32 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions32.setBounds(450, 375, 20, 20);
		}
		return exclusions32;
	}

	/**
	 * @return the exclusions33Desc
	 */
	private LabelBase getExclusions33Desc() {
		if (exclusions33Desc == null) {
			exclusions33Desc = new LabelBase();
			exclusions33Desc.setText("Walking aids/ Wheel Chair/ Crutches");
			exclusions33Desc.setBounds(240, 400, 200, 20);
		}
		return exclusions33Desc;
	}

	/**
	 * @return the exclusions33
	 */
	private CheckBoxBase getExclusions33() {
		if (exclusions33 == null) {
			exclusions33 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions33.setBounds(450, 400, 20, 20);
		}
		return exclusions33;
	}

/*
	/**
	 * @return the sexChangeOperationsDesc
	 
	private LabelBase getExclusions34Desc() {
		if (exclusions34Desc  == null) {
			exclusions34Desc = new LabelBase();
			exclusions34Desc.setText("Sex change operations");
			exclusions34Desc.setBounds(240, 425, 200, 20);
		}
		return exclusions34Desc;
	}

	*//**
	 * @return the exclusions34
	 *//*
	private CheckBoxBase getExclusions34() {
		if (exclusions34 == null) {
			exclusions34 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions34.setBounds(450, 425, 20, 20);
		}
		return exclusions34;
	}

	*//**
	 * @return the exclusions35Desc
	 *//*
	private LabelBase getExclusions35Desc() {
		if (exclusions35Desc == null) {
			exclusions35Desc = new LabelBase();
			exclusions35Desc.setText("Smoking Cessation");
			exclusions35Desc.setBounds(240, 450, 200, 20);
		}
		return exclusions35Desc;
	}

	*//**
	 * @return the exclusions35
	 *//*
	private CheckBoxBase getExclusions35() {
		if (exclusions35 == null) {
			exclusions35 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions35.setBounds(450, 450, 20, 20);
		}
		return exclusions35;
	}

	*//**
	 * @return the exclusions36Desc
	 *//*
	private LabelBase getExclusions36Desc() {
		if (exclusions36Desc == null) {
			exclusions36Desc = new LabelBase();
			exclusions36Desc.setText("Special nursing care");
			exclusions36Desc.setBounds(240, 475, 200, 20);
		}
		return exclusions36Desc;
	}

	*//**
	 * @return the exclusions36
	 *//*
	private CheckBoxBase getExclusions36() {
		if (exclusions36 == null) {
			exclusions36 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions36.setBounds(450, 475, 20, 20);
		}
		return exclusions36;
	}

	*//**
	 * @return the exclusions37Desc
	 *//*
	private LabelBase getExclusions37Desc() {
		if (exclusions37Desc == null) {
			exclusions37Desc = new LabelBase();
			exclusions37Desc.setText("Vaccination / Immunization");
			exclusions37Desc.setBounds(240, 500, 200, 20);
		}
		return exclusions37Desc;
	}

	*//**
	 * @return the exclusions37
	 *//*
	private CheckBoxBase getExclusions37() {
		if (exclusions37 == null) {
			exclusions37 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions37.setBounds(450, 500, 20, 20);
		}
		return exclusions37;
	}

	*//**
	 * @return the exclusions38Desc
	 *//*
	private LabelBase getExclusions38Desc() {
		if (exclusions38Desc == null) {
			exclusions38Desc = new LabelBase();
			exclusions38Desc.setText("Planned treatment outside HK");
			exclusions38Desc.setBounds(240, 525, 200, 20);
		}
		return exclusions38Desc;
	}

	*//**
	 * @return the exclusions38
	 *//*
	private CheckBoxBase getExclusions38() {
		if (exclusions38 == null) {
			exclusions38 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions38.setBounds(450, 525, 20, 20);
		}
		return exclusions38;
	}

	*//**
	 * @return the exclusions39Desc
	 *//*
	private LabelBase getExclusions39Desc() {
		if (exclusions39Desc == null) {
			exclusions39Desc = new LabelBase();
			exclusions39Desc.setText("Pre-existing conditions");
			exclusions39Desc.setBounds(490, 5, 200, 20);
		}
		return exclusions39Desc;
	}

	*//**
	 * @return the exclusions39
	 *//*
	private CheckBoxBase getExclusions39() {
		if (exclusions39 == null) {
			exclusions39 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions39.setBounds(710, 5, 20, 20);
		}
		return exclusions39;
	}

	*//**
	 * @return the exclusions40Desc
	 *//*
	private LabelBase getExclusions40Desc() {
		if (exclusions40Desc == null) {
			exclusions40Desc = new LabelBase();
			exclusions40Desc.setText("Self inflicted injuries");
			exclusions40Desc.setBounds(490, 30, 200, 20);
		}
		return exclusions40Desc;
	}

	*//**
	 * @return the exclusions40
	 *//*
	private CheckBoxBase getExclusions40() {
		if (exclusions40 == null) {
			exclusions40 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions40.setBounds(710, 30, 20, 20);
		}
		return exclusions40;
	}

	*//**
	 * @return the exclusions41Desc
	 *//*
	private LabelBase getExclusions41Desc() {
		if (exclusions41Desc == null) {
			exclusions41Desc = new LabelBase();
			exclusions41Desc.setText("Suicide / Attempt suicide");
			exclusions41Desc.setBounds(490, 55, 200, 20);
		}
		return exclusions41Desc;
	}

	*//**
	 * @return the exclusions41
	 *//*
	private CheckBoxBase getExclusions41() {
		if (exclusions41 == null) {
			exclusions41 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions41.setBounds(710, 55, 20, 20);
		}
		return exclusions41;
	}

	*//**
	 * @return the exclusions42Desc
	 *//*
	private LabelBase getExclusions42Desc() {
		if (exclusions42Desc == null) {
			exclusions42Desc = new LabelBase();
			exclusions42Desc.setText("Travel costs for treatment");
			exclusions42Desc.setBounds(490, 80, 200, 20);
		}
		return exclusions42Desc;
	}

	*//**
	 * @return the exclusions42
	 *//*
	private CheckBoxBase getExclusions42() {
		if (exclusions42 == null) {
			exclusions42 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions42.setBounds(710, 80, 20, 20);
		}
		return exclusions42;
	}

	*//**
	 * @return the exclusions43Desc
	 *//*
	private LabelBase getExclusions43Desc() {
		if (exclusions43Desc == null) {
			exclusions43Desc = new LabelBase();
			exclusions43Desc.setText("Treatment conducted by family");
			exclusions43Desc.setBounds(490, 105, 200, 20);
		}
		return exclusions43Desc;
	}

	*//**
	 * @return the exclusions43
	 *//*
	private CheckBoxBase getExclusions43() {
		if (exclusions43 == null) {
			exclusions43 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions43.setBounds(710, 105, 20, 20);
		}
		return exclusions43;
	}

	*//**
	 * @return the exclusions44Desc
	 *//*
	private LabelBase getExclusions44Desc() {
		if (exclusions44Desc == null) {
			exclusions44Desc = new LabelBase();
			exclusions44Desc.setText("Treatment outside geographic area");
			exclusions44Desc.setBounds(490, 130, 200, 20);
		}
		return exclusions44Desc;
	}

	*//**
	 * @return the exclusions44
	 *//*
	private CheckBoxBase getExclusions44() {
		if (exclusions44 == null) {
			exclusions44 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions44.setBounds(710, 130, 20, 20);
		}
		return exclusions44;
	}

	*//**
	 * @return the exclusions45Desc
	 *//*
	private LabelBase getExclusions45Desc() {
		if (exclusions45Desc == null) {
			exclusions45Desc = new LabelBase();
			exclusions45Desc.setText("Unproved treatment");
			exclusions45Desc.setBounds(490, 155, 200, 20);
		}
		return exclusions45Desc;
	}

	*//**
	 * @return the exclusions45
	 *//*
	private CheckBoxBase getExclusions45() {
		if (exclusions45 == null) {
			exclusions45 =  new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions45.setBounds(710, 155, 20, 20);
		}
		return exclusions45;
	}

	*//**
	 * @return the exclusions46Desc
	 *//*
	private LabelBase getExclusions46Desc() {
		if (exclusions46Desc == null) {
			exclusions46Desc = new LabelBase();
			exclusions46Desc.setText("War / riots / radioactive contamination");
			exclusions46Desc.setBounds(490, 180, 200, 40);
		}
		return exclusions46Desc;
	}

	*//**
	 * @return the exclusions46
	 *//*
	private CheckBoxBase getExclusions46() {
		if (exclusions46 == null) {
			exclusions46 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions46.setBounds(710, 180, 20, 40);
		}
		return exclusions46;
	}

	*//**
	 * @return the exclusions47Desc
	 *//*
	private LabelBase getExclusions47Desc() {
		if (exclusions47Desc == null) {
			exclusions47Desc = new LabelBase();
			exclusions47Desc.setText("Well Baby");
			exclusions47Desc.setBounds(490, 225, 200, 20);
		}
		return exclusions47Desc;
	}

	*//**
	 * @return the exclusions47
	 *//*
	private CheckBoxBase getExclusions47() {
		if (exclusions47 == null) {
			exclusions47 = new CheckBoxBase(){
				@Override
				public void onClick() {
					getSaveButton().setEnabled(true);
				}
			};
			exclusions47.setBounds(710, 225, 20, 20);
		}
		return exclusions47;
	}*/
	
	private ButtonBase getSaveButton() {
		if (saveButton == null) {
			saveButton = new ButtonBase("Save"){
				@Override
				public void onClick() {
					QueryUtil.executeMasterAction(getUserInfo(), "GENEXCLUSION", "MOD",
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
			saveButton.setBounds(710, 525, 60, 25);
		}
		return saveButton;
	}
}
