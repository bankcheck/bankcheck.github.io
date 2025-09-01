<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);
Calendar cal = Calendar.getInstance();
SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm", Locale.ENGLISH);

String type = request.getParameter("type");
String pirID = request.getParameter("pirID");
%>
<%if ("action".equals(type)) { %>
	<table border='1' style="background-color:#FFF0FF; border-style:solid; border-color:black;"
			class="contentFrameMenu content-table"
			cellpadding="0">
		<tr class="smallText"><td  colspan="4" style="background-color:#32A2F2" class="infoSubTitle5">Send Email</td></tr>
		<tr>
			<td class="infoLabel" style="width:15%;">Department</td>
			<td class="infoData" style="width:15%">
				<select name="followUp_dept" onChange="selectDeptEvent(this)" style="width:90%">
					<option value=""></option>
					<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
						<jsp:param name="deptCode" value='' />
						<jsp:param name="allowAll" value="Y" />
						<jsp:param name="includeAllDept" value="Y"/>
					</jsp:include>
				</select>
			</td>
		</tr>
		<tr>
			<td class="infoLabel" style="width:10%">Name</td>
			<td class="infoData" style="width:20%">
				<select  style="width:90%" name="followUp_staff">
				</select>
			</td>
			<td class="infoLabel" style="width:10%">Email</td>
			<td class="infoData" >
				<input type="textbox"  style="width:70%" name="followUp_staffEmail" />
				<button type='button' style="display:none;" onClick='saveStaffEmail()' class="saveEmail ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
					Save Email
				</button>
			</td>
		</tr>
		<tr>
			<td colspan="3"></td>
			<td align="left">
				<button type="button" onClick="insertEmailEvent('insertTo')" class="insertTO ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
					Add to "TO"
				</button>
				&nbsp;
				<button type="button" onClick="insertEmailEvent('insertCC')" class="insertCC ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
					Add to "CC"
				</button>
				<button type="button" onClick="insertEmailEvent('insertBCC')" class="insertBCC ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
					Add to "BCC"
				</button>
			</td>
		</tr>
		<tr>
			<td class="infoLabel">TO</td>
			<td class="infoData" colspan="5">
				<div class="toStaff"></div>
			</td>
		</tr>
		<tr>
			<td class="infoLabel">CC</td>
			<td class="infoData" colspan="5">
				<div class="ccStaff"></div>
			</td>
		</tr>
		<tr>
			<td class="infoLabel">BCC</td>
			<td class="infoData" colspan="5">
				<div class="bccStaff"></div>
			</td>
		</tr>
		<tr>
			<td class="infoLabel">Action</td>
			<td class="infoData" colspan="5">
				<input type="textbox" style="width:80%" name="followUp_action" />
			</td>
		</tr>
		<tr>
			<td class="infoLabel">Remark</td>
			<td class="infoData" colspan="5">
				<textarea rows="5" style="width:100%" name="followUp_remark"></textarea>
			</td>
		</tr>
		<tr>
			<td class="infoLabel">Email Notice</td>
			<td class="infoData" colspan="5">
				<input type="radio" name="followUp_email" value="Y"/>Yes
				<input CHECKED type="radio" name="followUp_email" value="N"/>No
			</td>
		</tr>
		<span id='emailDisplaySpan' style="display:none;">
			<tr>
				<td class="infoLabel">Send Reminder(Auto) per week</td>
				<td class="infoData" colspan="5" align="left">
					<input type="radio" name="followUp_reminder" value="Y"/>Yes
					<input CHECKED type="radio" name="followUp_reminder" value="N"/>No
				</td>
			</tr>
			<tr>
				<td class="infoLabel">Status</td>
				<td class="infoData" colspan="5" align="left">
					<input type="radio" name="followUp_status" value="process"/>Processing
					<input CHECKED type="radio" name="followUp_status" value="complete"/>Complete
				</td>
			</tr>
			<tr>
				<td class="infoData"></td>
				<td class="infoData" colspan="3">
				<button type="button" onClick="sendEmail('<%=pirID %>')" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
							Send Email
				</button>
				</td>
			</tr>
		</span>
	</table>
<%}
else if ("reply".equals(type)) {
	String flwUpID = request.getParameter("flwUpID");
	ArrayList record = PiReportDB.fetchFlwUpMessage(pirID,flwUpID);
	ReportableListObject row = null;
	if (record.size() > 0) {
		row = (ReportableListObject)record.get(0);
		String emailPirID = row.getValue(0);
		String emailFlwUpID = row.getValue(1);
		String emailToStaff = row.getValue(2);
		String emailCcStaff = row.getValue(3);
		String emailBccStaff = row.getValue(4);
		String emailAction = row.getValue(5);
		String emailRemark = row.getValue(6);
		String emailSend = row.getValue(7);
		String emailReminder = row.getValue(8);
		String emailStatus = row.getValue(9);

		String[] toStaffList = emailToStaff.split(";");
		String[] ccStaffList = emailCcStaff.split(";");
		String[] bccStaffList = emailBccStaff.split(";");

%>
	<table  border='1' style="background-color:#FFF0FF; border-style:solid; border-color:black;"
			class="content-table"
			cellpadding="0" width="100%">
		<tr class="smallText"><td colspan="8" style="background-color:#32A2F2" class="infoSubTitle5">Email Info</td></tr>
		<tr >
			<td width="15%" class="infoLabel">TO</td>
			<td class="infoData" colspan="5">
<%
	if (!emailToStaff.isEmpty()){
		for(String s:toStaffList){
			ArrayList staffRecord = StaffDB.getStaffNameDeptByEmail(s);
			String staffName = "";
			String staffDept = "";
			if (staffRecord.size()>0){
				ReportableListObject staffRow = (ReportableListObject)staffRecord.get(0);
				staffName=staffRow.getValue(0);
				staffDept=staffRow.getValue(1);
%>
				[<%=staffName%> (<%=staffDept%>): <b><%=s %></b>]</br>
<%			}else{%>
				<b><%=s %></b></br>
<%
			}
		}
	}

%>
			</td>
		</tr>
		<tr>
			<td class="infoLabel">CC</td>
			<td class="infoData" colspan="5">
<%
	if (!emailCcStaff.isEmpty()){
		for(String s:ccStaffList){
			ArrayList staffRecord = StaffDB.getStaffNameDeptByEmail(s);
			String staffName = "";
			String staffDept = "";
			if (staffRecord.size()>0){
				ReportableListObject staffRow = (ReportableListObject)staffRecord.get(0);
				staffName=staffRow.getValue(0);
				staffDept=staffRow.getValue(1);
%>
				[<%=staffName%> (<%=staffDept%>): <b><%=s %></b>]</br>
<%			}else{%>
				<b><%=s %></b></br>
<%
			}
		}
	}
%>
			</td>
		</tr>
		<tr>
			<td class="infoLabel">BCC</td>
			<td class="infoData" colspan="5">
<%
	if (!emailBccStaff.isEmpty()){
		for(String s:bccStaffList){
			ArrayList staffRecord = StaffDB.getStaffNameDeptByEmail(s);
			String staffName = "";
			String staffDept = "";
			if (staffRecord.size()>0){
				ReportableListObject staffRow = (ReportableListObject)staffRecord.get(0);
				staffName=staffRow.getValue(0);
				staffDept=staffRow.getValue(1);
%>
				[<%=staffName%> (<%=staffDept%>): <b><%=s %></b>]</br>
<%			}else{%>
				<b><%=s %></b></br>
<%
			}
		}
	}
%>
			</td>
		</tr>
		<tr>
			<td class="infoLabel">Action</td>
			<td class="infoData" colspan="5">
				<%=emailAction %>
			</td>
		</tr>
		<tr>
			<td class="infoLabel">Remark</td>
			<td class="infoData" colspan="5">
				<%=emailRemark %>
			</td>
		</tr>
		<tr>
			<td class="infoLabel">Email Notice</td>
			<td class="infoData" colspan="5">
		<%
		String tempEmailSend = "";
		if ("Y".equals(emailSend)){
			tempEmailSend = "Yes";
		}else if ("N".equals(emailSend)){
			tempEmailSend = "No";
		}
		%>
			<%=tempEmailSend %>
			</td>
		</tr>
		<tr>
			<td class="infoLabel">Send Reminder(Auto) per week</td>
			<td class="infoData" colspan="5" align="left">
		<%
		String tempEmailReminder = "";
		if ("Y".equals(emailReminder)){
			tempEmailReminder = "Yes";
		}else if ("N".equals(emailReminder)){
			tempEmailReminder = "No";
		}
		%>
			<%=tempEmailReminder %>
			</td>
		</tr>
		<tr>
			<td class="infoLabel">Status</td>
			<td class="infoData" colspan="5" align="left">
		<%
		String tempEmailStatus = "";
		if ("process".equals(emailStatus)){
			tempEmailStatus = "Process";
		}else if ("complete".equals(emailStatus)){
			tempEmailStatus = "Complete";
		}
		%>
			<%=tempEmailStatus%>
			</td>
		</tr>
	</table>
<%
	}
%>

<%
	ArrayList replyRecord = PiReportDB.fetchFlwUpAllReply(pirID,flwUpID);
	ReportableListObject replyRow = null;
	if (replyRecord.size() > 0) {
		%>
	<table width="100%" border='1' style="background-color:#FFF0FF; border-style:solid; border-color:black;"
		class="contentFrameMenu content-table"
		cellpadding="0">
		<tr class="smallText"><td  colspan="4" style="background-color:#32A2F2" class="infoSubTitle5">Reply Messages</td></tr>
		<%
		for(int i = 0; i < replyRecord.size(); i++) {
			replyRow = (ReportableListObject)replyRecord.get(i);
%>
		<tr>
			<td class="infoLabel" >Created User</td>
			<td class="infoData">
				<%=StaffDB.getStaffFullName(replyRow.getValue(4) )%>
			</td>

			<td class="infoLabel">Date</td>
			<td class="infoData">
				<%=replyRow.getValue(5) %>
			</td>

		</tr>
		<tr>
			<td width="14%" class="infoLabel">Reply Message</td>
			<td class="infoData" colspan="3" >
				<%=replyRow.getValue(3) %>
			</td>
		</tr>
		<tr><td colspan="4"><hr/></td></tr>
<%
		}
%>
	</table>
<%
	}
%>
	</br>
	<table width="100%" border='1' style="background-color:#FFF0FF; border-style:solid; border-color:black;"
		class="contentFrameMenu content-table"
		cellpadding="0">
		<tr class="smallText"><td  colspan="4" style="background-color:#32A2F2" class="infoSubTitle5">Reply </td></tr>
		<tr>
			<td class="infoLabel">User Name</td>
			<td class="infoData">
				<%=StaffDB.getStaffFullName(userBean.getLoginID()) %>
			</td>
			<td class="infoLabel">Date</td>
			<td class="infoData" >
				<%=sdf.format(cal.getTime()) %>
			</td>
		</tr>
		<tr>
			<td class="infoLabel">Reply Message</td>
			<td colspan="4" class="infoData">
				<textarea rows="5" style="width:100%" name="followUp_reply_msg"></textarea>
			</td>
		</tr>
		<tr>
		<td class="infoData"></td>
		<td colspan="4" class="infoData">
			<button type="button" onClick="return submitReply('<%=pirID%>','<%=flwUpID%>')" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
				Submit Reply
			</button>

		</td>
		</tr>
	</table>
<%}
else if ("list".equals(type)) {
	ArrayList record = PiReportDB.fetchFlwUpList(pirID);
	ReportableListObject row = null;
%>
	<table border='1' style="background-color:#FFF0FF; border-style:solid; border-color:black; width:100%; height:600px;"
			cellpadding="0" class="reply-index">
			<tr>
				<td colspan="2">
					<button type="button" onClick="createNewContent(this)" class="flwUpBtn ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"
								style="width:100%">
						New Email
					</button>
				</td>
			</tr>
			<tr><td colspan="2"><hr/></td></tr>
<%
	if (record.size() > 0) {
		for(int i = 0; i < record.size(); i++) {
			row = (ReportableListObject)record.get(i);
%>
			<tr>
				<td>
					<button type="button" class="flwUpBtn ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"
								onClick="displaySelectedEmail(this)" style="width:100%"  flwUpID='<%=row.getValue(1) %>'>
						<%=row.getValue(2) %>
					</button>
				</td>
				<%if (userBean.isAccessible("function.pi.report.admin")) { %>
					<td><img width="16" onClick="removeEmail(this)" pirID='<%=pirID %>' flwUpID='<%=row.getValue(1) %>' src="../images/remove-button.gif"></td>
				<%} %>
			</tr>
<%
		}
	}
%>
			<tr style="height:100%">
				<td>
				</td>
			</tr>
	</table>
<%
}
%>