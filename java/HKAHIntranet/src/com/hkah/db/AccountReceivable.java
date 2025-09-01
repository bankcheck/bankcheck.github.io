/*
 * Created on July 25, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.db;

import java.util.Vector;

import javax.sql.DataSource;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class AccountReceivable extends ServerSideCallDB {

	protected String getAppendSQL() {
		return null;
	}
		
	protected String getModifySQL() {
		return null;
	}

	protected String getDeleteSQL() {
		return null;
	}

	protected String getFetchSQL() {
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT A.ARCCODE, A.ARCNAME, ARCCNAME, A.GLCCODE, A.RETGLCCODE, A.ARCADD1, A.ARCADD2, A.ARCADD3, A.ARCTEL, A.FAX, A.EMAIL, A.ARCCT, A.ARCTITLE, A.ARCUAMT, A.ARCAMT, A.CPSID, C.CPSCODE, A.FURCCT, A.FURTTL, A.FURTEL, A.FURFAX, A.FUREMAIL, A.ADMTTL, A.ADMEMAIL, A.ARCADMCNAME, A.ARCADMCP, A.ARCADMCF, A.ARCSND, A.COPAYTYP, A.ARLMTAMT, A.CVREDATE, A.COPAYAMT, A.ITMTYPED, A.ITMTYPEH, A.ITMTYPES, A.ITMTYPEO, TO_CHAR(A.AR_S_DATE, 'dd/MM/YYYY'), TO_CHAR(A.AR_E_DATE, 'dd/MM/YYYY') ");
		sb.append("FROM ARCODE A, CONPCESET C ");
		sb.append("WHERE A.CPSID = C.CPSID(+) ");
		sb.append("AND   A.ARCCODE = ? ");
		return sb.toString();
	}

	protected String getListSQL(String[] inQueue) {
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT A.ARCCODE, A.ARCNAME, ARCCNAME, A.GLCCODE, A.RETGLCCODE, A.ARCADD1, A.ARCADD2, A.ARCADD3, A.ARCTEL, A.FAX, A.EMAIL, A.ARCCT, A.ARCTITLE, A.ARCUAMT, A.ARCAMT, A.CPSID, C.CPSCODE, A.FURCCT, A.FURTTL, A.FURTEL, A.FURFAX, A.FUREMAIL, A.ADMTTL, A.ADMEMAIL, A.ARCADMCNAME, A.ARCADMCP, A.ARCADMCF, A.ARCSND, A.COPAYTYP, A.ARLMTAMT, A.CVREDATE, A.COPAYAMT, A.ITMTYPED, A.ITMTYPEH, A.ITMTYPES, A.ITMTYPEO, TO_CHAR(A.AR_S_DATE, 'dd/MM/YYYY'), TO_CHAR(A.AR_E_DATE, 'dd/MM/YYYY') ");
		sb.append("FROM ARCODE A, CONPCESET C ");
		sb.append("WHERE A.CPSID = C.CPSID(+) ");
		if (inQueue[0].length() > 0) {
			sb.append("AND   A.ARCCODE LIKE ? ");
		}
		if (inQueue[1].length() > 0) {
			sb.append("AND   A.ARCNAME LIKE ? ");
		}
		sb.append("AND   ROWNUM < 100 ");
		sb.append("ORDER BY A.ARCCODE ASC");
		return sb.toString();
	}

	protected String[] getAppendParameters(String[] pStrA_InQueue) {
		return new String[] { 
				pStrA_InQueue[0], pStrA_InQueue[1], pStrA_InQueue[3], pStrA_InQueue[2], pStrA_InQueue[4], 
				pStrA_InQueue[5] 
		};
	}

	protected String[] getModifyParameters(String[] pStrA_InQueue) {
		return new String[] { 
				pStrA_InQueue[3], pStrA_InQueue[2], pStrA_InQueue[4], 
				pStrA_InQueue[5], pStrA_InQueue[0], pStrA_InQueue[1]
		};
	}

	protected String[] getDeleteParameters(String[] pStrA_InQueue) {
		return new String[] { pStrA_InQueue[0], pStrA_InQueue[1]};
	}

	protected String[] getFetchParameters(String[] pStrA_InQueue) {
		return new String[] { pStrA_InQueue[0] };
	}

	protected String[] getListParameters(String[] inQueue) {
		Vector<String> v = new Vector<String>();
		for (int i=0; i<inQueue.length; i++) {
			if (inQueue[i].length() > 0) {
				v.add("%" + inQueue[i] + "%");
			}
		}
		return v.toArray(new String[v.size()]);
	}

	protected boolean isValid(DataSource pObj_DataSource, String pStr_ActionType, String[] pStrA_InQueue) {
			return true;
	}
}