// Menu Name : Registration (Hospital) 
package com.hkah.client.tx.di;

import java.util.Date;
import java.util.List;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.google.gwt.i18n.client.DateTimeFormat;
import com.hkah.client.common.Factory;
import com.hkah.client.event.CallbackListener;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.combobox.ComboDoctor;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextItemCodeSearch;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.tx.di.DIECGExamReport;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsProperties;
import com.hkah.shared.constants.ConstantsTransaction;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DIECGExamReg extends MasterPanel {
	
	private String varJobNo = null;

	private String varPatNo = null;
	private String varPatFName = null;
	private String varPatGName = null;
	private String varPatCName = null;
	private String varIDNo = null;
	private String varDOB = null;
	private String varSex = null;
	
	private String varSlipNo = null;
	private String varRegDate = null;
	private String varDocCode = null;
	private String varPatType = null;
	private String varCurLocation = null;	
	private String varBedCode = null;
	private String varAcmCode = null;
	private String varLastVisit = null;
	private String varExpiryDate = null;
	private String varDisposed = null;
	private String varFilmInDI = null;
	private String varDisc = null;
	
	private String varSlpHdisc = null;
	private String varSlpDdisc = null;
	private String varSlpSdisc = null;
	
	private Double tmpAmount = 0.0;
	
	private int tmpOamt = 0;
	private int tmpDisc = 0;
	private int tmpNamt = 0;
	
	public final static int IDX_KEY = 0;
	public final static int IDX_SLPNO = 1;
	public final static int IDX_PATTYPE = 2;
	public final static int IDX_DOCCODE = 3;
	public final static int IDX_STNID = 4;
	public final static int IDX_STNDATE = 5;
	public final static int IDX_PKGCODE = 6;
	public final static int IDX_ITMCODE = 7;
	public final static int IDX_EXAMDESC = 8;
	public final static int IDX_DESCRIPTION = 9;
	public final static int IDX_OAMT = 10;
	public final static int IDX_BAMT = 11;
	public final static int IDX_DISCOUNT = 12;
	public final static int IDX_NAMT = 13;
	public final static int IDX_ONAMT = 14;
	public final static int IDX_OBAMT = 15;
	public final static int IDX_REPORTED = 16;
	public final static int IDX_USRID = 17;
	public final static int IDX_GLCODE = 18;
	public final static int IDX_APPTIME = 19;
	public final static int IDX_XAPID = 20;
	public final static int IDX_ROOM = 21;
	public final static int IDX_REMARK = 22;
	public final static int IDX_EXAMDATE = 23;
	public final static int IDX_UNIT = 24;
	public final static int IDX_XAPESTIME = 25;
	public final static int IDX_XRGID = 26;
	public final static int IDX_XAPDATE = 27;
	public final static int IDX_ITMDESC = 28;
	
	public final static int IDX_TOTALNO = 29;
	
	private String Cpsid = "";
	private boolean flagToDi = false;
	
	public DIECGExamReg(BasePanel panelFrom) {
		super();
		// this.panelFrom = panelFrom;
	}

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.ECGEXAMREG_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.ECGEXAMREG_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] { "Key", "Slip No", "Type", "Doc", "Stn ID",
				//
				"Stn Date", "Pkg", "Code", "Exam Name", "Description",
				//
				"O Amt", "B Amt", "Disc %", "N Amt", "ON Amt",
				//
				"OB Amt", "Reported", "USR ID", "GL Code",
				//
				"App. Time", "XAPID", "Room", "Remark", "Exam Date",
				//
				"Unit", "XAPESTIME", "XRGID", "XAPDATE", "itemDesc"

		};
	}

	public TableList getListTable() {
		if (listTable == null) {
			listTable = new TableList(getColumnNames(), getColumnWidths());
		}
		return listTable;
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] { 0, 80, 40, 40, 0,
				//
				0, 50, 60, 180, 180,
				//
				50, 50, 50, 50, 0,
				//
				0, 60, 0, 0,
				//
				60, 0, 50, 80, 80,
				//
				50, 0, 0, 0, 0 };
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private TableList listTable = null;
	
	private BasePanel leftPanel = null;
	
	//ParaPanel
	private BasePanel ParaPanel = null;
	private LabelBase diNoDesc = null;
	private TextString diNo = null;
	private LabelBase jobDateDesc = null;
	private TextString jobDate = null;
	private LabelBase ipDayCaseDesc = null;
	private TextString ip = null;
	private TextString DayCase = null;
	private LabelBase patNoDesc = null;
	private TextPatientNoSearch patNo = null;
	private LabelBase patFamilyNameDesc = null;
	private TextString patFamilyName = null;
	private LabelBase patLocDesc = null;
	private ComboBoxBase patLoc = null;
	private TextString patLocName = null;	
	private LabelBase patHKIDDesc = null;
	private TextString patHKID = null;
	private LabelBase patGivenNameDesc = null;
	private TextString patGivenName = null;	
	private LabelBase patAttDoctorDesc = null;
	private ComboDoctor patAttDoctor = null;	
	private LabelBase dobDesc = null;
	private TextString dob = null;
	private LabelBase patSexAgeDesc = null;
	private TextString patSex = null;
	private TextString patAge = null;
	private ButtonBase allergy = null;
	private LabelBase filmToDesc = null;
	private ComboBoxBase filmTo = null;
	private TextString filmToName = null;
	
	private ButtonBase diHist = null;
	private ButtonBase remove = null;
	
	private LabelBase oriExamDesc = null;
	private TextReadOnly oriExam = null;
	private LabelBase oriExamTotalDesc = null;
	private TextReadOnly oriExamTotal = null;
	private LabelBase curExamDesc = null;
	private TextReadOnly curExam = null;
	private LabelBase curExamTotalDesc = null;
	private TextReadOnly curExamTotal = null;
	
	// panel 2
	private BasePanel ParaPanel2 = null;
	private LabelBase examPkgCodeDesc = null;
	private TextItemCodeSearch examPkgCode = null;
	private LabelBase unitCodeDesc = null;
	private TextString unitCode = null;
	private LabelBase stanRateDesc = null;
	private CheckBoxBase stanRate = null;
	
	// status panel
	private BasePanel StatusPanel = null;
	private LabelBase examCountDesc = null;
	private TextReadOnly examCount = null;
	private LabelBase reportedCountDesc = null;
	private TextReadOnly reportedCount = null;
	private LabelBase incompletedCountDesc = null;
	private TextReadOnly incompletedCount = null;
	private LabelBase lendDesc = null;
	private TextReadOnly lendCount = null;
	private LabelBase printedCountDesc = null;
	private TextReadOnly printedCount = null;

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */

	private BasePanel rightPanel = null;
	
	/**
	 * This method initializes test
	 * 
	 */
	public DIECGExamReg() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		setLeftAlignPanel();
		getJScrollPane().setBounds(10, 190, 900, 440);
		getClearButton().setEnabled(true);
		getDILoc();
		return true;
	}

	private void setInitValue() {
		getDILoc();
		enableEditFiled("");
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		clearPatient();
		// getPatNo().requestFocus();
		setInitValue();
		enableButton();
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public Component getDefaultFocusComponent() {
		return getPatNo();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {
		getSearchButton().setEnabled(true);
		getSaveButton().setEnabled(false);
		getCancelButton().setEnabled(false);
		// getUpperTable().removeAllRow();
	}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {

		if (getListTable().getRowCount() > 0) {
			getSaveButton().setEnabled(true);
		} else {
			getSaveButton().setEnabled(false);
		}

		// getSaveButton().setEnabled(true);
		getCancelButton().setEnabled(true);
		getClearButton().setEnabled(false);
	}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
	}

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
		String[] inParm = new String[] { 
				getPatNo().getText(), 
				getDINo().getText(), 
				getExamPkgCode().getText()
		};
		return inParm;
	}

	/* >>> ~16~ Set Fetch Input Parameters ================================ <<< */
	@Override
	protected String[] getFetchInputParameters() {
		String[] selectedContent = getListSelectedRow();
		return new String[] { selectedContent[0] };
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {
	}

	/* >>> ~15~ Set Fetch Output Results ============================== <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {
	}

	/* >>> ~16.1~ Set Action Output Parameters =========================== <<< */
	@Override
	protected void getNewOutputValue(String returnValue) {
	}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return new String[] {};
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {
		if (getSaveButton().isEnabled() && getListTable().getRowCount() > 0) {
			getSaveButton().setEnabled(false);
			getMainFrame().setLoading(true);

			boolean validate = true;
			String[] s = null;
			int iChgAmt = 0;
			double iDiscount = 0;

			for (int i = 0; validate && i < getListTable().getRowCount(); i++) {
				s = getUpdatedContent(i);
				iChgAmt = 0;
				try {
					iChgAmt = Integer.parseInt( s[IDX_NAMT] );
				} catch ( Exception e) {
					getListTable().setSelectRow(i);
					validate = false;
				}

				iDiscount = 0.0;
				try {
					iDiscount = Double.parseDouble(s[IDX_DISCOUNT]);
				} catch ( Exception e) {
					addErrorMessage(MSG_NUMERIC_DISCOUNT);
					getListTable().setSelectRow(i);
					validate = false;
				}
				if (iDiscount < 0) {
					addErrorMessage(MSG_NUMERIC_DISCOUNT);
					getListTable().setSelectRow(i);
					validate = false;
				} else if (iDiscount > 100) {
					addErrorMessage(MSG_NUMERIC_DISCOUNTOFF);
					getListTable().setSelectRow(i);
					validate = false;
				}
			}

			if (validate) {
				String rowTransDate = getJobDate().getText().substring(0, 10);
				bCheckGridTransDate(rowTransDate, 0);
			} else {
				actionValidationReady(actionType, false);
			}
		}

		//actionValidationReady(actionType, true);
	}
	
	private void bCheckGridTransDate(final String transDate, final int index) {
		String currentdate = getMainFrame().getServerDateTime();
		if (DateTimeUtil.compareTo(transDate, currentdate.substring(0, 10)) > 0) {
			Factory.getInstance().isConfirmYesNoDialog("PBA-["+getTitle()+"]","The Transaction Date is greater than today. Do you want to proceed?", new Listener<MessageBoxEvent>() {
				@Override
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						String rowDocCode = varDocCode;
						bCheckGridDoctor(rowDocCode, 0);
					} else {
						getListTable().focus();
						getListTable().setSelectRow(index);
						actionValidationReady(null, false);
					}
				}
			});
		} else {
			String rowDocCode = varDocCode;
			bCheckGridDoctor(rowDocCode, 0);
		}
	}
	
	private void bCheckGridDoctor(final String docCode, final int index) {
		final int totalRow = 1;
		QueryUtil.executeMasterFetch(
				getUserInfo(),
				ConstantsTx.DOCTOR_ACTIVE_TXCODE,
				new String[] { docCode },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					if (index + 1 < totalRow) {
						if (mQueue.getContentField()[0] != null && mQueue.getContentField()[0].length() > 0) {
							String rowDocCode = getListTable().getValueAt(index + 1, IDX_DOCCODE);
							bCheckGridDoctor(rowDocCode, index + 1);
						} else {
							QueryUtil.executeMasterFetch(
									getUserInfo(),
									ConstantsTx.DOCTOR_TXCODE,
									new String[] { docCode },
									new MessageQueueCallBack() {
								@Override
								public void onPostSuccess(MessageQueue mQueue) {
									String sMsg = "Inactive Doctor. Doctor Code: " + mQueue.getContentField()[0] + "; Row" + (index + 1);
									if (mQueue.success()) {
										sMsg += "<br/>Admission Expiry Date: " + mQueue.getContentField()[21];
									} else {
										sMsg += "<br/>Cannot get Admission Expiry Date";
									}

									getListTable().setSelectRow(index);
									Factory.getInstance().addErrorMessage(sMsg, "PBA-[" + getTitle() + "]");
									actionValidationReady(null, false);
									getListTable().focus();
									getListTable().setSelectRow(index);
								}
							});
						}
					} else {
						actionValidationReady(null, true);
					}
				} else {
					QueryUtil.executeMasterFetch(getUserInfo(), "DOCTOR",
							new String[] {
								docCode
							},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							String sMsg = "Inactive Doctor. Doctor Code: " + mQueue.getContentField()[0] + "; Row" + (index + 1);
							if (mQueue.success()) {
								sMsg += "<br/>Admission Expiry Date: " + mQueue.getContentField()[21];
							} else {
								sMsg += "<br/>Cannot get Admission Expiry Date";
							}

							getListTable().setSelectRow(index);
							Factory.getInstance().addErrorMessage(sMsg, "PBA-[" + getTitle() + "]");
							actionValidationReady(null, false);
							getListTable().focus();
							getListTable().setSelectRow(index);
						}
					});
				}
			}
		});
	}
	
	@Override
	protected void actionValidationReady(final String actionType, boolean isValidationReady) {
		if (isValidationReady) {
			// PostTransaction
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] {"Slip, Arcode", "Cpsid", "Slip.Arccode = Arcode.Arccode AND Slip.Slpno ='" + varSlipNo + "'"},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					Cpsid = "";
					flagToDi = false;

					if (mQueue.success()) {
						Cpsid = mQueue.getContentField()[0];
					}

					// preAddEntry
					getAddEntryTable().removeAllRow();
					preAddEntryAddModeR(0, getListTable().getRowCount());
				}

				public void onComplete() {
					super.onComplete();
					getMainFrame().setLoading(false);
				}
			});
		} else {
			getSaveButton().setEnabled(true);
			getMainFrame().setLoading(false);
		}
	}
	
	private void preAddEntryAddModeR(final int idx, final int total) {
		if (idx >= total) {
			// exit
			addEntrySTAction();
		} else {
			final String[] s = getUpdatedContent(idx);

			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] {"item", "Itmcode", "itmcat = '" + ConstantsTransaction.ITEM_CATEGORY_DEPOSIT+ "' and itmcode ='" + s[IDX_ITMCODE] + "'"},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					String tempResult="";
					String RtnRefID="";
					String tmpAcmCode = null;

					if (mQueue.success()) {
						tempResult = mQueue.getContentField()[0];
					}

					if (s[IDX_ITMCODE].equals(tempResult)) {
						try {
							AddDeposit(s, varSlipNo, getMainFrame().getServerDateTime(),
									idx, total);
						} catch (Exception e) {
							postSaveAddEntryTable(false, null, "<html>Add Deposit Item Failed<br>Transaction cancelled</html>");
						}
					} else {
						if("MOD".equals(getActionType()) && !s[IDX_SLPNO].isEmpty()){
						}else{
							getAddEntryTable().addRow(new String[]{
									varSlipNo,
									s[IDX_ITMCODE],
									"",//s[IDX_ITMTYPE],
									ConstantsTransaction.SLIPTX_TYPE_DEBIT,
									s[IDX_OAMT],
									s[IDX_BAMT],
									varDocCode,//s[IDX_DOCCODE],
									"",//s[IDX_ITMLVL],
									varAcmCode,
									s[IDX_DISCOUNT],
									s[IDX_PKGCODE],
									getMainFrame().getServerDateTime(),
									getJobDate().getText(),
									s[IDX_EXAMDESC],
									"",
									"",
									RtnRefID,
									ZERO_VALUE, // false
									varBedCode,
									"",
									ZERO_VALUE,	// flagtoDi=true
									"",//s[IDX_CPS],
									Cpsid,
									s[IDX_UNIT],
									s[IDX_ITMDESC],
									s[IDX_STNID]//"" = s[IDX_IREF] --> change to pass stnid if stnid is not null
							});
						}
						preAddEntryAddModeR(idx + 1, total);
					}
				}
			});
		}
	}
	
	public void AddDeposit(final String[] s, String SlipNo, String capturedate,
			final int idx, final int total) {
		String txCode = "ADDDEPOSIT";
		String[] para = new String[] {s[IDX_NAMT], SlipNo, s[IDX_ITMCODE], capturedate, getJobDate().getText().substring(0, 10)};

		QueryUtil.executeMasterAction(getUserInfo(), txCode, QueryUtil.ACTION_APPEND, para,
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					AddDepositReady(mQueue.getReturnCode(), s, idx, total);
				} else {
					AddDepositReady("-1", s, idx, total);
				}
			}
		});
	}

	public void AddDepositReady(String deposit, String[] s, int idx, int total) {
		if ("-1".equals(deposit)) {
			postSaveAddEntryTable(false, null, "<html>Add Deposit Item Failed<br>Transaction cancelled</html>");
		} else {
			String RtnRefID = deposit;
			String tmpAcmCode = null;
			if("MOD".equals(getActionType()) && !s[IDX_SLPNO].isEmpty()){
			}else{
				// add to saveTable
				getAddEntryTable().addRow(new String[]{
						varSlipNo,
						s[IDX_ITMCODE],
						"",//s[IDX_ITMTYPE],
						ConstantsTransaction.SLIPTX_TYPE_DEPOSIT_O,
						s[IDX_OAMT],
						s[IDX_BAMT],
						varDocCode,//s[IDX_DOCCODE],
						"",//s[IDX_ITMLVL],
						varAcmCode,
						s[IDX_DISCOUNT],
						s[IDX_PKGCODE],
						getMainFrame().getServerDateTime(),
						getJobDate().getText(),
						s[IDX_EXAMDESC],
						"",
						"",
						RtnRefID,
						ZERO_VALUE, // false
						varBedCode,
						"",
						ZERO_VALUE,	// flagtoDi=true
						"",//s[IDX_CPS],
						Cpsid,
						s[IDX_UNIT],
						s[IDX_ITMDESC],
						s[IDX_STNID]//"" = s[IDX_IREF] --> change to pass stnid if stnid is not null
				});
			}
			preAddEntryAddModeR(idx + 1, total);
		}
	}
	
	private void addEntrySTAction() {
		if ("N".equals(Factory.getInstance().getSysParameter("SAVECRG"))) {
			Factory.getInstance().addInformationMessage(
					"[Debug mode] ADDENTRYST No. of row to be saved: " +
					getAddEntryTable().getRowCount() + " (remove sysparam SAVECRG to exit debug mode)");
		} else if (getAddEntryTable().getRowCount() > 0) {
			// save > postSaveAddEntryTable
			getAddEntryTable().saveTable(
					"ECGEXAMREGST",
					new String[]{
						getUserInfo().getUserID(),
						getDINo().getText().trim(),
						varPatNo,
						varPatType,
						getFilmTo().getText().trim(),
						getFilmToName().getText().trim()
						},
					false,
					false,
					true,
					false,
					true,
					"DI exam");
		}
	}

	@Override
	protected void postSaveAddEntryTable(boolean success, Integer rtnCode,
			String rtnMsg) {
		if (success) {
			getDINo().setText(rtnMsg);
			enableButton();
			getAppendButton().setEnabled(false);
			getSaveButton().setEnabled(false);
		}
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	protected String[] getUpdatedContent(int rowIndex) {
		String[] row = new String[IDX_TOTALNO];
		getListTable().getView().ensureVisible(rowIndex, 0, true);
		for (int i = 0; i < IDX_TOTALNO; i++) {
			row[i] = getListTable().getValueAt( rowIndex, i ) ;
		}
		return row;
	}
	
	protected void showDiHistPanel() {
		setParameter("PatNo", getPatNo().getText());
		showPanel(new DIECGExamReport());// change to "DI Exam Report History"
	}

	private void getDILoc() {
		QueryUtil.executeMasterBrowse(getUserInfo(), "DIINFO", 
				new String[] { "DILOC","5" }, 
				new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						getPatLoc().removeAllItems();
						getFilmTo().removeAllItems();
						List<String[]> results = mQueue.getContentAsArray();
						for (String[] r : results) {
							if ("P".equals(r[0])) {
								filmTo.addItem(r[0], r[1]);
							} else {
								patLoc.addItem(r[0], r[1]);
								filmTo.addItem(r[0], r[1]);
							}
						}
					} else {
						getPatLoc().removeAllItems();
						getFilmTo().removeAllItems();
					}
				}
		});
	}

	private void getPatInfo(final String patNo, final String diNo) {
		varPatNo = patNo;
		// Set patient info
		QueryUtil.executeMasterFetch(getUserInfo(), "ECGGETPATINFO", new String[] { patNo, diNo },
				new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							if("".equals(patNo) || patNo.isEmpty()){
								varPatNo = mQueue.getContentField()[0];
								getPatNo().setText(varPatNo);
							}
							varPatFName = mQueue.getContentField()[1];
							varPatGName = mQueue.getContentField()[2];
							varPatCName = mQueue.getContentField()[6];
							varIDNo = mQueue.getContentField()[3];
							varDOB = mQueue.getContentField()[4];
							varSex = mQueue.getContentField()[5];
							
							varSlipNo = mQueue.getContentField()[7];
							varRegDate = mQueue.getContentField()[8];
							varDocCode = mQueue.getContentField()[9];
							varPatType = mQueue.getContentField()[10];
							varCurLocation = mQueue.getContentField()[10];
							varBedCode = mQueue.getContentField()[11];
							varAcmCode = mQueue.getContentField()[12];
							varJobNo = mQueue.getContentField()[13];
							varLastVisit = mQueue.getContentField()[14];
							varExpiryDate = mQueue.getContentField()[15];
							varDisposed = mQueue.getContentField()[16];
							varFilmInDI = mQueue.getContentField()[17];
							
							getPatFamilyName().setText(varPatFName);
							getPatGivenName().setText(varPatGName);
							getPatHKID().setText(varIDNo);
							getPatSex().setText(varSex);
							getDob().setText(varDOB);
							int currentYear = (new Integer(DateTimeFormat.getFormat("yyyyMMdd").format(new Date()))).intValue();
							int dobYear = Integer.parseInt(varDOB.substring(6));
							int dobMonth = Integer.parseInt(varDOB.substring(3, 5));
							int dobDay = Integer.parseInt(varDOB.substring(0, 2));
							int birthYear = dobYear * 10000 + dobMonth * 100 + dobDay;
							int age = (int) (currentYear - birthYear) / 10000;
							getPatAge().setText(Integer.toString(age));
							getIp().setText(varSlipNo);
							getDayCase().setText(varBedCode);
							getPatAttDoctor().setText(varDocCode);

							//currentPatType = varPatType;
							getPatLoc().setText(varCurLocation);
							getFilmTo().setText(varCurLocation);
							getPatLocName().setText(varBedCode);
							getFilmToName().setText(varBedCode);
							getJobDate().setText(mQueue.getContentField()[20]);
						}
					}
				});
	}

	public static String left(String s, int len) {
		return s.substring(0, Math.min(len, s.length()));
	}

	// END -- VB DI_Module Function

	// VB -- Form Function
	private void clearPatient() {
		getDINo().setText("");
		getPatNo().setText("");
		getPatFamilyName().setText("");
		getPatGivenName().setText("");
		getPatHKID().setText("");
		getPatSex().setText("");
		getDob().setText("");
		getPatAge().setText("");

		getExamPkgCode().setText("");
		getStanRate().setSelected(true);

		getFilmTo().setText("");
		getPatLocName().setText("");
		getFilmToName().setText("");

		getIp().setText("");
		getDayCase().setText("");
		getPatLoc().removeAllItems();
		getFilmTo().removeAllItems();
	}

	private void refreshScreen() {
		String tempslpNo = "";
		String ONAmt = "";
		Integer OrigNo = 0;
		Integer OrigTotal = 0;
		Integer NewNo = 0;
		Integer NewTotal = 0;

		for (int i = 0; i < getListTable().getRowCount(); i++) {
			tempslpNo = getListTable().getRowContent(i)[1];
			
			if (!"".equals(tempslpNo) && (tempslpNo != null)) {
				OrigNo = OrigNo + 1;
				OrigTotal = OrigTotal + Integer.parseInt(getListTable().getRowContent(i)[IDX_ONAMT]);
			}
			ONAmt = getListTable().getRowContent(i)[IDX_ONAMT];
			if (!"".equals(ONAmt) && (ONAmt != null)) {
				NewNo = NewNo + 1;
			}
			NewTotal = NewTotal + Integer.parseInt(getListTable().getRowContent(i)[IDX_ONAMT]);
		}
		getOriExam().setText((OrigNo.toString()));
		getOriExamTotal().setText(OrigTotal.toString());
		getCurExam().setText(NewNo.toString());
		getCurExamTotal().setText(NewTotal.toString());

		getExamPkgCode().requestFocus();
	}

	private void enableEditFiled(String mode) {
		// setEditableForever
		getIp().setEditableForever(false);
		getDayCase().setEditableForever(false);
		getPatFamilyName().setEditableForever(false);
		getPatLocName().setEditableForever(false);
		getPatHKID().setEditableForever(false);
		getPatGivenName().setEditableForever(false);
		getDob().setEditableForever(false);
		getPatSex().setEditableForever(false);
		getPatAge().setEditableForever(false);
		getFilmToName().setEditableForever(false);
		getExamPkgCode().setEditable(false);
		getJobDate().setEditableForever(false);

		if ("SearchMode".equals(mode)) {
			getJobDate().setEnabled(false);
			getExamPkgCode().setEnabled(false);
			getExamPkgCode().isFocusOwner();
		} else if ("append".equals(mode)||"update".equals(mode)) {
			getJobDate().setEnabled(false);
			getExamPkgCode().setEnabled(true);
			getDINo().setEnabled(false);
			getPatNo().setEnabled(false);
		} else {
			getDINo().setEnabled(true);
			getPatNo().setEnabled(true);
		}

	}
	
	private boolean checkfield(){
		if(getPatLoc().isEmpty() || getPatAttDoctor().isEmpty() || getFilmTo().isEmpty()){
			return false;
		}else{
			if(varPatType == "R"/* && getErdCode().getText() != ""*/){
				return false;
			}else{
				return true;
			}
		}
	}
	// END VB -- Form Function
	
	private void appendItemPkg(final String itmCode, final String acmCode, String unit, String iRefNo,
			final CallbackListener afterAppendListener) {
		//getAppendButton().setEnabled(false);
		getMainFrame().setLoading(true);
		// set default value for unit
		if (unit == null || unit.length() == 0) {
			unit = ConstantsVariable.ONE_VALUE;
		} 
		
		QueryUtil.executeMasterFetch(getUserInfo(), "ItemChg",
			new String[] {
				"ADD",//memTransactionMode,
				varSlipNo,//memtempslpNo
				varPatType,
				getJobDate().getText().substring(0, 10),//getTransactionDate().getText(),
				itmCode.toUpperCase(),
				varDocCode, //getDocCode().getText(),
				varAcmCode, //varAcmCode
				unit,
				varSlpHdisc, //memSlpHDisc,
				varSlpDdisc, //memSlpDDisc,
				varSlpSdisc, //memSlpSDisc,
				getStanRate().isSelected()?MINUS_ONE_VALUE:ZERO_VALUE,
				getUserInfo().getUserID(),
				NO_VALUE, //bAmount
				tmpAmount.toString(),
				iRefNo
			},
			new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						
						tmpOamt = Integer.parseInt(mQueue.getContentField()[3]);
						tmpDisc = Integer.parseInt(mQueue.getContentField()[5]);
						tmpNamt = tmpOamt*(100-tmpDisc)/100;
						
						String row[] = new String[] { 
								null, //key
								null, //slipNo
								null, //type
								null, //doc
								null, //stnid
								null, //stndate
								null,  //pkgcode
								mQueue.getContentField()[1], //itmcode
								mQueue.getContentField()[9], //Stndesc
								mQueue.getContentField()[14], //Stndesc1
								mQueue.getContentField()[3], //o amt
								mQueue.getContentField()[4], //b amt
								mQueue.getContentField()[5], //disc
								Integer.toString(tmpNamt),//mQueue.getContentField()[4], //n amt
								Integer.toString(tmpNamt), //on amt
								mQueue.getContentField()[4], //ob amt
								null, //reported
								null, //usrid
								null, //glcode
								null, //apptime
								null, //xapid
								null, //room
								null, //remark
								null, //examdate
								mQueue.getContentField()[13], //unit
								null, //xapestime
								null, //xrgid
								null, //xapdate
								null //itemdesc
								 };
						getListTable().addRow(row);
						getListTable().setSelectRow(getListTable().getRowCount() - 1);						
						
						// check pkg alert
						QueryUtil.executeMasterFetch(getUserInfo(), "PackageAlert",
							new String[] {
								"ADD",
								itmCode.toUpperCase()
							},
							new MessageQueueCallBack() {
								@Override
								public void onPostSuccess(MessageQueue mQueue) {
									if (mQueue.success()) {
										String packageAlert = mQueue.getContentField()[0];
										if (packageAlert != null && packageAlert.length() > 0) {
											addErrorMessage(packageAlert, getExamPkgCode());
										}
									}
								}
							}
						);

						appendItemPkgReady(true, afterAppendListener);
					} else {
						appendItemPkgReady(false, afterAppendListener);
					}
				}
			}
		);
	}
	
	private void appendItemPkgReady(boolean ready, CallbackListener afterAppendListener) {
		refreshScreen();
		enableButton();
		defaultFocus();
		getMainFrame().setLoading(false);
	}
	
	private boolean isSingleSlip(){
		boolean singleSlip = true;
		for (int i = 1; i < getListTable().getRowCount(); i++) {
			if (!getListTable().getRowContent(i)[1].equals(getListTable().getRowContent(i-1)[1]) && !getListTable().getRowContent(i)[1].isEmpty()) {
				singleSlip = false;
			}
		}
		return singleSlip;
	}
	
	private void getSlipInfo(String slipNo) {
		QueryUtil.executeMasterFetch(getUserInfo(), "ECGGETSLIPINFO", new String[] { slipNo },
				new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							varSlipNo = mQueue.getContentField()[0];
							varPatNo = mQueue.getContentField()[1];
							varPatType = mQueue.getContentField()[2];
							varDocCode = mQueue.getContentField()[3];
							varAcmCode = mQueue.getContentField()[4];
							varSlpHdisc = mQueue.getContentField()[5];
							varSlpDdisc = mQueue.getContentField()[6];
							varSlpSdisc = mQueue.getContentField()[7];
							varBedCode = mQueue.getContentField()[8];
						}
					}
				});
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected void enableButton(String mode) {
		// disable all button
		disableButton();
		getSearchButton().setEnabled(true);
		getAppendButton().setEnabled(getDINo().isEmpty());
		getModifyButton().setEnabled(!getDINo().isEmpty());
		getSaveButton().setEnabled( !getJobDate().isEmpty() && getListTable().getRowCount() > 0);
		getClearButton().setEnabled(true);
		getExamCount().setText(Integer.toString(getListTable().getRowCount()));
		getDiHist().setEnabled(true);
		getRemove().setEnabled(getDINo().isEmpty());
		if("MOD".equals(getActionType())){
			getModifyButton().setEnabled(false);
			getAppendButton().setEnabled(true);
			getRemove().setEnabled(false);
		}
		
		refreshScreen();
	}

	@Override 
	public void clearAction(){
		if(varSlipNo.length()>0 || !"".equals(varSlipNo)){
			unlockRecord("Slip", varSlipNo);
		}
		super.clearAction();
	}
	
	@Override
	protected void clearPostAction() {
		super.clearPostAction();
		setInitValue();
		clearPatient();
		enableButton();
	}
	 

	@Override
	protected void searchPostAction() {
		if ((!"".equals(getPatNo().getText().trim()) || !"".equals(getDINo().getText().trim()))
				&& "".equals(getExamPkgCode().getText().trim())) {
			if (getPatNo().isMergePatientNo()) { 
				return;
			}
			// Fill patient information
			getPatInfo(getPatNo().getText().trim(), getDINo().getText().trim());
		}
		enableEditFiled(SEARCH_MODE);
	}

	@Override
	public void appendAction() {
		getMainFrame().setLoading(true);
		
		if("".equals(getIp().getText().trim()) && getListTable().getRowCount() == 0){
			Factory.getInstance().addSystemMessage("1.Patient is not current IP/Daycase, or \n 2.Slip has not been paid.");
			getMainFrame().setLoading(false);
			return;
		} else if (!isSingleSlip() && !"MOD".equals(getActionType())){
			Factory.getInstance().addSystemMessage("Job contain more than one Slip, \n Please remove the exam which are unrelated.");
			getMainFrame().setLoading(false);
			return;
		}else{ 
			if(getListTable().getRowCount() > 0 && !"".equals(getListTable().getSelectedRowContent()[1].trim())){
				getPatLoc().setText(getListTable().getSelectedRowContent()[2].trim()); 
				getFilmTo().setText(getListTable().getSelectedRowContent()[2].trim()); 
				getPatAttDoctor().setText(getListTable().getSelectedRowContent()[3].trim());
				varSlipNo = getListTable().getSelectedRowContent()[1].trim();
			}else{
				varSlipNo = getIp().getText().trim();
			}
			getSlipInfo(varSlipNo);

		}

		if (!getExamPkgCode().isEmpty()) {
			appendItemPkg(getExamPkgCode().getText().trim(),
					varAcmCode,
					getUnitCode().getText().trim(), null, null);
			getExamPkgCode().resetText();
			getUnitCode().resetText();
		}
		 appendPostAction();
	}

	@Override
	public void appendPostAction(){
		if(getJobDate().isEmpty()){
			getJobDate().setText(getMainFrame().getServerDateTime());
			
		}
		enableEditFiled("append");
		enableButton("append");
		getMainFrame().setLoading(false);
	}

	@Override
	public void modifyPostAction(){
		if(getListTable().getRowCount() > 0 && !"".equals(getListTable().getSelectedRowContent()[1].trim())){
			getPatLoc().setText(getListTable().getSelectedRowContent()[2].trim()); 
			getFilmTo().setText(getListTable().getSelectedRowContent()[2].trim()); 
			getPatAttDoctor().setText(getListTable().getSelectedRowContent()[3].trim());
			varSlipNo = getListTable().getSelectedRowContent()[1].trim();
		}else{
			varSlipNo = getIp().getText().trim();
		}
		getSlipInfo(varSlipNo);
		enableButton("update");
		enableEditFiled("update");
	}
	
	@Override
	protected void cancelYesAction() {
		// super.cancelYesAction();
		if(varSlipNo.length()>0 || !"".equals(varSlipNo)){
			unlockRecord("Slip", varSlipNo);
		}
		searchAction();

		getJobDate().setText("");
		getPatLoc().setText("");
		getFilmTo().setText("");
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/
	@Override
	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.add(getParaPanel());
			leftPanel.add(getParaPanel2());
			leftPanel.add(getJScrollPane());
		}
		return leftPanel;
	}

	protected BasePanel getRightPanel() {

		if (rightPanel == null) {
			rightPanel = new BasePanel();
		}
		return rightPanel;
	}

	public BasePanel getStatusPanel() {
		if (StatusPanel == null) {
			StatusPanel = new BasePanel();
			StatusPanel.setBounds(10, 680, 900, 70);
			StatusPanel.setBorders(true);
			StatusPanel.add(getExamCountDesc(), null);
			StatusPanel.add(getExamCount(), null);
			StatusPanel.add(getReportedCountDesc(), null);
			StatusPanel.add(getReportedCount(), null);
			StatusPanel.add(getIncompletedCountDesc(), null);
			StatusPanel.add(getIncompletedCount(), null);
			StatusPanel.add(getLendCountDesc(), null);
			StatusPanel.add(getLendCount(), null);
			StatusPanel.add(getPrintedCountDesc(), null);
			StatusPanel.add(getPrintedCount(), null);
		}
		return StatusPanel;
	}

	public BasePanel getParaPanel2() {
		if (ParaPanel2 == null) {
			ParaPanel2 = new BasePanel();
			ParaPanel2.setBounds(10, 140, 900, 35);
			ParaPanel2.setBorders(true);
			ParaPanel2.setHeading("Exam Details");
			ParaPanel2.add(getExamPkgCodeDesc(), null);
			ParaPanel2.add(getExamPkgCode(), null);
			ParaPanel2.add(getUnitCodeDesc(), null);
			ParaPanel2.add(getUnitCode(), null);
			ParaPanel2.add(getStanRateDesc(), null);
			ParaPanel2.add(getStanRate(), null);
		}
		return ParaPanel2;
	}

	public BasePanel getParaPanel() {
		if (ParaPanel == null) {
			ParaPanel = new BasePanel();
			ParaPanel.setBounds(10, 10, 900, 120);
			ParaPanel.setBorders(true);
			ParaPanel.add(getDIDesc(), null);
			ParaPanel.add(getDINo(), null);
			ParaPanel.add(getJobDateDesc(), null);
			ParaPanel.add(getJobDate(), null);
			ParaPanel.add(getIpDayCaseDesc(), null);
			ParaPanel.add(getIp(), null);
			ParaPanel.add(getDayCase(), null);
			ParaPanel.add(getpatNoDesc(), null);
			ParaPanel.add(getPatNo(), null);
			ParaPanel.add(getPatFamilyNameDesc(), null);
			ParaPanel.add(getPatFamilyName(), null);
			ParaPanel.add(getPatLocDesc(), null);
			ParaPanel.add(getPatLoc(), null);
			ParaPanel.add(getPatLocName(), null);
			ParaPanel.add(getPatHKIDDesc(), null);
			ParaPanel.add(getPatHKID(), null);
			ParaPanel.add(getPatGivenNameDesc(), null);
			ParaPanel.add(getPatGivenName(), null);
			ParaPanel.add(getPatSexAgeDesc(), null);
			ParaPanel.add(getPatSex(), null);
			ParaPanel.add(getPatAge(), null);
			ParaPanel.add(getAllergy(), null);
			ParaPanel.add(getFilmToDesc(), null);
			ParaPanel.add(getFilmTo(), null);
			ParaPanel.add(getFilmToName(), null);
			ParaPanel.add(getPatAttDoctorDesc(), null);
			ParaPanel.add(getPatAttDoctor(), null);
			ParaPanel.add(getDobDesc(), null);
			ParaPanel.add(getDob(), null);
			ParaPanel.setHeading("Criteria");
			ParaPanel.setTitle("Criteria");
			ParaPanel.add(getDiHist(), null);
			ParaPanel.add(getRemove(), null);
			ParaPanel.add(getOriExamDesc(), null);
			ParaPanel.add(getOriExam(), null);
			ParaPanel.add(getCurExamDesc(), null);
			ParaPanel.add(getCurExam(), null);
			ParaPanel.add(getCurExamDesc(), null);
			ParaPanel.add(getOriExamTotalDesc(), null);
			ParaPanel.add(getOriExamTotal(), null);
			ParaPanel.add(getCurExamTotalDesc(), null);
			ParaPanel.add(getCurExamTotal(), null);
		}
		return ParaPanel;
	}

	private LabelBase getpatNoDesc() {
		if (patNoDesc == null) {
			patNoDesc = new LabelBase();
			patNoDesc.setText("Patient No");
			patNoDesc.setBounds(5, 35, 95, 20);
		}
		return patNoDesc;
	}

	private TextPatientNoSearch getPatNo() {
		if (patNo == null) {
			patNo = new TextPatientNoSearch(true, true) {

				@Override
				public void onFocus() {
				};

				@Override
				public void onBlur() {
					super.onBlur();
				}

				@Override
				public void onBlurPost() {
					searchAction(true);
				}
			};
			patNo.setBounds(85, 35, 125, 20);
		}
		return patNo;
	}

	private LabelBase getDIDesc() {
		if (diNoDesc == null) {
			diNoDesc = new LabelBase();
			diNoDesc.setText("DI No");
			diNoDesc.setBounds(5, 10, 95, 20);
		}
		return diNoDesc;
	}

	private TextString getDINo() {
		if (diNo == null) {
			diNo = new TextString(81);
			diNo.setBounds(85, 10, 125, 20);
		}
		return diNo;
	}

	private LabelBase getJobDateDesc() {
		if (jobDateDesc == null) {
			jobDateDesc = new LabelBase();
			jobDateDesc.setText("Job Date");
			jobDateDesc.setBounds(225, 10, 95, 20);
		}
		return jobDateDesc;
	}

	private TextString getJobDate() {
		if (jobDate == null) {
			jobDate = new TextString(81);
			jobDate.setBounds(335, 10, 180, 20);
			jobDate.setEditable(false);
		}
		return jobDate;
	}

	private LabelBase getIpDayCaseDesc() {
		if (ipDayCaseDesc == null) {
			ipDayCaseDesc = new LabelBase();
			ipDayCaseDesc.setText("IP / Daycase Slip");
			ipDayCaseDesc.setBounds(540, 10, 105, 20);
		}
		return ipDayCaseDesc;
	}

	private TextString getIp() {
		if (ip == null) {
			ip = new TextString(81);
			ip.setBounds(660, 10, 95, 20);
			ip.setEditable(false);
		}
		return ip;
	}

	private TextString getDayCase() {
		if (DayCase == null) {
			DayCase = new TextString(81);
			DayCase.setBounds(760, 10, 95, 20);
			DayCase.setEditable(false);
		}
		return DayCase;
	}

	private LabelBase getPatFamilyNameDesc() {
		if (patFamilyNameDesc == null) {
			patFamilyNameDesc = new LabelBase();
			patFamilyNameDesc.setText("Family Name");
			patFamilyNameDesc.setBounds(225, 35, 95, 20);
		}
		return patFamilyNameDesc;
	}

	private TextString getPatFamilyName() {
		if (patFamilyName == null) {
			patFamilyName = new TextString(81);
			patFamilyName.setBounds(335, 35, 180, 20);
			patFamilyName.setEditable(false);
		}
		return patFamilyName;
	}

	private LabelBase getPatLocDesc() {
		if (patLocDesc == null) {
			patLocDesc = new LabelBase();
			patLocDesc.setText("Patient Location");
			patLocDesc.setBounds(540, 35, 105, 20);
		}
		return patLocDesc;
	}

	private ComboBoxBase getPatLoc() {
		if (patLoc == null) {
			patLoc = new ComboBoxBase(true);
			patLoc.setBounds(660, 35, 95, 20);
		}
		return patLoc;
	}

	private TextString getPatLocName() {
		if (patLocName == null) {
			patLocName = new TextString(81);
			patLocName.setBounds(760, 35, 95, 20);
			patLocName.setEditable(false);
		}
		return patLocName;
	}

	private LabelBase getPatHKIDDesc() {
		if (patHKIDDesc == null) {
			patHKIDDesc = new LabelBase();
			patHKIDDesc.setText("HKID");
			patHKIDDesc.setBounds(5, 60, 95, 20);
		}
		return patHKIDDesc;
	}

	private TextString getPatHKID() {
		if (patHKID == null) {
			patHKID = new TextString(81);
			patHKID.setBounds(85, 60, 125, 20);
			patHKID.setEditable(false);
		}
		return patHKID;
	}

	private LabelBase getPatGivenNameDesc() {
		if (patGivenNameDesc == null) {
			patGivenNameDesc = new LabelBase();
			patGivenNameDesc.setText("Given Name");
			patGivenNameDesc.setBounds(225, 60, 95, 20);
		}
		return patGivenNameDesc;
	}

	private TextString getPatGivenName() {
		if (patGivenName == null) {
			patGivenName = new TextString(81);
			patGivenName.setBounds(335, 60, 180, 20);
			patGivenName.setEditable(false);
		}
		return patGivenName;
	}

	private LabelBase getPatAttDoctorDesc() {
		if (patAttDoctorDesc == null) {
			patAttDoctorDesc = new LabelBase();
			patAttDoctorDesc.setText("Att. Doctor");
			patAttDoctorDesc.setBounds(540, 60, 105, 20);
		}
		return patAttDoctorDesc;
	}

	private ComboDoctor getPatAttDoctor() {
		if (patAttDoctor == null) {
			patAttDoctor = new ComboDoctor(true, "ECGOpenQueue", false);
			patAttDoctor.setBounds(660, 60, 200, 20);
		}
		return patAttDoctor;
	}

	private LabelBase getDobDesc() {
		if (dobDesc == null) {
			dobDesc = new LabelBase();
			dobDesc.setText("D.O.B");
			dobDesc.setBounds(5, 85, 95, 20);
		}
		return dobDesc;
	}

	private TextString getDob() {
		if (dob == null) {
			dob = new TextString(81);
			dob.setBounds(85, 85, 125, 20);
			dob.setEditable(false);
		}
		return dob;
	}

	private LabelBase getPatSexAgeDesc() {
		if (patSexAgeDesc == null) {
			patSexAgeDesc = new LabelBase();
			patSexAgeDesc.setText("Sex / Age");
			patSexAgeDesc.setBounds(225, 85, 95, 20);
		}
		return patSexAgeDesc;
	}

	private TextString getPatSex() {
		if (patSex == null) {
			patSex = new TextString(81);
			patSex.setBounds(335, 85, 55, 20);
			patSex.setEditable(false);
		}
		return patSex;
	}

	private TextString getPatAge() {
		if (patAge == null) {
			patAge = new TextString(81);
			patAge.setBounds(395, 85, 55, 20);
			patAge.setEditable(false);
		}
		return patAge;
	}

	private ButtonBase getAllergy() {

		if (allergy == null) {
			allergy = new ButtonBase() {
			};
			allergy.setText("Allergy", 'g');
			allergy.setBounds(460, 85, 50, 20);
		}
		return allergy;
	}

	private LabelBase getFilmToDesc() {
		if (filmToDesc == null) {
			filmToDesc = new LabelBase();
			filmToDesc.setText("Film To");
			filmToDesc.setBounds(540, 85, 105, 20);
		}
		return filmToDesc;
	}

	private ComboBoxBase getFilmTo() {
		if (filmTo == null) {
			filmTo = new ComboBoxBase(true);
			filmTo.setBounds(660, 85, 95, 20);
		}
		return filmTo;
	}

	private TextString getFilmToName() {
		if (filmToName == null) {
			filmToName = new TextString(81);
			filmToName.setBounds(760, 85, 95, 20);
			filmToName.setEditable(false);
		}
		return filmToName;
	}

	private LabelBase getExamCountDesc() {
		if (examCountDesc == null) {
			examCountDesc = new LabelBase();
			examCountDesc.setText("No of Exam");
			examCountDesc.setBounds(10, 5, 150, 20);
		}
		return examCountDesc;
	}

	private TextReadOnly getExamCount() {
		if (examCount == null) {
			examCount = new TextReadOnly();
			examCount.setBounds(80, 5, 73, 20);
		}
		return examCount;
	}

	private LabelBase getReportedCountDesc() {
		if (reportedCountDesc == null) {
			reportedCountDesc = new LabelBase();
			reportedCountDesc.setText("No of Reported");
			reportedCountDesc.setBounds(170, 5, 150, 20);
		}
		return reportedCountDesc;
	}

	private TextReadOnly getReportedCount() {
		if (reportedCount == null) {
			reportedCount = new TextReadOnly();
			reportedCount.setBounds(260, 5, 73, 20);
		}
		return reportedCount;
	}

	private LabelBase getIncompletedCountDesc() {
		if (incompletedCountDesc == null) {
			incompletedCountDesc = new LabelBase();
			incompletedCountDesc.setText("No of incompleted");
			incompletedCountDesc.setBounds(350, 5, 150, 20);
		}
		return incompletedCountDesc;
	}

	private TextReadOnly getIncompletedCount() {
		if (incompletedCount == null) {
			incompletedCount = new TextReadOnly();
			incompletedCount.setBounds(460, 5, 73, 20);
		}
		return incompletedCount;
	}

	private LabelBase getLendCountDesc() {
		if (lendDesc == null) {
			lendDesc = new LabelBase();
			lendDesc.setText("No of Lend");
			lendDesc.setBounds(550, 5, 150, 20);
		}
		return lendDesc;
	}

	private TextReadOnly getLendCount() {
		if (lendCount == null) {
			lendCount = new TextReadOnly();
			lendCount.setBounds(620, 5, 73, 20);
		}
		return lendCount;
	}

	private LabelBase getPrintedCountDesc() {
		if (printedCountDesc == null) {
			printedCountDesc = new LabelBase();
			printedCountDesc.setText("No of Printed");
			printedCountDesc.setBounds(710, 5, 150, 20);
		}
		return printedCountDesc;
	}

	private TextReadOnly getPrintedCount() {
		if (printedCount == null) {
			printedCount = new TextReadOnly();
			printedCount.setBounds(790, 5, 73, 20);
		}
		return printedCount;
	}

	private LabelBase getExamPkgCodeDesc() {
		if (examPkgCodeDesc == null) {
			examPkgCodeDesc = new LabelBase();
			examPkgCodeDesc.setText("Exam / Pkg Code");
			examPkgCodeDesc.setBounds(5, 5, 150, 20);
		}
		return examPkgCodeDesc;
	}

	private TextItemCodeSearch getExamPkgCode() {
		if (examPkgCode == null) {
			examPkgCode = new TextItemCodeSearch();
			examPkgCode.setBounds(105, 5, 100, 20);
			examPkgCode.setEditable(false);
		}
		return examPkgCode;
	}

	private LabelBase getUnitCodeDesc() {
		if (unitCodeDesc == null) {
			unitCodeDesc = new LabelBase();
			unitCodeDesc.setText("Unit");
			unitCodeDesc.setBounds(220, 5, 150, 20);
		}
		return unitCodeDesc;
	}

	private TextString getUnitCode() {
		if (unitCode == null) {
			unitCode = new TextString();
			unitCode.setText("1");
			unitCode.setBounds(250, 5, 100, 20);
			unitCode.setEditable(false);
		}
		return unitCode;
	}

	private LabelBase getStanRateDesc() {
		if (stanRateDesc == null) {
			stanRateDesc = new LabelBase();
			stanRateDesc.setText("Standard Rate");
			stanRateDesc.setBounds(360, 5, 150, 20);
		}
		return stanRateDesc;
	}

	private CheckBoxBase getStanRate() {
		if (stanRate == null) {
			stanRate = new CheckBoxBase();
			stanRate.setBounds(400, 5, 100, 20);
			stanRate.setSelected(true);
			stanRate.setEditable(false);
		}
		return stanRate;
	}

	private ButtonBase getDiHist() {

		if (diHist == null) {
			diHist = new ButtonBase() {
				@Override
				public void onClick() {
					showDiHistPanel();
				}
			};
			diHist.setText("DI History", 'D');
			
			diHist.setBounds(5, 630, 100, 20);
		}
		return diHist;
	}

	private ButtonBase getRemove() {
		if (remove == null) {
			remove = new ButtonBase() {
				@Override
				public void onClick() {
					int selectrow = getListTable().getSelectedRow();
					int rowcount = getListTable().getRowCount();
					if (getListTable().getRowCount() > 0) {
						getListTable().removeRow(getListTable().getSelectedRow());
						if (getListTable().getRowCount() > 0) {
							if (selectrow == (rowcount - 1)) {
								getListTable().setRowSelectionInterval(selectrow - 1, selectrow - 1);
							} else {
								getListTable().setRowSelectionInterval(selectrow, selectrow);
							}
						}
					}
					refreshScreen();
				}
			};
			remove.setText("Remove", 'v');
			remove.setBounds(110, 630, 100, 20);
		}
		return remove;
	}

	private LabelBase getOriExamDesc() {
		if (oriExamDesc == null) {
			oriExamDesc = new LabelBase();
			oriExamDesc.setText("Original Exam");
			oriExamDesc.setBounds(650, 630, 100, 20);
		}
		return oriExamDesc;
	}

	private TextReadOnly getOriExam() {
		if (oriExam == null) {
			oriExam = new TextReadOnly();
			oriExam.setBounds(730, 630, 50, 20);
		}
		return oriExam;
	}

	private LabelBase getOriExamTotalDesc() {
		if (oriExamTotalDesc == null) {
			oriExamTotalDesc = new LabelBase();
			oriExamTotalDesc.setText("Total");
			oriExamTotalDesc.setBounds(790, 630, 100, 20);
		}
		return oriExamTotalDesc;
	}

	private TextReadOnly getOriExamTotal() {
		if (oriExamTotal == null) {
			oriExamTotal = new TextReadOnly();
			oriExamTotal.setBounds(820, 630, 50, 20);
		}
		return oriExamTotal;
	}

	private LabelBase getCurExamDesc() {
		if (curExamDesc == null) {
			curExamDesc = new LabelBase();
			curExamDesc.setText("Current Exam");
			curExamDesc.setBounds(650, 660, 100, 20);
		}
		return curExamDesc;
	}

	private TextReadOnly getCurExam() {
		if (curExam == null) {
			curExam = new TextReadOnly();
			curExam.setBounds(730, 660, 50, 20);
		}
		return curExam;
	}

	private LabelBase getCurExamTotalDesc() {
		if (curExamTotalDesc == null) {
			curExamTotalDesc = new LabelBase();
			curExamTotalDesc.setText("Total");
			curExamTotalDesc.setBounds(790, 660, 100, 20);
		}
		return curExamTotalDesc;
	}

	private TextReadOnly getCurExamTotal() {
		if (curExamTotal == null) {
			curExamTotal = new TextReadOnly();
			curExamTotal.setBounds(820, 660, 50, 20);
		}
		return curExamTotal;
	}

}