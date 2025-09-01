<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>

<%
UserBean userBean = new UserBean(request);
String psID = request.getParameter("del");
if(psID != null && psID.length() > 0) {
	PatientDB.deletePatientService(userBean, psID, null, null, null, null);
}

request.setAttribute("tempOrders", PatientDB.getTempFoodOrderList());
%>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>

<html:html xhtml="true" lang="true">
	<jsp:include page="../common/header.jsp">
		<jsp:param name="nocache" value="N" />
	</jsp:include>
	<style>
		LABEL{
			font-size:18px;
		}
	</style>
	<body>	
		<DIV id=indexWrapper>
			<DIV id=mainFrame>
				<DIV id=contentFrame>
					<form name="form" action="customList.jsp" method="post">
						<display:table id="row" name="requestScope.tempOrders" export="false" pagesize="200" class="tablesorter" sort="list">
							<display:column title="Ward" style="width:5%">
								<label><c:out value="${row.fields6}" /></label>
							</display:column>
							<display:column title="Room" style="width:5%">
								<label><c:out value="${row.fields7}" /></label>
							</display:column>
							<display:column title="Bed" style="width:5%">
								<label><c:out value="${row.fields8}" /></label>
							</display:column>
							<display:column title="Patient No." style="width:5%">
								<label><c:out value="${row.fields2}" /></label>
							</display:column>
							<display:column title="Patient Name" style="width:20%">
								<label><c:out value="${row.fields5}" /></label>
							</display:column>
							<display:column title="Allergy" style="width:15%">
								<label><c:out value="${row.fields9}" /></label>
							</display:column>
							<display:column title="" style="width:35%">
								<div class="remark"><label><c:out value="${row.fields14}" /></label></div>
							</display:column>
							<display:column title="" style="width:10%">
								<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" 
											onclick="delTempOrder('<c:out value="${row.fields1}" />')">
									<label>Delete</label>
								</button>
							</display:column>
						</display:table>
						<input type="hidden" name="del" value=""/>
					</form>
				</DIV>
			</DIV>
		</DIV>
	</body>
</html:html>

<script type="text/javascript">
$(document).ready(function() {
	$('th').unbind('click');
	
	$.each($('.remark'), function(i, v) {
		//while(($(v).html()).indexOf("<") > -1 || ($(v).html()).indexOf(">") > -1)
			$(v).html($(v).html().replace('&lt;', '<').replace('&gt;', '>').replace('&lt;', '<').replace('&gt;', '>'));
	});
	$('input[name=del]').val('');
});

function delTempOrder(psID) {
	$('input[name=del]').val(psID);
	document.form.submit();
}
</script>