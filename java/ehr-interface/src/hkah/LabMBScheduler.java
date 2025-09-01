package hkah;

import hk.gov.ehr.hepr.ws.*;

import org.apache.commons.lang.ArrayUtils;
import org.apache.log4j.Logger;
import org.hl7.v3.LabResultMBDetail;
import org.hl7.v3.LabResultMBDetail.*;
import org.hl7.v3.Participant;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import test.client.HeprWebServiceClient;

import java.sql.*;

import jcifs.smb.NtlmPasswordAuthentication;
import jcifs.smb.SmbFile;
import jcifs.smb.SmbFileInputStream;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.hkah.constant.ConstantsEhr;
import com.hkah.constant.ConstantsServerSide;
import com.hkah.ehr.common.FactoryBase;
import com.hkah.util.db.ConnUtil;
import com.hkah.util.mail.UtilMail2;

@Service()
public class LabMBScheduler {
	protected static Logger logger = Logger.getLogger(LabMBScheduler.class);

	private static String getParam(String key, String defaultVal){
        PreparedStatement ps = null;
		Connection conn = null;
        ResultSet rs = null;
        String sql;
        String val = defaultVal;
        
		try {
			
        	sql = "select PARAM1 from sysparam where parcde=?";
        
        	conn = ConnUtil.getDataSourceHATS().getConnection();
    		ps = conn.prepareStatement(sql);
            ps.setString(1, key);
            rs = ps.executeQuery();
            
            if (rs.next()) {
            	val = rs.getString("PARAM1");
            } 
                                    
        } catch (Exception e) {
            logger.info("[LABMB] getParam error");
            e.printStackTrace();
            
        } finally {
        	try {
        		if (rs != null)
        			rs.close();
        		
        		if (ps != null)
        			ps.close();
        		
        		ConnUtil.closeConnection(conn);
        	} catch(Exception e) {
                logger.info("[LABMB] Cannot close getParam connection");
                e.printStackTrace();
        	}
        }
        
        return val;
	}	
			
	private String generateKey() {
        String recordKey = null;
        
        Connection conn = null;
        PreparedStatement ps1 = null;
        ResultSet rs1 = null;
        String sql1 = "select to_char(ehr_seq.nextval) from dual";
       
		try {			
            conn = ConnUtil.getDataSourceLIS().getConnection();
            ps1 = conn.prepareStatement(sql1);
            rs1 = ps1.executeQuery();
			
            if (rs1.next()) {
            	recordKey = rs1.getString(1);                	
                logger.info("[LABMB] gen key:" + recordKey);         	                
            }
			                
        } catch (Exception e) {
            logger.info("[LABMB] Cannot generate record key");
            e.printStackTrace();
            
        } finally {
        	try {
        		if (rs1 != null)
        			rs1.close();
        		
        		if (ps1 != null)
        			ps1.close();
        		
        		ConnUtil.closeConnection(conn);
        	} catch(Exception e) {
                logger.info("[LABMB] Cannot close connection");
                e.printStackTrace();
        	}
        }
		
		return recordKey;
	}
	
	private String newEhrLogNo() {
        String ehrLogNo = null;
        
        Connection conn = null;
        PreparedStatement psLogNo = null;
        ResultSet rsLogNo = null;
        String sql = "select sq_ehr_log_no.nextval from dual";		
                
		try {			
            conn = ConnUtil.getDataSourceLIS().getConnection();
            psLogNo = conn.prepareStatement(sql);            
	        rsLogNo = psLogNo.executeQuery();
	        if (rsLogNo.next()) {
            	ehrLogNo = rsLogNo.getString(1) ;    	        	
	        }   			
			                
        } catch (Exception e) {
            logger.info("[LABMB] Cannot generate ehr_log_no");
            e.printStackTrace();
            
        } finally {
        	try {
        		if (rsLogNo != null)
        			rsLogNo.close();
        		
        		if (psLogNo != null)
        			psLogNo.close();
        		
        		ConnUtil.closeConnection(conn);
        	} catch(Exception e) {
                logger.info("[LABMB] Cannot close connection");
                e.printStackTrace();
        	}
        }
		
        return ehrLogNo;
	}
	
	private String getRptDate(String labnum) { 
		
		String rptDate = null;
    
    	Connection conn = null;
    	PreparedStatement ps1 = null;
    	ResultSet rs1 = null;
    	String sql1 = "select to_char(max(rpt_date), 'yyyy-mm-dd hh24:mi:ss') || '.000' from labo_report_log where length(test_cat) > 1 and lab_num = ? ";
   
		try {
			
	        conn = ConnUtil.getDataSourceLIS().getConnection();
	        ps1 = conn.prepareStatement(sql1);
	        ps1.setString(1, labnum);
	        rs1 = ps1.executeQuery();
			
	        if (rs1.next()) {
	        	rptDate = rs1.getString(1);	
	        }	        	        
			                
	    } catch (Exception e) {
	        logger.info("[LABMB] Cannot get latest rptDate");
	        e.printStackTrace();
	        
	    } finally {
	    	try {
	    		if (rs1 != null)
	    			rs1.close();
	    		
	    		if (ps1 != null)
	    			ps1.close();
	    		
	    		ConnUtil.closeConnection(conn);
	    	} catch(Exception e) {
	            logger.info("[LABMB] Cannot close connection");
	            e.printStackTrace();
	    	}
	    }
		
		return rptDate;
	}
	
	private String getFileInd(String labnum) { 
		
		int cnt = 0;
		
        PreparedStatement ps = null;
		Connection conn = null;
        ResultSet rs = null;
        String sql;
        
		try {			
        	sql = " select count(*) cnt from labo_report_log r " +
        			" inner join file_store@cis f on r.file_id = f.file_id " +
        			" where f.status = 'A' and r.ehr_status in ('R', 'S', 'I') " +
        			" and length(r.test_cat) > 1 " +
        			" and f.store_server is not null " +
        			" and f.store_folder is not null " +
        			" and f.store_subfolder is not null " +
        			" and f.store_file is not null " +
        			" and lab_num = ? ";
        	
        	conn = ConnUtil.getDataSourceLIS().getConnection();
    		ps = conn.prepareStatement(sql);
            ps.setString(1, labnum);
            rs = ps.executeQuery();
            
            if (rs.next()) {
            	cnt = rs.getInt(1);
            }
                                    
        } catch (Exception e) {
            logger.info("[LABMB] getFileInd error: " + labnum);
            e.printStackTrace();
            
        } finally {
        	try {
        		if (rs != null)
        			rs.close();
        		
        		if (ps != null)
        			ps.close();
        		
        		ConnUtil.closeConnection(conn);
        	} catch(Exception e) {
                logger.info("[LABMB] Cannot close connection");
                e.printStackTrace();
        	}
        }
        
        if (cnt > 0)
        	return "1";
        else
        	return "0";
	}
	
