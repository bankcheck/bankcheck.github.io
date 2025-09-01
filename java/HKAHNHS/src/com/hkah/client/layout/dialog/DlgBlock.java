package com.hkah.client.layout.dialog;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.layout.textfield.TextTime;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public abstract class DlgBlock extends DialogBase {
    private final static int m_frameWidth = 390;
    private final static int m_frameHeight = 210;

    private BasePanel blockPanel = null;
	private FieldSetBase blockTopPanel = null;
	private LabelBase blockDoctorDESC = null;
	private TextReadOnly blockDocCode = null;
	private TextReadOnly blockDocName = null;
	private LabelBase blockSTimeDESC = null;
	private TextTime blockSTime = null;
	private LabelBase blockETimeDESC = null;
	private TextTime blockETime = null;

	private String memSchID = null;
	private String memDate = null;
//	private String memSchLen = null;

	public DlgBlock(MainFrame owner) {
    	super(owner, OKCANCEL, m_frameWidth, m_frameHeight);
    	initialize();
    }

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
    	setTitle("Schedule Blocking");
    	setContentPane(getBlockPanel());

    	setPosition(300, 100);

    	// change label
    	getButtonById(OK).setText("Block", 'B');
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	@Override
	public TextString getDefaultFocusComponent() {
		return getBlockSTime();
	}

	public void showDialog(String schID, String startTime, String endTime,
			String docCode, String docFName, String docGName,
			String schLen) {
		memSchID = schID;
		memDate = startTime.substring(0, 10);
//		memSchLen = schLen;
		getBlockDocCode().setText(docCode);
		getBlockDocName().setText(docFName + SPACE_VALUE + docGName);
		getBlockSTime().setText(startTime.substring(11));
		getBlockETime().setText(endTime);

    	setVisible(true);
	}

	@Override
	protected void doOkAction() {
		if (getBlockSTime().isEmpty() || !getBlockSTime().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid Time.", getBlockSTime());
			return;
		}

		if (getBlockETime().isEmpty() || !getBlockETime().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid Time.", getBlockETime());
			return;
		}

		if (!DateTimeUtil.timeCompare(getBlockSTime().getText().trim(), getBlockETime().getText().trim())) {
			String startTime = memDate + SPACE_VALUE + getBlockSTime().getText().trim() + ":00";
			String endTime = memDate + SPACE_VALUE + getBlockETime().getText().trim() + ":00";
			if (startTime == null || endTime == null) {
				Factory.getInstance().addErrorMessage("Invalid Time.", getBlockSTime());
			} else {
				checkBooking(startTime, endTime);
			}
		} else {
			Factory.getInstance().addErrorMessage("End time must be larger then start time.");
		}
	}

	private void checkBooking(final String startTime, final String endTime) {
		QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] {
								"booking",
								"count(1), SUM(DECODE(BKGSTS, 'F', 1, 0))",
								"schid='" + memSchID +
								"' and bkgsdate<=TO_DATE('" + endTime + "','DD/MM/YYYY HH24:MI:SS') "+
								"and bkgedate>=TO_DATE('" + startTime + "','DD/MM/YYYY HH24:MI:SS')"},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					// extra value
					try {
						int countBooking = Integer.parseInt(mQueue.getContentField()[0]);
						final int countConfirmBooking = Integer.parseInt(mQueue.getContentField()[1]);

						if (countBooking > 0) {
							Factory.getInstance().isConfirmYesNoDialog("PBA-["+getTitle()+"]",ConstantsMessage.MSG_BLOCK_CONFIRM,
									new Listener<MessageBoxEvent>() {
								public void handleEvent(MessageBoxEvent be) {
									if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
										if (countConfirmBooking > 0) {
											checkConfirmBooking(startTime, endTime, countConfirmBooking);
										} else {
											proceedBlock(startTime, endTime);
										}
									}
								}
							});
						} else {
							proceedBlock(startTime, endTime);
						}
					} catch (Exception e) {
						proceedBlock(startTime, endTime);
					}
				} else {
					proceedBlock(startTime, endTime);
				}
			}
		});
	}

	private void checkConfirmBooking(final String startTime, final String endTime, int countConfirmBooking) {
		if (countConfirmBooking > 0) {
			Factory.getInstance().isConfirmYesNoDialog("PBA-["+getTitle()+"]",
					"Confirmed appointment(s) exist, proceed for blocking ?",
					new Listener<MessageBoxEvent>() {
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						proceedBlock(startTime, endTime);
					}
				}
			});
		}
	}

	private void proceedBlock(String startTime, String endTime) {
		QueryUtil.executeMasterAction(getUserInfo(),
				"SCHEDULE_BLOCK", QueryUtil.ACTION_APPEND,
				new String[] {
						memSchID,
						startTime,
						endTime,
						getUserInfo().getUserID()
				},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				String msg = null;
				if (mQueue.success()) {
					msg = "Schedule successfully blocked.";
				} else {
					msg = "Failed to block schedule.";
				}
				Factory.getInstance().addInformationMessage(msg, "PBA - [Schedule Blocking]");
				dispose();
				post();
			}
		});
	}

	public abstract void post();

	/***************************************************************************
	* Layout Method
	**************************************************************************/

	public BasePanel getBlockPanel() {
		if (blockPanel == null) {
			blockPanel = new BasePanel();
			blockPanel.setBounds(0, 0, 360, 125);
			blockPanel.add(getBlockTopPanel(), null);
		}
		return blockPanel;
	}

	public FieldSetBase getBlockTopPanel() {
		if (blockTopPanel == null) {
			blockTopPanel = new FieldSetBase();
			blockTopPanel.setBounds(0, 0, 360, 125);
			blockTopPanel.setHeading("Blocking information");
			blockTopPanel.add(getBlockDoctorDESC(), null);
			blockTopPanel.add(getBlockDocCode(), null);
			blockTopPanel.add(getBlockDocName(), null);
			blockTopPanel.add(getBlockSTimeDESC(), null);
			blockTopPanel.add(getBlockSTime(), null);
			blockTopPanel.add(getBlockETimeDESC(), null);
			blockTopPanel.add(getBlockETime(), null);
		}
		return blockTopPanel;
	}

	public LabelBase getBlockDoctorDESC() {
		if (blockDoctorDESC == null) {
			blockDoctorDESC = new LabelBase();
			blockDoctorDESC.setText("Doctor");
			blockDoctorDESC.setBounds(5, 0, 80, 20);
		}
		return blockDoctorDESC;
	}

	public TextReadOnly getBlockDocCode() {
		if (blockDocCode == null) {
			blockDocCode = new TextReadOnly();
			blockDocCode.setBounds(90, 0, 260, 20);
		}
		return blockDocCode;
	}

	public TextReadOnly getBlockDocName() {
		if (blockDocName == null) {
			blockDocName = new TextReadOnly();
			blockDocName.setBounds(90, 25, 260, 20);
		}
		return blockDocName;
	}

	public LabelBase getBlockSTimeDESC() {
		if (blockSTimeDESC == null) {
			blockSTimeDESC = new LabelBase();
			blockSTimeDESC.setText("From Time");
			blockSTimeDESC.setBounds(5, 50, 80, 20);
		}
		return blockSTimeDESC;
	}

	public TextTime getBlockSTime() {
		if (blockSTime == null) {
			blockSTime = new TextTime();
			blockSTime.setBounds(90, 50, 260, 20);
		}
		return blockSTime;
	}

	public LabelBase getBlockETimeDESC() {
		if (blockETimeDESC == null) {
			blockETimeDESC = new LabelBase();
			blockETimeDESC.setText("To");
			blockETimeDESC.setBounds(5, 75, 80, 20);
		}
		return blockETimeDESC;
	}

	public TextTime getBlockETime() {
		if (blockETime == null) {
			blockETime = new TextTime();
			blockETime.setBounds(90, 75, 260, 20);
		}
		return blockETime;
	}
}