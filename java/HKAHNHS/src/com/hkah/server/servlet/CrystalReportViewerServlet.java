package com.hkah.server.servlet;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Locale;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.crystaldecisions.report.web.viewer.CrystalReportViewer;
import com.crystaldecisions.sdk.occa.report.application.OpenReportOptions;
import com.crystaldecisions.sdk.occa.report.application.ReportClientDocument;
import com.hkah.client.util.PasswordUtil;
import com.hkah.server.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.UserInfo;

import jcifs.smb.NtlmPasswordAuthentication;
import jcifs.smb.SmbFile;
import jcifs.smb.SmbFileInputStream;

public class CrystalReportViewerServlet extends HttpServlet {

	/**
	 *
	 */
	private static final long serialVersionUID = -536504261957508865L;
	private static String report_path = null;
	private static String report_login_user = null;
	private static String report_login_pass = null;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		this.doPost(req , resp) ;
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) {
		boolean isWindow = System.getProperty("os.name").toLowerCase().startsWith("windows");
		String rptPath = getReportPath();
		String reportname = request.getParameter("rptname");
		String subDirPath = request.getParameter("sdp");

		ReportClientDocument reportClientDoc = null;

		try {
			if (rptPath != null && reportname != null) {
				if (isWindow) {
					File rptFile = new File(rptPath+subDirPath+reportname);
					if (rptFile.exists()) {
						reportClientDoc = new ReportClientDocument();
						reportClientDoc.setReportAppServer(ReportClientDocument.inprocConnectionString);
						reportClientDoc.open(rptPath+subDirPath+reportname, OpenReportOptions._openAsReadOnly);
					}
				} else {
					String login_user = getReportLoginID();
					String login_pass = getReportLoginPwd();
					NtlmPasswordAuthentication auth = new NtlmPasswordAuthentication("", login_user, login_pass);

					//System.out.println("CrystalReportViewerServlet....");
					SmbFile rptFile = new SmbFile("smb:"+rptPath.replace("\\", "/")+"/"+subDirPath.replace("\\", "/")+reportname, auth);

					String rprDir = getServletConfig().getServletContext().getRealPath("dayend/");
					String reportPath = getServletConfig().getServletContext().getRealPath("dayend/") +
										"\\" + reportname;
					File rootDir = new File(rprDir);
					File report = new File(reportPath);

					if (!rootDir.exists()) {
						//System.out.println("create dir....");
						rootDir.mkdirs();
					}

					if (rptFile.exists()) {
						if (!report.exists()) {
							report.createNewFile();
						} else {
							report.delete();
							report.createNewFile();
						}
						SmbFileInputStream fileInputStream = new SmbFileInputStream(rptFile);
						FileOutputStream outputStream = new FileOutputStream(report);

						int bytes;
						while ((bytes = fileInputStream.read()) != -1) {
							outputStream.write(bytes);
						}
						outputStream.flush();
						outputStream.close();
						fileInputStream.close();

						reportClientDoc = new ReportClientDocument();
						reportClientDoc.setReportAppServer(ReportClientDocument.inprocConnectionString);
						reportClientDoc.setLocale(Locale.UK);
						reportClientDoc.open(reportPath, OpenReportOptions._openAsReadOnly);
					}
				}

				CrystalReportViewer crystalReportViewer = new CrystalReportViewer();
				crystalReportViewer.setOwnPage(true);
				//crystalReportViewer.setOwnForm(true);
				crystalReportViewer.setDisplayToolbar(true);
				crystalReportViewer.setDisplayGroupTree(false);
				crystalReportViewer.setDisplayPage(true);
				crystalReportViewer.setHasPrintButton(false);
				crystalReportViewer.setHasExportButton(false);
				crystalReportViewer.setHasRefreshButton(false);
				crystalReportViewer.setHasSearchButton(false);
				crystalReportViewer.setHasToggleGroupTreeButton(false);
				crystalReportViewer.setHasToggleParameterPanelButton(false);
				crystalReportViewer.setHasLogo(false);
				crystalReportViewer.setReportSource(reportClientDoc.getReportSource());
				crystalReportViewer.setProductLocale(Locale.UK);
				request.getSession().setAttribute("ReportSource", reportClientDoc.getReportSource());
				reportClientDoc.close();
				response.setLocale(Locale.UK);
				crystalReportViewer.processHttpRequest(request, response, getServletContext(), null);
				crystalReportViewer.dispose();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private String getReportPath() {
		if (report_path == null) {
			report_path = getSystemParameter("DERptPath");
		}
		return report_path;
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