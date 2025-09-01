<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);
String spec = request.getParameter("spec");
String docCode = request.getParameter("docCode");
String procYN = request.getParameter("procYN");
boolean editFavour = "true".equals(request.getParameter("editFavour"));
String showAll = "";

ArrayList<ReportableListObject> record = null;
ArrayList<ReportableListObject> recordAll = null;


if ((docCode != null && !"".equals(docCode)) && ("F".equals(procYN)) ) {
	record = UtilDBWeb.getReportableList(
			"(SELECT F.PROCCODE,P.PROCDESC ||DECODE(P.PROCCDESC,NULL,'',' ' ||P.PROCCDESC),DF.COMPLICATION, "+
			"(CASE WHEN P.FSHT_DOCNAME IS NOT NULL THEN 'Y' WHEN P.FSHT_DOCCNAME IS NOT NULL THEN 'Y' WHEN P.FSHT_DOCJNAME IS NOT NULL THEN 'Y' ELSE 'N' END) as hasFS "					
			+"FROM CFM_PROC@IWEB P, CFM_CODE@IWEB F, CFM_DRFAVLIST@IWEB DF WHERE F.PROCCODE=P.PROCCODE AND P.PROCCODE = DF.PROCCODE AND DF.DOCCODE = ? AND DF.ENABLED = 1 AND P.ISACTIVE  = -1)"
			+" UNION ( SELECT PROCDESC,PROCDESC,COMPLICATION,'' FROM CFM_DRFAVLIST@IWEB WHERE PROCCODE IS NULL AND DOCCODE = ?  AND ENABLED = 1) ORDER BY 2 "
					, new String[] { docCode,docCode });
} else if ((docCode != null && !"".equals(docCode)) && editFavour) {
	recordAll = UtilDBWeb.getReportableList("SELECT F.PROCCODE, P.PROCDESC,'' FROM CFM_PROC@IWEB P,CFM_CODE@IWEB F WHERE F.PROCCODE=P.PROCCODE AND P.ISACTIVE = -1 ORDER BY P.PROCDESC");
	record = UtilDBWeb.getReportableList(
			"(SELECT F.PROCCODE,P.PROCDESC ||DECODE(P.PROCCDESC,NULL,'',' ' ||P.PROCCDESC),DF.COMPLICATION, "+
			"(CASE WHEN P.FSHT_DOCNAME IS NOT NULL THEN 'Y' WHEN P.FSHT_DOCCNAME IS NOT NULL THEN 'Y' WHEN P.FSHT_DOCJNAME IS NOT NULL THEN 'Y' ELSE 'N' END) as hasFS "
					+" FROM CFM_PROC@IWEB P, CFM_CODE@IWEB F, CFM_DRFAVLIST@IWEB DF WHERE F.PROCCODE=P.PROCCODE AND P.PROCCODE = DF.PROCCODE AND DF.DOCCODE = ? AND DF.ENABLED = 1 AND P.ISACTIVE  = -1)"
			+" UNION ( SELECT PROCDESC,PROCDESC,COMPLICATION,'' FROM CFM_DRFAVLIST@IWEB WHERE PROCCODE IS NULL AND DOCCODE = ?  AND ENABLED = 1) ORDER BY 2 "
					, new String[] { docCode,docCode });
} else if (spec != null && !"".equals(spec) && ("S".equals(procYN))) {
	record = UtilDBWeb.getReportableList("SELECT F.PROCCODE, P.PROCDESC||DECODE(P.PROCCDESC,NULL,'',' '||P.PROCCDESC),'',"+
			"(CASE WHEN P.FSHT_DOCNAME IS NOT NULL THEN 'Y' WHEN P.FSHT_DOCCNAME IS NOT NULL THEN 'Y' WHEN P.FSHT_DOCJNAME IS NOT NULL THEN 'Y' ELSE 'N' END) as hasFS "
			+" FROM CFM_PROC@IWEB P,CFM_CODE@IWEB F WHERE F.PROCCODE=P.PROCCODE AND P.ISACTIVE = -1 AND P.SPECIALTY = ? ORDER BY P.PROCDESC", new String[] { spec });
} else {
	record = UtilDBWeb.getReportableList("SELECT F.PROCCODE, P.PROCDESC||DECODE(P.PROCCDESC,NULL,'',' '||P.PROCCDESC),'',"+
			"(CASE WHEN P.FSHT_DOCNAME IS NOT NULL THEN 'Y' WHEN P.FSHT_DOCCNAME IS NOT NULL THEN 'Y' WHEN P.FSHT_DOCJNAME IS NOT NULL THEN 'Y' ELSE 'N' END) as hasFS "
			+" FROM CFM_PROC@IWEB P,CFM_CODE@IWEB F WHERE F.PROCCODE=P.PROCCODE AND P.ISACTIVE = -1 ORDER BY P.PROCDESC");
}
ReportableListObject row = null;

/* if (record.size() == 0  && !editFavour) {
	record = UtilDBWeb.getReportableList("SELECT F.PROCCODE, P.PROCDESC||DECODE(P.PROCCDESC,NULL,'',' '||P.PROCCDESC),'' FROM CFM_PROC@IWEB P,CFM_CODE@IWEB F WHERE F.PROCCODE=P.PROCCODE AND P.ISACTIVE = -1 ORDER BY P.ORDERING");
	showAll = "showAll=\"true\"";
} */
if (!editFavour) {
%>
<select name="ProcedureSelectAvailable"  multiple id="select1" <%=showAll%> class="ProcedureSelect" style="width:550px; overflow-x: scroll;">
<%	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);%>
	<option value="<%=row.getValue(0) %>" comp="<%=row.getValue(2)%>">
	<%=row.getValue(1) %><%=("".equals(row.getValue(2))?"":"; (COMP:"+row.getValue(2)+")" )%><%=("Y".equals(row.getValue(3))?"*":"" )%>
	</option>
<%	}%>
</select>
<%} else if (editFavour) { %>
		<tr style="width:100%"><td colspan='4'>&nbsp;</td></tr>
		<tr>
			<td>All Procedures</td>
			<td>&nbsp;</td>
			<td>Favour List Procedures</td>
		</tr>
		<tr>
			<td>
			<span id="availProcedure_indicator">
				<select name="ProcedureSelectAvailable" class="ProcedureSelect"  multiple id="select1" style="width:550px;" >
				<%	for (int i = 0; i < recordAll.size(); i++) {
						row = (ReportableListObject) recordAll.get(i);%>
					<option value="<%=row.getValue(0) %>"><%=row.getValue(1) %></option>
				<%	}%>
				</select>
			</span>
			</td>
			<td>
			<button id="add" onclick="return addSelect();">add</button>
			<button id="remove" onclick="return removeSelect();">delete</button>
			</td>
			<td>
				<select name="ProcedureSelect1" class="ProcedureSelect" size="5" multiple id="select2">
						<%	for (int i = 0; i < record.size(); i++) {
								row = (ReportableListObject) record.get(i);%>
							<option value="<%=row.getValue(0) %>"><%=row.getValue(1) %></option>
						<%	}%>					
				</select>
			</td>
		</tr>
		<tr style="width:100%">
		<td>&nbsp;</td>
		<td colspan='2'>
			<button id="save" onclick="return submitAction('update');" >Save</button>
		</td>
		</tr>
<% } %>