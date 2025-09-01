<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%
String expectedDeliveryDateStr = request.getParameter("expectedDeliveryDate");
Date expectedDeliveryDate = DateTimeUtil.parseDate(expectedDeliveryDateStr);

if (expectedDeliveryDate != null) {
	Calendar calendar = Calendar.getInstance();
	calendar.setTime(expectedDeliveryDate);
	calendar.add(Calendar.WEEK_OF_YEAR, -20);
	%>From <%=DateTimeUtil.formatDate(calendar.getTime()) %> <%
	calendar.add(Calendar.WEEK_OF_YEAR, 2);
	%>To <%=DateTimeUtil.formatDate(calendar.getTime()) %><%
} %>