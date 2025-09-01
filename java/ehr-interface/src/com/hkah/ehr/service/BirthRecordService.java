package com.hkah.ehr.service;

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

import test.client.HeprWebServiceClient;

import com.hkah.constant.ConstantsEhr;
import com.hkah.constant.ConstantsServerSide;
import com.hkah.ehr.common.FactoryBase;
import com.hkah.ehr.model.PatientUploadResp;
import com.hkah.util.DateTimeUtil;
import com.hkah.util.db.ConnUtil;

public class BirthRecordService {
	public static final String EBIRTHDTL_BBWEIGHUNIT_GRAM = "Gram";
	
	private static Logger logger = Logger.getLogger(BirthRecordService.class);
	private DomainCommonService domainCommonService;
	
	public DomainCommonService getDomainCommonService() {
		return domainCommonService;
	}

	public void setDomainCommonService(DomainCommonService domainCommonService) {
		this.domainCommonService = domainCommonService;
	}
	
	/*
	public Response uploadToEhrBirthDetail(String patno, String mode, boolean isUpdatePatInit){
		logger.info("uploadToEhrBirthDetail Start");
		
        Map<Participant, BirthDetail> dmMap = null;
        //Map<Participant, BirthDetail> incMap = new HashMap<Participant, BirthDetail>();
        
		try {
			// get Birth record from
			dmMap = getReadyToUploadBirthDetail(patno, ConstantsEhr.UPLOAD_MODE_CODE_BLM);
			
			// debug
			//listPatientBirthDetails(dmMap);
			
			// upload to eHR
			uploadToEhr(dmMap, ConstantsEhr.UPLOAD_MODE_CODE_BLM, null, null);
			
			// No need to run update and delete mode
			/*
			 * Thread.sleep(1000);
			uploadToEhr(incMap, ConstantsEhr.UPLOAD_MODE_CODE_BL, null, null);
			*//*
			
			// store endDate
			saveLastEndDate(DateTimeUtil.formatDBTimestamp(endDate));
        } catch (Exception e) {
            logger.error("Error: " + e.getMessage());
            e.printStackTrace();
        }
		
		logger.info("End");
	}
	*/
	
	public Response uploadBlankBirthRecord(List<String> patnos) {
		Map<Participant, BirthDetail> map = new HashMap<Participant, BirthDetail>();
		//List<PatientUploadResp> patientUploadResps = domainCommonService.getEhrPatnos(patnos, ConstantsEhr.DOMAIN_CODE_BIRTH);
		
		for (String patno : patnos) {
			 BirthDetail detail = null;
			 map.put(domainCommonService.participant(patno), detail);
		}
		
		return uploadToEhr(map, ConstantsEhr.UPLOAD_MODE_CODE_BLM, null, null, false);
	}
	
