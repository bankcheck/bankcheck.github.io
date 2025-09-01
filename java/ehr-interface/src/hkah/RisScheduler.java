package hkah;

import hk.gov.ehr.hepr.ws.*;

import org.hl7.v3.RadiologyDetail.*;
import org.hl7.v3.LabResultGenDetail;
import org.hl7.v3.Participant;
import org.hl7.v3.RadiologyDetail;

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

import javax.jws.*;
import javax.xml.soap.*;
import javax.xml.transform.*;
import javax.xml.transform.stream.*;

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
@Service()
public class RisScheduler {

	private String uploadMode ;
	private String updRecordKey ; 
	private String transactionType ;
	private String recordKey;

	private String getUploadMode() {
		return uploadMode;
	}
	private String getUpdRecordKey() {
		return updRecordKey;
	}
	private String getTransactionType() {
		return transactionType;
	}
	private String getRecordKey() {
		return recordKey;
	}
	
	private void generateKey() {
        this.recordKey = null;
        
        PreparedStatement ps = null;
        Connection conn = null;
        ResultSet rs = null;
        String sql;
                
		try {
			
            sql = "select to_char(ehr_seq.nextval) from dual";
            conn = ConnUtil.getDataSourceCIS().getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            			
            if (rs.next()) {
            	this.recordKey = rs.getString(1);
                System.out.println("[RisScheduler] gen key:" + this.recordKey);         	
            }
                        
        } catch (Exception e) {
            System.out.println("[RisScheduler] Cannot generate record key");
            e.printStackTrace();
            
        } finally {
        	try {
        		if (rs != null)
        			rs.close();
        		
        		if (ps != null)
        			ps.close();
        		
        		ConnUtil.closeConnection(conn);
        	} catch(Exception e) {
                System.out.println("[RisScheduler] Cannot close connection");
                e.printStackTrace();
        	}
        }
        
	}
	
	private String getHKCTTDesc(String TermID){
        PreparedStatement ps = null;
        Connection conn = null;
        ResultSet rs = null;
        String sql;
        String desc = null;
        
		try {
			
        	sql = "select ehr_desc from labm_hkctt " +
        			" where term_id = ? ";
        	conn = ConnUtil.getDataSourceCIS().getConnection();
        	ps = conn.prepareStatement(sql);
            ps.setString(1, TermID);
            rs = ps.executeQuery();
            
            if (!rs.next()) {
            	System.out.println("[RisScheduler] HKCTT not found: " + TermID);
            } else {
            	desc = rs.getString("ehr_desc");
            }
                                    
        } catch (Exception e) {
            System.out.println("[RisScheduler] HKCTT error: " + TermID);
            e.printStackTrace();
            
        } finally {
        	try {
        		if (rs != null)
        			rs.close();
        		
        		if (ps != null)
        			ps.close();
        		
        		ConnUtil.closeConnection(conn);
        	} catch(Exception e) {
                System.out.println("[RisScheduler] Cannot close connection");
                e.printStackTrace();
        	}
        }
        
        return desc;
	}
	
