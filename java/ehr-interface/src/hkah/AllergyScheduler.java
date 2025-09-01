package hkah;

import hk.gov.ehr.alert.ws.beans.LocalEMRDownloadResponseBean;
import hk.gov.ehr.hepr.ws.Response;
import hk.gov.ehr.saam.transform.ws.AllergyRecordResponse;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.log4j.Logger;
import org.hl7.v3.AllergyDetail;
import org.hl7.v3.AllergyDetail.Allergen;
import org.hl7.v3.AllergyDetail.AllergicReaction;
import org.hl7.v3.Participant;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import test.client.AlertWebServiceClient;
import test.client.DataCollectSaamWebServiceClient;
import test.client.HeprWebServiceClient;

import com.hkah.constant.ConstantsEhr;
import com.hkah.model.db.EhrDataUploadLog;
import com.hkah.util.DateTimeUtil;
import com.hkah.util.EhrUtil;
import com.hkah.util.db.ConnUtil;
@Service()
public class AllergyScheduler {
	protected static Logger logger = Logger.getLogger(AllergyScheduler.class);
	
	private static final String DEFAULT_STARTDT = "01/01/2015";

//  testing : per 10 mins
//	@Scheduled(cron="0 0/10 * * * ?")
//	@Scheduled(fixedRate=60000)	
//	uat :
//	@Scheduled(cron="0 2,17,32,47 * * * ?")	// start every 15 mins for UAT
//  production :    
//	@Scheduled(cron="0 15 2 * * ?")	// start at 2:15am everyday for PROD
	public void adrSchedule(){
		logger.info("Start");
		
        Map<Participant,List<AllergyDetail>> dmMap = new HashMap<Participant,List<AllergyDetail>>();
        Map<Participant,List<AllergyDetail>> incMap = new HashMap<Participant,List<AllergyDetail>>();
        
		try {
			// get Allergy details from
			Date startDate = getLastEndDate();
			if (startDate == null) {
				startDate = DateTimeUtil.parseDate(DEFAULT_STARTDT);
			}
			Date endDate = new Date();
			String startDateStr = DateTimeUtil.formatDateTime(startDate);
			String startEndStr = DateTimeUtil.formatDateTime(endDate);
			
			logger.info("Get record period: " + startDateStr + " - " +  startEndStr);
			
			// get patient keys
			List<PatientInfo> patInfos = getUpdatedAllergyPatnos(startDateStr, startEndStr);
			List<PatientInfo> patDMInfos = new ArrayList<PatientInfo>();
			List<PatientInfo> patINCInfos = new ArrayList<PatientInfo>();
			
			logger.info("Active modified allergy patient list size: " + patInfos.size());
			
			for (int i = 0; i < patInfos.size(); i++) {
				String patno = patInfos.get(i).getPatNo();
				String ehrNo = patInfos.get(i).getEhrNo();

				AllergyRecordResponse algRes;				
				if("INC".equals(checkPatUpdateMode(patInfos.get(i).getInitAlg()))){
					algRes = getAllergyData(patno, startDate, endDate, "INC");
				} else {
					algRes = getAllergyData(patno, null, null, "DM");
				}
				
				List<AllergyDetail> algList =  algRes.getAllergyDetail();
				logger.debug("Patno: " + patno + ", eHR no: " + ehrNo + " (mode:" + checkPatUpdateMode(patInfos.get(i).getInitAlg()) + ", startDate: " + startDate + ", endDate: " + endDate + ") Return size: " + algList.size() + ", ws response: " + algRes.getResponse().getResponseCode() +
						" - " + algRes.getResponse().getResponseMessage());
				
				/*
				for (AllergyDetail alg : algList) {
					String episodeNo = alg.getEpisodeNo();
					String recordKey = alg.getRecordKey();
					String recordUpdateDtm = alg.getRecordUpdateDtm();
					String algNote = alg.getAllergyNote();
					String alnRemark = alg.getAllergenRemark();
					Allergen aln = alg.getAllergen();
					List<AllergicReaction> algRecs = alg.getAllergicReaction();
					
					String alnLtCode = aln.getAllergenLtCode();
					int algRecsSize = algRecs.size();
					
					logger.debug(" [ALG Record]:");
					logger.debug("    episodeNo =" + episodeNo + ", recordKey="+recordKey+", recordUpdateDtm="+recordUpdateDtm);
					logger.debug("    alnLtCode =" +alnLtCode + ", algNote="+algNote+", alnRemark="+alnRemark+", algRecsSize="+algRecsSize);
				}
				*/
				if (!algList.isEmpty()) {
					if("INC".equals(checkPatUpdateMode(patInfos.get(i).getInitAlg()))){
						incMap.put(participant(patno), algList);			
						patINCInfos.add(patInfos.get(i));
					} else {
						dmMap.put(participant(patno), algList);
						patDMInfos.add(patInfos.get(i));
					}
				}
			}
			
			// upload to eHR
			uploadToEhr(dmMap, "DM", patDMInfos, null, null);
			Thread.sleep(1000);	// wait for 1 sec to avoid duplicate folder ID
			uploadToEhr(incMap, "INC", patINCInfos, startDate, endDate);
			
			// store endDate
			saveLastEndDate(DateTimeUtil.formatDBTimestamp(endDate));
        } catch (Exception e) {
            logger.error("Error: " + e.getMessage());
            e.printStackTrace();
        }
		
		logger.info("End");
	}
	
