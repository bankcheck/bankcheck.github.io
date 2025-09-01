package com.hkah.web.db;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Vector;

import org.apache.commons.lang.StringUtils;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class EPORequestDB {
	private static String sqlStr_insertEpoLog = null;
	private static String serverSiteCode = ConstantsServerSide.SITE_CODE;

	public static ArrayList getRequestHdr(String reqNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("REQ_NO, ");
		sqlStr.append("TO_CHAR(REQ_DATE,'DD/MM/YYYY'), ");
		sqlStr.append("REQ_BY, ");
		sqlStr.append("REQ_SITE_CODE, ");
		sqlStr.append("REQ_DEPT_CODE, ");
		sqlStr.append("REQ_SHIP_TO, ");
		sqlStr.append("REQ_DESC, ");
		sqlStr.append("BUDGET_CODE, ");
		sqlStr.append("AMT_RANGE, ");
		sqlStr.append("REQ_STATUS, ");
		sqlStr.append("REMARK, ");
		sqlStr.append("SEND_APPROVAL, ");
		sqlStr.append("APPROVE_FLAG, ");
		sqlStr.append("FOLDER_ID, ");
		sqlStr.append("AD_COUNCIL_NO, ");
		sqlStr.append("BOARD_COUNCIL_NO, ");
		sqlStr.append("FINANCE_COMM_NO, ");
		sqlStr.append("PUR_REMARK, ");
		sqlStr.append("APPR_REMARK ");
		sqlStr.append("FROM EPO_REQUEST_M ");
		if (reqNo != null && reqNo.length() > 0) {
			sqlStr.append("WHERE REQ_NO = '");
			sqlStr.append(reqNo);
			sqlStr.append("' ");
		}
		System.err.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getRequestDesc(String reqNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("REQ_DESC ");
		sqlStr.append("FROM EPO_REQUEST_M ");
		if (reqNo != null && reqNo.length() > 0) {
			sqlStr.append("WHERE REQ_NO = '");
			sqlStr.append(reqNo);
			sqlStr.append("' ");
		}
		System.err.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}	

	public static String getFolderId() {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT EPO_FOLDER_ID.NEXTVAL FROM DUAL");
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			return row.getFields0();
		} else {
			return null;
		}
	}

	public static String getUseCredit(String flowID, String flowSeq, String approver, String appGrp) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT APPROVAL_CREDIT");
		sqlStr.append(" FROM EPO_APPROVE_LIST");
		sqlStr.append(" WHERE FLOW_ID = TO_NUMBER('");
		sqlStr.append(flowID);
		sqlStr.append("') AND FLOW_SEQ = TO_NUMBER('");
		sqlStr.append(flowSeq);
		sqlStr.append("') AND STAFF_ID ='");
		sqlStr.append(approver);
		sqlStr.append("' AND APPROVAL_GROUP = '");
		sqlStr.append(appGrp);
		sqlStr.append("'");
		System.err.println(sqlStr.toString());
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			return row.getFields0();
		} else {
			return null;
		}
	}

	private static String getReqNo() {
/*		
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT F_GET_PMS_TRANSNO('R') FROM DUAL");
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			return row.getFields0();
		} else {
			return null;
		}
*/		
		String f_rtn = UtilDBWeb.callFunction("F_GET_PMS_TRANSNO", "",new String[] {"R"});
		System.err.println("[R][f_rtn]:"+f_rtn);
		if(f_rtn!=null){
			return f_rtn;
		}else{
			return null;			
		}		
	}

	private static String getPoNo() {
/*		
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT F_GET_PMS_TRANSNO('J') FROM DUAL");
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			return row.getFields0();
		} else {
			return null;
		}
*/
		String f_rtn = UtilDBWeb.callFunction("F_GET_PMS_TRANSNO", "",new String[] {"J"});
		System.err.println("[f_rtn]:"+f_rtn);
		if(f_rtn!=null){
			return f_rtn;
		}else{
			return null;			
		}		
	}

	public static ArrayList getRequestDtl(String reqNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("REQ_NO, ");
		sqlStr.append("REQ_SEQ, ");
		sqlStr.append("SUPPLIER_NAME, ");
		sqlStr.append("ITEM_DESC, ");
		sqlStr.append("REQ_QTY, ");
		sqlStr.append("REQ_AMOUNT, ");
		sqlStr.append("ITEM_PRICE, ");
		sqlStr.append("ITEM_UNIT, ");
		sqlStr.append("REMARK, ");
		sqlStr.append("INS_BY, ");
		sqlStr.append("TO_CHAR(INS_DATE,'DD/MM/YYYY HH:MI:SS'), ");
		sqlStr.append("MOD_BY, ");
		sqlStr.append("TO_CHAR(MOD_DATE,'DD/MM/YYYY HH:MI:SS'), ");
		sqlStr.append("APPROVE_FLAG, ");
		sqlStr.append("APPROVED_BY ");
		sqlStr.append("FROM EPO_REQUEST_D ");
		sqlStr.append("WHERE REQ_NO = '");
		sqlStr.append(reqNo);
		sqlStr.append("' ");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getOrdedDtl(String reqNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("ERD.REQ_NO, ");
		sqlStr.append("ERD.REQ_SEQ, ");
		sqlStr.append("ERD.SUPPLIER_NAME, ");
		sqlStr.append("ERD.ITEM_DESC, ");
		sqlStr.append("ERD.REQ_QTY, ");
		sqlStr.append("ERD.REQ_AMOUNT, ");
		sqlStr.append("ERD.ITEM_PRICE, ");
		sqlStr.append("ERD.ITEM_UNIT, ");
		sqlStr.append("ERD.REMARK, ");
		sqlStr.append("ERD.INS_BY, ");
		sqlStr.append("TO_CHAR(ERD.INS_DATE,'DD/MM/YYYY HH:MI:SS'), ");
		sqlStr.append("ERD.MOD_BY, ");
		sqlStr.append("TO_CHAR(ERD.MOD_DATE,'DD/MM/YYYY HH:MI:SS'), ");
		sqlStr.append("ERD.APPROVE_FLAG, ");
		sqlStr.append("ERD.APPROVED_BY ");
		sqlStr.append("FROM ");
		sqlStr.append("EPO_REQUEST_D ERD,( ");
		sqlStr.append("SELECT M.REQ_NO, ");
		sqlStr.append("D.ITEM_DESC, ");
		sqlStr.append("D.REQ_SEQ, ");
		sqlStr.append("SUM(D.ORD_QTY) AS ORD_QTY, ");
		sqlStr.append("SUM(D.ORD_AMT) AS ORD_AMT, ");
		sqlStr.append("SUM(D.NET_AMT) AS NET_AMT ");
		sqlStr.append("FROM EPO_PO_D D,EPO_PO_M M ");
		sqlStr.append("WHERE M.PO_NO = D.PO_NO ");
		sqlStr.append("AND M.REQ_NO = D.REQ_NO ");
		sqlStr.append("AND M.REQ_NO = '");
		sqlStr.append(reqNo);
		sqlStr.append("' GROUP BY M.PO_NO, M.REQ_NO, D.REQ_SEQ, D.ITEM_DESC) PO ");
		sqlStr.append("WHERE ERD.REQ_NO = PO.REQ_NO(+) ");
		sqlStr.append("AND ERD.REQ_SEQ = PO.REQ_SEQ(+) ");
		sqlStr.append("AND ERD.REQ_NO = '");
		sqlStr.append(reqNo);
		sqlStr.append("' ORDER BY ERD.REQ_SEQ ASC ");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getPoDtl(String reqNo, String reqSeq) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("M.REQ_NO, ");
		sqlStr.append("M.PO_NO, ");
		sqlStr.append("TO_CHAR(M.PO_DATE,'DD/MM/YYYY HH24:MI'), ");
		sqlStr.append("D.VDR_NAME, ");
		sqlStr.append("D.ITEM_DESC, ");
		sqlStr.append("D.REQ_UNIT, ");
		sqlStr.append("D.REQ_QTY, ");
		sqlStr.append("D.ORD_QTY, ");
		sqlStr.append("D.ORD_PRICE, ");
		sqlStr.append("D.ORD_AMT, ");
		sqlStr.append("M.INS_BY, ");
		sqlStr.append("D.NET_AMT ");
		sqlStr.append("FROM EPO_PO_M M, EPO_PO_D D ");
		sqlStr.append("WHERE M.PO_NO = D.PO_NO ");
		sqlStr.append("AND M.REQ_NO = D.REQ_NO ");
		sqlStr.append("AND M.REQ_NO = '");
		sqlStr.append(reqNo);
		sqlStr.append("' AND D.REQ_SEQ = '");
		sqlStr.append(reqSeq);
		sqlStr.append("' ORDER BY M.REQ_NO, M.PO_NO, D.SEQ_NO ");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getMaskUsageHKAH(String fromDate, String toDate) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DEPT_NO, (SELECT DEPT_ENAME FROM PN_DEPT PD WHERE PD.DEPT_ID = DEPT_NO) AS DEPT_NAME, NO_OF_USAGE, NO_OF_HEADCOUNT, ");  
		sqlStr.append("NVL(A03010090050,0) AS A03010090050, NVL(A03012800047,0) AS A03012800047, NVL(A03012800336,0) AS A03012800336, ");
		sqlStr.append("NVL(A03010000094,0) AS A03010000094, NVL(A03010000112,0) AS A03010000112, NVL(A03010000010,0) AS A03010000010, ");
		sqlStr.append("NVL(A03010000033,0) AS A03010000033, NVL(A03010000019,0) AS A03010000019, NVL(A03012100020,0) AS A03012100020, ");
		sqlStr.append("NVL(A03012100169,0) AS A03012100169, NVL(A03010000207,0) AS A03010000207, NVL(A03012800197,0) AS A03012800197 ");
		sqlStr.append("FROM (");
		sqlStr.append("SELECT DEPT_NO, CODE, APPLY_QTY, NO_OF_USAGE, NO_OF_HEADCOUNT ");
		sqlStr.append("FROM (");
		sqlStr.append("SELECT M.DEPT_NO, M.CODE_NO AS CODE, "); 
		sqlStr.append("DECODE(ig.unit_flag,'1',M.end_qty,'0',ROUND(M.end_qty/ig.pack_qty,3)) AS APPLY_QTY, 0 AS NO_OF_USAGE,  0 AS NO_OF_HEADCOUNT ");
		sqlStr.append("FROM IVS_MONTH M, IVS_DEPT D, IVS_GOODS IG ");
		sqlStr.append("WHERE M.DEPT_NO = D.DEPT_NO ");
		sqlStr.append("AND M.STOCK_YM = D.STOCK_YM ");
		sqlStr.append("AND M.CODE_NO = IG.CODE_NO ");
		sqlStr.append("AND M.DEPT_NO IN ('MSC','CSR')");
		sqlStr.append("AND M.CODE_NO IN (");
		sqlStr.append("'03010090050', '03012800047', '03012800336', '03010000094', '03010000112', '03010000010', '03010000033', '03010000019', '03012100020', '03012100169', '03010000207', '03012800197') ");
		sqlStr.append("UNION ");
		sqlStr.append("SELECT M.APPLY_DEPT AS DEPT_NO, D.CODE, D.REAL_QTY, HU.NO_OF_USAGE, HU.NO_OF_HEADCOUNT ");
		sqlStr.append("FROM IVS_APPLY_M M, IVS_APPLY_D D, HEADCOUNT_USAGE HU ");
		sqlStr.append("WHERE M.APPLY_NO = D.APPLY_NO ");
		sqlStr.append("AND TRIM(M.APPLY_DEPT) = HU.DEPT_NO ");
		sqlStr.append("AND M.APPLY_DATE >= '");
		sqlStr.append(fromDate); 
		sqlStr.append("' AND M.APPLY_DATE <= '");
		sqlStr.append(toDate); 
		sqlStr.append("' AND M.APPLY_DEPT IN ('100','110','120','130','140','150','160','200','210','220','330','360','365','370','770','800') ");
		sqlStr.append("AND D.CODE IN (");		
		sqlStr.append("'03010090050', '03012800047', '03012800336', '03010000094', '03010000112', '03010000010', '03010000033', '03010000019', '03012100020', '03012100169', '03010000207', '03012800197')) ");    
		sqlStr.append(") PIVOT ");
		sqlStr.append("(SUM(APPLY_QTY) ");
		sqlStr.append("FOR CODE IN (");
		sqlStr.append("'03010090050' A03010090050, '03012800047' A03012800047, '03012800336' A03012800336, ");
		sqlStr.append("'03010000094' A03010000094, '03010000112' A03010000112, '03010000010' A03010000010, ");
		sqlStr.append("'03010000033' A03010000033, '03010000019' A03010000019, '03012100020' A03012100020, ");
		sqlStr.append("'03012100169' A03012100169, '03010000207' A03010000207, '03012800197' A03012800197) ");
		sqlStr.append(") order by 1");
		System.err.println(sqlStr.toString());
		return UtilDBWeb.getReportableListTAH(sqlStr.toString());
	}
	
	public static ArrayList getMaskUsageTWAH(String fromDate, String toDate) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DEPT_NO, (SELECT DEPT_ENAME FROM PN_DEPT PD WHERE PD.DEPT_ID = DEPT_NO) AS DEPT_NAME, NO_OF_USAGE, NO_OF_HEADCOUNT, ");  
		sqlStr.append("NVL(A03010090050,0) AS A03010090050, NVL(A03012800047,0) AS A03012800047, NVL(A03012800336,0) AS A03012800336, ");
		sqlStr.append("NVL(A03010000094,0) AS A03010000094, NVL(A03010000112,0) AS A03010000112, NVL(A03010000010,0) AS A03010000010, ");
		sqlStr.append("NVL(A03010000033,0) AS A03010000033, NVL(A03010000019,0) AS A03010000019, NVL(A03012100020,0) AS A03012100020, ");
		sqlStr.append("NVL(A03012100169,0) AS A03012100169, NVL(A03010000207,0) AS A03010000207, NVL(A03012800197,0) AS A03012800197 ");
		sqlStr.append("FROM (");
		sqlStr.append("SELECT DEPT_NO, CODE, APPLY_QTY, NO_OF_USAGE, NO_OF_HEADCOUNT ");
		sqlStr.append("FROM (");
		sqlStr.append("SELECT M.DEPT_NO, M.CODE_NO AS CODE, "); 
		sqlStr.append("DECODE(ig.unit_flag,'1',M.end_qty,'0',ROUND(M.end_qty/ig.pack_qty,3)) AS APPLY_QTY, 0 AS NO_OF_USAGE,  0 AS NO_OF_HEADCOUNT ");
		sqlStr.append("FROM IVS_MONTH M, IVS_DEPT D, IVS_GOODS IG ");
		sqlStr.append("WHERE M.DEPT_NO = D.DEPT_NO ");
		sqlStr.append("AND M.STOCK_YM = D.STOCK_YM ");
		sqlStr.append("AND M.CODE_NO = IG.CODE_NO ");
		sqlStr.append("AND M.DEPT_NO IN ('MSC','CSR')");
		sqlStr.append("AND M.CODE_NO IN (");
		sqlStr.append("'03010090050', '03012800047', '03012800336', '03010000094', '03010000112', '03010000010', '03010000033', '03010000019', '03012100020', '03012100169', '03010000207', '03012800197') ");
		sqlStr.append("UNION ");
		sqlStr.append("SELECT M.APPLY_DEPT AS DEPT_NO, D.CODE, D.REAL_QTY, HU.NO_OF_USAGE, HU.NO_OF_HEADCOUNT ");
		sqlStr.append("FROM IVS_APPLY_M M, IVS_APPLY_D D, HEADCOUNT_USAGE HU ");
		sqlStr.append("WHERE M.APPLY_NO = D.APPLY_NO ");
		sqlStr.append("AND TRIM(M.APPLY_DEPT) = HU.DEPT_NO ");
		sqlStr.append("AND M.APPLY_DATE >= '");
		sqlStr.append(fromDate); 
		sqlStr.append("' AND M.APPLY_DATE <= '");
		sqlStr.append(toDate); 
		sqlStr.append("' AND M.APPLY_DEPT IN ('100','110','120','130','140','150','160','200','210','220','330','360','365','370','770','800') ");
		sqlStr.append("AND D.CODE IN (");		
		sqlStr.append("'03010090050', '03012800047', '03012800336', '03010000094', '03010000112', '03010000010', '03010000033', '03010000019', '03012100020', '03012100169', '03010000207', '03012800197')) ");    
		sqlStr.append(") PIVOT ");
		sqlStr.append("(SUM(APPLY_QTY) ");
		sqlStr.append("FOR CODE IN (");
		sqlStr.append("'03010090050' A03010090050, '03012800047' A03012800047, '03012800336' A03012800336, ");
		sqlStr.append("'03010000094' A03010000094, '03010000112' A03010000112, '03010000010' A03010000010, ");
		sqlStr.append("'03010000033' A03010000033, '03010000019' A03010000019, '03012100020' A03012100020, ");
		sqlStr.append("'03012100169' A03012100169, '03010000207' A03010000207, '03012800197' A03012800197) ");
		sqlStr.append(") order by 1");
		System.err.println(sqlStr.toString());
		return UtilDBWeb.getReportableListTAH(sqlStr.toString());
	}	

	public static ArrayList getApprRequestDtl(String reqNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("REQ_NO, ");
		sqlStr.append("REQ_SEQ, ");
		sqlStr.append("SUPPLIER_NAME, ");
		sqlStr.append("ITEM_DESC, ");
		sqlStr.append("REQ_QTY, ");
		sqlStr.append("(OUTSTANDING*ITEM_PRICE), ");
		sqlStr.append("ITEM_PRICE, ");
		sqlStr.append("ITEM_UNIT, ");
		sqlStr.append("REMARK, ");
		sqlStr.append("INS_BY, ");
		sqlStr.append("TO_CHAR(INS_DATE,'DD/MM/YYYY HH:MI:SS'), ");
		sqlStr.append("MOD_BY, ");
		sqlStr.append("TO_CHAR(MOD_DATE,'DD/MM/YYYY HH:MI:SS'), ");
		sqlStr.append("APPROVE_FLAG, ");
		sqlStr.append("APPROVED_BY, ");
		sqlStr.append("COMPLETED, ");
		sqlStr.append("OUTSTANDING ");
		sqlStr.append("FROM EPO_REQUEST_D ");
		sqlStr.append("WHERE REQ_NO = '");
		sqlStr.append(reqNo);
		sqlStr.append("' AND APPROVE_FLAG  > 0 ");
		sqlStr.append("AND COMPLETED = 0");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}


	public static String addReqHdr( String staffID, String reqDate, String reqSiteCode, String reqDeptCode, String shipTo, String reqDesc, String reqBugcode, String amtRange, String reqRemarks, String sendApproveTo, String folderId, String currDate, String adCouncil, String boardCouncil, String financeComm, String purRmk, String reqStatus, String appGrp) {
		String reqNo = getReqNo();
		if("HKIOC".equals(appGrp) && "1".equals(amtRange) && "S".equals(reqStatus)){			
			reqStatus = "H";
		}
		System.err.println("[addReqHdr][reqNo]:"+reqNo+";[getStaffID]"+staffID);
		if(reqNo != null && reqNo.length()>0 && !"-1".equals(reqNo)){
			StringBuffer sqlStr = new StringBuffer();
			Vector<String> sqlValue = new Vector<String>();
			sqlStr.append("INSERT INTO EPO_REQUEST_M ( ");
			sqlStr.append("REQ_NO,");
			sqlStr.append("REQ_DATE,");
			sqlStr.append("REQ_BY,");
			sqlStr.append("REQ_SITE_CODE,");
			sqlStr.append("REQ_DEPT_CODE,");
			sqlStr.append("REQ_SHIP_TO,");
			sqlStr.append("REQ_DESC,");
			if ( reqBugcode!= null && reqBugcode.length() > 0) {
				sqlStr.append("BUDGET_CODE,");
			}
			sqlStr.append("AMT_RANGE,");
			sqlStr.append("REQ_STATUS,");
			if (reqRemarks!= null && reqRemarks.length() > 0) {
				sqlStr.append("REMARK,");
			}
//			if ("H".equals(reqStatus)) {
				sqlStr.append("SEND_APPROVAL,");
//			}
			sqlStr.append("INS_BY,");
			sqlStr.append("INS_DATE,");
			sqlStr.append("MOD_BY,");
			sqlStr.append("MOD_DATE,");
			sqlStr.append("APPROVE_FLAG,");
			sqlStr.append("APPROVED_BY,");
			sqlStr.append("APPROVED_DATE,");
			sqlStr.append("FOLDER_ID ");
			if (adCouncil != null && adCouncil.length() > 0) {
				sqlStr.append(", AD_COUNCIL_NO ");
			}
			if (boardCouncil != null && boardCouncil.length() > 0) {
				sqlStr.append(", BOARD_COUNCIL_NO");
			}
			if (financeComm != null && financeComm.length() > 0) {
				sqlStr.append(", FINANCE_COMM_NO");
			}
			if (purRmk != null && purRmk.length() > 0) {
				sqlStr.append(", PUR_REMARK");
			}
			sqlStr.append(") VALUES ('");
			sqlStr.append(reqNo);
			sqlStr.append("', ");
			if (reqDate != null && reqDate.length() > 0) {
				sqlStr.append("TO_DATE('");
				sqlStr.append(reqDate);
				sqlStr.append("','DD/MM/YYYY'), '");
			} else {
				sqlStr.append("sysdate, '");
			}
			sqlStr.append(staffID);
			sqlStr.append("', '");
			sqlStr.append(reqSiteCode);
			sqlStr.append("', '");
			sqlStr.append(reqDeptCode);
			sqlStr.append("', '");
			sqlStr.append(shipTo);
			sqlStr.append("', ?");
			sqlValue.add(reqDesc);
			sqlStr.append(", ");
			if (reqBugcode != null && reqBugcode.length() > 0) {
				sqlStr.append("?, ");
				sqlValue.add(reqBugcode);
			}
			sqlStr.append("TO_NUMBER('");
			sqlStr.append(amtRange);
			sqlStr.append("'), '");
			sqlStr.append(reqStatus);
			sqlStr.append("',");
			if (reqRemarks != null && reqRemarks.length() > 0) {
				sqlStr.append("?,");
				sqlValue.add(reqRemarks);
			}
//			if ("H".equals(reqStatus)) {
				sqlStr.append("'");
				sqlStr.append(sendApproveTo);
				sqlStr.append("', ");
//			}
			sqlStr.append("'");
			sqlStr.append(staffID);
			sqlStr.append("', TO_DATE('");
			sqlStr.append(currDate);
			sqlStr.append("','ddmmyyyyhh24miss'),'");
			sqlStr.append(staffID);
			sqlStr.append("', TO_DATE('");
			sqlStr.append(currDate);
			sqlStr.append("','ddmmyyyyhh24miss'),");
			sqlStr.append("0, null, null,TO_NUMBER('");
			sqlStr.append(folderId);
			sqlStr.append("') ");
			if (adCouncil != null && adCouncil.length() > 0) {
				sqlStr.append(",?");
				sqlValue.add(adCouncil);
			}
			if (boardCouncil != null && boardCouncil.length() > 0) {
				sqlStr.append(",?");
				sqlValue.add(boardCouncil);
			}
			if (financeComm != null && financeComm.length() > 0) {
				sqlStr.append(",?");
				sqlValue.add(financeComm);
			}
			if (purRmk != null && purRmk.length() > 0) {
				sqlStr.append(",?");
				sqlValue.add(purRmk);
			}
			sqlStr.append(") ");
			System.err.println(sqlStr.toString());
			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					(String[]) sqlValue.toArray(new String[sqlValue.size()]))) {
				if ((reqNo != null && reqNo.length() > 0)&&
						UtilDBWeb.updateQueue(sqlStr_insertEpoLog, new String[] {reqNo, "S", staffID, currDate })) {
						if ("H".equals(reqStatus) || "A".equals(reqStatus)) {
							UtilDBWeb.updateQueue(sqlStr_insertEpoLog, new String[] {reqNo, reqStatus, staffID, currDate });
						}
					return reqNo;
				} else {
					return null;
				}
			} else {
				return null;
			}			
		}else{
			return null;
		}
	}

	public static boolean addReqDtl(String staffID, String reqNo, String seqNo, String supplier, String itemDesc, String qty, String amount, String price, String uom, String itemRmk, String currDate, String itemAppFlag, String ApproveBy) {
		StringBuffer sqlStr = new StringBuffer();
		Vector<String> sqlValue = new Vector<String>();
		sqlStr.append("INSERT INTO EPO_REQUEST_D ( ");
		sqlStr.append("REQ_NO, ");
		sqlStr.append("REQ_SEQ, ");
		if (supplier != null && supplier.length() > 0) {
			sqlStr.append("SUPPLIER_NAME, ");
		}
		if (itemDesc != null && itemDesc.length() > 0) {
			sqlStr.append("ITEM_DESC, ");
		}
		sqlStr.append("REQ_QTY, ");
		sqlStr.append("REQ_AMOUNT, ");
		sqlStr.append("ITEM_PRICE, ");
		sqlStr.append("ITEM_UNIT, ");
		if (itemRmk != null && itemRmk.length() > 0) {
			sqlStr.append("REMARK, ");
		}
		sqlStr.append("INS_BY, ");
		sqlStr.append("INS_DATE, ");
		sqlStr.append("MOD_BY, ");
		sqlStr.append("MOD_DATE, ");
		sqlStr.append("APPROVE_FLAG, ");
		sqlStr.append("APPROVED_BY, ");
		sqlStr.append("COMPLETED, ");
		sqlStr.append("OUTSTANDING) VALUES ('");
		sqlStr.append(reqNo);
		sqlStr.append("',");
		sqlStr.append(seqNo);
		sqlStr.append(",");
		if (supplier != null && supplier.length() > 0) {
			sqlStr.append("?,");
			sqlValue.add(supplier);
		}
		if (itemDesc != null && itemDesc.length() > 0) {
			sqlStr.append("?,");
			sqlValue.add(itemDesc);
		}
		sqlStr.append("TO_NUMBER('");
		sqlStr.append(qty);
		sqlStr.append("'),TO_NUMBER('");
		sqlStr.append(amount);
		sqlStr.append("'),TO_NUMBER('");
		sqlStr.append(price);
		sqlStr.append("'),?");
		sqlValue.add(uom);
		sqlStr.append(",'");
		if (itemRmk != null && itemRmk.length() > 0) {
			sqlStr.append(itemRmk);
			sqlStr.append("','");
			sqlValue.add(itemRmk);
		}
		sqlStr.append(staffID);
		sqlStr.append("',TO_DATE('");
		sqlStr.append(currDate);
		sqlStr.append("','ddmmyyyyhh24miss'),'");
		sqlStr.append(staffID);
		sqlStr.append("',TO_DATE('");
		sqlStr.append(currDate);
		sqlStr.append("','ddmmyyyyhh24miss'),'");
		sqlStr.append(itemAppFlag);
		sqlStr.append("','");
		sqlStr.append(ApproveBy);
		sqlStr.append("', 0,TO_NUMBER('");
		sqlStr.append(qty);
		sqlStr.append("'))");
		System.err.println(sqlStr.toString());		
		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				(String[]) sqlValue.toArray(new String[sqlValue.size()]))) {
			return true;
		} else {
			return false;
		}
	}
	
	public static boolean addReqDtlLog (UserBean userBean, String reqNo, String seqNo, String supplier, String itemDesc, String qty, String amount, String price, String uom, String itemRmk, String currDate, String itemAppFlag, String ApproveBy) {
		StringBuffer sqlStr = new StringBuffer();
		Vector<String> sqlValue = new Vector<String>();
		sqlStr.append("INSERT INTO EPO_REQUEST_D_LOG ( ");
		sqlStr.append("REQ_NO, ");
		sqlStr.append("REQ_SEQ, ");
		if (supplier != null && supplier.length() > 0) {
			sqlStr.append("SUPPLIER_NAME, ");
		}
		if (itemDesc != null && itemDesc.length() > 0) {
			sqlStr.append("ITEM_DESC, ");
		}
		sqlStr.append("REQ_QTY, ");
		sqlStr.append("REQ_AMOUNT, ");
		sqlStr.append("ITEM_PRICE, ");
		if (uom != null && uom.length() > 0) {
			sqlStr.append("ITEM_UNIT, ");
		}

		if (itemRmk != null && itemRmk.length() > 0) {
			sqlStr.append("REMARK, ");
		}
		sqlStr.append("INS_BY, ");
		sqlStr.append("INS_DATE, ");
		sqlStr.append("MOD_BY, ");
		sqlStr.append("MOD_DATE, ");
		sqlStr.append("APPROVE_FLAG, ");
		sqlStr.append("APPROVED_BY, ");
		sqlStr.append("COMPLETED, ");
		sqlStr.append("OUTSTANDING) VALUES ('");
		sqlStr.append(reqNo);
		sqlStr.append("',TO_NUMBER('");
		sqlStr.append(seqNo);
		sqlStr.append("')");
		if (supplier != null && supplier.length() > 0) {
			sqlStr.append(",?");
			sqlValue.add(supplier);
		}
		if (itemDesc != null && itemDesc.length() > 0) {
			sqlStr.append(",?");
			sqlValue.add(itemDesc);
		}
		sqlStr.append(",TO_NUMBER('");
		sqlStr.append(qty);
		sqlStr.append("'),TO_NUMBER('");
		if (amount != null && amount.length() > 0) {
			sqlStr.append(amount);
		} else {
			sqlStr.append(qty);
			sqlStr.append("')*TO_NUMBER('");
			sqlStr.append(price);
		}
		sqlStr.append("'),TO_NUMBER('");
		sqlStr.append(price);
		sqlStr.append("')");
		if (uom != null && uom.length() > 0) {
			sqlStr.append(",?");
			sqlValue.add(uom);
		}
		if (itemRmk != null && itemRmk.length() > 0) {
			sqlStr.append(",?");
			sqlValue.add(itemRmk);
		}
		sqlStr.append(",'");
		sqlStr.append(userBean.getStaffID());
		sqlStr.append("',TO_DATE('");
		sqlStr.append(currDate);
		sqlStr.append("','ddmmyyyyhh24miss'),'");
		sqlStr.append(userBean.getStaffID());
		sqlStr.append("',TO_DATE('");
		sqlStr.append(currDate);
		sqlStr.append("','ddmmyyyyhh24miss'),'");
		sqlStr.append(itemAppFlag);
		sqlStr.append("','");
		sqlStr.append(ApproveBy);		
		sqlStr.append("',0,TO_NUMBER('");
		sqlStr.append(qty);
		sqlStr.append("'))");
		System.err.println(sqlStr.toString());		
		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				(String[]) sqlValue.toArray(new String[sqlValue.size()]))) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean addReqLog(UserBean userBean, String reqNo, String reqStatus, String currDate) {
		if (UtilDBWeb.updateQueue(sqlStr_insertEpoLog, new String[] {reqNo, reqStatus, userBean.getStaffID(), currDate })) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean updateRequestHdr(UserBean userBean, String reqNo, String reqDate, String reqSiteCode, String reqDeptCode, String shipTo, String reqDesc, String reqBugcode, String amtRange, String reqRemarks, String sendApproveTo, String currDate, String adCouncil, String boardCouncil, String financeComm, String reqStatus) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE EPO_REQUEST_M SET ");
		sqlStr.append("REQ_DATE = TO_DATE('");
		sqlStr.append(reqDate);
		sqlStr.append("','DD/MM/YYYY'), REQ_SITE_CODE = '");
		sqlStr.append(reqSiteCode);
		sqlStr.append("', REQ_DEPT_CODE = '");
		sqlStr.append(reqDeptCode);
		sqlStr.append("', REQ_SHIP_TO = '");
		sqlStr.append(shipTo);
		sqlStr.append("', REQ_DESC = ?");
		sqlStr.append(", REQ_STATUS = ?");
		sqlStr.append(", BUDGET_CODE = ?");
		sqlStr.append(", AD_COUNCIL_NO = ?");
		sqlStr.append(", BOARD_COUNCIL_NO = ?");
		sqlStr.append(", FINANCE_COMM_NO = ?");
		sqlStr.append(", AMT_RANGE = TO_NUMBER('");
		sqlStr.append(amtRange);
		sqlStr.append("')");
		sqlStr.append(", REMARK = ?");
		if (sendApproveTo != null && sendApproveTo.length() > 0) {
			sqlStr.append(", SEND_APPROVAL = '");
			sqlStr.append(sendApproveTo);
			sqlStr.append("'");
		}
		sqlStr.append(", MOD_BY = '");
		sqlStr.append(userBean.getStaffID());
		sqlStr.append("', MOD_DATE = TO_DATE('");
		sqlStr.append(currDate);
		sqlStr.append("','ddmmyyyyhh24miss') ");
		sqlStr.append("WHERE REQ_NO = '");
		sqlStr.append(reqNo);
		sqlStr.append("' ");
		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {reqDesc, reqStatus, reqBugcode, adCouncil, boardCouncil, financeComm, reqRemarks})) {
			if (UtilDBWeb.updateQueue(sqlStr_insertEpoLog, new String[] {reqNo, reqStatus, userBean.getStaffID(), currDate })) {
				return true;
			} else {
				return false;
			}
		} else {
			return false;
		}
	}

	public static boolean updateHdrStatus(UserBean userBean, String reqNo, String reqStatus, String reqRemarks, String sendApproveTo, String apprId, String currDate, String reqBugcode, String adCouncil, String boardCouncil, String financeComm, String approveCredit, String amtRange) {
		StringBuffer sqlStr = new StringBuffer();
		Vector<String> sqlValue = new Vector<String>();
		sqlStr.append("UPDATE EPO_REQUEST_M SET ");
		if ("A".equals(reqStatus)||"F".equals(reqStatus)) {
			sqlStr.append("APPROVED_BY = '");
			sqlStr.append(apprId);
			sqlStr.append("', CURR_CREDIT = CURR_CREDIT+TO_NUMBER('");
			sqlStr.append(approveCredit);
			sqlStr.append("'), APPROVE_FLAG = APPROVE_FLAG+1 ");
			sqlStr.append(", APPROVED_DATE = TO_DATE('");
			sqlStr.append(currDate);
			sqlStr.append("','ddMMyyyyhh24miss') ");
			if ("F".equals(reqStatus) && sendApproveTo != null && sendApproveTo.length() > 0) {
				sqlStr.append(", SEND_APPROVAL = '");
				sqlStr.append(sendApproveTo);
				sqlStr.append("' ");
			}
			sqlStr.append(", REQ_STATUS = '");
			sqlStr.append(reqStatus);
			sqlStr.append("' ");
		} else if ("R".equals(reqStatus)) {
			sqlStr.append("APPROVED_BY = '");
			sqlStr.append(apprId);
			sqlStr.append("', APPROVE_FLAG = -1 ");
			sqlStr.append(", APPROVED_DATE = TO_DATE('");
			sqlStr.append(currDate);
			sqlStr.append("','ddMMyyyyhh24miss') ");
			sqlStr.append(", REQ_STATUS = '");
			sqlStr.append(reqStatus);
			sqlStr.append("' ");
		} else if ("C".equals(reqStatus) || "S".equals(reqStatus)) {
			sqlStr.append(" REQ_STATUS = '");
			sqlStr.append(reqStatus);
			sqlStr.append("' ");
			if (sendApproveTo != null && sendApproveTo.length() > 0) {
				sqlStr.append(", SEND_APPROVAL = '");
				sqlStr.append(sendApproveTo);
				sqlStr.append("' ");
			}
			sqlStr.append(", REMARK = ?");
			sqlValue.add(reqRemarks);
		} else {
			sqlStr.append(" REQ_STATUS = '");
			sqlStr.append(reqStatus);
			sqlStr.append("' ");
		}

		if ("Z".equals(reqStatus)) {
			sqlStr.append(", MOD_BY = '");
			sqlStr.append(userBean.getStaffID());
			sqlStr.append("', MOD_DATE = TO_DATE('");
			sqlStr.append(currDate);
			sqlStr.append("','ddMMyyyyhh24miss') ");
			sqlStr.append(" WHERE REQ_NO = '");
			sqlStr.append(reqNo);
			sqlStr.append("' ");

			if (UtilDBWeb.updateQueue(sqlStr.toString())) {
				if (UtilDBWeb.updateQueue(sqlStr_insertEpoLog, new String[] {reqNo, reqStatus, userBean.getStaffID(), currDate })) {
					return true;
				} else {
					return false;
				}
			} else {
				return false;
			}
		} else if ("D".equals(reqStatus)) {
			sqlStr.append(", PUR_REMARK = ?");
			sqlValue.add(reqRemarks);
			sqlStr.append(", MOD_BY = '");
			sqlStr.append(userBean.getStaffID());
			sqlStr.append("', MOD_DATE = TO_DATE('");
			sqlStr.append(currDate);
			sqlStr.append("','ddMMyyyyhh24miss') ");
			sqlStr.append(" WHERE REQ_NO = '");
			sqlStr.append(reqNo);
			sqlStr.append("' ");

			if (UtilDBWeb.updateQueue(sqlStr.toString(),(String[]) sqlValue.toArray(new String[sqlValue.size()]))) {
				if (UtilDBWeb.updateQueue(sqlStr_insertEpoLog, new String[] {reqNo, reqStatus, userBean.getStaffID(), currDate })) {
					return true;
				} else {
					return false;
				}
			} else {
				return false;
			}
		} else {
			sqlStr.append(", BUDGET_CODE = ?");
			sqlValue.add(reqBugcode);
			sqlStr.append(", AD_COUNCIL_NO = ?");
			sqlValue.add(adCouncil);
			sqlStr.append(", BOARD_COUNCIL_NO = ?");
			sqlValue.add(boardCouncil);
			sqlStr.append(", FINANCE_COMM_NO = ?");
			sqlValue.add(financeComm);
			sqlStr.append(", AMT_RANGE = TO_NUMBER('");
			sqlStr.append(amtRange);
			sqlStr.append("'), MOD_BY = '");
			sqlStr.append(userBean.getStaffID());
			sqlStr.append("', MOD_DATE = TO_DATE('");
			sqlStr.append(currDate);
			sqlStr.append("','ddMMyyyyhh24miss') ");
			sqlStr.append(" WHERE REQ_NO = '");
			sqlStr.append(reqNo);
			sqlStr.append("' ");
			System.err.println(sqlStr.toString());
			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					(String[]) sqlValue.toArray(new String[sqlValue.size()]))) {
				if (UtilDBWeb.updateQueue(sqlStr_insertEpoLog, new String[] {reqNo, reqStatus, userBean.getStaffID(), currDate })) {
					return true;
				} else {
					return false;
				}
			} else {
				return false;
			}
		}
	}

	public static boolean updatePurRmk(String reqNo, String purRmk) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE EPO_REQUEST_M SET ");
		sqlStr.append(" PUR_REMARK = ? WHERE REQ_NO = '");
		sqlStr.append(reqNo);
		sqlStr.append("'");
		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {purRmk})) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean updateApprRmk(String reqNo, String apprRmk) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE EPO_REQUEST_M SET ");
		sqlStr.append(" APPR_REMARK = ? WHERE REQ_NO = '");
		sqlStr.append(reqNo);
		sqlStr.append("'");
		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {apprRmk})) {
			return true;
		} else {
			return false;
		}
	}

	public static int updateItemDtl(UserBean userBean, String reqNo, String reqSeq, String appFlag, String reqQty, String itemPrice, String currDate) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE EPO_REQUEST_D SET ");
		sqlStr.append("MOD_BY = '");
		sqlStr.append(userBean.getStaffID());
		sqlStr.append("', MOD_DATE = TO_DATE('");
		sqlStr.append(currDate);
		sqlStr.append("','ddMMyyyyhh24miss') ");
		if (Integer.parseInt(appFlag) > 0) {
			sqlStr.append(", REQ_QTY = TO_NUMBER('");
			sqlStr.append(reqQty);
			sqlStr.append("'), REQ_AMOUNT = TO_NUMBER('");
			sqlStr.append(reqQty);
			sqlStr.append("')*TO_NUMBER('");
			sqlStr.append(itemPrice);
			sqlStr.append("'), ITEM_PRICE = TO_NUMBER('");
			sqlStr.append(itemPrice);
			sqlStr.append("'), OUTSTANDING = TO_NUMBER('");
			sqlStr.append(reqQty);
			sqlStr.append("'), APPROVE_FLAG = 1 ");
			sqlStr.append(", APPROVED_BY = '");
			sqlStr.append(userBean.getStaffID());
			sqlStr.append("' ");
		} else {
			sqlStr.append(", APPROVE_FLAG = -1 ");
			sqlStr.append(", APPROVED_BY = '");
			sqlStr.append(userBean.getStaffID());
			sqlStr.append("' ");
		}
		sqlStr.append(" WHERE REQ_NO = '");
		sqlStr.append(reqNo);
		sqlStr.append("' AND REQ_SEQ = '");
		sqlStr.append(reqSeq);
		sqlStr.append("'");
		return UtilDBWeb.updateQueueInt(sqlStr.toString());
	}


	public static int updateDtlModDt(UserBean userBean, String reqNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE EPO_REQUEST_D SET ");
		sqlStr.append("MOD_BY = '");
		sqlStr.append(userBean.getStaffID());
		sqlStr.append("', MOD_DATE = SYSDATE ");
		sqlStr.append(" WHERE REQ_NO = '");
		sqlStr.append(reqNo);
		sqlStr.append("'");
		return UtilDBWeb.updateQueueInt(sqlStr.toString());
	}
	
	public static int updateDtlWhenPOCancel(UserBean userBean, String reqNo, String itemDesc) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE EPO_REQUEST_D SET ");
		sqlStr.append("APPROVE_FLAG = '-1', REMARK = REMARK||' [Cancel by Purchasing Dept.]', ");		
		sqlStr.append("MOD_BY = '");
		sqlStr.append(userBean.getStaffID());
		sqlStr.append("', MOD_DATE = SYSDATE ");
		sqlStr.append(" WHERE REQ_NO = '");
		sqlStr.append(reqNo);
		sqlStr.append("' AND item_desc = '");
		sqlStr.append(itemDesc);
		sqlStr.append("'");		
		return UtilDBWeb.updateQueueInt(sqlStr.toString());
	}	

	public static boolean delReqDtl(String reqNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("DELETE FROM EPO_REQUEST_D WHERE REQ_NO = '");
		sqlStr.append(reqNo);
		sqlStr.append("' ");
		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean addPoHdr(String poNO, String reqNo, String poDate, String poSiteCode, String poDeptCode, String shipTo,
								String budgetCode, String vdrCode, String vdrStaff, String vdrTel, String vdrFax, String vdrEmail, String vdrAddr, String dlvDate, String dlvPlace,
								String invType, String payType, String remark, String completed, String cancelFlag, String cancelRsn, String ordAmt, String payAmt,
								String disAmt, String exFeeID, String exCharges, String transCharges, String giftAmt, String invDis, String desposit, String currencyID,
								String exRate, String insBy, String modBy, String apprFlag, String approBy, String apprDate, String eSendFlag, String eSendBy, String eSendDate, String folderID, String currDate) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO EPO_PO_M ( ");
		sqlStr.append("PO_NO, ");
		sqlStr.append("REQ_NO, ");
		sqlStr.append("PO_DATE, ");
		sqlStr.append("PO_SITE_CODE, ");
		sqlStr.append("PO_DEPT_CODE, ");
		sqlStr.append("PO_SHIP_TO, ");
		sqlStr.append("BUDGET_CODE, ");
		sqlStr.append("VDR_CODE, ");
		sqlStr.append("VDR_STAFF, ");
		sqlStr.append("VDR_TEL, ");
		sqlStr.append("VDR_FAX, ");
		sqlStr.append("VDR_EMAIL, ");
		sqlStr.append("VDR_ADDR, ");
		sqlStr.append("DLV_DATE, ");
		sqlStr.append("DLV_PLACE, ");
		sqlStr.append("INV_TYPE, ");
		sqlStr.append("PAY_TYPE, ");
		sqlStr.append("REMARK, ");
		sqlStr.append("COMPLETED, ");
		sqlStr.append("CANCEL_FLAG, ");
		sqlStr.append("CANCEL_RSN, ");
		sqlStr.append("ORD_AMT, ");
		sqlStr.append("PAY_AMT, ");
		sqlStr.append("DISC_AMT, ");
		sqlStr.append("EX_FEE_ID, ");
		sqlStr.append("EX_CHARGES, ");
		sqlStr.append("TRANS_CHARGES, ");
		sqlStr.append("GIFT_AMT, ");
		sqlStr.append("INV_DIS, ");
		sqlStr.append("DEPOSIT, ");
		sqlStr.append("CURRENCY_ID, ");
		sqlStr.append("EX_RATE, ");
		sqlStr.append("INS_BY, ");
		sqlStr.append("INS_DATE, ");
		sqlStr.append("MOD_BY, ");
		sqlStr.append("MOD_DATE, ");
		sqlStr.append("APPROVE_FLAG, ");
		sqlStr.append("APPROVED_BY, ");
		sqlStr.append("APPROVED_DATE, ");
		sqlStr.append("ESEND_FLAG, ");
		sqlStr.append("ESEND_BY, ");
		sqlStr.append("ESEND_DATE, ");
		sqlStr.append("FOLDER_ID) VALUES ('");
		sqlStr.append(poNO);
		sqlStr.append("','");
		sqlStr.append(reqNo);
		sqlStr.append("',");
		sqlStr.append("TO_DATE('");
		sqlStr.append(poDate);
		sqlStr.append("','DD/MM/YYYY'), '");
		sqlStr.append(poSiteCode);
		sqlStr.append("','");
		sqlStr.append(poDeptCode);
		sqlStr.append("','");
		sqlStr.append(shipTo);
		sqlStr.append("',");
		if (budgetCode != null && budgetCode.length() > 0) {
			sqlStr.append("'");
			sqlStr.append(budgetCode);
			sqlStr.append("',");
		} else {
			sqlStr.append("null,");
		}
		if (vdrCode != null && vdrCode.length() > 0) {
			sqlStr.append("'");
			sqlStr.append(vdrCode);
			sqlStr.append("',");
		} else {
			sqlStr.append("null,");
		}
		if (vdrStaff != null && vdrStaff.length() > 0) {
			sqlStr.append("'");
			sqlStr.append(vdrStaff);
			sqlStr.append("',");
		} else {
			sqlStr.append("null,");
		}
		if (vdrTel != null && vdrTel.length() > 0) {
			sqlStr.append("'");
			sqlStr.append(vdrTel);
			sqlStr.append("',");
		} else {
			sqlStr.append("null,");
		}
		if (vdrFax != null && vdrFax.length() > 0) {
			sqlStr.append("'");
			sqlStr.append(vdrFax);
			sqlStr.append("',");
		} else {
			sqlStr.append("null,");
		}
		if (vdrEmail != null && vdrEmail.length() > 0) {
			sqlStr.append("'");
			sqlStr.append(vdrEmail);
			sqlStr.append("',");
		} else {
			sqlStr.append("null,");
		}
		if (vdrAddr != null && vdrAddr.length() > 0) {
			sqlStr.append("'");
			sqlStr.append(vdrAddr);
			sqlStr.append("',");
		} else {
			sqlStr.append("null,");
		}
		if (dlvDate != null && dlvDate.length() > 0) {
			sqlStr.append("TO_DATE('");
			sqlStr.append(dlvDate);
			sqlStr.append("','DD/MM/YYYY'), '");
		} else {
			sqlStr.append("null,");
		}
		if (dlvPlace != null && dlvPlace.length() > 0) {
			sqlStr.append("'");
			sqlStr.append(dlvPlace);
			sqlStr.append("',");
		} else {
			sqlStr.append("null,");
		}
		if (invType != null && invType.length() > 0) {
			sqlStr.append("'");
			sqlStr.append(invType);
			sqlStr.append("',");
		} else {
			sqlStr.append("null,");
		}
		if (payType != null && payType.length() > 0) {
			sqlStr.append("'");
			sqlStr.append(payType);
			sqlStr.append("',");
		} else {
			sqlStr.append("null,");
		}
		if (remark != null && remark.length() > 0) {
			sqlStr.append("'");
			sqlStr.append(remark);
			sqlStr.append("',");
		} else {
			sqlStr.append("null,");
		}
		sqlStr.append("TO_NUMBER('");
		sqlStr.append(completed);
		sqlStr.append("'),TO_NUMBER('");
		sqlStr.append(cancelFlag);
		sqlStr.append("'),");
		if (cancelRsn != null && cancelRsn.length() > 0) {
			sqlStr.append("'");
			sqlStr.append(cancelRsn);
			sqlStr.append("',");
		} else {
			sqlStr.append("null,");
		}
		sqlStr.append("TO_NUMBER('");
		sqlStr.append(ordAmt);
		sqlStr.append("'),TO_NUMBER('");
		sqlStr.append(payAmt);
		sqlStr.append("'),TO_NUMBER('");
		sqlStr.append(disAmt);
		sqlStr.append("'),");
		if (exFeeID != null && exFeeID.length() > 0) {
			sqlStr.append("'");
			sqlStr.append(exFeeID);
			sqlStr.append("',");
		} else {
			sqlStr.append("null,");
		}
		sqlStr.append("TO_NUMBER('");
		sqlStr.append(exCharges);
		sqlStr.append("'),TO_NUMBER('");
		sqlStr.append(transCharges);
		sqlStr.append("'),TO_NUMBER('");
		sqlStr.append(giftAmt);
		sqlStr.append("'),TO_NUMBER('");
		sqlStr.append(invDis);
		sqlStr.append("'),TO_NUMBER('");
		sqlStr.append(desposit);
		sqlStr.append("'),");
		if (currencyID != null && currencyID.length() > 0) {
			sqlStr.append("'");
			sqlStr.append(currencyID);
			sqlStr.append("',");
		} else {
			sqlStr.append("null,");
		}

		sqlStr.append("TO_NUMBER('");
		sqlStr.append(exRate);
		sqlStr.append("'),'");
		sqlStr.append(insBy);
		sqlStr.append("',TO_DATE('");
		sqlStr.append(currDate);
		sqlStr.append("','ddmmyyyyhh24miss'),'");
		sqlStr.append(modBy);
		sqlStr.append("',TO_DATE('");
		sqlStr.append(currDate);
		sqlStr.append("','ddmmyyyyhh24miss'),");
		sqlStr.append("TO_NUMBER('");
		sqlStr.append(apprFlag);
		sqlStr.append("'),");
		if (approBy != null && approBy.length() > 0) {
			sqlStr.append("'");
			sqlStr.append(approBy);
			sqlStr.append("',");
		} else {
			sqlStr.append("null,");
		}
		if (apprDate != null && apprDate.length() > 0) {
			sqlStr.append("TO_DATE('");
			sqlStr.append(apprDate);
			sqlStr.append("','DD/MM/YYYY'), ");
		} else {
			sqlStr.append("null,");
		}
		sqlStr.append("TO_NUMBER('");
		sqlStr.append(eSendFlag);
		sqlStr.append("'),");
		if (eSendBy != null && eSendBy.length() > 0) {
			sqlStr.append("'");
			sqlStr.append(eSendBy);
			sqlStr.append("',");
		} else {
			sqlStr.append("null,");
		}
		if (eSendDate != null && eSendDate.length() > 0) {
			sqlStr.append("TO_DATE('");
			sqlStr.append(eSendDate);
			sqlStr.append("','DD/MM/YYYY'), ");
		} else {
			sqlStr.append("null,");
		}
		sqlStr.append("TO_NUMBER('");
		sqlStr.append(folderID);
		sqlStr.append("')) ");
		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean updateHdrAmount(String poNO, String ordAmt, String payAmt) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE EPO_PO_M SET ");
		sqlStr.append("ORD_AMT = ORD_AMT + TO_NUMBER('");
		sqlStr.append(ordAmt);
		sqlStr.append("'), PAY_AMT = ORD_AMT + TO_NUMBER('");
		sqlStr.append(payAmt);
		sqlStr.append("') WHERE PO_NO = '");
		sqlStr.append(poNO);
		sqlStr.append("'");
		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean addPoDtl(UserBean userBean, String poNO, String reqNO, String seqNO, String reqSeq, String itemDesc, String vdrName, String vdrItemCode, String uom, String reqQty, String ordQty, String price, String amount, String itemRmk, String currDate, String netAmount) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO EPO_PO_D ( ");
		sqlStr.append("PO_NO,");
		sqlStr.append("REQ_NO,");
		sqlStr.append("SEQ_NO,");
		sqlStr.append("ITEM_DESC,");
		sqlStr.append("VDR_NAME,");
		sqlStr.append("VDR_ITEM_CODE,");
		sqlStr.append("REQ_UNIT,");
		sqlStr.append("REQ_QTY,");
		sqlStr.append("ORD_QTY,");
		sqlStr.append("ORD_PRICE,");
		sqlStr.append("ORD_AMT,");
		sqlStr.append("REMARK,");
		sqlStr.append("INS_BY,");
		sqlStr.append("INS_DATE,");
		sqlStr.append("MOD_BY,");
		sqlStr.append("MOD_DATE,");
		sqlStr.append("REQ_SEQ,");
		sqlStr.append("NET_AMT) VALUES ('");
		sqlStr.append(poNO);
		sqlStr.append("','");
		sqlStr.append(reqNO);
		sqlStr.append("',(SELECT NVL(MAX(SEQ_NO),0)+TO_NUMBER('");
		sqlStr.append(seqNO);
		sqlStr.append("') FROM EPO_PO_D WHERE PO_NO = '");
		sqlStr.append(poNO);
		sqlStr.append("')");
		sqlStr.append(",?,?,?,?,TO_NUMBER('");
		sqlStr.append(reqQty);
		sqlStr.append("'),TO_NUMBER('");
		sqlStr.append(ordQty);
		sqlStr.append("'),TO_NUMBER('");
		sqlStr.append(price);
		sqlStr.append("'),TO_NUMBER('");
		sqlStr.append(amount);
		sqlStr.append("'),");
		if (itemRmk != null && itemRmk.length() > 0) {
			sqlStr.append("'");
			sqlStr.append(itemRmk);
			sqlStr.append("',");
		} else {
			sqlStr.append("null,");
		}
		sqlStr.append("'");
		sqlStr.append(userBean.getStaffID());
		sqlStr.append("',TO_DATE('");
		sqlStr.append(currDate);
		sqlStr.append("','ddmmyyyyhh24miss'),'");
		sqlStr.append(userBean.getStaffID());
		sqlStr.append("',TO_DATE('");
		sqlStr.append(currDate);
		sqlStr.append("','ddmmyyyyhh24miss'),");
		sqlStr.append(reqSeq);
		sqlStr.append(",TO_NUMBER('");
		sqlStr.append(netAmount);
		sqlStr.append("'))");
		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {itemDesc, vdrName, vdrItemCode, uom})) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean updateReqDtlRemain(UserBean userBean, String reqNO, String seqNO, String reqQty, String ordQty, String currDate) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE EPO_REQUEST_D SET ");
		sqlStr.append(" OUTSTANDING = DECODE(SIGN(OUTSTANDING - TO_NUMBER('");
		sqlStr.append(ordQty);
		sqlStr.append("')),1,OUTSTANDING - TO_NUMBER('");
		sqlStr.append(ordQty);
		sqlStr.append("'),-1,0,0,0)");
		sqlStr.append(", MOD_BY ='");
		sqlStr.append(userBean.getStaffID());
		sqlStr.append("', MOD_DATE = TO_DATE('");
		sqlStr.append(currDate);
		sqlStr.append("','ddmmyyyyhh24miss') ");
		sqlStr.append("WHERE REQ_NO = '");
		sqlStr.append(reqNO);
		sqlStr.append("' AND REQ_SEQ = '");
		sqlStr.append(seqNO);
		sqlStr.append("'");
		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
			return true;
		} else {
			return false;
		}
	}

	public static String finalApprover(String reqNo, String flowId, String flowSeq, String amtID, String apprId) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT F_CHK_FINAL_APPROVAL('");
		sqlStr.append(reqNo);
		sqlStr.append("','");
		sqlStr.append(flowId);
		sqlStr.append("','");
		sqlStr.append(flowSeq);
		sqlStr.append("','");
		sqlStr.append(amtID);
		sqlStr.append("','");
		sqlStr.append(apprId);
		sqlStr.append("') FROM DUAL");
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			return row.getFields0();
		} else {
			return null;
		}
	}

	public static String getApprovalCode(String amtID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT EAL.REQUIRE_APPROVAL");
		sqlStr.append(" FROM EPO_APPROVE_LEVEL EAL");
		sqlStr.append(" WHERE EAL.AMOUNT_ID = TO_NUMBER('");
		sqlStr.append(amtID);
		sqlStr.append("')");
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			return row.getFields0();
		} else {
			return null;
		}
	}

	public static String countOfApproval(String reqNo, String apprId) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT COUNT(RECORD_STATUS) FROM EPO_REQUEST_LOG");
		sqlStr.append(" WHERE EPO_NO = '");
		sqlStr.append(reqNo);
		sqlStr.append("' AND INSERT_BY = '");
		sqlStr.append(apprId);
		sqlStr.append("' AND RECORD_STATUS IN ('A','F')");
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			return row.getFields0();
		} else {
			return null;
		}
	}

	public static ArrayList existPoListByReq(String reqNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DISTINCT PO_NO FROM EPO_PO_M");
		sqlStr.append(" WHERE REQ_NO = '");
		sqlStr.append(reqNo);
		sqlStr.append("' ORDER BY 1");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	public static ArrayList existPoListByPo(String poNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DISTINCT PO_NO FROM EPO_PO_M");
		sqlStr.append(" WHERE PO_NO = '");
		sqlStr.append(poNo);
		sqlStr.append("' ORDER BY 1");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getRelatedList(String flowID, String flowSeq, String appGrp) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("STAFF_ID ");
		sqlStr.append("FROM EPO_APPROVE_LIST ");
		sqlStr.append("WHERE FLOW_ID = TO_NUMBER('");
		sqlStr.append(flowID);
		sqlStr.append("') AND FLOW_SEQ = TO_NUMBER('");
		sqlStr.append(flowSeq);
		sqlStr.append("') AND APPROVAL_GROUP ='");
		sqlStr.append(appGrp);
		sqlStr.append("'");		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static boolean isApprover(UserBean userBean, String appGrp) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 FROM EPO_APPROVE_LIST ");
		sqlStr.append(" WHERE FLOW_ID = 1");
		sqlStr.append(" AND FLOW_SEQ = 1");
		sqlStr.append(" AND STAFF_ID = '");
		sqlStr.append(userBean.getStaffID());
		sqlStr.append("' AND APPROVAL_GROUP ='");
		sqlStr.append(appGrp);
		sqlStr.append("'");
		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean isPurchaser(UserBean userBean, String appGrp) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 FROM EPO_APPROVE_LIST ");
		sqlStr.append(" WHERE FLOW_ID = 1");
		sqlStr.append(" AND FLOW_SEQ = 2");
		sqlStr.append(" AND STAFF_ID = '");
		sqlStr.append(userBean.getStaffID());
		sqlStr.append("' AND APPROVAL_GROUP ='");
		sqlStr.append(appGrp);
		sqlStr.append("'");		
		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
			return true;
		} else {
			return false;
		}
	}
	
	public static boolean isVPF(UserBean userBean, String appGrp) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 FROM EPO_APPROVE_LIST ");
		sqlStr.append(" WHERE FLOW_ID = 1");
		sqlStr.append(" AND FLOW_SEQ = 4");
		sqlStr.append(" AND STAFF_ID = '");
		sqlStr.append(userBean.getStaffID());
		sqlStr.append("' AND APPROVAL_GROUP ='");
		sqlStr.append(appGrp);
		sqlStr.append("'");		
		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
			return true;
		} else {
			return false;
		}
	}	
	
	private static String getDIDeptHead() {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_DEPARTMENT_HEAD");
		sqlStr.append(" FROM CO_DEPARTMENTS");
		sqlStr.append(" WHERE CO_DEPARTMENT_CODE = 280");
		System.err.println(sqlStr.toString());
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			return row.getFields0();
		} else {
			return null;
		}
	}
	
	public static  boolean isDIDept(String deptCode) {
		String deptHead = getDIDeptHead();
		
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 FROM CO_DEPARTMENTS ");
		sqlStr.append(" WHERE CO_DEPARTMENT_CODE = '");
		sqlStr.append(deptCode);		
		sqlStr.append("' AND CO_DEPARTMENT_HEAD = '");
		sqlStr.append(deptHead);
		sqlStr.append("' ");
		System.err.println(sqlStr.toString());
		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
			return true;
		} else {
			return false;
		}
	}	

	public static ArrayList getTrackList(String user, String reqNo, String siteCode, String reqDept, String reqStatus, String fromReqDate, String toReqDate, String reqBugcode, String itemDesc, String appGrp) {
		System.err.println("[user]:"+user+"[reqDept]:"+reqDept+"[reqDept]:"+appGrp+"[fromReqDate]:"+fromReqDate+"[toReqDate]:"+toReqDate+"[appGrp]:"+appGrp);
		StringBuffer sqlStr = new StringBuffer();
		Vector<String> sqlValue = new Vector<String>();
		// turned by abraham [2016-02-12] : begin
		sqlStr.append("WITH MQ_EPO_REQUEST_LOG as ( SELECT /*+ materialize */ ERL.EPO_NO FROM EPO_REQUEST_LOG ERL WHERE ERL.INSERT_BY = ? ) ");
		sqlValue.add(user);		
		// end
		sqlStr.append("SELECT ");
		sqlStr.append("ERM.REQ_NO, ");
		sqlStr.append("TO_CHAR(ERM.REQ_DATE,'YYYY/MM/DD') AS REQ_DATE, ");
		sqlStr.append("(SELECT DISTINCT CS.CO_STAFFNAME FROM CO_STAFFS CS WHERE ERM.REQ_BY = CS.CO_STAFF_ID) AS REQ_BY, ");    
		sqlStr.append("(SELECT CD.CO_DEPARTMENT_DESC FROM CO_DEPARTMENTS CD WHERE CD.CO_DEPARTMENT_CODE = ERM.REQ_DEPT_CODE) AS REQ_DEPT, ");
		sqlStr.append("ERM.REQ_DESC, ");
		sqlStr.append("ERM.BUDGET_CODE, ");
		sqlStr.append("DECODE(ERM.REQ_STATUS,'A','Approved','C','Cancelled','F','Further approve','D','Pending','Z','PO Processing','P','Partial order','R','Rejected','S','Waiting for department head','O','Ordered','H','Waiting approve') AS REQSTATUS, ");
		sqlStr.append("(SELECT DISTINCT CS.CO_STAFFNAME FROM CO_STAFFS CS WHERE ERM.MOD_BY = CS.CO_STAFF_ID) AS LAST_MOD_BY, ");
		sqlStr.append("ERM.REQ_SITE_CODE, ");
		sqlStr.append("ERM.REQ_STATUS, ");
		sqlStr.append("ERM.FOLDER_ID, ");
		sqlStr.append("ERM.REQ_BY, ");
		sqlStr.append("(SELECT CD.CO_DEPARTMENT_HEAD FROM CO_DEPARTMENTS CD WHERE CD.CO_DEPARTMENT_CODE = ERM.REQ_DEPT_CODE) AS DEPARTMENT_HEAD, ");
		sqlStr.append("ERM.REQ_DEPT_CODE, ");
		sqlStr.append("ERM.SEND_APPROVAL ");		
		sqlStr.append(" FROM ( ");
		sqlStr.append("SELECT DISTINCT ");
		sqlStr.append("ERM.REQ_NO, ");
		sqlStr.append("ERM.REQ_DATE, ");
		sqlStr.append("ERM.REQ_BY, ");
		sqlStr.append("ERM.REQ_DEPT_CODE, ");
		sqlStr.append("ERM.REQ_DESC, ");
		sqlStr.append("ERM.BUDGET_CODE, ");
		sqlStr.append("ERM.AD_COUNCIL_NO, ");
		sqlStr.append("ERM.BOARD_COUNCIL_NO, ");
		sqlStr.append("ERM.FINANCE_COMM_NO, ");
		sqlStr.append("ERM.REQ_STATUS, ");
		sqlStr.append("ERM.MOD_BY, ");
		sqlStr.append("ERM.REQ_SITE_CODE, ");
		sqlStr.append("ERM.FOLDER_ID, ");
		sqlStr.append("ERM.SEND_APPROVAL ");		
		sqlStr.append(" FROM EPO_REQUEST_M ERM, EPO_REQUEST_D ERD ");
		sqlStr.append(" WHERE ERM.REQ_NO = ERD.REQ_NO ");
		if (itemDesc != null && itemDesc.length() > 0) {
			sqlStr.append(" AND (UPPER(ERD.ITEM_DESC) LIKE '%'||UPPER(TRIM(?))||'%'");
			sqlStr.append(" OR UPPER(ERM.REQ_DESC) LIKE '%'||UPPER(TRIM(?))||'%') ");
			sqlValue.add(itemDesc);
			sqlValue.add(itemDesc);			
		}
		if ("admin".equals(user) || "itadmin".equals(user)) {
			sqlStr.append(" ) ERM ");		
		} else {
			sqlStr.append(" AND (ERM.REQ_BY = ? OR ");
			sqlValue.add(user);
			sqlStr.append(" ERM.REQ_NO IN (SELECT REQ_NO FROM EPO_REQUEST_M WHERE REQ_DEPT_CODE = (SELECT DISTINCT CS.CO_DEPARTMENT_CODE FROM CO_STAFFS CS WHERE CS.CO_STAFF_ID = ?)) OR ");
			sqlValue.add(user);
			sqlStr.append(" ERM.REQ_DEPT_CODE IN (SELECT CO_DEPARTMENT_CODE FROM CO_STAFF_DEPARTMENTS WHERE CO_STAFF_ID = ? AND CO_ENABLED = 1) OR ");
			sqlValue.add(user);
			sqlStr.append(" ERM.REQ_DEPT_CODE IN (SELECT CO_DEPARTMENT_CODE FROM CO_DEPARTMENTS WHERE CO_DEPARTMENT_HEAD = ?) OR ");
			sqlValue.add(user);
	/*
			sqlStr.append(" ERM.REQ_BY IN (");
			sqlStr.append("SELECT DISTINCT CU.CO_USERNAME");
			sqlStr.append(" FROM CO_STAFFS CS, CO_USERS CU");
			sqlStr.append(" WHERE CS.CO_STAFF_ID = CU.CO_STAFF_ID");
			sqlStr.append(" AND (CS.CO_DEPARTMENT_CODE IN (SELECT CO_DEPARTMENT_CODE FROM CO_DEPARTMENTS WHERE CO_DEPARTMENT_HEAD = ? ) OR ");
			sqlValue.add(user);
			sqlStr.append(" CS.CO_DEPARTMENT_CODE IN (SELECT CO_DEPARTMENT_CODE FROM CO_DEPARTMENTS WHERE CO_DEPARTMENT_HEAD = (SELECT CO_STAFF_ID FROM CO_USERS WHERE CO_USERNAME = ? )))) OR ");
			sqlValue.add(user);
	*/
	        // turned by abraham [2016-02-12] : begin
			// sqlStr.append(" ERM.REQ_NO IN (SELECT ERL.EPO_NO FROM EPO_REQUEST_LOG ERL WHERE ERL.INSERT_BY = ? ) OR ");
			sqlStr.append(" ERM.REQ_NO IN (SELECT EPO_NO FROM MQ_EPO_REQUEST_LOG ) OR ");
			//sqlValue.add(user);			
			// end
			sqlStr.append(" ERM.SEND_APPROVAL = ? OR ");
			sqlValue.add(user);
			sqlStr.append(" DECODE((SELECT 1 FROM EPO_APPROVE_LIST WHERE FLOW_ID = 1 AND FLOW_SEQ = 2 AND STAFF_ID = ? AND APPROVAL_GROUP = ?),1,ERM.REQ_STATUS,ERM.REQ_NO) IN ('A','Z','P','O','D') OR ");
			sqlValue.add(user);
			sqlValue.add(appGrp);			
			sqlStr.append(" DECODE((SELECT 1 FROM EPO_APPROVE_LIST WHERE FLOW_ID = 1 AND FLOW_SEQ = 4 AND STAFF_ID = ? AND APPROVAL_GROUP = ?),1,ERM.REQ_STATUS,ERM.REQ_NO) IN ('A','Z','P','O','D') OR ");
			sqlValue.add(user);
			sqlValue.add(appGrp);
			sqlStr.append(" DECODE((SELECT 1 FROM EPO_APPROVE_LIST WHERE FLOW_ID = 1 AND FLOW_SEQ = 6 AND STAFF_ID = ? AND APPROVAL_GROUP = ?),1,ERM.REQ_STATUS,ERM.REQ_NO) IN ('A','Z','P','O','D','S','H','C','F') OR ");
			sqlValue.add(user);
			sqlValue.add(appGrp);			
			sqlStr.append(" DECODE((SELECT 1 FROM EPO_APPROVE_LIST WHERE FLOW_ID = 1 AND FLOW_SEQ = 3 AND STAFF_ID = ? AND APPROVAL_GROUP = ?),1,ERM.REQ_STATUS,ERM.REQ_NO) IN ('A','Z','P','O','D'))) ERM ");
			sqlValue.add(user);
			sqlValue.add(appGrp);			
		}
		sqlStr.append(" WHERE ERM.REQ_SITE_CODE = '");
		sqlStr.append(siteCode);
		sqlStr.append("'");
		if (reqNo != null && reqNo.length() > 0) {
			sqlStr.append(" AND ERM.REQ_NO = ?");
			sqlValue.add(reqNo);
		}
		if (reqStatus != null && reqStatus.length() > 0) {
			sqlStr.append(" AND ERM.REQ_STATUS = ?");
			sqlValue.add(reqStatus);
		}
		if (fromReqDate != null && fromReqDate.length() > 0) {
			sqlStr.append(" AND ERM.REQ_DATE >= TO_DATE(?,'DD/MM/YYYY')");
			sqlValue.add(fromReqDate);
		}
		if (toReqDate != null && toReqDate.length() > 0) {
			sqlStr.append(" AND ERM.REQ_DATE <= TO_DATE(?,'DD/MM/YYYY')");
			sqlValue.add(toReqDate);
		}
		if (reqDept != null && reqDept.length() > 0) {
			sqlStr.append(" AND ERM.REQ_DEPT_CODE = ?");
			sqlValue.add(reqDept);
		}
		if ((reqBugcode != null && reqBugcode.length() > 0)) {
			sqlStr.append(" AND (UPPER(ERM.BUDGET_CODE) = UPPER(?) OR ");
			sqlValue.add(reqBugcode);
			sqlStr.append(" UPPER(ERM.AD_COUNCIL_NO) = UPPER(?) OR");
			sqlValue.add(reqBugcode);
			sqlStr.append(" UPPER(ERM.BOARD_COUNCIL_NO) = UPPER(?) OR");
			sqlValue.add(reqBugcode);
			sqlStr.append(" UPPER(ERM.FINANCE_COMM_NO) = UPPER(?))");
			sqlValue.add(reqBugcode);
		}
		sqlStr.append(" ORDER BY ERM.REQ_DATE DESC, ERM.REQ_NO DESC ");
		System.err.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(
				sqlStr.toString(),
				(String[]) sqlValue.toArray(new String[sqlValue.size()]));
	}

	public static ArrayList getTrackDtl(String reqNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("R.ITEM_DESC, ");
		sqlStr.append("R.SUPPLIER_NAME, ");
		sqlStr.append("R.REQ_QTY, ");
		sqlStr.append("R.ITEM_UNIT, ");
		sqlStr.append("R.ITEM_PRICE, ");
		sqlStr.append("R.REQ_AMOUNT, ");
		sqlStr.append("P.PO_NO, ");
		sqlStr.append("P.ORD_QTY, ");
		sqlStr.append("P.ORD_PRICE, ");
		sqlStr.append("P.ORD_AMT, ");
		sqlStr.append("P.VDR_NAME, ");
		sqlStr.append("R.INS_DATE, ");
		sqlStr.append("R.REQ_SEQ, ");
		sqlStr.append("P.NET_AMT ");
		sqlStr.append("FROM ( ");
		sqlStr.append("SELECT ERM.REQ_NO, ");
		sqlStr.append("ERD.REQ_SEQ, ");
		sqlStr.append("ERD.ITEM_DESC, ");
		sqlStr.append("ERD.SUPPLIER_NAME, ");
		sqlStr.append("ERD.REQ_QTY, ");
		sqlStr.append("ERD.ITEM_UNIT, ");
		sqlStr.append("ERD.ITEM_PRICE, ");
		sqlStr.append("ERD.REQ_AMOUNT, ");
		sqlStr.append("ERD.INS_DATE ");
		sqlStr.append("FROM EPO_REQUEST_M ERM, EPO_REQUEST_D ERD ");
		sqlStr.append("WHERE ERM.REQ_NO = ERD.REQ_NO(+) ");
		sqlStr.append("AND ERM.REQ_NO = '");
		sqlStr.append(reqNo);
		sqlStr.append("')R,( ");
		sqlStr.append("SELECT EPM.PO_NO, ");
		sqlStr.append("EPM.REQ_NO, ");
		sqlStr.append("EPD.REQ_SEQ, ");
		sqlStr.append("EPD.VDR_NAME, ");
		sqlStr.append("EPD.ITEM_DESC, ");
		sqlStr.append("EPD.ORD_QTY, ");
		sqlStr.append("EPD.ORD_PRICE, ");
		sqlStr.append("EPD.ORD_AMT, ");
		sqlStr.append("EPD.NET_AMT ");
		sqlStr.append("FROM EPO_PO_M EPM, EPO_PO_D EPD ");
		sqlStr.append("WHERE EPM.PO_NO = EPD.PO_NO(+) ");
		sqlStr.append("AND EPM.REQ_NO = EPD.REQ_NO(+) ");
		sqlStr.append("AND EPM.REQ_NO = '");
		sqlStr.append(reqNo);
		sqlStr.append("')P ");
		sqlStr.append("WHERE R.REQ_NO = P.REQ_NO(+) ");
		sqlStr.append("AND R.REQ_SEQ = P.REQ_SEQ(+) ");
		sqlStr.append("AND R.REQ_NO = '");
		sqlStr.append(reqNo);
		sqlStr.append("' ");
		sqlStr.append("ORDER BY R.INS_DATE ASC");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getArCard() {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT  ");
		sqlStr.append("ACTID,  ");
		sqlStr.append("ARCCODE,  ");
		sqlStr.append("ACTCODE,  ");
		sqlStr.append("'\\\\160.100.1.10\\CardPhoto\\'||ACTCODE||'.bmp',");
		sqlStr.append("'\\\\160.100.1.10\\CardPhoto\\'||ACTCODE||'.jpg' ");
		sqlStr.append("FROM ARCARDTYPE@iweb ");
		sqlStr.append("ORDER BY ARCCODE, ACTID ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}	

	public static ArrayList getTrackItemStatus(String reqNo, String reqSeq) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DECODE( ");
		sqlStr.append("(CASE ");
		sqlStr.append("WHEN SIGN(ERD.APPROVE_FLAG) = -1 AND ERL.RECORD_STATUS IN ('F') THEN 'R' ");
		sqlStr.append("WHEN SIGN(ERD.APPROVE_FLAG) = -1 AND ERL.RECORD_STATUS IN ('A') THEN 'R' ");
		sqlStr.append("WHEN SIGN(ERD.APPROVE_FLAG) = -1 AND ERL.RECORD_STATUS IN ('P') THEN 'R' ");
		sqlStr.append("WHEN SIGN(ERD.APPROVE_FLAG) = -1 AND ERL.RECORD_STATUS IN ('Z') THEN 'R' ");
		sqlStr.append("WHEN SIGN(ERD.APPROVE_FLAG) = -1 AND ERL.RECORD_STATUS IN ('D') THEN 'R' ");
		sqlStr.append("WHEN SIGN(ERD.APPROVE_FLAG) = -1 AND ERL.RECORD_STATUS IN ('O') THEN 'R' ");
		sqlStr.append("ELSE ERL.RECORD_STATUS ");
		sqlStr.append("END),'A','Approved','C','Cancelled','F','Further approve','D','Pending','Z','PO Processing','P','Partial order','R','Rejected','S','Waiting for department head','O','Ordered','H','Waiting approve'), ");
		sqlStr.append("NVL((SELECT DISTINCT CS.CO_STAFFNAME FROM CO_STAFFS CS WHERE ERL.INSERT_BY = CS.CO_STAFF_ID), ERL.INSERT_BY), ");
		sqlStr.append("TO_CHAR(ERL.INSERT_DATE,'DD/MM/YYYY HH24:MI') ");
		sqlStr.append("FROM EPO_REQUEST_LOG ERL, EPO_REQUEST_D ERD ");
		sqlStr.append("WHERE ERL.EPO_NO = ERD.REQ_NO(+) ");
		sqlStr.append("AND ERL.EPO_NO = '");
		sqlStr.append(reqNo);
		sqlStr.append("' ");
		sqlStr.append("AND ERD.REQ_SEQ = '");
		sqlStr.append(reqSeq);
		sqlStr.append("' AND TRUNC(ERL.INSERT_DATE,'MI')<=TRUNC(ERD.MOD_DATE,'MI') ");
		sqlStr.append("AND (CASE ");
		sqlStr.append("WHEN SIGN(ERD.APPROVE_FLAG) = -1 AND ERL.RECORD_STATUS IN ('P')  THEN 'X' ");
		sqlStr.append("WHEN SIGN(ERD.APPROVE_FLAG) = -1 AND ERL.RECORD_STATUS IN ('Z')  THEN 'X' ");
		sqlStr.append("WHEN SIGN(ERD.APPROVE_FLAG) = -1 AND ERL.RECORD_STATUS IN ('D')  THEN 'X' ");
		sqlStr.append("WHEN SIGN(ERD.APPROVE_FLAG) = -1 AND ERL.RECORD_STATUS IN ('O')  THEN 'X' ");
		sqlStr.append("ELSE ERL.RECORD_STATUS ");
		sqlStr.append("END) <> 'X' ");
		sqlStr.append("ORDER BY ERL.INSERT_DATE ASC, ERL.RECORD_STATUS DESC ");
		System.err.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getTrackItemLog(String reqNo, String reqSeq) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("DISTINCT ");
		sqlStr.append("ERD.ITEM_DESC,");
		sqlStr.append("ERDL.REQ_QTY,");
		sqlStr.append("ERDL.ITEM_PRICE,");
		sqlStr.append("ERDL.REQ_AMOUNT,");
		sqlStr.append("(SELECT DISTINCT CS.CO_STAFFNAME FROM CO_STAFFS CS WHERE ERDL.MOD_BY = CS.CO_STAFF_ID) AS MOD_BY, ");
		sqlStr.append("TO_CHAR(ERDL.MOD_DATE,'YYYY/MM/DD HH24:MI:SS') AS MOD_DATE ");
		sqlStr.append(" FROM EPO_REQUEST_D_LOG ERDL, EPO_REQUEST_D ERD ");
		sqlStr.append(" WHERE ERD.REQ_NO = ERDL.REQ_NO ");
		sqlStr.append(" AND ERD.ITEM_DESC = ERDL.ITEM_DESC ");
		sqlStr.append(" AND ERD.REQ_NO = '");
		sqlStr.append(reqNo);
		sqlStr.append("' AND ERD.REQ_SEQ = '");
		sqlStr.append(reqSeq);
		sqlStr.append("' ORDER BY MOD_DATE");
		System.err.println(sqlStr.toString());		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getAmountList(String amountID, String appGrp) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT AMOUNT_ID, AMOUNT_DESC ");
		sqlStr.append("FROM  EPO_AMOUNT ");
		sqlStr.append("WHERE APPROVAL_GROUP ='");
		sqlStr.append(appGrp);
		sqlStr.append("' ORDER BY AMOUNT_SEQ ASC");
		System.err.println(sqlStr.toString());		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static String checkValidAmtID(String amountID, String amount) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 FROM EPO_AMOUNT ");
		sqlStr.append("WHERE AMOUNT_ID = TO_NUMBER('");
		sqlStr.append(amountID);
		sqlStr.append("') AND MIN<TO_NUMBER('");
		sqlStr.append(amount);
		sqlStr.append("') AND MAX>=TO_NUMBER('");
		sqlStr.append(amount);
		sqlStr.append("')");
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			return row.getFields0();
		} else {
			return null;
		}
	}

	public static String checkItemRejected(String reqNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("COUNT(REQ_NO) ");
		sqlStr.append("FROM ");
		sqlStr.append("EPO_REQUEST_D ");
		sqlStr.append("WHERE APPROVE_FLAG = -1 ");
		sqlStr.append("AND REQ_NO = '");
		sqlStr.append(reqNo);
		sqlStr.append("' ");
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			return row.getFields0();
		} else {
			return null;
		}
	}

	public static String checkValidAmt(String amountID, String amount) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM EPO_AMOUNT ");
		sqlStr.append("WHERE AMOUNT_ID = TO_NUMBER('");
		sqlStr.append(amountID);
		sqlStr.append("') AND MAX>=TO_NUMBER('");
		sqlStr.append(amount);
		sqlStr.append("') AND AMOUNT_ID< > 0 ");
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			return row.getFields0();
		} else {
			return null;
		}
	}

	public static String checkAmtId(String amount,String appGrp) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT AMOUNT_ID ");
		sqlStr.append("FROM EPO_AMOUNT A ");
		sqlStr.append("WHERE APPROVAL_GROUP ='");
		sqlStr.append(appGrp);
		sqlStr.append("' AND A.MIN<TO_NUMBER('");
		sqlStr.append(amount);
		sqlStr.append("') AND A.MAX>=TO_NUMBER('");
		sqlStr.append(amount);
		sqlStr.append("') ");
		sqlStr.append("AND A.AMOUNT_ID<> 0 ");
		sqlStr.append("AND A.MAX = ( ");
		sqlStr.append("SELECT MIN(MAX) ");
		sqlStr.append("FROM EPO_AMOUNT ");
		sqlStr.append("WHERE MIN<TO_NUMBER('");
		sqlStr.append(amount);
		sqlStr.append("') AND MAX>=TO_NUMBER('");
		sqlStr.append(amount);
		sqlStr.append("') AND AMOUNT_ID<> 0 AND APPROVAL_GROUP ='");
		sqlStr.append(appGrp);				
		sqlStr.append("') ");
			
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			return row.getFields0();
		} else {
			return null;
		}
	}

	public static String getDeptHead(String dept_code) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_DEPARTMENT_HEAD ");
		sqlStr.append(" FROM CO_DEPARTMENTS");
		sqlStr.append(" WHERE CO_DEPARTMENT_CODE = '");
		sqlStr.append(dept_code);
		sqlStr.append("'");
		System.err.println(sqlStr.toString());		
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			return row.getFields0();
		} else {
			return null;
		}
	}
	
	public static String getSupervisor(String dept_code) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_DEPARTMENT_SUPERVISOR ");
		sqlStr.append(" FROM CO_DEPARTMENTS");
		sqlStr.append(" WHERE CO_DEPARTMENT_CODE = '");
		sqlStr.append(dept_code);
		sqlStr.append("'");
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			return row.getFields0();
		} else {
			return null;
		}
	}	

	public static ArrayList getDeptHeadList(String dept_code) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CD.CO_DEPARTMENT_HEAD, (SELECT CS.CO_STAFFNAME FROM CO_STAFFS CS WHERE CS.CO_STAFF_ID=CD.CO_DEPARTMENT_HEAD), '' ");
		sqlStr.append(" FROM CO_DEPARTMENTS CD");
		sqlStr.append(" WHERE CD.CO_DEPARTMENT_CODE = '");
		sqlStr.append(dept_code);
		sqlStr.append("'");
		System.err.println(sqlStr.toString());		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
		
	public static ArrayList getEpoDeptHeadList(String dept_code) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CD.CO_DEPARTMENT_HEAD, (SELECT CS.CO_STAFFNAME FROM CO_STAFFS CS WHERE CS.CO_STAFF_ID=CD.CO_DEPARTMENT_HEAD), '' ");
		sqlStr.append(" from ");
		sqlStr.append(" ((SELECT CO_DEPARTMENT_HEAD,CO_DEPARTMENT_SUBHEAD FROM CO_DEPARTMENTS WHERE CO_DEPARTMENT_CODE= '");
		sqlStr.append(dept_code);
		sqlStr.append("') unpivot ");
		sqlStr.append("(CO_DEPARTMENT_HEAD ");
		sqlStr.append(" for value_type in ");
		sqlStr.append(" (CO_DEPARTMENT_HEAD,CO_DEPARTMENT_SUBHEAD))) CD");
		System.err.println(sqlStr.toString());		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}	

	public static String checkFirstApprover(String reqNo, String staffId) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 ");
		sqlStr.append(" FROM epo_request_log ");
		sqlStr.append(" WHERE epo_no = '");
		sqlStr.append(reqNo);
		sqlStr.append("' AND insert_by = '");
		sqlStr.append(staffId);
		sqlStr.append("' AND record_status = 'F'");
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			return row.getFields0();
		} else {
			return null;
		}
	}
	
	public static String isExistApprovlGroup(String amount, String staffId, String appGrp) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM EPO_AMOUNT EA, EPO_APPROVE_LIST EAL, EPO_APPROVE_LEVEL EALVL "); 
		sqlStr.append("WHERE EA.AMOUNT_ID = EALVL.AMOUNT_ID ");
		sqlStr.append("AND EAL.APPROVAL_CREDIT = EALVL.USE_CREDIT ");
		sqlStr.append("AND EA.APPROVAL_GROUP = EAL.APPROVAL_GROUP ");
		sqlStr.append("AND EAL.FLOW_ID=1 ");
		sqlStr.append("AND EAL.STAFF_ID = '");
		sqlStr.append(staffId);		
		sqlStr.append("' ");
		if(!"0".equals(amount)){
			sqlStr.append("AND EA.AMOUNT_ID ='");
			sqlStr.append(amount);
			sqlStr.append("'");			
		}
		sqlStr.append(" AND EAL.APPROVAL_GROUP='");
		sqlStr.append(appGrp);
		sqlStr.append("'");
		System.err.println(sqlStr.toString());		
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			return row.getFields0();
		} else {
			return "0";
		}
	}	

	public static String isExistApprovlGroupByReqNO(String reqNo, String staffId, String appGrp) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM EPO_AMOUNT EA, EPO_APPROVE_LIST EAL, EPO_APPROVE_LEVEL EALVL, EPO_REQUEST_M ERM "); 
		sqlStr.append("WHERE EA.AMOUNT_ID = EALVL.AMOUNT_ID ");
		sqlStr.append("AND EAL.APPROVAL_CREDIT = EALVL.USE_CREDIT ");
		sqlStr.append("AND EA.APPROVAL_GROUP = EAL.APPROVAL_GROUP ");
		sqlStr.append("AND EAL.FLOW_ID=1 ");
		sqlStr.append("AND EAL.STAFF_ID = '");
		sqlStr.append(staffId);		
		sqlStr.append("' AND EA.AMOUNT_ID = (SELECT AMT_RANGE FROM EPO_REQUEST_M WHERE REQ_NO = '");
	    sqlStr.append(reqNo);
		sqlStr.append("') AND EAL.APPROVAL_GROUP='");
		sqlStr.append(appGrp);
		sqlStr.append("'");
		System.err.println(sqlStr.toString());		
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			return row.getFields0();
		} else {
			return "0";
		}
	}
	
	public static String getDeptSRNList(String deptCode) {
		
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DISTINCT cd.CO_DEPARTMENT_SUBHEAD, (");
		sqlStr.append("SELECT DISTINCT cs.co_staffname ");
		sqlStr.append(" FROM co_staffs cs ");
		sqlStr.append(" WHERE cs.co_staff_id=cd.CO_DEPARTMENT_SUBHEAD), ''");
		sqlStr.append(" FROM co_departments cd WHERE cd.CO_DEPARTMENT_CODE = '");
		sqlStr.append(deptCode);
		sqlStr.append("'");
		System.err.println(sqlStr.toString());
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			return row.getFields0();
		} else {
			return null;
		}
	}	
	
	public static String getDeptByDeptHead(String staffId) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT co_department_code ");
		sqlStr.append(" FROM CO_DEPARTMENTS ");
		sqlStr.append(" WHERE co_department_head = '");
		sqlStr.append(staffId);
		sqlStr.append("'");
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			return row.getFields0();
		} else {
			return null;
		}
	}
	
	public static ArrayList<ReportableListObject> getBudgetList(String deptCode, String budgetCode, String budgetDesc, String budgetAmt, String budgetEnabled) {
		// fetch user
		
		System.err.println("[budgetEnabled]:"+budgetEnabled);
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT eb.dept_code, cd.co_department_desc, eb.code, eb.description, eb.amount , TO_CHAR(eb.effective_date,'DD/MM/YYYY'), TO_CHAR(eb.expired_date,'DD/MM/YYYY'), eb.remarks, eb.enabled, DECODE(eb.enabled,1,'Enabled',0,'Disabled') ");
		sqlStr.append("FROM epo_budget eb, co_departments cd ");
		sqlStr.append("WHERE eb.dept_code = cd.co_department_code(+) ");
		sqlStr.append("AND eb.type = 'BC' ");
		if (deptCode != null && deptCode.length() > 0) {			
			sqlStr.append("AND eb.dept_code = '");
			sqlStr.append(deptCode);
			sqlStr.append("' ");
		}		
		if (budgetCode != null && budgetCode.length() > 0) {		
			sqlStr.append("AND eb.code = '");
			sqlStr.append(budgetCode);
			sqlStr.append("' ");
		}
		if (budgetDesc != null && budgetDesc.length() > 0) {		
			sqlStr.append("AND UPPER(eb.description) = UPPER('");
			sqlStr.append(budgetDesc);
			sqlStr.append("') ");
		}
		if (budgetAmt != null && budgetAmt.length() > 0) {		
			sqlStr.append("AND eb.amount = TO_NUMBER('");
			sqlStr.append(budgetAmt);
			sqlStr.append("') ");
		}
		sqlStr.append("AND eb.enabled = TO_NUMBER('");
		sqlStr.append(budgetEnabled);
		sqlStr.append("') ");		
		sqlStr.append("ORDER BY eb.dept_code, eb.effective_date, eb.code ");
		System.err.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getBudgetRemain(String type, String code, String reqNo, String deptCode, String reqDate) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT EB.CODE, EB.AMOUNT, NVL(EPO.TOTAL_AMOUNT,0) AS USED_AMOUNT,EB.AMOUNT-NVL(EPO.TOTAL_AMOUNT,0) AS DIFF ");
		sqlStr.append("FROM ");
		sqlStr.append("(SELECT CODE, AMOUNT "); 
		sqlStr.append("FROM EPO_BUDGET "); 
		sqlStr.append("WHERE TYPE = '");
		sqlStr.append(type);
		sqlStr.append("' AND CODE = '");
		sqlStr.append(code);
		sqlStr.append("' AND DEPT_CODE = '");
		sqlStr.append(deptCode);
		sqlStr.append("' AND (  "); 
		sqlStr.append(" (SYSDATE >= EFFECTIVE_DATE AND TRUNC(SYSDATE) <= EXPIRED_DATE) ");
		sqlStr.append(" OR (TO_DATE('" + reqDate + "', 'DD/MM/YYYY') >= EFFECTIVE_DATE AND TRUNC(TO_DATE('" + reqDate + "', 'DD/MM/YYYY')) <= EXPIRED_DATE) "); 
		sqlStr.append("	 ) ");
		sqlStr.append("AND ENABLED =1) EB,");
		sqlStr.append("(SELECT M.BUDGET_CODE, SUM(D.REQ_AMOUNT) AS TOTAL_AMOUNT ");
		sqlStr.append("FROM EPO_REQUEST_M M, EPO_REQUEST_D D ");
		sqlStr.append("WHERE M.REQ_NO = D.REQ_NO ");
		sqlStr.append("AND M.REQ_STATUS <> 'C' ");
		sqlStr.append("AND M.APPROVE_FLAG = '1' ");		
		sqlStr.append("AND M.BUDGET_CODE = '");
		sqlStr.append(code);
		if (reqNo != null && reqNo.length() > 0) {
			sqlStr.append("' AND M.REQ_NO != '");
			sqlStr.append(reqNo);
			sqlStr.append("' ");
		}else{
			sqlStr.append("' ");			
		}
		sqlStr.append("GROUP BY M.BUDGET_CODE) EPO ");
		sqlStr.append("WHERE EB.CODE = EPO.BUDGET_CODE(+) ");

		System.err.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getBudgetDesc(String type, String code, String deptCode, String reqDate) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("DESCRIPTION ");
		sqlStr.append("FROM EPO_BUDGET ");
		sqlStr.append("WHERE TYPE = '");
		sqlStr.append(type);
		sqlStr.append("' AND CODE = '");
		sqlStr.append(code); 
		sqlStr.append("' AND DEPT_CODE = '");
		sqlStr.append(deptCode); 		
		sqlStr.append("' AND (  "); 
		sqlStr.append(" (SYSDATE >= EFFECTIVE_DATE AND TRUNC(SYSDATE) <= EXPIRED_DATE) ");
		sqlStr.append(" OR (TO_DATE('" + reqDate + "', 'DD/MM/YYYY') >= EFFECTIVE_DATE AND TRUNC(TO_DATE('" + reqDate + "', 'DD/MM/YYYY')) <= EXPIRED_DATE) "); 
		sqlStr.append("	 ) "); 
		sqlStr.append("AND ENABLED =1");

		System.err.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static boolean addBudgetCode(UserBean userBean, String type, String budgetCode, String effStartDate, String effEndDate, String deptCode, String budgetDesc, String budgetAmt, String remarks, String enabled) {
		StringBuffer sqlStr = new StringBuffer();
		Vector<String> sqlValue = new Vector<String>();
		sqlStr.append("INSERT INTO EPO_BUDGET ( ");
		sqlStr.append("TYPE, ");
		sqlStr.append("CODE, ");
		sqlStr.append("EFFECTIVE_DATE, ");
		sqlStr.append("EXPIRED_DATE, ");      
		sqlStr.append("DEPT_CODE, ");
		sqlStr.append("DESCRIPTION, ");
		sqlStr.append("AMOUNT, ");
		sqlStr.append("REMARKS, ");
		sqlStr.append("CREATED_BY, ");  
		sqlStr.append("CREATED_DATE, ");          
		sqlStr.append("MODIFIED_BY, "); 
		sqlStr.append("MODIFIED_DATE, ");           
		sqlStr.append("ENABLED) VALUES (?,?,TO_DATE(?,'DD/MM/YYYY'),TO_DATE(?,'DD/MM/YYYY'),?,?,TO_NUMBER(?),?,?,SYSDATE,?,SYSDATE,?)");
		System.err.println(sqlStr);
		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {type, budgetCode, effStartDate, effEndDate, deptCode, budgetDesc, budgetAmt, remarks, userBean.getStaffID(), userBean.getStaffID(), enabled})) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean updateBudgetDetail(UserBean userBean, String type, String budgetCode, String amt, String budgetDesc, String effStartDate, String effEndDate, String remarks, String enabled) {
		System.err.println("[budgetCode]:"+budgetCode);		
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE epo_budget ");
		sqlStr.append("SET DESCRIPTION = ?,");
		sqlStr.append("AMOUNT = TO_NUMBER(?),");
		sqlStr.append("EFFECTIVE_DATE = TO_DATE(?,'DD/MM/YYYY'),");
		sqlStr.append("EXPIRED_DATE = TO_DATE(?,'DD/MM/YYYY'),");
		sqlStr.append("REMARKS = ?,");		
		sqlStr.append("ENABLED = TO_NUMBER(?),");
		sqlStr.append("MODIFIED_BY = ?,");			
		sqlStr.append("MODIFIED_DATE = SYSDATE ");
		sqlStr.append("WHERE TYPE = ?");			
		sqlStr.append(" AND CODE = ?");
		System.err.println(sqlStr.toString());
		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {budgetDesc, amt, effStartDate, effEndDate, remarks, enabled, userBean.getStaffID(), type, budgetCode })) {
			return true;
		} else {
			return false;
		}
	}	
		
	public static void execProcUptComp(String txCode) {
		UtilDBWeb.executeFunction(txCode);
	}

	public static boolean sendEmail(String reqNo, String reqBy, String loginID, String approvalStaff, String reqDesc, String reqStatus, String folderID, String flowID, String flowSeq) {
		String emailFrom = null;
		Vector emailTo = new Vector();
		String emailToID = null;
		String staffId = null;
		String topic = null;
		String deptHead = null;
		String reqDept = null;
		String reqDeptDesc = null;
		String deptHeadName = null;
		String emailTo1 = null;
		StringBuffer commentStr = null;
		int noOfRow = 0;
		
		ArrayList record = EPORequestDB.getRequestHdr(reqNo);
		noOfRow = record.size();

		if (noOfRow > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			reqDept = row.getValue(4);
			reqDeptDesc = DepartmentDB.getDeptDesc(reqDept);
			deptHead = EPORequestDB.getDeptHead(reqDept);
//			emailTo.add(UserDB.getUserEmail(null, deptHead));
		}		

		// append url
		commentStr = new StringBuffer();
		if ("S".equals(reqStatus)) {
			topic = "Request NO.: "+reqNo+"; Purchase Requisition from :"+reqDeptDesc+" order for - "+reqDesc;

			if (reqDept!=null && reqDept.length()>0) {
				emailTo.add(UserDB.getUserEmail(null, deptHead));
			}			

// flowID in "E" indicate for email resend
			if ("E".equals(flowID) ) {
				topic = "This email is a gentle reminder for Request NO.: "+reqNo+"; Purchase Requisition from :"+reqDeptDesc+" order for - "+reqDesc;

				commentStr.append("<br>This email is a gentle reminder that this purchase requisition is waiting for your approval.");
				if ("hkah".equals(serverSiteCode)) {
					commentStr.append("<br>Please click  <a href=\'http://www-server/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Intranet</a> or <a href=\'https://mail.hkah.org.hk/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Offsite</a> to view the detail.");
				} else if ("twah".equals(serverSiteCode)) {
					commentStr.append("<br>Please click  <a href=\'http://192.168.0.20/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Intranet</a> or <a href=\'https://mail.twah.org.hk/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Offsite</a> to view the detail.");
				}
			} else {
				commentStr.append("<br>This purchase requisition, waiting for your approval.");
				if ("hkah".equals(serverSiteCode)) {
					commentStr.append("<br>Please click  <a href=\'http://www-server/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Intranet</a> or <a href=\'https://mail.hkah.org.hk/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Offsite</a> to view the detail.");
				} else if ("twah".equals(serverSiteCode)) {
					commentStr.append("<br>Please click  <a href=\'http://192.168.0.20/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Intranet</a> or <a href=\'https://mail.twah.org.hk/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Offsite</a> to view the detail.");
				}
			}
		} else if ("H".equals(reqStatus)) {
			topic = "Request NO.: "+reqNo+"; Purchase Requisition from :"+reqDeptDesc+" order for - "+reqDesc;

			if (approvalStaff != null && approvalStaff.length() > 0) {
				emailToID = approvalStaff;

				if (UserDB.getUserEmailByUserName(null, emailToID) != null &&
						UserDB.getUserEmailByUserName(null, emailToID).length() > 0) {
					emailTo.add(UserDB.getUserEmailByUserName(null, emailToID));
				} else {
					emailTo.add(ConstantsServerSide.MAIL_ALERT);
				}
			} else {
				emailToID = reqBy;
				if (UserDB.getUserEmailByUserName(null, emailToID) != null &&
						UserDB.getUserEmailByUserName(null, emailToID).length() > 0) {
					emailTo.add(UserDB.getUserEmailByUserName(null, emailToID));
				} else {
					emailTo.add(ConstantsServerSide.MAIL_ALERT);
				}
			}

// flowID in "E" indicate for email resend
			if ("E".equals(flowID)) {
				topic = "This email is a gentle reminder for Request NO.: "+reqNo+"; Purchase Requisition from :"+reqDeptDesc+" order for - "+reqDesc;

				commentStr.append("<br>This email is a gentle reminder that this purchase requisition is waiting for your approval.");
				if ("hkah".equals(serverSiteCode)) {
					commentStr.append("<br>Please click  <a href=\'http://www-server/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Intranet</a> or <a href=\'https://mail.hkah.org.hk/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Offsite</a> to view the detail.");
				} else if ("twah".equals(serverSiteCode)) {
					commentStr.append("<br>Please click  <a href=\'http://192.168.0.20/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Intranet</a> or <a href=\'https://mail.twah.org.hk/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Offsite</a> to view the detail.");
				}
			} else {
				commentStr.append("<br>This purchase requisition, waiting for your approval.");
				if ("hkah".equals(serverSiteCode)) {
					commentStr.append("<br>Please click  <a href=\'http://www-server/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Intranet</a> or <a href=\'https://mail.hkah.org.hk/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Offsite</a> to view the detail.");
				} else if ("twah".equals(serverSiteCode)) {
					commentStr.append("<br>Please click  <a href=\'http://192.168.0.20/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Intranet</a> or <a href=\'https://mail.twah.org.hk/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Offsite</a> to view the detail.");
				}
			}
		} else if ("F".equals(reqStatus)) {
			topic = "Request NO.: "+reqNo+"; Purchase Requisition from :"+reqDeptDesc+" order for - "+reqDesc;
			if (reqBy != null && reqBy.length() > 0) {
				emailToID = reqBy;
				if (UserDB.getUserEmailByUserName(null, emailToID) != null &&
						UserDB.getUserEmailByUserName(null, emailToID).length() > 0) {
					emailTo.add(UserDB.getUserEmailByUserName(null, emailToID));
				} else {
					emailTo.add(ConstantsServerSide.MAIL_ALERT);
				}

				commentStr.append("<br>Your purchase requisition is require further approval by "+approvalStaff+".");
				commentStr.append("Please wait for his/her approval.");
				if ("hkah".equals(serverSiteCode)) {
					commentStr.append("<br>Please click  <a href=\'http://www-server/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Intranet</a> or <a href=\'https://mail.hkah.org.hk/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Offsite</a> to view the detail.");
				} else if ("twah".equals(serverSiteCode)) {
					commentStr.append("<br>Please click  <a href=\'http://192.168.0.20/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Intranet</a> or <a href=\'https://mail.twah.org.hk/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Offsite</a> to view the detail.");
				}
			} else {
				emailToID = approvalStaff;
				if (UserDB.getUserEmailByUserName(null, emailToID) != null &&
						UserDB.getUserEmailByUserName(null, emailToID).length() > 0) {
					emailTo.add(UserDB.getUserEmailByUserName(null, emailToID));
				} else {
					emailTo.add(ConstantsServerSide.MAIL_ALERT);
				}

// flowID in "E" indicate for email resend
				if ("E".equals(flowID)) {
					topic = "This email is a gentle reminder for Request NO.: "+reqNo+"; Purchase Requisition from :"+reqDeptDesc+" order for - "+reqDesc;

					commentStr.append("<br>This email is a gentle reminder that this purchase requisition is waiting for your approval.");
					if ("hkah".equals(serverSiteCode)) {
						commentStr.append("<br>Please click  <a href=\'http://www-server/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
						commentStr.append("\'>Intranet</a> or <a href=\'https://mail.hkah.org.hk/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
						commentStr.append("\'>Offsite</a> to view the detail.");
					} else if ("twah".equals(serverSiteCode)) {
						commentStr.append("<br>Please click  <a href=\'http://192.168.0.20/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
						commentStr.append("\'>Intranet</a> or <a href=\'https://mail.twah.org.hk/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
						commentStr.append("\'>Offsite</a> to view the detail.");
					}
				} else {
					commentStr.append("<br>This purchase requisition, waiting for your approval.");
					if ("hkah".equals(serverSiteCode)) {
						commentStr.append("<br>Please click  <a href=\'http://www-server/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
						commentStr.append("\'>Intranet</a> or <a href=\'https://mail.hkah.org.hk/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
						commentStr.append("\'>Offsite</a> to view the detail.");
					} else if ("twah".equals(serverSiteCode)) {
						commentStr.append("<br>Please click  <a href=\'http://192.168.0.20/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
						commentStr.append("\'>Intranet</a> or <a href=\'https://mail.twah.org.hk/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
						commentStr.append("\'>Offsite</a> to view the detail.");
					}
				}
			}
		} else if ("A".equals(reqStatus)) {
			int noOfRejected = Integer.parseInt(checkItemRejected(reqNo));

			if (noOfRejected > 0) {
				topic = "Request NO.: "+reqNo+"; Purchase Requisition from :"+reqDeptDesc+" order for - "+reqDesc + " is partially approved";
			} else {
				topic = "Request NO.: "+reqNo+"; Purchase Requisition from :"+reqDeptDesc+" order for - "+reqDesc + " is approved";
			}
			System.err.println("[reqBy]:"+emailToID+";[flowSeq]:"+flowSeq);
			if ("1".equals(flowSeq)) {
				emailToID = reqBy;
				if (UserDB.getUserEmailByUserName(null, emailToID) != null &&
						UserDB.getUserEmailByUserName(null, emailToID).length() > 0) {
					emailTo.add(UserDB.getUserEmailByUserName(null, emailToID));
				} else {
					emailTo.add(ConstantsServerSide.MAIL_ALERT);
				}

				if (noOfRejected > 0) {
					commentStr.append("<br>Your purchase requisition is partially approved (items QTY may be changed). ");
				} else {
					commentStr.append("<br>Your purchase requisition is approved (items QTY may be changed). ");
				}
				commentStr.append("Purchasing department will process your order soon.");
				if ("hkah".equals(serverSiteCode)) {
					commentStr.append("<br>Please click  <a href=\'http://www-server/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Intranet</a> or <a href=\'https://mail.hkah.org.hk/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Offsite</a> to view the detail.");
				} else if ("twah".equals(serverSiteCode)) {
					commentStr.append("<br>Please click  <a href=\'http://192.168.0.20/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Intranet</a> or <a href=\'https://mail.twah.org.hk/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Offsite</a> to view the detail.");
				}
			} else if ("2".equals(flowSeq)) {
				ArrayList result = getRelatedList("1","2","HKAH"); // default approval group HKAH

				for(int i=0;i<result.size();i++) {
					ReportableListObject row = (ReportableListObject) result.get(i);

					if (UserDB.getUserEmailByUserName(null, row.getFields0()) != null &&
							UserDB.getUserEmailByUserName(null, row.getFields0()).length() > 0) {
						emailTo.add(UserDB.getUserEmailByUserName(null, row.getFields0()));
					} else {
						emailTo.add(ConstantsServerSide.MAIL_ALERT);
					}
				}

				commentStr.append("<br>This purchase requisition is approved. ");
				if ("hkah".equals(serverSiteCode)) {
					commentStr.append("<br>Please click  <a href=\'http://www-server/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Intranet</a> or <a href=\'https://mail.hkah.org.hk/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Offsite</a> to view the detail.");
				} else if ("twah".equals(serverSiteCode)) {
					commentStr.append("<br>Please click  <a href=\'http://192.168.0.20/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Intranet</a> or <a href=\'https://mail.twah.org.hk/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Offsite</a> to view the detail.");
				}
			} else if ("3".equals(flowSeq)) {
				ArrayList result = getRelatedList("1","3","HKAH"); //default approval group HKAH

				for(int i=0;i<result.size();i++) {
					ReportableListObject row = (ReportableListObject) result.get(i);

					if (UserDB.getUserEmailByUserName(null, row.getFields0()) != null &&
							UserDB.getUserEmailByUserName(null, row.getFields0()).length() > 0) {
						emailTo.add(UserDB.getUserEmailByUserName(null, row.getFields0()));
					} else {
						emailTo.add(ConstantsServerSide.MAIL_ALERT);
					}
				}

				commentStr.append("<br>This purchase requisition is approved. ");
				if ("hkah".equals(serverSiteCode)) {
					commentStr.append("<br>Please click  <a href=\'http://www-server/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Intranet</a> or <a href=\'https://mail.hkah.org.hk/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Offsite</a> to view the detail.");
				} else if ("twah".equals(serverSiteCode)) {
					commentStr.append("<br>Please click  <a href=\'http://192.168.0.20/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Intranet</a> or <a href=\'https://mail.twah.org.hk/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Offsite</a> to view the detail.");
				}
			}
		} else if ("C".equals(reqStatus)) {
			topic = "Request NO.: "+reqNo+"; Purchase Requisition from :"+reqDeptDesc+" order for - "+reqDesc+", was cancelled";

			emailToID = approvalStaff;
			if (UserDB.getUserEmailByUserName(null, emailToID) != null &&
					UserDB.getUserEmailByUserName(null, emailToID).length() > 0) {
				emailTo.add(UserDB.getUserEmailByUserName(null, emailToID));
			} else {
				emailTo.add(ConstantsServerSide.MAIL_ALERT);
			}

			commentStr.append("<br>Requisition is cancelled by user. ");

		} else if ("R".equals(reqStatus)) {
			topic = "Request NO.: "+reqNo+"; Purchase Requisition from :"+reqDeptDesc+" order for - "+reqDesc+", was rejected";

			emailToID = reqBy;
			if (UserDB.getUserEmailByUserName(null, emailToID) != null &&
					UserDB.getUserEmailByUserName(null, emailToID).length() > 0) {
				emailTo.add(UserDB.getUserEmailByUserName(null, emailToID));
			} else {
				emailTo.add(ConstantsServerSide.MAIL_ALERT);
			}

			commentStr.append("<br>Your purchase requisition is rejected. ");
			if ("hkah".equals(serverSiteCode)) {
				commentStr.append("<br>Please click  <a href=\'http://www-server/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
				commentStr.append("\'>Intranet</a> or <a href=\'https://mail.hkah.org.hk/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
				commentStr.append("\'>Offsite</a> to view the detail.");
			} else if ("twah".equals(serverSiteCode)) {
				commentStr.append("<br>Please click  <a href=\'http://192.168.0.20/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
				commentStr.append("\'>Intranet</a> or <a href=\'https://mail.twah.org.hk/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
				commentStr.append("\'>Offsite</a> to view the detail.");
			}
		} else if ("D".equals(reqStatus)) {
			topic = "Request NO.: "+reqNo+"; Purchase Requisition from :"+reqDeptDesc+" order for - "+reqDesc+", was pending";

			emailToID = reqBy;
			if (UserDB.getUserEmailByUserName(null, emailToID) != null &&
					UserDB.getUserEmailByUserName(null, emailToID).length() > 0) {
				emailTo.add(UserDB.getUserEmailByUserName(null, emailToID));
			} else {
				emailTo.add(ConstantsServerSide.MAIL_ALERT);
			}

			commentStr.append("<br>This purchase requisition was pending by "+approvalStaff+". ");
			commentStr.append("Please wait from further action.");
		} else if ("O".equals(reqStatus)) {
			topic = "Request NO.: "+reqNo+"; Purchase Requisition from :"+reqDeptDesc+" order for - "+reqDesc+", was ordered";

			emailToID = reqBy;
			if (UserDB.getUserEmailByUserName(null, emailToID) != null &&
					UserDB.getUserEmailByUserName(null, emailToID).length() > 0) {
				emailTo.add(UserDB.getUserEmailByUserName(null, emailToID));
			} else {
				emailTo.add(ConstantsServerSide.MAIL_ALERT);
			}

			commentStr.append("<br>This purchase requisition was ordered. ");
			commentStr.append("Please click the following URL to view PO details.");
			if ("hkah".equals(serverSiteCode)) {
				commentStr.append("<br>Please click  <a href=\'http://www-server/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
				commentStr.append("\'>Intranet</a> or <a href=\'https://mail.hkah.org.hk/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
				commentStr.append("\'>Offsite</a> to view the detail.");
			} else if ("twah".equals(serverSiteCode)) {
				commentStr.append("<br>Please click  <a href=\'http://192.168.0.20/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
				commentStr.append("\'>Intranet</a> or <a href=\'https://mail.twah.org.hk/intranet/epo/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
				commentStr.append("\'>Offsite</a> to view the detail.");
			}
		} else {
			if (UserDB.getUserEmailByUserName(null, emailToID) != null &&
					UserDB.getUserEmailByUserName(null, emailToID).length() > 0) {
				emailTo.add(UserDB.getUserEmailByUserName(null, emailToID));
			} else {
				emailTo.add(ConstantsServerSide.MAIL_ALERT);
			}
		}

		// get request user email
		emailFrom = UserDB.getUserEmail(null, loginID);

		if (emailFrom == null||emailFrom.length()==0) {
			emailFrom = ConstantsServerSide.MAIL_ALERT;
		}

		if (emailTo.size() > 0) {
			// alert admin if email address is invalid
			List<String> invalidEmails = new ArrayList<String>();
			Iterator<String> itr = emailTo.iterator();
			while (itr.hasNext()) {
				String email = (String) itr.next();
				if (!UtilMail.isValidEmailAddress(email)) {
					invalidEmails.add(email);
				}
			}
			if (!invalidEmails.isEmpty()) {
				String topicInvalid = "User email address invalid (From Intranet Portal - EPO)";
				String commentInvalid = "Request NO.: "+reqNo+"; reqBy="+reqBy+"; loginID="+loginID+"; approvalStaff="+approvalStaff+"; reqStatus="+reqStatus + "<br />" +
					"Invalid email address: " + StringUtils.join(invalidEmails, ", ");
				EmailAlertDB.sendEmail("portal.admin", topicInvalid, commentInvalid);
			}
			
			// send email
			System.err.println("[commentStr.toString()]:"+commentStr.toString());
			if (UtilMail.sendMail(
					emailFrom,
					(String[]) emailTo.toArray(new String[emailTo.size()]),
					topic + " (From Intranet Portal - EPO)",
					commentStr.toString())) {
				return true;
			} else {
				return false;
			}
		} else {
			return true;
		}
	}

	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO EPO_REQUEST_LOG (");
		sqlStr.append("	EPO_NO, RECORD_STATUS, INSERT_BY, INSERT_DATE) ");
		sqlStr.append("VALUES (");
		sqlStr.append("?, ?, ?, TO_DATE(?,'ddMMyyyyhh24miss'))");
		sqlStr_insertEpoLog = sqlStr.toString();
	}
	
	
	public static void doAction() {
		StringBuffer message = new StringBuffer();
		StringBuffer sqlStr = new StringBuffer();

		String doccode = null;
		String docfname = null;
		String docgname = null;
		String MPSCDATE = null;
		String docemail = null;
		String SPECIALTY = null;
		String getDocList_sqlStr = null;
		ArrayList<ReportableListObject> docList_ArrayList = null;
		ReportableListObject reportableListObject = null;
		Vector emailTo = new Vector();
		String[] emailListToArray = null;
		String[] mailToBccArray = new String[1];
		String vpmaEmail = "medicalaffairs@hkah.org.hk";
		String vpmaEmail1 = "eve.lee@hkah.org.hk";

		docemail = vpmaEmail+";"+vpmaEmail1;
		message.setLength(0);
		message.append("Test mail");
		emailTo.add(docemail);
		emailListToArray = (String[]) emailTo.toArray(new String[emailTo.size()]);
		mailToBccArray[0] = vpmaEmail;
						
		// Send mail
		UtilMail.sendMail(
				ConstantsServerSide.MAIL_ALERT,
				emailListToArray,
				mailToBccArray,
				null,
				"Test EMAIL",
				message.toString());
			
			
			// reset values
			emailListToArray = null;			
			emailTo = null; 

	}
	
	public static void menuGenWeeklyBill() throws IOException {
		DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
		//get current date time with Date()
		Date date = new Date();
		System.out.println(dateFormat.format(date));
  
		//get current date time with Calendar()
		Calendar cal = Calendar.getInstance();
//		if(ConstantsServerSide.SECURE_SERVER){
			cal.add(Calendar.DATE, 1);			
//		}
		String printDate = dateFormat.format(cal.getTime()); 
		System.out.println("[printDate]:"+printDate);
		   
		String successCreate = UtilDBWeb.callFunction(
				"NHS_ACT_GENALLPATLETTER",
				null,
				new String[] {					
						printDate
				});
		
		System.out.println("[successCreate]:"+successCreate);
	}	
	
	public static ArrayList getPath() {
		StringBuffer sqlStr = new StringBuffer();		
		String cms = "CMS";
		String mobile = "MOBILE";
		String photoPath = "PHOTO_PATH";
		
		sqlStr.append("select CODE_VALUE1 from AH_SYS_CODE@cis where SYS_ID = '");
		sqlStr.append(cms);
		sqlStr.append("' and CODE_TYPE = '");
		sqlStr.append(mobile);
		sqlStr.append("' and CODE_NO = '");
		sqlStr.append(photoPath);
		sqlStr.append("'");
		System.err.println("[sql]:"+sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());	
	}
	
}