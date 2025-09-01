<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="java.util.*"%>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%
UserBean userBean = new UserBean(request);
String eventType = request.getParameter("eventType");

boolean isMkt = userBean.isAccessible("function.mkt.event.type.marketing");
boolean isConcierge = userBean.isAccessible("function.mkt.event.type.concierge");
boolean isLMC = userBean.isAccessible("function.mkt.event.type.lmc");
boolean isOB = userBean.isAccessible("function.mkt.event.type.ob");
boolean isVPA = userBean.isAccessible("function.mkt.event.type.vpa");

StringBuffer sqlStr = new StringBuffer();
String eventCat = null;
sqlStr.append("SELECT CO_EVENT_ID, CO_EVENT_DESC, CO_EVENT_CATEGORY FROM CO_EVENT WHERE CO_MODULE_CODE='eventCal' AND CO_ENABLED = '1' ");
if (isMkt || isConcierge || isLMC || isOB || isVPA){
	sqlStr.append(" AND CO_EVENT_CATEGORY IN (");
	if(isMkt){sqlStr.append("'marketing', ");}
	if(isConcierge){sqlStr.append("'concierge', ");}
	if(isLMC){sqlStr.append("'lmc', ");}
	if(isOB){sqlStr.append("'ob', ");}
	if(isVPA){sqlStr.append("'vpa', ");}

	sqlStr.append("'') ORDER BY CO_EVENT_CATEGORY,CO_EVENT_DESC asc ");
}
ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString());


%>
<option value="" disabled selected>Choose your Type</option>
<% ReportableListObject row = null;
	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			eventCat = row.getValue(2);%>
				<option value="<%=row.getValue(0) %>" <%=row.getValue(0).equals(eventType)?" selected":"" %>><%=row.getValue(1) %></option>				
<%}} %>

