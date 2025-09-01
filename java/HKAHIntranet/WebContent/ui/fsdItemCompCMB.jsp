<%@ page language="java" contentType="text/html; charset=utf-8" %><%@
page import="java.util.*"%><%@
page import="com.hkah.servlet.*"%><%@
page import="com.hkah.util.*"%><%@
page import="com.hkah.util.db.*"%><%@
page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.constant.*"%>

<%!
	private ArrayList fetchItemComp(String itemCode, boolean isMenu, boolean isTW) {
		// fetch fund
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT COMP_CODE, COMP_NAME1, COMP_NAME2, OPT_CNT ");
		sqlStr.append("FROM   DIT_ITEM_COMP ");
		sqlStr.append("WHERE  (ITEM_CODE = '");
		sqlStr.append(itemCode);
		sqlStr.append("' ");
		if(isTW) {
			sqlStr.append(") ");
		}
		else {
			sqlStr.append("AND REMARKS is null) ");
		}
		if(hasModifier(itemCode) || (isTW && isMenu))
			sqlStr.append("OR ITEM_CODE='*'");
		sqlStr.append(" ORDER BY SEQ_NO");

		return UtilDBWeb.getReportableListFSD(sqlStr.toString());
	}

	private boolean hasModifier(String itemCode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("Select COMP_CODE ");
		sqlStr.append("FROM DIT_ITEM_OPT ");
		sqlStr.append("WHERE COMP_CODE = 'Modifier' AND  ");
		sqlStr.append("AVAILABLITY like '%"+itemCode+"|%' ");
		
		ArrayList record = UtilDBWeb.getReportableListFSD(sqlStr.toString());
		
		return (record.size() > 0);
	}

	private String fetchNoOfOptions(String compCode) {
		// fetch fund
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT OPT_CNT ");
		sqlStr.append("FROM   DIT_ITEM_COMP ");
		sqlStr.append("WHERE  COMP_CODE = '");
		sqlStr.append(compCode);
		sqlStr.append("' ");
		sqlStr.append("ORDER BY SEQ_NO");
	
		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableListFSD(sqlStr.toString());
		ReportableListObject row = null;
		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			return row.getValue(0);
		} else {
			return "0";
		}
	}
%><%
boolean isMenu = !"set".equals(request.getParameter("menuType"));
String itemCode = request.getParameter("itemCode");
String compCode = request.getParameter("compCode");
String format = request.getParameter("format");
boolean isLCB = "true".equals(request.getParameter("isLCB"));
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

ArrayList record = fetchItemComp(itemCode, isMenu, isTW);
ReportableListObject row = null;
String options = "";
String maxChoice = "";
if (record.size() > 0) {
	if(isTW) {
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			options = "[Max. " + (row.getValue(3).equals("")?"All":row.getValue(3)) + " Option(s)]";
			maxChoice = row.getValue(3);
			if(format != null && format.length() > 0) {
				if(format.equals("radio")) {
					%><input type="radio" style="width:40px; height:40px" name="setCompItem" value="<%=row.getValue(0)%>" index="<%=i%>"/><%=row.getValue(1)%> <%=row.getValue(2)%> <%=options %><br/><%
				}
			} else {
				if (!isLCB || (isLCB && !"ChangeMenu".equals(row.getValue(0)))) {
					%><option class="selectItemComp" value="<%=row.getValue(0)%>" maxchoice="<%=maxChoice%>" index="<%=i%>"><%=row.getValue(1)%> <%=row.getValue(2)%> <%=options %></option><%
				}
			}
		}
	}
	else {
		int i = 0;
		for (i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			if (isMenu) {
				options = "[Max. " + (row.getValue(3).equals("0")?"All":row.getValue(3)) + " Option(s)]";
	%><button style="font-size:15px" maxchoice="<%=row.getValue(3).equals("0")?99:row.getValue(3) %>" id="<%=row.getValue(0) %>" class = 'empty selectItemComp ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'">
		<label class="text"><%=row.getValue(1) %> <%=row.getValue(2) %><%=options %></label>
		<img id="<%=row.getValue(0) %>_image" src="../images/tick_green_small.gif" style="display:none"/>
	  </button><br/><%
			}
			else {
	%><button index="<%=i %>" maxchoice="<%=row.getValue(3).equals("0")?99:row.getValue(3) %>" id="<%=row.getValue(0) %>" class = 'setCategory ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'>
		<label class="text"><%=row.getValue(1) %><br/><br/><%=row.getValue(2) %></label> <img id="<%=row.getValue(0) %>_image" src="../images/tick_green_small.gif" style="display:none"/>
	  </button> 
	<%
			}
		}
		if(isTW && isMenu) {
			%><button style="font-size:15px" maxchoice="99" id="customRemark" class = 'empty selectItemComp ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'">
				<label class="text">Remark</label>
			  </button><br/>
			<%
				}
	}
}
%>
