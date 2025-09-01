package com.hkah.client.tx.registration;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.tx.ActionPanel;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class PatientAlert extends ActionPanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.PATIENTALERT_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.PATIENTALERT_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"",
				"Alert code",
				"Description",
				"Added by",
				"Add date",
				"Cancelled by",
				"Cancel date",
				"altid",
				"palid"
			};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				10,
				120,
				180,
				100,
				90,
				100,
				90,
				0,
				0
		};
	}

	private BasePanel actionPanel = null;

	private BasePanel ParaPanel = null;
	private LabelBase PatientNoDesc = null;
	private TextReadOnly PatientNo = null;
	private LabelBase PatientNameDesc = null;
	private TextReadOnly PatientFullName = null; // right top patient foreign name
	private TextReadOnly PatientCName = null; // right top patient Chinese name
	private LabelBase SexDesc = null;
	private TextReadOnly Sex = null;

	private LabelBase AvaAlertDesc = null;
	private LabelBase SelectAlertDesc = null;
	private CheckBoxBase ShowHistory = null;

	private BasePanel ListPanel = null;

	private TableList SelectedAlertTable = null;
	private TableList AvaAlertTable = null;
	private JScrollPane SelectedAlertSP = null;
	private JScrollPane AvaAlertSP = null;

	/**
	 * This method initializes
	 *
	 */
	public PatientAlert() {
		super();
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		setNoListDB(false);

		getPatientNo().setText(getParameter("PATNO"));
		getPatientFullName().setText(getParameter("Patfname") + " " + getParameter("patgname"));
		getPatientCName().setText(getParameter("patcname"));
		getSex().setText(getParameter("patsex"));

		// call search action
		searchAction(false);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public Component getDefaultFocusComponent() {
		return getPatientNo();
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
				getPatientNo().getText(),
				getShowHistory().isSelected()?"-1":"0",
						getUserInfo().getUserID()
		};
	}

	/* >>> ~16~ Set Fetch Input Parameters ============================ <<< */
	@Override
	protected String[] getFetchInputParameters() {
		String[] selectedContent = getSelectedAlertTable().getSelectedRowContent();
		return new String[] {
				selectedContent[8],
				getPatientNo().getText(),
				getUserInfo().getUserID(),
				selectedContent[3],
				selectedContent[4]
		};
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return new String[] {};
	}

	/* >>> ~17.1~ Set Action Input Parameters ============================= <<< */
	@Override
	protected void getNewOutputValue(String returnValue) {}

	/***************************************************************************
	 * Override Methods
	 **************************************************************************/

	@Override
	protected void enableButton(String mode) {
		disableButton();
		getModifyButton().setEnabled(getActionType() == null && !isDisableFunction("TB_MODIFY", "mnuAlert"));
		getDeleteButton().setEnabled(getActionType() == null && getSelectedAlertTable().getRowCount() > 0 && 
									!isDisableFunction("TB_DELETE", "mnuAlert"));
		getCancelButton().setEnabled(getActionType() != null);
		getShowHistory().setEnabled(getActionType() == null);
	}

	protected TableList getCurrentListTable() {
		return getSelectedAlertTable();
	}

	@Override
	protected void searchPostAction() {		
		getAvaAlertTable().setListTableContent("PATALERTEDIT",
				new String[] { getPatientNo().getText(), getUserInfo().getUserID() });

		// refresh button status
		enableButton();
	}

	@Override
	public void deleteAction() {
		if (getDeleteButton().isEnabled() && getSelectedAlertTable().getSelectedRow() >= 0) {
			Factory.getInstance().isConfirmYesNoDialog("Delete the alert?", new Listener<MessageBoxEvent>() {
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						setActionType(QueryUtil.ACTION_DELETE);

						enableButton();
						deleteDisabledFields();

						// call after all action done
						deletePostAction();

						String[] selectedContent = getSelectedAlertTable().getSelectedRowContent();
						QueryUtil.executeMasterAction(getUserInfo(), getTxCode(), QueryUtil.ACTION_DELETE,
								new String[] {
									selectedContent[7],
									getPatientNo().getText(),
									getUserInfo().getUserID(),
									selectedContent[4],
									selectedContent[8]
								},
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									searchAction();
								}
							}
						});
					}
				}
			});
		}
	}

	@Override
	public void saveAction() {
		if (getSaveButton().isEnabled()) {
//			if (performAction()) {
				confirmCancelButtonClicked();
				for (int i = 0; i < getSelectedAlertTable().getRowCount(); i++) {
					if ("new".equals(getSelectedAlertTable().getValueAt(i, 8).trim())) { //not save records
						getSelectedAlertTable().setSelectRow(i);
						String[] selectedContent = getSelectedAlertTable().getRowContent(i);
						QueryUtil.executeMasterAction(getUserInfo(), getTxCode(), QueryUtil.ACTION_MODIFY,
								new String[] {
									selectedContent[7],
									getPatientNo().getText(),
									getUserInfo().getUserID(),
									selectedContent[4],
									selectedContent[8]
								},
								new MessageQueueCallBack() {
							public void onPostSuccess(MessageQueue mQueue) {
								saveReady(mQueue.success());
							}
						});
					}
				}
			//}
		}
	}

	private void saveReady(boolean saveSuccess) {
		if (saveSuccess) {
			searchAction();
		}
	}

	@Override
	public void cancelPostAction() {
		searchAction();
	}

	/***************************************************************************
	 * Layout Methods
	 **************************************************************************/

	@Override
	protected BasePanel getActionPanel() {
		if (actionPanel == null) {
			actionPanel = new BasePanel();
			actionPanel.setSize(779, 480);
			actionPanel.add(getParaPanel(),null);
			actionPanel.add(getListPanel(), null);
		}
		return actionPanel;
	}

	public BasePanel getParaPanel() {
		if (ParaPanel == null) {
			ParaPanel = new BasePanel();
			ParaPanel.setBounds(5, 5, 757, 50);
			ParaPanel.add(getPatientNoDesc(), null);
			ParaPanel.add(getPatientNo(), null);
			ParaPanel.add(getPatientNameDesc(), null);
			ParaPanel.add(getPatientFullName(), null);
			ParaPanel.add(getPatientCName(), null);
			ParaPanel.add(getSexDesc(), null);
			ParaPanel.add(getSex(), null);
			ParaPanel.setBorders(true);
		}
		return ParaPanel;
	}

	public LabelBase getPatientNoDesc() {
		if (PatientNoDesc == null) {
			PatientNoDesc = new LabelBase();
			PatientNoDesc.setText("Patient Number");
			PatientNoDesc.setBounds(10, 10, 90, 20);
		}
		return PatientNoDesc;
	}

	public TextReadOnly getPatientNo() {
		if ( PatientNo == null) {
			 PatientNo = new TextReadOnly();
			 PatientNo.setBounds(102, 10, 80, 20);
		}
		return  PatientNo;
	}

	public LabelBase getPatientNameDesc() {
		if (PatientNameDesc == null) {
			PatientNameDesc = new LabelBase();
			PatientNameDesc.setText("Patient Name");
			PatientNameDesc.setBounds(190, 10, 90, 20);
		}
		return PatientNameDesc;
	}

	public TextReadOnly getPatientFullName() {
		if (PatientFullName == null) {
			PatientFullName = new TextReadOnly();
			PatientFullName.setBounds(287, 10, 180, 20);
		}
		return PatientFullName;
	}

	public TextReadOnly getPatientCName() {
		if (PatientCName == null) {
			PatientCName = new TextReadOnly();
			PatientCName.setBounds(472, 10, 80, 20);
		}
		return PatientCName;
	}

	public LabelBase getSexDesc() {
		if (SexDesc == null) {
			SexDesc = new LabelBase();
			SexDesc.setText("Sex");
			SexDesc.setBounds(576, 10, 33, 20);
		}
		return SexDesc;
	}

	public TextReadOnly getSex() {
		if (Sex == null) {
			Sex = new TextReadOnly();
			Sex.setBounds(608, 10, 80, 20);
		}
		return Sex;
	}

	public LabelBase getAvaAlertDesc() {
		if (AvaAlertDesc == null) {
			AvaAlertDesc = new LabelBase();
			AvaAlertDesc.setBounds(10, 5, 100, 20);
			AvaAlertDesc.setText("<html><b>Available Alert</html>");
		}
		return AvaAlertDesc;
	}

	public LabelBase getSelectAlertDesc() {
		if (SelectAlertDesc == null) {
			SelectAlertDesc = new LabelBase();
			SelectAlertDesc.setBounds(10, 205, 100, 20);
			SelectAlertDesc.setText("<html><b>Selected Alert</html>");
		}
		return SelectAlertDesc;
	}

	public CheckBoxBase getShowHistory() {
		if (ShowHistory == null) {
			ShowHistory = new CheckBoxBase("Show History") {
				public void onClick() {
					if (getShowHistory().isSelected()) {
						getModifyButton().setEnabled(false);
						getDeleteButton().setEnabled(false);
					} else {
						enableButton();
					}
					String[] inParam = new String[] {
							getPatientNo().getText(),
							getShowHistory().isSelected()?"-1":"0",
									getUserInfo().getUserID()};
					getSelectedAlertTable().setListTableContent(getTxCode(), inParam);
				}
			};
			ShowHistory.setBounds(641, 210, 23, 20);
		}
		return ShowHistory;
	}

	public BasePanel getListPanel() {
		if (ListPanel == null) {
			ListPanel = new BasePanel();
			ListPanel.setBounds(5, 63, 757, 401);
			ListPanel.add(getAvaAlertDesc());
			ListPanel.add(getAvaAlertSP());
			ListPanel.add(getSelectAlertDesc());
			ListPanel.add(getShowHistory());
			ListPanel.add(getSelectedAlertSP());
			ListPanel.setBorders(true);
		}
		return ListPanel;
	}

	private JScrollPane getAvaAlertSP() {
		if (AvaAlertSP == null) {
			AvaAlertSP = new JScrollPane();
			AvaAlertSP.setViewportView(getAvaAlertTable());
			AvaAlertSP.setBounds(10, 40, 725, 160);
		}
		return AvaAlertSP;
	}

	private TableList getAvaAlertTable() {
		if (AvaAlertTable == null) {
			AvaAlertTable = new TableList(getAvaAlertTableColumnNames(), getAvaAlertTableColumnWidths()) {
				public void doubleClick() {
					if (QueryUtil.ACTION_MODIFY.equals(getActionType())) {
						String row[] = new String[] {
							null,
							getAvaAlertTable().getSelectedRowContent()[1],
							getAvaAlertTable().getSelectedRowContent()[2],
							getUserInfo().getUserID(),
							getMainFrame().getServerDate(),
							null,
							null,
							getAvaAlertTable().getSelectedRowContent()[3],
							"new"
						};
						getSelectedAlertTable().addRow(row);
						int selectrow = getAvaAlertTable().getSelectedRow();
						int rowcount = getAvaAlertTable().getRowCount();
						getAvaAlertTable().removeRow(selectrow);
						if (selectrow == (rowcount - 1)) {
							getAvaAlertTable().setRowSelectionInterval(selectrow-1,selectrow-1);
						} else {
							getAvaAlertTable().setRowSelectionInterval(selectrow,selectrow);
						}
						getSaveButton().setEnabled(true);
					}
				}
			};
		}
		return AvaAlertTable;
	}

	protected String[] getAvaAlertTableColumnNames() {
		return new String[] {
				"",
				"Alert Code",
				"Description",
				"altid"
				};
	}

	protected int[] getAvaAlertTableColumnWidths() {
		return new int[] {
				10,
				150,
				300,
				0
				};
	}

	private JScrollPane getSelectedAlertSP() {
		if (SelectedAlertSP == null) {
			SelectedAlertSP = new JScrollPane();
			SelectedAlertSP.setBounds(10, 240, 730, 140);
			SelectedAlertSP.setViewportView(getSelectedAlertTable());
		}
		return SelectedAlertSP;
	}

	private TableList getSelectedAlertTable() {
		if (SelectedAlertTable == null) {
			SelectedAlertTable = new TableList(getColumnNames(), getColumnWidths());
		}
		return SelectedAlertTable;
	}
}