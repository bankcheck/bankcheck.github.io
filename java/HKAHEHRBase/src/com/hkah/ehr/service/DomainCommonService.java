package com.hkah.ehr.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import org.apache.commons.lang.StringUtils;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.log4j.Logger;

import com.hkah.constant.ConstantsEhr;
import com.hkah.ehr.common.FactoryBase;
import com.hkah.ehr.model.Participant;
import com.hkah.ehr.model.Patient;
import com.hkah.ehr.model.PatientUploadResp;
import com.hkah.ehr.model.Reg;
import com.hkah.model.db.EhrDataUploadLog;
import com.hkah.util.DateTimeUtil;
import com.hkah.util.EhrUtil;
import com.hkah.util.db.ConnUtil;

public class DomainCommonService {
	private static Logger logger = Logger.getLogger(DomainCommonService.class);
	
	public Participant getEhrHl7ParticipantByEhrNo(String ehrNo) {
		if (ehrNo == null) {
			ehrNo = "null";
		}
		return getEhrHl7Participant(ehrNo, null);
	}
	
	public Participant getEhrHl7ParticipantByPatNo(String patNo) {
		if (patNo == null) {
			patNo = "null";
		}
		return getEhrHl7Participant(null, patNo);
	}
	
	public Participant getEhrHl7Participant(String ehrNo, String patNo) {
		return getEhrHl7Participant(ehrNo, patNo , null);
	}
	
	public Participant getEhrHl7Participant(String ehrNo, String patNo, String active) {
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection conn = null;
        String sql;
        Participant p = new Participant();
        int index = 1;
       
		try {
			sql = "select patno, ehrno, ehrfname, ehrgname, ehrsex, ehrhkid, ehrdocno, ehrdoctype,";
			sql += " case when ehredobind = 'EY' then to_char(ehrdob, 'yyyy') else";
			sql += " case when ehredobind = 'EMY' then to_char(ehrdob, 'Mon-yyyy') else";
			sql += " to_char(ehrdob, 'dd-Mon-yyyy')";
			sql += " end";
			sql += " end ehrdobstr,";
			sql += " f_age_in_char@cis(ehrdob) age,";
			sql += " active";
			sql	+= " from ehr_pmi";
			sql += " where 1=1";
	        if (ehrNo != null) {
	        	sql += " and ehrno = ?";
	        }
	        if (patNo != null) {
	        	sql += " and patno = ?";
	        }
	        if (active != null) {
	        	sql += " and active = ?";
	        } else {
	        	sql += " and active = -1";
	        }
			conn = ConnUtil.getDataSourceHATS().getConnection();
	        ps = conn.prepareStatement(sql);
	        if (ehrNo != null) {
	        	ps.setString(index++, ehrNo);
	        }
	        if (patNo != null) {
	        	ps.setString(index++, patNo);
	        }
	        if (active != null) {
	        	ps.setString(index++, active);
	        }
            rs = ps.executeQuery();
            
            if (rs.next()) {
            	p.setPatientKey(rs.getString("patno"));
            	p.setEhrNo(rs.getString("ehrno"));
            	p.setPersonEngSurname(rs.getString("ehrfname"));
            	p.setPersonEngGivenName(rs.getString("ehrgname"));
            	p.setBirthDate(rs.getString("ehrdobStr"));
            	p.setSex(rs.getString("ehrsex"));
            	p.setHkid(rs.getString("ehrhkid"));
            	p.setDocNo(rs.getString("ehrdocno"));
            	p.setDocType(rs.getString("ehrdoctype"));
            	p.setAge(rs.getString("age"));
            	p.setActive("-1".equals(rs.getString("active")));
            }
        } catch (Exception e) {
            logger.error("error: " + e.getMessage());
            e.printStackTrace();
        } finally {
        	try {
        		if (rs != null)
        			rs.close();
        		
        		if (ps != null)
        			ps.close();
        		
        		if (conn != null)
        			conn.close();
        	} catch(Exception e) {
                logger.error("cannot close connection");
                e.printStackTrace();
        	}
        }     
        return p;
	}
	
