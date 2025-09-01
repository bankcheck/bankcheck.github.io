<%@ page language="java" contentType="text/html; charset=big5"
%><%@ page import="java.util.*"
%><%@ page import="com.hkah.util.*"
%><%@ page import="com.hkah.util.db.*"
%><%@ page import="com.hkah.web.common.*"
%><%@ page import="com.hkah.web.db.*"%><%
String doccode = request.getParameter("doccode");
String procedure = request.getParameter("procedure");
String day = request.getParameter("day");
String acmcode = request.getParameter("acmcode");

String OTMinP = null;
String OTMaxP = null;
String OtherFeeMinP = null;
String OtherFeeMaxP = null;
String OTMinQ = null;
String OTMaxQ = null;
String OtherFeeMinQ = null;
String OtherFeeMaxQ = null;
String RMMinS = null;
String RMMaxS = null;
String OTMinS = null;
String OTMaxS = null;
String OtherFeeMinS = null;
String OtherFeeMaxS = null;
String RMMinT = null;
String RMMaxT = null;
String OTMinT = null;
String OTMaxT = null;
String OtherFeeMinT = null;
String OtherFeeMaxT = null;

String DocMinS = null;
String DocMaxS = null;
String SurgicalMinS = null;
String SurgicalMaxS = null;
String AnaesthetistMinS = null;
String AnaesthetistMaxS = null;
String OtherMin1S = null;
String OtherMax1S = null;
String OtherMin2S = null;
String OtherMax2S = null;

ArrayList<ReportableListObject> record = null;

if (procedure != null && day != null && acmcode != null) {
	record = UtilDBWeb.getFunctionResultsHATS("NHS_GET_PROCFEE", new String[] { null, procedure, day, acmcode });
	if (record.size() > 0) {
		ReportableListObject row = (ReportableListObject) record.get(0);

		OTMinP = row.getValue(16);
		OTMaxP = row.getValue(17);
		OtherFeeMinP = row.getValue(20);
		OtherFeeMaxP = row.getValue(21);
		RMMinS = row.getValue(28);
		RMMaxS = row.getValue(29);
		OTMinS = row.getValue(30);
		OTMaxS = row.getValue(31);
		OtherFeeMinS = row.getValue(32);
		OtherFeeMaxS = row.getValue(33);
		RMMinT = row.getValue(34);
		RMMaxT = row.getValue(35);
		OTMinT = row.getValue(36);
		OTMaxT = row.getValue(37);
		OtherFeeMinT = row.getValue(38);
		OtherFeeMaxT = row.getValue(39);

		DocMinS = row.getValue(40);
		DocMaxS = row.getValue(41);
		SurgicalMinS = row.getValue(42);
		SurgicalMaxS = row.getValue(43);
		AnaesthetistMinS = row.getValue(44);
		AnaesthetistMaxS = row.getValue(45);
		OtherMin1S = row.getValue(46);
		OtherMax1S = row.getValue(47);
		OtherMin2S = row.getValue(48);
		OtherMax2S = row.getValue(49);
	}

	OTMinQ = null;
	OTMaxQ = null;
	OtherFeeMinQ = null;
	OtherFeeMaxQ = null;
	if (doccode != null && doccode.length() > 0) {
		record = UtilDBWeb.getFunctionResultsHATS("NHS_GET_PROCFEE", new String[] { doccode, procedure, day, acmcode });
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);

			OTMinQ = row.getValue(16);
			OTMaxQ = row.getValue(17);
			OtherFeeMinQ = row.getValue(20);
			OtherFeeMaxQ = row.getValue(21);

			DocMinS = row.getValue(40);
			DocMaxS = row.getValue(41);
			SurgicalMinS = row.getValue(42);
			SurgicalMaxS = row.getValue(43);
			AnaesthetistMinS = row.getValue(44);
			AnaesthetistMaxS = row.getValue(45);
			OtherMin1S = row.getValue(46);
			OtherMax1S = row.getValue(47);
			OtherMin2S = row.getValue(48);
			OtherMax2S = row.getValue(49);
		}
	}
}

