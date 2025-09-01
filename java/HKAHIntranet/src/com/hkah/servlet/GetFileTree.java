/*
 * Created on July 10, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.hkah.constant.ConstantsVariable;
import com.hkah.util.cache.ServerSideFileLoader;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class GetFileTree extends HttpServlet implements ConstantsVariable {

	//======================================================================
	private static Logger logger = Logger.getLogger(GetFileTree.class);

	public void init()
	throws javax.servlet.ServletException {
		logger.info("------------- HKAHLoadBalanceServlet Servlet Start!!!!!! -------------");
	}

	//======================================================================
	public void doGet(HttpServletRequest request, HttpServletResponse response)
	throws IOException, ServletException {
		//=== Setting ==========================================
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");

		//=== Output ===========================================
		PrintWriter output = response.getWriter();

		//=== Get Request ======================================
		if (request != null) {
			String category = request.getParameter("category");
			String documentID = request.getParameter("documentID");
			String fileDirectory = request.getParameter("fileDirectory");
			boolean showSubFolder = convertString2Boolean(request.getParameter("showSubFolder"));
			boolean onlyShowCurrentYear = convertString2Boolean(request.getParameter("onlyShowCurrentYear"));
			boolean ascOrder = convertString2Boolean(request.getParameter("ascOrder"));
			boolean oldTreeStyle = convertString2Boolean(request.getParameter("oldTreeStyle"));
			int currentLevel = convertString2Integer(request.getParameter("currentLevel"));
			int currentCount = convertString2Integer(request.getParameter("currentCount"));
			boolean sortByDate = convertString2Boolean(request.getParameter("sortByDate"));

			output.println(ServerSideFileLoader.getInstance().getFileTree(category, documentID, fileDirectory, showSubFolder, onlyShowCurrentYear,
					ascOrder, oldTreeStyle, currentLevel, currentCount, sortByDate));
		}
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
	throws IOException, ServletException {
		doGet(request, response);
	}

	private boolean convertString2Boolean(String value) {
		return YES_VALUE.equals(value);
	}

	private int convertString2Integer(String value) {
		try {
			return Integer.parseInt(value);
		} catch (Exception e) {
			return 0;
		}
	}
}