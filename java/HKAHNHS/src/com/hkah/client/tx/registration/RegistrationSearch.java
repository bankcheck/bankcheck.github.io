package com.hkah.client.tx.registration;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.extjs.gxt.ui.client.Style.SelectionMode;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.google.gwt.user.client.Timer;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.combobox.ComboRegType;
import com.hkah.client.layout.combobox.ComboSpecialtyCode;
import com.hkah.client.layout.combobox.ComboStatus;
import com.hkah.client.layout.combobox.ComboWard;
import com.hkah.client.layout.dialog.DialogBase;
import com.hkah.client.layout.dialog.DlgNoOfLblToBePrt;
import com.hkah.client.layout.dialog.DlgPrintWristbandLabel;
import com.hkah.client.layout.dialog.DlgTransferBedLabel;
import com.hkah.client.layout.dialog.DlgViewSupp;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.label.LabelSmallBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.radiobutton.RadioButtonBase;
import com.hkah.client.layout.table.TableData;
import com.hkah.client.layout.textfield.TextBedSearch;
import com.hkah.client.layout.textfield.TextDateTime;
import com.hkah.client.layout.textfield.TextDoctorSearch;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.tx.transaction.TransactionDetail;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class RegistrationSearch extends MasterPanel {
	/**
	 *
	 */
	private static final long serialVersionUID = 1L;

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with serverO

		return ConstantsTx.REGSEARCH_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.REGSEARCH_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Alert","REG ID", "Patient No.", "Patient SurName",
				"Patient Given Name", "Chinese Name", "",
				"", "Bed Code", "Phone Ext.",
				"Spec Req.",//special request
				"Slip No", "Reg. Type", "Category",
				"Trt.", "Adm.", "Status",
				"Registration Date", "Discharge Date", "Package Name",
				"Ticket #", "", "Created By","bkgid" };
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				45,0, 65, 100,
				130, 90, 0,
				0, 70, 70,
				(YES_VALUE.equals(getSysParameter("PBkAMCCMP")))?60:0,//special request
				80, 60, 70,
				50, 50, 50,
				110, 110, 90,
				90, 0, (YES_VALUE.equals(getSysParameter("PBkAMCCMP")))?70:0,//create user
				0
			};
	}

	/* >>> ~4a~ Set Table Column Menu  ==================================== <<< */
	@Override
	public boolean getNotShowMenu() {
		return false;
	}

	private BasePanel rightPanel = null;
	private BasePanel leftPanel = null;

	private BasePanel ParaPanel = null;
	private LabelBase LJLabel_PatNo = null;
	private TextPatientNoSearch LJText_PatNo = null;
	private LabelBase LJLabel_SurName = null;
	private TextString LJText_SurName = null;
	private LabelBase LJLabel_GivenName = null;
	private TextString LJText_GivenName = null;
	private LabelBase LJLabel_DocCode = null;
	private TextDoctorSearch LJText_DocCode = null;
	private LabelBase LJLabel_specialtyDesc = null;
	private ComboBoxBase LJCombo_specialty = null;
	private LabelBase LJLabel_SlipNo = null;
	private TextString LJText_SlipNo = null;
	private LabelBase LJLabel_RegType = null;
	private ComboRegType LJCombo_RegType = null;
	private LabelBase LJLabel_AdmDateFrom = null;
	private TextDateTime LJText_AdmDateFrom = null;
	private LabelBase LJLabel_AdmDateTo = null;
	private TextDateTime LJText_AdmDateTo = null;
	private LabelBase LJLabel_DisgDateFrom = null;
	private TextDateTime LJText_DisgDateFrom = null;
	private LabelBase LJLabel_DisgDateTo = null;
	private TextDateTime LJText_DisgDateTo = null;
	private LabelBase LJLabel_Status = null;
	private ComboStatus LJCombo_Status = null;
	private LabelBase LJLabel_CurInPat = null;
	private CheckBoxBase LJCheckBox_CurInPat = null;
	private LabelBase LJLabel_Ward = null;
	private ComboWard LJComboBox_Ward = null;
	private LabelBase LJLabel_BedCode = null;
	private TextBedSearch LJText_BedCode = null;
	private LabelBase LJLabel_CreateByUser = null;
	private TextString LJText_CreateByUsr = null;
	private LabelBase LJLabel_Sorting = null;
	private ComboBoxBase LJCombo_Sorting = null;
	private LabelBase LJLabel_Count = null;
	private TextReadOnly LJText_Count = null;
	private ButtonBase LJButton_BDTransfer = null;
	private ButtonBase LJButton_CancelReg = null;
	private ButtonBase LJButton_Discharge = null;
	private ButtonBase LJButton_PrtILRpt = null;
	private ButtonBase LJButton_PrtLbl = null;
	private ButtonBase LJButton_NewSlipInpat = null;
	private ButtonBase LJButton_IPGenLbl = null;
	private ButtonBase LJButton_RegSht = null;
	private ButtonBase LJButton_WrtBdLbl = null;
	private ButtonBase LJButton_PatLbl = null;
	private ButtonBase LJButton_ViewSupp = null;
	private ButtonBase LJButton_TransBedLbl = null;
	private ButtonBase LJButton_PEDLbl = null;
	private ButtonBase LJButton_AppLbl = null;
	private ButtonBase LJButton_PhysicalForm = null;

	private DlgNoOfLblToBePrt dlgNoOfLblToBePrtInp = null;
	private DlgNoOfLblToBePrt dlgNoOfLblToBePrtOutp = null;
	private DlgPrintWristbandLabel dlgPrintWristbandLabel = null;
	private DlgTransferBedLabel dlgTransferBedLabel = null;

	private int lcFocus;
