<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.mail.UtilMail" %>

<%!
public static boolean changeStaffEmail(UserBean userBean,String staffID,String staffEmail) {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("UPDATE CO_STAFFS  ");
	sqlStr.append("SET CO_EMAIL = '"+staffEmail+"', ");
	sqlStr.append("CO_MODIFIED_DATE=SYSDATE, ");
	sqlStr.append("CO_MODIFIED_USER='" + userBean.getLoginID() + "' ");
	sqlStr.append("WHERE CO_STAFF_ID = '" + staffID + "' ");

	//System.out.println(sqlStr.toString());

	return UtilDBWeb.updateQueue(sqlStr.toString());
}

public static boolean insertEmail(UserBean userBean,String pirID,String toStaff,String ccStaff,String bccStaff,String action,
		String remark,String emailNotice,String reminder,String status) {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("INSERT INTO PI_REPORT_FLWUP(PIRID,PI_FLW_ID,PI_TO,PI_CC,PI_BCC,PI_ACTION,PI_REMARK,PI_EMAIL,PI_AUTO_REMIND,PI_STATUS,CREATE_USER,MODIFIED_USER) ");
	sqlStr.append("	VALUES('"+pirID+"','"+getNextFlwID(pirID)+"','"+toStaff+"','"+ccStaff+"','"+bccStaff+"','"+action+"','"+remark+"','"+emailNotice+"','"+reminder+"','"+status+"','"+userBean.getLoginID()+"','"+userBean.getLoginID()+"')");
	//System.out.println(sqlStr.toString());

	return UtilDBWeb.updateQueue(sqlStr.toString());
}

public static boolean deleteEmail(UserBean userBean,String pirID,String flwUpID) {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("UPDATE PI_REPORT_FLWUP  ");
	sqlStr.append("SET ENABLE = '0', ");
	sqlStr.append("MODIFIED_DATE=SYSDATE, ");
	sqlStr.append("MODIFIED_USER='" + userBean.getLoginID() + "' ");
	sqlStr.append("WHERE PIRID = '" + pirID + "' ");
	sqlStr.append("AND PI_FLW_ID = '" + flwUpID + "' ");

	//System.out.println(sqlStr.toString());

	return UtilDBWeb.updateQueue(sqlStr.toString());
}

private static String getNextFlwID(String pirID) {
	String id = null;

	ArrayList result = UtilDBWeb.getReportableList("SELECT MAX(PI_FLW_ID) + 1 FROM PI_REPORT_FLWUP WHERE PIRID='"+pirID+"'");
	if (result.size() > 0) {
		ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
		//System.out.println(reportableListObject.getValue(0));
		id = reportableListObject.getValue(0);

		// set 1 for initial
		if (id == null || id.length() == 0) return "1";
	}
	return id;
}

public static boolean insertReply(UserBean userBean,String pirID,String flwUpID,String reply) {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("	INSERT INTO PI_REPORT_FLW_REPLY(PIRID,PI_FLW_ID,PI_REPLY_ID,PI_REPLY_MSG,CREATE_USER,MODIFIED_USER) ");
	sqlStr.append("	VALUES('"+pirID+"','"+flwUpID+"','"+getNextReplyID(pirID,flwUpID)+"','"+reply+"','"+userBean.getLoginID()+"','"+userBean.getLoginID()+"')");
	//System.out.println(sqlStr.toString());

	return UtilDBWeb.updateQueue(sqlStr.toString());
}

private static String getNextReplyID(String pirID,String flwUpID) {
	String id = null;

	ArrayList result = UtilDBWeb.getReportableList("SELECT MAX(PI_REPLY_ID) + 1 FROM PI_REPORT_FLW_REPLY WHERE PIRID='"+pirID+"' AND PI_FLW_ID='"+flwUpID+"' ");
	if (result.size() > 0) {
		ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
		//System.out.println(reportableListObject.getValue(0));
		id = reportableListObject.getValue(0);

		// set 1 for initial
		if (id == null || id.length() == 0) return "1";
	}
	return id;
}

