<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.text.SimpleDateFormat"%>

<%
UserBean userBean = new UserBean(request);
if (userBean == null || !userBean.isLogin()) {
	%>
	<script>
		window.open("../foodtw/index.jsp", "_self");
	</script>
	<%
	return;
}
String reset = request.getParameter("reset");
String psID = request.getParameter("psID");
String patNo = request.getParameter("patNo");
String regID = request.getParameter("regID");
String regType = request.getParameter("regType");
String patName = request.getParameter("patName");
String wardCode = request.getParameter("wardCode");
String romCode = request.getParameter("romCode");
String bedCode = request.getParameter("bedCode");
String status = request.getParameter("status");

String message = null;

//System.out.println(psID);

if(reset.equals("true")) {
	if(PatientDB.deleteAllPatientService(userBean, "food")) {
		message = "Successful";
	}
	else {
		message = "Fail to Update";
	}
}
else {
	Calendar cal = Calendar.getInstance();
	String isToday = request.getParameter("today");
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
	if(isToday.equals("N")) {
		cal.add(Calendar.DAY_OF_MONTH, 1);
	}
	
	if(patNo != null && status != null && patNo.length() > 0 && status.length() > 0) {
		if(psID != null && psID.length() > 0) {
			try {
				//Integer.parseInt(psID);
				if(!PatientDB.deleteFoodService(userBean, patNo, regID, sdf.format(cal.getTime()))) {
					message = "Fail to Update";
				}
			}
			catch (Exception nFE) {
			    System.out.println("[fsdOrderRemark] "+psID+": Error - ("+patNo+", "+regID+")");
			}
		}
	
		if(status.toLowerCase().equals("normal")) {
			//if(message == null) {
				message = "Successful";
			//}
		}
		else {
			if(PatientDB.addFoodService(userBean, patNo, patName, regID, regType, wardCode, romCode,
								bedCode, null, status, null, sdf.format(cal.getTime()))) {
				message = "Successful";
			}
			else {
				message = "Fail to Update";
			}
		}
	}
}

%>

<%=message%>