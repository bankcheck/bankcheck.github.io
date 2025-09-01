<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.fop.*"%>
<%
String language = request.getAttribute("language").toString();
Locale locale = Locale.US;
if ("chi".equals(language)) {
	locale = Locale.TRADITIONAL_CHINESE;
} else if ("eng".equals(language)) {
	locale = Locale.US;
}
String patpassport = request.getAttribute("patpassport").toString();
String admissionID = request.getAttribute("admissionID").toString();
String patidno1 = request.getAttribute("patidno1").toString();
String patidno2 = request.getAttribute("patidno2").toString();
String roomType = request.getAttribute("roomType").toString();

 %>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<html>
<head>
<title>Hong Kong Adventist Hospital</title>
<link rel="stylesheet" href="../css/style.css">
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/registration/background.css" />" />
</head>
<body>
<form name="form1" action="" method="post">
<input type="hidden" name="patpassport" value="<%=patpassport %>"/>
<input type="hidden" name="admissionID" value="<%=admissionID %>"/>
<input type="hidden" name="patidno1" value="<%=patidno1 %>"/>
<input type="hidden" name="patidno2" value="<%=patidno2 %>"/>
<input type="hidden" name="roomType" value="<%=roomType %>"/>
</form>
<DIV class="wrapper" style="background-color:white;">
<jsp:include page="admission_header.jsp" flush="false">
	<jsp:param name="language" value="<%=language %>" />
</jsp:include>
<div class="normal_area">
<div class="career_form" style="padding: 20px 18px;">
<tr>
	<td colspan="4">
		<table width="800" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<table width="700" align="center" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td class="enquiryLabel extraBigText">
								<p align ="left" style="font-size:120% ; color:gray"><b><%=MessageResources.getMessage(locale, "adm.insurance.notes") %></b></p>
								<p align ="left" style="font-size:80% ; color:gray">
									<br/>
									<%=MessageResources.getMessage(locale, "adm.insurance.note.line1") %>
									<br/><br/>
									<%=MessageResources.getMessage(locale, "adm.insurance.note.line2") %>
									<br/><br/>
									<%=MessageResources.getMessage(locale, "adm.insurance.note.line3") %>
									<br/><br/>
									<%=MessageResources.getMessage(locale, "adm.insurance.note.line4") %>
									<br/><br/>
									<%=MessageResources.getMessage(locale, "adm.insurance.note.line5") %>
									<br/><br/>
									<%=MessageResources.getMessage(locale, "adm.insurance.note.line6") %>
								</p>
								<br>
							</td>
						</tr>
						<tr>
							<td height="50">&nbsp;</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class="middleText">
					<p align="left">
						<button onclick="document.form1.action='admission_client_payment.jsp?language=<%=language%>';document.form1.submit();"><%=MessageResources.getMessage(locale, "button.page.previous") %></button>
						<button onclick="javascript:window.location.href = 'online_admission_submit.jsp?language=<%=language%>&paymentType=INSURANCE&admissionID=<%=admissionID %>'"><%=MessageResources.getMessage(locale, "button.page.next") %></button>
					</p>
				</td>
			</tr>
		</table>
	</td>
</tr>
</table>
</div>
</div>
<div  class="push"></div>
 <table  width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td>&nbsp;</td>
</tr>
</table>
</DIV>
<jsp:include page="admission_footer.jsp" flush="false" />
</body>
</html>