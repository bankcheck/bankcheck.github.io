package com.hkah.client.layout.dialog;

import java.util.HashMap;
import java.util.Map;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgEnterConfinement extends DialogBase {
	private final static int m_frameWidth = 680;
	private final static int m_frameHeight = 450;

	private BasePanel OBBookingPanel = null;
	private LabelBase OBBookingDesc = null;
	private BasePanel depositPanel = null;
	private LabelBase bookingDesc = null;
	private TextString booking = null;
	private LabelBase editedByDesc = null;
	private TextReadOnly editedBy = null;
	private LabelBase lastEditDateDesc = null;
	private TextReadOnly lastEditDate = null;
	private LabelBase bookingNameDesc = null;
	private TextReadOnly bookingName = null;
	private LabelBase slpNameDesc = null;
	private TextReadOnly slpName = null;
	private BasePanel certificatePanel = null;
	private LabelBase expectedDateDesc = null;
	private TextDate expectedDate = null;
	private LabelBase editedBy2Desc = null;
	private TextReadOnly editedBy2 = null;
	private LabelBase lastEditDate2Desc = null;
	private TextReadOnly lastEditDate2 = null;
	private LabelBase issueDateDesc = null;
	private TextReadOnly issueDate = null;
	private LabelBase printDateDesc = null;
	private TextReadOnly printDate = null;

	private String memSlipNo = null;
	private String memEDCDate = null;
	private String memOldBpbNo = null;

	public DlgEnterConfinement(MainFrame owner) {
		super(owner, YESNOCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Update and Print OB Booking");
		setContentPane(getOBBookingPanel());

    	// change label
		getButtonById(YES).setText("Update Slip", 'U');
		getButtonById(NO).setText("Print Cert", 'P');
		getButtonById(CANCEL).setText("Close", 'C');
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	public TextString getDefaultFocusComponent() {
		return getBooking();
	}

	@Override
	protected void doYesAction() {
		if (validation()) {
			if (getBooking().isEmpty()) {
				MessageBoxBase.confirm("PBA", "Booking # is missing, the link between booking & paid slip cannot be established", new Listener<MessageBoxEvent>() {
					public void handleEvent(MessageBoxEvent be) {
						if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
							updateSlip();
						}
					}
				});
			} else {
				updateSlip();
			}
		}
	}

	//for override
	protected void doOpenOBCert() {
	}

	@Override
	protected void doNoAction() {
		// UpdateFirstPrintDate
		QueryUtil.executeMasterAction(getUserInfo(), ConstantsTx.UPDATE_FIRSTPRINTDATE_TXCODE, QueryUtil.ACTION_APPEND,
				new String[] { memSlipNo },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (!mQueue.success()) {
					Factory.getInstance().addErrorMessage(mQueue);
				}
				refresh();
			}
		});
		if (YES_VALUE.equals( getMainFrame().getSysParameter("TxOBCrtPl"))) {
			doOpenOBCert();
		} else {
				// print cert
				String site = Factory.getInstance().getSysParameter("curtSite");
				String[] columnNameArray = null;
				if ("HKAH".equals(site)) {
					columnNameArray = new String[] { "HospitalNo", "PatName", "PatCName", "DOB",
							   "PatIdNo", "ExDate", "IssueDt", "EXDate60",
							   "Doccode", "husdoctype","patdoctype","docfname",
				               "docgname","docptel","docotel","hkmclicno",
				               "antchkdt1","antchkdt2","antchkdt3","antchkdt4",
				               "antchkdt5","antchkdt6","antchkdt7","antchkdt8",
				               "antchkdt9","antchkdt10","patfname","patgname",
				               // husband
				               "faCname", "husfname", "husganme", "faHkic"
					};
				} else {	// TWAH
					columnNameArray = new String[] { "HospitalNo", "PatName", "PatCName", "DOB",
							   "PatIdNo", "ExDate", "IssueDt", "EXDate60",
							   "Doccode", "husdoctype","patdoctype","docfname",
				               "docgname","docptel","docotel","hkmclicno",
				               "antchkdt1","antchkdt2","antchkdt3","antchkdt4",
				               "antchkdt5","antchkdt6","antchkdt7","antchkdt8",
				               "antchkdt9","antchkdt10","patfname","patgname"
		            };
				}

				Map<String, String> map = new HashMap<String, String>();
				map.put("SlpNo", memSlipNo);
				map.put("SUBREPORT_DIR",CommonUtil.getReportDir());
				map.put("ImgTick", CommonUtil.getReportImg("tick.gif"));
				PrintingUtil.print("", "PrintOBCert_"+site,
						map,null,
						new String[] { memSlipNo },
						columnNameArray);
		}
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String slipNo) {
		memSlipNo = slipNo;

		refresh();

		setVisible(true);
	}

	private void refresh() {
		QueryUtil.executeMasterFetch(
				getUserInfo(), ConstantsTx.OBBOOK_TXCODE, new String[] { memSlipNo },
				new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							getBooking().setText(mQueue.getContentField()[2]);
							getEditedBy().setText(mQueue.getContentField()[5]);
							getLastEditDate().setText(mQueue.getContentField()[6]);
							getBookingName().setText(mQueue.getContentField()[3]);
							getSlpName().setText(mQueue.getContentField()[0] + " " + mQueue.getContentField()[1]);
							memOldBpbNo = mQueue.getContentField()[2];

							if (mQueue.getContentField()[7].length() > 0) {
								getExpectedDate().setText(mQueue.getContentField()[7]);
								memEDCDate = mQueue.getContentField()[7];
								getIssueDate().setText(mQueue.getContentField()[9]);
								getPrintDate().setText(mQueue.getContentField()[8]);
								getEditedBy2().setText(mQueue.getContentField()[12]);
								getLastEditDate2().setText(mQueue.getContentField()[10]);

								setEnableButton();
							} else {
								setEnableButton();
							}
						}
					}
				});
	}

	private boolean validation() {
		if (!getExpectedDate().isEmpty() && !getExpectedDate().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid Date Value.", getExpectedDate());
			getExpectedDate().resetText();
			return false;
		} else {
			return true;
		}
	}

	private void updateSlip() {
		QueryUtil.executeMasterAction(
				getUserInfo(), "UPDATEOBBK", QueryUtil.ACTION_APPEND,
				new String[] { memSlipNo, getBooking().getText(), getExpectedDate().getText(), getUserInfo().getUserID() },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (!mQueue.success()) {
					Factory.getInstance().addErrorMessage(mQueue);
				}
				refresh();
			}
		});
	}

	private void resetBookingText() {
		getBooking().resetText();
		getBookingName().resetText();
	}

	private void setEnableButton() {
		getButtonById(YES).setEnabled(
				(!getBooking().getText().equals(memOldBpbNo))||
				 (!getExpectedDate().getText().equals(memEDCDate)));
		getButtonById(NO).setEnabled(!getExpectedDate().isEmpty() && getExpectedDate().isValid());
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getOBBookingPanel() {
		if (OBBookingPanel == null) {
			OBBookingPanel = new BasePanel();
			OBBookingPanel.setBounds(5, 5, 647, 400);
			OBBookingPanel.add(getOBBookingDesc(), null);
			OBBookingPanel.add(getDepositPanel(), null);
			OBBookingPanel.add(getCertificatePanel(), null);
		}
		return OBBookingPanel;
	}

	public LabelBase getOBBookingDesc() {
		if (OBBookingDesc == null) {
			OBBookingDesc = new LabelBase();
			OBBookingDesc.setBounds(10, 10, 600, 30);
			OBBookingDesc.setText("If you want to update the EDC/Booking#, please enter the values and click \"Update Slip\" button to make it effective.");
		}
		return OBBookingDesc;
	}

	public BasePanel getDepositPanel() {
		if (depositPanel == null) {
			depositPanel = new BasePanel();
			depositPanel.setBounds(10, 50, 600, 130);
			depositPanel.setHeading("Deposit");
			depositPanel.add(getBookingDesc(), null);
			depositPanel.add(getBooking(), null);
			depositPanel.add(getEditedByDesc(), null);
			depositPanel.add(getEditedBy(), null);
			depositPanel.add(getLastEditDateDesc(), null);
			depositPanel.add(getLastEditDate(), null);
			depositPanel.add(getBookingNameDesc(), null);
			depositPanel.add(getBookingName(), null);
			depositPanel.add(getSlpNameDesc(), null);
			depositPanel.add(getSlpName(), null);
		}
		return depositPanel;
	}

	public LabelBase getBookingDesc() {
		if (bookingDesc == null) {
			bookingDesc = new LabelBase();
			bookingDesc.setBounds(5, 20, 80, 20);
			bookingDesc.setText("Booking #");
		}
		return bookingDesc;
	}

	public TextString getBooking() {
		if (booking == null) {
			booking = new TextString(10, true) {
				@Override
				public void onBlur() {
					if (!booking.isEmpty()) {
						QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
								new String[] {"bedprebok b, slip s", "b.bpbno,b.bpbpname,TO_CHAR(b.bpbhdate,'DD/MM/YYYY'),s.slpno", "b.bpbno=s.bpbno (+) AND b.bpbno = '" + booking.getText() + "'"},
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success() && mQueue.getContentField()[0].length() > 0) {
									getBookingName().setText(mQueue.getContentField()[1]);
									//if (getExpectedDate().isEmpty()) {
										getExpectedDate().setText(mQueue.getContentField()[2]);
									//}

									if (memOldBpbNo != null && memOldBpbNo.length() > 0 && !booking.getText().equals(memOldBpbNo)) {
										 booking.resetText();
										 Factory.getInstance().addErrorMessage("Booking# already linked, please type another booking#.", booking);
									}

									setEnableButton();
								} else {
									resetBookingText();
									setEnableButton();

									Factory.getInstance().addErrorMessage("Invalid Booking #.", booking);
								}
							}
						});
					} else {
						resetBookingText();
						setEnableButton();
					}
				}
			};
			booking.setBounds(5, 45, 80, 20);
		}
		return booking;
	}

	public LabelBase getEditedByDesc() {
		if (editedByDesc == null) {
			editedByDesc = new LabelBase();
			editedByDesc.setBounds(90, 20, 300, 20);
			editedByDesc.setText("Edited By");
		}
		return editedByDesc;
	}

	public TextReadOnly getEditedBy() {
		if (editedBy == null) {
			editedBy = new TextReadOnly();
			editedBy.setBounds(90, 45, 300, 20);
		}
		return editedBy;
	}

	public LabelBase getLastEditDateDesc() {
		if (lastEditDateDesc == null) {
			lastEditDateDesc = new LabelBase();
			lastEditDateDesc.setBounds(400, 20,180, 20);
			lastEditDateDesc.setText("Last Edit Date");
		}
		return lastEditDateDesc;
	}

	public TextReadOnly getLastEditDate() {
		if (lastEditDate == null) {
			lastEditDate = new TextReadOnly();
			lastEditDate.setBounds(400, 45,180, 20);
		}
		return lastEditDate;
	}

	public LabelBase getBookingNameDesc() {
		if (bookingNameDesc == null) {
			bookingNameDesc = new LabelBase();
			bookingNameDesc.setBounds(5, 70, 110, 20);
			bookingNameDesc.setText("Booking Name");
		}
		return bookingNameDesc;
	}

	public TextReadOnly getBookingName() {
		if (bookingName == null) {
			bookingName = new TextReadOnly();
			bookingName.setBounds(5, 95, 230, 20);
		}
		return bookingName;
	}

	public LabelBase getSlpNameDesc() {
		if (slpNameDesc == null) {
			slpNameDesc = new LabelBase();
			slpNameDesc.setBounds(250, 70, 80, 20);
			slpNameDesc.setText("Slip Name");
		}
		return slpNameDesc;
	}

	public TextReadOnly getSlpName() {
		if (slpName == null) {
			slpName = new TextReadOnly();
			slpName.setBounds(250, 95, 331, 20);
		}
		return slpName;
	}

	public BasePanel getCertificatePanel() {
		if (certificatePanel == null) {
			certificatePanel = new BasePanel();
			certificatePanel.setStyleAttribute("margin-top", "5px");
			certificatePanel.setBounds(10, 180, 600, 150);
			certificatePanel.setHeading("Certificate");
			certificatePanel.add(getExpectedDateDesc(), null);
			certificatePanel.add(getExpectedDate(), null);
			certificatePanel.add(getEditedBy2Desc(), null);
			certificatePanel.add(getEditedBy2(), null);
			certificatePanel.add(getLastEditDate2Desc(), null);
			certificatePanel.add(getLastEditDate2(), null);
			certificatePanel.add(getIssueDateDesc(), null);
			certificatePanel.add(getIssueDate(), null);
			certificatePanel.add(getPrintDateDesc(), null);
			certificatePanel.add(getPrintDate(), null);
		}
		return certificatePanel;
	}

	public LabelBase getExpectedDateDesc() {
		if (expectedDateDesc == null) {
			expectedDateDesc = new LabelBase();
			expectedDateDesc.setText("<html>Expected Date<br> of Confinement</html>");
			expectedDateDesc.setBounds(5, 20, 110, 40);
		}
		return expectedDateDesc;
	}

	public TextDate getExpectedDate() {
		if (expectedDate == null) {
			//expectedDate = new TextString();
			expectedDate = new TextDate() {
				@Override
				public void onBlur() {
					setEnableButton();
				}

				@Override
				protected void onReleased() {
					onBlur();
				}
			};
			expectedDate.setBounds(5, 65, 100, 20);
		}
		return expectedDate;
	}

	public LabelBase getEditedBy2Desc() {
		if (editedBy2Desc == null) {
			editedBy2Desc = new LabelBase();
			editedBy2Desc.setText("Edited By");
			editedBy2Desc.setBounds(110, 40, 280, 20);
		}
		return editedBy2Desc;
	}

	public TextReadOnly getEditedBy2() {
		if (editedBy2 == null) {
			editedBy2 = new TextReadOnly();
			editedBy2.setBounds(110, 65, 280, 20);
		}
		return editedBy2;
	}

	public LabelBase getLastEditDate2Desc() {
		if (lastEditDate2Desc == null) {
			lastEditDate2Desc = new LabelBase();
			lastEditDate2Desc.setText("Last Edit Date");
			lastEditDate2Desc.setBounds(400, 40, 180, 20);
		}
		return lastEditDate2Desc;
	}

	public TextReadOnly getLastEditDate2() {
		if (lastEditDate2 == null) {
			lastEditDate2 = new TextReadOnly();
			lastEditDate2.setBounds(400, 65, 180, 20);
		}
		return lastEditDate2;
	}

	public LabelBase getIssueDateDesc() {
		if (issueDateDesc == null) {
			issueDateDesc = new LabelBase();
			issueDateDesc.setText("Issue Date");
			issueDateDesc.setBounds(5, 90, 100, 20);
		}
		return issueDateDesc;
	}

	public TextReadOnly getIssueDate() {
		if (issueDate == null) {
			issueDate = new TextReadOnly();
			issueDate.setBounds(5, 115, 100, 20);
		}
		return issueDate;
	}

	public LabelBase getPrintDateDesc() {
		if (printDateDesc == null) {
			printDateDesc = new LabelBase();
			printDateDesc.setText("1st Print Date");
			printDateDesc.setBounds(110, 90, 100, 20);
		}
		return printDateDesc;
	}

	public TextReadOnly getPrintDate() {
		if (printDate == null) {
			printDate = new TextReadOnly();
			printDate.setBounds(110, 115, 100, 20);
		}
		return printDate;
	}
}