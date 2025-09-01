package com.hkah.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import com.hkah.constant.ConstantsErrorMessage;
import com.hkah.constant.ConstantsVariable;
import com.hkah.util.mail.UtilMail;
import com.hkah.util.queue.HKAHQUtl;

public class HKAHMailServlet extends HttpServlet implements ConstantsVariable, ConstantsErrorMessage {
	private static Logger logger = Logger.getLogger(HKAHMailServlet.class);

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {
		doGet(request, response);
	}

	public void doGet(	HttpServletRequest 	request, HttpServletResponse response)
			throws IOException, ServletException {
		boolean success = false;

		try {
			//=== Input Parm =======================================
			String 		from 		= request.getParameter("from");
			String 		toCsv	= request.getParameter("to");
			String[] 		to	= null;
			if (toCsv != null) {
				to = StringUtils.split(toCsv, ",");
			}
			String 		ccCsv	= request.getParameter("cc");
			String[] 		cc	= null;
			if (ccCsv != null) {
				cc = StringUtils.split(ccCsv, ",");
			}
			String 		bccCsv	= request.getParameter("bcc");
			String[] 		bcc	= null;
			if (bccCsv != null) {
				bcc = StringUtils.split(bccCsv, ",");
			}
			String 		subject = request.getParameter("subject");
			String 		message	= request.getParameter("message");
			if (message != null) {
				message = URLDecoder.decode(message, "UTF-8");
			}

			//=== Setting ==========================================
			request.setCharacterEncoding("UTF-8");
			response.setContentType("text/html; charset=UTF-8");

			//=== Send mail ========================================
			success = UtilMail.sendMail(from, to, cc, bcc, subject, message, null, null, false);

			//=== Output ===========================================
			StringBuffer	logStrBuf = new StringBuffer();
			PrintWriter 	output = response.getWriter();

			String retCode = null;
			String returnMsg = null;
			if (success) {
				retCode = RETURN_PASS;
				returnMsg = OK;
			} else {
				retCode = RETURN_FAIL;
				returnMsg = "Send fail";
			}
			String mailResult = HKAHQUtl.packHeader(EMPTY_VALUE, retCode, returnMsg);
			output.println(mailResult);
		} catch (Throwable th) {
			th.printStackTrace();
			logger.error("Throwable : " + th.toString());

			// log the start time and end time
			String host = null;
			String clientTimeStamp = null;
			if (request != null){
				host = request.getParameter("host");
				clientTimeStamp = request.getParameter("clientTimeStamp");
			}
			logger.error("Exception occur!, mail host=" + host + ", clientTimeStamp=" + clientTimeStamp + ", error=" + th.toString());
		}
	}
}
