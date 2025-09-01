package com.hkah.web.db;

import java.util.Date;
import java.util.Iterator;
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
import com.hkah.web.db.hibernate.HaaChecklist;
import com.hkah.web.db.hibernate.HaaChecklistDate;
import com.hkah.web.db.hibernate.HaaChecklistDateId;
import com.hkah.web.db.hibernate.HaaChecklistId;
import com.hkah.web.db.hibernate.HaaChecklistProgress;


public class HAACheckListDB2 {
	
	protected static final Log logger = LogFactory.getLog(HAACheckListDB2.class);

	// constant
	public static String SITE_CODE = ConstantsServerSide.SITE_CODE;
	
	public static HaaChecklist get(HaaChecklistId id) {
		Session session = HibernateUtil.getCurrentSession();
		
		HaaChecklist haaChecklist = null;
		
		try {
			Criteria criteria = session.createCriteria(HaaChecklist.class);
			criteria.add(Restrictions.idEq(id));
			criteria.add(Restrictions.gt("haaEnabled", 0));
			criteria.addOrder(Order.asc("haaCorpName"));
			haaChecklist = (HaaChecklist) criteria.uniqueResult();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		
		}
		return haaChecklist;
	}
	
	public static String getNextHaaID() {
		Session session = HibernateUtil.getCurrentSession();
		String haaID = "1";

		try {
			String hql = 	"SELECT MAX(id.haaChecklistId) + 1 " +
							"FROM HaaChecklist";
			Query query = session.createQuery(hql);
			Integer nextId = (Integer) query.uniqueResult();
			if (nextId != null) {
				haaID = String.valueOf(nextId);
			}
			
		} catch (HibernateException hex) {
			throw hex;
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			// cannot close session, otherwise parent object cannot be saved
		}
		return haaID;
	}
	
