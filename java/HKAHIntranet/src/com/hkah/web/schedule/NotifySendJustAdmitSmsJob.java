package com.hkah.web.schedule;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.DateTimeUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.sms.UtilSMS;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.db.EmailAlertDB;
import com.hkah.web.db.helper.IPWardDetail;
import com.hkah.web.db.helper.JustAdmitDetail;
import com.hkah.web.db.helper.JustAdmitDocDetail;


public class NotifySendJustAdmitSmsJob implements Job {

	// ======================================================================
	private static Logger logger = Logger.getLogger(NotifySendJustAdmitSmsJob.class);
	public static final int TOTAL_SEC_DOC = 7;

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		System.out.println(DateTimeUtil.getCurrentDateTimeStandard() + " " + this.getClass().getSimpleName() + " execute");
		
		ArrayList handOverList = getHandOverList();
		logger.info("handOverList size="+handOverList.size());
		ArrayList<JustAdmitDocDetail> doctorDetailList = new ArrayList<JustAdmitDocDetail>();
		
		for (int i = 0; i < handOverList.size(); i++) {
			ReportableListObject row = (ReportableListObject) handOverList.get(i);	

			int j = 0;
			String patNo = row.getValue(j++);
			String regId = row.getValue(j++);
			String patfname = row.getValue(j++);
			String wardCode = row.getValue(j++);
			String wardName = row.getValue(j++);
			String bedCode = row.getValue(j++);
			String romCode = row.getValue(j++);
			String currdateStr = row.getValue(j++);
			
			String[] secDrM = new String[TOTAL_SEC_DOC];
			String[] secDrMtel = new String[TOTAL_SEC_DOC];
			String[] secDrMtel2 = new String[TOTAL_SEC_DOC];
			
//			System.out.println("Record["+i+"] regId="+regId);
			
			for (int k = 0; k < TOTAL_SEC_DOC; k++) {
				secDrM[k] = row.getValue(j++);
				secDrMtel[k] = row.getValue(j++);
				secDrMtel2[k] = row.getValue(j++);
				
//				System.out.println("  secDrM["+k+"]="+secDrM[k] + " secDrMtel["+k+"]="+secDrMtel[k] + " secDrMtel2["+k+"]="+secDrMtel2[k] + " secDrSmsSent["+k+"]="+secDrSmsSent[k]);
			}
			
			for (int k = 0; k < TOTAL_SEC_DOC; k++) {
				if (secDrM[k] != null && !secDrM[k].isEmpty()) {
					if (secDrMtel[k] != null || secDrMtel2[k] != null) {
						boolean foundDocCode = false;
						for(JustAdmitDocDetail d : doctorDetailList) {
							if (d.docCode.equals(secDrM[k])) {
								foundDocCode = true;
								d.justAdmitDetailList.add(new JustAdmitDetail(regId, patNo, patfname, wardCode, wardName, bedCode, romCode, currdateStr));
								break;
							}
						}
						if (foundDocCode == false) {	
							JustAdmitDocDetail tDoc = new JustAdmitDocDetail(secDrM[k], secDrMtel[k], secDrMtel2[k]);
							tDoc.justAdmitDetailList.add(new JustAdmitDetail(regId, patNo, patfname, wardCode, wardName, bedCode, romCode, currdateStr));
							doctorDetailList.add(tDoc);
						}
					}
				}
			}
		}
		
//		System.out.println("doctorDetailList size=" + doctorDetailList.size());

