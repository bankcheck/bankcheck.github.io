package com.hkah.web.db;

import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.ScrollableResults;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.criterion.CriteriaSpecification;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

import com.hkah.util.db.HibernateUtil;
import com.hkah.web.common.UserBean;
import com.hkah.web.db.hibernate.DbComment;
import com.hkah.web.db.hibernate.DbCommentContact;
import com.hkah.web.db.hibernate.DbCommentContactId;
import com.hkah.web.db.hibernate.DbCommentHistory;
import com.hkah.web.db.hibernate.DbCommentHistoryId;
import com.hkah.web.db.hibernate.DbCommentId;
import com.hkah.web.db.hibernate.DbCommentTypes;
import com.hkah.web.db.hibernate.DbCommentTypesId;

public class DbCommentDB {
	
	protected static final Log logger = LogFactory.getLog(HAACheckListDB2.class);
	
	//---------
	// constant
	//---------
	
	//------------------------
	// Retrieve persistence objects
	//------------------------
	public static DbComment get(DbCommentId id) {
		Session session = HibernateUtil.getCurrentSession();
		
		DbComment dbComment = null;
		
		try {
			dbComment = (DbComment) session.get(DbComment.class, id);
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		
		}
		return dbComment;
	}
	
	public static DbCommentHistory get(DbCommentHistoryId id) {
		Session session = HibernateUtil.getCurrentSession();
		
		DbCommentHistory dbCommentHistory = null;
		
		try {
			dbCommentHistory = (DbCommentHistory) session.get(DbCommentHistory.class, id);
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		
		}
		return dbCommentHistory;
	}
	
	public static DbCommentTypes get(DbCommentTypesId id) {
		Session session = HibernateUtil.getCurrentSession();
		
		DbCommentTypes dbCommentTypes = null;
		
		try {
			dbCommentTypes = (DbCommentTypes) session.get(DbCommentTypes.class, id);
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		
		}
		return dbCommentTypes;
	}
	
	public static BigDecimal getNextDbCommentId(DbCommentId id) {
		Session session = HibernateUtil.getCurrentSession();
		BigDecimal dbCommentId = new BigDecimal(1);

		try {
			String hql = 	"SELECT MAX(id.dbCommentId) + 1 " +
							"FROM 	DbComment " +
							"WHERE	id.dbSiteCode = ?" +
							"  AND	id.dbModuleCode = ?" +
							"  AND	id.dbRecordId = ?";
			Query query = session.createQuery(hql);
			int paraCount = 0;
			query.setString(paraCount++, id.getDbSiteCode());
			query.setString(paraCount++, id.getDbModuleCode());
			query.setBigDecimal(paraCount++, id.getDbRecordId());
			BigDecimal nextId = (BigDecimal) query.uniqueResult();
			if (nextId != null) {
				dbCommentId = nextId;
			}
		} catch (HibernateException hex) {
			throw hex;
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			// cannot close session, otherwise parent object cannot be saved
		}
		return dbCommentId;
	}
	
	public static BigDecimal getNextDbCommentSeq(DbCommentId id) {
		Session session = HibernateUtil.getCurrentSession();
		BigDecimal dbCommentSeq = new BigDecimal(1);

		try {
			String hql = 	"SELECT MAX(id.dbCommentSeq) + 1 " +
							"FROM 	DbComment " +
							"WHERE	id.dbSiteCode = ? " +
							"  AND	id.dbModuleCode = ? " +
							"  AND	id.dbRecordId = ? " +
							"  AND	id.dbCommentId = ? ";
			Query query = session.createQuery(hql);
			int paraCount = 0;
			query.setString(paraCount++, id.getDbSiteCode());
			query.setString(paraCount++, id.getDbModuleCode());
			query.setBigDecimal(paraCount++, id.getDbRecordId());
			query.setBigDecimal(paraCount++, id.getDbCommentId());
			BigDecimal nextId = (BigDecimal) query.uniqueResult();
			if (nextId != null) {
				dbCommentSeq = nextId;
			}
		} catch (HibernateException hex) {
			throw hex;
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			// cannot close session, otherwise parent object cannot be saved
		}
		return dbCommentSeq;
	}
	
