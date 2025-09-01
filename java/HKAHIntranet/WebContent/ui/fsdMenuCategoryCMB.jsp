<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.servlet.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.constant.*"%>
<%!
	private ArrayList fetchMenuItem(boolean isTW, String filterKey) {
		// fetch fund
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CODE_NO, CODE_VALUE1, CODE_VALUE2, REMARKS ");
		sqlStr.append("FROM   AH_SYS_CODE ");
		sqlStr.append("WHERE  SYS_ID = 'DIT' ");
		sqlStr.append("AND    CODE_TYPE = 'MENU_TYPE' ");
		sqlStr.append("AND    STATUS <> 'X' ");
		if(!isTW) {
			sqlStr.append("AND    REMARKS like '%[W]%' ");
		}
		else {
			if(filterKey != null && filterKey.length() > 0) {
				if(filterKey.equals("others")) {
					sqlStr.append("AND    (REMARKS like '%[S]%' ");
					sqlStr.append("OR     REMARKS like '%[*]%') ");
				}
				else if(filterKey.length() > 2) {
					sqlStr.append("AND    CODE_NO like '%"+filterKey+"%' ");
				}
				else {
					sqlStr.append("AND    REMARKS like '%["+filterKey+"]%' ");
				}
			}
		}
		sqlStr.append("ORDER BY CODE_VALUE1");
		return UtilDBWeb.getReportableListFSD(sqlStr.toString());
	}
%>

<%
UserBean userBean = new UserBean(request);
boolean isTW = ConstantsServerSide.isTWAH();

if (userBean == null || !userBean.isLogin()) {
	if(isTW) {
		%>
		<script>
			window.open("../foodtw/index.jsp", "_self");
		</script>
		<%
	}
	else {
		%>
		<script>
			window.open("../patient/index.jsp", "_self");
		</script>
		<%
	}
	
	return;
}
String menuType = request.getParameter("menuType");
String filterKey = request.getParameter("filterKey");

ArrayList record = fetchMenuItem(isTW, filterKey);
ReportableListObject row = null;

if (record.size() > 0) {
	if(isTW) {
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
		%>
			<option value="<%=row.getValue(0)%>"><%=row.getValue(1) %> <%=row.getValue(2) %></option>
		<%
		}
	}
	else {
		if(menuType != null && menuType != "menu") {
	%>		<tr><td align="center">
				<div style="width:100%" align="center">
	<%	}
		else {
			if(isTW) {
				%>
				<tr>
					<td align="center">
						<jsp:include page="../ui/foodAllergyCMB.jsp" flush="true">
							<jsp:param name="patno" value="<%=userBean.getStaffID() %>" />
						</jsp:include>
					</td>
				</tr>
				<%
			}else {
			%>			
			<tr><td align="center">
					<div style="width:90%" class="ui-button ui-widget ui-state-default ui-corner-all">
						<span class="text" style="color:purple; font-weight:bold">H - Suitable for heart patients<br/>DM - Suitable for diabetics<br/>S - Suitable for those on a soft/bland diet</span>
					</div>
				</td>
			</tr>
			<%
			}
			
			%>
			<tr><td>&nbsp;</td></tr>
			<tr style="background-color:#C43CDF; height:80px;">
				<td align="center">
					<div style="width:90%" align="center">
						<div class="menuBtnLoc" style="float:left; width:45%" align="center">
						</div>
						<div class="setMenuBtnLoc" style="float:right; width:45%" align="center">
						</div>
					</div>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			
			<%
			
		}
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			if(menuType == null) {
				if(i%2 == 0) {
		%>			
		<tr><td align="center">
			<div style="width:90%" align="center">
				<div style="float:left; width:45%" align="center">
		<%		} else {
		%>		<div style="float:right; width:45%" align="center">
		<%		}
		%>		
					<label class="text"><%=row.getValue(1) %> <%=row.getValue(2) %> <%=(row.getValue(1).indexOf("U.") > -1)?"<span style='color:red'>(Additional 額外需要)</span>":"" %></label><br/>
						<img style="cursor: pointer" src="../images/<%=isTW?"food":"food/"+row.getValue(0) %>.jpg" 
							class = "foodCategory" 
						 	id="<%=row.getValue(0) %>" 
						 	title="<%=row.getValue(1) %> <%=row.getValue(2) %>" 
						 	/>
				</div>
			
		<%		if(i%2 == 1) {
		%>			
		</div></td></tr>
		<tr><td>&nbsp;</td></tr>
		<%		}
			}else {
		%>		
				<div style='display:none;'><%=row.getValue(1) %> <%=row.getValue(2) %></div><label></label>
					<img style="cursor: pointer" src="../images/<%=isTW?"food":"food/"+row.getValue(0) %>.jpg" 
					 	id="<%=row.getValue(0) %>" width="7%" 
					 	title="<%=row.getValue(1) %> <%=row.getValue(2) %>" 
					 	class = "smallFoodCategory foodCategory"/>
		<%	}
		}
		if(menuType != null && menuType != "menu") {
			%>			
			</div></td></tr>
			<tr><td>&nbsp;</td></tr>
			
			<%
		}
		else {
			%>
			</div></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr style="background-color:#C43CDF; height:80px;">
				<td align="center">
					<div style="width:90%;" align="center">
						<div class="menuBtnLoc" style="float:left; width:45%" align="center">
						</div>
						<div class="setMenuBtnLoc" style="float:right; width:45%" align="center">
						</div>
					</div>
				</td>
			</tr>
			<%
		}
	}
}
%>


<%--  original
%><%
ArrayList record = fetchMenuItem();
ReportableListObject row = null;
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
%><option value="<%=row.getValue(0) %>"><%=row.getValue(1) %> <%=row.getValue(2) %></option><%
	}
}
%>
--%>