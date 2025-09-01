package com.hkah.client.tx.medrecord;

import com.extjs.gxt.ui.client.Style.Scroll;
import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.form.Field;
import com.hkah.client.common.BarcodeReader;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboDoctor;
import com.hkah.client.layout.combobox.ComboMedRecLoc;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.label.LabelSmallBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.table.TableData;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextDateTime;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMedicalRecord;
import com.hkah.shared.constants.ConstantsTableColumn;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class MedicalRecordDispatch extends MasterPanel implements ConstantsVariable, ConstantsTableColumn {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.MEDTRANSFER_TITLE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */

	@Override
	public String getTxCode() {
		return ConstantsTx.MEDDISTRANSFER_TXCODE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
			"Record ID", "Current Location", "Doctor", "Remarks", "Date/Time", "", ""
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
			110, 160, 160, 165, 120, 0, 0
		};
	}

	private BasePanel leftPanel = null;
	private BasePanel dispatchPanel = null;
	private LabelBase chartLocdesc = null;
	private ComboMedRecLoc chartLoc = null;
	private LabelBase docDesc = null;
	private LabelSmallBase rmkDesc = null;
	private TextString rmk = null;
	private LabelBase rediddesc = null;
	private TextString redID = null;
	private LabelBase patNameDesc = null;
	private TextReadOnly patName = null;
	private LabelBase datedesc = null;
	private TextDateTime date = null;
	private LabelBase sendSMSdesc = null;
	private CheckBoxBase sendSMS = null;
	private ComboDoctor doctor = null;
	private LabelBase cntDesc1 = null;
	private TextReadOnly count = null;
	private LabelBase doctorName = null;
	private BasePanel listScrollPane = null;
