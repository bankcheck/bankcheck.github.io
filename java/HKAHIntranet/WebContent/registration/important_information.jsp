<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.util.*"%>
<%
/*********************************************************************
20180910 Arran edit to read important information from resource

message									doc_id(chinese)		value
===================================================================
label.patient.admission					111					76		
label.patients.charter					112					390
label.why.vegetarian.diet				113					391
label.renovation.letter					118					118
label.health.care.advisory				114(115)			75
label.daily.room.rate					116(620)			392
label.pre-anaesthesia.questionnaire		117					394

**********************************************************************/
boolean isRegistration = "registration".equals(request.getParameter("source"));
String language = request.getParameter("language");
Locale locale = Locale.US;
if ("chi".equals(language)) {
	locale = Locale.TRADITIONAL_CHINESE;
} else{
	locale = Locale.US;
}
%>
<li><span class="folder"><%=MessageResources.getMessage(locale,"label.important.information") %></span>
	<ul>
<%	if (!isRegistration) { %>
		<li><span class="file"><%=MessageResources.getMessage(locale,"label.registration.form") %> <a href="javascript:void(0);" onclick="downloadFile('74');return false;" target="_blank">(<%=MessageResources.getMessage(locale,"label.click.here") %>)</a></span></li>
<%	} %>
		<li><span class="file"><%=MessageResources.getMessage(locale,"label.patient.admission") %> <a href="<%=DocumentDB.getURL("111") %>" target="_blank">(<%=MessageResources.getMessage(locale,"label.click.here") %>)</a><% if (isRegistration) { %><input type="checkbox" name="imptInfo" value="76"><%}%></span></li>
		<li><span class="file"><%=MessageResources.getMessage(locale,"label.patients.charter") %> <a href="<%=DocumentDB.getURL("112") %>" target="_blank">(<%=MessageResources.getMessage(locale,"label.click.here") %>)</a><% if (isRegistration) { %><input type="checkbox" name="imptInfo" value="390" ><%}%></span></li>
		<li><span class="file"><%=MessageResources.getMessage(locale,"label.why.vegetarian.diet") %> <a href="<%=DocumentDB.getURL("113") %>" target="_blank">(<%=MessageResources.getMessage(locale,"label.click.here") %>)</a><% if (isRegistration) { %><input type="checkbox" name="imptInfo" value="391"><%}%></span></li>
		<li><span class="file"><%=MessageResources.getMessage(locale,"label.renovation.letter") %> <a href="<%=DocumentDB.getURL("118") %>" target="_blank">(<%=MessageResources.getMessage(locale,"label.click.here") %>)</a><% if (isRegistration) { %><input type="checkbox" name="imptInfo" value="118"><%}%></span></li>
		<li><span class="file"><%=MessageResources.getMessage(locale,"label.health.care.advisory") %>
<%	if ("chi".equals(language)) { %>
			<a href="<%=DocumentDB.getURL("115") %>" target="_blank">(<%=MessageResources.getMessage(locale,"label.chinese.version") %>)</a>
<%	} else { %>
			<a href="<%=DocumentDB.getURL("114") %>" target="_blank">(<%=MessageResources.getMessage(locale,"label.english.version") %>)</a>
<%	} %>
<%	if (isRegistration) { %><input type="checkbox" name="imptInfo" value="75" id="Healthcarebox"><%}%></span></li>
		<li><span class="file"><%=MessageResources.getMessage(locale,"label.daily.room.rate") %> 
<%	if ("chi".equals(language)) {%>
			<a href="<%=DocumentDB.getURL("620") %>" target="_blank">(<%=MessageResources.getMessage(locale,"label.click.here") %>)</a>
<%	} else { %>
			<a href="<%=DocumentDB.getURL("116") %>" target="_blank">(<%=MessageResources.getMessage(locale,"label.click.here") %>)</a>
<%	} %>		
		<% if (isRegistration) { %><input type="checkbox" name="imptInfo" value="392" id="Roomrate"><%}%></span></li>
<%-- 		<li><span class="file"><%=MessageResources.getMessage(locale,"label.pre-anaesthesia.questionnaire") %> <a href="javascript:void(0);" onclick="downloadFile('117');return false;" target="_blank"()>(<%=MessageResources.getMessage(locale,"label.click.here") %>)</a><% if (isRegistration) { %><input type="checkbox" name="imptInfo" value="394"><%}%></span></li> --%>

	</ul>
</li>
