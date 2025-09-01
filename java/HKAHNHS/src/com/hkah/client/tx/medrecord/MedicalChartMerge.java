package com.hkah.client.tx.medrecord;

import java.util.List;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.tx.MaintenancePanel;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsProperties;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class MedicalChartMerge extends MaintenancePanel{

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.MEDRECMERGE_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.MEDCHARTMERGE_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				10,
				250,
				300,
				300
				};
	}
	protected String[] getColumnNames() {
		return new String[] {
				"",
				"Table",
				"Field name",
				"Field Reference"
				};
	}

	// property declare start
	private ColumnLayout rightPanel = null;
	private ColumnLayout searchPanel = null;
	private BasePanel leftPanel = null;
	private LabelBase fromPatNoDesc = null;
	private TextPatientNoSearch fromPatNo = null;
	private LabelBase fromPatNameDesc = null;
	private TextReadOnly fromPatFName = null;
	private TextReadOnly fromPatGName = null;
	private LabelBase fromPatSexDesc = null;
	private TextReadOnly fromPatSex = null;
	private LabelBase fromDOBDesc = null;
	private TextReadOnly fromDOB = null;
	private LabelBase fromHKIDDesc = null;
	private TextReadOnly fromHKID = null;
	private LabelBase toPatNoDesc = null;
	private TextPatientNoSearch toPatNo = null;
	private LabelBase toPatNameDesc = null;
	private TextReadOnly toPatFName = null;
	private TextReadOnly toPatGName = null;
	private LabelBase toPatSexDesc = null;
	private TextReadOnly toPatSex = null;
	private LabelBase toDOBDesc = null;
	private TextReadOnly toDOB = null;
	private LabelBase toHKIDDesc = null;
	private TextReadOnly toHKID = null;
	private LabelBase handleDateDesc = null;
	private TextReadOnly handleDate = null;
	private LabelBase handledByDesc = null;
	private TextReadOnly handledBy = null;
	private ButtonBase historyAction = null;

	private String frPatNoFrHist;

	/**
	 * This method initializes
	 *
	 */
	public MedicalChartMerge() {
		super();
		getListTable().setHeight(400);
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		enableButton(null);

		frPatNoFrHist = null;
		if (getListParameter("PATMER")!=null ) {
			List<String[]> list = getListParameter("PATMER");
			if (list.size() != 1) {
				return;
			}
			frPatNoFrHist = list.get(0)[2];;
			getFromPatNo().setText(frPatNoFrHist);
			getFromPatFName().setText(list.get(0)[3]);
			getFromPatGName().setText(list.get(0)[4]);
			getFromPatSex().setText(list.get(0)[5]);
			getFromDOB().setText(list.get(0)[6]);
			getFromHKID().setText(list.get(0)[7]);

			getToPatNo().setText(list.get(0)[8]);
			getToPatFName().setText(list.get(0)[9]);
			getToPatGName().setText(list.get(0)[10]);
			getToPatSex().setText(list.get(0)[11]);
			getToDOB().setText(list.get(0)[12]);
			getToHKID().setText(list.get(0)[13]);
			getHandleDate().setText(list.get(0)[1]);
			getHandledBy().setText(list.get(0)[14]);
			insertListTable(frPatNoFrHist);
			removeParameter();
		}
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextPatientNoSearch getDefaultFocusComponent() {
		return getFromPatNo();
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

	/* >>> ~14~ Set Browse Validation ===================================== <<< */
	@Override
	protected boolean browseValidation() {

		return true;
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {

		return new String[] {
		};
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
		enableButton(null);
	}

	/* >>> ~15~ Set Fetch Output Results ============================== <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {}

	/* >>> ~16.1~ Set Action Output Parameters =========================== <<< */
	@Override
	protected void getNewOutputValue(String returnValue) {}

	protected void insertListTable(String patno) {
		getListTable().removeAllRow();
		if (getListParameter("PATMER")!=null ) {
			getListTable().setListTableContent(ConstantsTx.MEDRECMERGE_TXCODE, new String[] {"LIS",patno});
		} else {
			getListTable().setListTableContent(ConstantsTx.MEDRECMERGE_TXCODE, new String[] {"ADD",patno});
		}
	}

	/* >>> ~19~ Set Add Action Validation ================================= <<< */
	@Override
	protected boolean addActionValidation() {
		if (getFromPatNo().getText().trim().isEmpty() || getToPatNo().getText().trim().isEmpty() ) {
			return false;
		} else {
			return true;
		}
	}

	/* >>> ~22~ Set Action Input Parameters per table ===================== <<< */
	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		return new String[] {
				getFromPatNo().getText().trim(),
				getToPatNo().getText().trim(),
				selectedContent[2],
				selectedContent[3],
				selectedContent[1],
				getUserInfo().getUserID()
		};
	}

	/* >>> ~23~ Set Action Validation per table =========================== <<< */
	@Override
	protected boolean actionValidation(String[] selectedContent) {
		return true;
	}

	@Override
	public boolean isTableViewOnly() {
		return false;
	}

	@Override
	protected void listTablePostSaveTable(boolean success) {
		if(success){
			Factory.getInstance().addInformationMessage("Merged Successfully!");
		}
		getListTable().setListTableContent(
							ConstantsTx.MEDRECMERGE_TXCODE,
							new String[] {
									"LIS",
									getFromPatNo().getText().trim()
							});
		setActionType(null);
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void superSaveAction() {
		super.saveAction();
	}

	protected void showPatientInfo(Component comp, String mergePatNo) {
		if (comp.equals(getFromPatNo())) {
			showFromPatientInfo(mergePatNo);
		} else if (comp.equals(getToPatNo())) {
			 showToPatientInfo(mergePatNo);
		}
	}

	protected void showFromPatientInfo(String patno) {
		QueryUtil.executeMasterFetch(getUserInfo(), "PATIENTBYNO",
				new String[] {patno},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				// TODO Auto-generated method stub
				getFromPatFName().setText(mQueue.getContentField()[0]);
				getFromPatGName().setText(mQueue.getContentField()[1]);
				getFromHKID().setText(mQueue.getContentField()[2]);
				getFromDOB().setText(mQueue.getContentField()[3]);
				getFromPatSex().setText(mQueue.getContentField()[5]);
			}

			@Override
			public void onFailure(Throwable caught) {
				getFromPatNo().resetText();
				getFromPatFName().resetText();
				getFromPatGName().resetText();
				getFromHKID().resetText();
				getFromDOB().resetText();
				getFromPatSex().resetText();
			}
		});
	}

	protected void showToPatientInfo(String patno) {
		QueryUtil.executeMasterFetch(getUserInfo(), "PATIENTBYNO",
				new String[] {patno},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				// TODO Auto-generated method stub
				getToPatFName().setText(mQueue.getContentField()[0]);
				getToPatGName().setText(mQueue.getContentField()[1]);
				getToHKID().setText(mQueue.getContentField()[2]);
				getToDOB().setText(mQueue.getContentField()[3]);
				getToPatSex().setText(mQueue.getContentField()[5]);
			}

			@Override
			public void onFailure(Throwable caught) {
				getToPatNo().resetText();
				getToPatFName().resetText();
				getToPatGName().resetText();
				getToHKID().resetText();
				getToDOB().resetText();
				getToPatSex().resetText();
			}
		});
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	public void clearAction() {
		frPatNoFrHist = null;
		getListTable().removeAllRow();
		getFromPatNo().resetText();
		getFromPatFName().resetText();
		getFromPatGName().resetText();
		getFromPatSex().resetText();
		getFromDOB().resetText();
		getFromHKID().resetText();

		getToPatNo().resetText();
		getToPatFName().resetText();
		getToPatGName().resetText();
		getToPatSex().resetText();
		getToDOB().resetText();
		getToHKID().resetText();
		getHandleDate().resetText();
		getHandledBy().resetText();
		getHistoryAction().setEnabled(true);
	}

	@Override
	public void deleteAction() {
		//super.deleteAction();
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
	}

	@Override
	public void appendAction() {
		if (!getFromPatNo().isMergePatientNo() && !getToPatNo().isMergePatientNo()) {
			setActionType(QueryUtil.ACTION_APPEND);
			String frPatNo = getFromPatNo().getText().trim();
			getHandleDate().setText(getMainFrame().getServerDate());
			getHandledBy().setText(getUserInfo().getUserID());
			getHistoryAction().setEnabled(false);
			insertListTable(frPatNo);
			enableButton(null);
		} else {
			clearAction();
			enableButton(null);
		}
	}

	@Override
	protected void listTableContentPost() {
		if (getListTable().getRowCount() > 0) {
			enableButton(null);
		}
	}

	@Override
	public void saveAction() {
			// Patient merge warning if patients are enrolled to eHR
			final String toPatno = getToPatNo().getText().trim();
			final String fromPatno = getFromPatNo().getText().trim();
			QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] {"EHR_PMI", "PATNO", "PATNO IN ('" + fromPatno + "', '" + toPatno + "') AND ACTIVE = -1"},
					new MessageQueueCallBack() {
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						boolean isToPatnoEhr = false;
						boolean isFmPatnoEhr = false;
						List<String[]> list = mQueue.getContentAsArray();
						for (String[] f : list) {
							String patno = f[0];
							if (patno != null) {
								if(patno.equals(toPatno)) {
									isToPatnoEhr = true;
								}
								if(patno.equals(fromPatno)) {
									isFmPatnoEhr = true;
								}
							}
						}

						String errTitle = "Patient enrolled to eHR";
						String errMsg = null;
						boolean confirmBox = false;
						if (isToPatnoEhr) {
							if (isFmPatnoEhr) {
								errMsg = "Both numbers are enrolled to eHR. Merge is not allowed. Please contact IT Department.";
							} else {
								errMsg = "Patient No. " + toPatno + " is enrolled to eHR. Do you want to continue?";
								confirmBox = true;
							}
						} else {
							if (isFmPatnoEhr) {
								errMsg = "Patient No. " + fromPatno + " is enrolled to eHR. Do you want to continue?";
								confirmBox = true;
							}
						}

						if (confirmBox) {
							Factory.getInstance().isConfirmYesNoDialog(errTitle, errMsg,
									new Listener<MessageBoxEvent>(){
								@Override
								public void handleEvent(MessageBoxEvent be) {
									// TODO Auto-generated method stub
									if (Dialog.YES.equalsIgnoreCase(
											be.getButtonClicked().getItemId())) {
										saveMedChartMerge();
									}
								}
							});
						} else if (errMsg != null) {
							Factory.getInstance().addErrorMessage(errMsg, errTitle);
						}
					} else {
						saveMedChartMerge();
					}
				}
			});

		getHandleDate().setText(getMainFrame().getServerDateTime());
		getHistoryAction().setEnabled(true);
	}

	private void saveMedChartMerge() {
		getListTable().saveTable(ConstantsTx.MEDCHARTMERGE_TXCODE,
				new String[] {
				getToPatNo().getText().trim(),
				getFromPatNo().getText().trim(),
				getUserInfo().getUserID(),
				getUserInfo().getSiteCode(),
				Integer.toString(ConstantsProperties.DIP1)},
				false,
				false,
				false,
				true,
				false,
				"MERGEDTL");
	}

	@Override
	protected void performListPost() {
		getSaveButton().setEnabled(isAppend());
		getDeleteButton().setEnabled(isAppend() && getListTable().getRowCount() > 0);
	}

	@Override
	protected void enableButton(String mode) {
		// disable all button
		disableButton();
		getSearchButton().setEnabled(true);
		getAppendButton().setEnabled(!isDisableFunction("TB_INSERT", "mnuMedRecMerge"));
		if (frPatNoFrHist == null) {
			getHistoryAction().setEnabled((!getSaveButton().isEnabled()));
		}
		performListPost();
	}

	@Override
	protected boolean triggerSearchField() {
		if (getFromPatNo().isFocusOwner()) {
			getFromPatNo().checkTriggerBySearchKey();
			return true;
		} else if (getToPatNo().isFocusOwner()) {
			getToPatNo().checkTriggerBySearchKey();
			return true;
		} else {
			return false;
		}
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	@Override
	protected ColumnLayout getActionPanel() {
		if (rightPanel == null) {
			rightPanel = new ColumnLayout(1, 1);
		}
		return rightPanel;
	}

	public ColumnLayout getSearchPanel() {
		if (searchPanel == null) {
			searchPanel = new ColumnLayout(1, 1);
			searchPanel.add(0, 0, getLeftPanel());
		}
		return searchPanel;
	}

	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.add(getFromPatNoDesc());
			leftPanel.add(getFromPatNo());
			leftPanel.add(getFromPatNameDesc());
			leftPanel.add(getFromPatFName());
			leftPanel.add(getFromPatGName());
			leftPanel.add(getFromPatSexDesc());
			leftPanel.add(getFromPatSex());
			leftPanel.add(getFromDOBDesc());
			leftPanel.add(getFromDOB());
			leftPanel.add(getFromHKIDDesc());
			leftPanel.add(getFromHKID());
			leftPanel.add(getToPatNoDesc());
			leftPanel.add(getToPatNo());
			leftPanel.add(getToPatNameDesc());
			leftPanel.add(getToPatFName());
			leftPanel.add(getToPatGName());
			leftPanel.add(getToPatSexDesc());
			leftPanel.add(getToPatSex());
			leftPanel.add(getToDOBDesc());
			leftPanel.add(getToDOB());
			leftPanel.add(getToHKIDDesc());
			leftPanel.add(getToHKID());
			leftPanel.add(getHandleDateDesc());
			leftPanel.add(getHandleDate());
			leftPanel.add(getHandledByDesc());
			leftPanel.add(getHandledBy());
			leftPanel.setSize(900, 40);
			leftPanel.add(getHistoryAction());
		}
		return leftPanel;
	}

	public LabelBase getFromPatNoDesc() {
		if (fromPatNoDesc == null) {
			fromPatNoDesc = new LabelBase();
			fromPatNoDesc.setText("From Patient No.");
			fromPatNoDesc.setBounds(0, 5, 95, 20);
		}
		return fromPatNoDesc;
	}

	public TextPatientNoSearch getFromPatNo() {
		if (fromPatNo == null) {
			fromPatNo = new TextPatientNoSearch(false) {
				protected void checkPatient(boolean isExistPatient, boolean bySearchKey) {
					super.checkPatient(isExistPatient, bySearchKey);

					if (isExistPatient) {
						showPatientInfo(this, getFromPatNo().getText().trim());
					}
				}

				@Override
				public void showMergePatient(String toPatientNo) {
					setMergePatientNo(true);
					if (frPatNoFrHist == null || !getText().equals(frPatNoFrHist)) {
						super.showMergePatient(toPatientNo);
					} else {
						frPatNoFrHist = null;
					}
				}
			};
			fromPatNo.setBounds(100, 5, 80, 20);
		}
		return fromPatNo;
	}

	public LabelBase getFromPatNameDesc() {
		if (fromPatNameDesc == null) {
			fromPatNameDesc = new LabelBase();
			fromPatNameDesc.setText("Name");
			fromPatNameDesc.setBounds(185, 5, 40, 20);
		}
		return fromPatNameDesc;
	}

	public TextReadOnly getFromPatFName() {
		if (fromPatFName == null) {
			fromPatFName = new TextReadOnly();
			fromPatFName.setBounds(230, 5, 100, 20);
		}
		return fromPatFName;
	}

	public TextReadOnly getFromPatGName() {
		if (fromPatGName == null) {
			fromPatGName = new TextReadOnly();
			fromPatGName.setBounds(332, 5, 100, 20);
		}
		return fromPatGName;
	}

	public LabelBase getFromPatSexDesc() {
		if (fromPatSexDesc == null) {
			fromPatSexDesc = new LabelBase();
			fromPatSexDesc.setText("Sex");
			fromPatSexDesc.setBounds(437, 5, 25, 20);
		}
		return fromPatSexDesc;
	}

	public TextReadOnly getFromPatSex() {
		if (fromPatSex == null) {
			fromPatSex = new TextReadOnly();
			fromPatSex.setWidth(50);
			fromPatSex.setBounds(467, 5, 25, 20);
		}
		return fromPatSex;
	}

	public LabelBase getFromDOBDesc() {
		if (fromDOBDesc == null) {
			fromDOBDesc = new LabelBase();
			fromDOBDesc.setText("D.O.B");
			fromDOBDesc.setBounds(497, 5, 45, 20);
		}
		return fromDOBDesc;
	}

	public TextReadOnly getFromDOB() {
		if (fromDOB == null) {
			fromDOB = new TextReadOnly();
			fromDOB.setWidth(80);
			fromDOB.setBounds(547, 5, 80, 20);
		}
		return fromDOB;
	}

	public LabelBase getFromHKIDDesc() {
		if (fromHKIDDesc == null) {
			fromHKIDDesc = new LabelBase();
			fromHKIDDesc.setText("HKID");
			fromHKIDDesc.setBounds(632, 5, 50, 20);
		}
		return fromHKIDDesc;
	}

	public TextReadOnly getFromHKID() {
		if (fromHKID == null) {
			fromHKID = new TextReadOnly();
			fromHKID.setBounds(682, 5, 70, 20);
		}
		return fromHKID;
	}

	public LabelBase getToPatNoDesc() {
		if (toPatNoDesc == null) {
			toPatNoDesc = new LabelBase();
			toPatNoDesc.setText("To Patient No.");
			toPatNoDesc.setBounds(0, 30, 95, 20);
		}
		return toPatNoDesc;
	}

	public TextPatientNoSearch getToPatNo() {
		if (toPatNo == null) {
			toPatNo = new TextPatientNoSearch(false) {
				protected void checkPatient(boolean isExistPatient, boolean bySearchKey) {
					super.checkPatient(isExistPatient, bySearchKey);

					if (isExistPatient) {
						showPatientInfo(this, getToPatNo().getText().trim());
					}
				}
			};
			toPatNo.setBounds(100, 30, 80, 20);
			toPatNo.setWidth(80);
		}
		return toPatNo;
	}

	public LabelBase getToPatNameDesc() {
		if (toPatNameDesc == null) {
			toPatNameDesc = new LabelBase();
			toPatNameDesc.setText("Name");
			toPatNameDesc.setBounds(185, 30, 40, 20);
		}
		return toPatNameDesc;
	}

	public TextReadOnly getToPatFName() {
		if (toPatFName == null) {
			toPatFName = new TextReadOnly();
			toPatFName.setBounds(230, 30, 100, 20);
		}
		return toPatFName;
	}

	public TextReadOnly getToPatGName() {
		if (toPatGName == null) {
			toPatGName = new TextReadOnly();
			toPatGName.setBounds(332, 30, 100, 20);
		}
		return toPatGName;
	}

	public LabelBase getToPatSexDesc() {
		if (toPatSexDesc == null) {
			toPatSexDesc = new LabelBase();
			toPatSexDesc.setText("Sex");
			toPatSexDesc.setBounds(437, 30, 25, 20);
		}
		return toPatSexDesc;
	}

	public TextReadOnly getToPatSex() {
		if (toPatSex == null) {
			toPatSex = new TextReadOnly();
			toPatSex.setWidth(50);
			toPatSex.setBounds(467, 30, 25, 20);
		}
		return toPatSex;
	}

	public LabelBase getToDOBDesc() {
		if (toDOBDesc == null) {
			toDOBDesc = new LabelBase();
			toDOBDesc.setText("D.O.B");
			toDOBDesc.setBounds(497, 30, 45, 20);
		}
		return toDOBDesc;
	}

	public TextReadOnly getToDOB() {
		if (toDOB == null) {
			toDOB = new TextReadOnly();
			toDOB.setWidth(80);
			toDOB.setBounds(547, 30, 80, 20);
		}
		return toDOB;
	}

	public LabelBase getToHKIDDesc() {
		if (toHKIDDesc == null) {
			toHKIDDesc = new LabelBase();
			toHKIDDesc.setText("HKID");
			toHKIDDesc.setBounds(632, 30, 50, 20);
		}
		return toHKIDDesc;
	}

	public TextReadOnly getToHKID() {
		if (toHKID == null) {
			toHKID = new TextReadOnly();
			toHKID.setBounds(682, 30, 70, 20);
		}
		return toHKID;
	}

	public LabelBase getHandleDateDesc() {
		if (handleDateDesc == null) {
			handleDateDesc = new LabelBase();
			handleDateDesc.setText("Date");
			handleDateDesc.setBounds(0, 55, 95, 20);
		}
		return handleDateDesc;
	}

	public TextReadOnly getHandleDate() {
		if (handleDate == null) {
			handleDate = new TextReadOnly();
			handleDate.setWidth(70);
			handleDate.setBounds(100, 55, 120, 20);
		}
		return handleDate;
	}

	public LabelBase getHandledByDesc() {
		if (handledByDesc == null) {
			handledByDesc = new LabelBase();
			handledByDesc.setText("Handled By");
			handledByDesc.setBounds(230, 55, 80, 20);
		}
		return handledByDesc;
	}

	public TextReadOnly getHandledBy() {
		if (handledBy == null) {
			handledBy = new TextReadOnly();
			handledBy.setBounds(315, 55, 120, 20);
		}
		return handledBy;
	}

	public ButtonBase getHistoryAction() {
		if (historyAction == null) {
			historyAction = new ButtonBase() {
				@Override
				public void onClick() {
					showPanel(new MedicalChartMergeHist(), false);
				}
			};
			historyAction.setText("History");
			historyAction.setBounds(680, 55, 80, 20);
		}
		return historyAction;
	}
}