<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>
<%@ page import="com.hkah.util.sms.UtilSMS"%>
<%@page import="org.json.JSONObject" %>
<%!
private HashMap<String, String> getMsgContent(String id) {
	HashMap<String, String> msgMap = new HashMap<String, String>();
	ArrayList<ReportableListObject> record = 
		UtilDBWeb.getReportableList("select LANGUAGE, DESCRIPTION from DESCRIPTION_MAPPING@IWEB where TYPE = 'EDFMSMS' AND ID = '"+id.toUpperCase()+"' AND ENABLE = 1");
	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			ReportableListObject row = (ReportableListObject) record.get(i);
			msgMap.put(row.getValue(0),row.getValue(1));
		}
	} 
	
	return msgMap;

}

private String getHPStatus(String status, String key) {

	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT HPRMK FROM HPSTATUS@IWEB WHERE HPTYPE = 'EDEFORM' AND HPSTATUS = UPPER('");
	sqlStr.append(status);
	sqlStr.append("') AND  HPKEY = UPPER('");
	sqlStr.append(key);
	sqlStr.append("')");

	ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr.toString());
	if (record.size() > 0) {
		ReportableListObject row = (ReportableListObject) record.get(0);
		return row.getValue(0);
	} else {
		return null;
	}
}

public  boolean isCaptchaValid(String secretKey, String response) {
    try {
        String url = "https://www.google.com/recaptcha/api/siteverify",
                params = "secret=" + secretKey + "&response=" + response;

        HttpURLConnection http = (HttpURLConnection) new URL(url).openConnection();
        http.setDoOutput(true);
        http.setRequestMethod("POST");
        http.setRequestProperty("Content-Type",
                "application/x-www-form-urlencoded; charset=UTF-8");
        OutputStream out = http.getOutputStream();
        out.write(params.getBytes("UTF-8"));
        out.flush();
        out.close();

        InputStream res = http.getInputStream();
        BufferedReader rd = new BufferedReader(new InputStreamReader(res, "UTF-8"));

        StringBuilder sb = new StringBuilder();
        int cp;
        while ((cp = rd.read()) != -1) {
            sb.append((char) cp);
        }
        JSONObject json = new JSONObject(sb.toString());
        res.close();
		System.out.println(sb.toString());
        return json.getBoolean("success");
    } catch (Exception e) {
        //e.printStackTrace();
    }
    return false;
}
%>
<%
UserBean userBean = new UserBean(request);
String type = request.getParameter("type");
String token = request.getParameter("token");
String name = request.getParameter("name");
String phone = request.getParameter("phone");
String ans = request.getParameter("ans");
String messageContentEN = null;
String messageContentCN = null;
boolean success =false;
int result = 0;
if ("verify".equals(type)) {
success = isCaptchaValid(getHPStatus("SECRETKEY","CAPTCHA"),token);
} else {
	Map<String, String>  msgMap = getMsgContent(ans);

	if (msgMap.size() > 0) {
		messageContentEN = msgMap.get("en").replace("{1}",name).replace("{2}",DateTimeUtil.getCurrentDate());
		messageContentCN = msgMap.get("zh-HK").replace("{1}",name).replace("{2}",DateTimeUtil.getCurrentDate());
	}
					
	 String resultIDen = UtilSMS.sendSMS(userBean, new String[] {phone},
			 messageContentEN,"TWMKT", null, null, null);
	 String resultIDchi = UtilSMS.sendSMS(userBean, new String[] {phone},
			 messageContentCN,"TWMKT", null, null, null);	
				
				
	 //if (resultID != null && resultID.length() > 0){			
		 result = EnrollmentDB.addExtClient("marketing","8445","1","online","external",
				 							null, null,name, null, "ETDEC",phone, ans).length();
						
	//}
}
%>
<%=success?success:result%>