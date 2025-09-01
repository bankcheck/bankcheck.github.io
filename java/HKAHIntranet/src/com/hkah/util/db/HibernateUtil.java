package com.hkah.util.db;

import org.apache.log4j.Logger;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

public class HibernateUtil {
	private static Logger logger = Logger.getLogger(HibernateUtil.class);
	
	private static final SessionFactory sessionFactory = buildSessionFactory();
	
	private static SessionFactory buildSessionFactory() {
		/*
		 * Set the hibernate configuation in hibernate.cfg.xml
		 */
		Configuration config = new Configuration().configure();
		return config.buildSessionFactory();
	}
	
	public static final ThreadLocal session = new ThreadLocal();

    public static Session getCurrentSession() {
    	try {
	        Session s = (Session) session.get();
	        if (s == null) {
	            s = sessionFactory.openSession();
	            session.set(s);
	        }
	        return s;
    	} catch (Exception e) {
			logger.error("Get Hibernate Current Session Exception: " + e.getMessage());
			e.printStackTrace();	
			return null;
    	}
    }
    
    public static void closeSession() {
    	try {
	        Session s = (Session) session.get();
	        session.set(null);
	        if (s != null)
	            s.close();
    	} catch (Exception e) {
			logger.error("Hibernate Close Session Exception: " + e.getMessage());
			e.printStackTrace();	
    	}
    }

}
