<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
// get infomation from userbean
UserBean userBean = new UserBean(request);
String moduleUserID = null;

ArrayList<ReportableListObject> record = UtilDBWeb.getReportableListSEED("SELECT MODULE_USER_ID FROM SSO_USER_MAPPING WHERE MODULE_CODE = 'bugzilla' AND SSO_USER_ID = ?", new String[] { userBean.getStaffID() });
ReportableListObject row = null;
if (record.size() > 0) {
	row = (ReportableListObject) record.get(0);
	moduleUserID = row.getValue(0);
%>
<table width="100%" height="100%"><tr><td align="center"><img src="../images/loadingAnimation.gif"><br>Loading...</td></tr></table>
<form name="form1" action="http://www-server/bugzilla/index.cgi" method="post" target="_top">
<input type="hidden" name="Bugzilla_login" value="<%=moduleUserID %>">
<input type="hidden" name="Bugzilla_password" value="123456">
</form>
<script language="javascript">document.form1.submit();</script>
<%
	return;
} else {
	%><script language="javascript">parent.location.href = "../common/access_deny.jsp";</script><%
	return;
}
%>