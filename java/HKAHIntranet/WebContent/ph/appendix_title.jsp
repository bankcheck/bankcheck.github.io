<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>


<%
ReportableListObject row = DocumentDB.getReportableListObject("629");
String location = null;
String filePath = null;
if (row != null) {
	location = row.getValue(2);
	if (ConstantsVariable.YES_VALUE.equals(row.getValue(3))) {
		filePath = ConstantsServerSide.DOCUMENT_FOLDER + File.separator + location;
	} else {
		filePath = location;
	}	
	
}
String removePdfCache = Long.toString((new Date()).getTime());
%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<style>
.likeabutton {
    text-decoration: none !important;
    display: inline-block; padding: 2px 8px;
    background: ButtonFace; color: ButtonText;
    border-style: solid; border-width: 2px;
    border-color: ButtonHighlight ButtonShadow ButtonShadow ButtonHighlight;
}
.likeabutton:active {
    border-color: ButtonShadow ButtonHighlight ButtonHighlight ButtonShadow;
}
</style>
<style></style>
<body>
<br/>
<br/>
<!-- \\hkim\im\Intranet\Library\General\phoneDir\content.doc-->
<a class='likeabutton' target="frame_details" href="../ph/openAppendix.jsp?fileIndex=1">Drug Information Tables</a>
<br/>
<br/>
<a class='likeabutton' target="frame_details" href="../ph/openAppendix.jsp?fileIndex=2">Equivalent Dosages Of Drugs In A Class</a>
<br/>
<br/>
<a class='likeabutton' target="frame_details" href="../ph/openAppendix.jsp?fileIndex=3">Prescribing Information For Specific Population</a>
<br/>
<br/>
<a class='likeabutton' target="frame_details" href="../ph/openAppendix.jsp?fileIndex=4">Therapeutic Drug Levels</a>
<br/>
<br/>
<a class='likeabutton' target="frame_details" href="../ph/openAppendix.jsp?fileIndex=5">Side Effects Of Drugs</a>
<br/>
<br/>
<a class='likeabutton' target="frame_details" href="../ph/openAppendix.jsp?fileIndex=6">Drug/Food Ineterations</a>
<br/>
<br/>
<a class='likeabutton' target="frame_details" href="../ph/openAppendix.jsp?fileIndex=7">Calculations</a>
<br/>
<br/>
<a class='likeabutton' target="frame_details" href="../ph/openAppendix.jsp?fileIndex=8">Approximate Conversions And Units</a>
<br/>
<br/>
<a class='likeabutton' target="frame_details" href="../ph/openAppendix.jsp?fileIndex=9">Update Childhood Vaccination Schedule(2014)</a>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>

</html:html>