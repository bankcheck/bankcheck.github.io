package com.hkah.web.controller;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.util.ParserUtil;
import com.hkah.util.TextUtil;
import com.hkah.web.common.UserBean;
import com.hkah.web.db.DbCommentDB;
import com.hkah.web.db.hibernate.DbComment;
import com.hkah.web.db.hibernate.DbCommentId;

public class DiscussionBoardController extends AbstractController  {
    protected final Log logger = LogFactory.getLog(getClass());
    
    private static final String MODULE_NAME = "discussionBoard";
    
    private static final String VIEW_COMMENT_LIST = MODULE_NAME + "/comment_list";
    private static final String VIEW_COMMENT_DETAIL = MODULE_NAME + "/comment_detail";
	//---------
	// constant
	//---------
	public static String SITE_CODE = ConstantsServerSide.SITE_CODE;
	
    private String requestName;
    
    public ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	SITE_CODE = ConstantsServerSide.SITE_CODE;
    	
    	System.out.println("DEBUG: getRequestName() = " + getRequestName());
    	
    	if ("list".equals(getRequestName()) ) {
    		return getList(request, response);
    	} else if ("comment_list".equals(getRequestName()) ) {
    		return getCommentList(request, response);
    	} else if ("comment_detail".equals(getRequestName()) ) {
    		return getCommentDetail(request, response);
    	} else {
    		return null;
    	}
    }
    
    private ModelAndView getCommentList(HttpServletRequest request, HttpServletResponse response) {
    	HttpSession session = request.getSession();
    	UserBean userBean = new UserBean(request);
    	
    	String moduleName = ParserUtil.getParameter(request, "moduleName");
    	String command = ParserUtil.getParameter(request, "command");
    	String step = ParserUtil.getParameter(request, "step");
    	String moduleCode = ParserUtil.getParameter(request, "moduleCode");
    	String moduleDescription = ParserUtil.getParameter(request, "moduleDescription");
    	String recordTitle = ParserUtil.getParameter(request, "recordTitle");
    	String recordId = ParserUtil.getParameter(request, "recordId");
    	String topicDesc = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "topicDesc"));
    	String commentDesc = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "commentDesc"));

    	String message = request.getParameter("message");
    	String errorMessage = request.getParameter("errorMessage");
    	
    	List dbCommentList = null;
    	
    	//-----------------------------
    	// Logic for different commands
    	//-----------------------------
    	boolean createAction = false;
    	boolean updateAction = false;
    	boolean deleteAction = false;
    	boolean createCommentAction = false;
    	boolean updateCommentAction = false;
    	boolean editCommentAction = false;
    	boolean replyCommentAction = false;
    	boolean viewCommentAction = false;
    	boolean quickAddCommentAction = false;
    	boolean closeAction = false;
    	boolean allowToEdit = false;
    	
    	//-------------------
    	// Load comment list 
    	//-------------------
    	if ("create".equals(command)) {
    		createAction = true;
    	} else if ("update".equals(command)) {
    		updateAction = true;
    	} else if ("delete".equals(command)) {
    		deleteAction = true;
    	} else if ("createComment".equals(command)) {
    		createCommentAction = true;
    	} else if ("updateComment".equals(command)) {
    		updateCommentAction = true;
    	} else if ("editComment".equals(command)) {
    		editCommentAction = true;
    	} else if ("replyComment".equals(command)) {
    		replyCommentAction = true;	
    	} else if ("viewComment".equals(command)) {
    		viewCommentAction = true;
    	} else if ("quickAddComment".equals(command)) {
    		quickAddCommentAction = true;
    	}
    	
    	try {
    		if ("1".equals(step)) {
    			if (createCommentAction) {
    				if (DbCommentDB.addComment(SITE_CODE, moduleCode, recordId, topicDesc, commentDesc, userBean)) {
    					message = "New topic added.";
    					createCommentAction = false;
    				}
    			} else if (quickAddCommentAction) {
    				if (DbCommentDB.addComment(SITE_CODE, moduleCode, recordId, topicDesc, commentDesc, userBean)) {
    					message = "New topic added.";
    					quickAddCommentAction = false;
    				}
    			}
    			step = null;
    		}

    		// load data from database
    		if (!createAction && !"1".equals(step)) {
    			if (moduleCode != null && moduleCode.length() > 0) {
    				dbCommentList = DbCommentDB.getDbCommentListByModuleCodeRecordId(
    						SITE_CODE, moduleCode, new BigDecimal(recordId), null);
//    				}
    			} else {
    				closeAction = true;
    			}
    		}
    	} catch (Exception e) {
    		e.printStackTrace();
    	}

    	if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
    	if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
    	
    	Map<String, Object> model = new HashMap<String, Object>();
    	model.put("message", message);
    	model.put("errorMessage", errorMessage);
    	model.put("userBean", userBean);
    	model.put("dbCommentList", dbCommentList);
    	
    	model.put("createAction", createAction);
    	model.put("updateAction", updateAction);
    	model.put("deleteAction", deleteAction);
    	model.put("createCommentAction", createCommentAction);
    	model.put("updateCommentAction", updateCommentAction);
    	model.put("editCommentAction", editCommentAction);
    	model.put("replyCommentAction", replyCommentAction);
    	model.put("viewCommentAction", viewCommentAction);
    	model.put("closeAction", closeAction);
    	model.put("allowToEdit", allowToEdit);
    	
    	model.put("moduleDescription", moduleDescription);
    	model.put("recordTitle", recordTitle);
    	model.put("moduleCode", moduleCode);
    	model.put("recordId", recordId);
    	
    	return new ModelAndView(VIEW_COMMENT_LIST, MODULE_NAME, model);
    }
    
    /*
    private ModelAndView getCommentDetails(HttpServletRequest request, HttpServletResponse response) {
    	HttpSession session = request.getSession();
    	UserBean userBean = new UserBean(request);

    	String moduleName = ParserUtil.getParameter(request, "moduleName");
    	String moduleCode = ParserUtil.getParameter(request, "moduleCode");
    	String recordId = ParserUtil.getParameter(request, "recordId");
    	String commentId = ParserUtil.getParameter(request, "commentId");
    	String step = ParserUtil.getParameter(request, "step");
    	String enabled = ParserUtil.getParameter(request, "enabled");
    	String moduleDescription = ParserUtil.getParameter(request, "moduleDescription");
    	String comment = TextUtil.parseStrUTF8(request.getParameter("comment"));
    	String emailNotify = ParserUtil.getParameter(request, "emailNotify");
    	
    	String command = ParserUtil.getParameter(request, "command");
    	
    	System.out.println("DEBUG command = " + command);
    	System.out.println("DEBUG commentId = " + commentId);
    	System.out.println("DEBUG moduleCode = " + moduleCode);
    	System.out.println("DEBUG step = " + step);
    	System.out.println("DEBUG recordId = " + recordId);
    	
    	String message = ParserUtil.getParameter(request, "message");
    	String errorMessage = ParserUtil.getParameter(request, "errorMessage");
    	
    	//-----------------------------
    	// Logic for different commands
    	//-----------------------------
    	boolean createCommentAction = false;
    	boolean updateCommentAction = false;
    	boolean editCommentAction = false;
    	boolean replyCommentAction = false;
    	boolean viewCommentAction = false;
    	boolean closeAction = false;
    	boolean allowToEdit = false;
    	
    	//-------------------
    	// Load comment list 
    	//-------------------
    	if ("createComment".equals(command)) {
    		createCommentAction = true;
    	} else if ("updateComment".equals(command)) {
    		updateCommentAction = true;
    	} else if ("editComment".equals(command)) {
    		editCommentAction = true;
    	} else if ("replyComment".equals(command)) {
    		replyCommentAction = true;	
    	} else if ("viewComment".equals(command)) {
    		viewCommentAction = true;
    	}
    	
    	//------------
    	// Command logic
    	//------------
    	DbComment dbComment = null;
    	HashMap<String, String> staffsInfo = new HashMap<String, String>();
    	String fromStaffId = "";
    	
    	if ("1".equals(step)) {
			if (replyCommentAction) {
				DbCommentId id = new DbCommentId(SITE_CODE, moduleCode, 
						new BigDecimal(commentId), new BigDecimal(recordId));
				
				if (DbCommentDB.replyComment(userBean, id,
						comment, emailNotify)) {
					message = "comment updated.";
					replyCommentAction = false;
					// change to view comment
					viewCommentAction = true;
					command = "viewComment";
				} else {
					errorMessage = "comment update fail.";
				}
			}
			step = null;
    	}
    	
    	
    	if (updateCommentAction || editCommentAction || replyCommentAction || viewCommentAction) {
    		// reconstruct DbCommentId
    		DbCommentId id = new DbCommentId(SITE_CODE,
    				moduleCode, new BigDecimal(commentId), new BigDecimal(recordId));
    		dbComment = DbCommentDB.getDbComment(id);
    		
    		if (dbComment.getDbCommentContacts() != null) {
    			for (DbCommentContact contact : dbComment.getDbCommentContacts()) {
    				String userId = contact.getDbContactUserId();
    				if (contact != null && userId != null && userId.length() > 0) {
    					staffsInfo.put(userId, contact.getStaffName() + " (" + contact.getDepartmentDesc() + ")");
    				} else {
    					staffsInfo.put(userId, userId);
    				}
    				
    				if ("from".equals(contact.getDbContactType())) {
    					fromStaffId = userId;
    				}
    			}
    		}
    	} else if (createCommentAction) {
    		dbComment = new DbComment(new DbCommentId(SITE_CODE,
    				moduleCode, null, new BigDecimal(recordId)), 
    				new DbCommentTypes(new DbCommentTypesId("general", "haa")), 1);
    	}

    	if (enabled == null) {
    		enabled = ConstantsVariable.ONE_VALUE;
    	}

    	if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
    	if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
    	
    	Map<String, Object> model = new HashMap<String, Object>();
    	model.put("message", message);
    	model.put("errorMessage", errorMessage);
    	model.put("userBean", userBean);
    	model.put("comment", dbComment);
    	model.put("commentHistories", dbComment.getDbCommentHistories());
    	model.put("staffsInfo", staffsInfo);
    	model.put("fromStaffId", fromStaffId);
    	model.put("enabled", enabled);
    	
    	model.put("createCommentAction", createCommentAction);
    	model.put("updateCommentAction", updateCommentAction);
    	model.put("editCommentAction", editCommentAction);
    	model.put("replyCommentAction", replyCommentAction);
    	model.put("viewCommentAction", viewCommentAction);
    	model.put("closeAction", closeAction);
    	model.put("allowToEdit", allowToEdit);
    	
    	model.put("moduleName", moduleName);
    	model.put("moduleDescription", moduleDescription);
    	model.put("moduleCode", moduleCode);
    	model.put("recordId", recordId);
    	
    	logger.info("DEBUG: viewCommentAction = " + viewCommentAction + ", allowToEdit = " + allowToEdit); 
    	
    	return new ModelAndView("discussionBoard/comment_details", MODULE_NAME, model);
    }
    */
    
    private ModelAndView getList(HttpServletRequest request, HttpServletResponse response) {
    	logger.info("DiscussionBoardController.getList()");
    	
    	String siteCode = request.getParameter("siteCode");
    	String moduleCode = request.getParameter("moduleCode");
    	String recordId = request.getParameter("recordId");
    	String moduleName = request.getParameter("moduleName");
    	
    	Map<String, Object> model = getModelMap(request, response, 
    				siteCode, moduleCode, moduleName, recordId, null, null);
    	if (model != null) {
    		// return to the last navigating page
    		String dbListCurPage = request.getParameter("dbListCurPage");
    		System.out.println("DEBUG 442 dbListCurPage = " + dbListCurPage);
    		if (dbListCurPage != null) {
    			String requestName = "d-442775-p";
    			System.out.println("DEBUG: set request attribute " + requestName + " = " + dbListCurPage);
    			// PROBLEM: cannot pass dbListCurPage as a url parameer
    			//model.put(requestName, dbListCurPage);
    		}
    	}
    	
    	return new ModelAndView("discussionBoard/list", MODULE_NAME, model);
    }
	
    private ModelAndView getCommentDetail(HttpServletRequest request, HttpServletResponse response) {
    	HttpSession session = request.getSession();
    	UserBean userBean = new UserBean(request);

    	String moduleName = ParserUtil.getParameter(request, "moduleName");
    	String siteCode = ParserUtil.getParameter(request, "siteCode");
    	String moduleCode = ParserUtil.getParameter(request, "moduleCode");
    	String recordId = ParserUtil.getParameter(request, "recordId");
    	String recordTitle = ParserUtil.getParameter(request, "recordTitle");
    	String dbListCurPage = ParserUtil.getParameter(request, "dbListCurPage");
    	String commentId = ParserUtil.getParameter(request, "commentId");
    	String commentHistoryId = ParserUtil.getParameter(request, "commentHistoryId");
    	String step = ParserUtil.getParameter(request, "step");
    	String enabled = ParserUtil.getParameter(request, "enabled");
    	String moduleDescription = ParserUtil.getParameter(request, "moduleDescription");
    	String comment = parseStrUTF8(request.getParameter("comment"), "UTF-8");
    	String commentTopic = parseStrUTF8(request.getParameter("commentTopic"), "UTF-8");
    	String commentHistoryDesc = parseStrUTF8(request.getParameter("commentHistoryDesc"), "UTF-8");
    	String emailNotify = ParserUtil.getParameter(request, "emailNotify");
    	String command = ParserUtil.getParameter(request, "command");
    	
    	String message = ParserUtil.getParameter(request, "message");
    	String errorMessage = ParserUtil.getParameter(request, "errorMessage");
    	
    	//-----------------------------
    	// Logic for different commands
    	//-----------------------------
    	boolean createCommentAction = false;
    	boolean updateCommentAction = false;
    	boolean editCommentAction = false;
    	boolean replyCommentAction = false;
    	boolean viewCommentAction = false;
    	boolean editCommentHistoryAction = false;
    	boolean closeAction = false;
    	boolean allowToEdit = false;
    	
    	//------------
    	// Command logic
    	//------------
    	if ("createComment".equals(command)) {
    		createCommentAction = true;
    	} else if ("updateComment".equals(command)) {
    		updateCommentAction = true;
    	} else if ("editComment".equals(command)) {
    		editCommentAction = true;
    	} else if ("replyComment".equals(command)) {
    		replyCommentAction = true;	
    	} else if ("viewComment".equals(command)) {
    		viewCommentAction = true;
    	} else if ("editCommentHistory".equals(command)) {
    		editCommentHistoryAction = true;
    	}
    	

    	DbComment dbComment = null;
    	List<DbComment> dbComments = null;
    	HashMap<String, String> staffsInfo = new HashMap<String, String>();
    	String fromStaffId = "";
    	
    	if ("1".equals(step)) {
			DbCommentId id = new DbCommentId(SITE_CODE, moduleCode, 
					new BigDecimal(commentId), new BigDecimal(recordId), null);
			
			if (replyCommentAction) {
				if (DbCommentDB.replyComment(userBean, id,
						comment, emailNotify)) {
					message = "Reply added.";
					replyCommentAction = false;
				} else {
					errorMessage = "Reply create fail.";
				}
			} 
//			else if (createCommentAction) {
//	    		dbComment = new DbComment(new DbCommentId(SITE_CODE,
//	    				moduleCode, null, new BigDecimal(recordId)), 
//	    				new DbCommentTypes(new DbCommentTypesId("general", "haa")), 1);
//	    		
//	    		//commentType, commentTopic, comment, involveDeptCode, involveUserID, deadline,
//				//fromStaffID, toStaffID, toEmail, ccStaffID, ccEmail, emailNotify
//	    		dbComment.setDbCommentTypes2("general");
//	    		dbComment.setDbTopicDesc(commentTopic);
//	    		dbComment.setDbCommentDesc(comment);
//	    		dbComment.setDbEmailNotify(emailNotify);
//	    		dbComment.setDbEnabled(1);
//	    		dbComment.setDbCreatedDate(new Date());
//	    		dbComment.setDbCreatedUser(userBean.getLoginID());
//	    		dbComment.setDbModifiedDate(new Date());
//	    		dbComment.setDbModifiedUser(userBean.getLoginID());
//	    		
//    			// add comment contacts
//	    		DbCommentContact contact = new DbCommentContact();
//	    		contact.setId(new DbCommentContactId(SITE_CODE,
//	    				moduleCode, new BigDecimal(recordId), dbComment.getId().getDbCommentId(), null));
//	    		contact.setDbContactType("from");
//	    		contact.setDbContactUserId("test");
//	    		contact.setDbContactUserType("staff");
//	    		contact.setDbContactEmail(null);
//	    		contact.setDbEnabled(1);
//	    		contact.setDbCreatedDate(new Date());
//	    		contact.setDbCreatedUser(userBean.getLoginID());
//	    		contact.setDbModifiedDate(new Date());
//	    		contact.setDbModifiedUser(userBean.getLoginID());
//	    		
//	    		dbComment.getDbCommentContacts().add(contact);
//	    		
//	    		if(DbCommentDB.add(dbComment)) {
//	    			message = "new comment added.";
//					createCommentAction = false;
//				} else {
//					errorMessage = "new comment add fail.";
//				}
//			} 
//			else if (editCommentHistoryAction) {
//				if (commentHistoryId != null && 
//						DbCommentDB.updateDbCommentHistory(new DbCommentHistoryId(siteCode, moduleCode,
//						new BigDecimal(commentId), new BigDecimal(commentHistoryId), 
//						new BigDecimal(recordId)), 
//						userBean, commentHistoryDesc)) {
//	    			message = "comment updated.";
//	    			editCommentHistoryAction = false;
//	    			viewCommentAction = true;
//				} else {
//					errorMessage = "update comment fail.";
//				}
//			}
			
			step = null;
    	}
    	
    	// Load DbComment and its association
//    	public DbCommentId(String dbSiteCode, String dbModuleCode,
//    			BigDecimal dbCommentId, BigDecimal dbRecordId,
//    			BigDecimal dbCommentSeq) {
    	
    	if (!createCommentAction) {
    		DbCommentId id = new DbCommentId(SITE_CODE, moduleCode, 
    				new BigDecimal(commentId), new BigDecimal(recordId), null);
    		dbComments = DbCommentDB.getDbCommentWithAllReplies(id);
    		if (dbComments != null && !dbComments.isEmpty()) {
    			dbComment = dbComments.get(dbComments.size() - 1);	// get the starting thread
    		}
    		
//    		if (dbComment != null && dbComment.getDbCommentContacts() != null) {
//    			for (DbCommentContact contact : dbComment.getDbCommentContacts()) {
//    				String userId = contact.getDbContactUserId();
//    				if (contact != null && userId != null && userId.length() > 0) {
//    					System.out.println("DEBUG: get staffInfo list: contact.getStaffName() = " + contact.getStaffName() +
//    							", contact.getDepartmentDesc() = " + contact.getDepartmentDesc() + 
//    							", contact.getDbContactUserId() = " + contact.getDbContactUserId());
//    					staffsInfo.put(userId, contact.getStaffName() + " (" + contact.getDepartmentDesc() + ")");
//    				} else {
//    					System.out.println("DEBUG: get staffInfo list: userId = " + userId);
//    					staffsInfo.put(userId, userId);
//    				}
//    				
//    				if ("from".equals(contact.getDbContactType())) {
//    					fromStaffId = userId;
//    				}
//    			}
//    		}
    	}
    	

    	if (enabled == null) {
    		enabled = ConstantsVariable.ONE_VALUE;
    	}

    	if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
    	if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
    	
    	Map<String, Object> model = new HashMap<String, Object>();
    	model.put("message", message);
    	model.put("errorMessage", errorMessage);
    	model.put("userBean", userBean);
    	model.put("comment", dbComment);
    	model.put("comments", dbComments);
    	model.put("staffsInfo", staffsInfo);
    	model.put("fromStaffId", fromStaffId);
    	model.put("enabled", enabled);
    	
    	model.put("createCommentAction", createCommentAction);
    	model.put("updateCommentAction", updateCommentAction);
    	model.put("editCommentAction", editCommentAction);
    	model.put("replyCommentAction", replyCommentAction);
    	model.put("viewCommentAction", viewCommentAction);
    	model.put("editCommentHistoryAction", editCommentHistoryAction);
    	model.put("closeAction", closeAction);
    	model.put("allowToEdit", allowToEdit);
    	
    	model.put("siteCode", siteCode);
    	model.put("moduleCode", moduleCode);
    	model.put("moduleName", moduleName);
    	model.put("moduleDescription", moduleDescription);
    	model.put("recordId", recordId);
    	model.put("recordTitle", recordTitle);
    	model.put("dbListCurPage", dbListCurPage);
   		model.put("commentHistoryId", commentHistoryId);
   		
    	return new ModelAndView(VIEW_COMMENT_DETAIL, MODULE_NAME, model);
    }
    
	public String getRequestName() {
		return requestName;
	}

	public void setRequestName(String requestName) {
		this.requestName = requestName;
	}
	
	/**
	 * to parse string for handle non-western character
	 * @param value
	 * @return
	 */
	public static String parseStrUTF8(String value, String charsetName) {
		value = TextUtil.parseStr(value);
		if (value.length() > 0) {
			try {
				value = new String(value.getBytes(charsetName), "UTF-8");
			} catch (UnsupportedEncodingException e) {}
		}
		return value;
	}

	public static Map<String, Object> getModelMap(HttpServletRequest request, HttpServletResponse response, 
			String siteCode, String moduleCode, String moduleDescription, String recordId, String recordTitle, Integer numOfTopics) {
		String dbCommand = ParserUtil.getParameter(request, "dbCommand");
		
    	//-----------------------------
    	// Logic for different commands
    	//-----------------------------
		boolean listCommentAction = false;
    	boolean createCommentAction = false;
    	boolean updateCommentAction = false;
    	boolean editCommentAction = false;
    	boolean replyCommentAction = false;
    	boolean viewCommentAction = false;
    	boolean closeAction = false;
    	boolean allowToEdit = false;
    	
    	//-------------------
    	// Load comment list 
    	//-------------------
		if ("listComments".equals(dbCommand)) {
			listCommentAction = true;
		} else if ("createComment".equals(dbCommand)) {
    		createCommentAction = true;
    	} else if ("updateComment".equals(dbCommand)) {
    		updateCommentAction = true;
    	} else if ("editComment".equals(dbCommand)) {
    		editCommentAction = true;
    	} else if ("replyComment".equals(dbCommand)) {
    		replyCommentAction = true;	
    	} else if ("viewComment".equals(dbCommand)) {
    		viewCommentAction = true;
    	} else {
    		listCommentAction = true;
    	}
		
		List<DbComment> dbCommentList = null;
		Integer totalNumOfComments = null; 
		try {
			if (listCommentAction) {
				dbCommentList = DbCommentDB.getDbCommentListByModuleCodeRecordId(
						SITE_CODE, moduleCode, new BigDecimal(recordId), numOfTopics);
				totalNumOfComments = DbCommentDB.getTotalNumOfDbCommentListByModuleCodeRecordId(
						SITE_CODE, moduleCode, new BigDecimal(recordId));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		Map<String, Object> model = new HashMap<String, Object>();
    	model.put("listCommentAction", listCommentAction);
    	model.put("createCommentAction", createCommentAction);
    	model.put("updateCommentAction", updateCommentAction);
    	model.put("editCommentAction", editCommentAction);
    	model.put("replyCommentAction", replyCommentAction);
    	model.put("viewCommentAction", viewCommentAction);
    	model.put("closeAction", closeAction);
    	model.put("allowToEdit", allowToEdit);
    	
    	model.put("dbCommentList", dbCommentList);
    	model.put("totalNumOfComments", totalNumOfComments);
    	
    	model.put("siteCode", siteCode);
    	model.put("moduleCode", moduleCode);
    	model.put("moduleDescription", moduleDescription);
    	model.put("recordId", recordId);
    	model.put("recordTitle", recordTitle);
    	
		return model;
	}
}
