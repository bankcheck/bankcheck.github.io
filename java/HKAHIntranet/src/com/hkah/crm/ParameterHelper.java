package com.hkah.crm;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpSession;

import com.hkah.config.MessageResources;
import com.hkah.constant.ConstantsVariable;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;

public class ParameterHelper {

	private static final String TITLE = "title";
	private static final String RELIGION = "religion";
	private static final String OCCUPATION = "occupation";
	private static final String ACTIVITY = "activity";
	private static final String DISTRICT = "district";
	private static final String AREA = "area";
	private static final String COUNTRY = "country";
	private static final String EDUCATION_LEVEL = "education";
	private static final String AGE_GROUP = "ageGroup";
	private static final String INCOME = "income";
	private static final String PREFER_CONTACT_METHOD = "preferContactMethod";
	private static final String CARD_TYPE = "cardType";
	private static final String MEDICAL = "medical";
	private static final String HOBBY = "hobby";
	private static final String HOSPITAL_FACILITY = "hospitalFacility";

	private static HashMap parameterMap = null;

	public static String getTitleValue(HttpSession session, String key) {
		return getParameterValue(session, TITLE, key);
	}

	public static String getReligionValue(HttpSession session, String key) {
		return getParameterValue(session, RELIGION, key);
	}

	public static String getOccupationValue(HttpSession session, String key) {
		return getParameterValue(session, OCCUPATION, key);
	}

	public static String getActivityValue(HttpSession session, String key) {
		return getParameterValue(session, ACTIVITY, key);
	}

	public static String getDistrictValue(HttpSession session, String key) {
		return getParameterValue(session, DISTRICT, key);
	}

	public static String getAreaValue(HttpSession session, String key) {
		return getParameterValue(session, AREA, key);
	}

	public static String getCountryValue(HttpSession session, String key) {
		return getParameterValue(session, COUNTRY, key);
	}

	public static String getEducationLevelValue(HttpSession session, String key) {
		return getParameterValue(session, EDUCATION_LEVEL, key);
	}

	public static String getAgeGroupValue(HttpSession session, String key) {
		return getParameterValue(session, AGE_GROUP, key);
	}

	public static String getIncomeValue(HttpSession session, String key) {
		return getParameterValue(session, INCOME, key);
	}

	public static String getPreferContactMethodValue(HttpSession session, String key) {
		return getParameterValue(session, PREFER_CONTACT_METHOD, key);
	}

	public static String getCardTypeValue(HttpSession session, String key) {
		return getParameterValue(session, CARD_TYPE, key);
	}

	public static String getMedicalValue(HttpSession session, String key) {
		return getParameterValue(session, MEDICAL, key);
	}

	public static String getHobbyValue(HttpSession session, String key) {
		return getParameterValue(session, HOBBY, key);
	}

	public static String getHospitalFacilityValue(HttpSession session, String key) {
		return getParameterValue(session, HOSPITAL_FACILITY, key);
	}

	private static String getParameterValue(HttpSession session, String parameterType, String key) {
		String value = ConstantsVariable.EMPTY_VALUE;
		HashMap typeHashMap = null;

		// extract default data from database
		if (parameterMap == null) {
			parameterMap = new HashMap();

			// fetch parameter
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("SELECT CRM_PARAMETER_TYPE, CRM_PARAMETER_ID, CRM_PARAMETER_DESC, CRM_PARAMETER_LABEL ");
			sqlStr.append("FROM   CRM_PARAMETER ");
			sqlStr.append("WHERE  CRM_ENABLED = 1 ");
			sqlStr.append("ORDER BY CRM_PARAMETER_TYPE");

			ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString());
			ReportableListObject row = null;
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				// extract hashmap by parameter type
				if (parameterMap.containsKey(row.getValue(0))) {
					typeHashMap = (HashMap) parameterMap.get(row.getValue(0));
				} else {
					typeHashMap = new HashMap();
				}
				if (row.getValue(3) != null && row.getValue(3).length() > 0) {
					typeHashMap.put(row.getValue(1), row.getValue(3));
				} else {
					typeHashMap.put(row.getValue(1), row.getValue(2));
				}
				parameterMap.put(row.getValue(0), typeHashMap);
			}
		}

		try {
			if (key != null && key.length() > 0 && !ConstantsVariable.ZERO_VALUE.equals(key)) {
					typeHashMap = (HashMap) parameterMap.get(parameterType);
					value = (String) typeHashMap.get(key);
					// try to get label
				value = MessageResources.getMessage(session, value);
			} else {
				value = MessageResources.getMessage(session, "label.others");
			}
		} catch (Exception e) {}
		return value;
	}
}