	public static int getNextHaaID2() {
		Session session = HibernateUtil.getCurrentSession();
		Integer nextId = 1;

		try {
			String hql = 	"SELECT MAX(id.haaChecklistId) + 1 " +
							"FROM HaaChecklist";
			Query query = session.createQuery(hql);
			nextId = (Integer) query.uniqueResult();
		} catch (HibernateException hex) {
			throw hex;
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		return nextId;
	}
	
	/**
	 * Setup HAACheckList and save to db
	 * @return HAACheckList if successful
	 */
	public static HaaChecklist add(UserBean userBean) {
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		HaaChecklist haaChecklist = null;

		try {
			transaction = session.beginTransaction();
		
			// HAA_CHECKLIST
			haaChecklist = new HaaChecklist();
			
			HaaChecklistId haaChecklistId = new HaaChecklistId();
			haaChecklistId.setHaaSiteCode(SITE_CODE);
			haaChecklist.setId(haaChecklistId);
			
			haaChecklist.setHaaCreatedUser(userBean.getLoginID());
			haaChecklist.setHaaCreatedDate(new Date());
			haaChecklist.setHaaModifiedUser(userBean.getLoginID());
			haaChecklist.setHaaModifiedDate(new Date());
			haaChecklist.setHaaEnabled(1);
			
			session.save(haaChecklist);
			
			// HAA_CHECKLIST_DATE
			// insert haaChecklistDate
			List<HaaChecklistProgress> progress = session.createCriteria(HaaChecklistProgress.class).list();
			if (progress.size() > 0) {
				HaaChecklistProgress row = null;
				for (int i = 0; i < progress.size(); i++) {
					row = (HaaChecklistProgress) progress.get(i);
					HaaChecklistDate date = newDate(userBean, row, haaChecklist, SITE_CODE);
					session.save(date);
				}
			}
			
			transaction.commit();
			
		} catch (HibernateException hex) {
			if (transaction != null) 
				transaction.rollback();
			throw hex;
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		return haaChecklist;
	}
	
	public static boolean update(UserBean userBean, int haaID, String haaCorpName, 
			String busType, Date contactDateFrom, Date contactDateTo, String enabled) {
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		boolean result = false;
		
		try {
			transaction = session.beginTransaction();
			// Get the unique HaaChecklist
			Criteria criteria = session.createCriteria(HaaChecklist.class);
			
			HaaChecklistId id = new HaaChecklistId();
			id.setHaaChecklistId(haaID);
			id.setHaaSiteCode(SITE_CODE);
			criteria.add(Restrictions.idEq(id));
			criteria.add(Restrictions.gt("haaEnabled", 0));
	
			HaaChecklist haaChecklist = (HaaChecklist) criteria.uniqueResult();
			
			// Update
			if (haaChecklist != null) {
				haaChecklist.setHaaContractDateFrom(contactDateFrom);
				haaChecklist.setHaaContractDateTo(contactDateTo);
				haaChecklist.setHaaCorpName(haaCorpName);
				haaChecklist.setHaaBusinessType(busType);
				haaChecklist.setHaaEnabled(Integer.parseInt(enabled));
				haaChecklist.setHaaModifiedDate(new Date());
				haaChecklist.setHaaModifiedUser(userBean.getLoginID());
				
				session.update(haaChecklist);
				transaction.commit();
				result = transaction.wasCommitted();
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
		return result;
	}
	
	public static List<HaaChecklistDate> getDateProgress(UserBean userBean, HaaChecklistId id) {
		Session session = HibernateUtil.getCurrentSession();
		List<HaaChecklistDate> dateList = null;
		HaaChecklistProgress progress = null;
		List<HaaChecklistProgress> progressList = null;
		
		try {
			// Method 1
			Criteria criteria = session.createCriteria(HaaChecklistDate.class);
			criteria.add(Restrictions.eq("haaSiteCode", SITE_CODE))
					.add(Restrictions.eq("id.haaChecklistId", id.getHaaChecklistId()))
					.add(Restrictions.eq("haaEnabled", 1))
					.addOrder(Order.asc("id.haaChecklistDid"));
			dateList = criteria.list();
			
			Criteria criteria2 = session.createCriteria(HaaChecklistProgress.class);
			criteria2.add(Restrictions.eq("haaEnabled", 1))
					.addOrder(Order.asc("haaChecklistPid"));
			progressList = criteria2.list();
			
			HaaChecklistDate date = null;
			for (Iterator<HaaChecklistDate> i = dateList.iterator(); i.hasNext();) {
				date = i.next();
				
				if (date != null) {
					boolean set = false;
					for (Iterator<HaaChecklistProgress> i2 = progressList.iterator(); i2.hasNext() && !set;) {
						progress = i2.next();
						if (date.getId().getHaaChecklistDid() == progress.getHaaChecklistPid()) {
							date.setHaaChecklistProgress(progress);
							set = true;
						}
					}
				}
			}
			
		} catch (HibernateException hex) {
			throw hex;
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		return dateList;
	}
	
	/**
	 * 
	 * @return List of HaaChecklistProgress
	 */
	public static List<HaaChecklistProgress> getHaaChecklistProgressList() {
		Session session = HibernateUtil.getCurrentSession();
		List<HaaChecklistProgress> list = null;
		
		try {
			list = session.createCriteria(HaaChecklistProgress.class).list();
			
		} catch (HibernateException hex) {
			throw hex;
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		
		return list;
	}
	
	/**
	 * Setup new HaaChecklistDate 
	 */
	public static HaaChecklistDate newDate(
		UserBean userBean, HaaChecklistProgress haaChecklistProgress, HaaChecklist haaChecklist, String siteCode) {
		if (haaChecklist == null || haaChecklist.getId() == null) {
			return null;
		}
		
		HaaChecklistDate date = new HaaChecklistDate();
		
		HaaChecklistDateId id = new HaaChecklistDateId();
		id.setHaaChecklistId(haaChecklist.getId().getHaaChecklistId());
		id.setHaaChecklistDid(haaChecklistProgress.getHaaChecklistPid());
		date.setId(id);
		date.setHaaSiteCode(siteCode);
		if (userBean != null) {
			date.setHaaCreatedUser(userBean.getLoginID());
			date.setHaaModifiedUser(userBean.getLoginID());
		}
		date.setHaaCreatedUser(userBean.getLoginID());
		date.setHaaCreatedDate(new Date());
		date.setHaaModifiedUser(userBean.getLoginID());
		date.setHaaModifiedDate(new Date());
		date.setHaaEnabled(1);
		
		return date;
	}
	
	/**
	 * 
	 * @param userBean
	 * @param enabled
	 * @return List of HaaChecklist
	 */
	public static List<HaaChecklist> getList(UserBean userBean, String enabled) {
		Session session = HibernateUtil.getCurrentSession();
		List<HaaChecklist> list = null;
		
		try {
			Criteria criteria = session.createCriteria(HaaChecklist.class);
			criteria.add(Restrictions.eq("id.haaSiteCode", SITE_CODE));
			if (enabled != null && enabled.length() > 0) {
				criteria.add(Restrictions.eq("haaEnabled", Integer.parseInt(enabled)));
			} else {
				criteria.add(Restrictions.gt("haaEnabled", 0));
			}
			criteria.addOrder(Order.asc("haaCorpName"));
	
			list = criteria.list();
			
			
		} catch (HibernateException hex) {
			throw hex;
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		return list;
	}
	
	public static boolean expiredContract(UserBean userBean) {
		return expiredContract(userBean, null);
	}
	
	public static boolean expiredContract(UserBean userBean, HaaChecklistId haaChecklistId) {
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		int rowCount = 0;
		
		try {
			transaction = session.beginTransaction();
		
			// batch update
			Query query = session.createQuery(
					"update HaaChecklist" +
					" set haaEnabled = ?" +
					" where haaEnabled = ?" +
					" and haaContractDateTo is not null" +
					" and haaContractDateTo < ?" +
					(haaChecklistId != null ? " and id.haaSiteCode = ?" : "") +
					(haaChecklistId != null ? " and id.haaChecklistId = ?" : ""));
			
			int paraCount = 0;
			query.setInteger(paraCount++, 2);
			query.setInteger(paraCount++, 1);
			query.setDate(paraCount++, new Date());
			if (haaChecklistId != null) {
				query.setString(paraCount++, haaChecklistId.getHaaSiteCode());
				query.setInteger(paraCount++, haaChecklistId.getHaaChecklistId());
			}
			
			rowCount = query.executeUpdate();
			transaction.commit();
			
		} catch (HibernateException hex) {
			if (transaction != null) 
				transaction.rollback();
			throw hex;
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		
		if (rowCount > 0) {
			return true;
		} else {
			return false;
		}
	}
	
	/**
	 * Disable healthAssessment
	 * @return true if everything was successful
	 */
	public static boolean delete(UserBean userBean, HaaChecklist haaChecklist) {
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		boolean ret = false;
		
		try {
			transaction = session.beginTransaction();
			
			if (haaChecklist != null && haaChecklist.getHaaEnabled() > 0) {
				haaChecklist.setHaaEnabled(0);
				haaChecklist.setHaaModifiedDate(new Date());
				haaChecklist.setHaaModifiedUser(userBean.getLoginID());
				
				session.update(haaChecklist);
				transaction.commit();
				ret = transaction.wasCommitted();
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
		
		return ret;
	}
	
	/**
	 * Archive healthAssessment
	 * @return true if everything was successful
	 */
	public static boolean archive(UserBean userBean, HaaChecklist haaChecklist) {
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		boolean ret = false;
		
		try {
			transaction = session.beginTransaction();
			
			if (haaChecklist != null && haaChecklist.getHaaEnabled() > 0) {
				haaChecklist.setHaaEnabled(2);
				haaChecklist.setHaaModifiedDate(new Date());
				haaChecklist.setHaaModifiedUser(userBean.getLoginID());
				
				session.update(haaChecklist);
				transaction.commit();
				ret = transaction.wasCommitted();
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
		
		return ret;
	}
	
	/**
	 * Update check list date (OO approach)
	 * 
	 * @param userBean
	 * @param haaChecklistDate
	 * @return true if update success
	 */
	public static boolean updateDate(UserBean userBean, HaaChecklistDate haaChecklistDate) {
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		boolean ret = false;
		
		try {
			transaction = session.beginTransaction();
			
			//-------------
			// single update (OO approach)
			//-------------
			haaChecklistDate.setHaaModifiedDate(new Date());
			haaChecklistDate.setHaaModifiedUser(userBean.getLoginID());
			session.update(haaChecklistDate);
		
			transaction.commit();
			ret = transaction.wasCommitted();
			
		} catch (HibernateException hex) {
			if (transaction != null) 
				transaction.rollback();
			throw hex;
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		
		return ret;
	}	
	
	/**
	 * Update check list date (Non-OO approach)
	 * 
	 * @param userBean
	 * @param siteCode
	 * @param haaID
	 * @param haaDID
	 * @param initDate
	 * @param compDate
	 * @return true if update success
	 */
	public static boolean updateDate(UserBean userBean, String siteCode, int haaID, int haaDID, Date initDate, Date compDate) {
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		int rowCount = 0;
		
		try {
			transaction = session.beginTransaction();
			String hql = 	"UPDATE HaaChecklistDate " +
							"SET 	haaInitDate = ? " +
							"	 	, haaCmpltDate = ? " +
							"	 	, haaModifiedDate = ? " +
							"	 	, haaModifiedUser = ? " +
							"WHERE 	haaSiteCode = ? " +
							"AND 	id.haaChecklistId = ? " + 
							"AND 	id.haaChecklistDid = ? ";
			Query query = session.createQuery(hql);
			
			int paraCount = 0;
			query.setDate(paraCount++, initDate);
			query.setDate(paraCount++, compDate);
			query.setDate(paraCount++, new Date());
			query.setString(paraCount++, userBean.getLoginID());
			query.setString(paraCount++ , siteCode);
			query.setInteger(paraCount++ , haaID);
			query.setInteger(paraCount++ , haaDID);
			
			rowCount = query.executeUpdate();
			transaction.commit();
			
		} catch (HibernateException hex) {
			if (transaction != null) 
				transaction.rollback();
			throw hex;
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		
		if (rowCount > 0) {
			return true;
		} else {
			return false;
		}
	}	
	
}