//	private EditorTableList editDispatchList = null;
	private TableList dispatchList = null;
	private BarcodeReader br = null;

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected boolean init() {
		setLeftAlignPanel();
		br = new BarcodeReader(this) {
			@Override
			protected void focus() {
//				getEditDispatchList().stopEditing(true);
//				getEditDispatchList().focus();
				getDispatchList().focus();
			}

			@Override
			protected void afterScan(String value) {
				if (checkPrefix(ConstantsMedicalRecord.BARCODE_PREFIX_LOCATION, value)) {
					getChartLoc().setSelectedIndex(
							getChartLoc().findModelByKey(
									getValue(ConstantsMedicalRecord.BARCODE_PREFIX_LOCATION, value)));
				} else if (checkPrefix(ConstantsMedicalRecord.BARCODE_PREFIX_DOCTOR, value)) {
					getDoctor().setSelectedIndex(
							getDoctor().findModelByKey(
									getValue(ConstantsMedicalRecord.BARCODE_PREFIX_DOCTOR, value)));
				} else if (checkPrefix(ConstantsMedicalRecord.BARCODE_PREFIX_RECORDID, value)) {
					getRedID().setText(getValue(ConstantsMedicalRecord.BARCODE_PREFIX_RECORDID, value));
					appendAction();
				} else if (checkPrefix(ConstantsMedicalRecord.BARCODE_PREFIX_RECORDID_2, value)) {
					getRedID().setText(getValue(ConstantsMedicalRecord.BARCODE_PREFIX_RECORDID_2, value));
					appendAction();
				} else if (checkPrefix(ConstantsMedicalRecord.BARCODE_PREFIX_NEW, value)) {
					if (getAppendButton().isEnabled()) {
						appendAction();
					}
				} else if (checkPrefix(ConstantsMedicalRecord.BARCODE_PREFIX_SAVE, value)) {
					if (getSaveButton().isEnabled()) {
						saveAction();
					}
				} else if (checkPrefix(ConstantsMedicalRecord.BARCODE_PREFIX_DELETE, value)) {
					if (getDeleteButton().isEnabled()) {
						deleteAction();
					}
				}
				defaultFocus();
			}
		};
		return true;
	}

	@Override
	protected void initAfterReady() {
//		getListTable().setColumnClass(2, new ComboMedRecLoc(), false);
//		getListTable().setColumnClass(3, new ComboDoctor(), false);
		br.reset();

		boolean isHKAH = HKAH_VALUE.equals(getUserInfo().getSiteCode());
		getSendSMSDesc().setVisible(isHKAH);
		getSendSMS().setVisible(isHKAH);
		getSendSMS().setSelected(false);

		enableButton();
	}

	@Override
	protected void confirmCancelButtonClicked() {}

	@Override
	protected void appendDisabledFields() {}

	@Override
	protected void modifyDisabledFields() {}

	@Override
	protected void deleteDisabledFields() {}

	@Override
	protected String[] getBrowseInputParameters() {
		return null;
	}

	@Override
	protected String[] getFetchInputParameters() {
		return null;
	}

	@Override
	protected void getFetchOutputValues(String[] outParam) {}

	@Override
	protected String[] getActionInputParamaters() {
		return null;
	}

	@Override
	public Component getDefaultFocusComponent() {
		return getRedID();
	}

	@Override
	protected void enableButton(String mode) {
		disableButton();
		getAppendButton().setEnabled(true);
/*
		getDeleteButton().setEnabled(getEditDispatchList().getRowCount() > 0);
		getSaveButton().setEnabled(getEditDispatchList().getRowCount() > 0);
		getCount().setText(String.valueOf(getEditDispatchList().getRowCount()));
*/
		getDeleteButton().setEnabled(getDispatchList().getRowCount() > 0);
		getSaveButton().setEnabled(getDispatchList().getRowCount() > 0);
		getCount().setText(String.valueOf(getDispatchList().getRowCount()));
	}

	@Override
	public void appendAction() {
		if (validation()) {
			final String[] temp = getRedID().getText().split("/");

			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] {
						"MedRecHdr h, MedRecDtl d",
						"h.MrhID, h.MrhSts, d.MrlID_S",
						"h.MrdID = d.MrdID and PatNo = '"+temp[0]+"' "+
						"and MrhVolLab "+
						((temp.length > 1 && temp[1] != null &&
							temp[1].length() > 0)?" = '"+temp[1]+"' ":"is null ")
					},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						if (mQueue.getContentField()[0].length() == 0) {
							Factory.getInstance().addErrorMessage("Patient no doesn't exist or medical record doesn't exist.");
							return;
						}

						if (!NO_VALUE.equalsIgnoreCase(mQueue.getContentField()[1])) {
							Factory.getInstance().addErrorMessage("Medical record is deleted or missing.");
							return;
						}

//						String[] columnNames = getEditDispatchList().getColumnIDs();
						String[] columnNames = getDispatchList().getColumnIDs();

						Object[] fields = new Object[getDispatchList().getColumnCount()];
//						Object[] fields = new Object[getEditDispatchList().getColumnCount()];

						fields[0] = getRedID().getText().trim();
						fields[1] = getChartLoc().getDisplayText();
						fields[2] = getDoctor().isEmpty()?EMPTY_VALUE: getDoctor().getDisplayText();
						fields[3] = getRemark().getText();
//						fields[4] = getDate().isEmpty()?
//										DateTimeUtil.parseDateTime(DateTimeUtil.getCurrentDateTime()):
//											DateTimeUtil.parseDateTime(getDate().getText());
						fields[4] = getDate().isEmpty()?
						DateTimeUtil.getCurrentDateTime():getDate().getText();
						fields[5] = getChartLoc().getText();
						fields[6] = getDoctor().isEmpty()?EMPTY_VALUE: getDoctor().getText();

						TableData newModel = new TableData(columnNames, fields);
//						getEditDispatchList().getStore().add(newModel);
						getDispatchList().getStore().add(newModel);

						setPatientName(temp[0]);
						getRedID().resetText();
//						getEditDispatchList().setSelectRow(getEditDispatchList().getRowCount() - 1);
						getDispatchList().setSelectRow(getDispatchList().getRowCount() - 1);
					} else {
						Factory.getInstance().addErrorMessage("Patient no doesn't exist or medical record doesn't exist.");
					}
					enableButton();
				}
			});
		}
	}
/*
	@Override
	public void deleteAction() {
		if (getEditDispatchList().getSelectedRow() > -1) {
			getEditDispatchList().getStore().remove(getEditDispatchList().getSelectedRow());
		}
		enableButton();
	}
*/
	@Override
	public void deleteAction() {
		if (getDispatchList().getSelectedRow() > -1) {
			getDispatchList().getStore().remove(getDispatchList().getSelectedRow());
		}
		enableButton();
	}

