<%@ page language="java" contentType="text/html; charset=big5" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
String doctorCode = request.getParameter("doctorCode");
String expectedDeliveryDate = request.getParameter("expectedDeliveryDate");
int monthMLQuota = 0;
int monthMLQuotaC1 = 0;
int monthMLQuotaC2 = 0;
int monthHKQuota = 0;

ArrayList<ReportableListObject> record = OBBookingDB.getQuota(doctorCode, expectedDeliveryDate);

if (record.size() > 0) {
	ReportableListObject row = (ReportableListObject) record.get(0);
	try { monthMLQuota = Integer.parseInt(row.getValue(3)); } catch (Exception e) {}
	try { monthMLQuotaC1 = Integer.parseInt(row.getValue(4)); } catch (Exception e) {}
	try { monthMLQuotaC2 = Integer.parseInt(row.getValue(5)); } catch (Exception e) {}
	try { monthHKQuota = Integer.parseInt(row.getValue(6)); } catch (Exception e) {}
	%>Remain Quota (HK : <%=monthHKQuota==0?"TBC":monthHKQuota %>), (Mainland: <%=monthMLQuota==0?"TBC":monthMLQuota %>)<%
} else {
	%>No Quota Available<%
}
%>