package com.hkah.client.layout.dialog;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.Report;

public class DlgEcgQueueReport extends DialogBase {

    private final static int m_frameWidth = 380;
    private final static int m_frameHeight = 276;

    private BasePanel panel = null;
	private LabelBase ECGQueueFromDesc = null;
	private TextDate ECGQueueFrom = null;
	private LabelBase ECGQueueToDesc = null;
	private TextDate ECGQueueTo = null;
	
	private Date fromDate = DateTimeUtil.parseDateTime(getMainFrame().getServerDateTime());
	private Date toDate = DateTimeUtil.parseDateTime(getMainFrame().getServerDateTime());
	/**
	 * This method initializes
	 *
	 */
	public DlgEcgQueueReport(MainFrame owner) {
		super(owner, OKCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Please input the sent date");
		setContentPane(getPanel());
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(final String actionType, String patNo) {
		setVisible(true);
	}

	@Override
	public TextDate getDefaultFocusComponent() {
		return getECGQueueFrom();
	}

	@Override
	protected void doOkAction() {
		dispose();
		
		Date fromDate = DateTimeUtil.parseDateTime(getMainFrame().getServerDateTime());
		String pFromDate = DateTimeUtil.formatDate(fromDate);
		String pToDate = DateTimeUtil.formatDate(toDate);
		Map<String, String> map = new HashMap<String, String>();

		pFromDate = getECGQueueFrom().getText();
		pToDate = getECGQueueTo().getText();

		map.put("in_sitename", getUserInfo().getSiteName());
		map.put("in_fromdate", pFromDate);
		map.put("in_todate", pToDate);
		
		Report.print(Factory.getInstance().getUserInfo(), "RptECG2OPD",
				map,
				new String[] {pFromDate, pToDate},				
				new String[] {"XRGID",
						"XRGDATE",
						"XRGSNDDATE",
						"XJBNO",
						"DOCCODE",
						"XJBTLOC",
						"XJBTLOCDESC",
						"STNDESC",
						"PATNO",
						"PATNAME",
						"DOCNAME"}, true);
	}

	@Override
	protected void doCancelAction() {
		post();
	}

	protected void post() {
		dispose();
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
			panel.add(getECGQueueFromDesc(), null);
			panel.add(getECGQueueFrom(), null);
			panel.add(getECGQueueToDesc(), null);
			panel.add(getECGQueueTo(), null);
		}
		return panel;
	}

	
	// 
	private LabelBase getECGQueueFromDesc() {
		if (ECGQueueFromDesc == null) {
			ECGQueueFromDesc = new LabelBase();
			ECGQueueFromDesc.setBounds(23, 18, 100, 20);
			ECGQueueFromDesc.setText("From Date");
		}
		return ECGQueueFromDesc;
	}

	private TextDate getECGQueueFrom() {		
		if (ECGQueueFrom == null) {
			ECGQueueFrom = new TextDate();
			ECGQueueFrom.setBounds(93, 18, 235, 20);
			ECGQueueFrom.setText(DateTimeUtil.formatDate(fromDate));
		}
		return ECGQueueFrom;
	}
	
	private LabelBase getECGQueueToDesc() {
		if (ECGQueueToDesc == null) {
			ECGQueueToDesc = new LabelBase();
			ECGQueueToDesc.setBounds(23, 45, 100, 20);
			ECGQueueToDesc.setText("To Date");
		}
		return ECGQueueToDesc;
	}

	private TextDate getECGQueueTo() {
			if (ECGQueueTo == null) {
			ECGQueueTo = new TextDate();
			ECGQueueTo.setBounds(93, 45, 235, 20);
			ECGQueueTo.setText(DateTimeUtil.formatDate(toDate));
		}
		return ECGQueueTo;
	}

}