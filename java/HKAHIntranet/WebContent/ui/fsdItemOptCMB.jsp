<%@ page language="java" contentType="text/html; charset=utf-8" %><%@
page import="java.util.*"%><%@
page import="com.hkah.servlet.*"%><%@
page import="com.hkah.util.*"%><%@
page import="com.hkah.util.db.*"%><%@
page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.constant.*"%>

<%!
	private ArrayList<ReportableListObject> fetchItemOpt(String compCode, String itemCode, boolean isTW) {
		// fetch fund
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT OPT_CODE, OPT_NAME1, OPT_NAME2, APPLICABLE, PRICE_WITHIN, PRICE_PLUS ");
		sqlStr.append("FROM   DIT_ITEM_OPT ");
		sqlStr.append("WHERE  COMP_CODE = '");
		sqlStr.append(compCode);
		sqlStr.append("' ");
		sqlStr.append("AND    AVAILABLITY <> 'none' "); 
		if(compCode.equals("Modifier") && !isTW) {
			sqlStr.append("AND AVAILABLITY like '%"+itemCode+"|%' ");
		}
		sqlStr.append("ORDER BY OPT_CODE");

		return UtilDBWeb.getReportableListFSD(sqlStr.toString());
	}
%><%
String menuType = request.getParameter("menuType");
String compCode = request.getParameter("compCode");
String itemCode = request.getParameter("itemCode");
boolean isTW = ConstantsServerSide.isTWAH();
UserBean userBean = new UserBean(request);
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

if(compCode.equals("customRemark")) {
	%><label class='text'>Remark:&nbsp;</label><br/><%
	%><textarea cols="30" rows="3" style="font-size:22px;" id="orderRemark"></textarea><%
}
else {
	ArrayList<ReportableListObject> record = fetchItemOpt(compCode, itemCode, isTW);
	ReportableListObject row = null;
	if (record.size() > 0) {
		if(isTW) {
			%><table style="width:100%"><%
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				
				if(i%3 == 0) {
				%>
					<tr style="height:60px;">
						<td style="width:35%;valign:top;">
				<%
				}
				else {
					if(i%3 == 1) {
				%>
					<td style="width:36%;valign:top;">
				<%
					}
					else {
				%>
					<td style="width:29%;valign:top;">
				<%		
					}
				}
				%>
				<div style="float:left"><input type="checkbox" style="width:40px; 
						height:40px" class="foodOpt" name="OptCode" value="<%=compCode %>@<%=row.getValue(0) %>"<%=row.getValue(0).equals(compCode)?" selected":"" %> 
						priceIn="<%=row.getValue(4)%>" pricePlus="<%=row.getValue(5)%>">
				</div>&nbsp;
					<label class="text">
						<%=row.getValue(1) %>&nbsp;
						<%=row.getValue(2) %>&nbsp;
						<%=(row.getValue(3).length() > 0)?"<span style='color:purple'>["+row.getValue(3)+"]</span>":"" %>
						[<%=row.getValue(4) %>|<%=row.getValue(5) %>]
					</label><br/>
					<%
				if(i%3 == 2) {
					%>
							</td>
						</tr>
					<%
				}
				else {
				%>
					</td>
				<%
				}
			}
			%></table><%
		}
		else {
		%><label class='text'>Options:&nbsp;</label><br/><%
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
		%><input type="checkbox" style="width:40px; 
				height:40px" class="foodOpt" name="OptCode" value="<%=compCode %>@<%=row.getValue(0) %>"<%=row.getValue(0).equals(compCode)?" selected":"" %>>
			<label class="text">
				<%=row.getValue(1) %>&nbsp;
				<%=row.getValue(2) %>&nbsp;
				<%=(row.getValue(3).length() > 0)?"<span style='color:purple'>["+row.getValue(3)+"]</span>":"" %>&nbsp;
			</label><br/><%
			}
		}
	}
}
%>