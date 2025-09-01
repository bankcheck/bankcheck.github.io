package com.hkah.web.db;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.util.TextUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class NewsDB {
	private static final String contentUrlFrom = "\"/upload/";
	private static final String contentUrlTo = "\"https://" + ConstantsServerSide.OFFSITE_URL + "/upload/";
	private static final String WEBMASTER_EMAIL = ConstantsServerSide.MAIL_ALERT;
	private static final int DEFAULT_COLUMN_LENGTH = 1000;

	private static String sqlStr_insertNews = null;
	private static String sqlStr_updateNews = null;
	private static String sqlStr_deleteNews = null;
	private static String sqlStr_getNews = null;
	private static String sqlStr_getNewsExceptPoster = null;
	private static String sqlStr_getNewsContent = null;

	private static String sqlStr_insertNewsContent = null;
	private static String sqlStr_deleteNewsContent = null;
	private static String sqlStr_updateNews_HitRate = null;
	private static String sqlStr_updateNews_Enabled = null;
	private static String sqlStr_updateNews_Like1 = null;
	private static String sqlStr_updateNews_Like2 = null;
	private static String sqlStr_updateNews_Like3 = null;
	public static Map<String, String> categories = new HashMap<String, String>();
	public static Map<String, String> senders = new HashMap<String, String>();

	private static String getNextNewsID(String newsCategory) {
		String newsID = null;

		// get next schedule id from db
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(CO_NEWS_ID) + 1 FROM CO_NEWS WHERE CO_NEWS_CATEGORY = ?",
				new String[] { newsCategory });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			newsID = reportableListObject.getValue(0);

			// set 1 for initial
			if (newsID == null || newsID.length() == 0) return ConstantsVariable.ONE_VALUE;
		}
		return newsID;
	}

	/**
	 * Add a news
	 */
	public static String add(UserBean userBean,
			String newsCategory) {

		// get next schedule ID
		String newsID = getNextNewsID(newsCategory);

		// try to insert a new record
		if (UtilDBWeb.updateQueue(
				sqlStr_insertNews,
				new String[] { newsID, newsCategory,
						userBean.getLoginID(), userBean.getLoginID() })) {
			return newsID;
		} else {
			return null;
		}
	}

	/**
	 * Modify a news
	 * @return whether it is successful to update the record
	 */
	public static boolean update(UserBean userBean,
			String newsID, String newsCategory, String newsType, String newsSender,
			String newsTitle, String newsTitleUrl, String newsTitleImage,
			String newsPostDate, String newsExpireDate,
			String content,
			String emailNotifyFromSelf, String emailNotifyToAll, String emailExclude, String postHomepage) {

		// try to update selected record
		if (!"1".equals(postHomepage)) {
			postHomepage = "0";
		}
		if (UtilDBWeb.updateQueue(
				sqlStr_updateNews,
				new String[] {
						newsType, newsSender, newsTitle, newsTitleUrl, newsTitleImage,
						newsPostDate, newsExpireDate, postHomepage ,
						userBean.getLoginID(), newsID, newsCategory})) {

			// delete existing content
			deleteContent(userBean, newsID, newsCategory);

			// set content
			addContent(userBean, newsID, newsCategory, processContent(content));

			if ("poster".equals(newsCategory)) {
				NewsDB.updateEnabled(newsID, newsCategory, "0");
			}

			sendEmail(newsID, userBean.getStaffID(), newsCategory, newsType, newsTitle, newsTitleImage, content,
					ConstantsVariable.YES_VALUE.equals(emailNotifyFromSelf),
					emailNotifyToAll,
					"S".equals(emailNotifyToAll),
					ConstantsVariable.YES_VALUE.equals(emailExclude)
				);
			return true;
		} else {
			return false;
		}
	}

	/**
	 * delete news
	 */
	public static boolean delete(UserBean userBean,
			String newsID, String newsCategory) {
		// try to delete selected record
		return UtilDBWeb.updateQueue(
				sqlStr_deleteNews,
				new String[] { userBean.getLoginID(), newsCategory, newsID });
	}

	/**
	 * Add a news
	 */
	private static void addContent(UserBean userBean,
			String newsID, String newsCategory, String[] contents) {

		// try to insert a new record
		for (int i = 0; i < contents.length; i++) {
			UtilDBWeb.updateQueue(
				sqlStr_insertNewsContent,
				new String[] { newsID, newsCategory, String.valueOf(i + 1),
						contents[i], userBean.getLoginID(), userBean.getLoginID() });
		}
	}

	/**
	 * delete news content
	 * @return whether it is successful to update the record
	 */
	private static boolean deleteContent(UserBean userBean,
			String newsID, String newsCategory) {

		// try to delete content
		return UtilDBWeb.updateQueue(
				sqlStr_deleteNewsContent,
				new String[] {
						newsID, newsCategory });
	}

	public static ArrayList getList(UserBean userBean, String newsCategory, int noOfMaxRecord) {
		return getList(userBean, newsCategory, null, null, null, 0, noOfMaxRecord, 0,1);
	}

	public static ArrayList getList(UserBean userBean, String newsCategory, String newsType, int noOfMaxRecord) {
		return getList(userBean, newsCategory, newsType, null, null, 0, noOfMaxRecord, 0,1);
	}

	public static ArrayList getList(UserBean userBean, String newsCategory, String newsType, String title, int noOfMaxRecord, int sortBy) {
		return getList(userBean, newsCategory, newsType, null, title, 0, noOfMaxRecord, sortBy,1);
	}

	public static ArrayList getList(UserBean userBean, String newsCategory, String newsType, String newsTypeExcept, int activeNews, int noOfMaxRecord, int sortBy) {
		return getList(userBean, newsCategory, newsType, newsTypeExcept, null, activeNews, noOfMaxRecord, sortBy,1);
	}

	public static ArrayList getList(UserBean userBean, String newsCategory, String newsType, String newsTypeExcept, String title, int activeNews, int noOfMaxRecord, int sortBy) {
		return getList(userBean, newsCategory, newsType, newsTypeExcept, title, activeNews, noOfMaxRecord, sortBy,1);
	}

	public static ArrayList getTopNewsList(UserBean userBean) {
		return getNewsList(userBean, 3, "");
	}

	public static ArrayList getTopNewsList(UserBean userBean, String mode) {
		return getNewsList(userBean, 3, mode);
	}

	public static ArrayList getPopularNewsList(UserBean userBean) {
		return getNewsList(userBean, 2, "");
	}

	public static String[] getNewsID(String newsCategory, String newsType) {
		// fetch news list
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT MAX(CO_NEWS_ID), CO_NEWS_CATEGORY ");
		sqlStr.append("FROM   CO_NEWS ");
		sqlStr.append("WHERE  CO_ENABLED = 1 ");
		if (newsCategory != null && newsCategory.length() > 0) {
			sqlStr.append("AND    CO_NEWS_CATEGORY LIKE '%");
			sqlStr.append(newsCategory);
			sqlStr.append("%' ");
		}
		if (newsType != null && newsType.length() > 0) {
			sqlStr.append("AND    CO_NEWS_TYPE LIKE '%");
			sqlStr.append(newsType);
			sqlStr.append("%' ");
		}
		sqlStr.append("GROUP BY CO_NEWS_CATEGORY ");

		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			return new String[] { row.getValue(0), row.getValue(1) };
		}
		return null;
	}

	public static ArrayList getNewsList(UserBean userBean, int sortBy, String mode) {
		// fetch news list
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT N.CO_NEWS_ID, N.CO_NEWS_CATEGORY, ");
		if ("renovationnews".equals(mode)) {
			sqlStr.append("		  DECODE(N.CO_NEWS_TYPE, 'status1', 'Completed', 'status2', 'To be Completed', 'status3', 'To Commence', 'status4', 'Delay'), ");
		} else {
			sqlStr.append("		  N.CO_NEWS_TYPE, ");
		}
		sqlStr.append("       N.CO_TITLE, N.CO_TITLE_URL, N.CO_TITLE_IMAGE, ");
		sqlStr.append("       TO_CHAR(N.CO_POST_DATE, 'dd/MM/YYYY HH24:MI'), ");
		sqlStr.append("       TO_CHAR(N.CO_EXPIRE_DATE, 'dd/MM/YYYY HH24:MI'), ");
		sqlStr.append("       TO_CHAR(N.CO_EVENT_DATE, 'dd/MM/YYYY HH24:MI'), ");
		sqlStr.append("       C1.CO_CONTENT, C2.CO_CONTENT, C3.CO_CONTENT, C4.CO_CONTENT, C5.CO_CONTENT, ");
		sqlStr.append("       C6.CO_CONTENT, C7.CO_CONTENT, C8.CO_CONTENT, C9.CO_CONTENT, N.CO_HIT_RATE, ");
		sqlStr.append("       N.CO_LIKED, L.CO_ENABLED ");
		sqlStr.append("FROM   CO_NEWS N ");
		sqlStr.append("       LEFT JOIN CO_NEWS_CONTENT C1 ON N.CO_NEWS_ID = C1.CO_NEWS_ID AND N.CO_NEWS_CATEGORY = C1.CO_NEWS_CATEGORY AND C1.CO_NEWS_CONTENT_ID = 1 ");
		sqlStr.append("       LEFT JOIN CO_NEWS_CONTENT C2 ON N.CO_NEWS_ID = C2.CO_NEWS_ID AND N.CO_NEWS_CATEGORY = C2.CO_NEWS_CATEGORY AND C2.CO_NEWS_CONTENT_ID = 2 ");
		sqlStr.append("       LEFT JOIN CO_NEWS_CONTENT C3 ON N.CO_NEWS_ID = C3.CO_NEWS_ID AND N.CO_NEWS_CATEGORY = C3.CO_NEWS_CATEGORY AND C3.CO_NEWS_CONTENT_ID = 3 ");
		sqlStr.append("       LEFT JOIN CO_NEWS_CONTENT C4 ON N.CO_NEWS_ID = C4.CO_NEWS_ID AND N.CO_NEWS_CATEGORY = C4.CO_NEWS_CATEGORY AND C4.CO_NEWS_CONTENT_ID = 4 ");
		sqlStr.append("       LEFT JOIN CO_NEWS_CONTENT C5 ON N.CO_NEWS_ID = C5.CO_NEWS_ID AND N.CO_NEWS_CATEGORY = C5.CO_NEWS_CATEGORY AND C5.CO_NEWS_CONTENT_ID = 5 ");
		sqlStr.append("       LEFT JOIN CO_NEWS_CONTENT C6 ON N.CO_NEWS_ID = C6.CO_NEWS_ID AND N.CO_NEWS_CATEGORY = C6.CO_NEWS_CATEGORY AND C6.CO_NEWS_CONTENT_ID = 6 ");
		sqlStr.append("       LEFT JOIN CO_NEWS_CONTENT C7 ON N.CO_NEWS_ID = C7.CO_NEWS_ID AND N.CO_NEWS_CATEGORY = C7.CO_NEWS_CATEGORY AND C7.CO_NEWS_CONTENT_ID = 7 ");
		sqlStr.append("       LEFT JOIN CO_NEWS_CONTENT C8 ON N.CO_NEWS_ID = C8.CO_NEWS_ID AND N.CO_NEWS_CATEGORY = C8.CO_NEWS_CATEGORY AND C8.CO_NEWS_CONTENT_ID = 8 ");
		sqlStr.append("       LEFT JOIN CO_NEWS_CONTENT C9 ON N.CO_NEWS_ID = C9.CO_NEWS_ID AND N.CO_NEWS_CATEGORY = C9.CO_NEWS_CATEGORY AND C9.CO_NEWS_CONTENT_ID = 9 ");
		sqlStr.append("       LEFT JOIN CO_NEWS_LIKE L ON N.CO_NEWS_ID = L.CO_NEWS_ID AND N.CO_NEWS_CATEGORY = L.CO_NEWS_CATEGORY AND L.CO_STAFF_ID = '");
		sqlStr.append(userBean.getStaffID());
		sqlStr.append("' ");
		sqlStr.append("WHERE  N.CO_ENABLED = 1 ");
		sqlStr.append("AND    N.CO_NEWS_CATEGORY NOT IN 'lmc.crm' ");
//		sqlStr.append("AND    N.CO_NEWS_CATEGORY IN ('hospital', 'education', 'marketing', 'osh', 'other') ");
		sqlStr.append("AND    N.CO_NEWS_TYPE NOT IN ('bank', 'package') ");
		sqlStr.append("AND    N.CO_POST_DATE <= SYSDATE ");
		sqlStr.append("AND   (N.CO_EXPIRE_DATE IS NULL OR N.CO_EXPIRE_DATE >= SYSDATE) ");

		// check if "generalnews", no display renovation news
		if ("generalnews".equals(mode)) {
			sqlStr.append("AND    N.CO_NEWS_CATEGORY <> 'renov.upd' ");
			sqlStr.append("AND    N.CO_NEWS_CATEGORY <> 'promotion' ");
		} else if ("renovationnews".equals(mode)) {
			sqlStr.append("AND    N.CO_NEWS_CATEGORY = 'renov.upd' ");
			sqlStr.append("AND    N.CO_POST_HOMEPAGE = '1' ");
		} else if("promotion".equals(mode)){
			sqlStr.append("AND    N.CO_NEWS_CATEGORY = 'promotion' ");
		}

		if (sortBy == 1) {
			sqlStr.append("ORDER BY N.CO_POST_DATE DESC, N.CO_NEWS_CATEGORY, N.CO_NEWS_TYPE");
		} else if (sortBy == 3) {
			sqlStr.append("AND    N.CO_NEWS_CATEGORY NOT IN ('poster') ");
			sqlStr.append("ORDER BY N.CO_POST_DATE DESC, N.CO_NEWS_CATEGORY, N.CO_NEWS_TYPE");
		} else {
			sqlStr.append("ORDER BY N.CO_HIT_RATE DESC, N.CO_POST_DATE DESC, N.CO_NEWS_CATEGORY, N.CO_NEWS_TYPE");
		}

		return UtilDBWeb.getReportableList(sqlStr.toString(), 30);
	}

	public static ArrayList getList(UserBean userBean, String newsCategory, String newsType, String newsTypeExcept, String title, int activeNews, int noOfMaxRecord, int sortBy, int enableValue) {
		// fetch leave
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT N.CO_NEWS_ID, N.CO_NEWS_CATEGORY, N.CO_NEWS_TYPE, ");
		sqlStr.append("       N.CO_TITLE, N.CO_TITLE_URL, N.CO_TITLE_IMAGE, ");
		sqlStr.append("       TO_CHAR(N.CO_POST_DATE, 'dd/MM/YYYY HH24:MI'), ");
		sqlStr.append("       TO_CHAR(N.CO_EXPIRE_DATE, 'dd/MM/YYYY HH24:MI'), ");
		sqlStr.append("       TO_CHAR(N.CO_EVENT_DATE, 'dd/MM/YYYY HH24:MI'), ");
		sqlStr.append("       C1.CO_CONTENT, C2.CO_CONTENT, C3.CO_CONTENT, C4.CO_CONTENT, C5.CO_CONTENT, ");
		sqlStr.append("       C6.CO_CONTENT, C7.CO_CONTENT, C8.CO_CONTENT, C9.CO_CONTENT, N.CO_HIT_RATE, ");
		sqlStr.append("       N.CO_LIKED, L.CO_ENABLED, ");
		sqlStr.append("       N.CO_NEWS_SENDER, decode(CO_POST_HOMEPAGE, 1, 'Posted', 'Not yet posted'), ");
		//sqlStr.append("       N.CO_NEWS_SENDER, decode(co_expire_date, null, 'Posted', 'Not yet posted'), ");
		sqlStr.append("       FN_CO_NEWS_CONTENT(N.CO_NEWS_ID) ");
		sqlStr.append("FROM   CO_NEWS N ");
		sqlStr.append("       LEFT JOIN CO_NEWS_CONTENT C1 ON N.CO_NEWS_ID = C1.CO_NEWS_ID AND N.CO_NEWS_CATEGORY = C1.CO_NEWS_CATEGORY AND C1.CO_NEWS_CONTENT_ID = 1 ");
		sqlStr.append("       LEFT JOIN CO_NEWS_CONTENT C2 ON N.CO_NEWS_ID = C2.CO_NEWS_ID AND N.CO_NEWS_CATEGORY = C2.CO_NEWS_CATEGORY AND C2.CO_NEWS_CONTENT_ID = 2 ");
		sqlStr.append("       LEFT JOIN CO_NEWS_CONTENT C3 ON N.CO_NEWS_ID = C3.CO_NEWS_ID AND N.CO_NEWS_CATEGORY = C3.CO_NEWS_CATEGORY AND C3.CO_NEWS_CONTENT_ID = 3 ");
		sqlStr.append("       LEFT JOIN CO_NEWS_CONTENT C4 ON N.CO_NEWS_ID = C4.CO_NEWS_ID AND N.CO_NEWS_CATEGORY = C4.CO_NEWS_CATEGORY AND C4.CO_NEWS_CONTENT_ID = 4 ");
		sqlStr.append("       LEFT JOIN CO_NEWS_CONTENT C5 ON N.CO_NEWS_ID = C5.CO_NEWS_ID AND N.CO_NEWS_CATEGORY = C5.CO_NEWS_CATEGORY AND C5.CO_NEWS_CONTENT_ID = 5 ");
		sqlStr.append("       LEFT JOIN CO_NEWS_CONTENT C6 ON N.CO_NEWS_ID = C6.CO_NEWS_ID AND N.CO_NEWS_CATEGORY = C6.CO_NEWS_CATEGORY AND C6.CO_NEWS_CONTENT_ID = 6 ");
		sqlStr.append("       LEFT JOIN CO_NEWS_CONTENT C7 ON N.CO_NEWS_ID = C7.CO_NEWS_ID AND N.CO_NEWS_CATEGORY = C7.CO_NEWS_CATEGORY AND C7.CO_NEWS_CONTENT_ID = 7 ");
		sqlStr.append("       LEFT JOIN CO_NEWS_CONTENT C8 ON N.CO_NEWS_ID = C8.CO_NEWS_ID AND N.CO_NEWS_CATEGORY = C8.CO_NEWS_CATEGORY AND C8.CO_NEWS_CONTENT_ID = 8 ");
		sqlStr.append("       LEFT JOIN CO_NEWS_CONTENT C9 ON N.CO_NEWS_ID = C9.CO_NEWS_ID AND N.CO_NEWS_CATEGORY = C9.CO_NEWS_CATEGORY AND C9.CO_NEWS_CONTENT_ID = 9 ");
		sqlStr.append("       LEFT JOIN CO_NEWS_LIKE L ON N.CO_NEWS_ID = L.CO_NEWS_ID AND N.CO_NEWS_CATEGORY = L.CO_NEWS_CATEGORY AND L.CO_STAFF_ID = '");
		sqlStr.append(userBean.getStaffID());
		sqlStr.append("' ");
		sqlStr.append("WHERE  N.CO_ENABLED = '");
		sqlStr.append(enableValue);
		sqlStr.append("' ");
		if (newsCategory != null && newsCategory.length() > 0) {
			sqlStr.append("AND    N.CO_NEWS_CATEGORY = '");
			sqlStr.append(newsCategory);
			sqlStr.append("' ");
		}
		if (newsType != null && newsType.length() > 0) {
			sqlStr.append("AND    N.CO_NEWS_TYPE LIKE '%");
			sqlStr.append(newsType);
			sqlStr.append("%' ");
		}
		if (newsTypeExcept != null && newsTypeExcept.length() > 0) {
			sqlStr.append("AND    N.CO_NEWS_TYPE != '");
			sqlStr.append(newsTypeExcept);
			sqlStr.append("' ");
		}
		if (title != null && title.length() > 0) {
			title = title.toUpperCase();
			sqlStr.append("AND    UPPER(N.CO_TITLE) LIKE '%");
			sqlStr.append(title);
			sqlStr.append("%' ");
		}
		if (activeNews == 1) {
			sqlStr.append("AND    N.CO_POST_DATE <= SYSDATE ");
			sqlStr.append("AND    (N.CO_EXPIRE_DATE IS NULL OR N.CO_EXPIRE_DATE >= SYSDATE) ");
		}
		if (sortBy == 1) {
			sqlStr.append("ORDER BY N.CO_NEWS_CATEGORY, N.CO_NEWS_TYPE, N.CO_POST_DATE DESC, N.CO_TITLE");
		} else if (sortBy == 2) {
			sqlStr.append("order by n.co_expire_date desc NULLS FIRST, N.CO_NEWS_CATEGORY, N.CO_NEWS_TYPE, N.CO_TITLE");
		} else if (sortBy == 3) {
			sqlStr.append("ORDER BY N.CO_NEWS_CATEGORY, N.CO_NEWS_TYPE, N.CO_NEWS_ID Asc ");
		} else {
			sqlStr.append("ORDER BY N.CO_POST_DATE DESC, N.CO_NEWS_CATEGORY, N.CO_NEWS_TYPE, N.CO_TITLE");
		} 
		//System.out.println(sqlStr.toString());
		if (noOfMaxRecord > 0) {
			return UtilDBWeb.getReportableList(sqlStr.toString(), noOfMaxRecord);
		} else {
			return UtilDBWeb.getReportableList(sqlStr.toString());
		}
	}

	public static ArrayList get(UserBean userBean, String newsID, String newsCategory) {
		return get(userBean, newsID, newsCategory, "1");
	}

	public static ArrayList get(UserBean userBean, String newsID, String newsCategory, String enabled) {
		// fetch news
		return UtilDBWeb.getReportableList(sqlStr_getNews, new String[] { userBean.getStaffID(), enabled, newsCategory, newsID });
	}

	public static ArrayList getNewsExceptPoster(UserBean userBean, String newsID, String newsCategory) {
		// fetch news
		return UtilDBWeb.getReportableList(sqlStr_getNewsExceptPoster, new String[] { userBean.getStaffID(), newsCategory, newsID });
	}

	public static ArrayList getContent(String newsID, String newsCategory) {
		// fetch news
		return UtilDBWeb.getReportableList(sqlStr_getNewsContent, new String[] { newsID, newsCategory });
	}

	public static void updateHitRate(String newsID, String newsCategory) {
		if (newsID == null || newsID.trim().isEmpty()) {
			return;
		}
		UtilDBWeb.updateQueue(sqlStr_updateNews_HitRate, new String[] { newsID, newsCategory });
	}

	public static void updateLike(UserBean userBean, String newsID, String newsCategory, boolean like) {
		if (!UtilDBWeb.updateQueue(sqlStr_updateNews_Like3, new String[] { like ? "1" : "0", newsID, newsCategory, userBean.getStaffID(), like ? "0" : "1" })) {
			// not exist
			UtilDBWeb.updateQueue(sqlStr_updateNews_Like2, new String[] { newsID, newsCategory, userBean.getStaffID(), userBean.getLoginID(), userBean.getLoginID() });
		}
		UtilDBWeb.updateQueue(sqlStr_updateNews_Like1, new String[] { like ? "1" : "-1", newsID, newsCategory });
	}

	public static void updateEnabled (String newsID, String newsCategory,String enabled) {
		UtilDBWeb.updateQueue(sqlStr_updateNews_Enabled, new String[] { enabled,newsID, newsCategory });
	}

	private static String[] processContent(String content) {
		if (content != null) {
			return TextUtil.split(content, DEFAULT_COLUMN_LENGTH);
		} else {
			return null;
		}
	}

	private static void sendEmail(String newsID, String fromStaffID,
			String newsCategory, String newsType, String newsTitle, String newsTitleImage, String content,
			boolean emailNotifyFromSelf, String emailNotifyToAll, boolean emailNotifyToSelf, boolean emailExclude) {
		String emailSelf = UserDB.getUserEmail(null, fromStaffID);
		// default value
		String emailFrom = WEBMASTER_EMAIL;
		if (emailNotifyFromSelf) {
			if (emailExclude) {
				emailFrom = "marketing@hkah.org.hk";
			} else if (emailSelf != null && emailSelf.length() > 0) {
				emailFrom = emailSelf;
			}
		}

		// append url
		StringBuffer commentStr = new StringBuffer();
		if (newsTitleImage != null && newsTitleImage.length() > 0) {
			commentStr.append("<img src=\"https://");
			commentStr.append(ConstantsServerSide.OFFSITE_URL);
			commentStr.append("/upload/");
			commentStr.append(newsCategory);
			commentStr.append("/");
			commentStr.append(newsID);
			commentStr.append("/");
			commentStr.append(newsTitleImage);
			commentStr.append("\" />");
			commentStr.append("<br />");
		}
		commentStr.append(contentParser(content));
		commentStr.append("<br />");
		commentStr.append("Please click <a href=\"http://");
		commentStr.append(ConstantsServerSide.INTRANET_URL);
		commentStr.append("/intranet/portal/news_view.jsp?newsID=");
		commentStr.append(newsID);
		commentStr.append("&newsCategory=");
		commentStr.append(newsCategory);
		commentStr.append("\">Intranet</a> or <a href=\"https://");
		commentStr.append(ConstantsServerSide.OFFSITE_URL);
		commentStr.append("/intranet/portal/news_view.jsp?newsID=");
		commentStr.append(newsID);
		commentStr.append("&newsCategory=");
		commentStr.append(newsCategory);
		commentStr.append("\">Offsite</a> to view the detail.");

		// send email
		if ("poster".equals(newsCategory)) {
			EmailAlertDB.sendEmail("news.approval", newsTitle+" (Apply for approval(by MKT)) ", commentStr.toString());
			emailNotifyToAll = "N";
			emailNotifyToSelf = true;
			emailSelf = "";
		}
		if (ConstantsVariable.YES_VALUE.equals(emailNotifyToAll)) {
			UtilMail.sendMail(emailFrom, ConstantsServerSide.MAIL_ALLSTAFF, newsTitle, commentStr.toString());
		}
		if (emailNotifyToSelf && emailSelf != null && emailSelf.length() > 0) {
			UtilMail.sendMail(emailFrom, emailSelf, newsTitle, commentStr.toString());
		}
		if ("unitManager".equals(emailNotifyToAll)) {
			UtilMail.sendMail(emailFrom, "unitm@hkah.org.hk", newsTitle, commentStr.toString());
		} else if ("adminDept".equals(emailNotifyToAll)) {
			UtilMail.sendMail(emailFrom, "admindept@hkah.org.hk", newsTitle, commentStr.toString());
		} else if ("ancillaryDept".equals(emailNotifyToAll)) {
			UtilMail.sendMail(emailFrom, "ancillarydept@hkah.org.hk", newsTitle, commentStr.toString());
		} else if ("nursingUnit".equals(emailNotifyToAll)) {
			UtilMail.sendMail(emailFrom, "nursingunit@hkah.org.hk", newsTitle, commentStr.toString());
		} else if ("supportDept".equals(emailNotifyToAll)) {
			UtilMail.sendMail(emailFrom, "supportdept@hkah.org.hk", newsTitle, commentStr.toString());
		} else if ("serviceUnit".equals(emailNotifyToAll)) {
			UtilMail.sendMail(emailFrom, "serviceunit@hkah.org.hk", newsTitle, commentStr.toString());
		} else if ("ammed".equals(emailNotifyToAll)) {
			UtilMail.sendMail(emailFrom, "ammedcenter@hkah.org.hk", newsTitle, commentStr.toString());
		}
	}

	public static String getRenovationClass(String status) {
		if ("status1".equals(status)) {
			return "Completed";
		} else if ("status2".equals(status)) {
			return "To be Completed";
		} else if ("status3".equals(status)) {
			return "To Commence";
		} else if ("status4".equals(status)) {
			return "Delay";
		}
		return "";
	}

	private static String contentParser(String content) {
		return TextUtil.replaceAll(content, contentUrlFrom, contentUrlTo);
	}

	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO CO_NEWS ");
		sqlStr.append("(CO_NEWS_ID, CO_NEWS_CATEGORY, ");
		sqlStr.append("CO_CREATED_USER, CO_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ");
		sqlStr.append("?, ?)");
		sqlStr_insertNews = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_NEWS ");
		sqlStr.append("SET    CO_NEWS_TYPE = ?, CO_NEWS_SENDER = ?, CO_TITLE = ?, ");
		sqlStr.append("       CO_TITLE_URL = ?, CO_TITLE_IMAGE = ?, ");
		sqlStr.append("       CO_POST_DATE = TO_DATE(?, 'dd/MM/yyyy HH24:MI'), ");
		sqlStr.append("       CO_EXPIRE_DATE = TO_DATE(?, 'dd/MM/yyyy HH24:MI'), ");
		sqlStr.append("       CO_POST_HOMEPAGE = ?, ");
		sqlStr.append("       CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CO_NEWS_ID = ? ");
		sqlStr.append("AND    CO_NEWS_CATEGORY = ? ");
		sqlStr.append("AND    CO_ENABLED = 1 ");
		sqlStr_updateNews = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_NEWS ");
		sqlStr.append("SET    CO_ENABLED = 0, CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CO_NEWS_CATEGORY = ? ");
		sqlStr.append("AND    CO_NEWS_ID = ? ");
		sqlStr.append("AND    CO_ENABLED = 1 ");
		sqlStr_deleteNews = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO CO_NEWS_CONTENT ");
		sqlStr.append("(CO_NEWS_ID, CO_NEWS_CATEGORY, CO_NEWS_CONTENT_ID, ");
		sqlStr.append("CO_CONTENT, CO_CREATED_USER, CO_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ");
		sqlStr.append("?, ?, ?)");
		sqlStr_insertNewsContent = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("DELETE FROM CO_NEWS_CONTENT ");
		sqlStr.append("WHERE  CO_NEWS_ID = ? ");
		sqlStr.append("AND    CO_NEWS_CATEGORY = ? ");
		sqlStr.append("AND    CO_ENABLED = 1 ");
		sqlStr_deleteNewsContent = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT N.CO_NEWS_ID, N.CO_NEWS_CATEGORY, N.CO_NEWS_TYPE, ");
		sqlStr.append("       N.CO_TITLE, N.CO_TITLE_URL, N.CO_TITLE_IMAGE, ");
		sqlStr.append("       TO_CHAR(N.CO_POST_DATE, 'dd/MM/YYYY HH24:MI'), ");
		sqlStr.append("       TO_CHAR(N.CO_EXPIRE_DATE, 'dd/MM/YYYY HH24:MI'), ");
		sqlStr.append("       N.CO_HIT_RATE, N.CO_LIKED, L.CO_ENABLED, ");
		sqlStr.append("       N.CO_NEWS_SENDER, CO_POST_HOMEPAGE ");
		sqlStr.append("FROM   CO_NEWS N ");
		sqlStr.append("       LEFT JOIN CO_NEWS_LIKE L ON N.CO_NEWS_ID = L.CO_NEWS_ID AND N.CO_NEWS_CATEGORY = L.CO_NEWS_CATEGORY AND L.CO_STAFF_ID = ? ");
		sqlStr.append("WHERE  N.CO_ENABLED = ? ");
		sqlStr.append("AND    N.CO_NEWS_CATEGORY = ? ");
		sqlStr.append("AND    N.CO_NEWS_ID = ? ");
		sqlStr_getNews = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT N.CO_NEWS_ID, N.CO_NEWS_CATEGORY, N.CO_NEWS_TYPE, ");
		sqlStr.append("       N.CO_TITLE, N.CO_TITLE_URL, N.CO_TITLE_IMAGE, ");
		sqlStr.append("       TO_CHAR(N.CO_POST_DATE, 'dd/MM/YYYY HH24:MI'), ");
		sqlStr.append("       TO_CHAR(N.CO_EXPIRE_DATE, 'dd/MM/YYYY HH24:MI'), ");
		sqlStr.append("       N.CO_HIT_RATE, N.CO_LIKED, L.CO_ENABLED, ");
		sqlStr.append("       N.CO_NEWS_SENDER ");
		sqlStr.append("FROM   CO_NEWS N ");
		sqlStr.append("       LEFT JOIN CO_NEWS_LIKE L ON N.CO_NEWS_ID = L.CO_NEWS_ID AND N.CO_NEWS_CATEGORY = L.CO_NEWS_CATEGORY AND L.CO_STAFF_ID = ? ");
		sqlStr.append("WHERE  N.CO_ENABLED = 1 ");
		sqlStr.append("AND    N.CO_NEWS_CATEGORY = ? ");
		sqlStr.append("AND    N.CO_NEWS_ID = ? ");
		sqlStr.append("AND    N.CO_NEWS_CATEGORY NOT IN 'poster' ");
		sqlStr_getNewsExceptPoster = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT CO_CONTENT ");
		sqlStr.append("FROM   CO_NEWS_CONTENT ");
		sqlStr.append("WHERE  CO_ENABLED = 1 ");
		sqlStr.append("AND    CO_NEWS_ID = ? ");
		sqlStr.append("AND    CO_NEWS_CATEGORY = ? ");
		sqlStr.append("ORDER BY CO_NEWS_CONTENT_ID ");
		sqlStr_getNewsContent = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_NEWS ");
		sqlStr.append("SET    CO_HIT_RATE = CO_HIT_RATE + 1 ");
		sqlStr.append("WHERE  CO_NEWS_ID = ? ");
		sqlStr.append("AND    CO_NEWS_CATEGORY = ? ");
		sqlStr.append("AND    CO_ENABLED = 1 ");
		sqlStr_updateNews_HitRate = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_NEWS ");
		sqlStr.append("SET    CO_ENABLED = ? ");
		sqlStr.append("WHERE  CO_NEWS_ID = ? ");
		sqlStr.append("AND    CO_NEWS_CATEGORY = ? ");
		sqlStr_updateNews_Enabled = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_NEWS ");
		sqlStr.append("SET    CO_LIKED = CO_LIKED + ? ");
		sqlStr.append("WHERE  CO_NEWS_ID = ? ");
		sqlStr.append("AND    CO_NEWS_CATEGORY = ? ");
		sqlStr.append("AND    CO_ENABLED = 1 ");
		sqlStr_updateNews_Like1 = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO CO_NEWS_LIKE ");
		sqlStr.append("(CO_NEWS_ID, CO_NEWS_CATEGORY, CO_STAFF_ID, CO_CREATED_USER, CO_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ?, ?)");
		sqlStr_updateNews_Like2 = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_NEWS_LIKE ");
		sqlStr.append("SET    CO_ENABLED = ? ");
		sqlStr.append("WHERE  CO_NEWS_ID = ? ");
		sqlStr.append("AND    CO_NEWS_CATEGORY = ? ");
		sqlStr.append("AND    CO_STAFF_ID = ? ");
		sqlStr.append("AND    CO_ENABLED = ? ");
		sqlStr_updateNews_Like3 = sqlStr.toString();

		categories.put("accreditation", "Accreditation");
		categories.put("chap", "Chaplaincy");
		categories.put("education", "Education");
		categories.put("executive order", "Executive Order");
		categories.put("physician", "Executive Order - Physician");
		categories.put("vpma", "Executive Order - VPMA");
		categories.put("hospital", "Hospital");
		categories.put("human resources", "Human Resources");
		categories.put("infection control", "Infection Control");
		categories.put("LMC", "LifeStyle Management Centre");
		categories.put("marketing", "Marketing");
		categories.put("newsletter", "Newsletter");
		categories.put("newstart", "NEWSTART Health Centre");
		categories.put("nursing", "Nursing");
		categories.put("osh", "OSH/EHS");
		categories.put("poster", "Poster");
		categories.put("pi", "Performance Improvement");
		categories.put("special sharing", "Special Sharing");
		categories.put("lmc.crm", "CRM");
		categories.put("pem", "PEM");
		categories.put("other", "Other");

		senders.put("from ceo", "from CEO");
		senders.put("from vice president for medical affairs", "from Vice President for Medical Affairs");
		senders.put("from vice president for administration", "from Vice President for Administration");
		senders.put("from medical program administrator", "from Medical Program Administrator");
		senders.put("from human resource director", "from Human Resource Director");
		senders.put("from nursing administrator", "from Nursing Administrator");
		senders.put("from vice president for physician services", "from Vice President for Physician Services");
		senders.put("from chief of medical staff", "from Chief of Medical Staff");
	}
}