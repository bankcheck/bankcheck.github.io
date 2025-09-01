<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.config.MessageResources"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.constant.*"%>

<%!
public class ClientValue{
	String clientID;
	String clientLastName;
	String clientFirstName;
	String clientSex;
	String pwpAttendDate;
	String scrAttendDate;
	String onlineCourseAttendDate;
	String nutritionWSAttendDate;
	String exerciseWSAttendDate;
	String trustWSAttendDate;
	String dayCampAttendDate;
	
	public ClientValue(String clientID, String clientLastName, String clientFirstName, String clientSex,
			String pwpAttendDate, String scrAttendDate, String onlineCourseAttendDate, String nutritionWSAttendDate,
			String exerciseWSAttendDate, String trustWSAttendDate, String dayCampAttendDate){
		this.clientID = clientID;
		this.clientLastName = clientLastName;
		this.clientFirstName = clientFirstName;
		this.clientSex = clientSex;
		this.pwpAttendDate = pwpAttendDate;
		this.scrAttendDate = scrAttendDate;
		this.onlineCourseAttendDate = onlineCourseAttendDate;
		this.nutritionWSAttendDate = nutritionWSAttendDate;
		this.exerciseWSAttendDate = exerciseWSAttendDate;
		this.trustWSAttendDate = trustWSAttendDate;
		this.dayCampAttendDate = dayCampAttendDate;
	}
}

public class EventValue{
	String eventModule;
	String clientID;
	String attendDate;
	
	public EventValue(String eventModule, String clientID, String attendDate){
		this.eventModule = eventModule;
		this.clientID = clientID;
		this.attendDate = attendDate;
	}
}