		for(JustAdmitDocDetail d : doctorDetailList) {
			logger.debug("docCode " + d.docCode + " phone1 = " + d.phone + " phone2 = " + d.phone2);
			
			String smsContent = null;
			boolean success1 = false;
			boolean success2= false;
			if ((d.phone != null && d.phone.length() > 0) || (d.phone2 != null && d.phone2.length() > 0)) {
				smsContent = getSMSMessage(d);
				if (smsContent != null) {
//					System.out.println(" smsContent=" + smsContent);	
					success1 = sendSms(d.phone, smsContent, d);
					success2 = sendSms(d.phone2, smsContent, d);
//					System.out.println("success1=" + success1 + ", success2="+success2);	
					if (success1 || success2) {
						updateSentLog(d);
					}
				}
			}				
		}
	}
	
	private static boolean sendSms(String phone, String smsContent, JustAdmitDocDetail justAdmitDocDetail) {
		boolean sent = false;
		if (phone != null && phone.length() > 0) {
			try {					
				String msgId = UtilSMS.sendSMS("", new String[] { StringUtils.deleteWhitespace(phone) },
						smsContent,
						"INPATDOCNUM",  "" , "ENG", "");
				sent = getSuccessOfSMS(msgId);
				
				//System.out.println("[SEND] phone=" + phone + ", smsContent=");	
				//System.out.println(smsContent);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return sent;
	}
					
	private static String getSMSMessage(JustAdmitDocDetail d) {
		StringBuffer smsContent = new StringBuffer();
		
		String currdateStr = null;
		if (!d.justAdmitDetailList.isEmpty()) {
			currdateStr = d.justAdmitDetailList.get(0).dateStr;
		}

		String docname = null;
		if (ConstantsServerSide.isTWAH()) {
			smsContent.append("Message from HKAH-TW: Just admitted" + (currdateStr == null ? "" : " as of " + currdateStr) + "\n");
			docname = getDoctorSurName(d.docCode);
		} else {
			smsContent.append("Message from HKAH-SR: Just admitted" + (currdateStr == null ? "" : " as of " + currdateStr) + "\n");
			docname = getDoctorName(d.docCode, false);
		}					
		smsContent.append("Under Dr. " + docname + "\n");						
		ArrayList<IPWardDetail> wardList = new ArrayList<IPWardDetail>();
		
		System.out.println(" detail size=" + d.justAdmitDetailList.size());	
		
		for (int i = 0; i < d.justAdmitDetailList.size(); i++) {
			String tWardCode =  d.justAdmitDetailList.get(i).wardCode;		
			String tWardName =  d.justAdmitDetailList.get(i).wardName;
			String tBedCode = d.justAdmitDetailList.get(i).bedCode;
			String tRomCode = d.justAdmitDetailList.get(i).romCode;
			String tPatfname = d.justAdmitDetailList.get(i).patfname;
			boolean foundDocCode = false;
			for(IPWardDetail w : wardList) {
				if (w.wardCode.equals(tWardCode)) {
					foundDocCode = true;
					w.numCount++;
					w.bedString += ", " + tRomCode + "(" + tPatfname + ")";
					break;
				}
			}
			if (foundDocCode == false) {
				String bedString = " Room: " + tRomCode + "(" + tPatfname + ")";
				IPWardDetail tWard = new IPWardDetail(tWardCode, tWardName, 1, bedString, tRomCode, tPatfname);
				wardList.add(tWard);
			}
		}
		for(IPWardDetail w : wardList) {
			smsContent.append(w.wardName + w.bedString + "\n");
		}

		return smsContent.toString();
	}
	
	private static boolean updateSentLog(JustAdmitDocDetail justAdmitDocDetail) {
		boolean result = false;
		StringBuffer sqlStr = new StringBuffer();
		StringBuffer sqlUpdateStr = new StringBuffer();
		
		String docCode = justAdmitDocDetail.docCode;
		List<String> regids = new ArrayList<String>();
		List<JustAdmitDetail> list = justAdmitDocDetail.justAdmitDetailList;
		for (JustAdmitDetail detail : list) {
			regids.add(detail.regid);
		}
		
		sqlStr.append("select regid, sec_dr1, '1' idx from NX_HANDOVER@CIS ");
		sqlStr.append("where regid in ('"+StringUtils.join(regids, "', '")+"') ");
		sqlStr.append("and sec_dr1 = ? ");
		sqlStr.append("union ");
		sqlStr.append("select regid, sec_dr2, '2' idx from NX_HANDOVER@CIS ");
		sqlStr.append("where regid in ('"+StringUtils.join(regids, "', '")+"') ");
		sqlStr.append("and sec_dr2 = ? ");
		sqlStr.append("union ");
		sqlStr.append("select regid, sec_dr3, '3' idx from NX_HANDOVER@CIS ");
		sqlStr.append("where regid in ('"+StringUtils.join(regids, "', '")+"') ");
		sqlStr.append("and sec_dr3 = ? ");
		sqlStr.append("union ");
		sqlStr.append("select regid, sec_dr4, '4' idx from NX_HANDOVER@CIS ");
		sqlStr.append("where regid in ('"+StringUtils.join(regids, "', '")+"') ");
		sqlStr.append("and sec_dr4 = ? ");
		sqlStr.append("union ");
		sqlStr.append("select regid, sec_dr5, '5' idx from NX_HANDOVER@CIS ");
		sqlStr.append("where regid in ('"+StringUtils.join(regids, "', '")+"') ");
		sqlStr.append("and sec_dr5 = ? ");
		sqlStr.append("union ");
		sqlStr.append("select regid, sec_dr6, '6' idx from NX_HANDOVER@CIS ");
		sqlStr.append("where regid in ('"+StringUtils.join(regids, "', '")+"') ");
		sqlStr.append("and sec_dr6 = ? ");
		sqlStr.append("union ");
		sqlStr.append("select regid, sec_dr7, '7' idx from NX_HANDOVER@CIS ");
		sqlStr.append("where regid in ('"+StringUtils.join(regids, "', '")+"') ");
		sqlStr.append("and sec_dr7 = ? ");
		
		List<ReportableListObject> updateList = UtilDBWeb.getReportableList(sqlStr.toString(), 
				new String[]{docCode,docCode,docCode,docCode,docCode,docCode,docCode});
		
		//logger.debug("updateSentLog sqlStr=" + sqlStr.toString()+", docCode="+docCode+", size=" + updateList.size());	
		
		for (int i = 0; i < updateList.size(); i++) {
			ReportableListObject row = (ReportableListObject) updateList.get(i);
			String rRegid = row.getValue(0);
			String rdocCode = row.getValue(1);
			String docIdx = row.getValue(2);
			
			sqlUpdateStr.setLength(0);
			sqlUpdateStr.append("UPDATE NX_HANDOVER@CIS ");
			sqlUpdateStr.append("set SEC_DR" + docIdx + "_SMS_SENT = 'Y', SEC_DR" + docIdx + "_SMS_DATE = sysdate ");
			sqlUpdateStr.append("WHERE REGID = ? ");
			sqlUpdateStr.append("AND SEC_DR" + docIdx + " = ?");
			
			logger.debug("updateSentLog sqlStr=" + sqlUpdateStr.toString()+", rRegid="+rRegid+", rdocCode="+rdocCode);
			
			result = UtilDBWeb.updateQueue(sqlUpdateStr.toString(), new String[]{rRegid, rdocCode});
		}
		
		return result;
	}

	private static ArrayList getHandOverList() {
		StringBuffer sqlStr = new StringBuffer();	
		sqlStr.append("select ");
		sqlStr.append("  patno,");
		sqlStr.append("  regid,");
		sqlStr.append("  patfname,");
		sqlStr.append("  wrdcode,");
		sqlStr.append("  wrdname,");
		sqlStr.append("  bedcode,");
		sqlStr.append("  romCode,");	
		sqlStr.append("  to_char(sysdate, 'Mon dd @ hh24:mi', 'NLS_DATE_LANGUAGE=AMERICAN') AS CURRDATE, "); 	// 7
		sqlStr.append("  SEC_DR1M,");
		sqlStr.append("  SEC_DR1M_smstel,");
		sqlStr.append("  SEC_DR1M_smstel2,");
		sqlStr.append("  SEC_DR2M,");
		sqlStr.append("  SEC_DR2M_smstel,");
		sqlStr.append("  SEC_DR2M_smstel2,");
		sqlStr.append("  SEC_DR3M,");
		sqlStr.append("  SEC_DR3M_smstel,");
		sqlStr.append("  SEC_DR3M_smstel2,");
		sqlStr.append("  SEC_DR4M,");
		sqlStr.append("  SEC_DR4M_smstel,");
		sqlStr.append("  SEC_DR4M_smstel2,");
		sqlStr.append("  SEC_DR5M,");
		sqlStr.append("  SEC_DR5M_smstel,");
		sqlStr.append("  SEC_DR5M_smstel2,");
		sqlStr.append("  SEC_DR6M,");
		sqlStr.append("  SEC_DR6M_smstel,");
		sqlStr.append("  SEC_DR6M_smstel2,");
		sqlStr.append("  SEC_DR7M,");
		sqlStr.append("  SEC_DR7M_smstel,");
		sqlStr.append("  SEC_DR7M_smstel2");
		sqlStr.append(" FROM SMS_JUST_ADMIT");
	
//		System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	private static boolean getSuccessOfSMS(String msgId) {
		StringBuffer sql_getSuccessStats = new StringBuffer();

		sql_getSuccessStats.append("SELECT SUCCESS ");
		sql_getSuccessStats.append("FROM SMS_LOG ");
		sql_getSuccessStats.append("WHERE MSG_BATCH_ID = '"+msgId+"' ");

		ArrayList record = UtilDBWeb.getReportableList(sql_getSuccessStats.toString());
		ReportableListObject row = null;

		if (record.size() > 0) {
			row = (ReportableListObject)record.get(0);

			return row.getValue(0).equals("1");
		} else {
			return false;
		}			
	}
	
	private static String getDoctorSurName(String docCode) {
		return getDoctorName(docCode, true);
	}
	
	private static String getDoctorName(String docCode, boolean surNameOnly) {
		String docName = "";
		String docFName = null;
		String docGName = null;
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DOCFNAME, DOCGNAME FROM DOCTOR@IWEB WHERE UPPER(DOCCODE) = UPPER('"+docCode+"')");			
		
		ArrayList docList = UtilDBWeb.getReportableList(sqlStr.toString());
		for (int i = 0; i < docList.size(); i++) {
			ReportableListObject row = (ReportableListObject) docList.get(0);
			if (row.getValue(0) != null && row.getValue(0).length() > 0) {
				docFName = row.getValue(0);
				docGName = row.getValue(1);
			}
		}
		
		if (surNameOnly) {
			docName = docFName;
		} else {
			docName = docFName + " " + docGName;	// chinese only
		}
		
		if (StringUtils.isBlank(docName)) {
			docName = docCode;
		}
		
		return docName;
	}
}