	private void writeLog(Participant p, LabResultMBDetail m, List<String> logNoList, String uploadMode ) {
			
        Connection conn = null;
        PreparedStatement psLogHeader = null;
        PreparedStatement psLogDetail = null;
        PreparedStatement psLogStDetail = null;
        String sql;
        
        String ehrLogNo;
        HashMap<String, String> logNoMap = new HashMap<String, String>();        
        
        String tranType = m.getLabReqData().get(0).getTransactionType();
        
        try {        	
        	conn = ConnUtil.getDataSourceLIS().getConnection();
			sql = "insert into ehr_log_header ( " +
					" ehr_no, patientkey, hkid, doc_type, doc_no, " +
					" person_eng_surname, person_eng_given_name, person_eng_full_name, sex, birth_date, " +
					" record_key, transaction_dtm, transaction_type, last_update_dtm, episode_no, " +
					" attendance_inst_id, request_no, request_doctor, request_part_inst_id, request_part_inst_name, " +
					" request_part_inst_lt_desc, order_no, lab_category_cd, lab_category_lt_desc, perform_lab_name, " +
					" report_reference_dtm, clinical_info, lab_report_comment, specimen_type_rt_name, specimen_type_rt_id, " +
					" specimen_type_rt_desc, specimen_type_lt_id, specimen_type_lt_desc, specimen_arrival_dtm, specimen_collect_dtm, " +
					" specimen_details, file_ind, record_creation_dtm, record_creation_inst_id, record_creation_inst_name, " +
					" report_status_cd, report_status_desc, report_status_lt_desc, report_dtm, file_name, " +
					" return_code, return_message, test_cat, ehr_log_no, upload_mode " +
					" ) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";	
			psLogHeader = conn.prepareStatement(sql);			
	
			sql = "insert into ehr_log_detail ( " +
					" record_key, test_lt_id, test_lt_desc, reportable_result, result_unit, " +
					" reference_range, panel_lt_cd, auth_dtm, auth_staff_id, auth_staff_eng_name, " +
					" abnormal_ind_cd, result_type, numeric_result, ehr_log_no, test_rt_name, " +
					" test_rt_id, test_rt_desc, Enumerated_Result, text_result, panel_lt_desc, " +
					" abnormal_ind_desc, abnormal_ind_lt_desc, result_note " +
					" ) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			psLogDetail = conn.prepareStatement(sql);
	
			sql = "insert into ehr_log_st_detail ( " +
					" RECORD_KEY, TEST_LT_ID, ORGANISM_KEY, ORGANISM_RT_NAME, ORGANISM_RT_ID, " +
					" ORGANISM_RT_DESC, ORGANISM_LT_ID, ORGANISM_LT_DESC, MB_TEXT_RESULT, ORGANISM_GROWTH_TEXT, " +
					" ST_RT_NAME, ST_RT_ID, ST_RT_DESC, ST_LT_ID, ST_LT_DESC, " +
					" ST_SEQ_NUM, ST_RESULT_CD, ST_RESULT_DESC, ST_RESULT_LT_DESC, ehr_log_no " +
					" ) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			psLogStDetail = conn.prepareStatement(sql);		
        		
			if ("D".equals(tranType) ) {
				ehrLogNo = newEhrLogNo();
				
				psLogHeader.setString(1, p.getEhrNo());
				psLogHeader.setString(2, p.getPatientKey());
				psLogHeader.setString(3, p.getHkid());
				psLogHeader.setString(4, p.getDocType());
				psLogHeader.setString(5, p.getDocNo());
				psLogHeader.setString(6, p.getPersonEngSurname());
				psLogHeader.setString(7, p.getPersonEngGivenName());
				psLogHeader.setString(8, p.getPersonEngFullName());
				psLogHeader.setString(9, p.getSex());
				psLogHeader.setString(10, p.getBirthDate());
				psLogHeader.setString(11, m.getLabReqData().get(0).getRecordKey());
				psLogHeader.setString(12, m.getLabReqData().get(0).getTransactionDtm());
				psLogHeader.setString(13, m.getLabReqData().get(0).getTransactionType());
				psLogHeader.setString(14, m.getLabReqData().get(0).getLastUpdateDtm());
				psLogHeader.setString(15, m.getLabReqData().get(0).getEpisodeNo());
				psLogHeader.setString(16, m.getLabReqData().get(0).getAttendanceInstId());
				psLogHeader.setString(17, m.getLabReqData().get(0).getRequestNo());
				psLogHeader.setString(18, m.getLabReqData().get(0).getRequestDoctor());
				psLogHeader.setString(19, m.getLabReqData().get(0).getRequestParticipantInstId());
				psLogHeader.setString(20, m.getLabReqData().get(0).getRequestParticipantInstName());
				psLogHeader.setString(21, m.getLabReqData().get(0).getRequestParticipantInstLtDesc());
				psLogHeader.setString(22, m.getLabReqData().get(0).getOrderNo());
				psLogHeader.setString(23, m.getLabReqData().get(0).getLabCategoryCd());
				psLogHeader.setString(24, m.getLabReqData().get(0).getLabCategoryLtDesc());
				psLogHeader.setString(25, m.getLabReqData().get(0).getPerformLabName());
				psLogHeader.setString(26, m.getLabReqData().get(0).getReportReferenceDtm());
				psLogHeader.setString(27, m.getLabReqData().get(0).getClinicalInfo());
				psLogHeader.setString(28, m.getLabReqData().get(0).getLabReportComment());
				psLogHeader.setString(29, m.getLabReqData().get(0).getSpecimenTypeRtName());
				psLogHeader.setString(30, m.getLabReqData().get(0).getSpecimenTypeRtId());
				psLogHeader.setString(31, m.getLabReqData().get(0).getSpecimenTypeRtDesc());
				psLogHeader.setString(32, m.getLabReqData().get(0).getSpecimenTypeLtId());
				psLogHeader.setString(33, m.getLabReqData().get(0).getSpecimenTypeLtDesc());
				psLogHeader.setString(34, m.getLabReqData().get(0).getSpecimenArrivalDtm());
				psLogHeader.setString(35, m.getLabReqData().get(0).getSpecimenCollectDtm());
				psLogHeader.setString(36, m.getLabReqData().get(0).getSpecimenDetails());
				psLogHeader.setString(37, m.getLabReqData().get(0).getFileInd());
				psLogHeader.setString(38, m.getLabReqData().get(0).getRecordCreationDtm());
				psLogHeader.setString(39, m.getLabReqData().get(0).getRecordCreationInstId());
				psLogHeader.setString(40, m.getLabReqData().get(0).getRecordCreationInstName());
				psLogHeader.setString(41, null);
				psLogHeader.setString(42, null);
				psLogHeader.setString(43, null);
				psLogHeader.setString(44, null);
				psLogHeader.setString(45, null);		    	
				psLogHeader.setString(46, null);
				psLogHeader.setString(47, null);
				psLogHeader.setString(48, "5");				
				psLogHeader.setString(49, ehrLogNo);	
				psLogHeader.setString(50, uploadMode);	
				
				psLogHeader.executeUpdate();
				psLogHeader.clearParameters();
								
				logNoList.add(ehrLogNo);
			
			} else {
				
				for (LabReportData r: m.getLabReportData()) {
					ehrLogNo = newEhrLogNo();       
					String fname = r.getFileName();       
					String test = fname.substring(0, fname.indexOf("#"));	
					psLogHeader.setString(1, p.getEhrNo());
					psLogHeader.setString(2, p.getPatientKey());
					psLogHeader.setString(3, p.getHkid());
					psLogHeader.setString(4, p.getDocType());
					psLogHeader.setString(5, p.getDocNo());
					psLogHeader.setString(6, p.getPersonEngSurname());
					psLogHeader.setString(7, p.getPersonEngGivenName());
					psLogHeader.setString(8, p.getPersonEngFullName());
					psLogHeader.setString(9, p.getSex());
					psLogHeader.setString(10, p.getBirthDate());
					psLogHeader.setString(11, m.getLabReqData().get(0).getRecordKey());
					psLogHeader.setString(12, m.getLabReqData().get(0).getTransactionDtm());
					psLogHeader.setString(13, m.getLabReqData().get(0).getTransactionType());
					psLogHeader.setString(14, m.getLabReqData().get(0).getLastUpdateDtm());
					psLogHeader.setString(15, m.getLabReqData().get(0).getEpisodeNo());
					psLogHeader.setString(16, m.getLabReqData().get(0).getAttendanceInstId());
					psLogHeader.setString(17, m.getLabReqData().get(0).getRequestNo());
					psLogHeader.setString(18, m.getLabReqData().get(0).getRequestDoctor());
					psLogHeader.setString(19, m.getLabReqData().get(0).getRequestParticipantInstId());
					psLogHeader.setString(20, m.getLabReqData().get(0).getRequestParticipantInstName());
					psLogHeader.setString(21, m.getLabReqData().get(0).getRequestParticipantInstLtDesc());
					psLogHeader.setString(22, m.getLabReqData().get(0).getOrderNo());
					psLogHeader.setString(23, m.getLabReqData().get(0).getLabCategoryCd());
					psLogHeader.setString(24, m.getLabReqData().get(0).getLabCategoryLtDesc());
					psLogHeader.setString(25, m.getLabReqData().get(0).getPerformLabName());
					psLogHeader.setString(26, m.getLabReqData().get(0).getReportReferenceDtm());
					psLogHeader.setString(27, m.getLabReqData().get(0).getClinicalInfo());
					psLogHeader.setString(28, m.getLabReqData().get(0).getLabReportComment());
					psLogHeader.setString(29, m.getLabReqData().get(0).getSpecimenTypeRtName());
					psLogHeader.setString(30, m.getLabReqData().get(0).getSpecimenTypeRtId());
					psLogHeader.setString(31, m.getLabReqData().get(0).getSpecimenTypeRtDesc());
					psLogHeader.setString(32, m.getLabReqData().get(0).getSpecimenTypeLtId());
					psLogHeader.setString(33, m.getLabReqData().get(0).getSpecimenTypeLtDesc());
					psLogHeader.setString(34, m.getLabReqData().get(0).getSpecimenArrivalDtm());
					psLogHeader.setString(35, m.getLabReqData().get(0).getSpecimenCollectDtm());
					psLogHeader.setString(36, m.getLabReqData().get(0).getSpecimenDetails());
					psLogHeader.setString(37, m.getLabReqData().get(0).getFileInd());
					psLogHeader.setString(38, m.getLabReqData().get(0).getRecordCreationDtm());
					psLogHeader.setString(39, m.getLabReqData().get(0).getRecordCreationInstId());
					psLogHeader.setString(40, m.getLabReqData().get(0).getRecordCreationInstName());
					psLogHeader.setString(41, r.getReportStatusCd());
					psLogHeader.setString(42, r.getReportStatusDesc());
					psLogHeader.setString(43, r.getReportStatusLtDesc());
					psLogHeader.setString(44, r.getReportDtm());
					psLogHeader.setString(45, fname);
					psLogHeader.setString(46, null);
					psLogHeader.setString(47, null);
					psLogHeader.setString(48, "5");
					psLogHeader.setString(49, ehrLogNo);
					psLogHeader.setString(50, uploadMode);
					
					psLogHeader.executeUpdate();
					psLogHeader.clearParameters();
										
					logNoList.add(ehrLogNo) ;
					logNoMap.put(test, ehrLogNo);
				}
				
				for (LabmbResultData mbResult : m.getLabmbResultData()) {
					
					ehrLogNo = logNoMap.get(mbResult.getTestLtId());
					
					psLogDetail.setString(1, mbResult.getRecordKey());
					psLogDetail.setString(2, mbResult.getTestLtId());
					psLogDetail.setString(3, mbResult.getTestLtDesc());
					psLogDetail.setString(4, mbResult.getReportableResult());
					psLogDetail.setString(5, mbResult.getResultUnit());
					psLogDetail.setString(6, mbResult.getReferenceRange());
					psLogDetail.setString(7, mbResult.getPanelLtCd());
					psLogDetail.setString(8, mbResult.getReportAuthDtm());
					psLogDetail.setString(9, mbResult.getReportAuthStaffId());
					psLogDetail.setString(10, mbResult.getReportAuthStaffEngName());
					psLogDetail.setString(11, mbResult.getAbnormalIndCd());
					psLogDetail.setString(12, mbResult.getResultType());
					psLogDetail.setString(13, mbResult.getNumericResult());
					psLogDetail.setString(14, ehrLogNo);
					psLogDetail.setString(15, mbResult.getTestRtName());
					psLogDetail.setString(16, mbResult.getTestRtId());
					psLogDetail.setString(17, mbResult.getTestRtDesc());
					psLogDetail.setString(18, mbResult.getEnumeratedResult());
					psLogDetail.setString(19, mbResult.getTextResult());
					psLogDetail.setString(20, mbResult.getPanelLtDesc());
					psLogDetail.setString(21, mbResult.getAbnormalIndDesc());
					psLogDetail.setString(22, mbResult.getAbnormalIndLtDesc());
					psLogDetail.setString(23, mbResult.getResultNote());
					
					psLogDetail.executeUpdate();
					psLogDetail.clearParameters();
				}
				
				for (LabmbStResultData stResult : m.getLabmbStResultData()) {
					
					ehrLogNo = logNoMap.get(stResult.getTestLtId());
					
					psLogStDetail.setString(1, stResult.getRecordKey());
					psLogStDetail.setString(2, stResult.getTestLtId());
					psLogStDetail.setString(3, stResult.getOrganismKey());
					psLogStDetail.setString(4, stResult.getOrganismRtName());
					psLogStDetail.setString(5, stResult.getOrganismRtId());
					psLogStDetail.setString(6, stResult.getOrganismRtDesc());
					psLogStDetail.setString(7, stResult.getOrganismLtId());
					psLogStDetail.setString(8, stResult.getOrganismLtDesc());
					psLogStDetail.setString(9, stResult.getMbTextResult());
					psLogStDetail.setString(10, stResult.getOrganismGrowthText());
					psLogStDetail.setString(11, stResult.getStRtName());
					psLogStDetail.setString(12, stResult.getStRtId());
					psLogStDetail.setString(13, stResult.getStRtDesc());
					
					if (stResult.getStLtId() == null)
						psLogStDetail.setString(14, "NONE");
					else
						psLogStDetail.setString(14, stResult.getStLtId());
					
					psLogStDetail.setString(15, stResult.getStLtDesc());
					psLogStDetail.setString(16, stResult.getStSeqNum());
					psLogStDetail.setString(17, stResult.getStResultCd());
					psLogStDetail.setString(18, stResult.getStResultDesc());
					psLogStDetail.setString(19, stResult.getStResultLtDesc());
					psLogStDetail.setString(20, ehrLogNo);
					
					psLogStDetail.executeUpdate();
					psLogStDetail.clearParameters();
				}								
			}
			
        } catch (Exception e) {
            logger.info("[LABMB] writeLog error: " + e.getMessage() );
            e.printStackTrace();
            
        } finally {
        	try {        		
        		if (psLogHeader != null)
        			psLogHeader.close();
        		
        		if (psLogDetail != null)
        			psLogDetail.close();
        		        		        		
        		if (psLogStDetail != null)
        			psLogStDetail.close();
        		        		
        		ConnUtil.closeConnection(conn);
        		
        	} catch(Exception e) {
                logger.info("[LABMB] Cannot close connection");
                e.printStackTrace();
        	}
        }			

	}
	
