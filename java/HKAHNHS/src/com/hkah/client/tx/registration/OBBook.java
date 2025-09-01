package com.hkah.client.tx.registration;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MenuEvent;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.event.SelectionListener;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.form.TextField;
import com.extjs.gxt.ui.client.widget.menu.Menu;
import com.extjs.gxt.ui.client.widget.menu.MenuItem;
import com.hkah.client.Resources;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.combobox.ComboBookType;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.combobox.ComboDeposit;
import com.hkah.client.layout.combobox.ComboSortPatStatPrePara;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.line.Line;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.panel.TabbedPaneBase;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextDoctorSearch;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.SearchPanel;
import com.hkah.client.tx.ot.OTAppointmentBrowse;
import com.hkah.client.tx.transaction.SlipSearch;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.PanelUtil;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class OBBook extends SearchPanel {

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.OBBOOK_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.OBBOOK_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] { "", "Status", "Booking #", "Patient No",
				"Patient Name", "Chi. Name", "Ordered By", "", "", "Class",
				"Ward", "Schd Adm Date", //11
				"EDC","Rmk", //13
				"", "", "Order Date", "Created By","*BE", //18
				"PBO Remark", "Document #", "Contract Phone No.",
				"Patient Mobile Phone", "OT Procedure", "Surgery time",
				"Cath Lab Remark", "Slip No", "Edit By", "Edit Date", "ISREFUSED", "PBPID", //30
				"USRID", "EDITUSER", "BPBTYPE", "DOCCODE", "FORDELIVERY", "PATFNAME", "PATGNAME", "OBBOOKID" };
	}
	
	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] { 0, 40, 70, 60, 120,
						80, 130, 0, 0, 50, 40, 110,
						80,60,
						0,0, 70, 120,
						(HKAH_VALUE.equals(getUserInfo().getSiteCode()))?60:0,//BE 18
						150, 80, 105, 110, 150, 130, 120, 80, 120, 70,
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
	}

	private BasePanel searchPanel = null;

	private TabbedPaneBase TabbedPane = null;
	private BasePanel OBBookPanel = null;

	private LabelBase RemarkDesc = null;
	private LabelBase ExpDateDesc = null;
	private TextDate ExpDate = null;
	private ButtonBase Check = null;
	private BasePanel OBBookStatPanel = null;
	private LabelBase BookLimitsDesc = null;
	private LabelBase CurBookDesc = null;
	private LabelBase CurWaitDesc = null;
	private LabelBase InproBookDesc = null;
	private LabelBase InproWaitDesc = null;
	private LabelBase AvailableDesc = null;
	private Line hp1 = null;
	private Line hp2 = null;
	private LabelBase MonthDesc = null;
	private LabelBase DayDesc = null;
	private LabelBase Month1Desc = null;
	private LabelBase YearDesc = null;
	private LabelBase MainlandCitizenDesc = null;
	private LabelBase MainlandCitizen1Desc = null;
	private LabelBase NoMainlandCitizenDesc = null;
	private LabelBase NoMainlandCitizen1Desc = null;
	private LabelBase TotalDesc = null;
	private LabelBase Total1Desc = null;

	private LabelBase MonBL = null;

	private LabelBase monMainlandCitizenBL = null;
	private LabelBase yearMainlandCitizenBL = null;
	private LabelBase monNoMainlandCitizenBL = null;
	private LabelBase yearNoMainlandCitizenBL = null;
	private LabelBase monTotalBL = null;
	private LabelBase yearTotalBL = null;

	private LabelBase MonCB = null;
	private LabelBase MonCW = null;
	private LabelBase MonIPB = null;
	private LabelBase MonIPW = null;
	private LabelBase MonA = null;
	private LabelBase DayBL = null;
	private LabelBase DayCB = null;
	private LabelBase DayCW = null;
	private LabelBase DayIPB = null;
	private LabelBase DayIPW = null;
	private LabelBase DayA = null;

	private LabelBase PatientNoDesc = null;
	private LabelBase PatientNo = null;
	private LabelBase PatientNameDesc = null;
	private LabelBase PatientName = null;
	private ButtonBase SelPatProfile = null;
	private ButtonBase CreOBBook = null;
	private ButtonBase Clear = null;
	private ButtonBase searchCertBtn = null;
	private LabelBase FootRemarkDesc = null;

	private BasePanel OBPreBookPanel = null;
	private BasePanel OBPreBookParaPanel = null;
	private LabelBase PrePatientNoDesc = null;
	private TextPatientNoSearch PrePatientNo = null;
	private LabelBase PreDocDesc = null;
	private TextString PreDoc = null;
	private LabelBase PreNameDesc = null;
	private TextString PreName = null;
	private LabelBase PreChiNameDesc = null;
	private TextString PreChiName = null;
	private LabelBase PreDrCodeDesc = null;
	private TextDoctorSearch PreDrCode = null;
	private LabelBase PreDrNameDesc = null;
	private TextString PreDrName = null;
	private LabelBase PreBookTypeDesc = null;
	private ComboBookType PreBookType = null;
	private LabelBase PreSortByDesc = null;
	private ComboSortPatStatPrePara PreSortBy = null;
	private LabelBase PreSchdADateFromDesc = null;
	private TextDate PreSchdADateFrom = null;
	private LabelBase PreSchdADateToDesc = null;
	private TextDate PreSchdADateTo = null;
	private LabelBase PreDepositDesc = null;
	private ComboDeposit PreDeposit = null;
	private LabelBase PreShowCancelDesc = null;
	private ComboBoxBase PreShowCancel = null;
	private LabelBase PreOrdDateFromDesc = null;
	private TextDate PreOrdDateFrom = null;
	private LabelBase PreOrdDateToDesc = null;
	private TextDate PreOrdDateTo = null;
	private LabelBase EDCDateFromDesc = null;
	private TextDate EDCDateFrom = null;
	private LabelBase EDCDateToDesc = null;
	private TextDate EDCDateTo = null;

	private ButtonBase PreIPReg = null;
	private ButtonBase PreOTAB = null;
	private ButtonBase PrePBL = null;
	private ButtonBase PrePSL = null;
	private LabelBase PreCountDesc = null;
	private TextReadOnly PreCount = null;

	private JScrollPane bookingScrollPanel = null;

	private LabelBase obBokStatusDesc;

	private Menu contextMenu = null;
	private MenuItem editBooking = null;
	private MenuItem deleteBooking = null;
	private MenuItem reactiveBooking = null;
	private MenuItem confirmBooking = null;

//	private String ObBokStatus = null;
	private boolean memIsBtnEdit = false;
	private boolean memIsBtnDelete = false;
	private String memPreShowCancel = null;
