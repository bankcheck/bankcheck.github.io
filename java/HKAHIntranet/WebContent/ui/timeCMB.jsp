<%@ page import="com.hkah.util.*"%>
<%@ page import="java.util.Date"%>
<%
String label = request.getParameter("label");
String time = request.getParameter("time");
boolean defaultValue = "Y".equals(request.getParameter("defaultValue"));
boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));
boolean isDisabled = "Y".equals(request.getParameter("isDisabled"));

int interval = 1;
try {
	interval = Integer.parseInt(request.getParameter("interval"));
} catch (Exception e) {}
int startfrom = 0;
try {
	startfrom = Integer.parseInt(request.getParameter("startfrom"));
} catch (Exception e) {}

// set default value
int day_hh_default = DateTimeUtil.getCurrentHour();
int day_mi_default = 0;
int day_hh = -1;
int day_mi = -1;

if (time != null) {
	try {
		day_hh = Integer.parseInt(time.substring(0, 2));
	} catch (Exception e) {
		day_hh = day_hh_default;
	}

	try {
		day_mi = Integer.parseInt(time.substring(3, 5));
	} catch (Exception e) {
		day_mi = day_mi_default;
	}
} else {
	day_hh = day_hh_default;
	day_mi = day_mi_default;
}

if (day_hh == day_hh_default && day_hh + startfrom <= 23) {
	day_hh += startfrom;
}

String displayValue = null;
%>
<select name="<%=label %>_hh" <%=(isDisabled?"disabled":"") %> class="notEmpty">
<%if (allowEmpty) {
	%><option value=""></option><%
}
	for (int l=0; l<24; l++) {
		displayValue = (l<10?"0":"") + l;
%><option value="<%=displayValue %>"<%=day_hh==l?" selected":"" %>><%=displayValue %></option>
<%	} %>
</select>:<select name="<%=label %>_mi" <%=(isDisabled?"disabled":"") %> class="notEmpty">
<%if (allowEmpty) {
	%><option value=""></option><%
}
	for (int l=0; l<=59; l+=interval) {
		displayValue = (l<10?"0":"") + l;
%><option value="<%=displayValue %>"<%=day_mi==l?" selected":"" %>><%=displayValue %></option>
<%	} %>
</select>

