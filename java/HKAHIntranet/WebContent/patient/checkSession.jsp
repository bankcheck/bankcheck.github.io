<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
UserBean userBean = new UserBean(request);

if (userBean == null || !userBean.isLogin()) {
	%>
	<script>
		window.open('../patient/login.jsp', '_self');	
	</script>
	<%
}
%>
<style type="text/css">
button { margin:0 7px 0 0; border:10px solid #aeaeae; border-top:10px solid #eee; border-left:10px solid #eee; font: 12px Arial, Helvetica, sans-serif; font-size:32px; line-height:100%; text-decoration:none; color:#565656; cursor:pointer; padding:10px 10px 10px 10px; /* Links */ ; }
</style>

<!-- the loading box -->
<div id="loadingBox" class="loading">
	<strong>Loading...</strong><br/>
	<img src="../images/loadingAnimation.gif"/>
</div>

<script>
	function showLoadingBox() {
		if($("div#loadingBox:hidden"))
			$('div#loadingBox').fadeIn(100);
	}
	
	function hideLoadingBox() {
		if($("div#loadingBox:visible"))
			$('div#loadingBox').fadeOut(500);
	}
</script>