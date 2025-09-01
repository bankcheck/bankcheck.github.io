package com.hkah.client.layout.dialog;

import java.util.Date;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.form.Field;
import com.extjs.gxt.ui.client.widget.form.RadioGroup;
import com.extjs.gxt.ui.client.widget.layout.AbsoluteLayout;
import com.google.gwt.user.datepicker.client.CalendarUtil;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.radiobutton.RadioButtonBase;
import com.hkah.client.layout.table.EditorTableList;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgClearSchedule extends DialogBase {

    private final static int m_frameWidth = 380;
    private final static int m_frameHeight = 200;

	private FieldSetBase dialogTopPanel = null;
	private RadioButtonBase singleDoctor = null;
	private RadioButtonBase allDoctor = null;
	private RadioButtonBase bySpecialty = null;
	private RadioGroup btnGoup = null;
	private JScrollPane specScrollPane = null;
	private EditorTableList specListTable = null;
	private LabelBase dFromDateDesc = null;
	private TextDate dFromDate = null;
	private LabelBase dToDateDesc = null;
	private TextDate dToDate = null;

	private String memDocCode = null;

	public DlgClearSchedule(MainFrame owner) {
		super(owner, Dialog.OKCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	private void initialize() {
		setTitle("Clear Doctor Schedule");
		setLayout(new AbsoluteLayout());
		add(getDialogTopPanel(), null);

		// limit the date selection
		Date toDate = new Date();
		getDFromDate().setMinValue(toDate);
		//CalendarUtil.addDaysToDate(toDate, 1);
		//getDToDate().setMinValue(toDate);

		// change label
		getButtonById(OK).setText("Confirm");
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	public void setVisible(boolean visible) {
		super.setVisible(visible);

		// reset table selection
		//getSpecListTable().getStore().rejectChanges();
		//getSpecListTable().getView().refresh(false);
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String docCode, String docName) {
		// reset date range
		getDFromDate().resetText();
		//getDToDate().resetText();

		if (docCode != null && docCode.trim().length() > 0) {
			memDocCode = docCode.trim();
			if (docName != null && docName.trim().length() > 0) {
				displayDoctorInfo(memDocCode, docName);
			} else {
				QueryUtil.executeMasterFetch(getUserInfo(), "DOCTOR",
						new String[] { memDocCode },
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						String docName2 = null;
						if (mQueue.success()) {
							docName2 = mQueue.getContentField()[1] + SPACE_VALUE + mQueue.getContentField()[2];
						}
						displayDoctorInfo(memDocCode, docName2);
					}
				});
			}
		} else {
			displayDoctorInfo(null, null);
		}
	}

	private void displayDoctorInfo(String docCode, String docName) {
		StringBuffer doctorDesc = new StringBuffer();
		if (docCode != null && docName != null) {
			doctorDesc.append("[");
			doctorDesc.append(docCode.trim());
			doctorDesc.append("] ");
			doctorDesc.append(docName);

			getSingleDoctor().setText(doctorDesc.toString());
			getSingleDoctor().setVisible(true);
			getSingleDoctor().setEnabled(true);

			getSingleDoctor().setSelected(true);
		} else {
			getSingleDoctor().setVisible(false);
			getSingleDoctor().setEnabled(false);
			getSingleDoctor().resetText();

		//	getAllDoctor().setSelected(true);
		}
	//	getSpecScrollPane().setEnabled(false);

		setVisible(true);
	}

	private boolean isGenValidate(String startdate) {
		String errorMsg = null;
		if (!getDFromDate().isValid()) {
			errorMsg = ConstantsMessage.MSG_INVALID_TIME;
		} else if (startdate.length() == 0 ) {
			errorMsg = ConstantsMessage.MSG_ADDSCH_SAMEDATE;
		} else if (DateTimeUtil.compareTo(getMainFrame().getServerDate(), startdate) > 0) {
			errorMsg = ConstantsMessage.MSG_ADDSCH_PASSDATE;
		} else if (memDocCode.length() == 0 || memDocCode == null) {
			errorMsg = "Invalide Doctor";
		}
		if (errorMsg != null) {
			Factory.getInstance().addErrorMessage(errorMsg, "PBA - [Clear Doctor Schedule]", getDFromDate());
			return false;
		} else {
			return true;
		}
	}

	@Override
	protected void doOkAction() {
		doGenerate(false);
	}

	private void doGenerate(boolean isBlockSchedule) {
		if (!isGenValidate(getDFromDate().getText().trim())) {
			return;
		}

		if (getSingleDoctor().isSelected()) {
			QueryUtil.executeMasterAction(getUserInfo(),
					"SCHEDULE_CLRDR",
					QueryUtil.ACTION_APPEND,
					new String[] {
						memDocCode,
						getDFromDate().getText().trim(),
						isBlockSchedule?YES_VALUE:NO_VALUE,
						CommonUtil.getComputerName(),
						getUserInfo().getUserID()
					},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						Factory.getInstance().addInformationMessage("Schedule cleared successfully", "PBA - [Clear Doctor Schedule]", 
								new Listener<MessageBoxEvent>() {
									@Override
									public void handleEvent(
											MessageBoxEvent be) {
										// TODO Auto-generated method stub
										dispose();
									}
						});
					} else if ("-100".equals(mQueue.getReturnCode())) {
						MessageBoxBase.confirm(ConstantsMessage.MSG_PBA_SYSTEM, mQueue.getReturnMsg(), new Listener<MessageBoxEvent>() {
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									doGenerate(true);
								} else {
									dispose();
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

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/* >>> override getListWidth for adjust the width of the table list========<<<< */
	protected int getListWidth() {
		return 790;
	}

	public FieldSetBase getDialogTopPanel() {
		if (dialogTopPanel == null) {
			dialogTopPanel = new FieldSetBase();
			dialogTopPanel.setHeading("Generation Information");
			dialogTopPanel.setBounds(5, 5, 350, 410);
			dialogTopPanel.add(getSingleDoctor(), null);
		//	dialogTopPanel.add(getAllDoctor(), null);
		//	dialogTopPanel.add(getBySpecialty(), null);
		//	dialogTopPanel.add(getSpecScrollPane(), null);
			dialogTopPanel.add(getDFromDateDesc(), null);
			dialogTopPanel.add(getDFromDate(), null);
		//	dialogTopPanel.add(getDToDateDesc(), null);
		//	dialogTopPanel.add(getDToDate(), null);
			getBtnGoup();
//			QueryUtil.executeMasterFetch(getUserInfo(), "SPECIALTY",
//					new String[] { EMPTY_VALUE},
//					new MessageQueueCallBack() {
//				@Override
//				public void onPostSuccess(MessageQueue mQueue) {
//					if (mQueue.success()) {
//						//getSpecListTable().setColumnClass(0, new CheckBoxBase(), true);
//						getSpecListTable().setListTableContent(mQueue);
//					} else {
//						Factory.getInstance().addErrorMessage("Fail to connect server.");
//					}
//				}
//			});
		}
		return dialogTopPanel;
	}

	public RadioButtonBase getSingleDoctor() {
		if (singleDoctor == null) {
			singleDoctor = new RadioButtonBase();
			singleDoctor.setSelected(true);
			singleDoctor.setBounds(5, 0, 200, 20);
		}
		return singleDoctor;
	}

//	public RadioButtonBase getAllDoctor() {
//		if (allDoctor == null) {
//			allDoctor = new RadioButtonBase() {
//				public void onClick() {
//					getSpecScrollPane().setEnabled(getBySpecialty().isSelected());
////					getSpecListTable().setAutoscrolls(false);
//				}
//			};
//			allDoctor.setText("All Doctor");
//			allDoctor.setBounds(5, 25, 200, 20);
//		}
//		return allDoctor;
//	}

//	public RadioButtonBase getBySpecialty() {
//		if (bySpecialty == null) {
//			bySpecialty = new RadioButtonBase() {
//				public void onClick() {
//					getSpecScrollPane().setEnabled(getBySpecialty().isSelected());
////					getSpecListTable().setAutoscrolls(true);
//				}
//			};
//			bySpecialty.setText("By Specialty");
//			bySpecialty.setBounds(5, 50, 200, 20);
//		}
//		return bySpecialty;
//	}

	public RadioGroup getBtnGoup() {
		if (btnGoup == null) {
			btnGoup = new RadioGroup();
			btnGoup.add(getSingleDoctor());
//			btnGoup.add(getAllDoctor());
//			btnGoup.add(getBySpecialty());
		}
		return btnGoup;
	}

//	public JScrollPane getSpecScrollPane() {
//		if (specScrollPane == null) {
//			specScrollPane = new JScrollPane();
//			specScrollPane.setViewportView(getSpecListTable());
//			specScrollPane.setBounds(5, 75, 335, 250);
//		}
//		return specScrollPane;
//	}

//	public EditorTableList getSpecListTable() {
//		if (specListTable == null) {
//			specListTable = new EditorTableList(
//					getSpecColumnNames(),
//					getSpecColumnWidths(),
//					getSpecColumnEditor()
//			);
//			specListTable.setTableLength(getListWidth());
//		}
//		return specListTable;
//	}

	public LabelBase getDFromDateDesc() {
		if (dFromDateDesc == null) {
			dFromDateDesc = new LabelBase();
			dFromDateDesc.setText("From Date");
			dFromDateDesc.setBounds(10, 30, 80, 20);
		}
		return dFromDateDesc;
	}

	public TextDate getDFromDate() {
		if (dFromDate == null) {
			dFromDate = new TextDate();
			dFromDate.setBounds(110,30, 150, 20);
		}
		return dFromDate;
	}

//	public LabelBase getDToDateDesc() {
//		if (dToDateDesc == null) {
//			dToDateDesc = new LabelBase();
//			dToDateDesc.setText("To");
//			dToDateDesc.setBounds(35, 355, 80, 20);
//		}
//		return dToDateDesc;
//	}

//	public TextDate getDToDate() {
//		if (dToDate == null) {
//			dToDate = new TextDate();
//			dToDate.setBounds(110, 355, 150, 20);
//		}
//		return dToDate;
//	}


}