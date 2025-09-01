<%
	String webpage = request.getParameter("webpage");
	
	boolean isWebTWAH = false;
	if("twahweb".equals(webpage)){
		isWebTWAH = true;
	}
%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<html>
<jsp:include page="../common/header.jsp"/>
<head>
<title>Hong Kong Adventist Hospital - Informed Consent</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<script language=JavaScript src="<html:rewrite page="/js/internet/common.js" />"></script>
<script language="JavaScript" src="<html:rewrite page="/js/internet/scroll.js" />"></script>
<script type="text/javascript" src="<html:rewrite page="/js/internet/objectSwap.js" />"></script>
<script type="text/javascript" src="<html:rewrite page="/js/internet/chanlang.js" />"></script>
<link rel="stylesheet" href="<html:rewrite page="/css/style_internet.css" />" type="text/css">
<style>
	body { background: #f5f1ee; }
	.acknowledgements { font-weight: bold; }
</style>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form name="form1" method="post" action="">
  <table border="0" cellspacing="0" cellpadding="0" align="center">
    <tr align="left" valign="top">
      <td width="5"><img src="<html:rewrite page="/images/internet/box.gif" />" width="5" height="16"></td>
      <td width="780">&nbsp;</td>
      <td width="5"><img src="<html:rewrite page="/images/internet/box.gif" />" width="5" height="16"></td>
    </tr>

    <tr align="left" valign="top">
      <td width="5" background="<html:rewrite page="/images/internet/border_24.jpg" />"><img src="<html:rewrite page="/images/internet/border_03.jpg" />"></td>
      <td width="780">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="left" valign="top" background="<html:rewrite page="/images/internet/index_04.jpg" />">
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr align="left" valign="top">
                <%if(isWebTWAH){%>
                	<td width="312"><a href="http://www.twah.org.hk/new/eng/index.htm"><img src="<html:rewrite page="/images/internet/index_twah_01.jpg" />" border="0"></a></td>
                <%}else{%>
                  <td width="312"><a href="http://www.hkah.org.hk/new/eng/index.htm"><img src="<html:rewrite page="/images/internet/index_03.jpg" />" border="0"></a></td>
                 <%} %>
                  <td><!-- #BeginLibraryItem "/Library/eng_lang.lbi" --><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>

                      <td align="right" valign="top"><img src="<html:rewrite page="/images/internet/spacer.gif" />" width="20" height="20"></td>
                    </tr>
                    <tr>
                      <td align="right" valign="top">

      <table border="0" cellspacing="0" cellpadding="0">
        <tr align="left" valign="top">
        </tr>
      </table>
                      </td>

                    </tr>
                    <tr>
                      <td align="right" valign="top" height="50">&nbsp;</td>
                    </tr>
                    <tr>
                      <td align="right" valign="top"></td>
                    </tr>
                  </table><!-- #EndLibraryItem --></td>
                  <td width="21"><img src="<html:rewrite page="/images/internet/index_06.jpg" />"></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td align="left" valign="top"><img src="<html:rewrite page="/images/internet/header_about_hkah.jpg" />" border="0"></td>
          </tr>
          <tr>
            <td align="left" valign="top" background="<html:rewrite page="/images/internet/index_54.jpg" />">
              <table cellspacing="0" cellpadding="0" width="100%">
                <tr align="left" valign="top">
                  <td width="90"><img src="<html:rewrite page="/images/internet/spacer.gif" />" width="90" height="10"></td>
                  <td>
                    <table width="100%" border="0" cellspacing="10" cellpadding="0" height="280">
                      <tr>
                        <td align="left" valign="top" class="content10">                            
                            <%if(isWebTWAH){%>
                            <jsp:include page="../common/information_helper.jsp" flush="false">
                            	<jsp:param name="category" value="doctor page" />
                            	  <jsp:param name="skipColumnTitle" value="Y" />
	                              <jsp:param name="mustLogin" value="N" />
	                              <jsp:param name="oldTreeStyle" value="Y" />
                            </jsp:include>
                            <%}else{ %>
                            <jsp:include page="../common/information_helper.jsp" flush="false">
                                <jsp:param name="category" value="informed consent" />
                                <jsp:param name="skipColumnTitle" value="Y" />
	                            <jsp:param name="mustLogin" value="N" />
	                            <jsp:param name="oldTreeStyle" value="Y" />
                            </jsp:include>
                            <%} %>
                            
						<br />
                        <p class="acknowledgements">Acknowledgements: Smart Patient Website, coordinated by Health InfoWorld of the Hospital Authority</p>
                        </td>
                      </tr>
                    </table>
                  </td>
                  <td valign="bottom" width="90"><img src="<html:rewrite page="/images/internet/service_15.jpg" />" width="90" height="29"></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td align="left" valign="top" background="<html:rewrite page="/images/internet/index_54.jpg" />"><!-- #BeginLibraryItem "/Library/eng_footer.lbi" --><table width="100%" border="0" cellspacing="0" cellpadding="4">
              <tr align="left" valign="top">
                <td class="content9" width="10"><img src="<html:rewrite page="/images/internet/spacer.gif" />" width="10" height="5"></td>
                <td class="content9"></td>
    			<td align="right" class="content9"></td>
                <td class="content9" width="10" align="left" valign="top"><img src="<html:rewrite page="/images/internet/spacer.gif" />" width="10" height="5"></td>
              </tr>
            </table><!-- #EndLibraryItem --></td>
          </tr>
        </table>
      </td>
      <td background="<html:rewrite page="/images/internet/border_32.jpg" />" width="5"><img src="<html:rewrite page="/images/internet/border_08.jpg" />"></td>
    </tr>
    <tr align="left" valign="top">
      <td width="5"><img src="<html:rewrite page="/images/internet/border_61.jpg" />"></td>
      <td width="780"><img src="<html:rewrite page="/images/internet/index_55.jpg" />"></td>
      <td width="5"><img src="<html:rewrite page="/images/internet/border_63.jpg" />"></td>
    </tr>
    <tr align="left" valign="top">
      <td width="5">&nbsp;</td>
      <td width="780"></td>
      <td width="5">&nbsp;</td>
    </tr>
  </table>

  </form>
  <script type="text/javascript" src="<html:rewrite page="/js/menu.js" />"></script>
  <script type="text/javascript" src="<html:rewrite page="/js/tracking.js" />"></script>
<jsp:include page="../common/footer.jsp" flush="false"/>
</body>
</html>