//	private boolean modalResult = false;
	private boolean isSearching = false;

	private final int GrdCol_alert = 0;
	private final int GrdCol_regid = 1;
	private final int GrdCol_patno = 2;
	private final int GrdCol_patsname = 3;
	private final int GrdCol_patgname = 4;
	private final int GrdCol_patcname = 5;
	private final int GrdCol_sex= 7;
	private final int GrdCol_bedcode = 8;
	private final int GrdCol_ext = 9;
	private final int GrdCol_specreq = 10;
	private final int GrdCol_slpno = 11;
	private final int GrdCol_regtype = 12;
	private final int GrdCol_category = 13;
	private final int GrdCol_trt = 14;
	private final int GrdCol_adm = 15;
	private final int GrdCol_status = 16;
	private final int GrdCol_regdate = 17;
	private final int GrdCol_disdate = 18;
	private final int GrdCol_pkgname = 19;
	private final int GrdCol_tktno = 20;
	private final int GrdCol_regsts = 21;
	private final int GrdCol_createby = 22;
	private final int GrdCol_bkgid = 23;

	/**
	 * This method initializes
	 *
	 */
	public RegistrationSearch() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		setLeftAlignPanel();
		getJScrollPane().setBounds(17, 145, 757, 265);
		getListTable().setSelectionMode(SelectionMode.MULTI);
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		getListTable().setColumnColor(GrdCol_alert, "red");
		// getListTable().setColumnClass(14, new ComboStatus(),false);

		// disable some action button
		getLJCombo_Status().setText("N");
		if (getParameter("qPATNO") != null) {
			getLJText_PatNo().setText(getParameter("qPATNO"));
			// searchAction(true);
		} else {
			resetParameter("qPATNO");
		}
		
		if (getParameter("from") != null) {
			if ("docAppBse".equals(getParameter("from"))) {
				getLJText_PatNo().setText(getParameter("qPATNO"));
				getLJCombo_specialty().setText(getParameter("spec"));
				if ((getParameter("qPATNO") != null && !"".equals(getParameter("qPATNO"))) &&
						(getParameter("spec") != null && !"".equals(getParameter("spec")))
					){
					searchAction(true);
				}
			}
			// searchAction(true);
		} else {
			resetParameter("from");
			resetParameter("qPATNO");
			resetParameter("spec");
		}
		listTableRowChange();
		
	}

	public void rePostAction() {
		// super.rePostAction();
		if (getParameter("PatNo") != null && !"".equals(getParameter("PatNo"))) {
			getLJText_PatNo().setText(getParameter("PatNo"));
			resetParameter("PatNo");
			getLJText_PatNo().requestFocus();
		} else {
			searchAction(true);
		}
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextPatientNoSearch getDefaultFocusComponent() {
		return getLJText_PatNo();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {
	}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {
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
		// if (getLJText_PatNo().isFocusOwner() &&
		// getLJText_PatNo().getText().trim().length()<=0) { //
		setParameter("AcceptClass", "PatientSearch");
		// showPanel(PatientSearch.class, true);
		// return false;
		// }
		// at least 3 criteria

		int criteria = 0;
		if (!getLJText_PatNo().isEmpty()) criteria = 3;
		if (!getLJText_SlipNo().isEmpty()) criteria = 3;
		if (!getLJText_CreateByUsr().isEmpty()) criteria = 3;
		if (!getLJText_SurName().isEmpty()) criteria++;
		if (!getLJText_GivenName().isEmpty()) criteria++;
		if (!getLJText_DocCode().isEmpty()) criteria++;
		if (!getLJText_DocCode().isEmpty()) criteria++;
		if (!getLJCombo_RegType().isEmpty()) criteria++;
		if (!getLJText_AdmDateFrom().isValidEmpty()) criteria++;
		if (!getLJText_AdmDateTo().isValidEmpty()) criteria++;
		if (!getLJCombo_Status().isEmpty()) criteria++;
		if (getLJCheckBox_CurInPat().isSelected()) criteria = 3;
		if (!getLJComboBox_Ward().isEmpty()) criteria++;
		if (!getLJText_DisgDateFrom().isValidEmpty()) criteria++;
		if (!getLJText_DisgDateTo().isValidEmpty()) criteria++;
		if (criteria < 3) {
			Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_INPUT_CRITERIA_3, "Registration Search", getDefaultFocusComponent());
			return false;
		}

		return true;
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
				getLJText_PatNo().getText().trim(),
				getLJText_SurName().getText().trim(),
				getLJText_GivenName().getText().trim(),
				EMPTY_VALUE,
				getLJText_DocCode().getText().trim(),
				getLJText_SlipNo().getText().trim(),
				getLJCombo_RegType().getText().trim(),
				getLJText_AdmDateFrom().getText().trim(),
				getLJText_AdmDateTo().getText().trim(),
				getLJText_DisgDateFrom().getText().trim(),
				getLJText_DisgDateTo().getText().trim(),
				getLJCombo_Status().getText().trim(),
				getLJCheckBox_CurInPat().isSelected() ? MINUS_ONE_VALUE : ZERO_VALUE,
				getLJComboBox_Ward().getText().trim(),
				getLJText_BedCode().getText().trim(),
				getLJText_CreateByUsr().getText().toUpperCase().trim(),
				Factory.getInstance().getUserInfo().getUserID(),
				getLJCombo_Sorting().getText(),
				getLJCombo_specialty().getText().trim()};
	}

	/* >>> ~16~ Set Fetch Input Parameters ================================ <<< */
	@Override
	protected String[] getFetchInputParameters() {
		return new String[] { getListSelectedRow()[GrdCol_regid] };
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {
		listTableRowChange();
	}

	/* >>> ~15~ Set Fetch Output Results ============================== <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {

	}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return new String[] {};
	}

	/* >>> ~16.1~ Set Action Output Parameters =========================== <<< */
	@Override
	protected void getNewOutputValue(String returnValue) {
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

//	private void setlcFocus(int focus) {
//		lcFocus = focus;
//	}

//	private int getlcFocus() {
//		return lcFocus;
//	}

	private void listTableRowChange() {
		getLJText_Count().setText(String.valueOf(getListTable().getRowCount()));
		if (getListTable().getRowCount() > 0 && getListTable().getSelectedRow() >= 0) {
			if ("I".equals(getListTable().getSelectedRowContent()[GrdCol_regtype])) {	// regType
				getLJButton_BDTransfer().setEnabled(!isDisableFunction("btnBed", "srhReg"));
				getLJButton_Discharge().setEnabled(!isDisableFunction("btnDischarge", "srhReg"));
				getLJButton_NewSlipInpat().setEnabled(
						!isDisableFunction("btnSplitSlip", "srhReg") &&
						(getListTable().getSelectedRowContent()[GrdCol_disdate] == null ||
						getListTable().getSelectedRowContent()[GrdCol_disdate].length() == 0));
				if (Factory.getInstance().getSysParameter("TRANSBLBL").equals("Y")) {
					getLJButton_TransBedLbl().setEnabled(
							(getListTable().getSelectedRowContent()[GrdCol_disdate] == null ||
							getListTable().getSelectedRowContent()[GrdCol_disdate].length() == 0));
				}
			} else {
				getLJButton_BDTransfer().setEnabled(false);
				getLJButton_Discharge().setEnabled(false);
				getLJButton_NewSlipInpat().setEnabled(false);
				getLJButton_TransBedLbl().setEnabled(false);
			}
			getLJButton_CancelReg().setEnabled(!isDisableFunction("btnCancelReg", "srhReg"));
			getLJButton_RegSht().setEnabled(true);
			getLJButton_ViewSupp().setEnabled(true);
		} else {
			getLJButton_BDTransfer().setEnabled(false);
			getLJButton_CancelReg().setEnabled(false);
			getLJButton_Discharge().setEnabled(false);
			getLJButton_NewSlipInpat().setEnabled(false);
			getLJButton_RegSht().setEnabled(false);
			getLJButton_ViewSupp().setEnabled(false);
			getLJButton_TransBedLbl().setEnabled(false);
			getLJButton_PEDLbl().setEnabled(false);
			getLJButton_AppLbl().setEnabled(false);
			getLJButton_PhysicalForm().setEnabled(false);
		}
		getLJButton_PrtILRpt().setEnabled(true);
		getLJButton_PrtLbl().setEnabled(true);
		getLJButton_IPGenLbl().setEnabled(true);
		getLJButton_PatLbl().setEnabled(true);
		getLJButton_WrtBdLbl().setEnabled(true);

		getAcceptButton().setEnabled(!isDisableFunction("Accept", "srhReg")
				&& !isDisableFunction("TB_ACCEPT", "srhReg")
				&& getListTable().getRowCount() > 0
				&& getListTable().getSelectedRow() >= 0
				&& "N".equals(getListTable().getSelectedRowContent()[GrdCol_regsts]));
		
		if (getParameter("from") != null && "docAppBse".equals(getParameter("from"))) {
			setAllLeftButtonEnabled(false);
		}
	}

	private void cancelReg() {
		if (getListTable().getRowCount() == 0 || getListTable().getSelectedRow() < 0) {
			return;
		}

		if ("C".equals(getListTable().getSelectedRowContent()[GrdCol_regsts])) {
			Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_CANCEL_REGISTRATION_FAILED);
			return;
		}

		MessageBoxBase.confirm(MSG_PBA_SYSTEM, MSG_CANCEL_REGISTRATION,
				new Listener<MessageBoxEvent>() {
			@Override
			public void handleEvent(MessageBoxEvent be) {
				if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
					if ("N".equals(getListTable().getSelectedRowContent()[GrdCol_regsts])) {
						QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
								new String[] {"SlipTx", "COUNT(1)", "SlpNo='" + getListTable().getSelectedRowContent()[GrdCol_slpno] + "'" },
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									String count = mQueue.getContentField()[0];
									if (!ZERO_VALUE.equals(count)) {
										MessageBoxBase.confirm(MSG_PBA_SYSTEM,
												"This patient slip have entry, Continue?",
												new Listener<MessageBoxEvent>() {
											@Override
											public void handleEvent(MessageBoxEvent be) {
												if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
													deleteReg();
												}
											}
										});
									} else {
										deleteReg();
									}
								} else {
									Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_CANCEL_REGISTRATION_FAILED);
								}
							}
						});
					}
				}
			}
		});
	}

	private void deleteReg() {
		if (getListTable().getRowCount() == 0 || getListTable().getSelectedRow() < 0) {
			return;
		}

		QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] { "Slip", "SlpPAmt+SlpCAmt+SlpDAmt", "SlpNo='" + getListTable().getSelectedRowContent()[GrdCol_slpno] + "'" },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				String amt = null;
				if (mQueue.success()) {
					amt = mQueue.getContentField()[0];
				} else {
					amt = ZERO_VALUE;
				}
				if (!ZERO_VALUE.equals(amt)) {
					Factory.getInstance().addErrorMessage("This patient slip balance is not zero. \n"
											+ ConstantsMessage.MSG_CANCEL_REGISTRATION_FAILED);
					return;
				}

				QueryUtil.executeMasterAction( getUserInfo(), "REG_CANCEL",
					QueryUtil.ACTION_MODIFY,
						new String[] {
								getListTable().getSelectedRowContent()[GrdCol_regid],
								getListTable().getSelectedRowContent()[GrdCol_slpno],
								getListTable().getSelectedRowContent()[GrdCol_bedcode],
								Factory.getInstance().getUserInfo().getUserID()
						},
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							checkAltAccess();
							searchAction(true);
						} else {
							Factory.getInstance().addErrorMessage(mQueue);
						}
					}
				});
			}
		});
	}

	private void checkAltAccess() {
		if (getListTable().getRowCount() == 0 || getListTable().getSelectedRow() < 0) {
			return;
		}

		String regId = getListTable().getSelectedRowContent()[GrdCol_regid];
		QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] {
						"reg r, inpat i, bed b, slip s, doctor d",
						"b.ROMCODE, d.DOCFNAME || ' ' || d.DOCGNAME",
						"r.RegID='" + regId + "'" +
						" and r.inpid = i.inpid " +
						" and b.bedcode = i.bedcode " +
						" and r.slpno = s.slpno " +
						" and s.DOCCODE = d.DOCCODE"}, new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					String roomNo = mQueue.getContentField()[0];
					String docName = mQueue.getContentField()[1];
					String admDate = getListTable().getSelectedRowContent()[GrdCol_regdate];
					String patno = getListTable().getSelectedRowContent()[GrdCol_patno];

					String funname = "Inpatient Cancellation";
					Map<String, String> params = new HashMap<String, String>();
					params.put("Doctor Name", docName);
					params.put("Room No", roomNo);
					params.put("Adm. Date", admDate);
					getAlertCheck().checkAltAccess(
							patno, funname, true, true, params);
				}
			}
		});
	}

	private void newSlip() {
		if (getListTable().getRowCount() == 0 || getListTable().getSelectedRow() < 0) {
			return;
		}

		Factory.getInstance().isConfirmYesNoDialog("Are you sure to create a new slip ?",
				new Listener<MessageBoxEvent>() {
			@Override
			public void handleEvent(MessageBoxEvent be) {
				if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
					if ("C".equals(getListTable().getSelectedRowContent()[GrdCol_regsts])) {
						Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_CANCELLED_REGISTRATION);
					} else {
						QueryUtil.executeMasterAction(getUserInfo(), "SPLIT_SLIP", QueryUtil.ACTION_APPEND,
								new String[] {
									getListTable().getSelectedRowContent()[GrdCol_regid],
									getListTable().getSelectedRowContent()[GrdCol_patno],
									getUserInfo().getSiteCode(),
									getUserInfo().getUserID()
								},
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(
									MessageQueue mQueue) {
								// TODO Auto-generated
								// method stub
								if (mQueue.success()) {
									final String slipNo = mQueue.getReturnCode();
									MessageBoxBase.confirm(ConstantsMessage.MSG_PBA_SYSTEM, ConstantsMessage.MSG_SPLITSLIP_SUCCESS + " Do you want to open?",
											new Listener<MessageBoxEvent>() {
											@Override
											public void handleEvent(MessageBoxEvent be) {
												if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
													lockRecord("Slip", slipNo, new String[] { "accept" });
												}
											}
										});
								} else {
									Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_SPLITSLIP_FAILED);
								}
							}
						});
					}
				}
			}
		});
	}

	@Override
	protected void lockRecordReady(final String lockType, final String lockKey, final String[] record, boolean lock, String returnMessage) {
		if (lock) {
			// store parameter
			setParameter("SlpNo", lockKey);
			setParameter("isNewSlip", YES_VALUE);
			setParameter("isLocked", YES_VALUE);
			setParameter("isReadOnly", NO_VALUE);

			// show transaction detail
			showPanel(new TransactionDetail());
		} else {
			Factory.getInstance().addErrorMessage(returnMessage);
		}
	}

	private void printRpt(boolean isHhlgted) {
		StringBuffer regID = new StringBuffer();
		List<TableData> data = new ArrayList<TableData>();
		if (isHhlgted) {
			data = getListTable().getSelectedItems();
		} else {
			data = getListTable().getStore().getModels();
		}
		for (int i = 0; i < data.size(); i++) {
			regID.append("'" + data.get(i).getValue(GrdCol_regid) + "'");
			if (i < data.size() - 1) {
				regID.append("ca");
			}
		}
		Map<String,String> map = new HashMap<String,String>();
		final String siteCode = getMainFrame().getUserInfo().getSiteCode();
		map.put("SITECODE", siteCode);
//		String inParam = new String();
//		String columnName = new String();
//		StringBuffer mapKey = new StringBuffer();
//		StringBuffer mapValue = new StringBuffer();

//		inParam = regID.toString()+"<FIELD/>";

		PrintingUtil.print("[Default Printer]","REGSHEET",
				map,null,
				new String[] {regID.toString()},
				new String[] {"regid","patno","regtype"
				,"patname","patcname","inpddateasdate"
				,"inpddateastext","regdateasdate","regdateastext"});
	}

	private String getDefaultPatientNumber() {
		if (!isSearching && getListTable().getRowCount() > 0 && getListTable().getSelectedRow() >= 0) {
			return getListTable().getSelectedRowContent()[GrdCol_patno];
		} else if (getLJText_PatNo().getText().length() > 0) {
			return getLJText_PatNo().getText();
		} else {
			return null;
		}
	}

	/***************************************************************************
	 * Dialog Methods
	 **************************************************************************/

	private DlgNoOfLblToBePrt getDlgNoOfLblToBePrtInp() {
		if (dlgNoOfLblToBePrtInp == null) {
			dlgNoOfLblToBePrtInp = new DlgNoOfLblToBePrt(getMainFrame(), true) {
				@Override
				protected void post(String patNo) {
					if (patNo == null) {
						Factory.getInstance().addErrorMessage("Invalid Patient Number", getLJText_PatNo());
					}
				}
			};
			dlgNoOfLblToBePrtInp.getPrintLabel().setText("How Many 2D BarCode Label to be printed?");
		}
		return dlgNoOfLblToBePrtInp;
	}

	private DlgNoOfLblToBePrt getDlgNoOfLblToBePrtOutp() {
		if (dlgNoOfLblToBePrtOutp == null) {
			dlgNoOfLblToBePrtOutp = new DlgNoOfLblToBePrt(getMainFrame(), false, false) {
				@Override
				protected void post(String patNo) {
					if (patNo == null) {
						Factory.getInstance().addErrorMessage("Invalid Patient Number", getLJText_PatNo());
					}
				}
			};
		}
		return dlgNoOfLblToBePrtOutp;
	}

	private DlgPrintWristbandLabel getDlgPrintWristbandLabel() {
		if (dlgPrintWristbandLabel == null) {
			dlgPrintWristbandLabel = new DlgPrintWristbandLabel(getMainFrame()) {
				@Override
				protected void post(String patNo) {
					if (patNo == null) {
						Factory.getInstance().addErrorMessage("Invalid Patient Number", getLJText_PatNo());
					}
				}
			};
		}
		return dlgPrintWristbandLabel;
	}

	/***************************************************************************
	 * Override Methods
	 **************************************************************************/

	@Override
	protected void performListPost() {
		listTableRowChange();
		isSearching = false;
	}

	@Override
	public void searchAction(boolean showMessage) {
		super.searchAction(showMessage);
	}

	@Override
	public void acceptAction() {
		if (getListTable().getRowCount() > 0 && getListTable().getSelectedRow() >= 0) {
			if ("C".equals(getListTable().getSelectedRowContent()[GrdCol_regsts])) {
				Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_CANCELLED_REGISTRATION);
				return;
			}
			setParameter("START_TYPE", "N");
			setParameter("PatNo", getListTable().getSelectedRowContent()[GrdCol_patno]); // PS_RatNo
			setParameter("RegID", getListTable().getSelectedRowContent()[GrdCol_regid]);
			setParameter("CallForm", "srhReg");
			setParameter("MODE", QueryUtil.ACTION_APPEND);// for Quick Charge
			showPanel(new Patient());
		}
	}

	@Override
	public void cancelAction() {
		cancelReg();
	}

	@Override
	protected void enableButton(String mode) {
		// disable all button
		disableButton();

		getSearchButton().setEnabled(true);
		getAcceptButton().setEnabled(!isDisableFunction("Accept", "srhReg") &&
				!isDisableFunction("TB_ACCEPT", "srhReg")
				&& getListTable().getRowCount() > 0
				&& getListTable().getSelectedRow() >= 0
				&& "N".equals(getListTable().getSelectedRowContent()[GrdCol_regsts]));
		getCancelButton().setEnabled(getListTable().getRowCount() > 0);
		getClearButton().setEnabled(true);
		getRefreshButton().setEnabled(true);
	}

	@Override
	protected void setAllLeftFieldsEnabled(boolean enable) {
		super.setAllLeftFieldsEnabled(enable);
		getLJButton_PrtLbl().enable();
		getLJButton_IPGenLbl().enable();
	}
	
	protected void setAllLeftButtonEnabled(boolean enable) {
		getLJButton_BDTransfer().setEnabled(enable);
		getLJButton_CancelReg().setEnabled(enable);
		getLJButton_Discharge().setEnabled(enable);
		getLJButton_PrtILRpt().setEnabled(enable);
		getLJButton_PrtLbl().setEnabled(enable);
		getLJButton_NewSlipInpat().setEnabled(enable);
		getLJButton_IPGenLbl().setEnabled(enable);
		getLJButton_PatLbl().setEnabled(enable);
		getLJButton_PatLbl().setEnabled(enable);
		getLJButton_WrtBdLbl().setEnabled(enable);
		getLJButton_RegSht().setEnabled(enable);
		getLJButton_ViewSupp().setEnabled(enable);
		getLJButton_TransBedLbl().setEnabled(enable);
		getLJButton_PEDLbl().setEnabled(enable);
		getLJButton_AppLbl().setEnabled(enable);
		getLJButton_PhysicalForm().setEnabled(enable);
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	@Override
	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.setSize(779, 528);
			leftPanel.add(getParaPanel(), null);
//			 leftPanel.add(getListTable());
			leftPanel.add(getJScrollPane());
//			 getJScrollPane().setBounds(17, 130, 757, 280);
			leftPanel.add(getLJLabel_Count(), null);
			leftPanel.add(getLJText_Count(), null);
			leftPanel.add(getLJButton_BDTransfer(), null);
			leftPanel.add(getLJButton_CancelReg(), null);
			leftPanel.add(getLJButton_Discharge(), null);
			leftPanel.add(getLJButton_PrtILRpt(), null);
			leftPanel.add(getLJButton_PrtLbl(), null);
			leftPanel.add(getLJButton_NewSlipInpat(), null);
			leftPanel.add(getLJButton_IPGenLbl(), null);
			leftPanel.add(getLJButton_PatLbl(), null);
			leftPanel.add(getLJButton_PatLbl(), null);
			leftPanel.add(getLJButton_WrtBdLbl(), null);
			leftPanel.add(getLJButton_RegSht(), null);
			leftPanel.add(getLJButton_ViewSupp(), null);
			leftPanel.add(getLJButton_TransBedLbl(), null);
			leftPanel.add(getLJButton_PEDLbl(), null);
			leftPanel.add(getLJButton_AppLbl(), null);
			leftPanel.add(getLJButton_PhysicalForm(), null);

		}
		return leftPanel;
	}

	protected BasePanel getRightPanel() {
		if (rightPanel == null) {
			rightPanel = new BasePanel();
		}
		return rightPanel;
	}

	public BasePanel getParaPanel() {
		if (ParaPanel == null) {
			ParaPanel = new BasePanel();
			ParaPanel.setBorders(true);
			ParaPanel.setBounds(17, 5, 757, 135);
			ParaPanel.add(getLJLabel_PatNo(), null);
			ParaPanel.add(getLJText_PatNo(), null);
			ParaPanel.add(getLJLabel_SurName(), null);
			ParaPanel.add(getLJText_SurName(), null);
			ParaPanel.add(getLJLabel_GivenName(), null);
			ParaPanel.add(getLJText_GivenName(), null);
			ParaPanel.add(getLJLabel_DocCode(), null);
			ParaPanel.add(getLJText_DocCode(), null);
			ParaPanel.add(getLJLabel_specialtyDesc(), null);
			ParaPanel.add(getLJCombo_specialty(), null);
			ParaPanel.add(getLJLabel_SlipNo(), null);
			ParaPanel.add(getLJText_SlipNo(), null);
			ParaPanel.add(getLJLabel_RegType(), null);
			ParaPanel.add(getLJCombo_RegType(), null);
			ParaPanel.add(getLJLabel_AdmDateFrom(), null);
			ParaPanel.add(getLJText_AdmDateFrom(), null);
			ParaPanel.add(getLJLabel_AdmDateTo(), null);
			ParaPanel.add(getLJText_AdmDateTo(), null);
			ParaPanel.add(getLJLabel_DisgDateFrom(), null);
			ParaPanel.add(getLJText_DisgDateFrom(), null);
			ParaPanel.add(getLJLabel_DisgDateTo(), null);
			ParaPanel.add(getLJText_DisgDateTo(), null);
			ParaPanel.add(getLJLabel_Status(), null);
			ParaPanel.add(getLJCombo_Status(), null);
			ParaPanel.add(getLJLabel_CurInPat(), null);
			ParaPanel.add(getLJCheckBox_CurInPat(), null);
			ParaPanel.add(getLJLabel_Ward(), null);
			ParaPanel.add(getLJComboBox_Ward(), null);
			ParaPanel.add(getLJLabel_BedCode(), null);
			ParaPanel.add(getLJText_BedCode(), null);
			ParaPanel.add(getLJLabel_CreateByUsr(), null);
			ParaPanel.add(getLJText_CreateByUsr(), null);
			ParaPanel.add(getLJLabel_Sorting(), null);
			ParaPanel.add(getLJCombo_Sorting(), null);
		}
		return ParaPanel;
	}

	private LabelBase getLJLabel_PatNo() {
		if (LJLabel_PatNo == null) {
			LJLabel_PatNo = new LabelBase();
			LJLabel_PatNo.setText("Patient No.");
			LJLabel_PatNo.setBounds(5, 5, 141, 20);
		}
		return LJLabel_PatNo;
	}

	private TextPatientNoSearch getLJText_PatNo() {
		if (LJText_PatNo == null) {
			LJText_PatNo = new TextPatientNoSearch(true, true) {
				@Override
				public void onFocus() {
//					setlcFocus(0);
				};

				@Override
				public void onBlur() {
					super.onBlur();
				}

				@Override
				public void onBlurPost() {
					isSearching = true;
					searchAction(true);
				}
			};
			LJText_PatNo.setBounds(146, 5, 120, 20);
		}
		return LJText_PatNo;
	}

	private LabelBase getLJLabel_SurName() {
		if (LJLabel_SurName == null) {
			LJLabel_SurName = new LabelBase();
			LJLabel_SurName.setText("SurName");
			LJLabel_SurName.setBounds(285, 5, 70, 20);
		}
		return LJLabel_SurName;
	}

	private TextString getLJText_SurName() {
		if (LJText_SurName == null) {
			LJText_SurName = new TextString() {
				@Override
				public void onFocus() {
//					setlcFocus(1);
				};
			};
			LJText_SurName.setBounds(354, 5, 120, 20);
		}
		return LJText_SurName;
	}

	private LabelBase getLJLabel_GivenName() {
		if (LJLabel_GivenName == null) {
			LJLabel_GivenName = new LabelBase();
			LJLabel_GivenName.setText("Given Name");
			LJLabel_GivenName.setBounds(494, 5, 120, 20);
		}
		return LJLabel_GivenName;
	}

	private TextString getLJText_GivenName() {
		if (LJText_GivenName == null) {
			LJText_GivenName = new TextString() {
				@Override
				public void onFocus() {
//					setlcFocus(2);
				};
			};
			LJText_GivenName.setBounds(614, 5, 120, 20);
		}
		return LJText_GivenName;
	}

	private LabelBase getLJLabel_DocCode() {
		if (LJLabel_DocCode == null) {
			LJLabel_DocCode = new LabelBase();
			LJLabel_DocCode.setText("Dr. Code");
			LJLabel_DocCode.setBounds(5, 30, 60, 20);
		}
		return LJLabel_DocCode;
	}

	private TextDoctorSearch getLJText_DocCode() {
		if (LJText_DocCode == null) {
			LJText_DocCode = new TextDoctorSearch() {
				@Override
				public void onFocus() {
//					setlcFocus(3);
				};

				@Override
				public void checkTriggerBySearchKeyPost() {
					searchAction(true);
				}
			};
			LJText_DocCode.setBounds(60, 30, 80, 20);
		}
		return LJText_DocCode;
	}
	
	private LabelBase getLJLabel_specialtyDesc() {
		if (LJLabel_specialtyDesc == null) {
			LJLabel_specialtyDesc = new LabelBase();
			LJLabel_specialtyDesc.setText("Spec.");
			LJLabel_specialtyDesc.setBounds(146, 30, 50, 20);
		}
		return LJLabel_specialtyDesc;
	}

	protected ComboBoxBase getLJCombo_specialty() {
		if (LJCombo_specialty == null) {
			LJCombo_specialty = new ComboSpecialtyCode();
			LJCombo_specialty.setBounds(180, 30, 80, 20);
		}
		return LJCombo_specialty;
	}

	private LabelBase getLJLabel_SlipNo() {
		if (LJLabel_SlipNo == null) {
			LJLabel_SlipNo = new LabelBase();
			LJLabel_SlipNo.setText("Slip No");
			LJLabel_SlipNo.setBounds(285, 30, 70, 20);
		}
		return LJLabel_SlipNo;
	}

	private TextString getLJText_SlipNo() {
		if (LJText_SlipNo == null) {
			LJText_SlipNo = new TextString() {
				@Override
				public void onFocus() {
//					setlcFocus(4);
				};
			};
			LJText_SlipNo.setBounds(355, 30, 120, 20);
		}
		return LJText_SlipNo;
	}

	private LabelBase getLJLabel_RegType() {
		if (LJLabel_RegType == null) {
			LJLabel_RegType = new LabelBase();
			LJLabel_RegType.setText("Registration Type");
			LJLabel_RegType.setBounds(494, 30, 120, 20);
		}
		return LJLabel_RegType;
	}

	public ComboRegType getLJCombo_RegType() {
		if (LJCombo_RegType == null) {
			LJCombo_RegType = new ComboRegType() {
				@Override
				protected void onSelected() {
					if (getLJCheckBox_CurInPat().isSelected() && !"I".equals(getText())) {
						getLJCheckBox_CurInPat().setSelected(false);
					}
				}
			};
			LJCombo_RegType.setBounds(614, 30, 120, 20);
		}
		return LJCombo_RegType;
	}

	private LabelBase getLJLabel_AdmDateFrom() {
		if (LJLabel_AdmDateFrom == null) {
			LJLabel_AdmDateFrom = new LabelBase();
			LJLabel_AdmDateFrom.setText("Admission Date From");
			LJLabel_AdmDateFrom.setBounds(5, 55, 141, 20);
		}
		return LJLabel_AdmDateFrom;
	}

	private TextDateTime getLJText_AdmDateFrom() {
		if (LJText_AdmDateFrom == null) {
			LJText_AdmDateFrom = new TextDateTime(true) {
				@Override
				public void onFocus() {
//					setlcFocus(6);
				};
			};
			LJText_AdmDateFrom.setBounds(146, 55, 120, 20);
		}
		return LJText_AdmDateFrom;
	}

	private LabelBase getLJLabel_AdmDateTo() {
		if (LJLabel_AdmDateTo == null) {
			LJLabel_AdmDateTo = new LabelBase();
			LJLabel_AdmDateTo.setText("To");
			LJLabel_AdmDateTo.setBounds(285, 55, 70, 20);
		}
		return LJLabel_AdmDateTo;
	}

	private TextDateTime getLJText_AdmDateTo() {
		if (LJText_AdmDateTo == null) {
			LJText_AdmDateTo = new TextDateTime(true) {
				@Override
				public void onFocus() {
//					setlcFocus(7);
				}
			};
			LJText_AdmDateTo.setBounds(355, 55, 120, 20);
		}
		return LJText_AdmDateTo;
	}

	private LabelBase getLJLabel_Status() {
		if (LJLabel_Status == null) {
			LJLabel_Status = new LabelBase();
			LJLabel_Status.setText("Status");
			LJLabel_Status.setBounds(494, 55, 120, 20);
		}
		return LJLabel_Status;
	}

	public ComboStatus getLJCombo_Status() {
		if (LJCombo_Status == null) {
			LJCombo_Status = new ComboStatus();
			LJCombo_Status.setBounds(614, 55, 120, 20);
		}
		return LJCombo_Status;
	}

	private LabelBase getLJLabel_DisgDateFrom() {
		if (LJLabel_DisgDateFrom == null) {
			LJLabel_DisgDateFrom = new LabelBase();
			LJLabel_DisgDateFrom.setText("Discharge Date From");
			LJLabel_DisgDateFrom.setBounds(5, 80, 141, 20);
		}
		return LJLabel_DisgDateFrom;
	}

	private TextDateTime getLJText_DisgDateFrom() {
		if (LJText_DisgDateFrom == null) {
			LJText_DisgDateFrom = new TextDateTime(true) {
				@Override
				public void onFocus() {
//					setlcFocus(6);
				};
			};
			LJText_DisgDateFrom.setBounds(146, 80, 120, 20);
		}
		return LJText_DisgDateFrom;
	}

	private LabelBase getLJLabel_DisgDateTo() {
		if (LJLabel_DisgDateTo == null) {
			LJLabel_DisgDateTo = new LabelBase();
			LJLabel_DisgDateTo.setText("To");
			LJLabel_DisgDateTo.setBounds(285, 80, 70, 20);
		}
		return LJLabel_DisgDateTo;
	}

	private TextDateTime getLJText_DisgDateTo() {
		if (LJText_DisgDateTo == null) {
			LJText_DisgDateTo = new TextDateTime(true) {
				@Override
				public void onFocus() {
//					setlcFocus(7);
				}
			};
			LJText_DisgDateTo.setBounds(355, 80, 120, 20);
		}
		return LJText_DisgDateTo;
	}

	private LabelBase getLJLabel_CurInPat() {
		if (LJLabel_CurInPat == null) {
			LJLabel_CurInPat = new LabelBase();
			LJLabel_CurInPat.setText("Current Inpatient");
			LJLabel_CurInPat.setBounds(494, 80, 122, 20);
		}
		return LJLabel_CurInPat;
	}

	public CheckBoxBase getLJCheckBox_CurInPat() {
		if (LJCheckBox_CurInPat == null) {
			LJCheckBox_CurInPat = new CheckBoxBase() {
				@Override
				public void onClick() {
					if (LJCheckBox_CurInPat.isSelected()) {
						getLJCombo_RegType().setText("I");
					}
				}
			};
			LJCheckBox_CurInPat.setBounds(590, 80, 20, 20);
		}
		return LJCheckBox_CurInPat;
	}

	private LabelBase getLJLabel_Ward() {
		if (LJLabel_Ward == null) {
			LJLabel_Ward = new LabelBase();
			LJLabel_Ward.setText("Ward");
			LJLabel_Ward.setBounds(614, 80, 100, 20);
		}
		return LJLabel_Ward;
	}

	public ComboWard getLJComboBox_Ward() {
		if (LJComboBox_Ward == null) {
			LJComboBox_Ward = new ComboWard(false);
			LJComboBox_Ward.setBounds(650, 80, 85, 20);
		}
		return LJComboBox_Ward;
	}

	private LabelBase getLJLabel_BedCode() {
		if (LJLabel_BedCode == null) {
			LJLabel_BedCode = new LabelBase();
			LJLabel_BedCode.setText("Bed Code");
			LJLabel_BedCode.setBounds(5, 105, 141, 20);
		}
		return LJLabel_BedCode;
	}

	private TextBedSearch getLJText_BedCode() {
		if (LJText_BedCode == null) {
			LJText_BedCode = new TextBedSearch() {
				public void onFocus() {
//					setlcFocus(6);
				};
			};
			LJText_BedCode.setBounds(146, 105, 120, 20);
		}
		return LJText_BedCode;
	}

	private LabelBase getLJLabel_CreateByUsr() {
		if (LJLabel_CreateByUser == null) {
			LJLabel_CreateByUser = new LabelBase();
			LJLabel_CreateByUser.setText("User");
			LJLabel_CreateByUser.setBounds(285, 105, 141, 20);
		}
		return LJLabel_CreateByUser;
	}

	private TextString getLJText_CreateByUsr() {
		if (LJText_CreateByUsr == null) {
			LJText_CreateByUsr = new TextString();
			LJText_CreateByUsr.setBounds(355, 105, 120, 20);
		}
		return LJText_CreateByUsr;
	}

	private LabelBase getLJLabel_Sorting() {
		if (LJLabel_Sorting == null) {
			LJLabel_Sorting = new LabelBase();
			LJLabel_Sorting.setText("Sort");
			LJLabel_Sorting.setBounds(494, 105, 120, 20);
		}
		return LJLabel_Sorting;
	}

	public ComboBoxBase getLJCombo_Sorting() {
		if (LJCombo_Sorting == null) {
			LJCombo_Sorting = new ComboBoxBase();
			LJCombo_Sorting.addItem("", "Default");
			LJCombo_Sorting.addItem("U", "By Create User");
			LJCombo_Sorting.setBounds(614, 105, 120, 20);
		}
		return LJCombo_Sorting;
	}

	private LabelBase getLJLabel_Count() {
		if (LJLabel_Count == null) {
			LJLabel_Count = new LabelBase();
			LJLabel_Count.setText("Count");
			LJLabel_Count.setBounds(655, 410, 39, 20);
		}
		return LJLabel_Count;
	}

	private TextReadOnly getLJText_Count() {
		if (LJText_Count == null) {
			LJText_Count = new TextReadOnly();
			LJText_Count.setText(ZERO_VALUE);
			LJText_Count.setBounds(698, 412, 75, 20);
		}
		return LJText_Count;
	}

	private ButtonBase getLJButton_BDTransfer() {
		if (LJButton_BDTransfer == null) {
			LJButton_BDTransfer = new ButtonBase() {
				@Override
				public void onClick() {
					if (!getListSelectedRow()[GrdCol_regsts].equals("C")) {
						setParameter("PatNo", getListSelectedRow()[GrdCol_patno]);
						setParameter("SlpNo", getListSelectedRow()[GrdCol_slpno]);
						setParameter("From", "srhReg");
						showPanel(new DoctorBedTransfer());
					} else {
						Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_CANCELLED_REGISTRATION);
					}
				}
			};
			LJButton_BDTransfer.setText("Bed/Doctor Transfer", 'T');
			LJButton_BDTransfer.setBounds(45, 435, 165, 25);
		}
		return LJButton_BDTransfer;
	}

	private ButtonBase getLJButton_CancelReg() {
		if (LJButton_CancelReg == null) {
			LJButton_CancelReg = new ButtonBase() {
				@Override
				public void onClick() {
					cancelReg();
				}
			};
			LJButton_CancelReg.setText("Cancel Registration", 'C');
			LJButton_CancelReg.setBounds(215, 435, 165, 25);
		}
		return LJButton_CancelReg;
	}

	private ButtonBase getLJButton_Discharge() {
		if (LJButton_Discharge == null) {
			LJButton_Discharge = new ButtonBase() {
				@Override
				public void onClick() {
					if (getListTable().getRowCount() > 0 && getListTable().getSelectedRow() >= 0) {
						if (!"C".equals(getListTable().getSelectedRowContent()[GrdCol_regsts])) {
							setParameter("RegID", getListSelectedRow()[GrdCol_regid]);
							setParameter("SlpNo", getListSelectedRow()[GrdCol_slpno]);
							showPanel(new RegistrationDischarge());
						} else {
							Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_CANCELLED_REGISTRATION);
						}
					}
				}
			};
			LJButton_Discharge.setText("Discharge", 'D');
			LJButton_Discharge.setBounds(385, 435, 165, 25);
		}
		return LJButton_Discharge;
	}

	private ButtonBase getLJButton_PrtILRpt() {
		if (LJButton_PrtILRpt == null) {
			LJButton_PrtILRpt = new ButtonBase() {
				@Override
				public void onClick() {
					showPrtILRptDlg();
				}
			};
			LJButton_PrtILRpt.setText("Print IP Listing Report", 'I');
			LJButton_PrtILRpt.setBounds(555, 435, 165, 25);
		}
		return LJButton_PrtILRpt;
	}

	protected void showPrtILRptDlg() {
		final DialogBase jdialog = new DialogBase(getMainFrame(),
				350, 150);
		final RadioButtonBase wOpt = new RadioButtonBase();
		final RadioButtonBase nOpt = new RadioButtonBase();
		BasePanel PrtILRptPanel = new BasePanel();
		ButtonBase prtButton = new ButtonBase() {
			@Override
			public void onClick() {
				String sortBy = null;
				if (wOpt.isSelected()) {
					sortBy = "bed";

					Map<String,String> map = new HashMap<String,String>();
					map.put("SteCode",getUserInfo().getSiteCode());
					PrintingUtil.print("[Default Printer]","RptIPListingWONat",
							map,null,
							new String[] {getUserInfo().getSiteCode(), sortBy},
							new String[] {"STENAME","WRDCODE","BEDCODE"
							,"EXTPHONE","ACMCODE","PATFNAME"
							,"PATGNAME","PATCNAME","PATNO"
							,"PATSEX","PATBDATE","DOCCODE"
							,"DOCFNAME","DOCGNAME","REGDATE"
							,"RELIGIOUS","MOTHCODE","REGTIME"
							,"AGE","PRTDATE", "RACDESC"});

					jdialog.setVisible(false);
				} else if (nOpt.isSelected()) {
					sortBy = "racdesc";

					Map<String,String> map = new HashMap<String,String>();
					map.put("SteCode",getUserInfo().getSiteCode());
					PrintingUtil.print("[Default Printer]","RptIPListing",
							map,null,
							new String[] {getUserInfo().getSiteCode(), sortBy},
							new String[] {"STENAME","WRDCODE","BEDCODE"
							,"EXTPHONE","ACMCODE","PATFNAME"
							,"PATGNAME","PATCNAME","PATNO"
							,"PATSEX","PATBDATE","DOCCODE"
							,"DOCFNAME","DOCGNAME","REGDATE"
							,"RELIGIOUS","MOTHCODE","REGTIME"
							,"AGE","PRTDATE", "RACDESC"});

					jdialog.setVisible(false);
				}

			}
		};
		ButtonBase cclButton = new ButtonBase() {
			@Override
			public void onClick() {
				jdialog.setVisible(false);
			}
		};
		LabelBase lSort = new LabelBase("Sort By");
		lSort.setBounds(150, 120, 50, 20);

		jdialog.setTitle("Print IP Listing Report");
		wOpt.setBoxLabel("Sort by Ward and Bed(W/O Nationality)");
		wOpt.setSelected(true);
		nOpt.setBoxLabel("Sort by Nationality(With Nationality)");
		nOpt.setTitle("");
		wOpt.setBounds(50, 20, 100, 20);
		nOpt.setBounds(50, 50, 100, 20);

		prtButton.setText("Print");
		cclButton.setText("Cancel");

		PrtILRptPanel.setSize(460, 250);
		prtButton.setBounds(50, 80, 50, 20);
		cclButton.setBounds(120, 80, 50, 20);

		PrtILRptPanel.add(wOpt, null);
		PrtILRptPanel.add(nOpt, null);
		PrtILRptPanel.add(prtButton, null);
		PrtILRptPanel.add(cclButton, null);

		jdialog.add(PrtILRptPanel, null);

		jdialog.setResizable(false);
		jdialog.setVisible(true);
		wOpt.focus();
	}

	private ButtonBase getLJButton_PrtLbl() {
		if (LJButton_PrtLbl == null) {
			LJButton_PrtLbl = new ButtonBase() {
				@Override
				public void onClick() {
					// ensure searchAction is initialized before prtLbl() get the patno
					Timer timer = new Timer() {
						 @Override
						 public void run() {
							 prtLbl();
						 }
					 };
					 timer.schedule(100);
				}
			};
			LJButton_PrtLbl.setText("Print Label(DOB)", 'L');
			LJButton_PrtLbl.setBounds(45, 465, 165, 25);
		}
		return LJButton_PrtLbl;
	}

	protected void prtLbl() {
		String patNo = getDefaultPatientNumber();
		if (patNo != null && patNo.length() > 0) {
			getDlgNoOfLblToBePrtOutp().showDialog(patNo, null, null, null, false);
		} else {
			Factory.getInstance().addErrorMessage("Please supply Patient Number.", getLJText_PatNo());
		}
	}

	private ButtonBase getLJButton_NewSlipInpat() {
		if (LJButton_NewSlipInpat == null) {
			LJButton_NewSlipInpat = new ButtonBase() {
				@Override
				public void onClick() {
					if (getListTable().getSelectedRow() >= 0) {
						newSlip();
					}
				}
			};
			LJButton_NewSlipInpat.setText("New Slip for Inpatient", 'N');
			LJButton_NewSlipInpat.setBounds(215, 465, 165, 25);
		}
		return LJButton_NewSlipInpat;
	}

	private ButtonBase getLJButton_IPGenLbl() {
		if (LJButton_IPGenLbl == null) {
			LJButton_IPGenLbl = new ButtonBase() {
				@Override
				public void onClick() {
					// ensure searchAction is initialized before iPGenLbl() get the patno
					Timer timer = new Timer() {
						 @Override
						 public void run() {
							 iPGenLbl();
						 }
					 };
					 timer.schedule(100);
				}
			};
			LJButton_IPGenLbl.setText("IP/OP General Label(DOB)", 'G');
			LJButton_IPGenLbl.setBounds(385, 465, 165, 25);
		}
		return LJButton_IPGenLbl;
	}

	private void iPGenLbl() {
		String patNo = getDefaultPatientNumber();
		if (patNo != null && patNo.length() > 0) {
			String regId = null;
			String regType = null;
			String regDate = null;
			if (getListTable().getSelectedRow() > -1 &&
					getListTable().getSelectedRowContent() != null &&
					!getListTable().getSelectedRowContent()[GrdCol_regtype].toUpperCase().equals("O")) {
				regId = getListTable().getSelectedRowContent()[GrdCol_regid];
				regType = getListTable().getSelectedRowContent()[GrdCol_regtype];
				regDate = getListTable().getSelectedRowContent()[GrdCol_regdate];
			}
			getDlgNoOfLblToBePrtInp().showDialog(patNo, regId, regType, regDate, false);
		} else {
			Factory.getInstance().addErrorMessage("Please supply Patient Number.", getLJText_PatNo());
		}
	}

	private ButtonBase getLJButton_PatLbl() {
		if (LJButton_PatLbl == null) {
			LJButton_PatLbl = new ButtonBase() {
				@Override
				public void onClick() {
					String patNo = getDefaultPatientNumber();
					if (patNo != null && patNo.length() > 0) {
						final boolean isasterisk = "YES".equals(getSysParameter("Chk*"));
						final boolean isChkDigit = "YES".equals(getSysParameter("ChkDigit"));
						String tempChkDigit = "#";
						if (isChkDigit) {
							if (patNo.length() > 0) {
								tempChkDigit = PrintingUtil.generateCheckDigit(patNo).toString()+"#";
							}
						}
						final String checkDigit = tempChkDigit;
						if (Integer.parseInt(getSysParameter("NOPATLABEL")) > 0) {
							QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.REGSEARCHPRINTDOB,
									new String[] { patNo },
									new MessageQueueCallBack() {
								@Override
								public void onPostSuccess(MessageQueue mQueue) {
									if (mQueue.success()) {
										HashMap<String, String> map = new HashMap<String, String>();
										map.put("stecode", mQueue.getContentField() [0] + (isasterisk ? "*" : ""));
										map.put("patno", mQueue.getContentField()[1]);
										map.put("name", mQueue.getContentField()[2]);
										map.put("patsex", mQueue.getContentField()[5]);
										map.put("patno1", mQueue.getContentField()[1] + (isChkDigit ? checkDigit : "#"));
										String patcname =  mQueue.getContentField()[3];

										PrintingUtil.print(getSysParameter("PRTRLBL"),
												"PatientLabel", map, patcname,
												Integer.parseInt(getSysParameter("NOPATLABEL")));
									} else {
										Factory.getInstance().addErrorMessage("Invalid Patient Number.", getLJText_PatNo());
									}
								}
							});
						}
					} else {
						Factory.getInstance().addErrorMessage("Please supply Patient Number.", getLJText_PatNo());
					}
				}
			};
			LJButton_PatLbl.setText("Patient Label", 'P');
			LJButton_PatLbl.setBounds(555, 465, 165, 25);
		}
		return LJButton_PatLbl;
	}

	private ButtonBase getLJButton_WrtBdLbl() {
		if (LJButton_WrtBdLbl == null) {
			LJButton_WrtBdLbl = new ButtonBase() {
				@Override
				public void onClick() {
					String patNo = getDefaultPatientNumber();
					if (patNo != null && patNo.length() > 0) {
						getDlgPrintWristbandLabel().showDialog(patNo);
					} else {
						Factory.getInstance().addErrorMessage("Please supply Patient Number.", getLJText_PatNo());
					}
				}
			};

			LJButton_WrtBdLbl.setText("Print Wristband Label", 'W');
			LJButton_WrtBdLbl.setBounds(45, 495, 165, 25);
		}
		return LJButton_WrtBdLbl;
	}

	private ButtonBase getLJButton_RegSht() {
		if (LJButton_RegSht == null) {
			LJButton_RegSht = new ButtonBase() {
				@Override
				public void onClick() {
					final DialogBase jdialog = new DialogBase(getMainFrame(),
							500, 250);
					final RadioButtonBase hhlgtedOpt = new RadioButtonBase();
					final RadioButtonBase allOpt = new RadioButtonBase();
					BasePanel PrtRegShtPanel = new BasePanel();
					ButtonBase prtButton = new ButtonBase() {
						@Override
						public void onClick() {
							if (hhlgtedOpt.isSelected()) {
								printRpt(true);
							}
							if (allOpt.isSelected()) {
								printRpt(false);
							}
							jdialog.setVisible(false);
						}
					};
					ButtonBase cclButton = new ButtonBase() {
						@Override
						public void onClick() {
							jdialog.setVisible(false);
						}
					};
					jdialog.setTitle("Print Registration Sheet");
					allOpt.setBoxLabel("All filtered Registrations");
					hhlgtedOpt.setBoxLabel("Highlighted Registration");
					hhlgtedOpt.setSelected(true);
					allOpt.setTitle("");
					prtButton.setText("Print");
					cclButton.setText("Cancel");

					PrtRegShtPanel.setSize(460, 200);
					prtButton.setBounds(150, 120, 50, 20);
					cclButton.setBounds(220, 120, 50, 20);
					hhlgtedOpt.setBounds(150, 50, 180, 20);
					allOpt.setBounds(150, 80, 180, 20);

					PrtRegShtPanel.add(hhlgtedOpt, null);
					PrtRegShtPanel.add(allOpt, null);
					PrtRegShtPanel.add(prtButton, null);
					PrtRegShtPanel.add(cclButton, null);

					jdialog.add(PrtRegShtPanel, null);

					jdialog.setResizable(false);
					jdialog.setVisible(true);
				}
			};
			LJButton_RegSht.setText("Print Reg Sheet", 'R');
			LJButton_RegSht.setBounds(215, 495, 165, 25);
		}
		return LJButton_RegSht;
	}

	private ButtonBase getLJButton_ViewSupp() {
		if (LJButton_ViewSupp == null) {
			LJButton_ViewSupp = new ButtonBase() {
				@Override
				public void onClick() {
					if (getListTable().getRowCount() == 0 || getListTable().getSelectedRow() < 0) {
						return;
					}

					QueryUtil.executeMasterFetch(getUserInfo(),
							ConstantsTx.LOOKUP_TXCODE, new String[] {
									"patient",
									"patsex,to_char(patbdate,'dd/mm/yyyy')",
									"patno='" + getListTable().getSelectedRowContent()[GrdCol_patno] + "'" },
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							final String patSex = mQueue.getContentField()[0];
							final String patDOB = mQueue.getContentField()[1];
							QueryUtil.executeMasterBrowse(getUserInfo(), "Item_Withsupp",
									new String[] { getListTable().getSelectedRowContent()[GrdCol_patno] },
									new MessageQueueCallBack() {
								@Override
								public void onPostSuccess(
										MessageQueue mQueue) {
									if (mQueue.success() && mQueue.getContentField().length > 0) {
										DlgViewSupp jdialog = new DlgViewSupp(
												getMainFrame(),
												getListTable().getSelectedRowContent()[GrdCol_bedcode],
												getListTable().getSelectedRowContent()[GrdCol_patno],
												getListTable().getSelectedRowContent()[GrdCol_patsname]
														+ " "
														+ getListTable().getSelectedRowContent()[GrdCol_patgname],
												getListTable().getSelectedRowContent()[GrdCol_patcname],
												getListTable().getSelectedRowContent()[GrdCol_adm],
												patSex,
												patDOB);
										jdialog.setResizable(false);
										jdialog.setVisible(true);
									} else {
										Factory.getInstance().addErrorMessage("No Supplementary Record!");
									}
								}
							});
						}
					});
				}
			};
			LJButton_ViewSupp.setText("View Supp", 'S');
			LJButton_ViewSupp.setBounds(385, 495, 165, 25);
		}
		return LJButton_ViewSupp;
	}

	/**
	 * @return the lJButton_TransBedLbl
	 */
	private ButtonBase getLJButton_TransBedLbl() {
		if (LJButton_TransBedLbl == null) {
			LJButton_TransBedLbl = new ButtonBase() {
				@Override
				public void onClick() {
					getDlgTransferBedLabel().showDialog(
							getListTable().getSelectedRowContent()[GrdCol_patno],
							getListTable().getSelectedRowContent()[GrdCol_regid],
							getListTable().getSelectedRowContent()[GrdCol_sex],
							getListTable().getSelectedRowContent()[GrdCol_bedcode]);
				}
			};
			LJButton_TransBedLbl.setText("Transfer Bed Label", 'B');
			LJButton_TransBedLbl.setBounds(555, 495, 165, 25);
		}
		return LJButton_TransBedLbl;
	}

	/**
	 * @return the dlgTransferBedLabel
	 */
	private DlgTransferBedLabel getDlgTransferBedLabel() {
		if (dlgTransferBedLabel == null) {
			dlgTransferBedLabel = new DlgTransferBedLabel(getMainFrame());
		}
		return dlgTransferBedLabel;
	}

	private ButtonBase getLJButton_PEDLbl() {
		if (LJButton_PEDLbl == null) {
			LJButton_PEDLbl = new ButtonBase() {
				@Override
				public void onClick() {
					String patNo = getListTable().getSelectedRowContent()[GrdCol_patno];
					final boolean isasterisk = "YES".equals(getSysParameter("Chk*"));
					final boolean isChkDigit = "YES".equals(getSysParameter("ChkDigit"));
					String tempChkDigit = "#";
					if (isChkDigit) {
						if (patNo.length() > 0) {
							tempChkDigit = PrintingUtil.generateCheckDigit(patNo).toString()+"#";
						}
					}
					final String checkDigit = tempChkDigit;
					HashMap<String, String> map = new HashMap<String, String>();
					map.put("patNo", getListTable().getSelectedRowContent()[GrdCol_patno]+ (isChkDigit ? checkDigit : "#"));
					map.put("patNo1", getListTable().getSelectedRowContent()[GrdCol_patno]);
					map.put("patSName", getListTable().getSelectedRowContent()[GrdCol_patsname]);
					map.put("patFName", getListTable().getSelectedRowContent()[GrdCol_patgname]);
					String patcname =  getListTable().getSelectedRowContent()[GrdCol_patcname];

					PrintingUtil.print("[Default Printer]","PEDLbl_A5", map, patcname,1);

				}
			};

			LJButton_PEDLbl.setText("Print PED Label", 'E');
			LJButton_PEDLbl.setBounds(45, 525, 165, 25);
		}
		return LJButton_PEDLbl;
	}

	private ButtonBase getLJButton_AppLbl() {
		if (LJButton_AppLbl == null) {
			LJButton_AppLbl = new ButtonBase() {
				@Override
				public void onClick() {
					if (getListTable().getSelectedRow() >= 0 && !"".equals(getListTable().getSelectedRowContent()[GrdCol_regid])) {
						String tempChkDigit = "#";
						if ("YES".equals(getSysParameter("ChkDigit"))) {
								tempChkDigit = PrintingUtil.generateCheckDigit(
										getListTable().getSelectedRowContent()[GrdCol_patno].trim()).toString()+"#";
						}
						Map<String,String> mapGeneral = new HashMap<String,String>();

						mapGeneral.put("outPatType", getListTable().getSelectedRowContent()[GrdCol_regtype]);
						mapGeneral.put("newbarcode", getListTable().getSelectedRowContent()[GrdCol_patno] + tempChkDigit);

							mapGeneral.put("TicketGenMth", getSysParameter("TicketGen"));
							mapGeneral.put("isasterisk",
									String.valueOf("YES".equals(getMainFrame().getSysParameter("Chk*"))));

							PrintingUtil.print(getSysParameter("PRTRLBL"),
												"DIAPPLABEL", mapGeneral, null,
												new String[] { getListTable().getSelectedRowContent()[GrdCol_patno],
																getListTable().getSelectedRowContent()[GrdCol_regid]},
												new String[] {
														"stecode", "patno", "patname",
														"patcname", "patbdate", "patsex",
														"docname", "regdate", "admdate",
														"regcat", "regcount", "ticketno",
														"regtype"
												});
					} else {
						Factory.getInstance().addErrorMessage("Please select an appointment to print.");
					}

				}
			};

			LJButton_AppLbl.setText("Print App Label");
			LJButton_AppLbl.setBounds(215, 525, 165, 25);
		}
		return LJButton_AppLbl;
	}
	
	private ButtonBase getLJButton_PhysicalForm() {
		if (LJButton_PhysicalForm == null) {
			LJButton_PhysicalForm = new ButtonBase() {
				@Override
				public void onClick() {
					if (getListTable().getSelectedRow() >= 0 && !"".equals(getListTable().getSelectedRowContent()[GrdCol_regid]) 
							&& "O".equals(getListTable().getSelectedRowContent()[GrdCol_regtype].toUpperCase())) {
						final String regid = getListTable().getSelectedRowContent()[GrdCol_regid];
						
						QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
								new String[] { "REG R, PATIENT P, DOCTOR D, GOVREG G, GOVJOB J, ARCODE A ", 
								"R.REGID,P.PATNO,INITCAP(CONCAT(P.PATFNAME,(' '||P.PATGNAME))),P.PATIDNO,TO_CHAR(P.PATBDATE,'dd/MM/YYYY'),P.PATSEX,INITCAP(CONCAT(('DR. '||D.DOCFNAME),(' '||D.DOCGNAME))),TO_CHAR(R.REGDATE,'dd/MM/YYYY HH24:MM'),INITCAP(A.ARCNAME),J.GOVPOSITION,TO_CHAR(R.REGDATE+5,'dd/MM/YYYY'),P.PATCNAME ",
								"R.PATNO=P.PATNO AND R.DOCCODE=D.DOCCODE AND R.REGID='" + regid +"' AND R.REGID=G.REGID AND J.GOVJOBCODE=G.GOVJOBCODE AND J.ARCCODE=A.ARCCODE "},
								new MessageQueueCallBack() {
									
									@Override
									public void onPostSuccess(MessageQueue mQueue) {
										if (mQueue.success()) {
											
											/*Check digit*/
											String newbarcode = mQueue.getContentField()[1] + ("YES".equals(getSysParameter("ChkDigit")) ? 
													PrintingUtil.generateCheckDigit(mQueue.getContentField()[1]).toString()+"#" : "#");
											
											HashMap<String, String> map = new HashMap<String, String>();
											map.put("regid", mQueue.getContentField()[0]);
											map.put("patno", mQueue.getContentField()[1]);
											map.put("name", mQueue.getContentField()[2]);
											map.put("sex", mQueue.getContentField()[5]);
											map.put("dob", mQueue.getContentField()[4]);
											map.put("hkid", mQueue.getContentField()[3]);
											map.put("orderDate", mQueue.getContentField()[7]);
											map.put("docName", mQueue.getContentField()[6]);
											map.put("govDept", mQueue.getContentField()[8]);
											map.put("govPosition", mQueue.getContentField()[9]);
											map.put("reportDueDate", mQueue.getContentField()[10]);
											String patcname = mQueue.getContentField()[11];
										
											map.put("SUBREPORT_DIR", CommonUtil.getReportDir());
											map.put("LogoImg", CommonUtil.getReportImg("Horizontal_billingual_HKAH_TW.jpg"));
											map.put("BreastImg", CommonUtil.getReportImg("breast.jpg"));
											map.put("userID", Factory.getInstance().getUserInfo().getUserID());
											map.put("userName", Factory.getInstance().getUserInfo().getUserName());
											map.put("newbarcode", newbarcode);
											
											PrintingUtil.print(
													"PHYORDERFORM_DEPT", 									
													map, 													
													patcname,													
													new String[]{mQueue.getContentField()[0]},									
													new String[]{"DPTCODE","DPTNAME","ITMCODE","ITMNAME","DSCCODE","DSCDESC"}	
												);
											PrintingUtil.print(
													"PHYORDERFORM_MR", 
													map, 
													patcname,
													new String[]{mQueue.getContentField()[0]},					
													new String[]{"DPTCODE","DPTNAME","ITMCODE","ITMNAME","GUIDELINE"},	
													2,
													new String[] {"PHYORDERFORM_MR_SUB1","PHYORDERFORM_MR_SUB2"},
													new String[][] {
														{ mQueue.getContentField()[0] },
														{ mQueue.getContentField()[0] }
													},
													new String[][] {
														{ "ITMCODE","ITMNAME","GUIDELINE","GLCCODE" },
														{ "DPTCODE","DPTNAME" }
													},
													new boolean[][] {
														{ false, false, false, false },
														{ false, false }
													}, 1);
										} else {
											QueryUtil.executeMasterFetch(getUserInfo(), "PHYSICALORDERFORM",
													new String[] { regid , null},
													new MessageQueueCallBack() {
														
														@Override
														public void onPostSuccess(MessageQueue mQueue) {
															if (mQueue.success()) {
																
																/*Check digit*/
																String newbarcode = mQueue.getContentField()[1] + ("YES".equals(getSysParameter("ChkDigit")) ? 
																		PrintingUtil.generateCheckDigit(mQueue.getContentField()[1]).toString()+"#" : "#");
																
																HashMap<String, String> map = new HashMap<String, String>();
																map.put("regid", mQueue.getContentField()[0]);
																map.put("patno", mQueue.getContentField()[1]);
																map.put("name", mQueue.getContentField()[2]);
																map.put("sex", mQueue.getContentField()[3]);
																map.put("dob", mQueue.getContentField()[4]);
																map.put("hkid", mQueue.getContentField()[5]);
																map.put("docName", mQueue.getContentField()[6]);
																map.put("orderDate", mQueue.getContentField()[7]);
																map.put("pkgCode", mQueue.getContentField()[8]);
																map.put("pkgName", mQueue.getContentField()[9]);
																String patcname = mQueue.getContentField()[10];
																
																map.put("SUBREPORT_DIR", CommonUtil.getReportDir());																
																map.put("LogoImg", CommonUtil.getReportImg("Horizontal_billingual_HKAH_TW.jpg"));
																map.put("BreastImg", CommonUtil.getReportImg("breast.jpg"));
																map.put("userID", Factory.getInstance().getUserInfo().getUserID());
																map.put("userName", Factory.getInstance().getUserInfo().getUserName());
																map.put("newbarcode", newbarcode);
																
																
																PrintingUtil.print(
																		"PHYORDERFORM", 										
																		map, 													
																		patcname,													
																		new String[]{ mQueue.getContentField()[8] },								
																		new String[]{"DPTCODE","DPTNAME","ITMCODE","ITMNAME","NUM","DSCCODE","DSCDESC"}	
																	);
																
															} else {
																Factory.getInstance().addErrorMessage("No Physical Checkup Order Form to be print.");
															}
														}
											});
										}
									}
								});
					} else {
						Factory.getInstance().addErrorMessage("No Physical Checkup Order Form to be print.");
					}
				}
			};

			LJButton_PhysicalForm.setText("Print Checkup Order Form");
			LJButton_PhysicalForm.setBounds(385, 525, 165, 25);
		}
		return LJButton_PhysicalForm;
	}

	@Override
	protected boolean triggerSearchField() {
		if (getLJText_PatNo().isFocusOwner()) {
			getLJText_PatNo().checkTriggerBySearchKey();
			return true;
		} else if (getLJText_DocCode().isFocusOwner()) {
			getLJText_DocCode().checkTriggerBySearchKey();
			return true;
		} else {
			return false;
		}
	}
}
