<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.constant.*"%>
<%
String serverSiteCode = ConstantsServerSide.SITE_CODE;
UserBean userBean = new UserBean(request);
String staffID = ParserUtil.getParameter(request, "staffID");
String verStaff= ParserUtil.getParameter(request, "verStaff");
String command = ParserUtil.getParameter(request, "command");
String folderID = ParserUtil.getParameter(request, "folderID");
String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
%>
<%

String patNo = ParserUtil.getParameter(request, "patNo");
String orgPatFName = null;
String orgPatGName = null;
String orgPatCName = null;
String orgPatDob = null;
String orgPatSex = null;
String orgPatID = null;
String orgPatDocType = null;
String newPatDocType = null;
String newPatFName = ParserUtil.getParameter(request, "patfname");
String newPatGName = ParserUtil.getParameter(request, "patgname");
//String newPatCName = ParserUtil.getParameter(request, "patcname");
String newPatCName = TextUtil.parseStrUTF8((String) request.getParameter("patcname"));
String newPatDob = ParserUtil.getParameter(request, "patdob");
String newPatSex = ParserUtil.getParameter(request, "patsex");
String newPatID = ParserUtil.getParameter(request, "patidno");
String newPatPassPort = ParserUtil.getParameter(request, "patpassport");
String admNo = ParserUtil.getParameter(request, "admNo");

int noOfPat = 0;
if(staffID==null){
	staffID = userBean.getStaffID();
	if(staffID==null){
		staffID = "3799";
	}	
}
String pwd = null;

boolean createAction = false;
boolean updateAction = false;
boolean updateHATSAction = false;
boolean viewAction = false;
boolean cancelAction = false;
boolean closeAction = false;

if("view".equals(command)){
	viewAction = true;
}else if ("updateHATS".equals(command)) {	
	updateHATSAction = true;	
}else if ("cancel".equals(command)) {
	cancelAction = true;
}
 
