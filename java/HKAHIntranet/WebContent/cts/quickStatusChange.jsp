<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.mail.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>

<%
UserBean userBean = new UserBean(request);

String command = (String) request.getAttribute("command");
if (command == null) {
	command = request.getParameter("command");
}

String ctsNo[] = null;
String docNo[] = null;
String docName[] = null;
String docSpec[] = null;

String ctsStatus = request.getParameter("rdStatus");
String changeStatus = request.getParameter("changeRdStatus");
String recSpec = request.getParameter("speciality");
String assignDoc = request.getParameter("assignDocTo");
String selectCtsNo[] = request.getParameterValues("updateRecord");
String formId = "F0001";

boolean updateAction = false;

String message = request.getParameter("message");
if (message == null) {
	message = "";
}
String errorMessage = "";

if ("save".equals(command)) {
	updateAction = true;
}

try {
	if (updateAction) { 
		for (int i=0; i<selectCtsNo.length; i++) {
			if (CTS.updateCtsRecordList(userBean, selectCtsNo[i], changeStatus, null, null, null)){
	    		if ("X".equals(changeStatus) || "Y".equals(changeStatus) || "Z".equals(changeStatus )|| 
	    				"I".equals(changeStatus ) || "L".equals(changeStatus ) || "K".equals(changeStatus )){
	    			
	    			ArrayList questList = CTS.getformQuest(formId,selectCtsNo[i]);
	    			
	    			if(questList.size()==0){	
		    	  		if (CTS.createFormQuestion(selectCtsNo[i])) {
	    					message = "Record update success";
	    					updateAction = false;		    	  			
		        		} else {
	    					message = "Record update failed(Question Create)";
	    					updateAction = false;    			
		        		}
	    			}else{
	    				message = "Record update success";	    				
	    			}
	    			
	         		if ("I".equals(changeStatus ) || "L".equals(changeStatus ) || "K".equals(changeStatus )){
	    	    		if(CTS.generateCoverLetter(userBean, selectCtsNo[i], "letter1")){
	    	    			System.out.println("cover letter pdf generate success");   			
	    	    		} else {
	    	    			System.out.println("cover letter pdf generate fail");    			
	    	    		}
	    	    	} else if ("J".equals(changeStatus )){
	    	    		if(CTS.generateInactLetter(userBean, selectCtsNo[i], "letter2")){
	    	    			System.out.println("inactive letter pdf generate success");   			
	    	    		} else {
	    	    			System.out.println("inactive letter pdf generate fail");    			
	    	    		}       	    		
	    	    	}
	    		}else if ("R".equals(changeStatus ) || "F".equals(changeStatus ) || "V".equals(changeStatus )){
	    			if(CTS.ctsAssignDoc(selectCtsNo[i], assignDoc)){
    					message = "Record update success";
    					updateAction = false;
	    			}else{
    					message = "Record update failed(Doctor Assign)";
    					updateAction = false;    					    				
	    			}
	    		}else{
					message = "Record update success";
					updateAction = false;	    			
	    		}
			} else {
				errorMessage = "Record update fail.";
			}
		}
	}		

	// load data from database
	ArrayList record = CTS.getRecord(ctsStatus, recSpec);
	
	if (record.size() > 0) {
		ctsNo = new String[record.size()];
		docNo = new String[record.size()];
		docName = new String[record.size()];
		docSpec = new String[record.size()];		
		ReportableListObject row = null;
		
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			ctsNo[i] = row.getValue(0);
			docNo[i] = row.getValue(1);
			docName[i] = row.getValue(2);
			docSpec[i] = row.getValue(3);
		}

	} else {
		ctsNo = null;
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
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<%if (userBean.isLogin()) { %>
<jsp:include page="../common/banner2.jsp"/>
<%} %>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<%
	String title = null;
	String commandType = null;
	if (updateAction) {
		commandType = "update";
	} else {
		commandType = "view";
	}
	// set submit label
	title = "function.cts.quickStatusChange";
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="prompt.admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<bean:define id="functionLabel"><bean:message key="function.cts.quickStatusChange" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="quickStatusChange" id="quickStatusChange" action="quickStatusChange.jsp" method="post" >
<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td width="25%"></td>
		<td class="infoLabel" width="25%"><bean:message key="prompt.recStatus" /></td>	
		<td class="infoData" width="25%">
			<select name="rdStatus">
			<option value="">			
			<option value="S"<%="S".equals(ctsStatus)?" selected":""%>>Start</option>
			<option value="X"<%="X".equals(ctsStatus)?" selected":""%>>1st Renewal(Email)</option>
			<option value="Y"<%="Y".equals(ctsStatus)?" selected":""%>>2nd Renewal(Email)</option>			
			<option value="Z"<%="Z".equals(ctsStatus)?" selected":""%>>3rd Renewal(Email)</option>
			<option value="I"<%="I".equals(ctsStatus)?" selected":""%>>1st Renewal(Post)</option>
			<option value="J"<%="J".equals(ctsStatus)?" selected":""%>>2nd Renewal(Post)</option>			
			<option value="K"<%="K".equals(ctsStatus)?" selected":""%>>3rd Renewal(Post)</option>			
			<option value="R"<%="R".equals(ctsStatus)?" selected":""%>>Application received</option>						
			<option value="F"<%="F".equals(ctsStatus)?" selected":""%>>User follow up</option>			
			<option value="V"<%="V".equals(ctsStatus)?" selected":""%>>Information verified</option>			
			<option value="A"<%="A".equals(ctsStatus)?" selected":""%>>Approved</option>		
			</select>		
		</td>
		<td width="25%"></td>
	</tr>
	<tr class="smallText">	
		<td width="25%"></td>
		<td class="infoLabel" width="25%"><bean:message key="prompt.specialty" /></td>
		<td class="infoData" width="25%">
			<select name="speciality" >
			<option value="">				
<jsp:include page="../ui/specCodeCMB.jsp" flush="false">
	<jsp:param name="spCode" value="<%=recSpec %>" />
	<jsp:param name="allowAll" value="Y" />
</jsp:include>
			</select>		
		</td>
		<td width="25%"></td>
	</tr>		
	<tr class="smallText">		
		<td width="25%"></td>
		<td align="center" colspan=2>
			<button onclick="return submitSearch();">Search</button>		
		</td>
		<td width="25%"></td>	
	</tr>	
</table>
<hr size="5" />
<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0">
	<tr class="smallText">
			<table border="0">
				<tr>
					<td class="infoCenterLabel2" width="40%"><bean:message key="prompt.searchResult" /></td>
					<td width="20%">&nbsp;</td>
					<td class="infoCenterLabel2" width="40%"><bean:message key="prompt.selectList" /></td>
				</tr>
				<tr>
					<td width="40%">
						<select name="recordList" size="15" multiple id="select1">
<%				if (ctsNo != null) {
					for (int i = 0; i < ctsNo.length; i++) {
%><option value="<%=ctsNo[i] %>">[<%=docNo[i] %>] [<%=docName[i] %>] [<%=docSpec[i] %>]</option><%
					}
				}%>
						</select>
					</td>
					<td width="20%" align="center">
						<button id="add"><bean:message key="button.add" /> >></button><br>
						<button id="remove"><bean:message key="button.delete" /></button>
					</td>
					<td width="40%">
						<select name="updateRecord" size="15" multiple id="select2">
						</select>
					</td>
				</tr>
			</table>
	</tr>
	<hr size="5" />
</table>
<hr size="5" />
<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0">	
	<tr class="smallText">
		<td width="25%"></td>
		<td class="infoLabel" width="25%"><bean:message key="prompt.statusChange" /></td>	
		<td class="infoData" width="25%">
			<select name="changeRdStatus">
			<option value="">			
			<option value="S"<%="S".equals(changeStatus)?" selected":""%>>Start</option>
			<option value="X"<%="X".equals(changeStatus)?" selected":""%>>1st Renewal(Email)</option>
			<option value="Y"<%="Y".equals(changeStatus)?" selected":""%>>2nd Renewal(Email)</option>			
			<option value="Z"<%="Z".equals(changeStatus)?" selected":""%>>3rd Renewal(Email)</option>
			<option value="I"<%="I".equals(changeStatus)?" selected":""%>>1st Renewal(Post)</option>
			<option value="J"<%="J".equals(changeStatus)?" selected":""%>>2nd Renewal(Post)</option>			
			<option value="K"<%="K".equals(changeStatus)?" selected":""%>>3rd Renewal(Post)</option>			
			<option value="R"<%="R".equals(changeStatus)?" selected":""%>>Application received</option>						
			<option value="F"<%="F".equals(changeStatus)?" selected":""%>>User follow up</option>			
			<option value="V"<%="V".equals(changeStatus)?" selected":""%>>Information verified</option>			
			<option value="A"<%="A".equals(changeStatus)?" selected":""%>>Approved</option>		
			</select>		
		</td>
		<td width="25%"></td>
	</tr>
	<tr class="smallText">	
		<td width="25%"></td>
		<td class="infoLabel" width="25%"><bean:message key="prompt.approver" /></td>
		<td class="infoData" width="25%">
			<select name="assignDocTo" >
			<option value="">				
				<jsp:include page="../ui/approvalIDCMB.jsp" flush="false">
					<jsp:param name="assignDoc" value="<%=assignDoc %>" />
					<jsp:param name="category" value="cts" />								
				</jsp:include>
			</select>		
		</td>
		<td width="25%"></td>		
	</tr>			
</table>
<hr size="5" />
<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0">	
	<tr class="smallText">
		<td align="center">
			<button onclick="submitAction('save')"><bean:message key="button.saveUpdate" /></button>	
		</td>
	</tr>			
</table>
<input type="hidden" name="command"/>
</form>
<script language="javascript">
	$().ready(function() {
		$('#add').click(function() {
			return !$('#select1 option:selected').appendTo('#select2');
		});
		$('#remove').click(function() {
			return !$('#select2 option:selected').appendTo('#select1');
		});
	});

	function submitSearch() {
		document.quickStatusChange.submit();
	}
	
	$('quickStatusChange').submit(function() {
		$('#select2 option').each(function(i) {
			$(this).attr("selected", "selected");
		});
	});


	function checkAssignedDoc(ctsNO){
		$.ajax({
			type: "POST",
			url: "cts_hidden.jsp",
			data: 'p1=2&p2=' + ctsNO,
			async: false,				
			success: function(values){
			if(values != '') {
				if(values.substring(0, 1) == 1) {
					rtnVal = true;
				}else{					
					rtnVal = false;						
				}										
			}//if
			}//success
		});//$.ajax

		return rtnVal;			
	}	

	function submitAction(cmd) {
		if (cmd=='save') {
			var updateList = document.quickStatusChange.updateRecord;
			
			if (updateList.length==0) {
				alert("Please select update record");
				document.quickStatusChange.recordList.focus();
				return false;
			}
			
			if (document.quickStatusChange.changeRdStatus.value == "") {
				alert("Please select update status");
				document.quickStatusChange.changeRdStatus.focus();
				return false;
			}
			
			if (document.quickStatusChange.assignDocTo.value != '' &&
				document.quickStatusChange.changeRdStatus.value != 'R' &&
				document.quickStatusChange.changeRdStatus.value != 'F' &&
				document.quickStatusChange.changeRdStatus.value != 'V') {
				alert('Assign doctor must in Application received OR User follow up OR Information verified status, please select again.');
				document.quickStatusChange.assignDocTo.focus();
				return false;
			}

			if(document.quickStatusChange.changeRdStatus.value == 'A' &&
				document.quickStatusChange.assignDocTo.value == ''){
				
				var j = 0;

				for(var k=0 ; k<updateList.length; k++){	
					if(!checkAssignedDoc(updateList[k].value)){
						alert('CTS record NO. '+updateList[k].value+' have not been assigned');
						j++;		
					};
				}

				if(j>0){
					var answer = confirm ("Found "+j+" record(S) doctor NOT assign, continue to update?");
					if (answer) {
						document.quickStatusChange.command.value = cmd;
						document.quickStatusChange.submit();
						return false;						
					} else {
						document.quickStatusChange.assignDocTo.focus();
						return false;
					}								
				}
			}else{
				var answer = confirm ("Confirm to update?");
				if (answer) {
					document.quickStatusChange.command.value = cmd;
					document.quickStatusChange.submit();
				} else {
					return false;
				}						
			}		
		}
	}
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp"/>
</body>
</html:html>