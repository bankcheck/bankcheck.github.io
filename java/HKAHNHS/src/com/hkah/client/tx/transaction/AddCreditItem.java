package com.hkah.client.tx.transaction;

import java.util.HashMap;

import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.event.FieldEvent;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.google.gwt.event.dom.client.KeyCodes;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.combobox.ComboCreditItemType;
import com.hkah.client.layout.combobox.ComboDoctor;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.dialogsearch.DlgItemSearch;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.textfield.TextItemCodeSearch;
import com.hkah.client.layout.textfield.TextNum;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.ActionPanel;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTransaction;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class AddCreditItem extends ActionPanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return "ENTRY";
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.ADDCREDITITEM_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Seq No",
				"Pkg Code",
				"Item Code",
				"Discount %",
				"Amount",
				"Doctor Code",
				"Date",
				"Service Code",
				"Status",
				"Description"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				50, 60, 60, 70, 70, 70, 90, 70, 50, 300
		};
	}
	
	@Override
	protected boolean getListTableSelectOnList(){
		return false;
	}

	private BasePanel actionPanel = null;
	private FieldSetBase CreditItemDetailPanel = null;
	private FieldSetBase CreditItemListPanel = null;
	private JScrollPane CreditItemScrollPane = null;
	private LabelBase ItemCodeDesc = null;
	private TextItemCodeSearch ItemCode = null;
	private TextReadOnly ItemName = null;
	private LabelBase DoctorCodeDesc = null;
	private ComboDoctor DoctorCode = null;
	private TextReadOnly DoctorName = null;
	private LabelBase CreditAmtDesc = null;
	private TextNum CreditAmt = null;
	private LabelBase ItemTypeDesc = null;
	private ComboCreditItemType ItemType = null;
	private LabelBase CreditPercentDesc = null;
	private TextNum CreditPercent = null; ;
	private LabelBase DescDesc = null;
	private TextString Desc = null;
	private LabelBase MaxinumDesc = null;
	private TextReadOnly Maxinum = null;
	private LabelBase CreditGivenDesc = null;
	private TextReadOnly CreditGiven = null;
	private LabelBase OperAddDesc = null;
	private LabelBase OperEqualDesc = null;
	private LabelBase BalanceDesc = null;
	private TextReadOnly Balance = null;
	private ButtonBase Calculate = null;

	private String memSlipNo = EMPTY_VALUE;
	private String memBedCode = EMPTY_VALUE;
	private String memDocCode = EMPTY_VALUE;
	private String memAcmCode = EMPTY_VALUE;
	private String memItmRlvl = EMPTY_VALUE;
	private String memStnTDate = EMPTY_VALUE;
	private String memItmType = EMPTY_VALUE;
