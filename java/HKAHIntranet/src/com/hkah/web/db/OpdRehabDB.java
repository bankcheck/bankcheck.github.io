package com.hkah.web.db;

import java.util.ArrayList;
import java.util.*;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
//for image
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import sun.misc.BASE64Decoder;

public class OpdRehabDB {
	private static String sqlStr_insertForm = null;
	private static String sqlStr_updateForm = null;
	private static String sqlStr_updateProgNotes = null;
	private static String sqlStr_saveLog = null;
	
	public static ArrayList getDocInfo(String userid) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT U.USER_ID, U.USER_NAME ");
		sqlStr.append("FROM AH_SYS_USER U ");
		sqlStr.append("WHERE U.USER_ID = '");
		sqlStr.append(userid);
		sqlStr.append("' ");

		//System.out.println(sqlStr.toString());

		return UtilDBWeb.getReportableListCIS(sqlStr.toString());
	}
	public static ArrayList getPatID(String regid) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT R.REGID, R.PATNO, p.patfname || ' ' || p.patgname AS patname, TO_CHAR(P.Patbdate, 'dd/mm/yyyy') AS DOB, P.PATSEX ");
		sqlStr.append("FROM REG@IWEB R, PATIENT@IWEB P");
		sqlStr.append(" WHERE R.PATNO = P.PATNO AND R.REGID = '");
		sqlStr.append(regid);
		sqlStr.append("' ");

