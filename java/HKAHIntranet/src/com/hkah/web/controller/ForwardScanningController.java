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

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.hkah.config.MessageResources;
import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.util.ParserUtil;
import com.hkah.util.TextUtil;
import com.hkah.util.upload.HttpFileUpload;
import com.hkah.web.common.UserBean;
import com.hkah.web.db.ForwardScanningDB;
import com.hkah.web.db.helper.FsModelHelper;
import com.hkah.web.db.model.FsCategory;

public class ForwardScanningController extends AbstractController {
	protected final Log logger = LogFactory.getLog(getClass());

	public static final String MODULE_NAME = "forwardScanning";

	public static final String VIEW_FS_CATEGORY_LIST = MODULE_NAME
			+ "/category_list";
	public static final String VIEW_FS_CATEGORY_DETAIL = MODULE_NAME
			+ "/category_detail";
	private static final String UPLOAD_SUB_PATH = File.separator + "Intranet"
			+ File.separator + "Portal" + File.separator + "Forward Scanning";

	private String requestName;

	public String getRequestName() {
		return requestName;
	}

	public void setRequestName(String requestName) {
		this.requestName = requestName;
	}

	public ModelAndView handleRequestInternal(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		if ("category_list".equals(getRequestName())) {
			return getFsCategoryList(request, response);
		} else if ("category_detail".equals(getRequestName())) {
			return getFsCategoryDetails(request, response);
		} else {
			return null;
		}
	}

