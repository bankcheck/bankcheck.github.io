package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;

public class PHDrugDB {
	public static ArrayList getDrugFolder() {
		StringBuffer sqlStr = new StringBuffer();		
		
		sqlStr.append("select PH_DRUG_ID, PH_CLASS_ONE, PH_CLASS_TWO, PH_CLASS_THREE, PH_CLASS_FOUR, PH_FOLDER, PH_LINK_TABLE, ");
		sqlStr.append("	      PH_GEN_NAME, PH_BRA_NAME, PH_DOS_FORM, PH_STRENGTH, PH_HKAH, PH_TWAH "); 
		sqlStr.append("from   PH_DRUG_FORMULARY ");
		sqlStr.append("where  TRIM(PH_FOLDER) = '*' ");
		sqlStr.append("AND    PH_ENABLED = '1' ");
		sqlStr.append("order by PH_CLASS_ONE, PH_CLASS_TWO, PH_CLASS_THREE, PH_CLASS_FOUR ");
		
//System.out.println("DEBUG sqlStr="+sqlStr);
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	private static String getDrugClassInSql(String drugClass){
		String[] arrayOfClass = drugClass.split("\\.");
		StringBuffer sqlStr = new StringBuffer();

		for(int i = 0; i < 4 ; i++){
			String tempClass = "";
			if(i == 0){
				tempClass = "ONE";
			} else if (i == 1){
				tempClass = "TWO";
			} else if (i == 2){
				tempClass = "THREE";
			} else if (i == 3){
				tempClass = "FOUR";
			}
			
			if( arrayOfClass.length > i){
				if( arrayOfClass[i].length() > 0 ){
					if ( i >= 1){
						sqlStr.append(" AND PH_CLASS_" + tempClass + "  ='" + arrayOfClass[i] + "' ");
					} else {
						sqlStr.append(" PH_CLASS_" + tempClass + "  ='" + arrayOfClass[i] + "' ");
					}
				}
			} else {
				if ( i >= 1){
					sqlStr.append(" AND PH_CLASS_" + tempClass + " IS NULL ");
				} else {
					sqlStr.append(" PH_CLASS_" + tempClass + " IS NULL ");
				}
			}
		}		
//System.out.println(sqlStr.toString());	
		
		return sqlStr.toString();
	}


	public static ArrayList getDrugFolder(String drugClass, String drugName) {
		StringBuffer sqlStr = new StringBuffer();	

		sqlStr.append("select PH_DRUG_ID, PH_CLASS_ONE, PH_CLASS_TWO, PH_CLASS_THREE, PH_CLASS_FOUR, PH_FOLDER, PH_LINK_TABLE, ");
		sqlStr.append("	      PH_GEN_NAME, PH_BRA_NAME, PH_DOS_FORM, PH_STRENGTH, PH_HKAH, PH_TWAH, PH_REMARK "); 
		sqlStr.append("from   PH_DRUG_FORMULARY ");
		sqlStr.append("where  PH_ENABLED = '1' ");
		sqlStr.append("	AND   PH_FOLDER IS NULL ");
		if ("hkah".toUpperCase().equals(ConstantsServerSide.SITE_CODE.toUpperCase())) {
			sqlStr.append("AND    TRIM(PH_HKAH) = 'Y' ");
		} else if ("twah".toUpperCase().equals(ConstantsServerSide.SITE_CODE.toUpperCase())){
			sqlStr.append("AND    TRIM(PH_TWAH) = 'Y' ");
		}
		if(drugClass != null && drugClass.length() > 0){
			if(drugClass.contains(",")){
				String[] listOfDrugClass = drugClass.split(",");
				for(int i = 0 ; i < listOfDrugClass.length; i++){
					if(i >= 1){
						sqlStr.append("OR (" + getDrugClassInSql(listOfDrugClass[i]) + " AND PH_FOLDER is null ) ");
					} else {
						sqlStr.append("AND (" + getDrugClassInSql(listOfDrugClass[i]) + " AND PH_FOLDER is null ) ");
					}
				}		
			} else {
				sqlStr.append("AND " + getDrugClassInSql(drugClass));
			}
		}
		if(drugName != null && drugName.length() > 0){
			sqlStr.append("AND (UPPER(TRIM(PH_GEN_NAME)) LIKE '%" + drugName.toUpperCase().trim().replaceAll("%", "\\\\%") + "%' escape '\\' OR UPPER(TRIM(PH_BRA_NAME)) LIKE '%" + drugName.toUpperCase().trim().replaceAll("%", "\\\\%") + "%' escape '\\' ) ");
		}
		
		sqlStr.append(" order by PH_CLASS_ONE, PH_CLASS_TWO, PH_CLASS_THREE, PH_CLASS_FOUR, PH_GEN_NAME, PH_BRA_NAME, PH_DOS_FORM, PH_STRENGTH ");		
//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static String getDrugClassName(String drugClassOne, String drugClassTwo, String drugClassThree, String drugClassFour) {
		StringBuffer sqlStr = new StringBuffer();
		String className = "";
		String classID = "";
		
		sqlStr.append("select PH_GEN_NAME "); 
		sqlStr.append("from   PH_DRUG_FORMULARY ");
		sqlStr.append("where  PH_ENABLED = '1' ");
		sqlStr.append("	AND   TRIM(PH_FOLDER) = '*' ");
		if(drugClassOne != null && drugClassOne.length() > 0){
			sqlStr.append("	AND   PH_CLASS_ONE = '" + drugClassOne + "' ");
			classID = drugClassOne;
		}
		if(drugClassTwo != null && drugClassTwo.length() > 0){
			sqlStr.append("	AND   PH_CLASS_TWO = '" + drugClassTwo + "' ");
			classID = classID + "." + drugClassTwo;
		}
		if(drugClassThree != null && drugClassThree.length() > 0){
			sqlStr.append("	AND   PH_CLASS_THREE = '" + drugClassThree + "' ");
			classID = classID + "." + drugClassThree;
		}
		if(drugClassFour != null && drugClassFour.length() > 0){
			sqlStr.append("	AND   PH_CLASS_FOUR = '" + drugClassFour + "' ");
			classID = classID + "." + drugClassFour;
		}
		sqlStr.append("order by PH_CLASS_ONE, PH_CLASS_TWO, PH_CLASS_THREE, PH_CLASS_FOUR ");
		
		if(drugClassOne != null && drugClassOne.length() > 0){
			ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString());
			if (record != null && record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				className = row.getValue(0);
				className = classID + "  " + className;
			}
		}
		return className;
	}	
	
