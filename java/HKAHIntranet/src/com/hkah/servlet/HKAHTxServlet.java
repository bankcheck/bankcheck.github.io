/*
 * Created on July 29, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import org.apache.log4j.Logger;

import com.hkah.constant.ConstantsErrorMessage;
import com.hkah.util.Crypt;
import com.hkah.util.TextUtil;
import com.hkah.util.db.UtilDBWeb;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class HKAHTxServlet extends HttpServlet implements ConstantsErrorMessage {

	//======================================================================
	private static Logger logger = Logger.getLogger(HKAHTxServlet.class);

	//======================================================================
	public void init()
	throws javax.servlet.ServletException {
		logger.info("------------- HKAHTxServlet Servlet Start!!!!!! -------------");
	}

	//======================================================================
	public void doGet(	HttpServletRequest 	request, HttpServletResponse response)
	throws IOException, ServletException {
		try {
			//=== Input Parm =======================================
			String		moduleCode	= null;
			String		txCode		= null;
			String		actionType	= null;
			String		userID		= null;
			String		inQueueStr	= null;
			String		timeStamp	= null;
			String		direct2DB	= null;

			//=== Db Info ==========================================
			String 		dbResult = null;

			//=== Setting ==========================================
			request.setCharacterEncoding("UTF-8");
			response.setContentType("text/html; charset=UTF-8");

			//=== Output ===========================================
			StringBuffer	logStrBuf = new StringBuffer();
			PrintWriter 	output = response.getWriter();

			//=== Get Request ======================================
			if (request != null){
				moduleCode	= request.getParameter("moduleCode");
				txCode		= request.getParameter("txCode");
				actionType	= request.getParameter("actionType");
				userID		= request.getParameter("userID");
				inQueueStr	= request.getParameter("inQueue");
				if (inQueueStr != null) {
					inQueueStr = URLDecoder.decode(inQueueStr, "UTF-8");
				}
				timeStamp	= request.getParameter("clientTimeStamp");
				direct2DB	= request.getParameter("direct2DB");
			}

			if (moduleCode == null) {
				moduleCode = "NHS";
			}

			DataSource dataSource = HKAHInitServlet.getDataSource(direct2DB, moduleCode);

			//--- write log ----------------------------------------
			logStrBuf.setLength(0);
			logStrBuf.append("[Start]\ttxcode[");
			logStrBuf.append(txCode);
			logStrBuf.append("], action[");
			logStrBuf.append(actionType);
			logStrBuf.append("], id[");
			logStrBuf.append(userID);
			logStrBuf.append("], time=");
			logStrBuf.append(timeStamp);
			logStrBuf.append("], input=");
			logStrBuf.append(inQueueStr);
			logger.debug(logStrBuf.toString());

			// special handle for login
			if ("ACT_LOGON".equals(txCode)) {
				String[] inQueue = TextUtil.split(inQueueStr);
				if (inQueue.length > 1) {
					// encrypt password
					inQueue[1] = Crypt.xorString(inQueue[1]);
				}
				dbResult = UtilDBWeb.getFunctionResultsStr(dataSource, moduleCode + "_" + txCode, inQueue);
			} else {
				dbResult = UtilDBWeb.getFunctionResultsStr(dataSource, moduleCode + "_" + txCode, TextUtil.split(inQueueStr));
			}
			logger.debug("Transaction Code: " + txCode);

			output.println(dbResult);

			// write log
			logStrBuf.setLength(0);
			logStrBuf.append("[End]\ttxcode[");
			logStrBuf.append(txCode);
			logStrBuf.append("], id[");
			logStrBuf.append(userID);
			logStrBuf.append("], time=");
			logStrBuf.append(timeStamp);
			logStrBuf.append("], output=");
			logStrBuf.append(dbResult);
			logger.debug(logStrBuf.toString());

		//=== End ======================================================
		} catch (Throwable th) {
			th.printStackTrace();
			logger.error("Throwable : " + th.toString());

			// log the start time and end time
			String txCode = null;
			String clientTimeStamp = null;
			if (request != null){
				txCode = request.getParameter("txcode");
				clientTimeStamp = request.getParameter("clientTimeStamp");
			}
			logger.error("Exception occur!, TxCode=" + txCode + ", clientTimeStamp=" + clientTimeStamp + ", error=" + th.toString());
		}
	}

	//======================================================================
	public void doPost(HttpServletRequest request, HttpServletResponse response)
	throws IOException, ServletException {
		doGet(request, response);
	}
}