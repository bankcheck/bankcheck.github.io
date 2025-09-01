package com.hkah.web.db;

import java.io.File;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.HibernateUtil;
import com.hkah.web.common.UserBean;
import com.hkah.web.db.hibernate.AcDocumentAccess;
import com.hkah.web.db.hibernate.AcDocumentAccessId;
import com.hkah.web.db.hibernate.CoDocument;
import com.hkah.web.db.hibernate.CoDocumentMailList;



public class DocumentDB2 {
	
	protected final Log logger = LogFactory.getLog(getClass());

	// constant
	public static String SITE_CODE = ConstantsServerSide.SITE_CODE;
	
	//------------------------
	// Retrieve persistence objects
	//------------------------
	
	// Get single model
	//-----------------
	public static CoDocument getCoDocument(BigDecimal coDocumentId) {
		return getCoDocument(coDocumentId, 1);
	}
	
	public static CoDocument getCoDocument(BigDecimal coDocumentId, Integer coEnabled) {
		Session session = HibernateUtil.getCurrentSession();
		
		CoDocument coDocument = null;
		
		try {
//			coDocument = (CoDocument) session.get(CoDocument.class, coDocumentId);
			
			Criteria criteria = session.createCriteria(CoDocument.class);
			
			// criteria
			criteria = criteria.add(Restrictions.eq("coDocumentId", coDocumentId));
			if (coEnabled != null) {
				criteria = criteria.add(Restrictions.eq("coEnabled", coEnabled));
			}
			
			coDocument = (CoDocument) criteria.uniqueResult();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		
		}
		return coDocument;
	}
	
	public static BigDecimal getNextCoDocumentId() {
		Session session = HibernateUtil.getCurrentSession();
		BigDecimal nextId = null;

		try {
			String hql = "SELECT MAX(coDocumentId) + 1 " +
						 "FROM CoDocument";
			Query query = session.createQuery(hql);
			nextId = (BigDecimal) query.uniqueResult();
		} catch (HibernateException hex) {
			throw hex;
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			// cannot close session, otherwise parent object cannot be saved
		}
		return nextId;
	}
	
	public static CoDocumentMailList getCoDocumentMailList(BigDecimal coDocumentId) {
		return getCoDocumentMailList(coDocumentId, 1);
	}
	
	public static CoDocumentMailList getCoDocumentMailList(BigDecimal coDocumentMailListId, Integer coEnabled) {
		Session session = HibernateUtil.getCurrentSession();
		
		CoDocumentMailList coDocumentMailList = null;
		
		try {
			Criteria criteria = session.createCriteria(CoDocumentMailList.class);
			
			// criteria
			criteria = criteria.add(Restrictions.eq("coDocumentMailListId", coDocumentMailListId));
			if (coEnabled != null) {
				criteria = criteria.add(Restrictions.eq("coEnabled", coEnabled));
			}
			
			coDocumentMailList = (CoDocumentMailList) criteria.uniqueResult();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		
		}
		return coDocumentMailList;
	}
	
	public static List<CoDocumentMailList> getCoDocumentMailLists(BigDecimal coDocumentId) {
		Session session = HibernateUtil.getCurrentSession();
		
		List<CoDocumentMailList> list = null;
		
		try {
			Criteria criteria = session.createCriteria(CoDocumentMailList.class);
			
			// criteria
			criteria = criteria.add(Restrictions.eq("coDocumentId", coDocumentId));
			criteria = criteria.add(Restrictions.eq("coEnabled", 1));
			
			list = criteria.list();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		
		}
		return list;
	}
	
	public static AcDocumentAccess getAcDocumentAccess(AcDocumentAccessId acDocumentAccessId) {
		Session session = HibernateUtil.getCurrentSession();
		
		AcDocumentAccess acDocumentAccess = null;
		
		try {
			acDocumentAccess = (AcDocumentAccess) session.get(AcDocumentAccess.class, acDocumentAccessId);
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		
		}
		return acDocumentAccess;
	}
	
