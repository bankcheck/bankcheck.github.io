package hkah;

import hk.gov.ehr.hepr.ws.Response;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.hl7.v3.Participant;
import org.hl7.v3.RxdDetail;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import test.client.HeprWebServiceClient;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.ehr.common.FactoryBase;
import com.hkah.util.db.ConnUtil;
@Service()
public class RxdDeleteScheduler {
	protected static Logger logger = Logger.getLogger(RxdDeleteScheduler.class);
	
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
            conn = ConnUtil.getDataSourcePHAR().getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            			
            if (rs.next()) {
            	this.recordKey = rs.getString(1);
            	logger.debug("gen key:" + this.recordKey);         	
            }
                        
        } catch (Exception e) {
        	logger.error("Cannot generate record key");
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
	
	// participant(String patno) : get patient data from hats' ehr_pmi table
	private Participant participant(String patno){
		
		Participant p = new Participant();
		
        PreparedStatement ps = null;
        PreparedStatement ps_hats = null;
        Connection conn = null;
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
       	
        	sql = "select ehrno, ehrfname || ', ' || ehrgname as fullname, ehrhkid, ehrdocno, ehrdoctype, ehrdob, ehrsex from ehr_pmi where patno = ? and active = -1" ;
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
        	logger.error("Participant Error, patno:" + patno );
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
        		
        		ConnUtil.closeConnection(conn);
        		ConnUtil.closeConnection(conn_hats);
        	} catch(Exception e) {
        		logger.error("Cannot close connection");
                e.printStackTrace();
        	}
        }
        
        return p; 
	}

