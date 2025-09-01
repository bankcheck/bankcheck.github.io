package com.hkah.server.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hkah.server.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.UserInfo;

public class UserSignOffServlet extends HttpServlet {
	/**
	 *
	 */
	private static final long serialVersionUID = -993848582310227519L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		this.doPost(req , resp) ;
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) {
		//release rlock and cashier
		String usrid = request.getParameter("uid");
		String cshcode = request.getParameter("cid");
		String computername = request.getParameter("cn");

		MessageQueue pathMQueue = QueryUtil.proceedTx(
				new UserInfo(), "NHS",
				ConstantsTx.SIGNOFF_TXCODE,
				QueryUtil.getMasterServlet(),
				QueryUtil.ACTION_APPEND,
				new String[] { usrid, cshcode, computername },
				null, null, QueryUtil.getJndiName());
		
		// remove sso session
		String ssosid = request.getParameter("ssosid");
		String ssomcode = request.getParameter("ssomcode");
		
		QueryUtil.proceedTx(
				new UserInfo(), "NHS",
				ConstantsTx.LOGON_SSO_TXCODE,
				QueryUtil.getMasterServlet(),
				QueryUtil.ACTION_DELETE,
				new String[] { usrid, null, ssomcode, ssosid },
				null, null, QueryUtil.getJndiName());
	}
}