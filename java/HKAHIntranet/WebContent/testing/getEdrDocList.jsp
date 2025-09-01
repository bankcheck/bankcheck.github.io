<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%@ page import="com.hkah.web.db.model.EdrDoctor" %>
<%@ page import="com.hkah.util.ServerUtil"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ page language="java" import="org.json.*" %>
<%@ page language="java" import="java.util.*" %>
<%!

public static String getUrlJson(String url, String queryString) {
    //String sJava="\\u0048\\u0065\\u006C\\u006C\\u006F";
	//String sJava = "{\"draw\":\"1\",\"recordsTotal\":1617,\"recordsFiltered\":1617,\"data\":[{\"name_chi\":\"\\u65b9\\u9053\\u751f\",\"name_eng\":\"Fong To Sang, Dawson\",\"gender\":\"\\u7537\",\"practice\":\"\\u79c1\\u4eba\\u57f7\\u696d\",\"address_chi\":\"\\u9999\\u6e2f\\u7687\\u540e\\u5927\\u9053\\u4e2d70\\u865f\\u5361\\u4f5b\\u5927\\u5ec811\\u6a131101\\u5ba4\",\"district\":\"\\u4e2d\\u897f\\u5340\",\"phone\":\"28016368\",\"voucher\":false,\"ppi\":true,\"ehealth\":false,\"ecard\":true,\"night\":false,\"speciality_name_chi\":\"\\u897f\\u91ab\",\"sub_speciality_name_chi\":\"\\u8166\\u5916\\u79d1\",\"doctor_title_chi\":\"\\u91ab\\u751f\",\"url\":\"\\/doctor\\/info\\/fong-to-sang-dawson-a\"},{\"name_chi\":\"\\u9ea5\\u68e8\\u8afe\",\"name_eng\":\"Mak Kai Lok, Gregory\",\"gender\":\"\\u7537\",\"practice\":\"\\u79c1\\u4eba\\u57f7\\u696d\",\"address_chi\":\"\\u9999\\u6e2f\\u4e2d\\u74b0\\u7687\\u540e\\u5927\\u9053\\u4e2d36\\u865f\\u8208\\u744b\\u5927\\u5ec812\\u6a131201A\\u5ba4\",\"district\":\"\\u4e2d\\u897f\\u5340\",\"phone\":\"26876777\",\"voucher\":false,\"ppi\":false,\"ehealth\":false,\"ecard\":true,\"night\":false,\"speciality_name_chi\":\"\\u897f\\u91ab\",\"sub_speciality_name_chi\":\"\\u7cbe\\u795e\\u79d1\",\"doctor_title_chi\":\"\\u91ab\\u751f\",\"url\":\"\\/doctor\\/info\\/mak-kai-lok-gregory\"},{\"name_chi\":\"\\u718a\\u5049\\u6c11\",\"name_eng\":\"Hung Wai Man\",\"gender\":\"\\u7537\",\"practice\":\"\\u79c1\\u4eba\\u57f7\\u696d\",\"address_chi\":\"\\u9999\\u6e2f\\u7687\\u540e\\u5927\\u9053\\u4e2d70\\u865f\\u5361\\u4f5b\\u5927\\u5ec811\\u6a131101-2\\u5ba4\",\"district\":\"\\u4e2d\\u897f\\u5340\",\"phone\":\"28016368\",\"voucher\":false,\"ppi\":false,\"ehealth\":false,\"ecard\":true,\"night\":false,\"speciality_name_chi\":\"\\u897f\\u91ab\",\"sub_speciality_name_chi\":\"\\u8166\\u5916\\u79d1\",\"doctor_title_chi\":\"\\u91ab\\u751f\",\"url\":\"\\/doctor\\/info\\/hung-wai-man\"},{\"name_chi\":\"\\u9673\\u51f1\\u6021\",\"name_eng\":\"Chan Hoi Yee\",\"gender\":\"\\u5973\",\"practice\":\"\\u79c1\\u4eba\\u57f7\\u696d\",\"address_chi\":\"\\u9999\\u6e2f\\u4e2d\\u74b0\\u7687\\u540e\\u5927\\u9053\\u4e2d36\\u865f\\u8208\\u744b\\u5927\\u5ec811\\u6a131101\\u5ba4\",\"district\":\"\\u4e2d\\u897f\\u5340\",\"phone\":\"39558113\",\"voucher\":true,\"ppi\":true,\"ehealth\":false,\"ecard\":true,\"night\":false,\"speciality_name_chi\":\"\\u897f\\u91ab\",\"sub_speciality_name_chi\":\"\\u773c\\u79d1\",\"doctor_title_chi\":\"\\u91ab\\u751f\",\"url\":\"\\/doctor\\/info\\/chan-hoi-yee\"},{\"name_chi\":\"\\u5b8b\\u6c38\\u6b0a\",\"name_eng\":\"Sung Wing Kuen\",\"gender\":\"\\u7537\",\"practice\":\"\\u79c1\\u4eba\\u57f7\\u696d\",\"address_chi\":\"\\u9999\\u6e2f\\u4e2d\\u74b0\\u7687\\u540e\\u5927\\u9053\\u4e2d70\\u865f\\u5361\\u4f5b\\u5927\\u5ec814\\u6a131401\\u5ba4\",\"district\":\"\\u4e2d\\u897f\\u5340\",\"phone\":\"25301098\",\"voucher\":true,\"ppi\":true,\"ehealth\":false,\"ecard\":true,\"night\":false,\"speciality_name_chi\":\"\\u897f\\u91ab\",\"sub_speciality_name_chi\":\"\\u7cbe\\u795e\\u79d1\",\"doctor_title_chi\":\"\\u91ab\\u751f\",\"url\":\"\\/doctor\\/info\\/sung-wing-kuen\"},{\"name_chi\":\"\\u9673\\u6137\\u6021\",\"name_eng\":\"Chan Hoi Yee, Karina\",\"gender\":\"\\u5973\",\"practice\":\"\\u79c1\\u4eba\\u57f7\\u696d\",\"address_chi\":\"\\u4e2d\\u74b0\\u7687\\u540e\\u5927\\u9053\\u4e2d38-48\\u865f\\u842c\\u5e74\\u5927\\u5ec81104\\u5ba4\",\"district\":\"\\u4e2d\\u897f\\u5340\",\"phone\":\"28017028\",\"voucher\":false,\"ppi\":true,\"ehealth\":false,\"ecard\":false,\"night\":false,\"speciality_name_chi\":\"\\u897f\\u91ab\",\"sub_speciality_name_chi\":\"\\u7cbe\\u795e\\u79d1\",\"doctor_title_chi\":\"\\u91ab\\u751f\",\"url\":\"\\/doctor\\/info\\/chan-hoi-yee-karina\"},{\"name_chi\":\"\\u5f35\\u6f22\\u5947\",\"name_eng\":\"Cheung Hon Kee, Henry\",\"gender\":\"\\u7537\",\"practice\":\"\\u79c1\\u4eba\\u57f7\\u696d\",\"address_chi\":\"\\u9999\\u6e2f\\u4e2d\\u74b0\\u7687\\u540e\\u5927\\u9053\\u4e2d70\\u865f\\u5361\\u4f5b\\u5927\\u5ec814\\u6a131406-1407\\u5ba4\",\"district\":\"\\u4e2d\\u897f\\u5340\",\"phone\":\"23339881\",\"voucher\":false,\"ppi\":true,\"ehealth\":false,\"ecard\":false,\"night\":false,\"speciality_name_chi\":\"\\u897f\\u91ab\",\"sub_speciality_name_chi\":\"\\u7cbe\\u795e\\u79d1\",\"doctor_title_chi\":\"\\u91ab\\u751f\",\"url\":\"\\/doctor\\/info\\/cheung-hon-kee-henry\"},{\"name_chi\":\"\\u6e90\\u65ed\",\"name_eng\":\"Leonard Yuen\",\"gender\":\"\\u7537\",\"practice\":\"\\u79c1\\u4eba\\u57f7\\u696d\",\"address_chi\":\"\\u9999\\u6e2f\\u4e2d\\u74b0\\u7687\\u540e\\u5927\\u9053\\u4e2d18\\u865f\\u65b0\\u4e16\\u754c\\u5927\\u5ec8\\u7b2c\\u4e8c\\u671f9\\u6a13\",\"district\":\"\\u4e2d\\u897f\\u5340\",\"phone\":\"25263333\",\"voucher\":true,\"ppi\":true,\"ehealth\":false,\"ecard\":false,\"night\":false,\"speciality_name_chi\":\"\\u897f\\u91ab\",\"sub_speciality_name_chi\":\"\\u773c\\u79d1\",\"doctor_title_chi\":\"\\u91ab\\u751f\",\"url\":\"\\/doctor\\/info\\/leonard-yuen-b\"},{\"name_chi\":\"\\u5f35\\u9038\\u548c\",\"name_eng\":\"Cheung Yat Wo, Eric\",\"gender\":\"\\u7537\",\"practice\":\"\\u79c1\\u4eba\\u57f7\\u696d\",\"address_chi\":\"\\u9999\\u6e2f\\u4e2d\\u74b0\\u7687\\u540e\\u5927\\u9053\\u4e2d70\\u865f\\u5361\\u4f5b\\u5927\\u5ec820\\u6a132006\\u5ba4\",\"district\":\"\\u4e2d\\u897f\\u5340\",\"phone\":\"28017088\",\"voucher\":false,\"ppi\":true,\"ehealth\":false,\"ecard\":false,\"night\":false,\"speciality_name_chi\":\"\\u897f\\u91ab\",\"sub_speciality_name_chi\":\"\\u7cbe\\u795e\\u79d1\",\"doctor_title_chi\":\"\\u91ab\\u751f\",\"url\":\"\\/doctor\\/info\\/cheung-yat-wo-eric\"},{\"name_chi\":\"\\u65b9\\u838e\\u8389\",\"name_eng\":\"FERGUSON SALLY ANNE\",\"gender\":\"\\u5973\",\"practice\":\"\\u79c1\\u4eba\\u57f7\\u696d\",\"address_chi\":\"\\u4e2d\\u74b0\\u5fb7\\u5df1\\u7b20\\u88571\\u865f\\u4e16\\u7d00\\u5ee3\\u58345\\u6a13\",\"district\":\"\\u4e2d\\u897f\\u5340\",\"phone\":\"25213181\",\"voucher\":false,\"ppi\":false,\"ehealth\":false,\"ecard\":false,\"night\":false,\"speciality_name_chi\":\"\\u897f\\u91ab\",\"sub_speciality_name_chi\":\"\\u5a66\\u7522\\u79d1\",\"doctor_title_chi\":\"\\u91ab\\u751f\",\"url\":\"\\/doctor\\/info\\/ferguson-sally-anne\"}]}";
	
	String ret = null;
	
    System.out.println("  (getUrlJson) url=" + url);
    
    try {
    	ret = ServerUtil.connectServer(url, queryString);
    } catch (Exception e) {
    	System.out.println("  (getUrlJson) fail to get response:" + e.getMessage());
    	ret = e.getMessage();
    }
    
    return ret;
}

