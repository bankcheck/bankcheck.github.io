<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.util.db.*"%>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%
	UserBean userBean = new UserBean(request);
	String category = request.getParameter("category");
	String siteDesc = "HKAH";
	String siteHistoryURL = "";
	if(ConstantsServerSide.isHKAH()){
		siteDesc = "HKAH-SR";
		siteHistoryURL = "https://www.hkah.org.hk/en/hkah-history";
	} else if(ConstantsServerSide.isTWAH()){
		siteDesc = "HKAH-TW";
		siteHistoryURL = "https://www.twah.org.hk/en/twah-history";
	}
%>
<%!
private String showNews(UserBean userBean,String newsID){
	String title = null;
	String titleImage = null;
	String newsCategory = "hospital";
	String content = null;
	if (newsID != null && newsID.length() > 0) {
	ArrayList result = null;
	// get news content
	
		result = NewsDB.get(userBean,newsID, newsCategory);
	
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			title = row.getValue(3);
			titleImage = row.getValue(5);
		
		
			StringBuffer contentSB = new StringBuffer();
			result = NewsDB.getContent(newsID, newsCategory);
			if (result != null) {
				for (int i = 0; i < result.size(); i++) {
					row = (ReportableListObject) result.get(i);
					contentSB.append(row.getValue(0));
				}
			}
			content = contentSB.toString();
		}
	}
	return content;
}

private String showNews(UserBean userBean,String newsCategory,String newsID){
	String title = null;
	String titleImage = null;
	String content = null;
	if (newsID != null && newsID.length() > 0) {
	ArrayList result = null;
	// get news content
	
		result = NewsDB.get(userBean,newsID, newsCategory);
	
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			title = row.getValue(3);
			titleImage = row.getValue(5);
		
		
			StringBuffer contentSB = new StringBuffer();
/* 			if (title != null && !"".equals(title)) {
				contentSB.append("<b><u>"+title+"</b></u><br>");
			} */
			result = NewsDB.getContent(newsID, newsCategory);
			if (result != null) {
				for (int i = 0; i < result.size(); i++) {
					row = (ReportableListObject) result.get(i);
					contentSB.append(row.getValue(0));
				}
			}
			content = contentSB.toString();
		}
	}
	return content;
}

private StringBuffer printNewsTree(UserBean userBean, String newsCategory) {
	StringBuffer sqlStr = new StringBuffer();
	StringBuffer sb = new StringBuffer();

	sqlStr.append(" SELECT CO_NEWS_TYPE, COUNT(1) FROM CO_NEWS ");
	sqlStr.append(" WHERE CO_NEWS_CATEGORY='"+newsCategory+"' ");
	sqlStr.append(" AND CO_ENABLED=1 ");
	sqlStr.append(" GROUP BY CO_NEWS_TYPE ORDER BY CO_NEWS_TYPE ");
			
	ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
	ArrayList resultNews = null;
	int newsCount = 0;
	String subNewsCategory = null;
	if (result != null) {
		for (int i = 0; i < result.size(); i++) {
			ReportableListObject row = (ReportableListObject) result.get(i);
			newsCount = Integer.parseInt(row.getValue(1));
			subNewsCategory = row.getValue(0);
			if (newsCount > 0) {
				resultNews = NewsDB.getList(userBean, newsCategory, row.getValue(0),null,0, 3);
					sb.append("<tr><td>&nbsp;</td></tr>");
					sb.append("<tr><td class=\"h1_margin\">");
					sb.append("<a href=\"#\" class=\"staticLink\" onclick=\"showhide("+i+", 'rr_hideobj_', 'rr_showobj_', 'rr_showhidelink_', '"
							+subNewsCategory+"', '"+subNewsCategory+"');return false;\">");
					sb.append("<u><span style=\" color: #000000;\" id=\"rr_showhidelink_"+i+"\" class=\"visible\">"+subNewsCategory+"</span></u>");
					sb.append("</a><br/>");
					if (resultNews != null) {
						
						sb.append("<span id=\"rr_hideobj_"+i+"\" style=\"display:none\">");
												
						for (int j = 0; j < resultNews.size(); j++) {
							ReportableListObject rowNews = (ReportableListObject) resultNews.get(j);
							
							if (rowNews.getValue(3).startsWith("-")){
								sb.append(formCollaspeTree("9"+Integer.toString(i)+Integer.toString(j),rowNews.getValue(3),showNews(userBean,"BLS",rowNews.getValue(0))).toString());
							} else {							
								sb.append(showNews(userBean,"BLS",rowNews.getValue(0))+"</br>");
							}
						}
						sb.append("</span>");

					}					
					sb.append("<span id=\"rr_showobj_"+i+"\" style=\"display:inline\"></span>");
					sb.append("</td></tr>");
				
			}
			
		}
	}
	
	
	
	return sb;
}
private StringBuffer formCollaspeTree(String i, String subNewsCategory, String content){
	StringBuffer sb = new StringBuffer();
	
	sb.append("<a href=\"#\" class=\"staticLink\" onclick=\"showhide("+i+", 'rr_hideobj_', 'rr_showobj_', 'rr_showhidelink_', '"
			+subNewsCategory+"', '"+subNewsCategory+"');return false;\">");
	sb.append("<u><span style=\" color: #000000;\" id=\"rr_showhidelink_"+i+"\" class=\"visible\">"+subNewsCategory+"</span></u>");
	sb.append("</a><br/>");
	sb.append("<span id=\"rr_hideobj_"+i+"\" style=\"display:none\">");
	sb.append(""+content+"<br></span>");
	sb.append("<span id=\"rr_showobj_"+i+"\" style=\"display:inline\"></span>");
	
	return sb;
}

