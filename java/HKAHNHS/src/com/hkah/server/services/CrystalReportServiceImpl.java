package com.hkah.server.services;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Locale;

import com.crystaldecisions.sdk.occa.report.application.OpenReportOptions;
import com.crystaldecisions.sdk.occa.report.application.ReportClientDocument;
import com.crystaldecisions.sdk.occa.report.exportoptions.ReportExportFormat;
import com.google.gwt.user.server.rpc.RemoteServiceServlet;
import com.hkah.client.services.CrystalReportService;
import com.hkah.client.util.PasswordUtil;
import com.hkah.server.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.UserInfo;

import jcifs.smb.NtlmPasswordAuthentication;
import jcifs.smb.SmbFile;
import jcifs.smb.SmbFileInputStream;

public class CrystalReportServiceImpl extends RemoteServiceServlet implements CrystalReportService {
	/**
	 *
	 */
	private static final long serialVersionUID = -308037490949756475L;
	private static String report_login_user = null;
	private static String report_login_pass = null;

	private static void copyFileUsingFileStreams(File source, File dest) throws IOException {
		InputStream input = null;
		OutputStream output = null;
		try {
			input = new FileInputStream(source);
			output = new FileOutputStream(dest);
			byte[] buf = new byte[1024];
			int bytesRead;
			while ((bytesRead = input.read(buf)) > 0) {
				output.write(buf, 0, bytesRead);
			}
		} finally {
			input.close();
			output.close();
		}
	}

	private static void copyFileUsingFileStreams(SmbFile source, File dest) throws IOException {
		SmbFileInputStream input = null;
		OutputStream output = null;
		try {
			input = new SmbFileInputStream(source);
			output = new FileOutputStream(dest);
			byte[] buf = new byte[1024];
			int bytesRead;
			while ((bytesRead = input.read(buf)) > 0) {
				output.write(buf, 0, bytesRead);
			}
		} finally {
			input.close();
			output.close();
		}
	}

