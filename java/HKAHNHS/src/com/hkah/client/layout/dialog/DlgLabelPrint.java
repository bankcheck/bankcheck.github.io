package com.hkah.client.layout.dialog;

import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.shared.constants.ConstantsMessage;

public abstract class DlgLabelPrint extends DialogBase implements ConstantsMessage {
	private final static int m_frameWidth = 400;
	private final static int m_frameHeight = 210;

	private BasePanel infoDailogPanel = null;
	private LabelBase infoDESC1 = null;
	private LabelBase infoDESC2 = null;
	private LabelBase infoDESC3 = null;
	private LabelBase walkInDESC = null;
	private LabelBase curBKID = null;
	private CheckBoxBase walkIn = null;
	private LabelBase homeVisitDESC = null;
	private CheckBoxBase homeVisit = null;
	private String memDocCode = null;
	private String memDocName = null;
	private String currDate = getMainFrame().getServerDate();

	public DlgLabelPrint(MainFrame owner) {
		super(owner, YESNOCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Information");
		setContentPane(getInfoDailogPanel());

		// change label
		getButtonById(YES).setText("OK", 'O');
		getButtonById(NO).setText("Print Call Chart Label");
		getButtonById(CANCEL).setWidth(150);
		getButtonById(CANCEL).setText("Print Appointment Label");
		getButtonById(NO).setEnabled(false);

		setPosition(300, 100);

		setVisible(true);
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/
	public void showDialog(String patno, String docCode, String docName, boolean showDesc2, boolean showDesc3,
			String desc3, boolean showHomeVisit, boolean isChanged, String appDate) {
			showDialog(patno, docCode ,docName, showDesc2, showDesc3, desc3, showHomeVisit,
						isChanged, true, null, true, appDate);
	}

	public void showDialog(String patno, String docCode, String docName, boolean showDesc2, boolean showDesc3,
							String desc3, boolean showHomeVisit, boolean isChanged,
							boolean isCallChtEnable, String isPaper, boolean creatNewVol, String appDate) {
		getWalkIn().reset();
		getHomeVisit().reset();
		memDocCode = docCode;
		memDocName = docName;

//		getButtonById(NO).setEnabled(patno != null && patno.length() > 0
//				&& !Factory.getInstance().isDisableFunction("btnPrintChartLabel", "regPatReg")
//				&& isCallChtEnable);
		getButtonById(NO).setEnabled(patno != null && patno.length() > 0
				&& !Factory.getInstance().isDisableFunction("btnPrintChartLabel", "regPatReg")
				&& "1".equals(isPaper)
				&& DateTimeUtil.compareTo(currDate, getDate(appDate.toString(), 10)) == 0
				&& !(HKAH_VALUE.equals(getUserInfo().getSiteCode()) && ("PBOG".equals(docCode) || "PBOR".equals(docCode))));

		getInfoDESC2().setVisible(showDesc2);
		getInfoDESC3().setVisible(showDesc3);

		if (desc3 != null) {
			if ("1".equals(isPaper)) {
				getInfoDESC3().setText(desc3);
				if (!isCallChtEnable) {
					getInfoDESC3().setStyleAttribute("background-color", "yellow");
				}
			} else {
				if ("11".equals((isPaper)) && "HKAH".equals(getUserInfo().getSiteCode())){
					getInfoDESC3().setText("PLEASE CHANGE MEDIA TYPE FROM TEMP TO PAPER AS VOL.1 (NEW CHART)");
				} else if (creatNewVol) {
					getInfoDESC3().setText("PLEASE CREATE A NEW VOLUME.");
				} else {
					getInfoDESC3().setText(desc3);
				}
			}
		} else {
			getInfoDESC3().setText("OPD FRONT DESK(PAPER)");
		}

		if (showHomeVisit) {
			getWalkInDESC().setBounds(55, 100, 80, 20);
			getWalkIn().setBounds(120, 100, 20, 20);
			getHomeVisitDESC().setVisible(true);
			getHomeVisit().setVisible(true);
		} else {
			getWalkInDESC().setBounds(135, 100, 80, 20);
			getWalkIn().setBounds(200, 100, 20, 20);
			getHomeVisitDESC().setVisible(false);
			getHomeVisit().setVisible(false);
		}

		if (isChanged) {
			getInfoDESC1().setText(MSG_BOOKING_CHANGED + "(" + getDocCode() + ")");
		} else {
			getInfoDESC1().setText(MSG_BOOKING_MADE + "(" + getDocCode() + ")");
		}

		setVisible(true);
	}

	// paper priority
	public void showDialog(String patno, boolean showDesc2, boolean showDesc3, String desc3, String isPaper, boolean showHomeVisit) {
		getWalkIn().reset();
		getHomeVisit().reset();

		getButtonById(NO).setEnabled(patno != null && patno.length() > 0 && !Factory.getInstance().isDisableFunction("btnPrintChartLabel", "regPatReg")&&"1".equals(isPaper));

		getInfoDESC2().setVisible(showDesc2);
		getInfoDESC3().setVisible(showDesc3);

		if (desc3 != null) {
			getInfoDESC3().setText(desc3);
		} else {
			getInfoDESC3().setText("OPD FRONT DESK(PAPER)");
		}

		if (showHomeVisit) {
			getWalkInDESC().setBounds(55, 100, 80, 20);
			getWalkIn().setBounds(120, 100, 20, 20);
			getHomeVisitDESC().setVisible(true);
			getHomeVisit().setVisible(true);
		} else {
			getWalkInDESC().setBounds(135, 100, 80, 20);
			getWalkIn().setBounds(200, 100, 20, 20);
			getHomeVisitDESC().setVisible(false);
			getHomeVisit().setVisible(false);
		}

		setVisible(true);
	}

	public String getDocCode() {
		return memDocCode;
	}

	public String getDocName() {
		return memDocName;
	}

	private String getDate(String date, int len) {
		return date.substring(0, len);
	}

	/***************************************************************************
	 * @Override Method
	 **************************************************************************/

	@Override
	protected void doYesAction() {
		dispose();
	}

	@Override
	protected void doNoAction() {
		doPrintCCL();
	}

	@Override
	protected void doCancelAction() {
		doPrintAppLbl();
	}

	/***************************************************************************
	 * Abstract Method
	 **************************************************************************/

	public abstract void doPrintCCL();

	public abstract void doPrintAppLbl();

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getInfoDailogPanel() {
		if (infoDailogPanel == null) {
			infoDailogPanel = new BasePanel();
			infoDailogPanel.setTitledBorder();
			infoDailogPanel.setSize(370, 130);
			infoDailogPanel.add(getInfoDESC1(), null);
			infoDailogPanel.add(getInfoDESC2(), null);
			infoDailogPanel.add(getInfoDESC3(), null);
			infoDailogPanel.add(getWalkInDESC(), null);
			infoDailogPanel.add(getWalkIn(), null);
			infoDailogPanel.add(getHomeVisitDESC(), null);
			infoDailogPanel.add(getHomeVisit(), null);
		}
		return infoDailogPanel;
	}

	public LabelBase getInfoDESC1() {
		if (infoDESC1 == null) {
			infoDESC1 = new LabelBase();
			infoDESC1.setText(MSG_BOOKING_MADE);
			infoDESC1.setBounds(95, 5, 200, 20);
		}
		return infoDESC1;
	}

	public LabelBase getInfoDESC2() {
		if (infoDESC2 == null) {
			infoDESC2 = new LabelBase();
			infoDESC2.setText("Medical Chart Current Location:");
			infoDESC2.setBounds(95, 40, 250, 20);
		}
		return infoDESC2;
	}

	public LabelBase getInfoDESC3() {
		if (infoDESC3 == null) {
			infoDESC3 = new LabelBase();
			infoDESC3.setBounds(105, 65, 250, 20);
		}
		return infoDESC3;
	}

	public LabelBase getWalkInDESC() {
		if (walkInDESC == null) {
			walkInDESC = new LabelBase();
			walkInDESC.setText("Walk-In");
			walkInDESC.setBounds(55, 100, 80, 20);
		}
		return walkInDESC;
	}

	public CheckBoxBase getWalkIn() {
		if (walkIn == null) {
			walkIn = new CheckBoxBase() {
				public void onClick() {
					getHomeVisit().reset();
					super.onClick();
				}
			};
			walkIn.setBounds(120, 100, 20, 20);
		}
		return walkIn;
	}

	public LabelBase getHomeVisitDESC() {
		if (homeVisitDESC == null) {
			homeVisitDESC = new LabelBase();
			homeVisitDESC.setText("Home Visit");
			homeVisitDESC.setBounds(205, 100, 80, 20);
		}
		return homeVisitDESC;
	}

	public CheckBoxBase getHomeVisit() {
		if (homeVisit == null) {
			homeVisit = new CheckBoxBase() {
				public void onClick() {
					getWalkIn().reset();
					super.onClick();
				}
			};
			homeVisit.setBounds(290, 100, 20, 20);
		}
		return homeVisit;
	}

	public LabelBase getCurBKID() {
		if (curBKID == null) {
			curBKID = new LabelBase();
			curBKID.setVisible(false);
		}
		return curBKID;
	}
}