public static String unescapeUnicode(String text) {
    // text="\\u0048\\u0065\\u006C\\u006C\\u006F";
    return StringEscapeUtils.unescapeJava(text);
}

public static List<EdrDoctor> getDocObject(String jsonString) {
	
	List<EdrDoctor> docList = new ArrayList<EdrDoctor>();
	try {
		

		JSONObject content = new JSONObject(jsonString);
		Iterator itr = null;
		/*
		itr = content.keys();
		while (itr.hasNext()) {
			String key = (String) itr.next();
			System.out.println(" key=" + key);
		}
		*/
		int recordsTotal = content.getInt("recordsTotal");
		System.out.println(" recordsTotal=" + recordsTotal);
		
		EdrDoctor doc = null;
		JSONArray data = (JSONArray) content.get("data");
		
		for (int i = 0; i < data.length(); i++) {
			JSONObject docObj = (JSONObject) data.get(i);
			
			//System.out.println(" Doc[" + (i + 1) + "]");
			/*
			itr = docObj.keys();
			while (itr.hasNext()) {
				String key = (String) itr.next();
				System.out.print("key=" + key + ", ");
			}
			System.out.println("");
			*/
			doc = new EdrDoctor();
			try {
				doc.setName_chi(docObj.getString("name_chi"));
			} catch (Exception e) {
				System.out.print("i=" + i + ", name_chi " + e.getMessage());
			}
			try {
				doc.setName_eng(docObj.getString("name_eng"));
			} catch (Exception e) {
				System.out.print("i=" + i + ", name_eng " + e.getMessage());
			}
			try {
				doc.setGender(docObj.getString("gender"));
			} catch (Exception e) {
				System.out.print("i=" + i + ", gender " + e.getMessage());
			}
			try {
				doc.setPractice(docObj.getString("practice"));
			} catch (Exception e) {
				System.out.print("i=" + i + ", practice " + e.getMessage());
			}
			try {
				doc.setAddress_chi(docObj.getString("address_chi"));
			} catch (Exception e) {
				System.out.print("i=" + i + ", address_chi " + e.getMessage());
			}
			try {
				doc.setDistrict(docObj.getString("district"));
			} catch (Exception e) {
				System.out.print("i=" + i + ", district " + e.getMessage());
			}
			try {
				doc.setPhone(docObj.getString("phone"));
			} catch (Exception e) {
				System.out.print("i=" + i + ", phone " + e.getMessage());
			}
			try {
				doc.setSpeciality_name_chi(docObj.getString("speciality_name_chi"));
			} catch (Exception e) {
				System.out.print("i=" + i + ", speciality_name_chi " + e.getMessage());
			}
			try {
				doc.setSub_speciality_name_chi(docObj.getString("sub_speciality_name_chi"));
			} catch (Exception e) {
				System.out.print("i=" + i + ", sub_speciality_name_chi " + e.getMessage());
			}
			try {
				doc.setDoctor_title_chi(docObj.getString("doctor_title_chi"));
			} catch (Exception e) {
				System.out.print("i=" + i + ", doctor_title_chi " + e.getMessage());
			}
			try {
				doc.setUrl(docObj.getString("url"));
			} catch (Exception e) {
				System.out.print("i=" + i + ", url " + e.getMessage());
			}
			docList.add(doc);
		}
		
		
 	} catch (Exception e) {
 		e.printStackTrace();
 	}
	
	return docList;
}

