package com.hkah.client.layout.dialog;

import java.util.HashMap;
import java.util.Map;
import java.util.logging.Logger;

import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.combobox.ComboPickListOrderBy;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextDateTimeWithoutSecond;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.util.PrintingUtil;

public class DlgRptBookingList extends DialogBase {

	private static final long serialVersionUID = 1L;
	protected static Logger logger = Logger.getLogger(DlgRptBookingList.class.getName());

	private BasePanel paraPanel = null;
	private BasePanel panel = null;
	private LabelBase bookingDate = null;
	private TextDate bookingDateDesc = null;
	private LabelBase fromTime = null;
	private TextString fromTimeDesc = null;
	private LabelBase toTime = null;
	private TextString toTimeDesc = null;
	private LabelBase capture = null;
	private TextDateTimeWithoutSecond captureDesc = null;
	private LabelBase doctorCode = null;
	private TextString doctorCodeDesc = null;
	private BasePanel ListPanel = null;
	private ButtonBase print = null;
	private LabelBase orderByDesc = null;
	private ComboPickListOrderBy orderBy = null;

	private ButtonBase cancel = null;
	boolean isasterisk = "YES".equals(getMainFrame().getSysParameter("Chk*"));
	boolean isChkDigit = "YES".equals(getMainFrame().getSysParameter("ChkDigit"));

	/**
	* This method initializes
	*
	*/
	public DlgRptBookingList(MainFrame owner) {
		super(owner,580, 280);
		initialize();
		afterInit();
		this.setVisible(true);
	}

	private void initialize() {
		this.setContentPane(getParaPanel());
	}

	protected void afterInit() {
		this.setTitle("Print Booking List Report");
		if (Factory.getInstance().getSysParameter("PICKLBLORD").length() > 0) {
			getOrderBy().setSelectedIndex(Factory.getInstance().getSysParameter("PICKLBLORD"));
		}
	}

	public void showDialog() {
		getBookingDateDesc().resetText();
		getFromTimeDesc().resetText();
		getToTimeDesc().resetText();
		getDoctorCodeDesc().resetText();
		if (Factory.getInstance().getSysParameter("PICKLBLORD").length() > 0) {
			getOrderBy().setSelectedIndex(Factory.getInstance().getSysParameter("PICKLBLORD"));
		}
		show();
	}

	private boolean printReceipt() {
		String toTime = getToTimeDesc().getText().length()==0?"23:59":getToTimeDesc().getText();

		Map<String, String> map = new HashMap<String, String>();

		if (getBookingDateDesc().getText().length()==0) {
			Factory.getInstance().addErrorMessage("Please supply Booking Date.");
			getBookingDateDesc().focus();
			return false;
		}

		map.put("CAPTDATE", getCaptureDesc().getText());
		map.put("BOOKINGDATE", getBookingDateDesc().getText());
		map.put("DOCCODE", getDoctorCodeDesc().getText());

		PrintingUtil.print(getMainFrame().getSysParameter("PRTRLBL"),
							"BookingListLabel",
							map, null,
							new String[] {
									getBookingDateDesc().getText() + "+" + getFromTimeDesc().getText().trim(),
									getBookingDateDesc().getText() + "+" + toTime,
									getCaptureDesc().getText(),
									getDoctorCodeDesc().getText(),
									getOrderBy().getText()
							},
							new String[] {
									"DOCNAME", "BPBHDATE", "PATNO", "PATNAME",
									"WARD", "LOC", "VOLNUM"
							});

		return true;
	}

	public BasePanel getParaPanel() {
		if (paraPanel == null) {
			paraPanel = new BasePanel();
			paraPanel.add(getPanel(), null);
			paraPanel.add(getListPanel(), null);
		}
		return paraPanel;
	}

	public BasePanel getPanel() {
		if (panel == null) {
			panel = new BasePanel();
			panel.setBounds(15, 8, 512, 432);
			panel.add(getDoctorCode(), null);
			panel.add(getBookingDate(), null);
			panel.add(getBookingDateDesc(), null);
			panel.add(getDoctorCodeDesc(), null);
			panel.add(getFromTime(), null);
			panel.add(getFromTimeDesc(), null);
			panel.add(getToTime(), null);
			panel.add(getToTimeDesc(), null);
			panel.add(getCapture(), null);
			panel.add(getCaptureDesc(), null);
			panel.add(getOrderByDesc(), null);
			panel.add(getOrderBy(), null);
		}
		return panel;
	}

