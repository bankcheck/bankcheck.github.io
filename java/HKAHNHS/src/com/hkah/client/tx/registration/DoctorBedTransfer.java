package com.hkah.client.tx.registration;

import java.util.Date;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.form.TextField;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.panel.TabbedPaneBase;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextBedSearch;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextDateTime;
import com.hkah.client.layout.textfield.TextDoctorSearch;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.ActionPanel;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.PanelUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTransaction;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DoctorBedTransfer extends ActionPanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		if (getTabbedPane().getSelectedIndex() == 0) {
			return ConstantsTx.DOCCHGHIS_TXCODE;
		} else {
			return ConstantsTx.BEDCHGHIS_TXCODE;
		}
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.DOCTORBEDTRANSFER_TITLE;

	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {};
	}

	private BasePanel actionPanel = null;

	private BasePanel ParaPanel = null;
	private LabelBase PatientNoDesc = null;
	private TextPatientNoSearch PatientNo = null;
	private TextReadOnly FullName = null;
	private TextReadOnly ChiName = null;
	private LabelBase SlipNoDesc = null;
	private TextString SlipNo = null;
	private LabelBase AdmDateDesc = null;
	private TextReadOnly AdmDate = null;
	private LabelBase DischangeDateDesc = null;
	private TextReadOnly DischangeDate = null;

	private TabbedPaneBase TabbedPane = null;
	private BasePanel DCHistoryPanel = null;
	private LabelBase DDoctorCodeDesc = null;
	private TextDoctorSearch DDoctorCode = null;
	private TextReadOnly DDocFullName = null;
	private TextReadOnly DDocCName = null;
	private LabelBase DStartDateDesc = null;
	private TextDate DStartDate = null;
	private LabelBase DEndDateDesc = null;
	private TextReadOnly DEndDate = null;
	private TableList DListTable = null;
	private JScrollPane DJScrollPane = null;

	private BasePanel BCHistoryPanel = null;
	private LabelBase BBedCodeDesc = null;
