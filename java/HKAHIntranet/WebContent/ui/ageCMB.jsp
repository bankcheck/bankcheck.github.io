<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>

<%
String label = request.getParameter("label");
String ageyrs = request.getParameter(label + "_ageyrs");
String agemths = request.getParameter(label + "_agemths");
String yearRange = request.getParameter("yearRange");
boolean isMonthOnly = "Y".equals(request.getParameter("isMonthOnly"));
boolean isYearOnly = "Y".equals(request.getParameter("isYearOnly"));

int range = 100;
if(yearRange != null){
	range = Integer.parseInt(yearRange);
}
if(!isMonthOnly)
{
%>
<select name = "<%=label%>_ageyrs" id="<%=label%>_ageyrs">
	<option value='ALL'>ALL</option>
<%
for (int i = 0; i < range ; i++ ){
	if(ageyrs!= null && !ageyrs.equals("ALL")){
		if(i==Integer.parseInt(ageyrs)){
%>
	<option value="<%=i%>" SELECTED ><%=i %></option>
<%
		}else{
%>
	<option  value="<%=i%>"><%=i %></option>
<%
		}	
	}
	else{
%>
	<option value="<%=i%>"><%=i %></option>
<%
	}
}
%>
</select>
yrs 
<%
}
if(!isYearOnly){
%>
<select name = "<%=label%>_agemths" id="<%=label%>_agemths">
	<option value='ALL'>ALL</option>
<%
for (int i = 0; i < 13 ; i++ ){
	if(agemths!= null && !agemths.equals("ALL")){
		if(i==Integer.parseInt(agemths)){
%>
	<option value="<%=i%>" SELECTED ><%=i %></option>
<%
		}else{
%>
	<option  value="<%=i%>"><%=i %></option>
<%
		}	
	}
	else{
%>
	<option value="<%=i%>"><%=i %></option>
<%
	}
}
%>
</select>
mths
<%
}
%>
