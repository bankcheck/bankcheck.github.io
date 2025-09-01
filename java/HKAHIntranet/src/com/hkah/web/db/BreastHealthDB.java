package com.hkah.web.db;

import java.util.ArrayList;

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

public class BreastHealthDB {
	private static String sqlStr_insertForm = null;
	private static String sqlStr_updateForm = null;
	
	public static ArrayList getDocInfo(String userid) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT U.USER_ID, U.USER_NAME ");
		sqlStr.append("FROM AH_SYS_USER U ");
		sqlStr.append("WHERE U.USER_ID = '");
		sqlStr.append(userid);
		sqlStr.append("' ");

		return UtilDBWeb.getReportableListCIS(sqlStr.toString());
	}
	public static ArrayList getPatID(String regid) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT REGID, PATNO ");
		sqlStr.append("FROM REG@IWEB ");
		sqlStr.append("WHERE REGID = '");
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

	public static String insertForm(String formType, 
									String regid, String patno, 
									String updateUser, String content){
		
		// get next Form UID
		String formUID = getNextFormUID();

		String formName = "Breast Health Centre Progress Sheet (web)";
		String folder = "WebBreastProgress";
		
		UtilDBWeb.updateQueueCIS(
				sqlStr_insertForm,
				new String[] {
						formUID, formType, formName, 
						regid, patno, folder,
						updateUser, content
						});
		return formUID;
	}
	
	public static String updateForm(String formUID, String formType, 
			String regid, String patno, 
			String updateUser, String content) {

		String formName = "Breast Health Centre Progress Sheet (web)";
		String folder = "WebBreastProgress";

		// try to update selected record
		UtilDBWeb.updateQueueCIS(
				sqlStr_updateForm,
				new String[] {
						formType, formName, 
						regid, patno, folder,
						updateUser, content, formUID
						});
		
		return formUID;
	}
	
	public static String createRehabProgNotes(String formType, 
			String regid, String patno, 
			String updateUser, String content){

		// get next Form UID
		String formUID = getNextFormUID();
		
		String formName = "Rehabilitation Progress Notes (web)";
		String folder = "WebRehabProgressNotes";
		
		UtilDBWeb.updateQueueCIS(
		sqlStr_insertForm,
		new String[] {
		formUID, formType, formName, 
		regid, patno, folder,
		updateUser, content
		});
		System.err.println("[sqlStr_insertForm]:"+sqlStr_insertForm+";[content]:"+content+";[formType]:"+formType+";[formName]:"+formName+";[regid]:"+regid+";[patno]:"+patno+";[folder]:"+folder);		
		return formUID;
	}

	public static String updateRehabProgNotes(String formUID, String formType, 
		String regid, String patno, 
		String updateUser, String content) {
		
		String formName = "Rehabilitation Progress Notes (web)";
		String folder = "WebRehabProgressNotes";
		
		// try to update selected record
		UtilDBWeb.updateQueueCIS(
		sqlStr_updateForm,
		new String[] {
		formType, formName, 
		regid, patno, folder,
		updateUser, content, formUID
		});
		System.err.println("[sqlStr_updateForm]:"+sqlStr_updateForm+";[content]:"+content+";[formType]:"+formType+";[formName]:"+formName+";[regid]:"+regid+";[patno]:"+patno+";[updateUser]:"+updateUser);		
		return formUID;
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
	
	public static ArrayList getFormIDByRegID(String regid, String patno, String formName) {		
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT FORM_UID ");
		sqlStr.append("FROM CIS_FORMS ");
		sqlStr.append("WHERE REGID = '");
		sqlStr.append(regid);
		sqlStr.append("' AND PATNO = '");
		sqlStr.append(patno);
		sqlStr.append("' AND FORM_NAME = '");
		sqlStr.append(formName);		
		sqlStr.append("'");
		
		System.out.println(sqlStr.toString());
		
		return UtilDBWeb.getReportableListCIS(sqlStr.toString());	
		}	
	
	public static ArrayList getFormInfo(String formuid) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT FORM_UID, TO_CHAR(FORM_DATE,'DD/MM/YYYY'), FORM_TYPE, REGID, PATNO, UPDATE_USER, FORM_FIELD_VALUES, TO_CHAR(UPDATE_DATE,'DD/MM/YYYY') ");
		sqlStr.append("FROM CIS_FORMS ");
		sqlStr.append("WHERE FORM_UID = '");
		sqlStr.append(formuid);
		sqlStr.append("' ");

//		System.out.println(sqlStr.toString());

		return UtilDBWeb.getReportableListCIS(sqlStr.toString());
	}
	
	public static void createImage(String imgPath, String fileName)throws IOException{
		File f = null;

		String path = "";
		ArrayList result = BreastHealthDB.getFormPath();
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			path = reportableListObject.getValue(0);
		}

		BASE64Decoder decoder = new BASE64Decoder();
		byte[] decodedBytes = decoder.decodeBuffer(imgPath.split("^data:image/(png|jpg);base64,")[1]);
		BufferedImage image = ImageIO.read(new ByteArrayInputStream(decodedBytes));
		
		try{
			f = new File(path + "BreastHealth_"+ fileName +".png");
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
		ArrayList result = BreastHealthDB.getFormPath();
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			path = reportableListObject.getValue(0);
		}

		try{
			f = new File(path + "BreastHealth_" + fileName + ".png");
			image = new BufferedImage(w, h, BufferedImage.TYPE_INT_ARGB);
			image = ImageIO.read(f);
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			ImageIO.write( image, "png", baos );
			baos.flush();
			byte[] imageInByteArray = baos.toByteArray();
			baos.close();
			imageString = javax.xml.bind.DatatypeConverter.printBase64Binary(imageInByteArray);
			//System.out.println("Read Complete");
		}catch(IOException e){
			//System.out.println("ERROR:" + e);
		}
		return imageString;
	}
	
	static{
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("Insert into CIS_FORMS");
		sqlStr.append("(FORM_UID, FORM_DATE, FORM_TYPE, FORM_NAME, ");
		sqlStr.append("REGID, PATNO, FOLDER, " );
		sqlStr.append("UPDATE_USER, UPDATE_DATE, FORM_FIELD_VALUES)");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, SYSDATE, ?, ?, ");
		sqlStr.append(" ?, ?, ?, ");
		sqlStr.append(" ?, SYSDATE, ? )");
		sqlStr_insertForm = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE CIS_FORMS ");
		sqlStr.append("SET    FORM_TYPE = ?, FORM_NAME = ?, ");
		sqlStr.append("       REGID = ?, PATNO = ?, FOLDER = ?, ");
		sqlStr.append("       UPDATE_USER = ?, UPDATE_DATE = SYSDATE, FORM_FIELD_VALUES = ? ");
		sqlStr.append("WHERE  FORM_UID = ?");
		sqlStr_updateForm = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE CIS_FORMS ");
		sqlStr.append("SET    FORM_TYPE = ?, FORM_NAME = ?, ");
		sqlStr.append("       REGID = ?, PATNO = ?, FOLDER = ?, ");
		sqlStr.append("       UPDATE_USER = ?, UPDATE_DATE = SYSDATE, FORM_FIELD_VALUES = ? ");
		sqlStr.append("WHERE  FORM_UID = ?");
		sqlStr_updateForm = sqlStr.toString();		
	}
}
