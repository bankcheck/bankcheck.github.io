package hkah;

import hk.gov.ehr.hepr.ws.*;

import org.apache.log4j.Logger;
import org.hl7.v3.LabResultAPDetail;
import org.hl7.v3.LabResultAPDetail.*;
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
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import test.client.HeprWebServiceClient;

import java.sql.*;

import jcifs.smb.NtlmPasswordAuthentication;
import jcifs.smb.SmbFile;
import jcifs.smb.SmbFileInputStream;

import com.hkah.constant.ConstantsEhr;
import com.hkah.ehr.common.FactoryBase;
import com.hkah.util.db.ConnUtil;

@Service()
public class LabAPScheduler {
	protected static Logger logger = Logger.getLogger(LabAPScheduler.class);

	//private LabReqData req;
	private LabResultAPDetail APDetail;
	//private String uploadMode ;
	//private String updRecordKey ; 
	//private String transactionType ;
	//private String recordKey;
	// use for set last update dtm
	//private String rptDate ;
	//private String rptFilename ;
	//private String fileInd ;
	//private String reportStatusCd;
	
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
            logger.info("[LABAP] getParam error");
            e.printStackTrace();
            
        } finally {
        	try {
        		if (rs != null)
        			rs.close();
        		
        		if (ps != null)
        			ps.close();
        		
        		ConnUtil.closeConnection(conn);
        	} catch(Exception e) {
                logger.info("[LABAP] Cannot close getParam connection");
                e.printStackTrace();
        	}
        }
        
        return val;
	}	
		
	private String getRecordKey() {
		String recordKey = null;
		try {
			recordKey = APDetail.getLabReqData().get(0).getRecordKey();
		} catch(Exception e) {
            logger.info("[LABAP] getRecordKey error: " + e.getMessage() );
            e.printStackTrace();
    	}
		
		return recordKey;
	}
	
	private String getLabnum() {
		String labnum = null;
		try {
			if (APDetail != null)
				labnum = APDetail.getLabReqData().get(0).getRequestNo();
		} catch(Exception e) {
            logger.info("[LABAP] getLabnum error: " + e.getMessage() );
            e.printStackTrace();
    	}
		
		return labnum;
	}
	
	/*
	private String getRptDate() {
		return rptDate;
	}
	*/
	/*
	private String getRptFilename() {
		return rptFilename;
	}
	*/
	
	private String getRecordKey(String labnum) {
        String recordKey = null;
        
        Connection conn = null;
        PreparedStatement ps1 = null;
        ResultSet rs1 = null;
        PreparedStatement ps2 = null;
        ResultSet rs2 = null;
        String sql1 = "select min(ehr_record_key) from labo_report_log where test_cat = 'P' and lab_num = ? ";
        String sql2 = "select to_char(ehr_seq.nextval) from dual";
       
		try {
			
            conn = ConnUtil.getDataSourceLIS().getConnection();
            ps1 = conn.prepareStatement(sql1);
            ps1.setString(1, labnum);
            rs1 = ps1.executeQuery();
			
            if (rs1.next()) {
            	recordKey = rs1.getString(1);
                logger.info("[LABAP] rec key:" + recordKey);         	
            }
            
            if (recordKey == null) {
                ps2 = conn.prepareStatement(sql2);
                rs2 = ps2.executeQuery();
                			
                if (rs2.next()) {
                	recordKey = rs2.getString(1);
                    logger.info("[LABAP] gen key:" + recordKey);         	
                }
            }
			                
        } catch (Exception e) {
            logger.info("[LABAP] Cannot generate record key");
            e.printStackTrace();
            
        } finally {
        	try {
        		if (rs1 != null)
        			rs1.close();
        		
        		if (ps1 != null)
        			ps1.close();
        		
        		if (rs2 != null)
        			rs2.close();
        		
        		if (ps2 != null)
        			ps2.close();
        		
        		ConnUtil.closeConnection(conn);
        	} catch(Exception e) {
                logger.info("[LABAP] Cannot close connection");
                e.printStackTrace();
        	}
        }
		
		return recordKey;
	}

	private void setAPDetail(String labnum, String transactionType, String rptDate){
						
	   	PreparedStatement psChkUpd = null;
	   	PreparedStatement psReqData = null;
	   	Connection conn = null;
	    ResultSet rsChkUpd = null;
	    ResultSet rsReqData = null;
        String sql;
        
        APDetail = new LabResultAPDetail();
        
        LabReqData req = new LabReqData();
        
        req.setRecordKey(getRecordKey(labnum));
        
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
    	req.setTransactionDtm(sdf.format(cal.getTime()));

		try {

			req.setTransactionType(transactionType);
			// use to replace labo_masthead update_dtm
        	req.setLastUpdateDtm(rptDate);
        	req.setFileInd("0");
        	req.setRequestNo(labnum);
            
        	if (!"D".equals(transactionType)) {
	        	sql = "select to_char(date_rpt, 'yyyy-mm-dd hh24:mi:ss') || '.000' update_dtm, regid, doc_nameo, " +
	        			" to_char(date_in, 'yyyy-mm-dd hh24:mi:ss') || '.000' date_in, " +
	        			" comments, s.spec_type, to_char(recv_date, 'yyyy-mm-dd hh24:mi:ss') || '.000' arrival_dtm, " +
	        			" to_char(date_col, 'yyyy-mm-dd hh24:mi:ss') || '.000' collect_dtm, " +
	        			" s.spec_desc, p.long_desc " +
	        			" from labo_masthead m left outer join labm_spec_type s on m.spec_type = s.spec_type " +
	        			" inner join labo_detail d on m.lab_num = d.lab_num and d.test_type = 'P' " +
	          			" inner join labm_prices p on p.code = d.test_num " +
	        			" where m.lab_num = ? ";
	        	
	        	conn = ConnUtil.getDataSourceLIS().getConnection();
	        	psReqData = conn.prepareStatement(sql);
	
	            psReqData.setString(1, labnum) ;
	            rsReqData = psReqData.executeQuery();
	
	            if (!rsReqData.next()) {
	            	logger.info("[LABAP] LabReqData data not found: labnum:" + labnum);
	            } else {
	            	
                 	req.setEpisodeNo(rsReqData.getString("regid"));

                	req.setAttendanceInstId(FactoryBase.getInstance().getSysparamValue("hcp_id"));
                
                	req.setRequestDoctor(rsReqData.getString("doc_nameo"));

                	req.setRequestParticipantInstId(FactoryBase.getInstance().getSysparamValue("hcp_id"));
                	
                	req.setRequestParticipantInstName(FactoryBase.getInstance().getSysparamValue("hcp_name"));

                	req.setRequestParticipantInstLtDesc(FactoryBase.getInstance().getSysparamValue("hcp_name"));
                	
                	req.setLabCategoryCd("PATH");
                	req.setLabCategoryDesc("Anatomical Pathology");
                	req.setLabCategoryLtDesc("Pathology");

//20191126 add Anatomical pathology test name                	
                	req.setApTestName(rsReqData.getString("long_desc"));
                	
                	req.setPerformLabName(FactoryBase.getInstance().getSysparamValue("hcp_name"));
                	
            		req.setReportReferenceDtm(rsReqData.getString("date_in"));
            		req.setLabReportComment(rsReqData.getString("comments"));
            		req.setSpecimenTypeLtId(rsReqData.getString("spec_type"));
            		req.setSpecimenArrivalDtm(rsReqData.getString("arrival_dtm"));
            		req.setSpecimenCollectDtm(rsReqData.getString("collect_dtm"));
            		
            		//r.setRecordCreationInstId("5987754786");
            		req.setRecordCreationInstId(FactoryBase.getInstance().getSysparamValue("hcp_id"));            		
            		req.setRecordCreationInstName(FactoryBase.getInstance().getSysparamValue("hcp_name"));
            		
            		req.setRecordUpdateDtm(rsReqData.getString("date_in"));

            		//r.setRecordUpdateInstId("5987754786");
            		req.setRecordUpdateInstId(FactoryBase.getInstance().getSysparamValue("hcp_id"));
            		req.setRecordUpdateInstName(FactoryBase.getInstance().getSysparamValue("hcp_name"));
            		req.setSpecimenTypeLtDesc(rsReqData.getString("spec_desc"));
            		req.setSpecimenDetails(rsReqData.getString("spec_desc"));
            	}
        		
            }
			                       
        } catch (Exception e) {
            logger.info("[LABAP] setAPDetail Error, labnum: " + labnum );
            e.printStackTrace();
            
        } finally {
        	try {
        		if (rsChkUpd != null)
        			rsChkUpd.close();
        		
        		if (psChkUpd != null)
        			psChkUpd.close();
        		
        		if (rsReqData != null)
        			rsReqData.close();
        		
        		if (psReqData != null)
        			psReqData.close();
        		        		
        		ConnUtil.closeConnection(conn);
        	} catch(Exception e) {
                logger.info("[LABAP] Cannot close connection");
                e.printStackTrace();
        	}
        }
		
		APDetail.getLabReqData().add(req);
	}
	
	private void setFileInd(String fileInd) {
		try {
			APDetail.getLabReqData().get(0).setFileInd(fileInd);
		} catch(Exception e) {
			logger.info("[LABAP] setFileInd error value=" + fileInd + " message=" + e.getMessage() );
			e.printStackTrace();
		}
	}
	
	private LabReportData report(String labnum, String rptno, String fileName, String rptStatus) {
		
		LabReportData r = new LabReportData();
		
        PreparedStatement ps = null;
        Connection conn = null;
        ResultSet rs = null;
        String sql;
		
		r.setRecordKey(getRecordKey());
		r.setReportStatusCd(rptStatus);
		
		if ( "P".equals(rptStatus) ) {
			r.setReportStatusDesc("Provisional/Preliminary report");
		} else if ( "F".equals(rptStatus) ) {
			r.setReportStatusDesc("Final report");
		} else if ( "A".equals(rptStatus) ) {
			r.setReportStatusDesc("Amended report");
		} else if ( "S".equals(rptStatus) ) {
			r.setReportStatusDesc("Supplementary report");
		} else {
			r.setReportStatusCd("U");
			r.setReportStatusDesc("Unspecified report status");
		}
		
		r.setReportStatusLtDesc("Report " + rptno);
		// report filename
		r.setFileName(fileName);
			
		try {

			sql = "select to_char(nvl(r.rpt_date, sysdate),'yyyy-mm-dd hh24:mi:ss') || '.000' report_dtm, " +
				" to_char(nvl(h.release_dt, sysdate),'yyyy-mm-dd hh24:mi:ss') || '.000' release_dtm " +
        		" from labo_report_log r inner join labo_header h on r.lab_num = h.lab_num and r.test_cat = 'P' and h.test_type = 'P' " +
        		" where r.lab_num = ? and r.rpt_no = ? and h.status = '2' ";
			conn = ConnUtil.getDataSourceLIS().getConnection();
			ps = conn.prepareStatement(sql);
			ps.setString(1, labnum) ;
			ps.setString(2, rptno) ;
			rs = ps.executeQuery();
			
			if (rs.next()) {
				r.setReportDtm(rs.getString("report_dtm"));
//20191126 added Laboratory report authorized datetime				
				r.setReportAuthDtm(rs.getString("report_dtm"));
			}
            
		} catch (Exception e) {
			
            logger.info("[LABAP] LabReportData Error, labnum:" + labnum + " rptno:" +  rptno);
            e.printStackTrace();
            
        } finally {
        	try {
        		if (rs != null)
        			rs.close();
        		
        		if (ps != null)
        			ps.close();
        		
        		ConnUtil.closeConnection(conn);
        	} catch(Exception e) {
                logger.info("[LABAP] Cannot close connection");
                e.printStackTrace();
        	}
        }		
		return r;
	}

    private static void copyFileUsingFileStreams(SmbFile source, File path, File dest) throws IOException {
        SmbFileInputStream input = null;
        OutputStream output = null;
        //try {
           path.mkdirs() ;
           input = new SmbFileInputStream(source);
           output = new FileOutputStream(dest);
           
           byte[] buf = new byte[1024];
           int bytesRead;
           while ((bytesRead = input.read(buf)) > 0) {
             output.write(buf, 0, bytesRead);
             }
        //} finally {
           input.close();
           output.close();
        //}
    }
	