	public static ArrayList getDrugNameList(String drugName) {
		StringBuffer sqlStr = new StringBuffer();	
		
		sqlStr.append("SELECT DrugName FROM ( ");
		sqlStr.append("	select  DISTINCT TRIM(PH_GEN_NAME) As DrugName ");
		sqlStr.append("from PH_DRUG_FORMULARY ");
		sqlStr.append("where PH_ENABLED = 1 ");
		sqlStr.append("AND UPPER(TRIM(PH_GEN_NAME)) LIKE '%" + drugName.toUpperCase().trim().replaceAll("%", "\\\\%") + "%' escape '\\' ");
		sqlStr.append("AND   PH_FOLDER IS NULL ");
		if ("hkah".toUpperCase().equals(ConstantsServerSide.SITE_CODE.toUpperCase())) {
			sqlStr.append("AND    TRIM(PH_HKAH) = 'Y' ");
		} else if ("twah".toUpperCase().equals(ConstantsServerSide.SITE_CODE.toUpperCase())){
			sqlStr.append("AND    TRIM(PH_TWAH) = 'Y' ");
		}
		sqlStr.append("UNION ");
		sqlStr.append("select  DISTINCT TRIM(PH_BRA_NAME) As DrugName ");
		sqlStr.append("from PH_DRUG_FORMULARY ");
		sqlStr.append("where PH_ENABLED = 1 ");
		sqlStr.append("AND UPPER(TRIM(PH_BRA_NAME)) LIKE '%" + drugName.toUpperCase().trim().replaceAll("%", "\\\\%") + "%' escape '\\' ");
		sqlStr.append("AND   PH_FOLDER IS NULL " );
		if ("hkah".toUpperCase().equals(ConstantsServerSide.SITE_CODE.toUpperCase())) {
			sqlStr.append("AND    TRIM(PH_HKAH) = 'Y' ");
		} else if ("twah".toUpperCase().equals(ConstantsServerSide.SITE_CODE.toUpperCase())){
			sqlStr.append("AND    TRIM(PH_TWAH) = 'Y' ");
		}
		sqlStr.append(") ORDER BY DrugName ");
		
//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
} 