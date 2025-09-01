/*
 * Created on April 8, 2009
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.web.db;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.DateTimeUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ELearning {

	private static String getNextELearningID() {
		String elearningID = null;

		ArrayList<ReportableListObject> result = UtilDBWeb.getReportableList(
				"SELECT MAX(EE_ELEARNING_ID) + 1 FROM EE_ELEARNING");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			elearningID = reportableListObject.getValue(0);

			// set 1 for initial
			if (elearningID == null || elearningID.length() == 0) return "1";
		}
		return elearningID;
	}

	private static String getNextELearningQID(String elearningID) {
		String elearningQID = null;

		ArrayList<ReportableListObject> result = UtilDBWeb.getReportableList(
				"SELECT MAX(EE_ELEARNING_QID) + 1 FROM EE_ELEARNING_QUESTION WHERE EE_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND EE_ELEARNING_ID = ?",
				new String[]{ elearningID });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			elearningQID = reportableListObject.getValue(0);

			// set 1 for initial
			if (elearningQID == null || elearningQID.length() == 0) return "1";
		}
		return elearningQID;
	}

	private static String getNextELearningAID(String elearningID, String elearningQID) {
		String elearningAID = null;

		ArrayList<ReportableListObject> result = UtilDBWeb.getReportableList(
				"SELECT MAX(EE_ELEARNING_AID) + 1 FROM EE_ELEARNING_ANSWER WHERE EE_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND EE_ELEARNING_ID = ? AND EE_ELEARNING_QID = ?",
				new String[]{ elearningID, elearningQID });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			elearningAID = reportableListObject.getValue(0);

			// set 1 for initial
			if (elearningAID == null || elearningAID.length() == 0) return "1";
		}
		return elearningAID;
	}

	private static String getNextELearningVideoID(String elearningID) {
		String elearningVideoID = null;

		ArrayList<ReportableListObject> result = UtilDBWeb.getReportableList(
				"SELECT MAX(EE_ELEARNING_VIDEO_ID) + 1 FROM EE_ELEARNING_VIDEO WHERE EE_ELEARNING_ID = ?",
				new String[]{elearningID});
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			elearningVideoID = reportableListObject.getValue(0);

			// set 1 for initial
			if (elearningVideoID == null || elearningVideoID.length() == 0) return "1";
		}
		return elearningVideoID;
	}
	public static String add(
			UserBean userBean, String topic, String topicZh, String questionNumPerTest,
			String passGrade, String duration, String documentID, String swffileEn, String swffileZh, String[] videoPathsEng, String[] videoPathsTchi) {

		return add(userBean,topic,topicZh,questionNumPerTest,passGrade,duration ,documentID,swffileEn,swffileZh,videoPathsEng,videoPathsTchi,"","","");
	}

	public static String add(
			UserBean userBean, String topic, String topicZh, String questionNumPerTest,
			String passGrade, String duration, String documentID, String swffileEn, String swffileZh, String[] videoPathsEng, String[] videoPathsTchi,String courseDescription,String courseType,String courseCategory) {
		// get next elearning ID
		String elearningID = getNextELearningID();

		String documentsNo = "0";
		if (documentID != null && documentID.length() > 0) {
			documentsNo = "1";
		}

		// try to insert a new record
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO EE_ELEARNING (");
		sqlStr.append("EE_SITE_CODE, EE_MODULE_CODE, EE_EVENT_ID, EE_ELEARNING_ID, EE_TOPIC, EE_TOPIC_ZH, ");
		sqlStr.append("EE_QUESTION_NUM, EE_PASSGRADE, EE_DURATION, EE_DOCUMENTS_NO, ");
		sqlStr.append("EE_SWFFILE_EN, EE_SWFFILE_ZH, ");
		sqlStr.append("EE_CREATED_USER, EE_MODIFIED_USER,EE_DESCRIPTION) ");
		sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', 'education', 0, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?)");

		// insert elearning record
		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { elearningID, topic, topicZh, questionNumPerTest, passGrade, duration, documentsNo, swffileEn, swffileZh,
					userBean.getLoginID(), userBean.getLoginID(),courseDescription })) {

			// update eventID
			String eventID = EventDB.add("education", null, courseCategory,courseType, topic, null, userBean.getLoginID());
			if (eventID != null && eventID.length() > 0) {
				sqlStr.setLength(0);
				sqlStr.append("UPDATE EE_ELEARNING ");
				sqlStr.append("SET    EE_EVENT_ID = ? ");
				sqlStr.append("WHERE  EE_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND EE_ELEARNING_ID = ?");

				UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] { eventID, elearningID });
			}

			// insert document record
			if (documentID != null && documentID.length() > 0) {
				sqlStr.setLength(0);
				sqlStr.append("INSERT INTO EE_ELEARNING_DOCUMENT (");
				sqlStr.append("EE_SITE_CODE, EE_ELEARNING_ID, EE_DOCUMENT_ID, ");
				sqlStr.append("EE_CREATED_USER, EE_MODIFIED_USER) ");
				sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', ?, ?, ?, ?)");

				UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] { elearningID, documentID, userBean.getLoginID(), userBean.getLoginID() });
			}

			// insert video record (english)
			if (videoPathsEng != null && videoPathsEng.length > 0) {
				// clear all video
				sqlStr.setLength(0);
				sqlStr.append("DELETE FROM EE_ELEARNING_VIDEO ");
				sqlStr.append("WHERE EE_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND EE_ELEARNING_ID = ? ");

				UtilDBWeb.updateQueue(sqlStr.toString(), new String[] {elearningID});

				for (int i = 0; i < videoPathsEng.length; i++) {
					if (!StringUtils.isEmpty(videoPathsEng[i])) {
						sqlStr.setLength(0);
						sqlStr.append("INSERT INTO EE_ELEARNING_VIDEO (");
						sqlStr.append("EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_VIDEO_ID, ");
						sqlStr.append("EE_SWFFILE_LANG, EE_SWFFILE, ");
						sqlStr.append("EE_CREATED_USER, EE_MODIFIED_USER) ");
						sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', ?, ?, ?, ?, ?, ?)");

						UtilDBWeb.updateQueue(
							sqlStr.toString(),
							new String[] { elearningID, getNextELearningVideoID(elearningID), "e", videoPathsEng[i], userBean.getLoginID(), userBean.getLoginID() });
					}
				}
			}

			// insert video record (trad chinese)
			if (videoPathsTchi != null && videoPathsTchi.length > 0) {
				// clear all video
				sqlStr.setLength(0);
				sqlStr.append("DELETE FROM EE_ELEARNING_VIDEO ");
				sqlStr.append("WHERE EE_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND EE_ELEARNING_ID = ? ");

				UtilDBWeb.updateQueue(sqlStr.toString(), new String[] {elearningID});

				for (int i = 0; i < videoPathsTchi.length; i++) {
					if (!StringUtils.isEmpty(videoPathsTchi[i])) {
						sqlStr.setLength(0);
						sqlStr.append("INSERT INTO EE_ELEARNING_VIDEO (");
						sqlStr.append("EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_VIDEO_ID, ");
						sqlStr.append("EE_SWFFILE_LANG, EE_SWFFILE, ");
						sqlStr.append("EE_CREATED_USER, EE_MODIFIED_USER) ");
						sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', ?, ?, ?, ?, ?, ?)");

						UtilDBWeb.updateQueue(
							sqlStr.toString(),
							new String[] { elearningID, getNextELearningVideoID(elearningID), "z", videoPathsTchi[i], userBean.getLoginID(), userBean.getLoginID() });
					}
				}
			}
		}
		return elearningID;
	}

	public static boolean updateTypeCategory(UserBean userBean,String eventType, String eventCategory,String eventID){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CO_EVENT ");
		sqlStr.append("SET ");
		if ("".equals(eventType) || eventType != null) {
			sqlStr.append("CO_EVENT_TYPE=?, ");
		}
		if ("".equals(eventCategory) || eventCategory != null) {
			sqlStr.append(" CO_EVENT_CATEGORY = ?, ");
		}
		sqlStr.append(" CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER=? ");
		sqlStr.append("WHERE CO_EVENT_ID = ? ");

		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { eventCategory, eventType, userBean.getLoginID(), eventID });
	}

	public static boolean update(
			UserBean userBean, String elearningID, String topic, String topicZh, String questionNumPerTest,
			String passGrade, String duration, String swffileEn, String swffileZh, String[] videoPathsEng, String[] videoPathsTchi) {

		return update(
				userBean,elearningID,topic,topicZh,questionNumPerTest,passGrade,
				duration,swffileEn,swffileZh,videoPathsEng,videoPathsTchi,"","","");
	}

	public static boolean update(
			UserBean userBean, String elearningID, String topic, String topicZh, String questionNumPerTest,
			String passGrade, String duration, String swffileEn, String swffileZh, String[] videoPathsEng, String[] videoPathsTchi,String courseDesc,String courseType,String courseCategory) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE EE_ELEARNING ");
		sqlStr.append("SET    EE_TOPIC = ?, EE_TOPIC_ZH = ?, ");
		sqlStr.append("       EE_QUESTION_NUM = ?, EE_PASSGRADE = ?, EE_DURATION = ?, ");
		sqlStr.append("       EE_SWFFILE_EN = ?, EE_SWFFILE_ZH = ?, ");
		sqlStr.append("       EE_DESCRIPTION = ?,  ");
		sqlStr.append("       EE_MODIFIED_DATE = SYSDATE, EE_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  EE_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND EE_ELEARNING_ID = ?");

		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {topic, topicZh, questionNumPerTest, passGrade, duration, swffileEn, swffileZh,courseDesc, userBean.getLoginID(), elearningID} )) {

			if(courseType != "" || courseCategory != ""){
				ArrayList<ReportableListObject> tempLearning = null;
				tempLearning = get(elearningID);
				String eventID = null;
				if(tempLearning.size()>0){
					ReportableListObject row = (ReportableListObject) tempLearning.get(0);
					eventID = row.getFields0();
				}
				updateTypeCategory(userBean,courseType,courseCategory,eventID);
			}
			// clear all video record (english)
			sqlStr.setLength(0);
			sqlStr.append("DELETE FROM EE_ELEARNING_VIDEO ");
			sqlStr.append("WHERE EE_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND EE_ELEARNING_ID = ? AND EE_SWFFILE_LANG = 'e'");
			UtilDBWeb.updateQueue(sqlStr.toString(), new String[] {elearningID});

			// insert video record (english)
			if (videoPathsEng != null && videoPathsEng.length > 0) {
				for (int i = 0; i < videoPathsEng.length; i++) {
					if (!StringUtils.isEmpty(videoPathsEng[i])) {
						sqlStr.setLength(0);
						sqlStr.append("INSERT INTO EE_ELEARNING_VIDEO (");
						sqlStr.append("EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_VIDEO_ID, ");
						sqlStr.append("EE_SWFFILE_LANG, EE_SWFFILE, ");
						sqlStr.append("EE_CREATED_USER, EE_MODIFIED_USER) ");
						sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', ?, ?, ?, ?, ?, ?)");

						UtilDBWeb.updateQueue(
							sqlStr.toString(),
							new String[] { elearningID, getNextELearningVideoID(elearningID), "e", videoPathsEng[i], userBean.getLoginID(), userBean.getLoginID() });
					}
				}
			}

			// clear all video record (trad chinese)
			sqlStr.setLength(0);
			sqlStr.append("DELETE FROM EE_ELEARNING_VIDEO ");
			sqlStr.append("WHERE EE_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND EE_ELEARNING_ID = ? AND EE_SWFFILE_LANG = 'z'");
			UtilDBWeb.updateQueue(sqlStr.toString(), new String[] {elearningID});

			// insert video record (trad chinese)
			if (videoPathsTchi != null && videoPathsTchi.length > 0) {
				for (int i = 0; i < videoPathsTchi.length; i++) {
					if (!StringUtils.isEmpty(videoPathsTchi[i])) {
						sqlStr.setLength(0);
						sqlStr.append("INSERT INTO EE_ELEARNING_VIDEO (");
						sqlStr.append("EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_VIDEO_ID, ");
						sqlStr.append("EE_SWFFILE_LANG, EE_SWFFILE, ");
						sqlStr.append("EE_CREATED_USER, EE_MODIFIED_USER) ");
						sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', ?, ?, ?, ?, ?, ?)");

						UtilDBWeb.updateQueue(
							sqlStr.toString(),
							new String[] { elearningID, getNextELearningVideoID(elearningID), "z", videoPathsTchi[i], userBean.getLoginID(), userBean.getLoginID() });
					}
				}
			}
			return true;
		} else {
			return false;
		}
	}

	public static boolean delete(
			UserBean userBean, String elearningID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE EE_ELEARNING SET EE_ENABLED = 0, ");
		sqlStr.append("       EE_MODIFIED_DATE = SYSDATE, EE_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  EE_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND EE_ELEARNING_ID = ?");

		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { userBean.getLoginID(), elearningID } )) {

			sqlStr.setLength(0);
			sqlStr.append("UPDATE CO_EVENT ");
			sqlStr.append("SET    CO_ENABLED = 0, CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
			sqlStr.append("WHERE  CO_EVENT_ID = ?");

			UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { userBean.getLoginID(), elearningID } );

			return true;
		} else {
			return false;
		}
	}

	public static ArrayList<ReportableListObject> get(String elearningID) {
		// fetch all elearning topic
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT EE_EVENT_ID, EE_TOPIC, EE_QUESTION_NUM, EE_PASSGRADE, ");
		sqlStr.append("       EE_DOCUMENTS_NO, EE_DURATION, EE_SWFFILE_EN, EE_SWFFILE_ZH, ");
		sqlStr.append("       TO_CHAR(EE_MODIFIED_DATE, 'dd/MM/YYYY'), EE_TOPIC_ZH, EE_DESCRIPTION ");
		sqlStr.append("FROM   EE_ELEARNING ");
		sqlStr.append("WHERE  EE_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    EE_MODULE_CODE = 'education' ");
		sqlStr.append("AND    EE_ELEARNING_ID = ? ");
		sqlStr.append("AND    EE_ENABLED = 1 ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { elearningID });
	}

	public static ArrayList<ReportableListObject> getCRM(String elearningID) {

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT EE_EVENT_ID, EE_TOPIC, EE_QUESTION_NUM, EE_PASSGRADE, ");
		sqlStr.append("       EE_DOCUMENTS_NO, EE_DURATION, EE_SWFFILE_EN, EE_SWFFILE_ZH, ");
		sqlStr.append("       TO_CHAR(EE_MODIFIED_DATE, 'dd/MM/YYYY'), EE_TOPIC_ZH, EE_DESCRIPTION ");
		sqlStr.append("FROM   EE_ELEARNING ");
		sqlStr.append("WHERE  EE_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    EE_MODULE_CODE = 'lmc.crm' ");
		sqlStr.append("AND    EE_ELEARNING_ID = ? ");
		sqlStr.append("AND    EE_ENABLED = 1 ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { elearningID });
	}

	public static ArrayList<ReportableListObject> getVideoList(String elearningID) {
		// fetch all elearning topic
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT EE_ELEARNING_VIDEO_ID, EE_SWFFILE_LANG, EE_SWFFILE ");
		sqlStr.append("FROM   EE_ELEARNING_VIDEO ");
		sqlStr.append("WHERE  EE_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    EE_ELEARNING_ID = ? ");
		sqlStr.append("AND    EE_ENABLED = 1 ");
		sqlStr.append("ORDER BY	EE_ELEARNING_VIDEO_ID ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { elearningID });
	}

	public static int getELearningDocVideoNum(String elearningID, String eeSwffileLang) {
		int num = 0;

		List<String> params = new ArrayList<String>();

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT doc.NUM + video.NUM ");
		sqlStr.append("FROM   ");
		sqlStr.append("(");
		sqlStr.append("SELECT COUNT(*) NUM ");
		sqlStr.append("FROM   EE_ELEARNING_DOCUMENT ED, CO_DOCUMENT D ");
		sqlStr.append("WHERE  ED.EE_DOCUMENT_ID = D.CO_DOCUMENT_ID ");
		sqlStr.append("AND    ED.EE_ENABLED = 1 ");
		sqlStr.append("AND    ED.EE_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    ED.EE_ELEARNING_ID = ? ");
		params.add(elearningID);
		sqlStr.append("ORDER BY D.CO_DOCUMENT_ID");
		sqlStr.append(") doc, ");
		sqlStr.append("(");
		sqlStr.append("SELECT COUNT(*) NUM ");
		sqlStr.append("FROM	  EE_ELEARNING_VIDEO V ");
		sqlStr.append("WHERE  V.EE_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    V.EE_ELEARNING_ID = ? ");
		params.add(elearningID);
		if (eeSwffileLang != null) {
			sqlStr.append("AND    V.EE_SWFFILE_LANG = ? ");
			params.add(eeSwffileLang);
		}
		sqlStr.append("AND    V.EE_ENABLED = 1 ");
		sqlStr.append(") video");

		ArrayList<ReportableListObject> list = UtilDBWeb.getReportableList(sqlStr.toString(), params.toArray(new String[]{}));
		ReportableListObject row = (ReportableListObject) list.get(0);
		String numString = null;
		if (row != null) {
			numString = row.getValue(0);
			try {
				num = Integer.parseInt(numString);
			} catch (Exception e) {
			}
		}
		return num;
	}

	public static ArrayList<ReportableListObject> getList(String[] eventTypes) {
		return getList(eventTypes, null);
	}
	
	public static ArrayList<ReportableListObject> getList(String[] eventTypes, String[] eventCategories) {
		return getList(eventTypes, eventCategories, null);
	}

	public static ArrayList<ReportableListObject> getList(String[] eventTypes, String[] eventCategories, String staffCatDesc) {
		
		// fetch each question
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT EE.EE_ELEARNING_ID, EE.EE_TOPIC, ");
		sqlStr.append("       EE.EE_QUESTION_NUM, EE.EE_PASSGRADE, EE.EE_DURATION, ");
		sqlStr.append("       CE.CO_EVENT_CATEGORY, CE.CO_EVENT_TYPE, EE.EE_TOPIC_ZH, EE_BG_COLOR, EE_DESCRIPTION ");
		sqlStr.append("FROM   EE_ELEARNING EE, CO_EVENT CE ");
		sqlStr.append("WHERE  CE.CO_MODULE_CODE = 'education' ");
		if (eventTypes != null && eventTypes.length > 0) {
			sqlStr.append("AND    CE.CO_EVENT_TYPE IN ('" + StringUtils.join(eventTypes, "', '") + "') ");
		}
		if (eventCategories != null && eventCategories.length > 0) {
			sqlStr.append("AND    CE.CO_EVENT_CATEGORY IN ('" + StringUtils.join(eventCategories, "', '") + "') ");
		}
		sqlStr.append("AND    EE.EE_EVENT_ID = CE.CO_EVENT_ID ");
		if (staffCatDesc != null) {
			sqlStr.append("AND    EE.EE_ELEARNING_ID IN ( ");
			sqlStr.append("SELECT E.EE_ELEARNING_ID ");
			sqlStr.append("FROM EE_ELEARNING E ");
			sqlStr.append("WHERE EE_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
			sqlStr.append("AND INSTR(EE_REQUIRED_STAFFCAT,  ");
			sqlStr.append("( ");
			sqlStr.append("SELECT CO_EVENT_ID FROM CO_EVENT ");
			sqlStr.append("WHERE CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
			sqlStr.append("AND CO_MODULE_CODE = 'staffCat' ");
			sqlStr.append("AND CO_EVENT_DESC = '" + staffCatDesc + "' ");
			sqlStr.append(") ");
			sqlStr.append(") > 0 ");
			sqlStr.append(") ");
		}
		sqlStr.append("AND    EE.EE_ENABLED = 1 ");
		sqlStr.append("ORDER BY CE.CO_EVENT_CATEGORY, CE.CO_EVENT_TYPE, EE.EE_SORT_ORDER, EE.EE_TOPIC");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList<ReportableListObject> getRequiredList(String[] eventTypes, String[] eventCategories, String staffId) {
		// fetch each question
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT EE.EE_ELEARNING_ID, EE.EE_TOPIC, ");
		sqlStr.append("       EE.EE_QUESTION_NUM, EE.EE_PASSGRADE, EE.EE_DURATION, ");
		sqlStr.append("       CE.CO_EVENT_CATEGORY, CE.CO_EVENT_TYPE, EE.EE_TOPIC_ZH, EE_BG_COLOR, EE_DESCRIPTION ");
		sqlStr.append("FROM   EE_ELEARNING EE, CO_EVENT CE ");
		sqlStr.append("WHERE  CE.CO_MODULE_CODE = 'education' ");
		if (eventTypes != null && eventTypes.length > 0) {
			sqlStr.append("AND    CE.CO_EVENT_TYPE IN ('" + StringUtils.join(eventTypes, "', '") + "') ");
		}
		if (eventCategories != null && eventCategories.length > 0) {
			sqlStr.append("AND    CE.CO_EVENT_CATEGORY IN ('" + StringUtils.join(eventCategories, "', '") + "') ");
		}
		sqlStr.append("AND    EE.EE_EVENT_ID = CE.CO_EVENT_ID ");
		sqlStr.append("AND    EE.EE_ENABLED = 1 ");
		
		if (staffId != null) {
			sqlStr.append("AND    CE.CO_EVENT_ID IN (");
			List<String> requiredList = EnrollmentDB.getCompulsoryList(staffId, String.valueOf(DateTimeUtil.getCurrentYear()));
			sqlStr.append(requiredList.isEmpty() ? "-1" : StringUtils.join(requiredList, ","));
			sqlStr.append(") ");
			
			String requiredListStr = StringUtils.join(requiredList, ",");
			System.out.println("[ELearning] getRequiredList staffId="+staffId+", requiredListStr="+requiredListStr);
		}
		
		sqlStr.append("ORDER BY CE.CO_EVENT_CATEGORY, CE.CO_EVENT_TYPE, EE.EE_SORT_ORDER, EE.EE_TOPIC");
		
		//System.out.println("[ELearning] getRequiredList sqlStr="+sqlStr);
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static boolean isRequiredCourse(String staffCatDesc, String elearningID) {
		boolean ret = false;
		StringBuffer sqlStr = new StringBuffer();

		
		sqlStr.append("SELECT EE_REQUIRED_STAFFCAT ");
		sqlStr.append("FROM EE_ELEARNING ");
	    sqlStr.append("WHERE EE_SITE_CODE = ? ");
	    sqlStr.append("AND ee_elearning_id = ? ");
	    sqlStr.append("and instr(ee_required_staffcat, ");	
	    sqlStr.append("( ");
	    sqlStr.append("select co_event_id from co_event ");
	    sqlStr.append("where co_site_code = ? ");
	    sqlStr.append("and co_module_code = ? ");
	    sqlStr.append("and co_event_desc = ? ");
	    sqlStr.append(") ");
	    sqlStr.append(") > 0");
	    
	    ArrayList<ReportableListObject> result = 
	    		UtilDBWeb.getReportableList(sqlStr.toString(), 
	    				new String[]{ConstantsServerSide.SITE_CODE, elearningID, 
	    			ConstantsServerSide.SITE_CODE, "staffCat", staffCatDesc});
	    
	   if (!result.isEmpty()) {
		   ret = true;
	   }
	   return ret;
	}
	
	public static boolean isNotAllowQuit(String eventID, String elearningID, String userID, int maxEntry,
			String Year) {
		boolean isAttended = isAttendedTestCurrentYr(eventID, elearningID, userID);
		int entryCount =  getTestEntryCount(eventID, userID);
		if (entryCount > maxEntry && !isAttended) {
			   return true;
		} else {
			return false;
		}
	}
	
	public static boolean isAttendedTestCurrentYr(String eventID, String elearningID, String userID){
		StringBuffer sqlStr = new StringBuffer();

		
		sqlStr.append("SELECT COUNT(1) ");
		sqlStr.append("FROM EE_ELEARNING_STAFF ");
		sqlStr.append(" WHERE EE_MODULE_CODE = 'education' ");
		sqlStr.append(" AND EE_EVENT_ID = ? ");
		sqlStr.append(" AND EE_ELEARNING_ID = ? ");
		sqlStr.append("  AND EE_CREATED_DATE > SYSDATE - 365 ");
		sqlStr.append(" AND EE_USER_ID = ? ");
		sqlStr.append(" AND EE_ENABLED = 1 ");
		
	    ArrayList<ReportableListObject> result = 
    		UtilDBWeb.getReportableList(sqlStr.toString(), 
    				new String[]{eventID, elearningID, userID});
	    if (!result.isEmpty()) {
			   ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			    if (Integer.parseInt(reportableListObject.getValue(0)) > 0 ){
			    	return true;
			    } else {
			    	return false;
			    }
		   } else {
			   return false;
		   }
	    
	}
	
	public static int getTestEntryCount(String eventID, String userID) {
		int ret = 0;
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT COUNT(1) FROM CO_ENROLLMENT ");
		sqlStr.append("WHERE CO_EVENT_ID = ? ");
	    sqlStr.append("AND CO_USER_ID = ? ");
	    sqlStr.append("AND CO_MODULE_CODE = 'education' ");
	    sqlStr.append("AND CO_USER_TYPE = 'CIS' ");
	    sqlStr.append("AND CO_ATTEND_DATE > sysdate - 365 ");
	    sqlStr.append("AND CO_ENABLED = 1 ");
	    
	    ArrayList<ReportableListObject> result = 
    		UtilDBWeb.getReportableList(sqlStr.toString(), 
    				new String[]{eventID, userID});
    
	   if (!result.isEmpty()) {
		   ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
		   ret = Integer.parseInt(reportableListObject.getValue(0));
		   
		   return ret;
	   } else {
		   return 0;
	   }
	}

	public static ArrayList<ReportableListObject> getList() {
		// fetch each question
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT EE.EE_ELEARNING_ID, EE.EE_TOPIC, ");
		sqlStr.append("       EE.EE_QUESTION_NUM, EE.EE_PASSGRADE, EE.EE_DURATION, ");
		sqlStr.append("       CE.CO_EVENT_CATEGORY, CE.CO_EVENT_TYPE, EE.EE_TOPIC_ZH, EE_BG_COLOR, EE_DESCRIPTION ");
		sqlStr.append("FROM   EE_ELEARNING EE, CO_EVENT CE ");
		sqlStr.append("WHERE  CE.CO_MODULE_CODE = 'education' ");
		sqlStr.append("AND    CE.CO_EVENT_TYPE = 'online' ");
		sqlStr.append("AND    EE.EE_EVENT_ID = CE.CO_EVENT_ID ");
		sqlStr.append("AND    EE.EE_ENABLED = 1 ");
		sqlStr.append("ORDER BY CE.CO_EVENT_CATEGORY, CE.CO_EVENT_TYPE, EE.EE_SORT_ORDER, EE.EE_TOPIC");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static String addQuestion(UserBean userBean, String elearningID, String question) {
		// get next elearning QID
		String elearningQID = getNextELearningQID(elearningID);

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO EE_ELEARNING_QUESTION (");
		sqlStr.append("EE_SITE_CODE, EE_ELEARNING_ID, ");
		sqlStr.append("EE_ELEARNING_QID, EE_QUESTION, EE_CREATED_USER, EE_MODIFIED_USER) ");
		sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', ?, ?, ?, ?, ?)");

		if (!UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {elearningID, elearningQID, question,
					userBean.getLoginID(), userBean.getLoginID()} )) {
			elearningQID = null;
		}
		return elearningQID;
	}

	public static boolean updateQuestion(UserBean userBean, String elearningID,
			String elearningQID, String question) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE EE_ELEARNING_QUESTION ");
		sqlStr.append("SET    EE_QUESTION = ?, EE_MODIFIED_DATE = SYSDATE, EE_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  EE_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND EE_ELEARNING_ID = ? AND EE_ELEARNING_QID = ?");

		return UtilDBWeb.updateQueue(
			sqlStr.toString(),
			new String[] {question, userBean.getLoginID(), elearningID, elearningQID} );
	}

	public static boolean deleteQuestion(UserBean userBean, String elearningID,
			String elearningQID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE EE_ELEARNING_QUESTION ");
		sqlStr.append("SET    EE_ENABLED = 0, EE_MODIFIED_DATE = SYSDATE, EE_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  EE_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND EE_ELEARNING_ID = ? AND EE_ELEARNING_QID = ?");

		if (UtilDBWeb.updateQueue(
			sqlStr.toString(),
			new String[] { userBean.getLoginID(), elearningID, elearningQID} )) {

			// delete the answer too
			sqlStr.setLength(0);
			sqlStr.append("UPDATE EE_ELEARNING_ANSWER SET EE_ENABLED = 0, EE_MODIFIED_DATE = SYSDATE, EE_MODIFIED_USER = ? ");
			sqlStr.append("WHERE EE_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND EE_ELEARNING_ID = ? AND EE_ELEARNING_QID = ?");

			UtilDBWeb.updateQueue(sqlStr.toString(), new String[] { userBean.getLoginID(), elearningQID, elearningQID });

			return true;
		} else {
			return false;
		}
	}

	public static ArrayList<ReportableListObject> getAllQuestions(String elearningID) {
		// fetch all question
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT Q.EE_ELEARNING_QID, Q.EE_QUESTION, A.EE_ELEARNING_AID, EE_ANSWER, A.EE_CORRECT_ANS ");
		sqlStr.append("FROM   EE_ELEARNING_QUESTION Q, EE_ELEARNING_ANSWER A ");
		sqlStr.append("WHERE  Q.EE_ELEARNING_ID = A.EE_ELEARNING_ID ");
		sqlStr.append("AND    Q.EE_ELEARNING_QID = A.EE_ELEARNING_QID ");
		sqlStr.append("AND    Q.EE_ENABLED = A.EE_ENABLED ");
		sqlStr.append("AND    Q.EE_ENABLED = 1 ");
		sqlStr.append("AND    Q.EE_ELEARNING_ID = ? ");
		sqlStr.append("ORDER BY Q.EE_ELEARNING_QID, A.EE_ELEARNING_AID");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { elearningID });
	}

	public static ArrayList<ReportableListObject> getQuestion(String elearningID, String elearningQID) {
		// fetch each question
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT E.EE_TOPIC, E.EE_QUESTION_NUM, E.EE_PASSGRADE, ");
		sqlStr.append("       E.EE_DURATION, Q.EE_QUESTION, TO_CHAR(E.EE_MODIFIED_DATE, 'dd/MM/YYYY') ");
		sqlStr.append("FROM   EE_ELEARNING_QUESTION Q, EE_ELEARNING E ");
		sqlStr.append("WHERE  Q.EE_ELEARNING_ID = E.EE_ELEARNING_ID ");
		sqlStr.append("AND    Q.EE_ELEARNING_ID = ? ");
		sqlStr.append("AND    Q.EE_ELEARNING_QID = ? ");
		sqlStr.append("AND    Q.EE_ENABLED = 1 ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { elearningID, elearningQID });
	}

	public static ArrayList<ReportableListObject> getQuestions(String elearningID) {
		// fetch each question
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT EE_ELEARNING_QID, EE_QUESTION ");
		sqlStr.append("FROM   EE_ELEARNING_QUESTION ");
		sqlStr.append("WHERE  EE_ENABLED = 1 ");
		sqlStr.append("AND    EE_ELEARNING_ID = ? ");
		sqlStr.append("ORDER BY EE_ELEARNING_QID");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { elearningID });
	}

	public static String addAnswer(UserBean userBean, String elearningID, String elearningQID, String answer, String correct_answer) {
		// get next elearning ID
		String elearningAID = getNextELearningAID(elearningID, elearningQID);

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO EE_ELEARNING_ANSWER (EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, EE_ELEARNING_AID, EE_ANSWER, EE_CORRECT_ANS, EE_CREATED_USER, EE_MODIFIED_USER) ");
		sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', ?, ?, ?, ?, ?, ?, ?)");

		if (!UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { elearningID, elearningQID, elearningAID, answer, correct_answer,
					userBean.getLoginID(), userBean.getLoginID() })) {
			elearningQID = null;
		}
		return elearningQID;
	}

	public static boolean updateAnswer(UserBean userBean, String elearningID,
			String elearningQID, String elearningAID, String answer, String correct_answer) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE EE_ELEARNING_ANSWER ");
		sqlStr.append("SET    EE_ANSWER = ?, EE_CORRECT_ANS = ?, EE_MODIFIED_DATE = SYSDATE, EE_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  EE_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND EE_ELEARNING_ID = ? AND EE_ELEARNING_QID = ? AND EE_ELEARNING_AID = ?");

		return UtilDBWeb.updateQueue(
			sqlStr.toString(),
			new String[] { answer, correct_answer, userBean.getLoginID(), elearningID, elearningQID, elearningAID });
	}

	public static boolean deleteAnswer(UserBean userBean, String elearningID,
			String elearningQID, String elearningAID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE EE_ELEARNING_ANSWER ");
		sqlStr.append("SET    EE_ENABLED = 0, EE_MODIFIED_DATE = SYSDATE, EE_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  EE_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND EE_ELEARNING_ID = ? AND EE_ELEARNING_QID = ? AND EE_ELEARNING_AID = ?");

		return UtilDBWeb.updateQueue(
			sqlStr.toString(),
			new String[] { userBean.getLoginID(), elearningID, elearningQID, elearningAID });
	}

	public static ArrayList<ReportableListObject> getAnswers(String elearningID, String elearningQID) {
		// fetch each answer
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT EE_ELEARNING_AID, EE_ANSWER, EE_CORRECT_ANS, ");
		sqlStr.append("       TO_CHAR(EE_MODIFIED_DATE, 'dd/MM/YYYY'), EE_ENABLED ");
		sqlStr.append("FROM   EE_ELEARNING_ANSWER ");
		sqlStr.append("WHERE  EE_ENABLED = 1 ");
		sqlStr.append("AND    EE_ELEARNING_ID = ? ");
		sqlStr.append("AND    EE_ELEARNING_QID = ? ");
		sqlStr.append("ORDER BY EE_ELEARNING_AID");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { elearningID, elearningQID });
	}

	public static ArrayList<ReportableListObject> getAnswer(String elearningID, String elearningQID, String elearningAID) {
		// fetch each answer
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT EE_ELEARNING_AID, EE_ANSWER, EE_CORRECT_ANS, ");
		sqlStr.append("       TO_CHAR(EE_MODIFIED_DATE, 'dd/MM/YYYY'), EE_ENABLED ");
		sqlStr.append("FROM   EE_ELEARNING_ANSWER ");
		sqlStr.append("WHERE  EE_ENABLED = 1 ");
		sqlStr.append("AND    EE_ELEARNING_ID = ? ");
		sqlStr.append("AND    EE_ELEARNING_QID = ? ");
		sqlStr.append("AND    EE_ELEARNING_AID = ? ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { elearningID, elearningQID, elearningAID });
	}

	public static boolean addStaffResult(
			UserBean userBean, String eventID, String elearningID, String enrollID,
			String correctAnswer) {
		// try to insert a new record
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO EE_ELEARNING_STAFF (");
		sqlStr.append("EE_SITE_CODE, EE_MODULE_CODE, EE_EVENT_ID, EE_ENROLL_ID, EE_ELEARNING_ID, ");
		sqlStr.append("EE_CORRECT_ANS, EE_USER_TYPE, EE_USER_ID, ");
		sqlStr.append("EE_CREATED_USER, EE_MODIFIED_USER) ");
		sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', 'education', ?, ?, ?, ");
		sqlStr.append("?, 'staff', ?, ?, ?)");

		// insert elearning record
		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { eventID, enrollID, elearningID, correctAnswer,
					userBean.getStaffID(), userBean.getLoginID(), userBean.getLoginID() });
	}
	
	public static boolean addStaffResult(
			UserBean userBean, String eventID, String elearningID, String enrollID,
			String correctAnswer,String userID) {
		// try to insert a new record
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO EE_ELEARNING_STAFF (");
		sqlStr.append("EE_SITE_CODE, EE_MODULE_CODE, EE_EVENT_ID, EE_ENROLL_ID, EE_ELEARNING_ID, ");
		sqlStr.append("EE_CORRECT_ANS, EE_USER_TYPE, EE_USER_ID, ");
		sqlStr.append("EE_CREATED_USER, EE_MODIFIED_USER) ");
		sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', 'education', ?, ?, ?, ");
		sqlStr.append("?, 'staff', ?, ?, ?)");

		// insert elearning record
		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { eventID, enrollID, elearningID, correctAnswer,
					userID, userID, userID });
	}

	public static boolean addLMCClientResult(
			UserBean userBean, String eventID, String elearningID, String enrollID,
			String correctAnswer) {
		// try to insert a new record
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO EE_ELEARNING_STAFF (");
		sqlStr.append("EE_SITE_CODE, EE_MODULE_CODE, EE_EVENT_ID, EE_ENROLL_ID, EE_ELEARNING_ID, ");
		sqlStr.append("EE_CORRECT_ANS, EE_USER_TYPE, EE_USER_ID, ");
		sqlStr.append("EE_CREATED_USER, EE_MODIFIED_USER) ");
		sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', 'lmc.crm', ?, ?, ?, ");
		sqlStr.append("?, 'guest', ?, ?, ?)");

		// insert elearning record
		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { eventID, enrollID, elearningID, correctAnswer,
					CRMClientDB.getClientID(userBean.getUserName()), userBean.getLoginID(), userBean.getLoginID() });
	}


	public static boolean addStaffResultAnswer(
			UserBean userBean, String eventID, String elearningID, String enrollID,
			String elearningQID, String elearningAID, String correctAnswer) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO EE_ELEARNING_STAFF_ANSWER (");
		sqlStr.append("EE_SITE_CODE, EE_MODULE_CODE, EE_EVENT_ID, EE_ENROLL_ID, EE_ELEARNING_ID, ");
		sqlStr.append("EE_ELEARNING_QID, EE_ELEARNING_AID, EE_CORRECT_ANS, ");
		sqlStr.append("EE_USER_TYPE, EE_USER_ID, ");
		sqlStr.append("EE_CREATED_USER, EE_MODIFIED_USER) ");
		sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', 'education', ?, ?, ?, ");
		sqlStr.append("?, ?, ?, ");
		sqlStr.append("'staff', ?, ?, ?)");

		// insert elearning record
		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { eventID, enrollID, elearningID,
					elearningQID, elearningAID, correctAnswer,
					userBean.getStaffID(), userBean.getLoginID(), userBean.getLoginID() });
	}
	
	public static boolean addStaffResultAnswer(
			UserBean userBean, String eventID, String elearningID, String enrollID,
			String elearningQID, String elearningAID, String correctAnswer,String userID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO EE_ELEARNING_STAFF_ANSWER (");
		sqlStr.append("EE_SITE_CODE, EE_MODULE_CODE, EE_EVENT_ID, EE_ENROLL_ID, EE_ELEARNING_ID, ");
		sqlStr.append("EE_ELEARNING_QID, EE_ELEARNING_AID, EE_CORRECT_ANS, ");
		sqlStr.append("EE_USER_TYPE, EE_USER_ID, ");
		sqlStr.append("EE_CREATED_USER, EE_MODIFIED_USER) ");
		sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', 'education', ?, ?, ?, ");
		sqlStr.append("?, ?, ?, ");
		sqlStr.append("'staff', ?, ?, ?)");

		// insert elearning record
		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { eventID, enrollID, elearningID,
					elearningQID, elearningAID, correctAnswer,
					userID, userID, userID });
	}

	public static boolean addLMCClientResultAnswer(
			UserBean userBean, String eventID, String elearningID, String enrollID,
			String elearningQID, String elearningAID, String correctAnswer) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO EE_ELEARNING_STAFF_ANSWER (");
		sqlStr.append("EE_SITE_CODE, EE_MODULE_CODE, EE_EVENT_ID, EE_ENROLL_ID, EE_ELEARNING_ID, ");
		sqlStr.append("EE_ELEARNING_QID, EE_ELEARNING_AID, EE_CORRECT_ANS, ");
		sqlStr.append("EE_USER_TYPE, EE_USER_ID, ");
		sqlStr.append("EE_CREATED_USER, EE_MODIFIED_USER) ");
		sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', 'lmc.crm', ?, ?, ?, ");
		sqlStr.append("?, ?, ?, ");
		sqlStr.append("'guest', ?, ?, ?)");

		// insert elearning record
		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { eventID, enrollID, elearningID,
					elearningQID, elearningAID, correctAnswer,
					CRMClientDB.getClientID(userBean.getUserName()), userBean.getLoginID(), userBean.getLoginID() });
	}


	public static ArrayList<ReportableListObject> getStaffResult(String eventID, String elearningID, String enrollID, String userType, String userID) {
		// fetch staff answer
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT S.CO_STAFFNAME, D.CO_DEPARTMENT_DESC, EL.EE_TOPIC, EL.EE_QUESTION_NUM, EL.EE_PASSGRADE, ES.EE_CORRECT_ANS ");
		sqlStr.append("FROM   EE_ELEARNING_STAFF ES, EE_ELEARNING EL, CO_STAFFS S, CO_DEPARTMENTS D ");
		sqlStr.append("WHERE  ES.EE_SITE_CODE = EL.EE_SITE_CODE ");
		sqlStr.append("AND    ES.EE_MODULE_CODE = EL.EE_MODULE_CODE ");
		sqlStr.append("AND    ES.EE_EVENT_ID = EL.EE_EVENT_ID ");
		sqlStr.append("AND    ES.EE_ELEARNING_ID = EL.EE_ELEARNING_ID ");
		sqlStr.append("AND    ES.EE_USER_ID = S.CO_STAFF_ID ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
		sqlStr.append("AND    ES.EE_ENABLED = 1 ");
		sqlStr.append("AND    ES.EE_EVENT_ID = ? ");
		sqlStr.append("AND    ES.EE_ELEARNING_ID = ? ");
		sqlStr.append("AND    ES.EE_ENROLL_ID = ? ");
		sqlStr.append("AND    ES.EE_USER_TYPE = ? ");
		sqlStr.append("AND    ES.EE_USER_ID = ? ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { eventID, elearningID, enrollID, userType, userID });
	}

	public static ArrayList<ReportableListObject> getCRMResult(String eventID, String elearningID, String enrollID, String userType, String userID) {
		// fetch staff answer
		StringBuffer sqlStr = new StringBuffer();
		 sqlStr.append(" SELECT C.CRM_LASTNAME||',' ||C.CRM_FIRSTNAME,NULL,EL.EE_TOPIC, EL.EE_QUESTION_NUM, EL.EE_PASSGRADE, ES.EE_CORRECT_ANS ");
		 sqlStr.append("FROM   EE_ELEARNING_STAFF ES, EE_ELEARNING EL,CRM_CLIENTS C ");
		 sqlStr.append("WHERE  ES.EE_SITE_CODE = EL.EE_SITE_CODE ");
		 sqlStr.append("AND    ES.EE_MODULE_CODE = EL.EE_MODULE_CODE ");
		 sqlStr.append("AND    ES.EE_EVENT_ID = EL.EE_EVENT_ID ");
		 sqlStr.append("AND    ES.EE_ELEARNING_ID = EL.EE_ELEARNING_ID ");
		 sqlStr.append("AND    ES.EE_ENABLED = 1 ");
		 sqlStr.append("AND    ES.EE_EVENT_ID = ? ");
		 sqlStr.append("AND    ES.EE_ELEARNING_ID = ? ");
		 sqlStr.append("AND    ES.EE_ENROLL_ID = ? ");
		 sqlStr.append("AND    ES.EE_USER_TYPE = ? ");
		 sqlStr.append("AND    ES.EE_USER_ID = ? ");
		 sqlStr.append("AND   ES.EE_USER_ID = C.CRM_USERNAME ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { eventID, elearningID, enrollID, userType, userID });
	}

	public static ArrayList<ReportableListObject> getStaffResultAnswer(String eventID, String elearningID, String enrollID, String userType, String userID) {
		// fetch staff answer
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT EE_ELEARNING_ID, EE_ELEARNING_QID, EE_ELEARNING_AID, EE_CORRECT_ANS ");
		sqlStr.append("FROM   EE_ELEARNING_STAFF_ANSWER ");
		sqlStr.append("WHERE  EE_ENABLED = 1 ");
		sqlStr.append("AND    EE_EVENT_ID = ? ");
		sqlStr.append("AND    EE_ELEARNING_ID = ? ");
		sqlStr.append("AND    EE_ENROLL_ID = ? ");
		sqlStr.append("AND    EE_USER_TYPE = ? ");
		sqlStr.append("AND    EE_USER_ID = ? ");
		sqlStr.append("ORDER BY EE_ELEARNING_QID, EE_ELEARNING_AID");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { eventID, elearningID, enrollID, userType, userID });
	}

	public static boolean addDocument(
			UserBean userBean, String elearningID, String documentID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 FROM EE_ELEARNING_DOCUMENT WHERE EE_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND EE_ELEARNING_ID = ? AND EE_DOCUMENT_ID = ?");

		if (UtilDBWeb.isExist(sqlStr.toString(), new String[] { elearningID, documentID })) {
			sqlStr.setLength(0);
			sqlStr.append("UPDATE EE_ELEARNING_DOCUMENT SET EE_ENABLED = 1, ");
			sqlStr.append("       EE_MODIFIED_DATE = SYSDATE, EE_MODIFIED_USER = ? ");
			sqlStr.append("WHERE  EE_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND EE_ELEARNING_ID = ? AND EE_DOCUMENT_ID = ?");

			UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { userBean.getLoginID(), elearningID, documentID} );
		} else {
			sqlStr.setLength(0);
			sqlStr.append("INSERT INTO EE_ELEARNING_DOCUMENT (");
			sqlStr.append("EE_SITE_CODE, EE_ELEARNING_ID, EE_DOCUMENT_ID, ");
			sqlStr.append("EE_CREATED_USER, EE_MODIFIED_USER) ");
			sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', ?, ?, ?, ?)");

			UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { elearningID, documentID, userBean.getLoginID(), userBean.getLoginID() });
		}

		sqlStr.setLength(0);
		sqlStr.append("UPDATE EE_ELEARNING ");
		sqlStr.append("SET    EE_DOCUMENTS_NO = ");
		sqlStr.append("(SELECT COUNT(1) FROM EE_ELEARNING_DOCUMENT WHERE EE_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND EE_ELEARNING_ID = ? AND EE_ENABLED = 1) ");
		sqlStr.append("WHERE  EE_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND EE_ELEARNING_ID = ?");

		return UtilDBWeb.updateQueue(
			sqlStr.toString(),
			new String[] { elearningID, elearningID });
	}

	public static boolean deleteDocument(
			UserBean userBean, String elearningID, String documentID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE EE_ELEARNING_DOCUMENT ");
		sqlStr.append("SET    EE_ENABLED = 0, EE_MODIFIED_DATE = SYSDATE, EE_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  EE_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND EE_ELEARNING_ID = ? AND EE_DOCUMENT_ID = ?");

		UtilDBWeb.updateQueue(
			sqlStr.toString(),
			new String[] { userBean.getLoginID(), elearningID, documentID });

		sqlStr.setLength(0);
		sqlStr.append("UPDATE EE_ELEARNING ");
		sqlStr.append("SET EE_DOCUMENTS_NO = ");
		sqlStr.append("(SELECT COUNT(1) FROM EE_ELEARNING_DOCUMENT WHERE EE_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND EE_ELEARNING_ID = ? AND EE_ENABLED = 1) ");
		sqlStr.append("WHERE  EE_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND EE_ELEARNING_ID = ?");

		return UtilDBWeb.updateQueue(
			sqlStr.toString(),
			new String[] { elearningID, elearningID });
	}

	public static ArrayList<ReportableListObject> getDocuments(String elearningID) {
		// fetch document
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ED.EE_DOCUMENT_ID, D.CO_DESCRIPTION ");
		sqlStr.append("FROM   EE_ELEARNING_DOCUMENT ED, CO_DOCUMENT D ");
		sqlStr.append("WHERE  ED.EE_DOCUMENT_ID = D.CO_DOCUMENT_ID ");
		sqlStr.append("AND    ED.EE_ENABLED = 1 ");
		sqlStr.append("AND    ED.EE_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    ED.EE_ELEARNING_ID = ? ");
		sqlStr.append("ORDER BY D.CO_DESCRIPTION");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { elearningID });
	}

	public static ArrayList<ReportableListObject> getCourse(String courseCategory, String eventType) {
		// fetch each question
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT C.CO_EVENT_ID, C.CO_EVENT_DESC, C.CO_EVENT_SHORT_DESC ");
		sqlStr.append("FROM   CO_EVENT C ");
		sqlStr.append("WHERE  C.CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		if (courseCategory != null && courseCategory.length() > 0) {
			sqlStr.append("AND    C.CO_EVENT_CATEGORY = '");
			sqlStr.append(courseCategory);
			sqlStr.append("' ");
		}
		if (eventType != null && eventType.length() > 0) {
			sqlStr.append("AND    C.CO_EVENT_TYPE = '");
			sqlStr.append(eventType);
			sqlStr.append("' ");
		}

		sqlStr.append("AND    C.CO_MODULE_CODE = 'education' ");
		sqlStr.append("AND    C.CO_ENABLED = 1");
		sqlStr.append("ORDER BY C.CO_EVENT_DESC");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList<ReportableListObject> getLesson(String courseCategory) {
		return getLesson(courseCategory, null);
	}

	public static ArrayList<ReportableListObject> getLesson(String courseCategory, String eventType) {
		// fetch each question
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT EE.EE_ELEARNING_ID, EE.EE_TOPIC, ");
		sqlStr.append("       EE.EE_PASSGRADE, EE.EE_DURATION ");
		sqlStr.append("FROM   EE_ELEARNING EE, CO_EVENT C ");
		sqlStr.append("WHERE  EE.EE_SITE_CODE = C.CO_SITE_CODE ");
		sqlStr.append("AND    EE.EE_MODULE_CODE = C.CO_MODULE_CODE ");
		sqlStr.append("AND    EE.EE_EVENT_ID = C.CO_EVENT_ID ");
		if (courseCategory != null && courseCategory.length() > 0) {
			sqlStr.append("AND    CO_EVENT_CATEGORY = '");
			sqlStr.append(courseCategory);
			sqlStr.append("' ");
		}
		if (eventType != null && eventType.length() > 0) {
			sqlStr.append("AND    CO_EVENT_TYPE = '");
			sqlStr.append(eventType);
			sqlStr.append("' ");
		}

		sqlStr.append("AND    EE.EE_MODULE_CODE = 'education' ");
		sqlStr.append("AND    EE.EE_ENABLED = 1");
		sqlStr.append("ORDER BY EE.EE_TOPIC");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList<ReportableListObject> getInservice(String moduleCode, String category) {
		// fetch each question
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT EE.EE_ELEARNING_ID, EE.EE_TOPIC, ");
		sqlStr.append("       EE.EE_PASSGRADE, EE.EE_DURATION ");
		sqlStr.append("FROM   EE_ELEARNING EE, CO_EVENT C ");
		sqlStr.append("WHERE  EE.EE_SITE_CODE = C.CO_SITE_CODE ");
		sqlStr.append("AND    EE.EE_MODULE_CODE = C.CO_MODULE_CODE ");
		sqlStr.append("AND    EE.EE_EVENT_ID = C.CO_EVENT_ID ");
		sqlStr.append("AND    EE.EE_MODULE_CODE = ? ");
		sqlStr.append("AND    C.CO_EVENT_CATEGORY = ? ");
		sqlStr.append("AND    EE.EE_ENABLED = 1 ");
		sqlStr.append("ORDER BY EE.EE_TOPIC ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { moduleCode, category });
	}

	public static ArrayList<ReportableListObject> getElearningEvent(String eventType) {
		List<String> paraList = new ArrayList<String>();

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT EE.EE_EVENT_ID, EE.EE_ELEARNING_ID, EE.EE_TOPIC ");
		sqlStr.append("FROM   EE_ELEARNING EE, CO_EVENT CE ");
		sqlStr.append("WHERE  CE.CO_MODULE_CODE = 'education' ");
		if (eventType != null) {
			sqlStr.append("AND    CE.CO_EVENT_TYPE = ? ");
			paraList.add(eventType);
		}
		sqlStr.append("AND    EE.EE_EVENT_ID = CE.CO_EVENT_ID ");
		sqlStr.append("AND    EE.EE_ENABLED = 1 ");
		sqlStr.append("ORDER BY CE.CO_EVENT_CATEGORY, CE.CO_EVENT_TYPE, EE.EE_TOPIC");

		return UtilDBWeb.getReportableList(sqlStr.toString(), paraList.toArray(new String[]{}));
	}

	public static ArrayList<ReportableListObject> getElearning(String elearningID) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT 	EE_SITE_CODE, ");
		sqlStr.append("			EE_MODULE_CODE, ");
		sqlStr.append("			EE_EVENT_ID, ");
		sqlStr.append("			EE_ELEARNING_ID, ");
		sqlStr.append("			EE_TOPIC, ");
		sqlStr.append("			EE_QUESTION_NUM, ");
		sqlStr.append("			EE_PASSGRADE, ");
		sqlStr.append("			EE_DURATION, ");
		sqlStr.append("			EE_DOCUMENTS_NO, ");
		sqlStr.append("			EE_SWFFILE_EN, ");
		sqlStr.append("			EE_SWFFILE_ZH, ");
		sqlStr.append("			EE_CREATED_DATE, ");
		sqlStr.append("			EE_CREATED_USER, ");
		sqlStr.append("			EE_MODIFIED_DATE, ");
		sqlStr.append("			EE_MODIFIED_USER, ");
		sqlStr.append("			EE_ENABLED ");
		sqlStr.append("FROM 	EE_ELEARNING ");
		sqlStr.append("WHERE 	EE_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND		EE_ELEARNING_ID = ? ");
		sqlStr.append("AND 		EE_ENABLED = 1 ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] {elearningID});
	}

	public static ArrayList<ReportableListObject> getElearningTestEnrolledUser(String eventID, String elearningID,
			String dateFrom, String dateTo) {
		StringBuffer sqlStr = new StringBuffer();
		List<String> params = new ArrayList<String>();

		sqlStr.append("SELECT 	EE_USER_ID ");
		sqlStr.append("FROM 	EE_ELEARNING_STAFF ");
		sqlStr.append("WHERE 	EE_SITE_CODE = ? ");
		params.add(ConstantsServerSide.SITE_CODE);
		sqlStr.append("AND		EE_MODULE_CODE = ? ");
		params.add("education");
		sqlStr.append("AND		EE_EVENT_ID = ? ");
		params.add(eventID);
		sqlStr.append("AND		EE_ELEARNING_ID = ? ");
		params.add(elearningID);
		sqlStr.append("AND 		EE_ENABLED = 1 ");
	    if (dateFrom != null) {
	    	sqlStr.append("	AND 	EE_CREATED_DATE >= TO_DATE(?, 'DD/MM/YYYY') ");
	    	params.add(dateFrom);
	    }
	    if (dateTo != null) {
	    	sqlStr.append("	AND 	EE_CREATED_DATE <= TO_DATE(?, 'DD/MM/YYYY') ");
	    	params.add(dateTo);
	    }

		return UtilDBWeb.getReportableList(sqlStr.toString(), params.toArray(new String[]{}));
	}

	public static ArrayList<ReportableListObject> getElearningTestEnrolledUniqueUser(String eventID, String elearningID,
			String dateFrom, String dateTo) {
		StringBuffer sqlStr = new StringBuffer();
		List<String> params = new ArrayList<String>();

		sqlStr.append("SELECT   DISTINCT(EE_USER_ID)  ");
		sqlStr.append("FROM 	EE_ELEARNING_STAFF ");
		sqlStr.append("WHERE 	EE_SITE_CODE = ? ");
		params.add(ConstantsServerSide.SITE_CODE);
		sqlStr.append("AND		EE_MODULE_CODE = ? ");
		params.add("education");
		sqlStr.append("AND		EE_EVENT_ID = ? ");
		params.add(eventID);
		sqlStr.append("AND		EE_ELEARNING_ID = ? ");
		params.add(elearningID);
		sqlStr.append("AND 		EE_ENABLED = 1 ");
	    if (dateFrom != null) {
	    	sqlStr.append("	AND 	EE_CREATED_DATE >= TO_DATE(?, 'DD/MM/YYYY') ");
	    	params.add(dateFrom);
	    }
	    if (dateTo != null) {
	    	sqlStr.append("	AND 	EE_CREATED_DATE <= TO_DATE(?, 'DD/MM/YYYY') ");
	    	params.add(dateTo);
	    }

		return UtilDBWeb.getReportableList(sqlStr.toString(), params.toArray(new String[]{}));
	}

	public static ArrayList<ReportableListObject> getElearningTestReport(String eventID, String elearningID, String reportCategory,
			String dateFrom, String dateTo) {
		if ("report1".equals(reportCategory)) {
			return getElearningCorrectCountSummary(eventID, elearningID, dateFrom, dateTo);
		} else if ("report2".equals(reportCategory)) {
			return getElearningIncorrectCountSummary(eventID, elearningID, dateFrom, dateTo);
		} else if ("report3".equals(reportCategory)) {
			return getElearningAttemptCountSummary(eventID, elearningID, dateFrom, dateTo);
		} else if ("report4".equals(reportCategory)) {
			return getElearningHitCountSummary(dateFrom, dateTo);
		}
		return new ArrayList<ReportableListObject>();
	}

	public static ArrayList<ReportableListObject> getElearningCorrectCountSummary(String eventID, String elearningID,
			String dateFrom, String dateTo) {
		StringBuffer sqlStr = new StringBuffer();
		List<String> params = new ArrayList<String>();

		/*
		 * Number of correct answer count attempted by staff for each test
		 * (including the one attempt with highest score only)
		 */
		sqlStr.append("SELECT EE_CORRECT_ANS AS SCORE, COUNT(EE_CORRECT_ANS) AS STAFF_COUNT ");
		sqlStr.append("FROM ");
		sqlStr.append("( ");
		sqlStr.append("	SELECT 	EE_USER_ID, MAX(EE_CORRECT_ANS) AS EE_CORRECT_ANS ");
		sqlStr.append("	FROM 	EE_ELEARNING_STAFF ");
		sqlStr.append("	WHERE ");
		sqlStr.append("			EE_SITE_CODE = ? ");
		params.add(ConstantsServerSide.SITE_CODE);
		sqlStr.append("	AND 	EE_MODULE_CODE = 'education' ");
		sqlStr.append("	AND 	EE_EVENT_ID = ? ");
		params.add(eventID);
		sqlStr.append("	AND 	EE_ELEARNING_ID = ? ");
		params.add(elearningID);
	    sqlStr.append("	AND 	EE_ENABLED = 1 ");
	    if (dateFrom != null) {
	    	sqlStr.append("	AND 	EE_CREATED_DATE >= TO_DATE(?, 'DD/MM/YYYY') ");
	    	params.add(dateFrom);
	    }
	    if (dateTo != null) {
	    	sqlStr.append("	AND 	EE_CREATED_DATE <= TO_DATE(?, 'DD/MM/YYYY') ");
	    	params.add(dateTo);
	    }
	    sqlStr.append("	GROUP BY EE_USER_ID, EE_ENROLL_ID ");
	    sqlStr.append(") ");
	    sqlStr.append("GROUP BY EE_CORRECT_ANS ");
	    sqlStr.append("ORDER BY EE_CORRECT_ANS DESC ");

	    return UtilDBWeb.getReportableList(sqlStr.toString(), params.toArray(new String[]{}));
	}

	public static ArrayList<ReportableListObject> getElearningIncorrectCountSummary(String eventID, String elearningID,
			String dateFrom, String dateTo) {
		StringBuffer sqlStr = new StringBuffer();
		List<String> params = new ArrayList<String>();

		/*
		 * Count the number of incorrect answer made by user for each question
		 */
		sqlStr.append("SELECT 	Q.EE_ELEARNING_QID, Q.EE_QUESTION, CASE WHEN SA.INCORRECT_COUNT IS NULL THEN 0 ELSE SA.INCORRECT_COUNT END ");
		sqlStr.append("FROM ");
		sqlStr.append("( ");
		sqlStr.append("SELECT	EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID, COUNT(1) INCORRECT_COUNT ");
		sqlStr.append("FROM  	EE_ELEARNING_STAFF_ANSWER ");
		sqlStr.append("WHERE ");
		sqlStr.append("			EE_SITE_CODE = ? ");
		params.add(ConstantsServerSide.SITE_CODE);
		sqlStr.append("AND   	EE_MODULE_CODE = 'education' ");
		sqlStr.append("AND   	EE_EVENT_ID = ? ");
		params.add(eventID);
		sqlStr.append("AND   	EE_ELEARNING_ID = ? ");
		params.add(elearningID);
		sqlStr.append("AND   	EE_CORRECT_ANS = 0 ");
	    if (dateFrom != null) {
	    	sqlStr.append("	AND 	EE_CREATED_DATE >= TO_DATE(?, 'DD/MM/YYYY') ");
	    	params.add(dateFrom);
	    }
	    if (dateTo != null) {
	    	sqlStr.append("	AND 	EE_CREATED_DATE <= TO_DATE(?, 'DD/MM/YYYY') ");
	    	params.add(dateTo);
	    }
		sqlStr.append("AND   	EE_ENABLED = 1 ");
		sqlStr.append("GROUP BY EE_SITE_CODE, EE_ELEARNING_ID, EE_ELEARNING_QID ");
		sqlStr.append(") SA");
		sqlStr.append("  RIGHT JOIN EE_ELEARNING_QUESTION Q ");
		sqlStr.append("		ON SA.EE_SITE_CODE = Q.EE_SITE_CODE ");
		sqlStr.append("			AND SA.EE_ELEARNING_ID = Q.EE_ELEARNING_ID ");
		sqlStr.append("			AND SA.EE_ELEARNING_QID = Q.EE_ELEARNING_QID ");
		sqlStr.append("WHERE ");
		sqlStr.append("			Q.EE_SITE_CODE = ? ");
		params.add(ConstantsServerSide.SITE_CODE);
		sqlStr.append("AND   	Q.EE_ELEARNING_ID = ? ");
		params.add(elearningID);
		sqlStr.append("AND   	Q.EE_ENABLED = 1 ");
		sqlStr.append("ORDER BY SA.INCORRECT_COUNT DESC NULLS LAST, Q.EE_ELEARNING_QID ");

	    return UtilDBWeb.getReportableList(sqlStr.toString(), params.toArray(new String[]{}));
	}

	public static ArrayList<ReportableListObject> getElearningAttemptCountSummary(String eventID, String elearningID,
			String dateFrom, String dateTo) {
		StringBuffer sqlStr = new StringBuffer();
		List<String> params = new ArrayList<String>();

		/*
		 * Count the number of attempt for the same test
		 */
		sqlStr.append("SELECT 	ATTEMPT_COUNT, COUNT(ATTEMPT_COUNT) ");
		sqlStr.append("FROM ");
		sqlStr.append("( ");
		sqlStr.append("	SELECT 	AC_USER_ID, COUNT(AC_USER_ID) ATTEMPT_COUNT ");
		sqlStr.append("	FROM  	AC_FUNCTION_ACCESS_LOG ");
		sqlStr.append("	WHERE ");
		sqlStr.append("			AC_REFERER like '%education/elearning_test.jsp%' ");
		sqlStr.append("	AND   	AC_REFERER like '%elearningID=" + elearningID + "%' ");
		sqlStr.append("	AND   	AC_REFERER like '%command=test%' ");
		sqlStr.append("	AND   	AC_REFERER like '%startQuiz=%' ");
	    if (dateFrom != null) {
	    	sqlStr.append("	AND 	AC_CREATED_DATE >= TO_DATE(?, 'DD/MM/YYYY') ");
	    	params.add(dateFrom);
	    }
	    if (dateTo != null) {
	    	sqlStr.append("	AND 	AC_CREATED_DATE <= TO_DATE(?, 'DD/MM/YYYY') ");
	    	params.add(dateTo);
	    }
	    sqlStr.append("	AND   	AC_ENABLED  = 1 ");
	    sqlStr.append("	GROUP BY  AC_USER_ID ");
	    sqlStr.append(") ");
	    sqlStr.append("GROUP BY ATTEMPT_COUNT ");
	    sqlStr.append("ORDER By ATTEMPT_COUNT ");

	    return UtilDBWeb.getReportableList(sqlStr.toString(), params.toArray(new String[]{}));
	}

	public static ArrayList<ReportableListObject> getElearningHitCountSummary(String dateFrom, String dateTo) {
		StringBuffer sqlStr = new StringBuffer();
		List<String> params = new ArrayList<String>();

		/*
		 * Count the hit rate of staff education front page
		 */
		sqlStr.append("SELECT 	HIT_COUNT, COUNT(HIT_COUNT) ");
		sqlStr.append("FROM ");
		sqlStr.append("( ");
		sqlStr.append("	SELECT 	AC_USER_ID, COUNT(AC_USER_ID) HIT_COUNT ");
		sqlStr.append("	FROM  	AC_FUNCTION_ACCESS_LOG ");
		sqlStr.append("	WHERE ");
		sqlStr.append("			AC_REFERER like '%education/reminder.jsp%' ");
	    if (dateFrom != null) {
	    	sqlStr.append("	AND 	AC_CREATED_DATE >= TO_DATE(?, 'DD/MM/YYYY') ");
	    	params.add(dateFrom);
	    }
	    if (dateTo != null) {
	    	sqlStr.append("	AND 	AC_CREATED_DATE <= TO_DATE(?, 'DD/MM/YYYY') ");
	    	params.add(dateTo);
	    }
	    sqlStr.append("	AND   	AC_ENABLED  = 1 ");
	    sqlStr.append("	GROUP BY  AC_USER_ID ");
	    sqlStr.append(") ");
	    sqlStr.append("GROUP BY HIT_COUNT ");
	    sqlStr.append("ORDER By HIT_COUNT DESC ");

	    return UtilDBWeb.getReportableList(sqlStr.toString(), params.toArray(new String[]{}));
	}

	public static int getTotalHitCount(String dateFrom, String dateTo) {
		ArrayList<ReportableListObject> hitCountList = getElearningHitCountSummary(dateFrom, dateTo);
		int count = 0;

		if (hitCountList != null && !hitCountList.isEmpty()) {
			ReportableListObject row = null;
			for (Iterator<ReportableListObject> it = hitCountList.iterator(); it.hasNext(); ) {
				row = (ReportableListObject) it.next();
				if (row != null) {
					try {
						count += (Integer.parseInt(row.getFields0()) * Integer.parseInt(row.getFields1()));
					} catch (Exception e) {
					}
				}
			}
		}
		return count;
	}

	public static boolean sendEmailNotifyManager(String topic, UserBean userBean) {
		// append url
		StringBuffer commentStr = new StringBuffer();
		commentStr.append("Staff "+userBean.getUserName()+"ID: "+userBean.getStaffID()+" has pass ["+topic);

		commentStr.append("] Please go to <a href=\"http://www-server/intranet/education/record_list.jsp\">Education Record</a> to check");

		String managerEmail = null;

		ArrayList<ReportableListObject> result = UtilDBWeb.getReportableList(
				"select u.co_email from co_users u, co_staffs s where u.co_staff_id = s.co_staff_id"+
				" and s.co_department_code = '" +userBean.getDeptCode()+ "' "+
				" and u.co_group_id = 'manager' ");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			managerEmail = reportableListObject.getValue(0);
		   }

		// send email
		return UtilMail.sendMail(
			"admin@hkah.org.hk",
			new String[] { "admin@hkah.org.hk",managerEmail },
			new String[] { "hellene.yiu@hkah.org.hk"},
			null,
			"Staff "+userBean.getUserName()+ " ("+userBean.getStaffID()+")"+" pass "+topic,
			commentStr.toString());
	}
}