<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%String type = request.getParameter("type");
%>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
	<frameset rows="50,*">
		<frame src="../portal/policyHeader.jsp?type=<%=type%>">
		<frame src="\\www-server\Policy\departmental">
	</frameset>
<jsp:include page="../common/footer.jsp" flush="false" />
</html:html>