	public static String getNextDbCommentHistoryId(DbCommentHistoryId id) {
		Session session = HibernateUtil.getCurrentSession();
		String dbCommentHistoryId = "1";

		try {
			String hql = 	"SELECT MAX(id.dbCommentHistoryId) + 1 " +
							"FROM 	DbCommentHistory " +
							"WHERE	id.dbSiteCode = ?" +
							"  AND	id.dbModuleCode = ?" +
							"  AND	id.dbRecordId = ?" +
							"  AND	id.dbCommentId = ?";
			Query query = session.createQuery(hql);
			int paraCount = 0;
			query.setString(paraCount++, id.getDbSiteCode());
			query.setString(paraCount++, id.getDbModuleCode());
			query.setBigDecimal(paraCount++, id.getDbRecordId());
			query.setBigDecimal(paraCount++, id.getDbCommentId());
			BigDecimal nextId = (BigDecimal) query.uniqueResult();
			if (nextId != null) {
				dbCommentHistoryId = String.valueOf(nextId);
			}
		} catch (HibernateException hex) {
			throw hex;
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			// cannot close session, otherwise parent object cannot be saved
		}
		return dbCommentHistoryId;
	}
	
	public static String getNextDbCommentContactId(DbCommentContactId id) {
		Session session = HibernateUtil.getCurrentSession();
		String dbCommentContactId = "1";

		try {
			String hql = 	"SELECT MAX(id.dbCommentId) + 1 " +
							"FROM 	DbCommentContact " +
							"WHERE	id.dbSiteCode = ?" +
							"  AND	id.dbModuleCode = ?" +
							"  AND	id.dbRecordId = ?" +
							"  AND	id.dbCommentId = ?";
			Query query = session.createQuery(hql);
			int paraCount = 0;
			query.setString(paraCount++, id.getDbSiteCode());
			query.setString(paraCount++, id.getDbModuleCode());
			query.setBigDecimal(paraCount++, id.getDbRecordId());
			query.setBigDecimal(paraCount++, id.getDbCommentId());
			BigDecimal nextId = (BigDecimal) query.uniqueResult();
			if (nextId != null) {
				dbCommentContactId = String.valueOf(nextId);
			}
		} catch (HibernateException hex) {
			throw hex;
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			// cannot close session, otherwise parent object cannot be saved
		}
		return dbCommentContactId;
	}

	public static List<DbComment> getDbCommentListByModuleCodeRecordId(
			String dbSiteCode, String dbModuleCode, BigDecimal dbRecordId) {
		return getDbCommentListByModuleCodeRecordId(dbSiteCode, dbModuleCode, dbRecordId, null);
	}
	
