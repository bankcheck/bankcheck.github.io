package com.hkah.server.servlet;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hkah.client.util.PasswordUtil;
import com.hkah.server.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.UserInfo;

import jcifs.smb.NtlmPasswordAuthentication;
import jcifs.smb.SmbFile;
import jcifs.smb.SmbFileInputStream;

public class GetCrystalReport extends HttpServlet {
	/**
	 *
	 */
	private static final long serialVersionUID = -7307845853392740391L;
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

		try {
			if (rptPath != null && reportname != null) {
				if (isWindow) {
					File rptFile = new File(rptPath+subDirPath+reportname);
					if (rptFile.exists()) {
						FileInputStream fileInputStream = new FileInputStream(rptFile);

						int bytes;
						while ((bytes = fileInputStream.read()) != -1) {
							response.getOutputStream().write(bytes);
						}

						response.getOutputStream().flush();
						response.getOutputStream().close();
						fileInputStream.close();
					}
				} else {
					String login_user = getReportLoginID();
					String login_pass = getReportLoginPwd();
					NtlmPasswordAuthentication auth = new NtlmPasswordAuthentication("", login_user, login_pass);
					System.out.println("GetCrystalReport....");
					SmbFile rptFile = new SmbFile("smb:"+rptPath.replace("\\", "/")+"/"+subDirPath.replace("\\", "/")+reportname, auth);

					if (rptFile.exists()) {
						SmbFileInputStream fileInputStream = new SmbFileInputStream(rptFile);

						int bytes;
						while ((bytes = fileInputStream.read()) != -1) {
							response.getOutputStream().write(bytes);
						}
						response.getOutputStream().flush();
						response.getOutputStream().close();
						fileInputStream.close();
					}
				}
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

