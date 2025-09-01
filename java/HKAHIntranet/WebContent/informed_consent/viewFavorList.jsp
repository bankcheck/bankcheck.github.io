<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.config.MessageResources"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
private boolean updateFavourList(String docCode, String[] procedure) {
	boolean success = true;
	if (procedure != null && procedure.length > 0) {
	// clear old procedure
	success = UtilDBWeb.updateQueue("UPDATE CFM_DRFAVLIST@IWEB SET ENABLED = 0 WHERE DOCCODE = ?", new String[] { docCode });

	// add procedure	
		for (int i = 0; i < procedure.length; i++) {
			UtilDBWeb.updateQueue("INSERT INTO CFM_DRFAVLIST@IWEB (FAVID, DOCCODE,PROCCODE) VALUES ((SEQ_CFMDRFAVLIST.NEXTVAL@IWEB), ?, ?)",
					new String[] { docCode, procedure[i] });
		}
	} else if (procedure == null) {
		success = UtilDBWeb.updateQueue("UPDATE CFM_DRFAVLIST@IWEB SET ENABLED = 0 WHERE DOCCODE = ?", new String[] { docCode });
	}

	return success;
}
%>
<%
UserBean userBean = new UserBean(request);
String docCode = request.getParameter("docCode");
String patno = request.getParameter("patno");
String procSelect[] = request.getParameterValues("ProcedureSelect1");
String command = request.getParameter("command");

boolean updateAction = false;
boolean closeAction = false;

String message = "";
String errorMessage = "";

if ("update".equals(command)) {
	updateAction = true;
} else if ("close".equals(command)) {
	closeAction = true;
}

try {
	if (updateAction) {
		if ((docCode != null && docCode.length() > 0) ) {
			updateFavourList(docCode, procSelect);

			message = "Favour List updated.";
			updateAction = false;
		} else {
			errorMessage = "Favour List update fail.";
		}
	}
	
} catch (Exception e) {
	e.printStackTrace();
}

%>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>

<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<script src="../js/jquery-1.3.2.min.js" type="text/javascript"></script>
	<style>
		TD,TH,A,SPAN,INPUT {
			font-size:18px !important;
		}

		#select2{
			font-size: 12px;
			height:300px;
		
		}
		#select1{
			font-size: 12px;
			height:300px;
		
		}
		</style>
	<body>	
		<DIV id=indexWrapper>
			<DIV id=mainFrame>
				<DIV id=contentFrame>
					<form name="searchForm" action="viewFavorList.jsp"  id ="searchForm" method="post">
						<table id="procTable" cellpadding="0" cellspacing="5"  border="0" style="width:100%">
							<tr style="width:100%"><td colspan='5'>&nbsp;</td></tr>
							<tr>
								<td>All Procedures</td>
								<td>&nbsp;</td>
								<td>Favour List Procedures</td>
							</tr>
							<tr>
								<td colspan="3">
									<table>
										<tr>
											<td>
											<span id="availProcedure_indicator">
											<select name="ProcedureSelectAvailable"  multiple id="select1" class="ProcedureSelect"/>
											</span>
											</td>
											<td>
											<button id="add" onclick="return addSelect();">add</button>
											<button id="remove" onclick="return removeSelect();">delete</button>
											</td>
											<td>
												<select name="ProcedureSelect1" class="ProcedureSelect" size="5" multiple id="select2"/>
											</td>
										</tr>
									</table>
								</td>
							</tr>								
							<tr style="width:100%"><td colspan='5'>&nbsp;</td></tr>
							<tr style="width:100%">
							<td>&nbsp;</td>
							<td colspan='2'>
										<button id="save" onclick="return submitAction('update');" >Save</button>
							</td>
							</tr>
							</table>
						<input type="hidden" name="docCode" id="docCode" value="<%=docCode==null?"":docCode %>">
						<input type="hidden" name="command"/>
					</form>
				</DIV>
			</DIV>
		</DIV>
	


<script type="text/javascript">

$().ready(function() {
	
	GetProcedure();
	
	removeDuplicateItem('searchForm', 'ProcedureSelectAvailable', 'ProcedureSelect1');
	

	
});


	function addSelect() {
		return !$('#select1 option:selected').appendTo('#select2');
	}
	
	function removeSelect() {
		return !$('#select2 option:selected').appendTo('#select1');
	}
	
	function GetProcedure() {
		$.ajax({
			type: "POST",
			url: "procedureCMB.jsp",
			data: "docCode="+document.getElementById("docCode").value
					+"&favourListYN=false&editFavour=true&spec=",
			success: function(values) {
			if (values != '') {		
				$("#procTable").html(values);
			} //if
			}//success
		});//$.ajax
	}
	
	function submitAction(cmd) {

		$('#select2 option').each(function(i) {
			$(this).attr("selected", "selected");
		});
		window.opener.location.href = window.opener.location.href;
		document.searchForm.command.value = cmd;
		document.searchForm.submit();
	}
	
</script>
</body>
</html:html>