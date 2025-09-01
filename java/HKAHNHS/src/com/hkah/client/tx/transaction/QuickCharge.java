package com.hkah.client.tx.transaction;

import java.util.Vector;

import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.util.Rectangle;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.form.RadioGroup;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.combobox.ComboVisitPkgCode;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.radiobutton.RadioButtonBase;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.SearchTriggerField;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextItemCodeSearch;
import com.hkah.client.layout.textfield.TextNum;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextSlipSearch;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.ActionPanel;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.PanelUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTransaction;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class QuickCharge extends ActionPanel {

	// property declare start
	private BasePanel actionPanel = null;
	private BasePanel listPanel = null;
	private LabelBase transactionDesc = null;
	private TextDate transaction = null;
	private BasePanel itmPanel = null;
	private LabelBase itmCodeDesc = null;
	private TextItemCodeSearch itmCode = null;
	private TextReadOnly itmName = null;
	private BasePanel patSlpPanel = null;
	private LabelBase patNoDesc = null;
	private TextPatientNoSearch patNo = null;
	private LabelBase slpNoDesc = null;
	private TextSlipSearch slpNo = null;
	private LabelBase CPSFixAmtDesc = null;
	private TextReadOnly CPSFixAmt = null;
	private LabelBase CPSDesc = null;
	private TextReadOnly CPS = null;
	private LabelBase amtDesc = null;
	private TextNum amt = null;
	private LabelBase visitDesc = null;
	private ComboVisitPkgCode visit = null;
	private LabelBase pkgCodeDesc = null;
	private TextString pkgCode = null;
	private BasePanel entBatPanel = null;
	private LabelBase numberOfEntryDesc = null;
	private TextReadOnly numberOfEntry = null;
	private LabelBase batchAmountDesc = null;
	private TextReadOnly batchAmount = null;
	private BasePanel postPanel = null;
	private RadioButtonBase post2Charge = null;
	private RadioButtonBase post2RefFile = null;
	private String mode=QueryUtil.ACTION_BROWSE;

	private JScrollPane slipScrollPane = null;
	private TableList chargeListTable = null;

	private String memItmCode = "";
	private String memPkgCode = "";
	private String memItmCName = "";
	private String memItmType = "";
	private String memItmRLvl = "";
	private Vector<String []> tmpVetor = new Vector<String []>();
	private boolean memCredit = false;
	private String memItmName = "";
	private String memLockSlipno = null;
	private String PatNo = "";
	private String PatFName = "";
	private String PatGName = "";
	private int row = -1;
//	private String PkgName = null;
//	private String cr = null;
	private boolean isSlpNoFocus = false;
	private String capturedate = "";
	private String TransactionDate = "";

	// property declare end

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return null;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return "Quick Charge Entry";
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Slip No.",      //SlpNo
				"Patient No.",  //PatNo
				"Amount",       //StnNAmt
				"Patient Name", //PatName=PatFName+PatGName
				"Visit",        //PkgCode
				"PatFName",
				"PatGName",
				"StnOAmt",
				"DocCode",
				"DptCode",
				"AcmCode",
				"cpsPct",
				"SlpDisc",
				"stnCpsFlag",
				"cpsid",
				"SlpType",
				"cpsFix",
				"PATNO2",        //PatNo2
				"PkgCode",       //PkgCode
				"SlpNo2"         //SlpNo2
			};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				80,
				100,
				80,
				100,
				80,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0
		};
	}

	/**
	 * This method initializes
	 *
	 */
	public QuickCharge() {
		super();
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		memItmCode = "";
		memPkgCode = "";
		memItmCName = "";
		memItmType = "";
		memItmRLvl ="-1";
		memCredit = false;

		if (getParameter("itmCode1") != null) {
			getItmCode().setText(getParameter("itmCode1"));
			getItmName().setText(getParameter("itmName"));
			getLookUpItmCode();
		}
		if (getParameter("PS_PatNo") != null) {
			getPatNo().setText(getParameter("PS_PatNo"));
		}
		if (getParameter("MODE") != null) {
			mode = getParameter("MODE");
		}

		PanelUtil.setAllFieldsEditable(getActionPanel(), true);
		if (QueryUtil.ACTION_APPEND.equals(mode)) {
			PanelUtil.setAllFieldsEditable(getPatSlpPanel(), true);
			PanelUtil.setAllFieldsEditable(getItmPanel(), false);
		} else {
			PanelUtil.setAllFieldsEditable(getPatSlpPanel(), false);
			PanelUtil.setAllFieldsEditable(getItmPanel(), true);
		}

//		if (!getItmName().isEmpty()) {
//			getAppendButton().setEnabled(true);
//		}

		disableButton();
		getSearchButton().setEnabled(true);

		// set default values
		getTransaction().setText(getMainFrame().getServerDate());
		getNumberOfEntry().setText(ZERO_VALUE);
		getBatchAmount().setText(ZERO_VALUE);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public SearchTriggerField getDefaultFocusComponent() {
		if (getPatNo().isEditable()) {
			return getPatNo();
		} else {
			return getItmCode();
		}
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
	protected void deleteDisabledFields() {}

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
		String[] selectedContent = getChargeListTable().getSelectedRowContent();
		return new String[] {
				selectedContent[0]
		};
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {
		String[] rs=getChargeListTable().getSelectedRowContent();
		if (rs != null && rs.length > 0) {
			getSlpNo().setText(rs[0]);
			getPatNo().setText(rs[1]);
			getAmt().setText(rs[2]);
			getVisit().setText(rs[4]);
			getVisit().resetList(getPatNo().getText());
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

	/***************************************************************************
	 * Overload Method
	 **************************************************************************/

	// action method override start
	@Override
	public void searchAction() {
		// check focus not working, use trigger button to show search panel in the fields
/*
		if (getItmCode().isFocusOwner()) {
			  System.out.println("DEBUG getItmCode focus");
			  setParameter("ITMCAT", "D");
			  setParameter("itmCode", getItmCode().getText().trim());
			  getItmCode().showSearchPanel();
		} else if (getPatNo().isFocusOwner()) {
			 System.out.println("DEBUG getPatNo focus");
			 setParameter("qPATNO", getPatNo().getText().trim());
			 getPatNo().showSearchPanel();
		} else {
		}
*/
		if (!validateTransaction()) {
			return;
		}
	}

	/**
	 * action when click append button
	 */
	@Override
	public void appendAction() {
		if (getItmName().getText().trim().length() == 0 || !validateTransaction()) {
			return ;
		}
		checkNew();	// append in postCheckNew if validated
	}

	@Override
	public void deleteAction() {
		if (getDeleteButton().isEnabled()) {
			int removeRow = getChargeListTable().getSelectedRow();
			if (getChargeListTable().getSelectedRow()>=0) {
				getChargeListTable().removeRow(getChargeListTable().getSelectedRow());
			}
			if (getChargeListTable().getRowCount() == 0) {
				disableButton();
				getSearchButton().setEnabled(true);
				getAppendButton().setEnabled(true);
				getNumberOfEntry().setText(ZERO_VALUE);
				getBatchAmount().setText(ZERO_VALUE);

				getSlpNo().resetText();
				getSlpNo().setShowSlpDlg(true);
				getPatNo().resetText();
				getAmt().resetText();
				getVisit().removeAllItems();
				getVisit().resetText();
				getCPSFixAmt().resetText();
				getCPS().resetText();

				// back to itmcode input stage
				disableButton();
			    getSearchButton().setEnabled(true);
			    getAppendButton().setEnabled(true);
			    PanelUtil.setAllFieldsEditable(getItmPanel(), true);
			    PanelUtil.setAllFieldsEditable(getPatSlpPanel(), false);
			}
			getNumberOfEntry().setText(String.valueOf(getChargeListTable().getRowCount()));
			if (getChargeListTable().getRowCount() > 0) {
				if (getChargeListTable().getRowCount() <= removeRow) {
					removeRow -= 1;
				}
				getChargeListTable().setSelectRow(removeRow);
				calcBatchAmount();
				setActionType(null);
			}
		}
	}

	private boolean validateTransaction() {
//		String txDate = getTransaction().getRawValue().trim();
		if (!getTransaction().isValid()) {
			Listener<MessageBoxEvent> callback = null;
			if (getTransaction().isEmpty()) {
				callback = new Listener<MessageBoxEvent>() {
					@Override
					public void handleEvent(MessageBoxEvent be) {
						getTransaction().setText(DateTimeUtil.getCurrentDate(0));
					}
				};
			}
			Factory.getInstance().addErrorMessage(
					ConstantsMessage.MSG_TRANSACTION_DATE_FORMAT,
					"PBA-["+getTitle()+"]", getTransaction(), callback);
			return false;
		}
		return true;
	}

	@Override
	public void saveAction() {
		if (getSaveButton().isEnabled()) {
			if (!validateTransaction()) {
				return ;
			}
			checkTranDate();
		}
	}

	private void saveAction2() {
		//LookupPatNo();
		if (memCredit && getPost2RefFile().isSelected()) {
			Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_CREDIT_CHARGES,
					"PBA-[" + getTitle() + "]");
			return;
		}
		PrePostTransactions();
	}

	private void checkTranDate() {
		String txDate = getTransaction().getRawValue().trim();
		if (DateTimeUtil.compareTo(txDate, getMainFrame().getServerDate()) > 0) {
			Factory.getInstance().isConfirmYesNoDialog("PBA-["+getTitle()+"]",ConstantsMessage.MSG_FUTURE_TRANSACTION_DATE,
					new Listener<MessageBoxEvent>() {
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						saveAction2();
					}
				}
			});
		} else {
			saveAction2();
		}
	}

	@Override
	protected void cancelYesAction() {
		   PanelUtil.resetAllFields(getPatSlpPanel());
		   getChargeListTable().removeAllRow();
		   getNumberOfEntry().setText(ZERO_VALUE);
		   getBatchAmount().setText(ZERO_VALUE);

//		   getItmCodeDesc().resetText();
		   getItmCode().resetText();
		   getItmCode().requestFocus();
		   getItmName().resetText();

		   disableButton();
		   getSearchButton().setEnabled(true);
		   getAppendButton().setEnabled(true);
		   PanelUtil.setAllFieldsEditable(getItmPanel(), true);
		   PanelUtil.setAllFieldsEditable(getPatSlpPanel(), false);
		   setActionType(null);
	}

	@Override
	public void clearAction() {
		if (getClearButton().isEnabled()) {
//			PanelUtil.resetAllFields(getItmPanel());
			PanelUtil.resetAllFields(getPatSlpPanel());
			if (getChargeListTable().getRowCount() > 0) {
				int row=getSelectedOrLastRow();
				for (int i=0;i<getChargeListTable().getColumnCount();i++) {
					getChargeListTable().resetValueAt(row, i);
				}
			}
			getAmt().setText("");
			calcBatchAmount();
		}
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	private void checkNew() {
		//System.out.println("DEBUG: checkNew ");
		if (getChargeListTable().getRowCount() == 0) {
			postCheckNew(true);
		} else {
			getLookupPatNo(true);
		}
	}

	private void checkNew2(boolean success) {
		//System.out.println("DEBUG: checkNew2 success="+success);
		if (success) {
			getLookupSlpNo(true);
			// goto checkNew3
		} else {
			postCheckNew(false);
		}
	}

	private void checkNew3(boolean success) {
		//System.out.println("DEBUG: checkNew3 success="+success);
		if (success) {
			ValidateVisitPkgCode(true);
			// goto checkNew4
		} else {
			postCheckNew(false);
		}
	}

	private void checkNew4(boolean success) {
		//System.out.println("DEBUG: checkNew4 success="+success);
		postCheckNew(success);
	}

	private void postCheckNew(boolean success) {
		//System.out.println("DEBUG: postCheckNew success="+success);
		if (success) {
			String[]row = new String[] {"","","","","","","","","","","","","","","","","","","",""};
			getChargeListTable().addRow(row);

			getSlpNo().resetText();
			getSlpNo().setShowSlpDlg(true);
			getPatNo().resetText();
			getAmt().resetText();
			getVisit().removeAllItems();
			getVisit().resetText();
			getCPSFixAmt().resetText();
			getCPS().resetText();

			getNumberOfEntry().setText(String.valueOf(getChargeListTable().getRowCount()));
			PanelUtil.setAllFieldsEditable(getPatSlpPanel(), true);
			PanelUtil.setAllFieldsEditable(getItmPanel(), false);
			getSearchButton().setEnabled(true);
			if (getChargeListTable().getRowCount() > 0) {
				getDeleteButton().setEnabled(true);
				getSaveButton().setEnabled(true);
				getCancelButton().setEnabled(true);
				getClearButton().setEnabled(true);
				getChargeListTable().setSelectRow(getChargeListTable().getRowCount() - 1);
			}
			getChargeListTable().resetValueAt(getSelectedOrLastRow(), 4);	// Visit
			getPatNo().requestFocus();
			setActionType("ADD");
		}
	}

	private void getLookUpItmCode() {
		String itemCodeValue = getItmCode().getText();

		if (itemCodeValue.equals(ConstantsTransaction.TXN_REFUND_ITMCODE)) {
			Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_TXN_NOREFUNDITM, "PBA-[" + getTitle() + "]", getItmCode());
			getItmCode().resetText();
			getItmName().resetText();
		} else if (itemCodeValue.length() > 0) {
			String cr = "itmcat<> '" + ConstantsTransaction.ITEM_CATEGORY_CREDIT + "' and ItmCode='" + itemCodeValue + "'";
			if (!getUserInfo().isPBO()) {
				cr += " and DptCode='" + getUserInfo().getDeptCode() + "'";
			}

			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] {"Item","ItmCode, ItmName,ItmCName, ItmType, ItmCat, ItmRLvl", cr},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					getAppendButton().setEnabled(false);
					if (mQueue.success()) {
						String[]rs=mQueue.getContentField();
						memItmCode = rs[0];
						if (memItmCode != null && memItmCode.trim().length() > 0) {
							memItmType = rs[3];
							memItmRLvl = rs[5];
							if (ConstantsTransaction.ITEM_CATEGORY_CREDIT.equals("")) {
								memCredit = true;
							} else {
								memCredit = false;
							}
							getItmName().setText(rs[1]);
							getAppendButton().setEnabled(true);
							getNumberOfEntry().setText(ZERO_VALUE);
							getBatchAmount().setText(ZERO_VALUE);
						} else {
							memItmType = "";
							memItmRLvl ="-1";
							if (memPkgCode == null || memPkgCode.trim().length() == 0) {
								getItmCode().resetText();
							}
						}
					} else {
						getItmName().resetText();
						Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_ITEM_CODE, "PBA-[" + getTitle() + "]", getItmCode());
					}
				}
			});
		}
	}

	private void getLookupPatNo() {
		getLookupPatNo(false);
	}

	private void getLookupPatNo(final boolean isBe4CheckNew) {
		getVisit().removeAllItems();

		row = getSelectedOrLastRow();

		if (getPatNo().getText().trim().length() == 0) {
			//getLookupPatNoReady(false);
			getChargeListTable().resetValueAt(row, 4);	// Visit
			getVisit().reset();

			if (isBe4CheckNew) {
				checkNew2(false);
			}
			return;
		}

		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] { "Patient", "PatNo, PatFName, PatGName", "PatNo='" + getPatNo().getText().trim() + "'" },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					String[]rs=mQueue.getContentField();
					PatNo = rs[0];
					PatFName = rs[1];
					PatGName = rs[2];
				} else {
					PatNo = "";
					PatFName = "";
					PatGName = "";
				}
				if (PatNo != null && PatNo.trim().length() > 0) {
					getChargeListTable().setValueAt(PatNo, row, 1);
					getChargeListTable().setValueAt(PatNo, row, 17);
					getChargeListTable().setValueAt(PatFName, row, 5);
					getChargeListTable().setValueAt(PatGName, row, 6);
					getChargeListTable().setValueAt(PatFName+" "+PatGName, row, 3);

					QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] { "Patient a, package p, REGPKGLINK r", "p.Pkgname,r.PkgCode",
								"a.patno ='" + getPatNo().getText().trim() + "' and p.pkgtype <> 'P' and a.REGID_C = r.RegID and r.pkgcode = p.pkgcode order by r.pkgcode "},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								TableList list = CommonUtil.getRs2col(2);
								list.setListTableContent(mQueue);
								if (list.getRowCount() > 0) {
									String[] rs = null;
									for (int i = 0; i < list.getRowCount(); i++) {
										rs = list.getRowContent(i);
										getVisit().addItem(rs[1]);
									}
									getVisit().setSelectedIndex(0);
									getChargeListTable().setValueAt(visit.getDisplayText(), getSelectedOrLastRow(), 4);
									getSlpNo().requestFocus();
								}
							}
						}
					});

					if (isBe4CheckNew) {
						checkNew2(true);
					}
				} else {
					getChargeListTable().resetValueAt(row, 1);	// PatNo
					getChargeListTable().resetValueAt(row, 5);	// PatFName
					getChargeListTable().resetValueAt(row, 6);	// PatGName
					getChargeListTable().resetValueAt(row, 17);	// PATNO2
					getChargeListTable().resetValueAt(row, 3);	// Patient Name
					getChargeListTable().resetValueAt(row, 18);	// PkgCode
					getChargeListTable().resetValueAt(row, 4);	// Visit
					getVisit().reset();
					getPatNo().clear();
					Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_PATIENT_NO, "PBA-["+getTitle()+"]", getPatNo());
					if (isBe4CheckNew) {
						checkNew2(false);
					}
				}

				if (isSlpNoFocus) {
					lookupSlpno();
				}
			}
		});
	}

	private void slpNoChanged() {
		if ("ADD".equals(getActionType())) {
			final int rowNum = getSelectedOrLastRow();
			if (!getSlpNo().isEmpty() && !getItmCode().isEmpty()) {
				QueryUtil.executeMasterFetch(
						getUserInfo(),
						"LOOKUPITEMCHARGE",
						new String[] {
							getSlpNo().getText().trim(),
							getItmCode().getText()
						},
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							getChargeListTable().setValueAt(mQueue.getContentField()[2], rowNum, 7); // StnOAmt<<DefaultRate

						    if (mQueue.getContentField()[6] != null && mQueue.getContentField()[6].length() > 0) { // memCPSID
							getChargeListTable().setValueAt(mQueue.getContentField()[6], rowNum, 14); // cpsid<<memCPSID
							if (mQueue.getContentField()[1] != null && mQueue.getContentField()[1].length() > 0) { // memCPSPct
								getChargeListTable().setValueAt(ConstantsTransaction.SLIPTX_CPS_STD_PCT, rowNum, 13); // stnCpsFlag
								getChargeListTable().setValueAt(mQueue.getContentField()[1], rowNum, 11); // cpsPct<<memCPSPct
								getCPS().setText(mQueue.getContentField()[1]);
							} else {
								getChargeListTable().setValueAt(ConstantsTransaction.SLIPTX_CPS_STD_FIX, rowNum, 13); // stnCpsFlag
								getChargeListTable().setValueAt(mQueue.getContentField()[4], rowNum, 16); // cpsFix<<CPS_DefaultRate
								getCPSFixAmt().setText(mQueue.getContentField()[4]);
							}
						   } else {
								getChargeListTable().setValueAt(null, rowNum, 14); // cpsid
						    getChargeListTable().setValueAt(null, rowNum, 13); // stnCpsFlag
						    getChargeListTable().setValueAt(null, rowNum, 16); // cpsFix
						    getChargeListTable().setValueAt(null, rowNum, 11); // cpsPct
						   }
						}
					}
				});
			} else {
				getChargeListTable().setValueAt(null, rowNum, 14); // cpsid
		    getChargeListTable().setValueAt(null, rowNum, 13); // stnCpsFlag
		    getChargeListTable().setValueAt(null, rowNum, 16); // cpsFix
		    getChargeListTable().setValueAt(null, rowNum, 11); // cpsPct
			}
			//txtSlpNo_Change()
			getChargeListTable().setValueAt(null, rowNum, 19); // SlpNo2
		}
	}

	private void getLookupSlpNoReady(boolean ready, boolean isBe4CheckNew) {
		if (true) {
			getSlpNo().setErrorField(false);
		}
		if (isBe4CheckNew) {
			checkNew3(ready);
		}
	}

	private void getLookupSlpNo() {
		getLookupSlpNo(false);
	}

	private void getLookupSlpNo(final boolean isBe4CheckNew) {
		if (getSlpNo().isEmpty()) {
			getLookupSlpNoReady(false, isBe4CheckNew);
		} else {
			row=getSelectedOrLastRow();

			String[] rs=getChargeListTable().getRowContent(row);

			if (rs[19].trim().length() == 0) {
				String back = "s.SlpNo, s." + ConstantsTransaction.GetDiscName(memItmType) +
								",s.SlpType, s.DptCode, s.DocCode, i.AcmCode ";
				String cr = " s.RegID=r.RegID(+) and r.InpID=i.InpID(+) and s.SlpNo='" +
								getSlpNo().getText().trim() + "'" +
								" and SlpSts='" + ConstantsTransaction.SLIP_STATUS_OPEN + "'";

				if (!getUserInfo().isAdmin() && !getUserInfo().isPBO()) {
					cr += " and DptCode='"+getUserInfo().getDeptCode() + "'";
				}

				QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
						new String[] {"Slip s, Reg r, Inpat i", back, cr},
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						String SlpNo = "";
						String SlpType = "";
						String DptCode = "";
						String DocCode = "";
						String AcmCode = "";
						String Disc = "";
						if (mQueue.success()) {
							String[] rs1 = mQueue.getContentField();
							SlpNo = rs1[0];
							Disc = rs1[1];
							SlpType = rs1[2];
							DptCode = rs1[3];
							DocCode = rs1[4];
							AcmCode = rs1[5];
						}

						if (SlpNo != null && SlpNo.trim().length() > 0) {
							getChargeListTable().setValueAt(SlpNo, row, 0);
							getChargeListTable().setValueAt(SlpNo, row, 19);
							getChargeListTable().setValueAt(SlpType, row, 15);
							getChargeListTable().setValueAt(DptCode, row, 9);
							getChargeListTable().setValueAt(DocCode, row, 8);
							getChargeListTable().setValueAt(AcmCode, row, 10);
							getChargeListTable().setValueAt(Disc, row, 12);

							getLookupSlpNoReady(true, isBe4CheckNew);
						} else {
							getChargeListTable().resetValueAt(row, 0);
							getChargeListTable().resetValueAt(row, 15);
							getChargeListTable().resetValueAt(row, 9);
							getChargeListTable().resetValueAt(row, 8);
							getChargeListTable().resetValueAt(row, 10);
							getChargeListTable().resetValueAt(row, 12);
							getChargeListTable().resetValueAt(row, 19);

							getSlpNo().resetText();
							getLookupSlpNoReady(false, isBe4CheckNew);
							Factory.getInstance().addErrorMessage(
									ConstantsMessage.MSG_SLIP_NO, "PBA-["+getTitle()+"]", getSlpNo());
						}
					}
				});
			} else {
				getLookupSlpNoReady(true, isBe4CheckNew);
			}
		}
	}

	private void lookupSlpno() {
		row = getSelectedOrLastRow();
//		String patNo2 = getChargeListTable().getValueAt(row, 17); //PatNo2
		if (patNo != null && !patNo.isEmpty()) {
			QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.SLIPSEARCH_TXCODE,
					new String[] { getPatNo().getText(), null,
						ConstantsTransaction.SLIP_TYPE_INPATIENT,
						ConstantsTransaction.SLIP_STATUS_OPEN,
						null,null, null,
						(!getUserInfo().isPBO() ? getUserInfo().getDeptCode() : null)},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue m) {
					int row = getSelectedOrLastRow();
					String[] rs = getChargeListTable().getSelectedRowContent();

					if (m.success()) {
						if (m.getContentLineCount() > 1) {
							if (rs != null && rs.length > 0) {
						    setParameter("PatNo", getPatNo().getText());
						    setParameter("PatFName", rs[5]);
						    setParameter("PatGName", rs[6]);
						    setParameter("SlpType", ConstantsTransaction.SLIP_TYPE_INPATIENT);
						    setParameter("SlipSts", ConstantsTransaction.SLIP_STATUS_OPEN);
							}
							getSlpNo().showSearchPanel();
						} else {
							getChargeListTable().setValueAt(m.getContentField()[0], row, 0);		// Slip No.
							getChargeListTable().setValueAt(m.getContentField()[0], row, 19);		// SlpNo2
							getChargeListTable().setValueAt(m.getContentField()[1], row, 15);		// SlpType
							getChargeListTable().setValueAt(m.getContentField()[6], row, 8);		// DocCode
							getChargeListTable().setValueAt(m.getContentField()[15], row, 9);		// DptCode
							getChargeListTable().setValueAt(m.getContentField()[13], row, 10);		// AcmCode
							getDiscVal(m.getContentField()[0], row);
							getSlpNo().setText(m.getContentField()[0]);
						}
					} else {
						getChargeListTable().resetValueAt(row, 0);		// Slip No.
						getChargeListTable().resetValueAt(row, 19);		// SlpNo2
						getChargeListTable().resetValueAt(row, 15);		// SlpType
						getChargeListTable().resetValueAt(row, 8);		// DocCode
						getChargeListTable().resetValueAt(row, 9);		// DptCode
						getChargeListTable().resetValueAt(row, 10);		// AcmCode
						getChargeListTable().resetValueAt(row, 12);		// SlpDisc
					}
				}
			});
		}
	}

	private void getDiscVal(final String slpno, final int row) {
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] {"Slip s", ConstantsTransaction.GetDiscName(memItmType),
					"SlpNo='" + slpno + "'"},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					String[] rs1 = mQueue.getContentField();
					getChargeListTable().setValueAt(rs1[0], row, 12);
				} else {
					getChargeListTable().resetValueAt(row, 12);
				}
			}
		});
	}

	private void ValidateVisitPkgCodeReady(boolean ready, boolean isBe4CheckNew) {
		if (isBe4CheckNew) {
			checkNew4(ready);
		}
	}

	private void ValidateVisitPkgCode() {
		ValidateVisitPkgCode(false);
	}

	private void ValidateVisitPkgCode(final boolean isBe4CheckNew) {
		if (getPost2Charge().isSelected()) {
			ValidateVisitPkgCodeReady(true, isBe4CheckNew);
			return;
		}
		String cr = null;
		if (getPkgCode().getText().trim().length() == 0) {
			cr = "PkgCode='"+getVisit().getText()+"'"+" and pkgtype <>'"+ConstantsTransaction.PKGTX_TYPE_NORMAL+"'";
		} else {
			cr = "PkgCode='"+getPkgCode().getText().trim()+"'"+" and pkgtype <>'"+ConstantsTransaction.PKGTX_TYPE_NATUREOFVISIT+"'";
		}

		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] {"Package", "PkgCode", cr},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
