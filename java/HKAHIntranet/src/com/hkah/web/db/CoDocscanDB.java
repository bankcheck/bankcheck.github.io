package com.hkah.web.db;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import org.apache.log4j.Logger;
import org.hibernate.Criteria;
import org.hibernate.FetchMode;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

import com.hkah.util.db.HibernateUtil;
import com.hkah.web.common.UserBean;
import com.hkah.web.db.helper.DocscanModelHelper;
import com.hkah.web.db.hibernate.CoDocscan;
import com.hkah.web.db.hibernate.CoDocscanDocument;
import com.hkah.web.db.hibernate.CoDocscanDocumentId;
import com.hkah.web.db.hibernate.CoDocscanId;

public class CoDocscanDB {
	private static Logger logger = Logger.getLogger(CoDocscanDB.class);
	
	//------------------------
	// Retrieve persistence objects
	//------------------------
	public static String getNextCoDocscanId(CoDocscanId id) {
		Session session = HibernateUtil.getCurrentSession();
		Query query = null;
		String coDocscanId = "1";
		
		try {
			String hql = 	"SELECT MAX(id.coDocscanId) + 1 " +
							"FROM 	CoDocscan " +
							"WHERE	id.coSiteCode = ?";
			query = session.createQuery(hql);
			int paraCount = 0;
			query.setString(paraCount++, id.getCoSiteCode());
			BigDecimal nextId = (BigDecimal) query.uniqueResult();
			if (nextId != null) {
				coDocscanId = String.valueOf(nextId);
			}
		} catch (HibernateException hex) {
			throw hex;
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			// cannot close session, otherwise call method cannot save the object
		}
		return coDocscanId;
	}
	
	//------------------------
	// Retrieve persistence objects
	//------------------------
	
	// Get single model
	//-----------------
	public static CoDocscanDocument getCoDocscanDocument(CoDocscanDocumentId id) {
		Session session = HibernateUtil.getCurrentSession();
		
		CoDocscanDocument coDocscanDocument = null;
		try {
			coDocscanDocument = (CoDocscanDocument) session.get(CoDocscanDocumentId.class, id);
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		
		}
		return coDocscanDocument;
	}
	
	public static CoDocscan getCoDocscan(CoDocscanId id) {
		return getCoDocscan(id, 1);
	}
	
