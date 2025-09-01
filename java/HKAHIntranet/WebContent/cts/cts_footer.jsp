<%@ page import="com.hkah.constant.*"%>
</br>
<div id="footer" class="footer" style="width:100%">
<div class="normal_area">
</br>
<table border="0" style="width:100%">
<tr>
<%if("twah".equals(ConstantsServerSide.SITE_CODE)){ %>
	<td style="color:white;font-size: 15px;text-align:left" colspan="2">Hong Kong Adventist Hospital - Tsuen Wan</td></tr>
<%} else { %>
	<td style="color:white;font-size: 15px;text-align:left" colspan="2">Hong Kong Adventist Hospital - Stubbs Road</td></tr>
<%} %>
<tr><td>&nbsp;</td></tr>
<%if("twah".equals(ConstantsServerSide.SITE_CODE)){ %>
	<tr><td style="color:white;text-align:left" colspan="2">199 Tsuen King Circuit, Tsuen Wan, N.T., Hong Kong.</td></tr>
<%} else { %>
	<tr><td style="color:white;text-align:left" colspan="2">40 Stubbs Road, Hong Kong</td></tr>
<%} %>
<tr>
<td style="color:white;text-align:left;vertical-align: text-top; width:30px">Tel:</td>
<%if("twah".equals(ConstantsServerSide.SITE_CODE)){ %>
	<td style="color:white;text-align:left">(852) 2835 0581</td>
<%} else { %>
	<td style="color:white;text-align:left">(852) 2275 6711</td>
<%} %>
</tr>      
<tr>
<td style="color:white;text-align:left">Fax:</td>
<%if("twah".equals(ConstantsServerSide.SITE_CODE)){ %>
	<td style="color:white;text-align:left">(852) 2574 6001</td>
<%} else { %>
	<td style="color:white;text-align:left">(852) 2275 6473</td>
<%} %>
</tr>
</table>    
<table border="0" style="width:100%">
<tr>
</br>
</br>
</br>
<td style="color:white;text-align:left">
<%if("twah".equals(ConstantsServerSide.SITE_CODE)){ %>
	    <a href="http://www.twah.org.hk/en/terms" class="link1">Legal Statement</a> | <a target="_blank" href="http://www.twah.org.hk/en/sitemap" class="link1">Site Map</a>
<%} else { %>
	    <a href="http://www.hkah.org.hk/en/terms" class="link1">Legal Statement</a> | <a target="_blank" href="http://www.hkah.org.hk/en/sitemap" class="link1">Site Map</a>
<%} %>
</td>
<td style="color:white;text-align:right">    
      © 2014 Adventist Health. All Rights Reserved.
</td>      
</tr>      
</table>
</div>
</div>