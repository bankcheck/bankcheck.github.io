<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%String specialtyCode = request.getParameter("specialtyCode");%>
<option value="ob"<%="ob".equals(specialtyCode)?" selected":"" %>><bean:message key="label.ob" /></option>
<option value="surgical"<%="surgical".equals(specialtyCode)?" selected":"" %>><bean:message key="label.surgical" /></option>
<option value="ha"<%="ha".equals(specialtyCode)?" selected":"" %>><bean:message key="label.ha" /></option>
<option value="cardiac"<%="cardiac".equals(specialtyCode)?" selected":"" %>><bean:message key="label.cardiac" /></option>