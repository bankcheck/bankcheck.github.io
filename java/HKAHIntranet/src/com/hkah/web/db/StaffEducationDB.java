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
import com.hkah.web.db.helper.StaffEducationModelHelper;
import com.hkah.web.db.hibernate.EeMenuContent;
import com.hkah.web.db.hibernate.EeMenuContentId;
import com.hkah.web.db.hibernate.EeMenuContentInservReview;
import com.hkah.web.db.hibernate.EeMenuDocument;
import com.hkah.web.db.hibernate.EeMenuDocumentId;
import com.hkah.web.db.hibernate.EeMenuModule;
import com.hkah.web.db.hibernate.EeMenuModuleId;

public class StaffEducationDB {
	private static Logger logger = Logger.getLogger(StaffEducationDB.class);
	
	//------------------------
	// Retrieve persistence objects
	//------------------------
	public static String getNextEeMenuContentId(EeMenuContentId id) {
		Session session = HibernateUtil.getCurrentSession();
		Query query = null;
		String eeMenuContentId = "1";
		
		try {
			String hql = 	"SELECT MAX(id.eeMenuContentId) + 1 " +
							"FROM 	EeMenuContent " +
							"WHERE	id.eeSiteCode = ?";
			query = session.createQuery(hql);
			int paraCount = 0;
			query.setString(paraCount++, id.getEeSiteCode());
			BigDecimal nextId = (BigDecimal) query.uniqueResult();
			if (nextId != null) {
				eeMenuContentId = String.valueOf(nextId);
			}
		} catch (HibernateException hex) {
			throw hex;
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			// cannot close session, otherwise call method cannot save the object
		}
		return eeMenuContentId;
	}
	
	//------------------------
	// Retrieve persistence objects
	//------------------------
	
	// Get single model
	//-----------------
	public static EeMenuModule getEeMenuModule(EeMenuModuleId eeMenuModuleId) {
		Session session = HibernateUtil.getCurrentSession();
		
		EeMenuModule eeMenuModule = null;
		try {
			eeMenuModule = (EeMenuModule) session.get(EeMenuModule.class, eeMenuModuleId);
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		
		}
		return eeMenuModule;
	}
	
	public static EeMenuDocument getEeMenuDocument(EeMenuDocumentId id) {
		Session session = HibernateUtil.getCurrentSession();
		
		EeMenuDocument eeMenuDocument = null;
		try {
			eeMenuDocument = (EeMenuDocument) session.get(EeMenuDocumentId.class, id);
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		
		}
		return eeMenuDocument;
	}
	
	public static EeMenuContent getEeMenuContent(EeMenuContentId id) {
		return getEeMenuContent(id, null, null);
	}
	
	public static EeMenuContent getEeMenuContent(EeMenuContentId id, String eeModuleCode) {
		return getEeMenuContent(id, null, 1);
	}
	
