/*
 * Created on July 3, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.hkah.client.layout.dialog;

import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.GridEvent;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.button.Button;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.combobox.ComboRmdrMethod;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.panel.TabbedPaneBase;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextAreaBase;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.util.PanelUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
@SuppressWarnings("serial")
public class DlgSlipRemark extends DialogBase {

	private final static int m_frameWidth = 700;
	private final static int m_frameHeight = 500;

	private BasePanel dialogTopPanel = null;
	private BasePanel remarkPanel = null;
	private BasePanel rmderPanel = null;
	private BasePanel rmderFielPanel = null;
	private BasePanel telemedPanel = null;
	private TabbedPaneBase slpRmkTabbedPanel = null;
	private TextAreaBase remarkTextArea = null;
	private LabelBase Label_RemarkInfo = null;

	private JScrollPane rmderTablePanel = null;
	private TableList rmderTable = null;
	private LabelBase Label_RmderRType = null;
	private ComboBoxBase comboRType = null;


	private LabelBase Label_RmderResbPson = null;
	private TextString Text_RmderResbPson = null;
	private ButtonBase saveResbPson = null;
	private LabelBase Label_RmderHandleBy = null;
	private LabelBase Label_RmderMedium = null;
	private LabelBase Label_RmderDate = null;
	private TextDate Text_RmderDate = null;
	private LabelBase Label_SentDate = null;
	private TextDate Text_SentDate = null;
	private TextString Text_RmderPson = null;
	private ComboRmdrMethod ComboRmdr = null;
	private LabelBase Label_RmderRmk = null;
	private TextAreaBase Text_RmderRmk = null;
	
	private LabelBase Label_ZoomURL = null;
	private TextString Text_ZoomURL = null;
	private LabelBase Label_ZoomID = null;
	private TextString Text_ZoomID = null;
	private LabelBase Label_ZoomPasscode = null;
	private TextString Text_ZoomPasscode = null;
	private LabelBase Label_ZoomURLInfo = null;

	private String memSlipNo = null;
	private boolean isAppend = false;
	private boolean isModify = false;
	private boolean isResPerExist = false;
//	private boolean isRmderLoaded = false;
//	private boolean isRemarkLoaded = false;


	public DlgSlipRemark(MainFrame owner) {
		super(owner, "okyesnoclosecancel", m_frameWidth, m_frameHeight);

		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Slip Remark");

		setContentPane(getDialogTopPanel());

		// change label
		getButtonById(OK).setText("New", 'N');
		getButtonById(YES).setText("Edit", 'E');
		getButtonById(NO).setText("Save", 'S');
		getButtonById(CANCEL).setText("Delete", 'D');
		getButtonById(CLOSE).setText("Cancel", 'C');
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String slipNo) {
		memSlipNo = slipNo;

		getSlpRmkTabbedPanel().setSelectedIndexWithoutStateChange(0);
		getRemarkTextArea().setEditable(false);

		isAppend = false;
		isModify = false;
		isResPerExist = false;

		PanelUtil.resetAllFields(getRmderFieldPanel());
		PanelUtil.setAllFieldsEditable(getRmderFieldPanel(), false);
		enableButton();
		setVisible(false);

		setClosable(true);
		updateContent();
	}

	@Override
	public ButtonBase getDefaultFocusComponent() {
		return getButtonById(YES);
	}

	protected void enableButton() {
		getButtonById(OK).setEnabled(false);
		getButtonById(YES).setEnabled(false);
		getButtonById(NO).setEnabled(false);
		getButtonById(CANCEL).setEnabled(false);
		getButtonById(CLOSE).setEnabled(true);

		if (getSlpRmkTabbedPanel().getSelectedIndex() == 1) {
			getButtonById(OK).setEnabled(true); //New
			getText_RmderResbPson().setEnabled(true);
			getSaveResbPson().setEnabled(true);
		}
	}

	@Override
	public void onButtonPressed(Button button) {
		if (OK.equals(button.getItemId())) { //New
			doOkAction();
		} else if (YES.equals(button.getItemId())) { //Edit
			doYesAction();
		} else if (NO.equals(button.getItemId())) { //Save
			doNoAction();
		} else if (CANCEL.equals(button.getItemId())) { //Delete
			doCancelAction();
		} else if (CLOSE.equals(button.getItemId())) { //Cancel
			doCloseAction();
		} else {
			super.onButtonPressed(button);
		}
	}

	@Override
	protected void doOkAction() {
		getRmderTable().addRow(new String[] {
				EMPTY_VALUE,
				EMPTY_VALUE,
				EMPTY_VALUE,
				EMPTY_VALUE,
				EMPTY_VALUE,
				EMPTY_VALUE,
				EMPTY_VALUE,
				EMPTY_VALUE,
				EMPTY_VALUE,
				EMPTY_VALUE,
				EMPTY_VALUE
			});
			getRmderTable().setSelectRow(getRmderTable().getRowCount() - 1);
			getButtonById(OK).setEnabled(false);
			getButtonById(YES).setEnabled(false);
			getButtonById(NO).setEnabled(true);
			getButtonById(CLOSE).setEnabled(true);

			getText_RmderResbPson().setEnabled(false);
			getSaveResbPson().setEnabled(false);

			isAppend = true;
			isModify = false;

			PanelUtil.setAllFieldsEditable(getRmderFieldPanel(), true);
			getRmderTable().setEnabled(false);
	}

	@Override
	protected void doYesAction() {
		if (getSlpRmkTabbedPanel().getSelectedIndex() == 0) {
			getRemarkTextArea().setEditable(true);
			getButtonById(YES).setEnabled(false);
			getButtonById(NO).setEnabled(!getMainFrame().isDisableFunction("btnSave", "dlgSlipReamrk"));
			setFocusWidget(getRemarkTextArea());
			focus();
		} else if (getSlpRmkTabbedPanel().getSelectedIndex() == 1) {
			isModify = true;
			if (getRmderTable().getSelectedRowCount() > 0) {
				getRmderTable().setEnabled(false);
			}
			PanelUtil.setAllFieldsEditable(getRmderFieldPanel(), true);
			getText_RmderResbPson().setEnabled(false);
			getSaveResbPson().setEnabled(false);

			getButtonById(OK).setEnabled(false);
			getButtonById(YES).setEnabled(false);
			getButtonById(NO).setEnabled(true);
			getButtonById(CLOSE).setEnabled(true);
		} else if (getSlpRmkTabbedPanel().getSelectedIndex() == 2) {
			getText_ZoomURL().setEditable(true);
			getText_ZoomID().setEditable(true);
			getText_ZoomPasscode().setEditable(true);
			getButtonById(YES).setEnabled(false);
			getButtonById(NO).setEnabled(!getMainFrame().isDisableFunction("btnSave", "dlgSlipReamrk"));
			setFocusWidget(getText_ZoomURL());
			focus();
		}
	}

	@Override
	protected void doNoAction() {
		if (getSlpRmkTabbedPanel().getSelectedIndex() == 0) {
			QueryUtil.executeMasterAction(getUserInfo(), "TXNREMARK", QueryUtil.ACTION_MODIFY,
					new String[] {
						memSlipNo,
						getRemarkTextArea().getText(),
						 getUserInfo().getUserID()
					},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
					//	isRemarkLoaded = false;
						updateContent();
						getRemarkTextArea().setEditable(false);
						if (!getMainFrame().isDisableFunction("btnEdit", "dlgSlipReamrk")) {
							getButtonById(YES).setEnabled(true);
							setFocusWidget(getButtonById(YES));
						} else {
							getButtonById(YES).setEnabled(false);
							setFocusWidget(getButtonById(CLOSE));
						}
						getButtonById(NO).setEnabled(false);
					} else {
						Factory.getInstance().addErrorMessage(mQueue);
					}
				}
			});
		} else if (getSlpRmkTabbedPanel().getSelectedIndex() == 1) {
			QueryUtil.executeMasterAction(getUserInfo(), "TXNRMDER2", isAppend?QueryUtil.ACTION_APPEND:QueryUtil.ACTION_MODIFY,
					new String[] {
						isModify?getRmderTable().getSelectedRowContent()[0]:null,
						memSlipNo,
						"",
						getComboRType().getText(),
						getText_RmderPson().getText(),
						getText_RmderDate().getText(),
						getText_SentDate().getText(),
						getComboRmdr().getText(),
						getText_RmderRmk().getText(),
						getUserInfo().getUserID(),
						"PBO"
					},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
//						isRmderLoaded = false;
						PanelUtil.resetAllFields(getRmderFieldPanel());
						updateContent();

						getButtonById(YES).setEnabled(true);
						getButtonById(OK).setEnabled(true);
						getButtonById(CLOSE).setEnabled(false);
						setFocusWidget(getButtonById(YES));
						getButtonById(NO).setEnabled(false);

						PanelUtil.setAllFieldsEditable(getRmderPanel(), false);
						getRmderTable().setEnabled(true);

						isAppend = false;
						isModify = false;
					} else {
						Factory.getInstance().addErrorMessage(mQueue);
					}
				}
			});
		} else if (getSlpRmkTabbedPanel().getSelectedIndex() == 2) {
			QueryUtil.executeMasterAction(getUserInfo(), "SLPTELEMED", QueryUtil.ACTION_MODIFY,
					new String[] {
						memSlipNo,
						getText_ZoomURL().getText(),
						getText_ZoomID().getText(),
						getText_ZoomPasscode().getText(),
						getUserInfo().getUserID()
					},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						updateContent();
						getText_ZoomURL().setEditable(false);
						getText_ZoomID().setEditable(false);
						getText_ZoomPasscode().setEditable(false);
						if (!getMainFrame().isDisableFunction("btnEdit", "dlgSlipReamrk")) {
							getButtonById(YES).setEnabled(true);
							setFocusWidget(getButtonById(YES));
						} else {
							getButtonById(YES).setEnabled(false);
							setFocusWidget(getButtonById(CLOSE));
						}
						getButtonById(NO).setEnabled(false);
					} else {
						Factory.getInstance().addErrorMessage(mQueue);
					}
				}
			});
		}
	}

	@Override
	protected void doCancelAction() { //Delete
		MessageBoxBase.confirm("Slip Remark", "Are you sure you want to delete this record? ", new Listener<MessageBoxEvent>() {
			@Override
			public void handleEvent(MessageBoxEvent be) {
				if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						QueryUtil.executeMasterAction(getUserInfo(), "TXNRMDER2", "DEL",
								new String[] {
									getRmderTable().getSelectedRowContent()[0],
									memSlipNo,
									"","","","","","","",
									getUserInfo().getUserID(),
									null
								},
								new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
//								isRmderLoaded = false;
								PanelUtil.resetAllFields(getRmderFieldPanel());
								updateContent();

								getButtonById(YES).setEnabled(true); //new
								getButtonById(OK).setEnabled(true); //edit
								getButtonById(CLOSE).setEnabled(false); //cancel
								setFocusWidget(getButtonById(YES));
								getButtonById(NO).setEnabled(false);

								PanelUtil.setAllFieldsEditable(getRmderPanel(), false);
								getRmderTable().setEnabled(true);

								isAppend = false;
								isModify = false;
							} else {
								Factory.getInstance().addErrorMessage(mQueue);
							}
						}
					});
				}
			}
		});
	}

	protected void doCloseAction() { //cancel
		if (getSlpRmkTabbedPanel().getSelectedIndex() == 1 && (isAppend || isModify) ) {	
			isAppend = false;
			isModify = false;
			isResPerExist = false;
			getText_RmderResbPson().resetText();
			getComboRType().resetText();
			getText_RmderDate().resetText();
			getText_RmderPson().resetText();
			getComboRmdr().resetText();
			getRemarkTextArea().setEditable(false);
			getButtonById(OK).setEnabled(false);
			getButtonById(YES).setEnabled(false);
			getButtonById(NO).setEnabled(false);
			getButtonById(CANCEL).setEnabled(false);
			PanelUtil.setAllFieldsEditable(getRmderFieldPanel(), false);
			updateContent();
		} else {
			dispose();
		}
	}

	private void updateContent() {
		if (getSlpRmkTabbedPanel().getSelectedIndex() == 0 ) {
			QueryUtil.executeMasterFetch(getUserInfo(),"SLPRMK",
					new String[] { memSlipNo },
					new MessageQueueCallBack() {
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						setVisible(true);

						StringBuffer html = new StringBuffer();
						html.append("<html>Slip Remark<br>=============<br>Remark : ");
						html.append(mQueue.getContentField()[2]);
						html.append("<br><br>Last update user: ");
						html.append(mQueue.getContentField()[0]);
						html.append("<br>Last update date: ");
						html.append(mQueue.getContentField()[1]);
						html.append("<br><br>Additional Remark<br>===================<br>Last update user: ");
						html.append(mQueue.getContentField()[3]);
						html.append("<br>Last update date: ");
						html.append(mQueue.getContentField()[4]);
						getLabel_RemarkInfo().setText(html.toString());
						getRemarkTextArea().setText(mQueue.getContentField()[5].replaceAll("<LINE/>", "\r\n"));

						if (!getMainFrame().isDisableFunction("btnEdit", "dlgSlipReamrk")) {
							getButtonById(YES).setEnabled(true);
							setFocusWidget(getButtonById(YES));
						} else {
							getButtonById(YES).setEnabled(false);
							setFocusWidget(getButtonById(CLOSE));
						}
					}
				}
			});
		} else if (getSlpRmkTabbedPanel().getSelectedIndex() == 1) {
			getRmderTable().setListTableContent("TXNRMDER", new String[] {memSlipNo,"N"});
			getRmderTable().setEnabled(true);
		} else if (getSlpRmkTabbedPanel().getSelectedIndex() == 2) {
			QueryUtil.executeMasterFetch(getUserInfo(),"SLPTELEMED",
					new String[] { memSlipNo },
					new MessageQueueCallBack() {
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						setVisible(true);

						getText_ZoomURL().setText(mQueue.getContentField()[2]);
						getText_ZoomID().setText(mQueue.getContentField()[3]);
						getText_ZoomPasscode().setText(mQueue.getContentField()[4]);
						StringBuffer html = new StringBuffer();
						html.append("<br>Last Update User: ");
						html.append(mQueue.getContentField()[0]);
						html.append("<br>Last Update Date: ");
						html.append(mQueue.getContentField()[1]);
						html.append("<br><br>Send SMS to patient<br>========================");
						html.append("<br>Last SMS with Zoom URL Sent: ");
						html.append(mQueue.getContentField()[5]);
						html.append("<br>SMS Sent result: ");
						html.append(mQueue.getContentField()[8]);
						//String smsOKDate = mQueue.getContentField()[6];
						//html.append((smsOKDate == null ? "" : " (" + smsOKDate + ")"));
						html.append("<br>SMS Sent by: ");
						html.append(mQueue.getContentField()[7]);
						getLabel_ZoomURLInfo().setText(html.toString());

						if (!getMainFrame().isDisableFunction("btnEdit", "dlgSlipReamrk")) {
							getButtonById(YES).setEnabled(true);
							setFocusWidget(getButtonById(YES));
						} else {
							getButtonById(YES).setEnabled(false);
							setFocusWidget(getButtonById(CLOSE));
						}
					}
				}
			});
		}
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getDialogTopPanel() {
		if (dialogTopPanel == null) {
			dialogTopPanel = new BasePanel();
			dialogTopPanel.setEtchedBorder();
			dialogTopPanel.setBounds(0, 0, 670, 480);
			dialogTopPanel.add(getSlpRmkTabbedPanel(), null);
		}
		return dialogTopPanel;
	}

	public TabbedPaneBase getSlpRmkTabbedPanel() {
		if (slpRmkTabbedPanel == null) {
			slpRmkTabbedPanel = new TabbedPaneBase() {
				@Override
				public void onStateChange() {
					enableButton();
					updateContent();
				}
			};
			slpRmkTabbedPanel.setBounds(0, 0, 665, 475);
			slpRmkTabbedPanel.addTab("Remark", getRemarkPanel());
			slpRmkTabbedPanel.addTab("Reminder", getRmderPanel(), "Y".equals(getMainFrame().getSysParameter("TXNRMDER")));
			slpRmkTabbedPanel.addTab("Telemedicine", getTelemedPanel());
		}
		return slpRmkTabbedPanel;
	}

	public LabelBase getLabel_RemarkInfo() {
		if (Label_RemarkInfo == null) {
			Label_RemarkInfo = new LabelBase();
			Label_RemarkInfo.setBounds(5, 5, 630, 150);
		}
		return Label_RemarkInfo;
	}

	public TextAreaBase getRemarkTextArea() {
		if (remarkTextArea == null) {
			remarkTextArea = new TextAreaBase(false);
			remarkTextArea.setEditable(true);
			remarkTextArea.setMaxLength(5000);
			remarkTextArea.setBounds(10, 190, 635, 190);
		}
		return remarkTextArea;
	}

	public BasePanel getRemarkPanel() {
		if (remarkPanel == null) {
			remarkPanel = new BasePanel();
			remarkPanel.setEtchedBorder();
			remarkPanel.setBounds(6, 8, 655, 385);
			remarkPanel.add(getLabel_RemarkInfo(), null);
			remarkPanel.add(getRemarkTextArea(), null);
		}
		return remarkPanel;
	}

	public BasePanel getRmderPanel() {
		if (rmderPanel == null) {
			rmderPanel = new BasePanel();
			rmderPanel.setEtchedBorder();
			rmderPanel.setBounds(6, 8, 655, 385);
			rmderPanel.add(getRmderFieldPanel(), null);
			rmderPanel.add(getRmderTablePanel(),null);
		}
		return rmderPanel;
	}

	public BasePanel getRmderFieldPanel() {
		if (rmderFielPanel == null) {
			rmderFielPanel = new BasePanel();
			rmderFielPanel.setEtchedBorder();
			rmderFielPanel.setBounds(6, 8, 580, 150);
			rmderFielPanel.add(getLabel_RmderResbPson(), null);
			rmderFielPanel.add(getText_RmderResbPson(), null);
			rmderFielPanel.add(getSaveResbPson(), null);
			rmderFielPanel.add(getLabel_RmderRType(), null);
			rmderFielPanel.add(getComboRType(), null);
			rmderFielPanel.add(getLabel_RmderDate(), null);
			rmderFielPanel.add(getText_RmderDate(), null);
			rmderFielPanel.add(getLabel_RmderHandleBy(), null);
			rmderFielPanel.add(getText_RmderPson(), null);
			rmderFielPanel.add(getLabel_RmderMedium(), null);
			rmderFielPanel.add(getComboRmdr(), null);
			rmderFielPanel.add(getLabel_SentDate(), null);
			rmderFielPanel.add(getText_SentDate(), null);
			rmderFielPanel.add(getLabel_RmderRmk(), null);
			rmderFielPanel.add(getText_RmderRmk(), null);
		}
		return rmderFielPanel;
	}

	private JScrollPane getRmderTablePanel() {
		if (rmderTablePanel == null) {
			rmderTablePanel = new JScrollPane();
			rmderTablePanel.setViewportView(getRmderTable());
			rmderTablePanel.setBounds(6, 170, 630, 200);
		}
		return rmderTablePanel;
	}

	private TableList getRmderTable() {
		if (rmderTable == null) {
			rmderTable = new TableList(getRmderTableColumnNames(), getRmderTableColumnWidths()) {
				@Override
				public void setListTableContentPost() {
					if (rmderTable.getRowCount() > 0) {
						int tmpResbP = rmderTable.findRow(1,"0");
						if (tmpResbP > -1){
							getText_RmderResbPson().setText(rmderTable.getRowContent(tmpResbP)[4]);
							isResPerExist = true;
							rmderTable.removeRow(tmpResbP);
						}
					} else {
						getButtonById(CANCEL).setEnabled(false);
					}
				}

				@Override
				public void onSelectionChanged() {
					if (!isAppend) {
						getView().focusRow(getEditRow());
						getSelectionModel().select(getEditRow(), false);
						if (getRmderTable().getSelectedRowContent() != null) {
								getButtonById(YES).setEnabled(true);

								getComboRType().resetText();
								getText_RmderDate().resetText();
								getText_RmderPson().resetText();
								getComboRmdr().resetText();
									getButtonById(CANCEL)
									.setEnabled(getUserInfo().getUserID().equals(rmderTable.getSelectedRowContent()[10]));
								getComboRType().setText(getRmderTable().getSelectedRowContent()[1]);
								getText_RmderDate().setText(getRmderTable().getSelectedRowContent()[3]);
								getText_SentDate().setText(getRmderTable().getSelectedRowContent()[7]);
								getText_RmderPson().setText(getRmderTable().getSelectedRowContent()[4]);
								getText_RmderRmk().setText(getRmderTable().getSelectedRowContent()[8]);
								getComboRmdr().setText(getRmderTable().getSelectedRowContent()[6]);
						}
					}
				};
			};
			rmderTable.setTableLength(200);
			rmderTable.addListener(Events.RowClick, new Listener<GridEvent>() {
				@Override
				public void handleEvent(GridEvent be) {

				}
			});
		}
		return rmderTable;
	}

	protected String[] getRmderTableColumnNames() {
		return new String[] {
				"HLDID",
				"RMDERTYPE",
				"Reminder Type",
				"Create Date",
				"Handle By",
				"MediumID",
				"Medium",
				"Sent Date",
				"Remark",
				"DEPT",
				"CREATEUSER"
				};
	}

	protected int[] getRmderTableColumnWidths() {
		return new int[] {
				0,
				0,
				120,
				80,
				100,
				0,
				60,
				80,
				130,
				50,
				0
			};
	}

	private LabelBase getLabel_RmderResbPson() {
		if (Label_RmderResbPson == null) {
			Label_RmderResbPson = new LabelBase();
			Label_RmderResbPson.setText("Responsible Personnel: ");
			Label_RmderResbPson.setBounds(5, 5, 130, 20);
		}
		return Label_RmderResbPson;
	}

	private TextString getText_RmderResbPson() {
		if (Text_RmderResbPson == null) {
			Text_RmderResbPson = new TextString(true);
			Text_RmderResbPson.setBounds(150, 5,140, 20);
		}
		return Text_RmderResbPson;
	}

	private ButtonBase getSaveResbPson() {
		if (saveResbPson == null) {
			saveResbPson = new ButtonBase() {
				@Override
				public void onClick() {
					QueryUtil.executeMasterAction(getUserInfo(), "TXNRMDER2",
							!isResPerExist?QueryUtil.ACTION_APPEND:QueryUtil.ACTION_MODIFY,
							new String[] {
								null,
								memSlipNo,
								getText_RmderResbPson().getText(),
								"","","","","","",
								getUserInfo().getUserID(),
								"PBO"
							},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								PanelUtil.resetAllFields(getRmderFieldPanel());
								updateContent();
								getButtonById(YES).setEnabled(true);
								getButtonById(OK).setEnabled(true);
								getButtonById(CLOSE).setEnabled(false);
								setFocusWidget(getButtonById(YES));
								getButtonById(NO).setEnabled(false);
								PanelUtil.setAllFieldsEditable(getRmderPanel(), false);
								getRmderTable().setEnabled(true);
								getText_RmderResbPson().setEnabled(true);
								getSaveResbPson().setEnabled(true);
								isAppend = false;
								isModify = false;
							} else {
								Factory.getInstance().addErrorMessage(mQueue);
							}
						}
					});
				}
			};
			saveResbPson.setText("Save Respnsible Personnel");
			saveResbPson.setBounds(300, 5, 150, 25);
		}
		return saveResbPson;
	}

	private LabelBase getLabel_RmderRType() {
		if (Label_RmderRType == null) {
			Label_RmderRType = new LabelBase();
			Label_RmderRType.setText("Type: ");
			Label_RmderRType.setBounds(5, 30, 30, 20);
		}
		return Label_RmderRType;
	}

	private ComboBoxBase getComboRType() {
		if (comboRType == null) {
			comboRType = new ComboBoxBase(){
				@Override
				protected void setTextPanel(ModelData modelData){
					super.setTextPanel(modelData);
					if (isModify || isAppend) {
						getRmderTable().setValueAt(getDisplayText(), getRmderTable().getSelectedRow(), 2);
					}
				}
			};
			comboRType.addItem("1", "1st Reminder");
			comboRType.addItem("2", "2nd Reminder");
			comboRType.addItem("3", "3nd Reminder");
			comboRType.setMinListWidth(120);

			comboRType.setBounds(40,30,80, 20);
		}
		return comboRType;
	}

	private LabelBase getLabel_RmderDate() {
		if (Label_RmderDate == null) {
			Label_RmderDate = new LabelBase();
			Label_RmderDate.setText("Create Date: ");
			Label_RmderDate.setBounds(140, 30, 100, 20);
		}
		return Label_RmderDate;
	}

	private TextDate getText_RmderDate() {
		if (Text_RmderDate == null) {
			Text_RmderDate = new TextDate(){
				@Override
				public void onBlur() {
					if (isModify || isAppend) {
						getRmderTable().setValueAt(getText(), getRmderTable().getSelectedRow(), 3);
					}
				}
			};
			Text_RmderDate.setBounds(245,30, 100, 20);
		}
		return Text_RmderDate;
	}

	private LabelBase getLabel_RmderHandleBy() {
		if (Label_RmderHandleBy == null) {
			Label_RmderHandleBy = new LabelBase();
			Label_RmderHandleBy.setText("Handle by: ");
			Label_RmderHandleBy.setBounds(350,30, 70, 20);
		}
		return Label_RmderHandleBy;
	}

	private TextString getText_RmderPson() {
		if (Text_RmderPson == null) {
			Text_RmderPson = new TextString(true){
				@Override
				public void onReleased() {
					if (isModify || isAppend) {
						getRmderTable().setValueAt(getText(), getRmderTable().getSelectedRow(), 5);
					}
				}
			};
			Text_RmderPson.setBounds(425, 30,120, 20);
		}
		return Text_RmderPson;
	}

	private LabelBase getLabel_RmderMedium() {
		if (Label_RmderMedium == null) {
			Label_RmderMedium = new LabelBase();
			Label_RmderMedium.setText("Medium: ");
			Label_RmderMedium.setBounds(5, 60, 60, 20);
		}
		return Label_RmderMedium;
	}

	private ComboRmdrMethod getComboRmdr() {
		if (ComboRmdr == null) {
			ComboRmdr = new ComboRmdrMethod(){
				@Override
				protected void setTextPanel(ModelData modelData){
					super.setTextPanel(modelData);
					if (isModify || isAppend) {
						getRmderTable().setValueAt(getDisplayText(), getRmderTable().getSelectedRow(), 6);
					}
				}
			};
			ComboRmdr.setBounds(65, 60, 100, 20);
		}
		return ComboRmdr;
	}

	private LabelBase getLabel_SentDate() {
		if (Label_SentDate == null) {
			Label_SentDate = new LabelBase();
			Label_SentDate.setText("Sent Date: ");
			Label_SentDate.setBounds(170, 60, 80, 20);
		}
		return Label_SentDate;
	}

	private TextDate getText_SentDate() {
		if (Text_SentDate == null) {
			Text_SentDate = new TextDate(){
				@Override
				public void onBlur() {
					if (isModify || isAppend) {
						getRmderTable().setValueAt(getText(), getRmderTable().getSelectedRow(), 7);
					}
				}
			};
			Text_SentDate.setBounds(250,60, 100, 20);
		}
		return Text_SentDate;
	}

	public LabelBase getLabel_RmderRmk() {
		if (Label_RmderRmk == null) {
			Label_RmderRmk = new LabelBase();
			Label_RmderRmk.setText("Remark: ");
			Label_RmderRmk.setBounds(5, 90, 50, 20);
		}
		return Label_RmderRmk;
	}

	public TextAreaBase getText_RmderRmk() {
		if (Text_RmderRmk == null) {
			Text_RmderRmk = new TextAreaBase(false);
			Text_RmderRmk.setEditable(true);
			Text_RmderRmk.setMaxLength(200);
			Text_RmderRmk.setBounds(65, 90, 500, 50);
		}
		return Text_RmderRmk;
	}
	
	public BasePanel getTelemedPanel() {
		if (telemedPanel == null) {
			telemedPanel = new BasePanel();
			telemedPanel.setEtchedBorder();
			telemedPanel.setBounds(6, 8, 655, 385);
			telemedPanel.add(getLabel_ZoomURL(), null);
			telemedPanel.add(getText_ZoomURL(), null);
			telemedPanel.add(getLabel_ZoomID(), null);
			telemedPanel.add(getText_ZoomID(), null);
			telemedPanel.add(getLabel_ZoomPasscode(), null);
			telemedPanel.add(getText_ZoomPasscode(), null);
			telemedPanel.add(getLabel_ZoomURLInfo(), null);
		}
		return telemedPanel;
	}
	
	private LabelBase getLabel_ZoomURL() {
		if (Label_ZoomURL == null) {
			Label_ZoomURL = new LabelBase();
			Label_ZoomURL.setText("Zoom URL");
			Label_ZoomURL.setBounds(5, 5, 80, 20);
		}
		return Label_ZoomURL;
	}

	private TextString getText_ZoomURL() {
		if (Text_ZoomURL == null) {
			Text_ZoomURL = new TextString(150, false);
			Text_ZoomURL.setEditable(false);
			Text_ZoomURL.setBounds(90, 5, 500, 20);
		}
		return Text_ZoomURL;
	}
	
	private LabelBase getLabel_ZoomID() {
		if (Label_ZoomID == null) {
			Label_ZoomID = new LabelBase();
			Label_ZoomID.setText("Zoom ID");
			Label_ZoomID.setBounds(5, 30, 80, 20);
		}
		return Label_ZoomID;
	}

	private TextString getText_ZoomID() {
		if (Text_ZoomID == null) {
			Text_ZoomID = new TextString(15, false);
			Text_ZoomID.setEditable(false);
			Text_ZoomID.setBounds(90, 30, 100, 20);
		}
		return Text_ZoomID;
	}
	
	private LabelBase getLabel_ZoomPasscode() {
		if (Label_ZoomPasscode == null) {
			Label_ZoomPasscode = new LabelBase();
			Label_ZoomPasscode.setText("Passcode");
			Label_ZoomPasscode.setBounds(5, 55, 80, 20);
		}
		return Label_ZoomPasscode;
	}

	private TextString getText_ZoomPasscode() {
		if (Text_ZoomPasscode == null) {
			Text_ZoomPasscode = new TextString(20, false);
			Text_ZoomPasscode.setEditable(false);
			Text_ZoomPasscode.setBounds(90, 55, 100, 20);
		}
		return Text_ZoomPasscode;
	}
	
	public LabelBase getLabel_ZoomURLInfo() {
		if (Label_ZoomURLInfo == null) {
			Label_ZoomURLInfo = new LabelBase();
			Label_ZoomURLInfo.setBounds(5, 85, 630, 150);
		}
		return Label_ZoomURLInfo;
	}
}