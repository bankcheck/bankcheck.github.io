<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.ForwardScanningDB"%>
<%@ page import="com.hkah.web.db.model.FsCategory"%>
<%@ page import="com.hkah.web.db.helper.FsModelHelper"%>
<%
UserBean userBean = new UserBean(request);

String categoryID = request.getParameter("categoryID");
boolean isShowSubLvl = "Y".equals(request.getParameter("isShowSubLvl"));
boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));

List<ReportableListObject> record = ForwardScanningDB.getCategoryList();
FsCategory fsCategory = null;

if (allowEmpty) {
	String emptyLabel = request.getParameter("emptyLabel");
	if (emptyLabel == null) {
		emptyLabel = "";
	}
%><option value=""><%=emptyLabel %></option><%
}

if (record.size() > 0) {
	ReportableListObject rlo = null;
	for (int i = 0; i < record.size(); i++) {
		rlo = (ReportableListObject) record.get(i);
		
		// SELECT FS_CATEGORY_ID, FS_NAME, FS_PARENT_CATEGORY_ID, FS_SEQ, FS_IS_MULTI
		String thisCategoryID = rlo.getFields0();
		String name = rlo.getFields1();
		String pCategoryID = rlo.getFields2();
if (pCategoryID == null || pCategoryID.isEmpty() || (isShowSubLvl && pCategoryID != null)) {
%><option value="<%=thisCategoryID %>"<%=thisCategoryID.equals(categoryID)?" selected":"" %>><%=name %></option><%
}
	}
}
%>