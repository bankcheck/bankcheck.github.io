<%@ page language="java" contentType="text/html; charset=utf-8" %><%@
page import="java.util.*"%><%@
page import="com.hkah.servlet.*"%><%@
page import="com.hkah.util.*"%><%@
page import="com.hkah.util.db.*"%><%@
page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.constant.*"%>
<%!
	private ArrayList<ReportableListObject> fetchSetItem(String compCode) {
		// fetch fund
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT I.ITEM_CODE, I.ITEM_NAME1, I.ITEM_NAME2, '', '', '', I.APPLICABLE, I.CURRENCY, I.UNIT_PRICE*-1, I.MENU_TYPE ");
		sqlStr.append("FROM   DIT_MENU_ITEM I, AH_SYS_CODE C ");
		sqlStr.append("WHERE  I.FOOD_UNIT = C.CODE_NO ");
		sqlStr.append("AND    C.SYS_ID = 'DIT' ");
		sqlStr.append("AND    C.CODE_TYPE = 'FOOD_UNIT' ");
		//sqlStr.append("AND   (TO_DATE('18/07/2012', 'DD/MM/YYYY') BETWEEN EFFECTIVE_DATE AND NVL(EXPIRED_DATE, TO_DATE('18/07/2012', 'DD/MM/YYYY')) ) ");
		sqlStr.append("AND   (SYSDATE BETWEEN I.EFFECTIVE_DATE AND NVL(I.EXPIRED_DATE, SYSDATE) ) "); 
		sqlStr.append("AND    I.ITEM_CODE IN (SELECT OPT_CODE FROM DIT_ITEM_OPT WHERE COMP_CODE = '");
		sqlStr.append(compCode);
		sqlStr.append("') ");
		sqlStr.append("ORDER BY ITEM_CODE");

		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableListFSD(sqlStr.toString());
	}

	private ArrayList fetchMenuItem(String menuType) {
		// fetch fund
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ITEM_CODE, ITEM_NAME1, ITEM_NAME2, CURRENCY, UNIT_PRICE, KITCHEN, APPLICABLE, '', '', '' ");
		sqlStr.append("FROM   DIT_MENU_ITEM ");
		sqlStr.append("WHERE  MENU_TYPE = '");
		sqlStr.append(menuType);
		sqlStr.append("' ");
		//sqlStr.append("AND   (TO_DATE('18/07/2012', 'DD/MM/YYYY') BETWEEN EFFECTIVE_DATE AND NVL(EXPIRED_DATE, TO_DATE('18/07/2012', 'DD/MM/YYYY')) ) ");
		sqlStr.append("AND   (SYSDATE BETWEEN EFFECTIVE_DATE AND NVL(EXPIRED_DATE, SYSDATE) ) "); 
		sqlStr.append("ORDER BY ITEM_CODE");
		
		return UtilDBWeb.getReportableListFSD(sqlStr.toString());
	}
	
	private String fetchMenuName(String menuType) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CODE_VALUE1, CODE_VALUE2 ");
		sqlStr.append("FROM   AH_SYS_CODE ");
		sqlStr.append("WHERE  SYS_ID = 'DIT' ");
		sqlStr.append("AND    CODE_TYPE = 'MENU_TYPE' ");
		sqlStr.append("AND    STATUS <> 'X' ");
		sqlStr.append("AND    CODE_NO = '"+menuType+"' ");
		sqlStr.append("ORDER BY CODE_VALUE1");
		
		ArrayList record = UtilDBWeb.getReportableListFSD(sqlStr.toString());
		
		if (record.size() > 0) {
			ReportableListObject row = null;
			row = (ReportableListObject) record.get(0);
			return row.getValue(0) + " " + row.getValue(1) + ((row.getValue(0).indexOf("U.") > -1)?"<span style='color:red'>(Additional 額外需要)</span>":"");
		}
		return "";
	}
%><%
String compCode = request.getParameter("compCode");
String menuType = request.getParameter("menuType");
String title = request.getParameter("title");
String format = request.getParameter("format");
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

