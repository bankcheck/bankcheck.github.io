package com.hkah.servlet;

//Import required java libraries
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hkah.util.ParserUtil;
import com.hkah.web.db.SMSDB;

//Extend HttpServlet class
public class SaveSendMethod extends HttpServlet {
	
	private ArrayList result = new ArrayList();
	private String batchID;
	private String rev;
	private String revMethod;
	private boolean success = false;

	public void init() throws ServletException {
	   // Do required initialization
	}
	
	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		service(request, response);
	}
	
	@Override
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		service(request, response);
	}
	
	public void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
			
		batchID = request.getParameter("batchID");
		
		Enumeration<String> parameterNames = request.getParameterNames();
		String patno = null;
		Map<String, String> patMethods = new HashMap<String, String>(); 
		while (parameterNames.hasMoreElements()) {
			String paramName = parameterNames.nextElement();

			if (paramName.startsWith("z")) {
				patno = paramName.substring(1);
				String paramValue = ParserUtil.getParameter(request, paramName);
				patMethods.put(patno, paramValue);
			}
		}
		
		if (!patMethods.isEmpty()){
			Set<String> keys = patMethods.keySet();
			Iterator<String> itr = keys.iterator();
			String thisPatno = null;
			while (itr.hasNext()) {
				thisPatno = itr.next();
				
				String smsList = null;
				String mailList = null;
				String noProList = null;
				if ("S".equals(patMethods.get(thisPatno))) {
					smsList = thisPatno;
				} else if ("M".equals(patMethods.get(thisPatno))) {
					mailList = thisPatno;
				} else if ("0".equals(patMethods.get(thisPatno))) {
					noProList = thisPatno;
				}
				success = SMSDB.updateBatch(batchID, smsList, mailList, noProList);
			}
		}

		response.setContentType("text/html");

    	PrintWriter out = response.getWriter();

		out.println(success);

	   destroy();
	}
	
	public void destroy() {
		result.clear();	
	}
}