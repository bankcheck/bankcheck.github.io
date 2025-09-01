<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.model.FsForm"%>
<%@ page import="com.hkah.web.db.helper.FsModelHelper"%>
<%
UserBean userBean = new UserBean(request);

String formCode = request.getParameter("formCode");
String orderBy = request.getParameter("orderBy");
Set<String> ignoreDeptCodes = new HashSet<String>();
boolean allowAll = "Y".equals(request.getParameter("allowAll"));
boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));

List<FsForm> record = FsModelHelper.searchFsForm(null, null, null, null, null, null, "FS_FORM_CODE");
FsForm fsForm = null;

if (allowEmpty) {
	String emptyLabel = request.getParameter("emptyLabel");
	if (emptyLabel == null) {
		emptyLabel = "";
	}
%><option value=""><%=emptyLabel %></option><%
}
if (allowAll) {
	String allLabel = request.getParameter("allLabel");
	if (allLabel == null) {
		allLabel = "-- All --";
	}
%><option value=""><%=allLabel %></option><%
}
if (record.size() > 0) {
	List<FsForm> final_result = new ArrayList<FsForm>();
	Set<String> distinctFormCode = new HashSet<String>();
	for (int i = 0; i < record.size(); i++) {
		fsForm = (FsForm) record.get(i);
		String thisFormCode = fsForm.getFsFormCode();
		String thisFormName = fsForm.getFsFormName();
		
		if (distinctFormCode.add(thisFormCode + "-" + thisFormName)) {
%><option value="<%=fsForm.getFsFormCode() %>"<%=thisFormCode.equals(formCode)?" selected":"" %>><%=thisFormCode %> - <%=thisFormName %></option><%
		}
	}
}
%>