	public Participant getEhrHl7Participant4DomainByEhrNo(String ehrNo) {
		if (ehrNo == null) {
			ehrNo = "null";
		}
		return getEhrHl7Participant4Domain(ehrNo, null);
	}
	
	public Participant getEhrHl7Participant4DomainByPatNo(String patNo) {
		if (patNo == null) {
			patNo = "null";
		}
		return getEhrHl7Participant4Domain(null, patNo);
	}
	
	public Participant getEhrHl7Participant4Domain(String ehrNo, String patNo) {
		return getEhrHl7Participant4Domain(ehrNo, patNo, null);
	}
	
	public Participant getEhrHl7Participant4Domain(String ehrNo, String patNo, String active) {
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection conn = null;
        String sql;
        Participant p = new Participant();
        int index = 1;
       
		try {
			sql = "select patno, ehrno, ehrfname, ehrgname, ehrsex, ehrhkid, ehrdocno, ehrdoctype,";
			sql += " DECODE( ehrfname, NULL, '', ehrfname || ', ' ) || ehrgname ehrfullname,";
			sql += " to_char(ehrdob, 'yyyy-MM-dd hh24:mi:ss') || '.000' ehrdobstr,";
			sql += " f_age_in_char@cis(ehrdob) age,";
			sql += " active";
			sql	+= " from ehr_pmi";
			sql += " where 1=1";
	        if (ehrNo != null) {
	        	sql += " and ehrno = ?";
	        }
	        if (patNo != null) {
	        	sql += " and patno = ?";
	        }
	        if (active != null) {
	        	sql += " and active = ?";
	        } else {
	        	sql += " and active = -1";
	        }
			conn = ConnUtil.getDataSourceHATS().getConnection();
	        ps = conn.prepareStatement(sql);
	        if (ehrNo != null) {
	        	ps.setString(index++, ehrNo);
	        }
	        if (patNo != null) {
	        	ps.setString(index++, patNo);
	        }
            rs = ps.executeQuery();
            
            if (rs.next()) {
            	p.setPatientKey(rs.getString("patno"));
            	p.setEhrNo(rs.getString("ehrno"));
            	p.setPersonEngSurname(rs.getString("ehrfname"));
            	p.setPersonEngGivenName(rs.getString("ehrgname"));
            	p.setPersonEngFullName(rs.getString("ehrfullname"));
            	p.setBirthDate(rs.getString("ehrdobStr"));
            	p.setSex(rs.getString("ehrsex"));
            	p.setHkid(rs.getString("ehrhkid"));
            	p.setDocNo(rs.getString("ehrdocno"));
            	p.setDocType(rs.getString("ehrdoctype"));
            	p.setAge(rs.getString("age"));
            	p.setActive("-1".equals(rs.getString("active")));
            }
        } catch (Exception e) {
            logger.error("error: " + e.getMessage());
            e.printStackTrace();
        } finally {
        	try {
        		if (rs != null)
        			rs.close();
        		
        		if (ps != null)
        			ps.close();
        		
        		if (conn != null)
        			conn.close();
        	} catch(Exception e) {
                logger.error("cannot close connection");
                e.printStackTrace();
        	}
        }     
        return p;
	}
	