ArrayList record = null;
if ("set".equals(menuType)) {
	record = fetchSetItem(compCode);
} else {
	record = fetchMenuItem(menuType);
}
ReportableListObject row = null;
if (record.size() > 0) {
	if(isTW) {
		if(format != null && format.length() > 0) {
			if(format.equals("radio")) {
				%><table><%
			}
		}
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			if(format != null && format.length() > 0) {
				if(format.equals("radio")) {
					if(i%2==0) {
						%><tr><%
					}
					%><td><input type="radio" style="width:40px; height:40px" 
						name="setOrderMenuItem" value="<%=row.getValue(0)%>" 
						index="<%=i%>"/>
						<%=row.getValue(1)%> <%=row.getValue(2)%> <%=row.getValue(3)%> <%=row.getValue(4)%> 
						<%=row.getValue(9).equals("setonly")?(row.getValue(8).length()>0?("<label class='extraCurr'>"+row.getValue(7)+"</label> <label class='extraPrice'>"+row.getValue(8)+"</label>"):""):""%> </td>
						<%
					if(i%2==1) {
						%></tr><%
					}
				}
			}
			else {
				%><option value="<%=row.getValue(0)%>" 
					kitchen="<%=row.getValue(5)%>" 
					currency="<%=row.getValue(3)%>"
					unitPrice="<%=row.getValue(4)%>" 
					index="<%=i%>" extraCurr="<%=row.getValue(9).equals("setonly")?row.getValue(7):""%>" extraPrice="<%=row.getValue(9).equals("setonly")?row.getValue(8):""%>">
					<%=row.getValue(1)%> <%=row.getValue(2)%> <%=row.getValue(3)%> <%=row.getValue(4)%>
					</option><%
			}
		}
		if(format != null && format.length() > 0) {
			if(format.equals("radio")) {
				%></table><%
			}
		}
	}
	else {
		if(compCode == null || compCode.equals("undefined")) {
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
			<jsp:include page="../ui/fsdMenuCategoryCMB.jsp" flush="false" />
			<tr><td align="center"><label><%=fetchMenuName(menuType) %></label></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td>&nbsp;</td></tr>
		<%
		}
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			if(true/*compCode == null || compCode.equals("undefined")*/) {
				if(i%2 == 0) {
		%>	
		<tr><td align="center">
			<div style="width:70%" align="center">
				<div style="float:left; width:35%" align="center">
		<%		} else {
		%>		<div style="float:right; width:35%" align="center">
		<%		}
		%>		
					<label class="text"><%=row.getValue(1) %> <%=row.getValue(2) %> <%=(row.getValue(6).length() > 0)?"<span style='color:purple'>["+row.getValue(6)+"]</span>":"" %></label><br/>
					<img id = "<%=row.getValue(0) %>" class="foodItem" style="cursor:pointer" src="../images/food.jpg"/><br/>
					<%--  <input type="hidden" value="<%=row.getValue(0) %>"/> --%>
					<label id="currency" class="text"><%=row.getValue(3) %></label>
					<label id="unitPrice" class="text"><%=row.getValue(4) %></label>
					<div id="kitchen" style="display:none"><%=row.getValue(5) %></div>
				</div>
			
		<%		if(i%2 ==
			1) {
		%>			
		</div></td></tr>
		<tr><td>&nbsp;</td></tr>
		<%		}
			}else {
				%><option value="<%=row.getValue(0) %>"><%=row.getValue(1) %> <%=row.getValue(2) %> <%=row.getValue(3) %><%=row.getValue(4) %></option><%
			}
		}
		
		if(compCode == null || compCode.equals("undefined")) {
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
			<%
		}
	}
}
%>


<%--  original
ArrayList record = null;
if ("set".equals(menuType)) {
	record = fetchSetItem(compCode);
} else {
	record = fetchMenuItem(menuType);
}
ReportableListObject row = null;
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
%><option value="<%=row.getValue(0) %>"><%=row.getValue(1) %> <%=row.getValue(2) %> <%=row.getValue(3) %><%=row.getValue(4) %></option><%
	}
}
%>
--%>