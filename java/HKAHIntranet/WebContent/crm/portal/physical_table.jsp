<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.util.*"%>

<%!
private String printData(ArrayList data, String className) {
	StringBuffer content = new StringBuffer();
	
	content.append("<tr>");
	for(int i = 0; i < data.size(); i++) {
		content.append("<td class='"+className+"' style='width:10%'>"+data.get(i)+"</td>");
	}
	for(int i = 0; i < 10-data.size(); i++) {
		content.append("<td class='"+className+"' style='width:10%'>&nbsp;</td>");
	}
	content.append("</tr>");
	
	return content.toString();
}
%> 

<%
UserBean userBean = new UserBean(request);
String figureID = request.getParameter("figureID");
String clientID = request.getParameter("clientID");
String groupID = request.getParameter("groupID");
String displayOnly = request.getParameter("displayOnly");
String dataName = request.getParameter("dataName");
if(dataName!=null&&dataName.length()>0){
	
}else{
	dataName = "physical-data";
}

String measure = TextUtil.parseStrUTF8(
						java.net.URLDecoder.decode(
								request.getParameter("measure").replaceAll("%", "%25")));

Calendar cal = Calendar.getInstance();
SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
ArrayList result;

if("Y".equals(displayOnly)){
	if(groupID!=null && groupID.length()>0 && !"null".equals(groupID)){		
		result = CRMClientPhysical.getTeamAllFigures(groupID,figureID) ;
	}else{
		result = CRMClientPhysical.getAllFigures(CRMClientDB.getClientID(clientID),figureID);
	}
}else{
	result = CRMClientPhysical.getAllFigures(CRMClientDB.getClientID(userBean.getLoginID()),figureID);
}
ReportableListObject row = null;
%>
<div class="infoBox">
	<div class="infoHead">
		<h6>History</h6>
	</div>
	<div class="infoContent">
		<div class="content">
			<div id='scroll-pane' class='scroll-pane jspScrollable' style='overflow: hidden; padding: 0px; width:100%; height:150px'>
										
			<table border='0' id='physicalTable'>
			<%
			if(result.size() > 0) {
				ArrayList field = new ArrayList();
				ArrayList data = new ArrayList();
				for(int i = 0; i < result.size(); i++) {
					row = (ReportableListObject)result.get(i);
					
					if(i != 0 && i%10 == 0) {
			%>			
						<%=printData(field, "crmField2") %>
						<%=printData(data, "crmData2") %>
			<%
						field = new ArrayList();
						data = new ArrayList();
					}
					field.add("<span class='"+dataName+"-date'>"+row.getValue(2)+"</span>");
					if("Y".equals(displayOnly)){
						data.add("<span class='"+dataName+"-value'>"+row.getValue(1)+"</span> "+measure);
					}else{
						data.add("<span class='"+dataName+"-value'>"+row.getValue(1)+"</span> "+measure +
								" <img width='16' eventID='"+row.getValue(3)+"' scheduleID='"+row.getValue(4)+"' "+ 
								" userType='"+row.getValue(5)+"' userID='"+row.getValue(6)+"' figureID='"+row.getValue(0)+"' recordCount='"+row.getValue(7)+"' "+
								" onClick='removePhydata(this)' src='../../images/remove-button.gif'>");
					}
				}
			%>
				<%=printData(field, "crmField2") %>
				<%=printData(data, "crmData2") %>
			<%
			}
			%>
			</table>
			</div>
		</div>
	</div>
</div>
<%
	if("Y".equals(displayOnly)){
	}else{
%>

<div class="infoBox">
	<div class="infoHead">
		<h6>New Record</h6>
	</div>
	<div class="infoContent">
		<div class="content">
			<table>
				<tr>
					<td class='crmField2' style='width:25%' colspan='2'>
					DATE: <input type="text" name="phyDate" id="phyDate" class="datepickerfield" value="<%=sdf.format(cal.getTime()) %>" style="width:40%" size="15" onkeyup="validDate(this)" onblur="validDate(this)">
					
					<td class='crmField2' style='width:65%' colspan='8'>&nbsp;</td>
				</tr>
				<tr>
					<td class='crmData2' style='width:25%;text-align:right' colspan='2'>
						<input name="phyValue" value='' type="text" style="width:40%"/> <%=measure %>
					</td>
					<td class='crmData2' style='width:65%' colspan='8'>
						<button type='button' class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" 
								onclick="submitAction('add')">
							Save
						</button>
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>
<%}%>
<script>
var apis = [];	
$(document).ready(function(){
	
	initScroll('.scroll-pane');
});

function initScroll(pane) {
	destroyScroll();		
$(pane).each(
		function()
		{
			apis.push($(this).jScrollPane({autoReinitialise:false}).data().jsp);
		}
	);
	return false;
}

function destroyScroll() {
if (apis.length) {
	$.each(
		apis,
			function(i) {
			this.destroy();
		}
	);
	apis = [];
}
return false;
}	

</script>