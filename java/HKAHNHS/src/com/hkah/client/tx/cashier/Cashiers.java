package com.hkah.client.tx.cashier;

import java.util.HashMap;
import java.util.Map;

import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.MessageBox;
import com.extjs.gxt.ui.client.widget.ProgressBar;
import com.google.gwt.user.client.Timer;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.dialog.DlgReprintRpt;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.DefaultPanel;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.Report;
import com.hkah.shared.constants.ConstantsCashiers;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class Cashiers implements ConstantsCashiers, ConstantsVariable {
	public static boolean CASHIER_CARD_ERROR = false;
	public static String CASHIER_CARD_ERROR_CTNID = "";
	private static DlgReprintRpt reprintAuditDialog = null;

	public static void setCashierSignOn(DefaultPanel panel, boolean isClosePanel) {
		setCashierSignOn(panel, false, true, false, isClosePanel, null);
/*  -- Direct print report for testing
		QueryUtil.executeMasterFetch(Factory.getInstance().getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] {"Cashier", "TO_CHAR(CshOdate, 'dd/mm/yyyy hh24:mi:ss'), TO_CHAR(SYSDATE, 'dd/mm/yyyy hh24:mi:ss'), CshRcnt, CshCrcnt, CshVcnt, CshSID", "USRID ='PEGGY'"},
				new MessageQueueCallBack() {
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					printReport(new String[] { "PEG",mQueue.getContentField()[0], mQueue.getContentField()[1], mQueue.getContentField()[2], mQueue.getContentField()[3], mQueue.getContentField()[4], mQueue.getContentField()[5], mQueue.getContentField()[6] });
				}
			}
		});
*/
	}

	public static void setCashierSignOn(final DefaultPanel panel, final boolean closed, final boolean resignon, final boolean isPrintReport, final boolean isClosePanel, final String[] parameter) {
		if (!Factory.getInstance().getUserInfo().isCashier() || closed) {
			QueryUtil.executeMasterAction(Factory.getInstance().getUserInfo(),
					"CASHIERSIGNON", QueryUtil.ACTION_MODIFY,
					new String[] { Factory.getInstance().getUserInfo().getUserID(), CommonUtil.getComputerName(), closed?YES_VALUE:NO_VALUE, resignon?YES_VALUE:NO_VALUE},
					new MessageQueueCallBack() {
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						if (closed) {
							// store cashier code
							final String cashierCode = Factory.getInstance().getUserInfo().getCashierCode();

							// clear cashier code
							Factory.getInstance().getUserInfo().setCashierCode(EMPTY_VALUE);

							// print report
							if (isPrintReport) {
								MessageBox mb =
									MessageBoxBase.confirm(ConstantsMessage.MSG_PBA_SYSTEM, ConstantsMessage.MSG_CASHIER_CLOSE_COMPLETE + " Ready to print?",
											new Listener<MessageBoxEvent>() {
										public void handleEvent(MessageBoxEvent be) {
											if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
												printReport(new String[] { cashierCode, parameter[0], parameter[1], parameter[2], parameter[3], parameter[4], parameter[5] }
												, NO_VALUE);
											}
										}
									});

								mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
							} else {
								Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_CASHIER_CLOSE_COMPLETE, "PBA-[Patient Business Administration System]");
							}
						} else {
							Factory.getInstance().addInformationMessage("Sign on successfully.", "PBA-[Patient Business Administration System]");
							// store cashier code
							Factory.getInstance().getUserInfo().setCashierCode(mQueue.getReturnMsg());
							Factory.getInstance().getMainFrame().stopSysTimeoutCount();
						}
					} else {
						MessageBox mb = MessageBoxBase.confirm(ConstantsMessage.MSG_PBA_SYSTEM, mQueue.getReturnMsg() + " <font color='green'>Do you want to override signon?</font> <font color='red'>Please only click 'Yes' if you're <u>sure</u> the previous signon is not active</font>.",
								new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									QueryUtil.executeMasterAction(Factory.getInstance().getUserInfo(),
											"CASHIERSIGNONRESET", QueryUtil.ACTION_MODIFY,
											new String[] { Factory.getInstance().getUserInfo().getUserID(), CommonUtil.getComputerName()},
											new MessageQueueCallBack() {
										public void onPostSuccess(MessageQueue mQueue) {
											if (mQueue.success()) {
												setCashierSignOn(panel, closed, resignon, isPrintReport, isClosePanel, parameter);
											} else {
												Factory.getInstance().addErrorMessage(mQueue.getReturnMsg(), "PBA-[Patient Business Administration System]");
											}
										}
									});
								}
							}
						});
						mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.NO));
					}

					if (panel != null) panel.refreshAction();

					// exit panel
					if (isClosePanel) Factory.getInstance().showPanel();
				}
			});
		}
	}

	public static void setCashierSignOff(final BasePanel panel, final boolean isPrintReport, final boolean isCashierClose) {
		Factory.getInstance().getMainFrame().writeLog("Cashiers", "Info",
				"setCashierSignOff - Cashier [" + panel.getUserInfo().getCashierCode() + "]" +
				(isPrintReport ? " print report" : ""));
		if (!panel.getUserInfo().isCashier()) {
			return;
		}

		QueryUtil.executeMasterBrowse(panel.getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] { "Cashier", "TO_CHAR(CshOdate, 'dd/mm/yyyy hh24:mi:ss'), TO_CHAR(Sysdate, 'dd/mm/yyyy hh24:mi:ss'), CshRcnt, CshCrcnt, CshVcnt, CshSID", "Usrid='" + panel.getUserInfo().getUserID() + "'"},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(final MessageQueue mQueue) {
				if (mQueue.success()) {
					// set status off
					QueryUtil.executeMasterAction(panel.getUserInfo(),
							ConstantsTx.SIGNOFF_TXCODE,
							QueryUtil.ACTION_APPEND,
							new String[] {
									panel.getUserInfo().getUserID(),
									panel.getUserInfo().getCashierCode(),
									CommonUtil.getComputerName()
							},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue2) {
							if (mQueue2.success()) {
								if (isCashierClose) {
									if (isPrintReport) {
										setCashierClose(panel, true, new String[] { mQueue.getContentField()[0], mQueue.getContentField()[1], mQueue.getContentField()[2], mQueue.getContentField()[3], mQueue.getContentField()[4], mQueue.getContentField()[5] });
									} else {
										setCashierClose(panel, false, null);
									}
								} else {
									Factory.getInstance().addInformationMessage("Sign off successfully.", "PBA-[Patient Business Administration System]");
									Factory.getInstance().showPanel();

									// clear cashier code
									Factory.getInstance().getUserInfo().setCashierCode(EMPTY_VALUE);
								}
							}
						}
					});
				} else {
					Factory.getInstance().addErrorMessage("Fail to signoff cashier.", "PBA-[Patient Business Administration System]");
				}
			}
		});
	}

	private static void setCashierClose(final BasePanel panel, final boolean isPrintReport, final String[] parameter) {
		Factory.getInstance().getMainFrame().writeLog("Cashiers", "Info",
				"setCashierClose - Cashier [" + panel.getUserInfo().getCashierCode() + "]");

		final MessageBox progressBox = MessageBoxBase.progress("Please don't turn off the browser", "cashier closing...", "Initializing...");
		final ProgressBar progressBar = progressBox.getProgressBar();
		final Timer timer = new Timer() {
			float i = 0;
			String displayText = "Initializing...";

			@Override
			public void run() {
//				progressBar.updateProgress(i / 100, (int) i + "% Complete (" + displayText + ")");
				progressBar.updateProgress(i / 100, displayText);
				i += 1;
				if (i < 20) {
					displayText = "update cashier transaction";
				} else if (i < 30) {
					displayText = "update ar transaction";
				} else if (i < 60) {
					displayText = "update capture date";
				} else if (i > 95) {
					// stop schedule
					cancel();
				}
			}
		};
		timer.scheduleRepeating(200);

		QueryUtil.executeMasterAction(panel.getUserInfo(),
				ConstantsTx.CASHIERCLOSE, QueryUtil.ACTION_MODIFY,
				new String[] { panel.getUserInfo().getCashierCode(), panel.getUserInfo().getUserID() },
				new MessageQueueCallBack() {
			public void onPostSuccess(MessageQueue mQueue) {
				setCashierSignOn(null, true, false, isPrintReport, true, parameter);

				timer.cancel();
				progressBox.close();
				Factory.getInstance().resetSysTimeout();

				Factory.getInstance().addSystemMessage("Cashier Closed", "PBA-[Patient Business Administration System]");
				Factory.getInstance().showPanel();
			}
		});
	}

	public static void printReport(String[] parameter) {
		printReport(parameter, NO_VALUE);
	}

	public static void printReport(String[] parameter, String isPreview) {
		Map<String,String> map = new HashMap<String, String>();
		map.put("cashiercode", parameter[0]);
		map.put("startdate", parameter[1]);
		map.put("enddate", parameter[2]);
		map.put("cshrcnt", parameter[3]);
		map.put("cshcrcnt", parameter[4]);
		map.put("cshvcnt", parameter[5]);
		if (YES_VALUE.equals(isPreview)) {
			map.put("isScreen",  CommonUtil.getComputerName());
			Report.print(Factory.getInstance().getUserInfo(), "RptCshrAuditSess", map,
					new String[] { Factory.getInstance().getUserInfo().getSiteCode(), parameter[0], parameter[6] },
					new String[] { "TYPE", "CTXMETH", "CTNCTYPE", "CTXTYPE", "CTXSNO", "CTXNAME", "CTXDESC", "CTXAMT" },
					true);
		} else {
			map.put("isScreen",  "");
			PrintingUtil.print("RptCshrAuditSess", map, "",
					new String[] { Factory.getInstance().getUserInfo().getSiteCode(), parameter[0], parameter[6] },
					new String[] { "TYPE", "CTXMETH", "CTNCTYPE", "CTXTYPE", "CTXSNO", "CTXNAME", "CTXDESC", "CTXAMT" });

			getReprintAuditDialog().showDialog(parameter, YES_VALUE.equals(Factory.getInstance().getSysParameter("REPTPREVW")));
		}
	}

	private static DlgReprintRpt getReprintAuditDialog() {
		if (reprintAuditDialog == null) {
			reprintAuditDialog = new DlgReprintRpt(Factory.getInstance().getMainFrame(), "Cashier Close Report") {
				@Override
				public void reprint() {
					if (getParameter() != null) {
						printReport(getParameter(), NO_VALUE);
					}
				}

				@Override
				public  void doPreviewRpt(){
					printReport(getParameter(),Factory.getInstance().getSysParameter("REPTPREVW"));
					dispose();
				};

				@Override
				public void TabAndArrowKeyEvent(ComponentEvent ce) {
					if (ce.getKeyCode() == 9) {
						this.focus();
						if (getFocusWidget().equals(getButtonById(YES))) {
							setFocusWidget(getButtonById(NO));
							getButtonById(NO).focus();
						} else if (getFocusWidget().equals(getButtonById(NO))) {
							setFocusWidget(getButtonById(CANCEL));
							getButtonById(CANCEL).focus();
						} else if (getFocusWidget().equals(getButtonById(CANCEL))) {
							setFocusWidget(getButtonById(YES));
							getButtonById(YES).focus();
						}
					} else if (ce.getKeyCode() == 37 || ce.getKeyCode() == 39) {
						if (getFocusWidget().equals(getButtonById(YES))) {
							setFocusWidget(getButtonById(NO));
							getButtonById(NO).focus();
						} else if (getFocusWidget().equals(getButtonById(NO))) {
							setFocusWidget(getButtonById(CANCEL));
							getButtonById(CANCEL).focus();
						} else if (getFocusWidget().equals(getButtonById(CANCEL))) {
							setFocusWidget(getButtonById(YES));
							getButtonById(YES).focus();
						}
					}
				}
			};
			reprintAuditDialog.setResizable(false);
		}
		return reprintAuditDialog;
	}
}