//		System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private static String getNextFormUID(){
		String formUID = "";
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT SEQ_CIS_FORMS.nextval ");
		sqlStr.append("FROM DUAL ");
		
		ArrayList result = UtilDBWeb.getReportableListCIS(sqlStr.toString());
		
		if (result.size() > 0){
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			formUID = reportableListObject.getValue(0);
			
			if (formUID == "" || formUID.length() == 0) return "1";
		}

		return formUID;
	}
	
	public static ArrayList getLastPhyInitAssRegID(String patno, String regid) {
		StringBuffer sqlStr = new StringBuffer();
		
		ArrayList result = getFormInfo(regid);

		if (result.size() > 0) {
			sqlStr.append("SELECT DISTINCT mstr_regid FROM OPD_REHAB_INIT WHERE patno = '");
			sqlStr.append(patno);
			sqlStr.append("' AND regid = '");
			sqlStr.append(regid);
			sqlStr.append("'");				
		}else{
/*			
			sqlStr.append("SELECT MAX(regid) FROM OPD_REHAB_INIT WHERE patno = '");
			sqlStr.append(patno);
			sqlStr.append("' AND PAIN_DESC IS NOT NULL");
*/
			sqlStr.append("select regid from ");
			sqlStr.append("		(SELECT regid, row_number() OVER (PARTITION BY patno order by assess_date desc) rn ");
			sqlStr.append("		FROM OPD_REHAB_INIT ");
			sqlStr.append("		WHERE patno = '" + patno + "'");
			sqlStr.append("		AND PAIN_DESC IS NOT NULL) ");
			sqlStr.append("	WHERE rn = 1 ");
		}
		
		System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableListCIS(sqlStr.toString());
	}	

	/**
	 * @param regid
	 * @param patno
	 * @param assess_date
	 * @param patient_goal
	 * @param func_assmt
	 * @param vas_pain
	 * @param vas_pn
	 * @param vas_numb
	 * @param pain_desc
	 * @param clear_chest
	 * @param diagnosis
	 * @param hpi
	 * @param emotional
	 * @param fall_assmt
	 * @param past_med_hist
	 * @param social_history
	 * @param subjective
	 * @param objective
	 * @param treatment_goal
	 * @param care_plan
	 * @param treatment
	 * @param education
	 * @param exercises
	 * @param defection
	 * @param post_treatment
	 * @param frequency
	 * @param options
	 * @param create_user
	 * @param update_user
	 * @return
	 */
	public static String insertForm(
			String regid, String patno, String assess_date, String patient_goal, String func_assmt, 
			String vas_pain, String vas_pn, String vas_numb, String pain_desc, String clear_chest,
			String diagnosis, String hpi, String emotional, String fall_assmt, String past_med_hist, 
			String social_history, String subjective, String objective, String treatment_goal, String care_plan,
			String treatment, String education, String exercises, String defection, String post_treatment, 
			String frequency, String options, String create_user, String update_user, String pt, String mstrRegid, String progNotes ){
		
		// get next Form UID		
		ArrayList result = getFormInfo(regid);
		System.err.println("[update_user]:"+update_user+";[pt]:"+pt+";[progNotes]:"+progNotes+";[regid]"+regid+";[mstrRegid]:"+mstrRegid);
		if (result.size() > 0) {
			// try to update selected record
			if(regid.equals(mstrRegid)){
				if (UtilDBWeb.updateQueueCIS(
						sqlStr_updateForm,
						new String[] {
								patno, assess_date, patient_goal, func_assmt, vas_pain, 
								vas_pn, vas_numb, pain_desc, clear_chest, diagnosis,
								hpi, emotional, fall_assmt, past_med_hist, social_history, 
								subjective, objective, treatment_goal, care_plan, treatment, 
								education, exercises, defection, post_treatment, frequency, 
								options, update_user, pt, progNotes, regid 
								})){
					System.err.println("[sqlStr_updateForm]:"+sqlStr_updateForm);
					saveLog(regid, patno, "SUCCESS", update_user);				
					return regid;					
				}else{
					saveLog(regid, patno, "FAIL", update_user);					
					return null;					
				}		
			}else{
				if (UtilDBWeb.updateQueueCIS(
						sqlStr_updateProgNotes,
						new String[] {progNotes, update_user, regid
								})){
					System.err.println("[sqlStr_updateProgNotes]:"+sqlStr_updateForm);
					saveLog(regid, patno, "SUCCESS", update_user);				
					return regid;					
				}else{
					saveLog(regid, patno, "FAIL", update_user);					
					return null;					
				}		
			}				
		}else{
			if(regid.equals(mstrRegid)){
				if(UtilDBWeb.updateQueueCIS(
						sqlStr_insertForm,
						new String[] {
								regid, patno, assess_date, patient_goal, func_assmt, 
								vas_pain, vas_pn, vas_numb, pain_desc, clear_chest,
								diagnosis, hpi, emotional, fall_assmt, past_med_hist, 
								social_history, subjective, objective, treatment_goal, care_plan,
								treatment, education, exercises, defection, post_treatment, 
								frequency, options, create_user, update_user, pt, 
								mstrRegid, progNotes})){
					System.err.println("[sqlStr_insertForm][initial record]:"+sqlStr_insertForm);
					saveLog(regid, patno, "SUCCESS", update_user);				
					return regid;			
					
				}else{
					saveLog(regid, patno, "FAIL", update_user);				
					return null;
				}					
			}else{
				if(UtilDBWeb.updateQueueCIS(
						sqlStr_insertForm,
						new String[] {
								regid, patno, assess_date, null, null, 
								null, null, null, null, null,
								null, null, null, null, null, 
								null, null, null, null, null,
								null, null, null, null, null, 
								null, null, null, update_user, null, mstrRegid, progNotes})){
					System.err.println("[sqlStr_insertForm][attach record]:"+sqlStr_insertForm);
					saveLog(regid, patno, "SUCCESS", update_user);				
					return regid;	
				}else{
					saveLog(regid, patno, "FAIL", update_user);				
					return null;
				}
			}				
		}
	}
	
	public static boolean saveLog(String regID, String patNO, String isSuccess, String update_user){
		if(UtilDBWeb.updateQueueCIS(
				sqlStr_saveLog,
				new String[] {regID, patNO, isSuccess, getComputerName(), update_user})){
			System.err.println("[sqlStr_saveLog]:"+sqlStr_saveLog);				
			return true;
		}else{
			System.err.println("[sqlStr_saveLog][FALSE]:"+sqlStr_saveLog+";[regID]:"+regID+"[patNO]:"+patNO+";[getComputerName()]:"+getComputerName()+";[update_user]:"+update_user);			
			return false;
		}
	}
	
	private static String getComputerName()
	{
	    Map<String, String> env = System.getenv();
	    if (env.containsKey("COMPUTERNAME"))
	        return env.get("COMPUTERNAME");
	    else if (env.containsKey("HOSTNAME"))
	        return env.get("HOSTNAME");
	    else
	        return "Unknown Computer";
	}
	
	public static String updateForm(String regid, String patno, String assess_date, String patient_goal, String func_assmt, 
									String vas_pain, String vas_pn, String vas_numb, String pain_desc, String clear_chest,
									String diagnosis, String hpi, String emotional, String fall_assmt, String past_med_hist, 
									String social_history, String subjective, String objective, String treatment_goal, String care_plan,
									String treatment, String education, String exercises, String defection, String post_treatment, 
									String frequency, String options, String create_user, String update_user, String time_duration) {

		String formName = "Breast Health Centre Progress Sheet (web)";
		String folder = "WebBreastProgress";

		// try to update selected record
		if (UtilDBWeb.updateQueueCIS(
				sqlStr_updateForm,
				new String[] {
						regid, patno, assess_date, patient_goal, func_assmt, 
						vas_pain, vas_pn, vas_numb, pain_desc, clear_chest,
						diagnosis, hpi, emotional, fall_assmt, past_med_hist, 
						social_history, subjective, objective, treatment_goal,care_plan,
						treatment, education, exercises, defection, post_treatment, 
						frequency, options, create_user, update_user, time_duration
						})){
			
			return regid;			
		}else{
			return null;
		}
	}
	
	public static ArrayList getFormPath() {		
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT code_value1 ");
		sqlStr.append("FROM AH_SYS_CODE ");
		sqlStr.append("WHERE SYS_ID = 'CMS' ");
		sqlStr.append("AND CODE_TYPE = 'FORM' ");
		sqlStr.append("AND CODE_NO = 'FORM_PATH' ");
		
		//System.out.println(sqlStr.toString());
		
		return UtilDBWeb.getReportableListCIS(sqlStr.toString());	
		}
	
	public static ArrayList getFormInfo(String regid) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT ");
		sqlStr.append("regid, patno, to_char(assess_date,'dd/mm/yyyy'), patient_goal, func_assmt, vas_pain, vas_pn, vas_numb, pain_desc, clear_chest,");
		sqlStr.append("diagnosis, hpi, emotional, fall_assmt, past_med_hist, social_history, subjective, objective, treatment_goal,care_plan,");
		sqlStr.append("treatment, education, exercises, defection, post_treatment, frequency, options, create_user, create_date, (select user_name from ah_sys_user where ah_sys_user.user_id = OPD_REHAB_INIT.update_user) as update_user,");
		sqlStr.append("update_date,");
		sqlStr.append("F_GET_OPTION(CARE_PLAN,'tcp1','N'),F_GET_OPTION(CARE_PLAN,'tcp2','N'),F_GET_OPTION(CARE_PLAN,'tcp3','N'),");
		sqlStr.append("F_GET_OPTION(CARE_PLAN,'tcp4','N'),F_GET_OPTION(CARE_PLAN,'tcp5','N'),F_GET_OPTION(CARE_PLAN,'tcp6','N'),");
		sqlStr.append("F_GET_OPTION(CARE_PLAN,'tcp7','N'),F_GET_OPTION(CARE_PLAN,'tcp8','N'),F_GET_OPTION(CARE_PLAN,'tcp9','N'),");
		sqlStr.append("F_GET_OPTION(CARE_PLAN,'tcpOther1',null),");
		sqlStr.append("F_GET_OPTION(EDUCATION,'peca1','N'),F_GET_OPTION(EDUCATION,'peca2','N'),");
		sqlStr.append("F_GET_OPTION(EDUCATION,'pecaOther1',null),");
		sqlStr.append("F_GET_OPTION(DEFECTION,'ad1','N'),F_GET_OPTION(DEFECTION,'ad2','N'),F_GET_OPTION(DEFECTION,'ad3','N'),");
		sqlStr.append("F_GET_OPTION(DEFECTION,'ad4','N'),F_GET_OPTION(DEFECTION,'ad5','N'),F_GET_OPTION(DEFECTION,'ad6','N'),");
		sqlStr.append("F_GET_OPTION(DEFECTION,'ad7','N'),F_GET_OPTION(DEFECTION,'ad8','N'),F_GET_OPTION(DEFECTION,'ad9','N'),");		
		sqlStr.append("F_GET_OPTION(DEFECTION,'adOther1',null),F_GET_OPTION(DEFECTION,'adOther2',null),");
		sqlStr.append("TIME_DURATION ");		
		sqlStr.append(" FROM OPD_REHAB_INIT ");
		sqlStr.append(" WHERE regid = '");
		sqlStr.append(regid);
		sqlStr.append("' ");

		System.out.println(sqlStr.toString());

		return UtilDBWeb.getReportableListCIS(sqlStr.toString());
	}
	
	public static ArrayList getCurrentProgressNote(String regid) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT ");
		sqlStr.append(" PROGRESS_NOTE, to_char(assess_date,'dd/mm/yyyy'), TO_CHAR(ORI.CREATE_DATE,'dd/mm/yyyy')||' by '||NVL((SELECT ASU.USER_NAME FROM AH_SYS_USER ASU WHERE ASU.USER_ID =ORI.UPDATE_USER),UPDATE_USER) ");
		sqlStr.append(" FROM OPD_REHAB_INIT ORI ");
		sqlStr.append(" WHERE regid = '");
		sqlStr.append(regid);
		sqlStr.append("' ");

		System.out.println(sqlStr.toString());

		return UtilDBWeb.getReportableListCIS(sqlStr.toString());
	}
	
	public static String getHistProgNote(String regid, String mstrRegid)throws IOException{
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT ");
		sqlStr.append(" TO_CHAR(ORI.CREATE_DATE,'dd/mm/yyyy')||' by '||NVL((SELECT ASU.USER_NAME FROM AH_SYS_USER ASU WHERE ASU.USER_ID =ORI.UPDATE_USER),UPDATE_USER), TRIM(ORI.PROGRESS_NOTE) ");		
		sqlStr.append(" FROM OPD_REHAB_INIT ORI ");
		sqlStr.append(" WHERE ORI.mstr_regid = '");
		sqlStr.append(mstrRegid);
		sqlStr.append("' AND ORI.regid != '");
		sqlStr.append(regid);
		
//		sqlStr.append("' AND TO_NUMBER(REGEXP_REPLACE(ORI.regid,'[[:alpha:]]','')) < TO_NUMBER(REGEXP_REPLACE('");
//		sqlStr.append(regid);
//		sqlStr.append("','[[:alpha:]]','')) ORDER BY ORI.regid, ORI.assess_date desc");
		
		sqlStr.append("' AND TO_NUMBER(SUBSTR(ORI.regid, INSTR(ORI.regid, '-')+1)) ");
		sqlStr.append("    < TO_NUMBER(SUBSTR('" + regid + "', INSTR('" + regid + "', '-')+1)) ");
		sqlStr.append(" ORDER BY ORI.regid, ORI.assess_date desc");	
		
		System.err.println(sqlStr.toString());
		ArrayList result = UtilDBWeb.getReportableListCIS(sqlStr.toString());
		String progNote = null;
		String createDate = null;
		if (result.size() > 0) {
	      	ReportableListObject row = null;
			for (int i = 0; i < result.size(); i++) {
				row = (ReportableListObject) result.get(i);				
				createDate = row.getValue(0);
				if(i>0 && progNote!=null){
					progNote = progNote + "<br>" + row.getValue(0) + "<br>" + row.getValue(1) + (i+1 == result.size() ? "" : "<br>");					
				}else{
					progNote = row.getValue(0) + "<br>" + row.getValue(1);					
				}
				System.err.println("["+i+"][progNote]:"+progNote);
			}		
		}else{progNote=null;}
		System.err.println("[progNote]:"+progNote);		
		return progNote;
	}	
	
	public static void createImage(String imgPath, String fileName)throws IOException{
		File f = null;
	
		String path = "";
		ArrayList result = getFormPath();
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			path = reportableListObject.getValue(0);
		}

		BASE64Decoder decoder = new BASE64Decoder();
		byte[] decodedBytes = decoder.decodeBuffer(imgPath.split("^data:image/(png|jpg);base64,")[1]);
		BufferedImage image = ImageIO.read(new ByteArrayInputStream(decodedBytes));
		
		try{
			f = new File(path + "PhyInitAssFormOP_" + fileName +".png");
			System.out.println("Path : " + f.getAbsolutePath());
			ImageIO.write(image, "png", f);
			//System.out.println("Write Complete");
		}catch(IOException e){
			//System.out.println("ERROR:" + e);
		}
	}
	
	public static String getImage(String fileName) throws IOException{
		int w = 341;
		int h = 201;
		File f = null;
		BufferedImage image = null;
		String imageString ="";

		String path = "";
		ArrayList result = getFormPath();
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			path = reportableListObject.getValue(0);
		}
		
		try{
			f = new File(path + "PhyInitAssFormOP_" + fileName + ".png");
			System.out.println("Path : " + f.getAbsolutePath());			
			image = new BufferedImage(w, h, BufferedImage.TYPE_INT_ARGB);
			image = ImageIO.read(f);
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			ImageIO.write( image, "png", baos );
			baos.flush();
			byte[] imageInByteArray = baos.toByteArray();
			baos.close();
			imageString = javax.xml.bind.DatatypeConverter.printBase64Binary(imageInByteArray);
			System.out.println("[imageString] : " + imageString);			
			//System.out.println("Read Complete");
		}catch(IOException e){
			//System.out.println("ERROR:" + e);
		}
		return imageString;
	}
	
	static{
		StringBuffer sqlStr = new StringBuffer();
				
		sqlStr.append("INSERT INTO OPD_REHAB_INIT (");
		sqlStr.append("regid, patno, assess_date, patient_goal, func_assmt, vas_pain, vas_pn, vas_numb, pain_desc, clear_chest,");
		sqlStr.append("diagnosis, hpi, emotional, fall_assmt, past_med_hist, social_history, subjective, objective, treatment_goal, care_plan,");
		sqlStr.append("treatment, education, exercises, defection, post_treatment, frequency, options, create_user, create_date, update_user,");
		sqlStr.append("update_date, time_duration, mstr_regid, progress_note)");
		sqlStr.append(" VALUES (");
		sqlStr.append("?, ?, TO_DATE(?,'DD/MM/YYYY'), ?, ?, ?, ?, ?, ?, ?,");
		sqlStr.append("?, ?, ?, ?, ?, ?, ?, ?, ?, ?,");
		sqlStr.append("?, ?, ?, ?, ?, ?, ?, ?, SYSDATE, ?,");
		sqlStr.append("SYSDATE, ?, ?, ?)");
		sqlStr_insertForm = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE OPD_REHAB_INIT");
		sqlStr.append(" SET patno = ?, assess_date = TO_DATE(?,'DD/MM/YYYY'), patient_goal = ?, func_assmt = ?, vas_pain = ?,");
		sqlStr.append("vas_pn = ?, vas_numb = ?, pain_desc = ?, clear_chest = ?, diagnosis = ?,");
		sqlStr.append("hpi = ?, emotional = ?, fall_assmt = ?, past_med_hist = ?, social_history = ?,");
		sqlStr.append("subjective = ?, objective = ?, treatment_goal = ?, care_plan = ?, treatment = ?,");
		sqlStr.append("education = ?, exercises = ?, defection = ?, post_treatment = ?, frequency = ?,");
		sqlStr.append("options = ?, update_user = ?, update_date = SYSDATE, time_duration = ?, progress_note = ?");		
		sqlStr.append(" WHERE  regid = ?");
		sqlStr_updateForm = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE OPD_REHAB_INIT");
		sqlStr.append(" SET progress_note = ?, update_user = ?, update_date = SYSDATE ");		
		sqlStr.append(" WHERE  regid = ?");
		sqlStr_updateProgNotes = sqlStr.toString();		
		
		sqlStr.setLength(0);
		sqlStr.append("insert into ah_sys_log"); 
		sqlStr.append(" (sys_id, sys_time, user_id, user_dept, user_team, keyword, description, pcname)");
		sqlStr.append(" select 'CIS', sysdate, user_id, user_dept, user_team, 'REHAB', 'Update record refer by RegID:'||?||',patNO:'||?||'||['||?||']''',?");
		sqlStr.append(" from ah_sys_user"); 
		sqlStr.append(" where user_id= ?");
		sqlStr_saveLog = sqlStr.toString();		
	}
}
