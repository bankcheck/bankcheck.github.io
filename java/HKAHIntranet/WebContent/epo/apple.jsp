<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.mail.*"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.util.*"%>
<%@ page import="javax.mail.*"%>
<%@ page import="javax.mail.internet.*"%>
<%@ page import="java.net.MalformedURLException"%>
<%@ page import="java.net.URL"%>
<%@ page import="java.security.cert.Certificate"%>
<%@ page import="java.io.*"%>
<%@ page import="javax.net.ssl.HttpsURLConnection"%>
<%@ page import="javax.net.ssl.SSLPeerUnverifiedException"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.parser.JSONParser"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);
String dirName = null;
String testfolder = request.getParameter("testfolder");
dirName = "\\\\hkim\\im\\VPMA\\Credential Renew Document\\"+testfolder;	

//For test
//String dirName = "\\\\ahhk.local\\ah\\IT it\\"+docCode+"-"+docSmtDate;

File f1 = new File(dirName);

String folderPathDest1 = "\\\\hkim\\im\\VPMA\\Credential Renew Document";
String folderPathDest2 = testfolder;
boolean status;
status = new File(folderPathDest1+File.separator+folderPathDest2).mkdir();
System.err.println("[dirName]:"+dirName+"[status]"+status);
%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%!
private static String getContent(String urlStr){
    URL url;
    String content = null;
    
    try {
	     url = new URL(urlStr);
	     HttpsURLConnection con = (HttpsURLConnection)url.openConnection();

	     //dumpl all cert info
	     //print_https_cert(con);

	     //dump all the content
	     content = getContent(con);
	     //System.out.println("content size = " + content.length());
    } catch (Exception e) {
	     //e.printStackTrace();
	     content = "E02: " + e.getMessage() + ", content="+content;
	     
	     //System.out.println("ERROR content="+content);
   }
	return content;
 }

 private static void print_https_cert(HttpsURLConnection con){

  if(con!=null){

    try {

	System.out.println("Response Code : " + con.getResponseCode());
	System.out.println("Cipher Suite : " + con.getCipherSuite());
	System.out.println("\n");

	Certificate[] certs = con.getServerCertificates();
	for(Certificate cert : certs){
	   System.out.println("Cert Type : " + cert.getType());
	   System.out.println("Cert Hash Code : " + cert.hashCode());
	   System.out.println("Cert Public Key Algorithm : " 
                                  + cert.getPublicKey().getAlgorithm());
	   System.out.println("Cert Public Key Format : " 
                                  + cert.getPublicKey().getFormat());
	   System.out.println("\n");
	}

	} catch (SSLPeerUnverifiedException e) {
		e.printStackTrace();
	} catch (IOException e){
		e.printStackTrace();
	}

   }

 }

 private static String getContent(HttpsURLConnection con) {
	 String input = "";
	 String ret = "";

	if(con!=null){
		
		try {
		   //System.out.println("****** Content of the URL ********");			
		   BufferedReader br = 
			new BufferedReader(
				new InputStreamReader(con.getInputStream()));
	
		   while ((input = br.readLine()) != null){
		      //System.out.println(input);
			   ret += input;
		   }
		   br.close();
		   
		} catch (Exception e) {
		   //e.printStackTrace();
		   ret = "E01: " + e.getMessage() + ", ret="+ret;
		}

     }
	return ret;
 }
 
	private static Map<String, Set<String>> getAvaSiteModels(String jsonStr) {
		JSONParser parser=new JSONParser();
		
		String timestamp = null;
		Map<String, Set<String>> stocks = new HashMap<String, Set<String>>();
		
		if (jsonStr != null && !jsonStr.isEmpty()) {
			if (jsonStr.startsWith("E")) {
				Set<String> errMsg = new HashSet<String>();
				errMsg.add(jsonStr);
				stocks.put("(ERROR)", errMsg);
			} else {
				
				try {
				  Object obj=parser.parse(jsonStr);
				  
				  JSONObject parent=(JSONObject)obj;
				 
				  if (parent.size() == 0) {
					  throw new Exception("Check availability out of service");
				  }
				  
				  Set key = parent.keySet();
				  Iterator itr = (Iterator) key.iterator();
				  while (itr.hasNext()) {
					  Object i = itr.next();
					  //System.out.println(i + " = " + parent.get(i));
					  
					  if ("updated".equals(i)) {
						  timestamp = ((Long) parent.get(i)).toString();
					  } else {
						  JSONObject siteObj = (JSONObject) parent.get(i);
						  String site = (String) i;
						  
						  //System.out.println(" SITE:  " + i );
						  
						  // get site stocks
						  Set key2 = siteObj.keySet();
						  Iterator itr2 = (Iterator) key2.iterator();
						  while (itr2.hasNext()) {
							  Object i2 = itr2.next();
							  Boolean isOpen = (Boolean) siteObj.get(i2);
							  //System.out.println("   " + i2 + " = " + isOpen);
							  if(isOpen) {
								  String model = (String) i2;
								  Set<String> models = stocks.get(site);
								  if (models == null) {
									  models = new LinkedHashSet<String>();
									  models.add(i2.toString());
									  stocks.put(site, models);
								  } else {
									  models.add(model);
								  }
							  }
						  }
					  }
				  }
				  
				  //System.out.println("Timestamp="+timestamp);
				  //System.out.println("Models available:");
				  /*
				  Set<String> key3 = stocks.keySet();
				  Iterator<String> itr3 = (Iterator) key3.iterator();
				  while (itr3.hasNext()) {
					  String site = itr3.next();
					  System.out.println("Site:"+site);
					  Set<String> models = stocks.get(site);
					  
					  Iterator<String> itr5 = models.iterator();
					  while (itr5.hasNext()) {
						  String model = itr5.next();
						  System.out.println(" model:"+model);
					  }
				  }
					*/
		      } catch (Exception e) {
				    // e.printStackTrace();
				     
					Set<String> errMsg = new HashSet<String>();
					errMsg.add("E03: " + e.getMessage() +", jsonStr="+jsonStr);
					stocks.put("(ERROR)", errMsg);
			  }
			}
		}
		return stocks;
	}
	
	static Map<String, String> sites = new HashMap<String, String>();
	static {
		sites.put("R485", "Festival Walk");
		sites.put("R409", "Causeway Bay");
		sites.put("R428", "ifc mall");
	}
	
	static Map<String, String> models = new HashMap<String, String>();
	static {
        models.put("MG472ZP/A", "ip6 grey 16G");
        models.put("MG482ZP/A", "ip6 silver 16G");
        models.put("MG492ZP/A", "ip6 silver 16G");
        models.put("MG4F2ZP/A", "ip6 grey 64G");
        models.put("MG4H2ZP/A", "ip6 silver 64G");
        models.put("MG4J2ZP/A", "ip6 gold 64G");
        models.put("MG4A2ZP/A", "ip6 grey 128G");
        models.put("MG4C2ZP/A", "ip6 silver 128G");
        models.put("MG4E2ZP/A", "ip6 gold 128G");
        models.put("MGA82ZP/A", "ip6+ grey 16G");
        models.put("MGA92ZP/A", "ip6+ silver 16G");
        models.put("MGAA2ZP/A", "ip6+ gold 16G");
        models.put("MGAH2ZP/A", "ip6+ grey 64G");
        models.put("MGAJ2ZP/A", "ip6+ silver 64G");
        models.put("MGAK2ZP/A", "ip6+ gold 64G");
        models.put("MGAC2ZP/A", "ip6+ grey 128G");
        models.put("MGAE2ZP/A", "ip6+ silver 128G");
        models.put("MGAF2ZP/A", "ip6+ gold 128G");

	}
	
	private static String decodeSite(String site){
		
		String siteName = sites.get(site);
		if (siteName == null) {
			siteName = site;
		}
		return siteName;
	}
	
	private static String decodeModel(String model){
		String modelName = models.get(model);
		if (modelName == null) {
			modelName = model;
		}
		return modelName;
	}
