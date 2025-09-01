<%@ page import="com.hkah.constant.*" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%String siteCode = request.getParameter("siteCode"); %>
	<input type="radio" name="siteCode" value="<%=ConstantsServerSide.SITE_CODE_HKAH %>"<%=ConstantsServerSide.SITE_CODE_HKAH.equals(siteCode)?" checked":"" %>><bean:message key="label.hkah" />
	<input type="radio" name="siteCode" value="<%=ConstantsServerSide.SITE_CODE_TWAH %>"<%=ConstantsServerSide.SITE_CODE_TWAH.equals(siteCode)?" checked":"" %>><bean:message key="label.twah" />
	<input type="radio" name="siteCode" value="<%=ConstantsServerSide.SITE_CODE_AMC %>"<%=ConstantsServerSide.SITE_CODE_AMC.equals(siteCode)?" checked":"" %>>AMC
	<input type="radio" name="siteCode" value="<%=ConstantsServerSide.SITE_CODE_AMC2 %>"<%=ConstantsServerSide.SITE_CODE_AMC2.equals(siteCode)?" checked":"" %>>AMC2
<%if ("Y".equals(request.getParameter("allowAll"))) { %>
	<input type="radio" name="siteCode" value=""<%=(!ConstantsServerSide.SITE_CODE_HKAH.equals(siteCode) && !ConstantsServerSide.SITE_CODE_TWAH.equals(siteCode) && !ConstantsServerSide.SITE_CODE_AMC.equals(siteCode))?" checked":"" %>><bean:message key="label.all" />
<%} %>