	//@Scheduled(fixedDelay=60000)
	public void testGetAllergyDataByPatno() {
		logger.info("[testGetAllergyDataByPatno]");
		String uploadMode = "DM";
		List<String> patnos = new ArrayList<String>();
		//patnos.add("405111");
		//patnos.add("4028800052f269df015307f648f80002");
		//patnos.add("470311");
		//patnos.add("40288000523f2d340152592ff8fd0050");
		
		
		for (String patno : patnos) {
			listAllergyDataByPatno(patno, uploadMode);
		}
	}
	
	public void listAllergyDataByPatno(String patno, String uploadMode) {
		logger.info("[listAllergyDataByPatno]" + "patno="+patno+", uploadMode="+uploadMode);
		
		List<AllergyDetail> algList = getAllergyDataByPatno(patno, uploadMode);
		
		logger.debug(" algList size="+algList.size());
		for (AllergyDetail alg : algList) {
			String episodeNo = alg.getEpisodeNo();
			String recordKey = alg.getRecordKey();
			String recordUpdateDtm = alg.getRecordUpdateDtm();
			String algNote = alg.getAllergyNote();
			String alnRemark = alg.getAllergenRemark();
			Allergen aln = alg.getAllergen();
			List<AllergicReaction> algRecs = alg.getAllergicReaction();
			
			String alnLtCode = aln.getAllergenLtCode();
			int algRecsSize = algRecs.size();
			
			logger.info(" [ALG Record]:");
			logger.info("    episodeNo =" + episodeNo + ", recordKey="+recordKey+", recordUpdateDtm="+recordUpdateDtm);
			logger.info("    alnLtCode =" +alnLtCode + ", algNote="+algNote+", alnRemark="+alnRemark+", algRecsSize="+algRecsSize);
		}
	}
	
	public List<AllergyDetail> getAllergyDataByPatno(String patno, String uploadMode){
		AllergyRecordResponse algRes;				
		algRes = getAllergyData(patno, null, null, uploadMode);
		List<AllergyDetail> algList =  algRes.getAllergyDetail();
		
		logger.debug(" Return size: " + algList.size() + ", ws response: " + algRes.getResponse().getResponseCode() +
				" - " + algRes.getResponse().getResponseMessage());
		
		return algList;
	}
	
	private AllergyRecordResponse getAllergyData(String patno, Date startDate, Date endDate, String uploadMode) {
		ApplicationContext context = new ClassPathXmlApplicationContext("ClientContext.xml");
		DataCollectSaamWebServiceClient dataCollectSaamWebServiceClient = (DataCollectSaamWebServiceClient) context.getBean("dataCollectSaamWebServiceClient");
		return dataCollectSaamWebServiceClient.collectAllergyRecord(patno, startDate, endDate, uploadMode);
	}
	
