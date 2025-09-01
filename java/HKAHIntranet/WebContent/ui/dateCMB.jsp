<%@ page import="com.hkah.util.*"%>
<%@ page import="java.util.Date"%>
<%
String month_shortform[] = { "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC" };
boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));
boolean defaultValue = !"N".equals(request.getParameter("defaultValue"));
String label = request.getParameter("label");
String date = request.getParameter("date");
String yearRange = request.getParameter("yearRange");

boolean isMonthOnly = "Y".equals(request.getParameter("monthOnly"));
boolean isYearOnly = "Y".equals(request.getParameter("isYearOnly"));
boolean YearAndMonth = "Y".equals(request.getParameter("YearAndMonth"));

boolean isShowTime = "Y".equals(request.getParameter("showTime"));
boolean isAddYear = "Y".equals(request.getParameter("addYear"));
boolean isYearOrderDesc = "Y".equals(request.getParameter("isYearOrderDesc"));
boolean isObBkUse = "Y".equals(request.getParameter("isObBkUse"));
boolean isShowNextYear = "Y".equals(request.getParameter("isShowNextYear"));
boolean hideFutureYear = "Y".equals(request.getParameter("hideFutureYear"));
boolean isDetailedTime = "Y".equals(request.getParameter("isDetailedTime"));
boolean isFromCurrYear = "Y".equals(request.getParameter("isFromCurrYear"));
// set default value
int day_dd = 0;
int day_mm = 0;
int day_yy = 0;
int day_hh = 0;
int day_mi = 0;
int current_yy = DateTimeUtil.getCurrentYear();
int year_from = 1900;
if (isFromCurrYear) {
	year_from = current_yy;
}
int year_to = current_yy;
if (isShowNextYear) {
	year_to = DateTimeUtil.getCurrentYear()+1;

}
// set year range
if (yearRange != null && yearRange.length() > 0) {
	try {
		int yearRangeInt = Integer.parseInt(yearRange);
		if (isObBkUse) {
			year_from = 2010;
		} else {
			year_from = current_yy - yearRangeInt;
		}
		if (!hideFutureYear) {
			year_to = current_yy + yearRangeInt;
		}
	} catch (Exception e) {}
}

if (isMonthOnly || isYearOnly || YearAndMonth) {
	if (isYearOnly || YearAndMonth) {
		try {
			day_yy = Integer.parseInt(request.getParameter("day_yy"));
		} catch (Exception e) {
		}
	}
	if (isMonthOnly || YearAndMonth) {
		try {
			day_mm = Integer.parseInt(request.getParameter("day_mm"));
		} catch (Exception e) {
		}
	}
} else if (date != null) {
	try {
		day_dd = Integer.parseInt(date.substring(0, 2));
		day_mm = Integer.parseInt(date.substring(3, 5));
		day_yy = Integer.parseInt(date.substring(6, 10));
		if (date.length() >= 13) {
			day_hh = Integer.parseInt(date.substring(11, 13));
		}
		if (date.length() >= 16) {
			day_mi = Integer.parseInt(date.substring(14, 16));
		}
	} catch (Exception e) {
	}
}
if (defaultValue) {
	if (day_dd == 0) {
		day_dd = DateTimeUtil.getCurrentDay();
	}
	if (day_mm == 0) {
		day_mm = DateTimeUtil.getCurrentMonth();
	}
	if (day_yy == 0) {
		day_yy = current_yy;
	}
	if (day_hh == 0) {
		day_hh = DateTimeUtil.getCurrentHour();
	}
}
if (isAddYear) {
	day_yy++;
}

// year ordering
int incrFactor = 0;
int beginYear = 0;
int endYear = 0;
if (isYearOrderDesc) {
	// descending order
	incrFactor = -1;
	beginYear = year_to;
	endYear = year_from;
} else {
	// ascending order
	incrFactor = 1;
	beginYear = year_from;
	endYear = year_to;
}

String displayValue = null;
if (isMonthOnly || isYearOnly || YearAndMonth) {
	if (isYearOnly || YearAndMonth) {
%><select name="<%=label %>_yy" id="<%=label %>_yy">
<%if (allowEmpty) {
	%><option value=""></option><%
}	for (int k = beginYear; (endYear - k) * incrFactor >= 0 ; k += incrFactor) {
%><option value="<%=k %>"<%=day_yy==k?" selected":"" %>><%=k %></option><%} %>
</select><%
	}
	if (isMonthOnly || YearAndMonth) {
%><select name="<%=label %>_mm" id="<%=label %>_mm">
<%
if (allowEmpty) {
	%><option value=""></option><%
}
for (int j = 1; j <= 12; j++) {
		displayValue = (j<10?"0":"") + j;
%><option value="<%=displayValue %>"<%=day_mm==j?" selected":"" %>><%=month_shortform[j - 1] %></option><%} %>
</select><%
	}
} else {
%><select name="<%=label %>_dd" id="<%=label %>_dd">
<%if (allowEmpty) {
	%><option value=""></option><%
}	for (int i = 1; i <= 31; i++) {
		displayValue = (i<10?"0":"") + i;
%><option value="<%=displayValue %>"<%=day_dd==i?" selected":"" %>><%=displayValue %></option><%} %>
</select>/
<select name="<%=label %>_mm" id="<%=label %>_mm">
<%if (allowEmpty) {
	%><option value=""></option><%
}	for (int j = 1; j <= 12; j++) {
		displayValue = (j<10?"0":"") + j;
 %><option value="<%=displayValue %>"<%=day_mm==j?" selected":"" %>><%=month_shortform[j - 1] %></option>
<%	} %>
</select>/
<select name="<%=label %>_yy" id="<%=label %>_yy">
<%if (allowEmpty) {
	%><option value=""></option><%
}	for (int k = beginYear; (endYear - k) * incrFactor >= 0 ; k += incrFactor) {
%><option value="<%=k %>"<%=day_yy==k?" selected":"" %>><%=k %></option><%} %>
</select>
<%}
if (isShowTime) { %>
<select name="<%=label %>_hh" id="<%=label %>_hh">
<%if (allowEmpty) {
	%><option value=""></option><%
}	for (int l = 0; l <= 23; l++) {
		displayValue = (l<10?"0":"") + l;
%><option value="<%=displayValue %>"<%=day_hh==l?" selected":"" %>><%=displayValue %></option>
<%	} %>
</select>:<select name="<%=label %>_mi" id="<%=label %>_mi">
<%if (allowEmpty) {

	%><option value=""></option><%
}
if (isDetailedTime == true) {
	for(int i = 0;i<60 ;i++) {
		if (i < 10) {
%>
	<option value=<%=i%><%=day_mi==i?" selected":"" %>><%=0%><%=i%></option>
<%
		} else {
%>
	<option value=<%=i%><%=day_mi==i?" selected":"" %>><%=i%></option>
<%
		}
	}
} else {
%>
	<option value="00"<%=day_mi==00?" selected":"" %>>00</option>
	<option value="15"<%=day_mi==15?" selected":"" %>>15</option>
	<option value="30"<%=day_mi==30?" selected":"" %>>30</option>
	<option value="45"<%=day_mi==45?" selected":"" %>>45</option>
</select>
<%
}
}
%>