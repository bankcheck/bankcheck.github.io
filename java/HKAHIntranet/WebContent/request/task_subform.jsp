<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.constant.*"%>
<%
UserBean userBean = new UserBean(request);
String staffID = request.getParameter("staffID");
String taskDate = request.getParameter("taskDate");
	
ArrayList record = null;
record = RequestDB.getTask(staffID, taskDate);
String total = RequestDB.getManTimeTotal(staffID, taskDate);
	
ReportableListObject row = null;
String taskID;
String reqNo;
String task;
String manTime;
String reqName;
String taskDept;
String message = ConstantsVariable.EMPTY_VALUE;

ArrayList reqRec = null;
ReportableListObject reqRow = null;

int dayOfWeek = DateTimeUtil.parseDate(taskDate).getDay();
String holiday = RequestDB.getHoliday(taskDate);

if (holiday != null) {
	message = taskDate + " is " + holiday;
} else if (dayOfWeek == 0) {
	message = taskDate + " is Sunday";
} else if (dayOfWeek == 6) {
	message = taskDate + " is Saturday";
} else {
%>
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
		<tr class="smallText">
			<td class="infoLabel" width="15%">Request No</td>
			<td class="infoLabel" width="20%">Department</td>	
			<td class="infoLabel" width="40%">Task Description</td>
			<td class="infoLabel" width="5%">Man Time</td>
			<td class="infoLabel" width="20%">Action</td>
		</tr>
<%
if (record.size() > 0) {
	boolean showOption = false;
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		
		taskID = row.getValue(0);
		reqNo = row.getValue(1);
		task = row.getValue(2);
		manTime = row.getValue(3);
		taskDept = row.getValue(4);
		
		reqRec = RequestDB.get(reqNo);
		
		if (reqRec.size()> 0) {	
			reqRow = (ReportableListObject) reqRec.get(0);		
			reqName = reqRow.getValue(7);
		} else {
			reqName = "";
		}
%>
		<tr class="smallText">
			<form name="form_<%=taskID%>" id="form_<%=taskID%>" action="task_entry.jsp">
			<td class="infoData">
				<select name="reqNo" onChange="changeReqNo('form_<%=taskID%>')" style="width: 80px;">
		<option value="<%=reqNo%>" selected><%=reqNo%> - <%=reqName %></option>				
<%
		ArrayList assignReq = RequestDB.getAssignReq(staffID);
		ReportableListObject assignReqRow = null;
		if (assignReq.size() > 0) {
			for (int j = 0; j < assignReq.size(); j++) {
				assignReqRow = (ReportableListObject) assignReq.get(j);
%>
		<option value="<%=assignReqRow.getValue(0)%>" ><%=assignReqRow.getValue(0)%> - <%=assignReqRow.getValue(1)%></option>
<%
			}
		}
%>
				</select>
			</td>
			
			<td class="infoData">
				<select name="taskDept" style="width: 150px;">
					<option value=""></option>				
					<jsp:include page="../ui/jointDeptCodeCMB.jsp" flush="false">
						<jsp:param name="deptCode" value="<%=taskDept %>" />
					</jsp:include>
				</select>
			</td>
		
			<td class="infoData">
				<input type="textfield" name="task" id="task" value="<%=task==null?"":task %>" maxlength="500" size="50" />
			</td>
			
			<td class="infoData">
				<input type="textfield" name="manTime" id="manTime" value="<%=manTime==null?"":manTime %>" size="5" max=999.99 min=0/>
			</td>

			<td class="infoData">
				<button onclick="return updateAction('form_<%=taskID%>');">Save</button>
				<button onclick="return deleteAction('form_<%=taskID%>');">Delete</button>
				<input type="hidden" name="taskDate" id="taskDate" value="<%=taskDate==null?"":taskDate %>" />			
				<input type="hidden" name="taskID" id="taskID" value="<%=taskID==null?"":taskID %>" />
				<input type="hidden" name="command" id="command" />
				<input type="hidden" name="staffID" id="staffID" value=<%=staffID %> />
			</td>
		</tr>
		</form>					
<%		
	}
}
%>
		<tr class="smallText">
			<form name="form_new" id="form_new" action="task_entry.jsp">
			<td class="infoData">
				<select name="reqNo" onChange="changeReqNo('form_new')" style="width: 80px;">
<%
		ArrayList assignReq = RequestDB.getAssignReq(staffID);
		ReportableListObject assignReqRow = null;
		ReportableListObject defaultRow = null;
		if (assignReq.size() > 0) {
			defaultRow = (ReportableListObject) assignReq.get(0);
			
			for (int j = 0; j < assignReq.size(); j++) {
				assignReqRow = (ReportableListObject) assignReq.get(j);
%>
		<option value="<%=assignReqRow.getValue(0)%>" ><%=assignReqRow.getValue(0)%> - <%=assignReqRow.getValue(1)%></option>
<%
			}
		}
%>
				</select>
			</td>
			
			<td class="infoData">
				<select name="taskDept" style="width: 150px;">
					<option value=""></option>				
					<jsp:include page="../ui/jointDeptCodeCMB.jsp" flush="false"/>
				</select>
			</td>
			
			<td class="infoData">
				<input type="textfield" name="task" id="task" maxlength="500" size="50"/>
			</td>
			
			<td class="infoData">
				<input type="textfield" name="manTime" id="manTime" size="5" max=999.99 min=0/>
			</td>

			<td class="infoData">
				<button onclick="return newAction();">Save</button>
				<input type="hidden" name="taskDate" id="taskDate" value="<%=taskDate==null?"":taskDate %>" />	
				<input type="hidden" name="command" id="command" value="new" />
				<input type="hidden" name="staffID" id="staffID" value=<%=staffID %> />
			</td>							
		</tr>
		</form>	
		<tr class="smallText">
			<td class="infoData" colspan="3">Total Man Time</td>
			<td class="infoData">
				<input type="textfield" name="total" id="total" value="<%=total %>" size="5" readonly/>
			</td>
		</tr>		
</table>
<%}%>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
</jsp:include>