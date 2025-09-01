package com.hkah.server.servlet;

import java.io.IOException;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.hkah.server.services.CommonUtilServiceImpl;
import com.hkah.server.util.QueryUtil;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.util.UrlUtil;

public class AuthServlet extends HttpServlet implements ConstantsVariable {
	private static final long serialVersionUID = 1L;
	protected static Logger logger = Logger.getLogger(AuthServlet.class);

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		login(request, response, getComputerName(request));
	}

	private void postLogin(HttpServletRequest request, HttpServletResponse response,
			String loginCodeStr)
			throws ServletException, IOException {
		String targetUrl = null;

		String queryString = request.getQueryString();
		Map<String, Object> params = UrlUtil.encapUrlQueryParams(queryString);
		params.remove("action");
		params.remove("password");
		params.put("userID", request.getParameter("userID"));

		LoginCode loginCode = LoginCode.getLoginCodeByCode(loginCodeStr);
		loginCode = loginCode == null ? LoginCode.AUTH_ERR : loginCode;

		if (LoginCode.AUTH_SUCCESS.equals(loginCode)) {
			params.put("userID", request.getParameter("userID").toUpperCase());
			targetUrl = "HKAHNHS.html";
		} else {
			params.put("errCode", loginCode.getCode());
			targetUrl = "login.jsp";
		}

		if (!params.isEmpty()) {
			targetUrl += "?" + UrlUtil.formatQueryParams(params);
		}

		logger.debug("HKAHNHS Login AuthServlet sendRedirect to " + targetUrl);
		response.sendRedirect(targetUrl);
	}

	private void login(HttpServletRequest request, HttpServletResponse response,
			String computerName) throws ServletException, IOException {
		String userID = request.getParameter("userID");
		String password = request.getParameter("password");
		String sessionID = request.getParameter("sessionID");

		MessageQueue mq = QueryUtil.executeTx(null, "NHS", "ACT_LOGON",
				new String[] {
					userID,
					password,
					NO_VALUE,
					computerName,
					YES_VALUE,
					sessionID
				});
		if (mq.success() && mq.getContentField().length > 0) {
			postLogin(request, response, mq.getContentField()[0]);
		} else {
			postLogin(request, response, null);
		}
	}

	private String getComputerName(HttpServletRequest request) {
		String name = request.getRemoteHost();
		try {
			name = InetAddress.getByName(name).getCanonicalHostName();
			int index = name.toUpperCase().indexOf(CommonUtilServiceImpl.HKAH_DOMAIN);

			if (index > 0) {
				// remove domain suffix
				name = name.substring(0, index);
			}

			index = name.toUpperCase().indexOf(CommonUtilServiceImpl.TWAH_DOMAIN);

			if (index > 0) {
				// remove domain suffix
				name = name.substring(0, index);
			}
		} catch (UnknownHostException e) {
			e.printStackTrace();
		}
		return name;
	}
}