<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.servlet.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.mail.UtilMail"%>
<%@ page import="com.hkah.web.common.*"%>

<%!
	private boolean isOrdered(String patNo, String rows) {
		//String date = getRegDate(patNo);
	
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM (SELECT ORDER_NO, STATUS, SERVE_DATE, SERVE_TIME, SLPAMT, ");
		sqlStr.append("CREATE_USER, UPDATE_USER, TO_CHAR(CREATE_DATE, 'DD/MM/YYYY HH24:MI') ");
		sqlStr.append("FROM DIT_ORDER_HDR ");
		sqlStr.append("WHERE PATNO = '"+patNo+"' ");
		sqlStr.append("AND CREATE_DATE >= (SYSDATE - 2/24) ");
		sqlStr.append("AND CREATE_DATE <= SYSDATE ");
		//sqlStr.append("AND (STATUS <> 'X' AND UPDATE_USER <> 'WEB') ");
		//if(date != null) {
		//	sqlStr.append("AND CREATE_DATE >= TO_DATE('"+date+"', 'DD/MM/YYYY HH24:MI:SS') ");
		//}
		sqlStr.append("ORDER BY ORDER_NO DESC) ");
		sqlStr.append("WHERE rownum <= "+rows+" ");
		
		//System.out.println(sqlStr.toString());
		
		return UtilDBWeb.isExistFSD(sqlStr.toString());
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

String patno = request.getParameter("patNo");

if(patno == null || patno.length() <= 0) {
	patno = userBean.getLoginID();
}

%>

<%=isOrdered(patno, "100") %>
