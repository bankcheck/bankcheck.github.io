<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.constant.*"%>

<%
UserBean userBean = new UserBean(request);

String templateID = request.getParameter("templateID");
String action = request.getParameter("action");
String reportID = request.getParameter("reportID");
String accessFunction = request.getParameter("accessFunction");

ArrayList template = TemplateDB.getTemplateByID(templateID);
ReportableListObject row = null;

if(template.size() > 0) {
	row = (ReportableListObject) template.get(0);
	
%>
	<jsp:include page="../common/page_title.jsp" flush="false">
		<jsp:param name="pageTitle" value="function.template.view" />
		<jsp:param name="isHideTitle" value="Y"/>
	</jsp:include>
	<div id="template-<%=templateID%>" class="template" 
		 templateId="<%=templateID%>">
		<%--Heading--%>
		<div align="center">
			<label style="font-size:22px; font-weight:bold;"><%=row.getValue(3) %></label>
		</div>
		<br/>
		
		<%--Menu--%>
		<div id="template-menu" 
				style="width:20%; height:100%; background-color:white; float:left;">
			<%--Menu View Type--%>
			<div class="menuMode">
				<table>
					<tr>
						<td style="width:20%">
							<div class="left_choice">
								<img src="../images/arrow-left.png" style="width:20px;height:20px;"/>
							</div>
						</td>
						<td style="width:60%;" align="center">
							<div class="viewType">
								<%=row.getValue(12).substring(0, 1)+row.getValue(12).substring(1).toLowerCase() %>
							</div>
						</td>
						<td style="width:20%">
							<div class="right_choice">
								<img src="../images/arrow-right.png" style="width:20px;height:20px;"/>
							</div>
						</td>
					</tr>
				</table>
			</div>
			<%--Menu Item--%>
			<div class='template-menu-pane scroll-pane jspScrollable' 
				style='overflow: hidden; padding: 0px; height:100%;'>
			</div>
			<div id="template-menu-category" style="display:none">
				<jsp:include page='../template/template_category.jsp' flush='false'>
					<jsp:param name='templateID' value='<%=templateID %>' />
					<jsp:param name='isMenu' value='Y' />
					<jsp:param name='menuType' value='CATEGORY' />
					<jsp:param name='action' value='<%=action %>' />
					<jsp:param name='reportID' value='<%=reportID %>' />
				</jsp:include>
			</div>
			<div id="template-menu-page" style="display:none">
				<jsp:include page='../template/template_category.jsp' flush='false'>
					<jsp:param name='templateID' value='<%=templateID %>' />
					<jsp:param name='isMenu' value='Y' />
					<jsp:param name='menuType' value='PAGE' />
					<jsp:param name='action' value='<%=action %>' />
					<jsp:param name='reportID' value='<%=reportID %>' />
				</jsp:include>
			</div>
		</div>
		
		<%--Content--%>
		<div id="template-content" 
				style="width:79%; height:100%; background-color:white; float:right;">
			<div class='template-content-pane scroll-pane jspScrollable' 
				style='overflow: hidden; padding: 0px; height:95%;'>
				
			</div>
			<div class="template-button-set" style="height:5%">
				<table>
					<tr>
						<td valign="middle" align="right">
<%
						if((action.equals("new") || action.equals("edit")) && 
								userBean.isAccessible(accessFunction+action)) {
%>
							<button id="submit" class="ui-button ui-widget ui-state-default 
														ui-corner-all ui-button-text-only">
								Submit
							</button>
<%
						}
						if(action.equals("view")) {
							if(userBean.isAccessible(accessFunction+"edit")) {
%>
								<button id="edit" class="ui-button ui-widget ui-state-default 
															ui-corner-all ui-button-text-only">
									Edit
								</button>
<%
							}
							if(userBean.isAccessible(accessFunction+"delete")) {
%>
								<button id="delete" class="ui-button ui-widget ui-state-default 
															ui-corner-all ui-button-text-only">
									Delete
								</button>
<%
							}
						}
						if(action.equals("edit")) {
%>
							<button id="cancel" class="ui-button ui-widget ui-state-default 
														ui-corner-all ui-button-text-only">
								Cancel
							</button>
<%
						}
%>
						</td>
					</tr>
				</table>
			</div>
		</div>
		
		<div id="template-content-container" style="display:none">
			<form name="templateForm" method="post" action="">
				<jsp:include page='../template/template_category.jsp' flush='false'>
					<jsp:param name='templateID' value='<%=templateID %>' />
					<jsp:param name='isMenu' value='N' />
				</jsp:include>
				<input type="hidden" name="command" value=""/>
				<input type="hidden" name="group" value="1"/>
				<input type="hidden" name="templateID" value="<%=templateID %>" />
				<input type="hidden" name="templateType" value="<%=row.getValue(1) %>" />
				<input type="hidden" name="reportID" value="<%=reportID %>" />
			</form>
		</div>
<%
}
%>
	</div>