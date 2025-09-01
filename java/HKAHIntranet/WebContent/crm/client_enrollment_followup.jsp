<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
String eventID = request.getParameter("eventID");
String scheduleID = request.getParameter("scheduleID");
String clientID = request.getParameter("clientID");
String remarkField = request.getParameter("remarkField");
String followupresult = request.getParameter("followupresult");
boolean updateAction = "update".equals(request.getParameter("commandType"));

followupresult = EnrollmentDB.getFollowup(eventID,scheduleID,clientID);
ArrayList record = EnrollmentDB.getremarkList(eventID,clientID,scheduleID);

// get followup option or remark

%>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">

	<tr class="smallText">
	<td class="infoLabel" width="40%">Has Follow Up?</td>
		<td>		
	<% if(updateAction){%>
	<input type="checkbox" name="hasfollowup" id ="hasfollowup" value="Y" onclick="ongetFollowup();" <%if("Y".equals(followupresult)){ %>checked="checked"<%} else if("N".equals(followupresult)) {%> unchecked <%} %>>Follow Up?</input>	
	<% }
	else{ %>
	<input type="checkbox" name="hasfollowup" id ="hasfollowup" value="Y" disabled="disabled" <%if("Y".equals(followupresult)){ %>checked="checked"<%} else if("N".equals(followupresult)) {%> unchecked <%} %>>Follow Up?</input>	
	
	<% }%>
		</td>		
	</tr>

	<tr id="remarkButton">
	<td class="infoLabel" width="20%">Remarks</td>
	<td width="70%">
	<%if(updateAction){ %>
	<button onclick="return createremark();" class="btn-click">create remark</button></td>
	<%} %>
	</tr>
	
	<tr id="inputremark" style="display:none">
	<td class="infoLabel" width="20%">Remarks</td>
	<td width="70%">
	<div class="box"><textarea id="wysiwyg" name="remarkField" rows="10" cols="80"><%=remarkField==null?"":remarkField %></textarea></div>
	</td>
	</tr>
		
	<tr id="remarkControl" style="display:none">
	<td width="20%"></td>
	<td width="70%">
	<button onclick="return submitremark();" class="btn-click">Submit remark</button></td>
	</tr>
	
	<%ReportableListObject row = null; 
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
%>
	<tr class="smallText" id="remark_show_<%=i %>">
		<td class="infoLabel" width="20%"></td>
		<td class="infoData" width="70%" ><%=row.getValue(0)%> 
		<br>( From: <%=row.getValue(1)%>    Date: <%=row.getValue(2) %>) 
		<%if(updateAction){ %>
		 <a href="javascript:editRemark(<%=i %>,<%=record.size()%>);">edit</a>
		<%}%>
		</td>
	</tr>
	<tr class="smallText" id="remark_edit_<%=i %>" style="display:none">
	<td class="infoLabel" width="20%"></td>
	<td class="infoData" width="70%">
	<div class="box"><textarea id="wysiwyg" name="remark_input_<%=i %>" rows="10" cols="80"><%=row.getValue(0)==null?"":row.getValue(0) %></textarea></div>
	<button onclick="return updateremark(<%=row.getValue(3) %>, <%=i%>);" class="btn-click">Update</button></td>
	</tr>
	
<% 	
   } 
  }
%>

	
</table>

