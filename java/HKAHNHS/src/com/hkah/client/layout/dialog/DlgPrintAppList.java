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
import com.hkah.client.layout.textfield.TextDoctorSearch;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.util.PrintingUtil;

public class DlgPrintAppList extends DialogBase {

	private static final long serialVersionUID = 1L;
	protected static Logger logger = Logger.getLogger(DlgPrintAppList.class.getName());

	private BasePanel paraPanel = null;
	private BasePanel panel = null;
	private LabelBase bookingDateFromDesc = null;
	private TextDate bookingDateFrom = null;
	private LabelBase bookingDateToDesc = null;
	private TextDate bookingDateTo = null;
	private LabelBase drCodeDesc = null;
	private TextDoctorSearch  drCode = null;
	private BasePanel ListPanel = null;
	private ButtonBase print = null;


	private ButtonBase cancel = null;
	
	private String spcCode = null;

	/**
	* This method initializes
	*
	*/
	public DlgPrintAppList(MainFrame owner) {
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
	}

	public void showDialog() {
		getBookingDateFrom().resetText();
		getBookingDateTo().resetText();
		spcCode = getUserInfo().getOtherCode();
		show();
	}

	public boolean printRpt() {

		Map<String, String> map = new HashMap<String, String>();

		if (getBookingDateFrom().getText().length()==0) {
			Factory.getInstance().addErrorMessage("Please supply Booking Date.");
			getBookingDateFrom().focus();
			return false;
		}


		map.put("BOOKINGDATEFROM", getBookingDateFrom().getText());
		map.put("BOOKINGDATETO", getBookingDateTo().getText());
		map.put("SiteName", getUserInfo().getSiteName());
		map.put("SPEC", getUserInfo().getOtherCode());



		PrintingUtil.print("SPCAPPLISTING",
							map, null,
							new String[] {
									getBookingDateFrom().getText(),
									getBookingDateTo().getText(),
									spcCode,
									getUserInfo().getUserID()
							},
							new String[] {
									"BKGDATE","DOCNAME", "PATNO", "DENTALNO", 
									"BKGPNAME","PATBDATE", "BKGMTEL","BKGRMK"
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
			panel.setBounds(15, 8, 512, 100);
			panel.add(getBookingDateFromDesc(), null);
			panel.add(getBookingDateFrom(), null);
			panel.add(getBookingDateToDesc(), null);
			panel.add(getBookingDateTo(), null);
			panel.add(getDrCodeDesc(), null);
			panel.add(getDrCode(), null);
		}
		return panel;
	}

	public LabelBase getBookingDateFromDesc() {
		if (bookingDateFromDesc == null) {
			bookingDateFromDesc = new LabelBase();
			bookingDateFromDesc.setText("<html>Booking Date:<br>(dd/mm/yyyy)</html>");
			bookingDateFromDesc.setBounds(18, 20, 120, 30);
		}
		return bookingDateFromDesc;
	}

	public TextDate getBookingDateFrom() {
		if (bookingDateFrom == null) {
			bookingDateFrom = new TextDate();
			bookingDateFrom.setBounds(130, 25, 120, 20);
		}
		return bookingDateFrom;
	}
	
	public LabelBase getBookingDateToDesc() {
		if (bookingDateToDesc == null) {
			bookingDateToDesc = new LabelBase();
			bookingDateToDesc.setText(" To ");
			bookingDateToDesc.setBounds(255, 20, 54, 45);
		}
		return bookingDateToDesc;
	}

	public TextDate getBookingDateTo() {
		if (bookingDateTo == null) {
			bookingDateTo = new TextDate();
			bookingDateTo.setBounds(315, 25, 120, 20);
		}
		return bookingDateTo;
	}
	
	public LabelBase getDrCodeDesc() {
		if (drCodeDesc == null) {
			drCodeDesc = new LabelBase();
			drCodeDesc.setText("Doctor");
			drCodeDesc.setBounds(18, 60, 54, 20);
			drCodeDesc.setEnabled(false);
		}
		return drCodeDesc;
	}
	
	public TextDoctorSearch getDrCode() {
		if (drCode == null) {
			drCode = new TextDoctorSearch() {
				@Override
				public void checkTriggerBySearchKey() {
					if (!getText().isEmpty() && (getText().indexOf("%") > -1 || getText().indexOf(",") > -1)) {
						checkTriggerBySearchKeyPost();
					} else {
						super.checkTriggerBySearchKey();
					}
				}

			};
			drCode.setShowClearButton(true);
			drCode.setBounds(130, 60, 130, 20);
			drCode.setEnabled(false);
		}
		return drCode;
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
					if (printRpt()) {
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
