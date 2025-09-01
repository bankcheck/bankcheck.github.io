<%@ page language="java" contentType="text/html; charset=big5"
%><%@ page import="java.util.*"
%><%@ page import="com.hkah.util.*"
%><%@ page import="com.hkah.util.db.*"
%><%@ page import="com.hkah.web.common.*"
%><%@ page import="com.hkah.web.db.*"
%><%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.*" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="org.json.simple.parser.JSONParser"%>
<%

String procedure = request.getParameter("procedure");

String fshtdocid = null;
String fshtdocname = null;
String fshtdocCName = null;
String procFinCode = null;

String[] pArray = null;





ArrayList<ReportableListObject> record = null;
JSONObject jObj = new JSONObject();

if (procedure != null) {
	pArray = procedure.split(";");
	for(int i=0; i < pArray.length; i++ ) {
		record = UtilDBWeb.getReportableList(
				"SELECT P.FSHT_DOCID,P.FSHT_DOCNAME,P.FSHT_DOCCNAME,C.FIN_CODE FROM CFM_PROC@IWEB P,CFM_CODE@IWEB C WHERE P.PROCCODE=C.PROCCODE AND P.PROCCODE= ?"
				, new String[] { pArray[i].toUpperCase() });
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
	
			fshtdocid = row.getValue(0);
			fshtdocname = row.getValue(1);
			fshtdocCName = row.getValue(2);
			procFinCode = row.getValue(3);
			JSONObject dataJSON = new JSONObject();
			dataJSON.put("url",
					"http://192.168.0.20/intranet/documentManage/download.jsp?documentID="+((fshtdocid==null||fshtdocid.length()==0)?"":fshtdocid)
							+"&fileName=/"+((fshtdocname==null||fshtdocname.length()==0)?fshtdocCName:fshtdocname));
			jObj.put(i, dataJSON);
		}
	}
}

response.setContentType("text/javascript");
PrintWriter writer = response.getWriter();
writer.print(request.getParameter("callback")+"("+jObj.toString()+ ");");
writer.close();
%>
<%-- <input type="hidden" name="fshtDocID" id="fshtDocID" value="<%=fshtdocid==null||fshtdocid.length()==0?"":fshtdocid %>" />
<input type="hidden" name="fshtDocName" id="fshtDocName" value="<%=fshtdocname==null||fshtdocname.length()==0?"":fshtdocname %>" />
<input type="hidden" name="fshtDocCName"  id="fshtDocCName" value="<%=fshtdoccname==null||fshtdoccname.length()==0?"":fshtdoccname %>" />
<input type="hidden" name="procFinCode"  id="procFinCode" value="<%=procFinCode==null||procFinCode.length()==0?"":procFinCode %>" /> --%>