	private void uploadToEhr(Map<Participant,List<AllergyDetail>> map, String mode, 
			List<PatientInfo> patInfos, Date startDate, Date endDate){
		logger.debug("Upload to eHR mode: " + mode + " , no. of participant: " + map.size());
		Set<Participant> keys = map.keySet();
		Iterator<Participant> itr = keys.iterator();
		while (itr.hasNext()) {
			Participant p = itr.next();
			if (p != null) {
				List<AllergyDetail> list = map.get(p);
				int listSize = (list != null ? list.size() : 0);
				logger.debug("  Patno: " + p.getPatientKey() + " (eHR No.: " + p.getEhrNo() + "), list size: " + listSize);
			}
		}
		
		ApplicationContext context = new ClassPathXmlApplicationContext("ClientContext.xml");
		
		if (!map.isEmpty()) {
			Date uploadDate = new Date();
			String uploadMode = "";
			if ("DM".equals(mode)){
				uploadMode = "BL-M";
			} else {
				uploadMode = "BL";
			}
	        HeprWebServiceClient wsClient = (HeprWebServiceClient) context.getBean("HeprWebServiceClient");
	        Response msg = wsClient.uploadAllergyData(map, uploadMode);
	        
	        /*
	        // TEST response
	        System.out.println("--TEST response--");
	        Response msg = new Response();
	        msg.setResponseCode("00001");
	        msg.setResponseMessage("[TESTING] Success (with error)");
	        for (PatientInfo p : patInfos) {
	        	RecordDetail rd = new RecordDetail();
	        	rd.setEhrNo(p.getEhrNo());
	        	rd.setPatientKey(p.getPatNo());
	        	// random set exception
	        	boolean isExc = (new Random((new Date()).getTime())).nextBoolean();
	        	rd.setExceptionType(isExc ? "e" : "");
	        	rd.setExceptionDescription(isExc ? "Exception" : "No exception");
	        	msg.getRecordDetail().add(rd);
	        }
	        // TEST response end
	         */
	        
	        logger.debug(mode + " upload finish, response:" + msg.getResponseCode() + " - " + msg.getResponseMessage());
	        ArrayList<String> patErrorList = new ArrayList<String>();
	        for(int i = 0; i < msg.getRecordDetail().size(); i++){
	        	logger.debug(mode + " exception (" + msg.getRecordDetail().get(i).getExceptionType() + "): Patno = " + msg.getRecordDetail().get(i).getPatientKey() + " Desc = " + msg.getRecordDetail().get(i).getExceptionDescription());
	        	if("e".equals(msg.getRecordDetail().get(i).getExceptionType().toLowerCase())){
	        		patErrorList.add(msg.getRecordDetail().get(i).getPatientKey());
	        	}
	        }    
	        
	        // log upload
	        updateDataUploadLog(patInfos, patErrorList, uploadDate, startDate, endDate, mode);
	        
	        // update patient initalg
	        if ("DM".equals(mode)) {
		        if(msg.getResponseCode().equals("00000") || msg.getResponseCode().equals("00001") || msg.getResponseCode().equals("00002")){
		        	logger.debug(mode + " Update Patient initAlg");
		            for (int i = 0; i < patInfos.size(); i++) {
		            	boolean uploadPatInitAlg = true;
		            	for( String ePatNo : patErrorList){
		            		if(ePatNo.equals(patInfos.get(i).getPatNo())){
		            			uploadPatInitAlg = false;
		            		}
		            	}
		            	
		            	if(uploadPatInitAlg == true) {
		            		updatePatInitAlg(patInfos.get(i).getPatNo());
		            	}
		            }
		        }
	        }
		}
	}
	
	//@Scheduled(cron="0 0 8 * * ?") 	// 8:00am everyday
	public void retryFailedUploadSchedule(){
		logger.info("Retry failed upload");
		try {
			retryFailedUploads(ConstantsEhr.DOMAIN_CODE_ALLERGY);
        } catch (Exception e) {
        	logger.error("Error: " + e.getMessage());
            e.printStackTrace();
        }
	}
	
