<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ taglib uri='http://java.sun.com/jsp/jstl/core' prefix='c'%>

<%
UserBean userBean = new UserBean(request);
if (userBean == null || !userBean.isLogin()) {
	%>
	<script>
		window.open("../index.jsp", "_self");
	</script>
	<%
	return;
}
String action = request.getParameter("action");

if(action.equals("view")) {
	boolean getList = "Y".equals(request.getParameter("getList"));
	boolean setRecord = "Y".equals(request.getParameter("setRecord"));
	boolean editRecord = "Y".equals(request.getParameter("editRecord"));
	if(getList) {		
		String staffID = request.getParameter("staffID");	
		int height = 450;
				
		
%>
		<tbody>	
		
<%
	String[] categoryString = new String[6];
	categoryString[0] = "Bible Study";
	categoryString[1] = "Contact";
	categoryString[2] = "Contact (Indirect)";
	categoryString[3] = "Counseling";
	categoryString[4] = "Decision for Christ";
	categoryString[5] = "Off Site Visitation";

	for(String servCategory:categoryString){
%>

			<tr bgcolor="#FFD067" style='width:100%;height:30px;'>
				<td colspan="2" style='width:160px;'>
				<%= servCategory %>
				</td>	
			</tr>						
			<tr style='width:100%;height:30px;'>
				<td style='width:160px; vertical-align:top;'>
					<button id='<%=servCategory%>_Staff' class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only record'
							style='width:160px;text-align:left; height:30px; font-size:15px;'>
						- Staff
					</button>
				</td>
				<td>
				<table width='100%'>	
					<%=getCategoryInfo(staffID,servCategory,"Staff") %>								
				</table>
				</td>
			</tr>	
			<tr>
			<td colspan="2">
			<hr/>
			</td>
			</tr>
			<tr style='width:100%;height:30px;'>
				<td style="vertical-align:top;">
					<button id='<%=servCategory%>_Staff Family' class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only record'
							style='width:160px;text-align:left; height:30px; font-size:15px;'>
						- Staff Family
					</button>
				</td>
				<td>
				<table width='100%'>
					<%=getCategoryInfo(staffID,servCategory,"Staff Family") %>
				</table>					
				</td>
			</tr>
			
<%
	}
%>
			<tr bgcolor="#FFD067" style='width:100%;height:30px;'>
				<td colspan="2" style='width:160px;'>
				Other
				</td>	
			
			</tr>						
			<tr style='width:100%;height:30px;'>
				<td style='width:160px; vertical-align:top;'>
					<button id='Other_Ceremony' class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only record'
							style='width:160px;text-align:left; height:30px; font-size:15px;'>
						- Ceremony
					</button>
				</td>
				<td>
				<table width="100%">
					<%=getCategoryInfo(staffID,"Other","Ceremony") %>
				</table>
				</td>
			</tr>	
			<tr>
			<td colspan="2">
			<hr/>
			</td>
			</tr>		
			<tr style='width:100%;height:30px;'>
				<td style="vertical-align:top;">
					<button id='Other_Devotions' class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only record'
							style='width:160px;text-align:left; height:30px; font-size:15px;'>
						- Devotions
					</button>
				</td>
				<td>
				<table  width="100%">
					<%=getCategoryInfo(staffID,"Other" ,"Devotions") %>
				</table>					
				</td>
			</tr>
			<tr>
			<td colspan="2">
			<hr/>
			</td>
			</tr>
			<tr style='width:100%;height:30px;'>
				<td style="vertical-align:top;">
					<button id='Other_Referral' class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only record'
							style='width:160px;text-align:left; height:30px; font-size:15px;'>
						- Referral
					</button>
				</td>
				<td>
				<table  width="100%">
					<%=getCategoryInfo(staffID,"Other","Referral") %>
				</table>					
				</td>
			</tr>	
									
			<tr bgcolor="#FFD067" style='width:100%;height:30px;'>
				<td colspan="2" style='width:160px;'>
				Chronological History
				</td>				
			</tr>						
			<tr style='width:100%;height:30px;'>
				<td style='width:160px; vertical-align:top;'>
					<button id='Chronological_History_Show' class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only record'
							style='width:160px;text-align:left; height:30px; font-size:15px;'>
						- Show
					</button>
					<button id='Chronological_History_Hide' class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only record'
							style='display:none;width:160px;text-align:left; height:30px; font-size:15px;'>
						- Hide
					</button>
				</td>
				<td>
				<div id='chronologicalRow'style="display:none;">
				<table width="100%">
					<%=getCategoryInfo(staffID,"Chronological History","Show") %>
				</table>
				</div>
				</td>
			</tr>	
			<tr>		
		</tbody>
<%
}	
else if(setRecord)
{
	String button_id = request.getParameter("buttonID");
	String[] category = button_id.split("_");
	String servCategory = category[0];
	String servItem = category[1];
			
	Calendar cal = Calendar.getInstance();
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);	
	SimpleDateFormat stf = new SimpleDateFormat("HH:mm", Locale.ENGLISH);	
	String date = sdf.format(cal.getTime()).toString() + " " + stf.format(cal.getTime()).toString();

%>
		<tbody>		
			<tr>
			<td>
			<span style='font-size:16px;'>Date: </span>
				<jsp:include page="../ui/dateCMB.jsp" flush="false"> 
					<jsp:param name="label" value="recordDate" />								
					<jsp:param name="yearRange" value="10" />									
					<jsp:param name="date" value="<%=date %>" />
					<jsp:param name="showTime" value="Y" />
					<jsp:param name="defaultValue" value="N" />
					<jsp:param name="isDetailedTime" value="Y"/>
				</jsp:include>	
			</td>
			</tr>
			<tr>
				<td>
					<span style='font-size:16px;'>User ID: <%=userBean.getUserName() %></span>
				</td>				
			</tr>	
						
			<tr>
				
				<td id='servCategory' style='display:none;'>				
					<%=servCategory.trim() %>
				</td>
				<td id='servItem' style='display:none;'>				
					<%=servItem.trim() %>
				</td>
				
				<td>
				<span style='font-size:16px;'>Category: <%=servCategory %> - <%=servItem %></span>
				</td>	
										
			</tr>			
			<tr>
			<td style="vertical-align:top;">					
				<textarea id="recordEntry"style='resize:none;height:230px;width:440px;'></textarea>
				</td>
			</tr>
			<tr>
				<td style="vertical-align:bottom;">
					<button class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
							style='width:100px; height:30px; font-size:15px;float:right'
							onclick="saveRecord('save')">
							Save
					</button>
				</td>
			</tr>
		</tbody>
<%
}else if(editRecord){			
	String ssID = request.getParameter("ssID");	
	System.out.println(ssID);
	ArrayList record = PatientDB.getPatientServiceByID(ssID) ;
	if(record.size() != 0){			
		ReportableListObject row = (ReportableListObject)record.get(0);	
		String arrayDate[] = row.getValue(15).split(" ");
	
		String date = arrayDate[0] + " " + arrayDate[1];
		
%>
	<tbody>		
		<tr>			
				<span style='display:none;font-size:16px;'>Last Modified Date: <%=row.getValue(18)%></span>
			
			<td><span style='font-size:16px;'>Date: </span>
				<jsp:include page="../ui/dateCMB.jsp" flush="false"> 
					<jsp:param name="label" value="editDate" />		
					<jsp:param name="yearRange" value="10" />									
					<jsp:param name="date" value="<%=date %>" />
					<jsp:param name="defaultValue" value="N" />
					<jsp:param name="showTime" value="Y" />
					<jsp:param name="isDetailedTime" value="Y"/>
				</jsp:include>
		</td>	
		</tr>

		<tr>
			<td>
					<span style='font-size:16px;'>Last Modified User: <%=row.getValue(20) %></span>
			</td>				
		</tr>							
		<tr>				
			<td id='servCategory' style='display:none;'>				
				<%=row.getValue(11)%>
			</td>
			<td id='servItem' style='display:none;'>				
				<%=row.getValue(12)%>
			</td>				
			<td>
			<span style='font-size:16px;'>Category: <%=row.getValue(11)%> - <%=row.getValue(12)%></span>
			</td>									
		</tr>			
		<tr>
			<td style="vertical-align:top;">					
			 
				<textarea id="recordEntry"style='resize:none;height:230px;width:440px;'><%=row.getValue(14)%></textarea>
			</td>
		</tr>
		<tr>
			<td style="vertical-align:bottom;">
				<button class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
				style='width:100px; height:30px; font-size:15px;float:right' onclick="saveRecord('edit','<%=ssID%>')">
				Save
				</button>
			</td>
		</tr>
	</tbody>
<%			
	}
%>
		
<%
}
}else if(action.equals("insert")) {	
	String staffID = request.getParameter("staffID");
	String staffName = request.getParameter("staffName");
	
	String status= request.getParameter("status");
	
	String remark= TextUtil.parseStrUTF8(
					java.net.URLDecoder.decode(
							request.getParameter("remark").replaceAll("%", "%25")));

	String servCategory = request.getParameter("servCategory");
	String servItem = request.getParameter("servItem");		
	
	String recordDate = request.getParameter("recordDate");	
	String recordTime = request.getParameter("recordTime");	
	
	/*
	System.out.println(staffID);
	System.out.println(staffName);	
	System.out.println(status);
	System.out.println(remark);
	System.out.println(servCategory);
	System.out.println(servItem);
	System.out.println(recordDate);
	System.out.println(recordTime);
	*/
	
	boolean insertSuccess = ChapStaffDB.addChaplaincyService(userBean,staffID,staffName,status,remark,servCategory.trim(),servItem.trim(),recordDate,recordTime);
	
%>			
	<%=insertSuccess %>
<%	
	

}else if(action.equals("edit")){
	String ssID = request.getParameter("ssID");
	String remark= TextUtil.parseStrUTF8(
			java.net.URLDecoder.decode(
					request.getParameter("remark").replaceAll("%", "%25")));	
	String editDate = request.getParameter("editDate");	
	String editTime = request.getParameter("editTime");	
	String staffID = request.getParameter("staffID");	
	
	String date = editDate + " " + editTime;
%>
	<%=PatientDB.updateChaplaincyServiceList(ssID,remark,userBean,date) %>
<%
}else if(action.equals("delete")) {	
	String ssID = request.getParameter("ssID");	
%>
	<%=PatientDB.deletePatientService(userBean, ssID, null, null, null, null) %>
<%

}else if(action.equals("insertInvolvement")) {
	String staffID = request.getParameter("staffID");
	String type = request.getParameter("type");
	String subType = request.getParameter("subType");
	String checked = request.getParameter("isChecked");
	boolean isChecked = false;
	if("true".equals(checked)){
		isChecked = true;
	}else if("false".equals(checked)){
		isChecked = false;
	}
		
	ArrayList record = ChapStaffDB.checkStaffInvolvement(staffID,type,subType);
		if(record.size() == 0){	
	%>
			<%=ChapStaffDB.addStaffInvolvement(userBean,staffID,type,subType)%>
	<%	
		}else{
	%>
			<%=ChapStaffDB.editStaffInvolvement(userBean,staffID,type,subType,isChecked)%>
	<%
		}
}else if(action.equals("insertTeam20Date")) {
	String staffID = request.getParameter("staffID");
	String type = request.getParameter("type");
	String subType = request.getParameter("subType");
	String team20Day = request.getParameter("team20Day");
	String team20Month = request.getParameter("team20Month");
	String team20Year = request.getParameter("team20Year");
	String team20Date = null;
	if(team20Day!=null&&team20Day.length()>0&&team20Month!=null&&team20Month.length()>0&&team20Year!=null&&team20Year.length()>0){
		team20Date = team20Day + "/" + team20Month + "/" + team20Year;
	}

	
		ArrayList record = ChapStaffDB.checkStaffInvolvement(staffID,type,subType);
		if(record.size() == 0){
			if(team20Date!=null){
	%>
				<%=ChapStaffDB.addStaffTeam20Date(userBean,staffID,type,subType,team20Date)%>
	<%	
			}
		}else{
			if(team20Date!=null){
	%>
				<%=ChapStaffDB.editStaffTeam20Date(userBean,staffID,type,subType,team20Date)%>
	<%	
			}else{
	%>			
				<%=ChapStaffDB.editStaffInvolvement(userBean,staffID,type,subType,false)%>
	<%		
			}
		}
	

}else if(action.equals("removeTeam20Date")){
	String staffID = request.getParameter("staffID");
	String type = request.getParameter("type");
	String subType = request.getParameter("subType");
	%>
		<%=ChapStaffDB.editStaffInvolvement(userBean,staffID,type,subType,false)%>
	<%
}
%>
<%!
public void removeDateTime(Calendar date){
	date.set(Calendar.HOUR_OF_DAY, 0);
	date.set(Calendar.MINUTE, 0);
	date.set(Calendar.SECOND, 0);
	date.set(Calendar.MILLISECOND, 0);
}

