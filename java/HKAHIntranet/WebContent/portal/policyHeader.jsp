<%@ page language="java"
%><%@ page import="com.hkah.constant.*"
%><%@ page import="com.hkah.util.*"
%><%@ page import="com.hkah.util.db.*"
%><%@ page import="com.hkah.web.common.*"
%><%@ page import="com.hkah.web.db.*"
%><%@ page import="com.hkah.convert.Converter"
%>
<%
UserBean userBean = new UserBean(request);

boolean allowConvert = Converter.checkHospitalWideAccess(userBean);
String type = request.getParameter("type");
%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<table border=0 cellspacing=0 cellpadding=0 width="100%">
<tr>
	<td>
		<h2>
			<b class="b1"></b><b class="b2"></b><b class="b3"></b><b class="b4"></b>
			<div style="" class="contentb">
				<span class="pageTitle bigText">
					Policy and Resource		
					<% if (userBean.isAdmin() && allowConvert){ %>		
					<button  onclick="return convertPathFileToPdf();" >Convert all to PDF</button>
					<% } %>								
				</span>
			</div>
			<b class="b4"></b><b class="b3"></b><b class="b2"></b><b class="b1"></b>
		</h2>
	</td>
</tr>
</table>

</body>
<script type="text/javascript">
function convertPathFileToPdf() {
	var convert = confirm("Convert all Departmental Policy?");
	if( convert == true ){	
		showLoadingBox('body', 500, $(window).scrollTop());
		$.ajax({
			url: '../common/convertPathFileToPdf.jsp?type=deptPolicy&isTest=<%=type%>',
			async: true,
			cache:false,
			success: function(values){
				alert('Finish converting policy.')				
				hideLoadingBox('body', 500);				
			},
			error: function() {
				alert('Error occured while converting policy.');
				hideLoadingBox('body', 500);
			}
		});
	}
}
</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</html:html>