	private String getDict(String termId, String type){
		String dict = null;        
		
        PreparedStatement ps = null;
		Connection conn = null;
        ResultSet rs = null;
        String sql;
        
		try {
			
        	sql = "select dict from labm_terms " +
        			" where TERMID = ? " +
        			" and type = ? ";
        	
        	conn = ConnUtil.getDataSourceLIS().getConnection();
    		ps = conn.prepareStatement(sql);

            ps.setString(1, termId);
            ps.setString(2, type);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
            	dict = rs.getString("dict");
            }
                                    
        } catch (Exception e) {
            logger.info("[LABMB] getDict error: " + termId);
            e.printStackTrace();
            
        } finally {
        	try {
        		if (rs != null)
        			rs.close();
        		
        		if (ps != null)
        			ps.close();
        		
        		ConnUtil.closeConnection(conn);
        	} catch(Exception e) {
                logger.info("[LABMB] Cannot close connection");
                e.printStackTrace();
        	}
        }
        
        return dict;
	}	
	
	private String getTerms(String termId, String type){
		String desc = null;        
		
        PreparedStatement ps = null;
		Connection conn = null;
        ResultSet rs = null;
        String sql;
        
		try {
			
        	sql = "select ehr_desc from labm_terms " +
        			" where TERMID = ? " +
        			" and type = ? ";
        	
        	conn = ConnUtil.getDataSourceLIS().getConnection();
    		ps = conn.prepareStatement(sql);

            ps.setString(1, termId);
            ps.setString(2, type);
            
            rs = ps.executeQuery();
            
            if (!rs.next()) {
            	logger.info("[LABMB] Terms not found: " + termId);
            } else {
            	desc = rs.getString("ehr_desc");
            }
                                    
        } catch (Exception e) {
            logger.info("[LABMB] getTerms error: " + termId);
            e.printStackTrace();
            
        } finally {
        	try {
        		if (rs != null)
        			rs.close();
        		
        		if (ps != null)
        			ps.close();
        		
        		ConnUtil.closeConnection(conn);
        	} catch(Exception e) {
                logger.info("[LABMB] Cannot close connection");
                e.printStackTrace();
        	}
        }
        
        return desc;
	}	
	
	private LabResultMBDetail.LabReqData req(String labnum, String recKey, String tranType ) {
		
		LabResultMBDetail.LabReqData r = new LabResultMBDetail.LabReqData();
		
	   	PreparedStatement psReqData = null;
	   	Connection conn = null;
	    ResultSet rsReqData = null;
        String sql;

        r.setRecordKey(recKey);
        
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
    	r.setTransactionDtm(sdf.format(cal.getTime()));

    	r.setTransactionType(tranType);
    	
      	r.setLastUpdateDtm(getRptDate(labnum));
    	
		try {	    
            if ( !"D".equals(tranType) ) {
            	            	
	    		sql = "select to_char(date_rpt, 'yyyy-mm-dd hh24:mi:ss') || '.000' update_dtm, regid, doc_nameo, " +
					" to_char(date_in, 'yyyy-mm-dd hh24:mi:ss') || '.000' date_in, " +
					" comments, m.spec_type, to_char(recv_date, 'yyyy-mm-dd hh24:mi:ss') || '.000' arrival_dtm, " +
					" decode(date_col, null, null, to_char(date_col, 'yyyy-mm-dd hh24:mi:ss') || '.000') collect_dtm, " +
					" s.spec_desc, ref_hcpid, req_no, s.spec_termid " +
					" from labo_masthead m left outer join labm_spec_type s on m.spec_type = s.spec_type " +
					" where lab_num = ? ";
	        				        	
	        	conn = ConnUtil.getDataSourceLIS().getConnection();
	        	psReqData = conn.prepareStatement(sql);
	
	            psReqData.setString(1, labnum) ;
	            rsReqData = psReqData.executeQuery();
            	                     
            	if (rsReqData.next()) {
                	r.setEpisodeNo(rsReqData.getString("regid"));

                	//r.setAttendanceInstId("5987754786");
                	r.setAttendanceInstId(FactoryBase.getInstance().getSysparamValue("hcp_id"));

                	r.setRequestNo(labnum);
                	r.setRequestDoctor(rsReqData.getString("doc_nameo"));

                	//r.setRequestParticipantInstId("5987754786");
                	r.setRequestParticipantInstId(FactoryBase.getInstance().getSysparamValue("hcp_id"));
                	
                	//r.setRequestParticipantInstName("ADV TEST");
                	r.setRequestParticipantInstName(FactoryBase.getInstance().getSysparamValue("hcp_name"));

                	//r.setRequestParticipantInstLtDesc("HKAH");
                	r.setRequestParticipantInstLtDesc(FactoryBase.getInstance().getSysparamValue("hcp_name"));
                	
                	r.setLabCategoryCd("MICRO");
                	r.setLabCategoryDesc("Microbiology & Virology");
                	r.setLabCategoryLtDesc("Microbiology");
                	
            		r.setFileInd(getFileInd(labnum));
                	
                	// r.setPerformLabName("HKAH");
                	r.setPerformLabName(FactoryBase.getInstance().getSysparamValue("hcp_name"));
                	
            		r.setReportReferenceDtm(rsReqData.getString("date_in"));
            		r.setLabReportComment(rsReqData.getString("comments"));
            		
            		r.setSpecimenTypeRtName(getDict(rsReqData.getString("spec_termid"), "S"));
            		r.setSpecimenTypeRtId(rsReqData.getString("spec_termid"));
            		r.setSpecimenTypeRtDesc(getTerms(rsReqData.getString("spec_termid"), "S"));            		           				
            				
            		r.setSpecimenTypeLtId(rsReqData.getString("spec_type"));
            		r.setSpecimenArrivalDtm(rsReqData.getString("arrival_dtm"));
            		r.setSpecimenCollectDtm(rsReqData.getString("collect_dtm"));
            		
            		//r.setRecordCreationInstId("5987754786");
            		r.setRecordCreationInstId(FactoryBase.getInstance().getSysparamValue("hcp_id"));
            		
            		//r.setRecordCreationInstName("ADV TEST");
            		r.setRecordCreationInstName(FactoryBase.getInstance().getSysparamValue("hcp_name"));
            		
            		r.setRecordUpdateDtm(rsReqData.getString("date_in"));

            		//r.setRecordUpdateInstId("5987754786");
            		r.setRecordUpdateInstId(FactoryBase.getInstance().getSysparamValue("hcp_id"));
            		
            		//r.setRecordUpdateInstName("ADV TEST");
            		r.setRecordUpdateInstName(FactoryBase.getInstance().getSysparamValue("hcp_name"));
            		
            		r.setSpecimenTypeLtDesc(rsReqData.getString("spec_desc"));
            	}
        		
            }	
                       
        } catch (Exception e) {
            logger.info("[LABMB] LabReqData Error, labnum: " + labnum );
            e.printStackTrace();
            
        } finally {
        	try {
        		if (rsReqData != null)
        			rsReqData.close();
        		
        		if (psReqData != null)
        			psReqData.close();        		        		
        		
        		ConnUtil.closeConnection(conn);
        	} catch(Exception e) {
                logger.info("[LABMB] Cannot close connection");
                e.printStackTrace();
        	}
        }        
        return r; 
	}
	
	private List<LabmbResultData> mbResult(String labnum, String recKey){
		
		List<LabmbResultData> result = new ArrayList<LabmbResultData>();
		LabmbResultData item;
		
		String testNum;
		int logNo;
		
        Connection conn = null;
        PreparedStatement psMbLogNo = null;
        ResultSet rsMbLogNo = null;        
        PreparedStatement psResult = null;
        ResultSet rs = null;
        
        String sql;
		
		try {
			
			sql ="select max(log_no), test_num from labo_bact_detail_log " +
					" where lab_num = ? group by test_num";
			
			conn = ConnUtil.getDataSourceLIS().getConnection();
			psMbLogNo = conn.prepareStatement(sql);
			psMbLogNo.setString(1, labnum) ;
			rsMbLogNo = psMbLogNo.executeQuery();
        	        	
        	while (rsMbLogNo.next()) {
        		
        		logNo = rsMbLogNo.getInt(1);
        		testNum = rsMbLogNo.getString("test_num");
        		
        		sql = " select d.short_desc test_desc, d.result result, p.loinc test_rt_id, " +
	        			" to_char(h.release_dt,'yyyy-mm-dd hh24:mi:ss') || '.000' auth_dtm " +
	        			" from labo_bact_detail_log d left outer join labm_prices p on p.code = d.test_num " +
	        			" join labo_header h on h.lab_num = d.lab_num and h.test_type = d.test_type " +
	        			" where d.lab_num = ? and d.test_num = ? and log_no = ?";
	        	
	        	psResult = conn.prepareStatement(sql);
	        	psResult.setString(1, labnum);
	        	psResult.setString(2, testNum);
	        	psResult.setInt(3, logNo);
	        	rs = psResult.executeQuery();
	
	        	while (rs.next()){        	
	            	
	        		item = new LabmbResultData();
	        		item.setRecordKey(recKey);
	        		
	        		item.setTestLtId(testNum);
	        		item.setTestRtName(getDict(rs.getString("test_rt_id"), "T"));
	        		item.setTestRtId(rs.getString("test_rt_id"));	        		
	        		item.setTestRtDesc(getTerms(rs.getString("test_rt_id"), "T")); 
	        		item.setTestLtDesc(rs.getString("test_desc"));
	        		item.setResultType("3");
	        		
	        		if (rs.getString("result").length() > 255)
	        			item.setReportableResult(rs.getString("result").substring(0, 251) + "...");
	        		else
	        			item.setReportableResult(rs.getString("result"));
	       			
	        		item.setReportAuthDtm(rs.getString("auth_dtm"));
	        		result.add(item);
	        	}
        	}
        	
		} catch (Exception e) {
			
            logger.info("[LABMB] LabmbResultData Error, labnum:" + labnum);
            e.printStackTrace();
            
        } finally {
        	
        	try {
        		if (rs != null)
        			rs.close();
        		
        		if (rsMbLogNo != null)
        			rsMbLogNo.close();      		
        		
        		if (psMbLogNo != null)
        			psMbLogNo.close();
        		
        		if (psResult != null)
        			psResult.close();
        		        
        		ConnUtil.closeConnection(conn);
        	} catch(Exception e) {
                logger.info("[LABMB] Cannot close connection");
                e.printStackTrace();
        	}
        }		
		
		return result;
	}
	
	private List<LabmbStResultData> mbStResult(String labnum, String recKey){
		
		List<LabmbStResultData> result = new ArrayList<LabmbStResultData>();
		LabmbStResultData item;
		
		String testNum;
		int logNo;
		
        Connection conn = null;
        PreparedStatement psMbLogNo = null;
        ResultSet rsMbLogNo = null;        
        PreparedStatement psResult = null;
        ResultSet rs = null;
        
        String sql;
		
		try {
			
			sql ="select max(log_no), test_num from labo_bact_detail_log " +
					" where lab_num = ? group by test_num";
			
			conn = ConnUtil.getDataSourceLIS().getConnection();
			psMbLogNo = conn.prepareStatement(sql);
			psMbLogNo.setString(1, labnum) ;
			rsMbLogNo = psMbLogNo.executeQuery();
        	        	
        	while (rsMbLogNo.next()) {
        		
        		logNo = rsMbLogNo.getInt(1);
        		testNum = rsMbLogNo.getString("test_num");
												
	        	sql = " select d.organ_code, o.description organism_lt_desc, q.desc_eng, " +
	        			" s.antibio_code st_lt_id, a.generic_name st_lt_desc, s.suscep_rst, " +
	        			" o.organ_termid, a.antibio_termid, " +
	        			" DECODE(s.suscep_rst, 'S', 'Sensitive', 'I', 'Intermediate', 'R', 'Resistant', " +
	        			" 'P', 'Positive', 'N', 'Negative', 'U', 'Indetermine' ) st_result_desc " +
	        			" from labo_bact_organdtl_log d left outer join labo_bact_sensidtl_log  s on ( d.lab_num = s.lab_num " +
	        			" and d.test_num = s.test_num and d.organ_code = s.organ_code and d.log_no = s.log_no) " +
	        			" join labm_bact_organism o on (d.organ_code = o.organ_code ) " +
	        			" left outer join labm_bact_antibio a on (a.antibio_code = s.antibio_code) " +
	        			" left outer join labm_bact_quantity q on (d.quan_code = q.int_tcode) " +
	        			" where d.lab_num = ? and d.test_num = ? and d.log_no = ? ";
        	
	        	psResult = conn.prepareStatement(sql);
	        	psResult.setString(1, labnum) ;
	        	psResult.setString(2, testNum);
	        	psResult.setInt(3, logNo);
	        	rs = psResult.executeQuery();

	        	int seqno = 0;
	        	while (rs.next()){        		            	
	        		item = new LabmbStResultData();
	        		item.setRecordKey(recKey);
	        		item.setTestLtId(testNum);
	        		item.setOrganismKey(rs.getString("organ_code"));
	        		
	        		item.setOrganismRtName(getDict(rs.getString("organ_termid"), "O"));
	        		item.setOrganismRtId(rs.getString("organ_termid"));
	        		item.setOrganismRtDesc(getTerms(rs.getString("organ_termid"), "O"));
	        		
	        		item.setOrganismLtId(rs.getString("organ_code"));
	        		item.setOrganismLtDesc(rs.getString("organism_lt_desc"));
	        		item.setMbTextResult(rs.getString("desc_eng"));
	        		
	        		item.setStRtName(getDict(rs.getString("antibio_termid"), "A"));
	        		item.setStRtId(rs.getString("antibio_termid"));
	        		item.setStRtDesc(getTerms(rs.getString("antibio_termid"), "A"));	
	        		
	        		item.setStLtId(rs.getString("st_lt_id"));
	        		item.setStLtDesc(rs.getString("st_lt_descvi "));
	        		item.setStSeqNum(Integer.toString(seqno++));	        			        		
	        		item.setStResultCd(rs.getString("suscep_rst"));
	        		item.setStResultDesc(rs.getString("st_result_desc"));
	        		item.setStResultLtDesc(rs.getString("st_result_desc"));
	        		result.add(item);
	        	}
        	}
        	
		} catch (Exception e) {
			
            logger.info("[LABMB] LabmbStResultData Error, labnum:" + labnum);
            e.printStackTrace();
            
        } finally {
        	
        	try {
        		if (rs != null)
        			rs.close(); 
      		
        		if (rsMbLogNo != null)
        			rsMbLogNo.close();  
        		
        		if (psResult != null)
        			psResult.close();
        		
        		if (psMbLogNo != null)
        			psMbLogNo.close();        		
    		        	
        		ConnUtil.closeConnection(conn);
        	} catch(Exception e) {
                logger.info("[LABMB] Cannot close connection");
                e.printStackTrace();
        	}
        }		
		
		return result;		
	}
	
	private List<LabReportData> mbReport(String labnum, String recKey, Map<String,File> fileMap ) {
		
		List<LabReportData> reports = new ArrayList<LabReportData>();
		LabResultMBDetail.LabReportData r;
		
		Connection conn = null;
		PreparedStatement ps = null;        
        ResultSet rs = null;        
        String sql;
        
        String fname;
        String ehr_fname;
        String ori_path = null;
        String tmp_path = null;
		
        String reportTmpBasePath = FactoryBase.getInstance().getSysparamValue(ConstantsEhr.SYSPARAM_LIS_REPORT_TEMP_PATH);
		String login_user = FactoryBase.getInstance().getSysparamValue(ConstantsEhr.SYSPARAM_SMB_USERNAME);
	    String login_pass = FactoryBase.getInstance().getSysparamValue(ConstantsEhr.SYSPARAM_SMB_PASSWORD);

        SmbFile smbFile = null ;
		File attachment = null ;
		File destDirFile = null ;
		
		String test = null;
		
        try {
			
        	sql = "	select to_char(h.release_dt,'yyyy-mm-dd hh24:mi:ss') || '.000' report_dtm, " +
        			" '//' || f.store_server || '/' || f.store_folder || '/' || f.store_subfolder folder, f.store_file fname, r.test_cat " +
        			" from labo_report_log r " +
        			" inner join labo_header h on h.lab_num = r.lab_num " +
        			" inner join file_store@cis f on r.file_id = f.file_id " +
        			" where h.lab_num = ? and h.test_type = '3' and h.status = '2' and f.status = 'A' and r.ehr_status in ('I', 'R', 'S') " +
        			" and f.store_server is not null and f.store_folder is not null and f.store_subfolder is not null and f.store_file is not null";
        	
        	        	
			conn = ConnUtil.getDataSourceLIS().getConnection();
			ps = conn.prepareStatement(sql);
			ps.setString(1, labnum) ;
			rs = ps.executeQuery();
			
			while (rs.next()) {
				r = new LabResultMBDetail.LabReportData();
				
				r.setRecordKey(recKey);
				r.setReportStatusDesc("Final Report");
				r.setReportStatusLtDesc("Final Report");
				
				fname = rs.getString("fname");
				ori_path = rs.getString("folder") + "/" + fname ;
				test = rs.getString("test_cat");
				
				ehr_fname = test + "#" + fname.substring(0, fname.length()-4).replace(".", "-") + fname.substring(fname.length()-4, fname.length()) ;				
				tmp_path = reportTmpBasePath + ehr_fname ;
				NtlmPasswordAuthentication auth = new NtlmPasswordAuthentication("",login_user, login_pass);
				
				// linux file path
				smbFile = new SmbFile("smb:" + ori_path.replace("\\", "/"), auth);
				destDirFile = new File( reportTmpBasePath ) ;
				attachment = new File( tmp_path ) ;
				
				logger.info("[LABMB] copyFileUsingFileStreams source=" + ori_path.replace("\\", "/") +
						"@" + login_user + "/" + login_pass +
						" path=" + reportTmpBasePath + 
						" dest=" + tmp_path);
				copyFileUsingFileStreams( smbFile, destDirFile, attachment ) ;
				logger.info("[LABMB] copyFileUsingFileStreams success");
				
				r.setFileName(ehr_fname);
				r.setReportDtm(rs.getString("report_dtm"));
				fileMap.put(attachment.getName(), attachment);	
				reports.add(r);
			}
		
            
		} catch (Exception e) {
			
            logger.info("[LABMB] LabReportData Error, labnum:" + labnum );
            e.printStackTrace();
            
        } finally {
        	try {        	
        		if (rs != null)
        			rs.close();
        		
        		if (ps != null)
        			ps.close();
        		
        		ConnUtil.closeConnection(conn);
        	} catch(Exception e) {
                logger.info("[LABMB] Cannot close connection");
                e.printStackTrace();
        	}
        }		
        
		return reports;
	}	
	
    private static void copyFileUsingFileStreams(SmbFile source, File path, File dest) throws IOException {
        SmbFileInputStream input = null;
        OutputStream output = null;
        
	    path.mkdirs() ;
	    input = new SmbFileInputStream(source);
	    output = new FileOutputStream(dest);
	   
	    byte[] buf = new byte[1024];
	    int bytesRead;
	    while ((bytesRead = input.read(buf)) > 0) {
		   output.write(buf, 0, bytesRead);
	    }
	
	    input.close();
	    output.close();
    }
        
	public static boolean sendAlert(List<String> ehrLogNoList, String resMsg) {
		
		String site = ConstantsServerSide.SITE_CODE.toUpperCase();
        
        String emailFrom = "it-admin@hkah.org.hk";
        
        String emailToList = getParam("EHRLISERRM", "arran.siu@hkah.org.hk");
        			
    	String emailTo[] = emailToList.split(";");

    	emailTo = (String[]) ArrayUtils.removeElement(emailTo, "");
    		                       
        if (ConstantsServerSide.DEBUG) {
        	emailTo = new String[] {"arran.siu@hkah.org.hk"};
		}
        
        String subject = "[" + site + "] eHR LAAM: Data upload error (LABMB)";

		String ehrLogNo = null;
		
        for (int i = 0; i < ehrLogNoList.size(); i++) {
        	
        	if (ehrLogNo == null) 
        		ehrLogNo = "EHR_LOG_NO: " + ehrLogNoList.get(i);
        	else
        		ehrLogNo = ehrLogNo + ", " + ehrLogNoList.get(i);
        	          			
        }
        
        String message = site + " eHR Data upload error. "  + "\n<br />"
        		+ "Result: " + resMsg + "\n<br />"
        		+ ehrLogNo;
        
        return UtilMail2.sendMail(emailFrom, emailTo, subject, message);
	}
	
