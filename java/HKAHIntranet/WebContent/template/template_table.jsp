<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.constant.*"%>

<%
String parentID = request.getParameter("tableID");
String column = request.getParameter("tableColumn");
String isMulti = request.getParameter("tableIsMulti");
String action = request.getParameter("action");
String reportID = request.getParameter("reportID");
String templateCategoryID = request.getParameter("templateCategoryID");

ArrayList content = new ArrayList();

if(action.equals("new")) {
	if(parentID != null && parentID.length() > 0) {
		content = TemplateDB.getTemplateContentByParentID(parentID);
	}
}
else if(action.equals("view") || action.equals("edit")) {
	content = TemplateDB.getTemplateRecordAndContent(reportID, templateCategoryID, parentID, "1");
}

ReportableListObject row = null;

if(content.size() > 0) {
	int maxColumn = Integer.parseInt(column);
	int currentColumn = 0;
	if(maxColumn != 0) {
%>
		<table border="1">
<%
		for(int i = 0; i < content.size(); i++) {
			row = (ReportableListObject) content.get(i);
			if(currentColumn == 0 && maxColumn != 0) {
		%>
				<tr>
		<%
			}
			currentColumn += Integer.parseInt(row.getValue(7));
			int width = Integer.parseInt(row.getValue(8));
			int height = Integer.parseInt(row.getValue(9));
			int forMulti = Integer.parseInt(row.getValue(10));
			int needVal = Integer.parseInt(row.getValue(6));
			String format = row.getValue(3);
			boolean heading = row.getValue(5).equals("Heading");
			String align = row.getValue(23);
			
			if(format.length() > 0) {
%>
				<td colspan="<%=Integer.parseInt(row.getValue(7))%>" align="<%=align %>" 
					width="<%=width%>%" height="<%=(height==0?100:height)%>%" <%=heading?"style='text-align:center;'":"" %>>
<%
				if(format.equals("label")) {
%>
					<label><%=heading?"<b>":""%><%=row.getValue(2) %><%=heading?"</b>":""%></label>
<%
				}
				else if(format.equals("input")) {
%>
					<label><%=row.getValue(2) %></label>
<%
					if(action.equals("view")) {
%>
						<%=row.getValue(27) %>
<%
					}
					else if(action.equals("new") || action.equals("edit")) {
%>
						<input optionType="input" type="text" name="<%=row.getValue(1)%>-group-1" 
							templateCategoryID="<%=row.getValue(0)%>" 
							templateContentID="<%=row.getValue(1)%>" parentID="<%=row.getValue(4)%>" 
							templateRecordID="<%=action.equals("edit")?row.getValue(26):""%>" 
							recordGroupID="<%=action.equals("edit")?row.getValue(28):""%>"  
							value="<%=action.equals("edit")?row.getValue(27):""%>"/>
<%
					}
				}
				else if(format.equals("checkbox")) {
%>
					<label><%=row.getValue(2) %></label>
<%
					if(action.equals("view") && row.getValue(27).length() > 0) {
%>
						<img src="../images/tick_green_small.gif"/>
<%
					}
					else if(action.equals("new") || action.equals("edit")) {
%>
						<input optionType="checkbox" type="checkbox" 
							name="<%=row.getValue(1)%>-group-1"
							templateCategoryID="<%=row.getValue(0)%>" 
							templateContentID="<%=row.getValue(1)%>" parentID="<%=row.getValue(4)%>" 
							templateRecordID="<%=action.equals("edit")?row.getValue(26):""%>" 
							recordGroupID="<%=action.equals("edit")?row.getValue(28):""%>"   
							value="checked" <%=action.equals("edit")?row.getValue(27):""%>/>
<%				
					}
				}	
				else if(format.equals("textarea")) {
					if(action.equals("view")) {
%>
						 <%=row.getValue(2) %><br/>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=row.getValue(27).replaceAll("\r\n", "</br>")%>						
<%
					}
					else if(action.equals("new") || action.equals("edit")) {
%>						
						<%=row.getValue(2) %><br/>
						<textarea optionType="textarea" 
							name="<%=row.getValue(1)%>-group-1" 
							templateCategoryID="<%=templateCategoryID%>" templateContentID="<%=row.getValue(1)%>" 
							parentID="<%=row.getValue(4)%>" style="width:100%"rows='5' 
							templateRecordID="<%=action.equals("edit")?row.getValue(26):""%>" 
							recordGroupID="<%=action.equals("edit")?row.getValue(28):""%>"><%=action.equals("edit")?row.getValue(27):""%></textarea>
<%
					}
				}
%>
				</td>
<%
				
			}
			if(currentColumn == maxColumn) {
				currentColumn = 0;
%>
				</tr>
<%
			}
		}
%>
		</table>
<%
	}
}
%>