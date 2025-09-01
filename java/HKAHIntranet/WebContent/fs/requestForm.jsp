<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.wsclient.lombardiWS.*"%>
<%@ page import="oracle.jdbc.*"%>
<%@ page import="oracle.sql.ArrayDescriptor"%>
<%@ page import="oracle.sql.ARRAY"%>
<%@ page import="oracle.sql.StructDescriptor"%>
<%@ page import="oracle.sql.STRUCT"%>
<%@ page import="oracle.jdbc.OracleTypes"%>
<%@ page import="java.sql.*"%>
<%
boolean fileUpload = false;
if (HttpFileUpload.isMultipartContent(request)){
	HttpFileUpload.toUploadFolder(
		request,
		ConstantsServerSide.DOCUMENT_FOLDER,
		ConstantsServerSide.TEMP_FOLDER,
		ConstantsServerSide.UPLOAD_FOLDER,
		"UTF-8"
	);
	
	fileUpload = true;
}

UserBean userBean = new UserBean(request);
String command = ParserUtil.getParameter(request, "command");
String reqNo = ParserUtil.getParameter(request, "reqNo");
String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");
String deptCode = userBean.getDeptCode();
String eventID = ParserUtil.getParameter(request, "eventID");
if (eventID == null) {
	eventID = "1301";
}
String venue = TextUtil.parseStrUTF8((String) ParserUtil.getParameter(request, "venue"));
String mealID = ParserUtil.getParameter(request, "mealID");

String reqByName = StaffDB.getStaffFullName2(userBean.getLoginID());
String reqSiteCode = ConstantsServerSide.SITE_CODE;
String reqDept = ParserUtil.getParameter(request, "reqDept");
String chargeTo = ParserUtil.getParameter(request, "chargeTo");
String reqBy = userBean.getLoginID();
String reqDate = ParserUtil.getParameter(request, "reqDate");

String servDate = ParserUtil.getParameter(request, "servDate");
String servDateStartTime = null;
String servDateEndTime = null;
String servDateStartDateTime = null; 

String servDateStartTime_hh = ParserUtil.getParameter(request, "servDateStartTime_hh");
String servDateStartTime_mi = ParserUtil.getParameter(request, "servDateStartTime_mi");
String servDateEndDateTime = null;
String servDateEndTime_hh = ParserUtil.getParameter(request, "servDateEndTime_hh");
String servDateEndTime_mi = ParserUtil.getParameter(request, "servDateEndTime_mi");

servDateStartTime = servDateStartTime_hh + ":" + servDateStartTime_mi + ":00";
servDateStartDateTime = servDate + " " + servDateStartTime;
servDateEndTime = servDateEndTime_hh + ":" + servDateEndTime_mi + ":00";
servDateEndDateTime = servDate + " " + 	servDateEndTime;
String noOfPerson = ParserUtil.getParameter(request, "noOfPerson");
String purpose = ParserUtil.getParameter(request, "purpose");
if(purpose!=null){
	purpose = purpose.replaceAll("'","''");
	purpose=purpose.trim();
}
String specReq = TextUtil.parseStrUTF8((String) ParserUtil.getParameter(request, "specReq"));
if(specReq!=null){
	specReq = specReq.replaceAll("'","''");
	specReq=specReq.trim();
}
String sendAppTo = ParserUtil.getParameter(request, "sendAppTo");
String reqStatus = ParserUtil.getParameter(request, "reqStatus");
String deptHead = null;

Calendar cal = Calendar.getInstance();
SimpleDateFormat dateFmt = new SimpleDateFormat("ddMMyyyyHHmmss");
String sysDate = dateFmt.format(cal.getTime());

ArrayList record1 = null;

boolean createAction = false;
boolean updateAction = false;
boolean viewAction = false;
boolean closeAction = false;
boolean successUpt = false;
boolean webServiceSuccess = false;

if("view".equals(command)){
	viewAction = true;
}else if ("edit".equals(command)) {
	updateAction = true;
}else if ("submit".equals(command)) {
	if(reqNo != null && reqNo.length() > 0){
		updateAction = true;			
	}else{
		createAction = true;
	}
}

