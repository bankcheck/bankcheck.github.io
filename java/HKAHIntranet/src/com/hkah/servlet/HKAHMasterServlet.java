/*
 * Created on July 10, 2008
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
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.hkah.constant.ConstantsVariable;
import com.hkah.util.QueryUtil;
import com.hkah.util.TextUtil;
import com.hkah.util.db.UtilDBWeb;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class HKAHMasterServlet extends HttpServlet implements ConstantsVariable {

	//======================================================================
	private static Logger logger = Logger.getLogger(HKAHMasterServlet.class);

	public void init()
	throws javax.servlet.ServletException {
		logger.info("------------- HKAHMasterServlet Servlet Start!!!!!! -------------");
	}

	//======================================================================
	public void doGet(	HttpServletRequest 	request, HttpServletResponse response)
	throws IOException, ServletException {
		try {
			//=== Input Parm =======================================
			String		moduleCode	= null;
			String		txCode 		= null;
			String		actionType	= null;
			String		userID 		= null;
			String		inQueueStr 	= null;
			String		structDescriptor = null;
			String		tableQueue	= null;
			String		timeStamp	= null;
			String		direct2DB	= null;
			String		outtype		= null;

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
				userID  	= request.getParameter("userID");
				inQueueStr	= request.getParameter("inQueue");
				if (inQueueStr != null) {
					inQueueStr = URLDecoder.decode(inQueueStr, "UTF-8");
				}
				structDescriptor = request.getParameter("structDescriptor");
				if (request.getParameter("tableQueue") != null) {
					tableQueue	= URLDecoder.decode(request.getParameter("tableQueue"), "UTF-8");
				}
				timeStamp	= request.getParameter("clientTimeStamp");
				direct2DB	= request.getParameter("direct2DB");
				outtype		= request.getParameter("outtype");
			}
			
			if (moduleCode == null) {
				moduleCode = HKAHInitServlet.MODULE_CODE_NHS;
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

			String[] inputParameter = null;
			if (inQueueStr != null && inQueueStr.length() > 0) {
				inputParameter = TextUtil.split(inQueueStr);
			}

			if (QueryUtil.ACTION_APPEND.equals(actionType)
					|| QueryUtil.ACTION_MODIFY.equals(actionType)
					|| QueryUtil.ACTION_DELETE.equals(actionType)) {
				if (structDescriptor != null && tableQueue != null) {
					dbResult = UtilDBWeb.callFunction(dataSource, moduleCode + "_ACT" + UNDERSCORE_VALUE + txCode, actionType, inputParameter, structDescriptor, tableQueue, true);
				} else {
					dbResult = UtilDBWeb.callFunction(dataSource, moduleCode + "_ACT" + UNDERSCORE_VALUE + txCode, actionType, inputParameter, true);
				}
			} else {
				dbResult = UtilDBWeb.getFunctionResultsStr(dataSource, moduleCode + UNDERSCORE_VALUE + actionType + UNDERSCORE_VALUE + txCode, inputParameter);
			}
			
			if ("json".equalsIgnoreCase(outtype)) {
				boolean hasHeader = true;
				JSONObject mainJO = new JSONObject();
				JSONArray resultJA = new JSONArray(); 
				if (dbResult != null) {
					int lineCount = 0;
					String[] lines = dbResult.split(TextUtil.LINE_DELIMITER);
					if (lines != null) {
						lineCount = lines.length;
						mainJO.put("totalCount", Integer.toString(lineCount));
						for (String line : lines) {
							String[] fields = line.split(TextUtil.FIELD_DELIMITER);
							JSONObject resultJO = new JSONObject();
							if (fields != null) {
								int fieldIdx = 0;
								for (int i = 0; i < fields.length; i++) {
									if (!hasHeader) {
										resultJO.put(fieldIdx++, fields[i]);
									}
									
									if (hasHeader && "OK".equals(fields[i])) {
										hasHeader = false;
										fieldIdx = 0;
									}
								}
							}
							resultJA.add(resultJO);
						}
						mainJO.put("result", resultJA);
					}
				}
				dbResult = mainJO.toString();
			}
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

	public void doPost(HttpServletRequest request, HttpServletResponse response)
	throws IOException, ServletException {
		doGet(request, response);
	}
}