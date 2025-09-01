package com.hkah.ehr.common;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ScheduledFuture;

import org.apache.log4j.Logger;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.ehr.model.Sysparam;
import com.hkah.util.db.ConnUtil;
import com.hkah.util.file.FileProperties;

public class FactoryBase {
	protected static Logger logger = Logger.getLogger(FactoryBase.class);
	private static FactoryBase singleton = null;
	private Map<String, Sysparam> sysparams = null;
	private ScheduledFuture<Object> scheduledFuture = null;
	
	public ScheduledFuture<Object> getScheduledFuture() {
		return scheduledFuture;
	}

	public void setScheduledFuture(ScheduledFuture<Object> scheduledFuture) {
		this.scheduledFuture = scheduledFuture;
	}

	{
		logger.info("== FactoryBase static run ==");
		
		// read default values from file
		FileProperties.readProperties();
		// read values from db, override file properties
		readPropertiesFromDB();
	}
	
	protected FactoryBase() {
		// Exists only to defeat instantiation.
	}
	
	public static FactoryBase getInstance() {
 		if(singleton == null) {
    	 	synchronized(FactoryBase.class) { 
    	 		singleton = new FactoryBase();
    	 	}
 		}
 		return singleton;
	}
	
	public String getSysparamValue(String paramName) {
		return getSysparamValue(paramName, 1);
	}
	
	public String getSysparamValue2(String paramName) {
		return getSysparamValue(paramName, 2);
	}
	
	private String getSysparamValue(String paramName, int number) {
		if(sysparams == null) {
			loadSysparams();
		}
		Sysparam sysparam = sysparams.get(paramName);
		return sysparam != null ? 
				(number == 1 ? sysparam.getParam1() : 
					(number == 2 ? sysparam.getParam2() : null))
				: null;
	}
	
	public void loadSysparams() {
		logger.info("loadSysparams");
		sysparams = new HashMap<String, Sysparam>();
		
        PreparedStatement psHATS = null;
        PreparedStatement psCIS = null;
        PreparedStatement psCIS2 = null;
        ResultSet rsHATS = null;
        ResultSet rsCIS = null;
        ResultSet rsCIS2 = null;
        Connection connHATS = null;
        Connection connCIS = null;
        String sql;
        
		try {
			// get from HATS sysapram
			sql = "select PARCDE, PARAM1, PARAM2, PARDESC from SYSPARAM";
			connHATS = ConnUtil.getDataSourceHATS().getConnection();
			psHATS = connHATS.prepareStatement(sql);
			rsHATS = psHATS.executeQuery();
            
            while (rsHATS.next()) {
            	Sysparam sysparam = new Sysparam();
            	String key = rsHATS.getString("PARCDE");
            	sysparam.setParcde(key);
            	sysparam.setParam1(rsHATS.getString("PARAM1"));
            	sysparam.setParam2(rsHATS.getString("PARAM2"));
            	sysparam.setPardesc(rsHATS.getString("PARDESC"));
            	sysparams.put(key, sysparam);
            }
            
            // get from EHR hepr_system_setting
			sql = "select param_name, param_name_desc, param_value, null param_value2 from hepr_system_setting@ehr";
			connCIS = ConnUtil.getDataSourceCIS().getConnection();
			psCIS = connCIS.prepareStatement(sql);
			rsCIS = psCIS.executeQuery();
            
            while (rsCIS.next()) {
            	Sysparam sysparam = new Sysparam();
            	String key = rsCIS.getString("param_name");
            	sysparam.setParcde(key);
            	sysparam.setParam1(rsCIS.getString("param_value"));
            	sysparam.setParam2(rsCIS.getString("param_value2"));
            	sysparam.setPardesc(rsCIS.getString("param_name_desc"));
            	sysparams.put(key, sysparam);
            }
            
			// get from CIS ah_sys_code (HA_eMR)
			sql = "select code_no, code_value1, code_value2, remarks from ah_sys_code where code_type = 'HA_eMR' and status in ('V', 'v', 'Y')";
			psCIS2 = connCIS.prepareStatement(sql);
			rsCIS2 = psCIS2.executeQuery();
            
            while (rsCIS2.next()) {
            	Sysparam sysparam = new Sysparam();
            	String key = rsCIS2.getString("code_no");
            	sysparam.setParcde(key);
            	sysparam.setParam1(rsCIS2.getString("code_value1"));
            	sysparam.setParam2(rsCIS2.getString("code_value2"));
            	sysparam.setPardesc(rsCIS2.getString("remarks"));
            	sysparams.put(key, sysparam);
            }
            
            readPropertiesFromDB();
        } catch (Exception e) {
            logger.error("loadSysparams error: " + e.getMessage());
            e.printStackTrace();
        } finally {
        	try {
        		if (rsHATS != null)
        			rsHATS.close();
        		
        		if (rsCIS != null)
        			rsCIS.close();
        		
        		if (rsCIS2 != null)
        			rsCIS2.close();
        		
        		if (psHATS != null)
        			psHATS.close();
        		
        		if (psCIS != null)
        			psCIS.close();
        		
        		if (psCIS2 != null)
        			psCIS2.close();
        		
        		ConnUtil.closeConnection(connHATS);
        		ConnUtil.closeConnection(connCIS);
        	} catch(Exception e) {
                logger.error("loadSysparams cannot close connection");
                e.printStackTrace();
        	}
        }     
	}
	
	private void readPropertiesFromDB() {
		String siteCode = getSysparamValue("curtSite");
		ConstantsServerSide.SITE_CODE = siteCode != null ? siteCode.toLowerCase() : siteCode;
		ConstantsServerSide.SITE_ENV = getSysparamValue2("curtSite");
		ConstantsServerSide.MAIL_HOST = getSysparamValue("EHRMHOST");
		ConstantsServerSide.MAIL_SMTP_PORT = getSysparamValue("EHRMPORT");
		ConstantsServerSide.MAIL_PROTOCOL = getSysparamValue("EHRMPROTO");
		ConstantsServerSide.MAIL_SMTP_AUTH = getSysparamValue("EHRMAUTH");
		ConstantsServerSide.MAIL_SMTP_USERNAME = getSysparamValue("EHRMUSER");
		ConstantsServerSide.MAIL_SMTP_PASSWORD = getSysparamValue("EHRMPW");
		ConstantsServerSide.MAIL_SMTP_CONNECTIONTIMEOUT = getSysparamValue("EHRMCTIMEO");
		ConstantsServerSide.MAIL_SMTP_TIMEOUT = getSysparamValue("EHRMTIMEO");
		ConstantsServerSide.MAIL_ALERT = getSysparamValue("EHRMAALERT");
		ConstantsServerSide.MAIL_TESTER = getSysparamValue("EHRMATEST");
		ConstantsServerSide.MAIL_ADMIN = getSysparamValue("EHRMAADMIN");
		
		logger.info("readPropertiesFromDB siteCode=" + ConstantsServerSide.SITE_CODE + ", siteEnv=" + ConstantsServerSide.SITE_ENV);
	}
}

