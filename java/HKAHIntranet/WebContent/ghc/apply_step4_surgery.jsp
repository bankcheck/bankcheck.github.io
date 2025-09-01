<%@ page import="java.math.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
UserBean userBean = new UserBean(request);

String command = ParserUtil.getParameter(request, "command");
int stageInt = 1;
try {
	stageInt = Integer.parseInt(ParserUtil.getParameter(request, "stage"));
} catch (Exception e) {}
String specialty = ParserUtil.getParameter(request, "specialty");
String clientID = ParserUtil.getParameter(request, "clientID");

String remark_hkah4 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remark_hkah4"));
String remark_ghc4 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remark_ghc4"));

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean addCommentAction = false;
boolean closeAction = false;
boolean letter1Action = false;
boolean letter2Action = false;

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
} else if ("letter1".equals(command)) {
	letter1Action = true;
} else if ("letter2".equals(command)) {
	letter2Action = true;
} else if ("addComment".equals(command)) {
	addCommentAction = true;
}

String allowRemove = createAction || updateAction ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE;

boolean isOB = "ob".equals(specialty);
boolean isSurgical = "surgical".equals(specialty);
boolean isHA = "ha".equals(specialty);
boolean isCardiac = "cardiac".equals(specialty);
boolean isOncology = "oncology".equals(specialty);

boolean isGHC = userBean.isAccessible("function.ghc.client.create");
boolean isPhysician = !isGHC && !userBean.isStaff();
boolean isHKAH = !isPhysician && !isGHC;
%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
	<tr class="smallText">
		<td class="infoTitle" colspan="4">Step 4. Registration</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">HKAH <bean:message key="prompt.remarks" /></td>
		<td class="infoData" colspan="3">
<%		if (!isGHC && (createAction || updateAction)) { %>
			<textarea name="remark_hkah4" rows="3" cols="100"><%=remark_hkah4==null?"":remark_hkah4 %></textarea>
<%		} else { %>
			<%=remark_hkah4==null?"":remark_hkah4 %>
<%		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">GHC <bean:message key="prompt.remarks" /></td>
		<td class="infoData" colspan="3">
<%		if (isGHC && (createAction || updateAction)) { %>
			<textarea name="remark_ghc4" rows="3" cols="100"><%=remark_ghc4==null?"":remark_ghc4 %></textarea>
<%		} else { %>
			<%=remark_ghc4==null?"":remark_ghc4 %>
<%		} %>
		</td>
	</tr>