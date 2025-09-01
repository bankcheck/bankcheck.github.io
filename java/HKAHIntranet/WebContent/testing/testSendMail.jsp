<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="com.hkah.constant.ConstantsServerSide"%>   
<%@ page import="com.hkah.web.common.*"%> 
<%@ page import="com.hkah.util.db.UtilDBWeb"%> 
<%@ page import="com.hkah.util.mail.UtilMail"%> 
<%@ page import="com.hkah.web.db.EmailAlertDB"%>
<%@ page import="java.util.*"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="com.hkah.web.common.ReportableListObject" %>
<%!
private ArrayList<ReportableListObject> getList(String moduleCode) {
	String sqlStr_getList = null;
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT CO_ACTION, CO_EMAIL ");
	sqlStr.append("FROM   CO_EMAIL_ALERT ");
	sqlStr.append("WHERE  CO_SITE_CODE = ? ");
	sqlStr.append("AND    CO_MODULE_CODE = ? ");
	sqlStr.append("AND    CO_ENABLED = 1 ");
	sqlStr_getList = sqlStr.toString();
	
	return UtilDBWeb.getReportableList(sqlStr_getList, new String[] { ConstantsServerSide.SITE_CODE, moduleCode});
}

private Map<String, List<String>> mailAlert(String mailAlertModuleCode) {
	Map<String, List<String>> ret = new HashMap<String, List<String>>();
	List<String> to = new ArrayList<String>();
	List<String> cc = new ArrayList<String>();
	List<String> bcc = new ArrayList<String>();
	
	//List<ReportableListObject> list = EmailAlertDB.getList(mailAlertModuleCode);
	ArrayList<ReportableListObject> list = getList(mailAlertModuleCode);
	for (ReportableListObject row : list) {
		String action = row.getFields0();
		String addr = row.getFields1();
		
		if ("to".equalsIgnoreCase(action)) {
			to.add(addr);
		} else if ("cc".equalsIgnoreCase(action)) {
			cc.add(addr);
		} else if ("bcc".equalsIgnoreCase(action)) {
			bcc.add(addr);
		}
	}
	ret.put("to", to);
	ret.put("cc", cc);
	ret.put("bcc", bcc);
	return ret;
}
%>
<%
UserBean userBean = new UserBean(request);
//if (!userBean.isAdmin()) {
//	throw new Exception("Permission Denied");
//}

String serverHostAddr = request.getLocalAddr();
String clientAddr = request.getRemoteAddr();

String action = request.getParameter("action");
String mailAlertModuldeCode = request.getParameter("mailAlertModuldeCode");
String host = request.getParameter("host");
String from2 = request.getParameter("from");
String to2 = request.getParameter("to");
String cc2 = request.getParameter("cc");
String bcc2 = request.getParameter("bcc");
String subject = request.getParameter("subject");
String content = request.getParameter("content");

//System.out.println("test sendmail to2="+to2+",mailAlertModuldeCode="+mailAlertModuldeCode);

String testString = "[Test mail from server: " + serverHostAddr + ", by client: " + clientAddr +"]";
Date date = new Date();
Map<String, List<String>> recipients = mailAlert(mailAlertModuldeCode);