	private void retryFailedUploads(String domainCode) {
		logger.info("upload mode (retry): " + domainCode);
		
		List<EhrDataUploadLog> retryLogList = getLatestFailedUploads(domainCode);
		for (EhrDataUploadLog retryLog : retryLogList) {
			logger.debug("[id:" + retryLog.getId() + ", patno:" + retryLog.getPatno() + ", ehrno:" + retryLog.getEhrNo() + ", getStartDate:" + retryLog.getStartDate() + ", getEndDate:" + retryLog.getEndDate() + ", getUploadMode:" + retryLog.getUploadMode());
			
			List<PatientInfo> patInfos = new ArrayList<PatientInfo>();
			Map<Participant,List<AllergyDetail>> map = new HashMap<Participant,List<AllergyDetail>>();
			
			AllergyRecordResponse algRes = getAllergyData(retryLog.getPatno(), retryLog.getStartDate(), retryLog.getEndDate(), retryLog.getUploadMode());
			List<AllergyDetail> algList =  algRes.getAllergyDetail();
			logger.debug(" Return size: " + algList.size() + ", ws response: " + algRes.getResponse().getResponseCode() +
					" - " + algRes.getResponse().getResponseMessage());
			
			if (!algList.isEmpty()) {
				map.put(participant(retryLog.getPatno()), algList);			
				patInfos.add(new PatientInfo(retryLog.getPatno(), retryLog.getEhrNo(), null));
				
				uploadToEhr(map, retryLog.getUploadMode(), patInfos, retryLog.getStartDate(), retryLog.getEndDate());
			}
		}
	}
	
	private List<EhrDataUploadLog> getLatestFailedUploads(String domainCode) {
		PreparedStatement ps = null;
		Connection conn = null;
	    ResultSet rs = null;
	    StringBuffer sqlBuffer = new StringBuffer();
	    List<EhrDataUploadLog> uploadDataLog = new ArrayList<EhrDataUploadLog>();
			
		try {
			// if initalg > sysdate, do not upload even if ehr is active
			sqlBuffer.append("select id, domain_code, ehr_no, patno, to_char(start_date, 'dd/mm/yyyy hh24:mi:ss'), to_char(end_date, 'dd/mm/yyyy hh24:mi:ss'), upload_mode, success ");
			sqlBuffer.append("from ( ");
			sqlBuffer.append("select max(id) id, domain_code, ehr_no, patno, start_date, end_date, upload_mode, max(success) success ");
			sqlBuffer.append("from EHR_DATA_UPLOAD_LOG ");
			sqlBuffer.append("where domain_code = ? ");
			sqlBuffer.append("group by domain_code, ehr_no, patno, start_date, end_date, upload_mode ");
			sqlBuffer.append(") ");
			sqlBuffer.append("where success = ? ");
			sqlBuffer.append("order by id");
			conn = ConnUtil.getDataSourceHATS().getConnection();
			ps = conn.prepareStatement(sqlBuffer.toString());
			ps.setString(1, domainCode);
			ps.setString(2, "N");
			rs = ps.executeQuery();
			
			while (rs.next()) {
				uploadDataLog.add(new EhrDataUploadLog(
						rs.getString(1), 
						rs.getString(2), 
						null,
						rs.getString(3),
						rs.getString(4),
						DateTimeUtil.parseDateTime(rs.getString(5)),
						DateTimeUtil.parseDateTime(rs.getString(6)),
						rs.getString(7),
						rs.getString(8)));
			}
		} catch (Exception e) {
            logger.error("getLatestFailedUploads Error");
            e.printStackTrace();
        } finally {
        	try {
        		if (rs != null)
        			rs.close();
        		
        		if (ps != null)
        			ps.close();
        		
        		ConnUtil.closeConnection(conn);
        	} catch(Exception e) {
                logger.error("getLatestFailedUploads Cannot close connection");
                e.printStackTrace();
        	}
        }		
		return uploadDataLog;
	}

