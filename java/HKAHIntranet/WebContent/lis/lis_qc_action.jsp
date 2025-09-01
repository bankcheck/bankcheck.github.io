<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>    
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="org.json.simple.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%
String user = request.getParameter("user");
String action = request.getParameter("action");
JSONObject jsonResponse = new JSONObject();

try  {		
	if ("comment".equals(action)) {
		String comment = request.getParameter("comment");
		String rownum = request.getParameter("key");				
		
		if (LabDB.updateQcCommentStatus( rownum, comment, user, action)) {
			jsonResponse.put("comment", comment);
			jsonResponse.put("user", user);
			jsonResponse.put("message", "success");
		} else {
			jsonResponse.put("message", action + " failed");	
		}		
		
	} else if ("accept".equals(action)) {
		if (LabDB.hasPermission(user, "maint")) {
			String comment = request.getParameter("comment");
			String rownum = request.getParameter("key");
					
			if (LabDB.updateQcCommentStatus( rownum, comment, user, action)) {
				jsonResponse.put("comment", comment);
				jsonResponse.put("user", user);
				jsonResponse.put("message", "success");
			} else {
				jsonResponse.put("message", action + " failed");	
			}	
			
		} else {
			jsonResponse.put("message", "Sorry, you are not authorized to use this function.");				
		}
		
	} else if ("reject".equals(action)) {
		if (LabDB.hasPermission(user, "maint")) {
			String comment = request.getParameter("comment");
			String rownum = request.getParameter("key");
			
			if (LabDB.updateQcCommentStatus( rownum, comment, user, action)) {
				jsonResponse.put("comment", comment);
				jsonResponse.put("user", user);
				jsonResponse.put("message", "success");
			} else {
				jsonResponse.put("message", action + " failed");	
			}	
			
		} else {
			jsonResponse.put("message", "Sorry, you are not authorized to use this function.");				
		}
		
/* Remove save cal function

	} else if ("updateNorm".equals(action)) {
		if (LabDB.hasPermission(user, "maint")) {
			String cntlNum = request.getParameter("cntlNum");
			String testType = request.getParameter("testType");
			String intTcode = request.getParameter("intTcode");
			String machno = request.getParameter("machno");
			String rangeHigh = request.getParameter("rangeHigh");
			String rangeLow = request.getParameter("rangeLow");						
			
			if (LabDB.updateQcNorm(rangeHigh, rangeLow, cntlNum, testType, intTcode, machno)) {		
				jsonResponse.put("message", "success");
			} else {
				jsonResponse.put("message", action + " failed");	
			}
		} else {
			jsonResponse.put("message", "Sorry, you are not authorized to use this function.");				
		}
*/		
		
	} else if ("cal".equals(action)){
		String cntlNum = request.getParameter("cntlNum");
		String testType = request.getParameter("testType");
		String machno = request.getParameter("machno");
		String intTcode = request.getParameter("intTcode");
		String frDate = request.getParameter("frDate");
		String toDate = request.getParameter("toDate");
		DecimalFormat df = LabDB.QcFormat;
		
		int total = 0;
		int reject = 0;	
		int accept = 0;
		double mean = 0;
		double sd = 0;
		double cv = 0;
		double range = 0;
		
		ReportableListObject cal = LabDB.getCalculatedQcResult(testType, cntlNum, machno, intTcode, frDate, toDate) ;				
		if (cal != null) {
			total = Integer.parseInt(cal.getValue(0));
			reject = Integer.parseInt(cal.getValue(1));
		}	
			
		ArrayList<ReportableListObject> data = LabDB.getSingleQcData(testType, cntlNum, machno, intTcode, frDate, toDate);
		
		ArrayList<Double> result = new ArrayList<Double>();
		
		for (int i = 0; i < data.size(); i++) {
			ReportableListObject row = (ReportableListObject)data.get(i);
						
			String status = row.getValue(2);
			
			if (!"R".equals(status)) {
				String txtResult = row.getValue(1);	
				double numResult = LabDB.convertQcResult(txtResult);
				result.add(numResult);				
			}			
		}
		
		accept = total - reject;
		mean = LabDB.calMean(result);
		sd = LabDB.calPopSD(result);
		cv = LabDB.calCV(result);
		range = LabDB.calRange(result);
						 		
		jsonResponse.put("accept", accept);
		jsonResponse.put("reject", reject);
		jsonResponse.put("total", total);
		jsonResponse.put("mean", df.format(mean));
		jsonResponse.put("sd", df.format(sd));
		jsonResponse.put("cv", df.format(cv));
		jsonResponse.put("range", df.format(range));
		jsonResponse.put("message", "success");
		
	} else {
		jsonResponse.put("message", "Unable to process " + action);	
	}
} catch (Exception e) {
	e.printStackTrace();
	jsonResponse.put("message", action + " failed: " + e.getMessage());
}

%>
<%
out.print(jsonResponse.toJSONString());
%>