%>
<%
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	String https_url = "https://reserve.cdn-apple.com/HK/en_HK/reserve/iPhone/availability.json";
	String testStr = "{ \"R485\" : { \"MGAF2ZP/A\" : true, \"MG492ZP/A\" : true, \"MGAC2ZP/A\" : true, \"MGA92ZP/A\" : false, \"MG4F2ZP/A\" : false, \"MG472ZP/A\" : false, \"MG4A2ZP/A\" : false, \"MGAK2ZP/A\" : false, \"MGAA2ZP/A\" : false, \"MG4J2ZP/A\" : false, \"MGAJ2ZP/A\" : false, \"MG4H2ZP/A\" : true, \"MGAE2ZP/A\" : true, \"MG4E2ZP/A\" : true, \"MG482ZP/A\" : true, \"MGAH2ZP/A\" : true, \"MG4C2ZP/A\" : true, \"MGA82ZP/A\" : true }, \"R409\" : { \"MGAF2ZP/A\" : true, \"MG492ZP/A\" : true, \"MGAC2ZP/A\" : true, \"MGA92ZP/A\" : true, \"MG4F2ZP/A\" : true, \"MG472ZP/A\" : true, \"MG4A2ZP/A\" : true, \"MGAK2ZP/A\" : true, \"MGAA2ZP/A\" : true, \"MG4J2ZP/A\" : true, \"MGAJ2ZP/A\" : true, \"MG4H2ZP/A\" : true, \"MGAE2ZP/A\" : false, \"MG4E2ZP/A\" : false, \"MG482ZP/A\" : true, \"MGAH2ZP/A\" : true, \"MG4C2ZP/A\" : true, \"MGA82ZP/A\" : true }, \"updated\" : 1411204620127, \"R428\" : { \"MGAF2ZP/A\" : true, \"MG492ZP/A\" : true, \"MGAC2ZP/A\" : true, \"MGA92ZP/A\" : false, \"MG4F2ZP/A\" : false, \"MG472ZP/A\" : false, \"MG4A2ZP/A\" : false, \"MGAK2ZP/A\" : false, \"MGAA2ZP/A\" : false, \"MG4J2ZP/A\" : true, \"MGAJ2ZP/A\" : false, \"MG4H2ZP/A\" : false, \"MGAE2ZP/A\" : false, \"MG4E2ZP/A\" : true, \"MG482ZP/A\" : false, \"MGAH2ZP/A\" : false, \"MG4C2ZP/A\" : false, \"MGA82ZP/A\" : false }}";
	String isTest = request.getParameter("t");
	
	Exception ex = null;
	Map<String, Set<String>> stocks = null;

	if ("1".equals(isTest)) {
   		stocks = getAvaSiteModels(testStr);
	} else {
		stocks = getAvaSiteModels(getContent(https_url));
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>checkStock</title>
</head>
<body>
<%
if ("1".equals(isTest)) {
%>
-- DEMO ONLY --
<%
}
%>

<%
boolean isOpen = false;

if (stocks == null || stocks.isEmpty()) {
%>
<div>(<%=sdf.format(new Date()) %>)<button id="timer_c" onclick="controlTimer();">Pause</button></div>
<div>NONE AVAILABLE</div>
<%
} else {
%>
<div>(<%=sdf.format(new Date()) %>)<button id="timer_c" onclick="controlTimer();">Pause</button></div>
<hr />
<%
Set<String> key3 = stocks.keySet();
Iterator<String> itr3 = (Iterator) key3.iterator();
while (itr3.hasNext()) {
	  String site = itr3.next();
	  if (site.startsWith("R")) {
		  isOpen = true;
	  }
 %>
 <div style="font-weight: bold; font: #FF0000;"><%=decodeSite(site) %></div>
 <%
	  Set<String> models = stocks.get(site);
	  
	  Iterator<String> itr5 = models.iterator();
	  while (itr5.hasNext()) {
		  String model = itr5.next();
		  %>
		  <div style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;<%=decodeModel(model) %></div>
		  <%		  
	  }
	  
	  %>
	  <br />
	  <%	  
}

}
%>
<script language="JavaScript">

//setTimeout('myrefresh()',1000); //reload

function Timer(callback, delay) {
    var timerId, start, remaining = delay;

    this.pause = function() {
        window.clearTimeout(timerId);
        remaining -= new Date() - start;
        isRunning = false;
    };

    this.resume = function() {
        start = new Date();
        timerId = window.setTimeout(callback, remaining);
        isRunning = true;
    };

    
    this.resume();
}
var isRunning = false;
var timer = new Timer(function myrefresh()
{
	window.location.reload();
	}, 2000);

function controlTimer(stop) {
	if (stop || isRunning) {
		timer.pause();
		document.getElementById("timer_c").innerHTML = 'Resume';
	} else {
		timer.resume();
		document.getElementById("timer_c").innerHTML = 'Pause';
	}
}
<%
if (isOpen) {
%>
controlTimer(true);
document.getElementById("timer_c").innerHTML = 'Resume';
window.open("https://reserve-hk.apple.com/HK/en_HK/reserve/iPhone");
<%
}
%>
</script>
</body>
</html>