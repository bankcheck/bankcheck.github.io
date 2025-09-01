package com.hkah.client.layout.dialog;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.MessageBox;
import com.extjs.gxt.ui.client.widget.form.TextField;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.combobox.ComboMedChartStatus;
import com.hkah.client.layout.combobox.ComboMedMediaType;
import com.hkah.client.layout.combobox.ComboMedRecLoc;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextAmount;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsGlobal;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgMRAmend extends DialogBase {

	private final static int m_frameWidth = 466;
	private final static int m_frameHeight = 345;

	private BasePanel panel = null;
	private LabelBase patNoDesc = null;
	private TextReadOnly patNo = null;
	private LabelBase patNameDesc = null;
	private TextReadOnly patName = null;
	private LabelBase recordIDDesc = null;
	private TextReadOnly recordID = null;
	private LabelBase volumeDesc = null;
	private TextAmount volume = null;
	private LabelBase mediaTypeDesc = null;
	private ComboMedMediaType mediaType = null;
	private LabelBase chartStatusDesc = null;
	private ComboMedChartStatus chartStatus = null;
	private LabelBase rmkDesc = null;
	private TextString rmk = null;
	private LabelBase storageLocDesc = null;
	private ComboMedRecLoc storageLoc = null;
	private LabelBase chartLocDesc = null;
	private ComboMedRecLoc chartLoc = null;

	private String memActionType = null;
	private String memChartSts = null;
	private String[] memSelectedRow = null;

	/**
	 * This method initializes
	 *
	 */
	public DlgMRAmend(MainFrame owner) {
		super(owner, OKCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setContentPane(getPanel());
	}

	public TextField getDefaultFocusComponent() {
		if (memActionType != null && memActionType.equals(QueryUtil.ACTION_DELETE)) {
			return getRmk();
		} else {
			return getVolume();
		}
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected void doOkAction() {
		modifyMedRec();
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String actionType, String patNo, String patName, String[] selectedRow) {
		memActionType = actionType;
		memSelectedRow = selectedRow;

		getVolume().setEnabled(true);
		getMediaType().setEnabled(true);
		getStorageLoc().setEnabled(true);
		getChartStatus().setEnabled(true);
		getChartLoc().setEnabled(true);
		getChartStatus().initContent();

		getPatNo().setText(selectedRow[18]);
		getPatName().setText(patName);
		getRecordID().setText(selectedRow[1]);
		getVolume().setText(selectedRow[21]);
		getMediaType().setText(selectedRow[11]);
		getChartStatus().setText(selectedRow[13]);
		getRmk().setText(selectedRow[10]);
		getStorageLoc().setText(selectedRow[4]);
		getChartLoc().setText(selectedRow[6]);

		if (QueryUtil.ACTION_MODIFY.equals(actionType)) {
			setTitle("Medical Record - Amend");
			if (!ConstantsGlobal.MEDICAL_RECORD_DELETE.equals(selectedRow[13])) {
				chartStatus.removeItemAt(3);
			}
		}

		if (QueryUtil.ACTION_DELETE.equals(actionType) || ConstantsGlobal.MEDICAL_RECORD_DELETE.equals(selectedRow[13])) {
			setTitle("Medical Record - Delete");
			getVolume().setEnabled(false);
			getMediaType().setEnabled(false);
			getStorageLoc().setEnabled(false);
			getChartStatus().setSelectedIndex(3);
			getChartStatus().setEnabled(false);
			getChartLoc().setEnabled(false);
			getRmkDesc().setText("Reason");
		}

		getDefaultFocusComponent().focus();
		setVisible(true);
	}

	private boolean validation() {
		if (getStorageLoc().isEmpty()) {
			Factory.getInstance().addErrorMessage("Storage location cannot be blank!", getStorageLoc());
			return false;
		} else if (getChartLoc().isEmpty()) {
			Factory.getInstance().addErrorMessage("Chart location cannot be blank!", getChartLoc());
			return false;
		} else if (getMediaType().isEmpty()) {
			Factory.getInstance().addErrorMessage("Media type cannot be blank!", getMediaType());
			return false;
		} else {
			return true;
		}
	}

	private void modifyMedRec() {
		if (validation()) {
			memChartSts = getChartStatus().getText();//ConstantsGlobal.MEDICAL_RECORD_X_DELETE;
			if (ConstantsGlobal.MEDICAL_RECORD_DELETE.equals(memChartSts)) {
				MessageBox mb = MessageBoxBase.confirm(ConstantsMessage.MSG_PBA_SYSTEM, "Permanent Deletion?",
						new Listener<MessageBoxEvent>() {
					public void handleEvent(MessageBoxEvent be) {
						if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
							memChartSts = ConstantsGlobal.MEDICAL_RECORD_PERMANENT;
						}

						String [] inParam = new String[] {
								memSelectedRow[16],
								memSelectedRow[17],
								volume.getText(),
								memChartSts,	//mrmsts
								mediaType.getText(),
								rmk.getText(),
								storageLoc.getText(),
								chartLoc.getText(),
								memSelectedRow[20],
								getUserInfo().getUserID()
						};

						QueryUtil.executeMasterAction(
								getUserInfo(), ConstantsTx.MEDRECMODIFY_TXCODE,
								memActionType, inParam,
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									dispose();
								}
							}
						});
					}
				});
				
				mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
			} else {
				String [] inParam = new String[] {
						memSelectedRow[16],
						memSelectedRow[17],
						volume.getText(),
						memChartSts,	//mrmsts
						mediaType.getText(),
						rmk.getText(),
						storageLoc.getText(),
						chartLoc.getText(),
						memSelectedRow[20],
						getUserInfo().getUserID()
				};

				QueryUtil.executeMasterAction(
						getUserInfo(), ConstantsTx.MEDRECMODIFY_TXCODE,
						memActionType, inParam,
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							dispose();
						}
					}
				});
			}
		}
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/**
	 * This method initializes panel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	private BasePanel getPanel() {
		if (panel == null) {
			panel = new BasePanel();
			panel.add(getPatNoDesc(), null);
			panel.add(getPatNo(), null);
			panel.add(getPatNameDesc(), null);
			panel.add(getPatName(), null);
			panel.add(getRecordIDDesc(), null);
			panel.add(getRecordID(), null);
			panel.add(getVolume(), null);
			panel.add(getVolumeDesc(), null);
			panel.add(getMediaTypeDesc(), null);
			panel.add(getMediaType(), null);
			panel.add(getChartStatusDesc(), null);
			panel.add(getChartStatus(), null);
			panel.add(getRmkDesc(), null);
			panel.add(getRmk(), null);
			panel.add(getStorageLocDesc(), null);
			panel.add(getStorageLoc(), null);
			panel.add(getChartLocDesc(), null);
			panel.add(getChartLoc(), null);
		}
		return panel;
	}

	/**
	 * This method initializes patNoDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getPatNoDesc() {
		if (patNoDesc == null) {
			patNoDesc = new LabelBase();
			patNoDesc.setBounds(17, 10, 100, 20);
			patNoDesc.setText("Patient No.");
		}
		return patNoDesc;
	}

	/**
	 * This method initializes patNo
	 *
	 * @return com.hkah.client.layout.textfield.TextReadOnly
	 */
	private TextReadOnly getPatNo() {
		if (patNo == null) {
			patNo = new TextReadOnly();
			patNo.setBounds(105, 10, 82, 20);
		}
		return patNo;
	}

	/**
	 * This method initializes patNameDesc
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private LabelBase getPatNameDesc() {
		if (patNameDesc == null) {
			patNameDesc = new LabelBase();
			patNameDesc.setBounds(194, 10, 100, 20);
			patNameDesc.setText("Name");
		}
		return patNameDesc;
	}

	/**
	 * This method initializes patName
	 *
	 * @return com.hkah.client.layout.textfield.TextReadOnly
	 */

	private TextReadOnly getPatName() {
		if (patName == null) {
			patName = new TextReadOnly();
			patName.setBounds(231, 10, 128, 20);
		}
		return patName;
	}

	/**
	 * This method initializes recordIDDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRecordIDDesc() {
		if (recordIDDesc == null) {
			recordIDDesc = new LabelBase();
			recordIDDesc.setBounds(17, 40, 100, 18);
			recordIDDesc.setText("Record ID");
		}
		return recordIDDesc;
	}

	/**
	 * This method initializes recordID
	 *
	 * @return com.hkah.client.layout.textfield.TextReadOnly
	 */
	private TextReadOnly getRecordID() {
		if (recordID == null) {
			recordID = new TextReadOnly();
			recordID.setBounds(105, 40, 82, 20);
		}
		return recordID;
	}

	/**
	 * This method initializes volumeDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getVolumeDesc() {
		if (volumeDesc == null) {
			volumeDesc = new LabelBase();
			volumeDesc.setBounds(18, 70, 100, 18);
			volumeDesc.setText("Volume ID");
		}
		return volumeDesc;
	}

	/**
	 * This method initializes volume
	 *
	 * @return com.hkah.client.layout.textfield.TextNum
	 */
	private TextAmount getVolume() {
		if (volume == null) {
			volume = new TextAmount(5) {
				public void onReleased() {
					// generate recordID
					getRecordID().setText(getPatNo().getText() + "/" + getVolume().getText().trim());
				}
			};
			volume.setBounds(105, 70, 42, 20);
		}
		return volume;
	}

	/**
	 * This method initializes mediaTypeDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getMediaTypeDesc() {
		if (mediaTypeDesc == null) {
			mediaTypeDesc = new LabelBase();
			mediaTypeDesc.setBounds(18, 100, 100, 20);
			mediaTypeDesc.setText("Media type");
		}
		return mediaTypeDesc;
	}

	/**
	 * This method initializes ComboMedMediaType
	 *
	 * @return com.hkah.client.layout.combobox.ComboMedMediaType
	 */
	private ComboMedMediaType getMediaType() {
		if (mediaType == null) {
			mediaType = new ComboMedMediaType();
			mediaType.setBounds(105, 100, 256, 20);
		}
		return mediaType;
	}

	/**
	 * This method initializes chartStatusDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getChartStatusDesc() {
		if (chartStatusDesc == null) {
			chartStatusDesc = new LabelBase();
			chartStatusDesc.setBounds(18, 130, 100, 20);
			chartStatusDesc.setText("Chart Status");
		}
		return chartStatusDesc;
	}

	/**
	 * This method initializes chartStatus
	 *
	 * @return com.hkah.client.layout.combobox.ComboMedChartStatus
	 */
	private ComboMedChartStatus getChartStatus() {
		if (chartStatus == null) {
			chartStatus = new ComboMedChartStatus();
			chartStatus.setBounds(105, 130, 82, 20);
		}
		return chartStatus;
	}

	/**
	 * This method initializes rmkDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRmkDesc() {
		if (rmkDesc == null) {
			rmkDesc = new LabelBase();
			rmkDesc.setBounds(18, 160, 100, 20);
			rmkDesc.setText("Requestor/Rmk");
		}
		return rmkDesc;
	}

	/**
	 * This method initializes rmk
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRmk() {
		if (rmk == null) {
			rmk = new TextString(false);
			rmk.setBounds(105, 160, 256, 20);
		}
		return rmk;
	}

	/**
	 * This method initializes storageLocDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getStorageLocDesc() {
		if (storageLocDesc == null) {
			storageLocDesc = new LabelBase();
			storageLocDesc.setBounds(18, 190, 100, 19);
			storageLocDesc.setText("Storage location");
		}
		return storageLocDesc;
	}

	/**
	 * This method initializes storageLoc
	 *
	 * @return com.hkah.client.layout.combobox.ComboMedRecLoc
	 */
	private ComboMedRecLoc getStorageLoc() {
		if (storageLoc == null) {
			storageLoc = new ComboMedRecLoc();
			storageLoc.setBounds(105, 190, 256, 20);
		}
		return storageLoc;
	}

	/**
	 * This method initializes chartLocDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getChartLocDesc() {
		if (chartLocDesc == null) {
			chartLocDesc = new LabelBase();
			chartLocDesc.setBounds(18, 220, 100, 20);
			chartLocDesc.setText("Chart location");
		}
		return chartLocDesc;
	}

	/**
	 * This method initializes chartLoc
	 *
	 * @return com.hkah.client.layout.combobox.ComboMedRecLoc
	 */
	private ComboMedRecLoc getChartLoc() {
		if (chartLoc == null) {
			chartLoc = new ComboMedRecLoc();
			chartLoc.setBounds(105, 220, 256, 20);
		}
		return chartLoc;
	}
}