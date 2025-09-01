/*
 * Created on July 29, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.servlet;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.http.HttpServlet;
import javax.sql.DataSource;

import org.apache.log4j.Logger;

import com.hkah.constant.ConstantsErrorMessage;
import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.util.cache.ServerSideCacheLoader;
import com.hkah.util.file.FileProperties;
import com.hkah.web.schedule.CronScheduler;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class HKAHInitServlet extends HttpServlet implements ConstantsErrorMessage {

	//======================================================================
	public final static String MODULE_CODE_NHS = "NHS";
	public final static String MODULE_CODE_CMS = "CMS";

	//======================================================================
	public final static String SERVER_TYPE_CORE = "CORE";
	public final static String SERVER_TYPE_SECURE = "SECURE";
	public final static String SERVER_TYPE_BACKEND = "BACKEND";
	public final static String SERVER_TYPE_EMAIL = "EMAIL";
	public final static String SERVER_TYPE_TEST = "TEST";

	//======================================================================
	private static Logger logger = Logger.getLogger(HKAHInitServlet.class);

	//======================================================================
	private final static String DATASOURCE_HATS = "jdbc/hats";
	private final static String DATASOURCE_INTRANET = "jdbc/Intranet";
	private final static String DATASOURCE_CIS = "jdbc/CIS";
	private final static String DATASOURCE_CMS = "jdbc/CMS";
	private final static String DATASOURCE_FSD = "jdbc/FSD";
	private final static String DATASOURCE_SEED = "jdbc/SEED";
	private final static String DATASOURCE_TAH = "jdbc/TAH";
	private final static String DATASOURCE_PACS = "jdbc/PACS";


	//======================================================================
	private final static boolean isWebsphere = false;

	//=== Data source ======================================================
	private static DataSource dataSourceHATS = null;
	private static DataSource dataSourceHATS1 = null;
	private static DataSource dataSourceIntranet = null;
	private static DataSource dataSourceCIS = null;
	private static DataSource dataSourceCMS = null;
	private static DataSource dataSourceFSD = null;
	private static DataSource dataSourceSEED = null;
	private static DataSource dataSourceTAH = null;
	private static DataSource dataSourcePACS = null;

	public void init()
	throws javax.servlet.ServletException {
		logger.info("------------- HKAHInitServlet Servlet Start!!!!!! -------------");

		// preload database paramters
		ServerSideCacheLoader.getInstance().loadData();

		// preload server config
		FileProperties.readProperties();
		logger.info("Upload folder:[" + ConstantsServerSide.UPLOAD_FOLDER + "]");
		logger.info("Upload web folder:[" + ConstantsServerSide.UPLOAD_WEB_FOLDER + "]");
		logger.info("Index folder:[" + ConstantsServerSide.INDEX_FOLDER + "]");
		logger.info("Temp folder:[" + ConstantsServerSide.TEMP_FOLDER + "]");
		logger.info("Document folder:[" + ConstantsServerSide.DOCUMENT_FOLDER + "]");

		logger.info("intranet url:[" + ConstantsServerSide.INTRANET_URL + "]");
		logger.info("offsite url:[" + ConstantsServerSide.OFFSITE_URL + "]");

		logger.info("Debug:[" + ConstantsServerSide.DEBUG + "]");

		String contextPath = getServletContext().getContextPath();
		logger.info("contextPath:[" + contextPath + "]");

		if ("/intranet".equals(contextPath)) {
			if (ConstantsServerSide.CORE_SERVER) {
				new CronScheduler(SERVER_TYPE_CORE);
				logger.info("Initialize quartz schedule job (core server)");
			}
			if (ConstantsServerSide.SECURE_SERVER) {
				new CronScheduler(SERVER_TYPE_SECURE);
				logger.info("Initialize quartz schedule job (secure server)");
			}
			if (ConstantsServerSide.BACKEND_SERVER) {
				new CronScheduler(SERVER_TYPE_BACKEND);
				logger.info("Initialize quartz schedule job (backend server)");
			}
			if (ConstantsServerSide.EMAIL_SERVER) {
				new CronScheduler(SERVER_TYPE_EMAIL);
				logger.info("Initialize quartz schedule job (email server)");
			}
			if (ConstantsServerSide.DEBUG) {
				new CronScheduler(SERVER_TYPE_TEST);
				logger.info("Initialize quartz schedule job (dev server)");
			}
		}
	}

	private static DataSource getDataSource(String jndiName) {
		try {
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
			e.printStackTrace();
		}
		return null;
	}

	public static DataSource getDataSource(String direct2DB, String moduleCode) {
		DataSource dataSource = null;
		if (ConstantsVariable.YES_VALUE.equals(direct2DB)) {
			if (HKAHInitServlet.MODULE_CODE_NHS.equals(moduleCode)) {
				dataSource = HKAHInitServlet.getDataSourceHATS();
			} else if (HKAHInitServlet.MODULE_CODE_CMS.equals(moduleCode)) {
				dataSource = HKAHInitServlet.getDataSourceCIS();
			} else {
				dataSource = HKAHInitServlet.getDataSourceIntranet();
			}
		} else {
			dataSource = HKAHInitServlet.getDataSourceIntranet();
		}
		return dataSource;
	}

	public static DataSource getDataSourceHATS() {
		if (dataSourceHATS == null) {
			dataSourceHATS = getDataSource(DATASOURCE_HATS);
		}
		return dataSourceHATS;
	}

	public static DataSource getDataSourceIntranet() {
		if (dataSourceIntranet == null) {
			dataSourceIntranet = getDataSource(DATASOURCE_INTRANET);
		}
		return dataSourceIntranet;
	}

	public static DataSource getDataSourceCIS() {
		if (dataSourceCIS == null) {
			dataSourceCIS = getDataSource(DATASOURCE_CIS);
		}
		return dataSourceCIS;
	}

	public static DataSource getDataSourceCMS() {
		if (dataSourceCMS == null) {
			dataSourceCMS = getDataSource(DATASOURCE_CMS);
		}
		return dataSourceCMS;
	}

	public static DataSource getDataSourceFSD() {
		if (dataSourceFSD == null) {
			dataSourceFSD = getDataSource(DATASOURCE_FSD);
		}
		return dataSourceFSD;
	}

	public static DataSource getDataSourceSEED() {
		if (dataSourceSEED == null) {
			dataSourceSEED = getDataSource(DATASOURCE_SEED);
		}
		return dataSourceSEED;
	}

	public static DataSource getDataSourceTAH() {
		if (dataSourceTAH == null) {
			dataSourceTAH = getDataSource(DATASOURCE_TAH);
		}
		return dataSourceTAH;
	}

	public static DataSource getDataSourcePACS() {
		if (dataSourcePACS == null) {
			dataSourcePACS = getDataSource(DATASOURCE_PACS);
		}
		return dataSourcePACS;
	}
}