/*
	@Override
	public void saveAction() {
		getEditDispatchList().saveTable(getTxCode(),
				new String[] {
					getUserInfo().getUserID()
				},
				true,
				false,
				false,
				true,
				true,
				getTitle());
		getRemark().resetText();
	}
*/
	@Override
	public void saveAction() {
		if (getSendSMS().isVisible() && getSendSMS().isSelected()) {
			MessageBoxBase.confirm(MSG_PBA_SYSTEM, "Are you sure to send SMS?",
					new Listener<MessageBoxEvent>() {
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						saveActionHelper();
					}
				}
			});
		} else {
			saveActionHelper();
		}
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	private void setPatientName(String patNo) {
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.PATIENT_TXCODE,
				new String[] {
					patNo
				},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					if (mQueue.getContentLineCount() > 0) {
						getPatName().setText(mQueue.getContentField()[PATIENT_FAMILY_NAME] + SPACE_VALUE + mQueue.getContentField()[PATIENT_GIVEN_NAME]);
					}
				} else {
					getPatName().resetText();
				}
			}
		});
	}

	private boolean validation() {
		if (getChartLoc().isEmpty()) {
			Factory.getInstance().addErrorMessage("Chart Location cannot be blank.", getChartLoc());
			return false;
		}

		if (getRedID().isEmpty()) {
			Factory.getInstance().addErrorMessage("Record ID cannot be blank.", getRedID());
			return false;
		}

		if (!getDate().isEmpty() && !getDate().validate()) {
			Factory.getInstance().addErrorMessage("Invalid Date Value.", getDate());
			return false;
		}

		return true;
	}

	private void saveActionHelper() {
		getDispatchList().saveTable(getTxCode(),
				new String[] {
					getUserInfo().getUserID(),
					getSendSMS().isSelected()?YES_VALUE:NO_VALUE
				},
				true,
				false,
				false,
				true,
				true,
				getTitle());
				getRemark().resetText();
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	@Override
	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.setSize(779, 728);
			leftPanel.add(getDispatchPanel(), null);
		}
		return leftPanel;
	}

	@Override
	protected BasePanel getRightPanel() {
		return null;
	}

	private BasePanel getDispatchPanel() {
		if (dispatchPanel == null) {
			dispatchPanel = new BasePanel();
			dispatchPanel.setSize(750, 500);
			dispatchPanel.add(getChartLocDesc(), null);
			dispatchPanel.add(getChartLoc(), null);
			dispatchPanel.add(getDocDesc(), null);
			dispatchPanel.add(getDoctor(), null);
			dispatchPanel.add(getDoctorNameDesc(), null);
			dispatchPanel.add(getRemarkDesc(), null);
			dispatchPanel.add(getRemark(), null);
			dispatchPanel.add(getSendSMSDesc(), null);
			dispatchPanel.add(getSendSMS(), null);
			dispatchPanel.add(getRecAndVolIDDesc(), null);
			dispatchPanel.add(getRedID(), null);
			dispatchPanel.add(getPatNameDesc(), null);
			dispatchPanel.add(getPatName(), null);
			dispatchPanel.add(getDateDesc(), null);
			dispatchPanel.add(getDate(), null);
			dispatchPanel.add(getListScrollPanel(), null);
			dispatchPanel.add(getCountDesc(), null);
			dispatchPanel.add(getCount(), null);
		}
		return dispatchPanel;
	}

	private LabelBase getChartLocDesc() {
		if (chartLocdesc == null) {
			chartLocdesc = new LabelBase();
			chartLocdesc.setBounds(5, 5, 85, 20);
			chartLocdesc.setText("Chart location");
		}
		return chartLocdesc;
	}

	private ComboMedRecLoc getChartLoc() {
		if (chartLoc == null) {
			chartLoc = new ComboMedRecLoc(true, "{v} {k}");
			chartLoc.setBounds(85, 5, 160, 20);
		}
		return chartLoc;
	}

	private LabelBase getDocDesc() {
		if (docDesc == null) {
			docDesc = new LabelBase();
			docDesc.setBounds(280, 5, 85, 20);
			docDesc.setText("Dr.");
		}
		return docDesc;
	}

	private ComboDoctor getDoctor() {
		if (doctor == null) {
			doctor = new ComboDoctor(true, "OrderByName", false, "{v} {k}") {
				@Override
				protected void setTextPanel(ModelData modelData) {
					super.setTextPanel(modelData);
					if (modelData != null) {
						getDoctorNameDesc().setText(modelData.get(ONE_VALUE).toString());
					}
					else {
						getDoctorNameDesc().resetText();
					}
				}

				@Override
				protected void clearPostAction() {
					getDoctorNameDesc().resetText();
				}
			};
			doctor.setBounds(350, 5, 160, 20);
		}
		return doctor;
	}

	private LabelBase getDoctorNameDesc() {
		if (doctorName == null) {
			doctorName = new LabelBase();
			doctorName.setBounds(535, 5, 260, 20);
		}
		return doctorName;
	}

	private LabelSmallBase getRemarkDesc() {
		if (rmkDesc == null) {
			rmkDesc = new LabelSmallBase();
			rmkDesc.setBounds(280, 20, 70, 20);
			rmkDesc.setText("Requestor/<br/>&nbsp;Remark");
		}
		return rmkDesc;
	}

	private TextString getRemark() {
		if (rmk == null) {
			rmk = new TextString(false);
			rmk.setBounds(350, 30, 160, 20);
		}
		return rmk;
	}

	private LabelBase getSendSMSDesc() {
		if (sendSMSdesc == null) {
			sendSMSdesc = new LabelBase();
			sendSMSdesc.setBounds(535, 30, 70, 20);
			sendSMSdesc.setText("SMS");
		}
		return sendSMSdesc;
	}

	private CheckBoxBase getSendSMS() {
		if (sendSMS == null) {
			sendSMS = new CheckBoxBase();
			sendSMS.setBounds(580, 30, 30, 20);
		}
		return sendSMS;
	}

	private LabelBase getRecAndVolIDDesc() {
		if (rediddesc == null) {
			rediddesc = new LabelBase();
			rediddesc.setBounds(5, 50, 85, 20);
			rediddesc.setText("Record ID &amp;<br/>Volume ID");
		}
		return rediddesc;
	}

	private TextString getRedID() {
		if (redID == null) {
			redID = new TextString();
			redID.setBounds(85, 55, 160, 20);
		}
		return redID;
	}

	private LabelBase getPatNameDesc() {
		if (patNameDesc == null) {
			patNameDesc = new LabelBase();
			patNameDesc.setBounds(280, 55, 35, 20);
			patNameDesc.setText("Name");
		}
		return patNameDesc;
	}

	private TextReadOnly getPatName() {
		if (patName == null) {
			patName = new TextReadOnly();
			patName.setBounds(350, 55, 160, 20);
		}
		return patName;
	}

	private LabelBase getDateDesc() {
		if (datedesc == null) {
			datedesc = new LabelBase();
			datedesc.setBounds(535, 55, 70, 20);
			datedesc.setText("Date");
		}
		return datedesc;
	}

	private TextDateTime getDate() {
		if (date == null) {
			date = new TextDateTime(true, true);
			date.setBounds(580, 55, 160, 20);
		}
		return date;
	}

	private LabelBase getCountDesc() {
		if (cntDesc1 == null) {
			cntDesc1 = new LabelBase();
			cntDesc1.setBounds(610, 450, 70, 20);
			cntDesc1.setText("Total Count:");
		}
		return cntDesc1;
	}

	private TextReadOnly getCount() {
		if (count == null) {
			count = new TextReadOnly();
			count.setBounds(685, 450, 60, 20);
		}
		return count;
	}

	private BasePanel getListScrollPanel() {
		if (listScrollPane == null) {
			listScrollPane = new BasePanel();
			listScrollPane.setBorders(true);
			listScrollPane.setScrollMode(Scroll.AUTO);
//			listScrollPane.add(getEditDispatchList());
			listScrollPane.add(getDispatchList());
			listScrollPane.setBounds(5, 90, 745, 352);
		}
		return listScrollPane;
	}

