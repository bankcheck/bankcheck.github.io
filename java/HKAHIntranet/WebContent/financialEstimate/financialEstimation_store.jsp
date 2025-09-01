<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="com.hkah.util.*" %>
<%@ page import="com.hkah.web.common.*" %>
<%
UserBean userBean = new UserBean(request);

String regid = request.getParameter("regid");
String patno = request.getParameter("patno");
String group = request.getParameter("group");

String doccode = request.getParameter("DocSelect");
if (doccode == null) {
	doccode = request.getParameter("doccode");
}
String docname = request.getParameter("DocInput");
String procedure1 = request.getParameter("ProcedureSelect1");
String procedure2 = request.getParameter("ProcedureSelect2");
String DiagnosisText = TextUtil.parseStrUTF8(request.getParameter("DiagnosisText"));
String acmcode = request.getParameter("acmSelect");
String day = request.getParameter("DaySelect");

String showdate = request.getParameter("showdate");
String staffID = userBean.getStaffID();

String DocRoundFeeMinInput = request.getParameter("DocRoundFeeMinInput");
String DocRoundFeeMaxInput = request.getParameter("DocRoundFeeMaxInput");
String ProFeeMinInput = request.getParameter("ProFeeMinInput");
String ProFeeMaxInput = request.getParameter("ProFeeMaxInput");
String AnaesthetistFeeMinInput = request.getParameter("AnaesthetistFeeMinInput");
String AnaesthetistFeeMaxInput = request.getParameter("AnaesthetistFeeMaxInput");
String OtherMin1Input = request.getParameter("OtherMin1Input");
String OtherMax1Input = request.getParameter("OtherMax1Input");
String OtherMin2Input = request.getParameter("OtherMin2Input");
String OtherMax2Input = request.getParameter("OtherMax2Input");

String RoomChgMinInput = request.getParameter("RoomChgMinInput");
String RoomChgMaxInput = request.getParameter("RoomChgMaxInput");
String OTMinInput = request.getParameter("OTMinInput");
String OTMaxInput = request.getParameter("OTMaxInput");
String OtherMin3Input = request.getParameter("OtherMin3Input");
String OtherMax3Input = request.getParameter("OtherMax3Input");
String totalMinInput = request.getParameter("totalMinInput");
String totalMaxInput = request.getParameter("totalMaxInput");

// store in session
session.setAttribute("doccode", doccode);
session.setAttribute("docname", docname);
session.setAttribute("ProcedureSelect1", procedure1);
session.setAttribute("ProcedureSelect2", procedure2);
session.setAttribute("DiagnosisText", DiagnosisText);
session.setAttribute("acmcode", acmcode);
session.setAttribute("day", day);

session.setAttribute("showdate", showdate);

session.setAttribute("DocRoundFeeMinInput", DocRoundFeeMinInput);
session.setAttribute("DocRoundFeeMaxInput", DocRoundFeeMaxInput);
session.setAttribute("ProFeeMinInput", ProFeeMinInput);
session.setAttribute("ProFeeMaxInput", ProFeeMaxInput);
session.setAttribute("AnaesthetistFeeMinInput", AnaesthetistFeeMinInput);
session.setAttribute("AnaesthetistFeeMaxInput", AnaesthetistFeeMaxInput);
session.setAttribute("OtherMin1Input", OtherMin1Input);
session.setAttribute("OtherMax1Input", OtherMax1Input);
session.setAttribute("OtherMin2Input", OtherMin2Input);
session.setAttribute("OtherMax2Input", OtherMax2Input);

session.setAttribute("RoomChgMinInput", RoomChgMinInput);
session.setAttribute("RoomChgMaxInput", RoomChgMaxInput);
session.setAttribute("OTMinInput", OTMinInput);
session.setAttribute("OTMaxInput", OTMaxInput);
session.setAttribute("OtherMin3Input", OtherMin3Input);
session.setAttribute("OtherMax3Input", OtherMax3Input);
session.setAttribute("totalMinInput", totalMinInput);
session.setAttribute("totalMaxInput", totalMaxInput);

response.sendRedirect("/intranet/cms/price_quotation.jsp?source=fe&regid=" + (regid==null?"":regid) + "&patno=" + (patno==null?"":patno) + "&user=" + userBean.getStaffID() + "&acmcode=" + acmcode + "&group=" + (group==null?"":group) );
%>