public static ArrayList checkStatus(String pirID) {
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT PIRID  ");
	sqlStr.append("FROM PI_REPORT_STATUS ");
	sqlStr.append("WHERE PIRID ='"+pirID+"' ");

	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

public static boolean insertStatus(UserBean userBean,String pirID,String reject,String follow,String complete,String contributingFactors,
		String recommendation,String evaluation,String closeLoop) {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("	INSERT INTO PI_REPORT_STATUS(PIRID,PIR_REJECT,PIR_FLWUP,PIR_FLWUP_COMPLETE,PIR_FINAL_FACTOR,PIR_FINAL_REC,PIR_CLOSE_EVAL,PIR_CLOSE_HAPPEN,CREATE_USER,MODIFIED_USER) ");
	sqlStr.append("	VALUES('"+pirID+"','"+reject+"','"+follow+"','"+complete+"','"+contributingFactors+"','"+recommendation+"','"+evaluation+"','"+closeLoop+"','"+userBean.getLoginID()+"','"+userBean.getLoginID()+"')");
	//System.out.println(sqlStr.toString());

	return UtilDBWeb.updateQueue(sqlStr.toString());
}

public static boolean editStatus(UserBean userBean,String pirID,String reject,String follow,String complete,String contributingFactors,
		String recommendation,String evaluation,String closeLoop) {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("UPDATE PI_REPORT_STATUS  ");
	sqlStr.append("SET PIR_REJECT = '"+reject+"', ");
	sqlStr.append("PIR_FLWUP = '"+follow+"', ");
	sqlStr.append("PIR_FLWUP_COMPLETE = '"+complete+"', ");
	sqlStr.append("PIR_FINAL_FACTOR = '"+contributingFactors+"', ");
	sqlStr.append("PIR_FINAL_REC = '"+recommendation+"', ");
	sqlStr.append("PIR_CLOSE_EVAL = '"+evaluation+"', ");
	sqlStr.append("PIR_CLOSE_HAPPEN = '"+closeLoop+"', ");
	sqlStr.append("ENABLE = '1', ");
	sqlStr.append("MODIFIED_DATE=SYSDATE, ");
	sqlStr.append("MODIFIED_USER='" + userBean.getLoginID() + "' ");
	sqlStr.append("WHERE PIRID = '" + pirID + "' ");

	//System.out.println(sqlStr.toString());

	return UtilDBWeb.updateQueue(sqlStr.toString());
}
%>
<%
UserBean userBean = new UserBean(request);
if (userBean == null || !userBean.isLogin()) {
	%>
	<script>
		window.open("../index.jsp", "_self");
	</script>
	<%
	return;
}

String type = request.getParameter("type");

if (type.equals("changeStaffEmail")) {
	String staffID = request.getParameter("staffID");
	String staffEmail = request.getParameter("staffEmail");
%>
	<%=changeStaffEmail(userBean,staffID,staffEmail)%>
<%
} else if (type.equals("sendEmail")) {
	String pirID = request.getParameter("pirID");
	String[] allToStaff = request.getParameterValues("allToStaff");
	String[] allCcStaff = request.getParameterValues("allCcStaff");
	String[] allBccStaff = request.getParameterValues("allBccStaff");

	String action =  TextUtil.parseStrUTF8(
			java.net.URLDecoder.decode(
					request.getParameter("action").replaceAll("%", "%25")));


	String remark =  TextUtil.parseStrUTF8(
			java.net.URLDecoder.decode(
					request.getParameter("remark").replaceAll("%", "%25")));
	String emailNotice = request.getParameter("emailNotice");
	String reminder = request.getParameter("reminder");
	String status = request.getParameter("status");

	ArrayList<String> allToStaffList = new ArrayList<String>();
	ArrayList<String> allCcStaffList = new ArrayList<String>();
	ArrayList<String> allBccStaffList = new ArrayList<String>();

	if (allToStaff!=null) {
		for (String s : allToStaff) {
			if (!allToStaffList.contains(s)) {
				allToStaffList.add(s);
			}
		}
	}
	if (allCcStaff!=null) {
		for (String s : allCcStaff) {
			if (!allCcStaffList.contains(s)) {
				allCcStaffList.add(s);
			}
		}
	}
	if (allBccStaff!=null) {
		for (String s : allBccStaff) {
			if (!allBccStaffList.contains(s)) {
				allBccStaffList.add(s);
			}
		}
	}
	if ("undefined".equals(emailNotice)) {
		emailNotice = "";
	}
	if ("undefined".equals(reminder)) {
		reminder = "";
	}
	if ("undefined".equals(status)) {
		status = "";
	}

	String toStaff="";
	for (String s : allToStaffList) {
		toStaff = toStaff + s + ";";
	}

	String ccStaff="";
	for (String s : allCcStaffList) {
		ccStaff = ccStaff + s + ";";
	}

	String bccStaff="";
	for (String s : allBccStaffList) {
		bccStaff = bccStaff + s + ";";
	}
	boolean emailSuccess = false;
	emailSuccess = insertEmail(userBean,pirID,toStaff,ccStaff,bccStaff,action,remark,emailNotice,reminder,status);

	//remark = remark + "<br></br><a href=\"http://localhost:8080/intranet/pi/followUpEmail.jsp?pirID="+pirID+"\">Portal: Link for replying Email.</a>";
	remark = remark + "<br></br><a href=\"http://www-server/intranet/pi/followUpEmail.jsp?pirID="+pirID+"\">Portal: Link for replying Email.</a>";

	if (emailSuccess) {
		UtilMail.sendMail(ConstantsServerSide.MAIL_ALERT,allToStaff, allCcStaff, allBccStaff
				, action, remark);
	}
%><%=emailSuccess %>
<%
} else if (type.equals("deleteEmail")) {
	String pirID = request.getParameter("pirID");
	String flwUpID = request.getParameter("flwUpID");
%>
	<%=deleteEmail(userBean,pirID,flwUpID)%>
<%
} else if (type.equals("submitReply")) {
	String pirID = request.getParameter("pirID");
	String flwUpID = request.getParameter("flwUpID");
	String reply =  TextUtil.parseStrUTF8(
			java.net.URLDecoder.decode(
					request.getParameter("reply").replaceAll("%", "%25")));

%>
	<%=insertReply(userBean,pirID,flwUpID,reply) %>
<%
} else if (type.equals("submitStatus")) {
	String pirID=request.getParameter("pirID");
	String reject=request.getParameter("reject");
	String follow=request.getParameter("follow");
	String complete=request.getParameter("complete");
	String contributingFactors=request.getParameter("contributingFactors");
	String recommendation=request.getParameter("recommendation");
	String evaluation=request.getParameter("evaluation");
	String closeLoop=request.getParameter("closeLoop");

	String status = "";
	if ("".equals(reject)) {
		status = "0"; //processing
	} else if ("Y".equals(reject)) {
		status = "4"; //reject

	} else if ("N".equals(reject)) {
		if ("".equals(follow)) {
			status = "1"; //accept
		} else if ("N".equals(follow)) {
			status = "7"; //closed
		} else if ("Y".equals(follow)) {
			status = "2"; //follow up
			if ("N".equals(complete)) {
				status = "6"; //not completed
			} else if ("Y".equals(complete)) {
				status = "7"; //closed
			}
		}
	}

	boolean statusSuccess = false;
	ArrayList statusRecord = checkStatus(pirID);
	if (statusRecord.size() == 0)	{
		statusSuccess = insertStatus(userBean,pirID,reject,follow,complete,contributingFactors,recommendation,evaluation,closeLoop);
	} else {
		statusSuccess = editStatus(userBean,pirID,reject,follow,complete,contributingFactors,recommendation,evaluation,closeLoop);
	}
	if (statusSuccess) {
		PiReportDB.updatePIReportStatus(userBean,pirID,status);
	}
%>
	<%=statusSuccess %>
<%
}
%>