	protected Response uploadToEhr(Map<Participant, BirthDetail> map, String mode, Date startDate, Date endDate, boolean isUpdatePatInit){
		logger.info("Upload to eHR mode: " + mode + " , no. of participant: " + map.size() + ", isUpdatePatInit="+isUpdatePatInit);
		
		ApplicationContext context = new ClassPathXmlApplicationContext("ClientContext.xml");
		Response msg = null;
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
	        msg = wsClient.uploadBirthData(map, uploadMode);
	        boolean isSuccess = ConstantsEhr.UPLOAD_SUCCESS_CODES.containsKey(msg.getResponseCode());
	        List<PatientUploadResp> patientUploadResps = new ArrayList<PatientUploadResp>();
	        
	        logger.debug(mode + " upload finish, response:" + msg.getResponseCode() + " - " + msg.getResponseMessage());
	        ArrayList<String> patErrorList = new ArrayList<String>();
	        // BIRTH may not return recordDetail in soap body
	        if (!msg.getRecordDetail().isEmpty()) {
		        for(int i = 0; i < msg.getRecordDetail().size(); i++){
		        	String patno = msg.getRecordDetail().get(i).getPatientKey();
		        	patientUploadResps.add(new PatientUploadResp(patno, msg.getRecordDetail().get(i).getEhrNo(), null));
		        	
		        	logger.debug(mode + " exception (" + msg.getRecordDetail().get(i).getExceptionType() + "): Patno = " + patno + " Desc = " + msg.getRecordDetail().get(i).getExceptionDescription());
		        	if("e".equals(msg.getRecordDetail().get(i).getExceptionType().toLowerCase())){
		        		patErrorList.add(patno);
		        	}
		        }    
	        } else {
                for (Entry<Participant, BirthDetail> entry : map.entrySet()) {
                    Participant p = entry.getKey();
                    BirthDetail detail = entry.getValue();
                    PatientUploadResp patientUploadResp = new PatientUploadResp(p.getPatientKey(), p.getEhrNo(), null);
                    patientUploadResps.add(patientUploadResp);
                    
                    if (!isSuccess) {
                    	patErrorList.add(p.getPatientKey());
                    }
		        }    
	        }
	        
	        // log upload
	        domainCommonService.updateDataUploadLog(patientUploadResps, patErrorList, uploadDate, startDate, endDate, mode, ConstantsEhr.DOMAIN_CODE_BIRTH);
	        
	        // update patient initBirth
	        if (ConstantsEhr.UPLOAD_MODE_CODE_BLM.equals(mode) && isUpdatePatInit) {
	        	if (isSuccess) {
		        	logger.debug(mode + " Update Patient initBirth");
		            for (int i = 0; i < patientUploadResps.size(); i++) {
		            	boolean uploadPatInitBirth = true;
		            	// check if uplaod success
		            	for( String ePatNo : patErrorList){
		            		if(ePatNo.equals(patientUploadResps.get(i).getPatNo())){
		            			uploadPatInitBirth = false;
		            		}
		            	}
		            	
		            	if(uploadPatInitBirth == true) {
		            		domainCommonService.updatePatInit(patientUploadResps.get(i).getPatNo(), ConstantsEhr.DOMAIN_CODE_BIRTH);
		            	}
		            }
		        }
	        }
		}
		