	private void updateDataUploadLog(List<PatientInfo> patInfos, List<String> patErrorList, Date uploadDate, 
			Date startDate, Date endDate, String mode) {
		logger.debug("updateDataUploadLog mode: " + mode);
		
		PreparedStatement ps = null;
        ResultSet rs = null;
        Connection conn = null;
        String sql;
        int[] retCounts = new int[patInfos.size()];
        List<String> batchPatnos = new ArrayList<String>();
		try {
			sql = "insert into EHR_DATA_UPLOAD_LOG(ID, DOMAIN_CODE, UPLOAD_DATE, EHR_NO, PATNO, START_DATE, END_DATE, UPLOAD_MODE, SUCCESS) " +
					"values(SEQ_EHR_DATA_UPLOAD_LOG.NEXTVAL, ?, TO_DATE(?, 'dd/mm/yyyy HH24:mi:ss'), ?, ?, TO_DATE(?, 'dd/mm/yyyy HH24:mi:ss'), TO_DATE(?, 'dd/mm/yyyy HH24:mi:ss'), ?, ?)";
			conn = ConnUtil.getDataSourceHATS().getConnection();
        	ps = conn.prepareStatement(sql);
			
			for (PatientInfo pInfo : patInfos) {
				int i = 1;
				ps.setString(i++, ConstantsEhr.DOMAIN_CODE_ALLERGY);
				ps.setString(i++, DateTimeUtil.formatDateTime(uploadDate));
				ps.setString(i++, pInfo.getEhrNo());
				ps.setString(i++, pInfo.getPatNo());
				ps.setString(i++, startDate == null ? null : DateTimeUtil.formatDateTime(startDate));
				ps.setString(i++, DateTimeUtil.formatDateTime(endDate));
				ps.setString(i++, mode);
				ps.setString(i++, patErrorList.contains(pInfo.getPatNo()) ? "N" : "Y");
				ps.addBatch();
				
				batchPatnos.add(pInfo.getPatNo());
			}
			retCounts = ps.executeBatch();
			for (int i = 0; i < retCounts.length; i++) {
				if (retCounts[i] == 0) {
					logger.debug("cannot insert upload log " + retCounts[i] + ", patno: " + batchPatnos.get(i));
				} else {
					logger.debug("insert upload log (ret:" + retCounts[i] + "), patno: " + batchPatnos.get(i));
				}
			}
			
		} catch (Exception e) {
            logger.error("updateDataUploadLog Error");
            e.printStackTrace();
        } finally {
        	try {
        		if (rs != null)
        			rs.close();
        		
        		if (ps != null)
        			ps.close();
        		
        		ConnUtil.closeConnection(conn);
        	} catch(Exception e) {
                logger.error("updateDataUploadLog Cannot close connection");
                e.printStackTrace();
        	}
        }		
	}
	
	private void updatePatInitAlg(String patno) {
		logger.info("Set init upload flag (initAlg) on, patno="+patno);
		
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection conn = null;
        String sql;
		try {
			sql = "update ehr_pmi set initAlg = SYSDATE where patno = '" + patno + "'";
			conn = ConnUtil.getDataSourceHATS().getConnection();
        	ps = conn.prepareStatement(sql);		
			rs = ps.executeQuery();
		} catch (Exception e) {
            logger.error("UpdatePatInitAlg Error");
            e.printStackTrace();
        } finally {
        	try {
        		if (rs != null)
        			rs.close();
        		
        		if (ps != null)
        			ps.close();
        		
        		ConnUtil.closeConnection(conn);
        	} catch(Exception e) {
                logger.error("UpdatePatInitAlg Cannot close connection");
                e.printStackTrace();
        	}
        }		
	}
	
