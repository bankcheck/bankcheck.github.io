package com.hkah.web.db;

import java.math.BigDecimal;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.DateTimeUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;

public class DiIncomeReportDB {
	private static String sqlStr_getDocincomeList = null;
	
	private static String sqlStr_getPayrollSummaryByExdateServcdeHKList = null;
	private static String sqlStr_getPayrollSummaryByExdateDrpayServcdeHKList = null;
	private static String sqlStr_getPayrollSummaryByExdateCommServcdeHKList = null;
	private static String sqlStr_getPayrollSummaryByExdateServcdeHKSumList = null;
	private static String sqlStr_getPayrollSummaryByExdateDiffHKSumList = null;
	
	private static String sqlStr_getPayrollSummaryByExdateServcdeTWList = null;
	private static String sqlStr_getPayrollSummaryByExdateDrpayServcdeTWList = null;
	private static String sqlStr_getPayrollSummaryByExdateCommServcdeTWList = null;
	private static String sqlStr_getPayrollSummaryByExdateServcdeTWSumList = null;
	private static String sqlStr_getPayrollSummaryByExdateDiffTWSumList = null;
	
	private static String sqlStr_getAdjustDetailsList = null;
	private static String sqlStr_getAdjustDetailsAdjList = null;
	
	private static String sqlStr_getConStartDate = null;
	private static String sqlStr_getConEndDate = null;
	
	private static String sqlStr_getPayToList = null;
	private static String sqlStr_insertExam2Pay = null;
	private static String sqlStr_deleteExam2Pay = null;
	private static String sqlStr_deleteExam2PayTrial = null;
	private static String sqlStr_noOfExam2PayActualInMth = null;
	private static String sqlStr_deleteTrialDocincome = null;
	private static String sqlStr_getDpServ = null;

	/*
	public static List getDiPayroll(String rptid, String rptdoccode, String enddt) {
		List<String> params = new ArrayList<String>();

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append(sqlStr_getDocincomeList);
		StringBuffer sqlStrWhere = new StringBuffer();
		if (rptid != null) {
			if (sqlStrWhere.length() > 0 )
				sqlStrWhere.append(" AND");
			sqlStr.append(" rptid = ? ");
			params.add(rptid);
		}
		if (rptdoccode != null) {
			if (sqlStrWhere.length() > 0 )
				sqlStrWhere.append(" AND");
			sqlStr.append(" rptdoccode = ? ");
			params.add(rptdoccode);
		}
		if (enddt != null && !"".equals(enddt)) {
			if (sqlStrWhere.length() > 0 )
				sqlStrWhere.append(" AND");
			sqlStrWhere.append(" TO_DATE(?, 'DD/MM/YYYY') <= TRUNC(enddt)");
			params.add(enddt);
		}
		sqlStr.append(sqlStrWhere);
		String[] paramsArray = params.toArray(new String[]{});

 		return UtilDBWeb.getReportableListHATS(sqlStr.toString(), paramsArray);
	}
	*/

	public static List getDiPayrollSummary(String rpttype, String actualrun, String endDate, String dept, String payTo) {
		List<String> params = new ArrayList<String>();

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append(sqlStr_getDocincomeList);
		/*
		StringBuffer sqlStrWhere = new StringBuffer();
		if (payTo != null && !"".equals(payTo)) {
			if (sqlStrWhere.length() > 0 )
				sqlStrWhere.append(" AND");
			sqlStrWhere.append(" PAYTO = ?");
			params.add(payTo);
		}

		if (startDate != null && !"".equals(startDate)) {
			if (sqlStrWhere.length() > 0 )
				sqlStrWhere.append(" AND");
			sqlStrWhere.append(" TRUNC(STARTDT) = TO_DATE(?, 'DD/MM/YYYY')");
			params.add(startDate);
		}

		if (endDate != null && !"".equals(endDate)) {
			if (sqlStrWhere.length() > 0 )
				sqlStrWhere.append(" AND");
			sqlStrWhere.append(" TRUNC(enddt) = TO_DATE(?, 'DD/MM/YYYY')");
			params.add(endDate);
		}
		if (sqlStrWhere.length() > 0 ) {
			sqlStrWhere.insert(0, " WHERE");
		}
		sqlStr.append(sqlStrWhere);
		String[] paramsArray = params.toArray(new String[]{});
		*/
		System.out.println("[DiIncomeReportDB] getDiPayrollSummary sqlStr=" + sqlStr.toString());
		System.out.println(" param:" + rpttype + "," + actualrun + "," + endDate + "," + dept + "," + payTo);
		
		return UtilDBWeb.getReportableListHATS(sqlStr.toString(), 
				new String[]{rpttype, actualrun, endDate, dept, payTo});
	}
	
