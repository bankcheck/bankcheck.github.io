package com.hkah.web.controller;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;
import java.util.Vector;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils;
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
import com.hkah.web.db.AccessControlDB2;
import com.hkah.web.db.DocumentDB2;
import com.hkah.web.db.hibernate.CoDocument;
import com.hkah.web.db.hibernate.CoGroups;
import com.hkah.web.db.hibernate.CoUsers;

public class DocumentController extends AbstractController  {

    protected final Log logger = LogFactory.getLog(getClass());
    
    private String requestName;
    private static final String UPLOAD_SUB_PATH = "/Intranet/Portal/Documents";   
    	
    public ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	if ("document_list".equals(getRequestName()) ) {
    		return getDocumentList(request, response);
    	} else if ("document_details".equals(getRequestName()) ) {
    		return getDocumentDetails(request, response);
    	} else {
    		return null;
    	}
    }
    
    private ModelAndView getDocumentList(HttpServletRequest request, HttpServletResponse response) {
    	UserBean userBean = new UserBean(request);

    	String documentDescSearch = request.getParameter("documentDescSearch");
    	String documentNameLocSearch = request.getParameter("documentNameLocSearch");
    	
    	String command = request.getParameter("command");
    	String message = request.getParameter("message");
    	String errorMessage = request.getParameter("errorMessage");

    	List<CoDocument> coDocumentList = DocumentDB2.getCoDocumentList(1);
    	if ((documentDescSearch != null && documentDescSearch.length() > 0) ||
    			(documentNameLocSearch != null && documentNameLocSearch.length() > 0)) {
    		coDocumentList = DocumentDB2.getSearchCoDocumentList(documentDescSearch, documentNameLocSearch);
    	} else {
    		coDocumentList = DocumentDB2.getCoDocumentList(1);
    	}

    	if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
    	if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
    	
    	Map<String, Object> model = new HashMap<String, Object>();
    	model.put("message", message);
    	model.put("errorMessage", errorMessage);
    	model.put("userBean", userBean);
    	model.put("list", coDocumentList);
    	model.put("isAdmin", userBean.isAdmin());
    	model.put("pageSize", userBean.getNoOfRecPerPage());
    	model.put("documentDescSearch", documentDescSearch);
    	model.put("documentNameLocSearch", documentNameLocSearch);
    	
    	
    	return new ModelAndView("admin/document_list", "document", model);
    }
    
    public ModelAndView getDocumentDetails(HttpServletRequest request, HttpServletResponse response) {
    	boolean isFileUploaded = false;
    	boolean isMultiFileUploaded = false;
    	boolean isFilePathSpecified = false;
    	boolean isDirectoryPathSpecified = false;
    	Vector uploadMessageV = null;
    	String uploadMessage = null;
    	String[] filelist = null;
    	
    	if (HttpFileUpload.isMultipartContent(request)) {
    		// process file upload and parse multipart request parameters
    		uploadMessageV = uploadDocument(request);
    		
    		filelist = (String[]) request.getAttribute("filelist");
    		if (filelist != null && filelist.length > 0) {
    			isFileUploaded = true;
    			if (filelist.length > 1) {
    				isMultiFileUploaded = true;
    			}
    		}
    		
			ListIterator iter = uploadMessageV.listIterator();
			uploadMessage = "";
			String tempMessage = null;
			while (iter.hasNext()) {
				tempMessage = (String)iter.next();
				uploadMessage += tempMessage;
				if ("fail".indexOf(tempMessage.toLowerCase()) > 0) {
					isFileUploaded = false;
				}
			}
    	}

    	UserBean userBean = new UserBean(request);
    	HttpSession session = request.getSession();
    	String command = ParserUtil.getParameter(request, "command");
    	String documentID = ParserUtil.getParameter(request, "documentID");
    	String step = ParserUtil.getParameter(request, "step");
    	
    	String fileMethod = ParserUtil.getParameter(request, "fileMethod");
    	String filePath = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "filePath"));
    	String fileDirectory = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "fileDirectory"));
    	String filePrefix = ParserUtil.getParameter(request, "filePrefix");
    	String fileSuffix = ParserUtil.getParameter(request, "fileSuffix");
    	isFilePathSpecified = "filePath".equals(fileMethod);
    	isDirectoryPathSpecified = "fileDirectory".equals(fileMethod);
    	String isMultiFileInWebFolder = ParserUtil.getParameter(request, "isMultiFileInWebFolder");
    	if (isMultiFileInWebFolder != null && "Y".equals(isMultiFileInWebFolder)) {
    		isMultiFileUploaded = true;
    	}
    	
    	String documentDesc = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "documentDesc"));
    	String[] groupIDs = (String[]) request.getAttribute("groupID_StringArray");
    	String[] userIDs = (String[]) request.getAttribute("userID_StringArray");
    	
    	BigDecimal documentID_BD;
    	try {
    		documentID_BD = BigDecimal.valueOf(Long.parseLong(documentID));
    	} catch (Exception e) {
    		documentID_BD = new BigDecimal(-1);
    	}
    	
    	String message = ParserUtil.getParameter(request, "message");
    	String errorMessage = ParserUtil.getParameter(request, "errorMessage");

    	CoDocument coDocument = null;
    	List<CoGroups> coGroupsList = null;
    	List<CoGroups> coGroupsSelectedList = null;
    	List<CoUsers> coUsersList = null;
    	List<CoUsers> coUsersSelectedList = null;
    	List<String> subFileNames = null;
    	
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
    			// Must append docment ID as a subfolder at the end before using
				String basePath = ConstantsServerSide.DOCUMENT_FOLDER + UPLOAD_SUB_PATH;
				String webPath = UPLOAD_SUB_PATH;
    			
    			if (createAction) {
    				boolean insertAccessControlSuccess = false;
    				
    				if (isFileUploaded || isFilePathSpecified || isDirectoryPathSpecified) {
    					// Add new document record
	    				documentID_BD = DocumentDB2.addCoDocument(documentDesc, true, " ", userBean);
	    				if (documentID_BD != null) {
	    					basePath += "/" + documentID_BD.toString();
	    					webPath += "/" + documentID_BD.toString();
	    					
		    				if (isFileUploaded) {
			    				// Move uploaded file to correct folder and update location
			    				moveDocument(request, documentID_BD, basePath, webPath, userBean);
		    					
			    				if (isMultiFileUploaded) {
			    					// Update location without filename, can specify file prefix and suffix
			    					DocumentDB2.updateLocation(documentID_BD, documentDesc, webPath , "Y", "N", filePrefix, fileSuffix, userBean);
			    				} else {
			    					// Update location including a particular filename
			    					String fileName = (filelist != null && filelist.length > 0) ? "/" + filelist[0] : "";
			    					DocumentDB2.updateLocation(documentID_BD, documentDesc, webPath + fileName , "Y", "Y", null, null, userBean);
			    				}
			    				
		    					message = uploadMessage;
		    				} else if (isFilePathSpecified) {
		    					// Update lcoation only, no files were uploaded
		    					DocumentDB2.updateLocation(documentID_BD, documentDesc, filePath, "N", userBean);
		    				} else if (isDirectoryPathSpecified) {
		    					// Update lcoation only, no files were uploaded
		    					DocumentDB2.updateLocation(documentID_BD, documentDesc, fileDirectory, "N", "N", filePrefix, fileSuffix, userBean);
		    				}
		    				
		    				insertAccessControlSuccess = insertAccessControlRecords(documentID_BD, userBean, groupIDs, userIDs);
		    				if (insertAccessControlSuccess) {
		    					message = MessageResources.getMessage(session, "message.document.createSuccess");
		    				} else {
		    					errorMessage = MessageResources.getMessage(session, "message.accessControl.updateFail");
		    				}
		    				
	    				} else {
	    					errorMessage = MessageResources.getMessage(session, "message.document.createFail");
	    				}
    				} else {
    					errorMessage = MessageResources.getMessage(session, "message.document.createFail");
    				}
					
    				createAction = false;
    			} else if (updateAction) {
    				boolean updateSuccess = false;
					basePath += "/" + documentID_BD.toString();
					webPath += "/" + documentID_BD.toString();
					
       				if (isFileUploaded) {
	    				// Move uploaded file to correct folder and update location
	    				moveDocument(request, documentID_BD, basePath, webPath, userBean);
    					
	    				if (isMultiFileUploaded) {
	    					// Update location without filename, can specify file prefix and suffix
	    					updateSuccess = DocumentDB2.updateLocation(documentID_BD, documentDesc, webPath , "Y", "N", filePrefix, fileSuffix, userBean);
	    				} else {
	    					// Update location including a particular filename
	    					String fileName = (filelist != null && filelist.length > 0) ? "/" + filelist[0] : "";
	    					updateSuccess = DocumentDB2.updateLocation(documentID_BD, documentDesc, webPath + fileName , "Y", "Y", null, null, userBean);
	    				}
    				} else if (isFilePathSpecified) {
    					// Update lcoation only, no files were uploaded
    					updateSuccess = DocumentDB2.updateLocation(documentID_BD, documentDesc, filePath, "N", userBean);
    				} else if (isDirectoryPathSpecified) {
    					// Update lcoation only, no files were uploaded
    					updateSuccess = DocumentDB2.updateLocation(documentID_BD, documentDesc, fileDirectory, "N", "N", filePrefix, fileSuffix, userBean);
    				} else {
    					// File(s) already in web folder and no file(s) is/are added, location remains unchanged
	    				if (isMultiFileUploaded) {
	    					// Update location without filename, can specify file prefix and suffix
	    					updateSuccess = DocumentDB2.updateLocation(documentID_BD, documentDesc, webPath , "Y", "N", filePrefix, fileSuffix, userBean);
	    				} else {
	    					// Update location including a particular filename
	    					String fileName = (filelist != null && filelist.length > 0) ? "/" + filelist[0] : "";
	    					updateSuccess = DocumentDB2.updateDescription(documentID_BD, documentDesc, userBean);
	    				}
    				}
    				
    				if(updateSuccess) {
    					updateSuccess = insertAccessControlRecords(documentID_BD, userBean, groupIDs, userIDs);
    					
    					if (updateSuccess)
    						message = MessageResources.getMessage(session, "message.document.updateSuccess");
    					else
    						errorMessage = MessageResources.getMessage(session, "message.document.updateFail");
    						
    				} else {
    					errorMessage = MessageResources.getMessage(session, "message.document.updateFail");
    				}
    				
    				updateAction = false;
    			} else if (deleteAction) {
    				if(DocumentDB2.deleteCoDocument(documentID_BD, userBean)) {
    					message = MessageResources.getMessage(session, "message.document.deleteSuccess");
    				} else {
    					errorMessage = MessageResources.getMessage(session, "message.document.deleteFail");
    				}
    				deleteAction = false;
    			}
    			
    			step = null;
    		}

    		//------------------------
    		// load data from database
    		//------------------------
    		if (!createAction && !"1".equals(step)) {
    			String fileFullPath = null;
    			
    			if (documentID_BD != null) {
    				coDocument = DocumentDB2.getCoDocument(documentID_BD, 1);
    				if (coDocument != null) {
    					// get access info
    					coGroupsSelectedList = AccessControlDB2.getCoDocumentSelectedCoGroupsList(documentID_BD, 1);
    					coUsersSelectedList = AccessControlDB2.getSelectedCoUsersList(documentID_BD);
    					
    					// get list of all files with matched file prefix and suffix
    					if ("N".equals(coDocument.getCoLocationWithFilename())) {
    						if ("Y".equals(coDocument.getCoWebFolder())) {
    							fileFullPath = ConstantsServerSide.DOCUMENT_FOLDER + coDocument.getCoLocation();
    						} else {
    							fileFullPath = coDocument.getCoLocation();
    						}
    						subFileNames = listFiles(fileFullPath, coDocument.getCoFilePrefix(), coDocument.getCoFileSuffix());
    						coDocument.setSubFileNames(subFileNames);
    					}
    					
    					// Set document location type
    					/* There are 4 types of document location
    					 * 								|	CO_WEB_FOLDER		CO_LOCATION_WITH_FILENAME
    					 * ---------------------------------------------------------------------------
    					 * 1a. Upload to web folder		|	Y					Y
    					 * 1b. Upload to web folder		|	Y					N
    					 *      (multiple files)		|						
    					 * 2.  Set file path only		|	N					Y
    					 * 3.  Set directory path		|	N					N
    					 *      (allow multiple files)	|
    					 * 
    					 */
    					if ("Y".equals(coDocument.getCoLocationWithFilename())) {
    						if ("N".equals(coDocument.getCoWebFolder())) {
        						isFileUploaded = false;
        						isMultiFileUploaded = false;
        						isFilePathSpecified = true;
        						isDirectoryPathSpecified = false;
    						} else {
        						isFileUploaded = true;
        						isFilePathSpecified = false;
        						isDirectoryPathSpecified = false;
    						}
    					} else {
    						if ("Y".equals(coDocument.getCoWebFolder())) {
	    						isFileUploaded = false;
	    						isMultiFileUploaded = true;
	    						isFilePathSpecified = false;
	    						isDirectoryPathSpecified = false;
    						} else {
	    						isFileUploaded = false;
	    						isMultiFileUploaded = false;
	    						isFilePathSpecified = false;
	    						isDirectoryPathSpecified = true;
    						}
    					}
    				} else {
    					// closeAction = true;
    				}
    			} else {
    				// closeAction = true;
    			}
    		}
    		
    		// load access info list
    		coGroupsList = AccessControlDB2.getCoGroupsList(1);
    		coUsersList = AccessControlDB2.getCoUsersList(userBean);
    	} catch (Exception e) {
    		e.printStackTrace();
    	}

    	// ui logic
    	String title = null;
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
    	// set submit label
    	title = "function.document." + commandType;

    	String allowRemove = updateAction ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE;
    	
    	if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
    	if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
    	
    	Map<String, Object> model = new HashMap<String, Object>();
    	model.put("title", title);
    	model.put("message", message);
    	model.put("errorMessage", errorMessage);
    	model.put("commandType", commandType);
    	model.put("createAction", createAction);
    	model.put("updateAction", updateAction);
    	model.put("deleteAction", deleteAction);
    	model.put("closeAction", closeAction);
    	model.put("userBean", userBean);
    	documentID = documentID == null ? "" : documentID;
    	model.put("documentID", documentID);
    	model.put("allowRemove", allowRemove);
    	model.put("coDocument", coDocument);
    	model.put("coGroupsList", coGroupsList);
    	model.put("coGroupsSelectedList", coGroupsSelectedList);
    	model.put("coUsersList", coUsersList);
    	model.put("coUsersSelectedList", coUsersSelectedList);
    	model.put("isFileUploaded", isFileUploaded);
    	model.put("isMultiFileUploaded", isMultiFileUploaded);
    	model.put("isFilePathSpecified", isFilePathSpecified);
    	model.put("isDirectoryPathSpecified", isDirectoryPathSpecified);
    	
    	return new ModelAndView("admin/document_details", "document", model);
    }
    
    private boolean insertAccessControlRecords(BigDecimal documentID_BD, UserBean userBean,
    		String[] groupIDs, String[] userIDs) {
		boolean insertSuccess = true;
		int accessControlInserted = 0;
		
		AccessControlDB2.deleteAcDocumentAccess(documentID_BD, userBean);
		// update access control list (group and user)
		if (groupIDs != null || userIDs != null) {
			accessControlInserted = AccessControlDB2.addAcDocumentAccess(documentID_BD, groupIDs, userIDs, userBean);
			
			// check if number of records inserted is correct
			if (accessControlInserted != 
				(groupIDs != null ? groupIDs.length : 0) + (userIDs != null ? userIDs.length : 0)) {
				insertSuccess = false;
			} 
		}
		return insertSuccess;
    }
    
    private List<String> listFiles(String path, String prefix, String suffix) {
    	// remove the extension separator before passing into FileUtils.iterateFiles
    	String[] suffixArray = null;
    	if (suffix != null) {
    		if (".".equals(suffix.substring(0, 1))) 
    			suffix = suffix.substring(1);
    		suffixArray = new String[]{suffix};
		}
    	
    	List<String> fileList = null;
    	File file = null;
    	Iterator<File> fileIterator = null;
    	String fileName = null;
    	boolean isMatched = false;
    	
    	try {
    		fileIterator = FileUtils.iterateFiles(new File(path), suffixArray, false);
    		if (fileIterator != null) {
    			while (fileIterator.hasNext()) {
    				file = fileIterator.next();
    				isMatched = false;
    				
    				if (file != null && file.isFile()) {
    					fileName = file.getName();
    					// check prefix
    					if (prefix != null) {
    						if (fileName != null && fileName.startsWith(prefix))
    							isMatched = true;
    					} else {
    						isMatched = true;
    					}
    					
    					if (isMatched) {
    						fileList = fileList == null ? (fileList = new ArrayList<String>()) : fileList;
    						fileList.add(fileName);
    					}
    				}
    			}
    			
    		}
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
    	
    	return fileList;
    }
    
    private void moveDocument(HttpServletRequest request, BigDecimal documentID, String baseUrl, String webUrl, UserBean userBean) {
		String[] fileList = (String[]) request.getAttribute("filelist");
		if (fileList != null) {
			for (int i = 0; i < fileList.length; i++) {
				FileUtil.moveFile(
					ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[i],
					baseUrl + "/" + fileList[i]
				);
			}
		}
    }
    
    private Vector uploadDocument(HttpServletRequest request) {
    	Vector messages = HttpFileUpload.toUploadFolder(
    			request,
    			ConstantsServerSide.DOCUMENT_FOLDER,
    			ConstantsServerSide.TEMP_FOLDER,
    			ConstantsServerSide.UPLOAD_FOLDER
    		);
		return messages;
    }
    
	public String getRequestName() {
		return requestName;
	}

	public void setRequestName(String requestName) {
		this.requestName = requestName;
	}

}
