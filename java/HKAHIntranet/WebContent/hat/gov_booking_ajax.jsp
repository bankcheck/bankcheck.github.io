<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
private static ArrayList getItem(String govPosition, String sex) {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT	G.ITMCODE, I.ITMNAME, G.GUIDELINE "); 
	sqlStr.append("FROM		GOVITEM@IWEB G, ITEM@IWEB I ");
	sqlStr.append("WHERE   	G.ITMCODE = I.ITMCODE ");
	sqlStr.append("AND 		G.GOVJOBCODE = '" + govPosition + "' ");
	sqlStr.append("AND 		G.GOVSEX LIKE '%" + sex + "%' ");
	sqlStr.append("AND		I.ITMTYPE != 'D' ");
	sqlStr.append("ORDER BY G.ITMCODE ");

	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
	<tr>
		<th width="5%">#</th>
		<th width="15%">Test Code</th>
		<th width="40%">Test Name</th>
		<th width="40%">Guideline</th>
	</tr>
	<tr>
<% 
String govDept = request.getParameter("govDept"); 
String govPosition = request.getParameter("govPosition");
String sex = request.getParameter("sex");
boolean action = "true".equals(request.getParameter("action"));
if(action){
	if("B".equals(govPosition.substring(govPosition.length()-1))){
	%>
		<script>
			$("#catB").show();
			alert("This position is in category B. \nPlease add Cat B consultation date for test.");
			document.govBookingForm.catBposition.value = "true";
		</script>
	<%
	}else{
	%>
		<script>
			$("#catB").hide();
			document.govBookingForm.catBposition.value = "false";
		</script>
	<%
	}
}

ArrayList record = new ArrayList();

record = getItem(govPosition, sex);
if(record.size() > 0){
	for(int i=0; i<record.size(); i++){
		ReportableListObject row = (ReportableListObject) record.get(i);
%>
		<td><%=i+1 %></td>
		<td><%=row.getValue(0) %></td>
		<td><%=row.getValue(1) %></td>
		<td><%=row.getValue(2) %></td>
		</tr>
<%
	}
}
%>
				