%><%=record != null && record.size() > 0 ? record.size() : 0 %>
<input type="hidden" name="hats_OTMinP" value="<%=OTMinP==null||OTMinP.length()==0?"--":OTMinP %>" />
<input type="hidden" name="hats_OTMaxP" value="<%=OTMaxP==null||OTMaxP.length()==0?"--":OTMaxP %>" />
<input type="hidden" name="hats_OtherMin3P" value="<%=OtherFeeMinP==null||OtherFeeMinP.length()==0?"--":OtherFeeMinP %>" />
<input type="hidden" name="hats_OtherMax3P" value="<%=OtherFeeMaxP==null||OtherFeeMaxP.length()==0?"--":OtherFeeMaxP %>" />
<input type="hidden" name="hats_OTMinQ" value="<%=OTMinQ==null||OTMinQ.length()==0?"--":OTMinQ %>" />
<input type="hidden" name="hats_OTMaxQ" value="<%=OTMaxQ==null||OTMaxQ.length()==0?"--":OTMaxQ %>" />
<input type="hidden" name="hats_OtherMin3Q" value="<%=OtherFeeMinQ==null||OtherFeeMinQ.length()==0?"--":OtherFeeMinQ %>" />
<input type="hidden" name="hats_OtherMax3Q" value="<%=OtherFeeMaxQ==null||OtherFeeMaxQ.length()==0?"--":OtherFeeMaxQ %>" />
<input type="hidden" name="hats_RMMinS" value="<%=RMMinS==null||RMMinS.length()==0?"--":RMMinS %>" />
<input type="hidden" name="hats_RMMaxS" value="<%=RMMaxS==null||RMMaxS.length()==0?"--":RMMaxS %>" />
<input type="hidden" name="hats_OTMinS" value="<%=OTMinS==null||OTMinS.length()==0?"--":OTMinS %>" />
<input type="hidden" name="hats_OTMaxS" value="<%=OTMaxS==null||OTMaxS.length()==0?"--":OTMaxS %>" />
<input type="hidden" name="hats_OtherMin3S" value="<%=OtherFeeMinS==null||OtherFeeMinS.length()==0?"--":OtherFeeMinS %>" />
<input type="hidden" name="hats_OtherMax3S" value="<%=OtherFeeMaxS==null||OtherFeeMaxS.length()==0?"--":OtherFeeMaxS %>" />
<input type="hidden" name="hats_RMMinT" value="<%=RMMinT==null||RMMinT.length()==0?"--":RMMinT %>" />
<input type="hidden" name="hats_RMMaxT" value="<%=RMMaxT==null||RMMaxT.length()==0?"--":RMMaxT %>" />
<input type="hidden" name="hats_OTMinT" value="<%=OTMinT==null||OTMinT.length()==0?"--":OTMinT %>" />
<input type="hidden" name="hats_OTMaxT" value="<%=OTMaxT==null||OTMaxT.length()==0?"--":OTMaxT %>" />
<input type="hidden" name="hats_OtherMin3T" value="<%=OtherFeeMinT==null||OtherFeeMinT.length()==0?"--":OtherFeeMinT %>" />
<input type="hidden" name="hats_OtherMax3T" value="<%=OtherFeeMaxT==null||OtherFeeMaxT.length()==0?"--":OtherFeeMaxT %>" />
<input type="hidden" name="hats_DocMinS" value="<%=DocMinS==null||DocMinS.length()==0?"--":DocMinS %>" />
<input type="hidden" name="hats_DocMaxS" value="<%=DocMaxS==null||DocMaxS.length()==0?"--":DocMaxS %>" />
<input type="hidden" name="hats_SurgicalMinS" value="<%=SurgicalMinS==null||SurgicalMinS.length()==0?"--":SurgicalMinS %>" />
<input type="hidden" name="hats_SurgicalMaxS" value="<%=SurgicalMaxS==null||SurgicalMaxS.length()==0?"--":SurgicalMaxS %>" />
<input type="hidden" name="hats_AnaesthetistMinS" value="<%=AnaesthetistMinS==null||AnaesthetistMinS.length()==0?"--":AnaesthetistMinS %>" />
<input type="hidden" name="hats_AnaesthetistMaxS" value="<%=AnaesthetistMaxS==null||AnaesthetistMaxS.length()==0?"--":AnaesthetistMaxS %>" />
<input type="hidden" name="hats_OtherMin1S" value="<%=OtherMin1S==null||OtherMin1S.length()==0?"--":OtherMin1S %>" />
<input type="hidden" name="hats_OtherMax1S" value="<%=OtherMax1S==null||OtherMax1S.length()==0?"--":OtherMax1S %>" />
<input type="hidden" name="hats_OtherMin2S" value="<%=OtherMin2S==null||OtherMin2S.length()==0?"--":OtherMin2S %>" />
<input type="hidden" name="hats_OtherMax2S" value="<%=OtherMax2S==null||OtherMax2S.length()==0?"--":OtherMax2S %>" />