	public static List<ReportableListObject> getPayrollSummaryByExdateServcde(String rpttype, String slptype, 
			String actualrun, String endDate, String payTo) {
		List<String> params = new ArrayList<String>();

		String sql = ConstantsServerSide.isTWAH() ? sqlStr_getPayrollSummaryByExdateServcdeTWList : sqlStr_getPayrollSummaryByExdateServcdeHKList;
		
		System.out.println("[DiIncomeReportDB] getPayrollSummaryByExdateServcde sqlStr=" + sql);
		System.out.println(" param:" + rpttype + "," + slptype + "," + actualrun + "," + endDate + "," + payTo);
		
		return UtilDBWeb.getReportableListHATS(sql, 
				new String[]{rpttype, slptype, actualrun, endDate, payTo});
	}
	
	public static List<ReportableListObject> getPayrollSummaryByExdateDrpayServcde(String rpttype, String slptype, 
			String actualrun, String endDate, String payTo) {
		List<String> params = new ArrayList<String>();

		String sql = ConstantsServerSide.isTWAH() ? sqlStr_getPayrollSummaryByExdateDrpayServcdeTWList : sqlStr_getPayrollSummaryByExdateDrpayServcdeHKList;
		
		System.out.println("[DiIncomeReportDB] getPayrollSummaryByExdateDrpayServcde sqlStr=" + sql);
		System.out.println(" param:" + rpttype + "," + slptype + "," + actualrun + "," + endDate + "," + payTo);
		
		return UtilDBWeb.getReportableListHATS(sql, 
				new String[]{rpttype, slptype, actualrun, endDate, payTo});
	}
	
	public static List<ReportableListObject> getPayrollSummaryByExdateCommServcde(String rpttype, String slptype, 
			String actualrun, String endDate, String payTo) {
		List<String> params = new ArrayList<String>();

		String sql = ConstantsServerSide.isTWAH() ? sqlStr_getPayrollSummaryByExdateCommServcdeTWList : sqlStr_getPayrollSummaryByExdateCommServcdeHKList;
		
		System.out.println("[DiIncomeReportDB] getPayrollSummaryByExdateCommServcde sqlStr=" + sql);
		System.out.println(" param:" + rpttype + "," + slptype + "," + actualrun + "," + endDate + "," + payTo);
		
		return UtilDBWeb.getReportableListHATS(sql, 
				new String[]{rpttype, slptype, actualrun, endDate, payTo});
	}
	
	public static List<ReportableListObject> getPayrollSummaryByExdateServcdeSum(String rpttype, String slptype, 
			String actualrun, String endDate, String payTo) {
		List<String> params = new ArrayList<String>();

		String sql = ConstantsServerSide.isTWAH() ? sqlStr_getPayrollSummaryByExdateServcdeTWSumList : sqlStr_getPayrollSummaryByExdateServcdeHKSumList;
		
		System.out.println("[DiIncomeReportDB] getPayrollSummaryByExdateServcdeSum sqlStr=" + sql);
		System.out.println(" param:" + rpttype + "," + slptype + "," + actualrun + "," + endDate + "," + payTo);
		
		return UtilDBWeb.getReportableListHATS(sql, 
				new String[]{rpttype, slptype, actualrun, endDate, payTo});
	}
	
	public static List<ReportableListObject> getPayrollSummaryByExdateDiff(String rpttype1, String enddt1, String rpttype2, String enddt2, 
			String slptype, String actualrun, String payTo) {
		List<String> params = new ArrayList<String>();

		String sql = ConstantsServerSide.isTWAH() ? sqlStr_getPayrollSummaryByExdateDiffTWSumList : sqlStr_getPayrollSummaryByExdateDiffHKSumList;
		
		System.out.println("[DiIncomeReportDB] sqlStr_getPayrollSummaryByExdateDiffTWSumList sqlStr=" + sql);
		System.out.println(" param:" + rpttype1 + "," + enddt1 + "," + rpttype2 + "," + enddt2 + "," + slptype + "," + actualrun + "," + payTo);
		
		return UtilDBWeb.getReportableListHATS(sql, 
				new String[]{rpttype1, slptype, actualrun, enddt1, payTo,
				rpttype2, slptype, actualrun, enddt2, payTo});
	}
	
	public static List<ReportableListObject> getAdjustDetails(String rpttype1, String enddt1, String rpttype2, String enddt2, 
			String slptype, String actualrun, String payTo, String servcde, String examdt, boolean isAdjust) {
		String sql = isAdjust ? sqlStr_getAdjustDetailsAdjList : sqlStr_getAdjustDetailsList;
		
		System.out.println("[DiIncomeReportDB] sqlStr_getAdjustDetailsList sqlStr=" + sql);
		System.out.println(" param:" + rpttype1 + "," + enddt1 + "," + rpttype2 + "," + enddt2 + "," + slptype + "," + 
				actualrun + "," + payTo + "," + servcde + "," + examdt + ", isAdjust=" + isAdjust);
		
		return UtilDBWeb.getReportableListHATS(sql, 
				new String[]{rpttype1, enddt1, rpttype2, enddt2, slptype, actualrun, payTo, servcde, examdt});
	}
	