try {
	ArrayList record = null;	
	record = ApprovalUserDB.getDepartmentHead1(userBean.getLoginID());
	if(!record.isEmpty()){
		ReportableListObject row = (ReportableListObject) record.get(0);
		deptHead = row.getValue(0);
		if(!deptHead.equals(userBean.getStaffID())){
			deptHead = null;
		}					
	}
	
	if(createAction){
	    reqNo = FsDB.addReqOrder(userBean, reqDate, servDateStartDateTime, servDateEndDateTime, reqSiteCode, reqDept, chargeTo, eventID, venue, purpose, noOfPerson, mealID, specReq, sendAppTo, "S");
	    if (reqNo!=null||reqNo.length()> 0){
	    	webServiceSuccess = CallWebservice.doKickStart(reqNo);
	    	if(webServiceSuccess){
				if(FsDB.sendEmail(reqNo, userBean.getStaffID(), userBean.getLoginID(), sendAppTo, null, reqStatus, null, "1", "1")){
					message = "New Requisition insert success";
					createAction = false;
					record1 = FsDB.getReqRecord(reqNo);
					ReportableListObject row1 = (ReportableListObject) record1.get(0);
						
					reqNo  = row1.getValue(0);
					reqDate  = row1.getValue(28);
					servDate  = row1.getValue(2);
					servDateStartTime = row1.getValue(26);
					servDateEndTime = row1.getValue(27);
					reqSiteCode = row1.getValue(4);
					reqDept = row1.getValue(5);
					reqByName = StaffDB.getStaffFullName2(row1.getValue(1));
					eventID = row1.getValue(7);
					venue = row1.getValue(8);
					reqStatus = row1.getValue(9);
					purpose = row1.getValue(10);
					noOfPerson = row1.getValue(12);
					mealID = row1.getValue(13);
					chargeTo = row1.getValue(6);
					specReq = row1.getValue(15);
					sendAppTo = row1.getValue(16);
				}else{
					message = "New Requisition added but email sent failed";
					createAction = false;				
				}		    	    		    		
	    	}else{
	    		FsDB.deleteReqOrder(reqNo,"S");
				errorMessage = "Requisition insert fail.(WebService Connet Failed)";
				reqNo = null;
				createAction = false;	    		
	    	}
	    }else{
			errorMessage = "Requisition insert fail.";
			createAction = false;
	    }
	}else if(viewAction){		
		record1 = FsDB.getReqRecord(reqNo);
		ReportableListObject row1 = (ReportableListObject) record1.get(0);
	
		reqNo  = row1.getValue(0);
		reqDate  = row1.getValue(28);
		servDate  = row1.getValue(2);
		servDateStartTime = row1.getValue(26);
		servDateEndTime = row1.getValue(27);
		reqSiteCode = row1.getValue(4);
		reqDept = row1.getValue(5);
		reqByName = StaffDB.getStaffFullName2(row1.getValue(1));
		eventID = row1.getValue(7);
		venue = row1.getValue(8);
		reqStatus = row1.getValue(9);
		purpose = row1.getValue(10);
		noOfPerson = row1.getValue(12);
		mealID = row1.getValue(13);
		chargeTo = row1.getValue(6);
		specReq = row1.getValue(15);
		sendAppTo = row1.getValue(16);

	}else if(updateAction){
		successUpt = FsDB.updateMenu(reqNo, servDateStartDateTime, servDateEndDateTime, eventID, venue, purpose, noOfPerson, mealID, specReq, userBean);

	    if (successUpt){
			message = "Requisition update success";
			updateAction = false;		    	    	
	    }else{
			errorMessage = "Requisition update fail.";
			updateAction = false;
	    }
	}else{
		Calendar calendar = Calendar.getInstance();	
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
		reqDate = dateFormat.format(calendar.getTime());
	    calendar.set(Calendar.DAY_OF_YEAR,calendar.get(Calendar.DAY_OF_YEAR) + 3);
		servDate = dateFormat.format(calendar.getTime());

	}
} catch (Exception e) {
	e.printStackTrace();
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<head>
<title>Insert title here</title>
</head>
<jsp:include page="../common/header.jsp"/>
<!-- 
<script type="text/javascript" src="<html:rewrite page="/js/jquery-1.2.6.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.meio.mask.js"/>" charset="utf-8" ></script>
 -->
<body>
<body>
<jsp:include page="../common/banner2.jsp"/>
<div id=indexWrapper>
<div id=mainFrame>
<div id=Frame>
<%
	String title = "function.dfsr.list"; 
	String suffix = "_2";
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="suffix" value="<%=suffix %>" />	
	<jsp:param name="category" value="admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<bean:define id="functionLabel"><bean:message key="function.dfsr.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" id="form1" enctype="multipart/form-data" action="requestForm.jsp" method=post >
<table cellpadding="0" cellspacing="5" class="contentFrameMenu1" border="0">
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqNo" /></td>
		<td class="infoData2" width="30%" colspan=3>
			<b><%=reqNo==null?"":reqNo%></b>			
		</td>
	</tr>
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqDate" /></td>
		<td class="infoData2" width="80%" colspan=3>
		<%if("S".equals(reqStatus)||"K".equals(reqStatus)){ %>		
			<input type="textfield" name="reqDate" id="reqDate" class="datepickerfield" value="<%=reqDate==null?"":reqDate %>" maxlength="20" size="20" onkeyup="validDate(this)" onblur="validDate(this)"/> (DD/MM/YYYY)
		<%} else { %>
			<input type="textfield" name="reqDate" id="reqDate" value="<%=reqDate==null?"":reqDate %>" maxlength="20" size="20" readonly="readonly"/> (DD/MM/YYYY)		
		<%} %>			
		</td>			
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.servDate" /></td>
		<td class="infoData2" width="80%" colspan=3>
		<%if("S".equals(reqStatus)||"K".equals(reqStatus)){ %>			
			<input type="textfield" name="servDate" id="servDate" class="datepickerfield" value="<%=servDate==null?"":servDate %>" maxlength="20" size="20" onkeyup="validDate(this)" onblur="validDate(this)"/> (DD/MM/YYYY)
		<%} else{ %>
			<input type="textfield" name="servDate" id="servDate" value="<%=servDate==null?"":servDate %>" maxlength="20" size="20" readonly="readonly"/> (DD/MM/YYYY)		
		<%} %>			
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Start Time</td>
		<td class="infoData2" width="80%" colspan=3>
<jsp:include page="../ui/timeCMB.jsp" flush="false">
	<jsp:param name="label" value="servDateStartTime" />
	<jsp:param name="time" value="<%=servDateStartTime %>" />
	<jsp:param name="interval" value="15" />
</jsp:include>
		(HH:MM)</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">End Time</td>
		<td class="infoData2" width="80%" colspan=3>
<jsp:include page="../ui/timeCMB.jsp" flush="false">
	<jsp:param name="label" value="servDateEndTime" />
	<jsp:param name="time" value="<%=servDateEndTime %>" />
	<jsp:param name="interval" value="15" />
</jsp:include>
		(HH:MM)</td>
	</tr>
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.siteCode" /></td>
		<td class="infoData2" width="80%" colspan=3>
			<input type="textfield" name="reqSiteCode" id="reqSiteCode" value="<%=reqSiteCode==null?"":reqSiteCode %>" maxlength="20" size="20" readonly="readonly">			
		</td>
	</tr>	
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqDept" /></td>
		<td class="infoData2" width="30%">
		<%if("S".equals(reqStatus)||"K".equals(reqStatus)){ %>	
			<select name="reqDept">
			<%reqDept = reqDept == null ? deptCode : reqDept; %>	
			<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
				<jsp:param name="deptCode" value="<%=reqDept %>" />
				<jsp:param name="allowAll" value="Y" />				
			</jsp:include>
			</select>
		<%}else { %>
			<select name="reqDept" disabled>
			<%reqDept = reqDept == null ? deptCode : reqDept; %>	
			<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
				<jsp:param name="deptCode" value="<%=reqDept %>" />
				<jsp:param name="allowAll" value="Y" />				
			</jsp:include>
			</select>		
		<%} %>
		</td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqBy" /></td>
		<td class="infoData2" width="30%" >
			<input type="textfield" name="reqBy" id="reqBy" value="<%=reqByName==null?"":reqByName %>" maxlength="20" size="20" disabled="disabled">			
		</td>		
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Meeting Room</td>		
		<td class="infoData2" width="80%" colspan=3>
		<%if("S".equals(reqStatus)||"K".equals(reqStatus)){ %>				
			<select name="eventID" >
<jsp:include page="../ui/eventIDCMB.jsp" flush="false">
	<jsp:param name="moduleCode" value="foodOrder" />
	<jsp:param name="eventID" value="<%=eventID %>" />
</jsp:include>
			</select>
		<%}else { %>
			<select name="eventID" disabled>
<jsp:include page="../ui/eventIDCMB.jsp" flush="false">
	<jsp:param name="moduleCode" value="foodOrder" />
	<jsp:param name="eventID" value="<%=eventID %>" />
</jsp:include>
			</select>		
		<%} %>			
		</td>
	</tr>
	<%venue = venue.replaceAll("'", "&#39;");%>	
	<tr>
		<td class="infoLabel" width="20%"><bean:message key="prompt.venue" /></td>
		<td class="infoData2" width="80%" colspan=3>
<%if("S".equals(reqStatus)||"K".equals(reqStatus)){ %>		
		<input type="textfield" name="venue" value="<%=venue==null?"":venue %>" maxlength="150" size="120"/>
<%}else {%>		
		<input type="textfield" name="venue" value="<%=venue==null?"":venue %>" maxlength="150" size="120" readonly="readonly"/>
<%} %>			
		</td>
	</tr>											
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.purpose" /></td>
		<td class="infoData2" width="80%" colspan=3>
		<%if("S".equals(reqStatus)||"K".equals(reqStatus)){ %>		
			<input type="textfield" name="purpose" value="<%=purpose==null?"":purpose %>" maxlength="150" size="120"/>
		<%} else { %>
			<input type="textfield" name="purpose" value="<%=purpose==null?"":purpose %>" maxlength="150" size="120" readonly="readonly"/>		
		<%} %>	
		</td>	
	</tr>
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.noOfPerson" /></td>
		<td class="infoData2" width="80%" colspan=3>
		<%if("S".equals(reqStatus)||"K".equals(reqStatus)){ %>		
			<input type="textfield" name="noOfPerson" value="<%=noOfPerson==null?"":noOfPerson %>" maxlength="3" size="3"/>
		<%}else { %>
			<input type="textfield" name="noOfPerson" value="<%=noOfPerson==null?"":noOfPerson %>" maxlength="3" size="3" readonly="readonly"/>		
		<%} %>	
		</td>	
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.typeOfMeal" /></td>
		<td class="infoData2" width="80%" colspan=3>
			<select name="mealID">
			<%mealID = mealID==null?"":mealID; %>
<jsp:include page="../ui/fsDCMB.jsp" flush="false">
	<jsp:param name="mealID" value="<%=mealID %>" />
	<jsp:param name="reqStatus" value="<%=reqStatus %>" />	
</jsp:include>
			</select>
		</td>
	</tr>
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.chargeTo" /></td>
		<td class="infoData2" width="80%" colspan=3>
		<%if("S".equals(reqStatus)||"K".equals(reqStatus)){ %>		
			<select name="chargeTo">
			<%chargeTo = chargeTo == null ? deptCode : chargeTo; %>	
			<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
				<jsp:param name="deptCode" value="<%=chargeTo %>" />
				<jsp:param name="allowAll" value="Y" />				
			</jsp:include>
			</select>
		<%}else { %>
			<select name="chargeTo" disabled>
			<%chargeTo = chargeTo == null ? deptCode : chargeTo; %>	
			<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
				<jsp:param name="deptCode" value="<%=chargeTo %>" />
				<jsp:param name="allowAll" value="Y" />				
			</jsp:include>
			</select>		
		<%} %>			
		</td>
	</tr>	
	<tr class="smallText">
		<td class="infoLabel"><bean:message key="prompt.specialReq" /></td>	
		<td class="infoData2" colspan=3>
			<div class=box><textarea id="wysiwyg" name="specReq" rows="5" cols="100" align="left"><%=specReq==null?"":specReq %></textarea></div>									
		</td>		
	</tr>
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.approvalBy" />	</td>	
		<td class="infoData2" width="80%" colspan=3>				
		<select name="sendAppTo" >
		<%if(sendAppTo == null||sendAppTo.length()==0){ %>
			<option value="" />	
		<%sendAppTo = "";} %>				
		<jsp:include page="../ui/approvalIDCMB.jsp" flush="false">		
			<jsp:param name="reqStat" value="<%=reqStatus %>" />
			<jsp:param name="sendAppTo" value="<%=sendAppTo %>" />
			<jsp:param name="deptHead" value="<%=deptHead %>" />													
			<jsp:param name="category" value="fs" />								
		</jsp:include>			
		</select>													
		</td>
	</tr>				
</table>
<hr noshade="noshade" />
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td align="center">
			<% if(reqNo!=null&&reqNo.length()>0){%>
				<% if("S".equals(reqStatus)){%>			
					<button onclick="return submitAction('edit','<%=reqNo==null?"":reqNo %>');"><bean:message key="button.save" /></button>
					<button onclick="return closeAction();"><bean:message key="button.close" /></button>
				<%} else if("R".equals(reqStatus)){ %>
					<button onclick="return closeAction();"><bean:message key="button.close" /></button>				
				<%} else { %>
					<button onclick="return closeAction();"><bean:message key="button.close" /></button>				
				<%} %>										
			<%}else{ %>
				<button onclick="return submitAction('submit','<%=reqNo==null?"":reqNo %>');"><bean:message key="button.saveSubmit" /></button>			
			<%} %>						
		</td>			
	</tr>
</table>
<input type="hidden" name="command" />
<input type="hidden" name="reqNo" />
<input type="hidden" name="reqStatus" value="<%=reqStatus==null?"":reqStatus %>"/>
</form>
<script language="javascript">
	function closeAction() {
		window.close();
	}
	
	function submitAction(cmd,reqNo) {
		document.form1.command.value = cmd;
		document.form1.requestNo.value = reqNo;
		
		var today = new Date();
		var dd = today.getDate();
		var MM = today.getMonth()+1;
		var yyyy = today.getYear();
		var validOrderDateStr = yyyy+'/'+MM+'/'+(dd+3);
		var validOrderDate = new Date(validOrderDateStr);
		var servDate = document.form1.servDate.value;

			
		if(cmd=='submit'||cmd=='edit'){			
			if (document.form1.reqDate.value == '') {
				alert('Please enter request date');
				document.form1.reqDate.focus();
				return false;
			}
			if (document.form1.servDate.value == '') {
				alert('Please enter serving date');
				document.form1.servDate.focus();
				return false;
			}else{
				var servDateStr = servDate.substring(6,10)+'/'+servDate.substring(3,5)+'/'+servDate.substring(0,2);
				var servToDate = new Date(servDateStr);
				if(servToDate<validOrderDate){
					alert('Serving date cannot early than '+validOrderDateStr);
					document.form1.servDate.focus();
					return false;
				}	
			}
			if (document.form1.noOfPerson.value == '') {
				alert('Please enter NO. of person');
				document.form1.noOfPerson.focus();
				return false;
			}else{
				if(isNaN(document.form1.noOfPerson.value)){
					alert('Please enter valid number');
					document.form1.noOfPerson.focus();
					document.form1.noOfPerson.select();
					return false;				
				}
			}	
			if (document.form1.sendAppTo.value == '') {
				alert('Please select send approval to person');
				document.form1.sendAppTo.focus();
				return false;
			}
		}

		if(reqNo!=''){
			var r=confirm("Confirm to save?");			
		}else{
			var r=confirm("Confirm to submit?");			
		}
		
		if (r==true){
			document.form1.submit();		
			return false;	
		 }else{
			 return false;	
		 }		  
	}
	
	function showVenue(inputObj) {
		var did = inputObj.value;
		if(did=='1306'){			
			$("#show_answerField").html('<td class="infoLabel" width="20%"><bean:message key="prompt.venue" /></td><td class="infoData2" width="80%" colspan=3><input type="textfield" name="venue" value="<%=venue==null?"":venue %>" maxlength="150" size="120"/></td>'); 
		}else{		
			$("#show_answerField").html(""); 				
		}
	}	
</script>
</div>
</div></div>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>