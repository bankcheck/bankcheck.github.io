package com.hkah.client.tx.registration;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.util.Rectangle;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.LayoutContainer;
import com.extjs.gxt.ui.client.widget.layout.FlowLayout;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.textfield.TextDateTime;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MaintenancePanel;
import com.hkah.client.tx.transaction.SlipSearch;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class HomeLeave extends MaintenancePanel {

	private static final long serialVersionUID = 1L;

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.HOMELEAVE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.HOMELEAVE_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] { "", "", "", "Leave Date", "Leave User", "Return Date",
				"Return User" };
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] { 0, 0, 0, 180, 180, 180, 180 };
	}

	@Override
	public boolean isTableViewOnly() {
		return false;
	}

	private ColumnLayout rightPanel = null;
	private BasePanel leftPanel = null;

	private BasePanel ParaPanel = null;

	private LabelBase PatientNoDesc = null;
	private TextPatientNoSearch PatientNo = null;
	private TextReadOnly FullName = null;
	private TextReadOnly ChiName = null;
	private LabelBase BedCodeDesc = null;
	private TextReadOnly BedCode = null;
	private LabelBase AcmCodeDesc = null;
	private TextReadOnly AcmCode = null;
	private LabelBase SlipNoDesc = null;
	private TextString SlipNo = null;
	private LabelBase AdmDateDesc = null;
	private TextReadOnly AdmDate = null;
	private LabelBase DischangeDateDesc = null;
	private TextReadOnly DischangeDate = null;
	private LabelBase HomeLeaveDesc = null;
	private CheckBoxBase HomeLeave = null;
	private LabelBase LeaveDTDesc = null;
	private TextDateTime LeaveDT = null;
	private LabelBase ReturnDTDesc = null;
	private TextDateTime ReturnDT = null;
	private JScrollPane leaveScrollPanel = null;

	private FieldSetBase ListPanel = null;

	private String memInpID = null;
	private String memPatNo = null;
	private String memSlpNo = null;
	private String lastSlipNo = null;