//	@Scheduled(cron="0/20 * * * * ?")	// every 20 seconds
//	@Scheduled(cron="0 0 15 * * ?")		3:00:00pm
//  @Scheduled(cron="0 0 0/1 * * ?")
//  testing : per 10 mins
//	@Scheduled(cron="0 0/5 * * * ?")
//  production :
//	@Scheduled(cron="0 0 20 * * ?")		// 8:00:00pm
	public void ehrSchedule(){
		
        PreparedStatement psReport = null;
        PreparedStatement psInsRxdLog = null;
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
        
        Long ehrRxdLogNo = null ;
        
        Participant p;
        //RadiologyDetail d;
        
        //Map<String,File> fileMap;
        Map<String,File> fileMap_BL = new HashMap<String,File>() ;
        Map<String,File> fileMap_BL_M = new HashMap<String,File>() ;

		//List<String> ehrRxdLogList = new ArrayList<String>() ;
		List<String> ehrRxdLogList_BL = new ArrayList<String>() ;
		List<String> ehrRxdLogList_BL_M = new ArrayList<String>() ;
        
	    Response response = null;
        
	    logger.info("Start");

        // 20150417
		//Map<Participant,List> pMap = new HashMap<Participant,List>();
		Map<Participant,RxdDetail> pMap_BL = new HashMap<Participant,RxdDetail>();
		Map<Participant,RxdDetail> pMap_BL_M = new HashMap<Participant,RxdDetail>();
		
		ApplicationContext context = new ClassPathXmlApplicationContext("ClientContext.xml");
		HeprWebServiceClient heprWebServiceClient = (HeprWebServiceClient) context.getBean("HeprWebServiceClient");

		//List<RadiologyDetail.RadDetail> detailList ;
		RxdDetail rxdDetail ;
		RxdDetail.DispensaryInst rxdDispensaryInst ;
		RxdDetail.DispensedDrug rxdDispensedDrug ; 

        Calendar cal = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
        
		try {
 	        sql = "select sq_ehr_rxd_log_no.nextval ehr_rxd_log_no, transaction_dtm, upload_mode, ehr_record_key, patno, episode_no, attendance_inst_id, dispensing_dtm, prescription_order_no, dispensed_drug_seq_no, dispensed_drug_code_lt, dispensed_drug_desc_lt, dose_instruction, " +
		          " ehrno, fullname, ehrhkid, ehrdocno, ehrdoctype, ehrdob_dtm, ehrsex, " +
 	              " dispensing_inst_id, dispensing_inst_long_name, dispensing_inst_local_name, record_creation_dtm, record_creation_inst_id, record_creation_inst_name, record_update_dtm, record_update_inst_id, record_update_inst_name " +
		          " from ehr_rxd_delete " ;
 	        conn = ConnUtil.getDataSourcePHAR().getConnection();
 	        psReport = conn.prepareStatement(sql);
 	        rs = psReport.executeQuery();

			sql = "insert into ehr_rxd_log ( ehr_rxd_log_no, ehr_no, patientkey, hkid, doc_type, doc_no, person_eng_surname, person_eng_given_name, person_eng_full_name, sex, birth_date, uploadmode, record_key, transaction_dtm, transaction_type, last_update_dtm, episode_no, attendance_inst_id, dispensing_dtm, dispensing_inst_id, dispensing_inst_long_name, dispensing_inst_local_name, prescription_order_no, dispensed_drug_seq_no, dispensed_drug_code_lt, dispensed_drug_desc_lt, dose_instruction, record_creation_dtm, record_creation_inst_id, record_creation_inst_name, record_update_dtm, record_update_inst_id, record_update_inst_name ) " +
				  " values (?,?,?,?,?,?,?,?,?,?," +
				           "?,?,?,?,?,?,?,?,?,?," +
				           "?,?,?,?,?,?,?,?,?,?, ?,?,?)"; // 33 columns
			psInsRxdLog = conn.prepareStatement(sql);
			
			sql = "update ehr_pmi set initrxd = sysdate where patno = ?" ;
			conn_hats = ConnUtil.getDataSourceHATS().getConnection();
			psUpdPmi = conn_hats.prepareStatement(sql);
            
            sql = "update ehr_rxd_log set return_code = ?, return_message = ? where ehr_rxd_log_no = ? " ;
            psUpdLog = conn.prepareStatement(sql);
            
			while (rs.next()) {
				logger.info("query pooling" );

            	patno = rs.getString("patno");

            	logger.debug("[RxdDeleteScheduler] patno: " + patno );
            	
            	ehrRxdLogNo = rs.getLong("ehr_rxd_log_no") ;
            	
            	this.uploadMode = rs.getString("upload_mode") ;
            	this.updRecordKey = rs.getString("ehr_record_key") ;
            	
            	/*
    			if ( getUploadMode().equals("BL-M") || getUpdRecordKey().equals("NULL") ) {
    				this.transactionType = "I" ;
    			} else {
    				this.transactionType = "U" ;
    			}
    			*/
            	this.transactionType = "D" ;
            	
            	
            
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
				logger.debug("debug 1 : ehrdob_dtm = " + rs.getString("ehrdob_dtm") );
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
					rxdDetail = new RxdDetail() ;
					rxdDispensaryInst = new RxdDetail.DispensaryInst() ;
					rxdDispensedDrug = new RxdDetail.DispensedDrug();
					

					rxdDetail.setRecordKey(getRecordKey());
					rxdDetail.setTransactionType(getTransactionType());
					rxdDetail.setTransactionDtm(sdf.format(cal.getTime()));
					rxdDetail.setLastUpdateDtm(sdf.format(cal.getTime()));
					// hats regid
					rxdDetail.setEpisodeNo(rs.getString("episode_no"));
					rxdDetail.setAttendanceInstId(rs.getString("attendance_inst_id"));
					rxdDetail.setDispensingDtm(rs.getString("dispensing_dtm"));
					rxdDetail.setPrescriptionOrderNo(rs.getString("prescription_order_no"));

					rxdDispensedDrug.setDispensedDrugSeqNo(rs.getString("dispensed_drug_seq_no"));
					rxdDispensedDrug.setDispensedDrugCodeLt(rs.getString("dispensed_drug_code_lt"));
					rxdDispensedDrug.setDispensedDrugDescLt(rs.getString("dispensed_drug_desc_lt"));
					rxdDispensedDrug.setDoseInstruction(rs.getString("dose_instruction")) ;
					
					//rxdDispensaryInst.setDispensingInstId(rs.getString("dispensing_inst_id"));
					//rxdDispensaryInst.setDispensingInstLongName(rs.getString("dispensing_inst_long_name"));
					//rxdDispensaryInst.setDispensingInstLocalName(rs.getString("dispensing_inst_local_name"));

					logger.debug("debug : hcp_id, hcp_name = " + FactoryBase.getInstance().getSysparamValue("hcp_id") + ", " + FactoryBase.getInstance().getSysparamValue("hcp_name") ) ; 
					rxdDispensaryInst.setDispensingInstId(FactoryBase.getInstance().getSysparamValue("hcp_id"));
					rxdDispensaryInst.setDispensingInstLongName(FactoryBase.getInstance().getSysparamValue("hcp_name"));
					//rxdDispensaryInst.setDispensingInstLocalName(ConstantsServerSide.SITE_CODE);
					// accord to mary
					rxdDispensaryInst.setDispensingInstLocalName(FactoryBase.getInstance().getSysparamValue("hcp_name"));
					
					rxdDetail.setRecordCreationDtm(rs.getString("record_creation_dtm"));
					//rxdDetail.setRecordCreationInstId(rs.getString("record_creation_inst_id"));
					//rxdDetail.setRecordCreationInstName(rs.getString("record_creation_inst_name"));
					rxdDetail.setRecordCreationInstId(FactoryBase.getInstance().getSysparamValue("hcp_id"));
					rxdDetail.setRecordCreationInstName(FactoryBase.getInstance().getSysparamValue("hcp_name"));
					rxdDetail.setRecordUpdateDtm(rs.getString("record_update_dtm"));
					//rxdDetail.setRecordUpdateInstId(rs.getString("record_update_inst_id"));
					//rxdDetail.setRecordUpdateInstName(rs.getString("record_update_inst_name"));
					rxdDetail.setRecordUpdateInstId(FactoryBase.getInstance().getSysparamValue("hcp_id"));
					rxdDetail.setRecordUpdateInstName(FactoryBase.getInstance().getSysparamValue("hcp_name"));

					// testing
					
					rxdDetail.setDispensaryInst( rxdDispensaryInst );
					rxdDetail.setDispensedDrug( rxdDispensedDrug );

					if ( rs.getString("upload_mode").equals("BL") ) {
						//pMap_BL.put(p,detailList);
						pMap_BL.put(p,rxdDetail) ;
						ehrRxdLogList_BL.add(rs.getString("ehr_rxd_log_no"));
					} else {
						//pMap_BL_M.put(p,detailList);
						pMap_BL_M.put(p,rxdDetail);
						ehrRxdLogList_BL_M.add(rs.getString("ehr_rxd_log_no"));
					}
					

					// 20150417 : replaced by batch web service request
					//response = heprWebServiceClient.uploadRadData(pMap, fileMap, "BL-M");

					//if (response!= null) {
					//	logger.debug("Return code: " + response.getResponseCode() + " Return message: " + response.getResponseMessage());
					//}
					//
										
					psInsRxdLog.setString(1, rs.getString("ehr_rxd_log_no")) ;
					psInsRxdLog.setString(2, p.getEhrNo());
					psInsRxdLog.setString(3, p.getPatientKey());
					psInsRxdLog.setString(4, p.getHkid());
					psInsRxdLog.setString(5, p.getDocType());
					psInsRxdLog.setString(6, p.getDocNo());
					psInsRxdLog.setString(7, p.getPersonEngSurname());
					psInsRxdLog.setString(8, p.getPersonEngGivenName());
					psInsRxdLog.setString(9, p.getPersonEngFullName());
					psInsRxdLog.setString(10, p.getSex());
		            //logger.debug("debug 2 : p.getBirthDate() 2 " + p.getBirthDate() );
					psInsRxdLog.setString(11, p.getBirthDate());
					
					psInsRxdLog.setString(12, rs.getString("upload_mode"));
					psInsRxdLog.setString(13, getRecordKey());
					
					psInsRxdLog.setString(14, rxdDetail.getTransactionDtm() ) ;
					psInsRxdLog.setString(15, rxdDetail.getTransactionType() ) ;
					psInsRxdLog.setString(16, rxdDetail.getLastUpdateDtm() ) ;
					psInsRxdLog.setString(17, rxdDetail.getEpisodeNo() ) ;
					psInsRxdLog.setString(18, rxdDetail.getAttendanceInstId() ) ;
					
					psInsRxdLog.setString(19, rxdDetail.getDispensingDtm() ) ;
					psInsRxdLog.setString(20, rxdDispensaryInst.getDispensingInstId() ) ;
					psInsRxdLog.setString(21, rxdDispensaryInst.getDispensingInstLongName() ) ;
					psInsRxdLog.setString(22, rxdDispensaryInst.getDispensingInstLocalName() ) ;
					
					psInsRxdLog.setString(23, rxdDetail.getPrescriptionOrderNo() ) ;
					
					psInsRxdLog.setString(24, rxdDispensedDrug.getDispensedDrugSeqNo() ) ;
					psInsRxdLog.setString(25, rxdDispensedDrug.getDispensedDrugCodeLt() ) ;
					psInsRxdLog.setString(26, rxdDispensedDrug.getDispensedDrugDescLt() ) ;
					psInsRxdLog.setString(27, rxdDispensedDrug.getDoseInstruction() ) ;

					psInsRxdLog.setString(28, rxdDetail.getRecordCreationDtm() ) ;
					psInsRxdLog.setString(29, rxdDetail.getRecordCreationInstId() ) ;
					psInsRxdLog.setString(30, rxdDetail.getRecordCreationInstName() ) ;

					psInsRxdLog.setString(31, rxdDetail.getRecordUpdateDtm() ) ;
					psInsRxdLog.setString(32, rxdDetail.getRecordUpdateInstId() ) ;
					psInsRxdLog.setString(33, rxdDetail.getRecordUpdateInstName() ) ;

					psInsRxdLog.executeUpdate();
					psInsRxdLog.clearParameters();

	            
				// for both BL / BL-M

				// just for BL-M
				if (rs.getString("upload_mode").equals("BL-M")) {
					psUpdPmi.setString(1, patno ) ;
					psUpdPmi.executeUpdate();
					psUpdPmi.clearParameters();
				}
            }
			
            if ( pMap_BL.size() > 0 ) {
            	logger.debug("call heprWebServiceClient, BL");
            	response = heprWebServiceClient.uploadRxdData(pMap_BL, fileMap_BL, "BL");
            	for (Map.Entry<String, File> entry : fileMap_BL.entrySet()) {
                	//entry.getValue().delete() ;
            	}
                for (int i = 0; i < ehrRxdLogList_BL.size(); i++) {
                    psUpdLog.setString(1, response.getResponseCode());
                    psUpdLog.setString(2, response.getResponseMessage());
                    psUpdLog.setString(3, ehrRxdLogList_BL.get(i));
                    psUpdLog.executeUpdate();
                    psUpdLog.clearParameters();
        		}

            }
            
            Thread.sleep(2000);
            
            if ( pMap_BL_M.size() > 0 ) {
            	logger.info("call heprWebServiceClient, BL-M");
            	response = heprWebServiceClient.uploadRxdData(pMap_BL_M, fileMap_BL_M, "BL-M");
            	for (Map.Entry<String, File> entry : fileMap_BL_M.entrySet()) {
                	//entry.getValue().delete() ;
            	}
                for (int i = 0; i < ehrRxdLogList_BL_M.size(); i++) {
                    psUpdLog.setString(1, response.getResponseCode());
                    psUpdLog.setString(2, response.getResponseMessage());
                    psUpdLog.setString(3, ehrRxdLogList_BL_M.get(i));
                    psUpdLog.executeUpdate();
                    psUpdLog.clearParameters();
        		}
            }
           
            logger.info("Complete");
			
        } catch (Exception e) {
        	logger.error("Error");
            e.printStackTrace();
            
        } finally {
        	try {
        		if (rs != null)
        			rs.close();
        		
        		if (psReport != null)
        			psReport.close();
        		
        		if (psInsRxdLog != null)
        			psInsRxdLog.close();
        		
        		if (psUpdPmi != null)
        			psUpdPmi.close();

        		if (psUpdLog != null)
        			psUpdLog.close();

        		ConnUtil.closeConnection(conn);
        		ConnUtil.closeConnection(conn_hats);
        		
        	} catch(Exception e) {
        		logger.error("Cannot close connection");
                e.printStackTrace();
        	}
        }
	}
}