	public static CoDocscan getCoDocscan(CoDocscanId id, Integer coEnabled) {
		Session session = HibernateUtil.getCurrentSession();
		
		CoDocscan coDocscan = null;
		try {
			Criteria criteria = session.createCriteria(CoDocscan.class)
									.setFetchMode("coDocscanDocuments", FetchMode.JOIN);;
			criteria = criteria.add(Restrictions.idEq(id));
			if (coEnabled != null) {
				criteria = criteria.add(Restrictions.eq("coEnabled", coEnabled));
			} 

			coDocscan = (CoDocscan) criteria.uniqueResult();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		return coDocscan;
	}
	
	// Get list
	//-----------------
	public static List<CoDocscan> getCoDocscanList() {
		return getCoDocscanList(null, 1);
	}
	
	public static List<CoDocscan> getCoDocscanList(BigDecimal eeParentDocscanId) {
		return getCoDocscanList(eeParentDocscanId, 1);
	}
	
	public static List<CoDocscan> getCoDocscanList(BigDecimal coParentCoDocscanId, Integer coEnabled) {
		Session session = HibernateUtil.getCurrentSession();
		List<CoDocscan> coDocscanList = null;
		
		try {
			Criteria criteria = session.createCriteria(CoDocscan.class);
			//.setFetchMode("coDocscanDocuments", FetchMode.EAGER);
			
			// criteria
			if (coParentCoDocscanId != null) {
				criteria = criteria.add(Restrictions.eq("coParentCoDocscanId", coParentCoDocscanId));
			}
			if (coEnabled != null) {
				criteria = criteria.add(Restrictions.eq("coEnabled", coEnabled));
			}
			
			// order
			criteria = criteria.addOrder(Order.desc("coSortOrder"));
			
			coDocscanList = criteria.list();
			
			// construct a tree structure
			coDocscanList = DocscanModelHelper.constructCoDocscanTree(coDocscanList, coParentCoDocscanId);
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		
		return coDocscanList;
	}
	
	public static List<CoDocscan> getCoDocscanAncestors(CoDocscanId id) {
		return getCoDocscanAncestors(id, 1, null);
	}
	
	public static List<CoDocscan> getCoDocscanAncestors(CoDocscanId id, Integer coEnabled, Integer maxLevel) {
		if (id == null) {
			return null;
		}
		final int MAX_LOOP = 100;
		Session session = HibernateUtil.getCurrentSession();
		Criteria criteria = null;
		List<CoDocscan> coDocscanList = null;
		CoDocscan coDocscan = null;
		boolean isSearchEnd = false;
		
		try {
			criteria = session.createCriteria(CoDocscan.class)
							.add(Restrictions.idEq(id))
							.add(Restrictions.eq("coEnabled", coEnabled));
			
			coDocscan = (CoDocscan) criteria.uniqueResult();
			if (coDocscan != null) {
				coDocscanList = new ArrayList<CoDocscan>();
				coDocscanList.add(coDocscan);
				
				while (!isSearchEnd) {
					criteria = session.createCriteria(CoDocscan.class)
									.add(Restrictions.eq("id.coDocscanId", coDocscan.getCoParentCoDocscanId()))
									.add(Restrictions.eq("coEnabled", coEnabled));
									
					coDocscan = (CoDocscan) criteria.uniqueResult();
					
					if (coDocscan != null) {
						coDocscanList.add(0, coDocscan);
					} else {
						isSearchEnd = true;
					}
					
					if (!isSearchEnd && 
							(coDocscanList.size() >= maxLevel || coDocscanList.size() >= MAX_LOOP)) {
						isSearchEnd = true;
					}
				}
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		
		return coDocscanList;
	}
	
	// Update list
	//-----------------
	public static boolean update(CoDocscan coDocscan) {
		if (coDocscan == null) {
			return false;
		}
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		boolean success = false;
		
		try {
			transaction = session.beginTransaction();
		
			session.update(coDocscan);
			
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
	
	public static boolean deleteCoDocscan(CoDocscanId id, UserBean userBean) {
		return deleteCoDocscan(id, userBean, 1);
	}
	
	public static boolean deleteCoDocscan(CoDocscanId id, UserBean userBean, Integer coEnabled) {
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		CoDocscan coDocscan = null;
		BigDecimal coParentCoDocscanId = null;
		List<CoDocscan> coDocscanList = null;
		boolean success = false;
		
		try {
			transaction = session.beginTransaction();
		
			coDocscan = (CoDocscan) session.get(CoDocscan.class, id);
			if (coDocscan != null) {
				coParentCoDocscanId = coDocscan.getCoParentCoDocscanId();
					
				coDocscan.setCoEnabled(0);
				coDocscan.setCoSortOrder(null);
				coDocscan.setCoModifiedDate(new Date());
				coDocscan.setCoModifiedUser(userBean.getLoginID());
			}
			session.update(coDocscan);
			
			//------------------------------------------------------
			// update sort order of other nodes in the same level
			//------------------------------------------------------
			Criteria criteria = session.createCriteria(CoDocscan.class);
			
			// criteria
			criteria = criteria.add(Restrictions.eq("coParentCoDocscanId", coParentCoDocscanId));
			if (coEnabled != null)
				criteria = criteria.add(Restrictions.eq("coEnabled", coEnabled));
			criteria = criteria.add(Restrictions.not(
	        		Restrictions.and(
	        				Restrictions.eq("id.coSiteCode", id.getCoSiteCode()), 
	        				Restrictions.eq("id.coDocscanId", id.getCoDocscanId()))));
			criteria = criteria.addOrder(Order.desc("coSortOrder"));
			
			coDocscanList = criteria.list();
			
			if (coDocscanList != null) {
				CoDocscan l_coDocscan = null;
			    Iterator<CoDocscan> itr = coDocscanList.iterator();
			    int listSize = coDocscanList.size();
			    while (itr.hasNext()){
			    	l_coDocscan = itr.next();
			    	if (l_coDocscan != null) {
			    		l_coDocscan.setCoSortOrder(BigDecimal.valueOf(listSize--));
			    		
			    		session.update(l_coDocscan);
			    	}
			    }
			}
			
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
	
	public static boolean deleteCoDocscanDocument(CoDocscanDocumentId id, UserBean userBean) {
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		CoDocscanDocument coDocscanDocument = null;
		boolean success = false;
		
		try {
			transaction = session.beginTransaction();
		
			coDocscanDocument = (CoDocscanDocument) session.get(CoDocscanDocument.class, id);
			if (coDocscanDocument != null) {
				coDocscanDocument.setCoEnabled(0);
				coDocscanDocument.setCoModifiedDate(new Date());
				coDocscanDocument.setCoModifiedUser(userBean.getLoginID());
			}
			session.update(coDocscanDocument);
			
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
	
	public static boolean updateCoDocscan(CoDocscanId id, 
			String coDescriptionEn, String coDescriptionZh, 
			UserBean userBean) {
		return  updateCoDocscan(id, 
				coDescriptionEn, coDescriptionZh, 
				null, null, userBean);
	}
	
	public static boolean updateCoDocscan(CoDocscanId id, 
			String coDescriptionEn, String coDescriptionZh, 
			String eeType, String eeBgColor, UserBean userBean) {
		if (id == null) {
			return false;
		}
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		CoDocscan eCoDocscan = null;
		boolean success = false;
		
		try {
			transaction = session.beginTransaction();
		
			Criteria criteria = session.createCriteria(CoDocscan.class);
			
			// criteria
			criteria = criteria.add(Restrictions.idEq(id));
			
			eCoDocscan = (CoDocscan) criteria.uniqueResult();
			
			if (eCoDocscan != null) {
				eCoDocscan.setCoDescriptionEn(coDescriptionEn);
				eCoDocscan.setCoDescriptionZh(coDescriptionZh);
				eCoDocscan.setCoModifiedDate(new Date());
				eCoDocscan.setCoModifiedUser(userBean.getLoginID());
				
				session.update(eCoDocscan);
				
				transaction.commit();
				success = transaction.wasCommitted();
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
		
		return success;
	}
	
	// upload document
	public static boolean updateOrInsertCoDocscanDocument(CoDocscanId coDocscanId,
			BigDecimal coDocumentId, UserBean userBean) {
		return updateOrInsertCoDocscanDocument(coDocscanId, coDocumentId, null, null, userBean);
	}
	
	// url
	public static boolean updateOrInsertCoDocscanDocument(CoDocscanId coDocscanId,
			String coUrl, UserBean userBean) {
		return updateOrInsertCoDocscanDocument(coDocscanId, null, coUrl, null, userBean);
	}
	
	public static boolean updateOrInsertCoDocscanDocument(CoDocscanId coDocscanId,
			BigDecimal coDocumentId, String coUrl, Integer coEnabled, UserBean userBean) {
		if (coDocscanId == null) {
			return false;
		}
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		CoDocscanDocument coDocscanDocument = null;
		boolean success = false;
		
		try {
			transaction = session.beginTransaction();
			Criteria criteria = session.createCriteria(CoDocscanDocument.class);
			
			// criteria
			criteria = criteria.add(Restrictions.eq("id.coSiteCode", coDocscanId.getCoSiteCode()));
			criteria = criteria.add(Restrictions.eq("id.coDocscanId", coDocscanId.getCoDocscanId()));
			if (coEnabled != null)
				criteria = criteria.add(Restrictions.eq("coEnabled", coEnabled));
			
			coDocscanDocument = (CoDocscanDocument) criteria.uniqueResult();
			if (coDocscanDocument == null) {
				// Insert
				coDocscanDocument = new CoDocscanDocument();
				CoDocscanDocumentId id = new CoDocscanDocumentId();
				id.setCoDocscanId(coDocscanId.getCoDocscanId());
				id.setCoSiteCode(coDocscanId.getCoSiteCode());
				coDocscanDocument.setId(id);
				
				if (coDocumentId != null) {
					coDocscanDocument.setCoDocumentId(coDocumentId);
					coDocscanDocument.setCoIsUrl("N");
					coDocscanDocument.setCoUrl(null);
				} else {
					coDocscanDocument.setCoDocumentId(null);
					coDocscanDocument.setCoIsUrl("Y");
					coDocscanDocument.setCoUrl(coUrl);
				}
				
				coDocscanDocument.setCoCreatedDate(new Date());
				coDocscanDocument.setCoCreatedUser(userBean.getLoginID());
				coDocscanDocument.setCoModifiedDate(new Date());
				coDocscanDocument.setCoModifiedUser(userBean.getLoginID());
				coDocscanDocument.setCoEnabled(1);
				
				session.save(coDocscanDocument);
			} else {
				// Update
				if (coDocumentId != null) {
					coDocscanDocument.setCoDocumentId(coDocumentId);
					coDocscanDocument.setCoIsUrl("N");
					coDocscanDocument.setCoUrl(null);
				} else {
					coDocscanDocument.setCoDocumentId(null);
					coDocscanDocument.setCoIsUrl("Y");
					coDocscanDocument.setCoUrl(coUrl);
				}
				coDocscanDocument.setCoModifiedDate(new Date());
				coDocscanDocument.setCoModifiedUser(userBean.getLoginID());
				coDocscanDocument.setCoEnabled(1);
				
				session.update(coDocscanDocument);
			}
			
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
	
	public static boolean updateCoDocscanSortOrder(String coSiteCode, BigDecimal[] ids, 
			UserBean userBean) {
		if (ids == null) {
			return false;
		}
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		CoDocscan eCoDocscan = null;
		List<CoDocscan> coDocscanList = null;
		boolean success = false;
		
		try {
			transaction = session.beginTransaction();
			Criteria criteria = session.createCriteria(CoDocscan.class);
			
			// criteria
			criteria = criteria.add(Restrictions.eq("id.coSiteCode", coSiteCode));
			criteria = criteria.add(Restrictions.in("id.coDocscanId", ids));
			
			coDocscanList = criteria.list();
			if (coDocscanList != null) {
				Iterator<CoDocscan> itr = coDocscanList.iterator();
				while (itr.hasNext()) {
					eCoDocscan = itr.next();
					boolean isFound = false;
					Integer order = ids.length;
					
					// sort order is in descending manner
					for (int i = 0; i < ids.length && !isFound; i++) {
						if (eCoDocscan.getId().getCoDocscanId().equals(ids[i])) {
							eCoDocscan.setCoSortOrder(new BigDecimal(order));
							eCoDocscan.setCoModifiedDate(new Date());
							eCoDocscan.setCoModifiedUser(userBean.getLoginID());
							isFound = true;
							
							session.update(eCoDocscan);
						}
						order--;
					}
				}
			}
			
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
	
	public static CoDocscan addCoDocscan(String coSiteCode, BigDecimal coParentCoDocscanId,
			String coDescriptionEn, String coDescriptionZh, UserBean userBean) {
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		CoDocscan coDocscan = null;
		CoDocscanId id = null;
		BigDecimal nextCoSortOrder = null;
		boolean success = false;
		
		try {
			transaction = session.beginTransaction();
		
			// Get the next sort order sequence
			List<BigDecimal> maxCoSortOrder = null;
			String hql = "SELECT	MAX(coSortOrder) + 1 " +
						 "FROM 		CoDocscan " +
						 "WHERE 	id.coSiteCode = ? ";
			if (coParentCoDocscanId != null) {
				hql += "  AND		coParentCoDocscanId = ?";
			} else {
				hql += "  AND		coParentCoDocscanId IS NULL";
			}
			
			int paraCount = 0;
			Query query = session.createQuery(hql)
							.setString(paraCount++, coSiteCode);
			if (coParentCoDocscanId != null) {
				query = query.setBigDecimal(paraCount++, coParentCoDocscanId);
			}
			maxCoSortOrder = query.list();
			
			if (maxCoSortOrder != null && !maxCoSortOrder.isEmpty() && maxCoSortOrder.get(0) != null) {
				nextCoSortOrder = maxCoSortOrder.get(0);
			} else {
				nextCoSortOrder = new BigDecimal("1");
			}
			
			// Create new instance
			coDocscan = new CoDocscan();
			id = new CoDocscanId();
			id.setCoSiteCode(coSiteCode);
			coDocscan.setId(id);
			coDocscan.setCoParentCoDocscanId(coParentCoDocscanId);
			coDocscan.setCoDescriptionEn(coDescriptionEn);
			coDocscan.setCoDescriptionZh(coDescriptionZh);
			coDocscan.setCoSortOrder(nextCoSortOrder);
			coDocscan.setCoCreatedDate(new Date());
			coDocscan.setCoCreatedUser(userBean.getLoginID());
			coDocscan.setCoModifiedDate(new Date());
			coDocscan.setCoModifiedUser(userBean.getLoginID());
			coDocscan.setCoEnabled(1);
			
			session.save(coDocscan);
			
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
		
		if (!success) {
			coDocscan = null;
		}
		
		return coDocscan;
	}
}
