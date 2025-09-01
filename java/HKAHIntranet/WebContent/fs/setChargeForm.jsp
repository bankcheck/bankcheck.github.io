<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.wsclient.lombWSSetCharge.*"%>
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
String requestNo = ParserUtil.getParameter(request, "requestNo");
String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");
String deptCode = userBean.getDeptCode();
String eventID = ParserUtil.getParameter(request, "eventID");
String venue = ParserUtil.getParameter(request, "venue");
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

String noOfPerson = ParserUtil.getParameter(request, "noOfPerson");
String purpose = ParserUtil.getParameter(request, "purpose");
String specReq = TextUtil.parseStrUTF8((String) request.getAttribute("specReq"));
String sendAppTo = ParserUtil.getParameter(request, "sendAppTo");
String command = ParserUtil.getParameter(request, "command");
String reqStatus = ParserUtil.getParameter(request, "reqStatus");
String menu = ParserUtil.getParameter(request, "menuDetails");
String amount = ParserUtil.getParameter(request, "amount");
String smtd = ParserUtil.getParameter(request, "smtd");

Calendar cal = Calendar.getInstance();
SimpleDateFormat dateFmt = new SimpleDateFormat("ddMMyyyyHHmmss");
String sysDate = dateFmt.format(cal.getTime());

boolean updateAction = false;
boolean viewAction = false;
boolean closeAction = false;
boolean successUptMenu = false;

boolean webServiceSuccess = false;

String insId = null;

if("view".equals(command)){
	viewAction = true;
}else if ("save".equals(command)) {
	updateAction = true;						
}

try {	
	if(updateAction){ 
//		successUptMenu = FsDB.updateMenu(requestNo, menu, reqStatus, amount, userBean);
//		insId = FsDB.getInstanceId(requestNo);
		if(successUptMenu){
			if("B".equals(reqStatus)){
				webServiceSuccess = CallWebservice.doKickSetCharge(insId);
		    	if(webServiceSuccess){
					message = "Charge submitted success";		    	    		    		
		    	}else{
					errorMessage = "Charge submitted fail.(WebService Connet Failed)";
					updateAction = false;	
		    	}
				updateAction = false;			    	
			}else if("M".equals(reqStatus)){
				message = "Charge saved success";
				updateAction = false;
			}	
		}else{
			message = "Charge submitted failed";
			updateAction = false;				
		}
	}else{
		Calendar calendar = Calendar.getInstance();
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
		reqDate = dateFormat.format(calendar.getTime());
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
	String title = "function.dfsr.setcharge"; 
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
<bean:define id="functionLabel"><bean:message key="function.dfsr.setcharge" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" id="form1" enctype="multipart/form-data" action="setChargeForm.jsp" method=post >
<!-- 
<table cellpadding="0" cellspacing="5" class="contentFrameMenu1" border="0">
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqNo" /></td>
		<td class="infoData2" width="30%">
			<input type="textfield" name="requestNo" id="requestNo" value="<%=requestNo==null?"":requestNo %>" maxlength="8" size="20" >
		</td>
		<td class="infoData2" width="50%">
			<button onclick="return getSetMenu();">Retrieve</button>
		</td>					
	</tr>
</table>
-->
<input type="hidden" name="command" />
<input type="hidden" name="requestNo" value="<%=requestNo==null?"":requestNo %>"/>
<input type="hidden" name="reqStatus" />
<input type="hidden" name="amount" />
<input type="hidden" name="menuDetails" />
<input type="hidden" name="smtd" value="<%=smtd==null?"":smtd%>"/>
</form>
<span id="setMenu"></span>
<script language="javascript">
	$(document).ready(function() {	
		window.opener.refresh();
	});

	function closeAction() {
		window.close();
	}
	
	function getSetMenu() {
		//var reqNo = document.getElementById("requestNo").value;
		var reqNo = document.form1.requestNo.value;
		var smtd = document.form1.smtd.value;		
		
		if (reqNo == '') {
			alert('Please enter request NO.');
			document.form1.requestNo.focus();
			return false;						
		}
		$.ajax({
			type: "POST",
			url: "../fs/setChargeFormDetail.jsp",
			data: "reqNo="+reqNo + "&submitted=" + smtd,
			async: false,
			success: function(values){
				if(values != '') {
					$("#setMenu").html(values);
				} else {
					$("#setMenu").html('');
				}//if
			},//success
			error: function(jqXHR, textStatus, errorThrown) {
				alert('Error in "getSetMenu"');
			}
		});//$.ajax
	}
	
<%if("save".equals(command)||"view".equals(command)){%>	
	getSetMenu();
<%}%>
</script>
</div>
</div></div>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>