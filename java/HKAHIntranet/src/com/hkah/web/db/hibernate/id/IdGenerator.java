package com.hkah.web.db.hibernate.id;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Iterator;

import org.hibernate.engine.SessionImplementor;
import org.hibernate.id.IdentityGenerator;

import com.hkah.web.db.CRMPromotionDB2;
import com.hkah.web.db.CoDocscanDB;
import com.hkah.web.db.DbCommentDB;
import com.hkah.web.db.DocumentDB2;
import com.hkah.web.db.HAACheckListDB2;
import com.hkah.web.db.StaffEducationDB;
import com.hkah.web.db.hibernate.CoDocscan;
import com.hkah.web.db.hibernate.CoDocscanId;
import com.hkah.web.db.hibernate.CoDocument;
import com.hkah.web.db.hibernate.CoEvent;
import com.hkah.web.db.hibernate.CoEventId;
import com.hkah.web.db.hibernate.CrmPromotion;
import com.hkah.web.db.hibernate.CrmPromotionDepartment;
import com.hkah.web.db.hibernate.CrmPromotionEnquiry;
import com.hkah.web.db.hibernate.CrmPromotionEnquiryId;
import com.hkah.web.db.hibernate.CrmPromotionInstruction;
import com.hkah.web.db.hibernate.CrmPromotionInstructionId;
import com.hkah.web.db.hibernate.CrmPromotionTarget;
import com.hkah.web.db.hibernate.CrmTarget;
import com.hkah.web.db.hibernate.DbComment;
import com.hkah.web.db.hibernate.DbCommentHistory;
import com.hkah.web.db.hibernate.DbCommentHistoryId;
import com.hkah.web.db.hibernate.DbCommentId;
import com.hkah.web.db.hibernate.EeMenuContent;
import com.hkah.web.db.hibernate.EeMenuContentId;
import com.hkah.web.db.hibernate.HaaChecklist;
import com.hkah.web.db.hibernate.HaaChecklistId;

