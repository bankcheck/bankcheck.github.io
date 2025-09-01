/*
 * Created on Nov 24, 2009
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.web.db;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

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
import com.hkah.web.controller.CRMController;
import com.hkah.web.db.hibernate.CoEvent;
import com.hkah.web.db.hibernate.CoEventId;
import com.hkah.web.db.hibernate.CrmClients;
import com.hkah.web.db.hibernate.CrmPromotion;
import com.hkah.web.db.hibernate.CrmPromotionClient;
import com.hkah.web.db.hibernate.CrmPromotionDepartment;
import com.hkah.web.db.hibernate.CrmPromotionDocument;
import com.hkah.web.db.hibernate.CrmPromotionDocumentId;
import com.hkah.web.db.hibernate.CrmPromotionEnquiry;
import com.hkah.web.db.hibernate.CrmPromotionEnquiryId;
import com.hkah.web.db.hibernate.CrmPromotionInstruction;
import com.hkah.web.db.hibernate.CrmPromotionInstructionId;
import com.hkah.web.db.hibernate.CrmPromotionRefCode;
import com.hkah.web.db.hibernate.CrmPromotionTarget;
import com.hkah.web.db.hibernate.CrmTarget;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class CRMPromotionDB2 {
	public static final String EVENT_CATEGORY_MARKETING = "marketing";
	public static final String EVENT_TYPE_PROMOTION = "promotion";
	
	
	//------------------------
	// Get next id
	//------------------------
	public static BigDecimal getNextCoEventId(CoEventId id) {
		Session session = HibernateUtil.getCurrentSession();
		Query query = null;
		BigDecimal nextId = null;
		
		try {
			String hql = 	"SELECT MAX(id.coEventId) + 1 " +
							"FROM 	CoEvent " +
							"WHERE	id.coSiteCode = ?" +
							"AND	id.coModuleCode = ?";
			query = session.createQuery(hql);
			int paraCount = 0;
			query.setString(paraCount++, id.getCoSiteCode());
			query.setString(paraCount++, id.getCoModuleCode());
			nextId = (BigDecimal) query.uniqueResult();
			if (nextId == null) {
				nextId = new BigDecimal("1");
			}
		} catch (HibernateException hex) {
			throw hex;
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			// cannot close session, otherwise call method cannot save the object
		}
		return nextId;
	}
	
	public static BigDecimal getNextCrmPromoInstrPid(CrmPromotionInstructionId id) {
		Session session = HibernateUtil.getCurrentSession();
		Query query = null;
		BigDecimal nextId = null;
		
		try {
			String hql = 	"SELECT MAX(id.crmPromoInstrPid) + 1 " +
							"FROM 	CrmPromotionInstruction " +
							"WHERE	id.crmSiteCode = ?" +
							"AND	id.crmModuleCode = ?" +
							"AND	id.crmEventId = ?";
			query = session.createQuery(hql);
			int paraCount = 0;
			query.setString(paraCount++, id.getCrmSiteCode());
			query.setString(paraCount++, id.getCrmModuleCode());
			query.setBigDecimal(paraCount++, id.getCrmEventId());
			nextId = (BigDecimal) query.uniqueResult();
			if (nextId == null) {
				nextId = new BigDecimal("1");
			}
		} catch (HibernateException hex) {
			throw hex;
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			// cannot close session, otherwise call method cannot save the object
		}
		return nextId;
	}
	
	public static BigDecimal getNextCrmTargetId() {
		Session session = HibernateUtil.getCurrentSession();
		Query query = null;
		BigDecimal nextId = null;
		
		try {
			String hql = 	"SELECT MAX(id.crmTargetId) + 1 " +
							"FROM 	CrmTarget";
			query = session.createQuery(hql);
			nextId = (BigDecimal) query.uniqueResult();
			if (nextId == null) {
				nextId = new BigDecimal("1");
			}
		} catch (HibernateException hex) {
			throw hex;
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			// cannot close session, otherwise call method cannot save the object
		}
		return nextId;
	}
	
	public static BigDecimal getNexCrmPromoEnqPid(CrmPromotionEnquiryId id) {
		Session session = HibernateUtil.getCurrentSession();
		Query query = null;
		BigDecimal nextId = null;
		
		try {
			String hql = 	"SELECT MAX(id.crmPromoEnqPid) + 1 " +
							"FROM 	CrmPromotionEnquiry " +
							"WHERE	id.crmSiteCode = ?" +
							"AND	id.crmModuleCode = ?" +
							"AND	id.crmEventId = ?";
			query = session.createQuery(hql);
			int paraCount = 0;
			query.setString(paraCount++, id.getCrmSiteCode());
			query.setString(paraCount++, id.getCrmModuleCode());
			query.setBigDecimal(paraCount++, id.getCrmEventId());
			nextId = (BigDecimal) query.uniqueResult();
			if (nextId == null) {
				nextId = new BigDecimal("1");
			}
		} catch (HibernateException hex) {
			throw hex;
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			// cannot close session, otherwise call method cannot save the object
		}
		return nextId;
	}
	
	
	//------------------------
	// Get persistence objects
	//------------------------
	public static CrmTarget getCrmTarget(BigDecimal crmTargetId_BD) {
		Session session = HibernateUtil.getCurrentSession();
		
		CrmTarget crmTarget = null;
		try {
			Criteria criteria = session.createCriteria(CrmTarget.class);
			
			criteria = criteria.add(Restrictions.eq("crmTargetId", crmTargetId_BD))
								.add(Restrictions.eq("crmEnabled", 1));
			
			crmTarget = (CrmTarget) criteria.uniqueResult();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		return crmTarget;
	}
	
	// Get single model
	//-----------------
	public static CoEvent getCoEventWithCrmPromotion(CoEventId coEventId) {
		Session session = HibernateUtil.getCurrentSession();
		
		CoEvent coEvent = null;
		try {
			Criteria criteria = session.createCriteria(CoEvent.class)
										.setFetchMode("crmPromotions", FetchMode.JOIN);
			
			criteria = criteria.add(Restrictions.idEq(coEventId))
								.add(Restrictions.eq("coEventCategory", EVENT_CATEGORY_MARKETING))
								.add(Restrictions.eq("coEventType", EVENT_TYPE_PROMOTION))
								.add(Restrictions.eq("coEnabled", 1));
			
			coEvent = (CoEvent) criteria.uniqueResult();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		return coEvent;
	}
	
	public static List<CoEvent> getCoEventWithCrmPromotionList() {
		return getCoEventWithCrmPromotionList(null);
	}
	
	public static List<CoEvent> getCoEventWithCrmPromotionList(String promotionStatus) {
		Session session = HibernateUtil.getCurrentSession();
		
		List<CoEvent> coEvents = new ArrayList<CoEvent>();
		try {
			Criteria criteria = session.createCriteria(CoEvent.class)
										.setFetchMode("crmPromotions", FetchMode.JOIN);
			Criteria subCriteria = criteria.createCriteria("crmPromotions");
			
			criteria = criteria.add(Restrictions.eq("coEventCategory", EVENT_CATEGORY_MARKETING))
								.add(Restrictions.eq("coEventType", EVENT_TYPE_PROMOTION))
								.add(Restrictions.eq("coEnabled", 1));
			if (promotionStatus != null) {
				Date now = new Date();
				if (CRMController.PROMOTION_STATUS_CODE_CURRENT.equals(promotionStatus)) {
					subCriteria = subCriteria.add(Restrictions.le("crmInitialDateFm", now))
										.add(Restrictions.ge("crmInitialDateTo", now));
				} else if (CRMController.PROMOTION_STATUS_CODE_COMING.equals(promotionStatus)) {
					subCriteria = subCriteria.add(Restrictions.gt("crmInitialDateFm", now));
				} else if (CRMController.PROMOTION_STATUS_CODE_EXPIRED.equals(promotionStatus)) {
					subCriteria = subCriteria.add(Restrictions.lt("crmInitialDateTo", now));
				}
			}
			criteria = criteria.addOrder(Order.asc("id.coEventId"));
			
			coEvents = criteria.list();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		return coEvents;
	}
	
	public static List<CrmTarget> getCrmTargetList() {
		Session session = HibernateUtil.getCurrentSession();
		
		List<CrmTarget> crmTarget = new ArrayList<CrmTarget>();
		try {
			Criteria criteria = session.createCriteria(CrmTarget.class);
			
			criteria = criteria.add(Restrictions.eq("crmEnabled", 1));
			criteria = criteria.addOrder(Order.asc("crmTargetCode"));
			criteria = criteria.addOrder(Order.asc("crmTargetName"));
			
			crmTarget = criteria.list();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		return crmTarget;
	}
	
	public static List<CrmPromotionRefCode> getCrmPromotionRefCodeList() {
		Session session = HibernateUtil.getCurrentSession();
		
		List<CrmPromotionRefCode> crmPromotionRefCode = new ArrayList<CrmPromotionRefCode>();
		try {
			Criteria criteria = session.createCriteria(CrmPromotionRefCode.class);
			
			criteria = criteria.add(Restrictions.eq("crmEnabled", 1));
			criteria = criteria.addOrder(Order.asc("crmRefTypeCode"));
			
			crmPromotionRefCode = criteria.list();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		return crmPromotionRefCode;
	}
	
	//cherry edit 20100709//	
	public static List<CrmClients> getCrmClientList(String ClientStart, String Search){
		Integer ClientEnd = new Integer(ClientStart) ;
		ClientEnd = ClientEnd + 25;
		Session session = HibernateUtil.getCurrentSession();
		List<CrmClients> crmClients = new ArrayList<CrmClients>();
		try{
			
			Criteria criteria = session.createCriteria(CrmClients.class);
			criteria = criteria.add(Restrictions.eq("crmEnabled",1));
			if(Search ==null)
			{
			criteria = criteria.add(Restrictions.between("crmClientId", new BigDecimal(ClientStart), new BigDecimal(ClientEnd)));
			}
			if(Search != null){
				String[]searcharray = Search.split(" ");
				System.out.println(searcharray.length);
				if(searcharray.length > 1){
					criteria = criteria.add(
							Restrictions.and(
							Restrictions.like("crmLastname", "%"+searcharray[0]	.toUpperCase()+"%"),
							Restrictions.like("crmFirstname", "%"+searcharray[1].toUpperCase()+"%")
							));				 	 
				}
				if(searcharray.length == 1){
					criteria = criteria.add(
							Restrictions.or(
							Restrictions.or(Restrictions.like("crmLastname", "%"+Search.toUpperCase()+"%"), 
									Restrictions.like("crmChinesename", "%"+Search.toUpperCase()+"%")),
							Restrictions.like("crmFirstname", "%"+Search.toUpperCase()+"%")));
				}

				
			}
			criteria = criteria.addOrder(Order.asc("crmClientId"));
			
			crmClients = criteria.list();
			
		}catch(Exception ex){
			ex.printStackTrace();		
		}finally{
			HibernateUtil.closeSession();
		}
		return crmClients;
	}
	//cherry edit 20100709//
	
	//------------------------
	// Write persistence objects
	//------------------------
	public static boolean add(CoEvent coEvent) {
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		boolean success = false;
		
		try {
			transaction = session.beginTransaction();
			session.save(coEvent);
			coEvent.getCrmPromotion().getId().setCrmEventId(coEvent.getId().getCoEventId());
			CrmPromotion crmPromotion = coEvent.getCrmPromotion();
			session.save(crmPromotion);
			
			if (crmPromotion != null) {
				if (crmPromotion.getCrmPromotionDepartments() != null) {
					for (Iterator<CrmPromotionDepartment> itr = crmPromotion.getCrmPromotionDepartments().iterator(); itr.hasNext(); ) {
						session.save(itr.next());
					}
				}
				if (crmPromotion.getCrmPromotionClient() != null) {
					for (Iterator<CrmPromotionClient> itr = crmPromotion.getCrmPromotionClient().iterator(); itr.hasNext(); ) {
						session.save(itr.next());
					}
				}
				if (crmPromotion.getCrmPromotionTargets() != null) {
					for (Iterator<CrmPromotionTarget> itr = crmPromotion.getCrmPromotionTargets().iterator(); itr.hasNext(); ) {
						session.save(itr.next());
					}
				}
				if (crmPromotion.getCrmPromotionEnquiries() != null) {
					for (Iterator<CrmPromotionEnquiry> itr = crmPromotion.getCrmPromotionEnquiries().iterator(); itr.hasNext(); ) {
						session.save(itr.next());
					}
				}
				if (crmPromotion.getCrmPromotionInstructions() != null) {
					for (Iterator<CrmPromotionInstruction> itr = crmPromotion.getCrmPromotionInstructions().iterator(); itr.hasNext(); ) {
						session.save(itr.next());
					}
				}
			}
			
			transaction.commit();
			success = transaction.wasCommitted();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		return success;
	}
	
	public static boolean update(CoEvent coEvent) {
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		boolean success = false;
		
		try {
			transaction = session.beginTransaction();
			session.update(coEvent);
			session.update(coEvent.getCrmPromotion());
			
			// update associations
			CrmPromotion crmPromotion = coEvent.getCrmPromotion();
			if (crmPromotion != null) {
				// CrmPromotionDepartment
				for (CrmPromotionDepartment department : crmPromotion.getCrmPromotionDepartments()) {
					session.saveOrUpdate(department);
				}
				// CrmPromotionTarget
				for (CrmPromotionTarget target : crmPromotion.getCrmPromotionTargets()) {
					session.saveOrUpdate(target);
				}
				// CrmPromotionClient
				for (CrmPromotionClient client : crmPromotion.getCrmPromotionClient()) {
					session.saveOrUpdate(client);
				}
				// CrmPromotionInstruction
				for (CrmPromotionInstruction instructions : crmPromotion.getCrmPromotionInstructions()) {
					session.saveOrUpdate(instructions);
				}
				// CrmPromotionEnquiry
				for (CrmPromotionEnquiry enquiry : crmPromotion.getCrmPromotionEnquiries()) {
					session.saveOrUpdate(enquiry);
				}
			}
			
			transaction.commit();
			success = transaction.wasCommitted();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		return success;
	}
	
	// add/update document record
	public static boolean addCrmPromotionDocument(
			CoEventId coEventId, BigDecimal coDocumentId, String crmDocumentType, UserBean userBean) {
		if (coEventId == null) {
			return false;
		}
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		CrmPromotionDocument crmPromotionDocument = null;
		boolean success = false;
		
		try {
			transaction = session.beginTransaction();
			Criteria criteria = session.createCriteria(CrmPromotionDocument.class);
			
			// criteria
			criteria = criteria.add(Restrictions.eq("id.crmSiteCode", coEventId.getCoSiteCode()));
			criteria = criteria.add(Restrictions.eq("id.crmModuleCode", coEventId.getCoModuleCode()));
			criteria = criteria.add(Restrictions.eq("id.crmEventId", coEventId.getCoEventId()));
			criteria = criteria.add(Restrictions.eq("id.crmDocumentId", coDocumentId));
			criteria = criteria.add(Restrictions.eq("crmEnabled", 1));
			
			crmPromotionDocument = (CrmPromotionDocument) criteria.uniqueResult();
			if (crmPromotionDocument == null) {
				// Insert
				crmPromotionDocument = new CrmPromotionDocument();
				CrmPromotionDocumentId id = new CrmPromotionDocumentId();
				id.setCrmSiteCode(coEventId.getCoSiteCode());
				id.setCrmModuleCode(coEventId.getCoModuleCode());
				id.setCrmEventId(coEventId.getCoEventId());
				id.setCrmDocumentId(coDocumentId);
				crmPromotionDocument.setId(id);
				crmPromotionDocument.setCrmDocumentType(crmDocumentType);
				
				crmPromotionDocument.setCrmCreatedDate(new Date());
				crmPromotionDocument.setCrmCreatedUser(userBean.getLoginID());
				crmPromotionDocument.setCrmModifiedDate(new Date());
				crmPromotionDocument.setCrmModifiedUser(userBean.getLoginID());
				crmPromotionDocument.setCrmEnabled(1);
				
				session.save(crmPromotionDocument);
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
	
	public static boolean delete(UserBean userBean, CoEvent coEvent) {
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		boolean success = false;
		
		try {
			transaction = session.beginTransaction();
			
			coEvent.setCoEnabled(0);
			coEvent.setCoModifiedDate(new Date());
			coEvent.setCoModifiedUser(userBean.getLoginID());
			
			session.update(coEvent);
			
			transaction.commit();
			success = transaction.wasCommitted();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		return success;
	}
	
	public static boolean deleteDocument(UserBean userBean, CrmPromotionDocumentId id) {
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		CrmPromotionDocument crmPromotionDocument = null;
		boolean success = false;
		
		try {
			transaction = session.beginTransaction();
			
			Criteria criteria = session.createCriteria(CrmPromotionDocument.class);
			criteria = criteria.add(Restrictions.idEq(id));
			criteria = criteria.add(Restrictions.eq("crmEnabled", 1));
			crmPromotionDocument = (CrmPromotionDocument) criteria.uniqueResult();
			
			if (crmPromotionDocument != null) {
				crmPromotionDocument.setCrmEnabled(0);
				crmPromotionDocument.setCrmModifiedDate(new Date());
				crmPromotionDocument.setCrmModifiedUser(userBean.getLoginID());
				session.update(crmPromotionDocument);
				
				transaction.commit();
				success = transaction.wasCommitted();
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		return success;
	}
	
	public static boolean add(CrmTarget crmTarget) {
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		boolean success = false;
		
		try {
			transaction = session.beginTransaction();
			session.save(crmTarget);
			
			transaction.commit();
			success = transaction.wasCommitted();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		return success;
	}
	
	public static boolean update(CrmTarget crmTarget) {
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		boolean success = false;
		
		try {
			transaction = session.beginTransaction();
			session.update(crmTarget);
			
			transaction.commit();
			success = transaction.wasCommitted();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		return success;
	}
	
	public static boolean delete(UserBean userBean, CrmTarget crmTarget) {
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		boolean success = false;
		
		try {
			transaction = session.beginTransaction();
			
			crmTarget.setCrmEnabled(0);
			crmTarget.setCrmModifiedDate(new Date());
			crmTarget.setCrmModifiedUser(userBean.getLoginID());
			
			session.update(crmTarget);
			
			transaction.commit();
			success = transaction.wasCommitted();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}
		return success;
	}
}