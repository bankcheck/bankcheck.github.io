<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String newsCategory = request.getParameter("newsCategory");
String newsID = request.getParameter("newsID");
int likeCount = -1;
try {
	likeCount = Integer.parseInt(request.getParameter("likeCount"));
} catch (Exception e) {}
String likeSelf = request.getParameter("likeSelf");
String action = request.getParameter("action");

if (likeCount == -1 && action != null) {
	NewsDB.updateLike(userBean, newsID, newsCategory, "like".equals(action));
}

ArrayList result = NewsDB.get(userBean, newsID, newsCategory);
if (result.size() > 0) {
	ReportableListObject row = (ReportableListObject) result.get(0);
	try {
		likeCount = Integer.parseInt(row.getValue(8));
	} catch (Exception e) {}
	likeSelf = row.getValue(9);
}

if (userBean.isLogin()) {
	%><br/><a href="javascript:void();" onclick="return likeMe('<%=newsCategory %>', '<%=newsID %>', '<%="1".equals(likeSelf) ? "un" : "" %>like');" class="topstoryblue"><%
	if ("1".equals(likeSelf)) {
		%>Unlike<%
	} else {
		%>Like<%
	}
	%></a><%
}
%><br/><img src="../images/like.gif">&nbsp;<%
if (likeCount == 0) {
	%>Do you like this?<%
} else {
	if (userBean.isLogin() && "1".equals(likeSelf)) {
		%>You<%
		if (likeCount > 1) {
			%> and <%=likeCount - 1 %> other<%
			if (likeCount > 2) {
				%>s<%
			}
		}
	} else {
		if (likeCount >= 1) {
			%><%=likeCount %> people<%
		}
	}
	%> like this.<%
}
%>