	public static List<ReportableListObject> getDpservs() {
		return UtilDBWeb.getReportableListHATS(sqlStr_getDpServ.toString());
	}

	public static List getPayToList() {
		return UtilDBWeb.getReportableListHATS(sqlStr_getPayToList.toString(), null);
	}
	
	public static String getConStartDate(String payTo, String endDate) {
		List<String> params = new ArrayList<String>();
		if (!ConstantsServerSide.isTWAH()) {
			params.add(payTo);
			params.add(endDate);
		}
		params.add(payTo);
		params.add(endDate);
		List<ReportableListObject> list = UtilDBWeb.getReportableListHATS(sqlStr_getConStartDate.toString(), 
				params.toArray(new String[params.size()]));
		String ret = null;
		if (list != null && !list.isEmpty()) {
			ReportableListObject rlo = list.get(0);
			ret = rlo.getValue(0);
		}
		return ret;
	}
	
	public static String getConEndDate(String payTo, String endDate) {
		List<ReportableListObject> list = UtilDBWeb.getReportableListHATS(sqlStr_getConEndDate.toString(), 
				new String[]{endDate, endDate, payTo, payTo});
		
		String ret = null;
		if (list != null && !list.isEmpty()) {
			ReportableListObject rlo = list.get(0);
			ret = rlo.getValue(0);
		}
		System.out.println("[getConEndDate] ret="+ret);
		return ret;
	}
	
	//====================
	// Prepare report data
	//====================
	public static boolean prepareExam2PayData(String approvedateStart, String approvedateEnd) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("insert into exam2pay ");
		sqlStr.append("select SEQ_EXAM2PAY.nextval, ");
		sqlStr.append("x.slpno, x.stnid ");
		sqlStr.append(", x.itmcode, a.doccode as rptdr ");
		sqlStr.append(", approvedate as rptdt ");
		sqlStr.append(", null as paydt ");
		sqlStr.append(", x.DIXREF ");
		sqlStr.append(", stntdate as EXAMDT ");
		sqlStr.append(", stncdate as ORDERDT ");
		sqlStr.append(", irefno ");
		sqlStr.append("from xreport a, xreg b, sliptx x ");
		sqlStr.append("where a.xrgid=b.xrgid ");
		sqlStr.append("and b.slpno=x.slpno and b.stnid=x.dixref ");
		sqlStr.append("and stnsts='N' ");
		if (approvedateStart != null) {
			sqlStr.append("and a.approvedate >= to_date(?,'dd/mm/yyyy') ");
		}
		if (approvedateEnd != null) {
			sqlStr.append("and a.approvedate < to_date(?,'dd/mm/yyyy') + 1 ");
		}
		sqlStr.append("and x.stndidoc is null");