	public String getReportSource(String rptPath, String dayOfWeek, String reportname, boolean isHistory) {
		boolean isWindow = System.getProperty("os.name").toLowerCase().startsWith("windows");

		try {
			Calendar cal = Calendar.getInstance();
			cal.add(Calendar.DATE, -1);
			SimpleDateFormat dayFormat = new SimpleDateFormat("EEE", Locale.UK);
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd", Locale.UK);
			reportname = reportname.subSequence(0, reportname.length() - 4) + ".pdf";

			if (!isHistory) {
				while (!dayFormat.format(cal.getTime()).equalsIgnoreCase(dayOfWeek)) {
					cal.add(Calendar.DATE, -1);
				}
			}

			StringBuffer reportPath = new StringBuffer();
			if (isWindow) {
				File rptFile = null;

				if (!isHistory) {
					rptFile = new File(rptPath + "\\Report\\" + dateFormat.format(cal.getTime()) + ConstantsVariable.BACKSLASH_VALUE + reportname);
				} else {
					rptFile = new File(rptPath + "\\Report\\" + dayOfWeek + ConstantsVariable.BACKSLASH_VALUE + reportname);
				}
				if (rptFile.exists()) {
					reportPath.append(getServletConfig().getServletContext().getRealPath("dayend/"));
					reportPath.append(ConstantsVariable.BACKSLASH_VALUE);
					reportPath.append(rptFile.lastModified());
					reportPath.append(ConstantsVariable.UNDERSCORE_VALUE);
					reportPath.append(reportname);
					File report = new File(reportPath.toString());

					if (!report.getParentFile().exists()) {
						report.getParentFile().mkdirs();
					}

					if (!report.exists()) {
						copyFileUsingFileStreams(rptFile, report);
					}
				} else if (!rptFile.exists() && isHistory) {
					rptFile = new File(rptPath + "\\Report\\" + dayOfWeek.substring(0,4)+"\\\\"
								+ dayOfWeek + ConstantsVariable.BACKSLASH_VALUE + reportname);
					if (rptFile.exists()) {
						reportPath.append(getServletConfig().getServletContext().getRealPath("dayend/"));
						reportPath.append(ConstantsVariable.BACKSLASH_VALUE);
						reportPath.append(rptFile.lastModified());
						reportPath.append(ConstantsVariable.UNDERSCORE_VALUE);
						reportPath.append(reportname);
						File report = new File(reportPath.toString());

						if (!report.getParentFile().exists()) {
							report.getParentFile().mkdirs();
						}

						if (!report.exists()) {
							copyFileUsingFileStreams(rptFile, report);
						}
					}
				} else {
					// Gen the report
					if (!isHistory) {
						generateReport(isWindow,
								rptPath + ConstantsVariable.BACKSLASH_VALUE + dayOfWeek + ConstantsVariable.BACKSLASH_VALUE + reportname.subSequence(0, reportname.length() - 4) + ".rpt",
								rptPath + "\\Report\\" + dateFormat.format(cal.getTime()) + ConstantsVariable.BACKSLASH_VALUE + reportname);

						reportPath.append(getServletConfig().getServletContext().getRealPath("dayend/"));
						reportPath.append(ConstantsVariable.BACKSLASH_VALUE);
						reportPath.append(rptFile.lastModified());
						reportPath.append(ConstantsVariable.UNDERSCORE_VALUE);
						reportPath.append(reportname);
						File report = new File(reportPath.toString());
						copyFileUsingFileStreams(rptFile, report);
					}
				}

				return "dayend/" + rptFile.lastModified() + ConstantsVariable.UNDERSCORE_VALUE + reportname;
			} else {
				String login_user = getReportLoginID();
				String login_pass = getReportLoginPwd();
				NtlmPasswordAuthentication auth = new NtlmPasswordAuthentication("", login_user, login_pass);

				SmbFile rptFile = null;
				if (!isHistory) {
					rptFile = new SmbFile("smb:" + rptPath.replace(ConstantsVariable.BACKSLASH_VALUE, ConstantsVariable.SLASH_VALUE) + "/Report/" + dateFormat.format(cal.getTime()) + ConstantsVariable.SLASH_VALUE + reportname, auth);
				} else {
					rptFile = new SmbFile("smb:" + rptPath.replace(ConstantsVariable.BACKSLASH_VALUE, ConstantsVariable.SLASH_VALUE) + "/Report/" + dayOfWeek + ConstantsVariable.SLASH_VALUE + reportname, auth);
				}

				if (rptFile.exists()) {
					reportPath.append(getServletConfig().getServletContext().getRealPath("dayend/"));
					reportPath.append(ConstantsVariable.SLASH_VALUE);
					reportPath.append(rptFile.lastModified());
					reportPath.append(ConstantsVariable.UNDERSCORE_VALUE);
					reportPath.append(reportname);
					File report = new File(reportPath.toString());

					if (!report.getParentFile().exists()) {
						report.getParentFile().mkdirs();
					}

					if (!report.exists()) {
						copyFileUsingFileStreams(rptFile, report);
					}
				} else {
					// Gen the report
					if (!isHistory) {
						generateReport(isWindow,
								rptPath + ConstantsVariable.BACKSLASH_VALUE + dayOfWeek + ConstantsVariable.BACKSLASH_VALUE + reportname.subSequence(0, reportname.length() - 4) + ".rpt",
								rptPath + "\\Report\\" + dateFormat.format(cal.getTime()) + ConstantsVariable.BACKSLASH_VALUE + reportname);

						reportPath.append(getServletConfig().getServletContext().getRealPath("dayend/"));
						reportPath.append(ConstantsVariable.SLASH_VALUE);
						reportPath.append(rptFile.lastModified());
						reportPath.append(ConstantsVariable.UNDERSCORE_VALUE);
						reportPath.append(reportname);
						File report = new File(reportPath.toString());
						copyFileUsingFileStreams(rptFile, report);
					}
				}
				return "dayend/" + rptFile.lastModified() + ConstantsVariable.UNDERSCORE_VALUE + reportname;
			}
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	private boolean generateReport(boolean isWindow, String crystalRptPath, String pdfPath) {
		try {
			ReportClientDocument reportClientDoc = new ReportClientDocument();
			reportClientDoc.setReportAppServer(ReportClientDocument.inprocConnectionString);
			reportClientDoc.open(crystalRptPath, OpenReportOptions._openAsReadOnly);

			if (isWindow) {
				File rptFile = new File(crystalRptPath);

				if (rptFile.exists()) {
					File report = new File(pdfPath);
					if (!report.getParentFile().exists()) {
						report.getParentFile().mkdirs();
					}
					report.createNewFile();

					ByteArrayInputStream byteArrayInputStream =
						(ByteArrayInputStream) reportClientDoc.getPrintOutputController().export(ReportExportFormat.PDF);
					byte[] byteArray;
					int bytesRead;
					FileOutputStream fos = new FileOutputStream(report);

					byteArray = new byte[1024];
					while ((bytesRead = byteArrayInputStream.read(byteArray)) > 0) {
						fos.write(byteArray, 0, bytesRead);
					}

					byteArrayInputStream.close();
					fos.close();
					reportClientDoc.close();
				} else {
					return false;
				}
			} else {
				String login_user = getReportLoginID();
				String login_pass = getReportLoginPwd();
				NtlmPasswordAuthentication auth = new NtlmPasswordAuthentication("", login_user, login_pass);

				SmbFile rptFile = new SmbFile("smb://" + crystalRptPath.replace(ConstantsVariable.BACKSLASH_VALUE, ConstantsVariable.SLASH_VALUE), auth);

				if (rptFile.exists()) {
					File report = new File(pdfPath);
					if (!report.getParentFile().exists()) {
						report.getParentFile().mkdirs();
					}
					report.createNewFile();

					ByteArrayInputStream byteArrayInputStream =
						(ByteArrayInputStream) reportClientDoc.getPrintOutputController().export(ReportExportFormat.PDF);
					byte[] byteArray;
					int bytesRead;
					FileOutputStream fos = new FileOutputStream(report);

					byteArray = new byte[1024];
					while ((bytesRead = byteArrayInputStream.read(byteArray)) > 0) {
						fos.write(byteArray, 0, bytesRead);
					}

					byteArrayInputStream.close();
					fos.close();
					reportClientDoc.close();
				} else {
					return false;
				}
			}
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
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