%> 
<%if( "BLS".equals(category)) { %>
	<table width="100%" border="0" cellspacing="0" cellpadding="20">
	<%=printNewsTree(userBean, "BLS") %>
	</table>
<% } else {  %>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr><td class="title"><span>About <%=siteDesc %> <img src="../images/title_arrow.gif"></span></td></tr>
		<tr><td height="2" bgcolor="#840010"></td></tr>
		<tr><td height="10"></td></tr>
	</table>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr><td height="2" bgcolor="#F2F2F2"></td></tr>
		<tr><td class="h1_margin">
			<span id="rr_hideobj_0"></span>
			<span id="rr_showobj_0" style="display:inline"><bean:message key="message.hkah.preamble" /></span>
		</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td class="h1_margin">
			<a href="#" class="staticLink" onclick="showhide(1, 'rr_hideobj_', 'rr_showobj_', 'rr_showhidelink_', '<bean:message key="message.mission" />', '<bean:message key="message.mission" />');return false;">
				<u><span style=" color: #000000;" id="rr_showhidelink_1" class="visible"><bean:message key="message.mission" /></span></u>
			</a>
			<br/>
			<span id="rr_hideobj_1" style="display:none"></span>
			<span id="rr_showobj_1" style="display:inline"><bean:message key="message.hkah.mission" /></span>
		</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td class="h1_margin" style="display:none">
			<a href="#" class="staticLink" onclick="showhide(2, 'rr_hideobj_', 'rr_showobj_', 'rr_showhidelink_', '<bean:message key="message.brandPromise" />', '<bean:message key="message.brandPromise" />');return false;">
				<u><span style=" color: #000000;" id="rr_showhidelink_2" class="visible"><bean:message key="message.brandPromise" /></span></u>
			</a>
			<br/>
			<span id="rr_hideobj_2" style="display:none"><bean:message key="message.hkah.brandPromise" /></span>
			<span id="rr_showobj_2" style="display:inline"></span>
		</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td class="h1_margin">
			<a href="#" class="staticLink" onclick="showhide(3, 'rr_hideobj_', 'rr_showobj_', 'rr_showhidelink_', '<bean:message key="message.values" />', '<bean:message key="message.values" />');return false;">
				<u><span style=" color: #000000;" id="rr_showhidelink_3" class="visible"><bean:message key="message.values" /></span></u>
			</a>
			<br/>
			<span id="rr_hideobj_3" style="display:inline">
				<bean:message key="message.hkah.values" />
					<div style="margin: 5px 0;">
						<ul>
							<li style="margin: 5px 0;">
								<span><b><bean:message key="message.hkah.values1.title" /></span></b><br />
								<span><bean:message key="message.hkah.values1.reason" /></span>
							</li>
							<li style="margin: 5px 0;">
								<span><b><bean:message key="message.hkah.values2.title" /></span></b><br />
								<span><bean:message key="message.hkah.values2.reason" /></span>
							</li>
							<li style="margin: 5px 0;">
								<span><b><bean:message key="message.hkah.values3.title" /></span></b><br />
								<span><bean:message key="message.hkah.values3.reason" /></span>
							</li>
							<li style="margin: 5px 0;">
								<span><b><bean:message key="message.hkah.values4.title" /></span></b><br />
								<span><bean:message key="message.hkah.values4.reason" /></span>
							</li>
							<li style="margin: 5px 0;">
								<span><b><bean:message key="message.hkah.values5.title" /></span></b><br />
								<span><bean:message key="message.hkah.values5.reason" /></span>
							</li>
						</ul>
					</div>
			</span>
			<span id="rr_showobj_3" style="display:none"></span>

			
		</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td class="h1_margin"><u><a href="<%=siteHistoryURL %>" class="topstoryblue" target="_blank">History of <%=siteDesc %></a></u></td></tr>
		<tr><td>&nbsp;</td></tr>
	</table>	
<%} %>
<script language="javascript">
	function showhide(i, hideobj, showobj, showhidelink, hidelink, showlink){
		var showelem = document.getElementById(showobj + i);
		var hideelem = document.getElementById(hideobj + i);
		var linkelem=document.getElementById(showhidelink + i);

		showelem.style.display=showelem.style.display=='none'?'inline':'none';
		hideelem.style.display=hideelem.style.display=='none'?'inline':'none';

		if (hideelem.style.display=='none'){
			linkelem.className="invisible";
			linkelem.innerHTML = showlink;
		} else {
			linkelem.className="visible";
			linkelem.innerHTML = hidelink;
		}
	}
</script>