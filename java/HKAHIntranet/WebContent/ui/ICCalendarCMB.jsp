<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.servlet.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>

<%
String Month = request.getParameter("Month");
String Year = request.getParameter("Year");

ArrayList record = ICPageDB.getEvent(Integer.parseInt(Month),Integer.parseInt(Year));
ReportableListObject row = null;
StringBuffer temp = new StringBuffer();

	if(record != null){
		for(int i =0;i<record.size();i++){			
			row = (ReportableListObject) record.get(i);
			if(temp!= null&&temp.length()>0){
				temp.append("[s]");
			}
			temp.append(row.getValue(1)+"[e]"+row.getValue(0));

		}
	}

%>

<%=temp.toString()%>