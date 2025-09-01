package com.hkah.client.layout.dialog;

import java.util.HashMap;
import java.util.Map;

import com.extjs.gxt.ui.client.core.El;
import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.event.SelectionChangedEvent;
import com.extjs.gxt.ui.client.event.SelectionChangedListener;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.form.RadioGroup;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.event.CallbackListener;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.radiobutton.RadioButtonBase;
import com.hkah.client.layout.textfield.TextAmount;
import com.hkah.client.layout.textfield.TextAreaBase;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextSlipMergeSearch;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.Report;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsTransaction;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgReminderLetter extends DialogSlipBase {
	private final static int m_frameWidth = 500;
	private final static int m_frameHeight = 580;
	private final static String REDUPLICATE_SLIP_NO = "Reduplicate Slip No.!";

	private BasePanel RemDerLtrPanel = null;
	private LabelBase rmderTypeDesc = null;
	private ComboBoxBase rmderTypeCombo = null;
	private LabelBase onBefDesc = null;
	private TextDate onBefDate = null;
	private LabelBase signDesc = null;
	private ComboBoxBase signCombo = null;
	private LabelBase endDesc = null;
	private ComboBoxBase endCombo = null;
	private LabelBase typeDesc = null;
	private RadioButtonBase typeInsOpt = null;
	private RadioButtonBase typeGenOpt = null;
	private LabelBase rmkTxtDesc = null;
	private BasePanel slipPanel = null;
	private BasePanel copyPanel = null;
	private TextAreaBase remarkTextArea = null;

	private TextAmount slpAmount = null;
	private TextSlipMergeSearch mergeWith1 = null;
	private TextSlipMergeSearch mergeWith2 = null;
	private TextSlipMergeSearch mergeWith3 = null;
	private TextSlipMergeSearch mergeWith4 = null;
	private TextSlipMergeSearch mergeWith5 = null;
	private TextAmount mergewith1Amt = null;
	private TextAmount mergewith2Amt = null;
	private TextAmount mergewith3Amt = null;
	private TextAmount mergewith4Amt = null;
	private TextAmount mergewith5Amt = null;
	private LabelBase  totalDesc = null;
	private TextAmount totalAmt = null;

	private String memReportType = "";
	private String memSlpAmt = "";
	private String memPatNo = "";

//	private boolean isShowSign = false;

	public DlgReminderLetter(MainFrame owner) {
		super(owner, "yesokcancel", m_frameWidth, m_frameHeight);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Print Reminder Letter");
		setContentPane(getRemDerLtrPanel());
		getButtonById(YES).setText("Print", 'P');
		getButtonById(OK).setText("Preview");

		RadioGroup btngrp = new RadioGroup();
		btngrp.add(getTypeInsOpt());
		btngrp.add(getTypeGenOpt());

		// layout
		getMergeWithDesc().setText("Other Slip:");
		getSlpNoDesc().setBounds(30, 20, 110, 20);
		getSlpNo().setBounds(150, 20, 130, 20);
		getMergeWithDesc().setBounds(30, 50, 120, 20);
		getMergeWith1().setBounds(150, 50, 130, 20);
		getMergeWith2().setBounds(150, 75, 130, 20);
		getMergeWith3().setBounds(150, 100, 130, 20);
		getMergeWith4().setBounds(150, 125, 130, 20);
		getMergeWith5().setBounds(150, 150, 130, 20);

		getSlpAmount().setReadOnly(true);
		getMergeWith1Amt().setReadOnly(true);
		getMergeWith2Amt().setReadOnly(true);
		getMergeWith3Amt().setReadOnly(true);
		getMergeWith4Amt().setReadOnly(true);
		getMergeWith5Amt().setReadOnly(true);

		getMergeWith1().setEditable(false);
		getMergeWith2().setEditable(false);
		getMergeWith3().setEditable(false);
		getMergeWith4().setEditable(false);
		getMergeWith5().setEditable(false);

		getMergeWith1().setName("1");
		getMergeWith2().setName("2");
		getMergeWith3().setName("3");
		getMergeWith4().setName("4");
		getMergeWith5().setName("5");

		setClosable(true);
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/
	@Override
	public Component getDefaultFocusComponent() {
		return getRemDerLtrPanel();
	}

	public void showDialog(String patNo, String slpNo, String slpType,String slpAmt,
							String rptType,String rptLang,String smtRemark) {
		setMemSlipNo(slpNo);
//		setSlipType(slpType);
		memReportType = rptType;
		memSlpAmt = slpAmt;

		clearSlipField();
		getRemarkTextArea().setText(smtRemark);
		getSlpAmount().setText(memSlpAmt);
		setParameter("PatNo", patNo);
		setLanguage(rptLang);
		memPatNo = patNo;
		resetContent();
		loadOldSlipNo(false);
		getTotalAmt().setText(countTotal());
		getButtonById(OK).setEnabled(false);
		getButtonById(YES).setEnabled(false);
		setVisible(true);
	}

	@Override
	protected void doYesAction() {
		printRpt();
	}

	@Override
	protected void doOkAction() {
		previewRpt();
	}

	@Override
	protected void postSetTextAction(final String slpno, final TextSlipMergeSearch slpnoField) {
		slipLostFocus(slpno,slpnoField);
	}

	@Override
	protected void slipLostFocus(final String slpno, final TextSlipMergeSearch slpnoField) {
		QueryUtil.executeMasterBrowse( getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] {"slip s", "S.SlpCAmt + S.SlpDAmt + S.SlpPAmt AS SlpNAmt", "s.slpno='" + slpno + "'"},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				updateSlpAmt(slpnoField.getName(),
				mQueue.getContentField()[0]);
			}
		});
	}

	@Override
	protected void slipNoChange(String slpno, final TextSlipMergeSearch slpnoField) {
		resetSlpAmt(slpnoField.getName());
	}

	private void updateSlpAmt(String slpField,String slpAmt){
		if ("0".equals(slpField)) {
				getSlpAmount().setText(slpAmt);
		} else if ("1".equals(slpField)) {
				getMergeWith1Amt().setText(slpAmt);
		} else if ("2".equals(slpField)) {
				getMergeWith2Amt().setText(slpAmt);
		} else if ("3".equals(slpField)) {
				getMergeWith3Amt().setText(slpAmt);
		} else if ("4".equals(slpField)) {
				getMergeWith4Amt().setText(slpAmt);
		} else if ("5".equals(slpField)) {
				getMergeWith5Amt().setText(slpAmt);
		}
		getTotalAmt().setText(countTotal());
	}

	private void resetSlpAmt(String slpField){
		if ("1".equals(slpField)) {
			getMergeWith1Amt().resetText();
		} else if ("2".equals(slpField)) {
			getMergeWith2Amt().resetText();
		} else if ("3".equals(slpField)) {
			getMergeWith3Amt().resetText();
		} else if ("4".equals(slpField)) {
			getMergeWith4Amt().resetText();
		} else if ("5".equals(slpField)) {
			getMergeWith5Amt().resetText();
		}
		getTotalAmt().setText(countTotal());
	}

	private void resetContent(){
		getSignCombo().resetText();
		getRemarkTextArea().resetText();
		getOnBefDate().resetText();
		getrmderTypeCombo().resetText();
		getEndCombo().resetText();
		getTypeGenOpt().setSelected(true);
	}

	private Double parseAmount(String amt){
		if (amt.length() > 0){
			return Double.parseDouble(amt);
		} else {
			return Double.parseDouble("0");
		}
	}

	private String countTotal(){
		return TextUtil.formatCurrency(
				parseAmount(getSlpAmount().getText())+
				parseAmount(getMergeWith1Amt().getText())+
				parseAmount(getMergeWith2Amt().getText())+
				parseAmount(getMergeWith3Amt().getText())+
				parseAmount(getMergeWith4Amt().getText())+
				parseAmount(getMergeWith5Amt().getText())
				).replaceAll(COMMA_VALUE, EMPTY_VALUE);
	}

	private String[] getPrintInputParam(){
		String slpList = getSlpNo().getText()+"/"+
		 getMergeWith1().getText()+(!"".equals(getMergeWith2().getText())?"/":"")+
		 getMergeWith2().getText()+(!"".equals(getMergeWith3().getText())?"/":"")+
		 getMergeWith3().getText()+(!"".equals(getMergeWith4().getText())?"/":"")+
		 getMergeWith4().getText()+(!"".equals(getMergeWith5().getText())?"/":"")+
		 getMergeWith5().getText();

		String slpAmtList =
			"SELECT '"+ getSlpNo().getText()+"' as slpno, '"+getSlpAmount().getText()+"' as amt FROM DUAL"+
			(!"".equals(getMergeWith1().getText())?
				" UNION SELECT '"+getMergeWith1().getText()+"' as slpno, '"
				+getMergeWith1Amt().getText()+"' as amt FROM DUAL":"")+
			(!"".equals(getMergeWith2().getText())?
					" UNION SELECT '"+getMergeWith2().getText()+"' as slpno, '"
					+getMergeWith2Amt().getText()+"' as amt FROM DUAL":"")+
			(!"".equals(getMergeWith3().getText())?
					" UNION SELECT '"+getMergeWith3().getText()+"' as slpno, '"
					+getMergeWith3Amt().getText()+"' as amt FROM DUAL":"")+
			(!"".equals(getMergeWith4().getText())?
					" UNION SELECT '"+getMergeWith4().getText()+"' as slpno, '"
					+getMergeWith4Amt().getText()+"' as amt FROM DUAL":"")+
			(!"".equals(getMergeWith5().getText())?
					" UNION SELECT '"+getMergeWith5().getText()+"' as slpno, '"
					+getMergeWith5Amt().getText()+"' as amt FROM DUAL":"");

		return new String[] {slpList,memPatNo,slpAmtList};

	}

	private Map<String,String> getPrintMap(){
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("totalAmt", getTotalAmt().getText());
		map.put("onBefDate", getOnBefDate().getText());
		map.put("rdrType", getrmderTypeCombo().getText());
		map.put("patNo", memPatNo);
		map.put("SUBREPORT_DIR", CommonUtil.getReportDir());
		map.put("signName", getSignCombo().getDisplayText());
		map.put("signID", getSignCombo().getText());
		map.put("isInsurance", getTypeInsOpt().isSelected()?"Y":"N");
		map.put("reason", getRemarkTextArea().getText());
		map.put("end", getEndCombo().getText());
		return map;
	}

	private void previewRpt(){

		Report.print(Factory.getInstance().getUserInfo(),
					"ReminderLetter_HKAH", getPrintMap(),getPrintInputParam(),
					new String[] {"PATTITLE","PATFNAME","PATGNAME","PATADD1",
					"PATADD2","PATADD3","PATCOUNTRY","PATTYPE","REGDATE","INPDDATE","SLPNO","AMT"},
					new boolean[] {false, false, false, false,false, false, false, false,false, false, false, false},
					new String[] {"ReminderLetter_HKAH_AD"},new String[][]{{getPrintInputParam()[2]}},
					new String[][]{{"SLPNO","AMT"}},new boolean[][] {{false, false}},
					"", true, false, true, false, new CallbackListener() {
						@Override
						public void handleRetBool(boolean ret, String result, MessageQueue mQueue) {
							if(ret){
								QueryUtil.executeMasterAction(getUserInfo(), "TXNRMDER2", QueryUtil.ACTION_APPEND,
										new String[] {
											null,
											getAllSlip(true),
											null,
											getrmderTypeCombo().getText(),
											Factory.getInstance().getUserInfo().getUserID(),
											null,null,null,
											(getTypeInsOpt().isSelected()?getRemarkTextArea().getText()
											+(!"".equals(getEndCombo().getText())?"(Ins:"+getEndCombo().getText()+")":"")
											:""),
											getUserInfo().getUserID(),getSignCombo().getText()
										},
										new MessageQueueCallBack() {
									@Override
									public void onPostSuccess(MessageQueue mQueue) {
										dispose();
									}
								});
							}
						}
					}, null, null, false);


	}

	private void printRpt() {
		if (PrintingUtil.print("DEFAULT",
				"ReminderLetter_HKAH",
				getPrintMap(),"",getPrintInputParam(),
				new String[] {"PATTITLE","PATFNAME","PATGNAME","PATADD1",
				"PATADD2","PATADD3","PATCOUNTRY","PATTYPE","REGDATE","INPDDATE","SLPNO","AMT"},
				1,new String[]{"ReminderLetter_HKAH_AD"},new String[][]{{getPrintInputParam()[2]}},
				new String[][]{{"SLPNO","AMT"}},new boolean[][]{{false,false}},1)){

			QueryUtil.executeMasterAction(getUserInfo(), "TXNRMDER2", QueryUtil.ACTION_APPEND,
					new String[] {
							null,
							getAllSlip(true),
							null,
							getrmderTypeCombo().getText(),
							Factory.getInstance().getUserInfo().getUserID(),
							null,null,null,
							(getTypeInsOpt().isSelected()?getRemarkTextArea().getText():""),
							getUserInfo().getUserID(),getSignCombo().getText()
					},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						Factory.getInstance().addInformationMessage("Reminder Record updated!");
					} else {
						Factory.getInstance().addErrorMessage(mQueue);
					}
				}
			});
		}
	}

	@Override
	protected void clearSlipField() {
		super.clearSlipField();
		getSlpAmount().resetText();
		getRemarkTextArea().resetText();
		getMergeWith1Amt().resetText();
		getMergeWith2Amt().resetText();
		getMergeWith3Amt().resetText();
		getMergeWith4Amt().resetText();
		getMergeWith5Amt().resetText();
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getRemDerLtrPanel() {
		if (RemDerLtrPanel == null) {
			RemDerLtrPanel = new BasePanel();
			RemDerLtrPanel.setBounds(5, 5, 460, 360);
			RemDerLtrPanel.add(getSlipPanel(), null);
			RemDerLtrPanel.add(getCopyPanel(), null);
		}
		return RemDerLtrPanel;
	}

	protected BasePanel getSlipPanel() {
		if (slipPanel == null) {
			slipPanel = new BasePanel();
			slipPanel.setBounds(5, 5, 450, 220);
			slipPanel.setBorders(true);
			slipPanel.add(getSlpNoDesc(), null);
			slipPanel.add(getSlpNo(), null);
			slipPanel.add(getSlpAmount(), null);
			slipPanel.add(getMergeWithDesc(), null);
			slipPanel.add(getMergeWith1(), null);
			slipPanel.add(getMergeWith2(), null);
			slipPanel.add(getMergeWith3(), null);
			slipPanel.add(getMergeWith4(), null);
			slipPanel.add(getMergeWith5(), null);
			slipPanel.add(getMergeWith1Amt(), null);
			slipPanel.add(getMergeWith2Amt(), null);
			slipPanel.add(getMergeWith3Amt(), null);
			slipPanel.add(getMergeWith4Amt(), null);
			slipPanel.add(getMergeWith5Amt(), null);
			slipPanel.add(getTotalDesc(), null);
			slipPanel.add(getTotalAmt(), null);
		}
		return slipPanel;
	}

	private BasePanel getCopyPanel() {
		if (copyPanel == null) {
			copyPanel = new BasePanel();
			copyPanel.setBounds(5, 230, 450, 250);
			copyPanel.setBorders(true);
			copyPanel.add(getOnBefDesc(), null);
			copyPanel.add(getOnBefDate(), null);
			copyPanel.add(getSignDesc(), null);
			copyPanel.add(getSignCombo(), null);
			copyPanel.add(getTypeDesc(), null);
			copyPanel.add(getTypeInsOpt(), null);
			copyPanel.add(getTypeGenOpt(), null);
			copyPanel.add(getRmkTxtDesc(), null);
			copyPanel.add(getRemarkTextArea(), null);
			copyPanel.add(getrmderTypeDesc(), null);
			copyPanel.add(getrmderTypeCombo(), null);
			copyPanel.add(getEndDesc(), null);
			copyPanel.add(getEndCombo(), null);
		}
		return copyPanel;
	}

	@Override
	protected TextSlipMergeSearch getMergeWith1() {
		if (mergeWith1 == null) {
			mergeWith1 = new TextSlipMergeSearch() {
				public void onBlur() {
					String slpNo1 = mergeWith1.getText().trim();
					if (slpNo1.length() > 0) {
						if (slpNo1.equals(getMemSlipNo())
								|| slpNo1.equals(getMergeWith2().getText().trim())
								|| slpNo1.equals(getMergeWith3().getText().trim())
								|| slpNo1.equals(getMergeWith4().getText().trim())
								|| slpNo1.equals(getMergeWith5().getText().trim())
								|| slpNo1.equals(getMergeWith6().getText().trim())
								|| slpNo1.equals(getMergeWith7().getText().trim())
								|| slpNo1.equals(getMergeWith8().getText().trim())
								|| slpNo1.equals(getMergeWith9().getText().trim())
								|| slpNo1.equals(getMergeWith10().getText().trim())) {

							Factory.getInstance().addErrorMessage(REDUPLICATE_SLIP_NO);
							mergeWith1.resetText();
							slpNo1 = null;
							slipLostFocus(slpNo1, this);
							return;
						}

						slipLostFocus(slpNo1, this);
					}
					slipNoChange(slpNo1, this);
				}

				@Override
				public void setEditable(boolean editable) {
					if (rendered) {
						El fromEl = getInputEl();
						fromEl.dom.setPropertyBoolean("readOnly", true);
						fromEl.setStyleName("x-triggerfield-noedit", true);
					}
				}

				@Override
				public void setText(String value) {
					super.setText(value, false);
					postSetTextAction(getText(),this);
				}
			};
			mergeWith1.setShowClearButton(true);
			mergeWith1.setBounds(190, 25, 160, 20);

		}
		return mergeWith1;
	}

	protected TextSlipMergeSearch getMergeWith2() {
		if (mergeWith2 == null) {
			mergeWith2 = new TextSlipMergeSearch() {
				public void onBlur() {
					String slpNo2 = mergeWith2.getText().trim();
					if (slpNo2.length() > 0) {
						if (slpNo2.equals(getMemSlipNo())
								|| slpNo2.equals(getMergeWith1().getText().trim())
								|| slpNo2.equals(getMergeWith3().getText().trim())
								|| slpNo2.equals(getMergeWith4().getText().trim())
								|| slpNo2.equals(getMergeWith5().getText().trim())
								|| slpNo2.equals(getMergeWith6().getText().trim())
								|| slpNo2.equals(getMergeWith7().getText().trim())
								|| slpNo2.equals(getMergeWith8().getText().trim())
								|| slpNo2.equals(getMergeWith9().getText().trim())
								|| slpNo2.equals(getMergeWith10().getText().trim())) {

							Factory.getInstance().addErrorMessage(REDUPLICATE_SLIP_NO);
							mergeWith2.resetText();
							slpNo2 = null;
							slipLostFocus(slpNo2, this);
							return;
						}

						slipLostFocus(slpNo2, this);
					}
					slipNoChange(slpNo2, this);
				}

				@Override
				public void setText(String value) {
					super.setText(value, false);
					postSetTextAction(getText(),this);
				}

				@Override
				public void setEditable(boolean editable) {
					if (rendered) {
						El fromEl = getInputEl();
						fromEl.dom.setPropertyBoolean("readOnly", true);
						fromEl.setStyleName("x-triggerfield-noedit", true);
					}
				}
			};
			mergeWith2.setShowClearButton(true);
			mergeWith2.setBounds(190, 50, 130, 20);
		}
		return mergeWith2;
	}

	protected TextSlipMergeSearch getMergeWith3() {
		if (mergeWith3 == null) {
			mergeWith3 = new TextSlipMergeSearch() {
				public void onBlur() {
					String slpNo3 = mergeWith3.getText().trim();
					if (slpNo3.length() > 0) {
						if (slpNo3.equals(getMemSlipNo())
								|| slpNo3.equals(getMergeWith1().getText().trim())
								|| slpNo3.equals(getMergeWith2().getText().trim())
								|| slpNo3.equals(getMergeWith4().getText().trim())
								|| slpNo3.equals(getMergeWith5().getText().trim())
								|| slpNo3.equals(getMergeWith6().getText().trim())
								|| slpNo3.equals(getMergeWith7().getText().trim())
								|| slpNo3.equals(getMergeWith8().getText().trim())
								|| slpNo3.equals(getMergeWith9().getText().trim())
								|| slpNo3.equals(getMergeWith10().getText().trim())) {

							Factory.getInstance().addErrorMessage(REDUPLICATE_SLIP_NO);
							mergeWith3.resetText();
							slpNo3 = null;
							slipLostFocus(slpNo3, this);
							return;
						}

						slipLostFocus(slpNo3, this);
					}
					slipNoChange(slpNo3, this);
				}

				@Override
				public void setText(String value) {
					super.setText(value, false);
					postSetTextAction(getText(),this);
				}

				@Override
				public void setEditable(boolean editable) {
					if (rendered) {
						El fromEl = getInputEl();
						fromEl.dom.setPropertyBoolean("readOnly", true);
						fromEl.setStyleName("x-triggerfield-noedit", true);
					}
				}
			};
			mergeWith3.setShowClearButton(true);
			mergeWith3.setBounds(190, 75, 130, 20);
		}
		return mergeWith3;
	}

	protected TextSlipMergeSearch getMergeWith4() {
		if (mergeWith4 == null) {
			mergeWith4 = new TextSlipMergeSearch() {
				public void onBlur() {
					String slpNo4 = mergeWith4.getText().trim();
					if (slpNo4.length() > 0) {
						if (slpNo4.equals(getMemSlipNo())
								|| slpNo4.equals(getMergeWith1().getText().trim())
								|| slpNo4.equals(getMergeWith2().getText().trim())
								|| slpNo4.equals(getMergeWith3().getText().trim())
								|| slpNo4.equals(getMergeWith5().getText().trim())
								|| slpNo4.equals(getMergeWith6().getText().trim())
								|| slpNo4.equals(getMergeWith7().getText().trim())
								|| slpNo4.equals(getMergeWith8().getText().trim())
								|| slpNo4.equals(getMergeWith9().getText().trim())
								|| slpNo4.equals(getMergeWith10().getText().trim())) {

							Factory.getInstance().addErrorMessage(REDUPLICATE_SLIP_NO);
							mergeWith4.resetText();
							slpNo4 = null;
							slipLostFocus(slpNo4, this);
							return;
						}

						slipLostFocus(slpNo4, this);
					}
					slipNoChange(slpNo4, this);
				}

				@Override
				public void setText(String value) {
					super.setText(value, false);
					postSetTextAction(getText(),this);
				}

				@Override
				public void setEditable(boolean editable) {
					if (rendered) {
						El fromEl = getInputEl();
						fromEl.dom.setPropertyBoolean("readOnly", true);
						fromEl.setStyleName("x-triggerfield-noedit", true);
					}
				}
			};
			mergeWith4.setShowClearButton(true);
			mergeWith4.setBounds(190, 100, 130, 20);
		}
		return mergeWith4;
	}

	protected TextSlipMergeSearch getMergeWith5() {
		if (mergeWith5 == null) {
			mergeWith5 = new TextSlipMergeSearch() {
				public void onBlur() {
					String slpNo5 = mergeWith5.getText().trim();
					if (slpNo5.length() > 0) {
						if (slpNo5.equals(getMemSlipNo())
								|| slpNo5.equals(getMergeWith1().getText().trim())
								|| slpNo5.equals(getMergeWith2().getText().trim())
								|| slpNo5.equals(getMergeWith3().getText().trim())
								|| slpNo5.equals(getMergeWith4().getText().trim())
								|| slpNo5.equals(getMergeWith6().getText().trim())
								|| slpNo5.equals(getMergeWith7().getText().trim())
								|| slpNo5.equals(getMergeWith8().getText().trim())
								|| slpNo5.equals(getMergeWith9().getText().trim())
								|| slpNo5.equals(getMergeWith10().getText().trim())) {

							Factory.getInstance().addErrorMessage(REDUPLICATE_SLIP_NO);
							mergeWith5.resetText();
							slpNo5 = null;
							slipLostFocus(slpNo5, this);
							return;
						}

						slipLostFocus(slpNo5, this);
					}
					slipNoChange(slpNo5, this);
				}

				@Override
				public void setText(String value) {
					super.setText(value, false);
					postSetTextAction(getText(),this);
				}

				@Override
				public void setEditable(boolean editable) {
					if (rendered) {
						El fromEl = getInputEl();
						fromEl.dom.setPropertyBoolean("readOnly", true);
						fromEl.setStyleName("x-triggerfield-noedit", true);
					}
				}
			};
			mergeWith5.setShowClearButton(true);
			mergeWith5.setBounds(190, 125, 130, 20);
		}
		return mergeWith5;
	}

	private TextAmount getSlpAmount() {
		if (slpAmount == null) {
			slpAmount = new TextAmount(ConstantsTransaction.MAX_AMOUNT_LIMIT){
				public void onBlur() {
					getTotalAmt().setText(countTotal());
				}
			};
			slpAmount.setBounds(300, 20, 130, 20);
		}
		return slpAmount;
	}

	private TextAmount getMergeWith1Amt() {
		if (mergewith1Amt == null) {
			mergewith1Amt = new TextAmount(ConstantsTransaction.MAX_AMOUNT_LIMIT,true){
				public void onBlur() {
					getTotalAmt().setText(countTotal());
				}
			};
			mergewith1Amt.setBounds(300, 50, 130, 20);
		}
		return mergewith1Amt;
	}

	private TextAmount getMergeWith2Amt() {
		if (mergewith2Amt == null) {
			mergewith2Amt = new TextAmount(ConstantsTransaction.MAX_AMOUNT_LIMIT){
				public void onBlur() {
					getTotalAmt().setText(countTotal());
				}
			};
			mergewith2Amt.setBounds(300, 75, 130, 20);
		}
		return mergewith2Amt;
	}

	private TextAmount getMergeWith3Amt() {
		if (mergewith3Amt == null) {
			mergewith3Amt = new TextAmount(ConstantsTransaction.MAX_AMOUNT_LIMIT){
				public void onBlur() {
					getTotalAmt().setText(countTotal());
				}
			};
			mergewith3Amt.setBounds(300, 100, 130, 20);
		}
		return mergewith3Amt;
	}

	private TextAmount getMergeWith4Amt() {
		if (mergewith4Amt == null) {
			mergewith4Amt = new TextAmount(ConstantsTransaction.MAX_AMOUNT_LIMIT){
				public void onBlur() {
					getTotalAmt().setText(countTotal());
				}
			};
			mergewith4Amt.setBounds(300, 125, 130, 20);
		}
		return mergewith4Amt;
	}

	private TextAmount getMergeWith5Amt() {
		if (mergewith5Amt == null) {
			mergewith5Amt = new TextAmount(ConstantsTransaction.MAX_AMOUNT_LIMIT){
				public void onBlur() {
					getTotalAmt().setText(countTotal());
				}
			};
			mergewith5Amt.setBounds(300, 150, 130, 20);
		}
		return mergewith5Amt;
	}

	protected LabelBase getTotalDesc() {
		if (totalDesc == null) {
			totalDesc = new LabelBase();
			totalDesc.setBounds(250, 190, 50, 20);
			totalDesc.setText("Total:");
		}
		return totalDesc;
	}

	private TextAmount getTotalAmt() {
		if (totalAmt == null) {
			totalAmt = new TextAmount(ConstantsTransaction.MAX_AMOUNT_LIMIT);
			totalAmt.setBounds(300, 190, 130, 20);
		}
		return totalAmt;
	}

	private LabelBase getrmderTypeDesc() {
		if (rmderTypeDesc == null) {
			rmderTypeDesc = new LabelBase();
			rmderTypeDesc.setText("ReminderType: ");
			rmderTypeDesc.setBounds(30, 10, 120, 20);
		}
		return rmderTypeDesc;
	}

	private ComboBoxBase getrmderTypeCombo() {
		if (rmderTypeCombo == null) {
			rmderTypeCombo = new ComboBoxBase("RMDERTYPE", false, false, true);
			rmderTypeCombo.addSelectionChangedListener(new SelectionChangedListener<ModelData>() {
				public void selectionChanged(SelectionChangedEvent se) {
					getButtonById(OK).setEnabled(true);
					getButtonById(YES).setEnabled(true);
					if("DENTIST".equals(Factory.getInstance().getUserInfo().getOtherCode())){
						if("1".equals(rmderTypeCombo.getText())){
							getOnBefDate().setEditable(false);
							getSignCombo().setText("DEN");
						} else if("2".equals(rmderTypeCombo.getText())){
							getOnBefDate().setEditable(true);
							getSignCombo().setText("DENNOE");
						} else if("3".equals(rmderTypeCombo.getText())){
							getOnBefDate().setEditable(true);
							getSignCombo().setText("DENMAR");
						}
					} else {
						if("1".equals(rmderTypeCombo.getText())){
							getOnBefDate().setEditable(false);
							getSignCombo().setText("PBO");
						} else if("2".equals(rmderTypeCombo.getText())){
							getOnBefDate().setEditable(true);
							getSignCombo().setText("PBOPEG");
						} else if("3".equals(rmderTypeCombo.getText())){
							getOnBefDate().setEditable(true);
							getSignCombo().setText("PBOBEC");
						}
					}
				}
			});
			rmderTypeCombo.setBounds(150, 10, 180, 20);
		}
		return rmderTypeCombo;
	}

	private LabelBase getOnBefDesc() {
		if (onBefDesc == null) {
			onBefDesc = new LabelBase();
			onBefDesc.setText("On or Before Date");
			onBefDesc.setBounds(30, 40, 120, 20);
		}
		return onBefDesc;
	}

	private TextDate getOnBefDate() {
		if (onBefDate == null) {
			onBefDate = new TextDate();
			onBefDate.setBounds(150, 40, 180, 20);
		}
		return onBefDate;
	}

	private LabelBase getSignDesc() {
		if (signDesc == null) {
			signDesc = new LabelBase();
			signDesc.setText("Signature: ");
			signDesc.setBounds(30, 70, 120, 20);
		}
		return signDesc;
	}

	private ComboBoxBase getSignCombo() {
		if (signCombo == null) {
			signCombo = new ComboBoxBase("RMDERSIGN", new String[]{Factory.getInstance().getUserInfo().getOtherCode()},
					null, null, -1, false, false, false, true);
			signCombo.setBounds(150, 70, 250, 20);
			signCombo.setMinListWidth(270);
		}
		return signCombo;
	}

	private LabelBase getTypeDesc() {
		if (typeDesc == null) {
			typeDesc = new LabelBase();
			typeDesc.setText("Type: ");
			typeDesc.setBounds(30, 100, 50, 20);
		}
		return typeDesc;
	}

	public RadioButtonBase getTypeInsOpt() {
		if (typeInsOpt == null) {
			typeInsOpt = new RadioButtonBase();
			typeInsOpt.setText("Insurance");
			typeInsOpt.setBounds(150, 100, 80, 20);
		}
		return typeInsOpt;
	}

	public RadioButtonBase getTypeGenOpt() {
		if (typeGenOpt == null) {
			typeGenOpt = new RadioButtonBase();
			typeGenOpt.setText("General");
			typeGenOpt.setSelected(true);
			typeGenOpt.setBounds(240, 100, 100, 20);
		}
		return typeGenOpt;
	}

	private LabelBase getRmkTxtDesc() {
		if (rmkTxtDesc == null) {
			rmkTxtDesc = new LabelBase();
			rmkTxtDesc.setText("Diagnosis/Reason: ");
			rmkTxtDesc.setBounds(30, 130, 120, 20);
		}
		return rmkTxtDesc;
	}

	private TextAreaBase getRemarkTextArea() {
		if (remarkTextArea == null) {
			remarkTextArea = new TextAreaBase();
			remarkTextArea.setMaxLength(2000);
			remarkTextArea.setBounds(150, 130, 280, 50);
		}
		return remarkTextArea;
	}

	private LabelBase getEndDesc() {
		if (endDesc == null) {
			endDesc = new LabelBase();
			endDesc.setText("Enclose document/Contact insurer: ");
			endDesc.setBounds(30, 185, 150, 20);
		}
		return endDesc;
	}

	private ComboBoxBase getEndCombo() {
		if (endCombo == null) {
			endCombo = new ComboBoxBase("RMDEREND", false, false, true);
			endCombo.setBounds(150, 200, 250, 20);
			endCombo.setMinListWidth(400);
		}
		return endCombo;
	}
}