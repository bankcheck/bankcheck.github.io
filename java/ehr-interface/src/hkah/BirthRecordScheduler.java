package hkah;

import hk.gov.ehr.hepr.ws.Response;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.log4j.Logger;
import org.hl7.v3.BirthDetail;
import org.hl7.v3.Participant;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import test.client.HeprWebServiceClient;

import com.hkah.constant.ConstantsEhr;
import com.hkah.ehr.service.BirthRecordService;
import com.hkah.ehr.service.DomainCommonService;
import com.hkah.model.db.EhrDataUploadLog;
import com.hkah.util.DateTimeUtil;
import com.hkah.util.EhrUtil;
import com.hkah.util.db.ConnUtil;
@Service()
public class BirthRecordScheduler {
	protected static Logger logger = Logger.getLogger(BirthRecordScheduler.class);
	
	private static final String DEFAULT_STARTDT = "13/03/2016";

	//@Scheduled(fixedDelay=6000000)
	public void testUploadEmptyBatch() {
		// Test upload empty batch
		logger.info("Test Start");
		
		ApplicationContext context = new ClassPathXmlApplicationContext("ClientContext.xml");
        HeprWebServiceClient wsClient = (HeprWebServiceClient) context.getBean("HeprWebServiceClient");
        
        Date currentDate = new Date();
        String uploadMode = ConstantsEhr.UPLOAD_MODE_NAME_BLM;
        Participant p = participant("455737");
        BirthDetail detail = new BirthDetail();
        String recordKey = String.valueOf(currentDate.getTime());
        detail.setRecordKey(recordKey);
        detail.setTransactionDtm(DateTimeUtil.formatEhrDateTime(currentDate));	// YYYY-MM-DD hh:mm:ss.sss
        detail.setTransactionType("I");
        
        Map<Participant,BirthDetail> list = new HashMap<Participant,BirthDetail>();
        list.put(p, detail);
        Response msg = wsClient.uploadBirthData(list, uploadMode);
        
        System.out.println("msg:" + msg.getResponseCode() + " - " + msg.getResponseMessage());
	}
	
	
//  testing : per 10 mins
//	@Scheduled(cron="0 0/10 * * * ?")
//	@Scheduled(fixedRate=60000)	
//	uat :
//	@Scheduled(cron="0 4,19,34,49 * * * ?")	// UAT start every 15 mins for UAT
//  production :    
//	@Scheduled(cron="0 45 2 * * ?")	// PROD start at 2:45am everyday
	public void schedule(){
		logger.info("BirthRecordScheduler Start");
		
		ApplicationContext context = new ClassPathXmlApplicationContext("ClientContext.xml");
		BirthRecordService birthRecordService = (BirthRecordService) context.getBean("birthRecordService");
		
        Map<Participant, BirthDetail> dmMap = null;
        //Map<Participant, BirthDetail> incMap = new HashMap<Participant, BirthDetail>();
        
		try {
			// get Birth record from
			Date startDate = getLastEndDate();
			if (startDate == null) {
				startDate = DateTimeUtil.parseDate(DEFAULT_STARTDT);
			}
			Date endDate = new Date();
			
			logger.info("Get record period: " + DateTimeUtil.formatDateTime(startDate) + 
					" - " +  DateTimeUtil.formatDateTime(endDate));
			
			dmMap = birthRecordService.getReadyToUploadBirthDetail(ConstantsEhr.UPLOAD_MODE_CODE_BLM);
			
			// debug
			//listPatientBirthDetails(dmMap);
			
			// upload to eHR
			uploadToEhr(dmMap, ConstantsEhr.UPLOAD_MODE_CODE_BLM, null, null);
			
			// No need to run update and delete mode
			/*
			 * Thread.sleep(1000);
			uploadToEhr(incMap, ConstantsEhr.UPLOAD_MODE_CODE_BL, null, null);
			*/
			
			// store endDate
			saveLastEndDate(DateTimeUtil.formatDBTimestamp(endDate));
        } catch (Exception e) {
            logger.error("Error: " + e.getMessage());
            e.printStackTrace();
        }
		
		logger.info("End");
	}
	