	public Patient getHATSPatient(String patNo) {
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection conn = null;
        String sql;
        Patient p = new Patient();
        int index = 1;
       
		try {
			sql = "select patno, patfname, patgname, patsex, patidno, ";
			sql += "to_char(patbdate, 'dd/MM/yyyy') patbdate, ";
			sql += "f_age_in_char@cis(patbdate) age, patcname ";
			sql	+= "from patient ";
	        sql += "where patno = ?";
			conn = ConnUtil.getDataSourceHATS().getConnection();
	        ps = conn.prepareStatement(sql);
	        ps.setString(index++, patNo);
            rs = ps.executeQuery();
            
            if (rs.next()) {
            	p.setPatno(rs.getString("patno"));
            	p.setPatfname(rs.getString("patfname"));
            	p.setPatgname(rs.getString("patgname"));
            	p.setPatcname(rs.getString("patcname"));
            	p.setPatbdate(DateTimeUtil.parseDate(rs.getString("patbdate")));
            	p.setPatsex(rs.getString("patsex"));
            	p.setPatidno(rs.getString("patidno"));
            	p.setAge(rs.getString("age"));
            }
        } catch (Exception e) {
            logger.error("error: " + e.getMessage());
            e.printStackTrace();
        } finally {
        	try {
        		if (rs != null)
        			rs.close();
        		
        		if (ps != null)
        			ps.close();
        		
        		if (conn != null)
        			conn.close();
        	} catch(Exception e) {
                logger.error("cannot close connection");
                e.printStackTrace();
        	}
        }     
        return p;
	}
	
	public Participant participant(String patno){
		return participant(patno, null);
	}
	
