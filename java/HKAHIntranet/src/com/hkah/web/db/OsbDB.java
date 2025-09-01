package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;

public class OsbDB {
	private static String sqlStr_getWards = null;
	
	public static ArrayList getServUsageReport(String admDateFrom, String admDateTo,
			String ward, String doccode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("  WRDNAME ");
		sqlStr.append("  , DOCNAME ");
		sqlStr.append("  , CNT_SUCCESS ");
		sqlStr.append("  , CASE WHEN PCT_SUCCESS IS NULL THEN TO_CHAR(PCT_SUCCESS) ELSE TO_CHAR(PCT_SUCCESS,'FM990.0') || '%' END PCT_SUCCESS ");
		sqlStr.append("  , CNT_NOTSHOW ");
		sqlStr.append("  , CASE WHEN PCT_NOTSHOW IS NULL THEN TO_CHAR(PCT_NOTSHOW) ELSE TO_CHAR(PCT_NOTSHOW,'FM990.0') || '%' END PCT_NOTSHOW ");
		sqlStr.append("  , CNT_CANCEL ");
		sqlStr.append("  , CASE WHEN PCT_CANCEL IS NULL THEN TO_CHAR(PCT_CANCEL) ELSE TO_CHAR(PCT_CANCEL,'FM990.0') || '%' END PCT_CANCEL ");
		sqlStr.append("  , CNT_FAILED ");
		sqlStr.append("  , CASE WHEN PCT_FAILED IS NULL THEN TO_CHAR(PCT_FAILED) ELSE TO_CHAR(PCT_FAILED,'FM990.0') || '%' END PCT_FAILED ");
		sqlStr.append("  , CNT_TOTAL ");
		sqlStr.append("FROM  ");
		sqlStr.append("( ");
		
		sqlStr.append("SELECT ");
		sqlStr.append("  (SELECT WRDNAME FROM WARD@IWEB X WHERE X.WRDCODE=A.WRDCODE) AS WRDNAME ");
		sqlStr.append("  , TITTLE || ' ' || DOCFNAME||' '||DOCGNAME AS DOCNAME ");
		sqlStr.append("  , SUM(CASE WHEN BPBSTS='F' THEN 1 END) AS CNT_SUCCESS ");
		sqlStr.append("  , ROUND(100*SUM(CASE WHEN BPBSTS='F' THEN 1 END)/COUNT(*), 1) AS PCT_SUCCESS ");
		sqlStr.append("  , SUM(CASE WHEN BPBSTS='N' THEN 1 END) AS CNT_NOTSHOW ");
		sqlStr.append("  , ROUND(100*SUM(CASE WHEN BPBSTS='N' THEN 1 END)/COUNT(*), 1) AS PCT_NOTSHOW ");
		sqlStr.append("  , SUM(CASE WHEN BPBSTS='D' THEN 1 END) AS CNT_CANCEL ");
		sqlStr.append("  , ROUND(100*SUM(CASE WHEN BPBSTS='D' THEN 1 END)/COUNT(*), 1) AS PCT_CANCEL ");
		sqlStr.append("  , NULL AS CNT_FAILED ");
		sqlStr.append("  , NULL AS PCT_FAILED ");
		sqlStr.append("  , COUNT(*) AS CNT_TOTAL ");
		sqlStr.append("FROM BEDPREBOK@IWEB A, DOCTOR@IWEB D ");
		sqlStr.append("WHERE A.DOCCODE=D.DOCCODE  ");
		sqlStr.append("   AND BPBHDATE<=SYSDATE ");
		if (admDateFrom != null && admDateFrom.length() > 0) {
			sqlStr.append("AND BPBHDATE >= TO_DATE('" + admDateFrom + " 00:00', 'DD/MM/YYYY HH24:MI') ");
		}
		if (admDateTo != null && admDateTo.length() > 0) {
			sqlStr.append("AND BPBHDATE < TO_DATE('" + admDateTo + " 00:00', 'DD/MM/YYYY HH24:MI') + 1 ");
		}
		if (doccode != null && doccode.length() > 0) {
			sqlStr.append("AND A.DOCCODE = '");
			sqlStr.append(doccode);
			sqlStr.append("' ");
		}
		if (ward != null && ward.length() > 0) {
			sqlStr.append("AND WRDCODE = '");
			sqlStr.append(ward);
			sqlStr.append("' ");
		}
		sqlStr.append("GROUP BY WRDCODE, TITTLE || ' ' || DOCFNAME||' '||DOCGNAME ");
		sqlStr.append("UNION ");
		sqlStr.append("SELECT ");
		sqlStr.append("  '' AS WRDNAME ");
		sqlStr.append("  ,'' AS DOCNAME ");
		sqlStr.append("  , SUM(CNT_SUCCESS) AS CNT_SUCCESS ");
		sqlStr.append("  , ROUND(100*(SUM(CNT_SUCCESS) / SUM(CNT_TOTAL)), 1) AS PCT_SUCCESS ");
		sqlStr.append("  , SUM(CNT_NOTSHOW) AS CNT_NOTSHOW ");
		sqlStr.append("  , ROUND(100*(SUM(CNT_NOTSHOW) / SUM(CNT_TOTAL)), 1) AS PCT_NOTSHOW ");
		sqlStr.append("  , SUM(CNT_CANCEL) AS CNT_CANCEL ");
		sqlStr.append("  , ROUND(100*(SUM(CNT_CANCEL) / SUM(CNT_TOTAL)), 1) PCT_NOTSHOW_TOT ");
		sqlStr.append("  , SUM(CNT_FAILED) CNT_FAILED_TOT ");
		sqlStr.append("  , ROUND(100*(SUM(CNT_FAILED) / SUM(CNT_TOTAL)), 1) PCT_FAILED_TOT ");
		sqlStr.append("  , SUM(CNT_TOTAL) CNT_TOTAL_TOT ");
		sqlStr.append("FROM ");
		sqlStr.append("( ");
		sqlStr.append("  SELECT  ");
		sqlStr.append("    WRDCODE ");
		sqlStr.append("    , (SELECT WRDNAME FROM WARD@IWEB X WHERE X.WRDCODE=A.WRDCODE) AS WRDNAME ");
		sqlStr.append("    , TITTLE || ' ' || DOCFNAME||' '||DOCGNAME AS DOCNAME ");
		sqlStr.append("    , SUM(CASE WHEN BPBSTS='F' THEN 1 END) AS CNT_SUCCESS ");
		sqlStr.append("    , ROUND(100*SUM(CASE WHEN BPBSTS='F' THEN 1 END)/COUNT(*), 1) AS PCT_SUCCESS ");
		sqlStr.append("    , SUM(CASE WHEN BPBSTS='N' THEN 1 END) AS CNT_NOTSHOW ");
		sqlStr.append("    , ROUND(100*SUM(CASE WHEN BPBSTS='N' THEN 1 END)/COUNT(*), 1) AS PCT_NOTSHOW ");
		sqlStr.append("    , SUM(CASE WHEN BPBSTS='D' THEN 1 END) AS CNT_CANCEL ");
		sqlStr.append("    , ROUND(100*SUM(CASE WHEN BPBSTS='D' THEN 1 END)/COUNT(*), 1) AS PCT_CANCEL ");
		sqlStr.append("    , NULL AS CNT_FAILED ");
		sqlStr.append("    , NULL AS PCT_FAILED ");
		sqlStr.append("    , COUNT(*) AS CNT_TOTAL ");
		sqlStr.append("    , '' DUMMY ");
		sqlStr.append("  FROM BEDPREBOK@IWEB A, DOCTOR@IWEB D ");
		sqlStr.append("  WHERE A.DOCCODE=D.DOCCODE  ");
		sqlStr.append("    AND BPBHDATE<=SYSDATE ");
		if (admDateFrom != null && admDateFrom.length() > 0) {
			sqlStr.append("AND BPBHDATE >= TO_DATE('" + admDateFrom + " 00:00', 'DD/MM/YYYY HH24:MI') ");
		}
		if (admDateTo != null && admDateTo.length() > 0) {
			sqlStr.append("AND BPBHDATE < TO_DATE('" + admDateTo + " 00:00', 'DD/MM/YYYY HH24:MI') + 1 ");
		}
		if (doccode != null && doccode.length() > 0) {
			sqlStr.append("AND A.DOCCODE = '");
			sqlStr.append(doccode);
			sqlStr.append("' ");
		}
		if (ward != null && ward.length() > 0) {
			sqlStr.append("AND WRDCODE = '");
			sqlStr.append(ward);
			sqlStr.append("' ");
		}
		sqlStr.append("  GROUP BY WRDCODE, TITTLE || ' ' || DOCFNAME||' '||DOCGNAME ");
		sqlStr.append(") ");
		sqlStr.append(") ");
		sqlStr.append("ORDER BY WRDNAME, DOCNAME ");

		//System.out.println("DEBUG sqlStr="+sqlStr);
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getBedOccuBookingReportOne(String ward, String doctorCode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select (select wrdname from ward@iweb x where x.wrdcode=r.wrdcode) as ward_name ");
		sqlStr.append("		, b.bedcode as Room ");
		sqlStr.append("		, i.acmcode as Class ");
		sqlStr.append("		, I.PATSEX as GENDER ");
		sqlStr.append("		, (select diagnosis from OSB_HANDOVER@cis x where i.patno=x.patno) as diagnosis ");
		sqlStr.append("		, (select docfname||' '||docgname from doctor@iweb d where d.doccode=i.doccode_a) as docname ");
		sqlStr.append("		, TO_CHAR(i.REGDATE,'dd/mm/yyyy') as admission_date ");
		sqlStr.append("		, (case when i.acmcode is null then 'V' else 'O' end) as bed_status ");
		sqlStr.append("		, TO_CHAR(i.REGDATE+i.ACTSTAYLEN - 1,'dd/mm/yyyy') as Tentative_Discharge_date ");
		sqlStr.append("from room@iweb r, bed@iweb b, ");
		sqlStr.append("		(select r.regid, a.patno, a.patsex, doccode_a ");
		sqlStr.append("		, i.acmcode, r.regdate, i.actstaylen, bedcode ");
		sqlStr.append("		, (select eststaylen from bedprebok@iweb x where x.pbpid=r.pbpid) as eststaylen ");
		sqlStr.append("FROM patient@iweb a, inpat@iweb i, reg@iweb r ");
		sqlStr.append("WHERE a.patno=r.patno and i.inpid  =r.inpid "); 
		sqlStr.append("		and r.regsts ='N' and inpddate is null ");
		sqlStr.append("		) i ");
		sqlStr.append("where r.romcode=b.romcode "); 
		sqlStr.append("		and bedoff=-1 ");
		sqlStr.append("		and b.bedcode=i.bedcode(+) ");
		if(ward != null && ward.length() > 0){
			sqlStr.append("and WRDCODE='"+ward+"' ");
		}
		if(doctorCode != null && doctorCode.length() > 0){
			sqlStr.append("and I.DOCCODE_A='"+doctorCode+"' ");
		}
		sqlStr.append("order by r.romcode, b.bedcode ");
		
	
		//System.out.println("DEBUG sqlStr="+sqlStr);
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getBedOccuBookingReportTwo() {
		StringBuffer sqlStr = new StringBuffer();		
		
		sqlStr.append("select BEDCODE ");
		sqlStr.append("		, TO_CHAR(bpbhdate,'dd/mm/yyyy')  as Tentative_Admission ");
		sqlStr.append("		, DOCFNAME||' '||DOCGNAME as DOCNAME ");		
		sqlStr.append("		, TO_CHAR(BPBHDATE+ESTSTAYLEN - 1,'dd/mm/yyyy') as TENTATIVE_DISCHARGE_DATE, pb.PBPID ");
		sqlStr.append("from bedprebok@iweb pb, doctor@iweb dr ");
		sqlStr.append("where pb.doccode=dr.doccode "); 
		sqlStr.append("		and PB.BPBHDATE >= TRUNC(sysdate) ");
		sqlStr.append("		AND BEDCODE IS NOT NULL ");
		sqlStr.append("		and PB.bpbsts = 'N' ");
		sqlStr.append("order by bpbhdate ");
	
		//System.out.println("DEBUG sqlStr="+sqlStr);
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getDiagnosis(String pbpId) {
		StringBuffer sqlStr = new StringBuffer();		
		sqlStr.append("select OP.OTPDESC ");
		sqlStr.append("from BEDPREBOK@IWEB PB2, OT_APP@IWEB OT, OT_PROC@IWEB OP ");
		sqlStr.append("where PB2.PBPID = OT.PBPID ");
		sqlStr.append("and   OT.OTPID = OP.OTPID ");
		sqlStr.append("and   PB2.PBPID = '"+pbpId+"' ");
		sqlStr.append("AND   OT.OTASTS = 'N' ");		
		sqlStr.append("ORDER BY OTAOSDATE DESC ");
				
		//System.out.println("DEBUG sqlStr="+sqlStr);
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	
	public static ArrayList getUtilReportByUnit(String dateFrom, String dateTo, String ward) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("  WARD ");
		sqlStr.append("  , CLASS ");
		sqlStr.append("  , BED_NO ");
		sqlStr.append("  , TO_CHAR(TOTAL_HOURS) TOTAL_HOURS ");
		sqlStr.append("  , TO_CHAR(AVAILABLE_HOURS) AVAILABLE_HOURS ");
		sqlStr.append("  , CASE WHEN OCCUPIED_HOURS IS NULL THEN TO_CHAR(OCCUPIED_HOURS) ELSE (CASE WHEN OCCUPIED_HOURS = -1 THEN 'Occupied %' ELSE TO_CHAR(OCCUPIED_HOURS, 'FM999990.0') END) END　OCCUPIED_HOURS ");
		sqlStr.append("  , CASE WHEN OCCUPIED_RATE IS NULL THEN TO_CHAR(OCCUPIED_RATE) ELSE TO_CHAR(OCCUPIED_RATE,'FM999990.0') || '%' END　OCCUPIED_RATE ");
		sqlStr.append("  , CASE WHEN NA_HOURS = -1 THEN 'N/A %' ELSE TO_CHAR(NA_HOURS, 'FM999990.0') END　NA_HOURS ");
		sqlStr.append("  , CASE WHEN NA_RATE IS NULL THEN TO_CHAR(NA_RATE) ELSE TO_CHAR(NA_RATE,'FM999990.0') || '%' END　NA_RATE ");
		sqlStr.append("FROM ");
		sqlStr.append("( ");
		
		sqlStr.append("  SELECT  ");
		sqlStr.append("    R.WRDCODE AS WARD ");
		sqlStr.append("    , DECODE(R.ACMCODE,'S','SP',R.ACMCODE) AS CLASS ");
		sqlStr.append("    , B.BEDCODE AS BED_NO ");
		sqlStr.append("    , 24*( TO_DATE('" + dateTo + " 00:00', 'DD/MM/YYYY HH24:MI') - TO_DATE('" + dateFrom + " 00:00', 'DD/MM/YYYY HH24:MI') + 1 ) AS TOTAL_HOURS ");
		sqlStr.append("    , ROUND(24*( TO_DATE('" + dateTo + " 00:00', 'DD/MM/YYYY HH24:MI') - TO_DATE('" + dateFrom + " 00:00', 'DD/MM/YYYY HH24:MI') + 1 ) - NVL(L.NA_HOURS_TOT, 0), 1) AS AVAILABLE_HOURS ");
		sqlStr.append("    , ROUND(NVL(OSB_BED_OCCUPIED@CIS( B.BEDCODE, TO_DATE('" + dateFrom + " 00:00', 'DD/MM/YYYY HH24:MI'), TO_DATE('" + dateTo + " 00:00', 'DD/MM/YYYY HH24:MI') + 1 ), 0), 1) AS OCCUPIED_HOURS ");
		sqlStr.append("    , ROUND(100* NVL(OSB_BED_OCCUPIED@CIS( B.BEDCODE, TO_DATE('" + dateFrom + " 00:00', 'DD/MM/YYYY HH24:MI'), TO_DATE('" + dateTo + " 00:00', 'DD/MM/YYYY HH24:MI') + 1 ), 0)/ 24 / (TO_DATE('" + dateTo + " 00:00', 'DD/MM/YYYY HH24:MI') - TO_DATE('" + dateFrom + " 00:00', 'DD/MM/YYYY HH24:MI') + 1), 1) AS OCCUPIED_RATE ");
		sqlStr.append("    , L.NA_HOURS_TOT AS NA_HOURS ");
		sqlStr.append("    , ROUND(100* (NVL(L.NA_HOURS_TOT, 0) / (24*( TO_DATE('" + dateTo + " 00:00', 'DD/MM/YYYY HH24:MI') - TO_DATE('" + dateFrom + " 00:00', 'DD/MM/YYYY HH24:MI') + 1))), 1) AS NA_RATE ");
		sqlStr.append("  FROM BED@IWEB B, ROOM@IWEB R,  ");
		sqlStr.append("  ( ");
		if (ConstantsServerSide.DEBUG) {
			sqlStr.append("  SELECT ");
			sqlStr.append("  BEDCODE ");
			sqlStr.append("  , SUM(NA_HOURS) NA_HOURS_TOT ");
			sqlStr.append("  FROM ");
			sqlStr.append("  ( ");
			sqlStr.append("    SELECT ");
			sqlStr.append("      BEDCODE ");
			sqlStr.append("      , 24*( ");
			sqlStr.append("        CASE WHEN DOWNTIME > TO_DATE('" + dateFrom + " 00:00', 'DD/MM/YYYY HH24:MI') THEN ");
			sqlStr.append("          (CASE WHEN ONTIME < TO_DATE('" + dateTo + " 00:00', 'DD/MM/YYYY HH24:MI') THEN ONTIME - DOWNTIME ELSE TO_DATE('" + dateTo + " 00:00', 'DD/MM/YYYY HH24:MI') - DOWNTIME END) ");
			sqlStr.append("        ELSE ( ");
			sqlStr.append("          (CASE WHEN ONTIME < TO_DATE('" + dateTo + " 00:00', 'DD/MM/YYYY HH24:MI') THEN ONTIME - TO_DATE('" + dateFrom + " 00:00', 'DD/MM/YYYY HH24:MI') ELSE TO_DATE('" + dateTo + " 00:00', 'DD/MM/YYYY HH24:MI') - TO_DATE('" + dateFrom + " 00:00', 'DD/MM/YYYY HH24:MI') END) ");
			sqlStr.append("        ) END ");
			sqlStr.append("      ) AS NA_HOURS ");
			sqlStr.append("    FROM BAB_BEDSERVICELOG@BAB ");
			sqlStr.append("    WHERE ");
			sqlStr.append("      DOWNTIME BETWEEN TO_DATE('" + dateFrom + " 00:00', 'DD/MM/YYYY HH24:MI') AND TO_DATE('" + dateTo + " 00:00', 'DD/MM/YYYY HH24:MI') ");
			sqlStr.append("      OR (DOWNTIME < TO_DATE('" + dateFrom + " 00:00', 'DD/MM/YYYY HH24:MI') AND (ONTIME >= TO_DATE('" + dateFrom + " 00:00', 'DD/MM/YYYY HH24:MI') OR ONTIME IS NULL)) ");
			sqlStr.append("  ) ");
			sqlStr.append("  GROUP BY BEDCODE ");
		} else {
			sqlStr.append("  select null BEDCODE, null NA_HOURS_TOT from dual where 1 = 2 ");
		}
		sqlStr.append("  ) L ");
		sqlStr.append("WHERE B.ROMCODE=R.ROMCODE ");
		sqlStr.append("  AND B.BEDCODE=L.BEDCODE(+) ");
		sqlStr.append("  AND B.BEDOFF=-1 ");
		if (ward != null && ward.length() > 0) {
			sqlStr.append("AND R.WRDCODE = '");
			sqlStr.append(ward);
			sqlStr.append("' ");
		}
		
		sqlStr.append("  UNION  ");
		sqlStr.append("   ");
		
		
		sqlStr.append("  SELECT ");
		sqlStr.append("    NULL AS WARD ");
		sqlStr.append("    , NULL AS CLASS ");
		sqlStr.append("    , NULL AS BED_NO ");
		sqlStr.append("    , NULL AS TOTAL_HOURS ");
		sqlStr.append("    , NULL AS AVAILABLE_HOURS ");
		sqlStr.append("    , -1 AS OCCUPIED_HOURS ");
		sqlStr.append("    , ROUND(100*(NVL(SUM(OCCUPIED_HOURS), 0) / NVL(SUM(AVAILABLE_HOURS), 0)), 1)  AS OCCUPIED_RATE_TOT ");
		sqlStr.append("    , -1 AS NA_HOURS ");
		sqlStr.append("    , ROUND(100*(NVL(SUM(NA_HOURS), 0) / NVL(SUM(TOTAL_HOURS), 0)), 1) AS NA_RATE_TOT ");
		sqlStr.append("  FROM ");
		sqlStr.append("  ( ");
		sqlStr.append("    SELECT  ");
		sqlStr.append("      R.WRDCODE AS WARD ");
		sqlStr.append("      , DECODE(R.ACMCODE,'S','SP',R.ACMCODE) AS CLASS ");
		sqlStr.append("      , B.BEDCODE AS BED_NO ");
		sqlStr.append("    	 , 24*( TO_DATE('" + dateTo + " 00:00', 'DD/MM/YYYY HH24:MI') - TO_DATE('" + dateFrom + " 00:00', 'DD/MM/YYYY HH24:MI') + 1 ) AS TOTAL_HOURS ");
		sqlStr.append("    	 , ROUND(24*( TO_DATE('" + dateTo + " 00:00', 'DD/MM/YYYY HH24:MI') - TO_DATE('" + dateFrom + " 00:00', 'DD/MM/YYYY HH24:MI') + 1 ) - NVL(L.NA_HOURS_TOT, 0), 1) AS AVAILABLE_HOURS ");
		sqlStr.append("    	 , ROUND(NVL(OSB_BED_OCCUPIED@CIS( B.BEDCODE, TO_DATE('" + dateFrom + " 00:00', 'DD/MM/YYYY HH24:MI'), TO_DATE('" + dateTo + " 00:00', 'DD/MM/YYYY HH24:MI') + 1 ), 0), 1) AS OCCUPIED_HOURS ");
		sqlStr.append("    	 , ROUND(100* NVL(OSB_BED_OCCUPIED@CIS( B.BEDCODE, TO_DATE('" + dateFrom + " 00:00', 'DD/MM/YYYY HH24:MI'), TO_DATE('" + dateTo + " 00:00', 'DD/MM/YYYY HH24:MI') + 1 ), 0)/ 24 / (TO_DATE('" + dateTo + " 00:00', 'DD/MM/YYYY HH24:MI') - TO_DATE('" + dateFrom + " 00:00', 'DD/MM/YYYY HH24:MI') + 1), 1) AS OCCUPIED_RATE ");
		sqlStr.append("    	 , L.NA_HOURS_TOT AS NA_HOURS ");
		sqlStr.append("    	 , ROUND(100* (NVL(L.NA_HOURS_TOT, 0) / (24*( TO_DATE('" + dateTo + " 00:00', 'DD/MM/YYYY HH24:MI') - TO_DATE('" + dateFrom + " 00:00', 'DD/MM/YYYY HH24:MI') + 1))), 1) AS NA_RATE ");
		sqlStr.append("    FROM BED@IWEB B, ROOM@IWEB R,  ");
		sqlStr.append("      ( ");
		if (ConstantsServerSide.DEBUG) {
			sqlStr.append("      SELECT ");
			sqlStr.append("      BEDCODE ");
			sqlStr.append("      , SUM(NA_HOURS) NA_HOURS_TOT ");
			sqlStr.append("      FROM ");
			sqlStr.append("      ( ");
			sqlStr.append("        SELECT ");
			sqlStr.append("          BEDCODE ");
			sqlStr.append("          , 24*( ");
			sqlStr.append("            CASE WHEN DOWNTIME > TO_DATE('" + dateFrom + " 00:00', 'DD/MM/YYYY HH24:MI') THEN  ");
			sqlStr.append("              (CASE WHEN ONTIME < TO_DATE('" + dateTo + " 00:00', 'DD/MM/YYYY HH24:MI') THEN ONTIME - DOWNTIME ELSE TO_DATE('" + dateTo + " 00:00', 'DD/MM/YYYY HH24:MI') - DOWNTIME END) ");
			sqlStr.append("            ELSE ( ");
			sqlStr.append("              (CASE WHEN ONTIME < TO_DATE('" + dateTo + " 00:00', 'DD/MM/YYYY HH24:MI') THEN ONTIME - TO_DATE('" + dateFrom + " 00:00', 'DD/MM/YYYY HH24:MI') ELSE TO_DATE('" + dateTo + " 00:00', 'DD/MM/YYYY HH24:MI') - TO_DATE('" + dateFrom + " 00:00', 'DD/MM/YYYY HH24:MI') END) ");
			sqlStr.append("            ) END ");
			sqlStr.append("          ) AS NA_HOURS ");
			sqlStr.append("        FROM BAB_BEDSERVICELOG@BAB ");
			sqlStr.append("        WHERE  ");
			sqlStr.append("          DOWNTIME BETWEEN TO_DATE('" + dateFrom + " 00:00', 'DD/MM/YYYY HH24:MI') AND TO_DATE('" + dateTo + " 00:00', 'DD/MM/YYYY HH24:MI') ");
			sqlStr.append("          OR (DOWNTIME < TO_DATE('" + dateFrom + " 00:00', 'DD/MM/YYYY HH24:MI') AND (ONTIME >= TO_DATE('" + dateFrom + " 00:00', 'DD/MM/YYYY HH24:MI') OR ONTIME IS NULL)) ");
			sqlStr.append("      )  ");
			sqlStr.append("      GROUP BY BEDCODE ");
		} else {
			sqlStr.append("  select null BEDCODE, null NA_HOURS_TOT from dual where 1 = 2 ");
		}
		sqlStr.append("      ) L ");
		sqlStr.append("    WHERE B.ROMCODE=R.ROMCODE ");
		sqlStr.append("      AND B.BEDCODE=L.BEDCODE(+) ");
		sqlStr.append("      AND B.BEDOFF=-1 ");
		if (ward != null && ward.length() > 0) {
			sqlStr.append("AND R.WRDCODE = '");
			sqlStr.append(ward);
			sqlStr.append("' ");
		}
		sqlStr.append("  ) ");
		sqlStr.append("   ");
		sqlStr.append("  ORDER BY WARD, BED_NO ");
		sqlStr.append(") ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getWards() {
		return UtilDBWeb.getReportableList(sqlStr_getWards);
	}
	
	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("WRDCODE, WRDNAME ");
		sqlStr.append("FROM ");
		sqlStr.append("WARD@IWEB ");
		sqlStr.append("ORDER BY WRDNAME");
		sqlStr_getWards = sqlStr.toString();
	}
}