//	@Scheduled(cron="0/15 * * * * ?")	//every 15 seconds
//	@Scheduled(cron="0 0 15 * * ?")		//3:00:00pm
//	@Scheduled(cron="0 0/15 * * * ?") 	//every 15 minutes
//	
// ***
//production:
//    @Scheduled(cron="0 15/30 * * * ?") //every 30 minutes at :15, :45   
    @Scheduled(cron="0 0/5 * * * ?") //testing   
	public void ehrSchedule(){
    	logger.info("[LABMB] Start 1.11");
    	uploadBLM();
    	uploadBL();
    	logger.info("[LABMB] Complete");
    }
    
    private void uploadBL() {
		Map<Participant,List> pMbMap = new HashMap<Participant,List>();
        Map<String,File> fileMap = new HashMap<String,File>() ;
    	
    	int size = Integer.valueOf( getParam("EHRLISSIZE", "30"));
    	
        Participant p;
        LabResultMBDetail m;
        
        Response mbResponse;   
    			
        PreparedStatement psReport = null;
        PreparedStatement psUpdLogHeader = null;
        
        PreparedStatement psUpdate_sent = null;
        PreparedStatement psUpdate_error = null;
        
        PreparedStatement psUpdD_labnum = null;
        PreparedStatement psUpdD_reckey = null;

        Connection conn = null;
        ResultSet rs = null;
        
        String sql;
        String labnum;
        String tranType;
        String recKey;        
                
		try {
	    	logger.info("[LABMB] Processing BL");
						
			sql = "select ehr_record_key, transaction_type, patno, " +
				" lab_num, ehrno, fullname, ehrhkid, " +
				" ehrdocno, ehrdoctype, ehrdob_dtm, ehrsex " +
				" from ehr_mb_pending  " +
				" where upload_mode = 'BL' " +
				" order by lab_num ";
						
			conn = ConnUtil.getDataSourceLIS().getConnection();
//get report			
			psReport = conn.prepareStatement(sql);
            rs = psReport.executeQuery();		

//update sent ehr_status            
			sql = "update labo_report_log set ehr_status = 'S', ehr_record_key = ? where lab_num = ? and length(test_cat) > 1 and ehr_status in ('R', 'I') ";
			psUpdate_sent = conn.prepareStatement(sql);
			
//update error ehr_status            
			sql = "update labo_report_log set ehr_status = 'E' where lab_num = ? and length(test_cat) > 1 and ehr_status in ('R', 'I') ";
			psUpdate_error = conn.prepareStatement(sql);			
			
//remove test			
			sql = "update labo_report_log set ehr_status = 'D', ehr_record_key = null where lab_num = ? and length(test_cat) > 1 and ehr_status = 'C' ";
			psUpdD_labnum = conn.prepareStatement(sql);			
			
//delete labnum			
			sql = "update labo_report_log set ehr_status = 'D', ehr_record_key = null where ehr_record_key = ? and ehr_status = 'C' ";
			psUpdD_reckey = conn.prepareStatement(sql);			
			
//update status			
            sql = "update ehr_log_header set return_code = ?, return_message = ? where ehr_log_no = ? and upload_mode = 'BL' " ;
            psUpdLogHeader = conn.prepareStatement(sql);
			
			List<String> mbEhrLogNoList = new ArrayList<String>() ;
			
			ApplicationContext context = new ClassPathXmlApplicationContext("ClientContext.xml");
			HeprWebServiceClient heprWebServiceClient = (HeprWebServiceClient) context.getBean("HeprWebServiceClient");
						
            while (rs.next()) {
            	            	
                if ( pMbMap.size() >= size ) {                     	
//Send batch       	
	            	logger.info("[LABMB] Send BL: " + pMbMap.size());
	            	try {
	            		Thread.sleep(60000);     
	            		mbResponse = heprWebServiceClient.uploadLabmbData(pMbMap, fileMap, "BL");
//update ehr log
	            		for (int i = 0; i < mbEhrLogNoList.size(); i++) {
	            			psUpdLogHeader.setString(1, mbResponse.getResponseCode());
	            			psUpdLogHeader.setString(2, mbResponse.getResponseMessage());
	            			psUpdLogHeader.setString(3, mbEhrLogNoList.get(i));
	            			psUpdLogHeader.executeUpdate();
	            			psUpdLogHeader.clearParameters();            			
	            		}
	         		
	            		if ( !"00000".equals(mbResponse.getResponseCode()) ) {
	            			logger.info("[LABMB] return code=" + mbResponse.getResponseCode());         
	            			String resMsg = mbResponse.getResponseCode() + " - " + mbResponse.getResponseMessage();
	            			sendAlert(mbEhrLogNoList, resMsg);
	            		}
//update labo_report_log status            		
	                    for(Map.Entry<Participant,List> entry : pMbMap.entrySet()) {
	                    	List<LabResultMBDetail> detailList = entry.getValue();
	                    	for(int i = 0; i < detailList.size(); i++) {
	                    		
	                    		m = detailList.get(i);
	                    		tranType =  m.getLabReqData().get(0).getTransactionType();
	                    		recKey = m.getLabReqData().get(0).getRecordKey();
	                    		labnum = m.getLabReqData().get(0).getRequestNo();	                    		
	                    		                                        		
	                    		logger.info("[LABMB] Update BL status tranType=" + tranType + " Key=" + recKey + " LABNUM=" + labnum );
	                    		
	    						if ( "D".equals(tranType) ) {
	    							psUpdD_reckey.setString(1, recKey ) ;
	    							psUpdD_reckey.executeUpdate();
	    							psUpdD_reckey.clearParameters();
	    						} else {						
	    	                		psUpdate_sent.setString(1, recKey ) ;
	    	                		psUpdate_sent.setString(2, labnum) ;	        						
	    	                		psUpdate_sent.executeUpdate();
	    	                		psUpdate_sent.clearParameters();  
	    	                		
	    	                   		psUpdD_labnum.setString(1, labnum) ;	        						
	    	                		psUpdD_labnum.executeUpdate();
	    	                		psUpdD_labnum.clearParameters();    	
	    						}    						    						
	                    	}
	                    }             		
	            		            		
	            	} catch (Exception e) {
//update log for exception               		
	               		for (int i = 0; i < mbEhrLogNoList.size(); i++) {
	               			psUpdLogHeader.setString(1, "exception");
	               			psUpdLogHeader.setString(2, e.getMessage());
	               			psUpdLogHeader.setString(3, mbEhrLogNoList.get(i));
	               			psUpdLogHeader.executeUpdate();
	               			psUpdLogHeader.clearParameters();
	               		}

	               		String resMsg = "Exception - " + e.getMessage();
	        			sendAlert(mbEhrLogNoList, resMsg);
	        			
						logger.info("[LABMB] send BL error : " + e.getMessage() );
						e.printStackTrace();
						
					} finally {
						pMbMap = new HashMap<Participant,List>();
						fileMap = new HashMap<String,File>() ;
						mbEhrLogNoList = new ArrayList<String>() ;
					}
                	            	
                }                          
//Prepare batch                
            	labnum = rs.getString("lab_num"); 	  
            	   			
				logger.info("[LABMB] labnum: " + labnum );
            
				p = new Participant() ;
				p.setSex( rs.getString("ehrsex") );
	            p.setBirthDate( rs.getString("ehrdob_dtm") );
				p.setEhrNo( rs.getString("ehrno") );
				p.setPatientKey( rs.getString("patno") );
				p.setHkid( rs.getString("ehrhkid") );
				p.setDocNo( rs.getString("ehrdocno") );
				p.setDocType( rs.getString("ehrdoctype") );
				p.setPersonEngFullName( rs.getString("fullname") );
				
				tranType = rs.getString("transaction_type");
													
				if ( "I".equals(tranType) ) {
					recKey = generateKey();
				} else {
					recKey = rs.getString("ehr_record_key");
				}
				
				if ( (!"NULL".equals(recKey)) || (recKey != null) ) {
				
					List<LabResultMBDetail> mbDetailList = new ArrayList<LabResultMBDetail>();
					m = new LabResultMBDetail();
										
					m.getLabReqData().add(req(labnum, recKey, tranType));						
					
		        	if ( !"D".equals(tranType) ) {
		        		
						m.getLabmbResultData().addAll(mbResult(labnum, recKey));
						m.getLabmbStResultData().addAll(mbStResult(labnum, recKey));
						m.getLabReportData().addAll(mbReport(labnum, recKey, fileMap));
						
						if (m.getLabmbResultData().isEmpty()) {
							logger.info("[LABMB] Fail: LabmbResultData is empty. record ignored");
	
							psUpdate_error.setString(1, labnum) ;							
							psUpdate_error.executeUpdate();
							psUpdate_error.clearParameters();
							
							continue;
						}
						
						//St result allows empty
						
						if (m.getLabReportData().isEmpty()) {
							logger.info("[LABMB] Fail: LabReportData is empty. record ignored");
							
							psUpdate_error.setString(1, labnum) ;							
							psUpdate_error.executeUpdate();
							psUpdate_error.clearParameters();							
							
							continue;
						}
						
		        	}
		        	
					if (m.getLabmbResultData() != null) {						
						mbDetailList.add(m);
						pMbMap.put(p, mbDetailList);	
						writeLog(p, m, mbEhrLogNoList, "BL");												
					}
            	}
//end loop						
            }
            
//send last batch
            if ( pMbMap.size() > 0 ) {
            	logger.info("[LABMB] Send BL: " + pMbMap.size());
            	try {
            		Thread.sleep(60000);     
            		mbResponse = heprWebServiceClient.uploadLabmbData(pMbMap, fileMap, "BL");
//update ehr log
            		for (int i = 0; i < mbEhrLogNoList.size(); i++) {
            			psUpdLogHeader.setString(1, mbResponse.getResponseCode());
            			psUpdLogHeader.setString(2, mbResponse.getResponseMessage());
            			psUpdLogHeader.setString(3, mbEhrLogNoList.get(i));
            			psUpdLogHeader.executeUpdate();
            			psUpdLogHeader.clearParameters();            			
            		}
         		
            		if ( !"00000".equals(mbResponse.getResponseCode()) ) {
            			logger.info("[LABMB] return code=" + mbResponse.getResponseCode());         
            			String resMsg = mbResponse.getResponseCode() + " - " + mbResponse.getResponseMessage();
            			sendAlert(mbEhrLogNoList, resMsg);
            		}
//update labo_report_log status            		
                    for(Map.Entry<Participant,List> entry : pMbMap.entrySet()) {
                    	List<LabResultMBDetail> detailList = entry.getValue();
                    	for(int i = 0; i < detailList.size(); i++) {
                    		
                    		m = detailList.get(i);
                    		tranType =  m.getLabReqData().get(0).getTransactionType();
                    		recKey = m.getLabReqData().get(0).getRecordKey();
                    		labnum = m.getLabReqData().get(0).getRequestNo();	                    		
                    		                                        		
                    		logger.info("[LABMB] Update BL status tranType=" + tranType + " Key=" + recKey + " LABNUM=" + labnum );
                    		
    						if ( "D".equals(tranType) ) {
    							psUpdD_reckey.setString(1, recKey ) ;
    							psUpdD_reckey.executeUpdate();
    							psUpdD_reckey.clearParameters();
    						} else {
    	                		psUpdate_sent.setString(1, recKey ) ;
    	                		psUpdate_sent.setString(2, labnum) ;	        						
    	                		psUpdate_sent.executeUpdate();
    	                		psUpdate_sent.clearParameters();  
    	                			    	                						    	        
    	                		psUpdD_labnum.setString(1, labnum) ;	        						
    	                		psUpdD_labnum.executeUpdate();
    	                		psUpdD_labnum.clearParameters();    	
    						}    						    						
                    	}
                    }             		
            		            		
            	} catch (Exception e) {
//update log for exception               		
               		for (int i = 0; i < mbEhrLogNoList.size(); i++) {
               			psUpdLogHeader.setString(1, "exception");
               			psUpdLogHeader.setString(2, e.getMessage());
               			psUpdLogHeader.setString(3, mbEhrLogNoList.get(i));
               			psUpdLogHeader.executeUpdate();
               			psUpdLogHeader.clearParameters();
               		}

               		String resMsg = "Exception - " + e.getMessage();
        			sendAlert(mbEhrLogNoList, resMsg);
        			
					logger.info("[LABMB] send BL error : " + e.getMessage() );
					e.printStackTrace();					
				}          	
            }
			
        } catch (Exception e) {
            logger.info("[LABMB] Error : " + e.getMessage() );
            e.printStackTrace();
            
        } finally {
        	try {
        		if (rs != null)
        			rs.close();
        		        		
        		if (psReport != null)
        			psReport.close();           		
        		
        		if (psUpdLogHeader != null)
        			psUpdLogHeader.close(); 
        		        		
        		if (psUpdate_sent != null)
        			psUpdate_sent.close();
        		
        		if (psUpdate_error != null)
        			psUpdate_error.close();        		

        		if (psUpdD_labnum != null)
        			psUpdD_labnum.close();
        		
        		if (psUpdD_reckey != null)
        			psUpdD_reckey.close();        	

        		ConnUtil.closeConnection(conn);
        		
        	} catch(Exception e) {
                logger.info("[LABMB] Cannot close connection");
                e.printStackTrace();
        	}
        }
	}
