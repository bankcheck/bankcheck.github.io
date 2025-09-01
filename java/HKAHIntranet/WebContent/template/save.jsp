<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="java.io.PrintWriter" %>
<%
UserBean userBean = new UserBean(request);
boolean success = true;
String errMsg = "";

String command = request.getParameter("command");
String templateID = request.getParameter("templateID");
String group = request.getParameter("group");
String templateType = request.getParameter("templateType");
String reportID = request.getParameter("reportID");

if(templateID != null && command != null) {
	ArrayList contents = TemplateDB.getAllTemplateContent(templateID);

	if(command.equals("submit")) {
		if(reportID != null && reportID.length() > 0) {
			//update report
			ReportableListObject row = null;
			
			try {
				if(TemplateDB.deleteTemplateRecord(userBean, reportID)) {
					for(int i = 0; i < contents.size(); i++) {
						row = (ReportableListObject) contents.get(i);
						
						if(row.getValue(6).equals("1")) {
							for(int j = 1; j <= Integer.parseInt(group); j++) {	
								String[] values = request.getParameterValues(row.getValue(1)+"-group-"+j);					
								String format = row.getValue(3);
								
								String[] dayValues = request.getParameterValues(row.getValue(1)+"-day-group-"+j);
								if(dayValues!=null){
									String day="";
									String hasDate = null;
									for(int s=0;s<dayValues.length;s++){										
										if(s == dayValues.length-1){
											day = day + dayValues[s];
										}else{
											day = day + dayValues[s] + "/";
										}
										if(dayValues[s] != null&& dayValues[s].length()>0){
											hasDate = hasDate + dayValues[s];
										}
									}
									if(hasDate!=null && hasDate.length()>0){										
										values = new String[]{day};
									}
								}	
																
								if(values != null) {									
									for(String value : values ){
										if(value != null && value.length()>0){											
											if(TemplateDB.addTemplateRecord(userBean, reportID, row.getValue(1), 
														String.valueOf(j), TextUtil.parseStrUTF8(
																java.net.URLDecoder.decode(value).replaceAll("%", "%25"))) == null) {
												success = false;
												errMsg = "Error#009: Saving Error. Ref: "+row.getValue(1) +". Report ID: "+reportID;
											}
										}
									}
								}
							}
						}
					}
				}
				else {
					success = false;
					errMsg = "Error#008: Updating Error. Report ID: "+reportID;
				}
			}
			catch(Exception e) {
				success = false;
				errMsg = "Error#007: Updating Error. Report ID: "+reportID;
			}
		}
		else {
			//new report
			if(contents.size() > 0) {
				ReportableListObject row = null;
				try {
					reportID = ReportDB.addReport(userBean, templateType, templateID);
					
					for(int i = 0; i < contents.size(); i++) {
						row = (ReportableListObject) contents.get(i);
						
						if(row.getValue(6).equals("1")) {
							for(int j = 1; j <= Integer.parseInt(group); j++) {
								String[] values = request.getParameterValues(row.getValue(1)+"-group-"+j);		
								String format = row.getValue(3);
								
								String[] dayValues = request.getParameterValues(row.getValue(1)+"-day-group-"+j);
								if(dayValues!=null){
									String day="";
									String hasDate = null;
									for(int s=0;s<dayValues.length;s++){										
										if(s == dayValues.length-1){
											day = day + dayValues[s];
										}else{
											day = day + dayValues[s] + "/";
										}
										if(dayValues[s] != null&& dayValues[s].length()>0){
											hasDate = hasDate + dayValues[s];
										}
									}
									if(hasDate!=null && hasDate.length()>0){										
										values = new String[]{day};
									}
								}								
								
								if(values != null) {
									for(String value : values){
										if(value != null && value.length() > 0){
											if(TemplateDB.addTemplateRecord(userBean, reportID, row.getValue(1), 
														String.valueOf(j), TextUtil.parseStrUTF8(
																java.net.URLDecoder.decode(value).replaceAll("%", "%25"))) == null) {
												success = false;
												errMsg = "Error#003: Saving Error. Ref: "+row.getValue(1) +". Report ID: "+reportID;
											}
										}
									}
								}
							}
						}
					}
				}
				catch(Exception e) {
					success = false;
					errMsg = "Error#001: Saving Error. Report ID: "+reportID;
				}
			}
			else {
				success = false;
				errMsg = "Error#002: Saving Error. Report ID: "+reportID;
			}
		}
	}
	else if(command.equals("delete")) {
		//delete report
		try {
			if(ReportDB.deleteReport(userBean, reportID)) {
				if(TemplateDB.deleteTemplateRecord(userBean, reportID)) {
					
				}
				else {
					success = false;
					errMsg = "Error#006: Deleting Error. Report ID: "+reportID;
				}
			}
			else {
				success = false;
				errMsg = "Error#005: Deleting Error. Report ID: "+reportID;
			}
		}
		catch(Exception e) {
			success = false;
			errMsg = "Error#004: Deleting Error. Report ID: "+reportID;
		}
	}
	
	JSONObject resultJSON = new JSONObject();
	resultJSON.put("success", success);
	resultJSON.put("reportID", reportID);
	resultJSON.put("errMsg", errMsg);
	
	response.setContentType("text/javascript");
	PrintWriter writer = response.getWriter();
	writer.print(request.getParameter("callback")+"("+resultJSON.toString()+ ");");
	writer.close();
}
%>