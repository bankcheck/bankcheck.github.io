package com.hkah.web.db;

import java.math.BigDecimal;
import java.util.ArrayList;
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

import com.hkah.util.db.HibernateUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;
import com.hkah.web.db.hibernate.AcDocumentAccess;
import com.hkah.web.db.hibernate.AcDocumentAccessId;
import com.hkah.web.db.hibernate.CoGroups;
import com.hkah.web.db.hibernate.CoUsers;


public class AccessControlDB2 {

	protected final Log logger = LogFactory.getLog(getClass());

	// Get single entity
	//-----------------

	// Get list
	//-----------------
	public static List<AcDocumentAccess> getAcDocumentAccessList() {
		return getAcDocumentAccessList(null, null);
	}


	public static List<AcDocumentAccess> getAcDocumentAccessList(BigDecimal acDocumentId, Integer acEnabled) {
		Session session = HibernateUtil.getCurrentSession();
		List<AcDocumentAccess> acDocumentAccessList = null;

		try {
			Criteria criteria = session.createCriteria(AcDocumentAccess.class);

			// criteria
			if (acEnabled != null) {
				criteria = criteria.add(Restrictions.eq("acEnabled", acEnabled));
			}
			criteria = criteria.addOrder(Order.asc("id.acDocumentId"));

			acDocumentAccessList = criteria.list();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}

		return acDocumentAccessList;
	}

	public static List<CoGroups> getCoGroupsList() {
		return getCoGroupsList(null);
	}

	public static List<CoGroups> getCoGroupsList(Integer coEnabled) {
		Session session = HibernateUtil.getCurrentSession();
		List<CoGroups> coGroupsList = null;

		try {
			Criteria criteria = session.createCriteria(CoGroups.class);

			// criteria
			if (coEnabled != null) {
				criteria = criteria.add(Restrictions.eq("coEnabled", coEnabled));
			}
			criteria = criteria.addOrder(Order.asc("coGroupLevel"));
			criteria = criteria.addOrder(Order.asc("coGroupId"));

			coGroupsList = criteria.list();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}

		return coGroupsList;
	}

	public static List<CoGroups> getCoDocumentSelectedCoGroupsList(BigDecimal acDocumentId, Integer coEnabled) {
		Session session = HibernateUtil.getCurrentSession();
		List<CoGroups> coGroupsList = null;

		try {
//			Criteria criteria = session.createCriteria(CoGroups.class);

			// criteria
			String sql = "SELECT {g.*} " +
	         			 "FROM   AC_DOCUMENT_ACCESS a, CO_GROUPS g " +
	         			 "WHERE  a.AC_GROUP_ID = g.CO_GROUP_ID " +
	         			 "  AND	 a.AC_DOCUMENT_ID = ? " +
	         			 "ORDER BY g.CO_GROUP_LEVEL, g.CO_GROUP_ID";
			int paraCount = 0;
			coGroupsList = session.createSQLQuery(sql)
							        .addEntity("g", CoGroups.class)
							        .setBigDecimal(paraCount++, acDocumentId)
							        .list();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			HibernateUtil.closeSession();
		}

		return coGroupsList;
	}

	public static List<CoUsers> getCoUsersList(UserBean userBean) {
	    	ArrayList record = null;
	    	String[] userIDAvailable = null;
	    	String[] userIDDescAvailable = null;
	    	String[] userID = null;
	    	String[] userIDDesc = null;
	    	List<CoUsers> userIDAvailableList = new ArrayList<CoUsers>();
	    	CoUsers coUsers = null;
	    	StringBuffer sqlStr = new StringBuffer();

		// (UserBean userBean, String siteCode, String deptCode, String staffID, String firstName, String lastName)
/*
  		sqlStr.append("SELECT S.CO_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC, ");
			sqlStr.append("       S.CO_STAFF_ID, S.CO_STAFFNAME, S.CO_STATUS, ");
			sqlStr.append("       TO_CHAR(S.CO_ANNUAL_INCR, 'MM') ");
*/
		record = StaffDB.getList(null, null, null);
		if (record.size() > 0) {
			userIDAvailable = new String[record.size()];
			userIDDescAvailable = new String[record.size()];
			ReportableListObject rlo = null;
			String staffID = null;
			String staffName = null;
			String deptDesc = null;
			String displayName = null;
			for (int i = 0; i < record.size(); i++) {
				rlo = (ReportableListObject) record.get(i);
				staffID = rlo.getValue(2);
				staffName = rlo.getValue(3);
				deptDesc = rlo.getValue(1);
				// show staff name, if no staff name, show empty
				if (staffName != null && staffName.trim().length() > 0) {
					displayName = staffName;
				} else {
					displayName = "";
				}

				userIDAvailable[i] = staffID;
				userIDDescAvailable[i] = displayName + " " + (deptDesc == null || deptDesc.length() == 0 ? "" : "(" + deptDesc + ")");

				// store string arrays in object based entity
				coUsers = new CoUsers();
				coUsers.setCoStaffId(userIDAvailable[i]);
				coUsers.setNameDept(userIDDescAvailable[i]);
				userIDAvailableList.add(coUsers);
			}
		} else {
			userIDAvailable = null;
			userIDDescAvailable = null;
		}

		return userIDAvailableList;
	}

