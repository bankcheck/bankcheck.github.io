<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
UserBean userBean = new UserBean(request);

String deptCode = ParserUtil.getParameter(request, "deptCode");
String showAdminOnly = ConstantsVariable.NO_VALUE;
if (!userBean.isOfficeAdministrator()
		&& deptCode != null && !deptCode.equals(userBean.getDeptCode()) && !userBean.getAssociatedDeptCode().contains(deptCode)) {
	showAdminOnly = ConstantsVariable.YES_VALUE;
}
%>
<jsp:include page="../ui/staffIDCMB.jsp" flush="false">
	<jsp:param name="siteCode" value="<%=userBean.getSiteCode() %>" />
	<jsp:param name="deptCode" value="<%=deptCode %>" />
	<jsp:param name="showDeptDesc" value="N" />
	<jsp:param name="showStaffID" value="Y" />
	<jsp:param name="showAdminOnly" value="<%=showAdminOnly %>" />
</jsp:include>