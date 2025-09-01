package com.hkah.web.schedule;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.web.common.ReportableListObject;

import jcifs.smb.NtlmPasswordAuthentication;
import jcifs.smb.SmbFile;
import jcifs.smb.SmbFileInputStream;
import net.lingala.zip4j.core.ZipFile;
import net.lingala.zip4j.exception.ZipException;
import net.lingala.zip4j.model.ZipParameters;
import net.lingala.zip4j.util.Zip4jConstants;

public class NotifyPatientCOVGQ implements Job {
	
	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		System.out.println("[NotifyPatientCOVGQ] ===== Start =====");
		main();
		System.out.println("[NotifyPatientCOVGQ] ===== End =====");
	}
	
	// ======================================================================
	private static ArrayList<ReportableListObject> getList() {

		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT LAB_NUM, PATNO, EMAIL, rptdate, report_path, report_file, cert_path, cert_file, lang "); 
		sqlStr.append(" FROM V_COVGQ_EMAIL_PENDING@LIS ");
				
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	// ======================================================================
	public static void main() {

		ArrayList<ReportableListObject> record = getList();
		ReportableListObject row = null;
		
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			
			String labnum = row.getValue(0);
			String patno = row.getValue(1);
			String email = row.getValue(2);
			String rptDate = row.getValue(3);
			String rptPath = row.getValue(4);
			String rptFile = row.getValue(5);
			String crtPath = row.getValue(6);
			String crtFile = row.getValue(7);
			String lang = row.getValue(8);
			
			try {
								
				if (email.length() > 0) {// send email
					
					send ( labnum, patno, email, rptDate, rptPath, rptFile, crtPath, crtFile, lang, true, false );					
					
				} else {
					updateEmailErrorMsg(labnum, "No email address");
				}
				
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
				
		}

	}
	
	// ======================================================================
	public static void send ( String labnum, String patno, String email, String rptDate, 
			String rptPath, String rptFile, String crtPath, String crtFile, String lang,
			boolean sendPw, boolean debug ) {
		
		String type = "HKLAB";
		String sender = "hkahsrcovid@hkah.org.hk";
		
		String subject1 = "HKAH-Stubbs Road: Document(s) for Your Reference";					
		if ("TRC".equals(lang))
			subject1 = "香港港安–司徒拔道：請參閱附件";
		else if ("SMC".equals(lang))
			subject1 = "香港港安–司徒拔道：请参阅附件";

		String srcRptPath = rptPath.trim() + rptFile;
		String srcCrtPath = crtPath.trim() + crtFile;
		
		boolean cert = false;
		if ( srcRptPath != null && !srcRptPath.trim().isEmpty()  ) {
			cert = true;
		}
	
		File attachment = zipAttachment(labnum, srcRptPath, srcCrtPath, debug);
		
		if (attachment != null) {
		
			String emailContent1 = getEmail1Content(lang, patno, rptDate, cert);
													
			if (UtilMail.sendMail(
					sender,
					new String[] { email },
					null, null,
					subject1,
					emailContent1, 
					attachment,
					labnum + ".zip", 
					false)) {
				
				UtilMail.insertEmailLog(null, labnum,
						type, "COVID", true, "");
					
				updateEmailSuccessTimeAndMsg(labnum);
				
			} else {
				UtilMail.insertEmailLog(null, labnum,
						type, "COVID", false, "");
					
				updateEmailErrorMsg(labnum, "Email sent failed");						
			}
			
			if (sendPw) {

				String subject2 = "HKAH-Stubbs Road: Password";					
				if ("TRC".equals(lang))
					subject2 = "香港港安–司徒拔道：密碼";
				else if ("SMC".equals(lang))
					subject2 = "香港港安–司徒拔道：密码";
				
				String emailContent2 = getEmail2Content(lang);
				
				if (UtilMail.sendMail(
						sender,
						new String[] { email },
						null,
						null,
						subject2,
						emailContent2, false)) {
					
					UtilMail.insertEmailLog(null, labnum,
						type, "COVID", true, "");
					
					updateEmailSuccessTimeAndMsg(labnum);
					
				} else {
					UtilMail.insertEmailLog(null, labnum,
						type, "COVID", false, "");
					
					updateEmailErrorMsg(labnum, "Password sent failed");
				}
				
			}
			
			if (!debug)
				attachment.delete();
			
		} else {
			updateEmailErrorMsg(labnum, "File attachment error");
		}							
	}
	
	// ======================================================================
	public static File zipAttachment (String labnum, String report, String cert, boolean debug) {
		
		File attachment = null;
		String tmpFolder = ConstantsServerSide.TEMP_FOLDER;
		System.out.println("[NotifyPatientCOVGQ] tmpFolder= " + tmpFolder);
		
		String destRptPath = tmpFolder + "/" + labnum + "-report.pdf";
		String destCrtPath = tmpFolder + "/"  + labnum + "-cert.pdf";

		String login_user = getSysParam("EHRSMBUID");
		if (login_user == null)
			login_user = "webfolder@ahhk.local";
	    String login_pass = getSysParam("EHRSMBPW");
	    if (login_pass == null)
	    	login_pass = "folder28350";

		NtlmPasswordAuthentication smbAuth = new NtlmPasswordAuthentication("",login_user, login_pass);
		
		try {
	        SmbFile smbReportFile = new SmbFile("smb:" + report.replace("\\", "/"), smbAuth);
	        SmbFile smbCertFile = new SmbFile("smb:" + cert.replace("\\", "/"), smbAuth);
			
			String zipPath = tmpFolder  + "/" + labnum + ".zip";
			
			System.out.println("[NotifyPatientCOVGQ] srcRptPath = " + report + 							
					" destRptPath = " + destRptPath +
					" srcCrtPath = " + cert +
					" destCrtPath = " + destCrtPath +
					" smb login = " + login_user + " / " + login_pass + 
					" zipPath = " + zipPath +
					" zipPassword = " + getPasswd() );
			
			File destReportFile = new File( destRptPath ) ;
			copyFileUsingFileStreams( smbReportFile, destReportFile ) ;
			
			File destCertFile = new File( destCrtPath ) ;
			
			if ( cert != null && !cert.trim().isEmpty()  ) {				
				copyFileUsingFileStreams( smbCertFile, destCertFile ) ;
			}
			
			try {
				ZipFile zipFile = new ZipFile(zipPath);						
				ZipParameters param = new ZipParameters();
				param.setCompressionMethod(Zip4jConstants.COMP_DEFLATE);
				param.setCompressionLevel(Zip4jConstants.DEFLATE_LEVEL_NORMAL); 
				param.setEncryptFiles(true);
				param.setEncryptionMethod(Zip4jConstants.ENC_METHOD_STANDARD);
				param.setPassword(getPasswd());
	
				ArrayList<File> filesToAdd = new ArrayList<File>();
				filesToAdd.add(destReportFile);
				
				if ( cert != null && !cert.trim().isEmpty()  ) {
					filesToAdd.add(destCertFile);
				}
									
				zipFile.addFiles(filesToAdd, param);
				
			} catch (ZipException e) {
				System.out.println("[NotifyPatientCOVGQ] zip file error : " + e.getMessage() );
			    e.printStackTrace();
			}
			
			attachment = new File(zipPath);
			
			if (!debug) {
				destReportFile.delete();
				destCertFile.delete();
			}
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		return attachment;			
	}

	// ======================================================================
	private static String getEmail1Content(String lang, String patno, String rptDate, boolean cert ) {
		
		String maskedPatno = getMaskedNum(patno);
		
		StringBuffer content = new StringBuffer();
		
		if ("TRC".equals(lang)) {
			
			String attachement = "化驗報告";			
			if ( cert )
				attachement = "化驗報告及健康證明";
			
			content.append("尊敬的先生/女士:<br /><br />");
			content.append("隨函附上以下文檔，謹供閣下參考。<br /><br />");
			content.append("<b>病人編號： " + maskedPatno + "</b><br />");
			content.append("<b>報告日期： " + rptDate + "</b><br />");	
			content.append("<b>檢測：新型冠狀病毒抗體IgG</b><br />");
			content.append("<b>附件：" + attachement + "</b><br /><br />");
			content.append("如欲索取列印本，您或獲授權人士可前往香港港安醫院—司徒拔道病理化驗中心領取。隨函所附的 PDF 文檔乃受密碼保護，密碼將稍後透過電郵發送。<br /><br />");
			content.append("Android 智能手機用戶需要一個工具來打開和提取文件。如果您的手機上尚未安裝該工具，請按以下鏈結下載<br />");
			content.append("<a href='https://play.google.com/store/apps/details?id=com.rarlab.rar'>https://play.google.com/store/apps/details?id=com.rarlab.rar</a><br /><br />");
			content.append("或以下鏈結瀏覽其他推薦工具<br /><br />");
			content.append("<a href='https://beebom.com/top-10-android-apps-for-zip-and-rar-files/'>https://beebom.com/top-10-android-apps-for-zip-and-rar-files/</a><br /><br />");
			content.append("如有任何查詢，請致電：<br />");
			content.append("電話：2835 0534（香港）<br />");
			content.append("辦公時間：星期一至日，上午 9 時至下午 9 時<br /><br />");
			content.append("感謝選用本院服務。<br /><br />");
			content.append("====<br /><br />");
			content.append("此電子郵件消息（包括附件）中包含的信息可機密和/或法律的特權。 如閣下並非準收件人，則不得閱讀、複製或向任何人披露該消息或該消息中包含的任何信息。若錯誤收到此訊息，請立即通知寄件人，並從您的所有系統中刪除訊息。");
		
		} else if ("SMC".equals(lang)) {
			
			String attachement = "化验报告";			
			if ( cert )
				attachement = "化验报告及健康证明";
			
			content.append("尊敬的先生/女士:<br /><br />");
			content.append("随函附上以下文档，谨供阁下参考。<br /><br />");
			content.append("<b>病人编号： " + maskedPatno + "</b><br />");
			content.append("<b>报告日期： " + rptDate + "</b><br />");	
			content.append("<b>检测：新型冠状病毒抗体IgG</b><br />");
			content.append("<b>附件：" + attachement + "</b><br /><br />");
			content.append("如欲索取列印本，您或获授权人士可前往香港港安医院—司徒拔道病理化验中心领取。随函所附的 PDF 文档乃受密码保护，密码将稍后透过电邮發送。<br /><br />");
			content.append("Android 智能手机用户需要一个工具来打开和提取文件。如果您的手机上尚未安装该工具，请按以下链结下载<br />");
			content.append("<a href='https://play.google.com/store/apps/details?id=com.rarlab.rar'>https://play.google.com/store/apps/details?id=com.rarlab.rar</a><br /><br />");
			content.append("或以下链结浏览其他推荐工具<br /><br />");
			content.append("<a href='https://beebom.com/top-10-android-apps-for-zip-and-rar-files/'>https://beebom.com/top-10-android-apps-for-zip-and-rar-files/</a><br /><br />");
			content.append("如有任何查询，请致电：<br />");
			content.append("电话：2835 0534（香港）<br />");
			content.append("办公时间：星期一至日，上午 9 时至下午 9 时<br /><br />");
			content.append("感谢选用本院服务。<br /><br />");
			content.append("====<br /><br />");
			content.append("此电子邮件消息（包括附件）中包含的信息可机密和/或法律的特权。 如阁下并非准收件人，则不得阅读、複製或向任何人披露该消息或该消息中包含的任何信息。若错误收到此讯息，请立即通知寄件人，并从您的所有系统中删除讯息。");
		
		} else {
			
			String attachement = "Testing Report";			
			if ( cert )
				attachement = "Testing Report & Health Certificate";
			
			content.append("Dear Sir / Madam,<br /><br />");
			content.append("Please find the attachment(s) for your reference.<br /><br />");
			content.append("<b>Patient No.: " + maskedPatno + "</b><br />");
			content.append("<b>Report Date: " + rptDate + "</b><br />");	
			content.append("<b>Test: SARS-CoV-2 IgG#</b><br />");
			content.append("<b>Attachment(s): " + attachement + "</b><br /><br />");
			content.append("If you wish to acquire a hard copy, you or an authorized person may collect the paperwork from the Clinical and Pathology Laboratory in HKAH-Stubbs Road. The PDF file is password protected and the password will be sent in a later email.<br /><br />");
			content.append("If you are using an Android smart phone, you may need a tool to open and extract the file.  Please find a link below to download the tool if it is not yet installed on your phone.<br /><br />");
			content.append("<a href='https://play.google.com/store/apps/details?id=com.rarlab.rar'>https://play.google.com/store/apps/details?id=com.rarlab.rar</a><br /><br />");
			content.append("<b>Or</b> other tools recommended by the link below<br /><br />");
			content.append("<a href='https://beebom.com/top-10-android-apps-for-zip-and-rar-files/'>https://beebom.com/top-10-android-apps-for-zip-and-rar-files/</a><br /><br />");
			content.append("Should you have any inquiries, please call:<br />");
			content.append("T: 28350534 (HK)<br />");
			content.append("Business hours: Mon to Sun, 9 am - 9 pm<br /><br />");
			content.append("Thank you for your attention.<br /><br />");
			content.append("====<br /><br />");
			content.append("This email and any attachments are confidential and may also be privileged. If you are not the intended recipient, you may not use, copy or disclose to anyone the message or any information contained in the message. If you have received the message in error, please advise the sender by reply e-mail and delete the message immediately.");
		}
		
		return content.toString();
	}
	
	// ======================================================================
	private static String getEmail2Content(String lang) {
		
		StringBuffer content = new StringBuffer();
				
		if ("TRC".equals(lang)) {		
			
			content.append("尊敬的先生/女士:<br /><br />");
			content.append("<b>密碼：" + getPasswd() + "</b><br /><br />");
			content.append("閣下可使用上述密碼開啟較早前電郵予閣下的文件。<br /><br />");
			content.append("如欲索取正本，您或獲授權人士可前往香港港安醫院—司徒拔道病理化驗中心領取。<br /><br />");
			content.append("如有任何查詢，請致電：<br />");
			content.append("電話：2835 0534（香港）<br />");
			content.append("辦公時間：星期一至日，上午 9 時至下午 9 時<br /><br />");
			content.append("感謝選用本院服務。<br /><br />");
			content.append("====<br /><br />");
			content.append("此電子郵件消息（包括附件）中包含的信息可機密和/或法律的特權。 如閣下並非準收件人，則不得閱讀、複製或向任何人披露該消息或該消息中包含的任何信息。若錯誤收到此訊息，請立即通知寄件人，並從您的所有系統中刪除訊息。");
		
		} else if ("SMC".equals(lang)) {
			
			content.append("尊敬的先生/女士:<br /><br />");
			content.append("<b>密码：" + getPasswd() + "</b><br /><br />");
			content.append("阁下可使用上述密码开启较早前电邮予阁下的文件。<br /><br />");
			content.append("如欲索取正本，您或获授权人士可前往香港港安医院—司徒拔道病理化验中心领取。<br /><br />");
			content.append("如有任何查询，请致电：<br />");
			content.append("电话：2835 0534（香港）<br />");
			content.append("办公时间：星期一至日，上午 9 时至下午 9 时<br /><br />");
			content.append("感谢选用本院服务。<br /><br />");
			content.append("====<br /><br />");
			content.append("此电子邮件消息（包括附件）中包含的信息可机密和/或法律的特权。 如阁下并非准收件人，则不得阅读、複製或向任何人披露该消息或该消息中包含的任何信息。若错误收到此讯息，请立即通知寄件人，并从您的所有系统中删除讯息。");
		
		} else {
			
			content.append("Dear Sir / Madam,<br /><br />");
			content.append("<b>Password: " + getPasswd() + "</b><br /><br />");
			content.append("The password above is for the document sent to you in a previous email.<br /><br />");
			content.append("If you wish to acquire a hard copy, you or an authorized person may collect the paperwork from the Clinical and Pathology Laboratory in HKAH-Stubbs Road.<br /><br />");
			content.append("Should you have any inquiries, please call:<br />");
			content.append("T: 28350534 (HK)<br />");
			content.append("Business hours: Mon to Sun, 9 am - 9 pm<br /><br />");
			content.append("Thank you for your attention.<br /><br />");
			content.append("====<br /><br />");
			content.append("This email and any attachments are confidential and may also be privileged. If you are not the intended recipient, you may not use, copy or disclose to anyone the message or any information contained in the message. If you have received the message in error, please advise the sender by reply e-mail and delete the message immediately.");
			
		}		
		
		return content.toString();
	}
	
	// ======================================================================
	private static String getMaskedNum(String num) {
		int maskedLen = 3;
		String maskChar = "X";
		int index = num.length() - maskedLen;
		String markedNum = "";
		
		if (num.length() <= maskedLen)
			return num;
		
		for (int i = 0; i < index; i++) {
			markedNum += maskChar;
		}
		
		return markedNum + num.substring(index);
	}	
	
	// ======================================================================
	private static boolean updateEmailErrorMsg(String labnum, String msg) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("UPDATE LABO_REPORT_LOG@LIS ");
		sqlStr.append(" SET PAT_EMAIL_STATUS = 'E', ");
		sqlStr.append(" PAT_RTNMSG = PAT_RTNMSG || ? || '; ' ");
		sqlStr.append(" WHERE LAB_NUM = ? ");
		sqlStr.append(" AND TEST_CAT in ('1', 'COVGQ')");
		
		return UtilDBWeb.updateQueue(sqlStr.toString(), new String[] { msg, labnum });
	}
	
	// ======================================================================
	private static boolean updateEmailSuccessTimeAndMsg(String labnum) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("UPDATE LABO_REPORT_LOG@LIS ");
		sqlStr.append(" SET PAT_EMAIL_STATUS = 'S', ");
		sqlStr.append(" PAT_NOTIFY_DATE = SYSDATE, ");
		sqlStr.append(" PAT_RTNMSG = PAT_RTNMSG || 'Email sent successfully; ' ");
		sqlStr.append(" WHERE LAB_NUM = ? ");
		sqlStr.append(" AND TEST_CAT in ('1', 'COVGQ')");

		return UtilDBWeb.updateQueue(sqlStr.toString(), new String[] {labnum});
	}
	
	// ======================================================================	
	private static String getSysParam(String key){
		
		String value = null;
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select PARAM1 from sysparam where parcde=?");
		
		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableListHATS(sqlStr.toString(), new String[] {key});
		ReportableListObject row = null;

		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			value = row.getValue(0);
		}
        
        return value;
	}
	
	// ======================================================================	
	private static String getPasswd(){
        return "1234hkah";
	}
	
	// ======================================================================	
    private static void copyFileUsingFileStreams(SmbFile source, File dest) throws IOException {
    	SmbFileInputStream input = null;
        OutputStream output = null;
        
        input = new SmbFileInputStream(source);
        output = new FileOutputStream(dest);
       
        byte[] buf = new byte[1024];
        int bytesRead;
       
        while ((bytesRead = input.read(buf)) > 0) {
    	   output.write(buf, 0, bytesRead);
        }
       
        input.close();
        output.close();
    }
}