	private List<PatientInfo> getEhrActivePatnos() {
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection conn = null;
        String sql;
        List<PatientInfo> patInfos = new ArrayList<PatientInfo>();
		
		try {
			// if initalg > sysdate, do not upload even if ehr is active
			sql = "select patno, ehrno, initalg from ehr_pmi where active = -1 and (initalg < sysdate or initalg is null) order by patno";
			conn = ConnUtil.getDataSourceHATS().getConnection();
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			
			while (rs.next()) {
				patInfos.add(new PatientInfo(rs.getString(1), rs.getString(2), rs.getString(3)));
			}
		} catch (Exception e) {
            logger.error("getEhrActivePatnos Error");
            e.printStackTrace();
        } finally {
        	try {
        		if (rs != null)
        			rs.close();
        		
        		if (ps != null)
        			ps.close();
        		
        		ConnUtil.closeConnection(conn);
        	} catch(Exception e) {
                logger.error("getEhrActivePatnos Cannot close connection");
                e.printStackTrace();
        	}
        }		
		return patInfos;
	}	
	
	private List<PatientInfo> getUpdatedAllergyPatnos(String startDateStr, String endDateStr) {
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection conn = null;
        List<PatientInfo> patInfos = new ArrayList<PatientInfo>();
		
		try {
			// if initalg > sysdate, do not upload even if ehr is active
			StringBuffer sqlStr = new StringBuffer();
			// DM
			sqlStr.append("select distinct ");
			sqlStr.append("    pm.patno, ");
			sqlStr.append("    pm.ehrno, ");
			sqlStr.append("    pm.initalg ");
			sqlStr.append("from sa_patient_allergy_log@ehr pl  ");
			sqlStr.append("    join sa_patient@ehr pt on pt.patient_key = pl.patient_key ");
			sqlStr.append("    join ehr_pmi@hat pm on pt.patient_ref_key = pm.patno ");
			sqlStr.append("where ");
			sqlStr.append("    pm.active = -1 ");
			sqlStr.append("    and pm.initalg is null ");
			// only check 2 days after build consent
			sqlStr.append("    and sysdate < (select max(createdate) from ehr_pmihist@hat where patno = pm.patno and ehreventcode = 'A28') + 2 ");
			sqlStr.append(" union ");
			// INC
			sqlStr.append("select distinct ");
			sqlStr.append("    pm.patno, ");
			sqlStr.append("    pm.ehrno, ");
			sqlStr.append("    pm.initalg ");
			sqlStr.append("from sa_patient_allergy_log@ehr pl  ");
			sqlStr.append("    join sa_patient@ehr pt on pt.patient_key = pl.patient_key ");
			sqlStr.append("    join ehr_pmi@hat pm on pt.patient_ref_key = pm.patno ");
			sqlStr.append("where 1=1 ");
			if (startDateStr != null && !startDateStr.isEmpty()) {
				sqlStr.append("  	and update_dtm >= to_date(?, 'dd/MM/yyyy HH24:mi:ss') ");
			}
			if (endDateStr != null && !endDateStr.isEmpty()) {
				sqlStr.append("  	and update_dtm <= to_date(?, 'dd/MM/yyyy HH24:mi:ss') ");
			}
			sqlStr.append("    and pm.active = -1 ");
			sqlStr.append("    and pm.initalg is not null ");
			
			conn = ConnUtil.getDataSourceCIS().getConnection();
			ps = conn.prepareStatement(sqlStr.toString());
			int i = 1;
			if (startDateStr != null && !startDateStr.isEmpty()) {
				ps.setString(i++, startDateStr);
			}
			if (endDateStr != null && !endDateStr.isEmpty()) {
				ps.setString(i++, endDateStr);
			}
			rs = ps.executeQuery();
			
			logger.debug("Get updated allergy period: " + startDateStr + " to " + endDateStr + ", sql="+sqlStr.toString());
			
			while (rs.next()) {
				patInfos.add(new PatientInfo(rs.getString(1), rs.getString(2), rs.getString(3)));
			}
		} catch (Exception e) {
            logger.error("getUpdatedAllergyPatnos Error:" + e.getMessage());
            e.printStackTrace();
        } finally {
        	try {
        		if (rs != null)
        			rs.close();
        		
        		if (ps != null)
        			ps.close();
        		
        		ConnUtil.closeConnection(conn);
        	} catch(Exception e) {
                logger.error("getUpdatedAllergyPatnos Cannot close connection");
                e.printStackTrace();
        	}
        }		
		return patInfos;
	}	
	
