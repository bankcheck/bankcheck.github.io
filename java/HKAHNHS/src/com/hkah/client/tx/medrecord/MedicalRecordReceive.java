package com.hkah.client.tx.medrecord;

import com.extjs.gxt.ui.client.Style.Scroll;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.form.Field;
import com.hkah.client.common.BarcodeReader;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboMedRecLoc;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.table.EditorTableList;
import com.hkah.client.layout.table.TableData;
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

public class MedicalRecordReceive extends MasterPanel implements ConstantsVariable, ConstantsTableColumn {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.MEDTRANSFER_TITLE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */

	@Override
	public String getTxCode() {
		return ConstantsTx.MEDRECTRANSFER_TXCODE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
			"Record ID", "Current Location", "Date/Time"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
			200, 320, 200
		};
	}

	private BasePanel leftPanel = null;
	private BasePanel dispatchPanel = null;
	private LabelBase chartLocdesc = null;
	private ComboMedRecLoc chartLoc = null;
	private LabelBase sendSMSdesc = null;
	private CheckBoxBase sendSMS = null;
	private LabelBase rediddesc = null;
	private TextString redID = null;
	private LabelBase patNameDesc = null;
	private TextReadOnly patName = null;
	private LabelBase datedesc = null;
	private TextDateTime date = null;
	private LabelBase cntDesc1 = null;
	private TextReadOnly count = null;
	private BasePanel listScrollPane = null;
	private EditorTableList editReceiveList = null;
	private BarcodeReader br = null;

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

	@Override
	protected boolean init() {
		setLeftAlignPanel();
		br = new BarcodeReader(this) {
			@Override
			protected void focus() {
				//getEditReceiveList().stopEditing();
				getEditReceiveList().focus();
			}

			@Override
			protected void afterScan(String value) {
				if (checkPrefix(ConstantsMedicalRecord.BARCODE_PREFIX_LOCATION, value)) {
					getChartLoc().setSelectedIndex(
							getChartLoc().findModelByKey(
									getValue(ConstantsMedicalRecord.BARCODE_PREFIX_LOCATION, value)));
				} else if (checkPrefix(ConstantsMedicalRecord.BARCODE_PREFIX_RECORDID, value)) {
					getRedID().setText(getValue(ConstantsMedicalRecord.BARCODE_PREFIX_RECORDID, value));
					appendAction();
				} else if (checkPrefix(ConstantsMedicalRecord.BARCODE_PREFIX_RECORDID_2, value)) {
					getRedID().setText(getValue(ConstantsMedicalRecord.BARCODE_PREFIX_RECORDID_2, value));
					appendAction();
				} else if (checkPrefix(ConstantsMedicalRecord.BARCODE_PREFIX_SAVE, value)) {
					if (getSaveButton().isEnabled()) {
						saveAction();
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
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] {
					"SYSPARAM, MEDRECLOC",
					"MRLID, MRLDESC",
					"PARCDE = 'MRTRCL' AND TO_CHAR(PARAM1) = MRLID"
				},
				new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							if (mQueue.getContentLineCount() > 0) {
								getChartLoc().setText(mQueue.getContentField()[1] + " "+ mQueue.getContentField()[0]);
							}
						}
					}
				});

		br.reset();

		boolean isHKAH = HKAH_VALUE.equals(getUserInfo().getSiteCode());
		getSendSMSDesc().setVisible(isHKAH);
		getSendSMS().setVisible(isHKAH);
		getSendSMS().setSelected(false);

		enableButton();
	}

	@Override
	protected void confirmCancelButtonClicked() {
	}

	@Override
	protected void appendDisabledFields() {
	}

	@Override
	protected void modifyDisabledFields() {
	}

	@Override
	protected void deleteDisabledFields() {
	}

	@Override
	protected String[] getBrowseInputParameters() {
		return null;
	}

	@Override
	protected String[] getFetchInputParameters() {
		return null;
	}

	@Override
	protected void getFetchOutputValues(String[] outParam) {
	}

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
		getDeleteButton().setEnabled(getEditReceiveList().getRowCount() > 0);
		getSaveButton().setEnabled(getEditReceiveList().getRowCount() > 0);
		getCount().setText(String.valueOf(getEditReceiveList().getRowCount()));
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

						if (!mQueue.getContentField()[1].equalsIgnoreCase("N")) {
							Factory.getInstance().addErrorMessage("Medical record is deleted or missing.");
							return;
						}

						String[] columnNames = getEditReceiveList().getColumnIDs();

						Object[] fields = new Object[getEditReceiveList().getColumnCount()];

						fields[0] = getRedID().getText().trim();
						fields[1] = getChartLoc().getDisplayText();
						fields[2] = getDate().isEmpty()?
										DateTimeUtil.parseDateTime(DateTimeUtil.getCurrentDateTime()):
											DateTimeUtil.parseDateTime(getDate().getText());

						TableData newModel = new TableData(columnNames, fields);
						getEditReceiveList().getStore().add(newModel);

						setPatientName(temp[0]);
						getRedID().resetText();
					}
					enableButton();
				}
			});
		}
	}

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

	@Override
	public void deleteAction() {
		if (getEditReceiveList().getSelectedRow() > -1) {
			getEditReceiveList().getStore().remove(getEditReceiveList().getSelectedRow());
		}
		enableButton();
	}

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
		getEditReceiveList().saveTable(getTxCode(),
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
	}

	private BasePanel getDispatchPanel() {
		if (dispatchPanel == null) {
			dispatchPanel = new BasePanel();
			dispatchPanel.setSize(750, 500);
			dispatchPanel.add(getChartLocDesc(), null);
			dispatchPanel.add(getChartLoc(), null);
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
			chartLoc.setBounds(95, 5, 365, 20);
		}
		return chartLoc;
	}

	private LabelBase getSendSMSDesc() {
		if (sendSMSdesc == null) {
			sendSMSdesc = new LabelBase();
			sendSMSdesc.setBounds(475, 5, 70, 20);
			sendSMSdesc.setText("SMS");
		}
		return sendSMSdesc;
	}

	private CheckBoxBase getSendSMS() {
		if (sendSMS == null) {
			sendSMS = new CheckBoxBase();
			sendSMS.setBounds(550, 5, 30, 20);
		}
		return sendSMS;
	}

	private LabelBase getRecAndVolIDDesc() {
		if (rediddesc == null) {
			rediddesc = new LabelBase();
			rediddesc.setBounds(5, 40, 85, 20);
			rediddesc.setText("Record ID &amp;<br/>Volume ID");
		}
		return rediddesc;
	}

	private TextString getRedID() {
		if (redID == null) {
			redID = new TextString();
			redID.setBounds(95, 45, 150, 20);
		}
		return redID;
	}

	private LabelBase getPatNameDesc() {
		if (patNameDesc == null) {
			patNameDesc = new LabelBase();
			patNameDesc.setBounds(260, 45, 35, 20);
			patNameDesc.setText("Name");
		}
		return patNameDesc;
	}

	private TextReadOnly getPatName() {
		if (patName == null) {
			patName = new TextReadOnly();
			patName.setBounds(300, 45, 160, 20);
		}
		return patName;
	}

	private LabelBase getDateDesc() {
		if (datedesc == null) {
			datedesc = new LabelBase();
			datedesc.setBounds(475, 45, 70, 20);
			datedesc.setText("Date");
		}
		return datedesc;
	}

	private TextDateTime getDate() {
		if (date == null) {
			date = new TextDateTime(true, true);
			date.setBounds(550, 45, 165, 20);
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
			listScrollPane.add(getEditReceiveList());
			listScrollPane.setBounds(5, 90, 745, 352);
		}
		return listScrollPane;
	}

	private EditorTableList getEditReceiveList() {
		if (editReceiveList == null) {
			editReceiveList = new EditorTableList(getColumnNames(),
						getColumnWidths(),
						getColumnEditor()) {
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
			editReceiveList.setBounds(5, 5, 733, 340);
		}
		return editReceiveList;
	}

	private Field<? extends Object>[] getColumnEditor() {
		Field<? extends Object>[] editors = new Field<?>[getColumnNames().length];

		editors[0] = new TextString();
		editors[1] = new ComboMedRecLoc(true, "{v} {k}");
		editors[2] = new TextDateTime(true, true) {
							@Override
							public void onBlur() {
								if (!validate()) {
									Factory.getInstance().addErrorMessage("Invalid Date.", this);
								}
							}
					 };

		return editors;
	}
}