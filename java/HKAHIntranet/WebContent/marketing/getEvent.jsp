<%@ page language="java" contentType="application/json; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="org.json.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="java.io.PrintWriter" %>

<%@ page import="java.text.SimpleDateFormat" %>
<%!
public String getFileHtml(UserBean userBean,String keyID,String action){
	String path = "http://www-server/";
	if (ConstantsServerSide.isTWAH()) {
		path = "http://192.168.0.20/";
	}
	if (!"".equals(keyID)&& keyID!=null){
		ArrayList record = DocumentDB.getList(userBean,userBean.getSiteCode(),"marketing",
							keyID,null,0);
		if(record.size() > 0) {
			ReportableListObject row = (ReportableListObject)record.get(0);
			/* return "<li><span class=\"file\"><a href=\"http:\\192.168.0.20\\"+row.getValue(1)+"\\"+row.getValue(2)+
			"\" target=\"_blank\">"+row.getValue(2)+"</a></li>"; */
			return "<li><span class=\"file\"><a keyid=\""+keyID+"\" id=\"eventDoc\" class=\"d"+keyID+"_"+row.getValue(0)+"\" href=\""+path+row.getValue(1)+"/"+row.getValue(2)+
			"\" target=\"_blank\">"+row.getValue(2)+"</a> "
			+("update".equals(action)?"<img onclick=\"deleteAttach('"+keyID+"','"+row.getValue(0)+"')\" src=\"../images/delete3.png\" />":"")+"</li>";
		}else {
			return null;
		}
	}else {
		return null;
	}
}
%>
<%
	UserBean userBean = new UserBean(request);
	String callback = request.getParameter("callback");
	String startDate = request.getParameter("start");
	String endDate = request.getParameter("end");
	JSONArray jsonArray = new JSONArray();
	ReportableListObject row = null;
	String[] color = {"","w3-blue-grey","w3-light-blue",
			"w3-lime","w3-teal","w3-indigo","w3-Indigo","w3-Indigo","w3-Indigo",
			"w3-Indigo","w3-Indigo","w3-Indigo"};

	ArrayList record = UtilDBWeb.getFunctionResults("GET_MKTEVENT",
			new String[]{startDate,endDate});
	
	if(record.size() > 0) {
		for(int i = 0; i < record.size(); i++) {
			row = (ReportableListObject)record.get(i);
			JSONObject childJSON = new JSONObject();
			childJSON.put("id", row.getValue(0));
			childJSON.put("start", row.getValue(1));
			childJSON.put("end", row.getValue(2));
			childJSON.put("title", row.getValue(3));
			childJSON.put("type", row.getValue(5));
			childJSON.put("typeID", row.getValue(4));
			childJSON.put("desc", row.getValue(6));
			childJSON.put("dateDD", row.getValue(7));
			childJSON.put("dateMM", row.getValue(8));
			childJSON.put("dateYYYY", row.getValue(9));
			childJSON.put("fromHH", row.getValue(10));
			childJSON.put("fromMI", row.getValue(11));
			childJSON.put("toHH", row.getValue(12));
			childJSON.put("toMI", row.getValue(13));
			childJSON.put("className",row.getValue(17));
			childJSON.put("eventDate", row.getValue(14));
			childJSON.put("attachHtml", getFileHtml(userBean,row.getValue(16),"view"));
			childJSON.put("updateHtml", getFileHtml(userBean,row.getValue(16),"update"));
			childJSON.put("keyID", row.getValue(16));
			childJSON.put("locationID", row.getValue(18));
			childJSON.put("locationDesc", row.getValue(19));
			
			
			if(childJSON.length() > 0) {
				jsonArray.put(childJSON);
			}
		}
	}
		

	response.setContentType("application/json");
	PrintWriter writer = response.getWriter();
	writer.print(request.getParameter("callback")+"("+jsonArray.toString()+ ");");
	writer.close();
%>