private ArrayList getClients() {	
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT    CRM_CLIENT_ID, CRM_LASTNAME, CRM_FIRSTNAME, CRM_SEX ");
	sqlStr.append("FROM      CRM_CLIENTS ");
	sqlStr.append("WHERE     CRM_ENABLED = 1 ");	
	sqlStr.append("AND       CRM_ISTEAM20 = 1 ");	
	sqlStr.append("ORDER BY  CRM_LASTNAME, CRM_FIRSTNAME");
	//System.out.println(sqlStr.toString());

	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private ArrayList getClientsEventEnrollment(String module) {	
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("select   CO_MODULE_CODE, CO_USER_ID, TO_CHAR(CO_MODIFIED_DATE  , 'DD/MM/YYYY') ");
	sqlStr.append("from     CO_ENROLLMENT ");
	sqlStr.append("where    CO_MODULE_CODE = '"+module+"' ");
	sqlStr.append("AND      CO_ENABLED = 1 ");
	sqlStr.append("ORDER BY CO_USER_ID");
	
	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private ArrayList getClientsOnlineCourse() {	
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("select  distinct E.EE_USER_ID,  TO_CHAR(max(E.EE_MODIFIED_DATE), 'DD/MM/YYYY') ");
	sqlStr.append("from    EE_ELEARNING_STAFF E ");
	sqlStr.append("where   E.EE_MODULE_CODE = 'lmc.crm' ");
	sqlStr.append("and     E.EE_ENABLED = 1 ");
	sqlStr.append("and     E.EE_CORRECT_ANS = ( ");
	sqlStr.append("select EE_PASSGRADE from EE_ELEARNING ");
	sqlStr.append("where EE_ENABLED= 1 ");
	sqlStr.append("and   EE_ELEARNING_ID = E.EE_ELEARNING_ID) ");
	sqlStr.append("group by E.EE_USER_ID ");
	sqlStr.append("ORDER BY E.EE_USER_ID ");   

	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private ArrayList getClientsWorkshopEnrollment(String type){
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("select DISTINCT EN.CO_USER_ID , TO_CHAR(max( EN.CO_ATTEND_DATE), 'DD/MM/YYYY') ");
	sqlStr.append("from CO_EVENT E , CO_ENROLLMENT EN ");
	sqlStr.append("where E.CO_EVENT_REMARK2 = '"+type+"' ");
	sqlStr.append("and   E.CO_ENABLED = 1 ");
	sqlStr.append("and   EN.CO_ENABLED = 1 ");
	sqlStr.append("and   E.CO_MODULE_CODE = 'lmc.crm' ");
	sqlStr.append("and   E.CO_EVENT_ID = EN.CO_EVENT_ID ");
	sqlStr.append("and   E.CO_MODULE_CODE = EN.CO_MODULE_CODE ");
	sqlStr.append("group by EN.CO_USER_ID ");  
	
	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private String getAttendDate(ArrayList<EventValue> list, String clientID){
	String attendDate = "";
	for(EventValue ev : list){			
		if(ev.clientID.equals(clientID)){
			attendDate = ev.attendDate;
			break;
		}
	}
	return attendDate;
}
%>
<%
UserBean userBean = new UserBean(request);

String message = "";
String errorMessage = "";

ArrayList<EventValue> pwpAttendList = new ArrayList<EventValue>();
ArrayList pwpAttentRecord = getClientsEventEnrollment("lmc.pwp");
if (pwpAttentRecord.size() > 0) {
	for (int i = 0; i < pwpAttentRecord.size(); i++) {
		ReportableListObject pwpAttendRow = (ReportableListObject) pwpAttentRecord.get(i);
		String eventModule = pwpAttendRow.getValue(0);
		String clientID = pwpAttendRow.getValue(1);
		String attendDate = pwpAttendRow.getValue(2);
				
		pwpAttendList.add(new EventValue(eventModule, clientID, attendDate));		
	}
}

ArrayList<EventValue> scrAttendList = new ArrayList<EventValue>();
ArrayList scrAttentRecord = getClientsEventEnrollment("lmc.scr");
if (scrAttentRecord.size() > 0) {
	for (int i = 0; i < scrAttentRecord.size(); i++) {
		ReportableListObject scrAttendRow = (ReportableListObject) scrAttentRecord.get(i);
		String eventModule = scrAttendRow.getValue(0);
		String clientID = scrAttendRow.getValue(1);
		String attendDate = scrAttendRow.getValue(2);
				
		scrAttendList.add(new EventValue(eventModule, clientID, attendDate));		
	}
}

ArrayList<EventValue> onlineCourseList = new ArrayList<EventValue>();
ArrayList onlineCourseRecord = getClientsOnlineCourse();
if (onlineCourseRecord.size() > 0) {
	for (int i = 0; i < onlineCourseRecord.size(); i++) {
		ReportableListObject onlineCourseRow = (ReportableListObject) onlineCourseRecord.get(i);		
		String clientID = onlineCourseRow.getValue(0);
		String attendDate = onlineCourseRow.getValue(1);
				
		onlineCourseList.add(new EventValue("online_course", clientID, attendDate));		
	}
}

ArrayList<EventValue> nutritionWSList = new ArrayList<EventValue>();
ArrayList nutritionWSRecord = getClientsWorkshopEnrollment("Nutrition Workshop");
if (nutritionWSRecord.size() > 0) {
	for (int i = 0; i < nutritionWSRecord.size(); i++) {
		ReportableListObject nutritionWSRow = (ReportableListObject) nutritionWSRecord.get(i);		
		String clientID = nutritionWSRow.getValue(0);
		String attendDate = nutritionWSRow.getValue(1);
				
		nutritionWSList.add(new EventValue("nutrition_ws", clientID, attendDate));		
	}
}

ArrayList<EventValue> exerciseWSList = new ArrayList<EventValue>();
ArrayList exerciseWSRecord = getClientsWorkshopEnrollment("Exercise Workshop");
if (exerciseWSRecord.size() > 0) {
	for (int i = 0; i < exerciseWSRecord.size(); i++) {
		ReportableListObject exerciseWSRow = (ReportableListObject) exerciseWSRecord.get(i);		
		String clientID = exerciseWSRow.getValue(0);
		String attendDate = exerciseWSRow.getValue(1);
				
		exerciseWSList.add(new EventValue("exercise_ws", clientID, attendDate));		
	}
}

ArrayList<EventValue> trustWSList = new ArrayList<EventValue>();
ArrayList trustWSRecord = getClientsWorkshopEnrollment("Trust Workshop");
if (trustWSRecord.size() > 0) {
	for (int i = 0; i < trustWSRecord.size(); i++) {
		ReportableListObject trustWSRow = (ReportableListObject) trustWSRecord.get(i);		
		String clientID = trustWSRow.getValue(0);
		String attendDate = trustWSRow.getValue(1);
				
		trustWSList.add(new EventValue("trust_ws", clientID, attendDate));		
	}
}

ArrayList<EventValue> dayCampList = new ArrayList<EventValue>();
ArrayList dayCampRecord = getClientsWorkshopEnrollment("Day Camp");
if (dayCampRecord.size() > 0) {
	for (int i = 0; i < dayCampRecord.size(); i++) {
		ReportableListObject dayCampRow = (ReportableListObject) dayCampRecord.get(i);		
		String clientID = dayCampRow.getValue(0);
		String attendDate = dayCampRow.getValue(1);
				
		dayCampList.add(new EventValue("day_camp", clientID, attendDate));		
	}
}

ArrayList<ClientValue> clientList = new ArrayList<ClientValue>();

ArrayList clientsRecord = getClients();
if (clientsRecord.size() > 0) {
	for (int i = 0; i < clientsRecord.size(); i++) {
		ReportableListObject clientRow = (ReportableListObject) clientsRecord.get(i);
		String clientID = clientRow.getValue(0);
		String clientLastName = clientRow.getValue(1);
		String clientFirstName = clientRow.getValue(2);
		String clientSex = clientRow.getValue(3);
		
		String pwpAttendDate = "";
		String scrAttendDate = "";
		String onlineCourseAttendDate = "";
		String nutritionWSAttendDate = "";
		String exerciseWSAttendDate = "";
		String trustWSAttendDate = "";
		String dayCampAttendDate = "";
		
		
		pwpAttendDate = getAttendDate(pwpAttendList,clientID);			
		scrAttendDate = getAttendDate(scrAttendList,clientID);		
		onlineCourseAttendDate = getAttendDate(onlineCourseList,clientID);						
		nutritionWSAttendDate = getAttendDate(nutritionWSList,clientID);
		exerciseWSAttendDate = getAttendDate( exerciseWSList,clientID);
		trustWSAttendDate = getAttendDate( trustWSList,clientID);
		dayCampAttendDate = getAttendDate(dayCampList,clientID);
						
		clientList.add(new ClientValue(clientID, clientLastName, clientFirstName, clientSex, pwpAttendDate, scrAttendDate, 
				onlineCourseAttendDate, nutritionWSAttendDate, exerciseWSAttendDate, trustWSAttendDate, dayCampAttendDate));
	}
}


try {

} catch (Exception e) {
	e.printStackTrace();
}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
    Licensed to the Apache Software Foundation (ASF) under one or more
    contributor license agreements.  See the NOTICE file distributed with
    this work for additional information regarding copyright ownership.
    The ASF licenses this file to You under the Apache License, Version 2.0
    (the "License"); you may not use this file except in compliance with
    the License.  You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="header.jsp"/>
<style>
.rowEven{
			background-color: #F5F1EE!important;		
}
.rowOdd{
			background-color: white!important;		
}
</style>
<body>
<DIV id=contentFrame style="width:100%;height:100%">
<jsp:include page="../../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Event Summary" />
	<jsp:param name="category" value="group.crm" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="form1" action="event_summary.jsp" method="post">
<table style="border-collapse:collapse;background-color:white;" border="1" cellpadding="0" cellspacing="0">
	<tr style="background-color:#F7ECEC;text-align:center" valign="bottom">
		<td colspan="4">HT20 - Natural Fit</td>
		<td colspan="3">Week 1 - Week 4</td>
		<td colspan="4">Week 5 - Week 12</td>
	</tr>
	<tr style="background-color:#F7ECEC;text-align:center;" valign="bottom">
		<td>&nbsp;</td>
		<td style="font-weight:bold;" colspan="2">Name</td>
		<td style="font-weight:bold;">Sex</td>
		<td style="font-weight:bold;">PWP</td>
		<td style="font-weight:bold;">Screening</td>
		<td style="font-weight:bold;">Online Course</td>
		<td style="font-weight:bold;">N Workshop</td>
		<td style="font-weight:bold;">E Workshop</td>
		<td style="font-weight:bold;">T Workshop</td>
		<td style="font-weight:bold;">Day Camp</td>
	</tr>
	
<%
int i = 0;
for(ClientValue cv : clientList){
%>
	<tr  <%=(i%2==0?"class=\"rowOdd\"":"class=\"rowEven\"") %>>
		<td><%=++i %></td>
		<td><%=cv.clientLastName %></td>
		<td><%=cv.clientFirstName %></td>
		<td><%=cv.clientSex %></td>
		<td><%=cv.pwpAttendDate %></td>
		<td><%=cv.scrAttendDate %></td>
		<td><%=cv.onlineCourseAttendDate %></td>
		<td><%=cv.nutritionWSAttendDate %></td>
		<td><%=cv.exerciseWSAttendDate %></td>
		<td><%=cv.trustWSAttendDate %></td>
		<td><%=cv.dayCampAttendDate %></td>
	</tr>
<%
}
%>

</table>
</form>
<script language="javascript">
<!--
-->
</script>
</div>
<jsp:include page="../../common/footer.jsp" flush="false" />
</body>
</html:html> 
