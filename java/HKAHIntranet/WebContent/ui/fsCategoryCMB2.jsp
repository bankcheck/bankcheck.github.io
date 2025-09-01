<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.ForwardScanningDB"%>
<%@ page import="com.hkah.web.db.model.FsCategory"%>
<%@ page import="com.hkah.web.db.helper.FsModelHelper"%>
<%
UserBean userBean = new UserBean(request);

String categoryID = request.getParameter("categoryID");
boolean isShowSubLvl = "Y".equals(request.getParameter("isShowSubLvl"));

List<ReportableListObject> record = ForwardScanningDB.getCategoryList();
FsCategory fsCategory = null;

if (record.size() > 0) {
%>
<div class="categoryIDs-con">
<%
	ReportableListObject rlo = null;
	for (int i = 0; i < record.size(); i++) {
		rlo = (ReportableListObject) record.get(i);
		
		// SELECT FS_CATEGORY_ID, FS_NAME, FS_PARENT_CATEGORY_ID, FS_SEQ, FS_IS_MULTI
		String thisCategoryID = rlo.getFields0();
		String name = rlo.getFields1();
		String pCategoryID = rlo.getFields2();
if (pCategoryID == null || pCategoryID.isEmpty() || (isShowSubLvl && pCategoryID != null)) {
%>
	<input class="" type="radio" name="categoryID" id="cat-<%=thisCategoryID %>" value="<%=thisCategoryID %>"<%=thisCategoryID.equals(categoryID)?" selected":"" %>></input>
	<label for="cat-<%=thisCategoryID %>"><%=name %></label>
<%
}
	}
%>
</div>
<%
}
%>