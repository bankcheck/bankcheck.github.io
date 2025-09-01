<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);
String procedure1 = request.getParameter("procedure1");
String procedure2 = request.getParameter("procedure2");

boolean isGP = userBean.isLogin() && userBean.isAccessible("function.financialEstimation.gp");
boolean isPBO = userBean.isLogin() && userBean.isAccessible("function.financialEstimation.pbo");

ArrayList<ReportableListObject> record = null;
if (isPBO) {
	if (isGP) {
		record = UtilDBWeb.getReportableListHATS("SELECT P.PROCCODE, P.PROCDESC || ' - ' || DECODE(C.HATSCODE, NULL, DECODE(C.REFCODE, NULL, '', C.REFCODE), C.HATSCODE) || DECODE(P.LOS, NULL, '', ' | Suggested LOS ' || P.LOS) FROM FIN_PROC P, FIN_CODE C WHERE P.PROCCODE = C.PROCCODE (+) AND P.TYPECODE = ? AND P.STATUS = -1 AND P.ISGP = '1' ORDER BY P.PROCDESC", new String[] { procedure1 });
	} else {
		record = UtilDBWeb.getReportableListHATS("SELECT P.PROCCODE, P.PROCDESC || ' - ' || DECODE(C.HATSCODE, NULL, DECODE(C.REFCODE, NULL, '', C.REFCODE), C.HATSCODE) || DECODE(P.LOS, NULL, '', ' | Suggested LOS ' || P.LOS) FROM FIN_PROC P, FIN_CODE C WHERE P.PROCCODE = C.PROCCODE (+) AND P.TYPECODE = ? AND P.STATUS = -1 ORDER BY P.PROCDESC", new String[] { procedure1 });
	}
} else {
	record = UtilDBWeb.getReportableListHATS("SELECT P.PROCCODE, P.PROCDESC FROM FIN_PROC P WHERE P.TYPECODE = ? AND P.STATUS = -1 ORDER BY P.PROCDESC", new String[] { procedure1 });
}
ReportableListObject row = null;

if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
%>
	<option value="<%=row.getValue(0) %>"<%if (procedure2 != null && row.getValue(0).equals(procedure2)) { %> selected<%}%>><%=row.getValue(1) %></option>
<%
	}
}
%>