package com.hkah.web.mobile;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.ws.rs.client.Client;
import javax.ws.rs.client.Entity;
import javax.ws.rs.client.Invocation;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.Form;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.MultivaluedHashMap;
import javax.ws.rs.core.MultivaluedMap;
import javax.ws.rs.core.Response;

import org.json.JSONException;
import org.json.JSONObject;
import org.json.simple.JSONArray;

public class NotifyService {
/*
	@Context
	public void setRequest(Request request) {
		// injection into a setter method
		System.out.println(request != null);
	}

	private static final String JSON_DELIMITER = "<JSON/>";

	private static ArrayList getCallServiceInfo(String service) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT HPKEY, HPRMK ");
		sqlStr.append("FROM HPSTATUS@IWEB ");
		sqlStr.append("WHERE HPSTATUS = '"+service+"' " );
		sqlStr.append("AND HPTYPE = 'MOBILEAPP' ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
*/
	public static String callService(String target, String path, String jHeaderString,
										String jParamString, String bodyString, String resultType, String resultKey) {
		String returnString = null;
		JSONObject headerJSON = null;
		JSONObject paramJSON = null;
		try {
			if (jHeaderString != null && !"".equals(jHeaderString)) {
				headerJSON = new JSONObject(jHeaderString);
			}
			if (jParamString != null && !"".equals(jParamString)) {
				paramJSON = new JSONObject(jParamString);
			}

			Client client = null;
			client = ClientUtil.getSslClient("TLSv1.2");
			WebTarget webTarget = client.target(target).path(path);

			Invocation.Builder invocationBuilder =  webTarget.request(MediaType.APPLICATION_JSON);
			MultivaluedMap<String, Object> map = new MultivaluedHashMap<String, Object>();
			Form form = new Form();
			Iterator<String> keys = null;
			String key = null;
			if (headerJSON != null && headerJSON.length() > 0) {
				keys = headerJSON.keys();

				while(keys.hasNext()) {
					key = keys.next();
					if (headerJSON.getString(key) instanceof String) {
						map.add(key, headerJSON.getString(key));
					}
				}
			}

			if (paramJSON != null && paramJSON.length() > 0) {
				keys = paramJSON.keys();

				while(keys.hasNext()) {
					key = keys.next();
					if (paramJSON.getString(key) instanceof String) {
						form.param(key, paramJSON.getString(key));
					}
				}
			}

			Response response = null;
			invocationBuilder.headers(map);
			if ("String".equals(resultType)) {
				response = invocationBuilder.post(Entity.form(form), Response.class);
				System.out.println(response.getStatus());
				String jString = response.readEntity(String.class);
				try {
					JSONObject jObj = new JSONObject(jString);
					if (jObj.has(resultKey)) {
						returnString = jObj.getString(resultKey);
					} else {
						returnString = "-999";
					}
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}

			if ("JSON".equals(resultType)) {
				response = invocationBuilder.post(Entity.entity(bodyString, MediaType.APPLICATION_JSON));
				System.out.println("A status:"+response.getStatus());
				String jString = response.readEntity(String.class);
				JSONObject resultJSON = new JSONObject(jString);

				int status = response.getStatus();
				resultJSON.put("status", Integer.toString(status));

				returnString = resultJSON.toString();
				System.out.println("A result:"+returnString);
			}

			response.close();
			client.close();
			return returnString;

		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			return null;
		}
	}

	public static String getToken(String target, String path,
			String ocpKey, String authorization, String username, String password) {

		org.json.simple.JSONObject headerString = new org.json.simple.JSONObject();
		headerString.put("Ocp-Apim-Subscription-Key", ocpKey);
		headerString.put("Authorization", "Basic "+authorization);

		org.json.simple.JSONObject paramString = new org.json.simple.JSONObject();
		paramString.put("grant_type", "password");
		paramString.put("username", username);
		paramString.put("password", password);

		return callService(target, path,
				headerString.toJSONString(), paramString.toJSONString(), null, "String", "access_token");
	}

	public static String sendMsg(String target, String path, String token,
			String jMsgBody){
		org.json.simple.JSONObject header = new org.json.simple.JSONObject();

		header.put("Authorization", "bearer "+token);
		header.put("Content-Type", "application/json");


		return callService(target, path, header.toJSONString(),
				null, jMsgBody, "JSON", null);
	}

	public static String getMsgJSONString(String patNo, String bkgID, String msgEN,
			String msgHK, String msgCN) {

		HashMap<String, String> msgContent = new HashMap<String, String>();

		msgContent.put("ENG", msgEN);
		msgContent.put("TRC", msgHK);
		msgContent.put("SMC", msgCN);

		return getMsgJSONString(patNo, bkgID, null, msgContent);
	}

	public static String getMsgJSONString(String patNo, String bkgID,
			String lang, Map<String, String> msgContent) {

		org.json.simple.JSONObject mainObj = new org.json.simple.JSONObject();
		JSONArray mainArray = new JSONArray();
		org.json.simple.JSONObject contentObj = new org.json.simple.JSONObject();
		JSONArray textArray = new JSONArray();
		org.json.simple.JSONObject textObj = new org.json.simple.JSONObject();
		org.json.simple.JSONObject textObj1 = new org.json.simple.JSONObject();
		org.json.simple.JSONObject textObj2 = new org.json.simple.JSONObject();
		org.json.simple.JSONObject textObj3 = new org.json.simple.JSONObject();

		contentObj.put("hospitalNo", patNo);
		contentObj.put("appointmentID", bkgID);

		textObj.put("languageCode", "en");
		textObj.put("message", msgContent.get("ENG"));

		textObj1.put("languageCode", "zh-HK");
		textObj1.put("message", msgContent.get("TRC"));

		textObj2.put("languageCode", "zh-CN");
		textObj2.put("message", msgContent.get("SMC"));

		textArray.add(textObj);
		textArray.add(textObj1);
		textArray.add(textObj2);
		contentObj.put("bookingMessages", textArray);

		mainArray.add(contentObj);
		mainObj.put("notifications", mainArray);

		return mainObj.toJSONString();
	}
	
	public static String getMsgJSONStringFs(String patNo, String orderType, String orderId, String msgEN,
			String msgHK, String msgCN) {

		HashMap<String, String> msgContent = new HashMap<String, String>();

		msgContent.put("ENG", msgEN);
		msgContent.put("TRC", msgHK);
		msgContent.put("SMC", msgCN);

		return getMsgJSONStringFs(patNo, orderType, orderId, null, msgContent);
	}
						
	public static String getMsgJSONStringFs(String patNo, String orderType, String orderId,
			String lang, Map<String, String> msgContent) {

		org.json.simple.JSONObject mainObj = new org.json.simple.JSONObject();
		JSONArray mainArray = new JSONArray();
		org.json.simple.JSONObject contentObj = new org.json.simple.JSONObject();
		JSONArray textArray = new JSONArray();
		org.json.simple.JSONObject textObj = new org.json.simple.JSONObject();
		org.json.simple.JSONObject textObj1 = new org.json.simple.JSONObject();
		org.json.simple.JSONObject textObj2 = new org.json.simple.JSONObject();
		org.json.simple.JSONObject textObj3 = new org.json.simple.JSONObject();

		contentObj.put("hospitalNo", patNo);
		contentObj.put("orderType", orderType);
		contentObj.put("orderId", orderId);

		textObj.put("languageCode", "en");
		textObj.put("message", msgContent.get("ENG"));

		textObj1.put("languageCode", "zh-HK");
		textObj1.put("message", msgContent.get("TRC"));

		textObj2.put("languageCode", "zh-CN");
		textObj2.put("message", msgContent.get("SMC"));

		textArray.add(textObj);
		textArray.add(textObj1);
		textArray.add(textObj2);
		contentObj.put("foodOrderMessages", textArray);

		mainArray.add(contentObj);
		mainObj.put("notifications", mainArray);

		return mainObj.toJSONString();
	}
	
	public static String getMsgJSONStringBill(String patNo, String billID, String msgEN,
			String msgHK, String msgCN) {

		HashMap<String, String> msgContent = new HashMap<String, String>();

		msgContent.put("ENG", msgEN);
		msgContent.put("TRC", msgHK);
		msgContent.put("SMC", msgCN);
		
		org.json.simple.JSONObject mainObj = new org.json.simple.JSONObject();
		JSONArray mainArray = new JSONArray();
		org.json.simple.JSONObject contentObj = new org.json.simple.JSONObject();
		JSONArray textArray = new JSONArray();
		org.json.simple.JSONObject textObj = new org.json.simple.JSONObject();
		org.json.simple.JSONObject textObj1 = new org.json.simple.JSONObject();
		org.json.simple.JSONObject textObj2 = new org.json.simple.JSONObject();
		org.json.simple.JSONObject textObj3 = new org.json.simple.JSONObject();

		contentObj.put("hospitalNo", patNo);
		contentObj.put("billId", billID);

		textObj.put("languageCode", "en");
		textObj.put("message", msgContent.get("ENG"));

		textObj1.put("languageCode", "zh-HK");
		textObj1.put("message", msgContent.get("TRC"));

		textObj2.put("languageCode", "zh-CN");
		textObj2.put("message", msgContent.get("SMC"));

		textArray.add(textObj);
		textArray.add(textObj1);
		textArray.add(textObj2);
		contentObj.put("billMessages", textArray);

		mainArray.add(contentObj);
		mainObj.put("notifications", mainArray);

		return mainObj.toJSONString();
	}
}