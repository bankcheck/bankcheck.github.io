<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.concurrent.TimeUnit"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.constant.*"%>

<%!
public static long getDateDiff(Date date1, Date date2, TimeUnit timeUnit) {
    long diffInMillies = date2.getTime() - date1.getTime();
    return timeUnit.convert(diffInMillies,TimeUnit.MILLISECONDS);
}
%>
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

String serverSiteCode = ConstantsServerSide.SITE_CODE;
UserBean userBean = new UserBean(request);
String command = ParserUtil.getParameter(request, "command");
String reqNo = ParserUtil.getParameter(request, "reqNo");
String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");
String deptCode = userBean.getDeptCode();
String eventID = ParserUtil.getParameter(request, "eventID");
String venue = TextUtil.parseStrUTF8((String) ParserUtil.getParameter(request, "venue"));
if(venue!=null){
	venue=venue.trim();
}
String mealID = ParserUtil.getParameter(request, "mealID");
String mealEvent = ParserUtil.getParameter(request, "mealEvent");
String reqByName = StaffDB.getStaffFullName2(userBean.getLoginID());
String reqSiteCode = ConstantsServerSide.SITE_CODE;
String reqDept = ParserUtil.getParameter(request, "reqDept");
String chargeTo = ParserUtil.getParameter(request, "chargeTo");
String reqBy = ParserUtil.getParameter(request, "reqBy");
String reqDate = ParserUtil.getParameter(request, "reqDate");
String otherMeal = ParserUtil.getParameter(request, "reqDate");
String contactTel = ParserUtil.getParameter(request, "contactTel");
String estAmount = ParserUtil.getParameter(request, "estAmount");

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
String otherReq = ParserUtil.getParameter(request, "otherReq");
String otherChg = ParserUtil.getParameter(request, "otherChg");

String requestType = ParserUtil.getParameter(request, "requestType");
if(noOfPerson==null){
	noOfPerson="0";
}else{
	noOfPerson=noOfPerson.trim();
}
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
String sendAppTo = ParserUtil.getParameter(request, "selectedApprover");
String reqStatus = ParserUtil.getParameter(request, "reqStatus");
String approveFlag = ParserUtil.getParameter(request, "approveFlag");
String deptHead = null;
String priceRange = ParserUtil.getParameter(request, "priceRange");
if(priceRange==null){
	priceRange="0";
}else{
	priceRange=priceRange.trim();
}
String chargeAmount = ParserUtil.getParameter(request, "chargeAmount");
Calendar cal = Calendar.getInstance();
SimpleDateFormat dateFmt = new SimpleDateFormat("ddMMyyyyHHmmss");
SimpleDateFormat dateFmt2 = new SimpleDateFormat("dd/MM/yyyy");
String sysDate = dateFmt.format(cal.getTime());

cal.set(Calendar.HOUR_OF_DAY, 0);
cal.set(Calendar.MINUTE, 0);
cal.set(Calendar.SECOND, 0);
cal.set(Calendar.MILLISECOND, 0);

Date serveDateDate = null;
long diffInMillies = 0;

try{
	serveDateDate = dateFmt2.parse(servDate);
	diffInMillies = getDateDiff(cal.getTime(),serveDateDate,TimeUnit.DAYS);
	System.err.println("[servDate]:"+servDate+";[currentDate]"+cal.getTime()+";[diffInMillies]:"+diffInMillies);	
}catch(Exception e){
	System.err.println("[servDate]:"+servDate);
}

ArrayList record1 = null;
ArrayList recordMiscItem = null;
recordMiscItem = FsDB.getMiscItemDtl(null);
ReportableListObject rowMiscItem = null;
int miscItemArraySize = recordMiscItem.size();
String[] checkBox = new String[miscItemArraySize];
String[] checkNo = new String[miscItemArraySize];
String[] checkQTY = new String[miscItemArraySize];
String[] checkDesc = new String[miscItemArraySize];
String[] checkUnit = new String[miscItemArraySize];

boolean approveAction = false;
boolean viewAction = false;
boolean closeAction = false;
boolean cancelAction = false;
boolean successApp = false;

