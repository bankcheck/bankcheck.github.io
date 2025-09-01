<%@ page language="java" contentType="text/html; charset=utf-8" %><%@
page import="java.util.*"%><%@
page import="com.hkah.servlet.*"%><%@
page import="com.hkah.util.*"%><%@
page import="com.hkah.util.db.*"%><%@
page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.constant.*"%>
<%!
	private ArrayList fetchMenuSet(boolean isTW, String filterKey) {
		// fetch fund
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT I.ITEM_CODE, I.ITEM_NAME1, I.ITEM_NAME2, I.CURRENCY, I.UNIT_PRICE ");
		sqlStr.append("FROM   DIT_MENU_ITEM I, AH_SYS_CODE C ");
		sqlStr.append("WHERE  I.FOOD_UNIT = C.CODE_NO (+) ");
		sqlStr.append("AND    I.MENU_TYPE = 'set' ");
		sqlStr.append("AND    C.SYS_ID = 'DIT' ");
		sqlStr.append("AND    C.CODE_TYPE = 'FOOD_UNIT' ");
		//sqlStr.append("AND   (TO_DATE('18/07/2012', 'DD/MM/YYYY') BETWEEN I.EFFECTIVE_DATE AND NVL(EXPIRED_DATE, TO_DATE('18/07/2012', 'DD/MM/YYYY')) ) ");
		sqlStr.append("AND   (SYSDATE BETWEEN I.EFFECTIVE_DATE AND NVL(EXPIRED_DATE, SYSDATE) ) ");
		if(isTW) {
			if(filterKey != null && filterKey.length() > 0) {
				if(filterKey.equals("0")) {
					sqlStr.append("AND    ITEM_NAME1 like '%Sunday%' ");
				}
				else if(filterKey.equals("1")) {
					sqlStr.append("AND    ITEM_NAME1 like '%Monday%' ");
				}
				else if(filterKey.equals("2")) {
					sqlStr.append("AND    ITEM_NAME1 like '%Tuesday%' ");
				}
				else if(filterKey.equals("3")) {
					sqlStr.append("AND    ITEM_NAME1 like '%Wednesday%' ");
				}
				else if(filterKey.equals("4")) {
					sqlStr.append("AND    ITEM_NAME1 like '%Thursday%' ");
				}
				else if(filterKey.equals("5")) {
					sqlStr.append("AND    ITEM_NAME1 like '%Friday%' ");
				}
				else if(filterKey.equals("6")) {
					sqlStr.append("AND    ITEM_NAME1 like '%Saturday%' ");
				}
				else {
					sqlStr.append("AND    ITEM_NAME1 not like '%Sunday%' ");
					sqlStr.append("AND    ITEM_NAME1 not like '%Monday%' ");
					sqlStr.append("AND    ITEM_NAME1 not like '%Tuesday%' ");
					sqlStr.append("AND    ITEM_NAME1 not like '%Wednesday%' ");
					sqlStr.append("AND    ITEM_NAME1 not like '%Thursday%' ");
					sqlStr.append("AND    ITEM_NAME1 not like '%Friday%' ");
					sqlStr.append("AND    ITEM_NAME1 not like '%Saturday%' ");
				}
			}
		}
		sqlStr.append("ORDER BY ITEM_CODE");
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableListFSD(sqlStr.toString());
	}
%><%
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

ArrayList record = fetchMenuSet(isTW, filterKey);
ReportableListObject row = null;
if (record.size() > 0) {
	if(isTW) {
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			%><option value="<%=row.getValue(0)%>"
				currency="<%=row.getValue(3)%>"
				unitPrice="<%=row.getValue(4)%>"><%=row.getValue(0)%>. <%=row.getValue(1)%> <%=row.getValue(2)%> <%=row.getValue(3)%> <%=row.getValue(4)%></option><%
		}
	}
	else {
		if(menuType != null && menuType != "set") {
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
					<label class="text"><%=row.getValue(1) %> <%=row.getValue(2) %></label><br/>
						<img style="cursor: pointer" src="../images/food.jpg" 
							class = "foodSet" 
						 	id="<%=row.getValue(0) %>" 
						 	title="<%=row.getValue(1) %> <%=row.getValue(2) %>" 
						 	/><br/>
					<label class="text"><%=row.getValue(3) %> <%=row.getValue(4) %></label>
				</div>
		<%		if(i%2 == 1) {
		%>			
		</div></td></tr>
		<tr><td>&nbsp;</td></tr>
		<%		}
			}else {
		%>		
				<div style='display:none;' class="text"><%=row.getValue(1) %> <%=row.getValue(2) %></div><label></label>
					<img style="cursor: pointer" src="../images/food.jpg" 
					 	id="<%=row.getValue(0) %>" width="4%" 
					 	title="<%=row.getValue(1) %> <%=row.getValue(2) %>" 
					 	class = "smallFoodSet foodSet"/>
		<%	}
		}
		if(menuType != null && menuType != "set") {
			%>			
			</div></td></tr>
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
			<%
		}else {
			%>			
			</div></td></tr>
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
			<%
		}
	}
}
%>

<%--
%><option value="<%=row.getValue(0) %>"><%=row.getValue(1) %> <%=row.getValue(2) %> <%=row.getValue(3) %> <%=row.getValue(4) %></option><%
--%>