package com.hkah.client.layout.dialog;

import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.combobox.ComboMedMediaType;
import com.hkah.client.layout.combobox.ComboMedRecLoc;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsGlobal;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgMRAdd extends DialogBase {

	private final static int m_frameWidth = 445;
	private final static int m_frameHeight = 320;

	private BasePanel panel = null;
	private LabelBase patNoDesc = null;
	private TextString patNo = null;
	private LabelBase patNameDesc = null;
	private TextReadOnly patName = null;
	private LabelBase storageLocDesc = null;
	private ComboMedRecLoc storageLoc = null;
	private LabelBase chartLocDesc = null;
	private ComboMedRecLoc chartLoc = null;
	private LabelBase mediaTypeDesc = null;
	private ComboMedMediaType mediaType = null;
	private LabelBase recordIDDesc = null;
	private TextReadOnly patNo2 = null;
	private TextString volume = null;
	private LabelBase volumeDesc = null;
	private TextReadOnly recordID = null;

	/**
	 * This method initializes
	 *
	 */
	public DlgMRAdd(MainFrame owner) {
		super(owner, OKCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setContentPane(getPanel());
        setTitle("Medical Record - Add Volume");
	}

	public TextString getDefaultFocusComponent() {
		System.err.println("[getDefaultFocusComponent]");
		return getPatNo();
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected void doOkAction() {
		appendMedRec();
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(final String patno, String patName) {
		getPatNo().setText(patno);
//		logger.info("[getPatNo]:" + getPatNo().getText()+";[patno]:"+patno);
//		Factory.getInstance().writeLogToLocal("[getPatNo]:" + getPatNo().getText()+";[patno]:"+patno);
		writeLog( "MedicalRecord", "Info", "[getPatNo]:" + getPatNo().getText()+";[patno]:"+patno);
		getPatName().setText(patName);
		getPatNo2().setText(patno);
//		logger.info("[getPatNo2]:" + getPatNo2().getText()+";[patno]:"+patno);
//		Factory.getInstance().writeLogToLocal("[getPatNo2]:" + getPatNo2().getText()+";[patno]:"+patno);
		writeLog( "MedicalRecord", "Info", "[getPatNo2]:" + getPatNo2().getText()+";[patno]:"+patno);
		
		QueryUtil.executeMasterFetch(
				getUserInfo(), ConstantsTx.ADDMEDRECVOLINFO_TXCODE,
				new String[] {
								patno,
								ConstantsGlobal.NEWVOLSTORAGELOCATION,
								ConstantsGlobal.NEWVOLCURRENTLOCATION,
								ConstantsGlobal.NEWVOLMEDIATYPE
				},
				new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						String vol = mQueue.getContentField()[0];
						if (vol.length() == 1) {
							vol = "0" + vol;
						}
						
						getVolume().setText(vol);
						genRecordID();
						
						getStorageLoc().setText(mQueue.getContentField()[1]);
						getChartLoc().setText(mQueue.getContentField()[2]);
						getMediaType().setText(mQueue.getContentField()[3]);
						
						setVisible(true);
					}
				});
	}

	private void genRecordID() {
		getRecordID().setText(getPatNo2().getText() + "/" + getVolume().getText().trim());
	}

	private boolean validation() {
		if (getPatNo().getText().trim().length() < 1) {
			Factory.getInstance().addErrorMessage(ConstantsGlobal.MSG_PATNO_NO_BLANK, getPatNo());
			return false;
		} else if (getStorageLoc().getText().trim().length() < 1) {
			Factory.getInstance().addErrorMessage("Storage location cannot be blank!", getStorageLoc());
			return false;
		} else if (getChartLoc().getText().trim().length() < 1) {
			Factory.getInstance().addErrorMessage("Chart location cannot be blank!", getChartLoc());
			return false;
		} else if (getMediaType().getText().trim().length() < 1) {
			Factory.getInstance().addErrorMessage("Media type cannot be blank!", getMediaType());
			return false;
		}
		return true;
	}

	private void appendMedRec() {
		System.err.println("[appendMedRec]");
		if (validation()) {
			String [] inParam = new String[] {
					getPatNo().getText().trim(),
					getVolume().getText(),
					getUserInfo().getSiteCode(),
					getMediaType().getText(),
					getUserInfo().getUserID(),
					getStorageLoc().getText(),
					getChartLoc().getText()
			};
			QueryUtil.executeMasterAction(
					getUserInfo(), ConstantsTx.MEDREC_TXCODE, QueryUtil.ACTION_APPEND, inParam,
					new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if ("-1".equals(mQueue.getReturnCode())) {
								Factory.getInstance().addErrorMessage(mQueue.getReturnMsg());
							}
							if (mQueue.success()) {
								dispose();
							}
						}
					});
		}
	}
	
	protected void writeLog(String module, String logAction, String remark) {
		Factory.getInstance().writeLog(module, logAction, remark);
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
			panel.add(getStorageLocDesc(), null);
			panel.add(getStorageLoc(), null);
			panel.add(getChartLocDesc(), null);
			panel.add(getChartLoc(), null);
			panel.add(getMediaTypeDesc(), null);
			panel.add(getMediaType(), null);
			panel.add(getRecordIDDesc(), null);
			panel.add(getPatNo2(), null);
			panel.add(getVolume(), null);
			panel.add(getVolumeDesc(), null);
			panel.add(getRecordID(), null);
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
			patNoDesc.setBounds(13, 10, 100, 20);
			patNoDesc.setText("Patient No.");
		}
		return patNoDesc;
	}

	/**
	 * This method initializes patNo
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getPatNo() {
		if (patNo == null) {
			patNo = new TextString() {
				public void onBlur() {
					if (patNo.getText().trim().length()>0) {
						QueryUtil.executeMasterFetch(getUserInfo(), "PATIENTBYNO",
								new String[] {patNo.getText().trim()},
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									patName.setText(mQueue.getContentField()[0]+" "+mQueue.getContentField()[1]);
								} else {
									patName.resetText();
								}
							}
						});
					}
				}

				public void onReleased() {
					patNo2.setText(patNo.getText().trim());
					genRecordID();
				}
			};
			patNo.setBounds(110, 10, 85, 20);
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
			patNameDesc.setBounds(220, 10, 100, 20);
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
			patName.setBounds(255, 10, 120, 20);
		}
		return patName;
	}

	/**
	 * This method initializes storageLocDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getStorageLocDesc() {
		if (storageLocDesc == null) {
			storageLocDesc = new LabelBase();
			storageLocDesc.setBounds(13, 50, 100, 19);
			storageLocDesc.setText("Storage location");
		}
		return storageLocDesc;
	}

	/**
	 * This method initializes storageLoc
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private ComboMedRecLoc getStorageLoc() {
		if (storageLoc == null) {
			storageLoc = new ComboMedRecLoc();
			storageLoc.setBounds(110, 50, 245, 20);
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
			chartLocDesc.setBounds(13, 90, 100, 20);
			chartLocDesc.setText("Chart location");
		}
		return chartLocDesc;
	}

	/**
	 * This method initializes chartLoc
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private ComboMedRecLoc getChartLoc() {
		if (chartLoc == null) {
			chartLoc = new ComboMedRecLoc();
			chartLoc.setBounds(110, 90, 245, 20);
		}
		return chartLoc;
	}

	/**
	 * This method initializes mediaTypeDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getMediaTypeDesc() {
		if (mediaTypeDesc == null) {
			mediaTypeDesc = new LabelBase();
			mediaTypeDesc.setBounds(13, 130, 100, 20);
			mediaTypeDesc.setText("Media type");
		}
		return mediaTypeDesc;
	}

	/**
	 * This method initializes mediaType
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private ComboMedMediaType getMediaType() {
		if (mediaType == null) {
			mediaType = new ComboMedMediaType();
			mediaType.setBounds(110, 130, 245, 20);
		}
		return mediaType;
	}

	/**
	 * This method initializes recordIDDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRecordIDDesc() {
		if (recordIDDesc == null) {
			recordIDDesc = new LabelBase();
			recordIDDesc.setBounds(13, 170, 150, 18);
			recordIDDesc.setText("Record ID &amp;");
		}
		return recordIDDesc;
	}

	/**
	 * This method initializes patNo2
	 *
	 * @return com.hkah.client.layout.textfield.TextReadOnly
	 */
	private TextReadOnly getPatNo2() {
		if (patNo2 == null) {
			patNo2 = new TextReadOnly();
			patNo2.setBounds(110, 170, 70, 20);
		}
		return patNo2;
	}

	/**
	 * This method initializes volume
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getVolume() {
		if (volume == null) {
			volume = new TextString() {
				public void onReleased() {
					genRecordID();
				}
			};
			volume.setBounds(180, 170, 42, 20);
		}
		return volume;
	}

	/**
	 * This method initializes volumeDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getVolumeDesc() {
		if (volumeDesc == null) {
			volumeDesc = new LabelBase();
			volumeDesc.setBounds(13, 190, 100, 18);
			volumeDesc.setText("Volume ID");
		}
		return volumeDesc;
	}

	/**
	 * This method initializes recordID
	 *
	 * @return com.hkah.client.layout.textfield.TextReadOnly
	 */
	private TextReadOnly getRecordID() {
		if (recordID == null) {
			recordID = new TextReadOnly();
			recordID.setBounds(110, 210, 112, 20);
		}
		return recordID;
	}
}