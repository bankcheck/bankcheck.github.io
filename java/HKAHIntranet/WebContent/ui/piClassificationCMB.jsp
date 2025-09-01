<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.constant.*"%>
<%
	String value = request.getParameter("value");
	String incidentType = request.getParameter("incidentType");
	String isOption =  request.getParameter("isOption");

	ArrayList classification = PiReportDB.fetchReportClassification();
	ReportableListObject row = null;

	if (classification.size() > 0) {
		if (isOption != null && isOption.equals("Y")) {
%>
			<option incidentType='' value=''></option>
<%
		}
		for (int i = 0; i < classification.size(); i++) {
			row = (ReportableListObject) classification.get(i);
			int width = row.getValue(4).length()/2;
			String must = null;
			//System.out.println(row.getValue(6));
			if (row.getValue(6).length() > 0) {
				must = row.getValue(6).substring(2);
			}

			if (incidentType != null && incidentType.length() > 0
					&& !incidentType.equals(row.getValue(1)) && !incidentType.equals("null")) {
				//continue;
			}
			if (isOption != null && isOption.equals("Y")) {
%>
				<option incidentType='<%=row.getValue(1)%>' <%=must!=null?"must='"+must+"'":"" %> value='<%=row.getValue(0) %>' <%=(value!=null && value.equals(row.getValue(0)))?"selected":"" %>><%=row.getValue(4) %></option>
<%
			}
			else {
%>
				<td width="<%=width<10?10:width%>%">
					<input incidentType='<%=row.getValue(1)%>' name="incidentClass" type="radio"
						value="<%=row.getValue(0) %>" <%=(value!=null?(value.equals(row.getValue(0))?"checked":""):"") %>
						<%=must!=null?"must='"+must+"'":"" %>/><%=row.getValue(4) %>
				</td>
<%
			}
		}
	}
%>