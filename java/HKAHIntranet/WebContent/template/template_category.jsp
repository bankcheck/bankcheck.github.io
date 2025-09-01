<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.constant.*"%>

<%
String templateID = request.getParameter("templateID");
String parentID = request.getParameter("parentID");
String isMenu = request.getParameter("isMenu");
String menuType = request.getParameter("menuType");
String action = request.getParameter("action");
String reportID = request.getParameter("reportID");

ArrayList category = new ArrayList(); 

if(parentID != null && parentID.length() > 0) {
	category = TemplateDB.getTemplateCategoryByParentID(parentID);
}
else if(templateID != null && templateID.length() > 0) {
	if(isMenu.equals("Y") && menuType.equals("PAGE")) {
		category = TemplateDB.getTemplatePages(templateID);
	}
	else {
		category = TemplateDB.getTemplateCategoryByTemplateID(templateID);
	}
}
ReportableListObject row = null;

if(category.size() > 0) {
	for(int i = 0; i < category.size(); i++) {
		row = (ReportableListObject) category.get(i);
		
		if(isMenu.equals("Y")) {
			if(menuType.equals("PAGE")) {
%>
				<div class="template-menu-item ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" 
						pageID="<%=row.getValue(0)%>">
					P. <%=row.getValue(0) %><span class="alert"></span>		
				</div>
<%
			}
			else if(menuType.equals("CATEGORY")){
				if(!TemplateDB.hasTemplateContent(row.getValue(1))) {
%>
					<div style="background-color:#C00000;color:white!important;with:auto">
						<label style="font-size:14px; font-weight:bold; color:white!important;">
							<%=row.getValue(2) %>
						</label>
					</div>
<%
				}
				else {
%>
					<div class="template-menu-item ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" 
							templateCategoryId="<%=row.getValue(1)%>" parentID="<%=row.getValue(3)%>" 
							pageID="<%=row.getValue(15)%>">
						<%=row.getValue(2) %><span class="alert"></span>		
					</div>
<%
				}
			}
		}
		else {
			if(TemplateDB.hasTemplateContent(row.getValue(1))) {
%>
				<div templateCategoryId="<%=row.getValue(1)%>" pageID="<%=row.getValue(15)%>" order="<%=row.getValue(6)%>" 
						class="template-content-pane content-frame" style="display:none">
					<div class="template-content-heading" style="background-color:#C00000;color:white!important;">
						<label style="font-size:16px; font-weight:bold;color:white!important;">
							<%=row.getValue(2) %>
						</label>
					</div>
					
					<table cellpadding="0" cellspacing="5">
						<tbody>
							<jsp:include page='../template/template_content.jsp' flush='false'>
								<jsp:param name='templateCategoryID' value='<%=row.getValue(1) %>' />
								<jsp:param name='column' value='<%=row.getValue(4) %>' />
								<jsp:param name='isMulti' value='<%=row.getValue(5) %>' />
								<jsp:param name='action' value='<%=action %>' />
								<jsp:param name='reportID' value='<%=reportID %>' />
							</jsp:include>
						</tbody>
					</table>
				</div>
<%
			}
		}
		if(!(isMenu.equals("Y") && menuType.equals("PAGE"))) {
%>
			<jsp:include page='../template/template_category.jsp' flush='false'>
				<jsp:param name='parentID' value='<%=row.getValue(1) %>' />
				<jsp:param name='isMenu' value='<%=isMenu%>' />
				<jsp:param name='menuType' value='<%=menuType%>' />
				<jsp:param name='action' value='<%=action %>' />
				<jsp:param name='reportID' value='<%=reportID %>' />
			</jsp:include>
<%
		}
	}
}
%>