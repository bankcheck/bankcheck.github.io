<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.config.MessageResources"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.constant.*"%>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>

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


String patNo = request.getParameter("patNo");	
String type = request.getParameter("type");

if(type != null && type.equals("admissionHistory")){
ArrayList record = PatientDB.getPatientAdmissionHistory(patNo,"20");
request.setAttribute("admissionList", record);

	
%>


	
<display:table id="row" name="requestScope.admissionList" style="width:100%" export="false" pagesize="200" sort="list">
<display:column title="Type"   style="width:40%">
 <c:choose>
      <c:when test="${row.fields0=='O'}">
     <c:out value="Out-Patient" />
      </c:when>
      <c:when test="${row.fields0=='I'}">
      <c:out value="In-Patient" />
      </c:when>
      <c:otherwise>
      <c:out value="${row.fields0}" />
      </c:otherwise>
</c:choose>
</display:column >
<display:column style="width:60%" title="Admission Date">
<c:out value="${row.fields2}" />
</display:column>
</display:table>
<%
}else if(type != null && type.equals("diagnosis")){

ArrayList diagnosisRecord =  PatientDB.checkPatientDiagnosisExists(patNo);
ReportableListObject diagnosisRow = null;
if(diagnosisRecord.size() != 0){	
	diagnosisRow = (ReportableListObject)diagnosisRecord.get(0);	
}
%>
<table>
		<tr>
			<td style="vertical-align:top;">					
			 
				<textarea id="diagnosisEntry"style='resize:none;height:230px;width:440px;'><%=(diagnosisRow!=null)?diagnosisRow.getValue(1):"" %></textarea>
			</td>
		</tr>
		<tr>
			<td style="vertical-align:bottom;">
				<button class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
				style='width:100px; height:30px; font-size:15px;float:right' onclick="saveDiagnosis('<%=patNo%>')">
				Save
				</button>
			</td>
		</tr>
		</table>
<%
}else if(type != null && ( type.equals("saveDiagnosis") || type.equals("removeDiagnosis"))){
	String remark= TextUtil.parseStrUTF8(
			java.net.URLDecoder.decode(
					request.getParameter("remark").replaceAll("%", "%25")));

	ArrayList record =  PatientDB.checkPatientDiagnosisExists(patNo.trim());
	
	if(record.size() == 0){		
%>
		<%=PatientDB.addPatientDiagnosis(userBean, patNo,remark,"diagnosis")%>
<%
	}else{
%>
		<%=PatientDB.editPatientDiagnosis(userBean, patNo,remark)%>
<%
	}
}else if(type != null && type.equals("refNotes")){
	String chaplain = request.getParameter("chaplain");
%>
<table>
		<tr>
			<td>
				Refer Patient #<%=patNo%> to <%=chaplain %> ?
			</td>
		</tr>
		<tr>
			<td>
				Notes:
			</td>
		</tr>
		<tr>
			<td style="vertical-align:top;">	
				<textarea id="refNotesEntry"style='resize:none;height:190px;width:440px;'></textarea>
			</td>
		</tr>
		<tr>
			<td style="vertical-align:bottom;">
				<button class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
				style='width:100px; height:30px; font-size:15px;float:right' onclick="closePage('refNotesPage')">
				Cancel
				</button>
				<button class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
				style='width:100px; height:30px; font-size:15px;float:right' onclick="submitReferral('<%=patNo%>','sendRef')">
				Refer
				</button>			
			</td>
		</tr>
		</table>
<%	
}else if(type != null && type.equals("otRecord")){
	ArrayList record = PatientDB.getPatientOTRecord(patNo,"20");
	request.setAttribute("otRecordList", record);
	%>
	<display:table id="row" name="requestScope.otRecordList" style="width:100%" export="false" pagesize="200" sort="list">
	<c:set var="otRecordStartDate" value="${row.fields0}"/>	
		<c:set var="otRecordEndDate" value="${row.fields1}"/>	
<%						
	String duration = "";
	if(record.size()>0){
		String otRecordStartDate = (String)pageContext.getAttribute("otRecordStartDate") ;
		String otRecordEndDate = (String)pageContext.getAttribute("otRecordEndDate") ;

		Calendar otRecordSDate = Calendar.getInstance();
		String[] otRecordSArray = otRecordStartDate.split(" ");
		String[] otRecordSDateArray = otRecordSArray[0].split("/");
		String[] otRecordSTimeArray = otRecordSArray[1].split(":");
		int otRecordSDay = Integer.parseInt(otRecordSDateArray[0]);
		int otRecordSMonth = Integer.parseInt(otRecordSDateArray[1]) -1;
		int otRecordSYear = Integer.parseInt(otRecordSDateArray[2]);
		int otRecordSHour = Integer.parseInt(otRecordSTimeArray[0]);
		int otRecordSMinute = Integer.parseInt(otRecordSTimeArray[1]);
		
		otRecordSDate.set(otRecordSYear,otRecordSMonth,otRecordSDay,otRecordSHour,otRecordSMinute,0);
		
		Calendar otRecordEDate = Calendar.getInstance();
		String[] otRecordEArray = otRecordEndDate.split(" ");
		String[] otRecordEDateArray = otRecordEArray[0].split("/");
		String[] otRecordETimeArray = otRecordEArray[1].split(":");
		int otRecordEDay = Integer.parseInt(otRecordEDateArray[0]);
		int otRecordEMonth = Integer.parseInt(otRecordEDateArray[1]) -1;
		int otRecordEYear = Integer.parseInt(otRecordEDateArray[2]);
		int otRecordEHour = Integer.parseInt(otRecordETimeArray[0]);
		int otRecordEMinute = Integer.parseInt(otRecordETimeArray[1]);
		
		otRecordEDate.set(otRecordEYear,otRecordEMonth,otRecordEDay,otRecordEHour,otRecordEMinute,0);
				
		 SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		 
		 long otRecordSMillisec = otRecordSDate.getTimeInMillis();
		 long otRecordEMillisec = otRecordEDate.getTimeInMillis();
		 long durationMillisec = otRecordEMillisec - otRecordSMillisec;
		 long durationHours = durationMillisec / (1000*60*60);
		long durationMinutes = (durationMillisec % (1000*60*60)) / (1000*60);
		
		 if(durationHours > 0){
			 duration = Long.toString(durationHours) + " Hour," + Long.toString(durationMinutes) + " Min";
		 }else{
			 duration = Long.toString(durationMinutes) + " Min";
		 }
			duration = " ("+duration+")";
	}
%>
	<display:column title="Start Date"   style="width:35%">		
		 <c:out value="${row.fields0}" />		 
	</display:column >
	<display:column style="width:35%" title="End Date">
		<c:out value="${row.fields1}" />
	</display:column>
	<display:column style="width:30%" title="Duration">
		<c:out value='<%=duration%>' />	
	</display:column>
	</display:table>
<%	
}
%>