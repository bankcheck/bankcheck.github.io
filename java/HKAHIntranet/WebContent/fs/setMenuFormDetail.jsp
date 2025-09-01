<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.wsclient.lombWSSetMenu.*"%>
<%@ page import="javax.swing.JFileChooser"%>
<%@ page import="javax.swing.JOptionPane"%>
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
String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");
String serverSiteCode = ConstantsServerSide.SITE_CODE;
String reqNo = ParserUtil.getParameter(request, "reqNo");
String reqDate = ParserUtil.getParameter(request, "reqDate");
String reqBy = ParserUtil.getParameter(request, "reqBy");
String reqByName = ParserUtil.getParameter(request, "reqByName");
String reqSiteCode = ConstantsServerSide.SITE_CODE;
String reqDept = ParserUtil.getParameter(request, "reqDept");
String servDateStart = ParserUtil.getParameter(request, "servDateStart");
String servDateStartTime = ParserUtil.getParameter(request, "servDateStartTime");
String servDateEndTime = ParserUtil.getParameter(request, "servDateEndTime");
String servDateEnd = ParserUtil.getParameter(request, "servDateEnd");
String chargeTo = ParserUtil.getParameter(request, "chargeTo");
String chargeToName = ParserUtil.getParameter(request, "chargeToName");
String venueId = ParserUtil.getParameter(request, "venueId");
String venue = ParserUtil.getParameter(request, "venue");
String reqStatus = ParserUtil.getParameter(request, "reqStatus");
String purpose = ParserUtil.getParameter(request, "purpose");
String approvedBy = ParserUtil.getParameter(request, "approvedBy");
String smtd = ParserUtil.getParameter(request, "smtd");
String estAmount =  ParserUtil.getParameter(request, "estAmount");
String mealEvent = ParserUtil.getParameter(request, "mealEvent");;
String otherMeal = ParserUtil.getParameter(request, "otherMeal");
String requestType = ParserUtil.getParameter(request, "requestType");
String command = ParserUtil.getParameter(request, "command");
	
if(purpose!=null){
	purpose = purpose.replaceAll("'","''");
	purpose=purpose.trim();
}
String specReq = TextUtil.parseStrUTF8((String) ParserUtil.getParameter(request, "specReq"));
if(specReq!=null){
	specReq = specReq.replaceAll("'","''");
	specReq=specReq.trim();
}
String chargeAmount = ParserUtil.getParameter(request, "chargeAmount");
String noOfPerson = ParserUtil.getParameter(request, "noOfPerson");
if(noOfPerson==null){
	noOfPerson="0";
}else{
	noOfPerson=noOfPerson.trim();
}
String menu = TextUtil.parseStrUTF8((String) ParserUtil.getParameter(request, "menu"));
if(menu!=null){
	menu=menu.replaceAll("'","''");
	menu=menu.trim();
}

String sendAppTo = ParserUtil.getParameter(request, "sendApproval");
String approveFlag = ParserUtil.getParameter(request, "approveFlag");
String deptCode = userBean.getDeptCode();
String deptHead = null;
String submitted = ParserUtil.getParameter(request, "submitted");
String priceRange = ParserUtil.getParameter(request, "priceRange");
String servDate = ParserUtil.getParameter(request, "servDate");
String eventID = ParserUtil.getParameter(request, "eventID");
String mealID = ParserUtil.getParameter(request, "mealID");
String reqDeptName = null;				

String otherReq = null;
String otherChg = null;

Date dateNow = new Date ();
SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
String currDate = sdf.format(dateNow);
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
String[] checkUnitPrice = new String[miscItemArraySize];
int qty = 0;
int totalAmount = 0;
int unitPrice = 0;

int noOfReq = 0;
boolean updateAction = false;
boolean submitAction = false;
boolean cancelAction = false;
boolean chargeAction = false;
boolean emailAction = false;
boolean successUpt = false;
boolean successSubmit = false;