try {	
	if(viewAction){	
// load data from database
		if (patNo != null && patNo.length() > 0) {	
			ArrayList record = PatientDB.getPatInfo(patNo);
			noOfPat = record.size();			
			if(noOfPat>0){
				ReportableListObject row = (ReportableListObject) record.get(0);
				patNo = row.getValue(0);
				if(newPatFName!=null&&newPatFName.length()>0){
					orgPatFName = row.getValue(11);
				}else{
					orgPatFName = null;
				}
				if(newPatGName!=null&&newPatGName.length()>0){
					orgPatGName = row.getValue(12);
				}else{
					orgPatGName = null;
				}
				if(newPatCName!=null&&newPatCName.length()>0){
					orgPatCName = row.getValue(4);
				}else{
					orgPatCName = null;
				}				
				if(newPatDob!=null&&newPatDob.length()>0){
					orgPatDob = row.getValue(10);
				}else{
					orgPatDob = null;
				}
				if(newPatSex!=null&&newPatSex.length()>0){
					orgPatSex = row.getValue(1);
				}else{
					orgPatSex = null;
				}
				if(newPatID!=null&&newPatID.length()>0){
					orgPatID = row.getValue(2);
				}else{
					if(newPatPassPort!=null&&newPatPassPort.length()>0){
						newPatID = newPatPassPort;
						orgPatID = row.getValue(2);
					}else{
						orgPatID = null;
					}
				}				
			}
		}
			message = "Requisition waiting approval";
			viewAction = false;
	} else if (updateHATSAction) {						
		if (AdmissionDB.updateUPDATELOG(userBean, admNo, staffID, verStaff)) {
			message = "admission updated in HATS.";
		} else {
			errorMessage = "admission update fail in HATS.";
		}			
	} else {
		errorMessage = "";
		Calendar calendar = Calendar.getInstance();
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
	}	
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
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<!-- 
<script type="text/javascript" src="<html:rewrite page="/js/jquery-1.2.6.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.meio.mask.js"/>" charset="utf-8" ></script>
 -->
<body>
<div id=indexWrapper>
<div id=mainFrame>
<div id=Frame>
<%
	String title = "function.epo.list"; 
%>
<form name="form1" id="form1" onkeypress="return event.keyCode!=13">
<table width="600" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="25" bgcolor="#AA3D01">
<font color="white"><strong>Patient Information Change</strong></font>
		</td>
	</tr>
</table>
<table width="600" cellpadding="0" cellspacing="5" frame="box">
	<tr>
		<td width="100%" bgcolor="#F9F9F9" colspan=3><b>Family Name:</b></td>
	</tr>
	<tr>
		<td width="30%" bgcolor="#F9F9F9"><b>From</b></td>
		<td width="70%" bgcolor="#F9F9F9" colspan=2>
			<input type="textfield" name="orgPatFName" id="orgPatFName" value="<%=orgPatFName==null?"":orgPatFName %>" maxlength="20" size="20" readonly>			
		</td>								
	</tr>
	<tr>
		<td width="30%" bgcolor="#F9F9F9"><b>To</b></td>
		<td width="70%" bgcolor="#F9F9F9" colspan=2>
			<input type="textfield" name="newPatFName" id="newPatFName" value="<%=newPatFName==null?"":newPatFName %>" style="color:red;" maxlength="20" size="20" readonly>			
		</td>								
	</tr>	
	<tr>
		<td width="100%" bgcolor="#F9F9F9" colspan=3><b>Given Name:</b></td>
	</tr>
	<tr>	
		<td width="30%" bgcolor="#F9F9F9"><b>From</b></td>
		<td width="70%" bgcolor="#F9F9F9" colspan=2>
			<input type="textfield" name="orgPatGName" id="orgPatGName" value="<%=orgPatGName==null?"":orgPatGName %>" maxlength="20" size="20" readonly/>
		</td>
	</tr>
	<tr>	
		<td width="30%" bgcolor="#F9F9F9"><b>To</b></td>
		<td width="70%" bgcolor="#F9F9F9" colspan=2>
			<input type="textfield" name="newPatGName" id="newPatGName" value="<%=newPatGName==null?"":newPatGName %>" style="color:red;" maxlength="20" size="20" readonly/>
		</td>
	</tr>
	<tr>	
		<td width="30%" bgcolor="#F9F9F9"></td>
		<td width="35%" bgcolor="#F9F9F9"><b>From</b></td>
		<td width="35%" bgcolor="#F9F9F9"><b>To</b></td>
	</tr>
	<tr>	
		<td width="30%" bgcolor="#F9F9F9"><b>Chinese Name:</b></td>
		<td width="35%" bgcolor="#F9F9F9">
			<input type="textfield" name="orgPatCName" value="<%=orgPatCName==null?"":orgPatCName %>" maxlength="20" size="20"/>
		</td>
		<td width="35%" bgcolor="#F9F9F9">
			<input type="textfield" name="newPatCName" value="<%=newPatCName==null?"":newPatCName %>" style="color:red;" maxlength="20" size="20"/>
		</td>
	</tr>
	<tr>	
		<td width="30%" bgcolor="#F9F9F9"><b>DOB:</b></td>
		<td width="35%" bgcolor="#F9F9F9">
			<input type="textfield" name="orgPatDob" value="<%=orgPatDob==null?"":orgPatDob %>" maxlength="20" size="20" readonly/>
		</td>
		<td width="35%" bgcolor="#F9F9F9">
			<input type="textfield" name="newPatDob" value="<%=newPatDob==null?"":newPatDob %>" style="color:red;" maxlength="20" size="20" readonly/>
		</td>
	</tr>
	<tr>	
		<td width="30%" bgcolor="#F9F9F9"><b>Sex:</b></td>
		<td width="35%" bgcolor="#F9F9F9">
			<input type="textfield" name="orgPatSex" value="<%=orgPatSex==null?"":orgPatSex %>" maxlength="20" size="20" readonly/>
		</td>
		<td width="35%" bgcolor="#F9F9F9">
			<input type="textfield" name="newPatSex" value="<%=newPatSex==null?"":newPatSex %>" style="color:red;" maxlength="20" size="20" readonly/>
		</td>
	</tr>
	<tr>	
		<td width="30%" bgcolor="#F9F9F9"><b>ID/Passport No.:</b></td>
		<td width="35%" bgcolor="#F9F9F9">
			<input type="textfield" name="orgPatID" value="<%=orgPatID==null?"":orgPatID %>" maxlength="20" size="20" readonly/>
		</td>
		<td width="35%" bgcolor="#F9F9F9">
			<input type="textfield" name="newPatID" value="<%=newPatID==null?"":newPatID %>" style="color:red;" maxlength="20" size="20" readonly/>
		</td>
	</tr>
	<tr>	
		<td width="30%" bgcolor="#F9F9F9"><b>Document Type:</b></td>
		<td width="35%" bgcolor="#F9F9F9">
			<input type="textfield" name="orgPatDocType" value="<%=orgPatDocType==null?"":orgPatDocType %>" maxlength="20" size="20" readonly/>
		</td>
		<td width="35%" bgcolor="#F9F9F9">
			<input type="textfield" name="newPatDocType" value="<%=newPatDocType==null?"":newPatDocType %>" style="color:red;" maxlength="20" size="20" readonly/>
		</td>
	</tr>				
</table>
<br/><br/>
<table width="600" cellpadding="0" cellspacing="5" frame="box">
	<tr>	
		<td width="25%" bgcolor="#F9F9F9"><b>Update Staff</b></td>
		<td width="75%" bgcolor="#F9F9F9" colspan=3>
			<input type="textfield" name="staffID" value="<%=staffID==null?"":staffID %>" maxlength="20" size="20"/>
		</td>
	</tr>
	<tr>	
		<td width="25%" bgcolor="#F9F9F9"><b>Verify Staff</b></td>
		<td width="25%" bgcolor="#F9F9F9">
			<input type="textfield" name="verStaff" value="<%=verStaff==null?"":verStaff %>" maxlength="20" size="20"/>
		</td>
		<td width="25%" bgcolor="#F9F9F9"><b>Password</b></td>		
		<td width="25%" bgcolor="#F9F9F9">
			<input type="password" name="pwd" value="<%=pwd==null?"":pwd %>" maxlength="20" size="20"/>
		</td>
	</tr>				
</table>
<br/><br/>
<table width="600" cellpadding="0" cellspacing="5" frame="box">
	<tr class="smallText">
		<td align="center">
					<button onclick="return submitAction('save','<%=admNo %>');">Update to HATS</button>
					<button onclick="return closeAction();"><bean:message key="button.close" /></button>						
		</td>			
	</tr>
</table>
<input type="hidden" name="command" />admNo
<input type="hidden" name="admNo" value="<%=admNo %>"/>
</form>
<script language="javascript">
	function closeAction() {
		window.close();
	}

	function cancelAction(reqNo) {
		var r=confirm("Confirm to cancel?");
		if (r==true){
			document.form1.command.value = 'cancel';
			document.form1.reqNo.value = reqNo;	
			document.form1.submit();
			return false;	
		 }else{
			 return false;	
		 }		  
	}
	
	function submitAction(cmd,admNo) {
		var verStaff = document.form1.verStaff.value;
		var staffID = document.form1.staffID.value;
		
		var pwd = document.form1.pwd.value;

		if(cmd=='save'){
			if (verStaff == staffID) {
				alert('The Verify User ID should be different from the Update User ID.');
				return false;
			}		
/*			
			if (document.form1.reqDesc.value == '') {
				alert('Please enter project/short description');
				document.form1.reqDesc.focus();
				return false;
			}
*/
			var rtn = checkpassword(verStaff,pwd);
						
			if(rtn=='1'){
				var r=confirm("Confirm Update HATS?");
				
				if (r==true){					
				    if (!window.opener.closed)
				    {										
						document.form1.command.value = 'updateHATS';
						document.form1.admNo.value = admNo;
						document.form1.staffID.value = staffID;						
						document.form1.verStaff.value = verStaff;								    	
				        // call opener function
				        window.opener.confirmAction();
				    }
					document.form1.submit();				    
					window.close();
				 }else{
					 return false;	
				 }			
			}else if(rtn=='-1'){					
				alert('Not a counter sign staff!');
			}else if(rtn=='-2'){					
				alert('No such staff ID of invalid password!');						
			}else{
				alert('No such staff ID of invalid password!');				
			}
			 return false;			
		}		  
	}

	function checkpassword(verStaff,pwd) {
		var rtn = null;			
		$.ajax({
			type: "POST",
			url: "registration_hidden.jsp",
			data: 'p1=1&p2=' + verStaff+'&p3='+pwd,
			async: false,
			success: function(values){				
			if(values != '') {
				if(rtn=='-1'){
					rtn = values.trim();					
					alert('Not a counter sign staff!');
				}else if(rtn=='-2'){
					rtn = values.trim();					
					alert('No such staff ID of invalid password!');						
				}else{
					rtn = values.trim();				
				}
			}else{
				rtn = values.trim();					
				alert('No such staff ID of invalid password!');
			}//if
			}//success
		});//$.ajax
		return rtn;		
	}
</script>
<script type="text/javascript" >
/*
(function($){
    // call setMask function on the document.ready event
      $(function(){
        $('input:text').setMask();
      }
    );
  })(jQuery);
  */
</script>
</div>
</div></div>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>