//					String[] rs = mQueue.getContentField();

					ValidateVisitPkgCodeReady(true, isBe4CheckNew);
					int row=getSelectedOrLastRow();
					//System.out.println("DEBUG: ValidateVisitPkgCode success row="+row+", getPkgCode().getText()="+getPkgCode().getText());
					String pkgCode = !getPkgCode().isEmpty() ? getPkgCode().getText().trim() : getVisit().getText();
					getChargeListTable().setValueAt(pkgCode, row,18);
					getVisit().setText(pkgCode);
					getChargeListTable().setValueAt(pkgCode, row, 4);	// visit
//					System.out.println("DEBUG: pkgcode value in row="+getChargeListTable().getValueAt(row, 18));
				} else {
					Factory.getInstance().addErrorMessage(
							ConstantsMessage.MSG_VISIT_PKGCODE, "PBA-["+getTitle()+"]", null,
							new Listener<MessageBoxEvent>() {
						@Override
						public void handleEvent(MessageBoxEvent be) {
							if (!getPkgCode().isEmpty()) {
								getPkgCode().resetText();
								getPkgCode().requestFocus();
							} else {
								getVisit().requestFocus();
							}
							ValidateVisitPkgCodeReady(false, isBe4CheckNew);
						}
					});
				}
			}
		});
	}

	private void IsSlipActive(final String[] record) {
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] {"slip","slpsts, slpno", "slpNo='" + record[19] + "'"},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					String[] rs = mQueue.getContentField();
					if ("A".equals(rs[0])) {
						IsSlipActiveReady(true, record);
					} else {
						IsSlipActiveReady(false, record);
					}
				} else {
					IsSlipActiveReady(false, record);
				}
			}
		});
	}

	private void IsSlipActiveReady(boolean ready, String[] record) {
		if (ready) {
			//lockRecord("Slip",rs[19],"OK");
			System.out.print("DEBUG: IsSlipActiveReady ready, slpno = " + record[19]);
			lockRecord("Slip", record[19], record);
			memLockSlipno = record[19];
			// unlock record after addEntry (in addEntryReady() or AddPackageEntryReady())
		} else {
			System.out.print("DEBUG: IsSlipActiveReady not ready, slpno = " + record[19]);
			tmpVetor.add(record);
		}
	}

	@Override
	protected void lockRecordReady(final String lockType, final String lockKey, String[] record, boolean lock) {
		super.lockRecordReady(lockType, lockKey, record, lock);
		if (lock) {
			if (getPost2Charge().isSelected()) {
				AddEntry(record[19], memItmCode, memItmType, memCredit?ConstantsTransaction.SLIPTX_TYPE_CREDIT:ConstantsTransaction.SLIPTX_TYPE_DEBIT,
						record[7], record[2], record[8], memItmRLvl, record[10],
						record[12].trim().length() == 0 ? record[11].trim():record[12].trim(), "", capturedate, TransactionDate,
								memItmName + " " + memItmCName, "", "", "", false,
						"", "", true, record[13], record[14], "1",
						"", "");
//					logger.info("AddEntry>>>>>"+id);
			} else {
				AddPackageEntry(record[19], record[18], memItmCode, record[7], record[2],
						record[8], memItmRLvl, record[10],
						capturedate, TransactionDate, memItmName + " " + memItmCName, "", false,
						"", "", true,
						record[13], record[14], "", "", false);
//				logger.info("AddPackageEntry>>>>>"+id);
			}
		} else {
			if (saveIndex < (getChargeListTable().getRowCount() - 1)) {
				saveIndex++;
				PostTransactions();
			}
		}
	}

	@Override
	public void AddEntryReady(String slpNo, String entry) {
		unlockSlipno(slpNo);

		int rowIndex = getChargeListTable().findRow(0, slpNo);
		if (rowIndex > -1) {
			getChargeListTable().removeRow(rowIndex);
		}

		if (getChargeListTable().getRowCount() == 0) {
			getCancelButton().setEnabled(false);	// no need confirm cancel popup
			cancelAction();
			tmpVetor.clear();
		} else {
			PostTransactions();
		}
	}

	@Override
	public void AddPackageEntryReady(String slpNo, String entry) {
		unlockSlipno(slpNo);

		int rowIndex = getChargeListTable().findRow(0, slpNo);
		if (rowIndex > -1) {
			getChargeListTable().removeRow(rowIndex);
		}

		if (getChargeListTable().getRowCount() == 0) {
			getCancelButton().setEnabled(false);	// no need confirm cancel popup
			cancelAction();
			tmpVetor.clear();
		} else {
			PostTransactions();
		}
	}

	private void unlockSlipno(String slipno) {
		CommonUtil.unlockRecord(getUserInfo(), "Slip", slipno);
	}

	private void PrePostTransactions() {
		capturedate = "";
		TransactionDate = "";
//		String PkgCode = "";
		memItmCName = "";
		memItmName = getItmName().getText();
		capturedate = getMainFrame().getServerDateTime();
		TransactionDate = getTransaction().getText().trim();
		PostTransactions();
	}

	int saveIndex = 0;
	private void PostTransactions() {
		if (getChargeListTable().getRowCount() > 0) {
			String[] rs = getChargeListTable().getRowContent(saveIndex);

			if (!memItmCode.isEmpty() && rs[19].trim().length() > 0&&rs[2].trim().length() > 0&&Integer.valueOf(rs[2].trim()) > 0) {//SlpNo2 is not empty and StnNAmt > 0
				IsSlipActive(rs);
			} else {
				tmpVetor.add(rs);
			}
		}
	}

	private int getSelectedOrLastRow() {
		row = getChargeListTable().getSelectedRow();
		if (row == -1) {
			row = getChargeListTable().getRowCount()-1;
		}
		return row;
	}

	private void calcBatchAmount() {
		int sum = 0;
		String[] rs = null;
		for (int i=0; i<getChargeListTable().getRowCount(); i++) {
			try {
				rs = getChargeListTable().getRowContent(i);
				sum += Integer.valueOf(rs[2]);
			} catch (Exception e) {}
		}
		getBatchAmount().setText(String.valueOf(sum));
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	//action method override end
	/* >>> getter methods for init the Component start from here================================== <<< */
	@Override
	protected BasePanel getActionPanel() {
		if (actionPanel == null) {
			actionPanel = new BasePanel();
			actionPanel.setSize(779, 480);
			actionPanel.add(getListPanel(), null);
		}
		return actionPanel;
	}

	public BasePanel getListPanel() {
		if (listPanel == null) {
			listPanel = new BasePanel();
			//listPanel.setEtchedBorder();
			listPanel.setBounds(new Rectangle(10, 5, 757, 400));
			listPanel.add(getSlipScrollPane(), null);
			listPanel.add(getTransactionDesc(), null);
			listPanel.add(getTransaction(), null);
			listPanel.add(getItmPanel(), null);
			listPanel.add(getPatSlpPanel(), null);
			listPanel.add(getEntBatPanel(), null);
			listPanel.add(getPostPanel(), null);
		}
		return listPanel;
	}

	/**
	 * This method initializes jScrollPane
	 *
	 * @return JScrollPane
	 */
	protected JScrollPane getSlipScrollPane() {
		if (slipScrollPane == null) {
			slipScrollPane = new JScrollPane();
			slipScrollPane.setViewportView(getChargeListTable());
			slipScrollPane.setBounds(300, 5, 450, 380);
		}
		return slipScrollPane;
	}

	public TableList getChargeListTable() {
		if (chargeListTable == null) {
			chargeListTable =
					new TableList(getChargeListColumnNames(),
										getChargeListColumnWidths(),
										false, null, null);
			chargeListTable.setId("charge-list-table");
//			chargeListTable.setAutoHeight(true);
		}
		return chargeListTable;
	}

	protected String[] getChargeListColumnNames() {
		return new String[] {
				"Slip No.",      //SlpNo
				"Patient No.",  //PatNo
				"Amount",       //StnNAmt
				"Patient Name", //PatName=PatFName+PatGName
				"Visit",        //PkgCode
				"PatFName",
				"PatGName",
				"StnOAmt",
				"DocCode",
				"DptCode",
				"AcmCode",
				"cpsPct",
				"SlpDisc",
				"stnCpsFlag",
				"cpsid",
				"SlpType",
				"cpsFix",
				"PATNO2",        //PatNo2
				"PkgCode",       //PkgCode
				"SlpNo2"         //SlpNo2
			};
	}

	protected int[] getChargeListColumnWidths() {
		return new int[] {
				80,
				100,
				80,
				100,
				80,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0
		};
	}

	public LabelBase getTransactionDesc() {
		if (transactionDesc == null) {
			transactionDesc = new LabelBase();
			transactionDesc.setText("Transaction Date");
			transactionDesc.setBounds(5, 5, 120, 20);
		}
		return transactionDesc;
	}

	public TextDate getTransaction() {
		if (transaction == null) {
		   transaction = new TextDate();
		   transaction.setBounds(130, 5, 120, 20);
		}
		return transaction;
	}

	public BasePanel getItmPanel() {
		if (itmPanel == null) {
			itmPanel = new BasePanel();
			itmPanel.setEtchedBorder();
			itmPanel.setBounds(5, 35, 250, 60);
			itmPanel.add(getItmCodeDesc(), null);
			itmPanel.add(getItmCode(), null);
			itmPanel.add(getItmName(), null);
		}
		return itmPanel;
	}

	public LabelBase getItmCodeDesc() {
		if (itmCodeDesc == null) {
			itmCodeDesc = new LabelBase();
			itmCodeDesc.setText("Item Code");
			itmCodeDesc.setBounds(5, 5, 80, 20);
		}
		return itmCodeDesc;
	}

	public TextItemCodeSearch getItmCode() {
		if (itmCode == null) {
			setParameter("itemCategoryExcl", ConstantsTransaction.ITEM_CATEGORY_CREDIT);
			itmCode = new TextItemCodeSearch() {
				@Override
				public void onReleased() {
					getItmName().resetText();
				}

				@Override
				public void onBlur() {
					super.onBlur();
					if (itmCode.getText().length() > 0) {
						getLookUpItmCode();
					}
				};

				@Override
				protected void onTriggerClick(ComponentEvent ce) {
					if (!validateTransaction()) {
						return;
					}
					super.onTriggerClick(ce);
				}
			};
			itmCode.setBounds(69, 5, 171, 20);
		}
		return itmCode;
	}

	public TextReadOnly getItmName() {
		if (itmName == null) {
			itmName = new TextReadOnly();
			itmName.setBounds(70, 30, 170, 20);
		}
		return itmName;
	}

	public BasePanel getPatSlpPanel() {
		if (patSlpPanel == null) {
			patSlpPanel = new BasePanel();
			patSlpPanel.setEtchedBorder();
			patSlpPanel.setBounds(5, 100, 250, 160);
			patSlpPanel.add(getPatNoDesc(), null);
			patSlpPanel.add(getPatNo(), null);
			patSlpPanel.add(getSlpNoDesc(), null);
			patSlpPanel.add(getSlpNo(), null);
			patSlpPanel.add(getCPSFixAmtDesc(), null);
			patSlpPanel.add(getCPSFixAmt(), null);
			patSlpPanel.add(getCPSDesc(), null);
			patSlpPanel.add(getCPS(), null);
			patSlpPanel.add(getAmtDesc(), null);
			patSlpPanel.add(getAmt(), null);
			patSlpPanel.add(getVisitDesc(), null);
			patSlpPanel.add(getVisit(), null);
			patSlpPanel.add(getPkgCodeDesc(), null);
			patSlpPanel.add(getPkgCode(), null);
		}
		return patSlpPanel;
	}

	public LabelBase getPatNoDesc() {
		if (patNoDesc == null) {
			patNoDesc = new LabelBase();
			patNoDesc.setText("Patient No.");
			patNoDesc.setBounds(5, 5, 110, 20);
		}
		return patNoDesc;
	}

	public TextPatientNoSearch getPatNo() {
		if (patNo == null) {
			patNo = new TextPatientNoSearch(false, getChargeListTable(), 1) {
				@Override
				public void onBlur() {
					String tempOldPatientNo = getOldPatientNo();
					checkMergePatient();

					// clear slpno only if patno changed
					if (!getText().equals(tempOldPatientNo)) {
						getSlpNo().clear();
						row = getChargeListTable().getSelectedRow();
						if (row == -1) {
							row = getChargeListTable().getRowCount() - 1;
						}
						getChargeListTable().resetValueAt(row, 0);	// Slip No.
						getChargeListTable().resetValueAt(row, 19);	// SlpNo2
						getChargeListTable().resetValueAt(row, 3);	// Patient Name
						getChargeListTable().resetValueAt(row, 18);	// PkgCode
					}
				};

				@Override
				protected void checkPatient(boolean isExistPatient, boolean bySearchKey) {
					super.checkPatient(isExistPatient, bySearchKey);
					if (!isEmpty()) {
						getLookupPatNo();
					}
				}

				@Override
				protected void onTriggerClick(ComponentEvent ce) {
					if (!validateTransaction()) {
						return;
					}
					super.onTriggerClick(ce);
				}

				@Override
				public void showMergeFromPatientPost() {
					getLookupPatNo();
				}
			};
			patNo.setBounds(120, 5, 120, 20);
		}
		return patNo;
	}

	public LabelBase getSlpNoDesc() {
		if (slpNoDesc == null) {
			slpNoDesc = new LabelBase();
			slpNoDesc.setText("Slip Number");
			slpNoDesc.setBounds(5, 30, 110, 20);
		}
		return slpNoDesc;
	}

	public TextSlipSearch getSlpNo() {
		if (slpNo == null) {
			slpNo = new TextSlipSearch() {
				@Override
				public void showSearchPanel() {
					getSearchDialog().showPanel();
					setShowSlpDlg(false);
				}

				@Override
				public void onBlur() {
					super.onBlur();
					if (!slpNo.isEmpty()) {
						slpNoChanged();
						getLookupSlpNo();
						setShowSlpDlg(true);
					}
					isSlpNoFocus = false;
				}

				@Override
				protected void onFocus(ComponentEvent ce) {
					super.onFocus();
					if (isShowSlpDlg() && slpNo.getText().trim().isEmpty()) {
						lookupSlpno();
					}
					isSlpNoFocus = true;
				}

				@Override
				protected void onTriggerClick(ComponentEvent ce) {
					if (!validateTransaction()) {
						return;
					}
					lookupSlpno();
				}
			};

			slpNo.setBounds(120, 30, 120, 20);
		}
		return slpNo;
	}

	public LabelBase getCPSFixAmtDesc() {
		if (CPSFixAmtDesc == null) {
			CPSFixAmtDesc = new LabelBase();
			CPSFixAmtDesc.setText("CPS Fix Amount");
			CPSFixAmtDesc.setBounds(5, 55, 110, 20);
		}
		return CPSFixAmtDesc;
	}

	public TextReadOnly getCPSFixAmt() {
		if (CPSFixAmt == null) {
			CPSFixAmt = new TextReadOnly();
			CPSFixAmt.setBounds(120, 55, 40, 20);
		}
		return CPSFixAmt;
	}

	public LabelBase getCPSDesc() {
		if (CPSDesc == null) {
			CPSDesc = new LabelBase();
			CPSDesc.setText("CPS%");
			CPSDesc.setBounds(165, 55, 50, 20);
		}
		return CPSDesc;
	}

	public TextReadOnly getCPS() {
		if (CPS == null) {
			CPS = new TextReadOnly();
			CPS.setBounds(210, 55, 30, 20);
		}
		return CPS;
	}

	public LabelBase getAmtDesc() {
		if (amtDesc == null) {
			amtDesc = new LabelBase();
			amtDesc.setText("Amount");
			amtDesc.setBounds(5, 80, 110, 20);
		}
		return amtDesc;
	}

	public TextNum getAmt() {
		if (amt == null) {
			amt = new TextNum(9, getChargeListTable(), 2) {
				@Override
				public void onBlur() {
					super.onBlur();
					if (amt.getRawValue().trim().length() > 0) {
						try {
							Integer.parseInt(amt.getRawValue());
						} catch (Exception e) {
							Factory.getInstance().addErrorMessage(
									ConstantsMessage.MSG_POS_INTEGER,
									"PBA-["+getTitle()+"]",
									null,
									new Listener<MessageBoxEvent>() {
										@Override
										public void handleEvent(
												MessageBoxEvent be) {
											selectAll();
											focus();
										}
							});
							return;
						}
					}
					calcBatchAmount();
				}
			};
			amt.setBounds(120, 80, 120, 20);
		}
		return amt;
	}

	public LabelBase getVisitDesc() {
		if (visitDesc == null) {
			visitDesc = new LabelBase();
			visitDesc.setText("Visit");
			visitDesc.setBounds(5, 105, 110, 20);
		}
		return visitDesc;
	}

	public ComboVisitPkgCode getVisit() {
		if (visit == null) {
			visit = new ComboVisitPkgCode(getSlpNo().getText().trim()) {
				@Override
				protected void setTextPanel(ModelData modelData) {
					int row = getChargeListTable().getSelectedRow();
					if (row == -1) {
						row = getChargeListTable().getRowCount()-1;
					}
					getChargeListTable().setValueAt(visit.getDisplayText(), row, 4);
				}
			};
			visit.setBounds(120, 105, 120, 20);
		}
		return visit;
	}

	public LabelBase getPkgCodeDesc() {
		if (pkgCodeDesc == null) {
			pkgCodeDesc = new LabelBase();
			pkgCodeDesc.setText("Pkg Code");
			pkgCodeDesc.setBounds(5, 130, 110, 20);
		}
		return pkgCodeDesc;
	}

	public TextString getPkgCode() {
		if (pkgCode == null) {
			pkgCode = new TextString() {
				public void onBlur() {
					if (!pkgCode.isEmpty()) {
						ValidateVisitPkgCode();
					}
				};
			};
			pkgCode.setBounds(120, 130, 120, 20);
		}
		return pkgCode;
	}

	public BasePanel getEntBatPanel() {
		if (entBatPanel == null) {
			entBatPanel = new BasePanel();
			entBatPanel.setEtchedBorder();
			entBatPanel.setBounds(5, 265, 250, 60);
			entBatPanel.add(getNumberOfEntryDesc(), null);
			entBatPanel.add(getNumberOfEntry(), null);
			entBatPanel.add(getBatchAmountDesc(), null);
			entBatPanel.add(getBatchAmount(), null);
		}
		return entBatPanel;
	}

	public LabelBase getNumberOfEntryDesc() {
		if (numberOfEntryDesc == null) {
			numberOfEntryDesc = new LabelBase();
			numberOfEntryDesc.setText("Number of Entry");
			numberOfEntryDesc.setBounds(5, 5, 110, 20);
		}
		return numberOfEntryDesc;
	}

	public TextReadOnly getNumberOfEntry() {
		if (numberOfEntry == null) {
			numberOfEntry = new TextReadOnly();
			numberOfEntry.setBounds(120, 5, 120, 20);
			numberOfEntry.setText(ZERO_VALUE);
		}
		return numberOfEntry;
	}

	public LabelBase getBatchAmountDesc() {
		if (batchAmountDesc == null) {
			batchAmountDesc = new LabelBase();
			batchAmountDesc.setText("Batch Amount");
			batchAmountDesc.setBounds(5,30, 110, 20);
		}
		return batchAmountDesc;
	}

	public TextReadOnly getBatchAmount() {
		if (batchAmount == null) {
			batchAmount = new TextReadOnly();
			batchAmount.setBounds(120, 30, 120, 20);
			batchAmount.setText(ZERO_VALUE);
		}
		return batchAmount;
	}

	public BasePanel getPostPanel() {
		if (postPanel == null) {
			postPanel = new BasePanel();
			postPanel.setEtchedBorder();
			postPanel.setBounds(5, 330, 250, 55);
			postPanel.add(getPost2Charge(), null);
			postPanel.add(getPost2RefFile(), null);
			RadioGroup btg = new RadioGroup();
			btg.add(getPost2Charge());
			btg.add(getPost2RefFile());
		}
		return postPanel;
	}

	public RadioButtonBase getPost2Charge() {
		if (post2Charge == null) {
			post2Charge = new RadioButtonBase();
			post2Charge.setText("<html>Post to<br>charge patient</html>");
			post2Charge.setSelected(true);
			post2Charge.setBounds(5, 5, 120, 40);
		}
		return post2Charge;
	}

	public RadioButtonBase getPost2RefFile() {
		if (post2RefFile == null) {
			post2RefFile = new RadioButtonBase() {
				@Override
				public void onClick() {
					super.onClick();
					if (!getPkgCode().isEmpty()) {
						ValidateVisitPkgCode();
					}
				}
			};
			post2RefFile.setText("<html>Post to<br>reference file</html>");
			post2RefFile.setBounds(130, 5, 113, 40);
		}
		return post2RefFile;
	}
}