String selectedApprover = null;
String reqDeptName = null;				
String chargeToName = null;
System.err.println("[command]:"+command);
if("view".equals(command)){
	viewAction = true;
}else if ("approve".equals(command)) {
	approveAction = true;
}else if ("cancel".equals(command)) {
	cancelAction = true;	
}
System.err.println("[requestFormApprove][command]:"+command);
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
	
 	if(viewAction){	
		record1 = FsDB.getReqRecord(reqNo);
		ReportableListObject row1 = (ReportableListObject) record1.get(0);
			
		reqNo = row1.getValue(0);
		reqDate = row1.getValue(1);
		reqByName = StaffDB.getStaffFullName2(row1.getValue(2));
		servDate  = row1.getValue(3);
		servDateStartTime = row1.getValue(4);
		servDateEndTime = row1.getValue(5);
		reqSiteCode = row1.getValue(6);
		reqDept = row1.getValue(7);
		chargeTo = row1.getValue(8);
		eventID = row1.getValue(9);
		venue = row1.getValue(10);
		reqStatus = row1.getValue(11);
		purpose = row1.getValue(12);
		estAmount = row1.getValue(13);
		noOfPerson = row1.getValue(14);
		mealID = row1.getValue(15);
		specReq = row1.getValue(17);
		sendAppTo = row1.getValue(18);
		priceRange = row1.getValue(28);
		mealEvent = row1.getValue(29);
		requestType = row1.getValue(30);
		selectedApprover = sendAppTo;					
		reqDeptName = DepartmentDB.getDeptDesc(reqDept);				
		chargeToName = DepartmentDB.getDeptDescWithCash(chargeTo);
		otherMeal = row1.getValue(31);
		contactTel = row1.getValue(32);
		chargeAmount = row1.getValue(33);
		otherReq = row1.getValue(34);
		otherChg = row1.getValue(35);
System.err.println("[viewAction][estAmount]:"+estAmount);
		recordMiscItem = FsDB.getMiscItemDtl(reqNo);		
		for(int i=0;i<recordMiscItem.size();i++) {
			rowMiscItem = (ReportableListObject) recordMiscItem.get(i);
			checkNo[i] = rowMiscItem.getValue(1);
			checkDesc[i] = rowMiscItem.getValue(2);
			checkQTY[i]= rowMiscItem.getValue(3);
			try {
				if(Integer.parseInt(checkQTY[i])>0){
					checkBox[i]="Y";
				}else{
					checkBox[i]="N";
				}			
			} catch (Exception e) {
				checkBox[i]="N";
			}
			checkUnit[i] = rowMiscItem.getValue(4);
		}		
	}else if(approveAction){
		System.err.println("[approveAction][estAmount]:"+estAmount);		
		successApp = FsDB.approveReqOrder(reqNo, servDateStartDateTime, servDateEndDateTime, reqDept, chargeTo, eventID, venue, purpose, noOfPerson, mealID, specReq, sendAppTo, priceRange, reqStatus, approveFlag, mealEvent, otherMeal, contactTel, estAmount, userBean);																																																					

		for(int i=0;i<miscItemArraySize;i++) {
			checkNo[i] = String.format("%02d", i+1);
			checkQTY[i] = ParserUtil.getParameter(request, "checkQTY"+String.format("%02d", i+1));
			System.err.println("checkQTY"+i+":"+checkQTY[i]);
			if("2".equals(requestType)){
	    		FsDB.updateMiscItem(userBean,reqNo,checkNo[i],checkQTY[i]);
			}else{
				System.err.println("[requestType]:"+requestType);				
			}
		}		
		
	    if (successApp){
			message = "Requisition approval success";
			approveAction = false;		    	    	
	    }else{
			errorMessage = "Requisition approval fail.";
			approveAction = false;
	    }
	    
		if("A".equals(approveFlag)){
			record1 = FsDB.getReqRecord(reqNo);
			ReportableListObject row1 = (ReportableListObject) record1.get(0);
				
			reqNo = row1.getValue(0);
			reqDate = row1.getValue(1);
			reqByName = StaffDB.getStaffFullName2(row1.getValue(2));
			reqBy = row1.getValue(2);
			servDate  = row1.getValue(3);
			servDateStartTime = row1.getValue(4);
			servDateEndTime = row1.getValue(5);
			reqSiteCode = row1.getValue(6);
			reqDept = row1.getValue(7);
			chargeTo = row1.getValue(8);
			eventID = row1.getValue(9);
			venue = row1.getValue(10);
			reqStatus = row1.getValue(11);
			purpose = row1.getValue(12);
			estAmount = row1.getValue(13);
			noOfPerson = row1.getValue(14);
			mealID = row1.getValue(15);
			specReq = row1.getValue(17);
			sendAppTo = row1.getValue(18);
			priceRange = row1.getValue(28);
			mealEvent = row1.getValue(29);
			requestType = row1.getValue(30);
			selectedApprover = sendAppTo;					
			reqDeptName = DepartmentDB.getDeptDesc(reqDept);				
			chargeToName = DepartmentDB.getDeptDescWithCash(chargeTo);
			otherMeal = row1.getValue(31);
			contactTel = row1.getValue(32);
			chargeAmount = row1.getValue(33);
			otherReq = row1.getValue(34);
			otherChg = row1.getValue(35);

			recordMiscItem = FsDB.getMiscItemDtl(reqNo);
			for(int i=0;i<recordMiscItem.size();i++) {
				rowMiscItem = (ReportableListObject) recordMiscItem.get(i);
				checkNo[i] = rowMiscItem.getValue(1);
				checkDesc[i] = rowMiscItem.getValue(2);
				checkQTY[i]= rowMiscItem.getValue(3);
				try {
					if(Integer.parseInt(checkQTY[i])>0){
						checkBox[i]="Y";
					}else{
						checkBox[i]="N";
					}			
				} catch (Exception e) {
					checkBox[i]="N";
				}			
				checkUnit[i] = rowMiscItem.getValue(4);
			}			
			
			System.err.println("A[reqStatus]:"+reqStatus+";[approveFlag]:"+approveFlag+";[reqBy]:"+reqBy);	
			if(FsDB.sendEmail(reqNo, reqBy, userBean.getLoginID(), sendAppTo, null, approveFlag, null, "2", "2")){
				System.err.println("A[sendEmail]:8"+";[serverSiteCode]:"+serverSiteCode);				
				if(FsDB.sendEmail(reqNo, reqBy, userBean.getLoginID(), sendAppTo, null, approveFlag, null, "2", "")){
					if(diffInMillies<3){
						String chargeToDeptHead = null;	
						chargeToDeptHead = EPORequestDB.getDeptHead(chargeTo);
						
						if ("hkah".equals(serverSiteCode) && "300".equals(reqDept)){
							System.err.println("A[diffInMillies]:"+diffInMillies+";[chargeTo]:"+chargeTo+";[chargeToDeptHead]:"+chargeToDeptHead);
							if(diffInMillies<3 && "300".equals(reqDept)){
								FsDB.sendEmail(reqNo, userBean.getStaffID(), userBean.getStaffID(), chargeToDeptHead, null, "S", null, "2", "3");						
							}
						}else if("twah".equals(serverSiteCode) && "FOOD".equals(reqDept)){
							if(diffInMillies<3 && "FOOD".equals(reqDept)){
								FsDB.sendEmail(reqNo, userBean.getStaffID(), userBean.getStaffID(), chargeToDeptHead, null, "S", null, "2", "3");
							}
						}
					}
										
					System.err.println("A[sendEmail]:9");					
					message = "mail sent success";							
				}else{
					message = "mail sent failed(To Requestor)";		
				}
			}else{
				message = "mail sent failed";
			}
		}else if("R".equals(approveFlag)){
			System.err.println("R[reqStatus]:"+reqStatus);
			if(FsDB.sendEmail(reqNo, reqBy, userBean.getLoginID(), sendAppTo, null, approveFlag, null, "1", "9")){
				message = "mail sent success";
			}else{
				message = "mail sent failed";				
			}

			record1 = FsDB.getReqRecord(reqNo);
			ReportableListObject row1 = (ReportableListObject) record1.get(0);
				
			reqNo = row1.getValue(0);
			reqDate = row1.getValue(1);
			reqByName = StaffDB.getStaffFullName2(row1.getValue(2));
			servDate  = row1.getValue(3);
			servDateStartTime = row1.getValue(4);
			servDateEndTime = row1.getValue(5);
			reqSiteCode = row1.getValue(6);
			reqDept = row1.getValue(7);
			chargeTo = row1.getValue(8);
			eventID = row1.getValue(9);
			venue = row1.getValue(10);
			reqStatus = row1.getValue(11);
			purpose = row1.getValue(12);
			chargeAmount = row1.getValue(13);
			noOfPerson = row1.getValue(14);
			mealID = row1.getValue(15);
			specReq = row1.getValue(17);
			sendAppTo = row1.getValue(18);
			priceRange = row1.getValue(28);
			mealEvent = row1.getValue(29);
			requestType = row1.getValue(30);
			selectedApprover = sendAppTo;					
			reqDeptName = DepartmentDB.getDeptDesc(reqDept);				
			chargeToName = DepartmentDB.getDeptDescWithCash(chargeTo);
			otherMeal = row1.getValue(31);
			contactTel = row1.getValue(32);
			estAmount = row1.getValue(33);
			otherReq = row1.getValue(34);
			otherChg = row1.getValue(35);

			recordMiscItem = FsDB.getMiscItemDtl(reqNo);
			for(int i=0;i<recordMiscItem.size();i++) {
				rowMiscItem = (ReportableListObject) recordMiscItem.get(i);
				checkNo[i] = rowMiscItem.getValue(1);
				checkDesc[i] = rowMiscItem.getValue(2);
				checkQTY[i]= rowMiscItem.getValue(3);
				try {
					if(Integer.parseInt(checkQTY[i])>0){
						checkBox[i]="Y";
					}else{
						checkBox[i]="N";
					}			
				} catch (Exception e) {
					checkBox[i]="N";
				}			
				checkUnit[i] = rowMiscItem.getValue(4);
			}				
		}
		System.err.println("A1[reqStatus][successApp]:"+successApp);		
		if(successApp){
			if("R".equals(approveFlag)){
				message = "Requisition rejected and "+message;			
			}else if("A".equals(approveFlag)) {
				message = "Food Order approved and "+message;
			}
			approveAction = false;			
		}else{
			errorMessage = "Requisition update fail.";
			approveAction = false;			
		}
	}else if(cancelAction){		
		successApp = FsDB.updateMenu( reqNo, "C", null, specReq, null, null, null, null, null, null, null, null, null, null, null, null, userBean);

	    if (successApp){
			message = "Requisition cancel success";
			approveAction = false;		    	    	
	    }else{
			errorMessage = "Requisition cancel fail.";
			approveAction = false;
	    }		

		record1 = FsDB.getReqRecord(reqNo);
		ReportableListObject row1 = (ReportableListObject) record1.get(0);
			
		reqNo = row1.getValue(0);
		reqDate = row1.getValue(1);
		reqByName = StaffDB.getStaffFullName2(row1.getValue(2));
		servDate  = row1.getValue(3);
		servDateStartTime = row1.getValue(4);
		servDateEndTime = row1.getValue(5);
		reqSiteCode = row1.getValue(6);
		reqDept = row1.getValue(7);
		chargeTo = row1.getValue(8);
		eventID = row1.getValue(9);
		venue = row1.getValue(10);
		reqStatus = row1.getValue(11);
		purpose = row1.getValue(12);
		estAmount = row1.getValue(13);
		noOfPerson = row1.getValue(14);
		mealID = row1.getValue(15);
		specReq = row1.getValue(17);
		sendAppTo = row1.getValue(18);
		priceRange = row1.getValue(28);
		mealEvent = row1.getValue(29);
		requestType = row1.getValue(30);
		selectedApprover = sendAppTo;					
		reqDeptName = DepartmentDB.getDeptDesc(reqDept);				
		chargeToName = DepartmentDB.getDeptDescWithCash(chargeTo);
		otherMeal = row1.getValue(31);
		contactTel = row1.getValue(32);
		chargeAmount = row1.getValue(33);
		otherReq = row1.getValue(34);
		otherChg = row1.getValue(35);
		
		recordMiscItem = FsDB.getMiscItemDtl(reqNo);
		for(int i=0;i<recordMiscItem.size();i++) {
			rowMiscItem = (ReportableListObject) recordMiscItem.get(i);
			checkNo[i] = rowMiscItem.getValue(1);
			checkDesc[i] = rowMiscItem.getValue(2);
			checkQTY[i]= rowMiscItem.getValue(3);
			try {
				if(Integer.parseInt(checkQTY[i])>0){
					checkBox[i]="Y";
				}else{
					checkBox[i]="N";
				}			
			} catch (Exception e) {
				checkBox[i]="N";
			}			
			checkUnit[i] = rowMiscItem.getValue(4);
		}		
	}else{
		System.err.println("[ELSE]");
		Calendar calendar = Calendar.getInstance();	
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
		reqDate = dateFormat.format(calendar.getTime());
	    calendar.set(Calendar.DAY_OF_YEAR,calendar.get(Calendar.DAY_OF_YEAR) + 3);
		servDate = dateFormat.format(calendar.getTime());
		
		recordMiscItem = FsDB.getMiscItemDtl(null);
		for(int i=0;i<recordMiscItem.size();i++) {
			rowMiscItem = (ReportableListObject) recordMiscItem.get(i);
			checkNo[i] = rowMiscItem.getValue(1);
			checkDesc[i] = rowMiscItem.getValue(2);
			checkQTY[i]= rowMiscItem.getValue(3);
			checkUnit[i] = rowMiscItem.getValue(4);
		}		
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
<style>
	TD,TH,A,SPAN,INPUT {
		font-size:16px !important;
	}
	.selected {
		background: url("../images/ui-bg_highlight-soft_75_ffe45c_1x100.png") repeat-x scroll 50% 50% #F6F6F6 !important;
	}		
</style>
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
<%
if("C".equals(reqStatus)){
%>
<font color="red" size="6">Order Cancelled</font>
<%} %>
<bean:define id="functionLabel"><bean:message key="function.dfsr.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" id="form1" enctype="multipart/form-data" action="requestFormApprove.jsp" method=post >
<table cellpadding="0" cellspacing="5" class="contentFrameMenu1" border="0" id="caretrackingTable">
<tbody>
<tr>
	<td id="patientInfo">
	<table>
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqNo" /></td>
		<td class="infoData2" width="30%">
			<b><%=reqNo==null?"":reqNo%></b>			
		</td>	
		<td class="infoLabel" width="20%"><bean:message key="prompt.siteCode" /></td>
		<td class="infoData2" width="30%">
			<input type="textfield" name="reqSiteCode" id="reqSiteCode" value="<%=reqSiteCode==null?"":reqSiteCode %>" maxlength="20" size="20" disabled="disabled">			
		</td>		
	</tr>
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.requestType" /></td>
		<td class="infoData2" width="80%"  colspan=3>
			<select name="requestType">
			<%requestType = requestType==null?"":requestType; %>
			<%System.err.println("[requestType]:"+requestType); %>	
<jsp:include page="../ui/fsDCMB.jsp" flush="false">
	<jsp:param name="mealID" value="<%=requestType %>" />
	<jsp:param name="mealType" value="REQUEST" />	
</jsp:include>
			</select>
		</td>	
	</tr>		
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.servDate" /></td>
		<td class="infoData2" width="30%">
			<input type="textfield" name="servDate" id="servDate" class="datepickerfield" value="<%=servDate==null?"":servDate %>" maxlength="20" size="20" onkeyup="validDate(this)" onblur="validDate(this)"/> (DD/MM/YYYY)
		</td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqDate" /></td>
		<td class="infoData2" width="30%">
			<input type="hidden" name="reqDate" value="<%=reqDate==null?"":reqDate %>" />
			<b><%=reqDate==null?"":reqDate %> (DD/MM/YYYY)</b>				
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
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqDept" /></td>
		<td class="infoData2" width="30%">
			<select name="reqDept" >
			<%reqDept = reqDept == null ? deptCode : reqDept; %>			
			<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
				<jsp:param name="deptCode" value="<%=reqDept %>" />
				<jsp:param name="allowAll" value="Y" />				
			</jsp:include>
			</select>					
		</td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqBy" /></td>
		<td class="infoData2" width="30%" >
			<input type="textfield" name="reqBy" id="reqBy" value="<%=reqByName==null?"":reqByName %>" maxlength="20" size="20" readonly="readonly">			
		</td>		
	</tr>
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.otherReq" /></td><td class="infoData2" width="80%" colspan=3><input type="textfield" name="otherReq" value="<%=otherReq==null?"":otherReq %>" maxlength="150" size="120"/></td>
	</tr>
<!--
	<tr id="show_answerField4">	
	</tr>	 
 -->	
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.chargeTo" /></td>
		<td class="infoData2" width="30%" >
			<select name="chargeTo">
			<%chargeTo = chargeTo == null ? deptCode : chargeTo; %>	
			<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
				<jsp:param name="deptCode" value="<%=chargeTo %>" />
				<jsp:param name="allowAll" value="Y" />								
			</jsp:include>
			</select>					
		</td>
		<td class="infoLabel" width="20%"><bean:message key="adm.contactTel" /></td>
		<td class="infoData2" width="30%" >
			<input type="textfield" name="contactTel" id="contactTel" onkeypress='numCheck(event)' value="<%=contactTel==null?"":contactTel %>" maxlength="20" size="20">			
		</td>		
	</tr>
	<tr class="smallText">	
	<td class="infoLabel" width="20%"><bean:message key="prompt.otherChg" /></td>
	<td class="infoData2" width="80%" colspan=3>
		<input type="textfield" name="otherChg" value="<%=otherChg==null?"":otherChg %>" maxlength="150" size="120"/></td>
	</tr>	
<!-- 
	<tr id="show_answerField5">	
	</tr>				
 -->	
	<tr class="smallText">
		<td class="infoLabel" width="20%">Delivery Location</td>		
		<td class="infoData2" width="80%" colspan=3>		
			<select name="eventID" onchange="return showVenue(this)">
<jsp:include page="../ui/eventIDCMB.jsp" flush="false">
	<jsp:param name="moduleCode" value="foodOrder" />
	<jsp:param name="eventID" value="<%=eventID %>" />
	<jsp:param name="allowAll" value="N" />	
</jsp:include>
			</select>
		</td>
	</tr>
	<tr id="show_answerField">		
	</tr>	
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.eventMeeting" /></td>
		<td class="infoData2" width="30%" >
			<select name="mealEvent" onchange="return showEvent(this)">
			<%System.err.println("[mealEvent]:"+mealEvent); %>				
			<%mealEvent = mealEvent==null?"":mealEvent; %>	
<jsp:include page="../ui/fsDCMB.jsp" flush="false">
	<jsp:param name="mealID" value="<%=mealEvent %>" />
	<jsp:param name="mealType" value="EVENT" />
	<jsp:param name="allowEmpty" value="Y" />
	<jsp:param name="emptyLabel" value="" />		
</jsp:include>
			</select>
		</td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.estAmount" /></td>
		<td class="infoData2" width="30%" >
		<%if("S".equals(reqStatus)){ %>		
			<input type="textfield" name="estAmount" onkeypress='numCheck(event)' value="<%=estAmount==null?"":estAmount %>" maxlength="4" size="4"/>
		<%}else{ %>
			<input type="textfield" name="estAmount" onkeypress='numCheck(event)' value="<%=estAmount==null?"":estAmount %>" maxlength="4" size="4" readonly="readonly"/>		
		<%} %>							
		</td>			
	</tr>
	<tr id="show_answerField2">	
	</tr>	
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.typeOfMeal" /></td>
		<td class="infoData2" width="30%" >
			<select name="mealID" onchange="return showMeal(this)">
			<%mealID = mealID==null?"":mealID; %>
			<%System.err.println("[mealID]:"+mealID); %>	
<jsp:include page="../ui/fsDCMB.jsp" flush="false">
	<jsp:param name="mealID" value="<%=mealID %>" />
	<jsp:param name="mealType" value="TYPE" />
	<jsp:param name="allowEmpty" value="Y" />
	<jsp:param name="emptyLabel" value="" />	
</jsp:include>
			</select>
		</td>	
		<td class="infoLabel" width="20%"><bean:message key="prompt.noOfPerson" /></td>
		<td class="infoData2" width="30%" >
		<%if("S".equals(reqStatus)){ %>		
			<input type="textfield" name="noOfPerson" onkeypress='numCheck(event)' value="<%=noOfPerson==null?"":noOfPerson %>" maxlength="3" size="3"/>
		<%}else{ %>
			<input type="textfield" name="noOfPerson" onkeypress='numCheck(event)' value="<%=noOfPerson==null?"":noOfPerson %>" maxlength="3" size="3" readonly="readonly"/>		
		<%} %>							
		</td>
	</tr>		
	<tr>
		<td colspan="4"  style='text-align:center;  font-size:14px;'>
		<span style="color:green">
		-----------------------------------------------
			<button type="button" id='Patient_Contact_Info_Show' class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only record'
							style='width:250px;text-align:left; height:30px; font-size:15px;'>
						Show Miscellaneous Item List
			</button>
			<button type="button" id='Patient_Contact_Info_Hide' class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only record'
							style='display:none;width:250px;text-align:left; height:30px; font-size:15px;'>
						Hide Miscellaneous Item List
			</button>
		 ----------------------------------------------
		</span>
		</td>	
	</tr>
	<td colspan='4'>
	<div id='patientContactInfo' style="display:none;">
	<table>
		<tr class="smallText">
			<td width="100" >
				<input type="checkbox" id="selectAll" onclick="javascript:invertSelected(this)"/>&nbsp;Select all								
			</td>
		</tr>
	</table>
	<table border="1|0">
		<tr class="smallText">
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[0] %>" value ="N" <%if ("Y".equals(checkBox[0])) {%> checked <% } %> class='chk-record'/><%=checkDesc[0]==null?"":checkDesc[0] %></input>																											
			</td>
			<td class="infoData2" width="14%">	
				<input type="text" name="checkQTY<%=checkNo[0] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[0]==null?"":checkQTY[0] %>" maxlength="3" size="3"/><%=checkUnit[0]==null?"":checkUnit[0] %></input>
			</td>					
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[1] %>" value ="N" <%if ("Y".equals(checkBox[1])) {%> checked <% } %> class='chk-record'/><%=checkDesc[1]==null?"":checkDesc[1] %></input>																											
			</td>
			<td class="infoData2" width="14%">		
				<input type="text" name="checkQTY<%=checkNo[1] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[1]==null?"":checkQTY[1] %>" maxlength="3" size="3"/><%=checkUnit[1]==null?"":checkUnit[1] %></input>																									
			</td>
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[2] %>" value ="N" <%if ("Y".equals(checkBox[2])) {%> checked <% } %> class='chk-record'/><%=checkDesc[2]==null?"":checkDesc[2] %></input>																											
			</td>
			<td class="infoData2" width="14%">		
				<input type="text" name="checkQTY<%=checkNo[2] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[2]==null?"":checkQTY[2] %>" maxlength="3" size="3"/><%=checkUnit[2]==null?"":checkUnit[2] %></input>																									
			</td>							
		</tr>
		<tr class="smallText">
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[3] %>" value ="N" <%if ("Y".equals(checkBox[3])) {%> checked <% } %> class='chk-record'/><%=checkDesc[3]==null?"":checkDesc[3] %></input>																											
			</td>
			<td class="infoData2" width="14%">	
				<input type="text" name="checkQTY<%=checkNo[3] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[3]==null?"":checkQTY[3] %>" maxlength="3" size="3"/><%=checkUnit[3]==null?"":checkUnit[3] %></input>
			</td>					
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[4] %>" value ="N" <%if ("Y".equals(checkBox[4])) {%> checked <% } %> class='chk-record'/><%=checkDesc[4]==null?"":checkDesc[4] %></input>																											
			</td>
			<td class="infoData2" width="14%">		
				<input type="text" name="checkQTY<%=checkNo[4] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[4]==null?"":checkQTY[4] %>" maxlength="3" size="3"/><%=checkUnit[4]==null?"":checkUnit[4] %></input>																									
			</td>
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[5] %>" value ="N" <%if ("Y".equals(checkBox[5])) {%> checked <% } %> class='chk-record'/><%=checkDesc[5]==null?"":checkDesc[5] %></input>																											
			</td>
			<td class="infoData2" width="14%">		
				<input type="text" name="checkQTY<%=checkNo[5] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[5]==null?"":checkQTY[5] %>" maxlength="3" size="3"/><%=checkUnit[5]==null?"":checkUnit[5] %></input>																									
			</td>							
		</tr>
		<tr class="smallText">
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[6] %>" value ="N" <%if ("Y".equals(checkBox[6])) {%> checked <% } %> class='chk-record'/><%=checkDesc[6]==null?"":checkDesc[6] %></input>																											
			</td>
			<td class="infoData2" width="14%">	
				<input type="text" name="checkQTY<%=checkNo[6] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[6]==null?"":checkQTY[6] %>" maxlength="3" size="3"/><%=checkUnit[6]==null?"":checkUnit[6] %></input>
			</td>					
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[7] %>" value ="N" <%if ("Y".equals(checkBox[7])) {%> checked <% } %> class='chk-record'/><%=checkDesc[7]==null?"":checkDesc[7] %></input>																											
			</td>
			<td class="infoData2" width="14%">		
				<input type="text" name="checkQTY<%=checkNo[7] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[7]==null?"":checkQTY[7] %>" maxlength="3" size="3"/><%=checkUnit[7]==null?"":checkUnit[7] %></input>																									
			</td>
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[8] %>" value ="N" <%if ("Y".equals(checkBox[8])) {%> checked <% } %> class='chk-record'/><%=checkDesc[8]==null?"":checkDesc[8] %></input>																											
			</td>
			<td class="infoData2" width="14%">		
				<input type="text" name="checkQTY<%=checkNo[8] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[8]==null?"":checkQTY[8] %>" maxlength="3" size="3"/><%=checkUnit[8]==null?"":checkUnit[8] %></input>																								
			</td>							
		</tr>
		<tr class="smallText">
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[9] %>" value ="N" <%if ("Y".equals(checkBox[9])) {%> checked <% } %> class='chk-record'/><%=checkDesc[9]==null?"":checkDesc[9] %></input>																											
			</td>
			<td class="infoData2" width="14%">	
				<input type="text" name="checkQTY<%=checkNo[9] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[9]==null?"":checkQTY[9] %>" maxlength="3" size="3"/><%=checkUnit[9]==null?"":checkUnit[9] %></input>
			</td>					
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[10] %>" value ="N" <%if ("Y".equals(checkBox[10])) {%> checked <% } %> class='chk-record'/><%=checkDesc[10]==null?"":checkDesc[10] %></input>																											
			</td>
			<td class="infoData2" width="14%">		
				<input type="text" name="checkQTY<%=checkNo[10] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[10]==null?"":checkQTY[10] %>" maxlength="3" size="3"/><%=checkUnit[10]==null?"":checkUnit[10] %></input>																									
			</td>
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[11] %>" value ="N" <%if ("Y".equals(checkBox[11])) {%> checked <% } %> class='chk-record'/><%=checkDesc[11]==null?"":checkDesc[11] %></input>																											
			</td>
			<td class="infoData2" width="14%">		
				<input type="text" name="checkQTY<%=checkNo[11] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[11]==null?"":checkQTY[11] %>" maxlength="3" size="3"/><%=checkUnit[11]==null?"":checkUnit[11] %></input>																									
			</td>							
		</tr>
		<% if("twah".equals(serverSiteCode)){%>
		<tr class="smallText">
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[12] %>" value ="N" <%if ("Y".equals(checkBox[12])) {%> checked <% } %> class='chk-record'/><%=checkDesc[12]==null?"":checkDesc[12] %></input>																											
			</td>
			<td class="infoData2" width="14%">	
				<input type="text" name="checkQTY<%=checkNo[12] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[12]==null?"":checkQTY[12] %>" maxlength="3" size="3"/><%=checkUnit[12]==null?"":checkUnit[12] %></input>
			</td>					
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[13] %>" value ="N" <%if ("Y".equals(checkBox[13])) {%> checked <% } %> class='chk-record'/><%=checkDesc[13]==null?"":checkDesc[13] %></input>																											
			</td>
			<td class="infoData2" width="14%">		
				<input type="text" name="checkQTY<%=checkNo[13] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[13]==null?"":checkQTY[13] %>" maxlength="3" size="3"/><%=checkUnit[13]==null?"":checkUnit[13] %></input>																									
			</td>
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[14] %>" value ="N" <%if ("Y".equals(checkBox[14])) {%> checked <% } %> class='chk-record'/><%=checkDesc[14]==null?"":checkDesc[14] %></input>																											
			</td>
			<td class="infoData2" width="14%">		
				<input type="text" name="checkQTY<%=checkNo[14] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[14]==null?"":checkQTY[14] %>" maxlength="3" size="3"/><%=checkUnit[14]==null?"":checkUnit[14] %></input>																									
			</td>							
		</tr>
		<tr class="smallText">
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[15] %>" value ="N" <%if ("Y".equals(checkBox[15])) {%> checked <% } %> class='chk-record'/><%=checkDesc[15]==null?"":checkDesc[15] %></input>																											
			</td>
			<td class="infoData2" width="14%">	
				<input type="text" name="checkQTY<%=checkNo[15] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[15]==null?"":checkQTY[15] %>" maxlength="3" size="3"/><%=checkUnit[15]==null?"":checkUnit[15] %></input>
			</td>					
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[16] %>" value ="N" <%if ("Y".equals(checkBox[16])) {%> checked <% } %> class='chk-record'/><%=checkDesc[16]==null?"":checkDesc[16] %></input>																											
			</td>
			<td class="infoData2" width="14%">		
				<input type="text" name="checkQTY<%=checkNo[16] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[16]==null?"":checkQTY[16] %>" maxlength="3" size="3"/><%=checkUnit[16]==null?"":checkUnit[16] %></input>																									
			</td>
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[17] %>" value ="N" <%if ("Y".equals(checkBox[17])) {%> checked <% } %> class='chk-record'/><%=checkDesc[17]==null?"":checkDesc[17] %></input>																											
			</td>
			<td class="infoData2" width="14%">		
				<input type="text" name="checkQTY<%=checkNo[17] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[17]==null?"":checkQTY[17] %>" maxlength="3" size="3"/><%=checkUnit[17]==null?"":checkUnit[17] %></input>																									
			</td>							
		</tr>
		<tr class="smallText">
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[18] %>" value ="N" <%if ("Y".equals(checkBox[18])) {%> checked <% } %> class='chk-record'/><%=checkDesc[18]==null?"":checkDesc[18] %></input>																											
			</td>
			<td class="infoData2" width="14%">	
				<input type="text" name="checkQTY<%=checkNo[18] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[18]==null?"":checkQTY[18] %>" maxlength="3" size="3"/><%=checkUnit[18]==null?"":checkUnit[15] %></input>
			</td>					
			<td class="infoData2" width="18%">
				<input type="checkbox" name="check<%=checkNo[19] %>" value ="N" <%if ("Y".equals(checkBox[19])) {%> checked <% } %> class='chk-record'/><%=checkDesc[19]==null?"":checkDesc[19] %></input>																											
			</td>
			<td class="infoData2" width="14%">		
				<input type="text" name="checkQTY<%=checkNo[19] %>" onkeypress='numCheck(event)' onblur='autoClick(this)' value="<%=checkQTY[19]==null?"":checkQTY[19] %>" maxlength="3" size="3"/><%=checkUnit[19]==null?"":checkUnit[19] %></input>																									
			</td>
			<td class="infoData2" width="18%">																											
			</td>
			<td class="infoData2" width="14%">																											
			</td>							
		</tr>							
		<% }%>												
	</table>
	<hr size="20">
	</div>
	</td>	
	<tr id="show_answerField3">	
	</tr>				
	<tr class="smallText">
		<td class="infoLabel"><bean:message key="prompt.specialReq" /></td>	
		<td class="infoData2" colspan=3>
			<div class=box>
<!-- 			
				<textarea id="wysiwyg" name="specReq" rows="5" cols="100" align="left"><%=specReq==null?"":specReq %></textarea>
-->				
				<textarea name="specReq" rows="6" cols="80" style="font-size:18px;"><%=specReq==null?"":specReq %></textarea>
			</div>									
		</td>		
	</tr>
	<tr class="smallText">	
		<td class="infoLabel"><bean:message key="prompt.approvalAction" /></td>	
		<td class="infoData2" colspan=3>		
			<select name="approveFlag" >
			<%if("S".equals(reqStatus)){ %>
				<option value="A" <%="A".equals(reqStatus)?" selected":""%>>APPROVE</option>
				<option value="R" <%="R".equals(reqStatus)?" selected":""%>>NOT APPROVE</option>	
			<%}else if("A".equals(reqStatus)){ %>
				<option value="A" <%="A".equals(reqStatus)?" selected":""%>>APPROVED</option>						
			<%}else if("R".equals(reqStatus)){ %>
				<option value="R" <%="R".equals(reqStatus)?" selected":""%>>REJECTED</option>		
			<%}else { %>
				<option value="A" <%="A".equals(reqStatus)?" selected":""%>>APPROVED</option>
			<%} %>
			</select>
		</td>		
	</tr>				
	</table>
	</td>
</tr>
</tbody>	
</table>
<hr noshade="noshade" />
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<%if("S".equals(reqStatus)){%>
		<td align="center" width="50%">
			<button onclick="return submitAction('approve','<%=reqNo==null?"":reqNo %>');"><bean:message key="button.approveReject" /></button>
			<button onclick="return submitAction('cancel','<%=reqNo==null?"":reqNo %>');"><bean:message key="button.cancelOrder" /></button>
			<button onclick="return closeAction();"><bean:message key="button.close" /></button>
		</td>
		<%}else{ %>
		<td align="center" width="50%">
			<button onclick="return closeAction();"><bean:message key="button.close" /></button>			
		</td>					
		<%} %>		
	</tr>
</table>
<input type="hidden" name="command" />
<input type="hidden" name="reqNo" />
<input type="hidden" name="reqStatus" value="<%=reqStatus==null?"":reqStatus %>"/>
<input type="hidden" name="selectedApprover" value="<%=selectedApprover==null?"":selectedApprover %>"/>
</form>
<script language="javascript">
$(document).ready(function() {
	showVenue(document.form1.eventID);
	showEvent(document.form1.mealEvent);
	showMeal(document.form1.mealID);
	
	var windowRtn = window.opener;
	if(windowRtn!=null && window.windowRtn){
		window.opener.refresh();		
	}
	$(document).ready(function() {
		window.opener.refresh();
	});
	
	selectRecordEvent();
	<%if("2".equals(requestType)){ %>		
		autoShowMisc(true);
	<%}else{ %>
		document.getElementById("Patient_Contact_Info_Show").disabled = true;
	<%} %>				

//	showOtherRequest(document.form1.reqDept);
//	showOtherCharge(document.form1.chargeTo);
		
	$('th.header').unbind('click');
});

	function autoShowMisc(showTrue) {
		if(showTrue){
		    document.getElementById("Patient_Contact_Info_Show").disabled = false;			
			document.form1.Patient_Contact_Info_Show.click();
		}else{
			document.form1.Patient_Contact_Info_Hide.click();			
		    document.getElementById("Patient_Contact_Info_Show").disabled = true;			
		};
	}

	function closeAction() {
		window.close();
	}
	
	function autoShowMisc(showTrue) {
		if(showTrue){
		    document.getElementById("Patient_Contact_Info_Show").disabled = false;			
			document.form1.Patient_Contact_Info_Show.click();
		}else{
			document.form1.Patient_Contact_Info_Hide.click();			
		    document.getElementById("Patient_Contact_Info_Show").disabled = true;			
		};
	}	
		
	function submitAction(cmd,reqNo) {	
		document.form1.reqNo.value = reqNo;
		var approveFlag = document.form1.approveFlag.value;
		var specReq = document.form1.approveFlag.value;
		var estAmount = document.form1.estAmount.value;

		var today = new Date();
		var validOrderDate = new Date();
		validOrderDate.setHours(0,0,0,0); //remove time
		var currDD = parseInt(today.getDate());
		var currMM = today.getMonth()+1;
		var currYYYY = today.getFullYear();
	
		var servDate = document.form1.servDate.value;
		var servDateYYYY = parseInt(servDate.substring(6,10));
		
		if(servDate.substring(3,5).substring(0,1)=='0'){
			var servDateMM = parseInt(servDate.substring(4,5))-1;			
		}else{
			var servDateMM = parseInt(servDate.substring(3,5))-1;
		}
		
		if(servDate.substring(0,2).substring(0,1)=='0'){
			var servDateDD = parseInt(servDate.substring(1,2));		
		}else{
			var servDateDD = parseInt(servDate.substring(0,2));
		}
		
		var servDt = new Date(servDateYYYY, servDateMM, servDateDD);		
	    // The number of milliseconds in one day
	    var ONE_DAY = 1000 * 60 * 60 * 24;
	    // Calculate the difference in milliseconds
//	    var difference_ms = Math.abs(servDt - validOrderDate);
	   	var difference_ms = servDt - validOrderDate;

	    // Convert back to days and return
	    var dayDiff=Math.round(difference_ms/ONE_DAY);

		if(cmd=='approve'){			
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
				if(document.form1.requestType.value=='1'){
					<%if ("hkah".equals(serverSiteCode)) { System.err.println("1[serverSiteCode]:"+serverSiteCode);%>				
						<%if(!("300".equals(deptCode))){ System.err.println("1[deptCode]:"+deptCode);%>					
							if(dayDiff<3){
								validOrderDate.setDate(today.getDate()+3);
								alert('Must apply at least 3 days before the serve date');
								document.form1.servDate.focus();
								return false;
							}
						<%}%>
					<%}else if ("twah".equals(serverSiteCode)) { System.err.println("2[serverSiteCode]:"+serverSiteCode);%>				
						<%if(!("FOOD".equals(deptCode))){ System.err.println("2[deptCode]:"+deptCode);%>
							if(dayDiff<3){
								validOrderDate.setDate(today.getDate()+3);
								alert('Must apply at least 3 days before the serve date');
								document.form1.servDate.focus();
								return false;
							}
						<%}%>
					<%}%>
				}else{
					<%if ("hkah".equals(serverSiteCode)) { System.err.println("3[serverSiteCode]:"+serverSiteCode);%>
					
					<%if(!("300".equals(deptCode))){ System.err.println("1[deptCode]:"+deptCode);%>
/*					
						if(dayDiff<0){
							validOrderDate.setDate(today.getDate());
							alert('Must apply at least 3 days before the serve date');
							document.form1.servDate.focus();
							return false;
						}
*/						
					<%}%>
					
				<%}else if ("twah".equals(serverSiteCode)) { System.err.println("4[serverSiteCode]:"+serverSiteCode);%>				
					<%if(!("FOOD".equals(deptCode))){ System.err.println("2[deptCode]:"+deptCode);%>
/*					
						if(dayDiff<0){
							validOrderDate.setDate(today.getDate());
							alert('Must apply at least 3 days before the serve date');
							document.form1.servDate.focus();
							return false;
						}
*/						
					<%}%>
				<%}%>					
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
		
			if (document.form1.specReq.value == '' && approveFlag == 'R') {
				alert('Please enter reject reason');
				document.form1.specReq.focus();
				return false;
			}		

			if(reqNo!=null && reqNo.length>0){
				if(approveFlag=='A'){
					var r=confirm("Confirm to Approve?");				
				}else if(approveFlag=='R'){
					var r=confirm("Confirm to Reject?");				
				}
			}

			if(estAmount==null){
				document.form1.estAmount.value=0;
			}
					
			if (r==true){
				document.form1.command.value = cmd;
				document.form1.submit();		
				return false;	
			 }else{
				 return false;	
			 }
			
		}else if(cmd=='cancel'){
			if(reqNo!=null && reqNo.length>0){
				var r = confirm("Confirm to cancel order?");
			}

			if(estAmount!=null && estAmount>0){
				document.form1.estAmount.value=0;
			}
					
			if (r==true){
				document.form1.command.value = cmd;				
				document.form1.submit();
				return false;	
			 }else{
				 return false;	
			 }			
		}
	}
	
	function showVenue(inputObj) {
		var did = inputObj.value;
		if(did=='1306'){			
			$("#show_answerField").html('<td class="infoLabel" width="20%"><bean:message key="prompt.venue" /></td><td class="infoData2" width="80%" colspan=3><input type="textfield" name="venue" value="<%=venue==null?"":venue.replaceAll("'","\\\\'") %>" maxlength="150" size="120"/></td>'); 
		}else{		
			$("#show_answerField").html(""); 				
		}
	}
	
	function showEvent(inputObj) {
		var did = inputObj.value;
		if(did=='9'){			
			$("#show_answerField2").html('<td class="infoLabel" width="20%"><bean:message key="prompt.otherEvent" /></td><td class="infoData2" width="80%" colspan=3><input type="textfield" name="purpose" value="<%=purpose==null?"":purpose.replaceAll("'","\\\\'") %>" maxlength="150" size="120"/></td>'); 
		}else{		
			$("#show_answerField2").html(""); 				
		}
	}
	
	function showOtherRequest(inputObj) {
		var did = inputObj.value;

		if(did=='996'){	// department code		
			$("#show_answerField4").html('<td class="infoLabel" width="20%"><bean:message key="prompt.otherReq" /></td><td class="infoData2" width="80%" colspan=3><input type="textfield" name="otherReq" value="<%=otherReq==null?"":otherReq.replaceAll("'","\\\\'") %>" maxlength="150" size="120"/></td>'); 
		}else{		
			$("#show_answerField4").html(""); 				
		}
	}
	
	function showOtherCharge(inputObj) {
		var did = inputObj.value;

		if(did=='996'){	// department code		
			$("#show_answerField5").html('<td class="infoLabel" width="20%"><bean:message key="prompt.otherChg" /></td><td class="infoData2" width="80%" colspan=3><input type="textfield" name="otherReq" value="<%=otherChg==null?"":otherChg.replaceAll("'","\\\\'") %>" maxlength="150" size="120"/></td>'); 
		}else{		
			$("#show_answerField5").html(""); 				
		}
	}	
	
	function showMeal(inputObj) {
		var did = inputObj.value;

		if(did=='9'){			
			$("#show_answerField3").html('<td class="infoLabel" width="20%"><bean:message key="prompt.otherMeal" /></td><td class="infoData2" width="80%" colspan=3><input type="textfield" name="otherMeal" value="<%=otherMeal==null?"":otherMeal.replaceAll("'","\\\\'") %>" maxlength="150" size="120"/></td>'); 
		}else{		
			$("#show_answerField3").html(""); 				
		}
	}
	
	function numCheck(evt) {
		var theEvent = evt || window.event;
		var key = theEvent.keyCode || theEvent.which;
		key = String.fromCharCode( key );
		var regex = /[0-9]/;
		if( !regex.test(key) ) {
			theEvent.returnValue = false;
			if(theEvent.preventDefault) theEvent.preventDefault();
		}
	}
	
	function selectRecordEvent() {		
		$('button.record').each(function(i, v) {
			if(this.id == 'Patient_Contact_Info_Show'){
				$(this).click(function() {	
					$('button#Patient_Contact_Info_Hide').addClass('selected');	
					$('button#Patient_Contact_Info_Hide').css('display', '');				
					$('div#patientContactInfo').css('display', '');
					$(this).css('display','none');
				});	
			}else if(this.id == 'Patient_Contact_Info_Hide'){
				$(this).click(function() {	
					$(this).removeClass('selected');
					$('div#patientContactInfo').css('display', 'none');
					$(this).css('display', 'none');
					$('button#Patient_Contact_Info_Show').css('display', '');
				});	
			}else{
				$(this).click(function() {				
					$(this).addClass('selected');	
					createPanel(this.id,'record');
				});
			}			
		});
	}
	
	function autoClick(inpObj){
		var qty = inpObj.value;
		if(inpObj.name.substr(0, 5)=='check'){
			itemNo = inpObj.name.substr(8, 2);	
			if(qty>0){
				$('input[name=check'+itemNo+']').attr("checked",true);
			}else if(qty==0){
				$('input[name=check'+itemNo+']').attr("checked",false);
			}		
		}		
	}	
	
	function invertSelected(inputObj){
		var checkAll = false;
		if(inputObj.checked){
			checkAll = true;
		}else{
			checkAll = false;
		};
		$('input.chk-record').each(function(i, v) {
			if (checkAll) {
				$(this).attr("checked",true);
			}else{
				$(this).attr("checked",false);
			};
		});
	}	

</script>
</div>
</div></div>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>