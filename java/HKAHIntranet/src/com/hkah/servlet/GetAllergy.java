package com.hkah.servlet;

//Import required java libraries
import java.io.*;
import java.util.ArrayList;

import javax.servlet.*;
import javax.servlet.http.*;


import com.hkah.web.common.ReportableListObject;
import com.hkah.web.db.AllergyDB;

//Extend HttpServlet class
public class GetAllergy extends HttpServlet {
	
	private ArrayList result = new ArrayList();
	private String allergyType;
	private ArrayList allergyCode = new ArrayList();
	private ArrayList allergyName = new ArrayList();

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
			
		allergyType = request.getParameter("allergyType");

		result = new ArrayList();
		result = AllergyDB.getAllergy(allergyType);
    	if (result.size() > 0) {
    		for (int i=0; i<result.size(); i++){
    			ReportableListObject reportableListObject = (ReportableListObject) result.get(i);
    			allergyCode.add(reportableListObject.getValue(0));
    			allergyName.add(reportableListObject.getValue(1));
    		}
    	}		
    	
    	response.setContentType("text/html");
	
	   // Actual logic goes here.
	   PrintWriter out = response.getWriter();

	   for (int i=0; i<allergyCode.size(); i++){
		   out.println("<input type='radio' class='allergy' name='allergy' id='"+allergyCode.get(i)+"' value='"+allergyCode.get(i)+"' onclick='showDesc()' />"+allergyName.get(i) );
		   if ("Others".equals(allergyName.get(i))) {
			   out.println("<input type='text' class='desc' name='desc' id='desc' placeholder='Description' disabled>");
		   }
		   out.println("<br>");
	   }
	   
	   
	   
	   destroy();
	}
	
	public void destroy() {
		result.clear();
		allergyCode.clear();
		allergyName.clear();
		
	}
}