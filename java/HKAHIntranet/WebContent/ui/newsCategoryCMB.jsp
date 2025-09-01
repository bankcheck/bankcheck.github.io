<%@ page import="com.hkah.web.common.*"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%
UserBean userBean = new UserBean(request);
String newsCategory = request.getParameter("newsCategory");

boolean isMarketing = userBean.isAccessible("function.news.type.marketing");
boolean isHR = userBean.isAccessible("function.news.type.humanResource");
boolean isPhysician = userBean.isAccessible("function.news.type.physician");
boolean isVPMA = userBean.isAccessible("function.news.type.vpma");
boolean isNursing = userBean.isAccessible("function.news.type.nursing");
boolean isPoster = userBean.isAccessible("function.news.type.poster");

boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));
if (allowEmpty) {
	String emptyLabel = request.getParameter("emptyLabel");
	if (emptyLabel == null) {
		emptyLabel = "--- All Category ---";
	}
%><option value=""><%=emptyLabel %></option><%
}
%>
<%if (userBean.isAccessible("function.news.type.accreditation")) { %><option value="accreditation"<%="accreditation".equals(newsCategory)?" selected":"" %>>Accreditation</option><%} %>
<%if (userBean.isAccessible("function.news.type.chap")) { %><option value="chap"<%="chap".equals(newsCategory)?" selected":"" %>>Chaplaincy</option><%} %>
<%if (userBean.isAccessible("function.news.type.education")) { %><option value="education"<%="education".equals(newsCategory)?" selected":"" %>><bean:message key="label.education" /></option><%} %>
<%if (isMarketing || isHR || isPhysician || isNursing) { %><option value="executive order"<%="executive order".equals(newsCategory)?" selected":"" %>>Executive Order</option><%} %>
<%if (isPhysician) { %><option value="physician"<%="physician".equals(newsCategory)?" selected":"" %>>Executive Order - Physician</option><%} %>
<%if (isVPMA) { %><option value="vpma"<%="vpma".equals(newsCategory)?" selected":"" %>>Executive Order - VPMA</option><%} %>
<%if (userBean.isAccessible("function.news.type.hospital")) { %><option value="hospital"<%="hospital".equals(newsCategory)?" selected":"" %>><bean:message key="label.hospital" /></option><%} %>
<%if (isHR) { %><option value="human resources"<%="human resources".equals(newsCategory)?" selected":"" %>><bean:message key="group.hr" /></option><%} %>
<%if (userBean.isAccessible("function.news.type.infectionControl")) { %><option value="infection control"<%="infection control".equals(newsCategory)?" selected":"" %>><bean:message key="department.780" /></option><%} %>
<%if (userBean.isAccessible("function.news.type.lmc")) {%><option value="LMC"<%="LMC".equals(newsCategory)?" selected":""%>>LifeStyle Management Centre</option><%} %>
<%if (isMarketing) { %><option value="marketing"<%="marketing".equals(newsCategory)?" selected":"" %>><bean:message key="department.750" /></option><%} %>
<%if (userBean.isAccessible("function.news.type.newsletter")) { %><option value="newsletter"<%="newsletter".equals(newsCategory)?" selected":"" %>>Newsletter</option><%} %>
<%if (isNursing) { %><option value="nursing"<%="nursing".equals(newsCategory)?" selected":"" %>><bean:message key="label.nursing" /></option><%} %>
<%if (userBean.isAccessible("function.news.type.osh")) { %><option value="osh"<%="osh".equals(newsCategory)?" selected":"" %>><bean:message key="department.785" /></option><%} %>
<%if (isPoster) { %><option value="poster"<%="poster".equals(newsCategory)?" selected":"" %>><bean:message key="label.poster" /></option><%} %>
<%if (userBean.isAccessible("function.news.type.pi")) { %><option value="pi"<%="pi".equals(newsCategory)?" selected":"" %>><bean:message key="label.performanceImprovement" /></option><%} %>
<%if (userBean.isAccessible("function.news.type.promotion")) { %><option value="promotion"<%="promotion".equals(newsCategory)?" selected":""%>>Vendor Discounts for Staff</option><%} %>
<%if (userBean.isAccessible("function.news.type.specsharing")){%><option value="special sharing"<%="special sharing".equals(newsCategory)?" selected":""%>>Special Sharing</option><%} %>
<%if (userBean.isAccessible("function.news.type.crm")) { %><option value="lmc.crm"<%="lmc.crm".equals(newsCategory)?" selected":""%>>CRM</option><%} %>
<%if(!"lmc.crm".equals(newsCategory)) {%>
<option value="pem"<%="pem".equals(newsCategory)?" selected":"" %>>PEM</option>
<option value="other"<%="other".equals(newsCategory)?" selected":"" %>><bean:message key="label.others" /></option>
<option value="BLS"<%="BLS".equals(newsCategory)?" selected":"" %>>BLS</option>
<%} %>