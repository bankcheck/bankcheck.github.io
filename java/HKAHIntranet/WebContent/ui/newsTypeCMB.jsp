<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %><%
String newsCategory = request.getParameter("newsCategory");
String newsType = request.getParameter("newsType");
if (newsType == null) {
	newsType = "";
}
if (newsCategory == null) {
	newsCategory = "";
}

boolean isChap = false;
boolean isHospital = false;
boolean isEducation = false;
boolean isMarketing = false;
boolean isHR = false;
boolean isPhysician = false;
boolean isNursing = false;
boolean isNewsletter = false;
boolean isLMC = false;
boolean isExecutiveOrder = false;
boolean isPoster = false;
boolean isBLS = false;

if ("chap".equals(newsCategory)) {
	isChap = true;
} else if ("hospital".equals(newsCategory)) {
	isHospital = true;
} else if ("education".equals(newsCategory)) {
	isEducation = true;
} else if ("marketing".equals(newsCategory)) {
	isMarketing = true;
} else if ("human resources".equals(newsCategory)) {
	isHR = true;
} else if ("physician".equals(newsCategory)) {
	isPhysician = true;
} else if ("nursing".equals(newsCategory)) {
	isNursing = true;
} else if ("LMC".equals(newsCategory)) {
	isLMC = true;
} else if ("executive order".equals(newsCategory)) {
	isExecutiveOrder = true;
} else if ("poster".equals(newsCategory)) {
	isPoster = true;
} else if ("BLS".equals(newsCategory)) {
	isBLS = true;
}
%>

<%if (isPoster) { %>
	<option value="hospital"<%="hospital".equals(newsType)?" selected":"" %>>Hospital (All) [G/F, 7/F, 8/F]</option>
	<option value="hospital.8f"<%="hospital.8f".equals(newsType)?" selected":"" %>>Hospital 8/F</option>
	<option value="hospital.7f"<%="hospital.7f".equals(newsType)?" selected":"" %>>Hospital 7/F</option>
	<option value="hospital.gf"<%="hospital.gf".equals(newsType)?" selected":"" %>>Hospital G/F</option>
	<option value="larue.1f"<%="larue.1f".equals(newsType)?" selected":"" %>>LaRue 1/F</option>
	<option value="larue.gf"<%="larue.gf".equals(newsType)?" selected":"" %>>LaRue LG/F</option>
	<option value="message"<%="message".equals(newsType)?" selected":"" %>>Message</option>
	<option value="all"<%="all".equals(newsType)?" selected":"" %>>All</option>
<%} else {%>
<%	if (!isLMC && !isBLS){ %>
<option value="article"<%="article".equals(newsType)?" selected":"" %>>Article</option>
<option value="announcement"<%="announcement".equals(newsType)?" selected":"" %>>Announcement</option>
<%	} %>
<%	if (isMarketing) { %><option value="bank"<%="bank".equals(newsType)?" selected":"" %>>Bank</option><%} %>
<%	if (!isEducation && !isLMC && !isChap && !isBLS) { %><option value="cmc"<%="cmc".equals(newsType)?" selected":"" %>>CMC</option><%} %>
<%	if (isEducation) { %><option value="cee"<%="cee".equals(newsType)?" selected":"" %>>Continuing External Education</option><%} %>
<%	if (!isLMC && !isBLS){ %>
<option value="event"<%="event".equals(newsType)?" selected":"" %>><bean:message key="prompt.event" /></option>
<option value="guideline"<%="guideline".equals(newsType)?" selected":"" %>>Guideline</option>
<%} %>
<%	if (isEducation) { %><option value="literature"<%="literature".equals(newsType)?" selected":"" %>>Literature Search</option><%} %>
<%	if (isHospital || isMarketing) { %><option value="media"<%="media".equals(newsType)?" selected":"" %>>Media</option><%} %>
<%	if(!isLMC && !isBLS){ %>
<option value="news"<%="news".equals(newsType)?" selected":"" %>>News</option>
<option value="notice"<%="notice".equals(newsType)?" selected":"" %>>Notice</option>
<%	} %>
<%	if (isMarketing) { %><option value="package"<%="package".equals(newsType)?" selected":"" %>>Package</option><%} %>
<%	if (isEducation) { %><option value="staff edu"<%="staff edu".equals(newsType)?" selected":"" %>>Staff Education</option><%} %>
<%	if (isEducation) { %><option value="classRelatedNews"<%="classRelatedNews".equals(newsType)?" selected":"" %>>Class Related News</option><%} %>
<%	if (isLMC) {%>
<option value="Community Health Services"<%="Community Health Services".equals(newsType)?" selected":"" %>><bean:message key="prompt.LMC.community" /></option>
<option value="Wellness Products"<%="Wellness Products".equals(newsType)?" selected":"" %>><bean:message key="prompt.LMC.health" /></option>
<option value="Newsletters"<%="Newsletters".equals(newsType)?" selected":"" %>><bean:message key="prompt.LMC.newsletters" /></option>
<option value="Newstart Program"<%="Newstart Program".equals(newsType)?" selected":"" %>><bean:message key="prompt.LMC.newstart" /></option>
<option value="Leisure And Health"<%="Leisure And Health".equals(newsType)?" selected":"" %>><bean:message key="prompt.LMC.Leisure" /></option>
<option value="Preventive Medicine Information"<%="Preventive Medicine Information".equals(newsType)?" selected":"" %>><bean:message key="prompt.LMC.preventive" /></option>
<option value="Health Promotion Standard"<%="Health Promotion Standard".equals(newsType)?" selected":"" %>><bean:message key="prompt.LMC.health.promotion" /></option>
<%	} %>
<% if (isBLS) { %>
<option value="1.Aims"<%="1.Aims".equals(newsType)?" selected":"" %>>Aims</option>
<option value="2.Target Group"<%="2.Target Group".equals(newsType)?" selected":"" %>>Target Group</option>
<option value="3.Course Details"<%="3.Course Details".equals(newsType)?" selected":"" %>>Course Details</option>
<option value="4.Pretest"<%="4.Pretest".equals(newsType)?" selected":"" %>>Pretest</option>
<option value="5.NRP Program"<%="5.NRP Program".equals(newsType)?" selected":"" %>>NRP Program</option>	
<% } %>
<%} %>
