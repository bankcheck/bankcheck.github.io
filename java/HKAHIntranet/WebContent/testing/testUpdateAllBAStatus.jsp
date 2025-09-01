<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.mail.*"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.util.*"%>
<%@ page import="javax.mail.*"%>
<%@ page import="javax.mail.internet.*"%>
<%@ page import="java.net.MalformedURLException"%>
<%@ page import="java.net.URL"%>
<%@ page import="java.security.cert.Certificate"%>
<%@ page import="java.io.*"%>
<%@ page import="javax.net.ssl.HttpsURLConnection"%>
<%@ page import="javax.net.ssl.SSLPeerUnverifiedException"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.parser.JSONParser"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.web.db.*"%>


<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%

List<String> baIds = new ArrayList<String>();
/*
baIds.add("34");
baIds.add("35");
baIds.add("36");
baIds.add("37");
baIds.add("38");
baIds.add("39");
baIds.add("40");
baIds.add("41");
baIds.add("42");
baIds.add("43");
baIds.add("44");
baIds.add("45");
baIds.add("46");
baIds.add("47");
baIds.add("48");
baIds.add("49");
baIds.add("50");
baIds.add("51");
baIds.add("52");
baIds.add("54");
baIds.add("55");
baIds.add("56");
baIds.add("57");
baIds.add("58");
baIds.add("59");
baIds.add("60");
baIds.add("61");
baIds.add("62");
baIds.add("63");
baIds.add("64");
baIds.add("65");
baIds.add("66");
baIds.add("67");
baIds.add("68");
baIds.add("69");
baIds.add("127");
baIds.add("136");
baIds.add("137");
baIds.add("138");
baIds.add("139");
baIds.add("140");
baIds.add("141");
baIds.add("142");
baIds.add("143");
baIds.add("144");
baIds.add("145");
baIds.add("146");
baIds.add("147");
baIds.add("149");
baIds.add("150");
baIds.add("151");
baIds.add("152");
baIds.add("153");
baIds.add("154");
baIds.add("155");
baIds.add("156");
baIds.add("161");
baIds.add("162");
baIds.add("186");
baIds.add("192");
baIds.add("193");
baIds.add("195");
baIds.add("196");
baIds.add("197");
baIds.add("198");
baIds.add("200");
baIds.add("201");
baIds.add("203");
baIds.add("204");
baIds.add("205");
baIds.add("206");
baIds.add("207");
baIds.add("210");
baIds.add("216");
baIds.add("222");
baIds.add("223");
baIds.add("224");
baIds.add("225");
baIds.add("226");
baIds.add("236");
baIds.add("241");
baIds.add("242");
baIds.add("243");
baIds.add("254");
baIds.add("261");
baIds.add("265");
baIds.add("267");
baIds.add("272");
baIds.add("273");
baIds.add("274");
baIds.add("279");
baIds.add("282");
baIds.add("284");
baIds.add("285");
baIds.add("286");
baIds.add("287");
baIds.add("288");
baIds.add("289");
baIds.add("292");
baIds.add("296");
baIds.add("299");
baIds.add("303");
baIds.add("306");
baIds.add("307");
baIds.add("308");
baIds.add("310");
baIds.add("315");
baIds.add("316");
baIds.add("317");
baIds.add("318");
baIds.add("319");
baIds.add("321");
baIds.add("322");
baIds.add("323");
baIds.add("324");
baIds.add("325");
baIds.add("326");
baIds.add("327");
baIds.add("328");
baIds.add("331");
baIds.add("332");
baIds.add("333");
baIds.add("334");
baIds.add("337");
baIds.add("339");
baIds.add("340");
baIds.add("341");
baIds.add("342");
baIds.add("344");
baIds.add("345");
baIds.add("346");
baIds.add("348");
baIds.add("349");
baIds.add("351");
baIds.add("359");
baIds.add("364");
baIds.add("366");
baIds.add("367");
baIds.add("368");
baIds.add("370");
baIds.add("371");
baIds.add("372");
baIds.add("375");
baIds.add("376");
baIds.add("378");
baIds.add("381");
baIds.add("383");
baIds.add("384");
baIds.add("389");
baIds.add("390");
baIds.add("391");
baIds.add("392");
baIds.add("393");
baIds.add("394");
baIds.add("397");
baIds.add("398");
baIds.add("402");
baIds.add("413");
baIds.add("415");
baIds.add("416");
baIds.add("418");
baIds.add("424");
baIds.add("426");
baIds.add("427");
baIds.add("430");
baIds.add("435");
baIds.add("437");
baIds.add("438");
baIds.add("439");
baIds.add("444");
baIds.add("445");
baIds.add("446");
baIds.add("448");
baIds.add("450");
baIds.add("452");
baIds.add("456");
baIds.add("464");
baIds.add("466");
baIds.add("470");
baIds.add("484");
baIds.add("505");
*/

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display"%>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c"%>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp" />
<title>batch update status</title>
<style>
div {
    cursor: help;
}
</style>
<script language="javascript">
var baIds = [<%=StringUtils.join(baIds, ",") %>];

runAll();

function runAll() {
	$.each(baIds, function( key, value ) {
		//  alert( key + ": " + value );
	
		$.ajax({
			type: "POST",
			url: "../billingAgreement/batch_update_status.jsp",
			data: "command=update&step=1&moduleCode=external&status=7&baID=" + value,
			success: function(values){
				$("#msg").append("run baID="+value+" success.<br/>");
			},//success
			fail:function(values){
				$("#msg").append("run baID="+value+" FAILED.<br/>");
			}
		});//$.ajax
	
	});
}
</script>
<body>
Result
<div id="msg">

</div>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>