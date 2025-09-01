<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ page import="java.util.*"%>
<%
String newsCategory = request.getParameter("newsCategory");
String newsSender = request.getParameter("newsSender");
boolean isExecutiveOrder = false;
if ("executive order".equals(newsCategory)) {
	isExecutiveOrder = true;
}
%>
<%if (isExecutiveOrder) { %>
<option value="from ceo"<%="from ceo".equals(newsSender)?" selected":"" %>>from CEO</option>
<option value="from vice president for medical affairs"<%="from vice president for medical affairs".equals(newsSender)?" selected":"" %>>from Vice President for Medical Affairs</option>
<option value="from vice president for administration"<%="from vice president for administration".equals(newsSender)?" selected":"" %>>from Vice President for Administration</option>
<option value="from medical program administrator"<%="from medical program administrator".equals(newsSender)?" selected":"" %>>from Medical Program Administrator</option>
<option value="from human resource director"<%="from human resource director".equals(newsSender)?" selected":"" %>>from Human Resource Director</option>
<option value="from nursing administrator"<%="from nursing administrator".equals(newsSender)?" selected":"" %>>from Nursing Administrator</option>
<%} else {%>
<option value="from ceo"<%="from ceo".equals(newsSender)?" selected":"" %>>from CEO</option>
<option value="from vice president for medical affairs"<%="from vice president for medical affairs".equals(newsSender)?" selected":"" %>>from Vice President for Medical Affairs</option>
<option value="from vice president for physician services"<%="from vice president for physician services".equals(newsSender)?" selected":"" %>>from Vice President for Physician Services</option>
<option value="from chief of medical staff"<%="from chief of medical staff".equals(newsSender)?" selected":"" %>>from Chief of Medical Staff</option>
<%}%>