//	private String memStnID = EMPTY_VALUE;

    /**
	 * This method initializes
	 *
	 */
	public AddCreditItem() {
		super();
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		// set column amount
		getListTable().setColumnAmount(3);
		getListTable().setColumnAmount(4);

	    memSlipNo = getParameter("SlpNo");
	    memBedCode = getParameter("BedCode");
		memDocCode = getParameter("DocCode");
		memAcmCode = getParameter("AcmCode");
		memItmRlvl = EMPTY_VALUE;
		memStnTDate = EMPTY_VALUE;
	    memItmType = getParameter("ItmType");
//	    memStnID = getParameter("StnID");
//		totalCharge = getParameter("TotalCharge");

		if (memSlipNo != null && memSlipNo.trim().length() > 0) {
//			QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LIST_TRANSACTION_SUBDETAIL_TXCODE, new String[] {slipNo ,"C"},
			QueryUtil.executeMasterBrowse(getUserInfo(), "TRANSACTION_CREDIT", new String[] {memSlipNo ,"C"},
					new MessageQueueCallBack() {
						public void onPostSuccess(MessageQueue mQueue) {
							getListTable().setListTableContent(mQueue);
						}
					});
//			getListTable().setListTableContent(QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LIST_TRANSACTION_SUBDETAIL_TXCODE, new String[] {slipNo ,"C"}));
			QueryUtil.executeMasterFetch(getUserInfo(), "DOCTOR_ACTIVE", new String[] {memDocCode},
					new MessageQueueCallBack() {
				public void onPostSuccess(MessageQueue mQueue) {
					getDoctorName().setText(mQueue.getContentField()[0]);
				}
			});
//			getDoctorName().setText(QueryUtil.executeMasterFetch(getUserInfo(), "DOCTOR_ACTIVE", new String[] {getDoctorCode().getText()}).getContentField()[1]);
			getDoctorCode().setText(memDocCode);
		}

// Cannot find such code in VB
/*
		if (getParameter("itmCode1") != null && getParameter("itmCode1").trim().length() > 0) {
			getItemCode().setText(getParameter("itmCode1"));
			getItemName().setText(getParameter("itmName"));
			resetParameter("itmCode1");
			resetParameter("itmName");
		} else {
			getItemCode().resetText();
			getItemName().resetText();
		}

		getCreditAmt().resetText();
		getItemType().resetText();
		getCreditPercent().resetText();
		getDesc().resetText();
*/
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextItemCodeSearch getDefaultFocusComponent() {
		return getItemCode();
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

	/* >>> ~15~ Set Fetch Output Results ============================== <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
//		logger.info("slipNo>>>"+slipNo);
//		logger.info("itmcode>>>"+getItemCode().getText());
//		logger.info("acmCode>>>"+acmCode);
//		QueryUtil.executeMasterFetch(getUserInfo(),ConstantsTx.CREDITITEMCHARGE_TXCODE, new String[] {slipNo, getItemCode().getText(),acmCode}, new MessageQueueCallBack() {
//			@Override
//			public void onPostSuccess(MessageQueue mQueue) {
//			}
//		});
//		String itmType = EMPTY_VALUE;
//		String cperc = EMPTY_VALUE;
//		if (getCreditAmt().getText().trim().length()==0) {
//			itmType=getItemType().getText();
//			cperc=getCreditPercent().getText().trim();
//		}
//		String[] s=mQueue.getContentField(); //pkgcode,itmcode,acmcode,glccode,cpsid,cpspct,itctype,itcamt1,itcamt2,itmrlvl
//		if (s != null && s.length>0) {
//			String[] para = new String[] {//v_slpno, v_pkgcode,v_itmcode,v_stat:= 'N',v_pkgrlvl,v_doccode,v_acmcode,v_stntdate,v_amount:= '0',v_override :='N',v_ref_no,v_cpsid,v_unit,
//				slipNo,
//				EMPTY_VALUE,//set package code null;
//				getItemCode().getText().trim(), //set package code null;
//				"N",
//				s[9],
//				getDoctorCode().getText(),
//				s[2],
//				date,
//				getCreditAmt().getText().trim(),
//				getCreditAmt().getText().trim(),
//				"Y",
//				EMPTY_VALUE,
//				s[4],
//				"1",
//				getDesc().getText().trim(),
//				EMPTY_VALUE,
//				itmType,
//				cperc,
//				"C"
//			};
//			return para;
//		}
		return new String[] {};
	}

	/* >>> ~16.1~ Set Action Output Parameters =========================== <<< */
	@Override
	protected void getNewOutputValue(String returnValue) {}

	/* >>> ~17~ Set Action Validation ================================= <<< */
	@Override
	protected void actionValidationReady(final String actionType, boolean isValidationReady) {
		if (isValidationReady) {
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] {"Item", "ItmRlvl", "ItmCode='" + getItemCode().getText() + "'"},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					String[] para = new String[] {"Item","ItmRlvl","ItmCode='"+getItemCode().getText()+"'"};
					if (mQueue.success()) {
						memItmRlvl = mQueue.getContentField()[0];
						String credit = getCreditAmt().getText().trim();
						if (credit.trim().length() == 0) {
							if ("A".equals(getItemType().getText())) {
								para = new String[] {"Sliptx","Sum(STNNAMT) as StnBAmt"," SlpNo='"+memSlipNo+"' and StnType='"
										+ConstantsTransaction.SLIPTX_TYPE_DEBIT+"' and (StnSts='"+ConstantsTransaction.SLIPTX_STATUS_NORMAL+
										"' or StnSts='"+ConstantsTransaction.SLIPTX_STATUS_ADJUST+"')"};
							} else {
								if ("D".equals(memItmType) && "D".equals(getItemType().getText())) {
									para = new String[] {"Sliptx","Sum(STNNAMT) as StnBAmt"," SlpNo='"+memSlipNo+"' and StnType='"
											+ConstantsTransaction.SLIPTX_TYPE_DEBIT+"' and (StnSts='"+ConstantsTransaction.SLIPTX_STATUS_NORMAL+
											"' or StnSts='"+ConstantsTransaction.SLIPTX_STATUS_ADJUST+"') and itmtype ='"+
											getItemType().getText()+"' and doccode = '"+getDoctorCode().getText()+"'"};
								} else {
									para = new String[] {"Sliptx","Sum(STNNAMT) as StnBAmt"," SlpNo='"+memSlipNo+"' and StnType='"
											+ConstantsTransaction.SLIPTX_TYPE_DEBIT+"' and (StnSts='"+ConstantsTransaction.SLIPTX_STATUS_NORMAL+
											"' or StnSts='"+ConstantsTransaction.SLIPTX_STATUS_ADJUST+"') and itmtype ='"+
											getItemType().getText()+"'"};
								}
							}

							QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
									para, new MessageQueueCallBack() {
								@Override
								public void onPostSuccess(MessageQueue mQueue) {
									String credit = getCreditAmt().getText().trim();
									if (mQueue.success()) {
										credit = String.valueOf(Math.round(Double.valueOf(mQueue.getContentField()[0])*Double.valueOf(getCreditPercent().getText())*0.01));
										addEntry(credit);
									}
								}
							});
						} else {
							addEntry(credit);
						}
					}
				}
			});
		}
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(final String actionType) {
		checkDoctorCode(actionType);
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	private void addEntry(final String credit) {
		AddEntry(memSlipNo, getItemCode().getText(), getItemType().getText(),
				 ConstantsTransaction.SLIPTX_TYPE_CREDIT, "-"+credit, "-"+credit,
				 getDoctorCode().getText(), memItmRlvl, memAcmCode, ZERO_VALUE, EMPTY_VALUE,
				 getMainFrame().getServerDateTime(), memStnTDate,
				 getItemName().getText()+" "+getDesc().getText(),
				 EMPTY_VALUE, EMPTY_VALUE, EMPTY_VALUE, false, memBedCode, EMPTY_VALUE, true, EMPTY_VALUE,
				 EMPTY_VALUE, "1", EMPTY_VALUE, EMPTY_VALUE);
	}

	private void checkDoctorCode(final String actionType) {
		if (ConstantsVariable.EMPTY_VALUE.equals(getDoctorCode().getText().trim())) {
			 Factory.getInstance().addErrorMessage("Doctor code is required.", getDoctorCode());
			 actionValidationReady(actionType, false);
		} else {
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] {"DOCTOR", "DOCSTS", "DOCCODE = '" + getDoctorCode().getText().trim() + "'"},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						if (mQueue.getContentField()[0].equals(ZERO_VALUE)) {
							Factory.getInstance().addErrorMessage("The current doctor is inactive or invalid.", getDoctorCode());
							actionValidationReady(actionType, false);
						} else {
							checkItemType(actionType);
						}
					} else {
						Factory.getInstance().addErrorMessage("The current doctor is inactive or invalid.", getDoctorCode());
						actionValidationReady(actionType, false);
					}
				}
			});
		}
	}

	private void checkItemType(final String actionType) {
		if (memItmType != null && memItmType.length() > 0 && !"D".equals(memItmType) && "D".equals(getItemType().getText())) {
			Factory.getInstance().addErrorMessage("Item Type not match.", getItemType());
			actionValidationReady(actionType, false);
		} else {
			if (!ConstantsVariable.EMPTY_VALUE.equals(getItemCode().getText().trim())) {
				QueryUtil.executeMasterFetch(getUserInfo(), "ITEM_EXIST",
						new String[] { getItemCode().getText().trim(), "C", getUserInfo().getUserID() },
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							getItemName().setText(mQueue.getContentField()[1]);
							checkCreditAmt(actionType);
						} else {
							 Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_ITEM_CODE, getItemCode());
							 getItemCode().resetText();
							 getItemName().resetText();
							 actionValidationReady(actionType, false);
						}
					}
				});
			} else {
				Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_ITEM_CODE, getItemCode());
				getItemCode().resetText();
				getItemName().resetText();
				actionValidationReady(actionType, false);
			}
		}
	}

	private void checkCreditAmt(final String actionType) {
		if (getCreditAmt().getText().trim().length() == 0) {
			if (getCreditPercent().getText().trim().length() == 0 || !TextUtil.isPositiveInteger(getCreditPercent().getText().trim())) {
				Factory.getInstance().addErrorMessage(MSG_CREDIT_PERCENTAGE, getCreditPercent());
				actionValidationReady(actionType, false);
			} else if (getItemType().getText().trim().length() == 0) {
				Factory.getInstance().addErrorMessage("Please select the item type.", getItemType());
				actionValidationReady(actionType, false);
			} else {
				actionValidationReady(actionType, true);
			}
		} else if (!TextUtil.isPositiveInteger(getCreditAmt().getText().trim())) {
			Factory.getInstance().addErrorMessage(MSG_POSITIVE_AMOUNT, getCreditAmt());
			actionValidationReady(actionType, false);
		} else {
			actionValidationReady(actionType, true);
		}
	}

	private void checkItemCode() {
		if (!QueryUtil.ACTION_FETCH.equals(getActionType())) {
			if (!ConstantsVariable.EMPTY_VALUE.equals(ItemCode.getText().trim())) {
				QueryUtil.executeMasterFetch(getUserInfo(), "ITEM_EXIST",
						new String[] { getItemCode().getText().trim(), "C", getUserInfo().getUserID() },
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							getItemName().setText(mQueue.getContentField()[1]);
						} else {
							Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_ITEM_CODE, getItemCode());
							getItemCode().resetText();
							getItemName().resetText();
						}
					}
				});
			} else {
				getItemName().resetText();
			}
		}
	}

	private void getTotalCredit() {
		QueryUtil.executeMasterFetch(getUserInfo(), "TOTALCREDIT",
				new String[] {
					memSlipNo, getDoctorCode().getText(),
					ConstantsTransaction.SLIPTX_STATUS_NORMAL,
					ConstantsTransaction.SLIPTX_STATUS_ADJUST,
					ConstantsTransaction.SLIPTX_TYPE_CREDIT
				},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				getCreditGiven().setText(mQueue.getContentField()[0]);
				getBalance().setText(String.valueOf(Integer.parseInt(getMaxinum().getText())+Integer.parseInt(getCreditGiven().getText())));
			}
		});
	}

	private void getMaxShare() {
		QueryUtil.executeMasterBrowse(getUserInfo(), "DOCITMPCT",
				new String[] {getDoctorCode().getText(), getUserInfo().getSiteCode()},
				new MessageQueueCallBack() {
			public void onPostSuccess(MessageQueue mQueue) {
				String[] docItmPcts = mQueue.getContentField();
				HashMap<String, DocItmPct> itmMap = new HashMap<String, DocItmPct>();

				for (int i = 0; i+3 < docItmPcts.length; i+=3) {
					itmMap.put(docItmPcts[i].replace(TextUtil.LINE_DELIMITER, EMPTY_VALUE),
							new DocItmPct(
									docItmPcts[i].replace(TextUtil.LINE_DELIMITER, EMPTY_VALUE),
									docItmPcts[i+1],
									docItmPcts[i+2]));
				}

				final HashMap<String, DocItmPct> itmMap2 = itmMap;
				QueryUtil.executeMasterBrowse(getUserInfo(), "DOCTRANS",
						new String[] {memSlipNo, getDoctorCode().getText(),
										ConstantsTransaction.SLIPTX_TYPE_DEBIT,
										ConstantsTransaction.SLIPTX_STATUS_NORMAL,
										ConstantsTransaction.SLIPTX_STATUS_ADJUST,
										ConstantsTransaction.TYPE_DOCTOR},
						new MessageQueueCallBack() {
					public void onPostSuccess(MessageQueue mQueue) {
						String[] docTrans = mQueue.getContentField();
						int maxShare = 0;

						for (int i = 0; i+6 < docTrans.length; i+=6) {
							int shareValue = 0;
							String slpType = docTrans[i+1];
							String pcyId = docTrans[i+2];
							String dscCode = docTrans[i+3];
							String itmCode = docTrans[i+4];
							String fixValue, pctValue;

							DocItmPct docItmPct = (DocItmPct) itmMap2.get(slpType+"~"+pcyId+"~"+dscCode+"~"+itmCode);

							if (docItmPct == null) {
								docItmPct = (DocItmPct) itmMap2.get(slpType+"~"+pcyId+"~"+dscCode+"~");
								if (docItmPct == null) {
									docItmPct = (DocItmPct) itmMap2.get(slpType+"~"+pcyId+"~~");
									if (docItmPct == null) {
										docItmPct = (DocItmPct) itmMap2.get(slpType+"~~~");
									}
								}
							}

							if (docItmPct == null) {
								fixValue = null;
								pctValue = ZERO_VALUE;
							} else {
								fixValue = docItmPct.getFix();
								pctValue = docItmPct.getPct();
							}

							if (pctValue == null || pctValue.equals(MINUS_ONE_VALUE)) {
								shareValue = Integer.parseInt(fixValue);
							} else {
								shareValue = (int) Math.round(Double.parseDouble(docTrans[i+5])*Double.parseDouble(pctValue)/100.0);
							}

							maxShare += shareValue;
						}
						getMaxinum().setText(String.valueOf(maxShare));
						getTotalCredit();
					}
				});
			}
		});
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	public void AddEntryReady(String slpNo, String entry) {
		super.AddEntryReady(slpNo, entry);

		if (entry != null && entry.length() > 0) {
			//Factory.getInstance().addInformationMessage("Sliptx update successfully.", "PBA - [Add Credit Item]");
			exitPanel();
		}
	}

	/**
	 * overrider cancel method
	 */
	@Override
	public void cancelYesAction() {
		MessageBoxBase.confirm("PBA - [Add Credit Item]",  MSG_CANCEL_WARNING,new Listener<MessageBoxEvent>() {
			public void handleEvent(MessageBoxEvent be) {
				if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						exitPanel();
				}
			}
		});
	}

	@Override
	public void enableButton(String enable) {
		disableButton();
		getSaveButton().setEnabled(true);
		getCancelButton().setEnabled(true);
		getSearchButton().setEnabled(true);
	}

	/***************************************************************************
	 * Private Class
	 **************************************************************************/

	private class DocItmPct {
		private String code;
		private String pct;
		private String fix;

		public DocItmPct(String code, String d, String e) {
			this.code = code;
			this.pct = d;
			this.fix = e;
		}

		public String getCode() {
			return this.code;
		}

		public String getPct() {
			return this.pct;
		}

		public String getFix() {
			return this.fix;
		}
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/* >>> getter methods for init the Component start from here================================== <<< */
	@Override
	protected BasePanel getActionPanel() {
		if (actionPanel == null) {
			actionPanel = new BasePanel();
			actionPanel.setSize(780, 450);
			actionPanel.add(getCreditItemListPanel(), null);
			actionPanel.add(getCreditItemDetailPanel(), null);
		}
		return actionPanel;
	}

	public FieldSetBase getCreditItemListPanel() {
		if (CreditItemListPanel == null) {
			CreditItemListPanel = new FieldSetBase();
			CreditItemListPanel.setHeading("Credit Item Lists");
			CreditItemListPanel.setBounds(5, 5, 770, 246);
			CreditItemListPanel.add(getCreditItemScrollPane());
		}
		return CreditItemListPanel;
	}

	/**
	 * This method initializes CreditItemScrollPane
	 *
	 * @return JScrollPane
	 */
	protected JScrollPane getCreditItemScrollPane() {
		if (CreditItemScrollPane == null) {
			CreditItemScrollPane = new JScrollPane();
			CreditItemScrollPane.setViewportView(getListTable());
			CreditItemScrollPane.setBounds(5, 5, 758, 210);
		}
		return CreditItemScrollPane;
	}

	public FieldSetBase getCreditItemDetailPanel() {
		if (CreditItemDetailPanel == null) {
			CreditItemDetailPanel = new FieldSetBase();
			CreditItemDetailPanel.setHeading("Credit Item Details");
			CreditItemDetailPanel.setBounds(5, 260, 770, 180);
			CreditItemDetailPanel.add(getItemCodeDesc(), null);
			CreditItemDetailPanel.add(getItemCode(), null);
			CreditItemDetailPanel.add(getItemName(), null);
			CreditItemDetailPanel.add(getDoctorCodeDesc(), null);
			CreditItemDetailPanel.add(getDoctorCode(), null);
			CreditItemDetailPanel.add(getDoctorName(), null);
			CreditItemDetailPanel.add(getCreditAmtDesc(), null);
			CreditItemDetailPanel.add(getCreditAmt(), null);
			CreditItemDetailPanel.add(getItemTypeDesc(), null);
			CreditItemDetailPanel.add(getItemType(), null);
			CreditItemDetailPanel.add(getCreditPercentDesc(), null);
			CreditItemDetailPanel.add(getCreditPercent(), null);
			CreditItemDetailPanel.add(getDescDesc(), null);
			CreditItemDetailPanel.add(getDesc(), null);
			CreditItemDetailPanel.add(getMaxinumDesc(), null);
			CreditItemDetailPanel.add(getMaxinum(), null);
			CreditItemDetailPanel.add(getCreditGivenDesc(), null);
			CreditItemDetailPanel.add(getCreditGiven(), null);
			CreditItemDetailPanel.add(getOperAddDesc(), null);
			CreditItemDetailPanel.add(getOperEqualDesc(), null);
			CreditItemDetailPanel.add(getBalanceDesc(), null);
			CreditItemDetailPanel.add(getBalance(), null);
			CreditItemDetailPanel.add(getCalculate(), null);
		}
		return CreditItemDetailPanel;
	}

	public LabelBase getItemCodeDesc() {
		if (ItemCodeDesc == null) {
			ItemCodeDesc = new LabelBase();
			ItemCodeDesc.setText("Item Code");
			ItemCodeDesc.setBounds(15, 0, 77, 20);
		}
		return ItemCodeDesc;
	}

	public TextItemCodeSearch getItemCode() {
		if (ItemCode == null) {
			setParameter("itemCategoryExcl", ConstantsTransaction.ITEM_CATEGORY_DEBIT);
			ItemCode = new TextItemCodeSearch(ConstantsTransaction.ITEM_CATEGORY_DEBIT) {
				public void onBlur() {
					// call database to retrieve district
					checkItemCode();
				};

				@Override
				public void showSearchPanel() {
					DlgItemSearch dlgItemSearch =
							new DlgItemSearch(this,ConstantsTransaction.ITEM_CATEGORY_DEBIT) {
						@Override
						protected void acceptPostAction() {
							if (!ItemCode.isEmpty()) {
								checkItemCode();
							}
						}
					};
					dlgItemSearch.showPanel();
				}
			};
			ItemCode.setBounds(99, 0, 108, 20);
		}
		return ItemCode;
	}

	public TextReadOnly getItemName() {
		if (ItemName == null) {
			ItemName = new TextReadOnly();
			ItemName.setBounds(215, 0, 161, 20);
		}
		return ItemName;
	}

	public LabelBase getDoctorCodeDesc() {
		if (DoctorCodeDesc == null) {
			DoctorCodeDesc = new LabelBase();
			DoctorCodeDesc.setText("Doctor Code");
			DoctorCodeDesc.setBounds(399, 0, 74, 20);
		}
		return DoctorCodeDesc;
	}

	public ComboDoctor getDoctorCode() {
		if (DoctorCode == null) {
			DoctorCode = new ComboDoctor() {
				@Override
				protected void setTextPanel(ModelData modelData) {
					if (getDoctorCode().getText() == null || getDoctorCode().getText().trim().length() == 0) {
						getDoctorName().resetText();
						return;
					}
					QueryUtil.executeMasterFetch(getUserInfo(), "DOCTOR_ACTIVE", new String[] {getDoctorCode().getText()},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							getDoctorName().setText(mQueue.getContentField()[0]);
						}
					});
				}

				@Override
				protected void onKeyUp(FieldEvent fe) {
					// TODO Auto-generated method stub
					super.onKeyUp(fe);
					if (KeyCodes.KEY_BACKSPACE == fe.getKeyCode()) {
						if (DoctorCode.getText() == null || DoctorCode.getText().trim().length() == 0) {
							getDoctorName().resetText();
							getDoctorName().setText(EMPTY_VALUE);
						}
					}
				}
			};
			DoctorCode.setBounds(480, 0, 91, 20);
		}
		return DoctorCode;
	}

	public TextReadOnly getDoctorName() {
		if (DoctorName == null) {
			DoctorName = new TextReadOnly();
			DoctorName.setBounds(580, 0, 166, 20);
		}
		return DoctorName;
	}

	public LabelBase getCreditAmtDesc() {
		if (CreditAmtDesc == null) {
			CreditAmtDesc = new LabelBase();
			CreditAmtDesc.setText("Credit Amount");
			CreditAmtDesc.setBounds(15, 30, 100, 20);
		}
		return CreditAmtDesc;
	}

	public TextNum getCreditAmt() {
		if (CreditAmt == null) {
			CreditAmt = new TextNum(ConstantsTransaction.MAX_AMOUNT_LIMIT);
			CreditAmt.setBounds(99, 30, 108, 20);
		}
		return CreditAmt;
	}

	public LabelBase getItemTypeDesc() {
		if (ItemTypeDesc == null) {
			ItemTypeDesc = new LabelBase();
			ItemTypeDesc.setText("Item Type");
			ItemTypeDesc.setBounds(215, 30, 63, 20);
		}
		return ItemTypeDesc;
	}

	public ComboCreditItemType getItemType() {
		if (ItemType == null) {
			ItemType = new ComboCreditItemType();
			ItemType.setBounds(284, 30, 91, 20);
		}
		return ItemType;
	}

	public LabelBase getCreditPercentDesc() {
		if (CreditPercentDesc == null) {
			CreditPercentDesc = new LabelBase();
			CreditPercentDesc.setText("Credit Percentage(%)");
			CreditPercentDesc.setBounds(399, 30, 130, 20);
		}
		return CreditPercentDesc;
	}

	public TextNum getCreditPercent() {
		if (CreditPercent == null) {
			CreditPercent = new TextNum(3, 0);
			CreditPercent.setBounds(519, 30, 166, 20);
		}
		return CreditPercent;
	}

	public LabelBase getDescDesc() {
		if (DescDesc == null) {
			DescDesc = new LabelBase();
			DescDesc.setText("Description");
			DescDesc.setBounds(15, 60, 77, 20);
		}
		return DescDesc;
	}

	public TextString getDesc() {
		if (Desc == null) {
			Desc = new TextString();
			Desc.setBounds(99, 60, 174, 20);
		}
		return Desc;
	}

	public LabelBase getMaxinumDesc() {
		if (MaxinumDesc == null) {
			MaxinumDesc = new LabelBase();
			MaxinumDesc.setText("Maximum Share");
			MaxinumDesc.setBounds(15, 100, 104, 20);
		}
		return MaxinumDesc;
	}

	public TextReadOnly getMaxinum() {
		if (Maxinum == null) {
			Maxinum = new TextReadOnly();
			Maxinum.setBounds(15, 120, 104, 20);
		}
		return Maxinum;
	}

	public LabelBase getCreditGivenDesc() {
		if (CreditGivenDesc == null) {
			CreditGivenDesc = new LabelBase();
			CreditGivenDesc.setText("Credit Given By Dr");
			CreditGivenDesc.setBounds(138, 100, 104, 20);
		}
		return CreditGivenDesc;
	}

	public TextReadOnly getCreditGiven() {
		if (CreditGiven == null) {
			CreditGiven = new TextReadOnly();
			CreditGiven.setBounds(138, 120, 104, 20);
		}
		return CreditGiven;
	}

	public LabelBase getOperAddDesc() {
		if (OperAddDesc == null) {
			OperAddDesc = new LabelBase();
			OperAddDesc.setText("+");
			OperAddDesc.setBounds(125, 120, 11, 20);
		}
		return OperAddDesc;
	}

	public LabelBase getOperEqualDesc() {
		if (OperEqualDesc == null) {
			OperEqualDesc = new LabelBase();
			OperEqualDesc.setText("=");
			OperEqualDesc.setBounds(245, 120, 14, 20);
		}
		return OperEqualDesc;
	}

	public LabelBase getBalanceDesc() {
		if (BalanceDesc == null) {
			BalanceDesc = new LabelBase();
			BalanceDesc.setText("Balance");
			BalanceDesc.setBounds(258, 100, 104, 20);
		}
		return BalanceDesc;
	}

	public TextReadOnly getBalance() {
		if (Balance == null) {
			Balance = new TextReadOnly();
			Balance.setBounds(258, 120, 104, 20);
		}
		return Balance;
	}

	public ButtonBase getCalculate() {
		if (Calculate == null) {
			Calculate = new ButtonBase() {
				@Override
				public void onClick() {
					getMaxShare();
/*
					getMaxinum().setText(totalCharge);
					if (getListTable().getRowCount()>0) {
						int given=0;
						for (int i=0; i<getListTable().getRowCount(); i++) {
							String[] para=getListTable().getRowContent(i);
							given=given+Integer.valueOf(para[9]);
						}
						getCreditGiven().setText(String.valueOf(given));
						bl=Integer.valueOf(totalCharge)+given;
					} else {
						getCreditGiven().setText(ZERO_VALUE);
						bl=Integer.valueOf(totalCharge);
					}

					getBalance().setText(String.valueOf(bl));
*/
				}
			};
			Calculate.setText("Calculate");
			Calculate.setBounds(376, 120, 93, 25);
		}
		return Calculate;
	}
}