		return UtilDBWeb.updateQueueHATS(sqlStr.toString(), new String[] { approvedateStart, approvedateEnd } );
	}

	public static boolean deleteExam2Pay() {
		return UtilDBWeb.updateQueueHATS(sqlStr_deleteExam2Pay, null);
	}

	public static boolean deleteTrialDocincome() {
		return UtilDBWeb.updateQueueHATS(sqlStr_deleteTrialDocincome, null);
	}
	
	// ** must do it before generating BF, IC, CF reports **
	public static boolean insertTempSliptx() {
		System.out.println("[DEV] DiIncomeReportDB.insertTempSliptx() ");
		boolean success = false;
		
		// temp_cardtx
		// do not use delete from, too many records
		success = UtilDBWeb.updateQueueHATS("truncate table temp_cardtx ", null);
		System.out.println("[DEV] truncate temp_cardtx success");
		String insertTempCardtxSql = 
			"insert into temp_cardtx select substr(CTNREF,3),CTNCTYPE from cardtx where ctnctype is not null ";
		
		success = UtilDBWeb.updateQueueHATS(insertTempCardtxSql, null);
		System.out.println("[DEV] insert temp_cardtx inserted row count=" + success);
		
		return success;
	}

	public static Integer execDiPayroll(String startdate, String enddate, String rptDrCode, String actualRun) {
		Object ret = null;
		Object[] inQueue = null;
		int[] inTypes = null;
		int outType;
		Integer retInt = null;

		try {
			Date startdateDat = DateTimeUtil.parseDate(startdate);
			java.sql.Date startdateSqlDate = (startdateDat != null ? new java.sql.Date(startdateDat.getTime()) : null);

			Date enddateDat = DateTimeUtil.parseDate(enddate);
			java.sql.Date enddateSqlDate = (enddateDat != null ? new java.sql.Date(enddateDat.getTime()) : null);

			/*
			 *
			cs.setDate(1, startdateSqlDate);
			cs.setDate(2, enddateSqlDate);
			cs.setString(3, rptDrCode);
			cs.setString(4, actualRun);
			cs.registerOutParameter(5, OracleTypes.NUMBER);
			 */
			inQueue = new Object[4];
			inQueue[0] = startdateSqlDate;
			inQueue[1] = enddateSqlDate;
			inQueue[2] = rptDrCode;
			inQueue[3] = actualRun;

			inTypes = new int[4];
			inTypes[0] = Types.DATE;
			inTypes[1] = Types.DATE;
			inTypes[2] = Types.VARCHAR;
			inTypes[3] = Types.CHAR;

			//outType = OracleTypes.NUMBER;
			outType = Types.NUMERIC;

			if (ConstantsServerSide.DEBUG) {
				ret = UtilDBWeb.callFunctionHATS("DI_PAYROLL", null, inQueue, inTypes, outType);
			} else {
				ret = UtilDBWeb.callFunctionHATS("DI_PAYROLL", null, inQueue, inTypes, outType);
			}
			
			if (ret != null) {
				if (ret instanceof BigDecimal) {
					retInt = ((BigDecimal) ret).intValue();
				} else if (ret instanceof Integer) {
					retInt = (Integer) ret;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return retInt;
	}

	public static boolean addExam2Pay(String year, String month) {
		String startDate = "01/" + month + "/" + year;

		// System.out.println("DEBUG: sqlStr_insertExam2Pay = " + sqlStr_insertExam2Pay + ", startDate = " + startDate);
		return UtilDBWeb.updateQueueHATS(sqlStr_insertExam2Pay.toString(), new String[] { startDate, startDate } );
	}
	
	public static boolean isExam2PayActualRun(String year, String month) {
		String startDate = "01/" + month + "/" + year;

		ArrayList list = null;
		if (ConstantsServerSide.DEBUG) {
			list = UtilDBWeb.getReportableListHATS(sqlStr_noOfExam2PayActualInMth.toString(), new String[] { startDate, startDate } );
		} else {
			list = UtilDBWeb.getReportableListHATS(sqlStr_noOfExam2PayActualInMth.toString(), new String[] { startDate, startDate } );
		}
		
		ReportableListObject row = (ReportableListObject) list.get(0);
		if (row != null) {
			String count = row.getFields0();
			if (!"0".equals(count)) {
				return true;
			}
		}
		return false;
	}
	

	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select ");
		sqlStr.append("RPTID, ");
		sqlStr.append("RPTDOCCODE, ");
		sqlStr.append("DOCFNAME, ");
		sqlStr.append("DOCGNAME, ");
		sqlStr.append("SERVCDE, ");
		sqlStr.append("SERVDESC, ");
		sqlStr.append("EXCODE, ");
		sqlStr.append("EXNAME, ");
		sqlStr.append("TO_CHAR(RPTDATE, 'dd/MM/yyyy'), ");
		sqlStr.append("PATNO, ");
		sqlStr.append("PATFNAME, ");
		sqlStr.append("PATGNAME, ");
		sqlStr.append("SLPFNAME, ");
		sqlStr.append("SLPGNAME, ");
		sqlStr.append("SLPNO, ");
		sqlStr.append("STNID, ");
		sqlStr.append("SLPTYPE, ");
		sqlStr.append("OAMT, ");
		sqlStr.append("BILLAMT, ");
		sqlStr.append("DISCOUNT, ");
		sqlStr.append("NETAMT, ");
		sqlStr.append("CONSUM, ");
		sqlStr.append("COLFEE, ");
		sqlStr.append("REVS, ");
		sqlStr.append("NETPAY, ");
		sqlStr.append("DOCSHARE, ");
		sqlStr.append("DOCSHAREAMT, ");
		sqlStr.append("DOCUSEFULL, ");
		sqlStr.append("DOCFEE, ");
		sqlStr.append("DIXREF, ");
		sqlStr.append("PAYTO, ");
		sqlStr.append("TO_CHAR(CONTRACTSTARTDT, 'dd/MM/yyyy'), ");
		sqlStr.append("TO_CHAR(CONTRACTENDDT, 'dd/MM/yyyy'), ");
		sqlStr.append("RPTTYPE, ");
		sqlStr.append("ACTUALRUN, ");
		sqlStr.append("TO_CHAR(ENDDT, 'dd/MM/yyyy'), ");
		sqlStr.append("STNSTS, ");
		sqlStr.append("PCYID, ");
		sqlStr.append("PATSTAFF, ");
		sqlStr.append("TO_CHAR(EXAMDT, 'dd/MM/yyyy'), ");
		sqlStr.append("TO_CHAR(ORDERDT, 'dd/MM/yyyy'), ");
		sqlStr.append("TO_CHAR(STARTDT, 'dd/MM/yyyy'), ");
		sqlStr.append("IREFNO ");
		sqlStr.append("table(RIS_PAYROLL.docincome2base(?, ?, ?, ?, ?)); ");
		sqlStr_getDocincomeList = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("select ");
		sqlStr.append("  examdt_ym || '/01', ");
		sqlStr.append("  null total, ");
		sqlStr.append("  ct_netpay, ");
		sqlStr.append("  jb_netpay, ");
		sqlStr.append("  jp_netpay, ");
		sqlStr.append("  mr_netpay, ");
		sqlStr.append("  nu_netpay, ");
		//sqlStr.append("  ps_netpay, ");
		sqlStr.append("  ra_netpay, ");
		sqlStr.append("  us_netpay ");
		sqlStr.append("from table(RIS_PAYROLL.summarybyexdate_hk(?,?,?,?,?)) ");
		sqlStr_getPayrollSummaryByExdateServcdeHKList = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("select ");
		sqlStr.append("  examdt_ym || '/01', ");
		sqlStr.append("  null total, ");
		sqlStr.append("  ct_netpay, ");
		sqlStr.append("  jb_netpay, ");
		sqlStr.append("  jp_netpay, ");
		sqlStr.append("  mr_netpay, ");
		sqlStr.append("  nu_netpay, ");
		//sqlStr.append("  ps_netpay, ");
		sqlStr.append("  ra_netpay, ");
		sqlStr.append("  us_netpay ");
		sqlStr.append("from table(RIS_PAYROLL.summarybyexdate_drpay_hk(?,?,?,?,?)) ");
		sqlStr_getPayrollSummaryByExdateDrpayServcdeHKList = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("select ");
		sqlStr.append("  examdt_ym || '/01', ");
		sqlStr.append("  null total, ");
		sqlStr.append("  ct_netpay, ");
		sqlStr.append("  jb_netpay, ");
		sqlStr.append("  jp_netpay, ");
		sqlStr.append("  mr_netpay, ");
		sqlStr.append("  nu_netpay, ");
		//sqlStr.append("  ps_netpay, ");
		sqlStr.append("  ra_netpay, ");
		sqlStr.append("  us_netpay ");
		sqlStr.append("from table(RIS_PAYROLL.summarybyexdate_comm_hk(?,?,?,?,?)) ");
		sqlStr_getPayrollSummaryByExdateCommServcdeHKList = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("select ");
		sqlStr.append("  sum(ct_netpay), ");
		sqlStr.append("  sum(jb_netpay), ");
		sqlStr.append("  sum(jp_netpay), ");
		sqlStr.append("  sum(mr_netpay), ");
		sqlStr.append("  sum(nu_netpay), ");
		//sqlStr.append("  sum(ps_netpay), ");
		sqlStr.append("  sum(ra_netpay), ");
		sqlStr.append("  sum(us_netpay) ");
		sqlStr.append("from table(RIS_PAYROLL.summarybyexdate_hk(?,?,?,?,?)) ");
		sqlStr_getPayrollSummaryByExdateServcdeHKSumList = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("select '0', 'servcde', 'CT', 'JB', 'JP', 'MR', 'NU', 'RA', 'US' from dual ");
		sqlStr.append("	union ");
		sqlStr.append("select  ");
		sqlStr.append("    bf.examdt examdt_1, ");
		sqlStr.append("    cf.examdt examdt_2, ");
		sqlStr.append("    to_char(nvl(bf.ct_netpay, 0) - nvl(cf.ct_netpay, 0)) ct_netpay_diff, ");
		sqlStr.append("    to_char(nvl(bf.jb_netpay, 0) - nvl(cf.jb_netpay, 0)) jb_netpay_diff, ");
		sqlStr.append("    to_char(nvl(bf.jp_netpay, 0) - nvl(cf.jp_netpay, 0)) jp_netpay_diff, ");
		sqlStr.append("    to_char(nvl(bf.mr_netpay, 0) - nvl(cf.mr_netpay, 0)) mr_netpay_diff, ");
		sqlStr.append("    to_char(nvl(bf.nu_netpay, 0) - nvl(cf.nu_netpay, 0)) nu_netpay_diff, ");
		sqlStr.append("    to_char(nvl(bf.ra_Netpay, 0) - nvl(cf.ra_Netpay, 0)) ra_Netpay_diff, ");
		sqlStr.append("    to_char(nvl(bf.us_netpay, 0) - nvl(cf.us_netpay, 0)) us_netpay_diff ");
		sqlStr.append("from ");
		sqlStr.append("( ");
		sqlStr.append("    select  ");
		sqlStr.append("      examdt_ym || '/01' examdt,  ");
		//sqlStr.append("      --null total,  ");
		sqlStr.append("      ct_netpay,  ");
		sqlStr.append("      jb_netpay,  ");
		sqlStr.append("      jp_netpay,  ");
		sqlStr.append("      mr_netpay,  ");
		sqlStr.append("      nu_netpay,  ");
		sqlStr.append("      ra_Netpay,  ");
		sqlStr.append("      us_netpay  ");
		sqlStr.append("    from table(RIS_PAYROLL.summarybyexdate_hk(?,?,?,?,?)) ");
		//sqlStr.append("    -- where examdt_ym <> to_char(to_date('31/05/2019', 'dd/mm/yyyy'), 'yyyy/mm') ");
		sqlStr.append(") bf ");
		sqlStr.append("full join ");
		sqlStr.append("( ");
		sqlStr.append("    select  ");
		sqlStr.append("      examdt_ym || '/01' examdt,  ");
		//sqlStr.append("      --null total,  ");
		sqlStr.append("      ct_netpay,  ");
		sqlStr.append("      jb_netpay,  ");
		sqlStr.append("      jp_netpay,  ");
		sqlStr.append("      mr_netpay,  ");
		sqlStr.append("      nu_netpay,  ");
		sqlStr.append("      ra_Netpay,  ");
		sqlStr.append("      us_netpay  ");
		sqlStr.append("    from table(RIS_PAYROLL.summarybyexdate_hk(?,?,?,?,?)) ");
		sqlStr.append(") cf  ");
		sqlStr.append("    on bf.examdt = cf.examdt ");
		sqlStr.append("where  ");
		sqlStr.append("    bf.ct_netpay <> cf.ct_netpay or ");
		sqlStr.append("    bf.jb_netpay <> cf.jb_netpay or ");
		sqlStr.append("    bf.jp_netpay <> cf.jp_netpay or ");
		sqlStr.append("    bf.mr_netpay <> cf.mr_netpay or ");
		sqlStr.append("    bf.nu_netpay <> cf.nu_netpay or ");
		sqlStr.append("    bf.ra_Netpay <> cf.ra_Netpay or ");
		sqlStr.append("    bf.us_netpay <> cf.us_netpay ");
		sqlStr_getPayrollSummaryByExdateDiffHKSumList = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("select ");
		sqlStr.append("  examdt_ym || '/01', ");
		sqlStr.append("  null total, ");
		sqlStr.append("  mm_netpay, ");
		sqlStr.append("  xe_netpay, ");
		sqlStr.append("  xh_netpay, ");
		sqlStr.append("  xp_netpay, ");
		sqlStr.append("  xr_netpay, ");
		sqlStr.append("  Xt_Netpay, ");
		sqlStr.append("  xu_netpay ");
		sqlStr.append("from table(RIS_PAYROLL.summarybyexdate_tw(?,?,?,?,?)) ");
		sqlStr_getPayrollSummaryByExdateServcdeTWList = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("select ");
		sqlStr.append("  examdt_ym || '/01', ");
		sqlStr.append("  null total, ");
		sqlStr.append("  mm_netpay, ");
		sqlStr.append("  xe_netpay, ");
		sqlStr.append("  xh_netpay, ");
		sqlStr.append("  xp_netpay, ");
		sqlStr.append("  xr_netpay, ");
		sqlStr.append("  Xt_Netpay, ");
		sqlStr.append("  xu_netpay ");
		sqlStr.append("from table(RIS_PAYROLL.summarybyexdate_drpay_tw(?,?,?,?,?)) ");
		sqlStr_getPayrollSummaryByExdateDrpayServcdeTWList = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("select ");
		sqlStr.append("  examdt_ym || '/01', ");
		sqlStr.append("  null total, ");
		sqlStr.append("  mm_netpay, ");
		sqlStr.append("  xe_netpay, ");
		sqlStr.append("  xh_netpay, ");
		sqlStr.append("  xp_netpay, ");
		sqlStr.append("  xr_netpay, ");
		sqlStr.append("  Xt_Netpay, ");
		sqlStr.append("  xu_netpay ");
		sqlStr.append("from table(RIS_PAYROLL.summarybyexdate_comm_tw(?,?,?,?,?)) ");
		sqlStr_getPayrollSummaryByExdateCommServcdeTWList = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("select  ");
		sqlStr.append("  to_char(enddt, 'dd/mm/yyyy'), ");
		sqlStr.append("  servcde, ");
		sqlStr.append("  Excode, ");
		sqlStr.append("  Exname, ");
		sqlStr.append("  Exdate, ");
		sqlStr.append("  Patno, ");
		sqlStr.append("  Patname, ");
		sqlStr.append("  Slpno, ");
		sqlStr.append("  Oamt, ");
		sqlStr.append("  Billamt, ");
		sqlStr.append("  Discount, ");
		sqlStr.append("  netamt, ");
		sqlStr.append("  Consum, ");
		sqlStr.append("  revs, ");
		sqlStr.append("  Netpay, ");
		sqlStr.append("  Docshare, ");
		sqlStr.append("  docfee, ");
		sqlStr.append("  Colfee, ");
		sqlStr.append("  drpay, ");
		sqlStr.append("  'Previous exam reported in ' || to_char(enddt, 'Mon-yyyy') ");
		sqlStr.append("from table(RIS_PAYROLL.adjust_details(?,?,?,?,?,?,?,?,?)) ");
		sqlStr_getAdjustDetailsList = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("select  ");
		sqlStr.append("  to_char(enddt, 'dd/mm/yyyy'), ");
		sqlStr.append("  servcde, ");
		sqlStr.append("  Excode, ");
		sqlStr.append("  Exname, ");
		sqlStr.append("  Exdate, ");
		sqlStr.append("  Patno, ");
		sqlStr.append("  Patname, ");
		sqlStr.append("  Slpno, ");
		sqlStr.append("  0 -Oamt, ");
		sqlStr.append("  0 -Billamt, ");
		sqlStr.append("  0 -Discount, ");
		sqlStr.append("  0 -netamt, ");
		sqlStr.append("  0 -Consum, ");
		sqlStr.append("  0 -revs, ");
		sqlStr.append("  0 -Netpay, ");
		sqlStr.append("  Docshare, ");
		sqlStr.append("  0 -docfee, ");
		sqlStr.append("  0 -Colfee, ");
		sqlStr.append("  0 -drpay, ");
		sqlStr.append("  'Adjustment' ");
		sqlStr.append("from table(RIS_PAYROLL.adjust_details(?,?,?,?,?,?,?,?,?)) ");
		sqlStr_getAdjustDetailsAdjList = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("select ");
		sqlStr.append("  sum(mm_netpay), ");
		sqlStr.append("  sum(xe_netpay), ");
		sqlStr.append("  sum(xh_netpay), ");
		sqlStr.append("  sum(xp_netpay), ");
		sqlStr.append("  sum(xr_netpay), ");
		sqlStr.append("  sum(Xt_Netpay), ");
		sqlStr.append("  sum(xu_netpay) ");
		sqlStr.append("from table(RIS_PAYROLL.summarybyexdate_tw(?,?,?,?,?)) ");
		sqlStr_getPayrollSummaryByExdateServcdeTWSumList = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("select '0', 'servcde', 'MM', 'XE', 'XH', 'XP', 'XR', 'XT', 'XU' from dual ");
		sqlStr.append("	union ");
		sqlStr.append("select  ");
		sqlStr.append("    bf.examdt examdt_1, ");
		sqlStr.append("    cf.examdt examdt_2, ");
		sqlStr.append("    to_char(nvl(bf.mm_netpay, 0) - nvl(cf.mm_netpay, 0)) mm_netpay_diff, ");
		sqlStr.append("    to_char(nvl(bf.xe_netpay, 0) - nvl(cf.xe_netpay, 0)) xe_netpay_diff, ");
		sqlStr.append("    to_char(nvl(bf.xh_netpay, 0) - nvl(cf.xh_netpay, 0)) xh_netpay_diff, ");
		sqlStr.append("    to_char(nvl(bf.xp_netpay, 0) - nvl(cf.xp_netpay, 0)) xp_netpay_diff, ");
		sqlStr.append("    to_char(nvl(bf.xr_netpay, 0) - nvl(cf.xr_netpay, 0)) xr_netpay_diff, ");
		sqlStr.append("    to_char(nvl(bf.Xt_Netpay, 0) - nvl(cf.Xt_Netpay, 0)) Xt_Netpay_diff, ");
		sqlStr.append("    to_char(nvl(bf.xu_netpay, 0) - nvl(cf.xu_netpay, 0)) xu_netpay_diff ");
		sqlStr.append("from ");
		sqlStr.append("( ");
		sqlStr.append("    select  ");
		sqlStr.append("      examdt_ym || '/01' examdt,  ");
		//sqlStr.append("      --null total,  ");
		sqlStr.append("      mm_netpay,  ");
		sqlStr.append("      xe_netpay,  ");
		sqlStr.append("      xh_netpay,  ");
		sqlStr.append("      xp_netpay,  ");
		sqlStr.append("      xr_netpay,  ");
		sqlStr.append("      Xt_Netpay,  ");
		sqlStr.append("      xu_netpay  ");
		sqlStr.append("    from table(RIS_PAYROLL.summarybyexdate_tw(?,?,?,?,?)) ");
		//sqlStr.append("    -- where examdt_ym <> to_char(to_date('31/05/2019', 'dd/mm/yyyy'), 'yyyy/mm') ");
		sqlStr.append(") bf ");
		sqlStr.append("full join ");
		sqlStr.append("( ");
		sqlStr.append("    select  ");
		sqlStr.append("      examdt_ym || '/01' examdt,  ");
		//sqlStr.append("      --null total,  ");
		sqlStr.append("      mm_netpay,  ");
		sqlStr.append("      xe_netpay,  ");
		sqlStr.append("      xh_netpay,  ");
		sqlStr.append("      xp_netpay,  ");
		sqlStr.append("      xr_netpay,  ");
		sqlStr.append("      Xt_Netpay,  ");
		sqlStr.append("      xu_netpay  ");
		sqlStr.append("    from table(RIS_PAYROLL.summarybyexdate_tw(?,?,?,?,?)) ");
		sqlStr.append(") cf  ");
		sqlStr.append("    on bf.examdt = cf.examdt ");
		sqlStr.append("where  ");
		sqlStr.append("    bf.mm_netpay <> cf.mm_netpay or ");
		sqlStr.append("    bf.xe_netpay <> cf.xe_netpay or ");
		sqlStr.append("    bf.xh_netpay <> cf.xh_netpay or ");
		sqlStr.append("    bf.xp_netpay <> cf.xp_netpay or ");
		sqlStr.append("    bf.xr_netpay <> cf.xr_netpay or ");
		sqlStr.append("    bf.Xt_Netpay <> cf.Xt_Netpay or ");
		sqlStr.append("    bf.xu_netpay <> cf.xu_netpay ");
		sqlStr_getPayrollSummaryByExdateDiffTWSumList = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("select distinct payto ");
		sqlStr.append("from DOCINCOME2 ");
		sqlStr.append("order by payto");
		sqlStr_getPayToList = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("select  ");
		sqlStr.append("    to_char(max(constartdate), 'dd/mm/yyyy') ");
		sqlStr.append("from ");
		sqlStr.append("( ");
		if (!ConstantsServerSide.isTWAH()) {
			// have current contract
			sqlStr.append("    select ");
			sqlStr.append("        min(constartdate) keep (dense_rank first order by conid) constartdate ");
			sqlStr.append("    from doccontract ");
			sqlStr.append("    where payto = ? ");
			sqlStr.append("    	and (conenddate > to_date(?, 'dd/mm/yyyy') or conenddate is null) ");
			sqlStr.append("        union ");
		}
		// no current contract
		sqlStr.append("    select ");
		sqlStr.append("        min(constartdate) keep (dense_rank first order by conid) constartdate ");
		sqlStr.append("    from doccontract ");
		sqlStr.append("    where payto = ? ");
		sqlStr.append("    and (conenddate < to_date(?, 'dd/mm/yyyy')) ");
		sqlStr.append(")  ");
		sqlStr_getConStartDate = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("select ");
		sqlStr.append(" case when max(conenddate) < to_date(?, 'dd/mm/yyyy') then to_char(max(conenddate), 'dd/mm/yyyy') else ?  end todate ");
		sqlStr.append("from doccontract ");
		sqlStr.append("where payto = ? ");
		sqlStr.append("and not exists ");
		sqlStr.append("( ");
		sqlStr.append("select 1 from doccontract ");
		sqlStr.append("where payto = ? ");
		sqlStr.append("and conenddate is null ");
		sqlStr.append(")");
		//sqlStr.append("select ?, ?, ? from dual");
		sqlStr_getConEndDate = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("insert into exam2pay ");
		sqlStr.append("select SEQ_EXAM2PAY.nextval, ");
		sqlStr.append("x.slpno, x.stnid ");
		sqlStr.append(", x.itmcode, a.doccode as rptdr ");
		sqlStr.append(", approvedate as rptdt ");
		sqlStr.append(", null as paydt ");
		sqlStr.append(", x.DIXREF ");
		sqlStr.append(", stntdate as EXAMDT ");
		sqlStr.append(", stncdate as ORDERDT ");
		sqlStr.append(", irefno ");
		sqlStr.append("from xreport a, xreg b, sliptx x ");
		sqlStr.append("where a.xrgid=b.xrgid ");
		sqlStr.append("and b.slpno=x.slpno and b.stnid=x.dixref ");
		sqlStr.append("and stnsts='N' ");
		sqlStr.append("and a.approvedate >= to_date(?,'dd/mm/yyyy') ");
		sqlStr.append("and a.approvedate < ADD_MONTHS(to_date(?,'dd/mm/yyyy'), 1) ");
		sqlStr.append("and x.stndidoc is null");
		sqlStr_insertExam2Pay = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("truncate table exam2pay ");
		sqlStr_deleteExam2Pay = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("select count(1) ");
		sqlStr.append("from exam2pay ");
		sqlStr.append("where paydt between to_date(?, 'dd/mm/yyyy') and add_months(to_date(?, 'dd/mm/yyyy'), 1) ");
		sqlStr_noOfExam2PayActualInMth = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("delete from DOCINCOME2 where actualrun = 'N' ");
		sqlStr_deleteTrialDocincome = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("select dsccode, dscdesc ");
		sqlStr.append("from dpserv ");
		sqlStr.append("order by dsccode");
		sqlStr_getDpServ = sqlStr.toString();
	}
}