	public LabelBase getBookingDate() {
		if (bookingDate == null) {
			bookingDate = new LabelBase();
			bookingDate.setText("<html>Booking Date:<br>(dd/mm/yyyy)</html>");
			bookingDate.setBounds(18, 20, 120, 30);
		}
		return bookingDate;
	}

	public TextDate getBookingDateDesc() {
		if (bookingDateDesc == null) {
			bookingDateDesc = new TextDate();
			bookingDateDesc.setBounds(130, 25, 120, 20);
		}
		return bookingDateDesc;
	}

	public LabelBase getFromTime() {
		if (fromTime == null) {
			fromTime = new LabelBase();
			fromTime.setText("<html>From:<br>(hh:mm)<br>(optional)</html>");
			fromTime.setBounds(255, 19, 54, 45);
		}
		return fromTime;
	}

	public TextString getFromTimeDesc() {
		if (fromTimeDesc == null) {
			fromTimeDesc = new TextString();
			fromTimeDesc.setBounds(315, 24, 60, 20);
		}
		return fromTimeDesc;
	}

	public LabelBase getToTime() {
		if (toTime == null) {
			toTime = new LabelBase();
			toTime.setText("<html>To:<br>(hh:mm)<br>(optional)</html>");
			toTime.setBounds(385, 21, 54, 45);
		}
		return toTime;
	}

	public TextString getToTimeDesc() {
		if (toTimeDesc == null) {
			toTimeDesc = new TextString();
			toTimeDesc.setBounds(445, 26, 60, 20);
		}
		return toTimeDesc;
	}

	public LabelBase getCapture() {
		if (capture == null) {
			capture = new LabelBase();
			capture.setText("<html>Capture Date<br>(dd/mm/yyy hh:mm)<br>(optional)</html>");
			capture.setBounds(18, 80, 120, 48);
		}
		return capture;
	}

	public TextDateTimeWithoutSecond getCaptureDesc() {
		if (captureDesc == null) {
			captureDesc = new TextDateTimeWithoutSecond();
			captureDesc.setBounds(130, 80, 120, 20);
		}
		return captureDesc;
	}

	public LabelBase getDoctorCode() {
		if (doctorCode == null) {
			doctorCode = new LabelBase();
			doctorCode.setText("<html>Doctor Code<br>(optional)</html>");
			doctorCode.setBounds(18, 140, 120, 35);
		}
		return doctorCode;
	}

	public TextString getDoctorCodeDesc() {
		if (doctorCodeDesc == null) {
			doctorCodeDesc = new TextString();
			doctorCodeDesc.setBounds(130, 140, 110, 20);
		}
		return doctorCodeDesc;
	}

	public LabelBase getOrderByDesc() {
		if (orderByDesc == null) {
			orderByDesc = new LabelBase();
			orderByDesc.setText("Order by:");
			orderByDesc.setBounds(250, 140, 55, 35);
		}
		return orderByDesc;
	}

	public ComboPickListOrderBy getOrderBy() {
		if (orderBy == null) {
			orderBy = new ComboPickListOrderBy();
			orderBy.setBounds(310, 140, 130, 20);
		}
		return orderBy;
	}

	private BasePanel getListPanel() {
		if (ListPanel == null) {
			ListPanel = new BasePanel();
			ListPanel.setBounds(15, 180, 512, 55);
			ListPanel.add(getPrint(), null);
			ListPanel.add(getCancel(), null);
		}
		return ListPanel;
	}

	private ButtonBase getPrint() {
		if (print == null) {
			print = new ButtonBase() {
				@Override
				public void onClick() {
					if (printReceipt()) {
						dispose();
					}
				}
			};
			print.setBounds(150, 12, 75, 30);
			print.setText("Print");
		}
		return print;
	}

	private ButtonBase getCancel() {
		if (cancel == null) {
			cancel = new ButtonBase() {
				@Override
				public void onClick() {
					dispose();
				}
			};
			cancel.setBounds(280, 12, 75, 30);
			cancel.setText("Cancel");
		}
		return cancel;
	}
}
