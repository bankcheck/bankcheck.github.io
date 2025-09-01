package com.hkah.client.layout.dialog;

import java.util.Date;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.form.RadioGroup;
import com.extjs.gxt.ui.client.widget.layout.AbsoluteLayout;
import com.google.gwt.user.datepicker.client.CalendarUtil;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.combobox.ComboDoctorLocation;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.radiobutton.RadioButtonBase;
import com.hkah.client.layout.table.TableData;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgGenerateSchedule extends DialogBase {

    private final static int m_frameWidth = 520;
    private final static int m_frameHeight = 510;

	private FieldSetBase dialogTopPanel = null;
	private RadioButtonBase singleDoctor = null;
	private RadioButtonBase allDoctor = null;
	private RadioButtonBase byLocation = null;
	private RadioButtonBase bySpecialty = null;
	private RadioGroup btnGoup = null;
	private ComboDoctorLocation docLocation = null;
	private LabelBase available = null;
	private TableList specListTableLeft = null;
	private TableList specListTableRight = null;
	private ButtonBase moveAllRightButtonBase = null;
	private ButtonBase moveRightButtonBase = null;
	private ButtonBase moveLeftButtonBase = null;
	private ButtonBase moveAllLeftButtonBase = null;
	private LabelBase selected = null;
	private JScrollPane specScrollPaneRight = null;
	private JScrollPane specScrollPaneLeft = null;
	private LabelBase dFromDateDesc = null;
	private TextDate dFromDate = null;
	private LabelBase dToDateDesc = null;
	private TextDate dToDate = null;

	private String memDocCode = null;
	private MessageQueue mQueueAllSpec = null;

	public DlgGenerateSchedule(MainFrame owner) {
		super(owner, Dialog.OKCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	private void initialize() {
		setTitle("Schedule Template Generation");
		setLayout(new AbsoluteLayout());
		add(getDialogTopPanel(), null);

		// limit the date selection
		Date toDate = DateTimeUtil.parseDateTime(getMainFrame().getServerDateTime());
		getDFromDate().setMinValue(toDate);
		CalendarUtil.addDaysToDate(toDate, 1);
		getDToDate().setMinValue(toDate);

		// change label
		getButtonById(OK).setText("Generate", 'G');
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String docCode, String docName, final String spcCode) {
		// reset date range
		getDFromDate().resetText();
		getDToDate().resetText();
		mQueueAllSpec = null;

		if (docCode != null && docCode.trim().length() > 0) {
			memDocCode = docCode.trim();
			if (docName != null && docName.trim().length() > 0) {
				displayDoctorInfo(memDocCode, docName, spcCode);
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
						displayDoctorInfo(memDocCode, docName2, spcCode);
					}
				});
			}
		} else {
			displayDoctorInfo(null, null, spcCode);
		}
	}

	private void displayDoctorInfo(String docCode, String docName, String specCode) {
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
			getDocLocation().setEnabled(false);
			getMoveAllRightButtonBase().setEnabled(false);
			getMoveRightButtonBase().setEnabled(false);
			getMoveLeftButtonBase().setEnabled(false);
			getMoveAllLeftButtonBase().setEnabled(false);
			getSpecScrollPaneLeft().setEnabled(false);
			getSpecScrollPaneRight().setEnabled(false);
		} else {
			getSingleDoctor().setVisible(false);
			getSingleDoctor().setEnabled(false);
			getSingleDoctor().resetText();

			if (specCode != null) {
				getDocLocation().setEnabled(false);
				getBySpecialty().setSelected(true);
				getMoveAllRightButtonBase().setEnabled(true);
				getMoveRightButtonBase().setEnabled(true);
				getMoveLeftButtonBase().setEnabled(true);
				getMoveAllLeftButtonBase().setEnabled(true);
				getSpecScrollPaneLeft().setEnabled(true);
				getSpecScrollPaneRight().setEnabled(true);
			} else {
				getAllDoctor().setSelected(true);
				getDocLocation().setEnabled(false);
				getMoveAllRightButtonBase().setEnabled(false);
				getMoveRightButtonBase().setEnabled(false);
				getMoveLeftButtonBase().setEnabled(false);
				getMoveAllLeftButtonBase().setEnabled(false);
				getSpecScrollPaneLeft().setEnabled(false);
				getSpecScrollPaneRight().setEnabled(false);
			}
		}

		getSpecListTableRight().removeAllRow();
		if (specCode != null) {
			getAllDoctor().setVisible(false);

			QueryUtil.executeComboBox(getUserInfo(), "SPECIALTY_PER_USER",
					new String[] { specCode, getUserInfo().getUserID() },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						mQueueAllSpec = mQueue;
						getSpecListTableLeft().setListTableContent(mQueueAllSpec);
						if (getSpecListTableLeft().getRowCount() > 0) {
							getSpecListTableLeft().setSelectRow(0);
						}
					} else {
						Factory.getInstance().addErrorMessage("Fail to connect server.");
					}
				}
			});
		} else {
			getAllDoctor().setVisible(true);

			QueryUtil.executeComboBox(getUserInfo(), "SPECIALTY_PER_USER",
					new String[] { EMPTY_VALUE, getUserInfo().getUserID() },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						mQueueAllSpec = mQueue;
						getSpecListTableLeft().setListTableContent(mQueueAllSpec);
						if (getSpecListTableLeft().getRowCount() > 0) {
							getSpecListTableLeft().setSelectRow(0);
						}
					} else {
						Factory.getInstance().addErrorMessage("Fail to connect server.");
					}
				}
			});
		}

		setVisible(true);
	}

	private boolean isGenValidate(String startdate, String enddate) {
		String errorMsg = null;
		if (!getDFromDate().isValid() || !getDToDate().isValid()) {
			errorMsg = ConstantsMessage.MSG_INVALID_TIME;
		} else if (startdate.length() == 0 || enddate.length() == 0 ||
					DateTimeUtil.compareTo(startdate, enddate) >= 0) {
			errorMsg = ConstantsMessage.MSG_ADDSCH_SAMEDATE;
		} else if (DateTimeUtil.compareTo(getMainFrame().getServerDate(), startdate) > 0) {
			errorMsg = ConstantsMessage.MSG_ADDSCH_PASSDATE;
		}
		if (errorMsg != null) {
			Factory.getInstance().addErrorMessage(errorMsg, "PBA - [Schedule Template Generation]", getDFromDate());
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
		if (!isGenValidate(getDFromDate().getText().trim(), getDToDate().getText().trim())) {
			return;
		}

		Factory.getInstance().showMask(getDialogTopPanel());

		if (getSingleDoctor().isSelected() || getAllDoctor().isSelected()) {
			QueryUtil.executeMasterAction(getUserInfo(),
					ConstantsTx.DOCAPPOINTMENT_TXCODE + "_MUTI",
					QueryUtil.ACTION_APPEND,
					new String[] {
						getAllDoctor().isSelected() ? EMPTY_VALUE : memDocCode,
						getDFromDate().getText().trim(),
						getDToDate().getText().trim(),
						isBlockSchedule?YES_VALUE:NO_VALUE,
						CommonUtil.getComputerName(),
						getUserInfo().getUserID()
					},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						Factory.getInstance().addInformationMessage(ConstantsMessage.MSG_GENERATE_SUCCESS, "PBA - [Schedule Template Generation]",
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


				@Override
				public void onComplete() {
					super.onComplete();
					Factory.getInstance().hideMask(getDialogTopPanel());
				}
			});
		} else if (getBySpecialty().isSelected()) {
			// schedule by specialty
			StringBuffer spec = new StringBuffer();

			for (int i = 0; i < getSpecListTableRight().getRowCount(); i++) {
				if (spec.length() > 0) spec.append(",");
				spec.append(getSpecListTableRight().getValueAt(i, 1).toString());
			}

			if (spec.length() == 0) {
				Factory.getInstance().hideMask(getDialogTopPanel());
				Factory.getInstance().addErrorMessage("Please select specialty!");
				return;
			} else {
				QueryUtil.executeMasterAction(getUserInfo(),
						ConstantsTx.DOCAPPOINTMENT_TXCODE + "_BY_SPEC",
						QueryUtil.ACTION_APPEND,
						new String[] {
							spec.toString(),
							getDFromDate().getText().trim(),
							getDToDate().getText().trim(),
							isBlockSchedule?YES_VALUE:NO_VALUE,
							CommonUtil.getComputerName(),
							getUserInfo().getUserID()
						},
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							Factory.getInstance().addInformationMessage(ConstantsMessage.MSG_GENERATE_SUCCESS, "PBA - [Schedule Template Generation]",
									new Listener<MessageBoxEvent>() {
										@Override
										public void handleEvent(MessageBoxEvent be) {
											// TODO Auto-generated method stub
											dispose();
										}
							});
						} else if ("-100".equals(mQueue.getReturnCode())) {
							MessageBoxBase.confirm(ConstantsMessage.MSG_PBA_SYSTEM, mQueue.getReturnMsg(), new Listener<MessageBoxEvent>() {
								public void handleEvent(MessageBoxEvent be) {
									if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
										doGenerate(true);
									}
								}
							});
						} else {
							Factory.getInstance().addErrorMessage(mQueue);
						}
					}

					@Override
					public void onComplete() {
						super.onComplete();
						Factory.getInstance().hideMask(getDialogTopPanel());
					}
				});
			}
		} else if (getByLocation().isSelected()) {
			if (getDocLocation().isEmpty()) {
				Factory.getInstance().hideMask(getDialogTopPanel());
				Factory.getInstance().addErrorMessage("Please select doctor location!");
				return;
			} else {
				QueryUtil.executeMasterAction(getUserInfo(),
						ConstantsTx.DOCAPPOINTMENT_TXCODE + "_BY_LOC",
						QueryUtil.ACTION_APPEND,
						new String[] {
							getDocLocation().getText(),
							getDFromDate().getText().trim(),
							getDToDate().getText().trim(),
							isBlockSchedule?YES_VALUE:NO_VALUE,
							CommonUtil.getComputerName(),
							getUserInfo().getUserID()
						},
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							Factory.getInstance().addInformationMessage(ConstantsMessage.MSG_GENERATE_SUCCESS, "PBA - [Schedule Template Generation]",
									new Listener<MessageBoxEvent>() {
										@Override
										public void handleEvent(MessageBoxEvent be) {
											// TODO Auto-generated method stub
											dispose();
										}
							});
						} else if ("-100".equals(mQueue.getReturnCode())) {
							MessageBoxBase.confirm(ConstantsMessage.MSG_PBA_SYSTEM, mQueue.getReturnMsg(), new Listener<MessageBoxEvent>() {
								public void handleEvent(MessageBoxEvent be) {
									if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
										doGenerate(true);
									}
								}
							});
						} else {
							Factory.getInstance().addErrorMessage(mQueue);
						}
					}

					@Override
					public void onComplete() {
						super.onComplete();
						Factory.getInstance().hideMask(getDialogTopPanel());
					}
				});
			}
		} else {
			Factory.getInstance().hideMask(getDialogTopPanel());
			Factory.getInstance().addErrorMessage("Not selected any generate method.");
		}
	}

	private void moveAllItemLeft() {
		getSpecListTableLeft().removeAllRow();
		getSpecListTableRight().removeAllRow();

		getSpecListTableLeft().setListTableContent(mQueueAllSpec);
		if (getSpecListTableLeft().getRowCount() > 0) {
			getSpecListTableLeft().setSelectRow(0);
		}
	}

	private void moveItemLeft() {
		TableData td = getSpecListTableRight().getSelectionModel().getSelectedItem();
		if (td != null) {
			removeRow(getSpecListTableRight(), td);
			getSpecListTableLeft().getStore().add(td);
//			if (getSpecListTableRight().getSelectionModel().getSelectedItem() == null && getSpecListTableRight().getRowCount() > 0) {
//				getSpecListTableRight().setSelectRow(0);
//			}
		} else {
			Factory.getInstance().addErrorMessage("Please select specialty to move.");
		}
	}

	protected void moveItemRight() {
		TableData td = getSpecListTableLeft().getSelectionModel().getSelectedItem();
		if (td != null) {
			removeRow(getSpecListTableLeft(), td);
			getSpecListTableRight().getStore().add(td);
//			if (getSpecListTableLeft().getSelectionModel().getSelectedItem() == null && getSpecListTableLeft().getRowCount() > 0) {
//				getSpecListTableLeft().setSelectRow(0);
//			}
		} else {
			Factory.getInstance().addErrorMessage("Please select specialty to move.");
		}
	}

	protected void moveAllItemRight() {
		getSpecListTableLeft().removeAllRow();
		getSpecListTableRight().removeAllRow();

		getSpecListTableRight().setListTableContent(mQueueAllSpec);
		if (getSpecListTableRight().getRowCount() > 0) {
			getSpecListTableRight().setSelectRow(0);
		}
	}

	public String[] getLeftListSelectedRow() {
		return getSpecListTableLeft().getSelectedRowContent();
	}

	public String[] getRightListSelectedRow() {
		return getSpecListTableRight().getSelectedRowContent();
	}

	public void removeRow(TableList table, TableData td) {
		table.getStore().remove(td);
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/* >>> override getListWidth for adjust the width of the table list========<<<< */
	protected int getListWidth() {
		return 790;
	}

	private FieldSetBase getDialogTopPanel() {
		if (dialogTopPanel == null) {
			dialogTopPanel = new FieldSetBase();
			dialogTopPanel.setHeading("Generation Information");
			dialogTopPanel.setBounds(5, 5, 495, 430);
			dialogTopPanel.add(getSingleDoctor(), null);
			dialogTopPanel.add(getAllDoctor(), null);
			dialogTopPanel.add(getByLocation(), null);
			dialogTopPanel.add(getDocLocation(), null);
			dialogTopPanel.add(getBySpecialty(), null);
			dialogTopPanel.add(getAvailable(), null);
			dialogTopPanel.add(getSelected(), null);
			dialogTopPanel.add(getMoveAllRightButtonBase(), null);
			dialogTopPanel.add(getMoveRightButtonBase(), null);
			dialogTopPanel.add(getMoveLeftButtonBase(), null);
			dialogTopPanel.add(getMoveAllLeftButtonBase(), null);
			dialogTopPanel.add(getSpecScrollPaneRight(), null);
			dialogTopPanel.add(getSpecScrollPaneLeft(), null);
			dialogTopPanel.add(getDFromDateDesc(), null);
			dialogTopPanel.add(getDFromDate(), null);
			dialogTopPanel.add(getDToDateDesc(), null);
			dialogTopPanel.add(getDToDate(), null);
			getBtnGoup();
		}
		return dialogTopPanel;
	}

	private RadioButtonBase getSingleDoctor() {
		if (singleDoctor == null) {
			singleDoctor = new RadioButtonBase() {
				public void onClick() {
					getDocLocation().setEnabled(getByLocation().isSelected());
					getMoveAllRightButtonBase().setEnabled(getBySpecialty().isSelected());
					getMoveRightButtonBase().setEnabled(getBySpecialty().isSelected());
					getMoveLeftButtonBase().setEnabled(getBySpecialty().isSelected());
					getMoveAllLeftButtonBase().setEnabled(getBySpecialty().isSelected());
					getSpecScrollPaneLeft().setEnabled(getBySpecialty().isSelected());
					getSpecScrollPaneRight().setEnabled(getBySpecialty().isSelected());
				}
			};
			singleDoctor.setBounds(5, 0, 200, 20);
		}
		return singleDoctor;
	}

	private RadioButtonBase getAllDoctor() {
		if (allDoctor == null) {
			allDoctor = new RadioButtonBase() {
				public void onClick() {
					getDocLocation().setEnabled(getByLocation().isSelected());
					getMoveAllRightButtonBase().setEnabled(getBySpecialty().isSelected());
					getMoveRightButtonBase().setEnabled(getBySpecialty().isSelected());
					getMoveLeftButtonBase().setEnabled(getBySpecialty().isSelected());
					getMoveAllLeftButtonBase().setEnabled(getBySpecialty().isSelected());
					getSpecScrollPaneLeft().setEnabled(getBySpecialty().isSelected());
					getSpecScrollPaneRight().setEnabled(getBySpecialty().isSelected());
				}
			};
			allDoctor.setText("All Doctor");
			allDoctor.setBounds(5, 25, 200, 20);
		}
		return allDoctor;
	}

	private RadioButtonBase getByLocation() {
		if (byLocation == null) {
			byLocation = new RadioButtonBase() {
				public void onClick() {
					getDocLocation().setEnabled(getByLocation().isSelected());
					getMoveAllRightButtonBase().setEnabled(getBySpecialty().isSelected());
					getMoveRightButtonBase().setEnabled(getBySpecialty().isSelected());
					getMoveLeftButtonBase().setEnabled(getBySpecialty().isSelected());
					getMoveAllLeftButtonBase().setEnabled(getBySpecialty().isSelected());
					getSpecScrollPaneLeft().setEnabled(getBySpecialty().isSelected());
					getSpecScrollPaneRight().setEnabled(getBySpecialty().isSelected());
				}
			};
			byLocation.setText("By Location");
			byLocation.setBounds(5, 50, 200, 20);
		}
		return byLocation;
	}

	private ComboDoctorLocation getDocLocation() {
		if (docLocation == null) {
			docLocation = new ComboDoctorLocation();
			docLocation.setBounds(150, 50, 120, 20);
			docLocation.setAllowBlank(false);
			docLocation.setShowClearButton(false);
		}
		return docLocation;
	}

	private RadioButtonBase getBySpecialty() {
		if (bySpecialty == null) {
			bySpecialty = new RadioButtonBase() {
				public void onClick() {
					getDocLocation().setEnabled(getByLocation().isSelected());
					getMoveAllRightButtonBase().setEnabled(getBySpecialty().isSelected());
					getMoveRightButtonBase().setEnabled(getBySpecialty().isSelected());
					getMoveLeftButtonBase().setEnabled(getBySpecialty().isSelected());
					getMoveAllLeftButtonBase().setEnabled(getBySpecialty().isSelected());
					getSpecScrollPaneLeft().setEnabled(getBySpecialty().isSelected());
					getSpecScrollPaneRight().setEnabled(getBySpecialty().isSelected());
				}
			};
			bySpecialty.setText("By Specialty");
			bySpecialty.setBounds(5, 75, 200, 20);
		}
		return bySpecialty;
	}

	private LabelBase getAvailable() {
		if (available == null) {
			available = new LabelBase();
			available.setText("Available Specialty");
			available.setBounds(18, 105, 120, 28);
		}
		return available;
	}

	private LabelBase getSelected() {
		if (selected == null) {
			selected = new LabelBase();
			selected.setText("Selected Specialty");
			selected.setBounds(300, 105, 120, 28);
		}
		return selected;
	}

	private TableList getSpecListTableLeft() {
		if (specListTableLeft == null) {
			specListTableLeft = new TableList(getSpecColumnNamesLeft(), getSpecColumnWidthsLeft()) {
				@Override
				public void doubleClick() {
					moveItemRight();
				}
			};
		}
		return specListTableLeft;
	}

	private TableList getSpecListTableRight() {
		if (specListTableRight == null) {
			specListTableRight = new TableList(getSpecColumnNamesRight(), getSpecColumnWidthsRight()) {
				@Override
				public void doubleClick() {
					moveItemLeft();
				}
			};
		}
		return specListTableRight;
	}

	private String[] getSpecColumnNamesLeft() {
		return new String[] { EMPTY_VALUE, "Code", "Name" };
	}

	private int[] getSpecColumnWidthsLeft() {
		return new int[] { 0, 50, 150 };
	}

	private String[] getSpecColumnNamesRight() {
		return new String[] { EMPTY_VALUE, "Code", "Name" };
	}

	private int[] getSpecColumnWidthsRight() {
		return new int[] { 0, 50, 150 };
	}

	private ButtonBase getMoveAllRightButtonBase() {
		if (moveAllRightButtonBase == null) {
			moveAllRightButtonBase = new ButtonBase() {
				@Override
				public void onClick() {
					moveAllItemRight();
					moveAllRightButtonBase.focus();
				}
			};
			moveAllRightButtonBase.setText("All >>");
			moveAllRightButtonBase.setBounds(228, 165, 52, 25);
		}
		return moveAllRightButtonBase;
	}

	private ButtonBase getMoveRightButtonBase() {
		if (moveRightButtonBase == null) {
			moveRightButtonBase = new ButtonBase() {
				@Override
				public void onClick() {
					moveItemRight();
					moveRightButtonBase.focus();
				}
			};
			moveRightButtonBase.setText(">>");
			moveRightButtonBase.setBounds(228, 195, 52, 25);
		}
		return moveRightButtonBase;
	}

	private ButtonBase getMoveLeftButtonBase() {
		if (moveLeftButtonBase == null) {
			moveLeftButtonBase = new ButtonBase() {
				@Override
				public void onClick() {
					moveItemLeft();
					moveLeftButtonBase.focus();
				}
			};
			moveLeftButtonBase.setText("<<");
			moveLeftButtonBase.setBounds(228, 225, 52, 25);
		}
		return moveLeftButtonBase;
	}

	private ButtonBase getMoveAllLeftButtonBase() {
		if (moveAllLeftButtonBase == null) {
			moveAllLeftButtonBase = new ButtonBase() {
				@Override
				public void onClick() {
					moveAllItemLeft();
					moveAllLeftButtonBase.focus();
				}
			};
			moveAllLeftButtonBase.setText("<< All");
			moveAllLeftButtonBase.setBounds(228, 255, 52, 25);
		}
		return moveAllLeftButtonBase;
	}

	private JScrollPane getSpecScrollPaneLeft() {
		if (specScrollPaneLeft == null) {
			specScrollPaneLeft = new JScrollPane();
			specScrollPaneLeft.setBounds(13, 125, 190, 210);
			specScrollPaneLeft.setViewportView(getSpecListTableLeft());
		}
		return specScrollPaneLeft;
	}

	private JScrollPane getSpecScrollPaneRight() {
		if (specScrollPaneRight == null) {
			specScrollPaneRight = new JScrollPane();
			specScrollPaneRight.setBounds(295, 125, 190, 210);
			specScrollPaneRight.setViewportView(getSpecListTableRight());
		}
		return specScrollPaneRight;
	}

	private RadioGroup getBtnGoup() {
		if (btnGoup == null) {
			btnGoup = new RadioGroup();
			btnGoup.add(getSingleDoctor());
			btnGoup.add(getAllDoctor());
			btnGoup.add(getByLocation());
			btnGoup.add(getBySpecialty());
		}
		return btnGoup;
	}

	private LabelBase getDFromDateDesc() {
		if (dFromDateDesc == null) {
			dFromDateDesc = new LabelBase();
			dFromDateDesc.setText("From Date");
			dFromDateDesc.setBounds(35, 350, 80, 20);
		}
		return dFromDateDesc;
	}

	private TextDate getDFromDate() {
		if (dFromDate == null) {
			dFromDate = new TextDate();
			dFromDate.setBounds(110, 350, 150, 20);
		}
		return dFromDate;
	}

	private LabelBase getDToDateDesc() {
		if (dToDateDesc == null) {
			dToDateDesc = new LabelBase();
			dToDateDesc.setText("To");
			dToDateDesc.setBounds(35, 375, 80, 20);
		}
		return dToDateDesc;
	}

	private TextDate getDToDate() {
		if (dToDate == null) {
			dToDate = new TextDate();
			dToDate.setBounds(110, 375, 150, 20);
		}
		return dToDate;
	}
}