	// participant(String patno) : get patient data from hats' ehr_pmi table
	private Participant participant(String patno){
		
		Participant p = new Participant();
		
        PreparedStatement ps = null;
        PreparedStatement ps_hats = null;
        Connection conn_hats = null;
        ResultSet rs = null;
        ResultSet rs_hats = null;
        
        String sql;
        String sex;
        String birthdate;
        String ehrno;
        String hkid;
        String fullname;
        String doctype;
        
        
		try {
        	//birthdate = rs.getString("birth_date");
        	//sex = rs.getString("sex");
       	
        	sql = "select ehrno, decode( ehrfname, null, '', ehrfname || ', ' ) || ehrgname as fullname, ehrhkid, ehrdocno, ehrdoctype, ehrdob, ehrsex from ehr_pmi where patno = ? and active = -1" ;
        	conn_hats = ConnUtil.getDataSourceHATS().getConnection();
        	ps_hats = conn_hats.prepareStatement(sql);
        	ps_hats.setString(1, patno);
        	rs_hats = ps_hats.executeQuery();
        	
        	if (!rs_hats.next()) {
        		return null;
        	} else {
				//p.setBirthDate(birthdate);
				//p.setSex(sex);
				//p.setEhrNo(rs_hats.getString("patehrno"));
				//p.setPatientKey(patno);
        		//p.setHkid(rs_hats.getString("patehrhkid"));
				//p.setDocType(rs_hats.getString("patehrdoctype"));
				//p.setPersonEngFullName(rs_hats.getString("fullname"));

        		ehrno = rs_hats.getString("ehrno") ;
        		hkid = rs_hats.getString("ehrhkid");
        		doctype = rs_hats.getString("ehrdoctype");
        		fullname = rs_hats.getString("fullname");

        		// use [hats]ehr_pmi instead of [lis]labo_masthead
            	birthdate = rs_hats.getString("ehrdob");
            	sex = rs_hats.getString("ehrsex");
        	}

        	// testing : begin
        	/*
        	if (sex.equals("M")) {
        		patno = "400001";
        		birthdate = "1932-01-01 00:00:00.000";
        		ehrno = "669995154023";
        		hkid = "U0000210";
        		fullname = "CHAN, PEAR";
        	} else {
        		patno = "400002";
        		birthdate = "1978-08-20 00:00:00.000";
        		ehrno = "896344899686";
        		hkid = "U0000229";
        		fullname = "SZE TO, HAPPY";
        	}
        	doctype = "ID";
        	*/
        	// testing : end
        	
			p.setBirthDate(birthdate);
			p.setSex(sex);
			p.setEhrNo(ehrno);
			p.setPatientKey(patno);
			p.setHkid(hkid);
			p.setDocType(doctype);
			p.setPersonEngFullName(fullname);

        } catch (Exception e) {
            System.out.println("[RisScheduler] Participant Error, patno:" + patno );
            e.printStackTrace();
            
        } finally {
        	try {
        		if (rs != null)
        			rs.close();
        		
        		if (ps != null)
        			ps.close();
        		
        		if (rs_hats != null)
        			rs_hats.close();
        		
        		if (ps_hats != null)
        			ps_hats.close();
        		
        		ConnUtil.closeConnection(conn_hats);
        	} catch(Exception e) {
                System.out.println("[RisScheduler] Cannot close connection");
                e.printStackTrace();
        	}
        }
        
        return p; 
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
	

//	@Scheduled(cron="0/20 * * * * ?")	// every 20 seconds
//	@Scheduled(cron="0 0/1 * * * ?") 	// every 1 minutes
//  @Scheduled(cron="0 0 0/1 * * ?")
//  testing : per 10 mins
//	@Scheduled(cron="0 0/10 * * * ?")
//  production :    
//	@Scheduled(cron="0 0 20 * * ?")		// 8:00:00pm
    
    
//	@Scheduled(cron="0 0/10 * * * ?")
    public void ehrSchedule(){
		
        PreparedStatement psReport = null;
        PreparedStatement psInsRadLog = null;
        PreparedStatement psUpdPmi = null;
        PreparedStatement psUpdLog = null;
        Connection conn = null;
        Connection conn_hats = null;
        ResultSet rs = null;
        String sql;
        String ori_path = null;
        String tmp_path = null;
        
        
        // key
        String patno;
        String fname;
        // replace . with -
        String ehr_fname;
        
        Long ehrRadLogNo = null ;
        
        Participant p;
        //RadiologyDetail d;
        
        //Map<String,File> fileMap;
        Map<String,File> fileMap_BL = new HashMap<String,File>() ;
        Map<String,File> fileMap_BL_M = new HashMap<String,File>() ;

		//List<String> ehrRadLogList = new ArrayList<String>() ;
		List<String> ehrRadLogList_BL = new ArrayList<String>() ;
		List<String> ehrRadLogList_BL_M = new ArrayList<String>() ;
        
        java.io.File reportPdf ;
        //String reportSrcBasePath = "\\\\160.100.2.79\\d$\\mrpdf\\" ;
        String reportSrcBasePath = FactoryBase.getInstance().getSysparamValue(ConstantsEhr.SYSPARAM_RIS_REPORT_SOURCE_PATH);
        String reportTmpBasePath = FactoryBase.getInstance().getSysparamValue(ConstantsEhr.SYSPARAM_RIS_REPORT_TEMP_PATH);
        SmbFile smbFile = null ;
        
		File attachment = null ;
		File destDirFile = null ;
		String login_user = FactoryBase.getInstance().getSysparamValue(ConstantsEhr.SYSPARAM_SMB_USERNAME);
	    String login_pass = FactoryBase.getInstance().getSysparamValue(ConstantsEhr.SYSPARAM_SMB_PASSWORD);

	    Response response = null;
        
        System.out.println("[RisScheduler] Start");

        // 20150417
		//Map<Participant,List> pMap = new HashMap<Participant,List>();
		Map<Participant,RadiologyDetail> pMap_BL = new HashMap<Participant,RadiologyDetail>();
		Map<Participant,RadiologyDetail> pMap_BL_M = new HashMap<Participant,RadiologyDetail>();
		
		ApplicationContext context = new ClassPathXmlApplicationContext("ClientContext.xml");
		HeprWebServiceClient heprWebServiceClient = (HeprWebServiceClient) context.getBean("HeprWebServiceClient");

		//List<RadiologyDetail.RadDetail> detailList ;
		RadiologyDetail radioLogyDetail ;
		RadiologyDetail.RadDetail radDetail ;
		RadiologyDetail.RadDetail.RadExamDetail radExamDetail ; 

        Calendar cal = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
        
		try {
 	        sql = "select sq_ehr_rad_log_no.nextval ehr_rad_log_no, upload_mode, ehr_record_key, patno, regid, ris_accession_no, rpt_version, rpt_dtm, rpt_by, fname, folder, " + 
 					 " exam_dtm, modality, exam_name, ehrno, fullname, ehrhkid, ehrdocno, ehrdoctype, ehrdob_dtm, ehrsex from ehr_rad_pending where rownum <= 150 " ;
 	        conn = ConnUtil.getDataSourceCIS().getConnection();
 	        psReport = conn.prepareStatement(sql);
 	        rs = psReport.executeQuery();

			sql = "insert into ehr_rad_log ( ehr_rad_log_no, report_name, ehr_no, patientkey, hkid, doc_type, doc_no, person_eng_surname, person_eng_given_name, person_eng_full_name, sex, birth_date, uploadmode, record_key, transaction_dtm, transaction_type, last_update_dtm, episode_no, attendance_inst_id, rad_image_accession_no, rad_request_no, record_creation_dtm, record_creation_inst_id, record_creation_inst_name, record_update_dtm, record_update_inst_id, record_update_inst_name, exam_dtm, modality_cd, exam_name, report_dtm, file_ind, file_name, rpt_version) " +
				  " values (?,?,?,?,?,?,?,?,?,?," +
				           "?,?,?,?,?,?,?,?,?,?," +
				           "?,?,?,?,?,?,?,?,?,?, ?,?,?,?)"; // 34 columns
			psInsRadLog = conn.prepareStatement(sql);
			
			sql = "update ehr_pmi set initris = sysdate where patno = ?" ;
			conn_hats = ConnUtil.getDataSourceHATS().getConnection();
			psUpdPmi = conn_hats.prepareStatement(sql);
            
            sql = "update ehr_rad_log set return_code = ?, return_message = ? where ehr_rad_log_no = ? " ;
            psUpdLog = conn.prepareStatement(sql);
            
//            System.out.println("[RisScheduler] query pooling" );
			while (rs.next()) {

            	patno = rs.getString("patno");
            	fname = rs.getString("fname");

				System.out.println("[RisScheduler] patno: " + patno + " fname: " + fname );
            	
            	ehrRadLogNo = rs.getLong("ehr_rad_log_no") ;
            	
            	this.uploadMode = rs.getString("upload_mode") ;
            	this.updRecordKey = rs.getString("ehr_record_key") ;
    			//if ( getUploadMode().equals(ConstantsEhr.UPLOAD_MODE_NAME_BLM) || getUpdRecordKey().equals("NULL") ) {
            	if ( getUploadMode().equals("BL-M") || getUpdRecordKey().equals("NULL") ) {
    				this.transactionType = "I" ;
    			} else {
    				this.transactionType = "U" ;
    			}
            	
            
				// 20150417 : following line is moved before the while loop
				//ApplicationContext context = new ClassPathXmlApplicationContext("ClientContext.xml");
				//HeprWebServiceClient heprWebServiceClient = (HeprWebServiceClient) context.getBean("HeprWebServiceClient");
				
                // 20150417 : following line is moved before the while loop
				// Map<Participant,List> pMap = new HashMap<Participant,List>();
				//fileMap = new HashMap<String,File>();
				
				// set participant
				//p = participant(patno);
				p = new Participant() ;
				p.setSex( rs.getString("ehrsex") );

				// production
	            System.out.println("[RisScheduler] debug 1 : ehrdob_dtm = " + rs.getString("ehrdob_dtm") );
	            p.setBirthDate( rs.getString("ehrdob_dtm") );
				p.setEhrNo( rs.getString("ehrno") );
				p.setPatientKey( rs.getString("patno") );
				p.setHkid( rs.getString("ehrhkid") );
				p.setDocNo( rs.getString("ehrdocno") );
				p.setDocType( rs.getString("ehrdoctype") );
				p.setPersonEngFullName( rs.getString("fullname") );
				
				// testing
				/*
	        	if (p.getSex().equals("M")) {
	        		p.setPatientKey("400001") ;
	        		p.setBirthDate( "1932-01-01 00:00:00.000" ) ;
	        		p.setEhrNo( "669995154023" ) ;
	        		p.setHkid( "U0000210" ) ;
	        		p.setPersonEngFullName( "CHAN, PEAR" ) ;
	        	} else {
	        		p.setPatientKey("400002") ;
	        		p.setBirthDate( "1978-08-20 00:00:00.000" ) ;
	        		p.setEhrNo( "896344899686" ) ;
	        		p.setHkid( "U0000229" ) ;
	        		p.setPersonEngFullName( "SZE TO, HAPPY" ) ;
	        	}
	        	*/
				
					//generate record key
					//generateKey();
					if ( getTransactionType().equals("I") ) {
						generateKey();
					} else {
						this.recordKey = getUpdRecordKey() ;
					}
					
					//detailList = new ArrayList<RadDetail>();
					radDetail = new RadiologyDetail.RadDetail() ;
					radExamDetail = new RadiologyDetail.RadDetail.RadExamDetail() ;
					radioLogyDetail = new RadiologyDetail();

					radDetail.setRecordKey(getRecordKey());
					radDetail.setTransactionType(getTransactionType());
					radDetail.setTransactionDtm(sdf.format(cal.getTime()));
					radDetail.setLastUpdateDtm(sdf.format(cal.getTime()));
					radDetail.setEpisodeNo(rs.getString("regid"));
					radDetail.setRadImageAccessionNo(rs.getString("ris_accession_no"));
					
					//radDetail.setAttendanceInstId("5987754786");
					//radDetail.setRequestInstId("5987754786");
					//radDetail.setRequestInstName("ADV TEST");
					//radDetail.setRequestInstLtDesc("ADV TEST");
					//radDetail.setExamPerformInstId("5987754786");
					//radDetail.setExamPerformInstName("ADV TEST");
					//radDetail.setExamPerfromInstLtDesc("ADV TEST");
					
					System.out.println("[RisScheduler] debug 1.4 : hcp_id, hcp_name = " + FactoryBase.getInstance().getSysparamValue("hcp_id") + ", " + FactoryBase.getInstance().getSysparamValue("hcp_name") ) ; 
					radDetail.setAttendanceInstId(FactoryBase.getInstance().getSysparamValue("hcp_id"));
					radDetail.setRequestInstId(FactoryBase.getInstance().getSysparamValue("hcp_id"));
					radDetail.setRequestInstName(FactoryBase.getInstance().getSysparamValue("hcp_name"));
					
					//radDetail.setRequestInstLtDesc(ConstantsServerSide.SITE_CODE);
					// accord to mary
					radDetail.setRequestInstLtDesc(FactoryBase.getInstance().getSysparamValue("hcp_name"));
					radDetail.setExamPerformInstId(FactoryBase.getInstance().getSysparamValue("hcp_id"));
					radDetail.setExamPerformInstName(FactoryBase.getInstance().getSysparamValue("hcp_name"));
					//radDetail.setExamPerfromInstLtDesc(ConstantsServerSide.SITE_CODE);
					// accord to mary
					radDetail.setExamPerfromInstLtDesc(FactoryBase.getInstance().getSysparamValue("hcp_name"));
					
					radExamDetail.setExamDtm(rs.getString("exam_dtm"));
					radExamDetail.setModalityCd(rs.getString("modality"));
					radExamDetail.setExamName(rs.getString("exam_name"));
					radExamDetail.setReportDtm(rs.getString("rpt_dtm"));
					radExamDetail.setFileInd("1");
					// testing
					
					//ori_path = reportSrcBasePath + "eHR-RIS-pdf\\" + rs.getString("fname") ;
					ori_path = reportSrcBasePath + rs.getString("folder") + "\\" + rs.getString("fname") ;
					//tmp_path = reportTmpBasePath + rs.getString("fname") ;

					ehr_fname = fname.substring(0, fname.length()-4).replace(".", "-") + fname.substring(fname.length()-4, fname.length()) ;
					tmp_path = reportTmpBasePath + ehr_fname ;
		            System.out.println("[RisScheduler] debug 1.5 : file copy to = " + tmp_path );

					
					//radExamDetail.setFileName( rs.getString("fname") ) ;
					radExamDetail.setFileName( ehr_fname ) ;
					
                    // production
					//radExamDetail.setFileName( reportSrcBasePath + rs.getString("folder") + "\\" + rs.getString("fname") );

					//attachment = new File( radExamDetail.getFileName() ) ;
					
					NtlmPasswordAuthentication auth = new NtlmPasswordAuthentication("",login_user, login_pass);
					
					//System.out.println("smb:" + radExamDetail.getFileName() );

					// testing tomcat
					//smbFile = new SmbFile("smb:" + radExamDetail.getFileName(), auth);
					// linux
					smbFile = new SmbFile("smb:" + ori_path.replace("\\", "/"), auth);
					
					System.out.println( smbFile.getPath() ) ; 
					
					//attachment = new File(reportTmpBasePath + rs.getString("fname") ) ;
					destDirFile = new File( reportTmpBasePath ) ;
					attachment = new File( tmp_path ) ;
					try {
						copyFileUsingFileStreams( smbFile, destDirFile, attachment ) ;
					} catch (Exception e) {
						System.out.println("[RisScheduler] copyFileUsingFileStreams Error : " + e.getMessage() );
						e.printStackTrace();
						continue ;
					}
					
					radDetail.getRadExamDetail().add( radExamDetail ) ;

					radioLogyDetail.getRadDetail().add( radDetail );
					//detailList.add( radDetail );

					//if ( rs.getString("upload_mode").equals(FactoryBase.getInstance().getSysparamValue(ConstantsEhr.UPLOAD_MODE_NAME_BL)) ) {
					if ( rs.getString("upload_mode").equals("BL") ) {
						//pMap_BL.put(p,detailList);
						pMap_BL.put(p,radioLogyDetail);
						fileMap_BL.put(attachment.getName(), attachment);
						ehrRadLogList_BL.add(rs.getString("ehr_rad_log_no"));
					} else {
						//pMap_BL_M.put(p,detailList);
						pMap_BL_M.put(p,radioLogyDetail);
						fileMap_BL_M.put(attachment.getName(), attachment);
						ehrRadLogList_BL_M.add(rs.getString("ehr_rad_log_no"));
					}
					

					// 20150417 : replaced by batch web service request
					//response = heprWebServiceClient.uploadRadData(pMap, fileMap, FactoryBase.getInstance().getSysparamValue(ConstantsEhr.UPLOAD_MODE_NAME_BLM));

					//if (response!= null) {
					//	System.out.println("[RisScheduler] Return code: " + response.getResponseCode() + " Return message: " + response.getResponseMessage());
					//}
					//
										
					psInsRadLog.setString(1, rs.getString("ehr_rad_log_no")) ;
					psInsRadLog.setString(2, rs.getString("fname")) ;
					psInsRadLog.setString(3, p.getEhrNo());
					psInsRadLog.setString(4, p.getPatientKey());
					psInsRadLog.setString(5, p.getHkid());
					psInsRadLog.setString(6, p.getDocType());
					psInsRadLog.setString(7, p.getDocNo());
					psInsRadLog.setString(8, p.getPersonEngSurname());
					psInsRadLog.setString(9, p.getPersonEngGivenName());
					psInsRadLog.setString(10, p.getPersonEngFullName());
					psInsRadLog.setString(11, p.getSex());
		            System.out.println("[RisScheduler] debug 2 : p.getBirthDate() 2 " + p.getBirthDate() );
					psInsRadLog.setString(12, p.getBirthDate());
					
					psInsRadLog.setString(13, rs.getString("upload_mode"));
					psInsRadLog.setString(14, getRecordKey());
					
					psInsRadLog.setString(15, radDetail.getTransactionDtm() ) ;
					psInsRadLog.setString(16, radDetail.getTransactionType() ) ;
					psInsRadLog.setString(17, radDetail.getLastUpdateDtm() ) ;
					psInsRadLog.setString(18, radDetail.getEpisodeNo() ) ;
					psInsRadLog.setString(19, radDetail.getAttendanceInstId() ) ;
					psInsRadLog.setString(20, radDetail.getRadImageAccessionNo() ) ;
					psInsRadLog.setString(21, radDetail.getRadRequestNo() ) ;
					psInsRadLog.setString(22, radDetail.getRecordCreationDtm() ) ;
					psInsRadLog.setString(23, radDetail.getRecordCreationInstId() ) ;
					psInsRadLog.setString(24, radDetail.getRecordCreationInstName() ) ;
					psInsRadLog.setString(25, radDetail.getRecordUpdateDtm() ) ;
					psInsRadLog.setString(26, radDetail.getRecordUpdateInstId() ) ;
					psInsRadLog.setString(27, radDetail.getRecordUpdateInstName() ) ;
					psInsRadLog.setString(28, radExamDetail.getExamDtm() ) ;
					psInsRadLog.setString(29, radExamDetail.getModalityCd() ) ;
					psInsRadLog.setString(30, radExamDetail.getExamName() ) ;
					psInsRadLog.setString(31, radExamDetail.getReportDtm() ) ;
					psInsRadLog.setString(32, radExamDetail.getFileInd() ) ;
					psInsRadLog.setString(33, radExamDetail.getFileName() ) ;
					psInsRadLog.setString(34, rs.getString("rpt_version") ) ;
					psInsRadLog.executeUpdate();
					psInsRadLog.clearParameters();

	            
				// for both BL / BL-M

				// just for BL-M
				//if (rs.getString("upload_mode").equals(ConstantsEhr.UPLOAD_MODE_NAME_BLM)) {
				if (rs.getString("upload_mode").equals("BL-M")) {
					psUpdPmi.setString(1, patno ) ;
					psUpdPmi.executeUpdate();
					psUpdPmi.clearParameters();
				}
            }
			
			System.out.println("[RisScheduler] call heprWebServiceClient");
            if ( pMap_BL_M.size() > 0 ) {
	            System.out.println("[RisScheduler] heprWebServiceClient debug 4.1 : pMap_BL_M.size = " + pMap_BL_M.size() );
            	//response = heprWebServiceClient.uploadRadData(pMap_BL_M, fileMap_BL_M, ConstantsEhr.UPLOAD_MODE_NAME_BLM);
	            response = heprWebServiceClient.uploadRadData(pMap_BL_M, fileMap_BL_M, "BL-M");
	            System.out.println("[RisScheduler] heprWebServiceClient debug 4.2 : response " + response.getResponseMessage() );
            	for (Map.Entry<String, File> entry : fileMap_BL_M.entrySet()) {
                	//entry.getValue().delete() ;
            	}
                for (int i = 0; i < ehrRadLogList_BL_M.size(); i++) {
                    psUpdLog.setString(1, response.getResponseCode());
                    psUpdLog.setString(2, response.getResponseMessage());
                    psUpdLog.setString(3, ehrRadLogList_BL_M.get(i));
                    psUpdLog.executeUpdate();
                    psUpdLog.clearParameters();
        		}
            }
            
            Thread.sleep(60000);

            if ( pMap_BL.size() > 0 ) {
	            System.out.println("[RisScheduler] heprWebServiceClient debug 3.1 : pMap_BL.size = " + pMap_BL.size() );
            	//response = heprWebServiceClient.uploadRadData(pMap_BL, fileMap_BL, FactoryBase.getInstance().getSysparamValue(ConstantsEhr.UPLOAD_MODE_NAME_BL));
	            response = heprWebServiceClient.uploadRadData(pMap_BL, fileMap_BL, "BL");
	            System.out.println("[RisScheduler] heprWebServiceClient debug 3.2 : response " + response.getResponseMessage() );
            	for (Map.Entry<String, File> entry : fileMap_BL.entrySet()) {
                	//entry.getValue().delete() ;
            	}
                for (int i = 0; i < ehrRadLogList_BL.size(); i++) {
                    psUpdLog.setString(1, response.getResponseCode());
                    psUpdLog.setString(2, response.getResponseMessage());
                    psUpdLog.setString(3, ehrRadLogList_BL.get(i));
                    psUpdLog.executeUpdate();
                    psUpdLog.clearParameters();
        		}

            }
            
            System.out.println("[RisScheduler] Complete");
			
        } catch (Exception e) {
            System.out.println("[RisScheduler] Error");
            e.printStackTrace();
            
        } finally {
        	try {
        		if (rs != null)
        			rs.close();
        		
        		if (psReport != null)
        			psReport.close();
        		
        		if (psInsRadLog != null)
        			psInsRadLog.close();
        		
        		if (psUpdPmi != null)
        			psUpdPmi.close();

        		if (psUpdLog != null)
        			psUpdLog.close();

        		ConnUtil.closeConnection(conn);
        		ConnUtil.closeConnection(conn_hats);
        		
        	} catch(Exception e) {
                System.out.println("[RisScheduler] Cannot close connection");
                e.printStackTrace();
        	}
        }
	}
}