package com.hkah.web.displaytag;

import java.util.Date;

import org.displaytag.decorator.TableDecorator;

import com.hkah.util.DateTimeUtil;
import com.hkah.web.db.hibernate.DbComment;

public class DiscussionBoardListDecorator extends TableDecorator {
	
	public String getFormattedCreatedDate() {
		DbComment dbComment = (DbComment) getCurrentRowObject(); 
		
		Date createdDate = dbComment.getDbCreatedDate();
		
		String creadedDateStr = "";
		if (createdDate != null) {
			creadedDateStr = DateTimeUtil.formatDateTime(createdDate);
		}
		
		return creadedDateStr;
	}
	
	public String getFormattedModifiedDate() {
		DbComment dbComment = (DbComment) getCurrentRowObject(); 
		
		Date modifiedDate = dbComment.getDbModifiedDate();
		
		String modifiedDateStr = "";
		if (modifiedDate != null) {
			modifiedDateStr = DateTimeUtil.formatDateTime(modifiedDate);
		}
		
		return modifiedDateStr;
	}
	
	public String getFormattedLastPostDate() {
		DbComment dbComment = (DbComment) getCurrentRowObject(); 
		
		Date lastPostDate = dbComment.getLastPostDate();
		
		String lastPostDateStr = "";
		if (lastPostDate != null) {
			lastPostDateStr = DateTimeUtil.formatDateTime(lastPostDate);
		}
		
		return lastPostDateStr;
	}
	
	public String getTopicDescWithLink() {
		DbComment dbComment = (DbComment) getCurrentRowObject();
        String link = "";
        if (dbComment != null && dbComment.getId() != null) {
        	link = 	"<a href=\"javascript: dbCommentListForm_viewCommentAction('viewComment', '" + dbComment.getId().getDbCommentId() + "')\">" + (dbComment.getDbTopicDesc() == null ? "" : dbComment.getDbTopicDesc()) + "</a>";
        }
        
        return link;
	}
	
	public String getTopicDescWithLinkNewWindow() {
		DbComment dbComment = (DbComment) getCurrentRowObject();
        String link = "";
        if (dbComment != null && dbComment.getId() != null) {
        	link = 	"<a href=\"javascript: void(0);\" onclick=\"return dbListForm_viewCommentAction('viewComment', '" + dbComment.getId().getDbCommentId() + "')\">" + (dbComment.getDbTopicDesc() == null ? "" : dbComment.getDbTopicDesc()) + "</a>";
        }
        
        return link;
	}
}