//	private boolean bCheckOk = false;
	private boolean isPrePBLWork = false;

	private final int GrdOBCol_sts = 1;
	private final int GrdOBCol_bpbno = 2;
	private final int GrdOBCol_patNo = 3;
	private final int GrdOBCol_patName = 4;
	private final int GrdOBCol_patCName = 5;
	private final int GrdOBCol_orderDr = 6;
	private final int GrdOBCol_ward = 10;
	private final int GrdOBCol_admDate = 11;
	private final int GrdOBCol_be = 18;
	private final int GrdOBCol_pboRemk = 19;
	private final int GrdOBCol_bpbid = 30;
	private final int GrdOBCol_bcheckwaiting = 31;
	private final int GrdOBCol_docCode = 34;	
	private final int GrdOBCol_patFName = 36;	
	private final int GrdOBCol_patGName = 37;
	private final int GrdOBCol_obbookingid = 38;

	/**
	 * This method initializes
	 *
	 */
	public OBBook() {
		super();
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		isPrePBLWork = "HKAH".equals(Factory.getInstance().getSysParameter("curtSite"));

		getListTable().setContextMenu(getPopupMenu());
		PanelUtil.setAllFieldsEditable(getLeftPanel(), true);
		getPreSchdADateFrom().setText(getMainFrame().getServerDate());
//		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
//				new String[] { "sysparam", "PARAM1","PARCDE = 'obwardcode'" },
//				new MessageQueueCallBack() {
//			@Override
//			public void onPostSuccess(MessageQueue mQueue) {
//				obWardcode = mQueue.getContentField()[0];
//			}
//		});
		getPreCount().setText(String.valueOf(getListTable().getRowCount()));

		// reset select default tab
		getTabbedPane().setSelectedIndex(0);

		// reset OB Booking tab
		initOBBooking();
		initPreBooking();
		getPreSchdADateFrom().resetText();
		getPreSchdADateTo().resetText();
		getPreOrdDateFrom().resetText();
		getPreOrdDateTo().resetText();

		// set default date OB Pre-booking Listing
		getPreSchdADateFrom().setText(getMainFrame().getServerDate());

		// inital default value
		memIsBtnEdit = !isDisableFunction("btnEdit", "obBooking");
		memIsBtnDelete = !isDisableFunction("btnDelete", "obBooking");
		memPreShowCancel = null;
		enableButton();

		if (isDisableFunction("BokTab")) {
			getTabbedPane().getItem(0).disable();
			getTabbedPane().setSelectedIndex(1);
		}
		if (isDisableFunction("SrhTab")) {
			getTabbedPane().getItem(1).disable();
			getTabbedPane().setSelectedIndex(0);
		}
	}

	@Override
	public void rePostAction() {
//		super.rePostAction();

		if (getParameter("pno") != null) {
			getPatientNo().setText(getParameter("pno"));
		}
		if (getParameter("pname") != null) {
			getPatientName().setText(getParameter("pname"));
		}

		// clean up parameter
		removeParameter();

		super.rePostAction();
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextField getDefaultFocusComponent() {
		if (getTabbedPane().getSelectedIndex() == 1) {
			return getPrePatientNo();
		} else {
			return getExpDate();
		}
	}

	/* >>> ~14~ Set Browse Validation ===================================== <<< */
	@Override
	protected boolean browseValidation() {
		if (getTabbedPane().getSelectedIndex() == 1) {
			if (getPreBookType().isEmpty()) {
				Factory.getInstance().addErrorMessage("Please select Booking #/Type.", getPreBookType());
				return false;
			} else if (getPreSortBy().isEmpty()) {
				Factory.getInstance().addErrorMessage("Please select Sort By.", getPreSortBy());
				return false;
			} else if (getPreSchdADateFrom().isEmpty() && (getEDCDateFrom().isEmpty()&&getEDCDateTo().isEmpty())  ) {
				Factory.getInstance().addErrorMessage("Please input Schd Adm Date From.", getPreSchdADateFrom());
				return false;
			} else if (getPreDeposit().isEmpty()) {
				Factory.getInstance().addErrorMessage("Please select Deposit.", getPreDeposit());
				return false;
			} else if (getPreShowCancel().isEmpty()) {
				Factory.getInstance().addErrorMessage("Please select Status.", getPreShowCancel());
				return false;
			} else {
				return true;
			}
		} else {
			return true;
		}
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] { getPrePatientNo().getText(), getPreName().getText(),
				getPreDrCode().getText(), getPreDrName().getText(), getPreDoc().getText(),
				getPreSchdADateFrom().getText(), getPreSchdADateTo().getText(),
				getPreBookType().getText(), getPreOrdDateFrom().getText(),
				getPreOrdDateTo().getText(), getPreDeposit().getText(),
				getPreShowCancel().getText(), "", "",
				getPreSortBy().getText(), getPreChiName().getText(),
				getEDCDateFrom().getText(),getEDCDateTo().getText()};
	}

	/* >>> ~16~ Set Fetch Input Parameters ================================ <<< */
	@Override
	protected String[] getFetchInputParameters() {
		String[] selectedContent = getListSelectedRow();
		return new String[] { selectedContent[0] };
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {
	}

	@Override
	protected void searchPostAction() {
		if (getListTable().getRowCount()>0) {
			getModifyButton().setEnabled(true);
			getDeleteButton().setEnabled(true);
		}
	};

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	private void findPatReady(boolean isReady) {
		if (isReady) {
			super.searchAction();
		} else {
			getPrePatientNo().showSearchPanel();
		}
	}

	private void findDocCodeReady(boolean isReady) {
		if (isReady) {
			super.searchAction();
		} else {
			showPanel(new SlipSearch());
		}
	}

	private void findDocCode(String docCode) {
		if (docCode != null && docCode.length() > 0) {
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] { "Doctor", "DocCode", "DocCode = '" + docCode + "'" },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					findDocCodeReady(mQueue.success());
				}
			});
		} else {
			findDocCodeReady(false);
		}
	}

	private void findPat(String patNo) {
		if (patNo != null && patNo.length() > 0) {
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] { "Patient", "Patno", "Patno = '" + patNo + "'" },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					findPatReady(mQueue.success());
				}
			});
		} else {
			findPatReady(false);
		}
	}

	private void reactiveBooking() {
		if (getListTable().getSelectedRow() > -1) {
			Factory.getInstance().isConfirmYesNoDialog("Confirm reactive pre-booking?", new Listener<MessageBoxEvent>() {
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						final String pbpid = getListTable().getSelectedRowContent()[GrdOBCol_bpbid];
						QueryUtil.executeMasterAction(getUserInfo(),
								"BEDPREBOKREACTIVE", QueryUtil.ACTION_APPEND,
								new String[] { pbpid, getUserInfo().getUserID() }, new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									Factory.getInstance().addInformationMessage("Booking reactive successfully");
								} else {
									Factory.getInstance().addErrorMessage("Reactive Failed.");
								}
								// call search function
								searchAction();
							}
						});
					}
				}
			});
		}
	}

	private void confirmBooking() {
		if (getListTable().getSelectedRow() > -1) {
			Factory.getInstance().isConfirmYesNoDialog("Confirm pre-booking?", new Listener<MessageBoxEvent>() {
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						final String obbookingid = getListTable().getSelectedRowContent()[GrdOBCol_obbookingid];
						QueryUtil.executeMasterAction(getUserInfo(),
								"WAITING2BEDPREBOK", QueryUtil.ACTION_APPEND,
								new String[] { getUserInfo().getUserID(), obbookingid }, new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									Factory.getInstance().addInformationMessage("Booking confirmed successfully");
								} else {
									Factory.getInstance().addErrorMessage("Fail to confirm.");
								}
								// call search function
								searchAction();
							}
						});
					}
				}
			});
		}
	}

	private void enableBookingButton(boolean enable) {
		getExpDate().setEditable(!enable);
		getSelPatProfile().setEnabled(enable);
		getCreOBBook().setEnabled(enable);
	}

	private void enableListingButton(boolean enable) {
		getPreIPReg().setEnabled(enable);
		getPrePBL().setEnabled(enable && isPrePBLWork);
		getPreOTAB().setEnabled(enable && !isDisableFunction("mnuOT", ""));
		getPrePSL().setEnabled(enable);
	}

	private void initBedPreBokCnt(final String sYearMonth) {
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] { "BedPreBokCnt", "COUNT(1)", "BPBMONTH = '" + sYearMonth + "' and BPBTYPE = 'B'" },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					if (Integer.parseInt(mQueue.getContentField()[0]) > 1) {
						Factory.getInstance().addErrorMessage(
								"more than two booking count for this month!");
					} else if (Integer.parseInt(mQueue.getContentField()[0]) == 0) {
						QueryUtil.executeMasterAction(getUserInfo(),
								ConstantsTx.ADD_BEDPREBOKCNT,
								QueryUtil.ACTION_APPEND, new String[] { sYearMonth, "B", "0" , getUserInfo().getUserID() ,
										getUserInfo().getSiteCode() });
					}
				} else {
					Factory.getInstance().addErrorMessage(
							"Cannot init bedprebokcnt table.");
				}
			}
		});

		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] { "BedPreBokCnt", "COUNT(1)", "BPBMONTH = '" + sYearMonth + "' and BPBTYPE = 'W'" },
				new MessageQueueCallBack() {
			public void onPostSuccess(MessageQueue mQueue1) {
				if (mQueue1.success()) {
					if (Integer.parseInt(mQueue1.getContentField()[0]) > 1) {
						Factory.getInstance().addErrorMessage(
								"more than two booking count for this month!");
					} else if (Integer.parseInt(mQueue1.getContentField()[0]) == 0) {
						QueryUtil.executeMasterAction(getUserInfo(),
								ConstantsTx.ADD_BEDPREBOKCNT,
								QueryUtil.ACTION_APPEND, new String[] { sYearMonth, "W", "0" , getUserInfo().getUserID() ,
										getUserInfo().getSiteCode() });
					}
				} else {
					Factory.getInstance().addErrorMessage("Cannot init bedprebokcnt table.");
				}
			}
		});
	}

	private void getBookingCountsReady(int maxMPreBok,int maxDPreBok,int monthlyWaitingStarts,String sOBWaitingAuto,
			int curMPreBok,int obWaitingcnt,int curMPreBokP_B,int curMPreBokP_W,int curDPreBok,int curDpreBok_W,
			int curDPreBokP_B,int curDPreBokP_W,int mmbk,int mnmbk,int mtotal,
			int ymbk,int ynmbk,int ytotal,String readyType,String readyType2) {

		if ("bCheckOk".equals(readyType)) {
			int m=0;
			int d=0;
			//ObBokStatus = "B";
			getObBokStatusDesc().setText("B");
			boolean m_month_ok = false;
			boolean m_day_ok = false;
			getMonMainlandCitizenBL().setText(String.valueOf(mmbk));
			getYearMainlandCitizenBL().setText(String.valueOf(ymbk));
			getMonNoMainlandCitizenBL().setText(String.valueOf(mnmbk));
			getYearNoMainlandCitizenBL().setText(String.valueOf(ynmbk));
			getMonTotalBL().setText(String.valueOf(mtotal));
			getYearTotalBL().setText(String.valueOf(ytotal));
			if (maxMPreBok<0) {
				getMonBL().setText("N/A");
				getMonCB().setText("N/A");
				getMonIPW().setText("N/A");
				getMonA().setText("N/A");
				getMonCW().setText("N/A");
				getMonIPB().setText("N/A");
				m_month_ok = true;
			} else {
				m = maxMPreBok - curMPreBok- curMPreBokP_B - curMPreBokP_W - obWaitingcnt;
				String monA = String.valueOf(m);
				getMonBL().setText(String.valueOf(maxMPreBok));
				getMonCB().setText(String.valueOf(curMPreBok));
				getMonIPW().setText(String.valueOf(curMPreBokP_W));
				getMonCW().setText(String.valueOf(obWaitingcnt));
				getMonA().setText(monA);
				getMonIPB().setText(String.valueOf(curMPreBokP_B));
				m_month_ok = Integer.parseInt(monA) > 0;
			}

			if (maxDPreBok<0) {
				getDayBL().setText("N/A");
				getDayCB().setText("N/A");
				getDayIPW().setText("-");
				getDayA().setText("N/A");
				getDayCW().setText("-");
				getDayIPB().setText("N/A");
				m_day_ok = true;
			} else {
				d = maxDPreBok - curDPreBok - curDPreBokP_B;
				if (d>m) {d=m;}
				String dayA = String.valueOf(d);
				getDayBL().setText(String.valueOf(maxDPreBok));
				getDayCB().setText(String.valueOf(curDPreBok));
				getDayA().setText(dayA);
				getDayIPB().setText(String.valueOf(curDPreBokP_B));
				m_day_ok = Integer.parseInt(dayA) > 0;
			}
			if (m_month_ok && m_day_ok) {
				if ("NO".equals(sOBWaitingAuto)) {
					if (curMPreBok >= monthlyWaitingStarts - 1 && obWaitingcnt < maxMPreBok - monthlyWaitingStarts + 1) {
						MessageBoxBase.confirm("Question", "Booking Queue is full, do you want to queue in the Waiting Queue ?",
								new Listener<MessageBoxEvent>() {
									public void handleEvent(MessageBoxEvent be) {
										if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
											getObBokStatusDesc().setText("W");
											enableBookingButton(true);
										} else {
											enableBookingButton(false);
										}
									}
								});
					} else if (curMPreBok >= monthlyWaitingStarts - 1 && obWaitingcnt >= maxMPreBok - monthlyWaitingStarts + 1) {
						Factory.getInstance().addErrorMessage("Both Booking & Waiting Queue is full, you cannot make any booking.", "Warning");
						enableBookingButton(false);
					} else if (curMPreBok < monthlyWaitingStarts - 1 && obWaitingcnt < maxMPreBok - monthlyWaitingStarts + 1) {
						MessageBoxBase.confirm(ConstantsMessage.MSG_PBA_SYSTEM, "Do you want to queue in the booking queue ?",
								new Listener<MessageBoxEvent>() {
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									getObBokStatusDesc().setText("B");
								} else if (Dialog.NO.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									getObBokStatusDesc().setText("W");
									enableBookingButton(true);
								} else {
									enableBookingButton(false);
								}
								defaultFocus();
							}
						});
					} else if (curMPreBok < monthlyWaitingStarts - 1 && obWaitingcnt >= maxMPreBok - monthlyWaitingStarts + 1) {
						MessageBoxBase.confirm("Question", "Waiting Queue is full, do you want to queue in the Booking Queue ?",
								new Listener<MessageBoxEvent>() {
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									getObBokStatusDesc().setText("B");
									enableBookingButton(true);
								} else {
									enableBookingButton(false);
								}
							}
						});
					}
				} else {
					if (curMPreBok < monthlyWaitingStarts - 1) {
						getObBokStatusDesc().setText("B");
						enableBookingButton(true);
						getFootRemarkDesc()
								.setText("Hint: Click \"select Patient Profile\" to create/choose a patient profile");
					} else {
						MessageBoxBase.confirm("Question", "Booking Queue is full, you can only queue in the Waiting Queue?",
						new Listener<MessageBoxEvent>() {
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									getFootRemarkDesc().setText("Hint: Click \"select Patient Profile\" to create/choose a patient profile");
									getObBokStatusDesc().setText("W");
									enableBookingButton(true);
								} else {
									getObBokStatusDesc().resetText();
//									bCheckOk = false;
									return;
								}
							}
						});
					}
