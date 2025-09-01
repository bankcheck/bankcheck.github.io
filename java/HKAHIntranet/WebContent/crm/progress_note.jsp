<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%!
private ArrayList getCRMClientLevel(String clientID) {
	return  UtilDBWeb.getReportableList("SELECT CRM_NS_LEVEL FROM CRM_CLIENTS_NEWSTART WHERE CRM_CLIENT_ID = "+clientID+" AND CRM_NS_LEVEL IS NOT NULL ");
			
}
%>
<%
UserBean userBean = new UserBean(request);
String clientID = CRMClientDB.getClientID(userBean.getUserName());
String level = null;
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>

<html:html xhtml="true" lang="true">
	<jsp:include page="../common/header.jsp"/>	<body>		
		<jsp:include page="../common/page_title.jsp" flush="false">
			<jsp:param name="pageTitle" value="Progress Note" />
			<jsp:param name="category" value="group.crm" />
			<jsp:param name="keepReferer" value="N" />
		</jsp:include>	
		<div class="infoContent3" style="width:100%;">
			<div class="content2">
				<form name="form1" action="progress_note.jsp" method="get">
					<table border="0" style="width:100%;">
<%
	ArrayList levelRecord = getCRMClientLevel(CRMClientDB.getClientID(userBean.getUserName()));		

	if (levelRecord.size() > 0) {				
		ReportableListObject row = (ReportableListObject) levelRecord.get(0);
		level = row.getValue(0);				
	}else{
		level = "1";
	}
%>
						<tr><td width="15%" class="infoLabel">Level</td><td class="infoData"><%=level %></td></tr>
						<tr class="smallText">
							<td colspan = "6"  class="infoTitle" colspan="4">Progress Note List</td>
						</tr>			
						<tr>
							<td colspan="2" style='border-width:1px; border-style:solid;background-color: #FFF6F6; '>									
								<div id='scroll-pane' class='scroll-pane jspScrollable' style='overflow: hidden; padding: 0px; width:100%; height:400px'>
									<table  id='progressNoteTable' border="0" style='border-width:0px;border-spacing:0px;width:100%;'>
										
									</table> 
								</div>										
							</td>
						</tr>
						<tr class="smallText">
							<td colspan = "6"  class="infoTitle" colspan="4"><bean:message key="function.crm.progressNoteDoc.list" /></td>
						</tr>				
						<tr class="smallText">
						<td class="infoLabel" width="15%">Documents</td>
						<td class="infoData">
							<jsp:include page="../helper/viewProgressDocument.jsp" flush="false">
								<jsp:param name="clientID" value="<%=clientID %>" />
							</jsp:include>
						</td>
						</tr>	
					</table>
				</form>
			</div>
		</div>			
	<jsp:include page="../common/footer.jsp" flush="false" />	
	</body>
</html:html>
<script language="javascript">
	var apis = [];	

	$(document).ready(function() {		
		initScroll('.scroll-pane');
		progressNoteUpdate('view',<%=clientID%>);		
	});
	

	function initScroll(pane) {
		destroyScroll();		
	$(pane).each(
			function()
			{
				apis.push($(this).jScrollPane({autoReinitialise:false}).data().jsp);
			}
		);
		return false;
	}

	function destroyScroll() {
		if (apis.length) {
			$.each(
				apis,
					function(i) {
					this.destroy();
				}
			);
			apis = [];
		}
		return false;
	}	
	
	function progressNoteUpdate(type,cID,pnID){	
		var clientID = 'clientID='+cID;
		if(type=='save'){			
			var progressNote = 'progressNote=' + encodeURIComponent($('textarea#progressNote').val());			
			var baseUrl ='../crm/progress_note_functions.jsp?action=insert';		
			var url = baseUrl + '&' + clientID + '&' + progressNote;	
			//alert(url)
			$.ajax({
				url: url,
				async: false,
				cache:false,
				success: function(values){					
					if(values) {						
						if(values.indexOf('true') > -1) {
							alert('Record Added Successfully.');	
							$('textarea#progressNote').val('') ;	
							progressNoteUpdate('view',cID);														
							}						
						else {
							alert('Error occured while adding record.');
						}
					}
				},
				error: function() {
					alert('Error occured while adding record.');
					
				}
			});
		}else if(type=='view'){
			var baseUrl ='../crm/progress_note_functions.jsp?action=view';		
			var url = baseUrl + '&' + clientID;	
			//alert(url)
			$.ajax({
				url: url,
				async: false,
				cache:false,
				success: function(values){					
					if(values) {						
						$('#progressNoteTable').html(values);
						apis[0].reinitialise();						
					}
				},
				error: function() {
					alert('Error occured while displaying record.');
					
				}
			});
		}else if(type=='delete'){
			var deleteNote = confirm("Delete Progress Note?");
			   if( deleteNote == true ){	
				var url ='../crm/progress_note_functions.jsp?action=delete&pnID='+pnID;		
					
				//alert(url)
				$.ajax({
					url: url,
					async: false,
					cache:false,
					success: function(values){					
						if(values) {		
							if(values.indexOf('true') > -1) {
							alert('Record deleted Successfully.');							
							progressNoteUpdate('view',cID);	
							}else{
								alert('Error occured while deleting record.');
							}
						}
					},
					error: function() {
						alert('Error occured while deleting record.');
						
					}
				});
			}		
		}
	}
	
	
</script>
