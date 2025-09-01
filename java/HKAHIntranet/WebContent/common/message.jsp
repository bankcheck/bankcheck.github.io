<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%
String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");
%>
<%if (message != null && message.length() > 0) { %>
<div class="ui-widget">
	<div class="ui-state-highlight ui-corner-all" style="margin-top: 20px; padding: 0 .7em;"> 
		<p><span class="ui-icon ui-icon-info" style="float: left; margin-right: .3em;"></span>
		<strong>
<%		try { %>
			<bean:message key="<%=message %>" />
<%		} catch (Exception e) { %>
			<%=message %>
<%		} %>
		</strong></p>
	</div>
</div>
<%} %>
<%if (errorMessage != null && errorMessage.length() > 0) { %>
<div class="ui-widget">
	<div class="ui-state-error ui-corner-all" style="padding: 0 .7em;"> 
		<p><span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span> 
		<strong>
<%		try { %>
			<bean:message key="<%=errorMessage %>" />
<%		} catch (Exception e) { %>
			<%=errorMessage %>
<%		} %>
		</strong></p>
	</div>
</div>
<%} %>