	public static List<DbComment> getDbCommentListByModuleCodeRecordId(
			String dbSiteCode, String dbModuleCode, BigDecimal dbRecordId, Integer numOfTopic) {
		Session session = HibernateUtil.getCurrentSession();
		List<DbComment> dbCommentlist = null;
		
		try {
			Criteria criteria = session.createCriteria(DbComment.class);
			criteria.add(Restrictions.eq("id.dbSiteCode", dbSiteCode))
					.add(Restrictions.eq("id.dbModuleCode", dbModuleCode))
					.add(Restrictions.eq("id.dbRecordId", dbRecordId))
					.add(Restrictions.eq("id.dbCommentSeq", new BigDecimal(1)))
					.add(Restrictions.eq("dbEnabled", 1))
					.addOrder(Order.desc("id.dbCommentId"));
			if (numOfTopic != null) {
				criteria.setMaxResults(numOfTopic);
			}
			dbCommentlist = criteria.list();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		
		return dbCommentlist;
	}
	
	public static Integer getTotalNumOfDbCommentListByModuleCodeRecordId(
			String dbSiteCode, String dbModuleCode, BigDecimal dbRecordId) {
		Session session = HibernateUtil.getCurrentSession();
		Integer totalNumOfRow = null;
		ScrollableResults scr = null;
		
		try {
			Criteria criteria = session.createCriteria(DbComment.class);
			criteria.add(Restrictions.eq("id.dbSiteCode", dbSiteCode))
					.add(Restrictions.eq("id.dbModuleCode", dbModuleCode))
					.add(Restrictions.eq("id.dbRecordId", dbRecordId))
					.add(Restrictions.eq("id.dbCommentSeq", new BigDecimal(1)))
					.add(Restrictions.eq("dbEnabled", 1))
					.addOrder(Order.desc("id.dbCommentId"));
			scr = criteria.scroll();
			if (scr != null) {
				scr.last();
				totalNumOfRow = scr.getRowNumber(); 
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		
		return totalNumOfRow;
	}
	
	public static DbComment getDbComment(DbCommentId id) {
		Session session = HibernateUtil.getCurrentSession();
		DbComment dbComment = null;
		
		try {
			Criteria criteria = session.createCriteria(DbComment.class);
			criteria.add(Restrictions.eq("id", id))
					.createAlias("dbCommentHistories", "histories", CriteriaSpecification.LEFT_JOIN)
					.createAlias("dbCommentDocuments", "documents", CriteriaSpecification.LEFT_JOIN)
					.addOrder(Order.desc("histories.id.dbCommentHistoryId"));
			dbComment = (DbComment) criteria.uniqueResult();
			
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		
		return dbComment;
	}
	
	public static List<DbComment> getDbCommentWithAllReplies(DbCommentId id) {
		Session session = HibernateUtil.getCurrentSession();
		List<DbComment> dbComments = null;
		
		try {
			Criteria criteria = session.createCriteria(DbComment.class);
			criteria.add(Restrictions.eq("id.dbSiteCode", id.getDbSiteCode()))
					.add(Restrictions.eq("id.dbModuleCode", id.getDbModuleCode()))
					.add(Restrictions.eq("id.dbRecordId", id.getDbRecordId()))
					.add(Restrictions.eq("id.dbCommentId", id.getDbCommentId()))
					.add(Restrictions.eq("dbEnabled", 1))
					.addOrder(Order.desc("id.dbCommentSeq"));
			dbComments = criteria.list();
			
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		
		return dbComments;
	}
	
	
	
	public static boolean replyComment(UserBean userBean, DbCommentId id, String newComment, 
			String sendEmail) {
		if (id == null) {
			return false;
		}
		
		Transaction transaction = null;
		boolean success = false;
		Session session = HibernateUtil.getCurrentSession();
		DbComment dbComment = null;
		
		try {
			transaction = session.beginTransaction();
			
			Date now = new Date();
			dbComment = new DbComment();
			dbComment.setId(id);
			dbComment.setDbCommentDesc(newComment);
			dbComment.setDbCreatedDate(now);
			dbComment.setDbCreatedUser(userBean.getLoginID());
			dbComment.setDbModifiedDate(now);
			dbComment.setDbModifiedUser(userBean.getLoginID());
			dbComment.setDbEnabled(1);
			
			session.save(dbComment);
			
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
	
	public static DbCommentHistory createDbCommentHistory(UserBean userBean, DbComment dbComment,
			String newComment, String sendEmail) {
		if (dbComment == null) {
			return null;
		}
		
		DbCommentHistory history = new DbCommentHistory();
		DbCommentId commentId = dbComment.getId();
		if (commentId != null) {
			history.setId(new DbCommentHistoryId(commentId.getDbSiteCode(),
					commentId.getDbModuleCode(), commentId.getDbCommentId(), commentId.getDbRecordId(),
					commentId.getDbCommentSeq(), null  
					));
		} else {
			history.setId(new DbCommentHistoryId());
		}
		
		history.setDbCommentTypes(dbComment.getDbCommentTypes());
		history.setDbCommentTypes2(dbComment.getDbCommentTypes().getId().getDbCommentTypeCode());	// used for insert
		history.setDbTopicDesc(dbComment.getDbTopicDesc());
		history.setDbCommentDesc(newComment);
		history.setDbInvolveDepartmentCode(dbComment.getDbInvolveDepartmentCode());
		history.setDbInvolveUserId(dbComment.getDbInvolveUserId());
		history.setDbEmailNotify(sendEmail);
		history.setDbCreatedDate(new Date());
		history.setDbCreatedUser(userBean.getLoginID());
		history.setDbModifiedDate(new Date());
		history.setDbModifiedUser(userBean.getLoginID());
		history.setDbEnabled(dbComment.getDbEnabled());
		
		return history;
	}
	
	public static boolean updateDbCommentHistory(DbCommentHistoryId id, UserBean userBean, 
			String dbCommentDesc) {
		Session session = null;
		Transaction transaction = null;
		DbCommentHistory history = null;
		boolean success = false;
		
		try {
			history = DbCommentDB.get(id);
			
			
			session = HibernateUtil.getCurrentSession();
			if (history != null) {
				transaction = session.beginTransaction();
			
			
				history.setDbCommentDesc(dbCommentDesc);
				history.setDbModifiedDate(new Date());
				history.setDbModifiedUser(userBean.getLoginID());
			}
			
			session.update(history);
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

	/*
	public static DbCommentHistory copyDbComment2DbCommentHistory(DbComment dbComment) {
		if (dbComment == null) {
			return null;
		}
		
		DbCommentHistory history = new DbCommentHistory();
		DbCommentId commentId = dbComment.getId();
		if (commentId != null) {
			history.setId(new DbCommentHistoryId(commentId.getDbSiteCode(),
					commentId.getDbModuleCode(), commentId.getDbCommentId(), null, 
					commentId.getDbRecordId()));
		} else {
			history.setId(new DbCommentHistoryId());
		}
		
		history.setDbCommentTypes(dbComment.getDbCommentTypes());
		history.setDbCommentTypes2(dbComment.getDbCommentTypes().getId().getDbCommentTypeCode());	// used for insert
		history.setDbTopicDesc(dbComment.getDbTopicDesc());
		history.setDbCommentDesc(dbComment.getDbCommentDesc());
		history.setDbInvolveDepartmentCode(dbComment.getDbInvolveDepartmentCode());
		history.setDbInvolveUserId(dbComment.getDbInvolveUserId());
		history.setDbEmailNotify(dbComment.getDbEmailNotify());
		history.setDbCreatedDate(dbComment.getDbCreatedDate());
		history.setDbCreatedUser(dbComment.getDbCreatedUser());
		history.setDbModifiedDate(dbComment.getDbModifiedDate());
		history.setDbModifiedUser(dbComment.getDbModifiedUser());
		history.setDbEnabled(dbComment.getDbEnabled());
		
		
		history.setDbCommentContactHistories(
				copyDbCommentContactSet2DbCommentContactHistorySet(dbComment.getDbCommentContacts()));
		
		return history;
	}
	
	public static Set<DbCommentContactHistory> copyDbCommentContactSet2DbCommentContactHistorySet(
			Set<DbCommentContact> contacts) {
		if (contacts == null) {
			return null;
		}
		
		HashSet<DbCommentContactHistory> set = new HashSet<DbCommentContactHistory>();
		for (DbCommentContact contact : contacts) {
			set.add(copyDbCommentContact2DbCommentContactHistory(contact));
		}
		
		return set;
	}
	
	public static DbCommentContactHistory copyDbCommentContact2DbCommentContactHistory(
			DbCommentContact dbCommentContact) {
		if (dbCommentContact == null) {
			return null;
		}
		
		DbCommentContactHistory contactHistory = new DbCommentContactHistory();
		DbCommentContactId commentContactId = dbCommentContact.getId();
		if (commentContactId != null) {
			contactHistory.setId(new DbCommentContactHistoryId(commentContactId.getDbSiteCode(),
					commentContactId.getDbModuleCode(), commentContactId.getDbCommentId(), 
					commentContactId.getDbCommentContactId(), null,  
					commentContactId.getDbRecordId()));
		} else {
			contactHistory.setId(new DbCommentContactHistoryId());
		}
		
		contactHistory.setDbContactType(dbCommentContact.getDbContactType());
		contactHistory.setDbContactUserType(dbCommentContact.getDbContactUserType());
		contactHistory.setDbContactUserId(dbCommentContact.getDbContactUserId());
		contactHistory.setDbContactEmail(dbCommentContact.getDbContactEmail());
		contactHistory.setDbCreatedDate(dbCommentContact.getDbCreatedDate());
		contactHistory.setDbCreatedUser(dbCommentContact.getDbCreatedUser());
		contactHistory.setDbModifiedDate(dbCommentContact.getDbModifiedDate());
		contactHistory.setDbModifiedUser(dbCommentContact.getDbModifiedUser());
		contactHistory.setDbEnabled(dbCommentContact.getDbEnabled());
		
		return contactHistory;
	}
	
	*/
	
	public static boolean addComment(String siteCode, String moduleCode, String recordId, 
			String topicDesc, String commentDesc, UserBean userBean) {
		Date now = new Date();
		
		DbComment dbComment = new DbComment();
		DbCommentId id = new DbCommentId();
		id.setDbModuleCode(moduleCode);
		id.setDbRecordId(new BigDecimal(recordId));
		id.setDbSiteCode(siteCode);
		dbComment.setId(id);
		
		dbComment.setDbTopicDesc(topicDesc);
		dbComment.setDbCommentDesc(commentDesc);
		dbComment.setDbCreatedDate(now);
		dbComment.setDbCreatedUser(userBean.getLoginID());
		dbComment.setDbModifiedDate(now);
		dbComment.setDbModifiedUser(userBean.getLoginID());
		dbComment.setDbEnabled(1);
		
		return add(dbComment);
	}
	
	public static boolean add(DbComment dbComment) {
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		boolean success = false;
		
		try {
			transaction = session.beginTransaction();
			
			session.save(dbComment);
			
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
	
	public static boolean add(DbCommentContact dbCommentContact) {
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		boolean success = false;
		
		try {
			transaction = session.beginTransaction();
			session.save(dbCommentContact);
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
	
	private static HashMap<String, String> getEmailList(String staffID) {
		HashMap<String, String> emailMap = new HashMap<String, String>();
		if (staffID != null && staffID.length() > 0) {
			String tempEmail = UserDB.getUserEmail(null, staffID);
			if (tempEmail != null && tempEmail.length() > 0) {
				emailMap.put(tempEmail, staffID);
			}
		}
		return emailMap;
	}
}