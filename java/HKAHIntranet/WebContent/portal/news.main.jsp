<%@ page import="java.util.*"%>
<%@ page import="org.apache.struts.*"%>
<%
	Locale locale = (Locale) session.getAttribute( Globals.LOCALE_KEY);
	String fileSuffix = null;
	if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {
		fileSuffix = "zh";
	} else {
		fileSuffix = "en";
	}
%>
<table width="100%" border="0">
	<tr class="bigText">
		<td align="center">The following video contains the information about Swine flu:</td>
	</tr>
	<tr class="smallText">
		<td align="center">
			<br><object id="presentation" width="500" height="400" classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0" align="middle">
			<param name="allowScriptAccess" value="sameDomain" />
			<param name="movie" value="/swf/handhygiene_<%=fileSuffix %>.swf" />
			<param name="quality" value="high" />
			<param name="bgcolor" value="#ffffff" />
			<param name="allowFullScreen" value="true" />
			<embed src="/swf/handhygiene_<%=fileSuffix %>.swf" quality="high" bgcolor="#ffffff" width="720" height="576" name="presentation" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.adobe.com/go/getflashplayer" allowFullScreen="true" />
			</object>
		</td>
	</tr>
	<tr class="smallText">
		<td align="center"><img src="../images/new.gif" border="0"><a href="../documentManage/download.jsp?documentID=13" class="bigText"><BLINK>IMPORTANT Information on Swine Influenza for Staff (updated)</BLINK></a></td>
	</tr>
	<tr class="smallText">
		<td align="center">&nbsp;</td>
	</tr>
	<tr class="smallText">
		<td align="center"><a href="../documentManage/download.jsp?documentID=12" class="bigText"><BLINK>IMPORTANT Information on Swine Influenza for Staff</BLINK></a></td>
	</tr>
	<tr class="smallText">
		<td align="center">&nbsp;</td>
	</tr>
	<tr class="smallText">
		<td align="center"><a href="../documentManage/download.jsp?documentID=11" class="bigText"><BLINK>Background Information on Swine Influenza</BLINK></a></td>
	</tr>
</table>
<br><p><br>