	public static EeMenuContent getEeMenuContent(EeMenuContentId id, String eeModuleCode, 
			Integer eeEnabled) {
		Session session = HibernateUtil.getCurrentSession();
		
		EeMenuContent eeMenuContent = null;
		try {
			Criteria criteria = session.createCriteria(EeMenuContent.class)
									.setFetchMode("eeMenuDocuments", FetchMode.JOIN);;
			criteria = criteria.add(Restrictions.idEq(id));
			if (eeModuleCode != null) {
				criteria = criteria.add(Restrictions.eq("eeModuleCode", eeModuleCode));
			}
			if (eeEnabled != null) {
				criteria = criteria.add(Restrictions.eq("eeEnabled", eeEnabled));
			} 

			eeMenuContent = (EeMenuContent) criteria.uniqueResult();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		return eeMenuContent;
	}
	
	// Get list
	//-----------------
	public static List<EeMenuModule> getEeMenuModuleList() {
		return getEeMenuModuleList(null);
	}
	
	public static List<EeMenuModule> getEeMenuModuleList(Integer eeEnabled) {
		Session session = HibernateUtil.getCurrentSession();
		List<EeMenuModule> eeMenuModuleList = null;
		
		try {
			Criteria criteria = session.createCriteria(EeMenuModule.class);
			
			// criteria
			if (eeEnabled != null) {
				criteria = criteria.add(Restrictions.eq("eeEnabled", eeEnabled));
			}
			// order
			criteria = criteria.addOrder(Order.desc("eeSortOrder"));
			
			eeMenuModuleList = criteria.list();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		
		return eeMenuModuleList;
	}
	
	public static List<EeMenuContent> getEeMenuContentList() {
		return getEeMenuContentList(null, null, null);
	}
	
	public static List<EeMenuContent> getEeMenuContentList(String eeModuleCode) {
		return getEeMenuContentList(eeModuleCode, null, 1, null);
	}
	
	public static List<EeMenuContent> getEeMenuContentList(String eeModuleCode, String[] associationFetch) {
		return getEeMenuContentList(eeModuleCode, null, 1, associationFetch);
	}
	
	public static List<EeMenuContent> getEeMenuContentList(String eeModuleCode, BigDecimal eeParentMenuContentId
			, String[] associationFetch) {
		return getEeMenuContentList(eeModuleCode, eeParentMenuContentId, 1, associationFetch);
	}
	
	public static List<EeMenuContent> getEeMenuContentList(String eeModuleCode, 
			BigDecimal eeParentMenuContentId, Integer eeEnabled, String[] associationFetch) {
		Session session = HibernateUtil.getCurrentSession();
		List<EeMenuContent> eeMenuContentList = null;
		
		try {
			Criteria criteria = session.createCriteria(EeMenuContent.class);
									//.setFetchMode("eeMenuDocuments", FetchMode.EAGER);
			
			// association
			if (associationFetch != null) {
				for (String association : associationFetch) {
					//criteria = criteria.setFetchMode(association, FetchMode.);
				}
			}
			
			// criteria
			if (eeModuleCode != null) {
				criteria = criteria.add(Restrictions.eq("eeModuleCode", eeModuleCode));
			}
			if (eeParentMenuContentId != null) {
				criteria = criteria.add(Restrictions.eq("eeParentMenuContentId", eeParentMenuContentId));
			}
			if (eeEnabled != null) {
				criteria = criteria.add(Restrictions.eq("eeEnabled", eeEnabled));
			}
			
			// order
			criteria = criteria.addOrder(Order.desc("eeSortOrder"));
			
			eeMenuContentList = criteria.list();
			
			// construct a tree structure
			eeMenuContentList = StaffEducationModelHelper.constructEeMenuContentTree(eeMenuContentList, eeParentMenuContentId);
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		
		return eeMenuContentList;
	}
	
	public static List<EeMenuContent> getEeMenuContentAncestors(EeMenuContentId id, String eeModuleCode, 
			Integer maxLevel) {
		return getEeMenuContentAncestors(id, eeModuleCode, 1, maxLevel, null);
	}
	
	public static List<EeMenuContent> getEeMenuContentAncestors(EeMenuContentId id, String eeModuleCode, 
			Integer maxLevel, String[] associationFetch) {
		return getEeMenuContentAncestors(id, eeModuleCode, 1, maxLevel, associationFetch);
	}
	
	public static List<EeMenuContent> getEeMenuContentAncestors(EeMenuContentId id, String eeModuleCode, 
			Integer eeEnabled, Integer maxLevel, String[] associationFetch) {
		if (id == null) {
			return null;
		}
		final int MAX_LOOP = 5;
		Session session = HibernateUtil.getCurrentSession();
		Criteria criteria = null;
		List<EeMenuContent> eeMenuContentList = null;
		EeMenuContent eeMenuContent = null;
		boolean isSearchEnd = false;
		
		try {
			criteria = session.createCriteria(EeMenuContent.class)
							.add(Restrictions.eq("eeModuleCode", eeModuleCode))
							.add(Restrictions.idEq(id))
							.add(Restrictions.eq("eeEnabled", eeEnabled));
			
			// association
			if (associationFetch != null) {
				for (String association : associationFetch) {
					criteria = criteria.setFetchMode(association, FetchMode.JOIN);
				}
			}
			
			eeMenuContent = (EeMenuContent) criteria.uniqueResult();
			if (eeMenuContent != null) {
				eeMenuContentList = new ArrayList<EeMenuContent>();
				eeMenuContentList.add(eeMenuContent);
				
				while (!isSearchEnd) {
					criteria = session.createCriteria(EeMenuContent.class)
									.add(Restrictions.eq("eeModuleCode", eeModuleCode))
									.add(Restrictions.eq("id.eeMenuContentId", eeMenuContent.getEeParentMenuContentId()))
									.add(Restrictions.eq("eeEnabled", eeEnabled));
					
					// association
					if (associationFetch != null) {
						for (String association : associationFetch) {
							criteria = criteria.setFetchMode(association, FetchMode.JOIN);
						}
					}
									
					eeMenuContent = (EeMenuContent) criteria.uniqueResult();
					
					if (eeMenuContent != null) {
						eeMenuContentList.add(0, eeMenuContent);
					} else {
						isSearchEnd = true;
					}
					
					if (!isSearchEnd && 
							(eeMenuContentList.size() >= maxLevel || eeMenuContentList.size() >= MAX_LOOP)) {
						isSearchEnd = true;
					}
				}
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		
		return eeMenuContentList;
	}
	
	public static Date getModuleRevisedDate(EeMenuModuleId eeMenuModuleId) {
		if (eeMenuModuleId == null) {
			return null;
		}
		Session session = HibernateUtil.getCurrentSession();
		EeMenuModule eeMenuModule = null;
		Date revisedDate = null;
		
		try {
			Criteria criteria = session.createCriteria(EeMenuModule.class);
			
			// criteria
			criteria = criteria.add(Restrictions.eq("id.eeModuleCode", eeMenuModuleId.getEeModuleCode()));
			criteria = criteria.add(Restrictions.eq("id.eeSiteCode", eeMenuModuleId.getEeSiteCode()));
			
			eeMenuModule = (EeMenuModule) criteria.uniqueResult();
			if (eeMenuModule != null){
				revisedDate = eeMenuModule.getEeRevisedDate();
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}

		return revisedDate;
	}
	
	// Update list
	//-----------------
	public static boolean update(EeMenuContent eeMenuContent) {
		if (eeMenuContent == null) {
			return false;
		}
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		boolean success = false;
		
		try {
			transaction = session.beginTransaction();
		
			session.update(eeMenuContent);
			
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
	
	public static boolean deleteEeMenuContent(EeMenuContentId id, String eeModuleCode, UserBean userBean) {
		return deleteEeMenuContent(id, eeModuleCode, userBean, 1);
	}
	
	public static boolean deleteEeMenuContent(EeMenuContentId id, String eeModuleCode, UserBean userBean,
			Integer eeEnabled) {
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		EeMenuContent eeMenuContent = null;
		BigDecimal eeParentMenuContentId = null;
		List<EeMenuContent> eeMenuContentList = null;
		boolean success = false;
		
		try {
			transaction = session.beginTransaction();
		
			eeMenuContent = (EeMenuContent) session.get(EeMenuContent.class, id);
			if (eeMenuContent != null) {
				eeParentMenuContentId = eeMenuContent.getEeParentMenuContentId();
					
				eeMenuContent.setEeEnabled(0);
				eeMenuContent.setEeSortOrder(null);
				eeMenuContent.setEeModifiedDate(new Date());
				eeMenuContent.setEeModifiedUser(userBean.getLoginID());
			}
			session.update(eeMenuContent);
			
			//------------------------------------------------------
			// update sort order of other nodes in the same level
			//------------------------------------------------------
			Criteria criteria = session.createCriteria(EeMenuContent.class);
			
			// criteria
			criteria = criteria.add(Restrictions.eq("eeModuleCode", eeModuleCode));
			criteria = criteria.add(Restrictions.eq("eeParentMenuContentId", eeParentMenuContentId));
			if (eeEnabled != null)
				criteria = criteria.add(Restrictions.eq("eeEnabled", eeEnabled));
			criteria = criteria.add(Restrictions.not(
	        		Restrictions.and(
	        				Restrictions.eq("id.eeSiteCode", id.getEeSiteCode()), 
	        				Restrictions.eq("id.eeMenuContentId", id.getEeMenuContentId()))));
			criteria = criteria.addOrder(Order.desc("eeSortOrder"));
			
			eeMenuContentList = criteria.list();
			
			if (eeMenuContentList != null) {
				EeMenuContent l_eeMenuContent = null;
			    Iterator<EeMenuContent> itr = eeMenuContentList.iterator();
			    int listSize = eeMenuContentList.size();
			    while (itr.hasNext()){
			    	l_eeMenuContent = itr.next();
			    	if (l_eeMenuContent != null) {
			    		l_eeMenuContent.setEeSortOrder(BigDecimal.valueOf(listSize--));
			    		
			    		session.update(l_eeMenuContent);
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
	
	public static boolean deleteEeMenuDocument(EeMenuDocumentId id, String eeModuleCode, UserBean userBean) {
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		EeMenuDocument eeMenuDocument = null;
		boolean success = false;
		
		try {
			transaction = session.beginTransaction();
		
			eeMenuDocument = (EeMenuDocument) session.get(EeMenuDocument.class, id);
			if (eeMenuDocument != null) {
				eeMenuDocument.setEeEnabled(0);
				eeMenuDocument.setEeModifiedDate(new Date());
				eeMenuDocument.setEeModifiedUser(userBean.getLoginID());
			}
			session.update(eeMenuDocument);
			
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
	
	public static boolean updateEeMenuContent(EeMenuContentId id, String eeModuleCode, 
			String eeDescriptionEn, String eeDescriptionZh, String eeInserviceContentDescriptionEn, 
			String eeInserviceContentDescriptionZh, UserBean userBean) {
		return  updateEeMenuContent(id, eeModuleCode, 
				eeDescriptionEn, eeDescriptionZh, eeInserviceContentDescriptionEn, 
				eeInserviceContentDescriptionZh, null, userBean);
	}
	
	public static boolean updateEeMenuContent(EeMenuContentId id, String eeModuleCode, 
			String eeDescriptionEn, String eeDescriptionZh, String eeInserviceContentDescriptionEn, 
			String eeInserviceContentDescriptionZh, String eeType, UserBean userBean) {
		return  updateEeMenuContent(id, eeModuleCode, 
				eeDescriptionEn, eeDescriptionZh, eeInserviceContentDescriptionEn, 
				eeInserviceContentDescriptionZh, null, null, userBean,false);
	}
	
	public static boolean updateEeMenuContent(EeMenuContentId id, String eeModuleCode, 
			String eeDescriptionEn, String eeDescriptionZh, String eeInserviceContentDescriptionEn, 
			String eeInserviceContentDescriptionZh, String eeType, String eeBgColor, UserBean userBean) {
		return  updateEeMenuContent(id, eeModuleCode, 
				eeDescriptionEn, eeDescriptionZh, eeInserviceContentDescriptionEn, 
				eeInserviceContentDescriptionZh, null, null, userBean,false);
	}
	
	public static boolean updateEeMenuContent(EeMenuContentId id, String eeModuleCode, 
			String eeDescriptionEn, String eeDescriptionZh, String eeInserviceContentDescriptionEn, 
			String eeInserviceContentDescriptionZh, String eeType, String eeBgColor, UserBean userBean,boolean isIsReview) {
		if (id == null) {
			return false;
		}
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		EeMenuContent eEeMenuContent = null;
		boolean success = false;
		
		try {
			transaction = session.beginTransaction();
		
			Criteria criteria = session.createCriteria(EeMenuContent.class);
			
			// criteria
			criteria = criteria.add(Restrictions.idEq(id));
			criteria = criteria.add(Restrictions.eq("eeModuleCode", eeModuleCode));
			
			eEeMenuContent = (EeMenuContent) criteria.uniqueResult();
			
			if (eEeMenuContent != null) {
				eEeMenuContent.setEeDescriptionEn(eeDescriptionEn);	
				eEeMenuContent.setEeDescriptionZh(eeDescriptionZh);
				eEeMenuContent.setEeType(eeType);
				eEeMenuContent.setEeBgColor(eeBgColor);
				eEeMenuContent.setEeModifiedDate(new Date());
				eEeMenuContent.setEeModifiedUser(userBean.getLoginID());
				EeMenuContentInservReview review = eEeMenuContent.getEeMenuContentInservReview();
				if (isIsReview) {
					if(review != null){
						review.setEeCategoryDescriptionEn(eeDescriptionEn);
						review.setEeCategoryDescriptionZh(eeDescriptionZh);
					}else if(review==null){
						EeMenuContentInservReview isReview = null;
						isReview.setEeCategoryDescriptionEn(eeDescriptionEn);
						isReview.setEeCategoryDescriptionZh(eeDescriptionZh);
						eEeMenuContent.setEeMenuContentInservReview(isReview);
					}
				}
				
				session.update(eEeMenuContent);
				
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
	public static boolean updateOrInsertEeMenuDocument(EeMenuContentId eeMenuContentId, String eeModuleCode,
			BigDecimal eeDocumentId, UserBean userBean) {
		return updateOrInsertEeMenuDocument(eeMenuContentId, eeModuleCode, eeDocumentId, null, 1, userBean);
	}
	
	// url
	public static boolean updateOrInsertEeMenuDocument(EeMenuContentId eeMenuContentId, String eeModuleCode,
			String eeUrl, UserBean userBean) {
		return updateOrInsertEeMenuDocument(eeMenuContentId, eeModuleCode, null, eeUrl, 1, userBean);
	}
	
	public static boolean updateOrInsertEeMenuDocument(EeMenuContentId eeMenuContentId, String eeModuleCode,
			BigDecimal eeDocumentId, String eeUrl, Integer eeEnabled, UserBean userBean) {
		if (eeMenuContentId == null) {
			return false;
		}
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		EeMenuDocument eeMenuDocument = null;
		boolean success = false;
		
		try {
			transaction = session.beginTransaction();
			Criteria criteria = session.createCriteria(EeMenuDocument.class);
			
			// criteria
			criteria = criteria.add(Restrictions.eq("id.eeSiteCode", eeMenuContentId.getEeSiteCode()));
			criteria = criteria.add(Restrictions.eq("id.eeMenuContentId", eeMenuContentId.getEeMenuContentId()));
			criteria = criteria.add(Restrictions.eq("eeModuleCode", eeModuleCode));
			if (eeEnabled != null)
				criteria = criteria.add(Restrictions.eq("eeEnabled", eeEnabled));
			
			eeMenuDocument = (EeMenuDocument) criteria.uniqueResult();
			if (eeMenuDocument == null) {
				// Insert
				eeMenuDocument = new EeMenuDocument();
				EeMenuDocumentId id = new EeMenuDocumentId();
				id.setEeMenuContentId(eeMenuContentId.getEeMenuContentId());
				id.setEeSiteCode(eeMenuContentId.getEeSiteCode());
				eeMenuDocument.setId(id);
				eeMenuDocument.setEeModuleCode(eeModuleCode);
				
				if (eeDocumentId != null) {
					eeMenuDocument.setEeDocumentId(eeDocumentId);
					eeMenuDocument.setEeIsUrl("N");
					eeMenuDocument.setEeUrl(null);
				} else {
					eeMenuDocument.setEeDocumentId(null);
					eeMenuDocument.setEeIsUrl("Y");
					eeMenuDocument.setEeUrl(eeUrl);
				}
				
				eeMenuDocument.setEeCreatedDate(new Date());
				eeMenuDocument.setEeCreatedUser(userBean.getLoginID());
				eeMenuDocument.setEeModifiedDate(new Date());
				eeMenuDocument.setEeModifiedUser(userBean.getLoginID());
				eeMenuDocument.setEeEnabled(1);
				
				session.save(eeMenuDocument);
				
			} else {
				// Update
				if (eeDocumentId != null) {
					eeMenuDocument.setEeDocumentId(eeDocumentId);
					eeMenuDocument.setEeIsUrl("N");
					eeMenuDocument.setEeUrl(null);
				} else {
					eeMenuDocument.setEeDocumentId(null);
					eeMenuDocument.setEeIsUrl("Y");
					eeMenuDocument.setEeUrl(eeUrl);
				}
				eeMenuDocument.setEeModifiedDate(new Date());
				eeMenuDocument.setEeModifiedUser(userBean.getLoginID());
				
				session.update(eeMenuDocument);
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
	
	public static boolean updateEeMenuContentSortOrder(String eeSiteCode, BigDecimal[] ids, 
			UserBean userBean) {
		if (ids == null) {
			return false;
		}
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		EeMenuContent eEeMenuContent = null;
		List<EeMenuContent> eeMenuContentList = null;
		boolean success = false;
		
		try {
			transaction = session.beginTransaction();
			Criteria criteria = session.createCriteria(EeMenuContent.class);
			
			// criteria
			criteria = criteria.add(Restrictions.eq("id.eeSiteCode", eeSiteCode));
			criteria = criteria.add(Restrictions.in("id.eeMenuContentId", ids));
			
			eeMenuContentList = criteria.list();
			if (eeMenuContentList != null) {
				Iterator<EeMenuContent> itr = eeMenuContentList.iterator();
				while (itr.hasNext()) {
					eEeMenuContent = itr.next();
					boolean isFound = false;
					Integer order = ids.length;
					
					// sort order is in descending manner
					for (int i = 0; i < ids.length && !isFound; i++) {
						if (eEeMenuContent.getId().getEeMenuContentId().equals(ids[i])) {
							eEeMenuContent.setEeSortOrder(new BigDecimal(order));
							eEeMenuContent.setEeModifiedDate(new Date());
							eEeMenuContent.setEeModifiedUser(userBean.getLoginID());
							isFound = true;
							
							session.update(eEeMenuContent);
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
	
	public static EeMenuContent addEeMenuContent(String eeSiteCode, String eeModuleCode, BigDecimal eeParentMenuContentId,
			String eeDescriptionEn, String eeDescriptionZh, String eeInserviceContentDescriptionEn, 
			String eeInserviceContentDescriptionZh, UserBean userBean) {
		return addEeMenuContent(eeSiteCode, eeModuleCode, eeParentMenuContentId, eeDescriptionEn, eeDescriptionZh, 
				eeInserviceContentDescriptionEn, eeInserviceContentDescriptionZh, null, userBean);
	}
	
	public static EeMenuContent addEeMenuContent(String eeSiteCode, String eeModuleCode, BigDecimal eeParentMenuContentId,
			String eeDescriptionEn, String eeDescriptionZh, String eeInserviceContentDescriptionEn, 
			String eeInserviceContentDescriptionZh, String eeType, UserBean userBean) {
		return addEeMenuContent(eeSiteCode, eeModuleCode, eeParentMenuContentId, eeDescriptionEn, eeDescriptionZh, 
				eeInserviceContentDescriptionEn, eeInserviceContentDescriptionZh, null, null, userBean);
	}
	
	public static EeMenuContent addEeMenuContent(String eeSiteCode, String eeModuleCode, BigDecimal eeParentMenuContentId,
			String eeDescriptionEn, String eeDescriptionZh, String eeInserviceContentDescriptionEn, 
			String eeInserviceContentDescriptionZh, String eeType, String eeBgColor, UserBean userBean) {
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		EeMenuContent eeMenuContent = null;
		EeMenuContentId id = null;
		BigDecimal nextEeSortOrder = null;
		boolean success = false;
		
		try {
			transaction = session.beginTransaction();
		
			// Get the next sort order sequence
			List<BigDecimal> maxEeSortOrder = null;
			String hql = "SELECT	MAX(eeSortOrder) + 1 " +
						 "FROM 		EeMenuContent " +
						 "WHERE 	id.eeSiteCode = ? " +
						 "  AND 	eeModuleCode = ? ";
			if (eeParentMenuContentId != null) {
				hql += "  AND		eeParentMenuContentId = ?";
			} else {
				hql += "  AND		eeParentMenuContentId IS NULL";
			}
			
			int paraCount = 0;
			Query query = session.createQuery(hql)
							.setString(paraCount++, eeSiteCode)
							.setString(paraCount++, eeModuleCode);
			if (eeParentMenuContentId != null) {
				query = query.setBigDecimal(paraCount++, eeParentMenuContentId);
			}
			maxEeSortOrder = query.list();
			
			if (maxEeSortOrder != null && !maxEeSortOrder.isEmpty() && maxEeSortOrder.get(0) != null) {
				nextEeSortOrder = maxEeSortOrder.get(0);
			} else {
				nextEeSortOrder = new BigDecimal("1");
			}
			
			// Create new instance
			eeMenuContent = new EeMenuContent();
			id = new EeMenuContentId();
			id.setEeSiteCode(eeSiteCode);
			eeMenuContent.setId(id);
			eeMenuContent.setEeModuleCode(eeModuleCode);
			eeMenuContent.setEeParentMenuContentId(eeParentMenuContentId);
			eeMenuContent.setEeDescriptionEn(eeDescriptionEn);
			eeMenuContent.setEeDescriptionZh(eeDescriptionZh);
			eeMenuContent.setEeType(eeType);
			eeMenuContent.setEeBgColor(eeBgColor);
			eeMenuContent.setEeSortOrder(nextEeSortOrder);
			eeMenuContent.setEeCreatedDate(new Date());
			eeMenuContent.setEeCreatedUser(userBean.getLoginID());
			eeMenuContent.setEeModifiedDate(new Date());
			eeMenuContent.setEeModifiedUser(userBean.getLoginID());
			eeMenuContent.setEeEnabled(1);
			
			session.save(eeMenuContent);
			
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
			eeMenuContent = null;
		}
		
		return eeMenuContent;
	}
}