		return msg;
	}
	
	//=== utils ===
	public Map<Participant, BirthDetail> getReadyToUploadBirthDetail(String mode) {
		return getReadyToUploadBirthDetail(null, mode);
	}

	public Map<Participant, BirthDetail> getReadyToUploadBirthDetail(String patno, String mode) {
		Map<Participant, BirthDetail> map = new HashMap<Participant, BirthDetail>();
		PreparedStatement ps = null;
        ResultSet rs = null;
        Connection conn = null;
        String sql;
		
        /*
         * Criteria of birth record ready to upload to eHR (29/04/2016):
         * 1. ebirth status is B (Received)
         * 2. dhbirth status is W (Sending - It is the final status after send if no error)
         * 3. dhbirth senddate should be at least 3 days passed (To confirm reject return)
         * 4. ehr pmi consent is build
         */
		try {
			StringBuffer sqlStr = new StringBuffer();
			// Insert mode only
			sqlStr.append("select  ");
			sqlStr.append("  e.ebirthid, ");
			sqlStr.append("  e.bb_patno, ");
			sqlStr.append("  s.regid, ");
			sqlStr.append("  to_char(e.bb_dob, 'yyyy-mm-dd hh24:mi:ss')||'.000' bb_dob, ");
			sqlStr.append("  e.bb_dobtime, ");
			sqlStr.append("  e.bb_cordcutplace, ");
			sqlStr.append("  e.bb_cordcutplacedesc, ");
			sqlStr.append("  e.BB_BORNB4ARRIVAL, ");
			sqlStr.append("  e.BB_BORNONARRIVAL, ");
			sqlStr.append("  d.WEIGHTATBIRTH, ");
			sqlStr.append("  d.BBWEIGHUNIT, ");
			sqlStr.append("  to_char(e.senddate, 'yyyy-mm-dd hh24:mi:ss')||'.000' comfirmdate, ");	// use senddate as confirm date that send to government
			sqlStr.append("  e.recstatus, ");
			sqlStr.append("  case when p.initbirth is null then 'I' else 'U' end ehrmode, ");
			
			// Participant
			sqlStr.append("	p.ehrno, ");
			sqlStr.append("	p.ehrsex, ");
			sqlStr.append("	to_char(p.ehrdob, 'yyyy-mm-dd hh24:mi:ss')||'.000' ehrdob, ");
			sqlStr.append("	p.ehrfname, ");
			sqlStr.append("	p.ehrgname, ");
			sqlStr.append("	p.ehrhkid, ");
			sqlStr.append("	p.ehrdocno, ");
			sqlStr.append("	p.ehrdoctype, ");
			
			// other
			sqlStr.append("	to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss')||'.000' curdate ");
			
			sqlStr.append("from ebirthdtl e join slip s on e.bb_slpno = s.slpno ");
			sqlStr.append("  join ehr_pmi p on e.bb_patno = p.patno ");
			sqlStr.append("  join dhbirthdtl d on e.bb_patno = d.bbpatno ");
			sqlStr.append("where  ");
			sqlStr.append("  p.active = -1 ");
			sqlStr.append("  and e.recstatus in ('A','B') and e.senddate + 3 < sysdate and d.recstatus = 'W' and d.senddate + 3 < sysdate ");
			if (ConstantsEhr.UPLOAD_MODE_CODE_BLM.equals(mode)) {
				sqlStr.append("  and p.initbirth is null  ");
			} else if (ConstantsEhr.UPLOAD_MODE_CODE_BL.equals(mode)) {
				sqlStr.append("  and p.initbirth is not null  ");
			}
			// do not check initbirth if mode is empty
			if (patno != null) {
				sqlStr.append("  and p.patno = ? ");
			}
			sql = sqlStr.toString();
			
			conn = ConnUtil.getDataSourceHATS().getConnection();
			ps = conn.prepareStatement(sql);
			if (patno != null) {
				ps.setString(1, patno);
			}
			rs = ps.executeQuery();
			
			while (rs.next()) {
				map.put(domainCommonService.newParticipant(
							rs.getString("bb_patno"), 
							rs.getString("ehrno"), 
							rs.getString("ehrdob"), 
							rs.getString("ehrsex"), 
							rs.getString("ehrhkid"), 
							rs.getString("ehrdoctype"), 
							rs.getString("ehrdocno"), 
							rs.getString("ehrfname"), 
							rs.getString("ehrgname")),
							convert2BirthDetail(
								rs.getString("ebirthid"),
								rs.getString("curdate"),
								rs.getString("ehrmode"),
								DateTimeUtil.parseEhrDateTime(rs.getString("comfirmdate")),
								rs.getString("regid"),
								DateTimeUtil.parseEhrDateTime(rs.getString("bb_dob")),
								rs.getString("bb_bornb4arrival"),
								rs.getString("bb_bornonarrival"),
								rs.getString("weightatbirth"),
								rs.getString("bbweighunit")
								));
			}
		} catch (Exception e) {
            logger.error("Error e:" + e.getMessage());
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
		
		return map;
	}
	
	private BirthDetail convert2BirthDetail(
			String ebirthid,
			String transactionDtm,
			String ehrmode,
			Date comfirmdate,
			String regid,
			Date bbDob,
			String isbornb4arrival,
			String isbornonarrival,
			String weightatbirth,
			String bbweighunit
			) {
		String confirmdateEhrFormat = DateTimeUtil.formatEhrDateTime(comfirmdate);
		String bbDobEhrFormat = DateTimeUtil.formatEhrDateTime(bbDob);
		String birthLocCd = convert2BithLocCd(isbornb4arrival, isbornonarrival);
		String birthWeight = convert2BithWeight(weightatbirth, bbweighunit);
		
		return getBirthDetailL3(
				ebirthid,
				transactionDtm,
				ehrmode,
				confirmdateEhrFormat,
				regid,
				FactoryBase.getInstance().getSysparamValue("hcp_id"),
				bbDobEhrFormat,
				getBirthInstCdSiteSpecific(),
				getBirthInstDescSiteSpecific(),
				FactoryBase.getInstance().getSysparamValue("hcp_name"),
				birthLocCd,
				getBirthLocDescByCd(birthLocCd),
				getBirthLocLtDescByCd(birthLocCd),
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				birthWeight,
				null,
				confirmdateEhrFormat,
				FactoryBase.getInstance().getSysparamValue("hcp_id"),
				FactoryBase.getInstance().getSysparamValue("hcp_name"),
				null,
				null,
				null
				);
	}
	
	private BirthDetail getBirthDetailL3(
			String recordKey,			// ebirthid
			String transactionDtm,		// sysdate
			String transactionType,		// I/U/D
			String lastUpdateDtm,		// confirmdate
			String episodeNo,			// regid
			String attendanceInstId,	// FactoryBase.getInstance().getSysparamValue("hcp_id")
			String birthDatetime,		// BB_DOB
			String birthInstCd,			// HKA, TWA
			String birthInstDesc,		// Hong Kong Adventist Hospital, Tsuen Wan Adventist Hospital
			String birthInstLtDesc,		// FactoryBase.getInstance().getSysparamValue("hcp_name")
			String birthLocCd,			// BBA, BOA, BIH
			String birthLocDesc,		// Born before arrival, Born on arrival, Born in hospital
			String birthLocLtDesc,		// Born before arriving the hospital, Born on arriving the Accident & Emergency Department, Born in hospital
			String birthMaturityWeek,
			String birthMaturityDay,
			String birthMode,
			String birthMembraneRupturedDuration,
			String birthApgarScore1Min,
			String birthApgarScore5Min,
			String birthApgarScore10Min,
			String birthWeight,			// dhbirthdtl.weightatbirth if dhbirthdtl.bbweighunit = 'Gram' and dhbirthdtl.weightatbirth between 300 and 7000
			String birthNote,
			String recordCreationDtm,	// confirmdate
			String recordCreationInstId,	// FactoryBase.getInstance().getSysparamValue("hcp_id")
			String recordCreationInstName,	// FactoryBase.getInstance().getSysparamValue("hcp_name")
			String recordUpdateDtm,
			String recordUpdateInstId,
			String recordUpdateInstName
			) {
		BirthDetail d = new BirthDetail();
		// mandatory
		d.setRecordKey(recordKey);
		d.setTransactionDtm(transactionDtm);
		d.setTransactionType(transactionType);
		d.setLastUpdateDtm(lastUpdateDtm);
		d.setEpisodeNo(episodeNo);					// optional
		d.setAttendanceInstId(attendanceInstId);	// optional
		d.setBirthDatetime(birthDatetime);
		d.setBirthInstCd(birthInstCd);
		d.setBirthInstDesc(birthInstDesc);
		d.setBirthInstLtDesc(birthInstLtDesc);
		d.setBirthLocCd(birthLocCd);	// optional
		if (birthLocCd != null) {
			d.setBirthLocDesc(birthLocDesc);		// mandatory if birthLocCd is not null
			d.setBirthLocLtDesc(birthLocLtDesc);
		}
		d.setBirthMaturityWeek(birthMaturityWeek);
		if (birthMaturityWeek != null) {
			d.setBirthMaturityDay(birthMaturityDay);
		}
		// optional below
		d.setBirthMode(birthMode);
		d.setBirthMembraneRupturedDuration(birthMembraneRupturedDuration);
		d.setBirthApgarScore1Min(birthApgarScore1Min);
		d.setBirthApgarScore5Min(birthApgarScore5Min);
		d.setBirthApgarScore10Min(birthApgarScore10Min);
		d.setBirthWeight(birthWeight);
		d.setBirthNote(birthNote);
		d.setRecordCreationDtm(recordCreationDtm);
		d.setRecordCreationInstId(recordCreationInstId);
		d.setRecordCreationInstName(recordCreationInstName);
		d.setRecordUpdateDtm(recordUpdateDtm);
		d.setRecordUpdateInstId(recordUpdateInstId);
		d.setRecordUpdateInstName(recordUpdateInstName);
		
		return d;
	}
	
	public String convert2BithLocCd(String isbornb4arrival, String isbornonarrival) {
		String ret = null;
		if ("Y".equalsIgnoreCase(isbornb4arrival)) {
			if ("N".equalsIgnoreCase(isbornonarrival)) {
				ret = ConstantsEhr.BIRTH_LOC_CODE_BBA;
			}
		} else if ("Y".equalsIgnoreCase(isbornonarrival)) {
			if ("N".equalsIgnoreCase(isbornb4arrival)) {
				ret = ConstantsEhr.BIRTH_LOC_CODE_BOA;
			}
		} else {
			// both N
			ret = ConstantsEhr.BIRTH_LOC_CODE_BIH;
		}
		if ("Y".equalsIgnoreCase(isbornb4arrival) && "Y".equalsIgnoreCase(isbornonarrival)) {
			logger.debug("Both bb_bornb4arrival and bb_bornonarrival is Y");
		}
		return ret;
	}
	
	public String getBirthLocDescByCd(String code) {
		String ret = null;
		if (ConstantsEhr.BIRTH_LOC_CODE_BBA.equalsIgnoreCase(code)) {
			ret = ConstantsEhr.BIRTH_LOC_DESC_BBA;
		}
		if (ConstantsEhr.BIRTH_LOC_CODE_BOA.equalsIgnoreCase(code)) {
			ret = ConstantsEhr.BIRTH_LOC_DESC_BOA;
		}
		if (ConstantsEhr.BIRTH_LOC_CODE_BIH.equalsIgnoreCase(code)) {
			ret = ConstantsEhr.BIRTH_LOC_DESC_BIH;
		}
		return ret;
	}
	
	public String getBirthLocLtDescByCd(String code) {
		String ret = null;
		if (ConstantsEhr.BIRTH_LOC_CODE_BBA.equalsIgnoreCase(code)) {
			ret = ConstantsEhr.BIRTH_LOC_LTDESC_BBA;
		}
		if (ConstantsEhr.BIRTH_LOC_CODE_BOA.equalsIgnoreCase(code)) {
			ret = ConstantsEhr.BIRTH_LOC_LTDESC_BOA;
		}
		if (ConstantsEhr.BIRTH_LOC_CODE_BIH.equalsIgnoreCase(code)) {
			ret = ConstantsEhr.BIRTH_LOC_LTDESC_BIH;
		}
		return ret;
	}
	
	public String convert2BithWeight(String weightatbirth, String bbweighunit) {
		String ret = null;
		if (EBIRTHDTL_BBWEIGHUNIT_GRAM.equalsIgnoreCase(bbweighunit)) {
			int weight = -1;
			try {
				weight = Integer.parseInt(weightatbirth.trim());
			} catch (NumberFormatException nfex) {
				logger.debug("Cannot convert weightatbirth=" + weightatbirth + " to integer.");
			}
			if (weight >= 300 && weight <= 7000) {
				ret = String.valueOf(weight);
			} else {
				logger.debug("BB weight=" + weight + " is not between 300 and 7000 (" + EBIRTHDTL_BBWEIGHUNIT_GRAM + ").");
			}
		}
		return ret;
	}
	
	private String getBirthInstCdSiteSpecific() {
		String ret = null;
		if (ConstantsServerSide.isHKAH()) {
			ret = ConstantsEhr.BIRTH_INSTITUTION_CODE_HKAH_SR;
		} else if (ConstantsServerSide.isTWAH()) {
			ret = ConstantsEhr.BIRTH_INSTITUTION_CODE_HKAH_TW;
		}
		return ret;
	}
	
	private String getBirthInstDescSiteSpecific() {
		String ret = null;
		if (ConstantsServerSide.isHKAH()) {
			ret = ConstantsEhr.BIRTH_INSTITUTION_DESC_HKAH_SR;
		} else if (ConstantsServerSide.isTWAH()) {
			ret = ConstantsEhr.BIRTH_INSTITUTION_DESC_HKAH_TW;
		}
		return ret;
	}
}