public class IdGenerator extends IdentityGenerator  {
	/* (non-Javadoc)
	 * @see org.hibernate.id.AbstractPostInsertGenerator#generate(org.hibernate.engine.SessionImplementor, java.lang.Object)
	 */
	@Override
	public Serializable generate(SessionImplementor s, Object obj) {
		// TODO Auto-generated method stub

		if (obj != null) {
			if (obj instanceof HaaChecklist) {
				String nextHaaChecklistId = HAACheckListDB2.getNextHaaID();
				String haaSiteCode = null;
				HaaChecklistId id = ((HaaChecklist) obj).getId();
				if (id != null) {
					haaSiteCode = id.getHaaSiteCode();
				}
				return new HaaChecklistId(haaSiteCode, Integer.parseInt(nextHaaChecklistId));
			}
			else if (obj instanceof DbComment) {
				String dbSiteCode = null;
				String dbModuleCode = null;
				BigDecimal dbRecordId = null;
				BigDecimal dbCommentId = null;
				BigDecimal dbCommentSeq = null;
				
				DbCommentId id = ((DbComment) obj).getId();
				if (id != null) {
					dbSiteCode = id.getDbSiteCode();
					dbModuleCode = id.getDbModuleCode();
					dbRecordId = id.getDbRecordId();
					dbCommentId = id.getDbCommentId();
					dbCommentSeq = id.getDbCommentSeq();
					if (dbCommentId == null) {
						dbCommentId = DbCommentDB.getNextDbCommentId(id);
					}
					if (dbCommentSeq == null) {
						dbCommentSeq = DbCommentDB.getNextDbCommentSeq(id);
					}
				}
				return new DbCommentId(dbSiteCode, dbModuleCode, dbCommentId, dbRecordId, dbCommentSeq);
			}
			else if (obj instanceof DbCommentHistory) {
				String nextDbCommentHistoryId = null;
				String dbSiteCode = null;
				String dbModuleCode = null;
				BigDecimal dbRecordId = null;
				BigDecimal dbCommentId = null;
				BigDecimal dbCommentSeq = null;
				
				DbCommentHistoryId id = ((DbCommentHistory) obj).getId();
				if (id != null) {
					dbSiteCode = id.getDbSiteCode();
					dbModuleCode = id.getDbModuleCode();
					dbRecordId = id.getDbRecordId();
					dbCommentId = id.getDbCommentId();
					dbCommentSeq = id.getDbCommentSeq();
					nextDbCommentHistoryId = DbCommentDB.getNextDbCommentHistoryId(id);
				}
				return new DbCommentHistoryId(dbSiteCode, dbModuleCode, dbCommentId, dbRecordId, dbCommentSeq, new BigDecimal(nextDbCommentHistoryId));
			}
			else if (obj instanceof CoDocument) {
				return DocumentDB2.getNextCoDocumentId();
			}
			else if (obj instanceof EeMenuContent) {
				String nextEeMenuContentId = null;
				String eeSiteCode = null;
				
				EeMenuContentId id = ((EeMenuContent) obj).getId();
				if (id != null) {
					eeSiteCode = id.getEeSiteCode();
					nextEeMenuContentId = StaffEducationDB.getNextEeMenuContentId(id);
				}
				return new EeMenuContentId(eeSiteCode, new BigDecimal(nextEeMenuContentId));
			}
			else if (obj instanceof CoEvent) {
				CoEvent event = (CoEvent) obj;
				CoEventId id = ((CoEvent) obj).getId();
				BigDecimal crmEventId = null;
				if (id != null) {
					crmEventId = CRMPromotionDB2.getNextCoEventId(id);
					id.setCoEventId(crmEventId);
					CrmPromotion promotion = null;
					if (event != null) {
						promotion = event.getCrmPromotion();
						if (promotion.getCrmPromotionDepartments() != null) {
							for (Iterator<CrmPromotionDepartment> itr = promotion.getCrmPromotionDepartments().iterator(); itr.hasNext(); ) {
								itr.next().getId().setCrmEventId(crmEventId);
							}
						}
						if (promotion.getCrmPromotionTargets() != null) {
							for (Iterator<CrmPromotionTarget> itr = promotion.getCrmPromotionTargets().iterator(); itr.hasNext(); ) {
								itr.next().getId().setCrmEventId(crmEventId);
							}
						}
						if (promotion.getCrmPromotionEnquiries() != null) {
							for (Iterator<CrmPromotionEnquiry> itr = promotion.getCrmPromotionEnquiries().iterator(); itr.hasNext(); ) {
								itr.next().getId().setCrmEventId(crmEventId);
							}
						}
						if (promotion.getCrmPromotionInstructions() != null) {
							for (Iterator<CrmPromotionInstruction> itr = promotion.getCrmPromotionInstructions().iterator(); itr.hasNext(); ) {
								itr.next().getId().setCrmEventId(crmEventId);
							}
						}
					}
				}
				
				return id;
			}
			else if (obj instanceof CrmPromotionInstruction) {
				CrmPromotionInstructionId id = ((CrmPromotionInstruction) obj).getId();
				if (id != null) {
					id.setCrmPromoInstrPid(CRMPromotionDB2.getNextCrmPromoInstrPid(id));
				}
				return id;
			}
			else if (obj instanceof CrmPromotionEnquiry) {
				CrmPromotionEnquiryId id = ((CrmPromotionEnquiry) obj).getId();
				if (id != null) {
					id.setCrmPromoEnqPid(CRMPromotionDB2.getNexCrmPromoEnqPid(id));
				}
				return id;
			}
			else if (obj instanceof CrmTarget) {
				return CRMPromotionDB2.getNextCrmTargetId();
			}
			else if (obj instanceof CoDocscan) {
				String nextCoDocscanId = null;
				String coSiteCode = null;
				
				CoDocscanId id = ((CoDocscan) obj).getId();
				if (id != null) {
					coSiteCode = id.getCoSiteCode();
					nextCoDocscanId = CoDocscanDB.getNextCoDocscanId(id);
				}
				return new CoDocscanId(coSiteCode, new BigDecimal(nextCoDocscanId));
			}
		}
		
		return null;
	}
}
