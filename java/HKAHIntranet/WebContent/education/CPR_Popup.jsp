<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ page import="com.hkah.config.*"%>	
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%UserBean userBean = new UserBean(request); %>
<%-- Please do not use this jsp as a standalone page, 
	 add html head, body tags, and include header.jsp and footer.jsp if you want to do so.
--%>

<style type="text/css">
    ul
	{
		list-style-type:none;
		padding:10px;
		margin:0px;
	}
    li
	{
		background-image:url(../images/beating_heart.gif);
		background-repeat:no-repeat;
		background-position:0px 0px; 
		padding-left:25px;
	}
  </style>
    <img src="../images/Bulb_man.gif" width="80" height="80"><font style="font-weight: bolder;color:red;font-size: large;">AHA New Guidelines on CPR & ECC 2010</font><img src="../images/heart.gif" width="80" height="80">
	
	<ul>
		<li><a href="javascript:void(0);" onclick="changeHitRate('link1','354');return false;" target="_blank">Highlights of the 2010AHA Guidelines for CPR and ECC</a><span id="link1"><%if(userBean.isEducationManager()){ %>Hit Rate: <%=DocumentDB.showHitRate("354") %><%} %></span></li>
		<li><a href="javascript:void(0);" onclick="changeHitRate('link2','355');return false;" target="_blank">Highlights of the 2010AHA Guidelines for CPR and ECC (Chinese Version)</a><span id="link2"><%if(userBean.isEducationManager()){ %>Hit Rate: <%=DocumentDB.showHitRate("355") %><%} %></span></li>
		<li><a href="javascript:void(0);" onclick="changeHitRate('link3','356');;return false;" target="_blank">2010 AHA Guidelines for CPR and ECC (PowerPoint)</a><span id="link3"><%if(userBean.isEducationManager()){ %>Hit Rate: <%=DocumentDB.showHitRate("356") %><%} %></span></li>
		<li><a href="javascript:void(0);" onclick="changeHitRate('link4','357');return false;" target="_blank">CPR Video </a><span id="link4"><%if(userBean.isEducationManager()){ %>Hit Rate: <%=DocumentDB.showHitRate("357") %><%} %></span></li>
		<li><a href="javascript:void(0);" onclick="changeHitRate('link5','358');return false;" target="_blank">2010 AHA Guidelines for CPR and ECC Key Change</a><span id="link5"><%if(userBean.isEducationManager()){ %>Hit Rate: <%=DocumentDB.showHitRate("358") %><%} %></span></li>
	</ul>	

<script language="javascript">
	var http = createRequestObject();

	
function changeHitRate(spanID,docID){
	downloadFile(docID);
	$('#'+spanID).load('../ui/docHitRateCMB.jsp?docID='+docID,new Date());
	return false;
}
</script>