//					bCheckOk = true;
				}
//				bCheckOk = true;
				enableBookingButton(true);
			} else if (!m_month_ok) {
				Factory.getInstance().addErrorMessage("Monthly quota full.  Please select another EDC!", getExpDate());
			} else if (m_month_ok) {
				Factory.getInstance().addErrorMessage("Daily quota full.  Please select another EDC!", getExpDate());
			} else {
				getExpDate().clear();
				Factory.getInstance().addErrorMessage("Please enter a valid EDC!", getExpDate());
			}
		} else if ("issueLock1".equals(readyType)) {
			if ((maxMPreBok > 0 ? maxMPreBok - curMPreBok - curMPreBokP_B
					- curMPreBokP_W - obWaitingcnt > 0 : true)
					&& (maxDPreBok > 0 ? maxDPreBok - curDPreBok - curDPreBokP_B > 0 : true)) {
				if ("S".equals(getObBokStatusDesc().getText())) {
					getObBokStatusDesc().setText("W");
				}
				getPBNo();
				getBookingCounts("issueLock2", readyType2);
			} else {
				Factory.getInstance().addErrorMessage("Cannot issue In-Progress lock. Currently no quota available.  Please retry.", "Warning");
			}
		} else if ("issueLock2".equals(readyType)) {
			if ((maxMPreBok > 0 ? maxMPreBok - curMPreBok - curMPreBokP_B
					- curMPreBokP_W - obWaitingcnt > 0: true)
					&& (maxDPreBok > 0 ? maxDPreBok - curDPreBok
							- curDPreBokP_B > 0 : true)) {
				issueLockReady(true, readyType2);
			} else {
				Factory.getInstance().addErrorMessage("Cannot issue In-Progress lock.  Currently no quota available.  Please retry.", "Warning");
			}
		}
	}

	private void getBookingCounts(final String readyType1,final String readyType2) {
		QueryUtil.executeMasterFetch(getUserInfo(),"BOOKINGCOUNT",new String[] {DateTimeUtil.formatDate(getExpDate().getValue()),CommonUtil.getComputerName()},
				new MessageQueueCallBack() {
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getBookingCountsReady(Integer.parseInt(mQueue.getContentField()[0]),Integer.parseInt(mQueue.getContentField()[1]),
							Integer.parseInt(mQueue.getContentField()[2]), mQueue.getContentField()[3],
							Integer.parseInt(mQueue.getContentField()[4]),Integer.parseInt(mQueue.getContentField()[5]),
							Integer.parseInt(mQueue.getContentField()[6]),Integer.parseInt(mQueue.getContentField()[7]),
							Integer.parseInt(mQueue.getContentField()[8]),Integer.parseInt(mQueue.getContentField()[9]),
							Integer.parseInt(mQueue.getContentField()[10]),Integer.parseInt(mQueue.getContentField()[11]),
							Integer.parseInt(mQueue.getContentField()[12]),Integer.parseInt(mQueue.getContentField()[13]),
							Integer.parseInt(mQueue.getContentField()[14]),Integer.parseInt(mQueue.getContentField()[15]),
							Integer.parseInt(mQueue.getContentField()[16]),Integer.parseInt(mQueue.getContentField()[17]),
							readyType1,readyType2
					);
				}
			}
		});
	}

	private void IPRegReady(boolean isReady) {
		if (isReady) {
			setParameter("isPreBooking", "YES");
			setParameter("DocCode", getListTable().getSelectedRowContent()[GrdOBCol_docCode]);
			setParameter("PatNo", getListTable().getSelectedRowContent()[GrdOBCol_patNo]);
			if (getListTable().getSelectedRowContent()[GrdOBCol_patFName].length() > 0) {
				setParameter("PatFName", getListTable().getSelectedRowContent()[GrdOBCol_patFName]);
			} else {
				setParameter("PatFName", getListTable().getSelectedRowContent()[GrdOBCol_patName]);
			}
			setParameter("pat_Fname", getListTable().getSelectedRowContent()[GrdOBCol_patFName]);
			setParameter("pat_Gname", getListTable().getSelectedRowContent()[GrdOBCol_patGName]);
			setParameter("pat_Cname", getListTable().getSelectedRowContent()[GrdOBCol_patCName]);
			setParameter("START_TYPE", "I"); // REG_INPATIENT="I"
			setParameter("CallForm", "srhPatStsView");
			setParameter("CurrentPBPId", getListTable().getSelectedRowContent()[GrdOBCol_bpbid]);
			setParameter("PBORemark", getListTable().getSelectedRowContent()[GrdOBCol_pboRemk]);

			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] { "bedprebok", "ESTSTAYLEN", "PBPId = '" + getListTable().getSelectedRowContent()[GrdOBCol_bpbid] + "'"},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					resetParameter("STAYLEN");
					if (mQueue.success() && mQueue.getContentField()[0].length() > 0) {
						setParameter("STAYLEN", mQueue.getContentField()[0]);
					}

					QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] { "bedprebok b, ot_app ota, ot_proc otp", "min(ota.otpid)", "b.pbpid = ota.pbpid and ota.otpid = otp.otpid and b.pbpid = '" + getListTable().getSelectedRowContent()[GrdOBCol_bpbid] + "'"},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							resetParameter("PkgCode");
							if (mQueue.success() && mQueue.getContentField()[0].length() > 0) {
								QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
										new String[] { "ot_proc", "PkgCode", "otpid = '" + mQueue.getContentField()[0] + "'"},
										new MessageQueueCallBack() {
									@Override
									public void onPostSuccess(MessageQueue mQueue) {
										if (mQueue.success() && mQueue.getContentField()[0].length() > 0) {
											setParameter("PkgCode", mQueue.getContentField()[0]);
										}
										showPanel(new PatientIn());
									}
								});
							} else {
								showPanel(new PatientIn());
							}
						}
					});
				}
			});
		}
	}

	private void IPReg() {
		if (getListTable().getSelectedRow() != -1) {
			if ("F".equals(getListTable().getSelectedRowContent()[0])) {
				Factory.getInstance().addInformationMessage("The current Pre_Booking has been confirmed.");
				IPRegReady(false);
			} else if ("S".equals(getListTable().getSelectedRowContent()[GrdOBCol_bpbno].substring(0, 1))) {
				Factory.getInstance().isConfirmYesNoDialog("Confirmed to register a waiting list pre-booking?",new Listener<MessageBoxEvent>() {
					public void handleEvent(MessageBoxEvent be) {
						if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
							IPRegReady(true);
						}
					}
				});
			} else if (DateTimeUtil.dateDiff(getMainFrame().getServerDate(), getListTable()
					.getSelectedRowContent()[GrdOBCol_admDate].substring(0, 10)) > 0) {
				Factory.getInstance().isConfirmYesNoDialog("Confirm IP registration on outdated booking ?",new Listener<MessageBoxEvent>() {
					public void handleEvent(MessageBoxEvent be) {
						if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
							IPRegReady(true);
						}
					}
				});
			} else {
				IPRegReady(true);
			}
		}
	}

	private void printOBBooking() {
		int k=0;
		ArrayList<String> docCodeList = new ArrayList<String>();
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("ImagePath", CommonUtil.getReportImg("rpt_logo3.jpg"));
		int rowCount=getListTable().getRowCount();

		if (rowCount<1) {
			return;
		}
		for (int i = 0; i < rowCount; i++) {
			if ((getListTable().getValueAt(i, 23)==null)||(getListTable().getValueAt(i, 23).trim().length()<1)) {
				String docCode = getListTable().getValueAt(i, GrdOBCol_docCode).toString();
				if (!docCodeList.contains(docCode)) {
					docCodeList.add(docCode);
				}
			}
		}
		boolean prtFlg = false;
		for (String docc : docCodeList) {
			String bpbid="";
			for (int i = 0; i < rowCount; i++) {
				if ((getListTable().getValueAt(i, 23)==null)||(getListTable().getValueAt(i, 23).trim().length()<1)) {
					if (docc.equals(getListTable().getValueAt(i, GrdOBCol_docCode).toString())) {
						bpbid =bpbid+getListTable().getValueAt(i, GrdOBCol_bpbid).toString()+",";
					}}
				}

			if (bpbid.length()>1) {
				bpbid=bpbid.substring(0, bpbid.length()-1);
				k++;
			  prtFlg = PrintingUtil.print("","OBCancellation", map,"",
						new String[] {bpbid},
						new String[] {"DOCNAME","ADD1","ADD2",
							"ADD3","ADD4","DOCTEL","DOCFAX","PATNAME","EDC","BPBNO"},
						false);

			}
		}
		if (prtFlg) {
			Factory.getInstance().addInformationMessage("print Successfully!");
		} else{
			Factory.getInstance().addErrorMessage("print fail");
		}
	}

	private void issueLockReady(boolean isReady, String readyType) {
		if (isReady) {
			if ("getSelPatProfile".equals(readyType)) {
				resetParameter("PatNo");
				setParameter("FromOBBook1", "YES");
				showPanel(new Patient());
			} else if ("getCreOBBook".equals(readyType)) {
				setParameter("ACTIONTYPE", QueryUtil.ACTION_APPEND);
				setParameter("obpatno", getPatientNo().getText().trim());
				setParameter("isfromobbooking", "TRU");
				setParameter("confinementdate", DateTimeUtil.formatDate(getExpDate().getValue()));
				setParameter("bcheckwaiting", getObBokStatusDesc().getText());
				setParameter("BPBREGTYPE","I");
				showPanel(new EditPreBooking());
			}
		}
	}

	private void issueLock(final String readyType) {
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] {"stsprebok", "COUNT(1)", " computername='" + CommonUtil.getComputerName()+ "' and enddate is null " },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (Integer.parseInt(mQueue.getContentField()[0]) <= 0) {
					getBookingCounts("issueLock1",readyType);
//					issueLockReady(true, readyType);
				} else {
					issueLockReady(true, readyType);
				}
			}
		});
	}

	private void getPBNoReady(String pbno) {
		QueryUtil.executeMasterAction(getUserInfo(),ConstantsTx.ADD_STSPREBOK, QueryUtil.ACTION_APPEND,
				new String[] { pbno, DateTimeUtil.formatDate(getExpDate().getValue()),
						CommonUtil.getComputerName(), getObBokStatusDesc().getText() });
	}

	private void getPBNo() {
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] { "stsprebok", "max(pbno)", "1=1" },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				int maxno = 1;
				if (mQueue.success()) {
					maxno=Integer.parseInt(mQueue.getContentField()[0])+1;
				}
				getPBNoReady(String.valueOf(maxno));
			}
		});
	}

	private void initOBBooking() {
		getMonBL().setText("N/A");
		getMonCB().setText("N/A");
		getMonIPW().setText("N/A");
		getMonA().setText("N/A");
		getDayBL().setText("N/A");
		getDayCB().setText("N/A");
		getDayA().setText("N/A");
		getMonCW().setText("N/A");
		getMonIPB().setText("N/A");
		getDayIPB().setText("N/A");
		getMonMainlandCitizenBL().setText("N/A");
		getYearMainlandCitizenBL().setText("N/A");
		getMonNoMainlandCitizenBL().setText("N/A");
		getYearNoMainlandCitizenBL().setText("N/A");
		getMonTotalBL().setText("N/A");
		getYearTotalBL().setText("N/A");

		getExpDate().setEditable(true);
		getExpDate().clear();
		getPatientNo().resetText();
		getPatientName().resetText();
		enableBookingButton(false);
		getCheck().setEnabled(true);
		if (TabbedPane.getSelectedIndex() == 0) {
			getExpDate().focus();
		} else {
			getPrePatientNo().requestFocus();
		}

		getFootRemarkDesc().setText("Hint: Enter the EDC and check for bed availability");
	}

	private void initPreBooking() {
		getPrePatientNo().resetText();
		getPreDoc().resetText();
		getPreName().resetText();
		getPreChiName().resetText();
		getPreDrCode().resetText();
		getPreDrName().resetText();
		getPreBookType().resetText();
		getPreSortBy().setSelectedIndex(5);
		getPreDeposit().resetText();
		getPreShowCancel().resetText();
	}

	private void endProcPB() {
		QueryUtil.executeMasterAction(getUserInfo(),
				ConstantsTx.UPDATE_STSPREBOK, QueryUtil.ACTION_MODIFY,
				new String[] { CommonUtil.getComputerName() }, new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				initOBBooking();
			}
		});
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	public void searchAction() {
		memPreShowCancel = getPreShowCancel().getText();

		if (getTabbedPane().getSelectedIndex() == 1) {
			if (getPrePatientNo().isFocusOwner()) {
				findPat(getPrePatientNo().getText().trim());
			} else if (getPreDrCode().isFocusOwner()) {
				findDocCode(getPreDrCode().getText().trim());
			} else {
				super.searchAction();
			}
		}
	}

	@Override
	public void modifyAction() {
		if (getListTable().getSelectedRow() > -1) {
			if ("N".equals(getListTable().getSelectedRowContent()[GrdOBCol_sts])) {
				setParameter("ACTIONTYPE", QueryUtil.ACTION_MODIFY);
			} else {
				setParameter("ACTIONTYPE", QueryUtil.ACTION_FETCH);
			}
			setParameter("PBPID", getListTable().getSelectedRowContent()[GrdOBCol_bpbid]);
			setParameter("isfromobbooking", "TRU-MOD");
			setParameter("bcheckwaiting", getListTable().getSelectedRowContent()[GrdOBCol_bcheckwaiting]);
			setParameter("BPBREGTYPE","I");			
			showPanel(new EditPreBooking());
		}
	}

	@Override
	public void deleteAction() {
		if (getListTable().getSelectedRow() > -1) {
			Factory.getInstance().isConfirmYesNoDialog("Confirm remove pre-booking?", new Listener<MessageBoxEvent>() {
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						final String pbpid = getListTable().getSelectedRowContent()[GrdOBCol_bpbid];
						QueryUtil.executeMasterAction(getUserInfo(),
								"BEDPREBOKDEL", QueryUtil.ACTION_DELETE,
								new String[] { pbpid, getUserInfo().getUserID() }, new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
											new String[] { "OT_APP", "COUNT(1)", "PBPID = " + pbpid + " and otasts = 'N'" },
											new MessageQueueCallBack() {
										@Override
										public void onPostSuccess(MessageQueue cntQueue) {
											final String showWarning = cntQueue.getContentField()[0];
											QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
													new String[] { "bedprebok", "COUNT(1)", "PBPID = " + pbpid + " and bpbsts = 'D'" },
													new MessageQueueCallBack() {
												@Override
												public void onPostSuccess(MessageQueue bedQueue) {
													if (bedQueue.success() && "1".equals(bedQueue.getContentField()[0])) {
														String funname = "OB Booking -> Delete";
														Map<String, String> params = new HashMap<String, String>();
														params.put("Ward", getListTable().getSelectedRowContent()[GrdOBCol_ward]);
														params.put("Order by Doctor", getListTable().getSelectedRowContent()[GrdOBCol_orderDr]);
														params.put("Hospital Date", getListTable().getSelectedRowContent()[GrdOBCol_admDate]);
														String patno = getListTable().getSelectedRowContent()[GrdOBCol_patNo];
														getAlertCheck().checkAltAccess(patno, funname, true, true, params);
														if ("0".equals(showWarning)) {
															Factory.getInstance().addInformationMessage("Booking removed successfully");
														} else {
															Factory.getInstance().addInformationMessage("Booking removed successfully. Please notify the Operation Room for the cancel of the pre-booking.");
														}
														// call search function
														searchAction();
													}
												}
											});
										}
									});
								} else {
									Factory.getInstance().addErrorMessage("Delete Failed.");
								}
							}
						});
					}
				}
			});
		}
	}

	@Override
	protected void performListPost() {
		getPreCount().setText(String.valueOf(getListTable().getRowCount()));
		enableButton();
	}

	@Override
	protected void enableButton(String mode) {
		int currentTab = getTabbedPane().getSelectedIndex();
		boolean noOfRecord = getListTable().getRowCount() > 0;
		boolean isNormal = "N".equals(memPreShowCancel);
		boolean isDeleted = "S".equals(memPreShowCancel);
		boolean isWaiting = "W".equals(memPreShowCancel);

		getSearchButton().setEnabled(currentTab == 1);
		getAppendButton().setEnabled(false);
		getModifyButton().setEnabled(currentTab == 1 && noOfRecord && (isNormal || isDeleted) && memIsBtnEdit);
		getDeleteButton().setEnabled(currentTab == 1 && noOfRecord && isNormal && memIsBtnDelete);
		getSaveButton().setEnabled(false);
		getAcceptButton().setEnabled(false);
		getCancelButton().setEnabled(false);
		getRefreshButton().setEnabled(false);
		getPrintButton().setEnabled(false);

		getEditBookingMenu().setEnabled(getModifyButton().isEnabled());
		getDeleteBookingMenu().setEnabled(getDeleteButton().isEnabled());
		getReactiveBookingMenu().setEnabled(noOfRecord && !isNormal && !isWaiting);
		getConfirmBookingMenu().setEnabled(noOfRecord && isWaiting);

		if (currentTab == 0) {
			enableBookingButton(!getExpDate().isEmpty());
		} else {
			enableListingButton(noOfRecord && isNormal);
		}
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	@Override
	protected BasePanel getSearchPanel() {
		if (searchPanel == null) {
			searchPanel = new BasePanel();
			searchPanel.setSize(810, 520);
			searchPanel.add(getTabbedPane());
		}
		return searchPanel;
	}

	public TabbedPaneBase getTabbedPane() {
		if (TabbedPane == null) {
			TabbedPane = new TabbedPaneBase() {
				@Override
				public void onStateChange() {
					enableButton();
				}
			};
			TabbedPane.setBounds(0, 0, 810, 510);
			TabbedPane.addTab("OB Booking", getOBBookPanel());
			TabbedPane.addTab("OB Pre-booking Listing", getOBPreBookPanel());
		}
		return TabbedPane;
	}

	public BasePanel getOBBookPanel() {
		if (OBBookPanel == null) {
			OBBookPanel = new BasePanel();
			OBBookPanel.add(getRemarkDesc(), null);
			OBBookPanel.add(getExpDateDesc(), null);
			OBBookPanel.add(getExpDate(), null);
			OBBookPanel.add(getCheck(), null);
			OBBookPanel.add(getOBBookStatPanel(), null);
			OBBookPanel.add(getPatientNoDesc(), null);
			OBBookPanel.add(getPatientNo(), null);
			OBBookPanel.add(getPatientNameDesc(), null);
			OBBookPanel.add(getPatientName(), null);
			OBBookPanel.add(getSelPatProfile(), null);
			OBBookPanel.add(getCreOBBook(), null);
			OBBookPanel.add(getClear(), null);
			OBBookPanel.add(getFootRemarkDesc(), null);
			OBBookPanel.setBounds(0, 0, 784, 500);
		}
		return OBBookPanel;
	}

	public LabelBase getRemarkDesc() {
		if (RemarkDesc == null) {
			RemarkDesc = new LabelBase();
			RemarkDesc.setText("<html>This feature is used for making Pre-booking for OB. User should check the availability of bed before process."
					+ "<br>Pre-booking made through this feature is only for O.B. Make sure no other Pre-booking is made throuth here.</html>");
			RemarkDesc.setBounds(15, 26, 733, 41);
		}
		return RemarkDesc;
	}

	public LabelBase getExpDateDesc() {
		if (ExpDateDesc == null) {
			ExpDateDesc = new LabelBase();
			ExpDateDesc.setText("<html>Expection Date of Confinement:"
					+ "<br>(dd/mm/yyyy)</html>");
			ExpDateDesc.setBounds(15, 82, 204, 35);
		}
		return ExpDateDesc;
	}

	public TextDate getExpDate() {
		if (ExpDate == null) {
			ExpDate = new TextDate();
			ExpDate.setPosition(210, 85);
		}
		return ExpDate;
	}

	public ButtonBase getCheck() {
		if (Check == null) {
			Check = new ButtonBase() {
				@Override
				public void onClick() {
					Date date = getExpDate().getValue();
					if (date!=null) {
					String expDate=DateTimeUtil.formatDate(date);
					initBedPreBokCnt(DateTimeUtil.formatYearMonth(date));
						if (DateTimeUtil.dateDiff(getMainFrame().getServerDate(),expDate)>0) {
							Factory.getInstance().isConfirmYesNoDialog("EDC earlier than today, continue?", new Listener<MessageBoxEvent>() {
								public void handleEvent(MessageBoxEvent be) {
									if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
										getCheck().setEnabled(false);
										getBookingCounts("bCheckOk", null);
										getExpDate().setEditable(false);
									} else if (Dialog.NO.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
										getExpDate().clear();
										getExpDate().focus();
									}
								}
							});
						} else {
							getExpDate().setEditable(false);
							getBookingCounts("bCheckOk", null);
							getCheck().setEnabled(false);
						}
					} else {
						Factory.getInstance().addErrorMessage("Invalid Expected Confinement Date(EDC). ", getExpDate());
					}
				}
			};
			Check.setText("Check");
			Check.setBounds(366, 85, 102, 25);
		}
		return Check;
	}

	public BasePanel getOBBookStatPanel() {
		if (OBBookStatPanel == null) {
			OBBookStatPanel = new BasePanel();
			OBBookStatPanel.setHeading("OB Booking Status");
			OBBookStatPanel.add(getBookLimitsDesc(), null);
			OBBookStatPanel.add(getCurBookDesc(), null);
			OBBookStatPanel.add(getCurWaitDesc(), null);
			OBBookStatPanel.add(getInproBookDesc(), null);
			OBBookStatPanel.add(getInproWaitDesc(), null);
			OBBookStatPanel.add(getAvailableDesc(), null);
//			OBBookStatPanel.add(getLine(), null);
			OBBookStatPanel.add(getMonthDesc(), null);

			OBBookStatPanel.add(getMonth1Desc(), null);
			OBBookStatPanel.add(getYearDesc(), null);
			OBBookStatPanel.add(getMainlandCitizenDesc(), null);
			OBBookStatPanel.add(getMainlandCitizen1Desc(), null);
			OBBookStatPanel.add(getNoMainlandCitizenDesc(), null);
			OBBookStatPanel.add(getNoMainlandCitizen1Desc(), null);
			OBBookStatPanel.add(getTotalDesc(), null);
			OBBookStatPanel.add(getTotal1Desc(), null);

			OBBookStatPanel.add(getMonMainlandCitizenBL(), null);
			OBBookStatPanel.add(getYearMainlandCitizenBL(), null);
			OBBookStatPanel.add(getMonNoMainlandCitizenBL(), null);
			OBBookStatPanel.add(getYearNoMainlandCitizenBL(), null);
			OBBookStatPanel.add(getMonTotalBL(), null);
			OBBookStatPanel.add(getYearTotalBL(), null);

			OBBookStatPanel.add(getDayDesc(), null);
			OBBookStatPanel.add(getMonBL(), null);
			OBBookStatPanel.add(getMonCB(), null);
			OBBookStatPanel.add(getMonCW(), null);
			OBBookStatPanel.add(getMonIPB(), null);
			OBBookStatPanel.add(getMonIPW(), null);
			OBBookStatPanel.add(getMonA(), null);
			OBBookStatPanel.add(getDayBL(), null);
			OBBookStatPanel.add(getDayCB(), null);
			OBBookStatPanel.add(getDayCW(), null);
			OBBookStatPanel.add(getDayIPB(), null);
			OBBookStatPanel.add(getDayIPW(), null);
			OBBookStatPanel.add(getLine1(), null);
			OBBookStatPanel.add(getLine2(), null);
			OBBookStatPanel.add(getDayA(), null);
			OBBookStatPanel.setBounds(9, 140, 757, 185);
		}
		return OBBookStatPanel;
	}

	public LabelBase getBookLimitsDesc() {
		if (BookLimitsDesc == null) {
			BookLimitsDesc = new LabelBase();
			BookLimitsDesc.setAlignmentCenter();
			BookLimitsDesc.setText("Booking Limits");
			BookLimitsDesc.setBounds(21, 21, 118, 20);
		}
		return BookLimitsDesc;
	}

	public LabelBase getCurBookDesc() {
		if (CurBookDesc == null) {
			CurBookDesc = new LabelBase();
			CurBookDesc.setAlignmentCenter();
			CurBookDesc.setText("Currently Booked");
			CurBookDesc.setBounds(138, 21, 131, 20);
		}
		return CurBookDesc;
	}

	public LabelBase getCurWaitDesc() {
		if (CurWaitDesc == null) {
			CurWaitDesc = new LabelBase();
			CurWaitDesc.setAlignmentCenter();
			CurWaitDesc.setText("Currently Waiting");
			CurWaitDesc.setBounds(268, 21, 131, 20);
		}
		return CurWaitDesc;
	}

	public LabelBase getInproBookDesc() {
		if (InproBookDesc == null) {
			InproBookDesc = new LabelBase();
			InproBookDesc.setAlignmentCenter();
			InproBookDesc.setText("In Progress Booked");
			InproBookDesc.setBounds(396, 21, 131, 20);
		}
		return InproBookDesc;
	}

	public LabelBase getInproWaitDesc() {
		if (InproWaitDesc == null) {
			InproWaitDesc = new LabelBase();
			InproWaitDesc.setAlignmentCenter();
			InproWaitDesc.setText("In Progress Waiting");
			InproWaitDesc.setBounds(517, 21, 131, 20);
		}
		return InproWaitDesc;
	}

	public LabelBase getAvailableDesc() {
		if (AvailableDesc == null) {
			AvailableDesc = new LabelBase();
			AvailableDesc.setAlignmentCenter();
			AvailableDesc.setText("Available");
			AvailableDesc.setBounds(650, 21, 90, 20);
		}
		return AvailableDesc;
	}