	private ModelAndView getFsCategoryList(HttpServletRequest request,
			HttpServletResponse response) {
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

		List<FsCategory> fsCategoryList = null;
		List<FsCategory> ancestors = null;

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
						for (String order : contentOrder) {
							try {
								contentOrder_BD[i] = new BigDecimal(order);
							} catch (NumberFormatException nfe) {
								contentOrder_BD[i] = null;
							}
							i++;
						}

						if (ForwardScanningDB.updateFsCategorySortOrder(
								contentOrder_BD, userBean)) {
							message = MessageResources
									.getMessage(session,
											"message.fs.category.displayOrderUpdateSuccess");
						} else {
							errorMessage = MessageResources
									.getMessage(session,
											"message.fs.category.displayOrderUpdateFail");
						}
					} else {
						errorMessage = MessageResources.getMessage(session,
								"message.fs.category.displayOrderNoChange");
					}
					updateSortOrderAction = false;
				}
				step = null;
			}

			fsCategoryList = FsModelHelper
					.getFsCategoryModels(ForwardScanningDB
							.getCategoryListByParentId(cid_BD));

			// get an ancestor list for breadcrumb navigation, limit to max 5
			// level only
			ancestors = ForwardScanningDB.getFsCategoryAncestors(cid_BD, 5);

			// set hierarchy level info
			parentCid = null;
			if (ancestors != null && ancestors.size() > 0) {
				FsCategory parent = ancestors.get(ancestors.size() - 1);
				parentCid = parent.getFsCategoryId_String();
			}
			grandCid = null;
			if (ancestors != null && ancestors.size() > 1) {
				FsCategory grand = ancestors.get(ancestors.size() - 2);
				grandCid = grand.getFsCategoryId_String();
			}
			if (ancestors != null) {
				level = String.valueOf(ancestors.size());
			} else {
				level = String.valueOf(0);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		if (message == null) {
			message = ConstantsVariable.EMPTY_VALUE;
		}
		if (errorMessage == null) {
			errorMessage = ConstantsVariable.EMPTY_VALUE;
		}

		Map<String, Object> model = new HashMap<String, Object>();
		model.put("message", message);
		model.put("errorMessage", errorMessage);

		model.put("command", command);
		model.put("level", level);
		model.put("grandCid", grandCid);
		model.put("parentCid", parentCid);

		model.put("userBean", userBean);
		model.put("list", fsCategoryList);
		model.put("ancestors", ancestors);

		return new ModelAndView(VIEW_FS_CATEGORY_LIST, MODULE_NAME, model);
	}

	private ModelAndView getFsCategoryDetails(HttpServletRequest request,
			HttpServletResponse response) {
		boolean fileUpload = false;
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

		String fsName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,
				"fsName"));
		String fsIsMulti = TextUtil.parseStrUTF8(ParserUtil.getParameter(
				request, "fsIsMulti"));
		String fsSeq = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,
				"fsSeq"));

		String message = request.getParameter("message");
		String errorMessage = request.getParameter("errorMessage");

		BigDecimal fsCategoryId = null;
		try {
			fsCategoryId = new BigDecimal(cid);
		} catch (Exception e) {
			fsCategoryId = new BigDecimal(-1);
		}
		BigDecimal fsParentCategoryId = null;
		try {
			fsParentCategoryId = new BigDecimal(parentCid);
		} catch (Exception e) {
		}

		FsCategory fsCategory = null;
		List<FsCategory> ancestors = null;

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
				// construct model
				fsCategory = new FsCategory(fsCategoryId, fsName,
						fsParentCategoryId, fsSeq, fsIsMulti);

				if (createAction) {
					boolean createSuccess = false;

					fsCategory = ForwardScanningDB.addFsCategory(userBean,
							fsCategory);
					if (fsCategory != null) {
						createSuccess = true;
						fsCategoryId = fsCategory.getFsCategoryId();
						cid = fsCategory.getFsCategoryId_String();
					}

					if (createSuccess) {
						message = MessageResources.getMessage(session,
								"message.fs.category.createSuccess");
					} else {
						errorMessage = MessageResources.getMessage(session,
								"message.fs.category.createFail");
					}

					createAction = false;
				} else if (updateAction) {
					boolean updateSuccess = false;

					fsCategory = ForwardScanningDB.updateFsCategory(userBean,
							fsCategory);
					if (fsCategory != null) {
						updateSuccess = true;
					}

					if (updateSuccess) {
						message = MessageResources.getMessage(session,
								"message.fs.category.updateSuccess");
					} else {
						errorMessage = MessageResources.getMessage(session,
								"message.fs.category.updateFail");
					}

					updateAction = false;
				} else if (deleteAction) {
					boolean deleteSuccess = ForwardScanningDB.deleteFsCategory(
							userBean, cid);
					if (deleteSuccess) {
						message = MessageResources.getMessage(session,
								"message.fs.category.deleteSuccess");
					} else {
						errorMessage = MessageResources.getMessage(session,
								"message.fs.category.deleteFail");
					}

					deleteAction = false;
				}
				step = null;
			}

			// ------------------------
			// load data from database
			// ------------------------
			if (!createAction && !"1".equals(step)) {
				if (fsCategoryId != null) {
					fsCategory = FsModelHelper.getFsCategory(fsCategoryId);
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
		String pageTitle = "function.fs.category." + commandType;

		String allowRemove = updateAction ? ConstantsVariable.YES_VALUE
				: ConstantsVariable.NO_VALUE;

		if (message == null) {
			message = ConstantsVariable.EMPTY_VALUE;
		}
		if (errorMessage == null) {
			errorMessage = ConstantsVariable.EMPTY_VALUE;
		}

		Map<String, Object> model = new HashMap<String, Object>();
		model.put("message", message);
		model.put("errorMessage", errorMessage);
		model.put("commandType", commandType);
		model.put("pageTitle", pageTitle);

		model.put("createAction", createAction);
		model.put("updateAction", updateAction);
		model.put("deleteAction", deleteAction);
		model.put("closeAction", closeAction);
		model.put("allowRemove", allowRemove);

		model.put("moduleCode", FsModelHelper.MODULE_CODE);
		model.put("parentCid", parentCid);
		model.put("command", command);
		model.put("level", level);

		model.put("userBean", userBean);
		cid = cid == null ? "" : cid;
		model.put("categoryId", cid);
		model.put("fsCategory", fsCategory);
		model.put("ancestors", ancestors);
		
		System.out.println("DEBUG: updateAction="+updateAction+", cid="+cid);

		return new ModelAndView(VIEW_FS_CATEGORY_DETAIL, MODULE_NAME, model);
	}

}