//	private TextString BBedCode = null;
	private TextBedSearch BBedCode = null;
	private LabelBase BStartDateDesc = null;
	private TextDateTime BStartDate = null;
	private LabelBase BEndDateDesc = null;
	private TextReadOnly BEndDate = null;
	private TableList BListTable = null;
	private JScrollPane BJScrollPane = null;

	private String memSLPNO = EMPTY_VALUE;
	private String memPATNO = EMPTY_VALUE;
	private String memREGID = EMPTY_VALUE;
	private String memRLock = EMPTY_VALUE;

	/**
	 * This method initializes
	 *
	 */
	public DoctorBedTransfer() {
		super();
	}

	@Override
	protected void proExitPanel() {
		if (memRLock.length() > 0) {
			CommonUtil.unlockRecord(getUserInfo(), "Slip", memRLock);
		}
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		getTabbedPane().setSelectedIndexWithoutStateChange(0);

		refreshAction();
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextField getDefaultFocusComponent() {
		if (isAppend() || isModify()) {
			if (getTabbedPane().getSelectedIndex() == 0) {
				return getDDoctorCode();
			} else {
				return getBBedCode();
			}
		}
		return getSlipNo();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {
		setFieldEditable(true);
	}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
		setFieldEditable(true);
	}

	/* >>> ~13~ Set Disable Fields When Delete ButtonBase Is Clicked ====== <<< */
	@Override
	protected void deleteDisabledFields() {
	}

	/* >>> ~14~ Set Browse Validation ===================================== <<< */
	@Override
	protected boolean browseValidation() {
		if (getSlipNo().isEmpty()) {
			Factory.getInstance().addErrorMessage(MSG_MISSED_SLIPNO, getSlipNo());
			return false;
		} else {
			return true;
		}
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] { memREGID };
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
		if (getTabbedPane().getSelectedIndex() == 0) {
			getDDoctorCode().setText(outParam[3]);
			getDDocFullName().setText(outParam[4]);
			getDDocCName().setText(outParam[5]);
			getDStartDate().setText(outParam[1]);
			getDEndDate().setText(outParam[2]);
		} else {
			getBBedCode().setText(outParam[3]);
			getBStartDate().setText(outParam[1]);
			getBEndDate().setText(outParam[2]);
		}
	}

	/* >>> ~15~ Set Fetch Output Results ============================== <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		String[] param = null;
		if (getTabbedPane().getSelectedIndex() == 0) {
			if (getDListTable().getSelectedRow() > 0) {
				int prevRow = getDListTable().getSelectedRow() - 1;

				if (isAppend()) {
					param = new String[] {
									getDListTable().getValueAt(prevRow, 9),
									getDListTable().getValueAt(prevRow, 10),
									getDListTable().getValueAt(prevRow, 11),
									getDListTable().getValueAt(prevRow, 3),
									getDListTable().getValueAt(prevRow, 1),
									getDListTable().getSelectedRowContent()[1],//next row start date
									getDListTable().getSelectedRowContent()[9],
									getDListTable().getSelectedRowContent()[10],
									getDListTable().getSelectedRowContent()[11],
									getDListTable().getSelectedRowContent()[3],
									getDListTable().getSelectedRowContent()[1],
									getDischangeDate().getText().isEmpty()?
											"":getDischangeDate().getText().substring(0, 10),
									Factory.getInstance().getUserInfo().getUserID()
							};
				} else {
					param = new String[] {
									getDListTable().getValueAt(prevRow, 9),
									getDListTable().getValueAt(prevRow, 10),
									getDListTable().getValueAt(prevRow, 11),
									getDListTable().getValueAt(prevRow, 3),
									getDListTable().getValueAt(prevRow, 1),
									getDListTable().getSelectedRowContent()[1],//next row start date
									getDListTable().getSelectedRowContent()[9],
									getDListTable().getSelectedRowContent()[10],
									getDListTable().getSelectedRowContent()[11],
									getDListTable().getSelectedRowContent()[3],
									getDListTable().getSelectedRowContent()[1],
									getDListTable().getSelectedRowContent()[2],
									Factory.getInstance().getUserInfo().getUserID()
							};
				}
			} else {
				param = new String[] {
								null,
								null,
								null,
								null,
								null,
								null,//next row start date
								getDListTable().getSelectedRowContent()[9],
								getDListTable().getSelectedRowContent()[10],
								getDListTable().getSelectedRowContent()[11],
								getDListTable().getSelectedRowContent()[3],
								getDListTable().getSelectedRowContent()[1],
								getDListTable().getSelectedRowContent()[2],
								Factory.getInstance().getUserInfo().getUserID()
						};
			}
		} else if (getTabbedPane().getSelectedIndex() == 1) {
			if (getBListTable().getSelectedRow() > 0) {
				int prevRow = getBListTable().getSelectedRow() - 1;

				if (isAppend()) {
					param = new String[] {
									getBListTable().getValueAt(prevRow, 7),
									getBListTable().getValueAt(prevRow, 8),
									getBListTable().getValueAt(prevRow, 9),
									getBListTable().getValueAt(prevRow, 3),
									getBListTable().getValueAt(prevRow, 1),
									getBListTable().getSelectedRowContent()[1],
									getBListTable().getSelectedRowContent()[7],
									getBListTable().getSelectedRowContent()[8],
									getBListTable().getSelectedRowContent()[9],
									getBListTable().getSelectedRowContent()[3],
									getBListTable().getSelectedRowContent()[1],
									getDischangeDate().getText().isEmpty()?
											"":getDischangeDate().getText().substring(0, 10) + " 00:00:00",
									Factory.getInstance().getUserInfo().getUserID()
								};
				} else {
					param = new String[] {
								getBListTable().getValueAt(prevRow, 7),
								getBListTable().getValueAt(prevRow, 8),
								getBListTable().getValueAt(prevRow, 9),
								getBListTable().getValueAt(prevRow, 3),
								getBListTable().getValueAt(prevRow, 1),
								getBListTable().getSelectedRowContent()[1],
								getBListTable().getSelectedRowContent()[7],
								getBListTable().getSelectedRowContent()[8],
								getBListTable().getSelectedRowContent()[9],
								getBListTable().getSelectedRowContent()[3],
								getBListTable().getSelectedRowContent()[1],
								getBListTable().getSelectedRowContent()[2],
								Factory.getInstance().getUserInfo().getUserID()
							};
				}
			} else {
				param = new String[] {
							null,
							null,
							null,
							null,
							null,
							null,
							getBListTable().getSelectedRowContent()[7],
							getBListTable().getSelectedRowContent()[8],
							getBListTable().getSelectedRowContent()[9],
							getBListTable().getSelectedRowContent()[3],
							getBListTable().getSelectedRowContent()[1],
							getBListTable().getSelectedRowContent()[2],
							Factory.getInstance().getUserInfo().getUserID()
						};
			}
		}
		return param;
	}

	/* >>> ~16.1~ Set Action Output Parameters =========================== <<< */
	@Override
	protected void getNewOutputValue(String returnValue) {}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(final String actionType) {
		if (getTabbedPane().getSelectedIndex() == 0) {
			// check date
			if (!getDStartDate().isEmpty()) {
				if (!getDStartDate().isValid()) {
					Factory.getInstance().addErrorMessage("Invalid Date Value.", getDStartDate());
					getDStartDate().resetText();
					return;
				}
				else {
					getDStartDate().onBlur();
				}
			} else {
				Factory.getInstance().addErrorMessage("Please enter the Start Date with the format of DD/MM/YYYY.", getDStartDate());
				return;
			}

			if (DateTimeUtil.dateDiff(getDListTable().getSelectedRowContent()[1], getAdmDate().getText().trim().substring(0, 10)) < 0) {
				Factory.getInstance().addErrorMessage("The start date can't be earlier than admission date!", getDStartDate());
				return;
			}

			if (!getDischangeDate().isEmpty()) {
				if (DateTimeUtil.dateDiff(getDListTable().getSelectedRowContent()[1], getDischangeDate().getText().trim().substring(0, 10)) > 0) {
					Factory.getInstance().addErrorMessage("The start date can't be later than discharge date!", getDStartDate());
					return;
				}
			}

			if (getDListTable().getSelectedRow() > 0) {
				if (DateTimeUtil.dateDiff(getDListTable().getSelectedRowContent()[1], getDListTable().getValueAt(getDListTable().getSelectedRow() - 1, 1)) < 0) {
					Factory.getInstance().addErrorMessage("The start date can't be earlier than previous from date!", getDStartDate());
					return;
				}

				if (getDListTable().getSelectedRowContent()[3].equals(getDListTable().getValueAt(getDListTable().getSelectedRow() - 1, 3))) {
					Factory.getInstance().addErrorMessage("Exist duplicate doctor code!", getDDoctorCode());
					return;
				}
			}

			if (isModify() && getDListTable().getRowCount() > (getDListTable().getSelectedRow() + 1)) {
				if (DateTimeUtil.dateDiff(getDListTable().getSelectedRowContent()[1], getDListTable().getValueAt(getDListTable().getSelectedRow() + 1, 1)) > 0) {
					Factory.getInstance().addErrorMessage("The start date can't be later than next from date!", getDStartDate());
					return;
				}

				if (getDListTable().getSelectedRowContent()[3].equals(getDListTable().getValueAt(getDListTable().getSelectedRow() + 1, 3))) {
					Factory.getInstance().addErrorMessage("Exist duplicate doctor code!", getDDoctorCode());
					return;
				}
			}

			if (getDDoctorCode().isEmpty()) {
				Factory.getInstance().addErrorMessage("Empty Doctor Code", getDDoctorCode());
				return;
			}

			QueryUtil.executeMasterBrowse(getUserInfo(),
					ConstantsTx.LOOKUP_TXCODE,
					new String[] {
									"doctor",
									"doccode, docfname || ' ' || docgname, doccname",
									"DocCode = '" + getDDoctorCode().getText() + "' and docsts=-1"
								 },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						if (mQueue.getContentLineCount() > 0) {
							actionValidationReady(actionType, true);
						}
					} else {
						Factory.getInstance().addErrorMessage(MSG_WRONG_DOCCODE, getDDoctorCode());
					}
				}
			});
		} else if (getTabbedPane().getSelectedIndex() == 1) {
			if (!getBStartDate().isEmpty()) {
				if (!getBStartDate().validate()) {
					Factory.getInstance().addErrorMessage("Invalid Date Value.", getBStartDate());
					getBStartDate().resetText();
					return;
				}
				else {
					getBStartDate().onBlur();
				}
			} else {
				Factory.getInstance().addErrorMessage("Invalid Date!", getBStartDate());
				return;
			}

			if (getBListTable().getSelectedRowContent()[1].trim().length() == 0) {
				getBStartDate().focus();
				return;
			}

			if (DateTimeUtil.dateTimeDiff(getBListTable().getSelectedRowContent()[1], getAdmDate().getText().trim()) < 0) {
				Factory.getInstance().addErrorMessage("The start date can't be earlier than admission date!", getBStartDate());
				return;
			}

			if (!getDischangeDate().isEmpty()) {
				if (DateTimeUtil.dateTimeDiff(getBListTable().getSelectedRowContent()[1], getDischangeDate().getText().trim()) > 0) {
					Factory.getInstance().addErrorMessage("The start date can't be later than discharge date!", getBStartDate());
					return;
				}
			}

			if (getBListTable().getSelectedRow() > 0) {
				if (DateTimeUtil.dateTimeDiff(getBListTable().getSelectedRowContent()[1], getBListTable().getValueAt(getBListTable().getSelectedRow() - 1, 1)) < 0) {
					Factory.getInstance().addErrorMessage("The start date can't be earlier than previous from date!", getBStartDate());
					return;
				}

				if (getBListTable().getSelectedRowContent()[3].equals(getBListTable().getValueAt(getBListTable().getSelectedRow() - 1, 3))) {
					Factory.getInstance().addErrorMessage("Exist duplicate bed code!", getBBedCode());
					return;
				}
			}

			if (isModify() && getBListTable().getRowCount() > (getBListTable().getSelectedRow() + 1)) {
				if (DateTimeUtil.dateTimeDiff(getBListTable().getSelectedRowContent()[1], getBListTable().getValueAt(getBListTable().getSelectedRow() + 1, 1)) > 0) {
					Factory.getInstance().addErrorMessage("The start date can't be later than next from date!", getDStartDate());
					return;
				}

				if (getBListTable().getSelectedRowContent()[3].equals(getBListTable().getValueAt(getBListTable().getSelectedRow() + 1, 3))) {
					Factory.getInstance().addErrorMessage("Exist duplicate bed code!", getBBedCode());
					return;
				}
			}

			if (getBBedCode().isEmpty()) {
				Factory.getInstance().addErrorMessage("Empty Bed Code", getBBedCode());
				return;
			}

			QueryUtil.executeMasterFetch(getUserInfo(),
					ConstantsTx.LOOKUP_TXCODE,
					new String[] {
									"bed b, room r, acm a, ward w",
									"b.bedcode, a.acmcode, w.dptcode, w.wrdname ",
									"b.romcode = r.romcode AND r.acmcode = a.acmcode AND w.wrdcode = r.wrdcode AND b.bedcode = '" + getBBedCode().getText() + "'"
								},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						if (mQueue.getContentLineCount() > 0) {
							actionValidationReady(actionType, true);
						}
					} else {
						Factory.getInstance().addErrorMessage(MSG_WRONG_BEDCODE, getBBedCode());
					}
				}
			});
		}
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	private void showInfo() {
		if (getParameter("PatNo") != null) {
			getPatientNo().setText(getParameter("PatNo"));
			getPatientNo().setOriginalValue(getParameter("PatNo"));
		}
		if ("srhReg".equals(getParameter("From")) || "regPatReg".equals(getParameter("From"))||"regDischarge".equals(getParameter("From"))) {
			getSlipNo().setText(getParameter("SlpNo"));
		}

		memPATNO = getPatientNo().getText();
		memSLPNO = getSlipNo().getText();

		fillSlpFields();
		showDetail();
	}

	private void fillPatFields(String patNo) {
		if (patNo.length() > 0) {
			getPatientNo().setText(patNo);
			getPatientNo().setOriginalValue(patNo);
			QueryUtil.executeMasterFetch(
					getUserInfo(), "PATIENTBYNO", new String[] {patNo},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						getFullName().setText(mQueue.getContentField()[0] + " " + mQueue.getContentField()[1]);
						getChiName().setText(mQueue.getContentField()[6]);
					}
				}
			});
		}
	}

	private void fillSlpFields() {
		if (memSLPNO.length() > 0) {
			QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] {"slip s, reg r, inpat i",
						"r.regid, to_char(r.regdate, 'dd/mm/yyyy hh24:mi:ss'), to_char(i.inpddate, 'dd/mm/yyyy hh24:mi:ss'), r.patno",
						"s.slpno='"+memSLPNO+"' and r.regid= s.regid and i.inpid= r.inpid"},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						memREGID = mQueue.getContentField()[0];
						getAdmDate().setText(mQueue.getContentField()[1]);
						getDischangeDate().setText(mQueue.getContentField()[2]);
						fillPatFields(mQueue.getContentField()[3]);
						fillDocBedInfo();
					}
				}
			});
		}
	}

	private void fillDocBedInfo() {
		if (memSLPNO.length() == 0) {
			Factory.getInstance().addErrorMessage(MSG_MISSED_SLIPNO, getSlipNo());
			return;
		}

		if (memSLPNO!=null && memSLPNO.length() > 0) {
			QueryUtil.executeMasterAction(getUserInfo(), "RECORDUNLOCK",
					QueryUtil.ACTION_APPEND, new String[] { getSlipNo().getText(), "Slip", CommonUtil.getComputerName(), getUserInfo().getUserID() },
					new MessageQueueCallBack() {
				public void onPostSuccess(MessageQueue mQueue) {
					lockRecord("Slip", memSLPNO);
					// following logic in override lockRecordReady()
				}
			});
		}
	}

	private void showDetail() {
		if (getTabbedPane().getSelectedIndex() == 0) {
			if (getDListTable().getSelectedRow() >= 0) {
				getDDoctorCode().setText(getDListTable().getSelectedRowContent()[3]);
				getDDocFullName().setText(getDListTable().getSelectedRowContent()[4]);
				getDDocCName().setText(getDListTable().getSelectedRowContent()[5]);
				getDStartDate().setText(getDListTable().getSelectedRowContent()[1]);
				getDEndDate().setText(getDListTable().getSelectedRowContent()[2]);
			}
		} else {
			if (getBListTable().getSelectedRow() >= 0) {
				getBBedCode().setText(getBListTable().getSelectedRowContent()[3]);
				getBStartDate().setText(getBListTable().getSelectedRowContent()[1]);
				getBEndDate().setText(getBListTable().getSelectedRowContent()[2]);
			}
		}
		enableButton();
	}

	private void clearAllFieldForSearch() {
		memPATNO = EMPTY_VALUE;
		memREGID = EMPTY_VALUE;
		memRLock = EMPTY_VALUE;
		memSLPNO = EMPTY_VALUE;
		PanelUtil.resetAllFields(getLeftPanel());
	}

	private void setFieldEditable(boolean flag) {
		getPatientNo().setEditable(!flag);
		getSlipNo().setEditable(!flag);
		if (getTabbedPane().getSelectedIndex() == 0) {
			getDDoctorCode().setEditable(flag);
			getDStartDate().setEditable(flag);
			getDListTable().disableEvents(flag);
			getDListTable().disableTextSelection(flag);
		} else if (getTabbedPane().getSelectedIndex() == 1) {
			getBBedCode().setEditable(flag);
			getBStartDate().setEditable(flag);
			getBListTable().disableEvents(flag);
			getBListTable().disableTextSelection(flag);
		}
		defaultFocus();
	}

	private void clearFields() {
//		getPatientNo().resetText();
		getChiName().resetText();
		getSlipNo().resetText();
		getAdmDate().resetText();
		getDischangeDate().resetText();
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected void actionValidationReadyHelper(String actionType, MessageQueue mQueue) {
		// do nothing
	}

	@Override
	protected void actionValidationPostReady(String actionType) {
		super.actionValidationPostReady(actionType);
		if (QueryUtil.ACTION_APPEND.equals(actionType)
				|| QueryUtil.ACTION_MODIFY.equals(actionType)
				|| QueryUtil.ACTION_DELETE.equals(actionType)) {
			savePostAction();
		}
	}

	@Override
	protected void lockRecordReady(final String lockType, final String lockKey, String[] record, boolean lock, String returnMessage) {
		if (lock) {
			memRLock = memSLPNO;
			QueryUtil.executeMasterBrowse(
					getUserInfo(), ConstantsTx.DOCCHGHIS_TXCODE, new String[] { memREGID},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						getDListTable().setListTableContent(mQueue);
					}
				}
			});

			QueryUtil.executeMasterBrowse(
					getUserInfo(), ConstantsTx.BEDCHGHIS_TXCODE, new String[] {memREGID},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						getBListTable().setListTableContent(mQueue);
					}
				}
			});
		} else {
			memRLock = EMPTY_VALUE;
			Factory.getInstance().addErrorMessage(returnMessage);
			getSlipNo().resetText();
		}
	}

	@Override
	protected void unlockRecordReady(final String lockType, final String lockKey, String[] record, boolean unlock, String returnMessage) {
		setParameter(lockType, getSlipNo().getText());
		clearAllFieldForSearch();
		showInfo();
	}

	@Override
	protected void enableButton(String mode) {
		disableButton();
		boolean isAction = isAppend() || isModify();

		getSearchButton().setEnabled(!isAction);
		getAppendButton().setEnabled(!isAction);
		getModifyButton().setEnabled(!isAction && getCurrentListTable().getSelectedRow() >= 0);
		getSaveButton().setEnabled(isAction);
		getDeleteButton().setEnabled(isModify() && getCurrentListTable().getSelectedRow() >= 0 &&
										getCurrentListTable().getSelectedRow() == getCurrentListTable().getRowCount() - 1);
		getCancelButton().setEnabled(isAction);
		getRefreshButton().setEnabled(!isAction);
	}

	@Override
	public void searchAction() {
		if ((isAppend() || isModify()) && getBBedCode().isFocusOwner()) {
			getBBedCode().checkTriggerBySearchKey();
		} else if (browseValidation()) {
			unlockRecord("Slip", memRLock);
		}
	}

	@Override
	public void appendAction() {
		super.appendAction(true);

		if (getTabbedPane().getSelectedIndex() == 0) {
			getDListTable().addRow(new String[] {
				EMPTY_VALUE,
				EMPTY_VALUE,
				EMPTY_VALUE,
				EMPTY_VALUE,
				EMPTY_VALUE,
				EMPTY_VALUE,
				EMPTY_VALUE,
				getUserInfo().getUserID(),
				EMPTY_VALUE,
				EMPTY_VALUE,
				memREGID,
				memPATNO,
				"C"
			});
		} else if (getTabbedPane().getSelectedIndex() == 1) {
			getBListTable().addRow(new String[] {
				EMPTY_VALUE,
				EMPTY_VALUE,
				EMPTY_VALUE,
				EMPTY_VALUE,
				EMPTY_VALUE,
				EMPTY_VALUE,
				getUserInfo().getUserID(),
				EMPTY_VALUE,
				memREGID,
				memPATNO,
				EMPTY_VALUE
			});
		}
		getCurrentListTable().setSelectRow(getCurrentListTable().getRowCount() - 1);
		defaultFocus();
	}

	@Override
	public void modifyAction() {
		super.modifyAction();
	}

	@Override
	public void deleteAction() {
		MessageBoxBase.confirm(MSG_PBA_SYSTEM, "Are you sure to delete this record?",
				new Listener<MessageBoxEvent>() {
			@Override
			public void handleEvent(MessageBoxEvent be) {
				if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
					int tableRowCount = -1;
					if (getTabbedPane().getSelectedIndex() == 0) {
						tableRowCount = getDListTable().getRowCount();
					} else if (getTabbedPane().getSelectedIndex() == 1) {
						tableRowCount = getBListTable().getRowCount();
					}

					if (tableRowCount > 1) {
						String[] param = null;

						if (getTabbedPane().getSelectedIndex() == 0) {
							param = new String[] {
								getDListTable().getValueAt(tableRowCount - 2, 9),
								getDListTable().getValueAt(tableRowCount - 2, 10),
								getDListTable().getValueAt(tableRowCount - 2, 11),
								getDListTable().getValueAt(tableRowCount - 2, 3),
								getDListTable().getValueAt(tableRowCount - 2, 1),
								!getAdmDate().isEmpty()?
										(!getDischangeDate().isEmpty()?
											getDischangeDate().getText().substring(0, 10):EMPTY_VALUE):EMPTY_VALUE,
								getDListTable().getSelectedRowContent()[9],
								getDListTable().getSelectedRowContent()[10],
								getDListTable().getSelectedRowContent()[11],
								getDListTable().getSelectedRowContent()[3],
								getDListTable().getSelectedRowContent()[1],
								getDListTable().getSelectedRowContent()[2],
								getDListTable().getSelectedRowContent()[7]
							};
						} else if (getTabbedPane().getSelectedIndex() == 1) {
							param = new String[] {
									getBListTable().getValueAt(tableRowCount - 2, 7),
									getBListTable().getValueAt(tableRowCount - 2, 8),
									getBListTable().getValueAt(tableRowCount - 2, 9),
									getBListTable().getValueAt(tableRowCount - 2, 3),
									getBListTable().getValueAt(tableRowCount - 2, 1),
									!getAdmDate().isEmpty()?
											(!getDischangeDate().isEmpty()?
													getDischangeDate().getText():EMPTY_VALUE):EMPTY_VALUE,
									getBListTable().getSelectedRowContent()[7],
									getBListTable().getSelectedRowContent()[8],
									getBListTable().getSelectedRowContent()[9],
									getBListTable().getSelectedRowContent()[3],
									getBListTable().getSelectedRowContent()[1],
									getBListTable().getSelectedRowContent()[2],
									getBListTable().getSelectedRowContent()[6]
							};
						}

						QueryUtil.executeMasterAction(getUserInfo(), getTxCode(),
								QueryUtil.ACTION_DELETE, param,
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									setActionType(QueryUtil.ACTION_DELETE);
									enableButton();

									setActionType(null);
									refreshAction();
								} else {
									Factory.getInstance().addErrorMessage(mQueue);
								}
							}
						});
					} else {
						Factory.getInstance().addErrorMessage("Must have at least 1 record.");
					}
				}
			}
		});
	}

	@Override
	protected void cancelPostAction() {
		refreshAction();
	}

	@Override
	protected void savePostAction() {
		refreshAction();
	}

	@Override
	protected void performListPost() {
		refreshAction();
	}

	@Override
	public void refreshAction() {
		showInfo();
		setFieldEditable(false);
//		getDListTable().getView().setSortingEnabled(false);
	}

	@Override
	protected TableList getCurrentListTable() {
		if (getTabbedPane().getSelectedIndex() == 1) {
			return getBListTable();
		} else {
			return getDListTable();
		}
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	@Override
	protected BasePanel getActionPanel() {
		if (actionPanel == null) {
			actionPanel = new BasePanel();
			actionPanel.setSize(775, 466);
			actionPanel.add(getParaPanel(), null);
			actionPanel.add(getTabbedPane());
		}
		return actionPanel;
	}

	public BasePanel getParaPanel() {
		if (ParaPanel == null) {
			ParaPanel = new BasePanel();
			ParaPanel.add(getPatientNoDesc(), null);
			ParaPanel.add(getPatientNo(), null);
			ParaPanel.add(getFullName(), null);
			ParaPanel.add(getChiName(), null);
			ParaPanel.add(getSlipNoDesc(), null);
			ParaPanel.add(getSlipNo(), null);
			ParaPanel.add(getAdmDateDesc(), null);
			ParaPanel.add(getAdmDate(), null);
			ParaPanel.add(getDischangeDateDesc(), null);
			ParaPanel.add(getDischangeDate(), null);
			ParaPanel.setBounds(6, 9, 757, 72);
		}
		return ParaPanel;
	}

	public LabelBase getPatientNoDesc() {
		if (PatientNoDesc == null) {
			PatientNoDesc = new LabelBase();
			PatientNoDesc.setText("Patient No.");
			PatientNoDesc.setBounds(10, 10, 81, 20);
		}
		return PatientNoDesc;
	}

	public TextPatientNoSearch getPatientNo() {
		if (PatientNo == null) {
			PatientNo = new TextPatientNoSearch() {
				public void onBlur() {
					if (!getPatientNo().getText().equals(getPatientNo().getOriginalValue())) {
						clearFields();
					}

					fillPatFields(getPatientNo().getText());
					getSlipNo().focus();
				};
			};
			PatientNo.setBounds(90, 10, 102, 20);
		}
		return PatientNo;
	}

	public TextReadOnly getFullName() {
		if (FullName == null) {
			FullName = new TextReadOnly();
			FullName.setBounds(206, 10, 173, 20);
		}
		return FullName;
	}

	public TextReadOnly getChiName() {
		if (ChiName == null) {
			ChiName = new TextReadOnly();
			ChiName.setBounds(391, 10, 76, 20);
		}
		return ChiName;
	}

	public LabelBase getSlipNoDesc() {
		if (SlipNoDesc == null) {
			SlipNoDesc = new LabelBase();
			SlipNoDesc.setText("Slip Number");
			SlipNoDesc.setBounds(10, 40, 81, 20);
		}
		return SlipNoDesc;
	}

	public TextString getSlipNo() {
		if (SlipNo == null) {
			SlipNo = new TextString() {
				public void onBlur() {
					QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] {"Slip", "SlpNo", "SlpNo= '" + SlipNo.getText() + "' and SlpSts='" + ConstantsTransaction.SLIP_STATUS_OPEN + "'"},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								memSLPNO = mQueue.getContentField()[0];
								fillSlpFields();
							} else {
								memSLPNO = EMPTY_VALUE;
							}
						}
					});
				};
			};
			SlipNo.setBounds(90, 40, 102, 20);
		}
		return SlipNo;
	}

	public LabelBase getAdmDateDesc() {
		if (AdmDateDesc == null) {
			AdmDateDesc = new LabelBase();
			AdmDateDesc.setText("Admission Date");
			AdmDateDesc.setBounds(206, 40, 104, 20);
		}
		return AdmDateDesc;
	}

	public TextReadOnly getAdmDate() {
		if (AdmDate == null) {
			AdmDate = new TextReadOnly();
			AdmDate.setBounds(310, 40, 152, 20);
		}
		return AdmDate;
	}

	public LabelBase getDischangeDateDesc() {
		if (DischangeDateDesc == null) {
			DischangeDateDesc = new LabelBase();
			DischangeDateDesc.setText("Discharge Date");
			DischangeDateDesc.setBounds(478, 40, 90, 20);
		}
		return DischangeDateDesc;
	}

	public TextReadOnly getDischangeDate() {
		if (DischangeDate == null) {
			DischangeDate = new TextReadOnly();
			DischangeDate.setBounds(572, 40, 152, 20);
		}
		return DischangeDate;
	}

	public TabbedPaneBase getTabbedPane() {
		if (TabbedPane == null) {
			TabbedPane = new TabbedPaneBase() {
				private int previousIndex = 0;
				public void onStateChange() {
					int selectedIndex = TabbedPane.getSelectedIndex();

					if (QueryUtil.ACTION_APPEND.equals(getActionType())
							|| QueryUtil.ACTION_MODIFY.equals(getActionType())) {
						TabbedPane.setSelectedIndexWithoutStateChange(previousIndex);
						setFieldEditable(true);
						return;
					} else {
						setFieldEditable(false);
						previousIndex = selectedIndex;
						enableButton();
					}
				}
			};
			TabbedPane.setBounds(7, 85, 760, 378);
			TabbedPane.addTab("Doctor Changing History", getDCHistoryPanel());
			TabbedPane.addTab("Bed Changing History", getBCHistoryPanel());
		}
		return TabbedPane;
	}

	public BasePanel getDCHistoryPanel() {
		if (DCHistoryPanel == null) {
			DCHistoryPanel = new BasePanel();
			DCHistoryPanel.add(getDDoctorCodeDesc(), null);
			DCHistoryPanel.add(getDDoctorCode(), null);
			DCHistoryPanel.add(getDDocFullName(), null);
			DCHistoryPanel.add(getDDocCName(), null);
			DCHistoryPanel.add(getDStartDateDesc(), null);
			DCHistoryPanel.add(getDStartDate(), null);
			DCHistoryPanel.add(getDEndDateDesc(), null);
			DCHistoryPanel.add(getDEndDate(), null);
			DCHistoryPanel.add(getDJScrollPane(), null);
			DCHistoryPanel.setBounds(0, 0, 774, 500);
		}
		return DCHistoryPanel;
	}

	public LabelBase getDDoctorCodeDesc() {
		if (DDoctorCodeDesc == null) {
			DDoctorCodeDesc = new LabelBase();
			DDoctorCodeDesc.setText("Doctor Code");
			DDoctorCodeDesc.setBounds(11, 90, 85, 20);
		}
		return DDoctorCodeDesc;
	}

	public TextDoctorSearch getDDoctorCode() {
		if (DDoctorCode == null) {
			DDoctorCode = new TextDoctorSearch(getDListTable(), 3, true) {
				public void onBlur() {
					if (!isEmpty()) {
						QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.DOCTOR_ACTIVE_TXCODE,
								new String[] { getText() },
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								// TODO Auto-generated method stub
								if (mQueue.success()) {
									getDDocFullName().setText(mQueue.getContentField()[0]);
									getDDocCName().setText(mQueue.getContentField()[2]);
									getDListTable().setValueAt(getText(), getDListTable().getSelectedRow(), 3);
									getDListTable().setValueAt(mQueue.getContentField()[0], getDListTable().getSelectedRow(), 4);
									getDListTable().setValueAt(mQueue.getContentField()[2], getDListTable().getSelectedRow(), 5);
									getDStartDate().requestFocus();
								} else {
									Factory.getInstance().addErrorMessage(MSG_WRONG_DOCCODE, getDDoctorCode());
									getDDocFullName().resetText();
									getDDocCName().resetText();
									DDoctorCode.resetText();
									getDListTable().resetValueAt(getDListTable().getSelectedRow(), 3);
									getDListTable().resetValueAt(getDListTable().getSelectedRow(), 4);
									getDListTable().resetValueAt(getDListTable().getSelectedRow(), 5);
								}
							}
						});
					} else {
						getDDocFullName().resetText();
						getDDocCName().resetText();
						DDoctorCode.resetText();
						getDListTable().resetValueAt(getDListTable().getSelectedRow(), 3);
						getDListTable().resetValueAt(getDListTable().getSelectedRow(), 4);
						getDListTable().resetValueAt(getDListTable().getSelectedRow(), 5);
					}
				};
			};
			DDoctorCode.setBounds(95, 90, 131, 20);
		}
		return DDoctorCode;
	}

	public TextReadOnly getDDocFullName() {
		if (DDocFullName == null) {
			DDocFullName = new TextReadOnly();
			DDocFullName.setBounds(95, 120, 131, 20);
		}
		return DDocFullName;
	}

	public TextReadOnly getDDocCName() {
		if (DDocCName == null) {
			DDocCName = new TextReadOnly();
			DDocCName.setBounds(95, 150, 131, 20);
		}
		return DDocCName;
	}

	public LabelBase getDStartDateDesc() {
		if (DStartDateDesc == null) {
			DStartDateDesc = new LabelBase();
			DStartDateDesc.setText("Start Date");
			DStartDateDesc.setBounds(11, 180, 85, 20);
		}
		return DStartDateDesc;
	}

	public TextDate getDStartDate() {
		if (DStartDate == null) {
			DStartDate = new TextDate(getDListTable(), 1) {
				@Override
				public void onBlur() {
					if (!isEmpty()) {
						if (getDListTable().getSelectedRow() >= 0) {
							if (isValid()) {
								int previousRow = getDListTable().getSelectedRow() - 1;
								if (previousRow >= 0) {
									if (DateTimeUtil.dateDiff(getDListTable().getValueAt(previousRow, 1), getText()) > 0) {
										Factory.getInstance().addErrorMessage("The start date can't be earlier than the previous from date.", DStartDate);
										resetText();
										return;
									} else if (DateTimeUtil.dateDiff(getText(), getAdmDate().getText().trim().substring(0, 10)) < 0) {
										Factory.getInstance().addErrorMessage("The start date can't be earlier than admission date!", DStartDate);
										resetText();
										return;
									}

									getDListTable().setValueAt(getText(), previousRow, 2);
									getDListTable().setValueAt("C", previousRow, 12);
								}
								getDListTable().setValueAt(getText(), getDListTable().getSelectedRow(), 1);
							} else {
								getDListTable().resetValueAt(getDListTable().getSelectedRow(), 1);
								getDListTable().resetValueAt(getDListTable().getSelectedRow(), 12);
							}
						}
					} else {
						getDListTable().resetValueAt(getDListTable().getSelectedRow(), 1);
						getDListTable().resetValueAt(getDListTable().getSelectedRow(), 12);
					}
				};
			};
			DStartDate.setBounds(95, 180, 131, 20);
		}
		return DStartDate;
	}

	public LabelBase getDEndDateDesc() {
		if (DEndDateDesc == null) {
			DEndDateDesc = new LabelBase();
			DEndDateDesc.setText("End Date");
			DEndDateDesc.setBounds(11, 210, 85, 20);
		}
		return DEndDateDesc;
	}

	public TextReadOnly getDEndDate() {
		if (DEndDate == null) {
			DEndDate = new TextReadOnly();
			DEndDate.setBounds(95, 210, 131, 20);
		}
		return DEndDate;
	}

	private JScrollPane getDJScrollPane() {
		if (DJScrollPane == null) {
			DJScrollPane = new JScrollPane();
			DJScrollPane.setViewportView(getDListTable());
			DJScrollPane.setBounds(240, 50, 500, 290);
		}
		return DJScrollPane;
	}

	private TableList getDListTable() {
		if (DListTable == null) {
			DListTable = new TableList(getDListTableColumnNames(), getDListTableColumnWidths()) {
				@Override
				public void onSelectionChanged() {
					showDetail();
				}
			};
			DListTable.setTableLength(getListWidth());
		}
		return DListTable;
	}

	private String[] getDListTableColumnNames() {
		return new String[] {
				EMPTY_VALUE,
				"From",
				"To",
				"Doctor Code",
				"Doctor Name",
				"Doctor Chinese Name",
				"Specialty",
				"User ID",
				EMPTY_VALUE, EMPTY_VALUE, EMPTY_VALUE, EMPTY_VALUE, EMPTY_VALUE
		};
	}

	private int[] getDListTableColumnWidths() {
		return new int[] {
				20,
				80,
				80,
				80,
				100,
				100,
				100,
				80,
				0, 0, 0, 0, 0
		};
	}

	public BasePanel getBCHistoryPanel() {
		if (BCHistoryPanel == null) {
			BCHistoryPanel = new BasePanel();
			BCHistoryPanel.add(getBBedCodeDesc(), null);
			BCHistoryPanel.add(getBBedCode(), null);
			BCHistoryPanel.add(getBStartDateDesc(), null);
			BCHistoryPanel.add(getBStartDate(), null);
			BCHistoryPanel.add(getBEndDateDesc(), null);
			BCHistoryPanel.add(getBEndDate(), null);
			BCHistoryPanel.add(getBJScrollPane(), null);
			BCHistoryPanel.setBounds(0, 0, 774, 500);
		}
		return BCHistoryPanel;
	}

	public LabelBase getBBedCodeDesc() {
		if (BBedCodeDesc == null) {
			BBedCodeDesc = new LabelBase();
			BBedCodeDesc.setText("Bed Code");
			BBedCodeDesc.setBounds(11, 90, 85, 20);
		}
		return BBedCodeDesc;
	}

	public TextBedSearch getBBedCode() {
		if (BBedCode == null) {
			BBedCode = new TextBedSearch(getBListTable(), 3) {
				@Override
				public void onBlur() {
					if (!isEmpty()) {
						QueryUtil.executeMasterFetch(getUserInfo(),
								ConstantsTx.LOOKUP_TXCODE,
								new String[] {
												"bed b, room r, acm a",
												"b.bedcode, a.acmcode",
												"b.romcode = r.romcode AND r.acmcode = a.acmcode  AND b.bedcode = '" + getBBedCode().getText() + "'"
											},
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									getBListTable().setValueAt(getText(), getBListTable().getSelectedRow(), 3);
								} else {
									Factory.getInstance().addErrorMessage(MSG_WRONG_BEDCODE, BBedCode);
									BBedCode.resetText();
									getBListTable().resetValueAt(getBListTable().getSelectedRow(), 3);
								}
							}
						});
					} else {
						BBedCode.resetText();
						getBListTable().resetValueAt(getBListTable().getSelectedRow(), 3);
					}
				};
			};
			BBedCode.setBounds(95, 90, 131, 20);
		}
		return BBedCode;
	}

	public LabelBase getBStartDateDesc() {
		if (BStartDateDesc == null) {
			BStartDateDesc = new LabelBase();
			BStartDateDesc.setText("Start Date");
			BStartDateDesc.setBounds(11, 120, 85, 20);
		}
		return BStartDateDesc;
	}

	public TextDateTime getBStartDate() {
		if (BStartDate == null) {
			BStartDate = new TextDateTime(true, true, getBListTable(), 1) {
				@Override
				public void setValue(Date value) {
					if (isAppend() || isModify()) {
						if (value != null) {
							value.setHours(0);
							value.setMinutes(0);
							value.setSeconds(0);
						}
					}
					super.setValue(value);
					if (value != null  && isRendered()) {
						setSelectionRange(11, 8);
					}
				}

				@Override
				public void onBlur() {
					if (!isEmpty()) {
						if (getBListTable().getSelectedRow() >= 0) {
							if (validate()) {
								if (DateTimeUtil.isDate(getRawValue())) {
									setRawValue(getRawValue()+ " 00:00");
									//focus();
									//getBListTable().resetValueAt(getBListTable().getSelectedRow(), 1);
									//return;
								}

								int previousRow = getBListTable().getSelectedRow() - 1;
								if (previousRow >= 0) {
									if (DateTimeUtil.dateTimeDiff(getBListTable().getValueAt(previousRow, 1), getText()) > 0) {
										Factory.getInstance().addErrorMessage("The start date can't be earlier than the previous from date.", BStartDate);
										resetText();
										return;
									} else if (DateTimeUtil.dateTimeDiff(getText(), getAdmDate().getText()) < 0) {
										Factory.getInstance().addErrorMessage("The start date can't be earlier than admission date!", BStartDate);
										resetText();
										return;
									}

									getBListTable().setValueAt(getText(), previousRow, 2);
								}
								getBListTable().setValueAt(getText(), getBListTable().getSelectedRow(), 1);
							} else {
								getBListTable().resetValueAt(getBListTable().getSelectedRow(), 1);
							}
						}
					} else {
						getBListTable().resetValueAt(getBListTable().getSelectedRow(), 1);
					}
				};
			};
			BStartDate.setBounds(95, 120, 131, 20);
		}
		return BStartDate;
	}

	public LabelBase getBEndDateDesc() {
		if (BEndDateDesc == null) {
			BEndDateDesc = new LabelBase();
			BEndDateDesc.setText("End Date");
			BEndDateDesc.setBounds(11, 150, 85, 20);
		}
		return BEndDateDesc;
	}

	public TextReadOnly getBEndDate() {
		if (BEndDate == null) {
			BEndDate = new TextReadOnly();
			BEndDate.setBounds(95, 150, 131, 20);
		}
		return BEndDate;
	}

	private JScrollPane getBJScrollPane() {
		if (BJScrollPane == null) {
			BJScrollPane = new JScrollPane();
			BJScrollPane.setViewportView(getBListTable());
			BJScrollPane.setBounds(240, 50, 500, 290);
		}
		return BJScrollPane;
	}

	private TableList getBListTable() {
		if (BListTable == null) {
			BListTable = new TableList(getBListTableColumnNames(), getBListTableColumnWidths()) {
				@Override
				public void onSelectionChanged() {
					showDetail();
				}
			};
			BListTable.setTableLength(getListWidth());
		}
		return BListTable;
	}

	protected String[] getBListTableColumnNames() {
		return new String[] {EMPTY_VALUE,
				"From",
				"To",
				"Bed Code",
				"Dept. Code",
				"Ward",
				"User ID", EMPTY_VALUE, EMPTY_VALUE, EMPTY_VALUE, EMPTY_VALUE
				};
	}

	protected int[] getBListTableColumnWidths() {
		return new int[] {20, 120, 120, 90, 100, 80, 60, 0, 0, 0, 0};
	}
}