boolean sendRet = false;
String emailSubj = null;
String emailContent = null;
String from = null;
String[] to = null;
String[] cc = null;
String[] bcc = null;
if ("send".equals(action)) {
	if (mailAlertModuldeCode == null || mailAlertModuldeCode.isEmpty()) {
		to = to2 == null || to2.isEmpty() ? null : new String[]{to2};
		cc = cc2 == null || cc2.isEmpty() ? null : new String[]{cc2};
		bcc = bcc2 == null || bcc2.isEmpty() ? null : new String[]{bcc2};
	} else {
		to = recipients.get("to").isEmpty() ? null : recipients.get("to").toArray(new String[]{});
		cc = recipients.get("cc").isEmpty() ? null : recipients.get("cc").toArray(new String[]{});
		bcc = recipients.get("bcc").isEmpty() ? null : recipients.get("bcc").toArray(new String[]{});
	}
	if (from2 != null && !from2.trim().isEmpty()) {
		from = from2;
	} else {
		from = ConstantsServerSide.MAIL_ALERT;
	}
	
	emailSubj = (subject == null ? "" : subject) + testString;
	emailContent = (content == null ? "" : content) + "\n<br>" + testString + "\n<br>Date Time: " + date;
	
	//System.out.println("[testSendMail] sendMail host="+host+", from="+from+",to="+to+", cc="+cc+", bcc="+bcc+", emailSubj="+emailSubj);
	sendRet = UtilMail.sendMail(host, from, to, cc, bcc, emailSubj, emailContent);
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style>
form[name=form1] {
    display: block;
}

form[name=form1] div {
	width: 100%;
	margin: 5px 0;
}

label {
	font-weight: bold;
}

input[type=text] {
	display: block;
    width: 80%;
    margin: 8px 0;
    box-sizing: border-box;
}

textarea {
	display: block;
    width: 80%;
    margin: 8px 0;
    box-sizing: border-box;
}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Send Mail</title>
</head>
	<body>
		<h1>Send email</h1>
<%
if ("send".equals(action)) {
%>
		<div>
			<b>Email sent: <%=sendRet %></b><br /><br />
			SMTP Host: <%=host %><br /> 
			Module Code: <%=mailAlertModuldeCode %><br />
			From: <%=from %><br />
			To: <%=StringUtils.join(to, ",") %><br />
			CC: <%=StringUtils.join(cc, ",") %><br />
			BCC: <%=StringUtils.join(bcc, ",") %><br />
			subject: <%=emailSubj %><br />
			content: <%=emailContent %>
		</div>
		<br />
<%
}
%>		
		<div>
			<form name="form1" action="" method="post">
				<div>
					<label>SMTP host</label>
					<select name="host">
<% if (ConstantsServerSide.isHKAH()) { %>
						<option value="160.100.2.6"<%="160.100.2.6".equals(host)?" selected":"" %>>160.100.2.6</option>
						<option value="160.100.1.230"<%="160.100.1.230".equals(host)?" selected":"" %>>160.100.1.230</option>
<% } else { %>
						<option value="<%=ConstantsServerSide.MAIL_HOST %>"<%=ConstantsServerSide.MAIL_HOST.equals(host)?" selected":"" %>><%=ConstantsServerSide.MAIL_HOST %></option>
<% } %>
					<select/>
				</div>			
				<div>
					<label>Module Code</label>
					<input type="text" name="mailAlertModuldeCode" value="<%=mailAlertModuldeCode == null ? "" : mailAlertModuldeCode %>" />
					(optional)
				</div>
				<div>
					<label>From</label>
					<input type="text" name="from" value="<%=from2 == null ? "" : from2 %>" />
					(leave blank to use default: <%=ConstantsServerSide.MAIL_ALERT %>)
				</div>				
				<div>
					<label>To</label>
					<input type="text" name="to" value="<%=to2 == null ? "" : to2 %>" />
				</div>
				<div>
					<label>CC</label>
					<input type="text" name="cc" value="<%=cc2 == null ? "" : cc2 %>" />
				</div>
				<div>
					<label>BCC</label>
					<input type="text" name="bcc" value="<%=bcc2 == null ? "" : bcc2 %>" />
				</div>
				<div>
					<label>Subject</label>
					<input type="text" name="subject" value="<%=subject == null ? "" : subject %>" />
				</div>
				<div>
					<label>Content</label>
					<textarea name="content"><%=content == null ? "" : content %></textarea>
				</div>
				<div>
					<button type="submit">Send</button>
				</div>
				<input type="hidden" name="action" value="send" />
			</form>
		</div>
		<hr />
		<div>Server default config:<br />
			ConstantsServerSide.MAIL_ALERT=<%=ConstantsServerSide.MAIL_ALERT %><br />
			ConstantsServerSide.MAIL_HOST=<%=ConstantsServerSide.MAIL_HOST %><br />
			ConstantsServerSide.MAIL_SMTP_PORT=<%=ConstantsServerSide.MAIL_SMTP_PORT %><br />
			ConstantsServerSide.MAIL_SMTP_USERNAME=<%=ConstantsServerSide.MAIL_SMTP_USERNAME %><br />
			ConstantsServerSide.MAIL_SMTP_PASSWORD=***<br />
			ConstantsServerSide.MAIL_SMTP_AUTH=<%=ConstantsServerSide.MAIL_SMTP_AUTH %><br />
			ConstantsServerSide.MAIL_SMTP_TIMEOUT=<%=ConstantsServerSide.MAIL_SMTP_TIMEOUT %><br />
			ConstantsServerSide.MAIL_SMTP_CONNECTIONTIMEOUT=<%=ConstantsServerSide.MAIL_SMTP_CONNECTIONTIMEOUT %><br />
		</div>
	</body>
</html>
