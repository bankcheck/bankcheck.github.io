<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.* "%>
<%
String hospnum = request.getParameter("hospnum");
String labnum = request.getParameter("labnum");
UserBean userBean = new UserBean(request);
String command = request.getParameter("command");
//String selectFrom = request.getParameter("selectFrom");


if (userBean.isAccessible("function.ic.ge_resp." + command) || userBean.isAccessible("function.ic.bld_mrsa_esbl." + command)) {
	//ArrayList<ReportableListObject> record = UtilDBWeb.getFunctionResults("HAT_CMB_DOCTOR");
	ArrayList record = IcGeRespDB.getPatInfoByHospNum(userBean, hospnum);
	
	ReportableListObject row = null;
	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			%><option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(labnum)?" selected":"" %>><%=row.getValue(0)%></option><%
		}
	}
} %>