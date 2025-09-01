<%@ page import="java.math.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%
UserBean userBean = new UserBean(request);

String command = ParserUtil.getParameter(request, "command");
int stageInt = 1;
try {
	stageInt = Integer.parseInt(ParserUtil.getParameter(request, "stage"));
} catch (Exception e) {}
String specialty = ParserUtil.getParameter(request, "specialty");
String clientID = ParserUtil.getParameter(request, "clientID");

/* step 3 */
String procedureFee = ParserUtil.getParameter(request, "procedureFee");
String procedureFeeAdditional = ParserUtil.getParameter(request, "procedureFeeAdditional");

String admissionDate = ParserUtil.getDate(request, "admissionDate");
String selectAnotherDate = ParserUtil.getDate(request, "selectAnotherDate");

String remark_hkah3 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remark_hkah3"));
String remark_ghc3 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remark_ghc3"));

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
		<td class="infoLabel" width="20%">HKAH <bean:message key="prompt.remarks" /></td>
		<td class="infoData" colspan="3">
<%	if (!isGHC && (createAction || updateAction)) { %>
			<textarea name="remark_hkah3" rows="3" cols="100"><%=remark_hkah3==null?"":remark_hkah3 %></textarea>
<%	} else { %>
			<%=remark_hkah3==null?"":remark_hkah3 %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">GHC <bean:message key="prompt.remarks" /></td>
		<td class="infoData" colspan="3">
<%	if (isGHC && (createAction || updateAction)) { %>
			<textarea name="remark_ghc3" rows="3" cols="100"><%=remark_ghc3==null?"":remark_ghc3 %></textarea>
<%	} else { %>
			<%=remark_ghc3==null?"":remark_ghc3 %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
	<td class="infoLabel" width="20%"></td>
	<td class="infoData" colspan="3"><button onclick="return submitAction('email', 1, 0);" class="btn-click">Send Email</button></td></tr>
<script language="javascript">
<!--
	function submitAction_step3(cmd, stp, conf) {

		return true;
	}
	
-->
</script>
