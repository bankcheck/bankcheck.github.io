<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.util.*"%>
<%
boolean isRegistration = "registration".equals(request.getParameter("source"));
String language = request.getParameter("language");
Locale locale = Locale.US;
if ("chi".equals(language)) {
	locale = Locale.TRADITIONAL_CHINESE;
} else{
	locale = Locale.US;
}
%>
<li><span class="folder"><%=MessageResources.getMessage(locale,"label.outpatient.other.information") %></span>
	<ul>
		<li><span class="file"><%=MessageResources.getMessage(locale,"label.find.doctor") %>(<a href="<%=("chi".equals(language)?"http://www.hkah.org.hk/new/chi/find_a_doctor03.php":"http://www.hkah.org.hk/new/eng/find_a_doctor03.php")%>" target="_blank" target="_blank"><%=MessageResources.getMessage(locale,"label.click.here") %></a>)</span></li>
		<li><span class="file"><%=MessageResources.getMessage(locale,"label.outpatient.service") %>(<a href="<%=("chi".equals(language)?"http://www.hkah.org.hk/new/chi/service_op.php":"http://www.hkah.org.hk/new/eng/service_op.php")%>" target="_blank"><%=MessageResources.getMessage(locale,"label.click.here") %></a>)</span></li>
		<li><span class="file"><%=MessageResources.getMessage(locale,"label.outpatient.doc.schedule") %>(<a href="<%=("chi".equals(language)?"https://mail.hkah.org.hk/online/hat/dr_schedule_all(ie).jsp":"https://mail.hkah.org.hk/online/hat/dr_schedule_all(ie).jsp")%>" target="_blank"><%=MessageResources.getMessage(locale,"label.click.here") %></a>)</span></li>
		<%--  
		<li><span class="file"><%=MessageResources.getMessage(locale,"label.patients.charter") %>(<a href="<%=("chi".equals(language)?"http://www.hkah.org.hk/new/eng/download/Patient_Charter.pdf":"http://www.hkah.org.hk/new/eng/download/Patient_Charter.pdf")%>" target="_blank"><%=MessageResources.getMessage(locale,"label.click.here") %></a>)</span></li>
		<li><span class="file"><%=MessageResources.getMessage(locale,"label.renovation.letter") %>
		--%>
		<%if ("chi".equals(language)) {%>
			<a href="javascript:void(0);" onclick="downloadFile('396');return false;" target="_blank">(<%=MessageResources.getMessage(locale,"label.chinese.version") %>)</a>		
		<%}else{ %>
			<a href="javascript:void(0);" onclick="downloadFile('395');return false;" target="_blank">(<%=MessageResources.getMessage(locale,"label.english.version") %>)</a>
		<%} %>
		</span></li>
		<li><span class="file"><%=MessageResources.getMessage(locale,"label.helpful") %>(<a href="<%=("chi".equals(language)?"http://www21.ha.org.hk/smartpatient/tc/operationstests_procedures.html":"http://www21.ha.org.hk/smartpatient/en/operationstests_procedures.html")%>" target="_blank"><%=MessageResources.getMessage(locale,"label.click.here") %></a>)</span></li>
		<li><span class="file"><%=MessageResources.getMessage(locale,"label.feerange") %>
			<a href="javascript:void(0);" onclick="downloadFile('546', '');return false;" target="_blank">(<%=MessageResources.getMessage(locale,"label.click.here") %>)</a>
		</span></li>
		<li><span class="file"><%=MessageResources.getMessage(locale,"label.insuranceProvide") %></span>
			<a href="javascript:void(0);" onclick="downloadFile('593', '');return false;" target="_blank">(<%=MessageResources.getMessage(locale,"label.click.here") %>)</a>
		</li>
		<li><span class="file"><%=MessageResources.getMessage(locale,"label.chargesPoster") %>
		<a href="http://www.hkah.org.hk/getfile/index/action/images/name/Fees_and_Charges_Informationpdf.pdf" target="_blank">(<%=MessageResources.getMessage(locale,"label.click.here") %>)</a>
		<%--
			<a href="javascript:void(0);" onclick="downloadFile('606', '');return false;" target="_blank">(<%=MessageResources.getMessage(locale,"label.click.here") %>)</a>
		 --%>
		</span></li>
	</ul>
</li>