%>
<%
String url = request.getParameter("url");
String queryString = request.getParameter("queryString");
String district = request.getParameter("district");


url = "https://www.edr.hk/ajax/district/list/central-western?draw=1&columns%5B0%5D%5Bdata%5D=&columns%5B0%5D%5Bname%5D=&columns%5B0%5D%5Bsearchable%5D=true&columns%5B0%5D%5Borderable%5D=false&columns%5B0%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B0%5D%5Bsearch%5D%5Bregex%5D=false&columns%5B1%5D%5Bdata%5D=&columns%5B1%5D%5Bname%5D=&columns%5B1%5D%5Bsearchable%5D=true&columns%5B1%5D%5Borderable%5D=true&columns%5B1%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B1%5D%5Bsearch%5D%5Bregex%5D=false&columns%5B2%5D%5Bdata%5D=&columns%5B2%5D%5Bname%5D=&columns%5B2%5D%5Bsearchable%5D=true&columns%5B2%5D%5Borderable%5D=true&columns%5B2%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B2%5D%5Bsearch%5D%5Bregex%5D=false&columns%5B3%5D%5Bdata%5D=&columns%5B3%5D%5Bname%5D=&columns%5B3%5D%5Bsearchable%5D=true&columns%5B3%5D%5Borderable%5D=true&columns%5B3%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B3%5D%5Bsearch%5D%5Bregex%5D=false&columns%5B4%5D%5Bdata%5D=&columns%5B4%5D%5Bname%5D=&columns%5B4%5D%5Bsearchable%5D=true&columns%5B4%5D%5Borderable%5D=true&columns%5B4%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B4%5D%5Bsearch%5D%5Bregex%5D=false&columns%5B5%5D%5Bdata%5D=address_chi&columns%5B5%5D%5Bname%5D=&columns%5B5%5D%5Bsearchable%5D=true&columns%5B5%5D%5Borderable%5D=true&columns%5B5%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B5%5D%5Bsearch%5D%5Bregex%5D=false&columns%5B6%5D%5Bdata%5D=district&columns%5B6%5D%5Bname%5D=&columns%5B6%5D%5Bsearchable%5D=true&columns%5B6%5D%5Borderable%5D=true&columns%5B6%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B6%5D%5Bsearch%5D%5Bregex%5D=false&columns%5B7%5D%5Bdata%5D=phone&columns%5B7%5D%5Bname%5D=&columns%5B7%5D%5Bsearchable%5D=true&columns%5B7%5D%5Borderable%5D=true&columns%5B7%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B7%5D%5Bsearch%5D%5Bregex%5D=false&start=0&length=10&search%5Bvalue%5D=&search%5Bregex%5D=false&_=1510283635208";
queryString = "";

