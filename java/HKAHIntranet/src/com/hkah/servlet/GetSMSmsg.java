package com.hkah.servlet;

//Import required java libraries
import java.io.*;
import java.util.ArrayList;

import javax.servlet.*;
import javax.servlet.http.*;


import com.hkah.web.common.ReportableListObject;
import com.hkah.web.db.SMSDB;

//Extend HttpServlet class
public class GetSMSmsg extends HttpServlet {
	
	private ArrayList result = new ArrayList();
	private String smsCode;
	private String smsMsg;

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
			
		smsCode = request.getParameter("smsCode");
		
		if (smsCode.contains("%")){
			smsMsg = "";
		}else{
			result = SMSDB.getMsg(smsCode);
			if (result.size() > 0) {
				ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
				smsMsg = reportableListObject.getValue(1);
			} else {
				smsMsg = "";
			}
		}

		String newMsg = smsMsg.replace("&#13;", "<br/>");
		
		response.setContentType("text/html");

    	PrintWriter out = response.getWriter();
	   if(smsMsg == ""){
		   out.println("<script>$('#send').prop('disabled',true);alert(\"Error SMS code\");</script>");
	   }else{
		   out.println(newMsg+"<script language='JavaScript'>$('#send').prop('disabled',false);</script>");
	   }
	   
	   destroy();
	}
	
	public void destroy() {
		result.clear();	
	}
}