	private Date getLastEndDate() {
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection conn = null;
        String sql;
        Date lastEndDate = null;
		
		try {
			sql = "select param1 from sysparam where parcde = 'EHRUL_ALG'";
			conn = ConnUtil.getDataSourceHATS().getConnection();
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			
			if (rs.next()) {
				lastEndDate = DateTimeUtil.parseDBTimestamp(rs.getString(1));
			}
		} catch (Exception e) {
            logger.error("getEhrActivePatnos Error");
            e.printStackTrace();
        } finally {
        	try {
        		if (rs != null)
        			rs.close();
        		
        		if (ps != null)
        			ps.close();
        		
        		ConnUtil.closeConnection(conn);
        	} catch(Exception e) {
                logger.error("getEhrActivePatnos Cannot close connection");
                e.printStackTrace();
        	}
        }		
		return lastEndDate;
	}	
	
	private void saveLastEndDate(String dbDateStr) {
		logger.info("Update EndDate (EHRUL_ALG): " + dbDateStr);
		
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection conn = null;
        String sql;
		
		try {
			sql = "update sysparam set param1 = ? where parcde = 'EHRUL_ALG'";
			conn = ConnUtil.getDataSourceHATS().getConnection();
			ps = conn.prepareStatement(sql);
			ps.setString(1, dbDateStr);
			rs = ps.executeQuery();
		} catch (Exception e) {
            logger.error("saveLastEndDate Error");
            e.printStackTrace();
        } finally {
        	try {
        		if (rs != null)
        			rs.close();
        		
        		if (ps != null)
        			ps.close();
        		
        		ConnUtil.closeConnection(conn);
        	} catch(Exception e) {
                logger.error("saveLastEndDate Cannot close connection");
                e.printStackTrace();
        	}
        }		
	}	
	
	private String checkPatUpdateMode(String initAlg){
		String updateMode;
		if(initAlg != null && initAlg.length() > 0){
			updateMode = "INC";
		} else {
			updateMode = "DM";
		}
		
		return updateMode;		
	}
	
	private Participant participant(String patno){		
		logger.debug("[Create Participant]");
		Participant p = new Participant();		
       
        PreparedStatement ps_hats = null;      
        ResultSet rs_hats = null;
        Connection conn = null;
        
        String sql;
        String sex;
        String birthdate;
        String ehrno;
        String hkid;
        String ehrfname;
        String ehrgname;
        String fullname;
        String doctype;
        String ehrdocno;
        
		try {
			sql = "select ehrno, ehrsex, to_char(ehrdob, 'yyyy-mm-dd hh24:mi:ss')||'.000' as birth_date, ehrfname, ehrgname, ehrfname || ', ' || ehrgname as fullname, ehrhkid, ehrdocno, ehrdoctype from ehr_pmi where patno = ? and active = -1" ;
			conn = ConnUtil.getDataSourceHATS().getConnection();
			ps_hats = conn.prepareStatement(sql);
        	ps_hats.setString(1, patno);
        	rs_hats = ps_hats.executeQuery();
			
        	if (!rs_hats.next()) {
        		return null;
        	} else {
            	//patno = rs.getString("hospnum");            	    	
            	ehrno = rs_hats.getString("ehrno") ;
            	birthdate = rs_hats.getString("birth_date");
            	sex = rs_hats.getString("ehrsex");       
            	hkid = rs_hats.getString("ehrhkid");
            	doctype = rs_hats.getString("ehrdoctype");
            	ehrdocno = rs_hats.getString("ehrdocno");
            	ehrfname = rs_hats.getString("ehrfname");
            	ehrgname = rs_hats.getString("ehrgname");
             	fullname = EhrUtil.convertToEngFullName(ehrfname, ehrgname);
                        					
				p.setEhrNo(ehrno);
				p.setBirthDate(birthdate);
				p.setSex(sex);
				p.setPatientKey(patno);
				p.setHkid(hkid);
				p.setDocType(doctype);
				p.setDocNo(ehrdocno);
				p.setPersonEngGivenName(ehrgname);
				p.setPersonEngSurname(ehrfname);
				p.setPersonEngFullName(fullname);
								
				logger.debug("participant: patno =" + patno + ", ehrno="+ehrno+", birthdate="+birthdate + ", ehrfname="+ehrfname+", ehrgname="+ehrgname+", sex =" +sex + ", hkid="+hkid+", doctype="+doctype+", ehrdocno="+ehrdocno+", fullname="+fullname);
        	}        	                                    
        } catch (Exception e) {
            logger.error("Participant Error, patno:" + patno);
            e.printStackTrace();
            
        } finally {
        	try {        		
        		if (rs_hats != null)
        			rs_hats.close();
        		
        		if (ps_hats != null)
        			ps_hats.close();
        		
        		ConnUtil.closeConnection(conn);
        	} catch(Exception e) {
                logger.error("Cannot close connection");
                e.printStackTrace();
        	}
        }
        
        return p; 
	}
	