//uploadBL end    
    
    private void uploadBLM() {  
		Map<Participant,List> pMbMap_init = new HashMap<Participant,List>();
		Map<Participant,List> pMbMap_BL_M = new HashMap<Participant,List>();
        Map<String,File> fileMap = new HashMap<String,File>() ;
		
        Connection conn = null;
        Connection connHATS = null;
    	
        PreparedStatement psReport = null;
        PreparedStatement psUpdate_sent = null;
        PreparedStatement psUpdate_error = null;
        PreparedStatement psUpdate_pmi = null;
        PreparedStatement psUpdate_init = null;
        PreparedStatement psUpdLogHeader = null;
                
        ResultSet rs = null;
        
        String sql;
        String labnum;
        String recKey;
                
        Participant p;
        LabResultMBDetail m;    

        Response mbResponse;        
        
		try {
	    	logger.info("[LABMB] Processing BL-M");
			
			sql = "select ehr_record_key, patno, " +
				" lab_num, ehrno, fullname, ehrhkid, " +
				" ehrdocno, ehrdoctype, ehrdob_dtm, ehrsex " +
				" from ehr_mb_pending  " +
				" where upload_mode = 'BL-M' " +
				" and rownum <= " + getParam("EHRLISSIZE", "30");				
						
			conn = ConnUtil.getDataSourceLIS().getConnection();
			//logger.info("[LabMBScheduler] DEBUG:sql=" + sql);
			psReport = conn.prepareStatement(sql);
            rs = psReport.executeQuery();                       

			sql = "update labo_report_log set ehr_status = 'S', ehr_record_key = ? where lab_num = ? and length(test_cat) > 1 and ehr_status in ('R', 'I') ";
			psUpdate_sent = conn.prepareStatement(sql);
			
			sql = "update labo_report_log set ehr_status = 'E' where lab_num = ? and length(test_cat) > 1 and ehr_status in ('R', 'I') ";
			psUpdate_error = conn.prepareStatement(sql);
						
			sql = "update ehr_pmi set initlabmb = sysdate where patno = ?" ;
			connHATS = ConnUtil.getDataSourceHATS().getConnection();
			psUpdate_pmi = connHATS.prepareStatement(sql);
			
			//20191028 Arran Re-init status for BL-M		
			sql = "update labo_report_log set ehr_status = 'I' " +
					" where lab_num in (select lab_num from labo_masthead where hospnum = ? or accountnum = ?) " +
					" and ehr_status in ('R', 'S') " +
					" and length(test_cat) > 1 ";
			psUpdate_init = conn.prepareStatement(sql);
						
            sql = "update ehr_log_header set return_code = ?, return_message = ? where ehr_log_no = ? and upload_mode = 'BL-M' " ;
            psUpdLogHeader = conn.prepareStatement(sql);
			
			List<String> mbEhrLogNoList = new ArrayList<String>() ;
			
			ApplicationContext context = new ClassPathXmlApplicationContext("ClientContext.xml");
			HeprWebServiceClient heprWebServiceClient = (HeprWebServiceClient) context.getBean("HeprWebServiceClient");
						
            while (rs.next()) {

            	labnum = rs.getString("lab_num");            	                       	            	
    			
				logger.info("[LABMB] labnum: " + labnum );
            
				p = new Participant() ;
				p.setSex( rs.getString("ehrsex") );
	            p.setBirthDate( rs.getString("ehrdob_dtm") );
				p.setEhrNo( rs.getString("ehrno") );
				p.setPatientKey( rs.getString("patno") );
				p.setHkid( rs.getString("ehrhkid") );
				p.setDocNo( rs.getString("ehrdocno") );
				p.setDocType( rs.getString("ehrdoctype") );
				p.setPersonEngFullName( rs.getString("fullname") );
				
				if ( "NULL".equals(rs.getString("ehr_record_key"))) {
					recKey = generateKey();
				} else {
					recKey = rs.getString("ehr_record_key");
				}
				
				List<LabResultMBDetail> mbDetailList = new ArrayList<LabResultMBDetail>();
				m = new LabResultMBDetail();
									
				m.getLabReqData().add(req(labnum, recKey, "I"));											        	
	        		
				m.getLabmbResultData().addAll(mbResult(labnum, recKey));
				m.getLabmbStResultData().addAll(mbStResult(labnum, recKey));
				m.getLabReportData().addAll(mbReport(labnum, recKey, fileMap));
				
				if (m.getLabmbResultData().isEmpty()) {
					logger.info("[LABMB] Fail: LabmbResultData is empty. record ignored");

					psUpdate_error.setString(1, labnum) ;					
					psUpdate_error.executeUpdate();
					psUpdate_error.clearParameters();
					
					continue;
				}
					
				//St result allows empty
				
				if (m.getLabReportData().isEmpty()) {
					logger.info("[LABMB] Fail: LabReportData is empty. record ignored");
					
					psUpdate_error.setString(1, labnum) ;					
					psUpdate_error.executeUpdate();
					psUpdate_error.clearParameters();						
					
					continue;
				}
						        	
				if (m.getLabmbResultData() != null) {						
					mbDetailList.add(m);
					pMbMap_BL_M.put(p, mbDetailList);
					pMbMap_init.put(p, new ArrayList<LabResultMBDetail>());
					writeLog(p, m, mbEhrLogNoList, "BL-M");												
				}
				
/*
 * Remove initial empty BLM batch 		
 * 		          
	            if ( pMbMap_init.size() > 0 ) {
	               	logger.info("[LABMB] Send init BL-M: " + pMbMap_init.size());
	               	try {
	               		mbResponse = heprWebServiceClient.uploadLabmbData(pMbMap_init, new HashMap<String,File>(), "BL-M");                   
	                    
	               	} catch (Exception e) {               		          
						logger.info("[LABMB] send init BL-M error : " + e.getMessage() );
						e.printStackTrace();
					}
	            }		
*/	            	           
																
				//send batch
	            if ( pMbMap_BL_M.size() > 0 ) {
	            	logger.info("[LABMB] Send BL-M: " + pMbMap_BL_M.size());
	            	try {
	            		Thread.sleep(60000);     
	            		mbResponse = heprWebServiceClient.uploadLabmbData(pMbMap_BL_M, fileMap, "BL-M");
	//update ehr log	            			            		
	            		for (int i = 0; i < mbEhrLogNoList.size(); i++) {
	            			psUpdLogHeader.setString(1, mbResponse.getResponseCode());
	            			psUpdLogHeader.setString(2, mbResponse.getResponseMessage());
	            			psUpdLogHeader.setString(3, mbEhrLogNoList.get(i));
	            			psUpdLogHeader.executeUpdate();
	            			psUpdLogHeader.clearParameters();            			
	            		}
	         		
	            		if ( !"00000".equals(mbResponse.getResponseCode()) ) {
	            			logger.info("[LABMB] return code=" + mbResponse.getResponseCode());         
	            			String resMsg = mbResponse.getResponseCode() + " - " + mbResponse.getResponseMessage();
	            			sendAlert(mbEhrLogNoList, resMsg);
	            		}
	            		
	                    for(Map.Entry<Participant,List> entry : pMbMap_BL_M.entrySet()) {                    	
	//update initlab   
	                    	String patno = entry.getKey().getPatientKey();  
	        				String ehrno = entry.getKey().getEhrNo();
	        				
	                    	psUpdate_pmi.setString(1, patno);                
	        				psUpdate_pmi.executeUpdate();
	        				psUpdate_pmi.clearParameters();  
	        				
	                    	logger.info("[LABGEN] update initlab: patno=" + patno + " ehrno=" + ehrno);                    	
	        				
	//re-init status for BL-M                    	
	                       	psUpdate_init.setString(1, patno);                       
	                    	psUpdate_init.setString(2, ehrno);     	
	        				psUpdate_init.executeUpdate();
	        				psUpdate_init.clearParameters();
	                    }
	            		
	//update labo_report_log status            		
	                    for(Map.Entry<Participant,List> entry : pMbMap_BL_M.entrySet()) {
	                    	List<LabResultMBDetail> detailList = entry.getValue();
	                    	for(int i = 0; i < detailList.size(); i++) {	                    		
	                    		m = detailList.get(i);
	                    		recKey = m.getLabReqData().get(0).getRecordKey();
	                    		labnum = m.getLabReqData().get(0).getRequestNo();	                    		
	                    		                                        		
	                    		logger.info("[LABMB] Update BL status Key=" + recKey + " LABNUM=" + labnum );	                    		
							
    	                		psUpdate_sent.setString(1, recKey ) ;
    	                		psUpdate_sent.setString(2, labnum) ;	        						
    	                		psUpdate_sent.executeUpdate();
    	                		psUpdate_sent.clearParameters();      	                			    	                			
	                    	}
	                    }             		
	            		            		
	            	} catch (Exception e) {
	//update log for exception               		
	               		for (int i = 0; i < mbEhrLogNoList.size(); i++) {
	               			psUpdLogHeader.setString(1, "exception");
	               			psUpdLogHeader.setString(2, e.getMessage());
	               			psUpdLogHeader.setString(3, mbEhrLogNoList.get(i));
	               			psUpdLogHeader.executeUpdate();
	               			psUpdLogHeader.clearParameters();
	               		}

	               		String resMsg = "Exception - " + e.getMessage();
	        			sendAlert(mbEhrLogNoList, resMsg);
	        			
						logger.info("[LABMB] send BL-M error : " + e.getMessage() );
						e.printStackTrace();					
					}          	
	            }				
													
            }
            
            logger.info("[LABMB] Complete");
			
        } catch (Exception e) {
            logger.info("[LABMB] Error : " + e.getMessage() );
            e.printStackTrace();
            
        } finally {
        	try {
        		if (rs != null)
        			rs.close();
        		
        		if (psReport != null)
        			psReport.close();      		
        		
        		if (psUpdate_sent != null)
        			psUpdate_sent.close();
        		
        		if (psUpdate_pmi != null)
        			psUpdate_pmi.close();
        		
        		if (psUpdate_init != null)
        			psUpdate_init.close();
        		
        		if (psUpdate_error != null)
        			psUpdate_error.close();
        		
        		if (psUpdLogHeader != null)
        			psUpdLogHeader.close();
        		
        		ConnUtil.closeConnection(conn);
        		ConnUtil.closeConnection(connHATS);
        		
        	} catch(Exception e) {
                logger.info("[LABMB] Cannot close connection");
                e.printStackTrace();
        	}
        }
	}
//uploadBLM end    
    
}