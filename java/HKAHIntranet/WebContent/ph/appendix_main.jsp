<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.util.*"%>
<%

%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<style></style>
<frameset cols="13%,*">
  <frame name="frame_index" id="frame_index" src="appendix_title.jsp">
  <frame name="frame_details" id="frame_details" src="appendix_details.jsp">
</frameset>
<jsp:include page="../common/footer.jsp" flush="false"/>

<!-- <iframe src="appendix_index.jsp" ></iframe> -->
<!-- <iframe src="appendix_details.jsp" ></iframe> -->
</html:html>