package com.hkah.client.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.extjs.gxt.ui.client.Registry;
import com.google.gwt.user.client.rpc.AsyncCallback;
import com.hkah.client.AbstractEntryPoint;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.dialog.DlgPatientAlert;
import com.hkah.client.services.AlertServiceAsync;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class AlertCheck implements ConstantsVariable {

	public final static String GALTMALEMAIL = "MAILALERT";
	public final static String GALTMALPTH = "MAILPATH";
	public final static String GALTMALURL = "MAILURL";
	public final static String GALTMALFLAG = "MAILFLAG";
	public final static String PORTAL_VALUE = "PORTAL";

	private DlgPatientAlert dlgPatientAlert = null;
	private boolean memIsEmailAlert = false;
//	private String memPatno = null;
//	private String memFunname = null;
//	private String memGaltMalPth = null;
//	private boolean memIsDialogueAlert = false;
//	private Map<String, String> memParams = null;

	public void checkAltAccess(final String patno, final String funname,
			final boolean isDialogueAlert, final boolean isEmailAlert,
			final Map<String, String> params) {
		checkAltAccess(patno, null, funname, isDialogueAlert, isEmailAlert, params);
	}

	public void checkAltAccess(final String patno, final String alertgroup, final String funname,
			final boolean isDialogueAlert, final boolean isEmailAlert,
			final Map<String, String> params) {
		memIsEmailAlert = isEmailAlert;
//		memPatno = patno;
//		memFunname = funname;
//		memIsDialogueAlert = isDialogueAlert;
//		memParams = params;

		if (patno == null || "".equals(patno.trim())) {
			checkAltAccessPostAction(true);
		} else {
			if (isDialogueAlert) {
				// show patient alert dialog
				getDlgPatientAlert().showDialog(patno);
			}

			if (isEmailAlert) {
				checkAltAccessMail(patno, alertgroup, funname, params);
			}
		}
	}

	public void checkAltAccessPostAction(boolean ret) {}

	public void checkAltOSBill(String patno) {
		if (patno == null || "".equals(patno.trim())) {
			return;
		}

		// not implemented
		checkAltOSBillPostAction();
	}

	public void checkAltOSBillPostAction() {}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	private DlgPatientAlert getDlgPatientAlert() {
		if (dlgPatientAlert == null) {
			dlgPatientAlert = new DlgPatientAlert(Factory.getInstance().getMainFrame()) {
				@Override
				protected void post(boolean success) {
					if (success && !memIsEmailAlert) {
						checkAltAccessPostAction(true);
					}
				}
			};
		}
		return dlgPatientAlert;
	}

	private void checkAltAccessMail(final String patno, final String alertgroup, final String funname,
			final Map<String, String> params) {
		QueryUtil.executeMasterBrowse(Factory.getInstance().getUserInfo(),
				"SEARCHALERT", new String[] {patno, alertgroup}, new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					String[] record = TextUtil.split(mQueue.getContentAsQueue(), TextUtil.LINE_DELIMITER);
					String[] fields = null;
					List<String> address = new ArrayList<String>();
					for (int i = 0; i < record.length; i++) {
						fields = TextUtil.split(record[i]);
						if (!TextUtil.FIELD_DELIMITER.equals(record[i])) {
							for (int n=0; n<fields.length; n++) {
								address.add(fields[n]);
							}
						}
					}
					composeMail(patno, funname, params, address);
				} else {
					checkAltAccessPostAction(false);
				}
			}
		});
	}

	private void composeMail(String patno, String funname,
			Map<String, String> params, List<String> address) {
		if (address != null && !address.isEmpty()) {
			String gAltMalEmail = Factory.getInstance().getSysParameter(GALTMALEMAIL);
			String gAltMalPth = Factory.getInstance().getSysParameter(GALTMALPTH);
			String gAltMalUrl = Factory.getInstance().getSysParameter(GALTMALURL);
			boolean thruPortal = PORTAL_VALUE.equals(Factory.getInstance().getSysParameter(GALTMALFLAG));
			if (gAltMalPth != null && !gAltMalPth.isEmpty()) {
				composeMail(patno, funname, params, address,
						gAltMalEmail, gAltMalPth, gAltMalUrl, thruPortal);
			} else {
				checkAltAccessPostAction(false);
			}
		}
	}

	private void composeMail(final String patno, final String funname,
			final Map<String, String> params, final List<String> address,
			final String gAltMalEmail, final String gAltMalPth, final String gAltMalUrl, final boolean thruPortal) {
		QueryUtil.executeMasterBrowse(Factory.getInstance().getUserInfo(), "SEARCH_TALERT",
				new String[] { patno, null }, new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					Map<String, List<String>> addrAltdesc = new HashMap<String, List<String>>();
					for (String addr : address) {
						addrAltdesc.put(addr, new ArrayList<String>());
					}
					List<String[]> results = mQueue.getContentAsArray();
					String addr = null;
					List<String> desc = null;
					for (String[] res : results) {
						if (res != null) {
							addr = res[3];
							desc = addrAltdesc.get(addr);
							desc.add(res[2]);
						}
					}

					composeMail(patno, funname, params, addrAltdesc,
							gAltMalEmail, gAltMalPth, gAltMalUrl, thruPortal);
				}
			}

			@Override
			public void onFailure(Throwable caught) {
				super.onFailure(caught);
				checkAltAccessPostAction(false);
			}
		});
	}

	private void composeMail(final String patno, final String funname,
			final Map<String, String> params, final Map<String, List<String>> addrAltdesc,
			final String gAltMalEmail, final String gAltMalPth, final String gAltMalUrl, final boolean thruPortal) {
//		StringBuffer addressStr = new StringBuffer();
//		Set<String> keys = addrAltdesc.keySet();
//		Iterator<String> it = keys.iterator();
//		String addr = null;
//		while (it.hasNext()) {
//			addr = it.next();
//			if (addr != null) {
//				if (addressStr.length() > 0) {
//					addressStr.append(COMMA_VALUE);
//				}
//				addressStr.append(addr);
//			}
//		}

		QueryUtil.executeMasterFetch(Factory.getInstance().getUserInfo(), "PATIENTBYNO",
				new String[] { patno },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					String patfname = mQueue.getContentField()[0];
					String patgname = mQueue.getContentField()[1];
					String patcname = mQueue.getContentField()[6];
					String miscRemark = mQueue.getContentField()[8];

					composeMail2(patno, funname, params, addrAltdesc,
							gAltMalEmail, gAltMalPth, gAltMalUrl,
							patfname, patgname, patcname, miscRemark, thruPortal);
				} else {
					composeMail2(patno, funname, params, addrAltdesc,
							gAltMalEmail, gAltMalPth, gAltMalUrl,
							"Unknown", null, null, null, thruPortal);
				}
			}

			@Override
			public void onFailure(Throwable caught) {
				composeMail2(patno, funname, params, addrAltdesc,
						gAltMalEmail, gAltMalPth, gAltMalUrl,
						"Unknown", null, null, null, thruPortal);
			}
		});
	}

	private void composeMail2(final String patno, final String funname,
			final Map<String, String> params, final Map<String, List<String>> addrAltdescs,
			String gAltMalEmail, String gAltMalPth, String gAltMalUrl,
			final String patfname, final String patgname, String patcname, String miscRemark, boolean thruPortal) {
//		System.out.println("[EmailAlert] Call Alert web service........");
		((AlertServiceAsync) Registry
				.get(AbstractEntryPoint.ALERT_SERVICE)).patientMailAlert(
						Factory.getInstance().getUserInfo(), patno, funname,
						params, addrAltdescs,
						gAltMalEmail, gAltMalPth, gAltMalUrl,
						patfname, patgname, patcname, miscRemark, thruPortal,
							new AsyncCallback<MessageQueue>() {
					@Override
					public void onSuccess(MessageQueue result) {
						//System.out.println("[EmailAlert] Call Alert web service success........");
						if (result.success()) {
							System.out.println("[EmailAlert] Call Alert web service success........");
							checkAltAccessPostAction(true);
						}
					}

					@Override
					public void onFailure(Throwable caught) {
						//System.out.println("[EmailAlert] Call Alert web service failure........");
						checkAltAccessPostAction(false);
					}
				});
	}
}