	// Get list
	//-----------------
	public static List<CoDocument> getCoDocumentList() {
		return getCoDocumentList(1);
	}
	
	public static List<CoDocument> getCoDocumentList(Integer coEnabled) {
		Session session = HibernateUtil.getCurrentSession();
		List<CoDocument> coDocumentlist = null;
		
		try {
			Criteria criteria = session.createCriteria(CoDocument.class);
			
			// criteria
			if (coEnabled != null) {
				criteria = criteria.add(Restrictions.eq("coEnabled", coEnabled));
			}
			criteria = criteria.addOrder(Order.desc("coDocumentId"));
			
			coDocumentlist = criteria.list();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		
		return coDocumentlist;
	}
	
	public static List<CoDocument> getSearchCoDocumentList(String coDescription, String coLocation) {
		Session session = HibernateUtil.getCurrentSession();
		List<CoDocument> coDocumentlist = null;
		
		try {
			Criteria criteria = session.createCriteria(CoDocument.class);
			
			// criteria
			if (coDescription != null && coDescription.length() > 0) {
				criteria = criteria.add(Restrictions.ilike("coDescription", "%" + coDescription.toLowerCase() + "%"));
			}
			if (coLocation != null && coLocation.length() > 0) {
				criteria = criteria.add(Restrictions.ilike("coLocation", "%" + coLocation.toLowerCase() + "%"));
			}
			criteria = criteria.add(Restrictions.eq("coEnabled", 1));
			criteria = criteria.addOrder(Order.desc("coDocumentId"));
			
			coDocumentlist = criteria.list();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		
		return coDocumentlist;
	}
	
	public static BigDecimal addCoDocument(String description, boolean isWebFolder, String folderPath, UserBean userBean) {
		CoDocument coDocument = new CoDocument();
		
		coDocument.setCoDescription(description);
		coDocument.setCoLocation(folderPath);
		coDocument.setCoLocationWithFilename("Y");
		if (isWebFolder) {
			coDocument.setCoWebFolder("Y");
		} else {
			coDocument.setCoWebFolder("N");
		}
		coDocument.setCoCreatedDate(new Date());
		coDocument.setCoCreatedUser(userBean.getLoginID());
		coDocument.setCoModifiedDate(new Date());
		coDocument.setCoModifiedUser(userBean.getLoginID());
		coDocument.setCoEnabled(1);
		
		BigDecimal coDocumentID = addCoDocument(coDocument);
		
		return coDocumentID;
	}
	
	public static BigDecimal addCoDocument(CoDocument coDocument) {
		if (coDocument == null) {
			return null;
		}
		
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		BigDecimal coDocumentId = null;
		
		try {
			transaction = session.beginTransaction();
			session.save(coDocument);
			transaction.commit();
			if (transaction.wasCommitted()) {
				coDocumentId = coDocument.getCoDocumentId();
			}
		} catch (HibernateException hex) {
			if (transaction != null) 
				transaction.rollback();
			throw hex;
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		
		return coDocumentId;
	}
	
	public static boolean update(CoDocument coDocument) {
		if (coDocument == null) {
			return false;
		}
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		boolean success = false;
		
		try {
			transaction = session.beginTransaction();
		
			session.update(coDocument);
			
			transaction.commit();
			success = transaction.wasCommitted();
		} catch (HibernateException hex) {
			if (transaction != null) 
				transaction.rollback();
			throw hex;
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		
		return success;
	}
	
	public static boolean updateDescription(BigDecimal coDocumentId, String description, UserBean userBean) {
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		CoDocument coDocument = null;
		boolean success = false;
		
		try {
			transaction = session.beginTransaction();
		
			coDocument = (CoDocument) session.get(CoDocument.class, coDocumentId);
			if (coDocument != null) {
				coDocument.setCoDescription(description);
				coDocument.setCoModifiedDate(new Date());
				coDocument.setCoModifiedUser(userBean.getLoginID());
			}
			
			session.update(coDocument);
			
			transaction.commit();
			success = transaction.wasCommitted();
		} catch (HibernateException hex) {
			if (transaction != null) 
				transaction.rollback();
			throw hex;
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		
		return success;
	}
	
	public static boolean updateLocation(BigDecimal coDocumentId, String description, String location, String webFolder, UserBean userBean) {
		return updateLocation(coDocumentId, description, location, webFolder, "Y", null, null, userBean);
	}
	
	public static boolean updateLocation(BigDecimal coDocumentId, String description, String location, String webFolder, 
			String locationWithFileName, String filePrefix, String fileSuffix, UserBean userBean) {
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		CoDocument coDocument = null;
		boolean success = false;
		
		try {
			transaction = session.beginTransaction();
		
			coDocument = (CoDocument) session.get(CoDocument.class, coDocumentId);
			if (coDocument != null) {
				coDocument.setCoDescription(description);
				coDocument.setCoLocation(location);
				coDocument.setCoWebFolder(webFolder);
				coDocument.setCoLocationWithFilename(locationWithFileName);
				coDocument.setCoFilePrefix(filePrefix);
				coDocument.setCoFileSuffix(fileSuffix);
				coDocument.setCoModifiedDate(new Date());
				coDocument.setCoModifiedUser(userBean.getLoginID());
			}
			
			session.update(coDocument);
			
			transaction.commit();
			success = transaction.wasCommitted();
		} catch (HibernateException hex) {
			if (transaction != null) 
				transaction.rollback();
			throw hex;
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		
		return success;
	}
	
	public static boolean deleteCoDocument(BigDecimal coDocumentId, UserBean userBean) {
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		CoDocument coDocument = null;
		boolean success = false;
		
		try {
			transaction = session.beginTransaction();
		
			coDocument = (CoDocument) session.get(CoDocument.class, coDocumentId);
			if (coDocument != null) {
				coDocument.setCoEnabled(0);
				coDocument.setCoModifiedDate(new Date());
				coDocument.setCoModifiedUser(userBean.getLoginID());
			}
			
			session.update(coDocument);
			
			transaction.commit();
			success = transaction.wasCommitted();
		} catch (HibernateException hex) {
			if (transaction != null) 
				transaction.rollback();
			throw hex;
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		
		return success;
	}
	
	public static boolean isFileModified(BigDecimal coDocumentId) {
		Long lastModified = null;
		boolean isFileModified = false;
		File file = null;
		
		CoDocument coDocument = DocumentDB2.getCoDocument(coDocumentId);
		if (coDocument != null) {
			file = new File(coDocument.getCoLocation());
			if (file != null) {
				lastModified = file.lastModified();
				if (lastModified != null && coDocument.getCoFileLastModified() != null
						&& lastModified.compareTo(coDocument.getCoFileLastModified().longValue()) > 0) {
					isFileModified = true;
				}
			}
		}
		
		return isFileModified;
	}
	
	public static boolean setFileLastModified(BigDecimal coDocumentId, UserBean userBean) {
		return setFileLastModified(coDocumentId, false, userBean);
	}
	
	public static boolean setFileLastModified(BigDecimal coDocumentId, boolean setOnlyWhenFieldIsNull, UserBean userBean) {
		Long lastModified = null;
		File file = null;
		boolean isUpdated = false;
		
		CoDocument coDocument = DocumentDB2.getCoDocument(coDocumentId);
		if (coDocument != null) {
			if (!setOnlyWhenFieldIsNull || (setOnlyWhenFieldIsNull && coDocument.getCoFileLastModified() == null)) {
				file = new File(coDocument.getCoLocation());
				if (file != null) {
					lastModified = file.lastModified();
				}
				coDocument.setCoFileLastModified(new BigDecimal(lastModified));
				coDocument.setCoModifiedDate(new Date());
				coDocument.setCoModifiedUser(userBean.getLoginID());
				
				isUpdated = update(coDocument);
			}
		}
		
		return isUpdated;
	}
}