//	public LabelBase getLine() {
//		if (Line == null) {
//			Line = new LabelBase();
//			//Line.setBorder(BorderFactory.createLineBorder(Color.black));
//			Line.setBounds(22, 50, 720, 1);
//		}
//		return Line;
//	}

	public LabelBase getMonthDesc() {
		if (MonthDesc == null) {
			MonthDesc = new LabelBase();
			MonthDesc.setText("Month:");
			MonthDesc.setBounds(12, 72, 52, 20);
		}
		return MonthDesc;
	}

	public LabelBase getDayDesc() {
		if (DayDesc == null) {
			DayDesc = new LabelBase();
			DayDesc.setText("Day:");
			DayDesc.setBounds(12, 99, 52, 20);
		}
		return DayDesc;
	}

	public Line getLine1() {
		if (hp1 == null) {
			hp1 = new Line();
			hp1.setBounds(12, 55, 730);
		}
		return hp1;
	}

	public Line getLine2() {
		if (hp2 == null) {
			hp2 = new Line();
			hp2.setBounds(12, 125, 730);
		}
		return hp2;
	}

	public LabelBase getMonth1Desc() {
		if (Month1Desc == null) {
			Month1Desc = new LabelBase();
			Month1Desc.setText("Month:");
			Month1Desc.setBounds(12, 130, 52, 20);
		}
		return Month1Desc;
	}

	public LabelBase getYearDesc() {
		if (YearDesc == null) {
			YearDesc = new LabelBase();
			YearDesc.setText("Year:");
			YearDesc.setBounds(12, 155, 52, 20);
		}
		return YearDesc;
	}

	public LabelBase getMainlandCitizenDesc() {
		if (MainlandCitizenDesc == null) {
			MainlandCitizenDesc = new LabelBase();
			MainlandCitizenDesc.setText("Mainland Citizen:");
			MainlandCitizenDesc.setBounds(90, 130, 120, 20);
		}
		return MainlandCitizenDesc;
	}

	public LabelBase getMonMainlandCitizenBL() {
		if (monMainlandCitizenBL == null) {
			monMainlandCitizenBL = new LabelBase();
			monMainlandCitizenBL.setText("N/A");
			monMainlandCitizenBL.setBounds(200, 130, 50, 20);
		}
		return monMainlandCitizenBL;
	}

	public LabelBase getYearMainlandCitizenBL() {
		if (yearMainlandCitizenBL == null) {
			yearMainlandCitizenBL = new LabelBase();
			yearMainlandCitizenBL.setText("N/A");
			yearMainlandCitizenBL.setBounds(200, 155, 50, 20);
		}
		return yearMainlandCitizenBL;
	}

	public LabelBase getMonNoMainlandCitizenBL() {
		if (monNoMainlandCitizenBL == null) {
			monNoMainlandCitizenBL = new LabelBase();
			monNoMainlandCitizenBL.setText("N/A");
			monNoMainlandCitizenBL.setBounds(400, 130, 50, 20);
		}
		return monNoMainlandCitizenBL;
	}

	public LabelBase getYearNoMainlandCitizenBL() {
		if (yearNoMainlandCitizenBL == null) {
			yearNoMainlandCitizenBL = new LabelBase();
			yearNoMainlandCitizenBL.setText("N/A");
			yearNoMainlandCitizenBL.setBounds(400, 155,50, 20);
		}
		return yearNoMainlandCitizenBL;
	}

	public LabelBase getMonTotalBL() {
		if (monTotalBL == null) {
			monTotalBL = new LabelBase();
			monTotalBL.setText("N/A");
			monTotalBL.setBounds(525, 130, 50, 20);
		}
		return monTotalBL;
	}

	public LabelBase getYearTotalBL() {
		if (yearTotalBL == null) {
			yearTotalBL = new LabelBase();
			yearTotalBL.setText("N/A");
			yearTotalBL.setBounds(525,155, 50, 20);
		}
		return yearTotalBL;
	}

	public LabelBase getMainlandCitizen1Desc() {
		if (MainlandCitizen1Desc == null) {
			MainlandCitizen1Desc = new LabelBase();
			MainlandCitizen1Desc.setText("Mainland Citizen:");
			MainlandCitizen1Desc.setBounds(90, 155, 120, 20);
		}
		return MainlandCitizen1Desc;
	}

	public LabelBase getNoMainlandCitizenDesc() {
		if (NoMainlandCitizenDesc == null) {
			NoMainlandCitizenDesc = new LabelBase();
			NoMainlandCitizenDesc.setText("Non Mainland Citizen:");
			NoMainlandCitizenDesc.setBounds(270, 130, 140, 20);
		}
		return NoMainlandCitizenDesc;
	}
	public LabelBase getNoMainlandCitizen1Desc() {
		if (NoMainlandCitizen1Desc == null) {
			NoMainlandCitizen1Desc = new LabelBase();
			NoMainlandCitizen1Desc.setText("Non Mainland Citizen:");
			NoMainlandCitizen1Desc.setBounds(270, 155, 140, 20);
		}
		return NoMainlandCitizen1Desc;
	}

	public LabelBase getTotalDesc() {
		if (TotalDesc == null) {
			TotalDesc = new LabelBase();
			TotalDesc.setText("Total:");
			TotalDesc.setBounds(480, 130, 50, 20);
		}
		return TotalDesc;
	}
	public LabelBase getTotal1Desc() {
		if (Total1Desc == null) {
			Total1Desc = new LabelBase();
			Total1Desc.setText("Total:");
			Total1Desc.setBounds(480, 155,50, 20);
		}
		return Total1Desc;
	}
	public LabelBase getMonBL() {
		if (MonBL == null) {
			MonBL = new LabelBase();
			MonBL.setText("N/A");
			MonBL.setBounds(66, 71, 30, 20);
		}
		return MonBL;
	}

	public LabelBase getMonCB() {
		if (MonCB == null) {
			MonCB = new LabelBase();
			MonCB.setText("N/A");
			MonCB.setBounds(189, 71, 30, 20);
		}
		return MonCB;
	}

	public LabelBase getMonCW() {
		if (MonCW == null) {
			MonCW = new LabelBase();
			MonCW.setText("N/A");
			MonCW.setBounds(315, 71, 30, 20);
		}
		return MonCW;
	}

	public LabelBase getMonIPB() {
		if (MonIPB == null) {
			MonIPB = new LabelBase();
			MonIPB.setText("N/A");
			MonIPB.setBounds(437, 71, 30, 20);
		}
		return MonIPB;
	}

	public LabelBase getMonIPW() {
		if (MonIPW == null) {
			MonIPW = new LabelBase();
			MonIPW.setText("N/A");
			MonIPW.setBounds(561, 71, 30, 20);
		}
		return MonIPW;
	}

	public LabelBase getMonA() {
		if (MonA == null) {
			MonA = new LabelBase();
			MonA.setText("N/A");
			MonA.setBounds(683, 71, 30, 20);
		}
		return MonA;
	}

	public LabelBase getDayBL() {
		if (DayBL == null) {
			DayBL = new LabelBase();
			DayBL.setText("N/A");
			DayBL.setBounds(66, 100, 30, 20);
		}
		return DayBL;
	}

	public LabelBase getDayCB() {
		if (DayCB == null) {
			DayCB = new LabelBase();
			DayCB.setText("N/A");
			DayCB.setBounds(189, 100, 30, 20);
		}
		return DayCB;
	}

	public LabelBase getDayCW() {
		if (DayCW == null) {
			DayCW = new LabelBase();
			DayCW.setText("-");
			DayCW.setBounds(315, 100, 30, 20);
		}
		return DayCW;
	}

	public LabelBase getDayIPB() {
		if (DayIPB == null) {
			DayIPB = new LabelBase();
			DayIPB.setText("N/A");
			DayIPB.setBounds(437, 100, 30, 20);
		}
		return DayIPB;
	}

	public LabelBase getDayIPW() {
		if (DayIPW == null) {
			DayIPW = new LabelBase();
			DayIPW.setText("-");
			DayIPW.setBounds(561, 100, 30, 20);
		}
		return DayIPW;
	}

	public LabelBase getPatientNoDesc() {
		if (PatientNoDesc == null) {
			PatientNoDesc = new LabelBase();
			PatientNoDesc.setText("Patient No:");
			PatientNoDesc.setBounds(30, 325, 121, 20);
		}
		return PatientNoDesc;
	}

	public LabelBase getPatientNo() {
		if (PatientNo == null) {
			PatientNo = new LabelBase();
			PatientNo.setBounds(151, 325, 152, 20);
		}
		return PatientNo;
	}

	public LabelBase getPatientNameDesc() {
		if (PatientNameDesc == null) {
			PatientNameDesc = new LabelBase();
			PatientNameDesc.setText("Patient Name:");
			PatientNameDesc.setBounds(30, 355, 121, 20);
		}
		return PatientNameDesc;
	}

	public LabelBase getPatientName() {
		if (PatientName == null) {
			PatientName = new LabelBase();
			PatientName.setBounds(151, 355, 182, 20);
		}
		return PatientName;
	}

	public LabelBase getDayA() {
		if (DayA == null) {
			DayA = new LabelBase();
			DayA.setText("N/A");
			DayA.setBounds(683, 100, 30, 20);
		}
		return DayA;
	}

	public ButtonBase getSelPatProfile() {
		if (SelPatProfile == null) {
			SelPatProfile = new ButtonBase() {
				@Override
				public void onClick() {
					issueLock("getSelPatProfile");
				}
			};
			SelPatProfile.setText("Select Patient Profile", 'S');
			SelPatProfile.setBounds(29, 393, 158, 25);
		}
		return SelPatProfile;
	}

	public ButtonBase getCreOBBook() {
		if (CreOBBook == null) {
			CreOBBook = new ButtonBase() {
				@Override
				public void onClick() {
					issueLock("getCreOBBook");
				}
			};
			CreOBBook.setText("Create OB Pre-booking", 'O');
			CreOBBook.setBounds(198, 393, 158, 25);
		}
		return CreOBBook;
	}

	public void clearAction() {
		if (getTabbedPane().getSelectedIndex() == 0) {
			endProcPB();
			initPreBooking();
		} else {
			super.clearAction();
			getPreSchdADateFrom().setText(getMainFrame().getServerDate());
		}
	}

	public ButtonBase getClear() {
		if (Clear == null) {
			Clear = new ButtonBase() {
				@Override
				public void onClick() {
					clearAction();
				}
			};
			Clear.setText("Clear", 'C');
			Clear.setBounds(366, 393, 158, 25);
		}
		return Clear;
	}

	public LabelBase getFootRemarkDesc() {
		if (FootRemarkDesc == null) {
			FootRemarkDesc = new LabelBase();
			FootRemarkDesc.setText("Hint: Enter the EDC and check for bed availability");
			FootRemarkDesc.setBounds(29, 423, 376, 20);
		}
		return FootRemarkDesc;
	}

	public BasePanel getOBPreBookPanel() {
		if (OBPreBookPanel == null) {
			OBPreBookPanel = new BasePanel();
			OBPreBookPanel.add(getOBPreBookParaPanel(), null);
			OBPreBookPanel.add(getBookingScrollPane());
			OBPreBookPanel.add(getPreIPReg());
			OBPreBookPanel.add(getPreOTAB());
			OBPreBookPanel.add(getPrePBL());
			OBPreBookPanel.add(getPrePSL());
			OBPreBookPanel.add(getSearchCertBtn());
			OBPreBookPanel.add(getPreCountDesc());
			OBPreBookPanel.add(getPreCount());
		}
		return OBPreBookPanel;
	}

	public BasePanel getOBPreBookParaPanel() {
		if (OBPreBookParaPanel == null) {
			OBPreBookParaPanel = new BasePanel();
			OBPreBookParaPanel.setHeading("OB Pre-Booking Listing");
			OBPreBookParaPanel.add(getPrePatientNoDesc(), null);
			OBPreBookParaPanel.add(getPrePatientNo(), null);
			OBPreBookParaPanel.add(getPreDocDesc(), null);
			OBPreBookParaPanel.add(getPreDoc(), null);
			OBPreBookParaPanel.add(getPreNameDesc(), null);
			OBPreBookParaPanel.add(getPreName(), null);
			OBPreBookParaPanel.add(getPreChiNameDesc(), null);
			OBPreBookParaPanel.add(getPreChiName(), null);
			OBPreBookParaPanel.add(getPreDrCodeDesc(), null);
			OBPreBookParaPanel.add(getPreDrCode(), null);
			OBPreBookParaPanel.add(getPreDrNameDesc(), null);
			OBPreBookParaPanel.add(getPreDrName(), null);
			OBPreBookParaPanel.add(getPreBookTypeDesc(), null);
			OBPreBookParaPanel.add(getPreBookType(), null);
			OBPreBookParaPanel.add(getPreSortByDesc(), null);
			OBPreBookParaPanel.add(getPreSortBy(), null);
			OBPreBookParaPanel.add(getPreSchdADateFromDesc(), null);
			OBPreBookParaPanel.add(getPreSchdADateFrom(), null);
			OBPreBookParaPanel.add(getPreSchdADateToDesc(), null);
			OBPreBookParaPanel.add(getPreSchdADateTo(), null);
			OBPreBookParaPanel.add(getPreDeposit(), null);
			OBPreBookParaPanel.add(getPreDepositDesc(), null);
			OBPreBookParaPanel.add(getPreShowCancelDesc(), null);
			OBPreBookParaPanel.add(getPreShowCancel(), null);
			OBPreBookParaPanel.add(getPreOrdDateFrom(), null);
			OBPreBookParaPanel.add(getPreOrdDateFromDesc(), null);
			OBPreBookParaPanel.add(getPreOrdDateTo(), null);
			OBPreBookParaPanel.add(getPreOrdDateToDesc(), null);
			OBPreBookParaPanel.add(getEDCDateFrom(), null);
			OBPreBookParaPanel.add(getEDCDateFromDesc(), null);
			OBPreBookParaPanel.add(getEDCDateTo(), null);
			OBPreBookParaPanel.add(getEDCDateToDesc(), null);
			OBPreBookParaPanel.add(getObBokStatusDesc());
			OBPreBookParaPanel.setBounds(5, 5, 795, 130);
		}
		return OBPreBookParaPanel;
	}

	public LabelBase getObBokStatusDesc() {
		if (obBokStatusDesc == null) {
			obBokStatusDesc = new LabelBase();
			obBokStatusDesc.resetText();
			obBokStatusDesc.setVisible(false);
		}
		return obBokStatusDesc;
	}

	public LabelBase getPrePatientNoDesc() {
		if (PrePatientNoDesc == null) {
			PrePatientNoDesc = new LabelBase();
			PrePatientNoDesc.setText("Patient No:");
			PrePatientNoDesc.setBounds(11, 10, 71, 20);
		}
		return PrePatientNoDesc;
	}

	public TextPatientNoSearch getPrePatientNo() {
		if (PrePatientNo == null) {
			PrePatientNo = new TextPatientNoSearch(false);
			PrePatientNo.setBounds(82, 10, 101, 20);
			PrePatientNo.setShowAllAlert(false);
		}
		return PrePatientNo;
	}

	public LabelBase getPreDocDesc() {
		if (PreDocDesc == null) {
			PreDocDesc = new LabelBase();
			PreDocDesc.setText("Document #:");
			PreDocDesc.setBounds(195, 10, 82, 20);
		}
		return PreDocDesc;
	}

	public TextString getPreDoc() {
		if (PreDoc == null) {
			PreDoc = new TextString();
			PreDoc.setBounds(276, 10, 101, 20);
		}
		return PreDoc;
	}

	public LabelBase getPreNameDesc() {
		if (PreNameDesc == null) {
			PreNameDesc = new LabelBase();
			PreNameDesc.setText("Name:");
			PreNameDesc.setBounds(442, 10, 46, 20);
		}
		return PreNameDesc;
	}

	public TextString getPreName() {
		if (PreName == null) {
			PreName = new TextString();
			PreName.setBounds(485, 10, 101, 20);
		}
		return PreName;
	}

	public LabelBase getPreChiNameDesc() {
		if (PreChiNameDesc == null) {
			PreChiNameDesc = new LabelBase();
			PreChiNameDesc.setText("Chi. Name:");
			PreChiNameDesc.setBounds(610, 10, 70, 20);
		}
		return PreChiNameDesc;
	}

	public TextString getPreChiName() {
		if (PreChiName == null) {
			PreChiName = new TextString();
			PreChiName.setBounds(690, 10, 95, 20);
		}
		return PreChiName;
	}

	public LabelBase getPreDrCodeDesc() {
		if (PreDrCodeDesc == null) {
			PreDrCodeDesc = new LabelBase();
			PreDrCodeDesc.setText("Dr. Code:");
			PreDrCodeDesc.setBounds(11, 40, 71, 20);
		}
		return PreDrCodeDesc;
	}

	public TextDoctorSearch getPreDrCode() {
		if (PreDrCode == null) {
			PreDrCode = new TextDoctorSearch();
			PreDrCode.setBounds(82, 40, 101, 20);
		}
		return PreDrCode;
	}

	public LabelBase getPreDrNameDesc() {
		if (PreDrNameDesc == null) {
			PreDrNameDesc = new LabelBase();
			PreDrNameDesc.setText("Dr. Name:");
			PreDrNameDesc.setBounds(195, 40, 65, 20);
		}
		return PreDrNameDesc;
	}

	public TextString getPreDrName() {
		if (PreDrName == null) {
			PreDrName = new TextString();
			PreDrName.setBounds(276, 40, 101, 20);
		}
		return PreDrName;
	}

	public LabelBase getPreBookTypeDesc() {
		if (PreBookTypeDesc == null) {
			PreBookTypeDesc = new LabelBase();
			PreBookTypeDesc.setText("Booking #/Type:");
			PreBookTypeDesc.setBounds(390, 40, 106, 20);
		}
		return PreBookTypeDesc;
	}

	public ComboBookType getPreBookType() {
		if (PreBookType == null) {
			PreBookType = new ComboBookType();
			PreBookType.setBounds(486, 40, 101, 20);
		}
		return PreBookType;
	}

	public LabelBase getPreSortByDesc() {
		if (PreSortByDesc == null) {
			PreSortByDesc = new LabelBase();
			PreSortByDesc.setText("Sort by:");
			PreSortByDesc.setBounds(610, 40, 52, 20);
		}
		return PreSortByDesc;
	}

	public ComboSortPatStatPrePara getPreSortBy() {
		if (PreSortBy == null) {
			PreSortBy = new ComboSortPatStatPrePara();
			PreSortBy.setShowClearButton(false);
			PreSortBy.setBounds(690, 40, 95, 20);
		}
		return PreSortBy;
	}

	public LabelBase getPreSchdADateFromDesc() {
		if (PreSchdADateFromDesc == null) {
			PreSchdADateFromDesc = new LabelBase();
			PreSchdADateFromDesc.setText("Schd Adm Date From:");
			PreSchdADateFromDesc.setBounds(11, 70, 122, 20);
		}
		return PreSchdADateFromDesc;
	}

	public TextDate getPreSchdADateFrom() {
		if (PreSchdADateFrom == null) {
			PreSchdADateFrom = new TextDate();
			PreSchdADateFrom.setBounds(131, 70, 118, 20);
		}
		return PreSchdADateFrom;
	}

	public LabelBase getPreSchdADateToDesc() {
		if (PreSchdADateToDesc == null) {
			PreSchdADateToDesc = new LabelBase();
			PreSchdADateToDesc.setText("to:");
			PreSchdADateToDesc.setBounds(257, 70, 20, 20);
		}
		return PreSchdADateToDesc;
	}

	public TextDate getPreSchdADateTo() {
		if (PreSchdADateTo == null) {
			PreSchdADateTo = new TextDate();
			PreSchdADateTo.setBounds(276, 70, 118, 20);
		}
		return PreSchdADateTo;
	}

	public LabelBase getPreDepositDesc() {
		if (PreDepositDesc == null) {
			PreDepositDesc = new LabelBase();
			PreDepositDesc.setText("Deposit:");
			PreDepositDesc.setBounds(435, 70, 55, 20);
		}
		return PreDepositDesc;
	}

	public ComboDeposit getPreDeposit() {
		if (PreDeposit == null) {
			PreDeposit = new ComboDeposit();
			PreDeposit.setBounds(486, 70, 101, 20);
		}
		return PreDeposit;
	}

	public LabelBase getPreShowCancelDesc() {
		if (PreShowCancelDesc == null) {
			PreShowCancelDesc = new LabelBase();
			PreShowCancelDesc.setText("Status:");
			PreShowCancelDesc.setBounds(610, 70, 52, 20);
		}
		return PreShowCancelDesc;
	}

	public ComboBoxBase getPreShowCancel() {
		if (PreShowCancel == null) {
			PreShowCancel = new ComboBoxBase() {
				public void resetText() {
					setSelectedIndex(0);
				}
			};
			PreShowCancel.setBounds(690, 70, 95, 20);
			PreShowCancel.setShowClearButton(false);
			PreShowCancel.addItem("N", "Normal");
			PreShowCancel.addItem("F", "Admitted");
			PreShowCancel.addItem("D", "Cancelled");
			PreShowCancel.addItem("W", "Waiting");
			PreShowCancel.setSelectedIndex(0);
		}
		return PreShowCancel;
	}

	public LabelBase getPreOrdDateFromDesc() {
		if (PreOrdDateFromDesc == null) {
			PreOrdDateFromDesc = new LabelBase();
			PreOrdDateFromDesc.setText("Order Date From:");
			PreOrdDateFromDesc.setBounds(11, 100, 122, 20);
		}
		return PreOrdDateFromDesc;
	}

	public TextDate getPreOrdDateFrom() {
		if (PreOrdDateFrom == null) {
			PreOrdDateFrom = new TextDate();
			PreOrdDateFrom.setBounds(131, 100, 118, 20);
		}
		return PreOrdDateFrom;
	}

	public LabelBase getPreOrdDateToDesc() {
		if (PreOrdDateToDesc == null) {
			PreOrdDateToDesc = new LabelBase();
			PreOrdDateToDesc.setText("to:");
			PreOrdDateToDesc.setBounds(257, 100, 20, 20);
		}
		return PreOrdDateToDesc;
	}

	public TextDate getPreOrdDateTo() {
		if (PreOrdDateTo == null) {
			PreOrdDateTo = new TextDate();
			PreOrdDateTo.setBounds(277, 100, 118, 20);
		}
		return PreOrdDateTo;
	}

	public LabelBase getEDCDateFromDesc() {
		if (EDCDateFromDesc == null) {
			EDCDateFromDesc = new LabelBase();
			EDCDateFromDesc.setText("EDC From:");
			EDCDateFromDesc.setBounds(420, 100, 65, 20);
		}
		return EDCDateFromDesc;
	}

	public TextDate getEDCDateFrom() {
		if (EDCDateFrom == null) {
			EDCDateFrom = new TextDate();
			EDCDateFrom.setBounds(485, 100, 118, 20);
		}
		return EDCDateFrom;
	}

	public LabelBase getEDCDateToDesc() {
		if (EDCDateToDesc == null) {
			EDCDateToDesc = new LabelBase();
			EDCDateToDesc.setText("to:");
			EDCDateToDesc.setBounds(610, 100, 20, 20);
		}
		return EDCDateToDesc;
	}

	public TextDate getEDCDateTo() {
		if (EDCDateTo == null) {
			EDCDateTo = new TextDate();
			EDCDateTo.setBounds(630, 100, 118, 20);
		}
		return EDCDateTo;
	}

	/**
	 * This method initializes jScrollPane
	 *
	 * @return JScrollPane
	 */
	protected JScrollPane getBookingScrollPane() {
		if (bookingScrollPanel == null) {
			getJScrollPane().removeViewportView(getListTable());
			bookingScrollPanel = new JScrollPane();
			bookingScrollPanel.setViewportView(getListTable());
			bookingScrollPanel.setBounds(5, 140, 795, 285);
		}
		return bookingScrollPanel;
	}

	public ButtonBase getPreIPReg() {
		if (PreIPReg == null) {
			PreIPReg = new ButtonBase() {
				@Override
				public void onClick() {
					IPReg();
				}
			};
			PreIPReg.setText("IP Registration", 'I');
			PreIPReg.setBounds(5, 444, 100, 25);
		}
		return PreIPReg;
	}

	public ButtonBase getPrePBL() {
		if (PrePBL == null) {
			PrePBL = new ButtonBase() {
				@Override
				public void onClick() {
					if (getListTable().getSelectedRow() == -1) {
						return;
					}
					HashMap<String, String> map = new HashMap<String, String>();
					map.put("Image", CommonUtil.getReportImg("rpt_logo2.jpg"));
					PrintingUtil.print("OBBooking_"+Factory.getInstance().getUserInfo().getSiteCode(), map,"",
							new String[] {getListTable().getSelectedRowContent()[GrdOBCol_bpbid]},
							new String[] {"PATNAME","PATCNAME","BPBHDATE","BPBNO",
							"DOCNAME","DOCFAXNO","DOCOTEL","PRINTDATE"});
				}
			};
			PrePBL.setText("Print Booking Letter");
			PrePBL.setBounds(110, 444, 130, 25);
			PrePBL.setEnabled(isPrePBLWork);
		}
		return PrePBL;
	}

	public ButtonBase getPreOTAB() {
		if (PreOTAB == null) {
			PreOTAB = new ButtonBase() {
				@Override
				public void onClick() {
					setParameter("lotPBPID", getListSelectedRow()[GrdOBCol_bpbid]);
					setParameter("FromPreBooking", "srhPatStsView");
//					setParameter("edate", getListSelectedRow()[11]);
//					setParameter("patno", getListSelectedRow()[3]);
					showPanel(new OTAppointmentBrowse());
				}
			};
			PreOTAB.setText("OT Appointment Browse", 'O');
			PreOTAB.setBounds(245, 444, 150, 25);
		}
		return PreOTAB;
	}

	public ButtonBase getPrePSL() {
		if (PrePSL == null) {
			PrePSL = new ButtonBase() {
				@Override
				public void onClick() {
					printOBBooking();
				}
			};
			PrePSL.setText("Prt N$ (Scrh List)", 'N');
			PrePSL.setBounds(400, 444, 120, 25);
		}
		return PrePSL;
	}

	public ButtonBase getSearchCertBtn() {
		if (searchCertBtn == null) {
			searchCertBtn = new ButtonBase() {
				@Override
				public void onClick() {
					setParameter("currMode","searchCert");
					showPanel(new PrintOBCert());
				}
			};
			searchCertBtn.setText("Search OB Cert");
			searchCertBtn.setBounds(525, 444, 110, 25);
		}
		return searchCertBtn;
	}

	public LabelBase getPreCountDesc() {
		if (PreCountDesc == null) {
			PreCountDesc = new LabelBase();
			PreCountDesc.setText("Count:");
			PreCountDesc.setBounds(685, 444, 47, 20);
		}
		return PreCountDesc;
	}

	public TextReadOnly getPreCount() {
		if (PreCount == null) {
			PreCount = new TextReadOnly();
			PreCount.setBounds(735, 444, 66, 20);
		}
		return PreCount;
	}

	private Menu getPopupMenu() {
		if (contextMenu == null) {
			contextMenu = new Menu();

			// set context menu
			contextMenu.setWidth(140);
			contextMenu.add(getEditBookingMenu());
			contextMenu.add(getDeleteBookingMenu());
			contextMenu.add(getReactiveBookingMenu());
			contextMenu.add(getConfirmBookingMenu());
		}
		return contextMenu;
	}

	public MenuItem getEditBookingMenu() {
		if (editBooking == null) {
			editBooking = new MenuItem();
			editBooking.setText("Edit Booking");
			editBooking.setIcon(Resources.ICONS.edit());
			editBooking.addSelectionListener(new SelectionListener<MenuEvent>() {
				public void componentSelected(MenuEvent ce) {
					modifyAction();
				}
			});
		}
		return editBooking;
	}

	public MenuItem getDeleteBookingMenu() {
		if (deleteBooking == null) {
			deleteBooking = new MenuItem();
			deleteBooking.setText("Delete Booking");
			deleteBooking.setIcon(Resources.ICONS.delete());
			deleteBooking.addSelectionListener(new SelectionListener<MenuEvent>() {
				public void componentSelected(MenuEvent ce) {
					deleteAction();
				}
			});
		}
		return deleteBooking;
	}

	public MenuItem getReactiveBookingMenu() {
		if (reactiveBooking == null) {
			reactiveBooking = new MenuItem();
			reactiveBooking.setText("Reactive Booking");
			reactiveBooking.setIcon(Resources.ICONS.refresh());
			reactiveBooking.addSelectionListener(new SelectionListener<MenuEvent>() {
				public void componentSelected(MenuEvent ce) {
					reactiveBooking();
				}
			});
		}
		return reactiveBooking;
	}

	public MenuItem getConfirmBookingMenu() {
		if (confirmBooking == null) {
			confirmBooking = new MenuItem();
			confirmBooking.setText("Confirm Booking");
			confirmBooking.setIcon(Resources.ICONS.save());
			confirmBooking.addSelectionListener(new SelectionListener<MenuEvent>() {
				public void componentSelected(MenuEvent ce) {
					confirmBooking();
				}
			});
		}
		return confirmBooking;
	}
}