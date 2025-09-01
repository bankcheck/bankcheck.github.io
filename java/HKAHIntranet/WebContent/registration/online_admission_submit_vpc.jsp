<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.fop.*"%>
<%
String language = request.getParameter("language");
Locale locale = Locale.US;
if ("chi".equals(language)) {
	locale = Locale.TRADITIONAL_CHINESE;
} else if ("eng".equals(language)) {
	locale = Locale.US;
}
String admissionID = request.getParameter("admissionID");
String type = request.getParameter("type");
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

<DIV class="wrapper" style="background-color:white;">
<jsp:include page="admission_header.jsp" flush="false">
	<jsp:param name="language" value="<%=language %>" />
</jsp:include>
<div class="normal_area">
<div class="career_form" style="padding: 20px 18px;">
<%if("OPD".equals(type)){ %>
<table width="1024" border="0" cellpadding="0" cellspacing="0" height="300"><tr>
	<td width="260" height="104"><div align="center">
		<table width="1024" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td style="width:600px">&nbsp;</td>			
				<td  style="font-size:120%;vertical-align:text-bottom;font-weight:bold">Ref No: OPD<%=(admissionID==null?"":admissionID) %></td>		
		</tr>
		</table>
		</div>
	</td>
</tr>
<%} %>
<tr>
	<td colspan="4">
		<table width="800" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<table width="700" align="center" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>&nbsp;</td>
					</tr>
				<%
				
				if("OPD".equals(type)){ %>
						<tr>
							<td class="enquiryLabel extraBigText">
								<p align ="left" style="font-size:80%"><%=MessageResources.getMessage(locale, "prompt.onlinereg.step2.block1")%></p>
								<br>
								<p align ="left" style="font-size:80%"><%=MessageResources.getMessage(locale, "prompt.out.onlinereg.step2.block3")%></p>
								<br>
								<p align ="left" style="font-size:80%">
									<%=MessageResources.getMessage(locale, "prompt.onlinereg.ending")%><br/>
									<%=MessageResources.getMessage(locale, "prompt.out.onlinereg.admission.office")%><br/>
									<%=MessageResources.getMessage(locale, "prompt.booking.hospital")%><br/>
									<%=MessageResources.getMessage(locale, "prompt.out.onlinereg.tel")%><br/>
									<%=MessageResources.getMessage(locale, "prompt.out.onlinereg.fax")%><br/>
									<%=MessageResources.getMessage(locale, "prompt.out.onlinereg.email")%>
								</p>
							</td>
						</tr>
						<tr>
							<td height="50">&nbsp;</td>
						</tr>
				<%
				}else{ %>
						<tr>
							<td class="enquiryLabel extraBigText">
								<p align ="left" style="font-size:80% ; color:gray"><%=MessageResources.getMessage(locale, "prompt.onlinereg.step2.block1")%></p>
								<br>
								<p align ="left" style="font-size:80% ; color:gray"><%=MessageResources.getMessage(locale, "prompt.onlinereg.step2.block2")%></p>
								<br>
								<p align ="left" style="font-size:80% ; color:gray"><%=MessageResources.getMessage(locale, "prompt.onlinereg.step2.block3")%></p>
								<br>
								<p align ="left" style="font-size:80% ; color:gray">
									<%=MessageResources.getMessage(locale, "prompt.onlinereg.ending")%><br/>
									<%=MessageResources.getMessage(locale, "prompt.onlinereg.admission.office")%><br/>
									<%=MessageResources.getMessage(locale, "prompt.onlinereg.tel")%>
								</p>
							</td>
						</tr>
						<tr>
							<td height="50">&nbsp;</td>
						</tr>
					<%
				}%>
					<tr>
						<td class="middleText">
							<p align="left">
								<button onclick="window.close();"><%=MessageResources.getMessage(locale, "button.completed")%></button>
							</p>
						</td>
					</tr>					
					</table>
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