if ("save".equals(command) && "A".equals(reqStatus) && "AY".equals(smtd)) {	
	updateAction = true;
}else if ("save".equals(command) && "M".equals(reqStatus) && "BY".equals(smtd)) {		
	submitAction = true;
}else if ("save".equals(command) && "C".equals(reqStatus) && "CY".equals(smtd)) {		
	cancelAction = true;
}else if ("email".equals(command)) {
	emailAction = true;		
}

try {
	if(updateAction){
		System.err.println("mealEvent"+mealEvent+";[venue]:"+venue+";[purpose]:"+purpose+";[otherMeal]:"+otherMeal);
		successUpt = FsDB.updateMenu( reqNo, "A", menu, specReq, mealID, noOfPerson, estAmount, servDateStartDateTime, servDateEndDateTime, chargeTo, mealEvent, eventID, venue, purpose, otherMeal, chargeAmount, userBean);
		
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

	    if (successUpt){
			message = "Requisition update success";
			updateAction = false;		    	   
	    }else{
	    	errorMessage = "Requisition update fail.";
			updateAction = false;
	    }
	    
		record1 = FsDB.getReqRecord(reqNo);
		ReportableListObject row1 = (ReportableListObject) record1.get(0);
			
		reqNo = row1.getValue(0);
		reqDate = row1.getValue(1);
		reqBy = row1.getValue(2);
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
		menu = row1.getValue(16);
		specReq = row1.getValue(17);
		sendAppTo = row1.getValue(18);
		approvedBy = row1.getValue(24);
		priceRange = row1.getValue(28);
		mealEvent = row1.getValue(29);
		requestType = row1.getValue(30);
		otherMeal = row1.getValue(31);		
		chargeAmount = row1.getValue(33);		
		otherReq = row1.getValue(34);
		otherChg = row1.getValue(35);		
		reqDeptName = DepartmentDB.getDeptDesc(reqDept);				
		chargeToName = DepartmentDB.getDeptDesc(chargeTo);
		
		recordMiscItem = FsDB.getMiscItemDtl(reqNo);		
		for(int i=0;i<recordMiscItem.size();i++) {
			rowMiscItem = (ReportableListObject) recordMiscItem.get(i);
			checkNo[i] = rowMiscItem.getValue(1);
			checkDesc[i] = rowMiscItem.getValue(2);
			checkQTY[i]= rowMiscItem.getValue(3);
			checkUnitPrice[i]= rowMiscItem.getValue(9);
 
			try {
				qty = Integer.parseInt(checkQTY[i]);
				if(qty>0){
					checkBox[i]="Y";
					try{
						unitPrice = Integer.parseInt(checkUnitPrice[i]);
					} catch (Exception e){
						unitPrice = 0;
					}
					totalAmount = totalAmount + unitPrice*qty;		
				}else{
					checkBox[i]="N";
				}			
			} catch (Exception e) {
				checkBox[i]="N";
			}
			checkUnit[i] = rowMiscItem.getValue(4);
		}		
	}else if(submitAction){
		successSubmit = FsDB.updateMenu(reqNo, "M", menu, specReq, mealID, noOfPerson, estAmount, servDateStartDateTime, servDateEndDateTime, chargeTo, mealEvent, eventID, venue, purpose, otherMeal, chargeAmount, userBean);
		
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
		
	    if (successSubmit){
			message = "Requisition Submit success";
					
			updateAction = false;		    	    	
	    }else{
	    	errorMessage = "Requisition Submit fail.";
			updateAction = false;
	    }
	    
		record1 = FsDB.getReqRecord(reqNo);
		ReportableListObject row1 = (ReportableListObject) record1.get(0);
		reqNo = row1.getValue(0);
		reqDate = row1.getValue(1);
		reqBy = row1.getValue(2);		
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
		approvedBy = row1.getValue(24);		
		priceRange = row1.getValue(28);
		mealEvent = row1.getValue(29);
		requestType = row1.getValue(30);
		otherMeal = row1.getValue(31);		
		chargeAmount = row1.getValue(33);		
		otherReq = row1.getValue(34);
		otherChg = row1.getValue(35);		
		reqDeptName = DepartmentDB.getDeptDesc(reqDept);				
		chargeToName = DepartmentDB.getDeptDesc(chargeTo);
		
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
	}else if(emailAction){		
		if(FsDB.sendEmail(reqNo, reqBy, userBean.getLoginID(), sendAppTo, null, reqStatus, null, "2", null)){
			message = "Email sent success";					
		}else{
			errorMessage = "Email sent fail";					
		}		
		
		updateAction = false;
	    
		record1 = FsDB.getReqRecord(reqNo);
		ReportableListObject row1 = (ReportableListObject) record1.get(0);
		reqNo = row1.getValue(0);
		reqDate = row1.getValue(1);
		reqBy = row1.getValue(2);		
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
		approvedBy = row1.getValue(24);		
		priceRange = row1.getValue(28);
		mealEvent = row1.getValue(29);
		requestType = row1.getValue(30);
		otherMeal = row1.getValue(31);		
		chargeAmount = row1.getValue(33);		
		otherReq = row1.getValue(34);
		otherChg = row1.getValue(35);		
		reqDeptName = DepartmentDB.getDeptDesc(reqDept);				
		chargeToName = DepartmentDB.getDeptDesc(chargeTo);
		
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
	}else if(cancelAction){	
		successSubmit = FsDB.updateMenu( reqNo, "C", null, null, null, null, null, null, null, null, null, null, null, null, null, null, userBean);
		
	    if (successSubmit){
			message = "Requisition cancel success";
			updateAction = false;		    	    	
	    }else{
			errorMessage = "Requisition cancel fail.";
			updateAction = false;
	    }		
		
		ArrayList record = FsDB.getReqRecord(reqNo);
		noOfReq = record.size();

		if(noOfReq>0){
			ReportableListObject row = (ReportableListObject) record.get(0);
			
			reqNo = row.getValue(0);
			reqDate = row.getValue(1);
			reqBy = row.getValue(2);			
			reqByName = StaffDB.getStaffFullName2(row.getValue(2));
			servDate  = row.getValue(3);
			servDateStartTime = row.getValue(4);		
			servDateEndTime = row.getValue(5);
			reqSiteCode = row.getValue(6);
			reqDept = row.getValue(7);
			chargeTo = row.getValue(8);
			eventID = row.getValue(9);
			venue = row.getValue(10);
			reqStatus = row.getValue(11);
			purpose = row.getValue(12);
			estAmount = row.getValue(13);			
			noOfPerson = row.getValue(14);
			mealID = row.getValue(15);
			specReq = row.getValue(17);				
			sendAppTo = row.getValue(18);
			approvedBy = row.getValue(24);			
			priceRange = row.getValue(28);
			menu = row.getValue(16);
			mealEvent = row.getValue(29);
			requestType = row.getValue(30);
			otherMeal = row.getValue(31);			
			chargeAmount = row.getValue(33);			
			otherReq = row.getValue(34);
			otherChg = row.getValue(35);			
			reqDeptName = DepartmentDB.getDeptDesc(reqDept);				
			chargeToName = DepartmentDB.getDeptDesc(chargeTo);
			
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
	}else{	
		ArrayList record = FsDB.getReqRecord(reqNo);
		noOfReq = record.size();

		if(noOfReq>0){
			ReportableListObject row = (ReportableListObject) record.get(0);
			
			reqNo = row.getValue(0);
			reqDate = row.getValue(1);
			reqBy = row.getValue(2);			
			reqByName = StaffDB.getStaffFullName2(row.getValue(2));
			servDate  = row.getValue(3);
			servDateStartTime = row.getValue(4);		
			servDateEndTime = row.getValue(5);
			reqSiteCode = row.getValue(6);
			reqDept = row.getValue(7);
			chargeTo = row.getValue(8);
			eventID = row.getValue(9);
			venue = row.getValue(10);
			reqStatus = row.getValue(11);
			purpose = row.getValue(12);
			estAmount = row.getValue(13);
			noOfPerson = row.getValue(14);
			mealID = row.getValue(15);
			specReq = row.getValue(17);				
			sendAppTo = row.getValue(18);
			approvedBy = row.getValue(24);			
			priceRange = row.getValue(28);
			menu = row.getValue(16);
			mealEvent = row.getValue(29);
			requestType = row.getValue(30);
			otherMeal = row.getValue(31);			
			chargeAmount = row.getValue(33);			
			otherReq = row.getValue(34);
			otherChg = row.getValue(35);
			reqDeptName = DepartmentDB.getDeptDesc(reqDept);				
			chargeToName = DepartmentDB.getDeptDesc(chargeTo);
			
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
<bean:define id="functionLabel"><bean:message key="function.dfsr.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form2" id="form2" enctype="multipart/form-data" action="setMenuFormDetail.jsp" method=post >
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
			<input type="textfield" name="reqSiteCode" id="reqSiteCode" value="<%=reqSiteCode==null?"":reqSiteCode %>" maxlength="20" size="20" readonly="readonly">			
		</td>		
	</tr>
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.requestType" /></td>
		<td class="infoData2" width="30%">
			<select name="requestType">
			<%requestType = requestType==null?"":requestType; %>	
<jsp:include page="../ui/fsDCMB.jsp" flush="false">
	<jsp:param name="mealID" value="<%=requestType %>" />
	<jsp:param name="mealType" value="REQUEST" />
</jsp:include>
			</select>
		</td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.approvalBy" />	</td>	
		<td class="infoData2" width="30%">				
		<select name="sendAppTo">
		<%if(approvedBy == null||approvedBy.length()==0){ %>
			<option value="" />
		<%approvedBy = "";} %>						
		<jsp:include page="../ui/approvalIDCMB.jsp" flush="false">		
			<jsp:param name="reqStat" value="<%=reqStatus %>" />
			<jsp:param name="sendAppTo" value="<%=approvedBy %>" />
			<jsp:param name="deptHead" value="<%=deptHead %>" />
			<jsp:param name="requestType" value="<%=requestType %>" />	
			<jsp:param name="category" value="fs" />								
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
<%if(otherReq!=null && otherReq!=""){ %>
			<td class="infoData2" width="30%" ><input type="textfield" name="prompt.otherReq" value="<%=otherReq==null?"":otherReq %>" maxlength="60" size="60" readonly="readonly"/>
<%}else{ %>
			<td class="infoData2" width="30%" ><input type="textfield" name="reqDept" value="<%=reqDeptName==null?"":reqDeptName %>" maxlength="40" size="40" readonly="readonly"/>
<%} %>			
		</td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqBy" /></td>
		<td class="infoData2" width="30%" >
			<input type="textfield" name="reqBy" id="reqBy" value="<%=reqByName==null?"":reqByName %>" maxlength="20" size="20" readonly="readonly">			
		</td>		
	</tr>
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
		<td class="infoLabel" width="20%"><bean:message key="prompt.otherChg" /></td>
		<td class="infoData2" width="30%" >
			<input type="textfield" name="otherChg" value="<%=otherChg==null?"":otherChg %>" maxlength="45" size="45"/>
		</td>	
	</tr>
<%if("B".equals(reqStatus) || "P".equals(reqStatus)){ %>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.delLocation" /></td>		
		<td class="infoData2" width="80%" colspan=3>		
			<select name="eventID" >
<jsp:include page="../ui/eventIDCMB.jsp" flush="false">
	<jsp:param name="moduleCode" value="foodOrder" />
	<jsp:param name="eventID" value="<%=eventID %>" />
</jsp:include>
			</select>
		</td>		
		<td class="infoLabel" width="20%"><bean:message key="prompt.typeOfMeal" /></td>
		<td class="infoData2" width="80%" colspan=3>
			<select name="mealID">
			<%mealID = mealID==null?"":mealID; %>
<jsp:include page="../ui/fsDCMB.jsp" flush="false">
	<jsp:param name="mealID" value="<%=mealID %>" />
	<jsp:param name="mealType" value="TYPE" />
	<jsp:param name="allowAll" value="Y" />	
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
			<%mealEvent = mealEvent==null?"":mealEvent; %>	
<jsp:include page="../ui/fsDCMB.jsp" flush="false">
	<jsp:param name="mealID" value="<%=mealEvent %>" />
	<jsp:param name="mealType" value="EVENT" />	
</jsp:include>
			</select>
		</td>			
		<td class="infoLabel" width="20%"><bean:message key="prompt.noOfPerson" /></td>
		<td class="infoData2" width="30%" >		
			<input type="textfield" name="noOfPerson" onkeypress='numCheck(event)' value="<%=noOfPerson==null?"":noOfPerson %>" maxlength="3" size="3"/>							
		</td>						
	</tr>
	<tr id="show_answerField3">	
	</tr>			
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.menu" /></td>		
		<td class="infoData2" width="80%" colspan=3 readonly="readonly">
		<div style="border-width: 2px;background:#FFFFFF;height:100px;width:66.25%;position:relative;border-style: inset;">
		<%=menu==null?"":menu %>
		</div>										
		</td>				
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.specialReq" /></td>	
		<td class="infoData2" width="80%" colspan=3 readonly="readonly">
		<div style="border-width: 2px;background:#FFFFFF;height:100px;width:66.25%;position:relative;border-style: inset;">
		<%=specReq==null?"":specReq %>
		</div>										
		</td>		
	</tr>	
<%}else{%>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.eventLocation" /></td>		
		<td class="infoData2" width="80%" colspan=3>
			<select name="eventID" onchange="return showVenue(this)">
			<%eventID = eventID==null?"":eventID; %>
<jsp:include page="../ui/eventIDCMB.jsp" flush="false">
	<jsp:param name="moduleCode" value="foodOrder" />
	<jsp:param name="eventID" value="<%=eventID %>" />
	<jsp:param name="allowAll" value="Y" />	
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
			<input type="textfield" name="estAmount" onkeypress='numCheck(event)' value="<%=estAmount==null?"":estAmount %>" maxlength="4" size="4"/>							
		</td>	
	</tr>
	<tr id="show_answerField2">	
	</tr>					
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.typeOfMeal" /></td>
		<td class="infoData2" width="30%" >
			<select name="mealID" onchange="return showMeal(this)">
			<%mealID = mealID==null?"":mealID; %>
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
			<input type="textfield" name="noOfPerson" value="<%=noOfPerson==null?"":noOfPerson %>" maxlength="3" size="3"/>	
		</td>						
	</tr>
	<tr id="show_answerField3">	
	</tr>		
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.menu" /></td>	
		<td class="infoData2" width="80%" colspan=3>		
			<div class=box>
				<textarea name="menu" rows="10" cols="80" style="font-size:18px;"><%=menu==null?"":menu %></textarea>			
<!--			
				<textarea id="wysiwyg" name="menu" rows="5" cols="128" align="left" ><%=menu==null?"":menu %></textarea>
-->				
			</div>								
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
	<tr class="smallText">
		<td class="infoLabel"><bean:message key="prompt.specialReq" /></td>	
		<td class="infoData2" colspan=3>
			<div class="box" >
  				<textarea name="specReq" rows="6" cols="80" style="font-size:18px;"><%=specReq==null?"":specReq %></textarea>
<!--		

				<textarea id="wysiwyg1" name="specReq" rows="5" cols="128" align="left"><%=specReq==null?"":specReq %></textarea>
-->									  				
  			</div>		
		</td>	
	</tr>		
<%} %>						
</table>
	</td>
</tr>
</tbody>	
</table>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td align="center">
<%if("A".equals(reqStatus)){ %>		
			<button onclick="return submitAction('<%=reqNo==null?"":reqNo %>','A','save');"><bean:message key="button.save" /></button>
	<%if(DateTimeUtil.compareTo(servDate, currDate) < 0){ %>
			<button onclick="return resendEmail('email','<%=reqNo==null?"":reqNo %>');"><bean:message key="button.sendConfirmEmail" /></button>			
	<%}else{%>
			<button onclick="return resendEmail('email','<%=reqNo==null?"":reqNo %>');"><bean:message key="button.sendConfirmEmail" /></button>
	<%} %>			
			<button onclick="return submitAction('<%=reqNo==null?"":reqNo %>','C','save');"><bean:message key="button.cancelOrder" /></button>
			<button style="background-color:red;color:white;border:5px #cccccc solid;" onclick="return submitAction('<%=reqNo==null?"":reqNo %>','M','save');"><bean:message key="button.saveMenu" /></button>														
			<button onclick="return closeAction();"><bean:message key="button.close" /></button>
<%}else{%>
			<button onclick="return closeAction();"><bean:message key="button.close" /></button>
<%} %>
		</td>			
	</tr>
</table>
<input type="hidden" name="command" />
<input type="hidden" name="reqNo" />
<input type="hidden" name="reqBy" value="<%=reqBy==null?"":reqBy %>"/>
<input type="hidden" name="reqStatus" value="<%=reqStatus==null?"":reqStatus %>"/>
<input type="hidden" name="smtd" value="<%="smtd"==null?"":"smtd" %>"/>
<input type="hidden" name="submitted" value="<%=submitted==null?"":submitted %>"/>
</form>
<script language="javascript">
$(document).ready(function() {
	showVenue(document.form2.eventID);
	showEvent(document.form2.mealEvent);
	showMeal(document.form2.mealID);
	selectRecordEvent();
	var windowRtn = window.opener;
	if(windowRtn!=null && window.windowRtn){
		window.opener.refresh();		
	}
	$(document).ready(function() {
		window.opener.refresh();
	});	
	
	<%if("2".equals(requestType)){ System.err.println("dasdfasd[requestType]:"+requestType);%>		
		autoShowMisc(true);
	<%}else{ %>
		document.getElementById("Patient_Contact_Info_Show").disabled = true;
	<%} %>	
	
	<%if(!"S".equals(reqStatus)){ %>	
	$("input[name=specReq]").attr("readonly", "readonly");
	<%} %>
	
	$('th.header').unbind('click');
});

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
	
	function showMeal(inputObj) {
		var did = inputObj.value;

		if(did=='9'){			
			$("#show_answerField3").html('<td class="infoLabel" width="20%"><bean:message key="prompt.otherMeal" /></td><td class="infoData2" width="80%" colspan=3><input type="textfield" name="otherMeal" value="<%=otherMeal==null?"":otherMeal.replaceAll("'","\\\\'") %>" maxlength="150" size="120"/></td>'); 
		}else{		
			$("#show_answerField3").html(""); 				
		}
	}	
	
	function submitAction(reqNo, reqStatus, cmd) {
		var menu = document.form2.menu.value;
		var specReq = document.form2.specReq.value;
		var reqBy = document.form2.reqBy.value;

		if (menu == '' &&  reqStatus!='C') {
			alert('Please enter menu');
			document.form2.menu.focus();
			return false;
		}		
	
		document.form2.reqNo.value = reqNo;
		document.form2.reqBy.value = reqBy;			
		document.form2.command.value = cmd;
		document.form2.menu.value = menu;
		document.form2.specReq.value = specReq;
		document.form2.reqStatus.value = reqStatus;		
	
		if(reqStatus=='A'){
			var r=confirm("Confirm to save?");
			document.form2.smtd.value = 'AY';				
		}else if(reqStatus=='M'){
			var r=confirm("Confirm to submit menu?");
			document.form2.smtd.value = 'BY';
		}else if(reqStatus=='C'){
			var r=confirm("Confirm to cancel this order?");
			document.form2.smtd.value = 'CY';				
		}

		if (r==true){				
			document.form2.submit();		
			return false;	
		 }else{
			 return false;	
		 }		  
	}
	
	function resendEmail(cmd,reqNo) {
		var menu = document.form2.menu.value;

		if (menu == '' || menu=='<p>&nbsp;</p>') {
			alert('Please enter menu');
			document.form2.menu.focus();
			return false;
		}else{
			var r=confirm("Confirm to send alert email?");
			if (r==true){
				document.form2.command.value = cmd;
				document.form2.reqNo.value = reqNo;			
				document.form2.submit();
				return false;	
			 }else{
				 return false;	
			 }					
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