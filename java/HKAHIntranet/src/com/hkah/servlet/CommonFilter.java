package com.hkah.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

import com.hkah.web.db.AccessControlDB;

public class CommonFilter implements Filter {
	private static Logger logger = Logger.getLogger(CommonFilter.class);
	private static List<String> urlsAllow = new ArrayList<String>();
	private static String contextRoot = null;
	
	@Override
	public void destroy() {
	}

	@Override
	public void doFilter(ServletRequest req, ServletResponse res,
			FilterChain chain) throws IOException, ServletException {
		HttpServletRequest httpReq = (HttpServletRequest) req;
	    HttpServletResponse httpRes = (HttpServletResponse) res;
	    String url = httpReq.getRequestURI();
	    HttpSession sess = httpReq.getSession(false);
	    
	    if (sess != null) {
	    	//logger.info("sid="+sess.getId() +", PortalStatus="+AccessControlDB.getPortalStatus());
	    	if (AccessControlDB.isDisablePortalFunctions()) {
	    		if (!containsSubstring(url, urlsAllow)) {
		    		try {
		    			String id = sess.getId();
		    			sess.invalidate();
		    			logger.info("invalidate session id=" + id + ", for URL=" + url);
		    		} catch (IllegalStateException ex) {
		    			//logger.info(" already invalidated");
		    		}
		    		//logger.info(" sess invalidated");
	    		}
	    	}
	    }
	    chain.doFilter(req, res);
	}

	@Override
	public void init(FilterConfig arg0) throws ServletException {
		// TODO Auto-generated method stub
		ServletContext context = arg0.getServletContext();
		String cPath = context.getContextPath();
		contextRoot = cPath;
		logger.info("-- CommonFilter init -- contextRoot="+contextRoot);
		
		urlsAllow.add(cPath + "/index.jsp");
		urlsAllow.add(cPath + "/Logon.do");
		urlsAllow.add(cPath + "/Logoff.do");
		urlsAllow.add(cPath + "/common/");
		urlsAllow.add(cPath + "/portal/");
		urlsAllow.add(cPath + "/js/");
		urlsAllow.add(cPath + "/images/");
	}
	
	public boolean containsSubstring(String myString, List<String> keywords){
		   for(String keyword : keywords){
		      if(myString.contains(keyword) || (contextRoot + "/").equals(myString)){
		         return true;
		      }
		   }
		   return false;
	}

}