	public static List<CoUsers> getSelectedCoUsersList(BigDecimal acDocumentId) {
	    	ArrayList record = null;
	    	String[] userID = null;
	    	String[] userIDDesc = null;
	    	List<CoUsers> userIDList = new ArrayList<CoUsers>();
	    	CoUsers coUsers = null;
	    	StringBuffer sqlStr = new StringBuffer();

		sqlStr.setLength(0);
		sqlStr.append("SELECT U.CO_FIRSTNAME, U.CO_LASTNAME, S.CO_STAFFNAME, D.CO_DEPARTMENT_DESC, S.CO_STAFF_ID ");
		sqlStr.append("FROM   AC_DOCUMENT_ACCESS AUG, CO_USERS U, CO_STAFFS S, CO_DEPARTMENTS D ");
		sqlStr.append("WHERE  AUG.AC_SITE_CODE = U.CO_SITE_CODE ");
		sqlStr.append("AND    AUG.AC_STAFF_ID = U.CO_STAFF_ID ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
		sqlStr.append("AND    S.CO_SITE_CODE = U.CO_SITE_CODE ");
		sqlStr.append("AND    S.CO_STAFF_ID = U.CO_STAFF_ID ");
		sqlStr.append("AND    AUG.AC_DOCUMENT_ID = ? ");
		sqlStr.append("AND    AUG.AC_ENABLED = 1 ");
		sqlStr.append("AND    S.CO_ENABLED = 1 ");
		sqlStr.append("ORDER  BY S.CO_STAFFNAME");

		record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { acDocumentId.toString() });
		if (record.size() > 0) {
			userID = new String[record.size()];
			userIDDesc = new String[record.size()];
			ReportableListObject rlo = null;
			String staffID = null;
			String userLastName = null;
			String userFirstName = null;
			String staffName = null;
			String deptDesc = null;
			String displayName = null;
			for (int i = 0; i < record.size(); i++) {
				rlo = (ReportableListObject) record.get(i);
				userFirstName = rlo.getValue(0);
				userLastName = rlo.getValue(1);
				staffName = rlo.getValue(2);
				deptDesc = rlo.getValue(3);
				staffID = rlo.getValue(4);
				// show staff name, if no staff name, show user first name and last name
				if (staffName != null && staffName.trim().length() > 0) {
					displayName = staffName;
				} else {
					displayName = (userFirstName == null ? "" : userFirstName) + (userLastName == null ? "" : userLastName);
				}

				userID[i] = staffID;
				userIDDesc[i] = displayName + " " + (deptDesc == null || deptDesc.length() == 0 ? "" : "(" + deptDesc + ")");

				// store string arrays in object based entity
				coUsers = new CoUsers();
				coUsers.setCoStaffId(userID[i]);
				coUsers.setNameDept(userIDDesc[i]);
				userIDList.add(coUsers);
			}
		} else {
			userID = null;
			userIDDesc = null;
		}

		return userIDList;
	}

	// Modifiy entity
	//-----------------
	public static boolean deleteAcDocumentAccess(BigDecimal acDocumentId, UserBean userBean) {
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		boolean success = false;

		try {
			transaction = session.beginTransaction();

			// batch update
			Query query = session.createQuery(
					"DELETE " +
					"FROM AcDocumentAccess " +
					"WHERE id.acDocumentId = ? " +
					"AND acEnabled = ? ");

			int paraCount = 0;
			query.setBigDecimal(paraCount++, acDocumentId);
			query.setInteger(paraCount++, 1);

			query.executeUpdate();
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

	public static int addAcDocumentAccess(BigDecimal acDocumentId, String[] groupIDs, String[] userIDs, UserBean userBean) {
		Session session = HibernateUtil.getCurrentSession();
		Transaction transaction = null;
		AcDocumentAccess acDocumentAccess = null;
		int rowCount = 0;

		try {
			transaction = session.beginTransaction();

			if (acDocumentId != null) {
				if (groupIDs != null) {
					for (String groupID : groupIDs) {
						if (groupID != null) {
							acDocumentAccess = new AcDocumentAccess();
							acDocumentAccess.setId(new AcDocumentAccessId(acDocumentId, "ALL", "ALL", "ALL", groupID));
							acDocumentAccess.setAcCreatedDate(new Date());
							acDocumentAccess.setAcCreatedUser(userBean.getLoginID());
							acDocumentAccess.setAcModifiedDate(new Date());
							acDocumentAccess.setAcModifiedUser(userBean.getLoginID());
							acDocumentAccess.setAcEnabled(1);

							session.save(acDocumentAccess);
							rowCount++;
						}
					}
				}

				if (userIDs != null) {
					for (String userID : userIDs) {
						if (userID != null) {
							acDocumentAccess = new AcDocumentAccess();
							acDocumentAccess.setId(new AcDocumentAccessId(acDocumentId, UserDB.getUserName(userID), "ALL", userID, "ALL"));
							acDocumentAccess.setAcCreatedDate(new Date());
							acDocumentAccess.setAcCreatedUser(userBean.getLoginID());
							acDocumentAccess.setAcModifiedDate(new Date());
							acDocumentAccess.setAcModifiedUser(userBean.getLoginID());
							acDocumentAccess.setAcEnabled(1);

							session.save(acDocumentAccess);
							rowCount++;
						}
					}
				}
			}

			transaction.commit();
			if (!transaction.wasCommitted()) {
				rowCount = 0;
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

		return rowCount;
	}

}