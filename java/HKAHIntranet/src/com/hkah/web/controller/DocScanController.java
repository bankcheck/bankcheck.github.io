package com.hkah.web.controller;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.hkah.config.MessageResources;
import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.util.FileUtil;
import com.hkah.util.ParserUtil;
import com.hkah.util.TextUtil;
import com.hkah.util.upload.HttpFileUpload;
import com.hkah.web.common.UserBean;
import com.hkah.web.db.CoDocscanDB;
import com.hkah.web.db.DocumentDB;
import com.hkah.web.db.helper.DocscanModelHelper;
import com.hkah.web.db.hibernate.CoDocscan;
import com.hkah.web.db.hibernate.CoDocscanDocumentId;
import com.hkah.web.db.hibernate.CoDocscanId;

public class DocScanController extends AbstractController  {
    protected final Log logger = LogFactory.getLog(getClass());
    
    public static final String MODULE_NAME = "documentManage";
    
    public static final String VIEW_DOC_SCANNING_LIST = MODULE_NAME + "/doc_scanning_list";
    public static final String VIEW_DOC_SCANNING_DETAIL = MODULE_NAME + "/doc_scanning_detail";
    private static final String UPLOAD_SUB_PATH =	File.separator + "Intranet" + 
    												File.separator + "Portal" +
    												File.separator + "Document Scanning";  
    
    private String requestName;
    
	public String getRequestName() {
		return requestName;
	}

	public void setRequestName(String requestName) {
		this.requestName = requestName;
	}