//	private int lcFocus;

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		lastSlipNo = "";
		if("SlipSearch".equals(getParameter("AcceptClass"))){
			getSlipNo().setText(getParameter("SlpNo"));
		}

		getLeaveDT().setEnabled(false);
		getReturnDT().setEnabled(false);
		getHomeLeave().setEnabled(false);
		isSelectHomeLeave();

		QueryUtil.executeMasterBrowse(getUserInfo(),
				ConstantsTx.SEARCH_HOMELEAVE, new String[] { getSlipNo().getText().trim() },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				// TODO Auto-generated method stub
				if (mQueue.success()) {
					getAppendButton().setEnabled(true);
				}
				if (getListTable().getRowCount() > 0) {
					LeaveDT.setText(getListSelectedRow()[3]);
					ReturnDT.setText(getListSelectedRow()[5]);
				}

				enableButton();
			}
		});
	}

	@Override
	protected void defaultFocus() {
		if("SlipSearch".equals(getParameter("AcceptClass"))){
			return;
		}
		super.defaultFocus();
	}

	public void rePostAction() {
		super.rePostAction();
		enableButton(null);
		if (getParameter("PatNo") != null) {
			getPatientNo().setText(getParameter("PatNo"));
			removeParameter("PatNo");
			getPatientNo().requestFocus();
		}
		if (getParameter("SlpNo") != null) {
			getSlipNo().setText(getParameter("SlpNo"));
			removeParameter("SlpNo");
			getSlipNo().requestFocus();
		}
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */

//	public TextPatientNoSearch getDefaultFocusComponent() {
//		return getPatientNo();
//	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {
		// override function if necessary
	}

	@Override
	public Component getDefaultFocusComponent() {
		if("SlipSearch".equals(getParameter("AcceptClass"))){
			return getSlipNo();
		}
		return getPatientNo();
	}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {
		// enable/disable field
		getPatientNo().setEnabled(false);
		getSlipNo().setEnabled(false);
		getLeaveDT().setEnabled(true);
		HomeLeave.setSelected(true);
		getLeaveDT().resetText();
		getReturnDT().resetText();
	}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
		// enable/disable field
		getPatientNo().setEnabled(false);
		getSlipNo().setEnabled(false);
		getLeaveDT().setEnabled(true);
		getReturnDT().setEnabled(true);
		getSaveButton().setEnabled(true);
		getCancelButton().setEnabled(true);
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
		return new String[] { getSlipNo().getText().trim()};
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
		int index = 0;
		index++;
		index++;
		index++;
		getLeaveDT().setText(outParam[index++]);
		index++;
		getReturnDT().setText(outParam[index++]);
		index++;
	}

	/* >>> ~21~ Set Add New Row toclearPostAction table ============================== <<< */
	@Override
	protected void clearTableFields() {
		super.clearTableFields();
		setCurrentTable(4, getUserInfo().getUserID());
	}

	/* >>> ~22~ Set Action Input Parameters per table ===================== <<< */
	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		return new String[] {
			selectedContent[0],
			getSlipNo().getText().trim(),
			memInpID,
			selectedContent[3],
			selectedContent[4],
			selectedContent[5],
			selectedContent[6]
		};
	}

	/* >>> ~23~ Set Action Validation per table =========================== <<< */
	@Override
	protected boolean actionValidation(String[] selectedContent) {
		if (getLeaveDT().isEmpty()) {
			Factory.getInstance().addErrorMessage("Leave Datetime is mandatory.", getLeaveDT());
			return false;
		} else if (!getLeaveDT().isValid()) {
			Factory.getInstance().addErrorMessage("Format of Leave Datetime is invalid.", getLeaveDT());
			return false;
		} else if (!getLeaveDT().isEmpty() && !getReturnDT().isEmpty()) {
			if (getReturnDT().isValid()) {
				if(DateTimeUtil.dateTimeDiff(getReturnDT().getText().trim(),
						getLeaveDT().getText().trim()) < 0){
					Factory.getInstance().addErrorMessage("Return Datetime can not be earlier than Leave Datetime.", getLeaveDT());
					return false;
				}
			} else {
				Factory.getInstance().addErrorMessage("Format of Return Datetime is invalid.", getReturnDT());
				getSaveButton().setEnabled(false);
				return false;
			}
		}
		return true;
	}

	@Override
	public void searchAction() {
		searchValidate();
	}

	@Override
	protected void searchPostAction() {
		if("SlipSearch".equals(getParameter("AcceptClass"))){
			return;
		}
		super.searchPostAction();
	}

	private void searchValidate() {
		String patNo = getPatientNo().getText().trim();
		String slpNo = getSlipNo().getText().trim();
		if (getPatientNo().isFocusOwner() && patNo.length() == 0) {
			getPatientNo().showSearchPanel();
			searchValidateReady(false);
		} else if (getSlipNo().isFocusOwner() && slpNo.length() == 0) {
			showPanel(new SlipSearch(this),false,true);
			setParameter("AcceptClass", "HomeLeave");
			searchValidateReady(false);
		} else if (slpNo.length() > 0) {
			checkSlpNo(slpNo, patNo);
		} else {
			searchValidateReady(false);
		}
	}

	private void checkSlpNoReady(boolean flag) {
		if (flag) {
			search();
			searchValidateReady(true);
		} else {
			searchValidateReady(false);
		}
	}

	private void searchValidateReady(boolean isValidate) {
		if (isValidate) {
			super.searchAction();
		}
	}

	/***************************************************************************
	 * Override Methods
	 **************************************************************************/

	public void search() {
		QueryUtil.executeMasterBrowse(getUserInfo(),
				ConstantsTx.SEARCH_HOMELEAVE, new String[] { getSlipNo().getText().trim() },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mq) {
				if (mq.success() == true) {
					if (getPatientNo().isEmpty()) {
						getPatientNo().setText(mq.getContentField()[1]);
					}
					getFullName().setText(mq.getContentField()[2]);
					getChiName().setText(mq.getContentField()[3]);
					getBedCode().setText(mq.getContentField()[6]);
					getAcmCode().setText(mq.getContentField()[7]);
					getAdmDate().setText(mq.getContentField()[4]);
					getDischangeDate().setText(mq.getContentField()[5]);

					memInpID = mq.getContentField()[0];
					memPatNo = getPatientNo().getText().trim();
					memSlpNo = getSlipNo().getText().trim();
				}
			}
		});
	}

	public void checkSlpNo(String strSlpNo, String strPatNo) {
		if (strPatNo.length()>0) {
			checkPatNo(strSlpNo, strPatNo);
		} else {
			QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] { "slip s", "s.SLPTYPE, s.*", "s.SLPNO = '" + strSlpNo + "'" },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						if (mQueue.getContentField()[0].equals("I")) {
							checkSlpNoReady(true);
						} else {
							getSlipNo().resetText();
							Factory.getInstance().addErrorMessage("The registration type is not In-Patient.", getPatientNo());
							checkSlpNoReady(false);
						}
					} else {
						getSlipNo().resetText();
						Factory.getInstance().addErrorMessage("There is no such Slip No.", getSlipNo());
						checkSlpNoReady(false);
					}
				}
			});
		}
	}

	private void checkPatNoReady(String strSlpNo, String strPatNo, boolean flag) {
		if (flag) {
			QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] {
							"slip s",
							"s.SLPTYPE, s.*",
							"s.PATNO = '" + strPatNo + "' and s.SLPNO = '"
									+ strSlpNo + "'" },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						if (mQueue.getContentField()[0].equals("I")) {
							checkSlpNoReady(true);
						} else {
							getSlipNo().resetText();
							Factory.getInstance().addErrorMessage("The registration type is not In-Patient.", getPatientNo());
							checkSlpNoReady(false);
						}
					} else {
						getSlipNo().resetText();
						Factory.getInstance().addErrorMessage("There is no such Slip No. for this patient.", getSlipNo());
						checkSlpNoReady(false);
					}
				}
			});
		}
	}

	public void checkPatNo(final String strSlpNo,final String strPatNo) {
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] { "patient", "*", "patno = '" + strPatNo + "'" },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					checkPatNoReady(strSlpNo,strPatNo,true);
				} else {
					Factory.getInstance().addErrorMessage("Patient No. is invalid.", getPatientNo());
					getPatientNo().resetText();
					checkPatNoReady(strSlpNo,strPatNo,false);
				}
			}
		});
	}

	public void isSelectHomeLeave() {
		if (getListTable().getRowCount() > 0) {
			HomeLeave.setSelected(true);
		} else {
			HomeLeave.setSelected(false);
		}
	}

	private void deleteContent() {
		super.deleteAction();
	}

	/***************************************************************************
	 * Override Methods
	 **************************************************************************/
	@Override
	protected void performListPost() {
		isSelectHomeLeave();
	}


	@Override
	public void deleteAction() {
		if (getListTable().getSelectedRow() != -1) {
			MessageBoxBase.confirm(MSG_PBA_SYSTEM, "Are you sure to delete this Home Leave record?",
					new Listener<MessageBoxEvent>() {
				@Override
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						deleteContent();
					}
				}
			});
		} else {
			Factory.getInstance().addErrorMessage("Please select a Home Leave record.");
		}
	}

	@Override
	public void deletePostAction() {
		performAction(ACTION_SAVE);
	}

	@Override
	public void appendPostAction() {
		getListTable().setEditRow();
	}

	@Override
	public void modifyAction() {
		if (getListTable().getSelectedRow() != -1) {
			super.modifyAction();
		} else {
			Factory.getInstance().addErrorMessage("Please select a Home Leave record.");
		}
	}

	@Override
	public void cancelAction() {
		MessageBoxBase.confirm(MSG_PBA_SYSTEM, MSG_CANCEL_WARNING,
					new Listener<MessageBoxEvent>() {
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						// do action after click yes
						searchAction();
					}
				}
			});
	}

	protected void enableButton(String mode) {
		if (SEARCH_MODE.equals(mode)) {
			if (getListTable().getRowCount() > 0) {
				getSearchButton().setEnabled(true);
				getAppendButton().setEnabled(true);
				getModifyButton().setEnabled(true);
				getDeleteButton().setEnabled(true);
			} else {
				getSearchButton().setEnabled(true);
				getAppendButton().setEnabled(true);
				getModifyButton().setEnabled(false);
				getDeleteButton().setEnabled(false);
			}
			getSaveButton().setEnabled(false);
			getAcceptButton().setEnabled(false);
			getCancelButton().setEnabled(false);
			getClearButton().setEnabled(false);
			getRefreshButton().setEnabled(false);
			getPrintButton().setEnabled(false);

			getHomeLeave().setEnabled(false);
			getReturnDT().setEnabled(false);
			getLeaveDT().setEnabled(false);

			getPatientNo().setEnabled(true);
			getSlipNo().setEnabled(true);
		} else if (isAppend()) {
			getSearchButton().setEnabled(false);
			getAppendButton().setEnabled(false);
			getModifyButton().setEnabled(false);
			getDeleteButton().setEnabled(false);
			getSaveButton().setEnabled(true);
			getAcceptButton().setEnabled(false);
			getCancelButton().setEnabled(true);
			getClearButton().setEnabled(false);
			getRefreshButton().setEnabled(false);
			getPrintButton().setEnabled(false);

			getHomeLeave().setEnabled(false);
			getReturnDT().setEnabled(false);
			getLeaveDT().setEnabled(false);
		} else {
			getSearchButton().setEnabled(true);
			getAppendButton().setEnabled(false);
			getModifyButton().setEnabled(false);
			getDeleteButton().setEnabled(false);
			getSaveButton().setEnabled(false);
			getAcceptButton().setEnabled(false);
			getCancelButton().setEnabled(false);
			getClearButton().setEnabled(false);
			getRefreshButton().setEnabled(false);
			getPrintButton().setEnabled(false);

			getHomeLeave().setEnabled(false);
			getReturnDT().setEnabled(false);
			getLeaveDT().setEnabled(false);

			getPatientNo().setEnabled(true);
			getSlipNo().setEnabled(true);
		}
	}

	/***************************************************************************
	 * Layout Methods
	 **************************************************************************/

	@Override
	protected LayoutContainer getBodyPanel() {
		LayoutContainer panel = new LayoutContainer();
		panel.setBorders(false);
		panel.setLayout(new FlowLayout(10));
		panel.add(getLeftPanel());
		return panel;
	}

	@Override
	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.setSize(779, 528);
			leftPanel.add(getParaPanel());
			leftPanel.add(getLeaveDTDesc());
			leftPanel.add(getLeaveDT());
			leftPanel.add(getReturnDTDesc());
			leftPanel.add(getReturnDT());
			leftPanel.add(getListPanel());
		}
		return leftPanel;
	}

	@Override
	protected ColumnLayout getSearchPanel() {
		return null;
	}

	protected ColumnLayout getActionPanel() {
		return null;
	}

	public BasePanel getParaPanel() {
		if (ParaPanel == null) {
			ParaPanel = new BasePanel();
			ParaPanel.add(getPatientNoDesc(), null);
			ParaPanel.add(getPatientNo(), null);
			ParaPanel.add(getFullName(), null);
			ParaPanel.add(getChiName(), null);
			ParaPanel.add(getBedCodeDesc(), null);
			ParaPanel.add(getBedCode(), null);
			ParaPanel.add(getAcmCodeDesc(), null);
			ParaPanel.add(getAcmCode(), null);
			ParaPanel.add(getSlipNoDesc(), null);
			ParaPanel.add(getSlipNo(), null);
			ParaPanel.add(getAdmDateDesc(), null);
			ParaPanel.add(getAdmDate(), null);
			ParaPanel.add(getDischangeDateDesc(), null);
			ParaPanel.add(getDischangeDate(), null);
			ParaPanel.add(getHomeLeaveDesc(), null);
			ParaPanel.add(getHomeLeave(), null);
			ParaPanel.setBorders(true);
			ParaPanel.setLocation(5, 5);
			ParaPanel.setSize(757, 99);
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
			PatientNo = new TextPatientNoSearch(){
				@Override
				public void onPressed() {
					if (!PatientNo.isEmpty()) {
						getFullName().resetText();
						getChiName().resetText();
						getBedCode().resetText();
						getAdmDate().resetText();
						getLeaveDT().resetText();
						getReturnDT().resetText();
						getDischangeDate().resetText();
						getListTable().removeAllRow();
					}
				}

				@Override
				public void onReleased() {
					if (!PatientNo.isEmpty()) {
						getFullName().resetText();
						getChiName().resetText();
						getBedCode().resetText();
						getAdmDate().resetText();
						getDischangeDate().resetText();
						getLeaveDT().resetText();
						getReturnDT().resetText();
						getListTable().removeAllRow();
					}
				}
				@Override
				public void onBlur() {
					getSlipNo().focus();
				}
			};
			PatientNo.setBounds(90, 10, 102, 20);
		}
		return PatientNo;
	}

	public TextReadOnly getFullName() {
		if (FullName == null) {
			FullName = new TextReadOnly();
			FullName.setBounds(new Rectangle(206, 10, 137, 20));
		}
		return FullName;
	}

	public TextReadOnly getChiName() {
		if (ChiName == null) {
			ChiName = new TextReadOnly();
			ChiName.setBounds(new Rectangle(347, 10, 87, 20));
		}
		return ChiName;
	}

	public LabelBase getBedCodeDesc() {
		if (BedCodeDesc == null) {
			BedCodeDesc = new LabelBase();
			BedCodeDesc.setText("Bed Code");
			BedCodeDesc.setBounds(444, 10, 69, 20);
		}
		return BedCodeDesc;
	}

	public TextReadOnly getBedCode() {
		if (BedCode == null) {
			BedCode = new TextReadOnly();
			BedCode.setBounds(new Rectangle(510, 10, 90, 20));
		}
		return BedCode;
	}

	public LabelBase getAcmCodeDesc() {
		if (AcmCodeDesc == null) {
			AcmCodeDesc = new LabelBase();
			AcmCodeDesc.setText("ACM Code");
			AcmCodeDesc.setBounds(610, 10, 72, 20);
		}
		return AcmCodeDesc;
	}

	public TextReadOnly getAcmCode() {
		if (AcmCode == null) {
			AcmCode = new TextReadOnly();
			AcmCode.setBounds(new Rectangle(682, 10, 61, 20));
		}
		return AcmCode;
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
			SlipNo = new TextString(){
				@Override
				protected void onPressed() {
					if (!SlipNo.isEmpty() && (lastSlipNo != null && !lastSlipNo.equals(getText()))) {
						getFullName().resetText();
						getChiName().resetText();
						getBedCode().resetText();
						getAdmDate().resetText();
						getLeaveDT().resetText();
						getReturnDT().resetText();
						getDischangeDate().resetText();
						getListTable().removeAllRow();
					} else if (isEmpty()) {
						lastSlipNo = getText();
					}
				}

				@Override
				protected void onReleased() {
					if ((lastSlipNo != null && !lastSlipNo.equals(getText()))) {
						getFullName().resetText();
						getChiName().resetText();
						getBedCode().resetText();
						getAdmDate().resetText();
						getDischangeDate().resetText();
						getLeaveDT().resetText();
						getReturnDT().resetText();
						getListTable().removeAllRow();
					}

					if (isEmpty()) {
						lastSlipNo = getText();
					}
				}

				@Override
				protected void onFocus() {
					// override by child class when on focus
					if("SlipSearch".equals(getParameter("AcceptClass")) && isRendered()){
						return;
					}
					if (!SlipNo.isEmpty() && (lastSlipNo != null && !lastSlipNo.equals(getText()))) {
						onBlur();
					}
				}

				@Override
				public void onBlur() {
					if (!SlipNo.isEmpty() && (lastSlipNo != null && !lastSlipNo.equals(getText()))) {
						if("SlipSearch".equals(getParameter("AcceptClass")) && isRendered()){
							removeParameter("AcceptClass");
							removeParameter("SlpNo");
						}
						lastSlipNo = getText();
						checkSlpNo(SlipNo.getText(),getPatientNo().getText());
					}
				}
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
			AdmDate.setBounds(new Rectangle(310, 40, 152, 20));
		}
		return AdmDate;
	}

	public LabelBase getDischangeDateDesc() {
		if (DischangeDateDesc == null) {
			DischangeDateDesc = new LabelBase();
			DischangeDateDesc.setText("Dischange Date");
			DischangeDateDesc.setBounds(478, 40, 104, 20);
		}
		return DischangeDateDesc;
	}

	public TextReadOnly getDischangeDate() {
		if (DischangeDate == null) {
			DischangeDate = new TextReadOnly();
			DischangeDate.setBounds(new Rectangle(582, 40, 152, 20));
		}
		return DischangeDate;
	}

	public LabelBase getHomeLeaveDesc() {
		if (HomeLeaveDesc == null) {
			HomeLeaveDesc = new LabelBase();
			HomeLeaveDesc.setText("Home Leave");
			HomeLeaveDesc.setBounds(10, 70, 81, 20);
		}
		return HomeLeaveDesc;
	}

	public CheckBoxBase getHomeLeave() {
		if (HomeLeave == null) {
			HomeLeave = new CheckBoxBase();
			HomeLeave.setBounds(new Rectangle(97, 71, 23, 20));
		}
		return HomeLeave;
	}

	public LabelBase getLeaveDTDesc() {
		if (LeaveDTDesc == null) {
			LeaveDTDesc = new LabelBase();
			LeaveDTDesc.setText("Leave Datetime");
			LeaveDTDesc.setBounds(20, 113, 116, 20);
		}
		return LeaveDTDesc;
	}

	public TextDateTime getLeaveDT() {
		if (LeaveDT == null) {
			LeaveDT = new TextDateTime(true,true,getListTable(),3){
				@Override
				public void onBlur() {
					if (!isEmpty()) {
						if (getListTable().getSelectedRow() > -1) {
							if (validate()) {
								getListTable().setValueAt(getText(), getListTable().getSelectedRow(), 3);
								setText(getRawValue());
							}
						}
					   }
					}
			};
			LeaveDT.setBounds(136, 114, 152, 20);
		}
		return LeaveDT;
	}

	public LabelBase getReturnDTDesc() {
		if (ReturnDTDesc == null) {
			ReturnDTDesc = new LabelBase();
			ReturnDTDesc.setText("Return Datetime");
			ReturnDTDesc.setBounds(20, 138, 116, 20);
		}
		return ReturnDTDesc;
	}

	public TextDateTime getReturnDT() {
		if (ReturnDT == null) {
			ReturnDT = new TextDateTime(true,true,getListTable(),5){
				@Override
				public void onBlur() {
					if (!isEmpty()) {
						if (getListTable().getSelectedRow() > -1) {
							if (validate()) {
								getListTable().setValueAt(getText(), getListTable().getSelectedRow(), 5);
								setText(getRawValue());
							}
						}
					   }
					}
			};
			ReturnDT.setBounds(new Rectangle(136, 138, 152, 20));
		}
		return ReturnDT;
	}

	public FieldSetBase getListPanel() {
		if (ListPanel == null) {
			ListPanel = new FieldSetBase();
			ListPanel.setHeading("Home Leave History");
			ListPanel.setBounds(new Rectangle(7, 174, 757, 336));
			ListPanel.add(getLeaveScrollPane());
		}
		return ListPanel;
	}

	/**
	 * This method initializes jScrollPane
	 *
	 * @return JScrollPane
	 */
	protected JScrollPane getLeaveScrollPane() {
		if (leaveScrollPanel == null) {
			leaveScrollPanel = new JScrollPane();
			getJScrollPane().removeViewportView(getListTable());
			leaveScrollPanel.setViewportView(getListTable());
			leaveScrollPanel.setBounds(15, 0, 725, 295);
		}
		return leaveScrollPanel;
	}
}