	public Participant participant(String patno, String active){
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
			sql = "select ehrno, ehrsex, to_char(ehrdob, 'yyyy-mm-dd hh24:mi:ss')||'.000' as birth_date, ehrfname, ehrgname, ehrfname || ', ' || ehrgname as fullname, ehrhkid, ehrdocno, ehrdoctype, active from ehr_pmi where patno = ?" ;
	        if (active != null) {
	        	sql += " and active = ?";
	        } else {
	        	sql += " and active = -1";
	        }
			conn = ConnUtil.getDataSourceHATS().getConnection();
			ps_hats = conn.prepareStatement(sql);
        	ps_hats.setString(1, patno);
	        if (active != null) {
	        	ps_hats.setString(2, active);
	        }
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
				p.setActive("-1".equals(rs_hats.getString("active")));
								
				logger.debug("patno =" + patno + ", ehrno="+ehrno+", birthdate="+birthdate + ", ehrfname="+ehrfname+", ehrgname="+ehrgname+", sex =" +sex + ", hkid="+hkid+", doctype="+doctype+", ehrdocno="+ehrdocno+", fullname="+fullname);
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
	
	public String getPatNoByRegID(String regID) {
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection conn = null;
        String sql;
        int index = 1;
        String patno = null;
       
		try {
			sql = "select patno from reg where regid = ?";
			conn = ConnUtil.getDataSourceHATS().getConnection();
	        ps = conn.prepareStatement(sql);
	        ps.setString(index++, regID);
            rs = ps.executeQuery();
            
            if (rs.next()) {
            	patno = rs.getString("patno");
            }
        } catch (Exception e) {
            logger.error("error: " + e.getMessage());
            e.printStackTrace();
        } finally {
        	try {
        		if (rs != null)
        			rs.close();
        		
        		if (ps != null)
        			ps.close();
        		
        		if (conn != null)
        			conn.close();
        	} catch(Exception e) {
                logger.error("cannot close connection");
                e.printStackTrace();
        	}
        }     
        return patno;
	}
	
	public Reg getReg(String regid) {
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection conn = null;
        String sql;
        Reg r = new Reg();
        int index = 1;
       
		try {
			sql = "select r.regid, r.patno, r.slpno, ";
			sql += "to_char(r.regdate, 'dd/MM/yyyy hh24:mi:ss') regdate, ";
			sql += "to_char(i.inpddate, 'dd/MM/yyyy hh24:mi:ss') inpddate, ";
			sql += "ac.acmname, ";
			sql += "w.wrdname, ";
			sql += "b.bedcode ";
			sql	+= "from reg r ";
			sql	+= "  left join inpat i on r.inpid = i.inpid ";
			sql	+= "  left join bed b on i.bedcode = b.bedcode ";
			sql	+= "  left join room rm on b.romcode = rm.romcode ";
			sql	+= "  left join ward w on rm.wrdcode = w.wrdcode ";
			sql	+= "  left join acm ac on i.acmcode = ac.acmcode ";
	        sql += "where r.regid = ?";
			conn = ConnUtil.getDataSourceHATS().getConnection();
	        ps = conn.prepareStatement(sql);
	        ps.setString(index++, regid);
            rs = ps.executeQuery();
            
            if (rs.next()) {
            	r.setRegid(rs.getString("regid"));
            	r.setPatno(rs.getString("patno"));
            	r.setSlpno(rs.getString("slpno"));
            	r.setRegdate(DateTimeUtil.parseDateTime(rs.getString("regdate")));
            	r.setInpddate(DateTimeUtil.parseDateTime(rs.getString("inpddate")));
            	r.setAcmname(rs.getString("acmname"));
            	r.setWrdname(rs.getString("wrdname"));
            	r.setBedcode(rs.getString("bedcode"));
            }
        } catch (Exception e) {
            logger.error("error: " + e.getMessage());
            e.printStackTrace();
        } finally {
        	try {
        		if (rs != null)
        			rs.close();
        		
        		if (ps != null)
        			ps.close();
        		
        		if (conn != null)
        			conn.close();
        	} catch(Exception e) {
                logger.error("cannot close connection");
                e.printStackTrace();
        	}
        }     
        return r;
	}
	
	public Participant newParticipant(
			String patno,
			String ehrno,
			String birthDate,
			String sex,
			String hkid,
			String docType,
			String docNo,
			String surname,
			String givenName
			) {
     	Participant p = new Participant();
		p.setEhrNo(ehrno);
		p.setBirthDate(birthDate);
		p.setSex(sex);
		p.setPatientKey(patno);
		p.setHkid(hkid);
		p.setDocType(docType);
		p.setDocNo(docNo);
		p.setPersonEngGivenName(givenName);
		p.setPersonEngSurname(surname);
		p.setPersonEngFullName(EhrUtil.convertToEngFullName(surname, givenName));
		
		return p;
	}
	
	public List<EhrDataUploadLog> getLatestFailedUploads(String domainCode) {
		PreparedStatement ps = null;
		Connection conn = null;
	    ResultSet rs = null;
	    StringBuffer sqlBuffer = new StringBuffer();
	    List<EhrDataUploadLog> uploadDataLog = new ArrayList<EhrDataUploadLog>();
			
		try {
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
	
	public void updatePatInit(String patno, String domainCode) {
		logger.info("Set init upload flag (" + domainCode + ") on, patno="+patno);
		
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection conn = null;
        String sql;
		try {
			sql = "update ehr_pmi set " + getInitColName(domainCode) + " = SYSDATE where patno = '" + patno + "'";
			conn = ConnUtil.getDataSourceHATS().getConnection();
			ps = conn.prepareStatement(sql);		
			rs = ps.executeQuery();
		} catch (Exception e) {
            logger.error("rror");
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
	
	public List<PatientUploadResp> getEhrPatnos(List<String> patnos, String domainCode) {
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection conn = null;
        String sql;
        List<PatientUploadResp> patInfos = new ArrayList<PatientUploadResp>();
		
		try {
			String patnosStr = StringUtils.join(patnos, "','");
			sql = "select patno, ehrno, " + getInitColName(domainCode) + " from ehr_pmi where patno in ('" + patnosStr + "') order by patno";
			conn = ConnUtil.getDataSourceHATS().getConnection();
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			
			while (rs.next()) {
				patInfos.add(new PatientUploadResp(rs.getString(1), rs.getString(2), rs.getString(3)));
			}
		} catch (Exception e) {
            logger.error("Error");
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
		return patInfos;
	}
	
	public void updateDataUploadLog(List<PatientUploadResp> patientUploadResps, List<String> patErrorList, Date uploadDate, 
			Date startDate, Date endDate, String mode, String domainCode) {
		logger.info("domainCode: " + domainCode + ", mode: " + mode);
		
		PreparedStatement ps = null;
        ResultSet rs = null;
        Connection conn = null;
        String sql;
        int[] retCounts = new int[patientUploadResps.size()];
        List<String> batchPatnos = new ArrayList<String>();
		try {
			sql = "insert into EHR_DATA_UPLOAD_LOG(ID, DOMAIN_CODE, UPLOAD_DATE, EHR_NO, PATNO, START_DATE, END_DATE, UPLOAD_MODE, SUCCESS) " +
					"values(SEQ_EHR_DATA_UPLOAD_LOG.NEXTVAL, ?, TO_DATE(?, 'dd/mm/yyyy HH24:mi:ss'), ?, ?, TO_DATE(?, 'dd/mm/yyyy HH24:mi:ss'), TO_DATE(?, 'dd/mm/yyyy HH24:mi:ss'), ?, ?)";
			conn = ConnUtil.getDataSourceHATS().getConnection();
			ps = conn.prepareStatement(sql);
			
			for (PatientUploadResp patientUploadResp : patientUploadResps) {
				int i = 1;
				ps.setString(i++, domainCode);
				ps.setString(i++, DateTimeUtil.formatDateTime(uploadDate));
				ps.setString(i++, patientUploadResp.getEhrNo());
				ps.setString(i++, patientUploadResp.getPatNo());
				ps.setString(i++, startDate == null ? null : DateTimeUtil.formatDateTime(startDate));
				ps.setString(i++, DateTimeUtil.formatDateTime(endDate));
				ps.setString(i++, mode);
				ps.setString(i++, patErrorList.contains(patientUploadResp.getPatNo()) ? "N" : "Y");
				ps.addBatch();
				
				batchPatnos.add(patientUploadResp.getPatNo());
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
            logger.error("Error");
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
	
	protected String getInitColName(String domainCode) {
		String ret = null;
		if (ConstantsEhr.DOMAIN_CODE_LABGEN.equals(domainCode)) {
			ret = ConstantsEhr.PMI_INIT_COLNAME_LABGEN;
		} else if (ConstantsEhr.DOMAIN_CODE_LABMICRO.equals(domainCode)) {
			ret = ConstantsEhr.PMI_INIT_COLNAME_LABMICRO;
		} else if (ConstantsEhr.DOMAIN_CODE_RADI.equals(domainCode)) {
			ret = ConstantsEhr.PMI_INIT_COLNAME_RADI;
		} else if (ConstantsEhr.DOMAIN_CODE_DISP.equals(domainCode)) {
			ret = ConstantsEhr.PMI_INIT_COLNAME_DISP;
		} else if (ConstantsEhr.DOMAIN_CODE_ADR.equals(domainCode)) {
			ret = ConstantsEhr.PMI_INIT_COLNAME_ADR;
		} else if (ConstantsEhr.DOMAIN_CODE_ALLERGY.equals(domainCode)) {
			ret = ConstantsEhr.PMI_INIT_COLNAME_ALLERGY;
		} else if (ConstantsEhr.DOMAIN_CODE_CNS.equals(domainCode)) {
			ret = ConstantsEhr.PMI_INIT_COLNAME_CNS;
		} else if (ConstantsEhr.DOMAIN_CODE_BIRTH.equals(domainCode)) {
			ret = ConstantsEhr.PMI_INIT_COLNAME_BIRTH;
		} else if (ConstantsEhr.DOMAIN_CODE_ENCTR.equals(domainCode)) {
			ret = ConstantsEhr.PMI_INIT_COLNAME_ENCTR;
		}
		return ret;
	}
	
	public void sendBlankDomains(String patno) {
		//String url = "http://160.100.2.73:9080/HKAHEHR-al1/uploadBlankEncounter";
		String url = FactoryBase.getInstance().getSysparamValue("EHRAL1BLNK") + "uploadBlankEncounter";
		
		logger.info("[DEV] Send blank domain: ENC url="+url+", patno="+patno);
		
		List<NameValuePair> pairList = new ArrayList<NameValuePair>();
		pairList.add(new BasicNameValuePair("patNo", patno));
		pairList.add(new BasicNameValuePair("userID", "SYSTEM"));
		
		CloseableHttpResponse response = null;
		try {
			CloseableHttpClient httpclient = HttpClients.createDefault();
			HttpPost httpPost = new HttpPost(url);
			UrlEncodedFormEntity entity = new UrlEncodedFormEntity(pairList);
			httpPost.setEntity(entity);
			response = httpclient.execute(httpPost);

			logger.info("Response Code : " 
	                + response.getStatusLine().getStatusCode());
			
			BufferedReader rd = new BufferedReader(
			        new InputStreamReader(response.getEntity().getContent()));
	
			StringBuffer result = new StringBuffer();
			String line = "";
			while ((line = rd.readLine()) != null) {
				result.append(line);
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("Error: " + e.getMessage());
		}
	}
	
	public void sendAllBlankDomains(String patno) {
		logger.info("sendAllBlankDomains patno="+patno);
		
		String result = null;
		List<String> activeDomains = getActiveDomainUpload();
		for (String activeDomain : activeDomains) {
			result = sendBlankDomain(activeDomain, patno);
		}
	}
	
	public String sendBlankDomain(String domainCode, String patno) {
		String uploadBlankDomainPath = ConstantsEhr.DOMAIN_UPLOAD_BLANK_PATHS.get(domainCode);
		if (uploadBlankDomainPath == null) {
			return "No upload blank path is defined for domain: " + domainCode + ".";
		}
		String url = FactoryBase.getInstance().getSysparamValue("EHRAL1BLNK") + uploadBlankDomainPath;
		
		logger.debug("Send blank domain: " + domainCode + ", url="+url+", patno="+patno);
		
		List<NameValuePair> pairList = new ArrayList<NameValuePair>();
		pairList.add(new BasicNameValuePair("patNo", patno));
		pairList.add(new BasicNameValuePair("userID", "SYSTEM"));
		
		CloseableHttpResponse response = null;
		StringBuffer result = new StringBuffer();
		try {
			CloseableHttpClient httpclient = HttpClients.createDefault();
			HttpPost httpPost = new HttpPost(url);
			UrlEncodedFormEntity entity = new UrlEncodedFormEntity(pairList);
			httpPost.setEntity(entity);
			response = httpclient.execute(httpPost);

			if (response.getStatusLine().getStatusCode() == 200) {
				logger.debug("Response Code : " 
		                + response.getStatusLine().getStatusCode());
			} else {
				logger.error("Response Code : " 
		                + response.getStatusLine().getStatusCode() + ", url="+url);
			}

			
			BufferedReader rd = new BufferedReader(
			        new InputStreamReader(response.getEntity().getContent()));
	
			String line = "";
			while ((line = rd.readLine()) != null) {
				result.append(line);
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("Error: " + e.getMessage());
			result.append(e.getMessage());
		}
		return result.toString();
	}
	
	public List<String> getActiveDomainUpload() {
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection conn = null;
        String sql;
        List<String> results = new ArrayList<String>();
       
		try {
			sql = "select domain_id, domain_desc ";
			sql += " from hepr_domain_setting@ehr";
			sql += " where enable = 'Y'";
			sql += " and domain_id not in (SELECT param1 FROM sysparam@hat where parcde like '" + ConstantsEhr.DOMAIN_PMI_NOT_SEND_BLANK_PREFIX + "%') ";
			sql += " order by domain_id";
			conn = ConnUtil.getDataSourceCIS().getConnection();
	        ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
            	results.add(rs.getString("domain_id"));
            }
        } catch (Exception e) {
            logger.error("error: " + e.getMessage());
            e.printStackTrace();
        } finally {
        	try {
        		if (rs != null)
        			rs.close();
        		
        		if (ps != null)
        			ps.close();
        		
        		if (conn != null)
        			conn.close();
        	} catch(Exception e) {
                logger.error("cannot close connection");
                e.printStackTrace();
        	}
        }     
        return results;
	}
}