    public ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	 
    	if ("doc_scanning_list".equals(getRequestName())) {
    		return getDocScanningList(request, response);
    	} else if ("doc_scanning_detail".equals(getRequestName())) {
    		return getDocScanningDetails(request, response);
    	} else {
    		return null;
    	}
    }
    
    private ModelAndView getDocScanningList(HttpServletRequest request, HttpServletResponse response) {
    	UserBean userBean = new UserBean(request);
    	HttpSession session = request.getSession();
    	
    	String command = ParserUtil.getParameter(request, "cmd");
    	String cid = ParserUtil.getParameter(request, "cid");
    	BigDecimal cid_BD = null;
    	try {
    		cid_BD = new BigDecimal(cid);
    	} catch (Exception e) {
    	}
    	String grandCid = ParserUtil.getParameter(request, "grandCid");
    	String parentCid = ParserUtil.getParameter(request, "parentCid");
    	String level = ParserUtil.getParameter(request, "level");
    	String step = ParserUtil.getParameter(request, "step");
    	String[] contentOrder = request.getParameterValues("row[]");
    	
    	String message = request.getParameter("message");
    	String errorMessage = request.getParameter("errorMessage");

    	List<CoDocscan> coDocscanList = null;
    	List<CoDocscan> ancestors = null;
    	
    	boolean createAction = false;
    	boolean updateSortOrderAction = false;
    	boolean closeAction = false;

    	if ("create".equals(command)) {
    		createAction = true;
    	} else if ("updateSortOrder".equals(command)) {
    		updateSortOrderAction = true;
    	}
    	
    	try {
    		if ("1".equals(step)) {
    			if (updateSortOrderAction) {
    				if (contentOrder != null) {
    					BigDecimal[] contentOrder_BD = new BigDecimal[contentOrder.length];
    					int i = 0;
    					for (String order: contentOrder) {
    						try {
    							contentOrder_BD[i] = new BigDecimal(order);
    						} catch (NumberFormatException nfe) {
    							contentOrder_BD[i] = null;
    						}
    						i++;
    					}
    					
	    				if(CoDocscanDB.updateCoDocscanSortOrder(ConstantsServerSide.SITE_CODE, contentOrder_BD, userBean)) {
	    					message = MessageResources.getMessage(session, "message.doc_scanning.displayOrderUpdateSuccess");
	    				} else {
	    					errorMessage = MessageResources.getMessage(session, "message.doc_scanning.displayOrderUpdateFail");
	    				}
    				} else {
    					errorMessage = MessageResources.getMessage(session, "message.doc_scanning.displayOrderNoChange");
    				}
    				updateSortOrderAction = false;
    			}
    			step = null;
    		}
    		
			coDocscanList = CoDocscanDB.getCoDocscanList(cid_BD);
			
    		// get an ancestor list for breadcrumb navigation, limit to max 5 level only
    		ancestors = CoDocscanDB.getCoDocscanAncestors(new CoDocscanId(ConstantsServerSide.SITE_CODE, cid_BD));
    		
    		// set hierarchy level info
    		parentCid = null;
    		if (ancestors != null && ancestors.size() > 0) {
   				CoDocscan parent = ancestors.get(ancestors.size() - 1);
				parentCid = parent.getId().getCoDocscanId_String();
    		}
    		grandCid = null;
    		if (ancestors != null && ancestors.size() > 1) {
   				CoDocscan grand = ancestors.get(ancestors.size() - 2);
				grandCid = grand.getId().getCoDocscanId_String();
    		}
    		if (ancestors != null) {
    			level = String.valueOf(ancestors.size());
    		} else {
    			level = String.valueOf(0);
    		}
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
    	
    	if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
    	if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
    	
    	Map<String, Object> model = new HashMap<String, Object>();
    	model.put("message", message);
    	model.put("errorMessage", errorMessage);
    	
    	model.put("command", command);
    	model.put("level", level);
    	model.put("grandCid", grandCid);
    	model.put("parentCid", parentCid);
    	
    	model.put("userBean", userBean);
    	model.put("list", coDocscanList);
    	model.put("ancestors", ancestors);
    	
    	return new ModelAndView(VIEW_DOC_SCANNING_LIST, MODULE_NAME, model);
    }
    
    private ModelAndView getDocScanningDetails(HttpServletRequest request, HttpServletResponse response) {
    	boolean fileUpload = false;
    	boolean isUrlSpecified = false;
    	boolean isFilePathSpecified = false;
    	boolean isRemoveDocument = false;
    	if (HttpFileUpload.isMultipartContent(request)){
    		HttpFileUpload.toUploadFolder(
    			request,
    			ConstantsServerSide.DOCUMENT_FOLDER,
    			ConstantsServerSide.TEMP_FOLDER,
    			ConstantsServerSide.UPLOAD_FOLDER
    		);
    		fileUpload = true;
    	}
    	
    	UserBean userBean = new UserBean(request);
    	HttpSession session = request.getSession();
    	
    	String command = ParserUtil.getParameter(request, "command");
    	String cid = ParserUtil.getParameter(request, "cid");
    	String parentCid = ParserUtil.getParameter(request, "parentCid");
    	String level = ParserUtil.getParameter(request, "level");
    	String step = ParserUtil.getParameter(request, "step");
    	String fileMethod = ParserUtil.getParameter(request, "fileMethod");
    	isUrlSpecified = "url".equals(fileMethod);
    	isFilePathSpecified = "filePath".equals(fileMethod);
    	isRemoveDocument = "remove".equals(fileMethod);
    	
    	String coDescriptionEn = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "coDescriptionEn"));
    	String coDescriptionZh = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "coDescriptionZh"));
    	String url = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "url"));
    	String filePath = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "filePath"));
    	
    	String message = request.getParameter("message");
    	String errorMessage = request.getParameter("errorMessage");
    	
    	BigDecimal coDocscanId_BD = null;
    	try {
    		coDocscanId_BD = new BigDecimal(cid);
    	} catch (Exception e) {
    		coDocscanId_BD = new BigDecimal(-1);
    	}
    	BigDecimal coParentCoDocscanId_BD = null;
    	try {
    		coParentCoDocscanId_BD = new BigDecimal(parentCid);
    	} catch (Exception e) {
    	}
    	CoDocscanId coDocscanId = new CoDocscanId(ConstantsServerSide.SITE_CODE, coDocscanId_BD);
    	CoDocscanDocumentId coDocscanDocumentId = new CoDocscanDocumentId(ConstantsServerSide.SITE_CODE, coDocscanId_BD);
    	
    	CoDocscan coDocscan = null;
    	List<CoDocscan> ancestors = null;
    	
    	boolean createAction = false;
    	boolean updateAction = false;
    	boolean deleteAction = false;
    	boolean closeAction = false;

    	if ("create".equals(command)) {
    		createAction = true;
    	} else if ("update".equals(command)) {
    		updateAction = true;
    	} else if ("delete".equals(command)) {
    		deleteAction = true;
    	}
    	
    	try {
    		if ("1".equals(step)) {
    			if (createAction) {
    				boolean createSuccess = false;
    		    	
    				coDocscan = CoDocscanDB.addCoDocscan(ConstantsServerSide.SITE_CODE, coParentCoDocscanId_BD,
    						coDescriptionEn, coDescriptionZh, userBean);
    				if (coDocscan != null) {
    					createSuccess = true;
    					coDocscanId = coDocscan.getId();
    				}
    				
    				if(createSuccess) {
        				if (isUrlSpecified && !StringUtils.isEmpty(url)) {
        					processUrl(request, coDocscanId, url, userBean);
        				} else if (isFilePathSpecified) {
        					processFilePath(request, coDocscanId, filePath, userBean);
        				} else if (fileUpload) {
        					processUploadedDocument(request, coDocscanId, userBean);
        				}
        				
    					message = MessageResources.getMessage(session, "message.doc_scanning.createSuccess");
    				} else {
    					errorMessage = MessageResources.getMessage(session, "message.doc_scanning.createFail");
    				}
    				
    				createAction = false;
    			} else if (updateAction) {
    				boolean updateSuccess = false;
    				
    				updateSuccess = CoDocscanDB.updateCoDocscan(coDocscanId, coDescriptionEn, coDescriptionZh, userBean);
    				if (isRemoveDocument) {
    					DocumentDB.delete(coDocscanId.getCoSiteCode(), userBean, 
    							DocscanModelHelper.MODULE_CODE, coDocscanId.getCoDocscanId().toEngineeringString());
    					updateSuccess = CoDocscanDB.deleteCoDocscanDocument(coDocscanDocumentId, userBean);
    				} else if (isUrlSpecified && !StringUtils.isEmpty(url)) {
    					processUrl(request, coDocscanId, url, userBean);
    				} else if (isFilePathSpecified) {
    					processFilePath(request, coDocscanId, filePath, userBean);
    				} else if (fileUpload) {
    					processUploadedDocument(request, coDocscanId, userBean);
    				}
    				
    				if(updateSuccess) {
    					message = MessageResources.getMessage(session, "message.doc_scanning.updateSuccess");
    				} else {
    					errorMessage = MessageResources.getMessage(session, "message.doc_scanning.updateFail");
    				}
    				
    				updateAction = false;	
    			} else if (deleteAction) {
    				boolean deleteSuccess = false;
    				
    				deleteSuccess = CoDocscanDB.deleteCoDocscan(coDocscanId, userBean);
    				if(deleteSuccess) {
    					message = MessageResources.getMessage(session, "message.doc_scanning.deleteSuccess");
    				} else {
    					errorMessage = MessageResources.getMessage(session, "message.doc_scanning.deleteFail");
    				}
    				
    				deleteAction = false;	
    			}
    			step = null;
    		}
    		
    		//------------------------
    		// load data from database
    		//------------------------
    		if (!createAction && !"1".equals(step)) {
    			if (coDocscanId != null) {
    				coDocscan = CoDocscanDB.getCoDocscan(coDocscanId);
    			}
    		}
    		
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
    	
    	// ui logic
    	String commandType = null;
    	if (createAction) {
    		commandType = "create";
    	} else if (updateAction) {
    		commandType = "update";
    	} else if (deleteAction) {
    		commandType = "delete";
    	} else {
    		commandType = "view";
    	}
    	
    	String allowRemove = updateAction ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE;
    	
    	if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
    	if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
    	
    	Map<String, Object> model = new HashMap<String, Object>();
    	model.put("message", message);
    	model.put("errorMessage", errorMessage);
    	model.put("commandType", commandType);
    	model.put("createAction", createAction);
    	model.put("updateAction", updateAction);
    	model.put("deleteAction", deleteAction);
    	model.put("closeAction", closeAction);
    	model.put("allowRemove", allowRemove);
    	
    	model.put("moduleCode", DocscanModelHelper.MODULE_CODE);
    	model.put("parentCid", parentCid);
    	model.put("command", command);
    	model.put("level", level);
    	
    	model.put("userBean", userBean);
    	cid = cid == null ? "" : cid;
    	model.put("coDocscanId", cid);
    	model.put("coDocscan", coDocscan);
    	model.put("ancestors", ancestors);
    	
    	return new ModelAndView(VIEW_DOC_SCANNING_DETAIL, MODULE_NAME, model);
    }
    
    private void processUploadedDocument(HttpServletRequest request, CoDocscanId id, UserBean userBean) {
		String[] fileList = (String[]) request.getAttribute("filelist");
		if (fileList != null) {
			StringBuffer tempStrBuffer = new StringBuffer();

			tempStrBuffer.append(ConstantsServerSide.DOCUMENT_FOLDER);
			tempStrBuffer.append(UPLOAD_SUB_PATH);
			tempStrBuffer.append(File.separator);
			tempStrBuffer.append(id.getCoDocscanId());
			tempStrBuffer.append(File.separator);
			String baseUrl = tempStrBuffer.toString();

			tempStrBuffer.setLength(0);
			tempStrBuffer.append(UPLOAD_SUB_PATH);
			tempStrBuffer.append(File.separator);
			tempStrBuffer.append(id.getCoDocscanId());
			String webUrl = tempStrBuffer.toString();
			
			String documentID = null;
			for (int i = 0; i < fileList.length; i++) {
				FileUtil.moveFile(
					ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[i],
					baseUrl + fileList[i]
				);
				
				// add record to CO_DOCUMENT_GENERAL
				DocumentDB.delete(ConstantsServerSide.SITE_CODE, userBean, DocscanModelHelper.MODULE_CODE, id.getCoDocscanId().toString());
				documentID = DocumentDB.add(ConstantsServerSide.SITE_CODE, userBean, DocscanModelHelper.MODULE_CODE, id.getCoDocscanId().toString(), webUrl, fileList[i]);
				
				// insert CO_DOCSCAN
				CoDocscanDB.updateOrInsertCoDocscanDocument(id, new BigDecimal(documentID), userBean);
			}
		}
    }
    
    private void processUrl(HttpServletRequest request, CoDocscanId id, 
    		String url, UserBean userBean) {
		// insert or update CO_DOCSCAN_DOCUMENT
		CoDocscanDB.updateOrInsertCoDocscanDocument(id, url, userBean);
    }
    
    private void processFilePath(HttpServletRequest request, CoDocscanId id, 
    		String filePath, UserBean userBean) {
    	String folderPath = "";
    	String fileName = "";
    	if (filePath != null) {
    		String separator = "\\\\";
    		if (filePath.startsWith("/")) {
    			separator = "/";
    		}
    		String[] pathArray = filePath.split(separator);
    		if (pathArray != null && pathArray.length > 0) {
    			fileName = pathArray[pathArray.length - 1];
    			try {
    				folderPath = filePath.substring(0, filePath.indexOf(fileName) - 1);
    			} catch (Exception e) {
    			}
    		}
    	}
    	
		// add record to CO_DOCUMENT_GENERAL
		DocumentDB.delete(ConstantsServerSide.SITE_CODE, userBean, DocscanModelHelper.MODULE_CODE, id.getCoDocscanId().toString());
		String documentID = DocumentDB.add(ConstantsServerSide.SITE_CODE, userBean, DocscanModelHelper.MODULE_CODE, id.getCoDocscanId().toString(), folderPath, fileName);
		
		// insert or update CO_DOCSCAN_DOCUMENT
		CoDocscanDB.updateOrInsertCoDocscanDocument(id, new BigDecimal(documentID), userBean);
    }
}
