package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.fop.HealthClubCard;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class CRMClientMembershipDB {

	private static String sqlStr_insertMembership = null;
	private static String sqlStr_updateMembership = null;
	private static String sqlStr_deleteMembership = null;
	private static String sqlStr_getMembership = null;
	private static String sqlStr_getListMembership = null;

	private static String sqlStr_isExistMembership = null;

	private static String getNextClubSeq(String clientID, String clubID) {
		String clubSeq = null;

		// get next schedule id from db
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT COUNT(1) + 1 FROM CRM_CLIENTS_MEMBERSHIP WHERE  CRM_CLIENT_ID = ? AND CRM_CLUB_ID = ? ",
				new String[] { clientID, clubID });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			clubSeq = reportableListObject.getValue(0);

			// set 1 for initial
			if (clubSeq == null || clubSeq.length() == 0) return "1";
		}
		return clubSeq;
	}

	private static String getMaxClubSeq(String clientID, String clubID) {
		String clubSeq = "1";

		// get next schedule id from db
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(CRM_CLUB_SEQ) FROM CRM_CLIENTS_MEMBERSHIP WHERE CRM_CLIENT_ID = ? AND CRM_CLUB_ID = ? ",
				new String[] { clientID, clubID });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			clubSeq = reportableListObject.getValue(0);
		}
		return clubSeq;
	}

	/**
	 * Add a membership
	 */
	public static String add(UserBean userBean,
			String clientID, String clubID, String cardType, String memberID,
			String joinDate, String issueDate, String expiryDate, String paidYN) {

		// get next client ID
		String clubSeq = getNextClubSeq(clientID, clubID);

		// try to insert a new record
		if (UtilDBWeb.updateQueue(
				sqlStr_insertMembership,
				new String[] {
						clientID, clubID, clubSeq, cardType, memberID==null?null:memberID.toUpperCase(),
						joinDate, issueDate, expiryDate, paidYN,
						userBean.getLoginID(), userBean.getLoginID()} ) ) {
			return clubSeq;
		} else {
			return null;
		}
	}

	/**
	 * Modify a client
	 * @return whether it is successful to update the record
	 */
	public static boolean update(UserBean userBean,
			String clientID, String clubID, String clubSeq, String cardType, String memberID,
			String joinDate, String issueDate, String expiryDate, String paidYN) {
		return UtilDBWeb.updateQueue(
				sqlStr_updateMembership,
				new String [] {
						cardType, memberID.toUpperCase(),
						joinDate, issueDate, expiryDate, paidYN,
						userBean.getLoginID(),
						clientID, clubID, clubSeq}
				);
	}

	/**
	 * Modify a client
	 * @return whether it is successful to update the record
	 */
	public static boolean update(UserBean userBean,
			String clientID, String clubID, String cardType, String memberID,
			String joinDate, String issueDate, String expiryDate, String paidYN) {
		return UtilDBWeb.updateQueue(
				sqlStr_updateMembership,
				new String [] {
						cardType, memberID==null?memberID:memberID.toUpperCase(),
						joinDate, issueDate, expiryDate, paidYN,
						userBean.getLoginID(),
						clientID, clubID, getMaxClubSeq(clientID, clubID)}
				);
	}

	public static boolean delete(UserBean userBean,
			String clientID, String clubID, String clubSeq) {
		// try to delete selected record
		return UtilDBWeb.updateQueue(
				sqlStr_deleteMembership,
				new String[] { userBean.getLoginID(), clientID, clubID, clubSeq } );
	}

	public static ArrayList get(String clientID, String clubID, String clubSeq) {
		return UtilDBWeb.getReportableList(sqlStr_getMembership, new String[] { clientID, clubID, clubSeq });
	}

	public static ArrayList getList(String clientID, String clubID) {
		return UtilDBWeb.getReportableList(sqlStr_getListMembership, new String[] { clientID, clubID });
	}

	public static boolean isExistMemberID(String clientID, String clubID, String memberID) {
		return UtilDBWeb.isExist(sqlStr_isExistMembership, new String[] { clientID, clubID, memberID.toUpperCase() });
	}

	public static String createPDF(UserBean userBean, String clientID, String clubID, String clubSeq) {
		ArrayList record = CRMClientDB.get(clientID);
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			// get club user name
			String name = CRMClientDB.getClientName(row.getValue(0), row.getValue(1));
			record = get(clientID, clubID, clubSeq);
			if (record.size() > 0) {
				row = (ReportableListObject) record.get(0);
				// get member id
				String memberID = row.getValue(1);
				// get expiry date
				String expiryDate = row.getValue(5);

				String locationPath = ConstantsServerSide.TEMP_FOLDER + "/" + userBean.getLoginID() + ".fo";
				try {
					HealthClubCard.toXMLfile(name, memberID, expiryDate, locationPath);
					return locationPath;
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		return null;
	}

	// ---------------------------------------------------------------------
	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO CRM_CLIENTS_MEMBERSHIP ");
		sqlStr.append("(CRM_CLIENT_ID, CRM_CLUB_ID, CRM_CLUB_SEQ, CRM_CARD_TYPE, CRM_MEMBER_ID, ");
		sqlStr.append(" CRM_JOINED_DATE, CRM_ISSUE_DATE, CRM_EXPIRY_DATE, CRM_PAID_YN, ");
		sqlStr.append(" CRM_CREATED_USER, CRM_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ?, ?, ");
		sqlStr.append(" TO_DATE(?, 'dd/MM/yyyy'), TO_DATE(?, 'dd/MM/yyyy'), TO_DATE(?, 'dd/MM/yyyy'), ?, ");
		sqlStr.append(" ?, ?)");
		sqlStr_insertMembership = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CRM_CLIENTS_MEMBERSHIP ");
		sqlStr.append("SET    CRM_CARD_TYPE = ?, CRM_MEMBER_ID = ?, ");
		sqlStr.append("       CRM_JOINED_DATE = TO_DATE(?, 'dd/MM/yyyy'), ");
		sqlStr.append("       CRM_ISSUE_DATE = TO_DATE(?, 'dd/MM/yyyy'), ");
		sqlStr.append("       CRM_EXPIRY_DATE = TO_DATE(?, 'dd/MM/yyyy'), ");
		sqlStr.append("       CRM_PAID_YN = ?, ");
		sqlStr.append("       CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		sqlStr.append("AND    CRM_CLIENT_ID = ? ");
		sqlStr.append("AND    CRM_CLUB_ID = ? ");
		sqlStr.append("AND    CRM_CLUB_SEQ = ? ");
		sqlStr_updateMembership = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CRM_CLIENTS_MEMBERSHIP ");
		sqlStr.append("SET    CRM_ENABLED = 0, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		sqlStr.append("AND    CRM_CLIENT_ID = ? ");
		sqlStr.append("AND    CRM_CLUB_ID = ? ");
		sqlStr.append("AND    CRM_CLUB_SEQ = ? ");
		sqlStr_deleteMembership = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT CM.CRM_CARD_TYPE, CM.CRM_MEMBER_ID, M.CRM_CLUB_DESC, ");
		sqlStr.append("       TO_CHAR(CM.CRM_JOINED_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(CM.CRM_ISSUE_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(CM.CRM_EXPIRY_DATE, 'dd/MM/YYYY'), CM.CRM_PAID_YN ");
		sqlStr.append("FROM   CRM_CLIENTS_MEMBERSHIP CM, CRM_CLUBS M ");
		sqlStr.append("WHERE  CM.CRM_CLUB_ID = M.CRM_CLUB_ID ");
		sqlStr.append("AND    CM.CRM_ENABLED = 1 ");
		sqlStr.append("AND    CM.CRM_CLIENT_ID = ? ");
		sqlStr.append("AND    CM.CRM_CLUB_ID = ? ");
		sqlStr.append("AND    CM.CRM_CLUB_SEQ = ? ");
		sqlStr.append("ORDER BY CRM_CLUB_DESC");
		sqlStr_getMembership = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT CM.CRM_CARD_TYPE, CM.CRM_MEMBER_ID, M.CRM_CLUB_DESC, ");
		sqlStr.append("       TO_CHAR(CM.CRM_JOINED_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(CM.CRM_ISSUE_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(CM.CRM_EXPIRY_DATE, 'dd/MM/YYYY'), CM.CRM_PAID_YN ");
		sqlStr.append("FROM   CRM_CLIENTS_MEMBERSHIP CM, CRM_CLUBS M ");
		sqlStr.append("WHERE  CM.CRM_CLUB_ID = M.CRM_CLUB_ID ");
		sqlStr.append("AND    CM.CRM_ENABLED = 1 ");
		sqlStr.append("AND    CM.CRM_CLIENT_ID = ? ");
		sqlStr.append("AND    CM.CRM_CLUB_ID = ? ");
		sqlStr.append("ORDER BY CM.CRM_CLUB_SEQ DESC ");
		sqlStr_getListMembership = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM   CRM_CLIENTS_MEMBERSHIP CM, CRM_CLUBS M ");
		sqlStr.append("WHERE  CM.CRM_CLUB_ID = M.CRM_CLUB_ID ");
		sqlStr.append("AND    CM.CRM_ENABLED = M.CRM_ENABLED ");
		sqlStr.append("AND    CM.CRM_ENABLED = 1 ");
		sqlStr.append("AND    CM.CRM_CLIENT_ID != ? ");
		sqlStr.append("AND    CM.CRM_CLUB_ID = ? ");
		sqlStr.append("AND    CM.CRM_MEMBER_ID = ? ");
		sqlStr_isExistMembership = sqlStr.toString();
	}
}