	private class PatientInfo{
		private String patNo;
		private String ehrNo;
		private boolean uploadSuccess;
		private String initAlg;
		
		public PatientInfo(String patNo, String ehrNo, String initAlg) {
			super();
			this.patNo = patNo;
			this.ehrNo = ehrNo;
			this.initAlg = initAlg;
		}
		
		public String getPatNo() {
			return patNo;
		}		
		public String getInitAlg() {
			return initAlg;
		}

		public String getEhrNo() {
			return ehrNo;
		}

		public void setEhrNo(String ehrNo) {
			this.ehrNo = ehrNo;
		}

		public boolean isUploadSuccess() {
			return uploadSuccess;
		}

		public void setUploadSuccess(boolean uploadSuccess) {
			this.uploadSuccess = uploadSuccess;
		}	
	}
	
	//== Download ==
	public void download(String patno, String userId) {
		// logger.debug("Download allergy and ADR [patno=" + patno + ", userId=" + userId + "] Start");
		LocalEMRDownloadResponseBean downloadRes = getDownloadResponse(patno, userId);
		if (!"70000".equals(downloadRes.getResponseCode())) {
			logger.debug("Download allergy and ADR [patno=" + patno + ", userId=" + userId + "], Rsponse[" + downloadRes.getResponseCode() + " - " + downloadRes.getResponseMessage() + "]");	
		}
	}
	
	private LocalEMRDownloadResponseBean getDownloadResponse(String patno, String userId) {
		ApplicationContext context = new ClassPathXmlApplicationContext("ClientContext.xml");
		AlertWebServiceClient alertWebServiceClient = (AlertWebServiceClient) context.getBean("alertWebServiceClient");
		return alertWebServiceClient.downloadAdrAllergy(patno, userId);
	}
	
//  testing :
//	@Scheduled(fixedRate=60000)	
//	uat :
//	@Scheduled(cron="0 0 8 * * ?")	// UAT HA open port between 0800-2000
//  production : --   	// PRODUCTION not scheduled to run
	public void downloadSchedule(){
		logger.info("[downloadSchedule] Start");
		
		// get patient keys
		List<PatientInfo> patInfos = getEhrActivePatnos();
		logger.info("Active patient list size: " + patInfos.size());
		
		for (int i = 0; i < patInfos.size(); i++) {
			String patno = patInfos.get(i).getPatNo();
			download(patno, "SYSTEM");
			
		}
		
		// batch send email
		
		logger.info("[downloadSchedule] End");
	}
	
	//@Scheduled(fixedRate=100000)
	public void testDownloadAlert(){
		System.out.println("== testDownloadAlert ==");
		String patno = "511856";	// hkah-sr uat success
		//String patno = "222222";	// hkah-sr uat inactive ehr_pmi
		//String patno = "223344";	// hkah-sr uat inactive ehr_pmi ehrno is not null
		String userId = "SYSTEM";
		download(patno, userId);
	}
}