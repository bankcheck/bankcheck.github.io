package com.hkah.web.schedule;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.DateTimeUtil;
import com.hkah.util.mail.UtilMail;
import com.hkah.web.common.UserBean;
import com.hkah.web.db.DocumentDB2;
import com.hkah.web.db.hibernate.CoDocument;
import com.hkah.web.db.hibernate.CoDocumentMailList;

public class NotifyDocumentOnChangeJob implements Job {

	// ======================================================================
	private static Logger logger = Logger.getLogger(NotifyDocumentOnChangeJob.class);

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		// defined which document to check
		List<BigDecimal> documentIDs = new ArrayList<BigDecimal>();
		documentIDs.add(new BigDecimal("326"));

		UserBean userBean = new UserBean();
		userBean.setLoginID("SYSTEM");
		userBean.setUserName("SYSTEM");
		String from = ConstantsServerSide.MAIL_ALERT;

		BigDecimal coDocumentId = null;
		CoDocument coDocument = null;
		for (Iterator<BigDecimal> itr = documentIDs.iterator(); itr.hasNext();) {
			coDocumentId = itr.next();

			coDocument = DocumentDB2.getCoDocument(coDocumentId);
			if (coDocument != null && coDocument.getCoFileLastModified() == null) {
				if (DocumentDB2.setFileLastModified(coDocumentId, true, userBean)) {
					logger.info("Set document (ID: " + coDocumentId + ") last modified date.");
				} else {
					logger.info("Set document (ID: " + coDocumentId + ") last modified date fail.");
				}
			} else {
				// check file modified date
				List<String> to = null;
				List<String> cc = null;
				List<String> bcc = null;
				CoDocumentMailList mailList = null;
				List<CoDocumentMailList> mailLists = null;
				if (DocumentDB2.isFileModified(coDocumentId)) {
					// trigger send notification mail
					mailLists = DocumentDB2.getCoDocumentMailLists(coDocumentId);
					for (Iterator<CoDocumentMailList> itr2 = mailLists.iterator(); itr2.hasNext();) {
						mailList = itr2.next();
						if (mailList != null) {
							if ("from".equals(mailList.getCoSendType())) {
								from = mailList.getActualEmail();
							} else if ("to".equals(mailList.getCoSendType())) {
								to = (to == null ? new ArrayList<String>() : to);
								to.add(mailList.getActualEmail());
							} else if ("cc".equals(mailList.getCoSendType())) {
								cc = (cc == null ? new ArrayList<String>() : cc);
								cc.add(mailList.getActualEmail());
							} else if ("bcc".equals(mailList.getCoSendType())) {
								bcc = (bcc == null ? new ArrayList<String>() : bcc);
								bcc.add(mailList.getActualEmail());
							}
						}
					}

					// update file modified date
					if (DocumentDB2.setFileLastModified(coDocumentId, userBean)) {
						logger.info("Set document (ID: " + coDocumentId + ") last modified date.");
					} else {
						logger.info("Set document (ID: " + coDocumentId + ") last modified date fail.");
					}

					Date lastModifiedDate = null;
					if (coDocument.getCoFileLastModified() != null) {
						lastModifiedDate = new Date(coDocument.getCoFileLastModified().longValue());
					}

					// send notify email
					UtilMail.sendMail(from, to == null ? null : to.toArray(new String[to.size()]),
							cc == null ? null : cc.toArray(new String[cc.size()]),
							bcc == null ? null : bcc.toArray(new String[bcc.size()]),
							"File update notification. (" + coDocument.getFileName() + ")(TESTING)",
							"The file " + coDocument.getFileName() + " (location: " + coDocument.getCoLocation()
									+ ") has been updated" + (lastModifiedDate == null ? "."
											: " on " + DateTimeUtil.formatDateTimeWithoutSecond(lastModifiedDate)));

					logger.info("Send document change notification: (ID: " + coDocumentId + ") to " + to == null ? "N/A"
							: StringUtils.join(to.toArray(new String[to.size()]), ", "));
				}
			}
		}
	}
}