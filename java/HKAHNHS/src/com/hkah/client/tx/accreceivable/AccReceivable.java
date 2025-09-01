package com.hkah.client.tx.accreceivable;

import java.util.HashMap;

import com.extjs.gxt.ui.client.widget.Component;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.dialog.DlgARChargeCap;
import com.hkah.client.layout.dialog.DlgPrintARList;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.panel.TabbedPaneBase;
import com.hkah.client.layout.table.BufferedTableList;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextARCodeSearch;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextSlipSearch;
import com.hkah.client.tx.SearchPanel;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsAR;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class AccReceivable extends SearchPanel implements ConstantsAR {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.ACCRECEIVABLE_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.ACCRECEIVABLE_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	protected String[] getColumnNames() {
		return new String[] {
				"", "",
				"Patient No.",
				"Patient Name",
				"Date",
				"Slip No.",
				"Balance",
				"Status"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				0, 0,
				70,
				310,
				80,
				90,
				100,
				50
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private BasePanel searchPanel = null;
	private BasePanel ParaPanel = null;

	private LabelBase PayerCodeDesc = null;
	private TextARCodeSearch PayerCode = null;
	private TextReadOnly PayerName = null;
	private LabelBase AddressDesc = null;
	private TextReadOnly Address1 = null;
	private TextReadOnly Address2 = null;
	private TextReadOnly Address3 = null;
	private LabelBase PhoneDesc = null;
	private TextReadOnly Phone = null;
	private LabelBase ContactDesc = null;
	private TextReadOnly Contact = null;
	private LabelBase FaxDesc = null;
	private TextReadOnly Fax = null;
	private LabelBase EmailDesc = null;
	private TextReadOnly Email = null;
	private LabelBase UnDrDesc = null;
	private TextReadOnly UnDr = null;
	private LabelBase UnCrDesc = null;
	private TextReadOnly UnCr = null;
	private LabelBase NetDesc = null;
	private TextReadOnly Net = null;

	private ButtonBase Details = null;
	private ButtonBase ChargeCredit = null;
	private ButtonBase CreditAll = null;
	private ButtonBase CompanyAll = null;
	private ButtonBase SelCompanyAll = null;

	private TabbedPaneBase TabbedPane = null;

	private BasePanel SLPanel = null;
	private LabelBase PatientNoDesc = null;
	private TextPatientNoSearch PatientNo = null;
	private LabelBase SlipNoDesc = null;
	private TextSlipSearch SlipNo = null;
	private LabelBase SLOutstandDesc = null;
	private CheckBoxBase SLOutstand = null;

	private BasePanel CLPanel = null;
	private LabelBase CLOutstandDesc = null;
	private CheckBoxBase CLOutstand = null;
	private TableList CLTable = null;
	private JScrollPane CLJScrollPane = null;

	private String memArcCode = null;
	private String memPatNo = null;
	private String memSlipNo = null;
	private boolean foundArcCode = false;
	private boolean loadSlipLevel = false;
	private boolean loadCompanyLevel = false;
	private DlgARChargeCap dlgARChargeCap = null;
	private DlgPrintARList dlgPrintARList = null;

	/**
	 * This method initializes
	 *
	 */
	public AccReceivable() {
		super();
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		resetCurrentFields();
		getJScrollPane().setBounds(10, 40, 747, 230);
		getCLTable().setColumnAmount(3);
		getListTable().setColumnAmount(6);

		getSLOutstand().setSelected(true);
		getCLOutstand().setSelected(true);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public Component getDefaultFocusComponent() {
		if (getTabbedPane().getSelectedIndex() == 1 && getCLTable().getRowCount() > 0) {
			return getCLTable();
		} else if (getTabbedPane().getSelectedIndex() == 0 && getListTable().getRowCount() > 0) {
			return getPatientNo();
		} else {
			return getPayerCode();
		}
	}

	/* >>> ~14~ Set Browse Validation ===================================== <<< */
	@Override
	protected boolean browseValidation() {
		return true;
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		if (getTabbedPane().getSelectedIndex() == 1) {
			return new String[] { "COMPANYLVL", getPayerCode().getText().trim(), EMPTY_VALUE, EMPTY_VALUE, getCLOutstand().isSelected()?YES_VALUE:NO_VALUE };
		} else {
			return new String[] { "SLIPLVL", getPayerCode().getText().trim(), getPatientNo().getText().trim(), getSlipNo().getText().trim(), getSLOutstand().isSelected()?YES_VALUE:NO_VALUE };
		}
	}

	/***************************************************************************
	 * Helper Methods
	 **************************************************************************/

	private void showInfo() {
		final String payerCode = getPayerCode().getText();
		if (payerCode.length() == 0) {
			resetCurrentFields();
			return;
		}

		if (!payerCode.equals(memArcCode)) {
			foundArcCode = false;
			loadSlipLevel = false;
			loadCompanyLevel = false;

			if (memArcCode != null && memArcCode.length() > 0) {
				unlockRecord("ArCode", memArcCode);
			}

			QueryUtil.executeMasterFetch(
					getUserInfo(), ConstantsTx.ACCRECEIVABLE_TXCODE, new String[] { payerCode },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						getPayerName().setText(mQueue.getContentField()[1]);
						getAddress1().setText(mQueue.getContentField()[2]);
						getAddress2().setText(mQueue.getContentField()[3]);
						getAddress3().setText(mQueue.getContentField()[4]);
						getPhone().setText(mQueue.getContentField()[5]);
						getContact().setText(mQueue.getContentField()[6]);
						getFax().setText(mQueue.getContentField()[7]);
						getEmail().setText(mQueue.getContentField()[8]);
						getUnDr().setText(TextUtil.formatCurrency(mQueue.getContentField()[10]));
						getUnCr().setText(TextUtil.formatCurrency(mQueue.getContentField()[9]));
						getNet().setText(TextUtil.formatCurrency(mQueue.getContentField()[11]));

						foundArcCode = true;
						memArcCode = payerCode;

						lockRecord("ArCode", payerCode);
					} else {
						resetCurrentFields();
						Factory.getInstance().addErrorMessage("Invalid payer code.", getPayerCode());
					}
				}
			});
		}
	}

	private void lookupPatNo(final String patno) {
		if	(memPatNo.length() == 0)	{
			getPatientNo().checkMergePatient();
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] { "patient", "patno", "patno='" + patno + "'" },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						loadSlipLevel = false;
						searchHelper(false);
						memPatNo = patno;
					} else {
						getPatientNo().resetText();
						Factory.getInstance().addErrorMessage("Invalid patient number.", getPatientNo());
					}
				}
			});
		}
	}

	private void lookupSlipNo(final String slipNo) {
		if	(memSlipNo.length() == 0)	{
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] { "slip", "slpno", "slpno='" + slipNo + "'" },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						loadSlipLevel = false;
						searchHelper(false);
						memSlipNo = slipNo;
					} else {
						getSlipNo().resetText();
						Factory.getInstance().addErrorMessage("Invalid slip number.", getSlipNo());
					}
				}
			});
		}
	}

	private void setARParameters(String transactionMode) {
		String atxAmt = null;
		String atxDesc = null;
		String atxRefID = null;
		String arID = null;
		if (getCLTable().getSelectedRow() >= 0) {
			atxAmt = getCLTable().getSelectedRowContent()[3];
			atxDesc = getCLTable().getSelectedRowContent()[2];
			atxRefID = getCLTable().getSelectedRowContent()[4];
			arID = getCLTable().getSelectedRowContent()[1];
		}

		getDlgARChargeCap().showDialog(
				transactionMode,
				getPayerCode().getText(),
				getPayerName().getText(),
				atxAmt,
				atxDesc,
				atxRefID,
				arID
		);
	}

	private void searchHelper(boolean searchPayer) {
		if (searchPayer) {
			searchAction();
		} else {
			if (foundArcCode) {
				superSearchAction();
			} else if (!getPayerCode().isEmpty()) {
				showInfo();
			} else {
				defaultFocus();
			}
		}
	}

	private void superSearchAction() {
		if (getTabbedPane().getSelectedIndex() == 0 && !loadSlipLevel) {
			loadSlipLevel = true;
			super.searchAction(true);
		} else if (getTabbedPane().getSelectedIndex() == 1 && !loadCompanyLevel) {
			loadCompanyLevel = true;
			super.searchAction(true);
		}
	}

	/***************************************************************************
	 * Override Methods
	 **************************************************************************/

	@Override
	public void resetCurrentFields() {
		foundArcCode = false;
		memArcCode = EMPTY_VALUE;
		memPatNo = EMPTY_VALUE;
		memSlipNo = EMPTY_VALUE;
		loadSlipLevel = false;
		loadCompanyLevel = false;

		getPayerCode().resetText();
		getPayerName().resetText();
		getAddress1().resetText();
		getAddress2().resetText();
		getAddress3().resetText();
		getPhone().resetText();
		getContact().resetText();
		getFax().resetText();
		getEmail().resetText();
		getUnDr().resetText();
		getUnCr().resetText();
		getNet().resetText();

		getPatientNo().resetText();
		getSlipNo().resetText();
		getListTable().removeAllRow();
		getCLTable().removeAllRow();
		enableButton();
	}

	@Override
	protected void proExitPanel() {
		Factory.getInstance().writeLogToLocal("--------------------------------");
		Factory.getInstance().writeLogToLocal("AR Code before exit ArReceivable.......");
		Factory.getInstance().writeLogToLocal("AR Code length:"+getPayerCode().getText().trim().length());

		if (getPayerCode().getText().trim().length() > 0) {
			Factory.getInstance().writeLogToLocal("AR Code:"+getPayerCode().getText());
			unlockRecord("ArCode", getPayerCode().getText());
		}
	}

	@Override
	protected void lockRecordReady(final String lockType, final String lockKey, String[] record, boolean lock, String returnMessage) {
		if (!lock) {
			resetCurrentFields();
			Factory.getInstance().addErrorMessage(returnMessage);
		} else {
			QueryUtil.executeMasterAction(
					getUserInfo(), "UPDATE", QueryUtil.ACTION_APPEND,
					new String[] { "ArCode",
						"ArcAmt=(select nvl(sum(ATXAMT),0)-nvl(sum(ATXSAMT),0) from Artx where arccode='" + getPayerCode().getText() + "' and ATXSTS='N' )",
						"arccode='" + getPayerCode().getText()+ "'" },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						QueryUtil.executeMasterAction(getUserInfo(), "UPDATE", QueryUtil.ACTION_APPEND,
								new String[] { "ArCode",
									"ARCUAMT=(select nvl(sum(ARPOAMT),0)+nvl(sum(ARPAAMT),0) from Arptx where arccode='" + getPayerCode().getText() + "' and  ARPSTS='N' )",
									"arccode='" + getPayerCode().getText()+ "'" },
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									searchHelper(false);
								} else {
									Factory.getInstance().addErrorMessage(mQueue);
								}
							}
						});
					} else {
						Factory.getInstance().addErrorMessage(mQueue);
					}
				}
			});
		}
	}

	@Override
	protected TableList getCurrentListTable() {
		if (getTabbedPane().getSelectedIndex() == 1) {
			return getCLTable();
		} else {
			return getListTable();
		}
	}

	@Override
	public void searchAction() {
		if (getSearchButton().isEnabled() && !triggerSearchField()) {
			if (getPayerCode().isEmpty()) {
				getPayerCode().showSearchPanel();
			} else {
				super.searchAction();
			}
		}
	}

	@Override
	protected void enableButton(String mode) {
		disableButton();
		getSearchButton().setEnabled(true);

		getPatientNo().setEditable(foundArcCode);
		getSlipNo().setEditable(foundArcCode);
		getSLOutstand().setEditable(foundArcCode);
		getSLOutstandDesc().setEnabled(foundArcCode);
		getCLOutstand().setEditable(foundArcCode);
		getCLOutstandDesc().setEnabled(foundArcCode);
		getDetails().setEnabled(foundArcCode);
		getChargeCredit().setEnabled(foundArcCode && getTabbedPane().getSelectedIndex() == 1);
		getCreditAll().setEnabled(foundArcCode);
		getCompanyAll().setEnabled(foundArcCode);
		getSelectedCompanyAll().setEnabled(foundArcCode && getTabbedPane().getSelectedIndex() == 1);
	}

	@Override
	public void rePostAction() {
		loadSlipLevel = false;
		loadCompanyLevel = false;
		memArcCode = null;
		showInfo();
	}

	@Override
	protected void performListNoRecordPostMsg(MessageQueue mQueue) {
	}

	@Override
	protected boolean triggerSearchField() {
		if (getPayerCode().isFocusOwner()) {
			getPayerCode().checkTriggerBySearchKey();
			return true;
		} else if (getPatientNo().isFocusOwner()) {
			getPatientNo().checkTriggerBySearchKey();
			return true;
		} else if (getSlipNo().isFocusOwner()) {
			getSlipNo().checkTriggerBySearchKey();
			return true;
		} else {
			return false;
		}
	}

	/***************************************************************************
	 * Dialog Method
	 **************************************************************************/

	private DlgARChargeCap getDlgARChargeCap() {
		if (dlgARChargeCap == null) {
			dlgARChargeCap = new DlgARChargeCap(getMainFrame()) {
				@Override
				protected void afterPost() {
					rePostAction();
				}
			};
		}
		return dlgARChargeCap;
	}

	private DlgPrintARList getDlgPrintARList() {
		if (dlgPrintARList == null) {
			dlgPrintARList = new DlgPrintARList(getMainFrame());
		}
		return dlgPrintARList;
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	@Override
	protected BasePanel getSearchPanel() {
		if (searchPanel == null) {
			searchPanel = new BasePanel();
			searchPanel.setSize(788, 528);
			searchPanel.add(getParaPanel(), null);
			searchPanel.add(getTabbedPane(), null);
			searchPanel.add(getDetails(), null);
			searchPanel.add(getChargeCredit(), null);
			searchPanel.add(getCreditAll(), null);
			searchPanel.add(getCompanyAll(), null);
			searchPanel.add(getSelectedCompanyAll(),null);
		}
		return searchPanel;
	}

	public TabbedPaneBase getTabbedPane() {
		if (TabbedPane == null) {
			TabbedPane = new TabbedPaneBase() {
				public void onStateChange() {
					searchHelper(false);
					enableButton();
				}
			};
			TabbedPane.setBounds(5, 145, 775, 310);
			TabbedPane.addTab("Slip Level", getSLPanel());
			TabbedPane.addTab("Company Level", getCLPanel());
		}
		return TabbedPane;
	}

	public BasePanel getParaPanel() {
		if (ParaPanel == null) {
			ParaPanel = new BasePanel();
			ParaPanel.setBorders(true);
			ParaPanel.setBounds(5, 5, 775, 133);
			ParaPanel.add(getPayerCodeDesc(), null);
			ParaPanel.add(getPayerCode(), null);
			ParaPanel.add(getPayerName(), null);
			ParaPanel.add(getAddressDesc(), null);
			ParaPanel.add(getAddress1(), null);
			ParaPanel.add(getAddress2(), null);
			ParaPanel.add(getAddress3(), null);
			ParaPanel.add(getPhoneDesc(), null);
			ParaPanel.add(getPhone(), null);
			ParaPanel.add(getContactDesc(), null);
			ParaPanel.add(getContact(), null);
			ParaPanel.add(getFaxDesc(), null);
			ParaPanel.add(getFax(), null);
			ParaPanel.add(getEmailDesc(), null);
			ParaPanel.add(getEmail(), null);
			ParaPanel.add(getUnDrDesc(), null);
			ParaPanel.add(getUnDr(), null);
			ParaPanel.add(getUnCrDesc(), null);
			ParaPanel.add(getUnCr(), null);
			ParaPanel.add(getNetDesc(), null);
			ParaPanel.add(getNet(), null);
		}
		return ParaPanel;
	}

	public LabelBase getPayerCodeDesc() {
		if (PayerCodeDesc == null) {
			PayerCodeDesc = new LabelBase();
			PayerCodeDesc.setText("Payer Code");
			PayerCodeDesc.setBounds(10, 10, 80, 20);
		}
		return PayerCodeDesc;
	}

	public TextARCodeSearch getPayerCode() {
		if (PayerCode == null) {
			PayerCode = new TextARCodeSearch() {

				@Override
				public void checkTriggerBySearchKey() {
					if (isFocusOwner()) {
							showSearchPanel();
							resetText();
					}
				}

				@Override
				public void onBlur() {
					if (PayerCode.getText().trim().length() > 0) {
						PayerCode.setText(PayerCode.getText().trim().toUpperCase());
					//	showInfo();
					}
				}

				@Override
				public void onTab() {
					if (PayerCode.getText().trim().length() > 0) {
						PayerCode.setText(PayerCode.getText().trim().toUpperCase());
						showInfo();
					}
				}

				@Override
				public void onReleased() {
					if (memArcCode != null && memArcCode.length() > 0 && !memArcCode.equals(getText())) {
						String originalArcCode = null;
						if (getText().length() > memArcCode.length()) {
							originalArcCode = getText().substring(memArcCode.length());
						}
						unlockRecord("ArCode", memArcCode);
						resetCurrentFields();
						if (originalArcCode != null) {
							setText(originalArcCode);
						}
					}
				}
			};
			PayerCode.setBounds(90, 10, 103, 20);
		 }
		return PayerCode;
	}

	public TextReadOnly getPayerName() {
		if (PayerName == null) {
			PayerName = new TextReadOnly();
			PayerName.setBounds(197, 10, 204, 20);
		 }
		return PayerName;
	}

	public LabelBase getAddressDesc() {
		if (AddressDesc == null) {
			AddressDesc = new LabelBase();
			AddressDesc.setText("Address");
			AddressDesc.setBounds(411, 10, 46, 20);
		}
		return AddressDesc;
	}

	public TextReadOnly getAddress1() {
		if (Address1 == null) {
			Address1 = new TextReadOnly();
			Address1.setBounds(457, 10, 299, 20);
		 }
		return Address1;
	}

	public TextReadOnly getAddress2() {
		if (Address2 == null) {
			Address2 = new TextReadOnly();
			Address2.setBounds(457, 40, 299, 20);
		 }
		return Address2;
	}

	public TextReadOnly getAddress3() {
		if (Address3 == null) {
			Address3 = new TextReadOnly();
			Address3.setBounds(457, 70, 299, 20);
		 }
		return Address3;
	}

	public LabelBase getPhoneDesc() {
		if (PhoneDesc == null) {
			PhoneDesc = new LabelBase();
			PhoneDesc.setText("Phone");
			PhoneDesc.setBounds(10, 40, 80, 20);
		}
		return PhoneDesc;
	}

	public TextReadOnly getPhone() {
		if (Phone == null) {
			Phone = new TextReadOnly();
			Phone.setBounds(90, 40, 103, 20);
		 }
		return Phone;
	}

	public LabelBase getContactDesc() {
		if (ContactDesc == null) {
			ContactDesc = new LabelBase();
			ContactDesc.setText("Contact");
			ContactDesc.setBounds(201, 40, 47, 20);
		}
		return ContactDesc;
	}

	public TextReadOnly getContact() {
		if (Contact == null) {
			Contact = new TextReadOnly();
			Contact.setBounds(248, 40, 152, 20);
		 }
		return Contact;
	}

	public LabelBase getFaxDesc() {
		if (FaxDesc == null) {
			FaxDesc = new LabelBase();
			FaxDesc.setText("Fax");
			FaxDesc.setBounds(10, 70, 80, 20);
		}
		return FaxDesc;
	}

	public TextReadOnly getFax() {
		if (Fax == null) {
			Fax = new TextReadOnly();
			Fax.setBounds(90, 70, 103, 20);
		 }
		return Fax;
	}

	public LabelBase getEmailDesc() {
		if (EmailDesc == null) {
			EmailDesc = new LabelBase();
			EmailDesc.setText("Email");
			EmailDesc.setBounds(201, 70, 47, 20);
		}
		return EmailDesc;
	}

	public TextReadOnly getEmail() {
		if (Email == null) {
			Email = new TextReadOnly();
			Email.setBounds(248, 70, 152, 20);
		 }
		return Email;
	}

	public LabelBase getUnDrDesc() {
		if (UnDrDesc == null) {
			UnDrDesc = new LabelBase();
			UnDrDesc.setText("Unsettled Dr.");
			UnDrDesc.setBounds(10, 100, 80, 20);
		}
		return UnDrDesc;
	}

	public TextReadOnly getUnDr() {
		if (UnDr == null) {
			UnDr = new TextReadOnly();
			UnDr.setBounds(90, 100, 103, 20);
		 }
		return UnDr;
	}

	public LabelBase getUnCrDesc() {
		if (UnCrDesc == null) {
			UnCrDesc = new LabelBase();
			UnCrDesc.setText("Unallocate Cr.");
			UnCrDesc.setBounds(310, 100, 81, 20);
		}
		return UnCrDesc;
	}

	public TextReadOnly getUnCr() {
		if (UnCr == null) {
			UnCr = new TextReadOnly();
			UnCr.setBounds(391, 100, 103, 20);
		 }
		return UnCr;
	}

	public LabelBase getNetDesc() {
		if (NetDesc == null) {
			NetDesc = new LabelBase();
			NetDesc.setText("Net");
			NetDesc.setBounds(607, 100, 33, 20);
		}
		return NetDesc;
	}

	public TextReadOnly getNet() {
		if (Net == null) {
			Net = new TextReadOnly();
			Net.setBounds(640, 100, 117, 20);
		 }
		return Net;
	}

	public ButtonBase getDetails() {
		if (Details == null) {
			Details = new ButtonBase() {
				@Override
				public void onClick() {
					if (getTabbedPane().getSelectedIndex() == 0) {
						if (getListTable().getSelectedRow() < 0) {
							return;
						}
						setParameter("SlpNo", getListSelectedRow()[5]);
						setParameter("PatNo", getListSelectedRow()[2]);
					} else {
						if (getCLTable().getSelectedRow() < 0) {
							return;
						}
						resetParameter("SlpNo");
						resetParameter("PatNo");
						if ("C".equals(getCLTable().getSelectedRowContent()[9])) {
							setParameter("AtxID", getCLTable().getSelectedRowContent()[1]);
						} else {
							resetParameter("AtxID");
						}
					}
					setParameter("ArcCode", getPayerCode().getText());
					setParameter("FUNCTION", AR_DETAIL);
					showPanel(new ARDetail());
				}
			};
			Details.setText("Details", 'D');
			Details.setBounds(20, 465, 92, 25);
		}
		return Details;
	}

	public ButtonBase getChargeCredit() {
		if (ChargeCredit == null) {
			ChargeCredit = new ButtonBase() {
				@Override
				public void onClick() {
					setARParameters(AR_CHARGE_MODE);
				}
			};
			ChargeCredit.setText("Charge/Credit", 'r');
			ChargeCredit.setBounds(120, 465, 112, 25);
		 }
		return ChargeCredit;
	}

	public ButtonBase getCreditAll() {
		if (CreditAll == null) {
			CreditAll = new ButtonBase() {
				@Override
				public void onClick() {
					if (getPayerCode().getText().length()>0) {
						setParameter("ArcCode", getPayerCode().getText());
						setParameter("ArcName", getPayerName().getText());
						showPanel(new ARCreditAlloc());
					}
				}
			};
			CreditAll.setText("Credit Allocation", 'e');
			CreditAll.setBounds(240, 465, 134, 25);
		 }
		return CreditAll;
	}

	public ButtonBase getCompanyAll() {
		if (CompanyAll == null) {
			CompanyAll = new ButtonBase() {
				@Override
				public void onClick() {
					if (getPayerCode().getText().length() > 0) {
						getDlgPrintARList().showDialog();
					}
				}
			};
			CompanyAll.setText("Company Allocation List", 'i');
			CompanyAll.setBounds(382, 465, 171, 25);
		 }
		return CompanyAll;
	}

	public ButtonBase getSelectedCompanyAll() {
		if (SelCompanyAll == null) {
			SelCompanyAll = new ButtonBase() {
				@Override
				public void onClick() {
					if (getPayerCode().getText().length() > 0) {
						if(getCLTable().getSelectedRowCount() > 0){
							final String tempArpid = getCLTable().getSelectedRowContent()[1];
							final String tempArprecno = getCLTable().getSelectedRowContent()[7];

							QueryUtil.executeTx(getUserInfo(), "RPT_CMPALLOCLIST",
									new String[] {Factory.getInstance().getUserInfo().getSiteCode(),
													tempArpid, tempArprecno},
									new MessageQueueCallBack() {
								@Override
								public void onPostSuccess(MessageQueue mQueue) {
									HashMap<String, String> map = new HashMap<String, String>();
									map.put("SITECODE", Factory.getInstance().getUserInfo().getSiteCode());
									map.put("SITENAME", Factory.getInstance().getUserInfo().getSiteName());
									map.put("ARPID", tempArpid);
									map.put("ARPRECNO", tempArprecno);

									if (mQueue.success()) {
										PrintingUtil.print("", "CmpAllocList", map,"",
												new String[] {Factory.getInstance().getUserInfo().getSiteCode(), tempArpid, tempArprecno},
												new String[] {"SLPNO","PATNO","ARCCODE","CHDATE",
												"ALLOCATE","CHAMT","ARPRECNO",
												"BILLAMT","BILLDATE","PATNAME","ARCNAME","SLPTYPE"});
									} else {
										PrintingUtil.print("CmpAllocListEmpty", map, null);
									}
								}});
						}
					}
				}
			};
			SelCompanyAll.setText("Selected Company Allocation List", 'i');
			SelCompanyAll.setBounds(558, 465,180, 25);
		 }
		return SelCompanyAll;
	}

	public BasePanel getSLPanel() {
		if (SLPanel == null) {
			SLPanel = new BasePanel();
			SLPanel.add(getPatientNoDesc(), null);
			SLPanel.add(getPatientNo(), null);
			SLPanel.add(getSlipNoDesc(), null);
			SLPanel.add(getSlipNo(), null);
			SLPanel.add(getSLOutstandDesc(), null);
			SLPanel.add(getSLOutstand(), null);
			SLPanel.add(getJScrollPane(), null);
			SLPanel.setBounds(5, 5, 790, 294);
		}
		return SLPanel;
	}

	public LabelBase getPatientNoDesc() {
		if (PatientNoDesc == null) {
			PatientNoDesc = new LabelBase();
			PatientNoDesc.setText("Patient Number");
			PatientNoDesc.setBounds(10, 10, 92, 20);
		}
		return PatientNoDesc;
	}

	public TextPatientNoSearch getPatientNo() {
		if (PatientNo == null) {
			PatientNo = new TextPatientNoSearch() {
				@Override
				public void onBlur() {
					if (!PatientNo.isEmpty()) {
						lookupPatNo(PatientNo.getText().trim());
					}
				};

				@Override
				public void onPressed() {
					memPatNo = "";
				}
			};
			PatientNo.setBounds(102, 10, 113, 20);
		 }
		return PatientNo;
	}

	public LabelBase getSlipNoDesc() {
		if (SlipNoDesc == null) {
			SlipNoDesc = new LabelBase();
			SlipNoDesc.setText("Slip Number");
			SlipNoDesc.setBounds(237, 10, 104, 20);
		}
		return SlipNoDesc;
	}

	public TextSlipSearch getSlipNo() {
		if (SlipNo == null) {
			SlipNo = new TextSlipSearch() {
				@Override
				public void onBlur() {
					if (!SlipNo.isEmpty()) {
						lookupSlipNo(SlipNo.getText().trim());
					}
				};

				@Override
				public void onPressed() {
					memSlipNo = "";
				}
			};
			SlipNo.setBounds(341, 10, 113, 20);
		 }
		return SlipNo;
	}

	public LabelBase getSLOutstandDesc() {
		if (SLOutstandDesc == null) {
			SLOutstandDesc = new LabelBase();
			SLOutstandDesc.setText("Outstanding Only");
			SLOutstandDesc.setBounds(560, 10, 104, 20);
		}
		return SLOutstandDesc;
	}

	public CheckBoxBase getSLOutstand() {
		if (SLOutstand == null) {
			SLOutstand = new CheckBoxBase() {
				public void onClick() {
					loadSlipLevel = false;
					searchHelper(false);
				}
			};
			SLOutstand.setBounds(535, 10, 22, 20);
		 }
		return SLOutstand;
	}

	public BasePanel getCLPanel() {
		if (CLPanel == null) {
			CLPanel = new BasePanel();
			CLPanel.add(getCLOutstandDesc(), null);
			CLPanel.add(getCLOutstand(), null);
			CLPanel.add(getCLJScrollPane(), null);
			CLPanel.setLocation(5, 5);
			CLPanel.setSize(790, 294);
		}
		return CLPanel;
	}

	public LabelBase getCLOutstandDesc() {
		if (CLOutstandDesc == null) {
			CLOutstandDesc = new LabelBase();
			CLOutstandDesc.setText("Outstanding Only");
			CLOutstandDesc.setBounds(560, 10, 104, 20);
		}
		return CLOutstandDesc;
	}

	public CheckBoxBase getCLOutstand() {
		if (CLOutstand == null) {
			CLOutstand = new CheckBoxBase() {
				public void onClick() {
					loadCompanyLevel = false;
					searchHelper(false);
				}
			};
			CLOutstand.setBounds(535, 10, 22, 20);
		 }
		return CLOutstand;
	}

	private JScrollPane getCLJScrollPane() {
		if (CLJScrollPane == null) {
			CLJScrollPane = new JScrollPane();
			CLJScrollPane.setViewportView(getCLTable());
			CLJScrollPane.setBounds(10, 40, 747, 230);
		}
		return CLJScrollPane;
	}

	private TableList getCLTable() {
		if (CLTable == null) {
			CLTable = new BufferedTableList(getCLTableColumnNames(), getCLTableColumnWidths());
			CLTable.setTableLength(getListWidth());
			//PatStatusTable.setColumnClass(0, ComboPackage.class, true);
			//PatStatusTable.setColumnClass(1, String.class, true);
		}
		return CLTable;
	}

	protected String[] getCLTableColumnNames() {
		return new String[] {
				"",
				"AR ID",
				"Description",
				"Balance",
				"Reference",
				"Date",
				"Status",
				"Receipt", "",
				"AR Type",
				"User ID"};
	}

	protected int[] getCLTableColumnWidths() {
		return new int[] { 10, 60, 160, 70, 80, 65, 45, 100, 0, 60, 70};
	}
}