package com.hkah.server.services;

import java.io.File;
import java.io.FilenameFilter;
import java.net.MalformedURLException;

import com.google.gwt.user.server.rpc.RemoteServiceServlet;
import com.hkah.client.services.DayendReportListService;
import com.hkah.client.util.PasswordUtil;
import com.hkah.server.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.UserInfo;

import jcifs.smb.NtlmPasswordAuthentication;
import jcifs.smb.SmbException;
import jcifs.smb.SmbFile;
import jcifs.smb.SmbFilenameFilter;

public class DayendReportListServiceImpl extends RemoteServiceServlet implements DayendReportListService {

	/**
	 *
	 */
	private static final long serialVersionUID = -4170719073796490297L;
	private static String report_login_user = null;
	private static String report_login_pass = null;

	@Override
	public String[] getReportList(String rootPath, String dayOfWeek, boolean isHistory, final String filter) {
		boolean isWindow = System.getProperty("os.name").toLowerCase().startsWith("windows");

		if (isWindow) {
			File rootDir = new File(rootPath);
			File rptDir = null;

			if (!isHistory) {
				rptDir = new File(rootPath + "DayEnd\\\\" + dayOfWeek);
				if (!rootDir.exists() || !rptDir.exists()) {
					return null;
				}
			} else if (filter != null) {
				if (filter.startsWith("CL")) {
					rptDir = new File(rootPath);
					if (!rootDir.exists() || !rptDir.exists()) {
						return null;
					}
				}
			} else {
				rptDir = new File(rootPath + "DayEnd\\Report\\\\" + dayOfWeek);
				if (!rptDir.exists() && isHistory) {
					rptDir = new File(rootPath + "DayEnd\\Report\\\\" + dayOfWeek.substring(0,4)+"\\\\"+dayOfWeek);
				}

				if (!rootDir.exists() || !rptDir.exists()) {
					return null;
				}
			}

			if (filter != null) {
				return rptDir.list(new FilenameFilter() {
					@Override
					public boolean accept(File dir, String name) {
						return name.startsWith(filter);
					}
				});
			} else {
				return rptDir.list();
			}
		} else {
			String login_user = getReportLoginID();
			String login_pass = getReportLoginPwd();
			NtlmPasswordAuthentication auth = new NtlmPasswordAuthentication("", login_user, login_pass);

			try {
				SmbFile rootDir = new SmbFile("smb:"+rootPath.replace("\\", "/"), auth);
				SmbFile rptDir = null;

				if (!isHistory) {
					rptDir = new SmbFile("smb:"+rootPath.replace("\\", "/")+"DayEnd/"+dayOfWeek+"/", auth);
				} else if (filter.startsWith("CL")) {
					rptDir = new SmbFile("smb:"+rootPath.replace("\\", "/"), auth);
				} else {
					rptDir = new SmbFile("smb:"+rootPath.replace("\\", "/")+"DayEnd/Report/"+dayOfWeek+"/", auth);
				}

				if (rootDir == null || rptDir == null || !rootDir.exists() || !rptDir.exists()) {
					return null;
				}

				if (filter != null) {
					return rptDir.list(new SmbFilenameFilter() {
						@Override
						public boolean accept(SmbFile arg0, String arg1)
								throws SmbException {
							return arg1.startsWith(filter);
						}
					});
				} else {
					return rptDir.list();
				}
			} catch (MalformedURLException e) {
				e.printStackTrace();
				return null;
			} catch (SmbException e) {
				e.printStackTrace();
				return null;
			}
		}
	}

	private String getReportLoginID() {
		if (report_login_user == null) {
			report_login_user = getSystemParameter("DERptUser");
		}
		return report_login_user;
	}

	private String getReportLoginPwd() {
		if (report_login_pass == null) {
			report_login_pass = PasswordUtil.cisDecryption(getSystemParameter("DERptPwd"));
		}
		return report_login_pass;
	}

	private String getSystemParameter(String paramName) {

		MessageQueue mQueue = QueryUtil.proceedTx(
				new UserInfo(), "NHS",
				ConstantsTx.SYSTEMPARAMETER_TXCODE,
				QueryUtil.getMasterServlet(),
				QueryUtil.ACTION_FETCH,
				new String[] { paramName },
				null, null, QueryUtil.getJndiName());
		if (mQueue.success()) {
			return mQueue.getContentField()[1];
		} else {
			return null;
		}
	}
}