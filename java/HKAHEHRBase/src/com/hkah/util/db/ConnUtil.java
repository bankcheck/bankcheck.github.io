package com.hkah.util.db;

import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.apache.log4j.Logger;

import com.hkah.server.config.ServerConfig;

public class ConnUtil {
	private static Logger logger = Logger.getLogger(ConnUtil.class);
	
	private final static String JNDINAME_PREFIX = "jdbc/";
	private static boolean isWebsphere = false;
	private static DataSource dataSourceHATS = null;
	private static DataSource dataSourceCIS = null;
	private static DataSource dataSourceLIS = null;
	private static DataSource dataSourcePHAR = null;
	
	static {
		// check web container
		logger.info("Check web container type");
		try {
			InitialContext ctx = new InitialContext();
			Context envContext = (Context)ctx.lookup("java:/comp/env");
			// tomcat 
			isWebsphere = false;
			logger.info("running in non-WAS");
		} catch (NamingException ex) {
			isWebsphere = true;
			logger.info("running in WAS");
		} catch (Exception ex) {
			logger.info("cannot determine container type");
		}
	}
	
	private static DataSource getDataSource(String jndiName) {
		try {
			// LOCAL DEV
			//boolean isWebsphere = false;
			
			// Perform a naming service lookup to get the DataSource object.
			if (isWebsphere) {
				InitialContext ctx = new InitialContext();
				return (DataSource) ctx.lookup(jndiName);
			} else {
				InitialContext ctx = new InitialContext();
				Context envContext = (Context)ctx.lookup("java:/comp/env");
				return (DataSource) envContext.lookup(jndiName);
			}

		} catch (Exception e) {
			logger.error("Naming Service Exception: " + e.getMessage());
		}
		return null;
	}
	
	public static DataSource getDataSource() {
		return getDataSourceHATS();
	}
	
	public static void closeConnection(Connection conn) {
		try {
			if (conn != null) {
				conn.close();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public static DataSource getDataSourceHATS() {
		if (dataSourceHATS == null) {
			dataSourceHATS = getDataSource(JNDINAME_PREFIX + ServerConfig.getObject().getJndiNameHATS());
		}
		return dataSourceHATS;
	}
	
	public static DataSource getDataSourceCIS() {
		if (dataSourceCIS == null) {
			dataSourceCIS = getDataSource(JNDINAME_PREFIX + ServerConfig.getObject().getJndiNameCIS());
		}
		return dataSourceCIS;
	}
	
	public static DataSource getDataSourceLIS() {
		if (dataSourceLIS == null) {
			dataSourceLIS = getDataSource(JNDINAME_PREFIX + ServerConfig.getObject().getJndiNameLIS());
		}
		return dataSourceLIS;
	}
	
	public static DataSource getDataSourcePHAR() {
		if (dataSourcePHAR == null) {
			dataSourcePHAR = getDataSource(JNDINAME_PREFIX + ServerConfig.getObject().getJndiNamePHAR());
		}
		return dataSourcePHAR;
	}
}
