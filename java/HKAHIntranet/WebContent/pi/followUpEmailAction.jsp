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
<% if(type.equals("reply")) {
	String flwUpID = request.getParameter("flwUpID");
	ArrayList record = PiReportDB.fetchFlwUpMessage(pirID,flwUpID);
	ReportableListObject row = null;
	if(record.size() > 0) {
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
	if(!emailToStaff.isEmpty()){
		for(String s:toStaffList){
			ArrayList staffRecord = StaffDB.getStaffNameDeptByEmail(s);
			String staffName = "";
			String staffDept = "";
			if(staffRecord.size()>0){
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
	if(!emailCcStaff.isEmpty()){
		for(String s:ccStaffList){
			ArrayList staffRecord = StaffDB.getStaffNameDeptByEmail(s);
			String staffName = "";
			String staffDept = "";
			if(staffRecord.size()>0){
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
	if(!emailBccStaff.isEmpty()){
		for(String s:bccStaffList){
			ArrayList staffRecord = StaffDB.getStaffNameDeptByEmail(s);
			String staffName = "";
			String staffDept = "";
			if(staffRecord.size()>0){
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
		if("Y".equals(emailSend)){
			tempEmailSend = "Yes";
		}else if("N".equals(emailSend)){
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
		if("Y".equals(emailReminder)){
			tempEmailReminder = "Yes";
		}else if("N".equals(emailReminder)){
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
		if("process".equals(emailStatus)){
			tempEmailStatus = "Process";
		}else if("complete".equals(emailStatus)){
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
	if(replyRecord.size() > 0) {
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
else if(type.equals("list")) {
	String currentStaffEmail = StaffDB.getStaffEmail(userBean.getStaffID());	
	boolean noList = true;
	ArrayList record = PiReportDB.fetchFlwUpList(pirID);
	ReportableListObject row = null;
%>
	<table border='1' style="background-color:#FFF0FF; border-style:solid; border-color:black; width:100%; height:600px;" 
			cellpadding="0" class="reply-index">
		
<%
	if(record.size() > 0) {
		for(int i = 0; i < record.size(); i++) {
			row = (ReportableListObject)record.get(i);	
			boolean isEmailForStaff = false;
			
			ArrayList messageRecord = PiReportDB.fetchFlwUpMessage(pirID,row.getValue(1));
			ReportableListObject messageRow = null;
			if(messageRecord.size() > 0) {
				messageRow = (ReportableListObject)messageRecord.get(0);
				String emailPirID = messageRow.getValue(0);
				String emailFlwUpID = messageRow.getValue(1);
				String emailToStaff = messageRow.getValue(2);
				String emailCcStaff = messageRow.getValue(3);
				String emailBccStaff = messageRow.getValue(4);
				String emailAction = messageRow.getValue(5);
				String emailRemark = messageRow.getValue(6);
				String emailSend = messageRow.getValue(7);
				String emailReminder = messageRow.getValue(8);
				String emailStatus = messageRow.getValue(9);
				
				String[] toStaffList = emailToStaff.split(";");
				String[] ccStaffList = emailCcStaff.split(";");
				String[] bccStaffList = emailBccStaff.split(";");
				
				
				if(!emailToStaff.isEmpty()){
					for(String s:toStaffList){
						if(s.equals(currentStaffEmail)){
							isEmailForStaff=true;
						}
					}
				}
				
				if(!emailCcStaff.isEmpty()){
					for(String s:ccStaffList){
						if(s.equals(currentStaffEmail)){
							isEmailForStaff=true;
						}
					}
				}
				if(!emailBccStaff.isEmpty()){
					for(String s:bccStaffList){
						if(s.equals(currentStaffEmail)){
							isEmailForStaff=true;
						}
					}
				}			
			}
			
			if(isEmailForStaff || userBean.isAdmin()){			
%>
			<tr>
				<td>
					<button type="button" class="flwUpBtn ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"
								onClick="displaySelectedEmail(this)" style="width:100%"  flwUpID='<%=row.getValue(1) %>'>
						<%=row.getValue(2) %>
					</button>					
				</td>				
			</tr>
<%	
			noList=false;
			}
		}
	}
	if(noList){
%>
			<tr><td>Cannot find any follow up email record.</td></tr>
<%
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
