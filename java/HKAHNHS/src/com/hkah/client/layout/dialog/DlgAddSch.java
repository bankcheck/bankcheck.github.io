package com.hkah.client.layout.dialog;

import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.combobox.ComboDoctorLocation;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.label.LabelSmallBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextDateTimeWithoutSecond;
import com.hkah.client.layout.textfield.TextNum;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.PanelUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public abstract class DlgAddSch extends DialogBase {
	private final static int m_frameWidth = 350;
	private final static int m_frameHeight = 360;

	private BasePanel schPanel = null;
	private FieldSetBase schTopPanel = null;
	private LabelBase schSiteDESC = null;
	private TextReadOnly schSite = null;
	private LabelBase schDocCodeDESC = null;
	private TextString schDocCode = null;
	private LabelBase schDocNameDESC = null;
	private TextReadOnly schDocName = null;
	private LabelBase schStartTimeDESC = null;
	private TextDateTimeWithoutSecond schStartTime = null;
	private LabelBase schEndTimeDESC = null;
	private TextDateTimeWithoutSecond schEndTime = null;
	private LabelBase schDurationDESC = null;
	private TextNum schDuration = null;
	private LabelBase docPrRemarkDesc = null;
	private TextString docPrRemark = null;
	private LabelBase docLocationDESC = null;
	private ComboDoctorLocation docLocation = null;
	private LabelSmallBase docRoomDesc = null;
	private ComboBoxBase docRoom = null;	
	private LabelBase allowPublicHolidayDesc = null;
	private CheckBoxBase allowPublicHoliday = null;

	private String memCurrentSite = null;
	private String memCurrdate = null;
	private String memSpecCode = null;
	private String memDocCode = null;

	public DlgAddSch(MainFrame owner) {
		super(owner, OKCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Add Schedule");
		setContentPane(getSchPanel());

		// change label
		getButtonById(DialogBase.OK).setText("Add");
		getButtonById(DialogBase.CANCEL).setText("Exit");
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	@Override
	public TextString getDefaultFocusComponent() {
		return getSchDocCode();
	}

	public void showDialog(String siteCode, final String docCode, String currdate, final String specCode) {
		memCurrentSite = siteCode;
		memCurrdate = currdate;
		memSpecCode = specCode;
		memDocCode = null;

		if (docCode.length() > 0) {
			QueryUtil.executeMasterFetch(getUserInfo(), "DOCTOR_ACTIVE",
					new String[] { docCode },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success() && (specCode == null || specCode.equals(mQueue.getContentField()[3]))) {
						getSchDocCode().setText(docCode);
						getSchDocName().setText(mQueue.getContentField()[0]);
						getSchDocCode().onBlur();
					} else {
						getSchDocCode().resetText();
						getSchDocName().resetText();
					}
				}
			});
		}

		setVisible(true);

		PanelUtil.resetAllFields(getSchTopPanel());
		getSchSite().setText(memCurrentSite);
		if (memCurrdate != null && memCurrdate.length() > 0) {
			getSchStartTime().setRawValue(memCurrdate + SPACE_VALUE);
			getSchEndTime().setRawValue(memCurrdate + SPACE_VALUE);
		} else {
			getSchStartTime().resetText();
			getSchEndTime().resetText();
		}

		getAllowPublicHoliday().setSelected(false);
	}

	@Override
	public void doOkAction() {
		if (getSchDocCode().isEmpty()) {
			Factory.getInstance().addErrorMessage("Please enter a valid active doctor. ", "PBA - [Add Schedule]", getSchDocCode());
			schValidateReady(false);
		} else {
			QueryUtil.executeMasterFetch(getUserInfo(), "DOCTOR_ACTIVE",
					new String[] { getSchDocCode().getText().trim() },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						schValidate();
					} else {
						Factory.getInstance().addErrorMessage("Please enter a valid active doctor. ", "PBA - [Add Schedule]", getSchDocCode());
						schValidateReady(false);
					}
				}
			});
		}
	}

	public void clearAction() {
		PanelUtil.resetAllFields(getSchTopPanel());
		getSchSite().setText(memCurrentSite);
	}

	// schedule add validate
	private void schValidateReady(boolean ready) {
		if (ready) {
			post(false);
		}
	}

	private void schValidate() {
		String sdv = getSchStartTime().getText().trim();
		String edv = getSchEndTime().getText().trim();

		if (sdv.length() == 0) {
			Factory.getInstance().addErrorMessage("Start time is empty!", "PBA - [Add Schedule]", getSchStartTime());
			schValidateReady(false);
		} else if (edv.length() == 0) {
			Factory.getInstance().addErrorMessage("End time is empty!", "PBA - [Add Schedule]", getSchStartTime());
			schValidateReady(false);
		} else if (sdv.indexOf("/") == -1 || edv.indexOf("/") == -1) {
			getSchStartTime().resetText();
			Factory.getInstance().addErrorMessage("Invalid date!", "PBA - [Add Schedule]", getSchStartTime());
			schValidateReady(false);
		} else if (getDocLocation().getKeySize() > 0 && getDocLocation().isEmpty()) {
			Factory.getInstance().addErrorMessage("Doctor Location is empty!", "PBA - [Add Schedule]", getDocLocation());
			schValidateReady(false);
		} else if (getDocRoom().getKeySize() > 0 && getDocRoom().isEmpty()) {
			Factory.getInstance().addErrorMessage("Doctor Room is empty!", "PBA - [Add Schedule]", getDocRoom());
			schValidateReady(false);
		} else {
			String sd = sdv.substring(0, 10);
			String ed = edv.substring(0, 10);
			if (DateTimeUtil.isValidDate(sd) && DateTimeUtil.isValidDate(ed)) {
				if (DateTimeUtil.compareTo(sd, memCurrdate) < 0) {
					Factory.getInstance().addErrorMessage("Creation of schedule with passed date is not allowed.", "PBA - [Add Schedule]", getSchStartTime());
					schValidateReady(false);
				} else {
					if (DateTimeUtil.compareTo(sd, ed) == 0) {
						if (sdv.length() > sd.length() && !DateTimeUtil.isValidDateTimeWithSecond(sdv)) {
							getSchStartTime().resetText();
							Factory.getInstance().addErrorMessage("Invalid date!", "PBA - [Add Schedule]", getSchStartTime());
							schValidateReady(false);
						} else if (edv.length() > ed.length() && !DateTimeUtil.isValidDateTimeWithSecond(edv)) {
							getSchStartTime().resetText();
							Factory.getInstance().addErrorMessage("Invalid date!", "PBA - [Add Schedule]", getSchStartTime());
							schValidateReady(false);
						} else if (sdv.length() > sd.length() && edv.length() > ed.length()) {
							if (DateTimeUtil.isValidDateTimeWithSecond(sdv)&&DateTimeUtil.isValidDateTimeWithSecond(edv)) {
								if (!DateTimeUtil.timeCompare(sdv.replaceFirst(sd+" ",EMPTY_VALUE), edv.replaceFirst(ed+" ",EMPTY_VALUE))) {
									if (getSchDuration().isEmpty()) {
										Factory.getInstance().addErrorMessage("Please enter duration. ", "PBA - [Add Schedule]", getSchDuration());
										schValidateReady(false);
									} else {
										schValidateReady(true);
									}
								} else {
									Factory.getInstance().addErrorMessage("Date range incorrect.", "PBA - [Add Schedule]", getSchStartTime());
									schValidateReady(false);
								}
							} else {
								getSchStartTime().resetText();
								Factory.getInstance().addErrorMessage("Invalid date!", "PBA - [Add Schedule]", getSchStartTime());
								schValidateReady(false);
							}
						} else {
							Factory.getInstance().addErrorMessage("Date range incorrect.", "PBA - [Add Schedule]", getSchStartTime());
							schValidateReady(false);
						}
					} else {
						Factory.getInstance().addErrorMessage("The date range must be within the same day.", "PBA - [Add Schedule]", getSchStartTime());
						schValidateReady(false);
					}
				}
			} else {
				getSchStartTime().resetText();
				Factory.getInstance().addErrorMessage("Invalid date!", "PBA - [Add Schedule]", getSchStartTime());
				schValidateReady(false);
			}
		}
	}

	protected abstract void post(boolean override);

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getSchPanel() {
		if (schPanel == null) {
			schPanel = new BasePanel();
			schPanel.setBounds(0, 0, 320, 210);
			schPanel.add(getSchTopPanel(), null);
		}
		return schPanel;
	}

	public FieldSetBase getSchTopPanel() {
		if (schTopPanel == null) {
			schTopPanel = new FieldSetBase();
			schTopPanel.setBounds(0, 0, 320, 270);
			schTopPanel.setHeading("Schedule Infomation");
			schTopPanel.add(getSchSiteDESC(), null);
			schTopPanel.add(getSchSite(), null);
			schTopPanel.add(getSchDocCodeDESC(), null);
			schTopPanel.add(getSchDocCode(), null);
			schTopPanel.add(getSchDocNameDESC(), null);
			schTopPanel.add(getSchDocName(), null);
			schTopPanel.add(getSchStartTimeDESC(), null);
			schTopPanel.add(getSchStartTime(), null);
			schTopPanel.add(getSchEndTimeDESC(), null);
			schTopPanel.add(getSchEndTime(), null);
			schTopPanel.add(getSchDurationDESC(), null);
			schTopPanel.add(getSchDuration(), null);
			schTopPanel.add(getDocPrRemarkDESC(), null);
			schTopPanel.add(getDocPrRemark(), null);
			schTopPanel.add(getDocLocationDESC(), null);
			schTopPanel.add(getDocLocation(), null);
			schTopPanel.add(getDocRoomDesc(), null);
			schTopPanel.add(getDocRoom(), null);
			schTopPanel.add(getAllowPublicHolidayDesc(), null);
			schTopPanel.add(getAllowPublicHoliday(), null);
		}
		return schTopPanel;
	}

	public LabelBase getSchSiteDESC() {
		if (schSiteDESC == null) {
			schSiteDESC = new LabelBase();
			schSiteDESC.setText("Site");
			schSiteDESC.setBounds(15, 0, 120, 20);
		}
		return schSiteDESC;
	}

	public TextReadOnly getSchSite() {
		if (schSite == null) {
			schSite = new TextReadOnly();
			schSite.setBounds(125, 0, 180, 20);
		}
		return schSite;
	}

	public LabelBase getSchDocCodeDESC() {
		if (schDocCodeDESC == null) {
			schDocCodeDESC = new LabelBase();
			schDocCodeDESC.setText("Doctor Code");
			schDocCodeDESC.setBounds(15, 25, 120, 20);
		}
		return schDocCodeDESC;
	}

	public TextString getSchDocCode() {
		if (schDocCode == null) {
			schDocCode = new TextString() {
				public void onBlur() {
					if (schDocCode.getText().trim().length() > 0) {
						QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.DOCTSLOT_TXCODE,
								new String[] {schDocCode.getText().trim()},
								new MessageQueueCallBack() {
									public void onPostSuccess(MessageQueue mQueue) {
										if (mQueue.success() && (memSpecCode == null || memSpecCode.equals(mQueue.getContentField()[2])) &&
												(!schDocCode.getText().trim().equals(memDocCode))) {
											getSchDocName().setText(mQueue.getContentField()[0]);
											getSchDuration().setText(mQueue.getContentField()[1]);
											memDocCode = schDocCode.getText().trim();
										} else if (schDocCode.getText().trim().equals(memDocCode)) {
											getSchDocName().setText(mQueue.getContentField()[0]);
										} else {
											getSchDocCode().resetText();
											getSchDocName().resetText();
											getSchDuration().resetText();
											memDocCode = null;
										}
									}
								}
						);
					} else {
						getSchDocCode().resetText();
						getSchDocName().resetText();
					}
				};
			};
			schDocCode.setBounds(125, 25, 180, 20);
		}
		return schDocCode;
	}

	public LabelBase getSchDocNameDESC() {
		if (schDocNameDESC == null) {
			schDocNameDESC = new LabelBase();
			schDocNameDESC.setText("Doctor Name");
			schDocNameDESC.setBounds(15, 50, 120, 20);
		}
		return schDocNameDESC;
	}

	public TextReadOnly getSchDocName() {
		if (schDocName == null) {
			schDocName = new TextReadOnly();
			schDocName.setBounds(125, 50, 180, 20);
		}
		return schDocName;
	}

	public LabelBase getSchStartTimeDESC() {
		if (schStartTimeDESC == null) {
			schStartTimeDESC = new LabelBase();
			schStartTimeDESC.setText("Start Time");
			schStartTimeDESC.setBounds(15, 75, 120, 20);
		}
		return schStartTimeDESC;
	}

	public TextDateTimeWithoutSecond getSchStartTime() {
		if (schStartTime == null) {
			schStartTime = new TextDateTimeWithoutSecond() {
				public void onBlur() {
					if (!isEmpty()) {
						if (!isValid()) {
							String schStartTimeStr = getRawValue().trim();
							if (schStartTimeStr.length() >= 10 && DateTimeUtil.isValidDate(schStartTimeStr.substring(0, 10))) {
								if (schStartTimeStr.length() == 10) {
									schStartTime.setText(schStartTimeStr.substring(0, 10) + " 00:00");
								}
								getSchEndTime().setText(getText().substring(0, 10) + SPACE_VALUE);
								getSchEndTime().setRawValue(getText().substring(0, 10) + SPACE_VALUE);
								getSchEndTime().setSelectionRange(getText().substring(0, 10).length() + 1, 0);
							} else {
								schStartTime.resetText();
								Factory.getInstance().addErrorMessage("Invalid date!", "PBA - [Add Schedule]", schStartTime);
							}
						} else {//if (getSchEndTime().getRawValue().length() == 0) {
							getSchEndTime().setText(getText().substring(0, 10) + SPACE_VALUE);
							getSchEndTime().setRawValue(getText().substring(0, 10) + SPACE_VALUE);
							getSchEndTime().setSelectionRange(getText().substring(0, 10).length() + 1, 0);
						}
					}
				}
			};
			schStartTime.setBounds(125, 75, 180, 20);
		}
		return schStartTime;
	}

	public LabelBase getSchEndTimeDESC() {
		if (schEndTimeDESC == null) {
			schEndTimeDESC = new LabelBase();
			schEndTimeDESC.setText("End Time");
			schEndTimeDESC.setBounds(15, 100, 120, 20);
		}
		return schEndTimeDESC;
	}

	public TextDateTimeWithoutSecond getSchEndTime() {
		if (schEndTime == null) {
			schEndTime = new TextDateTimeWithoutSecond() {
				public void onBlur() {
					if (!isEmpty()) {
						if (!isValid()) {
							String schEndTimeStr = getRawValue().trim();
							if (schEndTimeStr.length() >= 10 && DateTimeUtil.isValidDate(schEndTimeStr.substring(0, 10))) {
								schEndTime.setText(schEndTimeStr.substring(0, 10) + " 23:59");
							} else {
								schEndTime.resetText();
								Factory.getInstance().addErrorMessage("Invalid date!", "PBA - [Add Schedule]", schEndTime);
							}
						}
					}
				}
			};
			schEndTime.setBounds(125, 100, 180, 20);
		}
		return schEndTime;
	}

	public LabelBase getSchDurationDESC() {
		if (schDurationDESC == null) {
			schDurationDESC = new LabelBase();
			schDurationDESC.setText("Duration");
			schDurationDESC.setBounds(15, 125, 120, 20);
		}
		return schDurationDESC;
	}

	public TextNum getSchDuration() {
		if (schDuration == null) {
			schDuration = new TextNum(2);
			schDuration.setBounds(125, 125, 180, 20);
		}
		return schDuration;
	}

	public LabelBase getDocPrRemarkDESC() {
		if (docPrRemarkDesc == null) {
			docPrRemarkDesc = new LabelBase();
			docPrRemarkDesc.setText("Doctor Practice Rmk");
			docPrRemarkDesc.setBounds(15, 150, 120, 20);
		}
		return docPrRemarkDesc;
	}

	public TextString getDocPrRemark() {
		if (docPrRemark == null) {
			docPrRemark = new TextString(250, false);
			docPrRemark.setBounds(125, 150, 180, 20);
		}
		return docPrRemark;
	}

	public LabelBase getDocLocationDESC() {
		if (docLocationDESC == null) {
			docLocationDESC = new LabelBase();
			docLocationDESC.setText("Doctor Location");
			docLocationDESC.setBounds(15, 175, 120, 20);
		}
		return docLocationDESC;
	}

	public ComboDoctorLocation getDocLocation() {
		if (docLocation == null) {
			docLocation = new ComboDoctorLocation();
			docLocation.setBounds(125, 175, 180, 20);
		}
		return docLocation;
	}
	
	private LabelSmallBase getDocRoomDesc() {
		if (docRoomDesc == null) {
			docRoomDesc = new LabelSmallBase();
			docRoomDesc.setText("Doctor Room");
			docRoomDesc.setBounds(35, 200, 70, 20);
		}
		return docRoomDesc;
	}

	public ComboBoxBase getDocRoom() {
		if (docRoom == null) {
			docRoom = new ComboBoxBase("DRROOM", false, true, true);
			docRoom.setBounds(125, 200, 180, 20);
		}
		return docRoom;
	}

	/**
	 * @return the allowPublicHolidayDesc
	 */
	private LabelBase getAllowPublicHolidayDesc() {
		if (allowPublicHolidayDesc == null) {
			allowPublicHolidayDesc = new LabelBase();
			allowPublicHolidayDesc.setText("Generate on Public Holiday");
			allowPublicHolidayDesc.setBounds(15, 225, 150, 20);
		}
		return allowPublicHolidayDesc;
	}

	/**
	 * @return the allowPublicHoliday
	 */
	protected CheckBoxBase getAllowPublicHoliday() {
		if (allowPublicHoliday == null) {
			allowPublicHoliday = new CheckBoxBase();
			allowPublicHoliday.setBounds(115, 225, 180, 20);
		}
		return allowPublicHoliday;
	}
}