//	@Scheduled(cron="0/15 * * * * ?")	//every 15 seconds
//	@Scheduled(cron="0 0 15 * * ?")		//3:00:00pm
//	@Scheduled(cron="0 0/15 * * * ?") 	//every 15 minutes
// ***
//production:
//    @Scheduled(cron="0 0 * * * ?")    //every hour
	public void ehrSchedule(){
		logger.info("[LABAP] Start 1.23");
		
        PreparedStatement psReport = null;
        PreparedStatement psLogHeader = null;
        PreparedStatement psLogHeaderUpd = null;
        PreparedStatement psUpdate_1 = null;
        PreparedStatement psUpdate_2 = null;
        PreparedStatement psUpdate_3 = null;
        PreparedStatement psUpdate_D = null;      
        PreparedStatement psUpdate_error = null; 
        PreparedStatement psLogNo = null;
        
//        PreparedStatement psUpdate_rollback = null;
        Connection conn = null;
        Connection connHATS = null;
        ResultSet rs = null;
        ResultSet rsLogNo = null;

        String sql;
        //String labnum = null;
        String tranType;
        String recKey;
        String rptNo;
        String rptStatus;
        String uploadMode = null;
        
        Long ehrLogNo = null ;
        
        String fname;
        String ehr_fname;
        String ori_path = null;
        String tmp_path = null;
        
        //String reportSrcBasePath = "\\\\160.100.2.79\\d$\\mrpdf\\" ;
        String reportSrcBasePath = FactoryBase.getInstance().getSysparamValue(ConstantsEhr.SYSPARAM_LIS_REPORT_SOURCE_PATH);
        String reportTmpBasePath = FactoryBase.getInstance().getSysparamValue(ConstantsEhr.SYSPARAM_LIS_REPORT_TEMP_PATH);
        SmbFile smbFile = null ;
        
		File attachment = null ;
		File destDirFile = null ;
		String login_user = FactoryBase.getInstance().getSysparamValue(ConstantsEhr.SYSPARAM_SMB_USERNAME);
	    String login_pass = FactoryBase.getInstance().getSysparamValue(ConstantsEhr.SYSPARAM_SMB_PASSWORD);
        
        Participant p = null;
        
        List<LabResultAPDetail> detailList = new ArrayList<LabResultAPDetail>();
        
        Map<String,File> fileMap_BL = new HashMap<String,File>() ;
        Map<String,File> fileMap_BL_M = new HashMap<String,File>() ;

        Response response;
        
        logger.info("[LABAP] Start 1.20");
        APDetail = null;
        
		try {			
			sql = "select '1' dummy, upload_mode, transaction_type, ehr_record_key, patno, lab_num, rpt_date, rpt_by, fname, folder, ehr_status, ehrno, fullname, ehrhkid, ehrdocno, ehrdoctype, ehrdob_dtm, ehrsex, rpt_status, rpt_no " +
					" from ehr_ap_pending where lab_num in (" +
					"  select lab_num from (select lab_num from ehr_ap_pending order by lab_num) " +
					" where rownum < " + getParam("EHRLISSIZE", "30") + ")";

			logger.info("[LABAP] sql: " + sql );
			conn = ConnUtil.getDataSourceLIS().getConnection();
			psReport = conn.prepareStatement(sql);
			
            rs = psReport.executeQuery();
            
            sql = "select sq_ehr_log_no.nextval from dual";
			psLogNo = conn.prepareStatement(sql);

//20170111 Arran add upload mode to log						
			sql = "insert into ehr_log_header (ehr_no, patientkey, hkid, doc_type, doc_no, person_eng_surname, " +
					" person_eng_given_name, person_eng_full_name, sex, birth_date, record_key, transaction_dtm, " +
					" transaction_type, last_update_dtm, episode_no, attendance_inst_id, request_no, request_doctor, " +
					" request_part_inst_id, request_part_inst_name, request_part_inst_lt_desc, order_no, lab_category_cd, " +
					" lab_category_lt_desc, perform_lab_name, report_reference_dtm, clinical_info, lab_report_comment, " +
					" specimen_type_rt_name, specimen_type_rt_id, specimen_type_rt_desc, specimen_type_lt_id, " +
					" specimen_type_lt_desc, specimen_arrival_dtm, specimen_collect_dtm, specimen_details, file_ind, " +
					" record_creation_dtm, record_creation_inst_id, record_creation_inst_name, report_status_cd, " +
					" report_status_desc, report_status_lt_desc, report_dtm, file_name, return_code, return_message, test_cat, ehr_log_no, upload_mode ) " +
					" values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			psLogHeader = conn.prepareStatement(sql);

			sql = "update labo_report_log set ehr_status = 'S', ehr_record_key = ? where lab_num = ? and rpt_no = ? and test_cat = 'P' and ehr_status in ('R', 'I') ";
			psUpdate_1 = conn.prepareStatement(sql);
			
			sql = "update labo_report_log set ehr_status = 'E' where lab_num = ? and rpt_no = ? and test_cat = 'P' and ehr_status in ('R', 'I') ";
			psUpdate_error = conn.prepareStatement(sql);
			
			sql = "update ehr_pmi set initlabap = sysdate where patno = ?" ;
			connHATS = ConnUtil.getDataSourceHATS().getConnection();
			psUpdate_2 = connHATS.prepareStatement(sql);
			
			//Re-init status for BL-M		
			sql = "update labo_report_log set ehr_status = 'I' " +
					" where lab_num in (select lab_num from labo_masthead where hospnum = ?) " +
					" and ehr_status in ('R', 'S') " +
					" and test_cat = 'P' ";
			psUpdate_3 = conn.prepareStatement(sql);			
			
			sql = "update labo_report_log set ehr_status = 'D', ehr_record_key = null where ehr_record_key = ? and ehr_status = 'C' ";
			psUpdate_D = conn.prepareStatement(sql);		
			
            // Update return code
            sql = "update ehr_log_header set return_code = ?, return_message = ? where ehr_log_no = ? and upload_mode = ? " ;
            psLogHeaderUpd = conn.prepareStatement(sql);
			
			Map<Participant,List> pMap_BL = new HashMap<Participant,List>();
			Map<Participant,List> pMap_BL_M = new HashMap<Participant,List>();
			Map<Participant,List> pMap_init = new HashMap<Participant,List>();
			
			List<String> ehrLogNoList = new ArrayList<String>() ;
			
			ApplicationContext context = new ClassPathXmlApplicationContext("ClientContext.xml");
			HeprWebServiceClient heprWebServiceClient = (HeprWebServiceClient) context.getBean("HeprWebServiceClient");

            while (rs.next()) {        	
            	
    	        rsLogNo = psLogNo.executeQuery();
    	        if (rsLogNo.next()) {
                	ehrLogNo = rsLogNo.getLong(1) ;    	        	
    	        }     	  
    	        logger.info("[LABAP] ehrLogNo = " + ehrLogNo.toString());
    	        
            	rptNo = rs.getString("rpt_no") ;
            	rptStatus = rs.getString("RPT_STATUS");
            	
            	
            	if (!rs.getString("lab_num").equals(getLabnum())) {
            		
            		if (APDetail != null) {

        				detailList.add(APDetail);
            			
        				if ( "BL".equals(uploadMode) ) {
        					logger.info("[LABAP] prepare BL");

        					pMap_BL.put(p, detailList);
        						
        				} else {
        					logger.info("[LABAP] prepare BL-M");

        					pMap_BL_M.put(p, detailList);        					                               
    						pMap_init.put(p, new ArrayList<LabResultAPDetail>());
        				}
        				
            		}
                	setAPDetail(rs.getString("lab_num"), rs.getString("transaction_type"), rs.getString("rpt_date"));    
                   	uploadMode = rs.getString("upload_mode") ;
                	
    				p = new Participant() ;
    				p.setSex( rs.getString("ehrsex") );
    	            p.setBirthDate( rs.getString("ehrdob_dtm") );
    				p.setEhrNo( rs.getString("ehrno") );
    				p.setPatientKey( rs.getString("patno") );
    				p.setHkid( rs.getString("ehrhkid") );
    				p.setDocNo( rs.getString("ehrdocno") );
    				p.setDocType( rs.getString("ehrdoctype") );
    				p.setPersonEngFullName( rs.getString("fullname") );
    				
    				detailList = new ArrayList<LabResultAPDetail>();    		
            	}
            	logger.info("[LABAP] labnum: " + getLabnum() );
                
//attachment	
				if ( rs.getString("fname") == null || rs.getString("fname").isEmpty() || rs.getString("folder") == null || rs.getString("folder").isEmpty() || "D".equals(rs.getString("transaction_type")) ) {
					setFileInd("0");
					ehr_fname = null ;	
					
					if ( !"C".equals(rs.getString("ehr_status")) ) {
						logger.info("[LABAP] No file attached labnum: " + getLabnum() );
						
						psUpdate_error.setString(1, getLabnum()) ;
						psUpdate_error.setString(2, rptNo) ;						
						psUpdate_error.executeUpdate();
						psUpdate_error.clearParameters();
						
						continue ;
					}
					
				} else {
					try {
					// attach pdf  -- begin
						ori_path = reportSrcBasePath.trim() + rs.getString("folder") + "\\" + rs.getString("fname") ;

						fname = rs.getString("fname");
						ehr_fname = fname.substring(0, fname.length()-4).replace(".", "-") + fname.substring(fname.length()-4, fname.length()) ;
						tmp_path = reportTmpBasePath + ehr_fname ;
						logger.info("[LABAP] debug: reportSrcBasePath = " + reportSrcBasePath + 
								" folder = " + rs.getString("folder") +
								" ori_path = " + ori_path +
								" reportTmpBasePath = " + reportTmpBasePath +
								" file copy to = " + tmp_path +
								" smb login = " + login_user + " ; " + login_pass );

						NtlmPasswordAuthentication auth = new NtlmPasswordAuthentication("",login_user, login_pass);
// linux file path 
						smbFile = new SmbFile("smb:" + ori_path.replace("\\", "/"), auth);
						destDirFile = new File( reportTmpBasePath ) ;
						attachment = new File( tmp_path ) ;
						copyFileUsingFileStreams( smbFile, destDirFile, attachment ) ;
						
						APDetail.getLabReportData().add(report(getLabnum(), rptNo, ehr_fname, rptStatus));
						setFileInd("1");
						
					} catch (Exception e) {
// Skip the whole report if add file failed 						
						logger.info("[LABAP] Add file error : " + e.getMessage() );
						e.printStackTrace();
						
						psUpdate_error.setString(1, getLabnum()) ;
						psUpdate_error.setString(2, rptNo) ;						
						psUpdate_error.executeUpdate();
						psUpdate_error.clearParameters();
						
						continue ;
					}

// attach pdf file					
					if ( "BL".equals(uploadMode) ) {
						fileMap_BL.put(attachment.getName(), attachment);	
					} else {
						fileMap_BL_M.put(attachment.getName(), attachment);
					}

		            // -- end
				}																
				logger.info("[LABAP] prepare log for labnum: " + getLabnum() + " Trantype: " + APDetail.getLabReqData().get(0).getTransactionType());	
				
				ehrLogNoList.add(ehrLogNo.toString());

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
				psLogHeader.setString(11, getRecordKey());
				psLogHeader.setString(12, APDetail.getLabReqData().get(0).getTransactionDtm());
				psLogHeader.setString(13, APDetail.getLabReqData().get(0).getTransactionType());
				psLogHeader.setString(14, APDetail.getLabReqData().get(0).getLastUpdateDtm());
				psLogHeader.setString(15, APDetail.getLabReqData().get(0).getEpisodeNo());
				psLogHeader.setString(16, APDetail.getLabReqData().get(0).getAttendanceInstId());
				psLogHeader.setString(17, APDetail.getLabReqData().get(0).getRequestNo());
				psLogHeader.setString(18, APDetail.getLabReqData().get(0).getRequestDoctor());
				psLogHeader.setString(19, APDetail.getLabReqData().get(0).getRequestParticipantInstId());
				psLogHeader.setString(20, APDetail.getLabReqData().get(0).getRequestParticipantInstName());
				psLogHeader.setString(21, APDetail.getLabReqData().get(0).getRequestParticipantInstLtDesc());
				psLogHeader.setString(22, APDetail.getLabReqData().get(0).getOrderNo());
				psLogHeader.setString(23, APDetail.getLabReqData().get(0).getLabCategoryCd());
				psLogHeader.setString(24, APDetail.getLabReqData().get(0).getLabCategoryLtDesc());
				psLogHeader.setString(25, APDetail.getLabReqData().get(0).getPerformLabName());
				psLogHeader.setString(26, APDetail.getLabReqData().get(0).getReportReferenceDtm());
				psLogHeader.setString(27, APDetail.getLabReqData().get(0).getClinicalInfo());
				psLogHeader.setString(28, APDetail.getLabReqData().get(0).getLabReportComment());
				psLogHeader.setString(29, APDetail.getLabReqData().get(0).getSpecimenTypeRtName());
				psLogHeader.setString(30, APDetail.getLabReqData().get(0).getSpecimenTypeRtId());
				psLogHeader.setString(31, APDetail.getLabReqData().get(0).getSpecimenTypeRtDesc());
				psLogHeader.setString(32, APDetail.getLabReqData().get(0).getSpecimenTypeLtId());
				psLogHeader.setString(33, APDetail.getLabReqData().get(0).getSpecimenTypeLtDesc());
				psLogHeader.setString(34, APDetail.getLabReqData().get(0).getSpecimenArrivalDtm());
				psLogHeader.setString(35, APDetail.getLabReqData().get(0).getSpecimenCollectDtm());
				psLogHeader.setString(36, APDetail.getLabReqData().get(0).getSpecimenDetails());
				psLogHeader.setString(37, APDetail.getLabReqData().get(0).getFileInd());
				psLogHeader.setString(38, APDetail.getLabReqData().get(0).getRecordCreationDtm());
				psLogHeader.setString(39, APDetail.getLabReqData().get(0).getRecordCreationInstId());
				psLogHeader.setString(40, APDetail.getLabReqData().get(0).getRecordCreationInstName());		        

				int i = APDetail.getLabReportData().size() - 1;

				if (i >= 0) {
					psLogHeader.setString(41, APDetail.getLabReportData().get(i).getReportStatusCd());
					psLogHeader.setString(42, APDetail.getLabReportData().get(i).getReportStatusDesc());
					psLogHeader.setString(43, APDetail.getLabReportData().get(i).getReportStatusLtDesc());
					psLogHeader.setString(44, APDetail.getLabReportData().get(i).getReportDtm());
					psLogHeader.setString(45, APDetail.getLabReportData().get(i).getFileName());
				} else {
					psLogHeader.setString(41, null);
					psLogHeader.setString(42, null);
					psLogHeader.setString(43, null);
					psLogHeader.setString(44, null);
					psLogHeader.setString(45, null);
		        }
				
		        psLogHeader.setString(46, null);
				psLogHeader.setString(47, null);
				psLogHeader.setString(48, "P");
				psLogHeader.setLong(49, ehrLogNo);
//20170111 Arran add upload mode to log												
				psLogHeader.setString(50, uploadMode);
						
				psLogHeader.executeUpdate();
				psLogHeader.clearParameters();		
					
            }
            
            if (APDetail != null) {
				detailList.add(APDetail);

				if ( "BL".equals(uploadMode) ) {
					logger.info("[LABAP] debug: prepare BL");

					pMap_BL.put(p,detailList);
						
				} else {
					logger.info("[LABAP] debug: prepare BL-M");

					pMap_BL_M.put(p, detailList);
				}
				
            }

/*
 * 20240716 Arran send init BL-M
 * 20250312 Arran remove init BL-M
 *             
            if ( pMap_init.size() > 0 ) {
               	logger.info("[LABAP] Send init BL-M: " + pMap_init.size());
               	try {
               		response = heprWebServiceClient.uploadLabapData(pMap_init, new HashMap<String,File>(), "BL-M");
                                       
               	} catch (Exception e) {
               		          
					logger.info("[LABAP] send init BL-M error : " + e.getMessage() );
					e.printStackTrace();
				}
            }
*/            
            Thread.sleep(3000);     
            
//20181213 Arran send BL-M first
            if ( pMap_BL_M.size() > 0 ) {
               	logger.info("[LABAP] Send BL-M: " + pMap_BL_M.size());
               	try {
               		response = heprWebServiceClient.uploadLabapData(pMap_BL_M, fileMap_BL_M, "BL-M");
//Write log               		
               		for (int i = 0; i < ehrLogNoList.size(); i++) {
               			psLogHeaderUpd.setString(1, response.getResponseCode());
               			psLogHeaderUpd.setString(2, response.getResponseMessage());
               			psLogHeaderUpd.setString(3, ehrLogNoList.get(i));
               			psLogHeaderUpd.setString(4, "BL-M");
               			psLogHeaderUpd.executeUpdate();
               			psLogHeaderUpd.clearParameters();
               		}
               		                    
                    for(Map.Entry<Participant,List> entry : pMap_BL_M.entrySet()) {                    	
//update initlab   
                    	String patno = entry.getKey().getPatientKey();  
        				
                    	psUpdate_2.setString(1, patno);                
        				psUpdate_2.executeUpdate();
        				psUpdate_2.clearParameters();  
        				
                    	logger.info("[LABAP] update initlab: patno=" + patno );                    	
        				
//re-init status for BL-M                    	
                       	psUpdate_3.setString(1, patno);    	
        				psUpdate_3.executeUpdate();
        				psUpdate_3.clearParameters();
                    }
                    
//update labo_report_log status          
                    for(Map.Entry<Participant,List> entry : pMap_BL_M.entrySet()) {
                    	detailList = entry.getValue();
                    	
                    	for(LabResultAPDetail d : detailList) {          
                    		
                    		recKey = d.getLabReqData().get(0).getRecordKey();
                    		String labnum = d.getLabReqData().get(0).getRequestNo();
                    		
                    		for (LabReportData r : d.getLabReportData()) {
                    			String reportStatusLdDesc = r.getReportStatusLtDesc();
                    			if (reportStatusLdDesc.length() > 7) {
                    				rptNo = reportStatusLdDesc.substring(7);
                    				
                    				logger.info("[LABAP] Update BL-M status Key=" + recKey + " LABNUM=" + labnum + " RPTNO=" + rptNo);                    		
		                    		
                        			psUpdate_1.setString(1, recKey ) ;
                        			psUpdate_1.setString(2, labnum) ;
            						psUpdate_1.setString(3, rptNo) ;            						
                        			psUpdate_1.executeUpdate();
                        			psUpdate_1.clearParameters(); 
                    			}                    			
                    		}
                    		                   		    						
                    	}
                    }            	
                    
               	} catch (Exception e) {
//20190122 Arran add log for exception               		
               		for (int i = 0; i < ehrLogNoList.size(); i++) {
               			psLogHeaderUpd.setString(1, "exception");
               			psLogHeaderUpd.setString(2, e.getMessage());
               			psLogHeaderUpd.setString(3, ehrLogNoList.get(i));
               			psLogHeaderUpd.setString(4, "BL-M");
               			psLogHeaderUpd.executeUpdate();
               			psLogHeaderUpd.clearParameters();
               		}
               		          
					logger.info("[LABAP] send BL-M error : " + e.getMessage() );
					e.printStackTrace();
				}
            }
            Thread.sleep(2000);            
            
            if ( pMap_BL.size() > 0 ) {
//send BL            	
            	logger.info("[LABAP] Send BL: " + pMap_BL.size());
            	try {
            		response = heprWebServiceClient.uploadLabapData(pMap_BL, fileMap_BL, "BL");
//write log            		
            		for (int i = 0; i < ehrLogNoList.size(); i++) {
            			psLogHeaderUpd.setString(1, response.getResponseCode());
            			psLogHeaderUpd.setString(2, response.getResponseMessage());
            			psLogHeaderUpd.setString(3, ehrLogNoList.get(i));
            			psLogHeaderUpd.setString(4, "BL");
            			psLogHeaderUpd.executeUpdate();
            			psLogHeaderUpd.clearParameters();
            		}
            		
//update labo_report_log status          
                    for(Map.Entry<Participant,List> entry : pMap_BL.entrySet()) {
                    	detailList = entry.getValue();
                    	
                    	for(LabResultAPDetail d : detailList) {          
                    		
                    		tranType =  d.getLabReqData().get(0).getTransactionType();
                    		recKey = d.getLabReqData().get(0).getRecordKey();
                    		String labnum = d.getLabReqData().get(0).getRequestNo();
                    		
                   			if ( "D".equals(tranType) ) {
                   				logger.info("[LABAP] Update BL status tranType=" + tranType + " Key=" + recKey + " LABNUM=" + labnum );
                   				
                   				psUpdate_D.setString(1, recKey ) ;
                   				psUpdate_D.executeUpdate();
                   				psUpdate_D.clearParameters();
                   				
                   			} else {                    		                   				
		                		for (LabReportData r : d.getLabReportData()) {
		                			String reportStatusLdDesc = r.getReportStatusLtDesc();
		                			if (reportStatusLdDesc.length() > 7) {
		                				rptNo = reportStatusLdDesc.substring(7);
		                				
		                				logger.info("[LABAP] Update BL status tranType=" + tranType + " Key=" + recKey + " LABNUM=" + labnum + " RPTNO=" + rptNo);                    		
			                    		
		                    			psUpdate_1.setString(1, recKey ) ;
		                    			psUpdate_1.setString(2, labnum) ;
		        						psUpdate_1.setString(3, rptNo) ;		        						
		                    			psUpdate_1.executeUpdate();
		                    			psUpdate_1.clearParameters(); 
		                			}                    			
		                		}
                   			}                    		                   		    						
                    	}                    	                                         
                    }      		
            		
            	} catch (Exception e) {
 //20190122 Arran add log for exception               		
               		for (int i = 0; i < ehrLogNoList.size(); i++) {
               			psLogHeaderUpd.setString(1, "exception");
               			psLogHeaderUpd.setString(2, e.getMessage());
               			psLogHeaderUpd.setString(3, ehrLogNoList.get(i));
               			psLogHeaderUpd.setString(4, "BL");
               			psLogHeaderUpd.executeUpdate();
               			psLogHeaderUpd.clearParameters();
               		}

					logger.info("[LABAP] send BL error : " + e.getMessage() );
					e.printStackTrace();
				}
            }
            Thread.sleep(2000);
 
            logger.info("[LABAP] Complete");
			
        } catch (Exception e) {
            logger.info("[LABAP] Error : " + e.getMessage() );
            e.printStackTrace();
            
        } finally {
        	try {
        		if (rs != null)
        			rs.close();
        		
        		if (rsLogNo != null)
        			rsLogNo.close();
        		
        		if (psReport != null)
        			psReport.close();
        		
        		if (psLogHeader != null)
        			psLogHeader.close();
        		
        		if (psLogHeaderUpd != null)
        			psLogHeaderUpd.close();   		
        		
        		if (psUpdate_1 != null)
        			psUpdate_1.close();

        		if (psUpdate_2 != null)
        			psUpdate_2.close();
        		
        		if (psUpdate_3 != null)
        			psUpdate_3.close();
        		
        		if (psUpdate_error != null)
        			psUpdate_error.close();
        		
        		if (psUpdate_D != null)
        			psUpdate_D.close();
        		
        		if (psLogNo != null)
        			psLogNo.close();
        		
        		ConnUtil.closeConnection(conn);
        		ConnUtil.closeConnection(connHATS);        		        		
        		
        	} catch(Exception e) {
                logger.info("[LABAP] Cannot close connection");
                e.printStackTrace();
        	}
        }       
	}
}