String json = null;

// replace it with full list from \\ahhk.local\ah\IT\EDR doctor list\20171110_getEdrDocList\20171110_district_json.txt
// central-western
json = "{}";

//String ret = unescapeUnicode(getUrlJson(url, queryString));
//System.out.println("[getEdrDocList] url="+url);
//System.out.println("[getEdrDocList] ret="+ret);

List<EdrDoctor> docList = getDocObject(json);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style>
ul {
	padding-left: 30px!important;
}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>EDR doc list - <%=district %></title>
</head>
<jsp:include page="../common/header.jsp"/>
<body>
	<div>
		<!--<h1 style="font-size: 20px;">District - <%=district %></h1>-->
		<table>
			<thead>
				<tr>
					<td>No</td>
					<td>醫生姓名</td>
					<td>醫生姓名 (Eng)</td>
					<td>姓別</td>
					<td>專科</td>
					<td>專科(Sub)</td>
					<td>執業簡介</td>
					<td>醫務所地址</td>
					<td>地區</td>
					<td>電話</td>
				</tr>
			</thead>
			<tbody>
<%
	for (int i = 0; i < docList.size(); i ++) {
			EdrDoctor doc = docList.get(i); 
%>
				<tr>
					<td><%=(i+1) %></td>
					<td><%=doc.getName_chi()  == null ? "" : doc.getName_chi() %></td>
					<td><%=doc.getName_eng()  == null ? "" : doc.getName_eng() %></td>
					<td><%=doc.getGender()  == null ? "" : doc.getGender() %></td>
					<td><%=doc.getSpeciality_name_chi()  == null ? "" : doc.getSpeciality_name_chi() %></td>
					<td><%=doc.getSub_speciality_name_chi()  == null ? "" : doc.getSub_speciality_name_chi()%></td>
					<td><%=doc.getPractice()  == null ? "" : doc.getPractice() %></td>
					<td><%=doc.getAddress_chi()  == null ? "" : doc.getAddress_chi() %></td>
					<td><%=doc.getDistrict()  == null ? "" : doc.getDistrict() %></td>
					<td><%=doc.getPhone()  == null ? "" : doc.getPhone() %></td>
				</tr>				
<%
	}
%>
			</tbody>
		</table>
	</div>
</body>
</html>
