<%@ page language="java" contentType="text/html; charset=utf-8" %><%@
page import="java.io.*"%><%@
page import="java.net.*"%><%
String locid = request.getParameter("locid");
String ticketNo = request.getParameter("ticketNo");
String pickupTime = request.getParameter("pickupTime");

StringBuffer URLContent = new StringBuffer();
URLContent.append("http://192.168.0.180:8080/jmsserver/jmsservlet?topicName=twah.prod.pts&message=");

try {
	StringBuffer parameters = new StringBuffer();
	parameters.append(locid);
	parameters.append("<JMS/><JMS/>");
	parameters.append(ticketNo);
	parameters.append("<JMS/>");
	parameters.append(pickupTime);
	parameters.append("<JMS/>");
	URLContent.append(URLEncoder.encode(parameters.toString()));
} catch (Exception e) {
}

URL postURL = null;
HttpURLConnection conn = null;
BufferedReader rd = null;
String line = null;
StringBuffer result = new StringBuffer();
try {
	postURL = new URL(URLContent.toString());
	conn = (HttpURLConnection) postURL.openConnection();
	conn.setRequestMethod("GET");
	conn.setRequestProperty("Content-Type", "text/html; charset=UTF-8");
	rd = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF8"));
	while ((line = rd.readLine()) != null) {
		result.append(line);
	}
	rd.close();
} catch (MalformedURLException e) {
	e.printStackTrace();
}
%>