/*
	private EditorTableList getEditDispatchList() {
		if (editDispatchList == null) {
			editDispatchList = new EditorTableList(getColumnNames(),
						getColumnWidths(),
						getColumnEditor()) {
*/
	private TableList getDispatchList() {
		if (dispatchList == null) {
			dispatchList = new TableList(getColumnNames(),
					getColumnWidths()) {
				@Override
				public void postSaveTable(boolean success, Integer rtnCode, String rtnMsg) {
					if (success) {
						if (rtnMsg.length() != 0 && rtnMsg.indexOf("_") > -1) {
							String[] tmp = rtnMsg.split("_");
							TableData[] tempRow = new TableData[tmp.length];

							for (int i = 0; i < tmp.length; i++) {
								if (tmp.length > 0 && tmp[i].length() > 0) {
									tempRow[i] = (TableData) getStore().getAt(Integer.parseInt(tmp[i]));
								}
							}
							getStore().removeAll();
							for (int i = 0; i < tempRow.length; i++) {
								getStore().add(tempRow[i]);
							}
							Factory.getInstance().addErrorMessage("The remaining records cannot be saved. Please check and try again.");
						} else {
							getStore().removeAll();
						}

						getSendSMS().setSelected(false);
					}
					enableButton();
				}
			};
			dispatchList.setBounds(5, 5, 733, 340);
		}
		return dispatchList;
	}
/*
			editDispatchList.setBounds(5, 5, 733, 340);
		}
		return editDispatchList;
	}
*/

	private Field<? extends Object>[] getColumnEditor() {
		Field<? extends Object>[] editors = new Field<?>[getColumnNames().length];

		editors[0] = new TextString();
		editors[1] = new ComboMedRecLoc(true, "{v} {k}");
		editors[2] = new ComboDoctor(true, null, false, "{v} {k}");
		editors[3] = new TextString(false);
		editors[4] = new TextString(false);
		editors[5] = new TextString();
		editors[6] = new TextString();
/*
		editors[0] = new TextString();
		editors[1] = new ComboMedRecLoc(true, "{v} {k}");
		editors[2] = new ComboDoctor(true, null, false, "{v} {k}");
		editors[3] = new TextString(false);
		editors[4] = new TextString(false);

		editors[4] = new TextDateTime(true, true) {

			@Override
			public void onBlur() {
				if (!validate()) {
					Factory.getInstance().addErrorMessage("Invalid Date.", this);
				}
			}
		};
*/

		return editors;
	}
}