public String getCategoryInfo(String staffID, String servCategory,String servItem)
{
	StringBuffer sqlStr = new StringBuffer();
	ArrayList record;
	if(servCategory.equals("Chronological History")){
		record = PatientDB.getChaplaincyServiceList(staffID,null,null,null);
	}
	else{		
		record = PatientDB. getChaplaincyServiceList(staffID,servCategory,servItem,null);
		
	}		
	
		if(record.size() != 0){			
			for(int i =0;i< record.size();i++){
			ReportableListObject row = (ReportableListObject)record.get(i);

				sqlStr.append("<tr >");
				sqlStr.append("<td  width='60px' style='text-align:right;'>");
				sqlStr.append("Date: ");
				sqlStr.append("</td>");
				sqlStr.append("<td width='150px'>");
				sqlStr.append(row.getValue(15));
				sqlStr.append("</td>");
				sqlStr.append("<td style='text-align:right;' width='120px'>");
				sqlStr.append("Modified User: ");
				sqlStr.append("</td>");		
				sqlStr.append("<td >");
				sqlStr.append(row.getValue(21));
				sqlStr.append("</td>");	
				sqlStr.append("<td  title='Edit remark' width='18px'>");	
				sqlStr.append("<img width='24px' src='../images/edit1.png' onclick='editRemark(");
				sqlStr.append(row.getValue(1));
				sqlStr.append(")'/>");
				sqlStr.append("   ");
				sqlStr.append("</td>");	
				sqlStr.append("<td title='Delete remark' width='16px'>");	
				sqlStr.append("<img  width='24px' src='../images/delete5.png' onclick='deleteRemark(");
				sqlStr.append(row.getValue(1));
				sqlStr.append(")'/>");
				sqlStr.append("</td>");	
				sqlStr.append("</tr>");
				sqlStr.append("<tr>");
				sqlStr.append("<td style='text-align:right;' valign='top'>");
				sqlStr.append("Remark:");
				sqlStr.append("</td>");			
				sqlStr.append("<td colspan='3'>");
				sqlStr.append(row.getValue(14));					
				sqlStr.append("</td>");
				sqlStr.append("</tr>");

				if(record.size() -1 != i){

				sqlStr.append("<tr>");
				sqlStr.append("<td colspan='10'>");	
				sqlStr.append("<hr/>");
				sqlStr.append("</td>");	
				sqlStr.append("</tr>");

			
		}
	}
		
	}			
	return sqlStr.toString();
}
%>