	private void uploadToEhr(Map<Participant, BirthDetail> map, String mode, Date startDate, Date endDate){
		logger.info("Upload to eHR mode: " + mode + " , no. of participant: " + map.size());
		
		ApplicationContext context = new ClassPathXmlApplicationContext("ClientContext.xml");
		Date c = new Date();
		
		if (!map.isEmpty()) {
			Date uploadDate = new Date();
			String uploadMode = "";
			if (ConstantsEhr.UPLOAD_MODE_CODE_BLM.equals(mode)){
				uploadMode = ConstantsEhr.UPLOAD_MODE_NAME_BLM;
			} else {
				uploadMode = ConstantsEhr.UPLOAD_MODE_NAME_BL;
			}
	        HeprWebServiceClient wsClient = (HeprWebServiceClient) context.getBean("HeprWebServiceClient");
	        Response msg = wsClient.uploadBirthData(map, uploadMode);
	        boolean isSuccess = ConstantsEhr.UPLOAD_SUCCESS_CODES.containsKey(msg.getResponseCode());
	        List<PatientInfo> patInfos = new ArrayList<PatientInfo>();
	        
	        logger.debug(mode + " upload finish, response:" + msg.getResponseCode() + " - " + msg.getResponseMessage());
	        ArrayList<String> patErrorList = new ArrayList<String>();
	        // BIRTH may not return recordDetail in soap body
	        if (!msg.getRecordDetail().isEmpty()) {
		        for(int i = 0; i < msg.getRecordDetail().size(); i++){
		        	String patno = msg.getRecordDetail().get(i).getPatientKey();
		        	patInfos.add(new PatientInfo(patno, msg.getRecordDetail().get(i).getEhrNo(), null));
		        	
		        	logger.debug(mode + " exception (" + msg.getRecordDetail().get(i).getExceptionType() + "): Patno = " + patno + " Desc = " + msg.getRecordDetail().get(i).getExceptionDescription());
		        	if("e".equals(msg.getRecordDetail().get(i).getExceptionType().toLowerCase())){
		        		patErrorList.add(patno);
		        	}
		        }    
	        } else {
                for (Entry<Participant, BirthDetail> entry : map.entrySet()) {
                    Participant p = entry.getKey();
                    BirthDetail detail = entry.getValue();
                    PatientInfo patientInfo = new PatientInfo(p.getPatientKey(), p.getEhrNo(), null);
                    patInfos.add(patientInfo);
                    
                    if (!isSuccess) {
                    	patErrorList.add(p.getPatientKey());
                    }
		        }    
	        }
	        
	        // log upload
	        updateDataUploadLog(patInfos, patErrorList, uploadDate, startDate, endDate, mode);
	        
	        // update patient initBirth
	        if (ConstantsEhr.UPLOAD_MODE_CODE_BLM.equals(mode)) {
	        	if (isSuccess) {
		        	logger.debug(mode + " Update Patient initBirth");
		            for (int i = 0; i < patInfos.size(); i++) {
		            	boolean uploadPatInitBirth = true;
		            	// check if uplaod success
		            	for( String ePatNo : patErrorList){
		            		if(ePatNo.equals(patInfos.get(i).getPatNo())){
		            			uploadPatInitBirth = false;
		            		}
		            	}
		            	
		            	if(uploadPatInitBirth == true) {
		            		updatePatInitBirth(patInfos.get(i).getPatNo());
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
			retryFailedUploads(ConstantsEhr.DOMAIN_CODE_BIRTH);
        } catch (Exception e) {
        	logger.error("Error: " + e.getMessage());
            e.printStackTrace();
        }
	}
	
	private void retryFailedUploads(String domainCode) {
		logger.info("upload mode (retry): " + domainCode);
		
		ApplicationContext context = new ClassPathXmlApplicationContext("ClientContext.xml");
		DomainCommonService domainCommonService = (DomainCommonService) context.getBean("domainCommonService");
		BirthRecordService birthRecordService = (BirthRecordService) context.getBean("birthRecordService");
		
		List<EhrDataUploadLog> retryLogList = domainCommonService.getLatestFailedUploads(domainCode);
		for (EhrDataUploadLog retryLog : retryLogList) {
			logger.debug("[domainCode:" + domainCode + ", id:" + retryLog.getId() + ", patno:" + retryLog.getPatno() + ", ehrno:" + retryLog.getEhrNo() + ", getStartDate:" + retryLog.getStartDate() + ", getEndDate:" + retryLog.getEndDate() + ", getUploadMode:" + retryLog.getUploadMode());
			
			List<PatientInfo> patInfos = new ArrayList<PatientInfo>();
			Map<Participant, BirthDetail> map = birthRecordService.getReadyToUploadBirthDetail(retryLog.getPatno(), retryLog.getUploadMode());
			if (!map.isEmpty()) {
				patInfos.add(new PatientInfo(retryLog.getPatno(), retryLog.getEhrNo(), null));
				
				uploadToEhr(map, retryLog.getUploadMode(), retryLog.getStartDate(), retryLog.getEndDate());
			} else {
				logger.debug("No uploadable record found. (patno:" + retryLog.getPatno() +")"); 
			}
		}
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
				ps.setString(i++, ConstantsEhr.DOMAIN_CODE_BIRTH);
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
            logger.error("Error: " + e.getMessage());
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
	
	private void updatePatInitBirth(String patno) {
		logger.info("patno="+patno);
		
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection conn = null;
        String sql;
		try {
			sql = "update ehr_pmi set InitBirth = SYSDATE where patno = '" + patno + "'";
			conn = ConnUtil.getDataSourceHATS().getConnection();
        	ps = conn.prepareStatement(sql);		
			rs = ps.executeQuery();
		} catch (Exception e) {
			logger.error("Error: " + e.getMessage());
            e.printStackTrace();
        } finally {
        	try {
        		if (rs != null)
        			rs.close();
        		
        		if (ps != null)
        			ps.close();
        		
        		ConnUtil.closeConnection(conn);
        	} catch(Exception e) {
                logger.error("Cannot close connection");
                e.printStackTrace();
        	}
        }		
	}
	
	private Date getLastEndDate() {
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection conn = null;
        String sql;
        Date lastEndDate = null;
		
		try {
			sql = "select param1 from sysparam where parcde = 'EHRUL_BIRT'";
			conn = ConnUtil.getDataSourceHATS().getConnection();
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			
			if (rs.next()) {
				lastEndDate = DateTimeUtil.parseDBTimestamp(rs.getString(1));
			}
		} catch (Exception e) {
			logger.error("Error: " + e.getMessage());
            e.printStackTrace();
        } finally {
        	try {
        		if (rs != null)
        			rs.close();
        		
        		if (ps != null)
        			ps.close();
        		
        		ConnUtil.closeConnection(conn);
        	} catch(Exception e) {
                logger.error("Cannot close connection");
                e.printStackTrace();
        	}
        }		
		return lastEndDate;
	}	
	
	private void saveLastEndDate(String dbDateStr) {
		logger.info("Update EndDate: " + dbDateStr);
		
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection conn = null;
        String sql;
		
		try {
			sql = "update sysparam set param1 = ? where parcde = 'EHRUL_BIRT'";
			conn = ConnUtil.getDataSourceHATS().getConnection();
			ps = conn.prepareStatement(sql);
			ps.setString(1, dbDateStr);
			rs = ps.executeQuery();
		} catch (Exception e) {
			logger.error("Error: " + e.getMessage());
            e.printStackTrace();
        } finally {
        	try {
        		if (rs != null)
        			rs.close();
        		
        		if (ps != null)
        			ps.close();
        		
        		ConnUtil.closeConnection(conn);
        	} catch(Exception e) {
                logger.error("Cannot close connection");
                e.printStackTrace();
        	}
        }		
	}	
	
	private String checkPatUpdateMode(String initBirth){
		String updateMode;
		if(initBirth != null && initBirth.length() > 0){
			updateMode = ConstantsEhr.UPLOAD_MODE_CODE_BL;
		} else {
			updateMode = ConstantsEhr.UPLOAD_MODE_CODE_BLM;
		}
		
		return updateMode;	
	}
	
	public void listPatientBirthDetails(Map<Participant, BirthDetail> list) {
		logger.info((list == null || list.isEmpty()) ? "Empty map" : "List size=" + list.size());
		
		if (list != null) {
			for (Participant participant : list.keySet()) {
				logger.info("Participant:[" + participant.toString() + "]");
				BirthDetail birthDetail = list.get(participant);
				logger.info("BirthDetail:[" + birthDetail.toString() + "]");
			}
		}
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
            logger.error("Error, patno:" + patno);
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
		private String initBirth;
		
		public PatientInfo(String patNo, String ehrNo, String initBirth) {
			super();
			this.patNo = patNo;
			this.ehrNo = ehrNo;
			this.initBirth = initBirth;
		}
		
		public String getPatNo() {
			return patNo;
		}		
		public String getInitBirth() {
			return initBirth;
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
}