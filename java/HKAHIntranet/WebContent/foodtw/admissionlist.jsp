<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>

<%!
	private ArrayList getAdmissionList() {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT W.WRDNAME, M.ROMCODE, I.BEDCODE, R.PATNO, TO_CHAR(R.REGDATE, 'DD/MM/YYYY HH24:MI:SS'), ");
		sqlStr.append("TO_CHAR(I.INPDDATE, 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("FROM REG@IWEB R, INPAT@IWEB I, BED@IWEB B, ROOM@IWEB M, WARD@IWEB W ");
		sqlStr.append("WHERE R.REGTYPE = 'I' ");
		sqlStr.append("AND I.INPID = R.INPID ");
		sqlStr.append("AND M.WRDCODE = W.WRDCODE ");
		sqlStr.append("AND B.ROMCODE = M.ROMCODE ");
		sqlStr.append("AND I.BEDCODE = B.BEDCODE ");
		sqlStr.append("AND B.ROMCODE <> 'NUR' ");
		sqlStr.append("AND R.REGSTS <> 'C' ");
		sqlStr.append("AND (I.INPDDATE IS NULL ");
		sqlStr.append("	OR I.INPDDATE >= TO_DATE(TO_CHAR(SYSDATE, 'DD/MM/YYYY')||' 00:00:00', 'DD/MM/YYYY HH24:MI:SS')) ");
		sqlStr.append("ORDER BY W.WRDNAME, M.ROMCODE, I.BEDCODE ");
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
%>

<%
request.setAttribute("adList", getAdmissionList());
%>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>

<html:html xhtml="true" lang="true">
	<jsp:include page="../common/header.jsp">
		<jsp:param name="nocache" value="N" />
	</jsp:include>
	<body>	
		<DIV id=indexWrapper>
			<DIV id=mainFrame>
				<DIV id=contentFrame>
					<display:table id="row" name="requestScope.adList" export="false" pagesize="200" class="tablesorter" sort="list">
						<display:column title="Ward Name" style="width:5%">
							<c:out value="${row.fields0}" />
						</display:column>
						<display:column title="Room Code" style="width:5%">
							<c:out value="${row.fields1}" />
						</display:column>
						<display:column title="Bed Code" style="width:5%">
							<c:out value="${row.fields2}" />
						</display:column>
						<display:column title="Patient No" style="width:5%">
							<c:out value="${row.fields3}" />
						</display:column>
						<display:column title="Admission Date" style="width:5%">
							<c:out value="${row.fields4}" />
						</display:column>
						<display:column title="Discharge Date" style="width:5%">
							<c:out value="${row.fields5}" />
						</display:column>
					</display:table>
				</DIV>
			</DIV>
		</DIV>
	</body>
</html:html>

<script type="text/javascript">
$(document).ready(function() {
	$('th').unbind('click');
});
</script>