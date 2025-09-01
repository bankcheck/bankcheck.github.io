package com.hkah.servlet;

//Import required java libraries
import java.io.*;
import java.util.ArrayList;

import javax.servlet.*;
import javax.servlet.http.*;


import com.hkah.web.common.ReportableListObject;
import com.hkah.web.db.AllergyDB;

//Extend HttpServlet class
public class GetAllergyCancelReason extends HttpServlet {
	
	private ArrayList result = new ArrayList();
	private String recordID;
	private String showCancelReasonRemark;
	private String showCancelReason;
	private ArrayList ReasonCode = new ArrayList();
	private ArrayList Reason = new ArrayList();

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
			
		recordID = request.getParameter("recordID");

		result = new ArrayList();
		result = AllergyDB.getAllergyCancelReason(recordID);
		if (result.size() >= 0) {
				ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
				showCancelReasonRemark = reportableListObject.getValue(1);
				showCancelReason = reportableListObject.getValue(2);
		} 
		
		result = AllergyDB.getCancelReason();
		if (result.size() > 0) {
			for (int i=0; i<result.size(); i++){
				ReportableListObject reportableListObject = (ReportableListObject) result.get(i);
				ReasonCode.add(reportableListObject.getValue(0));
				Reason.add(reportableListObject.getValue(1));
			}
		} 
	
    	response.setContentType("text/html");
	
    	// Actual logic goes here.
    	PrintWriter out = response.getWriter();
    	out.println("<div class='cancelTitle'>Cancel Reason: </div>");
    	out.println("<div class='content'>");
    	out.println("<ul>");
    	if (showCancelReason.length() > 0) {
    		String[] temp = showCancelReason.split(",");
	    	for(int i=0; i<temp.length; i++){
	    		
	    		out.println("<li>");
	    		int index = ReasonCode.indexOf(temp[i]);
	    		//System.out.println(index);
	    		out.println(Reason.get(index));
	    		out.println("</li>");
	    	}
    	}
    	out.println("</ul>");
    	if(showCancelReasonRemark.length() > 0){
    		out.println("<b>Remarks:</b><br/>");
    		out.println(showCancelReasonRemark);
    	}
    	out.println("</div>");
	  
	   destroy();
	}
	
	public void destroy() {
	   // do nothing.
		result.clear();
	}
}